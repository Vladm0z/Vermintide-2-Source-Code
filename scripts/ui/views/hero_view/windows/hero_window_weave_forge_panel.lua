-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_weave_forge_panel.lua

require("scripts/ui/views/menu_world_previewer")
require("scripts/helpers/weave_utils")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_panel_definitions")
local var_0_1 = var_0_0.top_widgets
local var_0_2 = var_0_0.bottom_widgets
local var_0_3 = var_0_0.bottom_hdr_widgets
local var_0_4 = var_0_0.scenegraph_definition
local var_0_5 = var_0_0.animation_definitions
local var_0_6 = false

HeroWindowWeaveForgePanel = class(HeroWindowWeaveForgePanel)
HeroWindowWeaveForgePanel.NAME = "HeroWindowWeaveForgePanel"

HeroWindowWeaveForgePanel.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowWeaveForgePanel")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._wwise_world = var_1_0.wwise_world
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._ingame_ui_context = var_1_0

	local var_1_1 = Managers.input
	local var_1_2 = {
		wwise_world = arg_1_0._wwise_world,
		ui_renderer = arg_1_0._ui_renderer,
		ui_top_renderer = arg_1_0._ui_top_renderer,
		input_manager = var_1_1
	}

	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	local var_1_3 = arg_1_1.hero_name
	local var_1_4 = arg_1_1.career_index
	local var_1_5 = arg_1_1.profile_index

	arg_1_0._career_name = SPProfiles[var_1_5].careers[var_1_4].name
	arg_1_0._hero_name = var_1_3
end

HeroWindowWeaveForgePanel._start_transition_animation = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = {
		wwise_world = arg_2_0._wwise_world,
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = arg_2_0._widgets_by_name
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_2, var_2_1, var_0_4, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

HeroWindowWeaveForgePanel._setup_definitions = function (arg_3_0)
	if arg_3_0._parent:gamepad_style_active() then
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_panel_console_definitions")
	else
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_panel_definitions")
	end

	var_0_1 = var_0_0.top_widgets
	var_0_2 = var_0_0.bottom_widgets
	var_0_3 = var_0_0.bottom_hdr_widgets
	var_0_4 = var_0_0.scenegraph_definition
	var_0_5 = var_0_0.animation_definitions
end

HeroWindowWeaveForgePanel.create_ui_elements = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_setup_definitions()

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_4)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_1[#var_4_1 + 1] = var_4_2
		var_4_0[iter_4_0] = var_4_2
	end

	local var_4_3 = {}

	for iter_4_2, iter_4_3 in pairs(var_0_2) do
		local var_4_4 = UIWidget.init(iter_4_3)

		var_4_3[#var_4_3 + 1] = var_4_4
		var_4_0[iter_4_2] = var_4_4
	end

	local var_4_5 = {}

	for iter_4_4, iter_4_5 in pairs(var_0_3) do
		local var_4_6 = UIWidget.init(iter_4_5)

		var_4_5[#var_4_5 + 1] = var_4_6
		var_4_0[iter_4_4] = var_4_6
	end

	arg_4_0._top_widgets = var_4_1
	arg_4_0._bottom_widgets = var_4_3
	arg_4_0._bottom_hdr_widgets = var_4_5
	arg_4_0._widgets_by_name = var_4_0
	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_5)

	if arg_4_2 then
		local var_4_7 = arg_4_0._ui_scenegraph.window.local_position

		var_4_7[1] = var_4_7[1] + arg_4_2[1]
		var_4_7[2] = var_4_7[2] + arg_4_2[2]
		var_4_7[3] = var_4_7[3] + arg_4_2[3]
	end

	arg_4_0:_setup_essence_tooltip()
	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_top_renderer)
end

HeroWindowWeaveForgePanel._setup_essence_tooltip = function (arg_5_0)
	local var_5_0 = arg_5_0._top_widgets
	local var_5_1 = arg_5_0._widgets_by_name
	local var_5_2 = UIUtils.comma_value(0)
	local var_5_3 = UIUtils.comma_value(0)
	local var_5_4 = string.format(Localize("menu_weave_forge_tooltip_essence_description_total"), var_5_2, var_5_3)
	local var_5_5 = "essence_panel"
	local var_5_6 = var_0_4[var_5_5].size
	local var_5_7 = {
		"weave_progression_slot_titles"
	}
	local var_5_8 = {
		title = Localize("menu_weave_forge_tooltip_essence_title"),
		description = Localize("menu_weave_forge_tooltip_essence_description"),
		divider_description = Localize("menu_weave_forge_tooltip_essence_description_base_game"),
		essence_title = Localize("menu_weave_forge_tooltip_essence_description_total_title"),
		input_highlight = var_5_4
	}
	local var_5_9 = 400
	local var_5_10 = true
	local var_5_11
	local var_5_12
	local var_5_13 = {
		96,
		0,
		0
	}
	local var_5_14 = UIWidgets.create_additional_option_tooltip(var_5_5, var_5_6, var_5_7, var_5_8, var_5_9, var_5_11, var_5_12, var_5_10, var_5_13)
	local var_5_15 = UIWidget.init(var_5_14)

	var_5_0[#var_5_0 + 1] = var_5_15
	var_5_1.essence_tooltip = var_5_15
end

HeroWindowWeaveForgePanel._set_essence_tooltip_amounts = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._widgets_by_name.essence_tooltip.content.tooltip
	local var_6_1 = UIUtils.comma_value(arg_6_1)
	local var_6_2 = UIUtils.comma_value(arg_6_2)
	local var_6_3 = string.format(Localize("menu_weave_forge_tooltip_essence_description_total"), var_6_1, var_6_2)

	var_6_0.title = Localize("menu_weave_forge_tooltip_essence_title")
	var_6_0.description = Localize("menu_weave_forge_tooltip_essence_description")
	var_6_0.divider_description = Localize("menu_weave_forge_tooltip_essence_description_base_game")
	var_6_0.essence_title = Localize("menu_weave_forge_tooltip_essence_description_total_title")
	var_6_0.input_highlight = var_6_3
end

HeroWindowWeaveForgePanel.on_exit = function (arg_7_0, arg_7_1)
	print("[HeroViewWindow] Exit Substate HeroWindowWeaveForgePanel")

	arg_7_0._ui_animator = nil

	local var_7_0 = Managers.world:world("level_world")
	local var_7_1 = LevelHelper:current_level(var_7_0)

	Level.trigger_event(var_7_1, "lua_keep_vom_magic_forge_on_exit")
end

HeroWindowWeaveForgePanel._set_loadout_power = function (arg_8_0, arg_8_1)
	arg_8_0._widgets_by_name.loadout_power_text.content.text = arg_8_1
end

HeroWindowWeaveForgePanel._set_essence_amount = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._widgets_by_name
	local var_9_1 = var_9_0.essence_text
	local var_9_2 = var_9_0.essence_icon
	local var_9_3 = UIUtils.comma_value(arg_9_1)

	var_9_1.content.text = var_9_3

	local var_9_4 = arg_9_0._ui_top_renderer
	local var_9_5 = UIUtils.get_text_width(var_9_4, var_9_1.style.text, var_9_3)
	local var_9_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_9_2.content.texture_id).size[1]
	local var_9_7 = 0
	local var_9_8 = var_9_6 + var_9_5 + var_9_7

	var_9_2.offset[1] = -(var_9_8 / 2 - var_9_6 / 2 + 5)
	var_9_1.offset[1] = var_9_2.offset[1] + var_9_6 / 2 + var_9_5 / 2 + var_9_7

	return var_9_3
end

HeroWindowWeaveForgePanel._sync_backend_loadout = function (arg_10_0)
	local var_10_0 = arg_10_0._career_name
	local var_10_1 = Managers.backend:get_interface("weaves")
	local var_10_2 = var_10_1:get_essence()
	local var_10_3 = var_10_1:get_maximum_essence()
	local var_10_4 = var_10_1:get_total_essence()

	arg_10_0._current_essence_amount = var_10_2
	arg_10_0._essence_value_string = arg_10_0:_set_essence_amount(math.min(var_10_2, var_10_3))

	arg_10_0:_set_essence_tooltip_amounts(math.min(var_10_4, var_10_3), var_10_3)

	local var_10_5 = var_10_1:get_average_power_level(var_10_0)
	local var_10_6 = UIUtils.presentable_hero_power_level_weaves(var_10_5)

	arg_10_0:_set_loadout_power(var_10_6)
end

HeroWindowWeaveForgePanel._is_button_pressed = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	if var_11_0.on_release then
		var_11_0.on_release = false

		if not var_11_0.is_selected then
			return true
		end
	end
end

HeroWindowWeaveForgePanel._handle_input = function (arg_12_0, arg_12_1, arg_12_2)
	return
end

HeroWindowWeaveForgePanel._play_sound = function (arg_13_0, arg_13_1)
	arg_13_0._parent:play_sound(arg_13_1)
end

HeroWindowWeaveForgePanel.update = function (arg_14_0, arg_14_1, arg_14_2)
	if var_0_6 then
		var_0_6 = false

		arg_14_0:create_ui_elements()
	end

	local var_14_0 = Managers.backend:get_interface("weaves"):get_essence()
	local var_14_1 = arg_14_0._parent:get_selected_layout_name()

	if var_14_1 ~= arg_14_0._selected_layout_name or var_14_0 ~= arg_14_0._current_essence_amount then
		arg_14_0:_sync_component_visibilty_by_layout(var_14_1)

		arg_14_0._selected_layout_name = var_14_1

		arg_14_0:_sync_backend_loadout()
	end

	arg_14_0:_handle_input(arg_14_1, arg_14_2)
	arg_14_0:_update_animations(arg_14_1)
	arg_14_0:_draw(arg_14_1)
end

HeroWindowWeaveForgePanel._sync_component_visibilty_by_layout = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._ui_scenegraph
	local var_15_1 = arg_15_0._widgets_by_name

	if arg_15_1 == "weave_overview" then
		local var_15_2 = true

		var_15_1.loadout_power_title.content.visible = var_15_2
		var_15_1.loadout_power_text.content.visible = var_15_2
		var_15_1.top_corner_right.content.visible = var_15_2
		var_15_1.loadout_power_tooltip.content.visible = var_15_2
		var_15_1.bottom_panel_left.content.visible = var_15_2
		var_15_1.bottom_panel_right.content.visible = var_15_2
	else
		local var_15_3 = false

		var_15_1.loadout_power_title.content.visible = var_15_3
		var_15_1.loadout_power_text.content.visible = var_15_3
		var_15_1.loadout_power_tooltip.content.visible = var_15_3
		var_15_1.bottom_panel_left.content.visible = var_15_3
		var_15_1.bottom_panel_right.content.visible = var_15_3
		var_15_1.top_corner_right.content.visible = arg_15_1 ~= "weave_properties"
	end

	local var_15_4 = arg_15_1 ~= "weave_properties"

	arg_15_0:_set_background_wheel_visibility(var_15_4)
end

HeroWindowWeaveForgePanel.post_update = function (arg_16_0, arg_16_1, arg_16_2)
	return
end

HeroWindowWeaveForgePanel._update_animations = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._params.upgrading
	local var_17_1 = arg_17_0._upgrading_anim_progress or 0
	local var_17_2 = 3

	if var_17_0 then
		var_17_1 = math.min(var_17_1 + arg_17_1 * var_17_2, 1)
	else
		var_17_1 = math.max(var_17_1 - arg_17_1 * var_17_2, 0)
	end

	arg_17_0._upgrading_anim_progress = var_17_1

	local var_17_3 = arg_17_0._ui_animations
	local var_17_4 = arg_17_0._animations
	local var_17_5 = arg_17_0._ui_animator

	for iter_17_0, iter_17_1 in pairs(arg_17_0._ui_animations) do
		UIAnimation.update(iter_17_1, arg_17_1)

		if UIAnimation.completed(iter_17_1) then
			arg_17_0._ui_animations[iter_17_0] = nil
		end
	end

	var_17_5:update(arg_17_1)

	for iter_17_2, iter_17_3 in pairs(var_17_4) do
		if var_17_5:is_animation_completed(iter_17_3) then
			var_17_5:stop_animation(iter_17_3)

			var_17_4[iter_17_2] = nil
		end
	end

	if arg_17_0._draw_background_wheel then
		arg_17_0:_update_background_animations(arg_17_1)
	end
end

HeroWindowWeaveForgePanel._draw = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._parent
	local var_18_1 = var_18_0:get_ui_renderer()
	local var_18_2 = arg_18_0._ui_top_renderer
	local var_18_3 = arg_18_0._ui_scenegraph
	local var_18_4 = arg_18_0._render_settings
	local var_18_5 = var_18_0:window_input_service()
	local var_18_6 = var_18_0:hdr_renderer()

	UIRenderer.begin_pass(var_18_6, var_18_3, var_18_5, arg_18_1, nil, var_18_4)

	local var_18_7 = var_18_4.snap_pixel_positions
	local var_18_8 = var_18_4.alpha_multiplier

	for iter_18_0, iter_18_1 in ipairs(arg_18_0._bottom_hdr_widgets) do
		var_18_4.alpha_multiplier = iter_18_1.alpha_multiplier or var_18_8

		UIRenderer.draw_widget(var_18_6, iter_18_1)
	end

	UIRenderer.end_pass(var_18_6)
	UIRenderer.begin_pass(var_18_1, var_18_3, var_18_5, arg_18_1, nil, var_18_4)

	local var_18_9 = var_18_4.alpha_multiplier

	for iter_18_2, iter_18_3 in ipairs(arg_18_0._bottom_widgets) do
		var_18_4.alpha_multiplier = iter_18_3.alpha_multiplier or var_18_9

		UIRenderer.draw_widget(var_18_1, iter_18_3)
	end

	UIRenderer.end_pass(var_18_1)
	UIRenderer.begin_pass(var_18_2, var_18_3, var_18_5, arg_18_1, nil, var_18_4)

	for iter_18_4, iter_18_5 in ipairs(arg_18_0._top_widgets) do
		var_18_4.alpha_multiplier = iter_18_5.alpha_multiplier or var_18_9

		UIRenderer.draw_widget(var_18_2, iter_18_5)
	end

	UIRenderer.end_pass(var_18_2)
end

HeroWindowWeaveForgePanel._set_background_bloom_intensity = function (arg_19_0, arg_19_1)
	local var_19_0 = 1.39
	local var_19_1 = 2 + 30 * arg_19_0._upgrading_anim_progress
	local var_19_2 = var_19_0 + math.clamp(arg_19_1, 0, 1) * var_19_1
	local var_19_3 = arg_19_0._parent:hdr_renderer().gui
	local var_19_4 = arg_19_0._widgets_by_name
	local var_19_5 = var_19_4.hdr_background_wheel_1.content.texture_id
	local var_19_6 = Gui.material(var_19_3, var_19_5)

	Material.set_scalar(var_19_6, "noise_intensity", var_19_2)

	for iter_19_0 = 1, 2 do
		local var_19_7 = var_19_4["hdr_wheel_ring_" .. iter_19_0 .. "_1"]
		local var_19_8 = var_19_4["hdr_wheel_ring_" .. iter_19_0 .. "_2"]
		local var_19_9 = var_19_4["hdr_wheel_ring_" .. iter_19_0 .. "_3"]
		local var_19_10 = var_19_7.content.texture_id
		local var_19_11 = var_19_8.content.texture_id
		local var_19_12 = var_19_9.content.texture_id
		local var_19_13 = Gui.material(var_19_3, var_19_10)
		local var_19_14 = Gui.material(var_19_3, var_19_11)
		local var_19_15 = Gui.material(var_19_3, var_19_12)

		Material.set_scalar(var_19_13, "noise_intensity", var_19_2)
		Material.set_scalar(var_19_14, "noise_intensity", var_19_2)
		Material.set_scalar(var_19_15, "noise_intensity", var_19_2)
	end
end

HeroWindowWeaveForgePanel._set_background_wheel_visibility = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._widgets_by_name
	local var_20_1 = var_20_0.background_wheel_1
	local var_20_2 = var_20_0.hdr_background_wheel_1

	var_20_1.content.visible = arg_20_1
	var_20_2.content.visible = arg_20_1

	for iter_20_0 = 1, 2 do
		local var_20_3 = var_20_0["wheel_ring_" .. iter_20_0 .. "_1"]
		local var_20_4 = var_20_0["wheel_ring_" .. iter_20_0 .. "_2"]
		local var_20_5 = var_20_0["wheel_ring_" .. iter_20_0 .. "_3"]
		local var_20_6 = var_20_0["hdr_wheel_ring_" .. iter_20_0 .. "_1"]
		local var_20_7 = var_20_0["hdr_wheel_ring_" .. iter_20_0 .. "_2"]
		local var_20_8 = var_20_0["hdr_wheel_ring_" .. iter_20_0 .. "_3"]

		var_20_3.content.visible = arg_20_1
		var_20_4.content.visible = arg_20_1
		var_20_5.content.visible = arg_20_1
		var_20_6.content.visible = arg_20_1
		var_20_7.content.visible = arg_20_1
		var_20_8.content.visible = arg_20_1
	end

	arg_20_0._draw_background_wheel = arg_20_1
end

HeroWindowWeaveForgePanel._update_background_animations = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._widgets_by_name

	for iter_21_0 = 1, 2 do
		local var_21_1 = var_21_0["wheel_ring_" .. iter_21_0 .. "_1"]
		local var_21_2 = var_21_0["wheel_ring_" .. iter_21_0 .. "_2"]
		local var_21_3 = var_21_0["wheel_ring_" .. iter_21_0 .. "_3"]
		local var_21_4 = var_21_0["hdr_wheel_ring_" .. iter_21_0 .. "_1"]
		local var_21_5 = var_21_0["hdr_wheel_ring_" .. iter_21_0 .. "_2"]
		local var_21_6 = var_21_0["hdr_wheel_ring_" .. iter_21_0 .. "_3"]
		local var_21_7 = 360
		local var_21_8 = math.degrees_to_radians(var_21_7)
		local var_21_9 = 1 + 4 * arg_21_0._upgrading_anim_progress
		local var_21_10 = arg_21_1 * 0.01 * var_21_9
		local var_21_11 = arg_21_1 * 0.008 * var_21_9
		local var_21_12 = arg_21_1 * 0.006 * var_21_9

		var_21_1.style.texture_id.angle = (var_21_1.style.texture_id.angle + var_21_8 * var_21_10) % var_21_8
		var_21_2.style.texture_id.angle = (var_21_2.style.texture_id.angle - var_21_8 * var_21_11) % -var_21_8
		var_21_3.style.texture_id.angle = (var_21_3.style.texture_id.angle + var_21_8 * var_21_12) % var_21_8
		var_21_4.style.texture_id.angle = var_21_1.style.texture_id.angle
		var_21_5.style.texture_id.angle = var_21_2.style.texture_id.angle
		var_21_6.style.texture_id.angle = var_21_3.style.texture_id.angle
	end

	local var_21_13 = 2.5
	local var_21_14 = 0.5 + math.sin(Managers.time:time("ui") * var_21_13) * 0.5

	arg_21_0:_set_background_bloom_intensity(var_21_14)
end
