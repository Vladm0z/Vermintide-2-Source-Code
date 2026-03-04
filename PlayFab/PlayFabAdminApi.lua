-- chunkname: @PlayFab/PlayFabAdminApi.lua

local var_0_0 = require("PlayFab.IPlayFabHttps")
local var_0_1 = require("PlayFab.PlayFabSettings")

return {
	settings = var_0_1.settings,
	CreatePlayerSharedSecret = function (arg_1_0, arg_1_1, arg_1_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/CreatePlayerSharedSecret", arg_1_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_1_1, arg_1_2)
	end,
	DeletePlayerSharedSecret = function (arg_2_0, arg_2_1, arg_2_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/DeletePlayerSharedSecret", arg_2_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_2_1, arg_2_2)
	end,
	GetPlayerSharedSecrets = function (arg_3_0, arg_3_1, arg_3_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetPlayerSharedSecrets", arg_3_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_3_1, arg_3_2)
	end,
	GetPolicy = function (arg_4_0, arg_4_1, arg_4_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetPolicy", arg_4_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_4_1, arg_4_2)
	end,
	SetPlayerSecret = function (arg_5_0, arg_5_1, arg_5_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SetPlayerSecret", arg_5_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_5_1, arg_5_2)
	end,
	UpdatePlayerSharedSecret = function (arg_6_0, arg_6_1, arg_6_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdatePlayerSharedSecret", arg_6_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_6_1, arg_6_2)
	end,
	UpdatePolicy = function (arg_7_0, arg_7_1, arg_7_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdatePolicy", arg_7_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_7_1, arg_7_2)
	end,
	BanUsers = function (arg_8_0, arg_8_1, arg_8_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/BanUsers", arg_8_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_8_1, arg_8_2)
	end,
	DeletePlayer = function (arg_9_0, arg_9_1, arg_9_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/DeletePlayer", arg_9_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_9_1, arg_9_2)
	end,
	GetUserAccountInfo = function (arg_10_0, arg_10_1, arg_10_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserAccountInfo", arg_10_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_10_1, arg_10_2)
	end,
	GetUserBans = function (arg_11_0, arg_11_1, arg_11_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserBans", arg_11_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_11_1, arg_11_2)
	end,
	ResetUsers = function (arg_12_0, arg_12_1, arg_12_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/ResetUsers", arg_12_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_12_1, arg_12_2)
	end,
	RevokeAllBansForUser = function (arg_13_0, arg_13_1, arg_13_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/RevokeAllBansForUser", arg_13_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_13_1, arg_13_2)
	end,
	RevokeBans = function (arg_14_0, arg_14_1, arg_14_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/RevokeBans", arg_14_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_14_1, arg_14_2)
	end,
	SendAccountRecoveryEmail = function (arg_15_0, arg_15_1, arg_15_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SendAccountRecoveryEmail", arg_15_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_15_1, arg_15_2)
	end,
	UpdateBans = function (arg_16_0, arg_16_1, arg_16_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateBans", arg_16_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_16_1, arg_16_2)
	end,
	UpdateUserTitleDisplayName = function (arg_17_0, arg_17_1, arg_17_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateUserTitleDisplayName", arg_17_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_17_1, arg_17_2)
	end,
	CreatePlayerStatisticDefinition = function (arg_18_0, arg_18_1, arg_18_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/CreatePlayerStatisticDefinition", arg_18_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_18_1, arg_18_2)
	end,
	DeleteUsers = function (arg_19_0, arg_19_1, arg_19_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/DeleteUsers", arg_19_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_19_1, arg_19_2)
	end,
	GetDataReport = function (arg_20_0, arg_20_1, arg_20_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetDataReport", arg_20_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_20_1, arg_20_2)
	end,
	GetPlayerStatisticDefinitions = function (arg_21_0, arg_21_1, arg_21_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetPlayerStatisticDefinitions", arg_21_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_21_1, arg_21_2)
	end,
	GetPlayerStatisticVersions = function (arg_22_0, arg_22_1, arg_22_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetPlayerStatisticVersions", arg_22_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_22_1, arg_22_2)
	end,
	GetUserData = function (arg_23_0, arg_23_1, arg_23_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserData", arg_23_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_23_1, arg_23_2)
	end,
	GetUserInternalData = function (arg_24_0, arg_24_1, arg_24_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserInternalData", arg_24_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_24_1, arg_24_2)
	end,
	GetUserPublisherData = function (arg_25_0, arg_25_1, arg_25_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserPublisherData", arg_25_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_25_1, arg_25_2)
	end,
	GetUserPublisherInternalData = function (arg_26_0, arg_26_1, arg_26_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserPublisherInternalData", arg_26_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_26_1, arg_26_2)
	end,
	GetUserPublisherReadOnlyData = function (arg_27_0, arg_27_1, arg_27_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserPublisherReadOnlyData", arg_27_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_27_1, arg_27_2)
	end,
	GetUserReadOnlyData = function (arg_28_0, arg_28_1, arg_28_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserReadOnlyData", arg_28_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_28_1, arg_28_2)
	end,
	IncrementPlayerStatisticVersion = function (arg_29_0, arg_29_1, arg_29_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/IncrementPlayerStatisticVersion", arg_29_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_29_1, arg_29_2)
	end,
	RefundPurchase = function (arg_30_0, arg_30_1, arg_30_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/RefundPurchase", arg_30_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_30_1, arg_30_2)
	end,
	ResetUserStatistics = function (arg_31_0, arg_31_1, arg_31_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/ResetUserStatistics", arg_31_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_31_1, arg_31_2)
	end,
	ResolvePurchaseDispute = function (arg_32_0, arg_32_1, arg_32_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/ResolvePurchaseDispute", arg_32_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_32_1, arg_32_2)
	end,
	UpdatePlayerStatisticDefinition = function (arg_33_0, arg_33_1, arg_33_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdatePlayerStatisticDefinition", arg_33_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_33_1, arg_33_2)
	end,
	UpdateUserData = function (arg_34_0, arg_34_1, arg_34_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateUserData", arg_34_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_34_1, arg_34_2)
	end,
	UpdateUserInternalData = function (arg_35_0, arg_35_1, arg_35_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateUserInternalData", arg_35_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_35_1, arg_35_2)
	end,
	UpdateUserPublisherData = function (arg_36_0, arg_36_1, arg_36_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateUserPublisherData", arg_36_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_36_1, arg_36_2)
	end,
	UpdateUserPublisherInternalData = function (arg_37_0, arg_37_1, arg_37_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateUserPublisherInternalData", arg_37_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_37_1, arg_37_2)
	end,
	UpdateUserPublisherReadOnlyData = function (arg_38_0, arg_38_1, arg_38_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateUserPublisherReadOnlyData", arg_38_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_38_1, arg_38_2)
	end,
	UpdateUserReadOnlyData = function (arg_39_0, arg_39_1, arg_39_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateUserReadOnlyData", arg_39_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_39_1, arg_39_2)
	end,
	AddNews = function (arg_40_0, arg_40_1, arg_40_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/AddNews", arg_40_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_40_1, arg_40_2)
	end,
	AddVirtualCurrencyTypes = function (arg_41_0, arg_41_1, arg_41_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/AddVirtualCurrencyTypes", arg_41_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_41_1, arg_41_2)
	end,
	DeleteStore = function (arg_42_0, arg_42_1, arg_42_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/DeleteStore", arg_42_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_42_1, arg_42_2)
	end,
	GetCatalogItems = function (arg_43_0, arg_43_1, arg_43_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetCatalogItems", arg_43_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_43_1, arg_43_2)
	end,
	GetPublisherData = function (arg_44_0, arg_44_1, arg_44_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetPublisherData", arg_44_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_44_1, arg_44_2)
	end,
	GetRandomResultTables = function (arg_45_0, arg_45_1, arg_45_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetRandomResultTables", arg_45_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_45_1, arg_45_2)
	end,
	GetStoreItems = function (arg_46_0, arg_46_1, arg_46_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetStoreItems", arg_46_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_46_1, arg_46_2)
	end,
	GetTitleData = function (arg_47_0, arg_47_1, arg_47_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetTitleData", arg_47_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_47_1, arg_47_2)
	end,
	GetTitleInternalData = function (arg_48_0, arg_48_1, arg_48_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetTitleInternalData", arg_48_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_48_1, arg_48_2)
	end,
	ListVirtualCurrencyTypes = function (arg_49_0, arg_49_1, arg_49_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/ListVirtualCurrencyTypes", arg_49_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_49_1, arg_49_2)
	end,
	RemoveVirtualCurrencyTypes = function (arg_50_0, arg_50_1, arg_50_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/RemoveVirtualCurrencyTypes", arg_50_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_50_1, arg_50_2)
	end,
	SetCatalogItems = function (arg_51_0, arg_51_1, arg_51_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SetCatalogItems", arg_51_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_51_1, arg_51_2)
	end,
	SetStoreItems = function (arg_52_0, arg_52_1, arg_52_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SetStoreItems", arg_52_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_52_1, arg_52_2)
	end,
	SetTitleData = function (arg_53_0, arg_53_1, arg_53_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SetTitleData", arg_53_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_53_1, arg_53_2)
	end,
	SetTitleInternalData = function (arg_54_0, arg_54_1, arg_54_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SetTitleInternalData", arg_54_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_54_1, arg_54_2)
	end,
	SetupPushNotification = function (arg_55_0, arg_55_1, arg_55_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SetupPushNotification", arg_55_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_55_1, arg_55_2)
	end,
	UpdateCatalogItems = function (arg_56_0, arg_56_1, arg_56_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateCatalogItems", arg_56_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_56_1, arg_56_2)
	end,
	UpdateRandomResultTables = function (arg_57_0, arg_57_1, arg_57_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateRandomResultTables", arg_57_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_57_1, arg_57_2)
	end,
	UpdateStoreItems = function (arg_58_0, arg_58_1, arg_58_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateStoreItems", arg_58_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_58_1, arg_58_2)
	end,
	AddUserVirtualCurrency = function (arg_59_0, arg_59_1, arg_59_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/AddUserVirtualCurrency", arg_59_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_59_1, arg_59_2)
	end,
	GetUserInventory = function (arg_60_0, arg_60_1, arg_60_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetUserInventory", arg_60_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_60_1, arg_60_2)
	end,
	GrantItemsToUsers = function (arg_61_0, arg_61_1, arg_61_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GrantItemsToUsers", arg_61_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_61_1, arg_61_2)
	end,
	RevokeInventoryItem = function (arg_62_0, arg_62_1, arg_62_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/RevokeInventoryItem", arg_62_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_62_1, arg_62_2)
	end,
	SubtractUserVirtualCurrency = function (arg_63_0, arg_63_1, arg_63_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SubtractUserVirtualCurrency", arg_63_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_63_1, arg_63_2)
	end,
	GetMatchmakerGameInfo = function (arg_64_0, arg_64_1, arg_64_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetMatchmakerGameInfo", arg_64_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_64_1, arg_64_2)
	end,
	GetMatchmakerGameModes = function (arg_65_0, arg_65_1, arg_65_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetMatchmakerGameModes", arg_65_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_65_1, arg_65_2)
	end,
	ModifyMatchmakerGameModes = function (arg_66_0, arg_66_1, arg_66_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/ModifyMatchmakerGameModes", arg_66_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_66_1, arg_66_2)
	end,
	AddServerBuild = function (arg_67_0, arg_67_1, arg_67_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/AddServerBuild", arg_67_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_67_1, arg_67_2)
	end,
	GetServerBuildInfo = function (arg_68_0, arg_68_1, arg_68_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetServerBuildInfo", arg_68_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_68_1, arg_68_2)
	end,
	GetServerBuildUploadUrl = function (arg_69_0, arg_69_1, arg_69_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetServerBuildUploadUrl", arg_69_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_69_1, arg_69_2)
	end,
	ListServerBuilds = function (arg_70_0, arg_70_1, arg_70_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/ListServerBuilds", arg_70_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_70_1, arg_70_2)
	end,
	ModifyServerBuild = function (arg_71_0, arg_71_1, arg_71_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/ModifyServerBuild", arg_71_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_71_1, arg_71_2)
	end,
	RemoveServerBuild = function (arg_72_0, arg_72_1, arg_72_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/RemoveServerBuild", arg_72_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_72_1, arg_72_2)
	end,
	SetPublisherData = function (arg_73_0, arg_73_1, arg_73_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SetPublisherData", arg_73_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_73_1, arg_73_2)
	end,
	GetCloudScriptRevision = function (arg_74_0, arg_74_1, arg_74_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetCloudScriptRevision", arg_74_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_74_1, arg_74_2)
	end,
	GetCloudScriptVersions = function (arg_75_0, arg_75_1, arg_75_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetCloudScriptVersions", arg_75_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_75_1, arg_75_2)
	end,
	SetPublishedRevision = function (arg_76_0, arg_76_1, arg_76_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/SetPublishedRevision", arg_76_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_76_1, arg_76_2)
	end,
	UpdateCloudScript = function (arg_77_0, arg_77_1, arg_77_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateCloudScript", arg_77_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_77_1, arg_77_2)
	end,
	DeleteContent = function (arg_78_0, arg_78_1, arg_78_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/DeleteContent", arg_78_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_78_1, arg_78_2)
	end,
	GetContentList = function (arg_79_0, arg_79_1, arg_79_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetContentList", arg_79_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_79_1, arg_79_2)
	end,
	GetContentUploadUrl = function (arg_80_0, arg_80_1, arg_80_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetContentUploadUrl", arg_80_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_80_1, arg_80_2)
	end,
	ResetCharacterStatistics = function (arg_81_0, arg_81_1, arg_81_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/ResetCharacterStatistics", arg_81_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_81_1, arg_81_2)
	end,
	AddPlayerTag = function (arg_82_0, arg_82_1, arg_82_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/AddPlayerTag", arg_82_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_82_1, arg_82_2)
	end,
	GetAllActionGroups = function (arg_83_0, arg_83_1, arg_83_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetAllActionGroups", arg_83_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_83_1, arg_83_2)
	end,
	GetAllSegments = function (arg_84_0, arg_84_1, arg_84_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetAllSegments", arg_84_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_84_1, arg_84_2)
	end,
	GetPlayerSegments = function (arg_85_0, arg_85_1, arg_85_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetPlayerSegments", arg_85_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_85_1, arg_85_2)
	end,
	GetPlayersInSegment = function (arg_86_0, arg_86_1, arg_86_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetPlayersInSegment", arg_86_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_86_1, arg_86_2)
	end,
	GetPlayerTags = function (arg_87_0, arg_87_1, arg_87_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetPlayerTags", arg_87_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_87_1, arg_87_2)
	end,
	RemovePlayerTag = function (arg_88_0, arg_88_1, arg_88_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/RemovePlayerTag", arg_88_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_88_1, arg_88_2)
	end,
	AbortTaskInstance = function (arg_89_0, arg_89_1, arg_89_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/AbortTaskInstance", arg_89_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_89_1, arg_89_2)
	end,
	CreateActionsOnPlayersInSegmentTask = function (arg_90_0, arg_90_1, arg_90_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/CreateActionsOnPlayersInSegmentTask", arg_90_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_90_1, arg_90_2)
	end,
	CreateCloudScriptTask = function (arg_91_0, arg_91_1, arg_91_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/CreateCloudScriptTask", arg_91_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_91_1, arg_91_2)
	end,
	DeleteTask = function (arg_92_0, arg_92_1, arg_92_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/DeleteTask", arg_92_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_92_1, arg_92_2)
	end,
	GetActionsOnPlayersInSegmentTaskInstance = function (arg_93_0, arg_93_1, arg_93_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetActionsOnPlayersInSegmentTaskInstance", arg_93_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_93_1, arg_93_2)
	end,
	GetCloudScriptTaskInstance = function (arg_94_0, arg_94_1, arg_94_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetCloudScriptTaskInstance", arg_94_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_94_1, arg_94_2)
	end,
	GetTaskInstances = function (arg_95_0, arg_95_1, arg_95_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetTaskInstances", arg_95_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_95_1, arg_95_2)
	end,
	GetTasks = function (arg_96_0, arg_96_1, arg_96_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/GetTasks", arg_96_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_96_1, arg_96_2)
	end,
	RunTask = function (arg_97_0, arg_97_1, arg_97_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/RunTask", arg_97_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_97_1, arg_97_2)
	end,
	UpdateTask = function (arg_98_0, arg_98_1, arg_98_2)
		if not var_0_1.settings.titleId or not var_0_1.settings.devSecretKey then
			error("Must have PlayFabSettings.settings.devSecretKey set to call this method")
		end

		var_0_0.MakePlayFabApiCall("/Admin/UpdateTask", arg_98_0, "X-SecretKey", var_0_1.settings.devSecretKey, arg_98_1, arg_98_2)
	end
}
