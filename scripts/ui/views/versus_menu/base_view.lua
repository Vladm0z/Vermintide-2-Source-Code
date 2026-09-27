-- chunkname: @scripts/ui/views/versus_menu/base_view.lua

BaseView = class(BaseView)

BaseView.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	fassert(arg_1_2, "No definitions passed")
	fassert(arg_1_2.scenegraph_definition, "No scenegraph in definitions")

	self._ingame_ui_context = arg_1_1
	self._world = arg_1_1.world
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer

	local _render_settings = self._render_settings

	_render_settings = _render_settings or {}
	self._render_settings = _render_settings

	local world = Managers.world:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)
	self._input_manager = arg_1_1.input_manager
	self._input_service_name = "ingame_menu"
	self._definitions = arg_1_2
	self._retained_mode = not not arg_1_2.retained_mode
	self._dirty = true
	self._animations = {}
end

BaseView.destroy = function (arg_2_0)
	-- function 2
	return
end

BaseView.on_enter = function (self)
	-- function 3
	ShowCursorStack.show("BaseView")

	local _input_manager = self._input_manager
	local _input_service_name = self._input_service_name

	_input_manager:block_device_except_service(_input_service_name, "keyboard", 1)
	_input_manager:block_device_except_service(_input_service_name, "mouse", 1)
	_input_manager:block_device_except_service(_input_service_name, "gamepad", 1)
	self:_create_ui_elements()
end

BaseView.post_update_on_enter = function (arg_4_0)
	-- function 4
	return
end

BaseView.on_exit = function (self)
	-- function 5
	ShowCursorStack.hide("BaseView")

	local _input_manager = self._input_manager

	_input_manager:device_unblock_all_services("keyboard", 1)
	_input_manager:device_unblock_all_services("mouse", 1)
	_input_manager:device_unblock_all_services("gamepad", 1)
	self:_destroy_ui_elements()
end

BaseView.post_update_on_exit = function (arg_6_0)
	-- function 6
	return
end

BaseView._create_ui_elements = function (self)
	-- function 7
	local _definitions = self._definitions
	local scenegraph_definition = _definitions.scenegraph_definition

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}

	self._widgets = UIUtils.create_widgets(_definitions.widget_definitions, {}, tbl)

	local top_widget_definitions = _definitions.top_widget_definitions

	if not top_widget_definitions then
		self._top_widgets = UIUtils.create_widgets(top_widget_definitions, {}, tbl)
	end

	self._widgets_by_name = tbl

	if not _definitions.animations then
		self._ui_animator = UIAnimator:new(self._ui_scenegraph, _definitions.animations)
	end
end

BaseView._destroy_ui_elements = function (self)
	-- function 8
	if not self._retained_mode then
		UIUtils.destroy_widgets(self._ui_renderer, self._widgets_by_name)
	end

	self._ui_scenegraph = nil
	self._widgets = nil
	self._top_widgets = nil
	self._widgets_by_name = nil
	self._ui_animator = nil
end

BaseView.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

BaseView.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _ui_animator = self._ui_animator

	if not _ui_animator then
		_ui_animator:update(arg_10_1, arg_10_2)
	end

	if not self._retained_mode and not self._dirty then
		self:_draw(arg_10_1, self:input_service())

		self._dirty = false
	end
end

BaseView._draw_widgets = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	return
end

BaseView._draw = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, arg_12_2, arg_12_1, nil, _render_settings)

	for k, v in pairs(self._widgets) do
		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(_ui_renderer, v)
	end

	_render_settings.alpha_multiplier = alpha_multiplier

	self:_draw_widgets(_ui_renderer, arg_12_1)
	UIRenderer.end_pass(_ui_renderer)

	if not self._top_widgets then
		UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, arg_12_2, arg_12_1, nil, _render_settings)

		for k_2, v_2 in pairs(self._top_widgets) do
			local alpha_multiplier_3 = v_2.alpha_multiplier

			alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_3

			UIRenderer.draw_widget(_ui_top_renderer, v_2)
		end

		UIRenderer.end_pass(_ui_top_renderer)
	end

	_render_settings.alpha_multiplier = alpha_multiplier
end

BaseView._start_animation = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local flag = arg_13_4 or {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local scenegraph_definition = self._definitions.scenegraph_definition

	return self._ui_animator:start_animation(arg_13_2, arg_13_3, scenegraph_definition, flag)
end

BaseView.play_sound = function (self, arg_14_1)
	-- function 14
	return WwiseWorld.trigger_event(self._wwise_world, arg_14_1)
end

BaseView.input_service = function (self)
	-- function 15
	return self._input_manager:get_service(self._input_service_name)
end

BaseView._set_widget_dirty = function (arg_16_0, arg_16_1)
	-- function 16
	arg_16_1.element.dirty = true
end

BaseView.debug_set_definitions = function (self, arg_17_1)
	-- function 17
	self._definitions = arg_17_1
end
