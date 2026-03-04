-- chunkname: @scripts/unit_extensions/objectives/testify/versus_volume_objective_extension_testify.lua

return {
	versus_volume_objective_get_num_players_inside = function(arg_1_0)
		if arg_1_0._volume_type == "all_alive_human_players_inside" then
			return arg_1_0:_get_num_players_inside()
		end

		local var_1_0 = Managers.state.side:get_side_from_name("heroes")
		local var_1_1 = table.size(var_1_0.PLAYER_AND_BOT_UNITS)
		local var_1_2 = table.size(var_1_0.PLAYER_UNITS)
		local var_1_3 = Managers.player
		local var_1_4 = var_1_1 - var_1_2

		return arg_1_0:_get_num_players_inside() - var_1_4
	end
}
