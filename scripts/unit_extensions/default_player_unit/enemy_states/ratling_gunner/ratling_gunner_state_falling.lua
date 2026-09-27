-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/ratling_gunner/ratling_gunner_state_falling.lua

RatlingGunnerStateFalling = class(RatlingGunnerStateFalling, EnemyCharacterStateFalling)

RatlingGunnerStateFalling.init = function (self, arg_1_1)
	-- function 1
	RatlingGunnerStateFalling.super.init(self, arg_1_1)

	self._fire_ability_id = self._career_extension:ability_id("fire")
	self._reload_ability_id = self._career_extension:ability_id("reload")
end

RatlingGunnerStateFalling.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local _csm = self._csm
	local _career_extension = self._career_extension

	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, self._input_extension, self._inventory_extension, self._health_extension)

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local common_movement = self:common_movement(is_in_ghost_mode, arg_2_3, arg_2_1)
end
