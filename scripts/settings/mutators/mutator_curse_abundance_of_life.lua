-- chunkname: @scripts/settings/mutators/mutator_curse_abundance_of_life.lua

return {
	description = "curse_abundance_of_life_desc",
	display_name = "curse_abundance_of_life_name",
	icon = "deus_curse_slaanesh_01",
	pickup_system_multipliers = {
		healing = 0,
		deus_potions = 3,
		potions = 3
	},
	client_start_function = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		arg_1_1.only_affect_players = true
	end,
	client_update_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		MutatorUtils.apply_buff_to_alive_player_units(arg_2_0, arg_2_1, "curse_abundance_of_life")
	end
}
