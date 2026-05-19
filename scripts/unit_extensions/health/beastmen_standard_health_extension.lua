-- chunkname: @scripts/unit_extensions/health/beastmen_standard_health_extension.lua

BeastmenStandardHealthExtension = class(BeastmenStandardHealthExtension, GenericHealthExtension)

function BeastmenStandardHealthExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	BeastmenStandardHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._unit = arg_1_2
end

function BeastmenStandardHealthExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	return
end

function BeastmenStandardHealthExtension.destroy(arg_3_0)
	BeastmenStandardHealthExtension.super.destroy(arg_3_0)

	arg_3_0.blackboard = nil
end

function BeastmenStandardHealthExtension.apply_client_predicted_damage(arg_4_0, arg_4_1)
	return
end

local var_0_0 = {
	grenade_frag_02 = true,
	torch = true,
	grenade_fire_01 = true,
	grenade_fire_02 = true,
	wpn_deus_relic_01 = true,
	grenade_frag_01 = true,
	explosive_barrel = true,
	markus_questingknight_career_skill_weapon = true,
	dr_deus_01 = true,
	shadow_torch = true
}

function BeastmenStandardHealthExtension.add_damage(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	if arg_5_7 == "suicide" then
		BeastmenStandardHealthExtension.super.add_damage(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	else
		local var_5_0 = false

		if arg_5_15 and (arg_5_15 == "heavy_attack" or arg_5_15 == "light_attack") or var_0_0[arg_5_7] then
			BeastmenStandardHealthExtension.super.add_damage(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)

			local var_5_1 = ScriptUnit.has_extension(arg_5_0._unit, "ai_supplementary_system")
			local var_5_2 = var_5_1.standard_template

			if var_5_2 then
				local var_5_3 = var_5_2.sfx_taking_damage

				WwiseUtils.trigger_unit_event(var_5_1.world, var_5_3, arg_5_0._unit, 0)
			end
		end
	end
end
