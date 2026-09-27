-- chunkname: @scripts/network/lobby_lan.lua

require("scripts/network/lobby_aux")
require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/network/lobby_members")

local LobbyInternal = LobbyInternal

LobbyInternal = LobbyInternal or {}
LobbyInternal = LobbyInternal
LobbyInternal.lobby_data_version = 2

if not IS_XB1 then
	LobbyInternal.state_map = {
		[LobbyState.WORKING] = LobbyState.WORKING,
		[LobbyState.SHUTDOWN] = LobbyState.SHUTDOWN,
		[LobbyState.JOINED] = LobbyState.JOINED,
		[LobbyState.FAILED] = LobbyState.FAILED
	}
end

LobbyInternal.TYPE = "lan"

LobbyInternal.network_initialized = function ()
	-- function 1
	return not not LobbyInternal.client
end

LobbyInternal.create_lobby = function (self)
	-- function 2
	return Network.create_lan_lobby(self.max_members)
end

LobbyInternal.join_lobby = function (self)
	-- function 3
	return Network.join_lan_lobby(self.id)
end

LobbyInternal.leave_lobby = Network.leave_lan_lobby

LobbyInternal.open_channel = function (arg_4_0, arg_4_1)
	-- function 4
	local open_channel = LanLobby.open_channel(arg_4_0, arg_4_1)

	printf("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", arg_4_0, arg_4_1, open_channel)

	return open_channel
end

LobbyInternal.close_channel = function (arg_5_0, arg_5_1)
	-- function 5
	printf("LobbyInternal.close_channel lobby: %s, channel: %s", arg_5_0, arg_5_1)
	LanLobby.close_channel(arg_5_0, arg_5_1)
end

LobbyInternal.is_orphaned = function (arg_6_0)
	-- function 6
	return false
end

LobbyInternal.game_session_host = function (arg_7_0)
	-- function 7
	return LanLobby.game_session_host(arg_7_0)
end

LobbyInternal.init_client = function (self)
	-- function 8
	local server_port = self.server_port

	if not Development.parameter("client") then
		server_port = 0
	end

	local parameter = Development.parameter("lan_peer_id")

	if not parameter then
		print("Forcing LAN peer_id ", parameter)

		LobbyInternal.client = Network.init_lan_client(self.config_file_name, server_port, parameter)
	else
		LobbyInternal.client = Network.init_lan_client(self.config_file_name, server_port)
	end

	fassert(LobbyInternal.client, "Failed to initialize the network. The port is most likely in use, which means that another game instance is running at the same time.")
	GameSettingsDevelopment.set_ignored_rpc_logs()
end

LobbyInternal.shutdown_client = function ()
	-- function 9
	Network.shutdown_lan_client(LobbyInternal.client)

	LobbyInternal.client = nil
end

LobbyInternal.get_lobby_data_from_id = function (arg_10_0)
	-- function 10
	return nil
end

LobbyInternal.get_lobby_data_from_id_by_key = function (arg_11_0, arg_11_1)
	-- function 11
	return nil
end

LobbyInternal.ping = function (arg_12_0)
	-- function 12
	return Network.ping(arg_12_0)
end

LobbyInternal.get_lobby = LanLobbyBrowser.lobby

local tbl = {
	is_refreshing = function ()
		-- function 13
		return false
	end,
	refresh = function ()
		-- function 14
		return
	end,
	num_lobbies = function ()
		-- function 15
		return 0
	end
}

LobbyInternal.lobby_browser = function ()
	-- function 16
	return tbl
end

LobbyInternal.clear_filter_requirements = function ()
	-- function 17
	return
end

LobbyInternal.add_filter_requirements = function (arg_18_0)
	-- function 18
	return
end

LobbyInternal.user_name = function (arg_19_0)
	-- function 19
	return Network.peer_id()
end

LobbyInternal.lobby_id = function (arg_20_0)
	-- function 20
	return 10000
end

LobbyInternal.is_friend = function (arg_21_0)
	-- function 21
	local var_21_0 = rawget(_G, "Steam")

	var_21_0 = var_21_0 or stingray.Steam

	if not (not var_21_0 and var_21_0.user_id() ~= arg_21_0) then
		return true
	end

	local var_21_1 = rawget(_G, "Friends")

	var_21_1 = var_21_1 or stingray.Friends

	if not var_21_1 and not var_21_1.in_category(arg_21_0, var_21_1.FRIEND_FLAG) then
		return true
	end

	return false
end

LobbyInternal.client_ready = function ()
	-- function 22
	return false
end

LobbyInternal.set_max_members = function (arg_23_0, arg_23_1)
	-- function 23
	LanLobby.set_max_members(arg_23_0, arg_23_1)
end

LobbyInternal.lobby_id_match = function (arg_24_0, arg_24_1)
	-- function 24
	if not (arg_24_0 == nil or arg_24_1 ~= nil) then
		return true
	end

	return arg_24_0 == arg_24_1
end
