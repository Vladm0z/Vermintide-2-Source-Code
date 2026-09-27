-- chunkname: @scripts/managers/backend_playfab/script_backend_playfab_dedicated.lua

require("scripts/managers/backend_playfab/playfab_mirror_dedicated")
require("scripts/managers/backend_playfab/script_backend_playfab")

local IPlayFabHttps = require("PlayFab.IPlayFabHttps")
local scripts_managers_backend_playfab_https_curl = require("scripts/managers/backend/playfab_https_curl")

IPlayFabHttps.SetHttp(scripts_managers_backend_playfab_https_curl)

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

PlayFabClientApi.settings.titleId = GameSettingsDevelopment.backend_settings.title_id
ScriptBackendPlayFabDedicated = class(ScriptBackendPlayFabDedicated, ScriptBackendPlayFab)

ScriptBackendPlayFabDedicated.init = function (self)
	-- function 1
	local _generate_unique_id = self._generate_unique_id()

	self._metadata = Managers.backend:get_metadata()

	local tbl = {
		CreateAccount = true,
		CustomId = _generate_unique_id,
		InfoRequestParameters = {
			GetUserReadOnlyData = true,
			GetTitleData = true
		},
		TitleId = PlayFabClientApi.settings.titleId
	}

	self._signed_in = false

	print("Logging in to Playfab using custom ID")

	local var_1_2 = callback(self, "login_request_cb")

	PlayFabClientApi.LoginWithCustomID(tbl, var_1_2)
end

ScriptBackendPlayFabDedicated.login_request_cb = function (self, arg_2_1)
	-- function 2
	self._signin_result = arg_2_1

	local UserReadOnlyData = arg_2_1.InfoResultPayload.UserReadOnlyData
	local PlayFabId = arg_2_1.PlayFabId

	self:_update_telemetry_settings()
	Crashify.print_property("playfab_id", PlayFabId)
	cprint("[ScriptBackendPlayFabDedicated] Backend Sign-In Success")
	cprintf("[ScriptBackendPlayFabDedicated] PlayFabId: %s", PlayFabId)

	self._signed_in = true

	self:_validate_version()
end

ScriptBackendPlayFabDedicated._validate_version = function (self)
	-- function 3
	local tbl = {
		FunctionName = "validateVersion",
		FunctionParameter = {
			Version = VersionSettings.version,
			metadata = self._metadata
		}
	}
	local var_3_1 = callback(self, "_validate_version_cb")

	PlayFabClientApi.ExecuteCloudScript(tbl, var_3_1)

	self._validating_version = true
end

ScriptBackendPlayFabDedicated._validate_version_cb = function (self, arg_4_1)
	-- function 4
	local FunctionResult = arg_4_1.FunctionResult

	FunctionResult = not FunctionResult and arg_4_1.FunctionResult.valid_version
	self._validating_version = nil

	if FunctionResult ~= true then
		self._signed_in = false
		self._signin_result_error = {
			errorCode = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_UNSUPPORTED_VERSION_ERROR
		}
	end
end

ScriptBackendPlayFabDedicated.update_signin = function (self)
	-- function 5
	local _signin_result_error = self._signin_result_error

	if not _signin_result_error then
		local errorCode = _signin_result_error.errorCode
		local errorMessage = _signin_result_error.errorMessage

		return {
			reason = errorCode,
			details = errorMessage
		}
	end
end

ScriptBackendPlayFabDedicated._generate_unique_id = function ()
	-- function 6
	local machine_id = Application.machine_id()
	local default_network_address = Network.default_network_address()
	local server_port = script_data.server_port

	server_port = server_port or script_data.settings.server_port

	if machine_id == nil then
		machine_id = Application.guid()
	end

	return Application.make_hash(machine_id, default_network_address, server_port)
end
