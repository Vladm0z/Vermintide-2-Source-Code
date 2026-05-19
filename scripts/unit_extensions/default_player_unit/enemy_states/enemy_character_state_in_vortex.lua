-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_in_vortex.lua

EnemyCharacterStateInVortex = class(EnemyCharacterStateInVortex, EnemyCharacterState)

function EnemyCharacterStateInVortex.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "in_vortex")
end

function EnemyCharacterStateInVortex.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_0.game = Managers.state.network:game()

	local var_2_0 = arg_2_0._unit_storage
	local var_2_1 = arg_2_0._status_extension.in_vortex_unit
	local var_2_2 = var_2_0:go_id(var_2_1)
	local var_2_3 = ScriptUnit.has_extension(var_2_1, "ai_supplementary_system")
	local var_2_4 = ScriptUnit.has_extension(var_2_1, "area_damage_system")
	local var_2_5

	if var_2_3 then
		var_2_5 = var_2_3.vortex_template
	elseif var_2_4 then
		var_2_5 = var_2_4.vortex_template
	else
		error("[EnemyCharacterStateInVortex] Could not deduce vortex template.")
	end

	arg_2_0.vortex_unit = var_2_1
	arg_2_0.vortex_unit_go_id = var_2_2

	local var_2_6 = var_2_5.player_actions_allowed

	arg_2_0.vortex_full_inner_radius = var_2_5.full_inner_radius
	arg_2_0.keep_enemies_within_radius = var_2_5.keep_enemies_within_radius
	arg_2_0.ascend_speed = var_2_5.player_ascend_speed
	arg_2_0.rotation_speed = var_2_5.player_rotation_speed
	arg_2_0.radius_change_speed = var_2_5.player_radius_change_speed
	arg_2_0.player_actions_allowed = var_2_6
	arg_2_0.vortex_max_height = var_2_5.max_height_player_target or var_2_5.max_height
	arg_2_0.post_vortex_buff = var_2_5.post_vortex_buff

	arg_2_0._interactor_extension:abort_interaction()

	local var_2_7 = arg_2_0._locomotion_extension

	var_2_7:set_maximum_upwards_velocity(10)
	var_2_7:enable_drag(false)

	local var_2_8 = arg_2_0._first_person_extension

	arg_2_0.screenspace_effect_particle_id = var_2_8:create_screen_particles("fx/screenspace_inside_plague_vortex")

	var_2_8:play_hud_sound_event("sfx_player_in_vortex_true")

	local var_2_9

	if var_2_6 then
		var_2_9 = "idle"
	else
		local var_2_10 = arg_2_0._inventory_extension
		local var_2_11 = arg_2_0._career_extension

		CharacterStateHelper.stop_weapon_actions(var_2_10, "stunned")
		CharacterStateHelper.stop_career_abilities(var_2_11, "stunned")

		var_2_9 = "idle"

		var_2_8:hide_weapons("in_vortex")

		local var_2_12 = false

		CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_12, arg_2_0._is_server, var_2_10)
	end

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_9)
	CharacterStateHelper.play_animation_event_first_person(var_2_8, var_2_9)
end

function EnemyCharacterStateInVortex.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.vortex_unit_go_id = nil
	arg_3_0.vortex_full_inner_radius = nil

	if arg_3_6 then
		local var_3_0 = arg_3_0._locomotion_extension

		var_3_0:reset_maximum_upwards_velocity()
		var_3_0:enable_drag(true)

		local var_3_1 = arg_3_0._first_person_extension

		var_3_1:stop_spawning_screen_particles(arg_3_0.screenspace_effect_particle_id)
		var_3_1:play_hud_sound_event("sfx_player_in_vortex_false")

		arg_3_0.screenspace_effect_particle_id = nil

		if arg_3_0.post_vortex_buff then
			Managers.state.entity:system("buff_system"):add_buff(arg_3_1, arg_3_0.post_vortex_buff, arg_3_1)
		end

		if not arg_3_0.player_actions_allowed then
			var_3_1:unhide_weapons("in_vortex")

			if Managers.state.network:game() then
				local var_3_2 = false

				CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_2, arg_3_0._is_server, arg_3_0._inventory_extension)
				CharacterStateHelper.play_animation_event(arg_3_1, "idle")
			end
		end
	end
end

function EnemyCharacterStateInVortex.update_spin_velocity(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0.game
	local var_4_1 = GameSession.game_object_field(var_4_0, arg_4_3, "inner_radius_percentage")
	local var_4_2 = (arg_4_0.keep_enemies_within_radius or arg_4_0.vortex_full_inner_radius * 0.75) * var_4_1
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

	local var_4_12 = arg_4_0._locomotion_extension

	var_4_12:set_forced_velocity(var_4_8)
	var_4_12:set_wanted_velocity(var_4_8)
end

function EnemyCharacterStateInVortex.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0._csm
	local var_5_1 = arg_5_0._status_extension
	local var_5_2 = arg_5_0._first_person_extension
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

	local var_5_6 = arg_5_0._input_extension
	local var_5_7 = arg_5_0._interactor_extension

	if arg_5_0.player_actions_allowed and CharacterStateHelper.is_starting_interaction(var_5_6, var_5_7) and var_5_7:allow_movement_during_interaction() then
		local var_5_8, var_5_9 = InteractionHelper.interaction_action_names(arg_5_1)

		var_5_7:start_interaction(var_5_9)
	end

	if Unit.alive(arg_5_0.vortex_unit) then
		arg_5_0:update_spin_velocity(arg_5_1, arg_5_0.vortex_unit, arg_5_0.vortex_unit_go_id, arg_5_3)
	end

	local var_5_10 = arg_5_0._player.viewport_name
	local var_5_11 = arg_5_0._inventory_extension

	CharacterStateHelper.look(var_5_6, var_5_10, var_5_2, var_5_1, var_5_11)
end
