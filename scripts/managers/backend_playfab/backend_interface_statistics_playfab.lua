-- chunkname: @scripts/managers/backend_playfab/backend_interface_statistics_playfab.lua

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceStatisticsPlayFab = class(BackendInterfaceStatisticsPlayFab)

BackendInterfaceStatisticsPlayFab.update = function (arg_1_0, arg_1_1)
	return
end

BackendInterfaceStatisticsPlayFab.init = function (arg_2_0, arg_2_1)
	arg_2_0._mirror = arg_2_1
	arg_2_0._request_queue = arg_2_1:request_queue()

	local function var_2_0(arg_3_0)
		print("Player statistics loaded!")

		local var_3_0 = arg_3_0.FunctionResult

		arg_2_0._mirror:set_stats(var_3_0)

		arg_2_0._ready = true
	end

	local var_2_1 = {
		FunctionName = "loadPlayerStatistics"
	}

	arg_2_0._request_queue:enqueue(var_2_1, var_2_0)
end

BackendInterfaceStatisticsPlayFab.ready = function (arg_4_0)
	return arg_4_0._ready
end

BackendInterfaceStatisticsPlayFab.get_stats = function (arg_5_0)
	return arg_5_0._mirror:get_stats()
end

local function var_0_1(arg_6_0)
	local var_6_0 = {}

	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		if iter_6_1.value == nil then
			table.append(var_6_0, var_0_1(iter_6_1))
		else
			var_6_0[#var_6_0 + 1] = iter_6_1
		end
	end

	return var_6_0
end

local function var_0_2(arg_7_0)
	local var_7_0 = {}

	for iter_7_0, iter_7_1 in pairs(arg_7_0) do
		local var_7_1 = iter_7_1.database_name
		local var_7_2 = iter_7_1.persistent_value

		if var_7_1 and type(var_7_2) == "number" and iter_7_1.dirty then
			var_7_0[#var_7_0 + 1] = iter_7_1
		end
	end

	return var_7_0
end

BackendInterfaceStatisticsPlayFab.clear_dirty_flags = function (arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		iter_8_1.dirty = false
	end
end

BackendInterfaceStatisticsPlayFab.save = function (arg_9_0)
	local var_9_0 = Managers.player

	print("---------------------- BackendInterfaceStatisticsPlayFab:save ----------------------")

	if not var_9_0 then
		print("[BackendInterfaceStatisticsPlayFab] No player manager, skipping saving statistics...")

		return false
	end

	local var_9_1 = var_9_0:local_player()

	if not var_9_1 then
		print("[BackendInterfaceStatisticsPlayFab] No player found, skipping saving statistics...")

		return false
	end

	local var_9_2 = var_9_1:stats_id()
	local var_9_3 = Managers.player:statistics_db():get_all_stats(var_9_2)

	arg_9_0._stats_to_save = var_0_2(var_0_1(var_9_3)), var_9_0:set_stats_backend(var_9_1)
end

BackendInterfaceStatisticsPlayFab.save_explicit = function (arg_10_0, arg_10_1, arg_10_2)
	print("---------------------- BackendInterfaceStatisticsPlayFab:save ----------------------")

	if not arg_10_2 then
		print("[BackendInterfaceStatisticsPlayFab] No statistics_db provided, skipping saving statistics...")

		return false
	end

	if not arg_10_1 then
		print("[BackendInterfaceStatisticsPlayFab] No stats_id provided, skipping saving statistics...")

		return false
	end

	local var_10_0 = arg_10_2:get_all_stats(arg_10_1)

	arg_10_0._stats_to_save = var_0_2(var_0_1(var_10_0))

	local var_10_1 = {}

	arg_10_2:generate_backend_stats(arg_10_1, var_10_1)
	Managers.backend:set_stats(var_10_1)
end

BackendInterfaceStatisticsPlayFab.save_state_completed_achievements = function (arg_11_0, arg_11_1)
	arg_11_0._state_completed_achievements = arg_11_1
end

BackendInterfaceStatisticsPlayFab.clear_saved_stats = function (arg_12_0)
	arg_12_0._state_completed_achievements = nil
	arg_12_0._stats_to_save = nil

	Managers.player:statistics_db():apply_persistant_stats()
end

BackendInterfaceStatisticsPlayFab.get_stat_save_request = function (arg_13_0)
	local var_13_0 = arg_13_0._stats_to_save or {}
	local var_13_1 = arg_13_0._state_completed_achievements

	if (not var_13_0 or table.is_empty(var_13_0)) and (not var_13_1 or table.is_empty(var_13_1)) then
		print("[BackendInterfaceStatisticsPlayFab] No modified player statistics or achievements to save...")

		return false
	end

	return {
		FunctionName = "savePlayerStatistics3",
		FunctionParameter = {
			stats = var_13_0,
			completed_achievements = var_13_1
		}
	}, var_13_0
end

BackendInterfaceStatisticsPlayFab.get_achievement_reward_levels = function (arg_14_0)
	local var_14_0 = arg_14_0._mirror:get_read_only_data("achievement_reward_levels")

	if var_14_0 then
		return (cjson.decode(var_14_0))
	end
end

BackendInterfaceStatisticsPlayFab.get_achievement_reward_level = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._mirror:get_read_only_data("achievement_reward_levels")

	if var_15_0 then
		return cjson.decode(var_15_0)[arg_15_1]
	end
end

BackendInterfaceStatisticsPlayFab.reset = function (arg_16_0)
	local var_16_0 = Managers.player

	if not var_16_0 then
		print("[BackendInterfaceStatisticsPlayFab] No player manager, skipping resetting statistics...")

		return false
	end

	local var_16_1 = var_16_0:local_player()

	if not var_16_1 then
		print("[BackendInterfaceStatisticsPlayFab] No player found, skipping resetting statistics...")

		return false
	end

	local var_16_2 = var_16_1:stats_id()
	local var_16_3 = Managers.player:statistics_db():get_all_stats(var_16_2)
	local var_16_4 = var_0_1(var_16_3)
	local var_16_5 = {}

	for iter_16_0, iter_16_1 in pairs(var_16_4) do
		if iter_16_1.database_name and iter_16_1.source == nil then
			var_16_5[#var_16_5 + 1] = iter_16_1.database_name
		end
	end

	local var_16_6 = {
		FunctionName = "devResetPlayerStatistics",
		FunctionParameter = {
			stats = var_16_5
		}
	}

	local function var_16_7(arg_17_0)
		print("[BackendInterfaceStatisticsPlayFab] Player statistics resetted!")
	end

	arg_16_0._request_queue:enqueue(var_16_6, var_16_7)
end
