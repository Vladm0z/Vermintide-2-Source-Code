-- chunkname: @scripts/game_state/title_screen_substates/xb1/state_title_screen_load_save.lua

StateTitleScreenLoadSave = class(StateTitleScreenLoadSave)
StateTitleScreenLoadSave.NAME = "StateTitleScreenLoadSave"

StateTitleScreenLoadSave.on_enter = function (arg_1_0, arg_1_1)
	print("[Gamestate] Enter Substate StateTitleScreenLoadSave")

	arg_1_0._params = arg_1_1
	arg_1_0._world = arg_1_1.world
	arg_1_0._viewport = arg_1_1.viewport
	arg_1_0._title_start_ui = arg_1_1.ui
	arg_1_0._state = "get_user_profile"
	arg_1_0._network_event_meta_table = {}

	arg_1_0._network_event_meta_table.__index = function (arg_2_0, arg_2_1)
		return function ()
			Application.warning("Got RPC %s during forced network update when exiting StateTitleScreenMain", arg_2_1)
		end
	end

	Managers.transition:show_loading_icon(false)

	if not Managers.account:user_id() then
		arg_1_0:_close_menu()
	end

	arg_1_0:_setup_input()
end

StateTitleScreenLoadSave._setup_input = function (arg_4_0)
	arg_4_0.input_manager = Managers.input
end

StateTitleScreenLoadSave.update = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._title_start_ui

	var_5_0:update(arg_5_1, arg_5_2)
	arg_5_0:_update_network(arg_5_1, arg_5_2)

	if not Managers.account:user_detached() then
		if arg_5_0._state == "get_user_profile" then
			arg_5_0:_get_user_profile()
			var_5_0:set_information_text(Localize("loading_acquiring_user_profile"))
		elseif arg_5_0._state == "check_guest" then
			arg_5_0:_check_guest()
		elseif arg_5_0._state == "enumerate_dlc" then
			var_5_0:set_information_text(Localize("loading_checking_downloadable_content"))
			arg_5_0:_enumerate_dlc()
		elseif arg_5_0._state == "acquire_storage" then
			arg_5_0:_get_storage_space()
			var_5_0:set_information_text(Localize("loading_acquiring_storage"))
		elseif arg_5_0._state == "query_storage_spaces" then
			arg_5_0:_query_storage_spaces()
			var_5_0:set_information_text(Localize("loading_checking_save_data"))
		elseif arg_5_0._state == "load_save" then
			arg_5_0:_load_save()
			var_5_0:set_information_text(Localize("loading_loading_settings"))
		elseif arg_5_0._state == "check_popup" then
			arg_5_0:_check_popup()
		elseif arg_5_0._state == "create_save" then
			arg_5_0:_create_save()
		elseif arg_5_0._state == "delete_save" then
			arg_5_0:_delete_save()
			var_5_0:set_information_text(Localize("loading_deleting_settings"))
		end
	elseif arg_5_0._popup_id then
		arg_5_0:_check_popup()
	end

	return arg_5_0:_next_state()
end

StateTitleScreenLoadSave._update_network = function (arg_6_0, arg_6_1, arg_6_2)
	if rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized() then
		Network.update(arg_6_1, setmetatable({}, arg_6_0._network_event_meta_table))
	end
end

StateTitleScreenLoadSave._check_guest = function (arg_7_0)
	if Managers.account:is_guest() then
		arg_7_0._popup_id = Managers.popup:queue_popup(Localize("popup_is_guest"), Localize("popup_is_guest_header"), "verified_guest", Localize("menu_ok"))
		arg_7_0._state = "check_popup"
	else
		arg_7_0._state = "enumerate_dlc"
	end
end

StateTitleScreenLoadSave._get_user_profile = function (arg_8_0)
	arg_8_0._state = "waiting_for_profile"

	local var_8_0 = Managers.account:user_id()
	local var_8_1 = Managers.account:xbox_user_id()

	Managers.account:get_user_profiles(var_8_0, {
		var_8_1
	}, callback(arg_8_0, "cb_profile_acquired"))
end

StateTitleScreenLoadSave.cb_profile_acquired = function (arg_9_0, arg_9_1)
	if arg_9_1.error then
		arg_9_0._popup_id = Managers.popup:queue_popup(Localize("popup_xboxlive_profile_acquire_error"), Localize("popup_xboxlive_profile_acquire_error_header"), "profile_error", Localize("menu_ok"))
		arg_9_0._state = "check_popup"
	else
		arg_9_0._title_start_ui:set_user_name(Managers.account:my_gamertag())

		arg_9_0._state = "check_guest"
	end
end

StateTitleScreenLoadSave._enumerate_dlc = function (arg_10_0)
	XboxDLC.initialize()
	XboxDLC.enumerate_dlc()

	arg_10_0._state = "acquire_storage"
end

StateTitleScreenLoadSave._get_storage_space = function (arg_11_0)
	arg_11_0._state = "waiting_for_storage"

	Managers.account:get_storage_space(callback(arg_11_0, "cb_storage_acquired"))
end

StateTitleScreenLoadSave.cb_storage_acquired = function (arg_12_0, arg_12_1)
	if arg_12_1.error then
		arg_12_0._popup_id = Managers.popup:queue_popup(Localize("popup_storage_could_not_be_acquired"), Localize("popup_storage_could_not_be_acquired_header"), "storage_error", Localize("menu_ok"))
		arg_12_0._state = "check_popup"
	else
		arg_12_0._state = "query_storage_spaces"
	end
end

StateTitleScreenLoadSave._query_storage_spaces = function (arg_13_0)
	arg_13_0._state = "waiting_for_query"

	Managers.save:query_storage_spaces(callback(arg_13_0, "cb_query_done"))
end

StateTitleScreenLoadSave.cb_query_done = function (arg_14_0, arg_14_1)
	print("######################## QUERY ########################")

	if arg_14_1.error then
		arg_14_0._popup_id = Managers.popup:queue_popup(Localize("popup_query_storage_error"), Localize("popup_query_storage_error_header"), "query_storage_error", Localize("menu_ok"))
		arg_14_0._state = "check_popup"
	elseif arg_14_0:_save_data_contains(arg_14_1, "save_container") then
		if StateTitleScreenLoadSave.DELETE_SAVE then
			arg_14_0._state = "delete_save"
			StateTitleScreenLoadSave.DELETE_SAVE = false
		else
			arg_14_0._state = "load_save"
		end
	else
		arg_14_0._state = "create_save"
	end

	if not GameSettingsDevelopment.disable_intro_trailer and not script_data.skip_intro_trailer then
		arg_14_0.parent.parent.loading_context.first_time = true
	end
end

StateTitleScreenLoadSave._save_data_contains = function (arg_15_0, arg_15_1, arg_15_2)
	for iter_15_0, iter_15_1 in ipairs(arg_15_1) do
		if iter_15_1.name == arg_15_2 and iter_15_1.total_size > 0 then
			return true
		end
	end
end

StateTitleScreenLoadSave._load_save = function (arg_16_0)
	arg_16_0._state = "waiting_for_load"

	Managers.save:auto_load(SaveFileName, callback(arg_16_0, "cb_load_done"))
end

StateTitleScreenLoadSave.cb_load_done = function (arg_17_0, arg_17_1)
	print("######################## DATA LOADED ########################")

	if arg_17_1.error then
		arg_17_0._state = "check_popup"
		arg_17_0._popup_id = Managers.popup:queue_popup(Localize("popup_load_error_consoles"), Localize("popup_load_error_header"), "retry_load", Localize("menu_reload"), "reset_save", Localize("menu_reset"))
	elseif Managers.account:is_guest() then
		SaveData = table.clone(DefaultSaveData)

		populate_save_data(SaveData)

		arg_17_0._new_state = StateTitleScreenMainMenu
		arg_17_0._state = "none"
	else
		populate_save_data(arg_17_1)

		if arg_17_1.machine_id == nil then
			arg_17_0:_do_save()
		else
			arg_17_0._new_state = StateTitleScreenMainMenu
			arg_17_0._state = "none"
		end
	end
end

StateTitleScreenLoadSave._check_popup = function (arg_18_0)
	local var_18_0 = Managers.popup:query_result(arg_18_0._popup_id)

	if var_18_0 == "retry_load" then
		arg_18_0._state = "load_save"
	elseif var_18_0 == "reset_save" then
		arg_18_0._state = "delete_save"
	elseif var_18_0 == "profile_error" then
		arg_18_0:_close_menu()

		arg_18_0._state = "none"
	elseif var_18_0 == "storage_error" then
		arg_18_0:_close_menu()

		arg_18_0._state = "none"
	elseif var_18_0 == "query_storage_error" then
		arg_18_0:_close_menu()
		Managers.account:close_storage()

		arg_18_0._state = "none"
	elseif var_18_0 == "save_error" then
		arg_18_0:_close_menu()
		Managers.account:close_storage()

		arg_18_0._state = "none"
	elseif var_18_0 == "delete_save_error" then
		arg_18_0:_close_menu()
		Managers.account:close_storage()

		arg_18_0._state = "none"
	elseif var_18_0 == "verified_guest" then
		arg_18_0._state = "enumerate_dlc"
	elseif var_18_0 then
		fassert(false, "[StateTitleScreenLoadSave] The popup result doesn't exist (%s)", var_18_0)
	end

	if var_18_0 then
		arg_18_0._popup_id = nil
	end
end

StateTitleScreenLoadSave._create_save = function (arg_19_0)
	SaveData = table.clone(DefaultSaveData)

	arg_19_0:_do_save()
end

StateTitleScreenLoadSave._do_save = function (arg_20_0)
	ensure_user_id_in_save_data(SaveData)
	Managers.save:auto_save(SaveFileName, SaveData, callback(arg_20_0, "cb_save_done"))

	arg_20_0._state = "waiting_for_save"
end

StateTitleScreenLoadSave.cb_save_done = function (arg_21_0, arg_21_1)
	print("######################## DATA SAVED ########################")

	if arg_21_1.error then
		arg_21_0._popup_id = Managers.popup:queue_popup(Localize("popup_save_failed"), Localize("popup_save_failed_header"), "save_error", Localize("menu_ok"))
		arg_21_0._state = "check_popup"
	elseif Managers.account:is_guest() then
		SaveData = table.clone(DefaultSaveData)

		populate_save_data(SaveData)

		arg_21_0._new_state = StateTitleScreenMainMenu
		arg_21_0._state = "none"
	else
		populate_save_data(SaveData)

		arg_21_0._new_state = StateTitleScreenMainMenu
		arg_21_0._state = "none"
	end
end

StateTitleScreenLoadSave._delete_save = function (arg_22_0)
	arg_22_0._state = "waiting_for_delete"

	Managers.save:delete_save(SaveFileName, callback(arg_22_0, "cb_delete_done"))
end

StateTitleScreenLoadSave.cb_delete_done = function (arg_23_0, arg_23_1)
	print("######################## SAVE DELETED ########################")

	if arg_23_1.error then
		arg_23_0._popup_id = Managers.popup:queue_popup(Localize("popup_delete_save_failed"), Localize("popup_delete_save_failed_header"), "delete_save_error", Localize("menu_ok"))
		arg_23_0._state = "check_popup"
	else
		arg_23_0._state = "create_save"
	end
end

StateTitleScreenLoadSave._close_menu = function (arg_24_0)
	arg_24_0.parent:show_menu(false)
	arg_24_0._title_start_ui:set_start_pressed(false)

	arg_24_0._new_state = StateTitleScreenMain
	arg_24_0._state = "none"
	arg_24_0._closing_menu = true

	Managers.transition:hide_loading_icon()
end

StateTitleScreenLoadSave._next_state = function (arg_25_0)
	if not Managers.popup:has_popup() and not arg_25_0._popup_id then
		if script_data.honduras_demo and not arg_25_0._title_start_ui:is_ready() then
			return
		end

		return arg_25_0._new_state
	end
end

StateTitleScreenLoadSave.on_exit = function (arg_26_0)
	arg_26_0._title_start_ui:set_information_text("")

	arg_26_0._popup_id = nil
end
