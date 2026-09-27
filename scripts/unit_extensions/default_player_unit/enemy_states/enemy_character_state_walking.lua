-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_walking.lua

EnemyCharacterStateWalking = class(EnemyCharacterStateWalking, EnemyCharacterState)

EnemyCharacterStateWalking.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, arg_1_2 or "walking")

	local var_1_0 = arg_1_1

	self.current_movement_speed_scale = 0
	self.latest_valid_navmesh_position = Vector3Box(math.huge, math.huge, math.huge)
	self.last_input_direction = Vector3Box(0, 0, 0)
end

EnemyCharacterStateWalking.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local _unit = self._unit
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension
	local current_velocity = self._locomotion_extension:current_velocity()
	local owner = Managers.player:owner(_unit)
	local flag = not owner and owner.bot_player

	if not _status_extension:get_unarmed() then
		CharacterStateHelper.play_animation_event(_unit, "to_combat")
	end

	if arg_2_6 == "standing" then
		self.current_movement_speed_scale = 0
	else
		self.current_movement_speed_scale = 1
	end

	if not flag then
		local normalize = Vector3.normalize(Vector3.flat(current_velocity))
		local current_rotation = _first_person_extension:current_rotation()
		local dot = Vector3.dot(Quaternion.right(current_rotation), normalize)
		local dot_2 = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(current_rotation))), normalize)
		local var_2_13 = Vector3(dot, dot_2, 0)

		self.last_input_direction:store(var_2_13)
	end

	local get_move_animation, var_2_15 = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, _status_extension)

	self.move_anim_3p = get_move_animation
	self.move_anim_1p = var_2_15

	CharacterStateHelper.play_animation_event(_unit, get_move_animation)
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_2_15)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, _unit, _input_extension, _inventory_extension, _health_extension)

	self.is_bot = flag
end

EnemyCharacterStateWalking.common_state_changes = function (self)
	-- function 3
	self:handle_disabled_ghost_mode()

	local _csm = self._csm
	local _unit = self._unit
	local _input_extension = self._input_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local CharacterStateHelper = CharacterStateHelper
	local _first_person_extension = self._first_person_extension
	local _inventory_extension = self._inventory_extension
	local career_settings = self._career_extension:career_settings()

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
		local interaction_action_names, var_3_14 = InteractionHelper.interaction_action_names(_unit)

		_interactor_extension:start_interaction(var_3_14)

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

	if not self._input_extension:get("character_inspecting") then
		local get_item_data_and_weapon_extensions, var_3_18, var_3_19 = CharacterStateHelper.get_item_data_and_weapon_extensions(self._inventory_extension)

		if not CharacterStateHelper.get_current_action_data(var_3_19, var_3_18) then
			_csm:change_state("inspecting")

			return true
		end
	end

	return false
end

EnemyCharacterStateWalking.common_movement = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _csm = self._csm
	local current_movement_speed_scale = self.current_movement_speed_scale
	local _first_person_extension = self._first_person_extension
	local _input_extension = self._input_extension
	local _inventory_extension = self._inventory_extension
	local _locomotion_extension = self._locomotion_extension
	local _status_extension = self._status_extension
	local _unit = self._unit
	local extension = ScriptUnit.extension(_unit, "buff_system")
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)
	local is_device_active = Managers.input:is_device_active("gamepad")
	local is_crouching = _status_extension:is_crouching()
	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)

	if not (_csm.state_next or has_move_input or current_movement_speed_scale ~= 0) then
		local _temp_params = self._temp_params

		_csm:change_state("standing", _temp_params)
		_first_person_extension:change_state("standing")

		return true
	end

	if not (_csm.state_next or _locomotion_extension:is_on_ground()) then
		_csm:change_state("falling", self._temp_params)
		_first_person_extension:change_state("falling")

		return true
	end

	if (_input_extension:get("jump") or not _input_extension:get("jump_only") or _status_extension:is_crouching()) and (not is_crouching or CharacterStateHelper.can_uncrouch(_unit) or not _locomotion_extension:jump_allowed()) then
		if not is_crouching then
			CharacterStateHelper.uncrouch(_unit, t, _first_person_extension, _status_extension)
		end

		_csm:change_state("jumping")
		_first_person_extension:change_state("jumping")

		return
	end

	local toggle_crouch = _input_extension.toggle_crouch
	local owner = Managers.player:owner(_unit)
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)
	local get_data = Unit.get_data(_unit, "breed")

	if not self.is_bot then
		local flag = not get_data and get_data.breed_move_acceleration_up
		local flag_2 = not get_data and get_data.breed_move_acceleration_down
		local num = flag * arg_4_2

		num = num or get_movement_settings_table.move_acceleration_up * arg_4_2

		local num_2 = flag_2 * arg_4_2

		num_2 = num_2 or get_movement_settings_table.move_acceleration_down * arg_4_2

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num)

			if not is_device_active then
				current_movement_speed_scale = Vector3.length(get_movement_input) * current_movement_speed_scale
			end
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_2)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local get = _input_extension:get("walk")
	local movement_speed_multiplier = get_data.movement_speed_multiplier
	local move_speed = get_movement_settings_table.move_speed

	if not (not arg_4_1 and get) then
		move_speed = get_movement_settings_table.ghost_move_speed
	end

	local num_3 = move_speed * movement_speed_multiplier
	local num_4 = extension:apply_buffs_to_value(num_3, "movement_speed") * current_movement_speed_scale * get_movement_settings_table.player_speed_scale
	local strafe_speed_multiplier = get_data.strafe_speed_multiplier
	local normalize = Vector3.normalize(get_movement_input)

	if Vector3.length_squared(get_movement_input) == 0 then
		normalize = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize)
	end

	CharacterStateHelper.move_on_ground(_first_person_extension, _input_extension, _locomotion_extension, normalize, num_4, _unit, strafe_speed_multiplier)
	CharacterStateHelper.ghost_mode(self._ghost_mode_extension, _input_extension)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)

	local get_move_animation, var_4_30 = CharacterStateHelper.get_move_animation(_locomotion_extension, _input_extension, _status_extension, self.move_anim_3p)

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(_unit, get_move_animation, true)

		self.move_anim_3p = get_move_animation
	end

	if var_4_30 ~= self.move_anim_1p then
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_4_30)

		self.move_anim_1p = var_4_30
	end

	self.current_movement_speed_scale = current_movement_speed_scale

	return false
end

EnemyCharacterStateWalking.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if not self:common_state_changes() then
		return
	end

	local _input_extension = self._input_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension

	CharacterStateHelper.update_weapon_actions(arg_5_5, arg_5_1, _input_extension, _inventory_extension, _health_extension)
	self:_update_taunt_dialogue(arg_5_5)

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local common_movement = self:common_movement(is_in_ghost_mode, arg_5_3)
end
