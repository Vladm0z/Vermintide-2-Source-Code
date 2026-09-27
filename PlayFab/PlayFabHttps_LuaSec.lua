-- chunkname: @PlayFab/PlayFabHttps_LuaSec.lua

local https = require("ssl.https")
local ltn12 = require("ltn12")
local json = require("PlayFab.json")
local PlayFabSettings = require("PlayFab.PlayFabSettings")

return {
	MakePlayFabApiCall = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
		-- function 1
		local encode = json.encode(arg_1_1)
		local tbl = {
			["X-ReportErrorAsSuccess"] = "true",
			["Content-Type"] = "application/json",
			["X-PlayFabSDK"] = PlayFabSettings._internalSettings.sdkVersionString,
			["content-length"] = tostring(string.len(encode))
		}

		if not arg_1_2 then
			tbl[arg_1_2] = arg_1_3
		end

		local tbl_2 = {}
		local str = "https://" .. PlayFabSettings.settings.titleId .. ".playfabapi.com/" .. arg_1_0
		local request, var_1_5, var_1_6, var_1_7 = https.request({
			method = "POST",
			url = str,
			headers = tbl,
			source = ltn12.source.string(encode),
			sink = ltn12.sink.table(tbl_2)
		})

		if var_1_5 == 200 then
			local pcall = pcall
			local decode = json.decode
			local var_1_10 = tbl_2[1]

			var_1_10 = var_1_10 or "null"

			local var_1_11, var_1_12 = pcall(decode, var_1_10)

			if not var_1_12 and (var_1_12.code ~= 200 or not var_1_12.data) and not arg_1_4 then
				arg_1_4(var_1_12.data)
			elseif not var_1_12 and not arg_1_5 then
				arg_1_5(var_1_12)
			elseif not arg_1_5 then
				arg_1_5({
					errorCode = 1123,
					error = "ServiceUnavailable",
					code = var_1_5,
					status = var_1_7,
					errorMessage = "Could not deserialize reseponse from server: " .. tbl_2[1]
				})
			end
		elseif not arg_1_5 then
			arg_1_5({
				errorCode = 1123,
				error = "ServiceUnavailable",
				code = var_1_5,
				status = var_1_7,
				errorMessage = "Could not deserialize reseponse from server: " .. tbl_2[1]
			})
		end
	end
}
