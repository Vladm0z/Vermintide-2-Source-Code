-- chunkname: @scripts/managers/matchmaking/matchmaking_manager_testify.lua

return {
	wait_for_matchmaking_state = function (self, arg_1_1)
		-- function 1
		if self:state().NAME ~= arg_1_1 then
			return Testify.RETRY
		end
	end,
	wait_for_matchmaking_substate = function (self, arg_2_1)
		-- function 2
		local state = arg_2_1.state
		local substate = arg_2_1.substate

		if not (not state and self:state().NAME == state) then
			return Testify.RETRY
		end

		if self:state()._state ~= substate then
			return Testify.RETRY
		end
	end
}
