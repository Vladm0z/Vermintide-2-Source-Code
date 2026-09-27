-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_stunned.lua

EnemyCharacterStateStunned = class(EnemyCharacterStateStunned, EnemyCharacterState)

EnemyCharacterStateStunned.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "stunned")

	local var_1_0 = arg_1_1

	self.inputs_to_buffer = {
		wield_4_alt = true,
		wield_2 = true,
		wield_5 = true,
		action_career_release = true,
		action_career = true,
		wield_3 = true,
		wield_1 = true,
		wield_4 = true,
		action_one = true,
		wield_switch = true
	}
	self.movement_speed = 0
	self.movement_speed_limit = 1
	self.last_input_direction = Vector3Box(0, 0, 0)
	self.look_override = Vector3Box(0, 0, 0)
end

EnemyCharacterStateStunned.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self._inventory_extension, "stunned")
	CharacterStateHelper.stop_career_abilities(self._career_extension, "stunned")
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, arg_2_7.first_person_anim_name)
	CharacterStateHelper.play_animation_event(arg_2_1, arg_2_7.third_person_anim_name)

	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local extension = ScriptUnit.extension(arg_2_1, "buff_system")
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local hit_react_type = arg_2_7.hit_react_type

	hit_react_type = hit_react_type or "light"

	assert(get_movement_settings_table.hit_react_settings[hit_react_type])

	local var_2_5 = get_movement_settings_table.hit_react_settings[hit_react_type]
	local look_override_function, var_2_7 = var_2_5.look_override_function()

	self.movement_speed = var_2_5.movement_speed_modifier
	self.movement_speed_modifier = var_2_5.movement_speed_modifier
	self.end_look_sense_override = var_2_5.end_look_sense_override
	self.start_look_sense_override = var_2_5.start_look_sense_override

	local duration_function = var_2_5.duration_function()
	local apply_buffs_to_value = extension:apply_buffs_to_value(duration_function, "stun_duration")
	local onscreen_particle_function = var_2_5.onscreen_particle_function(apply_buffs_to_value)
	local has_extension = ScriptUnit.has_extension(arg_2_1, "first_person_system")

	if not has_extension and not onscreen_particle_function then
		self.onscreen_particle_id = has_extension:create_screen_particles(onscreen_particle_function)
	end

	local get_move_animation, var_2_13 = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, _status_extension, self.move_anim_3p)

	self.move_anim_3p = get_move_animation
	self.move_anim_1p = var_2_13

	self.last_input_direction:store(Vector3(0, 0, 0))

	if not var_2_7 and not look_override_function then
		self.look_override:store(Vector3(look_override_function, var_2_7, 0))
	end

	self.duration = apply_buffs_to_value
	self.time_in_state = 0
	self.end_time = arg_2_5 + apply_buffs_to_value
	self.next_pulse = 0
	self.current_stagger_speed = 1
	self.last_stagger = Vector3Box(0, 0, 0)
end

EnemyCharacterStateStunned.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local _input_extension = self._input_extension

	if not _input_extension:get("action_one_hold") then
		_input_extension:add_stun_buffer("action_one_hold")
	end

	local has_extension = ScriptUnit.has_extension(arg_3_1, "first_person_system")

	if not has_extension and not self.onscreen_particle_id then
		has_extension:stop_spawning_screen_particles(self.onscreen_particle_id)
	end
end

EnemyCharacterStateStunned.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local _unit = self._unit
	local _input_extension = self._input_extension
	local _inventory_extension = self._inventory_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local _world = self._world
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)
	local _first_person_extension = self._first_person_extension

	self.time_in_state = self.time_in_state + arg_4_3

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm, "stunned") then
		return
	end

	if arg_4_5 > self.end_time then
		_csm:change_state("standing")

		return
	end

	self:queue_input(arg_4_2, _input_extension, _inventory_extension)

	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)
	local _inventory_extension_2 = self._inventory_extension
	local owner = Managers.player:owner(_unit)

	if not has_move_input then
		self.movement_speed = math.min(0.75, self.movement_speed + get_movement_settings_table.move_acceleration_up * arg_4_3)
	elseif not owner and not owner.bot_player then
		self.movement_speed = 0
	else
		self.movement_speed = math.max(self.movement_speed_limit, self.movement_speed - get_movement_settings_table.move_acceleration_down * arg_4_3)
	end

	local get = _input_extension:get("walk")
	local crouch_move_speed

	if not _status_extension:is_crouching() then
		crouch_move_speed = get_movement_settings_table.crouch_move_speed

		if not crouch_move_speed then
			-- Nothing
		end
	end

	if not get then
		crouch_move_speed = get_movement_settings_table.walk_move_speed

		if not crouch_move_speed then
			-- Nothing
		end
	end

	crouch_move_speed = get_movement_settings_table.move_speed

	::label_4_0::

	local current_move_speed_multiplier = _status_extension:current_move_speed_multiplier()

	if get ~= self.walking then
		_status_extension:set_slowed(get)
	end

	local num = crouch_move_speed * current_move_speed_multiplier * get_movement_settings_table.player_speed_scale * self.movement_speed
	local var_4_16 = Vector3(0, 0, 0)
	local get_2 = _input_extension:get("move")

	if not get_2 then
		var_4_16 = var_4_16 + get_2
	end

	local get_3 = _input_extension:get("move_controller")

	if not get_3 then
		local length = Vector3.length(get_3)

		if length > 0 then
			num = num * length
		end

		var_4_16 = var_4_16 + get_3
	end

	local var_4_20

	if arg_4_5 > self.next_pulse then
		local var_4_21 = Vector3(2 * (math.random() - 0.5), 2 * (math.random() - 0.5), 0)
		local normalize = Vector3.normalize(var_4_21)
		local length_2 = Vector3.length(var_4_21)

		self.next_pulse = arg_4_5 + 0.2

		self.last_stagger:store(var_4_21)

		self.current_stagger_speed = 1
	end

	local num_2 = var_4_16 + self.last_stagger:unbox()

	self.current_stagger_speed = math.max(0, self.current_stagger_speed - get_movement_settings_table.move_acceleration_down * arg_4_3)

	local num_3 = num * self.current_stagger_speed * self.movement_speed_modifier
	local var_4_26
	local normalize_2 = Vector3.normalize(num_2)

	if Vector3.length(normalize_2) == 0 then
		normalize_2 = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize_2)
	end

	CharacterStateHelper.move_on_ground(_first_person_extension, _input_extension, _locomotion_extension, normalize_2, num_3, _unit)

	local get_move_animation = CharacterStateHelper.get_move_animation(_locomotion_extension, _input_extension, _status_extension, self.move_anim_3p)

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(_unit, get_move_animation)

		self.move_anim_3p = get_move_animation
	end

	self.walking = get

	if not (_csm.state_next or _locomotion_extension:is_on_ground()) then
		_csm:change_state("falling")

		return
	end

	local var_4_29

	if not self.look_override then
		var_4_29 = self.look_override:unbox()
	end

	local num_4 = self.time_in_state / self.duration
	local min = math.min(self.end_look_sense_override, math.lerp(self.start_look_sense_override, 1, num_4))

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, self._first_person_extension, _status_extension, self._inventory_extension, min, var_4_29)
	self.look_override:store(0, 0, 0)
end

EnemyCharacterStateStunned.queue_input = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local wield_input = CharacterStateHelper.wield_input(arg_5_2, arg_5_3, "action_wield")

	if not wield_input then
		arg_5_2:add_buffer(wield_input)
	end

	for k, v in pairs(self.inputs_to_buffer) do
		if not arg_5_2:get(k) then
			arg_5_2:add_stun_buffer(k)

			break
		end
	end
end
