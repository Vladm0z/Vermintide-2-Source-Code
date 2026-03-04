-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_jump_across.lua

EnemyCharacterStateJumpAcross = class(EnemyCharacterStateJumpAcross, EnemyCharacterStateAnimatedJump)

local function var_0_0(arg_1_0)
	if type(arg_1_0) == "table" then
		return arg_1_0[Math.random(1, #arg_1_0)]
	else
		return arg_1_0
	end
end

function EnemyCharacterStateJumpAcross.init(arg_2_0, arg_2_1)
	EnemyCharacterStateJumpAcross.super.init(arg_2_0, arg_2_1, "jump_across")
end

function EnemyCharacterStateJumpAcross.setup_transition(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0.smart_object_data = arg_3_2

	local var_3_0 = POSITION_LOOKUP[arg_3_1]

	arg_3_0._entrance_pos = Vector3Box(var_3_0)
	arg_3_0._exit_pos = Vector3Box(arg_3_4)
	arg_3_0._sub_state = "moving_to_to_entrance"

	arg_3_0._locomotion_extension:set_animation_translation_scale(Vector3(1, 1, 1))

	arg_3_0.jump_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(arg_3_4 - var_3_0)))
end

function EnemyCharacterStateJumpAcross.do_the_transition(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_0._sub_state == "moving_to_to_entrance" then
		local var_4_0 = arg_4_0._entrance_pos:unbox()
		local var_4_1 = arg_4_0._exit_pos:unbox()

		arg_4_4:enable_animation_driven_movement_entrance_and_exit_no_mover(var_4_0, var_4_1)

		local var_4_2 = arg_4_0.jump_ledge_lookat_direction:unbox()
		local var_4_3 = Quaternion.look(var_4_2)

		arg_4_0._first_person_extension:set_rotation(var_4_3)

		local var_4_4 = var_4_1 - var_4_0
		local var_4_5 = Vector3.length(Vector3.flat(var_4_4))
		local var_4_6 = SmartObjectSettings.templates[arg_4_0._breed.smart_object_template].jump_across_anim_thresholds

		for iter_4_0 = 1, #var_4_6 do
			local var_4_7 = var_4_6[iter_4_0]

			if var_4_5 < var_4_7.horizontal_threshold then
				Managers.state.network:anim_event(arg_4_1, var_0_0(var_4_7.animation_jump))

				local var_4_8 = var_4_5 / var_4_7.horizontal_length
				local var_4_9 = var_4_4.z

				arg_4_4:set_animation_translation_scale(Vector3(var_4_8, var_4_8, var_4_9))

				break
			end
		end

		ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = true
		arg_4_0._sub_state = "waiting_for_finished_climb_anim"
	end

	if arg_4_0._sub_state == "waiting_for_finished_climb_anim" and BLACKBOARDS[arg_4_1].jump_start_finished then
		arg_4_0._sub_state = "done"
	end

	if arg_4_0._sub_state == "done" or arg_4_2 > arg_4_0._fail_timer then
		if arg_4_2 > arg_4_0._fail_timer then
			Application.warning("Breed " .. Unit.get_data(arg_4_1, "breed").name .. " failed to jump across at position %q", arg_4_0._entrance_pos:unbox())
		end

		return true
	end
end
