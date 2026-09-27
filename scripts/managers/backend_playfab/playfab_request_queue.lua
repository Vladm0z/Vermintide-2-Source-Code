-- chunkname: @scripts/managers/backend_playfab/playfab_request_queue.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

if not (not IS_PS4 and math.uuid) then
	local guid = Application.guid
end

PlayFabRequestQueue = class(PlayFabRequestQueue)

local num = 2
local num_2 = 20
local num_3 = 10

PlayFabRequestQueue.init = function (self)
	-- function 1
	self._queue = {}
	self._active_entry = nil
	self._id = 0
	self._eac_id = 0
	self._metadata = Managers.backend:get_metadata()
	self._throttle_per_func = {}
end

PlayFabRequestQueue.is_pending_request = function (self)
	-- function 2
	local _active_entry = self._active_entry

	_active_entry = _active_entry or #self._queue > 0

	return _active_entry
end

PlayFabRequestQueue.enqueue = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local num = self._id + 1
	local FunctionParameter = arg_3_1.FunctionParameter

	if not FunctionParameter then
		arg_3_1.FunctionParameter = {
			metadata = self._metadata
		}
	else
		FunctionParameter.metadata = self._metadata
	end

	local tbl = {
		resends = 0,
		eac_challenge_success = false,
		api_function_name = "ExecuteCloudScript",
		request = table.clone(arg_3_1),
		success_callback = arg_3_2,
		error_callback = arg_3_4
	}
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and arg_3_3
	tbl.send_eac_challenge = IS_WINDOWS
	tbl.timeout = num_2
	tbl.id = num

	print("[PlayFabRequestQueue] Enqueuing ExecuteCloudScript request", arg_3_1.FunctionName, num)
	table.insert(self._queue, tbl)

	self._id = num

	return num
end

PlayFabRequestQueue.enqueue_api_request = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local num = self._id + 1
	local tbl = {
		resends = 0,
		send_eac_challenge = false,
		api_function_name = arg_4_1,
		request = table.clone(arg_4_2),
		success_callback = arg_4_3,
		error_callback = arg_4_4,
		timeout = num_2,
		id = num
	}

	print("[PlayFabRequestQueue] Enqueuing Client API request", arg_4_1, num)
	table.insert(self._queue, tbl)

	self._id = num

	return num
end

PlayFabRequestQueue._need_throttle = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self._throttle_per_func[arg_5_1]

	var_5_0 = var_5_0 or {}

	local num = #var_5_0 + 1

	if num >= num_3 then
		return true
	end

	var_5_0[num] = arg_5_2 + 15
	self._throttle_per_func[arg_5_1] = var_5_0

	return false
end

PlayFabRequestQueue._update_throttling = function (self, arg_6_1, arg_6_2)
	-- function 6
	for k, v in pairs(self._throttle_per_func) do
		local var_6_0 = v[1]

		var_6_0 = var_6_0 or arg_6_1 + 1

		while var_6_0 < arg_6_1 do
			table.remove(v, 1)

			var_6_0 = v[1] or arg_6_1 + 1
		end
	end

	if not arg_6_2.send_eac_challenge and not self:_need_throttle("generateChallenge", arg_6_1) then
		return false
	end

	local FunctionName

	if not arg_6_2.request then
		FunctionName = arg_6_2.request.FunctionName

		if not FunctionName then
			-- Nothing
		end
	end

	FunctionName = arg_6_2.api_function_name

	::label_6_0::

	if not self:_need_throttle(FunctionName, arg_6_1) then
		return false
	end

	return true
end

PlayFabRequestQueue.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _active_entry = self._active_entry

	if not _active_entry then
		local num_3 = _active_entry.timeout - arg_7_1
		local request = _active_entry.request

		if num_3 > 0 then
			self._active_entry.timeout = num_3

			return
		elseif not ((not (_active_entry.resends < num) or not _active_entry.send_eac_challenge) and _active_entry.eac_challenge_success) then
			_active_entry.resends = _active_entry.resends + 1
			_active_entry.timeout = num_2

			print("[PlayFabRequestQueue] EAC Challenge Request Timed Out Resending", request.FunctionName, _active_entry.id)
			table.dump(_active_entry, nil, 5)
			Crashify.print_exception("PlayFabRequestQueue", "EAC Challenge Request Timed Out - Resending")
			table.insert(self._queue, 1, _active_entry)
		else
			print("[PlayFabRequestQueue] Request Timed Out", request.api_function_name, request.FunctionName, _active_entry.id)
			table.dump(_active_entry, nil, 5)
			Crashify.print_exception("PlayFabRequestQueue", "Request Timed Out")

			return "request_timed_out", _active_entry.id
		end
	end

	if not table.is_empty(self._queue) then
		return
	end

	if not self:_update_throttling(arg_7_2, self._queue[1]) then
		return
	end

	local remove = table.remove(self._queue, 1)
	local request_2 = remove.request

	self._active_entry = remove

	if not remove.send_eac_challenge then
		local num_4 = self._eac_id + 1
		local var_7_6 = callback(self, "eac_challenge_success_cb")
		local tbl = {
			FunctionName = "generateChallenge",
			FunctionParameter = {
				eac_id = num_4,
				metadata = self._metadata
			}
		}

		remove.expected_eac_id = num_4
		self._eac_id = num_4

		print("[PlayFabRequestQueue] Sending EAC Challenge Request", request_2.FunctionName, remove.id, num_4)
		PlayFabClientApi.ExecuteCloudScript(tbl, var_7_6)
	else
		print("[PlayFabRequestQueue] Sending Request Without EAC Challenge", remove.api_function_name, request_2.FunctionName, remove.id)
		self:_send_request(remove)
	end
end

PlayFabRequestQueue.eac_challenge_success_cb = function (self, arg_8_1)
	-- function 8
	local _active_entry = self._active_entry
	local FunctionResult = arg_8_1.FunctionResult
	local challenge = FunctionResult.challenge
	local eac_id = FunctionResult.eac_id

	if not (not _active_entry and not eac_id and eac_id == _active_entry.expected_eac_id) then
		print("[PlayFabRequestQueue] Received Timed Out EAC Response - Ignoring", eac_id)

		return
	end

	local var_8_4
	local var_8_5

	if not challenge then
		var_8_4, var_8_5 = self:_get_eac_response(challenge)
	end

	if not challenge then
		print("[PlayFabRequestQueue] EAC disabled on backend", _active_entry.id)
		self:_challenge_response_received()
	elseif not var_8_4 then
		print("[PlayFabRequestQueue] EAC disabled on client", _active_entry.id)

		_active_entry.timeout = math.huge

		Managers.backend:playfab_eac_error()
	else
		print("[PlayFabRequestQueue] EAC Enabled!", _active_entry.id)
		self:_challenge_response_received(var_8_5)
	end
end

PlayFabRequestQueue._challenge_response_received = function (self, arg_9_1)
	-- function 9
	local _active_entry = self._active_entry

	_active_entry.eac_challenge_success = true
	_active_entry.timeout = num_2

	local request = _active_entry.request
	local FunctionParameter = request.FunctionParameter

	FunctionParameter = FunctionParameter or {}
	FunctionParameter.response = arg_9_1
	request.FunctionParameter = FunctionParameter

	print("[PlayFabRequestQueue] Sending Request", request.FunctionName, _active_entry.id)
	self:_send_request(_active_entry)
end

PlayFabRequestQueue._send_request = function (self, arg_10_1)
	-- function 10
	local api_function_name = arg_10_1.api_function_name
	local request = arg_10_1.request
	local success_callback = arg_10_1.success_callback
	local var_10_3 = callback(self, "playfab_request_success_cb", success_callback, arg_10_1.id)
	local error_callback = arg_10_1.error_callback
	local flag = not error_callback and callback(self, "playfab_request_error_cb", error_callback, arg_10_1.id)

	PlayFabClientApi[api_function_name](request, var_10_3, flag)

	self._current_api_call = request.FunctionName
end

PlayFabRequestQueue.playfab_request_success_cb = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	self._current_api_call = nil

	local _active_entry = self._active_entry
	local FunctionResult = arg_11_3.FunctionResult

	if not (not _active_entry and not arg_11_2 and arg_11_2 == _active_entry.id) then
		print("[PlayFabRequestQueue] Received Timed Out Success Response - Ignoring", arg_11_2)

		return
	end

	local request = _active_entry.request

	if not FunctionResult and not FunctionResult.eac_failed_verification then
		print("[PlayFabRequestQueue] EAC Failed Verification", request.FunctionName, _active_entry.id)
		Managers.backend:playfab_eac_error()

		return
	end

	print("[PlayFabRequestQueue] Request Success", _active_entry.api_function_name, request.FunctionName, _active_entry.id)

	self._active_entry = nil

	arg_11_1(arg_11_3)

	if not script_data.testify then
		local poll_request = Testify:poll_request("wait_for_playfab_response")

		if not (not poll_request and poll_request ~= request.FunctionName) then
			Testify:respond_to_request("wait_for_playfab_response", {
				request.FunctionName
			}, 1)
		end
	end
end

PlayFabRequestQueue.playfab_request_error_cb = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	self._current_api_call = nil

	local _active_entry = self._active_entry
	local request = _active_entry.request

	if not (not _active_entry and not arg_12_2 and arg_12_2 == _active_entry.id) then
		print("[PlayFabRequestQueue] Received Timed Out Error Response - Ignoring", arg_12_2)

		return
	end

	print("[PlayFabRequestQueue] Request Error", _active_entry.api_function_name, request.FunctionName, _active_entry.id, arg_12_3.errorCode, arg_12_3.errorMessage)

	local function fn()
		-- function 13
		self._active_entry = nil
	end

	arg_12_1(arg_12_3, fn)
end

PlayFabRequestQueue._get_eac_response = function (arg_14_0, arg_14_1)
	-- function 14
	local num = 0
	local str = ""

	while not arg_14_1[tostring(num)] do
		str = str .. string.char(arg_14_1[tostring(num)])
		num = num + 1
	end

	local challenge_response = Managers.eac:challenge_response(str)
	local var_14_3

	if not challenge_response then
		local num_2 = 1

		var_14_3 = {}

		while not string.byte(challenge_response, num_2, num_2) do
			local byte = string.byte(challenge_response, num_2, num_2)

			var_14_3[tostring(num_2 - 1)] = byte
			num_2 = num_2 + 1
		end
	end

	return challenge_response, var_14_3
end

PlayFabRequestQueue.current_api_call = function (self)
	-- function 15
	return self._current_api_call
end
