-- chunkname: @scripts/entity_system/systems/progress/progress_system.lua

ProgressSystem = class(ProgressSystem, ExtensionSystemBase)

local extensions = {
	"PlayerInZoneExtension"
}
local RPCS = {
	"rpc_player_in_zone_set_active",
	"rpc_player_in_zone_end_event"
}

ProgressSystem.init = function (self, entity_system_creation_context, system_name)
	-- function 1
	ProgressSystem.super.init(self, entity_system_creation_context, system_name, extensions)

	self._world = entity_system_creation_context.world
	self._network_event_delegate = entity_system_creation_context.network_event_delegate

	self._network_event_delegate:register(self, unpack(RPCS))

	self._existing_units = {}
end

ProgressSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	-- function 2
	local extension = ProgressSystem.super.on_add_extension(self, world, unit, extension_name)

	self._existing_units[unit] = extension

	return extension
end

ProgressSystem.on_remove_extension = function (self, unit, extension_name)
	-- function 3
	self._existing_units[unit] = nil

	ProgressSystem.super.on_remove_extension(self, unit, extension_name)
end

ProgressSystem.destroy = function (self)
	-- function 4
	self._network_event_delegate:unregister(self)
end

ProgressSystem.rpc_player_in_zone_end_event = function (self, channel_id, unit_id)
	-- function 5
	local level_unit = LevelHelper:unit_by_index(self._world, unit_id)

	if self._existing_units[level_unit] then
		self._existing_units[level_unit]:end_event()
	end
end

ProgressSystem.rpc_player_in_zone_set_active = function (self, channel_id, unit_index)
	-- function 6
	if self._is_server then
		local network_manager = Managers.state.network
		local peer_id = CHANNEL_TO_PEER_ID[channel_id]

		network_manager.network_transmit:send_rpc_clients_except("rpc_player_in_zone_set_active", peer_id, unit_index)
	end

	local level_unit = LevelHelper:unit_by_index(self._world, unit_index)

	if self._existing_units[level_unit] then
		self._existing_units[level_unit]:set_active_rpc()
	end
end
