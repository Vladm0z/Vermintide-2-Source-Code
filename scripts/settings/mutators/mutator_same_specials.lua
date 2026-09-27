-- chunkname: @scripts/settings/mutators/mutator_same_specials.lua

return {
	description = "description_mutator_same_specials",
	icon = "mutator_icon_specials_frequency",
	display_name = "display_name_mutator_same_specials",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		-- function 1
		local specials_by_slots = CurrentSpecialsSettings.methods.specials_by_slots

		specials_by_slots.select_next_breed = "get_random_breed"
		specials_by_slots.chance_of_coordinated_attack = 1
		specials_by_slots.max_of_same = 99
		specials_by_slots.same_breeds = true
		specials_by_slots.coordinated_trickle_time = 1
		specials_by_slots.always_coordinated = true
		specials_by_slots.after_safe_zone_delay = {
			30,
			70
		}
	end
}
