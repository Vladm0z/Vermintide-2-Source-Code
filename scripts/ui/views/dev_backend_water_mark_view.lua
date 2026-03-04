-- chunkname: @scripts/ui/views/dev_backend_water_mark_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")

local var_0_0 = require("scripts/ui/views/dev_backend_water_mark_view_definitions")

DevBackendWatermarkView = class(DevBackendWatermarkView)

DevBackendWatermarkView.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_watermarks")
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements()
end

DevBackendWatermarkView._create_ui_elements = function (arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0._water_mark_widget = UIWidget.init(var_0_0.water_mark)

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
end

local var_0_1 = false

DevBackendWatermarkView.update = function (arg_3_0, arg_3_1)
	if var_0_1 then
		var_0_1 = false

		arg_3_0:_create_ui_elements()
	end

	arg_3_0:_draw(arg_3_1)
end

DevBackendWatermarkView._draw = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._ui_renderer
	local var_4_1 = arg_4_0._ui_scenegraph

	UIRenderer.begin_pass(var_4_0, var_4_1, FAKE_INPUT_SERVICE, arg_4_1, nil, arg_4_0._render_settings)
	UIRenderer.draw_widget(var_4_0, arg_4_0._water_mark_widget)
	UIRenderer.end_pass(var_4_0)
end

DevBackendWatermarkView.destroy = function (arg_5_0)
	UIRenderer.destroy(arg_5_0._ui_renderer, arg_5_0._world)
end
