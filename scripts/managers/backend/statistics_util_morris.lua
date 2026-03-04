-- chunkname: @scripts/managers/backend/statistics_util_morris.lua

StatisticsUtil.register_open_shrine = function (arg_1_0)
	local var_1_0 = Managers.player
	local var_1_1 = var_1_0:local_player()
	local var_1_2 = var_1_0:statistics_db()
	local var_1_3 = var_1_1:stats_id()

	var_1_2:increment_stat(var_1_3, "opened_shrines", arg_1_0)
end
