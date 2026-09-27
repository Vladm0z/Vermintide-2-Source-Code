-- chunkname: @scripts/entity_system/systems/payload/payload_system.lua

require("scripts/unit_extensions/level/payload_extension")

PayloadSystem = class(PayloadSystem, ExtensionSystemBase)

local tbl = {
	"rpc_payload_flow_event"
}
local tbl_2 = {
	"PayloadExtension",
	"PayloadGizmoExtension"
}

PayloadSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	PayloadSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self._payloads = {}
	self._payload_gizmos = {}
end

PayloadSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

PayloadSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)
	-- function 3
	local _payload_gizmos = self._payload_gizmos
	local var_3_1

	if arg_3_3 == "PayloadExtension" then
		self._payloads[#self._payloads + 1] = arg_3_2
		var_3_1 = PickupSystem.super.on_add_extension(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)
	elseif arg_3_3 == "PayloadGizmoExtension" then
		local get_data = Unit.get_data(arg_3_2, "spline_name")

		fassert(get_data ~= "", "Spline Gizmo added to level without spline name at position %s", Unit.world_position(arg_3_2, 0))

		if not _payload_gizmos[get_data] then
			_payload_gizmos[get_data] = {}
		end

		local var_3_3 = _payload_gizmos[get_data]

		var_3_3[#var_3_3 + 1] = arg_3_2
		var_3_1 = {}
	end

	return var_3_1
end

PayloadSystem.init_payloads = function (self)
	-- function 4
	local _payloads = self._payloads
	local count = #_payloads
	local _payload_gizmos = self._payload_gizmos

	for i = 1, count do
		local var_4_3 = _payloads[i]
		local get_data = Unit.get_data(var_4_3, "spline_name")
		local extension = ScriptUnit.extension(var_4_3, "payload_system")
		local var_4_6 = _payload_gizmos[get_data]

		extension:init_payload(var_4_6)
	end
end

PayloadSystem.rpc_payload_flow_event = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local current_level = LevelHelper:current_level(self.world)
	local unit_by_index = Level.unit_by_index(current_level, arg_5_2)

	ScriptUnit.extension(unit_by_index, "payload_system"):payload_flow_event(arg_5_3)
end

PayloadSystem.hot_join_sync = function (arg_6_0)
	-- function 6
	return
end
