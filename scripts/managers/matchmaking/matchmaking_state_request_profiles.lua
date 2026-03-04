-- chunkname: @scripts/managers/matchmaking/matchmaking_state_request_profiles.lua

MatchmakingStateRequestProfiles = class(MatchmakingStateRequestProfiles)
MatchmakingStateRequestProfiles.NAME = "MatchmakingStateRequestProfiles"

function MatchmakingStateRequestProfiles.init(arg_1_0, arg_1_1)
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
end

function MatchmakingStateRequestProfiles.destroy(arg_2_0)
	return
end

function MatchmakingStateRequestProfiles.on_enter(arg_3_0, arg_3_1)
	arg_3_0.state_context = arg_3_1
	arg_3_0.search_config = arg_3_1.search_config
	arg_3_0._matchmaking_manager.debug.profiles_data = {}

	arg_3_0:_request_profiles_data()

	arg_3_0.state_context.profiles_data = nil
	arg_3_0.profiles_data = {}

	local var_3_0 = true

	Managers.chat:add_local_system_message(1, Localize("matchmaking_status_requesting_profiles"), var_3_0)
end

function MatchmakingStateRequestJoinGame.terminate(arg_4_0)
	Managers.lobby:destroy_lobby("matchmaking_join_lobby")
end

function MatchmakingStateRequestProfiles.on_exit(arg_5_0)
	return
end

function MatchmakingStateRequestProfiles.update(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._reply_timer then
		arg_6_0._reply_timer = arg_6_0._reply_timer - arg_6_1

		if arg_6_0._reply_timer < 0 then
			mm_printf("NO REPLY WHEN REQUESTING PROFILES DATA")

			if arg_6_0.search_config == nil then
				arg_6_0._matchmaking_manager:cancel_matchmaking()
			else
				Managers.lobby:destroy_lobby("matchmaking_join_lobby")

				local var_6_0 = arg_6_0.search_config

				if var_6_0 and var_6_0.dedicated_server and var_6_0.join_method == "party" then
					if var_6_0.aws then
						arg_6_0._next_state = MatchmakingStateFlexmatchHost
					else
						arg_6_0._next_state = MatchmakingStateReserveLobby
					end
				else
					arg_6_0._next_state = MatchmakingStateSearchGame
				end
			end
		end
	end

	if arg_6_0._next_state then
		return arg_6_0._next_state, arg_6_0.state_context
	end

	return nil
end

function MatchmakingStateRequestProfiles._request_profiles_data(arg_7_0)
	local var_7_0 = Managers.lobby:get_lobby("matchmaking_join_lobby"):lobby_host()

	RPC.rpc_matchmaking_request_profiles_data(PEER_ID_TO_CHANNEL[var_7_0])

	arg_7_0._reply_timer = MatchmakingSettings.REQUEST_PROFILES_REPLY_TIME
	arg_7_0._matchmaking_manager.debug.text = "requesting_profiles_data"
end

function MatchmakingStateRequestProfiles.rpc_matchmaking_request_profiles_data_reply(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_0._reply_timer = nil

	arg_8_0:_update_profiles_data(arg_8_2, arg_8_3, arg_8_4)

	arg_8_0.state_context.lobby_client = Managers.lobby:free_lobby("matchmaking_join_lobby")
	arg_8_0._next_state = MatchmakingStateJoinGame
	arg_8_0._matchmaking_manager.debug.text = "profiles_data_received"
end

function MatchmakingStateRequestProfiles._update_profiles_data(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.profiles_data = ProfileSynchronizer.join_reservation_data_arrays(arg_9_1, arg_9_2)
	arg_9_0.state_context.profiles_data = arg_9_0.profiles_data
	arg_9_0.state_context.reserved_party_id = arg_9_3
	arg_9_0._matchmaking_manager.debug.profiles_data = arg_9_0.profiles_data
end
