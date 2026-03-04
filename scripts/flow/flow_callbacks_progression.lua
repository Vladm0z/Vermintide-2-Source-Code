-- chunkname: @scripts/flow/flow_callbacks_progression.lua

local var_0_0 = Boot.flow_return_table

function flow_callback_check_progression_unlocked(arg_1_0)
	var_0_0.is_unlocked = false
	var_0_0.is_locked = true

	return var_0_0
end

function flow_callback_get_last_level_played(arg_2_0)
	local var_2_0 = SaveData.last_played_level or "N/A"
	local var_2_1 = SaveData.last_played_level_result == "won"

	var_0_0.level_key = var_2_0
	var_0_0.won = var_2_1

	return var_0_0
end

function flow_callback_last_level_played_was_weave(arg_3_0)
	local var_3_0 = SaveData.last_played_level or "N/A"
	local var_3_1 = SaveData.last_played_level_result == "won"
	local var_3_2 = WeaveSettings.templates
	local var_3_3 = false
	local var_3_4 = false

	for iter_3_0, iter_3_1 in pairs(var_3_2) do
		local var_3_5 = iter_3_1.objectives
		local var_3_6 = var_3_5[1]
		local var_3_7 = var_3_5[2]

		if var_3_6.level_id == var_3_0 then
			var_3_3 = true
		elseif var_3_7.level_id == var_3_0 then
			var_3_4 = true
		end
	end

	var_0_0.was_weave_level = var_3_3
	var_0_0.was_boss_level = var_3_4
	var_0_0.won = var_3_1

	return var_0_0
end

function flow_callback_ui_onboarding_tutorial_completed(arg_4_0)
	local var_4_0 = false
	local var_4_1 = Managers.player

	if var_4_1 then
		local var_4_2 = var_4_1:statistics_db()
		local var_4_3 = var_4_1:local_player()

		if var_4_2 and var_4_3 then
			local var_4_4 = arg_4_0.tutorial_name and WeaveUITutorials[arg_4_0.tutorial_name]

			if var_4_4 then
				local var_4_5 = WeaveOnboardingUtils.get_ui_onboarding_state(var_4_2, var_4_3:stats_id())

				var_4_0 = WeaveOnboardingUtils.tutorial_completed(var_4_5, var_4_4)
			end
		end
	end

	var_0_0.completed = var_4_0

	return var_0_0
end

function flow_callback_get_completed_game_difficulty(arg_5_0)
	local var_5_0 = Managers.player:statistics_db()
	local var_5_1 = Managers.player:server_player()

	if var_5_1 then
		local var_5_2 = var_5_1:stats_id()
		local var_5_3 = LevelUnlockUtils.completed_adventure_difficulty(var_5_0, var_5_2)

		return {
			completed_difficulty = var_5_3
		}
	end

	return {
		completed_difficulty = 0
	}
end

function flow_callback_get_completed_drachenfels_difficulty(arg_6_0)
	local var_6_0 = Managers.player:statistics_db()
	local var_6_1 = Managers.player:server_player()

	if var_6_1 then
		local var_6_2 = {
			"dlc_portals",
			"dlc_castle",
			"dlc_castle_dungeon"
		}
		local var_6_3
		local var_6_4 = var_6_1:stats_id()

		for iter_6_0, iter_6_1 in ipairs(var_6_2) do
			local var_6_5 = LevelUnlockUtils.completed_level_difficulty_index(var_6_0, var_6_4, iter_6_1)

			if not var_6_3 or var_6_5 < var_6_3 then
				var_6_3 = var_6_5
			end
		end

		return {
			completed_difficulty = var_6_3
		}
	end

	return {
		completed_difficulty = 0
	}
end

function flow_callback_get_completed_dwarf_levels_difficulty(arg_7_0)
	local var_7_0 = Managers.player:statistics_db()
	local var_7_1 = Managers.player:server_player()

	if var_7_1 then
		local var_7_2 = {
			"dlc_dwarf_exterior",
			"dlc_dwarf_interior",
			"dlc_dwarf_beacons"
		}
		local var_7_3
		local var_7_4 = var_7_1:stats_id()

		for iter_7_0, iter_7_1 in ipairs(var_7_2) do
			local var_7_5 = LevelUnlockUtils.completed_level_difficulty(var_7_0, var_7_4, iter_7_1)

			if not var_7_3 or var_7_5 < var_7_3 then
				var_7_3 = var_7_5
			end
		end

		return {
			completed_difficulty = var_7_3
		}
	end

	return {
		completed_difficulty = 0
	}
end

function flow_callback_get_completed_survival_waves(arg_8_0)
	local var_8_0 = Managers.player
	local var_8_1 = var_8_0:server_player()
	local var_8_2 = {
		dlc_survival_ruins = 0,
		dlc_survival_magnus = 0
	}

	if var_8_1 then
		local var_8_3 = var_8_0:statistics_db()
		local var_8_4 = SurvivalStartWaveByDifficulty
		local var_8_5 = var_8_1:stats_id()

		for iter_8_0, iter_8_1 in pairs(var_8_2) do
			local var_8_6 = StatisticsUtil.get_survival_stat(var_8_3, iter_8_0, "cataclysm", "waves", var_8_5)

			if var_8_6 > 0 then
				var_8_6 = var_8_6 + var_8_4.cataclysm
			end

			local var_8_7 = StatisticsUtil.get_survival_stat(var_8_3, iter_8_0, "cataclysm_2", "waves", var_8_5)

			if var_8_7 > 0 then
				var_8_7 = var_8_7 + var_8_4.cataclysm_2
			end

			local var_8_8 = StatisticsUtil.get_survival_stat(var_8_3, iter_8_0, "cataclysm_3", "waves", var_8_5)

			if var_8_8 > 0 then
				var_8_8 = var_8_8 + var_8_4.cataclysm_3
			end

			var_8_2[iter_8_0] = math.max(var_8_6, var_8_7, var_8_8)
		end
	end

	return var_8_2
end

function flow_callback_override_level_progression_for_experience(arg_9_0)
	local var_9_0 = arg_9_0.progression

	fassert(var_9_0 >= 0 and var_9_0 <= 1, "Level progression needs to be a number between 0 and 1, not %d", var_9_0)
	Managers.state.entity:system("mission_system"):override_percentage_completed(var_9_0)
end

function flow_query_leader_hero_level(arg_10_0)
	local var_10_0 = Managers.party:leader()
	local var_10_1 = Network.peer_id()

	fassert(var_10_0 == var_10_1, "Flow node \"Leader Hero Level\" should only be called by the leader player")

	local var_10_2 = arg_10_0.hero_name
	local var_10_3 = ExperienceSettings.get_experience(var_10_2)
	local var_10_4 = ExperienceSettings.get_level(var_10_3)

	var_0_0.value = var_10_4

	return var_0_0
end

function flow_query_leader_hero_prestige(arg_11_0)
	local var_11_0 = Managers.party:leader()
	local var_11_1 = Network.peer_id()

	fassert(var_11_0 == var_11_1, "Flow node \"Leader Hero Prestige\" should only be called by the leader player")

	local var_11_2 = arg_11_0.hero_name
	local var_11_3 = ProgressionUnlocks.get_prestige_level(var_11_2)

	var_0_0.value = var_11_3

	return var_0_0
end

function flow_query_leader_completed_difficulty(arg_12_0)
	local var_12_0 = Managers.party:leader()
	local var_12_1 = Network.peer_id()

	fassert(var_12_0 == var_12_1, "Flow node \"Leader Completed Difficulty\" should only be called by the leader player")

	local var_12_2 = Managers.player
	local var_12_3 = var_12_2:statistics_db()
	local var_12_4 = var_12_2:player(var_12_0, 1):stats_id()
	local var_12_5 = LevelUnlockUtils.completed_main_game_difficulty(var_12_3, var_12_4)

	var_0_0.value = var_12_5

	return var_0_0
end

function flow_query_leader_completed_dlc_difficulty(arg_13_0)
	local var_13_0 = Managers.party:leader()
	local var_13_1 = Network.peer_id()

	fassert(var_13_0 == var_13_1, "Flow node \"Leader Completed DLC Difficulty\" should only be called by the leader player")

	local var_13_2 = arg_13_0.dlc_name
	local var_13_3 = Managers.player
	local var_13_4 = var_13_3:statistics_db()
	local var_13_5 = var_13_3:player(var_13_0, 1):stats_id()
	local var_13_6 = LevelUnlockUtils.completed_dlc_difficulty(var_13_4, var_13_5, var_13_2)

	var_0_0.value = var_13_6

	return var_0_0
end

local function var_0_1(arg_14_0, ...)
	local var_14_0 = Managers.player
	local var_14_1 = var_14_0:statistics_db()
	local var_14_2 = var_14_0:player(arg_14_0, 1)
	local var_14_3

	if var_14_2 then
		local var_14_4 = var_14_2:stats_id()

		var_14_3 = var_14_1:get_persistent_stat(var_14_4, ...)
	end

	return var_14_3
end

function flow_query_leader_completed_exalted_champion_difficulty(arg_15_0)
	local var_15_0 = Managers.party:leader()
	local var_15_1 = Network.peer_id()

	fassert(var_15_0 == var_15_1, "Flow node \"Leader Completed Bodvarr Difficulty\" should only be called by the leader player")

	local var_15_2 = var_0_1(var_15_0, "kill_chaos_exalted_champion_difficulty_rank")

	var_0_0.value = var_15_2

	return var_0_0
end

function flow_query_leader_completed_exalted_sorcerer_difficulty(arg_16_0)
	local var_16_0 = Managers.party:leader()
	local var_16_1 = Network.peer_id()

	fassert(var_16_0 == var_16_1, "Flow node \"Leader Completed Haleschmorg Burglederp Difficulty\" should only be called by the leader player")

	local var_16_2 = var_0_1(var_16_0, "kill_chaos_exalted_sorcerer_difficulty_rank")

	var_0_0.value = var_16_2

	return var_0_0
end

function flow_query_leader_completed_grey_seer_difficulty(arg_17_0)
	local var_17_0 = Managers.party:leader()
	local var_17_1 = Network.peer_id()

	fassert(var_17_0 == var_17_1, "Flow node \"Leader Completed Rasknitt Difficulty\" should only be called by the leader player")

	local var_17_2 = var_0_1(var_17_0, "kill_skaven_grey_seer_difficulty_rank")

	var_0_0.value = var_17_2

	return var_0_0
end

function flow_query_leader_completed_storm_vermin_warlord_difficulty(arg_18_0)
	local var_18_0 = Managers.party:leader()
	local var_18_1 = Network.peer_id()

	fassert(var_18_0 == var_18_1, "Flow node \"Leader Completed Skarrik Spinemanglr Difficulty\" should only be called by the leader player")

	local var_18_2 = var_0_1(var_18_0, "kill_skaven_storm_vermin_warlord_difficulty_rank")

	var_0_0.value = var_18_2

	return var_0_0
end

function flow_query_leader_completed_celebrate_event_2019(arg_19_0)
	local var_19_0 = Managers.party:leader()
	local var_19_1 = Network.peer_id()

	fassert(var_19_0 == var_19_1, "Flow node \"Leader Completed Celebrate Event 2019\" should only be called by the leader player")

	local var_19_2 = var_0_1(var_19_0, "completed_levels", "dlc_celebrate_crawl") > 0

	var_0_0.value = var_19_2

	return var_0_0
end

function flow_query_leader_achievement_completed(arg_20_0)
	if script_data.settings.use_beta_mode or not Managers.state.achievement:is_enabled() then
		var_0_0.value = false

		return var_0_0
	end

	local var_20_0 = Managers.party:leader()
	local var_20_1 = Network.peer_id()

	fassert(var_20_0 == var_20_1, "Flow node \"Leader Achievement Completed\" should only be called by the leader player")

	if script_data.achievement_completed_flow_override ~= nil then
		var_0_0.value = script_data.achievement_completed_flow_override

		return var_0_0
	end

	local var_20_2 = arg_20_0.achievement_name
	local var_20_3 = AchievementTemplates.achievements[var_20_2]

	fassert(var_20_3, "Achievement [\"%s\"] not found in AchievementTemplates!", var_20_2)

	local var_20_4 = Managers.backend:get_interface("loot")

	if var_20_4 then
		local var_20_5 = var_20_4:achievement_rewards_claimed(var_20_3.id)

		if var_20_5 then
			var_0_0.value = var_20_5

			return var_0_0
		end
	end

	local var_20_6 = Managers.player
	local var_20_7 = var_20_6:statistics_db()
	local var_20_8 = var_20_6:player(var_20_0, 1):stats_id()
	local var_20_9 = var_20_3.completed(var_20_7, var_20_8)

	var_0_0.value = var_20_9

	return var_0_0
end

function flow_query_local_player_achievement_completed(arg_21_0)
	if script_data.settings.use_beta_mode or not Managers.state.achievement:is_enabled() then
		var_0_0.value = false

		return var_0_0
	end

	if script_data.achievement_completed_flow_override ~= nil then
		var_0_0.value = script_data.achievement_completed_flow_override

		return var_0_0
	end

	local var_21_0 = arg_21_0.achievement_name
	local var_21_1 = AchievementTemplates.achievements[var_21_0]

	fassert(var_21_1, "Achievement [\"%s\"] not found in AchievementTemplates!", var_21_0)

	local var_21_2 = Managers.backend:get_interface("loot")

	if var_21_2 then
		local var_21_3 = var_21_2:achievement_rewards_claimed(var_21_1.id)

		if var_21_3 then
			var_0_0.value = var_21_3

			return var_0_0
		end
	end

	local var_21_4 = Managers.player
	local var_21_5 = var_21_4:statistics_db()
	local var_21_6 = var_21_4:local_player()
	local var_21_7 = false

	if var_21_6 then
		local var_21_8 = var_21_6:stats_id()

		var_21_7 = var_21_1.completed(var_21_5, var_21_8)
	end

	var_0_0.value = var_21_7

	return var_0_0
end

function flow_query_local_player_quest_progress(arg_22_0)
	var_0_0.progress = 0
	var_0_0.target = 0

	if script_data.settings.use_beta_mode then
		var_0_0.success = false

		return var_0_0
	end

	local var_22_0 = arg_22_0.quest_id

	if not Managers.backend:get_interface("quests"):get_quest_key(var_22_0) then
		var_0_0.success = false

		return var_0_0
	end

	local var_22_1 = Managers.state.quest:get_data_by_id(var_22_0)

	if var_22_1 then
		var_0_0.progress = var_22_1.progress[1]
		var_0_0.target = var_22_1.progress[2]
		var_0_0.success = true
	else
		var_0_0.success = false
	end

	return var_0_0
end

function flow_query_leader_hero_xp(arg_23_0)
	local var_23_0 = Managers.party:leader()
	local var_23_1 = Network.peer_id()

	fassert(var_23_0 == var_23_1, "Flow node \"Leader Hero XP\" should only be called by the leader player")

	local var_23_2 = arg_23_0.hero_name
	local var_23_3 = ExperienceSettings.get_experience(var_23_2)

	var_0_0.value = var_23_3

	return var_0_0
end

function flow_query_leader_num_acts_completed(arg_24_0)
	local var_24_0 = Managers.party:leader()
	local var_24_1 = Network.peer_id()

	fassert(var_24_0 == var_24_1, "Flow node \"Leader Number of Acts Completed\" should only be called by the leader player")

	local var_24_2 = Managers.player
	local var_24_3 = var_24_2:statistics_db()
	local var_24_4 = var_24_2:player(var_24_0, 1):stats_id()
	local var_24_5 = LevelUnlockUtils.num_acts_completed(var_24_3, var_24_4)

	var_0_0.value = var_24_5

	return var_0_0
end

function flow_query_leader_num_crafted_items(arg_25_0)
	local var_25_0 = Managers.party:leader()
	local var_25_1 = Network.peer_id()

	fassert(var_25_0 == var_25_1, "Flow node \"Leader Number of Crafted Items\" should only be called by the leader player")

	local var_25_2 = Managers.player
	local var_25_3 = var_25_2:statistics_db()
	local var_25_4 = var_25_2:player(var_25_0, 1):stats_id()
	local var_25_5 = var_25_3:get_persistent_stat(var_25_4, "crafted_items")

	var_0_0.value = var_25_5

	return var_0_0
end

function flow_query_local_player_has_loot_chest(arg_26_0)
	local var_26_0 = BackendUtils.has_loot_chest()

	var_0_0.value = var_26_0

	return var_0_0
end

function flow_callback_leader_sum_best_power_levels(arg_27_0)
	local var_27_0 = Managers.party:leader()
	local var_27_1 = Network.peer_id()

	fassert(var_27_0 == var_27_1, "Flow node \"Leader Sum of Best Power Levels\" should only be called by the leader player")

	local var_27_2 = Managers.world
	local var_27_3 = "level_world"

	if var_27_2:has_world(var_27_3) then
		local var_27_4 = var_27_2:world(var_27_3)
		local var_27_5 = arg_27_0.result_event
		local var_27_6 = arg_27_0.result_parameter
		local var_27_7 = Managers.backend:get_interface("items"):sum_best_power_levels()

		LevelHelper:set_flow_parameter(var_27_4, var_27_6, var_27_7)
		LevelHelper:flow_event(var_27_4, var_27_5)
	end
end

function flow_query_leader_has_dlc(arg_28_0)
	local var_28_0 = Managers.party:leader()
	local var_28_1 = Network.peer_id()

	fassert(var_28_0 == var_28_1, "Flow node \"Leader Has DLC\" should only be called by the leader player")

	local var_28_2 = arg_28_0.dlc_name

	if var_28_2 == "pre_order" and script_data.has_dlc_pre_order_flow_override ~= nil then
		var_0_0.value = script_data.has_dlc_pre_order_flow_override

		return var_0_0
	end

	local var_28_3 = Managers.unlock:is_dlc_unlocked(var_28_2)

	var_0_0.value = var_28_3

	return var_0_0
end

function flow_query_local_player_has_dlc(arg_29_0)
	local var_29_0 = arg_29_0.dlc_name

	if var_29_0 == "pre_order" and script_data.has_dlc_pre_order_flow_override ~= nil then
		var_0_0.value = script_data.has_dlc_pre_order_flow_override

		return var_0_0
	end

	local var_29_1 = Managers.unlock:is_dlc_unlocked(var_29_0)

	var_0_0.value = var_29_1

	return var_0_0
end

function flow_query_leader_owns_vt1(arg_30_0)
	local var_30_0 = Managers.party:leader()
	local var_30_1 = Network.peer_id()

	fassert(var_30_0 == var_30_1, "Flow node \"Leader Owns VT1\" should only be called by the leader player")

	local var_30_2 = false

	if IS_WINDOWS and rawget(_G, "Steam") then
		var_30_2 = Steam.owns_app(235540)
	end

	var_0_0.value = var_30_2

	return var_0_0
end

function flow_query_leader_completed_all_dlc_levels(arg_31_0)
	local var_31_0 = Managers.party:leader()
	local var_31_1 = Network.peer_id()

	fassert(var_31_0 == var_31_1, "Flow node \"Leader Completed All DLC Levels\" should only be called by the leader player")

	local var_31_2 = arg_31_0.dlc_name
	local var_31_3 = Managers.player
	local var_31_4 = var_31_3:statistics_db()
	local var_31_5 = var_31_3:player(var_31_0, 1):stats_id()
	local var_31_6 = LevelUnlockUtils.all_dlc_levels_completed(var_31_4, var_31_5, var_31_2)

	var_0_0.value = var_31_6

	return var_0_0
end

function flow_query_leader_early_owner(arg_32_0)
	local var_32_0 = Managers.party:leader()
	local var_32_1 = Network.peer_id()

	fassert(var_32_0 == var_32_1, "Flow node \"Leader Early Owner\" should only be called by the leader player")

	local var_32_2 = Managers.backend:get_read_only_data("early_owner")

	var_0_0.value = not not var_32_2

	return var_0_0
end

function flow_query_leader_get_persistant_stat(arg_33_0)
	local var_33_0 = Managers.party:leader()
	local var_33_1 = Network.peer_id()

	fassert(var_33_0 == var_33_1, "Flow node \"Leader Get Persistant Stat\" should only be called by the leader player")

	local var_33_2 = arg_33_0.stat_name
	local var_33_3 = string.split(var_33_2, "|")
	local var_33_4 = var_0_1(var_33_1, unpack(var_33_3))

	var_0_0.value = var_33_4

	return var_0_0
end

function flow_query_local_player_get_persistant_stat(arg_34_0)
	local var_34_0 = arg_34_0.stat_name
	local var_34_1 = string.split(var_34_0, "|")
	local var_34_2 = var_0_1(Network.peer_id(), unpack(var_34_1))

	var_0_0.value = var_34_2

	return var_0_0
end
