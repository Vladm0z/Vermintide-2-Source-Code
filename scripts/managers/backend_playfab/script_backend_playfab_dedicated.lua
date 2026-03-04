-- chunkname: @scripts/managers/backend_playfab/script_backend_playfab_dedicated.lua

require("scripts/managers/backend_playfab/playfab_mirror_dedicated")
require("scripts/managers/backend_playfab/script_backend_playfab")

local var_0_0 = require("PlayFab.IPlayFabHttps")
local var_0_1 = require("scripts/managers/backend/playfab_https_curl")

var_0_0.SetHttp(var_0_1)

local var_0_2 = require("PlayFab.PlayFabClientApi")

var_0_2.settings.titleId = GameSettingsDevelopment.backend_settings.title_id
ScriptBackendPlayFabDedicated = class(ScriptBackendPlayFabDedicated, ScriptBackendPlayFab)

ScriptBackendPlayFabDedicated.init = function (arg_1_0)
	local var_1_0 = arg_1_0._generate_unique_id()

	arg_1_0._metadata = Managers.backend:get_metadata()

	local var_1_1 = {
		CreateAccount = true,
		CustomId = var_1_0,
		InfoRequestParameters = {
			GetUserReadOnlyData = true,
			GetTitleData = true
		},
		TitleId = var_0_2.settings.titleId
	}

	arg_1_0._signed_in = false

	print("Logging in to Playfab using custom ID")

	local var_1_2 = callback(arg_1_0, "login_request_cb")

	var_0_2.LoginWithCustomID(var_1_1, var_1_2)
end

ScriptBackendPlayFabDedicated.login_request_cb = function (arg_2_0, arg_2_1)
	arg_2_0._signin_result = arg_2_1

	local var_2_0 = arg_2_1.InfoResultPayload.UserReadOnlyData
	local var_2_1 = arg_2_1.PlayFabId

	arg_2_0:_update_telemetry_settings()
	Crashify.print_property("playfab_id", var_2_1)
	cprint("[ScriptBackendPlayFabDedicated] Backend Sign-In Success")
	cprintf("[ScriptBackendPlayFabDedicated] PlayFabId: %s", var_2_1)

	arg_2_0._signed_in = true

	arg_2_0:_validate_version()
end

ScriptBackendPlayFabDedicated._validate_version = function (arg_3_0)
	local var_3_0 = {
		FunctionName = "validateVersion",
		FunctionParameter = {
			Version = VersionSettings.version,
			metadata = arg_3_0._metadata
		}
	}
	local var_3_1 = callback(arg_3_0, "_validate_version_cb")

	var_0_2.ExecuteCloudScript(var_3_0, var_3_1)

	arg_3_0._validating_version = true
end

ScriptBackendPlayFabDedicated._validate_version_cb = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.FunctionResult and arg_4_1.FunctionResult.valid_version

	arg_4_0._validating_version = nil

	if var_4_0 ~= true then
		arg_4_0._signed_in = false
		arg_4_0._signin_result_error = {
			errorCode = BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_UNSUPPORTED_VERSION_ERROR
		}
	end
end

ScriptBackendPlayFabDedicated.update_signin = function (arg_5_0)
	local var_5_0 = arg_5_0._signin_result_error

	if var_5_0 then
		local var_5_1 = var_5_0.errorCode
		local var_5_2 = var_5_0.errorMessage

		return {
			reason = var_5_1,
			details = var_5_2
		}
	end
end

ScriptBackendPlayFabDedicated._generate_unique_id = function ()
	local var_6_0 = Application.machine_id()
	local var_6_1 = Network.default_network_address()
	local var_6_2 = script_data.server_port or script_data.settings.server_port

	if var_6_0 == nil then
		var_6_0 = Application.guid()
	end

	return Application.make_hash(var_6_0, var_6_1, var_6_2)
end
