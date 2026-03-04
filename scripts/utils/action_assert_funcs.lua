-- chunkname: @scripts/utils/action_assert_funcs.lua

ActionAssertFuncs = {
	handgun = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = arg_1_3.impact_data

		if var_1_0 then
			local var_1_1 = var_1_0.damage_profile

			fassert(var_1_1, "No damage profile set in impact_data for [\"%s.%s\"] in weapon [\"%s\"]", arg_1_1, arg_1_2, arg_1_0)
			fassert(DamageProfileTemplates[var_1_1], "Damage profile [\"%s\"] does not exist", var_1_1)
		else
			local var_1_2 = arg_1_3.damage_profile

			fassert(var_1_2, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_1_1, arg_1_2, arg_1_0)
			fassert(DamageProfileTemplates[var_1_2], "Damage profile [\"%s\"] does not exist", var_1_2)
		end
	end,
	sweep = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		if arg_2_3.weapon_action_hand == "both" then
			local var_2_0 = arg_2_3.damage_profile_left

			fassert(var_2_0, "No left damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_2_1, arg_2_2, arg_2_0)
			fassert(DamageProfileTemplates[var_2_0], "Damage profile [\"%s\"] does not exist", var_2_0)

			local var_2_1 = arg_2_3.damage_profile_right

			fassert(var_2_1, "No right damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_2_1, arg_2_2, arg_2_0)
			fassert(DamageProfileTemplates[var_2_1], "Damage profile [\"%s\"] does not exist", var_2_1)
		else
			local var_2_2 = arg_2_3.damage_profile

			fassert(var_2_2, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_2_1, arg_2_2, arg_2_0)
			fassert(DamageProfileTemplates[var_2_2], "Damage profile [\"%s\"] does not exist", var_2_2)
		end
	end,
	charged_sweep = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if arg_3_3.weapon_action_hand == "both" then
			local var_3_0 = arg_3_3.damage_profile_left

			fassert(var_3_0, "No left damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
			fassert(DamageProfileTemplates[var_3_0], "Damage profile [\"%s\"] does not exist", var_3_0)

			local var_3_1 = arg_3_3.damage_profile_right

			fassert(var_3_1, "No right damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
			fassert(DamageProfileTemplates[var_3_1], "Damage profile [\"%s\"] does not exist", var_3_1)
		else
			local var_3_2 = arg_3_3.damage_profile

			fassert(var_3_2, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
			fassert(DamageProfileTemplates[var_3_2], "Damage profile [\"%s\"] does not exist", var_3_2)
		end

		fassert(not arg_3_3.hit_time, "unsupported parameter hit_time set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)

		if arg_3_3.discharge_attack then
			fassert(arg_3_3.discharge_effects, "Action marked as discharge attack, but no discharge_effects set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
		else
			fassert(arg_3_3.overcharge_type, "Action marked as charge attack, but no overcharge_type set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
		end
	end,
	push_stagger = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = arg_4_3.damage_profile_inner

		fassert(var_4_0, "No inner damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_4_1, arg_4_2, arg_4_0)
		fassert(DamageProfileTemplates[var_4_0], "Damage profile [\"%s\"] does not exist", var_4_0)

		local var_4_1 = arg_4_3.damage_profile_outer

		fassert(var_4_1, "No outer damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_4_1, arg_4_2, arg_4_0)
		fassert(DamageProfileTemplates[var_4_1], "Damage profile [\"%s\"] does not exist", var_4_1)
	end,
	shield_slam = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = arg_5_3.damage_profile

		fassert(var_5_0, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_5_1, arg_5_2, arg_5_0)
		fassert(DamageProfileTemplates[var_5_0], "Damage profile [\"%s\"] does not exist", var_5_0)

		local var_5_1 = arg_5_3.damage_profile_aoe

		fassert(var_5_1, "No aoe damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_5_1, arg_5_2, arg_5_0)
		fassert(DamageProfileTemplates[var_5_1], "Damage profile [\"%s\"] does not exist", var_5_1)
	end,
	shotgun = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		local var_6_0 = arg_6_3.damage_profile

		fassert(var_6_0, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_6_1, arg_6_2, arg_6_0)
		fassert(DamageProfileTemplates[var_6_0], "Damage profile [\"%s\"] does not exist", var_6_0)
	end,
	geiser = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		local var_7_0 = arg_7_3.damage_profile

		fassert(var_7_0, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_7_1, arg_7_2, arg_7_0)
		fassert(DamageProfileTemplates[var_7_0], "Damage profile [\"%s\"] does not exist", var_7_0)
	end,
	beam = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		local var_8_0 = arg_8_3.damage_profile

		fassert(var_8_0, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_8_1, arg_8_2, arg_8_0)
		fassert(DamageProfileTemplates[var_8_0], "Damage profile [\"%s\"] does not exist", var_8_0)
	end,
	flamethrower = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		local var_9_0 = arg_9_3.damage_profile

		fassert(var_9_0, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_9_1, arg_9_2, arg_9_0)
		fassert(DamageProfileTemplates[var_9_0], "Damage profile [\"%s\"] does not exist", var_9_0)
	end,
	warpfire_thrower = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		local var_10_0 = arg_10_3.damage_profile

		fassert(var_10_0, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_10_1, arg_10_2, arg_10_0)
		fassert(DamageProfileTemplates[var_10_0], "Damage profile [\"%s\"] does not exist", var_10_0)
	end,
	charge = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		local var_11_0 = arg_11_3.charge_time

		fassert(var_11_0, "No charge time set for [\"%s.%s\"] in weapon [\"%s\"]", arg_11_1, arg_11_2, arg_11_0)
	end,
	action_selector = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = rawget(Weapons, arg_12_0).actions
		local var_12_1 = arg_12_3.conditional_actions
		local var_12_2 = arg_12_3.default_action

		fassert(var_12_1, "No conditional_actions set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)
		fassert(var_12_2, "No default_action set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)
		fassert(var_12_0, "No default_action set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)

		local var_12_3 = var_12_2.action or arg_12_1
		local var_12_4 = var_12_0[var_12_3]

		fassert(var_12_4, "Linked to invalid default action [\"%s\"] for [\"%s.%s\"] in weapon [\"%s\"]", var_12_3, arg_12_1, arg_12_2, arg_12_0)

		local var_12_5 = var_12_2.sub_action
		local var_12_6 = var_12_4[var_12_5]

		fassert(var_12_6, "Linked to invalid default sub_action [\"%s.%s\"] for [\"%s.%s\"] in weapon [\"%s\"]", var_12_3, var_12_5, arg_12_1, arg_12_2, arg_12_0)
		fassert(var_12_6.kind ~= "action_selector", "Recursive action_selector in [\"%s.%s\"] -> [\"%s.%s\"]  in weapon [\"%s\"]", arg_12_1, arg_12_2, var_12_3, var_12_5, arg_12_0)

		for iter_12_0 = 1, #var_12_1 do
			local var_12_7 = var_12_1[iter_12_0].sub_action

			fassert(var_12_7, "No linked sub action set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)

			local var_12_8 = var_12_1[iter_12_0].condition

			fassert(var_12_8, "No linked sub action condition set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)

			local var_12_9 = var_12_1[iter_12_0].action or arg_12_1
			local var_12_10 = var_12_0[var_12_9]

			fassert(var_12_10, "Linked to invalid action [\"%s\"] for [\"%s.%s\"] in weapon [\"%s\"]", var_12_9, arg_12_1, arg_12_2, arg_12_0)

			local var_12_11 = var_12_10[var_12_7]

			fassert(var_12_11, "Linked to invalid sub_action [\"%s.%s\"] for [\"%s.%s\"] in weapon [\"%s\"]", var_12_9, var_12_7, arg_12_1, arg_12_2, arg_12_0)
			fassert(var_12_11.kind ~= "action_selector", "Recursive action_selector in [\"%s.%s\"] -> [\"%s.%s\"]  in weapon [\"%s\"]", arg_12_1, arg_12_2, var_12_9, var_12_7, arg_12_0)
		end
	end
}
