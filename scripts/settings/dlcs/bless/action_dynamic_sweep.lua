-- chunkname: @scripts/settings/dlcs/bless/action_dynamic_sweep.lua

ActionDynamicSweep = class(ActionDynamicSweep, ActionSweep)

function ActionDynamicSweep.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionDynamicSweep.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
end

function ActionDynamicSweep._get_damage_profile_name(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.weapon_extension:get_mode()
	local var_2_1 = arg_2_2.dynamic_profiles[var_2_0]

	return arg_2_1 and arg_2_2["damage_profile_" .. arg_2_1] or var_2_1 or "default"
end

function ActionDynamicSweep._calculate_attack_direction(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.weapon_extension:get_mode()
	local var_3_1 = arg_3_1.dynamic_attack_direction[var_3_0]
	local var_3_2 = arg_3_1.attack_direction or "forward"
	local var_3_3 = Quaternion[var_3_2](arg_3_2)

	return var_3_1 and -var_3_3 or var_3_3
end
