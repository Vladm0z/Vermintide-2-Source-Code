-- chunkname: @scripts/network/smartmatch_xb1.lua

local flag = true

local function fn()
	-- function 1
	return
end

if not flag then
	function fn(...)
		-- function 2
		print("[SmartMatch]", string.format(...))
	end
end

local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
	[SmartMatchStatus.UNKNOWN] = "UNKNOWN",
	[SmartMatchStatus.SEARCHING] = "SEARCHING",
	[SmartMatchStatus.EXPIRED] = "EXPIRED",
	[SmartMatchStatus.FOUND] = "FOUND"
}
local tbl_5 = {
	[MultiplayerSession.READY] = "READY",
	[MultiplayerSession.WORKING] = "WORKING",
	[MultiplayerSession.SHUTDOWN] = "SHUTDOWN",
	[MultiplayerSession.BROKEN] = "BROKEN"
}

SmartMatch = class(SmartMatch)

SmartMatch.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self._hopper_name = arg_3_1 or LobbyInternal.HOPPER_NAME
	self._is_host = arg_3_2 or false
	self._ticket_params = arg_3_3 or {}
	self._timout = arg_3_4 or 90
	self._ticket_id = nil
	self._user_id = Managers.account:user_id()

	if not table.is_empty(self._ticket_params) then
		fn("No params sent to SmartMatch")
	end

	self:_create_smartmatch_session()

	self._state = "_start_smartmatch"

	return self._hopper_name
end

SmartMatch._create_smartmatch_session = function (self)
	-- function 4
	local guid = Application.guid()
	local _hopper_name = self._hopper_name
	local SMARTMATCH_SESSION_TEMPLATE_NAME = LobbyInternal.SMARTMATCH_SESSION_TEMPLATE_NAME
	local var_4_3
	local num = 0
	local num_2 = 0
	local var_4_6

	self._session_id = Network.create_multiplayer_session_host(self._user_id, guid, SMARTMATCH_SESSION_TEMPLATE_NAME, var_4_3, num, num_2, var_4_6)
	self._session_name = guid
end

SmartMatch._handle_smartmatch_session = function (self)
	-- function 5
	local status = MultiplayerSession.status(self._session_id)

	if status ~= self._status then
		local var_5_1 = fn
		local str = "Session status changed from: %s to %s"
		local var_5_3

		if not self._status then
			var_5_3 = tbl_5[self._status]

			if not var_5_3 then
				-- Nothing
			end
		end

		var_5_3 = "NONE"

		do
			local var_5_4
		end

		::label_5_0::

		if not status then
			var_5_4 = tbl_5[status]

			if not var_5_4 then
				-- Nothing
			end
		end

		var_5_4 = "NONE"

		::label_5_1::

		var_5_1(str, var_5_3, var_5_4)

		self._status = status
		self._ready = status == MultiplayerSession.READY
		self._failed = status == MultiplayerSession.BROKEN
	end
end

SmartMatch._start_smartmatch = function (self, arg_6_1)
	-- function 6
	if not self._ready then
		return
	end

	local num

	if not self._is_host then
		num = self._timout * 10

		if not num then
			-- Nothing
		end
	end

	num = self._timout

	do
		local ALWAYS
	end

	::label_6_0::

	if not self._is_host then
		ALWAYS = PreserveSessionMode.ALWAYS

		if not ALWAYS then
			-- Nothing
		end
	end

	ALWAYS = PreserveSessionMode.NEVER

	::label_6_1::

	local var_6_2 = fn
	local str = "PreserveSessionMode %s. is host %s"
	local flag

	flag = ALWAYS ~= PreserveSessionMode.ALWAYS or not "ALWAYS" or "NEVER"

	local flag_2

	flag_2 = not self._is_host and "TRUE" and "FALSE"

	var_6_2(str, flag, flag_2)

	local var_6_6

	if not self._ticket_params then
		var_6_6 = self:_convert_to_json(self._hopper_name, self._ticket_params)

		fn("Ticket Params: %s Hopper Name: %s", var_6_6, self._hopper_name)
	end

	local var_6_7 = fn
	local str_2 = "Starting SmartMatch with session_id: %s Hopper name: %s PreserveSessionMode: %s Ticket params: %s Timeout: %i"
	local var_6_9 = tostring(self._session_id)
	local _hopper_name = self._hopper_name
	local flag_3

	flag_3 = ALWAYS ~= PreserveSessionMode.ALWAYS or not "ALWAYS" or "NEVER"

	var_6_7(str_2, var_6_9, _hopper_name, flag_3, var_6_6, num)
	MultiplayerSession.start_smartmatch(self._session_id, self._hopper_name, num, ALWAYS, var_6_6)

	self._smartmatch_started = true
	self._state = "_check_smartmatch_result"
end

SmartMatch._check_smartmatch_result = function (self, arg_7_1)
	-- function 7
	if not self._ready then
		return
	end

	local start_smartmatch_result, var_7_1 = MultiplayerSession.start_smartmatch_result(self._session_id)

	if not (not self._ticket_id and self._ticket_id == start_smartmatch_result and start_smartmatch_result == "") then
		fn("Started smartmatch with ticket_id: %s", start_smartmatch_result)

		self._ticket_id = start_smartmatch_result
	end

	if not self._estimated_waiting_time then
		fn("[Start] Estimated waiting time: %s", var_7_1)

		self._estimated_waiting_time = var_7_1
	end

	local smartmatch_status = MultiplayerSession.smartmatch_status(self._session_id)
	local smartmatch_result, var_7_4, var_7_5 = MultiplayerSession.smartmatch_result(self._session_id)

	self._estimated_waiting_time = not (var_7_5 > 0) or not var_7_5 or self._estimated_waiting_time

	if self._smartmatch_status ~= smartmatch_status then
		if not flag then
			local var_7_6 = fn
			local str = "SmartMatch Status Changed from %s to %s"
			local var_7_8

			if not self._smartmatch_status then
				var_7_8 = tbl_4[self._smartmatch_status]

				if not var_7_8 then
					-- Nothing
				end
			end

			var_7_8 = "NONE"

			do
				local var_7_9
			end

			::label_7_0::

			if not smartmatch_status then
				var_7_9 = tbl_4[smartmatch_status]

				if not var_7_9 then
					-- Nothing
				end
			end

			var_7_9 = "NONE"

			::label_7_1::

			var_7_6(str, var_7_8, var_7_9)

			if smartmatch_result ~= "" then
				fn("Current session name: %s. Smartmatch session name: %s. Smartmatch session template: %s", self._session_name, smartmatch_result, var_7_4)
			end
		end

		self._smartmatch_status = smartmatch_status

		if self._smartmatch_status == SmartMatchStatus.FOUND then
			local flag_2 = smartmatch_result == self._session_name
			local var_7_11 = fn
			local str_2 = "Found session - Session name: %s %s Session template: %s"
			local var_7_13 = smartmatch_result
			local flag_3

			flag_3 = not flag_2 and "(My own session)" and ""

			var_7_11(str_2, var_7_13, flag_3, var_7_4)

			self._found_session_name = smartmatch_result
			self._found_session_template = var_7_4
			self._done = true
			self._failed = flag_2

			if not self._failed then
				fn("Smartmatch failed because: FOUND_SESSION == MY_SESSION")
			else
				fn("Smartmatch SUCCESS!")
			end

			self._state = "_smartmatch_done"
		elseif self._smartmatch_status == SmartMatchStatus.EXPIRED then
			self._done = true
			self._failed = true

			fn("Smartmatch failed because: TIMEOUT")

			self._state = "_smartmatch_done"
		end
	end
end

SmartMatch._smartmatch_done = function (arg_8_0, arg_8_1)
	-- function 8
	return
end

SmartMatch._convert_to_json = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0 = tbl[arg_9_1]
	local var_9_1 = tbl_3[arg_9_1]

	fassert(var_9_0, "[SmartMatch::_convert_to_json] No such hopper_name:  %s", arg_9_1)

	local str = ""

	for i, v in ipairs(var_9_0) do
		local var_9_3 = tbl_2[v]
		local var_9_4 = arg_9_2[v]

		fassert(var_9_4 or var_9_1[v], "[SmartMatch::_convert_to_json] Missing variable [%s] in params", v)

		if not var_9_4 then
			if var_9_3 == "number" then
				str = str .. string.format("%q:%i,", v, var_9_4)
			elseif var_9_3 == "string" then
				str = str .. string.format("%q:%q,", v, var_9_4)
			elseif var_9_3 == "collection" then
				str = str .. string.format("%q:[", v)

				for i_2, v_2 in ipairs(var_9_4) do
					if i_2 == 1 then
						str = str .. string.format("%q", tostring(v_2))
					else
						str = str .. string.format(",%q", tostring(v_2))
					end
				end

				str = str .. "],"
			end
		end
	end

	if str == "" then
		return
	else
		local sub = string.sub(str, 1, -2)

		print("Hopper name:", arg_9_1, "JSON_DATA:", string.format("{%s}", sub))

		return string.format("{%s}", sub)
	end
end

SmartMatch.update = function (self, arg_10_1)
	-- function 10
	self:_handle_smartmatch_session()
	self[self._state](self, arg_10_1)

	local _ready = self._ready

	_ready = not _ready and not self._done

	return _ready
end

SmartMatch.is_search_done = function (self)
	-- function 11
	return self._done
end

SmartMatch.results = function (self)
	-- function 12
	return self._found_session_name, self._found_session_template
end

SmartMatch.success = function (self)
	-- function 13
	return not self._failed
end

SmartMatch.destroy = function (self)
	-- function 14
	local tbl = {
		destroy_session = true,
		state = "_cleanup_ticket",
		user_id = self._user_id,
		session_id = self._session_id,
		hopper_name = self._hopper_name,
		session_name = self._session_name
	}

	Managers.account:add_session_to_cleanup(tbl)
end
