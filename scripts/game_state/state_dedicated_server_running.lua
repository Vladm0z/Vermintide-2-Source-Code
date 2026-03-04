-- chunkname: @scripts/game_state/state_dedicated_server_running.lua

StateDedicatedServerRunning = class(StateDedicatedServerRunning)
StateDedicatedServerRunning.NAME = "StateDedicatedServerRunning"

StateDedicatedServerRunning.on_enter = function (arg_1_0, arg_1_1)
	arg_1_0._game_server = arg_1_0.parent.parent.loading_context.game_server
end

StateDedicatedServerRunning.update = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0._game_server
	local var_2_1 = var_2_0:state()
	local var_2_2 = var_2_0:update(arg_2_1, arg_2_2)

	if var_2_1 ~= var_2_2 and var_2_2 == GameServerState.DISCONNECTED then
		error("DISCONNECTED, RESTART!")
	end
end

StateDedicatedServerRunning.on_exit = function (arg_3_0)
	return
end
