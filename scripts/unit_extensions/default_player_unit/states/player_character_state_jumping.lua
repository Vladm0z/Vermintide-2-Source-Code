-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_jumping.lua

PlayerCharacterStateJumping = class(PlayerCharacterStateJumping, PlayerCharacterState)

function PlayerCharacterStateJumping.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "jumping")

	local var_1_0 = arg_1_1
end

local var_0_0 = POSITION_LOOKUP

function PlayerCharacterStateJumping.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0.temp_params)

	local var_2_0 = arg_2_0.player
	local var_2_1 = arg_2_0.input_extension
	local var_2_2 = arg_2_0.status_extension
	local var_2_3 = arg_2_0.locomotion_extension
	local var_2_4 = arg_2_0.inventory_extension
	local var_2_5 = arg_2_0.first_person_extension
	local var_2_6 = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local var_2_7 = var_2_6.jump.initial_vertical_speed

	if script_data.use_super_jumps then
		var_2_7 = var_2_7 * 2
	end

	var_2_3:set_maximum_upwards_velocity(var_2_7)
	var_2_3:force_on_ground(false)

	local var_2_8 = var_2_3:current_velocity()
	local var_2_9

	if arg_2_7.post_dodge_jump then
		var_2_8 = var_2_8 * PlayerUnitMovementSettings.post_dodge_jump_velocity_scale
		var_2_7 = var_2_7 * PlayerUnitMovementSettings.post_dodge_jump_speed_scale
	end

	if arg_2_7.backward_jump then
		var_2_8 = var_2_8 * PlayerUnitMovementSettings.backwards_jump_velocity_scale
	end

	local var_2_10 = Vector3.length(var_2_8)

	if var_2_10 > PlayerUnitMovementSettings.move_speed then
		var_2_8 = var_2_8 * (PlayerUnitMovementSettings.move_speed / var_2_10)
	end

	if arg_2_6 == "climbing_ladder" then
		local var_2_11 = arg_2_7.ladder_unit
		local var_2_12 = Unit.world_rotation(var_2_11, 0)

		var_2_9 = Quaternion.forward(var_2_12) * var_2_6.ladder.jump_backwards_force
		arg_2_0.temp_params.shaking_ladder_unit = arg_2_7.shaking_ladder_unit
	else
		var_2_9 = Vector3(var_2_8.x, var_2_8.y, var_2_7)
	end

	var_2_3:set_forced_velocity(var_2_9)
	var_2_3:set_wanted_velocity(var_2_9)

	local var_2_13
	local var_2_14 = var_2_4:get_wielded_slot_item_template()

	arg_2_0._play_fp_anim = var_2_14 and var_2_14.jump_anim_enabled_1p

	local var_2_15 = CharacterStateHelper.has_move_input(var_2_1) and "jump_fwd" or "jump_idle"

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_15)

	if arg_2_0._play_fp_anim then
		CharacterStateHelper.play_animation_event_first_person(var_2_5, var_2_15)
	end

	var_2_5:play_camera_effect_sequence("jump", arg_2_5)
	CharacterStateHelper.look(var_2_1, var_2_0.viewport_name, var_2_5, var_2_2, arg_2_0.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_1, var_2_4, arg_2_0.health_extension)
	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	local var_2_16 = var_0_0[arg_2_1].z

	arg_2_0.status_extension:set_falling_height(var_2_16)
	Unit.flow_event(arg_2_1, "sfx_player_jump")
end

function PlayerCharacterStateJumping.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.input_extension

	arg_3_0.locomotion_extension:reset_maximum_upwards_velocity()

	if arg_3_6 == "walking" or arg_3_6 == "standing" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	elseif arg_3_6 and arg_3_6 ~= "falling" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end

	if arg_3_6 and arg_3_6 ~= "falling" and Managers.state.network:game() then
		CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
		CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")

		if arg_3_0._play_fp_anim then
			CharacterStateHelper.play_animation_event_first_person(arg_3_0.first_person_extension, "to_onground")
		end
	end
end

function PlayerCharacterStateJumping.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local var_4_2 = arg_4_0.input_extension
	local var_4_3 = arg_4_0.status_extension
	local var_4_4 = arg_4_0.first_person_extension
	local var_4_5 = arg_4_0.locomotion_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_3, var_4_0) then
		return
	end

	if CharacterStateHelper.is_overcharge_exploding(var_4_3) then
		var_4_0:change_state("overcharge_exploding")

		return
	end

	if CharacterStateHelper.is_pushed(var_4_3) then
		var_4_3:set_pushed(false)

		local var_4_6 = var_4_1.stun_settings.pushed

		var_4_6.hit_react_type = var_4_3:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_6)

		return
	end

	if CharacterStateHelper.is_charged(var_4_3) then
		local var_4_7 = var_4_1.charged_settings.charged

		var_4_7.hit_react_type = "charged"

		var_4_0:change_state("charged", var_4_7)

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_3) then
		var_4_3:set_block_broken(false)

		local var_4_8 = var_4_1.stun_settings.parry_broken

		var_4_8.hit_react_type = "medium_push"

		var_4_0:change_state("stunned", var_4_8)

		return
	end

	if var_4_5:is_on_ground() then
		var_4_0:change_state("walking")
		var_4_4:change_state("walking")

		return
	end

	if not var_4_0.state_next and var_4_5:current_velocity().z <= 0 then
		var_4_0:change_state("falling", arg_4_0.temp_params)
		var_4_4:change_state("falling")

		return
	end

	local var_4_9 = arg_4_0.inventory_extension
	local var_4_10 = math.clamp(var_4_1.move_speed, 0, PlayerUnitMovementSettings.move_speed) * var_4_3:current_move_speed_multiplier() * var_4_1.player_speed_scale * var_4_1.player_air_speed_scale

	CharacterStateHelper.move_in_air(arg_4_0.first_person_extension, var_4_2, arg_4_0.locomotion_extension, var_4_10, arg_4_1)
	CharacterStateHelper.look(var_4_2, arg_4_0.player.viewport_name, arg_4_0.first_person_extension, var_4_3, arg_4_0.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_4_5, arg_4_1, var_4_2, var_4_9, arg_4_0.health_extension)

	local var_4_11 = arg_4_0.interactor_extension

	if CharacterStateHelper.is_starting_interaction(var_4_2, var_4_11) then
		local var_4_12, var_4_13 = InteractionHelper.interaction_action_names(arg_4_1)

		var_4_11:start_interaction(var_4_13)

		if var_4_11:allow_movement_during_interaction() then
			return
		end

		local var_4_14 = var_4_11:interaction_config()
		local var_4_15 = arg_4_0.temp_params

		var_4_15.swap_to_3p = var_4_14.swap_to_3p
		var_4_15.show_weapons = var_4_14.show_weapons
		var_4_15.activate_block = var_4_14.activate_block
		var_4_15.allow_rotation_update = var_4_14.allow_rotation_update

		var_4_0:change_state("interacting", var_4_15)

		return
	end

	if CharacterStateHelper.is_interacting(var_4_11) then
		if var_4_11:allow_movement_during_interaction() then
			return
		end

		local var_4_16 = var_4_11:interaction_config()
		local var_4_17 = arg_4_0.temp_params

		var_4_17.swap_to_3p = var_4_16.swap_to_3p
		var_4_17.show_weapons = var_4_16.show_weapons
		var_4_17.activate_block = var_4_16.activate_block
		var_4_17.allow_rotation_update = var_4_16.allow_rotation_update

		var_4_0:change_state("interacting", var_4_17)

		return
	end
end
