-- chunkname: @scripts/ui/hint_ui/hint_ui.lua

HintUI = class(HintUI)

HintUI.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._ui_context = arg_1_1
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._hint_name = arg_1_2
	arg_1_0._hint_settings = arg_1_3
	arg_1_0._hint_data = arg_1_3.data
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements()

	arg_1_0._input_service_name = "hint_ui"

	arg_1_0:setup_input()

	arg_1_0.hint_id = 0
	arg_1_0._has_widget_been_closed = false
end

HintUI.destroy = function (arg_2_0)
	if arg_2_0._is_visible then
		arg_2_0:hide()
	end
end

HintUI.create_ui_elements = function (arg_3_0)
	local var_3_0 = arg_3_0._hint_settings.data

	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_3_0.definitions.scenegraph_definition)

	local var_3_1
	local var_3_2, var_3_3 = UIUtils.create_widgets(var_3_0.definitions.widget_definitions)

	arg_3_0._widgets_by_name, arg_3_0._widgets = var_3_3, var_3_2

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_3_0.definitions.animation_definitions)
end

HintUI.update = function (arg_4_0, arg_4_1)
	if not arg_4_0._is_visible then
		return
	end

	arg_4_0:_handle_input(arg_4_1)
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:draw(arg_4_1)
end

HintUI._handle_input = function (arg_5_0, arg_5_1)
	return
end

HintUI.draw = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ui_top_renderer
	local var_6_1 = arg_6_0._ui_scenegraph
	local var_6_2 = arg_6_0:_get_input_service()
	local var_6_3 = arg_6_0._render_settings
	local var_6_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_2, arg_6_1, nil, var_6_3)
	UIRenderer.draw_all_widgets(var_6_0, arg_6_0._widgets)
	UIRenderer.end_pass(var_6_0)

	if var_6_4 and arg_6_0._menu_input_description then
		arg_6_0._menu_input_description:draw(var_6_0, arg_6_1)
	end
end

HintUI.show = function (arg_7_0)
	assert(not arg_7_0._is_visible)

	arg_7_0._is_visible = true
end

HintUI.hide = function (arg_8_0)
	assert(arg_8_0._is_visible)

	arg_8_0._is_visible = false
end

HintUI.exit_done = function (arg_9_0)
	return not arg_9_0._is_visible and arg_9_0._has_widget_been_closed
end

HintUI._start_transition_animation = function (arg_10_0, arg_10_1)
	return
end

HintUI._update_animations = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._ui_animator

	var_11_0:update(arg_11_1)

	local var_11_1 = arg_11_0._animations

	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		if var_11_0:is_animation_completed(iter_11_1) then
			var_11_0:stop_animation(iter_11_1)

			var_11_1[iter_11_0] = nil
		end
	end
end

HintUI.acquire_input = function (arg_12_0)
	local var_12_0 = arg_12_0._input_manager

	if var_12_0 then
		ShowCursorStack.show("HintUI")
		var_12_0:capture_input(ALL_INPUT_METHODS, 1, arg_12_0._input_service_name, "HintUI")
	end
end

HintUI.release_input = function (arg_13_0)
	local var_13_0 = arg_13_0._input_manager

	if var_13_0 then
		ShowCursorStack.hide("HintUI")
		var_13_0:release_input(ALL_INPUT_METHODS, 1, arg_13_0._input_service_name, "HintUI")
	end
end

HintUI.setup_input = function (arg_14_0)
	local var_14_0 = arg_14_0._input_manager
	local var_14_1 = arg_14_0._input_service_name

	if var_14_0 then
		var_14_0:create_input_service(var_14_1, "IngameMenuKeymaps", "IngameMenuFilters")
		var_14_0:map_device_to_service(var_14_1, "keyboard")
		var_14_0:map_device_to_service(var_14_1, "gamepad")
		var_14_0:map_device_to_service(var_14_1, "mouse")
	end
end

HintUI._get_input_service = function (arg_15_0)
	return Managers.input:get_service(arg_15_0._input_service_name)
end

HintUI.should_show = function (arg_16_0)
	return not arg_16_0._is_visible
end

HintUI.is_hint_showing = function (arg_17_0)
	return arg_17_0._is_visible
end

HintUI.start_animation = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_3 or {
		wwise_world = arg_18_0._wwise_world,
		render_settings = arg_18_0._render_settings
	}
	local var_18_1 = arg_18_0._ui_animator:start_animation(arg_18_1, arg_18_2, arg_18_0._hint_data.definitions.scenegraph_definition, var_18_0)
	local var_18_2 = arg_18_1

	arg_18_0._animations[var_18_2] = var_18_1

	return var_18_1
end

HintUI.get_hint_name = function (arg_19_0)
	return arg_19_0._hint_name
end
