-- chunkname: @scripts/ui/hud_ui/base_component.lua

BaseComponent = class(BaseComponent)

BaseComponent.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	assert(arg_1_3, "No definitions passed")
	assert(arg_1_3.scenegraph_definition, "No scenegraph in definitions")

	self._world = arg_1_2.world
	self._ui_renderer = arg_1_2.ui_renderer
	self._ui_top_renderer = arg_1_2.ui_top_renderer
	self._input_manager = arg_1_2.input_manager
	self._ingame_ui_context = arg_1_2
	self._definitions = arg_1_3
	self._retained_mode = not not arg_1_3.retained_mode
	self._dirty = true

	self:_create_ui_elements()
end

BaseComponent._create_ui_elements = function (self)
	-- function 2
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
end

BaseComponent.destroy = function (self)
	-- function 3
	self:_destroy_ui_elements()
end

BaseComponent._destroy_ui_elements = function (self)
	-- function 4
	if not self._retained_mode then
		UIUtils.destroy_widgets(self._ui_renderer, self._widgets_by_name)
	end

	self._widgets_by_name = nil
	self._top_widgets = nil
	self._widgets = nil
	self._ui_scenegraph = nil
end

BaseComponent.set_visible = function (self, arg_5_1)
	-- function 5
	if not self._retained_mode then
		local _ui_renderer = self._ui_renderer

		for i, v in ipairs(self._widgets) do
			UIRenderer.set_element_visible(_ui_renderer, v.element, arg_5_1)
		end

		self._dirty = true
	end
end

BaseComponent.debug_set_definitions = function (self, arg_6_1)
	-- function 6
	self._definitions = arg_6_1
end

BaseComponent.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	return
end

BaseComponent.post_update = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not (self._dirty or self._retained_mode) then
		self:_draw(arg_8_1, self:input_service())

		self._dirty = false
	end
end

BaseComponent._draw_widgets = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

BaseComponent._draw_top_widgets = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

BaseComponent._draw = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, arg_11_2, arg_11_1)
	UIRenderer.draw_all_widgets(_ui_renderer, self._widgets)
	self:_draw_widgets(_ui_renderer, arg_11_1)
	UIRenderer.end_pass(_ui_renderer)
	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, arg_11_2, arg_11_1)

	if not self._top_widgets then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._top_widgets)
	end

	self:_draw_top_widgets(_ui_top_renderer, arg_11_1)
	UIRenderer.end_pass(_ui_top_renderer)
end

BaseComponent.input_service = function (self)
	-- function 12
	return self._input_manager:get_service("Player")
end

BaseComponent._set_widget_dirty = function (arg_13_0, arg_13_1)
	-- function 13
	arg_13_1.element.dirty = true
end
