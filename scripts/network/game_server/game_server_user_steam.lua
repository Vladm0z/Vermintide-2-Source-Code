-- chunkname: @scripts/network/game_server/game_server_user_steam.lua

require("scripts/network/game_server/game_server_aux")

local GameServerInternal = GameServerInternal

GameServerInternal = not not GameServerInternal or not not {}
GameServerInternal = GameServerInternal
GameServerInternal.lobby_data_version = 2

GameServerInternal.join_server = function (game_server_info, password)
	-- function 1
	local ip_address = game_server_info.ip_port
	local use_eac = true
	local invitee = game_server_info.invitee
	local game_server_lobby

	if invitee then
		game_server_lobby = Network.join_steam_server(use_eac, ip_address, password, invitee)
	else
		game_server_lobby = Network.join_steam_server(use_eac, ip_address, password)
	end

	SteamGameServerLobby.auto_update_data(game_server_lobby)

	return game_server_lobby
end

GameServerInternal.reserve_server = function (game_server_info, password, reserve_peers)
	-- function 2
	local ip_address = game_server_info.ip_port
	local use_eac = true
	local game_server_lobby = Network.reserve_steam_server(use_eac, reserve_peers, ip_address, password)

	SteamGameServerLobby.auto_update_data(game_server_lobby)

	return game_server_lobby
end

GameServerInternal.claim_reserved = function (game_server_lobby)
	-- function 3
	SteamGameServerLobby.join(game_server_lobby)
end

if not DEDICATED_SERVER then
	GameServerInternal.open_channel = function (lobby, peer)
		-- function 4
		local channel_id = SteamGameServerLobby.open_channel(lobby, peer)

		printf("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", lobby, peer, channel_id)

		return channel_id
	end

	GameServerInternal.close_channel = function (lobby, channel)
		-- function 5
		printf("LobbyInternal.close_channel lobby: %s, channel: %s", lobby, channel)
		SteamGameServerLobby.close_channel(lobby, channel)
	end
end

GameServerInternal.leave_server = function (game_server_lobby)
	-- function 6
	Network.leave_steam_server(game_server_lobby)
end

GameServerInternal.lobby_host = function (game_server_lobby)
	-- function 7
	return SteamGameServerLobby.game_session_host(game_server_lobby)
end

GameServerInternal.lobby_id = function (game_server_lobby)
	-- function 8
	return SteamGameServerLobby.game_session_host(game_server_lobby)
end

GameServerInternal.server_browser = function ()
	-- function 9
	return GameServerInternal._browser_wrapper
end

GameServerInternal.clear_filter_requirements = function ()
	-- function 10
	local browser_wrapper = GameServerInternal._browser_wrapper

	browser_wrapper:clear_filters()
end

GameServerInternal.add_filter_requirements = function (requirements)
	-- function 11
	local browser_wrapper = GameServerInternal._browser_wrapper

	browser_wrapper:clear_filters()
	browser_wrapper:add_filters(requirements)
end

GameServerInternal.forget_server_browser = function ()
	-- function 12
	if GameServerInternal._browser_wrapper then
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
	equal = function (lhv, rhv)
		-- function 14
		return lhv == tostring(rhv)
	end,
	not_equal = function (lhv, rhv)
		-- function 15
		return lhv ~= tostring(rhv)
	end,
	less = function (lhv, rhv)
		-- function 16
		return rhv > tonumber(lhv)
	end,
	less_or_equal = function (lhv, rhv)
		-- function 17
		return rhv >= tonumber(lhv)
	end,
	greater = function (lhv, rhv)
		-- function 18
		return rhv < tonumber(lhv)
	end,
	greater_or_equal = function (lhv, rhv)
		-- function 19
		return rhv <= tonumber(lhv)
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
	local state = self._state

	return state == "refreshing" or state == "fetching_data"
end

SteamServerBrowserWrapper.refresh = function (self)
	-- function 24
	if SteamServerBrowser.is_refreshing(self._engine_browser) then
		SteamServerBrowser.abort_refresh(self._engine_browser)
	end

	SteamServerBrowser.refresh(self._engine_browser, self._search_type)

	self._state = "refreshing"
end

SteamServerBrowserWrapper.set_search_type = function (self, search_type)
	-- function 25
	self._search_type = search_type
end

SteamServerBrowserWrapper.add_to_favorites = function (self, ip, connection_port, query_port)
	-- function 26
	SteamServerBrowser.add_favorite(self._engine_browser, ip, connection_port, query_port)
end

SteamServerBrowserWrapper.remove_from_favorites = function (self, ip, connection_port, query_port)
	-- function 27
	SteamServerBrowser.remove_favorite(self._engine_browser, ip, connection_port, query_port)
end

SteamServerBrowserWrapper.clear_filters = function (self)
	-- function 28
	SteamServerBrowser.clear_filters(self._engine_browser)
	table.clear(self._filters)
end

SteamServerBrowserWrapper.add_filters = function (self, filters)
	-- function 29
	local server_browser_filters = filters.server_browser_filters

	for key, value in pairs(server_browser_filters) do
		SteamServerBrowser.add_filter(self._engine_browser, key, value)
		mm_printf("Adding server filter: key(%s) value=%s", key, value)
	end

	local matchmaking_filters = filters.matchmaking_filters

	for data_name, filter in pairs(matchmaking_filters) do
		local value = filter.value
		local comparison = filter.comparison
		local compare_func = SteamServerBrowserWrapper.compare_funcs[comparison]

		fassert(compare_func, "Compare func does not exist for comparison(%s)", comparison)

		local compare_name = SteamServerBrowserWrapper.compare_func_names[comparison]

		self._filters[data_name] = {
			value = value,
			compare_name = compare_name,
			compare_func = compare_func
		}

		mm_printf("Server Filter: %s, comparison(%s), value=%s", tostring(data_name), tostring(comparison), tostring(value))
	end
end

SteamServerBrowserWrapper.update = function (self, dt, t)
	-- function 30
	local state = self._state

	if state == "refreshing" then
		if not SteamServerBrowser.is_refreshing(self._engine_browser) then
			local num_servers = SteamServerBrowser.num_servers(self._engine_browser)

			for i = 0, num_servers - 1 do
				SteamServerBrowser.request_data(self._engine_browser, i)
			end

			self._state = "fetching_data"
		end
	elseif state == "fetching_data" then
		local is_fetching = false
		local num_servers = SteamServerBrowser.num_servers(self._engine_browser)

		for i = 0, num_servers - 1 do
			local is_fetching_data, fetch_error = SteamServerBrowser.is_fetching_data(self._engine_browser, i)

			if is_fetching_data then
				is_fetching = true

				break
			end
		end

		if not is_fetching then
			local cached_servers = self._cached_servers

			table.clear(cached_servers)

			for i = 0, num_servers - 1 do
				local server = SteamServerBrowser.server(self._engine_browser, i)

				server.ip_port = server.ip_address .. ":" .. server.query_port

				local lobby_data = SteamServerBrowser.data_all(self._engine_browser, i)

				lobby_data.server_info = server

				if self:_filter_server(lobby_data) then
					cached_servers[#cached_servers + 1] = lobby_data
				end
			end

			self._state = "waiting"
		end
	end

	if self._state ~= state then
		printf("[SteamServerBrowserWrapper] Switched state from (%s) to (%s)", state, self._state)
	end
end

SteamServerBrowserWrapper._filter_server = function (self, server_data)
	-- function 31
	local filters = self._filters

	for data_name, filter in pairs(filters) do
		local server_value = server_data[data_name]

		if not server_value then
			printf("[SteamServerBrowserWrapper] Could not find value for server (%s)", data_name)

			return false
		else
			printf("[SteamServerBrowserWrapper] Found value %s, %s from server", tostring(server_value), data_name)
		end

		local compare_value = filter.value
		local compare_func = filter.compare_func
		local compare_name = filter.compare_name

		if not compare_func(server_value, compare_value) then
			printf("[SteamServerBrowserWrapper] Server failed on filter %s, server_value(%s) %s compare_value=(%s)", data_name, server_value, compare_name, compare_value)

			return false
		end
	end

	return true
end
