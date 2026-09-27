-- chunkname: @scripts/helpers/action_utils.lua

require("scripts/helpers/pseudo_random_distribution")

local ActionUtils = ActionUtils

ActionUtils = ActionUtils or {}
ActionUtils = ActionUtils

local get_data = Unit.get_data
local actor = Unit.actor
local find_actor = Unit.find_actor
local script_data = script_data
local no_critical_strikes = script_data.no_critical_strikes

no_critical_strikes = no_critical_strikes or Development.parameter("no_critical_strikes")
script_data.no_critical_strikes = no_critical_strikes

local script_data_2 = script_data
local always_critical_strikes = script_data.always_critical_strikes

always_critical_strikes = always_critical_strikes or Development.parameter("always_critical_strikes")
script_data_2.always_critical_strikes = always_critical_strikes

local script_data_3 = script_data
local alternating_critical_strikes = script_data.alternating_critical_strikes

alternating_critical_strikes = alternating_critical_strikes or Development.parameter("alternating_critical_strikes")
script_data_3.alternating_critical_strikes = alternating_critical_strikes

ActionUtils.get_power_level_percentage = function (arg_1_0)
	-- function 1
	local MIN_POWER_LEVEL = MIN_POWER_LEVEL
	local MAX_POWER_LEVEL = MAX_POWER_LEVEL

	return (arg_1_0 - MIN_POWER_LEVEL) / (MAX_POWER_LEVEL - MIN_POWER_LEVEL)
end

ActionUtils.get_max_targets = function (self, arg_2_1)
	-- function 2
	local cleave_distribution = self.cleave_distribution

	cleave_distribution = cleave_distribution or DefaultCleaveDistribution

	local num = Cleave.max - Cleave.min
	local num_2 = arg_2_1 * cleave_distribution.attack
	local num_3 = num * ActionUtils.get_power_level_percentage(num_2)
	local num_4 = arg_2_1 * cleave_distribution.impact
	local num_5 = num * ActionUtils.get_power_level_percentage(num_4)

	return num_3, num_5
end

ActionUtils.get_target_armor = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0
	local var_3_1
	local var_3_2
	local var_3_3
	local var_3_4

	if not arg_3_2 then
		var_3_0 = arg_3_2
		var_3_1 = arg_3_2

		return var_3_0, var_3_1
	end

	if not arg_3_1 and not arg_3_0 then
		local hitzone_armor_categories = arg_3_1.hitzone_armor_categories
		local flag = not hitzone_armor_categories and hitzone_armor_categories[arg_3_0] and arg_3_1.armor_category

		if type(flag) == "table" then
			var_3_0 = flag.attack
			var_3_1 = flag.impact
		else
			var_3_0 = flag
			var_3_1 = flag
		end

		local hitzone_primary_armor_categories = arg_3_1.hitzone_primary_armor_categories
		local var_3_8

		if not hitzone_primary_armor_categories then
			var_3_8 = hitzone_primary_armor_categories[arg_3_0]

			if not var_3_8 then
				-- Nothing
			end
		end

		var_3_8 = arg_3_1.primary_armor_category

		::label_3_0::

		if type(var_3_8) == "table" then
			var_3_3 = var_3_8.attack
			var_3_4 = var_3_8.impact
		else
			var_3_3 = var_3_8
			var_3_4 = var_3_8
		end
	elseif not arg_3_1 then
		var_3_0 = arg_3_1.armor_category
		var_3_1 = arg_3_1.armor_category
		var_3_3 = arg_3_1.primary_armor_category
		var_3_4 = arg_3_1.primary_armor_category
	else
		local num = 1

		var_3_0 = num
		var_3_1 = num
	end

	return var_3_0, var_3_1, var_3_3, var_3_4
end

ActionUtils.get_range_scalar_multiplier = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local range_modifier_settings = arg_4_1.range_modifier_settings

	range_modifier_settings = range_modifier_settings or self.range_modifier_settings

	if not range_modifier_settings then
		return 0
	end

	local var_4_1 = POSITION_LOOKUP[arg_4_2]

	var_4_1 = var_4_1 or Unit.world_position(arg_4_2, 0)

	local var_4_2 = POSITION_LOOKUP[arg_4_3]

	var_4_2 = var_4_2 or Unit.world_position(arg_4_3, 0)

	local distance = Vector3.distance(var_4_2, var_4_1)
	local distance_scaling_steps = range_modifier_settings.distance_scaling_steps

	if not distance_scaling_steps then
		local var_4_5

		if distance < distance_scaling_steps[1].distance then
			return 0
		elseif distance > distance_scaling_steps[#distance_scaling_steps].distance then
			return distance_scaling_steps[#distance_scaling_steps].multiplier
		else
			for i = 1, #distance_scaling_steps - 1 do
				if not (not (distance > distance_scaling_steps[i].distance) or not (distance < distance_scaling_steps[i + 1].distance)) then
					return distance_scaling_steps[i].multiplier
				end
			end
		end

		assert(false, "Setting: [distance_scaling_steps] range_multiplier never gets assigned a value")
	else
		local dropoff_start = range_modifier_settings.dropoff_start
		local dropoff_end = range_modifier_settings.dropoff_end

		if not ScriptUnit.has_extension(arg_4_2, "buff_system"):has_buff_perk("no_damage_dropoff") then
			dropoff_start = dropoff_start * 2
			dropoff_end = dropoff_end * 2
		end

		local num = dropoff_end - dropoff_start

		return math.clamp(distance - dropoff_start, 0, num) / num
	end
end

ActionUtils.get_armor_power_modifier = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	local armor_modifier = arg_5_2.armor_modifier

	if not armor_modifier then
		armor_modifier = arg_5_1.armor_modifier
		armor_modifier = armor_modifier or DefaultArmorPowerModifier
	end

	local armor_modifier_near = arg_5_2.armor_modifier_near

	armor_modifier_near = armor_modifier_near or arg_5_1.armor_modifier_near

	local armor_modifier_far = arg_5_2.armor_modifier_far

	armor_modifier_far = armor_modifier_far or arg_5_1.armor_modifier_far

	local var_5_3
	local var_5_4

	if not arg_5_5 then
		var_5_4 = arg_5_5[arg_5_0 .. "_armor_power_modifer"]
	end

	if not var_5_4 and not var_5_4[arg_5_3] then
		var_5_3 = not arg_5_4 and var_5_4[arg_5_4] and var_5_4[arg_5_3]
	elseif not armor_modifier_near and not armor_modifier_far and not arg_5_6 then
		local var_5_5

		if not arg_5_4 then
			var_5_5 = armor_modifier_near[arg_5_0][arg_5_4]

			if not var_5_5 then
				-- Nothing
			end
		end

		var_5_5 = armor_modifier_near[arg_5_0][arg_5_3]
		var_5_5 = var_5_5 or 1

		do
			local var_5_6
		end

		::label_5_0::

		if not arg_5_4 then
			var_5_6 = armor_modifier_far[arg_5_0][arg_5_4]

			if not var_5_6 then
				-- Nothing
			end
		end

		var_5_6 = armor_modifier_far[arg_5_0][arg_5_3]
		var_5_6 = var_5_6 or 1

		::label_5_1::

		var_5_3 = math.lerp(var_5_5, var_5_6, arg_5_6)
	else
		var_5_3 = not arg_5_4 and armor_modifier[arg_5_0][arg_5_4] and armor_modifier[arg_5_0][arg_5_3] or 1
	end

	return var_5_3
end

ActionUtils.scale_power_levels = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local clamp = math.clamp(arg_6_0, MIN_POWER_LEVEL, MAX_POWER_LEVEL)

	if not Managers and not Managers.state.game_mode:setting("cap_power_level") then
		local var_6_1 = DifficultySettings[arg_6_3]
		local power_level_cap = var_6_1.power_level_cap
		local MAX_POWER_LEVEL = MAX_POWER_LEVEL
		local power_level_max_target = var_6_1.power_level_max_target

		if not (power_level_cap < clamp) or not power_level_max_target then
			clamp = power_level_cap + power_level_max_target * ((clamp - power_level_cap) / (MAX_POWER_LEVEL - power_level_cap))
		else
			clamp = math.min(arg_6_0, power_level_cap)
		end
	end

	local var_6_5 = clamp

	if clamp >= MIN_POWER_LEVEL_CAP then
		local num = 50
		local num_2 = 100
		local num_3 = 10
		local var_6_9

		if clamp >= MIN_POWER_LEVEL_CAP + num_2 then
			var_6_9 = (clamp - MIN_POWER_LEVEL_CAP) * ((POWER_LEVEL_DIFF_RATIO[arg_6_1] - 1) / (num_3 - 1))
		else
			var_6_9 = (clamp + num * (1 - (clamp - 200) / num_2) - MIN_POWER_LEVEL_CAP) * ((POWER_LEVEL_DIFF_RATIO[arg_6_1] - 1) / (num_3 - 1))
		end

		var_6_5 = MIN_POWER_LEVEL_CAP + var_6_9
	end

	if not arg_6_2 then
		var_6_5 = ActionUtils.apply_buffs_to_power_level(arg_6_2, var_6_5)
	end

	return var_6_5
end

ActionUtils.get_power_multiplier = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local power_distribution = arg_7_2.power_distribution

	if not power_distribution then
		power_distribution = arg_7_1.power_distribution
		power_distribution = power_distribution or DefaultPowerDistribution
	end

	local power_distribution_near = arg_7_2.power_distribution_near

	power_distribution_near = power_distribution_near or arg_7_1.power_distribution_near

	local power_distribution_far = arg_7_2.power_distribution_far

	power_distribution_far = power_distribution_far or arg_7_1.power_distribution_far

	local var_7_3

	if not arg_7_3 and not (arg_7_3 >= 0) or not distance_scaling_steps then
		var_7_3 = arg_7_3
	elseif not power_distribution_near and not power_distribution_far and not arg_7_3 then
		local var_7_4 = power_distribution_near[arg_7_0]
		local var_7_5 = power_distribution_far[arg_7_0]

		var_7_3 = math.lerp(var_7_4, var_7_5, arg_7_3)
	else
		var_7_3 = power_distribution[arg_7_0]
	end

	return var_7_3
end

ActionUtils.get_power_level = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	-- function 8
	local get_power_multiplier = ActionUtils.get_power_multiplier(arg_8_0, arg_8_2, arg_8_3, arg_8_5)

	return ActionUtils.scale_power_levels(arg_8_1, arg_8_0, arg_8_6, arg_8_7) * get_power_multiplier
end

ActionUtils.get_power_level_for_target = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13)
	-- function 9
	local var_9_0

	if not arg_9_2.targets then
		var_9_0 = arg_9_2.targets[arg_9_3]

		if not var_9_0 then
			-- Nothing
		end
	end

	var_9_0 = arg_9_2.default_target

	::label_9_0::

	local flag = not arg_9_4 and arg_9_2.critical_strike
	local var_9_2
	local var_9_3
	local var_9_4 = arg_9_1
	local var_9_5 = arg_9_9
	local var_9_6 = arg_9_12
	local var_9_7 = arg_9_12
	local var_9_8 = arg_9_13
	local var_9_9 = arg_9_13

	if not arg_9_7 then
		var_9_6 = arg_9_7
		var_9_7 = arg_9_7
		var_9_8 = arg_9_7
		var_9_9 = arg_9_7
	end

	local get_armor_power_modifier = ActionUtils.get_armor_power_modifier("attack", arg_9_2, var_9_0, var_9_6, var_9_8, flag, arg_9_10)
	local get_armor_power_modifier_2 = ActionUtils.get_armor_power_modifier("impact", arg_9_2, var_9_0, var_9_7, var_9_9, flag, arg_9_10)
	local flag_2 = not arg_9_9 and arg_9_9.lord_armor

	if not (not flag_2 and var_9_8 ~= 6 or get_armor_power_modifier ~= 0) then
		get_armor_power_modifier = get_armor_power_modifier + ActionUtils.get_armor_power_modifier("attack", arg_9_2, var_9_0, var_9_6, nil, flag, arg_9_10) * flag_2
	end

	local get_power_level = ActionUtils.get_power_level("attack", var_9_4, arg_9_2, var_9_0, flag, arg_9_10, arg_9_5, arg_9_11)
	local get_power_level_2 = ActionUtils.get_power_level("impact", var_9_4, arg_9_2, var_9_0, flag, arg_9_10, arg_9_5, arg_9_11)

	if not var_9_5 then
		local var_9_15

		if not arg_9_0 then
			var_9_15 = get_data(arg_9_0, "armor")

			if not var_9_15 then
				-- Nothing
			end
		end

		var_9_15 = nil

		::label_9_1::

		get_power_level = ActionUtils.apply_buffs_to_power_level_on_hit(arg_9_5, get_power_level, arg_9_9, arg_9_8, arg_9_4, var_9_15)
		get_power_level_2 = ActionUtils.apply_buffs_to_power_level_on_hit(arg_9_5, get_power_level_2, arg_9_9, arg_9_8, arg_9_4, var_9_15)

		local flag_3 = arg_9_7 or arg_9_13 or arg_9_12

		get_armor_power_modifier = ActionUtils.apply_buffs_to_armor_power_on_hit(arg_9_5, arg_9_0, get_armor_power_modifier, flag_3)
		get_armor_power_modifier_2 = ActionUtils.apply_buffs_to_armor_power_on_hit(arg_9_5, arg_9_0, get_armor_power_modifier_2, flag_3)
	end

	local num = get_power_level * get_armor_power_modifier
	local num_2 = get_power_level_2 * get_armor_power_modifier_2

	if not (not arg_9_9 and arg_9_9.is_player) then
		local attack_player_target_power_modifier = var_9_0.attack_player_target_power_modifier
		local impact_player_target_power_modifier = var_9_0.impact_player_target_power_modifier

		num = num * (attack_player_target_power_modifier or 1)
		num_2 = num_2 * (impact_player_target_power_modifier or 1)
	end

	return num, num_2
end

ActionUtils.apply_buffs_to_power_level = function (arg_10_0, arg_10_1)
	-- function 10
	local has_extension = ScriptUnit.has_extension(arg_10_0, "buff_system")

	if not has_extension then
		return arg_10_1
	end

	arg_10_1 = has_extension:apply_buffs_to_value(arg_10_1, "power_level")

	return arg_10_1
end

ActionUtils.apply_buffs_to_power_level_on_hit = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	if not Unit.alive(arg_11_0) then
		return arg_11_1
	end

	local has_extension = ScriptUnit.has_extension(arg_11_0, "buff_system")

	if not has_extension then
		return arg_11_1
	end

	local num = 1

	if not arg_11_3 then
		local var_11_2 = rawget(ItemMasterList, arg_11_3)
		local flag = not var_11_2 and var_11_2.template

		if not flag then
			local num_2 = 1
			local get_weapon_template = WeaponUtils.get_weapon_template(flag)
			local buff_type = get_weapon_template.buff_type
			local var_11_7 = MeleeBuffTypes[buff_type]
			local var_11_8 = RangedBuffTypes[buff_type]
			local weapon_type = get_weapon_template.weapon_type

			if not var_11_7 then
				num_2 = has_extension:apply_buffs_to_value(num_2, "power_level_melee")
			elseif not var_11_8 then
				num_2 = has_extension:apply_buffs_to_value(num_2, "power_level_ranged")
			end

			if not (not weapon_type and weapon_type ~= "DRAKEFIRE") then
				num_2 = has_extension:apply_buffs_to_value(num_2, "power_level_ranged_drakefire")
			end

			num = num + (num_2 - 1)
		end
	end

	local num_3 = 1

	if not arg_11_5 then
		-- Nothing
	end

	do
		local armor_category
	end

	::label_11_0::

	if not arg_11_2 then
		armor_category = arg_11_2.armor_category

		if not armor_category then
			-- Nothing
		end
	end

	armor_category = 1

	::label_11_1::

	if armor_category == 2 then
		num_3 = has_extension:apply_buffs_to_value(num_3, "power_level_armoured")
	elseif armor_category == 3 then
		num_3 = has_extension:apply_buffs_to_value(num_3, "power_level_large")
	elseif armor_category == 5 then
		num_3 = has_extension:apply_buffs_to_value(num_3, "power_level_frenzy")
	elseif armor_category == 1 then
		num_3 = has_extension:apply_buffs_to_value(num_3, "power_level_unarmoured")
	end

	local num_4 = num + (num_3 - 1)
	local num_5 = 1
	local flag_2 = not arg_11_2 and arg_11_2.race and get_data(arg_11_0, "race")

	if not (flag_2 == "chaos" or flag_2 ~= "beastmen") then
		num_5 = has_extension:apply_buffs_to_value(num_5, "power_level_chaos")
	elseif flag_2 == "skaven" then
		num_5 = has_extension:apply_buffs_to_value(num_5, "power_level_skaven")
	end

	local num_6 = num_4 + (num_5 - 1)

	if not arg_11_4 then
		local num_7 = 1

		num_6 = num_6 + (has_extension:apply_buffs_to_value(num_7, "power_level_critical_strike") - 1)
	end

	arg_11_1 = arg_11_1 * num_6

	return arg_11_1
end

ActionUtils.apply_buffs_to_armor_power_on_hit = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not ALIVE[arg_12_0] then
		local has_extension = ScriptUnit.has_extension(arg_12_0, "buff_system")

		if not (not has_extension and arg_12_3 ~= 6) then
			arg_12_2 = has_extension:apply_buffs_to_value(arg_12_2, "power_level_super_armour")
		end
	end

	if not ALIVE[arg_12_1] then
		return arg_12_2
	end

	local has_extension_2 = ScriptUnit.has_extension(arg_12_1, "buff_system")

	if not has_extension_2 then
		return arg_12_2
	end

	if not (arg_12_3 == 2 or arg_12_3 ~= 6) then
		arg_12_2 = has_extension_2:apply_buffs_to_value(arg_12_2, "debuff_armoured")
	end

	return arg_12_2
end

ActionUtils.scale_charged_projectile_power_level = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	if not arg_13_1.scale_power_level then
		return math.max(arg_13_1.scale_power_level, arg_13_2) * arg_13_0
	end

	return arg_13_0
end

ActionUtils.scale_geiser_power_level = function (arg_14_0, arg_14_1)
	-- function 14
	return (0.5 + 0.5 * arg_14_1) * arg_14_0
end

ActionUtils.get_melee_boost = function (arg_15_0, arg_15_1)
	-- function 15
	local has_extension = ScriptUnit.has_extension(arg_15_0, "career_system")
	local flag = false
	local num = 0

	if not has_extension then
		flag, num = has_extension:has_melee_boost()
	end

	if not flag and not arg_15_1 then
		num = arg_15_1
	end

	return flag, num
end

ActionUtils.get_ranged_boost = function (arg_16_0)
	-- function 16
	local has_extension = ScriptUnit.has_extension(arg_16_0, "career_system")
	local flag = false
	local num = 0

	if not has_extension then
		flag, num = has_extension:has_ranged_boost()
	end

	return flag, num
end

ActionUtils.spawn_player_projectile = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, arg_17_11, arg_17_12, arg_17_13, arg_17_14)
	-- function 17
	arg_17_3 = arg_17_3 or 100

	local system = Managers.state.entity:system("projectile_system")
	local num = 0

	system:spawn_player_projectile(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, num, arg_17_11, arg_17_12, arg_17_13, arg_17_14)
end

ActionUtils.spawn_pickup_projectile = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10, arg_18_11)
	-- function 18
	local pickup_name = arg_18_4.projectile_info.pickup_name
	local var_18_1 = NetworkLookup.husks[arg_18_2]
	local var_18_2 = NetworkLookup.go_types[arg_18_3]
	local position_network_scale = AiAnimUtils.position_network_scale(arg_18_6, true)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_18_7, true)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(arg_18_8, true)
	local velocity_network_scale_2 = AiAnimUtils.velocity_network_scale(arg_18_9, true)
	local var_18_7 = NetworkLookup.pickup_names[pickup_name]
	local var_18_8 = NetworkLookup.pickup_spawn_types[arg_18_11]
	local has_extension = ScriptUnit.has_extension(arg_18_1, "tutorial_system")
	local always_show

	if not has_extension then
		always_show = has_extension.always_show

		if not always_show then
			-- Nothing
		end
	end

	always_show = false

	do
		local proxy_active
	end

	::label_18_0::

	if not has_extension then
		proxy_active = has_extension.proxy_active

		if not proxy_active then
			-- Nothing
		end

		proxy_active = has_extension.active

		if not proxy_active then
			-- Nothing
		end
	end

	proxy_active = false

	::label_18_1::

	if not ScriptUnit.has_extension(arg_18_1, "death_system") then
		local extension = ScriptUnit.extension(arg_18_1, "health_system")

		extension.thrown = true

		local damage = extension.damage
		local num = 0
		local num_2 = 6
		local var_18_16

		if not extension.ignited then
			local health_data = extension:health_data()

			num = health_data.explode_time
			num_2 = health_data.fuse_time
			var_18_16 = health_data.attacker_unit_id
		end

		var_18_16 = var_18_16 or NetworkConstants.invalid_game_object_id

		local var_18_18 = NetworkLookup.item_names[arg_18_10]

		if not ScriptUnit.has_extension(arg_18_1, "limited_item_track_system") then
			local extension_2 = ScriptUnit.extension(arg_18_1, "limited_item_track_system")

			extension_2.thrown = true

			local id = extension_2.id
			local spawner_unit = extension_2.spawner_unit
			local current_level = LevelHelper:current_level(arg_18_0)
			local unit_index

			if not spawner_unit then
				unit_index = Level.unit_index(current_level, spawner_unit)

				if not unit_index then
					-- Nothing
				end
			end

			unit_index = 0

			::label_18_2::

			var_18_2 = NetworkLookup.go_types.explosive_pickup_projectile_unit_limited

			Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_explosive_pickup_projectile_limited", var_18_1, var_18_2, position_network_scale, rotation_network_scale, velocity_network_scale, velocity_network_scale_2, var_18_7, unit_index, id, damage, num, num_2, var_18_16, var_18_18, var_18_8, always_show, proxy_active)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_explosive_pickup_projectile", var_18_1, var_18_2, position_network_scale, rotation_network_scale, velocity_network_scale, velocity_network_scale_2, var_18_7, damage, num, num_2, var_18_16, var_18_18, var_18_8, always_show, proxy_active)
		end
	elseif not ScriptUnit.has_extension(arg_18_1, "limited_item_track_system") then
		local extension_3 = ScriptUnit.extension(arg_18_1, "limited_item_track_system")

		extension_3.thrown = true

		local id_2 = extension_3.id
		local spawner_unit_2 = extension_3.spawner_unit
		local current_level_2 = LevelHelper:current_level(arg_18_0)
		local unit_index_2

		if not spawner_unit_2 then
			unit_index_2 = Level.unit_index(current_level_2, spawner_unit_2)

			if not unit_index_2 then
				-- Nothing
			end
		end

		unit_index_2 = 0

		::label_18_3::

		var_18_2 = NetworkLookup.go_types.pickup_projectile_unit_limited

		Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_projectile_limited", var_18_1, var_18_2, position_network_scale, rotation_network_scale, velocity_network_scale, velocity_network_scale_2, var_18_7, unit_index_2, id_2, var_18_8, always_show, proxy_active)
	else
		local has_extension_2 = ScriptUnit.has_extension(arg_18_1, "ammo_system")
		local max_ammo

		if not has_extension_2 then
			max_ammo = has_extension_2:max_ammo()

			if not max_ammo then
				-- Nothing
			end
		end

		max_ammo = 1

		::label_18_4::

		local var_18_31 = NetworkLookup.material_settings_templates["n/a"]

		Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_projectile", var_18_1, var_18_2, position_network_scale, rotation_network_scale, velocity_network_scale, velocity_network_scale_2, var_18_7, var_18_8, max_ammo, always_show, proxy_active, var_18_31)
	end
end

ActionUtils.spawn_true_flight_projectile = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14)
	-- function 19
	local system = Managers.state.entity:system("projectile_system")
	local var_19_1 = TrueFlightTemplatesLookup[arg_19_2]

	system:spawn_true_flight_projectile(arg_19_0, arg_19_1, var_19_1, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14)
end

ActionUtils.get_action_time_scale = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	if not arg_20_3 then
		-- Nothing
	end

	::label_20_0::

	local anim_time_scale = arg_20_1.anim_time_scale

	anim_time_scale = anim_time_scale or 1

	::label_20_1::

	if not arg_20_0 and not Unit.alive(arg_20_0) then
		local has_extension = ScriptUnit.has_extension(arg_20_0, "buff_system")

		if not has_extension then
			local custom_anim_time_scale_mult = arg_20_1.custom_anim_time_scale_mult

			if not custom_anim_time_scale_mult then
				anim_time_scale = anim_time_scale * custom_anim_time_scale_mult(arg_20_0, anim_time_scale, arg_20_2)
			end

			local get_wielded_slot_item_template = ScriptUnit.has_extension(arg_20_0, "inventory_system"):get_wielded_slot_item_template()

			if not get_wielded_slot_item_template then
				local buff_type = get_wielded_slot_item_template.buff_type
				local var_20_5 = MeleeBuffTypes[buff_type]
				local var_20_6 = RangedBuffTypes[buff_type]
				local weapon_type = get_wielded_slot_item_template.weapon_type

				if not var_20_5 then
					anim_time_scale = has_extension:apply_buffs_to_value(anim_time_scale, "attack_speed")
					anim_time_scale = has_extension:apply_buffs_to_value(anim_time_scale, "attack_speed_melee")
				elseif not var_20_6 then
					anim_time_scale = has_extension:apply_buffs_to_value(anim_time_scale, "attack_speed")
				end

				if not (not weapon_type and weapon_type ~= "DRAKEFIRE") then
					anim_time_scale = has_extension:apply_buffs_to_value(anim_time_scale, "attack_speed_drakefire")
				end

				if arg_20_1.scale_chain_window_by_charge_time_buff or not arg_20_1.scale_anim_by_charge_time_buff or not arg_20_2 then
					anim_time_scale = anim_time_scale * (1 / has_extension:apply_buffs_to_value(1, "reduced_ranged_charge_time"))
				end
			end
		end
	end

	return anim_time_scale
end

ActionUtils.init_action_buff_data = function (self, arg_21_1, arg_21_2)
	-- function 21
	local buff_start_times = self.buff_start_times
	local buff_end_times = self.buff_end_times
	local action_buffs_in_progress = self.action_buffs_in_progress
	local buff_identifiers = self.buff_identifiers

	for i, v in ipairs(arg_21_1) do
		local start_time = v.start_time

		start_time = start_time or 0

		local num = arg_21_2 + start_time
		local end_time = v.end_time

		end_time = end_time or math.huge

		local num_2 = #buff_start_times + 1

		buff_start_times[num_2] = num
		buff_end_times[num_2] = num + end_time
		action_buffs_in_progress[num_2] = false
		buff_identifiers[num_2] = ""
	end
end

local tbl = {}

ActionUtils.update_action_buff_data = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local buff_start_times = self.buff_start_times
	local buff_end_times = self.buff_end_times
	local buff_identifiers = self.buff_identifiers
	local action_buffs_in_progress = self.action_buffs_in_progress

	for i, v in ipairs(buff_start_times) do
		if v <= arg_22_3 then
			local var_22_4 = arg_22_1[i]
			local buff_name = var_22_4.buff_name

			tbl.external_optional_bonus = var_22_4.external_value
			tbl.external_optional_multiplier = var_22_4.external_multiplier
			buff_start_times[i] = math.huge
			buff_identifiers[i] = ScriptUnit.extension(arg_22_2, "buff_system"):add_buff(buff_name, tbl)
			action_buffs_in_progress[i] = true
		end
	end

	for i_2, v_2 in ipairs(buff_end_times) do
		if v_2 <= arg_22_3 then
			buff_end_times[i_2] = math.huge
			action_buffs_in_progress[i_2] = false

			local extension = ScriptUnit.extension(arg_22_2, "buff_system")
			local var_22_7 = buff_identifiers[i_2]

			extension:remove_buff(var_22_7)
		end
	end
end

ActionUtils.remove_action_buff_data = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not ALIVE[arg_23_2] then
		local action_buffs_in_progress = self.action_buffs_in_progress
		local has_extension = ScriptUnit.has_extension(arg_23_2, "buff_system")
		local buff_identifiers = self.buff_identifiers

		if not has_extension then
			for i, v in ipairs(action_buffs_in_progress) do
				if not v then
					local var_23_3 = buff_identifiers[i]

					has_extension:remove_buff(var_23_3)
				end
			end
		end
	end
end

ActionUtils.start_charge_sound = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local charge_sound_switch = arg_24_3.charge_sound_switch
	local charge_sound_name = arg_24_3.charge_sound_name
	local charge_sound_parameter_name = arg_24_3.charge_sound_parameter_name

	if not arg_24_3.charge_sound_name then
		return
	end

	local make_auto_source = WwiseWorld.make_auto_source(arg_24_0, arg_24_1)

	if not charge_sound_switch then
		if not ScriptUnit.extension(arg_24_2, "overcharge_system"):above_overcharge_threshold() then
			WwiseWorld.set_switch(arg_24_0, charge_sound_switch, "above_overcharge_threshold", make_auto_source)
		else
			WwiseWorld.set_switch(arg_24_0, charge_sound_switch, "below_overcharge_threshold", make_auto_source)
		end
	end

	local trigger_event = WwiseWorld.trigger_event(arg_24_0, charge_sound_name, make_auto_source)

	if not charge_sound_parameter_name then
		WwiseWorld.set_source_parameter(arg_24_0, make_auto_source, charge_sound_parameter_name, 1)
	end

	return trigger_event, make_auto_source
end

ActionUtils.stop_charge_sound = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local charge_sound_stop_event = arg_25_3.charge_sound_stop_event

	if not (not charge_sound_stop_event and arg_25_2) then
		return
	end

	if not WwiseWorld.is_playing(arg_25_0, arg_25_1) then
		return
	end

	WwiseWorld.trigger_event(arg_25_0, charge_sound_stop_event, arg_25_2)
end

ActionUtils.play_husk_sound_event = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	if not arg_26_1 then
		return
	end

	if not Unit.alive(arg_26_2) then
		return
	end

	local is_server = Managers.player.is_server
	local network = Managers.state.network
	local network_transmit = network.network_transmit
	local unit_game_object_id = network:unit_game_object_id(arg_26_2)
	local var_26_4 = NetworkLookup.sound_events[arg_26_1]
	local game = Managers.state.network:game()

	if not unit_game_object_id then
		return
	end

	if not is_server and not arg_26_3 then
		local make_auto_source = WwiseWorld.make_auto_source(arg_26_0, arg_26_2)

		WwiseWorld.trigger_event(arg_26_0, arg_26_1, make_auto_source)
	end

	if not game then
		if not is_server then
			network_transmit:send_rpc_clients("rpc_play_husk_sound_event", unit_game_object_id, var_26_4)
		else
			network_transmit:send_rpc_server("rpc_play_husk_sound_event", unit_game_object_id, var_26_4)
		end
	end
end

ActionUtils.get_critical_strike_chance = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local extension = ScriptUnit.extension(arg_27_0, "career_system")
	local extension_2 = ScriptUnit.extension(arg_27_0, "buff_system")
	local get_base_critical_strike_chance = extension:get_base_critical_strike_chance()
	local additional_critical_strike_chance

	if not arg_27_2 then
		additional_critical_strike_chance = arg_27_2.additional_critical_strike_chance

		if not additional_critical_strike_chance then
			-- Nothing
		end
	end

	additional_critical_strike_chance = arg_27_1.additional_critical_strike_chance
	additional_critical_strike_chance = additional_critical_strike_chance or 0

	::label_27_0::

	local num = get_base_critical_strike_chance + additional_critical_strike_chance
	local kind = arg_27_1.kind

	if not (kind == "sweep" or kind == "push_stagger" or kind == "shield_slam") then
		num = extension_2:apply_buffs_to_value(num, "critical_strike_chance_melee")
	else
		num = extension_2:apply_buffs_to_value(num, "critical_strike_chance_ranged")
	end

	local var_27_6 = DamageProfileTemplates[arg_27_1.damage_profile]

	if not var_27_6 then
		var_27_6 = DamageProfileTemplates[arg_27_1.damage_profile_left]
		var_27_6 = var_27_6 or DamageProfileTemplates[arg_27_1.damage_profile_right]
	end

	if not (not var_27_6 and var_27_6.charge_value ~= "heavy_attack") then
		num = extension_2:apply_buffs_to_value(num, "critical_strike_chance_heavy")
	end

	return (extension_2:apply_buffs_to_value(num, "critical_strike_chance"))
end

local flag = false

ActionUtils.is_critical_strike = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local extension = ScriptUnit.extension(arg_28_0, "buff_system")
	local has_extension = ScriptUnit.has_extension(arg_28_0, "talent_system")
	local flag_2 = false

	if not script_data.no_critical_strikes then
		flag_2 = false
	elseif not script_data.always_critical_strikes then
		flag_2 = true
	elseif not script_data.alternating_critical_strikes then
		flag = not flag
		flag_2 = flag
	elseif not extension:has_buff_perk("guaranteed_crit") then
		flag_2 = true
	elseif not has_extension and not has_extension:has_talent_perk("no_random_crits") then
		flag_2 = false
	else
		local get_critical_strike_chance = ActionUtils.get_critical_strike_chance(arg_28_0, arg_28_1, arg_28_3 or arg_28_1)

		flag_2 = extension:has_procced(get_critical_strike_chance, arg_28_1 or "ACTION_UNKNOWN")
	end

	local kind = arg_28_1.kind

	if kind ~= "push_stagger" then
		if not flag_2 then
			extension:trigger_procs("on_critical_action", kind)
		else
			extension:trigger_procs("on_non_critical_action", kind)
		end
	end

	return flag_2
end

ActionUtils.pitch_from_rotation = function (arg_29_0)
	-- function 29
	local normalize = Vector3.normalize(Quaternion.forward(arg_29_0))
	local normalize_2 = Vector3.normalize(Vector3.flat(normalize))
	local dot = Vector3.dot(normalize, normalize_2)
	local clamp = math.clamp(dot, -1, 1)
	local radians_to_degrees = math.radians_to_degrees(math.acos(clamp))
	local var_29_5 = Vector3(0, 0, 1)

	if Vector3.dot(normalize, var_29_5) < 0 then
		radians_to_degrees = -radians_to_degrees
	end

	return radians_to_degrees
end

ActionUtils.redirect_shield_hit = function (arg_30_0, arg_30_1)
	-- function 30
	local var_30_0 = get_data(arg_30_0, "shield_owner_unit")

	if not HEALTH_ALIVE[var_30_0] then
		return arg_30_0, arg_30_1
	end

	local var_30_1 = actor(var_30_0, find_actor(var_30_0, "c_leftforearm"))

	return var_30_0, var_30_1
end

ActionUtils.resolve_action_selector = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	if not self then
		return nil
	end

	if self.kind ~= "action_selector" then
		return self, self.lookup_data.action_name, self.lookup_data.sub_action_name
	end

	local default_action = self.default_action
	local conditional_actions = self.conditional_actions

	for i = 1, #conditional_actions do
		if not conditional_actions[i].condition(arg_31_1, arg_31_2, arg_31_3, arg_31_4) then
			default_action = conditional_actions[i]

			break
		end
	end

	local action = default_action.action

	action = action or self.lookup_data.action_name

	local sub_action = default_action.sub_action

	return WeaponUtils.get_weapon_template(self.lookup_data.item_template_name).actions[action][sub_action], action, sub_action
end

ActionUtils.get_push_damage_profile = function (self)
	-- function 32
	if not self then
		return self.damage_profile_inner, self.damage_profile_outer
	end

	return nil, nil
end

ActionUtils.get_damage_profile_name = function (self, arg_33_1)
	-- function 33
	if not self then
		arg_33_1 = arg_33_1 or self.weapon_action_hand

		local impact_data = self.impact_data
		local damage_profile

		if not impact_data then
			damage_profile = impact_data.damage_profile

			if not damage_profile then
				-- Nothing
			end
		end

		damage_profile = self.damage_profile

		do
			local damage_profile_left
		end

		::label_33_0::

		if not impact_data then
			damage_profile_left = impact_data.damage_profile_left

			if not damage_profile_left then
				-- Nothing
			end
		end

		damage_profile_left = self.damage_profile_left

		do
			local damage_profile_right
		end

		::label_33_1::

		if not impact_data then
			damage_profile_right = impact_data.damage_profile_right

			if not damage_profile_right then
				-- Nothing
			end
		end

		damage_profile_right = self.damage_profile_right

		::label_33_2::

		if arg_33_1 == "both" then
			return damage_profile_left, damage_profile_right
		end

		if arg_33_1 == "left" then
			return damage_profile or damage_profile_left, nil
		end

		if arg_33_1 == "right" then
			local flag = damage_profile or damage_profile_right

			return nil, flag
		end

		return nil, damage_profile
	end

	return nil, nil
end

ActionUtils.get_damage_profile_performance_scores = function (arg_34_0)
	-- function 34
	local tbl = {
		0,
		0,
		0,
		0,
		0,
		0
	}

	if not arg_34_0 then
		local var_34_1 = DamageProfileTemplates[arg_34_0]
		local var_34_2

		if not var_34_1.targets then
			var_34_2 = var_34_1.targets[1]

			if not var_34_2 then
				-- Nothing
			end
		end

		var_34_2 = var_34_1.default_target

		::label_34_0::

		local get_power_multiplier = ActionUtils.get_power_multiplier("attack", var_34_1, var_34_2, nil)

		for i = 1, 5 do
			tbl[i] = get_power_multiplier * ActionUtils.get_armor_power_modifier("attack", var_34_1, var_34_2, i)
		end

		tbl[6] = get_power_multiplier * ActionUtils.get_armor_power_modifier("attack", var_34_1, var_34_2, 2, 6)
	end

	return tbl
end

ActionUtils.get_performance_scores_for_sub_action = function (arg_35_0)
	-- function 35
	local var_35_0
	local get_damage_profile_name, var_35_2 = ActionUtils.get_damage_profile_name(arg_35_0)

	if not get_damage_profile_name then
		var_35_0 = ActionUtils.get_damage_profile_performance_scores(get_damage_profile_name)
	end

	if not var_35_2 then
		if not get_damage_profile_name then
			var_35_0 = ActionUtils.get_damage_profile_performance_scores(var_35_2)
		else
			local get_damage_profile_performance_scores = ActionUtils.get_damage_profile_performance_scores(var_35_2)

			for i = 1, #get_damage_profile_performance_scores do
				var_35_0[i] = var_35_0[i] + get_damage_profile_performance_scores[i]
			end
		end
	end

	return var_35_0
end

ActionUtils.is_melee_start_sub_action = function (self)
	-- function 36
	if not self then
		return false
	end

	if self.kind == "melee_start" then
		return true
	end

	return self.melee_start
end

ActionUtils.is_backstab = function (arg_37_0, arg_37_1)
	-- function 37
	local var_37_0 = POSITION_LOOKUP[arg_37_0]
	local var_37_1 = POSITION_LOOKUP[arg_37_1]
	local normalize = Vector3.normalize(var_37_1 - var_37_0)
	local forward = Quaternion.forward(Unit.local_rotation(arg_37_1, 0))
	local dot = Vector3.dot(forward, normalize)

	return not (dot >= 0.55) or dot <= 1
end
