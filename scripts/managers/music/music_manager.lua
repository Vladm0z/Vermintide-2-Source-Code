-- chunkname: @scripts/managers/music/music_manager.lua

require("scripts/settings/music_settings")
require("scripts/managers/music/music_player")

local function dprint(...)
	-- function 1
	if script_data.debug_music then
		print("[MusicManager] ", ...)
	end
end

MusicManager = class(MusicManager)
MusicManager.bus_transition_functions = {
	linear = function (transition, t)
		-- function 2
		return math.lerp(transition.start_value, transition.target_value, t)
	end,
	sine = function (transition, t)
		-- function 3
		return math.lerp(transition.start_value, transition.target_value, math.sin(t * math.pi * 0.5))
	end,
	smoothstep = function (transition, t)
		-- function 4
		return math.lerp(transition.start_value, transition.target_value, math.smoothstep(t, 0, 1))
	end
}
MusicManager.panning_rules = {
	PANNING_RULE_SPEAKERS = 0,
	PANNING_RULE_HEADPHONES = 1
}

MusicManager.init = function (self)
	-- function 5
	dprint("init")

	if GLOBAL_MUSIC_WORLD then
		self._world = MUSIC_WORLD
		self._wwise_world = MUSIC_WWISE_WORLD
	else
		self._world = Managers.world:create_world("music_world", nil, nil, nil, Application.DISABLE_PHYSICS, Application.DISABLE_RENDERING)
		self._wwise_world = Managers.world:wwise_world(self._world)

		ScriptWorld.deactivate(self._world)
	end

	self._music_players = {}
	self._duck_sounds_stack = 0

	self:_update_window_focus()

	self._bus_transitions = {}
	self._flags = {}
	self._game_states = {}
	self._game_object_id = nil
	self._group_states = {}
	self._scream_delays = {}
	self._current_horde_sound_settings = {}
	self._event_queues = {}

	local master_bus_volume = Application.user_setting("master_bus_volume")

	if master_bus_volume ~= nil then
		self:set_master_volume(master_bus_volume)
	end

	local music_bus_volume = Application.user_setting("music_bus_volume")

	if music_bus_volume ~= nil then
		self:set_music_volume(music_bus_volume)
	end

	local sound_panning_rule = Application.user_setting("sound_panning_rule")

	if sound_panning_rule ~= nil then
		local rule = sound_panning_rule ~= "headphones" and "PANNING_RULE_SPEAKERS" or not (sound_panning_rule ~= "headphones") and "PANNING_RULE_HEADPHONES"

		self:set_panning_rule(rule)
	end

	local sound_channel_configuration = Application.user_setting("sound_channel_configuration")

	if not DEDICATED_SERVER then
		Wwise.set_bus_config("ingame_mastering_channel", sound_channel_configuration)
	end
end

MusicManager.duck_sounds = function (self)
	-- function 6
	if self._duck_sounds_stack == 0 then
		self:trigger_event("hud_in_inventory_state_on")
	end

	self._duck_sounds_stack = self._duck_sounds_stack + 1
end

MusicManager.unduck_sounds = function (self, forced)
	-- function 7
	if self._duck_sounds_stack == 1 or forced then
		self:trigger_event("hud_in_inventory_state_off")
	end

	self._duck_sounds_stack = forced and 0 or not forced and math.max(0, self._duck_sounds_stack - 1)
end

MusicManager._update_window_focus = function (self)
	-- function 8
	if not DEDICATED_SERVER then
		local has_focus = Window.has_focus()

		if has_focus ~= self._has_focus then
			if has_focus then
				self:trigger_event("unmute_all")
			elseif Application.user_setting("mute_in_background") then
				self:trigger_event("mute_all")
			end

			self._has_focus = has_focus
		end
	end
end

MusicManager.stop_all_sounds = function (self)
	-- function 9
	dprint("stop_all_sounds")
	self._wwise_world:stop_all()
end

MusicManager.stop_event_id = function (self, event_id)
	-- function 10
	dprint("stop_event_id")

	if self._wwise_world:is_playing(event_id) then
		self._wwise_world:stop_event(event_id)
	end
end

MusicManager.trigger_event = function (self, event_name)
	-- function 11
	dprint("trigger_event", event_name)

	local wwise_world = self._wwise_world
	local wwise_playing_id, wwise_source_id = WwiseWorld.trigger_event(wwise_world, event_name)

	dprint("MUSIC MANAGER", event_name, wwise_playing_id, wwise_source_id)

	return wwise_playing_id, wwise_source_id
end

MusicManager.trigger_event_queue = function (self, event_queue_name, event_queue, delay)
	-- function 12
	fassert(not self._event_queues[event_queue_name], "[MusicManager:trigger_event_queue] There is already an event queue playing with that name")

	local event_index = 1
	local first_event = event_queue[1]
	local wwise_playing_id, wwise_source_id = self:trigger_event(first_event)

	self._event_queues[event_queue_name] = {
		delay = delay or 0.5,
		event_index = event_index,
		wwise_playing_id = wwise_playing_id,
		wwise_source_id = wwise_source_id,
		event_queue = event_queue
	}
end

MusicManager.update = function (self, dt, t)
	-- function 13
	local conflict_director = Managers.state.conflict

	if conflict_director then
		if self._is_server then
			self:_update_flag_in_combat(conflict_director)
			self:_update_combat_intensity(conflict_director)
			self:_update_boss_state(conflict_director)
			self:_update_game_state(dt, t, conflict_director)
		end

		self:_update_boss_state(conflict_director)

		if not DEDICATED_SERVER then
			self:_update_boss_music_intensity(conflict_director)
		end
	end

	if not DEDICATED_SERVER then
		self:_update_player_state(dt, t)
		self:_update_career_state(dt, t)
		self:_update_enemy_aggro_state(dt, t)
		self:_update_game_mode(dt, t)
		self:_update_side_state(dt, t)
		self:_update_window_focus()
	end

	self:_update_flags()
	self:_handle_event_queues(dt, t)

	local flags = self._flags

	for _, player in pairs(self._music_players) do
		player:update(flags, self._game_object_id, self._is_ingame)
	end
end

local EVENT_QUEUS_TO_REMOVE = {}

MusicManager._handle_event_queues = function (self, dt, t)
	-- function 14
	table.clear(EVENT_QUEUS_TO_REMOVE)

	for event_queue_name, event_queue_data in pairs(self._event_queues) do
		local wwise_playing_id = event_queue_data.wwise_playing_id

		if not self:is_playing(wwise_playing_id) then
			if not event_queue_data.current_delay then
				event_queue_data.current_delay = t + event_queue_data.delay
			elseif t > event_queue_data.current_delay then
				local event_queue = event_queue_data.event_queue
				local new_index = event_queue_data.event_index + 1
				local new_event = event_queue[new_index]

				if new_event then
					local wwise_playing_id, wwise_source_id = self:trigger_event(new_event)

					event_queue_data.event_index = new_index
					event_queue_data.wwise_playing_id = wwise_playing_id
					event_queue_data.wwise_source_id = wwise_source_id
					event_queue_data.current_delay = nil
				else
					EVENT_QUEUS_TO_REMOVE[#EVENT_QUEUS_TO_REMOVE + 1] = event_queue_name
				end
			end
		end
	end

	for _, event_queue_name in ipairs(EVENT_QUEUS_TO_REMOVE) do
		self:stop_event_queue(event_queue_name)
	end
end

MusicManager.stop_event_queue = function (self, event_queue_name)
	-- function 15
	local event_queue_data = self._event_queues[event_queue_name]

	if not event_queue_data then
		return
	end

	local wwise_playing_id = event_queue_data.wwise_playing_id

	if self:is_playing(wwise_playing_id) then
		self:stop_event_id(wwise_playing_id)
	end

	self._event_queues[event_queue_name] = nil
end

MusicManager.destroy = function (self)
	-- function 16
	dprint("DESTROY")

	if not GLOBAL_MUSIC_WORLD then
		Application.release_world(self._world)
	end

	self:_unregister_events()
end

MusicManager.on_enter_level = function (self, network_event_delegate, is_server)
	-- function 17
	dprint("on_enter_level")

	self._network_event_delegate = network_event_delegate

	if is_server then
		local go_type = NetworkLookup.go_types.music_states
		local intensity_state_id = NetworkLookup.music_group_states.low_battle
		local game_state_id = NetworkLookup.music_group_states.explore
		local boss_state_id = NetworkLookup.music_group_states.no_boss
		local dwarf_fest_dlc_state_id = NetworkLookup.music_group_states.None
		local is_weave = Managers.mechanism:game_mechanism():get_state() == "weave"
		local override_state_id = is_weave and NetworkLookup.music_group_states.winds or not is_weave and NetworkLookup.music_group_states["false"]
		local init_data = {
			go_type = go_type,
			combat_intensity = intensity_state_id,
			boss_state = boss_state_id,
			override = override_state_id,
			dlc_dwarf_fest = dwarf_fest_dlc_state_id
		}

		if self._override_init_fields then
			for group, state in pairs(self._override_init_fields) do
				local state_id = NetworkLookup.music_group_states[state]

				init_data[group] = state_id
			end

			self._override_init_fields = nil
		end

		local parties = Managers.party:parties()
		local game_states = {}

		for _, party in pairs(parties) do
			game_states[party.party_id] = game_state_id
		end

		init_data.game_state = game_states
		self._game_states = game_states

		local session = Managers.state.network.game_session

		fassert(not self._game_object_id, "Creating game object when already exists")

		self._game_object_id = Managers.state.network:create_game_object("music_states", init_data, function (game_object_id)
			-- function 18
			self:server_game_session_disconnect_music_states(game_object_id)
		end)
	end

	self:_setup_level_music_players()
	self:set_flag("in_level", true)

	self._is_server = is_server
	self.last_man_standing = false
	self._party_manager = Managers.party
	self._side_manager = Managers.state.side

	self:_register_events()
end

MusicManager.on_exit_level = function (self)
	-- function 19
	dprint("on_exit_level")
	self:set_flag("in_level", false)
	self:set_flag("in_combat", false)
	self:_reset_level_music_players()
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._is_server = false
	self.last_man_standing = false

	self:_unregister_events()
end

MusicManager._register_events = function (self)
	-- function 20
	local event_manager = Managers.state.event

	if not event_manager then
		return
	end

	event_manager:register(self, "player_party_changed", "on_player_party_changed")
	event_manager:register(self, "versus_pre_start_initialized", "versus_update_sides")
end

MusicManager._unregister_events = function (self)
	-- function 21
	local event_manager = Managers.state.event

	if not event_manager then
		return
	end

	event_manager:unregister("player_party_changed", self)
	event_manager:unregister("versus_pre_start_initialized", self)
end

MusicManager.client_game_session_disconnect_music_states = function (self, game_object_id)
	-- function 22
	return
end

MusicManager.server_game_session_disconnect_music_states = function (self, game_object_id)
	-- function 23
	self:game_object_destroyed(game_object_id, self._owner_id, self._go_template)
end

MusicManager.game_object_created = function (self, game_object_id, owner_id, go_template)
	-- function 24
	dprint("game_object_created")

	self._game_object_id = game_object_id
	self._owner_id = owner_id
	self._go_template = go_template
end

MusicManager.game_object_destroyed = function (self, game_object_id, owner_id, go_template)
	-- function 25
	dprint("game_object_destroyed")
	Application.warning("[MusicManager:game_object_destroyed] Removed go_template == self._go_template check due to crash")

	self._game_object_id = nil
	self._owner_id = nil
	self._go_template = nil
end

MusicManager._update_flags = function (self)
	-- function 26
	self:set_flag("combat_music_enabled", not script_data.debug_disable_combat_music)

	local game_object_id = self._game_object_id

	if self._is_server or not game_object_id then
		return
	end

	local session = Managers.state.network:game()

	for flag, _ in pairs(SyncedMusicFlags) do
		local value = GameSession.game_object_field(session, game_object_id, flag)

		self:set_flag(flag, value)
	end
end

MusicManager.set_flag = function (self, flag, value)
	-- function 27
	if self._flags[flag] == value then
		return
	end

	dprint("set_flag", flag, value)

	self._flags[flag] = value

	if self._is_server and SyncedMusicGroupFlags[flag] then
		local session = Managers.state.network:game()

		GameSession.set_game_object_field(session, self._game_object_id, flag, value)
	end
end

MusicManager._setup_level_music_players = function (self)
	-- function 28
	dprint("_setup_level_music_players")

	local music_configs = MusicSettings

	for config_name, config in pairs(music_configs) do
		if config.ingame_only then
			local start = config.start_event
			local stop = config.stop
			local set_flags = config.set_flags
			local unset_flags = config.unset_flags
			local parameters = config.parameters
			local groups = config.default_group_states
			local game_state_voice_thresholds = config.game_state_voice_thresholds
			local player = MusicPlayer:new(self._wwise_world, start, stop, config_name, set_flags, unset_flags, parameters, groups, game_state_voice_thresholds)

			self._music_players[config_name] = player
		end
	end
end

MusicManager._reset_level_music_players = function (self)
	-- function 29
	dprint("_reset_level_music_players")

	local music_configs = MusicSettings

	for config_name, config in pairs(music_configs) do
		if config.ingame_only then
			local player = self._music_players[config_name]

			if player then
				player:destroy()

				self._music_players[config_name] = nil
			end
		end
	end
end

MusicManager._number_of_aggroed_enemies = function (self)
	-- function 30
	local ai_slot_system = Managers.state.entity:system("ai_slot_system")
	local num_enemies = ai_slot_system.num_total_enemies

	return num_enemies
end

MusicManager._update_flag_in_combat = function (self, conflict_director)
	-- function 31
	local num_aggroed_enemies = self:_number_of_aggroed_enemies()
	local pacing = conflict_director.pacing
	local intensity = pacing.total_intensity
	local in_combat = num_aggroed_enemies >= CombatMusic.minimum_enemies

	self:set_flag("in_combat", in_combat)
end

MusicManager._update_combat_intensity = function (self, conflict_director)
	-- function 32
	local pacing = conflict_director.pacing
	local intensity = pacing.total_intensity
	local highest_state

	for _, data in ipairs(IntensityThresholds) do
		if intensity > data.threshold then
			highest_state = data.state
		end
	end

	if highest_state then
		self:set_music_group_state("combat_music", "combat_intensity", highest_state)
	end
end

MusicManager._update_boss_state = function (self, conflict_director)
	-- function 33
	local music_player = self._music_players.combat_music

	if not music_player then
		return
	end

	local is_versus = Managers.mechanism:current_mechanism_name() == "versus"
	local state

	if not is_versus then
		local angry_boss = conflict_director:angry_boss()

		state = angry_boss and (self:_get_combat_music_state(conflict_director) or "no_boss") or not angry_boss and "no_boss"
	else
		state = self:_get_versus_combat_music_state()
	end

	self:set_music_group_state("combat_music", "boss_state", state)
end

MusicManager._get_versus_combat_music_state = function (self)
	-- function 34
	local side_manager = Managers.state.side
	local side = side_manager:get_side(2)
	local players_and_bots = side.PLAYER_AND_BOT_UNITS
	local breed_combat_music = "no_boss"

	for i = 1, #players_and_bots do
		local player_breed = Unit.get_data(players_and_bots[i], "breed")

		if player_breed.boss then
			breed_combat_music = player_breed.combat_music_state

			break
		end
	end

	return breed_combat_music
end

MusicManager._get_combat_music_state = function (self, conflict_director)
	-- function 35
	local state = "rat_ogre"
	local boss_units = conflict_director:alive_bosses()
	local BLACKBOARDS = BLACKBOARDS

	for i = #boss_units, 1, -1 do
		local unit = boss_units[i]
		local blackboard = BLACKBOARDS[unit]

		if blackboard and blackboard.is_angry then
			local breed = blackboard.breed

			state = breed.combat_music_state or state

			if breed.combat_music_state ~= "no_boss" then
				break
			end
		end
	end

	return state
end

MusicManager._update_boss_music_intensity = function (self, conflict_director)
	-- function 36
	local state_name = BossFightMusicIntensity.default_state
	local group_name = BossFightMusicIntensity.group_name
	local local_player = self:_get_player()

	if local_player then
		local player_unit = local_player.player_unit

		if Unit.alive(player_unit) then
			local player_position = Unit.local_position(player_unit, 0)
			local boss_units = conflict_director:alive_bosses()
			local additional_contributing_units = FrameTable.alloc_table()

			for _, breed in pairs(BossFightMusicIntensity.additional_contributing_units) do
				table.append_non_indexed(additional_contributing_units, conflict_director:spawned_units_by_breed(breed))
			end

			local min_distance_sq = math.huge

			for _, unit in pairs(boss_units) do
				local unit_position = Unit.local_position(unit, 0)
				local distance_sq = Vector3.distance_squared(player_position, unit_position)

				min_distance_sq = not (distance_sq < min_distance_sq) or distance_sq or min_distance_sq
			end

			for _, unit in pairs(additional_contributing_units) do
				local unit_position = Unit.local_position(unit, 0)
				local distance_sq = Vector3.distance_squared(player_position, unit_position)

				min_distance_sq = not (distance_sq < min_distance_sq) or distance_sq or min_distance_sq
			end

			for _, boss_intensity_data in ipairs(BossFightMusicIntensity) do
				if min_distance_sq < boss_intensity_data.max_distance^2 then
					state_name = boss_intensity_data.state

					break
				end
			end
		end
	end

	self:set_wwise_state(group_name, state_name)
end

MusicManager.set_wwise_state = function (self, group_name, state_name)
	-- function 37
	self._group_states[group_name] = self._group_states[group_name]

	if state_name ~= self._group_states[group_name] then
		Wwise.set_state(group_name, state_name)
	end

	self._group_states[group_name] = state_name
end

MusicManager.check_last_man_standing_music_state = function (self)
	-- function 38
	local player_manager = Managers.player
	local num_players = player_manager:num_players()

	if num_players == 1 then
		self.last_man_standing = false

		return
	end

	local local_player = self:_get_player()
	local player_unit = local_player and local_player.player_unit

	if Unit.alive(player_unit) then
		local status_extension = ScriptUnit.has_extension(player_unit, "status_system")

		if status_extension and not status_extension:is_disabled() then
			local num_alive_allies = player_manager:num_alive_allies(local_player)
			local last_man_standing = num_alive_allies == 0

			self.last_man_standing = last_man_standing

			if last_man_standing then
				local dialogue_extension = ScriptUnit.has_extension(player_unit, "dialogue_system")

				if dialogue_extension then
					local dialogue_input = ScriptUnit.extension_input(player_unit, "dialogue_system")
					local event_data = FrameTable.alloc_table()

					dialogue_input:trigger_dialogue_event("last_hero_standing", event_data)
				end
			end
		else
			self.last_man_standing = false
		end
	else
		self.last_man_standing = false
	end
end

local function get_horde_music_state(state, sound_settings)
	-- function 39
	local music_state_settings = sound_settings.music_states
	local music_state = music_state_settings[state]

	return music_state or state
end

local HORDE_MUSIC_STATES = {
	pre_ambush = true,
	pre_horde = true,
	ambush = true,
	horde = true
}

MusicManager._update_game_state = function (self, dt, t, conflict_director)
	-- function 40
	local parties = Managers.party:parties()
	local states_changed

	for _, party in pairs(parties) do
		local slot_data = party.occupied_slots[1]
		local party_id = party.party_id

		if slot_data and party.name ~= "undecided" then
			local player = slot_data.player
			local old_state_id = self._game_states[party_id]
			local old_state = NetworkLookup.music_group_states[old_state_id]
			local state = self:_get_game_state_for_player(dt, t, conflict_director, party_id, old_state, player)

			if state ~= old_state then
				local music_state

				if self._current_horde_sound_settings[party_id] and HORDE_MUSIC_STATES[state] then
					music_state = get_horde_music_state(state, self._current_horde_sound_settings[party_id])
				else
					music_state = state
				end

				self._game_states[party_id] = NetworkLookup.music_group_states[music_state]
				states_changed = true
			end
		end
	end

	if states_changed then
		self:set_music_group_state("combat_music", "game_state", self._game_states)
	end
end

MusicManager._get_game_state_for_player = function (self, dt, t, conflict_director, party_id, old_state, player)
	-- function 41
	local game_mode_manager = Managers.state.game_mode
	local round_about_to_end = game_mode_manager:game_mode():is_about_to_end_game_early()
	local game_mode_key = game_mode_manager:game_mode_key()
	local is_survival = game_mode_key == "survival"

	if round_about_to_end then
		if is_survival then
			return "survival_lost"
		elseif game_mode_manager:game_won(player) then
			local weave_manager = Managers.weave

			if weave_manager:get_active_weave() and weave_manager:get_active_weave() == 2 then
				return "won_between_winds"
			end

			local level_settings = LevelHelper:current_level_settings()

			return level_settings and level_settings.music_won_state or not level_settings and "won"
		elseif game_mode_manager:game_lost(player) then
			return "lost"
		elseif game_mode_key == "versus" and Managers.mechanism:get_state() == "round_1" then
			return "draw"
		end

		return old_state
	end

	if game_mode_manager:game_won(player) then
		local weave_manager = Managers.weave

		if weave_manager:get_active_weave() and weave_manager:get_active_weave() == 2 then
			return "won_between_winds"
		end

		local level_settings = LevelHelper:current_level_settings()

		return level_settings and level_settings.music_won_state or not level_settings and "won"
	end

	local is_pre_horde = old_state == "pre_horde" or old_state == "pre_ambush" or old_state == "pre_ambush_beastmen" or old_state == "pre_ambush_chaos"
	local is_horde_alive, horde_type, sound_settings = conflict_director:is_horde_alive()

	if is_pre_horde and self._scream_delays[party_id] and t > self._scream_delays[party_id] then
		self._scream_delays[party_id] = nil

		return "horde"
	elseif is_pre_horde and not self._scream_delays[party_id] and self:_horde_done_spawning(horde_type) then
		if horde_type == "ambush" then
			self:delay_trigger_horde_dialogue(t, t + DialogueSettings.ambush_delay, "ambush")

			self._scream_delays[party_id] = t + 1.5

			return old_state
		else
			return "horde"
		end
	elseif is_pre_horde and is_horde_alive then
		self:delay_trigger_horde_dialogue(t)

		return old_state
	elseif old_state == "horde" and is_horde_alive or not (old_state == "horde") and (old_state == "horde_beastmen" and is_horde_alive or not (old_state == "horde_beastmen") and old_state == "horde_chaos" and is_horde_alive) then
		self:delay_trigger_horde_dialogue(t)

		return "horde"
	elseif horde_type == "vector" or horde_type == "vector_blob" or horde_type == "event" then
		self:delay_trigger_horde_dialogue(t, t + DialogueSettings.vector_delay, "vector")

		self._current_horde_sound_settings[party_id] = sound_settings

		return "pre_horde"
	elseif horde_type == "ambush" then
		self._current_horde_sound_settings[party_id] = sound_settings

		return "pre_ambush"
	end

	return "explore"
end

local ai_units = {}

MusicManager._horde_done_spawning = function (self, horde)
	-- function 42
	local engage_distance = horde ~= "ambush" and 25 or not (horde ~= "ambush") and 25
	local pos
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if Unit.alive(player_unit) then
			pos = Unit.local_position(player_unit, 0)

			local num_units = AiUtils.broadphase_query(pos, engage_distance, ai_units)

			for i = 1, num_units do
				local unit = ai_units[i]
				local ai_extension = ScriptUnit.extension(unit, "ai_system")
				local blackboard = ai_extension:blackboard()
				local spawn_type = blackboard.spawn_type

				if spawn_type == "horde_hidden" and HEALTH_ALIVE[unit] or not (spawn_type == "horde_hidden") and spawn_type == "horde" and HEALTH_ALIVE[unit] then
					return true
				end
			end
		end
	end

	return false
end

MusicManager._update_player_state = function (self, dt, t)
	-- function 43
	local music_player = self._music_players.combat_music

	if music_player then
		local player = self:_get_player()
		local player_unit = player.player_unit
		local state

		if Unit.alive(player_unit) then
			local status_ext = ScriptUnit.extension(player_unit, "status_system")

			state = Managers.state.game_mode:game_mode():is_about_to_end_game_early() and ("normal" or status_ext:is_ready_for_assisted_respawn() and ("normal" or status_ext:is_dead() and ("dead" or status_ext:is_knocked_down() and ("knocked_down" or status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")) or not status_ext:is_knocked_down() and (status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help"))) or not status_ext:is_dead() and (status_ext:is_knocked_down() and ("knocked_down" or status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")) or not status_ext:is_knocked_down() and (status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")))) or not status_ext:is_ready_for_assisted_respawn() and (status_ext:is_dead() and ("dead" or status_ext:is_knocked_down() and ("knocked_down" or status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")) or not status_ext:is_knocked_down() and (status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help"))) or not status_ext:is_dead() and (status_ext:is_knocked_down() and ("knocked_down" or status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")) or not status_ext:is_knocked_down() and (status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help"))))) or not Managers.state.game_mode:game_mode():is_about_to_end_game_early() and (status_ext:is_ready_for_assisted_respawn() and ("normal" or status_ext:is_dead() and ("dead" or status_ext:is_knocked_down() and ("knocked_down" or status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")) or not status_ext:is_knocked_down() and (status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help"))) or not status_ext:is_dead() and (status_ext:is_knocked_down() and ("knocked_down" or status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")) or not status_ext:is_knocked_down() and (status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")))) or not status_ext:is_ready_for_assisted_respawn() and (status_ext:is_dead() and ("dead" or status_ext:is_knocked_down() and ("knocked_down" or status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")) or not status_ext:is_knocked_down() and (status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help"))) or not status_ext:is_dead() and (status_ext:is_knocked_down() and ("knocked_down" or status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")) or not status_ext:is_knocked_down() and (status_ext:is_in_vortex() and ("normal" or not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help") or not status_ext:is_in_vortex() and (not status_ext:is_disabled() or status_ext:is_grabbed_by_chaos_spawn() or status_ext:is_grabbed_by_corruptor() or not "need_help")))))

			music_player:set_group_state("player_state", state)
		else
			local side_name = self:_get_side_name()

			state = "normal"

			music_player:set_group_state("player_state", state)
		end
	elseif music_player then
		music_player:set_group_state("player_state", "normal")
	end
end

MusicManager._update_career_state = function (self, dt, t)
	-- function 44
	local music_player = self._music_players.combat_music
	local player = self:_get_player()
	local career_state = "default"

	if player then
		local player_unit = player.player_unit

		if Unit.alive(player_unit) then
			local career_extension = ScriptUnit.extension(player_unit, "career_system")

			career_state = career_extension:get_state()
		end
	end

	if music_player then
		music_player:set_group_state("career_state", career_state)
	end
end

MusicManager._update_enemy_aggro_state = function (self, dt, t)
	-- function 45
	local music_player = self._music_players.combat_music
	local local_player_id = self._active_local_player_id

	if music_player and local_player_id then
		local player = self:_get_player()
		local player_unit = player and player.player_unit

		if Unit.alive(player_unit) then
			local sound_effect_extension = ScriptUnit.extension(player_unit, "sound_effect_system")
			local aggro_state = sound_effect_extension:get_music_aggro_state()

			music_player:set_group_state("music_target_aggro", aggro_state)
		else
			music_player:set_group_state("music_target_aggro", "husk")
		end
	elseif music_player then
		music_player:set_group_state("music_target_aggro", "husk")
	end
end

MusicManager._update_game_mode = function (self, dt, t)
	-- function 46
	local music_player = self._music_players.combat_music

	if music_player then
		local mechanism_name = Managers.mechanism:current_mechanism_name()

		music_player:set_group_state("game_mode", mechanism_name)

		if mechanism_name == "adventure" then
			-- Nothing
		elseif mechanism_name == "versus" then
			self:_update_versus_game_state(music_player, dt, t)
		else
			fassert("Non-supported game mode '%s'", mechanism_name)
		end
	end
end

MusicManager._update_side_state = function (self, dt, t)
	-- function 47
	local music_player = self._music_players.combat_music

	if not music_player or not self._active_local_player_id then
		return
	end

	local player = self:_get_player()

	if not player then
		return
	end

	if not player.player_unit or not Unit.alive(player.player_unit) then
		local party = Managers.party:get_local_player_party()

		if party and party.name then
			music_player:set_group_state("game_faction", party.name)

			return
		else
			return
		end
	end

	local side_name = self:_get_side_name()

	if side_name then
		music_player:set_group_state("game_faction", side_name)
	end
end

MusicManager._update_versus_game_state = function (self, music_player, dt, t)
	-- function 48
	local music_player = self._music_players.combat_music

	if not music_player or not self._active_local_player_id then
		return
	end

	local player = self:_get_player()

	if not player then
		return
	end

	local side_name = self:_get_side_name()
	local is_dark_pact = side_name == "dark_pact"

	if is_dark_pact then
		local status = self._party_manager:get_status_from_unique_id(player:unique_id())
		local profile_id = status.profile_id

		music_player:set_group_state("pactsworn_character", profile_id)
	end

	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()
	local game_mode_key = game_mode_manager:game_mode_key()
	local game_mode_state = game_mode:game_mode_state()

	if game_mode_key == "inn_vs" or game_mode.is_in_pre_match_state and game_mode:is_in_pre_match_state() then
		music_player:set_group_state("versus_state", "menu")

		return
	end

	if game_mode_state == "player_team_parading_state" then
		music_player:set_group_state("versus_state", "intro")

		return
	end

	if not game_mode_manager:is_round_started() or game_mode_manager:is_game_mode_ended() then
		music_player:set_group_state("versus_state", "normal")

		return
	end

	local win_conditions = Managers.mechanism:game_mechanism():win_conditions()
	local side_close_to_winning = win_conditions:get_side_close_to_winning()
	local heroes_close_to_safe_zone = win_conditions:heroes_close_to_safe_zone()

	if side_close_to_winning or heroes_close_to_safe_zone then
		local state
		local player_team_close_to_safe_zone = heroes_close_to_safe_zone and side_name == "heroes"

		state = side_name == side_close_to_winning and ("close_to_win" or "time_is_running_out") or not (side_name == side_close_to_winning) and (player_team_close_to_safe_zone and ("close_to_win" or "time_is_running_out") or not player_team_close_to_safe_zone and "time_is_running_out")

		music_player:set_group_state("versus_state", state)
	elseif is_dark_pact then
		music_player:set_group_state("versus_state", "match_on")
	else
		music_player:set_group_state("versus_state", "normal")
	end
end

MusicManager.register_active_player = function (self, player_id)
	-- function 49
	dprint("register_active_player")
	fassert(not self._active_local_player_id, "Active player %q already registered!", player_id)

	self._active_local_player_id = player_id
	self._player = nil
end

MusicManager.unregister_active_player = function (self, player_id)
	-- function 50
	dprint("unregister_active_player")
	fassert(self._active_local_player_id == player_id, "Trying to unregister player %q when player %q is active player", player_id, self._player_id)

	self._active_local_player_id = nil
	self._player = nil
end

MusicManager.set_music_group_state = function (self, music_player, group, state)
	-- function 51
	local game_object_id = self._game_object_id

	if self._is_server then
		if game_object_id then
			local state_id = NetworkLookup.music_group_states[state]
			local session = Managers.state.network:game()

			GameSession.set_game_object_field(session, game_object_id, group, state_id)
		else
			self._override_init_fields = self._override_init_fields
			self._override_init_fields[group] = state
		end
	end
end

MusicManager.music_trigger = function (self, music_player, event)
	-- function 52
	dprint("music_trigger")

	local player = self._music_players[music_player]

	player:post_trigger(event)
end

MusicManager.set_music_volume = function (self, value)
	-- function 53
	WwiseWorld.set_global_parameter(self._wwise_world, "music_bus_volume", value)
end

MusicManager.set_master_volume = function (self, value)
	-- function 54
	WwiseWorld.set_global_parameter(self._wwise_world, "master_bus_volume", value)
end

MusicManager.set_panning_rule = function (self, rule)
	-- function 55
	fassert(MusicManager.panning_rules[rule] ~= nil, "[MusicManager] Panning rule does not exist: %q", rule)
	Wwise.set_panning_rule(MusicManager.panning_rules[rule])
end

MusicManager.is_playing = function (self, wwise_playing_id)
	-- function 56
	return WwiseWorld.is_playing(self._wwise_world, wwise_playing_id)
end

MusicManager.delay_trigger_horde_dialogue = function (self, t, delay, horde_name)
	-- function 57
	if delay ~= nil then
		self._horde_delay = delay
		self._horde_type = horde_name
	end

	if self._horde_delay ~= nil and t > self._horde_delay then
		MusicManager:trigger_horde_dialogue(self._horde_type)

		self._horde_delay = nil
		self._horde_type = nil
	end
end

MusicManager.trigger_horde_dialogue = function (self, horde_name)
	-- function 58
	local dialogue_system = Managers.state.entity:system("dialogue_system")
	local dummy_unit = dialogue_system:get_random_player()

	if dummy_unit then
		SurroundingAwareSystem.add_event(dummy_unit, "horde", DialogueSettings.discover_enemy_attack_distance, "horde_type", horde_name)
	end
end

MusicManager._get_player = function (self)
	-- function 59
	if self._player then
		return self._player
	end

	if not self._active_local_player_id then
		return
	end

	self._player = Managers.player:local_player(self._active_local_player_id)

	if not self._player or self._player and self._player.bot_player then
		return
	end

	return self._player
end

MusicManager._get_party = function (self)
	-- function 60
	if self._party then
		return self._party
	end

	local player = self:_get_player()

	self._party = self._party_manager:get_party_from_unique_id(player:unique_id())

	return self._party
end

MusicManager._get_side_name = function (self)
	-- function 61
	if self._side then
		return self._side:name()
	end

	local party = self:_get_party()

	self._side = self._side_manager.side_by_party[party]

	return self._side
end

MusicManager.on_player_party_changed = function (self, player, is_local_player, old_party_id, new_party_id)
	-- function 62
	if not is_local_player then
		return
	end

	self._party = self._party_manager:get_party(new_party_id)
	self._side = self._side_manager.side_by_party[self._party]
end

MusicManager.versus_update_sides = function (self)
	-- function 63
	if DEDICATED_SERVER then
		return
	end

	self._side_manager = Managers.state.side
	self._side = self._side_manager.side_by_party[self._party]
end

MusicManager.on_enter_game = function (self)
	-- function 64
	self._is_ingame = true
end

MusicManager.on_exit_game = function (self)
	-- function 65
	self._is_ingame = false
end
