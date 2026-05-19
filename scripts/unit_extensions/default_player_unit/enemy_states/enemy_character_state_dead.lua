-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_dead.lua

EnemyCharacterStateDead = class(EnemyCharacterStateDead, EnemyCharacterState)

function EnemyCharacterStateDead.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "dead")
end

function EnemyCharacterStateDead.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.despawn_time_start = arg_2_5
	arg_2_0.despawned = false
	arg_2_0.switched_to_observer_camera = false

	local var_2_0 = Unit.get_data(arg_2_1, "breed")

	if not (var_2_0 and var_2_0.name and var_2_0.name == "vs_gutter_runner") and arg_2_1 then
		local var_2_1 = arg_2_7 and arg_2_7.animation or "death"

		CharacterStateHelper.play_animation_event(arg_2_1, var_2_1)
	end

	arg_2_0._locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_2 = arg_2_0._first_person_extension

	var_2_2:set_wanted_player_height("knocked_down", arg_2_5)
	var_2_2:set_first_person_mode(false)

	local var_2_3 = var_2_0.death_sound_event

	if var_2_3 then
		var_2_2:play_hud_sound_event(var_2_3)
	end

	local var_2_4 = true
	local var_2_5 = Development.parameter("fast_respawns")
	local var_2_6 = arg_2_0._player:profile_index()
	local var_2_7 = SPProfiles[var_2_6]
	local var_2_8 = var_2_7.affiliation
	local var_2_9 = ScriptUnit.extension(arg_2_1, "health_system").last_damage_data
	local var_2_10 = Managers.state.network.unit_storage:unit(var_2_9.attacker_unit_id)

	if var_2_10 and DamageUtils.is_player_unit(var_2_10) then
		arg_2_0._override_follow_unit = var_2_10
		arg_2_0._override_node_name = "camera_attach"
	else
		arg_2_0._override_follow_unit = arg_2_0._player.player_unit
		arg_2_0._override_node_name = "j_hips"
	end

	arg_2_0._linger_time = GameModeSettings.versus.side_settings.dark_pact.spawn_times.delayed_death_time
	arg_2_0.dead_player_destroy_time = var_2_5 and 1 or arg_2_0._linger_time

	local var_2_11 = not var_2_5 and arg_2_7 and arg_2_7.drop_items_delay or 0

	if var_2_7.dead_player_destroy_time then
		arg_2_0.dead_player_destroy_time = var_2_7.dead_player_destroy_time
		var_2_11 = arg_2_0.dead_player_destroy_time - 0.001
	end

	local var_2_12 = {
		override_node_name = "j_hips",
		allow_camera_movement = true,
		follow_unit_rotation = false,
		override_follow_unit = arg_2_0._player.player_unit,
		camera_offset = Vector3.up(),
		min_leave_t = math.huge
	}

	CharacterStateHelper.change_camera_state(arg_2_0._player, "follow_third_person", var_2_12)
	fassert(var_2_11 < arg_2_0.dead_player_destroy_time, "Drop items delay too large - this will cause a drop attempt when the player is already despawned!")

	arg_2_0.drop_items_time = arg_2_5 + var_2_11

	local var_2_13 = arg_2_7 and arg_2_7.override_item_drop_position or nil
	local var_2_14 = arg_2_7 and arg_2_7.override_item_drop_direction or nil

	arg_2_0.override_item_drop_position = var_2_13 and Vector3Box(var_2_13) or nil
	arg_2_0.override_item_drop_direction = var_2_14 and Vector3Box(var_2_14) or nil

	if var_2_0.name == "vs_packmaster" then
		local var_2_15 = ScriptUnit.extension(arg_2_1, "status_system")

		if var_2_15:get_is_packmaster_dragging() then
			local var_2_16 = var_2_15:get_packmaster_dragged_unit()

			StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", var_2_16, false, arg_2_1)
			var_2_15:set_packmaster_released()
		end
	end
end

function EnemyCharacterStateDead.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.override_item_drop_position = nil
	arg_3_0.override_item_drop_direction = nil

	local var_3_0 = Managers.state.game_mode:game_mode()

	if var_3_0 and not var_3_0:is_about_to_end_game_early() then
		local var_3_1 = {
			input_service_name = "dark_pact_selection",
			allow_camera_movement = true,
			follow_unit_rotation = false,
			override_follow_unit = arg_3_0._override_follow_unit,
			override_node_name = arg_3_0._override_node_name
		}
		local var_3_2 = arg_3_5 - arg_3_0.despawn_time_start

		if var_3_2 < arg_3_0._linger_time then
			local var_3_3 = arg_3_5 + (arg_3_0._linger_time - var_3_2)

			CharacterStateHelper.change_camera_state_delayed(arg_3_0._player, "observer", var_3_1, var_3_3)
		else
			CharacterStateHelper.change_camera_state(arg_3_0._player, "observer", var_3_1)
		end
	end
end

function EnemyCharacterStateDead.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_5 - arg_4_0.despawn_time_start

	if not arg_4_0.despawned and var_4_0 > arg_4_0.dead_player_destroy_time then
		local var_4_1 = Managers.player:unit_owner(arg_4_1)

		Managers.state.spawn:delayed_despawn(var_4_1)

		arg_4_0.despawned = true

		if var_4_1.local_player then
			Managers.state.camera:clear_mood("knocked_down")
			Managers.state.camera:clear_mood("wounded")
			Managers.state.camera:clear_mood("bleeding_out")
		end
	end
end
