-- chunkname: @PlayFab/PlayFabClientApi.lua

local var_0_0 = require("PlayFab.IPlayFabHttps")
local var_0_1 = require("PlayFab.PlayFabSettings")
local var_0_2 = {
	settings = var_0_1.settings,
	IsClientLoggedIn = function ()
		return var_0_1._internalSettings.sessionTicket ~= nil
	end
}

var_0_2._MultiStepClientLogin = function (arg_2_0)
	if arg_2_0 and not var_0_1.settings.disableAdvertising and var_0_1.settings.advertisingIdType and var_0_1.settings.advertisingIdValue then
		local var_2_0 = {}

		if var_0_1.settings.advertisingIdType == var_0_1.settings.AD_TYPE_IDFA then
			var_2_0.Idfa = var_0_1.settings.advertisingIdValue
		elseif var_0_1.settings.advertisingIdType == var_0_1.settings.AD_TYPE_ANDROID_ID then
			var_2_0.Adid = var_0_1.settings.advertisingIdValue
		else
			return
		end

		var_0_2.AttributeInstall(var_2_0, nil, nil)
	end
end

var_0_2.GetPhotonAuthenticationToken = function (arg_3_0, arg_3_1, arg_3_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPhotonAuthenticationToken", arg_3_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_3_1, arg_3_2)
end

var_0_2.GetTitlePublicKey = function (arg_4_0, arg_4_1, arg_4_2)
	var_0_0.MakePlayFabApiCall("/Client/GetTitlePublicKey", arg_4_0, nil, nil, arg_4_1, arg_4_2)
end

var_0_2.GetWindowsHelloChallenge = function (arg_5_0, arg_5_1, arg_5_2)
	var_0_0.MakePlayFabApiCall("/Client/GetWindowsHelloChallenge", arg_5_0, nil, nil, arg_5_1, arg_5_2)
end

var_0_2.LoginWithAndroidDeviceID = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.TitleId = var_0_1.settings.titleId

	local var_6_0 = arg_6_1

	function arg_6_1(arg_7_0)
		var_0_1._internalSettings.sessionTicket = arg_7_0.SessionTicket

		if var_6_0 then
			var_6_0(arg_7_0)
		end

		var_0_2._MultiStepClientLogin(arg_7_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithAndroidDeviceID", arg_6_0, nil, nil, arg_6_1, arg_6_2)
end

var_0_2.LoginWithCustomID = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.TitleId = var_0_1.settings.titleId

	local var_8_0 = arg_8_1

	function arg_8_1(arg_9_0)
		var_0_1._internalSettings.sessionTicket = arg_9_0.SessionTicket

		if var_8_0 then
			var_8_0(arg_9_0)
		end

		var_0_2._MultiStepClientLogin(arg_9_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithCustomID", arg_8_0, nil, nil, arg_8_1, arg_8_2)
end

var_0_2.LoginWithEmailAddress = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.TitleId = var_0_1.settings.titleId

	local var_10_0 = arg_10_1

	function arg_10_1(arg_11_0)
		var_0_1._internalSettings.sessionTicket = arg_11_0.SessionTicket

		if var_10_0 then
			var_10_0(arg_11_0)
		end

		var_0_2._MultiStepClientLogin(arg_11_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithEmailAddress", arg_10_0, nil, nil, arg_10_1, arg_10_2)
end

var_0_2.LoginWithFacebook = function (arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.TitleId = var_0_1.settings.titleId

	local var_12_0 = arg_12_1

	function arg_12_1(arg_13_0)
		var_0_1._internalSettings.sessionTicket = arg_13_0.SessionTicket

		if var_12_0 then
			var_12_0(arg_13_0)
		end

		var_0_2._MultiStepClientLogin(arg_13_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithFacebook", arg_12_0, nil, nil, arg_12_1, arg_12_2)
end

var_0_2.LoginWithGameCenter = function (arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.TitleId = var_0_1.settings.titleId

	local var_14_0 = arg_14_1

	function arg_14_1(arg_15_0)
		var_0_1._internalSettings.sessionTicket = arg_15_0.SessionTicket

		if var_14_0 then
			var_14_0(arg_15_0)
		end

		var_0_2._MultiStepClientLogin(arg_15_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithGameCenter", arg_14_0, nil, nil, arg_14_1, arg_14_2)
end

var_0_2.LoginWithGoogleAccount = function (arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.TitleId = var_0_1.settings.titleId

	local var_16_0 = arg_16_1

	function arg_16_1(arg_17_0)
		var_0_1._internalSettings.sessionTicket = arg_17_0.SessionTicket

		if var_16_0 then
			var_16_0(arg_17_0)
		end

		var_0_2._MultiStepClientLogin(arg_17_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithGoogleAccount", arg_16_0, nil, nil, arg_16_1, arg_16_2)
end

var_0_2.LoginWithIOSDeviceID = function (arg_18_0, arg_18_1, arg_18_2)
	arg_18_0.TitleId = var_0_1.settings.titleId

	local var_18_0 = arg_18_1

	function arg_18_1(arg_19_0)
		var_0_1._internalSettings.sessionTicket = arg_19_0.SessionTicket

		if var_18_0 then
			var_18_0(arg_19_0)
		end

		var_0_2._MultiStepClientLogin(arg_19_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithIOSDeviceID", arg_18_0, nil, nil, arg_18_1, arg_18_2)
end

var_0_2.LoginWithKongregate = function (arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.TitleId = var_0_1.settings.titleId

	local var_20_0 = arg_20_1

	function arg_20_1(arg_21_0)
		var_0_1._internalSettings.sessionTicket = arg_21_0.SessionTicket

		if var_20_0 then
			var_20_0(arg_21_0)
		end

		var_0_2._MultiStepClientLogin(arg_21_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithKongregate", arg_20_0, nil, nil, arg_20_1, arg_20_2)
end

var_0_2.LoginWithPlayFab = function (arg_22_0, arg_22_1, arg_22_2)
	arg_22_0.TitleId = var_0_1.settings.titleId

	local var_22_0 = arg_22_1

	function arg_22_1(arg_23_0)
		var_0_1._internalSettings.sessionTicket = arg_23_0.SessionTicket

		if var_22_0 then
			var_22_0(arg_23_0)
		end

		var_0_2._MultiStepClientLogin(arg_23_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithPlayFab", arg_22_0, nil, nil, arg_22_1, arg_22_2)
end

var_0_2.LoginWithSteam = function (arg_24_0, arg_24_1, arg_24_2)
	arg_24_0.TitleId = var_0_1.settings.titleId

	local var_24_0 = arg_24_1

	function arg_24_1(arg_25_0)
		var_0_1._internalSettings.sessionTicket = arg_25_0.SessionTicket

		if var_24_0 then
			var_24_0(arg_25_0)
		end

		var_0_2._MultiStepClientLogin(arg_25_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithSteam", arg_24_0, nil, nil, arg_24_1, arg_24_2)
end

var_0_2.LoginWithXbox = function (arg_26_0, arg_26_1, arg_26_2)
	arg_26_0.TitleId = var_0_1.settings.titleId

	local var_26_0 = arg_26_1

	function arg_26_1(arg_27_0)
		var_0_1._internalSettings.sessionTicket = arg_27_0.SessionTicket

		if var_26_0 then
			var_26_0(arg_27_0)
		end

		var_0_2._MultiStepClientLogin(arg_27_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithXbox", arg_26_0, nil, nil, arg_26_1, arg_26_2)
end

var_0_2.LoginWithPSN = function (arg_28_0, arg_28_1, arg_28_2)
	arg_28_0.TitleId = var_0_1.settings.titleId

	local var_28_0 = arg_28_1

	function arg_28_1(arg_29_0)
		var_0_1._internalSettings.sessionTicket = arg_29_0.SessionTicket

		if var_28_0 then
			var_28_0(arg_29_0)
		end

		var_0_2._MultiStepClientLogin(arg_29_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithPSN", arg_28_0, nil, nil, arg_28_1, arg_28_2)
end

var_0_2.LoginWithTwitch = function (arg_30_0, arg_30_1, arg_30_2)
	arg_30_0.TitleId = var_0_1.settings.titleId

	local var_30_0 = arg_30_1

	function arg_30_1(arg_31_0)
		var_0_1._internalSettings.sessionTicket = arg_31_0.SessionTicket

		if var_30_0 then
			var_30_0(arg_31_0)
		end

		var_0_2._MultiStepClientLogin(arg_31_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithTwitch", arg_30_0, nil, nil, arg_30_1, arg_30_2)
end

var_0_2.LoginWithWindowsHello = function (arg_32_0, arg_32_1, arg_32_2)
	arg_32_0.TitleId = var_0_1.settings.titleId

	local var_32_0 = arg_32_1

	function arg_32_1(arg_33_0)
		var_0_1._internalSettings.sessionTicket = arg_33_0.SessionTicket

		if var_32_0 then
			var_32_0(arg_33_0)
		end

		var_0_2._MultiStepClientLogin(arg_33_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/LoginWithWindowsHello", arg_32_0, nil, nil, arg_32_1, arg_32_2)
end

var_0_2.RegisterPlayFabUser = function (arg_34_0, arg_34_1, arg_34_2)
	arg_34_0.TitleId = var_0_1.settings.titleId

	local var_34_0 = arg_34_1

	function arg_34_1(arg_35_0)
		var_0_1._internalSettings.sessionTicket = arg_35_0.SessionTicket

		if var_34_0 then
			var_34_0(arg_35_0)
		end

		var_0_2._MultiStepClientLogin(arg_35_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/RegisterPlayFabUser", arg_34_0, nil, nil, arg_34_1, arg_34_2)
end

var_0_2.RegisterWithWindowsHello = function (arg_36_0, arg_36_1, arg_36_2)
	arg_36_0.TitleId = var_0_1.settings.titleId

	local var_36_0 = arg_36_1

	function arg_36_1(arg_37_0)
		var_0_1._internalSettings.sessionTicket = arg_37_0.SessionTicket

		if var_36_0 then
			var_36_0(arg_37_0)
		end

		var_0_2._MultiStepClientLogin(arg_37_0.SettingsForUser.NeedsAttribution)
	end

	var_0_0.MakePlayFabApiCall("/Client/RegisterWithWindowsHello", arg_36_0, nil, nil, arg_36_1, arg_36_2)
end

var_0_2.SetPlayerSecret = function (arg_38_0, arg_38_1, arg_38_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/SetPlayerSecret", arg_38_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_38_1, arg_38_2)
end

var_0_2.AddGenericID = function (arg_39_0, arg_39_1, arg_39_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/AddGenericID", arg_39_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_39_1, arg_39_2)
end

var_0_2.AddUsernamePassword = function (arg_40_0, arg_40_1, arg_40_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/AddUsernamePassword", arg_40_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_40_1, arg_40_2)
end

var_0_2.GetAccountInfo = function (arg_41_0, arg_41_1, arg_41_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetAccountInfo", arg_41_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_41_1, arg_41_2)
end

var_0_2.GetPlayerCombinedInfo = function (arg_42_0, arg_42_1, arg_42_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayerCombinedInfo", arg_42_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_42_1, arg_42_2)
end

var_0_2.GetPlayerProfile = function (arg_43_0, arg_43_1, arg_43_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayerProfile", arg_43_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_43_1, arg_43_2)
end

var_0_2.GetPlayFabIDsFromFacebookIDs = function (arg_44_0, arg_44_1, arg_44_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayFabIDsFromFacebookIDs", arg_44_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_44_1, arg_44_2)
end

var_0_2.GetPlayFabIDsFromGameCenterIDs = function (arg_45_0, arg_45_1, arg_45_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayFabIDsFromGameCenterIDs", arg_45_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_45_1, arg_45_2)
end

var_0_2.GetPlayFabIDsFromGenericIDs = function (arg_46_0, arg_46_1, arg_46_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayFabIDsFromGenericIDs", arg_46_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_46_1, arg_46_2)
end

var_0_2.GetPlayFabIDsFromGoogleIDs = function (arg_47_0, arg_47_1, arg_47_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayFabIDsFromGoogleIDs", arg_47_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_47_1, arg_47_2)
end

var_0_2.GetPlayFabIDsFromKongregateIDs = function (arg_48_0, arg_48_1, arg_48_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayFabIDsFromKongregateIDs", arg_48_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_48_1, arg_48_2)
end

var_0_2.GetPlayFabIDsFromSteamIDs = function (arg_49_0, arg_49_1, arg_49_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayFabIDsFromSteamIDs", arg_49_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_49_1, arg_49_2)
end

var_0_2.GetPlayFabIDsFromTwitchIDs = function (arg_50_0, arg_50_1, arg_50_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayFabIDsFromTwitchIDs", arg_50_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_50_1, arg_50_2)
end

var_0_2.LinkAndroidDeviceID = function (arg_51_0, arg_51_1, arg_51_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkAndroidDeviceID", arg_51_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_51_1, arg_51_2)
end

var_0_2.LinkCustomID = function (arg_52_0, arg_52_1, arg_52_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkCustomID", arg_52_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_52_1, arg_52_2)
end

var_0_2.LinkFacebookAccount = function (arg_53_0, arg_53_1, arg_53_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkFacebookAccount", arg_53_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_53_1, arg_53_2)
end

var_0_2.LinkGameCenterAccount = function (arg_54_0, arg_54_1, arg_54_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkGameCenterAccount", arg_54_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_54_1, arg_54_2)
end

var_0_2.LinkGoogleAccount = function (arg_55_0, arg_55_1, arg_55_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkGoogleAccount", arg_55_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_55_1, arg_55_2)
end

var_0_2.LinkIOSDeviceID = function (arg_56_0, arg_56_1, arg_56_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkIOSDeviceID", arg_56_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_56_1, arg_56_2)
end

var_0_2.LinkKongregate = function (arg_57_0, arg_57_1, arg_57_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkKongregate", arg_57_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_57_1, arg_57_2)
end

var_0_2.LinkSteamAccount = function (arg_58_0, arg_58_1, arg_58_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkSteamAccount", arg_58_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_58_1, arg_58_2)
end

var_0_2.LinkTwitch = function (arg_59_0, arg_59_1, arg_59_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkTwitch", arg_59_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_59_1, arg_59_2)
end

var_0_2.LinkWindowsHello = function (arg_60_0, arg_60_1, arg_60_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/LinkWindowsHello", arg_60_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_60_1, arg_60_2)
end

var_0_2.RemoveGenericID = function (arg_61_0, arg_61_1, arg_61_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/RemoveGenericID", arg_61_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_61_1, arg_61_2)
end

var_0_2.ReportPlayer = function (arg_62_0, arg_62_1, arg_62_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/ReportPlayer", arg_62_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_62_1, arg_62_2)
end

var_0_2.SendAccountRecoveryEmail = function (arg_63_0, arg_63_1, arg_63_2)
	var_0_0.MakePlayFabApiCall("/Client/SendAccountRecoveryEmail", arg_63_0, nil, nil, arg_63_1, arg_63_2)
end

var_0_2.UnlinkAndroidDeviceID = function (arg_64_0, arg_64_1, arg_64_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkAndroidDeviceID", arg_64_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_64_1, arg_64_2)
end

var_0_2.UnlinkCustomID = function (arg_65_0, arg_65_1, arg_65_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkCustomID", arg_65_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_65_1, arg_65_2)
end

var_0_2.UnlinkFacebookAccount = function (arg_66_0, arg_66_1, arg_66_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkFacebookAccount", arg_66_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_66_1, arg_66_2)
end

var_0_2.UnlinkGameCenterAccount = function (arg_67_0, arg_67_1, arg_67_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkGameCenterAccount", arg_67_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_67_1, arg_67_2)
end

var_0_2.UnlinkGoogleAccount = function (arg_68_0, arg_68_1, arg_68_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkGoogleAccount", arg_68_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_68_1, arg_68_2)
end

var_0_2.UnlinkIOSDeviceID = function (arg_69_0, arg_69_1, arg_69_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkIOSDeviceID", arg_69_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_69_1, arg_69_2)
end

var_0_2.UnlinkKongregate = function (arg_70_0, arg_70_1, arg_70_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkKongregate", arg_70_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_70_1, arg_70_2)
end

var_0_2.UnlinkSteamAccount = function (arg_71_0, arg_71_1, arg_71_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkSteamAccount", arg_71_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_71_1, arg_71_2)
end

var_0_2.UnlinkTwitch = function (arg_72_0, arg_72_1, arg_72_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkTwitch", arg_72_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_72_1, arg_72_2)
end

var_0_2.UnlinkWindowsHello = function (arg_73_0, arg_73_1, arg_73_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlinkWindowsHello", arg_73_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_73_1, arg_73_2)
end

var_0_2.UpdateAvatarUrl = function (arg_74_0, arg_74_1, arg_74_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UpdateAvatarUrl", arg_74_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_74_1, arg_74_2)
end

var_0_2.UpdateUserTitleDisplayName = function (arg_75_0, arg_75_1, arg_75_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UpdateUserTitleDisplayName", arg_75_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_75_1, arg_75_2)
end

var_0_2.GetFriendLeaderboard = function (arg_76_0, arg_76_1, arg_76_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetFriendLeaderboard", arg_76_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_76_1, arg_76_2)
end

var_0_2.GetFriendLeaderboardAroundPlayer = function (arg_77_0, arg_77_1, arg_77_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetFriendLeaderboardAroundPlayer", arg_77_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_77_1, arg_77_2)
end

var_0_2.GetLeaderboard = function (arg_78_0, arg_78_1, arg_78_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetLeaderboard", arg_78_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_78_1, arg_78_2)
end

var_0_2.GetLeaderboardAroundPlayer = function (arg_79_0, arg_79_1, arg_79_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetLeaderboardAroundPlayer", arg_79_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_79_1, arg_79_2)
end

var_0_2.GetPlayerStatistics = function (arg_80_0, arg_80_1, arg_80_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayerStatistics", arg_80_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_80_1, arg_80_2)
end

var_0_2.GetPlayerStatisticVersions = function (arg_81_0, arg_81_1, arg_81_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayerStatisticVersions", arg_81_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_81_1, arg_81_2)
end

var_0_2.GetUserData = function (arg_82_0, arg_82_1, arg_82_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetUserData", arg_82_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_82_1, arg_82_2)
end

var_0_2.GetUserPublisherData = function (arg_83_0, arg_83_1, arg_83_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetUserPublisherData", arg_83_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_83_1, arg_83_2)
end

var_0_2.GetUserPublisherReadOnlyData = function (arg_84_0, arg_84_1, arg_84_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetUserPublisherReadOnlyData", arg_84_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_84_1, arg_84_2)
end

var_0_2.GetUserReadOnlyData = function (arg_85_0, arg_85_1, arg_85_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetUserReadOnlyData", arg_85_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_85_1, arg_85_2)
end

var_0_2.UpdatePlayerStatistics = function (arg_86_0, arg_86_1, arg_86_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UpdatePlayerStatistics", arg_86_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_86_1, arg_86_2)
end

var_0_2.UpdateUserData = function (arg_87_0, arg_87_1, arg_87_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UpdateUserData", arg_87_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_87_1, arg_87_2)
end

var_0_2.UpdateUserPublisherData = function (arg_88_0, arg_88_1, arg_88_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UpdateUserPublisherData", arg_88_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_88_1, arg_88_2)
end

var_0_2.GetCatalogItems = function (arg_89_0, arg_89_1, arg_89_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetCatalogItems", arg_89_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_89_1, arg_89_2)
end

var_0_2.GetPublisherData = function (arg_90_0, arg_90_1, arg_90_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPublisherData", arg_90_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_90_1, arg_90_2)
end

var_0_2.GetStoreItems = function (arg_91_0, arg_91_1, arg_91_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetStoreItems", arg_91_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_91_1, arg_91_2)
end

var_0_2.GetTime = function (arg_92_0, arg_92_1, arg_92_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetTime", arg_92_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_92_1, arg_92_2)
end

var_0_2.GetTitleData = function (arg_93_0, arg_93_1, arg_93_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetTitleData", arg_93_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_93_1, arg_93_2)
end

var_0_2.GetTitleNews = function (arg_94_0, arg_94_1, arg_94_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetTitleNews", arg_94_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_94_1, arg_94_2)
end

var_0_2.AddUserVirtualCurrency = function (arg_95_0, arg_95_1, arg_95_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/AddUserVirtualCurrency", arg_95_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_95_1, arg_95_2)
end

var_0_2.ConfirmPurchase = function (arg_96_0, arg_96_1, arg_96_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/ConfirmPurchase", arg_96_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_96_1, arg_96_2)
end

var_0_2.ConsumeItem = function (arg_97_0, arg_97_1, arg_97_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/ConsumeItem", arg_97_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_97_1, arg_97_2)
end

var_0_2.GetCharacterInventory = function (arg_98_0, arg_98_1, arg_98_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetCharacterInventory", arg_98_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_98_1, arg_98_2)
end

var_0_2.GetPurchase = function (arg_99_0, arg_99_1, arg_99_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPurchase", arg_99_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_99_1, arg_99_2)
end

var_0_2.GetUserInventory = function (arg_100_0, arg_100_1, arg_100_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetUserInventory", arg_100_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_100_1, arg_100_2)
end

var_0_2.PayForPurchase = function (arg_101_0, arg_101_1, arg_101_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/PayForPurchase", arg_101_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_101_1, arg_101_2)
end

var_0_2.PurchaseItem = function (arg_102_0, arg_102_1, arg_102_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/PurchaseItem", arg_102_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_102_1, arg_102_2)
end

var_0_2.RedeemCoupon = function (arg_103_0, arg_103_1, arg_103_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/RedeemCoupon", arg_103_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_103_1, arg_103_2)
end

var_0_2.StartPurchase = function (arg_104_0, arg_104_1, arg_104_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/StartPurchase", arg_104_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_104_1, arg_104_2)
end

var_0_2.SubtractUserVirtualCurrency = function (arg_105_0, arg_105_1, arg_105_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/SubtractUserVirtualCurrency", arg_105_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_105_1, arg_105_2)
end

var_0_2.UnlockContainerInstance = function (arg_106_0, arg_106_1, arg_106_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlockContainerInstance", arg_106_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_106_1, arg_106_2)
end

var_0_2.UnlockContainerItem = function (arg_107_0, arg_107_1, arg_107_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UnlockContainerItem", arg_107_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_107_1, arg_107_2)
end

var_0_2.AddFriend = function (arg_108_0, arg_108_1, arg_108_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/AddFriend", arg_108_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_108_1, arg_108_2)
end

var_0_2.GetFriendsList = function (arg_109_0, arg_109_1, arg_109_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetFriendsList", arg_109_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_109_1, arg_109_2)
end

var_0_2.RemoveFriend = function (arg_110_0, arg_110_1, arg_110_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/RemoveFriend", arg_110_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_110_1, arg_110_2)
end

var_0_2.SetFriendTags = function (arg_111_0, arg_111_1, arg_111_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/SetFriendTags", arg_111_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_111_1, arg_111_2)
end

var_0_2.GetCurrentGames = function (arg_112_0, arg_112_1, arg_112_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetCurrentGames", arg_112_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_112_1, arg_112_2)
end

var_0_2.GetGameServerRegions = function (arg_113_0, arg_113_1, arg_113_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetGameServerRegions", arg_113_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_113_1, arg_113_2)
end

var_0_2.Matchmake = function (arg_114_0, arg_114_1, arg_114_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/Matchmake", arg_114_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_114_1, arg_114_2)
end

var_0_2.StartGame = function (arg_115_0, arg_115_1, arg_115_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/StartGame", arg_115_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_115_1, arg_115_2)
end

var_0_2.WriteCharacterEvent = function (arg_116_0, arg_116_1, arg_116_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/WriteCharacterEvent", arg_116_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_116_1, arg_116_2)
end

var_0_2.WritePlayerEvent = function (arg_117_0, arg_117_1, arg_117_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/WritePlayerEvent", arg_117_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_117_1, arg_117_2)
end

var_0_2.WriteTitleEvent = function (arg_118_0, arg_118_1, arg_118_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/WriteTitleEvent", arg_118_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_118_1, arg_118_2)
end

var_0_2.AddSharedGroupMembers = function (arg_119_0, arg_119_1, arg_119_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/AddSharedGroupMembers", arg_119_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_119_1, arg_119_2)
end

var_0_2.CreateSharedGroup = function (arg_120_0, arg_120_1, arg_120_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/CreateSharedGroup", arg_120_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_120_1, arg_120_2)
end

var_0_2.GetSharedGroupData = function (arg_121_0, arg_121_1, arg_121_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetSharedGroupData", arg_121_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_121_1, arg_121_2)
end

var_0_2.RemoveSharedGroupMembers = function (arg_122_0, arg_122_1, arg_122_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/RemoveSharedGroupMembers", arg_122_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_122_1, arg_122_2)
end

var_0_2.UpdateSharedGroupData = function (arg_123_0, arg_123_1, arg_123_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UpdateSharedGroupData", arg_123_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_123_1, arg_123_2)
end

var_0_2.ExecuteCloudScript = function (arg_124_0, arg_124_1, arg_124_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/ExecuteCloudScript", arg_124_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_124_1, arg_124_2)
end

var_0_2.GetContentDownloadUrl = function (arg_125_0, arg_125_1, arg_125_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetContentDownloadUrl", arg_125_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_125_1, arg_125_2)
end

var_0_2.GetAllUsersCharacters = function (arg_126_0, arg_126_1, arg_126_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetAllUsersCharacters", arg_126_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_126_1, arg_126_2)
end

var_0_2.GetCharacterLeaderboard = function (arg_127_0, arg_127_1, arg_127_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetCharacterLeaderboard", arg_127_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_127_1, arg_127_2)
end

var_0_2.GetCharacterStatistics = function (arg_128_0, arg_128_1, arg_128_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetCharacterStatistics", arg_128_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_128_1, arg_128_2)
end

var_0_2.GetLeaderboardAroundCharacter = function (arg_129_0, arg_129_1, arg_129_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetLeaderboardAroundCharacter", arg_129_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_129_1, arg_129_2)
end

var_0_2.GetLeaderboardForUserCharacters = function (arg_130_0, arg_130_1, arg_130_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetLeaderboardForUserCharacters", arg_130_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_130_1, arg_130_2)
end

var_0_2.GrantCharacterToUser = function (arg_131_0, arg_131_1, arg_131_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GrantCharacterToUser", arg_131_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_131_1, arg_131_2)
end

var_0_2.UpdateCharacterStatistics = function (arg_132_0, arg_132_1, arg_132_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UpdateCharacterStatistics", arg_132_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_132_1, arg_132_2)
end

var_0_2.GetCharacterData = function (arg_133_0, arg_133_1, arg_133_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetCharacterData", arg_133_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_133_1, arg_133_2)
end

var_0_2.GetCharacterReadOnlyData = function (arg_134_0, arg_134_1, arg_134_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetCharacterReadOnlyData", arg_134_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_134_1, arg_134_2)
end

var_0_2.UpdateCharacterData = function (arg_135_0, arg_135_1, arg_135_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/UpdateCharacterData", arg_135_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_135_1, arg_135_2)
end

var_0_2.AcceptTrade = function (arg_136_0, arg_136_1, arg_136_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/AcceptTrade", arg_136_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_136_1, arg_136_2)
end

var_0_2.CancelTrade = function (arg_137_0, arg_137_1, arg_137_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/CancelTrade", arg_137_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_137_1, arg_137_2)
end

var_0_2.GetPlayerTrades = function (arg_138_0, arg_138_1, arg_138_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayerTrades", arg_138_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_138_1, arg_138_2)
end

var_0_2.GetTradeStatus = function (arg_139_0, arg_139_1, arg_139_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetTradeStatus", arg_139_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_139_1, arg_139_2)
end

var_0_2.OpenTrade = function (arg_140_0, arg_140_1, arg_140_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/OpenTrade", arg_140_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_140_1, arg_140_2)
end

var_0_2.AttributeInstall = function (arg_141_0, arg_141_1, arg_141_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_1.settings.advertisingIdType = var_0_1.settings.advertisingIdType .. "_Successful"

	var_0_0.MakePlayFabApiCall("/Client/AttributeInstall", arg_141_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_141_1, arg_141_2)
end

var_0_2.GetPlayerSegments = function (arg_142_0, arg_142_1, arg_142_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayerSegments", arg_142_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_142_1, arg_142_2)
end

var_0_2.GetPlayerTags = function (arg_143_0, arg_143_1, arg_143_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/GetPlayerTags", arg_143_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_143_1, arg_143_2)
end

var_0_2.AndroidDevicePushNotificationRegistration = function (arg_144_0, arg_144_1, arg_144_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/AndroidDevicePushNotificationRegistration", arg_144_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_144_1, arg_144_2)
end

var_0_2.RegisterForIOSPushNotification = function (arg_145_0, arg_145_1, arg_145_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/RegisterForIOSPushNotification", arg_145_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_145_1, arg_145_2)
end

var_0_2.RestoreIOSPurchases = function (arg_146_0, arg_146_1, arg_146_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/RestoreIOSPurchases", arg_146_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_146_1, arg_146_2)
end

var_0_2.ValidateAmazonIAPReceipt = function (arg_147_0, arg_147_1, arg_147_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/ValidateAmazonIAPReceipt", arg_147_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_147_1, arg_147_2)
end

var_0_2.ValidateGooglePlayPurchase = function (arg_148_0, arg_148_1, arg_148_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/ValidateGooglePlayPurchase", arg_148_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_148_1, arg_148_2)
end

var_0_2.ValidateIOSReceipt = function (arg_149_0, arg_149_1, arg_149_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/ValidateIOSReceipt", arg_149_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_149_1, arg_149_2)
end

var_0_2.ValidateWindowsStoreReceipt = function (arg_150_0, arg_150_1, arg_150_2)
	if not var_0_2.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	var_0_0.MakePlayFabApiCall("/Client/ValidateWindowsStoreReceipt", arg_150_0, "X-Authorization", var_0_1._internalSettings.sessionTicket, arg_150_1, arg_150_2)
end

return var_0_2
