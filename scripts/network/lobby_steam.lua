-- chunkname: @scripts/network/lobby_steam.lua

require("scripts/network/lobby_aux")
require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/network/lobby_members")

LobbyInternal = LobbyInternal or {}
LobbyInternal.TYPE = "steam"
LobbyInternal.lobby_data_version = 2

function LobbyInternal.network_initialized()
	return not not LobbyInternal.client
end

function LobbyInternal.create_lobby(arg_2_0)
	local var_2_0 = arg_2_0.privacy or "public"
	local var_2_1 = true

	return Network.create_steam_lobby(var_2_0, arg_2_0.max_members, var_2_1)
end

function LobbyInternal.join_lobby(arg_3_0)
	local var_3_0 = true

	return Network.join_steam_lobby(arg_3_0.id, var_3_0)
end

function LobbyInternal.leave_lobby(arg_4_0)
	Network.leave_steam_lobby(arg_4_0)
end

function LobbyInternal.open_channel(arg_5_0, arg_5_1)
	local var_5_0 = SteamLobby.open_channel(arg_5_0, arg_5_1)

	printf("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", arg_5_0, arg_5_1, var_5_0)

	return var_5_0
end

function LobbyInternal.close_channel(arg_6_0, arg_6_1)
	printf("LobbyInternal.close_channel lobby: %s, channel: %s", arg_6_0, arg_6_1)
	SteamLobby.close_channel(arg_6_0, arg_6_1)
end

function LobbyInternal.is_orphaned(arg_7_0)
	return arg_7_0.is_orphaned(arg_7_0)
end

function LobbyInternal.init_client(arg_8_0)
	LobbyInternal.client = Network.init_steam_client(arg_8_0.config_file_name)

	if not LobbyInternal._peer_id_property_set then
		LobbyInternal._peer_id_property_set = true

		Crashify.print_property("peer_id", Network.peer_id())
	end

	GameSettingsDevelopment.set_ignored_rpc_logs()
end

function LobbyInternal.shutdown_client()
	Network.shutdown_steam_client(LobbyInternal.client)
	GameServerInternal.forget_server_browser()

	LobbyInternal.client = nil
end

function LobbyInternal.get_lobby_data_from_id(arg_10_0)
	SteamLobby.request_lobby_data(arg_10_0)

	return (SteamMisc.get_lobby_data(arg_10_0))
end

function LobbyInternal.get_lobby_data_from_id_by_key(arg_11_0, arg_11_1)
	local var_11_0 = SteamMisc.get_lobby_data_by_key(arg_11_0, arg_11_1)

	return var_11_0 ~= "" and var_11_0 or nil
end

function LobbyInternal.ping(arg_12_0)
	return Network.ping(arg_12_0)
end

function LobbyInternal.get_lobby(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0:lobby(arg_13_1)
	local var_13_1 = arg_13_0:data_all(arg_13_1)

	var_13_1.id = var_13_0.id

	local var_13_2 = {}

	for iter_13_0, iter_13_1 in pairs(var_13_1) do
		var_13_2[string.lower(iter_13_0)] = iter_13_1
	end

	return var_13_2
end

function LobbyInternal.clear_filter_requirements(arg_14_0)
	SteamLobbyBrowser.clear_filters(arg_14_0)
end

function LobbyInternal.add_filter_requirements(arg_15_0, arg_15_1)
	SteamLobbyBrowser.clear_filters(arg_15_1)
	SteamLobbyBrowser.add_slots_filter(arg_15_1, arg_15_0.free_slots)

	local var_15_0 = arg_15_0.distance_filter

	fassert(var_15_0, "Missing or bad distance filer: %s", var_15_0)
	SteamLobbyBrowser.add_distance_filter(arg_15_1, var_15_0)
	mm_printf("Filter: Free slots = %s", tostring(arg_15_0.free_slots))
	mm_printf("Filter: Distance = %s", tostring(arg_15_0.distance_filter))

	for iter_15_0, iter_15_1 in pairs(arg_15_0.filters) do
		local var_15_1 = iter_15_1.value
		local var_15_2 = iter_15_1.comparison

		SteamLobbyBrowser.add_filter(arg_15_1, iter_15_0, var_15_1, var_15_2)
		mm_printf("Filter: %s, comparison(%s), value=%s", tostring(iter_15_0), tostring(var_15_2), tostring(var_15_1))
	end

	for iter_15_2, iter_15_3 in ipairs(arg_15_0.near_filters) do
		local var_15_3 = iter_15_3.key
		local var_15_4 = iter_15_3.value

		SteamLobbyBrowser.add_near_filter(arg_15_1, var_15_3, var_15_4)
		mm_printf("Near Filter: %s, value=%s", tostring(var_15_3), tostring(var_15_4))
	end
end

function LobbyInternal.user_name(arg_16_0)
	return Steam.user_name(arg_16_0)
end

function LobbyInternal.lobby_id(arg_17_0)
	return arg_17_0:id()
end

function LobbyInternal.is_friend(arg_18_0)
	return Friends.in_category(arg_18_0, Friends.FRIEND_FLAG)
end

function LobbyInternal.set_max_members(arg_19_0, arg_19_1)
	SteamLobby.set_max_members(arg_19_0, arg_19_1)
end
