-- chunkname: @scripts/ui/weave_tutorial/custom_popups/new_ui_popup.lua

local var_0_0 = local_require("scripts/ui/weave_tutorial/custom_popups/new_ui_popup_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.animation_definitions
local var_0_3 = var_0_0.generic_input_actions
local var_0_4 = var_0_0.page_data
local var_0_5 = "new_ui_popup"

NewUIPopup = class(NewUIPopup)

NewUIPopup.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0.world)
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._parent = arg_1_2
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements()

	local var_1_0 = Managers.input:get_service("weave_tutorial")

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_1_0._ui_top_renderer, var_1_0, 3, 900, var_0_3.default)

	arg_1_0._menu_input_description:set_input_description(nil)
end

NewUIPopup.destroy = function (arg_2_0)
	arg_2_0:_destroy_video()
end

NewUIPopup._create_ui_elements = function (arg_3_0)
	arg_3_0:_destroy_video()

	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_3_0 = {}
	local var_3_1 = {}
	local var_3_2 = {}
	local var_3_3 = {}
	local var_3_4 = var_0_0.base_widget_definitions

	for iter_3_0, iter_3_1 in pairs(var_3_4) do
		local var_3_5 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_5
		var_3_3[iter_3_0] = var_3_5
	end

	local var_3_6 = var_0_0.page_widget_definitions

	for iter_3_2, iter_3_3 in pairs(var_3_6) do
		local var_3_7 = UIWidget.init(iter_3_3)

		var_3_2[#var_3_2 + 1] = var_3_7
		var_3_3[iter_3_2] = var_3_7
	end

	arg_3_0._base_widgets = var_3_0
	arg_3_0._page_widgets = var_3_2
	arg_3_0._widgets_by_name = var_3_3
	arg_3_0._pages_seen = 0

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_top_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_2)

	arg_3_0:_change_page(1)
end

NewUIPopup._clear_page_data = function (arg_4_0)
	arg_4_0:_destroy_video()

	arg_4_0._current_page_widgets = {}
end

NewUIPopup._change_page = function (arg_5_0, arg_5_1)
	arg_5_0:_clear_page_data()

	local var_5_0 = var_0_4[arg_5_1]
	local var_5_1 = var_5_0.widgets
	local var_5_2 = arg_5_0._widgets_by_name

	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		arg_5_0._current_page_widgets[#arg_5_0._current_page_widgets + 1] = var_5_2[iter_5_1]
	end

	arg_5_0:_create_video(var_5_0.video)

	if arg_5_1 < #var_0_4 then
		arg_5_0._current_page_widgets[#arg_5_0._current_page_widgets + 1] = arg_5_0._widgets_by_name.next_button
	else
		arg_5_0._current_page_widgets[#arg_5_0._current_page_widgets + 1] = arg_5_0._widgets_by_name.ok_button
	end

	if arg_5_1 > 1 then
		arg_5_0._current_page_widgets[#arg_5_0._current_page_widgets + 1] = arg_5_0._widgets_by_name.prev_button
	end

	arg_5_0._page_index = arg_5_1
	arg_5_0._button_index = nil

	if arg_5_1 > arg_5_0._pages_seen then
		arg_5_0:start_transition_animation("page_enter", "page_" .. arg_5_1)

		arg_5_0._pages_seen = arg_5_1
	end
end

NewUIPopup._create_video = function (arg_6_0, arg_6_1)
	if not arg_6_1 then
		return
	end

	arg_6_0._video_data = arg_6_1
	arg_6_0._video_widget = UIWidget.init(UIWidgets.create_video("video", arg_6_0._video_data.material_name, var_0_5))
end

NewUIPopup._destroy_video = function (arg_7_0)
	local var_7_0 = arg_7_0._ui_top_renderer

	arg_7_0._video_data = nil

	if arg_7_0._video_widget then
		UIWidget.destroy(var_7_0, arg_7_0._video_widget)

		arg_7_0._video_widget = nil
	end

	if var_7_0.video_players[var_0_5] then
		UIRenderer.destroy_video_player(var_7_0, var_0_5, arg_7_0._world)
	end
end

NewUIPopup.update = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:_update_animations(arg_8_1)
	arg_8_0:_handle_input(arg_8_1, arg_8_2)
	arg_8_0:_draw(arg_8_1, arg_8_2)
end

NewUIPopup._update_animations = function (arg_9_0, arg_9_1)
	arg_9_0._ui_animator:update(arg_9_1)

	local var_9_0 = arg_9_0._animations
	local var_9_1 = arg_9_0._ui_animator

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if var_9_1:is_animation_completed(iter_9_1) then
			var_9_1:stop_animation(iter_9_1)

			var_9_0[iter_9_0] = nil
		end
	end

	if #var_0_4 > arg_9_0._page_index then
		UIWidgetUtils.animate_default_button(arg_9_0._widgets_by_name.next_button, arg_9_1)
	else
		UIWidgetUtils.animate_default_button(arg_9_0._widgets_by_name.ok_button, arg_9_1)
	end

	if arg_9_0._page_index > 1 then
		UIWidgetUtils.animate_default_button(arg_9_0._widgets_by_name.prev_button, arg_9_1)
	end
end

NewUIPopup._handle_input = function (arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._video_exanded then
		arg_10_0:_handle_keyboard_input(arg_10_1, arg_10_2)

		local var_10_0 = arg_10_2:get("confirm", true)
		local var_10_1 = arg_10_0._page_index
		local var_10_2 = #var_0_4

		if var_10_2 > arg_10_0._page_index then
			if arg_10_0._widgets_by_name.next_button.content.visible and UIUtils.is_button_pressed(arg_10_0._widgets_by_name.next_button, nil, var_10_0) then
				var_10_1 = math.min(var_10_1 + 1, var_10_2)
			end
		elseif arg_10_0._widgets_by_name.ok_button.content.visible and UIUtils.is_button_pressed(arg_10_0._widgets_by_name.ok_button, nil, var_10_0) then
			arg_10_0._parent:hide()
		end

		if arg_10_0._page_index > 1 and arg_10_0._widgets_by_name.prev_button.content.visible and UIUtils.is_button_pressed(arg_10_0._widgets_by_name.prev_button, nil, var_10_0) then
			var_10_1 = math.max(var_10_1 - 1, 1)
		end

		if var_10_1 ~= arg_10_0._page_index then
			arg_10_0:_change_page(var_10_1)
		end
	end

	arg_10_0:_handle_expand_video(arg_10_2)
end

NewUIPopup._handle_keyboard_input = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = {}
	local var_11_1 = arg_11_0._widgets_by_name
	local var_11_2 = arg_11_0._page_index
	local var_11_3 = #var_0_4

	if arg_11_0._page_index > 1 then
		var_11_0[#var_11_0 + 1] = var_11_1.prev_button
	end

	if var_11_3 > arg_11_0._page_index then
		var_11_0[#var_11_0 + 1] = var_11_1.next_button
	else
		var_11_0[#var_11_0 + 1] = var_11_1.ok_button
	end

	if Managers.input:is_device_active("mouse") then
		for iter_11_0, iter_11_1 in pairs(var_11_0) do
			iter_11_1.content.button_hotspot.is_selected = false
		end

		arg_11_0._button_index = nil

		return
	end

	local var_11_4 = #var_11_0
	local var_11_5 = arg_11_0._button_index or var_11_4
	local var_11_6 = Managers.input:get_service("popup")

	if var_11_6:get("move_right_hold_continuous") then
		var_11_5 = math.clamp(var_11_5 + 1, 1, var_11_4)
	elseif var_11_6:get("move_left_hold_continuous") then
		var_11_5 = math.clamp(var_11_5 - 1, 1, var_11_4)
	end

	if var_11_5 ~= arg_11_0._button_index then
		for iter_11_2, iter_11_3 in ipairs(var_11_0) do
			iter_11_3.content.button_hotspot.is_selected = var_11_5 == iter_11_2
		end

		arg_11_0._button_index = var_11_5

		arg_11_0:_play_sound("Play_hud_hover")
	end
end

NewUIPopup._draw = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._ui_top_renderer
	local var_12_1 = arg_12_0._ui_scenegraph
	local var_12_2 = arg_12_0._render_settings
	local var_12_3 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_12_0, var_12_1, arg_12_2, arg_12_1, nil, var_12_2)

	for iter_12_0, iter_12_1 in ipairs(arg_12_0._base_widgets) do
		UIRenderer.draw_widget(var_12_0, iter_12_1)
	end

	for iter_12_2, iter_12_3 in ipairs(arg_12_0._current_page_widgets) do
		UIRenderer.draw_widget(var_12_0, iter_12_3)
	end

	arg_12_0:_draw_video(var_12_0)
	UIRenderer.end_pass(var_12_0)

	if var_12_3 then
		arg_12_0._menu_input_description:draw(var_12_0, arg_12_1)
	end
end

NewUIPopup._draw_video = function (arg_13_0, arg_13_1)
	if not arg_13_0._video_data then
		return
	end

	if not arg_13_1.video_players[var_0_5] then
		UIRenderer.create_video_player(arg_13_1, var_0_5, arg_13_0._world, arg_13_0._video_data.video_name, arg_13_0._video_data.loop)
	elseif arg_13_0._video_widget.content.video_content.video_completed and not arg_13_0._video_data.loop then
		UIRenderer.destroy_video_player(arg_13_1, var_0_5)

		arg_13_0._video_data.sound_started = false

		if arg_13_0._video_data.sound_stop then
			Managers.music:trigger_event(arg_13_0._video_data.sound_stop)
		end

		if not Managers.transition:loading_icon_active() then
			Managers.transition:show_loading_icon()
		end
	else
		if not arg_13_0._video_data.sound_started then
			if arg_13_0._video_data.sound_start then
				Managers.music:trigger_event(arg_13_0._video_data.sound_start)
			end

			arg_13_0._video_data.sound_started = true
		end

		UIRenderer.draw_widget(arg_13_1, arg_13_0._video_widget)
	end
end

NewUIPopup._handle_expand_video = function (arg_14_0, arg_14_1)
	if not arg_14_0._video_exanded then
		if UIUtils.is_button_pressed(arg_14_0._widgets_by_name.video_hover) then
			arg_14_0._video_widget.scenegraph_id = "expanded_video"
			arg_14_0._video_exanded = true
		end
	elseif arg_14_1:get("left_release", true) or arg_14_1:get("confirm", true) or arg_14_1:get("toggle_menu", true) then
		arg_14_0._video_widget.scenegraph_id = "video"
		arg_14_0._video_exanded = false
	end
end

NewUIPopup.start_transition_animation = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = {
		wwise_world = arg_15_0._wwise_world,
		render_settings = arg_15_0._render_settings,
		page_data = var_0_4[arg_15_0._page_index],
		video_widget = arg_15_0._video_widget
	}
	local var_15_1 = arg_15_0._widgets_by_name
	local var_15_2 = arg_15_0._ui_animator:start_animation(arg_15_2, var_15_1, var_0_1, var_15_0)

	arg_15_0._animations[arg_15_1] = var_15_2
end

NewUIPopup._play_sound = function (arg_16_0, arg_16_1)
	Managers.music:trigger_event(arg_16_1)
end
