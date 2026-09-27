-- chunkname: @scripts/utils/action_assert_funcs.lua

ActionAssertFuncs = {
	handgun = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		local impact_data = arg_1_3.impact_data

		if not impact_data then
			local damage_profile = impact_data.damage_profile

			fassert(damage_profile, "No damage profile set in impact_data for [\"%s.%s\"] in weapon [\"%s\"]", arg_1_1, arg_1_2, arg_1_0)
			fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)
		else
			local damage_profile_2 = arg_1_3.damage_profile

			fassert(damage_profile_2, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_1_1, arg_1_2, arg_1_0)
			fassert(DamageProfileTemplates[damage_profile_2], "Damage profile [\"%s\"] does not exist", damage_profile_2)
		end
	end,
	sweep = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		if arg_2_3.weapon_action_hand == "both" then
			local damage_profile_left = arg_2_3.damage_profile_left

			fassert(damage_profile_left, "No left damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_2_1, arg_2_2, arg_2_0)
			fassert(DamageProfileTemplates[damage_profile_left], "Damage profile [\"%s\"] does not exist", damage_profile_left)

			local damage_profile_right = arg_2_3.damage_profile_right

			fassert(damage_profile_right, "No right damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_2_1, arg_2_2, arg_2_0)
			fassert(DamageProfileTemplates[damage_profile_right], "Damage profile [\"%s\"] does not exist", damage_profile_right)
		else
			local damage_profile = arg_2_3.damage_profile

			fassert(damage_profile, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_2_1, arg_2_2, arg_2_0)
			fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)
		end
	end,
	charged_sweep = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		if arg_3_3.weapon_action_hand == "both" then
			local damage_profile_left = arg_3_3.damage_profile_left

			fassert(damage_profile_left, "No left damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
			fassert(DamageProfileTemplates[damage_profile_left], "Damage profile [\"%s\"] does not exist", damage_profile_left)

			local damage_profile_right = arg_3_3.damage_profile_right

			fassert(damage_profile_right, "No right damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
			fassert(DamageProfileTemplates[damage_profile_right], "Damage profile [\"%s\"] does not exist", damage_profile_right)
		else
			local damage_profile = arg_3_3.damage_profile

			fassert(damage_profile, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
			fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)
		end

		fassert(not arg_3_3.hit_time, "unsupported parameter hit_time set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)

		if not arg_3_3.discharge_attack then
			fassert(arg_3_3.discharge_effects, "Action marked as discharge attack, but no discharge_effects set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
		else
			fassert(arg_3_3.overcharge_type, "Action marked as charge attack, but no overcharge_type set for [\"%s.%s\"] in weapon [\"%s\"]", arg_3_1, arg_3_2, arg_3_0)
		end
	end,
	push_stagger = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		local damage_profile_inner = arg_4_3.damage_profile_inner

		fassert(damage_profile_inner, "No inner damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_4_1, arg_4_2, arg_4_0)
		fassert(DamageProfileTemplates[damage_profile_inner], "Damage profile [\"%s\"] does not exist", damage_profile_inner)

		local damage_profile_outer = arg_4_3.damage_profile_outer

		fassert(damage_profile_outer, "No outer damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_4_1, arg_4_2, arg_4_0)
		fassert(DamageProfileTemplates[damage_profile_outer], "Damage profile [\"%s\"] does not exist", damage_profile_outer)
	end,
	shield_slam = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		local damage_profile = arg_5_3.damage_profile

		fassert(damage_profile, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_5_1, arg_5_2, arg_5_0)
		fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)

		local damage_profile_aoe = arg_5_3.damage_profile_aoe

		fassert(damage_profile_aoe, "No aoe damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_5_1, arg_5_2, arg_5_0)
		fassert(DamageProfileTemplates[damage_profile_aoe], "Damage profile [\"%s\"] does not exist", damage_profile_aoe)
	end,
	shotgun = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		local damage_profile = arg_6_3.damage_profile

		fassert(damage_profile, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_6_1, arg_6_2, arg_6_0)
		fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)
	end,
	geiser = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		local damage_profile = arg_7_3.damage_profile

		fassert(damage_profile, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_7_1, arg_7_2, arg_7_0)
		fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)
	end,
	beam = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		-- function 8
		local damage_profile = arg_8_3.damage_profile

		fassert(damage_profile, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_8_1, arg_8_2, arg_8_0)
		fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)
	end,
	flamethrower = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		local damage_profile = arg_9_3.damage_profile

		fassert(damage_profile, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_9_1, arg_9_2, arg_9_0)
		fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)
	end,
	warpfire_thrower = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		-- function 10
		local damage_profile = arg_10_3.damage_profile

		fassert(damage_profile, "No damage profile set for [\"%s.%s\"] in weapon [\"%s\"]", arg_10_1, arg_10_2, arg_10_0)
		fassert(DamageProfileTemplates[damage_profile], "Damage profile [\"%s\"] does not exist", damage_profile)
	end,
	charge = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		-- function 11
		local charge_time = arg_11_3.charge_time

		fassert(charge_time, "No charge time set for [\"%s.%s\"] in weapon [\"%s\"]", arg_11_1, arg_11_2, arg_11_0)
	end,
	action_selector = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		-- function 12
		local actions = rawget(Weapons, arg_12_0).actions
		local conditional_actions = arg_12_3.conditional_actions
		local default_action = arg_12_3.default_action

		fassert(conditional_actions, "No conditional_actions set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)
		fassert(default_action, "No default_action set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)
		fassert(actions, "No default_action set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)

		local action = default_action.action

		action = action or arg_12_1

		local var_12_4 = actions[action]

		fassert(var_12_4, "Linked to invalid default action [\"%s\"] for [\"%s.%s\"] in weapon [\"%s\"]", action, arg_12_1, arg_12_2, arg_12_0)

		local sub_action = default_action.sub_action
		local var_12_6 = var_12_4[sub_action]

		fassert(var_12_6, "Linked to invalid default sub_action [\"%s.%s\"] for [\"%s.%s\"] in weapon [\"%s\"]", action, sub_action, arg_12_1, arg_12_2, arg_12_0)
		fassert(var_12_6.kind ~= "action_selector", "Recursive action_selector in [\"%s.%s\"] -> [\"%s.%s\"]  in weapon [\"%s\"]", arg_12_1, arg_12_2, action, sub_action, arg_12_0)

		for i = 1, #conditional_actions do
			local sub_action_2 = conditional_actions[i].sub_action

			fassert(sub_action_2, "No linked sub action set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)

			local condition = conditional_actions[i].condition

			fassert(condition, "No linked sub action condition set for [\"%s.%s\"] in weapon [\"%s\"]", arg_12_1, arg_12_2, arg_12_0)

			local action_2 = conditional_actions[i].action

			action_2 = action_2 or arg_12_1

			local var_12_10 = actions[action_2]

			fassert(var_12_10, "Linked to invalid action [\"%s\"] for [\"%s.%s\"] in weapon [\"%s\"]", action_2, arg_12_1, arg_12_2, arg_12_0)

			local var_12_11 = var_12_10[sub_action_2]

			fassert(var_12_11, "Linked to invalid sub_action [\"%s.%s\"] for [\"%s.%s\"] in weapon [\"%s\"]", action_2, sub_action_2, arg_12_1, arg_12_2, arg_12_0)
			fassert(var_12_11.kind ~= "action_selector", "Recursive action_selector in [\"%s.%s\"] -> [\"%s.%s\"]  in weapon [\"%s\"]", arg_12_1, arg_12_2, action_2, sub_action_2, arg_12_0)
		end
	end
}
