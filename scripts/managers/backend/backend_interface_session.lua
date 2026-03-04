-- chunkname: @scripts/managers/backend/backend_interface_session.lua

local var_0_0 = {
	END_OF_ROUND = 3,
	ERROR = 4,
	IN_GAME = 2,
	INITIALIZED = 1,
	UNINITIALIZED = 0
}

for iter_0_0, iter_0_1 in pairs(var_0_0) do
	var_0_0[iter_0_1] = iter_0_0
end

local var_0_1 = class(Session)

var_0_1.init = function (arg_1_0)
	arg_1_0._peers = {}
	arg_1_0._peer_queue = {}
	arg_1_0._debug_backend_session_done_timeout = false
	arg_1_0._debug_backend_session_stop_timeout = false
end

var_0_1.disable = function (arg_2_0)
	arg_2_0._disabled = true
end

var_0_1.enabled = function (arg_3_0)
	return not arg_3_0._disabled
end

var_0_1.register_rpcs = function (arg_4_0, arg_4_1)
	arg_4_0._network_event_delegate = arg_4_1

	if Managers.state.network.is_server then
		arg_4_1:register(arg_4_0, "rpc_backend_session_done")
	else
		arg_4_1:register(arg_4_0, "rpc_backend_session_join")
	end
end

var_0_1.rpc_backend_session_join = function (arg_5_0, arg_5_1, arg_5_2)
	BackendSession.join(arg_5_2)
end

var_0_1.rpc_backend_session_done = function (arg_6_0, arg_6_1)
	if not arg_6_0._debug_backend_session_done_timeout then
		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		arg_6_0:_dice_player_done(var_6_0)
	end
end

var_0_1._dice_player_done = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._dice_data.players

	var_7_0[arg_7_1] = nil

	if table.is_empty(var_7_0) and not arg_7_0._debug_backend_session_stop_timeout then
		BackendSession.stop()

		arg_7_0._dice_data = nil
	end
end

var_0_1.reset = function (arg_8_0)
	if arg_8_0._disabled then
		arg_8_0._disabled = nil
	else
		local var_8_0 = BackendSession.get_state()

		if Managers.state.network.is_server and var_8_0 ~= var_0_0.UNINITIALIZED then
			BackendSession.stop()
		end

		arg_8_0._post_dice_timeout = nil

		arg_8_0:_unregister_rpcs()

		arg_8_0._peers = {}
		arg_8_0._peer_queue = {}
		arg_8_0._disabled = nil
		arg_8_0._dice_data = nil
	end
end

var_0_1._unregister_rpcs = function (arg_9_0)
	arg_9_0._network_event_delegate:unregister(arg_9_0)

	arg_9_0._network_event_delegate = nil
end

var_0_1.update = function (arg_10_0, arg_10_1)
	local var_10_0 = BackendSession.get_state()

	if arg_10_0._log_state then
		if var_10_0 == var_0_0.UNINITIALIZED then
			print("Session state: done!")

			arg_10_0._log_state = nil
		else
			print("Session state: ", var_0_0[var_10_0])
		end
	end

	if #arg_10_0._peer_queue > 0 and BackendSession.get_session_id() then
		local var_10_1 = BackendSession.get_session_id()
		local var_10_2 = Managers.state.network

		for iter_10_0, iter_10_1 in ipairs(arg_10_0._peer_queue) do
			arg_10_0._peer_queue[iter_10_0] = nil

			var_10_2.network_transmit:send_rpc("rpc_backend_session_join", iter_10_1, var_10_1)

			arg_10_0._peers[iter_10_1] = true
		end
	end

	local var_10_3 = arg_10_0._dice_data

	if var_10_3 and Managers.time:time("main") > var_10_3.timeout then
		for iter_10_2, iter_10_3 in pairs(var_10_3.players) do
			arg_10_0:_dice_player_done(iter_10_2)
		end

		arg_10_0._error_data = {
			reason = BACKEND_LUA_ERRORS.ERR_DICE_TIMEOUT2
		}
	elseif arg_10_0._post_dice_timeout then
		if var_10_0 == var_0_0.UNINITIALIZED then
			arg_10_0._post_dice_timeout = nil
		elseif Managers.time:time("main") > arg_10_0._post_dice_timeout then
			arg_10_0._post_dice_timeout = nil
		end
	end
end

var_0_1.add_peer = function (arg_11_0, arg_11_1)
	local var_11_0 = BackendSession.get_session_id()

	if var_11_0 then
		Managers.state.network.network_transmit:send_rpc("rpc_backend_session_join", arg_11_1, var_11_0)

		arg_11_0._peers[arg_11_1] = true
	else
		arg_11_0._peer_queue[#arg_11_0._peer_queue + 1] = arg_11_1
	end
end

var_0_1.end_of_round = function (arg_12_0)
	local var_12_0 = table.clone(arg_12_0._peers)

	var_12_0[Network.peer_id()] = true

	local var_12_1 = Managers.time:time("main") + 20

	arg_12_0._dice_data = {
		players = var_12_0,
		timeout = var_12_1
	}

	BackendSession.end_of_round()
end

var_0_1.received_dice_game_loot = function (arg_13_0)
	arg_13_0._post_dice_timeout = Managers.time:time("main") + 20

	Managers.state.network.network_transmit:send_rpc_server("rpc_backend_session_done")
end

var_0_1.check_for_errors = function (arg_14_0)
	local var_14_0 = arg_14_0._error_data

	arg_14_0._error_data = nil

	return var_14_0
end

BackendInterfaceSession = class(BackendInterfaceSession)

BackendInterfaceSession.init = function (arg_15_0)
	arg_15_0._backend_session = var_0_1:new()
end

BackendInterfaceSession.setup = function (arg_16_0, arg_16_1, arg_16_2)
	if arg_16_2 then
		arg_16_0._backend_session:disable()
	else
		arg_16_0._backend_session:register_rpcs(arg_16_1)
	end
end

BackendInterfaceSession.update = function (arg_17_0)
	local var_17_0 = arg_17_0._backend_session

	if var_17_0:enabled() then
		var_17_0:update()
	end
end

BackendInterfaceSession.check_for_errors = function (arg_18_0)
	return arg_18_0._backend_session:check_for_errors()
end

BackendInterfaceSession.add_peer = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._backend_session

	if var_19_0:enabled() then
		var_19_0:add_peer(arg_19_1)
	end
end

BackendInterfaceSession.start = function (arg_20_0)
	if arg_20_0._backend_session:enabled() then
		BackendSession.start()
	end
end

BackendInterfaceSession.end_of_round = function (arg_21_0)
	local var_21_0 = arg_21_0._backend_session

	if var_21_0:enabled() then
		var_21_0:end_of_round()
	end
end

BackendInterfaceSession.received_dice_game_loot = function (arg_22_0)
	local var_22_0 = arg_22_0._backend_session

	if var_22_0:enabled() then
		var_22_0:received_dice_game_loot()
	end
end

BackendInterfaceSession.get_state = function (arg_23_0)
	local var_23_0 = BackendSession.get_state()

	return var_0_0[var_23_0]
end

BackendInterfaceSession.leave = function (arg_24_0)
	arg_24_0._backend_session:reset()
end

BackendInterfaceSessionLocal = class(BackendInterfaceSessionLocal)

BackendInterfaceSessionLocal.init = function (arg_25_0)
	local var_25_0 = {}

	var_25_0.__index = function ()
		return var_25_0.__index
	end

	setmetatable(arg_25_0, var_25_0)

	arg_25_0.is_local = true
end

BackendInterfaceSessionLocal.ready = function (arg_27_0)
	return true
end
