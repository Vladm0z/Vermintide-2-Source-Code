-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/chaos_troll/chaos_troll_state_standing.lua

ChaosTrollStateStanding = class(ChaosTrollStateStanding, EnemyCharacterStateStanding)

ChaosTrollStateStanding.init = function (self, arg_1_1)
	-- function 1
	ChaosTrollStateStanding.super.init(self, arg_1_1)

	self._vomit_ability_id = self._career_extension:ability_id("vomit")
end

ChaosTrollStateStanding.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	ChaosTrollStateStanding.super.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
end

ChaosTrollStateStanding.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self:common_state_changes() then
		return
	end

	local _csm = self._csm

	if not self._career_extension:ability_was_triggered(self._vomit_ability_id) then
		_csm:change_state("troll_vomiting")

		return
	end

	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local is_crouching = _status_extension:is_crouching()
	local toggle_crouch = _input_extension.toggle_crouch

	CharacterStateHelper.check_crouch(arg_3_1, _input_extension, _status_extension, toggle_crouch, _first_person_extension, arg_3_5)
	self:_update_taunt_dialogue(arg_3_5)

	if not self:common_movement(arg_3_5) then
		CharacterStateHelper.update_weapon_actions(arg_3_5, arg_3_1, self._input_extension, self._inventory_extension, self._health_extension)
	end
end
