-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_in_vortex.lua

PlayerCharacterStateInVortex = class(PlayerCharacterStateInVortex, PlayerCharacterState)

PlayerCharacterStateInVortex.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "in_vortex")
end

PlayerCharacterStateInVortex.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	self.game = Managers.state.network:game()

	local unit_storage = self.unit_storage
	local in_vortex_unit = self.status_extension.in_vortex_unit
	local go_id = unit_storage:go_id(in_vortex_unit)
	local extension = ScriptUnit.extension(in_vortex_unit, "ai_supplementary_system")
	local vortex_template = extension.vortex_template

	self.vortex_unit = in_vortex_unit
	self.vortex_unit_go_id = go_id
	self.vortex_owner_unit = extension._owner_unit

	local player_actions_allowed = vortex_template.player_actions_allowed

	self.vortex_full_inner_radius = vortex_template.full_inner_radius
	self.ascend_speed = vortex_template.player_ascend_speed
	self.rotation_speed = vortex_template.player_rotation_speed
	self.radius_change_speed = vortex_template.player_radius_change_speed
	self.player_actions_allowed = player_actions_allowed
	self.vortex_max_height = vortex_template.max_height

	self.interactor_extension:abort_interaction()

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:set_maximum_upwards_velocity(10)
	locomotion_extension:enable_drag(false)

	local first_person_extension = self.first_person_extension

	self.screenspace_effect_particle_id = first_person_extension:create_screen_particles("fx/screenspace_inside_plague_vortex")

	first_person_extension:play_hud_sound_event("sfx_player_in_vortex_true")

	local var_2_8

	if not player_actions_allowed then
		var_2_8 = "idle"
	else
		local inventory_extension = self.inventory_extension
		local career_extension = self.career_extension

		CharacterStateHelper.stop_weapon_actions(inventory_extension, "stunned")
		CharacterStateHelper.stop_career_abilities(career_extension, "stunned")

		local str = "backward"

		var_2_8 = PlayerUnitMovementSettings.catapulted.directions[str].start_animation

		first_person_extension:hide_weapons("in_vortex")

		local flag = false

		CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self.is_server, inventory_extension)
	end

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_8)
	CharacterStateHelper.play_animation_event_first_person(first_person_extension, var_2_8)
end

PlayerCharacterStateInVortex.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.vortex_unit_go_id = nil
	self.vortex_full_inner_radius = nil

	if not arg_3_6 then
		local locomotion_extension = self.locomotion_extension

		locomotion_extension:reset_maximum_upwards_velocity()
		locomotion_extension:enable_drag(true)

		local first_person_extension = self.first_person_extension

		first_person_extension:stop_spawning_screen_particles(self.screenspace_effect_particle_id)
		first_person_extension:play_hud_sound_event("sfx_player_in_vortex_false")

		self.screenspace_effect_particle_id = nil

		local vortex_owner_unit

		if not Unit.alive(self.vortex_owner_unit) then
			vortex_owner_unit = self.vortex_owner_unit

			if not vortex_owner_unit then
				-- Nothing
			end
		end

		vortex_owner_unit = arg_3_1

		::label_3_0::

		Managers.state.entity:system("buff_system"):add_buff(arg_3_1, "vortex_base", vortex_owner_unit)

		if not self.player_actions_allowed then
			first_person_extension:unhide_weapons("in_vortex")

			if not Managers.state.network:game() then
				local flag = false

				CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self.is_server, self.inventory_extension)
				CharacterStateHelper.play_animation_event(arg_3_1, "airtime_end")
			end
		end
	end

	self.vortex_owner_unit = nil
end

PlayerCharacterStateInVortex.update_spin_velocity = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local game = self.game
	local game_object_field = GameSession.game_object_field(game, arg_4_3, "inner_radius_percentage")
	local num = self.vortex_full_inner_radius * game_object_field * 0.75
	local ascend_speed = self.ascend_speed
	local rotation_speed = self.rotation_speed
	local radius_change_speed = self.radius_change_speed
	local var_4_6 = POSITION_LOOKUP[arg_4_1]
	local var_4_7 = POSITION_LOOKUP[arg_4_2]
	local get_vortex_spin_velocity, var_4_9, var_4_10 = LocomotionUtils.get_vortex_spin_velocity(var_4_6, var_4_7, num, Vector3.up(), rotation_speed, radius_change_speed, ascend_speed, arg_4_4)
	local game_object_field_2 = GameSession.game_object_field(game, arg_4_3, "height_percentage")

	if var_4_10 > self.vortex_max_height * game_object_field_2 then
		get_vortex_spin_velocity.z = 0
	end

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:set_forced_velocity(get_vortex_spin_velocity)
	locomotion_extension:set_wanted_velocity(get_vortex_spin_velocity)
end

PlayerCharacterStateInVortex.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local is_catapulted, var_5_4 = CharacterStateHelper.is_catapulted(status_extension)

	if not is_catapulted then
		local tbl = {
			sound_event = "Play_enemy_sorcerer_vortex_throw_player",
			direction = var_5_4
		}

		csm:change_state("catapulted", tbl)

		return
	end

	if not status_extension:is_valid_vortex_target() then
		CharacterStateHelper.do_common_state_transitions(status_extension, csm)

		return
	end

	if not CharacterStateHelper.is_in_vortex(status_extension) then
		if not CharacterStateHelper.is_colliding_down(arg_5_1) then
			csm:change_state("standing")
		else
			csm:change_state("falling")
		end

		return
	end

	local input_extension = self.input_extension
	local interactor_extension = self.interactor_extension
	local player_actions_allowed = self.player_actions_allowed

	if not player_actions_allowed and not CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) and not interactor_extension:allow_movement_during_interaction() then
		local interaction_action_names, var_5_10 = InteractionHelper.interaction_action_names(arg_5_1)

		interactor_extension:start_interaction(var_5_10)
	end

	if not Unit.alive(self.vortex_unit) then
		self:update_spin_velocity(arg_5_1, self.vortex_unit, self.vortex_unit_go_id, arg_5_3)
	end

	local viewport_name = self.player.viewport_name
	local inventory_extension = self.inventory_extension

	CharacterStateHelper.look(input_extension, viewport_name, first_person_extension, status_extension, inventory_extension)

	if not player_actions_allowed then
		local health_extension = self.health_extension

		CharacterStateHelper.update_weapon_actions(arg_5_5, arg_5_1, input_extension, inventory_extension, health_extension)
	end
end
