-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_jumping.lua

PlayerCharacterStateJumping = class(PlayerCharacterStateJumping, PlayerCharacterState)

PlayerCharacterStateJumping.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "jumping")

	local var_1_0 = arg_1_1
end

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerCharacterStateJumping.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self.temp_params)

	local player = self.player
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension
	local inventory_extension = self.inventory_extension
	local first_person_extension = self.first_person_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local initial_vertical_speed = get_movement_settings_table.jump.initial_vertical_speed

	if not script_data.use_super_jumps then
		initial_vertical_speed = initial_vertical_speed * 2
	end

	locomotion_extension:set_maximum_upwards_velocity(initial_vertical_speed)
	locomotion_extension:force_on_ground(false)

	local current_velocity = locomotion_extension:current_velocity()
	local var_2_9

	if not arg_2_7.post_dodge_jump then
		current_velocity = current_velocity * PlayerUnitMovementSettings.post_dodge_jump_velocity_scale
		initial_vertical_speed = initial_vertical_speed * PlayerUnitMovementSettings.post_dodge_jump_speed_scale
	end

	if not arg_2_7.backward_jump then
		current_velocity = current_velocity * PlayerUnitMovementSettings.backwards_jump_velocity_scale
	end

	local length = Vector3.length(current_velocity)

	if length > PlayerUnitMovementSettings.move_speed then
		current_velocity = current_velocity * (PlayerUnitMovementSettings.move_speed / length)
	end

	if arg_2_6 == "climbing_ladder" then
		local ladder_unit = arg_2_7.ladder_unit
		local world_rotation = Unit.world_rotation(ladder_unit, 0)

		var_2_9 = Quaternion.forward(world_rotation) * get_movement_settings_table.ladder.jump_backwards_force
		self.temp_params.shaking_ladder_unit = arg_2_7.shaking_ladder_unit
	else
		var_2_9 = Vector3(current_velocity.x, current_velocity.y, initial_vertical_speed)
	end

	locomotion_extension:set_forced_velocity(var_2_9)
	locomotion_extension:set_wanted_velocity(var_2_9)

	local var_2_13
	local get_wielded_slot_item_template = inventory_extension:get_wielded_slot_item_template()

	self._play_fp_anim = not get_wielded_slot_item_template and get_wielded_slot_item_template.jump_anim_enabled_1p

	local flag

	flag = not CharacterStateHelper.has_move_input(input_extension) and "jump_fwd" and "jump_idle"

	CharacterStateHelper.play_animation_event(arg_2_1, flag)

	if not self._play_fp_anim then
		CharacterStateHelper.play_animation_event_first_person(first_person_extension, flag)
	end

	first_person_extension:play_camera_effect_sequence("jump", arg_2_5)
	CharacterStateHelper.look(input_extension, player.viewport_name, first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, input_extension, inventory_extension, self.health_extension)
	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	local z = POSITION_LOOKUP[arg_2_1].z

	self.status_extension:set_falling_height(z)
	Unit.flow_event(arg_2_1, "sfx_player_jump")
end

PlayerCharacterStateJumping.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local input_extension = self.input_extension

	self.locomotion_extension:reset_maximum_upwards_velocity()

	if not (arg_3_6 == "walking" or arg_3_6 ~= "standing") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	elseif not (not arg_3_6 and arg_3_6 == "falling") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end

	if not arg_3_6 and arg_3_6 == "falling" or not Managers.state.network:game() then
		CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
		CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")

		if not self._play_fp_anim then
			CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, "to_onground")
		end
	end
end

PlayerCharacterStateJumping.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local locomotion_extension = self.locomotion_extension

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	if not CharacterStateHelper.is_pushed(status_extension) then
		status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = status_extension:hit_react_type() .. "_push"

		csm:change_state("stunned", pushed)

		return
	end

	if not CharacterStateHelper.is_charged(status_extension) then
		local charged = get_movement_settings_table.charged_settings.charged

		charged.hit_react_type = "charged"

		csm:change_state("charged", charged)

		return
	end

	if not CharacterStateHelper.is_block_broken(status_extension) then
		status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		csm:change_state("stunned", parry_broken)

		return
	end

	if not locomotion_extension:is_on_ground() then
		csm:change_state("walking")
		first_person_extension:change_state("walking")

		return
	end

	if not (csm.state_next or not (locomotion_extension:current_velocity().z <= 0)) then
		csm:change_state("falling", self.temp_params)
		first_person_extension:change_state("falling")

		return
	end

	local inventory_extension = self.inventory_extension
	local num = math.clamp(get_movement_settings_table.move_speed, 0, PlayerUnitMovementSettings.move_speed) * status_extension:current_move_speed_multiplier() * get_movement_settings_table.player_speed_scale * get_movement_settings_table.player_air_speed_scale

	CharacterStateHelper.move_in_air(self.first_person_extension, input_extension, self.locomotion_extension, num, arg_4_1)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_4_5, arg_4_1, input_extension, inventory_extension, self.health_extension)

	local interactor_extension = self.interactor_extension

	if not CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local interaction_action_names, var_4_13 = InteractionHelper.interaction_action_names(arg_4_1)

		interactor_extension:start_interaction(var_4_13)

		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config = interactor_extension:interaction_config()
		local temp_params = self.temp_params

		temp_params.swap_to_3p = interaction_config.swap_to_3p
		temp_params.show_weapons = interaction_config.show_weapons
		temp_params.activate_block = interaction_config.activate_block
		temp_params.allow_rotation_update = interaction_config.allow_rotation_update

		csm:change_state("interacting", temp_params)

		return
	end

	if not CharacterStateHelper.is_interacting(interactor_extension) then
		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config_2 = interactor_extension:interaction_config()
		local temp_params_2 = self.temp_params

		temp_params_2.swap_to_3p = interaction_config_2.swap_to_3p
		temp_params_2.show_weapons = interaction_config_2.show_weapons
		temp_params_2.activate_block = interaction_config_2.activate_block
		temp_params_2.allow_rotation_update = interaction_config_2.allow_rotation_update

		csm:change_state("interacting", temp_params_2)

		return
	end
end
