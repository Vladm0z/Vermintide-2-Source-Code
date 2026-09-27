-- chunkname: @scripts/entity_system/systems/buff/buff_area_system.lua

require("scripts/unit_extensions/default_player_unit/buffs/buff_area_extension")

BuffAreaSystem = class(BuffAreaSystem, ExtensionSystemBase)

local tbl = {
	"rpc_play_enter_buff_zone_sfx",
	"rpc_play_leave_buff_zone_sfx"
}
local tbl_2 = {
	"BuffAreaExtension"
}

BuffAreaSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	BuffAreaSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self._inside_by_side_and_template = {}
	self._inside_by_area = {}
	self._buff_area_extensions = {}

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
end

BuffAreaSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

BuffAreaSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, ...)
	-- function 3
	local on_add_extension = BuffAreaSystem.super.on_add_extension(self, arg_3_1, arg_3_2, arg_3_3, ...)
	local template = on_add_extension.template

	if not template.shared_area then
		local side = on_add_extension.side
		local name = template.name
		local _inside_by_side_and_template = self._inside_by_side_and_template
		local var_3_5 = _inside_by_side_and_template[side]

		var_3_5 = var_3_5 or {}
		_inside_by_side_and_template[side] = var_3_5

		local var_3_6 = _inside_by_side_and_template[side]
		local var_3_7 = var_3_6[name]

		var_3_7 = var_3_7 or {
			by_broadphase = {},
			by_position = {},
			buff_ids = {}
		}
		var_3_6[name] = var_3_7
	else
		self._inside_by_area[on_add_extension] = {
			by_broadphase = {},
			by_position = {},
			buff_ids = {}
		}
	end

	self._buff_area_extensions[arg_3_2] = on_add_extension

	return on_add_extension
end

BuffAreaSystem.inside_by_area = function (self, arg_4_1)
	-- function 4
	local template = arg_4_1.template

	if not template.shared_area then
		local side = arg_4_1.side
		local name = template.name

		return self._inside_by_side_and_template[side][name]
	else
		return self._inside_by_area[arg_4_1]
	end
end

BuffAreaSystem.rpc_play_enter_buff_zone_sfx = function (self, arg_5_1, arg_5_2)
	-- function 5
	local unit = Managers.state.unit_storage:unit(arg_5_2)
	local var_5_1 = self._buff_area_extensions[unit]

	if not var_5_1 then
		var_5_1:play_enter_buff_zone_sfx()
	end
end

BuffAreaSystem.rpc_play_leave_buff_zone_sfx = function (self, arg_6_1, arg_6_2)
	-- function 6
	local unit = Managers.state.unit_storage:unit(arg_6_2)
	local var_6_1 = self._buff_area_extensions[unit]

	if not var_6_1 then
		var_6_1:play_leave_buff_zone_sfx()
	end
end
