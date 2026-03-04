-- chunkname: @scripts/settings/dlcs/bless/action_wheel_selector.lua

ActionWheelSelector = class(ActionWheelSelector, ActionBase)

local var_0_0 = 0.125
local var_0_1 = 0.25
local var_0_2 = 0.01
local var_0_3 = 0.125

ActionWheelSelector.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionWheelSelector.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.weapon_unit = arg_1_7
	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
end

ActionWheelSelector.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionWheelSelector.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0.timer_per_seg = arg_2_1.timer_per_seg
	arg_2_0.num_seg = arg_2_1.num_seg
	arg_2_0._timer = arg_2_2 + arg_2_0.timer_per_seg
	arg_2_0.current_seg = arg_2_0.current_seg and arg_2_0.current_seg + 1 or 1

	if arg_2_0.current_seg > arg_2_0.num_seg then
		arg_2_0.current_seg = 1
	end

	arg_2_0.shader_info = arg_2_1.shader_info
end

ActionWheelSelector.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_2 > arg_3_0._timer then
		arg_3_0.current_seg = arg_3_0.current_seg + 1

		if arg_3_0.current_seg > arg_3_0.num_seg then
			arg_3_0.current_seg = 1
		end

		arg_3_0._timer = arg_3_2 + arg_3_0.timer_per_seg
	end

	arg_3_0.weapon_extension:set_mode(arg_3_0.current_seg)

	if arg_3_0.shader_info then
		local var_3_0 = arg_3_0.shader_info.material_slot
		local var_3_1 = arg_3_0.shader_info.variable_name

		Unit.set_scalar_for_material(arg_3_0.weapon_unit, var_3_0, var_3_1, arg_3_0.current_seg - 1)
	end
end

ActionWheelSelector.finish = function (arg_4_0, arg_4_1, arg_4_2)
	ActionChangeMode.super.finish(arg_4_0, arg_4_1)
end
