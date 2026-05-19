-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_walking.lua

PlayerCharacterStateWalking = class(PlayerCharacterStateWalking, PlayerCharacterState)

function PlayerCharacterStateWalking.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "walking")

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.latest_valid_navmesh_position = Vector3Box(math.huge, math.huge, math.huge)
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
end

function PlayerCharacterStateWalking.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.input_extension
	local var_2_1 = arg_2_0.first_person_extension
	local var_2_2 = arg_2_0.status_extension
	local var_2_3 = arg_2_0.inventory_extension
	local var_2_4 = arg_2_0.health_extension
	local var_2_5 = arg_2_0.locomotion_extension:current_velocity()
	local var_2_6 = Managers.player:owner(arg_2_1)
	local var_2_7 = var_2_6 and var_2_6.bot_player

	if arg_2_6 == "standing" then
		arg_2_0.current_movement_speed_scale = 0
	elseif not script_data.disable_nice_movement then
		local var_2_8 = Vector3.length(var_2_5)
		local var_2_9 = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)

		arg_2_0.current_movement_speed_scale = math.min(var_2_8 / var_2_9.move_speed, 1)
	else
		arg_2_0.current_movement_speed_scale = 1
	end

	if not var_2_7 then
		local var_2_10 = Vector3.normalize(Vector3.flat(var_2_5))
		local var_2_11 = var_2_1:current_rotation()
		local var_2_12 = Vector3.dot(Quaternion.right(var_2_11), var_2_10)
		local var_2_13 = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(var_2_11))), var_2_10)
		local var_2_14 = Vector3(var_2_12, var_2_13, 0)

		arg_2_0.last_input_direction:store(var_2_14)
	end

	local var_2_15, var_2_16 = CharacterStateHelper.get_move_animation(arg_2_0.locomotion_extension, var_2_0, var_2_2, arg_2_0.move_anim_3p)

	arg_2_0.move_anim_3p = var_2_15
	arg_2_0.move_anim_1p = var_2_16

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_15)
	CharacterStateHelper.play_animation_event_first_person(var_2_1, var_2_16)
	CharacterStateHelper.look(var_2_0, arg_2_0.player.viewport_name, var_2_1, var_2_2, var_2_3)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_0, var_2_3, var_2_4)

	arg_2_0.walking = false
	arg_2_0.is_bot = var_2_7
end

function PlayerCharacterStateWalking.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.first_person_extension

	CharacterStateHelper.play_animation_event_first_person(var_3_0, "idle")
end

function PlayerCharacterStateWalking._handle_ladder_collision(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.unit
	local var_4_1 = arg_4_0.status_extension
	local var_4_2 = arg_4_0.first_person_extension
	local var_4_3 = arg_4_0.locomotion_extension
	local var_4_4, var_4_5 = CharacterStateHelper.is_colliding_with_gameplay_collision_box(arg_4_0.world, var_4_0, "filter_ladder_collision")
	local var_4_6 = CharacterStateHelper.looking_up(var_4_2, arg_4_2.ladder.looking_up_threshold)
	local var_4_7 = CharacterStateHelper.recently_left_ladder(var_4_1, arg_4_1)

	if var_4_4 then
		local var_4_8 = false
		local var_4_9 = Unit.local_rotation(var_4_5, 0)
		local var_4_10 = Quaternion.forward(var_4_9)
		local var_4_11 = Unit.local_position(var_4_5, 0) - POSITION_LOOKUP[var_4_0]
		local var_4_12 = Vector3.dot(var_4_10, var_4_11)
		local var_4_13 = false
		local var_4_14 = false
		local var_4_15 = Quaternion.forward(Unit.local_rotation(var_4_5, 0))
		local var_4_16 = Quaternion.forward(var_4_2:current_rotation())
		local var_4_17 = Vector3.dot(var_4_16, var_4_15) < 0
		local var_4_18 = Vector3.dot(var_4_3.velocity_current:unbox(), var_4_15)
		local var_4_19 = Unit.node(var_4_5, "c_platform")

		if POSITION_LOOKUP[var_4_0].z > Vector3.z(Unit.world_position(var_4_5, var_4_19)) then
			local var_4_20 = not var_4_6

			if var_4_20 and var_4_17 and var_4_18 < 0 then
				var_4_14 = var_4_12 > 0.5
				var_4_13 = true
			elseif var_4_20 and var_4_12 > 0 and not var_4_17 and var_4_18 > 0.5 then
				var_4_14 = var_4_12 > 0.25
				var_4_13 = true
			end

			var_4_8 = true
		else
			local var_4_21 = 0.02

			var_4_14 = var_4_12 < 0.7 + var_4_21 and var_4_12 > 0
			var_4_13 = var_4_6 and not var_4_17 and var_4_18 > 0
		end

		if var_4_13 and not var_4_7 and var_4_14 then
			arg_4_0.temp_params.ladder_unit = var_4_5

			if var_4_8 then
				return "enter_ladder_top"
			else
				return "climbing_ladder"
			end
		end
	end
end

function PlayerCharacterStateWalking.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.world
	local var_5_2 = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_1)
	local var_5_3 = arg_5_0.input_extension
	local var_5_4 = arg_5_0.status_extension
	local var_5_5 = arg_5_0.first_person_extension
	local var_5_6 = arg_5_0.locomotion_extension
	local var_5_7 = arg_5_0.health_extension
	local var_5_8 = arg_5_0.inventory_extension
	local var_5_9 = arg_5_0.interactor_extension
	local var_5_10 = arg_5_0.buff_extension
	local var_5_11 = arg_5_0.current_movement_speed_scale
	local var_5_12 = CharacterStateHelper

	if var_5_6:is_on_ground() then
		ScriptUnit.extension(arg_5_1, "whereabouts_system"):set_is_onground()
	end

	if var_5_12.do_common_state_transitions(var_5_4, var_5_0) then
		return
	end

	if var_5_12.is_ledge_hanging(var_5_1, arg_5_1, arg_5_0.temp_params) and not var_5_12.handle_bot_ledge_hanging_failsafe(arg_5_1, arg_5_0.is_bot) then
		var_5_0:change_state("ledge_hanging", arg_5_0.temp_params)

		return
	end

	if var_5_12.is_overcharge_exploding(var_5_4) then
		var_5_0:change_state("overcharge_exploding")

		return
	end

	if var_5_12.is_using_transport(var_5_4) then
		var_5_0:change_state("using_transport")

		return
	end

	if var_5_12.is_pushed(var_5_4) then
		var_5_4:set_pushed(false)

		local var_5_13 = var_5_2.stun_settings.pushed

		var_5_13.hit_react_type = var_5_4:hit_react_type() .. "_push"

		var_5_0:change_state("stunned", var_5_13)

		return
	end

	if var_5_12.is_charged(var_5_4) then
		local var_5_14 = var_5_2.charged_settings.charged

		var_5_14.hit_react_type = "charged"

		var_5_0:change_state("charged", var_5_14)

		return
	end

	if var_5_12.is_block_broken(var_5_4) then
		var_5_4:set_block_broken(false)

		local var_5_15 = var_5_2.stun_settings.parry_broken

		var_5_15.hit_react_type = "medium_push"

		var_5_0:change_state("stunned", var_5_15)

		return
	end

	if var_5_6:is_animation_driven() then
		return
	end

	if not var_5_0.state_next and var_5_4.do_leap then
		var_5_0:change_state("leaping")

		return
	end

	var_5_12.update_dodge_lock(arg_5_1, var_5_3, var_5_4)

	local var_5_16, var_5_17 = var_5_12.check_to_start_dodge(arg_5_1, var_5_3, var_5_4, arg_5_5)

	if var_5_16 then
		local var_5_18 = arg_5_0.temp_params

		var_5_18.dodge_direction = var_5_17

		var_5_0:change_state("dodging", var_5_18)

		return
	end

	local var_5_19 = Managers.input:is_device_active("gamepad")
	local var_5_20 = var_5_4:is_crouching()

	if not var_5_0.state_next and (var_5_3:get("jump") or var_5_3:get("jump_only")) and (not var_5_20 or var_5_12.can_uncrouch(arg_5_1)) and var_5_6:jump_allowed() then
		local var_5_21 = var_5_12.get_movement_input(var_5_3)

		if var_5_20 then
			var_5_12.uncrouch(arg_5_1, arg_5_5, var_5_5, var_5_4)
		end

		if not var_5_3:get("jump") and not var_5_19 or var_5_4:can_override_dodge_with_jump(arg_5_5) or Vector3.y(var_5_21) >= 0 or Vector3.length(var_5_21) <= var_5_3.minimum_dodge_input then
			if Vector3.y(var_5_12.get_movement_input(var_5_3)) < 0 then
				arg_5_0.temp_params.backward_jump = true
			else
				arg_5_0.temp_params.backward_jump = false
			end

			var_5_0:change_state("jumping", arg_5_0.temp_params)
			var_5_5:change_state("jumping")

			return
		end
	end

	local var_5_22 = var_5_12.has_move_input(var_5_3)

	if not var_5_0.state_next and not var_5_22 and var_5_11 == 0 then
		local var_5_23 = arg_5_0.temp_params

		var_5_0:change_state("standing", var_5_23)
		var_5_5:change_state("standing")

		return
	end

	if not var_5_0.state_next and not var_5_6:is_on_ground() then
		var_5_0:change_state("falling", arg_5_0.temp_params)
		var_5_5:change_state("falling")

		return
	end

	local var_5_24 = arg_5_0:_handle_ladder_collision(arg_5_5, var_5_2)

	if not var_5_0.state_next and var_5_24 then
		var_5_0:change_state(var_5_24, arg_5_0.temp_params)

		return
	end

	local var_5_25 = var_5_3.toggle_crouch

	var_5_12.check_crouch(arg_5_1, var_5_3, var_5_4, var_5_25, var_5_5, arg_5_5)

	local var_5_26 = var_5_12.get_movement_input(var_5_3)

	if not arg_5_0.is_bot then
		local var_5_27 = var_5_2.move_acceleration_up * arg_5_3
		local var_5_28 = var_5_2.move_acceleration_down * arg_5_3

		if var_5_22 then
			var_5_11 = math.min(1, var_5_11 + var_5_27)

			if var_5_19 then
				var_5_11 = Vector3.length(var_5_26) * var_5_11
			end
		else
			var_5_11 = math.max(0, var_5_11 - var_5_28)
		end
	else
		var_5_11 = var_5_22 and 1 or 0
	end

	local var_5_29 = var_5_3:get("walk")
	local var_5_30 = var_5_4:is_crouching()

	if var_5_29 ~= arg_5_0.walking then
		var_5_4:set_slowed(var_5_29)
	end

	local var_5_31 = (var_5_30 and var_5_2.crouch_move_speed or var_5_29 and var_5_2.walk_move_speed or var_5_2.move_speed) * var_5_4:current_move_speed_multiplier() * var_5_11 * var_5_2.player_speed_scale
	local var_5_32 = var_5_10:has_buff_perk("intoxication_stagger")
	local var_5_33 = var_5_10:has_buff_perk("drunk_stagger")
	local var_5_34 = var_5_10:has_buff_perk("hungover_stagger")

	if var_5_32 or var_5_33 or var_5_34 then
		local var_5_35 = math.abs(var_5_4:intoxication_level())
		local var_5_36 = var_5_32 and math.random() > 0.6 / var_5_35
		local var_5_37 = var_5_33 and math.random() > 0.9 / var_5_35
		local var_5_38 = var_5_34
		local var_5_39 = var_5_36 or var_5_37 or var_5_38

		if not arg_5_0._is_in_intoxication_stagger_cooldown and not arg_5_0._is_intoxication_stagger and var_5_39 then
			arg_5_0._is_intoxication_stagger = true
			arg_5_0._intoxication_stagger_start = arg_5_5
			arg_5_0._intoxication_stagger_duration = math.random() * 1.5 + math.random() * 0.5
			arg_5_0._intoxication_stagger_time = arg_5_0._intoxication_stagger_start + arg_5_0._intoxication_stagger_duration

			local var_5_40 = var_5_6:current_velocity()
			local var_5_41 = Vector3.normalize(var_5_40)
			local var_5_42 = Vector3.cross(var_5_41, Vector3.up())
			local var_5_43 = math.sin(arg_5_5 * (math.pi * 0.5)) * math.sign(math.random() * 2 - 1) * var_5_42

			arg_5_0._intoxication_stagger_dir = Vector3Box(var_5_43)
		end

		if arg_5_0._is_intoxication_stagger and arg_5_5 <= arg_5_0._intoxication_stagger_time then
			local var_5_44 = arg_5_0._intoxication_stagger_time - arg_5_5
			local var_5_45 = (arg_5_0._intoxication_stagger_duration - var_5_44) / arg_5_0._intoxication_stagger_duration

			var_5_26 = var_5_26 + Vector3.lerp(var_5_26, arg_5_0._intoxication_stagger_dir:unbox(), var_5_45)

			if var_5_45 < 0.5 then
				var_5_31 = math.lerp(var_5_31, var_5_31 * 0.75, math.sin(var_5_45 * 2 * math.pi * 0.5))
			else
				var_5_31 = math.lerp(var_5_31 * 0.75, var_5_31, math.sin(var_5_45 * 2 * math.pi * 0.5))
			end
		elseif arg_5_0._is_intoxication_stagger and arg_5_5 > arg_5_0._intoxication_stagger_time then
			arg_5_0._is_intoxication_stagger = nil
			arg_5_0._is_in_intoxication_stagger_cooldown = true
			arg_5_0._intoxication_stagger_cooldown_time = arg_5_5 + math.random() * (1 / math.abs(var_5_35))
		end

		if arg_5_0._is_in_intoxication_stagger_cooldown and arg_5_5 > arg_5_0._intoxication_stagger_cooldown_time then
			arg_5_0._is_in_intoxication_stagger_cooldown = nil
			arg_5_0._intoxication_stagger_cooldown_time = nil
		end
	end

	local var_5_46 = Vector3.normalize(var_5_26)

	if Vector3.length_squared(var_5_26) == 0 then
		var_5_46 = arg_5_0.last_input_direction:unbox()
	else
		arg_5_0.last_input_direction:store(var_5_46)
	end

	if var_5_12.is_starting_interaction(var_5_3, var_5_9) then
		local var_5_47, var_5_48 = InteractionHelper.interaction_action_names(arg_5_1)

		var_5_9:start_interaction(var_5_48)

		if var_5_9:allow_movement_during_interaction() then
			return
		end

		local var_5_49 = var_5_9:interaction_config()
		local var_5_50 = arg_5_0.temp_params

		var_5_50.swap_to_3p = var_5_49.swap_to_3p
		var_5_50.show_weapons = var_5_49.show_weapons
		var_5_50.activate_block = var_5_49.activate_block
		var_5_50.allow_rotation_update = var_5_49.allow_rotation_update

		var_5_0:change_state("interacting", var_5_50)

		return
	end

	if arg_5_0.cosmetic_extension:get_queued_3p_emote() then
		local var_5_51, var_5_52, var_5_53 = var_5_12.get_item_data_and_weapon_extensions(arg_5_0.inventory_extension)

		if not var_5_12.get_current_action_data(var_5_53, var_5_52) then
			var_5_0:change_state("emote")

			return
		end
	end

	var_5_12.move_on_ground(var_5_5, var_5_3, var_5_6, var_5_46, var_5_31, arg_5_1)
	var_5_12.look(var_5_3, arg_5_0.player.viewport_name, var_5_5, var_5_4, var_5_8)
	var_5_12.update_weapon_actions(arg_5_5, arg_5_1, var_5_3, var_5_8, var_5_7)

	if var_5_12.is_interacting(var_5_9) then
		if var_5_9:allow_movement_during_interaction() then
			return
		end

		local var_5_54 = var_5_9:interaction_config()
		local var_5_55 = arg_5_0.temp_params

		var_5_55.swap_to_3p = var_5_54.swap_to_3p
		var_5_55.show_weapons = var_5_54.show_weapons
		var_5_55.activate_block = var_5_54.activate_block
		var_5_55.allow_rotation_update = var_5_54.allow_rotation_update

		var_5_0:change_state("interacting", var_5_55)

		return
	end

	local var_5_56, var_5_57 = var_5_12.get_move_animation(var_5_6, var_5_3, var_5_4, arg_5_0.move_anim_3p)

	if var_5_57 ~= arg_5_0.move_anim_1p then
		var_5_12.play_animation_event_first_person(var_5_5, var_5_57)

		arg_5_0.move_anim_1p = var_5_57
	end

	if var_5_56 ~= arg_5_0.move_anim_3p then
		var_5_12.play_animation_event(arg_5_1, var_5_56)

		arg_5_0.move_anim_3p = var_5_56
	end

	arg_5_0.current_movement_speed_scale = var_5_11
	arg_5_0.walking = var_5_29
end
