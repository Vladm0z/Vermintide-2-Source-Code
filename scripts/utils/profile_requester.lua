-- chunkname: @scripts/utils/profile_requester.lua

local tbl = {
	"rpc_request_profile",
	"rpc_request_profile_reply"
}

ProfileRequester = class(ProfileRequester)
ProfileRequester.REQUEST_RESULTS = {
	"success",
	"failure",
	success = 1,
	failure = 2
}

ProfileRequester.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._is_server = arg_1_1
	self._network_server = arg_1_2
	self._profile_synchronizer = arg_1_3
	self._peer_id = Network.peer_id()
	self._request_id = 0
end

ProfileRequester.destroy = function (arg_2_0)
	-- function 2
	return
end

ProfileRequester.register_rpcs = function (self, arg_3_1, arg_3_2)
	-- function 3
	arg_3_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_3_1
	self._network_transmit = arg_3_2
end

ProfileRequester.unregister_rpcs = function (self)
	-- function 4
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._network_transmit = nil
end

ProfileRequester.profile_is_specator = function (arg_5_0, arg_5_1)
	-- function 5
	return arg_5_1 == FindProfileIndex("spectator")
end

ProfileRequester.request_profile = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	self._request_id = self._request_id + 1
	self._request_result = nil

	local var_6_0 = FindProfileIndex(arg_6_3)
	local var_6_1 = career_index_from_name(var_6_0, arg_6_4)

	if not self._is_server then
		self:_request_profile(arg_6_1, arg_6_2, self._request_id, var_6_0, var_6_1, arg_6_5)
	else
		self._network_transmit:send_rpc_server("rpc_request_profile", arg_6_1, arg_6_2, self._request_id, var_6_0, var_6_1, arg_6_5)
	end
end

ProfileRequester._request_profile = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local var_7_0

	arg_7_6 = not not arg_7_6

	local reserved_party_id_by_peer = Managers.mechanism:reserved_party_id_by_peer(arg_7_1)
	local flag = self:profile_is_specator() or Managers.mechanism:profile_available_for_peer(reserved_party_id_by_peer, arg_7_1, arg_7_4)

	if not flag then
		local var_7_3
		local var_7_4
		local var_7_5, var_7_6

		flag, var_7_5, var_7_6 = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(arg_7_1, arg_7_4, arg_7_5, arg_7_6)

		if not var_7_5 then
			arg_7_4 = var_7_5
			arg_7_5 = var_7_6
		end
	end

	local var_7_7

	if not flag then
		var_7_7 = ProfileRequester.REQUEST_RESULTS.success

		Managers.party:set_selected_profile(arg_7_1, arg_7_2, arg_7_4, arg_7_5)

		local flag_2 = false

		self._profile_synchronizer:assign_full_profile(arg_7_1, arg_7_2, arg_7_4, arg_7_5, flag_2)

		if not arg_7_6 then
			Managers.state.game_mode:force_respawn(arg_7_1, arg_7_2)
		end
	else
		var_7_7 = ProfileRequester.REQUEST_RESULTS.failure
	end

	if self._peer_id == arg_7_1 then
		local var_7_9 = PEER_ID_TO_CHANNEL[arg_7_1]

		self:rpc_request_profile_reply(var_7_9, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, var_7_7)
	else
		self._network_transmit:send_rpc("rpc_request_profile_reply", arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, var_7_7)
	end
end

ProfileRequester._despawn_player_unit = function (self, arg_8_1)
	-- function 8
	self._despawning_player_unit = arg_8_1.player_unit

	Managers.state.spawn:delayed_despawn(arg_8_1)
end

ProfileRequester.update = function (self, arg_9_1)
	-- function 9
	if not (not self._despawning_player_unit and Unit.alive(self._despawning_player_unit)) then
		self._despawning_player_unit = nil
	end
end

ProfileRequester.result = function (self)
	-- function 10
	return self._request_result
end

ProfileRequester.rpc_request_profile = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	-- function 11
	local var_11_0 = CHANNEL_TO_PEER_ID[arg_11_1]

	self:_request_profile(var_11_0, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
end

ProfileRequester.rpc_request_profile_reply = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	-- function 12
	if arg_12_3 < self._request_id then
		return
	end

	local var_12_0 = ProfileRequester.REQUEST_RESULTS[arg_12_7]

	self._request_result = var_12_0

	if var_12_0 ~= "success" or not arg_12_6 then
		local _peer_id = self._peer_id
		local player = Managers.player:player(_peer_id, arg_12_2)

		if not player then
			if not player:needs_despawn() then
				self:_despawn_player_unit(player)
			end

			player:set_profile_index(arg_12_4)
			player:set_career_index(arg_12_5)
			Managers.party:set_selected_profile(_peer_id, arg_12_2, arg_12_4, arg_12_5)
		end
	end

	if not script_data.testify then
		Testify:respond_to_request("set_player_profile")
	end
end
