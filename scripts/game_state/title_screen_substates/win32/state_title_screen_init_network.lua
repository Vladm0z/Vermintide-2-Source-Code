-- chunkname: @scripts/game_state/title_screen_substates/win32/state_title_screen_init_network.lua

require("scripts/game_state/state_loading")

StateTitleScreenInitNetwork = class(StateTitleScreenInitNetwork)
StateTitleScreenInitNetwork.NAME = "StateTitleScreenInitNetwork"

StateTitleScreenInitNetwork.on_enter = function (self, arg_1_1)
	-- function 1
	print("[Gamestate] Enter Substate StateTitleScreenInitNetwork")

	self._params = arg_1_1
	self._title_start_ui = arg_1_1.ui
	self._save_data_loaded = false

	local loading_context = self.parent.parent.loading_context
	local loading_view = loading_context.loading_view

	if not loading_view then
		loading_view:destroy()

		loading_context.loading_view = nil
	end

	self:_load_save_data()
	Managers.transition:show_loading_icon(false)

	local backend = Managers.backend

	if not backend:is_disconnected() then
		backend:reset()
	end
end

StateTitleScreenInitNetwork._load_save_data = function (arg_2_0)
	-- function 2
	print("[StateTitleScreenInitNetwork] SaveFileName", SaveFileName)
	Managers.save:auto_load(SaveFileName, callback(arg_2_0, "cb_save_data_loaded"))
end

StateTitleScreenInitNetwork.cb_save_data_loaded = function (self, arg_3_1)
	-- function 3
	if not arg_3_1.error then
		Application.warning("Load error %q", arg_3_1.error)
	else
		populate_save_data(arg_3_1.data)
	end

	self._save_data_loaded = true
	GameSettingsDevelopment.trunk_path = Development.parameter("trunk_path")
	self.parent.parent.loading_context.restart_network = true
end

StateTitleScreenInitNetwork.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._title_start_ui then
		self._title_start_ui:update(arg_4_1, arg_4_2)
	end

	if not self._popup_id then
		self:_handle_popup()

		return
	end

	if not self:_connected_to_steam() then
		self:create_popup("failure_start_no_steam")

		return
	end

	local backend_signin_initated = self.backend_signin_initated
	local backend = Managers.backend

	if backend_signin_initated or backend:signed_in() or not self._save_data_loaded then
		backend:signin()

		self.backend_signin_initated = true
	end

	return self:_next_state()
end

StateTitleScreenInitNetwork._connected_to_steam = function (arg_5_0)
	-- function 5
	if not Development.parameter("use_lan_backend") then
		return true
	end

	local flag = true

	if IS_WINDOWS or not IS_LINUX or not rawget(_G, "Steam") then
		flag = Steam.connected()
	end

	return flag
end

StateTitleScreenInitNetwork._next_state = function (self)
	-- function 6
	local is_initialized, var_6_1 = Managers.eac:is_initialized()
	local profiles_loaded = Managers.backend:profiles_loaded()

	profiles_loaded = not profiles_loaded and not not Managers.backend:is_waiting_for_user_input() or is_initialized

	if not profiles_loaded then
		if not var_6_1 then
			self:_create_eac_error_popup(var_6_1)

			return
		end

		if GameSettingsDevelopment.skip_start_screen or not Development.parameter("skip_start_screen") then
			return StateTitleScreenLoadSave
		else
			if not (not script_data.honduras_demo and self._title_start_ui:is_ready()) then
				return
			end

			return StateTitleScreenMainMenu
		end
	end
end

StateTitleScreenInitNetwork.on_exit = function (arg_7_0, arg_7_1)
	-- function 7
	return
end

StateTitleScreenInitNetwork.create_popup = function (self, arg_8_1)
	-- function 8
	assert(arg_8_1, "[StateTitleScreenInitNetwork] No error was passed to popup handler")
	assert(self._popup_id == nil, "Tried to show popup even though we already had one.")

	local var_8_0 = Localize("popup_steam_error_header")
	local var_8_1 = Localize(arg_8_1)

	self._popup_id = Managers.popup:queue_popup(var_8_1, var_8_0, "retry", Localize("button_retry"), "quit", Localize("menu_quit"))
end

StateTitleScreenInitNetwork._create_eac_error_popup = function (self, arg_9_1)
	-- function 9
	assert(arg_9_1, "[StateTitleScreenInitNetwork] No error was passed to popup handler")
	assert(self._popup_id == nil, "Tried to show popup even though we already had one.")

	local var_9_0 = Localize("popup_eac_error_header")

	self._popup_id = Managers.popup:queue_popup(arg_9_1, var_9_0, "quit", Localize("menu_quit"))
end

StateTitleScreenInitNetwork._handle_popup = function (self)
	-- function 10
	local query_result = Managers.popup:query_result(self._popup_id)

	if query_result == "retry" then
		self._popup_id = nil
	elseif query_result == "quit" then
		Boot.quit_game = true
		self._popup_id = nil
	elseif not query_result then
		print(string.format("[StateTitleScreenInitNetwork] No such result handled (%s)", query_result))
	end
end
