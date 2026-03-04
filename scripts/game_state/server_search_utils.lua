-- chunkname: @scripts/game_state/server_search_utils.lua

ServerSearchUtils = {}

function ServerSearchUtils.trigger_game_server_finder_search(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	print("Attempting " .. arg_1_0 .. " search for game server")

	local var_1_0 = GameServerFinder:new(arg_1_1)

	var_1_0:set_search_type(arg_1_0)

	local var_1_1 = {
		free_slots = arg_1_2,
		server_browser_filters = {
			dedicated = "valuenotused",
			full = "valuenotused",
			gamedir = Managers.mechanism:server_universe()
		},
		matchmaking_filters = {}
	}

	table.merge_recursive(var_1_1, arg_1_3)

	local var_1_2 = true

	var_1_0:add_filter_requirements(var_1_1, var_1_2)
	var_1_0:refresh()

	return var_1_0
end

function ServerSearchUtils.trigger_lobby_finder_search(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = {
		distance_filter = "world",
		free_slots = arg_2_1,
		filters = {},
		near_filters = {}
	}

	table.merge_recursive(var_2_0, arg_2_2)

	local var_2_1 = true
	local var_2_2 = LobbyFinder:new(arg_2_0, nil, true)

	var_2_2:add_filter_requirements(var_2_0, var_2_1)
	var_2_2:refresh()

	return var_2_2
end

function ServerSearchUtils.filter_game_server_search(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	table.array_remove_if(arg_3_0, function(arg_4_0)
		if not Development.parameter("force_ignore_network_hash") then
			local var_4_0 = arg_4_0.network_hash ~= arg_3_3

			if var_4_0 then
				printf("Removing server %s with wrong version %s", arg_4_0.server_info.ip_port, arg_4_0.network_hash)

				arg_4_0.matching_fail = "wrong network hash"
			end

			return var_4_0
		end
	end)
	table.array_remove_if(arg_3_0, function(arg_5_0)
		if not script_data.blacklisting_disabled_vs then
			local var_5_0 = arg_3_4[arg_5_0.server_info.ip_port] ~= nil

			if var_5_0 then
				printf("Removing black listed server %s", arg_5_0.server_info.ip_port)

				arg_5_0.matching_fail = "blacklisted"
			end

			return var_5_0
		end
	end)
	table.array_remove_if(arg_3_0, function(arg_6_0)
		local var_6_0 = arg_6_0.server_info.password

		if var_6_0 then
			printf("Removing password protected server %s", arg_6_0.ip_port)

			arg_6_0.matching_fail = "password protected"
		end

		return var_6_0
	end)
	table.array_remove_if(arg_3_0, function(arg_7_0)
		return not arg_7_0.game_state
	end)
	table.array_remove_if(arg_3_0, function(arg_8_0)
		return arg_8_0.game_state == "dedicated_server_abort_game"
	end)

	if arg_3_2.hotjoin_disabled_game_states then
		table.array_remove_if(arg_3_0, function(arg_9_0)
			if Managers.state.game_mode:setting("allowed_hotjoin_states")[arg_9_0.game_state] then
				return false
			end

			return true
		end)
	end

	if arg_3_2.filter_fully_reserved_servers then
		table.array_remove_if(arg_3_0, function(arg_10_0)
			local var_10_0 = arg_10_0.server_info

			if not var_10_0 then
				return false
			end

			if arg_10_0.match_started ~= "true" then
				return false
			end

			return (var_10_0.num_players or 0) >= (var_10_0.max_players or 1)
		end)
	end

	local var_3_0 = tostring(NetworkLookup.host_types.official_dedicated_server)

	table.array_remove_if(arg_3_0, function(arg_11_0)
		return arg_11_0.host_type == var_3_0
	end)
	table.array_remove_if(arg_3_0, function(arg_12_0)
		local var_12_0 = arg_12_0.server_info.ping or math.huge

		if arg_3_5 >= 300 then
			return false
		end

		if arg_3_5 >= 240 then
			return var_12_0 >= 250
		end

		if arg_3_5 >= 180 then
			return var_12_0 >= 200
		end

		if arg_3_5 >= 120 then
			return var_12_0 >= 160
		end

		if arg_3_5 >= 60 then
			return var_12_0 >= 120
		end

		return var_12_0 >= 100
	end)

	return arg_3_0
end
