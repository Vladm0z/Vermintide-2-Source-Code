-- chunkname: @scripts/entity_system/systems/interaction/interactable_system.lua

require("scripts/unit_extensions/generic/generic_unit_interactable_extension")
require("scripts/unit_extensions/generic/local_interactable_extension")

InteractableSystem = class(InteractableSystem, ExtensionSystemBase)

local tbl = {
	"rpc_generic_interaction_request"
}
local tbl_2 = {
	"GenericUnitInteractableExtension",
	"LocalInteractableExtension"
}

InteractableSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	InteractableSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.unit_extensions = {}
end

InteractableSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

InteractableSystem.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	local dt = arg_3_1.dt

	if not script_data.debug_interactions then
		for k, v in pairs(self.unit_extensions) do
			local box, var_3_2 = Unit.box(k)

			QuickDrawer:box(box, var_3_2)
		end
	end
end

InteractableSystem.on_add_extension = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local on_add_extension = InteractableSystem.super.on_add_extension(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	arg_4_0.unit_extensions[arg_4_2] = on_add_extension

	return on_add_extension
end

InteractableSystem.on_remove_extension = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	arg_5_0.unit_extensions[arg_5_1] = nil

	InteractableSystem.super.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
end

InteractableSystem._can_interact_server_check = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not Unit.alive(arg_6_1) and not Unit.alive(arg_6_2) then
		return not not ScriptUnit.extension(arg_6_2, "interactable_system"):is_being_interacted_with() or InteractionDefinitions[arg_6_3].server.can_interact(arg_6_1, arg_6_2)
	end

	return false
end

InteractableSystem._handle_standard_interact_request = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local unit = self.unit_storage:unit(arg_7_3)
	local var_7_1

	if not arg_7_5 then
		local current_level = LevelHelper:current_level(self.world)

		var_7_1 = Level.unit_by_index(current_level, arg_7_4)

		fassert(var_7_1, "Interactable unit was not found in level")
	else
		var_7_1 = self.unit_storage:unit(arg_7_4)
	end

	if not self:_can_interact_server_check(unit, var_7_1, arg_7_1) then
		ScriptUnit.extension(unit, "interactor_system"):interaction_approved(arg_7_1, var_7_1)
		InteractionHelper:approve_request(arg_7_1, unit, var_7_1)

		return
	end

	InteractionHelper:deny_request(arg_7_2, arg_7_3)
end

local str = "IS_LOCAL_HOST"

InteractableSystem.rpc_generic_interaction_request = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local peer_id

	if arg_8_1 == str then
		peer_id = Network.peer_id()

		if not peer_id then
			-- Nothing
		end
	end

	peer_id = CHANNEL_TO_PEER_ID[arg_8_1]

	::label_8_0::

	local var_8_1 = NetworkLookup.interactions[arg_8_5]

	InteractionHelper.printf("rpc_generic_interaction_request(%s, %s, %s, %s, %s)", peer_id, tostring(arg_8_2), tostring(arg_8_3), tostring(arg_8_4), var_8_1)
	self:_handle_standard_interact_request(var_8_1, peer_id, arg_8_2, arg_8_3, arg_8_4)
end
