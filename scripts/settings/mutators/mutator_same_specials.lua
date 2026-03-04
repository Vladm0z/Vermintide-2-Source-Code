-- chunkname: @scripts/settings/mutators/mutator_same_specials.lua

return {
	description = "description_mutator_same_specials",
	icon = "mutator_icon_specials_frequency",
	display_name = "display_name_mutator_same_specials",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		local var_1_0 = CurrentSpecialsSettings.methods.specials_by_slots

		var_1_0.select_next_breed = "get_random_breed"
		var_1_0.chance_of_coordinated_attack = 1
		var_1_0.max_of_same = 99
		var_1_0.same_breeds = true
		var_1_0.coordinated_trickle_time = 1
		var_1_0.always_coordinated = true
		var_1_0.after_safe_zone_delay = {
			30,
			70
		}
	end
}
