-- chunkname: @scripts/game_state/title_screen_substates/ps4/state_title_screen_load_save.lua

StateTitleScreenLoadSave = class(StateTitleScreenLoadSave)
StateTitleScreenLoadSave.NAME = "StateTitleScreenLoadSave"

StateTitleScreenLoadSave.on_enter = function (self, arg_1_1)
	-- function 1
	print("[Gamestate] Enter Substate StateTitleScreenLoadSave")

	self._params = arg_1_1
	self._world = arg_1_1.world
	self._viewport = arg_1_1.viewport
	self._title_start_ui = arg_1_1.ui
	self._state = "fetch_dlcs"
	self._network_event_meta_table = {}

	self._network_event_meta_table.__index = function (arg_2_0, arg_2_1)
		-- function 2
		return function ()
			-- function 3
			Application.warning("Got RPC %s during forced network update when exiting StateTitleScreenMain", arg_2_1)
		end
	end

	Managers.transition:show_loading_icon(false)

	if not Managers.account:user_id() then
		self:_close_menu()
	end

	if not Managers.backend then
		Managers.backend:reset()
	end

	self:_setup_input()
end

StateTitleScreenLoadSave._setup_input = function (self)
	-- function 4
	self.input_manager = Managers.input
end

StateTitleScreenLoadSave.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _title_start_ui = self._title_start_ui

	_title_start_ui:update(arg_5_1, arg_5_2)
	self:_update_network(arg_5_1, arg_5_2)

	if not Managers.account:user_detached() then
		if self._state == "fetch_dlcs" then
			_title_start_ui:set_information_text(Localize("loading_checking_downloadable_content"))
			self:_fetch_dlcs()
		elseif self._state == "update_fetch_dlcs" then
			self:_update_fetch_dlcs()
		elseif self._state == "load_save" then
			self:_load_save()
			_title_start_ui:set_information_text(Localize("loading_loading_settings"))
		elseif self._state == "check_popup" then
			self:_check_popup()
		elseif self._state == "create_save" then
			self:_create_save()
		elseif self._state == "delete_save" then
			self:_delete_save()
			_title_start_ui:set_information_text(Localize("loading_deleting_settings"))
		end
	elseif not self._popup_id then
		self:_check_popup()
	end

	return self:_next_state()
end

StateTitleScreenLoadSave._update_network = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not rawget(_G, "LobbyInternal") and not LobbyInternal.network_initialized() then
		Network.update(arg_6_1, setmetatable({}, self._network_event_meta_table))
	end
end

StateTitleScreenLoadSave._fetch_dlcs = function (self)
	-- function 7
	if not PS4DLC.is_initialized() then
		PS4DLC.initialize()
	end

	PS4DLC.fetch_owned_dlcs()

	self._state = "update_fetch_dlcs"
end

StateTitleScreenLoadSave._update_fetch_dlcs = function (self)
	-- function 8
	if not PS4DLC.has_fetched_dlcs() then
		if not StateTitleScreenLoadSave.DELETE_SAVE then
			self._state = "delete_save"
			StateTitleScreenLoadSave.DELETE_SAVE = nil
		else
			self._state = "load_save"
		end
	end
end

StateTitleScreenLoadSave._load_save = function (self)
	-- function 9
	self._state = "waiting_for_load"

	Managers.save:auto_load(SaveFileName, callback(self, "cb_load_done"))
end

StateTitleScreenLoadSave.cb_load_done = function (self, arg_10_1)
	-- function 10
	print("######################## DATA LOADED ########################")

	if not (not arg_10_1.error and arg_10_1.error == "NOT_FOUND") then
		if arg_10_1.error == "BROKEN" then
			self._state = "check_popup"
			self._popup_id = Managers.popup:queue_popup(Localize("popup_load_error_consoles"), Localize("popup_load_error_header"), "retry_load", Localize("menu_reload"), "reset_save", Localize("menu_reset"))
		elseif not arg_10_1.sce_error_code then
			self:_show_error_dialog(arg_10_1.sce_error_code)
		else
			self:_close_menu()
		end
	else
		local data = arg_10_1.data

		if arg_10_1.error == "NOT_FOUND" then
			SaveData = table.clone(DefaultSaveData)

			populate_save_data(SaveData)
			self:_do_save()
		else
			populate_save_data(data)

			if data.machine_id == nil then
				self:_do_save()
			else
				self._new_state = StateTitleScreenMainMenu
				self._state = "none"
			end
		end
	end
end

StateTitleScreenLoadSave._check_popup = function (self)
	-- function 11
	local query_result = Managers.popup:query_result(self._popup_id)

	if query_result == "retry_load" then
		self._state = "load_save"
	elseif query_result == "reset_save" then
		self._state = "delete_save"
	elseif query_result == "save_error" then
		self:_close_menu()

		self._state = "none"
	elseif query_result == "delete_save_error" then
		self:_close_menu()

		self._state = "none"
	elseif not query_result then
		fassert(false, "[StateTitleScreenLoadSave] The popup result doesn't exist (%s)", query_result)
	end

	if not query_result then
		self._popup_id = nil
	end
end

StateTitleScreenLoadSave._create_save = function (self)
	-- function 12
	SaveData = table.clone(DefaultSaveData)

	self:_do_save()
end

StateTitleScreenLoadSave._do_save = function (self)
	-- function 13
	ensure_user_id_in_save_data(SaveData)
	Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_save_done"))

	self._state = "waiting_for_save"
end

StateTitleScreenLoadSave.cb_save_done = function (self, arg_14_1)
	-- function 14
	print("######################## DATA SAVED ########################")

	if not arg_14_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_save_failed"), Localize("popup_save_failed_header"), "save_error", Localize("menu_ok"))
		self._state = "check_popup"
	elseif not arg_14_1.sce_error_code then
		self:_show_error_dialog(arg_14_1.sce_error_code)
	else
		populate_save_data(SaveData)

		self._new_state = StateTitleScreenMainMenu
		self._state = "none"
	end
end

StateTitleScreenLoadSave._delete_save = function (self)
	-- function 15
	self._state = "waiting_for_delete"

	Managers.save:delete_save(SaveFileName, callback(self, "cb_delete_done"))
end

StateTitleScreenLoadSave.cb_delete_done = function (self, arg_16_1)
	-- function 16
	print("######################## SAVE DELETED ########################")

	if not arg_16_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_delete_save_failed"), Localize("popup_delete_save_failed_header"), "delete_save_error", Localize("menu_ok"))
		self._state = "check_popup"
	elseif not arg_16_1.sce_error_code then
		self:_show_error_dialog(arg_16_1.sce_error_code)
	else
		self._state = "create_save"
	end
end

StateTitleScreenLoadSave._show_error_dialog = function (self, arg_17_1)
	-- function 17
	self._state = "waiting_for_error_dialog"

	Managers.system_dialog:open_error_dialog(arg_17_1, callback(self, "cb_error_dialog_done"))
end

StateTitleScreenLoadSave.cb_error_dialog_done = function (self)
	-- function 18
	self:_close_menu()
end

StateTitleScreenLoadSave._close_menu = function (self)
	-- function 19
	self.parent:show_menu(false)
	self._title_start_ui:set_start_pressed(false)

	self._new_state = StateTitleScreenMain
	self._state = "none"

	Managers.transition:hide_loading_icon()
end

StateTitleScreenLoadSave._next_state = function (self)
	-- function 20
	if not (Managers.popup:has_popup() or self._popup_id) then
		if not (not script_data.honduras_demo and self._title_start_ui:is_ready()) then
			return
		end

		return self._new_state
	end
end

StateTitleScreenLoadSave.on_exit = function (self)
	-- function 21
	self._title_start_ui:set_information_text("")

	self._popup_id = nil
end
