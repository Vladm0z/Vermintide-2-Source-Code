-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_gotwf_item_preview.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_item_preview_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.top_widgets
local var_0_3 = var_0_0.loading_widgets
local var_0_4 = var_0_0.create_claimed_widget
local var_0_5 = var_0_0.create_painting_widget
local var_0_6 = var_0_0.create_texture_widget
local var_0_7 = var_0_0.animation_definitions
local var_0_8 = 10
local var_0_9 = 800
local var_0_10 = 140
local var_0_11 = "gui/1080p/single_textures/generic/transparent_placeholder_texture"

HeroWindowGotwfItemPreview = class(HeroWindowGotwfItemPreview)
HeroWindowGotwfItemPreview.NAME = "HeroWindowGotwfItemPreview"

function HeroWindowGotwfItemPreview.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowGotwfItemPreview")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0

	local var_1_1, var_1_2 = arg_1_0._parent:get_renderers()

	arg_1_0._ui_renderer = var_1_1
	arg_1_0._ui_top_renderer = var_1_2
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._is_in_inn = var_1_0.is_in_inn
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._loaded_package_names = {}
	arg_1_0._cloned_materials_by_reference = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_start_transition_animation("on_enter")
end

function HeroWindowGotwfItemPreview._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = arg_2_0._top_widgets_by_name
	local var_2_2 = arg_2_0._animations[arg_2_1]

	if var_2_2 then
		arg_2_0._ui_animator:stop_animation(var_2_2)

		arg_2_0._animations[arg_2_1] = nil
	end

	local var_2_3 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_3
end

function HeroWindowGotwfItemPreview._create_viewport_definition(arg_3_0)
	local var_3_0 = "environment/ui_store_preview"

	return {
		scenegraph_id = "viewport",
		element = UIElements.Viewport,
		style = {
			viewport = {
				viewport_type = "default_forward",
				layer = 990,
				viewport_name = "item_preview_viewport",
				world_name = "item_preview",
				horizontal_alignment = "center",
				vertical_alignment = "center",
				level_name = "levels/ui_store_preview/world",
				enable_sub_gui = false,
				fov = 65,
				shading_environment = var_3_0,
				object_sets = LevelResource.object_set_names("levels/ui_store_preview/world"),
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
				viewport_size = {
					600,
					500
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

function HeroWindowGotwfItemPreview._create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._viewport_widget then
		UIWidget.destroy(arg_4_0._ui_renderer, arg_4_0._viewport_widget)

		arg_4_0._viewport_widget = nil
	end

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_2) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._top_widgets = var_4_0
	arg_4_0._top_widgets_by_name = var_4_1

	local var_4_3 = var_0_4(arg_4_0._ui_renderer)
	local var_4_4 = UIWidget.init(var_4_3)

	arg_4_0._top_widgets[#arg_4_0._top_widgets + 1] = var_4_4
	arg_4_0._top_widgets_by_name.claimed = var_4_4

	local var_4_5 = {}
	local var_4_6 = {}

	for iter_4_2, iter_4_3 in pairs(var_0_3) do
		local var_4_7 = UIWidget.init(iter_4_3)

		var_4_5[#var_4_5 + 1] = var_4_7
		var_4_6[iter_4_2] = var_4_7
	end

	arg_4_0._loading_widgets = var_4_5
	arg_4_0._loading_widgets_by_name = var_4_6

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)

	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_7)

	if arg_4_2 then
		local var_4_8 = arg_4_0._ui_scenegraph.window.local_position

		var_4_8[1] = var_4_8[1] + arg_4_2[1]
		var_4_8[2] = var_4_8[2] + arg_4_2[2]
		var_4_8[3] = var_4_8[3] + arg_4_2[3]
	end

	arg_4_0._viewport_widget_definition = arg_4_0:_create_viewport_definition()
end

function HeroWindowGotwfItemPreview.on_exit(arg_5_0, arg_5_1, arg_5_2)
	print("[HeroViewWindow] Exit Substate HeroWindowGotwfItemPreview")

	arg_5_0._ui_animator = nil
	arg_5_0._has_exited = true

	arg_5_0:_destroy_previewers()
	arg_5_0:_destroy_viewport_gui()

	if arg_5_0._viewport_widget then
		UIWidget.destroy(arg_5_0._ui_renderer, arg_5_0._viewport_widget)

		arg_5_0._viewport_widget = nil
	end

	local var_5_0 = arg_5_0._loaded_package_names

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		arg_5_0:_unload_texture_by_reference(iter_5_0)
	end
end

function HeroWindowGotwfItemPreview.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_sync_layout_path()
	arg_6_0:_update_previewers(arg_6_1, arg_6_2)
end

function HeroWindowGotwfItemPreview._update_previewers(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0._selected_product then
		local var_7_0 = arg_7_0._parent:window_input_service()
		local var_7_1 = false
		local var_7_2 = false

		if arg_7_0._world_previewer then
			local var_7_3 = arg_7_0._parent:input_blocked()

			arg_7_0._world_previewer:update(arg_7_1, arg_7_2, var_7_3)
		end

		if arg_7_0._item_previewer then
			local var_7_4 = arg_7_0._top_widgets_by_name.viewport_button
			local var_7_5 = UIUtils.is_button_hover(var_7_4)
			local var_7_6 = Managers.input:is_device_active("gamepad")
			local var_7_7 = not var_7_1 and not var_7_2 and (var_7_6 or var_7_5)

			arg_7_0._item_previewer:update(arg_7_1, arg_7_2, var_7_7 and var_7_0)
		end
	end
end

function HeroWindowGotwfItemPreview._register_object_sets(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2.style.viewport
	local var_8_1 = arg_8_1.style
	local var_8_2 = arg_8_1.content
	local var_8_3 = arg_8_1.element.pass_data[1]
	local var_8_4 = var_8_0.level_name
	local var_8_5 = {}
	local var_8_6 = LevelResource.object_set_names(var_8_4)

	for iter_8_0, iter_8_1 in ipairs(var_8_6) do
		var_8_5[iter_8_1] = {
			set_enabled = true,
			units = LevelResource.unit_indices_in_object_set(var_8_4, iter_8_1)
		}
	end

	var_8_2.object_set_data = {
		world = var_8_3.world,
		level = var_8_3.level,
		object_sets = var_8_5,
		level_name = var_8_4
	}

	arg_8_0:_show_object_set(nil, true)
end

function HeroWindowGotwfItemPreview._show_object_set(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0._viewport_widget then
		print("[HeroWindowGotwfItemPreview:show_object_set] Viewport not initiated")

		return
	end

	local var_9_0 = arg_9_0._viewport_widget.content.object_set_data
	local var_9_1 = var_9_0.world
	local var_9_2 = var_9_0.level
	local var_9_3 = var_9_0.level_name
	local var_9_4 = var_9_0.object_sets

	if not var_9_4[arg_9_1] and not arg_9_2 then
		print(string.format("[HeroWindowGotwfItemPreview:show_object_set] No object set called %q in level %q", arg_9_1, var_9_3))

		return
	end

	for iter_9_0, iter_9_1 in pairs(var_9_4) do
		local var_9_5 = iter_9_1.set_enabled

		if var_9_5 and iter_9_0 ~= arg_9_1 then
			local var_9_6 = iter_9_1.units

			for iter_9_2, iter_9_3 in ipairs(var_9_6) do
				local var_9_7 = Level.unit_by_index(var_9_2, iter_9_3)

				Unit.set_unit_visibility(var_9_7, false)
			end

			iter_9_1.set_enabled = false
		elseif not var_9_5 and iter_9_0 == arg_9_1 then
			local var_9_8 = iter_9_1.units

			for iter_9_4, iter_9_5 in ipairs(var_9_8) do
				local var_9_9 = Level.unit_by_index(var_9_2, iter_9_5)

				Unit.set_unit_visibility(var_9_9, true)

				if Unit.has_data(var_9_9, "LevelEditor", "is_gizmo_unit") then
					local var_9_10 = Unit.get_data(var_9_9, "LevelEditor", "is_gizmo_unit")
					local var_9_11 = Unit.is_a(var_9_9, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe")

					if var_9_10 and not var_9_11 then
						Unit.flow_event(var_9_9, "hide_helper_mesh")
					end
				end
			end

			iter_9_1.set_enabled = true
		end
	end

	print("Showing object set:", arg_9_1)
end

function HeroWindowGotwfItemPreview._update_environment(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._viewport_widget then
		return
	end

	local var_10_0 = arg_10_1 or "default"
	local var_10_1 = arg_10_0._viewport_widget.content.object_set_data.world

	World.get_data(var_10_1, "shading_settings")[1] = arg_10_2 and "default" or var_10_0
end

function HeroWindowGotwfItemPreview._destroy_viewport_gui(arg_11_0)
	if arg_11_0._viewport_gui then
		local var_11_0 = Managers.world:world("item_preview")

		World.destroy_gui(var_11_0, arg_11_0._viewport_gui)

		arg_11_0._viewport_gui = nil
	end
end

function HeroWindowGotwfItemPreview._create_viewport_gui(arg_12_0)
	local var_12_0 = Managers.world:world("item_preview")
	local var_12_1 = false
	local var_12_2 = arg_12_0._is_in_inn
	local var_12_3 = Managers.mechanism:current_mechanism_name()

	arg_12_0._viewport_gui = World.create_screen_gui(var_12_0, "immediate", "material", "materials/ui/ui_1080p_lock_test")

	local var_12_4, var_12_5 = Gui.resolution()

	arg_12_0._gui_resolution = {
		var_12_4,
		var_12_5
	}
end

function HeroWindowGotwfItemPreview.post_update(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0._viewport_widget_definition and not arg_13_0._viewport_widget then
		arg_13_0._viewport_widget = UIWidget.init(arg_13_0._viewport_widget_definition)

		arg_13_0:_register_object_sets(arg_13_0._viewport_widget, arg_13_0._viewport_widget_definition)
	end

	arg_13_0:_update_loading_overlay_fadeout_animation(arg_13_1)
	arg_13_0:_update_delayed_item_unit_presentation(arg_13_1)

	if arg_13_0._viewport_widget then
		arg_13_0:_sync_presentation_item()
	end

	if arg_13_0._world_previewer then
		arg_13_0._world_previewer:post_update(arg_13_1, arg_13_2)
	end

	if arg_13_0._item_previewer then
		arg_13_0._item_previewer:post_update(arg_13_1, arg_13_2)
	end

	if arg_13_0._selected_product then
		arg_13_0:draw(arg_13_1)
	end
end

function HeroWindowGotwfItemPreview._update_animations(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._ui_animations
	local var_14_1 = arg_14_0._animations
	local var_14_2 = arg_14_0._ui_animator

	for iter_14_0, iter_14_1 in pairs(arg_14_0._ui_animations) do
		UIAnimation.update(iter_14_1, arg_14_1)

		if UIAnimation.completed(iter_14_1) then
			arg_14_0._ui_animations[iter_14_0] = nil
		end
	end

	var_14_2:update(arg_14_1)

	for iter_14_2, iter_14_3 in pairs(var_14_1) do
		if var_14_2:is_animation_completed(iter_14_3) then
			var_14_2:stop_animation(iter_14_3)

			var_14_1[iter_14_2] = nil
		end
	end

	arg_14_0:_update_title_edge_animation(arg_14_1)
end

function HeroWindowGotwfItemPreview._exit(arg_15_0)
	arg_15_0.exit = true
end

function HeroWindowGotwfItemPreview._get_alpha_multiplier(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._render_settings
	local var_16_1 = arg_16_1.alpha_multiplier

	if var_16_1 then
		return math.min(var_16_1, arg_16_2)
	end

	return arg_16_2
end

function HeroWindowGotwfItemPreview.draw(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ui_renderer
	local var_17_1 = arg_17_0._ui_top_renderer
	local var_17_2 = arg_17_0._ui_scenegraph
	local var_17_3 = arg_17_0._parent:window_input_service()
	local var_17_4 = arg_17_0._render_settings
	local var_17_5 = var_17_4.alpha_multiplier

	UIRenderer.begin_pass(var_17_1, var_17_2, var_17_3, arg_17_1, nil, var_17_4)

	for iter_17_0, iter_17_1 in ipairs(arg_17_0._top_widgets) do
		var_17_4.alpha_multiplier = arg_17_0:_get_alpha_multiplier(iter_17_1, var_17_5)

		UIRenderer.draw_widget(var_17_1, iter_17_1)
	end

	if arg_17_0._item_texture_widget then
		var_17_4.alpha_multiplier = arg_17_0:_get_alpha_multiplier(arg_17_0._item_texture_widget, var_17_5)

		UIRenderer.draw_widget(var_17_1, arg_17_0._item_texture_widget)
	end

	if arg_17_0._show_loading_overlay then
		for iter_17_2, iter_17_3 in ipairs(arg_17_0._loading_widgets) do
			var_17_4.alpha_multiplier = arg_17_0:_get_alpha_multiplier(iter_17_3, var_17_5)

			UIRenderer.draw_widget(var_17_1, iter_17_3)
		end
	end

	UIRenderer.end_pass(var_17_1)

	if arg_17_0._viewport_widget then
		UIRenderer.begin_pass(var_17_0, var_17_2, var_17_3, arg_17_1, nil, var_17_4)
		UIRenderer.draw_widget(var_17_0, arg_17_0._viewport_widget)
		UIRenderer.end_pass(var_17_0)
		arg_17_0:_render_viewport_mask()
	end

	var_17_4.alpha_multiplier = var_17_5
end

local var_0_12 = {}

function HeroWindowGotwfItemPreview._render_viewport_mask(arg_18_0)
	local var_18_0, var_18_1 = Application.resolution()
	local var_18_2 = arg_18_0._gui_resolution or var_0_12

	if not arg_18_0._viewport_gui or var_18_2[1] ~= var_18_0 or var_18_2[2] ~= var_18_1 then
		arg_18_0:_destroy_viewport_gui()
		arg_18_0:_create_viewport_gui()
	end

	local var_18_3 = arg_18_0._viewport_gui
	local var_18_4 = arg_18_0._viewport_widget.content
	local var_18_5 = var_18_4.viewport_size_y
	local var_18_6 = var_18_4.viewport_size_y
	local var_18_7 = var_18_5 * var_18_0 * 0.285
	local var_18_8 = var_18_6 * var_18_1 * 0.26

	Gui.bitmap(var_18_3, "gui_lock_test_viewport_mask", Vector3(0, 0, 2), Vector2(var_18_7, var_18_8))
	Gui.bitmap(var_18_3, "gui_lock_test_viewport_mask", Vector3(var_18_0 * var_18_5 - var_18_7, 0, 2), Vector2(var_18_7, var_18_8))

	local var_18_9 = var_18_7
	local var_18_10 = var_18_6 * var_18_1 * 0.2

	Gui.bitmap(var_18_3, "gui_lock_test_viewport_mask", Vector3(0, var_18_1 * var_18_6 - var_18_10, 2), Vector2(var_18_9, var_18_10))
	Gui.bitmap(var_18_3, "gui_lock_test_viewport_mask", Vector3(var_18_0 * var_18_5 - var_18_9, var_18_1 * var_18_6 - var_18_10, 2), Vector2(var_18_9, var_18_10))

	local var_18_11 = var_18_5 * var_18_0 * 0.09
	local var_18_12 = var_18_6 * var_18_1

	Gui.bitmap(var_18_3, "gui_lock_test_viewport_mask", Vector3(0, 0, 2), Vector2(var_18_11, var_18_12))
	Gui.bitmap(var_18_3, "gui_lock_test_viewport_mask", Vector3(var_18_0 * var_18_5 - var_18_11, 0, 2), Vector2(var_18_11, var_18_12))
end

function HeroWindowGotwfItemPreview._play_sound(arg_19_0, arg_19_1)
	arg_19_0._parent:play_sound(arg_19_1)
end

function HeroWindowGotwfItemPreview._start_loading_overlay(arg_20_0)
	arg_20_0._show_loading_overlay = true
	arg_20_0._fadeout_loading_overlay = nil
	arg_20_0._fadeout_progress = nil
	arg_20_0._loading_widgets_by_name.loading_icon.style.texture_id.color[1] = 255
end

function HeroWindowGotwfItemPreview._update_loading_overlay_fadeout_animation(arg_21_0, arg_21_1)
	if not arg_21_0._fadeout_loading_overlay and arg_21_0._show_loading_overlay then
		return
	end

	local var_21_0 = arg_21_0._loading_widgets_by_name
	local var_21_1 = 255
	local var_21_2 = 0
	local var_21_3 = 9
	local var_21_4 = math.min(1, (arg_21_0._fadeout_progress or 0) + var_21_3 * arg_21_1)
	local var_21_5 = math.lerp(var_21_1, var_21_2, math.easeInCubic(var_21_4))

	var_21_0.loading_icon.style.texture_id.color[1] = var_21_5
	arg_21_0._fadeout_progress = var_21_4

	if var_21_4 == 1 then
		arg_21_0._fadeout_loading_overlay = nil
		arg_21_0._fadeout_progress = nil
		arg_21_0._show_loading_overlay = false
	end
end

function HeroWindowGotwfItemPreview._destroy_previewers(arg_22_0)
	local var_22_0 = arg_22_0._item_previewer

	if var_22_0 then
		var_22_0:destroy()

		arg_22_0._item_previewer = nil
	end

	local var_22_1 = arg_22_0._world_previewer

	if var_22_1 then
		var_22_1:prepare_exit()
		var_22_1:on_exit()
		var_22_1:destroy()

		arg_22_0._world_previewer = nil
	end

	arg_22_0._item_texture_widget = nil
end

function HeroWindowGotwfItemPreview._sync_presentation_item(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._params.selected_item

	if var_23_0 ~= arg_23_0._selected_product or arg_23_1 then
		local var_23_1 = not var_23_0 or not arg_23_0._selected_product or arg_23_0._selected_product.item_id ~= var_23_0.item_id or var_23_0.reward_type == "currency"

		arg_23_0._selected_product = var_23_0

		local var_23_2 = var_23_0

		if var_23_1 then
			arg_23_0._delayed_item_unit_presentation_delay = nil

			arg_23_0:_destroy_previewers()

			if arg_23_0._selected_product then
				arg_23_0:_start_loading_overlay()
				arg_23_0:_present_item(var_23_2)
			end
		end
	end
end

local var_0_13 = {}

function HeroWindowGotwfItemPreview._present_item(arg_24_0, arg_24_1)
	local var_24_0
	local var_24_1
	local var_24_2 = arg_24_1.item_id
	local var_24_3 = arg_24_1.reward_type
	local var_24_4 = var_0_13
	local var_24_5

	if var_24_3 == "keep_decoration_painting" then
		var_24_5 = Paintings[arg_24_1.item_id]
	elseif var_24_3 == "chips" then
		var_24_4 = Currencies[arg_24_1.item_id]
	elseif var_24_3 == "currency" then
		var_24_4 = BackendUtils.get_fake_currency_item(arg_24_1.currency_code, arg_24_1.amount)
	else
		var_24_4 = ItemMasterList[arg_24_1.item_id]
	end

	if not var_24_4 then
		return
	end

	local var_24_6 = var_24_4.item_type
	local var_24_7 = var_24_4.slot_type
	local var_24_8 = var_24_4.can_wield
	local var_24_9 = var_24_4.display_name
	local var_24_10 = var_24_4.item_preview_environment
	local var_24_11 = var_24_4.item_preview_object_set_name
	local var_24_12 = ""
	local var_24_13 = ""
	local var_24_14 = ""
	local var_24_15 = ""
	local var_24_16, var_24_17 = arg_24_0:_get_can_wield_display_text(var_24_8)

	if var_24_7 == "melee" or var_24_7 == "ranged" or var_24_7 == "weapon_skin" then
		local var_24_18 = ItemMasterList[var_24_4.matching_item_key].item_type

		var_24_12 = Localize(var_24_18)
		var_24_13 = Localize(var_24_6)
		var_24_10 = var_24_10 or "weapons_default_01"
		var_24_11 = var_24_11 or "flow_weapon_lights"
	elseif var_24_7 == "hat" then
		var_24_12 = Localize(var_24_6)
		var_24_10 = var_24_10 or "hats_default_01"
		var_24_11 = var_24_11 or "flow_hat_lights"
	elseif var_24_7 == "skin" then
		var_24_12 = Localize(var_24_6)

		local var_24_19 = var_24_4.name
		local var_24_20 = Cosmetics[var_24_19]

		if var_24_20 and var_24_20.always_hide_attachment_slots then
			var_24_13 = Localize("menu_store_product_hero_skin_disclaimer_02_desc")
		else
			var_24_13 = Localize("menu_store_product_hero_skin_disclaimer_desc")
		end

		var_24_11 = var_24_11 or "flow_character_lights"
	elseif var_24_5 then
		var_24_9 = var_24_5.display_name
		var_24_12 = Localize("interaction_painting")
		var_24_14 = Localize(var_24_5.description)
		var_24_16 = ""
		var_24_17 = ""
	elseif var_24_7 == "chips" then
		local var_24_21 = arg_24_1.amount

		var_24_12 = Localize(var_24_6)
		var_24_14 = Localize(var_24_4.description)
		var_24_15 = var_24_21 and var_24_21 .. " " .. Localize("menu_store_panel_currency_tooltip_title") or ""
		var_24_16 = ""
		var_24_17 = ""
	elseif var_24_7 == "versus_currency_name" then
		local var_24_22 = arg_24_1.amount

		var_24_14 = Localize(var_24_4.description)
		var_24_15 = var_24_22 and string.format(Localize("achv_menu_vs_currency_reward_claimed"), var_24_22) or ""
		var_24_12 = Localize("hero_view_prestige_reward")
		var_24_9 = "versus_currency_name"
		var_24_16 = ""
		var_24_17 = ""
	elseif var_24_7 == "crafting_material" then
		local var_24_23 = arg_24_1.amount

		var_24_12 = Localize(var_24_6)
		var_24_14 = Localize(var_24_4.description)
		var_24_15 = var_24_23 and var_24_23 .. " " .. Localize(var_24_4.display_name) or ""
		var_24_16 = ""
		var_24_17 = ""
	else
		var_24_12 = Localize(var_24_6)
		var_24_14 = Localize(var_24_4.description)
		var_24_16 = ""
		var_24_17 = ""
	end

	if var_24_3 == "bundle_item" then
		local var_24_24 = arg_24_1.bundle_item_id
		local var_24_25 = ItemMasterList[var_24_24]

		var_24_12 = var_24_25.information_text and Localize(var_24_25.information_text) or var_24_12
		var_24_14 = var_24_25.description and Localize(var_24_25.description) or var_24_14
		var_24_16 = ""
		var_24_17 = ""
	end

	arg_24_0:_show_object_set(var_24_11)
	arg_24_0:_update_environment(var_24_10)
	arg_24_0:_set_title_name(Localize(var_24_9))
	arg_24_0:_set_sub_title_name(var_24_16)
	arg_24_0:_set_description_text(var_24_14)
	arg_24_0:_set_sub_title_alpha_multiplier(1)
	arg_24_0:_set_type_title_name(var_24_12)
	arg_24_0:_set_career_title_name(var_24_17)
	arg_24_0:_set_disclaimer_text(var_24_13)
	arg_24_0:_set_amount_text(var_24_15)
	arg_24_0:_update_claimed_status()
	arg_24_0:_start_transition_animation("info_animation")

	arg_24_0._delayed_item_unit_presentation_delay = 0.3
end

function HeroWindowGotwfItemPreview._update_claimed_status(arg_25_0)
	local var_25_0 = arg_25_0._params.selected_item_claimed
	local var_25_1 = arg_25_0._params.selected_item_already_owned
	local var_25_2 = arg_25_0._top_widgets_by_name.claimed

	var_25_2.content.visible = var_25_0
	var_25_2.content.already_owned = var_25_1
end

function HeroWindowGotwfItemPreview._create_material_instance(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	arg_26_0._cloned_materials_by_reference[arg_26_4] = arg_26_2

	return Gui.clone_material_from_template(arg_26_1, arg_26_2, arg_26_3)
end

function HeroWindowGotwfItemPreview._set_material_diffuse(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = Gui.material(arg_27_1, arg_27_2)

	if var_27_0 then
		Material.set_texture(var_27_0, "diffuse_map", arg_27_3)
	end
end

function HeroWindowGotwfItemPreview._load_texture_package(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = true
	local var_28_1 = false

	Managers.package:load(arg_28_1, arg_28_2, arg_28_3, var_28_0, var_28_1)

	arg_28_0._loaded_package_names[arg_28_2] = arg_28_1
end

function HeroWindowGotwfItemPreview._is_unique_reference_to_material(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._cloned_materials_by_reference
	local var_29_1 = var_29_0[arg_29_1]

	fassert(var_29_1, "[HeroWindowGotwfItemPreview] - Could not find a used material for reference name: (%s)", arg_29_1)

	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		if var_29_1 == iter_29_1 and arg_29_1 ~= iter_29_0 then
			return false
		end
	end

	return true
end

function HeroWindowGotwfItemPreview._unload_texture_by_reference(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0._loaded_package_names
	local var_30_1 = arg_30_0._cloned_materials_by_reference
	local var_30_2 = var_30_0[arg_30_1]

	fassert(var_30_2, "[HeroWindowGotwfOverview] - Could not find a package to unload for reference name: (%s)", arg_30_1)
	Managers.package:unload(var_30_2, arg_30_1)

	var_30_0[arg_30_1] = nil

	if arg_30_0:_is_unique_reference_to_material(arg_30_1) then
		local var_30_3 = var_30_1[arg_30_1]
		local var_30_4 = arg_30_0._ui_top_renderer.gui

		arg_30_0:_set_material_diffuse(var_30_4, var_30_3, var_0_11)
	end

	var_30_1[arg_30_1] = nil
end

function HeroWindowGotwfItemPreview._delayed_item_unit_presentation(arg_31_0, arg_31_1)
	if arg_31_1.reward_type == "keep_decoration_painting" then
		arg_31_0:_setup_painting_presentation(arg_31_1)
	else
		arg_31_0:_setup_item_presentation(arg_31_1)
	end
end

function HeroWindowGotwfItemPreview._setup_painting_presentation(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_1.item_id
	local var_32_1 = Paintings[var_32_0]

	if not var_32_1 or var_32_0 == "hidden" then
		return
	end

	local var_32_2 = arg_32_0._ui_top_renderer.gui
	local var_32_3
	local var_32_4 = "keep_painting_" .. var_32_0
	local var_32_5 = string.find(var_32_0, "_none") ~= nil

	if not var_32_5 then
		var_32_3 = "resource_packages/keep_paintings/" .. var_32_4
	end

	arg_32_0._reference_id = (arg_32_0._reference_id or 0) + 1

	local var_32_6 = var_32_0 .. "_" .. arg_32_0._reference_id
	local var_32_7 = "keep_painting_" .. var_32_0
	local var_32_8 = "template_store_diffuse_masked"

	arg_32_0:_create_material_instance(var_32_2, var_32_7, var_32_8, var_32_6)

	local function var_32_9()
		local var_33_0 = var_0_5()
		local var_33_1 = UIWidget.init(var_33_0)
		local var_33_2 = var_33_1.content
		local var_33_3 = var_33_1.style

		arg_32_0._item_texture_widget = var_33_1

		local var_33_4 = "units/gameplay/keep_paintings/materials/" .. var_32_4 .. "/" .. var_32_4 .. "_df"

		arg_32_0:_set_material_diffuse(var_32_2, var_32_7, var_33_4)

		local var_33_5 = 2
		local var_33_6 = 150 * var_33_5
		local var_33_7 = 0.125

		if var_32_1.orientation == "horizontal" then
			var_33_2.painting = {
				texture_id = var_32_7,
				uvs = {
					{
						0,
						var_33_7
					},
					{
						1,
						1 - var_33_7
					}
				}
			}
			var_33_3.painting.texture_size = {
				var_33_6,
				var_33_6 * (1 - 2 * var_33_7)
			}
			var_33_3.painting_frame.area_size = {
				var_33_6,
				var_33_6 * (1 - 2 * var_33_7)
			}
		else
			var_33_2.painting = {
				texture_id = var_32_7,
				uvs = {
					{
						var_33_7,
						0
					},
					{
						1 - var_33_7,
						1
					}
				}
			}
			var_33_3.painting.texture_size = {
				var_33_6 * (1 - 2 * var_33_7),
				var_33_6
			}
			var_33_3.painting_frame.area_size = {
				var_33_6 * (1 - 2 * var_33_7),
				var_33_6
			}
		end

		arg_32_0._fadeout_loading_overlay = true

		Renderer.request_textures_to_highest_mip_level()
	end

	if var_32_5 then
		var_32_9()
	else
		arg_32_0:_load_texture_package(var_32_3, var_32_6, var_32_9)
	end
end

function HeroWindowGotwfItemPreview._setup_item_presentation(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_1.item_id
	local var_34_1 = arg_34_1.reward_type
	local var_34_2

	if var_34_1 == "chips" then
		var_34_2 = Currencies[var_34_0]
	elseif var_34_1 == "currency" then
		var_34_2, var_34_0 = BackendUtils.get_fake_currency_item(arg_34_1.currency_code, arg_34_1.amount)
	else
		var_34_2 = ItemMasterList[var_34_0]
	end

	local var_34_3 = var_34_2.slot_type
	local var_34_4 = arg_34_0._viewport_widget
	local var_34_5 = var_34_4.element.pass_data[1]
	local var_34_6 = var_34_5.viewport
	local var_34_7 = var_34_5.world

	if var_34_3 == "melee" or var_34_3 == "ranged" or var_34_3 == "weapon_skin" then
		local var_34_8 = {
			0,
			0,
			0
		}
		local var_34_9
		local var_34_10 = true
		local var_34_11
		local var_34_12 = true
		local var_34_13 = ScriptViewport.camera(var_34_6)

		ScriptCamera.set_local_rotation(var_34_13, QuaternionBox(0, 0, 1, 0):unbox())

		local var_34_14 = {
			data = var_34_2
		}
		local var_34_15 = LootItemUnitPreviewer:new(var_34_14, var_34_8, var_34_7, var_34_6, var_34_9, var_34_10, var_34_11, var_34_12)
		local var_34_16 = callback(arg_34_0, "cb_unit_spawned_item_preview", var_34_15, var_34_0)

		var_34_15:activate_auto_spin()
		var_34_15:register_spawn_callback(var_34_16)

		arg_34_0._item_previewer = var_34_15
	elseif var_34_3 == "hat" then
		local var_34_17 = MenuWorldPreviewer:new(arg_34_0._ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroWindowGotwfItemPreview")

		var_34_17:on_enter(var_34_4)

		arg_34_0._world_previewer = var_34_17

		local var_34_18, var_34_19, var_34_20, var_34_21 = arg_34_0:_get_hero_wield_info_by_item(var_34_2)
		local var_34_22 = CareerSettings[var_34_20].base_skin

		arg_34_0:_spawn_hero_with_hat(var_34_17, var_34_18, var_34_21, var_34_22, var_34_0)
	elseif var_34_3 == "skin" then
		local var_34_23 = MenuWorldPreviewer:new(arg_34_0._ingame_ui_context, UISettings.hero_skin_camera_position_by_character, "HeroWindowGotwfItemPreview")

		var_34_23:on_enter(var_34_4)

		arg_34_0._world_previewer = var_34_23

		local var_34_24 = var_34_0
		local var_34_25, var_34_26, var_34_27, var_34_28 = arg_34_0:_get_hero_wield_info_by_item(var_34_2)

		arg_34_0:_spawn_hero_skin(var_34_23, var_34_25, var_34_28, var_34_24)
	elseif var_34_3 == "frame" then
		local var_34_29 = "item_texture"
		local var_34_30 = var_34_2.temporary_template or "default"
		local var_34_31 = 1.5
		local var_34_32
		local var_34_33 = false
		local var_34_34 = true
		local var_34_35 = UIWidgets.create_base_portrait_frame(var_34_29, var_34_30, var_34_31, var_34_32, var_34_33, var_34_34)

		arg_34_0._item_texture_widget = UIWidget.init(var_34_35)
		arg_34_0._fadeout_loading_overlay = true
	elseif var_34_3 == "loot_chest" or var_34_3 == "chips" or var_34_3 == "crafting_material" or var_34_3 == "versus_currency_name" then
		arg_34_0._reference_id = (arg_34_0._reference_id or 0) + 1

		local var_34_36 = var_34_0 .. "_" .. arg_34_0._reference_id

		if var_34_3 == "chips" then
			var_34_0 = "shillings_medium"
		elseif var_34_3 == "versus_currency_name" then
			var_34_0 = "versus_currency_small"
		elseif var_34_3 == "loot_chest" then
			var_34_0 = "loot_chest_generic"
		end

		local var_34_37 = var_34_2.store_icon_override_key
		local var_34_38 = "store_item_icon_" .. (var_34_37 or var_34_0)
		local var_34_39 = "resource_packages/store/item_icons/" .. var_34_38

		if Application.can_get("package", var_34_39) then
			local var_34_40
			local var_34_41 = "item_texture"
			local var_34_42
			local var_34_43
			local var_34_44
			local var_34_45
			local var_34_46 = {
				390,
				330
			}
			local var_34_47 = var_0_6(var_34_40, var_34_41, var_34_42, var_34_43, var_34_44, var_34_45, var_34_46)
			local var_34_48 = UIWidget.init(var_34_47)
			local var_34_49 = var_34_48.content

			var_34_49.reference_name = var_34_36

			local var_34_50 = arg_34_0._ui_top_renderer.gui
			local var_34_51 = var_34_42 and var_34_38 .. "_masked" or var_34_38
			local var_34_52 = var_34_42 and "template_store_diffuse_masked" or "template_store_diffuse"

			arg_34_0:_create_material_instance(var_34_50, var_34_51, var_34_52, var_34_36)

			local function var_34_53()
				local var_35_0 = "gui/1080p/single_textures/store_item_icons/" .. var_34_38 .. "/" .. var_34_38

				arg_34_0:_set_material_diffuse(var_34_50, var_34_51, var_35_0)

				var_34_49.texture_id = var_34_51
				arg_34_0._fadeout_loading_overlay = true
			end

			arg_34_0:_load_texture_package(var_34_39, var_34_36, var_34_53)

			arg_34_0._item_texture_widget = var_34_48
		else
			Application.warning("Icon package not accessable for product_id: (%s) and texture_name: (%s)", var_34_0, var_34_38)
		end
	end
end

function HeroWindowGotwfItemPreview._update_delayed_item_unit_presentation(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._delayed_item_unit_presentation_delay

	if not var_36_0 then
		return
	end

	local var_36_1 = math.max(var_36_0 - arg_36_1, 0)

	if var_36_1 == 0 then
		arg_36_0._delayed_item_unit_presentation_delay = nil

		local var_36_2 = arg_36_0._selected_product

		arg_36_0:_delayed_item_unit_presentation(var_36_2)
	else
		arg_36_0._delayed_item_unit_presentation_delay = var_36_1
	end
end

function HeroWindowGotwfItemPreview._set_title_name(arg_37_0, arg_37_1)
	arg_37_0._top_widgets_by_name.title_text.content.text = arg_37_1
end

function HeroWindowGotwfItemPreview._set_sub_title_name(arg_38_0, arg_38_1)
	arg_38_0._top_widgets_by_name.sub_title_text.content.text = arg_38_1
end

function HeroWindowGotwfItemPreview._set_description_text(arg_39_0, arg_39_1)
	arg_39_0._top_widgets_by_name.description_text.content.text = arg_39_1
end

function HeroWindowGotwfItemPreview._set_sub_title_alpha_multiplier(arg_40_0, arg_40_1)
	arg_40_0._top_widgets_by_name.sub_title_text.alpha_multiplier = arg_40_1
end

function HeroWindowGotwfItemPreview._set_type_title_name(arg_41_0, arg_41_1)
	arg_41_0._top_widgets_by_name.type_title_text.content.text = arg_41_1
end

function HeroWindowGotwfItemPreview._set_career_title_name(arg_42_0, arg_42_1)
	arg_42_0._top_widgets_by_name.career_title_text.content.text = arg_42_1
end

function HeroWindowGotwfItemPreview._set_disclaimer_text(arg_43_0, arg_43_1)
	arg_43_0._disclaimer_text = arg_43_1
	arg_43_0._top_widgets_by_name.disclaimer_text.content.text = arg_43_1

	arg_43_0:_update_info_text_alignment()
end

function HeroWindowGotwfItemPreview._set_amount_text(arg_44_0, arg_44_1)
	arg_44_0._top_widgets_by_name.amount_text.content.text = arg_44_1
end

function HeroWindowGotwfItemPreview._update_info_text_alignment(arg_45_0)
	local var_45_0 = arg_45_0._top_widgets_by_name.expire_timer_text
	local var_45_1 = arg_45_0._top_widgets_by_name.disclaimer_text
	local var_45_2 = arg_45_0._top_widgets_by_name.disclaimer_divider
	local var_45_3 = arg_45_0._expire_text and arg_45_0._expire_text ~= ""
	local var_45_4 = arg_45_0._disclaimer_text and arg_45_0._disclaimer_text ~= ""
	local var_45_5
	local var_45_6

	if var_45_3 then
		if var_45_4 then
			var_45_5 = var_45_0
			var_45_6 = var_45_1
		else
			var_45_6 = var_45_0
		end
	elseif var_45_4 then
		var_45_6 = var_45_1
	end

	local var_45_7 = var_45_3 or var_45_4
	local var_45_8 = arg_45_0._ui_renderer
	local var_45_9 = var_45_5 and UIUtils.get_text_width(var_45_8, var_45_5.style.text, var_45_5.content.text) or 0
	local var_45_10 = var_45_6 and UIUtils.get_text_width(var_45_8, var_45_6.style.text, var_45_6.content.text) or 0
	local var_45_11 = 14
	local var_45_12 = var_0_1[var_45_2.scenegraph_id].size[1]
	local var_45_13 = var_45_9 + var_45_10 + var_45_12
	local var_45_14 = var_45_9 / 2 - var_45_13 / 2 - var_45_11 / 2
	local var_45_15 = var_45_14 + var_45_9 / 2 + var_45_12 / 2 + var_45_11 / 2
	local var_45_16 = var_45_15 + var_45_10 / 2 + var_45_12 / 2 + var_45_11 / 2

	if var_45_5 then
		var_45_5.offset[1] = var_45_14
	end

	if var_45_6 then
		var_45_6.offset[1] = var_45_16
	end

	var_45_2.offset[1] = var_45_15
	var_45_2.content.visible = var_45_7
end

function HeroWindowGotwfItemPreview.cb_unit_spawned_item_preview(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = true

	arg_46_1:present_item(arg_46_2, var_46_0)

	arg_46_0._fadeout_loading_overlay = true
end

function HeroWindowGotwfItemPreview._spawn_hero_skin(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	local var_47_0 = callback(arg_47_0, "cb_hero_unit_spawned_skin_preview", arg_47_1, arg_47_2, arg_47_3)

	arg_47_1:request_spawn_hero_unit(arg_47_2, arg_47_3, false, var_47_0, 1, nil, arg_47_4)
end

function HeroWindowGotwfItemPreview._spawn_hero_with_hat(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	local var_48_0 = callback(arg_48_0, "cb_hero_unit_spawned_hat_preview", arg_48_1, arg_48_2, arg_48_3, arg_48_5)

	arg_48_1:request_spawn_hero_unit(arg_48_2, arg_48_3, false, var_48_0, 1, nil, arg_48_4)
end

function HeroWindowGotwfItemPreview.cb_hero_unit_spawned_skin_preview(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = FindProfileIndex(arg_49_2)
	local var_49_1 = SPProfiles[var_49_0].careers[arg_49_3]
	local var_49_2 = "store_idle"
	local var_49_3 = var_49_1.preview_items

	if var_49_3 then
		for iter_49_0, iter_49_1 in ipairs(var_49_3) do
			local var_49_4 = iter_49_1.item_name
			local var_49_5 = ItemMasterList[var_49_4].slot_type

			if var_49_5 ~= "melee" and var_49_5 ~= "ranged" then
				local var_49_6 = InventorySettings.slot_names_by_type[var_49_5][1]
				local var_49_7 = InventorySettings.slots_by_name[var_49_6]

				arg_49_1:equip_item(var_49_4, var_49_7)
			end
		end
	end

	if var_49_2 then
		arg_49_1:play_character_animation(var_49_2)
	end

	arg_49_0._fadeout_loading_overlay = true
end

function HeroWindowGotwfItemPreview.cb_hero_unit_spawned_hat_preview(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	local var_50_0 = FindProfileIndex(arg_50_2)
	local var_50_1 = SPProfiles[var_50_0].careers[arg_50_3]
	local var_50_2 = "store_idle"
	local var_50_3 = var_50_1.preview_items
	local var_50_4 = InventorySettings.slots_by_name.slot_hat

	arg_50_1:equip_item(arg_50_4, var_50_4)

	if var_50_3 then
		for iter_50_0, iter_50_1 in ipairs(var_50_3) do
			local var_50_5 = iter_50_1.item_name
			local var_50_6 = ItemMasterList[var_50_5].slot_type

			if var_50_6 ~= "melee" and var_50_6 ~= "ranged" and var_50_6 ~= "hat" then
				local var_50_7 = InventorySettings.slot_names_by_type[var_50_6][1]
				local var_50_8 = InventorySettings.slots_by_name[var_50_7]

				arg_50_1:equip_item(var_50_5, var_50_8)
			end
		end
	end

	if var_50_2 then
		arg_50_1:play_character_animation(var_50_2)
	end

	arg_50_0._fadeout_loading_overlay = true
end

function HeroWindowGotwfItemPreview._get_can_wield_display_text(arg_51_0, arg_51_1)
	local var_51_0 = ""
	local var_51_1 = ""

	if arg_51_1 then
		local var_51_2 = 0
		local var_51_3 = 0

		for iter_51_0, iter_51_1 in ipairs(arg_51_1) do
			local var_51_4 = CareerSettings[iter_51_1]
			local var_51_5 = var_51_4.profile_name
			local var_51_6 = FindProfileIndex(var_51_5)
			local var_51_7 = SPProfiles[var_51_6].character_name

			if var_51_3 > 0 then
				var_51_1 = var_51_1 .. ", "
			end

			var_51_3 = var_51_3 + 1

			local var_51_8 = var_51_4.display_name

			var_51_1 = var_51_1 .. Localize(var_51_8)

			local var_51_9 = Localize(var_51_7)

			if not string.find(var_51_0, var_51_9) then
				if var_51_2 > 0 then
					var_51_0 = var_51_0 .. ", "
				end

				var_51_2 = var_51_2 + 1
				var_51_0 = var_51_0 .. var_51_9
			end
		end
	end

	return var_51_0, var_51_1
end

function HeroWindowGotwfItemPreview._get_hero_wield_info_by_item(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_1.can_wield[1]

	for iter_52_0, iter_52_1 in ipairs(SPProfiles) do
		local var_52_1 = iter_52_1.careers

		for iter_52_2, iter_52_3 in ipairs(var_52_1) do
			if iter_52_3.name == var_52_0 then
				local var_52_2 = iter_52_1.display_name
				local var_52_3 = FindProfileIndex(var_52_2)
				local var_52_4 = iter_52_3.sort_order

				return var_52_2, var_52_3, var_52_0, var_52_4
			end
		end
	end
end

function HeroWindowGotwfItemPreview._sync_layout_path(arg_53_0)
	local var_53_0 = arg_53_0._parent
	local var_53_1 = arg_53_0._old_layout_name
	local var_53_2 = var_53_0:get_layout_name()

	if var_53_2 ~= var_53_1 then
		arg_53_0._old_layout_name = var_53_2
	end
end

function HeroWindowGotwfItemPreview._update_title_edge_animation(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0._title_edge_animation_data

	if not var_54_0 then
		return
	end

	local var_54_1 = var_54_0.duration

	if not var_54_1 then
		return
	end

	local var_54_2 = math.max(var_54_1 - arg_54_1, 0)
	local var_54_3 = var_54_0.start_length
	local var_54_4 = var_54_0.target_length
	local var_54_5 = var_54_0.total_duration
	local var_54_6 = math.easeOutCubic
	local var_54_7 = 1 - var_54_2 / var_54_5
	local var_54_8 = var_54_6(var_54_7)
	local var_54_9 = var_54_3 + (var_54_4 - var_54_3) * var_54_8
	local var_54_10 = arg_54_0._item_widgets_by_name.title_edge

	arg_54_0._ui_scenegraph[var_54_10.scenegraph_id].size[1] = var_54_9

	if var_54_2 == 0 then
		var_54_0.duration = nil
	else
		var_54_0.duration = var_54_2
	end
end
