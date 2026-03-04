-- chunkname: @scripts/settings/dlcs/shovel/shovel_ai_settings.lua

local var_0_0 = DLCSettings.shovel

var_0_0.bot_conditions = {
	"scripts/settings/dlcs/shovel/shovel_bot_conditions"
}
var_0_0.breeds = {
	"scripts/settings/breeds/breed_pet_skeleton",
	"scripts/settings/breeds/breed_pet_skeleton_with_shield",
	"scripts/settings/breeds/breed_pet_skeleton_dual_wield",
	"scripts/settings/breeds/breed_pet_skeleton_armored"
}
var_0_0.behaviour_trees = {
	"scripts/entity_system/systems/behaviour/trees/pets/pet_skeleton_behavior"
}
var_0_0.behaviour_tree_nodes = {
	"scripts/entity_system/systems/behaviour/nodes/bt_transported_action",
	"scripts/entity_system/systems/behaviour/nodes/bt_charge_position_action"
}
var_0_0.behaviour_trees_precompiled = {
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_pet_skeleton",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_pet_skeleton_with_shield",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_pet_skeleton_dual_wield",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_pet_skeleton_armored"
}
var_0_0.utility_considerations_file_names = {
	"scripts/settings/dlcs/shovel/shovel_utility_considerations"
}
