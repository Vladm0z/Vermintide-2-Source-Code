-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_grabbing.lua

PackmasterStateGrabbing = class(PackmasterStateGrabbing, EnemyCharacterState)

PackmasterStateGrabbing.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "packmaster_grabbing")

	self.current_movement_speed_scale = 0
	self.last_input_direction = Vector3Box(0, 0, 0)
end

local POSITION_LOOKUP = POSITION_LOOKUP

PackmasterStateGrabbing.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self._temp_params)

	self._unit = arg_2_1

	local get_data = Unit.get_data(arg_2_1, "breed")

	self._breed = get_data
	self._hook_range = get_data.grab_hook_range
	self._grab_movement_speed_multiplier_initial = get_data.grab_movement_speed_multiplier_initial
	self._grab_movement_speed_multiplier_target = get_data.grab_movement_speed_multiplier_target
	self._move_slow_lerp_constant = 0.5
	self._dot_threshold = get_data.grab_hook_cone_dot
	self._physics_world = World.physics_world(self._world)
	self.highest_dot_value = 0

	local _first_person_extension = self._first_person_extension

	self._first_person_unit = _first_person_extension:get_first_person_unit()

	CharacterStateHelper.play_animation_event(arg_2_1, "attack_grab")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "attack_grab")

	self._grab_time = arg_2_5 + get_data.grab_anim_time
	self._grab_grace_period = get_data.grab_grace_period

	self._status_extension:set_is_packmaster_grabbing(true)
	self:set_breed_action("initial_pull")
end

PackmasterStateGrabbing.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self._status_extension:set_is_packmaster_grabbing(false)
	self._career_extension:start_activated_ability_cooldown(1)
	self:set_breed_action("n/a")
end

PackmasterStateGrabbing.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return
	end

	if not CharacterStateHelper.is_block_broken(_status_extension) then
		_status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		_csm:change_state("stunned", parry_broken)

		return
	end

	local _grab_time = self._grab_time
	local tbl = {
		before = _grab_time - self._grab_grace_period.before,
		after = _grab_time + self._grab_grace_period.after
	}
	local _grab = self:_grab()

	if not (not _grab_time and not (arg_4_5 >= tbl.before)) then
		if not (_grab or not (_grab_time <= arg_4_5)) then
			CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "claw_closed")
		end

		local is_in_ghost_mode = ScriptUnit.extension(arg_4_1, "ghost_mode_system"):is_in_ghost_mode()

		if not (not _grab and is_in_ghost_mode) then
			local extension_input = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_networked_dialogue_event("hook_success", alloc_table)
			_csm:change_state("packmaster_dragging", _grab)
		elseif arg_4_5 >= tbl.after then
			local extension_input_2 = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
			local alloc_table_2 = FrameTable.alloc_table()

			extension_input_2:trigger_networked_dialogue_event("hook_fail", alloc_table_2)
			_csm:change_state("walking")
		end
	end

	_locomotion_extension:set_disable_rotation_update()
	self:_update_movement(arg_4_1, arg_4_5, arg_4_3)
end

PackmasterStateGrabbing._grab = function (self)
	-- function 5
	if not self._locomotion_extension:is_on_ground() then
		return nil
	end

	local _unit = self._unit
	local _first_person_unit = self._first_person_unit
	local _physics_world = self._physics_world

	return (EnemyCharacterStateHelper.get_enemies_in_line_of_sight(_unit, _first_person_unit, _physics_world))
end

PackmasterStateGrabbing._update_movement = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local _buff_extension = self._buff_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_1)
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)
	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)
	local current_movement_speed_scale = self.current_movement_speed_scale

	if not self.is_bot then
		local _breed = self._breed

		_breed = not _breed and self._breed.breed_move_acceleration_up

		local _breed_2 = self._breed

		_breed_2 = not _breed_2 and self._breed.breed_move_acceleration_down

		local num = _breed * arg_6_3

		num = num or get_movement_settings_table.move_acceleration_up * arg_6_3

		local num_2 = _breed_2 * arg_6_3

		num_2 = num_2 or get_movement_settings_table.move_acceleration_down * arg_6_3

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num)
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_2)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local lerp = math.lerp(self._grab_movement_speed_multiplier_initial, self._grab_movement_speed_multiplier_target, self._move_slow_lerp_constant * arg_6_3)
	local num_3 = get_movement_settings_table.move_speed * lerp
	local num_4 = _buff_extension:apply_buffs_to_value(num_3, "movement_speed") * current_movement_speed_scale * get_movement_settings_table.player_speed_scale
	local var_6_14 = Vector3(0, 0, 0)

	if not get_movement_input then
		var_6_14 = var_6_14 + get_movement_input
	end

	local var_6_15
	local normalize = Vector3.normalize(var_6_14)

	if Vector3.length(normalize) == 0 then
		normalize = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize)
	end

	local get_move_animation = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, self._status_extension, self.move_anim_3p)

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_6_1, get_move_animation)

		self.move_anim_3p = get_move_animation
	end

	CharacterStateHelper.move_on_ground(_first_person_extension, _input_extension, self._locomotion_extension, normalize, num_4, arg_6_1)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, self._status_extension, self._inventory_extension)

	self.current_movement_speed_scale = current_movement_speed_scale
end
