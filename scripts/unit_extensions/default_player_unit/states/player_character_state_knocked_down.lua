-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_knocked_down.lua

PlayerCharacterStateKnockedDown = class(PlayerCharacterStateKnockedDown, PlayerCharacterState)

PlayerCharacterStateKnockedDown.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "knocked_down")

	local var_1_0 = arg_1_1
end

PlayerCharacterStateKnockedDown.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "knocked_down")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "knocked_down")

	local var_2_0 = arg_2_0.unit
	local var_2_1 = arg_2_0.player.input_source

	if not arg_2_7 or not arg_2_7.already_in_ko_anim then
		local var_2_2 = "knockdown_fall_front"

		CharacterStateHelper.play_animation_event(var_2_0, var_2_2)

		if arg_2_7 and arg_2_7.already_in_ko_anim then
			arg_2_7.already_in_ko_anim = nil
		end
	end

	arg_2_0.debug_t = arg_2_5

	arg_2_0.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_3 = arg_2_0.first_person_extension

	var_2_3:set_wanted_player_height("knocked_down", arg_2_5)
	var_2_3:animation_event("knocked_down")
	var_2_3:animation_set_variable("knockdown_blend", 0)

	arg_2_0.start_time = arg_2_5

	CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person")
	var_2_3:set_first_person_mode(false)

	local var_2_4 = ScriptUnit.extension(var_2_0, "status_system")

	arg_2_0.pounced_down = arg_2_6 == "pounced_down"

	local var_2_5, var_2_6 = CharacterStateHelper.is_pounced_down(var_2_4)

	if var_2_5 and not arg_2_0.pounced_down then
		CharacterStateHelper.play_animation_event(var_2_6, "jump_attack")
		CharacterStateHelper.play_animation_event(var_2_0, "jump_attack")

		arg_2_0.pounced_down = true
	end

	arg_2_0.grabbed_by_pack_master = arg_2_6 == "grabbed_by_pack_master"

	local var_2_7 = true

	CharacterStateHelper.show_inventory_3p(var_2_0, false, var_2_7, arg_2_0.is_server, arg_2_0.inventory_extension)
	ScriptUnit.extension(var_2_0, "inventory_system"):check_and_drop_pickups("knocked_down")
	ScriptUnit.extension(var_2_0, "overcharge_system"):reset()
	var_2_4:set_catapulted(false)
end

PlayerCharacterStateKnockedDown.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.first_person_extension

	if arg_3_6 ~= "dead" then
		CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")

		local var_3_1 = true

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_1, arg_3_0.is_server, arg_3_0.inventory_extension)
		arg_3_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	end

	var_3_0:set_wanted_player_height("stand", arg_3_5)
end

PlayerCharacterStateKnockedDown.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.locomotion_extension

	if var_4_2:is_on_ground() then
		ScriptUnit.extension(var_4_1, "whereabouts_system"):set_is_onground()
	end

	local var_4_3 = arg_4_0.status_extension

	if CharacterStateHelper.is_dead(var_4_3) then
		var_4_0:change_state("dead")

		return
	end

	if arg_4_0.pounced_down and not CharacterStateHelper.is_pounced_down(var_4_3) then
		var_4_2:set_disabled(false, LocomotionUtils.update_local_animation_driven_movement_with_parent)

		local var_4_4 = "knockdown"

		CharacterStateHelper.play_animation_event(var_4_1, var_4_4)

		arg_4_0.pounced_down = false
	end

	if arg_4_0.grabbed_by_pack_master and not CharacterStateHelper.is_grabbed_by_pack_master(var_4_3) then
		var_4_2:enable_script_driven_movement()
		var_4_2:enable_rotation_towards_velocity(true)

		arg_4_0.grabbed_by_pack_master = false
	end

	if not CharacterStateHelper.is_knocked_down(var_4_3) then
		arg_4_0.temp_params.is_crouching = false

		var_4_0:change_state("standing")

		return
	end

	local var_4_5 = arg_4_5 - arg_4_0.start_time
	local var_4_6 = arg_4_0.first_person_extension

	if var_4_5 <= 1 then
		var_4_6:animation_set_variable("knockdown_blend", var_4_5)
	else
		var_4_6:animation_set_variable("knockdown_blend", 1)
	end

	local var_4_7 = arg_4_0.input_extension

	var_4_2:set_disable_rotation_update()
	CharacterStateHelper.look(var_4_7, arg_4_0.player.viewport_name, arg_4_0.first_person_extension, var_4_3, arg_4_0.inventory_extension)
end
