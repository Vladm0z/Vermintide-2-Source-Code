-- chunkname: @scripts/helpers/damage_utils.lua

local var_0_0 = require("scripts/utils/stagger_types")
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

DamageUtils = DamageUtils or {}

local var_0_2 = BLACKBOARDS
local var_0_3 = 4
local var_0_4 = POSITION_LOOKUP
local var_0_5 = Unit.get_data
local var_0_6 = Unit.alive
local var_0_7 = Unit.local_position
local var_0_8 = Unit.local_rotation
local var_0_9 = Unit.world_position
local var_0_10 = Unit.set_flow_variable
local var_0_11 = Unit.flow_event
local var_0_12 = Unit.actor
local var_0_13 = Unit.has_animation_state_machine
local var_0_14 = Unit.animation_event
local var_0_15 = Unit.has_animation_event
local var_0_16 = Vector3.distance_squared
local var_0_17 = Actor.position
local var_0_18 = Actor.unit
local var_0_19 = Actor.node
local var_0_20 = {
	aoe_poison_dot = true,
	poison = true,
	arrow_poison = true,
	arrow_poison_dot = true
}
local var_0_21 = {
	skaven_poison_wind_globadier = true,
	poison_dot = true
}

local function var_0_22(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = ScriptUnit.has_extension(arg_1_0, "buff_system")

	if var_1_0 then
		if var_1_0:has_buff_perk("invulnerable") or RangedAttackTypes[arg_1_3] and var_1_0:has_buff_perk("invulnerable_ranged") then
			return true
		end

		local var_1_1 = var_0_20[arg_1_1] or var_0_21[arg_1_2]
		local var_1_2 = var_1_0:has_buff_perk("poison_proof")

		return var_1_1 and var_1_2
	end

	return false
end

DamageUtils.get_breed_damage_multiplier_type = function (arg_2_0, arg_2_1)
	local var_2_0

	if arg_2_0 and arg_2_0.hitzone_multiplier_types then
		var_2_0 = arg_2_0.hitzone_multiplier_types[arg_2_1]
	end

	return var_2_0
end

local function var_0_23(arg_3_0, arg_3_1)
	if arg_3_1 < 1 then
		return arg_3_0[1]
	elseif arg_3_1 >= #arg_3_0 then
		return arg_3_0[#arg_3_0]
	else
		return arg_3_0[arg_3_1]
	end
end

DamageUtils.get_boost_curve_multiplier = function (arg_4_0, arg_4_1)
	local var_4_0 = (#arg_4_0 - 1) * arg_4_1
	local var_4_1 = math.floor(var_4_0) + 1
	local var_4_2 = var_4_0 - math.floor(var_4_0)
	local var_4_3 = var_0_23(arg_4_0, var_4_1 - 1)
	local var_4_4 = var_0_23(arg_4_0, var_4_1 + 0)
	local var_4_5 = var_0_23(arg_4_0, var_4_1 + 1)
	local var_4_6 = var_0_23(arg_4_0, var_4_1 + 2)
	local var_4_7 = -var_4_3 / 2 + 3 * var_4_4 / 2 - 3 * var_4_5 / 2 + var_4_6 / 2
	local var_4_8 = var_4_3 - 5 * var_4_4 / 2 + 2 * var_4_5 - var_4_6 / 2
	local var_4_9 = -var_4_3 / 2 + var_4_5 / 2
	local var_4_10 = var_4_4

	return var_4_7 * var_4_2 * var_4_2 * var_4_2 + var_4_8 * var_4_2 * var_4_2 + var_4_9 * var_4_2 + var_4_10
end

local function var_0_24(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	local var_5_0 = 0

	if arg_5_2 then
		if arg_5_4 then
			if arg_5_5 == 3 then
				var_5_0 = arg_5_0 and (arg_5_0.headshot_boost_boss or arg_5_0.headshot_boost) or 0.25
			else
				var_5_0 = arg_5_0 and arg_5_0.headshot_boost or 0.5
			end
		elseif arg_5_6 == 6 and not arg_5_4 then
			var_5_0 = arg_5_0 and arg_5_0.headshot_boost_heavy_armor or 0.25
		elseif arg_5_5 == 2 and not arg_5_4 then
			var_5_0 = arg_5_0 and (arg_5_0.headshot_boost_armor or arg_5_0.headshot_boost) or 0.5
		end

		if arg_5_3 == "protected_weakspot" then
			var_5_0 = var_5_0 * 0.25
		end
	end

	if arg_5_3 == "protected_spot" then
		var_5_0 = var_5_0 - 0.5
	end

	return var_5_0
end

local function var_0_25(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10, arg_6_11, arg_6_12, arg_6_13, arg_6_14, arg_6_15, arg_6_16, arg_6_17, arg_6_18, arg_6_19, arg_6_20, arg_6_21, arg_6_22)
	if arg_6_5 and arg_6_5.no_damage then
		return 0
	end

	local var_6_0 = DifficultySettings[arg_6_16]
	local var_6_1 = 0
	local var_6_2 = 0
	local var_6_3 = 1
	local var_6_4 = 1
	local var_6_5 = DamageUtils.get_breed_damage_multiplier_type(arg_6_11, arg_6_4)
	local var_6_6 = var_6_5 == "headshot" or var_6_5 == "weakspot" or var_6_5 == "protected_weakspot"

	if var_6_6 or arg_6_9 or arg_6_15 or arg_6_8 and arg_6_8 > 0 then
		local var_6_7
		local var_6_8 = (arg_6_17 == 2 or arg_6_17 == 5 or arg_6_17 == 6) and 1 or arg_6_17
		local var_6_9 = arg_6_3[var_6_8] or var_6_8 == 0 and 0 or arg_6_3[1]
		local var_6_10

		if type(var_6_9) == "table" then
			local var_6_11 = var_6_9.max - var_6_9.min
			local var_6_12, var_6_13 = ActionUtils.get_power_level_for_target(arg_6_22, arg_6_2, arg_6_5, arg_6_6, arg_6_9, arg_6_0, arg_6_4, var_6_8, arg_6_1, arg_6_11, arg_6_12, arg_6_16, arg_6_17, arg_6_18)
			local var_6_14 = ActionUtils.get_power_level_percentage(var_6_12)

			var_6_10 = var_6_9.min + var_6_11 * var_6_14
		else
			var_6_10 = var_6_9
		end

		if var_6_6 then
			var_6_3 = var_6_10 * 0.5
		end

		if arg_6_9 then
			var_6_3 = var_6_10 * 0.5
		end

		if arg_6_15 or arg_6_8 and arg_6_8 > 0 then
			var_6_1 = var_6_10
		end
	end

	local var_6_15
	local var_6_16

	if type(arg_6_3) == "table" then
		local var_6_17 = arg_6_18 or arg_6_17

		var_6_16 = arg_6_3[var_6_17] or var_6_17 == 0 and 0 or arg_6_3[1]
	else
		var_6_16 = arg_6_3
	end

	if type(var_6_16) == "table" then
		local var_6_18 = var_6_16.max - var_6_16.min
		local var_6_19 = 0

		if arg_6_5 then
			local var_6_20, var_6_21 = ActionUtils.get_power_level_for_target(arg_6_22, arg_6_2, arg_6_5, arg_6_6, arg_6_9, arg_6_0, arg_6_4, nil, arg_6_1, arg_6_11, arg_6_12, arg_6_16, arg_6_17, arg_6_18)

			var_6_19 = ActionUtils.get_power_level_percentage(var_6_20)
		end

		var_6_15 = var_6_16.min + var_6_18 * var_6_19
	else
		var_6_15 = var_6_16
	end

	local var_6_22

	if arg_6_10 then
		var_6_22 = var_6_1 and var_6_15 < var_6_1 and var_6_1 * (arg_6_10 - 1) or var_6_15 * (arg_6_10 - 1)
	end

	if not arg_6_13 then
		local var_6_23 = arg_6_5 and (arg_6_5.targets and arg_6_5.targets[arg_6_6] or arg_6_5.default_target)
		local var_6_24 = 0
		local var_6_25 = var_0_24(var_6_23, arg_6_5, var_6_6, var_6_5, var_6_15 > 0, arg_6_17, arg_6_18)

		if arg_6_15 then
			if arg_6_17 == 1 then
				var_6_24 = var_6_24 + 0.75
			elseif arg_6_17 == 2 then
				var_6_24 = var_6_24 + 0.6
			elseif arg_6_17 == 3 then
				var_6_24 = var_6_24 + 0.5
			elseif arg_6_17 == 4 then
				var_6_24 = var_6_24 + 0.5
			elseif arg_6_17 == 5 then
				var_6_24 = var_6_24 + 0.5
			elseif arg_6_17 == 6 then
				var_6_24 = var_6_24 + 0.3
			else
				var_6_24 = var_6_24 + 0.5
			end
		end

		if arg_6_8 and arg_6_8 > 0 then
			if arg_6_17 == 1 then
				var_6_24 = var_6_24 + 0.75
			elseif arg_6_17 == 2 then
				var_6_24 = var_6_24 + 0.3
			elseif arg_6_17 == 3 then
				var_6_24 = var_6_24 + 0.75
			elseif arg_6_17 == 4 then
				var_6_24 = var_6_24 + 0.5
			elseif arg_6_17 == 5 then
				var_6_24 = var_6_24 + 0.5
			elseif arg_6_17 == 6 then
				var_6_24 = var_6_24 + 0.2
			else
				var_6_24 = var_6_24 + 0.5
			end
		end

		if var_6_5 == "protected_spot" then
			var_6_24 = var_6_24 - 0.5
		end

		if arg_6_5 and arg_6_5.no_headshot_boost then
			var_6_25 = 0
		end

		local var_6_26 = arg_6_0 and ScriptUnit.has_extension(arg_6_0, "buff_system")
		local var_6_27 = 0

		if arg_6_9 then
			var_6_27 = arg_6_5 and arg_6_5.crit_boost or 0.5

			if arg_6_5 and arg_6_5.no_crit_boost then
				var_6_27 = 0
			end

			if var_6_26 and var_6_26:has_buff_perk("no_crit_damage") then
				var_6_27 = 0
			end
		end

		if arg_6_7 and (var_6_24 > 0 or var_6_25 > 0 or var_6_27 > 0) then
			local var_6_28
			local var_6_29
			local var_6_30 = var_6_23 and var_6_23.boost_curve_coefficient or DefaultBoostCurveCoefficient
			local var_6_31 = var_6_23 and var_6_23.boost_curve_coefficient_headshot or DefaultBoostCurveCoefficient

			if arg_6_8 and arg_6_8 > 0 then
				if arg_6_11 and arg_6_11.boost_curve_multiplier_override then
					arg_6_8 = math.clamp(arg_6_8, 0, arg_6_11.boost_curve_multiplier_override)
				end

				var_6_30 = var_6_30 * arg_6_8
				var_6_31 = var_6_31 * arg_6_8
			end

			if var_6_24 > 0 then
				local var_6_32 = DamageUtils.get_modified_boost_curve(arg_6_7, var_6_30)
				local var_6_33 = math.clamp(var_6_24, 0, 1)
				local var_6_34 = DamageUtils.get_boost_curve_multiplier(var_6_32 or arg_6_7, var_6_33)

				var_6_1 = math.max(math.max(var_6_1, var_6_15), var_6_4) * var_6_34
			end

			if var_6_25 > 0 or var_6_27 > 0 then
				local var_6_35 = DamageUtils.get_modified_boost_curve(arg_6_7, var_6_31)
				local var_6_36 = math.clamp(var_6_25 + var_6_27, 0, 1)
				local var_6_37 = DamageUtils.get_boost_curve_multiplier(var_6_35 or arg_6_7, var_6_36)

				var_6_2 = math.max(math.max(var_6_1, var_6_15), var_6_3) * var_6_37

				if var_6_26 and arg_6_9 then
					var_6_2 = var_6_2 * var_6_26:apply_buffs_to_value(1, "critical_strike_effectiveness")
				end

				if var_6_26 and var_6_6 then
					var_6_2 = var_6_2 * var_6_26:apply_buffs_to_value(1, "headshot_multiplier")
				end

				local var_6_38 = ScriptUnit.has_extension(arg_6_22, "buff_system")

				if var_6_38 and var_6_6 then
					var_6_2 = var_6_2 * var_6_38:apply_buffs_to_value(1, "headshot_vulnerability")
				end
			end
		end

		if arg_6_11 and arg_6_11.armored_boss_damage_reduction then
			var_6_15 = var_6_15 * 0.8
			var_6_1 = var_6_1 * 0.5
			var_6_22 = var_6_22 and var_6_22 * 0.75
		end

		if arg_6_11 and arg_6_11.boss_damage_reduction then
			var_6_15 = var_6_15 * 0.45
			var_6_1 = var_6_1 * 0.5
			var_6_2 = var_6_2 * 0.5
			var_6_22 = var_6_22 and var_6_22 * 0.75
		end

		if arg_6_11 and arg_6_11.lord_damage_reduction then
			var_6_15 = var_6_15 * 0.2
			var_6_1 = var_6_1 * 0.25
			var_6_2 = var_6_2 * 0.25
			var_6_22 = var_6_22 and var_6_22 * 0.5
		end

		var_6_15 = var_6_15 + var_6_1 + var_6_2

		if var_6_22 then
			var_6_15 = var_6_15 + var_6_22
		end

		if var_6_26 then
			if var_6_5 == "headshot" then
				var_6_15 = var_6_26:apply_buffs_to_value(var_6_15, "headshot_damage")
			else
				var_6_15 = var_6_26:apply_buffs_to_value(var_6_15, "non_headshot_damage")
			end
		end

		local var_6_39

		if arg_6_9 then
			if arg_6_4 == "head" and arg_6_19 then
				var_6_39 = true
			elseif arg_6_10 and arg_6_10 > 1 and arg_6_20 and arg_6_5.charge_value == "heavy_attack" then
				var_6_39 = true
			end
		end

		if var_6_39 and arg_6_11 then
			local var_6_40 = arg_6_11.boss
			local var_6_41 = arg_6_11.primary_armor_category

			if not var_6_40 and not var_6_41 then
				if arg_6_21 then
					var_6_15 = arg_6_21
				else
					local var_6_42 = arg_6_11.max_health

					var_6_15 = var_6_42[var_6_0.rank] or var_6_42[2]
				end
			end
		end
	end

	if arg_6_14 then
		local var_6_43 = var_6_0.friendly_fire_multiplier or 0
		local var_6_44, var_6_45, var_6_46 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "friendly_fire")

		if var_6_44 and var_6_46 and var_6_45 and not (Managers.state.side:versus_is_dark_pact(arg_6_0) or Managers.state.side:versus_is_dark_pact(arg_6_1)) then
			local var_6_47 = DifficultySettings[var_6_45]

			var_6_43 = var_6_47 and var_6_47.friendly_fire_multiplier or 0
		end

		if arg_6_5 and arg_6_5.friendly_fire_multiplier then
			var_6_43 = var_6_43 * arg_6_5.friendly_fire_multiplier
		end

		var_6_15 = var_6_15 * var_6_43
	end

	local var_6_48 = false

	return var_6_15, var_6_48
end

local function var_0_26(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = ScriptUnit.has_extension(arg_7_0, "buff_system")
	local var_7_1 = arg_7_4

	if var_7_0 then
		local var_7_2 = var_7_0:has_buff_perk("finesse_stagger_damage")
		local var_7_3 = var_7_0:has_buff_perk("smiter_stagger_damage")

		if var_7_0:has_buff_perk("linesman_stagger_damage") and var_7_1 > 0 then
			var_7_1 = var_7_1 + 1
		elseif (arg_7_3 or arg_7_2 == "head" or arg_7_2 == "neck") and var_7_2 then
			var_7_1 = 2
		elseif var_7_3 then
			if arg_7_1 and arg_7_1 <= 1 then
				var_7_1 = math.max(1, var_7_1)
			else
				var_7_1 = arg_7_4
			end
		end
	end

	return var_7_1
end

DamageUtils.calculate_damage_tooltip = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14, arg_8_15)
	local var_8_0 = DamageOutput
	local var_8_1 = false
	local var_8_2 = false
	local var_8_3 = false
	local var_8_4 = false
	local var_8_5 = var_0_25(arg_8_0, arg_8_1, arg_8_2, var_8_0, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, var_8_1, var_8_2, arg_8_12, arg_8_13, arg_8_14, arg_8_15, var_8_3, var_8_4)

	return (DamageUtils.networkify_damage(var_8_5))
end

DamageUtils.calculate_dot_buff_damage = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	arg_9_2 = arg_9_2 or "full"

	local var_9_0 = arg_9_4 or DefaultPowerLevel
	local var_9_1 = false

	arg_9_5 = arg_9_5 or "default"

	local var_9_2 = DamageProfileTemplates[arg_9_5]
	local var_9_3 = var_9_2.default_target.boost_curve_type
	local var_9_4 = BoostCurves[var_9_3]
	local var_9_5 = 0
	local var_9_6
	local var_9_7

	arg_9_3 = arg_9_3 or "dot_debuff"

	return DamageUtils.calculate_damage(DamageOutput, arg_9_0, arg_9_1, arg_9_2, var_9_0, var_9_4, var_9_5, var_9_1, var_9_2, var_9_6, var_9_7, arg_9_3)
end

DamageUtils.calculate_damage = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, arg_10_9, arg_10_10, arg_10_11)
	local var_10_0 = Managers.state.difficulty:get_difficulty_settings()
	local var_10_1
	local var_10_2
	local var_10_3

	if arg_10_1 then
		var_10_1 = AiUtils.unit_breed(arg_10_1)
		var_10_2 = var_0_5(arg_10_1, "armor")

		local var_10_4 = ScriptUnit.has_extension(arg_10_1, "health_system")
		local var_10_5 = ScriptUnit.has_extension(arg_10_1, "buff_system")
		local var_10_6 = var_10_4 and var_10_4:get_is_invincible()

		if not var_10_6 and var_10_5 then
			if var_10_5:has_buff_perk("invulnerable") then
				var_10_6 = true
			elseif var_10_5:has_buff_perk("invulnerable_ranged") then
				local var_10_7 = arg_10_8 and arg_10_8.charge_value

				var_10_6 = RangedAttackTypes[var_10_7]
			end
		end

		if var_10_6 then
			return 0, var_10_6
		end

		if var_10_4 then
			var_10_3 = var_10_4:get_max_health()
		elseif var_10_1 then
			local var_10_8 = var_10_1.max_health

			var_10_3 = var_10_8[var_10_0.rank] or var_10_8[2]
		end
	end

	local var_10_9

	if arg_10_2 then
		var_10_9 = Unit.get_data(arg_10_2, "breed")
	end

	local var_10_10 = not var_10_9 or not var_10_9.is_player
	local var_10_11 = not var_10_10 and Managers.state.side:is_ally(arg_10_2, arg_10_1)
	local var_10_12 = var_10_1 and var_10_1.is_hero
	local var_10_13 = 0

	if arg_10_8 and not var_10_10 then
		local var_10_14 = arg_10_8.targets and arg_10_8.targets[arg_10_9] or arg_10_8.default_target

		var_10_13 = ActionUtils.get_range_scalar_multiplier(arg_10_8, var_10_14, arg_10_2, arg_10_1)
	end

	local var_10_15 = arg_10_2 and ScriptUnit.has_extension(arg_10_2, "buff_system")
	local var_10_16 = false
	local var_10_17 = false
	local var_10_18 = false

	if var_10_15 then
		var_10_16 = var_10_15:has_buff_perk("potion_armor_penetration")
		var_10_17 = var_10_15:has_buff_perk("crit_headshot_killing_blow")
		var_10_18 = var_10_15:has_buff_perk("crit_backstab_killing_blow")
	end

	local var_10_19 = Managers.state.difficulty:get_difficulty()
	local var_10_20
	local var_10_21
	local var_10_22

	if var_10_12 then
		var_10_20 = var_0_3
	else
		local var_10_23, var_10_24

		var_10_20, var_10_23, var_10_21, var_10_24 = ActionUtils.get_target_armor(arg_10_3, var_10_1, var_10_2)
	end

	local var_10_25 = var_0_25(arg_10_2, arg_10_11, arg_10_4, arg_10_0, arg_10_3, arg_10_8, arg_10_9, arg_10_5, arg_10_6, arg_10_7, arg_10_10, var_10_1, var_10_13, var_10_10, var_10_11, var_10_16, var_10_19, var_10_20, var_10_21, var_10_17, var_10_18, var_10_3, arg_10_1)

	if arg_10_8 and not arg_10_8.is_dot then
		local var_10_26 = var_0_2[arg_10_1]
		local var_10_27 = 0

		if var_10_26 then
			if not arg_10_8.no_stagger_damage_reduction then
				local var_10_28 = var_10_1.no_stagger_damage_reduction
			end

			local var_10_29 = 0
			local var_10_30 = 2

			var_10_27 = var_10_26.is_climbing and 2 or math.min(var_10_26.stagger or var_10_29, var_10_30)

			if arg_10_8.no_stagger_damage_reduction_ranged then
				local var_10_31 = 1

				var_10_27 = math.max(var_10_31, var_10_27)
			end

			if not arg_10_8.no_stagger_damage_reduction_ranged then
				var_10_27 = var_0_26(arg_10_2, arg_10_9, arg_10_3, arg_10_7, var_10_27)
			end
		end

		local var_10_32 = var_10_0.min_stagger_damage_coefficient
		local var_10_33 = var_10_0.stagger_damage_multiplier

		if var_10_33 then
			local var_10_34 = var_10_27 * var_10_33
			local var_10_35 = ScriptUnit.has_extension(arg_10_1, "buff_system")

			if var_10_35 and not arg_10_8.no_stagger_damage_reduction_ranged then
				var_10_34 = var_10_35:apply_buffs_to_value(var_10_34, "unbalanced_damage_taken")
			end

			var_10_25 = var_10_25 * (var_10_32 + var_10_34)
		end
	end

	local var_10_36 = Managers.weave

	if var_10_12 and var_10_10 and var_10_36:get_active_weave() then
		var_10_25 = var_10_25 * (1 + var_10_36:get_scaling_value("enemy_damage"))
	end

	return var_10_25
end

local function var_0_27(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15, arg_11_16, arg_11_17, arg_11_18)
	local var_11_0 = arg_11_18 or arg_11_1.stagger_armor_category or arg_11_1.armor_category or 1
	local var_11_1 = var_0_0.none
	local var_11_2 = 0
	local var_11_3 = 1
	local var_11_4 = 1
	local var_11_5 = arg_11_3 and ScriptUnit.has_extension(arg_11_3, "buff_system")

	if var_11_5 then
		var_11_5:trigger_procs("stagger_calculation_started", arg_11_4)
	end

	local var_11_6 = arg_11_4 and ScriptUnit.has_extension(arg_11_4, "buff_system")
	local var_11_7 = arg_11_9.targets and arg_11_9.targets[arg_11_10] or arg_11_9.default_target
	local var_11_8 = var_11_7.attack_template
	local var_11_9 = DamageUtils.get_attack_template(var_11_8)
	local var_11_10 = ScriptUnit.has_extension(arg_11_4, "ai_system")
	local var_11_11 = ScriptUnit.has_extension(arg_11_4, "status_system")
	local var_11_12 = arg_11_2.is_player and not var_11_10
	local var_11_13
	local var_11_14 = FrameTable.alloc_table()

	var_11_14.damage_profile = arg_11_9

	if arg_11_1 then
		local var_11_15 = rawget(ItemMasterList, arg_11_12)
		local var_11_16 = var_11_15 and var_11_15.template

		if var_11_16 then
			local var_11_17 = WeaponUtils.get_weapon_template(var_11_16)
			local var_11_18 = var_11_17 and var_11_17.buff_type

			var_11_13 = var_11_18 and RangedBuffTypes[var_11_18]
			var_11_14.is_ranged = var_11_13
		end
	end

	var_11_14.is_ranged = var_11_13

	local var_11_19 = false
	local var_11_20, var_11_21, var_11_22 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "pactsworn_stagger_immunity")

	if var_11_20 and var_11_22 and var_11_21 then
		local var_11_23 = ScriptUnit.has_extension(arg_11_4, "career_system")

		if var_11_23 then
			local var_11_24 = var_11_23:profile_index()

			if SPProfiles[var_11_24].affiliation == "dark_pact" then
				var_11_19 = true
			end
		end
	end

	local var_11_25 = var_11_12 and var_11_11 and var_11_11:stagger_count() or arg_11_2.stagger_count or 0

	if arg_11_5 == "weakspot" and var_11_25 == 0 and (not arg_11_2.stagger or arg_11_2.stagger_anim_done or var_11_12 and not var_11_11:accumulated_stagger()) then
		var_11_1 = var_0_0.weakspot
	elseif arg_11_0 and not arg_11_1.stagger_immune and not var_11_19 then
		local var_11_26 = arg_11_0[var_11_0]
		local var_11_27 = var_11_26.max - var_11_26.min
		local var_11_28, var_11_29 = ActionUtils.get_power_level_for_target(arg_11_4, arg_11_6, arg_11_9, arg_11_10, arg_11_8, arg_11_3, arg_11_5, nil, arg_11_12, arg_11_1, arg_11_13, arg_11_15, var_11_0, nil)

		if arg_11_3 and var_0_6(arg_11_3) and var_11_5 then
			var_11_29 = var_11_5:apply_buffs_to_value(var_11_29, "push_power")

			local var_11_30 = var_11_12 and var_11_11:breed_action() or arg_11_2.action

			if var_11_30 and var_11_30.damage then
				var_11_29 = var_11_5:apply_buffs_to_value(var_11_29, "counter_push_power")
			end
		end

		if var_11_5 then
			var_11_29 = var_11_5:apply_buffs_to_value(var_11_29, "power_level_impact")
		end

		if var_11_6 then
			var_11_29 = var_11_6:apply_buffs_to_value(var_11_29, "impact_vulnerability")
		end

		var_11_2 = var_11_27 * ActionUtils.get_power_level_percentage(var_11_29)

		local var_11_31 = arg_11_8 or arg_11_5 == "head" or arg_11_5 == "neck"

		var_11_2 = var_11_26.min + var_11_2

		if arg_11_17 then
			var_11_2 = var_11_2 * 2
		end

		if arg_11_1 then
			local var_11_32 = DifficultySettings[arg_11_15].rank
			local var_11_33 = arg_11_1.diff_stagger_resist and (arg_11_1.diff_stagger_resist[var_11_32] or arg_11_1.diff_stagger_resist[2]) or var_11_13 and arg_11_1.stagger_resistance_ranged or arg_11_1.stagger_resistance or 2

			if var_11_6 then
				var_11_33 = var_11_6:apply_buffs_to_value(var_11_33, "stagger_resistance")
			end

			local var_11_34 = var_11_12 and var_11_11:breed_action() or arg_11_2.action
			local var_11_35 = var_11_34 and var_11_34.stagger_reduction
			local var_11_36 = not var_11_31 and not arg_11_9.ignore_stagger_reduction and (var_11_35 or arg_11_1.stagger_reduction)

			if var_11_36 and type(var_11_36) == "table" then
				var_11_36 = var_11_36[var_11_32] or var_11_36[2]
			end

			if var_11_36 then
				var_11_2 = math.clamp(var_11_2 - var_11_36, 0, var_11_2)
			end

			local var_11_37 = false

			if arg_11_2.stagger then
				var_11_2 = var_11_2 + math.clamp(arg_11_2.stagger * (arg_11_1.stagger_multiplier or 0.5) * var_11_2, 0, var_11_2)
			elseif var_11_12 and var_11_11 and var_11_11:accumulated_stagger() > 0 then
				local var_11_38 = var_11_11:accumulated_stagger()

				var_11_2 = var_11_2 + math.clamp(var_11_38 * (arg_11_1.stagger_multiplier or 0.5) * var_11_2, 0, var_11_2)
			elseif arg_11_9.is_push then
				var_11_37 = true
			end

			if var_11_2 > 0 then
				local var_11_39 = var_11_31
				local var_11_40 = arg_11_1.stagger_threshold_light and arg_11_1.stagger_threshold_light * var_11_33 or 0.25 * var_11_33
				local var_11_41 = arg_11_1.stagger_threshold_medium and arg_11_1.stagger_threshold_medium * var_11_33 or 1 * var_11_33
				local var_11_42 = arg_11_1.stagger_threshold_heavy and arg_11_1.stagger_threshold_heavy * var_11_33 or 2.5 * var_11_33

				if var_11_37 then
					var_11_42 = var_11_42 * 2
				end

				local var_11_43 = arg_11_1.stagger_threshold_explosion and arg_11_1.stagger_threshold_explosion * var_11_33 or 10 * var_11_33
				local var_11_44 = 0
				local var_11_45
				local var_11_46 = 1

				if var_11_2 < var_11_40 then
					var_11_1 = var_0_0.none
				elseif var_11_2 < var_11_41 then
					var_11_1 = var_0_0.weak
					var_11_44 = var_11_2

					local var_11_47 = var_11_44 > 0 and var_11_44 / var_11_33 or 0

					var_11_46 = 0.5 + 0.5 * math.clamp(var_11_47, 0, 1)
				elseif var_11_2 < var_11_42 then
					var_11_1 = var_0_0.medium
					var_11_44 = var_11_2 - var_11_41

					local var_11_48 = var_11_44 > 0 and var_11_44 / var_11_33 or 0

					var_11_46 = 0.5 + 0.5 * math.clamp(var_11_48, 0, 1)
				elseif var_11_2 < var_11_43 then
					var_11_1 = var_0_0.heavy
					var_11_44 = var_11_2 - var_11_42

					local var_11_49 = var_11_44 > 0 and var_11_44 / var_11_33 or 0

					var_11_46 = 0.5 + 0.5 * math.clamp(var_11_49, 0, 1)
				elseif arg_11_9.is_explosion then
					var_11_1 = var_0_0.explosion
				elseif arg_11_9.is_pull then
					var_11_1 = var_0_0.pulling
				else
					var_11_1 = var_0_0.heavy
				end

				if arg_11_1.stagger_duration_difficulty_mod then
					local var_11_50 = arg_11_1.stagger_duration_difficulty_mod

					var_11_3 = var_11_3 * (var_11_50[var_11_32] or var_11_50[2] or 1)
				end

				var_11_3 = var_11_3 * (0.75 + 0.25 * math.clamp(var_11_44 / var_11_33, 0, 2))
				var_11_4 = math.clamp(var_11_4 * var_11_46, 0.5, 1)
			end
		end
	end

	if arg_11_9.is_pull and var_11_1 <= var_0_0.heavy then
		var_11_1 = var_0_0.pulling
	end

	if var_11_9.ranged_stagger then
		if var_11_1 == var_0_0.weak then
			var_11_1 = var_0_0.ranged_weak
		elseif var_11_1 == var_0_0.medium then
			var_11_1 = var_0_0.ranged_medium
		end
	end

	local var_11_51 = var_11_9 and var_11_9.stagger_value or 1

	var_11_14.stagger_value = var_11_51

	local var_11_52

	if arg_11_1.stagger_modifier_function then
		var_11_1, var_11_3, var_11_4, var_11_52 = arg_11_1.stagger_modifier_function(var_11_1, var_11_3, var_11_4, arg_11_5, arg_11_2, arg_11_1, var_11_14)
	end

	if arg_11_11 then
		if arg_11_14 then
			arg_11_14.blocked_previous_attack = true
		end

		if var_11_1 == var_0_0.none and not var_11_52 then
			var_11_1 = var_0_0.weak
		elseif var_11_1 == var_0_0.heavy and var_11_51 == 1 then
			var_11_1 = var_0_0.medium
		end
	end

	if arg_11_1.boss_staggers and (var_11_1 < var_0_0.explosion or var_11_1 == var_0_0.pulling) or arg_11_1.small_boss_staggers and var_11_1 == var_0_0.pulling then
		var_11_1 = var_0_0.none
	end

	local var_11_53 = var_11_12 and var_11_11:breed_action() or arg_11_2.action
	local var_11_54 = var_11_53 and var_11_53.ignore_staggers

	if var_11_54 and var_11_5 and var_11_5:has_buff_type("push_increase") then
		var_11_54 = false
	end

	if (not var_11_9.always_stagger or arg_11_1.boss) and var_11_54 and var_11_54[var_11_1] and (not var_11_54.allow_push or not var_11_9 or not var_11_9.is_push) then
		return var_0_0.none, 0, 0, 0, 0
	end

	if arg_11_1.no_stagger_duration and not var_11_9.always_stagger then
		var_11_3 = var_11_3 * 0.25
	end

	if var_11_5 and var_11_5:has_buff_perk("explosive_stagger") then
		var_11_1 = var_0_0.explosion
	end

	local var_11_55 = var_11_7.stagger_duration_modifier or arg_11_9.stagger_duration_modifier or DefaultStaggerDurationModifier
	local var_11_56 = var_11_7.stagger_distance_modifier or arg_11_9.stagger_distance_modifier or DefaultStaggerDistanceModifier
	local var_11_57 = var_11_3 * (arg_11_1.stagger_duration and arg_11_1.stagger_duration[var_11_1] or DefaultStaggerDuration) * var_11_55
	local var_11_58 = var_11_4 * var_11_56

	if var_11_6 then
		var_11_58 = var_11_6:apply_buffs_to_value(var_11_58, "stagger_distance")
	end

	if var_11_5 then
		var_11_58 = var_11_5:apply_buffs_to_value(var_11_58, "applied_stagger_distance")
	end

	if not arg_11_1.no_random_stagger_duration then
		var_11_57 = math.max(var_11_57 + math.random() * 0.25, 0)
	end

	if arg_11_1.max_stagger_duration then
		var_11_57 = math.min(var_11_57, arg_11_1.max_stagger_duration)
	end

	if arg_11_9.is_pull and arg_11_4 then
		local var_11_59 = var_0_4[arg_11_4] or Unit.world_position(arg_11_4, 0)
		local var_11_60 = var_0_4[arg_11_3] or Unit.world_position(arg_11_3, 0)
		local var_11_61 = Vector3.length(var_11_59 - var_11_60) - 2.25

		var_11_58 = math.max(math.min(var_11_58, var_11_61), 0)
	end

	if var_11_5 then
		var_11_5:trigger_procs("stagger_calculation_ended", arg_11_4)
	end

	return var_11_1, var_11_57, var_11_58, var_11_51, var_11_2
end

local var_0_28 = {}

DamageUtils.calculate_stagger_player_tooltip = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8, arg_12_9, arg_12_10, arg_12_11, arg_12_12)
	local var_12_0 = ImpactTypeOutput

	arg_12_0 = arg_12_0 or var_0_28

	local var_12_1 = var_0_28
	local var_12_2
	local var_12_3 = false
	local var_12_4
	local var_12_5
	local var_12_6, var_12_7, var_12_8, var_12_9, var_12_10 = var_0_27(var_12_0, arg_12_0, var_12_1, arg_12_1, var_12_2, arg_12_2, arg_12_3, var_12_5, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8, arg_12_11, var_12_4, arg_12_9, var_12_3, arg_12_10, arg_12_12)

	return var_12_6, var_12_7, var_12_8, var_12_9, var_12_10
end

DamageUtils.calculate_stagger_player = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10)
	local var_13_0 = var_0_2[arg_13_1]
	local var_13_1 = var_13_0.breed
	local var_13_2 = Managers.state.difficulty:get_difficulty()
	local var_13_3 = AiUtils.shield_user(arg_13_1)
	local var_13_4 = arg_13_7.targets and arg_13_7.targets[arg_13_8] or arg_13_7.default_target
	local var_13_5 = ActionUtils.get_range_scalar_multiplier(arg_13_7, var_13_4, arg_13_2, arg_13_1)
	local var_13_6 = ScriptUnit.has_extension(arg_13_1, "ai_shield_system")
	local var_13_7 = false

	if arg_13_2 and var_0_6(arg_13_2) then
		local var_13_8 = ScriptUnit.has_extension(arg_13_2, "buff_system")

		if var_13_8 then
			var_13_7 = var_13_8:has_buff_perk("potion_armor_penetration")
		end
	end

	local var_13_9, var_13_10, var_13_11, var_13_12, var_13_13 = var_0_27(arg_13_0, var_13_1, var_13_0, arg_13_2, arg_13_1, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10, var_13_5, var_13_6, var_13_2, var_13_3, var_13_7)

	return var_13_9, var_13_10, var_13_11, var_13_12, var_13_13
end

DamageUtils.calculate_stagger = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	local var_14_0 = var_0_2[arg_14_2]
	local var_14_1 = var_14_0.breed
	local var_14_2 = var_14_1.stagger_armor_category or var_14_1.armor_category or 1
	local var_14_3 = AiUtils.shield_user(arg_14_2)
	local var_14_4 = var_0_0.none
	local var_14_5 = 0.5
	local var_14_6 = ScriptUnit.has_extension(arg_14_2, "ai_system")
	local var_14_7 = ScriptUnit.has_extension(arg_14_2, "status_system")
	local var_14_8 = var_14_0.is_player and not var_14_6

	if arg_14_5 == "weakspot" and var_14_0.stagger_count == 0 and (not var_14_0.stagger or var_14_0.stagger_anim_done) then
		var_14_4 = var_0_0.weakspot
	elseif arg_14_0 then
		var_14_4 = arg_14_0[var_14_2] or arg_14_0[1]
	end

	local var_14_9 = arg_14_4 and arg_14_4.stagger_value or 1

	if arg_14_6 then
		if var_14_4 == var_0_0.none then
			var_14_4 = var_0_0.weak
		elseif var_14_4 == var_0_0.heavy and var_14_9 == 1 then
			var_14_4 = var_0_0.medium
		end
	end

	if var_14_1.boss_staggers and var_14_4 < var_0_0.explosion then
		var_14_4 = var_0_0.none
	end

	local var_14_10 = var_14_8 and var_14_7:breed_action() or var_14_0.action
	local var_14_11 = var_14_10 and var_14_10.ignore_staggers

	if var_14_11 then
		local var_14_12 = ScriptUnit.has_extension(arg_14_3, "buff_system")

		if var_14_12 and var_14_12:has_buff_type("push_increase") then
			var_14_11 = false
		end
	end

	if var_14_11 and var_14_11[var_14_4] and (not var_14_11.allow_push or not arg_14_4 or not arg_14_4.is_push) then
		return 0, 0
	end

	if arg_14_1 then
		var_14_5 = arg_14_1[var_14_2] or arg_14_1[1]
	end

	if var_14_1.no_stagger_duration then
		var_14_5 = var_14_5 * 0.25
	elseif var_14_1.stagger_duration_mod then
		var_14_5 = var_14_5 * var_14_1.stagger_duration_mod
	elseif arg_14_6 then
		var_14_5 = math.lerp(var_14_5, 1.25, var_14_1.block_stagger_mod or 0.5)
	elseif var_14_3 then
		var_14_5 = var_14_5 * (var_14_1.shield_stagger_mod or 0.6)
	else
		var_14_5 = math.max(var_14_5 + math.random() - 0.5, 0)
	end

	return var_14_4, var_14_5
end

DamageUtils.is_player_unit = function (arg_15_0)
	return Managers.player:is_player_unit(arg_15_0)
end

DamageUtils.stagger_player = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11)
	fassert(arg_16_4 > 0, "Tried to use invalid stagger type %q", arg_16_4)

	local var_16_0 = Managers.state.difficulty:get_difficulty_settings().stagger_modifier
	local var_16_1 = ScriptUnit.has_extension(arg_16_0, "status_system")
	local var_16_2 = var_16_1:breed_action()

	if var_16_2 and var_16_2.stagger_prohibited or var_16_1:get_in_ghost_mode() then
		return
	end

	arg_16_8 = arg_16_8 or 1
	arg_16_6 = arg_16_6 or 1

	local var_16_3 = arg_16_5 * var_16_0
	local var_16_4 = var_16_1:accumulated_stagger()
	local var_16_5 = math.clamp(var_16_4 and var_16_4 + arg_16_8 or arg_16_8, 0, 2)
	local var_16_6 = math.max(var_16_5, var_16_4)

	var_16_1:set_stagger_values(arg_16_4, arg_16_2, arg_16_3, var_16_6, var_16_3, arg_16_6, arg_16_9, true)

	if arg_16_11 then
		local var_16_7 = arg_16_1.push_sound_event or "Play_generic_pushed_impact_small"

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_16_7, arg_16_0)
	end
end

DamageUtils.hit_zone = function (arg_17_0, arg_17_1)
	local var_17_0 = AiUtils.unit_breed(arg_17_0)

	if var_17_0 then
		local var_17_1 = var_0_19(arg_17_1)

		return var_17_0.hit_zones_lookup[var_17_1].name
	else
		return "full"
	end
end

DamageUtils.aoe_hit_zone = function (arg_18_0, arg_18_1)
	local var_18_0 = AiUtils.unit_breed(arg_18_0)

	if var_18_0 then
		local var_18_1 = var_0_19(arg_18_1)
		local var_18_2 = var_18_0.hit_zones_lookup[var_18_1]

		return (var_18_2 and var_18_2.name) == "afro" and "afro" or "torso"
	else
		return "full"
	end
end

DamageUtils.draw_aoe_size = function (arg_19_0, arg_19_1)
	local var_19_0, var_19_1 = DamageUtils.calculate_aoe_size(arg_19_0)
	local var_19_2 = var_0_4[arg_19_0]
	local var_19_3 = var_19_2 + Vector3(0, 0, math.max(var_19_1 - var_19_0 * 0.5, var_19_1 * 0.5))
	local var_19_4 = var_19_2 + Vector3(0, 0, math.min(var_19_0 * 0.5, var_19_1 * 0.5))

	QuickDrawer:capsule(var_19_4, var_19_3, var_19_0, Color(255, 255, 0, 255))
end

DamageUtils.calculate_aoe_size = function (arg_20_0, arg_20_1)
	local var_20_0
	local var_20_1

	if arg_20_1 then
		var_20_0 = arg_20_1.aoe_radius or DEFAULT_BREED_AOE_RADIUS
		var_20_1 = arg_20_1.aoe_height or DEFAULT_BREED_AOE_HEIGHT
	elseif DamageUtils.is_player_unit(arg_20_0) then
		var_20_0 = 0.3
		var_20_1 = 1.7
	else
		var_20_0 = 1
		var_20_1 = 1
	end

	return var_20_0, var_20_1
end

local var_0_29 = {}
local var_0_30 = {}
local var_0_31 = {}

DamageUtils.create_explosion = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10, arg_21_11, arg_21_12)
	local var_21_0 = DamageUtils
	local var_21_1 = arg_21_4.explosion
	local var_21_2 = Managers.weave:get_active_wind()
	local var_21_3 = Managers.weave:get_active_wind_settings()
	local var_21_4 = var_21_1.wind_mutator

	if var_21_1.camera_effect then
		local var_21_5 = var_21_1.camera_effect
		local var_21_6 = var_21_5.shake_name
		local var_21_7 = var_21_5.near_distance
		local var_21_8 = var_21_5.far_distance
		local var_21_9 = var_21_5.near_scale
		local var_21_10 = var_21_5.far_scale
		local var_21_11 = Managers.time:time("game")

		var_21_0.camera_shake_by_distance(var_21_6, var_21_11, nil, arg_21_9, var_21_7, var_21_8, var_21_9, var_21_10)
	end

	if var_21_1.effect_name then
		local var_21_12 = var_21_1.dont_rotate_fx and Quaternion.identity() or arg_21_3

		World.create_particles(arg_21_0, var_21_1.effect_name, arg_21_2, var_21_12)
	end

	if var_21_1.sound_event_name then
		local var_21_13, var_21_14 = WwiseUtils.make_position_auto_source(arg_21_0, arg_21_2)
		local var_21_15 = arg_21_8 and "true" or "false"

		WwiseWorld.set_switch(var_21_14, "husk", var_21_15, var_21_13)
		WwiseWorld.trigger_event(var_21_14, var_21_1.sound_event_name, var_21_13)
	end

	local var_21_16 = false

	if var_21_1.only_facing then
		local var_21_17 = Managers.player:local_player()
		local var_21_18 = var_21_17 and var_21_17.player_unit

		if var_21_18 then
			local var_21_19 = Unit.local_position(arg_21_1, 0)
			local var_21_20 = var_0_4[var_21_18]
			local var_21_21 = Unit.local_rotation(var_21_18, 0)
			local var_21_22, var_21_23, var_21_24 = Quaternion.to_euler_angles_xyz(var_21_21)
			local var_21_25 = var_21_24 - math.radians_to_degrees(math.angle(var_21_19.x, var_21_19.y, var_21_20.x, var_21_20.y))

			if var_21_25 < 0 then
				var_21_25 = var_21_25 + 360
			end

			if math.abs(90 - var_21_25) < 90 then
				var_21_16 = true
			end
		end
	end

	if var_21_1.screenspace_effect_name and (not var_21_1.only_facing or var_21_16) then
		local var_21_26 = Managers.player:local_player()
		local var_21_27 = var_21_26 and var_21_26.player_unit

		if var_21_27 then
			local var_21_28 = var_0_4[var_21_27]

			if Vector3.distance(var_21_28, arg_21_2) <= (var_21_1.screenspace_effect_radius or var_21_1.radius) then
				local var_21_29 = ScriptUnit.has_extension(var_21_27, "first_person_system")

				if var_21_29 then
					var_21_29:create_screen_particles(var_21_1.screenspace_effect_name)
				end
			end
		end
	end

	local var_21_30 = var_0_6(arg_21_1)

	if arg_21_7 and var_21_30 then
		if var_21_1.alert_enemies then
			Managers.state.entity:system("ai_system"):alert_enemies_within_range(arg_21_1, arg_21_2, var_21_1.alert_enemies_radius)
		end

		local var_21_31 = var_21_1.player_push_speed
		local var_21_32 = Managers.state.difficulty:get_difficulty()
		local var_21_33 = Managers.state.difficulty.fallback_difficulty
		local var_21_34 = var_21_1.radius
		local var_21_35

		if var_21_4 and var_21_2 and var_21_3.radius then
			local var_21_36 = Managers.weave:get_wind_strength()

			var_21_34 = var_21_3.radius[var_21_32][var_21_36] or var_21_3.radius[2][var_21_36]
			var_21_35 = var_21_1.max_damage_radius or var_21_34 - 1
		else
			var_21_35 = var_21_1.max_damage_radius or 0
		end

		local var_21_37 = var_21_1.radius_min
		local var_21_38 = var_21_1.radius_max
		local var_21_39 = var_21_1.exponential_falloff

		if var_21_37 and var_21_38 then
			var_21_34 = math.lerp(var_21_37, var_21_38, arg_21_5)

			if var_21_1.max_damage_radius_min then
				local var_21_40 = var_21_1.max_damage_radius_min
				local var_21_41 = var_21_1.max_damage_radius_max

				var_21_35 = math.lerp(var_21_40, var_21_41, arg_21_5)
			end
		end

		fassert(var_21_34, "Explosion template [%s] has no radius, or radius_min & radius_max, set", arg_21_4.name)

		local var_21_42 = ScriptUnit.has_extension(arg_21_1, "buff_system")
		local var_21_43 = arg_21_4.is_grenade

		if var_21_42 then
			local var_21_44 = 1

			if var_21_43 then
				var_21_44 = var_21_44 + (var_21_42:apply_buffs_to_value(1, "grenade_radius") - 1)
			end

			local var_21_45 = var_21_44 + (var_21_42:apply_buffs_to_value(1, "explosion_radius") - 1)

			var_21_34 = var_21_34 * var_21_45
			var_21_35 = var_21_35 * var_21_45
		end

		local var_21_46 = var_21_1.difficulty_power_level and (var_21_1.difficulty_power_level[var_21_32] or var_21_1.difficulty_power_level[var_21_33])
		local var_21_47 = var_21_1.different_power_levels_for_players
		local var_21_48 = var_21_46 or var_21_1
		local var_21_49
		local var_21_50
		local var_21_51
		local var_21_52
		local var_21_53

		if var_21_4 and var_21_2 then
			local var_21_54 = Managers.weave:get_wind_strength()

			if var_21_47 then
				var_21_52 = var_21_3.power_level_player[var_21_32][var_21_54]
				var_21_53 = var_21_3.power_level_ai[var_21_32][var_21_54]
			else
				var_21_49 = var_21_3.power_level and var_21_3.power_level[var_21_32][var_21_54] or 0
			end
		else
			var_21_49 = var_21_48.power_level
			var_21_50 = var_21_48.power_level_min
			var_21_51 = var_21_48.power_level_max
		end

		if var_21_1.use_attacker_power_level then
			assert(arg_21_10, "No attacker power level argument sent for explosion requiring it!")

			var_21_49 = arg_21_10
			var_21_51 = arg_21_10
			var_21_50 = var_21_51 * (var_21_1.attacker_power_level_offset or DefaultAttackerPowerLevelOffset)
		end

		if var_21_1.scale_power_level then
			var_21_49 = math.max(var_21_1.scale_power_level, arg_21_5) * var_21_49
			var_21_51 = math.max(var_21_1.scale_power_level, arg_21_5) * var_21_51
			var_21_50 = math.max(var_21_1.scale_power_level, arg_21_5) * var_21_50
		end

		local var_21_55 = var_21_48.power_level_glance
		local var_21_56 = var_21_49 or var_21_50 and var_21_51 or var_21_47 or false
		local var_21_57 = var_21_1.ignore_attacker_unit
		local var_21_58 = var_21_1.collision_filter or "filter_explosion_overlap"
		local var_21_59 = Managers.state.difficulty:get_difficulty_settings()
		local var_21_60 = var_21_1.only_line_of_sight
		local var_21_61 = Managers.player:owner(arg_21_1)
		local var_21_62 = var_21_61 ~= nil
		local var_21_63 = var_21_1.no_friendly_fire
		local var_21_64 = var_21_1.allow_friendly_fire_override
		local var_21_65

		if var_21_62 then
			var_21_65 = var_21_64 or var_21_0.allow_friendly_fire_ranged(var_21_59, var_21_61)
		else
			var_21_65 = var_21_1.ai_friendly_fire
		end

		local var_21_66 = ScriptUnit.has_extension(arg_21_1, "buff_system")

		if var_21_66 and var_21_66:has_buff_perk(var_0_1.no_explosion_friendly_fire) then
			var_21_65 = false
		end

		local var_21_67 = var_21_65 and not var_21_63
		local var_21_68 = World.physics_world(arg_21_0)
		local var_21_69, var_21_70 = PhysicsWorld.immediate_overlap(var_21_68, "shape", "sphere", "position", arg_21_2, "size", var_21_34, "collision_filter", var_21_58)
		local var_21_71 = var_0_29
		local var_21_72 = var_0_30
		local var_21_73 = var_0_31

		table.clear(var_21_71)
		table.clear(var_21_72)
		table.clear(var_21_73)

		local var_21_74 = var_21_1.explosion_forward_scaling
		local var_21_75 = var_21_1.explosion_cone_angle

		var_21_75 = var_21_75 and math.cos(var_21_75 / 2)

		local var_21_76

		if var_21_74 or var_21_75 then
			var_21_76 = Quaternion.forward(arg_21_3)
		end

		local var_21_77 = 0

		for iter_21_0 = 1, var_21_70 do
			local var_21_78 = var_21_69[iter_21_0]
			local var_21_79 = var_21_78 and var_0_18(var_21_78)

			if ScriptUnit.has_extension(var_21_79, "health_system") then
				if not var_0_5(var_21_79, "ignore_explosion_damage") and not var_21_71[var_21_79] and (not var_21_57 or var_21_79 ~= arg_21_1) and var_21_0.aoe_hit_zone(var_21_79, var_21_78) ~= "afro" then
					if not var_21_60 then
						local var_21_80 = true

						if var_21_75 or var_21_74 then
							local var_21_81 = Unit.world_position(var_21_79, 0) + Vector3.up() - arg_21_2
							local var_21_82 = Vector3.normalize(var_21_81)

							if var_21_75 then
								var_21_80 = var_21_75 <= Vector3.dot(var_21_82, var_21_76)
							end

							if var_21_80 and var_21_74 then
								local var_21_83 = math.lerp(var_21_34, var_21_34 * var_21_74, math.abs(Vector3.dot(var_21_82, var_21_76)))

								var_21_80 = var_21_83 * var_21_83 >= Vector3.length_squared(var_21_81)
							end
						end

						if var_21_80 then
							var_21_77 = var_21_77 + 1
							var_21_71[var_21_79] = true
							var_21_72[var_21_77] = var_21_78
						end
					else
						local var_21_84 = Unit.world_position(var_21_79, 0) + Vector3.up() - arg_21_2
						local var_21_85 = Vector3.normalize(var_21_84)
						local var_21_86 = var_21_34
						local var_21_87 = true

						if var_21_75 then
							var_21_87 = var_21_75 <= Vector3.dot(var_21_85, var_21_76)
						end

						local var_21_88 = true

						if var_21_87 and var_21_74 then
							local var_21_89 = math.lerp(var_21_34, var_21_34 * var_21_74, math.abs(Vector3.dot(var_21_85, var_21_76)))

							var_21_88 = var_21_89 * var_21_89 <= Vector3.length_squared(var_21_84)
						end

						if var_21_87 and explosion_right_scaling then
							local var_21_90 = math.lerp(var_21_34, var_21_34 * explosion_right_scaling, 1 - math.abs(Vector3.dot(var_21_85, explosion_right_scaling)))

							var_21_88 = var_21_90 * var_21_90 <= Vector3.length_squared(var_21_84)
						end

						if var_21_87 and var_21_88 then
							PhysicsWorld.prepare_actors_for_raycast(var_21_68, arg_21_2, var_21_85, 0.1)

							local var_21_91 = PhysicsWorld.immediate_raycast(var_21_68, arg_21_2, var_21_85, var_21_86, "all", "collision_filter", "filter_explosion_overlap_no_static")

							if var_21_91 then
								local var_21_92 = #var_21_91

								for iter_21_1 = 1, var_21_92 do
									local var_21_93 = var_21_91[iter_21_1][4]
									local var_21_94 = Actor.unit(var_21_93)

									if not AiUtils.unit_breed(var_21_94) then
										break
									end

									if var_21_79 == var_21_94 then
										var_21_77 = var_21_77 + 1
										var_21_71[var_21_79] = true
										var_21_72[var_21_77] = var_21_78

										break
									end
								end
							end
						end
					end
				end
			elseif var_21_79 and var_0_6(var_21_79) and var_21_78 and not var_21_1.no_prop_damage and not var_21_73[var_21_79] then
				var_21_73[var_21_79] = true

				local var_21_95 = Vector3.normalize(var_0_17(var_21_78) - arg_21_2)

				var_0_10(var_21_79, "hit_actor", var_21_78)
				var_0_10(var_21_79, "hit_direction", var_21_95)
				var_0_10(var_21_79, "hit_position", arg_21_2)
				var_0_11(var_21_79, "lua_simple_damage")
			end
		end

		if var_21_43 then
			SurroundingAwareSystem.add_event(arg_21_1, "grenade_exp", DialogueSettings.grabbed_broadcast_range, "hit", var_21_77, "grenade_owner", ScriptUnit.extension(arg_21_1, "dialogue_system").context.player_profile)
		end

		if var_21_77 > 0 then
			table.sort(var_21_72, function (arg_22_0, arg_22_1)
				local var_22_0 = var_0_18(arg_22_0)
				local var_22_1 = var_0_18(arg_22_1)
				local var_22_2 = var_0_4[var_22_0] or var_0_7(var_22_0, 0)
				local var_22_3 = var_0_4[var_22_1] or var_0_7(var_22_1, 0)

				return var_0_16(arg_21_2, var_22_2) < var_0_16(arg_21_2, var_22_3)
			end)
		end

		local var_21_96 = Managers.state.side
		local var_21_97 = Managers.state.entity:system("area_damage_system")
		local var_21_98 = 0
		local var_21_99 = var_21_1.hit_sound_event_cap or var_21_77
		local var_21_100 = var_21_1.ignore_players
		local var_21_101 = 0

		for iter_21_2 = 1, var_21_77 do
			local var_21_102 = var_21_72[iter_21_2]
			local var_21_103 = var_0_18(var_21_102)
			local var_21_104 = var_0_2[var_21_103]
			local var_21_105 = var_21_104 and var_21_104.breed
			local var_21_106 = var_21_105 and var_21_105.is_player
			local var_21_107 = var_21_105 and not var_21_106
			local var_21_108 = var_21_96:is_ally(arg_21_1, var_21_103)
			local var_21_109 = not var_21_108 or var_21_67

			if var_21_106 then
				if var_21_100 then
					var_21_109 = false
				elseif not var_21_108 and var_21_109 then
					local var_21_110 = ScriptUnit.has_extension(var_21_103, "ghost_mode_system")

					var_21_109 = not var_21_110 or not var_21_110:is_in_ghost_mode()
				end
			elseif var_21_62 and var_21_107 and var_21_108 then
				var_21_109 = false
			end

			if var_21_109 then
				local var_21_111, var_21_112 = var_21_0.calculate_aoe_size(var_21_103, var_21_105)
				local var_21_113 = var_0_4[var_21_103] or var_0_7(var_21_103, 0)
				local var_21_114 = var_21_113 + Vector3(0, 0, math.max(var_21_112 - var_21_111 * 0.5, var_21_112 * 0.5))
				local var_21_115 = var_21_113 + Vector3(0, 0, math.min(var_21_111 * 0.5, var_21_112 * 0.5))
				local var_21_116 = Geometry.closest_point_on_line(arg_21_2, var_21_115, var_21_114) - arg_21_2
				local var_21_117 = math.max(Vector3.length(var_21_116) - var_21_111, 0)
				local var_21_118 = Vector3.normalize(var_21_116)
				local var_21_119 = var_21_35 < var_21_117
				local var_21_120

				if var_21_50 and var_21_51 then
					var_21_120 = math.lerp(var_21_50, var_21_51, arg_21_5)
				end

				local var_21_121 = 1

				if var_21_35 < var_21_117 then
					local var_21_122 = var_21_34 - var_21_35

					if var_21_122 > 0 then
						var_21_121 = 1 - (var_21_117 - var_21_35) / var_21_122

						if var_21_39 then
							var_21_121 = var_21_121 * var_21_121
						end
					end
				end

				if var_21_4 and var_21_47 then
					if var_21_105 and var_21_105.is_hero then
						var_21_49 = var_21_52
						var_21_55 = var_21_52
					else
						var_21_49 = var_21_53
						var_21_55 = var_21_53
					end
				end

				local var_21_123 = (var_21_119 and var_21_55 or var_21_120 or var_21_49 or 0) * var_21_121

				var_21_31 = var_21_31 and math.auto_lerp(var_21_35, var_21_34, var_21_31, 1, math.clamp(var_21_117, var_21_35, var_21_34))

				if HEALTH_ALIVE[var_21_103] then
					var_21_98 = var_21_98 + 1
				end

				local var_21_124 = DamageProfileTemplates[arg_21_4.explosion.damage_profile]
				local var_21_125 = AiUtils.attack_is_shield_blocked(var_21_103, arg_21_1)
				local var_21_126 = var_21_0.aoe_hit_zone(var_21_103, var_21_102)

				if script_data.debug_projectiles then
					QuickDrawerStay:vector(arg_21_2, var_21_116, Colors.get("brown"))
				end

				local var_21_127 = false

				var_21_97:add_aoe_damage_target(var_21_103, arg_21_1, arg_21_2, var_21_125, var_21_56, var_21_126, arg_21_6, var_21_117, var_21_31, var_21_34, var_21_35, var_21_37, var_21_38, var_21_49, var_21_123, var_21_118, arg_21_4.name, arg_21_11, var_21_127, arg_21_12, var_21_98)

				if var_21_1.buff_to_apply and var_21_0.is_player_unit(var_21_103) then
					if not var_21_1.only_facing then
						Managers.state.entity:system("buff_system"):add_buff(var_21_103, var_21_1.buff_to_apply, var_21_103, false)
					else
						local var_21_128 = Unit.local_position(arg_21_1, 0)
						local var_21_129 = var_0_4[var_21_103] or Unit.local_position(var_21_103, 0)
						local var_21_130 = Unit.local_rotation(var_21_103, 0)
						local var_21_131, var_21_132, var_21_133 = Quaternion.to_euler_angles_xyz(var_21_130)
						local var_21_134 = var_21_133 - math.radians_to_degrees(math.angle(var_21_128.x, var_21_128.y, var_21_129.x, var_21_129.y))

						if var_21_134 < 0 then
							var_21_134 = var_21_134 + 360
						end

						if math.abs(90 - var_21_134) < 90 then
							Managers.state.entity:system("buff_system"):add_buff(var_21_103, var_21_1.buff_to_apply, var_21_103, false)
						end
					end
				elseif var_21_1.enemy_debuff and var_21_0.is_enemy(arg_21_1, var_21_103) then
					local var_21_135 = Managers.state.entity:system("buff_system")
					local var_21_136 = var_21_1.enemy_debuff

					for iter_21_3, iter_21_4 in pairs(var_21_136) do
						var_21_135:add_buff(var_21_103, iter_21_4, var_21_103, false)
					end
				end

				if var_21_1.server_hit_func then
					var_21_1.server_hit_func(var_21_103, arg_21_6, arg_21_1, arg_21_2, var_21_1)
				end

				if var_21_1.hit_sound_event and var_21_101 < var_21_99 then
					Managers.state.entity:system("audio_system"):play_audio_unit_event(var_21_1.hit_sound_event, var_21_103)

					var_21_101 = var_21_101 + 1
				end

				if var_21_1.catapult_players and var_21_0.is_player_unit(var_21_103) and not (Managers.player:owner(var_21_103) and not Managers.player:owner(var_21_103):is_player_controlled() and var_21_1.bot_knockback_immunity or false) then
					local var_21_137 = var_21_1.catapult_force
					local var_21_138 = var_21_1.catapult_force_z
					local var_21_139 = var_21_1.catapult_blocked_multiplier

					if var_21_139 then
						local var_21_140 = var_21_0.check_block(arg_21_1, var_21_103, var_21_1.fatigue_type) and var_21_139 or 1

						var_21_137 = var_21_137 * var_21_140
						var_21_138 = var_21_138 * var_21_140
					end

					local var_21_141 = var_21_137 * Vector3.normalize(var_21_116)

					if var_21_138 then
						Vector3.set_z(var_21_141, var_21_138)
					end

					StatusUtils.set_catapulted_network(var_21_103, true, var_21_141)
				end
			end
		end
	end
end

local var_0_32 = {}

DamageUtils.create_taunt = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_4.taunt
	local var_23_1 = AiUtils.broadphase_query(arg_23_3, var_23_0.target_selection_range, var_0_32)
	local var_23_2 = -math.huge
	local var_23_3

	if var_23_1 > 1 then
		for iter_23_0 = 1, var_23_1 do
			local var_23_4 = var_0_32[iter_23_0]
			local var_23_5 = ScriptUnit.extension(var_23_4, "health_system"):current_health()

			if var_23_2 < var_23_5 then
				var_23_3 = var_23_4
				var_23_2 = var_23_5
			end
		end
	end

	local var_23_6 = {
		health_system = {
			attached_unit = var_23_3,
			duration = var_23_0.duration
		},
		death_system = {
			death_reaction_template = "lure_unit"
		}
	}
	local var_23_7 = "units/hub_elements/empty"
	local var_23_8 = Managers.state.unit_spawner:spawn_network_unit(var_23_7, "lure_unit", var_23_6, arg_23_3)

	if var_23_3 then
		World.link_unit(arg_23_0, var_23_8, var_23_3)
	end

	local var_23_9 = Managers.time:time("game")
	local var_23_10 = var_23_9 + var_23_0.duration
	local var_23_11 = AiUtils.broadphase_query(arg_23_3, var_23_0.range, var_0_32)

	for iter_23_1 = 1, var_23_11 do
		local var_23_12 = var_0_32[iter_23_1]

		if var_23_12 ~= var_23_3 then
			local var_23_13 = ScriptUnit.extension(var_23_12, "ai_system")
			local var_23_14 = var_23_13:blackboard()

			if not var_23_13:breed().ignore_taunts then
				var_23_14.taunt_unit = var_23_8
				var_23_14.taunt_end_time = var_23_10
				var_23_14.target_unit = var_23_8
				var_23_14.target_unit_found_time = var_23_9
			end
		end
	end

	return var_23_8
end

DamageUtils.create_aoe = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	local var_24_0 = arg_24_4.aoe
	local var_24_1 = arg_24_5 or var_24_0.radius
	local var_24_2 = arg_24_6 or var_24_0.duration
	local var_24_3 = AiUtils.get_actual_attacker_unit(arg_24_1)
	local var_24_4 = arg_24_4.is_grenade
	local var_24_5 = ScriptUnit.has_extension(var_24_3, "buff_system")

	if var_24_5 then
		local var_24_6 = 1

		if var_24_4 then
			var_24_6 = var_24_6 + (var_24_5:apply_buffs_to_value(1, "grenade_radius") - 1)
		end

		var_24_1 = var_24_1 * (var_24_6 + (var_24_5:apply_buffs_to_value(1, "explosion_radius") - 1))
	end

	local var_24_7 = Managers.player:owner(var_24_3)
	local var_24_8 = true
	local var_24_9 = Managers.mechanism:current_mechanism_name()

	if var_24_7 ~= nil and var_24_9 ~= "versus" then
		local var_24_10 = Managers.state.difficulty:get_difficulty_settings()
		local var_24_11 = var_24_0.no_friendly_fire
		local var_24_12 = DamageUtils.allow_friendly_fire_ranged(var_24_10, var_24_7)

		var_24_8 = var_24_0.allow_friendly_fire or var_24_12 and not var_24_11
	end

	local var_24_13 = {
		area_damage_system = {
			invisible_unit = true,
			aoe_dot_damage = 0,
			aoe_dot_damage_interval = var_24_0.damage_interval,
			radius = var_24_1,
			life_time = var_24_2,
			damage_players = var_24_8,
			player_screen_effect_name = var_24_0.player_screen_effect_name,
			dot_effect_name = var_24_0.effect_name,
			extra_dot_effect_name = var_24_0.extra_effect_name,
			nav_mesh_effect = var_24_0.nav_mesh_effect,
			area_damage_template = var_24_0.area_damage_template or "explosion_template_aoe",
			damage_source = arg_24_3,
			create_nav_tag_volume = var_24_0.create_nav_tag_volume,
			nav_tag_volume_layer = var_24_0.nav_tag_volume_layer,
			explosion_template_name = arg_24_4.name,
			owner_player = var_24_7,
			source_attacker_unit = var_24_3
		}
	}
	local var_24_14 = "units/hub_elements/empty"
	local var_24_15 = Managers.state.unit_spawner:spawn_network_unit(var_24_14, "aoe_unit", var_24_13, arg_24_2)
	local var_24_16 = Managers.state.unit_storage:go_id(var_24_15)

	Unit.set_unit_visibility(var_24_15, false)
	Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", var_24_16, arg_24_2)

	return var_24_15
end

DamageUtils.networkify_damage = function (arg_25_0)
	local var_25_0 = NetworkConstants.damage

	arg_25_0 = math.clamp(arg_25_0, var_25_0.min, var_25_0.max)

	local var_25_1 = arg_25_0 % 1
	local var_25_2 = math.round(var_25_1 * 4) * 0.25

	return math.floor(arg_25_0) + var_25_2
end

DamageUtils.networkify_health = function (arg_26_0)
	local var_26_0 = NetworkConstants.health

	arg_26_0 = math.clamp(arg_26_0, var_26_0.min, var_26_0.max)

	local var_26_1 = arg_26_0 % 1
	local var_26_2 = math.round(var_26_1 * 4) * 0.25

	return math.floor(arg_26_0) + var_26_2
end

DamageUtils.create_hit_zone_lookup = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1.hit_zones
	local var_27_1 = {}
	local var_27_2 = arg_27_1.name

	if not var_27_2 then
		table.dump(arg_27_1, "breed", 2)
		error("breed.name was nil in DamageUtils.create_hit_zone_lookup")
	end

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		for iter_27_2, iter_27_3 in ipairs(iter_27_1.actors) do
			local var_27_3 = var_0_12(arg_27_0, iter_27_3)

			if not var_27_3 then
				printf("Actor %s not found in %s", iter_27_3, var_27_2)
			end

			local var_27_4 = var_0_19(var_27_3)

			var_27_1[var_27_4] = {
				name = iter_27_0,
				prio = iter_27_1.prio,
				actor_name = iter_27_3
			}
			var_27_1[iter_27_0] = var_27_4
			var_27_1[var_27_2] = true
		end
	end

	arg_27_1.hit_zones_lookup = var_27_1
	BreedHitZonesLookup[var_27_2] = var_27_1
end

DamageUtils.vs_register_dark_pact_player_damage = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	local var_28_0 = arg_28_4:owner(arg_28_0)
	local var_28_1 = arg_28_4:owner(arg_28_1)

	if var_28_0 and var_28_1 then
		local var_28_2 = Managers.state.side:versus_is_dark_pact(arg_28_0) or Managers.state.side:versus_is_dark_pact(arg_28_5)
		local var_28_3 = ScriptUnit.has_extension(arg_28_1, "status_system")
		local var_28_4 = var_28_3.is_ledge_hanging or var_28_3.knocked_down

		if arg_28_0 and var_28_2 then
			Managers.state.entity:system("versus_horde_ability_system"):server_ability_recharge_boost(var_28_0.peer_id, nil, arg_28_2, arg_28_3, var_28_4, arg_28_6)
		end
	end
end

DamageUtils.add_damage_network = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9, arg_29_10, arg_29_11, arg_29_12, arg_29_13, arg_29_14, arg_29_15, arg_29_16, arg_29_17, arg_29_18)
	local var_29_0 = Managers.state.network

	if not var_29_0:game() then
		return 0
	end

	local var_29_1 = Managers.state.side.side_by_unit[arg_29_0]

	if DamageUtils.is_in_inn and var_29_1 and var_29_1.VALID_ENEMY_PLAYERS_AND_BOTS[arg_29_0] then
		return 0
	end

	local var_29_2 = Managers.player
	local var_29_3 = var_29_2.is_server

	if var_0_22(arg_29_0, arg_29_4, arg_29_7, arg_29_10) then
		if var_29_3 or LEVEL_EDITOR_TEST then
			Managers.state.achievement:trigger_event("register_damage_resisted_immune", arg_29_0, arg_29_1, arg_29_4)
		end

		return 0
	end

	if var_29_3 and Managers.mechanism:current_mechanism_name() == "versus" then
		DamageUtils.vs_register_dark_pact_player_damage(arg_29_1, arg_29_0, arg_29_7, arg_29_4, var_29_2, arg_29_9)
	end

	local var_29_4 = FrameTable.alloc_table()

	if var_29_3 or LEVEL_EDITOR_TEST then
		local var_29_5, var_29_6, var_29_7 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "hero_damage_taken")

		arg_29_2 = var_29_5 and var_29_7 and var_29_1 and var_29_1:name() == "heroes" and arg_29_2 * var_29_6 or arg_29_2

		local var_29_8 = AiUtils.unit_breed(arg_29_1)

		if var_29_8 and var_29_8.is_hero then
			arg_29_2 = DamageUtils.networkify_damage(arg_29_2)
		end

		arg_29_2 = DamageUtils.apply_buffs_to_damage(arg_29_2, arg_29_0, arg_29_1, arg_29_7, var_29_4, arg_29_4, arg_29_10, arg_29_14, arg_29_9)
	end

	local var_29_9 = DamageUtils.networkify_damage(arg_29_2)

	arg_29_5 = arg_29_5 or Unit.world_position(arg_29_0, 0)
	arg_29_5 = NetworkUtils.network_clamp_position(arg_29_5)

	if HEALTH_ALIVE[arg_29_0] then
		local var_29_10 = ScriptUnit.has_extension(arg_29_1, "buff_system")

		if var_29_10 and not arg_29_17 then
			local var_29_11 = FrameTable.alloc_table()

			var_29_11.damage_amount = var_29_9

			var_29_10:trigger_procs("on_damage_dealt", arg_29_0, arg_29_1, var_29_9, arg_29_3, 0, arg_29_12, arg_29_10, 100, arg_29_7, arg_29_4, arg_29_14, var_29_11)

			var_29_9 = var_29_11.damage_amount
		end

		Managers.state.achievement:trigger_event("on_damage_dealt", arg_29_0, arg_29_1, var_29_9, arg_29_3, 0, arg_29_12, arg_29_10, 100, arg_29_7, arg_29_4, arg_29_14)
	end

	Managers.state.game_mode:game_mode():projectile_hit_character(nil, arg_29_9, arg_29_1, arg_29_0, arg_29_5, nil, arg_29_6, var_29_9)

	if var_29_3 or LEVEL_EDITOR_TEST then
		local var_29_12 = #var_29_4
		local var_29_13 = Managers.time:time("game")

		for iter_29_0 = 1, var_29_12 do
			local var_29_14 = var_29_4[iter_29_0]

			arg_29_4 = var_29_14 == arg_29_0 and arg_29_4 or "buff"

			ScriptUnit.extension(var_29_14, "health_system"):add_damage(arg_29_1, var_29_9, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9, arg_29_11, arg_29_12, arg_29_13, arg_29_14, arg_29_15, arg_29_10, arg_29_16, arg_29_18)

			if not HEALTH_ALIVE[var_29_14] then
				Managers.state.unit_spawner:prioritize_death_watch_unit(arg_29_0, var_29_13)
			end
		end
	else
		local var_29_15, var_29_16 = var_29_0:game_object_or_level_id(arg_29_0)
		local var_29_17, var_29_18 = var_29_0:game_object_or_level_id(arg_29_1)
		local var_29_19 = var_29_0:unit_game_object_id(arg_29_9) or NetworkConstants.invalid_game_object_id
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

		var_29_0.network_transmit:send_rpc_server("rpc_add_damage_network", var_29_15, var_29_16, var_29_17, var_29_18, var_29_19, var_29_9, var_29_20, var_29_21, arg_29_5, arg_29_6, var_29_22, var_29_23, arg_29_12, arg_29_13, arg_29_14, arg_29_15, arg_29_16, arg_29_18)
	end

	return var_29_9
end

DamageUtils.get_damage_type = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.targets and arg_30_0.targets[arg_30_1] or arg_30_0.default_target
	local var_30_1 = var_30_0.attack_template
	local var_30_2 = DamageUtils.get_attack_template(var_30_1)

	return var_30_0.damage_type or arg_30_0.damage_type or var_30_2.damage_type
end

DamageUtils.add_damage_network_player = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10, arg_31_11, arg_31_12, arg_31_13, arg_31_14, arg_31_15, arg_31_16)
	if not Managers.state.network:game() then
		return 0
	end

	local var_31_0 = Managers.state.side.side_by_unit[arg_31_3]

	if DamageUtils.is_in_inn and var_31_0 and var_31_0.VALID_ENEMY_PLAYERS_AND_BOTS[arg_31_3] then
		return 0
	end

	local var_31_1 = Managers.player
	local var_31_2 = var_31_1:owner(arg_31_4)

	if var_31_2 and var_31_2.bot_player and not DamageUtils.can_bots_damage(arg_31_3) then
		return 0
	end

	if Managers.mechanism:current_mechanism_name() == "versus" and arg_31_4 and Managers.state.side:versus_is_dark_pact(arg_31_4) then
		if not DamageUtils.vs_dark_pact_can_damage(arg_31_4, arg_31_3) then
			return 0
		end

		DamageUtils.vs_register_dark_pact_player_damage(arg_31_4, arg_31_3, arg_31_8, nil, var_31_1)
	end

	local var_31_3 = DamageUtils.get_damage_type(arg_31_0, arg_31_1)

	if arg_31_0.instant_death and DamageUtils.is_ai(arg_31_3) then
		AiUtils.kill_unit(arg_31_3, arg_31_4, arg_31_5, var_31_3, arg_31_7, arg_31_8)

		return 0
	end

	local var_31_4 = arg_31_0.charge_value

	if var_0_22(arg_31_3, var_31_3, arg_31_8, var_31_4) then
		return 0
	end

	local var_31_5 = ScriptUnit.has_extension(arg_31_3, "ghost_mode_system")

	if var_31_5 and var_31_5:is_in_ghost_mode() then
		return 0
	end

	local var_31_6 = arg_31_0.targets and arg_31_0.targets[arg_31_1] or arg_31_0.default_target
	local var_31_7 = BoostCurves[var_31_6.boost_curve_type]
	local var_31_8 = DamageUtils.calculate_damage(DamageOutput, arg_31_3, arg_31_4, arg_31_5, arg_31_2, var_31_7, arg_31_10, arg_31_11, arg_31_0, arg_31_1, arg_31_15, arg_31_8)
	local var_31_9 = FrameTable.alloc_table()
	local var_31_10 = NetworkConstants.damage.max
	local var_31_11 = DamageUtils.apply_buffs_to_damage(var_31_8, arg_31_3, arg_31_4, arg_31_8, var_31_9, var_31_3, var_31_4, arg_31_13, arg_31_16)

	arg_31_6 = arg_31_6 or Unit.world_position(arg_31_3, 0)
	arg_31_6 = NetworkUtils.network_clamp_position(arg_31_6)

	local var_31_12 = arg_31_4 and ScriptUnit.has_extension(arg_31_4, "buff_system")
	local var_31_13 = arg_31_16 and ScriptUnit.has_extension(arg_31_16, "buff_system")

	if (var_31_12 or var_31_13) and HEALTH_ALIVE[arg_31_3] then
		local var_31_14 = rawget(ItemMasterList, arg_31_8)
		local var_31_15 = var_31_14 and var_31_14.template
		local var_31_16 = "other"
		local var_31_17 = var_31_11

		if var_31_15 then
			local var_31_18 = WeaponUtils.get_weapon_template(var_31_15).buff_type

			var_31_17 = DamageUtils.calculate_damage(DamageOutput, arg_31_3, arg_31_4, "torso", arg_31_2, var_31_7, arg_31_10, false, arg_31_0, arg_31_1, arg_31_15, arg_31_8)
		end

		if arg_31_0.deal_min_damage then
			var_31_11 = math.max(var_31_11, 0.25)
		end

		local var_31_19 = FrameTable.alloc_table()

		var_31_19.damage_amount = var_31_11

		local var_31_20 = var_31_12 or var_31_13

		var_31_20:trigger_procs("on_player_damage_dealt", arg_31_3, var_31_11, arg_31_5, var_31_17, arg_31_11, var_31_4, arg_31_1, arg_31_8, arg_31_13, var_31_19)
		var_31_20:trigger_procs("on_damage_dealt", arg_31_3, arg_31_4, var_31_11, arg_31_5, var_31_17, arg_31_11, var_31_4, arg_31_1, arg_31_8, var_31_3, arg_31_13, var_31_19)

		var_31_11 = var_31_19.damage_amount
	end

	if var_31_1.is_server or LEVEL_EDITOR_TEST then
		local var_31_21 = #var_31_9
		local var_31_22, var_31_23, var_31_24 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "hero_damage_taken")

		var_31_11 = var_31_22 and var_31_24 and var_31_0 and var_31_0:name() == "heroes" and var_31_11 * var_31_23 or var_31_11

		local var_31_25 = Managers.time:time("game")

		for iter_31_0 = 1, var_31_21 do
			local var_31_26 = var_31_9[iter_31_0]

			var_31_3 = var_31_26 == arg_31_3 and var_31_3 or "buff"

			local var_31_27 = ScriptUnit.extension(var_31_26, "health_system")

			if var_31_10 < var_31_11 then
				local var_31_28 = math.floor(var_31_11 / var_31_10)

				for iter_31_1 = 1, var_31_28 do
					var_31_27:add_damage(arg_31_4, var_31_10, arg_31_5, var_31_3, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_16, nil, arg_31_11, arg_31_12, arg_31_13, arg_31_14, var_31_4, arg_31_15, arg_31_1)
				end

				var_31_11 = var_31_11 - var_31_10 * var_31_28
			end

			local var_31_29 = DamageUtils.networkify_damage(var_31_11)

			var_31_27:add_damage(arg_31_4, var_31_29, arg_31_5, var_31_3, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_16, nil, arg_31_11, arg_31_12, arg_31_13, arg_31_14, var_31_4, arg_31_15, arg_31_1)

			if not HEALTH_ALIVE[var_31_26] then
				Managers.state.unit_spawner:prioritize_death_watch_unit(arg_31_3, var_31_25)
			end
		end
	end

	return var_31_11
end

local var_0_33 = 0.1
local var_0_34 = {
	"headshot",
	"weakspot"
}

DamageUtils.handle_hit_indication = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	local var_32_0 = ScriptUnit.has_extension(arg_32_0, "hud_system")

	if var_32_0 and HEALTH_ALIVE[arg_32_1] and arg_32_0 ~= arg_32_1 then
		local var_32_1 = var_32_0.hit_marker_data
		local var_32_2 = Managers.time:time("game")
		local var_32_3 = 1

		if var_32_1.hit_marker_timestamp then
			var_32_3 = var_32_2 - var_32_1.hit_marker_timestamp
		end

		if var_32_3 > var_0_33 then
			local var_32_4 = AiUtils.unit_breed(arg_32_1)
			local var_32_5 = var_0_5(arg_32_1, "armor")
			local var_32_6, var_32_7, var_32_8, var_32_9 = ActionUtils.get_target_armor(arg_32_3, var_32_4, var_32_5)
			local var_32_10 = DamageUtils.is_character(arg_32_1) and not DamageUtils.is_enemy(arg_32_0, arg_32_1)
			local var_32_11 = DamageUtils.get_breed_damage_multiplier_type(var_32_4, arg_32_3)
			local var_32_12 = table.contains(var_0_34, var_32_11)
			local var_32_13 = var_32_4 and var_32_4.armored_on_no_damage

			var_32_1.shield_break = arg_32_6
			var_32_1.shield_open = false
			var_32_1.hit_enemy = true
			var_32_1.friendly_fire = var_32_10
			var_32_1.damage_amount = arg_32_2
			var_32_1.hit_zone = arg_32_3
			var_32_1.hit_critical = var_32_12
			var_32_1.has_armor = var_32_13 or var_32_8 == 6 or var_32_6 == 2 or var_32_6 == 0
			var_32_1.hit_marker_timestamp = var_32_2
			var_32_1.added_dot = arg_32_4
			var_32_1.invulnerable = arg_32_5
		end
	end
end

DamageUtils.get_item_buff_type = function (arg_33_0)
	local var_33_0 = rawget(ItemMasterList, arg_33_0)
	local var_33_1 = var_33_0 and var_33_0.template or var_33_0.temporary_template
	local var_33_2

	if var_33_1 then
		var_33_2 = WeaponUtils.get_weapon_template(var_33_1).buff_type
	end

	return var_33_2 or "n/a"
end

DamageUtils.buff_on_attack = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9)
	local var_34_0 = ScriptUnit.has_extension(arg_34_0, "buff_system")

	if not var_34_0 then
		return false
	end

	if not HEALTH_ALIVE[arg_34_1] then
		return false
	end

	local var_34_1 = ScriptUnit.has_extension(arg_34_1, "buff_system")
	local var_34_2 = Managers.state.side:is_enemy(arg_34_0, arg_34_1)

	if var_34_2 then
		if RangedAttackTypes[arg_34_2] then
			var_34_0:trigger_procs("on_ranged_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)

			if var_34_1 then
				var_34_1:trigger_procs("on_hit_by_ranged", arg_34_0, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)
			end
		else
			var_34_0:trigger_procs("on_melee_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)
		end

		var_34_0:trigger_procs("on_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)
		Managers.state.achievement:trigger_event("on_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8, arg_34_0, arg_34_9)
		Managers.state.event:trigger("on_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8, arg_34_0)

		if var_34_1 then
			var_34_1:trigger_procs("on_hit_by_other", arg_34_0, arg_34_2, arg_34_4, arg_34_5, arg_34_7, arg_34_3, arg_34_8)
		end
	end

	if arg_34_3 and var_34_2 then
		var_34_0:trigger_procs("on_critical_hit", arg_34_1, arg_34_2, arg_34_4, arg_34_5, arg_34_7)
	end

	if arg_34_6 and not Managers.player.is_server then
		local var_34_3 = Managers.state.network
		local var_34_4 = var_34_3:unit_game_object_id(arg_34_0)
		local var_34_5 = var_34_3:unit_game_object_id(arg_34_1)
		local var_34_6 = NetworkLookup.buff_attack_types[arg_34_2]
		local var_34_7 = NetworkLookup.hit_zones[arg_34_4]
		local var_34_8 = NetworkLookup.buff_weapon_types[arg_34_7]
		local var_34_9 = NetworkLookup.damage_sources[arg_34_9 or "undefined"]

		if var_34_5 then
			var_34_3.network_transmit:send_rpc_server("rpc_buff_on_attack", var_34_4, var_34_5, var_34_6, arg_34_3, var_34_7, arg_34_5, var_34_8, var_34_9)
		end
	end

	return true
end

local var_0_35 = {
	wounded_dot = true,
	suicide = true,
	knockdown_bleed = true
}
local var_0_36 = {
	temporary_health_degen = true,
	overcharge = true,
	life_tap = true,
	ground_impact = true,
	life_drain = true
}
local var_0_37 = {
	temporary_health_degen = true,
	overcharge = true,
	life_tap = true,
	ground_impact = true,
	life_drain = true
}
local var_0_38 = {
	temporary_health_degen = true,
	suicide = true,
	life_tap = true
}

DamageUtils.apply_buffs_to_damage = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8)
	local var_35_0 = arg_35_0
	local var_35_1 = Managers.state.network
	local var_35_2 = ScriptUnit.has_extension(arg_35_2, "buff_system") or ScriptUnit.has_extension(arg_35_8, "buff_system")

	if var_35_2 then
		var_35_2:trigger_procs("damage_calculation_started", arg_35_1)
	end

	local var_35_3 = Managers.player:owner(arg_35_1)
	local var_35_4 = Managers.player:owner(arg_35_2)

	if var_35_3 then
		var_35_0 = Managers.state.game_mode:modify_player_base_damage(arg_35_1, arg_35_2, var_35_0, arg_35_5)
	end

	arg_35_4[#arg_35_4 + 1] = arg_35_1

	local var_35_5 = ScriptUnit.extension(arg_35_1, "health_system")

	if var_35_5:has_assist_shield() and not var_0_35[arg_35_3] then
		local var_35_6 = var_35_1:unit_game_object_id(arg_35_1)

		var_35_1.network_transmit:send_rpc_clients("rpc_remove_assist_shield", var_35_6)
	end

	if ScriptUnit.has_extension(arg_35_1, "buff_system") then
		local var_35_7 = ScriptUnit.extension(arg_35_1, "buff_system")

		if SKAVEN[arg_35_3] then
			var_35_0 = var_35_7:apply_buffs_to_value(var_35_0, "protection_skaven")
		elseif CHAOS[arg_35_3] or BEASTMEN[arg_35_3] then
			var_35_0 = var_35_7:apply_buffs_to_value(var_35_0, "protection_chaos")
		end

		if DAMAGE_TYPES_AOE[arg_35_5] then
			var_35_0 = var_35_7:apply_buffs_to_value(var_35_0, "protection_aoe")
		end

		if not var_0_38[arg_35_3] then
			var_35_0 = var_35_7:apply_buffs_to_value(var_35_0, "damage_taken")

			if ELITES[arg_35_3] then
				var_35_0 = var_35_7:apply_buffs_to_value(var_35_0, "damage_taken_elites")
			end
		end

		if RangedAttackTypes[arg_35_6] then
			var_35_0 = var_35_7:apply_buffs_to_value(var_35_0, "damage_taken_ranged")
		elseif MeleeAttackTypes[arg_35_6] then
			var_35_0 = var_35_7:apply_buffs_to_value(var_35_0, "damage_taken_melee")
		end

		local var_35_8 = var_35_3 and ScriptUnit.has_extension(arg_35_1, "status_system")

		if var_35_8 then
			local var_35_9 = var_35_8:is_knocked_down()

			if var_35_9 then
				var_35_0 = arg_35_5 ~= "overcharge" and var_35_7:apply_buffs_to_value(var_35_0, "damage_taken_kd") or 0
			end

			if not var_35_8:is_disabled() and not var_0_36[arg_35_3] and var_35_0 > 0 and not var_35_9 then
				local var_35_10 = var_35_0
				local var_35_11 = var_35_7:apply_buffs_to_value(var_35_0, "damage_taken_to_overcharge")

				if var_35_11 < var_35_10 then
					local var_35_12 = var_35_10 - var_35_11
					local var_35_13 = var_35_7:apply_buffs_to_value(var_35_12, "reduced_overcharge_from_passive")
					local var_35_14 = DamageUtils.networkify_damage(var_35_13)

					if var_35_3.remote then
						local var_35_15 = var_35_3.peer_id
						local var_35_16 = var_35_1:unit_game_object_id(arg_35_1)
						local var_35_17 = PEER_ID_TO_CHANNEL[var_35_15]

						RPC.rpc_damage_taken_overcharge(var_35_17, var_35_16, var_35_14)
					else
						DamageUtils.apply_damage_to_overcharge(arg_35_1, var_35_14)
					end

					var_35_0 = var_35_11
				end
			end
		end

		if var_35_2 then
			if arg_35_6 == AttackTypes.grenade or DamageUtils.attacker_is_fire_bomb(arg_35_2) then
				var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "explosion_damage")
			end

			if var_35_2:has_buff_perk("burning") or var_35_2:has_buff_perk("burning_balefire") or var_35_2:has_buff_perk("burning_elven_magic") then
				local var_35_18 = Managers.state.side.side_by_unit[arg_35_1]

				if var_35_18 then
					local var_35_19 = var_35_18.PLAYER_AND_BOT_UNITS
					local var_35_20 = #var_35_19

					for iter_35_0 = 1, var_35_20 do
						local var_35_21 = var_35_19[iter_35_0]
						local var_35_22 = ScriptUnit.has_extension(var_35_21, "talent_system")

						if var_35_22 and var_35_22:has_talent("sienna_unchained_burning_enemies_reduced_damage") then
							var_35_0 = var_35_0 * (1 + BuffUtils.get_buff_template("sienna_unchained_burning_enemies_reduced_damage").buffs[1].multiplier)

							break
						end
					end
				end
			end
		end

		local var_35_23 = var_35_7:get_buff_value("max_damage_taken_from_boss_or_elite")
		local var_35_24 = var_35_7:get_buff_value("max_damage_taken")

		if var_35_7:has_buff_perk("anti_oneshot") then
			local var_35_25 = var_35_5:get_max_health() * 0.3

			if var_35_25 < var_35_0 then
				var_35_0 = var_35_25
			end
		end

		local var_35_26 = ALIVE[arg_35_2] and var_0_5(arg_35_2, "breed")

		if var_35_26 and (var_35_26.boss or var_35_26.elite) then
			local var_35_27

			if var_35_23 and var_35_24 then
				var_35_27 = math.min(var_35_23, var_35_24)
			else
				var_35_27 = var_35_23 and var_35_23 or var_35_24
			end

			if var_35_27 and var_35_27 <= var_35_0 then
				var_35_0 = math.max(var_35_0 * 0.5, var_35_27)
			end
		elseif var_35_24 and var_35_24 <= var_35_0 then
			var_35_0 = math.max(var_35_0 * 0.5, var_35_24)
		end

		if var_35_7:has_buff_type("shared_health_pool") and not var_0_35[arg_35_3] then
			local var_35_28 = Managers.state.side.side_by_unit[arg_35_1].PLAYER_AND_BOT_UNITS
			local var_35_29 = #var_35_28
			local var_35_30 = 1

			for iter_35_1 = 1, var_35_29 do
				local var_35_31 = var_35_28[iter_35_1]

				if var_35_31 ~= arg_35_1 and ScriptUnit.extension(var_35_31, "buff_system"):has_buff_type("shared_health_pool") then
					var_35_30 = var_35_30 + 1
					arg_35_4[#arg_35_4 + 1] = var_35_31
				end
			end

			var_35_0 = var_35_0 / var_35_30
		end

		local var_35_32 = ScriptUnit.has_extension(arg_35_1, "talent_system")

		if var_35_32 and var_35_32:has_talent("bardin_ranger_reduced_damage_taken_headshot") and var_0_4[arg_35_2] and AiUtils.unit_is_flanking_player(arg_35_2, arg_35_1) and not var_35_7:has_buff_type("bardin_ranger_reduced_damage_taken_headshot_buff") then
			var_35_0 = var_35_0 * (1 + BuffUtils.get_buff_template("bardin_ranger_reduced_damage_taken_headshot_buff").buffs[1].multiplier)
		end

		local var_35_33 = var_35_7:has_buff_perk("invulnerable")
		local var_35_34 = var_35_7:has_buff_type("bardin_ironbreaker_gromril_armour")
		local var_35_35 = var_35_7:has_buff_type("metal_mutator_gromril_armour")
		local var_35_36 = not var_0_37[arg_35_3]
		local var_35_37 = Managers.state.side.side_by_unit[arg_35_1]

		if var_35_37 and var_35_37:name() == "dark_pact" then
			var_35_33 = var_35_33 or arg_35_3 == "ground_impact"
		end

		if var_35_33 or (var_35_34 or var_35_35) and var_35_36 then
			var_35_0 = 0
		end

		if var_35_34 and var_35_36 and arg_35_0 > 0 then
			local var_35_38 = var_35_7:get_non_stacking_buff("bardin_ironbreaker_gromril_armour").id

			var_35_7:remove_buff(var_35_38)
			var_35_7:trigger_procs("on_gromril_armour_removed")

			local var_35_39 = var_35_1:unit_game_object_id(arg_35_1)

			var_35_1.network_transmit:send_rpc_clients("rpc_remove_gromril_armour", var_35_39)
		end

		if var_35_7:has_buff_type("invincibility_standard") then
			local var_35_40 = var_35_7:get_non_stacking_buff("invincibility_standard")

			if not var_35_40.applied_damage then
				var_35_40.stored_damage = not var_35_40.stored_damage and var_35_0 or var_35_40.stored_damage + var_35_0
				var_35_0 = 0
			end
		end
	end

	if var_35_2 then
		local var_35_41 = ScriptUnit.has_extension(arg_35_1, "buff_system")

		if var_35_4 then
			local var_35_42 = rawget(ItemMasterList, arg_35_3)
			local var_35_43 = var_35_42 and var_35_42.template

			if var_35_43 then
				local var_35_44 = WeaponUtils.get_weapon_template(var_35_43)
				local var_35_45 = var_35_44.buff_type

				if var_35_45 then
					var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_weapon_damage")

					if var_35_2:has_buff_perk("missing_health_damage") then
						var_35_0 = var_35_0 * (1 + (1 - ScriptUnit.extension(arg_35_1, "health_system"):current_health_percent()) / 2)
					end
				end

				local var_35_46 = MeleeBuffTypes[var_35_45]
				local var_35_47 = RangedBuffTypes[var_35_45]

				if var_35_46 then
					var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_weapon_damage_melee")

					if var_35_45 == "MELEE_1H" then
						var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_weapon_damage_melee_1h")
					elseif var_35_45 == "MELEE_2H" then
						var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_weapon_damage_melee_2h")
					end

					if arg_35_6 == "heavy_attack" then
						var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_weapon_damage_heavy_attack")
					end

					if arg_35_7 then
						var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "first_melee_hit_damage")
					end
				elseif var_35_47 then
					var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_weapon_damage_ranged")

					local var_35_48 = ScriptUnit.extension(arg_35_1, "health_system")

					if var_35_48:current_health_percent() <= 0.9 or var_35_48:current_max_health_percent() <= 0.9 then
						var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_weapon_damage_ranged_to_wounded")
					end
				end

				local var_35_49 = var_35_44.weapon_type

				if var_35_49 then
					local var_35_50 = WeaponSpecificStatBuffs[var_35_49].damage

					var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, var_35_50)
				end

				if var_35_46 or var_35_47 then
					var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "reduced_non_burn_damage")
				end
			end

			if var_35_41 and (var_35_41:has_buff_perk("poisoned") or var_35_41:has_buff_perk("bleeding")) then
				var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_weapon_damage_poisoned_or_bleeding")
			end

			if arg_35_5 == "burninating" then
				var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_burn_dot_damage")
			end
		end

		var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "damage_dealt")

		local var_35_51, var_35_52 = Managers.state.status_effect:has_status(arg_35_1, StatusEffectNames.burning_balefire)

		if var_35_51 and not var_35_52 then
			var_35_0 = var_35_2:apply_buffs_to_value(var_35_0, "increased_damage_to_balefire")
		end
	end

	Managers.state.game_mode:damage_taken(arg_35_1, arg_35_2, var_35_0, arg_35_3, arg_35_5)

	if var_35_2 then
		var_35_2:trigger_procs("damage_calculation_ended", arg_35_1)
	end

	return var_35_0
end

DamageUtils.apply_damage_to_overcharge = function (arg_36_0, arg_36_1)
	local var_36_0 = ScriptUnit.has_extension(arg_36_0, "overcharge_system")

	if var_36_0 then
		var_36_0:add_charge(arg_36_1, nil, "damage_to_overcharge")
	end
end

DamageUtils.assist_shield_network = function (arg_37_0, arg_37_1, arg_37_2)
	assert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_37_0, "health_system"):shield(arg_37_2)
	ScriptUnit.extension(arg_37_0, "status_system"):set_shielded(true)

	if not LEVEL_EDITOR_TEST then
		local var_37_0 = Managers.state.network
		local var_37_1 = var_37_0:unit_game_object_id(arg_37_0)
		local var_37_2, var_37_3 = var_37_0:game_object_or_level_id(arg_37_1)
		local var_37_4 = NetworkLookup.heal_types.shield_by_assist

		var_37_0.network_transmit:send_rpc_clients("rpc_heal", var_37_1, false, var_37_2, var_37_3, arg_37_2, var_37_4)
	end
end

local var_0_39 = {}

DamageUtils.heal_network = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST, "Only server can heal")

	local var_38_0 = ScriptUnit.has_extension(arg_38_0, "buff_system")

	if var_38_0 and var_38_0:has_buff_perk("healing_immune") then
		return
	end

	table.clear(var_0_39)

	local var_38_1, var_38_2 = DamageUtils.apply_buffs_to_heal(arg_38_0, arg_38_1, arg_38_2, arg_38_3, var_0_39)
	local var_38_3 = DamageUtils.networkify_damage(var_38_1)

	if arg_38_0 == arg_38_1 and (arg_38_3 == "healing_draught" or arg_38_3 == "healing_draught_temp_health") and ScriptUnit.extension(arg_38_0, "health_system"):current_permanent_health() > 80 then
		local var_38_4 = ScriptUnit.extension(arg_38_0, "dialogue_system").context.player_profile

		SurroundingAwareSystem.add_event(arg_38_0, "early_healing_draught", DialogueSettings.default_view_distance, "target_name", var_38_4)
	end

	if var_38_3 > 0 then
		if arg_38_0 ~= arg_38_1 then
			ScriptUnit.extension(arg_38_1, "buff_system"):trigger_procs("on_healed_ally", arg_38_0, var_38_3, arg_38_3)
		end

		local var_38_5 = #var_0_39

		for iter_38_0 = 1, var_38_5 do
			local var_38_6 = var_0_39[iter_38_0]

			arg_38_3 = var_38_2 and ("buff_shared_medpack" or "buff_shared_medpack_temp_health") or var_38_6 == arg_38_0 and arg_38_3 or "buff"

			ScriptUnit.extension(var_38_6, "health_system"):add_heal(arg_38_1, var_38_3, nil, arg_38_3)

			local var_38_7 = ScriptUnit.has_extension(var_38_6, "status_system")

			if var_38_7 then
				var_38_7:healed(arg_38_3)
			end

			local var_38_8 = ScriptUnit.extension(var_38_6, "buff_system")

			var_38_8:trigger_procs("on_healed", arg_38_1, var_38_3, arg_38_3)

			if arg_38_3 == "healing_draught" or arg_38_3 == "bandage" or arg_38_3 == "healing_draught_temp_health" or arg_38_3 == "bandage_temp_health" or arg_38_3 == "bandage_trinket" then
				var_38_8:trigger_procs("on_healed_consumeable", arg_38_1, var_38_3, arg_38_3)
			end

			if not LEVEL_EDITOR_TEST and var_38_7 and var_38_7:heal_can_remove_wounded(arg_38_3) then
				StatusUtils.set_wounded_network(var_38_6, false, "healed")
			end
		end
	else
		local var_38_9 = #var_0_39

		for iter_38_1 = 1, var_38_9 do
			local var_38_10 = var_0_39[iter_38_1]
			local var_38_11 = ScriptUnit.has_extension(var_38_10, "status_system")

			if not LEVEL_EDITOR_TEST and var_38_11 and var_38_11:is_wounded() and var_38_11:heal_can_remove_wounded(arg_38_3) then
				StatusUtils.set_wounded_network(var_38_10, false, "healed")
			end
		end
	end
end

DamageUtils.apply_buffs_to_heal = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	local var_39_0 = false

	arg_39_4[#arg_39_4 + 1] = arg_39_0

	if ScriptUnit.has_extension(arg_39_0, "buff_system") then
		local var_39_1 = ScriptUnit.extension(arg_39_0, "buff_system")

		if arg_39_3 ~= "raw_heal" and arg_39_3 ~= "health_conversion" then
			arg_39_2 = var_39_1:apply_buffs_to_value(arg_39_2, "healing_received")
		end

		if var_39_1:has_buff_type("shared_health_pool") then
			local var_39_2 = Managers.state.side.side_by_unit[arg_39_0].PLAYER_AND_BOT_UNITS
			local var_39_3 = #var_39_2
			local var_39_4 = 1

			for iter_39_0 = 1, var_39_3 do
				local var_39_5 = var_39_2[iter_39_0]

				if var_39_5 ~= arg_39_0 and ScriptUnit.extension(var_39_5, "buff_system"):has_buff_type("shared_health_pool") then
					var_39_4 = var_39_4 + 1
					arg_39_4[#arg_39_4 + 1] = var_39_5
				end
			end

			arg_39_2 = arg_39_2 / var_39_4

			if arg_39_3 == "bandage" or arg_39_3 == "healing_draught" then
				var_39_0 = true
			end
		end
	end

	return arg_39_2, var_39_0
end

DamageUtils.debug_heal = function (arg_40_0, arg_40_1)
	if Managers.player.is_server then
		DamageUtils.heal_network(arg_40_0, arg_40_0, arg_40_1, "debug")
	else
		local var_40_0 = Managers.state.network
		local var_40_1 = var_40_0.network_transmit
		local var_40_2 = var_40_0:unit_game_object_id(arg_40_0)
		local var_40_3 = NetworkLookup.heal_types.debug

		var_40_1:send_rpc_server("rpc_request_heal", var_40_2, arg_40_1, var_40_3)
	end
end

DamageUtils.debug_deal_damage = function (arg_41_0, arg_41_1)
	if not ALIVE[arg_41_0] then
		return
	end

	DamageUtils.add_damage_network(arg_41_0, arg_41_0, arg_41_1, "torso", "undefined", nil, Vector3(0, 0, 1), "debug", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
end

DamageUtils.check_distance = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = arg_42_1.breed
	local var_42_1 = var_0_4[arg_42_2]
	local var_42_2 = var_0_4[arg_42_3] or Unit.world_position(arg_42_3, 0)

	if not var_42_2 then
		return false
	end

	local var_42_3 = var_42_2 - var_42_1
	local var_42_4 = ScriptUnit.has_extension(arg_42_3, "ai_system")
	local var_42_5 = arg_42_1.is_player and not var_42_4 and status_extension:breed_action() or arg_42_1.action
	local var_42_6 = 1

	if arg_42_1.target_dodged_during_attack or arg_42_1.set_dodge_rotation_timer or arg_42_1.locked_attack_rotation then
		var_42_6 = var_42_6 * (var_42_5.player_dodged_radius or var_42_0.player_dodged_radius or 0.75)
	end

	if arg_42_0.use_box_range then
		local var_42_7 = var_42_3.x
		local var_42_8 = var_42_3.y
		local var_42_9 = var_42_3.z
		local var_42_10 = arg_42_1.attack_range_flat + var_42_6

		if var_42_9 < arg_42_1.attack_range_up and var_42_9 > arg_42_1.attack_range_down and var_42_7 * var_42_7 + var_42_8 * var_42_8 < var_42_10 * var_42_10 then
			return true
		end
	elseif Vector3.length(var_42_3) <= (var_42_5.weapon_reach or var_42_0.weapon_reach or var_42_0.radius) + var_42_6 then
		return true
	end

	return false
end

DamageUtils.check_infront = function (arg_43_0, arg_43_1)
	local var_43_0 = var_0_4[arg_43_0]
	local var_43_1 = var_0_4[arg_43_1] or Unit.world_position(arg_43_1, 0)

	if not var_43_1 or not var_43_0 then
		return false
	end

	local var_43_2 = Vector3.flat(var_43_1 - var_43_0)
	local var_43_3 = var_0_8(arg_43_0, 0)
	local var_43_4 = Quaternion.forward(var_43_3)
	local var_43_5 = Vector3.dot(Vector3.normalize(var_43_2), var_43_4)
	local var_43_6 = var_0_2[arg_43_0]
	local var_43_7 = var_43_6.breed
	local var_43_8 = ScriptUnit.has_extension(arg_43_1, "ai_system")
	local var_43_9 = ScriptUnit.has_extension(arg_43_1, "status_system")
	local var_43_10 = var_43_6.is_player and not var_43_8 and var_43_9:breed_action() or var_43_6.action
	local var_43_11 = 0.866

	if var_43_6.target_dodged_during_attack or var_43_6.set_dodge_rotation_timer or var_43_6.locked_attack_rotation then
		var_43_11 = var_43_10.player_dodged_cone or var_43_7.player_dodged_cone or 0.95
	end

	if var_43_5 > (var_43_7.weapon_reach_cone or var_43_11) then
		return true
	end

	return false
end

DamageUtils.check_block = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if arg_44_0 == arg_44_1 then
		return false
	end

	if type(arg_44_2) == "table" then
		arg_44_2 = Managers.state.difficulty:get_difficulty_value_from_table(arg_44_2)
	end

	local var_44_0 = Managers.state.network
	local var_44_1, var_44_2 = var_44_0:game_object_or_level_id(arg_44_1)

	if var_44_2 then
		return false
	elseif DamageUtils.is_ai(arg_44_1) and AiUtils.attack_is_shield_blocked(arg_44_1, arg_44_0, false, arg_44_3) then
		local var_44_3 = var_0_2[arg_44_0]
		local var_44_4 = var_44_3.action

		var_44_3.blocked = not (var_44_4 and var_44_4.no_block_stagger)

		return true
	end

	local var_44_5 = ScriptUnit.has_extension(arg_44_1, "status_system")

	if var_44_5 then
		local var_44_6 = var_44_5:is_blocking()
		local var_44_7, var_44_8, var_44_9, var_44_10 = var_44_5:can_block(arg_44_0, arg_44_3)
		local var_44_11 = ScriptUnit.has_extension(arg_44_1, "buff_system")
		local var_44_12 = var_44_11 and var_44_11:has_buff_perk("invulnerable")

		if var_44_6 and var_44_7 and not var_44_12 then
			local var_44_13 = ScriptUnit.has_extension(arg_44_0, "buff_system")

			if Managers.player.is_server and var_44_13 and var_44_13:has_buff_perk("ai_unblockable") then
				var_0_2[arg_44_0].hit_through_block = true

				return false
			end

			var_44_5:blocked_attack(arg_44_2, arg_44_0, var_44_8, var_44_9, var_44_10)

			if not LEVEL_EDITOR_TEST and Managers.player.is_server then
				local var_44_14 = Managers.state.unit_storage:go_id(arg_44_1)
				local var_44_15 = NetworkLookup.fatigue_types[arg_44_2]
				local var_44_16, var_44_17 = var_44_0:game_object_or_level_id(arg_44_0)

				var_44_0.network_transmit:send_rpc_clients("rpc_player_blocked_attack", var_44_14, var_44_15, var_44_16, var_44_8, var_44_9, var_44_10, var_44_17)

				local var_44_18 = var_0_2[arg_44_0]
				local var_44_19 = ScriptUnit.has_extension(arg_44_1, "ai_system")
				local var_44_20 = var_44_18.is_player and not var_44_19 and var_44_5:breed_action() or var_44_18.action

				if var_44_20 and var_44_20.no_block_stagger then
					-- Nothing
				elseif not var_44_18.stagger then
					var_44_18.blocked = true
				end
			end

			return true
		end
	end

	return false
end

DamageUtils.check_ranged_block = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = ScriptUnit.extension(arg_45_1, "status_system")
	local var_45_1 = var_45_0:is_blocking()
	local var_45_2, var_45_3, var_45_4, var_45_5 = var_45_0:can_block(arg_45_0)
	local var_45_6
	local var_45_7

	if arg_45_0 then
		local var_45_8 = AiUtils.unit_breed(arg_45_0)

		if var_45_8 then
			var_45_7 = var_45_8.blockable_ranged_attack
		end
	end

	if var_45_1 and var_45_2 and var_45_4 then
		local var_45_9 = ScriptUnit.has_extension(arg_45_0, "buff_system")

		if Managers.player.is_server and var_45_9 and var_45_9:has_buff_perk("ai_unblockable") then
			var_0_2[arg_45_0].hit_through_block = true

			return false
		end

		local var_45_10 = ScriptUnit.extension(arg_45_1, "inventory_system"):get_wielded_slot_item_template()

		if not var_45_10 then
			return false
		end

		if not var_45_10.can_block_ranged_attacks and not var_45_7 then
			return false
		end

		var_45_0:blocked_attack(arg_45_2, arg_45_0, var_45_3, false)

		if not LEVEL_EDITOR_TEST then
			local var_45_11 = Managers.state.network
			local var_45_12 = Managers.state.unit_storage:go_id(arg_45_1)
			local var_45_13 = NetworkLookup.fatigue_types[arg_45_2]
			local var_45_14, var_45_15 = var_45_11:game_object_or_level_id(arg_45_0)

			if Managers.player.is_server then
				var_45_11.network_transmit:send_rpc_clients("rpc_player_blocked_attack", var_45_12, var_45_13, var_45_14, var_45_3, var_45_4, "back", var_45_15)
			else
				var_45_11.network_transmit:send_rpc_server("rpc_player_blocked_attack", var_45_12, var_45_13, var_45_14, var_45_3, var_45_4, "back", var_45_15)
			end
		end

		return true
	end

	return false
end

DamageUtils.camera_shake_by_distance = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7)
	local var_46_0 = Managers.player:local_player()

	if not var_46_0 then
		return
	end

	local var_46_1 = arg_46_2 or var_46_0.player_unit

	if not var_46_1 then
		return
	end

	local var_46_2 = Managers.state.game_mode

	if var_46_2 and var_46_2:get_end_reason() then
		return
	end

	local var_46_3 = 1

	if arg_46_3 then
		local var_46_4 = Vector3.distance(var_0_7(arg_46_3, 0), var_0_7(var_46_1, 0))

		var_46_3 = 1 - math.clamp((var_46_4 - arg_46_4) / (arg_46_5 - arg_46_4), 0, 1)
		var_46_3 = arg_46_7 + var_46_3 * (arg_46_6 - arg_46_7)
	end

	Managers.state.camera:camera_effect_shake_event(arg_46_0, arg_46_1, var_46_3)
end

local var_0_40 = 1
local var_0_41 = 3
local var_0_42 = 4
local var_0_43 = {}
local var_0_44 = {}

DamageUtils.is_enemy = function (arg_47_0, arg_47_1)
	local var_47_0 = Managers.state.side.side_by_unit[arg_47_0]

	return var_47_0 and var_47_0.enemy_units_lookup[arg_47_1] ~= nil
end

DamageUtils.is_ai = function (arg_48_0)
	local var_48_0 = AiUtils.unit_breed(arg_48_0)

	if var_48_0 then
		return var_48_0.is_ai
	end
end

DamageUtils.is_character = function (arg_49_0)
	return Unit.has_data(arg_49_0, "breed") or false
end

DamageUtils.can_bots_damage = function (arg_50_0)
	local var_50_0, var_50_1 = DamageUtils.is_character(arg_50_0)
	local var_50_2 = Managers.state.network:level_object_id(arg_50_0)
	local var_50_3 = ScriptUnit.extension(arg_50_0, "health_system")

	return var_50_0 or var_50_2 or var_50_3.bots_can_do_damage
end

DamageUtils.vs_dark_pact_can_damage = function (arg_51_0, arg_51_1)
	local var_51_0, var_51_1 = DamageUtils.is_character(arg_51_1)
	local var_51_2 = Managers.state.network:level_object_id(arg_51_1)
	local var_51_3 = ScriptUnit.has_extension(arg_51_1, "props_system")
	local var_51_4 = var_51_3 and var_51_3.owner and var_51_3:owner()
	local var_51_5 = var_51_4 and Managers.state.side:is_enemy(arg_51_0, var_51_4)

	return var_51_0 or var_51_2 or var_51_5
end

DamageUtils.allow_friendly_fire_ranged = function (arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.friendly_fire_ranged
	local var_52_1, var_52_2, var_52_3 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "friendly_fire")

	if var_52_1 and var_52_3 then
		local var_52_4 = arg_52_1 and arg_52_1.player_unit

		if not (var_52_4 and Managers.state.side:versus_is_dark_pact(var_52_4)) then
			var_52_0 = not not var_52_2
		end
	end

	return var_52_0 and arg_52_1 and not arg_52_1.bot_player
end

DamageUtils.allow_friendly_fire_melee = function (arg_53_0, arg_53_1)
	return arg_53_0.friendly_fire_melee and not arg_53_1.bot_player
end

DamageUtils.damage_level_unit = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8, arg_54_9)
	if var_0_5(arg_54_0, "no_damage_from_players") then
		return
	end

	if Managers.mechanism:current_mechanism_name() == "versus" and ScriptUnit.has_extension(arg_54_0, "objective_system") then
		local var_54_0 = Managers.state.side.side_by_unit[arg_54_1]

		if not var_54_0 or var_54_0:name() ~= "heroes" then
			return
		end
	end

	local var_54_1 = arg_54_6[arg_54_7] or arg_54_6.default_target

	if not var_54_1 then
		return
	end

	local var_54_2 = var_0_5(arg_54_0, "filter_damage_source")

	if var_54_2 and var_54_2 ~= arg_54_9 then
		return
	end

	local var_54_3 = BoostCurves[var_54_1.boost_curve_type]
	local var_54_4 = DamageUtils.calculate_damage(DamageOutput, arg_54_0, arg_54_1, arg_54_2, arg_54_3, var_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, nil, arg_54_9)
	local var_54_5 = "destructible_level_object_hit"
	local var_54_6
	local var_54_7
	local var_54_8
	local var_54_9
	local var_54_10

	DamageUtils.add_damage_network(arg_54_0, arg_54_1, var_54_4, arg_54_2, var_54_5, nil, arg_54_8, arg_54_9, var_54_6, var_54_7, var_54_8, var_54_9, arg_54_5, var_54_10, nil, nil, nil, nil, arg_54_7)
end

DamageUtils._projectile_hit_object = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8, arg_55_9, arg_55_10, arg_55_11, arg_55_12, arg_55_13, arg_55_14, arg_55_15, arg_55_16, arg_55_17, arg_55_18, arg_55_19, arg_55_20, arg_55_21, arg_55_22, arg_55_23, arg_55_24, arg_55_25, arg_55_26, arg_55_27, arg_55_28, arg_55_29)
	local var_55_0 = var_0_43
	local var_55_1 = var_0_44
	local var_55_2 = Managers.state.entity:system("ai_system")
	local var_55_3 = Managers.state.network
	local var_55_4, var_55_5 = var_55_3:game_object_or_level_id(arg_55_5)
	local var_55_6 = ScriptUnit.has_extension(arg_55_5, "health_system")
	local var_55_7 = Managers.player:owner(arg_55_5)
	local var_55_8 = "full"
	local var_55_9 = arg_55_29
	local var_55_10 = var_0_5(arg_55_5, "allow_ranged_damage") ~= false

	if var_55_5 and not var_55_0[arg_55_5] and (GameSettingsDevelopment.allow_ranged_attacks_to_damage_props or var_55_10) and var_55_6 then
		var_55_0[arg_55_5] = true
		var_55_9 = var_55_9 + 1

		local var_55_11 = math.ceil(var_55_9)

		DamageUtils.damage_level_unit(arg_55_5, arg_55_1, var_55_8, arg_55_17, arg_55_18, arg_55_15, arg_55_19, var_55_11, arg_55_24, arg_55_20)

		var_55_1.stop = true
		var_55_1.hits = arg_55_28 + 1
	elseif not var_55_5 and var_55_10 and var_55_6 and not var_55_7 then
		var_55_0[arg_55_5] = true

		local var_55_12 = var_55_3:unit_game_object_id(arg_55_1)
		local var_55_13 = var_55_3:unit_game_object_id(arg_55_5)
		local var_55_14 = NetworkLookup.hit_zones[var_55_8]

		Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(arg_55_25, var_55_12, var_55_13, var_55_14, arg_55_7, arg_55_24, arg_55_26, "power_level", arg_55_17, "hit_target_index", nil, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", arg_55_18, "is_critical_strike", arg_55_15, "first_hit", arg_55_28 == 0)

		if arg_55_15 and arg_55_21 then
			EffectHelper.play_surface_material_effects(arg_55_21, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, nil, arg_55_10, nil, arg_55_6)
		else
			EffectHelper.play_surface_material_effects(arg_55_23, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, nil, arg_55_10, nil, arg_55_6)
		end

		if Managers.state.network:game() then
			if arg_55_15 and arg_55_21 then
				EffectHelper.remote_play_surface_material_effects(arg_55_21, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, arg_55_12, arg_55_6)
			else
				EffectHelper.remote_play_surface_material_effects(arg_55_23, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, arg_55_12, arg_55_6)
			end
		end

		var_55_1.stop = true
		var_55_1.hits = arg_55_28 + 1
	else
		if arg_55_0.alert_sound_range_hit and arg_55_1 then
			var_55_2:alert_enemies_within_range(arg_55_1, arg_55_7, arg_55_0.alert_sound_range_fire)
		end

		if not ScriptUnit.has_extension(arg_55_5, "ai_inventory_item_system") then
			local var_55_15 = Managers.player:owner(arg_55_5)

			if var_55_15 == nil or var_55_15.player_unit == nil then
				if arg_55_15 and arg_55_21 then
					EffectHelper.play_surface_material_effects(arg_55_21, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, nil, arg_55_10, nil, arg_55_6)
				else
					EffectHelper.play_surface_material_effects(arg_55_23, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, nil, arg_55_10, nil, arg_55_6)
				end

				if Managers.state.network:game() then
					if arg_55_15 and arg_55_21 then
						EffectHelper.remote_play_surface_material_effects(arg_55_21, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, arg_55_12, arg_55_6)
					else
						EffectHelper.remote_play_surface_material_effects(arg_55_23, arg_55_22, arg_55_5, arg_55_7, arg_55_8, arg_55_9, arg_55_12, arg_55_6)
					end
				end

				if var_55_10 and arg_55_5 and var_0_6(arg_55_5) and arg_55_6 then
					local var_55_16 = Vector3.multiply(arg_55_9, -1)

					var_0_10(arg_55_5, "hit_actor", arg_55_6)
					var_0_10(arg_55_5, "hit_direction", var_55_16)
					var_0_10(arg_55_5, "hit_position", arg_55_7)
					var_0_11(arg_55_5, "lua_simple_damage")
				end
			end

			var_55_1.stop = true
			var_55_1.hits = 1
		end
	end

	return var_55_9
end

DamageUtils._projectile_hit_character = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8, arg_56_9, arg_56_10, arg_56_11, arg_56_12, arg_56_13, arg_56_14, arg_56_15, arg_56_16, arg_56_17, arg_56_18, arg_56_19, arg_56_20, arg_56_21, arg_56_22, arg_56_23, arg_56_24, arg_56_25, arg_56_26, arg_56_27, arg_56_28, arg_56_29)
	local var_56_0 = var_0_43
	local var_56_1 = var_0_44
	local var_56_2 = Managers.state.network
	local var_56_3, var_56_4 = var_56_2:game_object_or_level_id(arg_56_1)
	local var_56_5, var_56_6 = var_56_2:game_object_or_level_id(arg_56_5)
	local var_56_7 = "torso"
	local var_56_8 = 0
	local var_56_9 = false
	local var_56_10 = false
	local var_56_11 = arg_56_27
	local var_56_12 = arg_56_28

	if arg_56_11 then
		local var_56_13 = var_0_19(arg_56_6)

		var_56_7 = arg_56_11.hit_zones_lookup[var_56_13].name

		if var_56_7 ~= "afro" then
			var_56_10 = AiUtils.attack_is_shield_blocked(arg_56_5, arg_56_1) and not arg_56_0.ignore_shield_hit

			if var_56_10 then
				var_56_1.blocked_by_unit = arg_56_5
			end
		end
	end

	if arg_56_0.hit_zone_override and var_56_7 ~= "afro" then
		var_56_7 = arg_56_0.hit_zone_override
	end

	local var_56_14 = true

	if var_56_7 ~= "head" and HEALTH_ALIVE[arg_56_5] and arg_56_11 and arg_56_11.hit_zones and arg_56_11.hit_zones.head then
		local var_56_15 = ScriptUnit.has_extension(arg_56_1, "buff_system")

		if var_56_15 and var_56_15:has_buff_perk("auto_headshot") and var_56_7 ~= "afro" then
			var_56_7 = "head"
			var_56_14 = false

			var_56_15:trigger_procs("on_auto_headshot")
		end
	end

	if arg_56_11 and var_56_7 == "head" and arg_56_2 and not var_56_10 then
		local var_56_16 = ScriptUnit.extension(arg_56_1, "first_person_system")
		local var_56_17, var_56_18 = arg_56_3:apply_buffs_to_value(0, "coop_stamina")

		if var_56_18 and HEALTH_ALIVE[arg_56_5] then
			local var_56_19 = arg_56_11.headshot_coop_stamina_fatigue_type or "headshot_clan_rat"
			local var_56_20 = NetworkLookup.fatigue_types[var_56_19]

			if arg_56_12 then
				var_56_2.network_transmit:send_rpc_clients("rpc_replenish_fatigue_other_players", var_56_20)
			else
				var_56_2.network_transmit:send_rpc_server("rpc_replenish_fatigue_other_players", var_56_20)
			end

			StatusUtils.replenish_stamina_local_players(arg_56_1, var_56_19)
			var_56_16:play_hud_sound_event("hud_player_buff_headshot", nil, false)
		end

		if not arg_56_0.no_headshot_sound and HEALTH_ALIVE[arg_56_5] then
			var_56_16:play_hud_sound_event("Play_hud_headshot", nil, false)
		end
	end

	local var_56_21 = Managers.player:owner(arg_56_5)

	if var_56_7 == "afro" then
		if arg_56_11.is_ai and Managers.state.side:is_enemy(arg_56_5, arg_56_1) then
			if arg_56_12 then
				if ScriptUnit.has_extension(arg_56_5, "ai_system") then
					AiUtils.alert_unit_of_enemy(arg_56_5, arg_56_1)
				end
			else
				var_56_2.network_transmit:send_rpc_server("rpc_alert_enemy", var_56_5, var_56_3)
			end
		end
	elseif var_56_21 and arg_56_6 == var_0_12(arg_56_5, "c_afro") then
		local var_56_22 = arg_56_0.afro_hit_sound

		if var_56_22 and not var_56_21.bot_player and Managers.state.network:game() then
			local var_56_23 = NetworkLookup.sound_events[var_56_22]

			var_56_2.network_transmit:send_rpc("rpc_play_first_person_sound", var_56_21.peer_id, var_56_5, var_56_23, arg_56_7)
		end
	else
		var_56_0[arg_56_5] = true

		local var_56_24 = NetworkLookup.hit_zones[var_56_7]
		local var_56_25 = arg_56_4.attack_template
		local var_56_26 = DamageUtils.get_attack_template(var_56_25)

		if arg_56_2 and arg_56_11 and arg_56_13 and not var_56_10 then
			local var_56_27 = true
			local var_56_28 = DamageUtils.get_item_buff_type(arg_56_19)
			local var_56_29 = DamageUtils.buff_on_attack(arg_56_1, arg_56_5, "instant_projectile", arg_56_14, var_56_7, arg_56_29 or var_56_11 + 1, var_56_27, var_56_28, var_56_14, arg_56_19)

			var_56_1.buffs_checked = var_56_1.buffs_checked or var_56_29
		end

		if arg_56_11 and HEALTH_ALIVE[arg_56_5] then
			local var_56_30 = arg_56_0.hit_mass_count

			if var_56_30 and var_56_30[arg_56_11.name] then
				var_56_12 = var_56_12 + (arg_56_0.hit_mass_count[arg_56_11.name] or 1)
			else
				var_56_12 = var_56_12 + (var_56_10 and (arg_56_11.hit_mass_counts_block and arg_56_11.hit_mass_counts_block[arg_56_15] or arg_56_11.hit_mass_count_block) or arg_56_11.hit_mass_counts and arg_56_11.hit_mass_counts[arg_56_15] or arg_56_11.hit_mass_count or 1)
			end

			local var_56_31 = ScriptUnit.has_extension(arg_56_5, "buff_system")

			if var_56_31 then
				var_56_12 = var_56_31:apply_buffs_to_value(var_56_12, "hit_mass_amount")
			end
		end

		local var_56_32 = math.ceil(var_56_12)
		local var_56_33 = var_56_26.sound_type
		local var_56_34

		var_56_8, var_56_34 = DamageUtils.calculate_damage(DamageOutput, arg_56_5, arg_56_1, var_56_7, arg_56_16, BoostCurves[arg_56_4.boost_curve_type], arg_56_17, arg_56_14, arg_56_18, var_56_32, nil, arg_56_19)

		local var_56_35 = var_56_8 <= 0

		if var_56_34 then
			arg_56_22 = "invulnerable"
			arg_56_20 = "invulnerable"

			DamageUtils.handle_hit_indication(arg_56_1, arg_56_5, 0, var_56_7, false, true)
		end

		if arg_56_11 and not arg_56_11.is_hero then
			local var_56_36 = arg_56_11.name

			if arg_56_14 and arg_56_20 then
				EffectHelper.play_skinned_surface_material_effects(arg_56_20, arg_56_21, arg_56_5, arg_56_7, arg_56_8, arg_56_9, arg_56_10, var_56_36, var_56_33, var_56_35, var_56_7, var_56_10, arg_56_11)
			else
				EffectHelper.play_skinned_surface_material_effects(arg_56_22, arg_56_21, arg_56_5, arg_56_7, arg_56_8, arg_56_9, arg_56_10, var_56_36, var_56_33, var_56_35, var_56_7, var_56_10, arg_56_11)
			end

			if Managers.state.network:game() then
				if arg_56_14 and arg_56_20 then
					EffectHelper.remote_play_skinned_surface_material_effects(arg_56_20, arg_56_21, arg_56_7, arg_56_8, arg_56_9, var_56_36, var_56_33, var_56_35, var_56_7, arg_56_12)
				else
					EffectHelper.remote_play_skinned_surface_material_effects(arg_56_22, arg_56_21, arg_56_7, arg_56_8, arg_56_9, var_56_36, var_56_33, var_56_35, var_56_7, arg_56_12)
				end
			end
		elseif var_56_21 and arg_56_11.is_hero and arg_56_0.player_push_velocity then
			local var_56_37 = ScriptUnit.has_extension(arg_56_5, "buff_system")

			if not (var_56_37 and var_56_37:has_buff_perk("no_ranged_knockback")) and not ScriptUnit.extension(arg_56_5, "status_system"):is_disabled() then
				local var_56_38 = arg_56_0.max_impact_push_speed

				ScriptUnit.extension(arg_56_5, "locomotion_system"):add_external_velocity(arg_56_0.player_push_velocity:unbox(), var_56_38)
			end
		end

		local var_56_39 = true
		local var_56_40 = var_0_6(arg_56_1)

		if var_56_40 and var_56_21 then
			local var_56_41 = arg_56_18.fatigue_damage_override or "blocked_ranged"
			local var_56_42 = DamageUtils.check_ranged_block(arg_56_1, arg_56_5, var_56_41)

			var_56_39 = not var_56_42
			var_56_10 = var_56_42

			if var_56_42 and Managers.state.side:versus_is_dark_pact(arg_56_1) then
				WwiseUtils.trigger_unit_event(arg_56_21, "Play_versus_ui_damage_mitigated_indicator", arg_56_5)
			end

			local var_56_43 = Unit.get_data(arg_56_1, "breed")

			if var_56_10 and var_56_43 and var_56_43.track_projectile_blocked_vo then
				local var_56_44 = Managers.time:time("game")
				local var_56_45 = Unit.get_data(arg_56_1, "blocked_projectile_hits") or {}
				local var_56_46 = #var_56_45 + 1

				var_56_45[var_56_46] = var_56_44

				for iter_56_0 = var_56_46, 1, -1 do
					if var_56_44 > var_56_45[iter_56_0] + DialogueSettings.vs_track_projectiles_blocked_timer then
						table.swap_delete(var_56_45, iter_56_0)

						var_56_46 = var_56_46 - 1
					end
				end

				if var_56_46 > DialogueSettings.vs_num_blocked_projectiles_to_track then
					ScriptUnit.extension_input(arg_56_1, "dialogue_system"):trigger_networked_dialogue_event("vs_ratling_hitting_shield")
					table.clear(var_56_45)
				end

				Unit.set_data(arg_56_1, "blocked_projectile_hits", var_56_45)
			end
		end

		if var_56_21 and arg_56_11.boss and Managers.state.side:versus_is_dark_pact(arg_56_1) then
			var_56_39 = false
		end

		if var_56_39 then
			Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(arg_56_24, var_56_3, var_56_5, var_56_24, arg_56_7, arg_56_23, arg_56_25, "power_level", arg_56_16, "hit_target_index", var_56_32, "blocking", var_56_10, "shield_break_procced", false, "boost_curve_multiplier", arg_56_17, "is_critical_strike", arg_56_14, "attacker_is_level_unit", var_56_4, "first_hit", var_56_11 == 0)
			EffectHelper.player_critical_hit(arg_56_21, arg_56_14, arg_56_1, arg_56_5, arg_56_7)
			Managers.state.game_mode:game_mode():projectile_hit_character(arg_56_2, nil, arg_56_1, arg_56_5, arg_56_7, arg_56_11, arg_56_23, var_56_8)

			if not arg_56_2 and var_56_40 and var_56_21 and var_56_21.bot_player then
				ScriptUnit.extension(arg_56_5, "ai_system"):hit_by_projectile(arg_56_1)
			end
		end

		local var_56_47 = var_0_5(arg_56_5, "armor")
		local var_56_48, var_56_49, var_56_50, var_56_51 = ActionUtils.get_target_armor(var_56_7, arg_56_11, var_56_47)

		if var_56_35 or var_56_10 or var_56_50 == 6 or var_56_48 == 2 then
			arg_56_26 = var_56_11
		else
			var_56_11 = var_56_11 + 1
		end

		if arg_56_26 <= var_56_12 then
			var_56_1.stop = true
			var_56_1.hits = var_56_11
		end
	end

	return var_56_12, var_56_11, var_56_8, var_56_10
end

DamageUtils.process_projectile_hit = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5, arg_57_6, arg_57_7, arg_57_8, arg_57_9, arg_57_10, arg_57_11, arg_57_12, arg_57_13)
	table.clear(var_0_43)
	table.clear(var_0_44)

	local var_57_0 = var_0_43
	local var_57_1 = var_0_44
	local var_57_2 = arg_57_6
	local var_57_3 = arg_57_2 and Managers.player:owner(arg_57_2)
	local var_57_4 = NetworkLookup.damage_sources[arg_57_1]
	local var_57_5 = false
	local var_57_6 = Managers.state.difficulty:get_difficulty_settings()
	local var_57_7 = ScriptUnit.has_extension(arg_57_2, "buff_system")
	local var_57_8 = 0
	local var_57_9 = 0
	local var_57_10 = 0
	local var_57_11
	local var_57_12

	arg_57_11 = arg_57_11 or DefaultPowerLevel

	local var_57_13 = arg_57_12 or arg_57_5.damage_profile or "default"
	local var_57_14 = arg_57_12 and DamageProfileTemplates[arg_57_12]
	local var_57_15 = NetworkLookup.damage_profiles[var_57_13]
	local var_57_16 = var_57_14 or DamageProfileTemplates[var_57_13]
	local var_57_17 = Managers.state.difficulty:get_difficulty()
	local var_57_18 = ActionUtils.scale_power_levels(arg_57_11, "cleave", arg_57_2, var_57_17)
	local var_57_19, var_57_20 = ActionUtils.get_max_targets(var_57_16, var_57_18)

	if var_57_7 then
		var_57_10 = var_57_7:apply_buffs_to_value(var_57_10, "ranged_additional_penetrations")
	end

	local var_57_21, var_57_22 = ActionUtils.get_ranged_boost(arg_57_2)
	local var_57_23 = var_57_20 < var_57_19 and var_57_19 or var_57_20
	local var_57_24 = var_57_3 and var_57_3.bot_player and true or false
	local var_57_25 = arg_57_5.hit_effect
	local var_57_26 = arg_57_5.critical_hit_effect
	local var_57_27 = #arg_57_4

	var_57_1.hits = var_57_9

	local var_57_28 = var_57_16.no_friendly_fire
	local var_57_29 = var_57_16.allow_friendly_fire
	local var_57_30 = Managers.state.difficulty:get_difficulty_rank()
	local var_57_31 = var_57_29 or not var_57_28 and DamageUtils.allow_friendly_fire_ranged(var_57_6, var_57_3)
	local var_57_32 = Managers.state.side
	local var_57_33 = Managers.player

	for iter_57_0 = 1, var_57_27 do
		repeat
			local var_57_34 = arg_57_4[iter_57_0]
			local var_57_35 = var_57_34[var_0_40]
			local var_57_36 = var_57_34[var_0_41]
			local var_57_37 = var_57_34[var_0_42]
			local var_57_38 = var_57_37 ~= nil
			local var_57_39 = var_57_38 and var_0_18(var_57_37) or nil

			if not var_0_6(var_57_39) or Unit.is_frozen(var_57_39) then
				var_57_38 = false
				var_57_39 = nil
			else
				var_57_39, var_57_37 = ActionUtils.redirect_shield_hit(var_57_39, var_57_37)
			end

			if var_57_39 == arg_57_2 or not var_57_38 then
				break
			end

			local var_57_40 = var_57_16.targets and var_57_16.targets[var_57_9 + 1] or var_57_16.default_target
			local var_57_41 = Quaternion.look(var_57_36)
			local var_57_42 = var_57_39 == arg_57_8 or arg_57_8 == nil
			local var_57_43 = AiUtils.unit_breed(var_57_39)
			local var_57_44

			if var_57_43 then
				local var_57_45 = var_0_19(var_57_37)
				local var_57_46 = var_57_43.hit_zones_lookup[var_57_45].name

				if arg_57_9 and arg_57_9[var_57_39] and var_57_46 ~= "afro" then
					return var_57_1
				end
			end

			local var_57_47 = var_57_33:is_player_unit(var_57_39)
			local var_57_48 = var_57_43 or var_57_47

			var_57_1.hit_any_player = var_57_1.hit_any_player or var_57_47

			local var_57_49 = false

			if var_57_48 and var_57_3 then
				local var_57_50 = var_57_32.side_by_unit[var_57_39]
				local var_57_51 = var_57_32.side_by_unit[arg_57_2]
				local var_57_52 = var_57_50 and var_57_51 and var_57_50.side_id == var_57_51.side_id

				if var_57_50 and var_57_51 and var_57_52 and not var_57_43.boss then
					var_57_49 = not var_57_31 or var_57_43.disable_projectile_friendly_fire
				end
			end

			if not var_57_48 and not var_57_0[var_57_39] then
				var_57_8 = DamageUtils._projectile_hit_object(arg_57_5, arg_57_2, var_57_3, var_57_7, var_57_40, var_57_39, var_57_37, var_57_35, var_57_41, var_57_36, var_57_24, var_57_43, arg_57_3, arg_57_7, var_57_5, arg_57_10, var_57_30, arg_57_11, var_57_22, var_57_16, arg_57_1, var_57_26, arg_57_0, var_57_25, var_57_2, var_57_4, var_57_15, var_57_23, var_57_9, var_57_8)

				if var_57_1.stop then
					if var_57_10 > 0 then
						var_57_10 = var_57_10 - 1
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

			if not var_57_0[var_57_39] and var_57_42 and not var_57_49 then
				local var_57_53, var_57_54

				var_57_8, var_57_9, var_57_53, var_57_54 = DamageUtils._projectile_hit_character(arg_57_5, arg_57_2, var_57_3, var_57_7, var_57_40, var_57_39, var_57_37, var_57_35, var_57_41, var_57_36, var_57_24, var_57_43, arg_57_3, arg_57_7, arg_57_10, var_57_30, arg_57_11, var_57_22, var_57_16, arg_57_1, var_57_26, arg_57_0, var_57_25, var_57_2, var_57_4, var_57_15, var_57_23, var_57_9, var_57_8, arg_57_13)

				if var_57_1.stop then
					if var_57_10 > 0 then
						var_57_10 = var_57_10 - 1
						var_57_1.stop = false

						break
					end

					var_57_1.hit_unit = var_57_39
					var_57_1.hit_actor = var_57_37
					var_57_1.hit_position = var_57_35
					var_57_1.hit_direction = var_57_2
					var_57_1.predicted_damage = var_57_53
					var_57_1.shield_blocked = var_57_54
					var_57_1.hit_player = var_57_47

					return var_57_1
				end
			end
		until true
	end

	return var_57_1
end

local var_0_45 = {}

DamageUtils.get_modified_boost_curve = function (arg_58_0, arg_58_1)
	table.clear(var_0_45)

	for iter_58_0, iter_58_1 in ipairs(arg_58_0) do
		var_0_45[iter_58_0] = arg_58_0[iter_58_0] * arg_58_1
	end

	return var_0_45
end

local function var_0_46(arg_59_0, arg_59_1)
	local var_59_0 = arg_59_0.stagger_immunity

	if not var_59_0 then
		return
	end

	local var_59_1 = var_59_0.num_attacks
	local var_59_2 = (var_59_0.num_hits or 0) + 1

	if var_59_2 == var_59_1 then
		var_59_0.stagger_immune_at = arg_59_1
		var_59_0.stagger_immune_at_health = arg_59_0.current_health_percent
		var_59_0.debug_damage_left = var_59_0.damage_threshold
		var_59_2 = 0
	end

	var_59_0.num_hits = var_59_2
end

local function var_0_47(arg_60_0, arg_60_1)
	local var_60_0 = arg_60_0.stagger_immunity

	if not var_60_0 then
		return false
	end

	local var_60_1 = arg_60_0.current_health_percent
	local var_60_2 = var_60_0.health_threshold

	if var_60_2 and var_60_2 < var_60_1 then
		return true
	end

	local var_60_3 = 0
	local var_60_4 = var_60_0.stagger_immune_at_health

	if var_60_4 then
		var_60_3 = var_60_0.damage_threshold - (var_60_4 - var_60_1)
		var_60_0.debug_damage_left = var_60_3
	end

	local var_60_5 = 0
	local var_60_6 = var_60_0.stagger_immune_at

	if var_60_6 then
		var_60_5 = (var_60_6 + var_60_0.time or 0) - arg_60_1
	end

	if var_60_3 > 0 and var_60_5 > 0 then
		return true
	end

	return false
end

local function var_0_48(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
	local var_61_0 = ScriptUnit.has_extension(arg_61_3, "status_system")
	local var_61_1 = arg_61_4 and var_61_0:breed_action() or arg_61_0.action
	local var_61_2 = var_61_1 and var_61_1.ignore_staggers

	if arg_61_0.anim_cb_stagger_immune then
		return true
	end

	if not var_61_2 or arg_61_1.always_stagger then
		return false
	end

	if var_61_2.allow_push and arg_61_1.is_push then
		return false
	end

	local var_61_3 = var_61_2[arg_61_2]

	if type(var_61_3) == "table" then
		local var_61_4 = var_61_3.type

		if var_61_4 == "ignore_by_health" then
			local var_61_5 = arg_61_0.current_health_percent
			local var_61_6 = var_61_3.health

			return var_61_5 > var_61_6.min and var_61_5 <= var_61_6.max
		elseif var_61_4 == "reset_attack" then
			arg_61_0.reset_attack = true
			arg_61_0.reset_attack_delay = var_61_3.delay

			return true
		end
	elseif type(var_61_3) == "boolean" then
		return var_61_3
	else
		error("action_ignores_stagger: unsupported type")
	end
end

DamageUtils.stagger_ai = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5, arg_62_6, arg_62_7, arg_62_8, arg_62_9, arg_62_10, arg_62_11, arg_62_12, arg_62_13)
	local var_62_0 = EnvironmentalHazards[arg_62_11]

	if not arg_62_1.always_stagger_ai and not DamageUtils.is_enemy(arg_62_12 or arg_62_5, arg_62_4) and (not var_62_0 or not var_62_0.enemy.can_stagger) then
		return
	end

	local var_62_1 = ScriptUnit.has_extension(arg_62_4, "ai_system")
	local var_62_2 = var_62_1 and var_62_1:blackboard() or var_0_2[arg_62_4]

	if not var_62_2 then
		return
	end

	if var_62_2.breed.is_hero and not var_62_1 then
		return
	end

	if var_0_47(var_62_2, arg_62_0) then
		return
	end

	local var_62_3 = (arg_62_1.targets and arg_62_1.targets[arg_62_2] or arg_62_1.default_target).attack_template
	local var_62_4 = DamageUtils.get_attack_template(var_62_3)
	local var_62_5, var_62_6, var_62_7, var_62_8 = DamageUtils.calculate_stagger_player(ImpactTypeOutput, arg_62_4, arg_62_5, arg_62_6, arg_62_3, arg_62_8, arg_62_9, arg_62_1, arg_62_2, arg_62_10, arg_62_11)
	local var_62_9 = arg_62_1.is_push

	if var_62_5 == 0 then
		return
	end

	local var_62_10 = var_62_2.is_player and not var_62_1

	if var_0_48(var_62_2, var_62_4, var_62_5, arg_62_4, var_62_10) then
		return
	end

	if not var_62_10 then
		var_0_46(var_62_2, arg_62_0)
	end

	local var_62_11 = var_62_4.stagger_angle
	local var_62_12 = var_0_4[arg_62_4] or var_0_9(arg_62_4, 0)
	local var_62_13 = var_0_4[arg_62_5] or var_0_9(arg_62_5, 0)

	if var_62_11 == "down" or var_62_11 == "smiter" and arg_62_10 then
		arg_62_7 = Vector3.normalize(var_62_12 - var_62_13)
		arg_62_7.z = -1
	elseif var_62_11 == "stab" or var_62_11 == "smiter" or arg_62_10 then
		arg_62_7 = Vector3.normalize(var_62_12 - var_62_13)
	elseif var_62_11 == "pull" then
		arg_62_7 = Vector3.normalize(var_62_13 - var_62_12)
	end

	if var_62_5 > var_0_0.none then
		if var_62_10 then
			DamageUtils.stagger_player(arg_62_4, var_62_2.breed, arg_62_7, var_62_7, var_62_5, var_62_6, var_62_4.stagger_animation_scale, arg_62_0, var_62_8, var_62_4.always_stagger, var_62_9)
		else
			AiUtils.stagger(arg_62_4, var_62_2, arg_62_5, arg_62_7, var_62_7, var_62_5, var_62_6, var_62_4.stagger_animation_scale, arg_62_0, var_62_8, var_62_4.always_stagger, var_62_9, nil, arg_62_13)
		end

		local var_62_14 = rawget(ItemMasterList, arg_62_11)
		local var_62_15 = var_62_14 and var_62_14.template
		local var_62_16 = var_62_15 and WeaponUtils.get_weapon_template(var_62_15)
		local var_62_17 = var_62_16 and var_62_16.buff_type or nil
		local var_62_18 = arg_62_5 and ScriptUnit.has_extension(arg_62_5, "buff_system")

		if var_62_18 and not var_62_2.override_stagger then
			Managers.state.achievement:trigger_event("register_ai_stagger", arg_62_4, arg_62_5, arg_62_1, var_62_9, var_62_5)
			var_62_18:trigger_procs("on_stagger", arg_62_4, arg_62_1, arg_62_5, var_62_5, var_62_6, var_62_8, var_62_17, arg_62_2)
		end

		local var_62_19 = ScriptUnit.has_extension(arg_62_4, "buff_system")

		if var_62_19 then
			var_62_19:trigger_procs("on_staggered", arg_62_4, arg_62_1, arg_62_5, var_62_5, var_62_6, var_62_8, var_62_17, arg_62_2)
		end
	end
end

local var_0_49 = {
	charge_ability_hit_blast = "on_charge_ability_hit_blast",
	charge_ability_hit = "on_charge_ability_hit"
}

DamageUtils.server_apply_hit = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4, arg_63_5, arg_63_6, arg_63_7, arg_63_8, arg_63_9, arg_63_10, arg_63_11, arg_63_12, arg_63_13, arg_63_14, arg_63_15, arg_63_16, arg_63_17, arg_63_18, arg_63_19, arg_63_20, arg_63_21)
	arg_63_20 = arg_63_20 or arg_63_1

	local var_63_0 = ScriptUnit.has_extension(arg_63_1, "buff_system")

	if var_63_0 and var_0_49[arg_63_7] then
		var_63_0:trigger_procs(var_0_49[arg_63_7], arg_63_2, arg_63_10)
	end

	if not arg_63_15 then
		local var_63_1 = arg_63_8

		if not arg_63_13 then
			var_63_1 = 0
		end

		if arg_63_9.charge_value == "heavy_attack" and DamageUtils.is_player_unit(arg_63_1) then
			local var_63_2 = ScriptUnit.has_extension(arg_63_1, "status_system")

			if var_63_2 and var_63_2:fall_distance() >= MinFallDistanceForBonus then
				var_63_1 = var_63_1 * FallingPowerLevelBonusMultiplier
			end
		end

		local var_63_3 = false

		if var_63_0 then
			local var_63_4 = var_63_0:has_buff_perk("victor_witchhunter_bleed_on_critical_hit") and (arg_63_9.charge_value == "light_attack" or arg_63_9.charge_value == "heavy_attack") and not var_63_0:has_buff_perk("victor_witchhunter_bleed_on_critical_hit_disable")
			local var_63_5 = var_63_0:has_buff_perk("kerillian_critical_bleed_dot") and arg_63_9.charge_value == "projectile" and not var_63_0:has_buff_perk("kerillian_critical_bleed_dot_disable")
			local var_63_6 = var_63_0:has_buff_perk("generic_melee_bleed") and (arg_63_9.charge_value == "light_attack" or arg_63_9.charge_value == "heavy_attack")
			local var_63_7

			if var_63_4 or var_63_5 or var_63_6 then
				var_63_7 = "weapon_bleed_dot_whc"
			elseif var_63_0:has_buff_perk("sienna_unchained_burn_push") and arg_63_9 and arg_63_9.is_push then
				var_63_7 = "burning_dot_unchained_push"
			end

			if var_63_7 then
				local var_63_8 = FrameTable.alloc_table()

				var_63_8.dot_template_name = var_63_7

				local var_63_9 = DamageUtils.apply_dot(arg_63_9, arg_63_10, arg_63_8, arg_63_2, arg_63_1, arg_63_3, arg_63_7, arg_63_11, arg_63_12, nil, arg_63_20, var_63_8)

				var_63_3 = var_63_3 or var_63_9
			end
		end

		if (not arg_63_9.require_damage_for_dot or var_63_1 ~= 0) and not var_63_3 then
			local var_63_10 = DamageUtils.apply_dot(arg_63_9, arg_63_10, arg_63_8, arg_63_2, arg_63_1, arg_63_3, arg_63_7, arg_63_11, arg_63_12, nil, arg_63_20, nil)

			var_63_3 = var_63_3 or var_63_10
		end

		DamageUtils.add_damage_network_player(arg_63_9, arg_63_10, var_63_1, arg_63_2, arg_63_1, arg_63_3, arg_63_4, arg_63_5, arg_63_7, arg_63_6, arg_63_11, arg_63_12, var_63_3, arg_63_18, arg_63_19, arg_63_17, arg_63_20)
	elseif arg_63_16 then
		local var_63_11 = ScriptUnit.has_extension(arg_63_2, "ai_shield_system")

		if var_63_11 and var_63_11:break_shield() and var_63_0 then
			var_63_0:trigger_procs("on_broke_shield", arg_63_2)
		end

		arg_63_15 = false
	end

	if HEALTH_ALIVE[arg_63_2] and not arg_63_9.no_stagger then
		local var_63_12 = arg_63_8

		if not arg_63_14 then
			var_63_12 = 0
		end

		DamageUtils.stagger_ai(arg_63_0, arg_63_9, arg_63_10, var_63_12, arg_63_2, arg_63_1, arg_63_3, arg_63_5, arg_63_11, arg_63_12, arg_63_15, arg_63_7, arg_63_20, arg_63_21)
	end
end

local function var_0_50(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	local var_64_0
	local var_64_1 = false

	if arg_64_3 then
		var_64_0 = arg_64_3.dot_template_name
		var_64_1 = arg_64_3.dot_balefire_variant
	elseif arg_64_2 and arg_64_2.dot_template_name then
		var_64_0 = arg_64_2.dot_template_name
		var_64_1 = arg_64_2.dot_balefire_variant
	elseif arg_64_0 then
		local var_64_2 = arg_64_0.targets and arg_64_0.targets[arg_64_1] or arg_64_0.default_target

		if var_64_2 then
			var_64_0 = var_64_2.dot_template_name
			var_64_1 = var_64_2.dot_balefire_variant
		end

		if not var_64_0 then
			var_64_0 = arg_64_0.dot_template_name
			var_64_1 = arg_64_0.dot_balefire_variant
		end
	end

	return var_64_0, var_64_1
end

DamageUtils.apply_dot = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_9, arg_65_10, arg_65_11)
	if arg_65_0 then
		local var_65_0 = arg_65_0.targets and arg_65_0.targets[arg_65_1] or arg_65_0.default_target

		if arg_65_0.allow_dot_finesse_hit then
			local var_65_1 = AiUtils.unit_breed(arg_65_3)
			local var_65_2 = DamageUtils.get_breed_damage_multiplier_type(var_65_1, arg_65_5)
			local var_65_3 = var_65_2 == "headshot" or var_65_2 == "weakspot" or var_65_2 == "protected_weakspot"

			if var_65_3 or arg_65_8 then
				local var_65_4 = var_65_0.boost_curve_coefficient_headshot or DefaultBoostCurveCoefficient
				local var_65_5 = BoostCurves[var_65_0.boost_curve_type]
				local var_65_6 = DamageUtils.get_modified_boost_curve(var_65_5, var_65_4)
				local var_65_7 = 1
				local var_65_8, var_65_9, var_65_10, var_65_11 = ActionUtils.get_target_armor(arg_65_5, var_65_1, var_65_7)
				local var_65_12 = var_0_24(var_65_0, arg_65_0, var_65_3, var_65_2, true, var_65_8, var_65_10)
				local var_65_13 = ScriptUnit.has_extension(arg_65_4, "buff_system")

				if var_65_13 then
					if var_65_3 then
						var_65_12 = var_65_13:apply_buffs_to_value(var_65_12, "headshot_multiplier")
					end

					if arg_65_8 then
						var_65_12 = var_65_13:apply_buffs_to_value(var_65_12, "critical_strike_effectiveness")
					end
				end

				local var_65_14 = ScriptUnit.has_extension(arg_65_3, "buff_system")

				if var_65_14 and var_65_3 then
					var_65_12 = var_65_14:apply_buffs_to_value(var_65_12, "headshot_vulnerability")
				end

				arg_65_2 = arg_65_2 + arg_65_2 * DamageUtils.get_boost_curve_multiplier(var_65_6 or var_65_5, var_65_12)
			end
		end
	end

	local var_65_15, var_65_16 = var_0_50(arg_65_0, arg_65_1, arg_65_9, arg_65_11)

	if var_65_16 then
		local var_65_17 = ScriptUnit.has_extension(arg_65_10, "career_system") or ScriptUnit.has_extension(arg_65_4, "career_system")

		var_65_15 = var_65_17 and var_65_17:career_name() == "bw_necromancer" and BalefireBurnDotLookup[var_65_15] or var_65_15
	end

	local var_65_18 = false
	local var_65_19 = DotTypeLookup[var_65_15]

	if var_65_19 then
		var_65_18 = Dots[var_65_19](var_65_15, arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_10)

		if var_65_18 then
			Managers.state.achievement:trigger_event("on_dot_applied", var_65_15, arg_65_6, arg_65_4)
		end
	end

	return var_65_18
end

DamageUtils.custom_calculate_damage = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8, arg_66_9, arg_66_10, arg_66_11, arg_66_12, arg_66_13)
	local var_66_0 = arg_66_3.targets and arg_66_3.targets[arg_66_4] or arg_66_3.default_target
	local var_66_1 = BoostCurves[var_66_0.boost_curve_type]
	local var_66_2 = 1
	local var_66_3, var_66_4, var_66_5, var_66_6 = ActionUtils.get_target_armor(arg_66_11, arg_66_10, var_66_2)
	local var_66_7 = DifficultySettings[arg_66_13]
	local var_66_8 = DamageOutput
	local var_66_9 = false
	local var_66_10 = false
	local var_66_11 = false
	local var_66_12 = false
	local var_66_13
	local var_66_14
	local var_66_15
	local var_66_16 = var_0_25(arg_66_0, arg_66_1, arg_66_2, var_66_8, arg_66_11, arg_66_3, arg_66_4, var_66_1, arg_66_9, arg_66_6, arg_66_7, arg_66_10, arg_66_5, var_66_9, var_66_10, arg_66_8, arg_66_13, var_66_3, var_66_5, var_66_11, var_66_12, var_66_14, var_66_15)
	local var_66_17 = var_66_16 * DamageUtils.calculate_stagger_multiplier(arg_66_3, var_66_13, var_66_7, arg_66_12)

	return var_66_16 + var_66_17, var_66_16, var_66_17
end

DamageUtils.calculate_stagger_multiplier = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	if arg_67_2 then
		local var_67_0 = arg_67_2.min_stagger_damage_coefficient
		local var_67_1 = arg_67_2.stagger_damage_multiplier

		if var_67_1 then
			local var_67_2 = arg_67_3 * var_67_1

			if arg_67_1 and not arg_67_0.no_stagger_damage_reduction_ranged then
				var_67_2 = arg_67_1:apply_buffs_to_value(var_67_2, "unbalanced_damage_taken")
			end

			return var_67_0 + var_67_2 - 1
		end
	end

	return 0
end

local var_0_51 = {
	bleed = true,
	burninating = true,
	arrow_poison_dot = true
}
local var_0_52 = {
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
	local var_68_0 = math.clamp(math.floor(math.remap(0, 30, 1, 7, arg_68_0)), 1, 7)

	return var_0_52[var_68_0]
end

DamageUtils.add_unit_floating_damage_numbers = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5, arg_69_6, arg_69_7)
	local var_69_0
	local var_69_1 = var_0_51[arg_69_1]

	if arg_69_4 then
		local var_69_2 = DamageUtils.get_color_from_damage(arg_69_4)

		var_69_0 = Vector3(var_69_2[2], var_69_2[3], var_69_2[4])
	else
		local var_69_3 = math.min(120 + arg_69_2 * 4, 255)
		local var_69_4 = math.max(200 - arg_69_2 * 4, 0)

		if var_69_1 then
			var_69_0 = Vector3(192, 192, 192)
		else
			var_69_0 = Vector3(var_69_3, var_69_4, 0)
		end
	end

	local var_69_5 = 40 + arg_69_2 * 0.75 * (arg_69_6 or 1)
	local var_69_6 = 2.2

	if arg_69_3 then
		var_69_0[1] = 255
		var_69_6 = 3.2
		var_69_5 = var_69_5 + 0.05
	end

	if var_69_1 then
		var_69_6 = 1.5
		var_69_5 = var_69_5 - 0.05
	end

	Managers.state.event:trigger("add_damage_number", arg_69_2, var_69_5, arg_69_0, var_69_6, var_69_0, arg_69_3, arg_69_5, arg_69_7)
end

DamageUtils.add_hit_reaction = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
	if arg_70_2 or arg_70_4 or not arg_70_1 or arg_70_1.disable_local_hit_reactions or not var_0_13(arg_70_0) then
		return
	end

	local var_70_0

	if var_0_15(arg_70_0, "hit_reaction_climb") then
		local var_70_1 = Managers.state.network
		local var_70_2 = var_70_1:unit_game_object_id(arg_70_0)
		local var_70_3 = NetworkLookup.bt_action_names[GameSession.game_object_field(var_70_1:game(), var_70_2, "bt_action_name")]

		if var_70_3 and var_70_3 == "climb" then
			var_70_0 = "hit_reaction_climb"
		end
	end

	local var_70_4 = Quaternion.forward(var_0_8(arg_70_0, 0))
	local var_70_5 = Vector3.flat_angle(var_70_4, arg_70_3)

	if not var_70_0 and arg_70_1.hit_reaction_function then
		var_70_0 = arg_70_1.hit_reaction_function(arg_70_0, arg_70_1, var_70_4, arg_70_3, var_70_5)
	else
		var_70_0 = var_70_0 or (var_70_5 < -math.pi * 0.75 or var_70_5 > math.pi * 0.75) and "hit_reaction_backward" or var_70_5 < -math.pi * 0.25 and "hit_reaction_left" or var_70_5 < math.pi * 0.25 and "hit_reaction_forward" or "hit_reaction_right"
	end

	var_0_14(arg_70_0, var_70_0)
end

DamageUtils.attacker_is_fire_bomb = function (arg_71_0)
	local var_71_0 = ScriptUnit.has_extension(arg_71_0, "area_damage_system")

	if not var_71_0 then
		return false
	end

	if var_71_0.explosion_template_name ~= "fire_grenade" and var_71_0.explosion_template_name ~= "frag_fire_grenade" then
		return false
	end

	return true
end

DamageUtils.get_attack_template = function (arg_72_0)
	return MechanismOverrides.get(AttackTemplates[arg_72_0])
end
