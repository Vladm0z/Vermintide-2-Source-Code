-- chunkname: @scripts/managers/backend/statistics_util_morris.lua

StatisticsUtil.register_open_shrine = function (arg_1_0)
	-- function 1
	local player = Managers.player
	local local_player = player:local_player()
	local statistics_db = player:statistics_db()
	local stats_id = local_player:stats_id()

	statistics_db:increment_stat(stats_id, "opened_shrines", arg_1_0)
end
