-- chunkname: @scripts/ui/hint_ui/hint_ui.lua

HintUI = class(HintUI)

HintUI.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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
	self._hint_name = arg_1_2
	self._hint_settings = arg_1_3
	self._hint_data = arg_1_3.data
	self._animations = {}

	self:create_ui_elements()

	self._input_service_name = "hint_ui"

	self:setup_input()

	self.hint_id = 0
	self._has_widget_been_closed = false
end

HintUI.destroy = function (self)
	-- function 2
	if not self._is_visible then
		self:hide()
	end
end

HintUI.create_ui_elements = function (self)
	-- function 3
	local data = self._hint_settings.data

	self._ui_scenegraph = UISceneGraph.init_scenegraph(data.definitions.scenegraph_definition)

	local var_3_1
	local create_widgets, var_3_3 = UIUtils.create_widgets(data.definitions.widget_definitions)

	self._widgets_by_name, self._widgets = var_3_3, create_widgets

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, data.definitions.animation_definitions)
end

HintUI.update = function (self, arg_4_1)
	-- function 4
	if not self._is_visible then
		return
	end

	self:_handle_input(arg_4_1)
	self:_update_animations(arg_4_1)
	self:draw(arg_4_1)
end

HintUI._handle_input = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

HintUI.draw = function (self, arg_6_1)
	-- function 6
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _get_input_service = self:_get_input_service()
	local _render_settings = self._render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, _get_input_service, arg_6_1, nil, _render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)
	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active and not self._menu_input_description then
		self._menu_input_description:draw(_ui_top_renderer, arg_6_1)
	end
end

HintUI.show = function (self)
	-- function 7
	assert(not self._is_visible)

	self._is_visible = true
end

HintUI.hide = function (self)
	-- function 8
	assert(self._is_visible)

	self._is_visible = false
end

HintUI.exit_done = function (self)
	-- function 9
	return not not self._is_visible or self._has_widget_been_closed
end

HintUI._start_transition_animation = function (arg_10_0, arg_10_1)
	-- function 10
	return
end

HintUI._update_animations = function (self, arg_11_1)
	-- function 11
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_11_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

HintUI.acquire_input = function (self)
	-- function 12
	local _input_manager = self._input_manager

	if not _input_manager then
		ShowCursorStack.show("HintUI")
		_input_manager:capture_input(ALL_INPUT_METHODS, 1, self._input_service_name, "HintUI")
	end
end

HintUI.release_input = function (self)
	-- function 13
	local _input_manager = self._input_manager

	if not _input_manager then
		ShowCursorStack.hide("HintUI")
		_input_manager:release_input(ALL_INPUT_METHODS, 1, self._input_service_name, "HintUI")
	end
end

HintUI.setup_input = function (self)
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

HintUI._get_input_service = function (self)
	-- function 15
	return Managers.input:get_service(self._input_service_name)
end

HintUI.should_show = function (self)
	-- function 16
	return not self._is_visible
end

HintUI.is_hint_showing = function (self)
	-- function 17
	return self._is_visible
end

HintUI.start_animation = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local flag = arg_18_3 or {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local start_animation = self._ui_animator:start_animation(arg_18_1, arg_18_2, self._hint_data.definitions.scenegraph_definition, flag)
	local var_18_2 = arg_18_1

	self._animations[var_18_2] = start_animation

	return start_animation
end

HintUI.get_hint_name = function (self)
	-- function 19
	return self._hint_name
end
