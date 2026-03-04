-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_prowling.lua

GutterRunnerStateProwling = class(GutterRunnerStateProwling, EnemyCharacterState)

function GutterRunnerStateProwling.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "gutter_runner_prowling")

	local var_1_0 = arg_1_1

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.latest_valid_navmesh_position = Vector3Box(math.huge, math.huge, math.huge)
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
end

function GutterRunnerStateProwling.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0._pounce_ready = false

	local var_2_0 = arg_2_0._unit
	local var_2_1 = arg_2_0._input_extension
	local var_2_2 = arg_2_0._first_person_extension
	local var_2_3 = arg_2_0._status_extension
	local var_2_4 = arg_2_0._inventory_extension
	local var_2_5 = arg_2_0._health_extension
	local var_2_6 = arg_2_0._locomotion_extension:current_velocity()

	arg_2_0._breed = Unit.get_data(var_2_0, "breed")

	local var_2_7 = Managers.player:owner(var_2_0)
	local var_2_8 = var_2_7 and var_2_7.bot_player

	if arg_2_6 == "standing" then
		arg_2_0.current_movement_speed_scale = 0
	else
		arg_2_0.current_movement_speed_scale = 1
	end

	if not var_2_8 then
		local var_2_9 = Vector3.normalize(Vector3.flat(var_2_6))
		local var_2_10 = var_2_2:current_rotation()
		local var_2_11 = Vector3.dot(Quaternion.right(var_2_10), var_2_9)
		local var_2_12 = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(var_2_10))), var_2_9)
		local var_2_13 = Vector3(var_2_11, var_2_12, 0)

		arg_2_0.last_input_direction:store(var_2_13)
	end

	local var_2_14, var_2_15 = CharacterStateHelper.get_move_animation(arg_2_0._locomotion_extension, var_2_1, var_2_3, arg_2_0.move_anim_3p)

	arg_2_0.move_anim_3p = var_2_14
	arg_2_0.move_anim_1p = var_2_15

	CharacterStateHelper.play_animation_event(var_2_0, var_2_14)
	CharacterStateHelper.play_animation_event_first_person(var_2_2, var_2_15)
	CharacterStateHelper.look(var_2_1, arg_2_0._player.viewport_name, var_2_2, var_2_3, var_2_4)
	CharacterStateHelper.update_weapon_actions(arg_2_5, var_2_0, var_2_1, var_2_4, var_2_5)
	var_2_2:play_unit_sound_event("Play_versus_gutterrunner_jump_attack_enter", var_2_0, 0)

	arg_2_0.is_bot = var_2_8

	arg_2_0:_start_priming(arg_2_5)

	arg_2_0._exit_with_priming = true

	arg_2_0:set_breed_action("prepare_crazy_jump")

	arg_2_0._left_wpn_particle_name = "fx/wpnfx_gutter_runner_enemy_in_range_1p"
	arg_2_0._left_wpn_particle_node_name = "g_wpn_left_claw"
	arg_2_0._right_wpn_particle_name = "fx/wpnfx_gutter_runner_enemy_in_range_1p"
	arg_2_0._right_wpn_particle_node_name = "g_wpn_right_claw"

	arg_2_0._ghost_mode_extension:set_external_no_spawn_reason("prowling", true)
end

function GutterRunnerStateProwling.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	EnemyCharacterState.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)

	if arg_3_7 or not Managers.state.network:game() then
		return
	end

	arg_3_0._pounce_ready = nil

	if not arg_3_0._exit_with_priming then
		arg_3_0:_stop_priming(arg_3_5)
	end

	arg_3_0:_set_priming_progress(0)
	arg_3_0:set_breed_action("n/a")
	arg_3_0._ghost_mode_extension:set_external_no_spawn_reason("prowling", nil)
end

function GutterRunnerStateProwling.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = arg_4_0._world
	local var_4_2 = arg_4_0._unit
	local var_4_3 = PlayerUnitMovementSettings.get_movement_settings_table(var_4_2)
	local var_4_4 = arg_4_0._input_extension
	local var_4_5 = arg_4_0._status_extension
	local var_4_6 = arg_4_0._first_person_extension
	local var_4_7 = arg_4_0._locomotion_extension
	local var_4_8 = arg_4_0._health_extension
	local var_4_9 = arg_4_0._inventory_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_5, var_4_0) then
		arg_4_0._exit_with_priming = false

		return
	end

	local var_4_10 = false

	if var_4_4:get("dark_pact_action_one_release") then
		arg_4_0:_update_priming(arg_4_5, arg_4_3, true)

		if arg_4_0._done_priming then
			arg_4_0:_start_pounce()

			return
		else
			var_4_10 = true
		end

		arg_4_0._pounce_ready = true
	else
		arg_4_0:_update_priming(arg_4_5, arg_4_3, false)
	end

	if var_4_4:get("dark_pact_action_two") or var_4_10 then
		var_4_6:play_hud_sound_event("Stop_versus_gutterrunner_jump_charge_loop")

		arg_4_0._exit_with_priming = false

		var_4_0:change_state("walking")

		return
	end

	local var_4_11 = arg_4_0.current_movement_speed_scale
	local var_4_12 = CharacterStateHelper

	if var_4_7:is_on_ground() then
		ScriptUnit.extension(var_4_2, "whereabouts_system"):set_is_onground()
	end

	if var_4_12.is_using_transport(var_4_5) then
		var_4_0:change_state("using_transport")

		return
	end

	if var_4_12.is_pushed(var_4_5) then
		var_4_5:set_pushed(false)

		local var_4_13 = var_4_3.stun_settings.pushed

		var_4_13.hit_react_type = var_4_5:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_13)

		return
	end

	if var_4_7:is_animation_driven() then
		return
	end

	local var_4_14 = Managers.input:is_device_active("gamepad")

	if not var_4_0.state_next and not var_4_7:is_on_ground() then
		var_4_0:change_state("falling", arg_4_0._temp_params)
		var_4_6:change_state("falling")

		return
	end

	local var_4_15 = Managers.player:owner(var_4_2)
	local var_4_16 = var_4_12.get_movement_input(var_4_4)
	local var_4_17 = var_4_12.has_move_input(var_4_4)

	if not arg_4_0.is_bot then
		local var_4_18 = arg_4_0._breed and arg_4_0._breed.breed_move_acceleration_up
		local var_4_19 = arg_4_0._breed and arg_4_0._breed.breed_move_acceleration_down
		local var_4_20 = var_4_18 * arg_4_3 or var_4_3.move_acceleration_up * arg_4_3
		local var_4_21 = var_4_19 * arg_4_3 or var_4_3.move_acceleration_down * arg_4_3

		if var_4_17 then
			var_4_11 = math.min(1, var_4_11 + var_4_20)

			if var_4_14 then
				var_4_11 = Vector3.length(var_4_16) * var_4_11
			end
		else
			var_4_11 = math.max(0, var_4_11 - var_4_21)
		end
	else
		var_4_11 = var_4_17 and 1 or 0
	end

	local var_4_22 = var_4_3.crouch_move_speed * var_4_5:current_move_speed_multiplier() * var_4_11 * var_4_3.player_speed_scale
	local var_4_23 = Vector3.normalize(var_4_16)

	if Vector3.length_squared(var_4_16) == 0 then
		var_4_23 = arg_4_0.last_input_direction:unbox()
	else
		arg_4_0.last_input_direction:store(var_4_23)
	end

	var_4_12.move_on_ground(var_4_6, var_4_4, var_4_7, var_4_23, var_4_22, var_4_2)
	var_4_12.look(var_4_4, arg_4_0._player.viewport_name, var_4_6, var_4_5, var_4_9)

	local var_4_24, var_4_25 = var_4_12.get_move_animation(var_4_7, var_4_4, var_4_5, arg_4_0.move_anim_3p)

	if var_4_24 ~= arg_4_0.move_anim_3p then
		var_4_12.play_animation_event(var_4_2, var_4_24)

		arg_4_0.move_anim_3p = var_4_24
	end

	if var_4_25 ~= arg_4_0.move_anim_1p then
		var_4_12.play_animation_event_first_person(var_4_6, var_4_25)

		arg_4_0.move_anim_1p = var_4_25
	end

	arg_4_0.current_movement_speed_scale = var_4_11
end

function GutterRunnerStateProwling._start_priming(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._first_person_extension

	var_5_0:play_hud_sound_event("Play_versus_gutterrunner_jump_charge_loop")
	CharacterStateHelper.play_animation_event(arg_5_0._unit, "to_crouch")
	CharacterStateHelper.play_animation_event_first_person(var_5_0, "to_crouch")

	local var_5_1 = arg_5_0._locomotion_extension

	arg_5_0._done_priming = false
	arg_5_0._prime_time = arg_5_1 + arg_5_0._breed.pounce_prime_time

	var_5_0:set_wanted_player_height("crouch", arg_5_1, arg_5_0._breed.pounce_prime_time)
	var_5_1:set_active_mover("crouch")
end

function GutterRunnerStateProwling._set_priming_progress(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._career_extension
	local var_6_1 = "pounce"
	local var_6_2 = var_6_0:ability_id(var_6_1)

	var_6_0:get_activated_ability_data(var_6_2).priming_progress = arg_6_1

	arg_6_0._first_person_extension:animation_set_variable("pounce_charge", arg_6_1, true)
end

local var_0_0 = 0.025

function GutterRunnerStateProwling._update_priming(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if arg_7_1 > arg_7_0._prime_time or arg_7_3 and arg_7_1 > arg_7_0._prime_time - var_0_0 then
		if not arg_7_0._done_priming then
			arg_7_0._first_person_extension:play_hud_sound_event("Play_versus_gutterrunner_jump_charge_end")
		end

		arg_7_0._done_priming = true
	end

	local var_7_0 = arg_7_0._breed.pounce_prime_time
	local var_7_1 = math.min(var_7_0 - (arg_7_0._prime_time - arg_7_1), var_7_0) / var_7_0

	arg_7_0:_set_priming_progress(var_7_1)
end

function GutterRunnerStateProwling._stop_priming(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._first_person_extension

	CharacterStateHelper.play_animation_event(arg_8_0._unit, "to_upright")
	CharacterStateHelper.play_animation_event_first_person(var_8_0, "to_upright")

	local var_8_1 = arg_8_0._locomotion_extension

	var_8_0:set_wanted_player_height("stand", arg_8_1)
	var_8_1:set_active_mover("standing")
end

function GutterRunnerStateProwling._start_pounce(arg_9_0)
	if not arg_9_0._locomotion_extension:is_on_ground() then
		return
	end

	local var_9_0 = arg_9_0._first_person_extension
	local var_9_1 = arg_9_0._world
	local var_9_2 = arg_9_0._is_server
	local var_9_3 = arg_9_0.local_player
	local var_9_4 = arg_9_0._status_extension
	local var_9_5 = arg_9_0._breed
	local var_9_6 = var_9_5.pounce_speed
	local var_9_7 = var_9_0:current_rotation()
	local var_9_8 = Quaternion.forward(var_9_7)
	local var_9_9 = Vector3.normalize(var_9_8 + Vector3(0, 0, var_9_5.pounce_upwards_amount)) * var_9_6

	var_9_4.do_pounce = {
		anim_start_event = "to_crouch",
		initial_velocity = Vector3Box(var_9_9)
	}

	local var_9_10 = arg_9_0._career_extension
	local var_9_11 = var_9_10:ability_id("pounce")

	if var_9_10:can_use_activated_ability(var_9_11) then
		arg_9_0._csm:change_state("pouncing")
	end
end
