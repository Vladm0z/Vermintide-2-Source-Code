-- chunkname: @scripts/network/network_clock_client.lua

local function fn(self)
	-- function 1
	local count = #self
	local var_1_1

	if count % 2 == 0 then
		local num = count / 2
		local num_2 = num + 1

		var_1_1 = (self[num] + self[num_2]) / 2
	else
		var_1_1 = self[math.ceil(count / 2)]
	end

	return var_1_1
end

local function fn_2(self)
	-- function 2
	local count = #self
	local num = 0

	for i = 1, count do
		num = num + self[i]
	end

	return num / count
end

local function fn_3(self, arg_3_1)
	-- function 3
	local count = #self
	local num = 0

	for i = 1, count do
		num = num + (self[i] - arg_3_1)^2
	end

	local num_2 = num / count

	return (math.sqrt(num_2))
end

NetworkClockClient = class(NetworkClockClient)

local tbl = {
	"rpc_network_time_sync_response",
	"rpc_network_current_server_time_response"
}

NetworkClockClient.init = function (self)
	-- function 4
	self._clock = 0
	self._delta_mean = nil
	self._delta_history = {}
	self._request_timer = 0
	self._times_synced = 0
	self._state = "syncing"
end

NetworkClockClient.register_rpcs = function (self, arg_5_1)
	-- function 5
	arg_5_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_5_1
end

NetworkClockClient.unregister_rpcs = function (self)
	-- function 6
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

NetworkClockClient.synchronized = function (self)
	-- function 7
	local flag

	flag = self._state ~= "synced" or not true or false

	return flag
end

NetworkClockClient.time = function (self)
	-- function 8
	return self._clock
end

local num = 3
local num_2 = 6
local num_3 = 2

NetworkClockClient.update = function (self, arg_9_1)
	-- function 9
	if self._state == "syncing" then
		self:_update_clock(arg_9_1)

		local network = Managers.state.network

		if not network:in_game_session() then
			return
		end

		local num_4 = self._request_timer + arg_9_1

		if not (not (num_4 >= num) or not (self._times_synced < num_2)) then
			num_4 = 0
			self._times_synced = self._times_synced + 1

			network.network_transmit:send_rpc_server("rpc_network_clock_sync_request", self._clock)
		end

		self._request_timer = num_4
	elseif self._state == "synced" then
		self:_update_clock(arg_9_1)

		local network_2 = Managers.state.network

		if not network_2:in_game_session() then
			return
		end

		local num_5 = self._request_timer + arg_9_1

		if num_5 >= num_3 then
			num_5 = 0

			network_2.network_transmit:send_rpc_server("rpc_network_current_server_time_request", self._clock)
		end

		self._request_timer = num_5
	else
		printf("[NetworkClockClient] FAIL Unknown state: %q", self._state)
	end

	if not Development.parameter("network_clock_debug") then
		self:_debug_stuff(arg_9_1)
	end
end

NetworkClockClient._update_clock = function (self, arg_10_1)
	-- function 10
	local num = self._clock + arg_10_1

	if num < 0 then
		num = 0

		printf("[NetworkClockClient] delta (%f) larger than current time (%f), clamping resulting time to 0.", arg_10_1, self._clock)
	end

	self._clock = num
end

local function fn_4(arg_11_0, arg_11_1)
	-- function 11
	return arg_11_0 < arg_11_1
end

NetworkClockClient._update_delta_history = function (self, arg_12_1)
	-- function 12
	local _delta_history = self._delta_history

	_delta_history[#_delta_history + 1] = arg_12_1

	table.sort(_delta_history, fn_4)

	self._delta_history = _delta_history
end

NetworkClockClient._calculate_mean_dt = function (self)
	-- function 13
	local _delta_history = self._delta_history
	local var_13_1 = fn(_delta_history)
	local var_13_2 = fn_3(_delta_history, var_13_1)
	local count = #_delta_history
	local num = 1

	while num <= count do
		local var_13_5 = _delta_history[num]

		if not (var_13_5 > var_13_1 + var_13_2 or not (var_13_5 < var_13_1 - var_13_2)) then
			table.remove(_delta_history, num)

			count = count - 1
		else
			num = num + 1
		end
	end

	self._mean_dt = fn_2(_delta_history)
	self._delta_history = _delta_history
end

NetworkClockClient.destroy = function (arg_14_0)
	-- function 14
	return
end

NetworkClockClient._debug_stuff = function (self, arg_15_1)
	-- function 15
	local debug_text = Managers.state.debug_text

	if not debug_text then
		local format = string.format("%.3f", self._clock)

		debug_text:output_screen_text(format, 22, 0.1)
	end

	if not Keyboard.pressed(Keyboard.button_index("p")) then
		print("<[NetworkClockClient] DEBUG INFO>")
		printf("state: %q", self._state)
		printf("mean dt: %q", self._mean_dt)
		table.dump(self._delta_history, "delta_history")
		print("</[NetworkClockClient] DEBUG INFO>")
	end
end

NetworkClockClient.rpc_network_time_sync_response = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local _clock = self._clock
	local num = (_clock - arg_16_2) / 2
	local num_3 = arg_16_3 - _clock + num

	if #self._delta_history == 0 then
		self:_update_clock(num_3)
	end

	self:_update_delta_history(num_3)

	if self._times_synced >= num_2 then
		self:_calculate_mean_dt()
		self:_update_clock(self._mean_dt)

		self._state = "synced"
		self._request_timer = 0
	end
end

NetworkClockClient.rpc_network_current_server_time_response = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local _clock = self._clock
	local num = (_clock - arg_17_2) / 2
	local num_2 = arg_17_3 - _clock + num

	self:_update_clock(num_2)
end
