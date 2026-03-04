-- chunkname: @scripts/ui/views/level_end/level_end_view_weave_testify.lua

return {
	make_game_ready_for_next_weave = function(arg_1_0)
		if not arg_1_0._started_exit then
			arg_1_0:exit_to_game()
		end

		return Testify.RETRY
	end
}
