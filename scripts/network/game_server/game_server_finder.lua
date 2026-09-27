-- chunkname: @scripts/network/game_server/game_server_finder.lua

GameServerFinder = class(GameServerFinder)

local num = 10

GameServerFinder.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local config_file_name = arg_1_1.config_file_name
	local project_hash = arg_1_1.project_hash

	self._network_hash = GameServerAux.create_network_hash(config_file_name, project_hash)
	self._cached_servers = {}
	self._pending_refresh_request = false

	local server_browser = GameServerInternal.server_browser()

	server_browser = server_browser or GameServerInternal.create_server_browser_wrapper()
	self._browser_wrapper = server_browser
end

GameServerFinder.destroy = function (arg_2_0)
	-- function 2
	GameServerInternal.forget_server_browser()
end

GameServerFinder.refresh = function (self)
	-- function 3
	self._browser_wrapper:refresh()

	self._pending_refresh_request = true

	table.clear(self._cached_servers)
end

GameServerFinder.set_search_type = function (self, arg_4_1)
	-- function 4
	self._browser_wrapper:set_search_type(arg_4_1)
end

GameServerFinder.add_to_favorites = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	self._browser_wrapper:add_to_favorites(arg_5_1, arg_5_2, arg_5_3)
end

GameServerFinder.remove_from_favorites = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	self._browser_wrapper:remove_from_favorites(arg_6_1, arg_6_2, arg_6_3)
end

GameServerFinder.add_filter_requirements = function (self, arg_7_1, arg_7_2)
	-- function 7
	GameServerInternal.add_filter_requirements(arg_7_1)

	self._skip_verify_lobby_data = arg_7_2
end

GameServerFinder.servers = function (self)
	-- function 8
	return self._cached_servers
end

GameServerFinder.is_refreshing = function (self)
	-- function 9
	return self._pending_refresh_request
end

GameServerFinder.update = function (self, arg_10_1)
	-- function 10
	local _browser_wrapper = self._browser_wrapper

	_browser_wrapper:update(arg_10_1)

	local is_refreshing = _browser_wrapper:is_refreshing()

	if not (not self._pending_refresh_request and is_refreshing) then
		local _cached_servers = self._cached_servers
		local servers = _browser_wrapper:servers()

		for i, v in ipairs(servers) do
			if self._skip_verify_lobby_data or not GameServerAux.verify_lobby_data(v) then
				v.valid = true
				_cached_servers[#_cached_servers + 1] = v
			end
		end

		self._pending_refresh_request = false
	end
end
