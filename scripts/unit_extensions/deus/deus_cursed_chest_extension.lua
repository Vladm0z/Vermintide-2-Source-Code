-- chunkname: @scripts/unit_extensions/deus/deus_cursed_chest_extension.lua

DeusCursedChestExtension = class(DeusCursedChestExtension)

local var_0_0 = {
	"rpc_deus_chest_looted"
}
local var_0_1 = {
	OPEN = 3,
	HOTJOIN_OPEN = 4,
	WAITING = 1,
	INITIALIZING = 0,
	RUNNING = 2
}
local var_0_2 = 4
local var_0_3 = {
	trigger_cursed_chest = "trigger_cursed_chest",
	finish_cursed_chest = "finish_cursed_chest"
}
local var_0_4 = 60

local function var_0_5(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = POSITION_LOOKUP[arg_1_1] + Vector3(math.random(-0.5, 0.5), math.random(-0.5, 0.5), 2)

	arg_1_0:spawn_pickup(arg_1_2, var_1_0, Quaternion.identity(), true, "dropped")
end

function DeusCursedChestExtension.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._unit = arg_2_2
	arg_2_0._is_server = Managers.player.is_server

	arg_2_0:register_rpcs(arg_2_1.network_transmit.network_event_delegate)
end

function DeusCursedChestExtension.game_object_initialized(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_set_state(var_0_1.WAITING)
end

function DeusCursedChestExtension.extensions_ready(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	fassert(arg_4_0._deus_run_controller, "deus pickup unit can only be used in a deus run")

	arg_4_0._telemetry_data = {
		activated = "not_found",
		success = false,
		chosen_boon = "n/a",
		challenge_name = "n/a",
		level_count = arg_4_0._deus_run_controller:get_completed_level_count() + 1,
		run_id = arg_4_0._deus_run_controller:get_run_id()
	}
end

function DeusCursedChestExtension.destroy(arg_5_0)
	if arg_5_0._objective_unit then
		arg_5_0:_clear_objective_unit()
	end

	arg_5_0:unregister_rpcs()

	if arg_5_0._telemetry_data.activated ~= "not_found" and not arg_5_0._telemetry_data.hotjoined_late then
		Managers.telemetry_events:cursed_chest_passed(arg_5_0._telemetry_data)
	end
end

function DeusCursedChestExtension.register_rpcs(arg_6_0, arg_6_1)
	arg_6_1:register(arg_6_0, unpack(var_0_0))

	arg_6_0._network_event_delegate = arg_6_1
end

function DeusCursedChestExtension.unregister_rpcs(arg_7_0)
	arg_7_0._network_event_delegate:unregister(arg_7_0)

	arg_7_0._network_event_delegate = nil
end

function DeusCursedChestExtension.update(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_0._prev_state
	local var_8_1 = arg_8_0:_get_state()

	if var_8_0 ~= var_8_1 then
		if var_8_1 == var_0_1.WAITING then
			Unit.flow_event(arg_8_0._unit, "state_WAITING")
		elseif var_8_1 == var_0_1.RUNNING then
			Unit.flow_event(arg_8_0._unit, "state_RUNNING")

			if var_8_0 == var_0_1.INITIALIZING then
				local var_8_2 = Managers.state.entity:system("mission_system"):get_missions()
				local var_8_3 = table.find_func(var_8_2, function(arg_9_0)
					return string.sub(arg_9_0, 1, string.len("cursed_chest_challenge")) == "cursed_chest_challenge"
				end)

				arg_8_0._telemetry_data.challenge_name = var_8_3 or "hotjoin"
			else
				Managers.state.event:register(arg_8_0, "ui_event_add_mission_objective", "_ui_event_add_mission_objective")
			end

			arg_8_0._telemetry_data.activated = true

			if arg_8_0._is_server then
				arg_8_0._terror_event_name = "cursed_chest_prototype"

				local var_8_4 = Managers.mechanism:get_level_seed()

				Managers.state.conflict:start_terror_event(arg_8_0._terror_event_name, var_8_4, arg_8_1)

				local var_8_5 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

				for iter_8_0 = 1, #var_8_5 do
					if ALIVE[var_8_5[iter_8_0]] then
						ScriptUnit.extension(var_8_5[iter_8_0], "buff_system"):trigger_procs("cursed_chest_running", arg_8_0._unit)
					end
				end
			end

			local var_8_6 = POSITION_LOOKUP[arg_8_0._unit]

			WwiseUtils.trigger_position_event(arg_8_4.world, var_0_3.trigger_cursed_chest, var_8_6)
		elseif var_8_1 == var_0_1.HOTJOIN_OPEN then
			Unit.flow_event(arg_8_0._unit, "state_HOTJOIN_OPEN")

			arg_8_0._reward_collected = true
			arg_8_0._telemetry_data.hotjoined_late = true
		elseif var_8_1 == var_0_1.OPEN then
			if arg_8_0._is_server then
				Managers.mechanism:game_mechanism():get_deus_run_controller():record_cursed_chest_purified()

				arg_8_0._play_dialogue_at = arg_8_5 + var_0_2
			end

			local var_8_7 = POSITION_LOOKUP[arg_8_0._unit]

			WwiseUtils.trigger_position_event(arg_8_4.world, var_0_3.finish_cursed_chest, var_8_7)

			local var_8_8 = "units/hub_elements/objective_unit"
			local var_8_9 = Managers.state.unit_spawner:spawn_local_unit(var_8_8, POSITION_LOOKUP[arg_8_1])

			Unit.set_data(var_8_9, "objective_server_only", true)
			Managers.state.unit_spawner:create_unit_extensions(Unit.world(var_8_9), var_8_9, "objective_unit")
			ScriptUnit.extension(var_8_9, "tutorial_system"):set_active(true)
			World.link_unit(Unit.world(arg_8_1), var_8_9, 0, arg_8_1, 0)

			arg_8_0._objective_unit = var_8_9
			arg_8_0._objective_unit_timeout = arg_8_5 + var_0_4
			arg_8_0._objective_unit_astar = GwNavAStar.create()

			Unit.flow_event(arg_8_0._unit, "state_OPEN")

			local var_8_10 = Managers.player:local_player()

			Managers.state.event:trigger("player_cleansed_deus_cursed_chest", var_8_10)

			arg_8_0._telemetry_data.success = true
		end

		if var_8_1 == var_0_1.HOTJOIN_OPEN then
			arg_8_0._prev_state = var_0_1.OPEN
		else
			arg_8_0._prev_state = var_8_1
		end
	elseif var_8_1 == var_0_1.RUNNING and arg_8_0._is_server and not TerrorEventMixer.find_event(arg_8_0._terror_event_name) then
		arg_8_0:_set_state(var_0_1.OPEN)
	end

	if arg_8_0._objective_unit then
		if arg_8_5 > arg_8_0._objective_unit_timeout then
			arg_8_0:_clear_objective_unit()
		elseif arg_8_0._objective_unit_running_astar then
			if GwNavAStar.processing_finished(arg_8_0._objective_unit_astar) then
				arg_8_0._objective_unit_running_astar = false

				if not GwNavAStar.path_found(arg_8_0._objective_unit_astar) then
					arg_8_0:_set_objective_unit_activate(false)
				else
					arg_8_0:_set_objective_unit_activate(true)
				end
			end
		else
			local var_8_11 = POSITION_LOOKUP[arg_8_1]
			local var_8_12 = Managers.player:local_player()
			local var_8_13 = var_8_12 and var_8_12.player_unit

			if var_8_13 then
				local var_8_14 = POSITION_LOOKUP[var_8_13]
				local var_8_15 = Managers.state.bot_nav_transition:traverse_logic()
				local var_8_16 = Managers.state.entity:system("ai_system"):nav_world()

				GwNavAStar.start_with_propagation_box(arg_8_0._objective_unit_astar, var_8_16, var_8_14, var_8_11, 30, var_8_15)

				arg_8_0._objective_unit_running_astar = true
			end
		end
	end

	if arg_8_0._play_dialogue_at and arg_8_5 >= arg_8_0._play_dialogue_at then
		arg_8_0._play_dialogue_at = nil

		local var_8_17 = LevelHelper:find_dialogue_unit(arg_8_4.world, "ferry_lady")

		if var_8_17 then
			local var_8_18 = ScriptUnit.extension_input(var_8_17, "dialogue_system")
			local var_8_19 = FrameTable.alloc_table()

			var_8_18:trigger_dialogue_event("cursed_chest_purified", var_8_19)
		end
	end

	arg_8_0:_update_telemetry(arg_8_1)
end

function DeusCursedChestExtension.on_reward_collected(arg_10_0, arg_10_1)
	if arg_10_0._objective_unit then
		arg_10_0:_clear_objective_unit()
	end

	Unit.flow_event(arg_10_0._unit, "state_LOOTED")

	arg_10_0._reward_collected = true

	if not arg_10_0._is_server then
		local var_10_0 = Managers.state.unit_storage:go_id(arg_10_0._unit)

		Managers.state.network.network_transmit:send_rpc_server("rpc_deus_chest_looted", var_10_0)
	end

	arg_10_0._telemetry_data.chosen_boon = arg_10_1.name
end

function DeusCursedChestExtension._clear_objective_unit(arg_11_0)
	World.unlink_unit(Unit.world(arg_11_0._objective_unit), arg_11_0._objective_unit)
	Managers.state.unit_spawner:mark_for_deletion(arg_11_0._objective_unit)

	arg_11_0._objective_unit = nil
	arg_11_0._objective_unit_timeout = nil

	GwNavAStar.destroy(arg_11_0._objective_unit_astar)

	arg_11_0._objective_unit_astar = nil
	arg_11_0._objective_unit_running_astar = nil
end

function DeusCursedChestExtension._set_objective_unit_activate(arg_12_0, arg_12_1)
	if arg_12_0._objective_unit then
		ScriptUnit.extension(arg_12_0._objective_unit, "tutorial_system"):set_active(arg_12_1)
	end
end

function DeusCursedChestExtension.can_interact(arg_13_0)
	local var_13_0 = arg_13_0:_get_state()

	return (var_13_0 == var_0_1.WAITING or var_13_0 == var_0_1.OPEN) and not arg_13_0._reward_collected
end

function DeusCursedChestExtension.get_interaction_length(arg_14_0)
	if arg_14_0:_get_state() == var_0_1.WAITING then
		local var_14_0 = arg_14_0._unit
		local var_14_1 = Unit.get_data(var_14_0, "interaction_data", "interaction_length")

		fassert(var_14_1, "Interacting with %q that has no interaction length", var_14_0)

		return var_14_1
	else
		return 0
	end
end

function DeusCursedChestExtension.get_interaction_action(arg_15_0)
	if arg_15_0:_get_state() == var_0_1.OPEN then
		return "deus_cursed_chest_get_reward_hud_desc"
	else
		return "interaction_action_cursed_chest"
	end
end

function DeusCursedChestExtension.on_server_interact(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	if arg_16_0:_get_state() == var_0_1.WAITING then
		ScriptUnit.extension_input(arg_16_2, "dialogue_system"):trigger_networked_dialogue_event("deus_cursed_chest_activated")
		arg_16_0:_set_state(var_0_1.RUNNING)
	end
end

function DeusCursedChestExtension.on_client_interact(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	if arg_17_0:_get_state() == var_0_1.OPEN then
		Managers.ui:handle_transition("deus_cursed_chest", {
			interactable_unit = arg_17_3
		})
		ScriptUnit.extension(arg_17_2, "inventory_system"):check_and_drop_pickups("deus_cursed_chest")
	end
end

function DeusCursedChestExtension._get_state(arg_18_0)
	local var_18_0 = Managers.state.network:game()
	local var_18_1 = Managers.state.unit_storage:go_id(arg_18_0._unit)

	if not var_18_0 or not var_18_1 then
		return var_0_1.INITIALIZING
	end

	local var_18_2 = GameSession.game_object_field(var_18_0, var_18_1, "collected_by_peers")
	local var_18_3 = Managers.mechanism:game_mechanism():get_deus_run_controller():get_own_peer_id()
	local var_18_4 = arg_18_0._reward_collected
	local var_18_5 = table.contains(var_18_2, var_18_3)

	if var_18_5 ~= var_18_4 and var_18_5 == true then
		return var_0_1.HOTJOIN_OPEN
	end

	return GameSession.game_object_field(var_18_0, var_18_1, "deus_cursed_chest_state")
end

function DeusCursedChestExtension._update_telemetry(arg_19_0, arg_19_1)
	local var_19_0 = Managers.player:local_player()
	local var_19_1 = var_19_0 and var_19_0.player_unit
	local var_19_2 = POSITION_LOOKUP[var_19_1]

	if not var_19_2 then
		return
	end

	local var_19_3 = arg_19_0._telemetry_data

	if var_19_3.activated == "not_found" then
		local var_19_4 = POSITION_LOOKUP[arg_19_1]

		if Vector3.distance_squared(var_19_2, var_19_4) < 625 then
			var_19_3.activated = false
		end
	end
end

function DeusCursedChestExtension._ui_event_add_mission_objective(arg_20_0, arg_20_1)
	arg_20_0._telemetry_data.challenge_name = arg_20_1

	Managers.state.event:unregister("ui_event_add_mission_objective", arg_20_0)
end

function DeusCursedChestExtension._set_state(arg_21_0, arg_21_1)
	local var_21_0 = Managers.state.network:game()
	local var_21_1 = Managers.state.unit_storage:go_id(arg_21_0._unit)

	fassert(var_21_0 and var_21_1, "setting state without network setup done")
	GameSession.set_game_object_field(var_21_0, var_21_1, "deus_cursed_chest_state", arg_21_1)
end

function DeusCursedChestExtension.rpc_deus_chest_looted(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = Managers.state.unit_storage:go_id(arg_22_0._unit)

	if arg_22_2 ~= var_22_0 then
		return
	end

	local var_22_1 = Managers.state.network:game()

	fassert(var_22_1 and var_22_0, "setting state without network setup done")

	local var_22_2 = GameSession.game_object_field(var_22_1, var_22_0, "collected_by_peers")
	local var_22_3 = CHANNEL_TO_PEER_ID[arg_22_1]

	table.insert(var_22_2, var_22_3)
	GameSession.set_game_object_field(var_22_1, var_22_0, "collected_by_peers", var_22_2)
end
