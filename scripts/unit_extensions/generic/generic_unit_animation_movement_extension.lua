-- chunkname: @scripts/unit_extensions/generic/generic_unit_animation_movement_extension.lua

require("scripts/unit_extensions/generic/animation_movement_templates")

GenericUnitAnimationMovementExtension = class(GenericUnitAnimationMovementExtension)

GenericUnitAnimationMovementExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2

	local var_1_0 = arg_1_3.template

	arg_1_0.template = AnimationMovementTemplates[var_1_0]
	arg_1_0.network_type = arg_1_3.is_husk and "husk" or "owner"
	arg_1_0.data = {}
	arg_1_0.enabled = false
end

GenericUnitAnimationMovementExtension.extensions_ready = function (arg_2_0)
	arg_2_0.template[arg_2_0.network_type].init(arg_2_0.unit, arg_2_0.data)

	local var_2_0 = Unit.get_data(arg_2_0.unit, "breed")
end

GenericUnitAnimationMovementExtension.destroy = function (arg_3_0)
	arg_3_0.template[arg_3_0.network_type].leave(arg_3_0.unit, arg_3_0.data)

	arg_3_0.template = nil
	arg_3_0.data = nil
end

GenericUnitAnimationMovementExtension.reset = function (arg_4_0)
	return
end

GenericUnitAnimationMovementExtension.set_enabled = function (arg_5_0, arg_5_1)
	arg_5_0.enabled = arg_5_1

	if not arg_5_1 then
		arg_5_0.leave = true
	end
end

GenericUnitAnimationMovementExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0.data
	local var_6_1 = arg_6_0.template

	if arg_6_0.enabled then
		var_6_1[arg_6_0.network_type].update(arg_6_1, arg_6_5, arg_6_3, var_6_0)
	elseif arg_6_0.leave then
		var_6_1[arg_6_0.network_type].leave(arg_6_1, var_6_0)

		arg_6_0.leave = false
	end
end
