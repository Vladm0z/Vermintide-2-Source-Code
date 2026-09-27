-- chunkname: @scripts/managers/backend_playfab/script_backend_playfab.lua

require("scripts/managers/backend_playfab/playfab_mirror_adventure")
require("scripts/settings/version_settings")
DLCUtils.require_list("playfab_mirror_files")

local IPlayFabHttps = require("PlayFab.IPlayFabHttps")
local scripts_managers_backend_playfab_https_curl = require("scripts/managers/backend/playfab_https_curl")

IPlayFabHttps.SetHttp(scripts_managers_backend_playfab_https_curl)

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

PlayFabClientApi.settings.titleId = GameSettingsDevelopment.backend_settings.title_id
ScriptBackendPlayFab = class(ScriptBackendPlayFab)

ScriptBackendPlayFab.init = function (self)
	-- function 1
	if not HAS_STEAM then
		self._steam_ticket_id = Steam.retrieve_auth_session_ticket("AzurePlayFab")
	elseif not GameSettingsDevelopment.use_offline_backend then
		-- Nothing
	end

	self._metadata = Managers.backend:get_metadata()
end

ScriptBackendPlayFab.update_state = function (arg_2_0)
	-- function 2
	return
end

ScriptBackendPlayFab.update_signin = function (self)
	-- function 3
	if not self._steam_ticket_id then
		local var_3_0

		if not HAS_STEAM then
			var_3_0 = Steam.poll_auth_session_ticket(self._steam_ticket_id)
		elseif not GameSettingsDevelopment.use_offline_backend then
			-- Nothing
		end

		if not var_3_0 then
			local tbl = {
				TicketIsServiceSpecific = true,
				CreateAccount = true,
				TitleId = PlayFabClientApi.settings.titleId,
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
			local var_3_2 = callback(self, "login_request_cb")

			PlayFabClientApi.LoginWithSteam(tbl, var_3_2)

			self._steam_ticket_id = nil
		end
	end

	local _signin_result_error = self._signin_result_error

	if not _signin_result_error then
		local errorCode = _signin_result_error.errorCode
		local errorMessage = _signin_result_error.errorMessage

		return {
			reason = errorCode,
			details = errorMessage
		}
	end

	local _initial_set_up_result_error = self._initial_set_up_result_error

	if not _initial_set_up_result_error then
		local errorCode_2 = _initial_set_up_result_error.errorCode
		local errorMessage_2 = _initial_set_up_result_error.errorMessage

		return {
			reason = errorCode_2,
			details = errorMessage_2
		}
	end

	local _initial_data_set_up_result_error = self._initial_data_set_up_result_error

	if not _initial_data_set_up_result_error then
		local errorCode_3 = _initial_data_set_up_result_error.errorCode
		local errorMessage_3 = _initial_data_set_up_result_error.errorMessage

		return {
			reason = errorCode_3,
			details = errorMessage_3
		}
	end

	return nil
end

ScriptBackendPlayFab.login_request_cb = function (self, arg_4_1)
	-- function 4
	self._signin_result = arg_4_1

	local UserReadOnlyData = arg_4_1.InfoResultPayload.UserReadOnlyData
	local PlayFabId = arg_4_1.PlayFabId

	Crashify.print_property("playfab_id", PlayFabId)
	Managers.telemetry_events:player_authenticated(PlayFabId)
	self:_update_telemetry_settings()

	local account_set_up = UserReadOnlyData.account_set_up
	local initial_inventory_setup = UserReadOnlyData.initial_inventory_setup
	local NewlyCreated = arg_4_1.NewlyCreated

	NewlyCreated = (NewlyCreated or not account_set_up) and account_set_up.Value == "false"
	self._setup_initial_account_needed = NewlyCreated
	self._setup_initial_inventory_needed = not initial_inventory_setup and initial_inventory_setup.Value == "false"

	self:_validate_version()

	self._signed_in = true
end

ScriptBackendPlayFab._update_telemetry_settings = function (self)
	-- function 5
	local telemetry_settings_override = self._signin_result.InfoResultPayload.TitleData.telemetry_settings_override

	if not telemetry_settings_override then
		table.merge(TelemetrySettings, cjson.decode(telemetry_settings_override))
		Managers.telemetry:reload_settings()
	end
end

ScriptBackendPlayFab._validate_version = function (self)
	-- function 6
	local tbl = {
		FunctionName = "validateVersion",
		FunctionParameter = {
			Version = VersionSettings.version,
			metadata = self._metadata
		}
	}
	local var_6_1 = callback(self, "_validate_version_cb")

	PlayFabClientApi.ExecuteCloudScript(tbl, var_6_1)

	self._validating_version = true
end

ScriptBackendPlayFab._validate_version_cb = function (self, arg_7_1)
	-- function 7
	local FunctionResult = arg_7_1.FunctionResult

	FunctionResult = not FunctionResult and arg_7_1.FunctionResult.valid_version
	self._validating_version = nil

	if FunctionResult ~= true then
		self._signed_in = false
		self._signin_result_error = {
			errorCode = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_UNSUPPORTED_VERSION_ERROR
		}
	elseif not self._setup_initial_account_needed then
		self:_set_up_initial_account()
	elseif not self._setup_initial_inventory_needed then
		self:_set_up_initial_inventory()
	end
end

ScriptBackendPlayFab._set_up_initial_account = function (self)
	-- function 8
	local tbl = {
		FunctionName = "initialAccountSetUp",
		FunctionParameter = {
			metadata = self._metadata
		}
	}
	local var_8_1 = callback(self, "initial_setup_request_cb")

	PlayFabClientApi.ExecuteCloudScript(tbl, var_8_1)

	self._setting_up_initial_account = true
end

ScriptBackendPlayFab.initial_setup_request_cb = function (self, arg_9_1)
	-- function 9
	local read_only_data = arg_9_1.FunctionResult.read_only_data

	if not read_only_data then
		for k, v in pairs(read_only_data) do
			self._signin_result.InfoResultPayload.UserReadOnlyData[k] = {
				Value = v
			}
		end
	end

	self:_set_up_initial_inventory()

	self._setting_up_initial_account = false
	self._setup_initial_account_needed = nil
end

ScriptBackendPlayFab._set_up_initial_inventory = function (self, arg_10_1)
	-- function 10
	local tbl = {
		FunctionName = "initialInventorySetup",
		FunctionParameter = {
			start_index = arg_10_1 or 0,
			metadata = self._metadata
		}
	}
	local var_10_1 = callback(self, "initial_inventory_setup_request_cb")

	PlayFabClientApi.ExecuteCloudScript(tbl, var_10_1)

	self._setting_up_initial_inventory = true
end

ScriptBackendPlayFab.initial_inventory_setup_request_cb = function (self, arg_11_1)
	-- function 11
	if not arg_11_1.FunctionResult.done then
		local new_start_index = arg_11_1.FunctionResult.new_start_index

		self:_set_up_initial_inventory(new_start_index)
	else
		self._setting_up_initial_inventory = false
		self._setup_initial_inventory_needed = nil
	end
end

ScriptBackendPlayFab.authenticated = function (self)
	-- function 12
	if self._validating_version or self._setting_up_initial_account or not self._setting_up_initial_inventory then
		return false
	end

	return self._signed_in
end

ScriptBackendPlayFab.get_signin_result = function (self)
	-- function 13
	return self._signin_result
end

ScriptBackendPlayFab.destroy = function (arg_14_0)
	-- function 14
	return
end
