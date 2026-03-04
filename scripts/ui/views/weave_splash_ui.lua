-- chunkname: @scripts/ui/views/weave_splash_ui.lua

local var_0_0 = local_require("scripts/ui/views/weave_splash_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.create_weave_image_func
local var_0_4 = {
	"weave_loading_screen"
}
local var_0_5 = 5

WeaveSplashUI = class(WeaveSplashUI)

WeaveSplashUI.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._current_splash_index = 1
	arg_1_0._current_timer = #var_0_4 > 1 and var_0_5

	arg_1_0:_setup_ui()
	arg_1_0:_create_ui_elements()
end

WeaveSplashUI._setup_ui = function (arg_2_0)
	arg_2_0._render_settings = {
		alpha_multiplier = 1
	}
	arg_2_0._ui_renderer = UIRenderer.create(arg_2_0._world, "material", "materials/ui/loading_screens/loading_screen_default")
end

WeaveSplashUI._create_ui_elements = function (arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_3_0._animations = {}
	arg_3_0._widgets = {}
	arg_3_0._weave_splash_widgets = {}

	for iter_3_0, iter_3_1 in pairs(var_0_2) do
		arg_3_0._widgets[iter_3_0] = UIWidget.init(iter_3_1)
	end

	local var_3_0 = Managers.mechanism:mechanism_setting("loading_screen_override") or var_0_4[1]
	local var_3_1 = var_0_3(var_3_0, 255)

	arg_3_0._weave_splash_widgets[#arg_3_0._weave_splash_widgets + 1] = UIWidget.init(var_3_1)

	local var_3_2 = 1 + arg_3_0._current_splash_index % #var_0_4
	local var_3_3 = var_0_4[var_3_2]
	local var_3_4 = var_0_3(var_3_3, 0)

	arg_3_0._weave_splash_widgets[#arg_3_0._weave_splash_widgets + 1] = UIWidget.init(var_3_4)

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)
end

WeaveSplashUI.update = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_update_animations(arg_4_1, arg_4_2)
	arg_4_0:_draw(arg_4_1, arg_4_2)
	arg_4_0:_update_current_splash(arg_4_1, arg_4_2)
end

WeaveSplashUI._update_animations = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._animations

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if not UIAnimation.completed(iter_5_1) then
			UIAnimation.update(iter_5_1, arg_5_1)
		else
			var_5_0[iter_5_0] = nil

			if table.is_empty(arg_5_0._animations) then
				arg_5_0._current_timer = var_0_5
			end
		end
	end
end

WeaveSplashUI._update_current_splash = function (arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0._current_timer then
		return
	end

	arg_6_0._current_timer = arg_6_0._current_timer - arg_6_1

	if arg_6_0._current_timer <= 0 then
		local var_6_0 = arg_6_0._current_splash_index

		arg_6_0._current_splash_index = 1 + arg_6_0._current_splash_index % #var_0_4

		local var_6_1 = arg_6_0._weave_splash_widgets[1].content
		local var_6_2 = arg_6_0._weave_splash_widgets[1].style.bg_texture
		local var_6_3 = arg_6_0._weave_splash_widgets[2].content
		local var_6_4 = arg_6_0._weave_splash_widgets[2].style.bg_texture

		var_6_1.bg_texture = var_0_4[var_6_0]
		var_6_3.bg_texture = var_0_4[arg_6_0._current_splash_index]
		arg_6_0._animations.splash_image_1 = UIAnimation.init(UIAnimation.function_by_time, var_6_2.color, 1, 255, 0, 0.5, math.easeInCubic)
		arg_6_0._animations.splash_image_2 = UIAnimation.init(UIAnimation.function_by_time, var_6_4.color, 1, 0, 255, 0.5, math.easeInCubic)
		arg_6_0._current_timer = nil
	end
end

WeaveSplashUI._draw = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._ui_renderer
	local var_7_1 = arg_7_0._ui_scenegraph
	local var_7_2 = arg_7_0._render_settings
	local var_7_3 = FAKE_INPUT_SERVICE

	UIRenderer.begin_pass(var_7_0, var_7_1, var_7_3, arg_7_1, nil, var_7_2)

	for iter_7_0, iter_7_1 in pairs(arg_7_0._widgets) do
		UIRenderer.draw_widget(var_7_0, iter_7_1)
	end

	for iter_7_2, iter_7_3 in ipairs(arg_7_0._weave_splash_widgets) do
		UIRenderer.draw_widget(var_7_0, iter_7_3)
	end

	UIRenderer.end_pass(var_7_0)
end

WeaveSplashUI.destroy = function (arg_8_0)
	UIRenderer.destroy(arg_8_0._ui_renderer, arg_8_0._world)
end

WeaveSplashUI.clear_user_name = function (arg_9_0)
	return
end
