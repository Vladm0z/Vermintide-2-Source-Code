-- chunkname: @scripts/settings/dlcs/carousel/carousel_game_object_templates.lua

local var_0_0 = DLCSettings.carousel

var_0_0.game_object_templates = {}
var_0_0.game_object_templates.versus_dark_pact_climbing_interaction_unit = {
	game_object_created_func_name = "game_object_created_network_unit",
	syncs_position = true,
	syncs_rotation = true,
	game_object_destroyed_func_name = "game_object_destroyed_network_unit",
	is_level_unit = false
}
