-- chunkname: @scripts/unit_extensions/generic/rat_ogre_health_extension.lua

RatOgreHealthExtension = class(RatOgreHealthExtension, GenericHealthExtension)

function RatOgreHealthExtension.init(arg_1_0, arg_1_1, arg_1_2, ...)
	RatOgreHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

	arg_1_0._wounded_anim_variable = Unit.animation_find_variable(arg_1_2, "wounded")
end

function RatOgreHealthExtension.update(arg_2_0, arg_2_1, ...)
	local var_2_0 = arg_2_0.unit
	local var_2_1 = arg_2_0.damage / arg_2_0.health > 0.5 and 1 or 0

	Unit.animation_set_variable(var_2_0, arg_2_0._wounded_anim_variable, var_2_1)
end
