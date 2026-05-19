-- chunkname: @scripts/entity_system/systems/interaction/interactable_system.lua

require("scripts/unit_extensions/generic/generic_unit_interactable_extension")
require("scripts/unit_extensions/generic/local_interactable_extension")

InteractableSystem = class(InteractableSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_generic_interaction_request"
}
local var_0_1 = {
	"GenericUnitInteractableExtension",
	"LocalInteractableExtension"
}

function InteractableSystem.init(arg_1_0, arg_1_1, arg_1_2)
	InteractableSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.unit_extensions = {}
end

function InteractableSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

function InteractableSystem.update(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1.dt

	if script_data.debug_interactions then
		for iter_3_0, iter_3_1 in pairs(arg_3_0.unit_extensions) do
			local var_3_1, var_3_2 = Unit.box(iter_3_0)

			QuickDrawer:box(var_3_1, var_3_2)
		end
	end
end

function InteractableSystem.on_add_extension(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = InteractableSystem.super.on_add_extension(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	arg_4_0.unit_extensions[arg_4_2] = var_4_0

	return var_4_0
end

function InteractableSystem.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.unit_extensions[arg_5_1] = nil

	InteractableSystem.super.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
end

function InteractableSystem._can_interact_server_check(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if Unit.alive(arg_6_1) and Unit.alive(arg_6_2) then
		return not ScriptUnit.extension(arg_6_2, "interactable_system"):is_being_interacted_with() and InteractionDefinitions[arg_6_3].server.can_interact(arg_6_1, arg_6_2)
	end

	return false
end

function InteractableSystem._handle_standard_interact_request(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0.unit_storage:unit(arg_7_3)
	local var_7_1

	if arg_7_5 then
		local var_7_2 = LevelHelper:current_level(arg_7_0.world)

		var_7_1 = Level.unit_by_index(var_7_2, arg_7_4)

		fassert(var_7_1, "Interactable unit was not found in level")
	else
		var_7_1 = arg_7_0.unit_storage:unit(arg_7_4)
	end

	if arg_7_0:_can_interact_server_check(var_7_0, var_7_1, arg_7_1) then
		ScriptUnit.extension(var_7_0, "interactor_system"):interaction_approved(arg_7_1, var_7_1)
		InteractionHelper:approve_request(arg_7_1, var_7_0, var_7_1)

		return
	end

	InteractionHelper:deny_request(arg_7_2, arg_7_3)
end

local var_0_2 = "IS_LOCAL_HOST"

function InteractableSystem.rpc_generic_interaction_request(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_1 == var_0_2 and Network.peer_id() or CHANNEL_TO_PEER_ID[arg_8_1]
	local var_8_1 = NetworkLookup.interactions[arg_8_5]

	InteractionHelper.printf("rpc_generic_interaction_request(%s, %s, %s, %s, %s)", var_8_0, tostring(arg_8_2), tostring(arg_8_3), tostring(arg_8_4), var_8_1)
	arg_8_0:_handle_standard_interact_request(var_8_1, var_8_0, arg_8_2, arg_8_3, arg_8_4)
end
