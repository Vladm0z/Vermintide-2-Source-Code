-- chunkname: @scripts/managers/backend_playfab/playfab_request_queue.lua

local var_0_0 = require("PlayFab.PlayFabClientApi")

if not IS_PS4 or not math.uuid then
	local var_0_1 = Application.guid
end

PlayFabRequestQueue = class(PlayFabRequestQueue)

local var_0_2 = 2
local var_0_3 = 20
local var_0_4 = 10

function PlayFabRequestQueue.init(arg_1_0)
	arg_1_0._queue = {}
	arg_1_0._active_entry = nil
	arg_1_0._id = 0
	arg_1_0._eac_id = 0
	arg_1_0._metadata = Managers.backend:get_metadata()
	arg_1_0._throttle_per_func = {}
end

function PlayFabRequestQueue.is_pending_request(arg_2_0)
	return arg_2_0._active_entry or #arg_2_0._queue > 0
end

function PlayFabRequestQueue.enqueue(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0._id + 1
	local var_3_1 = arg_3_1.FunctionParameter

	if not var_3_1 then
		arg_3_1.FunctionParameter = {
			metadata = arg_3_0._metadata
		}
	else
		var_3_1.metadata = arg_3_0._metadata
	end

	local var_3_2 = {
		resends = 0,
		eac_challenge_success = false,
		api_function_name = "ExecuteCloudScript",
		request = table.clone(arg_3_1),
		success_callback = arg_3_2,
		error_callback = arg_3_4,
		send_eac_challenge = IS_WINDOWS and arg_3_3,
		timeout = var_0_3,
		id = var_3_0
	}

	print("[PlayFabRequestQueue] Enqueuing ExecuteCloudScript request", arg_3_1.FunctionName, var_3_0)
	table.insert(arg_3_0._queue, var_3_2)

	arg_3_0._id = var_3_0

	return var_3_0
end

function PlayFabRequestQueue.enqueue_api_request(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0._id + 1
	local var_4_1 = {
		resends = 0,
		send_eac_challenge = false,
		api_function_name = arg_4_1,
		request = table.clone(arg_4_2),
		success_callback = arg_4_3,
		error_callback = arg_4_4,
		timeout = var_0_3,
		id = var_4_0
	}

	print("[PlayFabRequestQueue] Enqueuing Client API request", arg_4_1, var_4_0)
	table.insert(arg_4_0._queue, var_4_1)

	arg_4_0._id = var_4_0

	return var_4_0
end

function PlayFabRequestQueue._need_throttle(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._throttle_per_func[arg_5_1] or {}
	local var_5_1 = #var_5_0 + 1

	if var_5_1 >= var_0_4 then
		return true
	end

	var_5_0[var_5_1] = arg_5_2 + 15
	arg_5_0._throttle_per_func[arg_5_1] = var_5_0

	return false
end

function PlayFabRequestQueue._update_throttling(arg_6_0, arg_6_1, arg_6_2)
	for iter_6_0, iter_6_1 in pairs(arg_6_0._throttle_per_func) do
		local var_6_0 = iter_6_1[1] or arg_6_1 + 1

		while var_6_0 < arg_6_1 do
			table.remove(iter_6_1, 1)

			var_6_0 = iter_6_1[1] or arg_6_1 + 1
		end
	end

	if arg_6_2.send_eac_challenge and arg_6_0:_need_throttle("generateChallenge", arg_6_1) then
		return false
	end

	local var_6_1 = arg_6_2.request and arg_6_2.request.FunctionName or arg_6_2.api_function_name

	if arg_6_0:_need_throttle(var_6_1, arg_6_1) then
		return false
	end

	return true
end

function PlayFabRequestQueue.update(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._active_entry

	if var_7_0 then
		local var_7_1 = var_7_0.timeout - arg_7_1
		local var_7_2 = var_7_0.request

		if var_7_1 > 0 then
			arg_7_0._active_entry.timeout = var_7_1

			return
		elseif var_7_0.resends < var_0_2 and var_7_0.send_eac_challenge and not var_7_0.eac_challenge_success then
			var_7_0.resends = var_7_0.resends + 1
			var_7_0.timeout = var_0_3

			print("[PlayFabRequestQueue] EAC Challenge Request Timed Out Resending", var_7_2.FunctionName, var_7_0.id)
			table.dump(var_7_0, nil, 5)
			Crashify.print_exception("PlayFabRequestQueue", "EAC Challenge Request Timed Out - Resending")
			table.insert(arg_7_0._queue, 1, var_7_0)
		else
			print("[PlayFabRequestQueue] Request Timed Out", var_7_2.api_function_name, var_7_2.FunctionName, var_7_0.id)
			table.dump(var_7_0, nil, 5)
			Crashify.print_exception("PlayFabRequestQueue", "Request Timed Out")

			return "request_timed_out", var_7_0.id
		end
	end

	if table.is_empty(arg_7_0._queue) then
		return
	end

	if not arg_7_0:_update_throttling(arg_7_2, arg_7_0._queue[1]) then
		return
	end

	local var_7_3 = table.remove(arg_7_0._queue, 1)
	local var_7_4 = var_7_3.request

	arg_7_0._active_entry = var_7_3

	if var_7_3.send_eac_challenge then
		local var_7_5 = arg_7_0._eac_id + 1
		local var_7_6 = callback(arg_7_0, "eac_challenge_success_cb")
		local var_7_7 = {
			FunctionName = "generateChallenge",
			FunctionParameter = {
				eac_id = var_7_5,
				metadata = arg_7_0._metadata
			}
		}

		var_7_3.expected_eac_id = var_7_5
		arg_7_0._eac_id = var_7_5

		print("[PlayFabRequestQueue] Sending EAC Challenge Request", var_7_4.FunctionName, var_7_3.id, var_7_5)
		var_0_0.ExecuteCloudScript(var_7_7, var_7_6)
	else
		print("[PlayFabRequestQueue] Sending Request Without EAC Challenge", var_7_3.api_function_name, var_7_4.FunctionName, var_7_3.id)
		arg_7_0:_send_request(var_7_3)
	end
end

function PlayFabRequestQueue.eac_challenge_success_cb(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._active_entry
	local var_8_1 = arg_8_1.FunctionResult
	local var_8_2 = var_8_1.challenge
	local var_8_3 = var_8_1.eac_id

	if not var_8_0 or var_8_3 and var_8_3 ~= var_8_0.expected_eac_id then
		print("[PlayFabRequestQueue] Received Timed Out EAC Response - Ignoring", var_8_3)

		return
	end

	local var_8_4
	local var_8_5

	if var_8_2 then
		var_8_4, var_8_5 = arg_8_0:_get_eac_response(var_8_2)
	end

	if not var_8_2 then
		print("[PlayFabRequestQueue] EAC disabled on backend", var_8_0.id)
		arg_8_0:_challenge_response_received()
	elseif not var_8_4 then
		print("[PlayFabRequestQueue] EAC disabled on client", var_8_0.id)

		var_8_0.timeout = math.huge

		Managers.backend:playfab_eac_error()
	else
		print("[PlayFabRequestQueue] EAC Enabled!", var_8_0.id)
		arg_8_0:_challenge_response_received(var_8_5)
	end
end

function PlayFabRequestQueue._challenge_response_received(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._active_entry

	var_9_0.eac_challenge_success = true
	var_9_0.timeout = var_0_3

	local var_9_1 = var_9_0.request
	local var_9_2 = var_9_1.FunctionParameter or {}

	var_9_2.response = arg_9_1
	var_9_1.FunctionParameter = var_9_2

	print("[PlayFabRequestQueue] Sending Request", var_9_1.FunctionName, var_9_0.id)
	arg_9_0:_send_request(var_9_0)
end

function PlayFabRequestQueue._send_request(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.api_function_name
	local var_10_1 = arg_10_1.request
	local var_10_2 = arg_10_1.success_callback
	local var_10_3 = callback(arg_10_0, "playfab_request_success_cb", var_10_2, arg_10_1.id)
	local var_10_4 = arg_10_1.error_callback
	local var_10_5 = var_10_4 and callback(arg_10_0, "playfab_request_error_cb", var_10_4, arg_10_1.id)

	var_0_0[var_10_0](var_10_1, var_10_3, var_10_5)

	arg_10_0._current_api_call = var_10_1.FunctionName
end

function PlayFabRequestQueue.playfab_request_success_cb(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_0._current_api_call = nil

	local var_11_0 = arg_11_0._active_entry
	local var_11_1 = arg_11_3.FunctionResult

	if not var_11_0 or arg_11_2 and arg_11_2 ~= var_11_0.id then
		print("[PlayFabRequestQueue] Received Timed Out Success Response - Ignoring", arg_11_2)

		return
	end

	local var_11_2 = var_11_0.request

	if var_11_1 and var_11_1.eac_failed_verification then
		print("[PlayFabRequestQueue] EAC Failed Verification", var_11_2.FunctionName, var_11_0.id)
		Managers.backend:playfab_eac_error()

		return
	end

	print("[PlayFabRequestQueue] Request Success", var_11_0.api_function_name, var_11_2.FunctionName, var_11_0.id)

	arg_11_0._active_entry = nil

	arg_11_1(arg_11_3)

	if script_data.testify then
		local var_11_3 = Testify:poll_request("wait_for_playfab_response")

		if var_11_3 and var_11_3 == var_11_2.FunctionName then
			Testify:respond_to_request("wait_for_playfab_response", {
				var_11_2.FunctionName
			}, 1)
		end
	end
end

function PlayFabRequestQueue.playfab_request_error_cb(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_0._current_api_call = nil

	local var_12_0 = arg_12_0._active_entry
	local var_12_1 = var_12_0.request

	if not var_12_0 or arg_12_2 and arg_12_2 ~= var_12_0.id then
		print("[PlayFabRequestQueue] Received Timed Out Error Response - Ignoring", arg_12_2)

		return
	end

	print("[PlayFabRequestQueue] Request Error", var_12_0.api_function_name, var_12_1.FunctionName, var_12_0.id, arg_12_3.errorCode, arg_12_3.errorMessage)

	local function var_12_2()
		arg_12_0._active_entry = nil
	end

	arg_12_1(arg_12_3, var_12_2)
end

function PlayFabRequestQueue._get_eac_response(arg_14_0, arg_14_1)
	local var_14_0 = 0
	local var_14_1 = ""

	while arg_14_1[tostring(var_14_0)] do
		var_14_1 = var_14_1 .. string.char(arg_14_1[tostring(var_14_0)])
		var_14_0 = var_14_0 + 1
	end

	local var_14_2 = Managers.eac:challenge_response(var_14_1)
	local var_14_3

	if var_14_2 then
		local var_14_4 = 1

		var_14_3 = {}

		while string.byte(var_14_2, var_14_4, var_14_4) do
			local var_14_5 = string.byte(var_14_2, var_14_4, var_14_4)

			var_14_3[tostring(var_14_4 - 1)] = var_14_5
			var_14_4 = var_14_4 + 1
		end
	end

	return var_14_2, var_14_3
end

function PlayFabRequestQueue.current_api_call(arg_15_0)
	return arg_15_0._current_api_call
end
