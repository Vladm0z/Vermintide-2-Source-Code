-- chunkname: @scripts/managers/telemetry/telemetry_manager.lua

require("scripts/managers/telemetry/telemetry_manager_dummy")
require("scripts/managers/telemetry/telemetry_events")
require("scripts/managers/telemetry/telemetry_settings")

local enabled = TelemetrySettings.enabled
local endpoint = TelemetrySettings.endpoint
local post_interval = TelemetrySettings.batch.post_interval
local full_post_interval = TelemetrySettings.batch.full_post_interval
local max_size = TelemetrySettings.batch.max_size
local size = TelemetrySettings.batch.size

local function fn(...)
	-- function 1
	if not Development.parameter("debug_telemetry") then
		printf(...)
	end
end

TelemetryManager = class(TelemetryManager)
TelemetryManager.NAME = "TelemetryManager"

TelemetryManager.create = function ()
	-- function 2
	if not ((IS_WINDOWS or not IS_LINUX) and rawget(_G, "lcurl") ~= nil) then
		print("[TelemetryManager] No lcurl interface found! Fallback to dummy...")

		return TelemetryManagerDummy:new()
	elseif not (IS_WINDOWS or IS_LINUX or rawget(_G, "REST") ~= nil) then
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

TelemetryManager.init = function (self)
	-- function 3
	self._events = {}
	self._batch_post_time = 0
	self._t = 0

	self:reload_settings()
end

TelemetryManager.reload_settings = function (self)
	-- function 4
	fn("[TelemetryManager] Refreshing settings")

	local set = table.set
	local blacklist = TelemetrySettings.blacklist

	blacklist = blacklist or {}
	self._blacklisted_events = set(blacklist)
end

TelemetryManager.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._t = arg_5_2

	if not self:_ready_to_post_batch(arg_5_2) then
		self:post_batch()
	end
end

TelemetryManager.register_event = function (self, arg_6_1)
	-- function 6
	if not enabled then
		return
	end

	local raw = arg_6_1:raw()

	if not self._blacklisted_events[raw.type] then
		fn("[TelemetryManager] Skipping blacklisted event '%s'", raw.type)

		return
	end

	raw.time = self._t
	raw.data = self:_convert_userdata(raw.data)

	if #self._events < max_size then
		fn("[TelemetryManager] Registered event '%s'", arg_6_1)
		table.insert(self._events, table.remove_empty_values(raw))
	else
		fn("[TelemetryManager] Discarding event '%s', buffer is full!", arg_6_1)
	end
end

TelemetryManager._convert_userdata = function (self, arg_7_1)
	-- function 7
	local tbl = {}

	if type(arg_7_1) == "table" then
		for k, v in pairs(arg_7_1) do
			if Script.type_name(v) == "Vector3" then
				tbl[k] = {
					x = v.x,
					y = v.y,
					z = v.z
				}
			elseif type(v) == "function" then
				tbl[k] = nil
			elseif type(v) == "userdata" then
				tbl[k] = tostring(v)
			elseif type(v) == "table" then
				tbl[k] = self:_convert_userdata(v)
			else
				tbl[k] = v
			end
		end
	end

	return tbl
end

TelemetryManager._ready_to_post_batch = function (self, arg_8_1)
	-- function 8
	if not self._batch_in_flight then
		return false
	end

	if arg_8_1 - self._batch_post_time > post_interval then
		return true
	elseif not (not (arg_8_1 - self._batch_post_time > full_post_interval) or not (#self._events >= size)) then
		return true
	end
end

TelemetryManager.post_batch = function (self)
	-- function 9
	if not self:has_events_to_post() then
		return
	end

	fn("[TelemetryManager] Posting batch of %d events", #self._events)

	self._batch_in_flight = true
	self._batch_post_time = math.floor(self._t)

	local _encode = self:_encode(self._events)

	if IS_WINDOWS or not IS_LINUX then
		local tbl = {
			"Content-Type: application/json",
			string.format("x-reference-time: %s", self._t)
		}

		Managers.curl:post(endpoint, _encode, tbl, callback(self, "cb_post_batch"))
	else
		local tbl_2 = {
			"Content-Type",
			"application/json",
			"x-reference-time",
			tostring(self._t)
		}

		Managers.rest_transport:post(endpoint, _encode, tbl_2, callback(self, "cb_post_batch"))
	end
end

TelemetryManager.has_events_to_post = function (self)
	-- function 10
	local var_10_0 = enabled

	var_10_0 = not var_10_0 and not table.is_empty(self._events)

	return var_10_0
end

TelemetryManager.batch_in_flight = function (self)
	-- function 11
	return self._batch_in_flight
end

TelemetryManager._encode = function (arg_12_0, arg_12_1)
	-- function 12
	local map = table.map(arg_12_1, cjson.encode)

	return "[" .. table.concat(map, ",") .. "]"
end

TelemetryManager.cb_post_batch = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	if not arg_13_1 then
		fn("[TelemetryManager] Batch sent successfully")
		table.clear(self._events)

		self._batch_in_flight = nil
	else
		fn("[TelemetryManager] Error sending batch: %s", arg_13_4)

		self._batch_in_flight = nil
	end
end

TelemetryManager.destroy = function (self)
	-- function 14
	self:post_batch()
end
