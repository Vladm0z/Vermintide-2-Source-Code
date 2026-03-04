-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_weave_forge_weapons.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_weapons_definitions")
local var_0_1 = var_0_0.top_widgets
local var_0_2 = var_0_0.bottom_widgets
local var_0_3 = var_0_0.bottom_hdr_widgets
local var_0_4 = var_0_0.top_hdr_widgets
local var_0_5 = var_0_0.scenegraph_definition
local var_0_6 = var_0_0.animation_definitions
local var_0_7 = var_0_0.create_weapon_entry_widget
local var_0_8 = var_0_0.create_property_option
local var_0_9 = var_0_0.create_trait_option
local var_0_10 = var_0_0.create_divider_option
local var_0_11 = var_0_0.create_item_block_option
local var_0_12 = var_0_0.create_item_stamina_option
local var_0_13 = var_0_0.create_item_ammunition_option
local var_0_14 = var_0_0.create_item_keywords_option
local var_0_15 = var_0_0.create_item_overheat_option
local var_0_16 = false
local var_0_17 = 10
local var_0_18 = 0.3
local var_0_19 = 1.6

HeroWindowWeaveForgeWeapons = class(HeroWindowWeaveForgeWeapons)
HeroWindowWeaveForgeWeapons.NAME = "HeroWindowWeaveForgeWeapons"

HeroWindowWeaveForgeWeapons.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowWeaveForgeWeapons")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._scrollbars = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	local var_1_1 = arg_1_1.hero_name
	local var_1_2 = arg_1_1.career_index
	local var_1_3 = arg_1_1.profile_index

	arg_1_0._career_name = SPProfiles[var_1_3].careers[var_1_2].name
	arg_1_0._hero_name = var_1_1
	arg_1_0._selected_slot_name = arg_1_1.selected_slot_name

	local var_1_4 = Managers.player:local_player()
	local var_1_5 = WeaveOnboardingUtils.get_ui_onboarding_state(var_1_0.statistics_db, var_1_4:stats_id())

	arg_1_0._crafting_tutorial = not WeaveOnboardingUtils.tutorial_completed(var_1_5, WeaveUITutorials.equip_weapon)

	arg_1_0:_update_button_visibility()

	if arg_1_0._crafting_tutorial then
		local var_1_6 = arg_1_0._widgets_by_name.unlock_button

		var_1_6.content.highlighted = true
		arg_1_0._ui_animations.unlock_button_pulse = UIAnimation.init(UIAnimation.pulse_animation, var_1_6.style.texture_highlight.color, 1, 100, 255, 2)
	end

	arg_1_0:_setup_weapon_list()
	arg_1_0:_sync_backend_loadout()
	Managers.state.event:trigger("weave_forge_weapons_entered")
end

HeroWindowWeaveForgeWeapons._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		parent = arg_2_0._parent,
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = arg_2_0._widgets_by_name
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_5, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

HeroWindowWeaveForgeWeapons._setup_weapon_list = function (arg_3_0)
	local var_3_0 = Managers.backend
	local var_3_1 = var_3_0:get_interface("items")
	local var_3_2 = arg_3_0._selected_slot_name
	local var_3_3 = arg_3_0._career_name
	local var_3_4 = CareerSettings[var_3_3].item_slot_types_by_slot_name[var_3_2]
	local var_3_5 = {}

	for iter_3_0, iter_3_1 in pairs(ItemMasterList) do
		if iter_3_1.rarity == "magic" then
			local var_3_6 = iter_3_1.slot_type

			if table.contains(var_3_4, var_3_6) then
				local var_3_7 = iter_3_1.can_wield

				if table.contains(var_3_7, var_3_3) then
					local var_3_8 = iter_3_1.required_unlock_item
					local var_3_9 = var_3_1:get_item_from_key(var_3_8)
					local var_3_10 = var_3_1:get_item_from_key(iter_3_0)

					if var_3_9 or var_3_10 then
						local var_3_11 = var_3_10 and var_3_10.backend_id

						var_3_5[#var_3_5 + 1] = {
							key = iter_3_0,
							item_data = iter_3_1,
							backend_id = var_3_11
						}
					end
				end
			end
		end
	end

	if arg_3_0._crafting_tutorial then
		local var_3_12 = var_3_0:get_interface("weaves")

		for iter_3_2 = #var_3_5, 1, -1 do
			local var_3_13 = var_3_5[iter_3_2]
			local var_3_14 = var_3_12:magic_item_cost(var_3_13.key)

			if var_3_14 and var_3_14 > 0 then
				table.remove(var_3_5, iter_3_2)
			end
		end
	end

	arg_3_0:_populate_list(var_3_5)
end

HeroWindowWeaveForgeWeapons._setup_definitions = function (arg_4_0)
	if arg_4_0._parent:gamepad_style_active() then
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_weapons_console_definitions")
	else
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_weapons_definitions")
	end

	var_0_1 = var_0_0.top_widgets
	var_0_2 = var_0_0.bottom_widgets
	var_0_3 = var_0_0.bottom_hdr_widgets
	var_0_4 = var_0_0.top_hdr_widgets
	var_0_5 = var_0_0.scenegraph_definition
	var_0_6 = var_0_0.animation_definitions
	var_0_7 = var_0_0.create_weapon_entry_widget
	var_0_8 = var_0_0.create_property_option
	var_0_9 = var_0_0.create_trait_option
	var_0_10 = var_0_0.create_divider_option
	var_0_11 = var_0_0.create_item_block_option
	var_0_12 = var_0_0.create_item_stamina_option
	var_0_13 = var_0_0.create_item_ammunition_option
	var_0_14 = var_0_0.create_item_keywords_option
	var_0_15 = var_0_0.create_item_overheat_option
end

HeroWindowWeaveForgeWeapons.create_ui_elements = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_setup_definitions()

	arg_5_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_5)

	local var_5_0 = {}
	local var_5_1 = {}
	local var_5_2 = {}
	local var_5_3 = {}
	local var_5_4 = {}

	for iter_5_0, iter_5_1 in pairs(var_0_1) do
		local var_5_5 = UIWidget.init(iter_5_1)

		var_5_0[#var_5_0 + 1] = var_5_5
		var_5_4[iter_5_0] = var_5_5
	end

	for iter_5_2, iter_5_3 in pairs(var_0_2) do
		local var_5_6 = UIWidget.init(iter_5_3)

		var_5_1[#var_5_1 + 1] = var_5_6
		var_5_4[iter_5_2] = var_5_6
	end

	for iter_5_4, iter_5_5 in pairs(var_0_3) do
		local var_5_7 = UIWidget.init(iter_5_5)

		var_5_3[#var_5_3 + 1] = var_5_7
		var_5_4[iter_5_4] = var_5_7
	end

	for iter_5_6, iter_5_7 in pairs(var_0_4) do
		local var_5_8 = UIWidget.init(iter_5_7)

		var_5_2[#var_5_2 + 1] = var_5_8
		var_5_4[iter_5_6] = var_5_8
	end

	arg_5_0._top_widgets = var_5_0
	arg_5_0._bottom_widgets = var_5_1
	arg_5_0._top_hdr_widgets = var_5_2
	arg_5_0._bottom_hdr_widgets = var_5_3
	arg_5_0._widgets_by_name = var_5_4
	var_5_4.upgrade_bg.alpha_multiplier = 0
	var_5_4.upgrade_text.alpha_multiplier = 0
	var_5_4.upgrade_effect.alpha_multiplier = 0
	arg_5_0._ui_animator = UIAnimator:new(arg_5_0._ui_scenegraph, var_0_6)

	if arg_5_2 then
		local var_5_9 = arg_5_0._ui_scenegraph.window.local_position

		var_5_9[1] = var_5_9[1] + arg_5_2[1]
		var_5_9[2] = var_5_9[2] + arg_5_2[2]
		var_5_9[3] = var_5_9[3] + arg_5_2[3]
	end

	UIRenderer.clear_scenegraph_queue(arg_5_0._ui_renderer)
end

HeroWindowWeaveForgeWeapons._initialize_viewports = function (arg_6_0)
	local var_6_0 = arg_6_0._params.selected_item
	local var_6_1 = arg_6_0._career_name
	local var_6_2 = Managers.backend
	local var_6_3 = var_6_2:get_interface("weaves")
	local var_6_4 = var_6_2:get_interface("items")
	local var_6_5 = arg_6_0._widgets_by_name
	local var_6_6

	var_6_6 = var_6_0 ~= nil

	local var_6_7 = "viewport"
	local var_6_8 = arg_6_0:_create_viewport_definition(var_6_7)
	local var_6_9 = UIWidget.init(var_6_8)
	local var_6_10

	var_6_10 = var_6_0 and var_6_0.backend_id

	local var_6_11 = 0
	local var_6_12 = 0

	arg_6_0._viewport_data = {
		widget = var_6_9,
		item = var_6_0,
		equip_button = var_6_5.equip_button,
		customize_button = var_6_5.customize_button,
		unlock_button = var_6_5.unlock_button,
		magic_level = var_6_11,
		power_level = var_6_12
	}

	local var_6_13 = arg_6_0._params.selected_item.data.key
	local var_6_14 = arg_6_0:_list_index_by_item_key(var_6_13)

	arg_6_0:_on_list_index_selected(var_6_14)
end

HeroWindowWeaveForgeWeapons._create_item_previewer = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.data
	local var_7_1 = var_7_0.key or arg_7_2.key
	local var_7_2 = var_7_0.slot_type
	local var_7_3 = arg_7_1.element.pass_data[1]
	local var_7_4 = var_7_3.viewport
	local var_7_5 = var_7_3.world
	local var_7_6 = {
		0,
		2.5,
		0
	}
	local var_7_7
	local var_7_8
	local var_7_9
	local var_7_10
	local var_7_11
	local var_7_12 = arg_7_0._career_name
	local var_7_13 = LootItemUnitPreviewer:new(arg_7_2, var_7_6, var_7_5, var_7_4, var_7_7, var_7_8, var_7_9, var_7_10, var_7_11, var_7_12)
	local var_7_14 = callback(arg_7_0, "cb_unit_spawned_item_preview", var_7_13, var_7_1, arg_7_3)

	var_7_13:register_spawn_callback(var_7_14)
	var_7_13:activate_auto_spin()

	return var_7_13
end

HeroWindowWeaveForgeWeapons.cb_unit_spawned_item_preview = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = not arg_8_3

	arg_8_1:present_item(arg_8_2, var_8_0)
end

HeroWindowWeaveForgeWeapons._create_viewport_definition = function (arg_9_0, arg_9_1)
	local var_9_0 = "environment/ui_weave_forge_preview"

	return {
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 840,
				viewport_type = "default_forward",
				enable_sub_gui = false,
				fov = 20,
				shading_environment = var_9_0,
				world_name = "weave_forge_item_preview_" .. arg_9_1,
				viewport_name = "weave_forge_item_preview_" .. arg_9_1,
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
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		},
		scenegraph_id = arg_9_1
	}
end

HeroWindowWeaveForgeWeapons.on_exit = function (arg_10_0, arg_10_1)
	print("[HeroViewWindow] Exit Substate HeroWindowWeaveForgeWeapons")

	arg_10_0._ui_animator = nil

	local var_10_0 = arg_10_0._viewport_data

	if var_10_0 then
		local var_10_1 = arg_10_0._ui_renderer
		local var_10_2 = var_10_0.item_previewer

		if var_10_2 then
			var_10_2:destroy()
		end

		local var_10_3 = var_10_0.widget

		UIWidget.destroy(var_10_1, var_10_3)

		arg_10_0._viewport_data = nil
	end
end

HeroWindowWeaveForgeWeapons.update = function (arg_11_0, arg_11_1, arg_11_2)
	if var_0_16 then
		var_0_16 = false

		arg_11_0:create_ui_elements()
	end

	local var_11_0 = arg_11_0._parent:window_input_service()
	local var_11_1 = Managers.input:is_device_active("gamepad")
	local var_11_2 = arg_11_0._viewport_data

	if var_11_2 then
		local var_11_3 = var_11_2.item_previewer
		local var_11_4 = var_11_2.widget

		if var_11_3 then
			local var_11_5 = arg_11_0:_is_button_hover(var_11_4)
			local var_11_6 = var_11_1 or var_11_5

			var_11_3:update(arg_11_1, arg_11_2, var_11_6 and var_11_0)
		end
	end

	arg_11_0:_update_animations(arg_11_1)
	arg_11_0:_update_scrollbar_positions()

	if arg_11_0._viewport_data then
		arg_11_0:_draw(arg_11_1)
	end

	local var_11_7 = arg_11_0._unlock_item_done_time

	if var_11_7 and var_11_7 < arg_11_2 then
		local var_11_8 = arg_11_0._unlock_item_response

		if var_11_8 ~= nil then
			arg_11_0:_on_unlock_item_done(var_11_8)

			arg_11_0._unlock_item_done_time = nil
			arg_11_0._unlock_item_response = nil
		end
	end
end

HeroWindowWeaveForgeWeapons._update_button_visibility = function (arg_12_0)
	local var_12_0 = arg_12_0._widgets_by_name.equip_button.content
	local var_12_1 = arg_12_0._widgets_by_name.customize_button.content

	var_12_0.visible = not arg_12_0._crafting_tutorial
	var_12_1.visible = not arg_12_0._crafting_tutorial
end

HeroWindowWeaveForgeWeapons.post_update = function (arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0._viewport_data then
		arg_13_0:_initialize_viewports()
	end

	local var_13_0 = arg_13_0._viewport_data

	if var_13_0 then
		local var_13_1 = var_13_0.item_previewer

		if var_13_1 then
			var_13_1:post_update(arg_13_1, arg_13_2)
		end

		arg_13_0:_handle_input(arg_13_1, arg_13_2)
	end
end

HeroWindowWeaveForgeWeapons._update_animations = function (arg_14_0, arg_14_1)
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

	local var_14_3 = arg_14_0._widgets_by_name
	local var_14_4 = arg_14_0._viewport_data

	if var_14_4 then
		local var_14_5 = var_14_4.customize_button

		if var_14_5 then
			UIWidgetUtils.animate_default_button(var_14_5, arg_14_1)
		end

		local var_14_6 = var_14_4.equip_button

		if var_14_6 then
			UIWidgetUtils.animate_default_button(var_14_6, arg_14_1)
		end

		local var_14_7 = var_14_4.unlock_button

		if var_14_7 then
			UIWidgetUtils.animate_default_button(var_14_7, arg_14_1)
		end
	end

	arg_14_0:_update_item_pulse_animation(arg_14_1)
end

HeroWindowWeaveForgeWeapons._is_button_pressed = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.content.button_hotspot

	if var_15_0.on_release then
		var_15_0.on_release = false

		if not var_15_0.is_selected then
			return true
		end
	end
end

HeroWindowWeaveForgeWeapons._is_button_hover = function (arg_16_0, arg_16_1)
	return arg_16_1.content.button_hotspot.is_hover
end

HeroWindowWeaveForgeWeapons._is_button_hover_enter = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.content.button_hotspot

	return var_17_0.on_hover_enter and not var_17_0.is_selected
end

HeroWindowWeaveForgeWeapons._is_button_hover_exit = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.content.button_hotspot

	return var_18_0.on_hover_exit and not var_18_0.is_selected
end

HeroWindowWeaveForgeWeapons._is_button_selected = function (arg_19_0, arg_19_1)
	return arg_19_1.content.button_hotspot.is_selected
end

HeroWindowWeaveForgeWeapons._list_index_pressed = function (arg_20_0, arg_20_1)
	for iter_20_0, iter_20_1 in ipairs(arg_20_1) do
		local var_20_0 = iter_20_1.content
		local var_20_1 = var_20_0.hotspot or var_20_0.button_hotspot

		if var_20_1 and var_20_1.on_release then
			var_20_1.on_release = false

			return iter_20_0
		end
	end
end

HeroWindowWeaveForgeWeapons._is_list_hovered = function (arg_21_0, arg_21_1)
	return arg_21_1.content.hotspot.is_hover or false
end

HeroWindowWeaveForgeWeapons._sync_backend_loadout = function (arg_22_0)
	local var_22_0 = Managers.backend
	local var_22_1 = var_22_0:get_interface("items")
	local var_22_2 = var_22_0:get_interface("weaves")
	local var_22_3 = arg_22_0._career_name
	local var_22_4 = Managers.backend:get_interface("weaves")
	local var_22_5 = var_22_4:get_loadout_item_id(var_22_3, arg_22_0._selected_slot_name)
	local var_22_6 = var_22_4:max_magic_level()
	local var_22_7 = arg_22_0._scrollbars.weapons.list_widgets

	for iter_22_0, iter_22_1 in ipairs(var_22_7) do
		local var_22_8 = iter_22_1.content
		local var_22_9 = var_22_8.key
		local var_22_10

		if not arg_22_0._crafting_tutorial then
			var_22_10 = var_22_1:get_item_from_key(var_22_9)
		end

		local var_22_11 = var_22_10 and var_22_10.backend_id
		local var_22_12 = var_22_11 and var_22_4:get_item_power_level(var_22_11) or 0
		local var_22_13 = UIUtils.presentable_hero_power_level_weaves(var_22_12)
		local var_22_14 = var_22_11 and var_22_4:get_item_magic_level(var_22_11) or 0

		var_22_8.locked = not var_22_11
		var_22_8.backend_id = var_22_11
		var_22_8.equipped = var_22_11 and var_22_4:has_loadout_item_id(var_22_3, var_22_11)
		var_22_8.equipped_in_another_slot = var_22_8.equipped and var_22_11 ~= var_22_5
		var_22_8.power_text = var_22_13
		var_22_8.item_power = var_22_13
		var_22_8.magic_level = var_22_14
		var_22_8.level_progress = var_22_14 / var_22_6
	end

	local var_22_15 = arg_22_0._selected_backend_id ~= nil
	local var_22_16 = arg_22_0._selected_backend_id and var_22_4:has_loadout_item_id(var_22_3, arg_22_0._selected_backend_id)

	arg_22_0:_update_equip_button_status(var_22_15, var_22_16)
end

HeroWindowWeaveForgeWeapons._play_sound = function (arg_23_0, arg_23_1)
	arg_23_0._parent:play_sound(arg_23_1)
end

HeroWindowWeaveForgeWeapons._handle_input = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._parent
	local var_24_1 = arg_24_0._widgets_by_name
	local var_24_2 = Managers.input:is_device_active("gamepad")
	local var_24_3 = arg_24_0._parent:window_input_service()
	local var_24_4 = arg_24_0._scrollbars

	if var_24_4 then
		for iter_24_0, iter_24_1 in pairs(var_24_4) do
			iter_24_1.scrollbar_logic:update(arg_24_1, arg_24_2)
		end

		local var_24_5 = var_24_4.weapons

		if var_24_5 then
			local var_24_6 = var_24_5.list_mask_widget
			local var_24_7 = arg_24_0:_is_list_hovered(var_24_6)
			local var_24_8 = var_24_5.list_widgets

			if var_24_8 and var_24_7 then
				for iter_24_2, iter_24_3 in ipairs(var_24_8) do
					if arg_24_0:_is_button_hover_enter(iter_24_3) then
						arg_24_0:_play_sound("play_gui_equipment_button_hover")
					end
				end

				local var_24_9 = arg_24_0:_list_index_pressed(var_24_8)

				if var_24_9 and var_24_9 ~= arg_24_0._selected_list_index then
					arg_24_0:_on_list_index_selected(var_24_9)
					arg_24_0:_play_sound("menu_magic_forge_select_weapon")
				end
			end

			arg_24_0:_animate_weapon_lists_widgets(var_24_8, arg_24_1, var_24_7)
		end
	end

	local var_24_10 = arg_24_0._params
	local var_24_11 = arg_24_0._viewport_data

	if var_24_11 then
		local var_24_12 = var_24_11.equip_button
		local var_24_13 = var_24_11.customize_button
		local var_24_14 = var_24_11.unlock_button

		var_24_13.content.button_hotspot.disable_button = arg_24_0._selected_backend_id == nil

		if arg_24_0:_is_button_hover_enter(var_24_12) or arg_24_0:_is_button_hover_enter(var_24_13) or arg_24_0:_is_button_hover_enter(var_24_14) then
			arg_24_0:_play_sound("Play_hud_hover")
		end

		if arg_24_0:_is_button_pressed(var_24_12) and arg_24_0._selected_backend_id then
			arg_24_0:_equip_item(arg_24_0._selected_backend_id)
			arg_24_0:_play_sound("menu_magic_forge_equip_weapon")
		elseif arg_24_0:_is_button_pressed(var_24_14) and arg_24_0._selected_item_id then
			arg_24_0:_unlock_item(arg_24_0._selected_item_id)
		elseif arg_24_0:_is_button_pressed(var_24_13) then
			local var_24_15 = var_24_11.item

			if var_24_15 then
				var_24_10.selected_item = var_24_15

				var_24_0:set_layout_by_name("weave_properties")
			end
		end
	end
end

HeroWindowWeaveForgeWeapons._on_list_index_selected = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._scrollbars.weapons.list_widgets
	local var_25_1 = false

	for iter_25_0, iter_25_1 in ipairs(var_25_0) do
		local var_25_2 = iter_25_1.content
		local var_25_3 = var_25_2.key
		local var_25_4 = var_25_2.backend_id
		local var_25_5 = var_25_2.button_hotspot
		local var_25_6 = iter_25_0 == arg_25_1

		var_25_5.is_selected = var_25_6

		if var_25_6 then
			var_25_1 = var_25_2.equipped
			arg_25_0._selected_backend_id = arg_25_0:_present_item(var_25_3)
			arg_25_0._selected_item_id = var_25_3
		end
	end

	arg_25_0._selected_list_index = arg_25_1

	local var_25_7 = arg_25_0._selected_backend_id ~= nil

	arg_25_0:_update_equip_button_status(var_25_7, var_25_1)
end

HeroWindowWeaveForgeWeapons._update_equip_button_status = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._viewport_data

	if var_26_0 then
		local var_26_1 = var_26_0.equip_button
		local var_26_2 = arg_26_1 and not arg_26_2
		local var_26_3 = var_26_2 and Localize("menu_weave_forge_equip_weapon_button") or Localize("menu_weave_forge_equipped_weapon_button")

		var_26_1.content.button_hotspot.disable_button = not var_26_2
		var_26_1.content.title_text = var_26_3
	end
end

HeroWindowWeaveForgeWeapons._list_index_by_item_key = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._scrollbars.weapons.list_widgets

	for iter_27_0, iter_27_1 in ipairs(var_27_0) do
		if iter_27_1.content.key == arg_27_1 then
			return iter_27_0
		end
	end

	return 1
end

HeroWindowWeaveForgeWeapons._present_item = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0._viewport_data

	if var_28_0.item_previewer then
		var_28_0.item_previewer:destroy()

		var_28_0.item_previewer = nil
	end

	local var_28_1 = Managers.backend
	local var_28_2 = var_28_1:get_interface("weaves")
	local var_28_3 = var_28_1:get_interface("items")
	local var_28_4

	if not arg_28_0._crafting_tutorial then
		var_28_4 = var_28_3:get_item_from_key(arg_28_1)
	end

	local var_28_5
	local var_28_6 = false

	if not var_28_4 then
		local var_28_7 = table.clone(ItemMasterList[arg_28_1])

		var_28_7.key = arg_28_1
		var_28_5 = {
			data = var_28_7,
			key = arg_28_1
		}
		var_28_6 = true
	end

	local var_28_8 = var_28_0.widget

	var_28_0.item_previewer = arg_28_0:_create_item_previewer(var_28_8, var_28_4 or var_28_5, arg_28_2)
	var_28_0.item = var_28_4

	local var_28_9 = 0
	local var_28_10 = 0
	local var_28_11 = var_28_4 and var_28_4.backend_id
	local var_28_12 = ""
	local var_28_13 = ""

	if var_28_4 then
		var_28_9 = var_28_2:get_item_magic_level(var_28_11) or 0
		var_28_10 = var_28_4.power_level or 0
		var_28_10 = UIUtils.presentable_hero_power_level_weaves(var_28_10)

		local var_28_14 = var_28_4.data

		var_28_12 = Localize(var_28_14.display_name)
		var_28_13 = Localize(var_28_14.item_type)
	else
		local var_28_15 = var_28_5.data

		var_28_12 = Localize(var_28_15.display_name)
		var_28_13 = Localize(var_28_15.item_type)
	end

	var_28_0.magic_level = var_28_9
	var_28_0.power_level = var_28_10

	local var_28_16 = arg_28_0._widgets_by_name

	var_28_16.viewport_level_value.content.text = var_28_9
	var_28_16.viewport_power_value.content.text = var_28_10
	var_28_16.viewport_title.content.text = var_28_12
	var_28_16.viewport_sub_title.content.text = var_28_13

	arg_28_0:_set_presentation_locked_state(var_28_6)

	arg_28_0._selected_item_locked = var_28_6

	arg_28_0:_setup_weapon_stats(var_28_4 or var_28_5)

	if not var_28_4 then
		local var_28_17 = var_28_2:get_essence()
		local var_28_18 = var_28_2:magic_item_cost(arg_28_1)
		local var_28_19 = var_28_18 <= var_28_17

		arg_28_0:_set_essence_upgrade_cost(var_28_18, var_28_19)
	end

	return var_28_11
end

HeroWindowWeaveForgeWeapons._set_presentation_locked_state = function (arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._widgets_by_name
	local var_29_1 = var_29_0.viewport_level_value
	local var_29_2 = var_29_0.viewport_level_title

	var_29_1.content.visible = not arg_29_1
	var_29_2.content.visible = not arg_29_1

	local var_29_3 = var_29_0.viewport_power_value
	local var_29_4 = var_29_0.viewport_power_title

	var_29_3.content.visible = not arg_29_1
	var_29_4.content.visible = not arg_29_1

	local var_29_5 = var_29_0.viewport_panel_divider
	local var_29_6 = var_29_0.viewport_panel_divider_left
	local var_29_7 = var_29_0.viewport_panel_divider_right
	local var_29_8 = var_29_0.unlock_button

	var_29_5.content.visible = not arg_29_1
	var_29_6.content.visible = not arg_29_1
	var_29_7.content.visible = not arg_29_1
	var_29_8.content.visible = arg_29_1
end

HeroWindowWeaveForgeWeapons._set_essence_upgrade_cost = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._widgets_by_name.unlock_button
	local var_30_1 = var_30_0.content
	local var_30_2 = var_30_0.style
	local var_30_3 = ""

	if arg_30_1 then
		local var_30_4 = UIUtils.comma_value(arg_30_1)

		var_30_3 = Localize("menu_weave_forge_unlock_weapon_button") .. " " .. var_30_4
	else
		var_30_3 = Localize("backend_err_playfab")
	end

	local var_30_5 = arg_30_0._ui_top_renderer
	local var_30_6 = UIUtils.get_text_width(var_30_5, var_30_2.title_text, var_30_3)
	local var_30_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_30_1.price_icon).size[1]
	local var_30_8 = 0
	local var_30_9 = -((var_30_7 + var_30_6 + var_30_8) / 2 - (var_30_6 / 2 + 5))

	var_30_2.title_text.offset[1] = var_30_2.title_text.default_offset[1] + var_30_9
	var_30_2.title_text_shadow.offset[1] = var_30_2.title_text_shadow.default_offset[1] + var_30_9
	var_30_2.title_text_disabled.offset[1] = var_30_2.title_text_disabled.default_offset[1] + var_30_9
	var_30_2.price_icon.offset[1] = var_30_9 + var_30_7 / 2 + var_30_6 / 2 + var_30_8
	var_30_2.price_icon_disabled.offset[1] = var_30_2.price_icon.offset[1]
	var_30_2.price_icon.color[1] = 255
	var_30_2.price_icon_disabled.color[1] = 255
	var_30_1.button_hotspot.disable_button = not arg_30_1 or not arg_30_2
	var_30_1.title_text = var_30_3
end

HeroWindowWeaveForgeWeapons._unlock_item = function (arg_31_0, arg_31_1)
	arg_31_0._params.upgrading = true

	arg_31_0._parent:block_input()

	arg_31_0._unlock_item_done_time = Managers.time:time("ui") + var_0_19
	arg_31_0._unlock_item_response = nil

	local var_31_0 = arg_31_0._widgets_by_name.unlock_button

	var_31_0.content.upgrading = true
	var_31_0.content.button_hotspot.disable_button = true

	local var_31_1 = callback(arg_31_0, "_unlock_item_cb")

	if arg_31_0._crafting_tutorial then
		var_31_1(true)

		local var_31_2 = Managers.world:world("level_world")
		local var_31_3 = LevelHelper:current_level(var_31_2)

		Level.trigger_event(var_31_3, "lua_keep_vom_magic_forge_tutorial_weapon_craft")
	else
		Managers.backend:get_interface("weaves"):buy_magic_item(arg_31_1, var_31_1)
	end
end

HeroWindowWeaveForgeWeapons._unlock_item_cb = function (arg_32_0, arg_32_1)
	arg_32_0._unlock_item_response = arg_32_1

	if arg_32_0._crafting_tutorial then
		arg_32_0._crafting_tutorial = false
		arg_32_0._widgets_by_name.unlock_button.content.highlighted = false
		arg_32_0._ui_animations.unlock_button_pulse = nil

		arg_32_0:_update_button_visibility()
	end

	arg_32_0:_setup_weapon_list()
end

HeroWindowWeaveForgeWeapons._on_unlock_item_done = function (arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._widgets_by_name.unlock_button

	var_33_0.content.upgrading = false
	var_33_0.content.button_hotspot.disable_button = false
	arg_33_0._params.upgrading = nil

	arg_33_0._parent:unblock_input()

	if arg_33_1 then
		arg_33_0:_play_sound("menu_magic_forge_unlock_weapon_for_crafting")

		if arg_33_0._selected_item_id then
			arg_33_0._selected_backend_id = arg_33_0:_present_item(arg_33_0._selected_item_id)
		end

		Managers.state.event:trigger("weave_forge_item_unlocked")

		local var_33_1 = "upgrade"
		local var_33_2 = arg_33_0._animations[var_33_1]

		if var_33_2 then
			arg_33_0._ui_animator:stop_animation(var_33_2)

			arg_33_0._animations[var_33_1] = nil
		end

		arg_33_0:_start_transition_animation(var_33_1)
	end

	arg_33_0:_sync_backend_loadout(arg_33_1)
end

HeroWindowWeaveForgeWeapons._equip_item = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._career_name

	Managers.backend:get_interface("weaves"):set_loadout_item(arg_34_1, var_34_0, arg_34_0._selected_slot_name)
	arg_34_0:_sync_backend_loadout()

	arg_34_0._equip_pulse_duration = var_0_18

	Managers.state.event:trigger("weave_forge_item_equpped")
end

HeroWindowWeaveForgeWeapons._update_item_pulse_animation = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._equip_pulse_duration

	if not var_35_0 then
		return
	end

	local var_35_1 = math.max(var_35_0 - arg_35_1, 0)
	local var_35_2 = 1 - var_35_1 / var_0_18
	local var_35_3 = arg_35_0._viewport_data

	if var_35_3 then
		local var_35_4 = var_35_3.item_previewer

		if var_35_4 then
			local var_35_5 = 0.08 * math.ease_pulse(var_35_2)

			var_35_4:set_zoom_fraction(var_35_5)
		end
	end

	if var_35_2 == 1 then
		arg_35_0._equip_pulse_duration = nil
	else
		arg_35_0._equip_pulse_duration = var_35_1
	end
end

HeroWindowWeaveForgeWeapons._draw = function (arg_36_0, arg_36_1)
	arg_36_0:_update_visible_list_entries()

	local var_36_0 = arg_36_0._parent
	local var_36_1 = var_36_0:get_ui_renderer()
	local var_36_2 = arg_36_0._ui_top_renderer
	local var_36_3 = arg_36_0._ui_scenegraph
	local var_36_4 = var_36_0:window_input_service()
	local var_36_5 = arg_36_0._render_settings
	local var_36_6 = var_36_0:hdr_renderer()
	local var_36_7 = var_36_0:hdr_top_renderer()
	local var_36_8 = var_36_5.alpha_multiplier
	local var_36_9 = var_36_5.snap_pixel_positions

	UIRenderer.begin_pass(var_36_6, var_36_3, var_36_4, arg_36_1, nil, var_36_5)

	local var_36_10 = var_36_5.snap_pixel_positions

	for iter_36_0, iter_36_1 in ipairs(arg_36_0._bottom_hdr_widgets) do
		var_36_5.alpha_multiplier = iter_36_1.alpha_multiplier or var_36_8

		UIRenderer.draw_widget(var_36_6, iter_36_1)
	end

	UIRenderer.end_pass(var_36_6)
	UIRenderer.begin_pass(var_36_7, var_36_3, var_36_4, arg_36_1, nil, var_36_5)

	local var_36_11 = var_36_5.snap_pixel_positions

	for iter_36_2, iter_36_3 in ipairs(arg_36_0._top_hdr_widgets) do
		var_36_5.alpha_multiplier = iter_36_3.alpha_multiplier or var_36_8

		UIRenderer.draw_widget(var_36_7, iter_36_3)
	end

	UIRenderer.end_pass(var_36_7)
	UIRenderer.begin_pass(var_36_2, var_36_3, var_36_4, arg_36_1, nil, var_36_5)

	for iter_36_4, iter_36_5 in ipairs(arg_36_0._top_widgets) do
		var_36_5.alpha_multiplier = iter_36_5.alpha_multiplier or var_36_8

		UIRenderer.draw_widget(var_36_2, iter_36_5)
	end

	local var_36_12 = arg_36_0._scrollbars

	if var_36_12 then
		for iter_36_6, iter_36_7 in pairs(var_36_12) do
			local var_36_13 = iter_36_7.list_widgets

			for iter_36_8, iter_36_9 in ipairs(var_36_13) do
				var_36_5.alpha_multiplier = iter_36_9.alpha_multiplier or var_36_8

				UIRenderer.draw_widget(var_36_2, iter_36_9)
			end
		end
	end

	UIRenderer.end_pass(var_36_2)
	UIRenderer.begin_pass(var_36_1, var_36_3, var_36_4, arg_36_1, nil, var_36_5)

	local var_36_14 = arg_36_0._viewport_data

	if var_36_14 then
		local var_36_15 = var_36_14.widget

		var_36_5.alpha_multiplier = var_36_15.alpha_multiplier or var_36_8

		UIRenderer.draw_widget(var_36_1, var_36_15)
	end

	for iter_36_10, iter_36_11 in ipairs(arg_36_0._bottom_widgets) do
		var_36_5.alpha_multiplier = iter_36_11.alpha_multiplier or var_36_8

		UIRenderer.draw_widget(var_36_1, iter_36_11)
	end

	UIRenderer.end_pass(var_36_1)
end

local function var_0_20(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.content
	local var_37_1 = arg_37_1.content

	return var_37_0.magic_level > var_37_1.magic_level
end

HeroWindowWeaveForgeWeapons._populate_list = function (arg_38_0, arg_38_1)
	local var_38_0 = "weapon_list_entry"
	local var_38_1 = var_0_5[var_38_0].size
	local var_38_2 = {}
	local var_38_3 = var_0_7(var_38_0, var_38_1)
	local var_38_4 = arg_38_0._ui_renderer
	local var_38_5 = Managers.backend:get_interface("weaves")
	local var_38_6 = #arg_38_1

	for iter_38_0 = 1, var_38_6 do
		local var_38_7 = arg_38_1[iter_38_0]
		local var_38_8 = var_38_7.key
		local var_38_9 = var_38_7.item_data
		local var_38_10 = var_38_9.inventory_icon
		local var_38_11 = Localize(var_38_9.item_type)
		local var_38_12 = var_38_7.backend_id
		local var_38_13 = var_38_12 and var_38_5:get_item_magic_level(var_38_12) or 0
		local var_38_14 = UIWidget.init(var_38_3)

		var_38_2[iter_38_0] = var_38_14

		local var_38_15 = var_38_14.content
		local var_38_16 = var_38_14.style.title
		local var_38_17 = var_38_16.size[1] - 60

		var_38_15.title = UIRenderer.crop_text_width(var_38_4, var_38_11, var_38_17, var_38_16)
		var_38_15.level_title = Localize("menu_weave_forge_magic_level_title") .. ": " .. var_38_13
		var_38_15.icon = var_38_10
		var_38_15.key = var_38_8
		var_38_15.magic_level = var_38_13
	end

	if var_38_6 > 1 then
		table.sort(var_38_2, var_0_20)
	end

	local var_38_18 = var_0_17
	local var_38_19 = arg_38_0:_align_list_widgets(var_38_2, var_38_18)
	local var_38_20 = arg_38_0._widgets_by_name.weapon_list_scrollbar
	local var_38_21 = "weapon_list_window"
	local var_38_22 = "weapon_scroll_root"
	local var_38_23 = arg_38_0:_initialize_scrollbar(var_38_20, var_38_19, var_38_21, var_38_18)

	arg_38_0._scrollbars.weapons = {
		total_height = var_38_19,
		list_widgets = var_38_2,
		widget = var_38_20,
		scrollbar_logic = var_38_23,
		spacing = var_38_18,
		root_scenegraph_id = var_38_22,
		list_scenegraph_id = var_38_21,
		list_mask_widget = arg_38_0._widgets_by_name.weapon_list_mask
	}
end

HeroWindowWeaveForgeWeapons._align_list_widgets = function (arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = 0
	local var_39_1 = #arg_39_1

	for iter_39_0 = 1, var_39_1 do
		local var_39_2 = arg_39_1[iter_39_0]
		local var_39_3 = var_39_2.offset
		local var_39_4 = var_39_2.content.size

		var_39_2.default_offset = table.clone(var_39_3)

		local var_39_5 = var_39_4[2]

		var_39_3[2] = -var_39_0
		var_39_0 = var_39_0 + var_39_5

		if iter_39_0 ~= var_39_1 then
			var_39_0 = var_39_0 + arg_39_2
		end
	end

	return var_39_0
end

HeroWindowWeaveForgeWeapons._initialize_scrollbar = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	local var_40_0 = arg_40_1.scenegraph_id
	local var_40_1 = ScrollBarLogic:new(arg_40_1)
	local var_40_2 = var_0_5[arg_40_3].size
	local var_40_3 = var_0_5[var_40_0].size
	local var_40_4 = var_40_2[2]
	local var_40_5 = var_40_3[2]
	local var_40_6 = 220 + arg_40_4 * 1.5
	local var_40_7 = 1

	var_40_1:set_scrollbar_values(var_40_4, arg_40_2, var_40_5, var_40_6, var_40_7)
	var_40_1:set_scroll_percentage(0)

	return var_40_1
end

HeroWindowWeaveForgeWeapons._update_scrollbar_positions = function (arg_41_0)
	local var_41_0 = arg_41_0._scrollbars

	if var_41_0 then
		local var_41_1 = arg_41_0._ui_scenegraph

		for iter_41_0, iter_41_1 in pairs(var_41_0) do
			local var_41_2 = iter_41_1.scrollbar_logic
			local var_41_3 = iter_41_1.root_scenegraph_id
			local var_41_4 = iter_41_1.scrolled_length
			local var_41_5 = var_41_2:get_scrolled_length()

			if var_41_5 ~= var_41_4 then
				var_41_1[var_41_3].local_position[2] = math.round(var_41_5)
				iter_41_1.scrolled_length = var_41_5
			end
		end
	end
end

HeroWindowWeaveForgeWeapons._update_visible_list_entries = function (arg_42_0)
	local var_42_0 = arg_42_0._scrollbars

	if var_42_0 then
		local var_42_1 = arg_42_0._ui_scenegraph

		for iter_42_0, iter_42_1 in pairs(var_42_0) do
			local var_42_2 = iter_42_1.scrollbar_logic

			if var_42_2:enabled() then
				local var_42_3 = iter_42_1.list_scenegraph_id
				local var_42_4 = iter_42_1.list_widgets
				local var_42_5 = iter_42_1.spacing
				local var_42_6 = var_42_2:get_scrolled_length()
				local var_42_7 = var_0_5[var_42_3].size
				local var_42_8 = var_42_5 * 2
				local var_42_9 = var_42_7[2] + var_42_8

				for iter_42_2, iter_42_3 in ipairs(var_42_4) do
					local var_42_10 = iter_42_3.offset
					local var_42_11 = iter_42_3.content
					local var_42_12 = var_42_11.size
					local var_42_13 = math.abs(var_42_10[2]) + var_42_12[2]
					local var_42_14 = false

					if var_42_13 < var_42_6 - var_42_8 then
						var_42_14 = true
					elseif var_42_9 < math.abs(var_42_10[2]) - var_42_6 then
						var_42_14 = true
					end

					var_42_11.visible = not var_42_14
				end
			end
		end
	end
end

HeroWindowWeaveForgeWeapons._get_scrollbar_percentage_by_index = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0._scrollbars[arg_43_1]
	local var_43_1 = var_43_0.scrollbar_logic

	if var_43_1:enabled() then
		local var_43_2 = var_43_1:get_scroll_percentage()
		local var_43_3 = var_43_1:get_scrolled_length()
		local var_43_4 = var_43_1:get_scroll_length()
		local var_43_5 = var_43_0.list_scenegraph_id
		local var_43_6 = var_0_5[var_43_5].size[2]
		local var_43_7 = var_43_3
		local var_43_8 = var_43_7 + var_43_6
		local var_43_9 = var_43_0.list_widgets

		if var_43_9 then
			local var_43_10 = var_43_9[arg_43_2]
			local var_43_11 = var_43_10.content
			local var_43_12 = var_43_10.offset
			local var_43_13 = var_43_11.size[2]
			local var_43_14 = math.abs(var_43_12[2])
			local var_43_15 = var_43_14 + var_43_13
			local var_43_16 = 0

			if var_43_8 < var_43_15 then
				local var_43_17 = var_43_15 - var_43_8

				var_43_16 = math.clamp(var_43_17 / var_43_4, 0, 1)
			elseif var_43_14 < var_43_7 then
				local var_43_18 = var_43_7 - var_43_14

				var_43_16 = -math.clamp(var_43_18 / var_43_4, 0, 1)
			end

			if var_43_16 then
				return (math.clamp(var_43_2 + var_43_16, 0, 1))
			end
		end
	end

	return 0
end

HeroWindowWeaveForgeWeapons._find_closest_neighbour = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = arg_44_0._scrollbars[arg_44_1].list_widgets
	local var_44_1 = var_44_0[arg_44_3]
	local var_44_2 = var_44_1.content.size
	local var_44_3 = var_44_1.offset
	local var_44_4 = var_44_2[1] * 0.5 + var_44_3[1]
	local var_44_5 = math.huge
	local var_44_6

	for iter_44_0, iter_44_1 in pairs(arg_44_2) do
		local var_44_7 = var_44_0[iter_44_1]
		local var_44_8 = var_44_7.offset
		local var_44_9 = var_44_7.content.size[1] * 0.5 + var_44_8[1]
		local var_44_10 = math.abs(var_44_9 - var_44_4)

		if var_44_10 < var_44_5 then
			var_44_5 = var_44_10
			var_44_6 = iter_44_1
		end
	end

	if var_44_6 then
		return var_44_6
	end
end

HeroWindowWeaveForgeWeapons._animate_weapon_lists_widgets = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	for iter_45_0, iter_45_1 in ipairs(arg_45_1) do
		arg_45_0:_animate_list_widget(iter_45_1, arg_45_2, arg_45_3)
	end
end

HeroWindowWeaveForgeWeapons._animate_list_widget = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = arg_46_1.offset
	local var_46_1 = arg_46_1.content
	local var_46_2 = arg_46_1.style
	local var_46_3 = var_46_1.button_hotspot or var_46_1.hotspot
	local var_46_4 = var_46_1.equipped_in_another_slot
	local var_46_5 = var_46_1.locked
	local var_46_6 = var_46_3.on_hover_enter
	local var_46_7 = var_46_3.is_hover

	if arg_46_3 ~= nil and not arg_46_3 then
		var_46_7 = false
		var_46_6 = false
	end

	local var_46_8 = var_46_3.is_selected
	local var_46_9 = not var_46_8 and var_46_3.is_clicked and var_46_3.is_clicked == 0
	local var_46_10 = var_46_3.input_progress or 0
	local var_46_11 = var_46_3.hover_progress or 0
	local var_46_12 = var_46_3.pulse_progress or 1
	local var_46_13 = var_46_3.offset_progress or 1
	local var_46_14 = var_46_3.selection_progress or 0
	local var_46_15 = (var_46_7 or var_46_8) and 14 or 8
	local var_46_16 = 3
	local var_46_17 = 20
	local var_46_18 = 5

	if var_46_9 then
		var_46_10 = math.min(var_46_10 + arg_46_2 * var_46_17, 1)
	else
		var_46_10 = math.max(var_46_10 - arg_46_2 * var_46_17, 0)
	end

	local var_46_19 = math.easeOutCubic(var_46_10)
	local var_46_20 = math.easeInCubic(var_46_10)

	if var_46_6 then
		var_46_12 = 0
	end

	local var_46_21 = math.min(var_46_12 + arg_46_2 * var_46_16, 1)
	local var_46_22 = math.easeOutCubic(var_46_21)
	local var_46_23 = math.easeInCubic(var_46_21)

	if var_46_7 then
		var_46_11 = math.min(var_46_11 + arg_46_2 * var_46_15, 1)
	else
		var_46_11 = math.max(var_46_11 - arg_46_2 * var_46_15, 0)
	end

	local var_46_24 = math.easeOutCubic(var_46_11)
	local var_46_25 = math.easeInCubic(var_46_11)

	if var_46_8 then
		var_46_14 = math.min(var_46_14 + arg_46_2 * var_46_15, 1)
		var_46_13 = math.min(var_46_13 + arg_46_2 * var_46_18, 1)
	else
		var_46_14 = math.max(var_46_14 - arg_46_2 * var_46_15, 0)
		var_46_13 = math.max(var_46_13 - arg_46_2 * var_46_18, 0)
	end

	local var_46_26 = math.easeOutCubic(var_46_14)
	local var_46_27 = math.easeInCubic(var_46_14)
	local var_46_28 = math.max(var_46_11, var_46_14)
	local var_46_29 = math.max(var_46_26, var_46_24)
	local var_46_30 = math.max(var_46_25, var_46_27)
	local var_46_31 = 255 * var_46_28

	var_46_2.hover_frame.color[1] = var_46_31

	local var_46_32 = var_46_2.title
	local var_46_33 = var_46_32.text_color
	local var_46_34 = var_46_32.default_text_color
	local var_46_35 = var_46_32.hover_text_color

	Colors.lerp_color_tables(var_46_34, var_46_35, var_46_28, var_46_33)

	local var_46_36 = var_46_2.level_title
	local var_46_37 = var_46_36.text_color
	local var_46_38 = var_46_36.default_text_color
	local var_46_39 = var_46_36.hover_text_color

	Colors.lerp_color_tables(var_46_38, var_46_39, var_46_28, var_46_37)

	local var_46_40 = var_46_2.power_text
	local var_46_41 = var_46_40.text_color
	local var_46_42 = var_46_40.default_text_color
	local var_46_43 = var_46_40.hover_text_color

	Colors.lerp_color_tables(var_46_42, var_46_43, var_46_28, var_46_41)

	local var_46_44 = 255 - 255 * var_46_21

	var_46_2.pulse_frame.color[1] = var_46_44
	var_46_2.icon.saturated = var_46_4 or var_46_5
	var_46_2.icon_background.saturated = var_46_4 or var_46_5
	var_46_3.offset_progress = var_46_13
	var_46_3.pulse_progress = var_46_21
	var_46_3.hover_progress = var_46_11
	var_46_3.input_progress = var_46_10
	var_46_3.selection_progress = var_46_14
end

HeroWindowWeaveForgeWeapons._setup_weapon_stats = function (arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0._career_name
	local var_47_1 = arg_47_1.data
	local var_47_2 = arg_47_1 and arg_47_1.backend_id
	local var_47_3 = BackendUtils.get_item_template(var_47_1, var_47_2)
	local var_47_4 = var_47_1.slot_type
	local var_47_5 = Managers.backend:get_interface("weaves")
	local var_47_6 = var_47_5:get_loadout_properties(var_47_0, var_47_2)
	local var_47_7 = var_47_5:get_loadout_traits(var_47_0, var_47_2)
	local var_47_8

	var_47_8 = not var_47_2 and var_47_5:get_loadout_talents(var_47_0)

	local var_47_9 = 70
	local var_47_10 = 10
	local var_47_11 = {}
	local var_47_12 = {
		0,
		var_47_9
	}
	local var_47_13 = {
		0,
		var_47_9
	}
	local var_47_14 = 10
	local var_47_15 = arg_47_0:_create_divider_option_entry(var_47_12, Localize("menu_weave_forge_weapon_stats_title"))

	var_47_11[#var_47_11 + 1] = var_47_15
	var_47_15.offset[2] = -var_47_10

	local var_47_16 = var_47_10 + var_47_9
	local var_47_17 = var_47_3.tooltip_keywords

	if var_47_17 then
		local var_47_18 = {
			0,
			50
		}
		local var_47_19 = ""
		local var_47_20 = #var_47_17

		for iter_47_0, iter_47_1 in ipairs(var_47_17) do
			var_47_19 = var_47_19 .. Localize(iter_47_1)
			var_47_20 = var_47_20 - 1

			if var_47_20 > 0 then
				var_47_19 = var_47_19 .. ", "
			end
		end

		local var_47_21 = arg_47_0:_create_item_keywords_option_entry(var_47_18, var_47_19)

		var_47_11[#var_47_11 + 1] = var_47_21
		var_47_21.offset[2] = -var_47_16
		var_47_16 = var_47_16 + var_47_18[2] + var_47_14
	end

	if var_47_4 == ItemType.MELEE then
		local var_47_22 = var_47_3.block_angle

		if var_47_22 then
			local var_47_23 = math.degrees_to_radians(var_47_22)
			local var_47_24 = arg_47_0:_create_item_block_option_entry(var_47_13, var_47_23)

			var_47_11[#var_47_11 + 1] = var_47_24
			var_47_24.offset[2] = -var_47_16
			var_47_16 = var_47_16 + var_47_9 + var_47_14
		end

		local var_47_25 = var_47_3.max_fatigue_points

		if var_47_25 then
			local var_47_26 = var_47_25 / 2
			local var_47_27 = arg_47_0:_create_item_stamina_option_entry(var_47_13, var_47_26)

			var_47_11[#var_47_11 + 1] = var_47_27
			var_47_27.offset[2] = -var_47_16
			var_47_16 = var_47_16 + var_47_9 + var_47_14
		end
	end

	if var_47_4 == ItemType.RANGED then
		local var_47_28 = var_47_3.ammo_data

		if var_47_28 then
			local var_47_29 = var_47_28.single_clip
			local var_47_30 = var_47_28.reload_time
			local var_47_31 = var_47_28.max_ammo
			local var_47_32 = var_47_28.ammo_per_clip
			local var_47_33 = var_47_28.hide_ammo_ui
			local var_47_34
			local var_47_35

			if var_47_29 then
				var_47_34 = tostring(var_47_31) .. "/0"
			elseif var_47_33 then
				var_47_35 = Localize("menu_weave_forge_weapon_ammo_burn_description")
			else
				var_47_34 = tostring(var_47_32) .. "/" .. tostring(var_47_31 - var_47_32)
			end

			local var_47_36 = arg_47_0:_create_item_ammunition_option_entry(var_47_13, var_47_34)

			var_47_11[#var_47_11 + 1] = var_47_36
			var_47_36.offset[2] = -var_47_16
			var_47_16 = var_47_16 + var_47_9 + var_47_14

			if var_47_33 then
				var_47_36.content.hide_ammo_ui = var_47_33
				var_47_36.content.description_text = var_47_35
			end
		else
			local var_47_37 = arg_47_0:_create_item_overheat_option_entry(var_47_13)

			var_47_11[#var_47_11 + 1] = var_47_37
			var_47_37.offset[2] = -var_47_16
			var_47_16 = var_47_16 + var_47_9 + var_47_14
		end
	end

	if var_47_7 then
		local var_47_38 = 0

		for iter_47_2, iter_47_3 in pairs(var_47_7) do
			var_47_38 = var_47_38 + 1
		end

		if var_47_38 > 0 then
			local var_47_39 = arg_47_0:_create_divider_option_entry(var_47_12, Localize("menu_weave_forge_options_title_traits"))

			var_47_11[#var_47_11 + 1] = var_47_39
			var_47_39.offset[2] = -var_47_16
			var_47_16 = var_47_16 + var_47_9
		end

		local var_47_40 = {
			0,
			var_47_9
		}

		for iter_47_4, iter_47_5 in pairs(var_47_7) do
			local var_47_41 = WeaveTraits.traits[iter_47_4]
			local var_47_42 = var_47_41.icon or "icons_placeholder"
			local var_47_43 = var_47_41.display_name
			local var_47_44 = var_47_41.icon
			local var_47_45 = Localize(var_47_43)
			local var_47_46 = ""

			if var_47_41.advanced_description then
				var_47_46 = UIUtils.get_trait_description(iter_47_4, var_47_41)
			end

			local var_47_47, var_47_48 = arg_47_0:_create_trait_option_entry(var_47_40, var_47_45, var_47_46, var_47_42)

			var_47_11[#var_47_11 + 1] = var_47_47
			var_47_47.offset[2] = -var_47_16
			var_47_16 = var_47_16 + var_47_9 + var_47_48
		end
	end

	if var_47_6 then
		local var_47_49 = 0

		for iter_47_6, iter_47_7 in pairs(var_47_6) do
			var_47_49 = var_47_49 + 1
		end

		if var_47_49 > 0 then
			local var_47_50 = arg_47_0:_create_divider_option_entry(var_47_12, Localize("menu_weave_forge_options_title_properties"))

			var_47_11[#var_47_11 + 1] = var_47_50
			var_47_50.offset[2] = -var_47_16
			var_47_16 = var_47_16 + var_47_9
		end

		local var_47_51 = {}
		local var_47_52 = {
			0,
			var_47_9
		}

		for iter_47_8, iter_47_9 in pairs(var_47_6) do
			local var_47_53 = #iter_47_9
			local var_47_54 = WeaveProperties.properties[iter_47_8]
			local var_47_55 = var_47_5:get_property_mastery_costs(iter_47_8)
			local var_47_56 = UIUtils.get_weave_property_description(iter_47_8, var_47_54, var_47_55, var_47_53)
			local var_47_57 = string.find(var_47_56, " ", 1)
			local var_47_58 = string.sub(var_47_56, 1, var_47_57)
			local var_47_59 = var_47_54.icon or "icons_placeholder"
			local var_47_60 = arg_47_0:_create_property_option_entry(var_47_52, var_47_56, var_47_58, var_47_59)

			var_47_11[#var_47_11 + 1] = var_47_60
			var_47_60.offset[2] = -var_47_16
			var_47_16 = var_47_16 + var_47_9
		end
	end

	local var_47_61 = arg_47_0._widgets_by_name.stats_list_scrollbar
	local var_47_62 = "stats_list_window"
	local var_47_63 = "stats_scroll_root"
	local var_47_64 = 0
	local var_47_65 = arg_47_0:_initialize_scrollbar(var_47_61, var_47_16, var_47_62, var_47_64)

	arg_47_0._scrollbars.stats = {
		total_height = var_47_16,
		list_widgets = var_47_11,
		widget = var_47_61,
		scrollbar_logic = var_47_65,
		spacing = var_47_64,
		root_scenegraph_id = var_47_63,
		list_scenegraph_id = var_47_62,
		list_mask_widget = arg_47_0._widgets_by_name.stats_list_mask
	}
end

HeroWindowWeaveForgeWeapons._create_item_keywords_option_entry = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = true
	local var_48_1 = arg_48_0._ui_renderer
	local var_48_2 = "stat_option"
	local var_48_3 = var_0_14(arg_48_1, var_48_2, var_48_0, arg_48_2)
	local var_48_4 = UIWidget.init(var_48_3)
	local var_48_5 = var_48_4.content
	local var_48_6 = var_48_4.style.text

	return var_48_4
end

HeroWindowWeaveForgeWeapons._create_item_overheat_option_entry = function (arg_49_0, arg_49_1)
	local var_49_0 = true
	local var_49_1 = arg_49_0._ui_renderer
	local var_49_2 = "stat_option"
	local var_49_3 = var_0_15(arg_49_1, var_49_2, var_49_0)

	return (UIWidget.init(var_49_3))
end

HeroWindowWeaveForgeWeapons._create_item_ammunition_option_entry = function (arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = true
	local var_50_1 = arg_50_0._ui_renderer
	local var_50_2 = "stat_option"
	local var_50_3 = var_0_13(arg_50_1, var_50_2, var_50_0, arg_50_2)

	return (UIWidget.init(var_50_3))
end

HeroWindowWeaveForgeWeapons._create_item_stamina_option_entry = function (arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = true
	local var_51_1 = arg_51_0._ui_renderer
	local var_51_2 = "stat_option"
	local var_51_3 = var_0_12(arg_51_1, var_51_2, var_51_0, arg_51_2)

	return (UIWidget.init(var_51_3))
end

HeroWindowWeaveForgeWeapons._create_item_block_option_entry = function (arg_52_0, arg_52_1, arg_52_2)
	print("_create_item_block_option_entry", arg_52_2)

	local var_52_0 = true
	local var_52_1 = arg_52_0._ui_renderer
	local var_52_2 = "stat_option"
	local var_52_3 = var_0_11(arg_52_1, var_52_2, var_52_0, arg_52_2)

	return (UIWidget.init(var_52_3))
end

HeroWindowWeaveForgeWeapons._create_divider_option_entry = function (arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = true
	local var_53_1 = arg_53_0._ui_renderer
	local var_53_2 = "stat_option"
	local var_53_3 = var_0_10(arg_53_1, var_53_2, var_53_0, arg_53_2)
	local var_53_4 = UIWidget.init(var_53_3)
	local var_53_5 = var_53_4.content
	local var_53_6 = var_53_4.style.text

	return var_53_4
end

HeroWindowWeaveForgeWeapons._create_trait_option_entry = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	local var_54_0 = true
	local var_54_1 = arg_54_0._ui_renderer
	local var_54_2 = "stat_option"
	local var_54_3 = var_0_9(arg_54_1, var_54_2, var_54_0, arg_54_2, arg_54_3, arg_54_4)
	local var_54_4 = UIWidget.init(var_54_3)
	local var_54_5 = var_54_4.content
	local var_54_6 = var_54_4.style
	local var_54_7 = var_54_6.text
	local var_54_8 = var_54_6.description_text
	local var_54_9 = var_54_8.size
	local var_54_10 = math.floor(UIUtils.get_text_height(var_54_1, var_54_9, var_54_8, arg_54_3))
	local var_54_11 = math.floor(var_54_10)

	return var_54_4, var_54_11
end

HeroWindowWeaveForgeWeapons._create_property_option_entry = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = true
	local var_55_1 = "stat_option"
	local var_55_2 = arg_55_2
	local var_55_3 = var_0_8(arg_55_1, var_55_1, var_55_0, var_55_2, arg_55_4)
	local var_55_4 = UIWidget.init(var_55_3)
	local var_55_5 = var_55_4.style
	local var_55_6 = var_55_5.text.color_override_table
	local var_55_7 = UTF8Utils.string_length(arg_55_2) or 0
	local var_55_8 = UTF8Utils.string_length(arg_55_3)
	local var_55_9 = var_55_5.text

	if var_55_9 then
		local var_55_10 = var_55_9.color_override_table

		var_55_10.start_index = var_55_8
		var_55_10.end_index = var_55_7
		var_55_9.color_override[1] = var_55_10
	end

	return var_55_4
end
