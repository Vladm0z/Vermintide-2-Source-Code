-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_leaving_ladder_top.lua

PlayerCharacterStateLeavingLadderTop = class(PlayerCharacterStateLeavingLadderTop, PlayerCharacterState)

function PlayerCharacterStateLeavingLadderTop.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "leaving_ladder_top")

	local var_1_0 = arg_1_1

	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.wanted_forward_bonus_velocity = Vector3Box()
end

function PlayerCharacterStateLeavingLadderTop.on_enter_animation_event(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.unit

	CharacterStateHelper.play_animation_event_with_variable_float(var_2_0, "climb_top_exit_ladder", "climb_enter_exit_speed", arg_2_1)
end

function PlayerCharacterStateLeavingLadderTop.on_enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_0.unit
	local var_3_1 = arg_3_0.input_extension
	local var_3_2 = arg_3_0.first_person_extension
	local var_3_3 = arg_3_7.ladder_unit

	arg_3_0.ladder_unit = var_3_3
	arg_3_0.movement_speed = 1

	local var_3_4 = PlayerUnitMovementSettings.get_movement_settings_table(var_3_0).ladder.leaving_ladder_top_animation_time

	arg_3_0.finish_time = arg_3_5 + var_3_4

	arg_3_0.wanted_forward_bonus_velocity:store(Quaternion.forward(Unit.local_rotation(var_3_3, 0)))
	arg_3_0:on_enter_animation_event(2 / var_3_4)

	local var_3_5 = arg_3_0.locomotion_extension

	var_3_5:enable_script_driven_ladder_transition_movement()
	var_3_5:set_mover_filter_property("ladder", true)
end

function PlayerCharacterStateLeavingLadderTop.on_exit(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = Managers.state.network:unit_game_object_id(arg_4_0.unit)
	local var_4_1 = false

	CharacterStateHelper.show_inventory_3p(arg_4_1, true, var_4_1, arg_4_0.is_server, arg_4_0.inventory_extension)

	local var_4_2 = arg_4_0.first_person_extension

	var_4_2:unhide_weapons("climbing")
	var_4_2:play_animation_event("idle")

	if arg_4_6 and Managers.state.network:game() then
		CharacterStateHelper.play_animation_event(arg_4_1, "climb_end_ladder")
		CharacterStateHelper.set_is_on_ladder(arg_4_0.ladder_unit, arg_4_1, false, arg_4_0.is_server, arg_4_0.status_extension)
	end

	local var_4_3 = arg_4_0.locomotion_extension

	var_4_3:enable_script_driven_movement()
	var_4_3:enable_rotation_towards_velocity(true)
	var_4_3:set_mover_filter_property("ladder", false)
end

function PlayerCharacterStateLeavingLadderTop.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.unit
	local var_5_2 = arg_5_0.input_extension
	local var_5_3 = arg_5_0.status_extension
	local var_5_4 = arg_5_0.locomotion_extension

	if CharacterStateHelper.is_dead(var_5_3) then
		var_5_0:change_state("dead")

		return
	end

	if CharacterStateHelper.is_knocked_down(var_5_3) then
		var_5_0:change_state("knocked_down")

		return
	end

	if CharacterStateHelper.is_pounced_down(var_5_3) then
		var_5_0:change_state("pounced_down")

		return
	end

	local var_5_5, var_5_6 = CharacterStateHelper.is_catapulted(var_5_3)

	if var_5_5 then
		local var_5_7 = {
			sound_event = "Play_hit_by_ratogre",
			direction = var_5_6
		}

		var_5_0:change_state("catapulted", var_5_7)

		return
	end

	if arg_5_5 > arg_5_0.finish_time then
		var_5_0:change_state("walking")
	end

	local var_5_8 = PlayerUnitMovementSettings.get_movement_settings_table(var_5_1)
	local var_5_9 = math.degrees_to_radians(var_5_8.ladder.look_horizontal_max_degrees)
	local var_5_10 = Unit.local_rotation(arg_5_0.ladder_unit, 0)

	CharacterStateHelper.look_limited_rotation_freedom(var_5_2, arg_5_0.player.viewport_name, arg_5_0.first_person_extension, var_5_1, var_5_10, var_5_9, nil, var_5_3, arg_5_0.inventory_extension)
end
