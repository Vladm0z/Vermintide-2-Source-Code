-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/warpfire_thrower/warpfire_thrower_state_standing.lua

WarpfireThrowerStateStanding = class(WarpfireThrowerStateStanding, EnemyCharacterStateStanding)

WarpfireThrowerStateStanding.on_enter = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	-- function 1
	WarpfireThrowerStateStanding.super.on_enter(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)

	local vs_warpfire_thrower = PlayerBreeds.vs_warpfire_thrower

	self.blackboard = BLACKBOARDS[self._unit]

	local warpfire_data = self.blackboard.warpfire_data

	warpfire_data = warpfire_data or {
		aim_rotation_override_speed_multiplier = 1.5,
		aim_rotation_override_distance = 3,
		warpfire_follow_target_speed = 0.75,
		muzzle_node = "p_fx",
		buff_name_close = "vs_warpfire_thrower_short_distance_damage",
		buff_name_far = "vs_warpfire_thrower_long_distance_damage",
		aim_rotation_dodge_multipler = 0.15,
		attack_range = vs_warpfire_thrower.shoot_warpfire_attack_range,
		close_attack_range = vs_warpfire_thrower.shoot_warpfire_close_attack_range,
		close_attack_cooldown = vs_warpfire_thrower.shoot_warpfire_close_attack_cooldown,
		hit_radius = vs_warpfire_thrower.shoot_warpfire_close_attack_hit_radius,
		target_position = Vector3Box(0, 0, 0)
	}
	warpfire_data.is_firing = false
	self._is_firing = false

	local peer_id = warpfire_data.peer_id

	peer_id = peer_id or Network.peer_id()
	warpfire_data.peer_id = peer_id
	self.blackboard.warpfire_data = warpfire_data
	self._fire_ability_id = self._career_extension:ability_id("fire")
	self._left_wpn_particle_node_name = "p_fx"
	self._left_wpn_particle_name = "fx/wpnfx_gunner_enemy_in_range_1p"
end

WarpfireThrowerStateStanding.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self:common_state_changes() then
		return
	end

	self:_update_taunt_dialogue(arg_2_5)

	if not self:common_movement(arg_2_5) then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, self._input_extension, self._inventory_extension, self._health_extension)
	end
end
