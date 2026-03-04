-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/poison_wind_globadier/poison_wind_globadier_state_throwing.lua

PoisonWindGlobadierStateThrowing = class(PoisonWindGlobadierStateThrowing, EnemyCharacterState)

function PoisonWindGlobadierStateThrowing.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "globadier_throwing")

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
	arg_1_0._angle = 0
	arg_1_0._position = Vector3Box()
	arg_1_0._spline = nil
	arg_1_0._num_segments = 0
	arg_1_0._indicator_fx_unit_name = "fx/units/aoe_globadier"
	arg_1_0._impact_data = {}
	arg_1_0._right_wpn_particle_name = "fx/wpnfx_globadier_enemy_in_range_1p"
	arg_1_0._right_wpn_particle_node_name = "e_globe"
end

local var_0_0 = POSITION_LOOKUP

function PoisonWindGlobadierStateThrowing.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0._temp_params)

	arg_2_0._unit = arg_2_1
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_1, "first_person_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_1, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_1, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_1, "buff_system")
	arg_2_0._locomotion_extension = ScriptUnit.extension(arg_2_1, "locomotion_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_1, "input_system")
	arg_2_0._inventory_extension = ScriptUnit.has_extension(arg_2_1, "inventory_system")
	arg_2_0._is_server = Managers.player.is_server

	local var_2_0 = Unit.get_data(arg_2_1, "breed")

	arg_2_0._breed = var_2_0
	arg_2_0._previous_state = arg_2_6

	table.clear(arg_2_0._impact_data)

	arg_2_0._impact_data.position = Vector3Box()
	arg_2_0._impact_data.direction = Vector3Box()
	arg_2_0._impact_data.hit_normal = Vector3Box()
	arg_2_0._wind_up_movement_speed = var_2_0.wind_up_movement_speed

	local var_2_1 = arg_2_0._first_person_extension

	var_2_1:unhide_weapons("catapulted")
	CharacterStateHelper.show_inventory_3p(arg_2_1, true, false, arg_2_0._is_server, arg_2_0._inventory_extension)
	CharacterStateHelper.play_animation_event(arg_2_1, "globe_charge")
	CharacterStateHelper.play_animation_event_first_person(var_2_1, "globe_charge")

	arg_2_0._done_priming = false
	arg_2_0._prime_time = arg_2_5 + var_2_0.globe_throw_prime_time
	arg_2_0._max_prime_time = var_2_0.globe_throw_prime_time

	if arg_2_0._first_person_extension then
		arg_2_0._first_person_unit = arg_2_0._first_person_extension:get_first_person_unit()
	end

	arg_2_0:set_breed_action("throw_poison_globe")
end

function PoisonWindGlobadierStateThrowing.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._throw_ready = nil
	arg_3_0._throw_time = nil
	arg_3_0._finish_time = nil
	arg_3_0._done_priming = false
	arg_3_0._prime_time = nil

	arg_3_0:set_breed_action("n/a")
	arg_3_0:_set_priming_progress(0)
	arg_3_0:_destroy_indicator_unit()
end

function PoisonWindGlobadierStateThrowing.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local var_4_2 = arg_4_0._status_extension
	local var_4_3 = arg_4_0._first_person_extension
	local var_4_4 = arg_4_0._locomotion_extension

	if not arg_4_0._done_priming then
		arg_4_0:_update_priming(arg_4_1, arg_4_5, arg_4_3)
	end

	if arg_4_5 > arg_4_0._prime_time then
		arg_4_0._done_priming = true
	end

	if arg_4_0._done_priming then
		if not arg_4_0._throw_time then
			arg_4_0:_calculate_trajectory()
			arg_4_0:_update_indicator_unit()
		end

		arg_4_0:_update_movement(arg_4_1, arg_4_5, arg_4_3)
	end

	local var_4_5 = false

	if ScriptUnit.extension(arg_4_1, "ghost_mode_system"):is_in_ghost_mode() then
		arg_4_0:_stop_priming()

		var_4_5 = true
	elseif arg_4_0._throw_time then
		var_4_5 = arg_4_0:_throw_anim_update(arg_4_5)
	end

	if CharacterStateHelper.do_common_state_transitions(var_4_2, var_4_0) then
		if not var_4_5 then
			arg_4_0:_stop_priming()
		end

		return
	end

	if var_4_5 then
		if var_4_4:is_on_ground() then
			var_4_0:change_state("walking")
			var_4_3:change_state("walking")

			return
		end

		if var_4_4:current_velocity().z <= 0 then
			var_4_0:change_state("falling", arg_4_0._temp_params)
			var_4_3:change_state("falling")

			return
		end

		var_4_3:animation_set_variable("armed", 0)
		var_4_0:change_state("standing")

		return
	end

	if CharacterStateHelper.is_using_transport(var_4_2) then
		var_4_0:change_state("using_transport")

		return
	end

	if CharacterStateHelper.is_pushed(var_4_2) then
		var_4_2:set_pushed(false)

		local var_4_6 = var_4_1.stun_settings.pushed

		var_4_6.hit_react_type = var_4_2:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_6)

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_2) then
		var_4_2:set_block_broken(false)

		local var_4_7 = var_4_1.stun_settings.parry_broken

		var_4_7.hit_react_type = "medium_push"

		var_4_0:change_state("stunned", var_4_7)

		return
	end

	local var_4_8 = arg_4_0._input_extension

	if not var_4_8 then
		return
	end

	local var_4_9 = var_4_8:get("dark_pact_action_one_release")
	local var_4_10 = false

	if var_4_9 then
		arg_4_0._throw_ready = true
	end

	local var_4_11 = var_4_8:get("dark_pact_action_two")

	if var_4_10 or var_4_11 and not arg_4_0._throw_time then
		arg_4_0:_stop_priming()
		var_4_0:change_state("standing")

		return
	end

	if arg_4_0._throw_ready and not arg_4_0._throw_time then
		arg_4_0:_set_throw_start(arg_4_5)
		arg_4_0._career_extension:start_activated_ability_cooldown()
	end

	local var_4_12 = arg_4_0._breed.globe_throw_look_sense

	CharacterStateHelper.look(arg_4_0._input_extension, arg_4_0._player.viewport_name, arg_4_0._first_person_extension, arg_4_0._status_extension, arg_4_0._inventory_extension, var_4_12)
end

function PoisonWindGlobadierStateThrowing._calculate_trajectory(arg_5_0)
	local var_5_0 = arg_5_0._first_person_unit
	local var_5_1 = arg_5_0._breed
	local var_5_2 = Unit.local_rotation(var_5_0, 0)
	local var_5_3 = ActionUtils.pitch_from_rotation(var_5_2)
	local var_5_4 = Unit.node(var_5_0, "root_point")
	local var_5_5 = Unit.world_position(var_5_0, var_5_4)
	local var_5_6 = var_5_5
	local var_5_7 = arg_5_0._position:unbox()

	if Vector3.equal(var_5_5, var_5_7) and var_5_3 == arg_5_0._angle then
		return
	end

	arg_5_0._position:store(var_5_5)

	arg_5_0._angle = var_5_3

	local var_5_8 = math.degrees_to_radians(var_5_3)
	local var_5_9 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_5_2)))
	local var_5_10 = Vector3.normalize(var_5_9 + Vector3(0, 0, var_5_1.globe_throw_upwards_amount))
	local var_5_11 = var_5_1.globe_throw_speed * 0.01
	local var_5_12 = ProjectileGravitySettings.default
	local var_5_13 = arg_5_0._physics_world
	local var_5_14 = 0.5
	local var_5_15 = {
		WeaponHelper:position_on_trajectory(var_5_5, var_5_10, var_5_11, var_5_8, var_5_12, 0)
	}
	local var_5_16 = 0.05
	local var_5_17 = 5
	local var_5_18 = Managers.state.network

	for iter_5_0 = var_5_14, 10, var_5_14 do
		local var_5_19 = WeaponHelper:position_on_trajectory(var_5_5, var_5_10, var_5_11, var_5_8, var_5_12, iter_5_0)
		local var_5_20 = PhysicsWorld.linear_sphere_sweep(var_5_13, var_5_6, var_5_19, var_5_16, var_5_17, "collision_filter", "filter_player_ray_projectile_static_only")
		local var_5_21 = var_5_20 and #var_5_20 or 0

		if var_5_21 > 0 then
			local var_5_22 = false

			for iter_5_1 = 1, var_5_21 do
				local var_5_23 = var_5_20[iter_5_1]
				local var_5_24 = var_5_23.position
				local var_5_25 = var_5_23.normal
				local var_5_26 = var_5_23.actor
				local var_5_27 = var_5_23.distance
				local var_5_28 = Vector3.normalize(var_5_24 - var_5_6)

				if var_5_27 > 0 then
					local var_5_29 = Actor.unit(var_5_26)

					if var_5_18:level_object_id(var_5_29) then
						var_5_15[#var_5_15 + 1] = var_5_24

						local var_5_30 = var_5_6 - WeaponHelper:position_on_trajectory(var_5_5, var_5_10, var_5_11, var_5_8, var_5_12, iter_5_0 + var_5_14)
						local var_5_31 = Vector3.length(var_5_30)
						local var_5_32 = 0.2
						local var_5_33 = iter_5_0 - (var_5_14 - var_5_27 / var_5_31 * var_5_14) + var_5_32
						local var_5_34 = arg_5_0._impact_data

						var_5_34.position:store(var_5_24)
						var_5_34.hit_normal:store(var_5_25)
						var_5_34.direction:store(var_5_28)

						var_5_34.hit_unit = var_5_29

						local var_5_35 = Unit.num_actors(var_5_29)
						local var_5_36 = Unit.actor
						local var_5_37

						for iter_5_2 = 0, var_5_35 - 1 do
							if var_5_26 == var_5_36(var_5_29, iter_5_2) then
								var_5_37 = iter_5_2

								break
							end
						end

						var_5_34.actor_index = var_5_37
						var_5_34.time = var_5_33
						var_5_22 = true

						break
					end
				end
			end

			if var_5_22 then
				break
			end
		end

		var_5_6 = var_5_19
	end

	if #var_5_15 > 1 then
		arg_5_0._spline = SplineCurve:new(var_5_15, "Hermite", "SplineMovementMetered", "GlobadierProjectileTrajectory")
		arg_5_0._num_segments = #var_5_15
	end
end

function PoisonWindGlobadierStateThrowing._update_priming(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_2 > arg_6_0._prime_time then
		arg_6_0._done_priming = true

		arg_6_0:_create_indicator_unit()

		local var_6_0 = arg_6_0._unit
		local var_6_1 = arg_6_0._first_person_extension

		if not arg_6_0._thrown then
			CharacterStateHelper.play_animation_event(var_6_0, "globe_charge_hold")
			CharacterStateHelper.play_animation_event_first_person(var_6_1, "globe_charge_hold")
		end
	end

	if not arg_6_0._done_priming then
		local var_6_2 = arg_6_0._prime_time
		local var_6_3 = arg_6_0._max_prime_time
		local var_6_4 = var_6_3 - (var_6_2 - arg_6_2)
		local var_6_5 = math.clamp(var_6_4 / var_6_3, 0, 1)

		arg_6_0:_set_priming_progress(var_6_5)
		arg_6_0:_update_movement(arg_6_1, arg_6_2, arg_6_3, var_6_5)
	end
end

function PoisonWindGlobadierStateThrowing._set_priming_progress(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._career_extension
	local var_7_1 = "fire"
	local var_7_2 = var_7_0:ability_id(var_7_1)

	var_7_0:get_activated_ability_data(var_7_2).priming_progress = arg_7_1
end

function PoisonWindGlobadierStateThrowing._stop_priming(arg_8_0)
	local var_8_0 = arg_8_0._unit
	local var_8_1 = arg_8_0._first_person_extension

	CharacterStateHelper.play_animation_event(var_8_0, "globe_charge_cancel")
	CharacterStateHelper.play_animation_event_first_person(var_8_1, "globe_charge_cancel")

	arg_8_0._done_priming = false
end

function PoisonWindGlobadierStateThrowing._set_throw_start(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._unit
	local var_9_1 = arg_9_0._breed
	local var_9_2 = arg_9_0._first_person_unit
	local var_9_3 = arg_9_0._first_person_extension

	CharacterStateHelper.play_animation_event(var_9_0, "globe_throw")
	CharacterStateHelper.play_animation_event_first_person(var_9_3, "globe_throw")
	var_9_3:animation_set_variable("armed", 0)

	arg_9_0._throw_time = arg_9_1 + var_9_1.globe_throw_spawn_globe_time
	arg_9_0._finish_time = arg_9_1 + var_9_1.globe_throw_finish_time
	arg_9_0._thrown = false
	arg_9_0._throw_rotation_box = QuaternionBox(Unit.local_rotation(var_9_2, 0))

	local var_9_4 = Unit.node(var_9_2, "j_rightweaponattach")
	local var_9_5 = Unit.world_position(var_9_2, var_9_4)

	arg_9_0._throw_position_box = Vector3Box(var_9_5)
end

function PoisonWindGlobadierStateThrowing._throw_anim_update(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._throw_time

	if var_10_0 and not arg_10_0._thrown and var_10_0 <= arg_10_1 then
		arg_10_0:_throw()
	end

	local var_10_1 = arg_10_0._finish_time

	if var_10_1 and var_10_1 <= arg_10_1 then
		return true
	end

	arg_10_0._locomotion_extension:set_disable_rotation_update()

	return false
end

function PoisonWindGlobadierStateThrowing._throw(arg_11_0)
	local var_11_0 = arg_11_0._unit
	local var_11_1 = arg_11_0._breed

	arg_11_0._first_person_extension:hide_weapons("catapulted")
	CharacterStateHelper.show_inventory_3p(var_11_0, false, true, Managers.player.is_server, arg_11_0._inventory_extension)
	arg_11_0._status_extension:set_unarmed(true)

	local var_11_2 = arg_11_0._throw_rotation_box:unbox()
	local var_11_3 = arg_11_0._throw_position_box:unbox()
	local var_11_4 = ActionUtils.pitch_from_rotation(var_11_2)
	local var_11_5 = var_11_1.globe_throw_speed
	local var_11_6 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_11_2)))
	local var_11_7 = Vector3.normalize(var_11_6 + Vector3(0, 0, var_11_1.globe_throw_upwards_amount))
	local var_11_8 = var_11_1.globe_throw_impact_difficulty_damage
	local var_11_9 = var_11_1.globe_throw_dot_difficulty_damage
	local var_11_10 = var_11_1.globe_throw_dot_damage_interval
	local var_11_11 = Managers.state.difficulty:get_difficulty_rank()
	local var_11_12 = var_11_1.globe_throw_aoe_radius
	local var_11_13 = var_11_1.globe_throw_initial_radius
	local var_11_14 = var_11_1.globe_throw_aoe_life_time
	local var_11_15 = "vs_poison_wind_globadier"
	local var_11_16 = var_11_9[var_11_11] or var_11_9[2] or 5
	local var_11_17 = DamageUtils.calculate_damage(var_11_16)
	local var_11_18 = var_11_8[var_11_11] or var_11_8[2] or 7
	local var_11_19 = DamageUtils.calculate_damage(var_11_18)
	local var_11_20 = true
	local var_11_21 = false
	local var_11_22 = arg_11_0._impact_data
	local var_11_23

	if var_11_22.time then
		var_11_23 = table.clone(var_11_22)
	end

	Managers.state.entity:system("projectile_system"):spawn_globadier_globe(var_11_3, var_11_7, var_11_4, var_11_5, var_11_13, var_11_12, var_11_14, var_11_0, var_11_15, var_11_17, var_11_19, var_11_10, var_11_20, var_11_21, var_11_23)

	arg_11_0._thrown = true
end

function PoisonWindGlobadierStateThrowing._update_indicator_unit(arg_12_0)
	if arg_12_0._indicator_unit then
		local var_12_0 = arg_12_0._impact_data.position:unbox()

		Unit.set_local_position(arg_12_0._indicator_unit, 0, var_12_0)

		local var_12_1 = POSITION_LOOKUP[Managers.player:local_player().player_unit]
		local var_12_2 = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.pi * 0.5), Quaternion.look(var_12_1 - var_12_0, Vector3.up()))

		Unit.set_local_rotation(arg_12_0._indicator_unit, 0, var_12_2)
		arg_12_0:check_enemies_in_range_vfx(var_12_0)
	end
end

function PoisonWindGlobadierStateThrowing._create_indicator_unit(arg_13_0)
	local var_13_0 = arg_13_0._world
	local var_13_1 = arg_13_0._indicator_fx_unit_name

	arg_13_0._indicator_unit = World.spawn_unit(var_13_0, var_13_1, Vector3.zero())

	local var_13_2 = arg_13_0._breed.globe_throw_aoe_radius

	Unit.set_local_scale(arg_13_0._indicator_unit, 0, Vector3(var_13_2, var_13_2, var_13_2))
end

function PoisonWindGlobadierStateThrowing._destroy_indicator_unit(arg_14_0)
	local var_14_0 = arg_14_0._world

	if Unit.alive(arg_14_0._indicator_unit) then
		World.destroy_unit(var_14_0, arg_14_0._indicator_unit)

		arg_14_0._indicator_unit = nil
	end
end

function PoisonWindGlobadierStateThrowing._update_movement(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
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

	local var_15_11 = math.lerp(arg_15_0._wind_up_movement_speed, 0.6, (arg_15_4 or 1)^2)
	local var_15_12 = var_15_1:apply_buffs_to_value(var_15_11, "movement_speed") * var_15_6 * var_15_3.player_speed_scale
	local var_15_13 = Vector3(0, 0, 0)

	if var_15_4 then
		var_15_13 = var_15_13 + var_15_4
	end

	local var_15_14
	local var_15_15 = Vector3.normalize(var_15_13)

	if Vector3.length(var_15_15) == 0 then
		var_15_15 = arg_15_0.last_input_direction:unbox()
	else
		arg_15_0.last_input_direction:store(var_15_15)
	end

	local var_15_16 = CharacterStateHelper.get_move_animation(arg_15_0._locomotion_extension, var_15_0, arg_15_0._status_extension, arg_15_0.move_anim_3p)

	if var_15_16 ~= arg_15_0.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_15_1, var_15_16)

		arg_15_0.move_anim_3p = var_15_16
	end

	if (arg_15_0._previous_state == "jumping" or arg_15_0._previous_state == "falling") and not arg_15_0._locomotion_extension:is_on_ground() then
		CharacterStateHelper.move_in_air_pactsworn(arg_15_0._first_person_extension, var_15_0, arg_15_0._locomotion_extension, var_15_12, arg_15_1)
	else
		CharacterStateHelper.move_on_ground(var_15_2, var_15_0, arg_15_0._locomotion_extension, var_15_15, var_15_12, arg_15_1)
	end

	CharacterStateHelper.look(var_15_0, arg_15_0._player.viewport_name, var_15_2, arg_15_0._status_extension, arg_15_0._inventory_extension)

	arg_15_0.current_movement_speed_scale = var_15_6
end
