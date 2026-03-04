-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_jumping.lua

EnemyCharacterStateJumping = class(EnemyCharacterStateJumping, EnemyCharacterState)

EnemyCharacterStateJumping.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "jumping")

	local var_1_0 = arg_1_1
end

local var_0_0 = POSITION_LOOKUP

EnemyCharacterStateJumping.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0._temp_params)

	local var_2_0 = arg_2_0._player
	local var_2_1 = arg_2_0._input_extension
	local var_2_2 = arg_2_0._status_extension
	local var_2_3 = arg_2_0._locomotion_extension
	local var_2_4 = arg_2_0._inventory_extension
	local var_2_5 = arg_2_0._first_person_extension

	arg_2_0._breed = Unit.get_data(arg_2_1, "breed")

	local var_2_6 = arg_2_0._breed
	local var_2_7 = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local var_2_8 = var_2_7.jump.initial_vertical_speed

	if script_data.use_super_jumps then
		var_2_8 = var_2_8 * 2
	end

	var_2_3:set_maximum_upwards_velocity(var_2_8)
	var_2_3:force_on_ground(false)

	local var_2_9 = var_2_3:current_velocity()
	local var_2_10

	if arg_2_7.post_dodge_jump then
		var_2_9 = var_2_9 * PlayerUnitMovementSettings.post_dodge_jump_velocity_scale
		var_2_8 = var_2_8 * PlayerUnitMovementSettings.post_dodge_jump_speed_scale
	end

	if arg_2_7.backward_jump then
		var_2_9 = var_2_9 * PlayerUnitMovementSettings.backwards_jump_velocity_scale
	end

	local var_2_11 = var_2_6.movement_speed_multiplier
	local var_2_12 = var_2_7.move_speed

	if ScriptUnit.extension(arg_2_1, "ghost_mode_system"):is_in_ghost_mode() then
		var_2_12 = var_2_7.ghost_move_speed
	end

	local var_2_13 = var_2_12 * var_2_11
	local var_2_14 = Vector3.length(var_2_9)

	if var_2_13 < var_2_14 then
		var_2_9 = var_2_9 * (var_2_13 / var_2_14)
	end

	local var_2_15 = Vector3(var_2_9.x * 0.5, var_2_9.y * 0.5, var_2_8)

	var_2_3:set_forced_velocity(var_2_15)
	var_2_3:set_wanted_velocity(var_2_15)

	local var_2_16
	local var_2_17 = CharacterStateHelper.has_move_input(var_2_1) and "jump_fwd" or "jump_idle"

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_17)
	CharacterStateHelper.play_animation_event_first_person(var_2_5, "idle")
	var_2_5:play_camera_effect_sequence("jump", arg_2_5)
	CharacterStateHelper.ghost_mode(arg_2_0._ghost_mode_extension, var_2_1)
	CharacterStateHelper.look(var_2_1, var_2_0.viewport_name, var_2_5, var_2_2, arg_2_0._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_1, var_2_4, arg_2_0._health_extension)
	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	local var_2_18 = var_0_0[arg_2_1].z

	var_2_2:set_falling_height(var_2_18)
	Unit.flow_event(arg_2_1, "pactsworn_jump")
end

EnemyCharacterStateJumping.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	if arg_3_6 == "walking" or arg_3_6 == "standing" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	elseif arg_3_6 and arg_3_6 ~= "falling" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end
end

EnemyCharacterStateJumping.common_state_changes = function (arg_4_0)
	arg_4_0:handle_disabled_ghost_mode()

	local var_4_0 = arg_4_0._csm
	local var_4_1 = arg_4_0._unit
	local var_4_2 = arg_4_0._input_extension
	local var_4_3 = PlayerUnitMovementSettings.get_movement_settings_table(var_4_1)
	local var_4_4 = arg_4_0._status_extension
	local var_4_5 = arg_4_0._locomotion_extension
	local var_4_6 = CharacterStateHelper

	if var_4_5:is_on_ground() then
		ScriptUnit.extension(var_4_1, "whereabouts_system"):set_is_onground()
	end

	if var_4_6.do_common_state_transitions(var_4_4, var_4_0) then
		return true
	end

	if var_4_6.is_using_transport(var_4_4) then
		var_4_0:change_state("using_transport")

		return true
	end

	if var_4_6.is_pushed(var_4_4) then
		var_4_4:set_pushed(false)

		local var_4_7 = var_4_3.stun_settings.pushed

		var_4_7.hit_react_type = var_4_4:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_7)

		return true
	end

	if var_4_6.is_block_broken(var_4_4) then
		var_4_4:set_block_broken(false)

		local var_4_8 = var_4_3.stun_settings.parry_broken

		var_4_8.hit_react_type = "medium_push"

		var_4_0:change_state("stunned", var_4_8)

		return true
	end

	if var_4_5:is_animation_driven() then
		return true
	end

	local var_4_9 = arg_4_0._interactor_extension

	if var_4_6.is_starting_interaction(var_4_2, var_4_9) then
		local var_4_10, var_4_11 = InteractionHelper.interaction_action_names(var_4_1)

		var_4_9:start_interaction(var_4_11)

		if var_4_9:allow_movement_during_interaction() then
			return
		end

		local var_4_12 = var_4_9:interaction_config()
		local var_4_13 = arg_4_0._temp_params

		var_4_13.swap_to_3p = var_4_12.swap_to_3p
		var_4_13.show_weapons = var_4_12.show_weapons
		var_4_13.activate_block = var_4_12.activate_block
		var_4_13.allow_rotation_update = var_4_12.allow_rotation_update

		var_4_0:change_state("interacting", var_4_13)

		return true
	end

	if not var_4_0.state_next and var_4_4.do_leap then
		var_4_0:change_state("leaping")

		return true
	end

	if var_4_2:get("character_inspecting") then
		local var_4_14, var_4_15, var_4_16 = var_4_6.get_item_data_and_weapon_extensions(arg_4_0._inventory_extension)

		if not var_4_6.get_current_action_data(var_4_16, var_4_15) then
			var_4_0:change_state("inspecting")

			return true
		end
	end

	return false
end

EnemyCharacterStateJumping.common_movement = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0._csm
	local var_5_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_3)
	local var_5_2 = arg_5_0._input_extension
	local var_5_3 = arg_5_0._status_extension
	local var_5_4 = arg_5_0._first_person_extension
	local var_5_5 = arg_5_0._locomotion_extension
	local var_5_6 = arg_5_0._breed

	if CharacterStateHelper.do_common_state_transitions(var_5_3, var_5_0) then
		return
	end

	if CharacterStateHelper.is_pushed(var_5_3) then
		var_5_3:set_pushed(false)

		local var_5_7 = var_5_1.stun_settings.pushed

		var_5_7.hit_react_type = var_5_3:hit_react_type() .. "_push"

		var_5_0:change_state("stunned", var_5_7)

		return
	end

	if var_5_5:is_on_ground() then
		var_5_0:change_state("walking")
		var_5_4:change_state("walking")

		return
	end

	if not var_5_0.state_next and var_5_5:current_velocity().z <= 0 then
		var_5_0:change_state("falling", arg_5_0._temp_params)
		var_5_4:change_state("falling")

		return
	end

	local var_5_8 = var_5_6.movement_speed_multiplier
	local var_5_9 = var_5_1.move_speed

	if arg_5_1 then
		var_5_9 = var_5_1.ghost_move_speed
	end

	local var_5_10 = var_5_9 * var_5_8
	local var_5_11 = arg_5_0._buff_extension:apply_buffs_to_value(var_5_10, "movement_speed") * var_5_1.player_speed_scale

	CharacterStateHelper.move_in_air_pactsworn(arg_5_0._first_person_extension, var_5_2, arg_5_0._locomotion_extension, var_5_11, arg_5_3)
	CharacterStateHelper.ghost_mode(arg_5_0._ghost_mode_extension, var_5_2)
	CharacterStateHelper.look(var_5_2, arg_5_0._player.viewport_name, arg_5_0._first_person_extension, var_5_3, arg_5_0._inventory_extension)
end

EnemyCharacterStateJumping.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if arg_6_0:common_state_changes() then
		return
	end

	local var_6_0 = arg_6_0._ghost_mode_extension:is_in_ghost_mode()
	local var_6_1 = arg_6_0:common_movement(var_6_0, arg_6_3, arg_6_1)
end
