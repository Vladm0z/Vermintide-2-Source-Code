-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_climbing.lua

EnemyCharacterStateClimbing = class(EnemyCharacterStateClimbing, EnemyCharacterStateAnimatedJump)

local function var_0_0(arg_1_0)
	if type(arg_1_0) == "table" then
		return arg_1_0[Math.random(1, #arg_1_0)]
	else
		return arg_1_0
	end
end

EnemyCharacterStateClimbing.init = function (arg_2_0, arg_2_1)
	EnemyCharacterStateClimbing.super.init(arg_2_0, arg_2_1, "climbing")
end

EnemyCharacterStateClimbing.setup_transition = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0.smart_object_data = arg_3_2

	local var_3_0 = POSITION_LOOKUP[arg_3_1]

	arg_3_3.z = var_3_0.z

	local var_3_1 = Vector3Aux.unbox(arg_3_2.ledge_position)

	arg_3_0._ledge_position = Vector3Box(var_3_1)
	arg_3_0._entrance_pos = Vector3Box(arg_3_3)
	arg_3_0._exit_pos = Vector3Box(arg_3_4)
	arg_3_0._climb_upwards = true
	arg_3_0.jump_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(arg_3_4 - arg_3_3)))

	local var_3_2 = arg_3_3 - var_3_0
	local var_3_3 = Vector3.length(var_3_2)

	arg_3_0._correction_dir = Vector3Box(var_3_3 > 0 and Vector3.divide(var_3_2, var_3_3) or Vector3.zero())
	arg_3_0._correction_amount = var_3_3

	if not arg_3_2.is_on_edge then
		if arg_3_2.ledge_position1 then
			local var_3_4 = Vector3Aux.unbox(arg_3_2.ledge_position1)
			local var_3_5 = Vector3Aux.unbox(arg_3_2.ledge_position2)
			local var_3_6 = Vector3.distance_squared(var_3_4, arg_3_3) < Vector3.distance_squared(var_3_5, arg_3_3) and var_3_4 or var_3_5

			arg_3_0._climb_jump_height = var_3_6.z - arg_3_3.z

			arg_3_0._ledge_position:store(var_3_6)
		else
			arg_3_0._climb_jump_height = var_3_1.z - arg_3_3.z

			if arg_3_0._climb_jump_height < 0 then
				arg_3_2.is_on_edge = true
			end
		end
	end

	if arg_3_2.is_on_edge then
		if arg_3_3.z > arg_3_4.z then
			arg_3_0._climb_jump_height = arg_3_3.z - arg_3_4.z
			arg_3_0._climb_upwards = false
		else
			arg_3_0._climb_jump_height = arg_3_4.z - arg_3_3.z
		end
	end

	arg_3_0._sub_state = "moving_to_to_entrance"
end

EnemyCharacterStateClimbing.do_the_transition = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = POSITION_LOOKUP[arg_4_1]
	local var_4_1 = BLACKBOARDS[arg_4_1]
	local var_4_2 = arg_4_0.smart_object_data.is_on_edge

	if arg_4_0._sub_state == "moving_to_to_entrance" then
		local var_4_3 = arg_4_0._entrance_pos:unbox()
		local var_4_4 = arg_4_0._exit_pos:unbox()

		arg_4_4:enable_animation_driven_movement_entrance_and_exit_no_mover(var_4_3, var_4_4)

		local var_4_5 = arg_4_0.jump_ledge_lookat_direction:unbox()
		local var_4_6 = Quaternion.look(var_4_5)

		arg_4_0._first_person_extension:set_rotation(var_4_6)

		local var_4_7 = SmartObjectSettings.templates[arg_4_0._breed.smart_object_template]

		if arg_4_0._climb_upwards or not var_4_2 then
			local var_4_8 = 1
			local var_4_9 = var_4_7.jump_up_anim_thresholds
			local var_4_10 = arg_4_0._climb_jump_height

			for iter_4_0 = 1, #var_4_9 do
				local var_4_11 = var_4_9[iter_4_0]

				if var_4_10 < var_4_11.height_threshold then
					local var_4_12 = var_4_2 and var_4_11.animation_edge or var_4_11.animation_fence

					Managers.state.network:anim_event(arg_4_1, var_0_0(var_4_12))

					local var_4_13 = var_4_11.fence_vertical_length or var_4_11.vertical_length
					local var_4_14 = var_4_11.vertical_length
					local var_4_15 = var_4_2 and var_4_14 or var_4_13

					var_4_8 = var_4_8 * var_4_10 / var_4_15

					arg_4_4:set_animation_translation_scale(Vector3(1, 1, var_4_8))

					break
				end
			end

			arg_4_4:set_wanted_velocity(Vector3.zero())

			arg_4_0._sub_state = "waiting_for_finished_climb_anim"
		else
			local var_4_16 = var_4_7.jump_down_anim_thresholds
			local var_4_17 = math.abs(arg_4_0._climb_jump_height)

			for iter_4_1 = 1, #var_4_16 do
				local var_4_18 = var_4_16[iter_4_1]

				if var_4_17 < var_4_18.height_threshold then
					local var_4_19 = var_4_2 and var_4_18.animation_edge or var_4_18.animation_fence

					Managers.state.network:anim_event(arg_4_1, var_0_0(var_4_19))

					local var_4_20 = var_4_18.animation_land or "jump_down_land"

					arg_4_0._jump_down_land_animation = var_0_0(var_4_20)

					break
				end
			end

			arg_4_0._sub_state = "waiting_to_reach_ground"
		end
	end

	if arg_4_0._sub_state == "waiting_for_finished_climb_anim" then
		arg_4_0:_apply_position_correction(arg_4_1, var_4_0, arg_4_3)

		if var_4_1.jump_climb_finished then
			var_4_1.jump_climb_finished = nil

			local var_4_21 = arg_4_0._exit_pos:unbox()
			local var_4_22 = var_4_2 and var_4_21 or arg_4_0._ledge_position:unbox()

			if var_4_2 then
				arg_4_0._sub_state = "done"
			else
				local var_4_23 = SmartObjectSettings.templates[arg_4_0._breed.smart_object_template].jump_down_anim_thresholds
				local var_4_24 = var_4_22.z - var_4_21.z

				for iter_4_2 = 1, #var_4_23 do
					local var_4_25 = var_4_23[iter_4_2]

					if var_4_24 < var_4_25.height_threshold then
						local var_4_26 = 1
						local var_4_27 = var_4_25.fence_horizontal_length
						local var_4_28 = (Vector3.length(Vector3.flat(var_4_0 - var_4_21)) - var_4_25.fence_land_length) / (var_4_27 * var_4_26)

						arg_4_4:set_animation_translation_scale(Vector3(var_4_28, var_4_28, 1))

						local var_4_29 = var_4_25.animation_fence

						Managers.state.network:anim_event(arg_4_1, var_0_0(var_4_29))

						local var_4_30 = var_4_25.animation_land or "jump_down_land"

						arg_4_0._jump_down_land_animation = var_0_0(var_4_30)

						break
					end
				end

				arg_4_0._sub_state = "waiting_to_reach_ground"
			end
		end
	end

	if arg_4_0._sub_state == "waiting_to_reach_ground" then
		local var_4_31 = arg_4_0._exit_pos:unbox()
		local var_4_32 = arg_4_4:current_velocity()

		if var_4_0.z + var_4_32.z * arg_4_3 * 2 <= var_4_31.z then
			arg_4_4:set_animation_translation_scale(Vector3(1, 1, 1))

			local var_4_33 = arg_4_0._jump_down_land_animation

			Managers.state.network:anim_event(arg_4_1, var_4_33)

			arg_4_0._sub_state = "done"
		end
	end

	if arg_4_0._sub_state == "done" or arg_4_2 > arg_4_0._fail_timer then
		if arg_4_2 > arg_4_0._fail_timer then
			Application.warning("Breed " .. Unit.get_data(arg_4_1, "breed").name .. " failed to climb at position %q", arg_4_0._entrance_pos:unbox())
		end

		return true
	end
end

EnemyCharacterStateClimbing._apply_position_correction = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0._correction_amount * math.min(3 * arg_5_3, 1)

	arg_5_0._correction_amount = arg_5_0._correction_amount - var_5_0

	local var_5_1 = arg_5_2 + Vector3.multiply(arg_5_0._correction_dir:unbox(), var_5_0)
	local var_5_2 = Unit.mover(arg_5_1)

	if var_5_2 then
		Mover.set_position(var_5_2, var_5_1)
		Unit.set_local_position(arg_5_1, 0, var_5_1)
	end
end
