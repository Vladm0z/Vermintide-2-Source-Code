-- chunkname: @scripts/managers/game_mode/game_mechanism_manager_testify.lua

return {
	request_vote = function (self, arg_1_1)
		-- function 1
		self:request_vote(arg_1_1)
	end,
	versus_get_num_sets = function (self, arg_2_1)
		-- function 2
		if self:current_mechanism_name() ~= "versus" then
			return Testify.RETRY
		end

		local num_sets = self:game_mechanism():num_sets()

		if num_sets < 1 then
			return Testify.RETRY
		end

		return num_sets
	end
}
