-- chunkname: @scripts/ui/views/skip_input_ui.lua

local var_0_0 = local_require("scripts/ui/views/skip_input_ui_definitions")

SkipInputUI = class(SkipInputUI)

function SkipInputUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._context = arg_1_2
	arg_1_0._skip = false
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		internal_alpha_multiplier = 0,
		snap_pixel_positions = false
	}

	arg_1_0:_create_ui_elements()
end

function SkipInputUI._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_2_0 = arg_2_0._ui_renderer
	local var_2_1 = arg_2_0._parent:input_service() or FAKE_INPUT_SERVICE
	local var_2_2 = var_0_0.create_skip_widget(arg_2_0, var_2_0, var_2_1)

	arg_2_0._skip_widget = UIWidget.init(var_2_2)
end

function SkipInputUI.destroy(arg_3_0)
	return
end

function SkipInputUI.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0:_update_input(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0:_draw(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
end

function SkipInputUI._update_input(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0._render_settings.internal_alpha_multiplier

	if arg_5_0._active then
		var_5_0 = arg_5_3 and arg_5_3:get("cancel_video") and 1 or math.max(var_5_0 - arg_5_1 * 2, 0)
	end

	if arg_5_3:get("left_release") or arg_5_3:get("confirm") then
		arg_5_0._active = true
	end

	arg_5_0._render_settings.internal_alpha_multiplier = var_5_0
end

function SkipInputUI.skip(arg_6_0)
	arg_6_0._skip = true
end

function SkipInputUI.skipped(arg_7_0)
	local var_7_0 = arg_7_0._skip

	arg_7_0._skip = false

	return var_7_0
end

function SkipInputUI._draw(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0._parent
	local var_8_1 = arg_8_0._ui_renderer
	local var_8_2 = arg_8_0._ui_scenegraph
	local var_8_3 = arg_8_0._render_settings
	local var_8_4 = arg_8_3 or FAKE_INPUT_SERVICE

	var_8_3.alpha_multiplier = (arg_8_4 and arg_8_4.alpha_multiplier or 1) * var_8_3.internal_alpha_multiplier

	UIRenderer.begin_pass(var_8_1, var_8_2, var_8_4, arg_8_1, nil, var_8_3)
	UIRenderer.draw_widget(var_8_1, arg_8_0._skip_widget)
	UIRenderer.end_pass(var_8_1)
end
