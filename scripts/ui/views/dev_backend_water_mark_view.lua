-- chunkname: @scripts/ui/views/dev_backend_water_mark_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")

local scripts_ui_views_dev_backend_water_mark_view_definitions = require("scripts/ui/views/dev_backend_water_mark_view_definitions")

DevBackendWatermarkView = class(DevBackendWatermarkView)

DevBackendWatermarkView.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_watermarks")
	self._render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements()
end

DevBackendWatermarkView._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scripts_ui_views_dev_backend_water_mark_view_definitions.scenegraph_definition)
	self._water_mark_widget = UIWidget.init(scripts_ui_views_dev_backend_water_mark_view_definitions.water_mark)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

local flag = false

DevBackendWatermarkView.update = function (self, arg_3_1)
	-- function 3
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	self:_draw(arg_3_1)
end

DevBackendWatermarkView._draw = function (self, arg_4_1)
	-- function 4
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_4_1, nil, self._render_settings)
	UIRenderer.draw_widget(_ui_renderer, self._water_mark_widget)
	UIRenderer.end_pass(_ui_renderer)
end

DevBackendWatermarkView.destroy = function (self)
	-- function 5
	UIRenderer.destroy(self._ui_renderer, self._world)
end
