-- chunkname: @levels/honduras_dlcs/morris/level_settings_morris.lua

require("levels/honduras_dlcs/morris/deus_level_settings")
require("scripts/settings/dlcs/morris/deus_journey_settings")

local tbl = {
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

for k, v in pairs(DEUS_SHRINE_LEVEL_SETTINGS) do
	local clone = table.clone(LevelSettings.dlc_morris_map)

	for k_2, v_2 in pairs(v) do
		clone[k_2] = v_2
	end

	LevelSettings[k] = clone
end

for k_3, v_3 in pairs(DEUS_LEVEL_SETTINGS) do
	for i, v_4 in ipairs(v_3.themes) do
		for i_2, v_5 in ipairs(v_3.paths) do
			local clone_2 = table.clone(v_3)
			local str = v_4 .. "_path" .. v_5
			local var_0_4
			local var_0_5

			if not v_3.overridden_level_name then
				fassert(v_3.overridden_level_key, "If a morris level settings has an overridden_level_name, it also must have a overriden_level_key")

				var_0_4 = v_3.overridden_level_key
				var_0_5 = v_3.overridden_level_name
			else
				var_0_4 = k_3 .. "_" .. str
				var_0_5 = "levels/honduras_dlcs/morris/" .. k_3 .. "/generated/" .. str .. "/world"
			end

			clone_2.level_name = var_0_5
			clone_2.theme = v_4
			clone_2.display_name = k_3 .. "_title"
			clone_2.description_text = k_3 .. "_desc"
			clone_2.level_key = var_0_4
			clone_2.level_image = "level_icon_weaves"

			local loading_ui_package_name = clone_2.loading_ui_package_name

			loading_ui_package_name = loading_ui_package_name or "morris/deus_loading_screen_1"
			clone_2.loading_ui_package_name = loading_ui_package_name
			clone_2.music_won_state = clone_2.music_won_state
			clone_2.game_mode = "deus"
			clone_2.mechanism = "deus"
			clone_2.disable_percentage_completed = true
			clone_2.act = "deus_act"
			clone_2.act_presentation_order = 1
			clone_2.act_unlock_order = 0
			clone_2.unlockable = true
			clone_2.dlc_name = "morris"
			clone_2.level_id = var_0_4
			clone_2.ommit_from_lobby_browser = true
			clone_2.allowed_locked_director_functions = {
				beastmen = true
			}
			clone_2.disable_quickplay = true

			local base_level_name = v_3.base_level_name
			local packages = clone_2.packages

			if not v_3.do_not_add_default_packages then
				packages[#packages + 1] = tbl[v_4]
				packages[#packages + 1] = string.format("resource_packages/levels/dlcs/morris/%s/%s_common", base_level_name, v_4)
				packages[#packages + 1] = string.format("resource_packages/levels/dlcs/morris/%s/%s", k_3, str)
			end

			LevelSettings[var_0_4] = clone_2
		end
	end
end

for k_4, v_6 in pairs(DeusJourneySettings) do
	local tbl_2 = {
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

	table.merge(tbl_2, v_6)

	LevelSettings[k_4] = tbl_2
end

return LevelSettings
