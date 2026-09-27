-- chunkname: @scripts/managers/game_mode/mechanisms/shared_state_versus.lua

require("scripts/network/shared_state")

local scripts_managers_game_mode_mechanisms_shared_state_versus_spec = require("scripts/managers/game_mode/mechanisms/shared_state_versus_spec")

SharedStateVersus = class(SharedStateVersus)

SharedStateVersus.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._shared_state = SharedState:new("shared_state_versus_" .. arg_1_3, scripts_managers_game_mode_mechanisms_shared_state_versus_spec, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	self._is_server = arg_1_1
	self._server_peer_id = arg_1_3
	self._own_peer_id = arg_1_4
end

SharedStateVersus.full_sync = function (self)
	-- function 2
	self._shared_state:full_sync()
end

SharedStateVersus.register_rpcs = function (self, arg_3_1)
	-- function 3
	self._shared_state:register_rpcs(arg_3_1)
end

SharedStateVersus.unregister_rpcs = function (self)
	-- function 4
	self._shared_state:unregister_rpcs()
end

SharedStateVersus.network_context_created = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self._shared_state:network_context_created(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
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

SharedStateVersus.is_peer_fully_synced = function (self, arg_8_1)
	-- function 8
	return self._shared_state:is_peer_fully_synced(arg_8_1)
end

SharedStateVersus.get_hero_cosmetics = function (self, arg_9_1, arg_9_2)
	-- function 9
	local get_key = self._shared_state:get_key("hero_cosmetics", nil, arg_9_2)

	return self._shared_state:get_peer(arg_9_1, get_key)
end

SharedStateVersus.set_hero_cosmetics = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, arg_10_9, arg_10_10)
	-- function 10
	local get_key = self._shared_state:get_key("hero_cosmetics", nil, arg_10_2)

	self._shared_state:set_peer(arg_10_1, get_key, {
		weapon_slot = arg_10_3,
		weapon = arg_10_4,
		weapon_pose = arg_10_5,
		weapon_pose_skin = arg_10_6,
		hero_skin = arg_10_7,
		hat = arg_10_8,
		frame = arg_10_9,
		pactsworn_cosmetics = arg_10_10
	})
end

SharedStateVersus.on_match_ended = function (self)
	-- function 11
	local get_key = self._shared_state:get_key("match_ended")

	self._shared_state:set_server(get_key, true)
end

SharedStateVersus.get_match_ended = function (self)
	-- function 12
	local get_key = self._shared_state:get_key("match_ended")

	self._shared_state:get_server(get_key)
end

SharedStateVersus.on_party_won_early = function (self)
	-- function 13
	local get_key = self._shared_state:get_key("party_won_early")

	self._shared_state:set_server(get_key, true)
end

SharedStateVersus.get_party_won_early = function (self)
	-- function 14
	local get_key = self._shared_state:get_key("party_won_early")

	return self._shared_state:get_server(get_key)
end

SharedStateVersus.generate_match_id = function (self)
	-- function 15
	local guid = Application.guid()
	local get_key = self._shared_state:get_key("match_id")

	self._shared_state:set_server(get_key, guid)
end

SharedStateVersus.get_match_id = function (self)
	-- function 16
	local get_key = self._shared_state:get_key("match_id")

	return self._shared_state:get_server(get_key)
end
