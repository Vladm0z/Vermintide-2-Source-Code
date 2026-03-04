-- chunkname: @scripts/managers/performance_title/performance_title_manager.lua

require("scripts/managers/performance_title/performance_title_templates")

PerformanceTitleManager = class(PerformanceTitleManager)

local var_0_0 = {
	"rpc_sync_performance_titles"
}
local var_0_1 = "0"

local function var_0_2(arg_1_0)
	local var_1_0 = NetworkConstants.uint_16
	local var_1_1 = var_1_0.min
	local var_1_2 = var_1_0.max

	return math.clamp(arg_1_0, var_1_1, var_1_2)
end

PerformanceTitleManager.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._network_transmit = arg_2_1
	arg_2_0._statistics_db = arg_2_2
	arg_2_0._is_server = arg_2_3
	arg_2_0._assigned_titles = {}
end

PerformanceTitleManager.register_rpcs = function (arg_3_0, arg_3_1)
	arg_3_1:register(arg_3_0, unpack(var_0_0))

	arg_3_0._network_event_delegate = arg_3_1
end

PerformanceTitleManager.unregister_rpcs = function (arg_4_0)
	arg_4_0._network_event_delegate:unregister(arg_4_0)

	arg_4_0._network_event_delegate = nil
end

PerformanceTitleManager.destroy = function (arg_5_0)
	arg_5_0._statistics_db = nil
	arg_5_0._network_transmit = nil
end

PerformanceTitleManager.assigned_titles = function (arg_6_0)
	return arg_6_0._assigned_titles
end

PerformanceTitleManager._evaluate_player_titles = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._statistics_db
	local var_7_1 = arg_7_1:stats_id()
	local var_7_2 = PerformanceTitles.titles
	local var_7_3 = PerformanceTitles.templates
	local var_7_4 = false

	for iter_7_0, iter_7_1 in pairs(var_7_2) do
		local var_7_5, var_7_6 = var_7_3[iter_7_1.evaluation_template].evaluate(var_7_0, var_7_1, iter_7_1)

		if var_7_5 then
			arg_7_2[iter_7_0] = var_7_6
			var_7_4 = true
		end
	end

	return var_7_4
end

PerformanceTitleManager._get_title_list_from_player_titles = function (arg_8_0, arg_8_1)
	local var_8_0 = {}

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		for iter_8_2, iter_8_3 in pairs(iter_8_1) do
			if not table.contains(var_8_0, iter_8_2) then
				var_8_0[#var_8_0 + 1] = iter_8_2
			end
		end
	end

	return var_8_0
end

PerformanceTitleManager._find_individually_achieved_title = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0
	local var_9_1 = 0

	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		if iter_9_1[arg_9_2] then
			var_9_1 = var_9_1 + 1
			var_9_0 = iter_9_0
		end
	end

	if var_9_1 ~= 1 then
		var_9_0 = nil
	end

	return var_9_0
end

PerformanceTitleManager._assign_title = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2[arg_10_3][arg_10_4]
	local var_10_1 = arg_10_3:network_id()
	local var_10_2 = arg_10_3:local_player_id()

	arg_10_1[#arg_10_1 + 1] = {
		peer_id = var_10_1,
		local_player_id = var_10_2,
		title = arg_10_4,
		amount = var_10_0
	}
end

PerformanceTitleManager._remove_title_from_player_titles = function (arg_11_0, arg_11_1, arg_11_2)
	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		iter_11_1[arg_11_2] = nil
	end
end

PerformanceTitleManager._assign_individual_titles = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0:_get_title_list_from_player_titles(arg_12_1)
	local var_12_1 = 1

	while var_12_0[var_12_1] ~= nil do
		local var_12_2 = var_12_0[var_12_1]
		local var_12_3 = arg_12_0:_find_individually_achieved_title(arg_12_1, var_12_2)

		if var_12_3 then
			arg_12_0:_assign_title(arg_12_2, arg_12_1, var_12_3, var_12_2)

			arg_12_1[var_12_3] = nil

			arg_12_0:_remove_title_from_player_titles(arg_12_1, var_12_2)

			var_12_1 = 1
		else
			var_12_1 = var_12_1 + 1
		end
	end
end

PerformanceTitleManager._assign_compared_titles = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0:_get_title_list_from_player_titles(arg_13_1)
	local var_13_1 = PerformanceTitles.titles
	local var_13_2 = PerformanceTitles.templates

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		local var_13_3 = 0
		local var_13_4
		local var_13_5 = var_13_2[var_13_1[iter_13_1].evaluation_template]

		for iter_13_2, iter_13_3 in pairs(arg_13_1) do
			local var_13_6 = iter_13_3[iter_13_1]

			if var_13_6 and var_13_5.compare(var_13_6, var_13_3) then
				var_13_3 = var_13_6
				var_13_4 = iter_13_2
			end
		end

		if var_13_4 then
			arg_13_0:_assign_title(arg_13_2, arg_13_1, var_13_4, iter_13_1)

			arg_13_1[var_13_4] = nil
		end
	end
end

PerformanceTitleManager._sync_assigned_titles = function (arg_14_0, arg_14_1)
	local var_14_0 = {}
	local var_14_1 = {}
	local var_14_2 = {}
	local var_14_3 = {}

	for iter_14_0 = 1, 4 do
		local var_14_4 = arg_14_1[iter_14_0]

		if var_14_4 then
			var_14_0[iter_14_0] = var_14_4.peer_id
			var_14_1[iter_14_0] = var_14_4.local_player_id
			var_14_2[iter_14_0] = NetworkLookup.performance_titles[var_14_4.title]
			var_14_3[iter_14_0] = var_0_2(var_14_4.amount)
		else
			var_14_0[iter_14_0] = var_0_1
			var_14_1[iter_14_0] = 0
			var_14_2[iter_14_0] = NetworkLookup.performance_titles["n/a"]
			var_14_3[iter_14_0] = 0
		end
	end

	arg_14_0._network_transmit:send_rpc_clients("rpc_sync_performance_titles", var_14_0, var_14_1, var_14_2, var_14_3)
end

PerformanceTitleManager.evaluate_titles = function (arg_15_0, arg_15_1)
	fassert(arg_15_0._is_server, "Should only be server calling this")

	local var_15_0 = {}

	for iter_15_0, iter_15_1 in pairs(arg_15_1) do
		local var_15_1 = {}

		if arg_15_0:_evaluate_player_titles(iter_15_1, var_15_1) then
			var_15_0[iter_15_1] = var_15_1
		end
	end

	local var_15_2 = {}

	arg_15_0:_assign_individual_titles(var_15_0, var_15_2)

	if table.size(var_15_0) > 0 then
		arg_15_0:_assign_compared_titles(var_15_0, var_15_2)
	end

	arg_15_0._assigned_titles = var_15_2

	arg_15_0:_sync_assigned_titles(var_15_2)
end

PerformanceTitleManager._translate_title_assignment = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if arg_16_1 == var_0_1 then
		return nil
	end

	return {
		peer_id = arg_16_1,
		local_player_id = arg_16_2,
		title = NetworkLookup.performance_titles[arg_16_3],
		amount = arg_16_4
	}
end

PerformanceTitleManager.rpc_sync_performance_titles = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	local var_17_0 = {}

	for iter_17_0 = 1, 4 do
		local var_17_1 = arg_17_2[iter_17_0]

		if var_17_1 ~= var_0_1 then
			local var_17_2 = arg_17_3[iter_17_0]
			local var_17_3 = NetworkLookup.performance_titles[arg_17_4[iter_17_0]]
			local var_17_4 = arg_17_5[iter_17_0]

			var_17_0[#var_17_0 + 1] = {
				peer_id = var_17_1,
				local_player_id = var_17_2,
				title = var_17_3,
				amount = var_17_4
			}
		end
	end

	arg_17_0._assigned_titles = var_17_0
end
