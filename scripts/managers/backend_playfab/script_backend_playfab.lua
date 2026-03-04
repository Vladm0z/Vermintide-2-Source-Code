-- chunkname: @scripts/managers/backend_playfab/script_backend_playfab.lua

require("scripts/managers/backend_playfab/playfab_mirror_adventure")
require("scripts/settings/version_settings")
DLCUtils.require_list("playfab_mirror_files")

local var_0_0 = require("PlayFab.IPlayFabHttps")
local var_0_1 = require("scripts/managers/backend/playfab_https_curl")

var_0_0.SetHttp(var_0_1)

local var_0_2 = require("PlayFab.PlayFabClientApi")

var_0_2.settings.titleId = GameSettingsDevelopment.backend_settings.title_id
ScriptBackendPlayFab = class(ScriptBackendPlayFab)

ScriptBackendPlayFab.init = function (arg_1_0)
	if HAS_STEAM then
		arg_1_0._steam_ticket_id = Steam.retrieve_auth_session_ticket("AzurePlayFab")
	elseif GameSettingsDevelopment.use_offline_backend then
		-- Nothing
	end

	arg_1_0._metadata = Managers.backend:get_metadata()
end

ScriptBackendPlayFab.update_state = function (arg_2_0)
	return
end

ScriptBackendPlayFab.update_signin = function (arg_3_0)
	if arg_3_0._steam_ticket_id then
		local var_3_0

		if HAS_STEAM then
			var_3_0 = Steam.poll_auth_session_ticket(arg_3_0._steam_ticket_id)
		elseif GameSettingsDevelopment.use_offline_backend then
			-- Nothing
		end

		if var_3_0 then
			local var_3_1 = {
				TicketIsServiceSpecific = true,
				CreateAccount = true,
				TitleId = var_0_2.settings.titleId,
				SteamTicket = var_3_0,
				InfoRequestParameters = {
					GetUserReadOnlyData = true,
					GetUserData = true,
					GetPlayerProfile = true,
					GetUserAccountInfo = true,
					GetTitleData = true,
					ProfileConstraints = {
						ShowBannedUntil = true
					}
				}
			}
			local var_3_2 = callback(arg_3_0, "login_request_cb")

			var_0_2.LoginWithSteam(var_3_1, var_3_2)

			arg_3_0._steam_ticket_id = nil
		end
	end

	local var_3_3 = arg_3_0._signin_result_error

	if var_3_3 then
		local var_3_4 = var_3_3.errorCode
		local var_3_5 = var_3_3.errorMessage

		return {
			reason = var_3_4,
			details = var_3_5
		}
	end

	local var_3_6 = arg_3_0._initial_set_up_result_error

	if var_3_6 then
		local var_3_7 = var_3_6.errorCode
		local var_3_8 = var_3_6.errorMessage

		return {
			reason = var_3_7,
			details = var_3_8
		}
	end

	local var_3_9 = arg_3_0._initial_data_set_up_result_error

	if var_3_9 then
		local var_3_10 = var_3_9.errorCode
		local var_3_11 = var_3_9.errorMessage

		return {
			reason = var_3_10,
			details = var_3_11
		}
	end

	return nil
end

ScriptBackendPlayFab.login_request_cb = function (arg_4_0, arg_4_1)
	arg_4_0._signin_result = arg_4_1

	local var_4_0 = arg_4_1.InfoResultPayload.UserReadOnlyData
	local var_4_1 = arg_4_1.PlayFabId

	Crashify.print_property("playfab_id", var_4_1)
	Managers.telemetry_events:player_authenticated(var_4_1)
	arg_4_0:_update_telemetry_settings()

	local var_4_2 = var_4_0.account_set_up
	local var_4_3 = var_4_0.initial_inventory_setup

	arg_4_0._setup_initial_account_needed = arg_4_1.NewlyCreated or not var_4_2 or var_4_2.Value == "false"
	arg_4_0._setup_initial_inventory_needed = not var_4_3 or var_4_3.Value == "false"

	arg_4_0:_validate_version()

	arg_4_0._signed_in = true
end

ScriptBackendPlayFab._update_telemetry_settings = function (arg_5_0)
	local var_5_0 = arg_5_0._signin_result.InfoResultPayload.TitleData.telemetry_settings_override

	if var_5_0 then
		table.merge(TelemetrySettings, cjson.decode(var_5_0))
		Managers.telemetry:reload_settings()
	end
end

ScriptBackendPlayFab._validate_version = function (arg_6_0)
	local var_6_0 = {
		FunctionName = "validateVersion",
		FunctionParameter = {
			Version = VersionSettings.version,
			metadata = arg_6_0._metadata
		}
	}
	local var_6_1 = callback(arg_6_0, "_validate_version_cb")

	var_0_2.ExecuteCloudScript(var_6_0, var_6_1)

	arg_6_0._validating_version = true
end

ScriptBackendPlayFab._validate_version_cb = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.FunctionResult and arg_7_1.FunctionResult.valid_version

	arg_7_0._validating_version = nil

	if var_7_0 ~= true then
		arg_7_0._signed_in = false
		arg_7_0._signin_result_error = {
			errorCode = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_UNSUPPORTED_VERSION_ERROR
		}
	elseif arg_7_0._setup_initial_account_needed then
		arg_7_0:_set_up_initial_account()
	elseif arg_7_0._setup_initial_inventory_needed then
		arg_7_0:_set_up_initial_inventory()
	end
end

ScriptBackendPlayFab._set_up_initial_account = function (arg_8_0)
	local var_8_0 = {
		FunctionName = "initialAccountSetUp",
		FunctionParameter = {
			metadata = arg_8_0._metadata
		}
	}
	local var_8_1 = callback(arg_8_0, "initial_setup_request_cb")

	var_0_2.ExecuteCloudScript(var_8_0, var_8_1)

	arg_8_0._setting_up_initial_account = true
end

ScriptBackendPlayFab.initial_setup_request_cb = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.FunctionResult.read_only_data

	if var_9_0 then
		for iter_9_0, iter_9_1 in pairs(var_9_0) do
			arg_9_0._signin_result.InfoResultPayload.UserReadOnlyData[iter_9_0] = {
				Value = iter_9_1
			}
		end
	end

	arg_9_0:_set_up_initial_inventory()

	arg_9_0._setting_up_initial_account = false
	arg_9_0._setup_initial_account_needed = nil
end

ScriptBackendPlayFab._set_up_initial_inventory = function (arg_10_0, arg_10_1)
	local var_10_0 = {
		FunctionName = "initialInventorySetup",
		FunctionParameter = {
			start_index = arg_10_1 or 0,
			metadata = arg_10_0._metadata
		}
	}
	local var_10_1 = callback(arg_10_0, "initial_inventory_setup_request_cb")

	var_0_2.ExecuteCloudScript(var_10_0, var_10_1)

	arg_10_0._setting_up_initial_inventory = true
end

ScriptBackendPlayFab.initial_inventory_setup_request_cb = function (arg_11_0, arg_11_1)
	if not arg_11_1.FunctionResult.done then
		local var_11_0 = arg_11_1.FunctionResult.new_start_index

		arg_11_0:_set_up_initial_inventory(var_11_0)
	else
		arg_11_0._setting_up_initial_inventory = false
		arg_11_0._setup_initial_inventory_needed = nil
	end
end

ScriptBackendPlayFab.authenticated = function (arg_12_0)
	if arg_12_0._validating_version or arg_12_0._setting_up_initial_account or arg_12_0._setting_up_initial_inventory then
		return false
	end

	return arg_12_0._signed_in
end

ScriptBackendPlayFab.get_signin_result = function (arg_13_0)
	return arg_13_0._signin_result
end

ScriptBackendPlayFab.destroy = function (arg_14_0)
	return
end
