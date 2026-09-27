-- chunkname: @scripts/settings/hero_statistics_template.lua

HeroStatisticsTemplate = {
	{
		type = "empty"
	},
	{
		type = "title",
		display_name = Localize("tooltip_hero_stats_base_stats")
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_health"),
		generate_value = function (arg_1_0)
			-- function 1
			local player_unit = Managers.player:local_player().player_unit
			local get_max_health = ScriptUnit.has_extension(player_unit, "health_system"):get_max_health()

			return math.round(get_max_health)
		end,
		generate_description = function (arg_2_0)
			-- function 2
			local player_unit = Managers.player:local_player().player_unit
			local get_base_max_health = ScriptUnit.has_extension(player_unit, "health_system"):get_base_max_health()
			local num = (ScriptUnit.has_extension(player_unit, "buff_system"):apply_buffs_to_value(get_base_max_health, "max_health") / get_base_max_health - 1) * 100
			local str = "tooltip_hero_stats_health_description"

			return (string.format(Localize(str), math.round(num)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_movement_speed"),
		generate_value = function (arg_3_0)
			-- function 3
			local player_unit = Managers.player:local_player().player_unit
			local move_speed = PlayerUnitMovementSettings.get_movement_settings_table(player_unit).move_speed

			return math.round_with_precision(move_speed, 2)
		end,
		generate_description = function (arg_4_0)
			-- function 4
			local player_unit = Managers.player:local_player().player_unit
			local num = (PlayerUnitMovementSettings.get_movement_settings_table(player_unit).move_speed / 4 - 1) * 100
			local str = "tooltip_hero_stats_movement_speed_description"

			return (string.format(Localize(str), math.round(num)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_respawn_speed"),
		generate_value = function (arg_5_0)
			-- function 5
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 30
			local apply_buffs_to_value = has_extension:apply_buffs_to_value(num, "faster_respawn")
			local num_2 = (num - apply_buffs_to_value) / num * 100
			local var_5_5 = apply_buffs_to_value

			return math.round(var_5_5)
		end,
		generate_description = function (arg_6_0)
			-- function 6
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 30
			local num_2 = (num - has_extension:apply_buffs_to_value(num, "faster_respawn")) / num * 100
			local str = "tooltip_hero_stats_respawn_speed_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_ability_cooldown"),
		generate_value = function (arg_7_0)
			-- function 7
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local get_max_ability_cooldown = ScriptUnit.has_extension(player_unit, "career_system"):get_max_ability_cooldown()

			return (has_extension:apply_buffs_to_value(get_max_ability_cooldown, "activated_cooldown"))
		end,
		generate_description = function (arg_8_0)
			-- function 8
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local get_max_ability_cooldown = ScriptUnit.has_extension(player_unit, "career_system"):get_max_ability_cooldown()
			local num = (has_extension:apply_buffs_to_value(get_max_ability_cooldown, "activated_cooldown") - get_max_ability_cooldown) / get_max_ability_cooldown * -100
			local str = "tooltip_hero_stats_ability_cooldown_description"

			return (string.format(Localize(str), math.round(num)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_revive_speed"),
		generate_value = function (arg_9_0)
			-- function 9
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 2
			local apply_buffs_to_value = has_extension:apply_buffs_to_value(num, "faster_revive")

			return math.round_with_precision(apply_buffs_to_value, 2)
		end,
		generate_description = function (arg_10_0)
			-- function 10
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 2
			local num_2 = (has_extension:apply_buffs_to_value(num, "faster_revive") - num) / num * -100
			local str = "tooltip_hero_stats_revive_speed_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "empty"
	},
	{
		type = "title",
		display_name = Localize("tooltip_hero_stats_offensive_stats")
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_attack_speed"),
		generate_value = function (arg_11_0)
			-- function 11
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "attack_speed") / num - 1) * 100

			return math.round(num_2)
		end,
		generate_description = function (arg_12_0)
			-- function 12
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "attack_speed") / num - 1) * 100
			local str = "tooltip_hero_stats_attack_speed_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_critical_strike_chance"),
		generate_value = function (arg_13_0)
			-- function 13
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local career_name = ScriptUnit.has_extension(player_unit, "career_system"):career_name()
			local base_critical_strike_chance = CareerSettings[career_name].attributes.base_critical_strike_chance
			local num = has_extension:apply_buffs_to_value(base_critical_strike_chance, "critical_strike_chance") * 100

			return math.round(num)
		end,
		generate_description = function (arg_14_0)
			-- function 14
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local career_name = ScriptUnit.has_extension(player_unit, "career_system"):career_name()
			local base_critical_strike_chance = CareerSettings[career_name].attributes.base_critical_strike_chance
			local num = has_extension:apply_buffs_to_value(base_critical_strike_chance, "critical_strike_chance") * 100
			local str = "tooltip_hero_stats_critical_strike_chance_description"

			return (string.format(Localize(str), math.round(num)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_critical_strike_boost"),
		generate_value = function (arg_15_0)
			-- function 15
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "critical_strike_effectiveness") / num - 1) * 100

			return math.round(num_2)
		end,
		generate_description = function (arg_16_0)
			-- function 16
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "critical_strike_effectiveness") / num - 1) * 100
			local str = "tooltip_hero_stats_critical_strike_boost_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_headshot_damage"),
		generate_value = function (arg_17_0)
			-- function 17
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "headshot_multiplier") / num - 1) * 100

			return math.round(num_2)
		end,
		generate_description = function (arg_18_0)
			-- function 18
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "headshot_multiplier") / num - 1) * 100
			local str = "tooltip_hero_stats_headshot_damage_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_increase"),
		generate_value = function (arg_19_0)
			-- function 19
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level") - num

			return math.round(num_2)
		end,
		generate_description = function (arg_20_0)
			-- function 20
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level") - num
			local str = "tooltip_hero_stats_power_increase_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_skaven"),
		generate_value = function (arg_21_0)
			-- function 21
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_skaven") - num

			return math.round(num_2)
		end,
		generate_description = function (arg_22_0)
			-- function 22
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_skaven") - num
			local str = "tooltip_hero_stats_power_vs_skaven_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_chaos"),
		generate_value = function (arg_23_0)
			-- function 23
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_chaos") - num

			return math.round(num_2)
		end,
		generate_description = function (arg_24_0)
			-- function 24
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_chaos") - num
			local str = "tooltip_hero_stats_power_vs_chaos_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_infantry"),
		generate_value = function (arg_25_0)
			-- function 25
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_unarmoured") - num

			return math.round(num_2)
		end,
		generate_description = function (arg_26_0)
			-- function 26
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_unarmoured") - num
			local str = "tooltip_hero_stats_power_vs_infantry_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_armored"),
		generate_value = function (arg_27_0)
			-- function 27
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_armoured") - num

			return math.round(num_2)
		end,
		generate_description = function (arg_28_0)
			-- function 28
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_armoured") - num
			local str = "tooltip_hero_stats_power_vs_armored_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_monsters"),
		generate_value = function (arg_29_0)
			-- function 29
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_large") - num

			return math.round(num_2)
		end,
		generate_description = function (arg_30_0)
			-- function 30
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_large") - num
			local str = "tooltip_hero_stats_power_vs_monsters_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_frenzied"),
		generate_value = function (arg_31_0)
			-- function 31
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_frenzy") - num

			return math.round(num_2)
		end,
		generate_description = function (arg_32_0)
			-- function 32
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = has_extension:apply_buffs_to_value(num, "power_level_frenzy") - num
			local str = "tooltip_hero_stats_power_vs_frenzied_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "empty"
	},
	{
		type = "title",
		display_name = Localize("tooltip_hero_stats_defensive_stats")
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_shields_and_stamina"),
		generate_value = function (arg_33_0)
			-- function 33
			local player_unit = Managers.player:local_player().player_unit
			local get_max_fatigue_points = ScriptUnit.has_extension(player_unit, "status_system"):get_max_fatigue_points()

			get_max_fatigue_points = get_max_fatigue_points or 0

			local num = get_max_fatigue_points / 2

			return math.round(num)
		end,
		generate_description = function (arg_34_0)
			-- function 34
			local player_unit = Managers.player:local_player().player_unit
			local get_max_fatigue_points = ScriptUnit.has_extension(player_unit, "status_system"):get_max_fatigue_points()

			get_max_fatigue_points = get_max_fatigue_points or 0

			local num = get_max_fatigue_points / 2
			local var_34_3 = get_max_fatigue_points
			local str = "tooltip_hero_stats_shields_and_stamina_description"

			return (string.format(Localize(str), math.round(var_34_3)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_stamina_regeneration_speed"),
		generate_value = function (arg_35_0)
			-- function 35
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")

			if not ScriptUnit.has_extension(player_unit, "status_system"):get_max_fatigue_points() then
				local num = 0
			end

			local FATIGUE_POINTS_DEGEN_AMOUNT = PlayerUnitStatusSettings.FATIGUE_POINTS_DEGEN_AMOUNT
			local apply_buffs_to_value = has_extension:apply_buffs_to_value(FATIGUE_POINTS_DEGEN_AMOUNT, "fatigue_regen")

			return math.round_with_precision(apply_buffs_to_value, 2)
		end,
		generate_description = function (arg_36_0)
			-- function 36
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")

			if not ScriptUnit.has_extension(player_unit, "status_system"):get_max_fatigue_points() then
				local num = 0
			end

			local FATIGUE_POINTS_DEGEN_AMOUNT = PlayerUnitStatusSettings.FATIGUE_POINTS_DEGEN_AMOUNT
			local num_2 = (has_extension:apply_buffs_to_value(FATIGUE_POINTS_DEGEN_AMOUNT, "fatigue_regen") / FATIGUE_POINTS_DEGEN_AMOUNT - 1) * 100
			local str = "tooltip_hero_stats_stamina_regeneration_speed_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_dodge_distance"),
		generate_value = function (arg_37_0)
			-- function 37
			local player_unit = Managers.player:local_player().player_unit
			local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(player_unit)
			local distance_modifier = get_movement_settings_table.dodging.distance_modifier
			local distance = get_movement_settings_table.dodging.distance
			local num = distance_modifier * 100
			local num_2 = distance * distance_modifier

			return math.round_with_precision(num_2, 2)
		end,
		generate_description = function (arg_38_0)
			-- function 38
			local player_unit = Managers.player:local_player().player_unit
			local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(player_unit)
			local distance_modifier = get_movement_settings_table.dodging.distance_modifier
			local distance = get_movement_settings_table.dodging.distance
			local num = (distance * distance_modifier / distance - 1) * 100
			local var_38_5 = num
			local var_38_6 = num
			local str = "tooltip_hero_stats_dodge_distance_description"

			return (string.format(Localize(str), math.round(var_38_5)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_block_push_arc"),
		generate_value = function (arg_39_0)
			-- function 39
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "block_angle") / num - 1) * 100

			return math.round(num_2)
		end,
		generate_description = function (arg_40_0)
			-- function 40
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "block_angle") / num - 1) * 100
			local str = "tooltip_hero_stats_block_push_arc_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_block_cost_reduction"),
		generate_value = function (arg_41_0)
			-- function 41
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "block_cost") / num - 1) * -100

			return math.round(num_2)
		end,
		generate_description = function (arg_42_0)
			-- function 42
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "block_cost") / num - 1) * -100
			local str = "tooltip_hero_stats_block_cost_reduction_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_stun_duration"),
		generate_value = function (arg_43_0)
			-- function 43
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "stun_duration") / num - 1) * -100

			return math.round(num_2)
		end,
		generate_description = function (arg_44_0)
			-- function 44
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "stun_duration") / num - 1) * -100
			local str = "tooltip_hero_stats_stun_duration_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_damage_reduction"),
		generate_value = function (arg_45_0)
			-- function 45
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "damage_taken") / num - 1) * -100

			return math.round(num_2)
		end,
		generate_description = function (arg_46_0)
			-- function 46
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "damage_taken") / num - 1) * -100
			local str = "tooltip_hero_stats_damage_reduction_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_damage_reduction_skaven"),
		generate_value = function (arg_47_0)
			-- function 47
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "protection_skaven") / num - 1) * -100

			return math.round(num_2)
		end,
		generate_description = function (arg_48_0)
			-- function 48
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "protection_skaven") / num - 1) * -100
			local str = "tooltip_hero_stats_damage_reduction_skaven_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_damage_reduction_chaos"),
		generate_value = function (arg_49_0)
			-- function 49
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "protection_chaos") / num - 1) * -100

			return math.round(num_2)
		end,
		generate_description = function (arg_50_0)
			-- function 50
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "protection_chaos") / num - 1) * -100
			local str = "tooltip_hero_stats_damage_reduction_chaos_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_damage_reduction_aoe"),
		generate_value = function (arg_51_0)
			-- function 51
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = (has_extension:apply_buffs_to_value(num, "protection_aoe") / num - 1) * -100

			return math.round(num_2)
		end,
		generate_description = function (arg_52_0)
			-- function 52
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 100
			local num_2 = (has_extension:apply_buffs_to_value(num, "protection_aoe") / num - 1) * -100
			local str = "tooltip_hero_stats_damage_reduction_aoe_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_curse_resistance"),
		generate_value = function (arg_53_0)
			-- function 53
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "curse_protection") * num - 1) * -100

			return math.round(num_2)
		end,
		generate_description = function (arg_54_0)
			-- function 54
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "curse_protection") * num - 1) * -100
			local abs = math.abs(num_2)
			local str = "tooltip_hero_stats_curse_resistance_description"

			return (string.format(Localize(str), math.round(abs)))
		end
	},
	{
		type = "empty"
	},
	{
		type = "title",
		display_name = Localize("tooltip_hero_stats_ranged_stats")
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_max_ammo_increase"),
		generate_value = function (arg_55_0)
			-- function 55
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "total_ammo") / num - 1) * 100

			return math.round(num_2)
		end,
		generate_description = function (arg_56_0)
			-- function 56
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "total_ammo") / num - 1) * 100
			local str = "tooltip_hero_stats_max_ammo_increase_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_reload_speed_increase"),
		generate_value = function (arg_57_0)
			-- function 57
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "reload_speed") / num - 1) * 100

			return math.round(num_2)
		end,
		generate_description = function (arg_58_0)
			-- function 58
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "reload_speed") / num - 1) * 100
			local str = "tooltip_hero_stats_reload_speed_increase_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_max_overheat"),
		generate_value = function (arg_59_0)
			-- function 59
			local player_unit = Managers.player:local_player().player_unit
			local get_max_value = ScriptUnit.has_extension(player_unit, "overcharge_system"):get_max_value()
			local var_59_2 = tostring(get_max_value)

			return math.round(var_59_2)
		end,
		generate_description = function (arg_60_0)
			-- function 60
			local player_unit = Managers.player:local_player().player_unit
			local get_max_value = ScriptUnit.has_extension(player_unit, "overcharge_system"):get_max_value()
			local str = "tooltip_hero_stats_max_overheat_description"

			return (string.format(Localize(str), math.round(get_max_value)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_overheat_generated"),
		generate_value = function (arg_61_0)
			-- function 61
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local var_61_2
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "reduced_overcharge") / num - 1) * -100

			return math.round(num_2)
		end,
		generate_description = function (arg_62_0)
			-- function 62
			local player_unit = Managers.player:local_player().player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local num = 1
			local num_2 = (has_extension:apply_buffs_to_value(num, "reduced_overcharge") / num - 1) * -100
			local str = "tooltip_hero_stats_overheat_generated_description"

			return (string.format(Localize(str), math.round(num_2)))
		end
	},
	{
		type = "empty"
	}
}
