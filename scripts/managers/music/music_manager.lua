-- chunkname: @scripts/managers/music/music_manager.lua

require("scripts/settings/music_settings")
require("scripts/managers/music/music_player")

local function fn(...)
	-- function 1
	if not script_data.debug_music then
		print("[MusicManager] ", ...)
	end
end

MusicManager = class(MusicManager)
MusicManager.bus_transition_functions = {
	linear = function (self, arg_2_1)
		-- function 2
		return math.lerp(self.start_value, self.target_value, arg_2_1)
	end,
	sine = function (self, arg_3_1)
		-- function 3
		return math.lerp(self.start_value, self.target_value, math.sin(arg_3_1 * math.pi * 0.5))
	end,
	smoothstep = function (self, arg_4_1)
		-- function 4
		return math.lerp(self.start_value, self.target_value, math.smoothstep(arg_4_1, 0, 1))
	end
}
MusicManager.panning_rules = {
	PANNING_RULE_SPEAKERS = 0,
	PANNING_RULE_HEADPHONES = 1
}

MusicManager.init = function (self)
	-- function 5
	fn("init")

	if not GLOBAL_MUSIC_WORLD then
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

	local user_setting = Application.user_setting("master_bus_volume")

	if user_setting ~= nil then
		self:set_master_volume(user_setting)
	end

	local user_setting_2 = Application.user_setting("music_bus_volume")

	if user_setting_2 ~= nil then
		self:set_music_volume(user_setting_2)
	end

	local user_setting_3 = Application.user_setting("sound_panning_rule")

	if user_setting_3 ~= nil then
		local flag

		flag = user_setting_3 ~= "headphones" or not "PANNING_RULE_HEADPHONES" or "PANNING_RULE_SPEAKERS"

		self:set_panning_rule(flag)
	end

	local user_setting_4 = Application.user_setting("sound_channel_configuration")

	if not DEDICATED_SERVER then
		Wwise.set_bus_config("ingame_mastering_channel", user_setting_4)
	end
end

MusicManager.duck_sounds = function (self)
	-- function 6
	if self._duck_sounds_stack == 0 then
		self:trigger_event("hud_in_inventory_state_on")
	end

	self._duck_sounds_stack = self._duck_sounds_stack + 1
end

MusicManager.unduck_sounds = function (self, arg_7_1)
	-- function 7
	if self._duck_sounds_stack == 1 or not arg_7_1 then
		self:trigger_event("hud_in_inventory_state_off")
	end

	local flag

	flag = not arg_7_1 and 0 and math.max(0, self._duck_sounds_stack - 1)
	self._duck_sounds_stack = flag
end

MusicManager._update_window_focus = function (self)
	-- function 8
	if not DEDICATED_SERVER then
		local has_focus = Window.has_focus()

		if has_focus ~= self._has_focus then
			if not has_focus then
				self:trigger_event("unmute_all")
			elseif not Application.user_setting("mute_in_background") then
				self:trigger_event("mute_all")
			end

			self._has_focus = has_focus
		end
	end
end

MusicManager.stop_all_sounds = function (self)
	-- function 9
	fn("stop_all_sounds")
	self._wwise_world:stop_all()
end

MusicManager.stop_event_id = function (self, arg_10_1)
	-- function 10
	fn("stop_event_id")

	if not self._wwise_world:is_playing(arg_10_1) then
		self._wwise_world:stop_event(arg_10_1)
	end
end

MusicManager.trigger_event = function (self, arg_11_1)
	-- function 11
	fn("trigger_event", arg_11_1)

	local _wwise_world = self._wwise_world
	local trigger_event, var_11_2 = WwiseWorld.trigger_event(_wwise_world, arg_11_1)

	fn("MUSIC MANAGER", arg_11_1, trigger_event, var_11_2)

	return trigger_event, var_11_2
end

MusicManager.trigger_event_queue = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	fassert(not self._event_queues[arg_12_1], "[MusicManager:trigger_event_queue] There is already an event queue playing with that name")

	local num = 1
	local var_12_1 = arg_12_2[1]
	local trigger_event, var_12_3 = self:trigger_event(var_12_1)

	self._event_queues[arg_12_1] = {
		delay = arg_12_3 or 0.5,
		event_index = num,
		wwise_playing_id = trigger_event,
		wwise_source_id = var_12_3,
		event_queue = arg_12_2
	}
end

MusicManager.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	local conflict = Managers.state.conflict

	if not conflict then
		if not self._is_server then
			self:_update_flag_in_combat(conflict)
			self:_update_combat_intensity(conflict)
			self:_update_boss_state(conflict)
			self:_update_game_state(arg_13_1, arg_13_2, conflict)
		end

		self:_update_boss_state(conflict)

		if not DEDICATED_SERVER then
			self:_update_boss_music_intensity(conflict)
		end
	end

	if not DEDICATED_SERVER then
		self:_update_player_state(arg_13_1, arg_13_2)
		self:_update_career_state(arg_13_1, arg_13_2)
		self:_update_enemy_aggro_state(arg_13_1, arg_13_2)
		self:_update_game_mode(arg_13_1, arg_13_2)
		self:_update_side_state(arg_13_1, arg_13_2)
		self:_update_window_focus()
	end

	self:_update_flags()
	self:_handle_event_queues(arg_13_1, arg_13_2)

	local _flags = self._flags

	for k, v in pairs(self._music_players) do
		v:update(_flags, self._game_object_id, self._is_ingame)
	end
end

local tbl = {}

MusicManager._handle_event_queues = function (self, arg_14_1, arg_14_2)
	-- function 14
	table.clear(tbl)

	for k, v in pairs(self._event_queues) do
		local wwise_playing_id = v.wwise_playing_id

		if not self:is_playing(wwise_playing_id) then
			if not v.current_delay then
				v.current_delay = arg_14_2 + v.delay
			elseif arg_14_2 > v.current_delay then
				local event_queue = v.event_queue
				local num = v.event_index + 1
				local var_14_3 = event_queue[num]

				if not var_14_3 then
					local trigger_event, var_14_5 = self:trigger_event(var_14_3)

					v.event_index = num
					v.wwise_playing_id = trigger_event
					v.wwise_source_id = var_14_5
					v.current_delay = nil
				else
					tbl[#tbl + 1] = k
				end
			end
		end
	end

	for i, v_2 in ipairs(tbl) do
		self:stop_event_queue(v_2)
	end
end

MusicManager.stop_event_queue = function (self, arg_15_1)
	-- function 15
	local var_15_0 = self._event_queues[arg_15_1]

	if not var_15_0 then
		return
	end

	local wwise_playing_id = var_15_0.wwise_playing_id

	if not self:is_playing(wwise_playing_id) then
		self:stop_event_id(wwise_playing_id)
	end

	self._event_queues[arg_15_1] = nil
end

MusicManager.destroy = function (self)
	-- function 16
	fn("DESTROY")

	if not GLOBAL_MUSIC_WORLD then
		Application.release_world(self._world)
	end

	self:_unregister_events()
end

MusicManager.on_enter_level = function (self, arg_17_1, arg_17_2)
	-- function 17
	fn("on_enter_level")

	self._network_event_delegate = arg_17_1

	if not arg_17_2 then
		local music_states = NetworkLookup.go_types.music_states
		local low_battle = NetworkLookup.music_group_states.low_battle
		local explore = NetworkLookup.music_group_states.explore
		local no_boss = NetworkLookup.music_group_states.no_boss
		local None = NetworkLookup.music_group_states.None
		local winds

		if not (Managers.mechanism:game_mechanism():get_state() == "weave") then
			winds = NetworkLookup.music_group_states.winds

			if not winds then
				-- Nothing
			end
		end

		winds = NetworkLookup.music_group_states["false"]

		::label_17_0::

		local tbl = {
			go_type = music_states,
			combat_intensity = low_battle,
			boss_state = no_boss,
			override = winds,
			dlc_dwarf_fest = None
		}

		if not self._override_init_fields then
			for k, v in pairs(self._override_init_fields) do
				tbl[k] = type(v) ~= "table" or not v or NetworkLookup.music_group_states[v]
			end

			self._override_init_fields = nil
		end

		local parties = Managers.party:parties()
		local tbl_2 = {}

		for k_2, v_2 in pairs(parties) do
			tbl_2[v_2.party_id] = explore
		end

		tbl.game_state = tbl_2
		self._game_states = tbl_2

		local game_session = Managers.state.network.game_session

		fassert(not self._game_object_id, "Creating game object when already exists")

		self._game_object_id = Managers.state.network:create_game_object("music_states", tbl, function (arg_18_0)
			-- function 18
			self:server_game_session_disconnect_music_states(arg_18_0)
		end)
	end

	self:_setup_level_music_players()
	self:set_flag("in_level", true)

	self._is_server = arg_17_2
	self.last_man_standing = false
	self._party_manager = Managers.party
	self._side_manager = Managers.state.side

	self:_register_events()
end

MusicManager.on_exit_level = function (self)
	-- function 19
	fn("on_exit_level")
	self:set_flag("in_level", false)
	self:set_flag("in_combat", false)
	self:_reset_level_music_players()
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._is_server = false
	self.last_man_standing = false

	self:_unregister_events()
end

MusicManager._register_events = function (arg_20_0)
	-- function 20
	local event = Managers.state.event

	if not event then
		return
	end

	event:register(arg_20_0, "player_party_changed", "on_player_party_changed")
	event:register(arg_20_0, "versus_pre_start_initialized", "versus_update_sides")
end

MusicManager._unregister_events = function (arg_21_0)
	-- function 21
	local event = Managers.state.event

	if not event then
		return
	end

	event:unregister("player_party_changed", arg_21_0)
	event:unregister("versus_pre_start_initialized", arg_21_0)
end

MusicManager.client_game_session_disconnect_music_states = function (arg_22_0, arg_22_1)
	-- function 22
	return
end

MusicManager.server_game_session_disconnect_music_states = function (self, arg_23_1)
	-- function 23
	self:game_object_destroyed(arg_23_1, self._owner_id, self._go_template)
end

MusicManager.game_object_created = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	fn("game_object_created")

	self._game_object_id = arg_24_1
	self._owner_id = arg_24_2
	self._go_template = arg_24_3
end

MusicManager.game_object_destroyed = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	fn("game_object_destroyed")
	Application.warning("[MusicManager:game_object_destroyed] Removed go_template == self._go_template check due to crash")

	self._game_object_id = nil
	self._owner_id = nil
	self._go_template = nil
end

MusicManager._update_flags = function (self)
	-- function 26
	self:set_flag("combat_music_enabled", not script_data.debug_disable_combat_music)

	local _game_object_id = self._game_object_id

	if not (self._is_server or _game_object_id) then
		return
	end

	local game = Managers.state.network:game()

	for k, v in pairs(SyncedMusicFlags) do
		local game_object_field = GameSession.game_object_field(game, _game_object_id, k)

		self:set_flag(k, game_object_field)
	end
end

MusicManager.set_flag = function (self, arg_27_1, arg_27_2)
	-- function 27
	if self._flags[arg_27_1] == arg_27_2 then
		return
	end

	fn("set_flag", arg_27_1, arg_27_2)

	self._flags[arg_27_1] = arg_27_2

	if not self._is_server and not SyncedMusicGroupFlags[arg_27_1] then
		local game = Managers.state.network:game()

		GameSession.set_game_object_field(game, self._game_object_id, arg_27_1, arg_27_2)
	end
end

MusicManager._setup_level_music_players = function (self)
	-- function 28
	fn("_setup_level_music_players")

	local MusicSettings = MusicSettings

	for k, v in pairs(MusicSettings) do
		if not v.ingame_only then
			local start_event = v.start_event
			local stop = v.stop
			local set_flags = v.set_flags
			local unset_flags = v.unset_flags
			local parameters = v.parameters
			local default_group_states = v.default_group_states
			local game_state_voice_thresholds = v.game_state_voice_thresholds
			local var_28_8 = MusicPlayer:new(self._wwise_world, start_event, stop, k, set_flags, unset_flags, parameters, default_group_states, game_state_voice_thresholds)

			self._music_players[k] = var_28_8
		end
	end
end

MusicManager._reset_level_music_players = function (self)
	-- function 29
	fn("_reset_level_music_players")

	local MusicSettings = MusicSettings

	for k, v in pairs(MusicSettings) do
		if not v.ingame_only then
			local var_29_1 = self._music_players[k]

			if not var_29_1 then
				var_29_1:destroy()

				self._music_players[k] = nil
			end
		end
	end
end

MusicManager._number_of_aggroed_enemies = function (arg_30_0)
	-- function 30
	return Managers.state.entity:system("ai_slot_system").num_total_enemies
end

MusicManager._update_flag_in_combat = function (self, arg_31_1)
	-- function 31
	local _number_of_aggroed_enemies = self:_number_of_aggroed_enemies()
	local total_intensity = arg_31_1.pacing.total_intensity
	local flag = _number_of_aggroed_enemies >= CombatMusic.minimum_enemies

	self:set_flag("in_combat", flag)
end

MusicManager._update_combat_intensity = function (self, arg_32_1)
	-- function 32
	local total_intensity = arg_32_1.pacing.total_intensity
	local var_32_1

	for i, v in ipairs(IntensityThresholds) do
		if total_intensity > v.threshold then
			var_32_1 = v.state
		end
	end

	if not var_32_1 then
		self:set_music_group_state("combat_music", "combat_intensity", var_32_1)
	end
end

MusicManager._update_boss_state = function (self, arg_33_1)
	-- function 33
	if not self._music_players.combat_music then
		return
	end

	local flag = Managers.mechanism:current_mechanism_name() == "versus"
	local var_33_1

	if not flag then
		local angry_boss = arg_33_1:angry_boss()

		angry_boss = angry_boss or arg_33_1:boss_event_running()
		var_33_1 = not angry_boss and self:_get_combat_music_state(arg_33_1) and "no_boss"
	else
		var_33_1 = self:_get_versus_combat_music_state()
	end

	self:set_music_group_state("combat_music", "boss_state", var_33_1)
end

MusicManager._get_versus_combat_music_state = function (arg_34_0)
	-- function 34
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side(2).PLAYER_AND_BOT_UNITS
	local str = "no_boss"

	for i = 1, #PLAYER_AND_BOT_UNITS do
		local get_data = Unit.get_data(PLAYER_AND_BOT_UNITS[i], "breed")

		if not get_data.boss then
			str = get_data.combat_music_state

			break
		end
	end

	return str
end

MusicManager._get_combat_music_state = function (arg_35_0, arg_35_1)
	-- function 35
	local str = "rat_ogre"
	local alive_bosses = arg_35_1:alive_bosses()
	local BLACKBOARDS = BLACKBOARDS

	for i = #alive_bosses, 1, -1 do
		local var_35_3 = BLACKBOARDS[alive_bosses[i]]

		if not var_35_3 and not var_35_3.is_angry then
			local breed = var_35_3.breed

			str = breed.combat_music_state or str

			if breed.combat_music_state ~= "no_boss" then
				break
			end
		end
	end

	return str
end

MusicManager._update_boss_music_intensity = function (self, arg_36_1)
	-- function 36
	local default_state = BossFightMusicIntensity.default_state
	local group_name = BossFightMusicIntensity.group_name
	local _get_player = self:_get_player()

	if not _get_player then
		local player_unit = _get_player.player_unit

		if not Unit.alive(player_unit) then
			local local_position = Unit.local_position(player_unit, 0)
			local alive_bosses = arg_36_1:alive_bosses()
			local alloc_table = FrameTable.alloc_table()

			for k, v in pairs(BossFightMusicIntensity.additional_contributing_units) do
				table.append_non_indexed(alloc_table, arg_36_1:spawned_units_by_breed(v))
			end

			local huge = math.huge

			for k_2, v_2 in pairs(alive_bosses) do
				local local_position_2 = Unit.local_position(v_2, 0)
				local distance_squared = Vector3.distance_squared(local_position, local_position_2)

				huge = not (distance_squared < huge) or not distance_squared or huge
			end

			for k_3, v_3 in pairs(alloc_table) do
				local local_position_3 = Unit.local_position(v_3, 0)
				local distance_squared_2 = Vector3.distance_squared(local_position, local_position_3)

				huge = not (distance_squared_2 < huge) or not distance_squared_2 or huge
			end

			for i, v_4 in ipairs(BossFightMusicIntensity) do
				if huge < v_4.max_distance^2 then
					default_state = v_4.state

					break
				end
			end
		end
	end

	self:set_wwise_state(group_name, default_state)
end

MusicManager.set_wwise_state = function (self, arg_37_1, arg_37_2)
	-- function 37
	local _group_states = self._group_states
	local var_37_1 = self._group_states[arg_37_1]

	var_37_1 = var_37_1 or nil
	_group_states[arg_37_1] = var_37_1

	if arg_37_2 ~= self._group_states[arg_37_1] then
		Wwise.set_state(arg_37_1, arg_37_2)
	end

	self._group_states[arg_37_1] = arg_37_2
end

MusicManager.check_last_man_standing_music_state = function (self)
	-- function 38
	local player = Managers.player

	if player:num_players() == 1 then
		self.last_man_standing = false

		return
	end

	local _get_player = self:_get_player()
	local flag = not _get_player and _get_player.player_unit

	if not Unit.alive(flag) then
		local has_extension = ScriptUnit.has_extension(flag, "status_system")

		if not (not has_extension and has_extension:is_disabled()) then
			local flag_2 = player:num_alive_allies(_get_player) == 0

			self.last_man_standing = flag_2

			if not flag_2 and not ScriptUnit.has_extension(flag, "dialogue_system") then
				local extension_input = ScriptUnit.extension_input(flag, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				extension_input:trigger_dialogue_event("last_hero_standing", alloc_table)
			end
		else
			self.last_man_standing = false
		end
	else
		self.last_man_standing = false
	end
end

local function fn_2(arg_39_0, arg_39_1)
	-- function 39
	return arg_39_1.music_states[arg_39_0] or arg_39_0
end

local tbl_2 = {
	pre_ambush = true,
	pre_horde = true,
	ambush = true,
	horde = true
}

MusicManager._update_game_state = function (self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local parties = Managers.party:parties()
	local var_40_1

	for k, v in pairs(parties) do
		local var_40_2 = v.occupied_slots[1]
		local party_id = v.party_id

		if not (not var_40_2 and v.name == "undecided") then
			local player = var_40_2.player
			local var_40_5 = self._game_states[party_id]
			local var_40_6 = NetworkLookup.music_group_states[var_40_5]
			local _get_game_state_for_player = self:_get_game_state_for_player(arg_40_1, arg_40_2, arg_40_3, party_id, var_40_6, player)

			if _get_game_state_for_player ~= var_40_6 then
				local var_40_8

				if not self._current_horde_sound_settings[party_id] and not tbl_2[_get_game_state_for_player] then
					var_40_8 = fn_2(_get_game_state_for_player, self._current_horde_sound_settings[party_id])
				else
					var_40_8 = _get_game_state_for_player
				end

				self._game_states[party_id] = NetworkLookup.music_group_states[var_40_8]
				var_40_1 = true
			end
		end
	end

	if not var_40_1 then
		self:set_music_group_state("combat_music", "game_state", self._game_states)
	end
end

MusicManager._get_game_state_for_player = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	-- function 41
	local game_mode = Managers.state.game_mode
	local is_about_to_end_game_early = game_mode:game_mode():is_about_to_end_game_early()
	local game_mode_key = game_mode:game_mode_key()
	local flag = game_mode_key == "survival"

	if not is_about_to_end_game_early then
		if not flag then
			return "survival_lost"
		elseif not game_mode:game_won(arg_41_6) then
			local weave = Managers.weave

			if not (not weave:get_active_weave() and weave:get_active_weave() ~= 2) then
				return "won_between_winds"
			end

			local current_level_settings = LevelHelper:current_level_settings()
			local music_won_state

			if not current_level_settings then
				music_won_state = current_level_settings.music_won_state

				if not music_won_state then
					-- Nothing
				end
			end

			music_won_state = "won"

			::label_41_0::

			return music_won_state
		elseif not game_mode:game_lost(arg_41_6) then
			return "lost"
		elseif not (game_mode_key ~= "versus" or Managers.mechanism:get_state() ~= "round_1") then
			return "draw"
		end

		return arg_41_5
	end

	if not game_mode:game_won(arg_41_6) then
		local weave_2 = Managers.weave

		if not (not weave_2:get_active_weave() and weave_2:get_active_weave() ~= 2) then
			return "won_between_winds"
		end

		local current_level_settings_2 = LevelHelper:current_level_settings()
		local music_won_state_2

		if not current_level_settings_2 then
			music_won_state_2 = current_level_settings_2.music_won_state

			if not music_won_state_2 then
				-- Nothing
			end
		end

		music_won_state_2 = "won"

		::label_41_1::

		return music_won_state_2
	end

	local flag_2 = arg_41_5 == "pre_horde" or arg_41_5 == "pre_ambush" or arg_41_5 == "pre_ambush_beastmen" or arg_41_5 == "pre_ambush_chaos"
	local is_horde_alive, var_41_12, var_41_13 = arg_41_3:is_horde_alive()

	if not (not flag_2 and not self._scream_delays[arg_41_4] and not (arg_41_2 > self._scream_delays[arg_41_4])) then
		self._scream_delays[arg_41_4] = nil

		return "horde"
	elseif not flag_2 and self._scream_delays[arg_41_4] or not self:_horde_done_spawning(var_41_12) then
		if var_41_12 == "ambush" then
			self:delay_trigger_horde_dialogue(arg_41_2, arg_41_2 + DialogueSettings.ambush_delay, "ambush")

			self._scream_delays[arg_41_4] = arg_41_2 + 1.5

			return arg_41_5
		else
			return "horde"
		end
	elseif not flag_2 and not is_horde_alive then
		self:delay_trigger_horde_dialogue(arg_41_2)

		return arg_41_5
	elseif arg_41_5 == "horde" or arg_41_5 == "horde_beastmen" or arg_41_5 == "horde_chaos" or not is_horde_alive then
		self:delay_trigger_horde_dialogue(arg_41_2)

		return "horde"
	elseif not (var_41_12 == "vector" or var_41_12 == "vector_blob" or var_41_12 ~= "event") then
		self:delay_trigger_horde_dialogue(arg_41_2, arg_41_2 + DialogueSettings.vector_delay, "vector")

		self._current_horde_sound_settings[arg_41_4] = var_41_13

		return "pre_horde"
	elseif var_41_12 == "ambush" then
		self._current_horde_sound_settings[arg_41_4] = var_41_13

		return "pre_ambush"
	end

	return "explore"
end

local tbl_3 = {}

MusicManager._horde_done_spawning = function (arg_42_0, arg_42_1)
	-- function 42
	local flag

	flag = arg_42_1 ~= "ambush" or not 25 or 25

	local var_42_1
	local players = Managers.player:players()

	for k, v in pairs(players) do
		local player_unit = v.player_unit

		if not Unit.alive(player_unit) then
			local local_position = Unit.local_position(player_unit, 0)
			local broadphase_query = AiUtils.broadphase_query(local_position, flag, tbl_3)

			for k_2 = 1, broadphase_query do
				local var_42_6 = tbl_3[k_2]
				local spawn_type = ScriptUnit.extension(var_42_6, "ai_system"):blackboard().spawn_type

				if spawn_type == "horde_hidden" or spawn_type == "horde" or not HEALTH_ALIVE[var_42_6] then
					return true
				end
			end
		end
	end

	return false
end

MusicManager._update_player_state = function (self, arg_43_1, arg_43_2)
	-- function 43
	local combat_music = self._music_players.combat_music

	if not combat_music then
		local player_unit = self:_get_player().player_unit
		local var_43_2

		if not Unit.alive(player_unit) then
			local extension = ScriptUnit.extension(player_unit, "status_system")
			local flag

			flag = not Managers.state.game_mode:game_mode():is_about_to_end_game_early() and "normal" and not extension:is_ready_for_assisted_respawn() or "normal" and (not extension:is_dead() and "dead" and not extension:is_knocked_down() or "knocked_down" and (not extension:is_in_vortex() and "normal" and not extension:is_disabled() or not extension:is_grabbed_by_chaos_spawn() and not extension:is_grabbed_by_corruptor() and "need_help" and not self.last_man_standing or "last_man_standing" and not extension.get_in_ghost_mode and not extension:get_in_ghost_mode() and "ghost" and "normal"))

			combat_music:set_group_state("player_state", flag)
		else
			local flag_2

			flag_2 = self:_get_side_name() ~= "dark_pact" or not "dead" or "normal"

			combat_music:set_group_state("player_state", flag_2)
		end
	elseif not combat_music then
		combat_music:set_group_state("player_state", "normal")
	end
end

MusicManager._update_career_state = function (self, arg_44_1, arg_44_2)
	-- function 44
	local combat_music = self._music_players.combat_music
	local _get_player = self:_get_player()
	local str = "default"

	if not _get_player then
		local player_unit = _get_player.player_unit

		if not Unit.alive(player_unit) then
			str = ScriptUnit.extension(player_unit, "career_system"):get_state()
		end
	end

	if not combat_music then
		combat_music:set_group_state("career_state", str)
	end
end

MusicManager._update_enemy_aggro_state = function (self, arg_45_1, arg_45_2)
	-- function 45
	local combat_music = self._music_players.combat_music
	local _active_local_player_id = self._active_local_player_id

	if not combat_music and not _active_local_player_id then
		local _get_player = self:_get_player()
		local flag = not _get_player and _get_player.player_unit

		if not Unit.alive(flag) then
			local get_music_aggro_state = ScriptUnit.extension(flag, "sound_effect_system"):get_music_aggro_state()

			combat_music:set_group_state("music_target_aggro", get_music_aggro_state)
		else
			combat_music:set_group_state("music_target_aggro", "husk")
		end
	elseif not combat_music then
		combat_music:set_group_state("music_target_aggro", "husk")
	end
end

MusicManager._update_game_mode = function (self, arg_46_1, arg_46_2)
	-- function 46
	local combat_music = self._music_players.combat_music

	if not combat_music then
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()

		combat_music:set_group_state("game_mode", current_mechanism_name)

		if current_mechanism_name == "adventure" then
			-- Nothing
		elseif current_mechanism_name == "versus" then
			self:_update_versus_game_state(combat_music, arg_46_1, arg_46_2)
		else
			fassert("Non-supported game mode '%s'", current_mechanism_name)
		end
	end
end

MusicManager._update_side_state = function (self, arg_47_1, arg_47_2)
	-- function 47
	local combat_music = self._music_players.combat_music

	if not (not combat_music and self._active_local_player_id) then
		return
	end

	local _get_player = self:_get_player()

	if not _get_player then
		return
	end

	if not (not _get_player.player_unit and Unit.alive(_get_player.player_unit)) then
		local get_local_player_party = Managers.party:get_local_player_party()

		if not get_local_player_party and not get_local_player_party.name then
			combat_music:set_group_state("game_faction", get_local_player_party.name)

			return
		else
			return
		end
	end

	local _get_side_name = self:_get_side_name()

	if not _get_side_name then
		combat_music:set_group_state("game_faction", _get_side_name)
	end
end

MusicManager._update_versus_game_state = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local combat_music = self._music_players.combat_music

	if not (not combat_music and self._active_local_player_id) then
		return
	end

	local _get_player = self:_get_player()

	if not _get_player then
		return
	end

	local _get_side_name = self:_get_side_name()
	local flag = _get_side_name == "dark_pact"

	if not flag then
		local profile_id = self._party_manager:get_status_from_unique_id(_get_player:unique_id()).profile_id

		combat_music:set_group_state("pactsworn_character", profile_id)
	end

	local game_mode = Managers.state.game_mode
	local game_mode_2 = game_mode:game_mode()
	local game_mode_key = game_mode:game_mode_key()
	local game_mode_state = game_mode_2:game_mode_state()

	if game_mode_key == "inn_vs" or not game_mode_2.is_in_pre_match_state or not game_mode_2:is_in_pre_match_state() then
		combat_music:set_group_state("versus_state", "menu")

		return
	end

	if game_mode_state == "player_team_parading_state" then
		combat_music:set_group_state("versus_state", "intro")

		return
	end

	if not game_mode:is_round_started() and not game_mode:is_game_mode_ended() then
		combat_music:set_group_state("versus_state", "normal")

		return
	end

	local win_conditions = Managers.mechanism:game_mechanism():win_conditions()
	local get_side_close_to_winning = win_conditions:get_side_close_to_winning()
	local heroes_close_to_safe_zone = win_conditions:heroes_close_to_safe_zone()

	if get_side_close_to_winning or not heroes_close_to_safe_zone then
		local var_48_12
		local flag_2 = not heroes_close_to_safe_zone and _get_side_name == "heroes"
		local flag_3

		flag_3 = _get_side_name == get_side_close_to_winning or not flag_2 or "close_to_win" or "time_is_running_out"

		combat_music:set_group_state("versus_state", flag_3)
	elseif not flag then
		combat_music:set_group_state("versus_state", "match_on")
	else
		combat_music:set_group_state("versus_state", "normal")
	end
end

MusicManager.register_active_player = function (self, arg_49_1)
	-- function 49
	fn("register_active_player")
	fassert(not self._active_local_player_id, "Active player %q already registered!", arg_49_1)

	self._active_local_player_id = arg_49_1
	self._player = nil
end

MusicManager.unregister_active_player = function (self, arg_50_1)
	-- function 50
	fn("unregister_active_player")
	fassert(self._active_local_player_id == arg_50_1, "Trying to unregister player %q when player %q is active player", arg_50_1, self._player_id)

	self._active_local_player_id = nil
	self._player = nil
end

MusicManager.set_music_group_state = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	local _game_object_id = self._game_object_id

	if not self._is_server then
		if not _game_object_id then
			local flag = type(arg_51_3) ~= "table" or not arg_51_3 or NetworkLookup.music_group_states[arg_51_3]
			local game = Managers.state.network:game()

			GameSession.set_game_object_field(game, _game_object_id, arg_51_2, flag)
		else
			local _override_init_fields = self._override_init_fields

			_override_init_fields = _override_init_fields or {}
			self._override_init_fields = _override_init_fields
			self._override_init_fields[arg_51_2] = arg_51_3
		end
	end
end

MusicManager.music_trigger = function (self, arg_52_1, arg_52_2)
	-- function 52
	fn("music_trigger")
	self._music_players[arg_52_1]:post_trigger(arg_52_2)
end

MusicManager.set_music_volume = function (self, arg_53_1)
	-- function 53
	WwiseWorld.set_global_parameter(self._wwise_world, "music_bus_volume", arg_53_1)
end

MusicManager.set_master_volume = function (self, arg_54_1)
	-- function 54
	WwiseWorld.set_global_parameter(self._wwise_world, "master_bus_volume", arg_54_1)
end

MusicManager.set_panning_rule = function (arg_55_0, arg_55_1)
	-- function 55
	fassert(MusicManager.panning_rules[arg_55_1] ~= nil, "[MusicManager] Panning rule does not exist: %q", arg_55_1)
	Wwise.set_panning_rule(MusicManager.panning_rules[arg_55_1])
end

MusicManager.is_playing = function (self, arg_56_1)
	-- function 56
	return WwiseWorld.is_playing(self._wwise_world, arg_56_1)
end

MusicManager.delay_trigger_horde_dialogue = function (self, arg_57_1, arg_57_2, arg_57_3)
	-- function 57
	if arg_57_2 ~= nil then
		self._horde_delay = arg_57_2
		self._horde_type = arg_57_3
	end

	if not (self._horde_delay == nil or not (arg_57_1 > self._horde_delay)) then
		MusicManager:trigger_horde_dialogue(self._horde_type)

		self._horde_delay = nil
		self._horde_type = nil
	end
end

MusicManager.trigger_horde_dialogue = function (arg_58_0, arg_58_1)
	-- function 58
	local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

	if not get_random_player then
		SurroundingAwareSystem.add_event(get_random_player, "horde", DialogueSettings.discover_enemy_attack_distance, "horde_type", arg_58_1)
	end
end

MusicManager._get_player = function (self)
	-- function 59
	if not self._player then
		return self._player
	end

	if not self._active_local_player_id then
		return
	end

	self._player = Managers.player:local_player(self._active_local_player_id)

	if not self._player and not self._player and not self._player.bot_player then
		return
	end

	return self._player
end

MusicManager._get_party = function (self)
	-- function 60
	if not self._party then
		return self._party
	end

	local _get_player = self:_get_player()

	self._party = self._party_manager:get_party_from_unique_id(_get_player:unique_id())

	return self._party
end

MusicManager._get_side_name = function (self)
	-- function 61
	if not self._side then
		return self._side:name()
	end

	local _get_party = self:_get_party()

	self._side = self._side_manager.side_by_party[_get_party]

	local _side = self._side

	_side = not _side and self._side:name()

	return _side
end

MusicManager.on_player_party_changed = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	-- function 62
	if not arg_62_2 then
		return
	end

	self._party = self._party_manager:get_party(arg_62_4)
	self._side = self._side_manager.side_by_party[self._party]
end

MusicManager.versus_update_sides = function (self)
	-- function 63
	if not DEDICATED_SERVER then
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
