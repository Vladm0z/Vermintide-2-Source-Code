-- chunkname: @scripts/managers/backend/playfab_https_curl.lua

local var_0_0 = require("PlayFab.json")
local var_0_1 = require("PlayFab.PlayFabSettings")

PlayFabHttpsCurlData = PlayFabHttpsCurlData or {}
PlayFabHttpsCurlData.request_id = PlayFabHttpsCurlData.request_id or 0
PlayFabHttpsCurlData.active_requests = PlayFabHttpsCurlData.active_requests or {}

local var_0_2 = 2
local var_0_3 = {
	1199,
	1342,
	1133,
	1287,
	1127,
	1131,
	1214,
	1123,
	1101
}

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0

	if arg_1_1.data and arg_1_1.data.Error then
		local var_1_1 = arg_1_1.data.Logs

		if var_1_1 then
			for iter_1_0 = 1, #var_1_1 do
				local var_1_2 = var_1_1[iter_1_0].Data

				if var_1_2 then
					local var_1_3 = var_1_2.apiError

					if var_1_3 then
						var_1_0 = var_1_3.errorCode
					end
				end
			end
		end
	elseif arg_1_1.errorCode then
		var_1_0 = arg_1_1.errorCode
	end

	local var_1_4 = table.contains(var_0_3, var_1_0)

	if not var_1_4 then
		local var_1_5 = arg_1_1.data
		local var_1_6 = var_1_5 and var_1_5.Logs

		if var_1_6 then
			for iter_1_1 = 1, #var_1_6 do
				local var_1_7 = var_1_6[iter_1_1]

				if var_1_7.Message == "RetriableError" or var_1_7.Data and var_1_7.Data.error == "Timeout" then
					var_1_4 = true

					break
				end
			end
		end
	end

	if var_1_4 and arg_1_0.retries < var_0_2 then
		local var_1_8 = arg_1_0.url
		local var_1_9 = arg_1_0.body
		local var_1_10 = arg_1_0.headers
		local var_1_11 = arg_1_0.request_cb
		local var_1_12 = arg_1_0.options
		local var_1_13 = var_0_0.decode(var_1_9)

		if not var_1_13.FunctionParameter then
			var_1_13.FunctionParameter = {}
		end

		var_1_13.FunctionParameter.retry = true
		var_1_13.FunctionParameter.final_retry = arg_1_0.retries + 1 == var_0_2

		local var_1_14 = var_0_0.encode(var_1_13)

		var_1_10[4] = "content-length: " .. tostring(string.len(var_1_14))

		Managers.curl:post(var_1_8, var_1_14, var_1_10, var_1_11, arg_1_2, var_1_12)

		arg_1_0.retries = arg_1_0.retries + 1

		local var_1_15 = arg_1_3 and string.format(" | Error Override: %s", arg_1_3) or ""

		printf("[PLAYFAB HTTPS CURL] RESENDING REQUEST. Id: %s | Error Code: %s%s", arg_1_2, var_1_0, var_1_15)
		Crashify.print_exception("Backend_Error", "RESENDING REQUEST: %s", arg_1_0)
	else
		var_1_0 = arg_1_3 and arg_1_3 or var_1_0

		Managers.backend:playfab_api_error(arg_1_1, var_1_0)

		PlayFabHttpsCurlData.active_requests[arg_1_2] = nil
	end
end

function curl_callback(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = PlayFabHttpsCurlData.active_requests[arg_2_4]

	if arg_2_0 then
		local var_2_1, var_2_2 = pcall(var_0_0.decode, arg_2_3)

		if var_2_2 and type(var_2_2) == "table" then
			if var_2_2.code == 200 and var_2_2.data and not var_2_2.data.Error then
				var_2_0.onSuccess(var_2_2.data)

				PlayFabHttpsCurlData.active_requests[arg_2_4] = nil
			elseif var_2_0.onFail then
				var_2_0.onFail(var_2_2)

				PlayFabHttpsCurlData.active_requests[arg_2_4] = nil
			else
				var_0_4(var_2_0, var_2_2, arg_2_4)
			end
		else
			local var_2_3 = {
				error = "ServiceUnavailable",
				errorCode = 1123,
				status = "",
				code = arg_2_1
			}

			if arg_2_3 then
				var_2_3.errorMessage = "Could not deserialize response from server: " .. tostring(arg_2_3)
			else
				var_2_3.errorMessage = "Could not deserialize response from server: NO DATA"
			end

			var_0_4(var_2_0, var_2_3, arg_2_4)
		end
	else
		local var_2_4 = {
			error = "ServiceUnavailable",
			errorCode = 1123,
			status = "",
			code = arg_2_1
		}

		if arg_2_3 then
			var_2_4.errorMessage = "Could not deserialize response from server: " .. tostring(arg_2_3)
		else
			var_2_4.errorMessage = "Could not deserialize response from server: NO DATA"
		end

		var_0_4(var_2_0, var_2_4, arg_2_4, tostring(arg_2_3))
	end
end

return {
	MakePlayFabApiCall = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
		local var_3_0 = var_0_0.encode(arg_3_1)
		local var_3_1 = {
			"X-ReportErrorAsSuccess: true",
			"X-PlayFabSDK: " .. var_0_1._internalSettings.sdkVersionString,
			"Content-Type: application/json",
			"content-length: " .. string.len(var_3_0)
		}

		if arg_3_2 then
			var_3_1[#var_3_1 + 1] = arg_3_2 .. ": " .. arg_3_3
		end

		local var_3_2 = "https://" .. var_0_1.settings.titleId .. ".playfabapi.com"
		local var_3_3 = PlayFabHttpsCurlData.request_id + 1
		local var_3_4 = Managers.curl
		local var_3_5 = var_3_2 .. arg_3_0
		local var_3_6 = {
			[var_3_4._curl.OPT_SSL_OPTIONS] = var_3_4._curl.SSLOPT_NO_REVOKE
		}
		local var_3_7 = {
			retries = 0,
			onSuccess = arg_3_4,
			onFail = arg_3_5,
			url = var_3_5,
			body = var_3_0,
			headers = var_3_1,
			request_cb = curl_callback,
			id = var_3_3,
			options = var_3_6
		}

		PlayFabHttpsCurlData.active_requests[var_3_3] = var_3_7

		var_3_4:post(var_3_5, var_3_0, var_3_1, curl_callback, var_3_3, var_3_6)

		PlayFabHttpsCurlData.request_id = var_3_3
	end
}
