-- chunkname: @scripts/managers/backend/statistics_definitions_scorpion.lua

require("scripts/settings/weave_settings")
require("scripts/settings/dlcs/scorpion/scorpion_seasonal_settings")

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = ScorpionSeasonalSettings.current_season_id
local var_0_2 = 2
local var_0_3 = {
	"weave_quickplay_wins"
}

for iter_0_0 = var_0_2, var_0_1 do
	local var_0_4 = "s" .. iter_0_0

	var_0_0[var_0_4] = {}

	local var_0_5 = var_0_0[var_0_4]

	if iter_0_0 == 2 then
		var_0_5.weave_quickplay_wins = {
			value = 0,
			database_name = "weave_quickplay_wins",
			source = "player_data"
		}
	else
		for iter_0_1 = 1, #var_0_3 do
			local var_0_6 = var_0_3[iter_0_1]
			local var_0_7 = var_0_4 .. "_" .. var_0_6

			var_0_5[var_0_6] = {
				value = 0,
				source = "player_data",
				database_name = var_0_7
			}
		end
	end

	for iter_0_2 = 1, 500 do
		for iter_0_3 = 1, 4 do
			local var_0_8 = iter_0_2 .. "_" .. iter_0_3
			local var_0_9 = var_0_4 .. "_" .. var_0_8

			var_0_5[var_0_8] = {
				value = 0,
				source = "player_data",
				database_name = var_0_9
			}
		end
	end
end

var_0_0.season_1 = {}

for iter_0_4 = 1, 500 do
	local var_0_10 = {
		value = 0,
		source = "player_data"
	}

	for iter_0_5 = 1, 4 do
		local var_0_11 = "weave_score_weave_" .. iter_0_4 .. "_" .. iter_0_5 .. "_players"
		local var_0_12 = "season_1_" .. var_0_11

		var_0_0.season_1[var_0_11] = table.clone(var_0_10)
		var_0_0.season_1[var_0_11].database_name = var_0_12
	end
end

local var_0_13 = PROFILES_BY_AFFILIATION.heroes

for iter_0_6 = 1, #var_0_13 do
	local var_0_14 = FindProfileIndex(var_0_13[iter_0_6])

	for iter_0_7, iter_0_8 in pairs(SPProfiles[var_0_14].careers) do
		local var_0_15 = {
			value = 0,
			source = "player_data"
		}
		local var_0_16 = "weaves_complete_" .. iter_0_8.display_name .. "_season_1"
		local var_0_17 = "season_1_" .. var_0_16

		var_0_0.season_1[var_0_16] = table.clone(var_0_15)
		var_0_0.season_1[var_0_16].database_name = var_0_17

		for iter_0_9, iter_0_10 in ipairs(WeaveSettings.winds) do
			local var_0_18 = "weave_rainbow_" .. iter_0_10 .. "_" .. iter_0_8.display_name .. "_season_1"
			local var_0_19 = "season_1_" .. var_0_18

			var_0_0.season_1[var_0_18] = table.clone(var_0_15)
			var_0_0.season_1[var_0_18].database_name = var_0_19
		end
	end
end

var_0_0.season_1.weave_quickplay_wins = {
	value = 0,
	database_name = "season_1_weave_quickplay_wins",
	source = "player_data"
}

local var_0_20 = {
	value = 0,
	source = "player_data"
}

for iter_0_11, iter_0_12 in pairs(DifficultySettings) do
	local var_0_21 = "weave_quickplay_" .. iter_0_11 .. "_wins"
	local var_0_22 = "season_1_" .. var_0_21

	var_0_0.season_1[var_0_21] = table.clone(var_0_20)
	var_0_0.season_1[var_0_21].database_name = var_0_22
end

for iter_0_13, iter_0_14 in ipairs(WeaveSettings.winds) do
	local var_0_23 = "scorpion_weaves_" .. iter_0_14 .. "_season_1"
	local var_0_24 = "season_1_" .. var_0_23
	local var_0_25 = {
		value = 0,
		source = "player_data"
	}

	var_0_0.season_1[var_0_23] = table.clone(var_0_25)
	var_0_0.season_1[var_0_23].database_name = var_0_24
end

var_0_0.season_1.weave_life_stepped_in_bush = {
	value = 0,
	database_name = "season_1_weave_life_stepped_in_bush",
	source = "player_data"
}
var_0_0.season_1.weave_death_hit_by_spirit = {
	value = 0,
	database_name = "season_1_weave_death_hit_by_spirit",
	source = "player_data"
}
var_0_0.season_1.weave_beasts_destroyed_totems = {
	value = 0,
	database_name = "season_1_weave_beasts_destroyed_totems",
	source = "player_data"
}
var_0_0.season_1.weave_light_low_curse = {
	value = 0,
	database_name = "season_1_weave_light_low_curse",
	source = "player_data"
}
var_0_0.season_1.weave_shadow_kill_no_shrouded = {
	value = 0,
	database_name = "season_1_weave_shadow_kill_no_shrouded",
	source = "player_data"
}

local var_0_26 = WeaveSettings.templates

var_0_0.completed_weaves = {}
var_0_0.season_1.weave_won = {}

for iter_0_15, iter_0_16 in pairs(var_0_26) do
	var_0_0.completed_weaves[iter_0_15] = {
		value = 0,
		source = "player_data",
		database_name = "completed_" .. iter_0_15
	}

	local var_0_27 = 1
	local var_0_28 = iter_0_16.tier

	var_0_0.season_1.weave_won[var_0_28] = {
		value = 0,
		source = "player_data",
		database_name = "weave_won_" .. var_0_27 .. "_" .. var_0_28
	}
end

var_0_0.scorpion_onboarding_step = {
	value = 0,
	database_name = "scorpion_onboarding_step",
	source = "player_data"
}
var_0_0.scorpion_ui_onboarding_state = {
	value = 0,
	database_name = "scorpion_ui_onboarding_state",
	source = "player_data"
}
var_0_0.scorpion_weaves_won = {
	value = 0,
	database_name = "scorpion_weaves_won",
	source = "player_data"
}
var_0_0.kill_chaos_exalted_champion_scorpion_hardest = {
	value = 0,
	database_name = "kill_chaos_exalted_champion_scorpion_hardest",
	source = "player_data"
}
var_0_0.kill_chaos_exalted_sorcerer_scorpion_hardest = {
	value = 0,
	database_name = "kill_chaos_exalted_sorcerer_scorpion_hardest",
	source = "player_data"
}
var_0_0.kill_skaven_grey_seer_scorpion_hardest = {
	value = 0,
	database_name = "kill_skaven_grey_seer_scorpion_hardest",
	source = "player_data"
}
var_0_0.kill_skaven_storm_vermin_warlord_scorpion_hardest = {
	value = 0,
	database_name = "kill_skaven_storm_vermin_warlord_scorpion_hardest",
	source = "player_data"
}
var_0_0.scorpion_onboarding_weave_first_fail_vo_played = {
	value = 0,
	database_name = "scorpion_onboarding_weave_first_fail_vo_played",
	source = "player_data"
}

StatisticsUtil.generate_weapon_kill_stats_dlc(var_0_0, "scorpion", {
	value = 0,
	source = "player_data"
})
StatisticsUtil.generate_level_complete_with_weapon_stats_dlc(var_0_0, "scorpion", {
	value = 0,
	source = "player_data"
})
