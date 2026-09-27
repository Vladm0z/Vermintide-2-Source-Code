-- chunkname: @scripts/entity_system/systems/progress/progress_system.lua

ProgressSystem = class(ProgressSystem, ExtensionSystemBase)

local tbl = {
	"PlayerInZoneExtension"
}
local tbl_2 = {
	"rpc_player_in_zone_set_active",
	"rpc_player_in_zone_end_event"
}

ProgressSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	ProgressSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self._world = arg_1_1.world
	self._network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl_2))

	self._existing_units = {}
end

ProgressSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local on_add_extension = ProgressSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3)

	arg_2_0._existing_units[arg_2_2] = on_add_extension

	return on_add_extension
end

ProgressSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	arg_3_0._existing_units[arg_3_1] = nil

	ProgressSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
end

ProgressSystem.destroy = function (self)
	-- function 4
	self._network_event_delegate:unregister(self)
end

ProgressSystem.rpc_player_in_zone_end_event = function (self, arg_5_1, arg_5_2)
	-- function 5
	local unit_by_index = LevelHelper:unit_by_index(self._world, arg_5_2)

	if not self._existing_units[unit_by_index] then
		self._existing_units[unit_by_index]:end_event()
	end
end

ProgressSystem.rpc_player_in_zone_set_active = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._is_server then
		local network = Managers.state.network
		local var_6_1 = CHANNEL_TO_PEER_ID[arg_6_1]

		network.network_transmit:send_rpc_clients_except("rpc_player_in_zone_set_active", var_6_1, arg_6_2)
	end

	local unit_by_index = LevelHelper:unit_by_index(self._world, arg_6_2)

	if not self._existing_units[unit_by_index] then
		self._existing_units[unit_by_index]:set_active_rpc()
	end
end
