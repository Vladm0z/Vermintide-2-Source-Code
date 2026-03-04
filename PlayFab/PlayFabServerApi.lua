-- chunkname: @PlayFab/PlayFabServerApi.lua

local var_0_0 = require("PlayFab.IPlayFabHttps")
local var_0_1 = require("PlayFab.PlayFabSettings")

return {
	settings = var_0_1.settings,
	AuthenticateSessionTicket = function (arg_1_0, arg_1_1, arg_1_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/AuthenticateSessionTicket", arg_1_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_1_1, arg_1_2)
	end,
	SetPlayerSecret = function (arg_2_0, arg_2_1, arg_2_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SetPlayerSecret", arg_2_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_2_1, arg_2_2)
	end,
	BanUsers = function (arg_3_0, arg_3_1, arg_3_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/BanUsers", arg_3_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_3_1, arg_3_2)
	end,
	GetPlayerProfile = function (arg_4_0, arg_4_1, arg_4_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayerProfile", arg_4_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_4_1, arg_4_2)
	end,
	GetPlayFabIDsFromFacebookIDs = function (arg_5_0, arg_5_1, arg_5_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayFabIDsFromFacebookIDs", arg_5_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_5_1, arg_5_2)
	end,
	GetPlayFabIDsFromSteamIDs = function (arg_6_0, arg_6_1, arg_6_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayFabIDsFromSteamIDs", arg_6_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_6_1, arg_6_2)
	end,
	GetUserAccountInfo = function (arg_7_0, arg_7_1, arg_7_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserAccountInfo", arg_7_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_7_1, arg_7_2)
	end,
	GetUserBans = function (arg_8_0, arg_8_1, arg_8_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserBans", arg_8_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_8_1, arg_8_2)
	end,
	RevokeAllBansForUser = function (arg_9_0, arg_9_1, arg_9_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RevokeAllBansForUser", arg_9_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_9_1, arg_9_2)
	end,
	RevokeBans = function (arg_10_0, arg_10_1, arg_10_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RevokeBans", arg_10_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_10_1, arg_10_2)
	end,
	SendPushNotification = function (arg_11_0, arg_11_1, arg_11_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SendPushNotification", arg_11_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_11_1, arg_11_2)
	end,
	UpdateAvatarUrl = function (arg_12_0, arg_12_1, arg_12_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateAvatarUrl", arg_12_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_12_1, arg_12_2)
	end,
	UpdateBans = function (arg_13_0, arg_13_1, arg_13_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateBans", arg_13_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_13_1, arg_13_2)
	end,
	DeleteUsers = function (arg_14_0, arg_14_1, arg_14_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/DeleteUsers", arg_14_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_14_1, arg_14_2)
	end,
	GetFriendLeaderboard = function (arg_15_0, arg_15_1, arg_15_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetFriendLeaderboard", arg_15_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_15_1, arg_15_2)
	end,
	GetLeaderboard = function (arg_16_0, arg_16_1, arg_16_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetLeaderboard", arg_16_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_16_1, arg_16_2)
	end,
	GetLeaderboardAroundUser = function (arg_17_0, arg_17_1, arg_17_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetLeaderboardAroundUser", arg_17_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_17_1, arg_17_2)
	end,
	GetPlayerCombinedInfo = function (arg_18_0, arg_18_1, arg_18_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayerCombinedInfo", arg_18_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_18_1, arg_18_2)
	end,
	GetPlayerStatistics = function (arg_19_0, arg_19_1, arg_19_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayerStatistics", arg_19_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_19_1, arg_19_2)
	end,
	GetPlayerStatisticVersions = function (arg_20_0, arg_20_1, arg_20_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayerStatisticVersions", arg_20_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_20_1, arg_20_2)
	end,
	GetUserData = function (arg_21_0, arg_21_1, arg_21_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserData", arg_21_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_21_1, arg_21_2)
	end,
	GetUserInternalData = function (arg_22_0, arg_22_1, arg_22_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserInternalData", arg_22_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_22_1, arg_22_2)
	end,
	GetUserPublisherData = function (arg_23_0, arg_23_1, arg_23_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserPublisherData", arg_23_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_23_1, arg_23_2)
	end,
	GetUserPublisherInternalData = function (arg_24_0, arg_24_1, arg_24_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserPublisherInternalData", arg_24_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_24_1, arg_24_2)
	end,
	GetUserPublisherReadOnlyData = function (arg_25_0, arg_25_1, arg_25_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserPublisherReadOnlyData", arg_25_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_25_1, arg_25_2)
	end,
	GetUserReadOnlyData = function (arg_26_0, arg_26_1, arg_26_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserReadOnlyData", arg_26_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_26_1, arg_26_2)
	end,
	UpdatePlayerStatistics = function (arg_27_0, arg_27_1, arg_27_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdatePlayerStatistics", arg_27_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_27_1, arg_27_2)
	end,
	UpdateUserData = function (arg_28_0, arg_28_1, arg_28_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateUserData", arg_28_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_28_1, arg_28_2)
	end,
	UpdateUserInternalData = function (arg_29_0, arg_29_1, arg_29_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateUserInternalData", arg_29_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_29_1, arg_29_2)
	end,
	UpdateUserPublisherData = function (arg_30_0, arg_30_1, arg_30_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateUserPublisherData", arg_30_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_30_1, arg_30_2)
	end,
	UpdateUserPublisherInternalData = function (arg_31_0, arg_31_1, arg_31_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateUserPublisherInternalData", arg_31_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_31_1, arg_31_2)
	end,
	UpdateUserPublisherReadOnlyData = function (arg_32_0, arg_32_1, arg_32_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateUserPublisherReadOnlyData", arg_32_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_32_1, arg_32_2)
	end,
	UpdateUserReadOnlyData = function (arg_33_0, arg_33_1, arg_33_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateUserReadOnlyData", arg_33_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_33_1, arg_33_2)
	end,
	GetCatalogItems = function (arg_34_0, arg_34_1, arg_34_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetCatalogItems", arg_34_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_34_1, arg_34_2)
	end,
	GetPublisherData = function (arg_35_0, arg_35_1, arg_35_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPublisherData", arg_35_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_35_1, arg_35_2)
	end,
	GetTime = function (arg_36_0, arg_36_1, arg_36_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetTime", arg_36_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_36_1, arg_36_2)
	end,
	GetTitleData = function (arg_37_0, arg_37_1, arg_37_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetTitleData", arg_37_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_37_1, arg_37_2)
	end,
	GetTitleInternalData = function (arg_38_0, arg_38_1, arg_38_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetTitleInternalData", arg_38_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_38_1, arg_38_2)
	end,
	GetTitleNews = function (arg_39_0, arg_39_1, arg_39_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetTitleNews", arg_39_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_39_1, arg_39_2)
	end,
	SetPublisherData = function (arg_40_0, arg_40_1, arg_40_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SetPublisherData", arg_40_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_40_1, arg_40_2)
	end,
	SetTitleData = function (arg_41_0, arg_41_1, arg_41_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SetTitleData", arg_41_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_41_1, arg_41_2)
	end,
	SetTitleInternalData = function (arg_42_0, arg_42_1, arg_42_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SetTitleInternalData", arg_42_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_42_1, arg_42_2)
	end,
	AddCharacterVirtualCurrency = function (arg_43_0, arg_43_1, arg_43_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/AddCharacterVirtualCurrency", arg_43_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_43_1, arg_43_2)
	end,
	AddUserVirtualCurrency = function (arg_44_0, arg_44_1, arg_44_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/AddUserVirtualCurrency", arg_44_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_44_1, arg_44_2)
	end,
	ConsumeItem = function (arg_45_0, arg_45_1, arg_45_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/ConsumeItem", arg_45_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_45_1, arg_45_2)
	end,
	EvaluateRandomResultTable = function (arg_46_0, arg_46_1, arg_46_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/EvaluateRandomResultTable", arg_46_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_46_1, arg_46_2)
	end,
	GetCharacterInventory = function (arg_47_0, arg_47_1, arg_47_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetCharacterInventory", arg_47_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_47_1, arg_47_2)
	end,
	GetRandomResultTables = function (arg_48_0, arg_48_1, arg_48_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetRandomResultTables", arg_48_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_48_1, arg_48_2)
	end,
	GetUserInventory = function (arg_49_0, arg_49_1, arg_49_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetUserInventory", arg_49_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_49_1, arg_49_2)
	end,
	GrantItemsToCharacter = function (arg_50_0, arg_50_1, arg_50_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GrantItemsToCharacter", arg_50_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_50_1, arg_50_2)
	end,
	GrantItemsToUser = function (arg_51_0, arg_51_1, arg_51_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GrantItemsToUser", arg_51_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_51_1, arg_51_2)
	end,
	GrantItemsToUsers = function (arg_52_0, arg_52_1, arg_52_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GrantItemsToUsers", arg_52_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_52_1, arg_52_2)
	end,
	ModifyItemUses = function (arg_53_0, arg_53_1, arg_53_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/ModifyItemUses", arg_53_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_53_1, arg_53_2)
	end,
	MoveItemToCharacterFromCharacter = function (arg_54_0, arg_54_1, arg_54_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/MoveItemToCharacterFromCharacter", arg_54_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_54_1, arg_54_2)
	end,
	MoveItemToCharacterFromUser = function (arg_55_0, arg_55_1, arg_55_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/MoveItemToCharacterFromUser", arg_55_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_55_1, arg_55_2)
	end,
	MoveItemToUserFromCharacter = function (arg_56_0, arg_56_1, arg_56_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/MoveItemToUserFromCharacter", arg_56_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_56_1, arg_56_2)
	end,
	RedeemCoupon = function (arg_57_0, arg_57_1, arg_57_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RedeemCoupon", arg_57_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_57_1, arg_57_2)
	end,
	ReportPlayer = function (arg_58_0, arg_58_1, arg_58_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/ReportPlayer", arg_58_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_58_1, arg_58_2)
	end,
	RevokeInventoryItem = function (arg_59_0, arg_59_1, arg_59_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RevokeInventoryItem", arg_59_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_59_1, arg_59_2)
	end,
	SubtractCharacterVirtualCurrency = function (arg_60_0, arg_60_1, arg_60_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SubtractCharacterVirtualCurrency", arg_60_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_60_1, arg_60_2)
	end,
	SubtractUserVirtualCurrency = function (arg_61_0, arg_61_1, arg_61_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SubtractUserVirtualCurrency", arg_61_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_61_1, arg_61_2)
	end,
	UnlockContainerInstance = function (arg_62_0, arg_62_1, arg_62_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UnlockContainerInstance", arg_62_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_62_1, arg_62_2)
	end,
	UnlockContainerItem = function (arg_63_0, arg_63_1, arg_63_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UnlockContainerItem", arg_63_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_63_1, arg_63_2)
	end,
	UpdateUserInventoryItemCustomData = function (arg_64_0, arg_64_1, arg_64_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateUserInventoryItemCustomData", arg_64_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_64_1, arg_64_2)
	end,
	AddFriend = function (arg_65_0, arg_65_1, arg_65_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/AddFriend", arg_65_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_65_1, arg_65_2)
	end,
	GetFriendsList = function (arg_66_0, arg_66_1, arg_66_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetFriendsList", arg_66_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_66_1, arg_66_2)
	end,
	RemoveFriend = function (arg_67_0, arg_67_1, arg_67_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RemoveFriend", arg_67_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_67_1, arg_67_2)
	end,
	SetFriendTags = function (arg_68_0, arg_68_1, arg_68_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SetFriendTags", arg_68_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_68_1, arg_68_2)
	end,
	DeregisterGame = function (arg_69_0, arg_69_1, arg_69_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/DeregisterGame", arg_69_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_69_1, arg_69_2)
	end,
	NotifyMatchmakerPlayerLeft = function (arg_70_0, arg_70_1, arg_70_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/NotifyMatchmakerPlayerLeft", arg_70_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_70_1, arg_70_2)
	end,
	RedeemMatchmakerTicket = function (arg_71_0, arg_71_1, arg_71_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RedeemMatchmakerTicket", arg_71_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_71_1, arg_71_2)
	end,
	RefreshGameServerInstanceHeartbeat = function (arg_72_0, arg_72_1, arg_72_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RefreshGameServerInstanceHeartbeat", arg_72_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_72_1, arg_72_2)
	end,
	RegisterGame = function (arg_73_0, arg_73_1, arg_73_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RegisterGame", arg_73_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_73_1, arg_73_2)
	end,
	SetGameServerInstanceData = function (arg_74_0, arg_74_1, arg_74_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SetGameServerInstanceData", arg_74_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_74_1, arg_74_2)
	end,
	SetGameServerInstanceState = function (arg_75_0, arg_75_1, arg_75_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SetGameServerInstanceState", arg_75_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_75_1, arg_75_2)
	end,
	SetGameServerInstanceTags = function (arg_76_0, arg_76_1, arg_76_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/SetGameServerInstanceTags", arg_76_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_76_1, arg_76_2)
	end,
	WriteCharacterEvent = function (arg_77_0, arg_77_1, arg_77_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/WriteCharacterEvent", arg_77_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_77_1, arg_77_2)
	end,
	WritePlayerEvent = function (arg_78_0, arg_78_1, arg_78_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/WritePlayerEvent", arg_78_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_78_1, arg_78_2)
	end,
	WriteTitleEvent = function (arg_79_0, arg_79_1, arg_79_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/WriteTitleEvent", arg_79_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_79_1, arg_79_2)
	end,
	AddSharedGroupMembers = function (arg_80_0, arg_80_1, arg_80_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/AddSharedGroupMembers", arg_80_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_80_1, arg_80_2)
	end,
	CreateSharedGroup = function (arg_81_0, arg_81_1, arg_81_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/CreateSharedGroup", arg_81_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_81_1, arg_81_2)
	end,
	DeleteSharedGroup = function (arg_82_0, arg_82_1, arg_82_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/DeleteSharedGroup", arg_82_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_82_1, arg_82_2)
	end,
	GetSharedGroupData = function (arg_83_0, arg_83_1, arg_83_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetSharedGroupData", arg_83_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_83_1, arg_83_2)
	end,
	RemoveSharedGroupMembers = function (arg_84_0, arg_84_1, arg_84_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RemoveSharedGroupMembers", arg_84_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_84_1, arg_84_2)
	end,
	UpdateSharedGroupData = function (arg_85_0, arg_85_1, arg_85_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateSharedGroupData", arg_85_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_85_1, arg_85_2)
	end,
	ExecuteCloudScript = function (arg_86_0, arg_86_1, arg_86_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/ExecuteCloudScript", arg_86_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_86_1, arg_86_2)
	end,
	GetContentDownloadUrl = function (arg_87_0, arg_87_1, arg_87_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetContentDownloadUrl", arg_87_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_87_1, arg_87_2)
	end,
	DeleteCharacterFromUser = function (arg_88_0, arg_88_1, arg_88_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/DeleteCharacterFromUser", arg_88_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_88_1, arg_88_2)
	end,
	GetAllUsersCharacters = function (arg_89_0, arg_89_1, arg_89_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetAllUsersCharacters", arg_89_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_89_1, arg_89_2)
	end,
	GetCharacterLeaderboard = function (arg_90_0, arg_90_1, arg_90_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetCharacterLeaderboard", arg_90_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_90_1, arg_90_2)
	end,
	GetCharacterStatistics = function (arg_91_0, arg_91_1, arg_91_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetCharacterStatistics", arg_91_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_91_1, arg_91_2)
	end,
	GetLeaderboardAroundCharacter = function (arg_92_0, arg_92_1, arg_92_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetLeaderboardAroundCharacter", arg_92_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_92_1, arg_92_2)
	end,
	GetLeaderboardForUserCharacters = function (arg_93_0, arg_93_1, arg_93_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetLeaderboardForUserCharacters", arg_93_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_93_1, arg_93_2)
	end,
	GrantCharacterToUser = function (arg_94_0, arg_94_1, arg_94_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GrantCharacterToUser", arg_94_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_94_1, arg_94_2)
	end,
	UpdateCharacterStatistics = function (arg_95_0, arg_95_1, arg_95_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateCharacterStatistics", arg_95_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_95_1, arg_95_2)
	end,
	GetCharacterData = function (arg_96_0, arg_96_1, arg_96_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetCharacterData", arg_96_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_96_1, arg_96_2)
	end,
	GetCharacterInternalData = function (arg_97_0, arg_97_1, arg_97_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetCharacterInternalData", arg_97_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_97_1, arg_97_2)
	end,
	GetCharacterReadOnlyData = function (arg_98_0, arg_98_1, arg_98_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetCharacterReadOnlyData", arg_98_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_98_1, arg_98_2)
	end,
	UpdateCharacterData = function (arg_99_0, arg_99_1, arg_99_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateCharacterData", arg_99_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_99_1, arg_99_2)
	end,
	UpdateCharacterInternalData = function (arg_100_0, arg_100_1, arg_100_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateCharacterInternalData", arg_100_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_100_1, arg_100_2)
	end,
	UpdateCharacterReadOnlyData = function (arg_101_0, arg_101_1, arg_101_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/UpdateCharacterReadOnlyData", arg_101_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_101_1, arg_101_2)
	end,
	AddPlayerTag = function (arg_102_0, arg_102_1, arg_102_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/AddPlayerTag", arg_102_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_102_1, arg_102_2)
	end,
	GetAllActionGroups = function (arg_103_0, arg_103_1, arg_103_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetAllActionGroups", arg_103_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_103_1, arg_103_2)
	end,
	GetAllSegments = function (arg_104_0, arg_104_1, arg_104_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetAllSegments", arg_104_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_104_1, arg_104_2)
	end,
	GetPlayerSegments = function (arg_105_0, arg_105_1, arg_105_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayerSegments", arg_105_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_105_1, arg_105_2)
	end,
	GetPlayersInSegment = function (arg_106_0, arg_106_1, arg_106_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayersInSegment", arg_106_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_106_1, arg_106_2)
	end,
	GetPlayerTags = function (arg_107_0, arg_107_1, arg_107_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/GetPlayerTags", arg_107_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_107_1, arg_107_2)
	end,
	RemovePlayerTag = function (arg_108_0, arg_108_1, arg_108_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/RemovePlayerTag", arg_108_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_108_1, arg_108_2)
	end,
	AwardSteamAchievement = function (arg_109_0, arg_109_1, arg_109_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Server/AwardSteamAchievement", arg_109_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_109_1, arg_109_2)
	end
}
