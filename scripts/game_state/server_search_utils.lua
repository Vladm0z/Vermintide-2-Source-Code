-- chunkname: @scripts/game_state/server_search_utils.lua

ServerSearchUtils = {}

ServerSearchUtils.trigger_game_server_finder_search = function (search_type, network_options, num_players, filters)
	-- function 1
	print("Attempting " .. search_type .. " search for game server")

	local finder = GameServerFinder:new(network_options)

	finder:set_search_type(search_type)

	local game_server_requirements = {
		free_slots = num_players,
		server_browser_filters = {
			dedicated = "valuenotused",
			full = "valuenotused",
			gamedir = Managers.mechanism:server_universe()
		},
		matchmaking_filters = {}
	}

	table.merge_recursive(game_server_requirements, filters)

	local skip_verify_lobby_data = true

	finder:add_filter_requirements(game_server_requirements, skip_verify_lobby_data)
	finder:refresh()

	return finder
end

ServerSearchUtils.trigger_lobby_finder_search = function (network_options, num_players, filters)
	-- function 2
	local requirements = {
		distance_filter = "world",
		free_slots = num_players,
		filters = {},
		near_filters = {}
	}

	table.merge_recursive(requirements, filters)

	local skip_verify_lobby_data = true
	local finder = LobbyFinder:new(network_options, nil, true)

	finder:add_filter_requirements(requirements, skip_verify_lobby_data)
	finder:refresh()

	return finder
end

ServerSearchUtils.filter_game_server_search = function (servers, network_options, soft_filters, network_hash, black_listed_servers, search_time)
	-- function 3
	table.array_remove_if(servers, function (server)
		-- function 4
		local ignore_network_hash = Development.parameter("force_ignore_network_hash")

		if not ignore_network_hash then
			local wrong_version = server.network_hash ~= network_hash

			if wrong_version then
				printf("Removing server %s with wrong version %s", server.server_info.ip_port, server.network_hash)

				server.matching_fail = "wrong network hash"
			end

			return wrong_version
		end
	end)
	table.array_remove_if(servers, function (server)
		-- function 5
		if not script_data.blacklisting_disabled_vs then
			local blacklisted = black_listed_servers[server.server_info.ip_port] ~= nil

			if blacklisted then
				printf("Removing black listed server %s", server.server_info.ip_port)

				server.matching_fail = "blacklisted"
			end

			return blacklisted
		end
	end)
	table.array_remove_if(servers, function (server)
		-- function 6
		local has_password = server.server_info.password

		if has_password then
			printf("Removing password protected server %s", server.ip_port)

			server.matching_fail = "password protected"
		end

		return has_password
	end)
	table.array_remove_if(servers, function (server)
		-- function 7
		return not server.game_state
	end)
	table.array_remove_if(servers, function (server)
		-- function 8
		return server.game_state == "dedicated_server_abort_game"
	end)

	if soft_filters.hotjoin_disabled_game_states then
		table.array_remove_if(servers, function (server)
			-- function 9
			local allowed_states = Managers.state.game_mode:setting("allowed_hotjoin_states")

			if allowed_states[server.game_state] then
				return false
			end

			return true
		end)
	end

	if soft_filters.filter_fully_reserved_servers then
		table.array_remove_if(servers, function (server)
			-- function 10
			local server_info = server.server_info

			if not server_info then
				return false
			end

			local match_started = server.match_started

			if match_started ~= "true" then
				return false
			end

			local num_players_2 = server_info.num_players

			if not num_players_2 then
				-- Nothing
			end

			num_players_2 = 0

			local num_players = num_players_2

			::label_10_0::

			local max_players_2 = server_info.max_players

			if not max_players_2 then
				-- Nothing
			end

			max_players_2 = 1

			local max_players = max_players_2

			::label_10_1::

			return max_players <= num_players
		end)
	end

	local official_dedicated_server_lookup = tostring(NetworkLookup.host_types.official_dedicated_server)

	table.array_remove_if(servers, function (server)
		-- function 11
		return server.host_type == official_dedicated_server_lookup
	end)
	table.array_remove_if(servers, function (server)
		-- function 12
		local ping_2 = server.server_info.ping

		if not ping_2 then
			-- Nothing
		end

		ping_2 = math.huge

		local ping = ping_2

		::label_12_0::

		if search_time >= 300 then
			return false
		end

		if search_time >= 240 then
			return ping >= 250
		end

		if search_time >= 180 then
			return ping >= 200
		end

		if search_time >= 120 then
			return ping >= 160
		end

		if search_time >= 60 then
			return ping >= 120
		end

		return ping >= 100
	end)

	return servers
end
