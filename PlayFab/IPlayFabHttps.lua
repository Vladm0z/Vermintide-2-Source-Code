-- chunkname: @PlayFab/IPlayFabHttps.lua

local var_0_0 = require("PlayFab.PlayFabSettings")
local var_0_1 = {
	_defaultHttpsFile = "PlayFab.PlayFabHttps_LuaSec"
}

var_0_1.SetHttp = function (arg_1_0)
	if arg_1_0 then
		var_0_1._internalHttp = arg_1_0

		return
	end

	if var_0_1._defaultHttpsFile then
		var_0_1._internalHttp = require(var_0_1._defaultHttpsFile)

		return
	end
end

var_0_1.MakePlayFabApiCall = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if var_0_1._internalHttp == nil then
		var_0_1.SetHttp(nil)
	end

	if var_0_0.settings.titleId == nil then
		error("PlayFabSettings.settings.titleId must be set before making API calls")
	end

	var_0_1._internalHttp.MakePlayFabApiCall(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end

return var_0_1
