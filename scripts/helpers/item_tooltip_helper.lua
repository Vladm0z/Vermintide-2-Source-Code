-- chunkname: @scripts/helpers/item_tooltip_helper.lua

ItemTooltipHelper = ItemTooltipHelper or {}

local var_0_0 = {
	damage = function (arg_1_0)
		return string.format("%.2f", arg_1_0)
	end,
	max_targets = function (arg_2_0)
		if arg_2_0 == -1 then
			return "inf."
		end

		return string.format("%.2f", math.round_with_precision(arg_2_0, 2))
	end,
	stagger_strength = function (arg_3_0)
		return string.format("%.2f", math.round_with_precision(arg_3_0, 2))
	end,
	crit = function (arg_4_0)
		return string.format("%.1f", math.round_with_precision(arg_4_0, 1) * 100) .. "%"
	end,
	time_between_damage = function (arg_5_0)
		return string.format("%.2f", math.round_with_precision(arg_5_0, 2))
	end,
	boost = function (arg_6_0)
		return string.format("%.2f", math.round_with_precision(arg_6_0, 2))
	end,
	push_angle = function (arg_7_0)
		return tostring(arg_7_0)
	end,
	push_strength = function (arg_8_0)
		return string.format("%.2f", math.round_with_precision(arg_8_0, 2))
	end
}

ItemTooltipHelper.format_return_string = function (arg_9_0, arg_9_1)
	local var_9_0 = var_0_0[arg_9_0]
	local var_9_1 = ""

	if type(arg_9_1) == "table" then
		for iter_9_0 = 1, #arg_9_1 do
			local var_9_2 = arg_9_1[iter_9_0]

			if var_9_2.type == "charge" then
				var_9_1 = var_9_1 .. var_9_0(var_9_2.value_min) .. "-" .. var_9_0(var_9_2.value_max)
			elseif var_9_2.type == "multi" then
				var_9_1 = var_9_1 .. var_9_0(var_9_2.value) .. " x" .. tostring(var_9_2.shot_count)
			elseif var_9_2.type == "dual" then
				var_9_1 = var_9_1 .. var_9_0(var_9_2.value_left) .. "+" .. var_9_0(var_9_2.value_right)
			else
				var_9_1 = var_9_1 .. var_9_0(var_9_2.value)
			end

			if iter_9_0 < #arg_9_1 then
				var_9_1 = var_9_1 .. " / "
			end
		end
	else
		var_9_1 = var_9_0(arg_9_1)
	end

	return var_9_1
end

ItemTooltipHelper.get_damage = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	local var_10_0 = arg_10_1.name
	local var_10_1 = "torso"
	local var_10_2 = 1
	local var_10_3 = arg_10_4.targets and arg_10_4.targets[var_10_2] or arg_10_4.default_target
	local var_10_4 = BoostCurves[var_10_3.boost_curve_type]
	local var_10_5
	local var_10_6 = false
	local var_10_7 = 1
	local var_10_8 = Breeds.skaven_clan_rat
	local var_10_9 = 0
	local var_10_10 = false

	return (DamageUtils.calculate_damage_tooltip(arg_10_0, var_10_0, arg_10_5, var_10_1, arg_10_4, var_10_2, var_10_4, var_10_5, var_10_6, var_10_7, var_10_8, var_10_9, var_10_10, arg_10_6, arg_10_2, arg_10_3))
end

ItemTooltipHelper.get_stagger_strength = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0
	local var_11_1 = "torso"
	local var_11_2 = false
	local var_11_3 = 1
	local var_11_4 = false
	local var_11_5 = arg_11_1.name
	local var_11_6 = false
	local var_11_7 = 0
	local var_11_8, var_11_9, var_11_10, var_11_11, var_11_12 = DamageUtils.calculate_stagger_player_tooltip(var_11_0, arg_11_0, var_11_1, arg_11_3, var_11_2, arg_11_2, var_11_3, var_11_4, var_11_5, arg_11_4, var_11_6, var_11_7)

	return var_11_8, var_11_9, var_11_10, var_11_11, var_11_12
end

ItemTooltipHelper.get_next_action_names = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.allowed_chain_actions
	local var_12_1 = true

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if iter_12_1.auto_chain then
			var_12_1 = false

			break
		end
	end

	local var_12_2
	local var_12_3
	local var_12_4
	local var_12_5 = 1

	for iter_12_2, iter_12_3 in ipairs(var_12_0) do
		if arg_12_1 == "light" and iter_12_2 == var_12_5 or arg_12_1 == "heavy" and iter_12_3.auto_chain or var_12_1 and arg_12_1 == "heavy" and iter_12_2 == var_12_5 then
			if iter_12_3.input ~= "action_wield" then
				var_12_2 = iter_12_3.action
				var_12_3 = iter_12_3.sub_action
				var_12_4 = iter_12_3.start_time

				break
			else
				var_12_5 = var_12_5 + 1
			end
		end
	end

	return var_12_2, var_12_3, var_12_4
end

ItemTooltipHelper.get_action = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = ScriptUnit.has_extension(arg_13_0, "career_system")
	local var_13_1 = ScriptUnit.has_extension(arg_13_0, "buff_system")
	local var_13_2 = arg_13_1.data
	local var_13_3 = BackendUtils.get_item_template(var_13_2)
	local var_13_4 = var_13_3.actions
	local var_13_5 = arg_13_2.charge_type or "light"
	local var_13_6 = var_13_3.tooltip_compare[var_13_5]

	return var_13_4[var_13_6.action_name][var_13_6.sub_action_name]
end

ItemTooltipHelper.get_chain_damages = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = arg_14_1.impact_data
	local var_14_1 = ScriptUnit.has_extension(arg_14_2, "career_system")
	local var_14_2 = ScriptUnit.has_extension(arg_14_2, "buff_system")
	local var_14_3 = var_14_1:get_career_power_level()
	local var_14_4 = Managers.state.difficulty:get_difficulty()
	local var_14_5 = arg_14_4.armor_types or {}
	local var_14_6 = var_14_5[1] or 1
	local var_14_7 = var_14_5[2]
	local var_14_8 = var_14_0 and var_14_0.damage_profile or arg_14_1.damage_profile
	local var_14_9 = var_14_0 and var_14_0.damage_profile_left or arg_14_1.damage_profile_left
	local var_14_10 = var_14_0 and var_14_0.damage_profile_right or arg_14_1.damage_profile_right

	if var_14_8 then
		local var_14_11 = DamageProfileTemplates[var_14_8]

		if arg_14_1.kind == "charged_projectile" and arg_14_1.scale_power_level then
			local var_14_12 = ActionUtils.scale_charged_projectile_power_level(var_14_3, arg_14_1, 0)
			local var_14_13 = ActionUtils.scale_charged_projectile_power_level(var_14_3, arg_14_1, 1)
			local var_14_14 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, var_14_12, var_14_4)
			local var_14_15 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, var_14_13, var_14_4)

			arg_14_0[#arg_14_0 + 1] = {
				type = "charge",
				value_min = var_14_14,
				value_max = var_14_15
			}
		elseif arg_14_1.kind == "geiser" then
			local var_14_16 = ActionUtils.scale_geiser_power_level(var_14_3, 0)
			local var_14_17 = ActionUtils.scale_geiser_power_level(var_14_3, 1)
			local var_14_18 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, var_14_16, var_14_4)
			local var_14_19 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, var_14_17, var_14_4)

			arg_14_0[#arg_14_0 + 1] = {
				type = "charge",
				value_min = var_14_18,
				value_max = var_14_19
			}
		else
			local var_14_20 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, var_14_3, var_14_4)
			local var_14_21 = var_14_0 and (var_14_0.shot_count or var_14_0.num_projectiles) or arg_14_1.shot_count or arg_14_1.num_projectiles or 1

			arg_14_0[#arg_14_0 + 1] = {
				type = var_14_21 > 1 and "multi" or "single",
				shot_count = var_14_21,
				value = var_14_20
			}
		end
	elseif var_14_9 and var_14_10 then
		local var_14_22 = DamageProfileTemplates[var_14_9]
		local var_14_23 = DamageProfileTemplates[var_14_10]
		local var_14_24 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_22, var_14_3, var_14_4)
		local var_14_25 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_23, var_14_3, var_14_4)

		arg_14_0[#arg_14_0 + 1] = {
			type = "dual",
			value_left = var_14_24,
			value_right = var_14_25
		}
	end
end

ItemTooltipHelper.get_chain_max_targets = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_1.impact_data
	local var_15_1 = ScriptUnit.has_extension(arg_15_2, "career_system")
	local var_15_2 = ScriptUnit.has_extension(arg_15_2, "buff_system")
	local var_15_3 = var_15_1:get_career_power_level()
	local var_15_4 = Managers.state.difficulty:get_difficulty()
	local var_15_5 = var_15_0 and var_15_0.damage_profile or arg_15_1.damage_profile
	local var_15_6 = var_15_0 and var_15_0.damage_profile_left or arg_15_1.damage_profile_left
	local var_15_7 = var_15_0 and var_15_0.damage_profile_right or arg_15_1.damage_profile_right

	if var_15_5 then
		local var_15_8 = DamageProfileTemplates[var_15_5]

		if arg_15_1.kind == "charged_projectile" and arg_15_1.scale_power_level then
			local var_15_9 = ActionUtils.scale_charged_projectile_power_level(var_15_3, arg_15_1, 0)
			local var_15_10 = ActionUtils.scale_charged_projectile_power_level(var_15_3, arg_15_1, 1)
			local var_15_11 = ActionUtils.scale_power_levels(var_15_9, "cleave", arg_15_2, var_15_4)
			local var_15_12 = ActionUtils.scale_power_levels(var_15_10, "cleave", arg_15_2, var_15_4)
			local var_15_13, var_15_14 = ActionUtils.get_max_targets(var_15_8, var_15_11)
			local var_15_15, var_15_16 = ActionUtils.get_max_targets(var_15_8, var_15_12)
			local var_15_17 = var_15_14 < var_15_13 and var_15_13 or var_15_14
			local var_15_18 = var_15_16 < var_15_15 and var_15_15 or var_15_16

			arg_15_0[#arg_15_0 + 1] = {
				type = "charge",
				value_min = var_15_17,
				value_max = var_15_18
			}
		elseif arg_15_1.kind == "geiser" or arg_15_1.kind == "shield_slam" or arg_15_1.kind == "push_stagger" then
			arg_15_0[#arg_15_0 + 1] = {
				value = -1,
				type = "single"
			}
		else
			local var_15_19 = ActionUtils.scale_power_levels(var_15_3, "cleave", arg_15_2, var_15_4)
			local var_15_20, var_15_21 = ActionUtils.get_max_targets(var_15_8, var_15_19)
			local var_15_22 = var_15_21 < var_15_20 and var_15_20 or var_15_21
			local var_15_23 = var_15_0 and (var_15_0.shot_count or var_15_0.num_projectiles) or arg_15_1.shot_count or arg_15_1.num_projectiles or 1

			arg_15_0[#arg_15_0 + 1] = {
				type = var_15_23 > 1 and "multi" or "single",
				shot_count = var_15_23,
				value = var_15_22
			}
		end
	elseif var_15_6 and var_15_7 then
		local var_15_24 = DamageProfileTemplates[var_15_6]
		local var_15_25 = DamageProfileTemplates[var_15_7]
		local var_15_26 = ActionUtils.scale_power_levels(var_15_3, "cleave", arg_15_2, var_15_4)
		local var_15_27, var_15_28 = ActionUtils.get_max_targets(var_15_24, var_15_26)
		local var_15_29, var_15_30 = ActionUtils.get_max_targets(var_15_25, var_15_26)
		local var_15_31 = var_15_28 < var_15_27 and var_15_27 or var_15_28
		local var_15_32 = var_15_30 < var_15_29 and var_15_29 or var_15_30

		arg_15_0[#arg_15_0 + 1] = {
			type = "dual",
			value_left = var_15_31,
			value_right = var_15_32
		}
	end
end

ItemTooltipHelper.get_chain_stagger_strengths = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_1.impact_data
	local var_16_1 = ScriptUnit.has_extension(arg_16_2, "career_system")
	local var_16_2 = ScriptUnit.has_extension(arg_16_2, "buff_system")
	local var_16_3 = var_16_1:get_career_power_level()
	local var_16_4 = Managers.state.difficulty:get_difficulty()
	local var_16_5 = var_16_0 and var_16_0.damage_profile or arg_16_1.damage_profile
	local var_16_6 = var_16_0 and var_16_0.damage_profile_left or arg_16_1.damage_profile_left
	local var_16_7 = var_16_0 and var_16_0.damage_profile_right or arg_16_1.damage_profile_right

	if var_16_5 then
		local var_16_8 = DamageProfileTemplates[var_16_5]

		if arg_16_1.kind == "charged_projectile" and arg_16_1.scale_power_level then
			local var_16_9 = ActionUtils.scale_charged_projectile_power_level(var_16_3, arg_16_1, 0)
			local var_16_10 = ActionUtils.scale_charged_projectile_power_level(var_16_3, arg_16_1, 1)
			local var_16_11, var_16_12, var_16_13, var_16_14, var_16_15 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, var_16_9, var_16_4)
			local var_16_16, var_16_17, var_16_18, var_16_19, var_16_20 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, var_16_10, var_16_4)

			arg_16_0[#arg_16_0 + 1] = {
				type = "charge",
				value_min = var_16_15,
				value_max = var_16_20
			}
		elseif arg_16_1.kind == "geiser" then
			local var_16_21 = ActionUtils.scale_geiser_power_level(var_16_3, 0)
			local var_16_22 = ActionUtils.scale_geiser_power_level(var_16_3, 1)
			local var_16_23, var_16_24, var_16_25, var_16_26, var_16_27 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, var_16_21, var_16_4)
			local var_16_28, var_16_29, var_16_30, var_16_31, var_16_32 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, var_16_22, var_16_4)

			arg_16_0[#arg_16_0 + 1] = {
				type = "charge",
				value_min = var_16_27,
				value_max = var_16_32
			}
		else
			local var_16_33, var_16_34, var_16_35, var_16_36, var_16_37 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, var_16_3, var_16_4)
			local var_16_38 = var_16_0 and (var_16_0.shot_count or var_16_0.num_projectiles) or arg_16_1.shot_count or arg_16_1.num_projectiles or 1

			arg_16_0[#arg_16_0 + 1] = {
				type = var_16_38 > 1 and "multi" or "single",
				shot_count = var_16_38,
				value = var_16_37
			}
		end
	elseif var_16_6 and var_16_7 then
		local var_16_39 = DamageProfileTemplates[var_16_6]
		local var_16_40 = DamageProfileTemplates[var_16_7]
		local var_16_41, var_16_42, var_16_43, var_16_44, var_16_45 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_39, var_16_3, var_16_4)
		local var_16_46, var_16_47, var_16_48, var_16_49, var_16_50 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_40, var_16_3, var_16_4)

		arg_16_0[#arg_16_0 + 1] = {
			type = "dual",
			value_left = var_16_45,
			value_right = var_16_50
		}
	end
end

ItemTooltipHelper.get_chain_critical_hit_chances = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = arg_17_1.impact_data
	local var_17_1 = var_17_0 and var_17_0.damage_profile or arg_17_1.damage_profile
	local var_17_2 = var_17_0 and var_17_0.damage_profile_left or arg_17_1.damage_profile_left
	local var_17_3 = var_17_0 and var_17_0.damage_profile_right or arg_17_1.damage_profile_right

	if var_17_1 or var_17_2 and var_17_3 then
		local var_17_4 = ActionUtils.get_critical_strike_chance(arg_17_2, arg_17_1)

		arg_17_0[#arg_17_0 + 1] = {
			type = "single",
			value = var_17_4
		}
	end
end

local var_0_1 = {
	beam = true,
	crossbow = true,
	charged_projectile = true,
	shotgun = true,
	handgun = true,
	bow = true,
	bullet_spray = true,
	flamethrower = true
}

ItemTooltipHelper.get_time_between_damage = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_1.impact_data
	local var_18_1 = var_18_0 and var_18_0.damage_profile or arg_18_1.damage_profile
	local var_18_2 = var_18_0 and var_18_0.damage_profile_left or arg_18_1.damage_profile_left
	local var_18_3 = var_18_0 and var_18_0.damage_profile_right or arg_18_1.damage_profile_right

	if var_18_1 or var_18_2 and var_18_3 then
		if var_0_1[arg_18_1.kind] then
			local var_18_4 = (arg_18_4.chain_start_time or 0) + (arg_18_1.damage_interval or arg_18_1.fire_time or 0)

			arg_18_0[#arg_18_0 + 1] = {
				type = "single",
				value = var_18_4
			}
		elseif arg_18_1.kind == "sweep" or arg_18_1.kind == "shield_slam" then
			local var_18_5 = arg_18_4.chain_start_time or 0
			local var_18_6 = arg_18_1.damage_window_start or 0

			if not arg_18_1.damage_window_end then
				local var_18_7 = 0
			end

			local var_18_8 = var_18_5 + var_18_6

			arg_18_0[#arg_18_0 + 1] = {
				type = "single",
				value = var_18_8
			}

			return true
		end
	end
end

ItemTooltipHelper.get_chain_boost_coefficients = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_1.impact_data
	local var_19_1 = var_19_0 and var_19_0.damage_profile or arg_19_1.damage_profile
	local var_19_2 = var_19_0 and var_19_0.damage_profile_left or arg_19_1.damage_profile_left
	local var_19_3 = var_19_0 and var_19_0.damage_profile_right or arg_19_1.damage_profile_right

	if var_19_1 then
		local var_19_4 = DamageProfileTemplates[var_19_1]
		local var_19_5 = 1
		local var_19_6 = (var_19_4.targets and var_19_4.targets[var_19_5] or var_19_4.default_target).boost_curve_coefficient or DefaultBoostCurveCoefficient
		local var_19_7 = var_19_0 and (var_19_0.shot_count or var_19_0.num_projectiles) or arg_19_1.shot_count or arg_19_1.num_projectiles or 1

		arg_19_0[#arg_19_0 + 1] = {
			type = var_19_7 > 1 and "multi" or "single",
			shot_count = var_19_7,
			value = var_19_6
		}
	elseif var_19_2 and var_19_3 then
		local var_19_8 = DamageProfileTemplates[var_19_2]
		local var_19_9 = DamageProfileTemplates[var_19_3]
		local var_19_10 = 1
		local var_19_11 = (var_19_8.targets and var_19_8.targets[var_19_10] or var_19_8.default_target).boost_curve_coefficient or DefaultBoostCurveCoefficient
		local var_19_12 = (var_19_9.targets and var_19_9.targets[var_19_10] or var_19_9.default_target).boost_curve_coefficient or DefaultBoostCurveCoefficient

		arg_19_0[#arg_19_0 + 1] = {
			type = "dual",
			value_left = var_19_11,
			value_right = var_19_12
		}
	end
end

ItemTooltipHelper.get_chain_headshot_boost_coefficients = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = arg_20_1.impact_data
	local var_20_1 = var_20_0 and var_20_0.damage_profile or arg_20_1.damage_profile
	local var_20_2 = var_20_0 and var_20_0.damage_profile_left or arg_20_1.damage_profile_left
	local var_20_3 = var_20_0 and var_20_0.damage_profile_right or arg_20_1.damage_profile_right

	if var_20_1 then
		local var_20_4 = DamageProfileTemplates[var_20_1]
		local var_20_5 = 1
		local var_20_6 = (var_20_4.targets and var_20_4.targets[var_20_5] or var_20_4.default_target).boost_curve_coefficient_headshot or DefaultBoostCurveCoefficient
		local var_20_7 = var_20_0 and (var_20_0.shot_count or var_20_0.num_projectiles) or arg_20_1.shot_count or arg_20_1.num_projectiles or 1

		arg_20_0[#arg_20_0 + 1] = {
			type = var_20_7 > 1 and "multi" or "single",
			shot_count = var_20_7,
			value = var_20_6
		}
	elseif var_20_2 and var_20_3 then
		local var_20_8 = DamageProfileTemplates[var_20_2]
		local var_20_9 = DamageProfileTemplates[var_20_3]
		local var_20_10 = 1
		local var_20_11 = (var_20_8.targets and var_20_8.targets[var_20_10] or var_20_8.default_target).boost_curve_coefficient_headshot or DefaultBoostCurveCoefficient
		local var_20_12 = (var_20_9.targets and var_20_9.targets[var_20_10] or var_20_9.default_target).boost_curve_coefficient_headshot or DefaultBoostCurveCoefficient

		arg_20_0[#arg_20_0 + 1] = {
			type = "dual",
			value_left = var_20_11,
			value_right = var_20_12
		}
	end
end

ItemTooltipHelper.get_push_angles = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_3.data
	local var_21_1 = BackendUtils.get_item_template(var_21_0)
	local var_21_2 = var_21_1.actions
	local var_21_3 = arg_21_4.charge_type
	local var_21_4
	local var_21_5
	local var_21_6 = var_21_1.tooltip_detail

	if var_21_6 then
		var_21_4 = var_21_6[var_21_3].action_name
		var_21_5 = var_21_6[var_21_3].sub_action_name
	else
		return arg_21_0
	end

	local var_21_7 = var_21_2[var_21_4][var_21_5]
	local var_21_8 = var_21_7.damage_profile_inner
	local var_21_9 = var_21_7.damage_profile_outer

	if var_21_8 and var_21_9 then
		local var_21_10 = var_21_7.push_angle
		local var_21_11 = var_21_7.outer_push_angle

		arg_21_0[#arg_21_0 + 1] = {
			type = "single",
			value = var_21_10
		}
		arg_21_0[#arg_21_0 + 1] = {
			type = "single",
			value = var_21_11
		}
	end
end

ItemTooltipHelper.get_push_strengths = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = ScriptUnit.has_extension(arg_22_2, "career_system")
	local var_22_1 = ScriptUnit.has_extension(arg_22_2, "buff_system")
	local var_22_2 = var_22_0:get_career_power_level()
	local var_22_3 = Managers.state.difficulty:get_difficulty()
	local var_22_4 = arg_22_3.data
	local var_22_5 = BackendUtils.get_item_template(var_22_4)
	local var_22_6 = var_22_5.actions
	local var_22_7 = arg_22_4.charge_type
	local var_22_8
	local var_22_9
	local var_22_10 = var_22_5.tooltip_detail

	if var_22_10 then
		var_22_8 = var_22_10[var_22_7].action_name
		var_22_9 = var_22_10[var_22_7].sub_action_name
	else
		return arg_22_0
	end

	local var_22_11 = var_22_6[var_22_8][var_22_9]
	local var_22_12 = var_22_11.damage_profile_inner
	local var_22_13 = var_22_11.damage_profile_outer

	if var_22_12 and var_22_13 then
		local var_22_14 = DamageProfileTemplates[var_22_12]
		local var_22_15 = DamageProfileTemplates[var_22_13]
		local var_22_16
		local var_22_17 = "torso"
		local var_22_18 = false
		local var_22_19 = 1
		local var_22_20 = false
		local var_22_21 = arg_22_3.name
		local var_22_22 = false
		local var_22_23 = 0
		local var_22_24, var_22_25, var_22_26, var_22_27, var_22_28 = ItemTooltipHelper.get_stagger_strength(arg_22_2, arg_22_3, var_22_14, var_22_2, var_22_3)
		local var_22_29, var_22_30, var_22_31, var_22_32, var_22_33 = ItemTooltipHelper.get_stagger_strength(arg_22_2, arg_22_3, var_22_15, var_22_2, var_22_3)

		arg_22_0[#arg_22_0 + 1] = {
			type = "single",
			value = var_22_28
		}
		arg_22_0[#arg_22_0 + 1] = {
			type = "single",
			value = var_22_33
		}
	end
end

local var_0_2 = {}

ItemTooltipHelper.parse_weapon_chain = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_2.data
	local var_23_1 = BackendUtils.get_item_template(var_23_0)
	local var_23_2 = var_23_1.actions
	local var_23_3 = arg_23_3.charge_type
	local var_23_4 = var_23_0.slot_type
	local var_23_5 = false
	local var_23_6
	local var_23_7
	local var_23_8
	local var_23_9 = var_23_4 == "ranged"
	local var_23_10 = var_23_1.tooltip_detail
	local var_23_11

	if var_23_10 then
		var_23_11 = var_23_10[var_23_3]
		var_23_5 = var_23_11.custom_chain

		if not var_23_5 then
			var_23_6 = var_23_11.action_name
			var_23_7 = var_23_11.sub_action_name

			local var_23_12 = var_23_2[var_23_6][var_23_7]
			local var_23_13, var_23_14, var_23_15 = ItemTooltipHelper.get_next_action_names(var_23_12, var_23_3)

			var_23_8 = var_23_15
		end
	else
		return arg_23_0
	end

	if var_23_5 then
		for iter_23_0, iter_23_1 in ipairs(var_23_11) do
			var_23_6 = iter_23_1.action_name
			var_23_7 = iter_23_1.sub_action_name

			local var_23_16 = var_23_2[var_23_6][var_23_7]

			arg_23_3.chain_start_time = iter_23_1.chain_start_time

			arg_23_4(arg_23_0, var_23_16, arg_23_1, arg_23_2, arg_23_3)
		end
	else
		local var_23_17 = var_0_2

		table.clear(var_23_17)

		if var_23_4 == "ranged" then
			var_23_17[#var_23_17 + 1] = {
				var_23_10.light.action_name,
				var_23_10.light.sub_action_name
			}
			var_23_17[#var_23_17 + 1] = {
				var_23_10.heavy.action_name,
				var_23_10.heavy.sub_action_name
			}
		end

		local var_23_18 = false

		while not var_23_18 do
			var_23_17[#var_23_17 + 1] = {
				var_23_6,
				var_23_7
			}

			local var_23_19 = var_23_2[var_23_6][var_23_7]
			local var_23_20, var_23_21, var_23_22 = ItemTooltipHelper.get_next_action_names(var_23_19, var_23_3)

			arg_23_3.chain_start_time = not var_23_9 and var_23_8
			var_23_9 = arg_23_4(arg_23_0, var_23_19, arg_23_1, arg_23_2, arg_23_3)

			if var_23_20 == nil and var_23_21 == nil then
				var_23_18 = true
			end

			if not var_23_18 then
				for iter_23_2, iter_23_3 in pairs(var_23_17) do
					if iter_23_3[1] == var_23_20 and iter_23_3[2] == var_23_21 then
						var_23_18 = true
					end
				end
			end

			if not var_23_18 then
				var_23_6 = var_23_20
				var_23_7 = var_23_21

				if var_23_9 then
					var_23_8 = var_23_22
				end
			end
		end
	end
end
