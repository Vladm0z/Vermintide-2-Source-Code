-- chunkname: @scripts/managers/backend/script_backend.win32.lua

ScriptBackend = class(ScriptBackend)
BackendSaveDataVersion = 30

local tbl = {}
local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {}

if not rawget(_G, "Backend") then
	tbl[Backend.CONNECTION_UNINITIALIZED] = "connection_uninitialized"
	tbl[Backend.CONNECTION_INITIALIZED] = "connection_initialized"
	tbl[Backend.CONNECTION_CONNECTING] = "connection_connecting"
	tbl[Backend.CONNECTION_CONNECTED] = "connection_connected"
	tbl[Backend.CONNECTION_WAITING_AUTH_TICKET] = "connection_waiting_auth_ticket"
	tbl[Backend.CONNECTION_AUTHENTICATING] = "connection_authenticating"
	tbl[Backend.CONNECTION_AUTHENTICATED] = "connection_authenticated"
	tbl[Backend.CONNECTION_DISCONNECTING] = "connection_disconnecting"
	tbl[Backend.CONNECTION_ENTITIES_LOADED] = "connection_entities_loaded"
	tbl[Backend.CONNECTION_ERROR] = "connection_error"
	tbl_2[Backend.CONNECTION_UNINITIALIZED] = {
		[Backend.CONNECTION_INITIALIZED] = true
	}
	tbl_2[Backend.CONNECTION_INITIALIZED] = {
		[Backend.CONNECTION_CONNECTING] = true,
		[Backend.CONNECTION_CONNECTED] = true
	}
	tbl_2[Backend.CONNECTION_CONNECTING] = {
		[Backend.CONNECTION_CONNECTED] = true
	}
	tbl_2[Backend.CONNECTION_CONNECTED] = {
		[Backend.CONNECTION_AUTHENTICATING] = true,
		[Backend.CONNECTION_AUTHENTICATED] = true,
		[Backend.CONNECTION_WAITING_AUTH_TICKET] = true
	}
	tbl_2[Backend.CONNECTION_WAITING_AUTH_TICKET] = {
		[Backend.CONNECTION_AUTHENTICATING] = true,
		[Backend.CONNECTION_AUTHENTICATED] = true
	}
	tbl_2[Backend.CONNECTION_AUTHENTICATING] = {
		[Backend.CONNECTION_AUTHENTICATED] = true
	}
	tbl_2[Backend.CONNECTION_AUTHENTICATED] = {
		[Backend.CONNECTION_ENTITIES_LOADED] = true
	}
	tbl_2[Backend.CONNECTION_ENTITIES_LOADED] = {}
	tbl_3[Backend.RES_OK] = "backend_res_ok"
	tbl_3[Backend.RES_UNKNOWN_ERR] = "backend_res_unknown_error"
	tbl_3[Backend.RES_INVALID_STATE] = "backend_res_invalid_state"
	tbl_3[Backend.RES_AUTH_IN_PROGRESS] = "backend_res_auth_in_progress"
	tbl_3[Backend.RES_INVALID_USER] = "backend_res_invalid_user"
	tbl_3[Backend.RES_HTTP_ERROR] = "backend_res_http_error"
	tbl_3[Backend.RES_DNS_ERROR] = "backend_res_dns_error"
	tbl_3[Backend.RES_INVALID_TRANSACTION] = "backend_res_invalid_transaction"
	tbl_3[Backend.RES_INVALID_ATTRIBUTE] = "backend_res_invalid_attribute"
	tbl_3[Backend.RES_NO_PENDING_DATA] = "backend_res_no_pending_data"
	tbl_3[Backend.RES_COMM_ERROR] = "backend_res_comm_error"
	tbl_3[Backend.RES_NO_SUCH_ENTITY] = "backend_res_no_such_entity"
	tbl_3[Backend.RES_NO_CHANGE] = "backend_res_no_change"
	tbl_3[Backend.RES_INVALID_ENTITY_ID] = "backend_res_invalid_entity_id"
	tbl_3[Backend.RES_ACTIVE_SESSION] = "backend_res_active_session"
	tbl_3[Backend.RES_NO_ACTIVE_SESSION] = "backend_res_no_active_session"
	tbl_3[Backend.RES_PARSE_ERROR] = "backend_res_parse_error"
	tbl_3[Backend.RES_TITLE_ID_DISABLED] = "backend_res_title_id_disabled"

	if not Backend.ENV_DEV then
		tbl_4[Backend.ENV_DEV] = "Dev"
		tbl_4[Backend.ENV_STAGE] = "Stage"
		tbl_4[Backend.ENV_PROD] = "Prod"
	end
end

local tbl_5 = {
	off = 0,
	verbose = 2,
	normal = 1
}

ScriptBackend.init = function (self)
	-- function 1
	local title_id = GameSettingsDevelopment.backend_settings.title_id
	local environment = GameSettingsDevelopment.backend_settings.environment

	print(string.format("[Backend] Creating backend with title id: %d, environment: %q", title_id, tbl_4[environment]))
	Backend.create(title_id, environment)

	self._backend = true

	self:refresh_log_level()

	self._dirty = true
	self._dirty_stats = true
	self._state = Backend.CONNECTION_UNINITIALIZED
	self._commits = {}
	self._commit_current_id = nil
	self._commit_queue_id = nil
	self._last_id = 0
end

local function fn(self, arg_2_1)
	-- function 2
	if not (not self and self.reason == Backend.ERR_OK) then
		local format = string.format
		local str = "%q failed with %d, %s"
		local var_2_2 = arg_2_1
		local reason = self.reason
		local details = self.details

		details = details or "nil"

		local var_2_5 = format(str, var_2_2, reason, details)

		print_error(var_2_5)

		return {
			reason = self.reason,
			details = self.details
		}
	end
end

ScriptBackend.update = function (self)
	-- function 3
	if not self._commit_current_id then
		self:_check_current_commit()
	end

	return (Backend.update())
end

ScriptBackend._update_state = function (self)
	-- function 4
	local state = Backend.state()
	local var_4_1 = tbl_2[self._state]

	if state ~= self._state then
		print("[Backend] Changed state from", tbl[self._state], "to", tbl[state])
	end

	local var_4_2

	if not (state == self._state or var_4_1[state]) then
		local check_for_errors = self:check_for_errors()

		if not check_for_errors then
			return check_for_errors
		end

		local var_4_4 = tbl[self._state]
		local var_4_5 = tbl[state]
		local var_4_6
		local var_4_7

		if self._state == Backend.CONNECTION_ENTITIES_LOADED then
			Crashify.print_exception("Backend", "Disconnected")

			var_4_7 = BACKEND_LUA_ERRORS.ERR_DISCONNECTED
		else
			var_4_7 = Backend.ERR_UNKNOWN
			var_4_6 = string.format("Wrong transition: Going from state %q to %q", var_4_4, var_4_5)
		end

		print("[Backend]", var_4_7, var_4_6)

		var_4_2 = {
			reason = var_4_7,
			details = var_4_6
		}
	end

	self._state = state

	return var_4_2
end

ScriptBackend.update_state = function (self)
	-- function 5
	return self:_update_state()
end

ScriptBackend.update_signin = function (self)
	-- function 6
	local _update_state = self:_update_state()

	if not _update_state then
		return _update_state
	end

	local _state = self._state
	local var_6_2

	if _state == Backend.CONNECTION_INITIALIZED then
		var_6_2 = fn(Backend.connect(), "Connect")
	end

	if _state == Backend.CONNECTION_CONNECTED then
		var_6_2 = fn(Backend.steam_auth(), "Auth")
	end

	if not (_state ~= Backend.CONNECTION_AUTHENTICATED or self._entities_requested) then
		Backend.load_entities()

		self._entities_requested = true
	end

	return var_6_2
end

ScriptBackend.authenticated = function (arg_7_0)
	-- function 7
	return Backend.state() == Backend.CONNECTION_ENTITIES_LOADED
end

ScriptBackend._refresh_stats = function (self)
	-- function 8
	if not (self._dirty_stats or self._stats) then
		local get_stats = BackendStats.get_stats(self._backend)
		local tbl = {}

		for k, v in pairs(get_stats) do
			tbl[v.key] = v.data
		end

		self._stats = get_stats
		self._nice_stats = tbl
		self._dirty_stats = false
	end
end

ScriptBackend.get_stats = function (self)
	-- function 9
	self:_refresh_stats()

	return self._nice_stats
end

ScriptBackend.set_stats = function (self, arg_10_1)
	-- function 10
	self:_refresh_stats()

	local clone = table.clone(arg_10_1)

	for k, v in pairs(arg_10_1) do
		for k_2, v_2 in pairs(self._stats) do
			if v_2.key == k then
				clone[k] = nil

				if v_2.data ~= v then
					fn(BackendStats.set_stat(k_2, k, v), "Set stat")
				end

				break
			end
		end
	end

	for k_3, v_3 in pairs(clone) do
		Crashify.print_exception("ScriptBackend", "Tried to set unregistered stat %s, value: %s", k_3, v_3)
	end

	self:commit()

	self._dirty_stats = true
end

ScriptBackend.check_for_errors = function (self)
	-- function 11
	local get_error = Backend.get_error()
	local get_error_2 = BackendSession.get_error()
	local var_11_2

	if not self._commit_error then
		var_11_2 = {
			reason = Backend.ERR_COMMIT
		}
		self._commit_error = nil
	end

	return get_error or get_error_2 or var_11_2
end

ScriptBackend._new_id = function (self)
	-- function 12
	self._last_id = self._last_id + 1

	return self._last_id
end

ScriptBackend._check_current_commit = function (self)
	-- function 13
	local commit_status = self:commit_status(self._commit_current_id)

	if commit_status ~= Backend.COMMIT_WAITING then
		local var_13_1 = self._commits[self._commit_current_id]

		print("commit status", commit_status, var_13_1.id)

		self._commit_current_id = nil

		if commit_status == Backend.COMMIT_SUCCESS then
			if not self._commit_queue_id then
				self:commit(true)
			end
		elseif commit_status == Backend.COMMIT_ERROR then
			self._commit_error = true
			self._commit_queue_id = nil
		end
	end
end

ScriptBackend._commit_internal = function (self, arg_14_1)
	-- function 14
	local commit, var_14_1 = Backend.commit()
	local flag = arg_14_1 or self:_new_id()
	local tbl = {
		id = commit,
		timeout = os.time() + 15,
		result = var_14_1
	}

	self._commits[flag] = tbl
	self._commit_current_id = flag

	print(string.format("Commiting with %d:%d result: %d", flag, commit, var_14_1))

	return flag
end

ScriptBackend._queue_commit = function (self)
	-- function 15
	if not self._commit_queue_id then
		self._commit_queue_id = self:_new_id()
	end

	return self._commit_queue_id
end

ScriptBackend.commit = function (self, arg_16_1)
	-- function 16
	print("Trying to commit", arg_16_1, self._commit_current_id, self._commit_queue_id)

	if not self._commit_current_id then
		fassert(not arg_16_1, "Internal backend commit error, current commit exists")

		return self:_queue_commit()
	else
		local _commit_internal = self:_commit_internal(self._commit_queue_id)

		self._commit_queue_id = nil

		return _commit_internal
	end
end

ScriptBackend.commit_status = function (self, arg_17_1)
	-- function 17
	fassert(arg_17_1, "Querying status for commit_id %s", tostring(arg_17_1))

	if arg_17_1 == self._commit_queue_id then
		return Backend.COMMIT_WAITING
	end

	local var_17_0 = self._commits[arg_17_1]

	fassert(var_17_0, "No commit with id %d", arg_17_1)

	if var_17_0.timeout < os.time() then
		print(var_17_0.timeout, os.time())

		local format = string.format("Commit timed out %d:%d", arg_17_1, var_17_0.id)

		Application.warning(format)

		return Backend.COMMIT_ERROR
	end

	if var_17_0.result ~= Backend.COMMIT_WAITING then
		return var_17_0.result
	elseif not var_17_0.id then
		local query_commit = Backend.query_commit(var_17_0.id)

		if query_commit == Backend.COMMIT_SUCCESS then
			Managers.backend:get_interface("items"):__dirtify()
		end

		var_17_0.result = query_commit

		return query_commit
	else
		return Backend.COMMIT_WAITING
	end
end

ScriptBackend.destroy = function (arg_18_0)
	-- function 18
	print("[Backend] ScriptBackend destroy")
	Backend.destroy()
end

ScriptBackend.backend_object = function (self)
	-- function 19
	error("no backend object in lua anymore")

	return self._backend
end

ScriptBackend.refresh_log_level = function (arg_20_0)
	-- function 20
	local backend_logging_level = script_data.backend_logging_level

	backend_logging_level = backend_logging_level or "verbose"

	local var_20_1 = tbl_5[backend_logging_level]

	Backend.set_log_level(var_20_1)
end

ScriptBackend.wait_for_shutdown = function (self, arg_21_1)
	-- function 21
	local num = os.time() + arg_21_1

	while Backend.active_requests() > 0 or not self._commit_queue_id do
		local update = self:update()

		if not (update or not (num < os.time())) then
			if not update then
				print("wait for shutdown has enountered error")
			else
				print("wait for shutdown has timed out", Backend.active_requests(), self._commit_queue_id)
			end

			return
		end
	end

	print("disconnecting backend")
	Backend.disconnect()

	while not (self:update() or not (Backend.active_requests() > 0) or not (num > os.time())) do
		-- Nothing
	end

	if num < os.time() then
		print("backend disconnect has timed out")
	end
end
