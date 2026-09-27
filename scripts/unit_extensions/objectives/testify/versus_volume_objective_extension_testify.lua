-- chunkname: @scripts/unit_extensions/objectives/testify/versus_volume_objective_extension_testify.lua

return {
	versus_volume_objective_get_num_players_inside = function (self)
		-- function 1
		if self._volume_type == "all_alive_human_players_inside" then
			return self:_get_num_players_inside()
		end

		local get_side_from_name = Managers.state.side:get_side_from_name("heroes")
		local size = table.size(get_side_from_name.PLAYER_AND_BOT_UNITS)
		local size_2 = table.size(get_side_from_name.PLAYER_UNITS)
		local player = Managers.player
		local num = size - size_2

		return self:_get_num_players_inside() - num
	end
}
