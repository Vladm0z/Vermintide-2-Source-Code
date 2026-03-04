-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/warpfire_thrower/warpfire_thrower_state_walking.lua

WarpfireThrowerStateWalking = class(WarpfireThrowerStateWalking, EnemyCharacterStateWalking)

WarpfireThrowerStateWalking.on_enter = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	WarpfireThrowerStateWalking.super.on_enter(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)

	local var_1_0 = PlayerBreeds.vs_warpfire_thrower

	arg_1_0.blackboard = BLACKBOARDS[arg_1_0._unit]

	local var_1_1 = arg_1_0.blackboard.warpfire_data or {
		aim_rotation_override_speed_multiplier = 1.5,
		aim_rotation_override_distance = 3,
		warpfire_follow_target_speed = 0.75,
		muzzle_node = "p_fx",
		buff_name_close = "vs_warpfire_thrower_short_distance_damage",
		buff_name_far = "vs_warpfire_thrower_long_distance_damage",
		aim_rotation_dodge_multipler = 0.15,
		attack_range = var_1_0.shoot_warpfire_attack_range,
		close_attack_range = var_1_0.shoot_warpfire_close_attack_range,
		close_attack_cooldown = var_1_0.shoot_warpfire_close_attack_cooldown,
		hit_radius = var_1_0.shoot_warpfire_close_attack_hit_radius,
		target_position = Vector3Box(0, 0, 0)
	}

	var_1_1.is_firing = false
	arg_1_0._is_firing = false
	var_1_1.peer_id = var_1_1.peer_id or Network.peer_id()
	arg_1_0.blackboard.warpfire_data = var_1_1
	arg_1_0._fire_ability_id = arg_1_0._career_extension:ability_id("fire")
	arg_1_0._left_wpn_particle_node_name = "p_fx"
	arg_1_0._left_wpn_particle_name = "fx/wpnfx_gunner_enemy_in_range_1p"
end

WarpfireThrowerStateWalking.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0:common_state_changes() then
		return
	end

	arg_2_0:_update_taunt_dialogue(arg_2_5)

	local var_2_0 = arg_2_0._ghost_mode_extension:is_in_ghost_mode()

	if not arg_2_0:common_movement(var_2_0, arg_2_3) then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, arg_2_0._input_extension, arg_2_0._inventory_extension, arg_2_0._health_extension)
	end
end
