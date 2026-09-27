-- chunkname: @scripts/game_state/title_screen_substates/xb1/state_title_screen_load_save.lua

StateTitleScreenLoadSave = class(StateTitleScreenLoadSave)
StateTitleScreenLoadSave.NAME = "StateTitleScreenLoadSave"

StateTitleScreenLoadSave.on_enter = function (self, arg_1_1)
	-- function 1
	print("[Gamestate] Enter Substate StateTitleScreenLoadSave")

	self._params = arg_1_1
	self._world = arg_1_1.world
	self._viewport = arg_1_1.viewport
	self._title_start_ui = arg_1_1.ui
	self._state = "get_user_profile"
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
		if self._state == "get_user_profile" then
			self:_get_user_profile()
			_title_start_ui:set_information_text(Localize("loading_acquiring_user_profile"))
		elseif self._state == "check_guest" then
			self:_check_guest()
		elseif self._state == "enumerate_dlc" then
			_title_start_ui:set_information_text(Localize("loading_checking_downloadable_content"))
			self:_enumerate_dlc()
		elseif self._state == "acquire_storage" then
			self:_get_storage_space()
			_title_start_ui:set_information_text(Localize("loading_acquiring_storage"))
		elseif self._state == "query_storage_spaces" then
			self:_query_storage_spaces()
			_title_start_ui:set_information_text(Localize("loading_checking_save_data"))
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

StateTitleScreenLoadSave._check_guest = function (self)
	-- function 7
	if not Managers.account:is_guest() then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_is_guest"), Localize("popup_is_guest_header"), "verified_guest", Localize("menu_ok"))
		self._state = "check_popup"
	else
		self._state = "enumerate_dlc"
	end
end

StateTitleScreenLoadSave._get_user_profile = function (self)
	-- function 8
	self._state = "waiting_for_profile"

	local user_id = Managers.account:user_id()
	local xbox_user_id = Managers.account:xbox_user_id()

	Managers.account:get_user_profiles(user_id, {
		xbox_user_id
	}, callback(self, "cb_profile_acquired"))
end

StateTitleScreenLoadSave.cb_profile_acquired = function (self, arg_9_1)
	-- function 9
	if not arg_9_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_xboxlive_profile_acquire_error"), Localize("popup_xboxlive_profile_acquire_error_header"), "profile_error", Localize("menu_ok"))
		self._state = "check_popup"
	else
		self._title_start_ui:set_user_name(Managers.account:my_gamertag())

		self._state = "check_guest"
	end
end

StateTitleScreenLoadSave._enumerate_dlc = function (self)
	-- function 10
	XboxDLC.initialize()
	XboxDLC.enumerate_dlc()

	self._state = "acquire_storage"
end

StateTitleScreenLoadSave._get_storage_space = function (self)
	-- function 11
	self._state = "waiting_for_storage"

	Managers.account:get_storage_space(callback(self, "cb_storage_acquired"))
end

StateTitleScreenLoadSave.cb_storage_acquired = function (self, arg_12_1)
	-- function 12
	if not arg_12_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_storage_could_not_be_acquired"), Localize("popup_storage_could_not_be_acquired_header"), "storage_error", Localize("menu_ok"))
		self._state = "check_popup"
	else
		self._state = "query_storage_spaces"
	end
end

StateTitleScreenLoadSave._query_storage_spaces = function (self)
	-- function 13
	self._state = "waiting_for_query"

	Managers.save:query_storage_spaces(callback(self, "cb_query_done"))
end

StateTitleScreenLoadSave.cb_query_done = function (self, arg_14_1)
	-- function 14
	print("######################## QUERY ########################")

	if not arg_14_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_query_storage_error"), Localize("popup_query_storage_error_header"), "query_storage_error", Localize("menu_ok"))
		self._state = "check_popup"
	elseif not self:_save_data_contains(arg_14_1, "save_container") then
		if not StateTitleScreenLoadSave.DELETE_SAVE then
			self._state = "delete_save"
			StateTitleScreenLoadSave.DELETE_SAVE = false
		else
			self._state = "load_save"
		end
	else
		self._state = "create_save"
	end

	if not (GameSettingsDevelopment.disable_intro_trailer or script_data.skip_intro_trailer) then
		self.parent.parent.loading_context.first_time = true
	end
end

StateTitleScreenLoadSave._save_data_contains = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	for i, v in ipairs(arg_15_1) do
		if not (v.name ~= arg_15_2 or not (v.total_size > 0)) then
			return true
		end
	end
end

StateTitleScreenLoadSave._load_save = function (self)
	-- function 16
	self._state = "waiting_for_load"

	Managers.save:auto_load(SaveFileName, callback(self, "cb_load_done"))
end

StateTitleScreenLoadSave.cb_load_done = function (self, arg_17_1)
	-- function 17
	print("######################## DATA LOADED ########################")

	if not arg_17_1.error then
		self._state = "check_popup"
		self._popup_id = Managers.popup:queue_popup(Localize("popup_load_error_consoles"), Localize("popup_load_error_header"), "retry_load", Localize("menu_reload"), "reset_save", Localize("menu_reset"))
	elseif not Managers.account:is_guest() then
		SaveData = table.clone(DefaultSaveData)

		populate_save_data(SaveData)

		self._new_state = StateTitleScreenMainMenu
		self._state = "none"
	else
		populate_save_data(arg_17_1)

		if arg_17_1.machine_id == nil then
			self:_do_save()
		else
			self._new_state = StateTitleScreenMainMenu
			self._state = "none"
		end
	end
end

StateTitleScreenLoadSave._check_popup = function (self)
	-- function 18
	local query_result = Managers.popup:query_result(self._popup_id)

	if query_result == "retry_load" then
		self._state = "load_save"
	elseif query_result == "reset_save" then
		self._state = "delete_save"
	elseif query_result == "profile_error" then
		self:_close_menu()

		self._state = "none"
	elseif query_result == "storage_error" then
		self:_close_menu()

		self._state = "none"
	elseif query_result == "query_storage_error" then
		self:_close_menu()
		Managers.account:close_storage()

		self._state = "none"
	elseif query_result == "save_error" then
		self:_close_menu()
		Managers.account:close_storage()

		self._state = "none"
	elseif query_result == "delete_save_error" then
		self:_close_menu()
		Managers.account:close_storage()

		self._state = "none"
	elseif query_result == "verified_guest" then
		self._state = "enumerate_dlc"
	elseif not query_result then
		fassert(false, "[StateTitleScreenLoadSave] The popup result doesn't exist (%s)", query_result)
	end

	if not query_result then
		self._popup_id = nil
	end
end

StateTitleScreenLoadSave._create_save = function (self)
	-- function 19
	SaveData = table.clone(DefaultSaveData)

	self:_do_save()
end

StateTitleScreenLoadSave._do_save = function (self)
	-- function 20
	ensure_user_id_in_save_data(SaveData)
	Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_save_done"))

	self._state = "waiting_for_save"
end

StateTitleScreenLoadSave.cb_save_done = function (self, arg_21_1)
	-- function 21
	print("######################## DATA SAVED ########################")

	if not arg_21_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_save_failed"), Localize("popup_save_failed_header"), "save_error", Localize("menu_ok"))
		self._state = "check_popup"
	elseif not Managers.account:is_guest() then
		SaveData = table.clone(DefaultSaveData)

		populate_save_data(SaveData)

		self._new_state = StateTitleScreenMainMenu
		self._state = "none"
	else
		populate_save_data(SaveData)

		self._new_state = StateTitleScreenMainMenu
		self._state = "none"
	end
end

StateTitleScreenLoadSave._delete_save = function (self)
	-- function 22
	self._state = "waiting_for_delete"

	Managers.save:delete_save(SaveFileName, callback(self, "cb_delete_done"))
end

StateTitleScreenLoadSave.cb_delete_done = function (self, arg_23_1)
	-- function 23
	print("######################## SAVE DELETED ########################")

	if not arg_23_1.error then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_delete_save_failed"), Localize("popup_delete_save_failed_header"), "delete_save_error", Localize("menu_ok"))
		self._state = "check_popup"
	else
		self._state = "create_save"
	end
end

StateTitleScreenLoadSave._close_menu = function (self)
	-- function 24
	self.parent:show_menu(false)
	self._title_start_ui:set_start_pressed(false)

	self._new_state = StateTitleScreenMain
	self._state = "none"
	self._closing_menu = true

	Managers.transition:hide_loading_icon()
end

StateTitleScreenLoadSave._next_state = function (self)
	-- function 25
	if not (Managers.popup:has_popup() or self._popup_id) then
		if not (not script_data.honduras_demo and self._title_start_ui:is_ready()) then
			return
		end

		return self._new_state
	end
end

StateTitleScreenLoadSave.on_exit = function (self)
	-- function 26
	self._title_start_ui:set_information_text("")

	self._popup_id = nil
end
