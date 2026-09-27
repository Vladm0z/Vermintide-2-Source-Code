-- chunkname: @scripts/managers/backend_playfab/backend_interface_statistics_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceStatisticsPlayFab = class(BackendInterfaceStatisticsPlayFab)

BackendInterfaceStatisticsPlayFab.update = function (arg_1_0, arg_1_1)
	-- function 1
	return
end

BackendInterfaceStatisticsPlayFab.init = function (self, arg_2_1)
	-- function 2
	self._mirror = arg_2_1
	self._request_queue = arg_2_1:request_queue()

	local function fn(self)
		-- function 3
		print("Player statistics loaded!")

		local FunctionResult = self.FunctionResult

		self._mirror:set_stats(FunctionResult)

		self._ready = true
	end

	local tbl = {
		FunctionName = "loadPlayerStatistics"
	}

	self._request_queue:enqueue(tbl, fn)
end

BackendInterfaceStatisticsPlayFab.ready = function (self)
	-- function 4
	return self._ready
end

BackendInterfaceStatisticsPlayFab.get_stats = function (self)
	-- function 5
	return self._mirror:get_stats()
end

local function fn(arg_6_0)
	-- function 6
	local tbl = {}

	for k, v in pairs(arg_6_0) do
		if v.value == nil then
			table.append(tbl, fn(v))
		else
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

local function fn_2(arg_7_0)
	-- function 7
	local tbl = {}

	for k, v in pairs(arg_7_0) do
		local database_name = v.database_name
		local persistent_value = v.persistent_value

		if not database_name and type(persistent_value) ~= "number" or not v.dirty then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

BackendInterfaceStatisticsPlayFab.clear_dirty_flags = function (arg_8_0, arg_8_1)
	-- function 8
	for k, v in pairs(arg_8_1) do
		v.dirty = false
	end
end

BackendInterfaceStatisticsPlayFab.save = function (self)
	-- function 9
	local player = Managers.player

	print("---------------------- BackendInterfaceStatisticsPlayFab:save ----------------------")

	if not player then
		print("[BackendInterfaceStatisticsPlayFab] No player manager, skipping saving statistics...")

		return false
	end

	local local_player = player:local_player()

	if not local_player then
		print("[BackendInterfaceStatisticsPlayFab] No player found, skipping saving statistics...")

		return false
	end

	local stats_id = local_player:stats_id()
	local get_all_stats = Managers.player:statistics_db():get_all_stats(stats_id)

	self._stats_to_save = fn_2(fn(get_all_stats)), player:set_stats_backend(local_player)
end

BackendInterfaceStatisticsPlayFab.save_explicit = function (self, arg_10_1, arg_10_2)
	-- function 10
	print("---------------------- BackendInterfaceStatisticsPlayFab:save ----------------------")

	if not arg_10_2 then
		print("[BackendInterfaceStatisticsPlayFab] No statistics_db provided, skipping saving statistics...")

		return false
	end

	if not arg_10_1 then
		print("[BackendInterfaceStatisticsPlayFab] No stats_id provided, skipping saving statistics...")

		return false
	end

	local get_all_stats = arg_10_2:get_all_stats(arg_10_1)

	self._stats_to_save = fn_2(fn(get_all_stats))

	local tbl = {}

	arg_10_2:generate_backend_stats(arg_10_1, tbl)
	Managers.backend:set_stats(tbl)
end

BackendInterfaceStatisticsPlayFab.save_state_completed_achievements = function (self, arg_11_1)
	-- function 11
	self._state_completed_achievements = arg_11_1
end

BackendInterfaceStatisticsPlayFab.clear_saved_stats = function (self)
	-- function 12
	self._state_completed_achievements = nil
	self._stats_to_save = nil

	Managers.player:statistics_db():apply_persistant_stats()
end

BackendInterfaceStatisticsPlayFab.get_stat_save_request = function (self)
	-- function 13
	local _stats_to_save = self._stats_to_save

	_stats_to_save = _stats_to_save or {}

	local _state_completed_achievements = self._state_completed_achievements

	if (not _stats_to_save and table.is_empty(_stats_to_save) or not _state_completed_achievements) and not table.is_empty(_state_completed_achievements) then
		print("[BackendInterfaceStatisticsPlayFab] No modified player statistics or achievements to save...")

		return false
	end

	return {
		FunctionName = "savePlayerStatistics3",
		FunctionParameter = {
			stats = _stats_to_save,
			completed_achievements = _state_completed_achievements
		}
	}, _stats_to_save
end

BackendInterfaceStatisticsPlayFab.get_achievement_reward_levels = function (self)
	-- function 14
	local get_read_only_data = self._mirror:get_read_only_data("achievement_reward_levels")

	if not get_read_only_data then
		return (cjson.decode(get_read_only_data))
	end
end

BackendInterfaceStatisticsPlayFab.get_achievement_reward_level = function (self, arg_15_1)
	-- function 15
	local get_read_only_data = self._mirror:get_read_only_data("achievement_reward_levels")

	if not get_read_only_data then
		return cjson.decode(get_read_only_data)[arg_15_1]
	end
end

BackendInterfaceStatisticsPlayFab.reset = function (self)
	-- function 16
	local player = Managers.player

	if not player then
		print("[BackendInterfaceStatisticsPlayFab] No player manager, skipping resetting statistics...")

		return false
	end

	local local_player = player:local_player()

	if not local_player then
		print("[BackendInterfaceStatisticsPlayFab] No player found, skipping resetting statistics...")

		return false
	end

	local stats_id = local_player:stats_id()
	local get_all_stats = Managers.player:statistics_db():get_all_stats(stats_id)
	local var_16_4 = fn(get_all_stats)
	local tbl = {}

	for k, v in pairs(var_16_4) do
		if not (not v.database_name and v.source ~= nil) then
			tbl[#tbl + 1] = v.database_name
		end
	end

	local tbl_2 = {
		FunctionName = "devResetPlayerStatistics",
		FunctionParameter = {
			stats = tbl
		}
	}

	local function fn_2(arg_17_0)
		-- function 17
		print("[BackendInterfaceStatisticsPlayFab] Player statistics resetted!")
	end

	self._request_queue:enqueue(tbl_2, fn_2)
end
