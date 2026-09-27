-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_in_vortex.lua

EnemyCharacterStateInVortex = class(EnemyCharacterStateInVortex, EnemyCharacterState)

EnemyCharacterStateInVortex.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterState.init(arg_1_0, arg_1_1, "in_vortex")
end

EnemyCharacterStateInVortex.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	self.game = Managers.state.network:game()

	local _unit_storage = self._unit_storage
	local in_vortex_unit = self._status_extension.in_vortex_unit
	local go_id = _unit_storage:go_id(in_vortex_unit)
	local has_extension = ScriptUnit.has_extension(in_vortex_unit, "ai_supplementary_system")
	local has_extension_2 = ScriptUnit.has_extension(in_vortex_unit, "area_damage_system")
	local var_2_5

	if not has_extension then
		var_2_5 = has_extension.vortex_template
	elseif not has_extension_2 then
		var_2_5 = has_extension_2.vortex_template
	else
		error("[EnemyCharacterStateInVortex] Could not deduce vortex template.")
	end

	self.vortex_unit = in_vortex_unit
	self.vortex_unit_go_id = go_id

	local player_actions_allowed = var_2_5.player_actions_allowed

	self.vortex_full_inner_radius = var_2_5.full_inner_radius
	self.keep_enemies_within_radius = var_2_5.keep_enemies_within_radius
	self.ascend_speed = var_2_5.player_ascend_speed
	self.rotation_speed = var_2_5.player_rotation_speed
	self.radius_change_speed = var_2_5.player_radius_change_speed
	self.player_actions_allowed = player_actions_allowed

	local max_height_player_target = var_2_5.max_height_player_target

	max_height_player_target = max_height_player_target or var_2_5.max_height
	self.vortex_max_height = max_height_player_target
	self.post_vortex_buff = var_2_5.post_vortex_buff

	self._interactor_extension:abort_interaction()

	local _locomotion_extension = self._locomotion_extension

	_locomotion_extension:set_maximum_upwards_velocity(10)
	_locomotion_extension:enable_drag(false)

	local _first_person_extension = self._first_person_extension

	self.screenspace_effect_particle_id = _first_person_extension:create_screen_particles("fx/screenspace_inside_plague_vortex")

	_first_person_extension:play_hud_sound_event("sfx_player_in_vortex_true")

	local var_2_10

	if not player_actions_allowed then
		var_2_10 = "idle"
	else
		local _inventory_extension = self._inventory_extension
		local _career_extension = self._career_extension

		CharacterStateHelper.stop_weapon_actions(_inventory_extension, "stunned")
		CharacterStateHelper.stop_career_abilities(_career_extension, "stunned")

		var_2_10 = "idle"

		_first_person_extension:hide_weapons("in_vortex")

		local flag = false

		CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self._is_server, _inventory_extension)
	end

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_10)
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_2_10)
end

EnemyCharacterStateInVortex.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.vortex_unit_go_id = nil
	self.vortex_full_inner_radius = nil

	if not arg_3_6 then
		local _locomotion_extension = self._locomotion_extension

		_locomotion_extension:reset_maximum_upwards_velocity()
		_locomotion_extension:enable_drag(true)

		local _first_person_extension = self._first_person_extension

		_first_person_extension:stop_spawning_screen_particles(self.screenspace_effect_particle_id)
		_first_person_extension:play_hud_sound_event("sfx_player_in_vortex_false")

		self.screenspace_effect_particle_id = nil

		if not self.post_vortex_buff then
			Managers.state.entity:system("buff_system"):add_buff(arg_3_1, self.post_vortex_buff, arg_3_1)
		end

		if not self.player_actions_allowed then
			_first_person_extension:unhide_weapons("in_vortex")

			if not Managers.state.network:game() then
				local flag = false

				CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self._is_server, self._inventory_extension)
				CharacterStateHelper.play_animation_event(arg_3_1, "idle")
			end
		end
	end
end

EnemyCharacterStateInVortex.update_spin_velocity = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local game = self.game
	local game_object_field = GameSession.game_object_field(game, arg_4_3, "inner_radius_percentage")
	local keep_enemies_within_radius = self.keep_enemies_within_radius

	keep_enemies_within_radius = keep_enemies_within_radius or self.vortex_full_inner_radius * 0.75

	local num = keep_enemies_within_radius * game_object_field
	local ascend_speed = self.ascend_speed
	local rotation_speed = self.rotation_speed
	local radius_change_speed = self.radius_change_speed
	local var_4_7 = POSITION_LOOKUP[arg_4_1]
	local var_4_8 = POSITION_LOOKUP[arg_4_2]
	local get_vortex_spin_velocity, var_4_10, var_4_11 = LocomotionUtils.get_vortex_spin_velocity(var_4_7, var_4_8, num, Vector3.up(), rotation_speed, radius_change_speed, ascend_speed, arg_4_4)
	local game_object_field_2 = GameSession.game_object_field(game, arg_4_3, "height_percentage")

	if var_4_11 > self.vortex_max_height * game_object_field_2 then
		get_vortex_spin_velocity.z = 0
	end

	local _locomotion_extension = self._locomotion_extension

	_locomotion_extension:set_forced_velocity(get_vortex_spin_velocity)
	_locomotion_extension:set_wanted_velocity(get_vortex_spin_velocity)
end

EnemyCharacterStateInVortex.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local _csm = self._csm
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local is_catapulted, var_5_4 = CharacterStateHelper.is_catapulted(_status_extension)

	if not is_catapulted then
		local tbl = {
			sound_event = "Play_enemy_sorcerer_vortex_throw_player",
			direction = var_5_4
		}

		_csm:change_state("catapulted", tbl)

		return
	end

	if not _status_extension:is_valid_vortex_target() then
		CharacterStateHelper.do_common_state_transitions(_status_extension, _csm)

		return
	end

	if not CharacterStateHelper.is_in_vortex(_status_extension) then
		if not CharacterStateHelper.is_colliding_down(arg_5_1) then
			_csm:change_state("standing")
		else
			_csm:change_state("falling")
		end

		return
	end

	local _input_extension = self._input_extension
	local _interactor_extension = self._interactor_extension

	if not self.player_actions_allowed and not CharacterStateHelper.is_starting_interaction(_input_extension, _interactor_extension) and not _interactor_extension:allow_movement_during_interaction() then
		local interaction_action_names, var_5_9 = InteractionHelper.interaction_action_names(arg_5_1)

		_interactor_extension:start_interaction(var_5_9)
	end

	if not Unit.alive(self.vortex_unit) then
		self:update_spin_velocity(arg_5_1, self.vortex_unit, self.vortex_unit_go_id, arg_5_3)
	end

	local viewport_name = self._player.viewport_name
	local _inventory_extension = self._inventory_extension

	CharacterStateHelper.look(_input_extension, viewport_name, _first_person_extension, _status_extension, _inventory_extension)
end
