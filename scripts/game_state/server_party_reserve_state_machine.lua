-- chunkname: @scripts/game_state/server_party_reserve_state_machine.lua

local var_0_0 = class(FindServerState)

var_0_0.NAME = "FindServerState"

function var_0_0.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	arg_1_0._state_machine = arg_1_1
	arg_1_0._num_players = #arg_1_4
	arg_1_0._network_options = arg_1_2
	arg_1_0._network_hash = arg_1_3
	arg_1_0._optional_order_func = arg_1_7
	arg_1_0._black_listed_servers = arg_1_5
	arg_1_0._filters = arg_1_6
	arg_1_0._search_types = {
		"favorites",
		"internet",
		"lan"
	}
	arg_1_1._search_index = arg_1_1._search_index or 1
	arg_1_1._servers_by_type = arg_1_1._servers_by_type or {}
	arg_1_0._finder = nil
	arg_1_0._delay = 0
	arg_1_0._search_time = 0
	arg_1_0._soft_filters = arg_1_8.soft_filters or {}
end

function var_0_0.enter(arg_2_0)
	return
end

function var_0_0.destroy(arg_3_0)
	if arg_3_0._finder ~= nil then
		arg_3_0._finder:destroy()
	end

	arg_3_0._finder = nil
end

function var_0_0.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._search_time = arg_4_0._search_time + arg_4_1

	if arg_4_2 < arg_4_0._delay then
		return
	end

	local var_4_0 = arg_4_0._state_machine
	local var_4_1 = arg_4_0._search_types[var_4_0._search_index]
	local var_4_2 = var_4_0._servers_by_type[var_4_1] or {}

	if table.is_empty(var_4_2) then
		if arg_4_0._finder == nil then
			arg_4_0._finder = arg_4_0:_trigger_search(var_4_1)
		end

		arg_4_0._finder:update(arg_4_1)

		if arg_4_0._finder:is_refreshing() then
			return
		end

		local var_4_3 = arg_4_0._finder:servers()

		ServerSearchUtils.filter_game_server_search(var_4_3, arg_4_0._network_options, arg_4_0._soft_filters, arg_4_0._network_hash, arg_4_0._black_listed_servers, arg_4_0._search_time)

		if arg_4_0._optional_order_func ~= nil then
			table.sort(var_4_3, arg_4_0._optional_order_func)
		end

		var_4_0._servers_by_type[var_4_1] = var_4_3

		arg_4_0._finder:destroy()

		arg_4_0._finder = nil
		var_4_2 = var_4_3
	end

	local var_4_4 = arg_4_0:_pick_server(var_4_1, var_4_2)

	if var_4_4 == nil then
		if var_4_0._search_index >= #arg_4_0._search_types then
			arg_4_0._delay = arg_4_2 + 3
		end

		var_4_0._search_index = math.index_wrapper(var_4_0._search_index + 1, #arg_4_0._search_types)

		return
	else
		return "server_found", var_4_4
	end
end

function var_0_0._pick_server(arg_5_0, arg_5_1)
	print("######### PICKING SERVER #########")

	local var_5_0 = arg_5_0._state_machine
	local var_5_1 = var_5_0._servers_by_type[arg_5_1]

	if #var_5_1 == 0 then
		return nil
	end

	local var_5_2
	local var_5_3 = arg_5_0._optional_order_func ~= nil and 1 or Math.random(#var_5_1)
	local var_5_4 = var_5_1[var_5_3]

	table.remove(var_5_1, var_5_3)

	if table.is_empty(var_5_1) then
		var_5_0._reserve_attempts[arg_5_1] = var_5_0._reserve_attempts[arg_5_1] - 1

		if var_5_0._reserve_attempts[arg_5_1] <= 0 then
			table.clear(var_5_1)
		end
	end

	return var_5_4
end

function var_0_0._trigger_search(arg_6_0, arg_6_1)
	print("Attempting " .. arg_6_1 .. " search for game server")

	local var_6_0 = Development.parameter("use_lan_backend") or rawget(_G, "Steam") == nil
	local var_6_1 = IS_WINDOWS
	local var_6_2

	if var_6_0 or not var_6_1 then
		var_6_2 = GameServerFinderLan:new(arg_6_0._network_options)
	else
		var_6_2 = GameServerFinder:new(arg_6_0._network_options)
	end

	var_6_2:set_search_type(arg_6_1)

	local var_6_3 = {
		free_slots = arg_6_0._num_players,
		server_browser_filters = {
			dedicated = "valuenotused",
			notfull = "valuenotused",
			gamedir = Managers.mechanism:server_universe()
		},
		matchmaking_filters = {}
	}

	table.merge_recursive(var_6_3, arg_6_0._filters)

	local var_6_4 = true

	var_6_2:add_filter_requirements(var_6_3, var_6_4)
	var_6_2:refresh()

	return var_6_2
end

local var_0_1 = class(ServerReserveState)

var_0_1.NAME = "ServerReserveState"

function var_0_1.init(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	arg_7_0._network_options = arg_7_2
	arg_7_0._peers_to_reserve = arg_7_4
	arg_7_0._state_machine = arg_7_1
end

function var_0_1.enter(arg_8_0, arg_8_1)
	print("Attempt reserving slots on " .. arg_8_1.server_info.ip_port)

	local var_8_0

	arg_8_0._lobby_data = arg_8_1
	arg_8_0._lobby = GameServerLobbyClient:new(arg_8_0._network_options, arg_8_1, var_8_0, arg_8_0._peers_to_reserve)
	arg_8_0._state_machine._lobby = arg_8_0._lobby
end

function var_0_1.update(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._lobby

	var_9_0:update(arg_9_1)

	local var_9_1 = var_9_0:state()

	if var_9_1 == "reserved" then
		return "reserve_success", var_9_0, arg_9_0._lobby_data
	end

	if var_9_1 == "failed" then
		return "reserve_failed"
	end
end

local var_0_2 = class(SuccessState)

var_0_2.NAME = "SuccessState"

function var_0_2.init(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	arg_10_0._state_machine = arg_10_1
end

function var_0_2.enter(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._state_machine._result = "reserved"
	arg_11_0._state_machine._lobby_data = arg_11_2
end

local var_0_3 = class(FailState)

var_0_3.NAME = "FailState"

function var_0_3.init(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	arg_12_1._result = "failed"
end

ServerPartyReserveStateMachine = class(ServerPartyReserveStateMachine, VisualStateMachine)

function ServerPartyReserveStateMachine.init(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0
	local var_13_1 = arg_13_1.config_file_name
	local var_13_2 = arg_13_1.project_hash
	local var_13_3 = LobbyAux.create_network_hash(var_13_1, var_13_2)

	arg_13_0.super.init(arg_13_0, "ServerPartyReserveStateMachine", var_13_0, arg_13_1, var_13_3, arg_13_2, arg_13_4 or {}, arg_13_5 or {}, arg_13_3, arg_13_6 or {})

	arg_13_0._has_result = false
	arg_13_0._user_data = arg_13_6
	arg_13_0._result = nil
	arg_13_0._lobby = nil
	arg_13_0._lobby_data = nil
	arg_13_0._reserve_attempts = {
		internet = 5,
		favorites = 5,
		lan = 5
	}
	arg_13_0._servers = {}

	arg_13_0:add_transition("FindServerState", "server_found", var_0_1)
	arg_13_0:add_transition("FindServerState", "server_not_found", var_0_3)
	arg_13_0:add_transition("ServerReserveState", "reserve_success", var_0_2)
	arg_13_0:add_transition("ServerReserveState", "reserve_failed", var_0_0)
	arg_13_0:set_initial_state(var_0_0)
end

function ServerPartyReserveStateMachine.destroy(arg_14_0)
	if arg_14_0._lobby then
		arg_14_0._lobby:destroy()

		arg_14_0._lobby = nil
	end

	arg_14_0.super.destroy(arg_14_0)
end

function ServerPartyReserveStateMachine.result(arg_15_0)
	if arg_15_0._result == nil then
		return
	end

	local var_15_0 = arg_15_0._lobby

	arg_15_0._lobby = nil

	return arg_15_0._result, var_15_0, arg_15_0._lobby_data, arg_15_0._user_data
end
