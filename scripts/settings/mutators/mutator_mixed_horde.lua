-- chunkname: @scripts/settings/mutators/mutator_mixed_horde.lua

return {
	description = "description_mutator_mixed_horde",
	icon = "mutator_icon_specials_frequency",
	display_name = "display_name_mutator_mixed_horde",
	update_conflict_settings = function(arg_1_0, arg_1_1)
		CurrentHordeSettings.ambush_composition = "mutator_mixed_horde"
		CurrentHordeSettings.vector_composition = "mutator_mixed_horde"
		CurrentHordeSettings.vector_blob_composition = "mutator_mixed_horde"
	end
}
