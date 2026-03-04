-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_gotwf_panel.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_panel_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

HeroWindowGotwfPanel = class(HeroWindowGotwfPanel)
HeroWindowGotwfPanel.NAME = "HeroWindowGotwfPanel"

HeroWindowGotwfPanel.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowGotwfPanel")

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._parent = arg_1_1.parent
	arg_1_0._ui_renderer = var_1_0.ui_top_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
end

HeroWindowGotwfPanel._create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_3)
end

HeroWindowGotwfPanel.on_exit = function (arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowGotwfPanel")

	arg_3_0._ui_animator = nil
end

HeroWindowGotwfPanel.update = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_handle_gamepad_activity()
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_draw(arg_4_1)
end

HeroWindowGotwfPanel.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
end

HeroWindowGotwfPanel._update_animations = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ui_animations
	local var_6_1 = arg_6_0._animations
	local var_6_2 = arg_6_0._ui_animator

	for iter_6_0, iter_6_1 in pairs(arg_6_0._ui_animations) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			arg_6_0._ui_animations[iter_6_0] = nil
		end
	end

	var_6_2:update(arg_6_1)

	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		if var_6_2:is_animation_completed(iter_6_3) then
			var_6_2:stop_animation(iter_6_3)

			var_6_1[iter_6_2] = nil
		end
	end

	arg_6_0:_animate_button(arg_6_0._widgets_by_name.close_button, arg_6_1)
end

HeroWindowGotwfPanel._handle_input = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._parent
	local var_7_1 = arg_7_0._widgets_by_name
	local var_7_2 = arg_7_0._parent:window_input_service()
	local var_7_3 = var_7_1.close_button

	if UIUtils.is_button_pressed(var_7_3) then
		var_7_0:set_layout_by_name("featured")
	end
end

HeroWindowGotwfPanel._draw = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._ui_renderer
	local var_8_1 = arg_8_0._ui_scenegraph
	local var_8_2 = arg_8_0._parent:window_input_service()

	UIRenderer.begin_pass(var_8_0, var_8_1, var_8_2, arg_8_1, nil, arg_8_0._render_settings)

	for iter_8_0, iter_8_1 in ipairs(arg_8_0._widgets) do
		UIRenderer.draw_widget(var_8_0, iter_8_1)
	end

	UIRenderer.end_pass(var_8_0)
end

HeroWindowGotwfPanel._handle_gamepad_activity = function (arg_9_0)
	local var_9_0 = Managers.input:is_device_active("gamepad")
	local var_9_1 = arg_9_0._gamepad_active_last_frame == nil

	if var_9_0 then
		if not arg_9_0._gamepad_active_last_frame or var_9_1 then
			arg_9_0._gamepad_active_last_frame = true
			arg_9_0._widgets_by_name.close_button.content.visible = false
		end
	elseif arg_9_0._gamepad_active_last_frame or var_9_1 then
		arg_9_0._gamepad_active_last_frame = false
		arg_9_0._widgets_by_name.close_button.content.visible = true
	end
end

HeroWindowGotwfPanel._animate_button = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.content
	local var_10_1 = arg_10_1.style
	local var_10_2 = var_10_0.button_hotspot
	local var_10_3 = var_10_2.is_hover
	local var_10_4 = var_10_2.is_selected
	local var_10_5 = not var_10_4 and var_10_2.is_clicked and var_10_2.is_clicked == 0
	local var_10_6 = var_10_2.input_progress or 0
	local var_10_7 = var_10_2.hover_progress or 0
	local var_10_8 = var_10_2.selection_progress or 0
	local var_10_9 = 8
	local var_10_10 = 20

	if var_10_5 then
		var_10_6 = math.min(var_10_6 + arg_10_2 * var_10_10, 1)
	else
		var_10_6 = math.max(var_10_6 - arg_10_2 * var_10_10, 0)
	end

	local var_10_11 = math.easeOutCubic(var_10_6)
	local var_10_12 = math.easeInCubic(var_10_6)

	if var_10_3 then
		var_10_7 = math.min(var_10_7 + arg_10_2 * var_10_9, 1)
	else
		var_10_7 = math.max(var_10_7 - arg_10_2 * var_10_9, 0)
	end

	local var_10_13 = math.easeOutCubic(var_10_7)
	local var_10_14 = math.easeInCubic(var_10_7)

	if var_10_4 then
		var_10_8 = math.min(var_10_8 + arg_10_2 * var_10_9, 1)
	else
		var_10_8 = math.max(var_10_8 - arg_10_2 * var_10_9, 0)
	end

	local var_10_15 = math.easeOutCubic(var_10_8)
	local var_10_16 = math.easeInCubic(var_10_8)
	local var_10_17 = math.max(var_10_7, var_10_8)
	local var_10_18 = math.max(var_10_15, var_10_13)
	local var_10_19 = math.max(var_10_14, var_10_16)
	local var_10_20 = 255 * var_10_17

	var_10_1.texture_id.color[1] = 255 - var_10_20
	var_10_1.texture_hover_id.color[1] = var_10_20
	var_10_1.selected_texture.color[1] = var_10_20
	var_10_2.hover_progress = var_10_7
	var_10_2.input_progress = var_10_6
	var_10_2.selection_progress = var_10_8
end
