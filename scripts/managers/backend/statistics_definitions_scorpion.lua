-- chunkname: @scripts/managers/backend/statistics_definitions_scorpion.lua

require("scripts/settings/weave_settings")
require("scripts/settings/dlcs/scorpion/scorpion_seasonal_settings")

local player = StatisticsDefinitions.player
local current_season_id = ScorpionSeasonalSettings.current_season_id
local num = 2
local tbl = {
	"weave_quickplay_wins"
}

for i = num, current_season_id do
	local str = "s" .. i

	player[str] = {}

	local var_0_5 = player[str]

	if i == 2 then
		var_0_5.weave_quickplay_wins = {
			value = 0,
			database_name = "weave_quickplay_wins",
			source = "player_data"
		}
	else
		for j = 1, #tbl do
			local var_0_6 = tbl[j]
			local str_2 = str .. "_" .. var_0_6

			var_0_5[var_0_6] = {
				value = 0,
				source = "player_data",
				database_name = str_2
			}
		end
	end

	for k = 1, 500 do
		for l = 1, 4 do
			local str_3 = k .. "_" .. l
			local str_4 = str .. "_" .. str_3

			var_0_5[str_3] = {
				value = 0,
				source = "player_data",
				database_name = str_4
			}
		end
	end
end

player.season_1 = {}

for i4 = 1, 500 do
	local tbl_2 = {
		value = 0,
		source = "player_data"
	}

	for i5 = 1, 4 do
		local str_5 = "weave_score_weave_" .. i4 .. "_" .. i5 .. "_players"
		local str_6 = "season_1_" .. str_5

		player.season_1[str_5] = table.clone(tbl_2)
		player.season_1[str_5].database_name = str_6
	end
end

local heroes = PROFILES_BY_AFFILIATION.heroes

for i6 = 1, #heroes do
	local var_0_14 = FindProfileIndex(heroes[i6])

	for k_2, v in pairs(SPProfiles[var_0_14].careers) do
		local tbl_3 = {
			value = 0,
			source = "player_data"
		}
		local str_7 = "weaves_complete_" .. v.display_name .. "_season_1"
		local str_8 = "season_1_" .. str_7

		player.season_1[str_7] = table.clone(tbl_3)
		player.season_1[str_7].database_name = str_8

		for i_2, v_2 in ipairs(WeaveSettings.winds) do
			local str_9 = "weave_rainbow_" .. v_2 .. "_" .. v.display_name .. "_season_1"
			local str_10 = "season_1_" .. str_9

			player.season_1[str_9] = table.clone(tbl_3)
			player.season_1[str_9].database_name = str_10
		end
	end
end

player.season_1.weave_quickplay_wins = {
	value = 0,
	database_name = "season_1_weave_quickplay_wins",
	source = "player_data"
}

local tbl_4 = {
	value = 0,
	source = "player_data"
}

for k_3, v_3 in pairs(DifficultySettings) do
	local str_11 = "weave_quickplay_" .. k_3 .. "_wins"
	local str_12 = "season_1_" .. str_11

	player.season_1[str_11] = table.clone(tbl_4)
	player.season_1[str_11].database_name = str_12
end

for i_3, v_4 in ipairs(WeaveSettings.winds) do
	local str_13 = "scorpion_weaves_" .. v_4 .. "_season_1"
	local str_14 = "season_1_" .. str_13
	local tbl_5 = {
		value = 0,
		source = "player_data"
	}

	player.season_1[str_13] = table.clone(tbl_5)
	player.season_1[str_13].database_name = str_14
end

player.season_1.weave_life_stepped_in_bush = {
	value = 0,
	database_name = "season_1_weave_life_stepped_in_bush",
	source = "player_data"
}
player.season_1.weave_death_hit_by_spirit = {
	value = 0,
	database_name = "season_1_weave_death_hit_by_spirit",
	source = "player_data"
}
player.season_1.weave_beasts_destroyed_totems = {
	value = 0,
	database_name = "season_1_weave_beasts_destroyed_totems",
	source = "player_data"
}
player.season_1.weave_light_low_curse = {
	value = 0,
	database_name = "season_1_weave_light_low_curse",
	source = "player_data"
}
player.season_1.weave_shadow_kill_no_shrouded = {
	value = 0,
	database_name = "season_1_weave_shadow_kill_no_shrouded",
	source = "player_data"
}

local templates = WeaveSettings.templates

player.completed_weaves = {}
player.season_1.weave_won = {}

for k_4, v_5 in pairs(templates) do
	player.completed_weaves[k_4] = {
		value = 0,
		source = "player_data",
		database_name = "completed_" .. k_4
	}

	local num_2 = 1
	local tier = v_5.tier

	player.season_1.weave_won[tier] = {
		value = 0,
		source = "player_data",
		database_name = "weave_won_" .. num_2 .. "_" .. tier
	}
end

player.scorpion_onboarding_step = {
	value = 0,
	database_name = "scorpion_onboarding_step",
	source = "player_data"
}
player.scorpion_ui_onboarding_state = {
	value = 0,
	database_name = "scorpion_ui_onboarding_state",
	source = "player_data"
}
player.scorpion_weaves_won = {
	value = 0,
	database_name = "scorpion_weaves_won",
	source = "player_data"
}
player.kill_chaos_exalted_champion_scorpion_hardest = {
	value = 0,
	database_name = "kill_chaos_exalted_champion_scorpion_hardest",
	source = "player_data"
}
player.kill_chaos_exalted_sorcerer_scorpion_hardest = {
	value = 0,
	database_name = "kill_chaos_exalted_sorcerer_scorpion_hardest",
	source = "player_data"
}
player.kill_skaven_grey_seer_scorpion_hardest = {
	value = 0,
	database_name = "kill_skaven_grey_seer_scorpion_hardest",
	source = "player_data"
}
player.kill_skaven_storm_vermin_warlord_scorpion_hardest = {
	value = 0,
	database_name = "kill_skaven_storm_vermin_warlord_scorpion_hardest",
	source = "player_data"
}
player.scorpion_onboarding_weave_first_fail_vo_played = {
	value = 0,
	database_name = "scorpion_onboarding_weave_first_fail_vo_played",
	source = "player_data"
}

StatisticsUtil.generate_weapon_kill_stats_dlc(player, "scorpion", {
	value = 0,
	source = "player_data"
})
StatisticsUtil.generate_level_complete_with_weapon_stats_dlc(player, "scorpion", {
	value = 0,
	source = "player_data"
})
