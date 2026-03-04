-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_weave_forge_overview.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_overview_definitions")
local var_0_1 = var_0_0.top_widgets
local var_0_2 = var_0_0.bottom_widgets
local var_0_3 = var_0_0.bottom_hdr_widgets
local var_0_4 = var_0_0.top_hdr_widgets
local var_0_5 = var_0_0.scenegraph_definition
local var_0_6 = var_0_0.animation_definitions
local var_0_7 = var_0_0.weapon_crafting_tutorial_definitions
local var_0_8 = false
local var_0_9 = 1.6

HeroWindowWeaveForgeOverview = class(HeroWindowWeaveForgeOverview)
HeroWindowWeaveForgeOverview.NAME = "HeroWindowWeaveForgeOverview"

HeroWindowWeaveForgeOverview.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowWeaveForgeOverview")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._stats_id = Managers.player:local_player():stats_id()
	arg_1_0._statistics_db = var_1_0.statistics_db

	local var_1_1 = arg_1_0._statistics_db
	local var_1_2 = arg_1_0._stats_id
	local var_1_3 = WeaveOnboardingUtils.get_onboarding_step(var_1_1, var_1_2)
	local var_1_4 = WeaveOnboardingUtils.get_ui_onboarding_state(var_1_1, var_1_2)

	arg_1_0.weapon_crafting_tutorial = not WeaveOnboardingUtils.tutorial_completed(var_1_4, WeaveUITutorials.equip_weapon) and WeaveOnboardingUtils.reached_requirements(var_1_3, WeaveUITutorials.equip_weapon)
	arg_1_0.forge_upgrade_tutorial = not WeaveOnboardingUtils.tutorial_completed(var_1_4, WeaveUITutorials.forge_upgrade) and WeaveOnboardingUtils.reached_requirements(var_1_3, WeaveUITutorials.forge_upgrade)
	arg_1_0.amulet_introduced = WeaveOnboardingUtils.reached_requirements(var_1_3, WeaveUITutorials.amulet)
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	local var_1_5 = arg_1_1.hero_name
	local var_1_6 = arg_1_1.career_index
	local var_1_7 = arg_1_1.profile_index

	arg_1_0._career_name = SPProfiles[var_1_7].careers[var_1_6].name
	arg_1_0._hero_name = var_1_5

	arg_1_0:_sync_backend_loadout()
end

HeroWindowWeaveForgeOverview._setup_definitions = function (arg_2_0)
	if arg_2_0._parent:gamepad_style_active() then
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_overview_console_definitions")
	else
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_overview_definitions")
	end

	var_0_1 = var_0_0.top_widgets
	var_0_2 = var_0_0.bottom_widgets
	var_0_3 = var_0_0.bottom_hdr_widgets
	var_0_4 = var_0_0.top_hdr_widgets
	var_0_5 = var_0_0.scenegraph_definition
	var_0_6 = var_0_0.animation_definitions
	var_0_7 = var_0_0.weapon_crafting_tutorial_definitions
end

HeroWindowWeaveForgeOverview._start_transition_animation = function (arg_3_0, arg_3_1)
	local var_3_0 = {
		parent = arg_3_0._parent,
		render_settings = arg_3_0._render_settings
	}
	local var_3_1 = arg_3_0._widgets_by_name
	local var_3_2 = arg_3_0._ui_animator:start_animation(arg_3_1, var_3_1, var_0_5, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

HeroWindowWeaveForgeOverview.create_ui_elements = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_setup_definitions()

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_5)

	local var_4_0 = {}
	local var_4_1 = {}
	local var_4_2 = {}
	local var_4_3 = {}
	local var_4_4 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_5 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_5
		var_4_4[iter_4_0] = var_4_5
	end

	for iter_4_2, iter_4_3 in pairs(var_0_2) do
		local var_4_6 = UIWidget.init(iter_4_3)

		var_4_1[#var_4_1 + 1] = var_4_6
		var_4_4[iter_4_2] = var_4_6
	end

	for iter_4_4, iter_4_5 in pairs(var_0_3) do
		local var_4_7 = UIWidget.init(iter_4_5)

		var_4_3[#var_4_3 + 1] = var_4_7
		var_4_4[iter_4_4] = var_4_7
	end

	for iter_4_6, iter_4_7 in pairs(var_0_4) do
		local var_4_8 = UIWidget.init(iter_4_7)

		var_4_2[#var_4_2 + 1] = var_4_8
		var_4_4[iter_4_6] = var_4_8
	end

	arg_4_0._top_widgets = var_4_0
	arg_4_0._bottom_widgets = var_4_1
	arg_4_0._top_hdr_widgets = var_4_2
	arg_4_0._bottom_hdr_widgets = var_4_3
	arg_4_0._widgets_by_name = var_4_4

	local var_4_9 = arg_4_0._widgets_by_name.viewport_button_1
	local var_4_10 = arg_4_0._widgets_by_name.viewport_button_2
	local var_4_11 = arg_4_0._widgets_by_name.viewport_button_3

	var_4_9.content.hotspot.allow_multi_hover = true
	var_4_10.content.hotspot.allow_multi_hover = true
	var_4_11.content.hotspot.allow_multi_hover = true
	var_4_4.upgrade_text.alpha_multiplier = 0
	var_4_4.upgrade_bg.alpha_multiplier = 0
	var_4_4.skull_circle.alpha_multiplier = 0
	var_4_4.skull_circle_shade.alpha_multiplier = 0
	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_6)

	if arg_4_2 then
		local var_4_12 = arg_4_0._ui_scenegraph.window.local_position

		var_4_12[1] = var_4_12[1] + arg_4_2[1]
		var_4_12[2] = var_4_12[2] + arg_4_2[2]
		var_4_12[3] = var_4_12[3] + arg_4_2[3]
	end

	if arg_4_0.forge_upgrade_tutorial then
		local var_4_13 = var_4_4.upgrade_button

		var_4_13.content.highlighted = true
		arg_4_0._ui_animations.upgrade_button_pulse = UIAnimation.init(UIAnimation.pulse_animation, var_4_13.style.texture_highlight.color, 1, 100, 255, 2)
	end

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)
end

HeroWindowWeaveForgeOverview._play_sound = function (arg_5_0, arg_5_1)
	arg_5_0._parent:play_sound(arg_5_1)
end

HeroWindowWeaveForgeOverview._initialize_viewports = function (arg_6_0)
	local var_6_0 = arg_6_0.weapon_crafting_tutorial
	local var_6_1 = arg_6_0.amulet_introduced
	local var_6_2 = {
		{
			slot_name = "slot_melee",
			no_item_sub_title_text = "inventory_screen_melee_weapon_title",
			no_item_for_tutorial = var_6_0
		},
		{
			unit_name = "units/ui/pup_weave_amulet/pup_weave_amulet",
			package_name = "units/ui/pup_weave_amulet/pup_weave_amulet",
			optional_title = Localize("weave_amulet_name"),
			hidden_for_tutorial = not var_6_1
		},
		{
			slot_name = "slot_ranged",
			no_item_sub_title_text = "inventory_screen_ranged_weapon_title",
			no_item_for_tutorial = var_6_0
		}
	}
	local var_6_3 = arg_6_0._career_name
	local var_6_4 = Managers.backend
	local var_6_5 = var_6_4:get_interface("weaves")
	local var_6_6 = var_6_4:get_interface("items")
	local var_6_7 = arg_6_0._widgets_by_name
	local var_6_8 = {}

	for iter_6_0, iter_6_1 in ipairs(var_6_2) do
		local var_6_9 = iter_6_1.slot_name
		local var_6_10 = iter_6_1.package_name
		local var_6_11 = iter_6_1.unit_name
		local var_6_12 = iter_6_1.optional_title
		local var_6_13 = iter_6_1.optional_sub_title
		local var_6_14 = iter_6_1.hidden_for_tutorial
		local var_6_15 = iter_6_1.no_item_for_tutorial
		local var_6_16 = "viewport_" .. iter_6_0
		local var_6_17 = iter_6_0 == #var_6_2
		local var_6_18 = arg_6_0:_create_viewport_definition(var_6_16, var_6_17)
		local var_6_19 = UIWidget.init(var_6_18)

		var_6_19.content.visible = not var_6_14

		local var_6_20 = var_6_9 and var_6_5:get_loadout_item_id(var_6_3, var_6_9)
		local var_6_21 = var_6_20 and var_6_6:get_item_from_id(var_6_20)
		local var_6_22 = -0.8
		local var_6_23 = false
		local var_6_24 = not var_6_15 and var_6_21 and arg_6_0:_create_item_previewer(var_6_19, var_6_21, var_6_22, var_6_23)
		local var_6_25 = var_6_10 and arg_6_0:_create_unit_previewer(var_6_19, var_6_11, var_6_10)
		local var_6_26 = 0
		local var_6_27 = 0
		local var_6_28 = var_6_12 or ""
		local var_6_29 = var_6_13 or ""

		if var_6_15 then
			var_6_28 = Localize("menu_weave_tutorial_athanor_01_empty_state_no_weapon")
			var_6_29 = Localize(iter_6_1.no_item_sub_title_text)
			var_6_27 = nil
		elseif var_6_21 then
			var_6_26 = var_6_5:get_item_magic_level(var_6_20) or 0
			var_6_27 = var_6_21.power_level or 0
			var_6_27 = UIUtils.presentable_hero_power_level_weaves(var_6_27)

			local var_6_30 = var_6_21.data

			var_6_28 = Localize(var_6_30.display_name)
			var_6_29 = Localize(var_6_30.item_type)
		else
			var_6_26 = var_6_5:get_career_magic_level(var_6_3) or 0
			var_6_27 = var_6_5:get_career_power_level(var_6_3)
			var_6_27 = var_6_27 and UIUtils.presentable_hero_power_level_weaves(var_6_27)

			local var_6_31 = CareerSettings[var_6_3]

			var_6_29 = Localize(var_6_31.display_name)
		end

		local var_6_32 = var_6_7["viewport_panel_divider_" .. iter_6_0]
		local var_6_33 = var_6_7["viewport_panel_divider_left_" .. iter_6_0]
		local var_6_34 = var_6_7["viewport_panel_divider_right_" .. iter_6_0]
		local var_6_35 = var_6_7["viewport_level_value_" .. iter_6_0]
		local var_6_36 = var_6_7["viewport_level_title_" .. iter_6_0]

		var_6_35.content.text = var_6_26
		var_6_35.content.visible = not var_6_14 and not var_6_15
		var_6_36.content.visible = not var_6_14 and not var_6_15

		local var_6_37 = var_6_7["viewport_power_value_" .. iter_6_0]
		local var_6_38 = var_6_7["viewport_power_title_" .. iter_6_0]

		var_6_37.content.visible = var_6_27 ~= nil and not var_6_14
		var_6_38.content.visible = var_6_27 ~= nil and not var_6_14
		var_6_32.content.visible = var_6_27 ~= nil and not var_6_14
		var_6_33.content.visible = not var_6_14
		var_6_34.content.visible = not var_6_14

		if var_6_27 then
			var_6_37.content.text = var_6_27
		else
			arg_6_0._ui_scenegraph[var_6_35.scenegraph_id].local_position[1] = 0
			arg_6_0._ui_scenegraph[var_6_36.scenegraph_id].local_position[1] = 0
		end

		local var_6_39 = var_6_7["viewport_title_" .. iter_6_0]

		var_6_39.content.text = var_6_28
		var_6_39.content.visible = not var_6_14

		local var_6_40 = var_6_7["viewport_sub_title_" .. iter_6_0]

		var_6_40.content.text = var_6_29
		var_6_40.content.visible = not var_6_14

		local var_6_41 = var_6_7["viewport_button_" .. iter_6_0]
		local var_6_42 = var_6_7["viewport_button_highlight_" .. iter_6_0]
		local var_6_43 = var_6_7["viewport_button_text_highlight_" .. iter_6_0]

		var_6_41.content.hotspot.disable_button = (var_6_14 or var_6_15) == true

		local var_6_44 = var_6_7["change_button_" .. iter_6_0]

		if var_6_44 and var_6_0 then
			var_6_44.content.highlighted = true
			arg_6_0._ui_animations["change_button_pulse" .. iter_6_0] = UIAnimation.init(UIAnimation.pulse_animation, var_6_44.style.texture_highlight.color, 1, 100, 255, 2)
		end

		var_6_8[iter_6_0] = {
			widget = var_6_19,
			viewport_button = var_6_41,
			viewport_button_highlight = var_6_42,
			viewport_button_text_highlight = var_6_43,
			item_previewer = var_6_24,
			unit_previewer = var_6_25,
			package_name = var_6_10,
			unit_name = var_6_11,
			item = var_6_21,
			slot_name = var_6_9,
			change_button = var_6_44,
			magic_level = var_6_26,
			power_level = var_6_27
		}
	end

	if var_6_0 and not var_6_1 then
		local var_6_45 = arg_6_0._top_widgets

		for iter_6_2, iter_6_3 in pairs(var_0_7) do
			local var_6_46 = UIWidget.init(iter_6_3)

			var_6_45[#var_6_45 + 1] = var_6_46
		end
	end

	arg_6_0._viewports_data = var_6_8
end

HeroWindowWeaveForgeOverview._create_item_previewer = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2.data
	local var_7_1 = var_7_0.key
	local var_7_2 = var_7_0.slot_type
	local var_7_3 = arg_7_1.element.pass_data[1]
	local var_7_4 = var_7_3.viewport
	local var_7_5 = var_7_3.world
	local var_7_6 = {
		arg_7_3,
		3,
		0
	}
	local var_7_7
	local var_7_8 = arg_7_4
	local var_7_9
	local var_7_10
	local var_7_11
	local var_7_12 = arg_7_0._career_name
	local var_7_13 = LootItemUnitPreviewer:new(arg_7_2, var_7_6, var_7_5, var_7_4, var_7_7, var_7_8, var_7_9, var_7_10, var_7_11, var_7_12)
	local var_7_14 = callback(arg_7_0, "cb_unit_spawned_item_preview", var_7_13, var_7_1)

	var_7_13:register_spawn_callback(var_7_14)
	var_7_13:activate_auto_spin()

	return var_7_13
end

HeroWindowWeaveForgeOverview._create_unit_previewer = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_1.element.pass_data[1]
	local var_8_1 = var_8_0.viewport
	local var_8_2 = var_8_0.world
	local var_8_3 = {
		0,
		2.8,
		0
	}
	local var_8_4 = UIUnitPreviewer:new(arg_8_2, arg_8_3, var_8_3, var_8_2, var_8_1)
	local var_8_5 = callback(arg_8_0, "cb_unit_spawned_unit_preview", var_8_4, arg_8_2)

	var_8_4:register_spawn_callback(var_8_5)
	var_8_4:activate_auto_spin()

	return var_8_4
end

HeroWindowWeaveForgeOverview.cb_unit_spawned_unit_preview = function (arg_9_0, arg_9_1, arg_9_2)
	print("cb_unit_spawned_unit_preview", arg_9_1, arg_9_2)
end

HeroWindowWeaveForgeOverview.cb_unit_spawned_item_preview = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = true

	arg_10_1:present_item(arg_10_2, var_10_0)
end

HeroWindowWeaveForgeOverview._create_viewport_definition = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_2 and "environment/ui_weave_forge_preview_inverted" or "environment/ui_weave_forge_preview"

	return {
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 801,
				viewport_type = "default_forward",
				enable_sub_gui = false,
				fov = 20,
				shading_environment = var_11_0,
				world_name = "weave_forge_item_preview_" .. arg_11_1,
				viewport_name = "weave_forge_item_preview_" .. arg_11_1,
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
		scenegraph_id = arg_11_1
	}
end

HeroWindowWeaveForgeOverview.on_exit = function (arg_12_0, arg_12_1)
	print("[HeroViewWindow] Exit Substate HeroWindowWeaveForgeOverview")

	arg_12_0._ui_animator = nil

	if arg_12_0._viewports_data then
		local var_12_0 = arg_12_0._ui_top_renderer

		for iter_12_0, iter_12_1 in ipairs(arg_12_0._viewports_data) do
			local var_12_1 = iter_12_1.item_previewer

			if var_12_1 then
				var_12_1:destroy()
			end

			local var_12_2 = iter_12_1.unit_previewer

			if var_12_2 then
				var_12_2:destroy()
			end

			local var_12_3 = iter_12_1.widget

			UIWidget.destroy(var_12_0, var_12_3)
		end

		arg_12_0._viewports_data = nil
	end
end

HeroWindowWeaveForgeOverview.update = function (arg_13_0, arg_13_1, arg_13_2)
	if var_0_8 then
		var_0_8 = false

		arg_13_0:create_ui_elements()
	end

	local var_13_0 = arg_13_0._parent:window_input_service()
	local var_13_1 = Managers.input:is_device_active("gamepad")

	if arg_13_0._viewports_data then
		for iter_13_0, iter_13_1 in ipairs(arg_13_0._viewports_data) do
			local var_13_2 = iter_13_1.viewport_button
			local var_13_3 = iter_13_1.viewport_button_highlight
			local var_13_4 = iter_13_1.viewport_button_text_highlight
			local var_13_5 = iter_13_1.item_previewer
			local var_13_6 = iter_13_1.unit_previewer
			local var_13_7 = arg_13_0:_is_button_hover(var_13_2)
			local var_13_8 = false
			local var_13_9 = iter_13_1.hover_progress or 0
			local var_13_10 = 5
			local var_13_11

			if var_13_7 then
				var_13_9 = math.min(var_13_9 + arg_13_1 * var_13_10, 1)
			else
				var_13_9 = math.max(var_13_9 - arg_13_1 * var_13_10, 0)
			end

			iter_13_1.hover_progress = var_13_9

			local var_13_12 = math.ease_out_quad(var_13_9)

			var_13_3.alpha_multiplier = var_13_12
			var_13_4.alpha_multiplier = var_13_12

			local var_13_13 = 0.12 * var_13_12

			if var_13_5 then
				var_13_5:set_zoom_fraction(var_13_13)
				var_13_5:update(arg_13_1, arg_13_2, var_13_8 and var_13_0)
			end

			if var_13_6 then
				var_13_6:set_zoom_fraction(var_13_13)
				var_13_6:update(arg_13_1, arg_13_2, var_13_8 and var_13_0)
			end
		end
	end

	local var_13_14 = arg_13_0._upgrade_forge_done_time

	if var_13_14 and var_13_14 < arg_13_2 then
		local var_13_15 = arg_13_0._upgrade_forge_response

		if var_13_15 ~= nil then
			arg_13_0:_upgrade_forge_done(var_13_15)

			arg_13_0._upgrade_forge_done_time = nil
			arg_13_0._upgrade_forge_response = nil
		end
	end

	arg_13_0:_update_animations(arg_13_1)
	arg_13_0:_draw(arg_13_1)
end

HeroWindowWeaveForgeOverview.post_update = function (arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0._viewports_data then
		arg_14_0:_initialize_viewports()
	end

	if arg_14_0._viewports_data then
		for iter_14_0, iter_14_1 in ipairs(arg_14_0._viewports_data) do
			local var_14_0 = iter_14_1.item_previewer
			local var_14_1 = iter_14_1.unit_previewer

			if var_14_0 then
				var_14_0:post_update(arg_14_1, arg_14_2)
			end

			if var_14_1 then
				var_14_1:post_update(arg_14_1, arg_14_2)
			end
		end
	end

	arg_14_0:_handle_input(arg_14_1, arg_14_2)
end

HeroWindowWeaveForgeOverview._update_animations = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._ui_animations
	local var_15_1 = arg_15_0._animations
	local var_15_2 = arg_15_0._ui_animator

	for iter_15_0, iter_15_1 in pairs(arg_15_0._ui_animations) do
		UIAnimation.update(iter_15_1, arg_15_1)

		if UIAnimation.completed(iter_15_1) then
			arg_15_0._ui_animations[iter_15_0] = nil
		end
	end

	var_15_2:update(arg_15_1)

	for iter_15_2, iter_15_3 in pairs(var_15_1) do
		if var_15_2:is_animation_completed(iter_15_3) then
			var_15_2:stop_animation(iter_15_3)

			var_15_1[iter_15_2] = nil
		end
	end

	if arg_15_0._viewports_data then
		for iter_15_4, iter_15_5 in ipairs(arg_15_0._viewports_data) do
			if iter_15_5.customize_button then
				-- Nothing
			end

			local var_15_3 = iter_15_5.change_button

			if var_15_3 then
				UIWidgetUtils.animate_icon_button(var_15_3, arg_15_1)
			end
		end
	end

	local var_15_4 = arg_15_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_15_4.upgrade_button, arg_15_1)
end

HeroWindowWeaveForgeOverview._is_button_pressed = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1.content
	local var_16_1 = var_16_0.button_hotspot or var_16_0.hotspot

	if var_16_1.on_pressed or arg_16_2 and var_16_1.on_double_click then
		var_16_1.on_pressed = false

		if not var_16_1.is_selected then
			return true
		end
	end
end

HeroWindowWeaveForgeOverview._is_button_hover_enter = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.content
	local var_17_1 = var_17_0.button_hotspot or var_17_0.hotspot

	return var_17_1.on_hover_enter and not var_17_1.is_selected
end

HeroWindowWeaveForgeOverview._is_button_hover = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.content

	return (var_18_0.button_hotspot or var_18_0.hotspot).is_hover
end

HeroWindowWeaveForgeOverview._is_button_hover_exit = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.content
	local var_19_1 = var_19_0.button_hotspot or var_19_0.hotspot

	return var_19_1.on_hover_exit and not var_19_1.is_selected
end

HeroWindowWeaveForgeOverview._is_button_selected = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.content

	return (var_20_0.button_hotspot or var_20_0.hotspot).is_selected
end

HeroWindowWeaveForgeOverview._sync_backend_loadout = function (arg_21_0)
	local var_21_0 = Managers.backend:get_interface("weaves")
	local var_21_1 = var_21_0:get_forge_level()
	local var_21_2 = var_21_0:forge_max_level()

	arg_21_0:_set_forge_level(var_21_1)

	arg_21_0._forge_level = var_21_1

	local var_21_3 = var_21_1 < var_21_2

	arg_21_0:_set_forge_upgrade_price_by_level(var_21_1 + (var_21_3 and 1 or 0))
	arg_21_0:_setup_upgrade_tooltip(1)
end

HeroWindowWeaveForgeOverview._handle_input = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._parent
	local var_22_1 = arg_22_0._widgets_by_name
	local var_22_2 = Managers.input:is_device_active("gamepad")
	local var_22_3 = arg_22_0._parent:window_input_service()
	local var_22_4 = arg_22_0._params

	if arg_22_0._viewports_data then
		for iter_22_0, iter_22_1 in ipairs(arg_22_0._viewports_data) do
			local var_22_5 = iter_22_1.change_button

			if var_22_5 and arg_22_0:_is_button_hover_enter(var_22_5) then
				arg_22_0:_play_sound("Play_hud_hover")
			end

			if var_22_5 and arg_22_0:_is_button_pressed(var_22_5) then
				local var_22_6 = iter_22_1.item
				local var_22_7 = iter_22_1.slot_name

				if var_22_6 then
					var_22_4.selected_item = var_22_6
					var_22_4.selected_slot_name = var_22_7

					var_22_0:set_layout_by_name("weave_weapon_select")

					break
				end
			end

			local var_22_8 = iter_22_1.viewport_button

			if var_22_8 and arg_22_0:_is_button_hover_enter(var_22_8) then
				arg_22_0:_play_sound("menu_magic_forge_hover")
			end

			if var_22_8 and arg_22_0:_is_button_pressed(var_22_8) then
				local var_22_9 = iter_22_1.item
				local var_22_10 = iter_22_1.slot_name
				local var_22_11 = iter_22_1.unit_name

				var_22_4.selected_item = var_22_9
				var_22_4.selected_slot_name = var_22_10
				var_22_4.selected_unit_name = var_22_11

				var_22_0:set_layout_by_name("weave_properties")

				break
			end
		end
	end

	local var_22_12 = var_22_1.upgrade_button

	if arg_22_0:_is_button_hover_enter(var_22_12) and not var_22_12.content.button_hotspot.disable_button then
		arg_22_0:_play_sound("Play_hud_hover")
	end

	if arg_22_0:_is_button_pressed(var_22_12) then
		arg_22_0:_upgrade_forge()
	end
end

HeroWindowWeaveForgeOverview._draw = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._parent:get_ui_renderer()
	local var_23_1 = arg_23_0._ui_top_renderer
	local var_23_2 = arg_23_0._ui_scenegraph
	local var_23_3 = arg_23_0._parent
	local var_23_4 = var_23_3:window_input_service()
	local var_23_5 = arg_23_0._render_settings
	local var_23_6 = var_23_3:hdr_renderer()
	local var_23_7 = var_23_3:hdr_top_renderer()
	local var_23_8 = var_23_5.alpha_multiplier

	UIRenderer.begin_pass(var_23_6, var_23_2, var_23_4, arg_23_1, nil, var_23_5)

	local var_23_9 = var_23_5.snap_pixel_positions

	for iter_23_0, iter_23_1 in ipairs(arg_23_0._bottom_hdr_widgets) do
		var_23_5.alpha_multiplier = iter_23_1.alpha_multiplier or var_23_8

		UIRenderer.draw_widget(var_23_6, iter_23_1)
	end

	UIRenderer.end_pass(var_23_6)
	UIRenderer.begin_pass(var_23_7, var_23_2, var_23_4, arg_23_1, nil, var_23_5)

	local var_23_10 = var_23_5.snap_pixel_positions

	for iter_23_2, iter_23_3 in ipairs(arg_23_0._top_hdr_widgets) do
		var_23_5.alpha_multiplier = iter_23_3.alpha_multiplier or var_23_8

		UIRenderer.draw_widget(var_23_7, iter_23_3)
	end

	UIRenderer.end_pass(var_23_7)
	UIRenderer.begin_pass(var_23_1, var_23_2, var_23_4, arg_23_1, nil, var_23_5)

	local var_23_11 = var_23_5.snap_pixel_positions

	for iter_23_4, iter_23_5 in ipairs(arg_23_0._top_widgets) do
		var_23_5.alpha_multiplier = iter_23_5.alpha_multiplier or var_23_8

		UIRenderer.draw_widget(var_23_1, iter_23_5)
	end

	UIRenderer.end_pass(var_23_1)
	UIRenderer.begin_pass(var_23_0, var_23_2, var_23_4, arg_23_1, nil, var_23_5)

	if arg_23_0._viewports_data then
		for iter_23_6, iter_23_7 in ipairs(arg_23_0._viewports_data) do
			local var_23_12 = iter_23_7.widget

			var_23_5.alpha_multiplier = var_23_12.alpha_multiplier or var_23_8

			UIRenderer.draw_widget(var_23_0, var_23_12)
		end
	end

	for iter_23_8, iter_23_9 in ipairs(arg_23_0._bottom_widgets) do
		var_23_5.alpha_multiplier = iter_23_9.alpha_multiplier or var_23_8

		UIRenderer.draw_widget(var_23_0, iter_23_9)
	end

	UIRenderer.end_pass(var_23_0)

	var_23_5.alpha_multiplier = var_23_8
end

HeroWindowWeaveForgeOverview._set_forge_upgrade_price_by_level = function (arg_24_0, arg_24_1)
	local var_24_0 = Managers.backend:get_interface("weaves")
	local var_24_1 = var_24_0:get_essence()
	local var_24_2 = var_24_0:forge_upgrade_cost(arg_24_1 - arg_24_0._forge_level)
	local var_24_3 = var_24_2 and var_24_2 <= var_24_1 or false

	arg_24_0:_set_essence_upgrade_cost(var_24_2, var_24_3)
end

HeroWindowWeaveForgeOverview._upgrade_forge_cb = function (arg_25_0, arg_25_1)
	arg_25_0._upgrade_forge_response = arg_25_1
end

HeroWindowWeaveForgeOverview._upgrade_forge_done = function (arg_26_0, arg_26_1)
	arg_26_0._params.upgrading = nil

	arg_26_0._parent:unblock_input()

	local var_26_0 = arg_26_0._widgets_by_name.upgrade_button

	var_26_0.content.upgrading = false

	if arg_26_1 then
		arg_26_0:_play_sound("menu_magic_forge_forge_upgrade")
		arg_26_0:_sync_backend_loadout()
		Managers.state.event:trigger("weave_forge_upgraded")

		if arg_26_0.forge_upgrade_tutorial then
			arg_26_0.forge_upgrade_tutorial = false
			var_26_0.content.highlighted = false
			arg_26_0._ui_animations.upgrade_button_pulse = nil
		end

		local var_26_1 = "upgrade"
		local var_26_2 = arg_26_0._animations[var_26_1]

		if var_26_2 then
			arg_26_0._ui_animator:stop_animation(var_26_2)

			arg_26_0._animations[var_26_1] = nil
		end

		arg_26_0:_start_transition_animation(var_26_1)
	end
end

HeroWindowWeaveForgeOverview._upgrade_forge = function (arg_27_0)
	arg_27_0._params.upgrading = true

	arg_27_0._parent:block_input()

	arg_27_0._upgrade_forge_done_time = Managers.time:time("ui") + var_0_9
	arg_27_0._upgrade_forge_response = nil
	arg_27_0._widgets_by_name.upgrade_button.content.upgrading = true

	local var_27_0 = 1
	local var_27_1 = Managers.backend:get_interface("weaves")
	local var_27_2 = callback(arg_27_0, "_upgrade_forge_cb")

	var_27_1:upgrade_forge(var_27_0, var_27_2)
end

HeroWindowWeaveForgeOverview._setup_upgrade_tooltip = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._widgets_by_name.upgrade_button
	local var_28_1
	local var_28_2 = Managers.backend:get_interface("weaves")
	local var_28_3 = var_28_2:get_forge_level()
	local var_28_4 = var_28_2:forge_max_level()
	local var_28_5 = var_28_3 + arg_28_1

	if var_28_5 <= var_28_4 then
		var_28_1 = {
			title = string.format(Localize("menu_weave_forge_tooltip_upgrade_athanor_title"), var_28_5),
			sub_title = string.format(Localize("menu_weave_forge_tooltip_upgrade_item_description"), var_28_4),
			divider_description = Localize("menu_weave_forge_tooltip_upgrade_athanor_description"),
			upgrade_effect_title = Localize("menu_weave_forge_tooltip_upgrade_item_effect_title")
		}

		local var_28_6 = Managers.backend:get_interface("weaves")
		local var_28_7
		local var_28_8 = WeaveProperties.properties

		for iter_28_0, iter_28_1 in pairs(var_28_8) do
			local var_28_9 = var_28_6:get_property_required_forge_level(iter_28_0) or 0

			if var_28_3 < var_28_9 and var_28_9 <= var_28_5 then
				local var_28_10 = iter_28_1.icon or "icons_placeholder"
				local var_28_11 = var_28_6:get_property_mastery_costs(iter_28_0)
				local var_28_12 = UIUtils.get_weave_property_description(iter_28_0, iter_28_1, var_28_11)

				var_28_7 = var_28_7 or {}
				var_28_7[#var_28_7 + 1] = {
					text = var_28_12,
					icon = var_28_10,
					required_forge_level = var_28_9
				}
			end
		end

		if var_28_7 then
			table.sort(var_28_7, function (arg_29_0, arg_29_1)
				local var_29_0 = arg_29_0.required_forge_level
				local var_29_1 = arg_29_1.required_forge_level

				if var_29_0 == var_29_1 then
					return arg_29_0.text <= arg_29_1.text
				end

				return var_29_0 < var_29_1
			end)
		end

		var_28_1.property_unlock_table = var_28_7

		local var_28_13
		local var_28_14 = WeaveTraits.traits

		for iter_28_2, iter_28_3 in pairs(var_28_14) do
			local var_28_15 = var_28_6:get_trait_required_forge_level(iter_28_2) or 0

			if var_28_3 < var_28_15 and var_28_15 <= var_28_5 then
				local var_28_16 = iter_28_3.display_name
				local var_28_17 = iter_28_3.icon
				local var_28_18 = Localize(var_28_16)

				var_28_13 = var_28_13 or {}
				var_28_13[#var_28_13 + 1] = {
					text = var_28_18,
					icon = var_28_17,
					required_forge_level = var_28_15
				}
			end
		end

		if var_28_13 then
			table.sort(var_28_13, function (arg_30_0, arg_30_1)
				local var_30_0 = arg_30_0.required_forge_level
				local var_30_1 = arg_30_1.required_forge_level

				if var_30_0 == var_30_1 then
					return arg_30_0.text <= arg_30_1.text
				end

				return var_30_0 < var_30_1
			end)
		end

		var_28_1.trait_unlock_table = var_28_13
	end

	var_28_0.content.tooltip = var_28_1
end

HeroWindowWeaveForgeOverview._set_essence_upgrade_cost = function (arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0._widgets_by_name.upgrade_button
	local var_31_1 = var_31_0.content
	local var_31_2 = var_31_0.style
	local var_31_3 = arg_31_0._ui_top_renderer
	local var_31_4 = ""
	local var_31_5 = 0
	local var_31_6 = 0

	if arg_31_1 then
		var_31_6 = 15

		local var_31_7 = 170
		local var_31_8 = UIUtils.comma_value(arg_31_1)

		var_31_4 = Localize("menu_weave_forge_upgrade_button") .. " " .. var_31_8
		var_31_5 = math.min(UIUtils.get_text_width(var_31_3, var_31_2.title_text, var_31_4), var_31_7)

		local var_31_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_31_1.price_icon).size[1]
		local var_31_10 = 0
		local var_31_11 = -((var_31_9 + var_31_5 + var_31_10) / 2 - (var_31_5 / 2 + 5))

		var_31_2.title_text.offset[1] = var_31_2.title_text.default_offset[1] + var_31_11
		var_31_2.title_text_shadow.offset[1] = var_31_2.title_text_shadow.default_offset[1] + var_31_11
		var_31_2.title_text_disabled.offset[1] = var_31_2.title_text_disabled.default_offset[1] + var_31_11
		var_31_2.price_icon.offset[1] = var_31_2.title_text.offset[1] + var_31_5 / 2 + var_31_10
		var_31_2.price_icon_disabled.offset[1] = var_31_2.price_icon.offset[1]
		var_31_2.price_icon.color[1] = 255
		var_31_2.price_icon_disabled.color[1] = 255
		arg_31_0._can_upgrade = true
	else
		var_31_6 = 23

		local var_31_12 = 200

		var_31_4 = Localize("menu_weave_forge_upgrade_loadout_button_cap")
		var_31_5 = math.min(UIUtils.get_text_width(var_31_3, var_31_2.title_text, var_31_4), var_31_12)
		var_31_2.title_text.offset[1] = var_31_2.title_text.default_offset[1]
		var_31_2.title_text_shadow.offset[1] = var_31_2.title_text_shadow.default_offset[1]
		var_31_2.title_text_disabled.offset[1] = var_31_2.title_text_disabled.default_offset[1]
		var_31_2.price_icon.color[1] = 0
		var_31_2.price_icon_disabled.color[1] = 0
		arg_31_0._can_upgrade = false
	end

	local var_31_13 = var_31_6 + (var_31_1.size[1] / 2 - var_31_5 / 2)

	var_31_1.button_hotspot.disable_button = script_data["eac-untrusted"] or not arg_31_1 or not arg_31_2
	var_31_1.title_text = var_31_4
	var_31_2.title_text.size[1] = var_31_5
	var_31_2.title_text_shadow.size[1] = var_31_5
	var_31_2.title_text_disabled.size[1] = var_31_5
	var_31_2.title_text.offset[1] = var_31_13
	var_31_2.title_text_shadow.offset[1] = var_31_13
	var_31_2.title_text_disabled.offset[1] = var_31_13
end

HeroWindowWeaveForgeOverview._set_forge_level = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._widgets_by_name
	local var_32_1 = var_32_0.forge_level_title
	local var_32_2 = var_32_0.forge_level_text

	var_32_2.content.text = arg_32_1

	local var_32_3 = arg_32_0._ui_top_renderer
	local var_32_4 = math.min(170, UIUtils.get_text_width(var_32_3, var_32_1.style.text, var_32_1.content.text))
	local var_32_5 = math.min(30, UIUtils.get_text_width(var_32_3, var_32_2.style.text, var_32_2.content.text))
	local var_32_6 = arg_32_0._ui_scenegraph

	var_32_6[var_32_1.scenegraph_id].size[1] = var_32_4 + 5
	var_32_6[var_32_2.scenegraph_id].size[1] = var_32_5 + 5

	local var_32_7 = 10
	local var_32_8 = -((var_32_4 + var_32_5 + var_32_7) / 2 - var_32_4 / 2)

	var_32_1.style.text.offset[1] = var_32_8
	var_32_1.style.text_shadow.offset[1] = var_32_8
	var_32_2.style.text.offset[1] = var_32_8 + var_32_4 / 2 + var_32_5 / 2 + var_32_7
	var_32_2.style.text_shadow.offset[1] = var_32_2.style.text.offset[1]
end
