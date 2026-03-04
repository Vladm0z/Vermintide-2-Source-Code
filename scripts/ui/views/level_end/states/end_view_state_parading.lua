-- chunkname: @scripts/ui/views/level_end/states/end_view_state_parading.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_parading_definitions")

require("scripts/ui/views/world_hero_previewer")

EndViewStateParading = class(EndViewStateParading)
EndViewStateParading.NAME = "EndViewStateParading"
EndViewStateParading.CAN_SPEED_UP = true

local var_0_1 = 6
local var_0_2 = true

EndViewStateParading.on_enter = function (arg_1_0, arg_1_1)
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.context

	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._profile_synchronizer = var_1_0.profile_synchronizer
	arg_1_0._camera_done = false
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}
	arg_1_0._input_service = Managers.input:get_service("end_of_level")

	arg_1_0._parent:show_team()

	local var_1_1 = arg_1_0._parent:get_viewport_world()

	World.get_data(var_1_1, "shading_settings")[1] = "victory_parading"
	arg_1_0._world = var_1_1

	arg_1_0:_create_ui_elements()

	arg_1_0._menu_input_desc = MenuInputDescriptionUI:new(nil, arg_1_0._ui_renderer, arg_1_0._input_service, 3, 900, var_0_0.generic_input_actions.default, false)

	arg_1_0._parent:play_sound("Play_parading_screen_amb")
end

EndViewStateParading._create_ui_elements = function (arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definitions)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_0.widget_definitions) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_0.animation_definitions)
end

EndViewStateParading._start_animation = function (arg_3_0, arg_3_1)
	local var_3_0 = {
		render_settings = arg_3_0._render_settings,
		ui_scenegraph = arg_3_0._ui_scenegraph
	}
	local var_3_1 = arg_3_0._ui_animator:start_animation(arg_3_1, arg_3_0._widgets_by_name, var_0_0.scenegraph_definitions, var_3_0)

	arg_3_0._animations[var_3_1] = {
		name = arg_3_1
	}
end

EndViewStateParading.on_exit = function (arg_4_0)
	arg_4_0._parent:_pop_mouse_cursor()
	arg_4_0._parent:stop_playing_story(arg_4_0._story_id)
end

local function var_0_3(arg_5_0)
	return -(math.cos(math.pi * arg_5_0) - 1) / 2
end

EndViewStateParading.update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1, arg_6_2)
	arg_6_0:_update_camera(arg_6_1, arg_6_2)
	arg_6_0:_draw(arg_6_1, arg_6_2)
end

EndViewStateParading._handle_input = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._widgets_by_name.continue_button

	if UIUtils.is_button_hover_enter(var_7_0) then
		arg_7_0._parent:play_sound("Play_hud_hover")
	end

	if arg_7_0._camera_done and (UIUtils.is_button_pressed(var_7_0) or arg_7_0._parent:skip_pressed()) then
		arg_7_0._parent:play_sound("Play_gui_parading_screen_continue_button")

		arg_7_0._done = true
	end
end

EndViewStateParading._update_animations = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._ui_animator

	var_8_0:update(arg_8_1, arg_8_2)

	local var_8_1 = arg_8_0._animations

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		if var_8_0:is_animation_completed(iter_8_1) then
			var_8_0:stop_animation(iter_8_1)

			var_8_1[iter_8_0] = nil
		end
	end

	UIWidgetUtils.animate_default_button(arg_8_0._widgets_by_name.continue_button, arg_8_1)
end

EndViewStateParading._update_camera = function (arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0._camera_done or not arg_9_0._parent:loading_complete(arg_9_1, arg_9_2) then
		return
	end

	if var_0_2 then
		arg_9_0:_update_story_camera(arg_9_1, arg_9_2)
	else
		arg_9_0:_update_math_camera(arg_9_1, arg_9_2)
	end
end

EndViewStateParading._update_story_camera = function (arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._story_id then
		local var_10_0 = false
		local var_10_1 = 1
		local var_10_2 = false

		arg_10_0._story_id = arg_10_0._parent:start_story_camera("camera_pan", var_10_0, var_10_1, var_10_2)
	elseif not arg_10_0._parent:is_playing_story(arg_10_0._story_id) then
		arg_10_0._camera_done = true

		arg_10_0._parent:_push_mouse_cursor()
		arg_10_0:_start_animation("animate_continue_button")
	end
end

EndViewStateParading._update_math_camera = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._timer = arg_11_0._timer or Managers.time:time("main") + var_0_1
	arg_11_0._time = arg_11_0._time or Managers.time:time("main")

	local var_11_0 = arg_11_0._time
	local var_11_1 = 0
	local var_11_2 = 3
	local var_11_3 = arg_11_0._timer - var_11_0 - var_11_1
	local var_11_4 = math.clamp(1 - (arg_11_0._timer - var_11_0) / (var_0_1 - var_11_1), 0, 1)
	local var_11_5 = var_0_3(var_11_4)
	local var_11_6, var_11_7 = arg_11_0._parent:get_viewport_world()
	local var_11_8 = ScriptViewport.camera(var_11_7)
	local var_11_9 = arg_11_0._parent:get_camera_pose()
	local var_11_10 = Matrix4x4.rotation(var_11_9)
	local var_11_11 = Matrix4x4.translation(var_11_9)
	local var_11_12 = Quaternion.forward(var_11_10)
	local var_11_13 = var_11_11 + var_11_12 * var_11_2
	local var_11_14 = var_11_13 + Vector3(2.5, -4, -2.5)
	local var_11_15 = math.sin(math.min(var_11_5 * math.pi, math.pi)) * var_11_12 * -3 * 1
	local var_11_16 = Vector3.lerp(var_11_14, var_11_13, math.min(var_11_5, 1)) + var_11_15
	local var_11_17 = Quaternion.look(Vector3.normalize(Vector3.flat(var_11_13 - (var_11_16 - var_11_12 * 4))), Vector3.up())
	local var_11_18 = Matrix4x4.from_quaternion_position(var_11_17, var_11_16)

	ScriptCamera.set_local_pose(var_11_8, var_11_18)
	ScriptCamera.force_update(var_11_6, var_11_8)

	arg_11_0._time = arg_11_0._time + Managers.time:mean_dt()

	if var_11_0 > arg_11_0._timer then
		arg_11_0._camera_done = true

		arg_11_0._parent:_push_mouse_cursor()
		arg_11_0:_start_animation("animate_continue_button")
	end
end

EndViewStateParading._draw = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._ui_renderer
	local var_12_1 = arg_12_0._ui_scenegraph
	local var_12_2 = arg_12_0._render_settings
	local var_12_3 = arg_12_0._input_service
	local var_12_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_3, arg_12_1, nil, var_12_2)

	for iter_12_0, iter_12_1 in ipairs(arg_12_0._widgets) do
		UIRenderer.draw_widget(var_12_0, iter_12_1)
	end

	UIRenderer.end_pass(var_12_0)

	if var_12_4 and arg_12_0._camera_done then
		arg_12_0._menu_input_desc:draw(var_12_0, arg_12_1)
	end
end

EndViewStateParading.done = function (arg_13_0)
	return arg_13_0._done
end

EndViewStateParading.exit = function (arg_14_0)
	return
end

EndViewStateParading.exit_done = function (arg_15_0)
	return true
end
