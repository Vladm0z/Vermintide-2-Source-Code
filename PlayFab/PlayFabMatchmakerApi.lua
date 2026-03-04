-- chunkname: @PlayFab/PlayFabMatchmakerApi.lua

local var_0_0 = require("PlayFab.IPlayFabHttps")
local var_0_1 = require("PlayFab.PlayFabSettings")

return {
	settings = var_0_1.settings,
	AuthUser = function (arg_1_0, arg_1_1, arg_1_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Matchmaker/AuthUser", arg_1_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_1_1, arg_1_2)
	end,
	PlayerJoined = function (arg_2_0, arg_2_1, arg_2_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Matchmaker/PlayerJoined", arg_2_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_2_1, arg_2_2)
	end,
	PlayerLeft = function (arg_3_0, arg_3_1, arg_3_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Matchmaker/PlayerLeft", arg_3_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_3_1, arg_3_2)
	end,
	StartGame = function (arg_4_0, arg_4_1, arg_4_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Matchmaker/StartGame", arg_4_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_4_1, arg_4_2)
	end,
	UserInfo = function (arg_5_0, arg_5_1, arg_5_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Matchmaker/UserInfo", arg_5_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_5_1, arg_5_2)
	end
}
