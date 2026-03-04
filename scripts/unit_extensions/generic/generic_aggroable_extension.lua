-- chunkname: @scripts/unit_extensions/generic/generic_aggroable_extension.lua

GenericAggroableExtension = class(GenericAggroableExtension)

function GenericAggroableExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.aggro_modifier_passive = Unit.has_data(arg_1_2, "aggro_modifier_passive") and Unit.get_data(arg_1_2, "aggro_modifier_passive") * -1 or 0
	arg_1_0.aggro_modifier_active = Unit.has_data(arg_1_2, "aggro_modifier_active") and Unit.get_data(arg_1_2, "aggro_modifier_active") * -1 or 0

	arg_1_0:use_passive_aggro()
end

function GenericAggroableExtension.use_passive_aggro(arg_2_0)
	arg_2_0.aggro_modifier = arg_2_0.aggro_modifier_passive
end

function GenericAggroableExtension.use_active_aggro(arg_3_0)
	arg_3_0.aggro_modifier = arg_3_0.aggro_modifier_active
end

function GenericAggroableExtension.destroy(arg_4_0)
	return
end
