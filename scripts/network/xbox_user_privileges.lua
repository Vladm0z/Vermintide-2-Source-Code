-- chunkname: @scripts/network/xbox_user_privileges.lua

require("scripts/network/script_xbox_user_privilege_token")

XboxUserPrivileges = class(XboxUserPrivileges)

local DEFAULT_PRIVILEGES = DEFAULT_PRIVILEGES

DEFAULT_PRIVILEGES = DEFAULT_PRIVILEGES or {}
DEFAULT_PRIVILEGES = DEFAULT_PRIVILEGES

local ATTEMPT_RESOLUTION_PRIVILEGES = ATTEMPT_RESOLUTION_PRIVILEGES

ATTEMPT_RESOLUTION_PRIVILEGES = ATTEMPT_RESOLUTION_PRIVILEGES or {}
ATTEMPT_RESOLUTION_PRIVILEGES = ATTEMPT_RESOLUTION_PRIVILEGES

local XBOX_PRIVILEGE_LUT = XBOX_PRIVILEGE_LUT

XBOX_PRIVILEGE_LUT = XBOX_PRIVILEGE_LUT or {}
XBOX_PRIVILEGE_LUT = XBOX_PRIVILEGE_LUT

local PRIVILEGES_ERROR_CODES = PRIVILEGES_ERROR_CODES

PRIVILEGES_ERROR_CODES = PRIVILEGES_ERROR_CODES or {}
PRIVILEGES_ERROR_CODES = PRIVILEGES_ERROR_CODES

XboxUserPrivileges.init = function (self)
	-- function 1
	self:reset()
	self:_setup_lookup_tables()
end

XboxUserPrivileges.reset = function (self)
	-- function 2
	self._current_users = {}
	self._initialized = false
	self._has_error = nil
	self._check_privilege_cb = {}
end

XboxUserPrivileges.add_user = function (self, arg_3_1)
	-- function 3
	self:reset()

	self._current_users[arg_3_1] = {}

	for k, v in pairs(DEFAULT_PRIVILEGES) do
		local flag = false

		if not ATTEMPT_RESOLUTION_PRIVILEGES[v] then
			print(XBOX_PRIVILEGE_LUT[v] .. " using attempt_resolution=true")

			flag = true
		end

		local has = UserPrivilege.has(arg_3_1, flag, v)

		if not has then
			local var_3_2 = ScriptXboxUserPrivilegeToken:new(has)

			Managers.token:register_token(var_3_2, callback(self, "cb_user_privilege_done", arg_3_1, v, nil))
		else
			self._has_error = true
		end
	end
end

XboxUserPrivileges.get_privilege_async = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not self._current_users[arg_4_1] then
		fassert(false, "ERROR ERROR")

		return
	end

	local has = UserPrivilege.has(arg_4_1, arg_4_3, arg_4_2)

	if not has then
		local var_4_1 = ScriptXboxUserPrivilegeToken:new(has)

		Managers.token:register_token(var_4_1, callback(self, "cb_user_privilege_done", arg_4_1, arg_4_2, arg_4_4))
	else
		self._has_error = true
	end
end

XboxUserPrivileges.update_privilege = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0

	for k, v in pairs(XBOX_PRIVILEGE_LUT) do
		if v == arg_5_1 then
			var_5_0 = k

			break
		end
	end

	if not var_5_0 then
		Application.error(string.format("[XboxUserPrivileges] Couldn't find privilege called %s", arg_5_1))
	else
		local user_id = Managers.account:user_id()
		local has = UserPrivilege.has(user_id, false, var_5_0)

		if not has then
			local var_5_3 = ScriptXboxUserPrivilegeToken:new(has)

			Managers.token:register_token(var_5_3, callback(self, "cb_user_privilege_done", user_id, var_5_0, nil))

			if not arg_5_2 then
				local _check_privilege_cb = self._check_privilege_cb

				_check_privilege_cb = _check_privilege_cb or {}
				self._check_privilege_cb = _check_privilege_cb

				local _check_privilege_cb_2 = self._check_privilege_cb
				local var_5_6 = self._check_privilege_cb[var_5_0]

				var_5_6 = var_5_6 or {}
				_check_privilege_cb_2[var_5_0] = var_5_6
				self._check_privilege_cb[var_5_0][#self._check_privilege_cb[var_5_0] + 1] = arg_5_2
			end
		else
			self._has_error = true
		end
	end
end

XboxUserPrivileges.cb_user_privilege_done = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not arg_6_4.error then
		local error = Application.error
		local format = string.format
		local str = "[XboxUserPrivileges] Something went wrong when trying to fetch privilege [%s] for User [%s]. Error: %s"
		local var_6_3 = XBOX_PRIVILEGE_LUT[arg_6_2]

		var_6_3 = var_6_3 or "unknown"

		local var_6_4 = tostring(arg_6_1)
		local var_6_5 = PRIVILEGES_ERROR_CODES[arg_6_4.error]

		var_6_5 = var_6_5 or "UNKNOWN"

		error(format(str, var_6_3, var_6_4, var_6_5))

		self._has_error = true
		self._initialized = true
	elseif arg_6_4.status_code == UserPrivilege.NoIssue then
		local warning = Application.warning
		local format_2 = string.format
		local str_2 = "[XboxUserPrivileges] User [%s] has the privilege to [%s]"
		local var_6_9 = tostring(arg_6_1)
		local var_6_10 = XBOX_PRIVILEGE_LUT[arg_6_2]

		var_6_10 = var_6_10 or "unknown"

		local var_6_11 = PRIVILEGES_ERROR_CODES[arg_6_4.status_code]

		var_6_11 = var_6_11 or "UNKNOWN"

		warning(format_2(str_2, var_6_9, var_6_10, var_6_11))

		self._current_users[arg_6_1][arg_6_2] = true
	else
		local error_2 = Application.error
		local format_3 = string.format
		local str_3 = "[XboxUserPrivileges] User [%s] do not have the privilege to [%s]. Error: %s"
		local var_6_15 = tostring(arg_6_1)
		local var_6_16 = XBOX_PRIVILEGE_LUT[arg_6_2]

		var_6_16 = var_6_16 or "unknown"

		local var_6_17 = PRIVILEGES_ERROR_CODES[arg_6_4.status_code]

		var_6_17 = var_6_17 or "UNKNOWN"

		error_2(format_3(str_3, var_6_15, var_6_16, var_6_17))

		self._current_users[arg_6_1][arg_6_2] = false
	end

	if not self._check_privilege_cb and not self._check_privilege_cb[arg_6_2] then
		local var_6_18 = self._check_privilege_cb[arg_6_2]

		for k, v in pairs(var_6_18) do
			v(XBOX_PRIVILEGE_LUT[arg_6_2])
		end

		self._check_privilege_cb[arg_6_2] = nil
	end

	if not arg_6_3 then
		arg_6_3(arg_6_2)
	end
end

XboxUserPrivileges.has_privilege = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not arg_7_1 and not self._current_users[arg_7_1] then
		return self._current_users[arg_7_1][arg_7_2]
	else
		return false
	end
end

XboxUserPrivileges.is_initialized = function (self)
	-- function 8
	if not self._initialized then
		return true
	else
		local user_id = Managers.account:user_id()
		local var_8_1 = self._current_users[user_id]

		if not var_8_1 then
			return false
		end

		for k, v in pairs(DEFAULT_PRIVILEGES) do
			if var_8_1[v] == nil then
				return false
			end
		end

		self._initialized = true

		return true
	end
end

XboxUserPrivileges.has_error = function (self)
	-- function 9
	return self._has_error
end

XboxUserPrivileges._setup_lookup_tables = function (arg_10_0)
	-- function 10
	XBOX_PRIVILEGE_LUT[UserPrivilege.ADD_FRIEND] = "ADD_FRIEND"
	XBOX_PRIVILEGE_LUT[UserPrivilege.BROADCAST] = "BROADCAST"
	XBOX_PRIVILEGE_LUT[UserPrivilege.CLOUD_GAMING_JOIN_SESSION] = "CLOUD_GAMING_JOIN_SESSION"
	XBOX_PRIVILEGE_LUT[UserPrivilege.CLOUD_GAMING_MANAGE_SESSION] = "CLOUD_GAMING_MANAGE_SESSION"
	XBOX_PRIVILEGE_LUT[UserPrivilege.CLOUD_SAVED_GAMES] = "CLOUD_SAVED_GAMES"
	XBOX_PRIVILEGE_LUT[UserPrivilege.COMMUNICATIONS] = "COMMUNICATIONS"
	XBOX_PRIVILEGE_LUT[UserPrivilege.COMMUNICATION_VOICE_INGAME] = "COMMUNICATION_VOICE_INGAME"
	XBOX_PRIVILEGE_LUT[UserPrivilege.COMMUNICATION_VOICE_SKYPE] = "COMMUNICATION_VOICE_SKYPE"
	XBOX_PRIVILEGE_LUT[UserPrivilege.GAME_DVR] = "GAME_DVR"
	XBOX_PRIVILEGE_LUT[UserPrivilege.MULTIPLAYER_PARTIES] = "MULTIPLAYER_PARTIES"
	XBOX_PRIVILEGE_LUT[UserPrivilege.MULTIPLAYER_SESSIONS] = "MULTIPLAYER_SESSIONS"
	XBOX_PRIVILEGE_LUT[UserPrivilege.PREMIUM_CONTENT] = "PREMIUM_CONTENT"
	XBOX_PRIVILEGE_LUT[UserPrivilege.PREMIUM_VIDEO] = "PREMIUM_VIDEO"
	XBOX_PRIVILEGE_LUT[UserPrivilege.PROFILE_VIEWING] = "PROFILE_VIEWING"
	XBOX_PRIVILEGE_LUT[UserPrivilege.PURCHASE_CONTENT] = "PURCHASE_CONTENT"
	XBOX_PRIVILEGE_LUT[UserPrivilege.SHARE_CONTENT] = "SHARE_CONTENT"
	XBOX_PRIVILEGE_LUT[UserPrivilege.SHARE_KINECT_CONTENT] = "SHARE_KINECT_CONTENT"
	XBOX_PRIVILEGE_LUT[UserPrivilege.SOCIAL_NETWORK_SHARING] = "SOCIAL_NETWORK_SHARING"
	XBOX_PRIVILEGE_LUT[UserPrivilege.SUBSCRIPTION_CONTENT] = "SUBSCRIPTION_CONTENT"
	XBOX_PRIVILEGE_LUT[UserPrivilege.USER_CREATED_CONTENT] = "USER_CREATED_CONTENT"
	XBOX_PRIVILEGE_LUT[UserPrivilege.VIDEO_COMMUNICATIONS] = "VIDEO_COMMUNICATIONS"
	XBOX_PRIVILEGE_LUT[UserPrivilege.VIEW_FRIENDS_LIST] = "VIEW_FRIENDS_LIST"
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.ADD_FRIEND
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.BROADCAST
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.CLOUD_GAMING_JOIN_SESSION
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.CLOUD_GAMING_MANAGE_SESSION
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.CLOUD_SAVED_GAMES
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.COMMUNICATIONS
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.COMMUNICATION_VOICE_INGAME
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.COMMUNICATION_VOICE_SKYPE
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.GAME_DVR
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.MULTIPLAYER_PARTIES
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.PREMIUM_CONTENT
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.PREMIUM_VIDEO
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.PROFILE_VIEWING
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.PURCHASE_CONTENT
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.SHARE_CONTENT
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.SHARE_KINECT_CONTENT
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.SOCIAL_NETWORK_SHARING
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.SUBSCRIPTION_CONTENT
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.USER_CREATED_CONTENT
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.VIDEO_COMMUNICATIONS
	DEFAULT_PRIVILEGES[#DEFAULT_PRIVILEGES + 1] = UserPrivilege.VIEW_FRIENDS_LIST
	PRIVILEGES_ERROR_CODES[UserPrivilege.Aborted] = "ABORTED"
	PRIVILEGES_ERROR_CODES[UserPrivilege.Banned] = "BANNED"
	PRIVILEGES_ERROR_CODES[UserPrivilege.NoIssue] = "NO_ISSUE"
	PRIVILEGES_ERROR_CODES[UserPrivilege.PurchaseRequired] = "PURCHASE_REQUIRED"
	PRIVILEGES_ERROR_CODES[UserPrivilege.Restricted] = "RESTRICTED"
	ATTEMPT_RESOLUTION_PRIVILEGES[UserPrivilege.MULTIPLAYER_SESSIONS] = true
end
