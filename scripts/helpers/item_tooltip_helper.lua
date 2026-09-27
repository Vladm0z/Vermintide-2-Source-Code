-- chunkname: @scripts/helpers/item_tooltip_helper.lua

local ItemTooltipHelper = ItemTooltipHelper

ItemTooltipHelper = ItemTooltipHelper or {}
ItemTooltipHelper = ItemTooltipHelper

local tbl = {
	damage = function (arg_1_0)
		-- function 1
		return string.format("%.2f", arg_1_0)
	end,
	max_targets = function (arg_2_0)
		-- function 2
		if arg_2_0 == -1 then
			return "inf."
		end

		return string.format("%.2f", math.round_with_precision(arg_2_0, 2))
	end,
	stagger_strength = function (arg_3_0)
		-- function 3
		return string.format("%.2f", math.round_with_precision(arg_3_0, 2))
	end,
	crit = function (arg_4_0)
		-- function 4
		return string.format("%.1f", math.round_with_precision(arg_4_0, 1) * 100) .. "%"
	end,
	time_between_damage = function (arg_5_0)
		-- function 5
		return string.format("%.2f", math.round_with_precision(arg_5_0, 2))
	end,
	boost = function (arg_6_0)
		-- function 6
		return string.format("%.2f", math.round_with_precision(arg_6_0, 2))
	end,
	push_angle = function (arg_7_0)
		-- function 7
		return tostring(arg_7_0)
	end,
	push_strength = function (arg_8_0)
		-- function 8
		return string.format("%.2f", math.round_with_precision(arg_8_0, 2))
	end
}

ItemTooltipHelper.format_return_string = function (arg_9_0, arg_9_1)
	-- function 9
	local var_9_0 = tbl[arg_9_0]
	local str = ""

	if type(arg_9_1) == "table" then
		for i = 1, #arg_9_1 do
			local var_9_2 = arg_9_1[i]

			if var_9_2.type == "charge" then
				str = str .. var_9_0(var_9_2.value_min) .. "-" .. var_9_0(var_9_2.value_max)
			elseif var_9_2.type == "multi" then
				str = str .. var_9_0(var_9_2.value) .. " x" .. tostring(var_9_2.shot_count)
			elseif var_9_2.type == "dual" then
				str = str .. var_9_0(var_9_2.value_left) .. "+" .. var_9_0(var_9_2.value_right)
			else
				str = str .. var_9_0(var_9_2.value)
			end

			if i < #arg_9_1 then
				str = str .. " / "
			end
		end
	else
		str = var_9_0(arg_9_1)
	end

	return str
end

ItemTooltipHelper.get_damage = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	local name = arg_10_1.name
	local str = "torso"
	local num = 1
	local var_10_3

	if not arg_10_4.targets then
		var_10_3 = arg_10_4.targets[num]

		if not var_10_3 then
			-- Nothing
		end
	end

	var_10_3 = arg_10_4.default_target

	::label_10_0::

	local var_10_4 = BoostCurves[var_10_3.boost_curve_type]
	local var_10_5
	local flag = false
	local num_2 = 1
	local skaven_clan_rat = Breeds.skaven_clan_rat
	local num_3 = 0
	local flag_2 = false

	return (DamageUtils.calculate_damage_tooltip(arg_10_0, name, arg_10_5, str, arg_10_4, num, var_10_4, var_10_5, flag, num_2, skaven_clan_rat, num_3, flag_2, arg_10_6, arg_10_2, arg_10_3))
end

ItemTooltipHelper.get_stagger_strength = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0
	local str = "torso"
	local flag = false
	local num = 1
	local flag_2 = false
	local name = arg_11_1.name
	local flag_3 = false
	local num_2 = 0
	local calculate_stagger_player_tooltip, var_11_9, var_11_10, var_11_11, var_11_12 = DamageUtils.calculate_stagger_player_tooltip(var_11_0, arg_11_0, str, arg_11_3, flag, arg_11_2, num, flag_2, name, arg_11_4, flag_3, num_2)

	return calculate_stagger_player_tooltip, var_11_9, var_11_10, var_11_11, var_11_12
end

ItemTooltipHelper.get_next_action_names = function (self, arg_12_1)
	-- function 12
	local allowed_chain_actions = self.allowed_chain_actions
	local flag = true

	for k, v in pairs(allowed_chain_actions) do
		if not v.auto_chain then
			flag = false

			break
		end
	end

	local var_12_2
	local var_12_3
	local var_12_4
	local num = 1

	for i, v_2 in ipairs(allowed_chain_actions) do
		if not ((arg_12_1 ~= "light" or i ~= num or arg_12_1 ~= "heavy") and (not v_2.auto_chain or not flag or arg_12_1 ~= "heavy" or i ~= num)) then
			if v_2.input ~= "action_wield" then
				var_12_2 = v_2.action
				var_12_3 = v_2.sub_action
				var_12_4 = v_2.start_time

				break
			else
				num = num + 1
			end
		end
	end

	return var_12_2, var_12_3, var_12_4
end

ItemTooltipHelper.get_action = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local has_extension = ScriptUnit.has_extension(arg_13_0, "career_system")
	local has_extension_2 = ScriptUnit.has_extension(arg_13_0, "buff_system")
	local data = arg_13_1.data
	local get_item_template = BackendUtils.get_item_template(data)
	local actions = get_item_template.actions
	local charge_type = arg_13_2.charge_type

	charge_type = charge_type or "light"

	local var_13_6 = get_item_template.tooltip_compare[charge_type]

	return actions[var_13_6.action_name][var_13_6.sub_action_name]
end

ItemTooltipHelper.get_chain_damages = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local impact_data = arg_14_1.impact_data
	local has_extension = ScriptUnit.has_extension(arg_14_2, "career_system")
	local has_extension_2 = ScriptUnit.has_extension(arg_14_2, "buff_system")
	local get_career_power_level = has_extension:get_career_power_level()
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local armor_types = arg_14_4.armor_types

	armor_types = armor_types or {}

	local var_14_6 = armor_types[1]

	var_14_6 = var_14_6 or 1

	local var_14_7 = armor_types[2]
	local damage_profile

	if not impact_data then
		damage_profile = impact_data.damage_profile

		if not damage_profile then
			-- Nothing
		end
	end

	damage_profile = arg_14_1.damage_profile

	do
		local damage_profile_left
	end

	::label_14_0::

	if not impact_data then
		damage_profile_left = impact_data.damage_profile_left

		if not damage_profile_left then
			-- Nothing
		end
	end

	damage_profile_left = arg_14_1.damage_profile_left

	do
		local damage_profile_right
	end

	::label_14_1::

	if not impact_data then
		damage_profile_right = impact_data.damage_profile_right

		if not damage_profile_right then
			-- Nothing
		end
	end

	damage_profile_right = arg_14_1.damage_profile_right

	::label_14_2::

	if not damage_profile then
		local var_14_11 = DamageProfileTemplates[damage_profile]

		if arg_14_1.kind ~= "charged_projectile" or not arg_14_1.scale_power_level then
			local scale_charged_projectile_power_level = ActionUtils.scale_charged_projectile_power_level(get_career_power_level, arg_14_1, 0)
			local scale_charged_projectile_power_level_2 = ActionUtils.scale_charged_projectile_power_level(get_career_power_level, arg_14_1, 1)
			local get_damage = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, scale_charged_projectile_power_level, get_difficulty)
			local get_damage_2 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, scale_charged_projectile_power_level_2, get_difficulty)

			self[#self + 1] = {
				type = "charge",
				value_min = get_damage,
				value_max = get_damage_2
			}
		elseif arg_14_1.kind == "geiser" then
			local scale_geiser_power_level = ActionUtils.scale_geiser_power_level(get_career_power_level, 0)
			local scale_geiser_power_level_2 = ActionUtils.scale_geiser_power_level(get_career_power_level, 1)
			local get_damage_3 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, scale_geiser_power_level, get_difficulty)
			local get_damage_4 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, scale_geiser_power_level_2, get_difficulty)

			self[#self + 1] = {
				type = "charge",
				value_min = get_damage_3,
				value_max = get_damage_4
			}
		else
			local get_damage_5 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_11, get_career_power_level, get_difficulty)
			local shot_count

			if not impact_data then
				shot_count = impact_data.shot_count

				if not shot_count then
					-- Nothing
				end

				shot_count = impact_data.num_projectiles

				if not shot_count then
					-- Nothing
				end
			end

			shot_count = arg_14_1.shot_count

			if not shot_count then
				shot_count = arg_14_1.num_projectiles
				shot_count = shot_count or 1
			end

			::label_14_3::

			local num = #self + 1
			local tbl = {}
			local flag

			flag = not (shot_count > 1) or not "multi" or "single"
			tbl.type = flag
			tbl.shot_count = shot_count
			tbl.value = get_damage_5
			self[num] = tbl
		end
	elseif not damage_profile_left and not damage_profile_right then
		local var_14_25 = DamageProfileTemplates[damage_profile_left]
		local var_14_26 = DamageProfileTemplates[damage_profile_right]
		local get_damage_6 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_25, get_career_power_level, get_difficulty)
		local get_damage_7 = ItemTooltipHelper.get_damage(arg_14_2, arg_14_3, var_14_6, var_14_7, var_14_26, get_career_power_level, get_difficulty)

		self[#self + 1] = {
			type = "dual",
			value_left = get_damage_6,
			value_right = get_damage_7
		}
	end
end

ItemTooltipHelper.get_chain_max_targets = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local impact_data = arg_15_1.impact_data
	local has_extension = ScriptUnit.has_extension(arg_15_2, "career_system")
	local has_extension_2 = ScriptUnit.has_extension(arg_15_2, "buff_system")
	local get_career_power_level = has_extension:get_career_power_level()
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local damage_profile

	if not impact_data then
		damage_profile = impact_data.damage_profile

		if not damage_profile then
			-- Nothing
		end
	end

	damage_profile = arg_15_1.damage_profile

	do
		local damage_profile_left
	end

	::label_15_0::

	if not impact_data then
		damage_profile_left = impact_data.damage_profile_left

		if not damage_profile_left then
			-- Nothing
		end
	end

	damage_profile_left = arg_15_1.damage_profile_left

	do
		local damage_profile_right
	end

	::label_15_1::

	if not impact_data then
		damage_profile_right = impact_data.damage_profile_right

		if not damage_profile_right then
			-- Nothing
		end
	end

	damage_profile_right = arg_15_1.damage_profile_right

	::label_15_2::

	if not damage_profile then
		local var_15_8 = DamageProfileTemplates[damage_profile]

		if arg_15_1.kind ~= "charged_projectile" or not arg_15_1.scale_power_level then
			local scale_charged_projectile_power_level = ActionUtils.scale_charged_projectile_power_level(get_career_power_level, arg_15_1, 0)
			local scale_charged_projectile_power_level_2 = ActionUtils.scale_charged_projectile_power_level(get_career_power_level, arg_15_1, 1)
			local scale_power_levels = ActionUtils.scale_power_levels(scale_charged_projectile_power_level, "cleave", arg_15_2, get_difficulty)
			local scale_power_levels_2 = ActionUtils.scale_power_levels(scale_charged_projectile_power_level_2, "cleave", arg_15_2, get_difficulty)
			local get_max_targets, var_15_14 = ActionUtils.get_max_targets(var_15_8, scale_power_levels)
			local get_max_targets_2, var_15_16 = ActionUtils.get_max_targets(var_15_8, scale_power_levels_2)
			local flag = not (var_15_14 < get_max_targets) or not get_max_targets or var_15_14
			local flag_2 = not (var_15_16 < get_max_targets_2) or not get_max_targets_2 or var_15_16

			self[#self + 1] = {
				type = "charge",
				value_min = flag,
				value_max = flag_2
			}
		elseif not (arg_15_1.kind == "geiser" or arg_15_1.kind == "shield_slam" or arg_15_1.kind ~= "push_stagger") then
			self[#self + 1] = {
				value = -1,
				type = "single"
			}
		else
			local scale_power_levels_3 = ActionUtils.scale_power_levels(get_career_power_level, "cleave", arg_15_2, get_difficulty)
			local get_max_targets_3, var_15_21 = ActionUtils.get_max_targets(var_15_8, scale_power_levels_3)
			local flag_3 = not (var_15_21 < get_max_targets_3) or not get_max_targets_3 or var_15_21
			local shot_count

			if not impact_data then
				shot_count = impact_data.shot_count

				if not shot_count then
					-- Nothing
				end

				shot_count = impact_data.num_projectiles

				if not shot_count then
					-- Nothing
				end
			end

			shot_count = arg_15_1.shot_count

			if not shot_count then
				shot_count = arg_15_1.num_projectiles
				shot_count = shot_count or 1
			end

			::label_15_3::

			local num = #self + 1
			local tbl = {}
			local flag_4

			flag_4 = not (shot_count > 1) or not "multi" or "single"
			tbl.type = flag_4
			tbl.shot_count = shot_count
			tbl.value = flag_3
			self[num] = tbl
		end
	elseif not damage_profile_left and not damage_profile_right then
		local var_15_27 = DamageProfileTemplates[damage_profile_left]
		local var_15_28 = DamageProfileTemplates[damage_profile_right]
		local scale_power_levels_4 = ActionUtils.scale_power_levels(get_career_power_level, "cleave", arg_15_2, get_difficulty)
		local get_max_targets_4, var_15_31 = ActionUtils.get_max_targets(var_15_27, scale_power_levels_4)
		local get_max_targets_5, var_15_33 = ActionUtils.get_max_targets(var_15_28, scale_power_levels_4)
		local flag_5 = not (var_15_31 < get_max_targets_4) or not get_max_targets_4 or var_15_31
		local flag_6 = not (var_15_33 < get_max_targets_5) or not get_max_targets_5 or var_15_33

		self[#self + 1] = {
			type = "dual",
			value_left = flag_5,
			value_right = flag_6
		}
	end
end

ItemTooltipHelper.get_chain_stagger_strengths = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local impact_data = arg_16_1.impact_data
	local has_extension = ScriptUnit.has_extension(arg_16_2, "career_system")
	local has_extension_2 = ScriptUnit.has_extension(arg_16_2, "buff_system")
	local get_career_power_level = has_extension:get_career_power_level()
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local damage_profile

	if not impact_data then
		damage_profile = impact_data.damage_profile

		if not damage_profile then
			-- Nothing
		end
	end

	damage_profile = arg_16_1.damage_profile

	do
		local damage_profile_left
	end

	::label_16_0::

	if not impact_data then
		damage_profile_left = impact_data.damage_profile_left

		if not damage_profile_left then
			-- Nothing
		end
	end

	damage_profile_left = arg_16_1.damage_profile_left

	do
		local damage_profile_right
	end

	::label_16_1::

	if not impact_data then
		damage_profile_right = impact_data.damage_profile_right

		if not damage_profile_right then
			-- Nothing
		end
	end

	damage_profile_right = arg_16_1.damage_profile_right

	::label_16_2::

	if not damage_profile then
		local var_16_8 = DamageProfileTemplates[damage_profile]

		if arg_16_1.kind ~= "charged_projectile" or not arg_16_1.scale_power_level then
			local scale_charged_projectile_power_level = ActionUtils.scale_charged_projectile_power_level(get_career_power_level, arg_16_1, 0)
			local scale_charged_projectile_power_level_2 = ActionUtils.scale_charged_projectile_power_level(get_career_power_level, arg_16_1, 1)
			local get_stagger_strength, var_16_12, var_16_13, var_16_14, var_16_15 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, scale_charged_projectile_power_level, get_difficulty)
			local get_stagger_strength_2, var_16_17, var_16_18, var_16_19, var_16_20 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, scale_charged_projectile_power_level_2, get_difficulty)

			self[#self + 1] = {
				type = "charge",
				value_min = var_16_15,
				value_max = var_16_20
			}
		elseif arg_16_1.kind == "geiser" then
			local scale_geiser_power_level = ActionUtils.scale_geiser_power_level(get_career_power_level, 0)
			local scale_geiser_power_level_2 = ActionUtils.scale_geiser_power_level(get_career_power_level, 1)
			local get_stagger_strength_3, var_16_24, var_16_25, var_16_26, var_16_27 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, scale_geiser_power_level, get_difficulty)
			local get_stagger_strength_4, var_16_29, var_16_30, var_16_31, var_16_32 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, scale_geiser_power_level_2, get_difficulty)

			self[#self + 1] = {
				type = "charge",
				value_min = var_16_27,
				value_max = var_16_32
			}
		else
			local get_stagger_strength_5, var_16_34, var_16_35, var_16_36, var_16_37 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_8, get_career_power_level, get_difficulty)
			local shot_count

			if not impact_data then
				shot_count = impact_data.shot_count

				if not shot_count then
					-- Nothing
				end

				shot_count = impact_data.num_projectiles

				if not shot_count then
					-- Nothing
				end
			end

			shot_count = arg_16_1.shot_count

			if not shot_count then
				shot_count = arg_16_1.num_projectiles
				shot_count = shot_count or 1
			end

			::label_16_3::

			local num = #self + 1
			local tbl = {}
			local flag

			flag = not (shot_count > 1) or not "multi" or "single"
			tbl.type = flag
			tbl.shot_count = shot_count
			tbl.value = var_16_37
			self[num] = tbl
		end
	elseif not damage_profile_left and not damage_profile_right then
		local var_16_42 = DamageProfileTemplates[damage_profile_left]
		local var_16_43 = DamageProfileTemplates[damage_profile_right]
		local get_stagger_strength_6, var_16_45, var_16_46, var_16_47, var_16_48 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_42, get_career_power_level, get_difficulty)
		local get_stagger_strength_7, var_16_50, var_16_51, var_16_52, var_16_53 = ItemTooltipHelper.get_stagger_strength(arg_16_2, arg_16_3, var_16_43, get_career_power_level, get_difficulty)

		self[#self + 1] = {
			type = "dual",
			value_left = var_16_48,
			value_right = var_16_53
		}
	end
end

ItemTooltipHelper.get_chain_critical_hit_chances = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local impact_data = arg_17_1.impact_data
	local damage_profile

	if not impact_data then
		damage_profile = impact_data.damage_profile

		if not damage_profile then
			-- Nothing
		end
	end

	damage_profile = arg_17_1.damage_profile

	do
		local damage_profile_left
	end

	::label_17_0::

	if not impact_data then
		damage_profile_left = impact_data.damage_profile_left

		if not damage_profile_left then
			-- Nothing
		end
	end

	damage_profile_left = arg_17_1.damage_profile_left

	do
		local damage_profile_right
	end

	::label_17_1::

	if not impact_data then
		damage_profile_right = impact_data.damage_profile_right

		if not damage_profile_right then
			-- Nothing
		end
	end

	damage_profile_right = arg_17_1.damage_profile_right

	::label_17_2::

	if damage_profile or not damage_profile_left or not damage_profile_right then
		local get_critical_strike_chance = ActionUtils.get_critical_strike_chance(arg_17_2, arg_17_1)

		self[#self + 1] = {
			type = "single",
			value = get_critical_strike_chance
		}
	end
end

local tbl_2 = {
	beam = true,
	crossbow = true,
	charged_projectile = true,
	shotgun = true,
	handgun = true,
	bow = true,
	bullet_spray = true,
	flamethrower = true
}

ItemTooltipHelper.get_time_between_damage = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local impact_data = arg_18_1.impact_data
	local damage_profile

	if not impact_data then
		damage_profile = impact_data.damage_profile

		if not damage_profile then
			-- Nothing
		end
	end

	damage_profile = arg_18_1.damage_profile

	do
		local damage_profile_left
	end

	::label_18_0::

	if not impact_data then
		damage_profile_left = impact_data.damage_profile_left

		if not damage_profile_left then
			-- Nothing
		end
	end

	damage_profile_left = arg_18_1.damage_profile_left

	do
		local damage_profile_right
	end

	::label_18_1::

	if not impact_data then
		damage_profile_right = impact_data.damage_profile_right

		if not damage_profile_right then
			-- Nothing
		end
	end

	damage_profile_right = arg_18_1.damage_profile_right

	::label_18_2::

	if damage_profile or not damage_profile_left or not damage_profile_right then
		if not tbl_2[arg_18_1.kind] then
			local chain_start_time = arg_18_4.chain_start_time

			chain_start_time = chain_start_time or 0

			local damage_interval = arg_18_1.damage_interval

			if not damage_interval then
				damage_interval = arg_18_1.fire_time
				damage_interval = damage_interval or 0
			end

			local num = chain_start_time + damage_interval

			self[#self + 1] = {
				type = "single",
				value = num
			}
		elseif not (arg_18_1.kind == "sweep" or arg_18_1.kind ~= "shield_slam") then
			local chain_start_time_2 = arg_18_4.chain_start_time

			chain_start_time_2 = chain_start_time_2 or 0

			local damage_window_start = arg_18_1.damage_window_start

			damage_window_start = damage_window_start or 0

			if not arg_18_1.damage_window_end then
				local num_2 = 0
			end

			local num_3 = chain_start_time_2 + damage_window_start

			self[#self + 1] = {
				type = "single",
				value = num_3
			}

			return true
		end
	end
end

ItemTooltipHelper.get_chain_boost_coefficients = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local impact_data = arg_19_1.impact_data
	local damage_profile

	if not impact_data then
		damage_profile = impact_data.damage_profile

		if not damage_profile then
			-- Nothing
		end
	end

	damage_profile = arg_19_1.damage_profile

	do
		local damage_profile_left
	end

	::label_19_0::

	if not impact_data then
		damage_profile_left = impact_data.damage_profile_left

		if not damage_profile_left then
			-- Nothing
		end
	end

	damage_profile_left = arg_19_1.damage_profile_left

	do
		local damage_profile_right
	end

	::label_19_1::

	if not impact_data then
		damage_profile_right = impact_data.damage_profile_right

		if not damage_profile_right then
			-- Nothing
		end
	end

	damage_profile_right = arg_19_1.damage_profile_right

	::label_19_2::

	if not damage_profile then
		local var_19_4 = DamageProfileTemplates[damage_profile]
		local num = 1
		local var_19_6

		if not var_19_4.targets then
			var_19_6 = var_19_4.targets[num]

			if not var_19_6 then
				-- Nothing
			end
		end

		var_19_6 = var_19_4.default_target

		::label_19_3::

		local boost_curve_coefficient = var_19_6.boost_curve_coefficient

		boost_curve_coefficient = boost_curve_coefficient or DefaultBoostCurveCoefficient

		local shot_count

		if not impact_data then
			shot_count = impact_data.shot_count

			if not shot_count then
				-- Nothing
			end

			shot_count = impact_data.num_projectiles

			if not shot_count then
				-- Nothing
			end
		end

		shot_count = arg_19_1.shot_count

		if not shot_count then
			shot_count = arg_19_1.num_projectiles
			shot_count = shot_count or 1
		end

		::label_19_4::

		local num_2 = #self + 1
		local tbl = {}
		local flag

		flag = not (shot_count > 1) or not "multi" or "single"
		tbl.type = flag
		tbl.shot_count = shot_count
		tbl.value = boost_curve_coefficient
		self[num_2] = tbl
	elseif not damage_profile_left and not damage_profile_right then
		local var_19_12 = DamageProfileTemplates[damage_profile_left]
		local var_19_13 = DamageProfileTemplates[damage_profile_right]
		local num_3 = 1
		local var_19_15

		if not var_19_12.targets then
			var_19_15 = var_19_12.targets[num_3]

			if not var_19_15 then
				-- Nothing
			end
		end

		var_19_15 = var_19_12.default_target

		::label_19_5::

		local boost_curve_coefficient_2 = var_19_15.boost_curve_coefficient

		boost_curve_coefficient_2 = boost_curve_coefficient_2 or DefaultBoostCurveCoefficient

		local var_19_17

		if not var_19_13.targets then
			var_19_17 = var_19_13.targets[num_3]

			if not var_19_17 then
				-- Nothing
			end
		end

		var_19_17 = var_19_13.default_target

		::label_19_6::

		local boost_curve_coefficient_3 = var_19_17.boost_curve_coefficient

		boost_curve_coefficient_3 = boost_curve_coefficient_3 or DefaultBoostCurveCoefficient
		self[#self + 1] = {
			type = "dual",
			value_left = boost_curve_coefficient_2,
			value_right = boost_curve_coefficient_3
		}
	end
end

ItemTooltipHelper.get_chain_headshot_boost_coefficients = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local impact_data = arg_20_1.impact_data
	local damage_profile

	if not impact_data then
		damage_profile = impact_data.damage_profile

		if not damage_profile then
			-- Nothing
		end
	end

	damage_profile = arg_20_1.damage_profile

	do
		local damage_profile_left
	end

	::label_20_0::

	if not impact_data then
		damage_profile_left = impact_data.damage_profile_left

		if not damage_profile_left then
			-- Nothing
		end
	end

	damage_profile_left = arg_20_1.damage_profile_left

	do
		local damage_profile_right
	end

	::label_20_1::

	if not impact_data then
		damage_profile_right = impact_data.damage_profile_right

		if not damage_profile_right then
			-- Nothing
		end
	end

	damage_profile_right = arg_20_1.damage_profile_right

	::label_20_2::

	if not damage_profile then
		local var_20_4 = DamageProfileTemplates[damage_profile]
		local num = 1
		local var_20_6

		if not var_20_4.targets then
			var_20_6 = var_20_4.targets[num]

			if not var_20_6 then
				-- Nothing
			end
		end

		var_20_6 = var_20_4.default_target

		::label_20_3::

		local boost_curve_coefficient_headshot = var_20_6.boost_curve_coefficient_headshot

		boost_curve_coefficient_headshot = boost_curve_coefficient_headshot or DefaultBoostCurveCoefficient

		local shot_count

		if not impact_data then
			shot_count = impact_data.shot_count

			if not shot_count then
				-- Nothing
			end

			shot_count = impact_data.num_projectiles

			if not shot_count then
				-- Nothing
			end
		end

		shot_count = arg_20_1.shot_count

		if not shot_count then
			shot_count = arg_20_1.num_projectiles
			shot_count = shot_count or 1
		end

		::label_20_4::

		local num_2 = #self + 1
		local tbl = {}
		local flag

		flag = not (shot_count > 1) or not "multi" or "single"
		tbl.type = flag
		tbl.shot_count = shot_count
		tbl.value = boost_curve_coefficient_headshot
		self[num_2] = tbl
	elseif not damage_profile_left and not damage_profile_right then
		local var_20_12 = DamageProfileTemplates[damage_profile_left]
		local var_20_13 = DamageProfileTemplates[damage_profile_right]
		local num_3 = 1
		local var_20_15

		if not var_20_12.targets then
			var_20_15 = var_20_12.targets[num_3]

			if not var_20_15 then
				-- Nothing
			end
		end

		var_20_15 = var_20_12.default_target

		::label_20_5::

		local boost_curve_coefficient_headshot_2 = var_20_15.boost_curve_coefficient_headshot

		boost_curve_coefficient_headshot_2 = boost_curve_coefficient_headshot_2 or DefaultBoostCurveCoefficient

		local var_20_17

		if not var_20_13.targets then
			var_20_17 = var_20_13.targets[num_3]

			if not var_20_17 then
				-- Nothing
			end
		end

		var_20_17 = var_20_13.default_target

		::label_20_6::

		local boost_curve_coefficient_headshot_3 = var_20_17.boost_curve_coefficient_headshot

		boost_curve_coefficient_headshot_3 = boost_curve_coefficient_headshot_3 or DefaultBoostCurveCoefficient
		self[#self + 1] = {
			type = "dual",
			value_left = boost_curve_coefficient_headshot_2,
			value_right = boost_curve_coefficient_headshot_3
		}
	end
end

ItemTooltipHelper.get_push_angles = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local data = arg_21_3.data
	local get_item_template = BackendUtils.get_item_template(data)
	local actions = get_item_template.actions
	local charge_type = arg_21_4.charge_type
	local var_21_4
	local var_21_5
	local tooltip_detail = get_item_template.tooltip_detail

	if not tooltip_detail then
		var_21_4 = tooltip_detail[charge_type].action_name
		var_21_5 = tooltip_detail[charge_type].sub_action_name
	else
		return self
	end

	local var_21_7 = actions[var_21_4][var_21_5]
	local damage_profile_inner = var_21_7.damage_profile_inner
	local damage_profile_outer = var_21_7.damage_profile_outer

	if not damage_profile_inner and not damage_profile_outer then
		local push_angle = var_21_7.push_angle
		local outer_push_angle = var_21_7.outer_push_angle

		self[#self + 1] = {
			type = "single",
			value = push_angle
		}
		self[#self + 1] = {
			type = "single",
			value = outer_push_angle
		}
	end
end

ItemTooltipHelper.get_push_strengths = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local has_extension = ScriptUnit.has_extension(arg_22_2, "career_system")
	local has_extension_2 = ScriptUnit.has_extension(arg_22_2, "buff_system")
	local get_career_power_level = has_extension:get_career_power_level()
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local data = arg_22_3.data
	local get_item_template = BackendUtils.get_item_template(data)
	local actions = get_item_template.actions
	local charge_type = arg_22_4.charge_type
	local var_22_8
	local var_22_9
	local tooltip_detail = get_item_template.tooltip_detail

	if not tooltip_detail then
		var_22_8 = tooltip_detail[charge_type].action_name
		var_22_9 = tooltip_detail[charge_type].sub_action_name
	else
		return self
	end

	local var_22_11 = actions[var_22_8][var_22_9]
	local damage_profile_inner = var_22_11.damage_profile_inner
	local damage_profile_outer = var_22_11.damage_profile_outer

	if not damage_profile_inner and not damage_profile_outer then
		local var_22_14 = DamageProfileTemplates[damage_profile_inner]
		local var_22_15 = DamageProfileTemplates[damage_profile_outer]
		local var_22_16
		local str = "torso"
		local flag = false
		local num = 1
		local flag_2 = false
		local name = arg_22_3.name
		local flag_3 = false
		local num_2 = 0
		local get_stagger_strength, var_22_25, var_22_26, var_22_27, var_22_28 = ItemTooltipHelper.get_stagger_strength(arg_22_2, arg_22_3, var_22_14, get_career_power_level, get_difficulty)
		local get_stagger_strength_2, var_22_30, var_22_31, var_22_32, var_22_33 = ItemTooltipHelper.get_stagger_strength(arg_22_2, arg_22_3, var_22_15, get_career_power_level, get_difficulty)

		self[#self + 1] = {
			type = "single",
			value = var_22_28
		}
		self[#self + 1] = {
			type = "single",
			value = var_22_33
		}
	end
end

local tbl_3 = {}

ItemTooltipHelper.parse_weapon_chain = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local data = arg_23_2.data
	local get_item_template = BackendUtils.get_item_template(data)
	local actions = get_item_template.actions
	local charge_type = arg_23_3.charge_type
	local slot_type = data.slot_type
	local flag = false
	local var_23_6
	local var_23_7
	local var_23_8
	local flag_2 = slot_type == "ranged"
	local tooltip_detail = get_item_template.tooltip_detail
	local var_23_11

	if not tooltip_detail then
		var_23_11 = tooltip_detail[charge_type]
		flag = var_23_11.custom_chain

		if not flag then
			var_23_6 = var_23_11.action_name
			var_23_7 = var_23_11.sub_action_name

			local var_23_12 = actions[var_23_6][var_23_7]
			local get_next_action_names, var_23_14, var_23_15 = ItemTooltipHelper.get_next_action_names(var_23_12, charge_type)

			var_23_8 = var_23_15
		end
	else
		return arg_23_0
	end

	if not flag then
		for i, v in ipairs(var_23_11) do
			var_23_6 = v.action_name
			var_23_7 = v.sub_action_name

			local var_23_16 = actions[var_23_6][var_23_7]

			arg_23_3.chain_start_time = v.chain_start_time

			arg_23_4(arg_23_0, var_23_16, arg_23_1, arg_23_2, arg_23_3)
		end
	else
		local var_23_17 = tbl_3

		table.clear(var_23_17)

		if slot_type == "ranged" then
			var_23_17[#var_23_17 + 1] = {
				tooltip_detail.light.action_name,
				tooltip_detail.light.sub_action_name
			}
			var_23_17[#var_23_17 + 1] = {
				tooltip_detail.heavy.action_name,
				tooltip_detail.heavy.sub_action_name
			}
		end

		local flag_3 = false

		while not flag_3 do
			var_23_17[#var_23_17 + 1] = {
				var_23_6,
				var_23_7
			}

			local var_23_19 = actions[var_23_6][var_23_7]
			local get_next_action_names_2, var_23_21, var_23_22 = ItemTooltipHelper.get_next_action_names(var_23_19, charge_type)

			arg_23_3.chain_start_time = not not flag_2 or var_23_8
			flag_2 = arg_23_4(arg_23_0, var_23_19, arg_23_1, arg_23_2, arg_23_3)

			if not (get_next_action_names_2 ~= nil or var_23_21 ~= nil) then
				flag_3 = true
			end

			if not flag_3 then
				for k, v_2 in pairs(var_23_17) do
					if not (v_2[1] ~= get_next_action_names_2 or v_2[2] ~= var_23_21) then
						flag_3 = true
					end
				end
			end

			if not flag_3 then
				var_23_6 = get_next_action_names_2
				var_23_7 = var_23_21

				if not flag_2 then
					var_23_8 = var_23_22
				end
			end
		end
	end
end
