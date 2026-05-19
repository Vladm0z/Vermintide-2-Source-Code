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

if IS_WINDOWS or IS_LINUX then
	require("scripts/managers/backend_playfab/script_backend_playfab")
	DLCUtils.require_list("script_backend_playfab_files")
elseif IS_XB1 then
	require("scripts/managers/backend_playfab/script_backend_playfab_xbox")
	require("scripts/managers/backend_playfab/backend_interface_console_dlc_rewards_playfab")
elseif IS_PS4 then
	require("scripts/managers/backend_playfab/script_backend_playfab_ps4")
	require("scripts/managers/backend_playfab/backend_interface_console_dlc_rewards_playfab")
end

cjson = cjson.stingray_init()

local var_0_0 = script_data.testify and require("scripts/managers/backend_playfab/backend_manager_playfab_testify")

BackendManagerPlayFab = class(BackendManagerPlayFab)

local var_0_1 = 20

function BackendManagerPlayFab.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._backend_implementation = GameSettingsDevelopment.backend_settings.implementation
	arg_1_0._signin = rawget(_G, arg_1_1)
	arg_1_0._mirror = rawget(_G, arg_1_2)
	arg_1_0._server_queue = rawget(_G, arg_1_3)
	arg_1_0._interfaces = {}
	arg_1_0._interfaces_created = false
	arg_1_0._errors = {}
	arg_1_0._in_error_state = false
	arg_1_0._is_tutorial_backend = false
	arg_1_0._button_retry = "button_retry"
	arg_1_0._button_ok = "button_ok"
	arg_1_0._button_quit = "button_quit"
	arg_1_0._button_disconnected = "button_disconnected"
	arg_1_0._loadout_interface_overrides = {}
	arg_1_0._current_loadout_interface_override = nil
	arg_1_0._talents_interface_overrides = {}
	arg_1_0._current_talents_interface_override = nil
	arg_1_0._total_power_level_interface_overrides = {}
	arg_1_0._metadata = {
		client_type = "client",
		client_version = VersionSettings.version,
		realm = HAS_STEAM and script_data["eac-untrusted"] and "modded" or "official"
	}
end

function BackendManagerPlayFab.reset(arg_2_0)
	arg_2_0._errors = {}
	arg_2_0._is_disconnected = false
	arg_2_0._in_error_state = false

	arg_2_0:_destroy_backend()
end

function BackendManagerPlayFab.signin(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:available()
	local var_3_1 = arg_3_0:_backend_plugin_loaded()
	local var_3_2 = GameSettingsDevelopment.backend_settings.allow_local
	local var_3_3 = GameSettingsDevelopment.use_backend

	if not var_3_0 or not var_3_1 or not var_3_3 then
		if var_3_2 then
			if var_3_3 and not var_3_0 then
				local var_3_4 = {
					reason = BACKEND_LUA_ERRORS.ERR_PLATFORM_SPECIFIC_INTERFACE_MISSING
				}

				arg_3_0:_post_error(var_3_4)

				return
			end
		elseif not var_3_1 then
			local var_3_5 = {
				reason = BACKEND_LUA_ERRORS.ERR_LOADING_PLUGIN
			}

			arg_3_0:_post_error(var_3_5)

			return
		elseif not var_3_3 then
			local var_3_6 = {
				reason = BACKEND_LUA_ERRORS.ERR_USE_LOCAL_BACKEND_NOT_ALLOWED
			}

			arg_3_0:_post_error(var_3_6)

			return
		else
			error("Bad backend combination")
		end
	end

	if arg_3_0._backend_signin then
		arg_3_0:reset()
	end

	print("[BackendManagerPlayFab] Backend Enabled")

	arg_3_0._backend_signin = arg_3_0._signin:new(arg_3_1)
	arg_3_0._need_signin = true
	arg_3_0._signin_timeout = os.time() + var_0_1
end

function BackendManagerPlayFab.on_shutdown(arg_4_0, arg_4_1)
	local function var_4_0(arg_5_0)
		local function var_5_0(arg_6_0)
			arg_4_1(arg_6_0)
		end

		if arg_4_0._backend_mirror then
			arg_4_0._backend_mirror:log_player_exit(var_5_0)
		end
	end

	return arg_4_0:commit(true, var_4_0)
end

function BackendManagerPlayFab._backend_plugin_loaded(arg_7_0)
	if arg_7_0._backend_implementation == "fishtank" then
		return rawget(_G, "Backend")
	elseif arg_7_0._backend_implementation == "playfab" then
		return true
	end

	fassert(false, "unknown backend implementation set in backend settings")
end

function BackendManagerPlayFab._create_interfaces(arg_8_0)
	local var_8_0 = GameSettingsDevelopment.backend_settings

	arg_8_0:_create_items_interface(var_8_0)

	if not DEDICATED_SERVER then
		arg_8_0:_create_quests_interface(var_8_0)
	end

	arg_8_0:_create_crafting_interface(var_8_0)
	arg_8_0:_create_talents_interface(var_8_0)
	arg_8_0:_create_loot_interface(var_8_0)
	arg_8_0:_create_common_interface(var_8_0)
	arg_8_0:_create_hero_attributes_interface(var_8_0)
	arg_8_0:_create_statistics_interface(var_8_0)
	arg_8_0:_create_keep_decorations_interface(var_8_0)
	arg_8_0:_create_live_events_interface(var_8_0)
	arg_8_0:_create_cdn_resources_interface(var_8_0)
	arg_8_0:_create_dlcs_interface(var_8_0)

	if IS_CONSOLE then
		arg_8_0:_create_console_dlc_rewards_interface(var_8_0)
	end

	arg_8_0:_create_dlc_interfaces(var_8_0)

	arg_8_0._interfaces_created = true
end

function BackendManagerPlayFab._destroy_backend(arg_9_0)
	if arg_9_0._backend_signin then
		arg_9_0._backend_signin:destroy()

		arg_9_0._backend_signin = nil
	end

	if arg_9_0._backend_mirror then
		arg_9_0._backend_mirror:destroy()

		arg_9_0._backend_mirror = nil
	end
end

function BackendManagerPlayFab.item_script_type(arg_10_0)
	return "backend"
end

function BackendManagerPlayFab.get_interface(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0._interfaces[arg_11_1] then
		Application.warning("BackendManagerPlayFab:get_interface: Requesting unknown interface " .. arg_11_1)

		return nil
	end

	return arg_11_0._interfaces[arg_11_1]
end

function BackendManagerPlayFab.dirtify_interfaces(arg_12_0)
	local var_12_0 = arg_12_0._interfaces

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if iter_12_1.make_dirty then
			iter_12_1:make_dirty()
		end
	end
end

function BackendManagerPlayFab.get_data_server_queue(arg_13_0)
	return arg_13_0._data_server_queue
end

function BackendManagerPlayFab.is_disconnected(arg_14_0)
	return arg_14_0._is_disconnected
end

function BackendManagerPlayFab.is_waiting_for_user_input(arg_15_0)
	return not not arg_15_0._error_dialog
end

function BackendManagerPlayFab.get_title_data(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._backend_mirror

	if var_16_0 then
		return var_16_0:get_title_data()[arg_16_1]
	end

	return nil
end

function BackendManagerPlayFab.get_read_only_data(arg_17_0, arg_17_1)
	return arg_17_0._backend_mirror and arg_17_0._backend_mirror:get_read_only_data(arg_17_1) or nil
end

function BackendManagerPlayFab.start_tutorial(arg_18_0)
	fassert(arg_18_0._script_backend_items_backup == nil, "Tutorial already started")
	fassert(arg_18_0._script_backend_hero_attributes_backup == nil, "Tutorial already started")

	arg_18_0._script_backend_items_backup = arg_18_0._interfaces.items
	arg_18_0._interfaces.items = BackendInterfaceItemTutorial:new()
	arg_18_0._script_backend_hero_attributes_backup = arg_18_0._interfaces.hero_attributes
	arg_18_0._interfaces.hero_attributes = BackendInterfaceHeroAttributesTutorial:new()
	arg_18_0._is_tutorial_backend = true
end

function BackendManagerPlayFab.stop_tutorial(arg_19_0)
	fassert(arg_19_0._script_backend_items_backup ~= nil, "Stopping tutorial without starting it")
	fassert(arg_19_0._script_backend_hero_attributes_backup ~= nil, "Stopping tutorial without starting it")

	arg_19_0._interfaces.items = arg_19_0._script_backend_items_backup
	arg_19_0._script_backend_items_backup = nil
	arg_19_0._interfaces.hero_attributes = arg_19_0._script_backend_hero_attributes_backup
	arg_19_0._script_backend_hero_attributes_backup = nil
	arg_19_0._is_tutorial_backend = false
end

function BackendManagerPlayFab.is_tutorial_backend(arg_20_0)
	return arg_20_0._is_tutorial_backend
end

function BackendManagerPlayFab.is_benchmark_backend(arg_21_0)
	return arg_21_0._benchmark_backend
end

function BackendManagerPlayFab.start_benchmark(arg_22_0)
	fassert(arg_22_0._benchmark_backend == nil, "Benchmark backend already started.")

	arg_22_0._script_backend_items_backup = arg_22_0._interfaces.items
	arg_22_0._interfaces.items = BackendInterfaceItemTutorial:new()
	arg_22_0._script_backend_hero_attributes_backup = arg_22_0._interfaces.hero_attributes
	arg_22_0._interfaces.hero_attributes = BackendInterfaceHeroAttributesTutorial:new()
	arg_22_0._script_backend_loot_backup = arg_22_0._interfaces.loot
	arg_22_0._interfaces.loot = BackendInterfaceLootBenchmark:new()
	arg_22_0._script_backend_statistics_backup = arg_22_0._interfaces.statistics
	arg_22_0._interfaces.statistics = BackendInterfaceStatisticsBenchmark:new()
	arg_22_0._script_backend_quest_backup = arg_22_0._interfaces.quests
	arg_22_0._interfaces.quests = BackendInterfaceQuestsBenchmark:new()
	arg_22_0._benchmark_backend = true
end

function BackendManagerPlayFab.stop_benchmark(arg_23_0)
	fassert(arg_23_0._benchmark_backend == true, "Benchmark has not been started.")

	arg_23_0._interfaces.items = arg_23_0._script_backend_items_backup
	arg_23_0._script_backend_items_backup = nil
	arg_23_0._interfaces.hero_attributes = arg_23_0._script_backend_hero_attributes_backup
	arg_23_0._script_backend_hero_attributes_backup = nil
	arg_23_0._interfaces.loot = arg_23_0._script_backend_loot_backup
	arg_23_0._script_backend_loot_backup = nil
	arg_23_0._interfaces.statistics = arg_23_0._script_backend_statistics_backup
	arg_23_0._script_backend_statistics_backup = nil
	arg_23_0._interfaces.quests = arg_23_0._script_backend_quest_backup
	arg_23_0._script_backend_quest_backup = nil
	arg_23_0._benchmark_backend = nil
end

function BackendManagerPlayFab.add_loadout_interface_override(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._loadout_interface_overrides[arg_24_1] = arg_24_2
end

function BackendManagerPlayFab.set_loadout_interface_override(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._current_loadout_interface_override
	local var_25_1 = arg_25_0._loadout_interface_overrides[arg_25_1] and arg_25_1
	local var_25_2 = false

	if var_25_1 ~= var_25_0 then
		arg_25_0._current_loadout_interface_override = var_25_1
		var_25_2 = true
	end

	return var_25_2, var_25_0, var_25_1
end

function BackendManagerPlayFab.get_loadout_interface_by_slot(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._current_loadout_interface_override

	if not var_26_0 then
		return arg_26_0._interfaces.items
	end

	local var_26_1 = arg_26_0._loadout_interface_overrides[var_26_0][arg_26_1]

	return var_26_1 and arg_26_0._interfaces[var_26_1]
end

function BackendManagerPlayFab.add_talents_interface_override(arg_27_0, arg_27_1, arg_27_2)
	arg_27_0._talents_interface_overrides[arg_27_1] = arg_27_2
end

function BackendManagerPlayFab.set_talents_interface_override(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._current_talents_interface_override
	local var_28_1 = arg_28_0._talents_interface_overrides[arg_28_1] and arg_28_1
	local var_28_2 = false

	if var_28_1 ~= var_28_0 then
		arg_28_0._current_talents_interface_override = var_28_1
		var_28_2 = true
	end

	return var_28_2
end

function BackendManagerPlayFab.get_talents_interface(arg_29_0)
	local var_29_0 = arg_29_0._current_talents_interface_override

	if not var_29_0 then
		return arg_29_0._interfaces.talents
	end

	local var_29_1 = arg_29_0._talents_interface_overrides[var_29_0]

	return arg_29_0._interfaces[var_29_1]
end

function BackendManagerPlayFab.set_total_power_level_interface_for_game_mode(arg_30_0, arg_30_1, arg_30_2)
	arg_30_0._total_power_level_interface_overrides[arg_30_1] = arg_30_2
end

function BackendManagerPlayFab.get_total_power_level(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_0._total_power_level_interface_overrides[arg_31_3]

	if var_31_0 then
		return arg_31_0._interfaces[var_31_0]:get_total_power_level(arg_31_1, arg_31_2)
	end

	return BackendUtils.get_hero_power_level(arg_31_1) + BackendUtils.get_average_item_power_level(arg_31_2)
end

function BackendManagerPlayFab._update_state(arg_32_0)
	local var_32_0 = GameSettingsDevelopment.backend_settings
	local var_32_1 = arg_32_0._backend_signin

	if (not var_32_0.allow_backend or arg_32_0._local_save_loaded or DEDICATED_SERVER) and arg_32_0._need_signin then
		local var_32_2 = var_32_1:update_signin()

		if var_32_2 then
			arg_32_0._need_signin = false

			arg_32_0:_post_error(var_32_2)
		elseif var_32_1:authenticated() then
			local var_32_3 = arg_32_0._backend_mirror

			if var_32_3 and var_32_3:ready() then
				arg_32_0._need_signin = false
				arg_32_0._data_server_queue = arg_32_0._server_queue:new()

				arg_32_0:_create_interfaces(false)
			elseif not var_32_3 then
				local var_32_4 = var_32_1:get_signin_result()

				arg_32_0._backend_mirror = arg_32_0._mirror:new(var_32_4)

				if Managers.mechanism then
					Managers.mechanism:refresh_mechanism_setting_for_title()
				end
			end
		elseif arg_32_0._signin_timeout < os.time() then
			arg_32_0._need_signin = false

			local var_32_5 = {
				reason = BACKEND_LUA_ERRORS.ERR_SIGNIN_TIMEOUT
			}

			arg_32_0:_post_error(var_32_5)
		end
	end
end

function string_is_url(arg_33_0)
	return string.starts_with(arg_33_0, "http://") or string.starts_with(arg_33_0, "https://")
end

function BackendManagerPlayFab._update_error_handling(arg_34_0, arg_34_1)
	if #arg_34_0._errors > 0 and not arg_34_0._error_dialog and not arg_34_0._is_disconnected and not DEDICATED_SERVER then
		local var_34_0 = table.remove(arg_34_0._errors, 1)

		arg_34_0:_show_error_dialog(var_34_0.reason, var_34_0.details, var_34_0.optional_error_topic, var_34_0.optional_url_button, var_34_0.errorDetails)
	end

	if arg_34_0._error_dialog ~= nil and not Managers.popup:has_popup_with_id(arg_34_0._error_dialog) then
		arg_34_0._is_disconnected = true
		arg_34_0._error_dialog = nil
	end

	if arg_34_0._error_dialog then
		local var_34_1 = Managers.popup:query_result(arg_34_0._error_dialog)

		if var_34_1 then
			Managers.popup:cancel_popup(arg_34_0._error_dialog)

			arg_34_0._error_dialog = nil

			if type(var_34_1) == "table" then
				if var_34_1.open_url and string_is_url(var_34_1.open_url) then
					Application.open_url_in_browser(var_34_1.open_url)
				end

				if var_34_1.application_quit then
					Application.quit()
				end
			elseif var_34_1 == arg_34_0._button_disconnected then
				arg_34_0._is_disconnected = true
			elseif var_34_1 == arg_34_0._button_retry then
				arg_34_0._is_disconnected = true
			elseif var_34_1 == arg_34_0._button_quit then
				Application.quit()
			elseif var_34_1 == arg_34_0._button_restart then
				arg_34_0._is_disconnected = true
			end
		end
	end
end

function BackendManagerPlayFab._update_interface(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._interfaces[arg_35_1]
	local var_35_1 = arg_35_0._backend_mirror

	if var_35_0 and var_35_0.update and var_35_1 then
		var_35_0:update(arg_35_2)
	end
end

function BackendManagerPlayFab.update(arg_36_0, arg_36_1, arg_36_2)
	if arg_36_0:_are_profiles_loaded() and not arg_36_0._profiles_loaded then
		arg_36_0._profiles_loaded = true

		Managers.mechanism:backend_profiles_loaded()
	elseif not arg_36_0:_are_profiles_loaded() and arg_36_0._profiles_loaded then
		arg_36_0._profiles_loaded = false
	end

	local var_36_0 = GameSettingsDevelopment.backend_settings
	local var_36_1 = arg_36_0._backend_signin
	local var_36_2 = arg_36_0._backend_mirror
	local var_36_3 = arg_36_0._data_server_queue
	local var_36_4

	if var_36_2 then
		var_36_4 = var_36_2:update(arg_36_1, arg_36_2)
	end

	if var_36_3 then
		var_36_3:update()

		var_36_4 = var_36_4 or var_36_3:check_for_errors()
	end

	local var_36_5 = arg_36_0._interfaces

	if var_36_0.enable_sessions then
		arg_36_0:_update_interface("session", arg_36_1)
	end

	arg_36_0:_update_interface("items", arg_36_1)
	arg_36_0:_update_interface("crafting", arg_36_1)
	arg_36_0:_update_interface("talents", arg_36_1)
	arg_36_0:_update_interface("loot", arg_36_1)
	arg_36_0:_update_interface("quests", arg_36_1)
	arg_36_0:_update_interface("deus", arg_36_1)

	if var_36_1 then
		arg_36_0:_update_state()

		if var_36_0.enable_sessions then
			var_36_4 = var_36_4 or var_36_5.session:check_for_errors()
		end

		if var_36_4 then
			arg_36_0:_post_error(var_36_4)
		end
	end

	arg_36_0:_update_error_handling(arg_36_1)

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_36_0)
	end
end

function BackendManagerPlayFab.playfab_api_error(arg_37_0, arg_37_1, arg_37_2)
	table.dump(arg_37_1, nil, 10)

	local var_37_0 = {
		reason = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR,
		details = arg_37_2,
		errorDetails = arg_37_1.errorDetails
	}

	arg_37_0:_post_error(var_37_0)
end

function BackendManagerPlayFab.request_timeout(arg_38_0)
	local var_38_0 = {
		reason = BACKEND_LUA_ERRORS.ERR_REQUEST_TIMEOUT
	}

	arg_38_0:_post_error(var_38_0, "backend_err_request_timeout")
end

function BackendManagerPlayFab.commit_error(arg_39_0)
	local var_39_0 = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_COMMIT_TIMEOUT
	local var_39_1
	local var_39_2 = {
		reason = var_39_0,
		details = var_39_1
	}

	arg_39_0:_post_error(var_39_2)
end

function BackendManagerPlayFab.playfab_eac_error(arg_40_0)
	local var_40_0 = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_EAC_ERROR
	local var_40_1
	local var_40_2 = {
		reason = var_40_0,
		details = var_40_1
	}

	arg_40_0:_post_error(var_40_2)
end

function BackendManagerPlayFab.playfab_error(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = {
		reason = arg_41_1,
		details = arg_41_2
	}

	arg_41_0:_post_error(var_41_0)
end

function BackendManagerPlayFab.missing_required_dlc_error(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_MISSING_REQUIRED_DLC
	local var_42_1 = {
		reason = var_42_0,
		details = arg_42_1,
		optional_error_topic = arg_42_2,
		optional_url_button = arg_42_3
	}

	arg_42_0:_post_error(var_42_1, nil, true)
end

function BackendManagerPlayFab.signed_in(arg_43_0)
	local var_43_0 = arg_43_0._backend_signin

	if var_43_0 and var_43_0:authenticated() then
		return true
	end

	return false
end

function BackendManagerPlayFab.authenticated(arg_44_0)
	local var_44_0 = arg_44_0._backend_signin
	local var_44_1 = arg_44_0._backend_mirror

	return var_44_0 and var_44_0:authenticated() and var_44_1 and var_44_1:ready()
end

function BackendManagerPlayFab.has_error(arg_45_0)
	return arg_45_0._in_error_state
end

function BackendManagerPlayFab.error_string(arg_46_0)
	if #arg_46_0._errors == 0 then
		return ""
	else
		local var_46_0 = arg_46_0._errors[1].reason
		local var_46_1 = arg_46_0._errors[1].details
		local var_46_2 = arg_46_0:_reason_localize_key(var_46_0, var_46_1)

		return (Localize(var_46_2))
	end
end

function BackendManagerPlayFab._post_error(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	if not arg_47_3 then
		Crashify.print_exception("Backend_Error", "ERROR: %s", arg_47_2 or arg_47_1.details)
	end

	local var_47_0 = arg_47_0._data_server_queue

	if var_47_0 then
		var_47_0:clear()
	end

	fassert(arg_47_1.reason, "Posting error without reason, %q: %q", arg_47_1.reason or "nil")

	if DEDICATED_SERVER then
		cprintf("[BackendManagerPlayFab] Playfab error: %s, %s", arg_47_1.reason, arg_47_1.details)
	end

	print("[BackendManagerPlayFab] adding error:", arg_47_1.reason, arg_47_1.details)

	arg_47_0._errors[#arg_47_0._errors + 1] = arg_47_1
	arg_47_0._in_error_state = arg_47_0:_is_fatal(arg_47_1.reason)
end

function BackendManagerPlayFab._is_fatal(arg_48_0, arg_48_1)
	return not (arg_48_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED or arg_48_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_QUEST_REFRESH_UNAVAILABLE or arg_48_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_NON_FATAL_STORE_ERROR)
end

function BackendManagerPlayFab._format_ban_message(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0, var_49_1 = next(arg_49_2)

	if not var_49_1 or #var_49_1 == 0 then
		return ERROR_CODES[arg_49_1], arg_49_1
	end

	local var_49_2 = ERROR_CODES[arg_49_1]
	local var_49_3 = ""
	local var_49_4 = {}
	local var_49_5 = var_49_1[1]

	if var_49_5 == "Indefinite" then
		var_49_2 = "backend_err_account_banned_permanent"
	else
		local var_49_6, var_49_7, var_49_8, var_49_9, var_49_10, var_49_11 = var_49_5:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
		local var_49_12 = os.time({
			year = tonumber(var_49_6),
			month = tonumber(var_49_7),
			day = tonumber(var_49_8),
			hour = tonumber(var_49_9),
			min = tonumber(var_49_10),
			sec = tonumber(var_49_11)
		})
		local var_49_13 = os.date("*t")
		local var_49_14 = os.time(var_49_13)
		local var_49_15 = os.date("!*t")
		local var_49_16 = os.time(var_49_15)

		if var_49_13.isdst then
			var_49_16 = var_49_16 - 3600
		end

		local var_49_17 = var_49_12 + var_49_14 - var_49_16

		var_49_3 = string.format("\n%s\n", Localize("backend_err_account_banned_duration"))
		var_49_4[#var_49_4 + 1] = os.date("%x", var_49_17)
		var_49_4[#var_49_4 + 1] = os.date("%X", var_49_17)
	end

	if var_49_0 ~= "Unspecified reason" then
		var_49_3 = string.format("%s\n%s", var_49_3, Localize("backend_err_account_banned_reason"))
		var_49_4[#var_49_4 + 1] = var_49_0
	end

	return var_49_2, string.format(var_49_3, unpack(var_49_4))
end

function BackendManagerPlayFab._reason_localize_key(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = arg_50_2 and tonumber(arg_50_2) or -1

	if IS_CONSOLE then
		if not arg_50_0:profiles_loaded() then
			if rawget(_G, "Backend") and arg_50_1 == Backend.ERR_AUTH then
				if IS_XB1 then
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
	elseif not arg_50_0:profiles_loaded() then
		if rawget(_G, "Backend") and arg_50_1 == Backend.ERR_AUTH then
			return "backend_err_auth_steam", var_50_0
		elseif arg_50_1 == BACKEND_LUA_ERRORS.ERR_SIGNIN_TIMEOUT then
			return "backend_err_signin_timeout", var_50_0
		elseif arg_50_1 == BACKEND_LUA_ERRORS.ERR_PLATFORM_SPECIFIC_INTERFACE_MISSING then
			return "backend_err_steam_not_running", var_50_0
		elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR then
			if var_50_0 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_THIRD_PARTY_PROBLEM then
				return ERROR_CODES[var_50_0], var_50_0
			elseif var_50_0 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACCOUNT_BANNED then
				if arg_50_3 then
					local var_50_1, var_50_2 = arg_50_0:_format_ban_message(var_50_0, arg_50_3)

					return var_50_1, var_50_2
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
	elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_EAC_ERROR or arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_COMMIT_TIMEOUT then
		return ERROR_CODES[arg_50_1], var_50_0
	elseif arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED or arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_QUEST_REFRESH_UNAVAILABLE or arg_50_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_NON_FATAL_STORE_ERROR then
		return ERROR_CODES[arg_50_1], var_50_0
	else
		return "backend_err_network", var_50_0
	end
end

function BackendManagerPlayFab._format_error_message_console(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = {
		result = arg_51_0._button_retry,
		text = Localize("button_ok")
	}
	local var_51_1, var_51_2 = arg_51_0:_reason_localize_key(arg_51_1, arg_51_2, arg_51_3)

	return var_51_1, var_51_2, var_51_0
end

function BackendManagerPlayFab._format_error_message_windows(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	local var_52_0, var_52_1 = arg_52_0:_reason_localize_key(arg_52_1, arg_52_2, arg_52_4)
	local var_52_2
	local var_52_3
	local var_52_4

	if not arg_52_0:profiles_loaded() then
		var_52_2 = {
			result = arg_52_0._button_quit,
			text = Localize("menu_quit")
		}

		print("backend error", arg_52_1, ERROR_CODES[arg_52_1])
	elseif arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR or arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_EAC_ERROR or arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_COMMIT_TIMEOUT then
		var_52_2 = {
			result = arg_52_0._button_quit,
			text = Localize("menu_quit")
		}
	elseif arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ACHIEVEMENT_REWARD_CLAIMED or arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_QUEST_REFRESH_UNAVAILABLE or arg_52_1 == BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_NON_FATAL_STORE_ERROR then
		var_52_2 = {
			result = arg_52_0._button_ok,
			text = Localize("button_ok")
		}
	else
		var_52_2 = {
			result = arg_52_0._button_disconnected,
			text = Localize("button_ok")
		}
	end

	if arg_52_3 then
		local var_52_5 = {
			result = {
				application_quit = true,
				open_url = arg_52_3.url
			},
			text = arg_52_3.text
		}

		if var_52_3 then
			var_52_4 = var_52_5
		elseif var_52_2 then
			var_52_3 = var_52_5
		else
			var_52_2 = var_52_5
		end
	end

	return var_52_0, var_52_1, var_52_2, var_52_3, var_52_4
end

function BackendManagerPlayFab._show_error_dialog(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	print(string.format("[BackendManagerPlayFab] Showing error dialog: %q, %q", arg_53_1 or "nil", arg_53_2 or "nil"))

	local var_53_0 = arg_53_3 or Localize("backend_error_topic")
	local var_53_1
	local var_53_2
	local var_53_3
	local var_53_4

	if IS_CONSOLE then
		var_53_1, arg_53_2, var_53_2 = arg_53_0:_format_error_message_console(arg_53_1, arg_53_2, arg_53_5)
	else
		var_53_1, arg_53_2, var_53_2, var_53_3, var_53_4 = arg_53_0:_format_error_message_windows(arg_53_1, arg_53_2, arg_53_4, arg_53_5)
	end

	local var_53_5 = var_53_1 and Localize(var_53_1) or Localize("backend_err_playfab")

	if IS_WINDOWS then
		if var_53_5 and arg_53_2 then
			var_53_5 = var_53_5 .. "\n" .. arg_53_2
		elseif arg_53_2 then
			var_53_5 = arg_53_2
		end
	end

	if var_53_4 then
		arg_53_0._error_dialog = Managers.popup:queue_popup(var_53_5, var_53_0, var_53_2.result, var_53_2.text, var_53_3.result, var_53_3.text, var_53_4.result, var_53_4.text)
	elseif var_53_3 then
		arg_53_0._error_dialog = Managers.popup:queue_popup(var_53_5, var_53_0, var_53_2.result, var_53_2.text, var_53_3.result, var_53_3.text)
	else
		arg_53_0._error_dialog = Managers.popup:queue_popup(var_53_5, var_53_0, var_53_2.result, var_53_2.text)
	end
end

function BackendManagerPlayFab.get_stats(arg_54_0)
	if arg_54_0._backend_mirror then
		return arg_54_0._backend_mirror:get_stats()
	else
		return arg_54_0._save_data.stats
	end
end

function BackendManagerPlayFab.set_stats(arg_55_0, arg_55_1)
	if arg_55_0._backend_mirror then
		return arg_55_0._backend_mirror:set_stats(arg_55_1)
	else
		arg_55_0._save_data.stats = arg_55_1
	end
end

function BackendManagerPlayFab.get_user_data(arg_56_0, arg_56_1)
	if arg_56_0._backend_mirror then
		return arg_56_0._backend_mirror:get_user_data(arg_56_1)
	else
		return arg_56_0._save_data.user_data[arg_56_1]
	end
end

function BackendManagerPlayFab.set_user_data(arg_57_0, arg_57_1, arg_57_2)
	if arg_57_0._backend_mirror then
		arg_57_0._backend_mirror:set_user_data(arg_57_1, arg_57_2)
	else
		arg_57_0._save_data.user_data[arg_57_1] = arg_57_2
	end
end

function BackendManagerPlayFab.available(arg_58_0)
	local var_58_0 = GameSettingsDevelopment.backend_settings

	if IS_WINDOWS or IS_LINUX then
		return rawget(_G, "Steam") ~= nil or DEDICATED_SERVER or Development.parameter("use_lan_backend")
	elseif IS_XB1 then
		return true
	elseif IS_PS4 then
		return true
	end

	return false
end

function BackendManagerPlayFab.commit(arg_59_0, arg_59_1, arg_59_2)
	if arg_59_0._backend_mirror then
		return arg_59_0._backend_mirror:commit(arg_59_1, arg_59_2)
	end
end

function BackendManagerPlayFab.has_loaded(arg_60_0)
	return arg_60_0._local_save_loaded or DEDICATED_SERVER
end

function BackendManagerPlayFab._are_profiles_loaded(arg_61_0)
	local var_61_0 = arg_61_0._backend_signin
	local var_61_1 = arg_61_0._backend_mirror

	return (arg_61_0._disable_backend or var_61_0 and var_61_0:authenticated() and var_61_1 and var_61_1:ready()) and arg_61_0:_interfaces_ready()
end

function BackendManagerPlayFab.profiles_loaded(arg_62_0)
	return arg_62_0._profiles_loaded
end

function BackendManagerPlayFab.interfaces_ready(arg_63_0)
	return arg_63_0:_interfaces_ready()
end

function BackendManagerPlayFab._interfaces_ready(arg_64_0)
	if not arg_64_0._interfaces_created then
		return false
	end

	if not arg_64_0._interfaces then
		return false
	end

	local var_64_0 = arg_64_0._interfaces

	for iter_64_0, iter_64_1 in pairs(var_64_0) do
		if not iter_64_1:ready() then
			return false
		end
	end

	return true
end

function BackendManagerPlayFab.refresh_log_level(arg_65_0)
	print("[BackendManagerPlayFab] No backend to set log level on!")
end

function BackendManagerPlayFab.logout(arg_66_0)
	error("[BackendManagerPlayFab] Not implemented yet")
end

function BackendManagerPlayFab.disconnect(arg_67_0)
	error("[BackendManagerPlayFab] Not implemented yet")
end

function BackendManagerPlayFab.destroy(arg_68_0)
	if arg_68_0._interfaces.quests then
		arg_68_0._interfaces.quests:delete()
	end

	local var_68_0 = arg_68_0._backend_mirror

	if var_68_0 then
		var_68_0:wait_for_shutdown(1)
	end
end

function BackendManagerPlayFab.implementation(arg_69_0)
	return arg_69_0._backend_implementation
end

function BackendManagerPlayFab._create_items_interface(arg_70_0, arg_70_1)
	local var_70_0 = arg_70_0._backend_implementation

	if var_70_0 == "playfab" then
		arg_70_0._interfaces.items = BackendInterfaceItemPlayfab:new(arg_70_0._backend_mirror)
	elseif var_70_0 == "fishtank" then
		arg_70_0._interfaces.items = BackendInterfaceItem:new()
	end
end

function BackendManagerPlayFab._create_quests_interface(arg_71_0, arg_71_1)
	local var_71_0 = arg_71_0._backend_implementation

	if var_71_0 == "playfab" then
		arg_71_0._interfaces.quests = BackendInterfaceQuestsPlayfab:new(arg_71_0._backend_mirror)
	elseif var_71_0 == "fishtank" then
		arg_71_0._interfaces.quests = BackendInterfaceQuests:new()
	end
end

function BackendManagerPlayFab._create_crafting_interface(arg_72_0, arg_72_1)
	local var_72_0 = arg_72_0._backend_implementation

	if var_72_0 == "playfab" then
		arg_72_0._interfaces.crafting = BackendInterfaceCraftingPlayfab:new(arg_72_0._backend_mirror)
	elseif var_72_0 == "fishtank" then
		arg_72_0._interfaces.crafting = BackendInterfaceCrafting:new()
	end
end

function BackendManagerPlayFab._create_talents_interface(arg_73_0, arg_73_1)
	local var_73_0 = arg_73_0._backend_implementation

	if var_73_0 == "playfab" then
		arg_73_0._interfaces.talents = BackendInterfaceTalentsPlayfab:new(arg_73_0._backend_mirror)
	elseif var_73_0 == "fishtank" then
		arg_73_0._interfaces.talents = BackendInterfaceTalents:new()
	end
end

function BackendManagerPlayFab._create_loot_interface(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0._backend_implementation

	if var_74_0 == "playfab" then
		arg_74_0._interfaces.loot = BackendInterfaceLootPlayfab:new(arg_74_0._backend_mirror)
	elseif var_74_0 == "fishtank" then
		arg_74_0._interfaces.loot = BackendInterfaceLootLocal:new(arg_74_0._save_data)
	end
end

function BackendManagerPlayFab._create_common_interface(arg_75_0, arg_75_1)
	arg_75_0._interfaces.common = BackendInterfaceCommon:new(arg_75_0._backend_mirror)
end

function BackendManagerPlayFab._create_hero_attributes_interface(arg_76_0, arg_76_1)
	local var_76_0 = arg_76_0._backend_implementation

	if var_76_0 == "playfab" then
		arg_76_0._interfaces.hero_attributes = BackendInterfaceHeroAttributesPlayFab:new(arg_76_0._backend_mirror)
	elseif var_76_0 == "fishtank" then
		arg_76_0._interfaces.hero_attributes = BackendInterfaceHeroAttributesLocal:new(arg_76_0._save_data)
	end
end

function BackendManagerPlayFab._create_statistics_interface(arg_77_0, arg_77_1)
	arg_77_0._interfaces.statistics = BackendInterfaceStatisticsPlayFab:new(arg_77_0._backend_mirror)
end

function BackendManagerPlayFab._create_keep_decorations_interface(arg_78_0, arg_78_1)
	arg_78_0._interfaces.keep_decorations = BackendInterfaceKeepDecorationsPlayFab:new(arg_78_0._backend_mirror)
end

function BackendManagerPlayFab._create_live_events_interface(arg_79_0, arg_79_1)
	arg_79_0._interfaces.live_events = BackendInterfaceLiveEventsPlayfab:new(arg_79_0._backend_mirror)
end

function BackendManagerPlayFab._create_console_dlc_rewards_interface(arg_80_0, arg_80_1)
	arg_80_0._interfaces.console_dlc_rewards = BackendInterfaceConsoleDlcRewardsPlayfab:new(arg_80_0._backend_mirror)
end

function BackendManagerPlayFab._create_dlcs_interface(arg_81_0, arg_81_1)
	arg_81_0._interfaces.dlcs = BackendInterfaceDLCsPlayfab:new(arg_81_0._backend_mirror)
end

function BackendManagerPlayFab._create_dlc_interfaces(arg_82_0, arg_82_1)
	local var_82_0 = arg_82_0._interfaces
	local var_82_1 = arg_82_0._save_data
	local var_82_2 = arg_82_0._backend_mirror

	for iter_82_0, iter_82_1 in pairs(DLCSettings) do
		local var_82_3 = iter_82_1.backend_interfaces

		if var_82_3 then
			for iter_82_2, iter_82_3 in pairs(var_82_3) do
				if not (DEDICATED_SERVER and iter_82_3.ignore_on_dedicated_server) then
					local var_82_4
					local var_82_5 = iter_82_3.playfab_file

					require(var_82_5)

					local var_82_6 = iter_82_3.playfab_class

					var_82_0[iter_82_2] = rawget(_G, var_82_6):new(var_82_2)
				end
			end
		end
	end
end

function BackendManagerPlayFab._create_cdn_resources_interface(arg_83_0, arg_83_1)
	arg_83_0._interfaces.cdn = BackendInterfaceCdnResourcesPlayFab:new(arg_83_0._backend_mirror)

	local var_83_0 = Managers.localizer:language_id()

	arg_83_0._interfaces.cdn:load_backend_localizations(var_83_0, callback(arg_83_0, "_cb_backend_localizations_loaded"))
end

function BackendManagerPlayFab._cb_backend_localizations_loaded(arg_84_0, arg_84_1)
	if arg_84_1 then
		Managers.localizer:append_backend_localizations(arg_84_1)
	end
end

function BackendManagerPlayFab.player_id(arg_85_0)
	local var_85_0 = arg_85_0._backend_signin

	if not var_85_0 then
		return "-"
	end

	return var_85_0:get_signin_result().PlayFabId
end

function BackendManagerPlayFab.switch_mechanism(arg_86_0, arg_86_1)
	arg_86_0._backend_mirror:set_mechanism(arg_86_1)
end

function BackendManagerPlayFab.load_mechanism_loadout(arg_87_0, arg_87_1)
	arg_87_0._backend_mirror:request_characters(arg_87_1)
end

function BackendManagerPlayFab.is_pending_request(arg_88_0)
	local var_88_0 = arg_88_0._backend_mirror

	return var_88_0 and var_88_0:request_queue():is_pending_request() or false
end

function BackendManagerPlayFab.is_mirror_ready(arg_89_0)
	local var_89_0 = arg_89_0._backend_mirror

	return var_89_0 and var_89_0:ready() and not var_89_0:get_current_commit_id() and not var_89_0:have_queued_commit()
end

local var_0_2 = {}

function BackendManagerPlayFab.get_level_variation_data(arg_90_0)
	if not arg_90_0._backend_mirror then
		return var_0_2
	end

	local var_90_0 = arg_90_0._backend_mirror:get_title_data().level_variation_data

	return var_90_0 and cjson.decode(var_90_0) or var_0_2
end

function BackendManagerPlayFab.get_deus_weapon_preload_settings(arg_91_0)
	if not arg_91_0._backend_mirror then
		return var_0_2
	end

	local var_91_0 = arg_91_0._backend_mirror:get_title_data().deus_weapon_preload_settings

	return var_91_0 and cjson.decode(var_91_0) or var_0_2
end

function BackendManagerPlayFab.get_title_settings(arg_92_0)
	if not arg_92_0._backend_mirror then
		return var_0_2
	end

	local var_92_0 = arg_92_0._backend_mirror:get_title_data().title_settings

	return var_92_0 and cjson.decode(var_92_0) or var_0_2
end

function BackendManagerPlayFab.dlc_unlocked_at_signin(arg_93_0, arg_93_1)
	if IS_WINDOWS or IS_LINUX or not arg_93_0._backend_mirror then
		return true
	end

	return arg_93_0._backend_mirror:dlc_unlocked_at_signin(arg_93_1)
end

function BackendManagerPlayFab.get_metadata(arg_94_0)
	return arg_94_0._metadata
end

function BackendManagerPlayFab.get_backend_mirror(arg_95_0)
	return arg_95_0._backend_mirror
end

function BackendManagerPlayFab.get_twitch_app_access_token(arg_96_0)
	return arg_96_0._backend_mirror:get_twitch_app_access_token()
end

function BackendManagerPlayFab.get_current_api_call(arg_97_0)
	if not arg_97_0._backend_mirror then
		return
	end

	return arg_97_0._backend_mirror:current_api_call()
end
