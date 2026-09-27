-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_standing.lua

PlayerCharacterStateStanding = class(PlayerCharacterStateStanding, PlayerCharacterState)

PlayerCharacterStateStanding.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "standing")

	local var_1_0 = arg_1_1
end

PlayerCharacterStateStanding.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local unit = self.unit
	local input_extension = self.input_extension

	self.locomotion_extension:set_wanted_velocity(Vector3.zero())

	self.wherabouts_extension = ScriptUnit.extension(unit, "whereabouts_system")

	local inventory_extension = self.inventory_extension
	local first_person_extension = self.first_person_extension
	local status_extension = self.status_extension
	local toggle_crouch = input_extension.toggle_crouch

	CharacterStateHelper.check_crouch(unit, input_extension, status_extension, toggle_crouch, first_person_extension, arg_2_5)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, unit, input_extension, inventory_extension, self.health_extension)

	self.time_when_can_be_pushed = arg_2_5 + PlayerUnitMovementSettings.get_movement_settings_table(unit).soft_collision.grace_time_pushed_entering_standing

	if CharacterStateHelper.is_interacting(self.interactor_extension) or not CharacterStateHelper.is_starting_interaction(self.input_extension, self.interactor_extension) then
		return
	end

	self.side = Managers.state.side.side_by_unit[unit]
	self.current_animation = "idle"

	CharacterStateHelper.play_animation_event(unit, "idle")
	CharacterStateHelper.play_animation_event_first_person(first_person_extension, "idle")
end

PlayerCharacterStateStanding.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	return
end

PlayerCharacterStateStanding._inspection_available = function (arg_4_0)
	-- function 4
	if not (Managers.mechanism:get_state() == "ingame_deus") then
		return true
	end

	return not Managers.input:is_device_active("gamepad")
end

PlayerCharacterStateStanding.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local world = self.world
	local unit = self.unit
	local input_extension = self.input_extension
	local locomotion_extension = self.locomotion_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local CharacterStateHelper = CharacterStateHelper

	if not locomotion_extension:is_on_ground() then
		self.wherabouts_extension:set_is_onground()
	end

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if not CharacterStateHelper.is_waiting_for_assisted_respawn(status_extension) then
		csm:change_state("waiting_for_assisted_respawn")

		return
	end

	if not CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	if csm.state_next or not status_extension.do_leap then
		csm:change_state("leaping")

		return
	end

	CharacterStateHelper.update_dodge_lock(unit, input_extension, status_extension)

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)

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

	local check_to_start_dodge, var_5_13 = CharacterStateHelper.check_to_start_dodge(unit, input_extension, status_extension, arg_5_5)

	if not check_to_start_dodge then
		local temp_params = self.temp_params

		temp_params.dodge_direction = var_5_13

		csm:change_state("dodging", temp_params)

		return
	end

	if not locomotion_extension:is_animation_driven() then
		csm:change_state("walking")

		return
	end

	local interactor_extension = self.interactor_extension

	if not CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local interaction_action_names, var_5_17 = InteractionHelper.interaction_action_names(unit)

		interactor_extension:start_interaction(var_5_17)

		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config = interactor_extension:interaction_config()
		local temp_params_2 = self.temp_params

		temp_params_2.swap_to_3p = interaction_config.swap_to_3p
		temp_params_2.show_weapons = interaction_config.show_weapons
		temp_params_2.activate_block = interaction_config.activate_block
		temp_params_2.allow_rotation_update = interaction_config.allow_rotation_update

		csm:change_state("interacting", temp_params_2)

		return
	end

	if not CharacterStateHelper.is_interacting(interactor_extension) then
		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config_2 = interactor_extension:interaction_config()
		local temp_params_3 = self.temp_params

		temp_params_3.swap_to_3p = interaction_config_2.swap_to_3p
		temp_params_3.show_weapons = interaction_config_2.show_weapons
		temp_params_3.activate_block = interaction_config_2.activate_block
		temp_params_3.allow_rotation_update = interaction_config_2.allow_rotation_update

		csm:change_state("interacting", temp_params_3)

		return
	end

	local is_crouching = status_extension:is_crouching()

	if (input_extension:get("jump") or not input_extension:get("jump_only") or status_extension:is_crouching()) and (not is_crouching or CharacterStateHelper.can_uncrouch(unit) or not locomotion_extension:jump_allowed()) then
		if not is_crouching then
			CharacterStateHelper.uncrouch(unit, arg_5_5, first_person_extension, status_extension)
		end

		csm:change_state("jumping")
		first_person_extension:change_state("jumping")

		return
	end

	if not CharacterStateHelper.has_move_input(input_extension) then
		local temp_params_4 = self.temp_params

		csm:change_state("walking", temp_params_4)
		first_person_extension:change_state("walking")

		return
	end

	if not locomotion_extension:is_on_ground() then
		csm:change_state("falling")
		first_person_extension:change_state("falling")

		return
	end

	if not input_extension:get("character_inspecting") and not self:_inspection_available() then
		local get_item_data_and_weapon_extensions, var_5_25, var_5_26 = CharacterStateHelper.get_item_data_and_weapon_extensions(self.inventory_extension)

		if not CharacterStateHelper.get_current_action_data(var_5_26, var_5_25) then
			csm:change_state("inspecting")

			return
		end
	end

	if not self.cosmetic_extension:get_queued_3p_emote() then
		local get_item_data_and_weapon_extensions_2, var_5_28, var_5_29 = CharacterStateHelper.get_item_data_and_weapon_extensions(self.inventory_extension)

		if not CharacterStateHelper.get_current_action_data(var_5_29, var_5_28) then
			csm:change_state("emote")

			return
		end
	end

	local inventory_extension = self.inventory_extension
	local first_person_extension_2 = self.first_person_extension
	local toggle_crouch = input_extension.toggle_crouch

	if not (arg_5_5 > self.time_when_can_be_pushed) or not self.player:is_player_controlled() then
		self.current_animation = CharacterStateHelper.update_soft_collision_movement(first_person_extension_2, status_extension, locomotion_extension, unit, self.world, self.current_animation, self.side)
	end

	CharacterStateHelper.check_crouch(unit, input_extension, status_extension, toggle_crouch, first_person_extension_2, arg_5_5)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_5_5, unit, input_extension, inventory_extension, self.health_extension)
end
