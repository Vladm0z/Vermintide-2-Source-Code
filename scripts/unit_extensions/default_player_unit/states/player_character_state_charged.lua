-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_charged.lua

PlayerCharacterStateCharged = class(PlayerCharacterStateCharged, PlayerCharacterState)

PlayerCharacterStateCharged.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "charged")

	local var_1_0 = arg_1_1

	arg_1_0.inputs_to_buffer = {
		wield_4_alt = true,
		wield_2 = true,
		wield_5 = true,
		action_career_release = true,
		action_career = true,
		wield_3 = true,
		wield_1 = true,
		wield_4 = true,
		action_one = true,
		wield_switch = true
	}
	arg_1_0.movement_speed = 0
	arg_1_0.movement_speed_limit = 1
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
	arg_1_0.look_override = Vector3Box(0, 0, 0)
end

PlayerCharacterStateCharged.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "charged")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "charged")
	CharacterStateHelper.play_animation_event_first_person(arg_2_0.first_person_extension, arg_2_7.first_person_anim_name)
	CharacterStateHelper.play_animation_event(arg_2_1, arg_2_7.third_person_anim_name)

	local var_2_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local var_2_1 = arg_2_7.hit_react_type or "light"

	assert(var_2_0.hit_react_settings[var_2_1])

	local var_2_2 = var_2_0.hit_react_settings[var_2_1]
	local var_2_3, var_2_4 = var_2_2.look_override_function()

	arg_2_0.movement_speed = var_2_2.movement_speed_modifier
	arg_2_0.movement_speed_modifier = var_2_2.movement_speed_modifier
	arg_2_0.end_look_sense_override = var_2_2.end_look_sense_override
	arg_2_0.start_look_sense_override = var_2_2.start_look_sense_override

	local var_2_5 = var_2_2.duration_function()
	local var_2_6 = var_2_2.onscreen_particle_function(var_2_5)
	local var_2_7 = ScriptUnit.has_extension(arg_2_1, "first_person_system")

	if var_2_7 and var_2_6 then
		arg_2_0.onscreen_particle_id = var_2_7:create_screen_particles(var_2_6)
	end

	if var_2_7 then
		var_2_7:play_hud_sound_event("Play_enemy_bestigor_charge_impact")
		var_2_7:set_wanted_player_height("charged", arg_2_5, var_2_5 / 2)
	end

	arg_2_0.last_input_direction:store(Vector3(0, 0, 0))

	if var_2_4 and var_2_3 then
		arg_2_0.look_override:store(Vector3(var_2_3, var_2_4, 0))
	end

	arg_2_0.duration = var_2_5
	arg_2_0.time_in_state = 0
	arg_2_0.end_time = arg_2_5 + var_2_5
	arg_2_0.next_pulse = 0
	arg_2_0.current_stagger_speed = 1
	arg_2_0.last_stagger = Vector3Box(0, 0, 0)

	print("-----Enter charged")
end

PlayerCharacterStateCharged.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.input_extension

	if var_3_0:get("action_one_hold") then
		var_3_0:add_stun_buffer("action_one_hold")
	end

	local var_3_1 = ScriptUnit.has_extension(arg_3_1, "first_person_system")

	if var_3_1 and arg_3_0.onscreen_particle_id then
		var_3_1:stop_spawning_screen_particles(arg_3_0.onscreen_particle_id)
	end

	if var_3_1 then
		var_3_1:set_wanted_player_height("stand", arg_3_5, 0.2)
	end

	arg_3_0.status_extension:set_charged(false)

	if CharacterStateHelper.is_block_broken(arg_3_0.status_extension) then
		arg_3_0.status_extension:set_block_broken(false)
	end

	print("-----Exit charged")
end

PlayerCharacterStateCharged.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.input_extension
	local var_4_3 = arg_4_0.inventory_extension
	local var_4_4 = arg_4_0.status_extension
	local var_4_5 = arg_4_0.locomotion_extension
	local var_4_6 = arg_4_0.world
	local var_4_7 = PlayerUnitMovementSettings.get_movement_settings_table(var_4_1)
	local var_4_8 = arg_4_0.first_person_extension

	arg_4_0.time_in_state = arg_4_0.time_in_state + arg_4_3

	if var_4_8 and arg_4_0.time_in_state >= arg_4_0.duration / 2 then
		var_4_8:set_wanted_player_height("stand", arg_4_5, arg_4_0.duration / 2)
	end

	if CharacterStateHelper.do_common_state_transitions(var_4_4, var_4_0, "charged") then
		return
	end

	if CharacterStateHelper.is_ledge_hanging(var_4_6, var_4_1, arg_4_0.temp_params) then
		var_4_0:change_state("ledge_hanging", arg_4_0.temp_params)

		return
	end

	if arg_4_5 > arg_4_0.end_time then
		var_4_0:change_state("standing")

		return
	end

	if CharacterStateHelper.is_overcharge_exploding(var_4_4) then
		var_4_0:change_state("overcharge_exploding")

		return
	end

	arg_4_0:queue_input(arg_4_2, var_4_2, var_4_3)

	local var_4_9 = CharacterStateHelper.has_move_input(var_4_2)
	local var_4_10 = arg_4_0.inventory_extension
	local var_4_11 = Managers.player:owner(var_4_1)

	if var_4_9 then
		arg_4_0.movement_speed = math.min(0.75, arg_4_0.movement_speed + var_4_7.move_acceleration_up * arg_4_3)
	elseif var_4_11 and var_4_11.bot_player then
		arg_4_0.movement_speed = 0
	else
		arg_4_0.movement_speed = math.max(arg_4_0.movement_speed_limit, arg_4_0.movement_speed - var_4_7.move_acceleration_down * arg_4_3)
	end

	local var_4_12 = var_4_2:get("walk")
	local var_4_13 = var_4_4:is_crouching() and var_4_7.crouch_move_speed or var_4_12 and var_4_7.walk_move_speed or var_4_7.move_speed
	local var_4_14 = var_4_4:current_move_speed_multiplier()

	if var_4_12 ~= arg_4_0.walking then
		var_4_4:set_slowed(var_4_12)
	end

	local var_4_15 = var_4_13 * var_4_14 * var_4_7.player_speed_scale * arg_4_0.movement_speed
	local var_4_16 = Vector3(0, 0, 0)
	local var_4_17 = var_4_2:get("move")

	if var_4_17 then
		var_4_16 = var_4_16 + var_4_17
	end

	local var_4_18 = var_4_2:get("move_controller")

	if var_4_18 then
		local var_4_19 = Vector3.length(var_4_18)

		if var_4_19 > 0 then
			var_4_15 = var_4_15 * var_4_19
		end

		var_4_16 = var_4_16 + var_4_18
	end

	local var_4_20

	if arg_4_5 > arg_4_0.next_pulse then
		local var_4_21 = Vector3(2 * (math.random() - 0.5), 2 * (math.random() - 0.5), 0)
		local var_4_22 = Vector3.normalize(var_4_21)
		local var_4_23 = Vector3.length(var_4_21)

		arg_4_0.next_pulse = arg_4_5 + 0.2

		arg_4_0.last_stagger:store(var_4_21)

		arg_4_0.current_stagger_speed = 1
	end

	local var_4_24 = var_4_16 + arg_4_0.last_stagger:unbox()

	arg_4_0.current_stagger_speed = math.max(0, arg_4_0.current_stagger_speed - var_4_7.move_acceleration_down * arg_4_3)

	local var_4_25 = var_4_15 * arg_4_0.current_stagger_speed * arg_4_0.movement_speed_modifier
	local var_4_26
	local var_4_27 = Vector3.normalize(var_4_24)

	if Vector3.length(var_4_27) == 0 then
		var_4_27 = arg_4_0.last_input_direction:unbox()
	else
		arg_4_0.last_input_direction:store(var_4_27)
	end

	CharacterStateHelper.move_on_ground(var_4_8, var_4_2, var_4_5, var_4_27, var_4_25, var_4_1)

	arg_4_0.walking = var_4_12

	if not var_4_0.state_next and not var_4_5:is_on_ground() then
		var_4_0:change_state("falling")

		return
	end

	local var_4_28

	if arg_4_0.look_override then
		var_4_28 = arg_4_0.look_override:unbox()
	end

	local var_4_29 = arg_4_0.time_in_state / arg_4_0.duration
	local var_4_30 = math.min(arg_4_0.end_look_sense_override, math.lerp(arg_4_0.start_look_sense_override, 1, var_4_29))

	CharacterStateHelper.look(var_4_2, arg_4_0.player.viewport_name, arg_4_0.first_person_extension, var_4_4, arg_4_0.inventory_extension, var_4_30, var_4_28)
	CharacterStateHelper.update_weapon_actions(arg_4_5, var_4_1, var_4_2, var_4_10, arg_4_0.health_extension)
	arg_4_0.look_override:store(0, 0, 0)
end

PlayerCharacterStateCharged.queue_input = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = CharacterStateHelper.wield_input(arg_5_2, arg_5_3, "action_wield")

	if var_5_0 then
		arg_5_2:add_buffer(var_5_0)
	end

	for iter_5_0, iter_5_1 in pairs(arg_5_0.inputs_to_buffer) do
		if arg_5_2:get(iter_5_0) then
			arg_5_2:add_stun_buffer(iter_5_0)

			break
		end
	end
end
