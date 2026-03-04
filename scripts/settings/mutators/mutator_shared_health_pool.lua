-- chunkname: @scripts/settings/mutators/mutator_shared_health_pool.lua

return {
	description = "description_mutator_shared_health_pool",
	display_name = "display_name_mutator_shared_health_pool",
	icon = "icon_deed_normal_01",
	server_start_function = function (arg_1_0, arg_1_1)
		arg_1_1.player_units = {}
	end,
	server_update_function = function (arg_2_0, arg_2_1)
		MutatorUtils.apply_buff_to_alive_player_units(arg_2_0, arg_2_1, "trinket_shared_damage")
	end
}
