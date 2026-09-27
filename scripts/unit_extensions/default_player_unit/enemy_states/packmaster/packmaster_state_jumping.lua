-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_jumping.lua

PackmasterStateJumping = class(PackmasterStateJumping, EnemyCharacterStateJumping)

PackmasterStateJumping.init = function (self, arg_1_1)
	-- function 1
	PackmasterStateJumping.super.init(self, arg_1_1)

	self._grab_ability_id = self._career_extension:ability_id("grab")
end

PackmasterStateJumping.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self:common_state_changes() then
		return
	end

	local _csm = self._csm

	if not self._career_extension:ability_was_triggered(self._grab_ability_id) then
		_csm:change_state("packmaster_grabbing")

		return
	end

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local common_movement = self:common_movement(is_in_ghost_mode, arg_2_3, arg_2_1)
end
