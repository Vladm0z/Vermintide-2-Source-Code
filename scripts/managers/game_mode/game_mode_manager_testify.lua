-- chunkname: @scripts/managers/game_mode/game_mode_manager_testify.lua

return {
	game_mode_start_round = function (self)
		-- function 1
		self:round_started()

		self:game_mode().pre_round_start_timer = 0
	end,
	wait_for_game_mode = function (self, arg_2_1)
		-- function 2
		if arg_2_1 ~= self:game_mode_key() then
			return Testify.RETRY
		end
	end,
	wait_for_game_mode_state = function (self, arg_3_1)
		-- function 3
		local game_mode = arg_3_1.game_mode
		local state = arg_3_1.state
		local game_mode_key = self:game_mode_key()

		if not (not game_mode and game_mode == game_mode_key) then
			return Testify.RETRY
		end

		local game_mode_2 = self:game_mode()

		if not game_mode_2 then
			return Testify.RETRY
		end

		if game_mode_2:game_mode_state() ~= state then
			return Testify.RETRY
		end
	end,
	wait_for_transition_state = function (self, arg_4_1)
		-- function 4
		if self:wanted_transition() ~= arg_4_1 then
			return Testify.RETRY
		end
	end
}
