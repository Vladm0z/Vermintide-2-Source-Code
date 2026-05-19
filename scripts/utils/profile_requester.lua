-- chunkname: @scripts/utils/profile_requester.lua

local var_0_0 = {
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

function ProfileRequester.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._is_server = arg_1_1
	arg_1_0._network_server = arg_1_2
	arg_1_0._profile_synchronizer = arg_1_3
	arg_1_0._peer_id = Network.peer_id()
	arg_1_0._request_id = 0
end

function ProfileRequester.destroy(arg_2_0)
	return
end

function ProfileRequester.register_rpcs(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1:register(arg_3_0, unpack(var_0_0))

	arg_3_0._network_event_delegate = arg_3_1
	arg_3_0._network_transmit = arg_3_2
end

function ProfileRequester.unregister_rpcs(arg_4_0)
	arg_4_0._network_event_delegate:unregister(arg_4_0)

	arg_4_0._network_event_delegate = nil
	arg_4_0._network_transmit = nil
end

function ProfileRequester.profile_is_specator(arg_5_0, arg_5_1)
	return arg_5_1 == FindProfileIndex("spectator")
end

function ProfileRequester.request_profile(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_0._request_id = arg_6_0._request_id + 1
	arg_6_0._request_result = nil

	local var_6_0 = FindProfileIndex(arg_6_3)
	local var_6_1 = career_index_from_name(var_6_0, arg_6_4)

	if arg_6_0._is_server then
		arg_6_0:_request_profile(arg_6_1, arg_6_2, arg_6_0._request_id, var_6_0, var_6_1, arg_6_5)
	else
		arg_6_0._network_transmit:send_rpc_server("rpc_request_profile", arg_6_1, arg_6_2, arg_6_0._request_id, var_6_0, var_6_1, arg_6_5)
	end
end

function ProfileRequester._request_profile(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0

	arg_7_6 = not not arg_7_6

	local var_7_1 = Managers.mechanism:reserved_party_id_by_peer(arg_7_1)
	local var_7_2 = arg_7_0:profile_is_specator() or Managers.mechanism:profile_available_for_peer(var_7_1, arg_7_1, arg_7_4)

	if var_7_2 then
		local var_7_3
		local var_7_4
		local var_7_5, var_7_6

		var_7_2, var_7_5, var_7_6 = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(arg_7_1, arg_7_4, arg_7_5, arg_7_6)

		if var_7_5 then
			arg_7_4 = var_7_5
			arg_7_5 = var_7_6
		end
	end

	local var_7_7

	if var_7_2 then
		var_7_7 = ProfileRequester.REQUEST_RESULTS.success

		Managers.party:set_selected_profile(arg_7_1, arg_7_2, arg_7_4, arg_7_5)

		local var_7_8 = false

		arg_7_0._profile_synchronizer:assign_full_profile(arg_7_1, arg_7_2, arg_7_4, arg_7_5, var_7_8)

		if arg_7_6 then
			Managers.state.game_mode:force_respawn(arg_7_1, arg_7_2)
		end
	else
		var_7_7 = ProfileRequester.REQUEST_RESULTS.failure
	end

	if arg_7_0._peer_id == arg_7_1 then
		local var_7_9 = PEER_ID_TO_CHANNEL[arg_7_1]

		arg_7_0:rpc_request_profile_reply(var_7_9, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, var_7_7)
	else
		arg_7_0._network_transmit:send_rpc("rpc_request_profile_reply", arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, var_7_7)
	end
end

function ProfileRequester._despawn_player_unit(arg_8_0, arg_8_1)
	arg_8_0._despawning_player_unit = arg_8_1.player_unit

	Managers.state.spawn:delayed_despawn(arg_8_1)
end

function ProfileRequester.update(arg_9_0, arg_9_1)
	if arg_9_0._despawning_player_unit and not Unit.alive(arg_9_0._despawning_player_unit) then
		arg_9_0._despawning_player_unit = nil
	end
end

function ProfileRequester.result(arg_10_0)
	return arg_10_0._request_result
end

function ProfileRequester.rpc_request_profile(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	local var_11_0 = CHANNEL_TO_PEER_ID[arg_11_1]

	arg_11_0:_request_profile(var_11_0, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
end

function ProfileRequester.rpc_request_profile_reply(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	if arg_12_3 < arg_12_0._request_id then
		return
	end

	local var_12_0 = ProfileRequester.REQUEST_RESULTS[arg_12_7]

	arg_12_0._request_result = var_12_0

	if var_12_0 == "success" and arg_12_6 then
		local var_12_1 = arg_12_0._peer_id
		local var_12_2 = Managers.player:player(var_12_1, arg_12_2)

		if var_12_2 then
			if var_12_2:needs_despawn() then
				arg_12_0:_despawn_player_unit(var_12_2)
			end

			var_12_2:set_profile_index(arg_12_4)
			var_12_2:set_career_index(arg_12_5)
			Managers.party:set_selected_profile(var_12_1, arg_12_2, arg_12_4, arg_12_5)
		end
	end

	if script_data.testify then
		Testify:respond_to_request("set_player_profile")
	end
end
