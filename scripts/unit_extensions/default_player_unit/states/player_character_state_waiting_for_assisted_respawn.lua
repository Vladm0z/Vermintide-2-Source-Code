-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_waiting_for_assisted_respawn.lua

PlayerCharacterStateWaitingForAssistedRespawn = class(PlayerCharacterStateWaitingForAssistedRespawn, PlayerCharacterState)

function PlayerCharacterStateWaitingForAssistedRespawn.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "waiting_for_assisted_respawn")

	arg_1_0.recovery_timer = nil
	arg_1_0.recovered = false
end

function PlayerCharacterStateWaitingForAssistedRespawn.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.first_person_extension:set_first_person_mode(false)

	local var_2_0 = true

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_0, arg_2_0.is_server, arg_2_0.inventory_extension)
	arg_2_0.input_extension:set_enabled(false)

	local var_2_1 = arg_2_0.status_extension.assisted_respawn_flavour_unit

	arg_2_0.flavour_unit = var_2_1

	LocomotionUtils.enable_linked_movement(arg_2_0.world, arg_2_1, var_2_1, 0, Vector3.zero())

	local var_2_2 = Unit.get_data(var_2_1, "on_enter_loop_anim")

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_2)
	CharacterStateHelper.change_camera_state(arg_2_0.player, "observer")

	local var_2_3 = ScriptUnit.extension(arg_2_1, "career_system")

	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "respawning")
	CharacterStateHelper.stop_career_abilities(var_2_3, "respawning")
end

function PlayerCharacterStateWaitingForAssistedRespawn.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

	local var_3_0 = true

	CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_0, arg_3_0.is_server, arg_3_0.inventory_extension)
	arg_3_0.input_extension:set_enabled(true)

	local var_3_1 = arg_3_0.player

	CharacterStateHelper.change_camera_state(var_3_1, "follow")
	LocomotionUtils.disable_linked_movement(arg_3_1)
	arg_3_0.locomotion_extension:enable_script_driven_movement()

	arg_3_0.recovery_timer = nil
	arg_3_0.recovered = false

	local var_3_2 = arg_3_0.status_extension

	var_3_2:set_assisted_respawning(false)
	var_3_2:set_respawned(true)

	if Managers.state.network:game() and not LEVEL_EDITOR_TEST then
		local var_3_3 = Managers.state.network
		local var_3_4 = arg_3_0.status_extension:get_assisted_respawn_helper_unit()
		local var_3_5 = var_3_3:unit_game_object_id(arg_3_1) or 0
		local var_3_6 = var_3_4 and var_3_3:unit_game_object_id(var_3_4) or 0

		var_3_3.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.respawned, true, var_3_5, var_3_6)
	end
end

function PlayerCharacterStateWaitingForAssistedRespawn.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.status_extension

	if CharacterStateHelper.is_dead(var_4_1) then
		var_4_0:change_state("dead")

		return
	end

	if CharacterStateHelper.is_assisted_respawning(var_4_1) then
		if not arg_4_0.recovery_timer then
			local var_4_2 = arg_4_0.flavour_unit

			arg_4_0.recovery_timer = arg_4_5 + Unit.get_data(var_4_2, "recovery_time")

			CharacterStateHelper.play_animation_event(arg_4_1, "respawn_revive")
		elseif arg_4_5 >= arg_4_0.recovery_timer then
			var_4_0:change_state("standing")

			return
		end
	end
end
