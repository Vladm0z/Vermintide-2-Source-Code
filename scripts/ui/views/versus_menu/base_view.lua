-- chunkname: @scripts/ui/views/versus_menu/base_view.lua

BaseView = class(BaseView)

function BaseView.init(arg_1_0, arg_1_1, arg_1_2)
	fassert(arg_1_2, "No definitions passed")
	fassert(arg_1_2.scenegraph_definition, "No scenegraph in definitions")

	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._world = arg_1_1.world
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._render_settings = arg_1_0._render_settings or {}

	local var_1_0 = Managers.world:world("level_world")

	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._input_service_name = "ingame_menu"
	arg_1_0._definitions = arg_1_2
	arg_1_0._retained_mode = not not arg_1_2.retained_mode
	arg_1_0._dirty = true
	arg_1_0._animations = {}
end

function BaseView.destroy(arg_2_0)
	return
end

function BaseView.on_enter(arg_3_0)
	ShowCursorStack.show("BaseView")

	local var_3_0 = arg_3_0._input_manager
	local var_3_1 = arg_3_0._input_service_name

	var_3_0:block_device_except_service(var_3_1, "keyboard", 1)
	var_3_0:block_device_except_service(var_3_1, "mouse", 1)
	var_3_0:block_device_except_service(var_3_1, "gamepad", 1)
	arg_3_0:_create_ui_elements()
end

function BaseView.post_update_on_enter(arg_4_0)
	return
end

function BaseView.on_exit(arg_5_0)
	ShowCursorStack.hide("BaseView")

	local var_5_0 = arg_5_0._input_manager

	var_5_0:device_unblock_all_services("keyboard", 1)
	var_5_0:device_unblock_all_services("mouse", 1)
	var_5_0:device_unblock_all_services("gamepad", 1)
	arg_5_0:_destroy_ui_elements()
end

function BaseView.post_update_on_exit(arg_6_0)
	return
end

function BaseView._create_ui_elements(arg_7_0)
	local var_7_0 = arg_7_0._definitions
	local var_7_1 = var_7_0.scenegraph_definition

	arg_7_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_7_1)

	local var_7_2 = {}

	arg_7_0._widgets = UIUtils.create_widgets(var_7_0.widget_definitions, {}, var_7_2)

	local var_7_3 = var_7_0.top_widget_definitions

	if var_7_3 then
		arg_7_0._top_widgets = UIUtils.create_widgets(var_7_3, {}, var_7_2)
	end

	arg_7_0._widgets_by_name = var_7_2

	if var_7_0.animations then
		arg_7_0._ui_animator = UIAnimator:new(arg_7_0._ui_scenegraph, var_7_0.animations)
	end
end

function BaseView._destroy_ui_elements(arg_8_0)
	if arg_8_0._retained_mode then
		UIUtils.destroy_widgets(arg_8_0._ui_renderer, arg_8_0._widgets_by_name)
	end

	arg_8_0._ui_scenegraph = nil
	arg_8_0._widgets = nil
	arg_8_0._top_widgets = nil
	arg_8_0._widgets_by_name = nil
	arg_8_0._ui_animator = nil
end

function BaseView.post_update(arg_9_0, arg_9_1, arg_9_2)
	return
end

function BaseView.update(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._ui_animator

	if var_10_0 then
		var_10_0:update(arg_10_1, arg_10_2)
	end

	if not arg_10_0._retained_mode or arg_10_0._dirty then
		arg_10_0:_draw(arg_10_1, arg_10_0:input_service())

		arg_10_0._dirty = false
	end
end

function BaseView._draw_widgets(arg_11_0, arg_11_1, arg_11_2)
	return
end

function BaseView._draw(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._ui_renderer
	local var_12_1 = arg_12_0._ui_top_renderer
	local var_12_2 = arg_12_0._ui_scenegraph
	local var_12_3 = arg_12_0._render_settings
	local var_12_4 = var_12_3.alpha_multiplier or 1

	UIRenderer.begin_pass(var_12_0, var_12_2, arg_12_2, arg_12_1, nil, var_12_3)

	for iter_12_0, iter_12_1 in pairs(arg_12_0._widgets) do
		var_12_3.alpha_multiplier = iter_12_1.alpha_multiplier or var_12_4

		UIRenderer.draw_widget(var_12_0, iter_12_1)
	end

	var_12_3.alpha_multiplier = var_12_4

	arg_12_0:_draw_widgets(var_12_0, arg_12_1)
	UIRenderer.end_pass(var_12_0)

	if arg_12_0._top_widgets then
		UIRenderer.begin_pass(var_12_1, var_12_2, arg_12_2, arg_12_1, nil, var_12_3)

		for iter_12_2, iter_12_3 in pairs(arg_12_0._top_widgets) do
			var_12_3.alpha_multiplier = iter_12_3.alpha_multiplier or var_12_4

			UIRenderer.draw_widget(var_12_1, iter_12_3)
		end

		UIRenderer.end_pass(var_12_1)
	end

	var_12_3.alpha_multiplier = var_12_4
end

function BaseView._start_animation(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_4 or {
		wwise_world = arg_13_0._wwise_world,
		render_settings = arg_13_0._render_settings
	}
	local var_13_1 = arg_13_0._definitions.scenegraph_definition

	return arg_13_0._ui_animator:start_animation(arg_13_2, arg_13_3, var_13_1, var_13_0)
end

function BaseView.play_sound(arg_14_0, arg_14_1)
	return WwiseWorld.trigger_event(arg_14_0._wwise_world, arg_14_1)
end

function BaseView.input_service(arg_15_0)
	return arg_15_0._input_manager:get_service(arg_15_0._input_service_name)
end

function BaseView._set_widget_dirty(arg_16_0, arg_16_1)
	arg_16_1.element.dirty = true
end

function BaseView.debug_set_definitions(arg_17_0, arg_17_1)
	arg_17_0._definitions = arg_17_1
end
