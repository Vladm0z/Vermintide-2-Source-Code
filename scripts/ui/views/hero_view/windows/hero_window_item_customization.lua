-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_item_customization.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_item_customization_definitions")
local var_0_4 = var_0_3.scenegraph_definition
local var_0_5 = var_0_3.animation_definitions
local var_0_6 = var_0_3.widgets
local var_0_7 = var_0_3.crafting_widgets
local var_0_8 = var_0_3.info_widgets
local var_0_9 = var_0_3.weapon_illusion_base_widgets
local var_0_10 = var_0_3.trait_reroll_widgets
local var_0_11 = var_0_3.upgrade_widgets
local var_0_12 = var_0_3.property_reroll_widgets
local var_0_13 = var_0_3.viewport_widget
local var_0_14 = var_0_3.create_property_option
local var_0_15 = var_0_3.create_trait_option
local var_0_16 = var_0_3.create_illusion_button
local var_0_17 = var_0_3.background_rect
local var_0_18 = var_0_3.generic_input_actions
local var_0_19 = {
	item_setting = {
		setup_function = "_state_setup_overview",
		craft_complete_func_name = "_apply_weapon_skin_craft_complete",
		gamepad_input_func = "_update_skin_gamepad_input",
		transition_time = 0.3,
		fov = 30,
		draw_function = "_state_draw_overview",
		camera_position = {
			0,
			0,
			0
		}
	},
	item_properties = {
		setup_function = "_state_setup_property_reroll",
		craft_complete_func_name = "_state_setup_property_reroll",
		transition_time = 0.3,
		fov = 30,
		draw_function = "_state_draw_property_reroll",
		camera_position = {
			0,
			-1,
			0
		},
		recipe_by_slot_type = {
			trinket = "reroll_jewellery_properties",
			ranged = "reroll_weapon_properties",
			necklace = "reroll_jewellery_properties",
			ring = "reroll_jewellery_properties",
			melee = "reroll_weapon_properties"
		}
	},
	item_trait = {
		setup_function = "_state_setup_trait_reroll",
		craft_complete_func_name = "_state_setup_trait_reroll",
		transition_time = 0.3,
		fov = 30,
		draw_function = "_state_draw_trait_reroll",
		camera_position = {
			0,
			-1,
			0
		},
		recipe_by_slot_type = {
			trinket = "reroll_jewellery_traits",
			ranged = "reroll_weapon_traits",
			necklace = "reroll_jewellery_traits",
			ring = "reroll_jewellery_traits",
			melee = "reroll_weapon_traits"
		}
	},
	item_upgrade = {
		setup_function = "_state_setup_upgrade",
		craft_complete_func_name = "_upgrade_item_craft_complete",
		transition_time = 0.3,
		fov = 30,
		draw_function = "_state_draw_upgrade",
		camera_position = {
			0,
			-1,
			0
		},
		recipe_by_rarity = {
			common = "upgrade_item_rarity_rare",
			plentiful = "upgrade_item_rarity_common",
			rare = "upgrade_item_rarity_exotic",
			exotic = "upgrade_item_rarity_unique"
		}
	}
}

HeroWindowItemCustomization = class(HeroWindowItemCustomization)
HeroWindowItemCustomization.NAME = "HeroWindowItemCustomization"

HeroWindowItemCustomization.on_enter = function (arg_1_0, arg_1_1)
	print("[HeroViewWindow] Enter Substate HeroWindowItemCustomization")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._career_index = arg_1_1.career_index
	arg_1_0._profile_index = arg_1_1.profile_index
	arg_1_0._career_name = SPProfiles[arg_1_0._profile_index].careers[arg_1_0._career_index].name
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._state_render_settings = {
		alpha_multiplier = 0
	}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._animation_callbacks = {}
	arg_1_0._craft_progress = 0

	local var_1_1 = arg_1_1.item_to_customize

	arg_1_0._item_backend_id = var_1_1.backend_id

	arg_1_0:_create_ui_elements()
	arg_1_0:_setup_menu_input_description()
	arg_1_0:_present_item(var_1_1)
	arg_1_0:_find_equipment_slot()
	arg_1_0:_setup_availble_states(var_1_1)
	arg_1_0:_option_selected(1, true)
	arg_1_0:_start_transition_animation("on_enter")
end

HeroWindowItemCustomization._setup_menu_input_description = function (arg_2_0)
	local var_2_0 = UILayer.default + 300
	local var_2_1 = arg_2_0._parent:window_input_service()

	arg_2_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_2_0._ui_top_renderer, var_2_1, 5, var_2_0, var_0_18.default, true)

	arg_2_0._menu_input_description:set_input_description(nil)
end

HeroWindowItemCustomization._find_equipment_slot = function (arg_3_0)
	local var_3_0 = Managers.backend:get_interface("items")
	local var_3_1

	for iter_3_0, iter_3_1 in pairs(InventorySettings.equipment_slots) do
		var_3_1 = iter_3_1.name

		if var_3_0:get_loadout_item_id(arg_3_0._career_name, var_3_1) == arg_3_0._item_backend_id then
			break
		end
	end

	if not var_3_1 then
		local var_3_2 = arg_3_0:_get_item(arg_3_0._item_backend_id).data.slot_type

		var_3_1 = InventorySettings.slot_names_by_type[var_3_2][1]
	end

	arg_3_0._equipment_slot_name = var_3_1
end

HeroWindowItemCustomization._setup_availble_states = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.data
	local var_4_1 = arg_4_1.rarity or var_4_0.rarity or "default"
	local var_4_2 = UISettings.item_rarity_order
	local var_4_3 = var_4_2[var_4_1] or var_4_2.default

	if var_4_1 == "default" or var_4_1 == "promo" then
		arg_4_0._available_states = {
			"item_setting"
		}
	elseif var_4_3 <= var_4_2.unique then
		arg_4_0._available_states = {
			"item_setting",
			"item_properties",
			"item_trait"
		}
	elseif var_4_3 <= var_4_2.exotic then
		arg_4_0._available_states = {
			"item_setting",
			"item_properties",
			"item_trait",
			"item_upgrade"
		}
	elseif var_4_3 <= var_4_2.common then
		arg_4_0._available_states = {
			"item_setting",
			"item_properties",
			"item_upgrade"
		}
	elseif var_4_3 <= var_4_2.plentiful then
		arg_4_0._available_states = {
			"item_setting",
			"item_upgrade"
		}
	end

	arg_4_0._states = {}

	local var_4_4 = arg_4_0._widgets_by_name

	for iter_4_0, iter_4_1 in pairs(var_0_19) do
		local var_4_5 = table.find(arg_4_0._available_states, iter_4_0)

		if var_4_5 then
			arg_4_0._states[iter_4_0] = var_0_19[iter_4_0]
		end

		var_4_4[iter_4_0].content.visible = var_4_5
	end

	if arg_4_0._state and not arg_4_0._states[arg_4_0._state] then
		local var_4_6 = arg_4_0._widgets_by_name[arg_4_0._state]

		var_4_6.content.button_hotspot.is_selected = false
		var_4_6.style.hover_frame.saturated = false

		arg_4_0:_option_selected(1, true)
	end
end

HeroWindowItemCustomization._set_camera_position = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._preview_widget.element.pass_data[1].viewport
	local var_5_1 = ScriptViewport.camera(var_5_0)

	ScriptCamera.set_local_position(var_5_1, arg_5_1)
end

HeroWindowItemCustomization._camera_position = function (arg_6_0)
	local var_6_0 = arg_6_0._preview_widget.element.pass_data[1].viewport
	local var_6_1 = ScriptViewport.camera(var_6_0)

	return ScriptCamera.position(var_6_1)
end

HeroWindowItemCustomization._set_camera_fov = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._preview_widget.element.pass_data[1].viewport
	local var_7_1 = ScriptViewport.camera(var_7_0)

	Camera.set_vertical_fov(var_7_1, math.pi * arg_7_1 / 180)
end

HeroWindowItemCustomization._camera_fov = function (arg_8_0)
	local var_8_0 = arg_8_0._preview_widget.element.pass_data[1].viewport
	local var_8_1 = ScriptViewport.camera(var_8_0)
	local var_8_2 = Camera.vertical_fov(var_8_1)

	return math.floor(var_8_2 * 180 / math.pi)
end

HeroWindowItemCustomization._change_state = function (arg_9_0, arg_9_1)
	if not (arg_9_0._state == arg_9_1) then
		local var_9_0 = arg_9_0._states[arg_9_1]

		fassert(var_9_0, "[HeroWindowItemCustomization:_change_state] There is no state called %s", tostring(arg_9_1))

		arg_9_0._state = arg_9_1

		local var_9_1 = var_9_0.setup_function

		if var_9_1 then
			arg_9_0[var_9_1](arg_9_0)
		end

		arg_9_0._state_render_settings.alpha_multiplier = 0
	end

	arg_9_0._state_start_fov = arg_9_0:_camera_fov()

	local var_9_2 = arg_9_0:_camera_position()

	arg_9_0._state_start_camera_position = {
		var_9_2.x,
		var_9_2.y,
		var_9_2.z
	}
	arg_9_0._state_transition_timer = 0

	if arg_9_0._skin_dirty then
		local var_9_3 = arg_9_0:_get_item(arg_9_0._item_backend_id)

		arg_9_0:_present_item(var_9_3, true)

		arg_9_0._skin_dirty = nil
	end
end

HeroWindowItemCustomization._get_item = function (arg_10_0, arg_10_1)
	arg_10_0._item_backend_id = arg_10_1

	return Managers.backend:get_interface("items"):get_item_from_id(arg_10_1)
end

HeroWindowItemCustomization._start_transition_animation = function (arg_11_0, arg_11_1)
	local var_11_0 = {
		render_settings = arg_11_0._render_settings,
		state_render_settings = arg_11_0._state_render_settings
	}
	local var_11_1 = {}
	local var_11_2 = arg_11_0._ui_animator:start_animation(arg_11_1, var_11_1, var_0_4, var_11_0)

	arg_11_0._animations[arg_11_1] = var_11_2
end

HeroWindowItemCustomization._create_ui_elements = function (arg_12_0)
	if arg_12_0._preview_widget then
		UIWidget.destroy(arg_12_0._ui_top_renderer, arg_12_0._preview_widget)

		arg_12_0._preview_widget = nil
	end

	local var_12_0 = UISceneGraph.init_scenegraph(var_0_4)

	arg_12_0._ui_scenegraph = var_12_0
	arg_12_0._background_widget = UIWidget.init(var_0_17)

	local var_12_1 = {}
	local var_12_2 = {}

	for iter_12_0, iter_12_1 in pairs(var_0_6) do
		local var_12_3 = UIWidget.init(iter_12_1)

		var_12_1[#var_12_1 + 1] = var_12_3
		var_12_2[iter_12_0] = var_12_3
	end

	arg_12_0._widgets = var_12_1
	arg_12_0._widgets_by_name = var_12_2

	local var_12_4 = {}

	for iter_12_2, iter_12_3 in pairs(var_0_7) do
		local var_12_5 = UIWidget.init(iter_12_3)

		var_12_4[#var_12_4 + 1] = var_12_5
		arg_12_0._widgets_by_name[iter_12_2] = var_12_5
	end

	arg_12_0._crafting_widgets = var_12_4

	arg_12_0:_create_preview_widget()
	UIRenderer.clear_scenegraph_queue(arg_12_0._ui_renderer)

	arg_12_0._ui_animator = UIAnimator:new(var_12_0, var_0_5)
end

HeroWindowItemCustomization._create_preview_widget = function (arg_13_0)
	local var_13_0 = arg_13_0:_create_item_preview_widget_definition()

	arg_13_0._preview_widget = UIWidget.init(var_13_0)

	arg_13_0:_register_object_sets(arg_13_0._preview_widget, var_13_0)
end

HeroWindowItemCustomization._create_item_preview_widget_definition = function (arg_14_0)
	local var_14_0 = {
		element = {}
	}
	local var_14_1 = {
		{
			pass_type = "viewport",
			style_id = "viewport"
		},
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		}
	}
	local var_14_2 = {
		activated = true,
		button_hotspot = {}
	}
	local var_14_3 = {
		viewport = {
			viewport_type = "default_forward",
			layer = 962,
			shading_environment = "environment/ui_store_preview",
			viewport_name = "item_preview",
			level_name = "levels/ui_store_preview/world",
			enable_sub_gui = true,
			fov = 65,
			world_name = "item_preview",
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
			}
		}
	}

	var_14_0.element.passes = var_14_1
	var_14_0.content = var_14_2
	var_14_0.style = var_14_3
	var_14_0.offset = {
		0,
		0,
		0
	}
	var_14_0.scenegraph_id = "item_preview"

	return var_14_0
end

HeroWindowItemCustomization.on_exit = function (arg_15_0, arg_15_1)
	print("[HeroViewWindow] Exit Substate HeroWindowItemCustomization")

	arg_15_0._ui_animator = nil

	if arg_15_0._previewer then
		arg_15_0._previewer:destroy()
	end

	if arg_15_0._preview_widget then
		UIWidget.destroy(arg_15_0._ui_top_renderer, arg_15_0._preview_widget)
	end

	if arg_15_0._character_dirty then
		arg_15_0._parent:update_skin_sync()
	end
end

HeroWindowItemCustomization.play_sound = function (arg_16_0, arg_16_1)
	arg_16_0._parent:play_sound(arg_16_1)
end

HeroWindowItemCustomization.update = function (arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:_handle_gamepad_activity()
	arg_17_0:_update_craft_response()

	if arg_17_0._item_dirty then
		arg_17_0:_update_item_rarity()
		arg_17_0:_update_property_option()
		arg_17_0:_update_trait_option()
		arg_17_0:_update_upgrade_option()

		arg_17_0._item_dirty = false
	end

	arg_17_0:_update_active_preview()
	arg_17_0:_update_animations(arg_17_1)

	local var_17_0 = arg_17_0._parent:window_input_service()

	arg_17_0:_handle_gamepad_input(var_17_0, arg_17_1, arg_17_2)
	arg_17_0:_handle_input(var_17_0, arg_17_1, arg_17_2)

	if arg_17_0._previewer then
		arg_17_0._previewer:update(arg_17_1, arg_17_2, var_17_0)
	end

	local var_17_1 = arg_17_0._scrollbar_logic

	if var_17_1 then
		var_17_1:update(arg_17_1, arg_17_2)
	end

	arg_17_0:_update_scroll_position()
	arg_17_0:_draw(var_17_0, arg_17_1)
end

HeroWindowItemCustomization.post_update = function (arg_18_0, arg_18_1, arg_18_2)
	if arg_18_0._previewer then
		arg_18_0._previewer:post_update(arg_18_1, arg_18_2)
	end
end

HeroWindowItemCustomization._register_object_sets = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2.style.viewport
	local var_19_1 = arg_19_1.content
	local var_19_2 = arg_19_1.element.pass_data[1]
	local var_19_3 = var_19_0.level_name
	local var_19_4 = {}
	local var_19_5 = LevelResource.object_set_names(var_19_3)

	for iter_19_0, iter_19_1 in ipairs(var_19_5) do
		var_19_4[iter_19_1] = {
			set_enabled = true,
			units = LevelResource.unit_indices_in_object_set(var_19_3, iter_19_1)
		}
	end

	var_19_1.object_set_data = {
		world = var_19_2.world,
		level = var_19_2.level,
		object_sets = var_19_4,
		level_name = var_19_3
	}

	arg_19_0:_show_object_set(nil, true)
end

HeroWindowItemCustomization._show_object_set = function (arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0._preview_widget then
		print("[StoreWindowItemPreview:show_object_set] Viewport not initiated")

		return
	end

	local var_20_0 = arg_20_0._preview_widget.content.object_set_data
	local var_20_1 = var_20_0.world
	local var_20_2 = var_20_0.level
	local var_20_3 = var_20_0.level_name
	local var_20_4 = var_20_0.object_sets

	if not var_20_4[arg_20_1] and not arg_20_2 then
		print(string.format("[StoreWindowItemPreview:show_object_set] No object set called %q in level %q", arg_20_1, var_20_3))

		return
	end

	for iter_20_0, iter_20_1 in pairs(var_20_4) do
		local var_20_5 = iter_20_1.set_enabled

		if var_20_5 and iter_20_0 ~= arg_20_1 then
			local var_20_6 = iter_20_1.units

			for iter_20_2, iter_20_3 in ipairs(var_20_6) do
				local var_20_7 = Level.unit_by_index(var_20_2, iter_20_3)

				Unit.set_unit_visibility(var_20_7, false)
			end

			iter_20_1.set_enabled = false
		elseif not var_20_5 and iter_20_0 == arg_20_1 then
			local var_20_8 = iter_20_1.units

			for iter_20_4, iter_20_5 in ipairs(var_20_8) do
				local var_20_9 = Level.unit_by_index(var_20_2, iter_20_5)

				Unit.set_unit_visibility(var_20_9, true)

				if Unit.has_data(var_20_9, "LevelEditor", "is_gizmo_unit") then
					local var_20_10 = Unit.get_data(var_20_9, "LevelEditor", "is_gizmo_unit")
					local var_20_11 = Unit.is_a(var_20_9, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe")

					if var_20_10 and not var_20_11 then
						Unit.flow_event(var_20_9, "hide_helper_mesh")
					end
				end
			end

			iter_20_1.set_enabled = true
		end
	end
end

HeroWindowItemCustomization._update_environment = function (arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0._preview_widget then
		return
	end

	local var_21_0 = arg_21_1 or "default"
	local var_21_1 = arg_21_0._preview_widget.content.object_set_data.world

	World.get_data(var_21_1, "shading_settings")[1] = arg_21_2 and "default" or var_21_0
end

HeroWindowItemCustomization._is_button_hover = function (arg_22_0, arg_22_1)
	return arg_22_1.content.button_hotspot.is_hover
end

HeroWindowItemCustomization._is_button_hover_enter = function (arg_23_0, arg_23_1)
	return arg_23_1.content.button_hotspot.on_hover_enter
end

HeroWindowItemCustomization._is_button_pressed = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1.content.button_hotspot

	if var_24_0.on_release then
		var_24_0.on_release = false

		return true
	end
end

HeroWindowItemCustomization._navigation_menu_disabled = function (arg_25_0)
	return arg_25_0._mission_selection_grid ~= nil
end

HeroWindowItemCustomization._handle_gamepad_input = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = arg_26_0._parent
	local var_26_1 = false
	local var_26_2 = arg_26_0:_navigation_menu_disabled()
	local var_26_3 = arg_26_0._widgets_by_name

	if not var_26_2 then
		local var_26_4 = arg_26_0._states[arg_26_0._state].gamepad_input_func

		if var_26_4 then
			var_26_1 = arg_26_0[var_26_4](arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		end

		if not var_26_1 then
			local var_26_5 = arg_26_1:get("move_up_hold_continuous")
			local var_26_6 = arg_26_1:get("move_down_hold_continuous")
			local var_26_7 = arg_26_0._input_index or 1

			if var_26_6 then
				var_26_7 = math.min(var_26_7 + 1, #arg_26_0._available_states)
			elseif var_26_5 then
				var_26_7 = math.max(var_26_7 - 1, 1)
			end

			if var_26_7 ~= arg_26_0._input_index then
				arg_26_0:_handle_new_selection(var_26_7)
				arg_26_0:_option_selected(arg_26_0._input_index)

				var_26_1 = true
			end

			local var_26_8 = arg_26_0._info_widgets_by_name.weapon_diagram

			if var_26_8 then
				var_26_8.content.show_info = not var_26_1 and arg_26_1:get("trigger_cycle_previous_hold")
			end

			if arg_26_0._material_items and arg_26_0._current_recipe_name and arg_26_0._has_all_crafting_requirements then
				local var_26_9 = var_26_3.craft_button
				local var_26_10 = var_26_3.experience_bar
				local var_26_11 = arg_26_0._craft_progress

				if var_26_9.content.visible then
					local var_26_12 = 2

					if not UIUtils.is_button_held(var_26_9) then
						if arg_26_1:get("refresh_hold") or arg_26_1:get("skip") then
							var_26_11 = math.clamp(var_26_11 + arg_26_2 * var_26_12, 0, 1)
						else
							var_26_11 = math.max(var_26_11 - arg_26_2 * var_26_12, 0)
						end
					end

					local var_26_13 = math.easeOutCubic(var_26_11)

					arg_26_0._ui_scenegraph.experience_bar.size[1] = 390 * var_26_13
					var_26_10.content.texture_id.uvs[2][1] = var_26_13
					var_26_10.content.visible = true

					if var_26_11 >= 1 then
						arg_26_0:_craft(arg_26_0._material_items, arg_26_0._current_recipe_name)

						var_26_11 = 0
					end

					arg_26_0._craft_progress = var_26_11
				end
			end
		end
	end
end

HeroWindowItemCustomization._handle_input = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_0._parent
	local var_27_1 = false
	local var_27_2 = arg_27_0._widgets_by_name
	local var_27_3

	for iter_27_0 = 1, #arg_27_0._available_states do
		local var_27_4 = var_27_2[arg_27_0._available_states[iter_27_0]]

		if not var_27_4.content.button_hotspot.is_selected and arg_27_0:_is_button_hover_enter(var_27_4) then
			arg_27_0:play_sound("Play_hud_hover")
		end

		if arg_27_0:_is_button_hover(var_27_4) then
			var_27_3 = iter_27_0
		end

		if arg_27_0:_is_button_pressed(var_27_4) then
			arg_27_0:_option_selected(iter_27_0)

			local var_27_5 = true
		end
	end

	local var_27_6 = arg_27_0:_get_item(arg_27_0._item_backend_id)
	local var_27_7 = var_27_6.key
	local var_27_8 = WeaponSkins.default_skins[var_27_7]
	local var_27_9 = var_27_6.skin
	local var_27_10 = arg_27_0._illusion_widgets
	local var_27_11 = arg_27_0._weapon_illusion_base_widgets_by_name.illusions_name.content
	local var_27_12
	local var_27_13

	for iter_27_1 = 1, #var_27_10 do
		local var_27_14 = var_27_10[iter_27_1]

		if UIUtils.is_button_hover(var_27_14) then
			var_27_13 = var_27_14.content.skin_key
		elseif UIUtils.is_button_selected(var_27_14) then
			var_27_12 = var_27_14.content.skin_key
		end
	end

	local var_27_15 = var_27_13 or var_27_12 or var_27_9 or var_27_8
	local var_27_16 = var_27_15 and WeaponSkins.skins[var_27_15]

	var_27_11.text = var_27_16 and Localize(var_27_16.display_name) or ""

	if arg_27_0._material_items and arg_27_0._current_recipe_name then
		local var_27_17 = var_27_2.craft_button
		local var_27_18 = var_27_2.experience_bar
		local var_27_19 = arg_27_0._craft_progress
		local var_27_20 = 2

		if not arg_27_1:get("refresh_hold") and not arg_27_1:get("skip") then
			if UIUtils.is_button_held(var_27_17) then
				var_27_19 = math.clamp(var_27_19 + arg_27_2 * var_27_20, 0, 1)

				if not arg_27_0._playing_craft_sound then
					arg_27_0:_play_sound("play_gui_craft_forge_button_begin_qol")

					arg_27_0._playing_craft_sound = true
				end
			else
				var_27_19 = math.max(var_27_19 - arg_27_2 * var_27_20, 0)

				if arg_27_0._playing_craft_sound and not arg_27_0._waiting_for_craft then
					arg_27_0:_play_sound("play_gui_craft_forge_button_aborted_qol")

					arg_27_0._playing_craft_sound = false
				end
			end
		end

		local var_27_21 = math.easeOutCubic(var_27_19)

		arg_27_0._ui_scenegraph.experience_bar.size[1] = 390 * var_27_21
		var_27_18.content.texture_id.uvs[2][1] = var_27_21
		var_27_18.content.visible = true

		if var_27_19 >= 1 then
			arg_27_0:_craft(arg_27_0._material_items, arg_27_0._current_recipe_name)

			var_27_19 = 0
		end

		arg_27_0._craft_progress = var_27_19
	end

	arg_27_0._hover_index = var_27_3
end

HeroWindowItemCustomization._update_active_preview = function (arg_28_0)
	local var_28_0 = arg_28_0._active_selection_index or arg_28_0._hover_index or arg_28_0._input_index

	arg_28_0._active_selector_preview = arg_28_0._available_states[var_28_0]
end

HeroWindowItemCustomization._option_selected = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._parent
	local var_29_1 = arg_29_0._available_states[arg_29_1]
	local var_29_2 = false
	local var_29_3 = arg_29_1 and arg_29_0._active_selection_index == arg_29_1

	if not arg_29_2 then
		arg_29_0:play_sound("Play_hud_select")
	end

	if not var_29_3 then
		var_29_2 = true

		arg_29_0:_change_state(var_29_1)
	end

	local var_29_4 = Managers.input:is_device_active("mouse")
	local var_29_5 = arg_29_0._active_selection_index

	arg_29_0._active_selection_index = var_29_2 and arg_29_1

	local var_29_6 = arg_29_0._widgets_by_name

	for iter_29_0 = 1, #arg_29_0._available_states do
		var_29_6[arg_29_0._available_states[iter_29_0]].style.hover_frame.saturated = var_29_2 and arg_29_1 == iter_29_0 or not var_29_4 and iter_29_0 == var_29_5
	end

	if var_29_2 then
		arg_29_0:_handle_new_selection(arg_29_0._active_selection_index)
	elseif arg_29_0._input_index and not Managers.input:is_device_active("gamepad") then
		arg_29_0:_handle_new_selection(nil)
	end
end

HeroWindowItemCustomization._setting_option_pressed = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_1.content
	local var_30_1 = var_30_0.num_options

	for iter_30_0 = 1, var_30_1 do
		local var_30_2 = var_30_0["button_hotspot_" .. iter_30_0]

		if var_30_2.on_release or var_30_2.is_selected then
			return var_30_0["option_key_" .. iter_30_0], var_30_2.marked
		end
	end
end

HeroWindowItemCustomization._set_setting_option_selected = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_1.content
	local var_31_1 = var_31_0.num_options

	if var_31_1 then
		for iter_31_0 = 1, var_31_1 do
			var_31_0["button_hotspot_" .. iter_31_0].is_selected = arg_31_3 or iter_31_0 == arg_31_2
		end
	end
end

HeroWindowItemCustomization._handle_new_selection = function (arg_32_0, arg_32_1)
	local var_32_0 = #arg_32_0._available_states

	arg_32_1 = arg_32_1 and math.clamp(arg_32_1, 1, var_32_0)

	local var_32_1 = Managers.input:is_device_active("mouse")
	local var_32_2 = arg_32_0._widgets_by_name

	for iter_32_0 = 1, #arg_32_0._available_states do
		local var_32_3 = var_32_2[arg_32_0._available_states[iter_32_0]]
		local var_32_4 = iter_32_0 == arg_32_1

		var_32_3.content.button_hotspot.is_selected = var_32_4 or iter_32_0 == arg_32_0._active_selection_index

		if not var_32_1 then
			var_32_3.style.hover_frame.saturated = not var_32_4
		end

		arg_32_0:_set_setting_option_selected(var_32_3, var_32_4 and 1, var_32_4)
	end

	if arg_32_1 and arg_32_0._input_index ~= arg_32_1 then
		arg_32_0:play_sound("Play_hud_hover")
	end

	arg_32_0._input_index = arg_32_1
end

HeroWindowItemCustomization._update_animations = function (arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._ui_animator

	var_33_0:update(arg_33_1)

	local var_33_1 = arg_33_0._animations

	for iter_33_0, iter_33_1 in pairs(var_33_1) do
		if var_33_0:is_animation_completed(iter_33_1) then
			var_33_0:stop_animation(iter_33_1)

			var_33_1[iter_33_0] = nil
		end
	end

	local var_33_2 = arg_33_0._ui_animations
	local var_33_3 = arg_33_0._animation_callbacks

	for iter_33_2, iter_33_3 in pairs(var_33_2) do
		UIAnimation.update(iter_33_3, arg_33_1)

		if UIAnimation.completed(iter_33_3) then
			var_33_2[iter_33_2] = nil

			if var_33_3[iter_33_2] then
				var_33_3[iter_33_2]()

				var_33_3[iter_33_2] = nil
			end
		end
	end

	local var_33_4 = arg_33_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_33_4.craft_button, arg_33_1)
	UIWidgetUtils.animate_game_option_button(var_33_4.item_setting, arg_33_1)
	UIWidgetUtils.animate_game_option_button(var_33_4.item_properties, arg_33_1)
	UIWidgetUtils.animate_game_option_button(var_33_4.item_trait, arg_33_1)
	UIWidgetUtils.animate_game_option_button(var_33_4.item_upgrade, arg_33_1)
	arg_33_0:_animate_state_transition(arg_33_1)
end

HeroWindowItemCustomization._animate_state_transition = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._state_transition_timer

	if not var_34_0 then
		return
	end

	local var_34_1 = arg_34_0._state
	local var_34_2 = arg_34_0._states[var_34_1]
	local var_34_3 = var_34_2.transition_time
	local var_34_4 = var_34_0 + arg_34_1
	local var_34_5 = math.clamp(var_34_4 / var_34_3, 0, 1)
	local var_34_6 = math.smoothstep(var_34_5, 0, 1)
	local var_34_7 = arg_34_0._state_start_fov

	if var_34_7 then
		local var_34_8 = var_34_7 + (var_34_2.fov - arg_34_0._state_start_fov) * var_34_6

		arg_34_0:_set_camera_fov(var_34_8)
	end

	local var_34_9 = arg_34_0._state_start_camera_position

	if var_34_9 then
		local var_34_10 = var_34_2.camera_position
		local var_34_11 = var_34_10 and var_34_10[1] or 0
		local var_34_12 = var_34_10 and var_34_10[2] or 0
		local var_34_13 = var_34_10 and var_34_10[3] or 0
		local var_34_14 = var_34_9[1]
		local var_34_15 = var_34_9[2]
		local var_34_16 = var_34_9[3]
		local var_34_17 = var_34_11 - var_34_14
		local var_34_18 = var_34_12 - var_34_15
		local var_34_19 = var_34_13 - var_34_16
		local var_34_20 = var_34_14 + var_34_17 * var_34_6
		local var_34_21 = var_34_15 + var_34_18 * var_34_6
		local var_34_22 = var_34_16 + var_34_19 * var_34_6

		if var_34_17 ~= 0 or var_34_18 ~= 0 or var_34_19 ~= 0 then
			local var_34_23 = Vector3(var_34_20, var_34_21, var_34_22)

			arg_34_0:_set_camera_position(var_34_23)
		end
	end

	arg_34_0._state_render_settings.alpha_multiplier = math.max(var_34_6, arg_34_0._state_render_settings.alpha_multiplier)

	if var_34_5 == 1 then
		arg_34_0._state_transition_timer = nil
	else
		arg_34_0._state_transition_timer = var_34_4
	end
end

HeroWindowItemCustomization._draw = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._ui_renderer
	local var_35_1 = arg_35_0._ui_top_renderer
	local var_35_2 = arg_35_0._ui_scenegraph
	local var_35_3 = arg_35_0._render_settings
	local var_35_4
	local var_35_5 = Managers.input:is_device_active("gamepad")
	local var_35_6 = var_35_3.alpha_multiplier or 1

	UIRenderer.begin_pass(var_35_1, var_35_2, arg_35_1, arg_35_2, var_35_4, var_35_3)

	local var_35_7 = arg_35_0._widgets

	for iter_35_0 = 1, #var_35_7 do
		local var_35_8 = var_35_7[iter_35_0]

		UIRenderer.draw_widget(var_35_1, var_35_8)
	end

	local var_35_9 = arg_35_0._state

	if var_35_9 then
		local var_35_10 = arg_35_0._states[var_35_9]

		if var_35_10.draw_function then
			var_35_3.alpha_multiplier = arg_35_0._state_render_settings.alpha_multiplier or 0

			arg_35_0[var_35_10.draw_function](arg_35_0, var_35_1, arg_35_2)

			var_35_3.alpha_multiplier = var_35_6
		end
	end

	var_35_3.alpha_multiplier = arg_35_0._state_render_settings.alpha_multiplier or 0

	for iter_35_1, iter_35_2 in ipairs(arg_35_0._crafting_widgets) do
		UIRenderer.draw_widget(var_35_1, iter_35_2)
	end

	var_35_3.alpha_multiplier = var_35_6

	if arg_35_0._previewer then
		UIRenderer.draw_widget(var_35_1, arg_35_0._preview_widget)
	end

	UIRenderer.end_pass(var_35_1)

	var_35_3.alpha_multiplier = var_35_6

	if var_35_5 then
		arg_35_0._menu_input_description:draw(var_35_1, arg_35_2)
	end
end

HeroWindowItemCustomization._state_draw_overview = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0._info_widgets

	if var_36_0 then
		for iter_36_0, iter_36_1 in ipairs(var_36_0) do
			UIRenderer.draw_widget(arg_36_1, iter_36_1)
		end
	end

	local var_36_1 = arg_36_0._illusion_widgets

	if var_36_1 and #var_36_1 > 0 then
		local var_36_2 = arg_36_0._weapon_illusion_base_widgets

		for iter_36_2, iter_36_3 in ipairs(var_36_2) do
			UIRenderer.draw_widget(arg_36_1, iter_36_3)
		end

		for iter_36_4, iter_36_5 in ipairs(var_36_1) do
			UIRenderer.draw_widget(arg_36_1, iter_36_5)
		end

		local var_36_3 = arg_36_0._illusion_widgets

		for iter_36_6, iter_36_7 in ipairs(var_36_3) do
			if arg_36_0:_is_button_pressed(iter_36_7) then
				arg_36_0:_on_illusion_index_pressed(iter_36_6)

				break
			elseif arg_36_0:_is_button_hover_enter(iter_36_7) then
				arg_36_0:_play_sound("play_gui_equipment_inventory_hover")
			end
		end
	end
end

HeroWindowItemCustomization._state_draw_property_reroll = function (arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0._property_reroll_widgets

	if var_37_0 then
		for iter_37_0, iter_37_1 in ipairs(var_37_0) do
			UIRenderer.draw_widget(arg_37_1, iter_37_1)
		end

		local var_37_1 = arg_37_0._property_reroll_option_widgets

		if var_37_1 then
			for iter_37_2, iter_37_3 in ipairs(var_37_1) do
				UIRenderer.draw_widget(arg_37_1, iter_37_3)
			end
		end

		local var_37_2 = arg_37_0._material_widgets

		if var_37_2 then
			for iter_37_4, iter_37_5 in ipairs(var_37_2) do
				UIRenderer.draw_widget(arg_37_1, iter_37_5)
			end
		end
	end
end

HeroWindowItemCustomization._handle_gamepad_activity = function (arg_38_0)
	local var_38_0 = arg_38_0.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not arg_38_0.gamepad_active_last_frame or var_38_0 then
			arg_38_0.gamepad_active_last_frame = true

			local var_38_1 = arg_38_0._widgets_by_name

			if not arg_38_0._input_index then
				arg_38_0._input_index = arg_38_0._input_index or 1

				arg_38_0:_handle_new_selection(arg_38_0._input_index)
			end
		end
	elseif arg_38_0.gamepad_active_last_frame or var_38_0 then
		arg_38_0.gamepad_active_last_frame = false

		local var_38_2 = arg_38_0._widgets_by_name

		if not arg_38_0._active_selection_index then
			arg_38_0:_handle_new_selection(nil)
		end
	end
end

HeroWindowItemCustomization._update_item_rarity = function (arg_39_0)
	local var_39_0 = arg_39_0:_get_item(arg_39_0._item_backend_id)
	local var_39_1 = var_39_0.data
	local var_39_2 = var_39_0.rarity or var_39_1.rarity
	local var_39_3 = arg_39_0._widgets_by_name
	local var_39_4 = var_39_3.rarity_display.content.texture_id
	local var_39_5 = 0
	local var_39_6 = UISettings.item_rarity_order[var_39_2]
	local var_39_7 = UISettings.item_rarities
	local var_39_8 = table.index_of(var_39_7, var_39_2)

	for iter_39_0 = 1, #var_39_7 do
		local var_39_9 = var_39_7[iter_39_0]
		local var_39_10
		local var_39_11 = var_39_8 < iter_39_0 and "item_tier_empty" or "item_tier_" .. var_39_9

		if UIAtlasHelper.has_texture_by_name(var_39_11) then
			var_39_5 = var_39_5 + 1
			var_39_4[var_39_5] = var_39_11
		end
	end

	local var_39_12 = Colors.get_color_table_with_alpha(var_39_2, 255)
	local var_39_13 = var_39_3.item_setting
	local var_39_14 = var_39_13.content
	local var_39_15 = var_39_13.style.input_text
	local var_39_16 = 0.8
	local var_39_17 = {
		255,
		math.floor(var_39_12[2] * var_39_16),
		math.floor(var_39_12[3] * var_39_16),
		math.floor(var_39_12[4] * var_39_16)
	}

	var_39_15.text_color = var_39_17
	var_39_15.default_text_color = var_39_17
	var_39_15.select_text_color = var_39_12
end

HeroWindowItemCustomization._update_property_option = function (arg_40_0)
	local var_40_0 = arg_40_0:_get_item(arg_40_0._item_backend_id).properties

	if var_40_0 then
		local var_40_1 = arg_40_0._widgets_by_name.item_properties.content
		local var_40_2 = 0

		for iter_40_0, iter_40_1 in pairs(var_40_0) do
			var_40_2 = var_40_2 + 1

			local var_40_3 = WeaponProperties.properties[iter_40_0].buff_name
			local var_40_4

			var_40_4 = BuffUtils.get_buff_template(var_40_3).buffs[1].variable_multiplier ~= nil

			local var_40_5, var_40_6 = UIUtils.get_property_description(iter_40_0, iter_40_1)
			local var_40_7 = "button_hotspot_" .. var_40_2
			local var_40_8 = "option_text_" .. var_40_2

			var_40_1[var_40_7].disable_button = false
			var_40_1[var_40_8] = var_40_5
		end
	end
end

HeroWindowItemCustomization._update_upgrade_option = function (arg_41_0)
	local var_41_0 = arg_41_0._ui_top_renderer
	local var_41_1 = arg_41_0._ui_scenegraph
	local var_41_2 = arg_41_0:_get_item(arg_41_0._item_backend_id)
	local var_41_3 = var_41_2.data
	local var_41_4 = var_41_2.rarity or var_41_3.rarity
	local var_41_5 = arg_41_0._widgets_by_name.item_upgrade
	local var_41_6 = var_41_5.scenegraph_id
	local var_41_7 = var_0_4[var_41_6].size
	local var_41_8 = var_41_7[2]
	local var_41_9 = var_41_5.content
	local var_41_10 = var_41_5.style
	local var_41_11 = ""
	local var_41_12 = Colors.get_color_table_with_alpha("plentiful", 255)
	local var_41_13 = {}

	if var_41_4 == "plentiful" then
		local var_41_14 = Localize("forge_screen_common_token_tooltip")

		var_41_12 = Colors.get_color_table_with_alpha("common", 255)
		var_41_13[1] = "icon_add_property"
	elseif var_41_4 == "common" then
		local var_41_15 = Localize("forge_screen_rare_token_tooltip")

		var_41_12 = Colors.get_color_table_with_alpha("rare", 255)
		var_41_13[1] = "icon_add_property"
	elseif var_41_4 == "rare" then
		local var_41_16 = Localize("forge_screen_exotic_token_tooltip")

		var_41_12 = Colors.get_color_table_with_alpha("exotic", 255)
		var_41_13[1] = "icon_add_trait"
	elseif var_41_4 == "exotic" then
		var_41_13[1] = "icon_upgrade_property"
		var_41_13[2] = "icon_upgrade_property"

		local var_41_17 = Localize("difficulty_veteran")

		var_41_12 = Colors.get_color_table_with_alpha("unique", 255)
	end

	local var_41_18 = Localize("upgrade_description_text_" .. var_41_4)

	var_41_9.sub_title = var_41_18
	var_41_9.locked = var_41_4 == "unique" or var_41_4 == "default"
	var_41_9.input_text_locked = var_41_4 == "unique" and string.upper(Localize("menu_weave_forge_upgrade_loadout_button_cap")) or Localize("search_filter_locked")

	if var_41_12 then
		local var_41_19 = 0.8
		local var_41_20 = var_41_10.sub_title
		local var_41_21 = {
			255,
			math.floor(var_41_12[1] * var_41_19),
			math.floor(var_41_12[2] * var_41_19),
			math.floor(var_41_12[3] * var_41_19)
		}

		var_41_20.text_color = var_41_12
		var_41_20.default_text_color = var_41_21
		var_41_20.select_text_color = var_41_21
	end

	local var_41_22 = var_41_10.sub_title
	local var_41_23 = var_41_8 + (math.floor(UIUtils.get_text_height(var_41_0, var_41_7, var_41_22, var_41_18)) + 50)

	var_41_10.title_text.size[2] = var_41_23
	var_41_10.title_text_shadow.size[2] = var_41_23
	var_41_10.input_text.size[2] = var_41_23
	var_41_10.input_text_shadow.size[2] = var_41_23
	var_41_10.input_text_locked.size[2] = var_41_23
	var_41_10.input_text_locked_shadow.size[2] = var_41_23
	var_41_10.sub_title.size[2] = var_41_23
	var_41_10.sub_title_shadow.size[2] = var_41_23
	var_41_1[var_41_6].size[2] = var_41_23
end

HeroWindowItemCustomization._update_trait_option = function (arg_42_0)
	local var_42_0 = arg_42_0._ui_top_renderer
	local var_42_1 = arg_42_0._ui_scenegraph
	local var_42_2 = arg_42_0:_get_item(arg_42_0._item_backend_id).traits
	local var_42_3 = arg_42_0._widgets_by_name.item_trait
	local var_42_4 = var_42_3.scenegraph_id
	local var_42_5 = var_0_4[var_42_4].size
	local var_42_6 = var_42_5[2]

	if var_42_2 then
		local var_42_7 = var_42_3.content
		local var_42_8 = var_42_3.style

		for iter_42_0, iter_42_1 in ipairs(var_42_2) do
			local var_42_9 = WeaponTraits.traits[iter_42_1]
			local var_42_10 = var_42_9.display_name
			local var_42_11 = var_42_9.advanced_description
			local var_42_12 = var_42_9.icon
			local var_42_13 = Localize(var_42_10)
			local var_42_14 = UIUtils.get_trait_description(iter_42_1)

			var_42_7.icon_texture = var_42_12
			var_42_7.input_text = var_42_13
			var_42_7.sub_title = var_42_14
			var_42_7.locked = false

			local var_42_15 = var_42_8.sub_title

			var_42_6 = var_42_6 + math.floor(UIUtils.get_text_height(var_42_0, var_42_5, var_42_15, var_42_14))

			if var_42_6 ~= var_42_7.size[2] then
				-- Nothing
			end

			var_42_8.title_text.size[2] = var_42_6
			var_42_8.title_text_shadow.size[2] = var_42_6
			var_42_8.input_text.size[2] = var_42_6
			var_42_8.input_text_shadow.size[2] = var_42_6
			var_42_8.sub_title.size[2] = var_42_6
			var_42_8.sub_title_shadow.size[2] = var_42_6
		end
	end

	local var_42_16 = var_42_1[var_42_4].size
	local var_42_17 = var_42_1[var_42_4].local_position

	var_42_16[2] = var_42_6
	var_42_17[2] = -var_42_6
end

HeroWindowItemCustomization._present_item = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	arg_43_0._item_dirty = true

	arg_43_0:_spawn_item_unit(arg_43_1, arg_43_2, arg_43_3)

	local var_43_0, var_43_1, var_43_2, var_43_3 = UIUtils.get_ui_information_from_item(arg_43_1)
	local var_43_4 = arg_43_1.data
	local var_43_5 = var_43_4.item_type
	local var_43_6 = var_43_4.slot_type
	local var_43_7 = arg_43_1.backend_id
	local var_43_8 = BackendUtils.get_item_template(var_43_4, var_43_7)
	local var_43_9 = arg_43_1.rarity or var_43_4.rarity
	local var_43_10 = arg_43_1.power_level
	local var_43_11 = false

	if var_43_9 == "plentiful" or var_43_9 == "common" or var_43_9 == "rare" or var_43_9 == "exotic" then
		local var_43_12 = true
	end

	local var_43_13 = UISettings.item_rarity_textures[var_43_9]
	local var_43_14 = arg_43_0._widgets_by_name.item_setting.content

	var_43_14.input_text = Localize(var_43_1)
	var_43_14.sub_title = Localize(var_43_6)
	var_43_14.icon_texture = var_43_0 or "icons_placeholder"
	var_43_14.icon_bg = var_43_13 or "icons_placeholder"
	var_43_14.item = arg_43_1

	local var_43_15 = var_43_4.item_preview_object_set_name or "flow_weapon_lights"
	local var_43_16 = var_43_4.item_preview_environment or "weapons_default_01"

	arg_43_0:_show_object_set(var_43_15)
	arg_43_0:_update_environment(var_43_16)
end

HeroWindowItemCustomization._spawn_item_unit = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if arg_44_0._previewer then
		arg_44_0._previewer:destroy()
	end

	local var_44_0 = arg_44_1.data
	local var_44_1 = arg_44_1.key or var_44_0.key
	local var_44_2 = arg_44_0._preview_widget.element.pass_data[1]
	local var_44_3 = var_44_2.viewport
	local var_44_4 = var_44_2.world
	local var_44_5 = arg_44_3 or {
		0,
		1,
		0
	}
	local var_44_6
	local var_44_7
	local var_44_8
	local var_44_9
	local var_44_10
	local var_44_11 = arg_44_0._career_name
	local var_44_12 = LootItemUnitPreviewer:new(arg_44_1, var_44_5, var_44_4, var_44_3, var_44_6, var_44_7, var_44_8, var_44_9, var_44_10, var_44_11)
	local var_44_13 = callback(arg_44_0, "cb_on_item_loaded", var_44_1, arg_44_2)

	var_44_12:register_spawn_callback(var_44_13)

	arg_44_0._previewer = var_44_12
end

HeroWindowItemCustomization.cb_on_item_loaded = function (arg_45_0, arg_45_1, arg_45_2)
	print("cb_on_item_loaded", arg_45_1)
	arg_45_0._previewer:present_item(arg_45_1, arg_45_2)
end

HeroWindowItemCustomization._select_illusion_by_key = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	if not arg_46_1 then
		return
	end

	local var_46_0 = arg_46_0._illusion_widgets

	for iter_46_0, iter_46_1 in ipairs(var_46_0) do
		if iter_46_1.content.skin_key == arg_46_1 then
			arg_46_0:_on_illusion_index_pressed(iter_46_0, arg_46_2, arg_46_3)

			break
		end
	end
end

HeroWindowItemCustomization._on_illusion_index_pressed = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = arg_47_0._illusion_widgets[arg_47_1].content
	local var_47_1 = var_47_0.skin_key

	arg_47_0._skin_dirty = false

	if not arg_47_2 then
		local var_47_2 = var_47_0.locked
		local var_47_3 = ItemMasterList[var_47_1]
		local var_47_4 = {
			data = var_47_3,
			skin = var_47_1
		}

		arg_47_0:_spawn_item_unit(var_47_4, true)
		table.clear(arg_47_0._material_items)

		if not var_47_2 then
			local var_47_5 = arg_47_0:_get_item(arg_47_0._item_backend_id)
			local var_47_6 = var_47_5.key
			local var_47_7 = WeaponSkins.default_skins[var_47_6]

			if var_47_1 ~= (var_47_5.skin or var_47_7) then
				local var_47_8, var_47_9 = Managers.backend:get_interface("items"):get_weapon_skin_from_skin_key(var_47_1)

				arg_47_0._material_items[#arg_47_0._material_items + 1] = var_47_8

				arg_47_0:_enable_craft_button(true, true)

				arg_47_0._skin_dirty = true
			else
				arg_47_0:_enable_craft_button(false)
			end
		else
			arg_47_0:_enable_craft_button(false)
		end
	end

	local var_47_10 = arg_47_0._weapon_illusion_base_widgets_by_name
	local var_47_11 = WeaponSkins.skins[var_47_1]

	var_47_10.illusions_name.content.text = Localize(var_47_11.display_name)

	local var_47_12 = arg_47_0._illusion_widgets

	for iter_47_0, iter_47_1 in ipairs(var_47_12) do
		local var_47_13 = iter_47_0 == arg_47_1
		local var_47_14 = iter_47_1.content

		var_47_14.button_hotspot.is_selected = var_47_13

		if arg_47_3 then
			var_47_14.equipped = var_47_13
		end
	end

	arg_47_0._selected_skin_index = arg_47_1

	arg_47_0:_play_sound("play_gui_equipment_equip")
end

local function var_0_20(arg_48_0, arg_48_1)
	local var_48_0 = WeaponSkins.skins
	local var_48_1 = UISettings.item_rarity_order
	local var_48_2 = arg_48_0.content
	local var_48_3 = arg_48_1.content
	local var_48_4 = var_48_2.rarity
	local var_48_5 = var_48_3.rarity

	return (var_48_1[var_48_4] or 0) > (var_48_1[var_48_5] or 0)
end

local var_0_21 = {}

HeroWindowItemCustomization._setup_illusions = function (arg_49_0, arg_49_1)
	local var_49_0 = arg_49_1.key
	local var_49_1 = arg_49_1.data
	local var_49_2 = 0
	local var_49_3 = var_49_1.skin_combination_table
	local var_49_4 = WeaponSkins.skin_combinations[var_49_3] or var_0_21
	local var_49_5 = Managers.backend:get_interface("quests")
	local var_49_6 = Managers.backend:get_interface("crafting"):get_unlocked_weapon_skins()
	local var_49_7 = string.gsub(arg_49_1.ItemId, "^vs_", "")
	local var_49_8 = WeaponSkins.default_skins[var_49_7]
	local var_49_9
	local var_49_10 = 51
	local var_49_11 = -5
	local var_49_12 = -var_49_11
	local var_49_13 = {}
	local var_49_14 = {}
	local var_49_15 = RaritySettings
	local var_49_16 = var_0_16()

	for iter_49_0, iter_49_1 in pairs(var_49_4) do
		for iter_49_2, iter_49_3 in ipairs(iter_49_1) do
			if not var_49_14[iter_49_3] then
				if not var_49_15[iter_49_0] then
					local var_49_17 = WeaponSkins.skins[iter_49_3]

					iter_49_0 = var_49_17 and var_49_17.rarity or iter_49_0
				end

				local var_49_18 = var_49_6[iter_49_3] or iter_49_3 == var_49_8
				local var_49_19 = true
				local var_49_20 = (ItemMasterList[iter_49_3] or var_0_21).event_quest_requirement

				if not var_49_18 and var_49_20 then
					var_49_19 = var_49_5:get_quest_key(var_49_20)
				end

				if var_49_19 then
					local var_49_21 = "button_illusion_" .. iter_49_0

					if not UIAtlasHelper.has_texture_by_name(var_49_21) then
						var_49_21 = "button_illusion_default"
					end

					if var_49_18 then
						var_49_2 = var_49_2 + 1
					else
						var_49_21 = "button_illusion_locked"
					end

					local var_49_22 = UIWidget.init(var_49_16)

					var_49_13[#var_49_13 + 1] = var_49_22

					local var_49_23 = var_49_22.content

					var_49_23.skin_key = iter_49_3
					var_49_23.icon_texture = var_49_21
					var_49_23.locked = not var_49_18
					var_49_23.rarity = iter_49_0
					var_49_12 = var_49_12 + var_49_11 + var_49_10
					var_49_14[iter_49_3] = true
				end
			end
		end
	end

	if var_49_8 and not var_49_14[var_49_8] then
		local var_49_24 = true
		local var_49_25 = "plentiful"
		local var_49_26 = "button_illusion_" .. var_49_25

		if not UIAtlasHelper.has_texture_by_name(var_49_26) then
			var_49_26 = "button_illusion_default"
		end

		local var_49_27 = UIWidget.init(var_49_16)

		var_49_13[#var_49_13 + 1] = var_49_27

		local var_49_28 = var_49_27.content

		var_49_28.skin_key = var_49_8
		var_49_28.icon_texture = var_49_26
		var_49_28.locked = not var_49_24
		var_49_28.rarity = var_49_25
		var_49_12 = var_49_12 + var_49_11 + var_49_10
		var_49_2 = var_49_2 + 1
	end

	table.sort(var_49_13, var_0_20)

	local var_49_29 = var_49_10 / 2

	for iter_49_4, iter_49_5 in ipairs(var_49_13) do
		iter_49_5.offset[1] = -var_49_12 / 2 + var_49_29
		var_49_29 = var_49_29 + var_49_10 + var_49_11
	end

	arg_49_0._illusion_widgets = var_49_13

	local var_49_30 = arg_49_1.skin or var_49_8
	local var_49_31 = true
	local var_49_32 = true

	arg_49_0:_select_illusion_by_key(var_49_30, var_49_31, var_49_32)

	arg_49_0._weapon_illusion_base_widgets_by_name.illusions_counter.content.text = "(" .. tostring(var_49_2) .. "/" .. tostring(#var_49_13) .. ")"
end

HeroWindowItemCustomization._state_setup_overview = function (arg_50_0)
	local var_50_0 = {}
	local var_50_1 = {}

	for iter_50_0, iter_50_1 in pairs(var_0_8) do
		local var_50_2 = UIWidget.init(iter_50_1)

		var_50_0[#var_50_0 + 1] = var_50_2
		var_50_1[iter_50_0] = var_50_2
	end

	arg_50_0._info_widgets = var_50_0
	arg_50_0._info_widgets_by_name = var_50_1

	local var_50_3 = {}
	local var_50_4 = {}

	for iter_50_2, iter_50_3 in pairs(var_0_9) do
		local var_50_5 = UIWidget.init(iter_50_3)

		var_50_3[#var_50_3 + 1] = var_50_5
		var_50_4[iter_50_2] = var_50_5
	end

	arg_50_0._weapon_illusion_base_widgets = var_50_3
	arg_50_0._weapon_illusion_base_widgets_by_name = var_50_4

	local var_50_6 = arg_50_0:_get_item(arg_50_0._item_backend_id)
	local var_50_7, var_50_8, var_50_9, var_50_10 = UIUtils.get_ui_information_from_item(var_50_6)
	local var_50_11 = var_50_6.data
	local var_50_12 = var_50_11.slot_type
	local var_50_13 = var_50_6.backend_id
	local var_50_14 = BackendUtils.get_item_template(var_50_11, var_50_13)

	if not var_50_6.rarity then
		local var_50_15 = var_50_11.rarity
	end

	local var_50_16 = var_50_6.power_level
	local var_50_17 = {}
	local var_50_18 = arg_50_0:_create_item_feature_widget(Localize("tooltips_power"), var_50_16)

	var_50_17[#var_50_17 + 1] = var_50_18

	local var_50_19 = var_50_12 == "melee" or var_50_12 == "ranged"

	if var_50_19 then
		local var_50_20 = var_50_14.tooltip_keywords

		if var_50_20 then
			local var_50_21 = ""
			local var_50_22 = #var_50_20

			for iter_50_4, iter_50_5 in ipairs(var_50_20) do
				var_50_21 = var_50_21 .. Localize(iter_50_5)
				var_50_22 = var_50_22 - 1

				if var_50_22 > 0 then
					var_50_21 = var_50_21 .. ", "
				end
			end

			local var_50_23 = {
				word_wrap = true,
				font_size = 28,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			}
			local var_50_24, var_50_25 = arg_50_0:_create_description_widget("info_keyword_text", var_50_21, var_50_23)

			var_50_0[#var_50_0 + 1] = var_50_24
		end
	else
		arg_50_0._ui_scenegraph.info_keyword_text.size[2] = 0
	end

	arg_50_0._info_widgets_by_name.keyword_divider_top.content.visible = var_50_19

	if var_50_12 == "melee" then
		local var_50_26 = var_50_14.block_angle
		local var_50_27 = arg_50_0:_create_item_feature_widget(Localize("tutorial_tooltip_block"), var_50_26)

		var_50_17[#var_50_17 + 1] = var_50_27

		local var_50_28 = var_50_14.max_fatigue_points
		local var_50_29 = arg_50_0:_create_item_feature_widget(Localize("tooltips_stamina"), var_50_28)

		var_50_17[#var_50_17 + 1] = var_50_29
	elseif var_50_12 == "ranged" then
		local var_50_30
		local var_50_31
		local var_50_32 = var_50_14.ammo_data

		if var_50_32 and not var_50_32.hide_ammo_ui then
			local var_50_33 = var_50_32.single_clip
			local var_50_34 = var_50_32.reload_time
			local var_50_35 = var_50_32.max_ammo
			local var_50_36 = var_50_32.ammo_per_clip

			var_50_30 = tostring(var_50_35)
		else
			var_50_31 = "icon_fire"
		end

		local var_50_37 = arg_50_0:_create_item_feature_widget(Localize("tooltips_ammunition"), var_50_30, var_50_31)

		var_50_17[#var_50_17 + 1] = var_50_37

		local var_50_38 = UISettings.crosshair_styles.ranged[var_50_14.crosshair_style] or UISettings.crosshair_types.default
		local var_50_39 = arg_50_0:_create_item_feature_widget("Crosshair", nil, var_50_38.crosshair_icon)

		var_50_17[#var_50_17 + 1] = var_50_39
	end

	local var_50_40 = #var_50_17

	for iter_50_6 = 1, var_50_40 do
		local var_50_41 = var_50_17[iter_50_6]

		var_50_41.offset[1] = var_50_41.content.size[1] * (iter_50_6 - 1)
		var_50_0[#var_50_0 + 1] = var_50_41
	end

	if var_50_19 then
		local var_50_42 = arg_50_0:_create_weapon_diagram_widget(var_50_14)

		var_50_0[#var_50_0 + 1] = var_50_42
		var_50_1.weapon_diagram = var_50_42
	end

	local var_50_43, var_50_44 = arg_50_0:_create_description_widget("info_description_text", Localize(var_50_9))

	var_50_0[#var_50_0 + 1] = var_50_43
	arg_50_0._ui_scenegraph.info_description_text.local_position[2] = -(var_50_44[2] + 10)
	arg_50_0._ui_scenegraph.keyword_divider_bottom.local_position[2] = var_50_19 and -10 or 350

	arg_50_0:_destroy_scrollbar()
	arg_50_0:_setup_illusions(var_50_6)

	arg_50_0._current_recipe_name = "apply_weapon_skin"

	arg_50_0:_update_state_craft_button(arg_50_0._current_recipe_name, Localize("input_description_apply"), nil, nil, {
		0,
		-40,
		0
	})
	arg_50_0:_enable_craft_button(false)
	arg_50_0._menu_input_description:change_generic_actions(var_0_18.default)
end

HeroWindowItemCustomization._state_setup_property_reroll = function (arg_51_0)
	local var_51_0 = {}
	local var_51_1 = {}

	for iter_51_0, iter_51_1 in pairs(var_0_12) do
		local var_51_2 = UIWidget.init(iter_51_1)

		var_51_0[#var_51_0 + 1] = var_51_2
		var_51_1[iter_51_0] = var_51_2
	end

	arg_51_0._property_reroll_widgets = var_51_0
	arg_51_0._property_reroll_widgets_by_name = var_51_1

	local var_51_3 = arg_51_0:_get_item(arg_51_0._item_backend_id)
	local var_51_4 = var_51_3.data
	local var_51_5 = var_51_4.slot_type
	local var_51_6 = var_51_3.rarity or var_51_4.rarity
	local var_51_7 = var_51_4.property_table_name

	if not var_51_7 then
		return
	end

	local var_51_8 = {}
	local var_51_9 = 45
	local var_51_10 = 30
	local var_51_11 = var_51_9
	local var_51_12 = WeaponProperties.combinations[var_51_7]
	local var_51_13 = var_51_12[var_51_6] or var_51_12.common

	for iter_51_2, iter_51_3 in pairs(WeaponProperties.properties) do
		local var_51_14 = false

		for iter_51_4, iter_51_5 in ipairs(var_51_13) do
			if table.contains(iter_51_5, iter_51_2) then
				var_51_14 = true

				break
			end
		end

		if var_51_14 then
			local var_51_15 = iter_51_3.buff_name
			local var_51_16

			var_51_16 = BuffUtils.get_buff_template(var_51_15).buffs[1].variable_multiplier ~= nil

			local var_51_17 = iter_51_3.display_name
			local var_51_18 = 1
			local var_51_19, var_51_20 = UIUtils.get_property_description(iter_51_2, var_51_18)
			local var_51_21 = string.gsub(var_51_19, "%d", "")
			local var_51_22 = string.gsub(var_51_21, "%p", "")
			local var_51_23 = var_51_22
			local var_51_24 = arg_51_0:_create_property_option_entry(var_51_22, var_51_20)

			var_51_8[#var_51_8 + 1] = var_51_24
			var_51_24.offset[2] = -var_51_11
			var_51_11 = var_51_11 + var_51_10
		end
	end

	local var_51_25 = var_51_11 - var_51_9

	arg_51_0._property_reroll_option_widgets = var_51_8

	local var_51_26, var_51_27 = arg_51_0:_create_description_widget("info_description_text_2", Localize("description_crafting_recipe_weapon_reroll_properties"))

	var_51_0[#var_51_0 + 1] = var_51_26

	local var_51_28 = var_51_27[2] + 10

	arg_51_0._ui_scenegraph.info_description_text_2.local_position[2] = -var_51_28

	local var_51_29 = var_51_10 * 2

	arg_51_0:_initialize_scrollbar(var_51_25, var_51_29)

	local var_51_30 = arg_51_0._states[arg_51_0._state].recipe_by_slot_type[var_51_5]

	arg_51_0._current_recipe_name = var_51_30

	arg_51_0:_update_state_craft_button(var_51_30, Localize("crafting_recipe_weapon_reroll_properties"), Colors.get_color_table_with_alpha("corn_flower_blue", 255))
	arg_51_0._menu_input_description:change_generic_actions(var_0_18[arg_51_0._state])
end

HeroWindowItemCustomization._enable_craft_button = function (arg_52_0, arg_52_1, arg_52_2)
	if script_data["eac-untrusted"] then
		arg_52_1 = false
	end

	local var_52_0 = arg_52_0._widgets_by_name

	var_52_0.button_top_edge_left.content.visible = not arg_52_2 and arg_52_1 or false
	var_52_0.button_top_edge_right.content.visible = not arg_52_2 and arg_52_1 or false
	var_52_0.button_top_edge_glow.content.visible = not arg_52_2 and arg_52_1 or false

	local var_52_1 = var_52_0.craft_button

	var_52_1.content.visible = arg_52_1
	var_52_1.content.button_hotspot.disable_button = not arg_52_1
	var_52_0.experience_bar.content.visible = arg_52_1
	var_52_0.experience_bar_edge.content.visible = arg_52_1

	if not arg_52_1 then
		arg_52_0._menu_input_description:change_generic_actions(var_0_18.default)
	else
		arg_52_0._menu_input_description:change_generic_actions(var_0_18[arg_52_0._state])
	end
end

HeroWindowItemCustomization._update_state_craft_button = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	local var_53_0, var_53_1 = arg_53_0:_create_material_requirement_widgets(arg_53_1)
	local var_53_2 = math.max(var_53_1 + 30, 100)
	local var_53_3 = arg_53_0._widgets_by_name
	local var_53_4 = var_53_3.button_top_edge_left
	local var_53_5 = var_53_3.button_top_edge_right
	local var_53_6 = var_53_3.button_top_edge_glow

	var_53_4.offset[1] = -var_53_2 / 2
	var_53_5.offset[1] = var_53_2 / 2
	arg_53_0._ui_scenegraph.button_top_edge_glow.size[1] = var_53_2

	if arg_53_3 then
		var_53_6.style.texture_id.color = arg_53_3
	end

	local var_53_7 = var_53_3.craft_button

	var_53_7.content.button_hotspot.disable_button = arg_53_4 or not var_53_0 or script_data["eac-untrusted"]
	var_53_7.content.title_text = arg_53_2
	arg_53_0._has_all_crafting_requirements = var_53_0

	local var_53_8 = true

	var_53_4.content.visible = var_53_8
	var_53_5.content.visible = var_53_8
	var_53_6.content.visible = var_53_8
	var_53_7.content.visible = var_53_8
	arg_53_0._ui_scenegraph.craft_button.local_position = arg_53_5 or {
		0,
		0,
		0
	}
end

local var_0_22 = {
	0,
	0,
	0,
	0,
	0
}

HeroWindowItemCustomization._create_weapon_diagram_widget = function (arg_54_0, arg_54_1)
	local var_54_0 = 0.25
	local var_54_1 = 8
	local var_54_2 = (1 - var_54_0) / var_54_1
	local var_54_3 = 0.0125
	local var_54_4 = {}
	local var_54_5 = arg_54_1.weapon_diagram
	local var_54_6 = var_54_5 and var_54_5.light_attack

	if not var_54_6 then
		Application.error(string.format("[HeroWindowItemCustomization] Missing light attack weapon diagram data for %q - Defaulting to zeros", arg_54_1.name))

		var_54_6 = var_0_22
	end

	local var_54_7 = math.clamp(math.floor(var_54_6[DamageTypes.ARMOR_PIERCING] + 0.5), 0, var_54_1 - 1)
	local var_54_8 = math.clamp(math.floor(var_54_6[DamageTypes.CLEAVE] + 0.5), 0, var_54_1 - 1)
	local var_54_9 = math.clamp(math.floor(var_54_6[DamageTypes.SPEED] + 0.5), 0, var_54_1 - 1)
	local var_54_10 = math.clamp(math.floor(var_54_6[DamageTypes.STAGGER] + 0.5), 0, var_54_1 - 1)
	local var_54_11 = math.clamp(math.floor(var_54_6[DamageTypes.DAMAGE] + 0.5), 0, var_54_1 - 1)

	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_7 + var_54_7 * var_54_3
	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_8 + var_54_8 * var_54_3
	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_9 + var_54_9 * var_54_3
	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_10 + var_54_10 * var_54_3
	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_11 + var_54_11 * var_54_3

	local var_54_12 = var_54_5 and var_54_5.heavy_attack

	if not var_54_12 then
		Application.error(string.format("[HeroWindowItemCustomization] Missing heavy attack weapon diagram data for %q - Defaulting to zeros", arg_54_1.name))

		var_54_12 = var_0_22
	end

	local var_54_13 = math.clamp(math.floor(var_54_12[DamageTypes.ARMOR_PIERCING] + 0.5), 0, var_54_1 - 1)
	local var_54_14 = math.clamp(math.floor(var_54_12[DamageTypes.CLEAVE] + 0.5), 0, var_54_1 - 1)
	local var_54_15 = math.clamp(math.floor(var_54_12[DamageTypes.SPEED] + 0.5), 0, var_54_1 - 1)
	local var_54_16 = math.clamp(math.floor(var_54_12[DamageTypes.STAGGER] + 0.5), 0, var_54_1 - 1)
	local var_54_17 = math.clamp(math.floor(var_54_12[DamageTypes.DAMAGE] + 0.5), 0, var_54_1 - 1)

	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_13 + var_54_13 * var_54_3
	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_14 + var_54_14 * var_54_3
	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_15 + var_54_15 * var_54_3
	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_16 + var_54_16 * var_54_3
	var_54_4[#var_54_4 + 1] = var_54_0 + var_54_2 * var_54_17 + var_54_17 * var_54_3

	local var_54_18 = false
	local var_54_19 = "weapon_stats_diagram"
	local var_54_20 = var_0_4[var_54_19].size
	local var_54_21 = UIWidgets.create_weapon_diagram_widget("weapon_stats_diagram", var_54_20, var_54_4, var_54_18, var_54_0)

	return UIWidget.init(var_54_21), var_54_20
end

HeroWindowItemCustomization._create_item_feature_widget = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0 = false
	local var_55_1 = "item_feature"
	local var_55_2 = var_0_4[var_55_1].size
	local var_55_3 = UIWidgets.create_item_feature(var_55_1, var_55_2, arg_55_1, arg_55_2, arg_55_3, var_55_0)

	return UIWidget.init(var_55_3), var_55_2
end

HeroWindowItemCustomization._create_description_widget = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = false

	arg_56_3 = arg_56_3 or {
		word_wrap = true,
		font_size = 20,
		localize = false,
		use_shadow = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = var_56_0 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			0,
			0,
			2
		}
	}

	local var_56_1 = UIWidgets.create_simple_text(arg_56_2, arg_56_1, nil, nil, arg_56_3)
	local var_56_2 = UIWidget.init(var_56_1)
	local var_56_3 = arg_56_0._ui_top_renderer
	local var_56_4 = var_0_4[arg_56_1].size
	local var_56_5

	var_56_5[2], var_56_5 = math.floor(UIUtils.get_text_height(var_56_3, var_56_4, arg_56_3, arg_56_2)), arg_56_0._ui_scenegraph[arg_56_1].size

	return var_56_2, var_56_5
end

HeroWindowItemCustomization._create_property_option_entry = function (arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = "property_options"
	local var_57_1 = arg_57_1 .. arg_57_2
	local var_57_2 = var_0_14(var_57_0, var_57_1)
	local var_57_3 = UIWidget.init(var_57_2)
	local var_57_4 = var_57_3.style.text
	local var_57_5 = var_57_4.color_override_table
	local var_57_6 = arg_57_2 and UTF8Utils.string_length(arg_57_2) or 0
	local var_57_7 = UTF8Utils.string_length(arg_57_1) or 0

	var_57_5.start_index = var_57_7 + 1
	var_57_5.end_index = var_57_7 + var_57_6
	var_57_4.color_override[1] = var_57_5

	return var_57_3
end

HeroWindowItemCustomization._set_scroll_area_height = function (arg_58_0, arg_58_1, arg_58_2)
	arg_58_0._ui_scenegraph.scroll_area.size[2] = arg_58_2
	arg_58_1.style.mask.size[2] = arg_58_2
end

HeroWindowItemCustomization._destroy_scrollbar = function (arg_59_0)
	if arg_59_0._scrollbar_logic then
		arg_59_0._scrollbar_logic = nil
	end

	arg_59_0._widgets_by_name.scrollbar.content.visible = false
end

HeroWindowItemCustomization._initialize_scrollbar = function (arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_0._widgets_by_name
	local var_60_1 = arg_60_0._ui_scenegraph

	UISceneGraph.update_scenegraph(var_60_1)

	local var_60_2 = var_60_1.info_window.world_position[2]
	local var_60_3 = var_60_1.property_options_title.world_position[2] - var_60_2
	local var_60_4 = var_60_3 < arg_60_1

	var_60_1.scrollbar.size[2] = var_60_3

	local var_60_5 = var_60_0.scrollbar

	var_60_5.content.visible = var_60_4

	local var_60_6 = ScrollBarLogic:new(var_60_5)

	arg_60_0._scrollbar_logic = var_60_6

	local var_60_7 = 1
	local var_60_8 = var_60_3

	var_60_6:set_scrollbar_values(var_60_3, arg_60_1, var_60_8, arg_60_2, var_60_7)
	var_60_6:set_scroll_percentage(0)

	local var_60_9 = var_60_0.scroll_area

	arg_60_0:_set_scroll_area_height(var_60_9, var_60_3)

	arg_60_0._scrolled_length = nil

	return var_60_4
end

HeroWindowItemCustomization._update_scroll_position = function (arg_61_0)
	local var_61_0 = arg_61_0._scrollbar_logic

	if not var_61_0 then
		return
	end

	local var_61_1 = var_61_0:get_scrolled_length()

	if var_61_1 ~= arg_61_0._scrolled_length then
		arg_61_0._ui_scenegraph.scroll_root.local_position[2] = var_61_1
		arg_61_0._scrolled_length = var_61_1
	end
end

HeroWindowItemCustomization._create_material_requirement_widgets = function (arg_62_0, arg_62_1)
	local var_62_0 = var_0_1[arg_62_1].ingredients
	local var_62_1 = UIWidgets.create_craft_material_widget("material_root")
	local var_62_2 = Managers.backend:get_interface("items")
	local var_62_3 = var_62_2:get_filtered_items("item_type == crafting_material")
	local var_62_4 = UISettings.crafting_material_icons_small
	local var_62_5 = {}
	local var_62_6 = true

	if not arg_62_0._material_items then
		arg_62_0._material_items = {}
	end

	local var_62_7 = arg_62_0._material_items

	table.clear(var_62_7)

	for iter_62_0, iter_62_1 in ipairs(var_62_0) do
		if not iter_62_1.catergory then
			local var_62_8 = UIWidget.init(var_62_1)

			var_62_5[#var_62_5 + 1] = var_62_8

			local var_62_9 = iter_62_1.name
			local var_62_10 = iter_62_1.amount
			local var_62_11 = var_62_4[var_62_9]
			local var_62_12 = 0
			local var_62_13

			for iter_62_2, iter_62_3 in ipairs(var_62_3) do
				local var_62_14 = iter_62_3.backend_id

				if iter_62_3.data.key == var_62_9 then
					var_62_13 = var_62_14
					var_62_12 = var_62_2:get_item_amount(var_62_14)

					break
				end
			end

			local var_62_15 = var_62_10 <= var_62_12
			local var_62_16

			var_62_16.text, var_62_16 = (var_62_12 < UISettings.max_craft_material_presentation_amount and tostring(var_62_12) or "*") .. "/" .. tostring(var_62_10), var_62_8.content
			var_62_16.icon = var_62_11
			var_62_16.warning = not var_62_15
			var_62_16.item = {
				data = table.clone(ItemMasterList[var_62_9])
			}
			var_62_7[#var_62_7 + 1] = var_62_13

			if var_62_9 == "crafting_material_dust_4" and ExperienceSettings.get_highest_character_level() < LootChestData.LEVEL_USED_FOR_POOL_LEVELS then
				var_62_6 = false
			elseif not var_62_15 then
				var_62_6 = false
			end
		end
	end

	local var_62_17 = #var_62_7
	local var_62_18 = 80
	local var_62_19 = var_62_17 * var_62_18
	local var_62_20 = -(var_62_19 / 2) + var_62_18 / 2

	for iter_62_4 = 1, var_62_17 do
		var_62_5[iter_62_4].offset[1] = var_62_20
		var_62_20 = var_62_20 + var_62_18
	end

	arg_62_0._material_widgets = var_62_5

	return var_62_6, var_62_19
end

HeroWindowItemCustomization._play_sound = function (arg_63_0, arg_63_1)
	arg_63_0._parent:play_sound(arg_63_1)
end

HeroWindowItemCustomization._state_setup_trait_reroll = function (arg_64_0)
	local var_64_0 = {}
	local var_64_1 = {}

	for iter_64_0, iter_64_1 in pairs(var_0_10) do
		local var_64_2 = UIWidget.init(iter_64_1)

		var_64_0[#var_64_0 + 1] = var_64_2
		var_64_1[iter_64_0] = var_64_2
	end

	arg_64_0._trait_reroll_widgets = var_64_0
	arg_64_0._trait_reroll_widgets_by_name = var_64_1

	local var_64_3 = arg_64_0:_get_item(arg_64_0._item_backend_id)
	local var_64_4 = var_64_3.data
	local var_64_5 = var_64_4.slot_type
	local var_64_6 = var_64_3.rarity or var_64_4.rarity
	local var_64_7 = var_64_4.trait_table_name

	if not var_64_7 then
		arg_64_0:_enable_craft_button(false)

		return
	end

	arg_64_0:_enable_craft_button(var_64_6)

	local var_64_8 = {}
	local var_64_9 = 45
	local var_64_10 = 30
	local var_64_11 = var_64_9
	local var_64_12 = WeaponTraits.combinations[var_64_7]

	for iter_64_2, iter_64_3 in pairs(WeaponTraits.traits) do
		local var_64_13 = false

		for iter_64_4, iter_64_5 in ipairs(var_64_12) do
			if table.contains(iter_64_5, iter_64_2) and not iter_64_3.crafting_disabled then
				var_64_13 = true

				break
			end
		end

		if var_64_13 then
			local var_64_14 = iter_64_3.display_name
			local var_64_15 = iter_64_3.advanced_description
			local var_64_16 = iter_64_3.icon
			local var_64_17 = Localize(var_64_14)
			local var_64_18 = UIUtils.get_trait_description(iter_64_2)
			local var_64_19, var_64_20 = arg_64_0:_create_trait_option_entry(var_64_17, var_64_18, var_64_16)

			var_64_8[#var_64_8 + 1] = var_64_19
			var_64_19.offset[2] = -var_64_11
			var_64_11 = var_64_11 + var_64_10 + var_64_20
		end
	end

	local var_64_21 = var_64_11 - var_64_9

	arg_64_0._trait_reroll_option_widgets = var_64_8

	local var_64_22, var_64_23 = arg_64_0:_create_description_widget("info_description_text_2", Localize("description_crafting_recipe_weapon_reroll_traits"))

	var_64_0[#var_64_0 + 1] = var_64_22

	local var_64_24 = var_64_23[2] + 10

	arg_64_0._ui_scenegraph.info_description_text_2.local_position[2] = -var_64_24

	local var_64_25 = var_64_10 * 2

	arg_64_0:_initialize_scrollbar(var_64_21, var_64_25)

	local var_64_26 = arg_64_0._states[arg_64_0._state].recipe_by_slot_type[var_64_5]

	arg_64_0._current_recipe_name = var_64_26

	arg_64_0:_update_state_craft_button(var_64_26, Localize("crafting_recipe_weapon_reroll_traits"), Colors.get_color_table_with_alpha("font_title", 255))
	arg_64_0._menu_input_description:change_generic_actions(var_0_18[arg_64_0._state])
end

HeroWindowItemCustomization._create_trait_option_entry = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	local var_65_0 = arg_65_0._ui_top_renderer
	local var_65_1 = "trait_options"
	local var_65_2 = var_0_15(var_65_1, arg_65_1, arg_65_2, arg_65_3)
	local var_65_3 = UIWidget.init(var_65_2)
	local var_65_4 = var_65_3.content
	local var_65_5 = var_65_3.style
	local var_65_6 = var_65_5.text
	local var_65_7 = var_65_5.description_text
	local var_65_8 = var_65_7.size
	local var_65_9 = math.floor(UIUtils.get_text_height(var_65_0, var_65_8, var_65_7, arg_65_2))
	local var_65_10 = math.floor(var_65_9)

	return var_65_3, var_65_10
end

HeroWindowItemCustomization._state_draw_trait_reroll = function (arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = arg_66_0._trait_reroll_widgets

	if var_66_0 then
		for iter_66_0, iter_66_1 in ipairs(var_66_0) do
			UIRenderer.draw_widget(arg_66_1, iter_66_1)
		end

		local var_66_1 = arg_66_0._trait_reroll_option_widgets

		if var_66_1 then
			for iter_66_2, iter_66_3 in ipairs(var_66_1) do
				UIRenderer.draw_widget(arg_66_1, iter_66_3)
			end
		end

		local var_66_2 = arg_66_0._material_widgets

		if var_66_2 then
			for iter_66_4, iter_66_5 in ipairs(var_66_2) do
				UIRenderer.draw_widget(arg_66_1, iter_66_5)
			end
		end
	end
end

HeroWindowItemCustomization._state_setup_upgrade = function (arg_67_0)
	arg_67_0:_destroy_scrollbar()

	local var_67_0 = {}
	local var_67_1 = {}

	for iter_67_0, iter_67_1 in pairs(var_0_11) do
		local var_67_2 = UIWidget.init(iter_67_1)

		var_67_0[#var_67_0 + 1] = var_67_2
		var_67_1[iter_67_0] = var_67_2
	end

	arg_67_0._upgrade_widgets = var_67_0
	arg_67_0._upgrade_widgets_by_name = var_67_1

	local var_67_3 = arg_67_0:_get_item(arg_67_0._item_backend_id)
	local var_67_4 = var_67_3.data
	local var_67_5 = var_67_3.rarity or var_67_4.rarity
	local var_67_6 = ""
	local var_67_7 = Colors.get_color_table_with_alpha("plentiful", 255)
	local var_67_8 = {}

	if var_67_5 == "plentiful" then
		var_67_6 = Localize("forge_screen_common_token_tooltip")
		var_67_7 = Colors.get_color_table_with_alpha("common", 255)
		var_67_8[1] = "icon_add_property"
	elseif var_67_5 == "common" then
		var_67_6 = Localize("forge_screen_rare_token_tooltip")
		var_67_7 = Colors.get_color_table_with_alpha("rare", 255)
		var_67_8[1] = "icon_add_property"
	elseif var_67_5 == "rare" then
		var_67_6 = Localize("forge_screen_exotic_token_tooltip")
		var_67_7 = Colors.get_color_table_with_alpha("exotic", 255)
		var_67_8[1] = "icon_add_trait"
	elseif var_67_5 == "exotic" then
		var_67_8[1] = "icon_upgrade_property"
		var_67_8[2] = "icon_upgrade_property"
		var_67_6 = Localize("difficulty_veteran")
		var_67_7 = Colors.get_color_table_with_alpha("unique", 255)
	else
		return
	end

	local var_67_9 = Localize("upgrade_description_text_" .. var_67_5)
	local var_67_10 = var_67_1.upgrade_rarity_name

	var_67_10.content.text = var_67_6
	var_67_10.style.text.text_color = var_67_7

	local var_67_11 = var_67_1.upgrade_icons

	var_67_11.content.texture_id = var_67_8
	var_67_1.upgrade_description_text.content.text = var_67_9

	local var_67_12 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_67_8[1]).size

	var_67_11.style.texture_id.texture_size[1] = var_67_12[1]
	var_67_11.style.texture_id.texture_size[2] = var_67_12[2]
	var_67_11.style.texture_id.texture_amount = #var_67_8

	local var_67_13, var_67_14 = arg_67_0:_create_description_widget("info_description_text_2", Localize("description_crafting_upgrade_item_rarity_common"))

	var_67_0[#var_67_0 + 1] = var_67_13

	local var_67_15 = var_67_14[2] + 10

	arg_67_0._ui_scenegraph.info_description_text_2.local_position[2] = -var_67_15

	local var_67_16 = arg_67_0._states[arg_67_0._state].recipe_by_rarity[var_67_5]

	arg_67_0._current_recipe_name = var_67_16

	arg_67_0:_update_state_craft_button(var_67_16, Localize("hero_view_crafting_upgrade"), var_67_7)
	arg_67_0._menu_input_description:change_generic_actions(var_0_18[arg_67_0._state])
end

HeroWindowItemCustomization._state_draw_upgrade = function (arg_68_0, arg_68_1, arg_68_2)
	local var_68_0 = arg_68_0._upgrade_widgets

	if var_68_0 then
		for iter_68_0, iter_68_1 in ipairs(var_68_0) do
			UIRenderer.draw_widget(arg_68_1, iter_68_1)
		end

		local var_68_1 = arg_68_0._material_widgets

		if var_68_1 then
			for iter_68_2, iter_68_3 in ipairs(var_68_1) do
				UIRenderer.draw_widget(arg_68_1, iter_68_3)
			end
		end
	end
end

HeroWindowItemCustomization._craft = function (arg_69_0, arg_69_1, arg_69_2)
	local var_69_0 = arg_69_0:_get_item(arg_69_0._item_backend_id).backend_id
	local var_69_1 = table.clone(arg_69_1)

	var_69_1[#var_69_1 + 1] = var_69_0

	local var_69_2 = Managers.state.crafting:craft(var_69_1, arg_69_2)

	if var_69_2 then
		arg_69_0._waiting_for_craft = true

		arg_69_0._parent:block_input()

		arg_69_0._current_crafting_data = {
			craft_id = var_69_2,
			state_name = arg_69_0._state
		}

		local var_69_3 = arg_69_0._widgets_by_name.loading_icon

		arg_69_0:_start_transition_animation("on_crafting_enter")

		arg_69_0._ui_animations.on_crafting_enter = UIAnimation.init(UIAnimation.function_by_time, var_69_3.style.texture_id.color, 1, 0, 255, 0.3, math.easeOutCubic)
		var_69_3.content.active = true

		return true
	end

	return false
end

HeroWindowItemCustomization._update_craft_response = function (arg_70_0)
	local var_70_0 = arg_70_0._current_crafting_data and arg_70_0._current_crafting_data.craft_id

	if not var_70_0 then
		return
	end

	local var_70_1 = Managers.backend:get_interface("crafting")

	if var_70_1:is_craft_complete(var_70_0) then
		local var_70_2 = var_70_1:get_craft_result(var_70_0)

		arg_70_0:_craft_completed(var_70_2)

		arg_70_0._current_crafting_data = nil
		arg_70_0._character_dirty = true
	end
end

HeroWindowItemCustomization._craft_completed = function (arg_71_0, arg_71_1)
	arg_71_0._waiting_for_craft = false

	arg_71_0._parent:unblock_input()

	local var_71_0 = arg_71_0._state
	local var_71_1 = arg_71_0._states[var_71_0].craft_complete_func_name

	if var_71_1 then
		arg_71_0[var_71_1](arg_71_0, arg_71_1)
	end

	local var_71_2 = arg_71_0._widgets_by_name.loading_icon

	arg_71_0:_start_transition_animation("on_crafting_exit")

	arg_71_0._ui_animations.on_crafting_exit = UIAnimation.init(UIAnimation.function_by_time, var_71_2.style.texture_id.color, 1, 255, 0, 0.3, math.easeOutCubic)

	arg_71_0._animation_callbacks.on_crafting_exit = function ()
		var_71_2.content.active = false
	end

	arg_71_0._item_dirty = true

	arg_71_0:_play_sound("play_gui_craft_forge_end_console_qol")

	arg_71_0._playing_craft_sound = false
end

HeroWindowItemCustomization._apply_weapon_skin_craft_complete = function (arg_73_0, arg_73_1)
	local var_73_0 = arg_73_0:_get_item(arg_73_0._item_backend_id)
	local var_73_1 = var_73_0.key
	local var_73_2 = var_73_0.skin or WeaponSkins.default_skins[var_73_1]
	local var_73_3 = var_73_0.data.slot_type
	local var_73_4 = arg_73_0._equipment_slot_name or InventorySettings.slot_names_by_type[var_73_3][1]

	arg_73_0._parent:_set_loadout_item(var_73_0, var_73_4)
	arg_73_0:_present_item(var_73_0, true)

	local var_73_5 = true
	local var_73_6 = true

	arg_73_0:_select_illusion_by_key(var_73_2, var_73_5, var_73_6)
	arg_73_0._menu_input_description:change_generic_actions(var_0_18.default)
	arg_73_0:_enable_craft_button(false)
end

HeroWindowItemCustomization._update_skin_gamepad_input = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
	local var_74_0 = arg_74_0._selected_skin_index or 1
	local var_74_1 = arg_74_0._selected_skin_index
	local var_74_2 = arg_74_0._illusion_widgets

	if #var_74_2 == 0 then
		return
	end

	local var_74_3 = #var_74_2
	local var_74_4 = false

	if arg_74_1:get("move_left") then
		var_74_0 = math.clamp(var_74_0 - 1, 1, var_74_3)
	elseif arg_74_1:get("move_right") then
		var_74_0 = math.clamp(var_74_0 + 1, 1, var_74_3)
	end

	if var_74_0 ~= var_74_1 then
		local var_74_5 = false
		local var_74_6 = false

		arg_74_0:_on_illusion_index_pressed(var_74_0, var_74_5, var_74_6)

		var_74_4 = true
	end

	return var_74_4
end

HeroWindowItemCustomization._upgrade_item_craft_complete = function (arg_75_0, arg_75_1)
	local var_75_0 = arg_75_0._item_backend_id
	local var_75_1 = Managers.backend:get_interface("dlcs")
	local var_75_2 = Managers.backend:get_interface("items")
	local var_75_3 = arg_75_1[1][1]
	local var_75_4 = arg_75_0:_get_item(var_75_3)

	arg_75_0:_present_item(var_75_4, nil, {
		0,
		2,
		0
	})

	for iter_75_0, iter_75_1 in ipairs(ProfilePriority) do
		local var_75_5 = SPProfiles[iter_75_1].careers

		for iter_75_2, iter_75_3 in pairs(var_75_5) do
			local var_75_6 = iter_75_3.name

			if iter_75_3 and not var_75_1:is_unreleased_career(var_75_6) then
				local var_75_7 = var_75_2:get_career_loadouts(var_75_6)

				for iter_75_4, iter_75_5 in pairs(InventorySettings.equipment_slots) do
					local var_75_8 = iter_75_5.name

					for iter_75_6, iter_75_7 in ipairs(var_75_7) do
						if iter_75_7[var_75_8] == var_75_0 then
							var_75_2:set_loadout_item(var_75_3, var_75_6, var_75_8, iter_75_6)
						end
					end
				end
			end
		end
	end

	arg_75_0._parent:_set_loadout_item(var_75_4, arg_75_0._equipment_slot_name)
	arg_75_0:_state_setup_upgrade()
	arg_75_0:_setup_availble_states(var_75_4)
end
