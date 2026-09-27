-- chunkname: @scripts/ui/dlc_upsell/common_popup.lua

CommonPopup = class(CommonPopup)

CommonPopup.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._ui_context = arg_1_1
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._input_manager = arg_1_1.input_manager
	self._wwise_world = arg_1_1.wwise_world
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._name = arg_1_2
	self._common_settings = arg_1_3
	self._animations = {}
	self._input_service_name = "common_popup"

	self:setup_input()
	self:create_ui_elements()

	self.popup_id = 0
	self._has_widget_been_closed = false
end

CommonPopup.destroy = function (self)
	-- function 2
	if not self._is_visible then
		self:hide()
	end

	if not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end
end

CommonPopup.create_ui_elements = function (self)
	-- function 3
	local _common_settings = self._common_settings
	local definitions = _common_settings.definitions

	if not definitions then
		definitions = local_require(_common_settings.definitions_path)
		self._common_settings.definitions = definitions
	end

	self._definitions = definitions
	self._ui_scenegraph = UISceneGraph.init_scenegraph(definitions.scenegraph_definition)

	local var_3_2
	local create_widgets, var_3_4 = UIUtils.create_widgets(definitions.widget_definitions)

	self._widgets_by_name, self._widgets = var_3_4, create_widgets

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, definitions.animation_definitions)

	local generic_input_actions = definitions.generic_input_actions

	if not generic_input_actions then
		local var_3_6 = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, self:_get_input_service(), 3, 900, generic_input_actions.default)
		local input_desc = _common_settings.input_desc

		if not input_desc then
			var_3_6:set_input_description(input_desc)
		end

		self._menu_input_description = var_3_6
	end
end

CommonPopup.update = function (self, arg_4_1)
	-- function 4
	if not self._is_visible then
		return
	end

	self:_handle_input(arg_4_1)
	self:_update_animations(arg_4_1)
	self:draw(arg_4_1)
end

CommonPopup._handle_input = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

CommonPopup.draw = function (self, arg_6_1)
	-- function 6
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _get_input_service = self:_get_input_service()
	local _render_settings = self._render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, _get_input_service, arg_6_1, nil, _render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)

	if not self._content_widgets then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._content_widgets)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active and not self._menu_input_description then
		self._menu_input_description:draw(_ui_top_renderer, arg_6_1)
	end
end

CommonPopup.show = function (self)
	-- function 7
	assert(not self._is_visible)

	self._is_visible = true

	self:acquire_input()
end

CommonPopup.hide = function (self)
	-- function 8
	assert(self._is_visible)

	self._is_visible = false

	self:release_input()
end

CommonPopup.exit_done = function (self)
	-- function 9
	return not not self._is_visible or self._has_widget_been_closed
end

CommonPopup._start_transition_animation = function (arg_10_0, arg_10_1)
	-- function 10
	return
end

CommonPopup._update_animations = function (self, arg_11_1)
	-- function 11
	self._ui_animator:update(arg_11_1)
end

CommonPopup.acquire_input = function (self)
	-- function 12
	local _input_manager = self._input_manager

	if not _input_manager then
		ShowCursorStack.show("CommonPopup")
		_input_manager:capture_input(ALL_INPUT_METHODS, 1, self._input_service_name, "CommonPopup")
	end
end

CommonPopup.release_input = function (self)
	-- function 13
	local _input_manager = self._input_manager

	if not _input_manager then
		ShowCursorStack.hide("CommonPopup")
		_input_manager:release_input(ALL_INPUT_METHODS, 1, self._input_service_name, "CommonPopup")
	end
end

CommonPopup.setup_input = function (self)
	-- function 14
	local _input_manager = self._input_manager
	local _input_service_name = self._input_service_name

	if not _input_manager then
		_input_manager:create_input_service(_input_service_name, "IngameMenuKeymaps", "IngameMenuFilters")
		_input_manager:map_device_to_service(_input_service_name, "keyboard")
		_input_manager:map_device_to_service(_input_service_name, "gamepad")
		_input_manager:map_device_to_service(_input_service_name, "mouse")
	end
end

CommonPopup._get_input_service = function (self)
	-- function 15
	return Managers.input:get_service(self._input_service_name)
end

CommonPopup.should_show = function (self)
	-- function 16
	return not self._is_visible
end

CommonPopup.is_popup_showing = function (self)
	-- function 17
	return self._is_visible
end

CommonPopup.play_sound = function (self, arg_18_1)
	-- function 18
	WwiseWorld.trigger_event(self._wwise_world, arg_18_1)
end

CommonPopup.set_fullscreen_effect_enable_state = function (self, arg_19_1)
	-- function 19
	local world = self._ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_19_3 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_19_1 and 1 and 0

		set_scalar(var_19_3, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_19_7 = get_data
		local str_2 = "fullscreen_blur_amount"
		local flag_2

		flag_2 = not arg_19_1 and 0.75 and 0

		set_scalar_2(var_19_7, str_2, flag_2)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_19_1
end
