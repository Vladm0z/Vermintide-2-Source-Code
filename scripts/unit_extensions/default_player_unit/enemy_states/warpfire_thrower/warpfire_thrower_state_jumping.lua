-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/warpfire_thrower/warpfire_thrower_state_jumping.lua

WarpfireThrowerStateJumping = class(WarpfireThrowerStateJumping, EnemyCharacterStateJumping)

WarpfireThrowerStateJumping.init = function (self, arg_1_1)
	-- function 1
	WarpfireThrowerStateJumping.super.init(self, arg_1_1)

	self._fire_ability_id = self._career_extension:ability_id("fire")
end

WarpfireThrowerStateJumping.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self:common_state_changes() then
		return
	end

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()

	if not self:common_movement(is_in_ghost_mode, arg_2_3, arg_2_1) then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, self._input_extension, self._inventory_extension, self._health_extension)
	end
end
