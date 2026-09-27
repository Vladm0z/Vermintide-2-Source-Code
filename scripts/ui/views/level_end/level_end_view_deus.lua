-- chunkname: @scripts/ui/views/level_end/level_end_view_deus.lua

LevelEndViewDeus = class(LevelEndViewDeus, LevelEndView)

LevelEndViewDeus.start = function (self)
	-- function 1
	LevelEndViewDeus.super.start(self)

	local flag

	flag = not self.game_won and "Play_won_music_morris" and "Play_lost_music_morris"
	self._start_music_event = flag

	local flag_2

	flag_2 = not self.game_won and "Stop_won_music_morris" and "Stop_lost_music_morris"
	self._stop_music_event = flag_2
end

LevelEndViewDeus._setup_pages_victory = function (arg_2_0, arg_2_1)
	-- function 2
	local chest = arg_2_1.end_of_level_rewards.chest
	local var_2_1

	if not chest then
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

LevelEndViewDeus._setup_pages_defeat = function (arg_3_0, arg_3_1)
	-- function 3
	local chest = arg_3_1.end_of_level_rewards.chest
	local var_3_1

	if not chest then
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
