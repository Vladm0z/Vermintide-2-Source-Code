-- chunkname: @scripts/managers/telemetry/telemetry_manager.lua

require("scripts/managers/telemetry/telemetry_manager_dummy")
require("scripts/managers/telemetry/telemetry_events")
require("scripts/managers/telemetry/telemetry_settings")

local var_0_0 = TelemetrySettings.enabled
local var_0_1 = TelemetrySettings.endpoint
local var_0_2 = TelemetrySettings.batch.post_interval
local var_0_3 = TelemetrySettings.batch.full_post_interval
local var_0_4 = TelemetrySettings.batch.max_size
local var_0_5 = TelemetrySettings.batch.size

local function var_0_6(...)
	if Development.parameter("debug_telemetry") then
		printf(...)
	end
end

TelemetryManager = class(TelemetryManager)
TelemetryManager.NAME = "TelemetryManager"

TelemetryManager.create = function ()
	if (IS_WINDOWS or IS_LINUX) and rawget(_G, "lcurl") == nil then
		print("[TelemetryManager] No lcurl interface found! Fallback to dummy...")

		return TelemetryManagerDummy:new()
	elseif not IS_WINDOWS and not IS_LINUX and rawget(_G, "REST") == nil then
		print("[TelemetryManager] No REST interface found! Fallback to dummy...")

		return TelemetryManagerDummy:new()
	elseif rawget(_G, "cjson") == nil then
		print("[TelemetryManager] No cjson interface found! Fallback to dummy...")

		return TelemetryManagerDummy:new()
	elseif TelemetrySettings.enabled == false then
		print("[TelemetryManager] Disabled! Fallback to dummy...")

		return TelemetryManagerDummy:new()
	else
		return TelemetryManager:new()
	end
end

TelemetryManager.init = function (arg_3_0)
	arg_3_0._events = {}
	arg_3_0._batch_post_time = 0
	arg_3_0._t = 0

	arg_3_0:reload_settings()
end

TelemetryManager.reload_settings = function (arg_4_0)
	var_0_6("[TelemetryManager] Refreshing settings")

	arg_4_0._blacklisted_events = table.set(TelemetrySettings.blacklist or {})
end

TelemetryManager.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._t = arg_5_2

	if arg_5_0:_ready_to_post_batch(arg_5_2) then
		arg_5_0:post_batch()
	end
end

TelemetryManager.register_event = function (arg_6_0, arg_6_1)
	if not var_0_0 then
		return
	end

	local var_6_0 = arg_6_1:raw()

	if arg_6_0._blacklisted_events[var_6_0.type] then
		var_0_6("[TelemetryManager] Skipping blacklisted event '%s'", var_6_0.type)

		return
	end

	var_6_0.time = arg_6_0._t
	var_6_0.data = arg_6_0:_convert_userdata(var_6_0.data)

	if #arg_6_0._events < var_0_4 then
		var_0_6("[TelemetryManager] Registered event '%s'", arg_6_1)
		table.insert(arg_6_0._events, table.remove_empty_values(var_6_0))
	else
		var_0_6("[TelemetryManager] Discarding event '%s', buffer is full!", arg_6_1)
	end
end

TelemetryManager._convert_userdata = function (arg_7_0, arg_7_1)
	local var_7_0 = {}

	if type(arg_7_1) == "table" then
		for iter_7_0, iter_7_1 in pairs(arg_7_1) do
			if Script.type_name(iter_7_1) == "Vector3" then
				var_7_0[iter_7_0] = {
					x = iter_7_1.x,
					y = iter_7_1.y,
					z = iter_7_1.z
				}
			elseif type(iter_7_1) == "function" then
				var_7_0[iter_7_0] = nil
			elseif type(iter_7_1) == "userdata" then
				var_7_0[iter_7_0] = tostring(iter_7_1)
			elseif type(iter_7_1) == "table" then
				var_7_0[iter_7_0] = arg_7_0:_convert_userdata(iter_7_1)
			else
				var_7_0[iter_7_0] = iter_7_1
			end
		end
	end

	return var_7_0
end

TelemetryManager._ready_to_post_batch = function (arg_8_0, arg_8_1)
	if arg_8_0._batch_in_flight then
		return false
	end

	if arg_8_1 - arg_8_0._batch_post_time > var_0_2 then
		return true
	elseif arg_8_1 - arg_8_0._batch_post_time > var_0_3 and #arg_8_0._events >= var_0_5 then
		return true
	end
end

TelemetryManager.post_batch = function (arg_9_0)
	if not arg_9_0:has_events_to_post() then
		return
	end

	var_0_6("[TelemetryManager] Posting batch of %d events", #arg_9_0._events)

	arg_9_0._batch_in_flight = true
	arg_9_0._batch_post_time = math.floor(arg_9_0._t)

	local var_9_0 = arg_9_0:_encode(arg_9_0._events)

	if IS_WINDOWS or IS_LINUX then
		local var_9_1 = {
			"Content-Type: application/json",
			string.format("x-reference-time: %s", arg_9_0._t)
		}

		Managers.curl:post(var_0_1, var_9_0, var_9_1, callback(arg_9_0, "cb_post_batch"))
	else
		local var_9_2 = {
			"Content-Type",
			"application/json",
			"x-reference-time",
			tostring(arg_9_0._t)
		}

		Managers.rest_transport:post(var_0_1, var_9_0, var_9_2, callback(arg_9_0, "cb_post_batch"))
	end
end

TelemetryManager.has_events_to_post = function (arg_10_0)
	return var_0_0 and not table.is_empty(arg_10_0._events)
end

TelemetryManager.batch_in_flight = function (arg_11_0)
	return arg_11_0._batch_in_flight
end

TelemetryManager._encode = function (arg_12_0, arg_12_1)
	local var_12_0 = table.map(arg_12_1, cjson.encode)

	return "[" .. table.concat(var_12_0, ",") .. "]"
end

TelemetryManager.cb_post_batch = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	if arg_13_1 then
		var_0_6("[TelemetryManager] Batch sent successfully")
		table.clear(arg_13_0._events)

		arg_13_0._batch_in_flight = nil
	else
		var_0_6("[TelemetryManager] Error sending batch: %s", arg_13_4)

		arg_13_0._batch_in_flight = nil
	end
end

TelemetryManager.destroy = function (arg_14_0)
	arg_14_0:post_batch()
end
