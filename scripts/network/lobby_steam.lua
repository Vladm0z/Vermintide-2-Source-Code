-- chunkname: @scripts/network/lobby_steam.lua

require("scripts/network/lobby_aux")
require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/network/lobby_members")

local LobbyInternal = LobbyInternal

LobbyInternal = LobbyInternal or {}
LobbyInternal = LobbyInternal
LobbyInternal.TYPE = "steam"
LobbyInternal.lobby_data_version = 2

LobbyInternal.network_initialized = function ()
	-- function 1
	return not not LobbyInternal.client
end

LobbyInternal.create_lobby = function (self)
	-- function 2
	local privacy = self.privacy

	privacy = privacy or "public"

	local flag = true

	return Network.create_steam_lobby(privacy, self.max_members, flag)
end

LobbyInternal.join_lobby = function (self)
	-- function 3
	local flag = true

	return Network.join_steam_lobby(self.id, flag)
end

LobbyInternal.leave_lobby = function (arg_4_0)
	-- function 4
	Network.leave_steam_lobby(arg_4_0)
end

LobbyInternal.open_channel = function (arg_5_0, arg_5_1)
	-- function 5
	local open_channel = SteamLobby.open_channel(arg_5_0, arg_5_1)

	printf("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", arg_5_0, arg_5_1, open_channel)

	return open_channel
end

LobbyInternal.close_channel = function (arg_6_0, arg_6_1)
	-- function 6
	printf("LobbyInternal.close_channel lobby: %s, channel: %s", arg_6_0, arg_6_1)
	SteamLobby.close_channel(arg_6_0, arg_6_1)
end

LobbyInternal.is_orphaned = function (self)
	-- function 7
	return self.is_orphaned(self)
end

LobbyInternal.init_client = function (self)
	-- function 8
	LobbyInternal.client = Network.init_steam_client(self.config_file_name)

	if not LobbyInternal._peer_id_property_set then
		LobbyInternal._peer_id_property_set = true

		Crashify.print_property("peer_id", Network.peer_id())
	end

	GameSettingsDevelopment.set_ignored_rpc_logs()
end

LobbyInternal.shutdown_client = function ()
	-- function 9
	Network.shutdown_steam_client(LobbyInternal.client)
	GameServerInternal.forget_server_browser()

	LobbyInternal.client = nil
end

LobbyInternal.get_lobby_data_from_id = function (arg_10_0)
	-- function 10
	SteamLobby.request_lobby_data(arg_10_0)

	return (SteamMisc.get_lobby_data(arg_10_0))
end

LobbyInternal.get_lobby_data_from_id_by_key = function (arg_11_0, arg_11_1)
	-- function 11
	local get_lobby_data_by_key = SteamMisc.get_lobby_data_by_key(arg_11_0, arg_11_1)

	return get_lobby_data_by_key == "" or not get_lobby_data_by_key or nil
end

LobbyInternal.ping = function (arg_12_0)
	-- function 12
	return Network.ping(arg_12_0)
end

LobbyInternal.get_lobby = function (self, arg_13_1)
	-- function 13
	local lobby = self:lobby(arg_13_1)
	local data_all = self:data_all(arg_13_1)

	data_all.id = lobby.id

	local tbl = {}

	for k, v in pairs(data_all) do
		tbl[string.lower(k)] = v
	end

	return tbl
end

LobbyInternal.clear_filter_requirements = function (arg_14_0)
	-- function 14
	SteamLobbyBrowser.clear_filters(arg_14_0)
end

LobbyInternal.add_filter_requirements = function (self, arg_15_1)
	-- function 15
	SteamLobbyBrowser.clear_filters(arg_15_1)
	SteamLobbyBrowser.add_slots_filter(arg_15_1, self.free_slots)

	local distance_filter = self.distance_filter

	fassert(distance_filter, "Missing or bad distance filer: %s", distance_filter)
	SteamLobbyBrowser.add_distance_filter(arg_15_1, distance_filter)
	mm_printf("Filter: Free slots = %s", tostring(self.free_slots))
	mm_printf("Filter: Distance = %s", tostring(self.distance_filter))

	for k, v in pairs(self.filters) do
		local value = v.value
		local comparison = v.comparison

		SteamLobbyBrowser.add_filter(arg_15_1, k, value, comparison)
		mm_printf("Filter: %s, comparison(%s), value=%s", tostring(k), tostring(comparison), tostring(value))
	end

	for i, v_2 in ipairs(self.near_filters) do
		local key = v_2.key
		local value_2 = v_2.value

		SteamLobbyBrowser.add_near_filter(arg_15_1, key, value_2)
		mm_printf("Near Filter: %s, value=%s", tostring(key), tostring(value_2))
	end
end

LobbyInternal.user_name = function (arg_16_0)
	-- function 16
	return Steam.user_name(arg_16_0)
end

LobbyInternal.lobby_id = function (self)
	-- function 17
	return self:id()
end

LobbyInternal.is_friend = function (arg_18_0)
	-- function 18
	return Friends.in_category(arg_18_0, Friends.FRIEND_FLAG)
end

LobbyInternal.set_max_members = function (arg_19_0, arg_19_1)
	-- function 19
	SteamLobby.set_max_members(arg_19_0, arg_19_1)
end
