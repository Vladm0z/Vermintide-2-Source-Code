-- chunkname: @scripts/settings/mutators/mutator_powerful_elites.lua

return {
	description = "description_mutator_powerful_elites",
	health_modifier = 2,
	display_name = "display_name_mutator_powerful_elites",
	icon = "mutator_icon_powerful_elites",
	modify_health_breeds = {
		"skaven_storm_vermin",
		"skaven_storm_vermin_commander",
		"skaven_storm_vermin_with_shield",
		"skaven_plague_monk",
		"chaos_raider",
		"chaos_warrior",
		"chaos_berzerker",
		"beastmen_bestigor"
	},
	server_start_function = function(arg_1_0, arg_1_1)
		arg_1_1.player_units = {}
	end,
	server_update_function = function(arg_2_0, arg_2_1)
		MutatorUtils.apply_buff_to_alive_player_units(arg_2_0, arg_2_1, "damage_taken_powerful_elites")
	end
}
