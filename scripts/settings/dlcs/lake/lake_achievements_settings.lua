-- chunkname: @scripts/settings/dlcs/lake/lake_achievements_settings.lua

local var_0_0 = DLCSettings.lake

var_0_0.achievement_outline = {
	heroes = {
		categories = {
			{
				sorting = 1,
				name = "inventory_name_empire_soldier",
				entries = {
					"lake_complete_all_helmgart_levels_recruit_es_questingknight",
					"lake_complete_all_helmgart_levels_veteran_es_questingknight",
					"lake_complete_all_helmgart_levels_champion_es_questingknight",
					"lake_complete_all_helmgart_levels_legend_es_questingknight",
					"lake_complete_100_missions_es_questingknight",
					"lake_mission_streak_act1_legend_es_questingknight",
					"lake_mission_streak_act2_legend_es_questingknight",
					"lake_mission_streak_act3_legend_es_questingknight",
					"lake_boss_killblow",
					"lake_charge_stagger",
					"lake_bastard_block",
					"lake_untouchable",
					"lake_speed_quest",
					"lake_timing_quest",
					"complete_all_grailknight_challenges"
				}
			}
		}
	}
}
var_0_0.achievement_template_file_names = {
	"scripts/managers/achievements/achievement_templates_lake"
}
var_0_0.speed_quest_complete_time = 140
var_0_0.timing_quest_complete_margain = 5

local var_0_1

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = Managers.time:time("game")
	local var_1_1 = var_0_0.speed_quest_complete_time

	if arg_1_1 < 2 then
		var_0_1 = var_1_0
	elseif arg_1_1 > 1 and var_1_0 < var_1_1 then
		local var_1_2 = arg_1_0:network_id()
		local var_1_3 = "lake_speed_quest"
		local var_1_4 = Managers.state.network
		local var_1_5 = NetworkLookup.statistics[var_1_3]

		var_1_4.network_transmit:send_rpc("rpc_increment_stat", var_1_2, var_1_5)
	end
end

local var_0_3

local function var_0_4(arg_2_0, arg_2_1)
	local var_2_0 = Managers.time:time("game")
	local var_2_1 = var_0_0.timing_quest_complete_margain

	if arg_2_1 < 2 then
		var_0_3 = var_2_0
	elseif arg_2_1 > 1 and var_0_3 and var_2_0 < var_0_3 + var_2_1 then
		local var_2_2 = arg_2_0:network_id()
		local var_2_3 = "lake_timing_quest"
		local var_2_4 = Managers.state.network
		local var_2_5 = NetworkLookup.statistics[var_2_3]

		var_2_4.network_transmit:send_rpc("rpc_increment_stat", var_2_2, var_2_5)
	end
end

var_0_0.achievement_events = {
	on_challenge_completed = function(arg_3_0, arg_3_1)
		local var_3_0 = Managers.player
		local var_3_1 = var_3_0:local_player()

		if var_3_1 then
			local var_3_2 = var_3_1.player_unit

			if not var_3_2 then
				return
			end

			local var_3_3 = var_3_0:owner(var_3_2)

			if not var_3_3 then
				return
			end

			local var_3_4 = var_3_3:unique_id()
			local var_3_5 = Managers.venture.challenge:get_completed_challenges_filtered({}, "questing_knight", var_3_4)

			if not var_3_5 then
				return
			end

			local var_3_6 = #var_3_5

			var_0_2(var_3_1, var_3_6)
			var_0_4(var_3_1, var_3_6)
		end
	end
}
