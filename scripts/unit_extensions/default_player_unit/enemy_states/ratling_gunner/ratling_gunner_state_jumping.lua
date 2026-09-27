-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/ratling_gunner/ratling_gunner_state_jumping.lua

RatlingGunnerStateJumping = class(RatlingGunnerStateJumping, EnemyCharacterStateJumping)

RatlingGunnerStateJumping.init = function (self, arg_1_1)
	-- function 1
	RatlingGunnerStateJumping.super.init(self, arg_1_1)

	self._fire_ability_id = self._career_extension:ability_id("fire")
	self._reload_ability_id = self._career_extension:ability_id("reload")
end

RatlingGunnerStateJumping.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local common_state_changes = self:common_state_changes()

	if not common_state_changes then
		return
	end

	local _csm = self._csm
	local _career_extension = self._career_extension

	if not common_state_changes then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, self._input_extension, self._inventory_extension, self._health_extension)
	end

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local common_movement = self:common_movement(is_in_ghost_mode, arg_2_3, arg_2_1)
end

RatlingGunnerStateJumping.debug_display_ammo = function (self)
	-- function 3
	local _unit = self._unit
	local attack_pattern_data = BLACKBOARDS[_unit].attack_pattern_data

	attack_pattern_data = attack_pattern_data or {}

	local current_ammo = attack_pattern_data.current_ammo

	current_ammo = current_ammo or self._breed.max_ammo

	local res_w = RESOLUTION_LOOKUP.res_w
	local num = RESOLUTION_LOOKUP.res_h * 0.85
	local num_2 = res_w * 0.87
	local var_3_6 = Color(100, 255, 0)
	local var_3_7 = Vector3(num_2, num, 10)
	local num_3 = 40
	local format = string.format("Ammo: %2d", current_ammo)

	Debug.draw_text(format, var_3_7, num_3, var_3_6)
end
