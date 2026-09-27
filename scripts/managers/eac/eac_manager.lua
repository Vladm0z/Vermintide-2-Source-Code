-- chunkname: @scripts/managers/eac/eac_manager.lua

local enum = table.enum("untrusted", "trusted", "banned", "undetermined")
local num = 15

local function fn(...)
	-- function 1
	print("[EACManager] " .. string.format(...))
end

EacManager = class(EacManager)
USE_EOS = true

local function fn_2()
	-- function 2
	if not (IS_WINDOWS or DEDICATED_SERVER) then
		return false, "unsupported platform: " .. tostring(PLATFORM)
	end

	if not MODDED_REALM then
		return false, "in modded realm"
	end

	if not USE_EOS then
		if not rawget(_G, "EOS_EAC") then
			return false, "EOS_EAC not available"
		end

		if not DEDICATED_SERVER then
			local has_eac_server = EOS_EAC.has_eac_server()

			assert(has_eac_server, "Dedicated server is running without EAC running in server mode")

			return true
		end

		return EOS_EAC.has_eac_client(), "EAC client not available"
	else
		if not rawget(_G, "EAC") then
			return false, "EAC not available"
		end

		return true
	end
end

EacManager.init = function (self)
	-- function 3
	local var_3_0, var_3_1 = fn_2()

	if not var_3_0 then
		fn("EAC enabled")
	else
		fn("Disabling EAC due to reason: %s", var_3_1)
	end

	self._peer_data = {}
	self._eac_supported = var_3_0
	self._host_peer_id = nil
	self._local_role = nil
	self._network_model = nil
	self._user_id = "untrusted"
	self._suppress_popup = not var_3_0
	self._suppress_panel = not var_3_0
	self._popup_id = nil
	self._indicator_offset = 0
end

EacManager.challenge_response = function (self, arg_4_1)
	-- function 4
	if not self._eac_supported then
		if not USE_EOS then
			return EOS_EAC.challenge_response(arg_4_1)
		else
			return EAC.challenge_response(arg_4_1)
		end
	end

	return nil
end

EacManager.is_trusted = function (self)
	-- function 5
	if not self._eac_supported then
		if not USE_EOS then
			if not EOS_EAC.has_eac_server() then
				return true
			end

			return not EOS_EAC.get_integrity_violation()
		else
			return EAC.state() == enum.trusted
		end
	end

	return false
end

EacManager.before_join = function (self, arg_6_1)
	-- function 6
	assert(self._local_role == nil, "Method called in incompatible state")
	assert(arg_6_1 == "client_server" or arg_6_1 == "peer_to_peer", "Invalid network_model argument")

	self._local_role = "client"
	self._network_model = arg_6_1

	if not self._eac_supported then
		if not USE_EOS then
			EOS_EAC.begin_session(arg_6_1)
		else
			EAC.before_join()
		end
	end
end

EacManager.after_leave = function (self)
	-- function 7
	assert(self._local_role == "client", "Method called in incompatible state")

	if not self._eac_supported then
		if not USE_EOS then
			EOS_EAC.end_session()
			self:_pump_eos_actions()
		else
			EAC.after_leave()
		end
	end

	local _host_peer_id = self._host_peer_id

	if not _host_peer_id then
		self._peer_data[_host_peer_id] = nil
	else
		fn("Left EAC session without setting the host.")
	end

	self._local_role = nil
	self._session_mode = nil
	self._host_peer_id = nil
end

EacManager.set_host = function (self, arg_8_1)
	-- function 8
	assert(self._local_role == "client", "Method called in incompatible state")
	assert(self._host_peer_id == nil, "Host was already set and cannot be changed")

	local var_8_0 = PEER_ID_TO_CHANNEL[arg_8_1]

	assert(var_8_0, "Must already be connected")

	self._host_peer_id = arg_8_1

	local tbl = {
		user_id = false,
		peer_id = arg_8_1,
		channel_id = var_8_0
	}

	self._peer_data[arg_8_1] = tbl

	if not self._eac_supported then
		if not USE_EOS then
			if self._network_model == "peer_to_peer" then
				self:_initiate_handshake(arg_8_1)
			elseif self._network_model == "client_server" then
				EOS_EAC.set_server_peer_id(arg_8_1)

				tbl.timeout_t = math.huge
				tbl.is_server = true
			end
		else
			EAC.set_host(var_8_0)
			EAC.validate_host()
		end
	else
		self:_initiate_handshake(arg_8_1)
	end
end

EacManager.check_host = function (self)
	-- function 9
	assert(self._local_role == "client", "Method called in incompatible state")
	assert(self._host_peer_id, "Cannot check the host before it has been set.")

	local var_9_0
	local var_9_1

	if not self._eac_supported then
		if not USE_EOS then
			var_9_0, var_9_1 = self:_check_peer(self._host_peer_id)
		else
			local state = EAC.state(self._host_peer_id)
			local state_2 = EAC.state()

			var_9_0, var_9_1 = self:_check_states_compatible(state, state_2)
		end
	else
		var_9_0, var_9_1 = self:_check_peer(self._host_peer_id)
	end

	return var_9_0, var_9_1
end

EacManager._check_peer = function (self, arg_10_1)
	-- function 10
	local var_10_0 = self._peer_data[arg_10_1]

	if not var_10_0.untrusted then
		return true, not self._eac_supported
	end

	if not var_10_0.is_server then
		return true, true
	end

	if not var_10_0.user_id then
		return false, true
	end

	if not (not USE_EOS and not self._eac_supported and EOS_EAC.peer_status(arg_10_1) ~= EOS_EAC_ACCCAS.RemoteAuthComplete) then
		return true, true
	end

	return false, true
end

EacManager._check_states_compatible = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	if not (arg_11_1 == enum.banned or arg_11_2 ~= enum.banned) then
		return true, false
	end

	if not (arg_11_1 == enum.undetermined or arg_11_2 ~= enum.undetermined) then
		return false, true
	end

	local flag = arg_11_1 == arg_11_2

	return true, flag
end

EacManager.is_initialized = function (self)
	-- function 12
	if not self._eac_supported then
		if not USE_EOS then
			return self._eos_auth_complete, self._eos_auth_error
		else
			if not EAC.is_initialized() then
				return false, nil
			end

			local initialization_error, var_12_1 = EAC.initialization_error()

			if not var_12_1 then
				return true, var_12_1
			end
		end
	end

	return true, nil
end

EacManager.server_create = function (self, arg_13_1)
	-- function 13
	assert(self._local_role == nil, "Method called in incompatible state")
	assert(arg_13_1 ~= nil, "Must provide a server_name")

	self._local_role = "server"

	if not self._eac_supported then
		if not USE_EOS then
			local flag

			flag = not EOS_EAC.has_eac_server() and "client_server" and "peer_to_peer"

			EOS_EAC.begin_session(flag)
		else
			assert(self._eac_server == nil, "An EAC server already exists")

			self._eac_server = EACServer.create(arg_13_1)
		end
	end

	fn("Created EACServer with name %q", arg_13_1)
end

EacManager.server_destroy = function (self)
	-- function 14
	assert(self._local_role == "server", "Method called in incompatible state")

	self._local_role = nil

	if not self._eac_supported then
		if not USE_EOS then
			EOS_EAC.end_session()
			self:_pump_eos_actions()
		else
			EACServer.destroy(self._eac_server)

			self._eac_server = nil
		end
	end

	fn("Destroyed EACServer (%d registered peers)", table.size(self._peer_data))
	table.clear(self._peer_data)
end

EacManager.server_add_peer = function (self, arg_15_1)
	-- function 15
	assert(self._local_role == "server", "Method called in incompatible state")
	fassert(not self._peer_data[arg_15_1], "Peer %q was already added", arg_15_1)
	fn("Adding peer %s", arg_15_1)

	local var_15_0 = PEER_ID_TO_CHANNEL[arg_15_1]

	assert(var_15_0, "Must already be connected")

	local tbl = {
		peer_id = arg_15_1,
		channel_id = var_15_0
	}

	self._peer_data[arg_15_1] = tbl

	if not self._eac_supported then
		if not USE_EOS then
			self:_initiate_handshake(arg_15_1)
		else
			EACServer.add_peer(self._eac_server, var_15_0)
		end
	else
		self:_initiate_handshake(arg_15_1)
	end
end

EacManager.server_remove_peer = function (self, arg_16_1)
	-- function 16
	assert(self._local_role == "server", "Method called in incompatible state")
	fassert(self._peer_data[arg_16_1], "Peer %q was already removed", arg_16_1)
	fn("Removing peer %s", arg_16_1)

	if not self._eac_supported then
		if not USE_EOS then
			if not self._peer_data[arg_16_1].added then
				EOS_EAC.remove_peer(arg_16_1)
			end
		else
			local var_16_0 = PEER_ID_TO_CHANNEL[arg_16_1]

			EACServer.remove_peer(self._eac_server, var_16_0)
		end
	end

	self._peer_data[arg_16_1] = nil
end

EacManager.server_check_peer = function (self, arg_17_1)
	-- function 17
	if arg_17_1 == Network.peer_id() then
		return true, true
	end

	local var_17_0
	local var_17_1

	if not self._eac_supported then
		if not USE_EOS then
			var_17_0, var_17_1 = self:_check_peer(arg_17_1)
		else
			local _eac_server = self._eac_server
			local state = EACServer.state(_eac_server, Network.peer_id())
			local state_2 = EACServer.state(_eac_server, arg_17_1)

			var_17_0, var_17_1 = self:_check_states_compatible(state, state_2)
		end
	else
		var_17_0, var_17_1 = self:_check_peer(arg_17_1)
	end

	return var_17_0, var_17_1
end

EacManager.update = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not self._eac_server then
		EACServer.update(self._eac_server)
	end

	self:_handle_eos(arg_18_2)

	if not IS_WINDOWS then
		self:_handle_violations()
		self:_handle_popups()
	end
end

EacManager.register_network_event_delegate = function (self, arg_19_1)
	-- function 19
	arg_19_1:register(self, "rpc_eac_handshake_request", "rpc_eac_handshake_reply")

	self._network_event_delegate = arg_19_1
end

EacManager.unregister_network_event_delegate = function (self)
	-- function 20
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

EacManager._initiate_handshake = function (self, arg_21_1)
	-- function 21
	local var_21_0 = self._peer_data[arg_21_1]

	RPC.rpc_eac_handshake_request(var_21_0.channel_id)

	var_21_0.timeout_t = Managers.time:time("main") + num
	var_21_0.untrusted = false
end

EacManager.rpc_eac_handshake_request = function (self, arg_22_1)
	-- function 22
	local _user_id = self._user_id

	RPC.rpc_eac_handshake_reply(arg_22_1, _user_id)
end

EacManager.rpc_eac_handshake_reply = function (self, arg_23_1, arg_23_2)
	-- function 23
	local var_23_0 = CHANNEL_TO_PEER_ID[arg_23_1]
	local var_23_1 = self._peer_data[var_23_0]

	if not var_23_1 then
		fn("Ignoring handshake reply from unknown peer %s", var_23_0)

		return
	end

	if not var_23_1.untrusted then
		fn("Ignoring handshake reply from already untrusted peer %s", var_23_0)

		return
	end

	if not var_23_1.added then
		fn("Ignoring handshake reply from already added peer %s", var_23_0)

		return
	end

	if arg_23_2 == "untrusted" then
		var_23_1.untrusted = true
	else
		var_23_1.user_id = arg_23_2
		var_23_1.timeout_t = math.huge

		if not self._eac_supported and not USE_EOS then
			EOS_EAC.add_peer(var_23_0, arg_23_2)

			var_23_1.added = true
		end
	end
end

EacManager._pump_eos_actions = function (self)
	-- function 24
	while not EOS_EAC.has_eac_action() do
		local next_eac_action = EOS_EAC.next_eac_action()
		local find = table.find(EOS_EAC_ACCCA, next_eac_action.action)

		find = find or "?"

		local find_2 = table.find(EOS_EAC_ACCCAR, next_eac_action.reason)

		find_2 = find_2 or "?"

		fn("Got action { action=%d %q, reason=%d %q, details=%q, peer=%q }", next_eac_action.action, find, next_eac_action.reason, find_2, next_eac_action.details, next_eac_action.peer)

		local var_24_3 = self._peer_data[next_eac_action.peer]

		if not var_24_3 then
			if next_eac_action.action == EOS_EAC_ACCCA.RemovePlayer then
				var_24_3.untrusted = true
			else
				fn("Ignored action because it was unknown")
			end
		else
			fn("Ignored action because peer %q is not registed", next_eac_action.peer)
		end
	end
end

local num_2 = 5
local num_3 = 2
local tbl = {
	init = function (self, arg_25_1)
		-- function 25
		fn("Retrieving Steam auth session ticket...")

		self._auth_retries = 0

		return "retrieve_ticket"
	end,
	retrieve_ticket = function (self, arg_26_1)
		-- function 26
		local retrieve_auth_session_ticket = Steam.retrieve_auth_session_ticket("epiconlineservices")

		if not retrieve_auth_session_ticket then
			self._steam_ticket_job = retrieve_auth_session_ticket

			return "poll_ticket"
		end

		self._auth_retries = self._auth_retries + 1

		if self._auth_retries > num_3 then
			fn("Failed to retrieve auth session ticket. Exceded max %d retry attempt(s).", num_3)

			self._eos_auth_complete = true
			self._eos_auth_error = Localize("backend_err_auth_steam")
		end

		self._auth_retry_t = arg_26_1 + num_2

		return "retrying_retrieve_ticket"
	end,
	retrying_retrieve_ticket = function (self, arg_27_1)
		-- function 27
		if arg_27_1 >= self._auth_retry_t then
			return "retrieve_ticket"
		end
	end,
	poll_ticket = function (self, arg_28_1)
		-- function 28
		local poll_auth_session_ticket = Steam.poll_auth_session_ticket(self._steam_ticket_job)

		if not poll_auth_session_ticket then
			self._steam_ticket_job = nil
			self._auth_session_ticket = poll_auth_session_ticket

			return "start_authenticate"
		end
	end,
	start_authenticate = function (self, arg_29_1)
		-- function 29
		fn("Authenticating with Steam as an identity provider...")
		EOS_EAC.authenticate_with_steam(self._auth_session_ticket)

		self._auth_session_ticket = nil

		return "poll_authenticate"
	end,
	poll_authenticate = function (self, arg_30_1)
		-- function 30
		local poll_authenticate_status, var_30_1 = EOS_EAC.poll_authenticate_status()

		if poll_authenticate_status == "in_flight" then
			return
		end

		if poll_authenticate_status == "success" then
			self._user_id = EOS_EAC.user_id()
			self._eos_auth_error = nil
		else
			local format = string.format
			local str = "EOS auth status=%s, result=%s"
			local var_30_4 = poll_authenticate_status
			local find = table.find(EOS_Result, var_30_1)

			find = find or "?"
			self._eos_auth_error = format(str, var_30_4, find)
		end

		self._eos_auth_complete = true

		local var_30_6 = fn
		local str_2 = "Login complete. Error: %s"
		local _eos_auth_error = self._eos_auth_error

		_eos_auth_error = _eos_auth_error or "none"

		var_30_6(str_2, _eos_auth_error)

		return "poll_valid"
	end,
	poll_valid = function (arg_31_0, arg_31_1)
		-- function 31
		if EOS_EAC.poll_authenticate_status() == "expired" then
			fn("Refreshing user id ...")

			return "init"
		end
	end
}

EacManager._handle_eos = function (self, arg_32_1)
	-- function 32
	if not (not USE_EOS and self._eac_supported) then
		return
	end

	if not DEDICATED_SERVER then
		local _auth_state = self._auth_state

		_auth_state = _auth_state or "init"

		local var_32_1 = tbl[_auth_state](self, arg_32_1)

		if not var_32_1 then
			self._auth_state = var_32_1
		end

		if not self._user_id then
			return
		end
	end

	self:_pump_eos_actions()

	for k, v in pairs(self._peer_data) do
		if arg_32_1 > v.timeout_t then
			v.untrusted = true
		end
	end
end

local tbl_2 = {}

if not USE_EOS then
	tbl_2.IntegrityCatalogNotFound = true
	tbl_2.IntegrityCatalogError = true
	tbl_2.IntegrityCatalogMissingMainExecutable = true
	tbl_2.GameFileMismatch = true
	tbl_2.RequiredGameFileNotFound = true
	tbl_2.UnknownGameFileForbidden = true
else
	tbl_2.hash_catalogue_file_not_found = true
	tbl_2.hash_catalogue_error = true
	tbl_2.unknown_game_file_version = true
	tbl_2.required_game_file_not_found = true
end

EacManager._handle_violations = function (self)
	-- function 33
	if not self._eac_violation_type then
		return
	end

	if not USE_EOS and not rawget(_G, "EOS_EAC") then
		local var_33_0
		local var_33_1

		if not EOS_EAC.has_eac_client() then
			var_33_0, var_33_1 = "NO_BOOTSTRAPPER", "NO_BOOTSTRAPPER"
		elseif not self._eos_auth_error then
			var_33_0, var_33_1 = "AUTH_ERROR", self._eos_auth_error
		else
			var_33_0, var_33_1 = EOS_EAC.get_integrity_violation()
			var_33_0 = not var_33_0 and table.find(EOS_EAC_ACCVT, var_33_0) and "UNKNOWN"
		end

		if not var_33_0 then
			local str = "{#color(193,91,36)}"
			local str_2 = "{#color(255,255,255)}: "
			local str_3 = "{#reset()}"

			self._eac_violation_message = str .. Localize("eac_state") .. str_2 .. Localize("eac_state_untrusted") .. "\n" .. str .. Localize("eac_violation_type") .. str_2 .. var_33_0 .. "\n" .. str .. Localize("eac_cause") .. str_2 .. var_33_1 .. "\n" .. str_3 .. Localize("eac_untrusted_explanation")
			self._eac_violation_type = var_33_0
		end
	elseif not rawget(_G, "EAC") then
		local state, var_33_6, var_33_7, var_33_8 = EAC.state()

		if not (state == enum.untrusted or state ~= enum.banned) then
			local str_4 = "{#color(193,91,36)}"
			local str_5 = "{#color(255,255,255)}: "
			local str_6 = "{#reset()}"
			local var_33_12 = str_4
			local var_33_13 = Localize("eac_state")
			local var_33_14 = str_5
			local var_33_15 = Localize("eac_state_untrusted")
			local str_7 = "\n"
			local var_33_17 = str_4
			local var_33_18 = Localize("eac_violation_type")
			local var_33_19 = str_5
			local var_33_20 = var_33_8
			local str_8 = "\n"
			local var_33_22 = str_4
			local var_33_23 = Localize("eac_cause")
			local var_33_24 = str_5
			local var_33_25 = var_33_7
			local str_9 = "\n"
			local var_33_27 = str_6
			local Localize = Localize
			local flag

			flag = state ~= enum.banned or not "eac_banned_explanation" or "eac_untrusted_explanation"
			self._eac_violation_message = var_33_12 .. var_33_13 .. var_33_14 .. var_33_15 .. str_7 .. var_33_17 .. var_33_18 .. var_33_19 .. var_33_20 .. str_8 .. var_33_22 .. var_33_23 .. var_33_24 .. var_33_25 .. str_9 .. var_33_27 .. Localize(flag)
			self._eac_violation_type = var_33_8
		end
	end

	if not self._eac_violation_type then
		Crashify.print_exception("EAC", "Integrity violation: %s", self._eac_violation_type)
	end
end

EacManager._handle_popups = function (self)
	-- function 34
	local popup = Managers.popup

	if not (self._popup_id == nil or popup:query_result(self._popup_id) ~= "quit") then
		self._popup_id = nil

		Application.quit()
	end

	if not self._suppress_popup then
		return
	end

	if not tbl_2[self._eac_violation_type] then
		return
	end

	local var_34_1 = Localize("eac_file_corruption_detected")
	local var_34_2 = Localize("eac_file_corruption_topic")
	local var_34_3 = Localize("menu_quit")

	self._popup_id = popup:queue_popup(var_34_1, var_34_2, "quit", var_34_3)
	self._suppress_popup = true
end

EacManager.draw_panel = function (self, arg_35_1, arg_35_2)
	-- function 35
	local _eac_violation_message = self._eac_violation_message

	if not _eac_violation_message and not self._suppress_panel then
		return
	end

	local Vector2 = Vector2
	local Vector3 = Vector3
	local Color = Color
	local max = math.max(RESOLUTION_LOOKUP.scale, 0.5)
	local var_35_5 = Vector2(RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h)
	local str = "materials/fonts/arial"
	local num = 14 * max
	local num_2 = 1.1 * num
	local var_35_9 = Color(192, 91, 36)
	local var_35_10 = Color(200, 0, 0, 0)
	local var_35_11 = Color(180, 180, 180)
	local num_3 = 500 * max
	local num_4 = 1 * max
	local num_5 = Vector2(15, 10) * max
	local num_6 = Vector2(40, 20) * max
	local num_7 = 995
	local word_wrap = Gui.word_wrap(arg_35_1, _eac_violation_message, str, num, num_3, " ", "_-+&/", "\n", true, Gui.FormatDirectives)
	local num_8 = 2 * num_5 + Vector2(num_3, #word_wrap * num_2)
	local num_9 = var_35_5 - num_8 - num_6 + Vector3(0, 0, num_7)

	Gui.rect(arg_35_1, num_9, num_8, var_35_10)
	Gui.rect(arg_35_1, num_9 + Vector3(0, 0, 1), Vector2(num_4, num_8.y), var_35_9)
	Gui.rect(arg_35_1, num_9 + Vector3(0, 0, 1), Vector2(num_8.x, num_4), var_35_9)
	Gui.rect(arg_35_1, num_9 + Vector3(0, num_8.y, 1), Vector2(num_8.x, -num_4), var_35_9)
	Gui.rect(arg_35_1, num_9 + Vector3(num_8.x, 0, 1), Vector2(-num_4, num_8.y), var_35_9)

	local num_10 = num_9 + num_5 + Vector3(0, 0.18 * num, 2)

	for i = #word_wrap, 1, -1 do
		Gui.text(arg_35_1, word_wrap[i], str, num, nil, num_10, var_35_11, Gui.FormatDirectives)

		num_10.y = num_10.y + num_2
	end
end

EacManager.eac_ready_locally = function (self)
	-- function 36
	return not not self._local_role
end
