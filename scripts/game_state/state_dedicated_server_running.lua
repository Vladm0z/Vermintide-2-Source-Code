-- chunkname: @scripts/game_state/state_dedicated_server_running.lua

StateDedicatedServerRunning = class(StateDedicatedServerRunning)
StateDedicatedServerRunning.NAME = "StateDedicatedServerRunning"

StateDedicatedServerRunning.on_enter = function (self, params)
	-- function 1
	local loading_context = self.parent.parent.loading_context

	self._game_server = loading_context.game_server
end

StateDedicatedServerRunning.update = function (self, dt, t)
	-- function 2
	local game_server = self._game_server
	local old_state = game_server:state()
	local new_state = game_server:update(dt, t)

	if old_state ~= new_state and new_state == GameServerState.DISCONNECTED then
		error("DISCONNECTED, RESTART!")
	end
end

StateDedicatedServerRunning.on_exit = function (self)
	-- function 3
	return
end
