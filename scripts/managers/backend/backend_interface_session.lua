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

function var_0_1.init(arg_1_0)
	arg_1_0._peers = {}
	arg_1_0._peer_queue = {}
	arg_1_0._debug_backend_session_done_timeout = false
	arg_1_0._debug_backend_session_stop_timeout = false
end

function var_0_1.disable(arg_2_0)
	arg_2_0._disabled = true
end

function var_0_1.enabled(arg_3_0)
	return not arg_3_0._disabled
end

function var_0_1.register_rpcs(arg_4_0, arg_4_1)
	arg_4_0._network_event_delegate = arg_4_1

	if Managers.state.network.is_server then
		arg_4_1:register(arg_4_0, "rpc_backend_session_done")
	else
		arg_4_1:register(arg_4_0, "rpc_backend_session_join")
	end
end

function var_0_1.rpc_backend_session_join(arg_5_0, arg_5_1, arg_5_2)
	BackendSession.join(arg_5_2)
end

function var_0_1.rpc_backend_session_done(arg_6_0, arg_6_1)
	if not arg_6_0._debug_backend_session_done_timeout then
		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		arg_6_0:_dice_player_done(var_6_0)
	end
end

function var_0_1._dice_player_done(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._dice_data.players

	var_7_0[arg_7_1] = nil

	if table.is_empty(var_7_0) and not arg_7_0._debug_backend_session_stop_timeout then
		BackendSession.stop()

		arg_7_0._dice_data = nil
	end
end

function var_0_1.reset(arg_8_0)
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

function var_0_1._unregister_rpcs(arg_9_0)
	arg_9_0._network_event_delegate:unregister(arg_9_0)

	arg_9_0._network_event_delegate = nil
end

function var_0_1.update(arg_10_0, arg_10_1)
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

function var_0_1.add_peer(arg_11_0, arg_11_1)
	local var_11_0 = BackendSession.get_session_id()

	if var_11_0 then
		Managers.state.network.network_transmit:send_rpc("rpc_backend_session_join", arg_11_1, var_11_0)

		arg_11_0._peers[arg_11_1] = true
	else
		arg_11_0._peer_queue[#arg_11_0._peer_queue + 1] = arg_11_1
	end
end

function var_0_1.end_of_round(arg_12_0)
	local var_12_0 = table.clone(arg_12_0._peers)

	var_12_0[Network.peer_id()] = true

	local var_12_1 = Managers.time:time("main") + 20

	arg_12_0._dice_data = {
		players = var_12_0,
		timeout = var_12_1
	}

	BackendSession.end_of_round()
end

function var_0_1.received_dice_game_loot(arg_13_0)
	arg_13_0._post_dice_timeout = Managers.time:time("main") + 20

	Managers.state.network.network_transmit:send_rpc_server("rpc_backend_session_done")
end

function var_0_1.check_for_errors(arg_14_0)
	local var_14_0 = arg_14_0._error_data

	arg_14_0._error_data = nil

	return var_14_0
end

BackendInterfaceSession = class(BackendInterfaceSession)

function BackendInterfaceSession.init(arg_15_0)
	arg_15_0._backend_session = var_0_1:new()
end

function BackendInterfaceSession.setup(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_2 then
		arg_16_0._backend_session:disable()
	else
		arg_16_0._backend_session:register_rpcs(arg_16_1)
	end
end

function BackendInterfaceSession.update(arg_17_0)
	local var_17_0 = arg_17_0._backend_session

	if var_17_0:enabled() then
		var_17_0:update()
	end
end

function BackendInterfaceSession.check_for_errors(arg_18_0)
	return arg_18_0._backend_session:check_for_errors()
end

function BackendInterfaceSession.add_peer(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._backend_session

	if var_19_0:enabled() then
		var_19_0:add_peer(arg_19_1)
	end
end

function BackendInterfaceSession.start(arg_20_0)
	if arg_20_0._backend_session:enabled() then
		BackendSession.start()
	end
end

function BackendInterfaceSession.end_of_round(arg_21_0)
	local var_21_0 = arg_21_0._backend_session

	if var_21_0:enabled() then
		var_21_0:end_of_round()
	end
end

function BackendInterfaceSession.received_dice_game_loot(arg_22_0)
	local var_22_0 = arg_22_0._backend_session

	if var_22_0:enabled() then
		var_22_0:received_dice_game_loot()
	end
end

function BackendInterfaceSession.get_state(arg_23_0)
	local var_23_0 = BackendSession.get_state()

	return var_0_0[var_23_0]
end

function BackendInterfaceSession.leave(arg_24_0)
	arg_24_0._backend_session:reset()
end

BackendInterfaceSessionLocal = class(BackendInterfaceSessionLocal)

function BackendInterfaceSessionLocal.init(arg_25_0)
	local var_25_0 = {}

	function var_25_0.__index()
		return var_25_0.__index
	end

	setmetatable(arg_25_0, var_25_0)

	arg_25_0.is_local = true
end

function BackendInterfaceSessionLocal.ready(arg_27_0)
	return true
end
