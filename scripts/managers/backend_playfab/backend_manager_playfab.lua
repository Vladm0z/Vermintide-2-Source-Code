-- chunkname: @scripts/managers/backend_playfab/backend_manager_playfab.lua

require("scripts/managers/backend/backend_interface_common")
require("scripts/managers/backend/data_server_queue")
require("scripts/managers/backend_playfab/backend_interface_crafting_playfab")
require("scripts/managers/backend_playfab/backend_interface_item_playfab")
require("scripts/managers/backend_playfab/tutorial_backend/backend_interface_item_tutorial")
require("scripts/managers/backend_playfab/tutorial_backend/backend_interface_hero_attributes_tutorial")
require("scripts/managers/backend_playfab/backend_interface_loot_playfab")
require("scripts/managers/backend_playfab/backend_interface_talents_playfab")
require("scripts/managers/backend_playfab/backend_interface_quests_playfab")
require("scripts/managers/backend_playfab/backend_interface_hero_attributes_playfab")
require("scripts/managers/backend_playfab/backend_interface_statistics_playfab")
require("scripts/managers/backend_playfab/backend_interface_keep_decorations_playfab")
require("scripts/managers/backend_playfab/backend_interface_live_events_playfab")
require("scripts/managers/backend_playfab/backend_interface_cdn_resources_playfab")
require("scripts/managers/backend_playfab/backend_interface_dlcs_playfab")
require("scripts/managers/backend_playfab/benchmark_backend/backend_interface_loot_benchmark")
require("scripts/managers/backend_playfab/benchmark_backend/backend_interface_statistics_benchmark")
require("scripts/managers/backend_playfab/benchmark_backend/backend_interface_quests_benchmark")
require("scripts/managers/backend/script_backend")
require("scripts/settings/equipment/item_master_list")
require("backend/error_codes")

if IS_WINDOWS or not IS_LINUX then
	require("scripts/managers/backend_playfab/script_backend_playfab")
	DLCUtils.require_list("script_backend_playfab_files")
elseif not IS_XB1 then
	require("scripts/managers/backend_playfab/script_backend_playfab_xbox")
	require("scripts/managers/backend_playfab/backend_interface_console_dlc_rewards_playfab")
elseif not IS_PS4 then
	require("scripts/managers/backend_playfab/script_backend_playfab_ps4")
	require("scripts/managers/backend_playfab/backend_interface_console_dlc_rewards_playfab")
end

cjson = cjson.stingray_init()

local testify = script_data.testify

testify = not testify and require("scripts/managers/backend_playfab/backend_manager_playfab_testify")
BackendManagerPlayFab = class(BackendManagerPlayFab)

local num = 20

BackendManagerPlayFab.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._backend_implementation = GameSettingsDevelopment.backend_settings.implementation
	self._signin = rawget(_G, arg_1_1)
	self._mirror = rawget(_G, arg_1_2)
	self._server_queue = rawget(_G, arg_1_3)
	self._interfaces = {}
	self._interfaces_created = false
	self._errors = {}
	self._in_error_state = false
	self._is_tutorial_backend = false
	self._button_retry = "button_retry"
	self._button_ok = "button_ok"
	self._button_quit = "button_quit"
	self._button_disconnected = "button_disconnected"
	self._loadout_interface_overrides = {}
	self._current_loadout_interface_override = nil
	self._talents_interface_overrides = {}
	self._current_talents_interface_override = nil
	self._total_power_level_interface_overrides = {}

	local tbl = {
		client_type = "client",
		client_version = VersionSettings.version
	}
	local flag

	flag = not MODDED_REALM and "modded" and "official"
	tbl.realm = flag
	self._metadata = tbl
end

BackendManagerPlayFab.reset = function (self)
	-- function 2
	self._errors = {}
	self._is_disconnected = false
	self._in_error_state = false

	self:_destroy_backend()
end

BackendManagerPlayFab.signin = function (self, arg_3_1)
	-- function 3
	local available = self:available()
	local _backend_plugin_loaded = self:_backend_plugin_loaded()
	local allow_local = GameSettingsDevelopment.backend_settings.allow_local
	local use_backend = GameSettingsDevelopment.use_backend

	if not (not available and not _backend_plugin_loaded and use_backend) then
		if not allow_local then
			if not (not use_backend and available) then
				local tbl = {
					reason = BACKEND_LUA_ERRORS.ERR_PLATFORM_SPECIFIC_INTERFACE_MISSING
				}

				self:_post_error(tbl)

				return
			end
		elseif not _backend_plugin_loaded then
			local tbl_2 = {
				reason = BACKEND_LUA_ERRORS.ERR_LOADING_PLUGIN
			}

			self:_post_error(tbl_2)

			return
		elseif not use_backend then
			local tbl_3 = {
				reason = BACKEND_LUA_ERRORS.ERR_USE_LOCAL_BACKEND_NOT_ALLOWED
			}

			self:_post_error(tbl_3)

			return
		else
			error("Bad backend combination")
		end
	end

	if not self._backend_signin then
		self:reset()
	end

	print("[BackendManagerPlayFab] Backend Enabled")

	self._backend_signin = self._signin:new(arg_3_1)
	self._need_signin = true
	self._signin_timeout = os.time() + num
end

BackendManagerPlayFab.on_shutdown = function (self, arg_4_1)
	-- function 4
	local function fn(arg_5_0)
		-- function 5
		local function fn(arg_6_0)
			-- function 6
			arg_4_1(arg_6_0)
		end

		if not self._backend_mirror then
			self._backend_mirror:log_player_exit(fn)
		end
	end

	return self:commit(true, fn)
end

BackendManagerPlayFab._backend_plugin_loaded = function (self)
	-- function 7
	if self._backend_implementation == "fishtank" then
		return rawget(_G, "Backend")
	elseif self._backend_implementation == "playfab" then
		return true
	end

	fassert(false, "unknown backend implementation set in backend settings")
end

BackendManagerPlayFab._create_interfaces = function (self)
	-- function 8
	local backend_settings = GameSettingsDevelopment.backend_settings

	self:_create_items_interface(backend_settings)

	if not DEDICATED_SERVER then
		self:_create_quests_interface(backend_settings)
	end

	self:_create_crafting_interface(backend_settings)
	self:_create_talents_interface(backend_settings)
	self:_create_loot_interface(backend_settings)
	self:_create_common_interface(backend_settings)
	self:_create_hero_attributes_interface(backend_settings)
	self:_create_statistics_interface(backend_settings)
	self:_create_keep_decorations_interface(backend_settings)
	self:_create_live_events_interface(backend_settings)
	self:_create_cdn_resources_interface(backend_settings)
	self:_create_dlcs_interface(backend_settings)

	if not IS_CONSOLE then
		self:_create_console_dlc_rewards_interface(backend_settings)
	end

	self:_create_dlc_interfaces(backend_settings)

	self._interfaces_created = true
end

BackendManagerPlayFab._destroy_backend = function (self)
	-- function 9
	if not self._backend_signin then
		self._backend_signin:destroy()

		self._backend_signin = nil
	end

	if not self._backend_mirror then
		self._backend_mirror:destroy()

		self._backend_mirror = nil
	end
end

BackendManagerPlayFab.item_script_type = function (arg_10_0)
	-- function 10
	return "backend"
end

BackendManagerPlayFab.get_interface = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self._interfaces[arg_11_1] then
		Application.warning("BackendManagerPlayFab:get_interface: Requesting unknown interface " .. arg_11_1)

		return nil
	end

	return self._interfaces[arg_11_1]
end

BackendManagerPlayFab.dirtify_interfaces = function (self)
	-- function 12
	local _interfaces = self._interfaces

	for k, v in pairs(_interfaces) do
		if not v.make_dirty then
			v:make_dirty()
		end
	end
end

BackendManagerPlayFab.get_data_server_queue = function (self)
	-- function 13
	return self._data_server_queue
end

BackendManagerPlayFab.is_disconnected = function (self)
	-- function 14
	return self._is_disconnected
end

BackendManagerPlayFab.is_waiting_for_user_input = function (self)
	-- function 15
	return not not self._error_dialog
end

BackendManagerPlayFab.get_title_data = function (self, arg_16_1)
	-- function 16
	local _backend_mirror = self._backend_mirror

	if not _backend_mirror then
		return _backend_mirror:get_title_data()[arg_16_1]
	end

	return nil
end

BackendManagerPlayFab.get_read_only_data = function (self, arg_17_1)
	-- function 17
	local get_read_only_data

	if not self._backend_mirror then
		get_read_only_data = self._backend_mirror:get_read_only_data(arg_17_1)

		if not get_read_only_data then
			-- Nothing
		end
	end

	get_read_only_data = nil

	::label_17_0::

	return get_read_only_data
end

BackendManagerPlayFab.start_tutorial = function (self)
	-- function 18
	fassert(self._script_backend_items_backup == nil, "Tutorial already started")
	fassert(self._script_backend_hero_attributes_backup == nil, "Tutorial already started")

	self._script_backend_items_backup = self._interfaces.items
	self._interfaces.items = BackendInterfaceItemTutorial:new()
	self._script_backend_hero_attributes_backup = self._interfaces.hero_attributes
	self._interfaces.hero_attributes = BackendInterfaceHeroAttributesTutorial:new()
	self._is_tutorial_backend = true
end

BackendManagerPlayFab.stop_tutorial = function (self)
	-- function 19
	fassert(self._script_backend_items_backup ~= nil, "Stopping tutorial without starting it")
	fassert(self._script_backend_hero_attributes_backup ~= nil, "Stopping tutorial without starting it")

	self._interfaces.items = self._script_backend_items_backup
	self._script_backend_items_backup = nil
	self._interfaces.hero_attributes = self._script_backend_hero_attributes_backup
	self._script_backend_hero_attributes_backup = nil
	self._is_tutorial_backend = false
end

BackendManagerPlayFab.is_tutorial_backend = function (self)
	-- function 20
	return self._is_tutorial_backend
end

BackendManagerPlayFab.is_benchmark_backend = function (self)
	-- function 21
	return self._benchmark_backend
end

BackendManagerPlayFab.start_benchmark = function (self)
	-- function 22
	fassert(self._benchmark_backend == nil, "Benchmark backend already started.")

	self._script_backend_items_backup = self._interfaces.items
	self._interfaces.items = BackendInterfaceItemTutorial:new()
	self._script_backend_hero_attributes_backup = self._interfaces.hero_attributes
	self._interfaces.hero_attributes = BackendInterfaceHeroAttributesTutorial:new()
	self._script_backend_loot_backup = self._interfaces.loot
	self._interfaces.loot = BackendInterfaceLootBenchmark:new()
	self._script_backend_statistics_backup = self._interfaces.statistics
	self._interfaces.statistics = BackendInterfaceStatisticsBenchmark:new()
	self._script_backend_quest_backup = self._interfaces.quests
	self._interfaces.quests = BackendInterfaceQuestsBenchmark:new()
	self._benchmark_backend = true
end

BackendManagerPlayFab.stop_benchmark = function (self)
	-- function 23
	fassert(self._benchmark_backend == true, "Benchmark has not been started.")

	self._interfaces.items = self._script_backend_items_backup
	self._script_backend_items_backup = nil
	self._interfaces.hero_attributes = self._script_backend_hero_attributes_backup
	self._script_backend_hero_attributes_backup = nil
	self._interfaces.loot = self._script_backend_loot_backup
	self._script_backend_loot_backup = nil
	self._interfaces.statistics = self._script_backend_statistics_backup
	self._script_backend_statistics_backup = nil
	self._interfaces.quests = self._script_backend_quest_backup
	self._script_backend_quest_backup = nil
	self._benchmark_backend = nil
end

BackendManagerPlayFab.add_loadout_interface_override = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	arg_24_0._loadout_interface_overrides[arg_24_1] = arg_24_2
end

BackendManagerPlayFab.set_loadout_interface_override = function (self, arg_25_1)
	-- function 25
	local _current_loadout_interface_override = self._current_loadout_interface_override
	local var_25_1 = self._loadout_interface_overrides[arg_25_1]

	var_25_1 = not var_25_1 and arg_25_1

	local flag = false

	if var_25_1 ~= _current_loadout_interface_override then
		self._current_loadout_interface_override = var_25_1
		flag = true
	end

	return flag, _current_loadout_interface_override, var_25_1
end

BackendManagerPlayFab.get_loadout_interface_by_slot = function (self, arg_26_1)
	-- function 26
	local _current_loadout_interface_override = self._current_loadout_interface_override

	if not _current_loadout_interface_override then
		return self._interfaces.items
	end

	local var_26_1 = self._loadout_interface_overrides[_current_loadout_interface_override][arg_26_1]

	return not var_26_1 and self._interfaces[var_26_1]
end

BackendManagerPlayFab.add_talents_interface_override = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	arg_27_0._talents_interface_overrides[arg_27_1] = arg_27_2
end

BackendManagerPlayFab.set_talents_interface_override = function (self, arg_28_1)
	-- function 28
	local _current_talents_interface_override = self._current_talents_interface_override
	local var_28_1 = self._talents_interface_overrides[arg_28_1]

	var_28_1 = not var_28_1 and arg_28_1

	local flag = false

	if var_28_1 ~= _current_talents_interface_override then
		self._current_talents_interface_override = var_28_1
		flag = true
	end

	return flag
end

BackendManagerPlayFab.get_talents_interface = function (self)
	-- function 29
	local _current_talents_interface_override = self._current_talents_interface_override

	if not _current_talents_interface_override then
		return self._interfaces.talents
	end

	local var_29_1 = self._talents_interface_overrides[_current_talents_interface_override]

	return self._interfaces[var_29_1]
end

BackendManagerPlayFab.set_total_power_level_interface_for_game_mode = function (arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	arg_30_0._total_power_level_interface_overrides[arg_30_1] = arg_30_2
end

BackendManagerPlayFab.get_total_power_level = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local var_31_0 = self._total_power_level_interface_overrides[arg_31_3]

	if not var_31_0 then
		return self._interfaces[var_31_0]:get_total_power_level(arg_31_1, arg_31_2)
	end

	return BackendUtils.get_hero_power_level(arg_31_1) + BackendUtils.get_average_item_power_level(arg_31_2)
end

BackendManagerPlayFab._update_state = function (self)
	-- function 32
	local backend_settings = GameSettingsDevelopment.backend_settings
	local _backend_signin = self._backend_signin

	if not backend_settings.allow_backend and not self._local_save_loaded and DEDICATED_SERVER or not self._need_signin then
		local update_signin = _backend_signin:update_signin()

		if not update_signin then
			self._need_signin = false

			self:_post_error(update_signin)
		elseif not _backend_signin:authenticated() then
			local _backend_mirror = self._backend_mirror

			if not _backend_mirror and not _backend_mirror:ready() then
				self._need_signin = false
				self._data_server_queue = self._server_queue:new()

				self:_create_interfaces(false)
			elseif not _backend_mirror then
				local get_signin_result = _backend_signin:get_signin_result()

				self._backend_mirror = self._mirror:new(get_signin_result)

				if not Managers.mechanism then
					Managers.mechanism:refresh_mechanism_setting_for_title()
				end
			end
		elseif self._signin_timeout < os.time() then
			self._need_signin = false

			local tbl = {
				reason = BACKEND_LUA_ERRORS.ERR_SIGNIN_TIMEOUT
			}

			self:_post_error(tbl)
		end
	end
end

function string_is_url(arg_33_0)
	-- function 33
	local starts_with = string.starts_with(arg_33_0, "http://")

	starts_with = starts_with or string.starts_with(arg_33_0, "https://")

	return starts_with
end

BackendManagerPlayFab._update_error_handling = function (self, arg_34_1)
	-- function 34
	if not (not (#self._errors > 0) or self._error_dialog or self._is_disconnected or DEDICATED_SERVER) then
		local remove = table.remove(self._errors, 1)

		self:_show_error_dialog(remove.reason, remove.details, remove.optional_error_topic, remove.optional_url_button, remove.errorDetails)
	end

	if not (self._error_dialog == nil or Managers.popup:has_popup_with_id(self._error_dialog)) then
		self._is_disconnected = true
		self._error_dialog = nil
	end

	if not self._error_dialog then
		local query_result = Managers.popup:query_result(self._error_dialog)

		if not query_result then
			Managers.popup:cancel_popup(self._error_dialog)

			self._error_dialog = nil

			if type(query_result) == "table" then
				if not query_result.open_url and not string_is_url(query_result.open_url) then
					Application.open_url_in_browser(query_result.open_url)
				end

				if not query_result.application_quit then
					Application.quit()
				end
			elseif query_result == self._button_disconnected then
				self._is_disconnected = true
			elseif query_result == self._button_retry then
				self._is_disconnected = true
			elseif query_result == self._button_quit then
				Application.quit()
			elseif query_result == self._button_restart then
				self._is_disconnected = true
			end
		end
	end
end

BackendManagerPlayFab._update_interface = function (self, arg_35_1, arg_35_2)
	-- function 35
	local var_35_0 = self._interfaces[arg_35_1]
	local _backend_mirror = self._backend_mirror

	if not var_35_0 and not var_35_0.update and not _backend_mirror then
		var_35_0:update(arg_35_2)
	end
end

BackendManagerPlayFab.update = function (self, arg_36_1, arg_36_2)
	-- function 36
	if not (not self:_are_profiles_loaded() and self._profiles_loaded) then
		self._profiles_loaded = true

		Managers.mechanism:backend_profiles_loaded()
	elseif self:_are_profiles_loaded() or not self._profiles_loaded then
		self._profiles_loaded = false
	end

	local backend_settings = GameSettingsDevelopment.backend_settings
	local _backend_signin = self._backend_signin
	local _backend_mirror = self._backend_mirror
	local _data_server_queue = self._data_server_queue
	local var_36_4

	if not _backend_mirror then
		var_36_4 = _backend_mirror:update(arg_36_1, arg_36_2)
	end

	if not _data_server_queue then
		_data_server_queue:update()

		var_36_4 = var_36_4 or _data_server_queue:check_for_errors()
	end

	local _interfaces = self._interfaces

	if not backend_settings.enable_sessions then
		self:_update_interface("session", arg_36_1)
	end

	self:_update_interface("items", arg_36_1)
	self:_update_interface("crafting", arg_36_1)
	self:_update_interface("talents", arg_36_1)
	self:_update_interface("loot", arg_36_1)
	self:_update_interface("quests", arg_36_1)
	self:_update_interface("deus", arg_36_1)

	if not _backend_signin then
		self:_update_state()

		if not backend_settings.enable_sessions then
			var_36_4 = var_36_4 or _interfaces.session:check_for_errors()
		end

		if not var_36_4 then
			self:_post_error(var_36_4)
		end
	end

	self:_update_error_handling(arg_36_1)

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

BackendManagerPlayFab.playfab_api_error = function (self, arg_37_1, arg_37_2)
	-- function 37
	table.dump(arg_37_1, nil, 10)

	local tbl = {
		reason = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR,
		details = arg_37_2,
		errorDetails = arg_37_1.errorDetails
	}

	self:_post_error(tbl)
end

BackendManagerPlayFab.request_timeout = function (self)
	-- function 38
	local tbl = {
		reason = BACKEND_LUA_ERRORS.ERR_REQUEST_TIMEOUT
	}

	self:_post_error(tbl, "backend_err_request_timeout")
end

BackendManagerPlayFab.commit_error = function (self)
	-- function 39
	local ERR_PLAYFAB_COMMIT_TIMEOUT = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_COMMIT_TIMEOUT
	local var_39_1
	local tbl = {
		reason = ERR_PLAYFAB_COMMIT_TIMEOUT,
		details = var_39_1
	}

	self:_post_error(tbl)
end

BackendManagerPlayFab.playfab_eac_error = function (self)
	-- function 40
	local ERR_PLAYFAB_EAC_ERROR = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_EAC_ERROR
	local var_40_1
	local tbl = {
		reason = ERR_PLAYFAB_EAC_ERROR,
		details = var_40_1
	}

	self:_post_error(tbl)
end

BackendManagerPlayFab.playfab_error = function (self, arg_41_1, arg_41_2)
	-- function 41
	local tbl = {
		reason = arg_41_1,
		details = arg_41_2
	}

	self:_post_error(tbl)
end

BackendManagerPlayFab.missing_required_dlc_error = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local ERR_PLAYFAB_MISSING_REQUIRED_DLC = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_MISSING_REQUIRED_DLC
	local tbl = {
		reason = ERR_PLAYFAB_MISSING_REQUIRED_DLC,
		details = arg_42_1,
		optional_error_topic = arg_42_2,
		optional_url_button = arg_42_3
	}

	self:_post_error(tbl, nil, true)
end

BackendManagerPlayFab.signed_in = function (self)
	-- function 43
	local _backend_signin = self._backend_signin

	if not _backend_signin and not _backend_signin:authenticated() then
		return true
	end

	return false
end

BackendManagerPlayFab.authenticated = function (self)
	-- function 44
	local _backend_signin = self._backend_signin
	local _backend_mirror = self._backend_mirror

	if not _backend_signin then
		-- Nothing
	end

	::label_44_0::

	local authenticated = _backend_signin:authenticated()

	authenticated = not authenticated and not _backend_mirror and _backend_mirror:ready()

	::label_44_1::

	return authenticated
end

BackendManagerPlayFab.has_error = function (self)
	-- function 45
	return self._in_error_state
end

BackendManagerPlayFab.error_string = function (self)
	-- function 46
	if #self._errors == 0 then
		return ""
	else
		local reason = self._errors[1].reason
		local details = self._errors[1].details
		local _reason_localize_key = self:_reason_localize_key(reason, details)

		return (Localize(_reason_localize_key))
	end
end

BackendManagerPlayFab._post_error = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	if not arg_47_3 then
		Crashify.print_exception("Backend_Error", "ERROR: %s", arg_47_2 or arg_47_1.details)
	end

	local _data_server_queue = self._data_server_queue

	if not _data_server_queue then
		_data_server_queue:clear()
	end

	local fassert = fassert
	local reason = arg_47_1.reason
	local str = "Posting error without reason, %q: %q"
	local reason_2 = arg_47_1.reason

	reason_2 = reason_2 or "nil"

	fassert(reason, str, reason_2)

	if not DEDICATED_SERVER then
		cprintf("[BackendManagerPlayFab] Playfab error: %s, %s", arg_47_1.reason, arg_47_1.details)
	end

	print("[BackendManagerPlayFab] adding error:", arg_47_1.reason, arg_47_1.details)

	self._errors[#self._errors + 1] = arg_47_1
	self._in_error_state = self:_is_fatal(arg_47_1.reason)
end

BackendManagerPlayFab._is_fatal = function (arg_48_0, arg_48_1)
	-- function 48
	return not (arg_48_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED or arg_48_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_QUEST_REFRESH_UNAVAILABLE or arg_48_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_NON_FATAL_STORE_ERROR)
end

BackendManagerPlayFab._format_ban_message = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	local var_49_0, var_49_1 = next(arg_49_2)

	if not (not var_49_1 and #var_49_1 ~= 0) then
		return ERROR_CODES[arg_49_1], arg_49_1
	end

	local var_49_2 = ERROR_CODES[arg_49_1]
	local str = ""
	local tbl = {}
	local var_49_5 = var_49_1[1]

	if var_49_5 == "Indefinite" then
		var_49_2 = "backend_err_account_banned_permanent"
	else
		local match, var_49_7, var_49_8, var_49_9, var_49_10, var_49_11 = var_49_5:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
		local time = os.time({
			year = tonumber(match),
			month = tonumber(var_49_7),
			day = tonumber(var_49_8),
			hour = tonumber(var_49_9),
			min = tonumber(var_49_10),
			sec = tonumber(var_49_11)
		})
		local date = os.date("*t")
		local time_2 = os.time(date)
		local date_2 = os.date("!*t")
		local time_3 = os.time(date_2)

		if not date.isdst then
			time_3 = time_3 - 3600
		end

		local num = time + time_2 - time_3

		str = string.format("\n%s\n", Localize("backend_err_account_banned_duration"))
		tbl[#tbl + 1] = os.date("%x", num)
		tbl[#tbl + 1] = os.date("%X", num)
	end

	if var_49_0 ~= "Unspecified reason" then
		str = string.format("%s\n%s", str, Localize("backend_err_account_banned_reason"))
		tbl[#tbl + 1] = var_49_0
	end

	return var_49_2, string.format(str, unpack(tbl))
end

BackendManagerPlayFab._reason_localize_key = function (self, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	local var_50_0

	if not arg_50_2 then
		var_50_0 = tonumber(arg_50_2)

		if not var_50_0 then
			-- Nothing
		end
	end

	var_50_0 = -1

	::label_50_0::

	if not IS_CONSOLE then
		if not self:profiles_loaded() then
			if not (not rawget(_G, "Backend") and arg_50_1 ~= Backend.ERR_AUTH) then
				if not IS_XB1 then
					return "backend_err_auth_xb1", var_50_0
				else
					return "backend_err_auth_ps4", var_50_0
				end
			elseif arg_50_1 == BACKEND_LUA_ERRORS.ERR_SIGNIN_TIMEOUT then
				return "backend_err_signin_timeout", var_50_0
			elseif arg_50_1 == BACKEND_LUA_ERRORS.ERR_REQUEST_TIMEOUT then
				return "connection_timeout", var_50_0
			elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR then
				if var_50_0 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_THIRD_PARTY_PROBLEM then
					return ERROR_CODES[var_50_0]
				end

				return "backend_err_network", var_50_0
			else
				return "backend_err_connecting", var_50_0
			end
		elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR then
			if var_50_0 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_THIRD_PARTY_PROBLEM then
				return ERROR_CODES[var_50_0], var_50_0
			end

			return "backend_err_network", var_50_0
		end
	elseif not self:profiles_loaded() then
		if not (not rawget(_G, "Backend") and arg_50_1 ~= Backend.ERR_AUTH) then
			return "backend_err_auth_steam", var_50_0
		elseif arg_50_1 == BACKEND_LUA_ERRORS.ERR_SIGNIN_TIMEOUT then
			return "backend_err_signin_timeout", var_50_0
		elseif arg_50_1 == BACKEND_LUA_ERRORS.ERR_PLATFORM_SPECIFIC_INTERFACE_MISSING then
			return "backend_err_steam_not_running", var_50_0
		elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR then
			if var_50_0 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_THIRD_PARTY_PROBLEM then
				return ERROR_CODES[var_50_0], var_50_0
			elseif var_50_0 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACCOUNT_BANNED then
				if not arg_50_3 then
					local _format_ban_message, var_50_2 = self:_format_ban_message(var_50_0, arg_50_3)

					return _format_ban_message, var_50_2
				end

				return ERROR_CODES[var_50_0], var_50_0
			end

			return "backend_err_playfab", var_50_0
		elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_EAC_ERROR then
			return "backend_err_playfab_eac", var_50_0
		elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_COMMIT_TIMEOUT then
			return "backend_err_request_timeout", var_50_0
		elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_UNSUPPORTED_VERSION_ERROR then
			return "backend_err_unsupported_version", var_50_0
		elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_MISSING_REQUIRED_DLC then
			return nil, var_50_0
		else
			return "backend_err_connecting", var_50_0
		end
	elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR then
		if var_50_0 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_THIRD_PARTY_PROBLEM then
			return ERROR_CODES[var_50_0], var_50_0
		end

		return ERROR_CODES[arg_50_1], var_50_0
	elseif not (arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_EAC_ERROR or arg_50_1 ~= BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_COMMIT_TIMEOUT) then
		return ERROR_CODES[arg_50_1], var_50_0
	elseif not (arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED or arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_QUEST_REFRESH_UNAVAILABLE or arg_50_1 ~= BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_NON_FATAL_STORE_ERROR) then
		return ERROR_CODES[arg_50_1], var_50_0
	else
		return "backend_err_network", var_50_0
	end
end

BackendManagerPlayFab._format_error_message_console = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	local tbl = {
		result = self._button_retry,
		text = Localize("button_ok")
	}
	local _reason_localize_key, var_51_2 = self:_reason_localize_key(arg_51_1, arg_51_2, arg_51_3)

	return _reason_localize_key, var_51_2, tbl
end

BackendManagerPlayFab._format_error_message_windows = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	-- function 52
	local _reason_localize_key, var_52_1 = self:_reason_localize_key(arg_52_1, arg_52_2, arg_52_4)
	local var_52_2
	local var_52_3
	local var_52_4

	if not self:profiles_loaded() then
		var_52_2 = {
			result = self._button_quit,
			text = Localize("menu_quit")
		}

		print("backend error", arg_52_1, ERROR_CODES[arg_52_1])
	elseif not (arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR or arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_EAC_ERROR or arg_52_1 ~= BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_COMMIT_TIMEOUT) then
		var_52_2 = {
			result = self._button_quit,
			text = Localize("menu_quit")
		}
	elseif not (arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED or arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_QUEST_REFRESH_UNAVAILABLE or arg_52_1 ~= BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_NON_FATAL_STORE_ERROR) then
		var_52_2 = {
			result = self._button_ok,
			text = Localize("button_ok")
		}
	else
		var_52_2 = {
			result = self._button_disconnected,
			text = Localize("button_ok")
		}
	end

	if not arg_52_3 then
		local tbl = {
			result = {
				application_quit = true,
				open_url = arg_52_3.url
			},
			text = arg_52_3.text
		}

		if not var_52_3 then
			var_52_4 = tbl
		elseif not var_52_2 then
			var_52_3 = tbl
		else
			var_52_2 = tbl
		end
	end

	return _reason_localize_key, var_52_1, var_52_2, var_52_3, var_52_4
end

BackendManagerPlayFab._show_error_dialog = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	-- function 53
	print(string.format("[BackendManagerPlayFab] Showing error dialog: %q, %q", arg_53_1 or "nil", arg_53_2 or "nil"))

	local flag = arg_53_3 or Localize("backend_error_topic")
	local var_53_1
	local var_53_2
	local var_53_3
	local var_53_4

	if not IS_CONSOLE then
		var_53_1, arg_53_2, var_53_2 = self:_format_error_message_console(arg_53_1, arg_53_2, arg_53_5)
	else
		var_53_1, arg_53_2, var_53_2, var_53_3, var_53_4 = self:_format_error_message_windows(arg_53_1, arg_53_2, arg_53_4, arg_53_5)
	end

	local var_53_5

	if not var_53_1 then
		var_53_5 = Localize(var_53_1)

		if not var_53_5 then
			-- Nothing
		end
	end

	var_53_5 = Localize("backend_err_playfab")

	::label_53_0::

	if not IS_WINDOWS then
		if not var_53_5 and not arg_53_2 then
			var_53_5 = var_53_5 .. "\n" .. arg_53_2
		elseif not arg_53_2 then
			var_53_5 = arg_53_2
		end
	end

	if not var_53_4 then
		self._error_dialog = Managers.popup:queue_popup(var_53_5, flag, var_53_2.result, var_53_2.text, var_53_3.result, var_53_3.text, var_53_4.result, var_53_4.text)
	elseif not var_53_3 then
		self._error_dialog = Managers.popup:queue_popup(var_53_5, flag, var_53_2.result, var_53_2.text, var_53_3.result, var_53_3.text)
	else
		self._error_dialog = Managers.popup:queue_popup(var_53_5, flag, var_53_2.result, var_53_2.text)
	end
end

BackendManagerPlayFab.get_stats = function (self)
	-- function 54
	if not self._backend_mirror then
		return self._backend_mirror:get_stats()
	else
		return self._save_data.stats
	end
end

BackendManagerPlayFab.set_stats = function (self, arg_55_1)
	-- function 55
	if not self._backend_mirror then
		return self._backend_mirror:set_stats(arg_55_1)
	else
		self._save_data.stats = arg_55_1
	end
end

BackendManagerPlayFab.get_user_data = function (self, arg_56_1)
	-- function 56
	if not self._backend_mirror then
		return self._backend_mirror:get_user_data(arg_56_1)
	else
		return self._save_data.user_data[arg_56_1]
	end
end

BackendManagerPlayFab.set_user_data = function (self, arg_57_1, arg_57_2)
	-- function 57
	if not self._backend_mirror then
		self._backend_mirror:set_user_data(arg_57_1, arg_57_2)
	else
		self._save_data.user_data[arg_57_1] = arg_57_2
	end
end

BackendManagerPlayFab.available = function (arg_58_0)
	-- function 58
	local backend_settings = GameSettingsDevelopment.backend_settings

	if IS_WINDOWS or not IS_LINUX then
		local DEDICATED_SERVER

		if rawget(_G, "Steam") == nil then
			DEDICATED_SERVER = DEDICATED_SERVER

			if not DEDICATED_SERVER then
				DEDICATED_SERVER = Development.parameter("use_lan_backend")
			end

			if false then
				DEDICATED_SERVER = false
			end
		else
			DEDICATED_SERVER = true
		end

		return DEDICATED_SERVER
	elseif not IS_XB1 then
		return true
	elseif not IS_PS4 then
		return true
	end

	return false
end

BackendManagerPlayFab.commit = function (self, arg_59_1, arg_59_2)
	-- function 59
	if not self._backend_mirror then
		return self._backend_mirror:commit(arg_59_1, arg_59_2)
	end
end

BackendManagerPlayFab.has_loaded = function (self)
	-- function 60
	local _local_save_loaded = self._local_save_loaded

	_local_save_loaded = _local_save_loaded or DEDICATED_SERVER

	return _local_save_loaded
end

BackendManagerPlayFab._are_profiles_loaded = function (self)
	-- function 61
	local _backend_signin = self._backend_signin
	local _backend_mirror = self._backend_mirror
	local authenticated

	if not self._disable_backend then
		if not _backend_signin then
			-- Nothing
		end

		::label_61_0::

		authenticated = _backend_signin:authenticated()

		if not authenticated and not _backend_mirror then
			-- Nothing
		end

		::label_61_1::

		authenticated = _backend_mirror:ready()

		if not authenticated then
			-- Nothing
		end
	end

	authenticated = self:_interfaces_ready()

	::label_61_2::

	return authenticated
end

BackendManagerPlayFab.profiles_loaded = function (self)
	-- function 62
	return self._profiles_loaded
end

BackendManagerPlayFab.interfaces_ready = function (self)
	-- function 63
	return self:_interfaces_ready()
end

BackendManagerPlayFab._interfaces_ready = function (self)
	-- function 64
	if not self._interfaces_created then
		return false
	end

	if not self._interfaces then
		return false
	end

	local _interfaces = self._interfaces

	for k, v in pairs(_interfaces) do
		if not v:ready() then
			return false
		end
	end

	return true
end

BackendManagerPlayFab.refresh_log_level = function (arg_65_0)
	-- function 65
	print("[BackendManagerPlayFab] No backend to set log level on!")
end

BackendManagerPlayFab.logout = function (arg_66_0)
	-- function 66
	error("[BackendManagerPlayFab] Not implemented yet")
end

BackendManagerPlayFab.disconnect = function (arg_67_0)
	-- function 67
	error("[BackendManagerPlayFab] Not implemented yet")
end

BackendManagerPlayFab.destroy = function (self)
	-- function 68
	if not self._interfaces.quests then
		self._interfaces.quests:delete()
	end

	local _backend_mirror = self._backend_mirror

	if not _backend_mirror then
		_backend_mirror:wait_for_shutdown(1)
	end
end

BackendManagerPlayFab.implementation = function (self)
	-- function 69
	return self._backend_implementation
end

BackendManagerPlayFab._create_items_interface = function (self, arg_70_1)
	-- function 70
	local _backend_implementation = self._backend_implementation

	if _backend_implementation == "playfab" then
		self._interfaces.items = BackendInterfaceItemPlayfab:new(self._backend_mirror)
	elseif _backend_implementation == "fishtank" then
		self._interfaces.items = BackendInterfaceItem:new()
	end
end

BackendManagerPlayFab._create_quests_interface = function (self, arg_71_1)
	-- function 71
	local _backend_implementation = self._backend_implementation

	if _backend_implementation == "playfab" then
		self._interfaces.quests = BackendInterfaceQuestsPlayfab:new(self._backend_mirror)
	elseif _backend_implementation == "fishtank" then
		self._interfaces.quests = BackendInterfaceQuests:new()
	end
end

BackendManagerPlayFab._create_crafting_interface = function (self, arg_72_1)
	-- function 72
	local _backend_implementation = self._backend_implementation

	if _backend_implementation == "playfab" then
		self._interfaces.crafting = BackendInterfaceCraftingPlayfab:new(self._backend_mirror)
	elseif _backend_implementation == "fishtank" then
		self._interfaces.crafting = BackendInterfaceCrafting:new()
	end
end

BackendManagerPlayFab._create_talents_interface = function (self, arg_73_1)
	-- function 73
	local _backend_implementation = self._backend_implementation

	if _backend_implementation == "playfab" then
		self._interfaces.talents = BackendInterfaceTalentsPlayfab:new(self._backend_mirror)
	elseif _backend_implementation == "fishtank" then
		self._interfaces.talents = BackendInterfaceTalents:new()
	end
end

BackendManagerPlayFab._create_loot_interface = function (self, arg_74_1)
	-- function 74
	local _backend_implementation = self._backend_implementation

	if _backend_implementation == "playfab" then
		self._interfaces.loot = BackendInterfaceLootPlayfab:new(self._backend_mirror)
	elseif _backend_implementation == "fishtank" then
		self._interfaces.loot = BackendInterfaceLootLocal:new(self._save_data)
	end
end

BackendManagerPlayFab._create_common_interface = function (self, arg_75_1)
	-- function 75
	self._interfaces.common = BackendInterfaceCommon:new(self._backend_mirror)
end

BackendManagerPlayFab._create_hero_attributes_interface = function (self, arg_76_1)
	-- function 76
	local _backend_implementation = self._backend_implementation

	if _backend_implementation == "playfab" then
		self._interfaces.hero_attributes = BackendInterfaceHeroAttributesPlayFab:new(self._backend_mirror)
	elseif _backend_implementation == "fishtank" then
		self._interfaces.hero_attributes = BackendInterfaceHeroAttributesLocal:new(self._save_data)
	end
end

BackendManagerPlayFab._create_statistics_interface = function (self, arg_77_1)
	-- function 77
	self._interfaces.statistics = BackendInterfaceStatisticsPlayFab:new(self._backend_mirror)
end

BackendManagerPlayFab._create_keep_decorations_interface = function (self, arg_78_1)
	-- function 78
	self._interfaces.keep_decorations = BackendInterfaceKeepDecorationsPlayFab:new(self._backend_mirror)
end

BackendManagerPlayFab._create_live_events_interface = function (self, arg_79_1)
	-- function 79
	self._interfaces.live_events = BackendInterfaceLiveEventsPlayfab:new(self._backend_mirror)
end

BackendManagerPlayFab._create_console_dlc_rewards_interface = function (self, arg_80_1)
	-- function 80
	self._interfaces.console_dlc_rewards = BackendInterfaceConsoleDlcRewardsPlayfab:new(self._backend_mirror)
end

BackendManagerPlayFab._create_dlcs_interface = function (self, arg_81_1)
	-- function 81
	self._interfaces.dlcs = BackendInterfaceDLCsPlayfab:new(self._backend_mirror)
end

BackendManagerPlayFab._create_dlc_interfaces = function (self, arg_82_1)
	-- function 82
	local _interfaces = self._interfaces
	local _save_data = self._save_data
	local _backend_mirror = self._backend_mirror

	for k, v in pairs(DLCSettings) do
		local backend_interfaces = v.backend_interfaces

		if not backend_interfaces then
			for k_2, v_2 in pairs(backend_interfaces) do
				local DEDICATED_SERVER = DEDICATED_SERVER

				DEDICATED_SERVER = not DEDICATED_SERVER and v_2.ignore_on_dedicated_server

				if not DEDICATED_SERVER then
					local var_82_5
					local playfab_file = v_2.playfab_file

					require(playfab_file)

					local playfab_class = v_2.playfab_class

					_interfaces[k_2] = rawget(_G, playfab_class):new(_backend_mirror)
				end
			end
		end
	end
end

BackendManagerPlayFab._create_cdn_resources_interface = function (self, arg_83_1)
	-- function 83
	self._interfaces.cdn = BackendInterfaceCdnResourcesPlayFab:new(self._backend_mirror)

	local language_id = Managers.localizer:language_id()

	self._interfaces.cdn:load_backend_localizations(language_id, callback(self, "_cb_backend_localizations_loaded"))
end

BackendManagerPlayFab._cb_backend_localizations_loaded = function (arg_84_0, arg_84_1)
	-- function 84
	if not arg_84_1 then
		Managers.localizer:append_backend_localizations(arg_84_1)
	end
end

BackendManagerPlayFab.player_id = function (self)
	-- function 85
	local _backend_signin = self._backend_signin

	if not _backend_signin then
		return "-"
	end

	return _backend_signin:get_signin_result().PlayFabId
end

BackendManagerPlayFab.switch_mechanism = function (self, arg_86_1)
	-- function 86
	self._backend_mirror:set_mechanism(arg_86_1)
end

BackendManagerPlayFab.load_mechanism_loadout = function (self, arg_87_1)
	-- function 87
	self._backend_mirror:request_characters(arg_87_1)
end

BackendManagerPlayFab.is_pending_request = function (self)
	-- function 88
	local _backend_mirror = self._backend_mirror
	local is_pending_request

	if not _backend_mirror then
		is_pending_request = _backend_mirror:request_queue():is_pending_request()

		if not is_pending_request then
			-- Nothing
		end
	end

	is_pending_request = false

	::label_88_0::

	return is_pending_request
end

BackendManagerPlayFab.is_mirror_ready = function (self)
	-- function 89
	local _backend_mirror = self._backend_mirror

	if not _backend_mirror then
		-- Nothing
	end

	::label_89_0::

	local ready = _backend_mirror:ready()

	ready = not ready and not not _backend_mirror:get_current_commit_id() or not _backend_mirror:have_queued_commit()

	::label_89_1::

	return ready
end

local tbl = {}

BackendManagerPlayFab.get_level_variation_data = function (self)
	-- function 90
	if not self._backend_mirror then
		return tbl
	end

	local level_variation_data = self._backend_mirror:get_title_data().level_variation_data

	return not level_variation_data and cjson.decode(level_variation_data) or tbl
end

BackendManagerPlayFab.get_deus_weapon_preload_settings = function (self)
	-- function 91
	if not self._backend_mirror then
		return tbl
	end

	local deus_weapon_preload_settings = self._backend_mirror:get_title_data().deus_weapon_preload_settings

	return not deus_weapon_preload_settings and cjson.decode(deus_weapon_preload_settings) or tbl
end

BackendManagerPlayFab.get_title_settings = function (self)
	-- function 92
	if not self._backend_mirror then
		return tbl
	end

	local title_settings = self._backend_mirror:get_title_data().title_settings

	return not title_settings and cjson.decode(title_settings) or tbl
end

BackendManagerPlayFab.dlc_unlocked_at_signin = function (self, arg_93_1)
	-- function 93
	if not (IS_WINDOWS or IS_LINUX or self._backend_mirror) then
		return true
	end

	return self._backend_mirror:dlc_unlocked_at_signin(arg_93_1)
end

BackendManagerPlayFab.get_metadata = function (self)
	-- function 94
	return self._metadata
end

BackendManagerPlayFab.get_backend_mirror = function (self)
	-- function 95
	return self._backend_mirror
end

BackendManagerPlayFab.get_twitch_app_access_token = function (self)
	-- function 96
	return self._backend_mirror:get_twitch_app_access_token()
end

BackendManagerPlayFab.get_current_api_call = function (self)
	-- function 97
	if not self._backend_mirror then
		return
	end

	return self._backend_mirror:current_api_call()
end
