-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_inn.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/adventure_profile_rules")

local flag = false
local flag_2 = false

GameModeInn = class(GameModeInn, GameModeBase)

GameModeInn.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	GameModeInn.super.init(self, arg_1_1, arg_1_2, ...)

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
	self._show_tutorial = true
	self._waystone_is_active = false
	self._waystone_type = 0
	self._player_manager = Managers.player
	self._statistics_db = self._player_manager:statistics_db()

	Managers.state.event:register(self, "level_start_local_player_spawned", "event_local_player_spawned")

	self._local_player_spawned = false
end

GameModeInn.destroy = function (arg_2_0)
	-- function 2
	local event = Managers.state.event

	if not event then
		event:unregister("level_start_local_player_spawned", arg_2_0)
	end
end

GameModeInn.register_rpcs = function (self, arg_3_1, arg_3_2)
	-- function 3
	GameModeInn.super.register_rpcs(self, arg_3_1, arg_3_2)
	self._adventure_spawning:register_rpcs(arg_3_1, arg_3_2)

	self._network_event_delegate = arg_3_1

	self._network_event_delegate:register(self, "rpc_waystone_active")
end

GameModeInn.unregister_rpcs = function (self)
	-- function 4
	self._adventure_spawning:unregister_rpcs()
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil

	GameModeInn.super.unregister_rpcs(self)
end

GameModeInn.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_update_objectives()
	self._adventure_spawning:update(arg_5_1, arg_5_2)
end

GameModeInn.server_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._adventure_spawning:server_update(arg_6_1, arg_6_2)
end

GameModeInn.evaluate_end_conditions = function (self, arg_7_1)
	-- function 7
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

GameModeInn.event_local_player_spawned = function (self, arg_8_1)
	-- function 8
	self._local_player_spawned = true
	self._is_initial_spawn = arg_8_1
end

GameModeInn.COMPLETE_LEVEL = function (arg_9_0)
	-- function 9
	flag = true
end

GameModeInn.FAIL_LEVEL = function (arg_10_0)
	-- function 10
	flag_2 = true
end

GameModeInn.player_entered_game_session = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	GameModeInn.super.player_entered_game_session(self, arg_11_1, arg_11_2, arg_11_3)

	if Managers.party:get_player_status(arg_11_1, arg_11_2).party_id ~= 1 then
		local num = 1

		Managers.party:assign_peer_to_party(arg_11_1, arg_11_2, num)
	end

	self._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_11_1, arg_11_2)
end

GameModeInn.flow_callback_add_spawn_point = function (self, arg_12_1)
	-- function 12
	self._adventure_spawning:add_spawn_point(arg_12_1)
end

GameModeInn.respawn_unit_spawned = function (self, arg_13_1)
	-- function 13
	self._adventure_spawning:respawn_unit_spawned(arg_13_1)
end

GameModeInn.get_respawn_handler = function (self)
	-- function 14
	return self._adventure_spawning:get_respawn_handler()
end

GameModeInn.respawn_gate_unit_spawned = function (self, arg_15_1)
	-- function 15
	self._adventure_spawning:respawn_gate_unit_spawned(arg_15_1)
end

GameModeInn.force_respawn = function (self, arg_16_1, arg_16_2)
	-- function 16
	if Managers.party:get_player_status(arg_16_1, arg_16_2).party_id == 0 then
		local num = 1

		Managers.party:assign_peer_to_party(arg_16_1, arg_16_2, num)
	end

	self._adventure_spawning:force_respawn(arg_16_1, arg_16_2)
end

GameModeInn._update_objectives = function (self)
	-- function 17
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

GameModeInn._update_objective_marker = function (self)
	-- function 18
	local is_game_matchmaking = self._matchmaking_manager:is_game_matchmaking()

	if not (not self._show_tutorial and is_game_matchmaking) then
		local _should_show_tutorial, var_18_2 = self:_should_show_tutorial()

		if not _should_show_tutorial then
			self:_state_tutorial(var_18_2)
		end

		self._show_tutorial = _should_show_tutorial
	end

	if not is_game_matchmaking then
		self:_state_game_is_matchmaking()
	elseif not (is_game_matchmaking or self._show_tutorial) then
		self:_state_choose_map()
	end
end

local tbl = {
	"waystone",
	"waystone",
	"waystone_weave"
}

GameModeInn._state_game_is_matchmaking = function (self)
	-- function 19
	if not self._is_server then
		local waystone_is_active, var_19_1 = self._matchmaking_manager:waystone_is_active()

		if self._waystone_is_active ~= waystone_is_active then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_waystone_active", var_19_1, waystone_is_active, self._current_waystone_type)

			self._waystone_is_active = waystone_is_active
			self._waystone_type = var_19_1
		end
	end

	local _current_objective_id = self._current_objective_id

	if not self._waystone_is_active then
		self._current_waystone_type = self._waystone_type

		local var_19_3 = tbl[self._waystone_type]

		if var_19_3 ~= _current_objective_id then
			self:_deactivate_objective_marker(_current_objective_id)
			self:_activate_objective_marker(var_19_3)
		end
	elseif not _current_objective_id then
		self:_deactivate_objective_marker(_current_objective_id)
	end
end

local tbl_2 = {
	"map",
	"map",
	"wom_tutorial_weave_select"
}

GameModeInn._state_choose_map = function (self)
	-- function 20
	local _current_objective_id = self._current_objective_id
	local var_20_1 = tbl_2[self._current_waystone_type]

	if not self._is_server and not self._waystone_is_active then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_waystone_active", self._waystone_type, false, self._current_waystone_type)

		self._waystone_is_active = false
	end

	if var_20_1 ~= _current_objective_id then
		self:_deactivate_objective_marker(_current_objective_id)
		self:_activate_objective_marker(var_20_1)
	end
end

GameModeInn._should_show_tutorial = function (self)
	-- function 21
	local local_player = self._player_manager:local_player(1)

	if not local_player then
		local stats_id = local_player:stats_id()
		local get_persistent_stat = self._statistics_db:get_persistent_stat(stats_id, "scorpion_onboarding_step")

		return not (get_persistent_stat > 0) or get_persistent_stat < 10, get_persistent_stat
	end

	return false
end

GameModeInn._state_tutorial = function (self, arg_22_1)
	-- function 22
	local _current_objective_id = self._current_objective_id
	local var_22_1

	if arg_22_1 == 1 then
		var_22_1 = "wom_tutorial_mission_select"
	elseif arg_22_1 == 3 then
		var_22_1 = "wom_tutorial_weave_area"
	elseif arg_22_1 == 4 then
		var_22_1 = "wom_tutorial_athanor"
	elseif arg_22_1 == 5 then
		var_22_1 = "wom_tutorial_weave_select"
	elseif arg_22_1 == 6 then
		var_22_1 = "wom_tutorial_weave_select"
	elseif arg_22_1 == 7 then
		var_22_1 = "wom_tutorial_athanor"
	elseif arg_22_1 == 8 then
		var_22_1 = "wom_tutorial_weave_select"
	elseif arg_22_1 == 9 then
		var_22_1 = "wom_tutorial_athanor"
	end

	if var_22_1 ~= _current_objective_id then
		self:_deactivate_objective_marker(_current_objective_id)
		self:_activate_objective_marker(var_22_1)
	end
end

GameModeInn._activate_objective_marker = function (self, arg_23_1)
	-- function 23
	local var_23_0 = self._objective_markers[arg_23_1]

	if not var_23_0 then
		self._current_objective_id = arg_23_1

		ScriptUnit.extension(var_23_0, "tutorial_system"):set_active(true)
	end
end

GameModeInn._deactivate_objective_marker = function (self, arg_24_1)
	-- function 24
	local var_24_0 = self._objective_markers[arg_24_1]

	if not var_24_0 then
		ScriptUnit.extension(var_24_0, "tutorial_system"):set_active(false)
	end

	self._current_objective_id = nil
end

GameModeInn.rpc_waystone_active = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	self._waystone_is_active = arg_25_3
	self._waystone_type = arg_25_2
	self._current_waystone_type = arg_25_4
end

GameModeInn.hot_join_sync = function (self, arg_26_1)
	-- function 26
	self._waystone_is_active = false
	self._waystone_type = 0

	local var_26_0 = PEER_ID_TO_CHANNEL[arg_26_1]

	RPC.rpc_waystone_active(var_26_0, self._waystone_type, self._waystone_is_active, self._current_waystone_type)
end

GameModeInn.local_player_ready_to_start = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not self._local_player_spawned then
		return false
	end

	return true
end

GameModeInn.local_player_game_starts = function (self, arg_28_1, arg_28_2)
	-- function 28
	local show_profile_on_startup = arg_28_2.show_profile_on_startup

	arg_28_2.show_profile_on_startup = nil

	if not (not show_profile_on_startup and LEVEL_EDITOR_TEST or Development.parameter("skip-start-menu")) then
		local PLATFORM = PLATFORM
		local var_28_2
		local var_28_3

		if not IS_CONSOLE then
			var_28_2 = "initial_character_selection_force"
			var_28_3 = "character"
		elseif GameSettingsDevelopment.skip_start_screen or not Development.parameter("skip_start_screen") then
			local flag = not not SaveData.first_hero_selection_made or not Managers.backend:is_waiting_for_user_input()

			var_28_2 = "initial_start_menu_view_force"
			var_28_3 = not flag and "character" and "overview"
		else
			var_28_2 = "initial_character_selection_force"
			var_28_3 = "character"
		end

		Managers.ui:handle_transition(var_28_2, {
			menu_state_name = var_28_3,
			on_exit_callback = callback(self, "_cb_start_menu_closed")
		})
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

	print("[GameModeInn] Start menu opened")
end

GameModeInn._cb_start_menu_closed = function (self)
	-- function 29
	print("[GameModeInn] Start menu closed")

	local _world = self._world
	local flag = false

	if not not PlayerData.first_time_store_release then
		LevelHelper:flow_event(_world, "first_time_store_release")

		PlayerData.first_time_store_release = true
		flag = true
	end

	if not PlayerData.store_new_items and not GameSettingsDevelopment.store_nags then
		LevelHelper:flow_event(_world, "shop_new_items")

		PlayerData.store_new_items = false
		flag = true
	end

	if not flag then
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end

	Managers.ui:ingame_ui().has_left_menu = true

	Managers.state.event:trigger("tutorial_trigger", "keep_menu_left")
end
