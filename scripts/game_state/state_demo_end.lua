-- chunkname: @scripts/game_state/state_demo_end.lua

require("scripts/ui/views/demo_end_ui")

StateDemoEnd = class(StateDemoEnd)
StateDemoEnd.NAME = "StateDemoEnd"

StateDemoEnd.on_enter = function (self)
	-- function 1
	self:_setup_world()
	self:_setup_input()
	self:_setup_ui()
	self:_handle_fade()
	self:_handle_video_playback()
end

StateDemoEnd._handle_video_playback = function (arg_2_0)
	-- function 2
	Framerate.set_low_power()
	Managers.music:stop_all_sounds()
end

StateDemoEnd.on_exit = function (self)
	-- function 3
	if not self._demo_end_ui then
		self._demo_end_ui:destroy()

		self._demo_end_ui = nil
	end

	self._input_manager:destroy()

	self._input_manager = nil
	Managers.input = nil

	Managers.state:destroy()
	Framerate.set_playing()
	ScriptWorld.destroy_viewport(self._world, self._viewport_name)
	Managers.world:destroy_world(self._world)
end

StateDemoEnd._setup_world = function (self)
	-- function 4
	self._world_name = "demo_end_world"
	self._viewport_name = "demo_end_world_viewport"
	self._world = Managers.world:create_world(self._world_name, GameSettingsDevelopment.default_environment, nil, nil, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)
	self._viewport = ScriptWorld.create_viewport(self._world, self._viewport_name, "overlay", 1)
end

StateDemoEnd._setup_input = function (self)
	-- function 5
	self._input_manager = InputManager:new()

	local _input_manager = self._input_manager

	Managers.input = _input_manager

	_input_manager:initialize_device("keyboard", 1)
	_input_manager:initialize_device("mouse", 1)
	_input_manager:initialize_device("gamepad")
end

StateDemoEnd._setup_ui = function (self)
	-- function 6
	self._demo_end_ui = DemoEndUI:new(self._world)
end

StateDemoEnd._handle_fade = function (arg_7_0)
	-- function 7
	Managers.transition:hide_loading_icon()
	Managers.transition:fade_out(GameSettings.transition_fade_in_speed)
end

StateDemoEnd.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	self._demo_end_ui:update(arg_8_1, arg_8_2)

	return self:_try_exit()
end

StateDemoEnd.cb_fade_in_done = function (self, arg_9_1)
	-- function 9
	self._new_state = arg_9_1
end

StateDemoEnd._try_exit = function (self)
	-- function 10
	local flag = false

	if BUILD ~= "dev" or not Keyboard.pressed(Keyboard.ENTER) then
		flag = true
	end

	if self._fade_started or self._demo_end_ui:completed() or not flag then
		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(self, "cb_fade_in_done", StateTitleScreen))

		self._fade_started = true
	end

	return self._new_state
end
