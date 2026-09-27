-- chunkname: @scripts/managers/account/account_manager_win32.lua

require("scripts/managers/account/presence/presence_helper")

AccountManager = class(AccountManager)
AccountManager.VERSION = "win32"

local parameter = Development.parameter("debug_friends_list")

local function fn(...)
	-- function 1
	print("[AccountManager] ", ...)
end

AccountManager.init = function (self)
	-- function 2
	if not HAS_STEAM then
		self._initial_user_id = Steam.user_id()
	end

	if not DEDICATED_SERVER then
		self._country_code = string.lower(SteamGameServer.country_code())
	elseif not HAS_STEAM then
		self._country_code = string.lower(Steam.user_country_code())
	end
end

AccountManager.user_id = function (self)
	-- function 3
	return self._initial_user_id
end

AccountManager.update = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

AccountManager.sign_in = function (arg_5_0, arg_5_1)
	-- function 5
	Managers.state.event:trigger("account_user_signed_in")
end

AccountManager.num_signed_in_users = function (arg_6_0)
	-- function 6
	return 1
end

AccountManager.user_detached = function (arg_7_0)
	-- function 7
	return false
end

AccountManager.acitve_controller = function (arg_8_0)
	-- function 8
	return
end

AccountManager.leaving_game = function (arg_9_0)
	-- function 9
	return
end

AccountManager.reset = function (arg_10_0)
	-- function 10
	return
end

AccountManager.update_presence = function (arg_11_0)
	-- function 11
	if not (DEDICATED_SERVER or rawget(_G, "Presence")) then
		return
	end

	local in_hub_level = Managers.level_transition_handler:in_hub_level()
	local state = Managers.state
	local flag = not state and state.network
	local flag_2 = not flag and flag:lobby()

	if not flag_2 then
		return
	end

	local get_stored_lobby_data

	if not Managers.player.is_server then
		get_stored_lobby_data = flag_2:get_stored_lobby_data()

		if not get_stored_lobby_data then
			-- Nothing
		end
	end

	get_stored_lobby_data = LobbyInternal.get_lobby_data_from_id(flag_2:id())

	::label_11_0::

	if not get_stored_lobby_data then
		return
	end

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	if not in_hub_level then
		local set_presence = Presence.set_presence
		local str = "steam_display"
		local flag_3

		flag_3 = not to_boolean(MODDED_REALM) and "#presence_modded_hub" and "#presence_official_hub"

		set_presence(str, flag_3)
		Presence.set_presence("steam_player_group_size", PresenceHelper.lobby_num_players())
		Presence.set_presence("hub_string", PresenceHelper.get_hub_presence())
		Presence.set_presence("level", PresenceHelper.lobby_level())
	elseif current_mechanism_name ~= "versus" then
		local set_presence_2 = Presence.set_presence
		local str_2 = "steam_display"
		local flag_4

		flag_4 = not MODDED_REALM and "#presence_modded" and "#presence_official"

		set_presence_2(str_2, flag_4)
		Presence.set_presence("steam_player_group", flag_2:id())
		Presence.set_presence("steam_player_group_size", PresenceHelper.lobby_num_players())
		Presence.set_presence("gamemode", PresenceHelper.lobby_gamemode(get_stored_lobby_data))
		Presence.set_presence("difficulty", PresenceHelper.lobby_difficulty())
		Presence.set_presence("level", PresenceHelper.lobby_level())
	else
		Presence.set_presence("steam_display", "#presence_versus_official")

		local lobby_num_players = PresenceHelper.lobby_num_players()

		Presence.set_presence("steam_player_group_size", lobby_num_players)

		local lobby_gamemode = PresenceHelper.lobby_gamemode(get_stored_lobby_data)

		Presence.set_presence("gamemode", lobby_gamemode)

		local lobby_level = PresenceHelper.lobby_level()

		Presence.set_presence("level", lobby_level)

		local get_side = PresenceHelper.get_side()

		Presence.set_presence("side", get_side)

		local get_game_score = PresenceHelper.get_game_score()

		Presence.set_presence("score", get_game_score)

		local get_current_set = PresenceHelper.get_current_set()

		Presence.set_presence("set", get_current_set)
	end
end

AccountManager.set_controller_disconnected = function (arg_12_0, arg_12_1)
	-- function 12
	return
end

AccountManager.controller_disconnected = function (arg_13_0)
	-- function 13
	return
end

AccountManager.get_friends = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	if not parameter then
		arg_14_2(SteamHelper.debug_friends())
	elseif not rawget(_G, "Steam") and not rawget(_G, "Friends") then
		arg_14_2(SteamHelper.friends())
	else
		arg_14_2(nil)
	end
end

AccountManager.set_current_lobby = function (arg_15_0, arg_15_1)
	-- function 15
	return
end

AccountManager.all_sessions_cleaned_up = function (arg_16_0)
	-- function 16
	return
end

AccountManager.send_session_invitation = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	if not rawget(_G, "Steam") and not rawget(_G, "Friends") then
		Friends.invite(arg_17_1, arg_17_2)
	end
end

AccountManager.show_player_profile = function (arg_18_0, arg_18_1)
	-- function 18
	if not rawget(_G, "Steam") then
		local id_hex_to_dec = Steam.id_hex_to_dec(arg_18_1)
		local str = "http://steamcommunity.com/profiles/" .. id_hex_to_dec

		Steam.open_url(str)
	end
end

AccountManager.account_id = function (arg_19_0)
	-- function 19
	return Network.peer_id()
end

AccountManager.active_controller = function (arg_20_0)
	-- function 20
	local input = Managers.input

	if not input:is_device_active("gamepad") then
		return input:get_most_recent_device()
	end

	return nil
end

AccountManager.region = function (self)
	-- function 21
	return self._country_code
end

AccountManager.set_should_teardown_xboxlive = function (arg_22_0)
	-- function 22
	return
end

AccountManager.friends_list_initiated = function (arg_23_0)
	-- function 23
	return
end

AccountManager.check_popup_retrigger = function (arg_24_0)
	-- function 24
	return
end

AccountManager.set_offline_mode = function (arg_25_0, arg_25_1)
	-- function 25
	return
end

AccountManager.is_online = function (arg_26_0)
	-- function 26
	return not GameSettingsDevelopment.use_offline_backend
end

AccountManager.offline_mode = function (arg_27_0)
	-- function 27
	return GameSettingsDevelopment.use_offline_backend == true
end

AccountManager.has_fatal_error = function (arg_28_0)
	-- function 28
	return false
end

AccountManager.has_popup = function (arg_29_0)
	-- function 29
	return false
end

AccountManager.cancel_all_popups = function (arg_30_0)
	-- function 30
	return
end

AccountManager.has_session = function (arg_31_0)
	-- function 31
	return true
end

AccountManager.has_access = function (arg_32_0)
	-- function 32
	return false
end

AccountManager.should_throttle = function (arg_33_0)
	-- function 33
	return false
end

AccountManager.console_type_setting = function (arg_34_0)
	-- function 34
	return true
end

AccountManager.initiate_leave_game = function (arg_35_0)
	-- function 35
	return
end
