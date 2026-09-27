-- chunkname: @scripts/settings/dlcs/belakor/belakor_interactions.lua

local clone = table.clone(InteractionDefinitions.smartobject)

clone.config = {
	block_other_interactions = true,
	hud_verb = "player_interaction",
	hold = true,
	swap_to_3p = false,
	activate_block = true,
	animation = "interaction_start"
}

clone.server.start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local has_extension = ScriptUnit.has_extension(arg_1_2, "deus_belakor_locus_system")

	if not has_extension then
		local get_interaction_length = has_extension:get_interaction_length()

		arg_1_3.done_time = arg_1_5 + get_interaction_length
		arg_1_3.duration = get_interaction_length

		local get_data = Unit.get_data(arg_1_2, "interaction_data", "apply_buff")

		if not get_data then
			arg_1_3.apply_buff = get_data
		end

		local num = Unit.world_position(arg_1_1, 0) - Unit.world_position(arg_1_2, 0)

		arg_1_3.start_offset = Vector3Box(num)

		has_extension:on_server_start_interact(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	end
end

clone.server.stop = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	if arg_2_6 == InteractionResult.SUCCESS then
		local has_extension = ScriptUnit.has_extension(arg_2_2, "deus_belakor_locus_system")

		if not has_extension then
			has_extension:on_server_interact(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
		end
	end
end

clone.client.start = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local has_extension = ScriptUnit.has_extension(arg_3_2, "deus_belakor_locus_system")

	if not has_extension then
		arg_3_3.start_time = arg_3_5

		local get_interaction_length = has_extension:get_interaction_length()

		arg_3_3.duration = get_interaction_length

		local animation = arg_3_4.animation
		local get_data = Unit.get_data(arg_3_2, "interaction_data", "interactor_animation_time_variable")
		local extension = ScriptUnit.extension(arg_3_1, "inventory_system")
		local extension_2 = ScriptUnit.extension(arg_3_1, "career_system")

		if not animation then
			local animation_find_variable = Unit.animation_find_variable(arg_3_1, get_data)

			Unit.animation_set_variable(arg_3_1, animation_find_variable, get_interaction_length)
			Unit.animation_event(arg_3_1, animation)
		end

		local get_data_2 = Unit.get_data(arg_3_2, "interaction_data", "interactable_animation")
		local get_data_3 = Unit.get_data(arg_3_2, "interaction_data", "interactable_animation_time_variable")

		if not get_data_2 then
			local animation_find_variable_2 = Unit.animation_find_variable(arg_3_2, get_data_3)

			Unit.animation_set_variable(arg_3_2, animation_find_variable_2, get_interaction_length)
			Unit.animation_event(arg_3_2, get_data_2)
		end

		CharacterStateHelper.stop_weapon_actions(extension, "interacting")
		CharacterStateHelper.stop_career_abilities(extension_2, "interacting")
		Unit.set_data(arg_3_2, "interaction_data", "being_used", true)

		if arg_3_3.is_husk or not arg_3_4.rotate_toward_interactable then
			local num = Unit.local_position(arg_3_2, 0) - POSITION_LOOKUP[arg_3_1]
			local look = Quaternion.look(num, Vector3.up())
			local extension_3 = ScriptUnit.extension(arg_3_1, "locomotion_system")

			extension_3:enable_script_driven_ladder_transition_movement()
			extension_3:enable_rotation_towards_velocity(false, look, 0.25)
		end
	end
end

clone.client.get_progress = function (self, arg_4_1, arg_4_2)
	-- function 4
	local duration = self.duration

	duration = duration or 0

	if duration == 0 then
		return 0
	end

	local flag

	flag = self.start_time ~= nil or not 0 or math.min(1, (arg_4_2 - self.start_time) / duration)

	return flag
end

clone.client.stop = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	Unit.animation_event(arg_5_1, "interaction_end")

	if not (arg_5_6 ~= InteractionResult.SUCCESS or arg_5_3.is_husk) then
		local has_extension = ScriptUnit.has_extension(arg_5_2, "deus_belakor_locus_system")

		if not has_extension then
			has_extension:on_client_interact(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
		end
	end

	if arg_5_3.is_husk or not arg_5_4.rotate_toward_interactable then
		local extension = ScriptUnit.extension(arg_5_1, "locomotion_system")

		extension:enable_script_driven_movement()
		extension:enable_rotation_towards_velocity(true)
	end
end

clone.client.hud_description = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local has_extension = ScriptUnit.has_extension(arg_6_0, "deus_belakor_locus_system")

	return Unit.get_data(arg_6_0, "interaction_data", "hud_description"), arg_6_3 or has_extension:get_interaction_action()
end

clone.client.can_interact = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not (Managers.mechanism:current_mechanism_name() ~= "deus" or Managers.mechanism:game_mechanism():get_state() == "ingame_deus") then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_7_1, "deus_belakor_locus_system")

	if not has_extension then
		return has_extension:can_interact()
	end

	return false
end

InteractionDefinitions.deus_belakor_locus_pre_crystal = clone
InteractionDefinitions.deus_belakor_locus_with_crystal = table.clone(clone)

InteractionDefinitions.deus_belakor_locus_with_crystal.server.update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	local has_extension = ScriptUnit.has_extension(arg_8_2, "deus_belakor_locus_system")

	if not (not has_extension and has_extension:can_interact_validate(arg_8_1)) then
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
