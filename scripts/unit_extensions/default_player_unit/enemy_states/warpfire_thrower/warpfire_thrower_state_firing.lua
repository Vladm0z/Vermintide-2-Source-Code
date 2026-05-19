-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/warpfire_thrower/warpfire_thrower_state_firing.lua

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

WarpfireThrowerStateFiring = class(WarpfireThrowerStateFiring, EnemyCharacterState)

function WarpfireThrowerStateFiring.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "warpfire_firing")

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
end

local var_0_1 = POSITION_LOOKUP

function WarpfireThrowerStateFiring.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0._temp_params)

	arg_2_0._unit_id = Managers.state.network.unit_storage:go_id(arg_2_1)

	local var_2_0 = Unit.get_data(arg_2_1, "breed")

	arg_2_0._breed = var_2_0
	arg_2_0._blackboard = BLACKBOARDS[arg_2_1]

	local var_2_1 = Vector3(0, 0, 0)

	CharacterStateHelper.play_animation_event(arg_2_1, "attack_shoot_start")
	CharacterStateHelper.play_animation_event_first_person(arg_2_0._first_person_extension, "attack_shoot_start")

	arg_2_0._done_priming = false
	arg_2_0._prime_time = arg_2_5 + var_2_0.shoot_warpfire_prime_time
	arg_2_0._max_prime_time = var_2_0.shoot_warpfire_prime_time
	arg_2_0._max_flame_time = var_2_0.shoot_warpfire_max_flame_time
	arg_2_0._current_flame_time = 0
	arg_2_0._wind_up_movement_speed = var_2_0.shoot_warpfire_wind_up_movement_speed
	arg_2_0.shoot_warpfire_movement_speed_mod = var_2_0.shoot_warpfire_movement_speed_mod

	if arg_2_0._first_person_extension then
		arg_2_0.first_person_unit = arg_2_0._first_person_extension:get_first_person_unit()
	end

	arg_2_0.blackboard = BLACKBOARDS[arg_2_0._unit]

	local var_2_2 = arg_2_0.blackboard.warpfire_data or {
		aim_rotation_override_speed_multiplier = 1.5,
		aim_rotation_override_distance = 3,
		warpfire_follow_target_speed = 0.75,
		muzzle_node = "p_fx",
		buff_name_close = "vs_warpfire_thrower_short_distance_damage",
		buff_name_far = "vs_warpfire_thrower_long_distance_damage",
		aim_rotation_dodge_multipler = 0.15,
		attack_range = var_2_0.shoot_warpfire_attack_range,
		close_attack_range = var_2_0.shoot_warpfire_close_attack_range,
		close_attack_cooldown = var_2_0.shoot_warpfire_close_attack_cooldown,
		hit_radius = var_2_0.shoot_warpfire_close_attack_hit_radius,
		target_position = Vector3Box(0, 0, 0)
	}

	var_2_2.is_firing = false
	arg_2_0._is_firing = false
	var_2_2.peer_id = var_2_2.peer_id or Network.peer_id()
	arg_2_0.blackboard.warpfire_data = var_2_2
	arg_2_0._create_fire_time = 0
	arg_2_0._gravity = -9.82
	arg_2_0._speed = 17
	arg_2_0._angle = math.degrees_to_radians(math.pi / 4)

	arg_2_0:set_breed_action("shoot_warpfire_thrower")
	Managers.state.entity:system("weapon_system"):change_single_weapon_state(arg_2_1, "windup_start", var_2_2.peer_id)
end

function WarpfireThrowerStateFiring.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0._csm
	local var_3_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_3_1)
	local var_3_2 = arg_3_0._input_extension
	local var_3_3 = arg_3_0._status_extension
	local var_3_4 = arg_3_0._first_person_extension
	local var_3_5 = arg_3_0._locomotion_extension
	local var_3_6 = arg_3_0._inventory_extension

	if not arg_3_0._done_priming then
		arg_3_0:_update_priming(arg_3_1, arg_3_5, arg_3_3)
	end

	if arg_3_0._is_firing then
		arg_3_0:_update_warpfire_attack(arg_3_1, arg_3_5, arg_3_3)
	end

	if arg_3_0._current_flame_time >= arg_3_0._max_flame_time then
		var_3_0:change_state("standing")

		return
	end

	if CharacterStateHelper.do_common_state_transitions(var_3_3, var_3_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_3_3) then
		var_3_0:change_state("using_transport")

		return
	end

	if CharacterStateHelper.is_pushed(var_3_3) then
		var_3_3:set_pushed(false)

		local var_3_7 = var_3_1.stun_settings.pushed

		var_3_7.hit_react_type = var_3_3:hit_react_type() .. "_push"

		var_3_0:change_state("stunned", var_3_7)

		return
	end

	if not var_3_2 then
		return
	end

	if var_3_2:get("action_one_release") or var_3_2:get("action_two") or var_3_2:get("action_two_release") then
		var_3_0:change_state("standing")

		return
	end

	if arg_3_0._done_priming and not arg_3_0._is_firing then
		arg_3_0:_start_firing(arg_3_5)
	end

	arg_3_0:_update_movement(arg_3_1, arg_3_5, arg_3_3)
	CharacterStateHelper.look(arg_3_0._input_extension, arg_3_0._player.viewport_name, arg_3_0._first_person_extension, arg_3_0._status_extension, arg_3_0._inventory_extension)
end

function WarpfireThrowerStateFiring._set_priming_progress(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._career_extension
	local var_4_1 = "fire"
	local var_4_2 = var_4_0:ability_id(var_4_1)

	var_4_0:get_activated_ability_data(var_4_2).priming_progress = arg_4_1
end

function WarpfireThrowerStateFiring._update_priming(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = not arg_5_0._done_priming

	if arg_5_2 > arg_5_0._prime_time then
		arg_5_0._done_priming = true
	end

	if var_5_0 then
		local var_5_1 = arg_5_0._prime_time
		local var_5_2 = arg_5_0._max_prime_time
		local var_5_3 = var_5_2 - (var_5_1 - arg_5_2)
		local var_5_4 = math.clamp(var_5_3 / var_5_2, 0, 1)

		arg_5_0:_set_priming_progress(var_5_4)
		arg_5_0:_update_movement(arg_5_1, arg_5_2, arg_5_3, var_5_4)
	end
end

function WarpfireThrowerStateFiring._start_firing(arg_6_0, arg_6_1)
	arg_6_0:_set_priming_progress(0)

	local var_6_0 = arg_6_0._unit
	local var_6_1 = arg_6_0.blackboard
	local var_6_2 = var_6_1.warpfire_data

	if arg_6_0:_create_warpfire_blob(var_6_0, var_6_2, var_6_1, arg_6_1) then
		var_6_1.close_attack_cooldown = 0
	end

	local var_6_3 = var_6_1.warpfire_data

	var_6_3.is_firing = true
	arg_6_0._is_firing = true
	var_6_3.state = "shoot_start"

	Managers.state.entity:system("weapon_system"):change_single_weapon_state(var_6_0, "shoot_start", var_6_3.peer_id)
end

function WarpfireThrowerStateFiring._stop_priming(arg_7_0)
	local var_7_0 = arg_7_0._unit
	local var_7_1 = arg_7_0._first_person_extension

	CharacterStateHelper.play_animation_event(var_7_0, "idle")
	CharacterStateHelper.play_animation_event(var_7_0, "no_anim_upperbody")
end

function WarpfireThrowerStateFiring._close_range_attack(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = EnemyCharacterStateHelper.get_enemies_in_line_of_sight(arg_8_1, arg_8_0.first_person_unit, arg_8_0._physics_world)

	if not var_8_0 then
		return
	end

	for iter_8_0 = 1, #var_8_0 do
		local var_8_1 = var_8_0[iter_8_0]
		local var_8_2 = var_8_1.unit
		local var_8_3 = DamageUtils.is_enemy(arg_8_1, var_8_2)

		if var_8_3 then
			local var_8_4 = ScriptUnit.has_extension(var_8_2, "buff_system")
			local var_8_5 = var_8_4 and var_8_4:has_buff_perk(var_0_0.power_block)
			local var_8_6 = ScriptUnit.has_extension(var_8_2, "status_system")
			local var_8_7
			local var_8_8

			if var_8_6 then
				var_8_7, var_8_8 = var_8_6:is_blocking()
			end

			if var_8_5 and var_8_7 and var_8_8 then
				var_8_3 = not DamageUtils.check_ranged_block(arg_8_1, var_8_2, "blocked_berzerker")
			end

			if var_8_3 then
				local var_8_9 = var_8_1.distance <= arg_8_3.close_attack_range and arg_8_3.buff_name_close or arg_8_3.buff_name_far
				local var_8_10 = {
					attacker_unit = arg_8_1
				}
				local var_8_11 = Managers.state.entity:system("buff_system")

				var_8_11:add_buff_synced(var_8_2, var_8_9, BuffSyncType.All, var_8_10)
				var_8_11:add_buff_synced(var_8_2, "warpfire_thrower_fire_slowdown", BuffSyncType.All, var_8_10)
			end
		end
	end
end

local function var_0_2(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0 = arg_9_2 / arg_9_1

	for iter_9_0 = 1, arg_9_1 do
		local var_9_1 = arg_9_3 + arg_9_4 * var_9_0
		local var_9_2 = var_9_1 - arg_9_3
		local var_9_3 = Vector3.normalize(var_9_2)
		local var_9_4 = Vector3.length(var_9_2)
		local var_9_5, var_9_6, var_9_7, var_9_8, var_9_9 = PhysicsWorld.immediate_raycast(arg_9_0, arg_9_3, var_9_3, var_9_4, "closest", "collision_filter", arg_9_6)

		if var_9_6 then
			return var_9_5, var_9_6, var_9_7, var_9_8, var_9_9
		end

		arg_9_4 = arg_9_4 + arg_9_5 * var_9_0
		arg_9_3 = var_9_1
	end

	return false, arg_9_3
end

function WarpfireThrowerStateFiring._update_warpfire_attack(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0._current_flame_time = arg_10_0._current_flame_time + arg_10_3

	local var_10_0 = arg_10_0.blackboard
	local var_10_1 = var_10_0.warpfire_data

	if arg_10_2 > var_10_0.close_attack_cooldown then
		arg_10_0:_close_range_attack(arg_10_1, var_10_0, var_10_1, arg_10_2)

		var_10_0.close_attack_cooldown = arg_10_2 + var_10_1.close_attack_cooldown
	end
end

local var_0_3 = false

function WarpfireThrowerStateFiring.hit_ground_at(arg_11_0)
	local var_11_0 = var_0_1[arg_11_0._unit]
	local var_11_1 = var_0_1[arg_11_0.first_person_unit]
	local var_11_2 = Unit.world_rotation(arg_11_0.first_person_unit, 0)
	local var_11_3
	local var_11_4 = 10
	local var_11_5 = 1.5
	local var_11_6 = arg_11_0._speed
	local var_11_7 = arg_11_0._angle
	local var_11_8 = Quaternion.forward(Quaternion.multiply(var_11_2, Quaternion(Vector3.right(), var_11_7))) * var_11_6
	local var_11_9 = Vector3(0, 0, arg_11_0._gravity)
	local var_11_10 = "filter_geiser_check"
	local var_11_11, var_11_12, var_11_13, var_11_14 = var_0_2(arg_11_0._physics_world, var_11_4, var_11_5, var_11_1, var_11_8, var_11_9, var_11_10, var_0_3)
	local var_11_15 = var_11_12

	if var_11_11 then
		local var_11_16 = Vector3(0, 0, 1)

		if Vector3.dot(var_11_14, var_11_16) < 0.75 then
			local var_11_17 = var_11_15 - 1 * Vector3.normalize(var_11_15 - var_11_0)
			local var_11_18, var_11_19, var_11_20, var_11_21 = PhysicsWorld.immediate_raycast(arg_11_0._physics_world, var_11_17, Vector3(0, 0, -1), 5, "closest", "collision_filter", var_11_10)

			if var_11_19 then
				var_11_15 = var_11_19
			end
		end
	end

	return var_11_15, var_11_0
end

function WarpfireThrowerStateFiring._move_warpfire_blob(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_2.blob_unit
	local var_12_1 = var_0_1[var_12_0]

	if var_12_0 and var_12_1 then
		local var_12_2 = var_0_1[arg_12_1]
		local var_12_3 = arg_12_2.target_position:unbox()
		local var_12_4 = Vector3.flat(var_12_3 - var_12_2)
		local var_12_5 = Vector3.length(var_12_4)
		local var_12_6
		local var_12_7
		local var_12_8 = arg_12_2.close_attack_range
		local var_12_9 = arg_12_2.warpfire_follow_target_speed

		if var_12_8 < var_12_5 then
			var_12_6 = math.min(arg_12_4 * var_12_9, 1)
			var_12_7 = var_12_3
		else
			var_12_6 = math.min(arg_12_4 * var_12_9 * 6, 1)
			var_12_7 = var_12_2 + Vector3.normalize(var_12_3 - var_12_2) * var_12_8
		end

		local var_12_10 = Vector3.lerp(var_12_1, var_12_7, var_12_6)

		Unit.set_local_position(var_12_0, 0, var_12_10)
	end
end

function WarpfireThrowerStateFiring._create_warpfire_blob(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_3.warpfire_data
	local var_13_1 = arg_13_3.weapon_unit
	local var_13_2, var_13_3 = arg_13_0:hit_ground_at()

	if not var_13_2 then
		return false
	end

	var_13_0.target_position:store(var_13_2)

	local var_13_4 = {
		area_damage_system = {
			damage_blob_template_name = "warpfire_vs",
			source_unit = arg_13_1
		}
	}
	local var_13_5 = "units/hub_elements/empty"
	local var_13_6 = Managers.state.unit_spawner:spawn_network_unit(var_13_5, "damage_blob_unit", var_13_4, var_13_2)
	local var_13_7 = ScriptUnit.extension(var_13_6, "area_damage_system")

	var_13_0.blob_unit = var_13_6
	var_13_0.blob_extension = var_13_7

	local var_13_8 = Vector3.length(var_13_2 - var_13_3) / 10

	var_13_7:start_placing_blobs(var_13_8, arg_13_4)

	arg_13_0._create_fire_time = arg_13_4 + 9999999

	return true
end

function WarpfireThrowerStateFiring.on_exit(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	if not Managers.state.network:in_game_session() then
		return
	end

	local var_14_0 = arg_14_0._csm
	local var_14_1 = arg_14_0._status_extension
	local var_14_2 = arg_14_0._locomotion_extension
	local var_14_3 = arg_14_0._first_person_extension

	CharacterStateHelper.play_animation_event_first_person(var_14_3, "attack_finished")
	CharacterStateHelper.play_animation_event(arg_14_1, "no_anim_upperbody")

	local var_14_4 = arg_14_0.blackboard.warpfire_data

	if var_14_4.is_firing then
		local var_14_5 = math.clamp((arg_14_0._max_flame_time - arg_14_0._current_flame_time) / arg_14_0._max_flame_time - arg_14_0._breed.shoot_warpfire_minimum_forced_cooldown, 0, 1)

		arg_14_0._career_extension:start_activated_ability_cooldown(1, var_14_5)
		Managers.state.entity:system("weapon_system"):change_single_weapon_state(arg_14_1, "shoot_end", var_14_4.peer_id)

		var_14_4.is_firing = false

		CharacterStateHelper.play_animation_event_first_person(var_14_3, "wind_up_start")
		CharacterStateHelper.play_animation_event(arg_14_1, "wind_up_start")
		var_14_3:play_hud_sound_event("player_enemy_warpfire_steam_after_flame_start")
	end

	if var_14_4.blob_extension then
		var_14_4.blob_extension:stop_placing_blobs(arg_14_5)
	end

	arg_14_0._max_flame_time = nil
	arg_14_0._done_priming = false
	arg_14_0._prime_time = nil
	arg_14_0._current_flame_time = nil

	arg_14_0:set_breed_action("n/a")
	arg_14_0:_set_priming_progress(0)
end

function WarpfireThrowerStateFiring._update_movement(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_0._input_extension
	local var_15_1 = arg_15_0._buff_extension
	local var_15_2 = arg_15_0._first_person_extension
	local var_15_3 = PlayerUnitMovementSettings.get_movement_settings_table(arg_15_1)
	local var_15_4 = CharacterStateHelper.get_movement_input(var_15_0)
	local var_15_5 = CharacterStateHelper.has_move_input(var_15_0)
	local var_15_6 = arg_15_0.current_movement_speed_scale

	if not arg_15_0.is_bot then
		local var_15_7 = arg_15_0._breed and arg_15_0._breed.breed_move_acceleration_up
		local var_15_8 = arg_15_0._breed and arg_15_0._breed.breed_move_acceleration_down
		local var_15_9 = var_15_7 * arg_15_3 or var_15_3.move_acceleration_up * arg_15_3
		local var_15_10 = var_15_8 * arg_15_3 or var_15_3.move_acceleration_down * arg_15_3

		if var_15_5 then
			var_15_6 = math.min(1, var_15_6 + var_15_9)
		else
			var_15_6 = math.max(0, var_15_6 - var_15_10)
		end
	else
		var_15_6 = var_15_5 and 1 or 0
	end

	local var_15_11 = 1
	local var_15_12 = arg_15_0._is_firing and 1 or arg_15_0._career_extension:get_activated_ability_data(1).priming_progress
	local var_15_13 = math.lerp(arg_15_0._wind_up_movement_speed.start, arg_15_0._wind_up_movement_speed.finish, var_15_12^arg_15_0._wind_up_movement_speed.rate)
	local var_15_14 = var_15_1:apply_buffs_to_value(var_15_13, "movement_speed") * var_15_6 * var_15_3.player_speed_scale * arg_15_0.shoot_warpfire_movement_speed_mod
	local var_15_15 = Vector3(0, 0, 0)

	if var_15_4 then
		var_15_15 = var_15_15 + var_15_4
	end

	local var_15_16
	local var_15_17 = Vector3.normalize(var_15_15)

	if Vector3.length(var_15_17) == 0 then
		var_15_17 = arg_15_0.last_input_direction:unbox()
	else
		arg_15_0.last_input_direction:store(var_15_17)
	end

	local var_15_18 = CharacterStateHelper.get_move_animation(arg_15_0._locomotion_extension, var_15_0, arg_15_0._status_extension, arg_15_0.move_anim_3p)

	if var_15_18 ~= arg_15_0.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_15_1, var_15_18)

		arg_15_0.move_anim_3p = var_15_18
	end

	if arg_15_0._previous_state == "jumping" or arg_15_0._previous_state == "falling" then
		CharacterStateHelper.move_in_air_pactsworn(arg_15_0._first_person_extension, var_15_0, arg_15_0._locomotion_extension, var_15_14, arg_15_1)
	else
		CharacterStateHelper.move_on_ground(var_15_2, var_15_0, arg_15_0._locomotion_extension, var_15_17, var_15_14, arg_15_1)
	end

	CharacterStateHelper.look(var_15_0, arg_15_0._player.viewport_name, var_15_2, arg_15_0._status_extension, arg_15_0._inventory_extension)

	arg_15_0.current_movement_speed_scale = var_15_6

	if arg_15_2 > arg_15_0._prime_time then
		arg_15_0._done_priming = true
		arg_15_0._is_priming = false
	end
end
