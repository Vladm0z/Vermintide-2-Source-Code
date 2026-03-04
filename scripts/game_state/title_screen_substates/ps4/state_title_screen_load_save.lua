-- chunkname: @scripts/game_state/title_screen_substates/ps4/state_title_screen_load_save.lua

StateTitleScreenLoadSave = class(StateTitleScreenLoadSave)
StateTitleScreenLoadSave.NAME = "StateTitleScreenLoadSave"

function StateTitleScreenLoadSave.on_enter(arg_1_0, arg_1_1)
	print("[Gamestate] Enter Substate StateTitleScreenLoadSave")

	arg_1_0._params = arg_1_1
	arg_1_0._world = arg_1_1.world
	arg_1_0._viewport = arg_1_1.viewport
	arg_1_0._title_start_ui = arg_1_1.ui
	arg_1_0._state = "fetch_dlcs"
	arg_1_0._network_event_meta_table = {}

	function arg_1_0._network_event_meta_table.__index(arg_2_0, arg_2_1)
		return function()
			Application.warning("Got RPC %s during forced network update when exiting StateTitleScreenMain", arg_2_1)
		end
	end

	Managers.transition:show_loading_icon(false)

	if not Managers.account:user_id() then
		arg_1_0:_close_menu()
	end

	if Managers.backend then
		Managers.backend:reset()
	end

	arg_1_0:_setup_input()
end

function StateTitleScreenLoadSave._setup_input(arg_4_0)
	arg_4_0.input_manager = Managers.input
end

function StateTitleScreenLoadSave.update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._title_start_ui

	var_5_0:update(arg_5_1, arg_5_2)
	arg_5_0:_update_network(arg_5_1, arg_5_2)

	if not Managers.account:user_detached() then
		if arg_5_0._state == "fetch_dlcs" then
			var_5_0:set_information_text(Localize("loading_checking_downloadable_content"))
			arg_5_0:_fetch_dlcs()
		elseif arg_5_0._state == "update_fetch_dlcs" then
			arg_5_0:_update_fetch_dlcs()
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

function StateTitleScreenLoadSave._update_network(arg_6_0, arg_6_1, arg_6_2)
	if rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized() then
		Network.update(arg_6_1, setmetatable({}, arg_6_0._network_event_meta_table))
	end
end

function StateTitleScreenLoadSave._fetch_dlcs(arg_7_0)
	if not PS4DLC.is_initialized() then
		PS4DLC.initialize()
	end

	PS4DLC.fetch_owned_dlcs()

	arg_7_0._state = "update_fetch_dlcs"
end

function StateTitleScreenLoadSave._update_fetch_dlcs(arg_8_0)
	if PS4DLC.has_fetched_dlcs() then
		if StateTitleScreenLoadSave.DELETE_SAVE then
			arg_8_0._state = "delete_save"
			StateTitleScreenLoadSave.DELETE_SAVE = nil
		else
			arg_8_0._state = "load_save"
		end
	end
end

function StateTitleScreenLoadSave._load_save(arg_9_0)
	arg_9_0._state = "waiting_for_load"

	Managers.save:auto_load(SaveFileName, callback(arg_9_0, "cb_load_done"))
end

function StateTitleScreenLoadSave.cb_load_done(arg_10_0, arg_10_1)
	print("######################## DATA LOADED ########################")

	if arg_10_1.error and arg_10_1.error ~= "NOT_FOUND" then
		if arg_10_1.error == "BROKEN" then
			arg_10_0._state = "check_popup"
			arg_10_0._popup_id = Managers.popup:queue_popup(Localize("popup_load_error_consoles"), Localize("popup_load_error_header"), "retry_load", Localize("menu_reload"), "reset_save", Localize("menu_reset"))
		elseif arg_10_1.sce_error_code then
			arg_10_0:_show_error_dialog(arg_10_1.sce_error_code)
		else
			arg_10_0:_close_menu()
		end
	else
		local var_10_0 = arg_10_1.data

		if arg_10_1.error == "NOT_FOUND" then
			SaveData = table.clone(DefaultSaveData)

			populate_save_data(SaveData)
			arg_10_0:_do_save()
		else
			populate_save_data(var_10_0)

			if var_10_0.machine_id == nil then
				arg_10_0:_do_save()
			else
				arg_10_0._new_state = StateTitleScreenMainMenu
				arg_10_0._state = "none"
			end
		end
	end
end

function StateTitleScreenLoadSave._check_popup(arg_11_0)
	local var_11_0 = Managers.popup:query_result(arg_11_0._popup_id)

	if var_11_0 == "retry_load" then
		arg_11_0._state = "load_save"
	elseif var_11_0 == "reset_save" then
		arg_11_0._state = "delete_save"
	elseif var_11_0 == "save_error" then
		arg_11_0:_close_menu()

		arg_11_0._state = "none"
	elseif var_11_0 == "delete_save_error" then
		arg_11_0:_close_menu()

		arg_11_0._state = "none"
	elseif var_11_0 then
		fassert(false, "[StateTitleScreenLoadSave] The popup result doesn't exist (%s)", var_11_0)
	end

	if var_11_0 then
		arg_11_0._popup_id = nil
	end
end

function StateTitleScreenLoadSave._create_save(arg_12_0)
	SaveData = table.clone(DefaultSaveData)

	arg_12_0:_do_save()
end

function StateTitleScreenLoadSave._do_save(arg_13_0)
	ensure_user_id_in_save_data(SaveData)
	Managers.save:auto_save(SaveFileName, SaveData, callback(arg_13_0, "cb_save_done"))

	arg_13_0._state = "waiting_for_save"
end

function StateTitleScreenLoadSave.cb_save_done(arg_14_0, arg_14_1)
	print("######################## DATA SAVED ########################")

	if arg_14_1.error then
		arg_14_0._popup_id = Managers.popup:queue_popup(Localize("popup_save_failed"), Localize("popup_save_failed_header"), "save_error", Localize("menu_ok"))
		arg_14_0._state = "check_popup"
	elseif arg_14_1.sce_error_code then
		arg_14_0:_show_error_dialog(arg_14_1.sce_error_code)
	else
		populate_save_data(SaveData)

		arg_14_0._new_state = StateTitleScreenMainMenu
		arg_14_0._state = "none"
	end
end

function StateTitleScreenLoadSave._delete_save(arg_15_0)
	arg_15_0._state = "waiting_for_delete"

	Managers.save:delete_save(SaveFileName, callback(arg_15_0, "cb_delete_done"))
end

function StateTitleScreenLoadSave.cb_delete_done(arg_16_0, arg_16_1)
	print("######################## SAVE DELETED ########################")

	if arg_16_1.error then
		arg_16_0._popup_id = Managers.popup:queue_popup(Localize("popup_delete_save_failed"), Localize("popup_delete_save_failed_header"), "delete_save_error", Localize("menu_ok"))
		arg_16_0._state = "check_popup"
	elseif arg_16_1.sce_error_code then
		arg_16_0:_show_error_dialog(arg_16_1.sce_error_code)
	else
		arg_16_0._state = "create_save"
	end
end

function StateTitleScreenLoadSave._show_error_dialog(arg_17_0, arg_17_1)
	arg_17_0._state = "waiting_for_error_dialog"

	Managers.system_dialog:open_error_dialog(arg_17_1, callback(arg_17_0, "cb_error_dialog_done"))
end

function StateTitleScreenLoadSave.cb_error_dialog_done(arg_18_0)
	arg_18_0:_close_menu()
end

function StateTitleScreenLoadSave._close_menu(arg_19_0)
	arg_19_0.parent:show_menu(false)
	arg_19_0._title_start_ui:set_start_pressed(false)

	arg_19_0._new_state = StateTitleScreenMain
	arg_19_0._state = "none"

	Managers.transition:hide_loading_icon()
end

function StateTitleScreenLoadSave._next_state(arg_20_0)
	if not Managers.popup:has_popup() and not arg_20_0._popup_id then
		if script_data.honduras_demo and not arg_20_0._title_start_ui:is_ready() then
			return
		end

		return arg_20_0._new_state
	end
end

function StateTitleScreenLoadSave.on_exit(arg_21_0)
	arg_21_0._title_start_ui:set_information_text("")

	arg_21_0._popup_id = nil
end
