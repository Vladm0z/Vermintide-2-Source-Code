-- chunkname: @scripts/managers/account/account_manager_xb1.lua

require("scripts/managers/account/presence/script_presence_xb1")
require("scripts/managers/account/leaderboards/script_leaderboards_xb1")
require("scripts/managers/account/script_connected_storage_token")
require("scripts/managers/account/script_user_profile_token")
require("scripts/managers/account/smartmatch_cleaner")
require("scripts/network/xbox_user_privileges")
require("scripts/managers/account/qos/script_qos_token")
require("scripts/managers/account/xbox_marketplace/script_xbox_marketplace")

AccountManager = class(AccountManager)
AccountManager.VERSION = "xb1"
AccountManager.SIGNED_OUT = 4294967295
AccountManager.QUERY_BANDWIDTH_TIMER = 60
AccountManager.QUERY_BANDWIDTH_FAIL_TIMER = 10
AccountManager.QUERY_FAIL_AMOUNT = 5

local function var_0_0(...)
	print("[AccountManager] ", ...)
end

local var_0_1 = {
	[XboxOne.CONSOLE_TYPE_UNKNOWN] = {
		allow_dismemberment = false,
		console_type_name = "Unknown",
		should_throttle = true
	},
	[XboxOne.CONSOLE_TYPE_XBOX_ONE] = {
		allow_dismemberment = false,
		console_type_name = "Xbox One",
		should_throttle = true
	},
	[XboxOne.CONSOLE_TYPE_XBOX_ONE_S] = {
		allow_dismemberment = false,
		console_type_name = "Xbox One S",
		should_throttle = true
	},
	[XboxOne.CONSOLE_TYPE_XBOX_ONE_X] = {
		allow_dismemberment = false,
		console_type_name = "Xbox One X",
		should_throttle = true
	},
	[XboxOne.CONSOLE_TYPE_XBOX_ONE_X_DEVKIT] = {
		allow_dismemberment = false,
		console_type_name = "Xbox One X Devkit",
		should_throttle = true
	},
	[XboxOne.CONSOLE_TYPE_XBOX_LOCKHART] = {
		allow_dismemberment = true,
		console_type_name = "Xbox Series S",
		should_throttle = false
	},
	[XboxOne.CONSOLE_TYPE_XBOX_ANACONDA] = {
		allow_dismemberment = true,
		console_type_name = "Xbox Series X",
		should_throttle = false
	},
	[XboxOne.CONSOLE_TYPE_XBOX_SERIES_X_DEVKIT] = {
		allow_dismemberment = true,
		console_type_name = "Xbox Series X Devkit",
		should_throttle = false
	}
}

function AccountManager.init(arg_2_0)
	arg_2_0._user_id = nil
	arg_2_0._controller_id = nil
	arg_2_0._achievements = nil
	arg_2_0._initiated = false
	arg_2_0._offline_mode = nil
	arg_2_0._xsts_token = nil
	arg_2_0._gamertags = {}
	arg_2_0._smartmatch_cleaner = SmartMatchCleaner:new()
	arg_2_0._xbox_privileges = XboxUserPrivileges:new()
	arg_2_0._xbox_marketplace = ScriptXboxMarketplace:new()
	arg_2_0._presence = ScriptPresence:new()
	arg_2_0._leaderboards = ScriptLeaderboards:new()
	arg_2_0._query_bandwidth_timer = AccountManager.QUERY_BANDWIDTH_TIMER
	arg_2_0._bandwidth_query_fails = 0
	arg_2_0._unlocked_achievements = {}
	arg_2_0._offline_achievement_progress = {}
	arg_2_0._social_graph_callbacks = {}

	local var_2_0 = XboxLive.region_info()

	arg_2_0._country_code = string.lower(var_2_0.GEO_ISO2)
end

function AccountManager.set_achievement_unlocked(arg_3_0, arg_3_1)
	arg_3_0._unlocked_achievements[arg_3_1] = true
end

function AccountManager.get_unlocked_achievement_list(arg_4_0)
	return arg_4_0._unlocked_achievements
end

function AccountManager.set_offline_achievement_progress(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._offline_achievement_progress[arg_5_1] = arg_5_2
end

function AccountManager.offline_achievement_progress(arg_6_0, arg_6_1)
	return arg_6_0._offline_achievement_progress[arg_6_1]
end

function AccountManager._set_user_id(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._user_id = arg_7_1
	arg_7_0._user_info = XboxLive.user_info(arg_7_1)
	arg_7_0._player_session_id = Application.guid()
	arg_7_0._active_controller = arg_7_2
	arg_7_0._controller_id = arg_7_2.controller_id()
	arg_7_0._backend_user_id = Application.make_hash(arg_7_0:xbox_user_id())

	Application.warning(string.format("[AccountManager] Console Backend User id: %s", arg_7_0._backend_user_id))

	arg_7_0._suspend_callback_id = XboxCallbacks.register_suspending_callback(callback(arg_7_0, "cb_is_suspending"))
end

function AccountManager.cb_is_suspending(arg_8_0, ...)
	print("############################ SUSPENDING")

	arg_8_0._has_suspended = true

	if Managers.state.event then
		Managers.state.event:trigger("trigger_xbox_round_end")
	end

	if Managers.xbox_events then
		Managers.xbox_events:flush()
	end

	if Managers.xbox_stats then
		Managers.xbox_stats:flush()
	end
end

function AccountManager.set_presence(arg_9_0, arg_9_1)
	arg_9_0._presence:set_presence(arg_9_1)
end

function AccountManager.set_leaderboard(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0._user_id then
		arg_10_0._leaderboards:set_leaderboard(arg_10_0._user_info.xbox_user_id, arg_10_0._player_session_id, arg_10_1, arg_10_2)
	end
end

function AccountManager.get_leaderboard(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	if arg_11_0._user_id then
		arg_11_0._leaderboards:get_leaderboard(arg_11_0._user_id, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	end
end

function AccountManager.set_round_id(arg_12_0, arg_12_1)
	arg_12_0._current_round_id = arg_12_1 or Application.guid()
end

function AccountManager.round_id(arg_13_0)
	return arg_13_0._current_round_id
end

function AccountManager.my_gamertag(arg_14_0)
	local var_14_0 = arg_14_0._user_info.xbox_user_id

	return arg_14_0._gamertags[var_14_0]
end

function AccountManager.gamertag_from_xuid(arg_15_0, arg_15_1)
	return arg_15_0._gamertags[arg_15_1]
end

function AccountManager.has_privilege(arg_16_0, arg_16_1)
	if arg_16_0._user_id then
		return arg_16_0._xbox_privileges:has_privilege(arg_16_0._user_id, arg_16_1)
	else
		return false
	end
end

function AccountManager.is_privileges_initialized(arg_17_0)
	return arg_17_0._xbox_privileges:is_initialized()
end

function AccountManager.has_privilege_error(arg_18_0)
	arg_18_0._xbox_privileges:has_error()
end

function AccountManager.get_privilege_async(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0._xbox_privileges:get_privilege_async(arg_19_0._user_id, arg_19_1, arg_19_2, arg_19_3)
end

function AccountManager.active_controller(arg_20_0, arg_20_1)
	return arg_20_0._active_controller
end

function AccountManager.is_controller_disconnected(arg_21_0)
	return arg_21_0._popup_id
end

function AccountManager.user_detached(arg_22_0)
	return arg_22_0._user_detached
end

function AccountManager.xbox_user_id(arg_23_0)
	return arg_23_0._user_info.xbox_user_id
end

function AccountManager.account_id(arg_24_0)
	return arg_24_0._user_info.xbox_user_id
end

function AccountManager.backend_user_id(arg_25_0)
	return arg_25_0._backend_user_id
end

function AccountManager.player_session_id(arg_26_0)
	return arg_26_0._player_session_id
end

function AccountManager.user_id(arg_27_0)
	return arg_27_0._user_id
end

function AccountManager.storage_id(arg_28_0)
	return arg_28_0._storage_id
end

function AccountManager.is_guest(arg_29_0)
	return arg_29_0._user_info and arg_29_0._user_info.guest
end

function AccountManager.is_online(arg_30_0)
	return not arg_30_0._offline_mode and XboxLive.online_state() == XboxOne.ONLINE
end

function AccountManager.offline_mode(arg_31_0)
	return arg_31_0._offline_mode
end

function AccountManager.set_offline_mode(arg_32_0, arg_32_1)
	arg_32_0._offline_mode = arg_32_1
end

function AccountManager.update(arg_33_0, arg_33_1)
	if arg_33_0._initiated then
		local var_33_0 = arg_33_0._user_id

		if arg_33_0._storage_token then
			arg_33_0:_handle_storage_token()
		elseif var_33_0 and not arg_33_0:leaving_game() then
			arg_33_0:_check_session()
			arg_33_0:_verify_user_integrity()
			arg_33_0:_verify_user_profile(arg_33_1)
			arg_33_0:_verify_privileges()
			arg_33_0:_verify_user_in_cache()
			arg_33_0:_update_bandwidth_query(arg_33_1)
			arg_33_0:_update_social_manager(arg_33_1)
			arg_33_0._presence:update(arg_33_1)
			arg_33_0._xbox_marketplace:update(arg_33_1)
		end
	end

	arg_33_0:_check_trigger_popups()
	arg_33_0:_process_popup_handle("_popup_id")
	arg_33_0:_process_popup_handle("_signout_popup_id")
	arg_33_0:_process_popup_handle("_privilege_popup_id")
	arg_33_0:_process_popup_handle("_xbox_live_connection_lost_popup_id")
	arg_33_0:_process_popup_handle("_not_connected_to_xbox_live_popup_id")
	arg_33_0:_update_sessions(arg_33_1)

	arg_33_0._user_cache_changed = XboxLive.user_cache_changed()
end

function AccountManager.has_popup(arg_34_0)
	return arg_34_0._popup_id or arg_34_0._signout_popup_id or arg_34_0._privilege_popup_id or arg_34_0._xbox_live_connection_lost_popup_id or arg_34_0._not_connected_to_xbox_live_popup_id
end

function AccountManager.cancel_all_popups(arg_35_0)
	arg_35_0._popup_id = nil
	arg_35_0._signout_popup_id = nil
	arg_35_0._privilege_popup_id = nil
	arg_35_0._xbox_live_connection_lost_popup_id = nil
	arg_35_0._not_connected_to_xbox_live_popup_id = nil
end

function AccountManager._check_trigger_popups(arg_36_0)
	if not arg_36_0._retrigger_popups_check then
		return
	end

	if arg_36_0._popup_id and not Managers.popup:has_popup_with_id(arg_36_0._popup_id) then
		arg_36_0._popup_id = nil

		local var_36_0 = arg_36_0._user_info.xbox_user_id
		local var_36_1 = arg_36_0._gamertags[var_36_0]
		local var_36_2 = var_36_1 and Managers.popup:fit_text_width_to_popup(var_36_1) or "?"
		local var_36_3 = string.format(Localize("controller_pairing"), var_36_2)

		arg_36_0:_create_popup(var_36_3, "controller_pairing_header", "verify_profile", "menu_retry", "restart_network", "menu_return_to_title_screen", "show_profile_picker", "menu_select_profile", true)
	end

	if arg_36_0._privilege_popup_id and not Managers.popup:has_popup_with_id(arg_36_0._privilege_popup_id) then
		arg_36_0._privilege_popup_id = Managers.popup:queue_popup(Localize("popup_xbox_live_gold_error"), Localize("popup_xbox_live_gold_error_header"), "restart_network", Localize("menu_ok"))
	end

	if arg_36_0._xbox_live_connection_lost_popup_id and not Managers.popup:has_popup_with_id(arg_36_0._xbox_live_connection_lost_popup_id) then
		arg_36_0._xbox_live_connection_lost_popup_id = Managers.popup:queue_popup(Localize("xboxlive_connection_lost"), Localize("xboxlive_connection_lost_header"), "restart_network", Localize("menu_restart"))
	end

	if arg_36_0._not_connected_to_xbox_live_popup_id and not Managers.popup:has_popup_with_id(arg_36_0._not_connected_to_xbox_live_popup_id) then
		arg_36_0._not_connected_to_xbox_live_popup_id = Managers.popup:queue_popup(Localize("failure_start_xbox_lobby_create"), Localize("xboxlive_connection_lost_header"), "acknowledged", Localize("menu_ok"))
	end

	arg_36_0._retrigger_popups_check = false
end

function AccountManager.check_popup_retrigger(arg_37_0)
	arg_37_0._retrigger_popups_check = true
end

function AccountManager._process_popup_handle(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0[arg_38_1]

	if not var_38_0 then
		return
	end

	local var_38_1 = Managers.popup:query_result(var_38_0)

	if var_38_1 then
		arg_38_0[arg_38_1] = nil

		arg_38_0:_handle_popup_result(var_38_1)
	end
end

function AccountManager.setup_friendslist(arg_39_0)
	if rawget(_G, "LobbyInternal") and LobbyInternal.client then
		local var_39_0 = {
			Social.last_social_events()
		}

		table.dump(var_39_0, nil, 2)

		if (table.contains(var_39_0, SocialEventType.RTA_DISCONNECT_ERR) or not arg_39_0._added_local_user_to_graph) and not arg_39_0._user_detached then
			local var_39_1 = arg_39_0._user_id

			if Social.add_local_user_to_graph(var_39_1) then
				arg_39_0.title_online_friends_group_id = Social.create_filtered_social_group(var_39_1, SocialPresenceFilter.TITLE_ONLINE, SocialRelationshipFilter.FRIENDS)
				arg_39_0.online_friends_group_id = Social.create_filtered_social_group(var_39_1, SocialPresenceFilter.ALL_ONLINE, SocialRelationshipFilter.FRIENDS)
				arg_39_0.offline_friends_group_id = Social.create_filtered_social_group(var_39_1, SocialPresenceFilter.ALL_OFFLINE, SocialRelationshipFilter.FRIENDS)
				arg_39_0._added_local_user_to_graph = true
			end

			return true
		end
	end
end

function AccountManager._update_social_manager(arg_40_0, arg_40_1, arg_40_2)
	if arg_40_0._added_local_user_to_graph then
		local var_40_0 = {
			Social.last_social_events()
		}

		if table.contains(var_40_0, SocialEventType.GRAPH_LOADED) then
			arg_40_0._social_graph_loaded = true

			for iter_40_0, iter_40_1 in pairs(arg_40_0._social_graph_callbacks) do
				arg_40_0:get_friends(1000, iter_40_1)
			end
		end

		if table.contains(var_40_0, SocialEventType.PRESENCE_CHANGED) then
			-- block empty
		end
	end
end

function AccountManager.friends_list_initiated(arg_41_0)
	return arg_41_0._added_local_user_to_graph
end

function AccountManager.user_cache_changed(arg_42_0)
	return arg_42_0._user_cache_changed
end

function AccountManager._update_sessions(arg_43_0, arg_43_1)
	if Network.xboxlive_client_exists() then
		arg_43_0._smartmatch_cleaner:update(arg_43_1)
	else
		arg_43_0._smartmatch_cleaner:reset()
	end

	if arg_43_0:all_sessions_cleaned_up() and arg_43_0._teardown_xboxlive then
		Application.warning("SHUTTING DOWN XBOX LIVE CLIENT")

		if Managers.voice_chat then
			Managers.voice_chat:destroy()

			Managers.voice_chat = nil
		end

		if Network.xboxlive_client_exists() then
			LobbyInternal.shutdown_xboxlive_client()
		end

		arg_43_0._smartmatch_cleaner:reset()
		arg_43_0:reset()

		arg_43_0._added_local_user_to_graph = nil
	end
end

function AccountManager._verify_user_integrity(arg_44_0)
	if arg_44_0._offline_mode == nil or arg_44_0._offline_mode or arg_44_0._signout_popup_id then
		return
	end

	if not arg_44_0:user_exists(arg_44_0._user_id) then
		arg_44_0._signout_popup_id = Managers.popup:queue_popup(Localize("profile_signed_out_header"), Localize("popup_xboxlive_profile_acquire_error_header"), "restart_network", Localize("menu_return_to_title_screen"))
	end
end

local var_0_2 = {
	xb1_mouse = true,
	xb1_keyboard = true
}

function AccountManager._verify_user_profile(arg_45_0)
	if arg_45_0._popup_id or arg_45_0._signout_popup_id then
		return
	end

	local var_45_0 = Managers.input:get_most_recent_device().type()
	local var_45_1 = var_0_2[var_45_0] or false
	local var_45_2 = arg_45_0._active_controller
	local var_45_3 = false

	if var_45_2 and not var_45_1 then
		var_45_3 = var_45_2.controller_id() ~= arg_45_0._controller_id
	end

	local var_45_4 = var_45_2 and (not var_45_1 and var_45_2.user_id() or arg_45_0._user_id)
	local var_45_5 = var_45_4 and arg_45_0:_user_id_in_cache(var_45_4) and XboxLive.user_info(var_45_4)
	local var_45_6 = not var_45_1 and var_45_2.disconnected() or false
	local var_45_7 = not var_45_1 and var_45_2.user_id() or arg_45_0._user_id

	if not var_45_2 or not var_45_7 or var_45_6 or not var_45_5 or arg_45_0._user_info.xbox_user_id ~= var_45_5.xbox_user_id or not var_45_5.signed_in or var_45_3 then
		local var_45_8 = arg_45_0._user_info.xbox_user_id
		local var_45_9 = arg_45_0._gamertags[var_45_8]
		local var_45_10 = var_45_9 and Managers.popup:fit_text_width_to_popup(var_45_9) or "?"
		local var_45_11 = string.format(Localize("controller_pairing"), var_45_10)

		if Managers.matchmaking then
			-- block empty
		end

		arg_45_0:_verify_user_in_cache()
		arg_45_0:_create_popup(var_45_11, "controller_pairing_header", "verify_profile", "menu_retry", "restart_network", "menu_return_to_title_screen", "show_profile_picker", "menu_select_profile", true)
	end
end

function AccountManager._verify_privileges(arg_46_0)
	if not XboxLive.user_info_changed() or arg_46_0._privilege_popup_id or arg_46_0:offline_mode() then
		return
	end

	if arg_46_0:has_privilege(UserPrivilege.MULTIPLAYER_SESSIONS) then
		arg_46_0._xbox_privileges:update_privilege("MULTIPLAYER_SESSIONS", callback(arg_46_0, "cb_privileges_updated"))
	end
end

function AccountManager._user_id_in_cache(arg_47_0, arg_47_1)
	local var_47_0 = {
		XboxLive.users()
	}

	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		if iter_47_1.id == arg_47_1 then
			return true
		end
	end

	return false
end

function AccountManager._verify_user_in_cache(arg_48_0)
	local var_48_0 = {
		XboxLive.users()
	}

	for iter_48_0, iter_48_1 in pairs(var_48_0) do
		if iter_48_1.id == arg_48_0._user_id then
			arg_48_0._user_detached = false

			return
		end
	end

	arg_48_0._user_detached = true
end

function AccountManager.user_exists(arg_49_0, arg_49_1)
	local var_49_0 = {
		XboxLive.users()
	}

	for iter_49_0, iter_49_1 in pairs(var_49_0) do
		if iter_49_1.id == arg_49_1 then
			return true
		end
	end

	return false
end

function AccountManager._update_bandwidth_query(arg_50_0, arg_50_1)
	if GameSettingsDevelopment.bandwidth_queries_enabled then
		if arg_50_0._query_bandwidth_timer <= 0 then
			arg_50_0:query_bandwidth()
		end

		arg_50_0._query_bandwidth_timer = arg_50_0._query_bandwidth_timer - arg_50_1
	end
end

function AccountManager.cb_privileges_updated(arg_51_0, arg_51_1)
	if not arg_51_0:has_privilege(UserPrivilege.MULTIPLAYER_SESSIONS) then
		arg_51_0._privilege_popup_id = Managers.popup:queue_popup(Localize("popup_xbox_live_gold_error"), Localize("popup_xbox_live_gold_error_header"), "restart_network", Localize("menu_ok"))
	end
end

function AccountManager._check_session(arg_52_0)
	if Network.fatal_error() and not arg_52_0._fatal_error and (not Managers.invite or not Managers.invite:has_invitation()) and (not Managers.matchmaking or not Managers.matchmaking:is_joining_friend()) and not arg_52_0:leaving_game() then
		arg_52_0._xbox_live_connection_lost_popup_id = Managers.popup:queue_popup(Localize("xboxlive_connection_lost"), Localize("xboxlive_connection_lost_header"), "restart_network", Localize("menu_restart"))
		arg_52_0._fatal_error = true
	end
end

function AccountManager.has_fatal_error(arg_53_0)
	return arg_53_0._fatal_error or Network.fatal_error()
end

function AccountManager._create_popup(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8, arg_54_9)
	Managers.input:set_all_gamepads_available()
	assert(arg_54_1, "[AccountManager] No error was passed to popup handler")

	local var_54_0 = arg_54_2 or "popup_error_topic"
	local var_54_1 = arg_54_3
	local var_54_2 = arg_54_5
	local var_54_3 = arg_54_7
	local var_54_4 = arg_54_4 and Localize(arg_54_4)
	local var_54_5 = arg_54_6 and Localize(arg_54_6)
	local var_54_6 = arg_54_8 and Localize(arg_54_8)
	local var_54_7 = arg_54_9 and arg_54_1 or Localize(arg_54_1)

	assert(arg_54_0._popup_id == nil, "Tried to show popup even though we already had one.")
	print(arg_54_1, var_54_0, var_54_1, var_54_4, var_54_2, var_54_5, var_54_3, var_54_6, arg_54_9)

	if var_54_3 and var_54_6 then
		arg_54_0._popup_id = Managers.popup:queue_popup(var_54_7, Localize(var_54_0), var_54_1, var_54_4, var_54_2, var_54_5, var_54_3, var_54_6)
	elseif var_54_2 and var_54_5 then
		arg_54_0._popup_id = Managers.popup:queue_popup(var_54_7, Localize(var_54_0), var_54_1, var_54_4, var_54_2, var_54_5)
	else
		arg_54_0._popup_id = Managers.popup:queue_popup(var_54_7, Localize(var_54_0), var_54_1, var_54_4)
	end
end

local function var_0_3(arg_55_0)
	local var_55_0 = arg_55_0._user_info.xbox_user_id
	local var_55_1 = arg_55_0._gamertags[var_55_0]
	local var_55_2 = Managers.popup:fit_text_width_to_popup(var_55_1)
	local var_55_3 = string.format(Localize("wrong_profile"), var_55_2)

	arg_55_0:_create_popup(var_55_3, "wrong_profile_header", "verify_profile", "menu_retry", "restart_network", "menu_return_to_title_screen", "show_profile_picker", "menu_select_profile", true)
end

function AccountManager.force_exit_to_title_screen(arg_56_0)
	arg_56_0._should_teardown_xboxlive = true

	arg_56_0:initiate_leave_game()
end

function AccountManager._handle_popup_result(arg_57_0, arg_57_1)
	if arg_57_1 == "verify_profile" then
		arg_57_0:verify_profile()
	elseif arg_57_1 == "acknowledged" then
		-- block empty
	elseif arg_57_1 == "restart_network" then
		arg_57_0._should_teardown_xboxlive = true

		arg_57_0:initiate_leave_game()
	elseif arg_57_1 == "show_profile_picker" then
		local var_57_0 = Managers.input:get_most_recent_device()
		local var_57_1 = tonumber(string.gsub(var_57_0._name, "Pad", ""), 10)

		XboxLive.show_account_picker(var_57_1)

		local var_57_2, var_57_3, var_57_4, var_57_5 = XboxLive.show_account_picker_result()
		local var_57_6 = 4294967295

		if var_57_2 or var_57_5 == var_57_6 then
			var_0_3(arg_57_0)

			return
		end

		arg_57_0._active_controller = var_57_0
		arg_57_0._controller_id = arg_57_0._active_controller.controller_id()

		Managers.input:set_exclusive_gamepad(arg_57_0._active_controller)

		if Managers.voice_chat then
			Managers.voice_chat:add_local_user()
		end

		arg_57_0:_verify_user_in_cache()
	else
		fassert(false, "[AccountManager] The popup result doesn't exist (%s)", arg_57_1)
	end
end

function AccountManager.restarting(arg_58_0)
	return arg_58_0._restarting
end

function AccountManager.should_teardown_xboxlive(arg_59_0)
	return arg_59_0._should_teardown_xboxlive
end

function AccountManager.set_should_teardown_xboxlive(arg_60_0)
	arg_60_0._should_teardown_xboxlive = true
end

function AccountManager.teardown_xboxlive(arg_61_0)
	arg_61_0._teardown_xboxlive = true
end

function AccountManager.update_popup_status(arg_62_0)
	if not arg_62_0._popup_id then
		return
	end

	if not Managers.popup:has_popup_with_id(arg_62_0._popup_id) then
		arg_62_0._popup_id = nil
	end
end

function AccountManager.verify_profile(arg_63_0)
	if not arg_63_0._initiated then
		return
	end

	local var_63_0 = Managers.input:get_most_recent_device()

	if not (var_63_0.user_id and var_63_0.user_id()) then
		var_0_3(arg_63_0)

		return
	end

	if XboxLive.user_info(var_63_0.user_id()).xbox_user_id == arg_63_0._user_info.xbox_user_id then
		arg_63_0._active_controller = var_63_0
		arg_63_0._controller_id = arg_63_0._active_controller.controller_id()

		Managers.input:set_exclusive_gamepad(arg_63_0._active_controller)

		if Managers.voice_chat then
			Managers.voice_chat:add_local_user()
		end

		arg_63_0:_verify_user_in_cache()

		if Managers.matchmaking then
			-- block empty
		end
	else
		var_0_3(arg_63_0)
	end
end

function AccountManager.cb_profile_signed_out(arg_64_0)
	local var_64_0 = Managers.input:get_most_recent_device()
	local var_64_1 = XboxLive.user_info(var_64_0.user_id())

	if var_64_1.xbox_user_id == arg_64_0._user_info.xbox_user_id then
		arg_64_0._active_controller = var_64_0
		arg_64_0._controller_id = arg_64_0._active_controller.controller_id()

		Managers.input:set_exclusive_gamepad(arg_64_0._active_controller)

		if Managers.voice_chat then
			Managers.voice_chat:add_local_user()
		end
	else
		print(string.format("Wrong profile: Had user_id %s - wanted user_id %s", var_64_1.xbox_user_id, arg_64_0._user_info.xbox_user_id))
	end
end

function AccountManager.sign_in(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	if not arg_65_1 then
		local var_65_0 = arg_65_0:_controller_index(arg_65_2)

		if var_65_0 then
			XboxLive.show_account_picker(var_65_0)

			return false
		end
	else
		arg_65_0:_hard_sign_in(arg_65_1, arg_65_2, arg_65_3)
	end

	return true
end

function AccountManager._controller_index(arg_66_0, arg_66_1)
	if arg_66_1 then
		local var_66_0 = arg_66_1.name()

		if string.find(var_66_0, "Xbox Controller ") then
			return tonumber(string.gsub(arg_66_1.name(), "Xbox Controller ", ""), 10) + 1
		end
	end
end

function AccountManager._hard_sign_in(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	var_0_0("Hard-sign in", arg_67_1)
	Crashify.print_property("xb1_user_id", arg_67_1)
	arg_67_0:_set_user_id(arg_67_1, arg_67_2)
	arg_67_0:_unmap_other_controllers()
	arg_67_0:_on_user_signed_in()
end

function AccountManager.set_xsts_token(arg_68_0, arg_68_1)
	arg_68_0._xsts_token = arg_68_1
end

function AccountManager.get_xsts_token(arg_69_0)
	return arg_69_0._xsts_token
end

function AccountManager._unmap_other_controllers(arg_70_0)
	Managers.input:set_exclusive_gamepad(arg_70_0._active_controller)
end

function AccountManager._on_user_signed_in(arg_71_0)
	local var_71_0 = arg_71_0._user_id

	arg_71_0._xbox_privileges:reset()
	arg_71_0._xbox_privileges:add_user(var_71_0)

	arg_71_0._initiated = true
end

function AccountManager.get_user_profiles(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
	if XboxLive.online_state() == XboxOne.ONLINE then
		local var_72_0 = Xbone.get_user_profiles(arg_72_1, arg_72_2, #arg_72_2)
		local var_72_1 = ScriptUserProfileToken:new(var_72_0)

		Managers.token:register_token(var_72_1, callback(arg_72_0, "cb_user_profiles"))

		arg_72_0._my_user_profile_cb = arg_72_3
	else
		local var_72_2 = arg_72_0._user_info
		local var_72_3 = var_72_2.xbox_user_id

		arg_72_0._gamertags[var_72_3] = var_72_2.gamertag

		arg_72_3({})
	end
end

function AccountManager.cb_user_profiles(arg_73_0, arg_73_1)
	if not arg_73_1.error then
		for iter_73_0, iter_73_1 in pairs(arg_73_1.user_profiles) do
			arg_73_0._gamertags[iter_73_0] = iter_73_1

			Crashify.print_property("xb1_xuid", iter_73_0)
			Crashify.print_property("xb1_gamertag", iter_73_1)
		end
	end

	arg_73_0._my_user_profile_cb(arg_73_1)

	arg_73_0._my_user_profile_cb = nil
end

function AccountManager._handle_storage_token(arg_74_0)
	arg_74_0._storage_token:update()

	if arg_74_0._storage_token:done() then
		local var_74_0 = arg_74_0._storage_token:info()

		arg_74_0:_storage_acquired(var_74_0)

		arg_74_0._storage_token = nil
	end
end

function AccountManager.get_storage_space(arg_75_0, arg_75_1)
	if not arg_75_0._storage_id then
		local var_75_0 = XboxConnectedStorage.get_storage_space(arg_75_0._user_id)

		arg_75_0._storage_token = ScriptConnectedStorageToken:new(XboxConnectedStorage, var_75_0)
		arg_75_0._get_storage_done_callback = arg_75_1
	else
		arg_75_1({})
	end
end

function AccountManager._storage_acquired(arg_76_0, arg_76_1)
	if arg_76_1.error then
		Application.error("[AccountManager] There was an error in the get_storage_space operation: " .. arg_76_1.error)
		arg_76_0:close_storage()
	else
		arg_76_0._storage_id = arg_76_1.storage_id
	end

	arg_76_0._get_storage_done_callback(arg_76_1)

	arg_76_0._get_storage_done_callback = nil
end

function AccountManager.add_session_to_cleanup(arg_77_0, arg_77_1)
	arg_77_0._smartmatch_cleaner:add_session(arg_77_1)
end

function AccountManager.all_sessions_cleaned_up(arg_78_0)
	return arg_78_0._smartmatch_cleaner:ready()
end

function AccountManager.initiate_leave_game(arg_79_0)
	arg_79_0._leave_game = true

	if arg_79_0:is_online() then
		Presence.set(arg_79_0._user_id, "")
	end
end

function AccountManager.leaving_game(arg_80_0)
	return arg_80_0._leave_game
end

function AccountManager.reset(arg_81_0)
	if Network.xboxlive_client_exists() and arg_81_0._user_id and arg_81_0._added_local_user_to_graph then
		Social.remove_local_user_from_graph(arg_81_0._user_id)
	end

	arg_81_0._added_local_user_to_graph = nil
	arg_81_0._social_graph_loaded = nil
	arg_81_0._user_id = nil
	arg_81_0._presence = ScriptPresence:new()
	arg_81_0._user_info = nil
	arg_81_0._offline_mode = nil
	arg_81_0._player_session_id = nil
	arg_81_0._active_controller = nil
	arg_81_0._leave_game = nil
	arg_81_0._initiated = false
	arg_81_0._storage_id = nil
	arg_81_0._fatal_error = nil
	arg_81_0._teardown_xboxlive = nil
	arg_81_0._should_teardown_xboxlive = nil
	arg_81_0._backend_user_id = nil
	arg_81_0._user_detached = nil
	arg_81_0._signout_popup_id = nil
	arg_81_0._popup_id = nil
	arg_81_0._xbox_live_connection_lost_popup_id = nil
	arg_81_0._not_connected_to_xbox_live_popup_id = nil
	arg_81_0._privilege_popup_id = nil
	arg_81_0._controller_id = nil
	arg_81_0._xsts_token = nil
	arg_81_0._bandwidth_query_fails = 0
	arg_81_0._query_bandwidth_timer = AccountManager.QUERY_BANDWIDTH_TIMER
	arg_81_0._unlocked_achievements = {}
	arg_81_0._offline_achievement_progress = {}
	arg_81_0._social_graph_callbacks = {}

	if Managers.popup then
		Managers.popup:cancel_all_popups()
	end

	if arg_81_0._suspend_callback_id then
		XboxCallbacks.unregister_callback(arg_81_0._suspend_callback_id)

		arg_81_0._suspend_callback_id = nil
	end
end

function AccountManager.destroy(arg_82_0)
	arg_82_0:close_storage()
	arg_82_0._presence:destroy()
	arg_82_0._xbox_marketplace:destroy()

	if Network.xboxlive_client_exists() then
		Network.clean_sessions()
	end
end

function AccountManager.close_storage(arg_83_0)
	print("closing storage")

	if arg_83_0._storage_id then
		XboxConnectedStorage.finish(arg_83_0._storage_id)
		print("Storage Closed")
	else
		print("Storage Not Open")
	end

	arg_83_0._storage_id = nil
	arg_83_0._storage_token = nil
end

function AccountManager.set_controller_disconnected(arg_84_0, arg_84_1)
	arg_84_0._controller_disconnected = arg_84_1
end

function AccountManager.controller_disconnected(arg_85_0)
	return arg_85_0._controller_disconnected
end

local var_0_4 = {}

function AccountManager.get_friends(arg_86_0, arg_86_1, arg_86_2)
	table.clear(var_0_4)

	if arg_86_0._added_local_user_to_graph and arg_86_0._social_graph_loaded then
		local var_86_0 = {
			Social.social_group(arg_86_0.title_online_friends_group_id)
		}
		local var_86_1 = #var_86_0
		local var_86_2 = {
			Social.social_group(arg_86_0.online_friends_group_id)
		}
		local var_86_3 = #var_86_2
		local var_86_4 = {
			Social.social_group(arg_86_0.offline_friends_group_id)
		}
		local var_86_5 = #var_86_4

		for iter_86_0 = 1, var_86_1 do
			local var_86_6 = var_86_0[iter_86_0]
			local var_86_7 = var_86_6.xbox_user_id

			var_86_6.name = var_86_6.display_name
			var_86_6.status = "online"
			var_86_6.playing_this_game = true
			var_0_4[var_86_7] = var_86_6
		end

		for iter_86_1 = 1, var_86_3 do
			local var_86_8 = var_86_2[iter_86_1]
			local var_86_9 = var_86_8.xbox_user_id

			if not var_0_4[var_86_9] then
				var_86_8.name = var_86_8.display_name
				var_86_8.status = "online"
				var_86_8.playing_this_game = false
				var_0_4[var_86_9] = var_86_8
			end
		end

		for iter_86_2 = 1, var_86_5 do
			local var_86_10 = var_86_4[iter_86_2]
			local var_86_11 = var_86_10.xbox_user_id

			var_86_10.name = var_86_10.display_name
			var_86_10.status = "offline"
			var_86_10.playing_this_game = false
			var_0_4[var_86_11] = var_86_10
		end
	else
		arg_86_0._social_graph_callbacks[#arg_86_0._social_graph_callbacks + 1] = arg_86_2
	end

	arg_86_2(var_0_4)
end

function AccountManager.send_session_invitation(arg_87_0, arg_87_1, arg_87_2)
	local var_87_0 = {
		arg_87_1
	}

	arg_87_2:invite_friends_list(var_87_0)
end

function AccountManager.set_current_lobby(arg_88_0, arg_88_1)
	return
end

function AccountManager.reset_bandwidth_query(arg_89_0)
	arg_89_0._bandwidth_query_fails = 0
	arg_89_0._query_bandwidth_timer = AccountManager.QUERY_BANDWIDTH_TIMER
end

function AccountManager.query_bandwidth(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	if arg_90_0._querying_bandwidth or not Network.xboxlive_client_exists() or Managers.voice_chat and Managers.voice_chat:bandwidth_disabled() or not GameSettingsDevelopment.bandwidth_queries_enabled then
		return
	end

	local var_90_0 = QoS.query_bandwidth(arg_90_1 or 192, arg_90_2 or 192, arg_90_3 or 5000)

	if var_90_0 then
		local var_90_1 = ScriptQoSToken:new(var_90_0)

		Managers.token:register_token(var_90_1, callback(arg_90_0, "cb_bandwidth_query"))

		arg_90_0._querying_bandwidth = true
	else
		Application.warning("[AccountManager:query_bandwidth] QUERY FAILED TO INITIALIZE")

		arg_90_0._querying_bandwidth = nil
		arg_90_0._bandwidth_query_fails = 0
		arg_90_0._query_bandwidth_timer = AccountManager.QUERY_BANDWIDTH_TIMER
	end
end

function AccountManager.cb_bandwidth_query(arg_91_0, arg_91_1)
	if arg_91_1.error then
		Application.warning("[AccountManager:query_bandwidth] FAILED! reason: " .. arg_91_1.error)

		arg_91_0._bandwidth_query_fails = arg_91_0._bandwidth_query_fails + 1
		arg_91_0._query_bandwidth_timer = AccountManager.QUERY_BANDWIDTH_FAIL_TIMER

		if arg_91_0._bandwidth_query_fails >= AccountManager.QUERY_FAIL_AMOUNT then
			if Managers.voice_chat and not Managers.voice_chat:bandwidth_disabled() then
				Managers.voice_chat:bandwitdth_disable_voip()
			end

			arg_91_0._bandwidth_query_fails = 0
			arg_91_0._query_bandwidth_timer = AccountManager.QUERY_BANDWIDTH_TIMER
		end
	else
		Application.warning("[AccountManager:query_bandwidth] : SUCCESS!")

		arg_91_0._bandwidth_query_fails = 0
		arg_91_0._query_bandwidth_timer = AccountManager.QUERY_BANDWIDTH_TIMER
	end

	arg_91_0._querying_bandwidth = nil
end

function AccountManager.show_player_profile(arg_92_0, arg_92_1)
	if not arg_92_0._user_detached then
		XboxLive.show_gamercard(arg_92_0._user_id, arg_92_1)
	end
end

function AccountManager.get_product_details(arg_93_0, arg_93_1, arg_93_2)
	if not arg_93_0._user_id or arg_93_0._offline_mode or arg_93_0._user_detached then
		arg_93_2({
			error = "Can't fetch marketplace information while being offline"
		})

		return
	end

	arg_93_0._xbox_marketplace:get_product_details(arg_93_0._user_id, arg_93_1, arg_93_2)
end

function AccountManager.console_type(arg_94_0)
	local var_94_0 = XboxOne.console_type()

	return (var_0_1[var_94_0] or var_0_1[XboxOne.CONSOLE_TYPE_UNKNOWN]).console_type_name
end

function AccountManager.should_throttle(arg_95_0)
	local var_95_0 = XboxOne.console_type()

	return (var_0_1[var_95_0] or var_0_1[XboxOne.CONSOLE_TYPE_UNKNOWN]).should_throttle
end

function AccountManager.console_type_setting(arg_96_0, arg_96_1)
	local var_96_0 = XboxOne.console_type()

	return (var_0_1[var_96_0] or var_0_1[XboxOne.CONSOLE_TYPE_UNKNOWN])[arg_96_1]
end

function AccountManager.has_session(arg_97_0)
	return true
end

function AccountManager.region(arg_98_0)
	return arg_98_0._country_code
end

function AccountManager.update_presence(arg_99_0)
	return
end
