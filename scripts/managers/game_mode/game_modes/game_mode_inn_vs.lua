-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_inn_vs.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/admin/dedicated_server_commands")
require("scripts/managers/game_mode/spawning_components/simple_spawning")

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")
local var_0_1 = false
local var_0_2 = false

GameModeInnVs = class(GameModeInnVs, GameModeBase)

GameModeInnVs.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, ...)
	GameModeInnVs.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, ...)

	arg_1_0._mechanism = Managers.mechanism:game_mechanism()
	arg_1_0._adventure_profile_rules = AdventureProfileRules:new(arg_1_0._profile_synchronizer, arg_1_0._network_server)

	if DEDICATED_SERVER then
		arg_1_0._auto_force_start_time = math.huge

		Managers.state.event:register(arg_1_0, "game_server_unreserve_party_slot", "on_game_server_unreserve_party_slot")
	else
		local var_1_0 = true

		arg_1_0._simple_spawning = SimpleSpawning:new(arg_1_0._profile_synchronizer, var_1_0)

		Managers.state.event:register(arg_1_0, "level_start_local_player_spawned", "event_local_player_spawned")
	end

	if arg_1_0._is_server then
		arg_1_0._lobby_host = arg_1_3.lobby_host
	end

	if arg_1_0._mechanism:is_hosting_versus_custom_game() then
		arg_1_0._mechanism:set_is_hosting_versus_custom_game(false)
	end

	if not DEDICATED_SERVER then
		arg_1_0._mechanism:set_custom_game_settings_handler_enabled(false)
	end
end

GameModeInnVs.destroy = function (arg_2_0)
	if DEDICATED_SERVER then
		Managers.state.event:unregister("game_server_unreserve_party_slot", arg_2_0)
	end
end

GameModeInnVs.register_rpcs = function (arg_3_0, arg_3_1, arg_3_2)
	GameModeInnVs.super.register_rpcs(arg_3_0, arg_3_1, arg_3_2)

	if arg_3_0._simple_spawning then
		arg_3_0._simple_spawning:register_rpcs(arg_3_1, arg_3_2)
	end
end

GameModeInnVs.unregister_rpcs = function (arg_4_0)
	GameModeInnVs.super.unregister_rpcs(arg_4_0)

	if arg_4_0._simple_spawning then
		arg_4_0._simple_spawning:unregister_rpcs()
	end
end

GameModeInnVs.local_player_ready_to_start = function (arg_5_0)
	return arg_5_0._game_mode_state ~= "initial_state"
end

GameModeInnVs.local_player_game_starts = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.show_profile_on_startup

	arg_6_2.show_profile_on_startup = nil

	if var_6_0 and not LEVEL_EDITOR_TEST and not Development.parameter("skip-start-menu") then
		local var_6_1 = PLATFORM

		if IS_CONSOLE then
			Managers.ui:handle_transition("initial_character_selection_force", {
				menu_state_name = "character",
				on_exit_callback = callback(arg_6_0, "_cb_start_menu_closed")
			})
		elseif GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") then
			local var_6_2 = SaveData.first_hero_selection_made
			local var_6_3 = not Managers.backend:is_waiting_for_user_input() and not var_6_2

			Managers.ui:handle_transition("initial_start_menu_view_force", {
				menu_state_name = var_6_3 and "character" or "overview",
				on_exit_callback = callback(arg_6_0, "_cb_start_menu_closed")
			})
		else
			Managers.ui:handle_transition("initial_character_selection_force", {
				menu_state_name = "character",
				on_exit_callback = callback(arg_6_0, "_cb_start_menu_closed")
			})
		end
	else
		arg_6_0:_cb_start_menu_closed()
	end

	if arg_6_0._is_initial_spawn then
		LevelHelper:flow_event(arg_6_0._world, "local_player_spawned")

		if Development.parameter("attract_mode") then
			LevelHelper:flow_event(arg_6_0._world, "start_benchmark")
		else
			LevelHelper:flow_event(arg_6_0._world, "level_start_local_player_spawned")
		end
	end

	if not DEDICATED_SERVER and Development.parameter("vs_auto_search") then
		Managers.mechanism:request_vote({
			private_game = false,
			dedicated_servers_aws = true,
			player_hosted = false,
			dedicated_servers_win = false,
			request_type = "versus_quickplay",
			matchmaking_type = "standard",
			mechanism = "versus",
			quick_game = true,
			difficulty = "versus_base",
			join_method = "party"
		})
	end
end

GameModeInnVs._cb_start_menu_closed = function (arg_7_0)
	Managers.state.event:trigger("tutorial_trigger", "keep_menu_left")
end

GameModeInnVs.evaluate_end_conditions = function (arg_8_0, arg_8_1)
	if var_0_1 then
		var_0_1 = false

		return true, "won"
	end

	if arg_8_0:_is_time_up() then
		return true, "reload"
	end

	if var_0_2 then
		var_0_2 = false

		return true, "lost"
	end

	if arg_8_0._level_completed then
		return true, "start_game"
	else
		return false
	end
end

GameModeInnVs.setup_done = function (arg_9_0)
	if DEDICATED_SERVER then
		arg_9_0:change_game_mode_state("dedicated_server_waiting_for_fully_reserved")
		arg_9_0._mechanism:set_side_order_state(1)
	else
		arg_9_0:change_game_mode_state("party_lobby")
		arg_9_0:play_sound("Stop_versus_hud_last_hero_down_riser")
	end
end

GameModeInnVs.COMPLETE_LEVEL = function (arg_10_0)
	var_0_1 = true
end

GameModeInnVs.FAIL_LEVEL = function (arg_11_0)
	var_0_2 = true
end

GameModeInnVs.player_entered_game_session = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0._mechanism:handle_party_assignment_for_joining_peer(arg_12_1, arg_12_2)
	local var_12_1, var_12_2 = Managers.party:get_party_from_player_id(arg_12_1, arg_12_2)

	if var_12_0 ~= var_12_2 then
		Managers.party:request_join_party(arg_12_1, arg_12_2, var_12_0)
	end

	if LAUNCH_MODE ~= "attract_benchmark" then
		arg_12_0._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_12_1, arg_12_2)
	end

	if not DEDICATED_SERVER then
		arg_12_0._simple_spawning:setup_data(arg_12_1, arg_12_2)
	end
end

GameModeInnVs.player_left_game_session = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Managers.party:get_player_status(arg_13_1, arg_13_2)

	if var_13_0 then
		var_13_0.game_mode_data = {}
	end
end

GameModeInnVs.player_joined_party = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if not DEDICATED_SERVER then
		arg_14_0._simple_spawning:setup_data(arg_14_1, arg_14_2)
	end
end

GameModeInnVs.player_left_party = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	return
end

GameModeInnVs.on_game_server_unreserve_party_slot = function (arg_16_0, arg_16_1, arg_16_2)
	if DEDICATED_SERVER and arg_16_0._mechanism:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):is_empty() then
		arg_16_0._transition_state = "restart_game_server"
	end
end

GameModeInnVs.flow_callback_add_spawn_point = function (arg_17_0, arg_17_1)
	if not DEDICATED_SERVER then
		arg_17_0._simple_spawning:flow_callback_add_spawn_point(arg_17_1)
	end
end

GameModeInnVs.get_initial_inventory = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	local var_18_0

	if arg_18_5.affiliation == "heroes" then
		var_18_0 = {
			slot_packmaster_claw = "packmaster_claw_combo",
			slot_healthkit = arg_18_1,
			slot_potion = arg_18_2,
			slot_grenade = arg_18_3,
			additional_items = arg_18_4
		}
	else
		var_18_0 = {}
	end

	return var_18_0
end

GameModeInnVs.hot_join_sync = function (arg_19_0, arg_19_1)
	GameModeInnVs.super.hot_join_sync(arg_19_0, arg_19_1)
end

GameModeInnVs._send_system_message = function (arg_20_0, arg_20_1, ...)
	local var_20_0 = false
	local var_20_1 = true

	Managers.chat:send_system_chat_message(1, arg_20_1, nil, var_20_0, var_20_1)
end

GameModeInnVs.force_map_pool = function (arg_21_0, arg_21_1)
	arg_21_0._force_map_pool = arg_21_1
end

GameModeInnVs.event_local_player_spawned = function (arg_22_0, arg_22_1)
	arg_22_0._local_player_spawned = true
	arg_22_0._is_initial_spawn = arg_22_1
end

GameModeInnVs.server_update = function (arg_23_0, arg_23_1, arg_23_2)
	if DEDICATED_SERVER then
		arg_23_0:_handle_dedicated_start_game(arg_23_1, arg_23_2)
		arg_23_0:_handle_dedicated_input(arg_23_1, arg_23_2)
		arg_23_0:_handle_auto_force_start(arg_23_1, arg_23_2)
	else
		local var_23_0 = Managers.party:parties()

		for iter_23_0 = 1, #var_23_0 do
			local var_23_1 = var_23_0[iter_23_0]

			arg_23_0._simple_spawning:update(arg_23_1, arg_23_2, var_23_1)
		end
	end

	local var_23_2 = Managers.mechanism:get_all_reservation_handlers_by_owner(Network.peer_id())

	for iter_23_1, iter_23_2 in pairs(var_23_2) do
		if iter_23_2.handle_dangling_peers then
			iter_23_2:handle_dangling_peers()
		end
	end
end

GameModeInnVs._game_mode_state_changed = function (arg_24_0, arg_24_1)
	if arg_24_0._is_server and arg_24_1 == "dedicated_server_starting_game" then
		arg_24_0:_start_hosting_server()
		arg_24_0._mechanism:server_decide_side_order()
	end
end

GameModeInnVs._handle_dedicated_start_game = function (arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0._game_mode_state == "dedicated_server_waiting_for_fully_reserved" and arg_25_0._mechanism:should_game_server_start_game() then
		arg_25_0:change_game_mode_state("dedicated_server_starting_game")
	end
end

GameModeInnVs._handle_dedicated_input = function (arg_26_0, arg_26_1, arg_26_2)
	CommandWindow.update()

	local var_26_0 = CommandWindow.read_line()

	if var_26_0 then
		Managers.admin:execute_command(var_26_0)
	end
end

GameModeInnVs._start_hosting_server = function (arg_27_0)
	local var_27_0 = arg_27_0._force_map_pool or Managers.mechanism:mechanism_setting_for_title("map_pool")
	local var_27_1 = arg_27_0._settings.forced_difficulty
	local var_27_2 = Managers.mechanism:game_mechanism():get_level_override_key()
	local var_27_3 = var_27_2 and {
		var_27_2
	}
	local var_27_4 = {
		skip_waystone = true,
		private_game = true,
		matchmaking_type = "versus",
		always_host = true,
		game_mode = "versus",
		dedicated_server = false,
		mechanism = "versus",
		quick_game = false,
		preferred_level_keys = var_27_3 or table.clone(var_27_0),
		difficulty = var_27_1
	}

	Managers.matchmaking:find_game(var_27_4)

	arg_27_0._force_map_pool = nil
end

GameModeInnVs.wanted_transition = function (arg_28_0)
	if arg_28_0._transition_state == "restart_game_server" then
		return "restart_game_server"
	end
end

GameModeInnVs.is_reservable = function (arg_29_0)
	return true
end

GameModeInnVs.is_joinable = function (arg_30_0)
	return arg_30_0:is_reservable() and arg_30_0:game_mode_state() ~= "dedicated_server_waiting_for_fully_reserved"
end

GameModeInnVs.update_auto_force_start_conditions = function (arg_31_0, arg_31_1)
	return
end

GameModeInnVs._set_auto_force_start_time = function (arg_32_0)
	local var_32_0 = arg_32_0._settings.auto_force_start

	if not var_32_0.enabled then
		return
	end

	if arg_32_0._auto_force_start_time < math.huge then
		return
	end

	local var_32_1 = var_32_0.start_after_seconds
	local var_32_2 = Managers.time:time("game")

	arg_32_0._auto_force_start_time = var_32_2 + var_32_1
	arg_32_0._check_all_players_reserved_time = var_32_2 + 2

	printf("[GameModeInnVS:_set_auto_force_start_time]: Automatic force start in %s seconds if teams remain unchanged", var_32_0.start_after_seconds)
end

GameModeInnVs._handle_auto_force_start = function (arg_33_0, arg_33_1, arg_33_2)
	if arg_33_1 < arg_33_0._auto_force_start_time then
		return
	end

	arg_33_0._auto_force_start_time = math.huge
end

GameModeInnVs.play_sound = function (arg_34_0, arg_34_1)
	local var_34_0 = Managers.world:wwise_world(arg_34_0._world)

	WwiseWorld.trigger_event(var_34_0, arg_34_1)
end
