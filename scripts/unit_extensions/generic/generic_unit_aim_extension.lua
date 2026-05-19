-- chunkname: @scripts/unit_extensions/generic/generic_unit_aim_extension.lua

require("scripts/unit_extensions/generic/aim_templates")

GenericUnitAimExtension = class(GenericUnitAimExtension)

function GenericUnitAimExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.template = AimTemplates[arg_1_3.template or Unit.get_data(arg_1_2, "aim_template")]
	arg_1_0.network_type = arg_1_3.is_husk and "husk" or "owner"
	arg_1_0.data = {}
	arg_1_0.enabled = false
end

function GenericUnitAimExtension.extensions_ready(arg_2_0)
	arg_2_0.template[arg_2_0.network_type].init(arg_2_0.unit, arg_2_0.data)

	local var_2_0 = Unit.get_data(arg_2_0.unit, "breed")

	arg_2_0.always_aim = DEDICATED_SERVER or var_2_0 and var_2_0.always_look_at_target or arg_2_0.template == "innkeeper"
end

function GenericUnitAimExtension.destroy(arg_3_0)
	arg_3_0.template[arg_3_0.network_type].leave(arg_3_0.unit, arg_3_0.data)

	arg_3_0.template = nil
	arg_3_0.data = nil
end

function GenericUnitAimExtension.reset(arg_4_0)
	return
end

function GenericUnitAimExtension.set_enabled(arg_5_0, arg_5_1)
	arg_5_0.enabled = arg_5_1
end

function GenericUnitAimExtension.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0.data
	local var_6_1 = arg_6_0.template
	local var_6_2 = DamageUtils.is_player_unit(arg_6_1)

	if arg_6_0.enabled or arg_6_0.always_aim or var_6_2 then
		var_6_1[arg_6_0.network_type].update(arg_6_1, arg_6_5, arg_6_3, var_6_0)
	else
		var_6_1[arg_6_0.network_type].leave(arg_6_1, var_6_0)
	end
end
