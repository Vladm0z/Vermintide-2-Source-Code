-- chunkname: @scripts/managers/backend/backend_interface_session.lua

local tbl = {
	END_OF_ROUND = 3,
	ERROR = 4,
	IN_GAME = 2,
	INITIALIZED = 1,
	UNINITIALIZED = 0
}

for k, v in pairs(tbl) do
	tbl[v] = k
end

local var_0_1 = class(Session)

var_0_1.init = function (self)
	-- function 1
	self._peers = {}
	self._peer_queue = {}
	self._debug_backend_session_done_timeout = false
	self._debug_backend_session_stop_timeout = false
end

var_0_1.disable = function (self)
	-- function 2
	self._disabled = true
end

var_0_1.enabled = function (self)
	-- function 3
	return not self._disabled
end

var_0_1.register_rpcs = function (self, arg_4_1)
	-- function 4
	self._network_event_delegate = arg_4_1

	if not Managers.state.network.is_server then
		arg_4_1:register(self, "rpc_backend_session_done")
	else
		arg_4_1:register(self, "rpc_backend_session_join")
	end
end

var_0_1.rpc_backend_session_join = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	BackendSession.join(arg_5_2)
end

var_0_1.rpc_backend_session_done = function (self, arg_6_1)
	-- function 6
	if not self._debug_backend_session_done_timeout then
		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		self:_dice_player_done(var_6_0)
	end
end

var_0_1._dice_player_done = function (self, arg_7_1)
	-- function 7
	local players = self._dice_data.players

	players[arg_7_1] = nil

	if not (not table.is_empty(players) and self._debug_backend_session_stop_timeout) then
		BackendSession.stop()

		self._dice_data = nil
	end
end

var_0_1.reset = function (self)
	-- function 8
	if not self._disabled then
		self._disabled = nil
	else
		local get_state = BackendSession.get_state()

		if not (not Managers.state.network.is_server and get_state == tbl.UNINITIALIZED) then
			BackendSession.stop()
		end

		self._post_dice_timeout = nil

		self:_unregister_rpcs()

		self._peers = {}
		self._peer_queue = {}
		self._disabled = nil
		self._dice_data = nil
	end
end

var_0_1._unregister_rpcs = function (self)
	-- function 9
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

var_0_1.update = function (self, arg_10_1)
	-- function 10
	local get_state = BackendSession.get_state()

	if not self._log_state then
		if get_state == tbl.UNINITIALIZED then
			print("Session state: done!")

			self._log_state = nil
		else
			print("Session state: ", tbl[get_state])
		end
	end

	if not (#self._peer_queue > 0) or not BackendSession.get_session_id() then
		local get_session_id = BackendSession.get_session_id()
		local network = Managers.state.network

		for i, v in ipairs(self._peer_queue) do
			self._peer_queue[i] = nil

			network.network_transmit:send_rpc("rpc_backend_session_join", v, get_session_id)

			self._peers[v] = true
		end
	end

	local _dice_data = self._dice_data

	if not (not _dice_data and not (Managers.time:time("main") > _dice_data.timeout)) then
		for k, v_2 in pairs(_dice_data.players) do
			self:_dice_player_done(k)
		end

		self._error_data = {
			reason = BACKEND_LUA_ERRORS.ERR_DICE_TIMEOUT2
		}
	elseif not self._post_dice_timeout then
		if get_state == tbl.UNINITIALIZED then
			self._post_dice_timeout = nil
		elseif Managers.time:time("main") > self._post_dice_timeout then
			self._post_dice_timeout = nil
		end
	end
end

var_0_1.add_peer = function (arg_11_0, arg_11_1)
	-- function 11
	local get_session_id = BackendSession.get_session_id()

	if not get_session_id then
		Managers.state.network.network_transmit:send_rpc("rpc_backend_session_join", arg_11_1, get_session_id)

		arg_11_0._peers[arg_11_1] = true
	else
		arg_11_0._peer_queue[#arg_11_0._peer_queue + 1] = arg_11_1
	end
end

var_0_1.end_of_round = function (self)
	-- function 12
	local clone = table.clone(self._peers)

	clone[Network.peer_id()] = true

	local num = Managers.time:time("main") + 20

	self._dice_data = {
		players = clone,
		timeout = num
	}

	BackendSession.end_of_round()
end

var_0_1.received_dice_game_loot = function (self)
	-- function 13
	self._post_dice_timeout = Managers.time:time("main") + 20

	Managers.state.network.network_transmit:send_rpc_server("rpc_backend_session_done")
end

var_0_1.check_for_errors = function (self)
	-- function 14
	local _error_data = self._error_data

	self._error_data = nil

	return _error_data
end

BackendInterfaceSession = class(BackendInterfaceSession)

BackendInterfaceSession.init = function (self)
	-- function 15
	self._backend_session = var_0_1:new()
end

BackendInterfaceSession.setup = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not arg_16_2 then
		self._backend_session:disable()
	else
		self._backend_session:register_rpcs(arg_16_1)
	end
end

BackendInterfaceSession.update = function (self)
	-- function 17
	local _backend_session = self._backend_session

	if not _backend_session:enabled() then
		_backend_session:update()
	end
end

BackendInterfaceSession.check_for_errors = function (self)
	-- function 18
	return self._backend_session:check_for_errors()
end

BackendInterfaceSession.add_peer = function (self, arg_19_1)
	-- function 19
	local _backend_session = self._backend_session

	if not _backend_session:enabled() then
		_backend_session:add_peer(arg_19_1)
	end
end

BackendInterfaceSession.start = function (self)
	-- function 20
	if not self._backend_session:enabled() then
		BackendSession.start()
	end
end

BackendInterfaceSession.end_of_round = function (self)
	-- function 21
	local _backend_session = self._backend_session

	if not _backend_session:enabled() then
		_backend_session:end_of_round()
	end
end

BackendInterfaceSession.received_dice_game_loot = function (self)
	-- function 22
	local _backend_session = self._backend_session

	if not _backend_session:enabled() then
		_backend_session:received_dice_game_loot()
	end
end

BackendInterfaceSession.get_state = function (arg_23_0)
	-- function 23
	local get_state = BackendSession.get_state()

	return tbl[get_state]
end

BackendInterfaceSession.leave = function (self)
	-- function 24
	self._backend_session:reset()
end

BackendInterfaceSessionLocal = class(BackendInterfaceSessionLocal)

BackendInterfaceSessionLocal.init = function (self)
	-- function 25
	local tbl = {}

	tbl.__index = function ()
		-- function 26
		return tbl.__index
	end

	setmetatable(self, tbl)

	self.is_local = true
end

BackendInterfaceSessionLocal.ready = function (arg_27_0)
	-- function 27
	return true
end
