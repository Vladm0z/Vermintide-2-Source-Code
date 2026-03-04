-- chunkname: @levels/honduras_dlcs/morris/level_settings_morris.lua

require("levels/honduras_dlcs/morris/deus_level_settings")
require("scripts/settings/dlcs/morris/deus_journey_settings")

local var_0_0 = {
	wastes = "resource_packages/levels/dlcs/morris/wastes_common",
	tzeentch = "resource_packages/levels/dlcs/morris/tzeentch_common",
	belakor = "resource_packages/levels/dlcs/morris/belakor_common",
	nurgle = "resource_packages/levels/dlcs/morris/nurgle_common",
	slaanesh = "resource_packages/levels/dlcs/morris/slaanesh_common",
	khorne = "resource_packages/levels/dlcs/morris/khorne_common"
}

LevelSettings.morris_hub = {
	conflict_settings = "inn_level",
	knocked_down_setting = "knocked_down",
	display_name = "morris_hub_name",
	player_aux_bus_name = "environment_reverb_outside",
	preload_no_enemies = true,
	environment_state = "exterior",
	default_surface_material = "dirt",
	level_image = "level_icon_inn_level",
	loading_ui_package_name = "morris/deus_loading_screen_1",
	skip_generate_spawns = true,
	hub_level = true,
	ambient_sound_event = "silent_default_world_sound",
	no_bots_allowed = true,
	has_multiple_loading_images = true,
	no_terror_events = true,
	mechanism = "deus",
	game_mode = "inn_deus",
	level_name = "levels/honduras_dlcs/morris/morris_hub/world",
	no_nav_mesh = false,
	source_aux_bus_name = "environment_reverb_outside_source",
	packages = {
		"resource_packages/levels/inn_dependencies",
		"resource_packages/levels/dlcs/morris/morris_hub"
	},
	level_particle_effects = {},
	level_screen_effects = {},
	locations = {},
	loot_objectives = {},
	pickup_settings = {
		{
			primary = {
				deus_potions = 3,
				ammo = 5
			}
		}
	}
}
LevelSettings.dlc_morris_map = {
	disable_percentage_completed = true,
	display_name = "deus_map",
	environment_state = "exterior",
	music_won_state = "explore",
	player_aux_bus_name = "environment_reverb_outside",
	mechanism = "deus",
	ambient_sound_event = "silent_default_world_sound",
	knocked_down_setting = "knocked_down",
	loading_bg_image = "loading_screen_1",
	loading_ui_package_name = "morris/deus_loading_screen_2",
	conflict_settings = "disabled",
	preload_no_enemies = true,
	level_image = "level_image_any",
	no_terror_events = true,
	game_mode = "map_deus",
	level_name = "levels/honduras_dlcs/morris/map_scene/world",
	no_nav_mesh = true,
	source_aux_bus_name = "environment_reverb_outside_source",
	packages = {
		"resource_packages/levels/dlcs/morris/map"
	},
	level_particle_effects = {},
	level_screen_effects = {},
	locations = {},
	override_dialogue_settings = {
		dialogue_level_start_delay = 0
	}
}

for iter_0_0, iter_0_1 in pairs(DEUS_SHRINE_LEVEL_SETTINGS) do
	local var_0_1 = table.clone(LevelSettings.dlc_morris_map)

	for iter_0_2, iter_0_3 in pairs(iter_0_1) do
		var_0_1[iter_0_2] = iter_0_3
	end

	LevelSettings[iter_0_0] = var_0_1
end

for iter_0_4, iter_0_5 in pairs(DEUS_LEVEL_SETTINGS) do
	for iter_0_6, iter_0_7 in ipairs(iter_0_5.themes) do
		for iter_0_8, iter_0_9 in ipairs(iter_0_5.paths) do
			local var_0_2 = table.clone(iter_0_5)
			local var_0_3 = iter_0_7 .. "_path" .. iter_0_9
			local var_0_4
			local var_0_5

			if iter_0_5.overridden_level_name then
				fassert(iter_0_5.overridden_level_key, "If a morris level settings has an overridden_level_name, it also must have a overriden_level_key")

				var_0_4 = iter_0_5.overridden_level_key
				var_0_5 = iter_0_5.overridden_level_name
			else
				var_0_4 = iter_0_4 .. "_" .. var_0_3
				var_0_5 = "levels/honduras_dlcs/morris/" .. iter_0_4 .. "/generated/" .. var_0_3 .. "/world"
			end

			var_0_2.level_name = var_0_5
			var_0_2.theme = iter_0_7
			var_0_2.display_name = iter_0_4 .. "_title"
			var_0_2.description_text = iter_0_4 .. "_desc"
			var_0_2.level_key = var_0_4
			var_0_2.level_image = "level_icon_weaves"
			var_0_2.loading_ui_package_name = var_0_2.loading_ui_package_name or "morris/deus_loading_screen_1"
			var_0_2.music_won_state = var_0_2.music_won_state
			var_0_2.game_mode = "deus"
			var_0_2.mechanism = "deus"
			var_0_2.disable_percentage_completed = true
			var_0_2.act = "deus_act"
			var_0_2.act_presentation_order = 1
			var_0_2.act_unlock_order = 0
			var_0_2.unlockable = true
			var_0_2.dlc_name = "morris"
			var_0_2.level_id = var_0_4
			var_0_2.ommit_from_lobby_browser = true
			var_0_2.allowed_locked_director_functions = {
				beastmen = true
			}
			var_0_2.disable_quickplay = true

			local var_0_6 = iter_0_5.base_level_name
			local var_0_7 = var_0_2.packages

			if not iter_0_5.do_not_add_default_packages then
				var_0_7[#var_0_7 + 1] = var_0_0[iter_0_7]
				var_0_7[#var_0_7 + 1] = string.format("resource_packages/levels/dlcs/morris/%s/%s_common", var_0_6, iter_0_7)
				var_0_7[#var_0_7 + 1] = string.format("resource_packages/levels/dlcs/morris/%s/%s", iter_0_4, var_0_3)
			end

			LevelSettings[var_0_4] = var_0_2
		end
	end
end

for iter_0_10, iter_0_11 in pairs(DeusJourneySettings) do
	local var_0_8 = {
		player_aux_bus_name = "environment_reverb_outside",
		ambient_sound_event = "silent_default_world_sound",
		knocked_down_setting = "knocked_down",
		disable_percentage_completed = true,
		preload_no_enemies = true,
		environment_state = "exterior",
		game_mode = "deus",
		unlockable = true,
		loading_bg_image = "loading_screen_1",
		no_terror_events = true,
		loading_ui_package_name = "morris/deus_loading_screen_1",
		conflict_settings = "disabled",
		level_name = "levels/honduras_dlcs/morris/map_scene/world",
		no_nav_mesh = true,
		source_aux_bus_name = "environment_reverb_outside_source",
		packages = {
			"resource_packages/levels/dlcs/morris/map"
		},
		level_particle_effects = {},
		level_screen_effects = {},
		locations = {}
	}

	table.merge(var_0_8, iter_0_11)

	LevelSettings[iter_0_10] = var_0_8
end

return LevelSettings
