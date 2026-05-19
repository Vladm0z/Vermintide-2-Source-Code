-- chunkname: @scripts/unit_extensions/generic/generic_unit_interactable_extension.lua

GenericUnitInteractableExtension = class(GenericUnitInteractableExtension)

function GenericUnitInteractableExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0._is_level_object = Unit.level(arg_1_2) ~= nil
	arg_1_0.interactable_type = Unit.get_data(arg_1_2, "interaction_data", "interaction_type") or "player_generic"
	arg_1_0._override_interactable_action = Unit.get_data(arg_1_2, "override_interactable_action")
	arg_1_0.interactor_unit = nil
	arg_1_0._enabled = true
	arg_1_0.num_times_successfully_completed = 0
	arg_1_0.interaction_result = nil

	fassert(arg_1_0.interactable_type, "Unit: %s missing interaction_type in its unit data, should it have an interaction extension?", arg_1_2)
end

function GenericUnitInteractableExtension.destroy(arg_2_0)
	return
end

function GenericUnitInteractableExtension.interaction_type(arg_3_0)
	return arg_3_0.interactable_type
end

function GenericUnitInteractableExtension.local_only(arg_4_0)
	return false
end

function GenericUnitInteractableExtension.set_interactable_type(arg_5_0, arg_5_1)
	arg_5_0.interactable_type = arg_5_1
end

function GenericUnitInteractableExtension.set_is_being_interacted_with(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.unit
	local var_6_1 = arg_6_0.interactable_type

	if arg_6_0.interactor_unit then
		fassert(arg_6_1 == nil, "Interactor unit was already set.")

		local var_6_2 = arg_6_0.interactor_unit
		local var_6_3 = "lua_interaction_stopped_" .. var_6_1 .. "_" .. InteractionResult[arg_6_2]

		Unit.flow_event(var_6_0, var_6_3)

		if not (NetworkUnit.is_network_unit(var_6_2) and NetworkUnit.is_husk_unit(var_6_2)) then
			local var_6_4 = "lua_interaction_stopped_local_interactor_" .. var_6_1 .. "_" .. InteractionResult[arg_6_2]

			Unit.flow_event(var_6_0, var_6_4)
		end
	else
		fassert(arg_6_1 ~= nil, "Interactor unit was already nil.")
		Unit.set_flow_variable(var_6_0, "lua_interaction_started_unit", arg_6_1)

		local var_6_5 = "lua_interaction_started_" .. var_6_1

		Unit.flow_event(var_6_0, var_6_5)
	end

	arg_6_0.interactor_unit = arg_6_1
	arg_6_0.interaction_result = arg_6_2
end

function GenericUnitInteractableExtension.is_being_interacted_with(arg_7_0)
	return arg_7_0.interactor_unit
end

function GenericUnitInteractableExtension.hot_join_sync(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.unit

	if Unit.get_data(var_8_0, "interaction_data", "only_once") then
		local var_8_1 = Managers.state.network:game_object_or_level_id(arg_8_0.unit)
		local var_8_2 = Unit.get_data(var_8_0, "interaction_data", "used") or false

		if not (Unit.get_data(var_8_0, "interaction_data", "individual_pickup") or false) and var_8_2 then
			local var_8_3 = PEER_ID_TO_CHANNEL[arg_8_1]

			RPC.rpc_sync_interactable_used_state(var_8_3, var_8_1, arg_8_0._is_level_object, var_8_2)
		end
	end
end

function GenericUnitInteractableExtension.is_enabled(arg_9_0)
	return arg_9_0._enabled
end

function GenericUnitInteractableExtension.set_enabled(arg_10_0, arg_10_1)
	arg_10_0._enabled = arg_10_1
end

function GenericUnitInteractableExtension.override_interactable_action(arg_11_0)
	return arg_11_0._override_interactable_action
end
