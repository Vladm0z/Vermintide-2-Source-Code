-- chunkname: @PlayFab/PlayFabHttps_LuaSec.lua

local var_0_0 = require("ssl.https")
local var_0_1 = require("ltn12")
local var_0_2 = require("PlayFab.json")
local var_0_3 = require("PlayFab.PlayFabSettings")

return {
	MakePlayFabApiCall = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
		local var_1_0 = var_0_2.encode(arg_1_1)
		local var_1_1 = {
			["X-ReportErrorAsSuccess"] = "true",
			["Content-Type"] = "application/json",
			["X-PlayFabSDK"] = var_0_3._internalSettings.sdkVersionString,
			["content-length"] = tostring(string.len(var_1_0))
		}

		if arg_1_2 then
			var_1_1[arg_1_2] = arg_1_3
		end

		local var_1_2 = {}
		local var_1_3 = "https://" .. var_0_3.settings.titleId .. ".playfabapi.com/" .. arg_1_0
		local var_1_4, var_1_5, var_1_6, var_1_7 = var_0_0.request({
			method = "POST",
			url = var_1_3,
			headers = var_1_1,
			source = var_0_1.source.string(var_1_0),
			sink = var_0_1.sink.table(var_1_2)
		})

		if var_1_5 == 200 then
			local var_1_8, var_1_9 = pcall(var_0_2.decode, var_1_2[1] or "null")

			if var_1_9 and var_1_9.code == 200 and var_1_9.data and arg_1_4 then
				arg_1_4(var_1_9.data)
			elseif var_1_9 and arg_1_5 then
				arg_1_5(var_1_9)
			elseif arg_1_5 then
				arg_1_5({
					errorCode = 1123,
					error = "ServiceUnavailable",
					code = var_1_5,
					status = var_1_7,
					errorMessage = "Could not deserialize reseponse from server: " .. var_1_2[1]
				})
			end
		elseif arg_1_5 then
			arg_1_5({
				errorCode = 1123,
				error = "ServiceUnavailable",
				code = var_1_5,
				status = var_1_7,
				errorMessage = "Could not deserialize reseponse from server: " .. var_1_2[1]
			})
		end
	end
}
