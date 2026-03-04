-- chunkname: @scripts/game_state/title_screen_substates/win32/state_title_screen_init_network.lua

require("scripts/game_state/state_loading")

StateTitleScreenInitNetwork = class(StateTitleScreenInitNetwork)
StateTitleScreenInitNetwork.NAME = "StateTitleScreenInitNetwork"

StateTitleScreenInitNetwork.on_enter = function (arg_1_0, arg_1_1)
	print("[Gamestate] Enter Substate StateTitleScreenInitNetwork")

	arg_1_0._params = arg_1_1
	arg_1_0._title_start_ui = arg_1_1.ui
	arg_1_0._save_data_loaded = false

	local var_1_0 = arg_1_0.parent.parent.loading_context
	local var_1_1 = var_1_0.loading_view

	if var_1_1 then
		var_1_1:destroy()

		var_1_0.loading_view = nil
	end

	arg_1_0:_load_save_data()
	Managers.transition:show_loading_icon(false)

	local var_1_2 = Managers.backend

	if var_1_2:is_disconnected() then
		var_1_2:reset()
	end
end

StateTitleScreenInitNetwork._load_save_data = function (arg_2_0)
	print("[StateTitleScreenInitNetwork] SaveFileName", SaveFileName)
	Managers.save:auto_load(SaveFileName, callback(arg_2_0, "cb_save_data_loaded"))
end

StateTitleScreenInitNetwork.cb_save_data_loaded = function (arg_3_0, arg_3_1)
	if arg_3_1.error then
		Application.warning("Load error %q", arg_3_1.error)
	else
		populate_save_data(arg_3_1.data)
	end

	arg_3_0._save_data_loaded = true
	GameSettingsDevelopment.trunk_path = Development.parameter("trunk_path")
	arg_3_0.parent.parent.loading_context.restart_network = true
end

StateTitleScreenInitNetwork.update = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._title_start_ui then
		arg_4_0._title_start_ui:update(arg_4_1, arg_4_2)
	end

	if arg_4_0._popup_id then
		arg_4_0:_handle_popup()

		return
	end

	if not arg_4_0:_connected_to_steam() then
		arg_4_0:create_popup("failure_start_no_steam")

		return
	end

	local var_4_0 = arg_4_0.backend_signin_initated
	local var_4_1 = Managers.backend

	if not var_4_0 and not var_4_1:signed_in() and arg_4_0._save_data_loaded then
		var_4_1:signin()

		arg_4_0.backend_signin_initated = true
	end

	return arg_4_0:_next_state()
end

StateTitleScreenInitNetwork._connected_to_steam = function (arg_5_0)
	if Development.parameter("use_lan_backend") then
		return true
	end

	local var_5_0 = true

	if (IS_WINDOWS or IS_LINUX) and rawget(_G, "Steam") then
		var_5_0 = Steam.connected()
	end

	return var_5_0
end

StateTitleScreenInitNetwork._next_state = function (arg_6_0)
	local var_6_0, var_6_1 = Managers.eac:is_initialized()

	if Managers.backend:profiles_loaded() and not Managers.backend:is_waiting_for_user_input() and var_6_0 then
		if var_6_1 then
			arg_6_0:_create_eac_error_popup(var_6_1)

			return
		end

		if GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") then
			return StateTitleScreenLoadSave
		else
			if script_data.honduras_demo and not arg_6_0._title_start_ui:is_ready() then
				return
			end

			return StateTitleScreenMainMenu
		end
	end
end

StateTitleScreenInitNetwork.on_exit = function (arg_7_0, arg_7_1)
	return
end

StateTitleScreenInitNetwork.create_popup = function (arg_8_0, arg_8_1)
	assert(arg_8_1, "[StateTitleScreenInitNetwork] No error was passed to popup handler")
	assert(arg_8_0._popup_id == nil, "Tried to show popup even though we already had one.")

	local var_8_0 = Localize("popup_steam_error_header")
	local var_8_1 = Localize(arg_8_1)

	arg_8_0._popup_id = Managers.popup:queue_popup(var_8_1, var_8_0, "retry", Localize("button_retry"), "quit", Localize("menu_quit"))
end

StateTitleScreenInitNetwork._create_eac_error_popup = function (arg_9_0, arg_9_1)
	assert(arg_9_1, "[StateTitleScreenInitNetwork] No error was passed to popup handler")
	assert(arg_9_0._popup_id == nil, "Tried to show popup even though we already had one.")

	local var_9_0 = Localize("popup_eac_error_header")

	arg_9_0._popup_id = Managers.popup:queue_popup(arg_9_1, var_9_0, "quit", Localize("menu_quit"))
end

StateTitleScreenInitNetwork._handle_popup = function (arg_10_0)
	local var_10_0 = Managers.popup:query_result(arg_10_0._popup_id)

	if var_10_0 == "retry" then
		arg_10_0._popup_id = nil
	elseif var_10_0 == "quit" then
		Boot.quit_game = true
		arg_10_0._popup_id = nil
	elseif var_10_0 then
		print(string.format("[StateTitleScreenInitNetwork] No such result handled (%s)", var_10_0))
	end
end
