-- chunkname: @scripts/entity_system/systems/payload/payload_system.lua

require("scripts/unit_extensions/level/payload_extension")

PayloadSystem = class(PayloadSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_payload_flow_event"
}
local var_0_1 = {
	"PayloadExtension",
	"PayloadGizmoExtension"
}

function PayloadSystem.init(arg_1_0, arg_1_1, arg_1_2)
	PayloadSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0._payloads = {}
	arg_1_0._payload_gizmos = {}
end

function PayloadSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

function PayloadSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)
	local var_3_0 = arg_3_0._payload_gizmos
	local var_3_1

	if arg_3_3 == "PayloadExtension" then
		arg_3_0._payloads[#arg_3_0._payloads + 1] = arg_3_2
		var_3_1 = PickupSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)
	elseif arg_3_3 == "PayloadGizmoExtension" then
		local var_3_2 = Unit.get_data(arg_3_2, "spline_name")

		fassert(var_3_2 ~= "", "Spline Gizmo added to level without spline name at position %s", Unit.world_position(arg_3_2, 0))

		if not var_3_0[var_3_2] then
			var_3_0[var_3_2] = {}
		end

		local var_3_3 = var_3_0[var_3_2]

		var_3_3[#var_3_3 + 1] = arg_3_2
		var_3_1 = {}
	end

	return var_3_1
end

function PayloadSystem.init_payloads(arg_4_0)
	local var_4_0 = arg_4_0._payloads
	local var_4_1 = #var_4_0
	local var_4_2 = arg_4_0._payload_gizmos

	for iter_4_0 = 1, var_4_1 do
		local var_4_3 = var_4_0[iter_4_0]
		local var_4_4 = Unit.get_data(var_4_3, "spline_name")
		local var_4_5 = ScriptUnit.extension(var_4_3, "payload_system")
		local var_4_6 = var_4_2[var_4_4]

		var_4_5:init_payload(var_4_6)
	end
end

function PayloadSystem.rpc_payload_flow_event(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = LevelHelper:current_level(arg_5_0.world)
	local var_5_1 = Level.unit_by_index(var_5_0, arg_5_2)

	ScriptUnit.extension(var_5_1, "payload_system"):payload_flow_event(arg_5_3)
end

function PayloadSystem.hot_join_sync(arg_6_0)
	return
end
