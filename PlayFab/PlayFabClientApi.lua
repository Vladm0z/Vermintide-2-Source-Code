-- chunkname: @PlayFab/PlayFabClientApi.lua

local IPlayFabHttps = require("PlayFab.IPlayFabHttps")
local PlayFabSettings = require("PlayFab.PlayFabSettings")
local tbl = {
	settings = PlayFabSettings.settings,
	IsClientLoggedIn = function ()
		-- function 1
		return PlayFabSettings._internalSettings.sessionTicket ~= nil
	end
}

tbl._MultiStepClientLogin = function (arg_2_0)
	-- function 2
	if not arg_2_0 and (PlayFabSettings.settings.disableAdvertising or not PlayFabSettings.settings.advertisingIdType) and not PlayFabSettings.settings.advertisingIdValue then
		local tbl_2 = {}

		if PlayFabSettings.settings.advertisingIdType == PlayFabSettings.settings.AD_TYPE_IDFA then
			tbl_2.Idfa = PlayFabSettings.settings.advertisingIdValue
		elseif PlayFabSettings.settings.advertisingIdType == PlayFabSettings.settings.AD_TYPE_ANDROID_ID then
			tbl_2.Adid = PlayFabSettings.settings.advertisingIdValue
		else
			return
		end

		tbl.AttributeInstall(tbl_2, nil, nil)
	end
end

tbl.GetPhotonAuthenticationToken = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPhotonAuthenticationToken", arg_3_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_3_1, arg_3_2)
end

tbl.GetTitlePublicKey = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	IPlayFabHttps.MakePlayFabApiCall("/Client/GetTitlePublicKey", arg_4_0, nil, nil, arg_4_1, arg_4_2)
end

tbl.GetWindowsHelloChallenge = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	IPlayFabHttps.MakePlayFabApiCall("/Client/GetWindowsHelloChallenge", arg_5_0, nil, nil, arg_5_1, arg_5_2)
end

tbl.LoginWithAndroidDeviceID = function (self, arg_6_1, arg_6_2)
	-- function 6
	self.TitleId = PlayFabSettings.settings.titleId

	local var_6_0 = arg_6_1

	function arg_6_1(self)
		-- function 7
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_6_0 then
			var_6_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithAndroidDeviceID", self, nil, nil, arg_6_1, arg_6_2)
end

tbl.LoginWithCustomID = function (self, arg_8_1, arg_8_2)
	-- function 8
	self.TitleId = PlayFabSettings.settings.titleId

	local var_8_0 = arg_8_1

	function arg_8_1(self)
		-- function 9
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_8_0 then
			var_8_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithCustomID", self, nil, nil, arg_8_1, arg_8_2)
end

tbl.LoginWithEmailAddress = function (self, arg_10_1, arg_10_2)
	-- function 10
	self.TitleId = PlayFabSettings.settings.titleId

	local var_10_0 = arg_10_1

	function arg_10_1(self)
		-- function 11
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_10_0 then
			var_10_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithEmailAddress", self, nil, nil, arg_10_1, arg_10_2)
end

tbl.LoginWithFacebook = function (self, arg_12_1, arg_12_2)
	-- function 12
	self.TitleId = PlayFabSettings.settings.titleId

	local var_12_0 = arg_12_1

	function arg_12_1(self)
		-- function 13
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_12_0 then
			var_12_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithFacebook", self, nil, nil, arg_12_1, arg_12_2)
end

tbl.LoginWithGameCenter = function (self, arg_14_1, arg_14_2)
	-- function 14
	self.TitleId = PlayFabSettings.settings.titleId

	local var_14_0 = arg_14_1

	function arg_14_1(self)
		-- function 15
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_14_0 then
			var_14_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithGameCenter", self, nil, nil, arg_14_1, arg_14_2)
end

tbl.LoginWithGoogleAccount = function (self, arg_16_1, arg_16_2)
	-- function 16
	self.TitleId = PlayFabSettings.settings.titleId

	local var_16_0 = arg_16_1

	function arg_16_1(self)
		-- function 17
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_16_0 then
			var_16_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithGoogleAccount", self, nil, nil, arg_16_1, arg_16_2)
end

tbl.LoginWithIOSDeviceID = function (self, arg_18_1, arg_18_2)
	-- function 18
	self.TitleId = PlayFabSettings.settings.titleId

	local var_18_0 = arg_18_1

	function arg_18_1(self)
		-- function 19
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_18_0 then
			var_18_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithIOSDeviceID", self, nil, nil, arg_18_1, arg_18_2)
end

tbl.LoginWithKongregate = function (self, arg_20_1, arg_20_2)
	-- function 20
	self.TitleId = PlayFabSettings.settings.titleId

	local var_20_0 = arg_20_1

	function arg_20_1(self)
		-- function 21
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_20_0 then
			var_20_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithKongregate", self, nil, nil, arg_20_1, arg_20_2)
end

tbl.LoginWithPlayFab = function (self, arg_22_1, arg_22_2)
	-- function 22
	self.TitleId = PlayFabSettings.settings.titleId

	local var_22_0 = arg_22_1

	function arg_22_1(self)
		-- function 23
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_22_0 then
			var_22_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithPlayFab", self, nil, nil, arg_22_1, arg_22_2)
end

tbl.LoginWithSteam = function (self, arg_24_1, arg_24_2)
	-- function 24
	self.TitleId = PlayFabSettings.settings.titleId

	local var_24_0 = arg_24_1

	function arg_24_1(self)
		-- function 25
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_24_0 then
			var_24_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithSteam", self, nil, nil, arg_24_1, arg_24_2)
end

tbl.LoginWithXbox = function (self, arg_26_1, arg_26_2)
	-- function 26
	self.TitleId = PlayFabSettings.settings.titleId

	local var_26_0 = arg_26_1

	function arg_26_1(self)
		-- function 27
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_26_0 then
			var_26_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithXbox", self, nil, nil, arg_26_1, arg_26_2)
end

tbl.LoginWithPSN = function (self, arg_28_1, arg_28_2)
	-- function 28
	self.TitleId = PlayFabSettings.settings.titleId

	local var_28_0 = arg_28_1

	function arg_28_1(self)
		-- function 29
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_28_0 then
			var_28_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithPSN", self, nil, nil, arg_28_1, arg_28_2)
end

tbl.LoginWithTwitch = function (self, arg_30_1, arg_30_2)
	-- function 30
	self.TitleId = PlayFabSettings.settings.titleId

	local var_30_0 = arg_30_1

	function arg_30_1(self)
		-- function 31
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_30_0 then
			var_30_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithTwitch", self, nil, nil, arg_30_1, arg_30_2)
end

tbl.LoginWithWindowsHello = function (self, arg_32_1, arg_32_2)
	-- function 32
	self.TitleId = PlayFabSettings.settings.titleId

	local var_32_0 = arg_32_1

	function arg_32_1(self)
		-- function 33
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_32_0 then
			var_32_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LoginWithWindowsHello", self, nil, nil, arg_32_1, arg_32_2)
end

tbl.RegisterPlayFabUser = function (self, arg_34_1, arg_34_2)
	-- function 34
	self.TitleId = PlayFabSettings.settings.titleId

	local var_34_0 = arg_34_1

	function arg_34_1(self)
		-- function 35
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_34_0 then
			var_34_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/RegisterPlayFabUser", self, nil, nil, arg_34_1, arg_34_2)
end

tbl.RegisterWithWindowsHello = function (self, arg_36_1, arg_36_2)
	-- function 36
	self.TitleId = PlayFabSettings.settings.titleId

	local var_36_0 = arg_36_1

	function arg_36_1(self)
		-- function 37
		PlayFabSettings._internalSettings.sessionTicket = self.SessionTicket

		if not var_36_0 then
			var_36_0(self)
		end

		tbl._MultiStepClientLogin(self.SettingsForUser.NeedsAttribution)
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/RegisterWithWindowsHello", self, nil, nil, arg_36_1, arg_36_2)
end

tbl.SetPlayerSecret = function (arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/SetPlayerSecret", arg_38_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_38_1, arg_38_2)
end

tbl.AddGenericID = function (arg_39_0, arg_39_1, arg_39_2)
	-- function 39
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/AddGenericID", arg_39_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_39_1, arg_39_2)
end

tbl.AddUsernamePassword = function (arg_40_0, arg_40_1, arg_40_2)
	-- function 40
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/AddUsernamePassword", arg_40_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_40_1, arg_40_2)
end

tbl.GetAccountInfo = function (arg_41_0, arg_41_1, arg_41_2)
	-- function 41
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetAccountInfo", arg_41_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_41_1, arg_41_2)
end

tbl.GetPlayerCombinedInfo = function (arg_42_0, arg_42_1, arg_42_2)
	-- function 42
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayerCombinedInfo", arg_42_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_42_1, arg_42_2)
end

tbl.GetPlayerProfile = function (arg_43_0, arg_43_1, arg_43_2)
	-- function 43
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayerProfile", arg_43_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_43_1, arg_43_2)
end

tbl.GetPlayFabIDsFromFacebookIDs = function (arg_44_0, arg_44_1, arg_44_2)
	-- function 44
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayFabIDsFromFacebookIDs", arg_44_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_44_1, arg_44_2)
end

tbl.GetPlayFabIDsFromGameCenterIDs = function (arg_45_0, arg_45_1, arg_45_2)
	-- function 45
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayFabIDsFromGameCenterIDs", arg_45_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_45_1, arg_45_2)
end

tbl.GetPlayFabIDsFromGenericIDs = function (arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayFabIDsFromGenericIDs", arg_46_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_46_1, arg_46_2)
end

tbl.GetPlayFabIDsFromGoogleIDs = function (arg_47_0, arg_47_1, arg_47_2)
	-- function 47
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayFabIDsFromGoogleIDs", arg_47_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_47_1, arg_47_2)
end

tbl.GetPlayFabIDsFromKongregateIDs = function (arg_48_0, arg_48_1, arg_48_2)
	-- function 48
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayFabIDsFromKongregateIDs", arg_48_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_48_1, arg_48_2)
end

tbl.GetPlayFabIDsFromSteamIDs = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayFabIDsFromSteamIDs", arg_49_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_49_1, arg_49_2)
end

tbl.GetPlayFabIDsFromTwitchIDs = function (arg_50_0, arg_50_1, arg_50_2)
	-- function 50
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayFabIDsFromTwitchIDs", arg_50_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_50_1, arg_50_2)
end

tbl.LinkAndroidDeviceID = function (arg_51_0, arg_51_1, arg_51_2)
	-- function 51
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkAndroidDeviceID", arg_51_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_51_1, arg_51_2)
end

tbl.LinkCustomID = function (arg_52_0, arg_52_1, arg_52_2)
	-- function 52
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkCustomID", arg_52_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_52_1, arg_52_2)
end

tbl.LinkFacebookAccount = function (arg_53_0, arg_53_1, arg_53_2)
	-- function 53
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkFacebookAccount", arg_53_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_53_1, arg_53_2)
end

tbl.LinkGameCenterAccount = function (arg_54_0, arg_54_1, arg_54_2)
	-- function 54
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkGameCenterAccount", arg_54_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_54_1, arg_54_2)
end

tbl.LinkGoogleAccount = function (arg_55_0, arg_55_1, arg_55_2)
	-- function 55
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkGoogleAccount", arg_55_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_55_1, arg_55_2)
end

tbl.LinkIOSDeviceID = function (arg_56_0, arg_56_1, arg_56_2)
	-- function 56
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkIOSDeviceID", arg_56_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_56_1, arg_56_2)
end

tbl.LinkKongregate = function (arg_57_0, arg_57_1, arg_57_2)
	-- function 57
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkKongregate", arg_57_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_57_1, arg_57_2)
end

tbl.LinkSteamAccount = function (arg_58_0, arg_58_1, arg_58_2)
	-- function 58
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkSteamAccount", arg_58_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_58_1, arg_58_2)
end

tbl.LinkTwitch = function (arg_59_0, arg_59_1, arg_59_2)
	-- function 59
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkTwitch", arg_59_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_59_1, arg_59_2)
end

tbl.LinkWindowsHello = function (arg_60_0, arg_60_1, arg_60_2)
	-- function 60
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/LinkWindowsHello", arg_60_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_60_1, arg_60_2)
end

tbl.RemoveGenericID = function (arg_61_0, arg_61_1, arg_61_2)
	-- function 61
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/RemoveGenericID", arg_61_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_61_1, arg_61_2)
end

tbl.ReportPlayer = function (arg_62_0, arg_62_1, arg_62_2)
	-- function 62
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/ReportPlayer", arg_62_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_62_1, arg_62_2)
end

tbl.SendAccountRecoveryEmail = function (arg_63_0, arg_63_1, arg_63_2)
	-- function 63
	IPlayFabHttps.MakePlayFabApiCall("/Client/SendAccountRecoveryEmail", arg_63_0, nil, nil, arg_63_1, arg_63_2)
end

tbl.UnlinkAndroidDeviceID = function (arg_64_0, arg_64_1, arg_64_2)
	-- function 64
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkAndroidDeviceID", arg_64_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_64_1, arg_64_2)
end

tbl.UnlinkCustomID = function (arg_65_0, arg_65_1, arg_65_2)
	-- function 65
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkCustomID", arg_65_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_65_1, arg_65_2)
end

tbl.UnlinkFacebookAccount = function (arg_66_0, arg_66_1, arg_66_2)
	-- function 66
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkFacebookAccount", arg_66_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_66_1, arg_66_2)
end

tbl.UnlinkGameCenterAccount = function (arg_67_0, arg_67_1, arg_67_2)
	-- function 67
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkGameCenterAccount", arg_67_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_67_1, arg_67_2)
end

tbl.UnlinkGoogleAccount = function (arg_68_0, arg_68_1, arg_68_2)
	-- function 68
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkGoogleAccount", arg_68_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_68_1, arg_68_2)
end

tbl.UnlinkIOSDeviceID = function (arg_69_0, arg_69_1, arg_69_2)
	-- function 69
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkIOSDeviceID", arg_69_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_69_1, arg_69_2)
end

tbl.UnlinkKongregate = function (arg_70_0, arg_70_1, arg_70_2)
	-- function 70
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkKongregate", arg_70_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_70_1, arg_70_2)
end

tbl.UnlinkSteamAccount = function (arg_71_0, arg_71_1, arg_71_2)
	-- function 71
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkSteamAccount", arg_71_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_71_1, arg_71_2)
end

tbl.UnlinkTwitch = function (arg_72_0, arg_72_1, arg_72_2)
	-- function 72
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkTwitch", arg_72_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_72_1, arg_72_2)
end

tbl.UnlinkWindowsHello = function (arg_73_0, arg_73_1, arg_73_2)
	-- function 73
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlinkWindowsHello", arg_73_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_73_1, arg_73_2)
end

tbl.UpdateAvatarUrl = function (arg_74_0, arg_74_1, arg_74_2)
	-- function 74
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UpdateAvatarUrl", arg_74_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_74_1, arg_74_2)
end

tbl.UpdateUserTitleDisplayName = function (arg_75_0, arg_75_1, arg_75_2)
	-- function 75
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UpdateUserTitleDisplayName", arg_75_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_75_1, arg_75_2)
end

tbl.GetFriendLeaderboard = function (arg_76_0, arg_76_1, arg_76_2)
	-- function 76
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetFriendLeaderboard", arg_76_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_76_1, arg_76_2)
end

tbl.GetFriendLeaderboardAroundPlayer = function (arg_77_0, arg_77_1, arg_77_2)
	-- function 77
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetFriendLeaderboardAroundPlayer", arg_77_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_77_1, arg_77_2)
end

tbl.GetLeaderboard = function (arg_78_0, arg_78_1, arg_78_2)
	-- function 78
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetLeaderboard", arg_78_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_78_1, arg_78_2)
end

tbl.GetLeaderboardAroundPlayer = function (arg_79_0, arg_79_1, arg_79_2)
	-- function 79
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetLeaderboardAroundPlayer", arg_79_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_79_1, arg_79_2)
end

tbl.GetPlayerStatistics = function (arg_80_0, arg_80_1, arg_80_2)
	-- function 80
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayerStatistics", arg_80_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_80_1, arg_80_2)
end

tbl.GetPlayerStatisticVersions = function (arg_81_0, arg_81_1, arg_81_2)
	-- function 81
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayerStatisticVersions", arg_81_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_81_1, arg_81_2)
end

tbl.GetUserData = function (arg_82_0, arg_82_1, arg_82_2)
	-- function 82
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetUserData", arg_82_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_82_1, arg_82_2)
end

tbl.GetUserPublisherData = function (arg_83_0, arg_83_1, arg_83_2)
	-- function 83
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetUserPublisherData", arg_83_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_83_1, arg_83_2)
end

tbl.GetUserPublisherReadOnlyData = function (arg_84_0, arg_84_1, arg_84_2)
	-- function 84
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetUserPublisherReadOnlyData", arg_84_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_84_1, arg_84_2)
end

tbl.GetUserReadOnlyData = function (arg_85_0, arg_85_1, arg_85_2)
	-- function 85
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetUserReadOnlyData", arg_85_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_85_1, arg_85_2)
end

tbl.UpdatePlayerStatistics = function (arg_86_0, arg_86_1, arg_86_2)
	-- function 86
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UpdatePlayerStatistics", arg_86_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_86_1, arg_86_2)
end

tbl.UpdateUserData = function (arg_87_0, arg_87_1, arg_87_2)
	-- function 87
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UpdateUserData", arg_87_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_87_1, arg_87_2)
end

tbl.UpdateUserPublisherData = function (arg_88_0, arg_88_1, arg_88_2)
	-- function 88
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UpdateUserPublisherData", arg_88_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_88_1, arg_88_2)
end

tbl.GetCatalogItems = function (arg_89_0, arg_89_1, arg_89_2)
	-- function 89
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetCatalogItems", arg_89_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_89_1, arg_89_2)
end

tbl.GetPublisherData = function (arg_90_0, arg_90_1, arg_90_2)
	-- function 90
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPublisherData", arg_90_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_90_1, arg_90_2)
end

tbl.GetStoreItems = function (arg_91_0, arg_91_1, arg_91_2)
	-- function 91
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetStoreItems", arg_91_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_91_1, arg_91_2)
end

tbl.GetTime = function (arg_92_0, arg_92_1, arg_92_2)
	-- function 92
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetTime", arg_92_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_92_1, arg_92_2)
end

tbl.GetTitleData = function (arg_93_0, arg_93_1, arg_93_2)
	-- function 93
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetTitleData", arg_93_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_93_1, arg_93_2)
end

tbl.GetTitleNews = function (arg_94_0, arg_94_1, arg_94_2)
	-- function 94
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetTitleNews", arg_94_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_94_1, arg_94_2)
end

tbl.AddUserVirtualCurrency = function (arg_95_0, arg_95_1, arg_95_2)
	-- function 95
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/AddUserVirtualCurrency", arg_95_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_95_1, arg_95_2)
end

tbl.ConfirmPurchase = function (arg_96_0, arg_96_1, arg_96_2)
	-- function 96
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/ConfirmPurchase", arg_96_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_96_1, arg_96_2)
end

tbl.ConsumeItem = function (arg_97_0, arg_97_1, arg_97_2)
	-- function 97
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/ConsumeItem", arg_97_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_97_1, arg_97_2)
end

tbl.GetCharacterInventory = function (arg_98_0, arg_98_1, arg_98_2)
	-- function 98
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetCharacterInventory", arg_98_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_98_1, arg_98_2)
end

tbl.GetPurchase = function (arg_99_0, arg_99_1, arg_99_2)
	-- function 99
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPurchase", arg_99_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_99_1, arg_99_2)
end

tbl.GetUserInventory = function (arg_100_0, arg_100_1, arg_100_2)
	-- function 100
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetUserInventory", arg_100_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_100_1, arg_100_2)
end

tbl.PayForPurchase = function (arg_101_0, arg_101_1, arg_101_2)
	-- function 101
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/PayForPurchase", arg_101_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_101_1, arg_101_2)
end

tbl.PurchaseItem = function (arg_102_0, arg_102_1, arg_102_2)
	-- function 102
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/PurchaseItem", arg_102_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_102_1, arg_102_2)
end

tbl.RedeemCoupon = function (arg_103_0, arg_103_1, arg_103_2)
	-- function 103
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/RedeemCoupon", arg_103_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_103_1, arg_103_2)
end

tbl.StartPurchase = function (arg_104_0, arg_104_1, arg_104_2)
	-- function 104
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/StartPurchase", arg_104_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_104_1, arg_104_2)
end

tbl.SubtractUserVirtualCurrency = function (arg_105_0, arg_105_1, arg_105_2)
	-- function 105
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/SubtractUserVirtualCurrency", arg_105_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_105_1, arg_105_2)
end

tbl.UnlockContainerInstance = function (arg_106_0, arg_106_1, arg_106_2)
	-- function 106
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlockContainerInstance", arg_106_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_106_1, arg_106_2)
end

tbl.UnlockContainerItem = function (arg_107_0, arg_107_1, arg_107_2)
	-- function 107
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UnlockContainerItem", arg_107_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_107_1, arg_107_2)
end

tbl.AddFriend = function (arg_108_0, arg_108_1, arg_108_2)
	-- function 108
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/AddFriend", arg_108_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_108_1, arg_108_2)
end

tbl.GetFriendsList = function (arg_109_0, arg_109_1, arg_109_2)
	-- function 109
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetFriendsList", arg_109_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_109_1, arg_109_2)
end

tbl.RemoveFriend = function (arg_110_0, arg_110_1, arg_110_2)
	-- function 110
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/RemoveFriend", arg_110_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_110_1, arg_110_2)
end

tbl.SetFriendTags = function (arg_111_0, arg_111_1, arg_111_2)
	-- function 111
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/SetFriendTags", arg_111_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_111_1, arg_111_2)
end

tbl.GetCurrentGames = function (arg_112_0, arg_112_1, arg_112_2)
	-- function 112
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetCurrentGames", arg_112_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_112_1, arg_112_2)
end

tbl.GetGameServerRegions = function (arg_113_0, arg_113_1, arg_113_2)
	-- function 113
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetGameServerRegions", arg_113_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_113_1, arg_113_2)
end

tbl.Matchmake = function (arg_114_0, arg_114_1, arg_114_2)
	-- function 114
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/Matchmake", arg_114_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_114_1, arg_114_2)
end

tbl.StartGame = function (arg_115_0, arg_115_1, arg_115_2)
	-- function 115
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/StartGame", arg_115_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_115_1, arg_115_2)
end

tbl.WriteCharacterEvent = function (arg_116_0, arg_116_1, arg_116_2)
	-- function 116
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/WriteCharacterEvent", arg_116_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_116_1, arg_116_2)
end

tbl.WritePlayerEvent = function (arg_117_0, arg_117_1, arg_117_2)
	-- function 117
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/WritePlayerEvent", arg_117_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_117_1, arg_117_2)
end

tbl.WriteTitleEvent = function (arg_118_0, arg_118_1, arg_118_2)
	-- function 118
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/WriteTitleEvent", arg_118_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_118_1, arg_118_2)
end

tbl.AddSharedGroupMembers = function (arg_119_0, arg_119_1, arg_119_2)
	-- function 119
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/AddSharedGroupMembers", arg_119_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_119_1, arg_119_2)
end

tbl.CreateSharedGroup = function (arg_120_0, arg_120_1, arg_120_2)
	-- function 120
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/CreateSharedGroup", arg_120_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_120_1, arg_120_2)
end

tbl.GetSharedGroupData = function (arg_121_0, arg_121_1, arg_121_2)
	-- function 121
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetSharedGroupData", arg_121_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_121_1, arg_121_2)
end

tbl.RemoveSharedGroupMembers = function (arg_122_0, arg_122_1, arg_122_2)
	-- function 122
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/RemoveSharedGroupMembers", arg_122_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_122_1, arg_122_2)
end

tbl.UpdateSharedGroupData = function (arg_123_0, arg_123_1, arg_123_2)
	-- function 123
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UpdateSharedGroupData", arg_123_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_123_1, arg_123_2)
end

tbl.ExecuteCloudScript = function (arg_124_0, arg_124_1, arg_124_2)
	-- function 124
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/ExecuteCloudScript", arg_124_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_124_1, arg_124_2)
end

tbl.GetContentDownloadUrl = function (arg_125_0, arg_125_1, arg_125_2)
	-- function 125
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetContentDownloadUrl", arg_125_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_125_1, arg_125_2)
end

tbl.GetAllUsersCharacters = function (arg_126_0, arg_126_1, arg_126_2)
	-- function 126
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetAllUsersCharacters", arg_126_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_126_1, arg_126_2)
end

tbl.GetCharacterLeaderboard = function (arg_127_0, arg_127_1, arg_127_2)
	-- function 127
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetCharacterLeaderboard", arg_127_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_127_1, arg_127_2)
end

tbl.GetCharacterStatistics = function (arg_128_0, arg_128_1, arg_128_2)
	-- function 128
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetCharacterStatistics", arg_128_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_128_1, arg_128_2)
end

tbl.GetLeaderboardAroundCharacter = function (arg_129_0, arg_129_1, arg_129_2)
	-- function 129
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetLeaderboardAroundCharacter", arg_129_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_129_1, arg_129_2)
end

tbl.GetLeaderboardForUserCharacters = function (arg_130_0, arg_130_1, arg_130_2)
	-- function 130
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetLeaderboardForUserCharacters", arg_130_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_130_1, arg_130_2)
end

tbl.GrantCharacterToUser = function (arg_131_0, arg_131_1, arg_131_2)
	-- function 131
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GrantCharacterToUser", arg_131_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_131_1, arg_131_2)
end

tbl.UpdateCharacterStatistics = function (arg_132_0, arg_132_1, arg_132_2)
	-- function 132
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UpdateCharacterStatistics", arg_132_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_132_1, arg_132_2)
end

tbl.GetCharacterData = function (arg_133_0, arg_133_1, arg_133_2)
	-- function 133
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetCharacterData", arg_133_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_133_1, arg_133_2)
end

tbl.GetCharacterReadOnlyData = function (arg_134_0, arg_134_1, arg_134_2)
	-- function 134
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetCharacterReadOnlyData", arg_134_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_134_1, arg_134_2)
end

tbl.UpdateCharacterData = function (arg_135_0, arg_135_1, arg_135_2)
	-- function 135
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/UpdateCharacterData", arg_135_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_135_1, arg_135_2)
end

tbl.AcceptTrade = function (arg_136_0, arg_136_1, arg_136_2)
	-- function 136
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/AcceptTrade", arg_136_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_136_1, arg_136_2)
end

tbl.CancelTrade = function (arg_137_0, arg_137_1, arg_137_2)
	-- function 137
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/CancelTrade", arg_137_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_137_1, arg_137_2)
end

tbl.GetPlayerTrades = function (arg_138_0, arg_138_1, arg_138_2)
	-- function 138
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayerTrades", arg_138_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_138_1, arg_138_2)
end

tbl.GetTradeStatus = function (arg_139_0, arg_139_1, arg_139_2)
	-- function 139
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetTradeStatus", arg_139_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_139_1, arg_139_2)
end

tbl.OpenTrade = function (arg_140_0, arg_140_1, arg_140_2)
	-- function 140
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/OpenTrade", arg_140_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_140_1, arg_140_2)
end

tbl.AttributeInstall = function (arg_141_0, arg_141_1, arg_141_2)
	-- function 141
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	PlayFabSettings.settings.advertisingIdType = PlayFabSettings.settings.advertisingIdType .. "_Successful"

	IPlayFabHttps.MakePlayFabApiCall("/Client/AttributeInstall", arg_141_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_141_1, arg_141_2)
end

tbl.GetPlayerSegments = function (arg_142_0, arg_142_1, arg_142_2)
	-- function 142
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayerSegments", arg_142_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_142_1, arg_142_2)
end

tbl.GetPlayerTags = function (arg_143_0, arg_143_1, arg_143_2)
	-- function 143
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/GetPlayerTags", arg_143_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_143_1, arg_143_2)
end

tbl.AndroidDevicePushNotificationRegistration = function (arg_144_0, arg_144_1, arg_144_2)
	-- function 144
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/AndroidDevicePushNotificationRegistration", arg_144_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_144_1, arg_144_2)
end

tbl.RegisterForIOSPushNotification = function (arg_145_0, arg_145_1, arg_145_2)
	-- function 145
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/RegisterForIOSPushNotification", arg_145_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_145_1, arg_145_2)
end

tbl.RestoreIOSPurchases = function (arg_146_0, arg_146_1, arg_146_2)
	-- function 146
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/RestoreIOSPurchases", arg_146_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_146_1, arg_146_2)
end

tbl.ValidateAmazonIAPReceipt = function (arg_147_0, arg_147_1, arg_147_2)
	-- function 147
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/ValidateAmazonIAPReceipt", arg_147_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_147_1, arg_147_2)
end

tbl.ValidateGooglePlayPurchase = function (arg_148_0, arg_148_1, arg_148_2)
	-- function 148
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/ValidateGooglePlayPurchase", arg_148_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_148_1, arg_148_2)
end

tbl.ValidateIOSReceipt = function (arg_149_0, arg_149_1, arg_149_2)
	-- function 149
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/ValidateIOSReceipt", arg_149_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_149_1, arg_149_2)
end

tbl.ValidateWindowsStoreReceipt = function (arg_150_0, arg_150_1, arg_150_2)
	-- function 150
	if not tbl.IsClientLoggedIn() then
		error("Must be logged in to call this method")
	end

	IPlayFabHttps.MakePlayFabApiCall("/Client/ValidateWindowsStoreReceipt", arg_150_0, "X-Authorization", PlayFabSettings._internalSettings.sessionTicket, arg_150_1, arg_150_2)
end

return tbl
