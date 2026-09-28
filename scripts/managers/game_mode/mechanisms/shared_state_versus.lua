-- chunkname: @scripts/managers/game_mode/mechanisms/shared_state_versus.lua

require("scripts/network/shared_state")

local shared_state_spec = require("scripts/managers/game_mode/mechanisms/shared_state_versus_spec")

SharedStateVersus = class(SharedStateVersus)

SharedStateVersus.init = function (self, is_server, network_handler, server_peer_id, own_peer_id)
	-- function 1
	self._shared_state = SharedState:new("shared_state_versus_" .. server_peer_id, shared_state_spec, is_server, network_handler, server_peer_id, own_peer_id)
	self._is_server = is_server
	self._server_peer_id = server_peer_id
	self._own_peer_id = own_peer_id
end

SharedStateVersus.full_sync = function (self)
	-- function 2
	self._shared_state:full_sync()
end

SharedStateVersus.register_rpcs = function (self, network_event_delegate)
	-- function 3
	self._shared_state:register_rpcs(network_event_delegate)
end

SharedStateVersus.unregister_rpcs = function (self)
	-- function 4
	self._shared_state:unregister_rpcs()
end

SharedStateVersus.network_context_created = function (self, lobby, server_peer_id, own_peer_id, is_server, network_server)
	-- function 5
	self._shared_state:network_context_created(lobby, server_peer_id, own_peer_id, is_server, network_server)
end

SharedStateVersus.destroy = function (self)
	-- function 6
	self._shared_state:destroy()

	self._shared_state = nil
end

SharedStateVersus.get_revision = function (self)
	-- function 7
	return self._shared_state:get_revision()
end

SharedStateVersus.is_peer_fully_synced = function (self, peer_id)
	-- function 8
	return self._shared_state:is_peer_fully_synced(peer_id)
end

SharedStateVersus.get_hero_cosmetics = function (self, peer_id, local_player_id)
	-- function 9
	local key = self._shared_state:get_key("hero_cosmetics", nil, local_player_id)

	return self._shared_state:get_peer(peer_id, key)
end

SharedStateVersus.set_hero_cosmetics = function (self, peer_id, local_player_id, weapon_slot, weapon, weapon_pose, weapon_pose_skin, hero_skin, hat, frame, pactsworn_cosmetics)
	-- function 10
	local key = self._shared_state:get_key("hero_cosmetics", nil, local_player_id)

	self._shared_state:set_peer(peer_id, key, {
		weapon_slot = weapon_slot,
		weapon = weapon,
		weapon_pose = weapon_pose,
		weapon_pose_skin = weapon_pose_skin,
		hero_skin = hero_skin,
		hat = hat,
		frame = frame,
		pactsworn_cosmetics = pactsworn_cosmetics
	})
end

SharedStateVersus.on_match_ended = function (self)
	-- function 11
	local key = self._shared_state:get_key("match_ended")

	self._shared_state:set_server(key, true)
end

SharedStateVersus.get_match_ended = function (self)
	-- function 12
	local key = self._shared_state:get_key("match_ended")

	self._shared_state:get_server(key)
end

SharedStateVersus.on_party_won_early = function (self)
	-- function 13
	local key = self._shared_state:get_key("party_won_early")

	self._shared_state:set_server(key, true)
end

SharedStateVersus.get_party_won_early = function (self)
	-- function 14
	local key = self._shared_state:get_key("party_won_early")

	return self._shared_state:get_server(key)
end

SharedStateVersus.generate_match_id = function (self)
	-- function 15
	local match_id = Application.guid()
	local key = self._shared_state:get_key("match_id")

	self._shared_state:set_server(key, match_id)
end

SharedStateVersus.get_match_id = function (self)
	-- function 16
	local match_id = self._shared_state:get_key("match_id")

	return self._shared_state:get_server(match_id)
end
