-- chunkname: @scripts/managers/music/music_manager.lua

require("scripts/settings/music_settings")
require("scripts/managers/music/music_player")

local function var_0_0(...)
	if script_data.debug_music then
		print("[MusicManager] ", ...)
	end
end

MusicManager = class(MusicManager)
MusicManager.bus_transition_functions = {
	linear = function (arg_2_0, arg_2_1)
		return math.lerp(arg_2_0.start_value, arg_2_0.target_value, arg_2_1)
	end,
	sine = function (arg_3_0, arg_3_1)
		return math.lerp(arg_3_0.start_value, arg_3_0.target_value, math.sin(arg_3_1 * math.pi * 0.5))
	end,
	smoothstep = function (arg_4_0, arg_4_1)
		return math.lerp(arg_4_0.start_value, arg_4_0.target_value, math.smoothstep(arg_4_1, 0, 1))
	end
}
MusicManager.panning_rules = {
	PANNING_RULE_SPEAKERS = 0,
	PANNING_RULE_HEADPHONES = 1
}

MusicManager.init = function (arg_5_0)
	var_0_0("init")

	if GLOBAL_MUSIC_WORLD then
		arg_5_0._world = MUSIC_WORLD
		arg_5_0._wwise_world = MUSIC_WWISE_WORLD
	else
		arg_5_0._world = Managers.world:create_world("music_world", nil, nil, nil, Application.DISABLE_PHYSICS, Application.DISABLE_RENDERING)
		arg_5_0._wwise_world = Managers.world:wwise_world(arg_5_0._world)

		ScriptWorld.deactivate(arg_5_0._world)
	end

	arg_5_0._music_players = {}
	arg_5_0._duck_sounds_stack = 0

	arg_5_0:_update_window_focus()

	arg_5_0._bus_transitions = {}
	arg_5_0._flags = {}
	arg_5_0._game_states = {}
	arg_5_0._game_object_id = nil
	arg_5_0._group_states = {}
	arg_5_0._scream_delays = {}
	arg_5_0._current_horde_sound_settings = {}
	arg_5_0._event_queues = {}

	local var_5_0 = Application.user_setting("master_bus_volume")

	if var_5_0 ~= nil then
		arg_5_0:set_master_volume(var_5_0)
	end

	local var_5_1 = Application.user_setting("music_bus_volume")

	if var_5_1 ~= nil then
		arg_5_0:set_music_volume(var_5_1)
	end

	local var_5_2 = Application.user_setting("sound_panning_rule")

	if var_5_2 ~= nil then
		local var_5_3 = var_5_2 == "headphones" and "PANNING_RULE_HEADPHONES" or "PANNING_RULE_SPEAKERS"

		arg_5_0:set_panning_rule(var_5_3)
	end

	local var_5_4 = Application.user_setting("sound_channel_configuration")

	if not DEDICATED_SERVER then
		Wwise.set_bus_config("ingame_mastering_channel", var_5_4)
	end
end

MusicManager.duck_sounds = function (arg_6_0)
	if arg_6_0._duck_sounds_stack == 0 then
		arg_6_0:trigger_event("hud_in_inventory_state_on")
	end

	arg_6_0._duck_sounds_stack = arg_6_0._duck_sounds_stack + 1
end

MusicManager.unduck_sounds = function (arg_7_0, arg_7_1)
	if arg_7_0._duck_sounds_stack == 1 or arg_7_1 then
		arg_7_0:trigger_event("hud_in_inventory_state_off")
	end

	arg_7_0._duck_sounds_stack = arg_7_1 and 0 or math.max(0, arg_7_0._duck_sounds_stack - 1)
end

MusicManager._update_window_focus = function (arg_8_0)
	if not DEDICATED_SERVER then
		local var_8_0 = Window.has_focus()

		if var_8_0 ~= arg_8_0._has_focus then
			if var_8_0 then
				arg_8_0:trigger_event("unmute_all")
			elseif Application.user_setting("mute_in_background") then
				arg_8_0:trigger_event("mute_all")
			end

			arg_8_0._has_focus = var_8_0
		end
	end
end

MusicManager.stop_all_sounds = function (arg_9_0)
	var_0_0("stop_all_sounds")
	arg_9_0._wwise_world:stop_all()
end

MusicManager.stop_event_id = function (arg_10_0, arg_10_1)
	var_0_0("stop_event_id")

	if arg_10_0._wwise_world:is_playing(arg_10_1) then
		arg_10_0._wwise_world:stop_event(arg_10_1)
	end
end

MusicManager.trigger_event = function (arg_11_0, arg_11_1)
	var_0_0("trigger_event", arg_11_1)

	local var_11_0 = arg_11_0._wwise_world
	local var_11_1, var_11_2 = WwiseWorld.trigger_event(var_11_0, arg_11_1)

	var_0_0("MUSIC MANAGER", arg_11_1, var_11_1, var_11_2)

	return var_11_1, var_11_2
end

MusicManager.trigger_event_queue = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	fassert(not arg_12_0._event_queues[arg_12_1], "[MusicManager:trigger_event_queue] There is already an event queue playing with that name")

	local var_12_0 = 1
	local var_12_1 = arg_12_2[1]
	local var_12_2, var_12_3 = arg_12_0:trigger_event(var_12_1)

	arg_12_0._event_queues[arg_12_1] = {
		delay = arg_12_3 or 0.5,
		event_index = var_12_0,
		wwise_playing_id = var_12_2,
		wwise_source_id = var_12_3,
		event_queue = arg_12_2
	}
end

MusicManager.update = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Managers.state.conflict

	if var_13_0 then
		if arg_13_0._is_server then
			arg_13_0:_update_flag_in_combat(var_13_0)
			arg_13_0:_update_combat_intensity(var_13_0)
			arg_13_0:_update_boss_state(var_13_0)
			arg_13_0:_update_game_state(arg_13_1, arg_13_2, var_13_0)
		end

		arg_13_0:_update_boss_state(var_13_0)

		if not DEDICATED_SERVER then
			arg_13_0:_update_boss_music_intensity(var_13_0)
		end
	end

	if not DEDICATED_SERVER then
		arg_13_0:_update_player_state(arg_13_1, arg_13_2)
		arg_13_0:_update_career_state(arg_13_1, arg_13_2)
		arg_13_0:_update_enemy_aggro_state(arg_13_1, arg_13_2)
		arg_13_0:_update_game_mode(arg_13_1, arg_13_2)
		arg_13_0:_update_side_state(arg_13_1, arg_13_2)
		arg_13_0:_update_window_focus()
	end

	arg_13_0:_update_flags()
	arg_13_0:_handle_event_queues(arg_13_1, arg_13_2)

	local var_13_1 = arg_13_0._flags

	for iter_13_0, iter_13_1 in pairs(arg_13_0._music_players) do
		iter_13_1:update(var_13_1, arg_13_0._game_object_id, arg_13_0._is_ingame)
	end
end

local var_0_1 = {}

MusicManager._handle_event_queues = function (arg_14_0, arg_14_1, arg_14_2)
	table.clear(var_0_1)

	for iter_14_0, iter_14_1 in pairs(arg_14_0._event_queues) do
		local var_14_0 = iter_14_1.wwise_playing_id

		if not arg_14_0:is_playing(var_14_0) then
			if not iter_14_1.current_delay then
				iter_14_1.current_delay = arg_14_2 + iter_14_1.delay
			elseif arg_14_2 > iter_14_1.current_delay then
				local var_14_1 = iter_14_1.event_queue
				local var_14_2 = iter_14_1.event_index + 1
				local var_14_3 = var_14_1[var_14_2]

				if var_14_3 then
					local var_14_4, var_14_5 = arg_14_0:trigger_event(var_14_3)

					iter_14_1.event_index = var_14_2
					iter_14_1.wwise_playing_id = var_14_4
					iter_14_1.wwise_source_id = var_14_5
					iter_14_1.current_delay = nil
				else
					var_0_1[#var_0_1 + 1] = iter_14_0
				end
			end
		end
	end

	for iter_14_2, iter_14_3 in ipairs(var_0_1) do
		arg_14_0:stop_event_queue(iter_14_3)
	end
end

MusicManager.stop_event_queue = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._event_queues[arg_15_1]

	if not var_15_0 then
		return
	end

	local var_15_1 = var_15_0.wwise_playing_id

	if arg_15_0:is_playing(var_15_1) then
		arg_15_0:stop_event_id(var_15_1)
	end

	arg_15_0._event_queues[arg_15_1] = nil
end

MusicManager.destroy = function (arg_16_0)
	var_0_0("DESTROY")

	if not GLOBAL_MUSIC_WORLD then
		Application.release_world(arg_16_0._world)
	end

	arg_16_0:_unregister_events()
end

MusicManager.on_enter_level = function (arg_17_0, arg_17_1, arg_17_2)
	var_0_0("on_enter_level")

	arg_17_0._network_event_delegate = arg_17_1

	if arg_17_2 then
		local var_17_0 = NetworkLookup.go_types.music_states
		local var_17_1 = NetworkLookup.music_group_states.low_battle
		local var_17_2 = NetworkLookup.music_group_states.explore
		local var_17_3 = NetworkLookup.music_group_states.no_boss
		local var_17_4 = NetworkLookup.music_group_states.None
		local var_17_5 = Managers.mechanism:game_mechanism():get_state() == "weave" and NetworkLookup.music_group_states.winds or NetworkLookup.music_group_states["false"]
		local var_17_6 = {
			go_type = var_17_0,
			combat_intensity = var_17_1,
			boss_state = var_17_3,
			override = var_17_5,
			dlc_dwarf_fest = var_17_4
		}

		if arg_17_0._override_init_fields then
			for iter_17_0, iter_17_1 in pairs(arg_17_0._override_init_fields) do
				var_17_6[iter_17_0] = type(iter_17_1) == "table" and iter_17_1 or NetworkLookup.music_group_states[iter_17_1]
			end

			arg_17_0._override_init_fields = nil
		end

		local var_17_7 = Managers.party:parties()
		local var_17_8 = {}

		for iter_17_2, iter_17_3 in pairs(var_17_7) do
			var_17_8[iter_17_3.party_id] = var_17_2
		end

		var_17_6.game_state = var_17_8
		arg_17_0._game_states = var_17_8

		local var_17_9 = Managers.state.network.game_session

		fassert(not arg_17_0._game_object_id, "Creating game object when already exists")

		arg_17_0._game_object_id = Managers.state.network:create_game_object("music_states", var_17_6, function (arg_18_0)
			arg_17_0:server_game_session_disconnect_music_states(arg_18_0)
		end)
	end

	arg_17_0:_setup_level_music_players()
	arg_17_0:set_flag("in_level", true)

	arg_17_0._is_server = arg_17_2
	arg_17_0.last_man_standing = false
	arg_17_0._party_manager = Managers.party
	arg_17_0._side_manager = Managers.state.side

	arg_17_0:_register_events()
end

MusicManager.on_exit_level = function (arg_19_0)
	var_0_0("on_exit_level")
	arg_19_0:set_flag("in_level", false)
	arg_19_0:set_flag("in_combat", false)
	arg_19_0:_reset_level_music_players()
	arg_19_0._network_event_delegate:unregister(arg_19_0)

	arg_19_0._network_event_delegate = nil
	arg_19_0._is_server = false
	arg_19_0.last_man_standing = false

	arg_19_0:_unregister_events()
end

MusicManager._register_events = function (arg_20_0)
	local var_20_0 = Managers.state.event

	if not var_20_0 then
		return
	end

	var_20_0:register(arg_20_0, "player_party_changed", "on_player_party_changed")
	var_20_0:register(arg_20_0, "versus_pre_start_initialized", "versus_update_sides")
end

MusicManager._unregister_events = function (arg_21_0)
	local var_21_0 = Managers.state.event

	if not var_21_0 then
		return
	end

	var_21_0:unregister("player_party_changed", arg_21_0)
	var_21_0:unregister("versus_pre_start_initialized", arg_21_0)
end

MusicManager.client_game_session_disconnect_music_states = function (arg_22_0, arg_22_1)
	return
end

MusicManager.server_game_session_disconnect_music_states = function (arg_23_0, arg_23_1)
	arg_23_0:game_object_destroyed(arg_23_1, arg_23_0._owner_id, arg_23_0._go_template)
end

MusicManager.game_object_created = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	var_0_0("game_object_created")

	arg_24_0._game_object_id = arg_24_1
	arg_24_0._owner_id = arg_24_2
	arg_24_0._go_template = arg_24_3
end

MusicManager.game_object_destroyed = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	var_0_0("game_object_destroyed")
	Application.warning("[MusicManager:game_object_destroyed] Removed go_template == self._go_template check due to crash")

	arg_25_0._game_object_id = nil
	arg_25_0._owner_id = nil
	arg_25_0._go_template = nil
end

MusicManager._update_flags = function (arg_26_0)
	arg_26_0:set_flag("combat_music_enabled", not script_data.debug_disable_combat_music)

	local var_26_0 = arg_26_0._game_object_id

	if arg_26_0._is_server or not var_26_0 then
		return
	end

	local var_26_1 = Managers.state.network:game()

	for iter_26_0, iter_26_1 in pairs(SyncedMusicFlags) do
		local var_26_2 = GameSession.game_object_field(var_26_1, var_26_0, iter_26_0)

		arg_26_0:set_flag(iter_26_0, var_26_2)
	end
end

MusicManager.set_flag = function (arg_27_0, arg_27_1, arg_27_2)
	if arg_27_0._flags[arg_27_1] == arg_27_2 then
		return
	end

	var_0_0("set_flag", arg_27_1, arg_27_2)

	arg_27_0._flags[arg_27_1] = arg_27_2

	if arg_27_0._is_server and SyncedMusicGroupFlags[arg_27_1] then
		local var_27_0 = Managers.state.network:game()

		GameSession.set_game_object_field(var_27_0, arg_27_0._game_object_id, arg_27_1, arg_27_2)
	end
end

MusicManager._setup_level_music_players = function (arg_28_0)
	var_0_0("_setup_level_music_players")

	local var_28_0 = MusicSettings

	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		if iter_28_1.ingame_only then
			local var_28_1 = iter_28_1.start_event
			local var_28_2 = iter_28_1.stop
			local var_28_3 = iter_28_1.set_flags
			local var_28_4 = iter_28_1.unset_flags
			local var_28_5 = iter_28_1.parameters
			local var_28_6 = iter_28_1.default_group_states
			local var_28_7 = iter_28_1.game_state_voice_thresholds
			local var_28_8 = MusicPlayer:new(arg_28_0._wwise_world, var_28_1, var_28_2, iter_28_0, var_28_3, var_28_4, var_28_5, var_28_6, var_28_7)

			arg_28_0._music_players[iter_28_0] = var_28_8
		end
	end
end

MusicManager._reset_level_music_players = function (arg_29_0)
	var_0_0("_reset_level_music_players")

	local var_29_0 = MusicSettings

	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		if iter_29_1.ingame_only then
			local var_29_1 = arg_29_0._music_players[iter_29_0]

			if var_29_1 then
				var_29_1:destroy()

				arg_29_0._music_players[iter_29_0] = nil
			end
		end
	end
end

MusicManager._number_of_aggroed_enemies = function (arg_30_0)
	return Managers.state.entity:system("ai_slot_system").num_total_enemies
end

MusicManager._update_flag_in_combat = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0:_number_of_aggroed_enemies()
	local var_31_1 = arg_31_1.pacing.total_intensity
	local var_31_2 = var_31_0 >= CombatMusic.minimum_enemies

	arg_31_0:set_flag("in_combat", var_31_2)
end

MusicManager._update_combat_intensity = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_1.pacing.total_intensity
	local var_32_1

	for iter_32_0, iter_32_1 in ipairs(IntensityThresholds) do
		if var_32_0 > iter_32_1.threshold then
			var_32_1 = iter_32_1.state
		end
	end

	if var_32_1 then
		arg_32_0:set_music_group_state("combat_music", "combat_intensity", var_32_1)
	end
end

MusicManager._update_boss_state = function (arg_33_0, arg_33_1)
	if not arg_33_0._music_players.combat_music then
		return
	end

	local var_33_0 = Managers.mechanism:current_mechanism_name() == "versus"
	local var_33_1

	if not var_33_0 then
		var_33_1 = (arg_33_1:angry_boss() or arg_33_1:boss_event_running()) and arg_33_0:_get_combat_music_state(arg_33_1) or "no_boss"
	else
		var_33_1 = arg_33_0:_get_versus_combat_music_state()
	end

	arg_33_0:set_music_group_state("combat_music", "boss_state", var_33_1)
end

MusicManager._get_versus_combat_music_state = function (arg_34_0)
	local var_34_0 = Managers.state.side:get_side(2).PLAYER_AND_BOT_UNITS
	local var_34_1 = "no_boss"

	for iter_34_0 = 1, #var_34_0 do
		local var_34_2 = Unit.get_data(var_34_0[iter_34_0], "breed")

		if var_34_2.boss then
			var_34_1 = var_34_2.combat_music_state

			break
		end
	end

	return var_34_1
end

MusicManager._get_combat_music_state = function (arg_35_0, arg_35_1)
	local var_35_0 = "rat_ogre"
	local var_35_1 = arg_35_1:alive_bosses()
	local var_35_2 = BLACKBOARDS

	for iter_35_0 = #var_35_1, 1, -1 do
		local var_35_3 = var_35_2[var_35_1[iter_35_0]]

		if var_35_3 and var_35_3.is_angry then
			local var_35_4 = var_35_3.breed

			var_35_0 = var_35_4.combat_music_state or var_35_0

			if var_35_4.combat_music_state ~= "no_boss" then
				break
			end
		end
	end

	return var_35_0
end

MusicManager._update_boss_music_intensity = function (arg_36_0, arg_36_1)
	local var_36_0 = BossFightMusicIntensity.default_state
	local var_36_1 = BossFightMusicIntensity.group_name
	local var_36_2 = arg_36_0:_get_player()

	if var_36_2 then
		local var_36_3 = var_36_2.player_unit

		if Unit.alive(var_36_3) then
			local var_36_4 = Unit.local_position(var_36_3, 0)
			local var_36_5 = arg_36_1:alive_bosses()
			local var_36_6 = FrameTable.alloc_table()

			for iter_36_0, iter_36_1 in pairs(BossFightMusicIntensity.additional_contributing_units) do
				table.append_non_indexed(var_36_6, arg_36_1:spawned_units_by_breed(iter_36_1))
			end

			local var_36_7 = math.huge

			for iter_36_2, iter_36_3 in pairs(var_36_5) do
				local var_36_8 = Unit.local_position(iter_36_3, 0)
				local var_36_9 = Vector3.distance_squared(var_36_4, var_36_8)

				var_36_7 = var_36_9 < var_36_7 and var_36_9 or var_36_7
			end

			for iter_36_4, iter_36_5 in pairs(var_36_6) do
				local var_36_10 = Unit.local_position(iter_36_5, 0)
				local var_36_11 = Vector3.distance_squared(var_36_4, var_36_10)

				var_36_7 = var_36_11 < var_36_7 and var_36_11 or var_36_7
			end

			for iter_36_6, iter_36_7 in ipairs(BossFightMusicIntensity) do
				if var_36_7 < iter_36_7.max_distance^2 then
					var_36_0 = iter_36_7.state

					break
				end
			end
		end
	end

	arg_36_0:set_wwise_state(var_36_1, var_36_0)
end

MusicManager.set_wwise_state = function (arg_37_0, arg_37_1, arg_37_2)
	arg_37_0._group_states[arg_37_1] = arg_37_0._group_states[arg_37_1] or nil

	if arg_37_2 ~= arg_37_0._group_states[arg_37_1] then
		Wwise.set_state(arg_37_1, arg_37_2)
	end

	arg_37_0._group_states[arg_37_1] = arg_37_2
end

MusicManager.check_last_man_standing_music_state = function (arg_38_0)
	local var_38_0 = Managers.player

	if var_38_0:num_players() == 1 then
		arg_38_0.last_man_standing = false

		return
	end

	local var_38_1 = arg_38_0:_get_player()
	local var_38_2 = var_38_1 and var_38_1.player_unit

	if Unit.alive(var_38_2) then
		local var_38_3 = ScriptUnit.has_extension(var_38_2, "status_system")

		if var_38_3 and not var_38_3:is_disabled() then
			local var_38_4 = var_38_0:num_alive_allies(var_38_1) == 0

			arg_38_0.last_man_standing = var_38_4

			if var_38_4 and ScriptUnit.has_extension(var_38_2, "dialogue_system") then
				local var_38_5 = ScriptUnit.extension_input(var_38_2, "dialogue_system")
				local var_38_6 = FrameTable.alloc_table()

				var_38_5:trigger_dialogue_event("last_hero_standing", var_38_6)
			end
		else
			arg_38_0.last_man_standing = false
		end
	else
		arg_38_0.last_man_standing = false
	end
end

local function var_0_2(arg_39_0, arg_39_1)
	return arg_39_1.music_states[arg_39_0] or arg_39_0
end

local var_0_3 = {
	pre_ambush = true,
	pre_horde = true,
	ambush = true,
	horde = true
}

MusicManager._update_game_state = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = Managers.party:parties()
	local var_40_1

	for iter_40_0, iter_40_1 in pairs(var_40_0) do
		local var_40_2 = iter_40_1.occupied_slots[1]
		local var_40_3 = iter_40_1.party_id

		if var_40_2 and iter_40_1.name ~= "undecided" then
			local var_40_4 = var_40_2.player
			local var_40_5 = arg_40_0._game_states[var_40_3]
			local var_40_6 = NetworkLookup.music_group_states[var_40_5]
			local var_40_7 = arg_40_0:_get_game_state_for_player(arg_40_1, arg_40_2, arg_40_3, var_40_3, var_40_6, var_40_4)

			if var_40_7 ~= var_40_6 then
				local var_40_8

				if arg_40_0._current_horde_sound_settings[var_40_3] and var_0_3[var_40_7] then
					var_40_8 = var_0_2(var_40_7, arg_40_0._current_horde_sound_settings[var_40_3])
				else
					var_40_8 = var_40_7
				end

				arg_40_0._game_states[var_40_3] = NetworkLookup.music_group_states[var_40_8]
				var_40_1 = true
			end
		end
	end

	if var_40_1 then
		arg_40_0:set_music_group_state("combat_music", "game_state", arg_40_0._game_states)
	end
end

MusicManager._get_game_state_for_player = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	local var_41_0 = Managers.state.game_mode
	local var_41_1 = var_41_0:game_mode():is_about_to_end_game_early()
	local var_41_2 = var_41_0:game_mode_key()
	local var_41_3 = var_41_2 == "survival"

	if var_41_1 then
		if var_41_3 then
			return "survival_lost"
		elseif var_41_0:game_won(arg_41_6) then
			local var_41_4 = Managers.weave

			if var_41_4:get_active_weave() and var_41_4:get_active_weave() == 2 then
				return "won_between_winds"
			end

			local var_41_5 = LevelHelper:current_level_settings()

			return var_41_5 and var_41_5.music_won_state or "won"
		elseif var_41_0:game_lost(arg_41_6) then
			return "lost"
		elseif var_41_2 == "versus" and Managers.mechanism:get_state() == "round_1" then
			return "draw"
		end

		return arg_41_5
	end

	if var_41_0:game_won(arg_41_6) then
		local var_41_6 = Managers.weave

		if var_41_6:get_active_weave() and var_41_6:get_active_weave() == 2 then
			return "won_between_winds"
		end

		local var_41_7 = LevelHelper:current_level_settings()

		return var_41_7 and var_41_7.music_won_state or "won"
	end

	local var_41_8 = arg_41_5 == "pre_horde" or arg_41_5 == "pre_ambush" or arg_41_5 == "pre_ambush_beastmen" or arg_41_5 == "pre_ambush_chaos"
	local var_41_9, var_41_10, var_41_11 = arg_41_3:is_horde_alive()

	if var_41_8 and arg_41_0._scream_delays[arg_41_4] and arg_41_2 > arg_41_0._scream_delays[arg_41_4] then
		arg_41_0._scream_delays[arg_41_4] = nil

		return "horde"
	elseif var_41_8 and not arg_41_0._scream_delays[arg_41_4] and arg_41_0:_horde_done_spawning(var_41_10) then
		if var_41_10 == "ambush" then
			arg_41_0:delay_trigger_horde_dialogue(arg_41_2, arg_41_2 + DialogueSettings.ambush_delay, "ambush")

			arg_41_0._scream_delays[arg_41_4] = arg_41_2 + 1.5

			return arg_41_5
		else
			return "horde"
		end
	elseif var_41_8 and var_41_9 then
		arg_41_0:delay_trigger_horde_dialogue(arg_41_2)

		return arg_41_5
	elseif (arg_41_5 == "horde" or arg_41_5 == "horde_beastmen" or arg_41_5 == "horde_chaos") and var_41_9 then
		arg_41_0:delay_trigger_horde_dialogue(arg_41_2)

		return "horde"
	elseif var_41_10 == "vector" or var_41_10 == "vector_blob" or var_41_10 == "event" then
		arg_41_0:delay_trigger_horde_dialogue(arg_41_2, arg_41_2 + DialogueSettings.vector_delay, "vector")

		arg_41_0._current_horde_sound_settings[arg_41_4] = var_41_11

		return "pre_horde"
	elseif var_41_10 == "ambush" then
		arg_41_0._current_horde_sound_settings[arg_41_4] = var_41_11

		return "pre_ambush"
	end

	return "explore"
end

local var_0_4 = {}

MusicManager._horde_done_spawning = function (arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1 == "ambush" and 25 or 25
	local var_42_1
	local var_42_2 = Managers.player:players()

	for iter_42_0, iter_42_1 in pairs(var_42_2) do
		local var_42_3 = iter_42_1.player_unit

		if Unit.alive(var_42_3) then
			local var_42_4 = Unit.local_position(var_42_3, 0)
			local var_42_5 = AiUtils.broadphase_query(var_42_4, var_42_0, var_0_4)

			for iter_42_2 = 1, var_42_5 do
				local var_42_6 = var_0_4[iter_42_2]
				local var_42_7 = ScriptUnit.extension(var_42_6, "ai_system"):blackboard().spawn_type

				if (var_42_7 == "horde_hidden" or var_42_7 == "horde") and HEALTH_ALIVE[var_42_6] then
					return true
				end
			end
		end
	end

	return false
end

MusicManager._update_player_state = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0._music_players.combat_music

	if var_43_0 then
		local var_43_1 = arg_43_0:_get_player().player_unit
		local var_43_2

		if Unit.alive(var_43_1) then
			local var_43_3 = ScriptUnit.extension(var_43_1, "status_system")
			local var_43_4 = Managers.state.game_mode:game_mode():is_about_to_end_game_early() and "normal" or var_43_3:is_ready_for_assisted_respawn() and "normal" or var_43_3:is_dead() and "dead" or var_43_3:is_knocked_down() and "knocked_down" or var_43_3:is_in_vortex() and "normal" or var_43_3:is_disabled() and not var_43_3:is_grabbed_by_chaos_spawn() and not var_43_3:is_grabbed_by_corruptor() and "need_help" or arg_43_0.last_man_standing and "last_man_standing" or var_43_3.get_in_ghost_mode and var_43_3:get_in_ghost_mode() and "ghost" or "normal"

			var_43_0:set_group_state("player_state", var_43_4)
		else
			local var_43_5 = arg_43_0:_get_side_name() == "dark_pact" and "dead" or "normal"

			var_43_0:set_group_state("player_state", var_43_5)
		end
	elseif var_43_0 then
		var_43_0:set_group_state("player_state", "normal")
	end
end

MusicManager._update_career_state = function (arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0._music_players.combat_music
	local var_44_1 = arg_44_0:_get_player()
	local var_44_2 = "default"

	if var_44_1 then
		local var_44_3 = var_44_1.player_unit

		if Unit.alive(var_44_3) then
			var_44_2 = ScriptUnit.extension(var_44_3, "career_system"):get_state()
		end
	end

	if var_44_0 then
		var_44_0:set_group_state("career_state", var_44_2)
	end
end

MusicManager._update_enemy_aggro_state = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0._music_players.combat_music
	local var_45_1 = arg_45_0._active_local_player_id

	if var_45_0 and var_45_1 then
		local var_45_2 = arg_45_0:_get_player()
		local var_45_3 = var_45_2 and var_45_2.player_unit

		if Unit.alive(var_45_3) then
			local var_45_4 = ScriptUnit.extension(var_45_3, "sound_effect_system"):get_music_aggro_state()

			var_45_0:set_group_state("music_target_aggro", var_45_4)
		else
			var_45_0:set_group_state("music_target_aggro", "husk")
		end
	elseif var_45_0 then
		var_45_0:set_group_state("music_target_aggro", "husk")
	end
end

MusicManager._update_game_mode = function (arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_0._music_players.combat_music

	if var_46_0 then
		local var_46_1 = Managers.mechanism:current_mechanism_name()

		var_46_0:set_group_state("game_mode", var_46_1)

		if var_46_1 == "adventure" then
			-- Nothing
		elseif var_46_1 == "versus" then
			arg_46_0:_update_versus_game_state(var_46_0, arg_46_1, arg_46_2)
		else
			fassert("Non-supported game mode '%s'", var_46_1)
		end
	end
end

MusicManager._update_side_state = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._music_players.combat_music

	if not var_47_0 or not arg_47_0._active_local_player_id then
		return
	end

	local var_47_1 = arg_47_0:_get_player()

	if not var_47_1 then
		return
	end

	if not var_47_1.player_unit or not Unit.alive(var_47_1.player_unit) then
		local var_47_2 = Managers.party:get_local_player_party()

		if var_47_2 and var_47_2.name then
			var_47_0:set_group_state("game_faction", var_47_2.name)

			return
		else
			return
		end
	end

	local var_47_3 = arg_47_0:_get_side_name()

	if var_47_3 then
		var_47_0:set_group_state("game_faction", var_47_3)
	end
end

MusicManager._update_versus_game_state = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = arg_48_0._music_players.combat_music

	if not var_48_0 or not arg_48_0._active_local_player_id then
		return
	end

	local var_48_1 = arg_48_0:_get_player()

	if not var_48_1 then
		return
	end

	local var_48_2 = arg_48_0:_get_side_name()
	local var_48_3 = var_48_2 == "dark_pact"

	if var_48_3 then
		local var_48_4 = arg_48_0._party_manager:get_status_from_unique_id(var_48_1:unique_id()).profile_id

		var_48_0:set_group_state("pactsworn_character", var_48_4)
	end

	local var_48_5 = Managers.state.game_mode
	local var_48_6 = var_48_5:game_mode()
	local var_48_7 = var_48_5:game_mode_key()
	local var_48_8 = var_48_6:game_mode_state()

	if var_48_7 == "inn_vs" or var_48_6.is_in_pre_match_state and var_48_6:is_in_pre_match_state() then
		var_48_0:set_group_state("versus_state", "menu")

		return
	end

	if var_48_8 == "player_team_parading_state" then
		var_48_0:set_group_state("versus_state", "intro")

		return
	end

	if not var_48_5:is_round_started() or var_48_5:is_game_mode_ended() then
		var_48_0:set_group_state("versus_state", "normal")

		return
	end

	local var_48_9 = Managers.mechanism:game_mechanism():win_conditions()
	local var_48_10 = var_48_9:get_side_close_to_winning()
	local var_48_11 = var_48_9:heroes_close_to_safe_zone()

	if var_48_10 or var_48_11 then
		local var_48_12
		local var_48_13 = var_48_11 and var_48_2 == "heroes"
		local var_48_14 = (var_48_2 == var_48_10 or var_48_13) and "close_to_win" or "time_is_running_out"

		var_48_0:set_group_state("versus_state", var_48_14)
	elseif var_48_3 then
		var_48_0:set_group_state("versus_state", "match_on")
	else
		var_48_0:set_group_state("versus_state", "normal")
	end
end

MusicManager.register_active_player = function (arg_49_0, arg_49_1)
	var_0_0("register_active_player")
	fassert(not arg_49_0._active_local_player_id, "Active player %q already registered!", arg_49_1)

	arg_49_0._active_local_player_id = arg_49_1
	arg_49_0._player = nil
end

MusicManager.unregister_active_player = function (arg_50_0, arg_50_1)
	var_0_0("unregister_active_player")
	fassert(arg_50_0._active_local_player_id == arg_50_1, "Trying to unregister player %q when player %q is active player", arg_50_1, arg_50_0._player_id)

	arg_50_0._active_local_player_id = nil
	arg_50_0._player = nil
end

MusicManager.set_music_group_state = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = arg_51_0._game_object_id

	if arg_51_0._is_server then
		if var_51_0 then
			local var_51_1 = type(arg_51_3) == "table" and arg_51_3 or NetworkLookup.music_group_states[arg_51_3]
			local var_51_2 = Managers.state.network:game()

			GameSession.set_game_object_field(var_51_2, var_51_0, arg_51_2, var_51_1)
		else
			arg_51_0._override_init_fields = arg_51_0._override_init_fields or {}
			arg_51_0._override_init_fields[arg_51_2] = arg_51_3
		end
	end
end

MusicManager.music_trigger = function (arg_52_0, arg_52_1, arg_52_2)
	var_0_0("music_trigger")
	arg_52_0._music_players[arg_52_1]:post_trigger(arg_52_2)
end

MusicManager.set_music_volume = function (arg_53_0, arg_53_1)
	WwiseWorld.set_global_parameter(arg_53_0._wwise_world, "music_bus_volume", arg_53_1)
end

MusicManager.set_master_volume = function (arg_54_0, arg_54_1)
	WwiseWorld.set_global_parameter(arg_54_0._wwise_world, "master_bus_volume", arg_54_1)
end

MusicManager.set_panning_rule = function (arg_55_0, arg_55_1)
	fassert(MusicManager.panning_rules[arg_55_1] ~= nil, "[MusicManager] Panning rule does not exist: %q", arg_55_1)
	Wwise.set_panning_rule(MusicManager.panning_rules[arg_55_1])
end

MusicManager.is_playing = function (arg_56_0, arg_56_1)
	return WwiseWorld.is_playing(arg_56_0._wwise_world, arg_56_1)
end

MusicManager.delay_trigger_horde_dialogue = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	if arg_57_2 ~= nil then
		arg_57_0._horde_delay = arg_57_2
		arg_57_0._horde_type = arg_57_3
	end

	if arg_57_0._horde_delay ~= nil and arg_57_1 > arg_57_0._horde_delay then
		MusicManager:trigger_horde_dialogue(arg_57_0._horde_type)

		arg_57_0._horde_delay = nil
		arg_57_0._horde_type = nil
	end
end

MusicManager.trigger_horde_dialogue = function (arg_58_0, arg_58_1)
	local var_58_0 = Managers.state.entity:system("dialogue_system"):get_random_player()

	if var_58_0 then
		SurroundingAwareSystem.add_event(var_58_0, "horde", DialogueSettings.discover_enemy_attack_distance, "horde_type", arg_58_1)
	end
end

MusicManager._get_player = function (arg_59_0)
	if arg_59_0._player then
		return arg_59_0._player
	end

	if not arg_59_0._active_local_player_id then
		return
	end

	arg_59_0._player = Managers.player:local_player(arg_59_0._active_local_player_id)

	if not arg_59_0._player or arg_59_0._player and arg_59_0._player.bot_player then
		return
	end

	return arg_59_0._player
end

MusicManager._get_party = function (arg_60_0)
	if arg_60_0._party then
		return arg_60_0._party
	end

	local var_60_0 = arg_60_0:_get_player()

	arg_60_0._party = arg_60_0._party_manager:get_party_from_unique_id(var_60_0:unique_id())

	return arg_60_0._party
end

MusicManager._get_side_name = function (arg_61_0)
	if arg_61_0._side then
		return arg_61_0._side:name()
	end

	local var_61_0 = arg_61_0:_get_party()

	arg_61_0._side = arg_61_0._side_manager.side_by_party[var_61_0]

	return arg_61_0._side and arg_61_0._side:name()
end

MusicManager.on_player_party_changed = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	if not arg_62_2 then
		return
	end

	arg_62_0._party = arg_62_0._party_manager:get_party(arg_62_4)
	arg_62_0._side = arg_62_0._side_manager.side_by_party[arg_62_0._party]
end

MusicManager.versus_update_sides = function (arg_63_0)
	if DEDICATED_SERVER then
		return
	end

	arg_63_0._side_manager = Managers.state.side
	arg_63_0._side = arg_63_0._side_manager.side_by_party[arg_63_0._party]
end

MusicManager.on_enter_game = function (arg_64_0)
	arg_64_0._is_ingame = true
end

MusicManager.on_exit_game = function (arg_65_0)
	arg_65_0._is_ingame = false
end
