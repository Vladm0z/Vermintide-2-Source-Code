-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_pinning.lua

GutterRunnerStatePinning = class(GutterRunnerStatePinning, EnemyCharacterState)

function GutterRunnerStatePinning.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "pinning_enemy")

	arg_1_0.lerp_target_position = Vector3Box()
	arg_1_0.lerp_start_position = Vector3Box()
	arg_1_0.breed = Unit.get_data(arg_1_0._unit, "breed")
	arg_1_0._foff_ability_id = arg_1_0._career_extension:ability_id("foff")
end

function GutterRunnerStatePinning.change_to_third_person_camera(arg_2_0)
	CharacterStateHelper.change_camera_state(arg_2_0._player, "follow_third_person")
	arg_2_0._first_person_extension:set_first_person_mode(false)
end

function GutterRunnerStatePinning.pounce_down(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._locomotion_extension
	local var_3_1 = POSITION_LOOKUP[arg_3_2]

	var_3_0:set_wanted_velocity(Vector3.zero())

	local var_3_2 = Unit.mover(arg_3_1)

	Mover.set_position(var_3_2, var_3_1)
	LocomotionUtils.separate_mover_fallbacks(var_3_2, 1)

	local var_3_3 = Mover.position(var_3_2)

	var_3_0:teleport_to(var_3_3)

	local var_3_4 = Quaternion.flat_no_roll(Unit.local_rotation(arg_3_1, 0))

	Unit.set_local_rotation(arg_3_1, 0, var_3_4)
	arg_3_0._locomotion_extension:set_disable_rotation_update()

	local var_3_5 = Managers.state.network
	local var_3_6 = var_3_5:unit_game_object_id(arg_3_1)

	if Managers.state.network.is_server then
		var_3_5.network_transmit:send_rpc_clients("rpc_teleport_unit_to", var_3_6, var_3_3, var_3_4)
	else
		var_3_5.network_transmit:send_rpc_server("rpc_teleport_unit_to", var_3_6, var_3_3, var_3_4)
	end

	StatusUtils.set_pounced_down_network("pounced_down", arg_3_2, true, arg_3_1)
	ScriptUnit.extension(arg_3_2, "status_system"):add_pacing_intensity(CurrentIntensitySettings.intensity_add_pounced_down)

	local var_3_7 = arg_3_0._blackboard
	local var_3_8 = var_3_7.breed
	local var_3_9 = arg_3_3 - var_3_7.pounce_start_time
	local var_3_10 = var_3_8.name
	local var_3_11 = var_3_9 / var_3_8.pounce_max_damage_time
	local var_3_12 = math.clamp(var_3_11 * var_3_8.max_pounce_damage, var_3_8.min_pounce_damage, var_3_8.max_pounce_damage)
	local var_3_13

	DamageUtils.add_damage_network(arg_3_2, arg_3_1, var_3_12, "torso", "cutting", nil, Vector3(1, 0, 0), var_3_10, nil, nil, nil, var_3_13, nil, nil, nil, nil, nil, nil, 1)

	local var_3_14 = BreedActions.skaven_gutter_runner.target_pounced

	BTTargetPouncedAction.impact_pushback(arg_3_1, var_3_1, var_3_14.close_impact_radius, var_3_14.far_impact_radius, var_3_14.impact_speed_given, var_3_7.target_unit)
end

function GutterRunnerStatePinning.on_enter(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	local var_4_0 = arg_4_0._unit
	local var_4_1 = arg_4_0._first_person_extension
	local var_4_2 = arg_4_7.target_unit

	arg_4_0._blackboard = BLACKBOARDS[var_4_0]
	arg_4_0._blackboard.start_pouncing_time = arg_4_5

	arg_4_0:set_breed_action("target_pounced")
	var_4_1:play_unit_sound_event("Play_versus_gutterrunner_jump_attack_hit", var_4_0, 0)
	arg_4_0:pounce_down(var_4_0, var_4_2, arg_4_5)

	arg_4_0.target_unit = var_4_2
	arg_4_0.target_status_extension = ScriptUnit.extension(var_4_2, "status_system")

	CharacterStateHelper.stop_weapon_actions(arg_4_0._inventory_extension, "pinning_enemy")
	CharacterStateHelper.stop_career_abilities(arg_4_0._career_extension, "pinning_enemy")
	arg_4_0._locomotion_extension:set_forced_velocity(Vector3:zero())
	arg_4_0:change_to_third_person_camera()

	arg_4_0._next_stab_time = arg_4_5

	arg_4_0._status_extension:set_pinning_enemy(true, var_4_2)
end

function GutterRunnerStatePinning.on_exit(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	CharacterStateHelper.change_camera_state(arg_5_0._player, "follow")
	arg_5_0._first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

	if ALIVE[arg_5_0.target_unit] then
		StatusUtils.set_pounced_down_network("pounced_down", arg_5_0.target_unit, false, arg_5_1)
	else
		arg_5_0._status_extension:set_pinning_enemy(false, arg_5_0.target_unit)
	end

	arg_5_0:set_breed_action("n/a")

	local var_5_0 = arg_5_0._career_extension:current_ability_cooldown(arg_5_0._foff_ability_id)

	if var_5_0 < 1 then
		arg_5_0._career_extension:reduce_activated_ability_cooldown((1 - var_5_0) * -1, arg_5_0._foff_ability_id)
	end
end

function GutterRunnerStatePinning.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0._csm
	local var_6_1 = arg_6_0._unit
	local var_6_2 = arg_6_0._locomotion_extension
	local var_6_3 = arg_6_0._input_extension
	local var_6_4 = arg_6_0._status_extension
	local var_6_5 = arg_6_0._first_person_extension
	local var_6_6 = arg_6_0.target_unit
	local var_6_7 = arg_6_0.target_status_extension

	if not HEALTH_ALIVE[var_6_6] then
		local var_6_8 = arg_6_0._temp_params

		var_6_0:change_state("standing", var_6_8)

		return
	end

	if var_6_7:is_knocked_down() then
		local var_6_9 = arg_6_0._temp_params

		var_6_0:change_state("standing", var_6_9)

		return
	end

	local var_6_10 = arg_6_0._buff_extension:has_buff_type("vs_gutter_runner_allow_dismount")

	if not CharacterStateHelper.is_viable_stab_target(var_6_1, var_6_6, var_6_7) or (var_6_3:get("jump") or var_6_3:get("action_two")) and var_6_10 then
		var_6_7:set_pounced_down(false, var_6_1)

		local var_6_11 = arg_6_0._temp_params

		var_6_0:change_state("standing", var_6_11)

		return
	end

	arg_6_0:update_stabbing(arg_6_5, arg_6_3, var_6_1, var_6_6)

	if CharacterStateHelper.do_common_state_transitions(var_6_4, var_6_0) then
		return
	end

	arg_6_0._locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_6_3, arg_6_0._player.viewport_name, arg_6_0._first_person_extension, var_6_4, arg_6_0._inventory_extension)
end

function GutterRunnerStatePinning.update_stabbing(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = 0.5

	if arg_7_1 > arg_7_0._next_stab_time then
		local var_7_1 = BreedActions.skaven_gutter_runner.target_pounced
		local var_7_2 = (arg_7_1 - arg_7_0._blackboard.start_pouncing_time - arg_7_0.breed.time_before_ramping_damage) / arg_7_0.breed.time_to_reach_max_damage
		local var_7_3 = math.clamp(var_7_2, 0, 1)
		local var_7_4 = arg_7_0.breed.base_damage * (1 + var_7_3 * arg_7_0.breed.final_damage_multiplier)

		AiUtils.damage_target(arg_7_4, arg_7_3, var_7_1, var_7_4)

		arg_7_0._next_stab_time = arg_7_1 + var_7_0
	end
end
