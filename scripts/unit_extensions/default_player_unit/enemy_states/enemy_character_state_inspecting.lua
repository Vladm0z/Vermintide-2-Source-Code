-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_inspecting.lua

EnemyCharacterStateInspecting = class(EnemyCharacterStateInspecting, EnemyCharacterState)

function EnemyCharacterStateInspecting.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "inspecting")

	local var_1_0 = arg_1_1
end

function EnemyCharacterStateInspecting.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0._locomotion_extension:set_wanted_velocity(Vector3.zero())
	CharacterStateHelper.change_camera_state(arg_2_0._player, "follow_third_person")

	local var_2_0 = false
	local var_2_1
	local var_2_2 = false

	if arg_2_0._status_extension:get_unarmed() then
		var_2_2 = true
	end

	arg_2_0._first_person_extension:set_first_person_mode(var_2_0, var_2_1, var_2_2)
	CharacterStateHelper.stop_weapon_actions(arg_2_0._inventory_extension, "inspecting")
	CharacterStateHelper.stop_career_abilities(arg_2_0._career_extension, "inspecting")
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(arg_2_0._first_person_extension, "idle")
	arg_2_0._status_extension:set_inspecting(true)
end

function EnemyCharacterStateInspecting.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	CharacterStateHelper.change_camera_state(arg_3_0._player, "follow")
	arg_3_0._first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	arg_3_0._status_extension:set_inspecting(false)
end

function EnemyCharacterStateInspecting.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = arg_4_0._unit
	local var_4_2 = arg_4_0._input_extension
	local var_4_3 = arg_4_0._interactor_extension
	local var_4_4 = Managers.state.camera
	local var_4_5 = arg_4_0._status_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_5, var_4_0) then
		return
	end

	if not var_4_2:get("character_inspecting") then
		var_4_0:change_state("standing")

		return
	end

	if not var_4_0.state_next and var_4_5.do_leap then
		var_4_0:change_state("leaping")

		return
	end

	arg_4_0._locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_4_2, arg_4_0._player.viewport_name, arg_4_0._first_person_extension, var_4_5, arg_4_0._inventory_extension)
end
