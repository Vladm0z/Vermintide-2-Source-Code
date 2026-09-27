-- chunkname: @scripts/ui/views/level_end/level_end_view_weave_testify.lua

return {
	make_game_ready_for_next_weave = function (self)
		-- function 1
		if not self._started_exit then
			self:exit_to_game()
		end

		return Testify.RETRY
	end
}
