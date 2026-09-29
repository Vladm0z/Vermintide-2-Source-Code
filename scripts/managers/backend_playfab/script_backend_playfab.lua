-- chunkname: @scripts/managers/backend_playfab/script_backend_playfab.lua

require("scripts/managers/backend_playfab/playfab_mirror_adventure")
require("scripts/settings/version_settings")
DLCUtils.require_list("playfab_mirror_files")

local IPlayFabHttps = require("PlayFab.IPlayFabHttps")
local playfab_https = require("scripts/managers/backend/playfab_https_curl")

IPlayFabHttps.SetHttp(playfab_https)

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

PlayFabClientApi.settings.titleId = GameSettingsDevelopment.backend_settings.title_id
ScriptBackendPlayFab = class(ScriptBackendPlayFab)

ScriptBackendPlayFab.init = function (self)
	-- function 1
	if HAS_STEAM then
		self._steam_ticket_id = Steam.retrieve_auth_session_ticket("AzurePlayFab")
	elseif GameSettingsDevelopment.use_offline_backend then
		-- Nothing
	end

	self._metadata = Managers.backend:get_metadata()
end

ScriptBackendPlayFab.update_state = function (self)
	-- function 2
	return
end

ScriptBackendPlayFab.update_signin = function (self)
	-- function 3
	if self._steam_ticket_id then
		local ticket

		if HAS_STEAM then
			ticket = Steam.poll_auth_session_ticket(self._steam_ticket_id)
		elseif GameSettingsDevelopment.use_offline_backend then
			-- Nothing
		end

		if ticket then
			local login_request = {
				TicketIsServiceSpecific = true,
				CreateAccount = true,
				TitleId = PlayFabClientApi.settings.titleId,
				SteamTicket = ticket,
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
			local login_request_cb = callback(self, "login_request_cb")

			PlayFabClientApi.LoginWithSteam(login_request, login_request_cb)

			self._steam_ticket_id = nil
		end
	end

	local signin_result = self._signin_result_error

	if signin_result then
		local error_code = signin_result.errorCode
		local error_message = signin_result.errorMessage

		return {
			reason = error_code,
			details = error_message
		}
	end

	local initial_set_up_result = self._initial_set_up_result_error

	if initial_set_up_result then
		local error_code = initial_set_up_result.errorCode
		local error_message = initial_set_up_result.errorMessage

		return {
			reason = error_code,
			details = error_message
		}
	end

	local initial_data_set_up_result = self._initial_data_set_up_result_error

	if initial_data_set_up_result then
		local error_code = initial_data_set_up_result.errorCode
		local error_message = initial_data_set_up_result.errorMessage

		return {
			reason = error_code,
			details = error_message
		}
	end

	return nil
end

ScriptBackendPlayFab.login_request_cb = function (self, result)
	-- function 4
	self._signin_result = result

	local info_result_payload = result.InfoResultPayload
	local read_only_data = info_result_payload.UserReadOnlyData
	local playfab_id = result.PlayFabId

	Crashify.print_property("playfab_id", playfab_id)
	Managers.telemetry_events:player_authenticated(playfab_id)
	self:_update_telemetry_settings()

	local account_set_up = read_only_data.account_set_up
	local initial_inventory_setup = read_only_data.initial_inventory_setup

	self._setup_initial_account_needed = not not result.NewlyCreated
	self._setup_initial_inventory_needed = not initial_inventory_setup or initial_inventory_setup.Value == "false"

	self:_validate_version()

	self._signed_in = true
end

ScriptBackendPlayFab._update_telemetry_settings = function (self)
	-- function 5
	local settings_override = self._signin_result.InfoResultPayload.TitleData.telemetry_settings_override

	if settings_override then
		table.merge(TelemetrySettings, cjson.decode(settings_override))
		Managers.telemetry:reload_settings()
	end
end

ScriptBackendPlayFab._validate_version = function (self)
	-- function 6
	local request = {
		FunctionName = "validateVersion",
		FunctionParameter = {
			Version = VersionSettings.version,
			metadata = self._metadata
		}
	}
	local callback = callback(self, "_validate_version_cb")

	PlayFabClientApi.ExecuteCloudScript(request, callback)

	self._validating_version = true
end

ScriptBackendPlayFab._validate_version_cb = function (self, result)
	-- function 7
	local valid = not not result.FunctionResult

	self._validating_version = nil

	if valid ~= true then
		self._signed_in = false
		self._signin_result_error = {
			errorCode = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_UNSUPPORTED_VERSION_ERROR
		}
	elseif self._setup_initial_account_needed then
		self:_set_up_initial_account()
	elseif self._setup_initial_inventory_needed then
		self:_set_up_initial_inventory()
	end
end

ScriptBackendPlayFab._set_up_initial_account = function (self)
	-- function 8
	local initial_account_set_up = {
		FunctionName = "initialAccountSetUp",
		FunctionParameter = {
			metadata = self._metadata
		}
	}
	local initial_setup_request_cb = callback(self, "initial_setup_request_cb")

	PlayFabClientApi.ExecuteCloudScript(initial_account_set_up, initial_setup_request_cb)

	self._setting_up_initial_account = true
end

ScriptBackendPlayFab.initial_setup_request_cb = function (self, result)
	-- function 9
	local read_only_data = result.FunctionResult.read_only_data

	if read_only_data then
		for key, data in pairs(read_only_data) do
			self._signin_result.InfoResultPayload.UserReadOnlyData[key] = {
				Value = data
			}
		end
	end

	self:_set_up_initial_inventory()

	self._setting_up_initial_account = false
	self._setup_initial_account_needed = nil
end

ScriptBackendPlayFab._set_up_initial_inventory = function (self, start_index)
	-- function 10
	local initial_account_data_set_up = {
		FunctionName = "initialInventorySetup",
		FunctionParameter = {
			start_index = not not start_index or not not 0,
			metadata = self._metadata
		}
	}
	local initial_inventory_setup_request_cb = callback(self, "initial_inventory_setup_request_cb")

	PlayFabClientApi.ExecuteCloudScript(initial_account_data_set_up, initial_inventory_setup_request_cb)

	self._setting_up_initial_inventory = true
end

ScriptBackendPlayFab.initial_inventory_setup_request_cb = function (self, result)
	-- function 11
	local done = result.FunctionResult.done

	if not done then
		local new_start_index = result.FunctionResult.new_start_index

		self:_set_up_initial_inventory(new_start_index)
	else
		self._setting_up_initial_inventory = false
		self._setup_initial_inventory_needed = nil
	end
end

ScriptBackendPlayFab.authenticated = function (self)
	-- function 12
	if self._validating_version or self._setting_up_initial_account or self._setting_up_initial_inventory then
		return false
	end

	return self._signed_in
end

ScriptBackendPlayFab.get_signin_result = function (self)
	-- function 13
	return self._signin_result
end

ScriptBackendPlayFab.destroy = function (self)
	-- function 14
	return
end
