-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_inn_deus.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/adventure_profile_rules")

local flag = false
local flag_2 = false

GameModeInnDeus = class(GameModeInnDeus, GameModeBase)

GameModeInnDeus.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	GameModeInnDeus.super.init(self, arg_1_1, arg_1_2, ...)

	self._adventure_profile_rules = AdventureProfileRules:new(self._profile_synchronizer, self._network_server)

	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	self._adventure_spawning = AdventureSpawning:new(self._profile_synchronizer, get_side_from_name, self._is_server, self._network_server)

	self:_register_player_spawner(self._adventure_spawning)

	self._objective_units = nil
	self._state = "_state_none"
	self._matchmaking_manager = Managers.matchmaking
	self._objective_markers = {}
	self._current_objective_id = nil
	self._current_waystone_type = 1
	self._waystone_is_active = false
	self._waystone_type = 0
	self._player_manager = Managers.player
	self._statistics_db = self._player_manager:statistics_db()

	Managers.state.event:register(self, "level_start_local_player_spawned", "event_local_player_spawned")

	self._local_player_spawned = false
end

GameModeInnDeus.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	GameModeInnDeus.super.register_rpcs(self, arg_2_1, arg_2_2)
	self._adventure_spawning:register_rpcs(arg_2_1, arg_2_2)

	self._network_event_delegate = arg_2_1

	self._network_event_delegate:register(self, "rpc_waystone_active")
end

GameModeInnDeus.unregister_rpcs = function (self)
	-- function 3
	self._adventure_spawning:unregister_rpcs()
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil

	GameModeInnDeus.super.unregister_rpcs(self)
end

GameModeInnDeus.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_objectives()
	self._adventure_spawning:update(arg_4_1, arg_4_2)
end

GameModeInnDeus.server_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._adventure_spawning:server_update(arg_5_1, arg_5_2)
end

GameModeInnDeus.evaluate_end_conditions = function (self, arg_6_1)
	-- function 6
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

	if not self:update_end_level_areas() then
		return true, "start_game"
	elseif not self._level_completed then
		return true, "start_game"
	else
		return false
	end
end

GameModeInnDeus.event_local_player_spawned = function (self, arg_7_1)
	-- function 7
	self._local_player_spawned = true
	self._is_initial_spawn = arg_7_1
end

GameModeInnDeus.COMPLETE_LEVEL = function (arg_8_0)
	-- function 8
	flag = true
end

GameModeInnDeus.FAIL_LEVEL = function (arg_9_0)
	-- function 9
	flag_2 = true
end

GameModeInnDeus.player_entered_game_session = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	GameModeInnDeus.super.player_entered_game_session(self, arg_10_1, arg_10_2, arg_10_3)

	if Managers.party:get_player_status(arg_10_1, arg_10_2).party_id ~= 1 then
		local num = 1

		Managers.party:assign_peer_to_party(arg_10_1, arg_10_2, num)
	end

	self._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_10_1, arg_10_2)
end

GameModeInnDeus.flow_callback_add_spawn_point = function (self, arg_11_1)
	-- function 11
	self._adventure_spawning:add_spawn_point(arg_11_1)
end

GameModeInnDeus.respawn_unit_spawned = function (self, arg_12_1)
	-- function 12
	self._adventure_spawning:respawn_unit_spawned(arg_12_1)
end

GameModeInnDeus.get_respawn_handler = function (self)
	-- function 13
	return self._adventure_spawning:get_respawn_handler()
end

GameModeInnDeus.respawn_gate_unit_spawned = function (self, arg_14_1)
	-- function 14
	self._adventure_spawning:respawn_gate_unit_spawned(arg_14_1)
end

GameModeInnDeus.force_respawn = function (self, arg_15_1, arg_15_2)
	-- function 15
	if Managers.party:get_player_status(arg_15_1, arg_15_2).party_id == 0 then
		local num = 1

		Managers.party:assign_peer_to_party(arg_15_1, arg_15_2, num)
	end

	self._adventure_spawning:force_respawn(arg_15_1, arg_15_2)
end

GameModeInnDeus._update_objectives = function (self)
	-- function 16
	if not self._objective_units then
		self._objective_units = Managers.state.entity:get_entities("ObjectiveUnitExtension")

		for k, v in pairs(self._objective_units) do
			local get_data = Unit.get_data(k, "objective_id")

			if not get_data then
				self._objective_markers[get_data] = k
			end

			self:_deactivate_objective_marker(k)
		end
	else
		self:_update_objective_marker()
	end
end

GameModeInnDeus._update_objective_marker = function (self)
	-- function 17
	if not self._matchmaking_manager:is_game_matchmaking() then
		self:_state_game_is_matchmaking()
	else
		self:_state_choose_map()
	end
end

local tbl = {
	"waystone",
	"waystone",
	"waystone_weave"
}

GameModeInnDeus._state_game_is_matchmaking = function (self)
	-- function 18
	if not self._is_server then
		local waystone_is_active, var_18_1 = self._matchmaking_manager:waystone_is_active()

		if self._waystone_is_active ~= waystone_is_active then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_waystone_active", var_18_1, waystone_is_active, self._current_waystone_type)

			self._waystone_is_active = waystone_is_active
			self._waystone_type = var_18_1
		end
	end

	local _current_objective_id = self._current_objective_id

	if not self._waystone_is_active then
		self._current_waystone_type = self._waystone_type

		local var_18_3 = tbl[self._waystone_type]

		if var_18_3 ~= _current_objective_id then
			self:_deactivate_objective_marker(_current_objective_id)
			self:_activate_objective_marker(var_18_3)
		end
	elseif not _current_objective_id then
		self:_deactivate_objective_marker(_current_objective_id)
	end
end

local tbl_2 = {
	"map",
	"map"
}

GameModeInnDeus._state_choose_map = function (self)
	-- function 19
	local _current_objective_id = self._current_objective_id
	local var_19_1 = tbl_2[self._current_waystone_type]

	if not self._is_server and not self._waystone_is_active then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_waystone_active", self._waystone_type, false, self._current_waystone_type)

		self._waystone_is_active = false
	end

	if var_19_1 ~= _current_objective_id then
		self:_deactivate_objective_marker(_current_objective_id)
		self:_activate_objective_marker(var_19_1)
	end
end

GameModeInnDeus._activate_objective_marker = function (self, arg_20_1)
	-- function 20
	local var_20_0 = self._objective_markers[arg_20_1]

	if not var_20_0 then
		self._current_objective_id = arg_20_1

		ScriptUnit.extension(var_20_0, "tutorial_system"):set_active(true)
	end
end

GameModeInnDeus._deactivate_objective_marker = function (self, arg_21_1)
	-- function 21
	local var_21_0 = self._objective_markers[arg_21_1]

	if not var_21_0 then
		ScriptUnit.extension(var_21_0, "tutorial_system"):set_active(false)
	end

	self._current_objective_id = nil
end

GameModeInnDeus.rpc_waystone_active = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	self._waystone_is_active = arg_22_3
	self._waystone_type = arg_22_2
	self._current_waystone_type = arg_22_4
end

GameModeInnDeus.hot_join_sync = function (self, arg_23_1)
	-- function 23
	self._waystone_is_active = false
	self._waystone_type = 0

	local var_23_0 = PEER_ID_TO_CHANNEL[arg_23_1]

	RPC.rpc_waystone_active(var_23_0, self._waystone_type, self._waystone_is_active, self._current_waystone_type)
end

GameModeInnDeus.local_player_ready_to_start = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not self._local_player_spawned then
		return false
	end

	return true
end

GameModeInnDeus.local_player_game_starts = function (self, arg_25_1, arg_25_2)
	-- function 25
	local show_profile_on_startup = arg_25_2.show_profile_on_startup

	arg_25_2.show_profile_on_startup = nil

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
			local var_25_5 = ui
			local handle_transition = ui.handle_transition
			local str = "initial_start_menu_view_force"
			local tbl = {}
			local flag_2

			flag_2 = not flag and "character" and "overview"
			tbl.menu_state_name = flag_2
			tbl.on_exit_callback = callback(self, "_cb_start_menu_closed")

			handle_transition(var_25_5, str, tbl)
		else
			Managers.ui:handle_transition("initial_character_selection_force", {
				menu_state_name = "character",
				on_exit_callback = callback(self, "_cb_start_menu_closed")
			})
		end
	else
		Managers.state.event:trigger("tutorial_trigger", "keep_menu_left")
	end

	if not self._is_initial_spawn then
		LevelHelper:flow_event(self._world, "local_player_spawned")

		if not Development.parameter("attract_mode") then
			LevelHelper:flow_event(self._world, "start_benchmark")
		else
			LevelHelper:flow_event(self._world, "level_start_local_player_spawned")
		end
	end
end

GameModeInnDeus._cb_start_menu_closed = function (arg_26_0)
	-- function 26
	Managers.state.event:trigger("tutorial_trigger", "keep_menu_left")
end
