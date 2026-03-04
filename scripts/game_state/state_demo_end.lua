-- chunkname: @scripts/game_state/state_demo_end.lua

require("scripts/ui/views/demo_end_ui")

StateDemoEnd = class(StateDemoEnd)
StateDemoEnd.NAME = "StateDemoEnd"

StateDemoEnd.on_enter = function (arg_1_0)
	arg_1_0:_setup_world()
	arg_1_0:_setup_input()
	arg_1_0:_setup_ui()
	arg_1_0:_handle_fade()
	arg_1_0:_handle_video_playback()
end

StateDemoEnd._handle_video_playback = function (arg_2_0)
	Framerate.set_low_power()
	Managers.music:stop_all_sounds()
end

StateDemoEnd.on_exit = function (arg_3_0)
	if arg_3_0._demo_end_ui then
		arg_3_0._demo_end_ui:destroy()

		arg_3_0._demo_end_ui = nil
	end

	arg_3_0._input_manager:destroy()

	arg_3_0._input_manager = nil
	Managers.input = nil

	Managers.state:destroy()
	Framerate.set_playing()
	ScriptWorld.destroy_viewport(arg_3_0._world, arg_3_0._viewport_name)
	Managers.world:destroy_world(arg_3_0._world)
end

StateDemoEnd._setup_world = function (arg_4_0)
	arg_4_0._world_name = "demo_end_world"
	arg_4_0._viewport_name = "demo_end_world_viewport"
	arg_4_0._world = Managers.world:create_world(arg_4_0._world_name, GameSettingsDevelopment.default_environment, nil, nil, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)
	arg_4_0._viewport = ScriptWorld.create_viewport(arg_4_0._world, arg_4_0._viewport_name, "overlay", 1)
end

StateDemoEnd._setup_input = function (arg_5_0)
	arg_5_0._input_manager = InputManager:new()

	local var_5_0 = arg_5_0._input_manager

	Managers.input = var_5_0

	var_5_0:initialize_device("keyboard", 1)
	var_5_0:initialize_device("mouse", 1)
	var_5_0:initialize_device("gamepad")
end

StateDemoEnd._setup_ui = function (arg_6_0)
	arg_6_0._demo_end_ui = DemoEndUI:new(arg_6_0._world)
end

StateDemoEnd._handle_fade = function (arg_7_0)
	Managers.transition:hide_loading_icon()
	Managers.transition:fade_out(GameSettings.transition_fade_in_speed)
end

StateDemoEnd.update = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0._demo_end_ui:update(arg_8_1, arg_8_2)

	return arg_8_0:_try_exit()
end

StateDemoEnd.cb_fade_in_done = function (arg_9_0, arg_9_1)
	arg_9_0._new_state = arg_9_1
end

StateDemoEnd._try_exit = function (arg_10_0)
	local var_10_0 = false

	if BUILD == "dev" and Keyboard.pressed(Keyboard.ENTER) then
		var_10_0 = true
	end

	if not arg_10_0._fade_started and (arg_10_0._demo_end_ui:completed() or var_10_0) then
		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(arg_10_0, "cb_fade_in_done", StateTitleScreen))

		arg_10_0._fade_started = true
	end

	return arg_10_0._new_state
end
