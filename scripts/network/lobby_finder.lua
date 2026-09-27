-- chunkname: @scripts/network/lobby_finder.lua

require("scripts/network/lobby_aux")

LobbyFinder = class(LobbyFinder)

if not (not script_data.verbose_lobby_finder and print) then
	local NOP = NOP
end

local printf

if not script_data.verbose_lobby_finder then
	printf = printf

	if not printf then
		-- Nothing
	end
end

printf = NOP

::label_0_0::

LobbyFinder.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local config_file_name = arg_1_1.config_file_name
	local project_hash = arg_1_1.project_hash

	self._network_hash = LobbyAux.create_network_hash(config_file_name, project_hash)
	self._server_port = arg_1_1.server_port

	assert(self._server_port, "Must specify port to LobbyFinder.")

	self._cached_lobbies = {}
	self._max_num_lobbies = arg_1_2
	self._refreshing = false

	if not IS_XB1 then
		self._browser = LobbyInternal.lobby_browser()
	else
		self._browser = LobbyInternal.client:create_lobby_browser()

		print("===========Lobbyfinder CREATED", self._browser)
	end
end

LobbyFinder.get_lobby_browser = function (self)
	-- function 2
	return self._browser
end

LobbyFinder.destroy = function (self)
	-- function 3
	if not IS_XB1 then
		LobbyInternal.client.destroy_lobby_browser(LobbyInternal.client, self._browser)
		print("===========Lobbyfinder DESTROYED", self._browser)
	end
end

LobbyFinder.add_filter_requirements = function (self, arg_4_1, arg_4_2)
	-- function 4
	LobbyInternal.add_filter_requirements(arg_4_1, self._browser)

	if not arg_4_2 then
		printf("===========LobbyFinder:add_filter_requirements force refresh")
		self:refresh()
	end

	table.clear(self._cached_lobbies)
end

LobbyFinder.network_hash = function (self)
	-- function 5
	return self._network_hash
end

LobbyFinder.lobbies = function (self)
	-- function 6
	return self._cached_lobbies
end

LobbyFinder.latest_filter_lobbies = function (arg_7_0)
	-- function 7
	print("[LobbyFinder]:latest_filter_lobbies is deprecated")
end

LobbyFinder.refresh = function (self)
	-- function 8
	printf("===========LobbyFinder:refresh() _refresing=%s", self._refreshing)

	if not self._refreshing then
		self._browser:refresh(self._server_port)

		self._refreshing = true
	end
end

LobbyFinder.is_refreshing = function (self)
	-- function 9
	return self._refreshing
end

LobbyFinder.update = function (self, arg_10_1)
	-- function 10
	if not self._refreshing then
		local _browser = self._browser

		if not _browser:is_refreshing() then
			local _cached_lobbies = self._cached_lobbies

			table.clear_array(_cached_lobbies)

			local num_lobbies = _browser:num_lobbies()
			local _max_num_lobbies = self._max_num_lobbies

			if not _max_num_lobbies then
				num_lobbies = math.min(_max_num_lobbies, num_lobbies)
			end

			printf("===========Lobbyfinder REFRESHING num_lobbies: %s", num_lobbies)

			for i = 0, num_lobbies - 1 do
				local get_lobby = LobbyInternal.get_lobby(_browser, i)

				if get_lobby.network_hash ~= self._network_hash or not LobbyAux.verify_lobby_data(get_lobby) then
					_cached_lobbies[#_cached_lobbies + 1] = get_lobby
					get_lobby.valid = true

					printf("=======================Found valid lobby!")
				end
			end

			self._cached_lobbies = _cached_lobbies
			self._refreshing = false
		end
	end
end
