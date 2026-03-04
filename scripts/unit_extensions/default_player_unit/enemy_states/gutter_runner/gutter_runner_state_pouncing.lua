-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_pouncing.lua

GutterRunnerStatePouncing = class(GutterRunnerStatePouncing, EnemyCharacterState)

GutterRunnerStatePouncing.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "pouncing")
end

local var_0_0 = POSITION_LOOKUP

GutterRunnerStatePouncing.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0._temp_params)

	local var_2_0 = arg_2_0._player
	local var_2_1 = arg_2_0._input_extension
	local var_2_2 = arg_2_0._status_extension
	local var_2_3 = arg_2_0._locomotion_extension
	local var_2_4 = arg_2_0._inventory_extension
	local var_2_5 = arg_2_0._first_person_extension

	arg_2_0._breed = Unit.get_data(arg_2_1, "breed")
	arg_2_0._physics_world = World.physics_world(arg_2_0._world)

	local var_2_6 = var_2_2.do_pounce

	var_2_6.starting_pos = Vector3Box(POSITION_LOOKUP[arg_2_1])
	var_2_6.sfx_event_jump = "Play_versus_gutterrunner_jump_attack_release"
	var_2_6.sfx_event_land = "Play_versus_pactsworn_jump_land"
	var_2_6.sfx_event_jump_end = "Play_versus_gutterrunner_leap_stop"
	arg_2_0._pounce_data = var_2_6
	var_2_2.do_pounce = false

	local var_2_7 = var_2_6.initial_velocity:unbox()

	arg_2_0:_start_pounce(arg_2_1, var_2_7, arg_2_5)
	CharacterStateHelper.ghost_mode(arg_2_0._ghost_mode_extension, var_2_1)
	CharacterStateHelper.look(var_2_1, var_2_0.viewport_name, var_2_5, var_2_2, arg_2_0._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_1, var_2_4, arg_2_0._health_extension)

	local var_2_8 = POSITION_LOOKUP[arg_2_1]

	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	local var_2_9 = var_0_0[arg_2_1].z

	var_2_2:set_falling_height(var_2_9)
	var_2_2:set_gutter_runner_leaping(true)

	arg_2_0._entered_in_ghostmode = var_2_2:get_in_ghost_mode()
	arg_2_0._played_landing_event = nil

	CharacterStateHelper.play_animation_event(arg_2_1, "jump_start")
	CharacterStateHelper.play_animation_event_first_person(var_2_5, "jump_start")

	local var_2_10 = BLACKBOARDS[arg_2_1]

	var_2_10.starting_pos_boxed = Vector3Box(POSITION_LOOKUP[arg_2_1])
	var_2_10.pounce_start_time = arg_2_5

	arg_2_0:set_breed_action("jump")
	arg_2_0._ghost_mode_extension:set_external_no_spawn_reason("pouncing", true)
end

GutterRunnerStatePouncing.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_0._first_person_extension
	local var_3_1 = arg_3_0._locomotion_extension
	local var_3_2 = arg_3_0._status_extension

	var_3_1:reset_maximum_upwards_velocity()

	local var_3_3 = ScriptUnit.extension(arg_3_1, "career_system")
	local var_3_4 = var_3_3:ability_id("pounce")

	var_3_3:start_activated_ability_cooldown(var_3_4)

	local var_3_5 = arg_3_0._pounce_data.sfx_event_jump_end

	if var_3_5 then
		var_3_0:play_unit_sound_event(var_3_5, arg_3_1, 0)
	end

	if arg_3_6 == "walking" or arg_3_6 == "standing" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	elseif arg_3_6 and arg_3_6 ~= "falling" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end

	if arg_3_6 and Managers.state.network:game() then
		if arg_3_6 == "pinning_enemy" then
			CharacterStateHelper.play_animation_event(arg_3_1, "jump_attack")
			CharacterStateHelper.play_animation_event_first_person(var_3_0, "attack_finished")
		else
			CharacterStateHelper.play_animation_event(arg_3_1, "jump_fail")
			CharacterStateHelper.play_animation_event(arg_3_1, "to_combat")
			CharacterStateHelper.play_animation_event_first_person(var_3_0, "attack_finished")
		end
	end

	CharacterStateHelper.play_animation_event(arg_3_0._unit, "to_upright")
	CharacterStateHelper.play_animation_event_first_person(var_3_0, "to_upright")
	var_3_0:set_wanted_player_height("stand", arg_3_5)
	var_3_1:set_active_mover("standing")
	arg_3_0:set_breed_action("n/a")

	if arg_3_7 then
		return
	end

	arg_3_0._ghost_mode_extension:set_external_no_spawn_reason("pouncing", nil)
	var_3_2:set_gutter_runner_leaping(false)
end

GutterRunnerStatePouncing.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local var_4_2 = arg_4_0._input_extension
	local var_4_3 = arg_4_0._status_extension
	local var_4_4 = arg_4_0._first_person_extension
	local var_4_5 = arg_4_0._locomotion_extension
	local var_4_6 = arg_4_0._inventory_extension
	local var_4_7 = arg_4_0._health_extension
	local var_4_8 = arg_4_0._breed

	if CharacterStateHelper.do_common_state_transitions(var_4_3, var_4_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_4_3) then
		var_4_0:change_state("using_transport")

		return
	end

	if CharacterStateHelper.is_pushed(var_4_3) then
		var_4_3:set_pushed(false)

		local var_4_9 = var_4_1.stun_settings.pushed

		var_4_9.hit_react_type = var_4_3:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_9)

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_3) then
		var_4_3:set_block_broken(false)

		local var_4_10 = var_4_1.stun_settings.parry_broken

		var_4_10.hit_react_type = "medium_push"

		var_4_0:change_state("stunned", var_4_10)

		return
	end

	if arg_4_0:_update_movement(arg_4_1, arg_4_3, arg_4_5) then
		arg_4_0:_finish(arg_4_1, arg_4_5)

		if arg_4_0._pounce_target then
			local var_4_11 = arg_4_0._pounce_target

			arg_4_0._temp_params.target_unit = var_4_11

			var_4_0:change_state("pinning_enemy", arg_4_0._temp_params)
			var_4_4:change_state("pinning_enemy")

			return
		end

		if CharacterStateHelper.is_colliding_down(arg_4_1) then
			var_4_0:change_state("walking", arg_4_0._temp_params)
			var_4_4:change_state("walking")

			return
		end

		if not arg_4_0._csm.state_next and var_4_5:current_velocity().z <= 0 then
			var_4_0:change_state("falling", arg_4_0._temp_params)
			var_4_4:change_state("falling")

			return
		end
	end

	local var_4_12 = var_4_8.pounce_look_sense

	CharacterStateHelper.look(var_4_2, arg_4_0._player.viewport_name, var_4_4, var_4_3, var_4_6, var_4_12)
end

GutterRunnerStatePouncing._update_movement = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0._locomotion_extension
	local var_5_1 = arg_5_0._previous_speed

	arg_5_0._pounce_target = nil

	if not arg_5_0._entered_in_ghostmode then
		local var_5_2 = arg_5_0._breed.pounce_hit_radius
		local var_5_3 = FrameTable.alloc_table()
		local var_5_4 = Managers.state.entity:system("proximity_system")
		local var_5_5 = POSITION_LOOKUP[arg_5_1]
		local var_5_6 = var_5_4.player_units_broadphase

		Broadphase.query(var_5_6, var_5_5, var_5_2, var_5_3)

		local var_5_7

		for iter_5_0, iter_5_1 in pairs(var_5_3) do
			local var_5_8 = ScriptUnit.extension(iter_5_1, "status_system")

			if iter_5_1 ~= arg_5_1 and CharacterStateHelper.is_viable_stab_target(arg_5_1, iter_5_1, var_5_8) then
				local var_5_9 = Unit.world_position(iter_5_1, Unit.node(iter_5_1, "j_spine"))
				local var_5_10 = Vector3.distance(var_5_9, var_5_5)

				if (not var_5_7 or var_5_10 < var_5_7) and PerceptionUtils.is_position_in_line_of_sight(nil, var_5_5, var_5_9, arg_5_0._physics_world) then
					var_5_7 = var_5_10
					arg_5_0._pounce_target = iter_5_1
				end
			end
		end
	end

	if CharacterStateHelper.is_colliding_down(arg_5_1) or CharacterStateHelper.is_colliding_sides(arg_5_1) or arg_5_0._pounce_target then
		return true
	end

	local var_5_11 = Vector3.length(var_5_0:current_velocity())

	arg_5_0._previous_speed = var_5_11

	local var_5_12 = arg_5_0._status_extension
	local var_5_13 = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_1)
	local var_5_14 = var_5_11 * var_5_13.player_air_speed_scale_pouncing

	arg_5_0:_move_during_pounce(var_5_14, arg_5_1, arg_5_2)
end

GutterRunnerStatePouncing._move_during_pounce = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._input_extension
	local var_6_1 = CharacterStateHelper.get_movement_input(var_6_0)

	if not var_6_1 then
		return
	end

	local var_6_2 = arg_6_0._locomotion_extension
	local var_6_3 = arg_6_0._first_person_extension
	local var_6_4 = arg_6_0._breed
	local var_6_5 = Vector3.normalize(var_6_1)
	local var_6_6 = var_6_3:current_rotation()
	local var_6_7 = Vector3.normalize(Vector3.flat(Quaternion.rotate(var_6_6, var_6_5)))
	local var_6_8 = Vector3.flat(var_6_2:current_velocity())
	local var_6_9 = var_6_2:current_velocity()
	local var_6_10 = var_6_8 + var_6_7 * arg_6_1
	local var_6_11 = var_6_9.z - var_6_4.pounce_gravity * arg_6_3
	local var_6_12 = Vector3.length(var_6_10)
	local var_6_13 = math.clamp(var_6_12, 0, math.huge)
	local var_6_14 = Vector3.normalize(var_6_10) * var_6_13

	var_6_14.z = var_6_11

	var_6_2:set_forced_velocity(var_6_14)

	local var_6_15 = 0.5
	local var_6_16 = Quaternion.look(var_6_14, Vector3.up())
	local var_6_17 = Quaternion.pitch(var_6_16)

	if var_6_17 < Quaternion.pitch(var_6_6) then
		local var_6_18 = Quaternion.look(var_6_9, Vector3.up())
		local var_6_19 = Quaternion.pitch(var_6_18)
		local var_6_20 = math.radian_lerp(var_6_19, var_6_17, var_6_15)
		local var_6_21 = Quaternion.right(var_6_6)
		local var_6_22 = Quaternion.axis_angle(var_6_21, var_6_20 - var_6_19)
		local var_6_23 = Quaternion.multiply(var_6_22, var_6_6)

		var_6_3:set_rotation(var_6_23)
	end
end

GutterRunnerStatePouncing._finish = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._world
	local var_7_1 = arg_7_0._locomotion_extension
	local var_7_2 = arg_7_0._first_person_extension
	local var_7_3 = Vector3(0, 0, 0)

	var_7_1:set_forced_velocity(var_7_3)
	var_7_2:play_camera_effect_sequence("landed_hard", arg_7_2)

	local var_7_4 = arg_7_0._pounce_data.sfx_event_land

	if not arg_7_0._pounce_target and var_7_4 and not arg_7_0._played_landing_event then
		var_7_2:play_unit_sound_event(var_7_4, arg_7_1, 0)

		arg_7_0._played_landing_event = true
	end

	CharacterStateHelper.play_animation_event(arg_7_1, "jump_land")
	CharacterStateHelper.play_animation_event_first_person(var_7_2, "jump_land")

	PlayerUnitMovementSettings.get_movement_settings_table(arg_7_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration
end

GutterRunnerStatePouncing._start_pounce = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._world
	local var_8_1 = arg_8_0._first_person_extension
	local var_8_2 = arg_8_0._locomotion_extension

	arg_8_0._previous_speed = 0

	var_8_1:play_camera_effect_sequence("jump", arg_8_3)

	local var_8_3 = arg_8_0._pounce_data.sfx_event_jump

	if var_8_3 then
		var_8_1:play_unit_sound_event(var_8_3, arg_8_1, 0)
	end

	local var_8_4 = arg_8_0._breed
	local var_8_5 = var_8_4.pounce_start_forward_offset
	local var_8_6 = var_8_4.pounce_start_up_offset
	local var_8_7 = POSITION_LOOKUP[arg_8_1]
	local var_8_8 = var_8_1:current_rotation()
	local var_8_9 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_8_8))) * var_8_5

	var_8_9.z = var_8_6

	var_8_2:teleport_to(var_8_7 + var_8_9)
	var_8_2:set_maximum_upwards_velocity(arg_8_2.z)
	var_8_2:set_forced_velocity(arg_8_2)
	var_8_2:set_wanted_velocity(arg_8_2)

	PlayerUnitMovementSettings.get_movement_settings_table(arg_8_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration_gutter_runner_pounce
end
