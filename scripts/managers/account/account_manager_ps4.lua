-- chunkname: @scripts/managers/account/account_manager_ps4.lua

require("scripts/managers/account/script_web_api_psn")
require("scripts/utils/base64")
require("scripts/network/ps_restrictions")
require("scripts/network/script_tss_token")
require("scripts/managers/matchmaking/matchmaking_regions")

local scripts_settings_presence_set = require("scripts/settings/presence_set")

AccountManager = class(AccountManager)
AccountManager.VERSION = "ps4"

local num = 10
local num_2 = 500

local function fn(...)
	-- function 1
	print("[AccountManager] ", ...)
end

local tbl = {
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

AccountManager.init = function (self)
	-- function 2
	if not self:is_online() then
		self:fetch_user_data()
	end

	self._web_api = ScriptWebApiPsn:new()
	self._initial_user_id = PS4.initial_user_id()

	if not script_data.settings.use_beta_mode then
		Trophies.create_context(self._initial_user_id)
	end

	self._country_code = PS4.user_country(self._initial_user_id)
	self._room_state = nil
	self._current_room = nil
	self._offline_mode = nil
	self._session = nil
	self._has_presence_game_data = false
	self._np_title_id = PS4.title_id()
	self._ps_restrictions = PSRestrictions:new()
	self._dialog_open = false
	self._realtime_multiplay = false
	self._realtime_multiplay_host = nil
	self._psn_client_error = nil
	self._friend_data = {}
	self._next_friend_list_request = 0
	self._fetching_friend_list = false
	self._fetching_matchmaking_data = false
	self._next_matchmaking_data_fetch = 0
	self._retrigger_popups_check = false
end

AccountManager.set_controller = function (self, arg_3_1)
	-- function 3
	self._active_controller = arg_3_1
end

AccountManager.fetch_user_data = function (self)
	-- function 4
	self._online_id = PS4.online_id()
	self._np_id = PS4.np_id()
	self._account_id = PS4.account_id()

	Crashify.print_property("ps4_online_id", self._online_id)
	Crashify.print_property("ps4_account_id", self._account_id)
	print("PSN_ID:", self._online_id)
end

AccountManager.np_title_id = function (self)
	-- function 5
	return self._np_title_id
end

AccountManager.initial_user_id = function (self)
	-- function 6
	return self._initial_user_id
end

AccountManager.user_id = function (self)
	-- function 7
	return self._initial_user_id
end

AccountManager.user_detached = function (self)
	-- function 8
	return self._user_detached
end

AccountManager.active_controller = function (arg_9_0, arg_9_1)
	-- function 9
	return Managers.input:get_most_recent_device()
end

AccountManager.np_id = function (self)
	-- function 10
	return self._np_id
end

AccountManager.online_id = function (self)
	-- function 11
	return self._online_id
end

AccountManager.account_id = function (self)
	-- function 12
	return self._account_id
end

AccountManager.add_restriction_user = function (self, arg_13_1)
	-- function 13
	self._ps_restrictions:add_user(arg_13_1)
end

AccountManager.set_current_lobby = function (self, arg_14_1)
	-- function 14
	self._current_room = arg_14_1
end

AccountManager.initiate_leave_game = function (self)
	-- function 15
	self._leave_game = true

	if not self:is_online() and not self._has_presence_game_data then
		self:delete_presence_game_data()
	end
end

AccountManager.leaving_game = function (self)
	-- function 16
	return self._leave_game
end

AccountManager.reset = function (self)
	-- function 17
	if not self._popup_id then
		Managers.popup:cancel_popup(self._popup_id)

		self._popup_info = nil
		self._popup_id = nil
	end

	self._signed_in = false
	self._offline_mode = nil
	self._leave_game = nil
	self._user_detached = nil
end

AccountManager.destroy = function (self)
	-- function 18
	self._web_api:destroy()

	self._web_api = nil

	if not self._has_presence_game_data then
		self:delete_presence_game_data()
	end

	local _session = self._session

	if not _session then
		if not _session.is_owner then
			self:delete_session()
		else
			self:leave_session()
		end
	end
end

AccountManager.sign_in = function (self)
	-- function 19
	self._signed_in = PS4.signed_in(self._initial_user_id)
end

AccountManager.is_online = function (self)
	-- function 20
	return not not self._offline_mode or PS4.signed_in()
end

AccountManager.offline_mode = function (self)
	-- function 21
	return self._offline_mode
end

AccountManager.set_offline_mode = function (self, arg_22_1)
	-- function 22
	self._offline_mode = arg_22_1
end

AccountManager.update = function (self, arg_23_1)
	-- function 23
	self:_update_playtogether()
	self:_update_psn_client(arg_23_1)

	if not self:is_online() then
		self:_update_psn()
	end

	self:_notify_plus()
	self:_verify_profile()
	self._web_api:update(arg_23_1)
	self:_update_profile_dialog()
	self:_check_trigger_popup()
	self:_check_popup()
end

AccountManager._check_trigger_popup = function (self)
	-- function 24
	if not self._retrigger_popups_check then
		return
	end

	local popup = Managers.popup

	if not (self._popup_id == nil or popup:has_popup_with_id(self._popup_id)) then
		self._popup_id = popup:queue_popup(self._popup_info.header, self._popup_info.text, self._popup_info.action1, self._popup_info.buttontext1)
	end

	self._retrigger_popups_check = false
end

AccountManager._check_popup = function (self)
	-- function 25
	if not self._popup_id then
		local query_result = Managers.popup:query_result(self._popup_id)

		if not query_result then
			self._popup_id = nil

			if query_result == "retry_verify_profile" then
				self._user_detached = false

				self:_verify_profile()
			else
				fassert(false, "[AccountManager:_check_popup] No result trackedc called %q", query_result)
			end
		end
	end
end

AccountManager._verify_profile = function (self)
	-- function 26
	if not self._popup_id then
		return
	end

	if not self._initial_user_id then
		local flag = false

		if not self._user_detached then
			if not not PS4.signed_in(self._initial_user_id) and not self._signed_in then
				self:_queue_popup(Localize("profile_signed_out_header"), Localize("popup_xboxlive_profile_acquire_error_header"), "retry_verify_profile", Localize("button_retry"))

				self._user_detached = true
			elseif not self._active_controller then
				local flag_2 = false

				if not self._active_controller then
					local user_id = self._active_controller.user_id()
				end

				if not self._active_controller and not self._active_controller.user_id() and self._active_controller.disconnected() or not flag_2 then
					self:_queue_popup(Localize("controller_disconnected"), Localize("controller_disconnected_header"), "retry_verify_profile", Localize("button_retry"))

					self._user_detached = true
				end
			end
		end
	end
end

AccountManager._queue_popup = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	self._popup_info = {
		header = arg_27_1,
		text = arg_27_2,
		action1 = arg_27_3,
		buttontext1 = arg_27_4
	}
	self._popup_id = Managers.popup:queue_popup(arg_27_1, arg_27_2, arg_27_3, arg_27_4)
end

AccountManager._update_playtogether = function (self)
	-- function 28
	if self._session ~= nil then
		local invite = Managers.invite
		local play_together_list = SessionInvitation.play_together_list()

		if play_together_list ~= nil then
			invite:set_play_together_list(play_together_list)
		end

		local play_together_list_2 = invite:play_together_list()
		local flag = Managers.matchmaking ~= nil

		if play_together_list_2 == nil or not flag then
			print("[AccountManager] Play Together: sending invites")
			invite:clear_play_together_list()
			self:send_session_invitation_multiple(play_together_list_2)
		end
	end
end

local num_3 = 20

AccountManager._update_psn_client = function (self, arg_29_1)
	-- function 29
	if not (not rawget(_G, "LobbyInternal") and not LobbyInternal.client and LobbyInternal.TYPE == "psn") then
		self._psn_client_error = nil

		return
	end

	if not self._psn_client_error then
		return
	end

	if not LobbyInternal.client_ready() then
		if LobbyInternal.client_lost_context() or not LobbyInternal.client_failed() then
			self._psn_client_error = "lost_context"
		else
			local _psn_client_timeout_timer = self._psn_client_timeout_timer

			_psn_client_timeout_timer = _psn_client_timeout_timer or 0
			self._psn_client_timeout_timer = _psn_client_timeout_timer + arg_29_1

			if self._psn_client_timeout_timer > num_3 then
				self._psn_client_error = "ready_timeout"
				self._psn_client_timeout_timer = 0
			end
		end
	else
		self._psn_client_timeout_timer = 0
	end
end

AccountManager.psn_client_error = function (self)
	-- function 30
	return self._psn_client_error
end

AccountManager._update_psn = function (self)
	-- function 31
	local _current_room = self._current_room
	local _previous_room = self._previous_room
	local flag = not _current_room and _current_room:state()
	local _room_state = self._room_state
	local flag_2 = false
	local flag_3 = false

	if _current_room ~= _previous_room then
		flag_2 = flag == LobbyState.JOINED
		flag_3 = _room_state == LobbyState.JOINED
	else
		flag_2 = _room_state == LobbyState.JOINED or flag == LobbyState.JOINED
		flag_3 = _room_state ~= LobbyState.JOINED or flag ~= LobbyState.JOINED
	end

	self:_update_psn_presence(flag_2, flag_3)
	self:_update_psn_session(flag_2, flag_3)

	self._previous_room = _current_room
	self._room_state = flag
end

AccountManager._update_psn_presence = function (self, arg_32_1, arg_32_2)
	-- function 32
	if not arg_32_2 then
		-- Nothing
	end

	if not arg_32_1 then
		local sce_np_room_id = self._current_room:sce_np_room_id()

		self:set_presence_game_data(sce_np_room_id)
	end
end

AccountManager._update_psn_session = function (self, arg_33_1, arg_33_2)
	-- function 33
	local _session = self._session

	if not arg_33_2 and not _session then
		if not _session.is_owner then
			self:delete_session()
		else
			self:leave_session()
		end
	end

	if not arg_33_1 then
		local _current_room = self._current_room
		local sce_np_room_id = _current_room:sce_np_room_id()

		if _current_room:lobby_host() == Network.peer_id() then
			self:create_session(sce_np_room_id)
		else
			local data = _current_room:data("session_id")

			if not data then
				self:join_session(data)
			end
		end
	end
end

AccountManager._notify_plus = function (self)
	-- function 34
	if not self._realtime_multiplay then
		return
	end

	if not self._session then
		return
	end

	local _realtime_multiplay_host = self._realtime_multiplay_host

	if not _realtime_multiplay_host then
		return
	end

	local _current_room = self._current_room
	local flag = not _current_room and _current_room:lobby_host()

	if not flag then
		return
	end

	if _realtime_multiplay_host ~= flag then
		self._realtime_multiplay = false
		self._realtime_multiplay_host = nil

		return
	end

	if Network.time_since_receive(flag) > GameSettingsDevelopment.network_silence_warning_delay then
		return
	end

	local user_id = self:user_id()

	if not PS4.signed_in(user_id) then
		NpCheck.notify_plus(user_id, NpCheck.REALTIME_MULTIPLAY)
	end
end

AccountManager.friends_list_initiated = function (arg_35_0)
	-- function 35
	return
end

AccountManager.region = function (self)
	-- function 36
	return self._country_code
end

AccountManager._update_matchmaking_data = function (self, arg_37_1)
	-- function 37
	local time = Managers.time:time("main")

	if not (self._matchmaking_data or self._fetching_matchmaking_data or not (time >= self._next_matchmaking_data_fetch)) then
		self:_fetch_matchmaking_data(time)
	end
end

AccountManager._fetch_matchmaking_data = function (self, arg_38_1)
	-- function 38
	print("FETCHING MATCHMAKING DATA")

	local num = 0
	local get = Tss.get(num)
	local var_38_2 = ScriptTssToken:new(get)

	Managers.token:register_token(var_38_2, callback(self, "cb_matchmaking_data_fetched"))

	self._fetching_matchmaking_data = true
	self._next_matchmaking_data_fetch = arg_38_1 + 3
end

AccountManager.cb_matchmaking_data_fetched = function (self, arg_39_1)
	-- function 39
	self._fetching_matchmaking_data = false

	if not arg_39_1.result then
		print("MATCHMAKING DATA FETCHED")
		MatchmakingRegionsHelper.populate_matchmaking_data(arg_39_1.result)

		self._matchmaking_data = true
	else
		Application.warning(string.format("[AccountManager] Failed fetching matchmaking data"))
	end
end

AccountManager.set_realtime_multiplay = function (self, arg_40_1)
	-- function 40
	self._realtime_multiplay = arg_40_1

	if not arg_40_1 then
		local _current_room = self._current_room

		self._realtime_multiplay_host = not _current_room and _current_room:lobby_host()
	else
		self._realtime_multiplay_host = nil
	end
end

AccountManager._update_profile_dialog = function (self)
	-- function 41
	if not self._dialog_open then
		return
	end

	NpProfileDialog.update()

	if NpProfileDialog.status() == NpProfileDialog.FINISHED then
		NpProfileDialog.terminate()

		self._dialog_open = false
	end
end

AccountManager.current_psn_session = function (self)
	-- function 42
	local _session = self._session

	return not _session and _session.id
end

AccountManager.all_sessions_cleaned_up = function (arg_43_0)
	-- function 43
	return true
end

AccountManager.has_access = function (self, arg_44_1, arg_44_2)
	-- function 44
	local flag = arg_44_2 or self:user_id()

	return self._ps_restrictions:has_access(flag, arg_44_1)
end

AccountManager.has_error = function (self, arg_45_1, arg_45_2)
	-- function 45
	local flag = arg_45_2 or self:user_id()

	return self._ps_restrictions:has_error(flag, arg_45_1)
end

AccountManager.restriction_access_fetched = function (self, arg_46_1)
	-- function 46
	local user_id = self:user_id()

	return self._ps_restrictions:restriction_access_fetched(user_id, arg_46_1)
end

AccountManager.refetch_restriction_access = function (self, arg_47_1, arg_47_2)
	-- function 47
	local flag = arg_47_1 or self:user_id()

	self._ps_restrictions:refetch_restriction_access(flag, arg_47_2)
end

AccountManager.show_player_profile = function (self, arg_48_1)
	-- function 48
	if not self._dialog_open then
		return
	end

	local user_id = self:user_id()

	arg_48_1 = arg_48_1 or self:user_id()

	NpProfileDialog.initialize()
	NpProfileDialog.open(user_id, arg_48_1)

	self._dialog_open = true
end

AccountManager.show_player_profile_with_np_id = function (arg_49_0, arg_49_1)
	-- function 49
	Application.error("[AccountManager:show_player_profile_with_np_id] This function is deprecated, use AccountManager:show_player_profile_with_account_id() instead")
end

AccountManager.show_player_profile_with_account_id = function (self, arg_50_1)
	-- function 50
	if not self._dialog_open then
		return
	end

	local user_id = self:user_id()

	arg_50_1 = arg_50_1 or self:account_id()

	NpProfileDialog.initialize()
	NpProfileDialog.open_with_account_id(user_id, arg_50_1)

	self._dialog_open = true
end

AccountManager.get_friends = function (self, arg_51_1, arg_51_2)
	-- function 51
	local _friend_data = self._friend_data
	local time = Managers.time:time("main")

	if not (self._fetching_friend_list or not (time < self._next_friend_list_request)) then
		arg_51_2(_friend_data)
	elseif not self._account_id then
		arg_51_2(_friend_data)
	else
		table.clear(_friend_data)
		self:_fetch_friends(arg_51_1, 0, arg_51_2)

		self._next_friend_list_request = time + num
	end
end

AccountManager._fetch_friends = function (self, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	local var_52_0 = num_2
	local hex64_to_dec = Application.hex64_to_dec(self._account_id)
	local user_id = self:user_id()
	local str = "sdk:userProfile"
	local format = string.format("/v1/users/%s/friendList?friendStatus=friend&presenceType=primary&presenceDetail=true&limit=%s&offset=%s", hex64_to_dec, tostring(var_52_0), tostring(arg_52_2))
	local GET = WebApi.GET
	local var_52_6
	local var_52_7 = callback(self, "cb_fetch_friends", arg_52_1, arg_52_2, arg_52_3)

	self._web_api:send_request(user_id, str, format, GET, var_52_6, var_52_7)

	self._fetching_friend_list = true
end

AccountManager.cb_fetch_friends = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	-- function 53
	local _friend_data = self._friend_data

	if not arg_53_4 then
		self._fetching_friend_list = false

		arg_53_3(_friend_data)

		return
	end

	local friendList = arg_53_4.friendList

	for i = 1, #friendList do
		local var_53_2 = friendList[i]
		local user = var_53_2.user
		local dec64_to_hex = Application.dec64_to_hex(user.accountId)
		local onlineId = user.onlineId
		local primaryInfo = var_53_2.presence.primaryInfo
		local onlineStatus = primaryInfo.onlineStatus
		local gameData = primaryInfo.gameData

		gameData = not gameData and from_base64(primaryInfo.gameData)

		local var_53_9
		local var_53_10
		local flag

		if not (not onlineStatus and onlineStatus ~= "online") then
			var_53_9 = "online"

			local gameTitleInfo = primaryInfo.gameTitleInfo

			if not (not gameTitleInfo and gameTitleInfo.npTitleId ~= self._np_title_id) then
				flag = true
			else
				flag = false
			end
		else
			var_53_9 = "offline"
			flag = false
		end

		_friend_data[dec64_to_hex] = {
			name = onlineId,
			status = var_53_9,
			playing_this_game = flag,
			room_id = gameData
		}
	end

	local var_53_13 = num_2

	if not (#friendList ~= var_53_13 or not (arg_53_1 > table.size(_friend_data))) then
		arg_53_2 = arg_53_2 + var_53_13

		self:_fetch_friends(arg_53_1, arg_53_2, arg_53_3)
	else
		self._fetching_friend_list = false

		arg_53_3(_friend_data)
	end
end

AccountManager.get_user_presence = function (self, arg_54_1, arg_54_2)
	-- function 54
	local user_id = self:user_id()
	local str = "sdk:userProfile"
	local format = string.format("/v1/users/%s/presence?type=platform&platform=PS4", Application.hex64_to_dec(arg_54_1))
	local GET = WebApi.GET
	local var_54_4

	self._web_api:send_request(user_id, str, format, GET, var_54_4, arg_54_2)
end

AccountManager.set_presence = function (self, arg_55_1, arg_55_2)
	-- function 55
	if not (not self:is_online() and self._account_id) then
		return
	end

	local hex64_to_dec = Application.hex64_to_dec(self._account_id)
	local user_id = self:user_id()
	local str = "sdk:userProfile"
	local format = string.format("/v1/users/%s/presence/gameStatus", hex64_to_dec)
	local PUT = WebApi.PUT
	local _set_presence_status_content = self:_set_presence_status_content(arg_55_1, arg_55_2)

	self._web_api:send_request(user_id, str, format, PUT, _set_presence_status_content)
end

AccountManager.set_presence_game_data = function (self, arg_56_1)
	-- function 56
	local hex64_to_dec = Application.hex64_to_dec(self._account_id)
	local user_id = self:user_id()
	local str = "sdk:userProfile"
	local format = string.format("/v1/users/%s/presence/gameData", hex64_to_dec)
	local PUT = WebApi.PUT
	local var_56_5 = to_base64(arg_56_1)
	local tbl = {
		gameData = var_56_5
	}

	self._web_api:send_request(user_id, str, format, PUT, tbl)

	self._has_presence_game_data = true
end

AccountManager.delete_presence_game_data = function (self)
	-- function 57
	local hex64_to_dec = Application.hex64_to_dec(self._account_id)
	local user_id = self:user_id()
	local str = "sdk:userProfile"
	local format = string.format("/v1/users/%s/presence/gameData", hex64_to_dec)
	local DELETE = WebApi.DELETE

	self._web_api:send_request(user_id, str, format, DELETE)

	self._has_presence_game_data = false
end

AccountManager.create_session = function (self, arg_58_1)
	-- function 58
	assert(arg_58_1, "[AccountManager] Tried to create psn session but parameter \"room_id\" is missing")

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local flag = false

	if not (not get_current_level_keys and get_current_level_keys ~= "tutorial") then
		flag = true
	end

	local user_id = self:user_id()
	local tbl = {
		max_user = 4,
		type = "owner-bind",
		privacy = "public",
		platforms = "[\"PS4\"]",
		lock_flag = flag
	}
	local _format_session_parameters = self:_format_session_parameters(tbl)
	local str = "/app0/content/session_images/session_image_default.jpg"
	local var_58_6 = arg_58_1
	local var_58_7

	self._web_api:send_request_create_session(user_id, _format_session_parameters, str, var_58_6, var_58_7, callback(self, "_cb_session_created"))
end

AccountManager._cb_session_created = function (self, arg_59_1)
	-- function 59
	if not arg_59_1 then
		local sessionId = arg_59_1.sessionId

		self._session = {
			is_owner = true,
			id = sessionId
		}

		local _current_room = self._current_room

		if not _current_room then
			_current_room:set_data("session_id", sessionId)
		end
	else
		self._session = nil
	end
end

AccountManager.delete_session = function (self)
	-- function 60
	local user_id = self:user_id()
	local id = self._session.id
	local str = "sessionInvitation"
	local format = string.format("/v1/sessions/%s", id)
	local DELETE = WebApi.DELETE

	self._web_api:send_request(user_id, str, format, DELETE)

	self._session = nil
end

AccountManager.join_session = function (self, arg_61_1)
	-- function 61
	local user_id = self:user_id()
	local str = "sessionInvitation"
	local format = string.format("/v1/sessions/%s/members", tostring(arg_61_1))
	local POST = WebApi.POST

	self._web_api:send_request(user_id, str, format, POST)

	self._session = {
		is_owner = false,
		id = arg_61_1
	}
end

AccountManager.leave_session = function (self)
	-- function 62
	local user_id = self:user_id()
	local id = self._session.id
	local str = "sessionInvitation"
	local format = string.format("/v1/sessions/%s/members/me", tostring(id))
	local DELETE = WebApi.DELETE

	self._web_api:send_request(user_id, str, format, DELETE)

	self._session = nil
end

AccountManager.get_session_data = function (self, arg_63_1, arg_63_2)
	-- function 63
	local user_id = self:user_id()
	local str = "sessionInvitation"
	local format = string.format("/v1/sessions/%s/sessionData", tostring(arg_63_1))
	local GET = WebApi.GET
	local var_63_4
	local STRING = WebApi.STRING

	self._web_api:send_request(user_id, str, format, GET, var_63_4, arg_63_2, STRING)
end

AccountManager.send_session_invitation = function (self, arg_64_1)
	-- function 64
	local user_id = self:user_id()
	local id = self._session.id
	local var_64_2 = Localize("ps4_session_invitation")
	local str = ((((("" .. "{\r\n") .. "  \"to\":[\r\n") .. string.format("    \"%s\"\r\n", Application.hex64_to_dec(arg_64_1))) .. "  ],\r\n") .. string.format("  \"message\":\"%s\"\r\n", var_64_2)) .. "}"

	self._web_api:send_request_session_invitation(user_id, str, id)
end

AccountManager.has_session = function (self)
	-- function 65
	return self._session == nil or self._session.id ~= nil
end

AccountManager.send_session_invitation_multiple = function (self, arg_66_1)
	-- function 66
	local user_id = self:user_id()
	local id = self._session.id
	local var_66_2 = Localize("ps4_session_invitation")
	local str = ("" .. "{\r\n") .. "  \"to\":[\r\n"

	for i = 1, #arg_66_1 do
		if not arg_66_1[i + 1] then
			str = str .. string.format("    \"%s\",\r\n", Application.hex64_to_dec(arg_66_1[i]))
		else
			str = str .. string.format("    \"%s\"\r\n", Application.hex64_to_dec(arg_66_1[i]))
		end
	end

	local str_2 = ((str .. "  ],\r\n") .. string.format("  \"message\":\"%s\"\r\n", var_66_2)) .. "}"

	self._web_api:send_request_session_invitation(user_id, str_2, id)
end

AccountManager.activity_feed_post_mission_completed = function (self, arg_67_1, arg_67_2)
	-- function 67
	if not (not self:is_online() and self._account_id) then
		return
	end

	local user_id = self:user_id()
	local hex64_to_dec = Application.hex64_to_dec(self._account_id)
	local _np_title_id = self._np_title_id
	local str = "sdk:activityFeed"
	local format = string.format("/v1/users/%s/feed", hex64_to_dec)
	local POST = WebApi.POST
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}

	tbl_2.default = string.format(Localize("activity_feed_finished_level_en"), Localize(arg_67_1), Localize(arg_67_2))
	tbl_3.default = string.format(Localize("activity_feed_finished_level_condensed_en"), Localize(arg_67_1))

	for i, v in ipairs(tbl) do
		tbl_2[v] = string.format(Localize("activity_feed_finished_level_" .. v), Localize(arg_67_1), Localize(arg_67_2))
		tbl_3[v] = string.format(Localize("activity_feed_finished_level_condensed_" .. v), Localize(arg_67_1))
	end

	local tbl_4 = {
		subType = 1,
		storyType = "IN_GAME_POST",
		captions = tbl_2,
		condensedCaptions = tbl_3,
		targets = {
			{
				type = "TITLE_ID",
				meta = _np_title_id
			}
		}
	}
	local encode = cjson.encode(tbl_4)

	self._web_api:send_request(user_id, str, format, POST, encode)
end

AccountManager.get_entitlement = function (self, arg_68_1, arg_68_2, arg_68_3)
	-- function 68
	local user_id = self:user_id()
	local str = "sdk:entitlement"
	local flag = arg_68_2 or 0
	local format = string.format("/v1/users/me/entitlements/%s?service_label=%s&fields=active_flag", arg_68_1, flag)
	local GET = WebApi.GET
	local var_68_5

	self._web_api:send_request(user_id, str, format, GET, var_68_5, arg_68_3)
end

AccountManager.get_product_details = function (self, arg_69_1, arg_69_2, arg_69_3)
	-- function 69
	local user_id = self:user_id()
	local str = "sdk:commerce"
	local flag = arg_69_2 or 0
	local format = string.format("/v1/users/me/container/%s?flag=discounts&useCurrencySymbol=true&serviceLabel=%s", arg_69_1, flag)
	local GET = WebApi.GET
	local var_69_5
	local STRING = WebApi.STRING

	self._web_api:send_request(user_id, str, format, GET, var_69_5, arg_69_3, STRING)
end

AccountManager._format_session_parameters = function (arg_70_0, arg_70_1)
	-- function 70
	local str = ((("" .. "{\r\n") .. string.format("  \"sessionType\":%q,\r\n", arg_70_1.type)) .. string.format("  \"sessionPrivacy\":%q,\r\n", arg_70_1.privacy)) .. string.format("  \"sessionMaxUser\":%s,\r\n", tostring(arg_70_1.max_user))

	if not arg_70_1.name then
		str = str .. string.format("  \"sessionName\":%q,\r\n", arg_70_1.name)
	end

	if not arg_70_1.status then
		str = str .. string.format("  \"sessionStatus\":%q,\r\n", arg_70_1.status)
	end

	local str_2 = str .. string.format("  \"availablePlatforms\":%s,\r\n", arg_70_1.platforms)
	local format = string.format
	local str_3 = "  \"sessionLockFlag\":%s\r\n"
	local flag

	flag = not arg_70_1.lock_flag and "true" and "false"

	return (str_2 .. format(str_3, flag)) .. "}"
end

AccountManager._set_presence_status_content = function (arg_71_0, arg_71_1, arg_71_2)
	-- function 71
	local var_71_0 = arg_71_2
	local var_71_1 = scripts_settings_presence_set[arg_71_1]

	var_71_1 = var_71_1 or {
		"en"
	}

	if not scripts_settings_presence_set[arg_71_1] then
		Application.error(string.format("[AccountManager:set_presence] \"%s\" could not be found in PresenceSet - defaulting to english", arg_71_1))
	end

	local str = "" .. "{\r\n"
	local format = string.format
	local str_2 = "  \"gameStatus\":%q,\r\n"
	local var_71_5 = Localize(arg_71_1 .. "_en")
	local str_3

	if not var_71_0 then
		str_3 = " " .. Localize(var_71_0)

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = ""

	::label_71_0::

	local str_4 = (str .. format(str_2, var_71_5 .. str_3)) .. "  \"localizedGameStatus\":[\r\n"

	if not var_71_1 then
		for i, v in ipairs(var_71_1) do
			str_4 = str_4 .. "    {\r\n"
			str_4 = str_4 .. string.format("      \"npLanguage\":%q,\r\n", v)

			local var_71_8 = str_4
			local format_2 = string.format
			local str_5 = "      \"gameStatus\":%q\r\n"
			local var_71_11 = Localize(arg_71_1 .. "_" .. v)
			local str_6

			if not var_71_0 then
				str_6 = " " .. Localize(var_71_0)

				if not str_6 then
					-- Nothing
				end
			end

			str_6 = ""

			::label_71_1::

			str_4 = var_71_8 .. format_2(str_5, var_71_11 .. str_6)

			local var_71_13 = str_4
			local flag

			flag = not (i < #var_71_1) or not "    },\r\n" or "    }\r\n"
			str_4 = var_71_13 .. flag
		end
	end

	return (str_4 .. "  ]\r\n") .. "}"
end

AccountManager.force_exit_to_title_screen = function (self)
	-- function 72
	self:initiate_leave_game()
end

AccountManager.check_popup_retrigger = function (self)
	-- function 73
	self._retrigger_popups_check = true
end

AccountManager.set_should_teardown_xboxlive = function (arg_74_0)
	-- function 74
	return
end

AccountManager.has_fatal_error = function (arg_75_0)
	-- function 75
	return false
end

AccountManager.has_popup = function (arg_76_0)
	-- function 76
	return false
end

AccountManager.cancel_all_popups = function (arg_77_0)
	-- function 77
	return
end

AccountManager.update_presence = function (arg_78_0)
	-- function 78
	return
end

AccountManager.should_throttle = function (arg_79_0)
	-- function 79
	if not PS4.is_ps5() then
		return false
	elseif not PS4.is_pro() then
		return true
	else
		return true
	end
end

AccountManager.console_type = function (arg_80_0)
	-- function 80
	local str = "ps4"

	if not PS4.is_ps5() then
		str = "ps5"
	elseif not PS4.is_pro() then
		str = "ps4_pro"
	end

	return str
end

AccountManager.console_type_setting = function (self, arg_81_1)
	-- function 81
	local console_type = self:console_type()
	local var_81_1 = tbl[console_type]

	var_81_1 = var_81_1 or tbl.default

	return var_81_1[arg_81_1]
end
