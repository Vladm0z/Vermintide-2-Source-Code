-- chunkname: @scripts/network/ps_restrictions.lua

require("scripts/network/script_ps_restriction_token")

PSRestrictions = class(PSRestrictions)

local var_0_0 = {
	"network_availability",
	"playstation_plus",
	"parental_control"
}
local var_0_1 = {
	playstation_plus = "_playstation_plus_start",
	network_availability = "_network_availability_start",
	parental_control = "_parental_control_start"
}
local var_0_2 = {
	playstation_plus = "cb_playstation_plus",
	network_availability = "cb_network_availability",
	parental_control = "cb_parental_control"
}

local function var_0_3(arg_1_0, ...)
	if script_data.debug_ps_restrictions then
		local var_1_0 = arg_1_0.format("[PSRestrictions] %s", arg_1_0)

		printf(var_1_0, ...)
	end
end

local function var_0_4(arg_2_0, ...)
	local var_2_0 = arg_2_0.format("[PSRestrictions] %s", arg_2_0)

	Application.error(arg_2_0.format(var_2_0, ...))
end

local var_0_5 = script_data.fake_restrictions

function PSRestrictions.init(arg_3_0)
	arg_3_0._current_users = {}
end

function PSRestrictions.add_user(arg_4_0, arg_4_1)
	arg_4_0._current_users[arg_4_1] = {
		restrictions = table.clone(var_0_0)
	}

	arg_4_0:_start_restriction_access_fetched(arg_4_1)
end

function PSRestrictions._start_restriction_access_fetched(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._current_users[arg_5_1]

	arg_5_0:_fetch_next_restriction_access(arg_5_1)
end

function PSRestrictions._fetch_next_restriction_access(arg_6_0, arg_6_1)
	if var_0_5 then
		return
	end

	local var_6_0 = arg_6_0._current_users[arg_6_1].restrictions
	local var_6_1, var_6_2 = next(var_6_0)
	local var_6_3 = PS4.signed_in(arg_6_1)
	local var_6_4 = var_0_1[var_6_2]
	local var_6_5 = var_0_2[var_6_2]

	if var_6_3 then
		local var_6_6 = arg_6_0[var_6_4](arg_6_0, arg_6_1)
		local var_6_7 = ScriptPSRestrictionToken:new(var_6_6)

		Managers.token:register_token(var_6_7, callback(arg_6_0, var_6_5, arg_6_1, var_6_2))
	else
		arg_6_0[var_6_5](arg_6_0, arg_6_1, var_6_2, {
			error = PS4.SCE_NP_ERROR_SIGNED_OUT
		})
	end
end

function PSRestrictions.has_access(arg_7_0, arg_7_1, arg_7_2)
	if var_0_5 then
		return true
	end

	local var_7_0 = arg_7_0._current_users[arg_7_1][arg_7_2].access

	fassert(var_7_0 ~= nil, "Have not fetched access to this restriction (%s)", arg_7_2)

	return var_7_0
end

function PSRestrictions.has_error(arg_8_0, arg_8_1, arg_8_2)
	if var_0_5 then
		return false
	end

	return arg_8_0._current_users[arg_8_1][arg_8_2].error
end

function PSRestrictions.restriction_access_fetched(arg_9_0, arg_9_1, arg_9_2)
	if var_0_5 then
		return true
	end

	return arg_9_0._current_users[arg_9_1][arg_9_2]
end

function PSRestrictions.refetch_restriction_access(arg_10_0, arg_10_1, arg_10_2)
	fassert(arg_10_0._current_users[arg_10_1] ~= nil, "User (%d) is not added", arg_10_1)

	local var_10_0 = arg_10_0._current_users[arg_10_1]

	var_10_0.restrictions = table.clone(arg_10_2)

	for iter_10_0, iter_10_1 in ipairs(arg_10_2) do
		var_10_0[iter_10_1] = nil
	end

	arg_10_0:_fetch_next_restriction_access(arg_10_1)
end

function PSRestrictions._set_restriction_fetched(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._current_users[arg_11_1].restrictions
	local var_11_1 = table.find(var_11_0, arg_11_2)

	if var_11_1 then
		table.remove(var_11_0, var_11_1)
	end
end

function PSRestrictions._try_fetch_next_restriction_access(arg_12_0, arg_12_1)
	if #arg_12_0._current_users[arg_12_1].restrictions > 0 then
		arg_12_0:_fetch_next_restriction_access(arg_12_1)
	end
end

function PSRestrictions._playstation_plus_start(arg_13_0, arg_13_1)
	return NpCheck.check_plus(arg_13_1, NpCheck.REALTIME_MULTIPLAY)
end

function PSRestrictions._network_availability_start(arg_14_0, arg_14_1)
	return NpCheck.check_availability(arg_14_1)
end

function PSRestrictions._parental_control_start(arg_15_0, arg_15_1)
	return NpCheck.parental_control_info(arg_15_1)
end

function PSRestrictions.cb_network_availability(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_3.error or NpCheck.error_code(arg_16_3.token)

	if var_16_0 then
		var_0_4("Error (%#x) when checking (%s) access for user (%d)", var_16_0, arg_16_2, arg_16_1)

		arg_16_0._current_users[arg_16_1][arg_16_2] = {
			access = false,
			error = var_16_0
		}
	else
		local var_16_1 = NpCheck.result(arg_16_3.token)

		var_0_3("(%q) access for user (%d) result (%s)", arg_16_2, arg_16_1, tostring(var_16_1))

		arg_16_0._current_users[arg_16_1][arg_16_2] = {
			error = false,
			access = var_16_1
		}
	end

	arg_16_0:_set_restriction_fetched(arg_16_1, arg_16_2)
	arg_16_0:_try_fetch_next_restriction_access(arg_16_1)
end

function PSRestrictions.cb_playstation_plus(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_3.error or NpCheck.error_code(arg_17_3.token)

	if var_17_0 then
		var_0_4("Error (%#x) when checking (%s) access for user (%d)", var_17_0, arg_17_2, arg_17_1)

		arg_17_0._current_users[arg_17_1][arg_17_2] = {
			access = false,
			error = var_17_0
		}
	else
		local var_17_1 = NpCheck.result(arg_17_3.token)

		var_0_3("(%q) access for user (%d) result (%s)", arg_17_2, arg_17_1, tostring(var_17_1))

		arg_17_0._current_users[arg_17_1][arg_17_2] = {
			error = false,
			access = var_17_1
		}
	end

	arg_17_0:_set_restriction_fetched(arg_17_1, arg_17_2)
	arg_17_0:_try_fetch_next_restriction_access(arg_17_1)
end

function PSRestrictions.cb_parental_control(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_3.error or NpCheck.error_code(arg_18_3.token)

	if var_18_0 then
		var_0_4("Error (%#x) when checking parental control access for user (%d)", var_18_0, arg_18_1)

		arg_18_0._current_users[arg_18_1].chat = {
			access = false,
			error = var_18_0
		}
		arg_18_0._current_users[arg_18_1].user_generated_content = {
			access = false,
			error = var_18_0
		}
	else
		local var_18_1 = NpCheck.parental_control_info_result(arg_18_3.token)
		local var_18_2 = var_18_1.chat_restriction == false
		local var_18_3 = var_18_1.ugc_restriction == false

		arg_18_0._current_users[arg_18_1].chat = {
			error = false,
			access = var_18_2
		}
		arg_18_0._current_users[arg_18_1].user_generated_content = {
			error = false,
			access = var_18_3
		}

		var_0_3("\"chat\" access for user (%d) result (%s)", arg_18_1, tostring(var_18_2))
		var_0_3("\"ugc\" access for user (%d) result (%s)", arg_18_1, tostring(var_18_3))
	end

	arg_18_0:_set_restriction_fetched(arg_18_1, arg_18_2)
	arg_18_0:_try_fetch_next_restriction_access(arg_18_1)
end
