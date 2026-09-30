-- chunkname: @scripts/network/game_server/game_server_finder.lua

GameServerFinder = class(GameServerFinder)

local SECONDS_BETWEEN_REFRESHES = 10

GameServerFinder.init = function (self, network_options, max_num_servers)
	-- function 1
	local config_file_name = network_options.config_file_name
	local project_hash = network_options.project_hash

	self._network_hash = GameServerAux.create_network_hash(config_file_name, project_hash)
	self._cached_servers = {}
	self._pending_refresh_request = false
	self._browser_wrapper = GameServerInternal.server_browser()
end

GameServerFinder.destroy = function (self)
	-- function 2
	GameServerInternal.forget_server_browser()
end

GameServerFinder.refresh = function (self)
	-- function 3
	self._browser_wrapper:refresh()

	self._pending_refresh_request = true

	table.clear(self._cached_servers)
end

GameServerFinder.set_search_type = function (self, search_type)
	-- function 4
	self._browser_wrapper:set_search_type(search_type)
end

GameServerFinder.add_to_favorites = function (self, ip, connection_port, query_port)
	-- function 5
	self._browser_wrapper:add_to_favorites(ip, connection_port, query_port)
end

GameServerFinder.remove_from_favorites = function (self, ip, connection_port, query_port)
	-- function 6
	self._browser_wrapper:remove_from_favorites(ip, connection_port, query_port)
end

GameServerFinder.add_filter_requirements = function (self, requirements, skip_verify_lobby_data)
	-- function 7
	GameServerInternal.add_filter_requirements(requirements)

	self._skip_verify_lobby_data = skip_verify_lobby_data
end

GameServerFinder.servers = function (self)
	-- function 8
	return self._cached_servers
end

GameServerFinder.is_refreshing = function (self)
	-- function 9
	return self._pending_refresh_request
end

GameServerFinder.update = function (self, dt)
	-- function 10
	local browser_wrapper = self._browser_wrapper

	browser_wrapper:update(dt)

	local is_refreshing = browser_wrapper:is_refreshing()

	if self._pending_refresh_request and not is_refreshing then
		local cached_server = self._cached_servers
		local servers = browser_wrapper:servers()

		for _, server in ipairs(servers) do
			if self._skip_verify_lobby_data or GameServerAux.verify_lobby_data(server) then
				server.valid = true
				cached_server[#cached_server + 1] = server
			end
		end

		self._pending_refresh_request = false
	end
end
