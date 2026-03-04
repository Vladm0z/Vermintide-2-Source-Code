-- chunkname: @scripts/network/xbox_user_privileges.lua

require("scripts/network/script_xbox_user_privilege_token")

XboxUserPrivileges = class(XboxUserPrivileges)
DEFAULT_PRIVILEGES = DEFAULT_PRIVILEGES or {}
ATTEMPT_RESOLUTION_PRIVILEGES = ATTEMPT_RESOLUTION_PRIVILEGES or {}
XBOX_PRIVILEGE_LUT = XBOX_PRIVILEGE_LUT or {}
PRIVILEGES_ERROR_CODES = PRIVILEGES_ERROR_CODES or {}

function XboxUserPrivileges.init(arg_1_0)
	arg_1_0:reset()
	arg_1_0:_setup_lookup_tables()
end

function XboxUserPrivileges.reset(arg_2_0)
	arg_2_0._current_users = {}
	arg_2_0._initialized = false
	arg_2_0._has_error = nil
	arg_2_0._check_privilege_cb = {}
end

function XboxUserPrivileges.add_user(arg_3_0, arg_3_1)
	arg_3_0:reset()

	arg_3_0._current_users[arg_3_1] = {}

	for iter_3_0, iter_3_1 in pairs(DEFAULT_PRIVILEGES) do
		local var_3_0 = false

		if ATTEMPT_RESOLUTION_PRIVILEGES[iter_3_1] then
			print(XBOX_PRIVILEGE_LUT[iter_3_1] .. " using attempt_resolution=true")

			var_3_0 = true
		end

		local var_3_1 = UserPrivilege.has(arg_3_1, var_3_0, iter_3_1)

		if var_3_1 then
			local var_3_2 = ScriptXboxUserPrivilegeToken:new(var_3_1)

			Managers.token:register_token(var_3_2, callback(arg_3_0, "cb_user_privilege_done", arg_3_1, iter_3_1, nil))
		else
			arg_3_0._has_error = true
		end
	end
end

function XboxUserPrivileges.get_privilege_async(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not arg_4_0._current_users[arg_4_1] then
		fassert(false, "ERROR ERROR")

		return
	end

	local var_4_0 = UserPrivilege.has(arg_4_1, arg_4_3, arg_4_2)

	if var_4_0 then
		local var_4_1 = ScriptXboxUserPrivilegeToken:new(var_4_0)

		Managers.token:register_token(var_4_1, callback(arg_4_0, "cb_user_privilege_done", arg_4_1, arg_4_2, arg_4_4))
	else
		arg_4_0._has_error = true
	end
end

function XboxUserPrivileges.update_privilege(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0

	for iter_5_0, iter_5_1 in pairs(XBOX_PRIVILEGE_LUT) do
		if iter_5_1 == arg_5_1 then
			var_5_0 = iter_5_0

			break
		end
	end

	if not var_5_0 then
		Application.error(string.format("[XboxUserPrivileges] Couldn't find privilege called %s", arg_5_1))
	else
		local var_5_1 = Managers.account:user_id()
		local var_5_2 = UserPrivilege.has(var_5_1, false, var_5_0)

		if var_5_2 then
			local var_5_3 = ScriptXboxUserPrivilegeToken:new(var_5_2)

			Managers.token:register_token(var_5_3, callback(arg_5_0, "cb_user_privilege_done", var_5_1, var_5_0, nil))

			if arg_5_2 then
				arg_5_0._check_privilege_cb = arg_5_0._check_privilege_cb or {}
				arg_5_0._check_privilege_cb[var_5_0] = arg_5_0._check_privilege_cb[var_5_0] or {}
				arg_5_0._check_privilege_cb[var_5_0][#arg_5_0._check_privilege_cb[var_5_0] + 1] = arg_5_2
			end
		else
			arg_5_0._has_error = true
		end
	end
end

function XboxUserPrivileges.cb_user_privilege_done(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_4.error then
		Application.error(string.format("[XboxUserPrivileges] Something went wrong when trying to fetch privilege [%s] for User [%s]. Error: %s", XBOX_PRIVILEGE_LUT[arg_6_2] or "unknown", tostring(arg_6_1), PRIVILEGES_ERROR_CODES[arg_6_4.error] or "UNKNOWN"))

		arg_6_0._has_error = true
		arg_6_0._initialized = true
	elseif arg_6_4.status_code == UserPrivilege.NoIssue then
		Application.warning(string.format("[XboxUserPrivileges] User [%s] has the privilege to [%s]", tostring(arg_6_1), XBOX_PRIVILEGE_LUT[arg_6_2] or "unknown", PRIVILEGES_ERROR_CODES[arg_6_4.status_code] or "UNKNOWN"))

		arg_6_0._current_users[arg_6_1][arg_6_2] = true
	else
		Application.error(string.format("[XboxUserPrivileges] User [%s] do not have the privilege to [%s]. Error: %s", tostring(arg_6_1), XBOX_PRIVILEGE_LUT[arg_6_2] or "unknown", PRIVILEGES_ERROR_CODES[arg_6_4.status_code] or "UNKNOWN"))

		arg_6_0._current_users[arg_6_1][arg_6_2] = false
	end

	if arg_6_0._check_privilege_cb and arg_6_0._check_privilege_cb[arg_6_2] then
		local var_6_0 = arg_6_0._check_privilege_cb[arg_6_2]

		for iter_6_0, iter_6_1 in pairs(var_6_0) do
			iter_6_1(XBOX_PRIVILEGE_LUT[arg_6_2])
		end

		arg_6_0._check_privilege_cb[arg_6_2] = nil
	end

	if arg_6_3 then
		arg_6_3(arg_6_2)
	end
end

function XboxUserPrivileges.has_privilege(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1 and arg_7_0._current_users[arg_7_1] then
		return arg_7_0._current_users[arg_7_1][arg_7_2]
	else
		return false
	end
end

function XboxUserPrivileges.is_initialized(arg_8_0)
	if arg_8_0._initialized then
		return true
	else
		local var_8_0 = Managers.account:user_id()
		local var_8_1 = arg_8_0._current_users[var_8_0]

		if not var_8_1 then
			return false
		end

		for iter_8_0, iter_8_1 in pairs(DEFAULT_PRIVILEGES) do
			if var_8_1[iter_8_1] == nil then
				return false
			end
		end

		arg_8_0._initialized = true

		return true
	end
end

function XboxUserPrivileges.has_error(arg_9_0)
	return arg_9_0._has_error
end

function XboxUserPrivileges._setup_lookup_tables(arg_10_0)
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
