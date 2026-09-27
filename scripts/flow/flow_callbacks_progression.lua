-- chunkname: @scripts/flow/flow_callbacks_progression.lua

local flow_return_table = Boot.flow_return_table

function flow_callback_check_progression_unlocked(arg_1_0)
	-- function 1
	flow_return_table.is_unlocked = false
	flow_return_table.is_locked = true

	return flow_return_table
end

function flow_callback_get_last_level_played(arg_2_0)
	-- function 2
	local last_played_level = SaveData.last_played_level

	last_played_level = last_played_level or "N/A"

	local flag = SaveData.last_played_level_result == "won"

	flow_return_table.level_key = last_played_level
	flow_return_table.won = flag

	return flow_return_table
end

function flow_callback_last_level_played_was_weave(arg_3_0)
	-- function 3
	local last_played_level = SaveData.last_played_level

	last_played_level = last_played_level or "N/A"

	local flag = SaveData.last_played_level_result == "won"
	local templates = WeaveSettings.templates
	local flag_2 = false
	local flag_3 = false

	for k, v in pairs(templates) do
		local objectives = v.objectives
		local var_3_6 = objectives[1]
		local var_3_7 = objectives[2]

		if var_3_6.level_id == last_played_level then
			flag_2 = true
		elseif var_3_7.level_id == last_played_level then
			flag_3 = true
		end
	end

	flow_return_table.was_weave_level = flag_2
	flow_return_table.was_boss_level = flag_3
	flow_return_table.won = flag

	return flow_return_table
end

function flow_callback_ui_onboarding_tutorial_completed(self)
	-- function 4
	local flag = false
	local player = Managers.player

	if not player then
		local statistics_db = player:statistics_db()
		local local_player = player:local_player()

		if not statistics_db and not local_player then
			local tutorial_name = self.tutorial_name

			tutorial_name = not tutorial_name and WeaveUITutorials[self.tutorial_name]

			if not tutorial_name then
				local get_ui_onboarding_state = WeaveOnboardingUtils.get_ui_onboarding_state(statistics_db, local_player:stats_id())

				flag = WeaveOnboardingUtils.tutorial_completed(get_ui_onboarding_state, tutorial_name)
			end
		end
	end

	flow_return_table.completed = flag

	return flow_return_table
end

function flow_callback_get_completed_game_difficulty(arg_5_0)
	-- function 5
	local statistics_db = Managers.player:statistics_db()
	local server_player = Managers.player:server_player()

	if not server_player then
		local stats_id = server_player:stats_id()
		local completed_adventure_difficulty = LevelUnlockUtils.completed_adventure_difficulty(statistics_db, stats_id)

		return {
			completed_difficulty = completed_adventure_difficulty
		}
	end

	return {
		completed_difficulty = 0
	}
end

function flow_callback_get_completed_drachenfels_difficulty(arg_6_0)
	-- function 6
	local statistics_db = Managers.player:statistics_db()
	local server_player = Managers.player:server_player()

	if not server_player then
		local tbl = {
			"dlc_portals",
			"dlc_castle",
			"dlc_castle_dungeon"
		}
		local var_6_3
		local stats_id = server_player:stats_id()

		for i, v in ipairs(tbl) do
			local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, v)

			if not (not var_6_3 and not (completed_level_difficulty_index < var_6_3)) then
				var_6_3 = completed_level_difficulty_index
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
	-- function 7
	local statistics_db = Managers.player:statistics_db()
	local server_player = Managers.player:server_player()

	if not server_player then
		local tbl = {
			"dlc_dwarf_exterior",
			"dlc_dwarf_interior",
			"dlc_dwarf_beacons"
		}
		local var_7_3
		local stats_id = server_player:stats_id()

		for i, v in ipairs(tbl) do
			local completed_level_difficulty = LevelUnlockUtils.completed_level_difficulty(statistics_db, stats_id, v)

			if not (not var_7_3 and not (completed_level_difficulty < var_7_3)) then
				var_7_3 = completed_level_difficulty
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
	-- function 8
	local player = Managers.player
	local server_player = player:server_player()
	local tbl = {
		dlc_survival_ruins = 0,
		dlc_survival_magnus = 0
	}

	if not server_player then
		local statistics_db = player:statistics_db()
		local SurvivalStartWaveByDifficulty = SurvivalStartWaveByDifficulty
		local stats_id = server_player:stats_id()

		for k, v in pairs(tbl) do
			local get_survival_stat = StatisticsUtil.get_survival_stat(statistics_db, k, "cataclysm", "waves", stats_id)

			if get_survival_stat > 0 then
				get_survival_stat = get_survival_stat + SurvivalStartWaveByDifficulty.cataclysm
			end

			local get_survival_stat_2 = StatisticsUtil.get_survival_stat(statistics_db, k, "cataclysm_2", "waves", stats_id)

			if get_survival_stat_2 > 0 then
				get_survival_stat_2 = get_survival_stat_2 + SurvivalStartWaveByDifficulty.cataclysm_2
			end

			local get_survival_stat_3 = StatisticsUtil.get_survival_stat(statistics_db, k, "cataclysm_3", "waves", stats_id)

			if get_survival_stat_3 > 0 then
				get_survival_stat_3 = get_survival_stat_3 + SurvivalStartWaveByDifficulty.cataclysm_3
			end

			tbl[k] = math.max(get_survival_stat, get_survival_stat_2, get_survival_stat_3)
		end
	end

	return tbl
end

function flow_callback_override_level_progression_for_experience(self)
	-- function 9
	local progression = self.progression

	fassert(not (progression >= 0) or progression <= 1, "Level progression needs to be a number between 0 and 1, not %d", progression)
	Managers.state.entity:system("mission_system"):override_percentage_completed(progression)
end

function flow_query_leader_hero_level(self)
	-- function 10
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Hero Level\" should only be called by the leader player")

	local hero_name = self.hero_name
	local get_experience = ExperienceSettings.get_experience(hero_name)
	local get_level = ExperienceSettings.get_level(get_experience)

	flow_return_table.value = get_level

	return flow_return_table
end

function flow_query_leader_hero_prestige(self)
	-- function 11
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Hero Prestige\" should only be called by the leader player")

	local hero_name = self.hero_name
	local get_prestige_level = ProgressionUnlocks.get_prestige_level(hero_name)

	flow_return_table.value = get_prestige_level

	return flow_return_table
end

function flow_query_leader_completed_difficulty(arg_12_0)
	-- function 12
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Completed Difficulty\" should only be called by the leader player")

	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:player(leader, 1):stats_id()
	local completed_main_game_difficulty = LevelUnlockUtils.completed_main_game_difficulty(statistics_db, stats_id)

	flow_return_table.value = completed_main_game_difficulty

	return flow_return_table
end

function flow_query_leader_completed_dlc_difficulty(self)
	-- function 13
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Completed DLC Difficulty\" should only be called by the leader player")

	local dlc_name = self.dlc_name
	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:player(leader, 1):stats_id()
	local completed_dlc_difficulty = LevelUnlockUtils.completed_dlc_difficulty(statistics_db, stats_id, dlc_name)

	flow_return_table.value = completed_dlc_difficulty

	return flow_return_table
end

local function fn(arg_14_0, ...)
	-- function 14
	local player = Managers.player
	local statistics_db = player:statistics_db()
	local player_2 = player:player(arg_14_0, 1)
	local var_14_3

	if not player_2 then
		local stats_id = player_2:stats_id()

		var_14_3 = statistics_db:get_persistent_stat(stats_id, ...)
	end

	return var_14_3
end

function flow_query_leader_completed_exalted_champion_difficulty(arg_15_0)
	-- function 15
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Completed Bodvarr Difficulty\" should only be called by the leader player")

	local var_15_2 = fn(leader, "kill_chaos_exalted_champion_difficulty_rank")

	flow_return_table.value = var_15_2

	return flow_return_table
end

function flow_query_leader_completed_exalted_sorcerer_difficulty(arg_16_0)
	-- function 16
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Completed Haleschmorg Burglederp Difficulty\" should only be called by the leader player")

	local var_16_2 = fn(leader, "kill_chaos_exalted_sorcerer_difficulty_rank")

	flow_return_table.value = var_16_2

	return flow_return_table
end

function flow_query_leader_completed_grey_seer_difficulty(arg_17_0)
	-- function 17
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Completed Rasknitt Difficulty\" should only be called by the leader player")

	local var_17_2 = fn(leader, "kill_skaven_grey_seer_difficulty_rank")

	flow_return_table.value = var_17_2

	return flow_return_table
end

function flow_query_leader_completed_storm_vermin_warlord_difficulty(arg_18_0)
	-- function 18
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Completed Skarrik Spinemanglr Difficulty\" should only be called by the leader player")

	local var_18_2 = fn(leader, "kill_skaven_storm_vermin_warlord_difficulty_rank")

	flow_return_table.value = var_18_2

	return flow_return_table
end

function flow_query_leader_completed_celebrate_event_2019(arg_19_0)
	-- function 19
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Completed Celebrate Event 2019\" should only be called by the leader player")

	local flag = fn(leader, "completed_levels", "dlc_celebrate_crawl") > 0

	flow_return_table.value = flag

	return flow_return_table
end

function flow_query_leader_achievement_completed(self)
	-- function 20
	if not (script_data.settings.use_beta_mode or Managers.state.achievement:is_enabled()) then
		flow_return_table.value = false

		return flow_return_table
	end

	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Achievement Completed\" should only be called by the leader player")

	if script_data.achievement_completed_flow_override ~= nil then
		flow_return_table.value = script_data.achievement_completed_flow_override

		return flow_return_table
	end

	local achievement_name = self.achievement_name
	local var_20_3 = AchievementTemplates.achievements[achievement_name]

	fassert(var_20_3, "Achievement [\"%s\"] not found in AchievementTemplates!", achievement_name)

	local get_interface = Managers.backend:get_interface("loot")

	if not get_interface then
		local achievement_rewards_claimed = get_interface:achievement_rewards_claimed(var_20_3.id)

		if not achievement_rewards_claimed then
			flow_return_table.value = achievement_rewards_claimed

			return flow_return_table
		end
	end

	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:player(leader, 1):stats_id()
	local completed = var_20_3.completed(statistics_db, stats_id)

	flow_return_table.value = completed

	return flow_return_table
end

function flow_query_local_player_achievement_completed(self)
	-- function 21
	if not (script_data.settings.use_beta_mode or Managers.state.achievement:is_enabled()) then
		flow_return_table.value = false

		return flow_return_table
	end

	if script_data.achievement_completed_flow_override ~= nil then
		flow_return_table.value = script_data.achievement_completed_flow_override

		return flow_return_table
	end

	local achievement_name = self.achievement_name
	local var_21_1 = AchievementTemplates.achievements[achievement_name]

	fassert(var_21_1, "Achievement [\"%s\"] not found in AchievementTemplates!", achievement_name)

	local get_interface = Managers.backend:get_interface("loot")

	if not get_interface then
		local achievement_rewards_claimed = get_interface:achievement_rewards_claimed(var_21_1.id)

		if not achievement_rewards_claimed then
			flow_return_table.value = achievement_rewards_claimed

			return flow_return_table
		end
	end

	local player = Managers.player
	local statistics_db = player:statistics_db()
	local local_player = player:local_player()
	local flag = false

	if not local_player then
		local stats_id = local_player:stats_id()

		flag = var_21_1.completed(statistics_db, stats_id)
	end

	flow_return_table.value = flag

	return flow_return_table
end

function flow_query_local_player_quest_progress(self)
	-- function 22
	flow_return_table.progress = 0
	flow_return_table.target = 0

	if not script_data.settings.use_beta_mode then
		flow_return_table.success = false

		return flow_return_table
	end

	local quest_id = self.quest_id

	if not Managers.backend:get_interface("quests"):get_quest_key(quest_id) then
		flow_return_table.success = false

		return flow_return_table
	end

	local get_data_by_id = Managers.state.quest:get_data_by_id(quest_id)

	if not get_data_by_id then
		flow_return_table.progress = get_data_by_id.progress[1]
		flow_return_table.target = get_data_by_id.progress[2]
		flow_return_table.success = true
	else
		flow_return_table.success = false
	end

	return flow_return_table
end

function flow_query_leader_hero_xp(self)
	-- function 23
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Hero XP\" should only be called by the leader player")

	local hero_name = self.hero_name
	local get_experience = ExperienceSettings.get_experience(hero_name)

	flow_return_table.value = get_experience

	return flow_return_table
end

function flow_query_leader_num_acts_completed(arg_24_0)
	-- function 24
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Number of Acts Completed\" should only be called by the leader player")

	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:player(leader, 1):stats_id()
	local num_acts_completed = LevelUnlockUtils.num_acts_completed(statistics_db, stats_id)

	flow_return_table.value = num_acts_completed

	return flow_return_table
end

function flow_query_leader_num_crafted_items(arg_25_0)
	-- function 25
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Number of Crafted Items\" should only be called by the leader player")

	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:player(leader, 1):stats_id()
	local get_persistent_stat = statistics_db:get_persistent_stat(stats_id, "crafted_items")

	flow_return_table.value = get_persistent_stat

	return flow_return_table
end

function flow_query_local_player_has_loot_chest(arg_26_0)
	-- function 26
	local has_loot_chest = BackendUtils.has_loot_chest()

	flow_return_table.value = has_loot_chest

	return flow_return_table
end

function flow_callback_leader_sum_best_power_levels(self)
	-- function 27
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Sum of Best Power Levels\" should only be called by the leader player")

	local world = Managers.world
	local str = "level_world"

	if not world:has_world(str) then
		local world_2 = world:world(str)
		local result_event = self.result_event
		local result_parameter = self.result_parameter
		local sum_best_power_levels = Managers.backend:get_interface("items"):sum_best_power_levels()

		LevelHelper:set_flow_parameter(world_2, result_parameter, sum_best_power_levels)
		LevelHelper:flow_event(world_2, result_event)
	end
end

function flow_query_leader_has_dlc(self)
	-- function 28
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Has DLC\" should only be called by the leader player")

	local dlc_name = self.dlc_name

	if not (dlc_name ~= "pre_order" or script_data.has_dlc_pre_order_flow_override == nil) then
		flow_return_table.value = script_data.has_dlc_pre_order_flow_override

		return flow_return_table
	end

	local is_dlc_unlocked = Managers.unlock:is_dlc_unlocked(dlc_name)

	flow_return_table.value = is_dlc_unlocked

	return flow_return_table
end

function flow_query_local_player_has_dlc(self)
	-- function 29
	local dlc_name = self.dlc_name

	if not (dlc_name ~= "pre_order" or script_data.has_dlc_pre_order_flow_override == nil) then
		flow_return_table.value = script_data.has_dlc_pre_order_flow_override

		return flow_return_table
	end

	local is_dlc_unlocked = Managers.unlock:is_dlc_unlocked(dlc_name)

	flow_return_table.value = is_dlc_unlocked

	return flow_return_table
end

function flow_query_leader_owns_vt1(arg_30_0)
	-- function 30
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Owns VT1\" should only be called by the leader player")

	local flag = false

	if not IS_WINDOWS and not rawget(_G, "Steam") then
		flag = Steam.owns_app(235540)
	end

	flow_return_table.value = flag

	return flow_return_table
end

function flow_query_leader_completed_all_dlc_levels(self)
	-- function 31
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Completed All DLC Levels\" should only be called by the leader player")

	local dlc_name = self.dlc_name
	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:player(leader, 1):stats_id()
	local all_dlc_levels_completed = LevelUnlockUtils.all_dlc_levels_completed(statistics_db, stats_id, dlc_name)

	flow_return_table.value = all_dlc_levels_completed

	return flow_return_table
end

function flow_query_leader_early_owner(arg_32_0)
	-- function 32
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Early Owner\" should only be called by the leader player")

	local get_read_only_data = Managers.backend:get_read_only_data("early_owner")

	flow_return_table.value = not not get_read_only_data

	return flow_return_table
end

function flow_query_leader_get_persistant_stat(self)
	-- function 33
	local leader = Managers.party:leader()
	local peer_id = Network.peer_id()

	fassert(leader == peer_id, "Flow node \"Leader Get Persistant Stat\" should only be called by the leader player")

	local stat_name = self.stat_name
	local split = string.split(stat_name, "|")
	local var_33_4 = fn(peer_id, unpack(split))

	flow_return_table.value = var_33_4

	return flow_return_table
end

function flow_query_local_player_get_persistant_stat(self)
	-- function 34
	local stat_name = self.stat_name
	local split = string.split(stat_name, "|")
	local var_34_2 = fn(Network.peer_id(), unpack(split))

	flow_return_table.value = var_34_2

	return flow_return_table
end
