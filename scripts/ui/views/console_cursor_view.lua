-- chunkname: @scripts/ui/views/console_cursor_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local var_0_0 = dofile("scripts/ui/views/console_cursor_view_definitions")
local var_0_1 = true

ConsoleCursorView = class(ConsoleCursorView)

function ConsoleCursorView.init(arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_loading")
	arg_1_0._render_settings = {
		snap_pixel_positions = false
	}

	arg_1_0:_create_ui_elements()

	var_0_1 = false
end

function ConsoleCursorView._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0._widgets = {}

	for iter_2_0, iter_2_1 in pairs(var_0_0.widgets) do
		arg_2_0._widgets[iter_2_0] = UIWidget.init(iter_2_1)
	end

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
end

function ConsoleCursorView.update(arg_3_0, arg_3_1)
	if var_0_1 then
		var_0_1 = false

		arg_3_0:_create_ui_elements()
	end

	if not Managers.input:is_device_active("gamepad") then
		return
	end

	arg_3_0:_update_position(arg_3_1)
	arg_3_0:_draw(arg_3_1)
end

function ConsoleCursorView._update_position(arg_4_0, arg_4_1)
	return
end

function ConsoleCursorView._draw(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._ui_renderer
	local var_5_1 = arg_5_0._ui_scenegraph

	UIRenderer.begin_pass(var_5_0, var_5_1, FAKE_INPUT_SERVICE, arg_5_1, nil, arg_5_0._render_settings)

	for iter_5_0, iter_5_1 in pairs(arg_5_0._widgets) do
		UIRenderer.draw_widget(var_5_0, iter_5_1)
	end

	UIRenderer.end_pass(var_5_0)
end
