-- chunkname: @scripts/network/network_timer_handler.lua

NetworkTimerHandler = class(NetworkTimerHandler)

NetworkTimerHandler.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._timer_state = "inactive"
	arg_1_0._world = arg_1_1
	arg_1_0._network_clock = arg_1_2
	arg_1_0.is_server = arg_1_3
	arg_1_0._gui = World.create_screen_gui(arg_1_1, "material", "materials/fonts/gw_fonts", "immediate")
end

local var_0_0 = {
	"rpc_start_network_timer"
}

NetworkTimerHandler.register_rpcs = function (arg_2_0, arg_2_1)
	arg_2_1:register(arg_2_0, unpack(var_0_0))

	arg_2_0._network_event_delegate = arg_2_1
end

NetworkTimerHandler.unregister_rpcs = function (arg_3_0)
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil
end

NetworkTimerHandler.start_timer_server = function (arg_4_0, arg_4_1)
	assert(arg_4_0.is_server == true, "Tried starting timer as server; not server")

	local var_4_0 = arg_4_0._network_clock:time() + arg_4_1

	arg_4_0:start_timer_client(var_4_0)
	Managers.state.network.network_transmit:send_rpc_clients("rpc_start_network_timer", var_4_0)
end

NetworkTimerHandler.start_timer_client = function (arg_5_0, arg_5_1)
	arg_5_0._timer_state = "active"
	arg_5_0._end_time = arg_5_1
end

NetworkTimerHandler.update = function (arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._timer_state == "inactive" then
		return
	end

	arg_6_0:_render_timer()

	if arg_6_0._network_clock:time() >= arg_6_0._end_time then
		arg_6_0._timer_state = "inactive"
		arg_6_0._end_time = nil

		local var_6_0 = LevelHelper:current_level(arg_6_0._world)

		Level.trigger_event(var_6_0, "network_timer_done")
	end
end

NetworkTimerHandler._render_timer = function (arg_7_0)
	if not script_data.debug_enabled then
		return
	end

	local var_7_0 = arg_7_0._network_clock:time()
	local var_7_1 = arg_7_0._end_time
	local var_7_2 = tostring(math.max(0, math.ceil(var_7_1 - var_7_0)))
	local var_7_3, var_7_4 = Gui.resolution()
	local var_7_5 = Vector3(0, 0, 100)
	local var_7_6 = Vector2(120, 50)

	Gui.rect(arg_7_0._gui, var_7_5, var_7_6, Color(150, 102, 255, 102))

	local var_7_7 = Vector3(20, 15, 110)
	local var_7_8 = "arial"
	local var_7_9 = "materials/fonts/" .. var_7_8
	local var_7_10 = 30

	Gui.text(arg_7_0._gui, var_7_2, var_7_9, var_7_10, var_7_8, var_7_7, Color(255, 0, 0, 0))
end

NetworkTimerHandler.destroy = function (arg_8_0)
	World.destroy_gui(arg_8_0._world, arg_8_0._gui)

	arg_8_0._gui = nil
	arg_8_0._world = nil
	arg_8_0._network_clock = nil
end

NetworkTimerHandler.rpc_start_network_timer = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:start_timer_client(arg_9_2)
end
