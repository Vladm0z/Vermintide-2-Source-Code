-- chunkname: @scripts/managers/ping/ping_manager.lua

PingManager = class(PingManager)

PingManager.init = function (self)
	-- function 1
	self._target_to_region = {}
	self._targets = {}
	self._latency_results = {}
	self._ping_count = 0
	self._is_fetching_data = false
	self._timeout = 0
	self._cb = nil
end

PingManager.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not self._is_fetching_data then
		return
	end

	local update = Ping.update(arg_2_1, arg_2_2)

	if not update then
		if arg_2_2 > self._timeout then
			self._is_fetching_data = false

			self._cb(false)
		end

		return
	end

	local tbl = {}

	for i = 1, #update do
		for k, v in pairs(update[i].results) do
			local var_2_2 = self._target_to_region[k]

			if not var_2_2 then
				if not v.failed then
					printf("RegionLatency, failed to get latency for region %s", var_2_2.region)
				else
					tbl[var_2_2.region] = v.latency
				end
			else
				printf("RegionLatency, did not recieve latency for target %s", k)
			end
		end
	end

	self._latency_results[#self._latency_results + 1] = tbl

	if #self._latency_results < self._ping_count then
		self:_ping(self._timeout)
	else
		self._is_fetching_data = false

		self._cb(true, self:_stats())
	end
end

PingManager._stats = function (self)
	-- function 3
	local tbl = {}

	for i = 1, #self._latency_results do
		for k, v in pairs(self._latency_results[i]) do
			local var_3_1 = tbl[k]

			var_3_1 = var_3_1 or {}
			var_3_1[#var_3_1 + 1] = v
			tbl[k] = var_3_1
		end
	end

	local tbl_2 = {}

	for k_2, v_2 in pairs(tbl) do
		local count = #v_2

		if count > 0 then
			tbl_2[k_2] = {}

			local num = 0

			for i5 = 1, count do
				num = num + v_2[i5]
			end

			tbl_2[k_2] = num / count
		end
	end

	return tbl_2
end

PingManager._target_to_regions = function (self, arg_4_1)
	-- function 4
	if not arg_4_1 then
		print("Received empty region data, nothing to ping")

		return false
	end

	local _targets = self._targets
	local _target_to_region = self._target_to_region

	table.clear(_targets)
	table.clear(_target_to_region)

	for i = 1, #arg_4_1 do
		local var_4_2 = arg_4_1[i]
		local pingTarget = var_4_2.pingTarget

		_targets[#_targets + 1] = pingTarget
		_target_to_region[pingTarget] = var_4_2
	end

	return true
end

PingManager.ping_multiple_times = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not self._is_fetching_data then
		print("Already pinging")

		return
	end

	if not self:_target_to_regions(arg_5_2) then
		return
	end

	table.clear(self._latency_results)

	self._ping_count = arg_5_3
	self._timeout_duration = arg_5_1
	self._cb = arg_5_4

	self:_ping()
end

PingManager.ping = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not self._is_fetching_data then
		print("Already pinging")

		return
	end

	if not self:_target_to_regions(arg_6_2) then
		return
	end

	table.clear(self._latency_results)

	self._ping_count = 1
	self._timeout_duration = arg_6_1
	self._cb = arg_6_3

	self:_ping()
end

PingManager._ping = function (self)
	-- function 7
	self._timeout = Managers.time:time("main") + self._timeout_duration
	self._is_fetching_data = true

	Ping.ping(self._timeout_duration, unpack(self._targets))
end
