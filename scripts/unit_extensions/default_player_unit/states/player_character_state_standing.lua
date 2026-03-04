-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_standing.lua

PlayerCharacterStateStanding = class(PlayerCharacterStateStanding, PlayerCharacterState)

PlayerCharacterStateStanding.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "standing")

	local var_1_0 = arg_1_1
end

PlayerCharacterStateStanding.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.unit
	local var_2_1 = arg_2_0.input_extension

	arg_2_0.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_0.wherabouts_extension = ScriptUnit.extension(var_2_0, "whereabouts_system")

	local var_2_2 = arg_2_0.inventory_extension
	local var_2_3 = arg_2_0.first_person_extension
	local var_2_4 = arg_2_0.status_extension
	local var_2_5 = var_2_1.toggle_crouch

	CharacterStateHelper.check_crouch(var_2_0, var_2_1, var_2_4, var_2_5, var_2_3, arg_2_5)
	CharacterStateHelper.look(var_2_1, arg_2_0.player.viewport_name, var_2_3, var_2_4, arg_2_0.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, var_2_0, var_2_1, var_2_2, arg_2_0.health_extension)

	arg_2_0.time_when_can_be_pushed = arg_2_5 + PlayerUnitMovementSettings.get_movement_settings_table(var_2_0).soft_collision.grace_time_pushed_entering_standing

	if CharacterStateHelper.is_interacting(arg_2_0.interactor_extension) or CharacterStateHelper.is_starting_interaction(arg_2_0.input_extension, arg_2_0.interactor_extension) then
		return
	end

	arg_2_0.side = Managers.state.side.side_by_unit[var_2_0]
	arg_2_0.current_animation = "idle"

	CharacterStateHelper.play_animation_event(var_2_0, "idle")
	CharacterStateHelper.play_animation_event_first_person(var_2_3, "idle")
end

PlayerCharacterStateStanding.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	return
end

PlayerCharacterStateStanding._inspection_available = function (arg_4_0)
	if not (Managers.mechanism:get_state() == "ingame_deus") then
		return true
	end

	return not Managers.input:is_device_active("gamepad")
end

PlayerCharacterStateStanding.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.world
	local var_5_2 = arg_5_0.unit
	local var_5_3 = arg_5_0.input_extension
	local var_5_4 = arg_5_0.locomotion_extension
	local var_5_5 = arg_5_0.status_extension
	local var_5_6 = arg_5_0.first_person_extension
	local var_5_7 = CharacterStateHelper

	if var_5_4:is_on_ground() then
		arg_5_0.wherabouts_extension:set_is_onground()
	end

	if var_5_7.do_common_state_transitions(var_5_5, var_5_0) then
		return
	end

	if var_5_7.is_waiting_for_assisted_respawn(var_5_5) then
		var_5_0:change_state("waiting_for_assisted_respawn")

		return
	end

	if var_5_7.is_using_transport(var_5_5) then
		var_5_0:change_state("using_transport")

		return
	end

	if var_5_7.is_ledge_hanging(var_5_1, var_5_2, arg_5_0.temp_params) then
		var_5_0:change_state("ledge_hanging", arg_5_0.temp_params)

		return
	end

	if var_5_7.is_overcharge_exploding(var_5_5) then
		var_5_0:change_state("overcharge_exploding")

		return
	end

	if not var_5_0.state_next and var_5_5.do_leap then
		var_5_0:change_state("leaping")

		return
	end

	var_5_7.update_dodge_lock(var_5_2, var_5_3, var_5_5)

	local var_5_8 = PlayerUnitMovementSettings.get_movement_settings_table(var_5_2)

	if var_5_7.is_pushed(var_5_5) then
		var_5_5:set_pushed(false)

		local var_5_9 = var_5_8.stun_settings.pushed

		var_5_9.hit_react_type = var_5_5:hit_react_type() .. "_push"

		var_5_0:change_state("stunned", var_5_9)

		return
	end

	if var_5_7.is_charged(var_5_5) then
		local var_5_10 = var_5_8.charged_settings.charged

		var_5_10.hit_react_type = "charged"

		var_5_0:change_state("charged", var_5_10)

		return
	end

	if var_5_7.is_block_broken(var_5_5) then
		var_5_5:set_block_broken(false)

		local var_5_11 = var_5_8.stun_settings.parry_broken

		var_5_11.hit_react_type = "medium_push"

		var_5_0:change_state("stunned", var_5_11)

		return
	end

	local var_5_12, var_5_13 = var_5_7.check_to_start_dodge(var_5_2, var_5_3, var_5_5, arg_5_5)

	if var_5_12 then
		local var_5_14 = arg_5_0.temp_params

		var_5_14.dodge_direction = var_5_13

		var_5_0:change_state("dodging", var_5_14)

		return
	end

	if var_5_4:is_animation_driven() then
		var_5_0:change_state("walking")

		return
	end

	local var_5_15 = arg_5_0.interactor_extension

	if var_5_7.is_starting_interaction(var_5_3, var_5_15) then
		local var_5_16, var_5_17 = InteractionHelper.interaction_action_names(var_5_2)

		var_5_15:start_interaction(var_5_17)

		if var_5_15:allow_movement_during_interaction() then
			return
		end

		local var_5_18 = var_5_15:interaction_config()
		local var_5_19 = arg_5_0.temp_params

		var_5_19.swap_to_3p = var_5_18.swap_to_3p
		var_5_19.show_weapons = var_5_18.show_weapons
		var_5_19.activate_block = var_5_18.activate_block
		var_5_19.allow_rotation_update = var_5_18.allow_rotation_update

		var_5_0:change_state("interacting", var_5_19)

		return
	end

	if var_5_7.is_interacting(var_5_15) then
		if var_5_15:allow_movement_during_interaction() then
			return
		end

		local var_5_20 = var_5_15:interaction_config()
		local var_5_21 = arg_5_0.temp_params

		var_5_21.swap_to_3p = var_5_20.swap_to_3p
		var_5_21.show_weapons = var_5_20.show_weapons
		var_5_21.activate_block = var_5_20.activate_block
		var_5_21.allow_rotation_update = var_5_20.allow_rotation_update

		var_5_0:change_state("interacting", var_5_21)

		return
	end

	local var_5_22 = var_5_5:is_crouching()

	if (var_5_3:get("jump") or var_5_3:get("jump_only")) and not var_5_5:is_crouching() and (not var_5_22 or var_5_7.can_uncrouch(var_5_2)) and var_5_4:jump_allowed() then
		if var_5_22 then
			var_5_7.uncrouch(var_5_2, arg_5_5, var_5_6, var_5_5)
		end

		var_5_0:change_state("jumping")
		var_5_6:change_state("jumping")

		return
	end

	if var_5_7.has_move_input(var_5_3) then
		local var_5_23 = arg_5_0.temp_params

		var_5_0:change_state("walking", var_5_23)
		var_5_6:change_state("walking")

		return
	end

	if not var_5_4:is_on_ground() then
		var_5_0:change_state("falling")
		var_5_6:change_state("falling")

		return
	end

	if var_5_3:get("character_inspecting") and arg_5_0:_inspection_available() then
		local var_5_24, var_5_25, var_5_26 = var_5_7.get_item_data_and_weapon_extensions(arg_5_0.inventory_extension)

		if not var_5_7.get_current_action_data(var_5_26, var_5_25) then
			var_5_0:change_state("inspecting")

			return
		end
	end

	if arg_5_0.cosmetic_extension:get_queued_3p_emote() then
		local var_5_27, var_5_28, var_5_29 = var_5_7.get_item_data_and_weapon_extensions(arg_5_0.inventory_extension)

		if not var_5_7.get_current_action_data(var_5_29, var_5_28) then
			var_5_0:change_state("emote")

			return
		end
	end

	local var_5_30 = arg_5_0.inventory_extension
	local var_5_31 = arg_5_0.first_person_extension
	local var_5_32 = var_5_3.toggle_crouch

	if arg_5_5 > arg_5_0.time_when_can_be_pushed and arg_5_0.player:is_player_controlled() then
		arg_5_0.current_animation = var_5_7.update_soft_collision_movement(var_5_31, var_5_5, var_5_4, var_5_2, arg_5_0.world, arg_5_0.current_animation, arg_5_0.side)
	end

	var_5_7.check_crouch(var_5_2, var_5_3, var_5_5, var_5_32, var_5_31, arg_5_5)
	var_5_7.look(var_5_3, arg_5_0.player.viewport_name, arg_5_0.first_person_extension, var_5_5, arg_5_0.inventory_extension)
	var_5_7.update_weapon_actions(arg_5_5, var_5_2, var_5_3, var_5_30, arg_5_0.health_extension)
end
