-- chunkname: @scripts/ui/views/console_cursor_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local var_0_0 = dofile("scripts/ui/views/console_cursor_view_definitions")
local flag = true

ConsoleCursorView = class(ConsoleCursorView)

ConsoleCursorView.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_loading")
	self._render_settings = {
		snap_pixel_positions = false
	}

	self:_create_ui_elements()

	flag = false
end

ConsoleCursorView._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._widgets = {}

	for k, v in pairs(var_0_0.widgets) do
		self._widgets[k] = UIWidget.init(v)
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

ConsoleCursorView.update = function (self, arg_3_1)
	-- function 3
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	if not Managers.input:is_device_active("gamepad") then
		return
	end

	self:_update_position(arg_3_1)
	self:_draw(arg_3_1)
end

ConsoleCursorView._update_position = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

ConsoleCursorView._draw = function (self, arg_5_1)
	-- function 5
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_5_1, nil, self._render_settings)

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	UIRenderer.end_pass(_ui_renderer)
end
