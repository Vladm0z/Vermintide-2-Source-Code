-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/chaos_troll/chaos_troll_state_walking.lua

ChaosTrollStateWalking = class(ChaosTrollStateWalking, EnemyCharacterStateWalking)

ChaosTrollStateWalking.init = function (self, arg_1_1)
	-- function 1
	ChaosTrollStateWalking.super.init(self, arg_1_1)

	self._vomit_ability_id = self._career_extension:ability_id("vomit")
end

ChaosTrollStateWalking.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self:common_state_changes() then
		return
	end

	local _csm = self._csm

	if not self._career_extension:ability_was_triggered(self._vomit_ability_id) then
		_csm:change_state("troll_vomiting")

		return
	end

	self:_update_taunt_dialogue(arg_2_5)

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local is_crouching = _status_extension:is_crouching()
	local toggle_crouch = _input_extension.toggle_crouch

	CharacterStateHelper.check_crouch(arg_2_1, _input_extension, _status_extension, toggle_crouch, _first_person_extension, arg_2_5)

	if not self:common_movement(is_in_ghost_mode, arg_2_3) then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, self._input_extension, self._inventory_extension, self._health_extension)
	end
end
