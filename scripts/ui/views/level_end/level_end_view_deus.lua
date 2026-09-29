-- chunkname: @scripts/ui/views/level_end/level_end_view_deus.lua

LevelEndViewDeus = class(LevelEndViewDeus, LevelEndView)

LevelEndViewDeus.start = function (self)
	-- function 1
	LevelEndViewDeus.super.start(self)

	self._start_music_event = self.game_won and not not "Play_won_music_morris" or not self.game_won and not not "Play_lost_music_morris"
	self._stop_music_event = self.game_won and not not "Stop_won_music_morris" or not self.game_won and not not "Stop_lost_music_morris"
end

LevelEndViewDeus._setup_pages_victory = function (self, rewards)
	-- function 2
	local end_of_level_rewards = rewards.end_of_level_rewards
	local chest = end_of_level_rewards.chest
	local index_by_state_name

	if chest then
		index_by_state_name = {
			EndViewStateParading = 1,
			EndViewStateSummaryDeus = 2,
			EndViewStateChest = 3,
			EndViewStateScore = 4
		}
	else
		index_by_state_name = {
			EndViewStateParading = 1,
			EndViewStateSummaryDeus = 2,
			EndViewStateScore = 3
		}
	end

	return index_by_state_name
end

LevelEndViewDeus._setup_pages_defeat = function (self, rewards)
	-- function 3
	local end_of_level_rewards = rewards.end_of_level_rewards
	local chest = end_of_level_rewards.chest
	local index_by_state_name

	if chest then
		index_by_state_name = {
			EndViewStateChest = 2,
			EndViewStateSummaryDeus = 1,
			EndViewStateScore = 3
		}
	else
		index_by_state_name = {
			EndViewStateScore = 2,
			EndViewStateSummaryDeus = 1
		}
	end

	return index_by_state_name
end
