-- chunkname: @scripts/managers/account/account_manager_win32.lua

require("scripts/managers/account/presence/presence_helper")

AccountManager = class(AccountManager)
AccountManager.VERSION = "win32"

local debug_friends_list = Development.parameter("debug_friends_list")

local function dprint(...)
	-- function 1
	print("[AccountManager] ", ...)
end

AccountManager.init = function (self)
	-- function 2
	if HAS_STEAM then
		self._initial_user_id = Steam.user_id()
	end

	if DEDICATED_SERVER then
		self._country_code = string.lower(SteamGameServer.country_code())
	elseif HAS_STEAM then
		self._country_code = string.lower(Steam.user_country_code())
	end
end

AccountManager.user_id = function (self)
	-- function 3
	return self._initial_user_id
end

AccountManager.update = function (self, dt)
	-- function 4
	return
end

AccountManager.sign_in = function (self, user_id)
	-- function 5
	Managers.state.event:trigger("account_user_signed_in")
end

AccountManager.num_signed_in_users = function (self)
	-- function 6
	return 1
end

AccountManager.user_detached = function (self)
	-- function 7
	return false
end

AccountManager.acitve_controller = function (self)
	-- function 8
	return
end

AccountManager.leaving_game = function (self)
	-- function 9
	return
end

AccountManager.reset = function (self)
	-- function 10
	return
end

AccountManager.update_presence = function (self)
	-- function 11
	if DEDICATED_SERVER or not rawget(_G, "Presence") then
		return
	end

	local is_in_hub_level = Managers.level_transition_handler:in_hub_level()
	local state = Managers.state
	local network = not not state and not not state.network
	local lobby = not not network and not not network:lobby()

	if not lobby then
		return
	end

	local is_server = Managers.player.is_server
	local get_stored_lobby_data

	if is_server then
		get_stored_lobby_data = lobby:get_stored_lobby_data()

		if not get_stored_lobby_data then
			-- Nothing
		end
	end

	get_stored_lobby_data = LobbyInternal.get_lobby_data_from_id(lobby:id())

	local lobby_data = get_stored_lobby_data

	::label_11_0::

	if not lobby_data then
		return
	end

	local mechanism_name = Managers.mechanism:current_mechanism_name()

	if is_in_hub_level then
		local set_presence = Presence.set_presence
		local str = "steam_display"
		local flag

		flag = (not to_boolean(MODDED_REALM) or not "#presence_modded_hub") and not not "#presence_official_hub"

		set_presence(str, flag)
		Presence.set_presence("steam_player_group_size", PresenceHelper.lobby_num_players())
		Presence.set_presence("hub_string", PresenceHelper.get_hub_presence())
		Presence.set_presence("level", PresenceHelper.lobby_level())
	elseif mechanism_name ~= "versus" then
		local set_presence_2 = Presence.set_presence
		local str_2 = "steam_display"
		local flag_2

		flag_2 = (not MODDED_REALM or not "#presence_modded") and not not "#presence_official"

		set_presence_2(str_2, flag_2)
		Presence.set_presence("steam_player_group", lobby:id())
		Presence.set_presence("steam_player_group_size", PresenceHelper.lobby_num_players())
		Presence.set_presence("gamemode", PresenceHelper.lobby_gamemode(lobby_data))
		Presence.set_presence("difficulty", PresenceHelper.lobby_difficulty())
		Presence.set_presence("level", PresenceHelper.lobby_level())
	else
		Presence.set_presence("steam_display", "#presence_versus_official")

		local num_players = PresenceHelper.lobby_num_players()

		Presence.set_presence("steam_player_group_size", num_players)

		local gamemode = PresenceHelper.lobby_gamemode(lobby_data)

		Presence.set_presence("gamemode", gamemode)

		local level = PresenceHelper.lobby_level()

		Presence.set_presence("level", level)

		local side = PresenceHelper.get_side()

		Presence.set_presence("side", side)

		local score = PresenceHelper.get_game_score()

		Presence.set_presence("score", score)

		local set = PresenceHelper.get_current_set()

		Presence.set_presence("set", set)
	end
end

AccountManager.set_controller_disconnected = function (self, disconnected)
	-- function 12
	return
end

AccountManager.controller_disconnected = function (self)
	-- function 13
	return
end

AccountManager.get_friends = function (self, friends_list_limit, callback)
	-- function 14
	if debug_friends_list then
		callback(SteamHelper.debug_friends())
	elseif rawget(_G, "Steam") and rawget(_G, "Friends") then
		callback(SteamHelper.friends())
	else
		callback(nil)
	end
end

AccountManager.set_current_lobby = function (self, lobby)
	-- function 15
	return
end

AccountManager.all_sessions_cleaned_up = function (self)
	-- function 16
	return
end

AccountManager.send_session_invitation = function (self, id, invite_target)
	-- function 17
	if rawget(_G, "Steam") and rawget(_G, "Friends") then
		Friends.invite(id, invite_target)
	end
end

AccountManager.show_player_profile = function (self, id)
	-- function 18
	if rawget(_G, "Steam") then
		local dec_id = Steam.id_hex_to_dec(id)
		local url = "http://steamcommunity.com/profiles/" .. dec_id

		Steam.open_url(url)
	end
end

AccountManager.account_id = function (self)
	-- function 19
	return Network.peer_id()
end

AccountManager.active_controller = function (self)
	-- function 20
	local input_manager = Managers.input

	if input_manager:is_device_active("gamepad") then
		return input_manager:get_most_recent_device()
	end

	return nil
end

AccountManager.region = function (self)
	-- function 21
	return self._country_code
end

AccountManager.set_should_teardown_xboxlive = function (self)
	-- function 22
	return
end

AccountManager.friends_list_initiated = function (self)
	-- function 23
	return
end

AccountManager.check_popup_retrigger = function (self)
	-- function 24
	return
end

AccountManager.set_offline_mode = function (self, offline)
	-- function 25
	return
end

AccountManager.is_online = function (self)
	-- function 26
	return not GameSettingsDevelopment.use_offline_backend
end

AccountManager.offline_mode = function (self)
	-- function 27
	return GameSettingsDevelopment.use_offline_backend == true
end

AccountManager.has_fatal_error = function (self)
	-- function 28
	return false
end

AccountManager.has_popup = function (self)
	-- function 29
	return false
end

AccountManager.cancel_all_popups = function (self)
	-- function 30
	return
end

AccountManager.has_session = function (self)
	-- function 31
	return true
end

AccountManager.has_access = function (self)
	-- function 32
	return false
end

AccountManager.should_throttle = function (self)
	-- function 33
	return false
end

AccountManager.console_type_setting = function (self)
	-- function 34
	return true
end

AccountManager.initiate_leave_game = function (self)
	-- function 35
	return
end
