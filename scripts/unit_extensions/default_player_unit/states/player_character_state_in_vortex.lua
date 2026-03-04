-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_in_vortex.lua

PlayerCharacterStateInVortex = class(PlayerCharacterStateInVortex, PlayerCharacterState)

PlayerCharacterStateInVortex.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "in_vortex")
end

PlayerCharacterStateInVortex.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_0.game = Managers.state.network:game()

	local var_2_0 = arg_2_0.unit_storage
	local var_2_1 = arg_2_0.status_extension.in_vortex_unit
	local var_2_2 = var_2_0:go_id(var_2_1)
	local var_2_3 = ScriptUnit.extension(var_2_1, "ai_supplementary_system")
	local var_2_4 = var_2_3.vortex_template

	arg_2_0.vortex_unit = var_2_1
	arg_2_0.vortex_unit_go_id = var_2_2
	arg_2_0.vortex_owner_unit = var_2_3._owner_unit

	local var_2_5 = var_2_4.player_actions_allowed

	arg_2_0.vortex_full_inner_radius = var_2_4.full_inner_radius
	arg_2_0.ascend_speed = var_2_4.player_ascend_speed
	arg_2_0.rotation_speed = var_2_4.player_rotation_speed
	arg_2_0.radius_change_speed = var_2_4.player_radius_change_speed
	arg_2_0.player_actions_allowed = var_2_5
	arg_2_0.vortex_max_height = var_2_4.max_height

	arg_2_0.interactor_extension:abort_interaction()

	local var_2_6 = arg_2_0.locomotion_extension

	var_2_6:set_maximum_upwards_velocity(10)
	var_2_6:enable_drag(false)

	local var_2_7 = arg_2_0.first_person_extension

	arg_2_0.screenspace_effect_particle_id = var_2_7:create_screen_particles("fx/screenspace_inside_plague_vortex")

	var_2_7:play_hud_sound_event("sfx_player_in_vortex_true")

	local var_2_8

	if var_2_5 then
		var_2_8 = "idle"
	else
		local var_2_9 = arg_2_0.inventory_extension
		local var_2_10 = arg_2_0.career_extension

		CharacterStateHelper.stop_weapon_actions(var_2_9, "stunned")
		CharacterStateHelper.stop_career_abilities(var_2_10, "stunned")

		local var_2_11 = "backward"

		var_2_8 = PlayerUnitMovementSettings.catapulted.directions[var_2_11].start_animation

		var_2_7:hide_weapons("in_vortex")

		local var_2_12 = false

		CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_12, arg_2_0.is_server, var_2_9)
	end

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_8)
	CharacterStateHelper.play_animation_event_first_person(var_2_7, var_2_8)
end

PlayerCharacterStateInVortex.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.vortex_unit_go_id = nil
	arg_3_0.vortex_full_inner_radius = nil

	if arg_3_6 then
		local var_3_0 = arg_3_0.locomotion_extension

		var_3_0:reset_maximum_upwards_velocity()
		var_3_0:enable_drag(true)

		local var_3_1 = arg_3_0.first_person_extension

		var_3_1:stop_spawning_screen_particles(arg_3_0.screenspace_effect_particle_id)
		var_3_1:play_hud_sound_event("sfx_player_in_vortex_false")

		arg_3_0.screenspace_effect_particle_id = nil

		local var_3_2 = Unit.alive(arg_3_0.vortex_owner_unit) and arg_3_0.vortex_owner_unit or arg_3_1

		Managers.state.entity:system("buff_system"):add_buff(arg_3_1, "vortex_base", var_3_2)

		if not arg_3_0.player_actions_allowed then
			var_3_1:unhide_weapons("in_vortex")

			if Managers.state.network:game() then
				local var_3_3 = false

				CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_3, arg_3_0.is_server, arg_3_0.inventory_extension)
				CharacterStateHelper.play_animation_event(arg_3_1, "airtime_end")
			end
		end
	end

	arg_3_0.vortex_owner_unit = nil
end

PlayerCharacterStateInVortex.update_spin_velocity = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0.game
	local var_4_1 = GameSession.game_object_field(var_4_0, arg_4_3, "inner_radius_percentage")
	local var_4_2 = arg_4_0.vortex_full_inner_radius * var_4_1 * 0.75
	local var_4_3 = arg_4_0.ascend_speed
	local var_4_4 = arg_4_0.rotation_speed
	local var_4_5 = arg_4_0.radius_change_speed
	local var_4_6 = POSITION_LOOKUP[arg_4_1]
	local var_4_7 = POSITION_LOOKUP[arg_4_2]
	local var_4_8, var_4_9, var_4_10 = LocomotionUtils.get_vortex_spin_velocity(var_4_6, var_4_7, var_4_2, Vector3.up(), var_4_4, var_4_5, var_4_3, arg_4_4)
	local var_4_11 = GameSession.game_object_field(var_4_0, arg_4_3, "height_percentage")

	if var_4_10 > arg_4_0.vortex_max_height * var_4_11 then
		var_4_8.z = 0
	end

	local var_4_12 = arg_4_0.locomotion_extension

	var_4_12:set_forced_velocity(var_4_8)
	var_4_12:set_wanted_velocity(var_4_8)
end

PlayerCharacterStateInVortex.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.status_extension
	local var_5_2 = arg_5_0.first_person_extension
	local var_5_3, var_5_4 = CharacterStateHelper.is_catapulted(var_5_1)

	if var_5_3 then
		local var_5_5 = {
			sound_event = "Play_enemy_sorcerer_vortex_throw_player",
			direction = var_5_4
		}

		var_5_0:change_state("catapulted", var_5_5)

		return
	end

	if not var_5_1:is_valid_vortex_target() then
		CharacterStateHelper.do_common_state_transitions(var_5_1, var_5_0)

		return
	end

	if not CharacterStateHelper.is_in_vortex(var_5_1) then
		if CharacterStateHelper.is_colliding_down(arg_5_1) then
			var_5_0:change_state("standing")
		else
			var_5_0:change_state("falling")
		end

		return
	end

	local var_5_6 = arg_5_0.input_extension
	local var_5_7 = arg_5_0.interactor_extension
	local var_5_8 = arg_5_0.player_actions_allowed

	if var_5_8 and CharacterStateHelper.is_starting_interaction(var_5_6, var_5_7) and var_5_7:allow_movement_during_interaction() then
		local var_5_9, var_5_10 = InteractionHelper.interaction_action_names(arg_5_1)

		var_5_7:start_interaction(var_5_10)
	end

	if Unit.alive(arg_5_0.vortex_unit) then
		arg_5_0:update_spin_velocity(arg_5_1, arg_5_0.vortex_unit, arg_5_0.vortex_unit_go_id, arg_5_3)
	end

	local var_5_11 = arg_5_0.player.viewport_name
	local var_5_12 = arg_5_0.inventory_extension

	CharacterStateHelper.look(var_5_6, var_5_11, var_5_2, var_5_1, var_5_12)

	if var_5_8 then
		local var_5_13 = arg_5_0.health_extension

		CharacterStateHelper.update_weapon_actions(arg_5_5, arg_5_1, var_5_6, var_5_12, var_5_13)
	end
end
