-- chunkname: @scripts/managers/account/account_manager_win32.lua

require("scripts/managers/account/presence/presence_helper")

AccountManager = class(AccountManager)
AccountManager.VERSION = "win32"

local var_0_0 = Development.parameter("debug_friends_list")

local function var_0_1(...)
	print("[AccountManager] ", ...)
end

AccountManager.init = function (arg_2_0)
	if HAS_STEAM then
		arg_2_0._initial_user_id = Steam.user_id()
	end

	if DEDICATED_SERVER then
		arg_2_0._country_code = string.lower(SteamGameServer.country_code())
	elseif HAS_STEAM then
		arg_2_0._country_code = string.lower(Steam.user_country_code())
	end
end

AccountManager.user_id = function (arg_3_0)
	return arg_3_0._initial_user_id
end

AccountManager.update = function (arg_4_0, arg_4_1)
	return
end

AccountManager.sign_in = function (arg_5_0, arg_5_1)
	Managers.state.event:trigger("account_user_signed_in")
end

AccountManager.num_signed_in_users = function (arg_6_0)
	return 1
end

AccountManager.user_detached = function (arg_7_0)
	return false
end

AccountManager.acitve_controller = function (arg_8_0)
	return
end

AccountManager.leaving_game = function (arg_9_0)
	return
end

AccountManager.reset = function (arg_10_0)
	return
end

AccountManager.update_presence = function (arg_11_0)
	if DEDICATED_SERVER or not rawget(_G, "Presence") then
		return
	end

	local var_11_0 = Managers.level_transition_handler:in_hub_level()
	local var_11_1 = Managers.state
	local var_11_2 = var_11_1 and var_11_1.network
	local var_11_3 = var_11_2 and var_11_2:lobby()

	if not var_11_3 then
		return
	end

	local var_11_4 = Managers.player.is_server and var_11_3:get_stored_lobby_data() or LobbyInternal.get_lobby_data_from_id(var_11_3:id())

	if not var_11_4 then
		return
	end

	local var_11_5 = Managers.mechanism:current_mechanism_name()

	if var_11_0 then
		Presence.set_presence("steam_display", to_boolean(script_data["eac-untrusted"]) and "#presence_modded_hub" or "#presence_official_hub")
		Presence.set_presence("steam_player_group_size", PresenceHelper.lobby_num_players())
		Presence.set_presence("hub_string", PresenceHelper.get_hub_presence())
		Presence.set_presence("level", PresenceHelper.lobby_level())
	elseif var_11_5 ~= "versus" then
		Presence.set_presence("steam_display", to_boolean(script_data["eac-untrusted"]) and "#presence_modded" or "#presence_official")
		Presence.set_presence("steam_player_group", var_11_3:id())
		Presence.set_presence("steam_player_group_size", PresenceHelper.lobby_num_players())
		Presence.set_presence("gamemode", PresenceHelper.lobby_gamemode(var_11_4))
		Presence.set_presence("difficulty", PresenceHelper.lobby_difficulty())
		Presence.set_presence("level", PresenceHelper.lobby_level())
	else
		Presence.set_presence("steam_display", "#presence_versus_official")

		local var_11_6 = PresenceHelper.lobby_num_players()

		Presence.set_presence("steam_player_group_size", var_11_6)

		local var_11_7 = PresenceHelper.lobby_gamemode(var_11_4)

		Presence.set_presence("gamemode", var_11_7)

		local var_11_8 = PresenceHelper.lobby_level()

		Presence.set_presence("level", var_11_8)

		local var_11_9 = PresenceHelper.get_side()

		Presence.set_presence("side", var_11_9)

		local var_11_10 = PresenceHelper.get_game_score()

		Presence.set_presence("score", var_11_10)

		local var_11_11 = PresenceHelper.get_current_set()

		Presence.set_presence("set", var_11_11)
	end
end

AccountManager.set_controller_disconnected = function (arg_12_0, arg_12_1)
	return
end

AccountManager.controller_disconnected = function (arg_13_0)
	return
end

AccountManager.get_friends = function (arg_14_0, arg_14_1, arg_14_2)
	if var_0_0 then
		arg_14_2(SteamHelper.debug_friends())
	elseif rawget(_G, "Steam") and rawget(_G, "Friends") then
		arg_14_2(SteamHelper.friends())
	else
		arg_14_2(nil)
	end
end

AccountManager.set_current_lobby = function (arg_15_0, arg_15_1)
	return
end

AccountManager.all_sessions_cleaned_up = function (arg_16_0)
	return
end

AccountManager.send_session_invitation = function (arg_17_0, arg_17_1, arg_17_2)
	if rawget(_G, "Steam") and rawget(_G, "Friends") then
		Friends.invite(arg_17_1, arg_17_2)
	end
end

AccountManager.show_player_profile = function (arg_18_0, arg_18_1)
	if rawget(_G, "Steam") then
		local var_18_0 = Steam.id_hex_to_dec(arg_18_1)
		local var_18_1 = "http://steamcommunity.com/profiles/" .. var_18_0

		Steam.open_url(var_18_1)
	end
end

AccountManager.account_id = function (arg_19_0)
	return Network.peer_id()
end

AccountManager.active_controller = function (arg_20_0)
	local var_20_0 = Managers.input

	if var_20_0:is_device_active("gamepad") then
		return var_20_0:get_most_recent_device()
	end

	return nil
end

AccountManager.region = function (arg_21_0)
	return arg_21_0._country_code
end

AccountManager.set_should_teardown_xboxlive = function (arg_22_0)
	return
end

AccountManager.friends_list_initiated = function (arg_23_0)
	return
end

AccountManager.check_popup_retrigger = function (arg_24_0)
	return
end

AccountManager.set_offline_mode = function (arg_25_0, arg_25_1)
	return
end

AccountManager.is_online = function (arg_26_0)
	return not GameSettingsDevelopment.use_offline_backend
end

AccountManager.offline_mode = function (arg_27_0)
	return GameSettingsDevelopment.use_offline_backend == true
end

AccountManager.has_fatal_error = function (arg_28_0)
	return false
end

AccountManager.has_popup = function (arg_29_0)
	return false
end

AccountManager.cancel_all_popups = function (arg_30_0)
	return
end

AccountManager.has_session = function (arg_31_0)
	return true
end

AccountManager.has_access = function (arg_32_0)
	return false
end

AccountManager.should_throttle = function (arg_33_0)
	return false
end

AccountManager.console_type_setting = function (arg_34_0)
	return true
end

AccountManager.initiate_leave_game = function (arg_35_0)
	return
end
