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
		generate_value = function(arg_1_0)
			local var_1_0 = Managers.player:local_player().player_unit
			local var_1_1 = ScriptUnit.has_extension(var_1_0, "health_system"):get_max_health()

			return math.round(var_1_1)
		end,
		generate_description = function(arg_2_0)
			local var_2_0 = Managers.player:local_player().player_unit
			local var_2_1 = ScriptUnit.has_extension(var_2_0, "health_system"):get_base_max_health()
			local var_2_2 = (ScriptUnit.has_extension(var_2_0, "buff_system"):apply_buffs_to_value(var_2_1, "max_health") / var_2_1 - 1) * 100
			local var_2_3 = "tooltip_hero_stats_health_description"

			return (string.format(Localize(var_2_3), math.round(var_2_2)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_movement_speed"),
		generate_value = function(arg_3_0)
			local var_3_0 = Managers.player:local_player().player_unit
			local var_3_1 = PlayerUnitMovementSettings.get_movement_settings_table(var_3_0).move_speed

			return math.round_with_precision(var_3_1, 2)
		end,
		generate_description = function(arg_4_0)
			local var_4_0 = Managers.player:local_player().player_unit
			local var_4_1 = (PlayerUnitMovementSettings.get_movement_settings_table(var_4_0).move_speed / 4 - 1) * 100
			local var_4_2 = "tooltip_hero_stats_movement_speed_description"

			return (string.format(Localize(var_4_2), math.round(var_4_1)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_respawn_speed"),
		generate_value = function(arg_5_0)
			local var_5_0 = Managers.player:local_player().player_unit
			local var_5_1 = ScriptUnit.has_extension(var_5_0, "buff_system")
			local var_5_2 = 30
			local var_5_3 = var_5_1:apply_buffs_to_value(var_5_2, "faster_respawn")
			local var_5_4 = (var_5_2 - var_5_3) / var_5_2 * 100
			local var_5_5 = var_5_3

			return math.round(var_5_5)
		end,
		generate_description = function(arg_6_0)
			local var_6_0 = Managers.player:local_player().player_unit
			local var_6_1 = ScriptUnit.has_extension(var_6_0, "buff_system")
			local var_6_2 = 30
			local var_6_3 = (var_6_2 - var_6_1:apply_buffs_to_value(var_6_2, "faster_respawn")) / var_6_2 * 100
			local var_6_4 = "tooltip_hero_stats_respawn_speed_description"

			return (string.format(Localize(var_6_4), math.round(var_6_3)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_ability_cooldown"),
		generate_value = function(arg_7_0)
			local var_7_0 = Managers.player:local_player().player_unit
			local var_7_1 = ScriptUnit.has_extension(var_7_0, "buff_system")
			local var_7_2 = ScriptUnit.has_extension(var_7_0, "career_system"):get_max_ability_cooldown()

			return (var_7_1:apply_buffs_to_value(var_7_2, "activated_cooldown"))
		end,
		generate_description = function(arg_8_0)
			local var_8_0 = Managers.player:local_player().player_unit
			local var_8_1 = ScriptUnit.has_extension(var_8_0, "buff_system")
			local var_8_2 = ScriptUnit.has_extension(var_8_0, "career_system"):get_max_ability_cooldown()
			local var_8_3 = (var_8_1:apply_buffs_to_value(var_8_2, "activated_cooldown") - var_8_2) / var_8_2 * -100
			local var_8_4 = "tooltip_hero_stats_ability_cooldown_description"

			return (string.format(Localize(var_8_4), math.round(var_8_3)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_revive_speed"),
		generate_value = function(arg_9_0)
			local var_9_0 = Managers.player:local_player().player_unit
			local var_9_1 = ScriptUnit.has_extension(var_9_0, "buff_system")
			local var_9_2 = 2
			local var_9_3 = var_9_1:apply_buffs_to_value(var_9_2, "faster_revive")

			return math.round_with_precision(var_9_3, 2)
		end,
		generate_description = function(arg_10_0)
			local var_10_0 = Managers.player:local_player().player_unit
			local var_10_1 = ScriptUnit.has_extension(var_10_0, "buff_system")
			local var_10_2 = 2
			local var_10_3 = (var_10_1:apply_buffs_to_value(var_10_2, "faster_revive") - var_10_2) / var_10_2 * -100
			local var_10_4 = "tooltip_hero_stats_revive_speed_description"

			return (string.format(Localize(var_10_4), math.round(var_10_3)))
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
		generate_value = function(arg_11_0)
			local var_11_0 = Managers.player:local_player().player_unit
			local var_11_1 = ScriptUnit.has_extension(var_11_0, "buff_system")
			local var_11_2 = 1
			local var_11_3 = (var_11_1:apply_buffs_to_value(var_11_2, "attack_speed") / var_11_2 - 1) * 100

			return math.round(var_11_3)
		end,
		generate_description = function(arg_12_0)
			local var_12_0 = Managers.player:local_player().player_unit
			local var_12_1 = ScriptUnit.has_extension(var_12_0, "buff_system")
			local var_12_2 = 1
			local var_12_3 = (var_12_1:apply_buffs_to_value(var_12_2, "attack_speed") / var_12_2 - 1) * 100
			local var_12_4 = "tooltip_hero_stats_attack_speed_description"

			return (string.format(Localize(var_12_4), math.round(var_12_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_critical_strike_chance"),
		generate_value = function(arg_13_0)
			local var_13_0 = Managers.player:local_player().player_unit
			local var_13_1 = ScriptUnit.has_extension(var_13_0, "buff_system")
			local var_13_2 = ScriptUnit.has_extension(var_13_0, "career_system"):career_name()
			local var_13_3 = CareerSettings[var_13_2].attributes.base_critical_strike_chance
			local var_13_4 = var_13_1:apply_buffs_to_value(var_13_3, "critical_strike_chance") * 100

			return math.round(var_13_4)
		end,
		generate_description = function(arg_14_0)
			local var_14_0 = Managers.player:local_player().player_unit
			local var_14_1 = ScriptUnit.has_extension(var_14_0, "buff_system")
			local var_14_2 = ScriptUnit.has_extension(var_14_0, "career_system"):career_name()
			local var_14_3 = CareerSettings[var_14_2].attributes.base_critical_strike_chance
			local var_14_4 = var_14_1:apply_buffs_to_value(var_14_3, "critical_strike_chance") * 100
			local var_14_5 = "tooltip_hero_stats_critical_strike_chance_description"

			return (string.format(Localize(var_14_5), math.round(var_14_4)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_critical_strike_boost"),
		generate_value = function(arg_15_0)
			local var_15_0 = Managers.player:local_player().player_unit
			local var_15_1 = ScriptUnit.has_extension(var_15_0, "buff_system")
			local var_15_2 = 1
			local var_15_3 = (var_15_1:apply_buffs_to_value(var_15_2, "critical_strike_effectiveness") / var_15_2 - 1) * 100

			return math.round(var_15_3)
		end,
		generate_description = function(arg_16_0)
			local var_16_0 = Managers.player:local_player().player_unit
			local var_16_1 = ScriptUnit.has_extension(var_16_0, "buff_system")
			local var_16_2 = 1
			local var_16_3 = (var_16_1:apply_buffs_to_value(var_16_2, "critical_strike_effectiveness") / var_16_2 - 1) * 100
			local var_16_4 = "tooltip_hero_stats_critical_strike_boost_description"

			return (string.format(Localize(var_16_4), math.round(var_16_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_headshot_damage"),
		generate_value = function(arg_17_0)
			local var_17_0 = Managers.player:local_player().player_unit
			local var_17_1 = ScriptUnit.has_extension(var_17_0, "buff_system")
			local var_17_2 = 1
			local var_17_3 = (var_17_1:apply_buffs_to_value(var_17_2, "headshot_multiplier") / var_17_2 - 1) * 100

			return math.round(var_17_3)
		end,
		generate_description = function(arg_18_0)
			local var_18_0 = Managers.player:local_player().player_unit
			local var_18_1 = ScriptUnit.has_extension(var_18_0, "buff_system")
			local var_18_2 = 1
			local var_18_3 = (var_18_1:apply_buffs_to_value(var_18_2, "headshot_multiplier") / var_18_2 - 1) * 100
			local var_18_4 = "tooltip_hero_stats_headshot_damage_description"

			return (string.format(Localize(var_18_4), math.round(var_18_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_increase"),
		generate_value = function(arg_19_0)
			local var_19_0 = Managers.player:local_player().player_unit
			local var_19_1 = ScriptUnit.has_extension(var_19_0, "buff_system")
			local var_19_2 = 100
			local var_19_3 = var_19_1:apply_buffs_to_value(var_19_2, "power_level") - var_19_2

			return math.round(var_19_3)
		end,
		generate_description = function(arg_20_0)
			local var_20_0 = Managers.player:local_player().player_unit
			local var_20_1 = ScriptUnit.has_extension(var_20_0, "buff_system")
			local var_20_2 = 100
			local var_20_3 = var_20_1:apply_buffs_to_value(var_20_2, "power_level") - var_20_2
			local var_20_4 = "tooltip_hero_stats_power_increase_description"

			return (string.format(Localize(var_20_4), math.round(var_20_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_skaven"),
		generate_value = function(arg_21_0)
			local var_21_0 = Managers.player:local_player().player_unit
			local var_21_1 = ScriptUnit.has_extension(var_21_0, "buff_system")
			local var_21_2 = 100
			local var_21_3 = var_21_1:apply_buffs_to_value(var_21_2, "power_level_skaven") - var_21_2

			return math.round(var_21_3)
		end,
		generate_description = function(arg_22_0)
			local var_22_0 = Managers.player:local_player().player_unit
			local var_22_1 = ScriptUnit.has_extension(var_22_0, "buff_system")
			local var_22_2 = 100
			local var_22_3 = var_22_1:apply_buffs_to_value(var_22_2, "power_level_skaven") - var_22_2
			local var_22_4 = "tooltip_hero_stats_power_vs_skaven_description"

			return (string.format(Localize(var_22_4), math.round(var_22_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_chaos"),
		generate_value = function(arg_23_0)
			local var_23_0 = Managers.player:local_player().player_unit
			local var_23_1 = ScriptUnit.has_extension(var_23_0, "buff_system")
			local var_23_2 = 100
			local var_23_3 = var_23_1:apply_buffs_to_value(var_23_2, "power_level_chaos") - var_23_2

			return math.round(var_23_3)
		end,
		generate_description = function(arg_24_0)
			local var_24_0 = Managers.player:local_player().player_unit
			local var_24_1 = ScriptUnit.has_extension(var_24_0, "buff_system")
			local var_24_2 = 100
			local var_24_3 = var_24_1:apply_buffs_to_value(var_24_2, "power_level_chaos") - var_24_2
			local var_24_4 = "tooltip_hero_stats_power_vs_chaos_description"

			return (string.format(Localize(var_24_4), math.round(var_24_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_infantry"),
		generate_value = function(arg_25_0)
			local var_25_0 = Managers.player:local_player().player_unit
			local var_25_1 = ScriptUnit.has_extension(var_25_0, "buff_system")
			local var_25_2 = 100
			local var_25_3 = var_25_1:apply_buffs_to_value(var_25_2, "power_level_unarmoured") - var_25_2

			return math.round(var_25_3)
		end,
		generate_description = function(arg_26_0)
			local var_26_0 = Managers.player:local_player().player_unit
			local var_26_1 = ScriptUnit.has_extension(var_26_0, "buff_system")
			local var_26_2 = 100
			local var_26_3 = var_26_1:apply_buffs_to_value(var_26_2, "power_level_unarmoured") - var_26_2
			local var_26_4 = "tooltip_hero_stats_power_vs_infantry_description"

			return (string.format(Localize(var_26_4), math.round(var_26_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_armored"),
		generate_value = function(arg_27_0)
			local var_27_0 = Managers.player:local_player().player_unit
			local var_27_1 = ScriptUnit.has_extension(var_27_0, "buff_system")
			local var_27_2 = 100
			local var_27_3 = var_27_1:apply_buffs_to_value(var_27_2, "power_level_armoured") - var_27_2

			return math.round(var_27_3)
		end,
		generate_description = function(arg_28_0)
			local var_28_0 = Managers.player:local_player().player_unit
			local var_28_1 = ScriptUnit.has_extension(var_28_0, "buff_system")
			local var_28_2 = 100
			local var_28_3 = var_28_1:apply_buffs_to_value(var_28_2, "power_level_armoured") - var_28_2
			local var_28_4 = "tooltip_hero_stats_power_vs_armored_description"

			return (string.format(Localize(var_28_4), math.round(var_28_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_monsters"),
		generate_value = function(arg_29_0)
			local var_29_0 = Managers.player:local_player().player_unit
			local var_29_1 = ScriptUnit.has_extension(var_29_0, "buff_system")
			local var_29_2 = 100
			local var_29_3 = var_29_1:apply_buffs_to_value(var_29_2, "power_level_large") - var_29_2

			return math.round(var_29_3)
		end,
		generate_description = function(arg_30_0)
			local var_30_0 = Managers.player:local_player().player_unit
			local var_30_1 = ScriptUnit.has_extension(var_30_0, "buff_system")
			local var_30_2 = 100
			local var_30_3 = var_30_1:apply_buffs_to_value(var_30_2, "power_level_large") - var_30_2
			local var_30_4 = "tooltip_hero_stats_power_vs_monsters_description"

			return (string.format(Localize(var_30_4), math.round(var_30_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_power_vs_frenzied"),
		generate_value = function(arg_31_0)
			local var_31_0 = Managers.player:local_player().player_unit
			local var_31_1 = ScriptUnit.has_extension(var_31_0, "buff_system")
			local var_31_2 = 100
			local var_31_3 = var_31_1:apply_buffs_to_value(var_31_2, "power_level_frenzy") - var_31_2

			return math.round(var_31_3)
		end,
		generate_description = function(arg_32_0)
			local var_32_0 = Managers.player:local_player().player_unit
			local var_32_1 = ScriptUnit.has_extension(var_32_0, "buff_system")
			local var_32_2 = 100
			local var_32_3 = var_32_1:apply_buffs_to_value(var_32_2, "power_level_frenzy") - var_32_2
			local var_32_4 = "tooltip_hero_stats_power_vs_frenzied_description"

			return (string.format(Localize(var_32_4), math.round(var_32_3)))
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
		generate_value = function(arg_33_0)
			local var_33_0 = Managers.player:local_player().player_unit
			local var_33_1 = (ScriptUnit.has_extension(var_33_0, "status_system"):get_max_fatigue_points() or 0) / 2

			return math.round(var_33_1)
		end,
		generate_description = function(arg_34_0)
			local var_34_0 = Managers.player:local_player().player_unit
			local var_34_1 = ScriptUnit.has_extension(var_34_0, "status_system"):get_max_fatigue_points() or 0
			local var_34_2 = var_34_1 / 2
			local var_34_3 = var_34_1
			local var_34_4 = "tooltip_hero_stats_shields_and_stamina_description"

			return (string.format(Localize(var_34_4), math.round(var_34_3)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_stamina_regeneration_speed"),
		generate_value = function(arg_35_0)
			local var_35_0 = Managers.player:local_player().player_unit
			local var_35_1 = ScriptUnit.has_extension(var_35_0, "buff_system")

			if not ScriptUnit.has_extension(var_35_0, "status_system"):get_max_fatigue_points() then
				local var_35_2 = 0
			end

			local var_35_3 = PlayerUnitStatusSettings.FATIGUE_POINTS_DEGEN_AMOUNT
			local var_35_4 = var_35_1:apply_buffs_to_value(var_35_3, "fatigue_regen")

			return math.round_with_precision(var_35_4, 2)
		end,
		generate_description = function(arg_36_0)
			local var_36_0 = Managers.player:local_player().player_unit
			local var_36_1 = ScriptUnit.has_extension(var_36_0, "buff_system")

			if not ScriptUnit.has_extension(var_36_0, "status_system"):get_max_fatigue_points() then
				local var_36_2 = 0
			end

			local var_36_3 = PlayerUnitStatusSettings.FATIGUE_POINTS_DEGEN_AMOUNT
			local var_36_4 = (var_36_1:apply_buffs_to_value(var_36_3, "fatigue_regen") / var_36_3 - 1) * 100
			local var_36_5 = "tooltip_hero_stats_stamina_regeneration_speed_description"

			return (string.format(Localize(var_36_5), math.round(var_36_4)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_dodge_distance"),
		generate_value = function(arg_37_0)
			local var_37_0 = Managers.player:local_player().player_unit
			local var_37_1 = PlayerUnitMovementSettings.get_movement_settings_table(var_37_0)
			local var_37_2 = var_37_1.dodging.distance_modifier
			local var_37_3 = var_37_1.dodging.distance
			local var_37_4 = var_37_2 * 100
			local var_37_5 = var_37_3 * var_37_2

			return math.round_with_precision(var_37_5, 2)
		end,
		generate_description = function(arg_38_0)
			local var_38_0 = Managers.player:local_player().player_unit
			local var_38_1 = PlayerUnitMovementSettings.get_movement_settings_table(var_38_0)
			local var_38_2 = var_38_1.dodging.distance_modifier
			local var_38_3 = var_38_1.dodging.distance
			local var_38_4 = (var_38_3 * var_38_2 / var_38_3 - 1) * 100
			local var_38_5 = var_38_4
			local var_38_6 = var_38_4
			local var_38_7 = "tooltip_hero_stats_dodge_distance_description"

			return (string.format(Localize(var_38_7), math.round(var_38_5)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_block_push_arc"),
		generate_value = function(arg_39_0)
			local var_39_0 = Managers.player:local_player().player_unit
			local var_39_1 = ScriptUnit.has_extension(var_39_0, "buff_system")
			local var_39_2 = 1
			local var_39_3 = (var_39_1:apply_buffs_to_value(var_39_2, "block_angle") / var_39_2 - 1) * 100

			return math.round(var_39_3)
		end,
		generate_description = function(arg_40_0)
			local var_40_0 = Managers.player:local_player().player_unit
			local var_40_1 = ScriptUnit.has_extension(var_40_0, "buff_system")
			local var_40_2 = 1
			local var_40_3 = (var_40_1:apply_buffs_to_value(var_40_2, "block_angle") / var_40_2 - 1) * 100
			local var_40_4 = "tooltip_hero_stats_block_push_arc_description"

			return (string.format(Localize(var_40_4), math.round(var_40_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_block_cost_reduction"),
		generate_value = function(arg_41_0)
			local var_41_0 = Managers.player:local_player().player_unit
			local var_41_1 = ScriptUnit.has_extension(var_41_0, "buff_system")
			local var_41_2 = 1
			local var_41_3 = (var_41_1:apply_buffs_to_value(var_41_2, "block_cost") / var_41_2 - 1) * -100

			return math.round(var_41_3)
		end,
		generate_description = function(arg_42_0)
			local var_42_0 = Managers.player:local_player().player_unit
			local var_42_1 = ScriptUnit.has_extension(var_42_0, "buff_system")
			local var_42_2 = 1
			local var_42_3 = (var_42_1:apply_buffs_to_value(var_42_2, "block_cost") / var_42_2 - 1) * -100
			local var_42_4 = "tooltip_hero_stats_block_cost_reduction_description"

			return (string.format(Localize(var_42_4), math.round(var_42_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_stun_duration"),
		generate_value = function(arg_43_0)
			local var_43_0 = Managers.player:local_player().player_unit
			local var_43_1 = ScriptUnit.has_extension(var_43_0, "buff_system")
			local var_43_2 = 1
			local var_43_3 = (var_43_1:apply_buffs_to_value(var_43_2, "stun_duration") / var_43_2 - 1) * -100

			return math.round(var_43_3)
		end,
		generate_description = function(arg_44_0)
			local var_44_0 = Managers.player:local_player().player_unit
			local var_44_1 = ScriptUnit.has_extension(var_44_0, "buff_system")
			local var_44_2 = 1
			local var_44_3 = (var_44_1:apply_buffs_to_value(var_44_2, "stun_duration") / var_44_2 - 1) * -100
			local var_44_4 = "tooltip_hero_stats_stun_duration_description"

			return (string.format(Localize(var_44_4), math.round(var_44_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_damage_reduction"),
		generate_value = function(arg_45_0)
			local var_45_0 = Managers.player:local_player().player_unit
			local var_45_1 = ScriptUnit.has_extension(var_45_0, "buff_system")
			local var_45_2 = 1
			local var_45_3 = (var_45_1:apply_buffs_to_value(var_45_2, "damage_taken") / var_45_2 - 1) * -100

			return math.round(var_45_3)
		end,
		generate_description = function(arg_46_0)
			local var_46_0 = Managers.player:local_player().player_unit
			local var_46_1 = ScriptUnit.has_extension(var_46_0, "buff_system")
			local var_46_2 = 1
			local var_46_3 = (var_46_1:apply_buffs_to_value(var_46_2, "damage_taken") / var_46_2 - 1) * -100
			local var_46_4 = "tooltip_hero_stats_damage_reduction_description"

			return (string.format(Localize(var_46_4), math.round(var_46_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_damage_reduction_skaven"),
		generate_value = function(arg_47_0)
			local var_47_0 = Managers.player:local_player().player_unit
			local var_47_1 = ScriptUnit.has_extension(var_47_0, "buff_system")
			local var_47_2 = 1
			local var_47_3 = (var_47_1:apply_buffs_to_value(var_47_2, "protection_skaven") / var_47_2 - 1) * -100

			return math.round(var_47_3)
		end,
		generate_description = function(arg_48_0)
			local var_48_0 = Managers.player:local_player().player_unit
			local var_48_1 = ScriptUnit.has_extension(var_48_0, "buff_system")
			local var_48_2 = 1
			local var_48_3 = (var_48_1:apply_buffs_to_value(var_48_2, "protection_skaven") / var_48_2 - 1) * -100
			local var_48_4 = "tooltip_hero_stats_damage_reduction_skaven_description"

			return (string.format(Localize(var_48_4), math.round(var_48_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_damage_reduction_chaos"),
		generate_value = function(arg_49_0)
			local var_49_0 = Managers.player:local_player().player_unit
			local var_49_1 = ScriptUnit.has_extension(var_49_0, "buff_system")
			local var_49_2 = 1
			local var_49_3 = (var_49_1:apply_buffs_to_value(var_49_2, "protection_chaos") / var_49_2 - 1) * -100

			return math.round(var_49_3)
		end,
		generate_description = function(arg_50_0)
			local var_50_0 = Managers.player:local_player().player_unit
			local var_50_1 = ScriptUnit.has_extension(var_50_0, "buff_system")
			local var_50_2 = 1
			local var_50_3 = (var_50_1:apply_buffs_to_value(var_50_2, "protection_chaos") / var_50_2 - 1) * -100
			local var_50_4 = "tooltip_hero_stats_damage_reduction_chaos_description"

			return (string.format(Localize(var_50_4), math.round(var_50_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_damage_reduction_aoe"),
		generate_value = function(arg_51_0)
			local var_51_0 = Managers.player:local_player().player_unit
			local var_51_1 = ScriptUnit.has_extension(var_51_0, "buff_system")
			local var_51_2 = 100
			local var_51_3 = (var_51_1:apply_buffs_to_value(var_51_2, "protection_aoe") / var_51_2 - 1) * -100

			return math.round(var_51_3)
		end,
		generate_description = function(arg_52_0)
			local var_52_0 = Managers.player:local_player().player_unit
			local var_52_1 = ScriptUnit.has_extension(var_52_0, "buff_system")
			local var_52_2 = 100
			local var_52_3 = (var_52_1:apply_buffs_to_value(var_52_2, "protection_aoe") / var_52_2 - 1) * -100
			local var_52_4 = "tooltip_hero_stats_damage_reduction_aoe_description"

			return (string.format(Localize(var_52_4), math.round(var_52_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_curse_resistance"),
		generate_value = function(arg_53_0)
			local var_53_0 = Managers.player:local_player().player_unit
			local var_53_1 = ScriptUnit.has_extension(var_53_0, "buff_system")
			local var_53_2 = 1
			local var_53_3 = (var_53_1:apply_buffs_to_value(var_53_2, "curse_protection") * var_53_2 - 1) * -100

			return math.round(var_53_3)
		end,
		generate_description = function(arg_54_0)
			local var_54_0 = Managers.player:local_player().player_unit
			local var_54_1 = ScriptUnit.has_extension(var_54_0, "buff_system")
			local var_54_2 = 1
			local var_54_3 = (var_54_1:apply_buffs_to_value(var_54_2, "curse_protection") * var_54_2 - 1) * -100
			local var_54_4 = math.abs(var_54_3)
			local var_54_5 = "tooltip_hero_stats_curse_resistance_description"

			return (string.format(Localize(var_54_5), math.round(var_54_4)))
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
		generate_value = function(arg_55_0)
			local var_55_0 = Managers.player:local_player().player_unit
			local var_55_1 = ScriptUnit.has_extension(var_55_0, "buff_system")
			local var_55_2 = 1
			local var_55_3 = (var_55_1:apply_buffs_to_value(var_55_2, "total_ammo") / var_55_2 - 1) * 100

			return math.round(var_55_3)
		end,
		generate_description = function(arg_56_0)
			local var_56_0 = Managers.player:local_player().player_unit
			local var_56_1 = ScriptUnit.has_extension(var_56_0, "buff_system")
			local var_56_2 = 1
			local var_56_3 = (var_56_1:apply_buffs_to_value(var_56_2, "total_ammo") / var_56_2 - 1) * 100
			local var_56_4 = "tooltip_hero_stats_max_ammo_increase_description"

			return (string.format(Localize(var_56_4), math.round(var_56_3)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_reload_speed_increase"),
		generate_value = function(arg_57_0)
			local var_57_0 = Managers.player:local_player().player_unit
			local var_57_1 = ScriptUnit.has_extension(var_57_0, "buff_system")
			local var_57_2 = 1
			local var_57_3 = (var_57_1:apply_buffs_to_value(var_57_2, "reload_speed") / var_57_2 - 1) * 100

			return math.round(var_57_3)
		end,
		generate_description = function(arg_58_0)
			local var_58_0 = Managers.player:local_player().player_unit
			local var_58_1 = ScriptUnit.has_extension(var_58_0, "buff_system")
			local var_58_2 = 1
			local var_58_3 = (var_58_1:apply_buffs_to_value(var_58_2, "reload_speed") / var_58_2 - 1) * 100
			local var_58_4 = "tooltip_hero_stats_reload_speed_increase_description"

			return (string.format(Localize(var_58_4), math.round(var_58_3)))
		end
	},
	{
		type = "entry",
		display_name = Localize("tooltip_hero_stats_max_overheat"),
		generate_value = function(arg_59_0)
			local var_59_0 = Managers.player:local_player().player_unit
			local var_59_1 = ScriptUnit.has_extension(var_59_0, "overcharge_system"):get_max_value()
			local var_59_2 = tostring(var_59_1)

			return math.round(var_59_2)
		end,
		generate_description = function(arg_60_0)
			local var_60_0 = Managers.player:local_player().player_unit
			local var_60_1 = ScriptUnit.has_extension(var_60_0, "overcharge_system"):get_max_value()
			local var_60_2 = "tooltip_hero_stats_max_overheat_description"

			return (string.format(Localize(var_60_2), math.round(var_60_1)))
		end
	},
	{
		type = "entry",
		value_type = "percent",
		display_name = Localize("tooltip_hero_stats_overheat_generated"),
		generate_value = function(arg_61_0)
			local var_61_0 = Managers.player:local_player().player_unit
			local var_61_1 = ScriptUnit.has_extension(var_61_0, "buff_system")
			local var_61_2
			local var_61_3 = 1
			local var_61_4 = (var_61_1:apply_buffs_to_value(var_61_3, "reduced_overcharge") / var_61_3 - 1) * -100

			return math.round(var_61_4)
		end,
		generate_description = function(arg_62_0)
			local var_62_0 = Managers.player:local_player().player_unit
			local var_62_1 = ScriptUnit.has_extension(var_62_0, "buff_system")
			local var_62_2 = 1
			local var_62_3 = (var_62_1:apply_buffs_to_value(var_62_2, "reduced_overcharge") / var_62_2 - 1) * -100
			local var_62_4 = "tooltip_hero_stats_overheat_generated_description"

			return (string.format(Localize(var_62_4), math.round(var_62_3)))
		end
	},
	{
		type = "empty"
	}
}
