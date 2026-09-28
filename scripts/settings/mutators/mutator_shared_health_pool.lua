-- chunkname: @scripts/settings/mutators/mutator_shared_health_pool.lua

return {
	description = "description_mutator_shared_health_pool",
	display_name = "display_name_mutator_shared_health_pool",
	icon = "icon_deed_normal_01",
	server_start_function = function (context, data)
		-- function 1
		data.player_units = {}
	end,
	server_update_function = function (context, data)
		-- function 2
		MutatorUtils.apply_buff_to_alive_player_units(context, data, "trinket_shared_damage")
	end
}
