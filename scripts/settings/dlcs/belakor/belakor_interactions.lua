-- chunkname: @scripts/settings/dlcs/belakor/belakor_interactions.lua

local var_0_0 = table.clone(InteractionDefinitions.smartobject)

var_0_0.config = {
	block_other_interactions = true,
	hud_verb = "player_interaction",
	hold = true,
	swap_to_3p = false,
	activate_block = true,
	animation = "interaction_start"
}

var_0_0.server.start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = ScriptUnit.has_extension(arg_1_2, "deus_belakor_locus_system")

	if var_1_0 then
		local var_1_1 = var_1_0:get_interaction_length()

		arg_1_3.done_time = arg_1_5 + var_1_1
		arg_1_3.duration = var_1_1

		local var_1_2 = Unit.get_data(arg_1_2, "interaction_data", "apply_buff")

		if var_1_2 then
			arg_1_3.apply_buff = var_1_2
		end

		local var_1_3 = Unit.world_position(arg_1_1, 0) - Unit.world_position(arg_1_2, 0)

		arg_1_3.start_offset = Vector3Box(var_1_3)

		var_1_0:on_server_start_interact(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	end
end

var_0_0.server.stop = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	if arg_2_6 == InteractionResult.SUCCESS then
		local var_2_0 = ScriptUnit.has_extension(arg_2_2, "deus_belakor_locus_system")

		if var_2_0 then
			var_2_0:on_server_interact(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
		end
	end
end

var_0_0.client.start = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = ScriptUnit.has_extension(arg_3_2, "deus_belakor_locus_system")

	if var_3_0 then
		arg_3_3.start_time = arg_3_5

		local var_3_1 = var_3_0:get_interaction_length()

		arg_3_3.duration = var_3_1

		local var_3_2 = arg_3_4.animation
		local var_3_3 = Unit.get_data(arg_3_2, "interaction_data", "interactor_animation_time_variable")
		local var_3_4 = ScriptUnit.extension(arg_3_1, "inventory_system")
		local var_3_5 = ScriptUnit.extension(arg_3_1, "career_system")

		if var_3_2 then
			local var_3_6 = Unit.animation_find_variable(arg_3_1, var_3_3)

			Unit.animation_set_variable(arg_3_1, var_3_6, var_3_1)
			Unit.animation_event(arg_3_1, var_3_2)
		end

		local var_3_7 = Unit.get_data(arg_3_2, "interaction_data", "interactable_animation")
		local var_3_8 = Unit.get_data(arg_3_2, "interaction_data", "interactable_animation_time_variable")

		if var_3_7 then
			local var_3_9 = Unit.animation_find_variable(arg_3_2, var_3_8)

			Unit.animation_set_variable(arg_3_2, var_3_9, var_3_1)
			Unit.animation_event(arg_3_2, var_3_7)
		end

		CharacterStateHelper.stop_weapon_actions(var_3_4, "interacting")
		CharacterStateHelper.stop_career_abilities(var_3_5, "interacting")
		Unit.set_data(arg_3_2, "interaction_data", "being_used", true)

		if not arg_3_3.is_husk and arg_3_4.rotate_toward_interactable then
			local var_3_10 = Unit.local_position(arg_3_2, 0) - POSITION_LOOKUP[arg_3_1]
			local var_3_11 = Quaternion.look(var_3_10, Vector3.up())
			local var_3_12 = ScriptUnit.extension(arg_3_1, "locomotion_system")

			var_3_12:enable_script_driven_ladder_transition_movement()
			var_3_12:enable_rotation_towards_velocity(false, var_3_11, 0.25)
		end
	end
end

var_0_0.client.get_progress = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.duration or 0

	if var_4_0 == 0 then
		return 0
	end

	return arg_4_0.start_time == nil and 0 or math.min(1, (arg_4_2 - arg_4_0.start_time) / var_4_0)
end

var_0_0.client.stop = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	Unit.animation_event(arg_5_1, "interaction_end")

	if arg_5_6 == InteractionResult.SUCCESS and not arg_5_3.is_husk then
		local var_5_0 = ScriptUnit.has_extension(arg_5_2, "deus_belakor_locus_system")

		if var_5_0 then
			var_5_0:on_client_interact(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
		end
	end

	if not arg_5_3.is_husk and arg_5_4.rotate_toward_interactable then
		local var_5_1 = ScriptUnit.extension(arg_5_1, "locomotion_system")

		var_5_1:enable_script_driven_movement()
		var_5_1:enable_rotation_towards_velocity(true)
	end
end

var_0_0.client.hud_description = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = ScriptUnit.has_extension(arg_6_0, "deus_belakor_locus_system")

	return Unit.get_data(arg_6_0, "interaction_data", "hud_description"), arg_6_3 or var_6_0:get_interaction_action()
end

var_0_0.client.can_interact = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if Managers.mechanism:current_mechanism_name() ~= "deus" or Managers.mechanism:game_mechanism():get_state() ~= "ingame_deus" then
		return false
	end

	local var_7_0 = ScriptUnit.has_extension(arg_7_1, "deus_belakor_locus_system")

	if var_7_0 then
		return var_7_0:can_interact()
	end

	return false
end

InteractionDefinitions.deus_belakor_locus_pre_crystal = var_0_0
InteractionDefinitions.deus_belakor_locus_with_crystal = table.clone(var_0_0)

InteractionDefinitions.deus_belakor_locus_with_crystal.server.update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	local var_8_0 = ScriptUnit.has_extension(arg_8_2, "deus_belakor_locus_system")

	if not var_8_0 or not var_8_0:can_interact_validate(arg_8_1) then
		return InteractionResult.FAILURE
	end

	if arg_8_6 > arg_8_3.done_time then
		return InteractionResult.SUCCESS
	end

	return InteractionResult.ONGOING
end

InteractionDefinitions.deus_belakor_locus_with_crystal.config.swap_to_3p = true
InteractionDefinitions.deus_belakor_locus_with_crystal.config.allow_rotation_update = true
InteractionDefinitions.deus_belakor_locus_with_crystal.config.show_weapons = true
InteractionDefinitions.deus_belakor_locus_with_crystal.config.animation = "insert_locus_crystal"
InteractionDefinitions.deus_belakor_locus_with_crystal.config.rotate_toward_interactable = true
