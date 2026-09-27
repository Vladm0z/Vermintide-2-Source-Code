-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_jumping.lua

EnemyCharacterStateJumping = class(EnemyCharacterStateJumping, EnemyCharacterState)

EnemyCharacterStateJumping.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterState.init(arg_1_0, arg_1_1, "jumping")

	local var_1_0 = arg_1_1
end

local POSITION_LOOKUP = POSITION_LOOKUP

EnemyCharacterStateJumping.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self._temp_params)

	local _player = self._player
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension
	local _first_person_extension = self._first_person_extension

	self._breed = Unit.get_data(arg_2_1, "breed")

	local _breed = self._breed
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local initial_vertical_speed = get_movement_settings_table.jump.initial_vertical_speed

	if not script_data.use_super_jumps then
		initial_vertical_speed = initial_vertical_speed * 2
	end

	_locomotion_extension:set_maximum_upwards_velocity(initial_vertical_speed)
	_locomotion_extension:force_on_ground(false)

	local current_velocity = _locomotion_extension:current_velocity()
	local var_2_10

	if not arg_2_7.post_dodge_jump then
		current_velocity = current_velocity * PlayerUnitMovementSettings.post_dodge_jump_velocity_scale
		initial_vertical_speed = initial_vertical_speed * PlayerUnitMovementSettings.post_dodge_jump_speed_scale
	end

	if not arg_2_7.backward_jump then
		current_velocity = current_velocity * PlayerUnitMovementSettings.backwards_jump_velocity_scale
	end

	local movement_speed_multiplier = _breed.movement_speed_multiplier
	local move_speed = get_movement_settings_table.move_speed

	if not ScriptUnit.extension(arg_2_1, "ghost_mode_system"):is_in_ghost_mode() then
		move_speed = get_movement_settings_table.ghost_move_speed
	end

	local num = move_speed * movement_speed_multiplier
	local length = Vector3.length(current_velocity)

	if num < length then
		current_velocity = current_velocity * (num / length)
	end

	local var_2_15 = Vector3(current_velocity.x * 0.5, current_velocity.y * 0.5, initial_vertical_speed)

	_locomotion_extension:set_forced_velocity(var_2_15)
	_locomotion_extension:set_wanted_velocity(var_2_15)

	local var_2_16
	local flag

	flag = not CharacterStateHelper.has_move_input(_input_extension) and "jump_fwd" and "jump_idle"

	CharacterStateHelper.play_animation_event(arg_2_1, flag)
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "idle")
	_first_person_extension:play_camera_effect_sequence("jump", arg_2_5)
	CharacterStateHelper.ghost_mode(self._ghost_mode_extension, _input_extension)
	CharacterStateHelper.look(_input_extension, _player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, _input_extension, _inventory_extension, self._health_extension)
	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	local z = POSITION_LOOKUP[arg_2_1].z

	_status_extension:set_falling_height(z)
	Unit.flow_event(arg_2_1, "pactsworn_jump")
end

EnemyCharacterStateJumping.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	if not (arg_3_6 == "walking" or arg_3_6 ~= "standing") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	elseif not (not arg_3_6 and arg_3_6 == "falling") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end
end

EnemyCharacterStateJumping.common_state_changes = function (self)
	-- function 4
	self:handle_disabled_ghost_mode()

	local _csm = self._csm
	local _unit = self._unit
	local _input_extension = self._input_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local CharacterStateHelper = CharacterStateHelper

	if not _locomotion_extension:is_on_ground() then
		ScriptUnit.extension(_unit, "whereabouts_system"):set_is_onground()
	end

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return true
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return true
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return true
	end

	if not CharacterStateHelper.is_block_broken(_status_extension) then
		_status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		_csm:change_state("stunned", parry_broken)

		return true
	end

	if not _locomotion_extension:is_animation_driven() then
		return true
	end

	local _interactor_extension = self._interactor_extension

	if not CharacterStateHelper.is_starting_interaction(_input_extension, _interactor_extension) then
		local interaction_action_names, var_4_11 = InteractionHelper.interaction_action_names(_unit)

		_interactor_extension:start_interaction(var_4_11)

		if not _interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config = _interactor_extension:interaction_config()
		local _temp_params = self._temp_params

		_temp_params.swap_to_3p = interaction_config.swap_to_3p
		_temp_params.show_weapons = interaction_config.show_weapons
		_temp_params.activate_block = interaction_config.activate_block
		_temp_params.allow_rotation_update = interaction_config.allow_rotation_update

		_csm:change_state("interacting", _temp_params)

		return true
	end

	if _csm.state_next or not _status_extension.do_leap then
		_csm:change_state("leaping")

		return true
	end

	if not _input_extension:get("character_inspecting") then
		local get_item_data_and_weapon_extensions, var_4_15, var_4_16 = CharacterStateHelper.get_item_data_and_weapon_extensions(self._inventory_extension)

		if not CharacterStateHelper.get_current_action_data(var_4_16, var_4_15) then
			_csm:change_state("inspecting")

			return true
		end
	end

	return false
end

EnemyCharacterStateJumping.common_movement = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local _csm = self._csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_3)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _breed = self._breed

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return
	end

	if not _locomotion_extension:is_on_ground() then
		_csm:change_state("walking")
		_first_person_extension:change_state("walking")

		return
	end

	if not (_csm.state_next or not (_locomotion_extension:current_velocity().z <= 0)) then
		_csm:change_state("falling", self._temp_params)
		_first_person_extension:change_state("falling")

		return
	end

	local movement_speed_multiplier = _breed.movement_speed_multiplier
	local move_speed = get_movement_settings_table.move_speed

	if not arg_5_1 then
		move_speed = get_movement_settings_table.ghost_move_speed
	end

	local num = move_speed * movement_speed_multiplier
	local num_2 = self._buff_extension:apply_buffs_to_value(num, "movement_speed") * get_movement_settings_table.player_speed_scale

	CharacterStateHelper.move_in_air_pactsworn(self._first_person_extension, _input_extension, self._locomotion_extension, num_2, arg_5_3)
	CharacterStateHelper.ghost_mode(self._ghost_mode_extension, _input_extension)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, self._first_person_extension, _status_extension, self._inventory_extension)
end

EnemyCharacterStateJumping.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not self:common_state_changes() then
		return
	end

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local common_movement = self:common_movement(is_in_ghost_mode, arg_6_3, arg_6_1)
end
