-- chunkname: @scripts/settings/mutators/mutator_player_dot.lua

return {
	description = "description_mutator_player_dot",
	display_name = "display_name_mutator_player_dot",
	icon = "mutator_icon_player_dot",
	server_start_function = function(arg_1_0, arg_1_1)
		arg_1_1.player_units = {}
	end,
	server_update_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		MutatorUtils.apply_buff_to_alive_player_units(arg_2_0, arg_2_1, "mutator_player_dot")
	end
}
