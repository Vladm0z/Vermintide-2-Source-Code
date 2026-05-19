-- chunkname: @scripts/managers/account/account_manager_ps4.lua

require("scripts/managers/account/script_web_api_psn")
require("scripts/utils/base64")
require("scripts/network/ps_restrictions")
require("scripts/network/script_tss_token")
require("scripts/managers/matchmaking/matchmaking_regions")

local var_0_0 = require("scripts/settings/presence_set")

AccountManager = class(AccountManager)
AccountManager.VERSION = "ps4"

local var_0_1 = 10
local var_0_2 = 500

local function var_0_3(...)
	print("[AccountManager] ", ...)
end

local var_0_4 = {
	ps4 = {
		allow_dismemberment = false
	},
	ps4_pro = {
		allow_dismemberment = false
	},
	ps5 = {
		allow_dismemberment = true
	},
	default = {
		allow_dismemberment = false
	}
}

function AccountManager.init(arg_2_0)
	if arg_2_0:is_online() then
		arg_2_0:fetch_user_data()
	end

	arg_2_0._web_api = ScriptWebApiPsn:new()
	arg_2_0._initial_user_id = PS4.initial_user_id()

	if not script_data.settings.use_beta_mode then
		Trophies.create_context(arg_2_0._initial_user_id)
	end

	arg_2_0._country_code = PS4.user_country(arg_2_0._initial_user_id)
	arg_2_0._room_state = nil
	arg_2_0._current_room = nil
	arg_2_0._offline_mode = nil
	arg_2_0._session = nil
	arg_2_0._has_presence_game_data = false
	arg_2_0._np_title_id = PS4.title_id()
	arg_2_0._ps_restrictions = PSRestrictions:new()
	arg_2_0._dialog_open = false
	arg_2_0._realtime_multiplay = false
	arg_2_0._realtime_multiplay_host = nil
	arg_2_0._psn_client_error = nil
	arg_2_0._friend_data = {}
	arg_2_0._next_friend_list_request = 0
	arg_2_0._fetching_friend_list = false
	arg_2_0._fetching_matchmaking_data = false
	arg_2_0._next_matchmaking_data_fetch = 0
	arg_2_0._retrigger_popups_check = false
end

function AccountManager.set_controller(arg_3_0, arg_3_1)
	arg_3_0._active_controller = arg_3_1
end

function AccountManager.fetch_user_data(arg_4_0)
	arg_4_0._online_id = PS4.online_id()
	arg_4_0._np_id = PS4.np_id()
	arg_4_0._account_id = PS4.account_id()

	Crashify.print_property("ps4_online_id", arg_4_0._online_id)
	Crashify.print_property("ps4_account_id", arg_4_0._account_id)
	print("PSN_ID:", arg_4_0._online_id)
end

function AccountManager.np_title_id(arg_5_0)
	return arg_5_0._np_title_id
end

function AccountManager.initial_user_id(arg_6_0)
	return arg_6_0._initial_user_id
end

function AccountManager.user_id(arg_7_0)
	return arg_7_0._initial_user_id
end

function AccountManager.user_detached(arg_8_0)
	return arg_8_0._user_detached
end

function AccountManager.active_controller(arg_9_0, arg_9_1)
	return Managers.input:get_most_recent_device()
end

function AccountManager.np_id(arg_10_0)
	return arg_10_0._np_id
end

function AccountManager.online_id(arg_11_0)
	return arg_11_0._online_id
end

function AccountManager.account_id(arg_12_0)
	return arg_12_0._account_id
end

function AccountManager.add_restriction_user(arg_13_0, arg_13_1)
	arg_13_0._ps_restrictions:add_user(arg_13_1)
end

function AccountManager.set_current_lobby(arg_14_0, arg_14_1)
	arg_14_0._current_room = arg_14_1
end

function AccountManager.initiate_leave_game(arg_15_0)
	arg_15_0._leave_game = true

	if arg_15_0:is_online() and arg_15_0._has_presence_game_data then
		arg_15_0:delete_presence_game_data()
	end
end

function AccountManager.leaving_game(arg_16_0)
	return arg_16_0._leave_game
end

function AccountManager.reset(arg_17_0)
	if arg_17_0._popup_id then
		Managers.popup:cancel_popup(arg_17_0._popup_id)

		arg_17_0._popup_info = nil
		arg_17_0._popup_id = nil
	end

	arg_17_0._signed_in = false
	arg_17_0._offline_mode = nil
	arg_17_0._leave_game = nil
	arg_17_0._user_detached = nil
end

function AccountManager.destroy(arg_18_0)
	arg_18_0._web_api:destroy()

	arg_18_0._web_api = nil

	if arg_18_0._has_presence_game_data then
		arg_18_0:delete_presence_game_data()
	end

	local var_18_0 = arg_18_0._session

	if var_18_0 then
		if var_18_0.is_owner then
			arg_18_0:delete_session()
		else
			arg_18_0:leave_session()
		end
	end
end

function AccountManager.sign_in(arg_19_0)
	arg_19_0._signed_in = PS4.signed_in(arg_19_0._initial_user_id)
end

function AccountManager.is_online(arg_20_0)
	return not arg_20_0._offline_mode and PS4.signed_in()
end

function AccountManager.offline_mode(arg_21_0)
	return arg_21_0._offline_mode
end

function AccountManager.set_offline_mode(arg_22_0, arg_22_1)
	arg_22_0._offline_mode = arg_22_1
end

function AccountManager.update(arg_23_0, arg_23_1)
	arg_23_0:_update_playtogether()
	arg_23_0:_update_psn_client(arg_23_1)

	if arg_23_0:is_online() then
		arg_23_0:_update_psn()
	end

	arg_23_0:_notify_plus()
	arg_23_0:_verify_profile()
	arg_23_0._web_api:update(arg_23_1)
	arg_23_0:_update_profile_dialog()
	arg_23_0:_check_trigger_popup()
	arg_23_0:_check_popup()
end

function AccountManager._check_trigger_popup(arg_24_0)
	if not arg_24_0._retrigger_popups_check then
		return
	end

	local var_24_0 = Managers.popup

	if arg_24_0._popup_id ~= nil and not var_24_0:has_popup_with_id(arg_24_0._popup_id) then
		arg_24_0._popup_id = var_24_0:queue_popup(arg_24_0._popup_info.header, arg_24_0._popup_info.text, arg_24_0._popup_info.action1, arg_24_0._popup_info.buttontext1)
	end

	arg_24_0._retrigger_popups_check = false
end

function AccountManager._check_popup(arg_25_0)
	if arg_25_0._popup_id then
		local var_25_0 = Managers.popup:query_result(arg_25_0._popup_id)

		if var_25_0 then
			arg_25_0._popup_id = nil

			if var_25_0 == "retry_verify_profile" then
				arg_25_0._user_detached = false

				arg_25_0:_verify_profile()
			else
				fassert(false, "[AccountManager:_check_popup] No result trackedc called %q", var_25_0)
			end
		end
	end
end

function AccountManager._verify_profile(arg_26_0)
	if arg_26_0._popup_id then
		return
	end

	if arg_26_0._initial_user_id then
		local var_26_0 = false

		if not arg_26_0._user_detached then
			if not PS4.signed_in(arg_26_0._initial_user_id) and arg_26_0._signed_in then
				arg_26_0:_queue_popup(Localize("profile_signed_out_header"), Localize("popup_xboxlive_profile_acquire_error_header"), "retry_verify_profile", Localize("button_retry"))

				arg_26_0._user_detached = true
			elseif arg_26_0._active_controller then
				local var_26_1 = false

				if arg_26_0._active_controller then
					local var_26_2 = arg_26_0._active_controller.user_id()
				end

				if not arg_26_0._active_controller or not arg_26_0._active_controller.user_id() or arg_26_0._active_controller.disconnected() or var_26_1 then
					arg_26_0:_queue_popup(Localize("controller_disconnected"), Localize("controller_disconnected_header"), "retry_verify_profile", Localize("button_retry"))

					arg_26_0._user_detached = true
				end
			end
		end
	end
end

function AccountManager._queue_popup(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	arg_27_0._popup_info = {
		header = arg_27_1,
		text = arg_27_2,
		action1 = arg_27_3,
		buttontext1 = arg_27_4
	}
	arg_27_0._popup_id = Managers.popup:queue_popup(arg_27_1, arg_27_2, arg_27_3, arg_27_4)
end

function AccountManager._update_playtogether(arg_28_0)
	if arg_28_0._session ~= nil then
		local var_28_0 = Managers.invite
		local var_28_1 = SessionInvitation.play_together_list()

		if var_28_1 ~= nil then
			var_28_0:set_play_together_list(var_28_1)
		end

		local var_28_2 = var_28_0:play_together_list()
		local var_28_3 = Managers.matchmaking ~= nil

		if var_28_2 ~= nil and var_28_3 then
			print("[AccountManager] Play Together: sending invites")
			var_28_0:clear_play_together_list()
			arg_28_0:send_session_invitation_multiple(var_28_2)
		end
	end
end

local var_0_5 = 20

function AccountManager._update_psn_client(arg_29_0, arg_29_1)
	if not rawget(_G, "LobbyInternal") or not LobbyInternal.client or LobbyInternal.TYPE ~= "psn" then
		arg_29_0._psn_client_error = nil

		return
	end

	if arg_29_0._psn_client_error then
		return
	end

	if not LobbyInternal.client_ready() then
		if LobbyInternal.client_lost_context() or LobbyInternal.client_failed() then
			arg_29_0._psn_client_error = "lost_context"
		else
			arg_29_0._psn_client_timeout_timer = (arg_29_0._psn_client_timeout_timer or 0) + arg_29_1

			if arg_29_0._psn_client_timeout_timer > var_0_5 then
				arg_29_0._psn_client_error = "ready_timeout"
				arg_29_0._psn_client_timeout_timer = 0
			end
		end
	else
		arg_29_0._psn_client_timeout_timer = 0
	end
end

function AccountManager.psn_client_error(arg_30_0)
	return arg_30_0._psn_client_error
end

function AccountManager._update_psn(arg_31_0)
	local var_31_0 = arg_31_0._current_room
	local var_31_1 = arg_31_0._previous_room
	local var_31_2 = var_31_0 and var_31_0:state()
	local var_31_3 = arg_31_0._room_state
	local var_31_4 = false
	local var_31_5 = false

	if var_31_0 ~= var_31_1 then
		var_31_4 = var_31_2 == LobbyState.JOINED
		var_31_5 = var_31_3 == LobbyState.JOINED
	else
		var_31_4 = var_31_3 ~= LobbyState.JOINED and var_31_2 == LobbyState.JOINED
		var_31_5 = var_31_3 == LobbyState.JOINED and var_31_2 ~= LobbyState.JOINED
	end

	arg_31_0:_update_psn_presence(var_31_4, var_31_5)
	arg_31_0:_update_psn_session(var_31_4, var_31_5)

	arg_31_0._previous_room = var_31_0
	arg_31_0._room_state = var_31_2
end

function AccountManager._update_psn_presence(arg_32_0, arg_32_1, arg_32_2)
	if arg_32_2 then
		-- block empty
	end

	if arg_32_1 then
		local var_32_0 = arg_32_0._current_room:sce_np_room_id()

		arg_32_0:set_presence_game_data(var_32_0)
	end
end

function AccountManager._update_psn_session(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._session

	if arg_33_2 and var_33_0 then
		if var_33_0.is_owner then
			arg_33_0:delete_session()
		else
			arg_33_0:leave_session()
		end
	end

	if arg_33_1 then
		local var_33_1 = arg_33_0._current_room
		local var_33_2 = var_33_1:sce_np_room_id()

		if var_33_1:lobby_host() == Network.peer_id() then
			arg_33_0:create_session(var_33_2)
		else
			local var_33_3 = var_33_1:data("session_id")

			if var_33_3 then
				arg_33_0:join_session(var_33_3)
			end
		end
	end
end

function AccountManager._notify_plus(arg_34_0)
	if not arg_34_0._realtime_multiplay then
		return
	end

	if not arg_34_0._session then
		return
	end

	local var_34_0 = arg_34_0._realtime_multiplay_host

	if not var_34_0 then
		return
	end

	local var_34_1 = arg_34_0._current_room
	local var_34_2 = var_34_1 and var_34_1:lobby_host()

	if not var_34_2 then
		return
	end

	if var_34_0 ~= var_34_2 then
		arg_34_0._realtime_multiplay = false
		arg_34_0._realtime_multiplay_host = nil

		return
	end

	if Network.time_since_receive(var_34_2) > GameSettingsDevelopment.network_silence_warning_delay then
		return
	end

	local var_34_3 = arg_34_0:user_id()

	if PS4.signed_in(var_34_3) then
		NpCheck.notify_plus(var_34_3, NpCheck.REALTIME_MULTIPLAY)
	end
end

function AccountManager.friends_list_initiated(arg_35_0)
	return
end

function AccountManager.region(arg_36_0)
	return arg_36_0._country_code
end

function AccountManager._update_matchmaking_data(arg_37_0, arg_37_1)
	local var_37_0 = Managers.time:time("main")

	if not arg_37_0._matchmaking_data and not arg_37_0._fetching_matchmaking_data and var_37_0 >= arg_37_0._next_matchmaking_data_fetch then
		arg_37_0:_fetch_matchmaking_data(var_37_0)
	end
end

function AccountManager._fetch_matchmaking_data(arg_38_0, arg_38_1)
	print("FETCHING MATCHMAKING DATA")

	local var_38_0 = 0
	local var_38_1 = Tss.get(var_38_0)
	local var_38_2 = ScriptTssToken:new(var_38_1)

	Managers.token:register_token(var_38_2, callback(arg_38_0, "cb_matchmaking_data_fetched"))

	arg_38_0._fetching_matchmaking_data = true
	arg_38_0._next_matchmaking_data_fetch = arg_38_1 + 3
end

function AccountManager.cb_matchmaking_data_fetched(arg_39_0, arg_39_1)
	arg_39_0._fetching_matchmaking_data = false

	if arg_39_1.result then
		print("MATCHMAKING DATA FETCHED")
		MatchmakingRegionsHelper.populate_matchmaking_data(arg_39_1.result)

		arg_39_0._matchmaking_data = true
	else
		Application.warning(string.format("[AccountManager] Failed fetching matchmaking data"))
	end
end

function AccountManager.set_realtime_multiplay(arg_40_0, arg_40_1)
	arg_40_0._realtime_multiplay = arg_40_1

	if arg_40_1 then
		local var_40_0 = arg_40_0._current_room

		arg_40_0._realtime_multiplay_host = var_40_0 and var_40_0:lobby_host()
	else
		arg_40_0._realtime_multiplay_host = nil
	end
end

function AccountManager._update_profile_dialog(arg_41_0)
	if not arg_41_0._dialog_open then
		return
	end

	NpProfileDialog.update()

	if NpProfileDialog.status() == NpProfileDialog.FINISHED then
		NpProfileDialog.terminate()

		arg_41_0._dialog_open = false
	end
end

function AccountManager.current_psn_session(arg_42_0)
	local var_42_0 = arg_42_0._session

	return var_42_0 and var_42_0.id
end

function AccountManager.all_sessions_cleaned_up(arg_43_0)
	return true
end

function AccountManager.has_access(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_2 or arg_44_0:user_id()

	return arg_44_0._ps_restrictions:has_access(var_44_0, arg_44_1)
end

function AccountManager.has_error(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_2 or arg_45_0:user_id()

	return arg_45_0._ps_restrictions:has_error(var_45_0, arg_45_1)
end

function AccountManager.restriction_access_fetched(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0:user_id()

	return arg_46_0._ps_restrictions:restriction_access_fetched(var_46_0, arg_46_1)
end

function AccountManager.refetch_restriction_access(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_1 or arg_47_0:user_id()

	arg_47_0._ps_restrictions:refetch_restriction_access(var_47_0, arg_47_2)
end

function AccountManager.show_player_profile(arg_48_0, arg_48_1)
	if arg_48_0._dialog_open then
		return
	end

	local var_48_0 = arg_48_0:user_id()

	arg_48_1 = arg_48_1 or arg_48_0:user_id()

	NpProfileDialog.initialize()
	NpProfileDialog.open(var_48_0, arg_48_1)

	arg_48_0._dialog_open = true
end

function AccountManager.show_player_profile_with_np_id(arg_49_0, arg_49_1)
	Application.error("[AccountManager:show_player_profile_with_np_id] This function is deprecated, use AccountManager:show_player_profile_with_account_id() instead")
end

function AccountManager.show_player_profile_with_account_id(arg_50_0, arg_50_1)
	if arg_50_0._dialog_open then
		return
	end

	local var_50_0 = arg_50_0:user_id()

	arg_50_1 = arg_50_1 or arg_50_0:account_id()

	NpProfileDialog.initialize()
	NpProfileDialog.open_with_account_id(var_50_0, arg_50_1)

	arg_50_0._dialog_open = true
end

function AccountManager.get_friends(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_0._friend_data
	local var_51_1 = Managers.time:time("main")

	if arg_51_0._fetching_friend_list or var_51_1 < arg_51_0._next_friend_list_request then
		arg_51_2(var_51_0)
	elseif not arg_51_0._account_id then
		arg_51_2(var_51_0)
	else
		table.clear(var_51_0)
		arg_51_0:_fetch_friends(arg_51_1, 0, arg_51_2)

		arg_51_0._next_friend_list_request = var_51_1 + var_0_1
	end
end

function AccountManager._fetch_friends(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0 = var_0_2
	local var_52_1 = Application.hex64_to_dec(arg_52_0._account_id)
	local var_52_2 = arg_52_0:user_id()
	local var_52_3 = "sdk:userProfile"
	local var_52_4 = string.format("/v1/users/%s/friendList?friendStatus=friend&presenceType=primary&presenceDetail=true&limit=%s&offset=%s", var_52_1, tostring(var_52_0), tostring(arg_52_2))
	local var_52_5 = WebApi.GET
	local var_52_6
	local var_52_7 = callback(arg_52_0, "cb_fetch_friends", arg_52_1, arg_52_2, arg_52_3)

	arg_52_0._web_api:send_request(var_52_2, var_52_3, var_52_4, var_52_5, var_52_6, var_52_7)

	arg_52_0._fetching_friend_list = true
end

function AccountManager.cb_fetch_friends(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	local var_53_0 = arg_53_0._friend_data

	if not arg_53_4 then
		arg_53_0._fetching_friend_list = false

		arg_53_3(var_53_0)

		return
	end

	local var_53_1 = arg_53_4.friendList

	for iter_53_0 = 1, #var_53_1 do
		local var_53_2 = var_53_1[iter_53_0]
		local var_53_3 = var_53_2.user
		local var_53_4 = Application.dec64_to_hex(var_53_3.accountId)
		local var_53_5 = var_53_3.onlineId
		local var_53_6 = var_53_2.presence.primaryInfo
		local var_53_7 = var_53_6.onlineStatus
		local var_53_8 = var_53_6.gameData and from_base64(var_53_6.gameData)
		local var_53_9
		local var_53_10
		local var_53_12

		if var_53_7 and var_53_7 == "online" then
			var_53_9 = "online"

			local var_53_11 = var_53_6.gameTitleInfo

			if var_53_11 and var_53_11.npTitleId == arg_53_0._np_title_id then
				var_53_12 = true
			else
				var_53_12 = false
			end
		else
			var_53_9 = "offline"
			var_53_12 = false
		end

		var_53_0[var_53_4] = {
			name = var_53_5,
			status = var_53_9,
			playing_this_game = var_53_12,
			room_id = var_53_8
		}
	end

	local var_53_13 = var_0_2

	if #var_53_1 == var_53_13 and arg_53_1 > table.size(var_53_0) then
		arg_53_2 = arg_53_2 + var_53_13

		arg_53_0:_fetch_friends(arg_53_1, arg_53_2, arg_53_3)
	else
		arg_53_0._fetching_friend_list = false

		arg_53_3(var_53_0)
	end
end

function AccountManager.get_user_presence(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_0:user_id()
	local var_54_1 = "sdk:userProfile"
	local var_54_2 = string.format("/v1/users/%s/presence?type=platform&platform=PS4", Application.hex64_to_dec(arg_54_1))
	local var_54_3 = WebApi.GET
	local var_54_4

	arg_54_0._web_api:send_request(var_54_0, var_54_1, var_54_2, var_54_3, var_54_4, arg_54_2)
end

function AccountManager.set_presence(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_0:is_online() or not arg_55_0._account_id then
		return
	end

	local var_55_0 = Application.hex64_to_dec(arg_55_0._account_id)
	local var_55_1 = arg_55_0:user_id()
	local var_55_2 = "sdk:userProfile"
	local var_55_3 = string.format("/v1/users/%s/presence/gameStatus", var_55_0)
	local var_55_4 = WebApi.PUT
	local var_55_5 = arg_55_0:_set_presence_status_content(arg_55_1, arg_55_2)

	arg_55_0._web_api:send_request(var_55_1, var_55_2, var_55_3, var_55_4, var_55_5)
end

function AccountManager.set_presence_game_data(arg_56_0, arg_56_1)
	local var_56_0 = Application.hex64_to_dec(arg_56_0._account_id)
	local var_56_1 = arg_56_0:user_id()
	local var_56_2 = "sdk:userProfile"
	local var_56_3 = string.format("/v1/users/%s/presence/gameData", var_56_0)
	local var_56_4 = WebApi.PUT
	local var_56_5 = to_base64(arg_56_1)
	local var_56_6 = {
		gameData = var_56_5
	}

	arg_56_0._web_api:send_request(var_56_1, var_56_2, var_56_3, var_56_4, var_56_6)

	arg_56_0._has_presence_game_data = true
end

function AccountManager.delete_presence_game_data(arg_57_0)
	local var_57_0 = Application.hex64_to_dec(arg_57_0._account_id)
	local var_57_1 = arg_57_0:user_id()
	local var_57_2 = "sdk:userProfile"
	local var_57_3 = string.format("/v1/users/%s/presence/gameData", var_57_0)
	local var_57_4 = WebApi.DELETE

	arg_57_0._web_api:send_request(var_57_1, var_57_2, var_57_3, var_57_4)

	arg_57_0._has_presence_game_data = false
end

function AccountManager.create_session(arg_58_0, arg_58_1)
	assert(arg_58_1, "[AccountManager] Tried to create psn session but parameter \"room_id\" is missing")

	local var_58_0 = Managers.level_transition_handler:get_current_level_keys()
	local var_58_1 = false

	if var_58_0 and var_58_0 == "tutorial" then
		var_58_1 = true
	end

	local var_58_2 = arg_58_0:user_id()
	local var_58_3 = {
		max_user = 4,
		type = "owner-bind",
		privacy = "public",
		platforms = "[\"PS4\"]",
		lock_flag = var_58_1
	}
	local var_58_4 = arg_58_0:_format_session_parameters(var_58_3)
	local var_58_5 = "/app0/content/session_images/session_image_default.jpg"
	local var_58_6 = arg_58_1
	local var_58_7

	arg_58_0._web_api:send_request_create_session(var_58_2, var_58_4, var_58_5, var_58_6, var_58_7, callback(arg_58_0, "_cb_session_created"))
end

function AccountManager._cb_session_created(arg_59_0, arg_59_1)
	if arg_59_1 then
		local var_59_0 = arg_59_1.sessionId

		arg_59_0._session = {
			is_owner = true,
			id = var_59_0
		}

		local var_59_1 = arg_59_0._current_room

		if var_59_1 then
			var_59_1:set_data("session_id", var_59_0)
		end
	else
		arg_59_0._session = nil
	end
end

function AccountManager.delete_session(arg_60_0)
	local var_60_0 = arg_60_0:user_id()
	local var_60_1 = arg_60_0._session.id
	local var_60_2 = "sessionInvitation"
	local var_60_3 = string.format("/v1/sessions/%s", var_60_1)
	local var_60_4 = WebApi.DELETE

	arg_60_0._web_api:send_request(var_60_0, var_60_2, var_60_3, var_60_4)

	arg_60_0._session = nil
end

function AccountManager.join_session(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_0:user_id()
	local var_61_1 = "sessionInvitation"
	local var_61_2 = string.format("/v1/sessions/%s/members", tostring(arg_61_1))
	local var_61_3 = WebApi.POST

	arg_61_0._web_api:send_request(var_61_0, var_61_1, var_61_2, var_61_3)

	arg_61_0._session = {
		is_owner = false,
		id = arg_61_1
	}
end

function AccountManager.leave_session(arg_62_0)
	local var_62_0 = arg_62_0:user_id()
	local var_62_1 = arg_62_0._session.id
	local var_62_2 = "sessionInvitation"
	local var_62_3 = string.format("/v1/sessions/%s/members/me", tostring(var_62_1))
	local var_62_4 = WebApi.DELETE

	arg_62_0._web_api:send_request(var_62_0, var_62_2, var_62_3, var_62_4)

	arg_62_0._session = nil
end

function AccountManager.get_session_data(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = arg_63_0:user_id()
	local var_63_1 = "sessionInvitation"
	local var_63_2 = string.format("/v1/sessions/%s/sessionData", tostring(arg_63_1))
	local var_63_3 = WebApi.GET
	local var_63_4
	local var_63_5 = WebApi.STRING

	arg_63_0._web_api:send_request(var_63_0, var_63_1, var_63_2, var_63_3, var_63_4, arg_63_2, var_63_5)
end

function AccountManager.send_session_invitation(arg_64_0, arg_64_1)
	local var_64_0 = arg_64_0:user_id()
	local var_64_1 = arg_64_0._session.id
	local var_64_2 = Localize("ps4_session_invitation")
	local var_64_3 = ((((("" .. "{\r\n") .. "  \"to\":[\r\n") .. string.format("    \"%s\"\r\n", Application.hex64_to_dec(arg_64_1))) .. "  ],\r\n") .. string.format("  \"message\":\"%s\"\r\n", var_64_2)) .. "}"

	arg_64_0._web_api:send_request_session_invitation(var_64_0, var_64_3, var_64_1)
end

function AccountManager.has_session(arg_65_0)
	return arg_65_0._session ~= nil and arg_65_0._session.id ~= nil
end

function AccountManager.send_session_invitation_multiple(arg_66_0, arg_66_1)
	local var_66_0 = arg_66_0:user_id()
	local var_66_1 = arg_66_0._session.id
	local var_66_2 = Localize("ps4_session_invitation")
	local var_66_3 = ("" .. "{\r\n") .. "  \"to\":[\r\n"

	for iter_66_0 = 1, #arg_66_1 do
		if arg_66_1[iter_66_0 + 1] then
			var_66_3 = var_66_3 .. string.format("    \"%s\",\r\n", Application.hex64_to_dec(arg_66_1[iter_66_0]))
		else
			var_66_3 = var_66_3 .. string.format("    \"%s\"\r\n", Application.hex64_to_dec(arg_66_1[iter_66_0]))
		end
	end

	local var_66_4 = ((var_66_3 .. "  ],\r\n") .. string.format("  \"message\":\"%s\"\r\n", var_66_2)) .. "}"

	arg_66_0._web_api:send_request_session_invitation(var_66_0, var_66_4, var_66_1)
end

function AccountManager.activity_feed_post_mission_completed(arg_67_0, arg_67_1, arg_67_2)
	if not arg_67_0:is_online() or not arg_67_0._account_id then
		return
	end

	local var_67_0 = arg_67_0:user_id()
	local var_67_1 = Application.hex64_to_dec(arg_67_0._account_id)
	local var_67_2 = arg_67_0._np_title_id
	local var_67_3 = "sdk:activityFeed"
	local var_67_4 = string.format("/v1/users/%s/feed", var_67_1)
	local var_67_5 = WebApi.POST
	local var_67_6 = {}
	local var_67_7 = {}
	local var_67_8 = {}

	var_67_7.default = string.format(Localize("activity_feed_finished_level_en"), Localize(arg_67_1), Localize(arg_67_2))
	var_67_8.default = string.format(Localize("activity_feed_finished_level_condensed_en"), Localize(arg_67_1))

	for iter_67_0, iter_67_1 in ipairs(var_67_6) do
		var_67_7[iter_67_1] = string.format(Localize("activity_feed_finished_level_" .. iter_67_1), Localize(arg_67_1), Localize(arg_67_2))
		var_67_8[iter_67_1] = string.format(Localize("activity_feed_finished_level_condensed_" .. iter_67_1), Localize(arg_67_1))
	end

	local var_67_9 = {
		subType = 1,
		storyType = "IN_GAME_POST",
		captions = var_67_7,
		condensedCaptions = var_67_8,
		targets = {
			{
				type = "TITLE_ID",
				meta = var_67_2
			}
		}
	}
	local var_67_10 = cjson.encode(var_67_9)

	arg_67_0._web_api:send_request(var_67_0, var_67_3, var_67_4, var_67_5, var_67_10)
end

function AccountManager.get_entitlement(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	local var_68_0 = arg_68_0:user_id()
	local var_68_1 = "sdk:entitlement"
	local var_68_2 = arg_68_2 or 0
	local var_68_3 = string.format("/v1/users/me/entitlements/%s?service_label=%s&fields=active_flag", arg_68_1, var_68_2)
	local var_68_4 = WebApi.GET
	local var_68_5

	arg_68_0._web_api:send_request(var_68_0, var_68_1, var_68_3, var_68_4, var_68_5, arg_68_3)
end

function AccountManager.get_product_details(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	local var_69_0 = arg_69_0:user_id()
	local var_69_1 = "sdk:commerce"
	local var_69_2 = arg_69_2 or 0
	local var_69_3 = string.format("/v1/users/me/container/%s?flag=discounts&useCurrencySymbol=true&serviceLabel=%s", arg_69_1, var_69_2)
	local var_69_4 = WebApi.GET
	local var_69_5
	local var_69_6 = WebApi.STRING

	arg_69_0._web_api:send_request(var_69_0, var_69_1, var_69_3, var_69_4, var_69_5, arg_69_3, var_69_6)
end

function AccountManager._format_session_parameters(arg_70_0, arg_70_1)
	local var_70_0 = ((("" .. "{\r\n") .. string.format("  \"sessionType\":%q,\r\n", arg_70_1.type)) .. string.format("  \"sessionPrivacy\":%q,\r\n", arg_70_1.privacy)) .. string.format("  \"sessionMaxUser\":%s,\r\n", tostring(arg_70_1.max_user))

	if arg_70_1.name then
		var_70_0 = var_70_0 .. string.format("  \"sessionName\":%q,\r\n", arg_70_1.name)
	end

	if arg_70_1.status then
		var_70_0 = var_70_0 .. string.format("  \"sessionStatus\":%q,\r\n", arg_70_1.status)
	end

	return ((var_70_0 .. string.format("  \"availablePlatforms\":%s,\r\n", arg_70_1.platforms)) .. string.format("  \"sessionLockFlag\":%s\r\n", arg_70_1.lock_flag and "true" or "false")) .. "}"
end

function AccountManager._set_presence_status_content(arg_71_0, arg_71_1, arg_71_2)
	local var_71_0 = arg_71_2
	local var_71_1 = var_0_0[arg_71_1] or {
		"en"
	}

	if not var_0_0[arg_71_1] then
		Application.error(string.format("[AccountManager:set_presence] \"%s\" could not be found in PresenceSet - defaulting to english", arg_71_1))
	end

	local var_71_2 = (("" .. "{\r\n") .. string.format("  \"gameStatus\":%q,\r\n", Localize(arg_71_1 .. "_en") .. (var_71_0 and " " .. Localize(var_71_0) or ""))) .. "  \"localizedGameStatus\":[\r\n"

	if var_71_1 then
		for iter_71_0, iter_71_1 in ipairs(var_71_1) do
			var_71_2 = var_71_2 .. "    {\r\n"
			var_71_2 = var_71_2 .. string.format("      \"npLanguage\":%q,\r\n", iter_71_1)
			var_71_2 = var_71_2 .. string.format("      \"gameStatus\":%q\r\n", Localize(arg_71_1 .. "_" .. iter_71_1) .. (var_71_0 and " " .. Localize(var_71_0) or ""))
			var_71_2 = var_71_2 .. (iter_71_0 < #var_71_1 and "    },\r\n" or "    }\r\n")
		end
	end

	return (var_71_2 .. "  ]\r\n") .. "}"
end

function AccountManager.force_exit_to_title_screen(arg_72_0)
	arg_72_0:initiate_leave_game()
end

function AccountManager.check_popup_retrigger(arg_73_0)
	arg_73_0._retrigger_popups_check = true
end

function AccountManager.set_should_teardown_xboxlive(arg_74_0)
	return
end

function AccountManager.has_fatal_error(arg_75_0)
	return false
end

function AccountManager.has_popup(arg_76_0)
	return false
end

function AccountManager.cancel_all_popups(arg_77_0)
	return
end

function AccountManager.update_presence(arg_78_0)
	return
end

function AccountManager.should_throttle(arg_79_0)
	if PS4.is_ps5() then
		return false
	elseif PS4.is_pro() then
		return true
	else
		return true
	end
end

function AccountManager.console_type(arg_80_0)
	local var_80_0 = "ps4"

	if PS4.is_ps5() then
		var_80_0 = "ps5"
	elseif PS4.is_pro() then
		var_80_0 = "ps4_pro"
	end

	return var_80_0
end

function AccountManager.console_type_setting(arg_81_0, arg_81_1)
	local var_81_0 = arg_81_0:console_type()

	return (var_0_4[var_81_0] or var_0_4.default)[arg_81_1]
end
