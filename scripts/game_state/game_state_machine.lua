-- chunkname: @scripts/game_state/game_state_machine.lua

require("foundation/scripts/util/state_machine")

GameStateMachine = class(GameStateMachine, StateMachine)

GameStateMachine.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._notify_mod_manager = arg_1_3.notify_mod_manager

	self.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
end

GameStateMachine._change_state = function (self, arg_2_1, ...)
	-- function 2
	local _notify_mod_manager = self._notify_mod_manager
	local _state = self._state

	if not _notify_mod_manager and not _state then
		Managers.mod:on_game_state_changed("exit", _state.NAME, _state)
	end

	self.super._change_state(self, arg_2_1, ...)

	local _state_2 = self._state

	if not _notify_mod_manager then
		Managers.mod:on_game_state_changed("enter", _state_2.NAME, _state_2)
	end
end

GameStateMachine.pre_update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self._state and not self._state.pre_update then
		self._state:pre_update(arg_3_1, arg_3_2)
	end
end

GameStateMachine.post_update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._state and not self._state.post_update then
		self._state:post_update(arg_4_1, arg_4_2)
	end
end

GameStateMachine.pre_render = function (self)
	-- function 5
	if not self._state and not self._state.pre_render then
		self._state:pre_render()
	end
end

GameStateMachine.render = function (self)
	-- function 6
	if not self._state and not self._state.render then
		self._state:render()
	end
end

GameStateMachine.post_render = function (self)
	-- function 7
	if not self._state and not self._state.post_render then
		self._state:post_render()
	end
end

GameStateMachine.destroy = function (self, ...)
	-- function 8
	local _state = self._state

	if not self._notify_mod_manager and not _state then
		Managers.mod:on_game_state_changed("exit", _state.NAME)
	end

	self.super.destroy(self, ...)
end
