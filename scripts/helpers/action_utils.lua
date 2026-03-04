-- chunkname: @scripts/helpers/action_utils.lua

require("scripts/helpers/pseudo_random_distribution")

ActionUtils = ActionUtils or {}

local var_0_0 = Unit.get_data
local var_0_1 = Unit.actor
local var_0_2 = Unit.find_actor

script_data.no_critical_strikes = script_data.no_critical_strikes or Development.parameter("no_critical_strikes")
script_data.always_critical_strikes = script_data.always_critical_strikes or Development.parameter("always_critical_strikes")
script_data.alternating_critical_strikes = script_data.alternating_critical_strikes or Development.parameter("alternating_critical_strikes")

ActionUtils.get_power_level_percentage = function (arg_1_0)
	local var_1_0 = MIN_POWER_LEVEL
	local var_1_1 = MAX_POWER_LEVEL

	return (arg_1_0 - var_1_0) / (var_1_1 - var_1_0)
end

ActionUtils.get_max_targets = function (arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.cleave_distribution or DefaultCleaveDistribution
	local var_2_1 = Cleave.max - Cleave.min
	local var_2_2 = arg_2_1 * var_2_0.attack
	local var_2_3 = var_2_1 * ActionUtils.get_power_level_percentage(var_2_2)
	local var_2_4 = arg_2_1 * var_2_0.impact
	local var_2_5 = var_2_1 * ActionUtils.get_power_level_percentage(var_2_4)

	return var_2_3, var_2_5
end

ActionUtils.get_target_armor = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0
	local var_3_1
	local var_3_2
	local var_3_3
	local var_3_4

	if arg_3_2 then
		var_3_0 = arg_3_2
		var_3_1 = arg_3_2

		return var_3_0, var_3_1
	end

	if arg_3_1 and arg_3_0 then
		local var_3_5 = arg_3_1.hitzone_armor_categories
		local var_3_6 = var_3_5 and var_3_5[arg_3_0] or arg_3_1.armor_category

		if type(var_3_6) == "table" then
			var_3_0 = var_3_6.attack
			var_3_1 = var_3_6.impact
		else
			var_3_0 = var_3_6
			var_3_1 = var_3_6
		end

		local var_3_7 = arg_3_1.hitzone_primary_armor_categories
		local var_3_8 = var_3_7 and var_3_7[arg_3_0] or arg_3_1.primary_armor_category

		if type(var_3_8) == "table" then
			var_3_3 = var_3_8.attack
			var_3_4 = var_3_8.impact
		else
			var_3_3 = var_3_8
			var_3_4 = var_3_8
		end
	elseif arg_3_1 then
		var_3_0 = arg_3_1.armor_category
		var_3_1 = arg_3_1.armor_category
		var_3_3 = arg_3_1.primary_armor_category
		var_3_4 = arg_3_1.primary_armor_category
	else
		local var_3_9 = 1

		var_3_0 = var_3_9
		var_3_1 = var_3_9
	end

	return var_3_0, var_3_1, var_3_3, var_3_4
end

ActionUtils.get_range_scalar_multiplier = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_1.range_modifier_settings or arg_4_0.range_modifier_settings

	if not var_4_0 then
		return 0
	end

	local var_4_1 = POSITION_LOOKUP[arg_4_2] or Unit.world_position(arg_4_2, 0)
	local var_4_2 = POSITION_LOOKUP[arg_4_3] or Unit.world_position(arg_4_3, 0)
	local var_4_3 = Vector3.distance(var_4_2, var_4_1)
	local var_4_4 = var_4_0.distance_scaling_steps

	if var_4_4 then
		local var_4_5

		if var_4_3 < var_4_4[1].distance then
			return 0
		elseif var_4_3 > var_4_4[#var_4_4].distance then
			return var_4_4[#var_4_4].multiplier
		else
			for iter_4_0 = 1, #var_4_4 - 1 do
				if var_4_3 > var_4_4[iter_4_0].distance and var_4_3 < var_4_4[iter_4_0 + 1].distance then
					return var_4_4[iter_4_0].multiplier
				end
			end
		end

		assert(false, "Setting: [distance_scaling_steps] range_multiplier never gets assigned a value")
	else
		local var_4_6 = var_4_0.dropoff_start
		local var_4_7 = var_4_0.dropoff_end

		if ScriptUnit.has_extension(arg_4_2, "buff_system"):has_buff_perk("no_damage_dropoff") then
			var_4_6 = var_4_6 * 2
			var_4_7 = var_4_7 * 2
		end

		local var_4_8 = var_4_7 - var_4_6

		return math.clamp(var_4_3 - var_4_6, 0, var_4_8) / var_4_8
	end
end

ActionUtils.get_armor_power_modifier = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	local var_5_0 = arg_5_2.armor_modifier or arg_5_1.armor_modifier or DefaultArmorPowerModifier
	local var_5_1 = arg_5_2.armor_modifier_near or arg_5_1.armor_modifier_near
	local var_5_2 = arg_5_2.armor_modifier_far or arg_5_1.armor_modifier_far
	local var_5_3
	local var_5_4

	if arg_5_5 then
		var_5_4 = arg_5_5[arg_5_0 .. "_armor_power_modifer"]
	end

	if var_5_4 and var_5_4[arg_5_3] then
		var_5_3 = arg_5_4 and var_5_4[arg_5_4] or var_5_4[arg_5_3]
	elseif var_5_1 and var_5_2 and arg_5_6 then
		local var_5_5 = arg_5_4 and var_5_1[arg_5_0][arg_5_4] or var_5_1[arg_5_0][arg_5_3] or 1
		local var_5_6 = arg_5_4 and var_5_2[arg_5_0][arg_5_4] or var_5_2[arg_5_0][arg_5_3] or 1

		var_5_3 = math.lerp(var_5_5, var_5_6, arg_5_6)
	else
		var_5_3 = arg_5_4 and var_5_0[arg_5_0][arg_5_4] or var_5_0[arg_5_0][arg_5_3] or 1
	end

	return var_5_3
end

ActionUtils.scale_power_levels = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = math.clamp(arg_6_0, MIN_POWER_LEVEL, MAX_POWER_LEVEL)

	if Managers and Managers.state.game_mode:setting("cap_power_level") then
		local var_6_1 = DifficultySettings[arg_6_3]
		local var_6_2 = var_6_1.power_level_cap
		local var_6_3 = MAX_POWER_LEVEL
		local var_6_4 = var_6_1.power_level_max_target

		if var_6_2 < var_6_0 and var_6_4 then
			var_6_0 = var_6_2 + var_6_4 * ((var_6_0 - var_6_2) / (var_6_3 - var_6_2))
		else
			var_6_0 = math.min(arg_6_0, var_6_2)
		end
	end

	local var_6_5 = var_6_0

	if var_6_0 >= MIN_POWER_LEVEL_CAP then
		local var_6_6 = 50
		local var_6_7 = 100
		local var_6_8 = 10
		local var_6_9

		if var_6_0 >= MIN_POWER_LEVEL_CAP + var_6_7 then
			var_6_9 = (var_6_0 - MIN_POWER_LEVEL_CAP) * ((POWER_LEVEL_DIFF_RATIO[arg_6_1] - 1) / (var_6_8 - 1))
		else
			var_6_9 = (var_6_0 + var_6_6 * (1 - (var_6_0 - 200) / var_6_7) - MIN_POWER_LEVEL_CAP) * ((POWER_LEVEL_DIFF_RATIO[arg_6_1] - 1) / (var_6_8 - 1))
		end

		var_6_5 = MIN_POWER_LEVEL_CAP + var_6_9
	end

	if arg_6_2 then
		var_6_5 = ActionUtils.apply_buffs_to_power_level(arg_6_2, var_6_5)
	end

	return var_6_5
end

ActionUtils.get_power_multiplier = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.power_distribution or arg_7_1.power_distribution or DefaultPowerDistribution
	local var_7_1 = arg_7_2.power_distribution_near or arg_7_1.power_distribution_near
	local var_7_2 = arg_7_2.power_distribution_far or arg_7_1.power_distribution_far
	local var_7_3

	if arg_7_3 and arg_7_3 >= 0 and distance_scaling_steps then
		var_7_3 = arg_7_3
	elseif var_7_1 and var_7_2 and arg_7_3 then
		local var_7_4 = var_7_1[arg_7_0]
		local var_7_5 = var_7_2[arg_7_0]

		var_7_3 = math.lerp(var_7_4, var_7_5, arg_7_3)
	else
		var_7_3 = var_7_0[arg_7_0]
	end

	return var_7_3
end

ActionUtils.get_power_level = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	local var_8_0 = ActionUtils.get_power_multiplier(arg_8_0, arg_8_2, arg_8_3, arg_8_5)

	return ActionUtils.scale_power_levels(arg_8_1, arg_8_0, arg_8_6, arg_8_7) * var_8_0
end

ActionUtils.get_power_level_for_target = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13)
	local var_9_0 = arg_9_2.targets and arg_9_2.targets[arg_9_3] or arg_9_2.default_target
	local var_9_1 = arg_9_4 and arg_9_2.critical_strike
	local var_9_2
	local var_9_3
	local var_9_4 = arg_9_1
	local var_9_5 = arg_9_9
	local var_9_6 = arg_9_12
	local var_9_7 = arg_9_12
	local var_9_8 = arg_9_13
	local var_9_9 = arg_9_13

	if arg_9_7 then
		var_9_6 = arg_9_7
		var_9_7 = arg_9_7
		var_9_8 = arg_9_7
		var_9_9 = arg_9_7
	end

	local var_9_10 = ActionUtils.get_armor_power_modifier("attack", arg_9_2, var_9_0, var_9_6, var_9_8, var_9_1, arg_9_10)
	local var_9_11 = ActionUtils.get_armor_power_modifier("impact", arg_9_2, var_9_0, var_9_7, var_9_9, var_9_1, arg_9_10)
	local var_9_12 = arg_9_9 and arg_9_9.lord_armor

	if var_9_12 and var_9_8 == 6 and var_9_10 == 0 then
		var_9_10 = var_9_10 + ActionUtils.get_armor_power_modifier("attack", arg_9_2, var_9_0, var_9_6, nil, var_9_1, arg_9_10) * var_9_12
	end

	local var_9_13 = ActionUtils.get_power_level("attack", var_9_4, arg_9_2, var_9_0, var_9_1, arg_9_10, arg_9_5, arg_9_11)
	local var_9_14 = ActionUtils.get_power_level("impact", var_9_4, arg_9_2, var_9_0, var_9_1, arg_9_10, arg_9_5, arg_9_11)

	if var_9_5 then
		local var_9_15 = arg_9_0 and var_0_0(arg_9_0, "armor") or nil

		var_9_13 = ActionUtils.apply_buffs_to_power_level_on_hit(arg_9_5, var_9_13, arg_9_9, arg_9_8, arg_9_4, var_9_15)
		var_9_14 = ActionUtils.apply_buffs_to_power_level_on_hit(arg_9_5, var_9_14, arg_9_9, arg_9_8, arg_9_4, var_9_15)

		local var_9_16 = arg_9_7 or arg_9_13 or arg_9_12

		var_9_10 = ActionUtils.apply_buffs_to_armor_power_on_hit(arg_9_5, arg_9_0, var_9_10, var_9_16)
		var_9_11 = ActionUtils.apply_buffs_to_armor_power_on_hit(arg_9_5, arg_9_0, var_9_11, var_9_16)
	end

	local var_9_17 = var_9_13 * var_9_10
	local var_9_18 = var_9_14 * var_9_11

	if arg_9_9 and arg_9_9.is_player then
		local var_9_19 = var_9_0.attack_player_target_power_modifier
		local var_9_20 = var_9_0.impact_player_target_power_modifier

		var_9_17 = var_9_17 * (var_9_19 or 1)
		var_9_18 = var_9_18 * (var_9_20 or 1)
	end

	return var_9_17, var_9_18
end

ActionUtils.apply_buffs_to_power_level = function (arg_10_0, arg_10_1)
	local var_10_0 = ScriptUnit.has_extension(arg_10_0, "buff_system")

	if not var_10_0 then
		return arg_10_1
	end

	arg_10_1 = var_10_0:apply_buffs_to_value(arg_10_1, "power_level")

	return arg_10_1
end

ActionUtils.apply_buffs_to_power_level_on_hit = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	if not Unit.alive(arg_11_0) then
		return arg_11_1
	end

	local var_11_0 = ScriptUnit.has_extension(arg_11_0, "buff_system")

	if not var_11_0 then
		return arg_11_1
	end

	local var_11_1 = 1

	if arg_11_3 then
		local var_11_2 = rawget(ItemMasterList, arg_11_3)
		local var_11_3 = var_11_2 and var_11_2.template

		if var_11_3 then
			local var_11_4 = 1
			local var_11_5 = WeaponUtils.get_weapon_template(var_11_3)
			local var_11_6 = var_11_5.buff_type
			local var_11_7 = MeleeBuffTypes[var_11_6]
			local var_11_8 = RangedBuffTypes[var_11_6]
			local var_11_9 = var_11_5.weapon_type

			if var_11_7 then
				var_11_4 = var_11_0:apply_buffs_to_value(var_11_4, "power_level_melee")
			elseif var_11_8 then
				var_11_4 = var_11_0:apply_buffs_to_value(var_11_4, "power_level_ranged")
			end

			if var_11_9 and var_11_9 == "DRAKEFIRE" then
				var_11_4 = var_11_0:apply_buffs_to_value(var_11_4, "power_level_ranged_drakefire")
			end

			var_11_1 = var_11_1 + (var_11_4 - 1)
		end
	end

	local var_11_10 = 1
	local var_11_11 = arg_11_5 or arg_11_2 and arg_11_2.armor_category or 1

	if var_11_11 == 2 then
		var_11_10 = var_11_0:apply_buffs_to_value(var_11_10, "power_level_armoured")
	elseif var_11_11 == 3 then
		var_11_10 = var_11_0:apply_buffs_to_value(var_11_10, "power_level_large")
	elseif var_11_11 == 5 then
		var_11_10 = var_11_0:apply_buffs_to_value(var_11_10, "power_level_frenzy")
	elseif var_11_11 == 1 then
		var_11_10 = var_11_0:apply_buffs_to_value(var_11_10, "power_level_unarmoured")
	end

	local var_11_12 = var_11_1 + (var_11_10 - 1)
	local var_11_13 = 1
	local var_11_14 = var_0_0(arg_11_0, "race") or arg_11_2 and arg_11_2.race

	if var_11_14 == "chaos" or var_11_14 == "beastmen" then
		var_11_13 = var_11_0:apply_buffs_to_value(var_11_13, "power_level_chaos")
	elseif var_11_14 == "skaven" then
		var_11_13 = var_11_0:apply_buffs_to_value(var_11_13, "power_level_skaven")
	end

	local var_11_15 = var_11_12 + (var_11_13 - 1)

	if arg_11_4 then
		local var_11_16 = 1

		var_11_15 = var_11_15 + (var_11_0:apply_buffs_to_value(var_11_16, "power_level_critical_strike") - 1)
	end

	arg_11_1 = arg_11_1 * var_11_15

	return arg_11_1
end

ActionUtils.apply_buffs_to_armor_power_on_hit = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if ALIVE[arg_12_0] then
		local var_12_0 = ScriptUnit.has_extension(arg_12_0, "buff_system")

		if var_12_0 and arg_12_3 == 6 then
			arg_12_2 = var_12_0:apply_buffs_to_value(arg_12_2, "power_level_super_armour")
		end
	end

	if not ALIVE[arg_12_1] then
		return arg_12_2
	end

	local var_12_1 = ScriptUnit.has_extension(arg_12_1, "buff_system")

	if not var_12_1 then
		return arg_12_2
	end

	if arg_12_3 == 2 or arg_12_3 == 6 then
		arg_12_2 = var_12_1:apply_buffs_to_value(arg_12_2, "debuff_armoured")
	end

	return arg_12_2
end

ActionUtils.scale_charged_projectile_power_level = function (arg_13_0, arg_13_1, arg_13_2)
	if arg_13_1.scale_power_level then
		return math.max(arg_13_1.scale_power_level, arg_13_2) * arg_13_0
	end

	return arg_13_0
end

ActionUtils.scale_geiser_power_level = function (arg_14_0, arg_14_1)
	return (0.5 + 0.5 * arg_14_1) * arg_14_0
end

ActionUtils.get_melee_boost = function (arg_15_0, arg_15_1)
	local var_15_0 = ScriptUnit.has_extension(arg_15_0, "career_system")
	local var_15_1 = false
	local var_15_2 = 0

	if var_15_0 then
		var_15_1, var_15_2 = var_15_0:has_melee_boost()
	end

	if var_15_1 and arg_15_1 then
		var_15_2 = arg_15_1
	end

	return var_15_1, var_15_2
end

ActionUtils.get_ranged_boost = function (arg_16_0)
	local var_16_0 = ScriptUnit.has_extension(arg_16_0, "career_system")
	local var_16_1 = false
	local var_16_2 = 0

	if var_16_0 then
		var_16_1, var_16_2 = var_16_0:has_ranged_boost()
	end

	return var_16_1, var_16_2
end

ActionUtils.spawn_player_projectile = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, arg_17_11, arg_17_12, arg_17_13, arg_17_14)
	arg_17_3 = arg_17_3 or 100

	local var_17_0 = Managers.state.entity:system("projectile_system")
	local var_17_1 = 0

	var_17_0:spawn_player_projectile(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, var_17_1, arg_17_11, arg_17_12, arg_17_13, arg_17_14)
end

ActionUtils.spawn_pickup_projectile = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10, arg_18_11)
	local var_18_0 = arg_18_4.projectile_info.pickup_name
	local var_18_1 = NetworkLookup.husks[arg_18_2]
	local var_18_2 = NetworkLookup.go_types[arg_18_3]
	local var_18_3 = AiAnimUtils.position_network_scale(arg_18_6, true)
	local var_18_4 = AiAnimUtils.rotation_network_scale(arg_18_7, true)
	local var_18_5 = AiAnimUtils.velocity_network_scale(arg_18_8, true)
	local var_18_6 = AiAnimUtils.velocity_network_scale(arg_18_9, true)
	local var_18_7 = NetworkLookup.pickup_names[var_18_0]
	local var_18_8 = NetworkLookup.pickup_spawn_types[arg_18_11]
	local var_18_9 = ScriptUnit.has_extension(arg_18_1, "tutorial_system")
	local var_18_10 = var_18_9 and var_18_9.always_show or false
	local var_18_11 = var_18_9 and (var_18_9.proxy_active or var_18_9.active) or false

	if ScriptUnit.has_extension(arg_18_1, "death_system") then
		local var_18_12 = ScriptUnit.extension(arg_18_1, "health_system")

		var_18_12.thrown = true

		local var_18_13 = var_18_12.damage
		local var_18_14 = 0
		local var_18_15 = 6
		local var_18_16

		if var_18_12.ignited then
			local var_18_17 = var_18_12:health_data()

			var_18_14 = var_18_17.explode_time
			var_18_15 = var_18_17.fuse_time
			var_18_16 = var_18_17.attacker_unit_id
		end

		var_18_16 = var_18_16 or NetworkConstants.invalid_game_object_id

		local var_18_18 = NetworkLookup.item_names[arg_18_10]

		if ScriptUnit.has_extension(arg_18_1, "limited_item_track_system") then
			local var_18_19 = ScriptUnit.extension(arg_18_1, "limited_item_track_system")

			var_18_19.thrown = true

			local var_18_20 = var_18_19.id
			local var_18_21 = var_18_19.spawner_unit
			local var_18_22 = LevelHelper:current_level(arg_18_0)
			local var_18_23 = var_18_21 and Level.unit_index(var_18_22, var_18_21) or 0

			var_18_2 = NetworkLookup.go_types.explosive_pickup_projectile_unit_limited

			Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_explosive_pickup_projectile_limited", var_18_1, var_18_2, var_18_3, var_18_4, var_18_5, var_18_6, var_18_7, var_18_23, var_18_20, var_18_13, var_18_14, var_18_15, var_18_16, var_18_18, var_18_8, var_18_10, var_18_11)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_explosive_pickup_projectile", var_18_1, var_18_2, var_18_3, var_18_4, var_18_5, var_18_6, var_18_7, var_18_13, var_18_14, var_18_15, var_18_16, var_18_18, var_18_8, var_18_10, var_18_11)
		end
	elseif ScriptUnit.has_extension(arg_18_1, "limited_item_track_system") then
		local var_18_24 = ScriptUnit.extension(arg_18_1, "limited_item_track_system")

		var_18_24.thrown = true

		local var_18_25 = var_18_24.id
		local var_18_26 = var_18_24.spawner_unit
		local var_18_27 = LevelHelper:current_level(arg_18_0)
		local var_18_28 = var_18_26 and Level.unit_index(var_18_27, var_18_26) or 0

		var_18_2 = NetworkLookup.go_types.pickup_projectile_unit_limited

		Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_projectile_limited", var_18_1, var_18_2, var_18_3, var_18_4, var_18_5, var_18_6, var_18_7, var_18_28, var_18_25, var_18_8, var_18_10, var_18_11)
	else
		local var_18_29 = ScriptUnit.has_extension(arg_18_1, "ammo_system")
		local var_18_30 = var_18_29 and var_18_29:max_ammo() or 1
		local var_18_31 = NetworkLookup.material_settings_templates["n/a"]

		Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_projectile", var_18_1, var_18_2, var_18_3, var_18_4, var_18_5, var_18_6, var_18_7, var_18_8, var_18_30, var_18_10, var_18_11, var_18_31)
	end
end

ActionUtils.spawn_true_flight_projectile = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14)
	local var_19_0 = Managers.state.entity:system("projectile_system")
	local var_19_1 = TrueFlightTemplatesLookup[arg_19_2]

	var_19_0:spawn_true_flight_projectile(arg_19_0, arg_19_1, var_19_1, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14)
end

ActionUtils.get_action_time_scale = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_3 or arg_20_1.anim_time_scale or 1

	if arg_20_0 and Unit.alive(arg_20_0) then
		local var_20_1 = ScriptUnit.has_extension(arg_20_0, "buff_system")

		if var_20_1 then
			local var_20_2 = arg_20_1.custom_anim_time_scale_mult

			if var_20_2 then
				var_20_0 = var_20_0 * var_20_2(arg_20_0, var_20_0, arg_20_2)
			end

			local var_20_3 = ScriptUnit.has_extension(arg_20_0, "inventory_system"):get_wielded_slot_item_template()

			if var_20_3 then
				local var_20_4 = var_20_3.buff_type
				local var_20_5 = MeleeBuffTypes[var_20_4]
				local var_20_6 = RangedBuffTypes[var_20_4]
				local var_20_7 = var_20_3.weapon_type

				if var_20_5 then
					var_20_0 = var_20_1:apply_buffs_to_value(var_20_0, "attack_speed")
					var_20_0 = var_20_1:apply_buffs_to_value(var_20_0, "attack_speed_melee")
				elseif var_20_6 then
					var_20_0 = var_20_1:apply_buffs_to_value(var_20_0, "attack_speed")
				end

				if var_20_7 and var_20_7 == "DRAKEFIRE" then
					var_20_0 = var_20_1:apply_buffs_to_value(var_20_0, "attack_speed_drakefire")
				end

				if arg_20_1.scale_chain_window_by_charge_time_buff or arg_20_1.scale_anim_by_charge_time_buff and arg_20_2 then
					var_20_0 = var_20_0 * (1 / var_20_1:apply_buffs_to_value(1, "reduced_ranged_charge_time"))
				end
			end
		end
	end

	return var_20_0
end

ActionUtils.init_action_buff_data = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0.buff_start_times
	local var_21_1 = arg_21_0.buff_end_times
	local var_21_2 = arg_21_0.action_buffs_in_progress
	local var_21_3 = arg_21_0.buff_identifiers

	for iter_21_0, iter_21_1 in ipairs(arg_21_1) do
		local var_21_4 = arg_21_2 + (iter_21_1.start_time or 0)
		local var_21_5 = iter_21_1.end_time or math.huge
		local var_21_6 = #var_21_0 + 1

		var_21_0[var_21_6] = var_21_4
		var_21_1[var_21_6] = var_21_4 + var_21_5
		var_21_2[var_21_6] = false
		var_21_3[var_21_6] = ""
	end
end

local var_0_3 = {}

ActionUtils.update_action_buff_data = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0.buff_start_times
	local var_22_1 = arg_22_0.buff_end_times
	local var_22_2 = arg_22_0.buff_identifiers
	local var_22_3 = arg_22_0.action_buffs_in_progress

	for iter_22_0, iter_22_1 in ipairs(var_22_0) do
		if iter_22_1 <= arg_22_3 then
			local var_22_4 = arg_22_1[iter_22_0]
			local var_22_5 = var_22_4.buff_name

			var_0_3.external_optional_bonus = var_22_4.external_value
			var_0_3.external_optional_multiplier = var_22_4.external_multiplier
			var_22_0[iter_22_0] = math.huge
			var_22_2[iter_22_0] = ScriptUnit.extension(arg_22_2, "buff_system"):add_buff(var_22_5, var_0_3)
			var_22_3[iter_22_0] = true
		end
	end

	for iter_22_2, iter_22_3 in ipairs(var_22_1) do
		if iter_22_3 <= arg_22_3 then
			var_22_1[iter_22_2] = math.huge
			var_22_3[iter_22_2] = false

			local var_22_6 = ScriptUnit.extension(arg_22_2, "buff_system")
			local var_22_7 = var_22_2[iter_22_2]

			var_22_6:remove_buff(var_22_7)
		end
	end
end

ActionUtils.remove_action_buff_data = function (arg_23_0, arg_23_1, arg_23_2)
	if ALIVE[arg_23_2] then
		local var_23_0 = arg_23_0.action_buffs_in_progress
		local var_23_1 = ScriptUnit.has_extension(arg_23_2, "buff_system")
		local var_23_2 = arg_23_0.buff_identifiers

		if var_23_1 then
			for iter_23_0, iter_23_1 in ipairs(var_23_0) do
				if iter_23_1 then
					local var_23_3 = var_23_2[iter_23_0]

					var_23_1:remove_buff(var_23_3)
				end
			end
		end
	end
end

ActionUtils.start_charge_sound = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_3.charge_sound_switch
	local var_24_1 = arg_24_3.charge_sound_name
	local var_24_2 = arg_24_3.charge_sound_parameter_name

	if not arg_24_3.charge_sound_name then
		return
	end

	local var_24_3 = WwiseWorld.make_auto_source(arg_24_0, arg_24_1)

	if var_24_0 then
		if ScriptUnit.extension(arg_24_2, "overcharge_system"):above_overcharge_threshold() then
			WwiseWorld.set_switch(arg_24_0, var_24_0, "above_overcharge_threshold", var_24_3)
		else
			WwiseWorld.set_switch(arg_24_0, var_24_0, "below_overcharge_threshold", var_24_3)
		end
	end

	local var_24_4 = WwiseWorld.trigger_event(arg_24_0, var_24_1, var_24_3)

	if var_24_2 then
		WwiseWorld.set_source_parameter(arg_24_0, var_24_3, var_24_2, 1)
	end

	return var_24_4, var_24_3
end

ActionUtils.stop_charge_sound = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_3.charge_sound_stop_event

	if not var_25_0 or not arg_25_2 then
		return
	end

	if not WwiseWorld.is_playing(arg_25_0, arg_25_1) then
		return
	end

	WwiseWorld.trigger_event(arg_25_0, var_25_0, arg_25_2)
end

ActionUtils.play_husk_sound_event = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if not arg_26_1 then
		return
	end

	if not Unit.alive(arg_26_2) then
		return
	end

	local var_26_0 = Managers.player.is_server
	local var_26_1 = Managers.state.network
	local var_26_2 = var_26_1.network_transmit
	local var_26_3 = var_26_1:unit_game_object_id(arg_26_2)
	local var_26_4 = NetworkLookup.sound_events[arg_26_1]
	local var_26_5 = Managers.state.network:game()

	if not var_26_3 then
		return
	end

	if var_26_0 and arg_26_3 then
		local var_26_6 = WwiseWorld.make_auto_source(arg_26_0, arg_26_2)

		WwiseWorld.trigger_event(arg_26_0, arg_26_1, var_26_6)
	end

	if var_26_5 then
		if var_26_0 then
			var_26_2:send_rpc_clients("rpc_play_husk_sound_event", var_26_3, var_26_4)
		else
			var_26_2:send_rpc_server("rpc_play_husk_sound_event", var_26_3, var_26_4)
		end
	end
end

ActionUtils.get_critical_strike_chance = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = ScriptUnit.extension(arg_27_0, "career_system")
	local var_27_1 = ScriptUnit.extension(arg_27_0, "buff_system")
	local var_27_2 = var_27_0:get_base_critical_strike_chance() + (arg_27_2 and arg_27_2.additional_critical_strike_chance or arg_27_1.additional_critical_strike_chance or 0)
	local var_27_3 = arg_27_1.kind

	if var_27_3 == "sweep" or var_27_3 == "push_stagger" or var_27_3 == "shield_slam" then
		var_27_2 = var_27_1:apply_buffs_to_value(var_27_2, "critical_strike_chance_melee")
	else
		var_27_2 = var_27_1:apply_buffs_to_value(var_27_2, "critical_strike_chance_ranged")
	end

	local var_27_4 = DamageProfileTemplates[arg_27_1.damage_profile] or DamageProfileTemplates[arg_27_1.damage_profile_left] or DamageProfileTemplates[arg_27_1.damage_profile_right]

	if var_27_4 and var_27_4.charge_value == "heavy_attack" then
		var_27_2 = var_27_1:apply_buffs_to_value(var_27_2, "critical_strike_chance_heavy")
	end

	return (var_27_1:apply_buffs_to_value(var_27_2, "critical_strike_chance"))
end

local var_0_4 = false

ActionUtils.is_critical_strike = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = ScriptUnit.extension(arg_28_0, "buff_system")
	local var_28_1 = ScriptUnit.has_extension(arg_28_0, "talent_system")
	local var_28_2 = false

	if script_data.no_critical_strikes then
		var_28_2 = false
	elseif script_data.always_critical_strikes then
		var_28_2 = true
	elseif script_data.alternating_critical_strikes then
		var_0_4 = not var_0_4
		var_28_2 = var_0_4
	elseif var_28_0:has_buff_perk("guaranteed_crit") then
		var_28_2 = true
	elseif var_28_1 and var_28_1:has_talent_perk("no_random_crits") then
		var_28_2 = false
	else
		local var_28_3 = ActionUtils.get_critical_strike_chance(arg_28_0, arg_28_1, arg_28_3 or arg_28_1)

		var_28_2 = var_28_0:has_procced(var_28_3, arg_28_1 or "ACTION_UNKNOWN")
	end

	local var_28_4 = arg_28_1.kind

	if var_28_4 ~= "push_stagger" then
		if var_28_2 then
			var_28_0:trigger_procs("on_critical_action", var_28_4)
		else
			var_28_0:trigger_procs("on_non_critical_action", var_28_4)
		end
	end

	return var_28_2
end

ActionUtils.pitch_from_rotation = function (arg_29_0)
	local var_29_0 = Vector3.normalize(Quaternion.forward(arg_29_0))
	local var_29_1 = Vector3.normalize(Vector3.flat(var_29_0))
	local var_29_2 = Vector3.dot(var_29_0, var_29_1)
	local var_29_3 = math.clamp(var_29_2, -1, 1)
	local var_29_4 = math.radians_to_degrees(math.acos(var_29_3))
	local var_29_5 = Vector3(0, 0, 1)

	if Vector3.dot(var_29_0, var_29_5) < 0 then
		var_29_4 = -var_29_4
	end

	return var_29_4
end

ActionUtils.redirect_shield_hit = function (arg_30_0, arg_30_1)
	local var_30_0 = var_0_0(arg_30_0, "shield_owner_unit")

	if not HEALTH_ALIVE[var_30_0] then
		return arg_30_0, arg_30_1
	end

	local var_30_1 = var_0_1(var_30_0, var_0_2(var_30_0, "c_leftforearm"))

	return var_30_0, var_30_1
end

ActionUtils.resolve_action_selector = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	if not arg_31_0 then
		return nil
	end

	if arg_31_0.kind ~= "action_selector" then
		return arg_31_0, arg_31_0.lookup_data.action_name, arg_31_0.lookup_data.sub_action_name
	end

	local var_31_0 = arg_31_0.default_action
	local var_31_1 = arg_31_0.conditional_actions

	for iter_31_0 = 1, #var_31_1 do
		if var_31_1[iter_31_0].condition(arg_31_1, arg_31_2, arg_31_3, arg_31_4) then
			var_31_0 = var_31_1[iter_31_0]

			break
		end
	end

	local var_31_2 = var_31_0.action or arg_31_0.lookup_data.action_name
	local var_31_3 = var_31_0.sub_action

	return WeaponUtils.get_weapon_template(arg_31_0.lookup_data.item_template_name).actions[var_31_2][var_31_3], var_31_2, var_31_3
end

ActionUtils.get_push_damage_profile = function (arg_32_0)
	if arg_32_0 then
		return arg_32_0.damage_profile_inner, arg_32_0.damage_profile_outer
	end

	return nil, nil
end

ActionUtils.get_damage_profile_name = function (arg_33_0, arg_33_1)
	if arg_33_0 then
		arg_33_1 = arg_33_1 or arg_33_0.weapon_action_hand

		local var_33_0 = arg_33_0.impact_data
		local var_33_1 = var_33_0 and var_33_0.damage_profile or arg_33_0.damage_profile
		local var_33_2 = var_33_0 and var_33_0.damage_profile_left or arg_33_0.damage_profile_left
		local var_33_3 = var_33_0 and var_33_0.damage_profile_right or arg_33_0.damage_profile_right

		if arg_33_1 == "both" then
			return var_33_2, var_33_3
		end

		if arg_33_1 == "left" then
			return var_33_1 or var_33_2, nil
		end

		if arg_33_1 == "right" then
			local var_33_4 = var_33_1 or var_33_3

			return nil, var_33_4
		end

		return nil, var_33_1
	end

	return nil, nil
end

ActionUtils.get_damage_profile_performance_scores = function (arg_34_0)
	local var_34_0 = {
		0,
		0,
		0,
		0,
		0,
		0
	}

	if arg_34_0 then
		local var_34_1 = DamageProfileTemplates[arg_34_0]
		local var_34_2 = var_34_1.targets and var_34_1.targets[1] or var_34_1.default_target
		local var_34_3 = ActionUtils.get_power_multiplier("attack", var_34_1, var_34_2, nil)

		for iter_34_0 = 1, 5 do
			var_34_0[iter_34_0] = var_34_3 * ActionUtils.get_armor_power_modifier("attack", var_34_1, var_34_2, iter_34_0)
		end

		var_34_0[6] = var_34_3 * ActionUtils.get_armor_power_modifier("attack", var_34_1, var_34_2, 2, 6)
	end

	return var_34_0
end

ActionUtils.get_performance_scores_for_sub_action = function (arg_35_0)
	local var_35_0
	local var_35_1, var_35_2 = ActionUtils.get_damage_profile_name(arg_35_0)

	if var_35_1 then
		var_35_0 = ActionUtils.get_damage_profile_performance_scores(var_35_1)
	end

	if var_35_2 then
		if not var_35_1 then
			var_35_0 = ActionUtils.get_damage_profile_performance_scores(var_35_2)
		else
			local var_35_3 = ActionUtils.get_damage_profile_performance_scores(var_35_2)

			for iter_35_0 = 1, #var_35_3 do
				var_35_0[iter_35_0] = var_35_0[iter_35_0] + var_35_3[iter_35_0]
			end
		end
	end

	return var_35_0
end

ActionUtils.is_melee_start_sub_action = function (arg_36_0)
	if not arg_36_0 then
		return false
	end

	if arg_36_0.kind == "melee_start" then
		return true
	end

	return arg_36_0.melee_start
end

ActionUtils.is_backstab = function (arg_37_0, arg_37_1)
	local var_37_0 = POSITION_LOOKUP[arg_37_0]
	local var_37_1 = POSITION_LOOKUP[arg_37_1]
	local var_37_2 = Vector3.normalize(var_37_1 - var_37_0)
	local var_37_3 = Quaternion.forward(Unit.local_rotation(arg_37_1, 0))
	local var_37_4 = Vector3.dot(var_37_3, var_37_2)

	return var_37_4 >= 0.55 and var_37_4 <= 1
end
