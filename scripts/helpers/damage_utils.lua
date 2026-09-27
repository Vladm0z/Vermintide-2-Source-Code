-- chunkname: @scripts/helpers/damage_utils.lua

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local DamageUtils = DamageUtils

DamageUtils = DamageUtils or {}
DamageUtils = DamageUtils

local BLACKBOARDS = BLACKBOARDS
local num = 4
local POSITION_LOOKUP = POSITION_LOOKUP
local get_data = Unit.get_data
local alive = Unit.alive
local local_position = Unit.local_position
local local_rotation = Unit.local_rotation
local world_position = Unit.world_position
local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event
local actor = Unit.actor
local has_animation_state_machine = Unit.has_animation_state_machine
local animation_event = Unit.animation_event
local has_animation_event = Unit.has_animation_event
local distance_squared = Vector3.distance_squared
local position = Actor.position
local unit = Actor.unit
local node = Actor.node
local tbl = {
	aoe_poison_dot = true,
	poison = true,
	arrow_poison = true,
	arrow_poison_dot = true
}
local tbl_2 = {
	skaven_poison_wind_globadier = true,
	poison_dot = true
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local has_extension = ScriptUnit.has_extension(arg_1_0, "buff_system")

	if not has_extension then
		if has_extension:has_buff_perk("invulnerable") or not RangedAttackTypes[arg_1_3] or not has_extension:has_buff_perk("invulnerable_ranged") then
			return true
		end

		local var_1_1 = tbl[arg_1_1]

		var_1_1 = var_1_1 or tbl_2[arg_1_2]

		local has_buff_perk = has_extension:has_buff_perk("poison_proof")

		return not var_1_1 and has_buff_perk
	end

	return false
end

DamageUtils.get_breed_damage_multiplier_type = function (self, arg_2_1)
	-- function 2
	local var_2_0

	if not self and not self.hitzone_multiplier_types then
		var_2_0 = self.hitzone_multiplier_types[arg_2_1]
	end

	return var_2_0
end

local function fn_2(self, arg_3_1)
	-- function 3
	if arg_3_1 < 1 then
		return self[1]
	elseif arg_3_1 >= #self then
		return self[#self]
	else
		return self[arg_3_1]
	end
end

DamageUtils.get_boost_curve_multiplier = function (arg_4_0, arg_4_1)
	-- function 4
	local num = (#arg_4_0 - 1) * arg_4_1
	local num_2 = math.floor(num) + 1
	local num_3 = num - math.floor(num)
	local var_4_3 = fn_2(arg_4_0, num_2 - 1)
	local var_4_4 = fn_2(arg_4_0, num_2 + 0)
	local var_4_5 = fn_2(arg_4_0, num_2 + 1)
	local var_4_6 = fn_2(arg_4_0, num_2 + 2)
	local num_4 = -var_4_3 / 2 + 3 * var_4_4 / 2 - 3 * var_4_5 / 2 + var_4_6 / 2
	local num_5 = var_4_3 - 5 * var_4_4 / 2 + 2 * var_4_5 - var_4_6 / 2
	local num_6 = -var_4_3 / 2 + var_4_5 / 2
	local var_4_10 = var_4_4

	return num_4 * num_3 * num_3 * num_3 + num_5 * num_3 * num_3 + num_6 * num_3 + var_4_10
end

local function fn_3(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	local num = 0

	if not arg_5_2 then
		if not arg_5_4 then
			if arg_5_5 == 3 then
				num = not self and self.headshot_boost_boss and self.headshot_boost and 0.25
			else
				num = not self and self.headshot_boost and 0.5
			end
		elseif not (arg_5_6 ~= 6 or arg_5_4) then
			num = not self and self.headshot_boost_heavy_armor and 0.25
		elseif not (arg_5_5 ~= 2 or arg_5_4) then
			num = not self and self.headshot_boost_armor and self.headshot_boost and 0.5
		end

		if arg_5_3 == "protected_weakspot" then
			num = num * 0.25
		end
	end

	if arg_5_3 == "protected_spot" then
		num = num - 0.5
	end

	return num
end

local function fn_4(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10, arg_6_11, arg_6_12, arg_6_13, arg_6_14, arg_6_15, arg_6_16, arg_6_17, arg_6_18, arg_6_19, arg_6_20, arg_6_21, arg_6_22)
	-- function 6
	if not arg_6_5 and not arg_6_5.no_damage then
		return 0
	end

	local var_6_0 = DifficultySettings[arg_6_16]
	local num = 0
	local num_2 = 0
	local num_3 = 1
	local num_4 = 1
	local get_breed_damage_multiplier_type = DamageUtils.get_breed_damage_multiplier_type(arg_6_11, arg_6_4)
	local flag = get_breed_damage_multiplier_type == "headshot" or get_breed_damage_multiplier_type == "weakspot" or get_breed_damage_multiplier_type == "protected_weakspot"

	if not ((flag or arg_6_9 or arg_6_15 or not arg_6_8) and not (arg_6_8 > 0)) then
		local var_6_7
		local flag_2

		flag_2 = arg_6_17 == 2 or arg_6_17 == 5 or arg_6_17 == 6 or 1 or arg_6_17

		local var_6_9 = arg_6_3[flag_2]

		var_6_9 = var_6_9 or flag_2 ~= 0 or not 0 or arg_6_3[1]

		local var_6_10

		if type(var_6_9) == "table" then
			local num_5 = var_6_9.max - var_6_9.min
			local get_power_level_for_target, var_6_13 = ActionUtils.get_power_level_for_target(arg_6_22, arg_6_2, arg_6_5, arg_6_6, arg_6_9, arg_6_0, arg_6_4, flag_2, arg_6_1, arg_6_11, arg_6_12, arg_6_16, arg_6_17, arg_6_18)
			local get_power_level_percentage = ActionUtils.get_power_level_percentage(get_power_level_for_target)

			var_6_10 = var_6_9.min + num_5 * get_power_level_percentage
		else
			var_6_10 = var_6_9
		end

		if not flag then
			num_3 = var_6_10 * 0.5
		end

		if not arg_6_9 then
			num_3 = var_6_10 * 0.5
		end

		if not ((arg_6_15 or not arg_6_8) and not (arg_6_8 > 0)) then
			num = var_6_10
		end
	end

	local var_6_15
	local var_6_16

	if type(arg_6_3) == "table" then
		local flag_3 = arg_6_18 or arg_6_17

		var_6_16 = arg_6_3[flag_3] or flag_3 ~= 0 or not 0 or arg_6_3[1]
	else
		var_6_16 = arg_6_3
	end

	if type(var_6_16) == "table" then
		local num_6 = var_6_16.max - var_6_16.min
		local num_7 = 0

		if not arg_6_5 then
			local get_power_level_for_target_2, var_6_21 = ActionUtils.get_power_level_for_target(arg_6_22, arg_6_2, arg_6_5, arg_6_6, arg_6_9, arg_6_0, arg_6_4, nil, arg_6_1, arg_6_11, arg_6_12, arg_6_16, arg_6_17, arg_6_18)

			num_7 = ActionUtils.get_power_level_percentage(get_power_level_for_target_2)
		end

		var_6_15 = var_6_16.min + num_6 * num_7
	else
		var_6_15 = var_6_16
	end

	local var_6_22

	if not arg_6_10 then
		var_6_22 = not num and var_6_15 < num and num * (arg_6_10 - 1) and var_6_15 * (arg_6_10 - 1)
	end

	if not arg_6_13 then
		if not arg_6_5 then
			-- Nothing
		end

		do
			local var_6_23
		end

		::label_6_0::

		if not arg_6_5.targets then
			var_6_23 = arg_6_5.targets[arg_6_6]

			if not var_6_23 then
				-- Nothing
			end
		end

		var_6_23 = arg_6_5.default_target

		::label_6_1::

		local num_8 = 0
		local var_6_25 = fn_3(var_6_23, arg_6_5, flag, get_breed_damage_multiplier_type, var_6_15 > 0, arg_6_17, arg_6_18)

		if not arg_6_15 then
			if arg_6_17 == 1 then
				num_8 = num_8 + 0.75
			elseif arg_6_17 == 2 then
				num_8 = num_8 + 0.6
			elseif arg_6_17 == 3 then
				num_8 = num_8 + 0.5
			elseif arg_6_17 == 4 then
				num_8 = num_8 + 0.5
			elseif arg_6_17 == 5 then
				num_8 = num_8 + 0.5
			elseif arg_6_17 == 6 then
				num_8 = num_8 + 0.3
			else
				num_8 = num_8 + 0.5
			end
		end

		if not (not arg_6_8 and not (arg_6_8 > 0)) then
			if arg_6_17 == 1 then
				num_8 = num_8 + 0.75
			elseif arg_6_17 == 2 then
				num_8 = num_8 + 0.3
			elseif arg_6_17 == 3 then
				num_8 = num_8 + 0.75
			elseif arg_6_17 == 4 then
				num_8 = num_8 + 0.5
			elseif arg_6_17 == 5 then
				num_8 = num_8 + 0.5
			elseif arg_6_17 == 6 then
				num_8 = num_8 + 0.2
			else
				num_8 = num_8 + 0.5
			end
		end

		if get_breed_damage_multiplier_type == "protected_spot" then
			num_8 = num_8 - 0.5
		end

		if not arg_6_5 and not arg_6_5.no_headshot_boost then
			var_6_25 = 0
		end

		local flag_4 = not arg_6_0 and ScriptUnit.has_extension(arg_6_0, "buff_system")
		local num_9 = 0

		if not arg_6_9 then
			num_9 = not arg_6_5 and arg_6_5.crit_boost and 0.5

			if not arg_6_5 and not arg_6_5.no_crit_boost then
				num_9 = 0
			end

			if not flag_4 and not flag_4:has_buff_perk("no_crit_damage") then
				num_9 = 0
			end
		end

		if not (not arg_6_7 and num_8 > 0 or var_6_25 > 0 or not (num_9 > 0)) then
			local var_6_28
			local var_6_29
			local boost_curve_coefficient

			if not var_6_23 then
				boost_curve_coefficient = var_6_23.boost_curve_coefficient

				if not boost_curve_coefficient then
					-- Nothing
				end
			end

			boost_curve_coefficient = DefaultBoostCurveCoefficient

			do
				local boost_curve_coefficient_headshot
			end

			::label_6_2::

			if not var_6_23 then
				boost_curve_coefficient_headshot = var_6_23.boost_curve_coefficient_headshot

				if not boost_curve_coefficient_headshot then
					-- Nothing
				end
			end

			boost_curve_coefficient_headshot = DefaultBoostCurveCoefficient

			::label_6_3::

			if not (not arg_6_8 and not (arg_6_8 > 0)) then
				if not arg_6_11 and not arg_6_11.boost_curve_multiplier_override then
					arg_6_8 = math.clamp(arg_6_8, 0, arg_6_11.boost_curve_multiplier_override)
				end

				boost_curve_coefficient = boost_curve_coefficient * arg_6_8
				boost_curve_coefficient_headshot = boost_curve_coefficient_headshot * arg_6_8
			end

			if num_8 > 0 then
				local get_modified_boost_curve = DamageUtils.get_modified_boost_curve(arg_6_7, boost_curve_coefficient)
				local clamp = math.clamp(num_8, 0, 1)
				local get_boost_curve_multiplier = DamageUtils.get_boost_curve_multiplier(get_modified_boost_curve or arg_6_7, clamp)

				num = math.max(math.max(num, var_6_15), num_4) * get_boost_curve_multiplier
			end

			if not (var_6_25 > 0 or not (num_9 > 0)) then
				local get_modified_boost_curve_2 = DamageUtils.get_modified_boost_curve(arg_6_7, boost_curve_coefficient_headshot)
				local clamp_2 = math.clamp(var_6_25 + num_9, 0, 1)
				local get_boost_curve_multiplier_2 = DamageUtils.get_boost_curve_multiplier(get_modified_boost_curve_2 or arg_6_7, clamp_2)

				num_2 = math.max(math.max(num, var_6_15), num_3) * get_boost_curve_multiplier_2

				if not flag_4 and not arg_6_9 then
					num_2 = num_2 * flag_4:apply_buffs_to_value(1, "critical_strike_effectiveness")
				end

				if not flag_4 and not flag then
					num_2 = num_2 * flag_4:apply_buffs_to_value(1, "headshot_multiplier")
				end

				local has_extension = ScriptUnit.has_extension(arg_6_22, "buff_system")

				if not has_extension and not flag then
					num_2 = num_2 * has_extension:apply_buffs_to_value(1, "headshot_vulnerability")
				end
			end
		end

		if not arg_6_11 and not arg_6_11.armored_boss_damage_reduction then
			var_6_15 = var_6_15 * 0.8
			num = num * 0.5
			var_6_22 = not var_6_22 and var_6_22 * 0.75
		end

		if not arg_6_11 and not arg_6_11.boss_damage_reduction then
			var_6_15 = var_6_15 * 0.45
			num = num * 0.5
			num_2 = num_2 * 0.5
			var_6_22 = not var_6_22 and var_6_22 * 0.75
		end

		if not arg_6_11 and not arg_6_11.lord_damage_reduction then
			var_6_15 = var_6_15 * 0.2
			num = num * 0.25
			num_2 = num_2 * 0.25
			var_6_22 = not var_6_22 and var_6_22 * 0.5
		end

		var_6_15 = var_6_15 + num + num_2

		if not var_6_22 then
			var_6_15 = var_6_15 + var_6_22
		end

		if not flag_4 then
			if get_breed_damage_multiplier_type == "headshot" then
				var_6_15 = flag_4:apply_buffs_to_value(var_6_15, "headshot_damage")
			else
				var_6_15 = flag_4:apply_buffs_to_value(var_6_15, "non_headshot_damage")
			end
		end

		local var_6_39

		if not arg_6_9 then
			if arg_6_4 ~= "head" or not arg_6_19 then
				var_6_39 = true
			elseif not (not arg_6_10 and not (arg_6_10 > 1) and not arg_6_20 and arg_6_5.charge_value ~= "heavy_attack") then
				var_6_39 = true
			end
		end

		if not var_6_39 and not arg_6_11 then
			local boss = arg_6_11.boss
			local primary_armor_category = arg_6_11.primary_armor_category

			if not (boss or primary_armor_category) then
				if not arg_6_21 then
					var_6_15 = arg_6_21
				else
					local max_health = arg_6_11.max_health
					local var_6_43 = max_health[var_6_0.rank]

					var_6_43 = var_6_43 or max_health[2]
					var_6_15 = var_6_43
				end
			end
		end
	end

	if not arg_6_14 then
		local friendly_fire_multiplier = var_6_0.friendly_fire_multiplier

		friendly_fire_multiplier = friendly_fire_multiplier or 0

		local mechanism_try_call, var_6_46, var_6_47 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "friendly_fire")

		if not mechanism_try_call and not var_6_47 and not var_6_46 then
			local versus_is_dark_pact = Managers.state.side:versus_is_dark_pact(arg_6_0)

			versus_is_dark_pact = versus_is_dark_pact or Managers.state.side:versus_is_dark_pact(arg_6_1)

			if not versus_is_dark_pact then
				local var_6_49 = DifficultySettings[var_6_46]

				friendly_fire_multiplier = not var_6_49 and var_6_49.friendly_fire_multiplier and 0
			end
		end

		if not arg_6_5 and not arg_6_5.friendly_fire_multiplier then
			friendly_fire_multiplier = friendly_fire_multiplier * arg_6_5.friendly_fire_multiplier
		end

		var_6_15 = var_6_15 * friendly_fire_multiplier
	end

	local flag_5 = false

	return var_6_15, flag_5
end

local function fn_5(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local has_extension = ScriptUnit.has_extension(arg_7_0, "buff_system")
	local var_7_1 = arg_7_4

	if not has_extension then
		local has_buff_perk = has_extension:has_buff_perk("finesse_stagger_damage")
		local has_buff_perk_2 = has_extension:has_buff_perk("smiter_stagger_damage")

		if not (not has_extension:has_buff_perk("linesman_stagger_damage") and not (var_7_1 > 0)) then
			var_7_1 = var_7_1 + 1
		elseif arg_7_3 or arg_7_2 == "head" or arg_7_2 == "neck" or not has_buff_perk then
			var_7_1 = 2
		elseif not has_buff_perk_2 then
			if not (not arg_7_1 and not (arg_7_1 <= 1)) then
				var_7_1 = math.max(1, var_7_1)
			else
				var_7_1 = arg_7_4
			end
		end
	end

	return var_7_1
end

DamageUtils.calculate_damage_tooltip = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14, arg_8_15)
	-- function 8
	local DamageOutput = DamageOutput
	local flag = false
	local flag_2 = false
	local flag_3 = false
	local flag_4 = false
	local var_8_5 = fn_4(arg_8_0, arg_8_1, arg_8_2, DamageOutput, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, flag, flag_2, arg_8_12, arg_8_13, arg_8_14, arg_8_15, flag_3, flag_4)

	return (DamageUtils.networkify_damage(var_8_5))
end

DamageUtils.calculate_dot_buff_damage = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	arg_9_2 = arg_9_2 or "full"
	arg_9_4 = arg_9_4 or DefaultPowerLevel

	local flag = false

	arg_9_5 = arg_9_5 or "default"

	local var_9_1 = DamageProfileTemplates[arg_9_5]
	local boost_curve_type = var_9_1.default_target.boost_curve_type
	local var_9_3 = BoostCurves[boost_curve_type]
	local num = 0
	local var_9_5
	local var_9_6

	arg_9_3 = arg_9_3 or "dot_debuff"

	return DamageUtils.calculate_damage(DamageOutput, arg_9_0, arg_9_1, arg_9_2, arg_9_4, var_9_3, num, flag, var_9_1, var_9_5, var_9_6, arg_9_3)
end

DamageUtils.calculate_damage = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, arg_10_9, arg_10_10, arg_10_11)
	-- function 10
	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local var_10_1
	local var_10_2
	local var_10_3

	if not arg_10_1 then
		var_10_1 = AiUtils.unit_breed(arg_10_1)
		var_10_2 = get_data(arg_10_1, "armor")

		local has_extension = ScriptUnit.has_extension(arg_10_1, "health_system")
		local has_extension_2 = ScriptUnit.has_extension(arg_10_1, "buff_system")
		local flag = not has_extension and has_extension:get_is_invincible()

		if flag or not has_extension_2 then
			if not has_extension_2:has_buff_perk("invulnerable") then
				flag = true
			elseif not has_extension_2:has_buff_perk("invulnerable_ranged") then
				local flag_2 = not arg_10_8 and arg_10_8.charge_value

				flag = RangedAttackTypes[flag_2]
			end
		end

		if not flag then
			return 0, flag
		end

		if not has_extension then
			var_10_3 = has_extension:get_max_health()
		elseif not var_10_1 then
			local max_health = var_10_1.max_health
			local var_10_9 = max_health[get_difficulty_settings.rank]

			var_10_9 = var_10_9 or max_health[2]
			var_10_3 = var_10_9
		end
	end

	local var_10_10

	if not arg_10_2 then
		var_10_10 = Unit.get_data(arg_10_2, "breed")
	end

	local flag_3 = not var_10_10 and not var_10_10.is_player
	local flag_4 = not not flag_3 or Managers.state.side:is_ally(arg_10_2, arg_10_1)
	local flag_5 = not var_10_1 and var_10_1.is_hero
	local num_2 = 0

	if not (not arg_10_8 and flag_3) then
		local var_10_15

		if not arg_10_8.targets then
			var_10_15 = arg_10_8.targets[arg_10_9]

			if not var_10_15 then
				-- Nothing
			end
		end

		var_10_15 = arg_10_8.default_target

		::label_10_0::

		num_2 = ActionUtils.get_range_scalar_multiplier(arg_10_8, var_10_15, arg_10_2, arg_10_1)
	end

	local flag_6 = not arg_10_2 and ScriptUnit.has_extension(arg_10_2, "buff_system")
	local flag_7 = false
	local flag_8 = false
	local flag_9 = false

	if not flag_6 then
		flag_7 = flag_6:has_buff_perk("potion_armor_penetration")
		flag_8 = flag_6:has_buff_perk("crit_headshot_killing_blow")
		flag_9 = flag_6:has_buff_perk("crit_backstab_killing_blow")
	end

	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local var_10_21
	local var_10_22
	local var_10_23

	if not flag_5 then
		var_10_21 = num
	else
		local var_10_24, var_10_25

		var_10_21, var_10_24, var_10_22, var_10_25 = ActionUtils.get_target_armor(arg_10_3, var_10_1, var_10_2)
	end

	local var_10_26 = fn_4(arg_10_2, arg_10_11, arg_10_4, arg_10_0, arg_10_3, arg_10_8, arg_10_9, arg_10_5, arg_10_6, arg_10_7, arg_10_10, var_10_1, num_2, flag_3, flag_4, flag_7, get_difficulty, var_10_21, var_10_22, flag_8, flag_9, var_10_3, arg_10_1)

	if not (not arg_10_8 and arg_10_8.is_dot) then
		local var_10_27 = BLACKBOARDS[arg_10_1]
		local num_3 = 0

		if not var_10_27 then
			local num_4 = 0
			local num_5 = 2

			if not var_10_27.is_climbing then
				num_3 = 2
			else
				local min = math.min
				local stagger = var_10_27.stagger

				stagger = stagger or num_4
				num_3 = min(stagger, num_5)
			end

			if not arg_10_8.no_stagger_damage_reduction_ranged then
				local num_6 = 1

				num_3 = math.max(num_6, num_3)
			end

			if not arg_10_8.no_stagger_damage_reduction_ranged then
				num_3 = fn_5(arg_10_2, arg_10_9, arg_10_3, arg_10_7, num_3)
			end
		end

		local min_stagger_damage_coefficient = get_difficulty_settings.min_stagger_damage_coefficient
		local stagger_damage_multiplier = get_difficulty_settings.stagger_damage_multiplier

		if not stagger_damage_multiplier then
			local num_7 = num_3 * stagger_damage_multiplier
			local has_extension_3 = ScriptUnit.has_extension(arg_10_1, "buff_system")

			if not (not has_extension_3 and arg_10_8.no_stagger_damage_reduction_ranged) then
				num_7 = has_extension_3:apply_buffs_to_value(num_7, "unbalanced_damage_taken")
			end

			var_10_26 = var_10_26 * (min_stagger_damage_coefficient + num_7)
		end
	end

	local weave = Managers.weave

	if not flag_5 and not flag_3 and not weave:get_active_weave() then
		var_10_26 = var_10_26 * (1 + weave:get_scaling_value("enemy_damage"))
	end

	return var_10_26
end

local function fn_6(self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15, arg_11_16, arg_11_17, arg_11_18)
	-- function 11
	if not arg_11_18 then
		-- Nothing
	end

	::label_11_0::

	local stagger_armor_category = arg_11_1.stagger_armor_category

	if not stagger_armor_category then
		stagger_armor_category = arg_11_1.armor_category
		stagger_armor_category = stagger_armor_category or 1
	end

	::label_11_1::

	local none = scripts_utils_stagger_types.none
	local num = 0
	local num_2 = 1
	local num_3 = 1
	local flag = not arg_11_3 and ScriptUnit.has_extension(arg_11_3, "buff_system")

	if not flag then
		flag:trigger_procs("stagger_calculation_started", arg_11_4)
	end

	local flag_2 = not arg_11_4 and ScriptUnit.has_extension(arg_11_4, "buff_system")
	local var_11_7

	if not arg_11_9.targets then
		var_11_7 = arg_11_9.targets[arg_11_10]

		if not var_11_7 then
			-- Nothing
		end
	end

	var_11_7 = arg_11_9.default_target

	::label_11_2::

	local attack_template = var_11_7.attack_template
	local get_attack_template = DamageUtils.get_attack_template(attack_template)
	local has_extension = ScriptUnit.has_extension(arg_11_4, "ai_system")
	local has_extension_2 = ScriptUnit.has_extension(arg_11_4, "status_system")
	local is_player = arg_11_2.is_player

	is_player = not is_player and not has_extension

	local var_11_13
	local alloc_table = FrameTable.alloc_table()

	alloc_table.damage_profile = arg_11_9

	if not arg_11_1 then
		local var_11_15 = rawget(ItemMasterList, arg_11_12)
		local flag_3 = not var_11_15 and var_11_15.template

		if not flag_3 then
			local get_weapon_template = WeaponUtils.get_weapon_template(flag_3)
			local flag_4 = not get_weapon_template and get_weapon_template.buff_type

			var_11_13 = not flag_4 and RangedBuffTypes[flag_4]
			alloc_table.is_ranged = var_11_13
		end
	end

	alloc_table.is_ranged = var_11_13

	local flag_5 = false
	local mechanism_try_call, var_11_21, var_11_22 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "pactsworn_stagger_immunity")

	if not mechanism_try_call and not var_11_22 and not var_11_21 then
		local has_extension_3 = ScriptUnit.has_extension(arg_11_4, "career_system")

		if not has_extension_3 then
			local profile_index = has_extension_3:profile_index()

			if SPProfiles[profile_index].affiliation == "dark_pact" then
				flag_5 = true
			end
		end
	end

	local stagger_count

	if not is_player and not has_extension_2 then
		stagger_count = has_extension_2:stagger_count()

		if not stagger_count then
			-- Nothing
		end
	end

	stagger_count = arg_11_2.stagger_count
	stagger_count = stagger_count or 0

	::label_11_3::

	if not (arg_11_5 ~= "weakspot" or stagger_count ~= 0 or not arg_11_2.stagger or arg_11_2.stagger_anim_done or not is_player or has_extension_2:accumulated_stagger()) then
		none = scripts_utils_stagger_types.weakspot
	elseif not (not self and arg_11_1.stagger_immune or flag_5) then
		local var_11_26 = self[stagger_armor_category]
		local num_4 = var_11_26.max - var_11_26.min
		local get_power_level_for_target, var_11_29 = ActionUtils.get_power_level_for_target(arg_11_4, arg_11_6, arg_11_9, arg_11_10, arg_11_8, arg_11_3, arg_11_5, nil, arg_11_12, arg_11_1, arg_11_13, arg_11_15, stagger_armor_category, nil)

		if not arg_11_3 and not alive(arg_11_3) and not flag then
			var_11_29 = flag:apply_buffs_to_value(var_11_29, "push_power")

			local breed_action

			if not is_player then
				breed_action = has_extension_2:breed_action()

				if not breed_action then
					-- Nothing
				end
			end

			breed_action = arg_11_2.action

			::label_11_4::

			if not breed_action and not breed_action.damage then
				var_11_29 = flag:apply_buffs_to_value(var_11_29, "counter_push_power")
			end
		end

		if not flag then
			var_11_29 = flag:apply_buffs_to_value(var_11_29, "power_level_impact")
		end

		if not flag_2 then
			var_11_29 = flag_2:apply_buffs_to_value(var_11_29, "impact_vulnerability")
		end

		num = num_4 * ActionUtils.get_power_level_percentage(var_11_29)

		local flag_6 = arg_11_8 or arg_11_5 == "head" or arg_11_5 == "neck"

		num = var_11_26.min + num

		if not arg_11_17 then
			num = num * 2
		end

		if not arg_11_1 then
			local rank = DifficultySettings[arg_11_15].rank
			local var_11_33

			if not arg_11_1.diff_stagger_resist then
				var_11_33 = arg_11_1.diff_stagger_resist[rank]

				if not var_11_33 then
					-- Nothing
				end

				var_11_33 = arg_11_1.diff_stagger_resist[2]

				if not var_11_33 then
					-- Nothing
				end
			end

			if not var_11_13 then
				var_11_33 = arg_11_1.stagger_resistance_ranged

				if not var_11_33 then
					-- Nothing
				end
			end

			var_11_33 = arg_11_1.stagger_resistance
			var_11_33 = var_11_33 or 2

			::label_11_5::

			if not flag_2 then
				var_11_33 = flag_2:apply_buffs_to_value(var_11_33, "stagger_resistance")
			end

			local breed_action_2

			if not is_player then
				breed_action_2 = has_extension_2:breed_action()

				if not breed_action_2 then
					-- Nothing
				end
			end

			breed_action_2 = arg_11_2.action

			::label_11_6::

			local flag_7 = not breed_action_2 and breed_action_2.stagger_reduction
			local flag_8 = not not flag_6 or not not arg_11_9.ignore_stagger_reduction or flag_7 or arg_11_1.stagger_reduction

			if not (not flag_8 and type(flag_8) ~= "table") then
				flag_8 = flag_8[rank] or flag_8[2]
			end

			if not flag_8 then
				num = math.clamp(num - flag_8, 0, num)
			end

			local flag_9 = false

			if not arg_11_2.stagger then
				local clamp = math.clamp
				local stagger = arg_11_2.stagger
				local stagger_multiplier = arg_11_1.stagger_multiplier

				stagger_multiplier = stagger_multiplier or 0.5
				num = num + clamp(stagger * stagger_multiplier * num, 0, num)
			elseif not (not is_player and not has_extension_2 and not (has_extension_2:accumulated_stagger() > 0)) then
				local accumulated_stagger = has_extension_2:accumulated_stagger()
				local clamp_2 = math.clamp
				local stagger_multiplier_2 = arg_11_1.stagger_multiplier

				stagger_multiplier_2 = stagger_multiplier_2 or 0.5
				num = num + clamp_2(accumulated_stagger * stagger_multiplier_2 * num, 0, num)
			elseif not arg_11_9.is_push then
				flag_9 = true
			end

			if num > 0 then
				local num_5

				if not arg_11_1.stagger_threshold_light then
					num_5 = arg_11_1.stagger_threshold_light * var_11_33

					if not num_5 then
						-- Nothing
					end
				end

				num_5 = 0.25 * var_11_33

				do
					local num_6
				end

				::label_11_7::

				if not arg_11_1.stagger_threshold_medium then
					num_6 = arg_11_1.stagger_threshold_medium * var_11_33

					if not num_6 then
						-- Nothing
					end
				end

				num_6 = 1 * var_11_33

				do
					local num_7
				end

				::label_11_8::

				if not arg_11_1.stagger_threshold_heavy then
					num_7 = arg_11_1.stagger_threshold_heavy * var_11_33

					if not num_7 then
						-- Nothing
					end
				end

				num_7 = 2.5 * var_11_33

				::label_11_9::

				if not flag_9 then
					num_7 = num_7 * 2
				end

				local num_8

				if not arg_11_1.stagger_threshold_explosion then
					num_8 = arg_11_1.stagger_threshold_explosion * var_11_33

					if not num_8 then
						-- Nothing
					end
				end

				num_8 = 10 * var_11_33

				::label_11_10::

				local num_9 = 0
				local var_11_49
				local num_10 = 1

				if num < num_5 then
					none = scripts_utils_stagger_types.none
				elseif num < num_6 then
					none = scripts_utils_stagger_types.weak
					num_9 = num

					local flag_10 = not (num_9 > 0) or not (num_9 / var_11_33) or 0

					num_10 = 0.5 + 0.5 * math.clamp(flag_10, 0, 1)
				elseif num < num_7 then
					none = scripts_utils_stagger_types.medium
					num_9 = num - num_6

					local flag_11 = not (num_9 > 0) or not (num_9 / var_11_33) or 0

					num_10 = 0.5 + 0.5 * math.clamp(flag_11, 0, 1)
				elseif num < num_8 then
					none = scripts_utils_stagger_types.heavy
					num_9 = num - num_7

					local flag_12 = not (num_9 > 0) or not (num_9 / var_11_33) or 0

					num_10 = 0.5 + 0.5 * math.clamp(flag_12, 0, 1)
				elseif not arg_11_9.is_explosion then
					none = scripts_utils_stagger_types.explosion
				elseif not arg_11_9.is_pull then
					none = scripts_utils_stagger_types.pulling
				else
					none = scripts_utils_stagger_types.heavy
				end

				if not arg_11_1.stagger_duration_difficulty_mod then
					local stagger_duration_difficulty_mod = arg_11_1.stagger_duration_difficulty_mod
					local var_11_55 = stagger_duration_difficulty_mod[rank]

					if not var_11_55 then
						var_11_55 = stagger_duration_difficulty_mod[2]
						var_11_55 = var_11_55 or 1
					end

					num_2 = num_2 * var_11_55
				end

				num_2 = num_2 * (0.75 + 0.25 * math.clamp(num_9 / var_11_33, 0, 2))
				num_3 = math.clamp(num_3 * num_10, 0.5, 1)
			end
		end
	end

	if not (not arg_11_9.is_pull and not (none <= scripts_utils_stagger_types.heavy)) then
		none = scripts_utils_stagger_types.pulling
	end

	if not get_attack_template.ranged_stagger then
		if none == scripts_utils_stagger_types.weak then
			none = scripts_utils_stagger_types.ranged_weak
		elseif none == scripts_utils_stagger_types.medium then
			none = scripts_utils_stagger_types.ranged_medium
		end
	end

	local stagger_value

	if not get_attack_template then
		stagger_value = get_attack_template.stagger_value

		if not stagger_value then
			-- Nothing
		end
	end

	stagger_value = 1

	::label_11_11::

	alloc_table.stagger_value = stagger_value

	local var_11_57

	if not arg_11_1.stagger_modifier_function then
		none, num_2, num_3, var_11_57 = arg_11_1.stagger_modifier_function(none, num_2, num_3, arg_11_5, arg_11_2, arg_11_1, alloc_table)
	end

	if not arg_11_11 then
		if not arg_11_14 then
			arg_11_14.blocked_previous_attack = true
		end

		if not (none ~= scripts_utils_stagger_types.none or var_11_57) then
			none = scripts_utils_stagger_types.weak
		elseif not (none ~= scripts_utils_stagger_types.heavy or stagger_value ~= 1) then
			none = scripts_utils_stagger_types.medium
		end
	end

	if not ((not arg_11_1.boss_staggers and none < scripts_utils_stagger_types.explosion and none == scripts_utils_stagger_types.pulling or not arg_11_1.small_boss_staggers) and none ~= scripts_utils_stagger_types.pulling) then
		none = scripts_utils_stagger_types.none
	end

	local breed_action_3

	if not is_player then
		breed_action_3 = has_extension_2:breed_action()

		if not breed_action_3 then
			-- Nothing
		end
	end

	breed_action_3 = arg_11_2.action

	::label_11_12::

	local flag_13 = not breed_action_3 and breed_action_3.ignore_staggers

	if not flag_13 and not flag and not flag:has_buff_type("push_increase") then
		flag_13 = false
	end

	if not (not get_attack_template.always_stagger and arg_11_1.boss and not flag_13 or not flag_13[none] and not flag_13.allow_push and not get_attack_template and get_attack_template.is_push) then
		return scripts_utils_stagger_types.none, 0, 0, 0, 0
	end

	if not (not arg_11_1.no_stagger_duration and get_attack_template.always_stagger) then
		num_2 = num_2 * 0.25
	end

	if not flag and not flag:has_buff_perk("explosive_stagger") then
		none = scripts_utils_stagger_types.explosion
	end

	local stagger_duration_modifier = var_11_7.stagger_duration_modifier

	if not stagger_duration_modifier then
		stagger_duration_modifier = arg_11_9.stagger_duration_modifier
		stagger_duration_modifier = stagger_duration_modifier or DefaultStaggerDurationModifier
	end

	local stagger_distance_modifier = var_11_7.stagger_distance_modifier

	if not stagger_distance_modifier then
		stagger_distance_modifier = arg_11_9.stagger_distance_modifier
		stagger_distance_modifier = stagger_distance_modifier or DefaultStaggerDistanceModifier
	end

	local var_11_62

	if not arg_11_1.stagger_duration then
		var_11_62 = arg_11_1.stagger_duration[none]

		if not var_11_62 then
			-- Nothing
		end
	end

	var_11_62 = DefaultStaggerDuration

	::label_11_13::

	local num_11 = num_2 * var_11_62 * stagger_duration_modifier
	local num_12 = num_3 * stagger_distance_modifier

	if not flag_2 then
		num_12 = flag_2:apply_buffs_to_value(num_12, "stagger_distance")
	end

	if not flag then
		num_12 = flag:apply_buffs_to_value(num_12, "applied_stagger_distance")
	end

	if not arg_11_1.no_random_stagger_duration then
		num_11 = math.max(num_11 + math.random() * 0.25, 0)
	end

	if not arg_11_1.max_stagger_duration then
		num_11 = math.min(num_11, arg_11_1.max_stagger_duration)
	end

	if not arg_11_9.is_pull and not arg_11_4 then
		local var_11_65 = POSITION_LOOKUP[arg_11_4]

		var_11_65 = var_11_65 or Unit.world_position(arg_11_4, 0)

		local var_11_66 = POSITION_LOOKUP[arg_11_3]

		var_11_66 = var_11_66 or Unit.world_position(arg_11_3, 0)

		local num_13 = Vector3.length(var_11_65 - var_11_66) - 2.25

		num_12 = math.max(math.min(num_12, num_13), 0)
	end

	if not flag then
		flag:trigger_procs("stagger_calculation_ended", arg_11_4)
	end

	return none, num_11, num_12, stagger_value, num
end

local tbl_3 = {}

DamageUtils.calculate_stagger_player_tooltip = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8, arg_12_9, arg_12_10, arg_12_11, arg_12_12)
	-- function 12
	local ImpactTypeOutput = ImpactTypeOutput

	arg_12_0 = arg_12_0 or tbl_3

	local var_12_1 = tbl_3
	local var_12_2
	local flag = false
	local var_12_4
	local var_12_5
	local var_12_6, var_12_7, var_12_8, var_12_9, var_12_10 = fn_6(ImpactTypeOutput, arg_12_0, var_12_1, arg_12_1, var_12_2, arg_12_2, arg_12_3, var_12_5, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8, arg_12_11, var_12_4, arg_12_9, flag, arg_12_10, arg_12_12)

	return var_12_6, var_12_7, var_12_8, var_12_9, var_12_10
end

DamageUtils.calculate_stagger_player = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10)
	-- function 13
	local var_13_0 = BLACKBOARDS[arg_13_1]
	local breed = var_13_0.breed
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local shield_user = AiUtils.shield_user(arg_13_1)
	local var_13_4

	if not arg_13_7.targets then
		var_13_4 = arg_13_7.targets[arg_13_8]

		if not var_13_4 then
			-- Nothing
		end
	end

	var_13_4 = arg_13_7.default_target

	::label_13_0::

	local get_range_scalar_multiplier = ActionUtils.get_range_scalar_multiplier(arg_13_7, var_13_4, arg_13_2, arg_13_1)
	local has_extension = ScriptUnit.has_extension(arg_13_1, "ai_shield_system")
	local flag = false

	if not arg_13_2 and not alive(arg_13_2) then
		local has_extension_2 = ScriptUnit.has_extension(arg_13_2, "buff_system")

		if not has_extension_2 then
			flag = has_extension_2:has_buff_perk("potion_armor_penetration")
		end
	end

	local var_13_9, var_13_10, var_13_11, var_13_12, var_13_13 = fn_6(arg_13_0, breed, var_13_0, arg_13_2, arg_13_1, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10, get_range_scalar_multiplier, has_extension, get_difficulty, shield_user, flag)

	return var_13_9, var_13_10, var_13_11, var_13_12, var_13_13
end

DamageUtils.calculate_stagger = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	local var_14_0 = BLACKBOARDS[arg_14_2]
	local breed = var_14_0.breed
	local stagger_armor_category = breed.stagger_armor_category

	if not stagger_armor_category then
		stagger_armor_category = breed.armor_category
		stagger_armor_category = stagger_armor_category or 1
	end

	local shield_user = AiUtils.shield_user(arg_14_2)
	local none = scripts_utils_stagger_types.none
	local num = 0.5
	local has_extension = ScriptUnit.has_extension(arg_14_2, "ai_system")
	local has_extension_2 = ScriptUnit.has_extension(arg_14_2, "status_system")
	local is_player = var_14_0.is_player

	is_player = not is_player and not has_extension

	if (arg_14_5 ~= "weakspot" or var_14_0.stagger_count ~= 0 or not var_14_0.stagger) and not var_14_0.stagger_anim_done then
		none = scripts_utils_stagger_types.weakspot
	elseif not self then
		none = self[stagger_armor_category] or self[1]
	end

	local stagger_value

	if not arg_14_4 then
		stagger_value = arg_14_4.stagger_value

		if not stagger_value then
			-- Nothing
		end
	end

	stagger_value = 1

	::label_14_0::

	if not arg_14_6 then
		if none == scripts_utils_stagger_types.none then
			none = scripts_utils_stagger_types.weak
		elseif not (none ~= scripts_utils_stagger_types.heavy or stagger_value ~= 1) then
			none = scripts_utils_stagger_types.medium
		end
	end

	if not (not breed.boss_staggers and not (none < scripts_utils_stagger_types.explosion)) then
		none = scripts_utils_stagger_types.none
	end

	local breed_action

	if not is_player then
		breed_action = has_extension_2:breed_action()

		if not breed_action then
			-- Nothing
		end
	end

	breed_action = var_14_0.action

	::label_14_1::

	local flag = not breed_action and breed_action.ignore_staggers

	if not flag then
		local has_extension_3 = ScriptUnit.has_extension(arg_14_3, "buff_system")

		if not has_extension_3 and not has_extension_3:has_buff_type("push_increase") then
			flag = false
		end
	end

	if not (not flag and not flag[none] and not flag.allow_push and not arg_14_4 and arg_14_4.is_push) then
		return 0, 0
	end

	if not arg_14_1 then
		num = arg_14_1[stagger_armor_category] or arg_14_1[1]
	end

	if not breed.no_stagger_duration then
		num = num * 0.25
	elseif not breed.stagger_duration_mod then
		num = num * breed.stagger_duration_mod
	elseif not arg_14_6 then
		local lerp = math.lerp
		local var_14_14 = num
		local num_2 = 1.25
		local block_stagger_mod = breed.block_stagger_mod

		block_stagger_mod = block_stagger_mod or 0.5
		num = lerp(var_14_14, num_2, block_stagger_mod)
	elseif not shield_user then
		local shield_stagger_mod = breed.shield_stagger_mod

		shield_stagger_mod = shield_stagger_mod or 0.6
		num = num * shield_stagger_mod
	else
		num = math.max(num + math.random() - 0.5, 0)
	end

	return none, num
end

DamageUtils.is_player_unit = function (arg_15_0)
	-- function 15
	return Managers.player:is_player_unit(arg_15_0)
end

DamageUtils.stagger_player = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11)
	-- function 16
	fassert(arg_16_4 > 0, "Tried to use invalid stagger type %q", arg_16_4)

	local stagger_modifier = Managers.state.difficulty:get_difficulty_settings().stagger_modifier
	local has_extension = ScriptUnit.has_extension(arg_16_0, "status_system")
	local breed_action = has_extension:breed_action()

	if not breed_action and breed_action.stagger_prohibited or not has_extension:get_in_ghost_mode() then
		return
	end

	arg_16_8 = arg_16_8 or 1
	arg_16_6 = arg_16_6 or 1

	local num = arg_16_5 * stagger_modifier
	local accumulated_stagger = has_extension:accumulated_stagger()
	local clamp = math.clamp
	local num_2

	if not accumulated_stagger then
		num_2 = accumulated_stagger + arg_16_8

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = arg_16_8

	::label_16_0::

	local var_16_7 = clamp(num_2, 0, 2)
	local max = math.max(var_16_7, accumulated_stagger)

	has_extension:set_stagger_values(arg_16_4, arg_16_2, arg_16_3, max, num, arg_16_6, arg_16_9, true)

	if not arg_16_11 then
		local push_sound_event = arg_16_1.push_sound_event

		push_sound_event = push_sound_event or "Play_generic_pushed_impact_small"

		Managers.state.entity:system("audio_system"):play_audio_unit_event(push_sound_event, arg_16_0)
	end
end

DamageUtils.hit_zone = function (arg_17_0, arg_17_1)
	-- function 17
	local unit_breed = AiUtils.unit_breed(arg_17_0)

	if not unit_breed then
		local var_17_1 = node(arg_17_1)

		return unit_breed.hit_zones_lookup[var_17_1].name
	else
		return "full"
	end
end

DamageUtils.aoe_hit_zone = function (arg_18_0, arg_18_1)
	-- function 18
	local unit_breed = AiUtils.unit_breed(arg_18_0)

	if not unit_breed then
		local var_18_1 = node(arg_18_1)
		local var_18_2 = unit_breed.hit_zones_lookup[var_18_1]
		local flag

		flag = (not var_18_2 and var_18_2.name) ~= "afro" or not "afro" or "torso"

		return flag
	else
		return "full"
	end
end

DamageUtils.draw_aoe_size = function (arg_19_0, arg_19_1)
	-- function 19
	local calculate_aoe_size, var_19_1 = DamageUtils.calculate_aoe_size(arg_19_0)
	local var_19_2 = POSITION_LOOKUP[arg_19_0]
	local num = var_19_2 + Vector3(0, 0, math.max(var_19_1 - calculate_aoe_size * 0.5, var_19_1 * 0.5))
	local num_2 = var_19_2 + Vector3(0, 0, math.min(calculate_aoe_size * 0.5, var_19_1 * 0.5))

	QuickDrawer:capsule(num_2, num, calculate_aoe_size, Color(255, 255, 0, 255))
end

DamageUtils.calculate_aoe_size = function (arg_20_0, arg_20_1)
	-- function 20
	local var_20_0
	local var_20_1

	if not arg_20_1 then
		var_20_0 = arg_20_1.aoe_radius or DEFAULT_BREED_AOE_RADIUS
		var_20_1 = arg_20_1.aoe_height or DEFAULT_BREED_AOE_HEIGHT
	elseif not DamageUtils.is_player_unit(arg_20_0) then
		var_20_0 = 0.3
		var_20_1 = 1.7
	else
		var_20_0 = 1
		var_20_1 = 1
	end

	return var_20_0, var_20_1
end

local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}

DamageUtils.create_explosion = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10, arg_21_11, arg_21_12)
	-- function 21
	local DamageUtils = DamageUtils
	local explosion = arg_21_4.explosion
	local get_active_wind = Managers.weave:get_active_wind()
	local get_active_wind_settings = Managers.weave:get_active_wind_settings()
	local wind_mutator = explosion.wind_mutator

	if not explosion.camera_effect then
		local camera_effect = explosion.camera_effect
		local shake_name = camera_effect.shake_name
		local near_distance = camera_effect.near_distance
		local far_distance = camera_effect.far_distance
		local near_scale = camera_effect.near_scale
		local far_scale = camera_effect.far_scale
		local time = Managers.time:time("game")

		DamageUtils.camera_shake_by_distance(shake_name, time, nil, arg_21_9, near_distance, far_distance, near_scale, far_scale)
	end

	if not explosion.effect_name then
		local identity

		if not explosion.dont_rotate_fx then
			identity = Quaternion.identity()

			if not identity then
				-- Nothing
			end
		end

		identity = arg_21_3

		::label_21_0::

		World.create_particles(arg_21_0, explosion.effect_name, arg_21_2, identity)
	end

	if not explosion.sound_event_name then
		local make_position_auto_source, var_21_14 = WwiseUtils.make_position_auto_source(arg_21_0, arg_21_2)
		local flag

		flag = not arg_21_8 and "true" and "false"

		WwiseWorld.set_switch(var_21_14, "husk", flag, make_position_auto_source)
		WwiseWorld.trigger_event(var_21_14, explosion.sound_event_name, make_position_auto_source)
	end

	local flag_2 = false

	if not explosion.only_facing then
		local local_player = Managers.player:local_player()
		local flag_3 = not local_player and local_player.player_unit

		if not flag_3 then
			local local_position_2 = Unit.local_position(arg_21_1, 0)
			local var_21_20 = POSITION_LOOKUP[flag_3]
			local local_rotation = Unit.local_rotation(flag_3, 0)
			local to_euler_angles_xyz, var_21_23, var_21_24 = Quaternion.to_euler_angles_xyz(local_rotation)
			local num = var_21_24 - math.radians_to_degrees(math.angle(local_position_2.x, local_position_2.y, var_21_20.x, var_21_20.y))

			if num < 0 then
				num = num + 360
			end

			if math.abs(90 - num) < 90 then
				flag_2 = true
			end
		end
	end

	if not explosion.screenspace_effect_name and not explosion.only_facing and not flag_2 then
		local local_player_2 = Managers.player:local_player()
		local flag_4 = not local_player_2 and local_player_2.player_unit

		if not flag_4 then
			local var_21_28 = POSITION_LOOKUP[flag_4]
			local distance = Vector3.distance(var_21_28, arg_21_2)
			local screenspace_effect_radius = explosion.screenspace_effect_radius

			screenspace_effect_radius = screenspace_effect_radius or explosion.radius

			if distance <= screenspace_effect_radius then
				local has_extension = ScriptUnit.has_extension(flag_4, "first_person_system")

				if not has_extension then
					has_extension:create_screen_particles(explosion.screenspace_effect_name)
				end
			end
		end
	end

	local var_21_32 = alive(arg_21_1)

	if not arg_21_7 and not var_21_32 then
		if not explosion.alert_enemies then
			Managers.state.entity:system("ai_system"):alert_enemies_within_range(arg_21_1, arg_21_2, explosion.alert_enemies_radius)
		end

		local player_push_speed = explosion.player_push_speed
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local fallback_difficulty = Managers.state.difficulty.fallback_difficulty
		local radius = explosion.radius
		local var_21_37

		if not wind_mutator and not get_active_wind and not get_active_wind_settings.radius then
			local get_wind_strength = Managers.weave:get_wind_strength()

			radius = get_active_wind_settings.radius[get_difficulty][get_wind_strength] or get_active_wind_settings.radius[2][get_wind_strength]
			var_21_37 = explosion.max_damage_radius or radius - 1
		else
			var_21_37 = explosion.max_damage_radius or 0
		end

		local radius_min = explosion.radius_min
		local radius_max = explosion.radius_max
		local exponential_falloff = explosion.exponential_falloff

		if not radius_min and not radius_max then
			radius = math.lerp(radius_min, radius_max, arg_21_5)

			if not explosion.max_damage_radius_min then
				local max_damage_radius_min = explosion.max_damage_radius_min
				local max_damage_radius_max = explosion.max_damage_radius_max

				var_21_37 = math.lerp(max_damage_radius_min, max_damage_radius_max, arg_21_5)
			end
		end

		fassert(radius, "Explosion template [%s] has no radius, or radius_min & radius_max, set", arg_21_4.name)

		local has_extension_2 = ScriptUnit.has_extension(arg_21_1, "buff_system")
		local is_grenade = arg_21_4.is_grenade

		if not has_extension_2 then
			local num_2 = 1

			if not is_grenade then
				num_2 = num_2 + (has_extension_2:apply_buffs_to_value(1, "grenade_radius") - 1)
			end

			local num_3 = num_2 + (has_extension_2:apply_buffs_to_value(1, "explosion_radius") - 1)

			radius = radius * num_3
			var_21_37 = var_21_37 * num_3
		end

		local difficulty_power_level = explosion.difficulty_power_level

		if not difficulty_power_level then
			difficulty_power_level = explosion.difficulty_power_level[get_difficulty]
			difficulty_power_level = difficulty_power_level or explosion.difficulty_power_level[fallback_difficulty]
		end

		local different_power_levels_for_players = explosion.different_power_levels_for_players
		local flag_5 = difficulty_power_level or explosion
		local var_21_51
		local var_21_52
		local var_21_53
		local var_21_54
		local var_21_55

		if not wind_mutator and not get_active_wind then
			local get_wind_strength_2 = Managers.weave:get_wind_strength()

			if not different_power_levels_for_players then
				var_21_54 = get_active_wind_settings.power_level_player[get_difficulty][get_wind_strength_2]
				var_21_55 = get_active_wind_settings.power_level_ai[get_difficulty][get_wind_strength_2]
			else
				var_21_51 = not get_active_wind_settings.power_level and get_active_wind_settings.power_level[get_difficulty][get_wind_strength_2] and 0
			end
		else
			var_21_51 = flag_5.power_level
			var_21_52 = flag_5.power_level_min
			var_21_53 = flag_5.power_level_max
		end

		if not explosion.use_attacker_power_level then
			assert(arg_21_10, "No attacker power level argument sent for explosion requiring it!")

			var_21_51 = arg_21_10
			var_21_53 = arg_21_10

			local attacker_power_level_offset = explosion.attacker_power_level_offset

			attacker_power_level_offset = attacker_power_level_offset or DefaultAttackerPowerLevelOffset
			var_21_52 = var_21_53 * attacker_power_level_offset
		end

		if not explosion.scale_power_level then
			var_21_51 = math.max(explosion.scale_power_level, arg_21_5) * var_21_51
			var_21_53 = math.max(explosion.scale_power_level, arg_21_5) * var_21_53
			var_21_52 = math.max(explosion.scale_power_level, arg_21_5) * var_21_52
		end

		local power_level_glance = flag_5.power_level_glance
		local flag_6 = var_21_51 or not var_21_52 and var_21_53 and different_power_levels_for_players or false
		local ignore_attacker_unit = explosion.ignore_attacker_unit
		local collision_filter = explosion.collision_filter

		collision_filter = collision_filter or "filter_explosion_overlap"

		local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
		local only_line_of_sight = explosion.only_line_of_sight
		local owner = Managers.player:owner(arg_21_1)
		local flag_7 = owner ~= nil
		local no_friendly_fire = explosion.no_friendly_fire
		local allow_friendly_fire_override = explosion.allow_friendly_fire_override
		local var_21_68

		if not flag_7 then
			var_21_68 = allow_friendly_fire_override or DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, owner)
		else
			var_21_68 = explosion.ai_friendly_fire
		end

		if not has_extension_2 and not has_extension_2:has_buff_perk(scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.no_explosion_friendly_fire) then
			var_21_68 = false
		end

		local flag_8 = not var_21_68 and not no_friendly_fire
		local physics_world = World.physics_world(arg_21_0)
		local immediate_overlap, var_21_72 = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", arg_21_2, "size", radius, "collision_filter", collision_filter)
		local var_21_73 = tbl_4
		local var_21_74 = tbl_5
		local var_21_75 = tbl_6

		table.clear(var_21_73)
		table.clear(var_21_74)
		table.clear(var_21_75)

		local explosion_forward_scaling = explosion.explosion_forward_scaling
		local explosion_right_scaling = explosion.explosion_right_scaling
		local explosion_cone_angle = explosion.explosion_cone_angle

		explosion_cone_angle = not explosion_cone_angle and math.cos(explosion_cone_angle / 2)

		local var_21_79

		if explosion_forward_scaling or explosion_right_scaling or not explosion_cone_angle then
			var_21_79 = Quaternion.forward(arg_21_3)
		end

		local num_4 = 0

		for i = 1, var_21_72 do
			local var_21_81 = immediate_overlap[i]
			local flag_9 = not var_21_81 and unit(var_21_81)

			if not ScriptUnit.has_extension(flag_9, "health_system") then
				if not (get_data(flag_9, "ignore_explosion_damage") or var_21_73[flag_9] or not ignore_attacker_unit or flag_9 == arg_21_1 or DamageUtils.aoe_hit_zone(flag_9, var_21_81) == "afro") then
					if not only_line_of_sight then
						local flag_10 = true

						if explosion_cone_angle or not explosion_forward_scaling then
							local num_5 = Unit.world_position(flag_9, 0) + Vector3.up() - arg_21_2
							local normalize = Vector3.normalize(num_5)

							if not explosion_cone_angle then
								flag_10 = explosion_cone_angle <= Vector3.dot(normalize, var_21_79)
							end

							if not flag_10 and not explosion_forward_scaling then
								local lerp = math.lerp(radius, radius * explosion_forward_scaling, math.abs(Vector3.dot(normalize, var_21_79)))

								flag_10 = lerp * lerp >= Vector3.length_squared(num_5)
							end
						end

						if not flag_10 then
							num_4 = num_4 + 1
							var_21_73[flag_9] = true
							var_21_74[num_4] = var_21_81
						end
					else
						local num_6 = Unit.world_position(flag_9, 0) + Vector3.up() - arg_21_2
						local normalize_2 = Vector3.normalize(num_6)
						local var_21_89 = radius
						local flag_11 = true

						if not explosion_cone_angle then
							flag_11 = explosion_cone_angle <= Vector3.dot(normalize_2, var_21_79)
						end

						local flag_12 = true

						if not flag_11 and not explosion_forward_scaling then
							local lerp_2 = math.lerp(radius, radius * explosion_forward_scaling, math.abs(Vector3.dot(normalize_2, var_21_79)))

							flag_12 = lerp_2 * lerp_2 <= Vector3.length_squared(num_6)
						end

						if not flag_11 and not explosion_right_scaling then
							local lerp_3 = math.lerp(radius, radius * explosion_right_scaling, 1 - math.abs(Vector3.dot(normalize_2, explosion_right_scaling)))

							flag_12 = lerp_3 * lerp_3 <= Vector3.length_squared(num_6)
						end

						if not flag_11 and not flag_12 then
							PhysicsWorld.prepare_actors_for_raycast(physics_world, arg_21_2, normalize_2, 0.1)

							local immediate_raycast = PhysicsWorld.immediate_raycast(physics_world, arg_21_2, normalize_2, var_21_89, "all", "collision_filter", "filter_explosion_overlap_no_static")

							if not immediate_raycast then
								local count = #immediate_raycast

								for j = 1, count do
									local var_21_96 = immediate_raycast[j][4]
									local unit_2 = Actor.unit(var_21_96)

									if not AiUtils.unit_breed(unit_2) then
										break
									end

									if flag_9 == unit_2 then
										num_4 = num_4 + 1
										var_21_73[flag_9] = true
										var_21_74[num_4] = var_21_81

										break
									end
								end
							end
						end
					end
				end
			elseif not (not flag_9 and not alive(flag_9) and not var_21_81 and explosion.no_prop_damage or var_21_75[flag_9]) then
				var_21_75[flag_9] = true

				local normalize_3 = Vector3.normalize(position(var_21_81) - arg_21_2)

				set_flow_variable(flag_9, "hit_actor", var_21_81)
				set_flow_variable(flag_9, "hit_direction", normalize_3)
				set_flow_variable(flag_9, "hit_position", arg_21_2)
				flow_event(flag_9, "lua_simple_damage")
			end
		end

		if not is_grenade then
			SurroundingAwareSystem.add_event(arg_21_1, "grenade_exp", DialogueSettings.grabbed_broadcast_range, "hit", num_4, "grenade_owner", ScriptUnit.extension(arg_21_1, "dialogue_system").context.player_profile)
		end

		if num_4 > 0 then
			table.sort(var_21_74, function (arg_22_0, arg_22_1)
				-- function 22
				local var_22_0 = unit(arg_22_0)
				local var_22_1 = unit(arg_22_1)
				local var_22_2 = POSITION_LOOKUP[var_22_0]

				var_22_2 = var_22_2 or local_position(var_22_0, 0)

				local var_22_3 = POSITION_LOOKUP[var_22_1]

				var_22_3 = var_22_3 or local_position(var_22_1, 0)

				return distance_squared(arg_21_2, var_22_2) < distance_squared(arg_21_2, var_22_3)
			end)
		end

		local side = Managers.state.side
		local system = Managers.state.entity:system("area_damage_system")
		local num_7 = 0
		local hit_sound_event_cap = explosion.hit_sound_event_cap

		hit_sound_event_cap = hit_sound_event_cap or num_4

		local ignore_players = explosion.ignore_players
		local num_8 = 0

		for k = 1, num_4 do
			local var_21_105 = var_21_74[k]
			local var_21_106 = unit(var_21_105)
			local var_21_107 = BLACKBOARDS[var_21_106]
			local flag_13 = not var_21_107 and var_21_107.breed
			local flag_14 = not flag_13 and flag_13.is_player
			local flag_15 = not flag_13 and not flag_14
			local is_ally = side:is_ally(arg_21_1, var_21_106)
			local flag_16 = not is_ally and flag_8

			if not flag_14 then
				if not ignore_players then
					flag_16 = false
				elseif is_ally or not flag_16 then
					local has_extension_3 = ScriptUnit.has_extension(var_21_106, "ghost_mode_system")

					flag_16 = not has_extension_3 and not has_extension_3:is_in_ghost_mode()
				end
			elseif not flag_7 and not flag_15 and not is_ally then
				flag_16 = false
			end

			if not flag_16 then
				local calculate_aoe_size, var_21_115 = DamageUtils.calculate_aoe_size(var_21_106, flag_13)
				local var_21_116 = POSITION_LOOKUP[var_21_106]

				var_21_116 = var_21_116 or local_position(var_21_106, 0)

				local num_9 = var_21_116 + Vector3(0, 0, math.max(var_21_115 - calculate_aoe_size * 0.5, var_21_115 * 0.5))
				local num_10 = var_21_116 + Vector3(0, 0, math.min(calculate_aoe_size * 0.5, var_21_115 * 0.5))
				local num_11 = Geometry.closest_point_on_line(arg_21_2, num_10, num_9) - arg_21_2
				local max = math.max(Vector3.length(num_11) - calculate_aoe_size, 0)
				local normalize_4 = Vector3.normalize(num_11)
				local flag_17 = var_21_37 < max
				local var_21_123

				if not var_21_52 and not var_21_53 then
					var_21_123 = math.lerp(var_21_52, var_21_53, arg_21_5)
				end

				local num_12 = 1

				if var_21_37 < max then
					local num_13 = radius - var_21_37

					if num_13 > 0 then
						num_12 = 1 - (max - var_21_37) / num_13

						if not exponential_falloff then
							num_12 = num_12 * num_12
						end
					end
				end

				if not wind_mutator and not different_power_levels_for_players then
					if not flag_13 and not flag_13.is_hero then
						var_21_51 = var_21_54
						power_level_glance = var_21_54
					else
						var_21_51 = var_21_55
						power_level_glance = var_21_55
					end
				end

				local num_14 = (not flag_17 and power_level_glance and var_21_123 or var_21_51 and 0) * num_12

				player_push_speed = not player_push_speed and math.auto_lerp(var_21_37, radius, player_push_speed, 1, math.clamp(max, var_21_37, radius))

				if not HEALTH_ALIVE[var_21_106] then
					num_7 = num_7 + 1
				end

				local attack_is_shield_blocked = AiUtils.attack_is_shield_blocked(var_21_106, arg_21_1)
				local aoe_hit_zone = DamageUtils.aoe_hit_zone(var_21_106, var_21_105)

				if not script_data.debug_projectiles then
					QuickDrawerStay:vector(arg_21_2, num_11, Colors.get("brown"))
				end

				local flag_18 = false

				system:add_aoe_damage_target(var_21_106, arg_21_1, arg_21_2, attack_is_shield_blocked, flag_6, aoe_hit_zone, arg_21_6, max, player_push_speed, radius, var_21_37, radius_min, radius_max, var_21_51, num_14, normalize_4, arg_21_4.name, arg_21_11, flag_18, arg_21_12, num_7)

				if not explosion.buff_to_apply and not DamageUtils.is_player_unit(var_21_106) then
					if not explosion.only_facing then
						Managers.state.entity:system("buff_system"):add_buff(var_21_106, explosion.buff_to_apply, var_21_106, false)
					else
						local local_position_3 = Unit.local_position(arg_21_1, 0)
						local var_21_131 = POSITION_LOOKUP[var_21_106]

						var_21_131 = var_21_131 or Unit.local_position(var_21_106, 0)

						local local_rotation_2 = Unit.local_rotation(var_21_106, 0)
						local to_euler_angles_xyz_2, var_21_134, var_21_135 = Quaternion.to_euler_angles_xyz(local_rotation_2)
						local num_15 = var_21_135 - math.radians_to_degrees(math.angle(local_position_3.x, local_position_3.y, var_21_131.x, var_21_131.y))

						if num_15 < 0 then
							num_15 = num_15 + 360
						end

						if math.abs(90 - num_15) < 90 then
							Managers.state.entity:system("buff_system"):add_buff(var_21_106, explosion.buff_to_apply, var_21_106, false)
						end
					end
				elseif not explosion.enemy_debuff and not DamageUtils.is_enemy(arg_21_1, var_21_106) then
					local system_2 = Managers.state.entity:system("buff_system")
					local enemy_debuff = explosion.enemy_debuff

					for k_2, v in pairs(enemy_debuff) do
						system_2:add_buff(var_21_106, v, var_21_106, false)
					end
				end

				if not explosion.server_hit_func then
					explosion.server_hit_func(var_21_106, arg_21_6, arg_21_1, arg_21_2, explosion)
				end

				if not (not explosion.hit_sound_event and not (num_8 < hit_sound_event_cap)) then
					Managers.state.entity:system("audio_system"):play_audio_unit_event(explosion.hit_sound_event, var_21_106)

					num_8 = num_8 + 1
				end

				if not explosion.catapult_players and not DamageUtils.is_player_unit(var_21_106) then
					local owner_2 = Managers.player:owner(var_21_106)

					owner_2 = not owner_2 and not Managers.player:owner(var_21_106):is_player_controlled()

					local bot_knockback_immunity

					if not owner_2 then
						bot_knockback_immunity = explosion.bot_knockback_immunity

						if not bot_knockback_immunity then
							-- Nothing
						end
					end

					bot_knockback_immunity = false

					::label_21_1::

					if not bot_knockback_immunity then
						local catapult_force = explosion.catapult_force
						local catapult_force_z = explosion.catapult_force_z
						local catapult_blocked_multiplier = explosion.catapult_blocked_multiplier

						if not catapult_blocked_multiplier then
							local flag_19 = not DamageUtils.check_block(arg_21_1, var_21_106, explosion.fatigue_type) and catapult_blocked_multiplier and 1

							catapult_force = catapult_force * flag_19
							catapult_force_z = catapult_force_z * flag_19
						end

						local num_16 = catapult_force * Vector3.normalize(num_11)

						if not catapult_force_z then
							Vector3.set_z(num_16, catapult_force_z)
						end

						StatusUtils.set_catapulted_network(var_21_106, true, num_16)
					end
				end
			end
		end
	end
end

local tbl_7 = {}

DamageUtils.create_taunt = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local taunt = arg_23_4.taunt
	local broadphase_query = AiUtils.broadphase_query(arg_23_3, taunt.target_selection_range, tbl_7)
	local num = -math.huge
	local var_23_3

	if broadphase_query > 1 then
		for i = 1, broadphase_query do
			local var_23_4 = tbl_7[i]
			local current_health = ScriptUnit.extension(var_23_4, "health_system"):current_health()

			if num < current_health then
				var_23_3 = var_23_4
				num = current_health
			end
		end
	end

	local tbl = {
		health_system = {
			attached_unit = var_23_3,
			duration = taunt.duration
		},
		death_system = {
			death_reaction_template = "lure_unit"
		}
	}
	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "lure_unit", tbl, arg_23_3)

	if not var_23_3 then
		World.link_unit(arg_23_0, spawn_network_unit, var_23_3)
	end

	local time = Managers.time:time("game")
	local num_2 = time + taunt.duration
	local broadphase_query_2 = AiUtils.broadphase_query(arg_23_3, taunt.range, tbl_7)

	for j = 1, broadphase_query_2 do
		local var_23_12 = tbl_7[j]

		if var_23_12 ~= var_23_3 then
			local extension = ScriptUnit.extension(var_23_12, "ai_system")
			local blackboard = extension:blackboard()

			if not extension:breed().ignore_taunts then
				blackboard.taunt_unit = spawn_network_unit
				blackboard.taunt_end_time = num_2
				blackboard.target_unit = spawn_network_unit
				blackboard.target_unit_found_time = time
			end
		end
	end

	return spawn_network_unit
end

DamageUtils.create_aoe = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	local aoe = arg_24_4.aoe

	arg_24_5 = arg_24_5 or aoe.radius
	arg_24_6 = arg_24_6 or aoe.duration
	arg_24_1 = AiUtils.get_actual_attacker_unit(arg_24_1)

	local is_grenade = arg_24_4.is_grenade
	local has_extension = ScriptUnit.has_extension(arg_24_1, "buff_system")

	if not has_extension then
		local num = 1

		if not is_grenade then
			num = num + (has_extension:apply_buffs_to_value(1, "grenade_radius") - 1)
		end

		arg_24_5 = arg_24_5 * (num + (has_extension:apply_buffs_to_value(1, "explosion_radius") - 1))
	end

	local owner = Managers.player:owner(arg_24_1)
	local flag = true
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	if not (owner == nil or current_mechanism_name == "versus") then
		local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
		local no_friendly_fire = aoe.no_friendly_fire
		local allow_friendly_fire_ranged = DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, owner)

		flag = aoe.allow_friendly_fire or not allow_friendly_fire_ranged or not no_friendly_fire
	end

	local tbl = {}
	local tbl_2 = {
		invisible_unit = true,
		aoe_dot_damage = 0,
		aoe_dot_damage_interval = aoe.damage_interval,
		radius = arg_24_5,
		life_time = arg_24_6,
		damage_players = flag,
		player_screen_effect_name = aoe.player_screen_effect_name,
		dot_effect_name = aoe.effect_name,
		extra_dot_effect_name = aoe.extra_effect_name,
		nav_mesh_effect = aoe.nav_mesh_effect
	}
	local area_damage_template = aoe.area_damage_template

	area_damage_template = area_damage_template or "explosion_template_aoe"
	tbl_2.area_damage_template = area_damage_template
	tbl_2.damage_source = arg_24_3
	tbl_2.create_nav_tag_volume = aoe.create_nav_tag_volume
	tbl_2.nav_tag_volume_layer = aoe.nav_tag_volume_layer
	tbl_2.explosion_template_name = arg_24_4.name
	tbl_2.owner_player = owner
	tbl_2.source_attacker_unit = arg_24_1
	tbl.area_damage_system = tbl_2

	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "aoe_unit", tbl, arg_24_2)
	local go_id = Managers.state.unit_storage:go_id(spawn_network_unit)

	Unit.set_unit_visibility(spawn_network_unit, false)
	Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", go_id, arg_24_2)

	return spawn_network_unit
end

DamageUtils.networkify_damage = function (arg_25_0)
	-- function 25
	local damage = NetworkConstants.damage

	arg_25_0 = math.clamp(arg_25_0, damage.min, damage.max)

	local num = arg_25_0 % 1
	local num_2 = math.round(num * 4) * 0.25

	return math.floor(arg_25_0) + num_2
end

DamageUtils.networkify_health = function (arg_26_0)
	-- function 26
	local health = NetworkConstants.health

	arg_26_0 = math.clamp(arg_26_0, health.min, health.max)

	local num = arg_26_0 % 1
	local num_2 = math.round(num * 4) * 0.25

	return math.floor(arg_26_0) + num_2
end

DamageUtils.create_hit_zone_lookup = function (arg_27_0, arg_27_1)
	-- function 27
	local hit_zones = arg_27_1.hit_zones
	local tbl = {}
	local name = arg_27_1.name

	if not name then
		table.dump(arg_27_1, "breed", 2)
		error("breed.name was nil in DamageUtils.create_hit_zone_lookup")
	end

	for k, v in pairs(hit_zones) do
		for i, v_2 in ipairs(v.actors) do
			local var_27_3 = actor(arg_27_0, v_2)

			if not var_27_3 then
				printf("Actor %s not found in %s", v_2, name)
			end

			local var_27_4 = node(var_27_3)

			tbl[var_27_4] = {
				name = k,
				prio = v.prio,
				actor_name = v_2
			}
			tbl[k] = var_27_4
			tbl[name] = true
		end
	end

	arg_27_1.hit_zones_lookup = tbl
	BreedHitZonesLookup[name] = tbl
end

DamageUtils.vs_register_dark_pact_player_damage = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	-- function 28
	local owner = arg_28_4:owner(arg_28_0)
	local owner_2 = arg_28_4:owner(arg_28_1)

	if not owner and not owner_2 then
		local versus_is_dark_pact = Managers.state.side:versus_is_dark_pact(arg_28_0)

		versus_is_dark_pact = versus_is_dark_pact or Managers.state.side:versus_is_dark_pact(arg_28_5)

		local has_extension = ScriptUnit.has_extension(arg_28_1, "status_system")
		local is_ledge_hanging = has_extension.is_ledge_hanging

		is_ledge_hanging = is_ledge_hanging or has_extension.knocked_down

		if not arg_28_0 and not versus_is_dark_pact then
			Managers.state.entity:system("versus_horde_ability_system"):server_ability_recharge_boost(owner.peer_id, nil, arg_28_2, arg_28_3, is_ledge_hanging, arg_28_6)
		end
	end
end

DamageUtils.add_damage_network = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9, arg_29_10, arg_29_11, arg_29_12, arg_29_13, arg_29_14, arg_29_15, arg_29_16, arg_29_17, arg_29_18)
	-- function 29
	local network = Managers.state.network

	if not network:game() then
		return 0
	end

	local var_29_1 = Managers.state.side.side_by_unit[arg_29_0]

	if not DamageUtils.is_in_inn and not var_29_1 and not var_29_1.VALID_ENEMY_PLAYERS_AND_BOTS[arg_29_0] then
		return 0
	end

	local player = Managers.player
	local is_server = player.is_server

	if not fn(arg_29_0, arg_29_4, arg_29_7, arg_29_10) then
		if is_server or not LEVEL_EDITOR_TEST then
			Managers.state.achievement:trigger_event("register_damage_resisted_immune", arg_29_0, arg_29_1, arg_29_4)
		end

		return 0
	end

	if not (not is_server and Managers.mechanism:current_mechanism_name() ~= "versus") then
		DamageUtils.vs_register_dark_pact_player_damage(arg_29_1, arg_29_0, arg_29_7, arg_29_4, player, arg_29_9)
	end

	local alloc_table = FrameTable.alloc_table()

	if is_server or not LEVEL_EDITOR_TEST then
		local mechanism_try_call, var_29_6, var_29_7 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "hero_damage_taken")

		arg_29_2 = not mechanism_try_call and not var_29_7 and not (not var_29_1 and var_29_1:name() == "heroes") and arg_29_2 * var_29_6 and arg_29_2

		local unit_breed = AiUtils.unit_breed(arg_29_1)

		if not unit_breed and not unit_breed.is_hero then
			arg_29_2 = DamageUtils.networkify_damage(arg_29_2)
		end

		arg_29_2 = DamageUtils.apply_buffs_to_damage(arg_29_2, arg_29_0, arg_29_1, arg_29_7, alloc_table, arg_29_4, arg_29_10, arg_29_14, arg_29_9)
	end

	local networkify_damage = DamageUtils.networkify_damage(arg_29_2)

	arg_29_5 = arg_29_5 or Unit.world_position(arg_29_0, 0)
	arg_29_5 = NetworkUtils.network_clamp_position(arg_29_5)

	if not HEALTH_ALIVE[arg_29_0] then
		local has_extension = ScriptUnit.has_extension(arg_29_1, "buff_system")

		if not (not has_extension and arg_29_17) then
			local alloc_table_2 = FrameTable.alloc_table()

			alloc_table_2.damage_amount = networkify_damage

			has_extension:trigger_procs("on_damage_dealt", arg_29_0, arg_29_1, networkify_damage, arg_29_3, 0, arg_29_12, arg_29_10, 100, arg_29_7, arg_29_4, arg_29_14, alloc_table_2)

			networkify_damage = alloc_table_2.damage_amount
		end

		Managers.state.achievement:trigger_event("on_damage_dealt", arg_29_0, arg_29_1, networkify_damage, arg_29_3, 0, arg_29_12, arg_29_10, 100, arg_29_7, arg_29_4, arg_29_14)
	end

	Managers.state.game_mode:game_mode():projectile_hit_character(nil, arg_29_9, arg_29_1, arg_29_0, arg_29_5, nil, arg_29_6, networkify_damage)

	if is_server or not LEVEL_EDITOR_TEST then
		local count = #alloc_table
		local time = Managers.time:time("game")

		for i = 1, count do
			local var_29_14 = alloc_table[i]

			arg_29_4 = var_29_14 ~= arg_29_0 or not arg_29_4 or "buff"

			ScriptUnit.extension(var_29_14, "health_system"):add_damage(arg_29_1, networkify_damage, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9, arg_29_11, arg_29_12, arg_29_13, arg_29_14, arg_29_15, arg_29_10, arg_29_16, arg_29_18)

			if not HEALTH_ALIVE[var_29_14] then
				Managers.state.unit_spawner:prioritize_death_watch_unit(arg_29_0, time)
			end
		end
	else
		local game_object_or_level_id, var_29_16 = network:game_object_or_level_id(arg_29_0)
		local game_object_or_level_id_2, var_29_18 = network:game_object_or_level_id(arg_29_1)
		local unit_game_object_id = network:unit_game_object_id(arg_29_9)

		unit_game_object_id = unit_game_object_id or NetworkConstants.invalid_game_object_id

		local var_29_20 = NetworkLookup.hit_zones[arg_29_3]
		local var_29_21 = NetworkLookup.damage_types[arg_29_4]
		local var_29_22 = NetworkLookup.damage_sources[arg_29_7 or "n/a"]
		local var_29_23 = NetworkLookup.hit_react_types[arg_29_11 or "light"]

		arg_29_12 = arg_29_12 or false
		arg_29_13 = arg_29_13 or false
		arg_29_14 = arg_29_14 or false
		arg_29_15 = arg_29_15 or 0
		arg_29_16 = arg_29_16 or 1
		arg_29_18 = arg_29_18 or 1

		network.network_transmit:send_rpc_server("rpc_add_damage_network", game_object_or_level_id, var_29_16, game_object_or_level_id_2, var_29_18, unit_game_object_id, networkify_damage, var_29_20, var_29_21, arg_29_5, arg_29_6, var_29_22, var_29_23, arg_29_12, arg_29_13, arg_29_14, arg_29_15, arg_29_16, arg_29_18)
	end

	return networkify_damage
end

DamageUtils.get_damage_type = function (self, arg_30_1)
	-- function 30
	local var_30_0

	if not self.targets then
		var_30_0 = self.targets[arg_30_1]

		if not var_30_0 then
			-- Nothing
		end
	end

	var_30_0 = self.default_target

	::label_30_0::

	local attack_template = var_30_0.attack_template
	local get_attack_template = DamageUtils.get_attack_template(attack_template)
	local damage_type = var_30_0.damage_type

	if not damage_type then
		damage_type = self.damage_type
		damage_type = damage_type or get_attack_template.damage_type
	end

	return damage_type
end

DamageUtils.add_damage_network_player = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10, arg_31_11, arg_31_12, arg_31_13, arg_31_14, arg_31_15, arg_31_16)
	-- function 31
	if not Managers.state.network:game() then
		return 0
	end

	local var_31_0 = Managers.state.side.side_by_unit[arg_31_3]

	if not DamageUtils.is_in_inn and not var_31_0 and not var_31_0.VALID_ENEMY_PLAYERS_AND_BOTS[arg_31_3] then
		return 0
	end

	local player = Managers.player
	local owner = player:owner(arg_31_4)

	if not (not owner and not owner.bot_player and DamageUtils.can_bots_damage(arg_31_3)) then
		return 0
	end

	if (Managers.mechanism:current_mechanism_name() ~= "versus" or not arg_31_4) and not Managers.state.side:versus_is_dark_pact(arg_31_4) then
		if not DamageUtils.vs_dark_pact_can_damage(arg_31_4, arg_31_3) then
			return 0
		end

		DamageUtils.vs_register_dark_pact_player_damage(arg_31_4, arg_31_3, arg_31_8, nil, player)
	end

	local get_damage_type = DamageUtils.get_damage_type(self, arg_31_1)

	if not self.instant_death and not DamageUtils.is_ai(arg_31_3) then
		AiUtils.kill_unit(arg_31_3, arg_31_4, arg_31_5, get_damage_type, arg_31_7, arg_31_8)

		return 0
	end

	local charge_value = self.charge_value

	if not fn(arg_31_3, get_damage_type, arg_31_8, charge_value) then
		return 0
	end

	local has_extension = ScriptUnit.has_extension(arg_31_3, "ghost_mode_system")

	if not has_extension and not has_extension:is_in_ghost_mode() then
		return 0
	end

	local var_31_6

	if not self.targets then
		var_31_6 = self.targets[arg_31_1]

		if not var_31_6 then
			-- Nothing
		end
	end

	var_31_6 = self.default_target

	::label_31_0::

	local var_31_7 = BoostCurves[var_31_6.boost_curve_type]
	local calculate_damage = DamageUtils.calculate_damage(DamageOutput, arg_31_3, arg_31_4, arg_31_5, arg_31_2, var_31_7, arg_31_10, arg_31_11, self, arg_31_1, arg_31_15, arg_31_8)
	local alloc_table = FrameTable.alloc_table()
	local max = NetworkConstants.damage.max
	local apply_buffs_to_damage = DamageUtils.apply_buffs_to_damage(calculate_damage, arg_31_3, arg_31_4, arg_31_8, alloc_table, get_damage_type, charge_value, arg_31_13, arg_31_16)

	arg_31_6 = arg_31_6 or Unit.world_position(arg_31_3, 0)
	arg_31_6 = NetworkUtils.network_clamp_position(arg_31_6)

	local has_extension_2 = ScriptUnit.has_extension(arg_31_4, "buff_system")

	has_extension_2 = has_extension_2 or ScriptUnit.has_extension(arg_31_16, "buff_system")

	if not has_extension_2 and not HEALTH_ALIVE[arg_31_3] then
		local var_31_13 = rawget(ItemMasterList, arg_31_8)
		local flag = not var_31_13 and var_31_13.template
		local var_31_15 = apply_buffs_to_damage

		if not flag then
			var_31_15 = DamageUtils.calculate_damage(DamageOutput, arg_31_3, arg_31_4, "torso", arg_31_2, var_31_7, arg_31_10, false, self, arg_31_1, arg_31_15, arg_31_8)
		end

		if not self.deal_min_damage then
			apply_buffs_to_damage = math.max(apply_buffs_to_damage, 0.25)
		end

		local alloc_table_2 = FrameTable.alloc_table()

		alloc_table_2.damage_amount = apply_buffs_to_damage

		has_extension_2:trigger_procs("on_player_damage_dealt", arg_31_3, apply_buffs_to_damage, arg_31_5, var_31_15, arg_31_11, charge_value, arg_31_1, arg_31_8, arg_31_13, alloc_table_2)
		has_extension_2:trigger_procs("on_damage_dealt", arg_31_3, arg_31_4, apply_buffs_to_damage, arg_31_5, var_31_15, arg_31_11, charge_value, arg_31_1, arg_31_8, get_damage_type, arg_31_13, alloc_table_2)

		apply_buffs_to_damage = alloc_table_2.damage_amount
	end

	if player.is_server or not LEVEL_EDITOR_TEST then
		local count = #alloc_table
		local mechanism_try_call, var_31_19, var_31_20 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "hero_damage_taken")

		apply_buffs_to_damage = not mechanism_try_call and not var_31_20 and not (not var_31_0 and var_31_0:name() == "heroes") and apply_buffs_to_damage * var_31_19 and apply_buffs_to_damage

		local time = Managers.time:time("game")

		for i = 1, count do
			local var_31_22 = alloc_table[i]

			get_damage_type = var_31_22 ~= arg_31_3 or not get_damage_type or "buff"

			local extension = ScriptUnit.extension(var_31_22, "health_system")

			if max < apply_buffs_to_damage then
				local floor = math.floor(apply_buffs_to_damage / max)

				for j = 1, floor do
					extension:add_damage(arg_31_4, max, arg_31_5, get_damage_type, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_16, nil, arg_31_11, arg_31_12, arg_31_13, arg_31_14, charge_value, arg_31_15, arg_31_1)
				end

				apply_buffs_to_damage = apply_buffs_to_damage - max * floor
			end

			local networkify_damage = DamageUtils.networkify_damage(apply_buffs_to_damage)

			extension:add_damage(arg_31_4, networkify_damage, arg_31_5, get_damage_type, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_16, nil, arg_31_11, arg_31_12, arg_31_13, arg_31_14, charge_value, arg_31_15, arg_31_1)

			if not HEALTH_ALIVE[var_31_22] then
				Managers.state.unit_spawner:prioritize_death_watch_unit(arg_31_3, time)
			end
		end
	end

	return apply_buffs_to_damage
end

local num_2 = 0.1
local tbl_8 = {
	"headshot",
	"weakspot"
}

DamageUtils.handle_hit_indication = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	-- function 32
	local has_extension = ScriptUnit.has_extension(arg_32_0, "hud_system")

	if not (not has_extension and not HEALTH_ALIVE[arg_32_1] and arg_32_0 == arg_32_1) then
		local hit_marker_data = has_extension.hit_marker_data
		local time = Managers.time:time("game")
		local num = 1

		if not hit_marker_data.hit_marker_timestamp then
			num = time - hit_marker_data.hit_marker_timestamp
		end

		if num > num_2 then
			local unit_breed = AiUtils.unit_breed(arg_32_1)
			local var_32_5 = get_data(arg_32_1, "armor")
			local get_target_armor, var_32_7, var_32_8, var_32_9 = ActionUtils.get_target_armor(arg_32_3, unit_breed, var_32_5)
			local flag = not DamageUtils.is_character(arg_32_1) and not DamageUtils.is_enemy(arg_32_0, arg_32_1)
			local get_breed_damage_multiplier_type = DamageUtils.get_breed_damage_multiplier_type(unit_breed, arg_32_3)
			local contains = table.contains(tbl_8, get_breed_damage_multiplier_type)
			local flag_2 = not unit_breed and unit_breed.armored_on_no_damage

			hit_marker_data.shield_break = arg_32_6
			hit_marker_data.shield_open = false
			hit_marker_data.hit_enemy = true
			hit_marker_data.friendly_fire = flag
			hit_marker_data.damage_amount = arg_32_2
			hit_marker_data.hit_zone = arg_32_3
			hit_marker_data.hit_critical = contains
			hit_marker_data.has_armor = flag_2 or var_32_8 == 6 or get_target_armor == 2 or get_target_armor == 0
			hit_marker_data.hit_marker_timestamp = time
			hit_marker_data.added_dot = arg_32_4
			hit_marker_data.invulnerable = arg_32_5
		end
	end
end

DamageUtils.get_item_buff_type = function (arg_33_0)
	-- function 33
	local var_33_0 = rawget(ItemMasterList, arg_33_0)
	local template

	if not var_33_0 then
		template = var_33_0.template

		if not template then
			-- Nothing
		end
	end

	template = var_33_0.temporary_template

	::label_33_0::

	local var_33_2

	if not template then
		var_33_2 = WeaponUtils.get_weapon_template(template).buff_type
	end

	return var_33_2 or "n/a"
end

DamageUtils.buff_on_attack = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9)
	-- function 34
	local has_extension = ScriptUnit.has_extension(arg_34_0, "buff_system")

	if not has_extension then
		return false
	end

	if not HEALTH_ALIVE[arg_34_1] then
		return false
	end

	local has_extension_2 = ScriptUnit.has_extension(arg_34_1, "buff_system")
	local is_enemy = Managers.state.side:is_enemy(arg_34_0, arg_34_1)

	if not is_enemy then
		if not RangedAttackTypes[arg_34_2] then
			has_extension:trigger_procs("on_ranged_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)

			if not has_extension_2 then
				has_extension_2:trigger_procs("on_hit_by_ranged", arg_34_0, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)
			end
		else
			has_extension:trigger_procs("on_melee_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)
		end

		has_extension:trigger_procs("on_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)
		Managers.state.achievement:trigger_event("on_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8, arg_34_0, arg_34_9)
		Managers.state.event:trigger("on_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8, arg_34_0)

		if not has_extension_2 then
			has_extension_2:trigger_procs("on_hit_by_other", arg_34_0, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)
		end
	end

	if not arg_34_3 and not is_enemy then
		has_extension:trigger_procs("on_critical_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7)
	end

	if not (not arg_34_6 and Managers.player.is_server) then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_34_0)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_34_1)
		local var_34_6 = NetworkLookup.buff_attack_types[arg_34_2]
		local var_34_7 = NetworkLookup.hit_zones[arg_34_4]
		local var_34_8 = NetworkLookup.buff_weapon_types[arg_34_7]
		local var_34_9 = NetworkLookup.damage_sources[arg_34_9 or "undefined"]

		if not unit_game_object_id_2 then
			network.network_transmit:send_rpc_server("rpc_buff_on_attack", unit_game_object_id, unit_game_object_id_2, var_34_6, arg_34_3, var_34_7, arg_34_5, var_34_8, var_34_9)
		end
	end

	return true
end

local tbl_9 = {
	wounded_dot = true,
	suicide = true,
	knockdown_bleed = true
}
local tbl_10 = {
	temporary_health_degen = true,
	overcharge = true,
	life_tap = true,
	ground_impact = true,
	life_drain = true
}
local tbl_11 = {
	temporary_health_degen = true,
	overcharge = true,
	life_tap = true,
	ground_impact = true,
	life_drain = true
}
local tbl_12 = {
	temporary_health_degen = true,
	suicide = true,
	life_tap = true
}

DamageUtils.apply_buffs_to_damage = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8)
	-- function 35
	local var_35_0 = arg_35_0
	local network = Managers.state.network
	local has_extension = ScriptUnit.has_extension(arg_35_2, "buff_system")

	has_extension = has_extension or ScriptUnit.has_extension(arg_35_8, "buff_system")

	if not has_extension then
		has_extension:trigger_procs("damage_calculation_started", arg_35_1)
	end

	local owner = Managers.player:owner(arg_35_1)
	local owner_2 = Managers.player:owner(arg_35_2)

	if not owner then
		var_35_0 = Managers.state.game_mode:modify_player_base_damage(arg_35_1, arg_35_2, var_35_0, arg_35_5)
	end

	arg_35_4[#arg_35_4 + 1] = arg_35_1

	local extension = ScriptUnit.extension(arg_35_1, "health_system")

	if not (not extension:has_assist_shield() and tbl_9[arg_35_3]) then
		local unit_game_object_id = network:unit_game_object_id(arg_35_1)

		network.network_transmit:send_rpc_clients("rpc_remove_assist_shield", unit_game_object_id)
	end

	if not ScriptUnit.has_extension(arg_35_1, "buff_system") then
		local extension_2 = ScriptUnit.extension(arg_35_1, "buff_system")

		if not SKAVEN[arg_35_3] then
			var_35_0 = extension_2:apply_buffs_to_value(var_35_0, "protection_skaven")
		elseif CHAOS[arg_35_3] or not BEASTMEN[arg_35_3] then
			var_35_0 = extension_2:apply_buffs_to_value(var_35_0, "protection_chaos")
		end

		if not DAMAGE_TYPES_AOE[arg_35_5] then
			var_35_0 = extension_2:apply_buffs_to_value(var_35_0, "protection_aoe")
		end

		if not tbl_12[arg_35_3] then
			var_35_0 = extension_2:apply_buffs_to_value(var_35_0, "damage_taken")

			if not ELITES[arg_35_3] then
				var_35_0 = extension_2:apply_buffs_to_value(var_35_0, "damage_taken_elites")
			end
		end

		if not RangedAttackTypes[arg_35_6] then
			var_35_0 = extension_2:apply_buffs_to_value(var_35_0, "damage_taken_ranged")
		elseif not MeleeAttackTypes[arg_35_6] then
			var_35_0 = extension_2:apply_buffs_to_value(var_35_0, "damage_taken_melee")
		end

		local flag = not owner and ScriptUnit.has_extension(arg_35_1, "status_system")

		if not flag then
			local is_knocked_down = flag:is_knocked_down()

			if not is_knocked_down then
				var_35_0 = arg_35_5 == "overcharge" or not extension_2:apply_buffs_to_value(var_35_0, "damage_taken_kd") or 0
			end

			if not (flag:is_disabled() or not not tbl_10[arg_35_3] and not (var_35_0 > 0) or is_knocked_down) then
				local var_35_10 = var_35_0
				local apply_buffs_to_value = extension_2:apply_buffs_to_value(var_35_0, "damage_taken_to_overcharge")

				if apply_buffs_to_value < var_35_10 then
					local num = var_35_10 - apply_buffs_to_value
					local apply_buffs_to_value_2 = extension_2:apply_buffs_to_value(num, "reduced_overcharge_from_passive")
					local networkify_damage = DamageUtils.networkify_damage(apply_buffs_to_value_2)

					if not owner.remote then
						local peer_id = owner.peer_id
						local unit_game_object_id_2 = network:unit_game_object_id(arg_35_1)
						local var_35_17 = PEER_ID_TO_CHANNEL[peer_id]

						RPC.rpc_damage_taken_overcharge(var_35_17, unit_game_object_id_2, networkify_damage)
					else
						DamageUtils.apply_damage_to_overcharge(arg_35_1, networkify_damage)
					end

					var_35_0 = apply_buffs_to_value
				end
			end
		end

		if not has_extension then
			if not (arg_35_6 == AttackTypes.grenade or DamageUtils.attacker_is_fire_bomb(arg_35_2)) then
				var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "explosion_damage")
			end

			local has_buff_perk = has_extension:has_buff_perk("burning")

			if not has_buff_perk then
				has_buff_perk = has_extension:has_buff_perk("burning_balefire")
				has_buff_perk = has_buff_perk or has_extension:has_buff_perk("burning_elven_magic")
			end

			if not has_buff_perk then
				local var_35_19 = Managers.state.side.side_by_unit[arg_35_1]

				if not var_35_19 then
					local PLAYER_AND_BOT_UNITS = var_35_19.PLAYER_AND_BOT_UNITS
					local count = #PLAYER_AND_BOT_UNITS

					for i = 1, count do
						local var_35_22 = PLAYER_AND_BOT_UNITS[i]
						local has_extension_2 = ScriptUnit.has_extension(var_35_22, "talent_system")

						if not has_extension_2 and not has_extension_2:has_talent("sienna_unchained_burning_enemies_reduced_damage") then
							var_35_0 = var_35_0 * (1 + BuffUtils.get_buff_template("sienna_unchained_burning_enemies_reduced_damage").buffs[1].multiplier)

							break
						end
					end
				end
			end
		end

		local get_buff_value = extension_2:get_buff_value("max_damage_taken_from_boss_or_elite")
		local get_buff_value_2 = extension_2:get_buff_value("max_damage_taken")

		if not extension_2:has_buff_perk("anti_oneshot") then
			local num_2 = extension:get_max_health() * 0.3

			if num_2 < var_35_0 then
				var_35_0 = num_2
			end
		end

		local var_35_27 = ALIVE[arg_35_2]

		var_35_27 = not var_35_27 and get_data(arg_35_2, "breed")

		if not var_35_27 and var_35_27.boss and not var_35_27.elite then
			local var_35_28

			if not get_buff_value and not get_buff_value_2 then
				var_35_28 = math.min(get_buff_value, get_buff_value_2)
			else
				var_35_28 = not get_buff_value and get_buff_value and get_buff_value_2
			end

			if not (not var_35_28 and not (var_35_28 <= var_35_0)) then
				var_35_0 = math.max(var_35_0 * 0.5, var_35_28)
			end
		elseif not (not get_buff_value_2 and not (get_buff_value_2 <= var_35_0)) then
			var_35_0 = math.max(var_35_0 * 0.5, get_buff_value_2)
		end

		if not (not extension_2:has_buff_type("shared_health_pool") and tbl_9[arg_35_3]) then
			local PLAYER_AND_BOT_UNITS_2 = Managers.state.side.side_by_unit[arg_35_1].PLAYER_AND_BOT_UNITS
			local count_2 = #PLAYER_AND_BOT_UNITS_2
			local num_3 = 1

			for j = 1, count_2 do
				local var_35_32 = PLAYER_AND_BOT_UNITS_2[j]

				if var_35_32 == arg_35_1 or not ScriptUnit.extension(var_35_32, "buff_system"):has_buff_type("shared_health_pool") then
					num_3 = num_3 + 1
					arg_35_4[#arg_35_4 + 1] = var_35_32
				end
			end

			var_35_0 = var_35_0 / num_3
		end

		local has_extension_3 = ScriptUnit.has_extension(arg_35_1, "talent_system")

		if not (not has_extension_3 and not has_extension_3:has_talent("bardin_ranger_reduced_damage_taken_headshot") and not POSITION_LOOKUP[arg_35_2] and not AiUtils.unit_is_flanking_player(arg_35_2, arg_35_1) and extension_2:has_buff_type("bardin_ranger_reduced_damage_taken_headshot_buff")) then
			var_35_0 = var_35_0 * (1 + BuffUtils.get_buff_template("bardin_ranger_reduced_damage_taken_headshot_buff").buffs[1].multiplier)
		end

		local has_buff_perk_2 = extension_2:has_buff_perk("invulnerable")
		local has_buff_type = extension_2:has_buff_type("bardin_ironbreaker_gromril_armour")
		local has_buff_type_2 = extension_2:has_buff_type("metal_mutator_gromril_armour")
		local flag_2 = not tbl_11[arg_35_3]
		local var_35_38 = Managers.state.side.side_by_unit[arg_35_1]

		if not (not var_35_38 and var_35_38:name() ~= "dark_pact") then
			has_buff_perk_2 = has_buff_perk_2 or arg_35_3 == "ground_impact"
		end

		if has_buff_perk_2 or has_buff_type or not has_buff_type_2 or not flag_2 then
			var_35_0 = 0
		end

		if not (not has_buff_type and not flag_2 and not (arg_35_0 > 0)) then
			local id = extension_2:get_non_stacking_buff("bardin_ironbreaker_gromril_armour").id

			extension_2:remove_buff(id)
			extension_2:trigger_procs("on_gromril_armour_removed")

			local unit_game_object_id_3 = network:unit_game_object_id(arg_35_1)

			network.network_transmit:send_rpc_clients("rpc_remove_gromril_armour", unit_game_object_id_3)
		end

		if not extension_2:has_buff_type("invincibility_standard") then
			local get_non_stacking_buff = extension_2:get_non_stacking_buff("invincibility_standard")

			if not get_non_stacking_buff.applied_damage then
				get_non_stacking_buff.stored_damage = get_non_stacking_buff.stored_damage or not var_35_0 or get_non_stacking_buff.stored_damage + var_35_0
				var_35_0 = 0
			end
		end
	end

	if not has_extension then
		local has_extension_4 = ScriptUnit.has_extension(arg_35_1, "buff_system")

		if not owner_2 then
			local var_35_43 = rawget(ItemMasterList, arg_35_3)
			local flag_3 = not var_35_43 and var_35_43.template

			if not flag_3 then
				local get_weapon_template = WeaponUtils.get_weapon_template(flag_3)
				local buff_type = get_weapon_template.buff_type

				if not buff_type then
					var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_weapon_damage")

					if not has_extension:has_buff_perk("missing_health_damage") then
						var_35_0 = var_35_0 * (1 + (1 - ScriptUnit.extension(arg_35_1, "health_system"):current_health_percent()) / 2)
					end
				end

				local var_35_47 = MeleeBuffTypes[buff_type]
				local var_35_48 = RangedBuffTypes[buff_type]

				if not var_35_47 then
					var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_weapon_damage_melee")

					if buff_type == "MELEE_1H" then
						var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_weapon_damage_melee_1h")
					elseif buff_type == "MELEE_2H" then
						var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_weapon_damage_melee_2h")
					end

					if arg_35_6 == "heavy_attack" then
						var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_weapon_damage_heavy_attack")
					end

					if not arg_35_7 then
						var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "first_melee_hit_damage")
					end
				elseif not var_35_48 then
					var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_weapon_damage_ranged")

					local extension_3 = ScriptUnit.extension(arg_35_1, "health_system")

					if not (extension_3:current_health_percent() <= 0.9 or not (extension_3:current_max_health_percent() <= 0.9)) then
						var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_weapon_damage_ranged_to_wounded")
					end
				end

				local weapon_type = get_weapon_template.weapon_type

				if not weapon_type then
					local damage = WeaponSpecificStatBuffs[weapon_type].damage

					var_35_0 = has_extension:apply_buffs_to_value(var_35_0, damage)
				end

				if var_35_47 or not var_35_48 then
					var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "reduced_non_burn_damage")
				end
			end

			if not has_extension_4 then
				local has_buff_perk_3 = has_extension_4:has_buff_perk("poisoned")

				has_buff_perk_3 = has_buff_perk_3 or has_extension_4:has_buff_perk("bleeding")

				if not has_buff_perk_3 then
					var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_weapon_damage_poisoned_or_bleeding")
				end
			end

			if arg_35_5 == "burninating" then
				var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_burn_dot_damage")
			end
		end

		var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "damage_dealt")

		local has_status, var_35_54 = Managers.state.status_effect:has_status(arg_35_1, StatusEffectNames.burning_balefire)

		if not (not has_status and var_35_54) then
			var_35_0 = has_extension:apply_buffs_to_value(var_35_0, "increased_damage_to_balefire")
		end
	end

	Managers.state.game_mode:damage_taken(arg_35_1, arg_35_2, var_35_0, arg_35_3, arg_35_5)

	if not has_extension then
		has_extension:trigger_procs("damage_calculation_ended", arg_35_1)
	end

	return var_35_0
end

DamageUtils.apply_damage_to_overcharge = function (arg_36_0, arg_36_1)
	-- function 36
	local has_extension = ScriptUnit.has_extension(arg_36_0, "overcharge_system")

	if not has_extension then
		has_extension:add_charge(arg_36_1, nil, "damage_to_overcharge")
	end
end

DamageUtils.assist_shield_network = function (arg_37_0, arg_37_1, arg_37_2)
	-- function 37
	local assert = assert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	assert(is_server)
	ScriptUnit.extension(arg_37_0, "health_system"):shield(arg_37_2)
	ScriptUnit.extension(arg_37_0, "status_system"):set_shielded(true)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_37_0)
		local game_object_or_level_id, var_37_5 = network:game_object_or_level_id(arg_37_1)
		local shield_by_assist = NetworkLookup.heal_types.shield_by_assist

		network.network_transmit:send_rpc_clients("rpc_heal", unit_game_object_id, false, game_object_or_level_id, var_37_5, arg_37_2, shield_by_assist)
	end
end

local tbl_13 = {}

DamageUtils.heal_network = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Only server can heal")

	local has_extension = ScriptUnit.has_extension(arg_38_0, "buff_system")

	if not has_extension and not has_extension:has_buff_perk("healing_immune") then
		return
	end

	table.clear(tbl_13)

	local apply_buffs_to_heal, var_38_4 = DamageUtils.apply_buffs_to_heal(arg_38_0, arg_38_1, arg_38_2, arg_38_3, tbl_13)
	local networkify_damage = DamageUtils.networkify_damage(apply_buffs_to_heal)

	if not ((arg_38_0 ~= arg_38_1 or not (arg_38_3 == "healing_draught" or arg_38_3 == "healing_draught_temp_health")) and not (ScriptUnit.extension(arg_38_0, "health_system"):current_permanent_health() > 80)) then
		local player_profile = ScriptUnit.extension(arg_38_0, "dialogue_system").context.player_profile

		SurroundingAwareSystem.add_event(arg_38_0, "early_healing_draught", DialogueSettings.default_view_distance, "target_name", player_profile)
	end

	if networkify_damage > 0 then
		if arg_38_0 ~= arg_38_1 then
			ScriptUnit.extension(arg_38_1, "buff_system"):trigger_procs("on_healed_ally", arg_38_0, networkify_damage, arg_38_3)
		end

		local count = #tbl_13

		for i = 1, count do
			local var_38_8 = tbl_13[i]

			arg_38_3 = not var_38_4 and "buff_shared_medpack" and "buff_shared_medpack_temp_health" and var_38_8 ~= arg_38_0 or not arg_38_3 and "buff"

			ScriptUnit.extension(var_38_8, "health_system"):add_heal(arg_38_1, networkify_damage, nil, arg_38_3)

			local has_extension_2 = ScriptUnit.has_extension(var_38_8, "status_system")

			if not has_extension_2 then
				has_extension_2:healed(arg_38_3)
			end

			local extension = ScriptUnit.extension(var_38_8, "buff_system")

			extension:trigger_procs("on_healed", arg_38_1, networkify_damage, arg_38_3)

			if not (arg_38_3 == "healing_draught" or arg_38_3 == "bandage" or arg_38_3 == "healing_draught_temp_health" or arg_38_3 == "bandage_temp_health" or arg_38_3 ~= "bandage_trinket") then
				extension:trigger_procs("on_healed_consumeable", arg_38_1, networkify_damage, arg_38_3)
			end

			if (LEVEL_EDITOR_TEST or not has_extension_2) and not has_extension_2:heal_can_remove_wounded(arg_38_3) then
				StatusUtils.set_wounded_network(var_38_8, false, "healed")
			end
		end
	else
		local count_2 = #tbl_13

		for j = 1, count_2 do
			local var_38_12 = tbl_13[j]
			local has_extension_3 = ScriptUnit.has_extension(var_38_12, "status_system")

			if (LEVEL_EDITOR_TEST or not has_extension_3) and not has_extension_3:is_wounded() and not has_extension_3:heal_can_remove_wounded(arg_38_3) then
				StatusUtils.set_wounded_network(var_38_12, false, "healed")
			end
		end
	end
end

DamageUtils.apply_buffs_to_heal = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	-- function 39
	local flag = false

	arg_39_4[#arg_39_4 + 1] = arg_39_0

	if not ScriptUnit.has_extension(arg_39_0, "buff_system") then
		local extension = ScriptUnit.extension(arg_39_0, "buff_system")

		if not (arg_39_3 == "raw_heal" or arg_39_3 == "health_conversion") then
			arg_39_2 = extension:apply_buffs_to_value(arg_39_2, "healing_received")
		end

		if not extension:has_buff_type("shared_health_pool") then
			local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_39_0].PLAYER_AND_BOT_UNITS
			local count = #PLAYER_AND_BOT_UNITS
			local num = 1

			for i = 1, count do
				local var_39_5 = PLAYER_AND_BOT_UNITS[i]

				if var_39_5 == arg_39_0 or not ScriptUnit.extension(var_39_5, "buff_system"):has_buff_type("shared_health_pool") then
					num = num + 1
					arg_39_4[#arg_39_4 + 1] = var_39_5
				end
			end

			arg_39_2 = arg_39_2 / num

			if not (arg_39_3 == "bandage" or arg_39_3 ~= "healing_draught") then
				flag = true
			end
		end
	end

	return arg_39_2, flag
end

DamageUtils.debug_heal = function (arg_40_0, arg_40_1)
	-- function 40
	if not Managers.player.is_server then
		DamageUtils.heal_network(arg_40_0, arg_40_0, arg_40_1, "debug")
	else
		local network = Managers.state.network
		local network_transmit = network.network_transmit
		local unit_game_object_id = network:unit_game_object_id(arg_40_0)
		local debug = NetworkLookup.heal_types.debug

		network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, arg_40_1, debug)
	end
end

DamageUtils.debug_deal_damage = function (arg_41_0, arg_41_1)
	-- function 41
	if not ALIVE[arg_41_0] then
		return
	end

	DamageUtils.add_damage_network(arg_41_0, arg_41_0, arg_41_1, "torso", "undefined", nil, Vector3(0, 0, 1), "debug", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
end

DamageUtils.check_distance = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local breed = arg_42_1.breed
	local var_42_1 = POSITION_LOOKUP[arg_42_2]
	local var_42_2 = POSITION_LOOKUP[arg_42_3]

	var_42_2 = var_42_2 or Unit.world_position(arg_42_3, 0)

	if not var_42_2 then
		return false
	end

	local num = var_42_2 - var_42_1
	local has_extension = ScriptUnit.has_extension(arg_42_3, "ai_system")
	local is_player = arg_42_1.is_player

	is_player = not is_player and not has_extension

	local has_extension_2 = ScriptUnit.has_extension(arg_42_3, "status_system")
	local breed_action

	if not is_player and not has_extension_2 then
		breed_action = has_extension_2:breed_action()

		if not breed_action then
			-- Nothing
		end
	end

	breed_action = arg_42_1.action

	::label_42_0::

	local num_2 = 1

	if arg_42_1.target_dodged_during_attack or arg_42_1.set_dodge_rotation_timer or not arg_42_1.locked_attack_rotation then
		local player_dodged_radius = breed_action.player_dodged_radius

		if not player_dodged_radius then
			player_dodged_radius = breed.player_dodged_radius
			player_dodged_radius = player_dodged_radius or 0.75
		end

		num_2 = num_2 * player_dodged_radius
	end

	if not self.use_box_range then
		local x = num.x
		local y = num.y
		local z = num.z
		local num_3 = arg_42_1.attack_range_flat + num_2

		if not (not (z < arg_42_1.attack_range_up) or not (z > arg_42_1.attack_range_down) or not (x * x + y * y < num_3 * num_3)) then
			return true
		end
	else
		local length = Vector3.length(num)
		local weapon_reach = breed_action.weapon_reach

		if not weapon_reach then
			weapon_reach = breed.weapon_reach
			weapon_reach = weapon_reach or breed.radius
		end

		if length <= weapon_reach + num_2 then
			return true
		end
	end

	return false
end

DamageUtils.check_infront = function (arg_43_0, arg_43_1)
	-- function 43
	local var_43_0 = POSITION_LOOKUP[arg_43_0]
	local var_43_1 = POSITION_LOOKUP[arg_43_1]

	var_43_1 = var_43_1 or Unit.world_position(arg_43_1, 0)

	if not (not var_43_1 and var_43_0) then
		return false
	end

	local flat = Vector3.flat(var_43_1 - var_43_0)
	local var_43_3 = local_rotation(arg_43_0, 0)
	local forward = Quaternion.forward(var_43_3)
	local dot = Vector3.dot(Vector3.normalize(flat), forward)
	local var_43_6 = BLACKBOARDS[arg_43_0]
	local breed = var_43_6.breed
	local has_extension = ScriptUnit.has_extension(arg_43_1, "ai_system")
	local has_extension_2 = ScriptUnit.has_extension(arg_43_1, "status_system")
	local is_player = var_43_6.is_player

	is_player = not is_player and not has_extension

	local breed_action

	if not is_player then
		breed_action = has_extension_2:breed_action()

		if not breed_action then
			-- Nothing
		end
	end

	breed_action = var_43_6.action

	::label_43_0::

	local num = 0.866

	if var_43_6.target_dodged_during_attack or var_43_6.set_dodge_rotation_timer or not var_43_6.locked_attack_rotation then
		num = breed_action.player_dodged_cone or breed.player_dodged_cone or 0.95
	end

	local weapon_reach_cone = breed.weapon_reach_cone

	weapon_reach_cone = weapon_reach_cone or num

	if weapon_reach_cone < dot then
		return true
	end

	return false
end

DamageUtils.check_block = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	if arg_44_0 == arg_44_1 then
		return false
	end

	if type(arg_44_2) == "table" then
		arg_44_2 = Managers.state.difficulty:get_difficulty_value_from_table(arg_44_2)
	end

	local network = Managers.state.network
	local game_object_or_level_id, var_44_2 = network:game_object_or_level_id(arg_44_1)

	if not var_44_2 then
		return false
	elseif not DamageUtils.is_ai(arg_44_1) and not AiUtils.attack_is_shield_blocked(arg_44_1, arg_44_0, false, arg_44_3) then
		local var_44_3 = BLACKBOARDS[arg_44_0]
		local action = var_44_3.action

		var_44_3.blocked = not (not action and action.no_block_stagger)

		return true
	end

	local has_extension = ScriptUnit.has_extension(arg_44_1, "status_system")

	if not has_extension then
		local is_blocking = has_extension:is_blocking()
		local can_block, var_44_8, var_44_9, var_44_10 = has_extension:can_block(arg_44_0, arg_44_3)
		local has_extension_2 = ScriptUnit.has_extension(arg_44_1, "buff_system")
		local flag = not has_extension_2 and has_extension_2:has_buff_perk("invulnerable")

		if not (not is_blocking and not can_block and flag) then
			local has_extension_3 = ScriptUnit.has_extension(arg_44_0, "buff_system")

			if not Managers.player.is_server and not has_extension_3 and not has_extension_3:has_buff_perk("ai_unblockable") then
				BLACKBOARDS[arg_44_0].hit_through_block = true

				return false
			end

			has_extension:blocked_attack(arg_44_2, arg_44_0, var_44_8, var_44_9, var_44_10)

			if LEVEL_EDITOR_TEST or not Managers.player.is_server then
				local go_id = Managers.state.unit_storage:go_id(arg_44_1)
				local var_44_15 = NetworkLookup.fatigue_types[arg_44_2]
				local game_object_or_level_id_2, var_44_17 = network:game_object_or_level_id(arg_44_0)

				network.network_transmit:send_rpc_clients("rpc_player_blocked_attack", go_id, var_44_15, game_object_or_level_id_2, var_44_8, var_44_9, var_44_10, var_44_17)

				local var_44_18 = BLACKBOARDS[arg_44_0]
				local has_extension_4 = ScriptUnit.has_extension(arg_44_1, "ai_system")
				local is_player = var_44_18.is_player

				is_player = not is_player and not has_extension_4

				local breed_action

				if not is_player then
					breed_action = has_extension:breed_action()

					if not breed_action then
						-- Nothing
					end
				end

				breed_action = var_44_18.action

				::label_44_0::

				if not (not breed_action and breed_action.no_block_stagger and var_44_18.stagger) then
					var_44_18.blocked = true
				end
			end

			return true
		end
	end

	return false
end

DamageUtils.check_ranged_block = function (arg_45_0, arg_45_1, arg_45_2)
	-- function 45
	local extension = ScriptUnit.extension(arg_45_1, "status_system")
	local is_blocking = extension:is_blocking()
	local can_block, var_45_3, var_45_4, var_45_5 = extension:can_block(arg_45_0)
	local var_45_6
	local var_45_7

	if not arg_45_0 then
		local unit_breed = AiUtils.unit_breed(arg_45_0)

		if not unit_breed then
			var_45_7 = unit_breed.blockable_ranged_attack
		end
	end

	if not is_blocking and not can_block and not var_45_4 then
		local has_extension = ScriptUnit.has_extension(arg_45_0, "buff_system")

		if not Managers.player.is_server and not has_extension and not has_extension:has_buff_perk("ai_unblockable") then
			BLACKBOARDS[arg_45_0].hit_through_block = true

			return false
		end

		local get_wielded_slot_item_template = ScriptUnit.extension(arg_45_1, "inventory_system"):get_wielded_slot_item_template()

		if not get_wielded_slot_item_template then
			return false
		end

		if not (get_wielded_slot_item_template.can_block_ranged_attacks or var_45_7) then
			return false
		end

		extension:blocked_attack(arg_45_2, arg_45_0, var_45_3, false)

		if not LEVEL_EDITOR_TEST then
			local network = Managers.state.network
			local go_id = Managers.state.unit_storage:go_id(arg_45_1)
			local var_45_13 = NetworkLookup.fatigue_types[arg_45_2]
			local game_object_or_level_id, var_45_15 = network:game_object_or_level_id(arg_45_0)

			if not Managers.player.is_server then
				network.network_transmit:send_rpc_clients("rpc_player_blocked_attack", go_id, var_45_13, game_object_or_level_id, var_45_3, var_45_4, "back", var_45_15)
			else
				network.network_transmit:send_rpc_server("rpc_player_blocked_attack", go_id, var_45_13, game_object_or_level_id, var_45_3, var_45_4, "back", var_45_15)
			end
		end

		return true
	end

	return false
end

DamageUtils.camera_shake_by_distance = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7)
	-- function 46
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local flag = arg_46_2 or local_player.player_unit

	if not flag then
		return
	end

	local game_mode = Managers.state.game_mode

	if not (not game_mode and game_mode:get_end_reason()) then
		return
	end

	local num = 1

	if not arg_46_3 then
		local distance = Vector3.distance(local_position(arg_46_3, 0), local_position(flag, 0))

		num = 1 - math.clamp((distance - arg_46_4) / (arg_46_5 - arg_46_4), 0, 1)
		num = arg_46_7 + num * (arg_46_6 - arg_46_7)
	end

	Managers.state.camera:camera_effect_shake_event(arg_46_0, arg_46_1, num)
end

local num_3 = 1
local num_4 = 3
local num_5 = 4
local tbl_14 = {}
local tbl_15 = {}

DamageUtils.is_enemy = function (arg_47_0, arg_47_1)
	-- function 47
	local var_47_0 = Managers.state.side.side_by_unit[arg_47_0]

	return not var_47_0 and var_47_0.enemy_units_lookup[arg_47_1] ~= nil
end

DamageUtils.is_ai = function (arg_48_0)
	-- function 48
	local unit_breed = AiUtils.unit_breed(arg_48_0)

	if not unit_breed then
		return unit_breed.is_ai
	end
end

DamageUtils.is_character = function (arg_49_0)
	-- function 49
	return Unit.has_data(arg_49_0, "breed") or false
end

DamageUtils.can_bots_damage = function (arg_50_0)
	-- function 50
	local is_character, var_50_1 = DamageUtils.is_character(arg_50_0)
	local level_object_id = Managers.state.network:level_object_id(arg_50_0)
	local extension = ScriptUnit.extension(arg_50_0, "health_system")

	return is_character or level_object_id or extension.bots_can_do_damage
end

DamageUtils.vs_dark_pact_can_damage = function (arg_51_0, arg_51_1)
	-- function 51
	local is_character, var_51_1 = DamageUtils.is_character(arg_51_1)
	local level_object_id = Managers.state.network:level_object_id(arg_51_1)
	local has_extension = ScriptUnit.has_extension(arg_51_1, "props_system")

	if not has_extension then
		-- Nothing
	end

	::label_51_0::

	local owner = has_extension.owner

	owner = not owner and has_extension:owner()

	::label_51_1::

	local flag = not owner and Managers.state.side:is_enemy(arg_51_0, owner)

	return is_character or level_object_id or flag
end

DamageUtils.allow_friendly_fire_ranged = function (self, arg_52_1)
	-- function 52
	local friendly_fire_ranged = self.friendly_fire_ranged
	local mechanism_try_call, var_52_2, var_52_3 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "friendly_fire")

	if not mechanism_try_call and not var_52_3 then
		local flag = not arg_52_1 and arg_52_1.player_unit

		if not (not flag and Managers.state.side:versus_is_dark_pact(flag)) then
			friendly_fire_ranged = not not var_52_2
		end
	end

	return not friendly_fire_ranged and not arg_52_1 and not arg_52_1.bot_player
end

DamageUtils.allow_friendly_fire_melee = function (self, arg_53_1)
	-- function 53
	local friendly_fire_melee = self.friendly_fire_melee

	friendly_fire_melee = not friendly_fire_melee and not arg_53_1.bot_player

	return friendly_fire_melee
end

DamageUtils.damage_level_unit = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8, arg_54_9)
	-- function 54
	if not get_data(arg_54_0, "no_damage_from_players") then
		return
	end

	if not (Managers.mechanism:current_mechanism_name() == "versus") and not ScriptUnit.has_extension(arg_54_0, "objective_system") then
		local var_54_0 = Managers.state.side.side_by_unit[arg_54_1]

		if not (not var_54_0 and var_54_0:name() == "heroes") then
			return
		end
	end

	local var_54_1 = arg_54_6[arg_54_7]

	var_54_1 = var_54_1 or arg_54_6.default_target

	if not var_54_1 then
		return
	end

	local var_54_2 = get_data(arg_54_0, "filter_damage_source")

	if not (not var_54_2 and var_54_2 == arg_54_9) then
		return
	end

	local var_54_3 = BoostCurves[var_54_1.boost_curve_type]
	local calculate_damage = DamageUtils.calculate_damage(DamageOutput, arg_54_0, arg_54_1, arg_54_2, arg_54_3, var_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, nil, arg_54_9)
	local str = "destructible_level_object_hit"
	local var_54_6
	local var_54_7
	local var_54_8
	local var_54_9
	local var_54_10

	DamageUtils.add_damage_network(arg_54_0, arg_54_1, calculate_damage, arg_54_2, str, nil, arg_54_8, arg_54_9, var_54_6, var_54_7, var_54_8, var_54_9, arg_54_5, var_54_10, nil, nil, nil, nil, arg_54_7)
end

DamageUtils._projectile_hit_object = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8, arg_55_9, arg_55_10, arg_55_11, arg_55_12, arg_55_13, arg_55_14, arg_55_15, arg_55_16, arg_55_17, arg_55_18, arg_55_19, arg_55_20, arg_55_21, arg_55_22, arg_55_23, arg_55_24, arg_55_25, arg_55_26, arg_55_27, arg_55_28, arg_55_29)
	-- function 55
	local var_55_0 = tbl_14
	local var_55_1 = tbl_15
	local system = Managers.state.entity:system("ai_system")
	local network = Managers.state.network
	local game_object_or_level_id, var_55_5 = network:game_object_or_level_id(arg_55_5)
	local has_extension = ScriptUnit.has_extension(arg_55_5, "health_system")
	local owner = Managers.player:owner(arg_55_5)
	local str = "full"
	local var_55_9 = arg_55_29
	local flag = get_data(arg_55_5, "allow_ranged_damage") ~= false

	if not var_55_5 and (var_55_0[arg_55_5] or GameSettingsDevelopment.allow_ranged_attacks_to_damage_props) and not flag and not has_extension then
		var_55_0[arg_55_5] = true
		var_55_9 = var_55_9 + 1

		local ceil = math.ceil(var_55_9)

		DamageUtils.damage_level_unit(arg_55_5, arg_55_1, str, arg_55_17, arg_55_18, arg_55_15, arg_55_19, ceil, arg_55_24, arg_55_20)

		var_55_1.stop = true
		var_55_1.hits = arg_55_28 + 1
	elseif not ((var_55_5 or not flag or not has_extension) and owner) then
		var_55_0[arg_55_5] = true

		local unit_game_object_id = network:unit_game_object_id(arg_55_1)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_55_5)
		local var_55_14 = NetworkLookup.hit_zones[str]

		Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(arg_55_25, unit_game_object_id, unit_game_object_id_2, var_55_14, arg_55_7, arg_55_24, arg_55_26, "power_level", arg_55_17, "hit_target_index", nil, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", arg_55_18, "is_critical_strike", arg_55_15, "first_hit", arg_55_28 == 0)

		if not arg_55_15 and not arg_55_21 then
			EffectHelper.play_surface_material_effects(arg_55_21, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, nil, arg_55_10, nil, arg_55_6)
		else
			EffectHelper.play_surface_material_effects(arg_55_23, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, nil, arg_55_10, nil, arg_55_6)
		end

		if not Managers.state.network:game() then
			if not arg_55_15 and not arg_55_21 then
				EffectHelper.remote_play_surface_material_effects(arg_55_21, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, arg_55_12, arg_55_6)
			else
				EffectHelper.remote_play_surface_material_effects(arg_55_23, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, arg_55_12, arg_55_6)
			end
		end

		var_55_1.stop = true
		var_55_1.hits = arg_55_28 + 1
	else
		if not self.alert_sound_range_hit and not arg_55_1 then
			system:alert_enemies_within_range(arg_55_1, arg_55_7, self.alert_sound_range_fire)
		end

		if not ScriptUnit.has_extension(arg_55_5, "ai_inventory_item_system") then
			local owner_2 = Managers.player:owner(arg_55_5)

			if not (owner_2 == nil or owner_2.player_unit ~= nil) then
				if not arg_55_15 and not arg_55_21 then
					EffectHelper.play_surface_material_effects(arg_55_21, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, nil, arg_55_10, nil, arg_55_6)
				else
					EffectHelper.play_surface_material_effects(arg_55_23, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, nil, arg_55_10, nil, arg_55_6)
				end

				if not Managers.state.network:game() then
					if not arg_55_15 and not arg_55_21 then
						EffectHelper.remote_play_surface_material_effects(arg_55_21, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, arg_55_12, arg_55_6)
					else
						EffectHelper.remote_play_surface_material_effects(arg_55_23, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, arg_55_12, arg_55_6)
					end
				end

				if not flag and not arg_55_5 and not alive(arg_55_5) and not arg_55_6 then
					local multiply = Vector3.multiply(arg_55_9, -1)

					set_flow_variable(arg_55_5, "hit_actor", arg_55_6)
					set_flow_variable(arg_55_5, "hit_direction", multiply)
					set_flow_variable(arg_55_5, "hit_position", arg_55_7)
					flow_event(arg_55_5, "lua_simple_damage")
				end
			end

			var_55_1.stop = true
			var_55_1.hits = 1
		end
	end

	return var_55_9
end

DamageUtils._projectile_hit_character = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8, arg_56_9, arg_56_10, arg_56_11, arg_56_12, arg_56_13, arg_56_14, arg_56_15, arg_56_16, arg_56_17, arg_56_18, arg_56_19, arg_56_20, arg_56_21, arg_56_22, arg_56_23, arg_56_24, arg_56_25, arg_56_26, arg_56_27, arg_56_28, arg_56_29)
	-- function 56
	local var_56_0 = tbl_14
	local var_56_1 = tbl_15
	local network = Managers.state.network
	local game_object_or_level_id, var_56_4 = network:game_object_or_level_id(arg_56_1)
	local game_object_or_level_id_2, var_56_6 = network:game_object_or_level_id(arg_56_5)
	local str = "torso"
	local num = 0
	local flag = false
	local var_56_10 = arg_56_27
	local var_56_11 = arg_56_28

	if not arg_56_11 then
		local var_56_12 = node(arg_56_6)

		str = arg_56_11.hit_zones_lookup[var_56_12].name

		if str ~= "afro" then
			flag = not AiUtils.attack_is_shield_blocked(arg_56_5, arg_56_1) and not self.ignore_shield_hit

			if not flag then
				var_56_1.blocked_by_unit = arg_56_5
			end
		end
	end

	if not (not self.hit_zone_override and str == "afro") then
		str = self.hit_zone_override
	end

	local flag_2 = true

	if not ((str == "head" or not HEALTH_ALIVE[arg_56_5] or not arg_56_11 or not arg_56_11.hit_zones or not arg_56_11.hit_zones.head or not (not arg_56_3 and arg_56_3:has_buff_perk("auto_headshot"))) and str == "afro") then
		str = "head"
		flag_2 = false

		arg_56_3:trigger_procs("on_auto_headshot")
	end

	if not (not arg_56_11 and str ~= "head" and not arg_56_2 and flag) then
		local extension = ScriptUnit.extension(arg_56_1, "first_person_system")
		local apply_buffs_to_value, var_56_16 = arg_56_3:apply_buffs_to_value(0, "coop_stamina")

		if not var_56_16 and not HEALTH_ALIVE[arg_56_5] then
			local headshot_coop_stamina_fatigue_type = arg_56_11.headshot_coop_stamina_fatigue_type

			headshot_coop_stamina_fatigue_type = headshot_coop_stamina_fatigue_type or "headshot_clan_rat"

			local var_56_18 = NetworkLookup.fatigue_types[headshot_coop_stamina_fatigue_type]

			if not arg_56_12 then
				network.network_transmit:send_rpc_clients("rpc_replenish_fatigue_other_players", var_56_18)
			else
				network.network_transmit:send_rpc_server("rpc_replenish_fatigue_other_players", var_56_18)
			end

			StatusUtils.replenish_stamina_local_players(arg_56_1, headshot_coop_stamina_fatigue_type)
			extension:play_hud_sound_event("hud_player_buff_headshot", nil, false)
		end

		if self.no_headshot_sound or not HEALTH_ALIVE[arg_56_5] then
			extension:play_hud_sound_event("Play_hud_headshot", nil, false)
		end
	end

	local owner = Managers.player:owner(arg_56_5)

	if str == "afro" then
		if not arg_56_11.is_ai and not Managers.state.side:is_enemy(arg_56_5, arg_56_1) then
			if not arg_56_12 then
				if not ScriptUnit.has_extension(arg_56_5, "ai_system") then
					AiUtils.alert_unit_of_enemy(arg_56_5, arg_56_1)
				end
			else
				network.network_transmit:send_rpc_server("rpc_alert_enemy", game_object_or_level_id_2, game_object_or_level_id)
			end
		end
	elseif not (not owner and arg_56_6 ~= actor(arg_56_5, "c_afro")) then
		local afro_hit_sound = self.afro_hit_sound

		if not afro_hit_sound and owner.bot_player or not Managers.state.network:game() then
			local var_56_21 = NetworkLookup.sound_events[afro_hit_sound]

			network.network_transmit:send_rpc("rpc_play_first_person_sound", owner.peer_id, game_object_or_level_id_2, var_56_21, arg_56_7)
		end
	else
		var_56_0[arg_56_5] = true

		local var_56_22 = NetworkLookup.hit_zones[str]
		local attack_template = arg_56_4.attack_template
		local get_attack_template = DamageUtils.get_attack_template(attack_template)

		if not (not arg_56_2 and not arg_56_11 and not arg_56_13 and flag) then
			local flag_3 = true
			local get_item_buff_type = DamageUtils.get_item_buff_type(arg_56_19)
			local buff_on_attack = DamageUtils.buff_on_attack(arg_56_1, arg_56_5, "instant_projectile", arg_56_14, str, arg_56_29 or var_56_10 + 1, flag_3, get_item_buff_type, flag_2, arg_56_19)
			local buffs_checked = var_56_1.buffs_checked

			buffs_checked = buffs_checked or buff_on_attack
			var_56_1.buffs_checked = buffs_checked
		end

		if not arg_56_11 and not HEALTH_ALIVE[arg_56_5] then
			local hit_mass_count = self.hit_mass_count

			if not hit_mass_count and not hit_mass_count[arg_56_11.name] then
				var_56_11 = var_56_11 + (self.hit_mass_count[arg_56_11.name] or 1)
			else
				local var_56_30

				if not flag then
					if not arg_56_11.hit_mass_counts_block then
						var_56_30 = arg_56_11.hit_mass_counts_block[arg_56_15]

						if not var_56_30 then
							-- Nothing
						end
					end

					var_56_30 = arg_56_11.hit_mass_count_block

					if not var_56_30 then
						-- Nothing
					end
				end

				if not arg_56_11.hit_mass_counts then
					var_56_30 = arg_56_11.hit_mass_counts[arg_56_15]

					if not var_56_30 then
						-- Nothing
					end
				end

				var_56_30 = arg_56_11.hit_mass_count
				var_56_30 = var_56_30 or 1

				::label_56_0::

				var_56_11 = var_56_11 + var_56_30
			end

			local has_extension = ScriptUnit.has_extension(arg_56_5, "buff_system")

			if not has_extension then
				var_56_11 = has_extension:apply_buffs_to_value(var_56_11, "hit_mass_amount")
			end
		end

		local ceil = math.ceil(var_56_11)
		local var_56_33
		local sound_type = get_attack_template.sound_type
		local var_56_35

		num, var_56_35 = DamageUtils.calculate_damage(DamageOutput, arg_56_5, arg_56_1, str, arg_56_16, BoostCurves[arg_56_4.boost_curve_type], arg_56_17, arg_56_14, arg_56_18, ceil, nil, arg_56_19)

		local flag_4 = num <= 0

		if not var_56_35 then
			arg_56_22 = "invulnerable"
			arg_56_20 = "invulnerable"

			DamageUtils.handle_hit_indication(arg_56_1, arg_56_5, 0, str, false, true)
		end

		if not (not arg_56_11 and arg_56_11.is_hero) then
			local name = arg_56_11.name

			if not arg_56_14 and not arg_56_20 then
				EffectHelper.play_skinned_surface_material_effects(arg_56_20, arg_56_21, arg_56_5, arg_56_7, arg_56_8, arg_56_9, arg_56_10, name, sound_type, flag_4, str, flag, arg_56_11)
			else
				EffectHelper.play_skinned_surface_material_effects(arg_56_22, arg_56_21, arg_56_5, arg_56_7, arg_56_8, arg_56_9, arg_56_10, name, sound_type, flag_4, str, flag, arg_56_11)
			end

			if not Managers.state.network:game() then
				if not arg_56_14 and not arg_56_20 then
					EffectHelper.remote_play_skinned_surface_material_effects(arg_56_20, arg_56_21, arg_56_7, arg_56_8, arg_56_9, name, sound_type, flag_4, str, arg_56_12)
				else
					EffectHelper.remote_play_skinned_surface_material_effects(arg_56_22, arg_56_21, arg_56_7, arg_56_8, arg_56_9, name, sound_type, flag_4, str, arg_56_12)
				end
			end
		elseif not owner and not arg_56_11.is_hero and not self.player_push_velocity then
			local has_extension_2 = ScriptUnit.has_extension(arg_56_5, "buff_system")

			if not (not has_extension_2 and has_extension_2:has_buff_perk("no_ranged_knockback") or ScriptUnit.extension(arg_56_5, "status_system"):is_disabled()) then
				local max_impact_push_speed = self.max_impact_push_speed

				ScriptUnit.extension(arg_56_5, "locomotion_system"):add_external_velocity(self.player_push_velocity:unbox(), max_impact_push_speed)
			end
		end

		local flag_5 = true
		local var_56_41 = alive(arg_56_1)

		if not var_56_41 and not owner then
			local fatigue_damage_override = arg_56_18.fatigue_damage_override

			fatigue_damage_override = fatigue_damage_override or "blocked_ranged"

			local check_ranged_block = DamageUtils.check_ranged_block(arg_56_1, arg_56_5, fatigue_damage_override)

			flag_5 = not check_ranged_block
			flag = check_ranged_block

			if not check_ranged_block and not Managers.state.side:versus_is_dark_pact(arg_56_1) then
				WwiseUtils.trigger_unit_event(arg_56_21, "Play_versus_ui_damage_mitigated_indicator", arg_56_5)
			end

			local get_data_2 = Unit.get_data(arg_56_1, "breed")

			if not flag and not get_data_2 and not get_data_2.track_projectile_blocked_vo then
				local time = Managers.time:time("game")
				local get_data_3 = Unit.get_data(arg_56_1, "blocked_projectile_hits")

				get_data_3 = get_data_3 or {}

				local num_2 = #get_data_3 + 1

				get_data_3[num_2] = time

				for i = num_2, 1, -1 do
					if time > get_data_3[i] + DialogueSettings.vs_track_projectiles_blocked_timer then
						table.swap_delete(get_data_3, i)

						num_2 = num_2 - 1
					end
				end

				if num_2 > DialogueSettings.vs_num_blocked_projectiles_to_track then
					ScriptUnit.extension_input(arg_56_1, "dialogue_system"):trigger_networked_dialogue_event("vs_ratling_hitting_shield")
					table.clear(get_data_3)
				end

				Unit.set_data(arg_56_1, "blocked_projectile_hits", get_data_3)
			end
		end

		if not owner and not arg_56_11.boss and not Managers.state.side:versus_is_dark_pact(arg_56_1) then
			flag_5 = false
		end

		if not flag_5 then
			Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(arg_56_24, game_object_or_level_id, game_object_or_level_id_2, var_56_22, arg_56_7, arg_56_23, arg_56_25, "power_level", arg_56_16, "hit_target_index", ceil, "blocking", flag, "shield_break_procced", false, "boost_curve_multiplier", arg_56_17, "is_critical_strike", arg_56_14, "attacker_is_level_unit", var_56_4, "first_hit", var_56_10 == 0)
			EffectHelper.player_critical_hit(arg_56_21, arg_56_14, arg_56_1, arg_56_5, arg_56_7)
			Managers.state.game_mode:game_mode():projectile_hit_character(arg_56_2, nil, arg_56_1, arg_56_5, arg_56_7, arg_56_11, arg_56_23, num)

			if (arg_56_2 or not var_56_41) and not owner and not owner.bot_player then
				ScriptUnit.extension(arg_56_5, "ai_system"):hit_by_projectile(arg_56_1)
			end
		end

		local var_56_48 = get_data(arg_56_5, "armor")
		local get_target_armor, var_56_50, var_56_51, var_56_52 = ActionUtils.get_target_armor(str, arg_56_11, var_56_48)

		if not (flag_4 or flag or var_56_51 == 6 or get_target_armor ~= 2) then
			arg_56_26 = var_56_10
		else
			var_56_10 = var_56_10 + 1
		end

		if arg_56_26 <= var_56_11 then
			var_56_1.stop = true
			var_56_1.hits = var_56_10
		end
	end

	return var_56_11, var_56_10, num, flag
end

DamageUtils.process_projectile_hit = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5, arg_57_6, arg_57_7, arg_57_8, arg_57_9, arg_57_10, arg_57_11, arg_57_12, arg_57_13)
	-- function 57
	table.clear(tbl_14)
	table.clear(tbl_15)

	local var_57_0 = tbl_14
	local var_57_1 = tbl_15
	local var_57_2 = arg_57_6
	local flag = not arg_57_2 and Managers.player:owner(arg_57_2)
	local var_57_4 = NetworkLookup.damage_sources[arg_57_1]
	local flag_2 = false
	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local has_extension = ScriptUnit.has_extension(arg_57_2, "buff_system")
	local num = 0
	local num_2 = 0
	local num_6 = 0
	local var_57_11
	local var_57_12

	arg_57_11 = arg_57_11 or DefaultPowerLevel

	if not arg_57_12 then
		-- Nothing
	end

	::label_57_0::

	local damage_profile = arg_57_5.damage_profile

	damage_profile = damage_profile or "default"

	::label_57_1::

	local flag_3 = not arg_57_12 and DamageProfileTemplates[arg_57_12]
	local var_57_15 = NetworkLookup.damage_profiles[damage_profile]
	local flag_4 = flag_3 or DamageProfileTemplates[damage_profile]
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local scale_power_levels = ActionUtils.scale_power_levels(arg_57_11, "cleave", arg_57_2, get_difficulty)
	local get_max_targets, var_57_20 = ActionUtils.get_max_targets(flag_4, scale_power_levels)

	if not has_extension then
		num_6 = has_extension:apply_buffs_to_value(num_6, "ranged_additional_penetrations")
	end

	local get_ranged_boost, var_57_22 = ActionUtils.get_ranged_boost(arg_57_2)
	local flag_5 = not (var_57_20 < get_max_targets) or not get_max_targets or var_57_20
	local flag_6

	flag_6 = not (not flag and flag.bot_player) and true and false

	local hit_effect = arg_57_5.hit_effect
	local critical_hit_effect = arg_57_5.critical_hit_effect
	local count = #arg_57_4

	var_57_1.hits = num_2

	local no_friendly_fire = flag_4.no_friendly_fire
	local allow_friendly_fire = flag_4.allow_friendly_fire
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local flag_7 = allow_friendly_fire or not not no_friendly_fire or DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, flag)
	local side = Managers.state.side
	local player = Managers.player

	for i = 1, count do
		repeat
			local var_57_34 = arg_57_4[i]
			local var_57_35 = var_57_34[num_3]
			local var_57_36 = var_57_34[num_4]
			local var_57_37 = var_57_34[num_5]
			local flag_8 = var_57_37 ~= nil
			local var_57_39

			if not flag_8 then
				var_57_39 = unit(var_57_37)

				if not var_57_39 then
					-- Nothing
				end
			end

			var_57_39 = nil

			::label_57_2::

			if not alive(var_57_39) and not Unit.is_frozen(var_57_39) then
				flag_8 = false
				var_57_39 = nil
			else
				var_57_39, var_57_37 = ActionUtils.redirect_shield_hit(var_57_39, var_57_37)
			end

			if not (var_57_39 == arg_57_2 or flag_8) then
				break
			end

			local var_57_40

			if not flag_4.targets then
				var_57_40 = flag_4.targets[num_2 + 1]

				if not var_57_40 then
					-- Nothing
				end
			end

			var_57_40 = flag_4.default_target

			::label_57_3::

			local look = Quaternion.look(var_57_36)
			local flag_9 = var_57_39 == arg_57_8 or arg_57_8 == nil
			local unit_breed = AiUtils.unit_breed(var_57_39)
			local var_57_44

			if not unit_breed then
				local var_57_45 = node(var_57_37)
				local name = unit_breed.hit_zones_lookup[var_57_45].name

				if not (not arg_57_9 and not arg_57_9[var_57_39] and name == "afro") then
					return var_57_1
				end
			end

			local is_player_unit = player:is_player_unit(var_57_39)
			local flag_10 = unit_breed or is_player_unit
			local hit_any_player = var_57_1.hit_any_player

			hit_any_player = hit_any_player or is_player_unit
			var_57_1.hit_any_player = hit_any_player

			local flag_11 = false

			if not flag_10 and not flag then
				local var_57_51 = side.side_by_unit[var_57_39]
				local var_57_52 = side.side_by_unit[arg_57_2]
				local flag_12 = not var_57_51 and not var_57_52 and var_57_51.side_id == var_57_52.side_id

				if not (not var_57_51 and not var_57_52 and not flag_12 and unit_breed.boss) then
					flag_11 = not flag_7 and unit_breed.disable_projectile_friendly_fire
				end
			end

			if not (flag_10 or var_57_0[var_57_39]) then
				num = DamageUtils._projectile_hit_object(arg_57_5, arg_57_2, flag, has_extension, var_57_40, var_57_39, var_57_37, var_57_35, look, var_57_36, flag_6, unit_breed, arg_57_3, arg_57_7, flag_2, arg_57_10, get_difficulty_rank, arg_57_11, var_57_22, flag_4, arg_57_1, critical_hit_effect, arg_57_0, hit_effect, var_57_2, var_57_4, var_57_15, flag_5, num_2, num)

				if not var_57_1.stop then
					if num_6 > 0 then
						num_6 = num_6 - 1
						var_57_1.stop = false

						break
					end

					var_57_1.hit_unit = var_57_39
					var_57_1.hit_actor = var_57_37
					var_57_1.hit_position = var_57_35
					var_57_1.hit_direction = var_57_2

					return var_57_1
				end

				break
			end

			if not ((var_57_0[var_57_39] or not flag_9) and flag_11) then
				local var_57_54, var_57_55

				num, num_2, var_57_54, var_57_55 = DamageUtils._projectile_hit_character(arg_57_5, arg_57_2, flag, has_extension, var_57_40, var_57_39, var_57_37, var_57_35, look, var_57_36, flag_6, unit_breed, arg_57_3, arg_57_7, arg_57_10, get_difficulty_rank, arg_57_11, var_57_22, flag_4, arg_57_1, critical_hit_effect, arg_57_0, hit_effect, var_57_2, var_57_4, var_57_15, flag_5, num_2, num, arg_57_13)

				if not var_57_1.stop then
					if num_6 > 0 then
						num_6 = num_6 - 1
						var_57_1.stop = false

						break
					end

					var_57_1.hit_unit = var_57_39
					var_57_1.hit_actor = var_57_37
					var_57_1.hit_position = var_57_35
					var_57_1.hit_direction = var_57_2
					var_57_1.predicted_damage = var_57_54
					var_57_1.shield_blocked = var_57_55
					var_57_1.hit_player = is_player_unit

					return var_57_1
				end
			end
		until true
	end

	return var_57_1
end

local tbl_16 = {}

DamageUtils.get_modified_boost_curve = function (self, arg_58_1)
	-- function 58
	table.clear(tbl_16)

	for i, v in ipairs(self) do
		tbl_16[i] = self[i] * arg_58_1
	end

	return tbl_16
end

local function fn_7(self, arg_59_1)
	-- function 59
	local stagger_immunity = self.stagger_immunity

	if not stagger_immunity then
		return
	end

	local num_attacks = stagger_immunity.num_attacks
	local num_hits = stagger_immunity.num_hits

	num_hits = num_hits or 0

	local num = num_hits + 1

	if num == num_attacks then
		stagger_immunity.stagger_immune_at = arg_59_1
		stagger_immunity.stagger_immune_at_health = self.current_health_percent
		stagger_immunity.debug_damage_left = stagger_immunity.damage_threshold
		num = 0
	end

	stagger_immunity.num_hits = num
end

local function fn_8(self, arg_60_1)
	-- function 60
	local stagger_immunity = self.stagger_immunity

	if not stagger_immunity then
		return false
	end

	local current_health_percent = self.current_health_percent
	local health_threshold = stagger_immunity.health_threshold

	if not (not health_threshold and not (health_threshold < current_health_percent)) then
		return true
	end

	local num = 0
	local stagger_immune_at_health = stagger_immunity.stagger_immune_at_health

	if not stagger_immune_at_health then
		num = stagger_immunity.damage_threshold - (stagger_immune_at_health - current_health_percent)
		stagger_immunity.debug_damage_left = num
	end

	local num_2 = 0
	local stagger_immune_at = stagger_immunity.stagger_immune_at

	if not stagger_immune_at then
		local num_3 = stagger_immune_at + stagger_immunity.time

		num_3 = num_3 or 0
		num_2 = num_3 - arg_60_1
	end

	if not (not (num > 0) or not (num_2 > 0)) then
		return true
	end

	return false
end

local function fn_9(self, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
	-- function 61
	local has_extension = ScriptUnit.has_extension(arg_61_3, "status_system")
	local breed_action

	if not arg_61_4 then
		breed_action = has_extension:breed_action()

		if not breed_action then
			-- Nothing
		end
	end

	breed_action = self.action

	::label_61_0::

	local flag = not breed_action and breed_action.ignore_staggers

	if not self.anim_cb_stagger_immune then
		return true
	end

	if not flag and not arg_61_1.always_stagger then
		return false
	end

	if not flag.allow_push and not arg_61_1.is_push then
		return false
	end

	local var_61_3 = flag[arg_61_2]

	if type(var_61_3) == "table" then
		local type = var_61_3.type

		if type == "ignore_by_health" then
			local current_health_percent = self.current_health_percent
			local health = var_61_3.health

			return not (current_health_percent > health.min) or current_health_percent <= health.max
		elseif type == "reset_attack" then
			self.reset_attack = true
			self.reset_attack_delay = var_61_3.delay

			return true
		end
	elseif type(var_61_3) == "boolean" then
		return var_61_3
	else
		error("action_ignores_stagger: unsupported type")
	end
end

DamageUtils.stagger_ai = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5, arg_62_6, arg_62_7, arg_62_8, arg_62_9, arg_62_10, arg_62_11, arg_62_12, arg_62_13)
	-- function 62
	local var_62_0 = EnvironmentalHazards[arg_62_11]

	if not (arg_62_1.always_stagger_ai or DamageUtils.is_enemy(arg_62_12 or arg_62_5, arg_62_4) or not var_62_0 or var_62_0.enemy.can_stagger) then
		return
	end

	local has_extension = ScriptUnit.has_extension(arg_62_4, "ai_system")
	local blackboard

	if not has_extension then
		blackboard = has_extension:blackboard()

		if not blackboard then
			-- Nothing
		end
	end

	blackboard = BLACKBOARDS[arg_62_4]

	::label_62_0::

	if not blackboard then
		return
	end

	local is_hero = blackboard.breed.is_hero

	is_hero = not is_hero and not has_extension

	if not is_hero then
		return
	end

	if not fn_8(blackboard, arg_62_0) then
		return
	end

	local var_62_4

	if not arg_62_1.targets then
		var_62_4 = arg_62_1.targets[arg_62_2]

		if not var_62_4 then
			-- Nothing
		end
	end

	var_62_4 = arg_62_1.default_target

	::label_62_1::

	local attack_template = var_62_4.attack_template
	local get_attack_template = DamageUtils.get_attack_template(attack_template)
	local calculate_stagger_player, var_62_8, var_62_9, var_62_10 = DamageUtils.calculate_stagger_player(ImpactTypeOutput, arg_62_4, arg_62_5, arg_62_6, arg_62_3, arg_62_8, arg_62_9, arg_62_1, arg_62_2, arg_62_10, arg_62_11)
	local is_push = arg_62_1.is_push

	if calculate_stagger_player == 0 then
		return
	end

	local is_player = blackboard.is_player

	is_player = not is_player and not has_extension

	if not fn_9(blackboard, get_attack_template, calculate_stagger_player, arg_62_4, is_player) then
		return
	end

	if not is_player then
		fn_7(blackboard, arg_62_0)
	end

	local stagger_angle = get_attack_template.stagger_angle
	local var_62_14 = POSITION_LOOKUP[arg_62_4]

	var_62_14 = var_62_14 or world_position(arg_62_4, 0)

	local var_62_15 = POSITION_LOOKUP[arg_62_5]

	var_62_15 = var_62_15 or world_position(arg_62_5, 0)

	if stagger_angle == "down" or stagger_angle ~= "smiter" or not arg_62_10 then
		arg_62_7 = Vector3.normalize(var_62_14 - var_62_15)
		arg_62_7.z = -1
	elseif stagger_angle == "stab" or stagger_angle == "smiter" or not arg_62_10 then
		arg_62_7 = Vector3.normalize(var_62_14 - var_62_15)
	elseif stagger_angle == "pull" then
		arg_62_7 = Vector3.normalize(var_62_15 - var_62_14)
	end

	if calculate_stagger_player > scripts_utils_stagger_types.none then
		if not is_player then
			DamageUtils.stagger_player(arg_62_4, blackboard.breed, arg_62_7, var_62_9, calculate_stagger_player, var_62_8, get_attack_template.stagger_animation_scale, arg_62_0, var_62_10, get_attack_template.always_stagger, is_push)
		else
			AiUtils.stagger(arg_62_4, blackboard, arg_62_5, arg_62_7, var_62_9, calculate_stagger_player, var_62_8, get_attack_template.stagger_animation_scale, arg_62_0, var_62_10, get_attack_template.always_stagger, is_push, nil, arg_62_13, arg_62_11)
		end

		local var_62_16 = rawget(ItemMasterList, arg_62_11)
		local flag = not var_62_16 and var_62_16.template
		local flag_2 = not flag and WeaponUtils.get_weapon_template(flag)
		local buff_type

		if not flag_2 then
			buff_type = flag_2.buff_type

			if not buff_type then
				-- Nothing
			end
		end

		buff_type = nil

		::label_62_2::

		local flag_3 = not arg_62_5 and ScriptUnit.has_extension(arg_62_5, "buff_system")

		if not (not flag_3 and blackboard.override_stagger) then
			Managers.state.achievement:trigger_event("register_ai_stagger", arg_62_4, arg_62_5, arg_62_1, is_push, calculate_stagger_player)
			flag_3:trigger_procs("on_stagger", arg_62_4, arg_62_1, arg_62_5, calculate_stagger_player, var_62_8, var_62_10, buff_type, arg_62_2)
		end

		local has_extension_2 = ScriptUnit.has_extension(arg_62_4, "buff_system")

		if not has_extension_2 then
			has_extension_2:trigger_procs("on_staggered", arg_62_4, arg_62_1, arg_62_5, calculate_stagger_player, var_62_8, var_62_10, buff_type, arg_62_2)
		end
	end
end

local tbl_17 = {
	charge_ability_hit_blast = "on_charge_ability_hit_blast",
	charge_ability_hit = "on_charge_ability_hit"
}

DamageUtils.server_apply_hit = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4, arg_63_5, arg_63_6, arg_63_7, arg_63_8, arg_63_9, arg_63_10, arg_63_11, arg_63_12, arg_63_13, arg_63_14, arg_63_15, arg_63_16, arg_63_17, arg_63_18, arg_63_19, arg_63_20, arg_63_21)
	-- function 63
	arg_63_20 = arg_63_20 or arg_63_1

	local has_extension = ScriptUnit.has_extension(arg_63_1, "buff_system")

	if not has_extension and not tbl_17[arg_63_7] then
		has_extension:trigger_procs(tbl_17[arg_63_7], arg_63_2, arg_63_10)
	end

	if not arg_63_15 then
		local var_63_1 = arg_63_8

		if not arg_63_13 then
			var_63_1 = 0
		end

		if arg_63_9.charge_value ~= "heavy_attack" or not DamageUtils.is_player_unit(arg_63_1) then
			local has_extension_2 = ScriptUnit.has_extension(arg_63_1, "status_system")

			if not (not has_extension_2 and not (has_extension_2:fall_distance() >= MinFallDistanceForBonus)) then
				var_63_1 = var_63_1 * FallingPowerLevelBonusMultiplier
			end
		end

		local flag = false

		if not has_extension then
			local has_buff_perk = has_extension:has_buff_perk("victor_witchhunter_bleed_on_critical_hit")

			has_buff_perk = not has_buff_perk and arg_63_9.charge_value == "light_attack" and arg_63_9.charge_value == "heavy_attack" and not has_extension:has_buff_perk("victor_witchhunter_bleed_on_critical_hit_disable")

			local has_buff_perk_2 = has_extension:has_buff_perk("kerillian_critical_bleed_dot")

			has_buff_perk_2 = not has_buff_perk_2 and arg_63_9.charge_value ~= "projectile" or not has_extension:has_buff_perk("kerillian_critical_bleed_dot_disable")

			local flag_2 = arg_63_9.charge_value == "light_attack" or arg_63_9.charge_value == "heavy_attack" or not has_extension:has_buff_perk("generic_melee_bleed")
			local var_63_7

			if has_buff_perk or has_buff_perk_2 or not flag_2 then
				var_63_7 = "weapon_bleed_dot_whc"
			elseif not has_extension:has_buff_perk("sienna_unchained_burn_push") and not arg_63_9 and not arg_63_9.is_push then
				var_63_7 = "burning_dot_unchained_push"
			end

			if not var_63_7 then
				local alloc_table = FrameTable.alloc_table()

				alloc_table.dot_template_name = var_63_7

				local apply_dot = DamageUtils.apply_dot(arg_63_9, arg_63_10, arg_63_8, arg_63_2, arg_63_1, arg_63_3, arg_63_7, arg_63_11, arg_63_12, nil, arg_63_20, alloc_table)

				flag = flag or apply_dot
			end
		end

		if not (not arg_63_9.require_damage_for_dot and var_63_1 == 0 and flag) then
			local apply_dot_2 = DamageUtils.apply_dot(arg_63_9, arg_63_10, arg_63_8, arg_63_2, arg_63_1, arg_63_3, arg_63_7, arg_63_11, arg_63_12, nil, arg_63_20, nil)

			flag = flag or apply_dot_2
		end

		DamageUtils.add_damage_network_player(arg_63_9, arg_63_10, var_63_1, arg_63_2, arg_63_1, arg_63_3, arg_63_4, arg_63_5, arg_63_7, arg_63_6, arg_63_11, arg_63_12, flag, arg_63_18, arg_63_19, arg_63_17, arg_63_20)
	elseif not arg_63_16 then
		local has_extension_3 = ScriptUnit.has_extension(arg_63_2, "ai_shield_system")

		if not has_extension_3 and not has_extension_3:break_shield() and not has_extension then
			has_extension:trigger_procs("on_broke_shield", arg_63_2)
		end

		arg_63_15 = false
	end

	if not (not HEALTH_ALIVE[arg_63_2] and arg_63_9.no_stagger) then
		local var_63_12 = arg_63_8

		if not arg_63_14 then
			var_63_12 = 0
		end

		DamageUtils.stagger_ai(arg_63_0, arg_63_9, arg_63_10, var_63_12, arg_63_2, arg_63_1, arg_63_3, arg_63_5, arg_63_11, arg_63_12, arg_63_15, arg_63_7, arg_63_20, arg_63_21)
	end
end

local function fn_10(self, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	local var_64_0
	local flag = false

	if not arg_64_3 then
		var_64_0 = arg_64_3.dot_template_name
		flag = arg_64_3.dot_balefire_variant
	elseif not arg_64_2 and not arg_64_2.dot_template_name then
		var_64_0 = arg_64_2.dot_template_name
		flag = arg_64_2.dot_balefire_variant
	elseif not self then
		local var_64_2

		if not self.targets then
			var_64_2 = self.targets[arg_64_1]

			if not var_64_2 then
				-- Nothing
			end
		end

		var_64_2 = self.default_target

		::label_64_0::

		if not var_64_2 then
			var_64_0 = var_64_2.dot_template_name
			flag = var_64_2.dot_balefire_variant
		end

		if not var_64_0 then
			var_64_0 = self.dot_template_name
			flag = self.dot_balefire_variant
		end
	end

	return var_64_0, flag
end

DamageUtils.apply_dot = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_9, arg_65_10, arg_65_11)
	-- function 65
	if not self then
		local var_65_0

		if not self.targets then
			var_65_0 = self.targets[arg_65_1]

			if not var_65_0 then
				-- Nothing
			end
		end

		var_65_0 = self.default_target

		::label_65_0::

		if not self.allow_dot_finesse_hit then
			local unit_breed = AiUtils.unit_breed(arg_65_3)
			local get_breed_damage_multiplier_type = DamageUtils.get_breed_damage_multiplier_type(unit_breed, arg_65_5)
			local flag = get_breed_damage_multiplier_type == "headshot" or get_breed_damage_multiplier_type == "weakspot" or get_breed_damage_multiplier_type == "protected_weakspot"

			if flag or not arg_65_8 then
				local boost_curve_coefficient_headshot = var_65_0.boost_curve_coefficient_headshot

				boost_curve_coefficient_headshot = boost_curve_coefficient_headshot or DefaultBoostCurveCoefficient

				local var_65_5 = BoostCurves[var_65_0.boost_curve_type]
				local get_modified_boost_curve = DamageUtils.get_modified_boost_curve(var_65_5, boost_curve_coefficient_headshot)
				local num = 1
				local get_target_armor, var_65_9, var_65_10, var_65_11 = ActionUtils.get_target_armor(arg_65_5, unit_breed, num)
				local var_65_12 = fn_3(var_65_0, self, flag, get_breed_damage_multiplier_type, true, get_target_armor, var_65_10)
				local has_extension = ScriptUnit.has_extension(arg_65_4, "buff_system")

				if not has_extension then
					if not flag then
						var_65_12 = has_extension:apply_buffs_to_value(var_65_12, "headshot_multiplier")
					end

					if not arg_65_8 then
						var_65_12 = has_extension:apply_buffs_to_value(var_65_12, "critical_strike_effectiveness")
					end
				end

				local has_extension_2 = ScriptUnit.has_extension(arg_65_3, "buff_system")

				if not has_extension_2 and not flag then
					var_65_12 = has_extension_2:apply_buffs_to_value(var_65_12, "headshot_vulnerability")
				end

				arg_65_2 = arg_65_2 + arg_65_2 * DamageUtils.get_boost_curve_multiplier(get_modified_boost_curve or var_65_5, var_65_12)
			end
		end
	end

	local var_65_15, var_65_16 = fn_10(self, arg_65_1, arg_65_9, arg_65_11)

	if not var_65_16 then
		local has_extension_3 = ScriptUnit.has_extension(arg_65_10, "career_system")

		has_extension_3 = has_extension_3 or ScriptUnit.has_extension(arg_65_4, "career_system")
		var_65_15 = not has_extension_3 and has_extension_3:career_name() == "bw_necromancer" and BalefireBurnDotLookup[var_65_15] and var_65_15
	end

	local flag_2 = false
	local var_65_19 = DotTypeLookup[var_65_15]

	if not var_65_19 then
		flag_2 = Dots[var_65_19](var_65_15, self, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_10)

		if not flag_2 then
			Managers.state.achievement:trigger_event("on_dot_applied", var_65_15, arg_65_6, arg_65_4)
		end
	end

	return flag_2
end

DamageUtils.custom_calculate_damage = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8, arg_66_9, arg_66_10, arg_66_11, arg_66_12, arg_66_13)
	-- function 66
	local var_66_0

	if not arg_66_3.targets then
		var_66_0 = arg_66_3.targets[arg_66_4]

		if not var_66_0 then
			-- Nothing
		end
	end

	var_66_0 = arg_66_3.default_target

	::label_66_0::

	local var_66_1 = BoostCurves[var_66_0.boost_curve_type]
	local num = 1
	local get_target_armor, var_66_4, var_66_5, var_66_6 = ActionUtils.get_target_armor(arg_66_11, arg_66_10, num)
	local var_66_7 = DifficultySettings[arg_66_13]
	local DamageOutput = DamageOutput
	local flag = false
	local flag_2 = false
	local flag_3 = false
	local flag_4 = false
	local var_66_13
	local var_66_14
	local var_66_15
	local var_66_16 = fn_4(arg_66_0, arg_66_1, arg_66_2, DamageOutput, arg_66_11, arg_66_3, arg_66_4, var_66_1, arg_66_9, arg_66_6, arg_66_7, arg_66_10, arg_66_5, flag, flag_2, arg_66_8, arg_66_13, get_target_armor, var_66_5, flag_3, flag_4, var_66_14, var_66_15)
	local num_2 = var_66_16 * DamageUtils.calculate_stagger_multiplier(arg_66_3, var_66_13, var_66_7, arg_66_12)

	return var_66_16 + num_2, var_66_16, num_2
end

DamageUtils.calculate_stagger_multiplier = function (self, arg_67_1, arg_67_2, arg_67_3)
	-- function 67
	if not arg_67_2 then
		local min_stagger_damage_coefficient = arg_67_2.min_stagger_damage_coefficient
		local stagger_damage_multiplier = arg_67_2.stagger_damage_multiplier

		if not stagger_damage_multiplier then
			local num = arg_67_3 * stagger_damage_multiplier

			if not (not arg_67_1 and self.no_stagger_damage_reduction_ranged) then
				num = arg_67_1:apply_buffs_to_value(num, "unbalanced_damage_taken")
			end

			return min_stagger_damage_coefficient + num - 1
		end
	end

	return 0
end

local tbl_18 = {
	bleed = true,
	burninating = true,
	arrow_poison_dot = true
}
local tbl_19 = {
	{
		255,
		252,
		219,
		3
	},
	{
		255,
		252,
		169,
		3
	},
	{
		255,
		252,
		128,
		3
	},
	{
		255,
		252,
		98,
		3
	},
	{
		255,
		252,
		65,
		3
	},
	{
		255,
		207,
		49,
		31
	},
	{
		255,
		156,
		29,
		19
	}
}

DamageUtils.get_color_from_damage = function (arg_68_0)
	-- function 68
	local clamp = math.clamp(math.floor(math.remap(0, 30, 1, 7, arg_68_0)), 1, 7)

	return tbl_19[clamp]
end

DamageUtils.add_unit_floating_damage_numbers = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5, arg_69_6, arg_69_7)
	-- function 69
	local var_69_0
	local var_69_1 = tbl_18[arg_69_1]

	if not arg_69_4 then
		local get_color_from_damage = DamageUtils.get_color_from_damage(arg_69_4)

		var_69_0 = Vector3(get_color_from_damage[2], get_color_from_damage[3], get_color_from_damage[4])
	else
		local min = math.min(120 + arg_69_2 * 4, 255)
		local max = math.max(200 - arg_69_2 * 4, 0)

		if not var_69_1 then
			var_69_0 = Vector3(192, 192, 192)
		else
			var_69_0 = Vector3(min, max, 0)
		end
	end

	local num = 40 + arg_69_2 * 0.75 * (arg_69_6 or 1)
	local num_2 = 2.2

	if not arg_69_3 then
		var_69_0[1] = 255
		num_2 = 3.2
		num = num + 0.05
	end

	if not var_69_1 then
		num_2 = 1.5
		num = num - 0.05
	end

	Managers.state.event:trigger("add_damage_number", arg_69_2, num, arg_69_0, num_2, var_69_0, arg_69_3, arg_69_5, arg_69_7)
end

DamageUtils.add_hit_reaction = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
	-- function 70
	if not (arg_70_2 or arg_70_4 or not arg_70_1 or arg_70_1.disable_local_hit_reactions or has_animation_state_machine(arg_70_0)) then
		return
	end

	local var_70_0

	if not has_animation_event(arg_70_0, "hit_reaction_climb") then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_70_0)
		local var_70_3 = NetworkLookup.bt_action_names[GameSession.game_object_field(network:game(), unit_game_object_id, "bt_action_name")]

		if not (not var_70_3 and var_70_3 ~= "climb") then
			var_70_0 = "hit_reaction_climb"
		end
	end

	local forward = Quaternion.forward(local_rotation(arg_70_0, 0))
	local flat_angle = Vector3.flat_angle(forward, arg_70_3)

	if var_70_0 or not arg_70_1.hit_reaction_function then
		var_70_0 = arg_70_1.hit_reaction_function(arg_70_0, arg_70_1, forward, arg_70_3, flat_angle)
	else
		var_70_0 = (var_70_0 or flat_angle < -math.pi * 0.75 or flat_angle > math.pi * 0.75 or "hit_reaction_backward" or not (flat_angle < -math.pi * 0.25) or not "hit_reaction_left" or not (flat_angle < math.pi * 0.25)) and (not "hit_reaction_forward" or "hit_reaction_right")
	end

	animation_event(arg_70_0, var_70_0)
end

DamageUtils.attacker_is_fire_bomb = function (arg_71_0)
	-- function 71
	local has_extension = ScriptUnit.has_extension(arg_71_0, "area_damage_system")

	if not has_extension then
		return false
	end

	if not (has_extension.explosion_template_name == "fire_grenade" or has_extension.explosion_template_name == "frag_fire_grenade") then
		return false
	end

	return true
end

DamageUtils.get_attack_template = function (arg_72_0)
	-- function 72
	return MechanismOverrides.get(AttackTemplates[arg_72_0])
end
