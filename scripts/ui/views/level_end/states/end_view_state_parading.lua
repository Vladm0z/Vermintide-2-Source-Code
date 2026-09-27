-- chunkname: @scripts/ui/views/level_end/states/end_view_state_parading.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_parading_definitions")

require("scripts/ui/views/world_hero_previewer")

EndViewStateParading = class(EndViewStateParading)
EndViewStateParading.NAME = "EndViewStateParading"
EndViewStateParading.CAN_SPEED_UP = true

local num = 6
local flag = true

EndViewStateParading.on_enter = function (self, arg_1_1)
	-- function 1
	self._parent = arg_1_1.parent

	local context = arg_1_1.context

	self._statistics_db = context.statistics_db
	self._profile_synchronizer = context.profile_synchronizer
	self._camera_done = false
	self._ui_renderer = context.ui_renderer
	self._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._animations = {}
	self._input_service = Managers.input:get_service("end_of_level")

	self._parent:show_team()

	local get_viewport_world = self._parent:get_viewport_world()

	World.get_data(get_viewport_world, "shading_settings")[1] = "victory_parading"
	self._world = get_viewport_world

	self:_create_ui_elements()

	self._menu_input_desc = MenuInputDescriptionUI:new(nil, self._ui_renderer, self._input_service, 3, 900, var_0_0.generic_input_actions.default, false)

	self._parent:play_sound("Play_parading_screen_amb")
end

EndViewStateParading._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definitions)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(var_0_0.widget_definitions) do
		local var_2_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_2
		tbl_2[k] = var_2_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.animation_definitions)
end

EndViewStateParading._start_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		render_settings = self._render_settings,
		ui_scenegraph = self._ui_scenegraph
	}
	local start_animation = self._ui_animator:start_animation(arg_3_1, self._widgets_by_name, var_0_0.scenegraph_definitions, tbl)

	self._animations[start_animation] = {
		name = arg_3_1
	}
end

EndViewStateParading.on_exit = function (self)
	-- function 4
	self._parent:_pop_mouse_cursor()
	self._parent:stop_playing_story(self._story_id)
end

local function fn(arg_5_0)
	-- function 5
	return -(math.cos(math.pi * arg_5_0) - 1) / 2
end

EndViewStateParading.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_handle_input(arg_6_1, arg_6_2)
	self:_update_animations(arg_6_1, arg_6_2)
	self:_update_camera(arg_6_1, arg_6_2)
	self:_draw(arg_6_1, arg_6_2)
end

EndViewStateParading._handle_input = function (self, arg_7_1, arg_7_2)
	-- function 7
	local continue_button = self._widgets_by_name.continue_button

	if not UIUtils.is_button_hover_enter(continue_button) then
		self._parent:play_sound("Play_hud_hover")
	end

	if not self._camera_done and UIUtils.is_button_pressed(continue_button) and not self._parent:skip_pressed() then
		self._parent:play_sound("Play_gui_parading_screen_continue_button")

		self._done = true
	end
end

EndViewStateParading._update_animations = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_8_1, arg_8_2)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	UIWidgetUtils.animate_default_button(self._widgets_by_name.continue_button, arg_8_1)
end

EndViewStateParading._update_camera = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not (self._camera_done or self._parent:loading_complete(arg_9_1, arg_9_2)) then
		return
	end

	if not flag then
		self:_update_story_camera(arg_9_1, arg_9_2)
	else
		self:_update_math_camera(arg_9_1, arg_9_2)
	end
end

EndViewStateParading._update_story_camera = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._story_id then
		local flag = false
		local num = 1
		local flag_2 = false

		self._story_id = self._parent:start_story_camera("camera_pan", flag, num, flag_2)
	elseif not self._parent:is_playing_story(self._story_id) then
		self._camera_done = true

		self._parent:_push_mouse_cursor()
		self:_start_animation("animate_continue_button")
	end
end

EndViewStateParading._update_math_camera = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _timer = self._timer

	_timer = _timer or Managers.time:time("main") + num
	self._timer = _timer

	local _time = self._time

	_time = _time or Managers.time:time("main")
	self._time = _time

	local _time_2 = self._time
	local num_2 = 0
	local num_3 = 3
	local num_4 = self._timer - _time_2 - num_2
	local clamp = math.clamp(1 - (self._timer - _time_2) / (num - num_2), 0, 1)
	local var_11_7 = fn(clamp)
	local get_viewport_world, var_11_9 = self._parent:get_viewport_world()
	local camera = ScriptViewport.camera(var_11_9)
	local get_camera_pose = self._parent:get_camera_pose()
	local rotation = Matrix4x4.rotation(get_camera_pose)
	local translation = Matrix4x4.translation(get_camera_pose)
	local forward = Quaternion.forward(rotation)
	local num_5 = translation + forward * num_3
	local num_6 = num_5 + Vector3(2.5, -4, -2.5)
	local num_7 = math.sin(math.min(var_11_7 * math.pi, math.pi)) * forward * -3 * 1
	local num_8 = Vector3.lerp(num_6, num_5, math.min(var_11_7, 1)) + num_7
	local look = Quaternion.look(Vector3.normalize(Vector3.flat(num_5 - (num_8 - forward * 4))), Vector3.up())
	local from_quaternion_position = Matrix4x4.from_quaternion_position(look, num_8)

	ScriptCamera.set_local_pose(camera, from_quaternion_position)
	ScriptCamera.force_update(get_viewport_world, camera)

	self._time = self._time + Managers.time:mean_dt()

	if _time_2 > self._timer then
		self._camera_done = true

		self._parent:_push_mouse_cursor()
		self:_start_animation("animate_continue_button")
	end
end

EndViewStateParading._draw = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local _input_service = self._input_service
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, _input_service, arg_12_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	UIRenderer.end_pass(_ui_renderer)

	if not is_device_active and not self._camera_done then
		self._menu_input_desc:draw(_ui_renderer, arg_12_1)
	end
end

EndViewStateParading.done = function (self)
	-- function 13
	return self._done
end

EndViewStateParading.exit = function (arg_14_0)
	-- function 14
	return
end

EndViewStateParading.exit_done = function (arg_15_0)
	-- function 15
	return true
end
