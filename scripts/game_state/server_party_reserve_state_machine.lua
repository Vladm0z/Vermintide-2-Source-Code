-- chunkname: @scripts/game_state/server_party_reserve_state_machine.lua

local var_0_0 = class(FindServerState)

var_0_0.NAME = "FindServerState"

var_0_0.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	self._state_machine = arg_1_1
	self._num_players = #arg_1_4
	self._network_options = arg_1_2
	self._network_hash = arg_1_3
	self._optional_order_func = arg_1_7
	self._black_listed_servers = arg_1_5
	self._filters = arg_1_6
	self._search_types = {
		"favorites",
		"internet",
		"lan"
	}

	local _search_index = arg_1_1._search_index

	_search_index = _search_index or 1
	arg_1_1._search_index = _search_index

	local _servers_by_type = arg_1_1._servers_by_type

	_servers_by_type = _servers_by_type or {}
	arg_1_1._servers_by_type = _servers_by_type
	self._finder = nil
	self._delay = 0
	self._search_time = 0

	local soft_filters = arg_1_8.soft_filters

	soft_filters = soft_filters or {}
	self._soft_filters = soft_filters
end

var_0_0.enter = function (arg_2_0)
	-- function 2
	return
end

var_0_0.destroy = function (self)
	-- function 3
	if self._finder ~= nil then
		self._finder:destroy()
	end

	self._finder = nil
end

var_0_0.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._search_time = self._search_time + arg_4_1

	if arg_4_2 < self._delay then
		return
	end

	local _state_machine = self._state_machine
	local var_4_1 = self._search_types[_state_machine._search_index]
	local var_4_2 = _state_machine._servers_by_type[var_4_1]

	var_4_2 = var_4_2 or {}

	if not table.is_empty(var_4_2) then
		if self._finder == nil then
			self._finder = self:_trigger_search(var_4_1)
		end

		self._finder:update(arg_4_1)

		if not self._finder:is_refreshing() then
			return
		end

		local servers = self._finder:servers()

		ServerSearchUtils.filter_game_server_search(servers, self._network_options, self._soft_filters, self._network_hash, self._black_listed_servers, self._search_time)

		if self._optional_order_func ~= nil then
			table.sort(servers, self._optional_order_func)
		end

		_state_machine._servers_by_type[var_4_1] = servers

		self._finder:destroy()

		self._finder = nil
		var_4_2 = servers
	end

	local _pick_server = self:_pick_server(var_4_1, var_4_2)

	if _pick_server == nil then
		if _state_machine._search_index >= #self._search_types then
			self._delay = arg_4_2 + 3
		end

		_state_machine._search_index = math.index_wrapper(_state_machine._search_index + 1, #self._search_types)

		return
	else
		return "server_found", _pick_server
	end
end

var_0_0._pick_server = function (self, arg_5_1)
	-- function 5
	print("######### PICKING SERVER #########")

	local _state_machine = self._state_machine
	local var_5_1 = _state_machine._servers_by_type[arg_5_1]

	if #var_5_1 == 0 then
		return nil
	end

	local var_5_2
	local flag

	flag = self._optional_order_func == nil or not 1 or Math.random(#var_5_1)

	local var_5_4 = var_5_1[flag]

	table.remove(var_5_1, flag)

	if not table.is_empty(var_5_1) then
		_state_machine._reserve_attempts[arg_5_1] = _state_machine._reserve_attempts[arg_5_1] - 1

		if _state_machine._reserve_attempts[arg_5_1] <= 0 then
			table.clear(var_5_1)
		end
	end

	return var_5_4
end

var_0_0._trigger_search = function (self, arg_6_1)
	-- function 6
	print("Attempting " .. arg_6_1 .. " search for game server")

	local parameter = Development.parameter("use_lan_backend")

	parameter = parameter or rawget(_G, "Steam") == nil

	local IS_WINDOWS = IS_WINDOWS
	local var_6_2

	if not (parameter or IS_WINDOWS) then
		var_6_2 = GameServerFinderLan:new(self._network_options)
	else
		var_6_2 = GameServerFinder:new(self._network_options)
	end

	var_6_2:set_search_type(arg_6_1)

	local tbl = {
		free_slots = self._num_players,
		server_browser_filters = {
			dedicated = "valuenotused",
			notfull = "valuenotused",
			gamedir = Managers.mechanism:server_universe()
		},
		matchmaking_filters = {}
	}

	table.merge_recursive(tbl, self._filters)

	local flag = true

	var_6_2:add_filter_requirements(tbl, flag)
	var_6_2:refresh()

	return var_6_2
end

local var_0_1 = class(ServerReserveState)

var_0_1.NAME = "ServerReserveState"

var_0_1.init = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	-- function 7
	self._network_options = arg_7_2
	self._peers_to_reserve = arg_7_4
	self._state_machine = arg_7_1
end

var_0_1.enter = function (self, arg_8_1)
	-- function 8
	print("Attempt reserving slots on " .. arg_8_1.server_info.ip_port)

	local var_8_0

	self._lobby_data = arg_8_1
	self._lobby = GameServerLobbyClient:new(self._network_options, arg_8_1, var_8_0, self._peers_to_reserve)
	self._state_machine._lobby = self._lobby
end

var_0_1.update = function (self, arg_9_1)
	-- function 9
	local _lobby = self._lobby

	_lobby:update(arg_9_1)

	local state = _lobby:state()

	if state == "reserved" then
		return "reserve_success", _lobby, self._lobby_data
	end

	if state == "failed" then
		return "reserve_failed"
	end
end

local var_0_2 = class(SuccessState)

var_0_2.NAME = "SuccessState"

var_0_2.init = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	-- function 10
	self._state_machine = arg_10_1
end

var_0_2.enter = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_0._state_machine._result = "reserved"
	arg_11_0._state_machine._lobby_data = arg_11_2
end

local var_0_3 = class(FailState)

var_0_3.NAME = "FailState"

var_0_3.init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	-- function 12
	arg_12_1._result = "failed"
end

ServerPartyReserveStateMachine = class(ServerPartyReserveStateMachine, VisualStateMachine)

ServerPartyReserveStateMachine.init = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local var_13_0
	local config_file_name = arg_13_1.config_file_name
	local project_hash = arg_13_1.project_hash
	local create_network_hash = LobbyAux.create_network_hash(config_file_name, project_hash)

	self.super.init(self, "ServerPartyReserveStateMachine", var_13_0, arg_13_1, create_network_hash, arg_13_2, arg_13_4 or {}, arg_13_5 or {}, arg_13_3, arg_13_6 or {})

	self._has_result = false
	self._user_data = arg_13_6
	self._result = nil
	self._lobby = nil
	self._lobby_data = nil
	self._reserve_attempts = {
		internet = 5,
		favorites = 5,
		lan = 5
	}
	self._servers = {}

	self:add_transition("FindServerState", "server_found", var_0_1)
	self:add_transition("FindServerState", "server_not_found", var_0_3)
	self:add_transition("ServerReserveState", "reserve_success", var_0_2)
	self:add_transition("ServerReserveState", "reserve_failed", var_0_0)
	self:set_initial_state(var_0_0)
end

ServerPartyReserveStateMachine.destroy = function (self)
	-- function 14
	if not self._lobby then
		self._lobby:destroy()

		self._lobby = nil
	end

	self.super.destroy(self)
end

ServerPartyReserveStateMachine.result = function (self)
	-- function 15
	if self._result == nil then
		return
	end

	local _lobby = self._lobby

	self._lobby = nil

	return self._result, _lobby, self._lobby_data, self._user_data
end
