-- chunkname: @scripts/managers/network/game_server_manager.lua

GameServerManager = class(GameServerManager)

GameServerManager.init = function (arg_1_0, arg_1_1)
	arg_1_0._last_error_reason = ""
end

GameServerManager.setup_network_context = function (arg_2_0, arg_2_1)
	arg_2_0._network_server = arg_2_1.network_server
	arg_2_0._network_transmit = arg_2_1.network_transmit
	arg_2_0._game_server = arg_2_1.game_server
	arg_2_0._profile_synchronizer = arg_2_1.profile_synchronizer
end

GameServerManager.destroy = function (arg_3_0)
	if arg_3_0._network_transmit then
		arg_3_0._network_transmit:destroy()

		arg_3_0._network_transmit = nil
	end
end

GameServerManager.update = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_notify_backend_errors()
end

GameServerManager.peer_name = function (arg_5_0, arg_5_1)
	return arg_5_0._game_server:user_name(arg_5_1)
end

GameServerManager.remove_peer = function (arg_6_0, arg_6_1)
	arg_6_0._game_server:remove_peer(arg_6_1)
end

GameServerManager._update_game_server = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:_update_leader()
end

GameServerManager.server_name = function (arg_8_0)
	return arg_8_0._game_server:server_name()
end

GameServerManager.set_leader_peer_id = function (arg_9_0, arg_9_1)
	Managers.party:set_leader(arg_9_1)

	local var_9_0 = arg_9_1 == nil and "0" or arg_9_1
	local var_9_1 = arg_9_0._game_server:members():get_members()

	for iter_9_0, iter_9_1 in ipairs(var_9_1) do
		local var_9_2 = PEER_ID_TO_CHANNEL[iter_9_1]

		RPC.rpc_game_server_set_group_leader(var_9_2, var_9_0)
	end
end

GameServerManager.start_game_params = function (arg_10_0)
	return arg_10_0._start_game_params
end

GameServerManager.restart = function (arg_11_0)
	arg_11_0._wants_restart = true
end

GameServerManager.get_transition = function (arg_12_0)
	if arg_12_0._wants_restart then
		return "restart_game_server"
	end
end

GameServerManager.hot_join_sync = function (arg_13_0, arg_13_1)
	local var_13_0 = Managers.matchmaking

	if var_13_0 and var_13_0:on_dedicated_server() then
		return
	end

	local var_13_1 = Managers.party:leader()
	local var_13_2 = var_13_1 == nil and "0" or var_13_1
	local var_13_3 = PEER_ID_TO_CHANNEL[arg_13_1]

	RPC.rpc_game_server_set_group_leader(var_13_3, var_13_2)
end

GameServerManager.set_start_game_params = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = Managers.party:leader()

	if arg_14_1 ~= var_14_0 then
		mm_printf("Peer (%s) tried starting the game without being leader (%s)", arg_14_1, var_14_0)

		return
	end

	local var_14_1 = arg_14_0._game_server:get_stored_lobby_data()

	var_14_1.level_key = arg_14_2
	var_14_1.difficulty = arg_14_4
	var_14_1.game_mode = not IS_PS4 and NetworkLookup.game_modes[arg_14_3] or arg_14_3
	var_14_1.is_private = arg_14_5 and "true" or "false"

	arg_14_0._game_server:set_lobby_data(var_14_1)

	arg_14_0._start_game_params = {
		level_key = arg_14_2,
		game_mode = arg_14_3,
		difficulty = arg_14_4,
		private_game = arg_14_5
	}
end

GameServerManager._notify_backend_errors = function (arg_15_0)
	local var_15_0 = Managers.backend

	if var_15_0 ~= nil and var_15_0:has_error() then
		local var_15_1 = var_15_0:error_string()

		if arg_15_0._last_error_reason ~= var_15_1 then
			arg_15_0:_say(var_15_1)

			arg_15_0._last_error_reason = var_15_1
		end
	end
end

GameServerManager._say = function (arg_16_0, arg_16_1)
	arg_16_1 = UTF8Utils.sub_string(arg_16_1, 1, 128)

	local var_16_0 = Managers.chat

	if var_16_0 ~= nil and var_16_0:has_channel(1) then
		local var_16_1 = false

		var_16_0:send_system_chat_message(1, "backend_error_on_server", arg_16_1, var_16_1, true)
	end
end
