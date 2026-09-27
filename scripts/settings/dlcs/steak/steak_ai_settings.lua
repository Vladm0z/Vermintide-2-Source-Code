-- chunkname: @scripts/settings/dlcs/steak/steak_ai_settings.lua

local steak = DLCSettings.steak

steak.breeds = {
	"scripts/settings/breeds/breed_beastmen_minotaur"
}
steak.behaviour_trees_precompiled = {
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_minotaur"
}
steak.behaviour_trees = {
	"scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_minotaur_behavior"
}
steak.enemy_package_loader_breed_categories = {
	bosses = {
		"beastmen_minotaur"
	}
}
steak.ai_breed_snippets_file_names = {
	"scripts/settings/dlcs/steak/steak_ai_breed_snippets"
}
steak.utility_considerations_file_names = {
	"scripts/settings/dlcs/steak/steak_utility_considerations"
}
steak.unit_extension_templates = {
	"scripts/settings/dlcs/steak/steak_unit_extension_templates"
}
steak.anim_lookup = {
	"crater_intro_1"
}
