-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_inn_vs.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/admin/dedicated_server_commands")
require("scripts/managers/game_mode/spawning_components/simple_spawning")

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")
local flag = false
local flag_2 = false

GameModeInnVs = class(GameModeInnVs, GameModeBase)

GameModeInnVs.init = function (self, arg_1_1, arg_1_2, arg_1_3, ...)
	-- function 1
	GameModeInnVs.super.init(self, arg_1_1, arg_1_2, arg_1_3, ...)

	self._mechanism = Managers.mechanism:game_mechanism()
	self._adventure_profile_rules = AdventureProfileRules:new(self._profile_synchronizer, self._network_server)

	if not DEDICATED_SERVER then
		self._auto_force_start_time = math.huge

		Managers.state.event:register(self, "game_server_unreserve_party_slot", "on_game_server_unreserve_party_slot")
	else
		local flag = true

		self._simple_spawning = SimpleSpawning:new(self._profile_synchronizer, flag)

		Managers.state.event:register(self, "level_start_local_player_spawned", "event_local_player_spawned")
	end

	if not self._is_server then
		self._lobby_host = arg_1_3.lobby_host
	end

	if not self._mechanism:is_hosting_versus_custom_game() then
		self._mechanism:set_is_hosting_versus_custom_game(false)
	end

	if not DEDICATED_SERVER then
		self._mechanism:set_custom_game_settings_handler_enabled(false)
	end
end

GameModeInnVs.destroy = function (arg_2_0)
	-- function 2
	if not DEDICATED_SERVER then
		Managers.state.event:unregister("game_server_unreserve_party_slot", arg_2_0)
	end
end

GameModeInnVs.register_rpcs = function (self, arg_3_1, arg_3_2)
	-- function 3
	GameModeInnVs.super.register_rpcs(self, arg_3_1, arg_3_2)

	if not self._simple_spawning then
		self._simple_spawning:register_rpcs(arg_3_1, arg_3_2)
	end
end

GameModeInnVs.unregister_rpcs = function (self)
	-- function 4
	GameModeInnVs.super.unregister_rpcs(self)

	if not self._simple_spawning then
		self._simple_spawning:unregister_rpcs()
	end
end

GameModeInnVs.local_player_ready_to_start = function (self)
	-- function 5
	return self._game_mode_state ~= "initial_state"
end

GameModeInnVs.local_player_game_starts = function (self, arg_6_1, arg_6_2)
	-- function 6
	local show_profile_on_startup = arg_6_2.show_profile_on_startup

	arg_6_2.show_profile_on_startup = nil

	if not (not show_profile_on_startup and LEVEL_EDITOR_TEST or Development.parameter("skip-start-menu")) then
		local PLATFORM = PLATFORM

		if not IS_CONSOLE then
			Managers.ui:handle_transition("initial_character_selection_force", {
				menu_state_name = "character",
				on_exit_callback = callback(self, "_cb_start_menu_closed")
			})
		elseif GameSettingsDevelopment.skip_start_screen or not Development.parameter("skip_start_screen") then
			local first_hero_selection_made = SaveData.first_hero_selection_made
			local flag = not not Managers.backend:is_waiting_for_user_input() or not first_hero_selection_made
			local ui = Managers.ui
			local var_6_5 = ui
			local handle_transition = ui.handle_transition
			local str = "initial_start_menu_view_force"
			local tbl = {}
			local flag_2

			flag_2 = not flag and "character" and "overview"
			tbl.menu_state_name = flag_2
			tbl.on_exit_callback = callback(self, "_cb_start_menu_closed")

			handle_transition(var_6_5, str, tbl)
		else
			Managers.ui:handle_transition("initial_character_selection_force", {
				menu_state_name = "character",
				on_exit_callback = callback(self, "_cb_start_menu_closed")
			})
		end
	else
		self:_cb_start_menu_closed()
	end

	if not self._is_initial_spawn then
		LevelHelper:flow_event(self._world, "local_player_spawned")

		if not Development.parameter("attract_mode") then
			LevelHelper:flow_event(self._world, "start_benchmark")
		else
			LevelHelper:flow_event(self._world, "level_start_local_player_spawned")
		end
	end

	if DEDICATED_SERVER or not Development.parameter("vs_auto_search") then
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
	-- function 7
	Managers.state.event:trigger("tutorial_trigger", "keep_menu_left")
end

GameModeInnVs.evaluate_end_conditions = function (self, arg_8_1)
	-- function 8
	if not flag then
		flag = false

		return true, "won"
	end

	if not self:_is_time_up() then
		return true, "reload"
	end

	if not flag_2 then
		flag_2 = false

		return true, "lost"
	end

	if not self._level_completed then
		return true, "start_game"
	else
		return false
	end
end

GameModeInnVs.setup_done = function (self)
	-- function 9
	if not DEDICATED_SERVER then
		self:change_game_mode_state("dedicated_server_waiting_for_fully_reserved")
		self._mechanism:set_side_order_state(1)
	else
		self:change_game_mode_state("party_lobby")
		self:play_sound("Stop_versus_hud_last_hero_down_riser")
	end
end

GameModeInnVs.COMPLETE_LEVEL = function (arg_10_0)
	-- function 10
	flag = true
end

GameModeInnVs.FAIL_LEVEL = function (arg_11_0)
	-- function 11
	flag_2 = true
end

GameModeInnVs.player_entered_game_session = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local handle_party_assignment_for_joining_peer = self._mechanism:handle_party_assignment_for_joining_peer(arg_12_1, arg_12_2)
	local get_party_from_player_id, var_12_2 = Managers.party:get_party_from_player_id(arg_12_1, arg_12_2)

	if handle_party_assignment_for_joining_peer ~= var_12_2 then
		Managers.party:request_join_party(arg_12_1, arg_12_2, handle_party_assignment_for_joining_peer)
	end

	if LAUNCH_MODE ~= "attract_benchmark" then
		self._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_12_1, arg_12_2)
	end

	if not DEDICATED_SERVER then
		self._simple_spawning:setup_data(arg_12_1, arg_12_2)
	end
end

GameModeInnVs.player_left_game_session = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local get_player_status = Managers.party:get_player_status(arg_13_1, arg_13_2)

	if not get_player_status then
		get_player_status.game_mode_data = {}
	end
end

GameModeInnVs.player_joined_party = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if not DEDICATED_SERVER then
		self._simple_spawning:setup_data(arg_14_1, arg_14_2)
	end
end

GameModeInnVs.player_left_party = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	return
end

GameModeInnVs.on_game_server_unreserve_party_slot = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not DEDICATED_SERVER and not self._mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):is_empty() then
		self._transition_state = "restart_game_server"
	end
end

GameModeInnVs.flow_callback_add_spawn_point = function (self, arg_17_1)
	-- function 17
	if not DEDICATED_SERVER then
		self._simple_spawning:flow_callback_add_spawn_point(arg_17_1)
	end
end

GameModeInnVs.get_initial_inventory = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
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
	-- function 19
	GameModeInnVs.super.hot_join_sync(arg_19_0, arg_19_1)
end

GameModeInnVs._send_system_message = function (arg_20_0, arg_20_1, ...)
	-- function 20
	local flag = false
	local flag_2 = true

	Managers.chat:send_system_chat_message(1, arg_20_1, nil, flag, flag_2)
end

GameModeInnVs.force_map_pool = function (self, arg_21_1)
	-- function 21
	self._force_map_pool = arg_21_1
end

GameModeInnVs.event_local_player_spawned = function (self, arg_22_1)
	-- function 22
	self._local_player_spawned = true
	self._is_initial_spawn = arg_22_1
end

GameModeInnVs.server_update = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not DEDICATED_SERVER then
		self:_handle_dedicated_start_game(arg_23_1, arg_23_2)
		self:_handle_dedicated_input(arg_23_1, arg_23_2)
		self:_handle_auto_force_start(arg_23_1, arg_23_2)
	else
		local parties = Managers.party:parties()

		for i = 1, #parties do
			local var_23_1 = parties[i]

			self._simple_spawning:update(arg_23_1, arg_23_2, var_23_1)
		end
	end

	local get_all_reservation_handlers_by_owner = Managers.mechanism:get_all_reservation_handlers_by_owner(Network.peer_id())

	for k, v in pairs(get_all_reservation_handlers_by_owner) do
		if not v.handle_dangling_peers then
			v:handle_dangling_peers()
		end
	end
end

GameModeInnVs._game_mode_state_changed = function (self, arg_24_1)
	-- function 24
	if not (not self._is_server and arg_24_1 ~= "dedicated_server_starting_game") then
		self:_start_hosting_server()
		self._mechanism:server_decide_side_order()
	end
end

GameModeInnVs._handle_dedicated_start_game = function (self, arg_25_1, arg_25_2)
	-- function 25
	if self._game_mode_state ~= "dedicated_server_waiting_for_fully_reserved" or not self._mechanism:should_game_server_start_game() then
		self:change_game_mode_state("dedicated_server_starting_game")
	end
end

GameModeInnVs._handle_dedicated_input = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	CommandWindow.update()

	local read_line = CommandWindow.read_line()

	if not read_line then
		Managers.admin:execute_command(read_line)
	end
end

GameModeInnVs._start_hosting_server = function (self)
	-- function 27
	local _force_map_pool = self._force_map_pool

	_force_map_pool = _force_map_pool or Managers.mechanism:mechanism_setting_for_title("map_pool")

	local forced_difficulty = self._settings.forced_difficulty
	local get_level_override_key = Managers.mechanism:game_mechanism():get_level_override_key()
	local flag = not get_level_override_key and {
		get_level_override_key
	}
	local tbl = {
		skip_waystone = true,
		private_game = true,
		matchmaking_type = "versus",
		always_host = true,
		game_mode = "versus",
		dedicated_server = false,
		mechanism = "versus",
		quick_game = false,
		preferred_level_keys = flag or table.clone(_force_map_pool),
		difficulty = forced_difficulty
	}

	Managers.matchmaking:find_game(tbl)

	self._force_map_pool = nil
end

GameModeInnVs.wanted_transition = function (self)
	-- function 28
	if self._transition_state == "restart_game_server" then
		return "restart_game_server"
	end
end

GameModeInnVs.is_reservable = function (arg_29_0)
	-- function 29
	return true
end

GameModeInnVs.is_joinable = function (self)
	-- function 30
	local is_reservable = self:is_reservable()

	is_reservable = not is_reservable and self:game_mode_state() ~= "dedicated_server_waiting_for_fully_reserved"

	return is_reservable
end

GameModeInnVs.update_auto_force_start_conditions = function (arg_31_0, arg_31_1)
	-- function 31
	return
end

GameModeInnVs._set_auto_force_start_time = function (self)
	-- function 32
	local auto_force_start = self._settings.auto_force_start

	if not auto_force_start.enabled then
		return
	end

	if self._auto_force_start_time < math.huge then
		return
	end

	local start_after_seconds = auto_force_start.start_after_seconds
	local time = Managers.time:time("game")

	self._auto_force_start_time = time + start_after_seconds
	self._check_all_players_reserved_time = time + 2

	printf("[GameModeInnVS:_set_auto_force_start_time]: Automatic force start in %s seconds if teams remain unchanged", auto_force_start.start_after_seconds)
end

GameModeInnVs._handle_auto_force_start = function (self, arg_33_1, arg_33_2)
	-- function 33
	if arg_33_1 < self._auto_force_start_time then
		return
	end

	self._auto_force_start_time = math.huge
end

GameModeInnVs.play_sound = function (self, arg_34_1)
	-- function 34
	local wwise_world = Managers.world:wwise_world(self._world)

	WwiseWorld.trigger_event(wwise_world, arg_34_1)
end
