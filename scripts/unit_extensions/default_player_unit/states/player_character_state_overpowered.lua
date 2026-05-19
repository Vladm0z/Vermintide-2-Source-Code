-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_overpowered.lua

PlayerCharacterStateOverpowered = class(PlayerCharacterStateOverpowered, PlayerCharacterState)

function PlayerCharacterStateOverpowered.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "overpowered")
end

function PlayerCharacterStateOverpowered.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "overpowered")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "overpowered")

	local var_2_0 = Managers.player:owner(arg_2_1)
	local var_2_1 = var_2_0 and not var_2_0:is_player_controlled()

	if arg_2_7.start_sound_event and not var_2_1 then
		local var_2_2 = Managers.world:wwise_world(arg_2_0.world)

		WwiseWorld.trigger_event(var_2_2, arg_2_7.start_sound_event)
	end

	local var_2_3 = "to_cloud_of_flies"

	arg_2_0.inventory_extension:check_and_drop_pickups("overpowererd")
	CharacterStateHelper.play_animation_event(arg_2_1, var_2_3)

	local var_2_4 = arg_2_0.input_extension
	local var_2_5 = arg_2_0.status_extension

	arg_2_0.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_0.params = arg_2_7

	CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person")
	arg_2_0.first_person_extension:set_first_person_mode(false)
	CharacterStateHelper.show_inventory_3p(arg_2_1, false, true, Managers.player.is_server, arg_2_0.inventory_extension)
end

function PlayerCharacterStateOverpowered.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = Managers.player:owner(arg_3_1)
	local var_3_1 = var_3_0 and not var_3_0:is_player_controlled()

	if arg_3_0.params.end_sound_event and not var_3_1 then
		local var_3_2 = Managers.world:wwise_world(arg_3_0.world)

		WwiseWorld.trigger_event(var_3_2, arg_3_0.params.end_sound_event)
	end

	local var_3_3 = ScriptUnit.has_extension(arg_3_1, "first_person_system")

	if var_3_3 and arg_3_0.onscreen_particle_id then
		var_3_3:stop_spawning_screen_particles(arg_3_0.onscreen_particle_id)
	end

	if arg_3_6 ~= "knocked_down" then
		CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")
		arg_3_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

		local var_3_4 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_4, arg_3_0.is_server, arg_3_0.inventory_extension)
	end

	arg_3_0.inventory_extension:rewield_wielded_slot()
	arg_3_0.status_extension:set_overpowered(false)
end

function PlayerCharacterStateOverpowered.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.input_extension
	local var_4_3 = arg_4_0.inventory_extension
	local var_4_4 = arg_4_0.status_extension
	local var_4_5 = arg_4_0.locomotion_extension
	local var_4_6 = arg_4_0.world
	local var_4_7 = var_4_4.overpowered_attacking_unit

	if not HEALTH_ALIVE[var_4_7] then
		if CharacterStateHelper.is_waiting_for_assisted_respawn(var_4_4) then
			var_4_0:change_state("waiting_for_assisted_respawn")
		elseif CharacterStateHelper.is_knocked_down(var_4_4) then
			var_4_0:change_state("knocked_down")
		elseif CharacterStateHelper.is_dead(var_4_4) then
			var_4_0:change_state("dead")
		else
			var_4_0:change_state("standing")
		end

		return
	end

	if CharacterStateHelper.do_common_state_transitions(var_4_4, var_4_0, "overpowered") then
		return
	end

	if CharacterStateHelper.is_ledge_hanging(var_4_6, var_4_1, arg_4_0.temp_params) then
		var_4_0:change_state("ledge_hanging", arg_4_0.temp_params)

		return
	end

	if not var_4_0.state_next and not var_4_5:is_on_ground() then
		var_4_0:change_state("falling")

		return
	end

	var_4_5:set_disable_rotation_update()
	CharacterStateHelper.look(var_4_2, arg_4_0.player.viewport_name, arg_4_0.first_person_extension, var_4_4, var_4_3)
end
