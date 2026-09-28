-- chunkname: @scripts/settings/mutators/mutator_big_specials.lua

return {
	description = "description_mutator_big_specials",
	icon = "mutator_icon_powerful_elites",
	display_name = "display_name_mutator_big_specials",
	update_conflict_settings = function (context, data)
		-- function 1
		local method = CurrentSpecialsSettings.methods.specials_by_slots

		method.select_next_breed = "get_chance_of_boss_breed"
	end
}
