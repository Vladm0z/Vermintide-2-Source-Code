-- chunkname: @scripts/managers/side/side_manager_testify.lua

return {
	num_human_players_on_side = function(arg_1_0, arg_1_1)
		local var_1_0 = arg_1_0:get_side_from_name("heroes")

		if not var_1_0 then
			return Testify.RETRY
		end

		return table.size(var_1_0.PLAYER_UNITS)
	end
}
