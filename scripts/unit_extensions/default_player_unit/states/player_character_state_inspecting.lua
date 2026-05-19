-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_inspecting.lua

PlayerCharacterStateInspecting = class(PlayerCharacterStateInspecting, PlayerCharacterState)

function PlayerCharacterStateInspecting.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "inspecting")

	local var_1_0 = arg_1_1
end

function PlayerCharacterStateInspecting.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.locomotion_extension:set_wanted_velocity(Vector3.zero())
	CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person")
	arg_2_0.first_person_extension:set_first_person_mode(false)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "inspecting")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "inspecting")
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(arg_2_0.first_person_extension, "idle")
	arg_2_0.status_extension:set_inspecting(true)
end

function PlayerCharacterStateInspecting.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")
	arg_3_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	arg_3_0.status_extension:set_inspecting(false)
end

function PlayerCharacterStateInspecting.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.input_extension
	local var_4_3 = arg_4_0.interactor_extension
	local var_4_4 = Managers.state.camera
	local var_4_5 = arg_4_0.status_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_5, var_4_0) then
		return
	end

	local var_4_6 = arg_4_0.world

	if CharacterStateHelper.is_ledge_hanging(var_4_6, var_4_1, arg_4_0.temp_params) then
		var_4_0:change_state("ledge_hanging", arg_4_0.temp_params)

		return
	end

	if arg_4_0.cosmetic_extension:get_queued_3p_emote() then
		var_4_0:change_state("emote")

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

	arg_4_0.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_4_2, arg_4_0.player.viewport_name, arg_4_0.first_person_extension, var_4_5, arg_4_0.inventory_extension)
end
