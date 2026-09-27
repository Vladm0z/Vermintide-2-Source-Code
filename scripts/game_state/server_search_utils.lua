-- chunkname: @scripts/game_state/server_search_utils.lua

ServerSearchUtils = {}

ServerSearchUtils.trigger_game_server_finder_search = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	print("Attempting " .. arg_1_0 .. " search for game server")

	local var_1_0 = GameServerFinder:new(arg_1_1)

	var_1_0:set_search_type(arg_1_0)

	local tbl = {
		free_slots = arg_1_2,
		server_browser_filters = {
			dedicated = "valuenotused",
			full = "valuenotused",
			gamedir = Managers.mechanism:server_universe()
		},
		matchmaking_filters = {}
	}

	table.merge_recursive(tbl, arg_1_3)

	local flag = true

	var_1_0:add_filter_requirements(tbl, flag)
	var_1_0:refresh()

	return var_1_0
end

ServerSearchUtils.trigger_lobby_finder_search = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local tbl = {
		distance_filter = "world",
		free_slots = arg_2_1,
		filters = {},
		near_filters = {}
	}

	table.merge_recursive(tbl, arg_2_2)

	local flag = true
	local var_2_2 = LobbyFinder:new(arg_2_0, nil, true)

	var_2_2:add_filter_requirements(tbl, flag)
	var_2_2:refresh()

	return var_2_2
end

ServerSearchUtils.filter_game_server_search = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	table.array_remove_if(arg_3_0, function (self)
		-- function 4
		if not Development.parameter("force_ignore_network_hash") then
			local flag = self.network_hash ~= arg_3_3

			if not flag then
				printf("Removing server %s with wrong version %s", self.server_info.ip_port, self.network_hash)

				self.matching_fail = "wrong network hash"
			end

			return flag
		end
	end)
	table.array_remove_if(arg_3_0, function (self)
		-- function 5
		if not script_data.blacklisting_disabled_vs then
			local flag = arg_3_4[self.server_info.ip_port] ~= nil

			if not flag then
				printf("Removing black listed server %s", self.server_info.ip_port)

				self.matching_fail = "blacklisted"
			end

			return flag
		end
	end)
	table.array_remove_if(arg_3_0, function (self)
		-- function 6
		local password = self.server_info.password

		if not password then
			printf("Removing password protected server %s", self.ip_port)

			self.matching_fail = "password protected"
		end

		return password
	end)
	table.array_remove_if(arg_3_0, function (self)
		-- function 7
		return not self.game_state
	end)
	table.array_remove_if(arg_3_0, function (self)
		-- function 8
		return self.game_state == "dedicated_server_abort_game"
	end)

	if not arg_3_2.hotjoin_disabled_game_states then
		table.array_remove_if(arg_3_0, function (self)
			-- function 9
			if not Managers.state.game_mode:setting("allowed_hotjoin_states")[self.game_state] then
				return false
			end

			return true
		end)
	end

	if not arg_3_2.filter_fully_reserved_servers then
		table.array_remove_if(arg_3_0, function (self)
			-- function 10
			local server_info = self.server_info

			if not server_info then
				return false
			end

			if self.match_started ~= "true" then
				return false
			end

			local num_players = server_info.num_players

			num_players = num_players or 0

			local max_players = server_info.max_players

			max_players = max_players or 1

			return max_players <= num_players
		end)
	end

	local var_3_0 = tostring(NetworkLookup.host_types.official_dedicated_server)

	table.array_remove_if(arg_3_0, function (self)
		-- function 11
		return self.host_type == var_3_0
	end)
	table.array_remove_if(arg_3_0, function (self)
		-- function 12
		local ping = self.server_info.ping

		ping = ping or math.huge

		if arg_3_5 >= 300 then
			return false
		end

		if arg_3_5 >= 240 then
			return ping >= 250
		end

		if arg_3_5 >= 180 then
			return ping >= 200
		end

		if arg_3_5 >= 120 then
			return ping >= 160
		end

		if arg_3_5 >= 60 then
			return ping >= 120
		end

		return ping >= 100
	end)

	return arg_3_0
end
