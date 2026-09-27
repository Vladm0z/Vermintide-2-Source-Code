-- chunkname: @PlayFab/PlayFabMatchmakerApi.lua

local IPlayFabHttps = require("PlayFab.IPlayFabHttps")
local PlayFabSettings = require("PlayFab.PlayFabSettings")

return {
	settings = PlayFabSettings.settings,
	AuthUser = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		if not (not PlayFabSettings.settings.titleId and PlayFabSettings.settings.devSecretKey) then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		IPlayFabHttps.MakePlayFabApiCall("/Matchmaker/AuthUser", arg_1_0, "X-SecretKey", PlayFabSettings.settings.devSecretKey, arg_1_1, arg_1_2)
	end,
	PlayerJoined = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		if not (not PlayFabSettings.settings.titleId and PlayFabSettings.settings.devSecretKey) then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		IPlayFabHttps.MakePlayFabApiCall("/Matchmaker/PlayerJoined", arg_2_0, "X-SecretKey", PlayFabSettings.settings.devSecretKey, arg_2_1, arg_2_2)
	end,
	PlayerLeft = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		if not (not PlayFabSettings.settings.titleId and PlayFabSettings.settings.devSecretKey) then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		IPlayFabHttps.MakePlayFabApiCall("/Matchmaker/PlayerLeft", arg_3_0, "X-SecretKey", PlayFabSettings.settings.devSecretKey, arg_3_1, arg_3_2)
	end,
	StartGame = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		if not (not PlayFabSettings.settings.titleId and PlayFabSettings.settings.devSecretKey) then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		IPlayFabHttps.MakePlayFabApiCall("/Matchmaker/StartGame", arg_4_0, "X-SecretKey", PlayFabSettings.settings.devSecretKey, arg_4_1, arg_4_2)
	end,
	UserInfo = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		if not (not PlayFabSettings.settings.titleId and PlayFabSettings.settings.devSecretKey) then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		IPlayFabHttps.MakePlayFabApiCall("/Matchmaker/UserInfo", arg_5_0, "X-SecretKey", PlayFabSettings.settings.devSecretKey, arg_5_1, arg_5_2)
	end
}
