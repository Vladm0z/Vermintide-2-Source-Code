-- chunkname: @scripts/network/network_clock_client.lua

local function var_0_0(arg_1_0)
	local var_1_0 = #arg_1_0
	local var_1_1

	if var_1_0 % 2 == 0 then
		local var_1_2 = var_1_0 / 2
		local var_1_3 = var_1_2 + 1

		var_1_1 = (arg_1_0[var_1_2] + arg_1_0[var_1_3]) / 2
	else
		var_1_1 = arg_1_0[math.ceil(var_1_0 / 2)]
	end

	return var_1_1
end

local function var_0_1(arg_2_0)
	local var_2_0 = #arg_2_0
	local var_2_1 = 0

	for iter_2_0 = 1, var_2_0 do
		var_2_1 = var_2_1 + arg_2_0[iter_2_0]
	end

	return var_2_1 / var_2_0
end

local function var_0_2(arg_3_0, arg_3_1)
	local var_3_0 = #arg_3_0
	local var_3_1 = 0

	for iter_3_0 = 1, var_3_0 do
		var_3_1 = var_3_1 + (arg_3_0[iter_3_0] - arg_3_1)^2
	end

	local var_3_2 = var_3_1 / var_3_0

	return (math.sqrt(var_3_2))
end

NetworkClockClient = class(NetworkClockClient)

local var_0_3 = {
	"rpc_network_time_sync_response",
	"rpc_network_current_server_time_response"
}

function NetworkClockClient.init(arg_4_0)
	arg_4_0._clock = 0
	arg_4_0._delta_mean = nil
	arg_4_0._delta_history = {}
	arg_4_0._request_timer = 0
	arg_4_0._times_synced = 0
	arg_4_0._state = "syncing"
end

function NetworkClockClient.register_rpcs(arg_5_0, arg_5_1)
	arg_5_1:register(arg_5_0, unpack(var_0_3))

	arg_5_0._network_event_delegate = arg_5_1
end

function NetworkClockClient.unregister_rpcs(arg_6_0)
	arg_6_0._network_event_delegate:unregister(arg_6_0)

	arg_6_0._network_event_delegate = nil
end

function NetworkClockClient.synchronized(arg_7_0)
	return arg_7_0._state == "synced" and true or false
end

function NetworkClockClient.time(arg_8_0)
	return arg_8_0._clock
end

local var_0_4 = 3
local var_0_5 = 6
local var_0_6 = 2

function NetworkClockClient.update(arg_9_0, arg_9_1)
	if arg_9_0._state == "syncing" then
		arg_9_0:_update_clock(arg_9_1)

		local var_9_0 = Managers.state.network

		if not var_9_0:in_game_session() then
			return
		end

		local var_9_1 = arg_9_0._request_timer + arg_9_1

		if var_9_1 >= var_0_4 and arg_9_0._times_synced < var_0_5 then
			var_9_1 = 0
			arg_9_0._times_synced = arg_9_0._times_synced + 1

			var_9_0.network_transmit:send_rpc_server("rpc_network_clock_sync_request", arg_9_0._clock)
		end

		arg_9_0._request_timer = var_9_1
	elseif arg_9_0._state == "synced" then
		arg_9_0:_update_clock(arg_9_1)

		local var_9_2 = Managers.state.network

		if not var_9_2:in_game_session() then
			return
		end

		local var_9_3 = arg_9_0._request_timer + arg_9_1

		if var_9_3 >= var_0_6 then
			var_9_3 = 0

			var_9_2.network_transmit:send_rpc_server("rpc_network_current_server_time_request", arg_9_0._clock)
		end

		arg_9_0._request_timer = var_9_3
	else
		printf("[NetworkClockClient] FAIL Unknown state: %q", arg_9_0._state)
	end

	if Development.parameter("network_clock_debug") then
		arg_9_0:_debug_stuff(arg_9_1)
	end
end

function NetworkClockClient._update_clock(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._clock + arg_10_1

	if var_10_0 < 0 then
		var_10_0 = 0

		printf("[NetworkClockClient] delta (%f) larger than current time (%f), clamping resulting time to 0.", arg_10_1, arg_10_0._clock)
	end

	arg_10_0._clock = var_10_0
end

local function var_0_7(arg_11_0, arg_11_1)
	return arg_11_0 < arg_11_1
end

function NetworkClockClient._update_delta_history(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._delta_history

	var_12_0[#var_12_0 + 1] = arg_12_1

	table.sort(var_12_0, var_0_7)

	arg_12_0._delta_history = var_12_0
end

function NetworkClockClient._calculate_mean_dt(arg_13_0)
	local var_13_0 = arg_13_0._delta_history
	local var_13_1 = var_0_0(var_13_0)
	local var_13_2 = var_0_2(var_13_0, var_13_1)
	local var_13_3 = #var_13_0
	local var_13_4 = 1

	while var_13_4 <= var_13_3 do
		local var_13_5 = var_13_0[var_13_4]

		if var_13_5 > var_13_1 + var_13_2 or var_13_5 < var_13_1 - var_13_2 then
			table.remove(var_13_0, var_13_4)

			var_13_3 = var_13_3 - 1
		else
			var_13_4 = var_13_4 + 1
		end
	end

	arg_13_0._mean_dt = var_0_1(var_13_0)
	arg_13_0._delta_history = var_13_0
end

function NetworkClockClient.destroy(arg_14_0)
	return
end

function NetworkClockClient._debug_stuff(arg_15_0, arg_15_1)
	local var_15_0 = Managers.state.debug_text

	if var_15_0 then
		local var_15_1 = string.format("%.3f", arg_15_0._clock)

		var_15_0:output_screen_text(var_15_1, 22, 0.1)
	end

	if Keyboard.pressed(Keyboard.button_index("p")) then
		print("<[NetworkClockClient] DEBUG INFO>")
		printf("state: %q", arg_15_0._state)
		printf("mean dt: %q", arg_15_0._mean_dt)
		table.dump(arg_15_0._delta_history, "delta_history")
		print("</[NetworkClockClient] DEBUG INFO>")
	end
end

function NetworkClockClient.rpc_network_time_sync_response(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0._clock
	local var_16_1 = (var_16_0 - arg_16_2) / 2
	local var_16_2 = arg_16_3 - var_16_0 + var_16_1

	if #arg_16_0._delta_history == 0 then
		arg_16_0:_update_clock(var_16_2)
	end

	arg_16_0:_update_delta_history(var_16_2)

	if arg_16_0._times_synced >= var_0_5 then
		arg_16_0:_calculate_mean_dt()
		arg_16_0:_update_clock(arg_16_0._mean_dt)

		arg_16_0._state = "synced"
		arg_16_0._request_timer = 0
	end
end

function NetworkClockClient.rpc_network_current_server_time_response(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0._clock
	local var_17_1 = (var_17_0 - arg_17_2) / 2
	local var_17_2 = arg_17_3 - var_17_0 + var_17_1

	arg_17_0:_update_clock(var_17_2)
end
