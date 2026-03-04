-- chunkname: @scripts/settings/mutators/mutator_gutter_runner_mayhem.lua

return {
	description = "description_mutator_gutter_runner_mayhem",
	icon = "mutator_icon_specials_frequency",
	display_name = "display_name_mutator_gutter_runner_mayhem",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		CurrentSpecialsSettings.breeds = {
			"skaven_gutter_runner"
		}

		local var_1_0 = CurrentSpecialsSettings.methods.specials_by_slots

		var_1_0.max_of_same = 99
		var_1_0.spawn_cooldown = {
			30,
			50
		}
		var_1_0.chance_of_coordinated_attack = 1
		var_1_0.coordinated_trickle_time = 0.66
	end
}
