-- chunkname: @scripts/settings/dlcs/penny/penny_ai_settings_part_2.lua

local penny_part_2 = DLCSettings.penny_part_2

penny_part_2.breeds = {
	"scripts/settings/breeds/breed_chaos_dummy_exalted_sorcerer_drachenfels"
}
penny_part_2.behaviour_trees_precompiled = {
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_dummy_exalted_sorcerer_drachenfels"
}
penny_part_2.behaviour_trees = {
	"scripts/entity_system/systems/behaviour/trees/chaos/chaos_dummy_exalted_sorcerer_drachenfels_behavior"
}
penny_part_2.anim_lookup = {
	"float_idle_nostaff",
	"float_idle_bastion_outro"
}
