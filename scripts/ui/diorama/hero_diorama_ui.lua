-- chunkname: @scripts/ui/diorama/hero_diorama_ui.lua

local var_0_0 = local_require("scripts/ui/diorama/hero_diorama_ui_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = false
local var_0_4 = 0.8

HeroDioramaUI = class(HeroDioramaUI)
HeroDioramaUI.unique_id = HeroDioramaUI.unique_id or 0

HeroDioramaUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._settings = arg_1_2
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._player_manager = arg_1_1.player_manager

	local var_1_0 = arg_1_1.world_manager:world("level_world")

	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0._instance_id = arg_1_0:_get_unique_id()
	arg_1_0._animations = {}
	arg_1_0._active = false
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements()

	arg_1_0._viewport_active = true
end

HeroDioramaUI._get_unique_id = function (arg_2_0)
	local var_2_0 = HeroDioramaUI.unique_id

	HeroDioramaUI.unique_id = var_2_0 + 1

	return var_2_0
end

HeroDioramaUI._create_ui_elements = function (arg_3_0)
	var_0_3 = false

	if arg_3_0._viewport_widget then
		arg_3_0:_unload_level_package()
		arg_3_0:_unload_diorama_package()
		UIWidget.destroy(arg_3_0._ui_renderer, arg_3_0._viewport_widget)

		arg_3_0._viewport_widget = nil
	end

	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_3_0 = {}
	local var_3_1 = {}
	local var_3_2 = var_0_0.widget_definitions

	for iter_3_0, iter_3_1 in pairs(var_3_2) do
		local var_3_3 = UIWidget.init(iter_3_1)

		var_3_1[iter_3_0] = var_3_3
		var_3_0[#var_3_0 + 1] = var_3_3
	end

	arg_3_0._widgets_by_name = var_3_1
	arg_3_0._widgets = var_3_0
	arg_3_0._viewport_widget_definition = arg_3_0:_create_viewport_definition()

	local var_3_4 = "diorama_test"
	local var_3_5 = true
	local var_3_6 = callback(arg_3_0, "_cb_diorama_package_loaded")

	Managers.package:load("resource_packages/dlcs/carousel_diorama", var_3_4, var_3_6, var_3_5)
	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_1)

	arg_3_0:update_position()
	arg_3_0:_reset_overlay()
end

HeroDioramaUI._cb_level_package_loaded = function (arg_4_0)
	arg_4_0._level_package_loaded = true
end

HeroDioramaUI._cb_diorama_package_loaded = function (arg_5_0)
	arg_5_0._diorama_package_loaded = true

	local var_5_0 = arg_5_0._viewport_widget_definition.style.viewport.level_package_name
	local var_5_1 = arg_5_0:_resource_id()
	local var_5_2 = true
	local var_5_3 = callback(arg_5_0, "_cb_level_package_loaded")

	Managers.package:load(var_5_0, var_5_1, var_5_3, var_5_2)
end

HeroDioramaUI.fade_in = function (arg_6_0, arg_6_1)
	arg_6_0._fade_in_duration = arg_6_1
	arg_6_0._fade_timer = 0
end

HeroDioramaUI.fade_out = function (arg_7_0, arg_7_1)
	arg_7_0._fade_out_duration = arg_7_1
	arg_7_0._fade_timer = 0
end

HeroDioramaUI._fade_out_overlay = function (arg_8_0)
	arg_8_0._overlay_fade_out_time = 0
end

HeroDioramaUI._reset_overlay = function (arg_9_0)
	arg_9_0._widgets_by_name.overlay.alpha_multiplier = 1
	arg_9_0._overlay_fade_out_time = nil
	arg_9_0._destroy_previewer_on_fade_out = true
end

HeroDioramaUI._update_overlay_fade_out_animation = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._overlay_fade_out_time

	if not var_10_0 then
		return
	end

	local var_10_1 = var_10_0 + arg_10_1
	local var_10_2 = math.min(var_10_1 / var_0_4, 1)

	arg_10_0._widgets_by_name.overlay.alpha_multiplier = 1 - var_10_2

	if var_10_2 == 1 then
		arg_10_0._overlay_fade_out_time = nil
	else
		arg_10_0._overlay_fade_out_time = var_10_1
	end
end

HeroDioramaUI._update_fade_animations = function (arg_11_0, arg_11_1)
	arg_11_0:_update_fade_in_animation(arg_11_1)
	arg_11_0:_update_fade_out_animation(arg_11_1)
	arg_11_0:_update_overlay_fade_out_animation(arg_11_1)
end

HeroDioramaUI._update_fade_in_animation = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._fade_timer
	local var_12_1 = arg_12_0._fade_in_duration

	if not var_12_0 or not var_12_1 then
		return
	end

	local var_12_2 = var_12_0 + arg_12_1
	local var_12_3 = math.min(var_12_2 / var_12_1, 1)

	arg_12_0._render_settings.alpha_multiplier = var_12_3

	if var_12_3 == 1 then
		arg_12_0._fade_in_duration = nil
		arg_12_0._fade_timer = nil
	else
		arg_12_0._fade_timer = var_12_2
	end
end

HeroDioramaUI._update_fade_out_animation = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._fade_timer
	local var_13_1 = arg_13_0._fade_out_duration

	if not var_13_0 or not var_13_1 then
		return
	end

	local var_13_2 = var_13_0 + arg_13_1
	local var_13_3 = math.min(var_13_2 / var_13_1, 1)

	arg_13_0._render_settings.alpha_multiplier = 1 - var_13_3

	if var_13_3 == 1 then
		arg_13_0._fade_out_duration = nil
		arg_13_0._fade_timer = nil
	else
		arg_13_0._fade_timer = var_13_2
	end
end

HeroDioramaUI.set_viewport_active = function (arg_14_0, arg_14_1)
	arg_14_0._viewport_active = arg_14_1
end

HeroDioramaUI._update_viewport_active_state = function (arg_15_0)
	local var_15_0 = arg_15_0._viewport_active

	if arg_15_0._synced_viewport_active_state ~= var_15_0 then
		local var_15_1 = arg_15_0._viewport_widget
		local var_15_2 = var_15_1.style.viewport
		local var_15_3 = var_15_2.viewport_name
		local var_15_4 = var_15_2.world_name
		local var_15_5 = var_15_1.element.pass_data[1]
		local var_15_6 = var_15_5.world
		local var_15_7 = var_15_5.viewport

		if var_15_0 then
			if arg_15_0._synced_viewport_active_state == false then
				ScriptWorld.activate_viewport(var_15_6, var_15_7)
			end

			arg_15_0:_fade_out_overlay()
		else
			ScriptWorld.deactivate_viewport(var_15_6, var_15_7)
			arg_15_0:_reset_overlay()
		end

		arg_15_0._synced_viewport_active_state = var_15_0
	end
end

HeroDioramaUI._create_viewport_definition = function (arg_16_0)
	local var_16_0 = "environment/ui_store_preview"
	local var_16_1 = arg_16_0._instance_id
	local var_16_2 = {
		"fire_01/tier_01",
		"fire_01/tier_02",
		"fire_01/tier_03",
		"forest_01/tier_01",
		"forest_01/tier_02",
		"forest_01/tier_03",
		"snow_01/tier_01",
		"snow_01/tier_02",
		"snow_01/tier_03"
	}
	local var_16_3 = table.random(var_16_2)

	return {
		scenegraph_id = "viewport",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 800,
				viewport_type = "default_offscreen",
				enable_sub_gui = false,
				fov = 30,
				shading_environment = var_16_0,
				world_name = "diorama_preview_" .. tostring(var_16_1),
				viewport_name = "diorama_preview_viewport_" .. tostring(var_16_1),
				level_name = string.format("levels/diorama/%s/world", var_16_3),
				level_package_name = string.format("resource_packages/levels/dlcs/carousel/diorama/%s", var_16_3),
				world_flags = {
					Application.DISABLE_SOUND,
					Application.DISABLE_ESRAM
				},
				camera_position = {
					0,
					0,
					0
				},
				camera_lookat = {
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		}
	}
end

HeroDioramaUI._set_size = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ui_scenegraph
	local var_17_1 = var_17_0.background
	local var_17_2 = var_17_0.viewport
	local var_17_3 = var_17_0.hero_text_box
	local var_17_4 = var_17_0.player_text_box
	local var_17_5 = var_17_0.bottom_panel
	local var_17_6 = var_17_0.bottom_panel_edge.size
	local var_17_7 = var_17_5.size
	local var_17_8 = var_17_3.size
	local var_17_9 = var_17_4.size
	local var_17_10 = var_17_1.size
	local var_17_11 = var_17_2.size

	var_17_10[1] = math.max(arg_17_1 and arg_17_1[1] or 500, 1)
	var_17_10[2] = math.max(arg_17_1 and arg_17_1[2] or 500, 1)
	var_17_11[1] = math.max(arg_17_1 and arg_17_1[1] or 500, 1)
	var_17_11[2] = math.max((arg_17_1 and arg_17_1[2] or 500) - var_17_7[2], 1)
	var_17_7[1] = math.max(arg_17_1 and arg_17_1[1] or 500, 1)
	var_17_6[1] = math.max(arg_17_1 and arg_17_1[1] or 500, 1)
	var_17_8[1] = math.max((arg_17_1 and arg_17_1[1] or 500) - var_17_7[2] * 2, 1)
	var_17_9[1] = math.max((arg_17_1 and arg_17_1[1] or 500) - var_17_7[2], 1)

	arg_17_0:_update_panel_background()
end

HeroDioramaUI._update_panel_background = function (arg_18_0, arg_18_1)
	local var_18_0 = var_0_0.create_panel_background
	local var_18_1 = "bottom_panel"
	local var_18_2 = arg_18_0._ui_scenegraph[var_18_1].size
	local var_18_3 = "talent_tree_bg_01"
	local var_18_4 = arg_18_1 or {
		255,
		255,
		255,
		255
	}
	local var_18_5 = var_18_0(var_18_1, var_18_2, var_18_3, var_18_4)

	arg_18_0._bottom_panel_widget = UIWidget.init(var_18_5)
end

HeroDioramaUI.update_position = function (arg_19_0)
	local var_19_0 = arg_19_0._settings

	if var_19_0 then
		local var_19_1 = var_19_0.size

		arg_19_0:_set_size(var_19_1)

		local var_19_2 = var_19_0.position
		local var_19_3 = var_19_0.vertical_alignment
		local var_19_4 = var_19_0.horizontal_alignment

		arg_19_0:_set_position(var_19_2, var_19_4, var_19_3)
	end
end

HeroDioramaUI._set_position = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0._ui_scenegraph.background
	local var_20_1 = var_20_0.position

	var_20_1[1] = arg_20_1 and arg_20_1[1] or 0
	var_20_1[2] = arg_20_1 and arg_20_1[2] or 0
	var_20_1[3] = arg_20_1 and arg_20_1[3] or 0
	var_20_0.vertical_alignment = arg_20_3 or "center"
	var_20_0.horizontal_alignment = arg_20_2 or "center"
end

HeroDioramaUI.destroy = function (arg_21_0)
	arg_21_0:_destroy_previewers()

	if arg_21_0._viewport_widget then
		UIWidget.destroy(arg_21_0._ui_renderer, arg_21_0._viewport_widget)

		arg_21_0._viewport_widget = nil
	end

	arg_21_0:_unload_level_package()
	arg_21_0:_unload_diorama_package()

	arg_21_0._ui_animator = nil
end

HeroDioramaUI._resource_id = function (arg_22_0)
	return "HeroDioramaUI_" .. arg_22_0._instance_id
end

HeroDioramaUI._can_create_viewport = function (arg_23_0)
	if arg_23_0._viewport_widget then
		return false
	end

	return arg_23_0._level_package_loaded and arg_23_0._cb_diorama_package_loaded
end

HeroDioramaUI.set_hero_profile = function (arg_24_0, arg_24_1, arg_24_2)
	if arg_24_0._viewport_widget then
		arg_24_0._cashed_profile_data = nil

		arg_24_0:_set_hero_profile(arg_24_1, arg_24_2)
	else
		arg_24_0._cashed_profile_data = {
			profile_index = arg_24_1,
			career_index = arg_24_2
		}
	end
end

HeroDioramaUI._set_hero_profile = function (arg_25_0, arg_25_1, arg_25_2)
	arg_25_0:_setup_character_previewer(arg_25_1, arg_25_2)

	local var_25_0 = SPProfiles[arg_25_1].display_name
	local var_25_1 = ExperienceSettings.get_versus_experience()
	local var_25_2 = ExperienceSettings.get_versus_level_from_experience(var_25_1) or ""
	local var_25_3 = arg_25_0:_get_portrait_frame(arg_25_1, arg_25_2)
	local var_25_4 = arg_25_2 and UIUtils.get_portrait_image_by_profile_index(arg_25_1, arg_25_2) or "unit_frame_portrait_default"

	arg_25_0:_set_portrait_frame(var_25_3, var_25_2, var_25_4)
	arg_25_0:_set_career_name(arg_25_1, arg_25_2)

	local var_25_5 = SPProfiles[arg_25_1].careers[arg_25_2].name
	local var_25_6 = Colors.get_color_table_with_alpha(var_25_5, 255) or Colors.color_definitions.white

	arg_25_0:_update_panel_background(var_25_6)
end

HeroDioramaUI.post_update = function (arg_26_0, arg_26_1, arg_26_2)
	if var_0_3 then
		arg_26_0:_destroy_previewers()
		arg_26_0:_create_ui_elements()
	end

	if arg_26_0:_can_create_viewport() then
		arg_26_0._viewport_widget = UIWidget.init(arg_26_0._viewport_widget_definition)

		local var_26_0 = arg_26_0._cashed_profile_data

		if var_26_0 then
			local var_26_1 = var_26_0.profile_index
			local var_26_2 = var_26_0.career_index

			arg_26_0._cashed_profile_data = nil

			arg_26_0:_set_hero_profile(var_26_1, var_26_2)
		end
	end

	if arg_26_0._viewport_widget then
		arg_26_0:_update_viewport_active_state()
	end

	if arg_26_0._world_previewer then
		arg_26_0._world_previewer:post_update(arg_26_1, arg_26_2)
	end

	if RESOLUTION_LOOKUP.modified then
		arg_26_0:update_position()
	end
end

HeroDioramaUI.update = function (arg_27_0, arg_27_1, arg_27_2)
	if arg_27_0._world_previewer and not var_0_3 then
		local var_27_0 = true

		arg_27_0._world_previewer:update(arg_27_1, arg_27_2, var_27_0)
	end

	arg_27_0:_update_animations(arg_27_1, arg_27_2)
	arg_27_0:_draw(arg_27_1)
end

HeroDioramaUI._update_animations = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0._animations
	local var_28_1 = arg_28_0._ui_animator

	var_28_1:update(arg_28_1)

	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		if var_28_1:is_animation_completed(iter_28_1) then
			var_28_1:stop_animation(iter_28_1)

			var_28_0[iter_28_0] = nil
		end
	end

	arg_28_0:_update_fade_animations(arg_28_1)
end

HeroDioramaUI._draw = function (arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._ui_renderer
	local var_29_1 = arg_29_0._ui_top_renderer
	local var_29_2 = arg_29_0._ui_scenegraph
	local var_29_3 = arg_29_0._input_manager:get_service("ingame_menu")
	local var_29_4 = arg_29_0._render_settings
	local var_29_5 = var_29_4.alpha_multiplier or 1

	UIRenderer.begin_pass(var_29_0, var_29_2, var_29_3, arg_29_1, nil, var_29_4)

	local var_29_6 = arg_29_0._viewport_widget

	if var_29_6 then
		var_29_4.alpha_multiplier = math.min(var_29_6.alpha_multiplier or var_29_5, var_29_5)

		UIRenderer.draw_widget(var_29_0, var_29_6)
	end

	UIRenderer.end_pass(var_29_0)
	UIRenderer.begin_pass(var_29_1, var_29_2, var_29_3, arg_29_1, nil, var_29_4)

	local var_29_7 = arg_29_0._widgets

	if var_29_7 then
		for iter_29_0 = 1, #var_29_7 do
			local var_29_8 = var_29_7[iter_29_0]

			var_29_4.alpha_multiplier = math.min(var_29_8.alpha_multiplier or var_29_5, var_29_5)

			UIRenderer.draw_widget(var_29_1, var_29_8)
		end
	end

	local var_29_9 = arg_29_0._portrait_widget

	if var_29_9 then
		var_29_4.alpha_multiplier = math.min(var_29_9.alpha_multiplier or var_29_5, var_29_5)

		UIRenderer.draw_widget(var_29_1, var_29_9)
	end

	local var_29_10 = arg_29_0._bottom_panel_widget

	if var_29_10 then
		var_29_4.alpha_multiplier = math.min(var_29_10.alpha_multiplier or var_29_5, var_29_5)

		UIRenderer.draw_widget(var_29_1, var_29_10)
	end

	UIRenderer.end_pass(var_29_1)

	var_29_4.alpha_multiplier = var_29_5
end

HeroDioramaUI._unload_level_package = function (arg_30_0)
	local var_30_0 = arg_30_0:_resource_id()
	local var_30_1 = arg_30_0._viewport_widget_definition.style.viewport.level_package_name

	Managers.package:unload(var_30_1, var_30_0)

	arg_30_0._level_package_loaded = false
end

HeroDioramaUI._unload_diorama_package = function (arg_31_0)
	Managers.package:unload("resource_packages/dlcs/carousel_diorama", "diorama_test")

	arg_31_0._diorama_package_loaded = false
end

HeroDioramaUI._destroy_previewers = function (arg_32_0)
	local var_32_0 = arg_32_0._world_previewer

	if var_32_0 then
		var_32_0:prepare_exit()
		var_32_0:on_exit()
		var_32_0:destroy()

		arg_32_0._world_previewer = nil
	end
end

local var_0_5 = {
	default = {
		z = 0.4,
		x = 0,
		y = 0
	}
}

HeroDioramaUI._setup_character_previewer = function (arg_33_0, arg_33_1, arg_33_2)
	arg_33_0:_destroy_previewers()

	local var_33_0 = arg_33_0._viewport_widget
	local var_33_1 = MenuWorldPreviewer:new(arg_33_0._ingame_ui_context, var_0_5)

	var_33_1:on_enter(var_33_0)
	var_33_1:set_camera_axis_offset("y", 3.5, 0.01, math.easeOutCubic)

	arg_33_0._world_previewer = var_33_1

	local var_33_2 = SPProfiles[arg_33_1]
	local var_33_3 = var_33_2.display_name
	local var_33_4 = var_33_2.careers[arg_33_2].name
	local var_33_5 = CareerSettings[var_33_4].base_skin
	local var_33_6
	local var_33_7 = callback(arg_33_0, "cb_hero_unit_spawned_preview", var_33_1, var_33_3, arg_33_2)

	var_33_1:request_spawn_hero_unit(var_33_3, arg_33_2, false, var_33_7, 1, nil, var_33_6)

	local var_33_8 = {
		"units/diorama/podium/diorama_banner_flag_01",
		"units/diorama/podium/diorama_banner_flag_02"
	}
	local var_33_9 = callback(arg_33_0, "cb_flag_spawned", var_33_1)

	var_33_1:request_spawn_unit(table.random(var_33_8), "flag", var_33_9)

	local var_33_10 = {
		"units/diorama/podium/diorama_banner_pole_01",
		"units/diorama/podium/diorama_banner_pole_02"
	}
	local var_33_11 = callback(arg_33_0, "cb_pole_spawned", var_33_1)

	var_33_1:request_spawn_unit(table.random(var_33_10), "pole", var_33_11)

	local var_33_12 = {
		"units/diorama/podium/diorama_podium_rock_01",
		"units/diorama/podium/diorama_podium_stone_01",
		"units/diorama/podium/diorama_podium_dwarf_01",
		"units/diorama/podium/diorama_podium_pile_of_skulls_01"
	}
	local var_33_13 = callback(arg_33_0, "cb_podium_spawned", var_33_1)

	var_33_1:request_spawn_unit(table.random(var_33_12), "podium", var_33_13)
	arg_33_0:_reset_overlay()
end

HeroDioramaUI.cb_hero_unit_spawned_preview = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	arg_34_1:set_hero_location({
		0,
		0,
		0.43
	})

	local var_34_0 = FindProfileIndex(arg_34_2)
	local var_34_1 = SPProfiles[var_34_0].careers[arg_34_3]
	local var_34_2 = "store_idle"
	local var_34_3 = var_34_1.preview_items

	if var_34_3 then
		for iter_34_0, iter_34_1 in ipairs(var_34_3) do
			local var_34_4 = iter_34_1.item_name
			local var_34_5 = ItemMasterList[var_34_4].slot_type
			local var_34_6 = InventorySettings.slot_names_by_type[var_34_5][1]
			local var_34_7 = InventorySettings.slots_by_name[var_34_6]

			if var_34_5 == "melee" or var_34_5 == "ranged" then
				arg_34_1:wield_weapon_slot(var_34_5)
			end

			arg_34_1:equip_item(var_34_4, var_34_7)
		end
	end

	if var_34_2 then
		-- Nothing
	end

	if arg_34_0._viewport_active then
		arg_34_0:_fade_out_overlay()
	end
end

HeroDioramaUI.cb_flag_spawned = function (arg_35_0, arg_35_1, arg_35_2)
	arg_35_1:set_unit_location(arg_35_2, {
		0,
		-1.5,
		0
	})
end

HeroDioramaUI.cb_pole_spawned = function (arg_36_0, arg_36_1, arg_36_2)
	arg_36_1:set_unit_location(arg_36_2, {
		0,
		-1.5,
		0
	})
end

HeroDioramaUI.cb_podium_spawned = function (arg_37_0, arg_37_1, arg_37_2)
	arg_37_1:set_unit_location(arg_37_2, {
		0,
		0,
		0
	})
end

HeroDioramaUI._set_career_name = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = SPProfiles[arg_38_1].careers[arg_38_2].display_name

	arg_38_0._widgets_by_name.career_name.content.text = Localize(var_38_0)
end

HeroDioramaUI._set_hero_name = function (arg_39_0, arg_39_1)
	local var_39_0 = SPProfiles[arg_39_1].ingame_short_display_name

	arg_39_0._widgets_by_name.hero_name.content.text = Localize(var_39_0)
end

HeroDioramaUI.set_player_name = function (arg_40_0, arg_40_1)
	arg_40_0._widgets_by_name.player_name.content.text = arg_40_1
end

HeroDioramaUI._set_portrait_frame = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	local var_41_0 = arg_41_4 or 1
	local var_41_1 = false
	local var_41_2 = UIWidgets.create_portrait_frame("portrait_pivot", arg_41_1, arg_41_2, var_41_0, var_41_1, arg_41_3)
	local var_41_3 = UIWidget.init(var_41_2, arg_41_0._ui_renderer)
	local var_41_4 = var_41_3.content

	var_41_4.frame_settings_name = arg_41_1
	var_41_4.level_text = arg_41_2
	arg_41_0._portrait_widget = var_41_3
end

HeroDioramaUI._get_portrait_frame = function (arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = SPProfiles[arg_42_1].careers[arg_42_2].name
	local var_42_1 = "default"
	local var_42_2 = BackendUtils.get_loadout_item(var_42_0, "slot_frame")

	var_42_1 = var_42_2 and var_42_2.data.temporary_template or var_42_1

	return var_42_1
end
