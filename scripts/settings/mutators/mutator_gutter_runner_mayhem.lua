-- chunkname: @scripts/settings/mutators/mutator_gutter_runner_mayhem.lua

return {
	description = "description_mutator_gutter_runner_mayhem",
	icon = "mutator_icon_specials_frequency",
	display_name = "display_name_mutator_gutter_runner_mayhem",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		-- function 1
		CurrentSpecialsSettings.breeds = {
			"skaven_gutter_runner"
		}

		local specials_by_slots = CurrentSpecialsSettings.methods.specials_by_slots

		specials_by_slots.max_of_same = 99
		specials_by_slots.spawn_cooldown = {
			30,
			50
		}
		specials_by_slots.chance_of_coordinated_attack = 1
		specials_by_slots.coordinated_trickle_time = 0.66
	end
}
