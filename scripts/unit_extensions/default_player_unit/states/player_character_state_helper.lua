-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_helper.lua

CharacterStateHelper = CharacterStateHelper or {}

local var_0_0 = CharacterStateHelper

function var_0_0.get_movement_input(arg_1_0)
	local var_1_0 = arg_1_0:get("move") or Vector3(0, 0, 0)
	local var_1_1 = arg_1_0:get("move_controller") or Vector3(0, 0, 0)
	local var_1_2

	if Vector3.length(var_1_0) > Vector3.length(var_1_1) then
		var_1_2 = Vector3.normalize(var_1_0)
	else
		var_1_2 = var_1_1
	end

	return var_1_2
end

function var_0_0.get_square_movement_input(arg_2_0)
	local var_2_0 = arg_2_0:get("move") or Vector3(0, 0, 0)
	local var_2_1 = arg_2_0:get("move_controller") or Vector3(0, 0, 0)
	local var_2_2

	if Vector3.length(var_2_0) > Vector3.length(var_2_1) then
		var_2_2 = var_2_0
	else
		var_2_2 = math.circular_to_square_coordinates(var_2_1)
	end

	return var_2_2
end

function var_0_0.get_look_input(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_1.unit
	local var_3_1

	if ScriptUnit.has_extension(var_3_0, "smart_targeting_system") then
		var_3_1 = ScriptUnit.extension(var_3_0, "smart_targeting_system"):get_targeting_data()
	end

	local var_3_2 = arg_3_0:get("look")
	local var_3_3
	local var_3_4 = arg_3_1:is_zooming()
	local var_3_5 = Managers.input:is_device_active("gamepad")
	local var_3_6 = arg_3_2:get_wielded_slot_name()
	local var_3_7 = arg_3_2:get_wielded_slot_item_template()

	if var_3_5 then
		if var_3_4 then
			var_3_3 = arg_3_0:get("look_controller_zoom")
		elseif arg_3_3 then
			var_3_3 = arg_3_0:get("look_controller_3p")
		elseif var_3_6 == "slot_ranged" then
			var_3_3 = arg_3_0:get("look_controller_ranged")
		elseif var_3_6 == "slot_melee" and var_3_1 and var_3_1.targets_within_range then
			var_3_3 = arg_3_0:get("look_controller_melee")
		else
			var_3_3 = arg_3_0:get("look_controller")
		end
	end

	local var_3_8 = Vector3(0, 0, 0)

	if var_3_2 then
		var_3_8 = var_3_8 + var_3_2
	end

	if var_3_3 then
		var_3_8 = var_3_8 + var_3_3
	end

	local var_3_9 = var_0_0.apply_motion_controls(var_3_8, arg_3_0)

	if script_data.attract_mode_spectate then
		var_3_9 = Vector3(0.005, 0, 0)
	end

	return var_3_9
end

function var_0_0.apply_motion_controls(arg_4_0, arg_4_1)
	if MotionControlSettings.use_motion_controls then
		if MotionControlSettings.motion_disable_right_stick_vertical then
			arg_4_0.y = 0
		end

		local var_4_0 = MotionControlSettings.sensitivity_min_value
		local var_4_1 = MotionControlSettings.sensitivity_base_value
		local var_4_2 = MotionControlSettings.sensitivity_yaw_max - MotionControlSettings.sensitivity_yaw_min
		local var_4_3 = (var_4_1 - var_4_0) / (var_4_2 * 0.5)
		local var_4_4 = var_4_1 + MotionControlSettings.motion_sensitivity_yaw * var_4_3
		local var_4_5 = MotionControlSettings.sensitivity_pitch_max - MotionControlSettings.sensitivity_pitch_min
		local var_4_6 = (var_4_1 - var_4_0) / (var_4_5 * 0.5)
		local var_4_7 = var_4_1 + MotionControlSettings.motion_sensitivity_pitch * var_4_6
		local var_4_8 = var_4_4 * (MotionControlSettings.motion_invert_yaw and -1 or 1) * (MotionControlSettings.motion_enable_yaw_motion and 1 or 0)
		local var_4_9 = var_4_7 * (MotionControlSettings.motion_invert_pitch and -1 or 1) * (MotionControlSettings.motion_enable_pitch_motion and 1 or 0)
		local var_4_10 = arg_4_1:get("angular_velocity")
		local var_4_11 = var_4_10 and var_4_10.x or 0
		local var_4_12 = var_4_10 and -var_4_10.y or 0

		arg_4_0 = arg_4_0 + Vector3(var_4_8 * var_4_12, var_4_9 * var_4_11, 0)
	end

	return arg_4_0
end

function var_0_0.update_dodge_lock(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_2:dodge_locked() and not arg_5_1:get("dodge_hold") then
		arg_5_2:set_dodge_locked(false)
	end
end

local var_0_1 = {
	move_left_pressed = Vector3Box(-Vector3.right()),
	move_right_pressed = Vector3Box(Vector3.right()),
	move_back_pressed = Vector3Box(-Vector3.forward())
}

function var_0_0.check_to_start_dodge(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_2:dodge_locked() or not arg_6_2:can_dodge(arg_6_3) then
		return false
	end

	local var_6_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_0)
	local var_6_1 = var_0_0.get_movement_input(arg_6_1)
	local var_6_2 = arg_6_1.double_tap_dodge
	local var_6_3 = false
	local var_6_4 = Vector3(0, 0, 0)
	local var_6_5 = arg_6_1:get("dodge_hold")
	local var_6_6 = arg_6_1:get("dodge")
	local var_6_7 = var_6_6 or arg_6_1:get("jump") and var_6_5
	local var_6_8 = Vector3.length(var_6_1)
	local var_6_9 = not Managers.input:is_device_active("gamepad")
	local var_6_10 = Application.user_setting("toggle_stationary_dodge")

	if var_6_2 then
		for iter_6_0, iter_6_1 in pairs(var_0_1) do
			if arg_6_1:get(iter_6_0) then
				local var_6_11 = arg_6_1:was_double_tap(iter_6_0, arg_6_3, Application.user_setting("double_tap_dodge_threshold"))

				for iter_6_2, iter_6_3 in pairs(var_0_1) do
					arg_6_1:clear_double_tap(iter_6_2)
				end

				if var_6_11 then
					var_6_3 = true
					var_6_4 = iter_6_1:unbox()

					break
				end

				arg_6_1:start_double_tap(iter_6_0, arg_6_3)

				break
			end
		end
	end

	if not var_6_3 and var_6_7 and var_6_8 > arg_6_1.minimum_dodge_input then
		local var_6_12 = var_6_1 / var_6_8
		local var_6_13 = var_6_12.x
		local var_6_14 = var_6_12.y
		local var_6_15 = math.abs(var_6_13)

		if var_6_14 <= 0 or not var_6_9 and var_6_15 > 0.9239 or var_6_6 and var_6_15 > 0.707 then
			var_6_3 = true

			if var_6_14 > 0 then
				var_6_4 = Vector3(math.sign(var_6_13), 0, 0)
			else
				var_6_4 = var_6_12
			end
		end
	elseif var_6_7 and var_6_10 then
		var_6_3 = true
		var_6_4 = -Vector3.forward()
	end

	if var_6_3 then
		Managers.state.entity:system("play_go_tutorial_system"):register_dodge(var_6_4)
		arg_6_2:add_fatigue_points("action_dodge")
		arg_6_2:set_dodge_locked(true)
		arg_6_2:add_dodge_cooldown()

		local var_6_16 = ScriptUnit.extension(arg_6_0, "first_person_system")
	end

	return var_6_3, var_6_4
end

function var_0_0.move_on_ground(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = arg_7_0:current_rotation()
	local var_7_1 = Quaternion.look(Vector3.flat(Quaternion.forward(var_7_0)), Vector3.up())
	local var_7_2 = Quaternion.rotate(var_7_1, arg_7_3)

	if arg_7_3.y < 0 then
		arg_7_4 = arg_7_4 * PlayerUnitMovementSettings.get_movement_settings_table(arg_7_5).backward_move_scale
	end

	local var_7_3 = Vector3.dot(Quaternion.forward(var_7_1), var_7_2)

	arg_7_4 = arg_7_4 - arg_7_4 * (arg_7_6 and 1 - arg_7_6 or 0) * (1 - math.abs(var_7_3))

	arg_7_2:set_wanted_velocity(var_7_2 * arg_7_4)
end

function var_0_0.packmaster_move_on_ground(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11)
	local var_8_0 = arg_8_1:current_rotation()
	local var_8_1 = Quaternion.look(Vector3.flat(Quaternion.forward(var_8_0)), Vector3.up())
	local var_8_2 = Quaternion.rotate(var_8_1, arg_8_4)
	local var_8_3 = Managers.world:world("level_world")
	local var_8_4 = World.get_data(var_8_3, "physics_world")
	local var_8_5 = Managers.state.camera:camera_rotation(arg_8_7.viewport_name)
	local var_8_6 = Quaternion.forward(var_8_5)

	Vector3.set_z(var_8_6, 0)
	Vector3.set_z(arg_8_8, 0)

	local var_8_7 = Vector3.normalize(var_8_6)

	arg_8_8 = Vector3.normalize(arg_8_8)

	local var_8_8 = Vector3.dot(arg_8_8, var_8_2)
	local var_8_9 = var_8_8 > 0
	local var_8_10 = PlayerUnitMovementSettings.get_movement_settings_table(arg_8_6)
	local var_8_11 = math.clamp(1 - var_8_8, var_8_10.packmaster_forward_move_scale, 1)

	if var_8_9 then
		local var_8_12 = arg_8_10 and 1.5 or 1.1
		local var_8_13 = POSITION_LOOKUP[arg_8_9]
		local var_8_14, var_8_15, var_8_16, var_8_17, var_8_18 = PhysicsWorld.immediate_raycast(var_8_4, var_8_13 + Vector3(0, 0, 0.5), arg_8_8, var_8_12, "closest", "types", "both", "collision_filter", "filter_ground_material_check")

		if var_8_14 then
			var_8_11 = 0
		end
	else
		local var_8_19 = Unit.node(arg_8_9, "j_neck")
		local var_8_20 = Unit.world_position(arg_8_9, var_8_19)
		local var_8_21 = Unit.node(arg_8_6, "j_rightweaponcomponent10")
		local var_8_22 = Unit.world_position(arg_8_6, var_8_21)

		if Vector3.distance(var_8_20, var_8_22) > 3.25 then
			var_8_11 = 0
		end
	end

	arg_8_5 = arg_8_5 * var_8_11

	arg_8_3:set_wanted_velocity(var_8_2 * arg_8_5)
end

function var_0_0.update_soft_collision_movement(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	local var_9_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_9_3)
	local var_9_1 = Vector3(0, 0, 0)
	local var_9_2 = POSITION_LOOKUP[arg_9_3]
	local var_9_3 = Unit.local_rotation(arg_9_3, 0)
	local var_9_4 = arg_9_6.PLAYER_UNITS

	if Unit.alive(arg_9_3) then
		for iter_9_0, iter_9_1 in pairs(var_9_4) do
			if iter_9_1 ~= arg_9_3 and Unit.alive(iter_9_1) and StatusUtils.use_soft_collision(iter_9_1) then
				local var_9_5 = var_9_2 - POSITION_LOOKUP[iter_9_1]
				local var_9_6 = math.abs(Vector3.z(var_9_5))

				Vector3.set_z(var_9_5, 0)

				local var_9_7 = Vector3.length(var_9_5)

				if var_9_6 <= var_9_0.soft_collision.max_height_diference and var_9_7 <= var_9_0.soft_collision.max_distance then
					local var_9_8 = Vector3.normalize(var_9_5)
					local var_9_9 = 1 / (var_9_7 + var_9_0.soft_collision.speed_modifier)

					var_9_1 = var_9_1 + var_9_8 * (var_9_9 * var_9_9)
				end
			end
		end
	end

	local var_9_10 = Vector3.length(var_9_1)
	local var_9_11 = Vector3.normalize(var_9_1)
	local var_9_12 = var_9_0.soft_collision.idle_speed_threshold

	if var_9_10 <= var_9_12 then
		arg_9_2:set_wanted_velocity(Vector3(0, 0, 0))
	else
		var_9_10 = math.clamp(var_9_10, var_9_0.soft_collision.lowest_speed, var_9_0.soft_collision.highest_speed)

		arg_9_2:set_wanted_velocity(var_9_11 * var_9_10)
	end

	if var_9_10 <= var_9_12 then
		if arg_9_5 ~= "idle" then
			var_0_0.play_animation_event(arg_9_3, "idle")
			var_0_0.play_animation_event_first_person(arg_9_0, "idle")

			arg_9_5 = "idle"
		end
	elseif Vector3.dot(var_9_11, Quaternion.forward(var_9_3)) >= 0 then
		if arg_9_5 ~= "move_fwd" then
			var_0_0.play_animation_event(arg_9_3, "move_fwd")
			var_0_0.play_animation_event_first_person(arg_9_0, "move_fwd")

			arg_9_5 = "move_fwd"
		end
	elseif arg_9_5 ~= "move_bwd" then
		var_0_0.play_animation_event(arg_9_3, "move_bwd")
		var_0_0.play_animation_event_first_person(arg_9_0, "move_bwd")

		arg_9_5 = "move_bwd"
	end

	return arg_9_5
end

function var_0_0.do_common_state_transitions(arg_10_0, arg_10_1, arg_10_2)
	if var_0_0.is_dead(arg_10_0) then
		arg_10_1:change_state("dead")

		return true
	end

	if var_0_0.is_staggered(arg_10_0) then
		arg_10_1:change_state("staggered")

		return true
	end

	if var_0_0.is_knocked_down(arg_10_0) then
		arg_10_1:change_state("knocked_down")

		return true
	end

	if var_0_0.is_pounced_down(arg_10_0) then
		arg_10_1:change_state("pounced_down")

		return true
	end

	local var_10_0, var_10_1 = var_0_0.is_catapulted(arg_10_0)

	if var_10_0 then
		local var_10_2 = {
			sound_event = "Play_hit_by_ratogre",
			direction = var_10_1
		}

		arg_10_1:change_state("catapulted", var_10_2)

		return true
	end

	if var_0_0.is_grabbed_by_pack_master(arg_10_0) then
		arg_10_1:change_state("grabbed_by_pack_master")

		return true
	end

	if arg_10_0.grabbed_by_corruptor then
		arg_10_1:change_state("grabbed_by_corruptor")

		return true
	end

	if arg_10_0.grabbed_by_tentacle then
		arg_10_1:change_state("grabbed_by_tentacle")

		return true
	end

	if arg_10_0.grabbed_by_chaos_spawn then
		arg_10_1:change_state("grabbed_by_chaos_spawn")

		return true
	end

	if arg_10_0.in_vortex then
		arg_10_1:change_state("in_vortex")

		return true
	end

	if arg_10_0.do_lunge then
		arg_10_1:change_state("lunging")

		return true
	end

	if arg_10_0.is_packmaster_dragging then
		local var_10_3 = arg_10_0:get_packmaster_dragged_unit()
		local var_10_4 = ScriptUnit.extension(var_10_3, "status_system")

		if not (var_10_4.pack_master_status == "pack_master_hanging" or var_10_4.pack_master_status == "pack_master_hoisting") then
			arg_10_1:change_state("packmaster_dragging")

			return true
		end
	end

	if arg_10_0.in_hanging_cage then
		local var_10_5 = arg_10_0.in_hanging_cage_animations
		local var_10_6 = arg_10_0.in_hanging_cage_unit
		local var_10_7 = {
			animations = var_10_5,
			cage_unit = var_10_6
		}

		arg_10_1:change_state("in_hanging_cage", var_10_7)

		return true
	end

	if arg_10_2 ~= "overpowered" and arg_10_2 ~= "ledge_hanging" and arg_10_0.overpowered then
		local var_10_8 = PlayerUnitMovementSettings.overpowered_templates[arg_10_0.overpowered_template]

		arg_10_1:change_state("overpowered", var_10_8)

		return true
	end

	return false
end

function var_0_0.is_colliding_with_gameplay_collision_box(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = World.get_data(arg_11_0, "physics_world")
	local var_11_1 = arg_11_3 and arg_11_3.position or POSITION_LOOKUP[arg_11_1]
	local var_11_2 = PlayerUnitMovementSettings.get_movement_settings_table(arg_11_1)
	local var_11_3 = arg_11_3 and arg_11_3.movement_settings_table_name or "gameplay_collision_box"
	local var_11_4 = var_11_2[var_11_3].collision_check_player_half_height
	local var_11_5 = var_11_2[var_11_3].collision_check_player_height_offset
	local var_11_6 = var_11_1 + Vector3(0, 0, var_11_5)
	local var_11_7 = Unit.local_rotation(arg_11_1, 0)
	local var_11_8 = var_11_2[arg_11_3 and arg_11_3.movement_settings_table_name or "gameplay_collision_box"].collision_check_player_radius
	local var_11_9 = Vector3(var_11_8, var_11_4, var_11_8)
	local var_11_10 = var_11_4 - var_11_8 > 0 and "capsule" or "sphere"
	local var_11_11 = PhysicsWorld.immediate_overlap(var_11_0, "shape", var_11_10, "position", var_11_6, "rotation", var_11_7, "size", var_11_9, "collision_filter", arg_11_2)
	local var_11_12 = var_11_11 and var_11_11[1]
	local var_11_13
	local var_11_14

	if var_11_12 then
		var_11_13 = true
		var_11_14 = Actor.unit(var_11_12)
	end

	return var_11_13, var_11_14
end

function var_0_0.move_in_air(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = var_0_0.get_movement_input(arg_12_1)
	local var_12_1 = 0

	if arg_12_5 and arg_12_5 > 0 then
		var_12_1 = var_12_1 - 1
	end

	if arg_12_6 and arg_12_6 > 0 then
		var_12_1 = var_12_1 + 1
	end

	if var_12_1 ~= 0 then
		Vector3.set_y(var_12_0, var_12_1)
	end

	local var_12_2 = Vector3.normalize(var_12_0)
	local var_12_3 = arg_12_0:current_rotation()
	local var_12_4 = Vector3.normalize(Vector3.flat(Quaternion.rotate(var_12_3, var_12_2)))
	local var_12_5 = PlayerUnitMovementSettings.get_movement_settings_table(arg_12_4)
	local var_12_6 = math.clamp(var_12_5.move_speed, 0, PlayerUnitMovementSettings.move_speed)

	if var_12_0.y < 0 then
		arg_12_3 = arg_12_3 * var_12_5.backward_move_scale
		var_12_6 = var_12_6 * var_12_5.backward_move_scale * 0.9
	end

	local var_12_7 = Vector3.flat(arg_12_2:current_velocity()) + var_12_4 * arg_12_3
	local var_12_8 = Vector3.length(var_12_7)
	local var_12_9 = math.clamp(var_12_8, 0, var_12_6 * var_12_5.player_speed_scale)
	local var_12_10 = Vector3.normalize(var_12_7)

	arg_12_2:set_wanted_velocity(var_12_10 * var_12_9)
end

function var_0_0.move_in_air_pactsworn(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
	local var_13_0 = var_0_0.get_movement_input(arg_13_1)
	local var_13_1 = 0
	local var_13_2 = Unit.get_data(arg_13_4, "breed")

	if arg_13_5 and arg_13_5 > 0 then
		var_13_1 = var_13_1 - 1
	end

	if arg_13_6 and arg_13_6 > 0 then
		var_13_1 = var_13_1 + 1
	end

	if var_13_1 ~= 0 then
		Vector3.set_y(var_13_0, var_13_1)
	end

	local var_13_3 = Vector3.normalize(var_13_0)
	local var_13_4 = arg_13_0:current_rotation()
	local var_13_5 = Vector3.normalize(Vector3.flat(Quaternion.rotate(var_13_4, var_13_3)))
	local var_13_6 = PlayerUnitMovementSettings.get_movement_settings_table(arg_13_4)
	local var_13_7 = var_13_2.movement_speed_multiplier
	local var_13_8 = var_13_6.move_speed

	if ScriptUnit.extension(arg_13_4, "ghost_mode_system"):is_in_ghost_mode() then
		var_13_8 = var_13_6.ghost_move_speed
	end

	local var_13_9 = var_13_8 * var_13_7 * 0.7

	if var_13_0.y < 0 then
		arg_13_3 = arg_13_3 * var_13_6.backward_move_scale
		var_13_9 = var_13_9 * var_13_6.backward_move_scale * 0.9
	end

	local var_13_10 = Vector3.flat(arg_13_2:current_velocity()) + var_13_5 * arg_13_3
	local var_13_11 = Vector3.length(var_13_10)
	local var_13_12 = math.clamp(var_13_11, 0, var_13_9 * var_13_6.player_speed_scale)
	local var_13_13 = Vector3.normalize(var_13_10)

	arg_13_2:set_wanted_velocity(var_13_13 * var_13_12)
end

function var_0_0.looking_up(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0:get_first_person_unit()
	local var_14_1 = Unit.world_rotation(var_14_0, 0)
	local var_14_2 = Quaternion.forward(var_14_1)
	local var_14_3 = Vector3.normalize(var_14_2)

	return arg_14_1 < Vector3.dot(var_14_3, Vector3.up()) and true or false
end

function var_0_0.looking_down(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0:get_first_person_unit()
	local var_15_1 = Unit.world_rotation(var_15_0, 0)
	local var_15_2 = Quaternion.forward(var_15_1)
	local var_15_3 = Vector3.normalize(var_15_2)

	return arg_15_1 > Vector3.dot(var_15_3, Vector3.up()) and true or false
end

function var_0_0.look(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	local var_16_0 = Managers.state.camera
	local var_16_1 = arg_16_5 or var_16_0:has_viewport(arg_16_1) and var_16_0:fov(arg_16_1) / 0.785 or 1
	local var_16_2 = arg_16_0.unit
	local var_16_3 = var_16_1 * PlayerUnitMovementSettings.get_movement_settings_table(var_16_2).look_input_sensitivity
	local var_16_4 = false
	local var_16_5 = var_0_0.get_look_input(arg_16_0, arg_16_3, arg_16_4, var_16_4) * var_16_3

	if arg_16_6 then
		var_16_5 = var_16_5 + arg_16_6
	end

	arg_16_2:set_look_delta(var_16_5)
end

function var_0_0.look_limited_rotation_freedom(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9)
	local var_17_0 = Managers.state.camera
	local var_17_1 = arg_17_9 or var_17_0:has_viewport(arg_17_1) and Managers.state.camera:fov(arg_17_1) / 0.785 or 1
	local var_17_2 = false
	local var_17_3 = var_0_0.get_look_input(arg_17_0, arg_17_7, arg_17_8, var_17_2) * var_17_1

	if arg_17_5 then
		local var_17_4 = Quaternion.yaw(arg_17_4) - Quaternion.yaw(Unit.local_rotation(arg_17_2.first_person_unit, 0))
		local var_17_5 = Vector3.x(var_17_3)

		if var_17_5 > 0 and arg_17_5 < var_17_4 then
			var_17_5 = 0
		end

		if var_17_5 < 0 and var_17_4 < -arg_17_5 then
			var_17_5 = 0
		end

		Vector3.set_x(var_17_3, var_17_5)
	end

	if arg_17_6 then
		local var_17_6 = Quaternion.pitch(arg_17_4) - Quaternion.pitch(Unit.local_rotation(arg_17_2.first_person_unit, 0))
		local var_17_7 = Vector3.y(var_17_3)
		local var_17_8 = math.pi / 2

		if var_17_7 < 0 and arg_17_6 < var_17_6 then
			var_17_7 = 0
		end

		if var_17_7 > 0 and var_17_6 < -arg_17_6 then
			var_17_7 = 0
		end

		Vector3.set_y(var_17_3, var_17_7)
	end

	arg_17_2:set_look_delta(var_17_3)
end

function var_0_0.lerp_player_rotation_radian(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0

	if arg_18_1 >= 0 and arg_18_0 >= 0 or arg_18_1 <= 0 and arg_18_0 <= 0 then
		var_18_0 = arg_18_0 + (arg_18_1 - arg_18_0) * arg_18_3
	else
		local var_18_1 = arg_18_2 * arg_18_3

		if arg_18_1 < 0 then
			if math.abs(arg_18_1) + arg_18_0 > math.pi then
				var_18_0 = arg_18_0 + var_18_1

				if var_18_0 >= math.pi then
					local var_18_2 = math.pi - math.abs(var_18_0)

					var_18_0 = math.pi - var_18_2
				end
			else
				var_18_0 = arg_18_0 - var_18_1
			end
		elseif arg_18_1 + math.abs(arg_18_0) > math.pi then
			var_18_0 = arg_18_0 - var_18_1

			if var_18_0 <= -math.pi then
				local var_18_3 = var_18_0 - math.pi

				var_18_0 = -math.pi + var_18_3
			end
		else
			var_18_0 = arg_18_0 + var_18_1
		end
	end

	return var_18_0
end

function var_0_0.lerp_player_pitch_rotation(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = Unit.local_rotation(arg_19_3, 0)
	local var_19_1 = math.lerp(arg_19_0, 0, arg_19_2)
	local var_19_2 = Quaternion.yaw(var_19_0)
	local var_19_3 = Quaternion.roll(var_19_0)
	local var_19_4 = Quaternion(Vector3.up(), var_19_2)
	local var_19_5 = Quaternion(Vector3.right(), var_19_1)
	local var_19_6 = Quaternion(Vector3.forward(), var_19_3)
	local var_19_7 = Quaternion.multiply(var_19_4, var_19_5)
	local var_19_8 = Quaternion.multiply(var_19_7, var_19_6)

	arg_19_1:set_rotation(var_19_8)
	Unit.set_local_rotation(arg_19_3, 0, var_19_8)
end

function var_0_0.lerp_player_yaw_rotation(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_3:get_first_person_unit()
	local var_20_1 = Unit.local_rotation(var_20_0, 0)
	local var_20_2 = var_0_0.lerp_player_rotation_radian(arg_20_0, arg_20_1, arg_20_2, arg_20_4)
	local var_20_3 = Quaternion.pitch(var_20_1)
	local var_20_4 = Quaternion.roll(var_20_1)
	local var_20_5 = Quaternion(Vector3.up(), var_20_2)
	local var_20_6 = Quaternion(Vector3.right(), var_20_3)
	local var_20_7 = Quaternion(Vector3.forward(), var_20_4)
	local var_20_8 = Quaternion.multiply(var_20_5, var_20_6)
	local var_20_9 = Quaternion.multiply(var_20_8, var_20_7)

	arg_20_3:set_rotation(var_20_9)
	Unit.set_local_rotation(arg_20_5, 0, var_20_9)
end

function var_0_0.time_in_ladder_move_animation(arg_21_0, arg_21_1)
	local var_21_0 = Unit.world_position(arg_21_0, 0)
	local var_21_1 = Vector3.z(var_21_0) - arg_21_1
	local var_21_2 = PlayerUnitMovementSettings.get_movement_settings_table(arg_21_0)

	return var_21_1 % var_21_2.ladder.whole_movement_animation_distance / var_21_2.ladder.whole_movement_animation_distance * var_21_2.ladder.movement_animation_length
end

function var_0_0.show_inventory_3p(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = Managers.state.network
	local var_22_1 = var_22_0:unit_game_object_id(arg_22_0)

	if not var_22_0.game_session then
		return
	end

	if arg_22_2 or arg_22_3 and arg_22_4.is_bot then
		arg_22_4:show_third_person_inventory(arg_22_1)
	end

	if arg_22_3 then
		var_22_0.network_transmit:send_rpc_clients("rpc_show_inventory", var_22_1, arg_22_1)
	else
		var_22_0.network_transmit:send_rpc_server("rpc_show_inventory", var_22_1, arg_22_1)
	end
end

function var_0_0.set_is_on_ladder(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = Managers.state.network
	local var_23_1 = var_23_0:unit_game_object_id(arg_23_1)
	local var_23_2, var_23_3 = var_23_0:game_object_or_level_id(arg_23_0)

	assert(var_23_3, "Ladder unit wasn't a level unit")

	if arg_23_3 or LEVEL_EDITOR_TEST then
		Managers.state.entity:system("status_system"):rpc_status_change_bool(nil, NetworkLookup.statuses.ladder_climbing, arg_23_2, var_23_1, var_23_2)
	else
		arg_23_4:set_is_on_ladder(arg_23_2, arg_23_0)
		var_23_0.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.ladder_climbing, arg_23_2, var_23_1, var_23_2)
	end
end

function var_0_0.set_is_on_ledge(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = Managers.state.network
	local var_24_1 = var_24_0:unit_game_object_id(arg_24_1)
	local var_24_2, var_24_3 = var_24_0:game_object_or_level_id(arg_24_0)

	arg_24_4:set_crouching(false)

	if Managers.state.network:game() and not LEVEL_EDITOR_TEST then
		arg_24_4:set_is_ledge_hanging(arg_24_2, arg_24_0)
		var_24_0.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.ledge_hanging, arg_24_2, var_24_1, var_24_2)
	end
end

function var_0_0.get_buffered_input(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0
	local var_25_1

	if arg_25_0 then
		var_25_0 = arg_25_1:get(arg_25_0)

		if var_25_0 and arg_25_4 and var_25_0 < arg_25_4 then
			return false
		end

		if not arg_25_2 then
			if var_25_0 then
				arg_25_1:add_buffer(arg_25_0, arg_25_3)
			else
				var_25_0 = arg_25_1:get_buffer(arg_25_0)
				var_25_1 = true
			end
		end
	end

	return var_25_0, var_25_1
end

function var_0_0._check_cooldown(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = false

	if arg_26_0 then
		local var_26_1 = arg_26_0:get_action_cooldown(arg_26_1)

		var_26_0 = var_26_1 and arg_26_2 <= var_26_1
	end

	return var_26_0
end

function var_0_0.wield_input(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_2 ~= "action_wield" then
		return nil
	end

	local var_27_0 = InventorySettings.slots_by_name
	local var_27_1 = InventorySettings.slots_by_wield_input
	local var_27_2 = arg_27_1:equipment()
	local var_27_3 = var_27_2.wielded_slot
	local var_27_4 = var_27_0[var_27_3]
	local var_27_5 = var_27_4.wield_input
	local var_27_6
	local var_27_7

	if var_0_0.get_buffered_input("wield_switch", arg_27_0, nil, nil, nil, var_27_3 == "slot_melee") then
		var_27_6 = var_27_4.name ~= "slot_melee" and "slot_melee" or "slot_ranged"
	end

	if not var_27_6 then
		for iter_27_0, iter_27_1 in ipairs(var_27_1) do
			if iter_27_1 ~= var_27_4 or arg_27_1:can_swap_from_storage(iter_27_1.name, SwapFromStorageType.Unique) then
				local var_27_8 = iter_27_1.wield_input
				local var_27_9 = iter_27_1.name

				if var_27_2.slots[var_27_9] and var_0_0.get_buffered_input(var_27_8, arg_27_0, nil, nil, nil, var_27_3 == "slot_melee") then
					var_27_6 = var_27_9

					break
				end
			end

			local var_27_10 = iter_27_1.wield_input_alt

			if var_27_10 and var_0_0.get_buffered_input(var_27_10, arg_27_0, nil, nil, nil, var_27_3 == "slot_melee") and (iter_27_1 ~= var_27_4 or arg_27_1:can_swap_from_storage(iter_27_1.name, SwapFromStorageType.LowestUnwieldPrio)) then
				var_27_6 = iter_27_1.name
				var_27_7 = SwapFromStorageType.LowestUnwieldPrio

				break
			end
		end
	end

	local var_27_11 = 0

	if arg_27_0:get("wield_prev") then
		var_27_11 = -1
	elseif arg_27_0:get("wield_next") then
		var_27_11 = 1
	end

	local var_27_12 = DebugKeyHandler.key_pressed("left shift") or DebugKeyHandler.key_pressed("left alt")
	local var_27_13 = Application.user_setting("weapon_scroll_type") or "scroll_wrap"

	if var_27_13 ~= "scroll_disabled" and not var_27_6 and var_27_11 ~= 0 and not var_27_12 then
		local var_27_14 = var_27_4.wield_index or 1
		local var_27_15 = #var_27_1
		local var_27_16 = math.sign(var_27_11)
		local var_27_17 = var_27_14 + var_27_16

		repeat
			local var_27_18 = var_27_1[var_27_17]
			local var_27_19 = var_27_18 and var_27_2.slots[var_27_18.name]

			if not var_27_19 then
				if var_27_15 < var_27_17 then
					if var_27_13 == "scroll_clamp" then
						var_27_17 = var_27_15
						var_27_16 = -1
					else
						var_27_17 = 1
					end
				elseif var_27_17 < 1 then
					if var_27_13 == "scroll_clamp" then
						var_27_17 = 1
						var_27_16 = 1
					else
						var_27_17 = var_27_15
					end
				else
					var_27_17 = var_27_17 + var_27_16
				end
			end
		until var_27_19

		if var_27_4.wield_index ~= var_27_17 then
			var_27_6 = var_27_1[var_27_17].name
		end
	end

	if var_27_6 and not var_27_2.slots[var_27_6] then
		var_27_6 = nil
	end

	return var_27_6, var_27_11, var_27_7
end

local var_0_2 = {}

function var_0_0.get_item_data_and_weapon_extensions(arg_28_0)
	local var_28_0 = arg_28_0:equipment()
	local var_28_1 = var_28_0.wielded

	if var_28_1 == nil then
		return
	end

	local var_28_2 = var_28_0.right_hand_wielded_unit
	local var_28_3 = var_28_0.left_hand_wielded_unit
	local var_28_4
	local var_28_5

	if Unit.alive(var_28_2) then
		var_28_4 = ScriptUnit.extension(var_28_2, "weapon_system")
	end

	if Unit.alive(var_28_3) then
		var_28_5 = ScriptUnit.extension(var_28_3, "weapon_system")
	end

	if not var_28_4 and not var_28_5 then
		return
	end

	return var_28_1, var_28_4, var_28_5
end

function var_0_0.get_current_action_data(arg_29_0, arg_29_1)
	local var_29_0
	local var_29_1
	local var_29_2

	if arg_29_0 then
		local var_29_3 = arg_29_0.current_action_settings

		if var_29_3 then
			var_29_0 = var_29_3
			var_29_1 = arg_29_0
			var_29_2 = var_29_0.weapon_action_hand or "left"
		end
	end

	if arg_29_1 then
		local var_29_4 = arg_29_1.current_action_settings

		if var_29_4 then
			var_29_0 = var_29_4
			var_29_1 = arg_29_1
			var_29_2 = var_29_0.weapon_action_hand or "right"
		end
	end

	return var_29_0, var_29_1, var_29_2
end

function var_0_0._check_chain_action(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8)
	local var_30_0
	local var_30_1
	local var_30_2
	local var_30_3
	local var_30_4
	local var_30_5 = arg_30_1.release_required
	local var_30_6 = true

	if var_30_5 then
		var_30_6 = arg_30_4:released_input(var_30_5)
	end

	local var_30_7 = arg_30_1.hold_required

	if var_30_7 then
		for iter_30_0, iter_30_1 in pairs(var_30_7) do
			if arg_30_4:released_input(iter_30_1) then
				var_30_6 = false

				break
			end
		end
	end

	local var_30_8 = arg_30_1.softbutton_required

	if var_30_8 then
		for iter_30_2, iter_30_3 in pairs(var_30_8) do
			if arg_30_4:released_softbutton_input(iter_30_3.input, iter_30_3.softbutton_threshold or arg_30_1.softbutton_threshold) then
				var_30_6 = false

				break
			end
		end
	end

	local var_30_9 = arg_30_1.input
	local var_30_10 = arg_30_1.softbutton_threshold
	local var_30_11
	local var_30_12
	local var_30_13 = arg_30_1.no_buffer
	local var_30_14 = arg_30_1.doubleclick_window
	local var_30_15 = arg_30_1.blocking_input
	local var_30_16 = false

	if var_30_15 then
		var_30_16 = arg_30_4:get(var_30_15)
	end

	if var_30_6 and not var_30_16 then
		local var_30_17 = arg_30_5:equipment().wielded_slot

		var_30_11, var_30_12 = var_0_0.get_buffered_input(var_30_9, arg_30_4, var_30_13, var_30_14, var_30_10, var_30_17 == "slot_melee")

		if not var_30_11 and arg_30_1.hold_allowed then
			var_30_11, var_30_12 = var_0_0.get_buffered_input(var_30_9 .. "_hold", arg_30_4, var_30_13, var_30_14, var_30_10, var_30_17 == "slot_melee")
		end
	end

	if not var_30_11 then
		local var_30_18 = arg_30_1.action
		local var_30_19 = arg_30_1.sub_action
		local var_30_20 = arg_30_2.actions[var_30_18] and arg_30_2.actions[var_30_18][var_30_19]

		var_30_11 = var_30_20 and var_30_20.kind == "block" and arg_30_4:is_input_blocked()
	end

	if not var_30_11 then
		arg_30_0 = var_0_0.wield_input(arg_30_4, arg_30_5, arg_30_1.action)
		var_30_11 = arg_30_0
	end

	local var_30_21 = arg_30_1.auto_chain and var_30_6

	if var_30_11 or var_30_21 then
		local var_30_22 = (arg_30_1.select_chance or 1) >= math.random()

		if arg_30_3:is_chain_action_available(arg_30_1, arg_30_7) and var_30_22 then
			local var_30_23 = arg_30_1.sub_action

			if arg_30_1.blocker then
				return true, nil, nil, arg_30_0, nil, nil
			end

			if var_30_23 then
				local var_30_24 = arg_30_1.action
				local var_30_25 = var_30_23
				local var_30_26 = arg_30_2.actions[var_30_24] and arg_30_2.actions[var_30_24][var_30_25]
				local var_30_27 = var_30_26 and var_30_26.chain_condition_func
				local var_30_28 = false

				if var_30_27 then
					var_30_28 = not var_30_27(arg_30_6, arg_30_4, arg_30_8, arg_30_3)
				end

				local var_30_29 = var_0_0._check_cooldown(arg_30_3, var_30_24, arg_30_7)

				if var_30_26 and not var_30_28 and not var_30_29 then
					local var_30_30 = arg_30_1.send_buffer
					local var_30_31 = arg_30_1.clear_buffer

					if var_30_12 and arg_30_1.input == "action_one_release" then
						var_30_4 = "action_one_hold"
					elseif var_30_21 and arg_30_1.input == "action_wield" then
						-- block empty
					end

					return true, var_30_24, var_30_25, arg_30_0, var_30_30, var_30_31, var_30_4
				end
			end
		end
	end

	return false
end

local var_0_3 = {
	sub_action = "default",
	start_time = 0,
	action = "N/A",
	input = "action_career"
}

function var_0_0._get_chain_action_data(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)
	local var_31_0
	local var_31_1
	local var_31_2
	local var_31_3
	local var_31_4
	local var_31_5
	local var_31_6
	local var_31_7 = ScriptUnit.has_extension(arg_31_5, "career_system")

	if var_31_7 then
		local var_31_8 = arg_31_2.lookup_data.action_name
		local var_31_9 = var_31_7:ability_amount()

		for iter_31_0 = 1, var_31_9 do
			local var_31_10 = var_31_7:get_activated_ability_data(iter_31_0)
			local var_31_11 = var_31_10.action_name

			if var_31_11 and var_31_11 ~= var_31_8 then
				local var_31_12 = var_0_3

				var_31_12.action = var_31_11

				local var_31_13, var_31_14, var_31_15, var_31_16, var_31_17, var_31_18, var_31_19 = var_0_0._check_chain_action(var_31_3, var_31_12, arg_31_0, arg_31_1, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)

				if var_31_13 then
					local var_31_20 = var_31_10.activatable_on_wield_chain_only
					local var_31_21 = not var_31_20

					if var_31_20 then
						local var_31_22 = arg_31_2.allowed_chain_actions

						if var_31_22 then
							for iter_31_1 = 1, #var_31_22 do
								local var_31_23 = var_31_22[iter_31_1]

								if var_31_23.input == "action_wield" and arg_31_1:is_chain_action_available(var_31_23, arg_31_6) then
									var_31_21 = true

									break
								end
							end
						end
					end

					if var_31_21 then
						local var_31_24 = var_31_13

						var_31_1 = var_31_14
						var_31_2 = var_31_15
						var_31_3 = var_31_16
						var_31_4 = var_31_17
						var_31_5 = var_31_18
						var_31_6 = var_31_19
					end
				end
			end
		end
	end

	if not var_31_1 then
		local var_31_25 = arg_31_2.allowed_chain_actions or var_0_2

		for iter_31_2 = 1, #var_31_25 do
			local var_31_26 = var_31_25[iter_31_2]
			local var_31_27, var_31_28, var_31_29, var_31_30, var_31_31, var_31_32, var_31_33 = var_0_0._check_chain_action(var_31_3, var_31_26, arg_31_0, arg_31_1, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)

			var_31_6 = var_31_33
			var_31_5 = var_31_32
			var_31_4 = var_31_31
			var_31_3 = var_31_30
			var_31_2 = var_31_29
			var_31_1 = var_31_28

			if var_31_27 then
				break
			end
		end
	end

	if var_31_1 then
		local var_31_34 = arg_31_0.actions[var_31_1] and arg_31_0.actions[var_31_1][var_31_2]

		if var_31_5 or var_31_2 == "push" then
			arg_31_3:clear_input_buffer()
		elseif var_31_34 and not var_31_3 and not var_31_34.keep_buffer and not var_31_4 then
			arg_31_3:reset_input_buffer()
		end
	end

	return var_31_1, var_31_2, var_31_3, var_31_6
end

local function var_0_4(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8, arg_32_9)
	local var_32_0 = arg_32_3.input_override or arg_32_1
	local var_32_1 = not arg_32_3.do_not_validate_with_hold and arg_32_3.hold_input
	local var_32_2 = arg_32_3.allow_hold_toggle and arg_32_4.toggle_alternate_attack
	local var_32_3 = arg_32_6 or arg_32_4:get(var_32_0) or arg_32_4:get_buffer(var_32_0) or arg_32_4:get(arg_32_3.attack_hold_input) or not var_32_2 and arg_32_4:get(var_32_1) or arg_32_3.kind == "block" and arg_32_4:is_input_blocked()
	local var_32_4
	local var_32_5

	if not var_32_3 then
		var_32_4 = var_0_0.wield_input(arg_32_4, arg_32_5, var_32_0)
		var_32_5 = true
	end

	if var_32_3 or var_32_4 then
		local var_32_6 = arg_32_3.condition_func

		if (not var_32_6 or var_32_6(arg_32_0, arg_32_4, arg_32_7, arg_32_8)) and not var_0_0._check_cooldown(arg_32_8, arg_32_1, arg_32_9) then
			if not var_32_5 then
				var_32_4 = var_0_0.wield_input(arg_32_4, arg_32_5, var_32_0)
			end

			if not var_32_4 and not arg_32_3.keep_buffer then
				arg_32_4:reset_input_buffer()
			end

			return arg_32_1, arg_32_2
		else
			arg_32_4:add_buffer(var_32_0)
		end
	end
end

function var_0_0.validate_action(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9)
	return var_0_4(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9)
end

local var_0_5 = {
	cutting_berserker = true,
	cutting = true
}
local var_0_6 = {}

function var_0_0.update_weapon_actions(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0, var_34_1, var_34_2 = var_0_0.get_item_data_and_weapon_extensions(arg_34_3)

	table.clear(var_0_6)

	if not var_34_0 then
		return
	end

	local var_34_3
	local var_34_4
	local var_34_5
	local var_34_6
	local var_34_7
	local var_34_8
	local var_34_9
	local var_34_10, var_34_11, var_34_12 = var_0_0.get_current_action_data(var_34_2, var_34_1)
	local var_34_13 = BackendUtils.get_item_template(var_34_0)
	local var_34_14, var_34_15 = arg_34_4:recently_damaged()
	local var_34_16 = ScriptUnit.extension(arg_34_1, "status_system")
	local var_34_17 = ScriptUnit.extension(arg_34_1, "buff_system")
	local var_34_18 = false

	if var_34_10 then
		var_34_18 = ActionUtils.is_melee_start_sub_action(var_34_10) and var_34_17:has_buff_perk("uninterruptible_heavy")
	end

	local var_34_19
	local var_34_20
	local var_34_21 = Managers.player:owner(arg_34_1)
	local var_34_22 = var_34_21 and var_34_21.bot_player
	local var_34_23 = var_34_2 and var_34_2.ammo_extension or var_34_1 and var_34_1.ammo_extension
	local var_34_24 = Unit.get_data(arg_34_1, "breed")

	if var_34_14 and var_0_5[var_34_14] and not var_34_24.boss then
		if var_34_23 then
			if var_34_2 and var_34_2.ammo_extension then
				var_34_20 = var_34_2.ammo_extension:is_reloading()
			end

			if var_34_1 and var_34_1.ammo_extension then
				var_34_20 = var_34_1.ammo_extension:is_reloading()
			end
		end

		if ((not var_34_10 or not var_34_10.uninterruptible) and not script_data.uninterruptible and not var_34_20 and not var_34_22 and not var_34_17:has_buff_perk("uninterruptible") and not var_34_18 or false) and (var_34_14 == "cutting_berserker" and true or var_34_16:hitreact_interrupt()) and not var_34_16:is_disabled() then
			if var_34_17:has_buff_perk("reduced_hit_react") then
				var_34_15 = "light"
			end

			if var_34_10 then
				var_34_11:stop_action("interrupted")
			end

			local var_34_25 = ScriptUnit.extension(arg_34_1, "first_person_system")

			var_0_0.play_animation_event(arg_34_1, "hit_reaction")

			if var_34_15 == "medium" then
				var_34_25:play_hud_sound_event("enemy_hit_medium")
			elseif var_34_15 == "heavy" then
				var_34_25:play_hud_sound_event("enemy_hit_heavy")
			end

			if not Development.parameter("attract_mode") then
				if var_34_14 == "cutting_berserker" then
					var_34_16:set_hit_react_type(var_34_15)
					var_34_16:set_pushed_no_cooldown(true, arg_34_0)
				else
					var_34_16:set_hit_react_type(var_34_15)
					var_34_16:set_pushed(true, arg_34_0)
				end
			end

			return
		end
	end

	local var_34_26

	if var_34_10 then
		local var_34_27

		var_34_3, var_34_4, var_34_27, var_34_6 = var_0_0._get_chain_action_data(var_34_13, var_34_11, var_34_10, arg_34_2, arg_34_3, arg_34_1, arg_34_0, var_34_23)

		if not var_34_3 then
			if var_34_10.allow_hold_toggle and arg_34_2.toggle_alternate_attack then
				local var_34_28 = var_34_10.lookup_data.action_name

				if var_34_28 and arg_34_2:get(var_34_28, true) and var_34_11:can_stop_hold_action(arg_34_0) then
					var_34_11:stop_action("hold_input_released")
				end
			elseif var_34_10.kind ~= "block" or not arg_34_2:is_input_blocked() then
				local var_34_29 = var_34_10.hold_input

				if var_34_29 and not arg_34_2:get(var_34_29) and var_34_11:can_stop_hold_action(arg_34_0) then
					var_34_11:stop_action("hold_input_released")
				end
			end
		end
	elseif var_34_13.next_action then
		local var_34_30 = var_34_13.next_action

		var_34_26 = var_34_30.action_init_data

		local var_34_31 = var_34_30.action
		local var_34_32 = true
		local var_34_33 = var_34_13.actions[var_34_31]

		for iter_34_0, iter_34_1 in pairs(var_34_33) do
			if iter_34_0 ~= "default" and iter_34_1.condition_func then
				var_34_3, var_34_4 = var_0_4(arg_34_1, var_34_31, iter_34_0, iter_34_1, arg_34_2, arg_34_3, var_34_32, nil, var_34_11, arg_34_0)

				if var_34_3 and var_34_4 then
					break
				end
			end
		end

		if not var_34_3 then
			local var_34_34 = var_34_13.actions[var_34_31].default

			var_34_3, var_34_4 = var_0_4(arg_34_1, var_34_31, "default", var_34_34, arg_34_2, arg_34_3, var_34_32, nil, var_34_11, arg_34_0)
		end

		var_34_13.next_action = nil
	else
		local var_34_35 = 0

		for iter_34_2, iter_34_3 in pairs(var_34_13.actions) do
			for iter_34_4, iter_34_5 in pairs(iter_34_3) do
				if iter_34_4 ~= "default" and iter_34_5.condition_func then
					local var_34_36 = iter_34_5.weapon_action_hand or "right"
					local var_34_37 = iter_34_5.action_priority or 1

					if var_34_35 < var_34_37 then
						local var_34_38 = var_34_36 == "right" and var_34_1 or var_34_2
						local var_34_39, var_34_40 = var_0_4(arg_34_1, iter_34_2, iter_34_4, iter_34_5, arg_34_2, arg_34_3, false, var_34_23, var_34_38, arg_34_0)

						if var_34_39 and var_34_40 then
							var_34_3 = var_34_39
							var_34_4 = var_34_40
							var_34_35 = var_34_37
						end
					end
				end
			end

			local var_34_41 = var_34_13.actions[iter_34_2].default

			if var_34_41 then
				local var_34_42 = var_34_41.weapon_action_hand or "right"
				local var_34_43 = var_34_41.action_priority or 1

				if var_34_35 < var_34_43 then
					local var_34_44 = var_34_42 == "right" and var_34_1 or var_34_2
					local var_34_45, var_34_46 = var_0_4(arg_34_1, iter_34_2, "default", var_34_41, arg_34_2, arg_34_3, false, var_34_23, var_34_44, arg_34_0)

					if var_34_45 and var_34_46 then
						var_34_3 = var_34_45
						var_34_4 = var_34_46
						var_34_35 = var_34_43
					end
				end
			end
		end
	end

	if var_34_3 and var_34_4 then
		local var_34_47 = ScriptUnit.extension(arg_34_1, "career_system"):get_career_power_level()
		local var_34_48 = var_34_13.actions[var_34_3][var_34_4]
		local var_34_49 = var_34_48.weapon_action_hand or "right"

		var_0_6.new_action = var_34_3
		var_0_6.new_sub_action = var_34_4
		var_0_6.new_action_settings = var_34_48

		if var_34_49 == "both" then
			assert(var_34_2 and var_34_1, "tried to start a dual wield weapon action without both a left and right hand wielded unit")

			if var_34_12 == "left" then
				var_34_2:stop_action("new_interupting_action", var_0_6)
			elseif var_34_12 == "right" then
				var_34_1:stop_action("new_interupting_action", var_0_6)
			elseif var_34_12 == "both" then
				var_34_2:stop_action("new_interupting_action", var_0_6)
				var_34_1:stop_action("new_interupting_action", var_0_6)
			end

			local var_34_50 = var_34_26 and table.merge(var_34_26, {
				action_hand = "left"
			}) or {
				action_hand = "left"
			}
			local var_34_51 = var_34_26 and table.merge(var_34_26, {
				action_hand = "right"
			}) or {
				action_hand = "right"
			}

			var_34_2:start_action(var_34_3, var_34_4, var_34_13.actions, arg_34_0, var_34_47, var_34_50)
			var_34_1:start_action(var_34_3, var_34_4, var_34_13.actions, arg_34_0, var_34_47, var_34_51)

			return
		end

		if var_34_49 == "either" then
			var_34_49 = var_34_1 and "right" or "left"
		end

		if var_34_49 == "left" then
			assert(var_34_2, "tried to start a left hand weapon action without a left hand wielded unit")

			if var_34_12 == "right" then
				var_34_1:stop_action("new_interupting_action", var_0_6)
			elseif var_34_12 == "both" then
				var_34_2:stop_action("new_interupting_action", var_0_6)
				var_34_1:stop_action("new_interupting_action", var_0_6)
			end

			var_34_2:start_action(var_34_3, var_34_4, var_34_13.actions, arg_34_0, var_34_47, var_34_26)

			return
		end

		assert(var_34_1, "tried to start a right hand weapon action without a right hand wielded unit")

		if var_34_12 == "left" then
			var_34_2:stop_action("new_interupting_action", var_0_6)
		elseif var_34_12 == "both" then
			var_34_2:stop_action("new_interupting_action", var_0_6)
			var_34_1:stop_action("new_interupting_action", var_0_6)
		end

		var_34_1:start_action(var_34_3, var_34_4, var_34_13.actions, arg_34_0, var_34_47, var_34_26)

		if var_34_6 then
			arg_34_2:force_release_input(var_34_6)
		end
	end
end

function var_0_0.stop_weapon_actions(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0:equipment()
	local var_35_1 = var_35_0.right_hand_wielded_unit
	local var_35_2 = var_35_0.left_hand_wielded_unit
	local var_35_3 = Unit.alive(var_35_1) and ScriptUnit.extension(var_35_1, "weapon_system")
	local var_35_4 = Unit.alive(var_35_2) and ScriptUnit.extension(var_35_2, "weapon_system")

	if var_35_3 and var_35_3.current_action_settings then
		var_35_3:stop_action(arg_35_1)
	end

	if var_35_4 and var_35_4.current_action_settings then
		var_35_4:stop_action(arg_35_1)
	end
end

function var_0_0.stop_career_abilities(arg_36_0, arg_36_1)
	arg_36_0:stop_ability(arg_36_1)
end

function var_0_0.check_crouch(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	local var_37_0 = arg_37_2:is_crouching()
	local var_37_1 = var_37_0
	local var_37_2 = arg_37_1:get("crouch")
	local var_37_3 = Managers.input:is_device_active("gamepad")
	local var_37_4 = arg_37_1:get("crouching")

	if var_37_3 and Managers.matchmaking and Managers.matchmaking:is_matchmaking_in_inn() then
		var_37_2 = false
		var_37_4 = false
	end

	if arg_37_3 and var_37_2 then
		var_37_1 = arg_37_2:crouch_toggle()
	elseif not arg_37_3 and not var_37_4 then
		var_37_1 = false
	elseif not arg_37_3 and var_37_4 then
		var_37_1 = true
	end

	if var_37_1 and not var_37_0 then
		var_0_0.crouch(arg_37_0, arg_37_5, arg_37_4, arg_37_2)
	elseif not var_37_1 and var_37_0 and var_0_0.can_uncrouch(arg_37_0) then
		var_0_0.uncrouch(arg_37_0, arg_37_5, arg_37_4, arg_37_2)
	end

	return var_37_0
end

function var_0_0.can_uncrouch(arg_38_0)
	local var_38_0 = Unit.mover(arg_38_0)
	local var_38_1 = Mover.position(var_38_0)

	return Unit.mover_fits_at(arg_38_0, "standing", var_38_1)
end

function var_0_0.crouch(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	var_0_0.play_animation_event(arg_39_0, "to_crouch")
	var_0_0.play_animation_event_first_person(arg_39_2, "to_crouch")
	var_0_0.set_animation_var_first_person(arg_39_2, "is_crouched", 1)
	arg_39_2:set_wanted_player_height("crouch", arg_39_1)
	ScriptUnit.extension(arg_39_0, "locomotion_system"):set_active_mover("crouch")
	arg_39_3:set_crouching(true)
	ScriptUnit.extension(arg_39_0, "buff_system"):trigger_procs("on_crouch")
end

function var_0_0.uncrouch(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	var_0_0.play_animation_event(arg_40_0, "to_uncrouch")
	var_0_0.play_animation_event_first_person(arg_40_2, "to_uncrouch")
	var_0_0.set_animation_var_first_person(arg_40_2, "is_crouched", 0)
	arg_40_2:set_wanted_player_height("stand", arg_40_1)
	ScriptUnit.extension(arg_40_0, "locomotion_system"):set_active_mover("standing")
	arg_40_3:set_crouching(false)
end

local var_0_7 = 0.05
local var_0_8 = 2.1

function var_0_0.get_move_animation(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = var_0_0.get_movement_input(arg_41_1)
	local var_41_1 = "move_fwd"
	local var_41_2 = "move_bwd"
	local var_41_3

	if arg_41_2.unit then
		local var_41_4 = arg_41_2.unit
		local var_41_5 = Unit.get_data(var_41_4, "breed")

		if var_41_5 then
			local var_41_6 = var_41_5.run_threshold

			if var_41_6 then
				local var_41_7 = var_41_5.walk_threshold or var_41_6 * 0.9
				local var_41_8 = var_41_6

				if arg_41_3 == var_41_1 or arg_41_3 == var_41_2 then
					var_41_8 = var_41_7
				end

				var_41_3 = var_41_8 < Vector3.length(Vector3.flat(arg_41_0:current_velocity()))
			end
		end
	end

	var_41_3 = var_41_3 or Vector3.length(Vector3.flat(arg_41_0:current_velocity())) > var_0_8

	if Vector3.length(arg_41_0:current_velocity()) < var_0_7 then
		return "idle", "idle"
	end

	if var_41_0.y < 0 then
		return var_41_2, var_41_3 and var_41_2 or "walk_bwd"
	end

	return var_41_1, var_41_3 and var_41_1 or "walk_fwd"
end

function var_0_0.is_colliding_down(arg_42_0)
	local var_42_0 = Unit.mover(arg_42_0)

	return Mover.collides_down(var_42_0)
end

function var_0_0.is_colliding_sides(arg_43_0)
	local var_43_0 = Unit.mover(arg_43_0)

	return Mover.collides_sides(var_43_0)
end

function var_0_0.has_move_input(arg_44_0)
	local var_44_0 = var_0_0.get_movement_input(arg_44_0)

	return Vector3.length(var_44_0) > 0
end

function var_0_0.is_moving(arg_45_0)
	local var_45_0 = arg_45_0:current_velocity()

	return Vector3.length_squared(var_45_0) > 0.001
end

function var_0_0.is_moving_backwards(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_1:current_rotation()
	local var_46_1 = Vector3.flat(arg_46_0:current_velocity())

	return Vector3.dot(var_46_1, var_46_0) < -0.1
end

function var_0_0.is_knocked_down(arg_47_0)
	return arg_47_0:is_knocked_down()
end

function var_0_0.is_staggered(arg_48_0)
	return arg_48_0:is_staggered()
end

function var_0_0.is_pounced_down(arg_49_0)
	return arg_49_0:is_pounced_down()
end

function var_0_0.is_catapulted(arg_50_0)
	local var_50_0, var_50_1 = arg_50_0:is_catapulted()

	return var_50_0, var_50_1
end

function var_0_0.is_grabbed_by_pack_master(arg_51_0)
	return arg_51_0:is_grabbed_by_pack_master()
end

function var_0_0.is_grabbed_by_tentacle(arg_52_0)
	return arg_52_0.grabbed_by_tentacle
end

function var_0_0.is_in_vortex(arg_53_0)
	return arg_53_0.in_vortex
end

function var_0_0.is_overcharge_exploding(arg_54_0)
	return arg_54_0:is_overcharge_exploding()
end

function var_0_0.pack_master_status(arg_55_0)
	return arg_55_0.pack_master_status
end

function var_0_0.corruptor_status(arg_56_0)
	return arg_56_0.corruptor_status
end

function var_0_0.grabbed_by_tentacle_status(arg_57_0)
	return arg_57_0.grabbed_by_tentacle_status
end

function var_0_0.grabbed_by_chaos_spawn_status(arg_58_0)
	return arg_58_0.grabbed_by_chaos_spawn_status, arg_58_0.grabbed_by_chaos_spawn_status_count
end

function var_0_0.is_waiting_for_assisted_respawn(arg_59_0)
	return arg_59_0:is_ready_for_assisted_respawn()
end

function var_0_0.is_assisted_respawning(arg_60_0)
	return arg_60_0:is_assisted_respawning()
end

function var_0_0.is_pushed(arg_61_0)
	return arg_61_0:is_pushed()
end

function var_0_0.is_charged(arg_62_0)
	return arg_62_0:is_charged()
end

function var_0_0.is_block_broken(arg_63_0)
	return arg_63_0:is_block_broken()
end

function var_0_0.is_dead(arg_64_0)
	return arg_64_0:is_dead()
end

function var_0_0.is_using_transport(arg_65_0)
	return arg_65_0:is_using_transport()
end

function var_0_0.is_zooming(arg_66_0)
	return arg_66_0:is_zooming()
end

function var_0_0.is_crouching(arg_67_0)
	return arg_67_0:is_crouching()
end

function var_0_0.is_starting_interaction(arg_68_0, arg_68_1)
	local var_68_0, var_68_1, var_68_2, var_68_3 = arg_68_1:can_interact()

	if GameSettingsDevelopment.disabled_interactions[var_68_2] then
		return false
	end

	local var_68_4 = InteractionHelper.interaction_action_names(arg_68_0.unit, var_68_3)

	return var_68_0 and var_68_2 ~= "heal" and var_68_2 ~= "give_item" and arg_68_0:get(var_68_4, true)
end

function var_0_0.is_interacting(arg_69_0)
	return arg_69_0:is_interacting()
end

function var_0_0.is_waiting_for_interaction_approval(arg_70_0)
	return arg_70_0:is_waiting_for_interaction_approval()
end

function var_0_0.interact(arg_71_0, arg_71_1)
	if arg_71_1:interaction_config().hold then
		local var_71_0 = arg_71_1:interaction_hold_input()

		if not arg_71_0:get(var_71_0) then
			arg_71_1:abort_interaction()

			return false
		end
	end

	return true
end

function var_0_0.will_be_ledge_hanging(arg_72_0, arg_72_1, arg_72_2)
	if not script_data.ledge_hanging_turned_off then
		local var_72_0 = arg_72_2.collision_filter or "filter_ledge_collision"
		local var_72_1, var_72_2 = var_0_0.is_raycasting_to_gameplay_collision_box(arg_72_0, arg_72_1, var_72_0, arg_72_2)

		if var_72_1 then
			local var_72_3 = Vector3.z(arg_72_2 and arg_72_2.ray_position or Unit.world_position(arg_72_1, 0)) + (arg_72_2 and arg_72_2.z_offset or 0)
			local var_72_4 = Unit.node(var_72_2, "g_gameplay_ledge_trigger_box")

			if var_72_3 <= Vector3.z(Unit.world_position(var_72_2, var_72_4)) then
				arg_72_2.ledge_unit = var_72_2

				return true
			end
		end
	end

	return false
end

local var_0_9 = 4

function var_0_0.is_raycasting_to_gameplay_collision_box(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
	local var_73_0 = World.get_data(arg_73_0, "physics_world")
	local var_73_1 = arg_73_3 and arg_73_3.ray_position or POSITION_LOOKUP[arg_73_1]
	local var_73_2 = PlayerUnitMovementSettings.get_movement_settings_table(arg_73_1)
	local var_73_3 = arg_73_3 and arg_73_3.movement_settings_table_name or "gameplay_collision_box"
	local var_73_4 = var_73_2[var_73_3].collision_check_player_half_height
	local var_73_5 = var_73_2[var_73_3].collision_check_player_height_offset
	local var_73_6 = var_73_1 + Vector3(0, 0, var_73_5 * 2)
	local var_73_7
	local var_73_8
	local var_73_9, var_73_10 = PhysicsWorld.immediate_raycast(var_73_0, var_73_6, Vector3.down(), var_73_4 * 4, "all", "collision_filter", arg_73_2)

	for iter_73_0 = 1, var_73_10 do
		local var_73_11 = var_73_9[iter_73_0][var_0_9]
		local var_73_12 = Actor.unit(var_73_11)

		if Unit.get_data(var_73_12, "is_ledge_unit") then
			var_73_7 = true
			var_73_8 = var_73_12
		else
			var_73_7 = false
			var_73_8 = nil

			break
		end
	end

	if var_73_7 and var_73_8 then
		local var_73_13 = arg_73_3 and arg_73_3.radius or 0.15
		local var_73_14 = 4
		local var_73_15 = PhysicsWorld.linear_sphere_sweep(var_73_0, var_73_6, var_73_6 + Vector3.down() * var_73_4 * 4, var_73_13, var_73_14, "collision_filter", arg_73_2, "report_initial_overlap")

		if var_73_15 then
			for iter_73_1 = 1, #var_73_15 do
				local var_73_16 = var_73_15[iter_73_1].actor
				local var_73_17 = Actor.unit(var_73_16)

				if Unit.get_data(var_73_17, "is_ledge_unit") then
					var_73_7 = true
					var_73_8 = var_73_17
				else
					var_73_7 = false
					var_73_8 = nil

					break
				end
			end
		end
	end

	return var_73_7, var_73_8
end

function var_0_0.is_ledge_hanging(arg_74_0, arg_74_1, arg_74_2)
	if not script_data.ledge_hanging_turned_off then
		local var_74_0, var_74_1 = var_0_0.is_colliding_with_gameplay_collision_box(arg_74_0, arg_74_1, "filter_ledge_collision", arg_74_2)

		if var_74_0 then
			local var_74_2 = Vector3.z(arg_74_2 and arg_74_2.position or Unit.world_position(arg_74_1, 0)) + (arg_74_2 and arg_74_2.z_offset or 0)
			local var_74_3 = Unit.node(var_74_1, "g_gameplay_ledge_trigger_box")

			if var_74_2 <= Vector3.z(Unit.world_position(var_74_1, var_74_3)) then
				arg_74_2.ledge_unit = var_74_1

				return true
			end
		end
	end

	return false
end

function var_0_0.recently_left_ladder(arg_75_0, arg_75_1)
	return arg_75_0:has_recently_left_ladder(arg_75_1)
end

function var_0_0.change_camera_state(arg_76_0, arg_76_1, arg_76_2)
	if arg_76_0.bot_player then
		return
	end

	if Development.parameter("third_person_mode") and arg_76_1 == "follow" then
		arg_76_1 = "follow_third_person_over_shoulder"
	end

	Managers.state.entity:system("camera_system"):external_state_change(arg_76_0, arg_76_1, arg_76_2)
end

function var_0_0.change_camera_state_delayed(arg_77_0, arg_77_1, arg_77_2, arg_77_3)
	if arg_77_0.bot_player then
		return
	end

	if Development.parameter("third_person_mode") and arg_77_1 == "follow" then
		arg_77_1 = "follow_third_person_over_shoulder"
	end

	Managers.state.entity:system("camera_system"):external_state_change_delayed(arg_77_0, arg_77_1, arg_77_2, arg_77_3)
end

function var_0_0.play_animation_event(arg_78_0, arg_78_1)
	Managers.state.network:anim_event(arg_78_0, arg_78_1)
end

function var_0_0.play_animation_event_first_person(arg_79_0, arg_79_1)
	arg_79_0:animation_event(arg_79_1)
end

function var_0_0.set_animation_var_first_person(arg_80_0, arg_80_1, arg_80_2)
	arg_80_0:animation_set_variable(arg_80_1, arg_80_2)
end

function var_0_0.play_animation_event_with_variable_float(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	Managers.state.network:anim_event_with_variable_float(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
end

function var_0_0.set_animation_variable_float(arg_82_0, arg_82_1, arg_82_2)
	Managers.state.network:anim_set_variable_float(arg_82_0, arg_82_1, arg_82_2)
end

function var_0_0.is_enemy_character(arg_83_0)
	local var_83_0 = Managers.state.side.side_by_unit[arg_83_0]

	if var_83_0 and var_83_0:name() == "dark_pact" then
		return true
	end

	return false
end

function var_0_0.is_viable_stab_target(arg_84_0, arg_84_1, arg_84_2)
	if arg_84_2:disabled_by_other(arg_84_0) then
		return false
	end

	local var_84_0 = arg_84_2:is_using_transport()
	local var_84_1 = var_0_0.is_enemy_character(arg_84_1)

	if var_84_0 or var_84_1 then
		return false
	end

	return true
end

function var_0_0.ghost_mode(arg_85_0, arg_85_1)
	if not arg_85_0:is_in_ghost_mode() then
		if arg_85_1:get("ghost_mode_enter") and arg_85_0:allowed_to_enter() then
			arg_85_0:try_enter_ghost_mode()
		end
	elseif arg_85_0:is_in_ghost_mode() then
		if arg_85_1:get("ghost_mode_exit") and arg_85_0:allowed_to_leave() then
			local var_85_0 = false

			arg_85_0:try_leave_ghost_mode(var_85_0)
		elseif arg_85_1:get("ghost_mode_enter") then
			local var_85_1 = false

			arg_85_0:teleport_player(var_85_1)
		end
	end
end

function var_0_0.handle_bot_ledge_hanging_failsafe(arg_86_0, arg_86_1)
	if arg_86_1 and ALIVE[arg_86_0] then
		local var_86_0 = BLACKBOARDS[arg_86_0]
		local var_86_1 = var_86_0.locomotion_extension

		if var_86_1.external_velocity then
			return false
		else
			local var_86_2 = var_86_0.navigation_extension:current_goal()

			if not var_86_2 then
				local var_86_3 = var_86_0.ai_bot_group_extension.data.follow_unit

				if ALIVE[var_86_3] then
					var_86_2 = ScriptUnit.extension(var_86_3, "whereabouts_system"):last_position_on_navmesh()
				else
					var_86_2 = var_86_0.navigation_extension:destination()
				end
			end

			if var_86_2 then
				var_86_1:teleport_to(var_86_2)

				return true
			end
		end
	end

	return false
end
