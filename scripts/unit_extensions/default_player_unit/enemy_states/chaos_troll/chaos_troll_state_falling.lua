-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/chaos_troll/chaos_troll_state_falling.lua

ChaosTrollStateFalling = class(ChaosTrollStateFalling, EnemyCharacterStateFalling)

ChaosTrollStateFalling.init = function (arg_1_0, arg_1_1)
	-- function 1
	ChaosTrollStateFalling.super.init(arg_1_0, arg_1_1)
end

ChaosTrollStateFalling.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()

	if not self:common_movement(is_in_ghost_mode, arg_2_3, arg_2_1) then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, self._input_extension, self._inventory_extension, self._health_extension)
	end
end
