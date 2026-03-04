-- chunkname: @scripts/ui/dlc_upsell/common_popup.lua

CommonPopup = class(CommonPopup)

function CommonPopup.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._ui_context = arg_1_1
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._name = arg_1_2
	arg_1_0._common_settings = arg_1_3
	arg_1_0._animations = {}
	arg_1_0._input_service_name = "common_popup"

	arg_1_0:setup_input()
	arg_1_0:create_ui_elements()

	arg_1_0.popup_id = 0
	arg_1_0._has_widget_been_closed = false
end

function CommonPopup.destroy(arg_2_0)
	if arg_2_0._is_visible then
		arg_2_0:hide()
	end

	if arg_2_0._fullscreen_effect_enabled then
		arg_2_0:set_fullscreen_effect_enable_state(false)
	end
end

function CommonPopup.create_ui_elements(arg_3_0)
	local var_3_0 = arg_3_0._common_settings
	local var_3_1 = var_3_0.definitions

	if not var_3_1 then
		var_3_1 = local_require(var_3_0.definitions_path)
		arg_3_0._common_settings.definitions = var_3_1
	end

	arg_3_0._definitions = var_3_1
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_3_1.scenegraph_definition)

	local var_3_2
	local var_3_3, var_3_4 = UIUtils.create_widgets(var_3_1.widget_definitions)

	arg_3_0._widgets_by_name, arg_3_0._widgets = var_3_4, var_3_3

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_top_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_3_1.animation_definitions)

	local var_3_5 = var_3_1.generic_input_actions

	if var_3_5 then
		local var_3_6 = MenuInputDescriptionUI:new(nil, arg_3_0._ui_top_renderer, arg_3_0:_get_input_service(), 3, 900, var_3_5.default)
		local var_3_7 = var_3_0.input_desc

		if var_3_7 then
			var_3_6:set_input_description(var_3_7)
		end

		arg_3_0._menu_input_description = var_3_6
	end
end

function CommonPopup.update(arg_4_0, arg_4_1)
	if not arg_4_0._is_visible then
		return
	end

	arg_4_0:_handle_input(arg_4_1)
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:draw(arg_4_1)
end

function CommonPopup._handle_input(arg_5_0, arg_5_1)
	return
end

function CommonPopup.draw(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ui_top_renderer
	local var_6_1 = arg_6_0._ui_scenegraph
	local var_6_2 = arg_6_0:_get_input_service()
	local var_6_3 = arg_6_0._render_settings
	local var_6_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_2, arg_6_1, nil, var_6_3)
	UIRenderer.draw_all_widgets(var_6_0, arg_6_0._widgets)

	if arg_6_0._content_widgets then
		UIRenderer.draw_all_widgets(var_6_0, arg_6_0._content_widgets)
	end

	UIRenderer.end_pass(var_6_0)

	if var_6_4 and arg_6_0._menu_input_description then
		arg_6_0._menu_input_description:draw(var_6_0, arg_6_1)
	end
end

function CommonPopup.show(arg_7_0)
	assert(not arg_7_0._is_visible)

	arg_7_0._is_visible = true

	arg_7_0:acquire_input()
end

function CommonPopup.hide(arg_8_0)
	assert(arg_8_0._is_visible)

	arg_8_0._is_visible = false

	arg_8_0:release_input()
end

function CommonPopup.exit_done(arg_9_0)
	return not arg_9_0._is_visible and arg_9_0._has_widget_been_closed
end

function CommonPopup._start_transition_animation(arg_10_0, arg_10_1)
	return
end

function CommonPopup._update_animations(arg_11_0, arg_11_1)
	arg_11_0._ui_animator:update(arg_11_1)
end

function CommonPopup.acquire_input(arg_12_0)
	local var_12_0 = arg_12_0._input_manager

	if var_12_0 then
		ShowCursorStack.show("CommonPopup")
		var_12_0:capture_input(ALL_INPUT_METHODS, 1, arg_12_0._input_service_name, "CommonPopup")
	end
end

function CommonPopup.release_input(arg_13_0)
	local var_13_0 = arg_13_0._input_manager

	if var_13_0 then
		ShowCursorStack.hide("CommonPopup")
		var_13_0:release_input(ALL_INPUT_METHODS, 1, arg_13_0._input_service_name, "CommonPopup")
	end
end

function CommonPopup.setup_input(arg_14_0)
	local var_14_0 = arg_14_0._input_manager
	local var_14_1 = arg_14_0._input_service_name

	if var_14_0 then
		var_14_0:create_input_service(var_14_1, "IngameMenuKeymaps", "IngameMenuFilters")
		var_14_0:map_device_to_service(var_14_1, "keyboard")
		var_14_0:map_device_to_service(var_14_1, "gamepad")
		var_14_0:map_device_to_service(var_14_1, "mouse")
	end
end

function CommonPopup._get_input_service(arg_15_0)
	return Managers.input:get_service(arg_15_0._input_service_name)
end

function CommonPopup.should_show(arg_16_0)
	return not arg_16_0._is_visible
end

function CommonPopup.is_popup_showing(arg_17_0)
	return arg_17_0._is_visible
end

function CommonPopup.play_sound(arg_18_0, arg_18_1)
	WwiseWorld.trigger_event(arg_18_0._wwise_world, arg_18_1)
end

function CommonPopup.set_fullscreen_effect_enable_state(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._ui_renderer.world
	local var_19_1 = World.get_data(var_19_0, "shading_environment")

	if var_19_1 then
		ShadingEnvironment.set_scalar(var_19_1, "fullscreen_blur_enabled", arg_19_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_19_1, "fullscreen_blur_amount", arg_19_1 and 0.75 or 0)
		ShadingEnvironment.apply(var_19_1)
	end

	arg_19_0._fullscreen_effect_enabled = arg_19_1
end
