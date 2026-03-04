-- chunkname: @scripts/settings/dlcs/steak/steak_ai_settings.lua

local var_0_0 = DLCSettings.steak

var_0_0.breeds = {
	"scripts/settings/breeds/breed_beastmen_minotaur"
}
var_0_0.behaviour_trees_precompiled = {
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_minotaur"
}
var_0_0.behaviour_trees = {
	"scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_minotaur_behavior"
}
var_0_0.enemy_package_loader_breed_categories = {
	bosses = {
		"beastmen_minotaur"
	}
}
var_0_0.ai_breed_snippets_file_names = {
	"scripts/settings/dlcs/steak/steak_ai_breed_snippets"
}
var_0_0.utility_considerations_file_names = {
	"scripts/settings/dlcs/steak/steak_utility_considerations"
}
var_0_0.unit_extension_templates = {
	"scripts/settings/dlcs/steak/steak_unit_extension_templates"
}
var_0_0.anim_lookup = {
	"crater_intro_1"
}
