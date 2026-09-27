-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/rat_ogre/rat_ogre_state_walking.lua

RatOgreStateWalking = class(RatOgreStateWalking, EnemyCharacterStateWalking)

RatOgreStateWalking.init = function (self, arg_1_1)
	-- function 1
	RatOgreStateWalking.super.init(self, arg_1_1)

	self._ogre_jump_ability_id = self._career_extension:ability_id("ogre_jump")
end

RatOgreStateWalking.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	RatOgreStateWalking.super.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
end

RatOgreStateWalking.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self:common_state_changes() then
		return
	end

	local _csm = self._csm
	local _status_extension = self._status_extension
	local _career_extension = self._career_extension
	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()

	self:_update_taunt_dialogue(arg_3_5)

	if not self:common_movement(is_in_ghost_mode, arg_3_3) then
		CharacterStateHelper.update_weapon_actions(arg_3_5, arg_3_1, self._input_extension, self._inventory_extension, self._health_extension)
	end
end
