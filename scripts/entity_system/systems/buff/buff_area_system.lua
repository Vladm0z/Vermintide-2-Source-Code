-- chunkname: @scripts/entity_system/systems/buff/buff_area_system.lua

require("scripts/unit_extensions/default_player_unit/buffs/buff_area_extension")

BuffAreaSystem = class(BuffAreaSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_play_enter_buff_zone_sfx",
	"rpc_play_leave_buff_zone_sfx"
}
local var_0_1 = {
	"BuffAreaExtension"
}

function BuffAreaSystem.init(arg_1_0, arg_1_1, arg_1_2)
	BuffAreaSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0._inside_by_side_and_template = {}
	arg_1_0._inside_by_area = {}
	arg_1_0._buff_area_extensions = {}

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))
end

function BuffAreaSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

function BuffAreaSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, ...)
	local var_3_0 = BuffAreaSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, ...)
	local var_3_1 = var_3_0.template

	if var_3_1.shared_area then
		local var_3_2 = var_3_0.side
		local var_3_3 = var_3_1.name
		local var_3_4 = arg_3_0._inside_by_side_and_template

		var_3_4[var_3_2] = var_3_4[var_3_2] or {}

		local var_3_5 = var_3_4[var_3_2]

		var_3_5[var_3_3] = var_3_5[var_3_3] or {
			by_broadphase = {},
			by_position = {},
			buff_ids = {}
		}
	else
		arg_3_0._inside_by_area[var_3_0] = {
			by_broadphase = {},
			by_position = {},
			buff_ids = {}
		}
	end

	arg_3_0._buff_area_extensions[arg_3_2] = var_3_0

	return var_3_0
end

function BuffAreaSystem.inside_by_area(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.template

	if var_4_0.shared_area then
		local var_4_1 = arg_4_1.side
		local var_4_2 = var_4_0.name

		return arg_4_0._inside_by_side_and_template[var_4_1][var_4_2]
	else
		return arg_4_0._inside_by_area[arg_4_1]
	end
end

function BuffAreaSystem.rpc_play_enter_buff_zone_sfx(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Managers.state.unit_storage:unit(arg_5_2)
	local var_5_1 = arg_5_0._buff_area_extensions[var_5_0]

	if var_5_1 then
		var_5_1:play_enter_buff_zone_sfx()
	end
end

function BuffAreaSystem.rpc_play_leave_buff_zone_sfx(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.state.unit_storage:unit(arg_6_2)
	local var_6_1 = arg_6_0._buff_area_extensions[var_6_0]

	if var_6_1 then
		var_6_1:play_leave_buff_zone_sfx()
	end
end
