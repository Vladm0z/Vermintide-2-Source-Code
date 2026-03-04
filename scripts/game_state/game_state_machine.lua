-- chunkname: @scripts/game_state/game_state_machine.lua

require("foundation/scripts/util/state_machine")

GameStateMachine = class(GameStateMachine, StateMachine)

GameStateMachine.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._notify_mod_manager = arg_1_3.notify_mod_manager

	arg_1_0.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
end

GameStateMachine._change_state = function (arg_2_0, arg_2_1, ...)
	local var_2_0 = arg_2_0._notify_mod_manager
	local var_2_1 = arg_2_0._state

	if var_2_0 and var_2_1 then
		Managers.mod:on_game_state_changed("exit", var_2_1.NAME, var_2_1)
	end

	arg_2_0.super._change_state(arg_2_0, arg_2_1, ...)

	local var_2_2 = arg_2_0._state

	if var_2_0 then
		Managers.mod:on_game_state_changed("enter", var_2_2.NAME, var_2_2)
	end
end

GameStateMachine.pre_update = function (arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0._state and arg_3_0._state.pre_update then
		arg_3_0._state:pre_update(arg_3_1, arg_3_2)
	end
end

GameStateMachine.post_update = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._state and arg_4_0._state.post_update then
		arg_4_0._state:post_update(arg_4_1, arg_4_2)
	end
end

GameStateMachine.pre_render = function (arg_5_0)
	if arg_5_0._state and arg_5_0._state.pre_render then
		arg_5_0._state:pre_render()
	end
end

GameStateMachine.render = function (arg_6_0)
	if arg_6_0._state and arg_6_0._state.render then
		arg_6_0._state:render()
	end
end

GameStateMachine.post_render = function (arg_7_0)
	if arg_7_0._state and arg_7_0._state.post_render then
		arg_7_0._state:post_render()
	end
end

GameStateMachine.destroy = function (arg_8_0, ...)
	local var_8_0 = arg_8_0._state

	if arg_8_0._notify_mod_manager and var_8_0 then
		Managers.mod:on_game_state_changed("exit", var_8_0.NAME)
	end

	arg_8_0.super.destroy(arg_8_0, ...)
end
