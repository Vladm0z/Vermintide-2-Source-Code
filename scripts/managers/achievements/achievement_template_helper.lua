-- chunkname: @scripts/managers/achievements/achievement_template_helper.lua

AchievementTemplateHelper = AchievementTemplateHelper or {}
AchievementTemplateHelper.rarity_index = {
	common = 2,
	plentiful = 1,
	exotic = 4,
	rare = 3,
	unique = 5
}
AchievementTemplateHelper.PLACEHOLDER_ICON = "icons_placeholder"

AchievementTemplateHelper.check_level = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_0:get_persistent_stat(arg_1_1, "completed_levels", arg_1_2)

	return not (not var_1_0 or var_1_0 == 0)
end

AchievementTemplateHelper.check_level_list = function (arg_2_0, arg_2_1, arg_2_2)
	assert(type(arg_2_2) == "table" and #arg_2_2 > 0, "levels_to_complete needs to be a list of levels with at least 1 element")

	for iter_2_0 = 1, #arg_2_2 do
		local var_2_0 = arg_2_2[iter_2_0]
		local var_2_1 = arg_2_0:get_persistent_stat(arg_2_1, "completed_levels", var_2_0)

		if not var_2_1 or var_2_1 == 0 then
			return false
		end
	end

	return true
end

AchievementTemplateHelper.rpc_increment_stat = function (arg_3_0, arg_3_1)
	local var_3_0 = Managers.player:unit_owner(arg_3_0)

	if var_3_0 and not var_3_0.bot_player then
		local var_3_1 = var_3_0:network_id()
		local var_3_2 = Managers.state.network
		local var_3_3 = NetworkLookup.statistics[arg_3_1]

		var_3_2.network_transmit:send_rpc("rpc_increment_stat", var_3_1, var_3_3)
	end
end

AchievementTemplateHelper.rpc_increment_stat_unique_id = function (arg_4_0, arg_4_1)
	local var_4_0 = Managers.player:player_from_unique_id(arg_4_0)

	if var_4_0 and not var_4_0.bot_player then
		local var_4_1 = var_4_0:network_id()
		local var_4_2 = Managers.state.network
		local var_4_3 = NetworkLookup.statistics[arg_4_1]

		var_4_2.network_transmit:send_rpc("rpc_increment_stat", var_4_1, var_4_3)
	end
end

AchievementTemplateHelper.rpc_modify_stat = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Managers.player:unit_owner(arg_5_0)

	if var_5_0 and not var_5_0.bot_player then
		local var_5_1 = var_5_0:network_id()
		local var_5_2 = Managers.state.network
		local var_5_3 = NetworkLookup.statistics[arg_5_1]

		var_5_2.network_transmit:send_rpc("rpc_modify_stat", var_5_1, var_5_3, arg_5_2)
	end
end

AchievementTemplateHelper.check_level_difficulty = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = Managers.state.difficulty

	if not var_6_0 then
		return false
	end

	local var_6_1 = var_6_0:get_default_difficulties()
	local var_6_2

	if not arg_6_4 then
		var_6_2 = LevelUnlockUtils.completed_level_difficulty_index(arg_6_0, arg_6_1, arg_6_2)
	else
		for iter_6_0 = #var_6_1, 1, -1 do
			if arg_6_0:get_persistent_stat(arg_6_1, "completed_career_levels", arg_6_4, arg_6_2, var_6_1[iter_6_0]) > 0 then
				var_6_2 = iter_6_0

				break
			end
		end
	end

	local var_6_3 = var_6_1[var_6_2]

	if not var_6_3 then
		return false
	end

	if not DefaultDifficultyLookup[var_6_3] then
		return false
	end

	return arg_6_3 <= DifficultySettings[var_6_3].rank
end

AchievementTemplateHelper.check_level_table_difficulty = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	assert(type(arg_7_2) == "table" and arg_7_2.level_id, "level_to_complete needs to be a table with a level_id field")

	local var_7_0 = arg_7_2.level_id

	return AchievementTemplateHelper.check_level_difficulty(arg_7_0, arg_7_1, var_7_0, arg_7_3, arg_7_4)
end

AchievementTemplateHelper.check_level_list_difficulty = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	assert(type(arg_8_2) == "table" and #arg_8_2 > 0, "levels_to_complete needs to be a list of levels with at least 1 element")

	local var_8_0 = AchievementTemplateHelper.check_level_difficulty

	for iter_8_0 = 1, #arg_8_2 do
		local var_8_1 = arg_8_2[iter_8_0]

		if not var_8_0(arg_8_0, arg_8_1, var_8_1, arg_8_3, arg_8_4) then
			return false
		end
	end

	return true
end

AchievementTemplateHelper.hero_level = function (arg_9_0)
	local var_9_0 = ExperienceSettings.get_experience(arg_9_0)

	return ExperienceSettings.get_level(var_9_0)
end

local var_0_0 = {
	"melee",
	"ranged",
	"necklace",
	"ring",
	"trinket"
}

AchievementTemplateHelper.equipped_items_of_rarity = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = AchievementTemplateHelper.rarity_index[arg_10_2]

	assert(var_10_0, "Invalid rarity %s", arg_10_2)

	local var_10_1 = 0

	for iter_10_0, iter_10_1 in ipairs(var_0_0) do
		if var_10_0 <= arg_10_0:get_persistent_stat(arg_10_1, "highest_equipped_rarity", iter_10_1) then
			var_10_1 = var_10_1 + 1
		end
	end

	return var_10_1
end

AchievementTemplateHelper.add_stat_count_challenge = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
	arg_11_0[arg_11_1] = {
		display_completion_ui = true,
		name = "achv_" .. arg_11_1 .. "_name",
		desc = function ()
			local var_12_0 = "achv_" .. arg_11_1 .. "_desc"

			return string.format(Localize(var_12_0), arg_11_3)
		end,
		icon = arg_11_5 or "achievement_trophy_" .. arg_11_1,
		required_dlc = arg_11_6,
		ID_XB1 = arg_11_7,
		ID_PS4 = arg_11_8,
		completed = function (arg_13_0, arg_13_1)
			if arg_11_4 then
				return arg_13_0:get_persistent_stat(arg_13_1, arg_11_2, arg_11_4) >= arg_11_3
			else
				return arg_13_0:get_persistent_stat(arg_13_1, arg_11_2) >= arg_11_3
			end
		end,
		progress = function (arg_14_0, arg_14_1)
			if arg_11_4 then
				local var_14_0 = arg_14_0:get_persistent_stat(arg_14_1, arg_11_2, arg_11_4)

				return {
					var_14_0,
					arg_11_3
				}
			else
				local var_14_1 = arg_14_0:get_persistent_stat(arg_14_1, arg_11_2)

				return {
					var_14_1,
					arg_11_3
				}
			end
		end
	}
end

AchievementTemplateHelper.add_health_challenge = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
	arg_15_0[arg_15_1] = {
		display_completion_ui = true,
		name = "achv_" .. arg_15_1 .. "_name",
		desc = "achv_" .. arg_15_1 .. "_desc",
		icon = arg_15_4 or "achievement_trophy_" .. arg_15_1,
		required_dlc = arg_15_5,
		ID_XB1 = arg_15_6,
		ID_PS4 = arg_15_7,
		completed = function (arg_16_0, arg_16_1)
			return arg_16_0:get_persistent_stat(arg_16_1, "min_health_completed", arg_15_2) >= arg_15_3
		end
	}
end

AchievementTemplateHelper.add_weapon_kills_per_breeds_challenge = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9)
	assert(type(arg_17_3) == "table", "breeds_to_kill needs to be a list of breeds")

	arg_17_0[arg_17_1] = {
		name = "achv_" .. arg_17_1 .. "_name",
		desc = function ()
			local var_18_0 = "achv_" .. arg_17_1 .. "_desc"

			return string.format(Localize(var_18_0), arg_17_4)
		end,
		icon = arg_17_5 or "achievement_trophy_" .. arg_17_1,
		required_dlc = arg_17_6,
		ID_XB1 = arg_17_8,
		ID_PS4 = arg_17_9,
		display_completion_ui = arg_17_7,
		completed = function (arg_19_0, arg_19_1)
			local var_19_0 = "weapon_kills_per_breed"
			local var_19_1 = 0

			for iter_19_0 = 1, #arg_17_3 do
				for iter_19_1 = 1, #arg_17_2 do
					var_19_1 = var_19_1 + arg_19_0:get_persistent_stat(arg_19_1, var_19_0, arg_17_2[iter_19_1], arg_17_3[iter_19_0])
				end
			end

			return var_19_1 >= arg_17_4
		end,
		progress = function (arg_20_0, arg_20_1)
			local var_20_0 = "weapon_kills_per_breed"
			local var_20_1 = 0

			for iter_20_0 = 1, #arg_17_3 do
				for iter_20_1 = 1, #arg_17_2 do
					var_20_1 = var_20_1 + arg_20_0:get_persistent_stat(arg_20_1, var_20_0, arg_17_2[iter_20_1], arg_17_3[iter_20_0])
				end
			end

			if var_20_1 > arg_17_4 then
				var_20_1 = arg_17_4
			end

			return {
				var_20_1,
				arg_17_4
			}
		end
	}
end

AchievementTemplateHelper.add_career_mission_count_challenge = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10)
	arg_21_0[arg_21_1 .. "_" .. arg_21_3] = {
		display_completion_ui = true,
		name = "achv_" .. arg_21_1 .. "_" .. arg_21_3 .. "_name",
		desc = "achv_" .. arg_21_1 .. "_" .. arg_21_3 .. "_desc",
		icon = arg_21_7 or "achievement_trophy_" .. arg_21_1 .. "_" .. arg_21_3,
		required_dlc = arg_21_8,
		ID_XB1 = arg_21_9,
		ID_PS4 = arg_21_10,
		completed = function (arg_22_0, arg_22_1)
			local var_22_0 = 0

			for iter_22_0 = 1, #arg_21_4 do
				for iter_22_1 = 1, #UnlockableLevels do
					var_22_0 = var_22_0 + arg_22_0:get_persistent_stat(arg_22_1, arg_21_2, arg_21_3, UnlockableLevels[iter_22_1], arg_21_4[iter_22_0])
				end
			end

			return var_22_0 >= arg_21_5
		end,
		progress = function (arg_23_0, arg_23_1)
			local var_23_0 = 0

			for iter_23_0 = 1, #arg_21_4 do
				for iter_23_1 = 1, #UnlockableLevels do
					var_23_0 = var_23_0 + arg_23_0:get_persistent_stat(arg_23_1, arg_21_2, arg_21_3, UnlockableLevels[iter_23_1], arg_21_4[iter_23_0])
				end
			end

			if var_23_0 > arg_21_5 then
				var_23_0 = arg_21_5
			end

			return {
				var_23_0,
				arg_21_5
			}
		end
	}
end

AchievementTemplateHelper.add_multi_stat_count_challenge = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7)
	arg_24_0[arg_24_1] = {
		display_completion_ui = true,
		name = "achv_" .. arg_24_1 .. "_name",
		desc = "achv_" .. arg_24_1 .. "_desc",
		icon = arg_24_4 or "achievement_trophy_" .. arg_24_1,
		required_dlc = arg_24_5,
		ID_XB1 = arg_24_6,
		ID_PS4 = arg_24_7,
		completed = function (arg_25_0, arg_25_1)
			local var_25_0 = 0
			local var_25_1 = #arg_24_2

			for iter_25_0 = 1, var_25_1 do
				var_25_0 = var_25_0 + arg_25_0:get_persistent_stat(arg_25_1, arg_24_2[iter_25_0])
			end

			return var_25_0 >= arg_24_3
		end,
		progress = function (arg_26_0, arg_26_1)
			local var_26_0 = 0
			local var_26_1 = #arg_24_2

			for iter_26_0 = 1, var_26_1 do
				var_26_0 = var_26_0 + arg_26_0:get_persistent_stat(arg_26_1, arg_24_2[iter_26_0])
			end

			if var_26_0 > arg_24_3 then
				var_26_0 = arg_24_3
			end

			return {
				var_26_0,
				arg_24_3
			}
		end
	}
end

AchievementTemplateHelper.add_weapon_kill_challenge = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7)
	local var_27_0 = (arg_27_5 or "") .. "_kills_" .. arg_27_2

	AchievementTemplateHelper.add_stat_count_challenge(arg_27_0, arg_27_1, var_27_0, arg_27_3, nil, arg_27_4, arg_27_5, arg_27_6, arg_27_7)
end

AchievementTemplateHelper.add_weapon_levels_challenge = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8)
	local var_28_0 = {}
	local var_28_1 = arg_28_3 and #arg_28_3 or 0

	for iter_28_0 = 1, var_28_1 do
		local var_28_2 = arg_28_3[iter_28_0]

		var_28_0[iter_28_0] = (arg_28_6 or "") .. "_" .. var_28_2 .. "_" .. arg_28_2
	end

	local var_28_3 = DifficultySettings[arg_28_4]
	local var_28_4 = DifficultySettings[arg_28_4].rank

	arg_28_0[arg_28_1] = {
		name = "achv_" .. arg_28_1 .. "_name",
		desc = "achv_" .. arg_28_1 .. "_desc",
		icon = arg_28_5 or "achievement_trophy_" .. arg_28_1,
		required_dlc = arg_28_6,
		required_dlc_extra = var_28_3.dlc_requirement,
		ID_XB1 = arg_28_7,
		ID_PS4 = arg_28_8,
		completed = function (arg_29_0, arg_29_1)
			for iter_29_0 = 1, var_28_1 do
				if arg_29_0:get_persistent_stat(arg_29_1, var_28_0[iter_29_0]) < var_28_4 then
					return false
				end
			end

			return true
		end,
		progress = function (arg_30_0, arg_30_1)
			local var_30_0 = 0

			for iter_30_0 = 1, var_28_1 do
				local var_30_1 = var_28_0[iter_30_0]

				if arg_30_0:get_persistent_stat(arg_30_1, var_30_1) >= var_28_4 then
					var_30_0 = var_30_0 + 1
				end
			end

			return {
				var_30_0,
				var_28_1
			}
		end,
		requirements = function (arg_31_0, arg_31_1)
			local var_31_0 = {}

			for iter_31_0 = 1, var_28_1 do
				local var_31_1 = arg_28_3[iter_31_0]
				local var_31_2 = LevelSettings[var_31_1].display_name
				local var_31_3 = {
					name = var_31_2,
					completed = arg_31_0:get_persistent_stat(arg_31_1, var_28_0[iter_31_0]) >= var_28_4
				}

				table.insert(var_31_0, var_31_3)
			end

			return var_31_0
		end
	}
end

AchievementTemplateHelper.add_event_challenge = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	local var_32_0 = {
		display_completion_ui = true,
		name = "achv_" .. arg_32_1 .. "_name",
		icon = arg_32_2 or "achievement_trophy_" .. arg_32_1,
		required_dlc = arg_32_4,
		ID_XB1 = arg_32_5,
		ID_PS4 = arg_32_6,
		completed = function (arg_33_0, arg_33_1)
			return arg_33_0:get_persistent_stat(arg_33_1, arg_32_1) > 0
		end
	}
	local var_32_1 = "achv_" .. arg_32_1 .. "_desc"

	if arg_32_3 then
		var_32_0.desc = function ()
			return string.format(Localize(var_32_1), unpack(arg_32_3))
		end
	else
		var_32_0.desc = var_32_1
	end

	arg_32_0[arg_32_1] = var_32_0
end

AchievementTemplateHelper.add_levels_complete_challenge = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
	local var_35_0 = arg_35_2 and #arg_35_2 or 0
	local var_35_1 = DifficultyRankLookup[arg_35_3]
	local var_35_2 = DifficultySettings[var_35_1]
	local var_35_3 = {
		name = "achv_" .. arg_35_1 .. "_name",
		desc = "achv_" .. arg_35_1 .. "_desc",
		icon = arg_35_4 or "achievement_trophy_" .. arg_35_1,
		required_dlc = arg_35_5,
		required_dlc_extra = var_35_2.dlc_requirement,
		ID_XB1 = arg_35_6,
		ID_PS4 = arg_35_7,
		completed = function (arg_36_0, arg_36_1)
			local var_36_0 = 0

			for iter_36_0 = 1, var_35_0 do
				if AchievementTemplateHelper.check_level_table_difficulty(arg_36_0, arg_36_1, arg_35_2[iter_36_0], arg_35_3) then
					var_36_0 = var_36_0 + 1
				end
			end

			return var_36_0 >= var_35_0
		end
	}

	if var_35_0 > 1 then
		var_35_3.progress = function (arg_37_0, arg_37_1)
			local var_37_0 = 0

			for iter_37_0 = 1, var_35_0 do
				if AchievementTemplateHelper.check_level_table_difficulty(arg_37_0, arg_37_1, arg_35_2[iter_37_0], arg_35_3) then
					var_37_0 = var_37_0 + 1
				end
			end

			return {
				var_37_0,
				var_35_0
			}
		end

		var_35_3.requirements = function (arg_38_0, arg_38_1)
			local var_38_0 = {}

			for iter_38_0 = 1, var_35_0 do
				local var_38_1 = {
					name = arg_35_2[iter_38_0].display_name,
					completed = AchievementTemplateHelper.check_level_table_difficulty(arg_38_0, arg_38_1, arg_35_2[iter_38_0], arg_35_3)
				}

				table.insert(var_38_0, var_38_1)
			end

			return var_38_0
		end
	end

	arg_35_0[arg_35_1] = var_35_3
end

AchievementTemplateHelper.add_levels_complete_per_hero_challenge = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9)
	fassert(CareerSettings[arg_39_4] ~= nil, "No career with such name (%s)", arg_39_4)

	local var_39_0 = arg_39_2 and #arg_39_2 or 0
	local var_39_1 = DifficultyRankLookup[arg_39_3]
	local var_39_2 = DifficultySettings[var_39_1]
	local var_39_3 = {
		name = "achv_" .. arg_39_1 .. "_" .. arg_39_4 .. "_name",
		desc = "achv_" .. arg_39_1 .. "_" .. arg_39_4 .. "_desc",
		icon = arg_39_6 or "achievement_trophy_" .. arg_39_1 .. "_" .. arg_39_4,
		required_dlc = arg_39_7,
		required_dlc_extra = var_39_2.dlc_requirement,
		ID_XB1 = arg_39_8,
		ID_PS4 = arg_39_9,
		completed = function (arg_40_0, arg_40_1)
			return AchievementTemplateHelper.check_level_list_difficulty(arg_40_0, arg_40_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
		end
	}

	if var_39_0 > 1 then
		var_39_3.progress = function (arg_41_0, arg_41_1)
			local var_41_0 = 0

			for iter_41_0 = 1, var_39_0 do
				if AchievementTemplateHelper.check_level_list_difficulty(arg_41_0, arg_41_1, {
					arg_39_2[iter_41_0]
				}, arg_39_3, arg_39_4, arg_39_5) then
					var_41_0 = var_41_0 + 1
				end
			end

			return {
				var_41_0,
				var_39_0
			}
		end

		var_39_3.requirements = function (arg_42_0, arg_42_1)
			local var_42_0 = {}

			for iter_42_0 = 1, var_39_0 do
				local var_42_1 = {
					name = LevelSettings[arg_39_2[iter_42_0]].display_name,
					completed = AchievementTemplateHelper.check_level_list_difficulty(arg_42_0, arg_42_1, {
						arg_39_2[iter_42_0]
					}, arg_39_3, arg_39_4, arg_39_5)
				}

				table.insert(var_42_0, var_42_1)
			end

			return var_42_0
		end
	end

	arg_39_0[arg_39_1 .. "_" .. arg_39_4] = var_39_3
end

AchievementTemplateHelper.add_meta_challenge = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
	arg_43_0[arg_43_1] = {
		display_completion_ui = true,
		name = "achv_" .. arg_43_1 .. "_name",
		desc = "achv_" .. arg_43_1 .. "_desc",
		icon = arg_43_3 or "achievement_trophy_" .. arg_43_1,
		required_dlc = arg_43_4,
		ID_XB1 = arg_43_5,
		ID_PS4 = arg_43_6,
		completed = function (arg_44_0, arg_44_1)
			local var_44_0 = Managers.backend:get_interface("loot")

			for iter_44_0 = 1, #arg_43_2 do
				local var_44_1 = arg_43_2[iter_44_0]

				if not arg_43_0[var_44_1].completed(arg_44_0, arg_44_1) and not var_44_0:achievement_rewards_claimed(var_44_1) then
					return false
				end
			end

			return true
		end,
		progress = function (arg_45_0, arg_45_1)
			local var_45_0 = Managers.backend:get_interface("loot")
			local var_45_1 = 0
			local var_45_2 = #arg_43_2

			for iter_45_0 = 1, var_45_2 do
				local var_45_3 = arg_43_2[iter_45_0]

				if arg_43_0[var_45_3].completed(arg_45_0, arg_45_1) or var_45_0:achievement_rewards_claimed(var_45_3) then
					var_45_1 = var_45_1 + 1
				end
			end

			return {
				var_45_1,
				var_45_2
			}
		end,
		requirements = function (arg_46_0, arg_46_1)
			local var_46_0 = Managers.backend:get_interface("loot")
			local var_46_1 = {}

			for iter_46_0 = 1, #arg_43_2 do
				local var_46_2 = arg_43_2[iter_46_0]
				local var_46_3 = arg_43_0[var_46_2].name
				local var_46_4 = arg_43_0[var_46_2].completed(arg_46_0, arg_46_1) or var_46_0:achievement_rewards_claimed(var_46_2)

				table.insert(var_46_1, {
					name = var_46_3,
					completed = var_46_4
				})
			end

			return var_46_1
		end
	}
end

AchievementTemplateHelper.add_console_achievements = function (arg_47_0, arg_47_1)
	local var_47_0 = AchievementTemplates.achievements

	for iter_47_0, iter_47_1 in pairs(arg_47_0) do
		if var_47_0[iter_47_0] then
			var_47_0[iter_47_0].ID_XB1 = iter_47_1
		else
			Application.error(string.format("Missing xbox achievement %q", iter_47_0))
		end
	end

	for iter_47_2, iter_47_3 in pairs(arg_47_1) do
		if var_47_0[iter_47_2] then
			var_47_0[iter_47_2].ID_PS4 = iter_47_3
		else
			Application.error(string.format("Missing xbox achievement %q", iter_47_2))
		end
	end
end
