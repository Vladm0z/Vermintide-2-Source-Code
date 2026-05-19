-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_seasonal_settings.lua

ScorpionSeasonalSettings = {}
ScorpionSeasonalSettings.current_season_id = 4

function ScorpionSeasonalSettings.get_season_name(arg_1_0)
	if arg_1_0 == 1 then
		return "season_" .. arg_1_0
	end

	return "s" .. arg_1_0
end

ScorpionSeasonalSettings.current_season_name = ScorpionSeasonalSettings.get_season_name(ScorpionSeasonalSettings.current_season_id)

function ScorpionSeasonalSettings.get_leaderboard_stat_for_season(arg_2_0, arg_2_1)
	return ScorpionSeasonalSettings.get_season_name(arg_2_0) .. "_weave_score_" .. arg_2_1 .. "_players"
end

function ScorpionSeasonalSettings.get_leaderboard_stat(arg_3_0)
	return ScorpionSeasonalSettings.get_leaderboard_stat_for_season(ScorpionSeasonalSettings.current_season_id, arg_3_0)
end

function ScorpionSeasonalSettings.get_weave_score_stat_for_season(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0 == 1 then
		return "weave_score_weave_" .. arg_4_1 .. "_" .. arg_4_2 .. "_players"
	end

	return arg_4_1 .. "_" .. arg_4_2
end

function ScorpionSeasonalSettings.get_weave_score_stat(arg_5_0, arg_5_1)
	return ScorpionSeasonalSettings.get_weave_score_stat_for_season(ScorpionSeasonalSettings.current_season_id, arg_5_0, arg_5_1)
end
