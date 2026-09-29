-- chunkname: @scripts/entity_system/systems/buff/buff_area_system.lua

require("scripts/unit_extensions/default_player_unit/buffs/buff_area_extension")

BuffAreaSystem = class(BuffAreaSystem, ExtensionSystemBase)

local RPCS = {
	"rpc_play_enter_buff_zone_sfx",
	"rpc_play_leave_buff_zone_sfx"
}
local extensions = {
	"BuffAreaExtension"
}

BuffAreaSystem.init = function (self, entity_system_creation_context, system_name)
	-- function 1
	BuffAreaSystem.super.init(self, entity_system_creation_context, system_name, extensions)

	self._inside_by_side_and_template = {}
	self._inside_by_area = {}
	self._buff_area_extensions = {}

	local network_event_delegate = entity_system_creation_context.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(RPCS))
end

BuffAreaSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

BuffAreaSystem.on_add_extension = function (self, world, unit, extension_name, ...)
	-- function 3
	local buff_area_extension = BuffAreaSystem.super.on_add_extension(self, world, unit, extension_name, ...)
	local buff_template = buff_area_extension.template

	if buff_template.shared_area then
		local side = buff_area_extension.side
		local name = buff_template.name
		local inside = self._inside_by_side_and_template

		inside[side] = not not inside[side]
		inside = inside[side]
		inside[name] = not not inside[name]
	else
		self._inside_by_area[buff_area_extension] = {
			by_broadphase = {},
			by_position = {},
			buff_ids = {}
		}
	end

	self._buff_area_extensions[unit] = buff_area_extension

	return buff_area_extension
end

BuffAreaSystem.inside_by_area = function (self, buff_area_extension)
	-- function 4
	local template = buff_area_extension.template

	if template.shared_area then
		local side = buff_area_extension.side
		local name = template.name

		return self._inside_by_side_and_template[side][name]
	else
		return self._inside_by_area[buff_area_extension]
	end
end

BuffAreaSystem.rpc_play_enter_buff_zone_sfx = function (self, channel_id, go_id)
	-- function 5
	local unit = Managers.state.unit_storage:unit(go_id)
	local extension = self._buff_area_extensions[unit]

	if extension then
		extension:play_enter_buff_zone_sfx()
	end
end

BuffAreaSystem.rpc_play_leave_buff_zone_sfx = function (self, channel_id, go_id)
	-- function 6
	local unit = Managers.state.unit_storage:unit(go_id)
	local extension = self._buff_area_extensions[unit]

	if extension then
		extension:play_leave_buff_zone_sfx()
	end
end
