-- chunkname: @scripts/managers/backend_playfab/backend_interface_statistics_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceStatisticsPlayFab = class(BackendInterfaceStatisticsPlayFab)

BackendInterfaceStatisticsPlayFab.update = function (self, dt)
	-- function 1
	return
end

BackendInterfaceStatisticsPlayFab.init = function (self, mirror)
	-- function 2
	self._mirror = mirror
	self._request_queue = mirror:request_queue()

	local function success_callback(result)
		-- function 3
		print("Player statistics loaded!")

		local stats = result.FunctionResult

		self._mirror:set_stats(stats)

		self._ready = true
	end

	local request = {
		FunctionName = "loadPlayerStatistics"
	}

	self._request_queue:enqueue(request, success_callback)
end

BackendInterfaceStatisticsPlayFab.ready = function (self)
	-- function 4
	return self._ready
end

BackendInterfaceStatisticsPlayFab.get_stats = function (self)
	-- function 5
	return self._mirror:get_stats()
end

local function flatten_stats(stats)
	-- function 6
	local flattened_stats = {}

	for _, stat in pairs(stats) do
		if stat.value == nil then
			table.append(flattened_stats, flatten_stats(stat))
		else
			flattened_stats[#flattened_stats + 1] = stat
		end
	end

	return flattened_stats
end

local function filter_stats(stats)
	-- function 7
	local filtered_stats = {}

	for _, stat in pairs(stats) do
		local d_name = stat.database_name
		local p_value = stat.persistent_value

		if d_name and type(p_value) == "number" and stat.dirty then
			filtered_stats[#filtered_stats + 1] = stat
		end
	end

	return filtered_stats
end

BackendInterfaceStatisticsPlayFab.clear_dirty_flags = function (self, stats)
	-- function 8
	for _, stat in pairs(stats) do
		stat.dirty = false
	end
end

BackendInterfaceStatisticsPlayFab.save = function (self)
	-- function 9
	local player_manager = Managers.player

	print("---------------------- BackendInterfaceStatisticsPlayFab:save ----------------------")

	if not player_manager then
		print("[BackendInterfaceStatisticsPlayFab] No player manager, skipping saving statistics...")

		return false
	end

	local player = player_manager:local_player()

	if not player then
		print("[BackendInterfaceStatisticsPlayFab] No player found, skipping saving statistics...")

		return false
	end

	local player_stats_id = player:stats_id()
	local player_stats = Managers.player:statistics_db():get_all_stats(player_stats_id)
	local stats_to_save = filter_stats(flatten_stats(player_stats))

	player_manager:set_stats_backend(player)

	self._stats_to_save = stats_to_save
end

BackendInterfaceStatisticsPlayFab.save_explicit = function (self, stats_id, statistics_db)
	-- function 10
	print("---------------------- BackendInterfaceStatisticsPlayFab:save ----------------------")

	if not statistics_db then
		print("[BackendInterfaceStatisticsPlayFab] No statistics_db provided, skipping saving statistics...")

		return false
	end

	if not stats_id then
		print("[BackendInterfaceStatisticsPlayFab] No stats_id provided, skipping saving statistics...")

		return false
	end

	local player_stats = statistics_db:get_all_stats(stats_id)
	local stats_to_save = filter_stats(flatten_stats(player_stats))

	self._stats_to_save = stats_to_save

	local backend_stats = {}

	statistics_db:generate_backend_stats(stats_id, backend_stats)
	Managers.backend:set_stats(backend_stats)
end

BackendInterfaceStatisticsPlayFab.save_state_completed_achievements = function (self, state_completed_achievements)
	-- function 11
	self._state_completed_achievements = state_completed_achievements
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

	if not _stats_to_save then
		-- Nothing
	end

	_stats_to_save = {}

	local stats_to_save = _stats_to_save

	::label_13_0::

	local state_completed_achievements = self._state_completed_achievements

	if (not stats_to_save or table.is_empty(stats_to_save)) and (not state_completed_achievements or table.is_empty(state_completed_achievements)) then
		print("[BackendInterfaceStatisticsPlayFab] No modified player statistics or achievements to save...")

		return false
	end

	local request = {
		FunctionName = "savePlayerStatistics3",
		FunctionParameter = {
			stats = stats_to_save,
			completed_achievements = state_completed_achievements
		}
	}

	return request, stats_to_save
end

BackendInterfaceStatisticsPlayFab.get_achievement_reward_levels = function (self)
	-- function 14
	local achievement_reward_levels = self._mirror:get_read_only_data("achievement_reward_levels")

	if achievement_reward_levels then
		achievement_reward_levels = cjson.decode(achievement_reward_levels)

		return achievement_reward_levels
	end
end

BackendInterfaceStatisticsPlayFab.get_achievement_reward_level = function (self, achievement_id)
	-- function 15
	local achievement_reward_levels = self._mirror:get_read_only_data("achievement_reward_levels")

	if achievement_reward_levels then
		achievement_reward_levels = cjson.decode(achievement_reward_levels)

		return achievement_reward_levels[achievement_id]
	end
end

BackendInterfaceStatisticsPlayFab.reset = function (self)
	-- function 16
	local player_manager = Managers.player

	if not player_manager then
		print("[BackendInterfaceStatisticsPlayFab] No player manager, skipping resetting statistics...")

		return false
	end

	local player = player_manager:local_player()

	if not player then
		print("[BackendInterfaceStatisticsPlayFab] No player found, skipping resetting statistics...")

		return false
	end

	local player_stats_id = player:stats_id()
	local stats_database = Managers.player:statistics_db()
	local player_stats = stats_database:get_all_stats(player_stats_id)
	local player_stats_flattened = flatten_stats(player_stats)
	local stats_to_reset = {}

	for name, properties in pairs(player_stats_flattened) do
		if properties.database_name and properties.source == nil then
			stats_to_reset[#stats_to_reset + 1] = properties.database_name
		end
	end

	local request = {
		FunctionName = "devResetPlayerStatistics",
		FunctionParameter = {
			stats = stats_to_reset
		}
	}

	local function success_callback(result)
		-- function 17
		print("[BackendInterfaceStatisticsPlayFab] Player statistics resetted!")
	end

	self._request_queue:enqueue(request, success_callback)
end
