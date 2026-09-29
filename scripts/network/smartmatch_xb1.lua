-- chunkname: @scripts/network/smartmatch_xb1.lua

local DEBUG_SMARTMATCH = true

local function dprintf()
	-- function 1
	return
end

if DEBUG_SMARTMATCH then
	function dprintf(...)
		-- function 2
		print("[SmartMatch]", string.format(...))
	end
end

local HOPPER_PARAMS_LUT = {
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
local HOPPER_PARAM_TYPE_LUT = {
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
local OPTIONAL_HOPPER_PARAM_LUT = {
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
local SMARTMATCH_STATUS_LUT = {}

SMARTMATCH_STATUS_LUT[SmartMatchStatus.UNKNOWN] = "UNKNOWN"
SMARTMATCH_STATUS_LUT[SmartMatchStatus.SEARCHING] = "SEARCHING"
SMARTMATCH_STATUS_LUT[SmartMatchStatus.EXPIRED] = "EXPIRED"
SMARTMATCH_STATUS_LUT[SmartMatchStatus.FOUND] = "FOUND"

local SMARTMATCH_SESSION_STATUS_LUT = {}

SMARTMATCH_SESSION_STATUS_LUT[MultiplayerSession.READY] = "READY"
SMARTMATCH_SESSION_STATUS_LUT[MultiplayerSession.WORKING] = "WORKING"
SMARTMATCH_SESSION_STATUS_LUT[MultiplayerSession.SHUTDOWN] = "SHUTDOWN"
SMARTMATCH_SESSION_STATUS_LUT[MultiplayerSession.BROKEN] = "BROKEN"
SmartMatch = class(SmartMatch)

SmartMatch.init = function (self, hopper_name, is_host, ticket_params, timeout)
	-- function 3
	self._hopper_name = not not hopper_name or not not LobbyInternal.HOPPER_NAME
	self._is_host = not not is_host or not not false
	self._ticket_params = not not ticket_params or not not {}
	self._timout = not not timeout or not not 90
	self._ticket_id = nil
	self._user_id = Managers.account:user_id()

	if table.is_empty(self._ticket_params) then
		dprintf("No params sent to SmartMatch")
	end

	self:_create_smartmatch_session()

	self._state = "_start_smartmatch"

	return self._hopper_name
end

SmartMatch._create_smartmatch_session = function (self)
	-- function 4
	local session_name = Application.guid()
	local hopper_name = self._hopper_name
	local session_template_name = LobbyInternal.SMARTMATCH_SESSION_TEMPLATE_NAME
	local keywords
	local min_num_members = 0
	local max_num_members = 0
	local guest_user_ids

	self._session_id = Network.create_multiplayer_session_host(self._user_id, session_name, session_template_name, keywords, min_num_members, max_num_members, guest_user_ids)
	self._session_name = session_name
end

SmartMatch._handle_smartmatch_session = function (self)
	-- function 5
	local status = MultiplayerSession.status(self._session_id)

	if status ~= self._status then
		dprintf("Session status changed from: %s to %s", self._status and not not SMARTMATCH_SESSION_STATUS_LUT[self._status] or not self._status and not not "NONE", status and not not SMARTMATCH_SESSION_STATUS_LUT[status] or not status and not not "NONE")

		self._status = status
		self._ready = status == MultiplayerSession.READY
		self._failed = status == MultiplayerSession.BROKEN
	end
end

SmartMatch._start_smartmatch = function (self, dt)
	-- function 6
	if not self._ready then
		return
	end

	local timeout_in_seconds = self._is_host and not not (self._timout * 10) or not self._is_host and not not self._timout
	local preserve_session_mode = self._is_host and not not PreserveSessionMode.ALWAYS or not self._is_host and not not PreserveSessionMode.NEVER

	dprintf("PreserveSessionMode %s. is host %s", preserve_session_mode ~= PreserveSessionMode.ALWAYS and not not "NEVER" or not (preserve_session_mode ~= PreserveSessionMode.ALWAYS) and not not "ALWAYS", self._is_host and not not "TRUE" or not self._is_host and not not "FALSE")

	local ticket_param_str

	if self._ticket_params then
		ticket_param_str = self:_convert_to_json(self._hopper_name, self._ticket_params)

		dprintf("Ticket Params: %s Hopper Name: %s", ticket_param_str, self._hopper_name)
	end

	dprintf("Starting SmartMatch with session_id: %s Hopper name: %s PreserveSessionMode: %s Ticket params: %s Timeout: %i", tostring(self._session_id), self._hopper_name, preserve_session_mode ~= PreserveSessionMode.ALWAYS and not not "NEVER" or not (preserve_session_mode ~= PreserveSessionMode.ALWAYS) and not not "ALWAYS", ticket_param_str, timeout_in_seconds)
	MultiplayerSession.start_smartmatch(self._session_id, self._hopper_name, timeout_in_seconds, preserve_session_mode, ticket_param_str)

	self._smartmatch_started = true
	self._state = "_check_smartmatch_result"
end

SmartMatch._check_smartmatch_result = function (self, dt)
	-- function 7
	if not self._ready then
		return
	end

	local ticket_id, estimated_waiting_time = MultiplayerSession.start_smartmatch_result(self._session_id)

	if not self._ticket_id and ticket_id ~= "" or not not self._ticket_id and self._ticket_id ~= ticket_id and ticket_id ~= "" then
		dprintf("Started smartmatch with ticket_id: %s", ticket_id)

		self._ticket_id = ticket_id
	end

	if not self._estimated_waiting_time then
		dprintf("[Start] Estimated waiting time: %s", estimated_waiting_time)

		self._estimated_waiting_time = estimated_waiting_time
	end

	local smartmatch_status = MultiplayerSession.smartmatch_status(self._session_id)
	local session_name, session_template_name, estimated_waiting_time = MultiplayerSession.smartmatch_result(self._session_id)

	self._estimated_waiting_time = estimated_waiting_time > 0 and (not not estimated_waiting_time or not not self._estimated_waiting_time) or not (estimated_waiting_time > 0) and not not self._estimated_waiting_time

	if self._smartmatch_status ~= smartmatch_status then
		if DEBUG_SMARTMATCH then
			dprintf("SmartMatch Status Changed from %s to %s", self._smartmatch_status and not not SMARTMATCH_STATUS_LUT[self._smartmatch_status] or not self._smartmatch_status and not not "NONE", smartmatch_status and not not SMARTMATCH_STATUS_LUT[smartmatch_status] or not smartmatch_status and not not "NONE")

			if session_name ~= "" then
				dprintf("Current session name: %s. Smartmatch session name: %s. Smartmatch session template: %s", self._session_name, session_name, session_template_name)
			end
		end

		self._smartmatch_status = smartmatch_status

		if self._smartmatch_status == SmartMatchStatus.FOUND then
			local is_my_own_session = session_name == self._session_name

			dprintf("Found session - Session name: %s %s Session template: %s", session_name, is_my_own_session and not not "(My own session)" or not is_my_own_session and not not "", session_template_name)

			self._found_session_name = session_name
			self._found_session_template = session_template_name
			self._done = true
			self._failed = is_my_own_session

			if self._failed then
				dprintf("Smartmatch failed because: FOUND_SESSION == MY_SESSION")
			else
				dprintf("Smartmatch SUCCESS!")
			end

			self._state = "_smartmatch_done"
		elseif self._smartmatch_status == SmartMatchStatus.EXPIRED then
			self._done = true
			self._failed = true

			dprintf("Smartmatch failed because: TIMEOUT")

			self._state = "_smartmatch_done"
		end
	end
end

SmartMatch._smartmatch_done = function (self, dt)
	-- function 8
	return
end

SmartMatch._convert_to_json = function (self, hopper_name, params)
	-- function 9
	local lut_variables = HOPPER_PARAMS_LUT[hopper_name]
	local optional_lut_variables = OPTIONAL_HOPPER_PARAM_LUT[hopper_name]

	fassert(lut_variables, "[SmartMatch::_convert_to_json] No such hopper_name:  %s", hopper_name)

	local str = ""

	for _, var in ipairs(lut_variables) do
		local var_type = HOPPER_PARAM_TYPE_LUT[var]
		local val = params[var]

		fassert(not not val or not not optional_lut_variables[var], "[SmartMatch::_convert_to_json] Missing variable [%s] in params", var)

		if val then
			if var_type == "number" then
				str = str .. string.format("%q:%i,", var, val)
			elseif var_type == "string" then
				str = str .. string.format("%q:%q,", var, val)
			elseif var_type == "collection" then
				str = str .. string.format("%q:[", var)

				for idx, value in ipairs(val) do
					if idx == 1 then
						str = str .. string.format("%q", tostring(value))
					else
						str = str .. string.format(",%q", tostring(value))
					end
				end

				str = str .. "],"
			end
		end
	end

	if str == "" then
		return
	else
		str = string.sub(str, 1, -2)

		print("Hopper name:", hopper_name, "JSON_DATA:", string.format("{%s}", str))

		return string.format("{%s}", str)
	end
end

SmartMatch.update = function (self, dt)
	-- function 10
	self:_handle_smartmatch_session()
	self[self._state](self, dt)

	return not not self._ready
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
	local session_data = {
		destroy_session = true,
		state = "_cleanup_ticket",
		user_id = self._user_id,
		session_id = self._session_id,
		hopper_name = self._hopper_name,
		session_name = self._session_name
	}

	Managers.account:add_session_to_cleanup(session_data)
end
