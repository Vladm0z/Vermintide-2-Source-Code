-- chunkname: @scripts/ui/hud_ui/emote_photomode_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/emote_photomode_ui_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.widgets_pc
local var_0_3 = var_0_0.widgets_gamepad
local var_0_4 = var_0_0.scenegraph_definition

EmotePhotomodeUI = class(EmotePhotomodeUI)

local var_0_5 = false

EmotePhotomodeUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._render_settings = {}

	arg_1_0:_create_ui_elements()

	arg_1_0._is_enabled = false
end

EmotePhotomodeUI.destroy = function (arg_2_0)
	return
end

EmotePhotomodeUI._create_ui_elements = function (arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_4)
	arg_3_0._render_settings = arg_3_0._render_settings or {}
	arg_3_0._widgets = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_0 = UIWidget.init(iter_3_1)

		arg_3_0._widgets[iter_3_0] = var_3_0
	end

	arg_3_0._widgets_pc = {}

	for iter_3_2, iter_3_3 in pairs(var_0_2) do
		local var_3_1 = UIWidget.init(iter_3_3)

		arg_3_0._widgets_pc[iter_3_2] = var_3_1
	end

	arg_3_0._widgets_gamepad = {}

	for iter_3_4, iter_3_5 in pairs(var_0_3) do
		local var_3_2 = UIWidget.init(iter_3_5)

		arg_3_0._widgets_gamepad[iter_3_4] = var_3_2
	end

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)
end

EmotePhotomodeUI.update = function (arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_0._is_enabled then
		return
	end

	arg_4_0:_draw(arg_4_1, arg_4_2)
end

EmotePhotomodeUI.set_enabled = function (arg_5_0, arg_5_1)
	arg_5_0._is_enabled = arg_5_1
end

EmotePhotomodeUI._draw = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._ui_renderer
	local var_6_1 = arg_6_0._ui_scenegraph
	local var_6_2 = arg_6_0._render_settings
	local var_6_3 = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_3, arg_6_1, nil, var_6_2)

	for iter_6_0, iter_6_1 in pairs(arg_6_0._widgets) do
		UIRenderer.draw_widget(var_6_0, iter_6_1)
	end

	if Managers.input:is_device_active("gamepad") then
		for iter_6_2, iter_6_3 in pairs(arg_6_0._widgets_gamepad) do
			UIRenderer.draw_widget(var_6_0, iter_6_3)
		end
	else
		for iter_6_4, iter_6_5 in pairs(arg_6_0._widgets_pc) do
			UIRenderer.draw_widget(var_6_0, iter_6_5)
		end
	end

	UIRenderer.end_pass(var_6_0)
end
