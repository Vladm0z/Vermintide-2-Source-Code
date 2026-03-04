-- chunkname: @scripts/managers/network/lobby_manager.lua

LobbyManager = class(LobbyManager)

LobbyManager.init = function (arg_1_0)
	arg_1_0._lobbies = {}
	arg_1_0._tags = {}
end

LobbyManager.make_lobby = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, ...)
	fassert(not arg_2_0._lobbies[arg_2_2], "[LobbyManager] Overwriting existing lobby with handle %s. Tag: %s", arg_2_2, arg_2_0._tags[arg_2_2])

	local var_2_0 = arg_2_1:new(...)

	arg_2_0._lobbies[arg_2_2] = var_2_0
	arg_2_0._tags[arg_2_2] = arg_2_3

	return var_2_0
end

LobbyManager.register_existing_lobby = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	fassert(not arg_3_0._lobbies[arg_3_2], "[LobbyManager] Overwriting existing lobby with handle %s. Tag: %s", arg_3_2, arg_3_0._tags[arg_3_2])

	arg_3_0._lobbies[arg_3_2] = arg_3_1
	arg_3_0._tags[arg_3_2] = arg_3_3
end

LobbyManager.move_lobby = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	fassert(not arg_4_0._lobbies[arg_4_2], "[LobbyManager] Overwriting existing lobby with handle %s. Existing tag: %s", arg_4_2, arg_4_0._tags[arg_4_1])

	arg_4_0._lobbies[arg_4_2] = arg_4_0._lobbies[arg_4_1]
	arg_4_0._tags[arg_4_2] = arg_4_0._tags[arg_4_1] .. " -> " .. arg_4_3
	arg_4_0._lobbies[arg_4_1] = nil
	arg_4_0._tags[arg_4_1] = nil

	print("[LobbyManager] Renaming lobby %s to %s", arg_4_1, arg_4_2)
end

LobbyManager.query_lobby = function (arg_5_0, arg_5_1)
	return arg_5_0._lobbies[arg_5_1]
end

LobbyManager.get_lobby = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._lobbies[arg_6_1]

	if not var_6_0 then
		ferror("[LobbyManager] Expected lobby with handle %s but found none. Existing lobbies:", arg_6_1, table.tostring(table.map_to_array(arg_6_0._lobbies, function (arg_7_0)
			return arg_7_0 .. ": " .. arg_6_0._tags[arg_7_0]
		end)))
	end

	return var_6_0
end

LobbyManager.destroy_lobby = function (arg_8_0, arg_8_1)
	arg_8_0:free_lobby(arg_8_1):destroy()
end

LobbyManager.free_lobby = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._lobbies[arg_9_1]

	arg_9_0._lobbies[arg_9_1] = nil

	return var_9_0
end
