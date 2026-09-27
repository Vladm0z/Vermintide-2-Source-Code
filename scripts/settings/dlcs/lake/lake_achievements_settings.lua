-- chunkname: @scripts/settings/dlcs/lake/lake_achievements_settings.lua

local lake = DLCSettings.lake

lake.achievement_outline = {
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
lake.achievement_template_file_names = {
	"scripts/managers/achievements/achievement_templates_lake"
}
lake.speed_quest_complete_time = 140
lake.timing_quest_complete_margain = 5

local var_0_1

local function fn(self, arg_1_1)
	-- function 1
	local time = Managers.time:time("game")
	local speed_quest_complete_time = lake.speed_quest_complete_time

	if arg_1_1 < 2 then
		var_0_1 = time
	elseif not (not (arg_1_1 > 1) or not (time < speed_quest_complete_time)) then
		local network_id = self:network_id()
		local str = "lake_speed_quest"
		local network = Managers.state.network
		local var_1_5 = NetworkLookup.statistics[str]

		network.network_transmit:send_rpc("rpc_increment_stat", network_id, var_1_5)
	end
end

local var_0_3

local function fn_2(self, arg_2_1)
	-- function 2
	local time = Managers.time:time("game")
	local timing_quest_complete_margain = lake.timing_quest_complete_margain

	if arg_2_1 < 2 then
		var_0_3 = time
	elseif not ((not (arg_2_1 > 1) or not var_0_3) and not (time < var_0_3 + timing_quest_complete_margain)) then
		local network_id = self:network_id()
		local str = "lake_timing_quest"
		local network = Managers.state.network
		local var_2_5 = NetworkLookup.statistics[str]

		network.network_transmit:send_rpc("rpc_increment_stat", network_id, var_2_5)
	end
end

lake.achievement_events = {
	on_challenge_completed = function (arg_3_0, arg_3_1)
		-- function 3
		local player = Managers.player
		local local_player = player:local_player()

		if not local_player then
			local player_unit = local_player.player_unit

			if not player_unit then
				return
			end

			local owner = player:owner(player_unit)

			if not owner then
				return
			end

			local unique_id = owner:unique_id()
			local get_completed_challenges_filtered = Managers.venture.challenge:get_completed_challenges_filtered({}, "questing_knight", unique_id)

			if not get_completed_challenges_filtered then
				return
			end

			local count = #get_completed_challenges_filtered

			fn(local_player, count)
			fn_2(local_player, count)
		end
	end
}
