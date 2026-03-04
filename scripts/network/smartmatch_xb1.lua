-- chunkname: @scripts/network/smartmatch_xb1.lua

local var_0_0 = true

local function var_0_1()
	return
end

if var_0_0 then
	function var_0_1(...)
		print("[SmartMatch]", string.format(...))
	end
end

local var_0_2 = {
	default_stage_hopper = {
		"difficulty",
		"stage"
	},
	new_stage_hopper = {
		"difficulty",
		"level",
		"powerlevel",
		"strict_matchmaking"
	},
	safe_profiles_hopper = {
		"difficulty",
		"level",
		"powerlevel",
		"strict_matchmaking",
		"profiles",
		"network_hash",
		"matchmaking_types"
	},
	weave_find_group_hopper = {
		"difficulty",
		"powerlevel",
		"profiles",
		"network_hash",
		"matchmaking_types",
		"weave_index"
	}
}
local var_0_3 = {
	network_hash = "string",
	strict_matchmaking = "number",
	weave_index = "number",
	powerlevel = "number",
	matchmaking_types = "collection",
	profiles = "collection",
	stage = "number",
	difficulty = "number",
	level = "collection"
}
local var_0_4 = {
	default_stage_hopper = {},
	new_stage_hopper = {
		strict_matchmaking = true
	},
	safe_profiles_hopper = {
		strict_matchmaking = true
	},
	weave_find_group_hopper = {
		profiles = true,
		weave_index = true,
		difficulty = true,
		powerlevel = true
	}
}
local var_0_5 = {
	[SmartMatchStatus.UNKNOWN] = "UNKNOWN",
	[SmartMatchStatus.SEARCHING] = "SEARCHING",
	[SmartMatchStatus.EXPIRED] = "EXPIRED",
	[SmartMatchStatus.FOUND] = "FOUND"
}
local var_0_6 = {
	[MultiplayerSession.READY] = "READY",
	[MultiplayerSession.WORKING] = "WORKING",
	[MultiplayerSession.SHUTDOWN] = "SHUTDOWN",
	[MultiplayerSession.BROKEN] = "BROKEN"
}

SmartMatch = class(SmartMatch)

function SmartMatch.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0._hopper_name = arg_3_1 or LobbyInternal.HOPPER_NAME
	arg_3_0._is_host = arg_3_2 or false
	arg_3_0._ticket_params = arg_3_3 or {}
	arg_3_0._timout = arg_3_4 or 90
	arg_3_0._ticket_id = nil
	arg_3_0._user_id = Managers.account:user_id()

	if table.is_empty(arg_3_0._ticket_params) then
		var_0_1("No params sent to SmartMatch")
	end

	arg_3_0:_create_smartmatch_session()

	arg_3_0._state = "_start_smartmatch"

	return arg_3_0._hopper_name
end

function SmartMatch._create_smartmatch_session(arg_4_0)
	local var_4_0 = Application.guid()
	local var_4_1 = arg_4_0._hopper_name
	local var_4_2 = LobbyInternal.SMARTMATCH_SESSION_TEMPLATE_NAME
	local var_4_3
	local var_4_4 = 0
	local var_4_5 = 0
	local var_4_6

	arg_4_0._session_id = Network.create_multiplayer_session_host(arg_4_0._user_id, var_4_0, var_4_2, var_4_3, var_4_4, var_4_5, var_4_6)
	arg_4_0._session_name = var_4_0
end

function SmartMatch._handle_smartmatch_session(arg_5_0)
	local var_5_0 = MultiplayerSession.status(arg_5_0._session_id)

	if var_5_0 ~= arg_5_0._status then
		var_0_1("Session status changed from: %s to %s", arg_5_0._status and var_0_6[arg_5_0._status] or "NONE", var_5_0 and var_0_6[var_5_0] or "NONE")

		arg_5_0._status = var_5_0
		arg_5_0._ready = var_5_0 == MultiplayerSession.READY
		arg_5_0._failed = var_5_0 == MultiplayerSession.BROKEN
	end
end

function SmartMatch._start_smartmatch(arg_6_0, arg_6_1)
	if not arg_6_0._ready then
		return
	end

	local var_6_0 = arg_6_0._is_host and arg_6_0._timout * 10 or arg_6_0._timout
	local var_6_1 = arg_6_0._is_host and PreserveSessionMode.ALWAYS or PreserveSessionMode.NEVER

	var_0_1("PreserveSessionMode %s. is host %s", var_6_1 == PreserveSessionMode.ALWAYS and "ALWAYS" or "NEVER", arg_6_0._is_host and "TRUE" or "FALSE")

	local var_6_2

	if arg_6_0._ticket_params then
		var_6_2 = arg_6_0:_convert_to_json(arg_6_0._hopper_name, arg_6_0._ticket_params)

		var_0_1("Ticket Params: %s Hopper Name: %s", var_6_2, arg_6_0._hopper_name)
	end

	var_0_1("Starting SmartMatch with session_id: %s Hopper name: %s PreserveSessionMode: %s Ticket params: %s Timeout: %i", tostring(arg_6_0._session_id), arg_6_0._hopper_name, var_6_1 == PreserveSessionMode.ALWAYS and "ALWAYS" or "NEVER", var_6_2, var_6_0)
	MultiplayerSession.start_smartmatch(arg_6_0._session_id, arg_6_0._hopper_name, var_6_0, var_6_1, var_6_2)

	arg_6_0._smartmatch_started = true
	arg_6_0._state = "_check_smartmatch_result"
end

function SmartMatch._check_smartmatch_result(arg_7_0, arg_7_1)
	if not arg_7_0._ready then
		return
	end

	local var_7_0, var_7_1 = MultiplayerSession.start_smartmatch_result(arg_7_0._session_id)

	if (not arg_7_0._ticket_id or arg_7_0._ticket_id ~= var_7_0) and var_7_0 ~= "" then
		var_0_1("Started smartmatch with ticket_id: %s", var_7_0)

		arg_7_0._ticket_id = var_7_0
	end

	if not arg_7_0._estimated_waiting_time then
		var_0_1("[Start] Estimated waiting time: %s", var_7_1)

		arg_7_0._estimated_waiting_time = var_7_1
	end

	local var_7_2 = MultiplayerSession.smartmatch_status(arg_7_0._session_id)
	local var_7_3, var_7_4, var_7_5 = MultiplayerSession.smartmatch_result(arg_7_0._session_id)

	arg_7_0._estimated_waiting_time = var_7_5 > 0 and var_7_5 or arg_7_0._estimated_waiting_time

	if arg_7_0._smartmatch_status ~= var_7_2 then
		if var_0_0 then
			var_0_1("SmartMatch Status Changed from %s to %s", arg_7_0._smartmatch_status and var_0_5[arg_7_0._smartmatch_status] or "NONE", var_7_2 and var_0_5[var_7_2] or "NONE")

			if var_7_3 ~= "" then
				var_0_1("Current session name: %s. Smartmatch session name: %s. Smartmatch session template: %s", arg_7_0._session_name, var_7_3, var_7_4)
			end
		end

		arg_7_0._smartmatch_status = var_7_2

		if arg_7_0._smartmatch_status == SmartMatchStatus.FOUND then
			local var_7_6 = var_7_3 == arg_7_0._session_name

			var_0_1("Found session - Session name: %s %s Session template: %s", var_7_3, var_7_6 and "(My own session)" or "", var_7_4)

			arg_7_0._found_session_name = var_7_3
			arg_7_0._found_session_template = var_7_4
			arg_7_0._done = true
			arg_7_0._failed = var_7_6

			if arg_7_0._failed then
				var_0_1("Smartmatch failed because: FOUND_SESSION == MY_SESSION")
			else
				var_0_1("Smartmatch SUCCESS!")
			end

			arg_7_0._state = "_smartmatch_done"
		elseif arg_7_0._smartmatch_status == SmartMatchStatus.EXPIRED then
			arg_7_0._done = true
			arg_7_0._failed = true

			var_0_1("Smartmatch failed because: TIMEOUT")

			arg_7_0._state = "_smartmatch_done"
		end
	end
end

function SmartMatch._smartmatch_done(arg_8_0, arg_8_1)
	return
end

function SmartMatch._convert_to_json(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = var_0_2[arg_9_1]
	local var_9_1 = var_0_4[arg_9_1]

	fassert(var_9_0, "[SmartMatch::_convert_to_json] No such hopper_name:  %s", arg_9_1)

	local var_9_2 = ""

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		local var_9_3 = var_0_3[iter_9_1]
		local var_9_4 = arg_9_2[iter_9_1]

		fassert(var_9_4 or var_9_1[iter_9_1], "[SmartMatch::_convert_to_json] Missing variable [%s] in params", iter_9_1)

		if var_9_4 then
			if var_9_3 == "number" then
				var_9_2 = var_9_2 .. string.format("%q:%i,", iter_9_1, var_9_4)
			elseif var_9_3 == "string" then
				var_9_2 = var_9_2 .. string.format("%q:%q,", iter_9_1, var_9_4)
			elseif var_9_3 == "collection" then
				var_9_2 = var_9_2 .. string.format("%q:[", iter_9_1)

				for iter_9_2, iter_9_3 in ipairs(var_9_4) do
					if iter_9_2 == 1 then
						var_9_2 = var_9_2 .. string.format("%q", tostring(iter_9_3))
					else
						var_9_2 = var_9_2 .. string.format(",%q", tostring(iter_9_3))
					end
				end

				var_9_2 = var_9_2 .. "],"
			end
		end
	end

	if var_9_2 == "" then
		return
	else
		local var_9_5 = string.sub(var_9_2, 1, -2)

		print("Hopper name:", arg_9_1, "JSON_DATA:", string.format("{%s}", var_9_5))

		return string.format("{%s}", var_9_5)
	end
end

function SmartMatch.update(arg_10_0, arg_10_1)
	arg_10_0:_handle_smartmatch_session()
	arg_10_0[arg_10_0._state](arg_10_0, arg_10_1)

	return arg_10_0._ready and not arg_10_0._done
end

function SmartMatch.is_search_done(arg_11_0)
	return arg_11_0._done
end

function SmartMatch.results(arg_12_0)
	return arg_12_0._found_session_name, arg_12_0._found_session_template
end

function SmartMatch.success(arg_13_0)
	return not arg_13_0._failed
end

function SmartMatch.destroy(arg_14_0)
	local var_14_0 = {
		destroy_session = true,
		state = "_cleanup_ticket",
		user_id = arg_14_0._user_id,
		session_id = arg_14_0._session_id,
		hopper_name = arg_14_0._hopper_name,
		session_name = arg_14_0._session_name
	}

	Managers.account:add_session_to_cleanup(var_14_0)
end
