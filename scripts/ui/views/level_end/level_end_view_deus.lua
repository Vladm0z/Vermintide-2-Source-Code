-- chunkname: @scripts/ui/views/level_end/level_end_view_deus.lua

LevelEndViewDeus = class(LevelEndViewDeus, LevelEndView)

function LevelEndViewDeus.start(arg_1_0)
	LevelEndViewDeus.super.start(arg_1_0)

	arg_1_0._start_music_event = arg_1_0.game_won and "Play_won_music_morris" or "Play_lost_music_morris"
	arg_1_0._stop_music_event = arg_1_0.game_won and "Stop_won_music_morris" or "Stop_lost_music_morris"
end

function LevelEndViewDeus._setup_pages_victory(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.end_of_level_rewards.chest
	local var_2_1

	if var_2_0 then
		var_2_1 = {
			EndViewStateParading = 1,
			EndViewStateSummaryDeus = 2,
			EndViewStateChest = 3,
			EndViewStateScore = 4
		}
	else
		var_2_1 = {
			EndViewStateParading = 1,
			EndViewStateSummaryDeus = 2,
			EndViewStateScore = 3
		}
	end

	return var_2_1
end

function LevelEndViewDeus._setup_pages_defeat(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.end_of_level_rewards.chest
	local var_3_1

	if var_3_0 then
		var_3_1 = {
			EndViewStateChest = 2,
			EndViewStateSummaryDeus = 1,
			EndViewStateScore = 3
		}
	else
		var_3_1 = {
			EndViewStateScore = 2,
			EndViewStateSummaryDeus = 1
		}
	end

	return var_3_1
end
