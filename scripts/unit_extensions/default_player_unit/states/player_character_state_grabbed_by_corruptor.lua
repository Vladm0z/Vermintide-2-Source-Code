-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_corruptor.lua

PlayerCharacterStateGrabbedByCorruptor = class(PlayerCharacterStateGrabbedByCorruptor, PlayerCharacterState)

local var_0_0 = POSITION_LOOKUP

PlayerCharacterStateGrabbedByCorruptor.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "grabbed_by_corruptor")

	arg_1_0.next_hanging_damage_time = 0
end

PlayerCharacterStateGrabbedByCorruptor.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.inventory_extension
	local var_2_1 = arg_2_0.career_extension

	CharacterStateHelper.stop_weapon_actions(var_2_0, "grabbed")
	CharacterStateHelper.stop_career_abilities(var_2_1, "grabbed")
	var_2_0:check_and_drop_pickups("grabbed_by_corruptor")
	CharacterStateHelper.play_animation_event(arg_2_1, "to_corruptor")
	CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person")

	local var_2_2 = arg_2_0.first_person_extension

	var_2_2:set_first_person_mode(false)

	if arg_2_0.ai_extension == nil then
		local var_2_3 = Managers.world:wwise_world(arg_2_0.world)
		local var_2_4, var_2_5 = WwiseWorld.trigger_event(var_2_3, "start_strangled_state", var_2_2:get_first_person_unit())

		arg_2_0.grabbed_by_corruptor_start_sound_event = "chaos_corruptor_corrupting"
		arg_2_0.grabbed_by_corruptor_stop_sound_event = "chaos_corruptor_corrupting_stop"

		WwiseUtils.trigger_unit_event(arg_2_0.world, arg_2_0.grabbed_by_corruptor_start_sound_event, arg_2_1, 0)
	end

	local var_2_6 = arg_2_0.status_extension

	arg_2_0.corruptor_status = CharacterStateHelper.corruptor_status(var_2_6)

	local var_2_7 = PlayerCharacterStateGrabbedByCorruptor.states

	if var_2_7[arg_2_0.corruptor_status].enter then
		var_2_7[arg_2_0.corruptor_status].enter(arg_2_0, arg_2_1)
	end

	ScriptUnit.extension(arg_2_1, "locomotion_system"):enable_rotation_towards_velocity(false)
	CharacterStateHelper.show_inventory_3p(arg_2_1, false, true, Managers.player.is_server, arg_2_0.inventory_extension)
end

PlayerCharacterStateGrabbedByCorruptor.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.first_person_extension
	local var_3_1 = arg_3_0.status_extension
	local var_3_2 = arg_3_0.locomotion_extension

	if not var_3_1:is_knocked_down() and not var_3_1:is_dead() then
		CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")
		var_3_0:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
		var_3_2:enable_script_driven_movement()
	end

	var_3_2:enable_rotation_towards_velocity(true)

	if arg_3_0.ai_extension == nil then
		local var_3_3 = Managers.world:wwise_world(arg_3_0.world)
		local var_3_4, var_3_5 = WwiseWorld.trigger_event(var_3_3, "stop_strangled_state", var_3_0:get_first_person_unit())

		WwiseUtils.trigger_unit_event(arg_3_0.world, arg_3_0.grabbed_by_corruptor_stop_sound_event, arg_3_1, 0)
	end

	local var_3_6 = arg_3_0.inventory_extension

	if var_3_6 then
		if var_3_6:get_wielded_slot_name() == "slot_career_skill_weapon" then
			var_3_6:wield_previous_weapon()
		else
			var_3_6:rewield_wielded_slot()
		end
	end
end

PlayerCharacterStateGrabbedByCorruptor.states = {
	chaos_corruptor_grabbed = {
		enter = function (arg_4_0, arg_4_1)
			local var_4_0 = ScriptUnit.extension(arg_4_1, "locomotion_system")
			local var_4_1 = arg_4_0.status_extension.corruptor_unit

			if Unit.alive(var_4_1) then
				local var_4_2 = var_0_0[var_4_1]
				local var_4_3 = var_0_0[arg_4_1]
				local var_4_4 = Vector3.normalize(var_4_2 - var_4_3)

				var_4_0:set_wanted_velocity(Vector3.zero())
				Unit.set_local_rotation(arg_4_1, 0, Quaternion.look(var_4_4))
				var_4_0:enable_rotation_towards_velocity(true, Quaternion.look(var_4_4), 1)
			end
		end,
		run = function (arg_5_0, arg_5_1)
			local var_5_0 = arg_5_0.status_extension.corruptor_unit

			if Unit.alive(var_5_0) then
				local var_5_1 = ScriptUnit.extension(arg_5_1, "locomotion_system")
				local var_5_2 = var_0_0[var_5_0]
				local var_5_3 = var_0_0[arg_5_1]
				local var_5_4 = Vector3.distance(var_5_2, var_5_3)
				local var_5_5 = var_5_2 - var_5_3
				local var_5_6 = Vector3.normalize(var_5_5) * 2

				var_5_1:set_maximum_upwards_velocity(var_5_6.z)
				var_5_1:set_forced_velocity(var_5_6)
			end
		end
	},
	chaos_corruptor_dragging = {
		enter = function (arg_6_0, arg_6_1)
			return
		end,
		run = function (arg_7_0, arg_7_1)
			local var_7_0 = arg_7_0.status_extension.corruptor_unit

			if Unit.alive(var_7_0) then
				local var_7_1 = ScriptUnit.extension(arg_7_1, "locomotion_system")

				var_7_1:set_disable_rotation_update()

				local var_7_2 = var_0_0[var_7_0]
				local var_7_3 = var_0_0[arg_7_1]
				local var_7_4 = Vector3.distance(var_7_2, var_7_3)
				local var_7_5 = Vector3.normalize(var_7_2 - var_7_3) * 4

				if var_7_4 > 1.5 then
					var_7_1:set_forced_velocity(var_7_5)
				else
					var_7_1:set_wanted_velocity(Vector3.zero())
				end
			end

			return true
		end
	},
	chaos_corruptor_released = {
		run = function (arg_8_0, arg_8_1)
			return
		end,
		enter = function (arg_9_0, arg_9_1)
			arg_9_0.locomotion_extension:enable_script_driven_movement()

			local var_9_0 = arg_9_0.status_extension
			local var_9_1 = arg_9_0.csm
			local var_9_2 = arg_9_0.status_extension

			if CharacterStateHelper.is_dead(var_9_2) then
				var_9_1:change_state("dead")
			elseif CharacterStateHelper.is_knocked_down(var_9_2) then
				local var_9_3 = arg_9_0.inventory_extension

				if var_9_3 and var_9_3:get_wielded_slot_name() == "slot_career_skill_weapon" then
					var_9_3:wield_previous_weapon()
				else
					var_9_3:rewield_wielded_slot()
				end

				var_9_1:change_state("knocked_down", arg_9_0.temp_params)
			else
				local var_9_4 = arg_9_0.inventory_extension

				if var_9_4 and var_9_4:get_wielded_slot_name() == "slot_career_skill_weapon" then
					var_9_4:wield_previous_weapon()
				else
					var_9_4:rewield_wielded_slot()
				end

				var_9_1:change_state("standing")
			end

			CharacterStateHelper.show_inventory_3p(arg_9_1, true, true, Managers.player.is_server, arg_9_0.inventory_extension)
		end
	}
}

PlayerCharacterStateGrabbedByCorruptor.update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = arg_10_0.csm
	local var_10_1 = arg_10_0.unit
	local var_10_2 = arg_10_0.input_extension
	local var_10_3 = arg_10_0.status_extension
	local var_10_4 = arg_10_0.first_person_extension
	local var_10_5 = CharacterStateHelper.corruptor_status(arg_10_0.status_extension)
	local var_10_6 = PlayerCharacterStateGrabbedByCorruptor.states
	local var_10_7 = arg_10_0.corruptor_status

	if var_10_5 ~= var_10_7 then
		if var_10_6[var_10_7].leave then
			var_10_6[var_10_7].leave(arg_10_0, var_10_1)
		end

		if var_10_6[var_10_5].enter then
			var_10_6[var_10_5].enter(arg_10_0, var_10_1)
		end

		arg_10_0.corruptor_status = var_10_5
	end

	if not var_10_6[var_10_5].run(arg_10_0, var_10_1) then
		return
	end

	CharacterStateHelper.look(var_10_2, arg_10_0.player.viewport_name, arg_10_0.first_person_extension, var_10_3, arg_10_0.inventory_extension)
end
