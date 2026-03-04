-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_walking.lua

EnemyCharacterStateWalking = class(EnemyCharacterStateWalking, EnemyCharacterState)

EnemyCharacterStateWalking.init = function (arg_1_0, arg_1_1, arg_1_2)
	EnemyCharacterState.init(arg_1_0, arg_1_1, arg_1_2 or "walking")

	local var_1_0 = arg_1_1

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.latest_valid_navmesh_position = Vector3Box(math.huge, math.huge, math.huge)
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
end

EnemyCharacterStateWalking.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0._unit
	local var_2_1 = arg_2_0._input_extension
	local var_2_2 = arg_2_0._first_person_extension
	local var_2_3 = arg_2_0._status_extension
	local var_2_4 = arg_2_0._inventory_extension
	local var_2_5 = arg_2_0._health_extension
	local var_2_6 = arg_2_0._locomotion_extension:current_velocity()
	local var_2_7 = Managers.player:owner(var_2_0)
	local var_2_8 = var_2_7 and var_2_7.bot_player

	if not var_2_3:get_unarmed() then
		CharacterStateHelper.play_animation_event(var_2_0, "to_combat")
	end

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

	local var_2_14, var_2_15 = CharacterStateHelper.get_move_animation(arg_2_0._locomotion_extension, var_2_1, var_2_3)

	arg_2_0.move_anim_3p = var_2_14
	arg_2_0.move_anim_1p = var_2_15

	CharacterStateHelper.play_animation_event(var_2_0, var_2_14)
	CharacterStateHelper.play_animation_event_first_person(var_2_2, var_2_15)
	CharacterStateHelper.look(var_2_1, arg_2_0._player.viewport_name, var_2_2, var_2_3, var_2_4)
	CharacterStateHelper.update_weapon_actions(arg_2_5, var_2_0, var_2_1, var_2_4, var_2_5)

	arg_2_0.is_bot = var_2_8
end

EnemyCharacterStateWalking.common_state_changes = function (arg_3_0)
	arg_3_0:handle_disabled_ghost_mode()

	local var_3_0 = arg_3_0._csm
	local var_3_1 = arg_3_0._unit
	local var_3_2 = arg_3_0._input_extension
	local var_3_3 = PlayerUnitMovementSettings.get_movement_settings_table(var_3_1)
	local var_3_4 = arg_3_0._status_extension
	local var_3_5 = arg_3_0._locomotion_extension
	local var_3_6 = CharacterStateHelper
	local var_3_7 = arg_3_0._first_person_extension
	local var_3_8 = arg_3_0._inventory_extension
	local var_3_9 = arg_3_0._career_extension:career_settings()

	if var_3_5:is_on_ground() then
		ScriptUnit.extension(var_3_1, "whereabouts_system"):set_is_onground()
	end

	if var_3_6.do_common_state_transitions(var_3_4, var_3_0) then
		return true
	end

	if var_3_6.is_using_transport(var_3_4) then
		var_3_0:change_state("using_transport")

		return true
	end

	if var_3_6.is_pushed(var_3_4) then
		var_3_4:set_pushed(false)

		local var_3_10 = var_3_3.stun_settings.pushed

		var_3_10.hit_react_type = var_3_4:hit_react_type() .. "_push"

		var_3_0:change_state("stunned", var_3_10)

		return true
	end

	if var_3_6.is_block_broken(var_3_4) then
		var_3_4:set_block_broken(false)

		local var_3_11 = var_3_3.stun_settings.parry_broken

		var_3_11.hit_react_type = "medium_push"

		var_3_0:change_state("stunned", var_3_11)

		return true
	end

	if var_3_5:is_animation_driven() then
		return true
	end

	local var_3_12 = arg_3_0._interactor_extension

	if var_3_6.is_starting_interaction(var_3_2, var_3_12) then
		local var_3_13, var_3_14 = InteractionHelper.interaction_action_names(var_3_1)

		var_3_12:start_interaction(var_3_14)

		if var_3_12:allow_movement_during_interaction() then
			return
		end

		local var_3_15 = var_3_12:interaction_config()
		local var_3_16 = arg_3_0._temp_params

		var_3_16.swap_to_3p = var_3_15.swap_to_3p
		var_3_16.show_weapons = var_3_15.show_weapons
		var_3_16.activate_block = var_3_15.activate_block
		var_3_16.allow_rotation_update = var_3_15.allow_rotation_update

		var_3_0:change_state("interacting", var_3_16)

		return true
	end

	if not var_3_0.state_next and var_3_4.do_leap then
		var_3_0:change_state("leaping")

		return true
	end

	if arg_3_0._input_extension:get("character_inspecting") then
		local var_3_17, var_3_18, var_3_19 = var_3_6.get_item_data_and_weapon_extensions(arg_3_0._inventory_extension)

		if not var_3_6.get_current_action_data(var_3_19, var_3_18) then
			var_3_0:change_state("inspecting")

			return true
		end
	end

	return false
end

EnemyCharacterStateWalking.common_movement = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = arg_4_0.current_movement_speed_scale
	local var_4_2 = arg_4_0._first_person_extension
	local var_4_3 = arg_4_0._input_extension
	local var_4_4 = arg_4_0._inventory_extension
	local var_4_5 = arg_4_0._locomotion_extension
	local var_4_6 = arg_4_0._status_extension
	local var_4_7 = arg_4_0._unit
	local var_4_8 = ScriptUnit.extension(var_4_7, "buff_system")
	local var_4_9 = PlayerUnitMovementSettings.get_movement_settings_table(var_4_7)
	local var_4_10 = Managers.input:is_device_active("gamepad")
	local var_4_11 = var_4_6:is_crouching()
	local var_4_12 = CharacterStateHelper.has_move_input(var_4_3)

	if not var_4_0.state_next and not var_4_12 and var_4_1 == 0 then
		local var_4_13 = arg_4_0._temp_params

		var_4_0:change_state("standing", var_4_13)
		var_4_2:change_state("standing")

		return true
	end

	if not var_4_0.state_next and not var_4_5:is_on_ground() then
		var_4_0:change_state("falling", arg_4_0._temp_params)
		var_4_2:change_state("falling")

		return true
	end

	if (var_4_3:get("jump") or var_4_3:get("jump_only")) and not var_4_6:is_crouching() and (not var_4_11 or CharacterStateHelper.can_uncrouch(var_4_7)) and var_4_5:jump_allowed() then
		if var_4_11 then
			CharacterStateHelper.uncrouch(var_4_7, t, var_4_2, var_4_6)
		end

		var_4_0:change_state("jumping")
		var_4_2:change_state("jumping")

		return
	end

	local var_4_14 = var_4_3.toggle_crouch
	local var_4_15 = Managers.player:owner(var_4_7)
	local var_4_16 = CharacterStateHelper.get_movement_input(var_4_3)
	local var_4_17 = Unit.get_data(var_4_7, "breed")

	if not arg_4_0.is_bot then
		local var_4_18 = var_4_17 and var_4_17.breed_move_acceleration_up
		local var_4_19 = var_4_17 and var_4_17.breed_move_acceleration_down
		local var_4_20 = var_4_18 * arg_4_2 or var_4_9.move_acceleration_up * arg_4_2
		local var_4_21 = var_4_19 * arg_4_2 or var_4_9.move_acceleration_down * arg_4_2

		if var_4_12 then
			var_4_1 = math.min(1, var_4_1 + var_4_20)

			if var_4_10 then
				var_4_1 = Vector3.length(var_4_16) * var_4_1
			end
		else
			var_4_1 = math.max(0, var_4_1 - var_4_21)
		end
	else
		var_4_1 = var_4_12 and 1 or 0
	end

	local var_4_22 = var_4_3:get("walk")
	local var_4_23 = var_4_17.movement_speed_multiplier
	local var_4_24 = var_4_9.move_speed

	if arg_4_1 and not var_4_22 then
		var_4_24 = var_4_9.ghost_move_speed
	end

	local var_4_25 = var_4_24 * var_4_23
	local var_4_26 = var_4_8:apply_buffs_to_value(var_4_25, "movement_speed") * var_4_1 * var_4_9.player_speed_scale
	local var_4_27 = var_4_17.strafe_speed_multiplier
	local var_4_28 = Vector3.normalize(var_4_16)

	if Vector3.length_squared(var_4_16) == 0 then
		var_4_28 = arg_4_0.last_input_direction:unbox()
	else
		arg_4_0.last_input_direction:store(var_4_28)
	end

	CharacterStateHelper.move_on_ground(var_4_2, var_4_3, var_4_5, var_4_28, var_4_26, var_4_7, var_4_27)
	CharacterStateHelper.ghost_mode(arg_4_0._ghost_mode_extension, var_4_3)
	CharacterStateHelper.look(var_4_3, arg_4_0._player.viewport_name, var_4_2, var_4_6, var_4_4)

	local var_4_29, var_4_30 = CharacterStateHelper.get_move_animation(var_4_5, var_4_3, var_4_6, arg_4_0.move_anim_3p)

	if var_4_29 ~= arg_4_0.move_anim_3p then
		CharacterStateHelper.play_animation_event(var_4_7, var_4_29, true)

		arg_4_0.move_anim_3p = var_4_29
	end

	if var_4_30 ~= arg_4_0.move_anim_1p then
		CharacterStateHelper.play_animation_event_first_person(var_4_2, var_4_30)

		arg_4_0.move_anim_1p = var_4_30
	end

	arg_4_0.current_movement_speed_scale = var_4_1

	return false
end

EnemyCharacterStateWalking.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_0:common_state_changes() then
		return
	end

	local var_5_0 = arg_5_0._input_extension
	local var_5_1 = arg_5_0._inventory_extension
	local var_5_2 = arg_5_0._health_extension

	CharacterStateHelper.update_weapon_actions(arg_5_5, arg_5_1, var_5_0, var_5_1, var_5_2)
	arg_5_0:_update_taunt_dialogue(arg_5_5)

	local var_5_3 = arg_5_0._ghost_mode_extension:is_in_ghost_mode()
	local var_5_4 = arg_5_0:common_movement(var_5_3, arg_5_3)
end
