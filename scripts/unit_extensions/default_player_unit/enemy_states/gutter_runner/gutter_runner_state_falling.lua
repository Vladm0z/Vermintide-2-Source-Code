-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_falling.lua

GutterRunnerStateFalling = class(GutterRunnerStateFalling, EnemyCharacterStateFalling)

function GutterRunnerStateFalling.init(arg_1_0, arg_1_1)
	GutterRunnerStateFalling.super.init(arg_1_0, arg_1_1)
end

function GutterRunnerStateFalling.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0._ghost_mode_extension:is_in_ghost_mode()
	local var_2_1 = arg_2_0:common_movement(var_2_0, arg_2_3, arg_2_1)
end
