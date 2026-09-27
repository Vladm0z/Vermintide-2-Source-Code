-- chunkname: @scripts/entity_system/systems/interaction/interaction_system.lua

require("scripts/unit_extensions/generic/generic_unit_interactor_extension")
require("scripts/unit_extensions/generic/generic_husk_interactor_extension")

InteractionSystem = class(InteractionSystem, ExtensionSystemBase)

local tbl = {
	"rpc_interaction_approved",
	"rpc_interaction_denied",
	"rpc_interaction_completed",
	"rpc_interaction_abort",
	"rpc_sync_interactable_used_state",
	"rpc_sync_interaction_state"
}
local tbl_2 = {
	"GenericHuskInteractorExtension",
	"GenericUnitInteractorExtension"
}

InteractionSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	InteractionSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.extension_init_context.dice_keeper = arg_1_1.dice_keeper
end

InteractionSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

InteractionSystem.rpc_interaction_approved = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local var_3_0 = NetworkLookup.interactions[arg_3_2]
	local unit = self.unit_storage:unit(arg_3_3)
	local unit_2 = self.unit_storage:unit(arg_3_4)

	if not arg_3_5 then
		local current_level = LevelHelper:current_level(self.world)

		unit_2 = Level.unit_by_index(current_level, arg_3_4)

		fassert(unit_2, "Couldn't find level unit to interact with.")
	end

	if not (not Unit.alive(unit_2) and Unit.alive(unit)) then
		return
	end

	InteractionHelper.printf("rpc_interaction_approved(%s, %s, %s, %s, %s)", arg_3_1, var_3_0, tostring(arg_3_3), tostring(arg_3_4), tostring(arg_3_5))
	InteractionHelper:request_approved(var_3_0, unit, unit_2)
end

InteractionSystem.rpc_interaction_denied = function (self, arg_4_1, arg_4_2)
	-- function 4
	InteractionHelper.printf("rpc_interaction_denied(%s, %s)", arg_4_1, tostring(arg_4_2))

	local unit = self.unit_storage:unit(arg_4_2)

	if not ALIVE[unit] then
		InteractionHelper:request_denied(unit)
	end
end

InteractionSystem.rpc_interaction_completed = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	InteractionHelper.printf("rpc_interaction_completed(%s, %s, %s)", arg_5_1, tostring(arg_5_2), InteractionResult[arg_5_3])

	local unit = self.unit_storage:unit(arg_5_2)

	if not Unit.alive(unit) then
		return
	end

	local extension = ScriptUnit.extension(unit, "interactor_system")

	if not extension:is_interacting() then
		InteractionHelper.printf("got rpc_interaction_completed but wasnt interacting (%s, %s, %s)", arg_5_1, tostring(arg_5_2), InteractionResult[arg_5_3])

		return
	end

	local interactable_unit = extension:interactable_unit()

	InteractionHelper:interaction_completed(unit, interactable_unit, arg_5_3)
end

InteractionSystem.rpc_interaction_abort = function (self, arg_6_1, arg_6_2)
	-- function 6
	InteractionHelper.printf("rpc_interaction_abort(%s, %s)", arg_6_1, tostring(arg_6_2))

	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Error, this should only be run on server!")

	local unit = self.unit_storage:unit(arg_6_2)

	InteractionHelper:abort_authoritative(unit)
end

InteractionSystem.rpc_sync_interaction_state = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8)
	-- function 7
	local unit = self.unit_storage:unit(arg_7_2)

	if not unit then
		return
	end

	local var_7_1 = NetworkLookup.interaction_states[arg_7_3]
	local var_7_2 = NetworkLookup.interactions[arg_7_4]
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_7_5, arg_7_8)

	ScriptUnit.extension(unit, "interactor_system"):set_interaction_context(var_7_1, var_7_2, game_object_or_level_unit, arg_7_6, arg_7_7)
end

InteractionSystem.rpc_sync_interactable_used_state = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_8_2, arg_8_3)

	Unit.set_data(game_object_or_level_unit, "interaction_data", "used", arg_8_4)
end
