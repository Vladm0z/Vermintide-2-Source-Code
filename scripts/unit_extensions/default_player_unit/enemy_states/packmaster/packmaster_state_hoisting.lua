-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_hoisting.lua

PackmasterStateHoisting = class(PackmasterStateHoisting, EnemyCharacterState)

function PackmasterStateHoisting.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "packmaster_hoisting")

	local var_1_0 = arg_1_1

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
end

function PackmasterStateHoisting.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0._hosting_end_time = arg_2_5 + BreedActions.skaven_pack_master.hoist.hoist_anim_length
	arg_2_0._drag_target_unit = arg_2_7
	arg_2_0._unit = arg_2_1

	local var_2_0 = arg_2_0._drag_target_unit
	local var_2_1 = Vector3(0, 0, 0)

	arg_2_0._locomotion_extension:set_forced_velocity(var_2_1)
	arg_2_0._locomotion_extension:set_wanted_velocity(Vector3.zero())
	CharacterStateHelper.change_camera_state(arg_2_0._player, "follow_third_person")
	StatusUtils.set_grabbed_by_pack_master_network("pack_master_hoisting", var_2_0, true, arg_2_1)
	arg_2_0:set_breed_action("hoist")
end

function PackmasterStateHoisting.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0._drag_target_unit
	local var_3_1 = arg_3_0._first_person_extension

	if Unit.alive(var_3_0) then
		-- block empty
	end

	arg_3_0._drag_target_unit = nil

	CharacterStateHelper.change_camera_state(arg_3_0._player, "follow")
	var_3_1:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	var_3_1:set_wanted_player_height("stand", arg_3_5)

	if arg_3_0._action_aborted then
		return
	end

	local var_3_2 = true

	if not arg_3_0._status_extension:get_unarmed() then
		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_2, arg_3_0._is_server, arg_3_0._inventory_extension)
		var_3_1:unhide_weapons("catapulted")
	else
		CharacterStateHelper.play_animation_event(arg_3_1, "to_unarmed")
		CharacterStateHelper.play_animation_event_first_person(var_3_1, "to_unarmed")
		var_3_1:animation_set_variable("armed", 0)
		CharacterStateHelper.show_inventory_3p(arg_3_1, false, var_3_2, arg_3_0._is_server, arg_3_0._inventory_extension)
	end

	arg_3_0:set_breed_action("n/a")

	local var_3_3 = arg_3_0._career_extension
	local var_3_4 = var_3_3:ability_id("equip")

	var_3_3:ability_by_id(var_3_4):unfreeze()
end

function PackmasterStateHoisting.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = arg_4_0._inventory_extension
	local var_4_2 = ScriptUnit.extension(arg_4_1, "input_system")
	local var_4_3 = arg_4_0._status_extension
	local var_4_4 = arg_4_0._drag_target_unit
	local var_4_5

	if var_4_4 and HEALTH_ALIVE[var_4_4] then
		if ScriptUnit.extension(var_4_4, "status_system"):is_dead() then
			local var_4_6 = arg_4_0._temp_params

			var_4_0:change_state("walking", var_4_6)

			return
		end
	else
		local var_4_7 = arg_4_0._temp_params

		var_4_0:change_state("walking", var_4_7)

		return
	end

	if CharacterStateHelper.is_dead(var_4_3) then
		arg_4_0:release_dragged_target()
		var_4_0:change_state("dead")

		return true
	end

	if CharacterStateHelper.is_staggered(var_4_3) then
		arg_4_0:release_dragged_target()
		var_4_0:change_state("staggered")

		return true
	end

	if not arg_4_0._locomotion_extension:is_on_ground() then
		arg_4_0:release_dragged_target()

		local var_4_8 = arg_4_0._temp_params

		var_4_0:change_state("walking", var_4_8)

		return true
	end

	if not var_4_2 then
		return
	end

	if arg_4_5 > arg_4_0._hosting_end_time then
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_hanging", var_4_4, true, arg_4_1)
		var_4_3:set_packmaster_released()
		var_4_3:set_unarmed(true)

		local var_4_9 = arg_4_0._temp_params
		local var_4_10 = ScriptUnit.extension(arg_4_1, "career_system")

		var_4_0:change_state("standing", var_4_9)
	end

	arg_4_0._locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_4_2, arg_4_0._player.viewport_name, arg_4_0._first_person_extension, var_4_3, var_4_1)
end

function PackmasterStateHoisting.release_dragged_target(arg_5_0)
	local var_5_0 = arg_5_0._status_extension
	local var_5_1 = arg_5_0._first_person_extension
	local var_5_2 = arg_5_0._drag_target_unit
	local var_5_3 = ScriptUnit.extension(var_5_2, "status_system")

	CharacterStateHelper.show_inventory_3p(arg_5_0._unit, true, true, Managers.player.is_server, arg_5_0._inventory_extension)
	var_5_1:unhide_weapons("catapulted")
	StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", var_5_2, false, arg_5_0._unit)
	var_5_0:set_packmaster_released()
end
