-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_in_hanging_cage.lua

PlayerCharacterStateInHangingCage = class(PlayerCharacterStateInHangingCage, PlayerCharacterState)

PlayerCharacterStateInHangingCage.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "in_hanging_cage")
end

PlayerCharacterStateInHangingCage.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "in_hanging_cage")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "in_hanging_cage")

	local var_2_0 = arg_2_7.cage_unit

	arg_2_0.cage_unit = var_2_0

	LocomotionUtils.enable_linked_movement(arg_2_0.world, arg_2_1, var_2_0, 0, Vector3.zero())

	local var_2_1 = true

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_1, arg_2_0.is_server, arg_2_0.inventory_extension)

	local var_2_2 = arg_2_7.animations
	local var_2_3 = var_2_2.idle

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_3)

	arg_2_0.falling_animation = var_2_2.falling
	arg_2_0.landing_animation = var_2_2.landing
	arg_2_0.state = "hanging"
end

PlayerCharacterStateInHangingCage.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.status_extension:set_in_hanging_cage(false)
end

PlayerCharacterStateInHangingCage.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.status_extension
	local var_4_2 = arg_4_0.state
	local var_4_3 = var_4_1.in_hanging_cage_state
	local var_4_4 = arg_4_0.cage_unit
	local var_4_5 = Unit.local_rotation(var_4_4, 0)

	Unit.set_local_rotation(arg_4_1, 0, var_4_5)

	if var_4_2 ~= var_4_3 then
		if var_4_3 == "falling" then
			local var_4_6 = arg_4_0.falling_animation

			if var_4_6 then
				CharacterStateHelper.play_animation_event(arg_4_1, var_4_6)
			end
		elseif var_4_3 == "landed" then
			local var_4_7 = arg_4_0.landing_animation

			CharacterStateHelper.play_animation_event(arg_4_1, var_4_7)
			LocomotionUtils.disable_linked_movement(arg_4_1)

			local var_4_8 = POSITION_LOOKUP[arg_4_1]
			local var_4_9 = arg_4_0.locomotion_extension

			var_4_9:teleport_to(var_4_8)
			var_4_9:enable_script_driven_movement()
			arg_4_0.health_extension:knock_down(arg_4_1)
			var_4_0:change_state("knocked_down", {
				already_in_ko_anim = true
			})
		end

		arg_4_0.state = var_4_3
	end
end
