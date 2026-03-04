-- chunkname: @scripts/managers/backend/script_backend.win32.lua

ScriptBackend = class(ScriptBackend)
BackendSaveDataVersion = 30

local var_0_0 = {}
local var_0_1 = {}
local var_0_2 = {}
local var_0_3 = {}

if rawget(_G, "Backend") then
	var_0_0[Backend.CONNECTION_UNINITIALIZED] = "connection_uninitialized"
	var_0_0[Backend.CONNECTION_INITIALIZED] = "connection_initialized"
	var_0_0[Backend.CONNECTION_CONNECTING] = "connection_connecting"
	var_0_0[Backend.CONNECTION_CONNECTED] = "connection_connected"
	var_0_0[Backend.CONNECTION_WAITING_AUTH_TICKET] = "connection_waiting_auth_ticket"
	var_0_0[Backend.CONNECTION_AUTHENTICATING] = "connection_authenticating"
	var_0_0[Backend.CONNECTION_AUTHENTICATED] = "connection_authenticated"
	var_0_0[Backend.CONNECTION_DISCONNECTING] = "connection_disconnecting"
	var_0_0[Backend.CONNECTION_ENTITIES_LOADED] = "connection_entities_loaded"
	var_0_0[Backend.CONNECTION_ERROR] = "connection_error"
	var_0_1[Backend.CONNECTION_UNINITIALIZED] = {
		[Backend.CONNECTION_INITIALIZED] = true
	}
	var_0_1[Backend.CONNECTION_INITIALIZED] = {
		[Backend.CONNECTION_CONNECTING] = true,
		[Backend.CONNECTION_CONNECTED] = true
	}
	var_0_1[Backend.CONNECTION_CONNECTING] = {
		[Backend.CONNECTION_CONNECTED] = true
	}
	var_0_1[Backend.CONNECTION_CONNECTED] = {
		[Backend.CONNECTION_AUTHENTICATING] = true,
		[Backend.CONNECTION_AUTHENTICATED] = true,
		[Backend.CONNECTION_WAITING_AUTH_TICKET] = true
	}
	var_0_1[Backend.CONNECTION_WAITING_AUTH_TICKET] = {
		[Backend.CONNECTION_AUTHENTICATING] = true,
		[Backend.CONNECTION_AUTHENTICATED] = true
	}
	var_0_1[Backend.CONNECTION_AUTHENTICATING] = {
		[Backend.CONNECTION_AUTHENTICATED] = true
	}
	var_0_1[Backend.CONNECTION_AUTHENTICATED] = {
		[Backend.CONNECTION_ENTITIES_LOADED] = true
	}
	var_0_1[Backend.CONNECTION_ENTITIES_LOADED] = {}
	var_0_2[Backend.RES_OK] = "backend_res_ok"
	var_0_2[Backend.RES_UNKNOWN_ERR] = "backend_res_unknown_error"
	var_0_2[Backend.RES_INVALID_STATE] = "backend_res_invalid_state"
	var_0_2[Backend.RES_AUTH_IN_PROGRESS] = "backend_res_auth_in_progress"
	var_0_2[Backend.RES_INVALID_USER] = "backend_res_invalid_user"
	var_0_2[Backend.RES_HTTP_ERROR] = "backend_res_http_error"
	var_0_2[Backend.RES_DNS_ERROR] = "backend_res_dns_error"
	var_0_2[Backend.RES_INVALID_TRANSACTION] = "backend_res_invalid_transaction"
	var_0_2[Backend.RES_INVALID_ATTRIBUTE] = "backend_res_invalid_attribute"
	var_0_2[Backend.RES_NO_PENDING_DATA] = "backend_res_no_pending_data"
	var_0_2[Backend.RES_COMM_ERROR] = "backend_res_comm_error"
	var_0_2[Backend.RES_NO_SUCH_ENTITY] = "backend_res_no_such_entity"
	var_0_2[Backend.RES_NO_CHANGE] = "backend_res_no_change"
	var_0_2[Backend.RES_INVALID_ENTITY_ID] = "backend_res_invalid_entity_id"
	var_0_2[Backend.RES_ACTIVE_SESSION] = "backend_res_active_session"
	var_0_2[Backend.RES_NO_ACTIVE_SESSION] = "backend_res_no_active_session"
	var_0_2[Backend.RES_PARSE_ERROR] = "backend_res_parse_error"
	var_0_2[Backend.RES_TITLE_ID_DISABLED] = "backend_res_title_id_disabled"

	if Backend.ENV_DEV then
		var_0_3[Backend.ENV_DEV] = "Dev"
		var_0_3[Backend.ENV_STAGE] = "Stage"
		var_0_3[Backend.ENV_PROD] = "Prod"
	end
end

local var_0_4 = {
	off = 0,
	verbose = 2,
	normal = 1
}

function ScriptBackend.init(arg_1_0)
	local var_1_0 = GameSettingsDevelopment.backend_settings.title_id
	local var_1_1 = GameSettingsDevelopment.backend_settings.environment

	print(string.format("[Backend] Creating backend with title id: %d, environment: %q", var_1_0, var_0_3[var_1_1]))
	Backend.create(var_1_0, var_1_1)

	arg_1_0._backend = true

	arg_1_0:refresh_log_level()

	arg_1_0._dirty = true
	arg_1_0._dirty_stats = true
	arg_1_0._state = Backend.CONNECTION_UNINITIALIZED
	arg_1_0._commits = {}
	arg_1_0._commit_current_id = nil
	arg_1_0._commit_queue_id = nil
	arg_1_0._last_id = 0
end

local function var_0_5(arg_2_0, arg_2_1)
	if arg_2_0 and arg_2_0.reason ~= Backend.ERR_OK then
		local var_2_0 = string.format("%q failed with %d, %s", arg_2_1, arg_2_0.reason, arg_2_0.details or "nil")

		print_error(var_2_0)

		return {
			reason = arg_2_0.reason,
			details = arg_2_0.details
		}
	end
end

function ScriptBackend.update(arg_3_0)
	if arg_3_0._commit_current_id then
		arg_3_0:_check_current_commit()
	end

	return (Backend.update())
end

function ScriptBackend._update_state(arg_4_0)
	local var_4_0 = Backend.state()
	local var_4_1 = var_0_1[arg_4_0._state]

	if var_4_0 ~= arg_4_0._state then
		print("[Backend] Changed state from", var_0_0[arg_4_0._state], "to", var_0_0[var_4_0])
	end

	local var_4_2

	if var_4_0 ~= arg_4_0._state and not var_4_1[var_4_0] then
		local var_4_3 = arg_4_0:check_for_errors()

		if var_4_3 then
			return var_4_3
		end

		local var_4_4 = var_0_0[arg_4_0._state]
		local var_4_5 = var_0_0[var_4_0]
		local var_4_6
		local var_4_7

		if arg_4_0._state == Backend.CONNECTION_ENTITIES_LOADED then
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

	arg_4_0._state = var_4_0

	return var_4_2
end

function ScriptBackend.update_state(arg_5_0)
	return arg_5_0:_update_state()
end

function ScriptBackend.update_signin(arg_6_0)
	local var_6_0 = arg_6_0:_update_state()

	if var_6_0 then
		return var_6_0
	end

	local var_6_1 = arg_6_0._state
	local var_6_2

	if var_6_1 == Backend.CONNECTION_INITIALIZED then
		var_6_2 = var_0_5(Backend.connect(), "Connect")
	end

	if var_6_1 == Backend.CONNECTION_CONNECTED then
		var_6_2 = var_0_5(Backend.steam_auth(), "Auth")
	end

	if var_6_1 == Backend.CONNECTION_AUTHENTICATED and not arg_6_0._entities_requested then
		Backend.load_entities()

		arg_6_0._entities_requested = true
	end

	return var_6_2
end

function ScriptBackend.authenticated(arg_7_0)
	return Backend.state() == Backend.CONNECTION_ENTITIES_LOADED
end

function ScriptBackend._refresh_stats(arg_8_0)
	if arg_8_0._dirty_stats or not arg_8_0._stats then
		local var_8_0 = BackendStats.get_stats(arg_8_0._backend)
		local var_8_1 = {}

		for iter_8_0, iter_8_1 in pairs(var_8_0) do
			var_8_1[iter_8_1.key] = iter_8_1.data
		end

		arg_8_0._stats = var_8_0
		arg_8_0._nice_stats = var_8_1
		arg_8_0._dirty_stats = false
	end
end

function ScriptBackend.get_stats(arg_9_0)
	arg_9_0:_refresh_stats()

	return arg_9_0._nice_stats
end

function ScriptBackend.set_stats(arg_10_0, arg_10_1)
	arg_10_0:_refresh_stats()

	local var_10_0 = table.clone(arg_10_1)

	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		for iter_10_2, iter_10_3 in pairs(arg_10_0._stats) do
			if iter_10_3.key == iter_10_0 then
				var_10_0[iter_10_0] = nil

				if iter_10_3.data ~= iter_10_1 then
					var_0_5(BackendStats.set_stat(iter_10_2, iter_10_0, iter_10_1), "Set stat")
				end

				break
			end
		end
	end

	for iter_10_4, iter_10_5 in pairs(var_10_0) do
		Crashify.print_exception("ScriptBackend", "Tried to set unregistered stat %s, value: %s", iter_10_4, iter_10_5)
	end

	arg_10_0:commit()

	arg_10_0._dirty_stats = true
end

function ScriptBackend.check_for_errors(arg_11_0)
	local var_11_0 = Backend.get_error()
	local var_11_1 = BackendSession.get_error()
	local var_11_2

	if arg_11_0._commit_error then
		var_11_2 = {
			reason = Backend.ERR_COMMIT
		}
		arg_11_0._commit_error = nil
	end

	return var_11_0 or var_11_1 or var_11_2
end

function ScriptBackend._new_id(arg_12_0)
	arg_12_0._last_id = arg_12_0._last_id + 1

	return arg_12_0._last_id
end

function ScriptBackend._check_current_commit(arg_13_0)
	local var_13_0 = arg_13_0:commit_status(arg_13_0._commit_current_id)

	if var_13_0 ~= Backend.COMMIT_WAITING then
		local var_13_1 = arg_13_0._commits[arg_13_0._commit_current_id]

		print("commit status", var_13_0, var_13_1.id)

		arg_13_0._commit_current_id = nil

		if var_13_0 == Backend.COMMIT_SUCCESS then
			if arg_13_0._commit_queue_id then
				arg_13_0:commit(true)
			end
		elseif var_13_0 == Backend.COMMIT_ERROR then
			arg_13_0._commit_error = true
			arg_13_0._commit_queue_id = nil
		end
	end
end

function ScriptBackend._commit_internal(arg_14_0, arg_14_1)
	local var_14_0, var_14_1 = Backend.commit()
	local var_14_2 = arg_14_1 or arg_14_0:_new_id()
	local var_14_3 = {
		id = var_14_0,
		timeout = os.time() + 15,
		result = var_14_1
	}

	arg_14_0._commits[var_14_2] = var_14_3
	arg_14_0._commit_current_id = var_14_2

	print(string.format("Commiting with %d:%d result: %d", var_14_2, var_14_0, var_14_1))

	return var_14_2
end

function ScriptBackend._queue_commit(arg_15_0)
	if not arg_15_0._commit_queue_id then
		arg_15_0._commit_queue_id = arg_15_0:_new_id()
	end

	return arg_15_0._commit_queue_id
end

function ScriptBackend.commit(arg_16_0, arg_16_1)
	print("Trying to commit", arg_16_1, arg_16_0._commit_current_id, arg_16_0._commit_queue_id)

	if arg_16_0._commit_current_id then
		fassert(not arg_16_1, "Internal backend commit error, current commit exists")

		return arg_16_0:_queue_commit()
	else
		local var_16_0 = arg_16_0:_commit_internal(arg_16_0._commit_queue_id)

		arg_16_0._commit_queue_id = nil

		return var_16_0
	end
end

function ScriptBackend.commit_status(arg_17_0, arg_17_1)
	fassert(arg_17_1, "Querying status for commit_id %s", tostring(arg_17_1))

	if arg_17_1 == arg_17_0._commit_queue_id then
		return Backend.COMMIT_WAITING
	end

	local var_17_0 = arg_17_0._commits[arg_17_1]

	fassert(var_17_0, "No commit with id %d", arg_17_1)

	if var_17_0.timeout < os.time() then
		print(var_17_0.timeout, os.time())

		local var_17_1 = string.format("Commit timed out %d:%d", arg_17_1, var_17_0.id)

		Application.warning(var_17_1)

		return Backend.COMMIT_ERROR
	end

	if var_17_0.result ~= Backend.COMMIT_WAITING then
		return var_17_0.result
	elseif var_17_0.id then
		local var_17_2 = Backend.query_commit(var_17_0.id)

		if var_17_2 == Backend.COMMIT_SUCCESS then
			Managers.backend:get_interface("items"):__dirtify()
		end

		var_17_0.result = var_17_2

		return var_17_2
	else
		return Backend.COMMIT_WAITING
	end
end

function ScriptBackend.destroy(arg_18_0)
	print("[Backend] ScriptBackend destroy")
	Backend.destroy()
end

function ScriptBackend.backend_object(arg_19_0)
	error("no backend object in lua anymore")

	return arg_19_0._backend
end

function ScriptBackend.refresh_log_level(arg_20_0)
	local var_20_0 = script_data.backend_logging_level or "verbose"
	local var_20_1 = var_0_4[var_20_0]

	Backend.set_log_level(var_20_1)
end

function ScriptBackend.wait_for_shutdown(arg_21_0, arg_21_1)
	local var_21_0 = os.time() + arg_21_1

	while Backend.active_requests() > 0 or arg_21_0._commit_queue_id do
		local var_21_1 = arg_21_0:update()

		if var_21_1 or var_21_0 < os.time() then
			if var_21_1 then
				print("wait for shutdown has enountered error")
			else
				print("wait for shutdown has timed out", Backend.active_requests(), arg_21_0._commit_queue_id)
			end

			return
		end
	end

	print("disconnecting backend")
	Backend.disconnect()

	while not arg_21_0:update() and Backend.active_requests() > 0 and var_21_0 > os.time() do
		-- block empty
	end

	if var_21_0 < os.time() then
		print("backend disconnect has timed out")
	end
end
