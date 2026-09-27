-- chunkname: @scripts/network/ps_restrictions.lua

require("scripts/network/script_ps_restriction_token")

PSRestrictions = class(PSRestrictions)

local tbl = {
	"network_availability",
	"playstation_plus",
	"parental_control"
}
local tbl_2 = {
	playstation_plus = "_playstation_plus_start",
	network_availability = "_network_availability_start",
	parental_control = "_parental_control_start"
}
local tbl_3 = {
	playstation_plus = "cb_playstation_plus",
	network_availability = "cb_network_availability",
	parental_control = "cb_parental_control"
}

local function fn(self, ...)
	-- function 1
	if not script_data.debug_ps_restrictions then
		local format = self.format("[PSRestrictions] %s", self)

		printf(format, ...)
	end
end

local function fn_2(self, ...)
	-- function 2
	local format = self.format("[PSRestrictions] %s", self)

	Application.error(self.format(format, ...))
end

local fake_restrictions = script_data.fake_restrictions

PSRestrictions.init = function (self)
	-- function 3
	self._current_users = {}
end

PSRestrictions.add_user = function (self, arg_4_1)
	-- function 4
	self._current_users[arg_4_1] = {
		restrictions = table.clone(tbl)
	}

	self:_start_restriction_access_fetched(arg_4_1)
end

PSRestrictions._start_restriction_access_fetched = function (self, arg_5_1)
	-- function 5
	local var_5_0 = self._current_users[arg_5_1]

	self:_fetch_next_restriction_access(arg_5_1)
end

PSRestrictions._fetch_next_restriction_access = function (self, arg_6_1)
	-- function 6
	if not fake_restrictions then
		return
	end

	local restrictions = self._current_users[arg_6_1].restrictions
	local var_6_1, var_6_2 = next(restrictions)
	local signed_in = PS4.signed_in(arg_6_1)
	local var_6_4 = tbl_2[var_6_2]
	local var_6_5 = tbl_3[var_6_2]

	if not signed_in then
		local var_6_6 = self[var_6_4](self, arg_6_1)
		local var_6_7 = ScriptPSRestrictionToken:new(var_6_6)

		Managers.token:register_token(var_6_7, callback(self, var_6_5, arg_6_1, var_6_2))
	else
		self[var_6_5](self, arg_6_1, var_6_2, {
			error = PS4.SCE_NP_ERROR_SIGNED_OUT
		})
	end
end

PSRestrictions.has_access = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not fake_restrictions then
		return true
	end

	local access = self._current_users[arg_7_1][arg_7_2].access

	fassert(access ~= nil, "Have not fetched access to this restriction (%s)", arg_7_2)

	return access
end

PSRestrictions.has_error = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not fake_restrictions then
		return false
	end

	return self._current_users[arg_8_1][arg_8_2].error
end

PSRestrictions.restriction_access_fetched = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not fake_restrictions then
		return true
	end

	return self._current_users[arg_9_1][arg_9_2]
end

PSRestrictions.refetch_restriction_access = function (self, arg_10_1, arg_10_2)
	-- function 10
	fassert(self._current_users[arg_10_1] ~= nil, "User (%d) is not added", arg_10_1)

	local var_10_0 = self._current_users[arg_10_1]

	var_10_0.restrictions = table.clone(arg_10_2)

	for i, v in ipairs(arg_10_2) do
		var_10_0[v] = nil
	end

	self:_fetch_next_restriction_access(arg_10_1)
end

PSRestrictions._set_restriction_fetched = function (self, arg_11_1, arg_11_2)
	-- function 11
	local restrictions = self._current_users[arg_11_1].restrictions
	local find = table.find(restrictions, arg_11_2)

	if not find then
		table.remove(restrictions, find)
	end
end

PSRestrictions._try_fetch_next_restriction_access = function (self, arg_12_1)
	-- function 12
	if #self._current_users[arg_12_1].restrictions > 0 then
		self:_fetch_next_restriction_access(arg_12_1)
	end
end

PSRestrictions._playstation_plus_start = function (arg_13_0, arg_13_1)
	-- function 13
	return NpCheck.check_plus(arg_13_1, NpCheck.REALTIME_MULTIPLAY)
end

PSRestrictions._network_availability_start = function (arg_14_0, arg_14_1)
	-- function 14
	return NpCheck.check_availability(arg_14_1)
end

PSRestrictions._parental_control_start = function (arg_15_0, arg_15_1)
	-- function 15
	return NpCheck.parental_control_info(arg_15_1)
end

PSRestrictions.cb_network_availability = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local error = arg_16_3.error

	error = error or NpCheck.error_code(arg_16_3.token)

	if not error then
		fn_2("Error (%#x) when checking (%s) access for user (%d)", error, arg_16_2, arg_16_1)

		self._current_users[arg_16_1][arg_16_2] = {
			access = false,
			error = error
		}
	else
		local result = NpCheck.result(arg_16_3.token)

		fn("(%q) access for user (%d) result (%s)", arg_16_2, arg_16_1, tostring(result))

		self._current_users[arg_16_1][arg_16_2] = {
			error = false,
			access = result
		}
	end

	self:_set_restriction_fetched(arg_16_1, arg_16_2)
	self:_try_fetch_next_restriction_access(arg_16_1)
end

PSRestrictions.cb_playstation_plus = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local error = arg_17_3.error

	error = error or NpCheck.error_code(arg_17_3.token)

	if not error then
		fn_2("Error (%#x) when checking (%s) access for user (%d)", error, arg_17_2, arg_17_1)

		self._current_users[arg_17_1][arg_17_2] = {
			access = false,
			error = error
		}
	else
		local result = NpCheck.result(arg_17_3.token)

		fn("(%q) access for user (%d) result (%s)", arg_17_2, arg_17_1, tostring(result))

		self._current_users[arg_17_1][arg_17_2] = {
			error = false,
			access = result
		}
	end

	self:_set_restriction_fetched(arg_17_1, arg_17_2)
	self:_try_fetch_next_restriction_access(arg_17_1)
end

PSRestrictions.cb_parental_control = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local error = arg_18_3.error

	error = error or NpCheck.error_code(arg_18_3.token)

	if not error then
		fn_2("Error (%#x) when checking parental control access for user (%d)", error, arg_18_1)

		self._current_users[arg_18_1].chat = {
			access = false,
			error = error
		}
		self._current_users[arg_18_1].user_generated_content = {
			access = false,
			error = error
		}
	else
		local parental_control_info_result = NpCheck.parental_control_info_result(arg_18_3.token)
		local flag = parental_control_info_result.chat_restriction == false
		local flag_2 = parental_control_info_result.ugc_restriction == false

		self._current_users[arg_18_1].chat = {
			error = false,
			access = flag
		}
		self._current_users[arg_18_1].user_generated_content = {
			error = false,
			access = flag_2
		}

		fn("\"chat\" access for user (%d) result (%s)", arg_18_1, tostring(flag))
		fn("\"ugc\" access for user (%d) result (%s)", arg_18_1, tostring(flag_2))
	end

	self:_set_restriction_fetched(arg_18_1, arg_18_2)
	self:_try_fetch_next_restriction_access(arg_18_1)
end
