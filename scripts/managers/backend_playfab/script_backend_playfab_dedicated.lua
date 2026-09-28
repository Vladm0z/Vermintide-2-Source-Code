-- chunkname: @scripts/managers/backend_playfab/script_backend_playfab_dedicated.lua

require("scripts/managers/backend_playfab/playfab_mirror_dedicated")
require("scripts/managers/backend_playfab/script_backend_playfab")

local IPlayFabHttps = require("PlayFab.IPlayFabHttps")
local playfab_https_curl = require("scripts/managers/backend/playfab_https_curl")

IPlayFabHttps.SetHttp(playfab_https_curl)

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

PlayFabClientApi.settings.titleId = GameSettingsDevelopment.backend_settings.title_id
ScriptBackendPlayFabDedicated = class(ScriptBackendPlayFabDedicated, ScriptBackendPlayFab)

ScriptBackendPlayFabDedicated.init = function (self)
	-- function 1
	local unique_id = self._generate_unique_id()

	self._metadata = Managers.backend:get_metadata()

	local login_request = {
		CreateAccount = true,
		CustomId = unique_id,
		InfoRequestParameters = {
			GetUserReadOnlyData = true,
			GetTitleData = true
		},
		TitleId = PlayFabClientApi.settings.titleId
	}

	self._signed_in = false

	print("Logging in to Playfab using custom ID")

	local login_request_cb = callback(self, "login_request_cb")

	PlayFabClientApi.LoginWithCustomID(login_request, login_request_cb)
end

ScriptBackendPlayFabDedicated.login_request_cb = function (self, result)
	-- function 2
	self._signin_result = result

	local info_result_payload = result.InfoResultPayload
	local read_only_data = info_result_payload.UserReadOnlyData
	local playfab_id = result.PlayFabId

	self:_update_telemetry_settings()
	Crashify.print_property("playfab_id", playfab_id)
	cprint("[ScriptBackendPlayFabDedicated] Backend Sign-In Success")
	cprintf("[ScriptBackendPlayFabDedicated] PlayFabId: %s", playfab_id)

	self._signed_in = true

	self:_validate_version()
end

ScriptBackendPlayFabDedicated._validate_version = function (self)
	-- function 3
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

ScriptBackendPlayFabDedicated._validate_version_cb = function (self, result)
	-- function 4
	local FunctionResult = result.FunctionResult

	if FunctionResult then
		-- Nothing
	end

	FunctionResult = result.FunctionResult.valid_version

	local valid = FunctionResult

	::label_4_0::

	self._validating_version = nil

	if valid ~= true then
		self._signed_in = false
		self._signin_result_error = {
			errorCode = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_UNSUPPORTED_VERSION_ERROR
		}
	end
end

ScriptBackendPlayFabDedicated.update_signin = function (self)
	-- function 5
	local signin_result = self._signin_result_error

	if signin_result then
		local error_code = signin_result.errorCode
		local error_message = signin_result.errorMessage

		return {
			reason = error_code,
			details = error_message
		}
	end
end

ScriptBackendPlayFabDedicated._generate_unique_id = function ()
	-- function 6
	local machine_id = Application.machine_id()
	local ip_address = Network.default_network_address()
	local server_port_2 = script_data.server_port

	if not server_port_2 then
		-- Nothing
	end

	server_port_2 = script_data.settings.server_port

	local server_port = server_port_2

	::label_6_0::

	if machine_id == nil then
		machine_id = Application.guid()
	end

	return Application.make_hash(machine_id, ip_address, server_port)
end
