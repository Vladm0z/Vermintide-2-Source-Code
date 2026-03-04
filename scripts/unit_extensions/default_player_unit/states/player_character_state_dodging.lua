-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_dodging.lua

PlayerCharacterStateDodging = class(PlayerCharacterStateDodging, PlayerCharacterState)

PlayerCharacterStateDodging.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "dodging")

	local var_1_0 = arg_1_1

	arg_1_0.movement_speed = 0
	arg_1_0.dodge_direction = Vector3Box(0, 0, 0)
	arg_1_0.last_position = Vector3Box(0, 0, 0)
end

PlayerCharacterStateDodging.on_enter_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local var_2_1 = arg_2_0.dodge_direction:unbox()
	local var_2_2 = Vector3.x(var_2_1)
	local var_2_3 = Vector3.y(var_2_1)
	local var_2_4 = "dodge_time"
	local var_2_5 = arg_2_0.estimated_dodge_time
	local var_2_6 = arg_2_0.first_person_extension

	if math.abs(var_2_3) > math.abs(var_2_2) then
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, "dodge_bwd", var_2_4, var_2_5)
		CharacterStateHelper.play_animation_event_first_person(var_2_6, "dodge_bwd")
	elseif var_2_2 > 0 then
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, "dodge_left", var_2_4, var_2_5)
		CharacterStateHelper.play_animation_event_first_person(var_2_6, "dodge_left")
	else
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, "dodge_right", var_2_4, var_2_5)
		CharacterStateHelper.play_animation_event_first_person(var_2_6, "dodge_right")
	end
end

PlayerCharacterStateDodging.on_enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_0.unit
	local var_3_1 = arg_3_0.input_extension
	local var_3_2 = arg_3_0.first_person_extension
	local var_3_3 = arg_3_0.status_extension
	local var_3_4 = arg_3_0.inventory_extension
	local var_3_5 = arg_3_0.health_extension

	arg_3_0.dodge_direction:store(arg_3_7.dodge_direction)

	arg_3_7.dodge_direction = nil

	local var_3_6 = PlayerUnitMovementSettings.get_movement_settings_table(var_3_0)

	var_3_3:set_dodge_jump_override_t(arg_3_5, var_3_6.dodging.dodge_jump_override_timer)
	arg_3_0:start_dodge(var_3_0, arg_3_5)
	CharacterStateHelper.look(var_3_1, arg_3_0.player.viewport_name, var_3_2, var_3_3, var_3_4)
	CharacterStateHelper.update_weapon_actions(arg_3_5, var_3_0, var_3_1, var_3_4, var_3_5)
	arg_3_0:on_enter_animation(var_3_0)
	arg_3_0.locomotion_extension:enable_rotation_towards_velocity(false)

	local var_3_7 = Quaternion.forward(var_3_2:current_rotation())

	Vector3.set_z(var_3_7, 0)

	local var_3_8 = Vector3.normalize(var_3_7)
	local var_3_9 = Quaternion.look(var_3_8, Vector3(0, 0, 1))

	Unit.set_local_rotation(var_3_0, 0, var_3_9)
end

PlayerCharacterStateDodging.on_exit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local var_4_1 = math.max(var_4_0.dodging.dodge_cd, var_4_0.dodging.dodge_jump_override_timer - arg_4_0.time_in_dodge)

	arg_4_0.status_extension:set_dodge_cd(arg_4_5, var_4_1)

	arg_4_0.dodge_timer = nil
	arg_4_0.dodge_stand_still_timer = nil
	arg_4_0.dodge_return_timer = nil

	arg_4_0.locomotion_extension:enable_rotation_towards_velocity(true)
	arg_4_0.status_extension:start_dodge_cooldown(arg_4_5)
	arg_4_0.buff_extension:trigger_procs("on_dodge_finished")

	local var_4_2 = Managers.state.network

	if var_4_2:game() then
		CharacterStateHelper.play_animation_event(arg_4_1, "dodge_end")

		if not LEVEL_EDITOR_TEST then
			local var_4_3 = var_4_2:unit_game_object_id(arg_4_1)

			arg_4_0.status_extension:set_is_dodging(false)
			var_4_2.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, var_4_3, 0)
		end
	end
end

PlayerCharacterStateDodging.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.unit
	local var_5_2 = PlayerUnitMovementSettings.get_movement_settings_table(var_5_1)
	local var_5_3 = arg_5_0.input_extension
	local var_5_4 = arg_5_0.status_extension
	local var_5_5 = arg_5_0.first_person_extension

	arg_5_0.time_in_dodge = arg_5_0.time_in_dodge + arg_5_3

	ScriptUnit.extension(var_5_1, "whereabouts_system"):set_is_onground()

	if CharacterStateHelper.do_common_state_transitions(var_5_4, var_5_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_5_4) then
		var_5_0:change_state("using_transport")

		return
	end

	if not var_5_0.state_next and var_5_4.do_leap then
		var_5_0:change_state("leaping")

		return true
	end

	if CharacterStateHelper.is_pushed(var_5_4) then
		var_5_4:set_pushed(false)

		local var_5_6 = var_5_2.stun_settings.pushed

		var_5_6.hit_react_type = var_5_4:hit_react_type() .. "_push"

		var_5_0:change_state("stunned", var_5_6)

		return
	end

	if CharacterStateHelper.is_charged(var_5_4) then
		local var_5_7 = var_5_2.charged_settings.charged

		var_5_7.hit_react_type = "charged"

		var_5_0:change_state("charged", var_5_7)

		return
	end

	if CharacterStateHelper.is_block_broken(var_5_4) then
		var_5_4:set_block_broken(false)

		local var_5_8 = var_5_2.stun_settings.parry_broken

		var_5_8.hit_react_type = "medium_push"

		var_5_0:change_state("stunned", var_5_8)

		return
	end

	local var_5_9 = arg_5_0.interactor_extension

	if CharacterStateHelper.is_starting_interaction(var_5_3, var_5_9) then
		local var_5_10, var_5_11 = InteractionHelper.interaction_action_names(var_5_1)

		var_5_9:start_interaction(var_5_11)

		if var_5_9:allow_movement_during_interaction() then
			return
		end

		local var_5_12 = var_5_9:interaction_config()
		local var_5_13 = arg_5_0.temp_params

		var_5_13.swap_to_3p = var_5_12.swap_to_3p
		var_5_13.show_weapons = var_5_12.show_weapons
		var_5_13.activate_block = var_5_12.activate_block
		var_5_13.allow_rotation_update = var_5_12.allow_rotation_update

		var_5_0:change_state("interacting", var_5_13)

		return
	end

	if arg_5_0.locomotion_extension:is_animation_driven() then
		return
	end

	if (var_5_3:get("jump") or var_5_3:get("jump_only")) and var_5_4:can_override_dodge_with_jump(arg_5_5) and arg_5_0.locomotion_extension:jump_allowed() then
		local var_5_14 = arg_5_0.temp_params

		var_5_14.post_dodge_jump = true

		var_5_0:change_state("jumping", var_5_14)

		return
	end

	CharacterStateHelper.update_dodge_lock(var_5_1, arg_5_0.input_extension, var_5_4)

	if not arg_5_0.csm.state_next and not arg_5_0.locomotion_extension:is_on_ground() then
		var_5_0:change_state("falling", arg_5_0.temp_params)

		return
	end

	if not arg_5_0:update_dodge(var_5_1, arg_5_3, arg_5_5) then
		local var_5_15 = arg_5_0.temp_params

		var_5_0:change_state("walking", var_5_15)
	end

	CharacterStateHelper.look(var_5_3, arg_5_0.player.viewport_name, var_5_5, var_5_4, arg_5_0.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_5_5, var_5_1, var_5_3, arg_5_0.inventory_extension, arg_5_0.health_extension)

	local var_5_16 = CharacterStateHelper.get_move_animation(arg_5_0.locomotion_extension, var_5_3, var_5_4, arg_5_0.move_anim)

	if var_5_16 ~= arg_5_0.move_anim then
		CharacterStateHelper.play_animation_event(var_5_1, var_5_16)

		arg_5_0.move_anim = var_5_16
	end
end

local var_0_0 = {}

PlayerCharacterStateDodging.update_dodge = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_1)
	local var_6_1 = arg_6_0.distance_left
	local var_6_2 = arg_6_0.status_extension:get_dodge_cooldown()
	local var_6_3 = var_6_0.dodging.speed_modifier
	local var_6_4 = var_6_0.dodging.distance_modifier

	if Vector3.distance(Unit.world_position(arg_6_1, 0), arg_6_0.last_position:unbox()) / arg_6_0.distance_supposed_to_move < var_6_0.dodging.stop_threshold then
		return false
	end

	if arg_6_0.distance_left <= 0 then
		return false
	end

	local var_6_5 = arg_6_0.time_in_dodge * var_6_2
	local var_6_6 = var_6_0.dodging.speed_at_times
	local var_6_7 = false
	local var_6_8 = arg_6_0.current_speed_setting_index + 1

	arg_6_0.current_speed_setting_index = #var_6_6

	for iter_6_0 = var_6_8, #var_6_6 do
		if var_6_5 <= var_6_6[iter_6_0].time_in_dodge then
			arg_6_0.current_speed_setting_index = iter_6_0 - 1

			break
		end
	end

	local var_6_9 = false
	local var_6_10 = arg_6_0.current_speed_setting_index
	local var_6_11 = var_6_10 + 1

	if var_6_11 <= #var_6_6 then
		local var_6_12 = var_6_6[var_6_11].time_in_dodge - var_6_6[var_6_10].time_in_dodge
		local var_6_13 = (var_6_5 - var_6_6[var_6_10].time_in_dodge) / var_6_12

		arg_6_0.speed = math.lerp(var_6_6[var_6_10].speed, var_6_6[var_6_11].speed, var_6_13) * var_6_3 * var_6_2
	else
		arg_6_0.speed = var_6_6[var_6_10].speed * var_6_3 * var_6_2
	end

	local var_6_14 = arg_6_0.first_person_extension:current_rotation()
	local var_6_15 = Quaternion.look(Vector3.flat(Quaternion.forward(var_6_14)), Vector3.up())
	local var_6_16 = Quaternion.rotate(var_6_15, arg_6_0.dodge_direction:unbox())

	arg_6_0.locomotion_extension:set_wanted_velocity(var_6_16 * arg_6_0.speed)

	local var_6_17 = arg_6_0.speed * arg_6_2

	arg_6_0.distance_supposed_to_move = var_6_17
	arg_6_0.distance_left = arg_6_0.distance_left - var_6_17

	return true
end

PlayerCharacterStateDodging.get_is_dodging = function (arg_7_0)
	return arg_7_0.dodge_timer or arg_7_0.dodge_stand_still_timer or arg_7_0.dodge_return_timer
end

PlayerCharacterStateDodging.start_dodge = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_8_1)
	local var_8_1 = Managers.state.network

	if var_8_1:game() and not LEVEL_EDITOR_TEST then
		local var_8_2 = var_8_1:unit_game_object_id(arg_8_1)

		arg_8_0.status_extension:set_is_dodging(true)
		var_8_1.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, var_8_2, 0)
	end

	ScriptUnit.has_extension(arg_8_1, "buff_system"):trigger_procs("on_dodge", arg_8_0.dodge_direction)
	assert(#var_8_0.dodging.speed_at_times > 1, "not enough speed at times in movementsettings")

	arg_8_0.current_speed_setting_index = 1
	arg_8_0.speed = var_8_0.dodging.speed_at_times[arg_8_0.current_speed_setting_index].speed
	arg_8_0.distance_supposed_to_move = 0
	arg_8_0.time_in_dodge = 0
	arg_8_0.distance_left = var_8_0.dodging.distance * var_8_0.dodging.distance_modifier * arg_8_0.status_extension:get_dodge_cooldown()

	arg_8_0.last_position:store(Unit.world_position(arg_8_1, 0))
	arg_8_0:calculate_dodge_total_time(arg_8_1)
end

PlayerCharacterStateDodging.calculate_dodge_total_time = function (arg_9_0, arg_9_1)
	local var_9_0 = 0.016666666666666666
	local var_9_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_9_1)
	local var_9_2 = true
	local var_9_3 = 0
	local var_9_4 = 1
	local var_9_5 = 0
	local var_9_6 = arg_9_0.dodge_fatigue
	local var_9_7 = arg_9_0.status_extension:get_dodge_cooldown()
	local var_9_8 = var_9_1.dodging.speed_modifier
	local var_9_9 = var_9_1.dodging.distance_modifier * var_9_7
	local var_9_10 = var_9_1.dodging.speed_at_times[1].speed * var_9_8 * var_9_7

	while var_9_2 do
		var_9_3 = var_9_3 + var_9_0

		local var_9_11 = var_9_1.dodging.speed_at_times
		local var_9_12 = false
		local var_9_13 = var_9_4 + 1

		var_9_4 = #var_9_11

		for iter_9_0 = var_9_13, #var_9_11 do
			if var_9_3 <= var_9_11[iter_9_0].time_in_dodge then
				var_9_4 = iter_9_0 - 1

				break
			end
		end

		local var_9_14 = var_9_4 + 1

		if var_9_14 <= #var_9_11 then
			local var_9_15 = var_9_11[var_9_14].time_in_dodge - var_9_11[var_9_4].time_in_dodge
			local var_9_16 = (var_9_3 - var_9_11[var_9_4].time_in_dodge) / var_9_15

			var_9_10 = math.lerp(var_9_11[var_9_4].speed, var_9_11[var_9_14].speed, var_9_16) * var_9_8 * var_9_7
		else
			var_9_10 = var_9_11[var_9_4].speed * var_9_8
		end

		var_9_5 = var_9_5 + var_9_10 * var_9_0

		if var_9_5 > var_9_1.dodging.distance * var_9_9 * var_9_7 then
			var_9_2 = false
		end
	end

	arg_9_0.estimated_dodge_time = var_9_3
end
