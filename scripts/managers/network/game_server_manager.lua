-- chunkname: @scripts/managers/network/game_server_manager.lua

GameServerManager = class(GameServerManager)

GameServerManager.init = function (self, arg_1_1)
	-- function 1
	self._last_error_reason = ""
end

GameServerManager.setup_network_context = function (self, arg_2_1)
	-- function 2
	self._network_server = arg_2_1.network_server
	self._network_transmit = arg_2_1.network_transmit
	self._game_server = arg_2_1.game_server
	self._profile_synchronizer = arg_2_1.profile_synchronizer
end

GameServerManager.destroy = function (self)
	-- function 3
	if not self._network_transmit then
		self._network_transmit:destroy()

		self._network_transmit = nil
	end
end

GameServerManager.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_notify_backend_errors()
end

GameServerManager.peer_name = function (self, arg_5_1)
	-- function 5
	return self._game_server:user_name(arg_5_1)
end

GameServerManager.remove_peer = function (self, arg_6_1)
	-- function 6
	self._game_server:remove_peer(arg_6_1)
end

GameServerManager._update_game_server = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:_update_leader()
end

GameServerManager.server_name = function (self)
	-- function 8
	return self._game_server:server_name()
end

GameServerManager.set_leader_peer_id = function (self, arg_9_1)
	-- function 9
	Managers.party:set_leader(arg_9_1)

	local flag

	flag = arg_9_1 ~= nil or not "0" or arg_9_1

	local get_members = self._game_server:members():get_members()

	for i, v in ipairs(get_members) do
		local var_9_2 = PEER_ID_TO_CHANNEL[v]

		RPC.rpc_game_server_set_group_leader(var_9_2, flag)
	end
end

GameServerManager.start_game_params = function (self)
	-- function 10
	return self._start_game_params
end

GameServerManager.restart = function (self)
	-- function 11
	self._wants_restart = true
end

GameServerManager.get_transition = function (self)
	-- function 12
	if not self._wants_restart then
		return "restart_game_server"
	end
end

GameServerManager.hot_join_sync = function (arg_13_0, arg_13_1)
	-- function 13
	local matchmaking = Managers.matchmaking

	if not matchmaking and not matchmaking:on_dedicated_server() then
		return
	end

	local leader = Managers.party:leader()
	local flag

	flag = leader ~= nil or not "0" or leader

	local var_13_3 = PEER_ID_TO_CHANNEL[arg_13_1]

	RPC.rpc_game_server_set_group_leader(var_13_3, flag)
end

GameServerManager.set_start_game_params = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local leader = Managers.party:leader()

	if arg_14_1 ~= leader then
		mm_printf("Peer (%s) tried starting the game without being leader (%s)", arg_14_1, leader)

		return
	end

	local get_stored_lobby_data = self._game_server:get_stored_lobby_data()

	get_stored_lobby_data.level_key = arg_14_2
	get_stored_lobby_data.difficulty = arg_14_4

	local var_14_2

	if not IS_PS4 then
		var_14_2 = NetworkLookup.game_modes[arg_14_3]

		if not var_14_2 then
			-- Nothing
		end
	end

	var_14_2 = arg_14_3

	::label_14_0::

	get_stored_lobby_data.game_mode = var_14_2

	local flag

	flag = not arg_14_5 and "true" and "false"
	get_stored_lobby_data.is_private = flag

	self._game_server:set_lobby_data(get_stored_lobby_data)

	self._start_game_params = {
		level_key = arg_14_2,
		game_mode = arg_14_3,
		difficulty = arg_14_4,
		private_game = arg_14_5
	}
end

GameServerManager._notify_backend_errors = function (self)
	-- function 15
	local backend = Managers.backend

	if backend == nil or not backend:has_error() then
		local error_string = backend:error_string()

		if self._last_error_reason ~= error_string then
			self:_say(error_string)

			self._last_error_reason = error_string
		end
	end
end

GameServerManager._say = function (arg_16_0, arg_16_1)
	-- function 16
	arg_16_1 = UTF8Utils.sub_string(arg_16_1, 1, 128)

	local chat = Managers.chat

	if chat == nil or not chat:has_channel(1) then
		local flag = false

		chat:send_system_chat_message(1, "backend_error_on_server", arg_16_1, flag, true)
	end
end
