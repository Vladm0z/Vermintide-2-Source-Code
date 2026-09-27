-- chunkname: @PlayFab/IPlayFabHttps.lua

local PlayFabSettings = require("PlayFab.PlayFabSettings")
local tbl = {
	_defaultHttpsFile = "PlayFab.PlayFabHttps_LuaSec"
}

tbl.SetHttp = function (arg_1_0)
	-- function 1
	if not arg_1_0 then
		tbl._internalHttp = arg_1_0

		return
	end

	if not tbl._defaultHttpsFile then
		tbl._internalHttp = require(tbl._defaultHttpsFile)

		return
	end
end

tbl.MakePlayFabApiCall = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if tbl._internalHttp == nil then
		tbl.SetHttp(nil)
	end

	if PlayFabSettings.settings.titleId == nil then
		error("PlayFabSettings.settings.titleId must be set before making API calls")
	end

	tbl._internalHttp.MakePlayFabApiCall(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end

return tbl
