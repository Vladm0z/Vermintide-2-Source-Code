-- chunkname: @scripts/unit_extensions/generic/generic_aggroable_extension.lua

GenericAggroableExtension = class(GenericAggroableExtension)

GenericAggroableExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.aggro_modifier_passive = Unit.has_data(arg_1_2, "aggro_modifier_passive") and Unit.get_data(arg_1_2, "aggro_modifier_passive") * -1 or 0
	arg_1_0.aggro_modifier_active = Unit.has_data(arg_1_2, "aggro_modifier_active") and Unit.get_data(arg_1_2, "aggro_modifier_active") * -1 or 0

	arg_1_0:use_passive_aggro()
end

GenericAggroableExtension.use_passive_aggro = function (arg_2_0)
	arg_2_0.aggro_modifier = arg_2_0.aggro_modifier_passive
end

GenericAggroableExtension.use_active_aggro = function (arg_3_0)
	arg_3_0.aggro_modifier = arg_3_0.aggro_modifier_active
end

GenericAggroableExtension.destroy = function (arg_4_0)
	return
end
