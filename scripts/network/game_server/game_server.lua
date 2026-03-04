-- chunkname: @scripts/network/game_server/game_server.lua

require("scripts/network/game_server/game_server_aux")
require("scripts/network/lobby_members")

local var_0_0 = script_data.testify and require("scripts/network/game_server/testify/game_server_testify")

GameServer = class(GameServer)

local function var_0_1(arg_1_0, ...)
	local var_1_0 = arg_1_0.format(arg_1_0, ...)

	printf("[GameServer]: %s", var_1_0)
end

GameServer.init = function (arg_2_0, arg_2_1, arg_2_2)
	var_0_1("Initializing game server...")

	local var_2_0 = arg_2_1.config_file_name
	local var_2_1 = arg_2_1.project_hash

	arg_2_0._network_hash = GameServerAux.create_network_hash(var_2_0, var_2_1)

	assert(arg_2_1.max_members, "Has to pass max_members to GameServer")

	arg_2_0._max_members = arg_2_1.max_members
	arg_2_0._game_server = GameServerInternal.init_server(arg_2_1, arg_2_2)
	arg_2_0._data_table = {}
	arg_2_0._server_name = arg_2_2
	arg_2_0._network_initialized = false
	arg_2_0.is_host = true
end

GameServer.kick_all_except = function (arg_3_0, arg_3_1)
	if GameServerInternal.remove_member then
		arg_3_1 = arg_3_1 or {}

		local var_3_0 = arg_3_0._data_table.host

		for iter_3_0, iter_3_1 in ipairs(arg_3_0._members) do
			if iter_3_1 ~= var_3_0 and not arg_3_1[iter_3_1] then
				GameServerInternal.remove_member(arg_3_0._game_server, iter_3_1)
			end
		end
	end
end

GameServer.destroy = function (arg_4_0)
	var_0_1("Shutting down game server")

	arg_4_0._members = nil
	arg_4_0._data_table = nil

	GameServerInternal.shutdown_server(arg_4_0._game_server)

	arg_4_0._game_server = nil

	GarbageLeakDetector.register_object(arg_4_0, "Game Server")
end

GameServer.update = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._game_server
	local var_5_1 = var_5_0:state()
	local var_5_2 = arg_5_0._state

	if var_5_1 ~= var_5_2 then
		var_0_1("Changing state from %s to %s", var_5_2, var_5_1)

		arg_5_0._state = var_5_1

		if var_5_1 == "connected" then
			local var_5_3 = arg_5_0._data_table

			var_5_3.network_hash = arg_5_0._network_hash

			for iter_5_0, iter_5_1 in pairs(var_5_3) do
				var_5_0:set_data(iter_5_0, iter_5_1)
			end

			arg_5_0._members = arg_5_0._members or LobbyMembers:new(var_5_0)

			if not GameServer._peer_id_property_set then
				GameServer._peer_id_property_set = true

				Crashify.print_property("peer_id", Network.peer_id())
			end
		end

		if var_5_2 == "connected" and arg_5_0._members then
			arg_5_0._members:clear()
		end
	end

	local var_5_4 = arg_5_0._members

	if var_5_4 then
		var_5_4:update()
	end

	GameServerInternal.run_callbacks(arg_5_0._game_server, arg_5_0)

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_5_0)
	end

	return arg_5_0._state
end

GameServer.ping_by_peer = function (arg_6_0, arg_6_1)
	return GameServerInternal.ping(arg_6_1)
end

GameServer.remove_peer = function (arg_7_0, arg_7_1)
	arg_7_0._game_server:remove_member(arg_7_1)
end

GameServer.close_channel = function (arg_8_0, arg_8_1)
	GameServerInternal.close_channel(arg_8_0._game_server, arg_8_1)
end

GameServer.set_level_name = function (arg_9_0, arg_9_1)
	GameServerInternal.set_level_name(arg_9_0._game_server, arg_9_1)
end

GameServer.set_lobby_data = function (arg_10_0, arg_10_1)
	print("Set lobby begin:")

	local var_10_0 = arg_10_0._data_table
	local var_10_1 = arg_10_0._game_server

	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		print(string.format("  Lobby data %s = %s", iter_10_0, tostring(iter_10_1)))

		var_10_0[iter_10_0] = iter_10_1

		var_10_1:set_data(iter_10_0, iter_10_1)
	end

	print("Set lobby end.")
end

GameServer.get_stored_lobby_data = function (arg_11_0)
	return arg_11_0._data_table
end

GameServer.attempting_reconnect = function (arg_12_0)
	return false
end

GameServer.is_dedicated_server = function (arg_13_0)
	return true
end

GameServer.lobby_data = function (arg_14_0, arg_14_1)
	return arg_14_0._game_server:data(arg_14_1)
end

GameServer.lobby_host = function (arg_15_0)
	return Network.peer_id()
end

GameServer.state = function (arg_16_0)
	return arg_16_0._state
end

GameServer.members = function (arg_17_0)
	return arg_17_0._members
end

GameServer.user_name = function (arg_18_0, arg_18_1)
	return GameServerInternal.user_name(arg_18_0._game_server, arg_18_1)
end

GameServer.get_max_members = function (arg_19_0)
	return arg_19_0._max_members
end

GameServer.set_max_members = function (arg_20_0, arg_20_1)
	arg_20_0._max_members = arg_20_1

	GameServerInternal.set_max_members(arg_20_0._game_server, arg_20_1)
end

GameServer.is_joined = function (arg_21_0)
	return arg_21_0._state == "connected"
end

GameServer.id = function (arg_22_0)
	return GameServerInternal.server_id and GameServerInternal.server_id(arg_22_0._game_server) or "no_id"
end

GameServer.server_name = function (arg_23_0)
	return arg_23_0._server_name
end

GameServer.set_server_name = function (arg_24_0, arg_24_1)
	arg_24_0._server_name = arg_24_1
end

GameServer.set_network_initialized = function (arg_25_0, arg_25_1)
	arg_25_0._network_initialized = arg_25_1
end

GameServer.network_initialized = function (arg_26_0)
	return arg_26_0._network_initialized
end

GameServer.failed = function (arg_27_0)
	return arg_27_0._state == "disconnected"
end

GameServer.server_member_added = function (arg_28_0, arg_28_1)
	printf("Member %s was added", arg_28_1)
end

GameServer.server_slot_allocation_request = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if Managers.mechanism:try_reserve_game_server_slots(arg_29_1, arg_29_2, arg_29_3) then
		printf("Request by %s to allocate %d slots was approved", arg_29_1, #arg_29_2)

		return true
	else
		printf("Request by %s to allocate %d slots was disapproved", arg_29_1, #arg_29_2)

		return false
	end
end

GameServer.server_slot_expired = function (arg_30_0, arg_30_1)
	Managers.mechanism:game_server_slot_reservation_expired(arg_30_1)
	printf("Server slot %s was deallocated", arg_30_1)
end

GameServer.lost_connection_to_lobby = function (arg_31_0)
	return false
end
