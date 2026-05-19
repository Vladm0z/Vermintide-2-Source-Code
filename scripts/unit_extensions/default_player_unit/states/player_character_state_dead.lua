-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_dead.lua

PlayerCharacterStateDead = class(PlayerCharacterStateDead, PlayerCharacterState)

function PlayerCharacterStateDead.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "dead")
end

function PlayerCharacterStateDead.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.despawn_time_start = arg_2_5
	arg_2_0.despawned = false
	arg_2_0.switched_to_observer_camera = false

	local var_2_0 = arg_2_7 and arg_2_7.animation or "death"

	CharacterStateHelper.play_animation_event(arg_2_0.unit, var_2_0)
	arg_2_0.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_1 = arg_2_0.first_person_extension

	var_2_1:set_wanted_player_height("knocked_down", arg_2_5)
	var_2_1:set_first_person_mode(false)

	local var_2_2 = true

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_2, arg_2_0.is_server, arg_2_0.inventory_extension)
	CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person")

	local var_2_3 = Development.parameter("fast_respawns")

	arg_2_0.dead_player_destroy_time = var_2_3 and 1 or PlayerUnitDamageSettings.dead_player_destroy_time

	local var_2_4 = not var_2_3 and arg_2_7 and arg_2_7.drop_items_delay or 0

	fassert(var_2_4 < arg_2_0.dead_player_destroy_time, "Drop items delay too large - this will cause a drop attempt when the player is already despawned!")

	arg_2_0.drop_items_time = arg_2_5 + var_2_4

	local var_2_5 = arg_2_7 and arg_2_7.override_item_drop_position or nil
	local var_2_6 = arg_2_7 and arg_2_7.override_item_drop_direction or nil

	arg_2_0.override_item_drop_position = var_2_5 and Vector3Box(var_2_5) or nil
	arg_2_0.override_item_drop_direction = var_2_6 and Vector3Box(var_2_6) or nil
end

function PlayerCharacterStateDead.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.override_item_drop_position = nil
	arg_3_0.override_item_drop_direction = nil
end

function PlayerCharacterStateDead.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_5 - arg_4_0.despawn_time_start
	local var_4_1 = Managers.player:unit_owner(arg_4_1)
	local var_4_2 = var_4_1 and not var_4_1:needs_despawn()
	local var_4_3 = Managers.state.game_mode:game_mode():is_about_to_end_game_early()

	if not arg_4_0.switched_to_observer_camera and (var_4_2 or var_4_0 + 1 > arg_4_0.dead_player_destroy_time) and not var_4_3 then
		arg_4_0.switched_to_observer_camera = true

		CharacterStateHelper.change_camera_state(arg_4_0.player, "observer")
	end

	if not arg_4_0.items_dropped and (var_4_2 or arg_4_5 > arg_4_0.drop_items_time) then
		local var_4_4 = arg_4_0.override_item_drop_position and arg_4_0.override_item_drop_position:unbox()
		local var_4_5 = arg_4_0.override_item_drop_direction and arg_4_0.override_item_drop_direction:unbox()

		ScriptUnit.extension(arg_4_1, "inventory_system"):check_and_drop_pickups("death", var_4_4, var_4_5)

		arg_4_0.items_dropped = true
	end

	if not arg_4_0.despawned and (var_4_2 or var_4_0 > arg_4_0.dead_player_destroy_time) then
		print("state dead despawn")

		if not var_4_2 then
			Managers.state.spawn:delayed_despawn(var_4_1)
		end

		arg_4_0.despawned = true

		if var_4_1.local_player then
			Managers.state.camera:clear_mood("knocked_down")
			Managers.state.camera:clear_mood("wounded")
			Managers.state.camera:clear_mood("bleeding_out")
		end
	end
end
