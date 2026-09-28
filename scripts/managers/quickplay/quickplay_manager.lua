-- chunkname: @scripts/managers/quickplay/quickplay_manager.lua

local rpcs = {
	"rpc_set_has_pending_quick_game"
}

QuickplayManager = class(QuickplayManager)

QuickplayManager.init = function (self, loading_context, is_server)
	-- function 1
	self._is_server = is_server
	self._has_pending_quick_game = false
	self._is_quick_game = not not loading_context.quickplay_bonus
	loading_context.quickplay_bonus = nil

	if not is_server then
		self._joined_via_quickplay = self._is_quick_game

		local level_settings = LevelSettings[Managers.level_transition_handler:get_current_level_key()]

		if level_settings.hub_level then
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

QuickplayManager.set_has_pending_quick_game = function (self, value)
	-- function 4
	if self._has_pending_quick_game ~= value and self._is_server and self._network_transmit then
		self._network_transmit:send_rpc_clients("rpc_set_has_pending_quick_game", value)
	end

	self._has_pending_quick_game = value
end

QuickplayManager.has_pending_quick_game = function (self)
	-- function 5
	return self._has_pending_quick_game
end

QuickplayManager.on_round_start = function (self, network_event_delegate, event_manager, network_transmit)
	-- function 6
	self:_register_rpcs(network_event_delegate, network_transmit)
end

QuickplayManager.on_round_end = function (self)
	-- function 7
	self:_unregister_rpcs()
end

QuickplayManager._register_rpcs = function (self, network_event_delegate, network_transmit)
	-- function 8
	if not self._network_event_delegate then
		self._network_event_delegate = network_event_delegate

		network_event_delegate:register(self, unpack(rpcs))

		self._network_transmit = network_transmit
	end
end

QuickplayManager._unregister_rpcs = function (self)
	-- function 9
	if self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
		self._network_transmit = nil
	end
end

QuickplayManager.hot_join_sync = function (self, peer_id)
	-- function 10
	if self._has_pending_quick_game then
		self._network_transmit:send_rpc("rpc_set_has_pending_quick_game", peer_id, true)
	end
end

QuickplayManager.rpc_set_has_pending_quick_game = function (self, channel_id, value)
	-- function 11
	if not self._joined_via_quickplay then
		self:set_has_pending_quick_game(value)
	end
end
