-- chunkname: @scripts/unit_extensions/deus/deus_cursed_chest_extension.lua

DeusCursedChestExtension = class(DeusCursedChestExtension)

local tbl = {
	"rpc_deus_chest_looted"
}
local tbl_2 = {
	OPEN = 3,
	HOTJOIN_OPEN = 4,
	WAITING = 1,
	INITIALIZING = 0,
	RUNNING = 2
}
local num = 4
local tbl_3 = {
	trigger_cursed_chest = "trigger_cursed_chest",
	finish_cursed_chest = "finish_cursed_chest"
}
local num_2 = 60

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	local num = POSITION_LOOKUP[arg_1_1] + Vector3(math.random(-0.5, 0.5), math.random(-0.5, 0.5), 2)

	self:spawn_pickup(arg_1_2, num, Quaternion.identity(), true, "dropped")
end

DeusCursedChestExtension.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._unit = arg_2_2
	self._is_server = Managers.player.is_server

	self:register_rpcs(arg_2_1.network_transmit.network_event_delegate)
end

DeusCursedChestExtension.game_object_initialized = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_set_state(tbl_2.WAITING)
end

DeusCursedChestExtension.extensions_ready = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	fassert(self._deus_run_controller, "deus pickup unit can only be used in a deus run")

	self._telemetry_data = {
		activated = "not_found",
		success = false,
		chosen_boon = "n/a",
		challenge_name = "n/a",
		level_count = self._deus_run_controller:get_completed_level_count() + 1,
		run_id = self._deus_run_controller:get_run_id()
	}
end

DeusCursedChestExtension.destroy = function (self)
	-- function 5
	if not self._objective_unit then
		self:_clear_objective_unit()
	end

	self:unregister_rpcs()

	if not (self._telemetry_data.activated == "not_found" or self._telemetry_data.hotjoined_late) then
		Managers.telemetry_events:cursed_chest_passed(self._telemetry_data)
	end
end

DeusCursedChestExtension.register_rpcs = function (self, arg_6_1)
	-- function 6
	arg_6_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_6_1
end

DeusCursedChestExtension.unregister_rpcs = function (self)
	-- function 7
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

DeusCursedChestExtension.update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local _prev_state = self._prev_state
	local _get_state = self:_get_state()

	if _prev_state ~= _get_state then
		if _get_state == tbl_2.WAITING then
			Unit.flow_event(self._unit, "state_WAITING")
		elseif _get_state == tbl_2.RUNNING then
			Unit.flow_event(self._unit, "state_RUNNING")

			if _prev_state == tbl_2.INITIALIZING then
				local get_missions = Managers.state.entity:system("mission_system"):get_missions()
				local find_func = table.find_func(get_missions, function (arg_9_0)
					-- function 9
					return string.sub(arg_9_0, 1, string.len("cursed_chest_challenge")) == "cursed_chest_challenge"
				end)

				self._telemetry_data.challenge_name = find_func or "hotjoin"
			else
				Managers.state.event:register(self, "ui_event_add_mission_objective", "_ui_event_add_mission_objective")
			end

			self._telemetry_data.activated = true

			if not self._is_server then
				self._terror_event_name = "cursed_chest_prototype"

				local get_level_seed = Managers.mechanism:get_level_seed()

				Managers.state.conflict:start_terror_event(self._terror_event_name, get_level_seed, arg_8_1)

				local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

				for i = 1, #PLAYER_UNITS do
					if not ALIVE[PLAYER_UNITS[i]] then
						ScriptUnit.extension(PLAYER_UNITS[i], "buff_system"):trigger_procs("cursed_chest_running", self._unit)
					end
				end
			end

			local var_8_6 = POSITION_LOOKUP[self._unit]

			WwiseUtils.trigger_position_event(arg_8_4.world, tbl_3.trigger_cursed_chest, var_8_6)
		elseif _get_state == tbl_2.HOTJOIN_OPEN then
			Unit.flow_event(self._unit, "state_HOTJOIN_OPEN")

			self._reward_collected = true
			self._telemetry_data.hotjoined_late = true
		elseif _get_state == tbl_2.OPEN then
			if not self._is_server then
				Managers.mechanism:game_mechanism():get_deus_run_controller():record_cursed_chest_purified()

				self._play_dialogue_at = arg_8_5 + num
			end

			local var_8_7 = POSITION_LOOKUP[self._unit]

			WwiseUtils.trigger_position_event(arg_8_4.world, tbl_3.finish_cursed_chest, var_8_7)

			local str = "units/hub_elements/objective_unit"
			local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(str, POSITION_LOOKUP[arg_8_1])

			Unit.set_data(spawn_local_unit, "objective_server_only", true)
			Managers.state.unit_spawner:create_unit_extensions(Unit.world(spawn_local_unit), spawn_local_unit, "objective_unit")
			ScriptUnit.extension(spawn_local_unit, "tutorial_system"):set_active(true)
			World.link_unit(Unit.world(arg_8_1), spawn_local_unit, 0, arg_8_1, 0)

			self._objective_unit = spawn_local_unit
			self._objective_unit_timeout = arg_8_5 + num_2
			self._objective_unit_astar = GwNavAStar.create()

			Unit.flow_event(self._unit, "state_OPEN")

			local local_player = Managers.player:local_player()

			Managers.state.event:trigger("player_cleansed_deus_cursed_chest", local_player)

			self._telemetry_data.success = true
		end

		if _get_state == tbl_2.HOTJOIN_OPEN then
			self._prev_state = tbl_2.OPEN
		else
			self._prev_state = _get_state
		end
	elseif not ((_get_state ~= tbl_2.RUNNING or not self._is_server) and TerrorEventMixer.find_event(self._terror_event_name)) then
		self:_set_state(tbl_2.OPEN)
	end

	if not self._objective_unit then
		if arg_8_5 > self._objective_unit_timeout then
			self:_clear_objective_unit()
		elseif not self._objective_unit_running_astar then
			if not GwNavAStar.processing_finished(self._objective_unit_astar) then
				self._objective_unit_running_astar = false

				if not GwNavAStar.path_found(self._objective_unit_astar) then
					self:_set_objective_unit_activate(false)
				else
					self:_set_objective_unit_activate(true)
				end
			end
		else
			local var_8_11 = POSITION_LOOKUP[arg_8_1]
			local local_player_2 = Managers.player:local_player()
			local flag = not local_player_2 and local_player_2.player_unit

			if not flag then
				local var_8_14 = POSITION_LOOKUP[flag]
				local traverse_logic = Managers.state.bot_nav_transition:traverse_logic()
				local nav_world = Managers.state.entity:system("ai_system"):nav_world()

				GwNavAStar.start_with_propagation_box(self._objective_unit_astar, nav_world, var_8_14, var_8_11, 30, traverse_logic)

				self._objective_unit_running_astar = true
			end
		end
	end

	if not (not self._play_dialogue_at and not (arg_8_5 >= self._play_dialogue_at)) then
		self._play_dialogue_at = nil

		local find_dialogue_unit = LevelHelper:find_dialogue_unit(arg_8_4.world, "ferry_lady")

		if not find_dialogue_unit then
			local extension_input = ScriptUnit.extension_input(find_dialogue_unit, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_dialogue_event("cursed_chest_purified", alloc_table)
		end
	end

	self:_update_telemetry(arg_8_1)
end

DeusCursedChestExtension.on_reward_collected = function (self, arg_10_1)
	-- function 10
	if not self._objective_unit then
		self:_clear_objective_unit()
	end

	Unit.flow_event(self._unit, "state_LOOTED")

	self._reward_collected = true

	if not self._is_server then
		local go_id = Managers.state.unit_storage:go_id(self._unit)

		Managers.state.network.network_transmit:send_rpc_server("rpc_deus_chest_looted", go_id)
	end

	self._telemetry_data.chosen_boon = arg_10_1.name
end

DeusCursedChestExtension._clear_objective_unit = function (self)
	-- function 11
	World.unlink_unit(Unit.world(self._objective_unit), self._objective_unit)
	Managers.state.unit_spawner:mark_for_deletion(self._objective_unit)

	self._objective_unit = nil
	self._objective_unit_timeout = nil

	GwNavAStar.destroy(self._objective_unit_astar)

	self._objective_unit_astar = nil
	self._objective_unit_running_astar = nil
end

DeusCursedChestExtension._set_objective_unit_activate = function (self, arg_12_1)
	-- function 12
	if not self._objective_unit then
		ScriptUnit.extension(self._objective_unit, "tutorial_system"):set_active(arg_12_1)
	end
end

DeusCursedChestExtension.can_interact = function (self)
	-- function 13
	local _get_state = self:_get_state()

	return (_get_state == tbl_2.WAITING or _get_state == tbl_2.OPEN) and not self._reward_collected
end

DeusCursedChestExtension.get_interaction_length = function (self)
	-- function 14
	if self:_get_state() == tbl_2.WAITING then
		local _unit = self._unit
		local get_data = Unit.get_data(_unit, "interaction_data", "interaction_length")

		fassert(get_data, "Interacting with %q that has no interaction length", _unit)

		return get_data
	else
		return 0
	end
end

DeusCursedChestExtension.get_interaction_action = function (self)
	-- function 15
	if self:_get_state() == tbl_2.OPEN then
		return "deus_cursed_chest_get_reward_hud_desc"
	else
		return "interaction_action_cursed_chest"
	end
end

DeusCursedChestExtension.on_server_interact = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	-- function 16
	if self:_get_state() == tbl_2.WAITING then
		ScriptUnit.extension_input(arg_16_2, "dialogue_system"):trigger_networked_dialogue_event("deus_cursed_chest_activated")
		self:_set_state(tbl_2.RUNNING)
	end
end

DeusCursedChestExtension.on_client_interact = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	-- function 17
	if self:_get_state() == tbl_2.OPEN then
		Managers.ui:handle_transition("deus_cursed_chest", {
			interactable_unit = arg_17_3
		})
		ScriptUnit.extension(arg_17_2, "inventory_system"):check_and_drop_pickups("deus_cursed_chest")
	end
end

DeusCursedChestExtension._get_state = function (self)
	-- function 18
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	if not (not game and go_id) then
		return tbl_2.INITIALIZING
	end

	local game_object_field = GameSession.game_object_field(game, go_id, "collected_by_peers")
	local get_own_peer_id = Managers.mechanism:game_mechanism():get_deus_run_controller():get_own_peer_id()
	local _reward_collected = self._reward_collected
	local contains = table.contains(game_object_field, get_own_peer_id)

	if not (contains == _reward_collected or contains ~= true) then
		return tbl_2.HOTJOIN_OPEN
	end

	return GameSession.game_object_field(game, go_id, "deus_cursed_chest_state")
end

DeusCursedChestExtension._update_telemetry = function (self, arg_19_1)
	-- function 19
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit
	local var_19_2 = POSITION_LOOKUP[flag]

	if not var_19_2 then
		return
	end

	local _telemetry_data = self._telemetry_data

	if _telemetry_data.activated == "not_found" then
		local var_19_4 = POSITION_LOOKUP[arg_19_1]

		if Vector3.distance_squared(var_19_2, var_19_4) < 625 then
			_telemetry_data.activated = false
		end
	end
end

DeusCursedChestExtension._ui_event_add_mission_objective = function (arg_20_0, arg_20_1)
	-- function 20
	arg_20_0._telemetry_data.challenge_name = arg_20_1

	Managers.state.event:unregister("ui_event_add_mission_objective", arg_20_0)
end

DeusCursedChestExtension._set_state = function (self, arg_21_1)
	-- function 21
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	fassert(not game and go_id, "setting state without network setup done")
	GameSession.set_game_object_field(game, go_id, "deus_cursed_chest_state", arg_21_1)
end

DeusCursedChestExtension.rpc_deus_chest_looted = function (self, arg_22_1, arg_22_2)
	-- function 22
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	if arg_22_2 ~= go_id then
		return
	end

	local game = Managers.state.network:game()

	fassert(not game and go_id, "setting state without network setup done")

	local game_object_field = GameSession.game_object_field(game, go_id, "collected_by_peers")
	local var_22_3 = CHANNEL_TO_PEER_ID[arg_22_1]

	table.insert(game_object_field, var_22_3)
	GameSession.set_game_object_field(game, go_id, "collected_by_peers", game_object_field)
end
