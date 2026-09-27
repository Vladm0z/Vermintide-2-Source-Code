-- chunkname: @scripts/managers/backend/playfab_https_curl.lua

local json = require("PlayFab.json")
local PlayFabSettings = require("PlayFab.PlayFabSettings")
local PlayFabHttpsCurlData = PlayFabHttpsCurlData

PlayFabHttpsCurlData = PlayFabHttpsCurlData or {}
PlayFabHttpsCurlData = PlayFabHttpsCurlData

local PlayFabHttpsCurlData_2 = PlayFabHttpsCurlData
local request_id = PlayFabHttpsCurlData.request_id

request_id = request_id or 0
PlayFabHttpsCurlData_2.request_id = request_id

local PlayFabHttpsCurlData_3 = PlayFabHttpsCurlData
local active_requests = PlayFabHttpsCurlData.active_requests

active_requests = active_requests or {}
PlayFabHttpsCurlData_3.active_requests = active_requests

local num = 2
local tbl = {
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

local function fn(self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local var_1_0

	if not arg_1_1.data and not arg_1_1.data.Error then
		local Logs = arg_1_1.data.Logs

		if not Logs then
			for i = 1, #Logs do
				local Data = Logs[i].Data

				if not Data then
					local apiError = Data.apiError

					if not apiError then
						var_1_0 = apiError.errorCode
					end
				end
			end
		end
	elseif not arg_1_1.errorCode then
		var_1_0 = arg_1_1.errorCode
	end

	local contains = table.contains(tbl, var_1_0)

	if not contains then
		local data = arg_1_1.data
		local flag = not data and data.Logs

		if not flag then
			for j = 1, #flag do
				local var_1_7 = flag[j]

				if not ((var_1_7.Message == "RetriableError" or not var_1_7.Data) and var_1_7.Data.error ~= "Timeout") then
					contains = true

					break
				end
			end
		end
	end

	if not (not contains and not (self.retries < num)) then
		local url = self.url
		local body = self.body
		local headers = self.headers
		local request_cb = self.request_cb
		local options = self.options
		local decode = json.decode(body)

		if not decode.FunctionParameter then
			decode.FunctionParameter = {}
		end

		decode.FunctionParameter.retry = true
		decode.FunctionParameter.final_retry = self.retries + 1 == num

		local encode = json.encode(decode)

		headers[4] = "content-length: " .. tostring(string.len(encode))

		Managers.curl:post(url, encode, headers, request_cb, arg_1_2, options)

		self.retries = self.retries + 1

		local format

		if not arg_1_3 then
			format = string.format(" | Error Override: %s", arg_1_3)

			if not format then
				-- Nothing
			end
		end

		format = ""

		::label_1_0::

		printf("[PLAYFAB HTTPS CURL] RESENDING REQUEST. Id: %s | Error Code: %s%s", arg_1_2, var_1_0, format)
		Crashify.print_exception("Backend_Error", "RESENDING REQUEST: %s", self)
	else
		var_1_0 = not arg_1_3 and arg_1_3 and var_1_0

		Managers.backend:playfab_api_error(arg_1_1, var_1_0)

		PlayFabHttpsCurlData.active_requests[arg_1_2] = nil
	end
end

function curl_callback(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local var_2_0 = PlayFabHttpsCurlData.active_requests[arg_2_4]

	if not arg_2_0 then
		local var_2_1, var_2_2 = pcall(json.decode, arg_2_3)

		if not (not var_2_2 and type(var_2_2) ~= "table") then
			if not ((var_2_2.code ~= 200 or not var_2_2.data) and var_2_2.data.Error) then
				var_2_0.onSuccess(var_2_2.data)

				PlayFabHttpsCurlData.active_requests[arg_2_4] = nil
			elseif not var_2_0.onFail then
				var_2_0.onFail(var_2_2)

				PlayFabHttpsCurlData.active_requests[arg_2_4] = nil
			else
				fn(var_2_0, var_2_2, arg_2_4)
			end
		else
			local tbl = {
				error = "ServiceUnavailable",
				errorCode = 1123,
				status = "",
				code = arg_2_1
			}

			if not arg_2_3 then
				tbl.errorMessage = "Could not deserialize response from server: " .. tostring(arg_2_3)
			else
				tbl.errorMessage = "Could not deserialize response from server: NO DATA"
			end

			fn(var_2_0, tbl, arg_2_4)
		end
	else
		local tbl_2 = {
			error = "ServiceUnavailable",
			errorCode = 1123,
			status = "",
			code = arg_2_1
		}

		if not arg_2_3 then
			tbl_2.errorMessage = "Could not deserialize response from server: " .. tostring(arg_2_3)
		else
			tbl_2.errorMessage = "Could not deserialize response from server: NO DATA"
		end

		fn(var_2_0, tbl_2, arg_2_4, tostring(arg_2_3))
	end
end

return {
	MakePlayFabApiCall = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
		-- function 3
		local encode = json.encode(arg_3_1)
		local tbl = {
			"X-ReportErrorAsSuccess: true",
			"X-PlayFabSDK: " .. PlayFabSettings._internalSettings.sdkVersionString,
			"Content-Type: application/json",
			"content-length: " .. string.len(encode)
		}

		if not arg_3_2 then
			tbl[#tbl + 1] = arg_3_2 .. ": " .. arg_3_3
		end

		local str = "https://" .. PlayFabSettings.settings.titleId .. ".playfabapi.com"
		local num = PlayFabHttpsCurlData.request_id + 1
		local curl = Managers.curl
		local str_2 = str .. arg_3_0
		local tbl_2 = {
			[curl._curl.OPT_SSL_OPTIONS] = curl._curl.SSLOPT_NO_REVOKE
		}
		local tbl_3 = {
			retries = 0,
			onSuccess = arg_3_4,
			onFail = arg_3_5,
			url = str_2,
			body = encode,
			headers = tbl,
			request_cb = curl_callback,
			id = num,
			options = tbl_2
		}

		PlayFabHttpsCurlData.active_requests[num] = tbl_3

		curl:post(str_2, encode, tbl, curl_callback, num, tbl_2)

		PlayFabHttpsCurlData.request_id = num
	end
}
