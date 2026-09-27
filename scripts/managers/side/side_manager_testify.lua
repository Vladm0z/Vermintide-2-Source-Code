-- chunkname: @scripts/managers/side/side_manager_testify.lua

return {
	num_human_players_on_side = function (self, arg_1_1)
		-- function 1
		local get_side_from_name = self:get_side_from_name("heroes")

		if not get_side_from_name then
			return Testify.RETRY
		end

		return table.size(get_side_from_name.PLAYER_UNITS)
	end
}
