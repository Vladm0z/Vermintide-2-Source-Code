-- chunkname: @scripts/ui/weave_tutorial/weave_tutorial_popup_ui.lua

local var_0_0 = local_require("scripts/ui/weave_tutorial/weave_tutorial_popup_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.body_definitions
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.generic_input_actions

WeaveTutorialPopupUI = class(WeaveTutorialPopupUI)

local var_0_5 = 40

function WeaveTutorialPopupUI.init(arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.world = arg_1_1.world
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_0.world)
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.ui_context = arg_1_1
	arg_1_0.body_paragraphs = {}
	arg_1_0.body_paragraph_heights = {}
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements()
	arg_1_0:_setup_input()

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_1_0.ui_top_renderer, Managers.input:get_service("weave_tutorial"), 3, 900, var_0_4.default)

	arg_1_0._menu_input_description:set_input_description(nil)
end

function WeaveTutorialPopupUI._setup_input(arg_2_0)
	arg_2_0.input_manager:create_input_service("weave_tutorial", "IngameMenuKeymaps", "IngameMenuFilters")
	arg_2_0.input_manager:map_device_to_service("weave_tutorial", "keyboard")
	arg_2_0.input_manager:map_device_to_service("weave_tutorial", "mouse")
	arg_2_0.input_manager:map_device_to_service("weave_tutorial", "gamepad")
end

function WeaveTutorialPopupUI._create_ui_elements(arg_3_0)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_3_0 = var_0_0.widget_definitions

	arg_3_0.widgets = {}

	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_2 = UIWidget.init(iter_3_1)

		arg_3_0.widgets[#arg_3_0.widgets + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0.widgets_by_name = var_3_1
	arg_3_0.button_1 = var_3_1.button_1
	arg_3_0.button_2 = var_3_1.button_2
	arg_3_0.title_text = var_3_1.title_text
	arg_3_0.sub_title_text = var_3_1.sub_title_text
	arg_3_0.body_text = UIWidget.init(var_0_2.body_text)
	arg_3_0.body_text_divider = UIWidget.init(var_0_2.paragraph_divider)

	local var_3_3 = arg_3_0.ui_scenegraph

	arg_3_0.title_start_y = UISceneGraph.get_world_position(var_3_3, "title")[2]
	arg_3_0.sub_title_start_y = UISceneGraph.get_world_position(var_3_3, "sub_title")[2]
	arg_3_0.body_start_y = UISceneGraph.get_world_position(var_3_3, "body")[2]
	arg_3_0.button_height = var_0_1.button_1.position[2] + var_0_1.button_1.size[2]

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_3)
end

function WeaveTutorialPopupUI.show(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	if arg_4_0.is_visible then
		print("WeaveTutorialPopupUI is already visible")

		return
	end

	arg_4_0._optional_button_2_func = arg_4_5

	arg_4_0._menu_input_description:set_input_description(arg_4_6)
	arg_4_0:start_transition_animation("on_show", "transition_enter")
	arg_4_0:populate_message(arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_7, arg_4_8)

	arg_4_0.is_visible = true

	arg_4_0:_acquire_input()
end

function WeaveTutorialPopupUI.show_custom_popup(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.custom_popup

	arg_5_0._custom_popup = rawget(_G, var_5_0):new(arg_5_0.ui_context, arg_5_0)
	arg_5_0.is_visible = true

	arg_5_0:_acquire_input()
end

function WeaveTutorialPopupUI.hide(arg_6_0)
	if not arg_6_0.is_visible then
		return
	end

	arg_6_0.is_visible = false

	arg_6_0:_release_input()
	arg_6_0:_destroy_custom_popup()
end

function WeaveTutorialPopupUI._destroy_custom_popup(arg_7_0)
	if arg_7_0._custom_popup then
		arg_7_0._custom_popup:destroy()

		arg_7_0._custom_popup = nil
	end
end

function WeaveTutorialPopupUI.destroy(arg_8_0)
	arg_8_0:hide()

	arg_8_0.widgets = nil
	arg_8_0.widgets_by_name = nil
	arg_8_0.button_1 = nil
	arg_8_0.button_2 = nil
	arg_8_0.title_text = nil
	arg_8_0.sub_title_text = nil
	arg_8_0.body_text = nil
	arg_8_0.ui_animator = nil
end

function WeaveTutorialPopupUI.update(arg_9_0, arg_9_1)
	if not arg_9_0.is_visible then
		return
	end

	local var_9_0 = arg_9_0.input_manager:get_service("weave_tutorial")

	if arg_9_0._custom_popup then
		arg_9_0._custom_popup:update(arg_9_1, var_9_0)
	else
		if UIUtils.is_button_pressed(arg_9_0.button_1) or var_9_0:get("toggle_menu", true) or var_9_0:get("confirm_press", true) then
			arg_9_0:hide()

			return
		end

		if arg_9_0._optional_button_2_func and (UIUtils.is_button_pressed(arg_9_0.button_2) or var_9_0:get("special_1_press", true)) then
			arg_9_0._optional_button_2_func(arg_9_0)
			arg_9_0:hide()

			return
		end

		arg_9_0:_update_animations(arg_9_1)
		arg_9_0:_draw(arg_9_1, var_9_0)
	end
end

function WeaveTutorialPopupUI._update_animations(arg_10_0, arg_10_1)
	arg_10_0.ui_animator:update(arg_10_1)

	local var_10_0 = arg_10_0._animations
	local var_10_1 = arg_10_0.ui_animator

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if var_10_1:is_animation_completed(iter_10_1) then
			var_10_1:stop_animation(iter_10_1)

			var_10_0[iter_10_0] = nil
		end
	end

	UIWidgetUtils.animate_default_button(arg_10_0.button_1, arg_10_1)
	UIWidgetUtils.animate_default_button(arg_10_0.button_2, arg_10_1)
end

function WeaveTutorialPopupUI._draw(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0._custom_popup then
		return
	end

	local var_11_0 = arg_11_0.ui_top_renderer
	local var_11_1 = arg_11_0.ui_scenegraph
	local var_11_2 = arg_11_0.render_settings
	local var_11_3 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_11_0, var_11_1, arg_11_2, arg_11_1, nil, var_11_2)

	for iter_11_0, iter_11_1 in ipairs(arg_11_0.widgets) do
		UIRenderer.draw_widget(var_11_0, iter_11_1)
	end

	arg_11_0:draw_body(var_11_0)
	UIRenderer.end_pass(var_11_0)

	if var_11_3 then
		arg_11_0._menu_input_description:draw(var_11_0, arg_11_1)
	end
end

function WeaveTutorialPopupUI.populate_message(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = arg_12_0.title_text.content

	var_12_0.text = arg_12_1 or ""
	var_12_0.visible = arg_12_1 ~= nil

	local var_12_1 = arg_12_0.sub_title_text.content

	var_12_1.text = arg_12_2 or ""
	var_12_1.visible = arg_12_2 ~= nil

	local var_12_2 = arg_12_0.button_2

	if arg_12_4 then
		var_12_2.content.visible = true
		var_12_2.content.title_text = Localize(arg_12_4)
	else
		var_12_2.content.visible = false
	end

	local var_12_3 = arg_12_5 and arg_12_3 or Localize(arg_12_3)

	arg_12_0.body_paragraphs = UIRenderer.break_paragraphs(var_12_3, {})

	arg_12_0:resize_to_fit()

	local var_12_4 = arg_12_0.widgets

	for iter_12_0 = 1, #var_12_4 do
		var_12_4[iter_12_0].element.dirty = true
	end
end

function WeaveTutorialPopupUI.resize_to_fit(arg_13_0)
	local var_13_0 = arg_13_0.ui_top_renderer
	local var_13_1 = arg_13_0.ui_scenegraph
	local var_13_2 = var_13_1.sub_title
	local var_13_3 = var_13_1.body
	local var_13_4 = var_13_1.window
	local var_13_5 = var_13_3.size
	local var_13_6 = arg_13_0.body_text.style.text
	local var_13_7 = 0

	arg_13_0.body_paragraph_heights = {}

	local var_13_8 = arg_13_0.body_paragraphs
	local var_13_9 = #var_13_8

	for iter_13_0 = 1, var_13_9 do
		local var_13_10 = UIUtils.get_text_height(var_13_0, var_13_5, var_13_6, var_13_8[iter_13_0])

		arg_13_0.body_paragraph_heights[iter_13_0] = var_13_10
		var_13_7 = var_13_7 + var_13_10

		if iter_13_0 < var_13_9 then
			var_13_7 = var_13_7 + var_0_5
		end
	end

	var_13_3.size[2] = var_13_7

	local var_13_11 = arg_13_0.title_text.content.visible
	local var_13_12 = var_0_1.sub_title.position

	var_13_2.position[2] = var_13_11 and var_13_12[2] or 0

	local var_13_13 = arg_13_0.sub_title_text.content.visible
	local var_13_14 = var_0_1.body.position

	var_13_3.position[2] = var_13_13 and var_13_14[2] or var_13_12[2]

	local var_13_15 = arg_13_0:calculate_base_window_height()

	var_13_4.size[2] = var_13_7 + var_13_15

	local var_13_16 = arg_13_0.button_1
	local var_13_17 = arg_13_0.button_2

	if var_13_17.content.visible then
		local var_13_18 = 20
		local var_13_19 = var_0_1.button_1.size

		var_13_16.offset[1] = var_13_19[1] * 0.5 + var_13_18
		var_13_17.offset[1] = -var_13_19[1] * 0.5 - var_13_18
	else
		var_13_16.offset[1] = 0
	end
end

function WeaveTutorialPopupUI.calculate_base_window_height(arg_14_0)
	local var_14_0 = arg_14_0.title_start_y - arg_14_0.sub_title_start_y
	local var_14_1 = arg_14_0.title_text.content.visible and 0 or var_14_0
	local var_14_2 = arg_14_0.sub_title_start_y - arg_14_0.body_start_y
	local var_14_3

	var_14_3 = arg_14_0.sub_title_text.content.visible and 0 or var_14_2

	return arg_14_0.button_height - arg_14_0.body_start_y - var_14_1 + 50
end

function WeaveTutorialPopupUI.draw_body(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.body_text
	local var_15_1 = arg_15_0.body_text_divider
	local var_15_2 = var_15_0.offset
	local var_15_3 = var_15_1.offset
	local var_15_4 = 0
	local var_15_5 = arg_15_0.body_paragraphs
	local var_15_6 = arg_15_0.body_paragraph_heights
	local var_15_7 = #var_15_5

	for iter_15_0 = 1, var_15_7 do
		var_15_2[2] = -var_15_4
		var_15_0.content.text = var_15_5[iter_15_0]

		UIRenderer.draw_widget(arg_15_1, var_15_0)

		var_15_4 = var_15_4 + var_15_6[iter_15_0]

		if iter_15_0 < var_15_7 then
			var_15_3[2] = -(var_15_4 + var_0_5 / 2)

			UIRenderer.draw_widget(arg_15_1, var_15_1)

			var_15_4 = var_15_4 + var_0_5
		end
	end
end

function WeaveTutorialPopupUI.start_transition_animation(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {
		wwise_world = arg_16_0.wwise_world,
		render_settings = arg_16_0.render_settings,
		text_highlight_widget = arg_16_0.widgets_by_name.result_text_bg
	}
	local var_16_1 = {
		arg_16_0.widgets_by_name.screen_background
	}
	local var_16_2 = arg_16_0.ui_animator:start_animation(arg_16_2, var_16_1, var_0_1, var_16_0)

	arg_16_0._animations[arg_16_1] = var_16_2
end

function WeaveTutorialPopupUI._acquire_input(arg_17_0)
	arg_17_0.input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "weave_tutorial", "WeaveTutorialPopupUI")
	ShowCursorStack.show("WeaveTutorialPopupUI")
end

function WeaveTutorialPopupUI._release_input(arg_18_0)
	arg_18_0.input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "weave_tutorial", "WeaveTutorialPopupUI")
	ShowCursorStack.hide("WeaveTutorialPopupUI")
end
