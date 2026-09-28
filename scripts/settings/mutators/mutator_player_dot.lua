-- chunkname: @scripts/settings/mutators/mutator_player_dot.lua

return {
	description = "description_mutator_player_dot",
	display_name = "display_name_mutator_player_dot",
	icon = "mutator_icon_player_dot",
	server_start_function = function (context, data)
		-- function 1
		data.player_units = {}
	end,
	server_update_function = function (context, data, dt, t)
		-- function 2
		MutatorUtils.apply_buff_to_alive_player_units(context, data, "mutator_player_dot")
	end
}
