-- chunkname: @scripts/settings/mutators/mutator_specials_frequency.lua

return {
	description = "description_mutator_specials_frequency",
	spawn_time_reduction_multiplier = 0.4,
	display_name = "display_name_mutator_specials_frequency",
	max_specials_multiplier = 2,
	icon = "mutator_icon_specials_frequency",
	update_conflict_settings = function(arg_1_0, arg_1_1)
		local var_1_0 = arg_1_1.template

		MutatorUtils.update_conflict_settings_specials_frequency(var_1_0.max_specials_multiplier, var_1_0.spawn_time_reduction_multiplier)
	end
}
