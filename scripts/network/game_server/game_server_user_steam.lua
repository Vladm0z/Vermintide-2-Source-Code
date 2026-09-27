-- chunkname: @scripts/network/game_server/game_server_user_steam.lua

require("scripts/network/game_server/game_server_aux")

local GameServerInternal = GameServerInternal

GameServerInternal = GameServerInternal or {}
GameServerInternal = GameServerInternal
GameServerInternal.lobby_data_version = 2

GameServerInternal.join_server = function (self, arg_1_1)
	-- function 1
	local ip_port = self.ip_port
	local flag = true
	local invitee = self.invitee
	local var_1_3

	if not invitee then
		var_1_3 = Network.join_steam_server(flag, ip_port, arg_1_1, invitee)
	else
		var_1_3 = Network.join_steam_server(flag, ip_port, arg_1_1)
	end

	SteamGameServerLobby.auto_update_data(var_1_3)

	return var_1_3
end

GameServerInternal.reserve_server = function (self, arg_2_1, arg_2_2)
	-- function 2
	local ip_port = self.ip_port
	local flag = true
	local reserve_steam_server = Network.reserve_steam_server(flag, arg_2_2, ip_port, arg_2_1)

	SteamGameServerLobby.auto_update_data(reserve_steam_server)

	return reserve_steam_server
end

GameServerInternal.claim_reserved = function (arg_3_0)
	-- function 3
	SteamGameServerLobby.join(arg_3_0)
end

if not DEDICATED_SERVER then
	GameServerInternal.open_channel = function (arg_4_0, arg_4_1)
		-- function 4
		local open_channel = SteamGameServerLobby.open_channel(arg_4_0, arg_4_1)

		printf("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", arg_4_0, arg_4_1, open_channel)

		return open_channel
	end

	GameServerInternal.close_channel = function (arg_5_0, arg_5_1)
		-- function 5
		printf("LobbyInternal.close_channel lobby: %s, channel: %s", arg_5_0, arg_5_1)
		SteamGameServerLobby.close_channel(arg_5_0, arg_5_1)
	end
end

GameServerInternal.leave_server = function (arg_6_0)
	-- function 6
	Network.leave_steam_server(arg_6_0)
end

GameServerInternal.lobby_host = function (arg_7_0)
	-- function 7
	return SteamGameServerLobby.game_session_host(arg_7_0)
end

GameServerInternal.lobby_id = function (arg_8_0)
	-- function 8
	return SteamGameServerLobby.game_session_host(arg_8_0)
end

GameServerInternal.server_browser = function ()
	-- function 9
	return GameServerInternal._browser_wrapper
end

GameServerInternal.clear_filter_requirements = function ()
	-- function 10
	GameServerInternal._browser_wrapper:clear_filters()
end

GameServerInternal.add_filter_requirements = function (arg_11_0)
	-- function 11
	local _browser_wrapper = GameServerInternal._browser_wrapper

	_browser_wrapper:clear_filters()
	_browser_wrapper:add_filters(arg_11_0)
end

GameServerInternal.forget_server_browser = function ()
	-- function 12
	if not GameServerInternal._browser_wrapper then
		GameServerInternal._browser_wrapper:destroy()

		GameServerInternal._browser_wrapper = nil
	end
end

GameServerInternal.create_server_browser_wrapper = function ()
	-- function 13
	fassert(GameServerInternal._browser_wrapper == nil, "Already has server browser wrapper")

	GameServerInternal._browser_wrapper = SteamServerBrowserWrapper:new()

	return GameServerInternal._browser_wrapper
end

SteamServerBrowserWrapper = class(SteamServerBrowserWrapper)
SteamServerBrowserWrapper.compare_funcs = {
	equal = function (arg_14_0, arg_14_1)
		-- function 14
		return arg_14_0 == tostring(arg_14_1)
	end,
	not_equal = function (arg_15_0, arg_15_1)
		-- function 15
		return arg_15_0 ~= tostring(arg_15_1)
	end,
	less = function (arg_16_0, arg_16_1)
		-- function 16
		return arg_16_1 > tonumber(arg_16_0)
	end,
	less_or_equal = function (arg_17_0, arg_17_1)
		-- function 17
		return arg_17_1 >= tonumber(arg_17_0)
	end,
	greater = function (arg_18_0, arg_18_1)
		-- function 18
		return arg_18_1 < tonumber(arg_18_0)
	end,
	greater_or_equal = function (arg_19_0, arg_19_1)
		-- function 19
		return arg_19_1 <= tonumber(arg_19_0)
	end
}
SteamServerBrowserWrapper.compare_func_names = {
	greater_or_equal = ">=",
	less_or_equal = "<=",
	greater = ">",
	less = "<",
	equal = "==",
	not_equal = "~="
}

SteamServerBrowserWrapper.init = function (self)
	-- function 20
	self._engine_browser = LobbyInternal.client:create_server_browser()
	self._cached_servers = {}
	self._filters = {}
	self._search_type = "internet"
	self._state = "waiting"
end

SteamServerBrowserWrapper.destroy = function (self)
	-- function 21
	LobbyInternal.client:destroy_server_browser(self._engine_browser)
end

SteamServerBrowserWrapper.servers = function (self)
	-- function 22
	return self._cached_servers
end

SteamServerBrowserWrapper.is_refreshing = function (self)
	-- function 23
	local _state = self._state

	return _state == "refreshing" or _state == "fetching_data"
end

SteamServerBrowserWrapper.refresh = function (self)
	-- function 24
	if not SteamServerBrowser.is_refreshing(self._engine_browser) then
		SteamServerBrowser.abort_refresh(self._engine_browser)
	end

	SteamServerBrowser.refresh(self._engine_browser, self._search_type)

	self._state = "refreshing"
end

SteamServerBrowserWrapper.set_search_type = function (self, arg_25_1)
	-- function 25
	self._search_type = arg_25_1
end

SteamServerBrowserWrapper.add_to_favorites = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	SteamServerBrowser.add_favorite(self._engine_browser, arg_26_1, arg_26_2, arg_26_3)
end

SteamServerBrowserWrapper.remove_from_favorites = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	SteamServerBrowser.remove_favorite(self._engine_browser, arg_27_1, arg_27_2, arg_27_3)
end

SteamServerBrowserWrapper.clear_filters = function (self)
	-- function 28
	SteamServerBrowser.clear_filters(self._engine_browser)
	table.clear(self._filters)
end

SteamServerBrowserWrapper.add_filters = function (self, arg_29_1)
	-- function 29
	local server_browser_filters = arg_29_1.server_browser_filters

	for k, v in pairs(server_browser_filters) do
		SteamServerBrowser.add_filter(self._engine_browser, k, v)
		mm_printf("Adding server filter: key(%s) value=%s", k, v)
	end

	local matchmaking_filters = arg_29_1.matchmaking_filters

	for k_2, v_2 in pairs(matchmaking_filters) do
		local value = v_2.value
		local comparison = v_2.comparison
		local var_29_4 = SteamServerBrowserWrapper.compare_funcs[comparison]

		fassert(var_29_4, "Compare func does not exist for comparison(%s)", comparison)

		local var_29_5 = SteamServerBrowserWrapper.compare_func_names[comparison]

		self._filters[k_2] = {
			value = value,
			compare_name = var_29_5,
			compare_func = var_29_4
		}

		mm_printf("Server Filter: %s, comparison(%s), value=%s", tostring(k_2), tostring(comparison), tostring(value))
	end
end

SteamServerBrowserWrapper.update = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _state = self._state

	if _state == "refreshing" then
		if not SteamServerBrowser.is_refreshing(self._engine_browser) then
			local num_servers = SteamServerBrowser.num_servers(self._engine_browser)

			for i = 0, num_servers - 1 do
				SteamServerBrowser.request_data(self._engine_browser, i)
			end

			self._state = "fetching_data"
		end
	elseif _state == "fetching_data" then
		local flag = false
		local num_servers_2 = SteamServerBrowser.num_servers(self._engine_browser)

		for j = 0, num_servers_2 - 1 do
			local is_fetching_data, var_30_5 = SteamServerBrowser.is_fetching_data(self._engine_browser, j)

			if not is_fetching_data then
				flag = true

				break
			end
		end

		if not flag then
			local _cached_servers = self._cached_servers

			table.clear(_cached_servers)

			for k = 0, num_servers_2 - 1 do
				local server = SteamServerBrowser.server(self._engine_browser, k)

				server.ip_port = server.ip_address .. ":" .. server.query_port

				local data_all = SteamServerBrowser.data_all(self._engine_browser, k)

				data_all.server_info = server

				if not self:_filter_server(data_all) then
					_cached_servers[#_cached_servers + 1] = data_all
				end
			end

			self._state = "waiting"
		end
	end

	if self._state ~= _state then
		printf("[SteamServerBrowserWrapper] Switched state from (%s) to (%s)", _state, self._state)
	end
end

SteamServerBrowserWrapper._filter_server = function (self, arg_31_1)
	-- function 31
	local _filters = self._filters

	for k, v in pairs(_filters) do
		local var_31_1 = arg_31_1[k]

		if not var_31_1 then
			printf("[SteamServerBrowserWrapper] Could not find value for server (%s)", k)

			return false
		else
			printf("[SteamServerBrowserWrapper] Found value %s, %s from server", tostring(var_31_1), k)
		end

		local value = v.value
		local compare_func = v.compare_func
		local compare_name = v.compare_name

		if not compare_func(var_31_1, value) then
			printf("[SteamServerBrowserWrapper] Server failed on filter %s, server_value(%s) %s compare_value=(%s)", k, var_31_1, compare_name, value)

			return false
		end
	end

	return true
end
