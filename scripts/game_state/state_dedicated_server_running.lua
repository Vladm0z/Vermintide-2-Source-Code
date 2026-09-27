-- chunkname: @scripts/game_state/state_dedicated_server_running.lua

StateDedicatedServerRunning = class(StateDedicatedServerRunning)
StateDedicatedServerRunning.NAME = "StateDedicatedServerRunning"

StateDedicatedServerRunning.on_enter = function (self, arg_1_1)
	-- function 1
	self._game_server = self.parent.parent.loading_context.game_server
end

StateDedicatedServerRunning.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	local _game_server = self._game_server
	local state = _game_server:state()
	local update = _game_server:update(arg_2_1, arg_2_2)

	if not (state == update or update ~= GameServerState.DISCONNECTED) then
		error("DISCONNECTED, RESTART!")
	end
end

StateDedicatedServerRunning.on_exit = function (arg_3_0)
	-- function 3
	return
end
