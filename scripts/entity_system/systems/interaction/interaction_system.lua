-- chunkname: @scripts/entity_system/systems/interaction/interaction_system.lua

require("scripts/unit_extensions/generic/generic_unit_interactor_extension")
require("scripts/unit_extensions/generic/generic_husk_interactor_extension")

InteractionSystem = class(InteractionSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_interaction_approved",
	"rpc_interaction_denied",
	"rpc_interaction_completed",
	"rpc_interaction_abort",
	"rpc_sync_interactable_used_state",
	"rpc_sync_interaction_state"
}
local var_0_1 = {
	"GenericHuskInteractorExtension",
	"GenericUnitInteractorExtension"
}

function InteractionSystem.init(arg_1_0, arg_1_1, arg_1_2)
	InteractionSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.extension_init_context.dice_keeper = arg_1_1.dice_keeper
end

function InteractionSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

function InteractionSystem.rpc_interaction_approved(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = NetworkLookup.interactions[arg_3_2]
	local var_3_1 = arg_3_0.unit_storage:unit(arg_3_3)
	local var_3_2 = arg_3_0.unit_storage:unit(arg_3_4)

	if arg_3_5 then
		local var_3_3 = LevelHelper:current_level(arg_3_0.world)

		var_3_2 = Level.unit_by_index(var_3_3, arg_3_4)

		fassert(var_3_2, "Couldn't find level unit to interact with.")
	end

	if not Unit.alive(var_3_2) or not Unit.alive(var_3_1) then
		return
	end

	InteractionHelper.printf("rpc_interaction_approved(%s, %s, %s, %s, %s)", arg_3_1, var_3_0, tostring(arg_3_3), tostring(arg_3_4), tostring(arg_3_5))
	InteractionHelper:request_approved(var_3_0, var_3_1, var_3_2)
end

function InteractionSystem.rpc_interaction_denied(arg_4_0, arg_4_1, arg_4_2)
	InteractionHelper.printf("rpc_interaction_denied(%s, %s)", arg_4_1, tostring(arg_4_2))

	local var_4_0 = arg_4_0.unit_storage:unit(arg_4_2)

	if ALIVE[var_4_0] then
		InteractionHelper:request_denied(var_4_0)
	end
end

function InteractionSystem.rpc_interaction_completed(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	InteractionHelper.printf("rpc_interaction_completed(%s, %s, %s)", arg_5_1, tostring(arg_5_2), InteractionResult[arg_5_3])

	local var_5_0 = arg_5_0.unit_storage:unit(arg_5_2)

	if not Unit.alive(var_5_0) then
		return
	end

	local var_5_1 = ScriptUnit.extension(var_5_0, "interactor_system")

	if not var_5_1:is_interacting() then
		InteractionHelper.printf("got rpc_interaction_completed but wasnt interacting (%s, %s, %s)", arg_5_1, tostring(arg_5_2), InteractionResult[arg_5_3])

		return
	end

	local var_5_2 = var_5_1:interactable_unit()

	InteractionHelper:interaction_completed(var_5_0, var_5_2, arg_5_3)
end

function InteractionSystem.rpc_interaction_abort(arg_6_0, arg_6_1, arg_6_2)
	InteractionHelper.printf("rpc_interaction_abort(%s, %s)", arg_6_1, tostring(arg_6_2))
	fassert(arg_6_0.is_server or LEVEL_EDITOR_TEST, "Error, this should only be run on server!")

	local var_6_0 = arg_6_0.unit_storage:unit(arg_6_2)

	InteractionHelper:abort_authoritative(var_6_0)
end

function InteractionSystem.rpc_sync_interaction_state(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8)
	local var_7_0 = arg_7_0.unit_storage:unit(arg_7_2)

	if not var_7_0 then
		return
	end

	local var_7_1 = NetworkLookup.interaction_states[arg_7_3]
	local var_7_2 = NetworkLookup.interactions[arg_7_4]
	local var_7_3 = Managers.state.network:game_object_or_level_unit(arg_7_5, arg_7_8)

	ScriptUnit.extension(var_7_0, "interactor_system"):set_interaction_context(var_7_1, var_7_2, var_7_3, arg_7_6, arg_7_7)
end

function InteractionSystem.rpc_sync_interactable_used_state(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = Managers.state.network:game_object_or_level_unit(arg_8_2, arg_8_3)

	Unit.set_data(var_8_0, "interaction_data", "used", arg_8_4)
end
