-- chunkname: @scripts/network/lobby_lan.lua

require("scripts/network/lobby_aux")
require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/network/lobby_members")

LobbyInternal = LobbyInternal or {}
LobbyInternal.lobby_data_version = 2

if IS_XB1 then
	LobbyInternal.state_map = {
		[LobbyState.WORKING] = LobbyState.WORKING,
		[LobbyState.SHUTDOWN] = LobbyState.SHUTDOWN,
		[LobbyState.JOINED] = LobbyState.JOINED,
		[LobbyState.FAILED] = LobbyState.FAILED
	}
end

LobbyInternal.TYPE = "lan"

function LobbyInternal.network_initialized()
	return not not LobbyInternal.client
end

function LobbyInternal.create_lobby(arg_2_0)
	return Network.create_lan_lobby(arg_2_0.max_members)
end

function LobbyInternal.join_lobby(arg_3_0)
	return Network.join_lan_lobby(arg_3_0.id)
end

LobbyInternal.leave_lobby = Network.leave_lan_lobby

function LobbyInternal.open_channel(arg_4_0, arg_4_1)
	local var_4_0 = LanLobby.open_channel(arg_4_0, arg_4_1)

	print("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", arg_4_0, arg_4_1, var_4_0)

	return var_4_0
end

function LobbyInternal.close_channel(arg_5_0, arg_5_1)
	printf("LobbyInternal.close_channel lobby: %s, channel: %s", arg_5_0, arg_5_1)
	LanLobby.close_channel(arg_5_0, arg_5_1)
end

function LobbyInternal.is_orphaned(arg_6_0)
	return false
end

function LobbyInternal.game_session_host(arg_7_0)
	return LanLobby.game_session_host(arg_7_0)
end

function LobbyInternal.init_client(arg_8_0)
	local var_8_0 = arg_8_0.server_port

	if Development.parameter("client") then
		var_8_0 = 0
	end

	local var_8_1 = Development.parameter("lan_peer_id")

	if var_8_1 then
		print("Forcing LAN peer_id ", var_8_1)

		LobbyInternal.client = Network.init_lan_client(arg_8_0.config_file_name, var_8_0, var_8_1)
	else
		LobbyInternal.client = Network.init_lan_client(arg_8_0.config_file_name, var_8_0)
	end

	fassert(LobbyInternal.client, "Failed to initialize the network. The port is most likely in use, which means that another game instance is running at the same time.")
	GameSettingsDevelopment.set_ignored_rpc_logs()
end

function LobbyInternal.shutdown_client()
	Network.shutdown_lan_client(LobbyInternal.client)

	LobbyInternal.client = nil
end

function LobbyInternal.get_lobby_data_from_id(arg_10_0)
	return nil
end

function LobbyInternal.get_lobby_data_from_id_by_key(arg_11_0, arg_11_1)
	return nil
end

function LobbyInternal.ping(arg_12_0)
	return Network.ping(arg_12_0)
end

LobbyInternal.get_lobby = LanLobbyBrowser.lobby

local var_0_0 = {
	is_refreshing = function()
		return false
	end,
	refresh = function()
		return
	end,
	num_lobbies = function()
		return 0
	end
}

function LobbyInternal.lobby_browser()
	return var_0_0
end

function LobbyInternal.clear_filter_requirements()
	return
end

function LobbyInternal.add_filter_requirements(arg_18_0)
	return
end

function LobbyInternal.user_name(arg_19_0)
	return Network.peer_id()
end

function LobbyInternal.lobby_id(arg_20_0)
	return 10000
end

function LobbyInternal.is_friend(arg_21_0)
	local var_21_0 = rawget(_G, "Steam") or stingray.Steam

	if var_21_0 and var_21_0.user_id() == arg_21_0 then
		return true
	end

	local var_21_1 = rawget(_G, "Friends") or stingray.Friends

	if var_21_1 and var_21_1.in_category(arg_21_0, var_21_1.FRIEND_FLAG) then
		return true
	end

	return false
end

function LobbyInternal.client_ready()
	return false
end

function LobbyInternal.set_max_members(arg_23_0, arg_23_1)
	LanLobby.set_max_members(arg_23_0, arg_23_1)
end

function LobbyInternal.lobby_id_match(arg_24_0, arg_24_1)
	if arg_24_0 == nil or arg_24_1 == nil then
		return true
	end

	return arg_24_0 == arg_24_1
end
