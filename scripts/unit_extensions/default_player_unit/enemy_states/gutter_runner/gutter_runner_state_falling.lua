-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_falling.lua

GutterRunnerStateFalling = class(GutterRunnerStateFalling, EnemyCharacterStateFalling)

GutterRunnerStateFalling.init = function (arg_1_0, arg_1_1)
	-- function 1
	GutterRunnerStateFalling.super.init(arg_1_0, arg_1_1)
end

GutterRunnerStateFalling.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local common_movement = self:common_movement(is_in_ghost_mode, arg_2_3, arg_2_1)
end
