-- chunkname: @scripts/managers/ping/ping_manager.lua

PingManager = class(PingManager)

function PingManager.init(arg_1_0)
	arg_1_0._target_to_region = {}
	arg_1_0._targets = {}
	arg_1_0._latency_results = {}
	arg_1_0._ping_count = 0
	arg_1_0._is_fetching_data = false
	arg_1_0._timeout = 0
	arg_1_0._cb = nil
end

function PingManager.update(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0._is_fetching_data then
		return
	end

	local var_2_0 = Ping.update(arg_2_1, arg_2_2)

	if not var_2_0 then
		if arg_2_2 > arg_2_0._timeout then
			arg_2_0._is_fetching_data = false

			arg_2_0._cb(false)
		end

		return
	end

	local var_2_1 = {}

	for iter_2_0 = 1, #var_2_0 do
		for iter_2_1, iter_2_2 in pairs(var_2_0[iter_2_0].results) do
			local var_2_2 = arg_2_0._target_to_region[iter_2_1]

			if var_2_2 then
				if iter_2_2.failed then
					printf("RegionLatency, failed to get latency for region %s", var_2_2.region)
				else
					var_2_1[var_2_2.region] = iter_2_2.latency
				end
			else
				printf("RegionLatency, did not recieve latency for target %s", iter_2_1)
			end
		end
	end

	arg_2_0._latency_results[#arg_2_0._latency_results + 1] = var_2_1

	if #arg_2_0._latency_results < arg_2_0._ping_count then
		arg_2_0:_ping(arg_2_0._timeout)
	else
		arg_2_0._is_fetching_data = false

		arg_2_0._cb(true, arg_2_0:_stats())
	end
end

function PingManager._stats(arg_3_0)
	local var_3_0 = {}

	for iter_3_0 = 1, #arg_3_0._latency_results do
		for iter_3_1, iter_3_2 in pairs(arg_3_0._latency_results[iter_3_0]) do
			local var_3_1 = var_3_0[iter_3_1] or {}

			var_3_1[#var_3_1 + 1] = iter_3_2
			var_3_0[iter_3_1] = var_3_1
		end
	end

	local var_3_2 = {}

	for iter_3_3, iter_3_4 in pairs(var_3_0) do
		local var_3_3 = #iter_3_4

		if var_3_3 > 0 then
			var_3_2[iter_3_3] = {}

			local var_3_4 = 0

			for iter_3_5 = 1, var_3_3 do
				var_3_4 = var_3_4 + iter_3_4[iter_3_5]
			end

			var_3_2[iter_3_3] = var_3_4 / var_3_3
		end
	end

	return var_3_2
end

function PingManager._target_to_regions(arg_4_0, arg_4_1)
	if not arg_4_1 then
		print("Received empty region data, nothing to ping")

		return false
	end

	local var_4_0 = arg_4_0._targets
	local var_4_1 = arg_4_0._target_to_region

	table.clear(var_4_0)
	table.clear(var_4_1)

	for iter_4_0 = 1, #arg_4_1 do
		local var_4_2 = arg_4_1[iter_4_0]
		local var_4_3 = var_4_2.pingTarget

		var_4_0[#var_4_0 + 1] = var_4_3
		var_4_1[var_4_3] = var_4_2
	end

	return true
end

function PingManager.ping_multiple_times(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_0._is_fetching_data then
		print("Already pinging")

		return
	end

	if not arg_5_0:_target_to_regions(arg_5_2) then
		return
	end

	table.clear(arg_5_0._latency_results)

	arg_5_0._ping_count = arg_5_3
	arg_5_0._timeout_duration = arg_5_1
	arg_5_0._cb = arg_5_4

	arg_5_0:_ping()
end

function PingManager.ping(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0._is_fetching_data then
		print("Already pinging")

		return
	end

	if not arg_6_0:_target_to_regions(arg_6_2) then
		return
	end

	table.clear(arg_6_0._latency_results)

	arg_6_0._ping_count = 1
	arg_6_0._timeout_duration = arg_6_1
	arg_6_0._cb = arg_6_3

	arg_6_0:_ping()
end

function PingManager._ping(arg_7_0)
	arg_7_0._timeout = Managers.time:time("main") + arg_7_0._timeout_duration
	arg_7_0._is_fetching_data = true

	Ping.ping(arg_7_0._timeout_duration, unpack(arg_7_0._targets))
end
