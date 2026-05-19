-- chunkname: @scripts/unit_extensions/generic/generic_husk_interactor_extension.lua

GenericHuskInteractorExtension = class(GenericHuskInteractorExtension)

function GenericHuskInteractorExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.state = "waiting_to_interact"
	arg_1_0.interaction_context = {
		data = {
			is_husk = true,
			dice_keeper = arg_1_1.dice_keeper,
			statistics_db = arg_1_1.statistics_db
		}
	}
	arg_1_0.is_server = Managers.player.is_server

	function arg_1_0.interactable_unit_destroy_callback(arg_2_0)
		local var_2_0 = Managers.time:time("game")

		arg_1_0:_stop_interaction(arg_2_0, var_2_0)
	end
end

function GenericHuskInteractorExtension.game_object_unit_destroyed(arg_3_0)
	if Managers.state.network:game() and arg_3_0.is_server then
		local var_3_0 = arg_3_0.interaction_context.interactable_unit

		if Unit.alive(var_3_0) and arg_3_0.state == "doing_interaction" then
			InteractionHelper.printf("[GenericHuskInteractorExtension] stopping due to game_object_unit_destroyed")
			InteractionHelper:complete_interaction(arg_3_0.unit, var_3_0, InteractionResult.FAILURE)
		end
	end
end

function GenericHuskInteractorExtension.destroy(arg_4_0)
	local var_4_0 = arg_4_0.interaction_context.interactable_unit

	if Unit.alive(var_4_0) then
		Managers.state.unit_spawner:remove_destroy_listener(var_4_0, "interactable_unit_for_husk")
	end
end

function GenericHuskInteractorExtension.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.world
	local var_5_1 = arg_5_0.interaction_context
	local var_5_2 = var_5_1.interactable_unit
	local var_5_3 = var_5_1.data

	var_5_3.is_server = arg_5_0.is_server

	local var_5_4 = var_5_1.interaction_type
	local var_5_5 = InteractionDefinitions[var_5_4]
	local var_5_6 = var_5_5 and var_5_5.config or nil

	if arg_5_0.state == "starting_interaction" then
		var_5_5.client.start(var_5_0, arg_5_1, var_5_2, var_5_3, var_5_6, arg_5_5)

		if arg_5_0.is_server then
			var_5_5.server.start(var_5_0, arg_5_1, var_5_2, var_5_3, var_5_6, arg_5_5)
		end

		var_5_1.previous_state = arg_5_0.state
		arg_5_0.state = "doing_interaction"
	end

	if arg_5_0.state == "doing_interaction" then
		var_5_5.client.update(var_5_0, arg_5_1, var_5_2, var_5_3, var_5_6, arg_5_3, arg_5_5)

		if arg_5_0.is_server then
			local var_5_7 = var_5_5.server.update(var_5_0, arg_5_1, var_5_2, var_5_3, var_5_6, arg_5_3, arg_5_5)

			var_5_1.result = var_5_7

			if var_5_7 ~= InteractionResult.ONGOING then
				InteractionHelper:complete_interaction(arg_5_1, var_5_2, var_5_7)
			end
		end
	end
end

function GenericHuskInteractorExtension._stop_interaction(arg_6_0, arg_6_1, arg_6_2)
	Managers.state.unit_spawner:remove_destroy_listener(arg_6_1, "interactable_unit_for_husk")

	local var_6_0 = arg_6_0.world
	local var_6_1 = arg_6_0.unit
	local var_6_2 = arg_6_0.interaction_context
	local var_6_3 = var_6_2.data

	var_6_3.is_server = arg_6_0.is_server

	local var_6_4 = var_6_2.interaction_type
	local var_6_5 = InteractionDefinitions[var_6_4]
	local var_6_6 = var_6_5 and var_6_5.config or nil
	local var_6_7 = var_6_2.local_only
	local var_6_8, var_6_9 = Managers.state.network:game_object_or_level_id(arg_6_1)

	if not var_6_9 and var_6_8 == nil then
		InteractionHelper.printf("[GenericUnitInteractorExtension] game object doesnt exist, changing result from %s to %s", InteractionResult[var_6_2.result], InteractionResult[InteractionResult.FAILURE])

		var_6_2.result = InteractionResult.FAILURE
	end

	local var_6_10 = var_6_2.result

	if var_6_10 == InteractionResult.ONGOING or var_6_10 == nil then
		var_6_10 = InteractionResult.FAILURE
		var_6_2.result = var_6_10
	end

	InteractionHelper.printf("[GenericHuskInteractorExtension] Stopping interaction %s with result %s", var_6_4, InteractionResult[var_6_10])
	var_6_5.client.stop(var_6_0, var_6_1, arg_6_1, var_6_3, var_6_6, arg_6_2, var_6_10)

	if arg_6_0.is_server and not var_6_7 then
		var_6_5.server.stop(var_6_0, var_6_1, arg_6_1, var_6_3, var_6_6, arg_6_2, var_6_10)
	end

	var_6_2.previous_state = arg_6_0.state
	arg_6_0.state = "waiting_to_interact"
end

function GenericHuskInteractorExtension.is_interacting(arg_7_0)
	local var_7_0 = arg_7_0.interaction_context.interaction_type

	return arg_7_0.state ~= "waiting_to_interact", var_7_0
end

function GenericHuskInteractorExtension.is_stopping(arg_8_0)
	return arg_8_0.state == "stopping_interaction"
end

function GenericHuskInteractorExtension.interactable_unit(arg_9_0)
	assert(arg_9_0:is_interacting(), "Attempted to get interactable unit when interactor unit wasn't interacting.")

	return arg_9_0.interaction_context.interactable_unit
end

function GenericHuskInteractorExtension.hot_join_sync(arg_10_0, arg_10_1)
	if not arg_10_0:is_interacting() then
		return
	end

	local var_10_0 = Managers.state.network
	local var_10_1 = arg_10_0.interaction_context
	local var_10_2 = NetworkLookup.interaction_states[arg_10_0.state]
	local var_10_3 = NetworkLookup.interactions[var_10_1.interaction_type]
	local var_10_4, var_10_5 = var_10_0:game_object_or_level_id(var_10_1.interactable_unit)
	local var_10_6 = var_10_1.data
	local var_10_7 = var_10_6.start_time
	local var_10_8 = var_10_6.duration or 0
	local var_10_9 = var_10_0:unit_game_object_id(arg_10_0.unit)
	local var_10_10 = PEER_ID_TO_CHANNEL[arg_10_1]

	RPC.rpc_sync_interaction_state(var_10_10, var_10_9, var_10_2, var_10_3, var_10_4, var_10_7, var_10_8, var_10_5)
end

function GenericHuskInteractorExtension.set_interaction_context(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	InteractionHelper.printf("[GenericHuskInteractorExtension] set_interaction_context %s %s %s", arg_11_1, arg_11_2, tostring(arg_11_3))

	arg_11_0.interaction_context.previous_state = arg_11_0.state
	arg_11_0.state = arg_11_1
	arg_11_0.interaction_context.data.start_time = arg_11_4
	arg_11_0.interaction_context.data.duration = arg_11_5
	arg_11_0.interaction_context.interactable_unit = arg_11_3
	arg_11_0.interaction_context.interaction_type = arg_11_2
	arg_11_0.interaction_context.result = InteractionResult.ONGOING

	ScriptUnit.extension(arg_11_3, "interactable_system"):set_is_being_interacted_with(arg_11_0.unit)
end

function GenericHuskInteractorExtension.interaction_approved(arg_12_0, arg_12_1, arg_12_2)
	if not Unit.alive(arg_12_2) then
		InteractionHelper.printf("[GenericHuskInteractorExtension] interaction_approved interactable_unit no longer alive interaction_type:%s", arg_12_1)

		return
	end

	InteractionHelper.printf("[GenericHuskInteractorExtension] interaction_approved %s %s", arg_12_1, tostring(arg_12_2))

	arg_12_0.interaction_context.previous_state = arg_12_0.state
	arg_12_0.state = "starting_interaction"

	local var_12_0 = arg_12_0.interaction_context

	var_12_0.interaction_type = arg_12_1
	var_12_0.interactable_unit = arg_12_2
	var_12_0.result = InteractionResult.ONGOING

	local var_12_1 = var_12_0.data

	var_12_1.duration = InteractionDefinitions[arg_12_1].config.duration
	var_12_1.start_time = Managers.time:time("game")

	Managers.state.unit_spawner:add_destroy_listener(arg_12_2, "interactable_unit_for_husk", arg_12_0.interactable_unit_destroy_callback)
end

function GenericHuskInteractorExtension.interaction_completed(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.state

	InteractionHelper.printf("[GenericHuskInteractorExtension] interaction_completed during state %s with result %s", var_13_0, InteractionResult[arg_13_1])
	assert(var_13_0 ~= "waiting_to_interact", "Was in wrong state when getting interaction completed.")

	arg_13_0.interaction_context.result = arg_13_1

	local var_13_1 = arg_13_0.interaction_context.interactable_unit
	local var_13_2 = Managers.time:time("game")

	arg_13_0:_stop_interaction(var_13_1, var_13_2)
end
