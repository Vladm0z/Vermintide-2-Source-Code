-- chunkname: @scripts/network/network_timer_handler.lua

NetworkTimerHandler = class(NetworkTimerHandler)

NetworkTimerHandler.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._timer_state = "inactive"
	self._world = arg_1_1
	self._network_clock = arg_1_2
	self.is_server = arg_1_3
	self._gui = World.create_screen_gui(arg_1_1, "material", "materials/fonts/gw_fonts", "immediate")
end

local tbl = {
	"rpc_start_network_timer"
}

NetworkTimerHandler.register_rpcs = function (self, arg_2_1)
	-- function 2
	arg_2_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_2_1
end

NetworkTimerHandler.unregister_rpcs = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

NetworkTimerHandler.start_timer_server = function (self, arg_4_1)
	-- function 4
	assert(self.is_server == true, "Tried starting timer as server; not server")

	local num = self._network_clock:time() + arg_4_1

	self:start_timer_client(num)
	Managers.state.network.network_transmit:send_rpc_clients("rpc_start_network_timer", num)
end

NetworkTimerHandler.start_timer_client = function (self, arg_5_1)
	-- function 5
	self._timer_state = "active"
	self._end_time = arg_5_1
end

NetworkTimerHandler.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if self._timer_state == "inactive" then
		return
	end

	self:_render_timer()

	if self._network_clock:time() >= self._end_time then
		self._timer_state = "inactive"
		self._end_time = nil

		local current_level = LevelHelper:current_level(self._world)

		Level.trigger_event(current_level, "network_timer_done")
	end
end

NetworkTimerHandler._render_timer = function (self)
	-- function 7
	if not script_data.debug_enabled then
		return
	end

	local time = self._network_clock:time()
	local _end_time = self._end_time
	local var_7_2 = tostring(math.max(0, math.ceil(_end_time - time)))
	local resolution, var_7_4 = Gui.resolution()
	local var_7_5 = Vector3(0, 0, 100)
	local var_7_6 = Vector2(120, 50)

	Gui.rect(self._gui, var_7_5, var_7_6, Color(150, 102, 255, 102))

	local var_7_7 = Vector3(20, 15, 110)
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local num = 30

	Gui.text(self._gui, var_7_2, str_2, num, str, var_7_7, Color(255, 0, 0, 0))
end

NetworkTimerHandler.destroy = function (self)
	-- function 8
	World.destroy_gui(self._world, self._gui)

	self._gui = nil
	self._world = nil
	self._network_clock = nil
end

NetworkTimerHandler.rpc_start_network_timer = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:start_timer_client(arg_9_2)
end
