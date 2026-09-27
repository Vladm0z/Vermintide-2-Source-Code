-- chunkname: @scripts/managers/quickplay/quickplay_manager.lua

local tbl = {
	"rpc_set_has_pending_quick_game"
}

QuickplayManager = class(QuickplayManager)

QuickplayManager.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._is_server = arg_1_2
	self._has_pending_quick_game = false
	self._is_quick_game = not not arg_1_1.quickplay_bonus
	arg_1_1.quickplay_bonus = nil

	if not arg_1_2 then
		self._joined_via_quickplay = self._is_quick_game

		if not LevelSettings[Managers.level_transition_handler:get_current_level_key()].hub_level then
			self:set_has_pending_quick_game(self._is_quick_game)
		end
	end
end

QuickplayManager.is_quick_game = function (self)
	-- function 2
	return self._is_quick_game
end

QuickplayManager.set_is_weave_quick_game = function (self)
	-- function 3
	self._is_quick_game = true
end

QuickplayManager.set_has_pending_quick_game = function (self, arg_4_1)
	-- function 4
	if (self._has_pending_quick_game == arg_4_1 or not self._is_server) and not self._network_transmit then
		self._network_transmit:send_rpc_clients("rpc_set_has_pending_quick_game", arg_4_1)
	end

	self._has_pending_quick_game = arg_4_1
end

QuickplayManager.has_pending_quick_game = function (self)
	-- function 5
	return self._has_pending_quick_game
end

QuickplayManager.on_round_start = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	self:_register_rpcs(arg_6_1, arg_6_3)
end

QuickplayManager.on_round_end = function (self)
	-- function 7
	self:_unregister_rpcs()
end

QuickplayManager._register_rpcs = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._network_event_delegate then
		self._network_event_delegate = arg_8_1

		arg_8_1:register(self, unpack(tbl))

		self._network_transmit = arg_8_2
	end
end

QuickplayManager._unregister_rpcs = function (self)
	-- function 9
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
		self._network_transmit = nil
	end
end

QuickplayManager.hot_join_sync = function (self, arg_10_1)
	-- function 10
	if not self._has_pending_quick_game then
		self._network_transmit:send_rpc("rpc_set_has_pending_quick_game", arg_10_1, true)
	end
end

QuickplayManager.rpc_set_has_pending_quick_game = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self._joined_via_quickplay then
		self:set_has_pending_quick_game(arg_11_2)
	end
end
