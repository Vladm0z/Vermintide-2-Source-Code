-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_animated_jump.lua

EnemyCharacterStateAnimatedJump = class(EnemyCharacterStateAnimatedJump, EnemyCharacterState)

EnemyCharacterStateAnimatedJump.do_the_transition = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	return
end

EnemyCharacterStateAnimatedJump.setup_transition = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	return
end

EnemyCharacterStateAnimatedJump.init = function (arg_3_0, arg_3_1, arg_3_2)
	EnemyCharacterStateAnimatedJump.super.init(arg_3_0, arg_3_1, arg_3_2)
end

EnemyCharacterStateAnimatedJump.on_enter = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	local var_4_0 = arg_4_0._input_extension
	local var_4_1 = arg_4_0._first_person_extension
	local var_4_2 = arg_4_0._status_extension
	local var_4_3 = arg_4_0._inventory_extension
	local var_4_4 = arg_4_0._health_extension
	local var_4_5 = arg_4_0._locomotion_extension
	local var_4_6 = arg_4_0._breed

	Managers.telemetry_events:node_climb(var_4_6.name, POSITION_LOOKUP[arg_4_1])

	local var_4_7 = arg_4_0._breed.climb_type == "climb"

	arg_4_0.is_climber = var_4_7
	arg_4_0._camera_transitioned_back = nil
	arg_4_0._control_back = nil

	local var_4_8 = Managers.player:owner(arg_4_1)

	arg_4_0._player = var_4_8

	if var_4_2:get_unarmed() then
		CharacterStateHelper.play_animation_event(arg_4_1, "to_armed")
	end

	CharacterStateHelper.play_animation_event(arg_4_1, "climbing")
	CharacterStateHelper.change_camera_state(var_4_8, "follow_third_person_smart_climbing")

	local var_4_9 = false
	local var_4_10
	local var_4_11 = false

	if var_4_2:get_unarmed() then
		var_4_11 = true
	end

	var_4_1:set_first_person_mode(var_4_9, var_4_10, var_4_11)

	local var_4_12 = arg_4_7.jump_data

	if not var_4_12 then
		error("Missing jump_data")
	end

	var_4_2:set_should_climb(false)
	var_4_2:set_is_climbing(true)

	local var_4_13 = var_4_12.swap_entrance_exit
	local var_4_14 = var_4_12.jump_object_data
	local var_4_15
	local var_4_16

	if var_4_13 then
		var_4_15 = Vector3Aux.unbox(var_4_14.pos1)
		var_4_16 = Vector3Aux.unbox(var_4_14.pos2)
	else
		var_4_15 = Vector3Aux.unbox(var_4_14.pos2)
		var_4_16 = Vector3Aux.unbox(var_4_14.pos1)
	end

	if not var_4_7 then
		local var_4_17 = Vector3.normalize(Vector3.flat(var_4_16 - var_4_15))
		local var_4_18 = Quaternion.look(var_4_17)

		var_4_5:teleport_to(var_4_16, var_4_18)
	elseif var_4_7 then
		local var_4_19 = var_4_14.data

		arg_4_0:setup_transition(arg_4_1, var_4_19, var_4_15, var_4_16)

		arg_4_0._fail_timer = arg_4_5 + 7

		local var_4_20, var_4_21 = CharacterStateHelper.get_move_animation(arg_4_0._locomotion_extension, var_4_0, var_4_2)

		arg_4_0.move_anim_3p = var_4_20
		arg_4_0.move_anim_1p = var_4_21

		CharacterStateHelper.play_animation_event(arg_4_1, var_4_20)
		CharacterStateHelper.play_animation_event_first_person(var_4_1, var_4_21)

		local var_4_22 = BLACKBOARDS[arg_4_1]

		var_4_22.jump_start_finished = nil
		var_4_22.jump_climb_finished = nil
	end

	CharacterStateHelper.look(var_4_0, arg_4_0._player.viewport_name, var_4_1, var_4_2, var_4_3)
	CharacterStateHelper.update_weapon_actions(arg_4_5, arg_4_1, var_4_0, var_4_3, var_4_4)
	arg_4_0:set_breed_action("climbing")
end

EnemyCharacterStateAnimatedJump.on_exit = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	local var_5_0 = BLACKBOARDS[arg_5_1]

	if var_5_0 then
		var_5_0.jump_climb_finished = nil
		var_5_0.jump_camera_transition = nil
		var_5_0.jump_give_control = nil
	end

	local var_5_1 = arg_5_0._status_extension

	var_5_1:set_is_climbing(false)

	if var_5_1:get_unarmed() then
		CharacterStateHelper.play_animation_event(arg_5_1, "to_unarmed")
	end

	if not arg_5_0._camera_transitioned_back then
		arg_5_0:start_camera_transition()
	end

	if not arg_5_0._control_back then
		arg_5_0:grant_control_to_player()
	end

	arg_5_0:set_breed_action("n/a")

	ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

EnemyCharacterStateAnimatedJump.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0._csm
	local var_6_1 = arg_6_0._input_extension
	local var_6_2 = arg_6_0._status_extension
	local var_6_3 = arg_6_0._first_person_extension
	local var_6_4 = arg_6_0._locomotion_extension
	local var_6_5 = arg_6_0._inventory_extension
	local var_6_6 = CharacterStateHelper

	if var_6_4:is_on_ground() then
		ScriptUnit.extension(arg_6_1, "whereabouts_system"):set_is_onground()
	end

	local var_6_7 = arg_6_0._health_extension

	var_6_6.update_weapon_actions(arg_6_5, arg_6_1, var_6_1, var_6_5, var_6_7)

	if var_6_6.do_common_state_transitions(var_6_2, var_6_0) then
		return
	end

	if var_6_6.is_using_transport(var_6_2) then
		var_6_0:change_state("using_transport")

		return
	end

	if not arg_6_0.is_climber then
		arg_6_0:to_movement_state()

		return
	end

	local var_6_8 = BLACKBOARDS[arg_6_1]

	if var_6_8.jump_camera_transition and not arg_6_0._camera_transitioned_back then
		arg_6_0:start_camera_transition()
	end

	if arg_6_0:do_the_transition(arg_6_1, arg_6_5, arg_6_3, var_6_4) then
		arg_6_0:to_movement_state()
	elseif var_6_8.jump_give_control and not arg_6_0._control_back and arg_6_0:has_movement_input() then
		arg_6_0:to_movement_state()
	end

	if var_6_4:is_animation_driven() then
		return
	end

	var_6_6.look(var_6_1, arg_6_0._player.viewport_name, var_6_3, var_6_2, var_6_5)
end

EnemyCharacterStateAnimatedJump.grant_control_to_player = function (arg_7_0)
	local var_7_0 = arg_7_0._locomotion_extension
	local var_7_1 = Unit.animation_wanted_root_pose(arg_7_0._unit)

	var_7_0:teleport_to(Matrix4x4.translation(var_7_1))
	var_7_0:set_wanted_velocity(Vector3.zero())
	var_7_0:enable_script_driven_movement()
	var_7_0:set_animation_translation_scale(Vector3(1, 1, 1))
	var_7_0:force_on_ground(true)

	arg_7_0._control_back = true
end

EnemyCharacterStateAnimatedJump.start_camera_transition = function (arg_8_0)
	local var_8_0 = arg_8_0._first_person_extension

	CharacterStateHelper.change_camera_state(arg_8_0._player, "follow")
	CharacterStateHelper.play_animation_event_first_person(var_8_0, "idle")
	var_8_0:toggle_visibility(0.4)

	arg_8_0._camera_transitioned_back = true
end
