-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_leaping.lua

EnemyCharacterStateLeaping = class(EnemyCharacterStateLeaping, EnemyCharacterState)

EnemyCharacterStateLeaping.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "leaping")

	self._direction = Vector3Box()
end

local POSITION_LOOKUP = POSITION_LOOKUP

EnemyCharacterStateLeaping.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self._temp_params)

	self._time_entered_leap = arg_2_5

	local _player = self._player
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension

	self._locomotion_extension:set_mover_filter_property("enemy_leap_state", true)

	local _inventory_extension = self._inventory_extension
	local _first_person_extension = self._first_person_extension
	local do_leap = _status_extension.do_leap

	do_leap.starting_pos = Vector3Box(POSITION_LOOKUP[arg_2_1])
	do_leap.total_distance = Vector3.length(do_leap.projected_hit_pos:unbox() - POSITION_LOOKUP[arg_2_1])
	self._leap_data = do_leap
	_status_extension.do_leap = false

	local current_rotation = _first_person_extension:current_rotation()
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(current_rotation)))
	local var_2_8 = POSITION_LOOKUP[arg_2_1]
	local unbox = do_leap.projected_hit_pos:unbox()

	self._percentage_done = 0
	self.initial_jump_direction = Vector3Box(unbox - var_2_8)
	self.jump_direction = Vector3Box(normalize)

	self:_start_leap(arg_2_1, arg_2_5)
	CharacterStateHelper.look(_input_extension, _player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, _input_extension, _inventory_extension, self._health_extension)
	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	self._time_slided = 0
	self._played_landing_event = nil
end

EnemyCharacterStateLeaping.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local _locomotion_extension = self._locomotion_extension

	_locomotion_extension:set_mover_filter_property("enemy_leap_state", false)

	if not arg_3_7 then
		local copy = Vector3.copy(POSITION_LOOKUP[arg_3_1])
		local unbox = self._leap_data.projected_hit_pos:unbox()

		if not (not copy and not unbox and not (copy.z < unbox.z)) then
			copy.z = unbox.z + 0.1

			_locomotion_extension:teleport_to(copy)
		end

		_locomotion_extension:set_forced_velocity(Vector3.zero())
		_locomotion_extension:set_wanted_velocity(Vector3.zero())

		if self._leap_done or not self._leap_data.leap_events.finished then
			local var_3_3 = POSITION_LOOKUP[arg_3_1]

			self._leap_data.leap_events.finished(self, arg_3_1, false, var_3_3)
		end

		if not (arg_3_6 == "walking" or arg_3_6 ~= "standing") then
			ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
		elseif not (not arg_3_6 and arg_3_6 == "falling") then
			ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
		end

		if not arg_3_6 and arg_3_6 == "falling" and arg_3_6 == "staggered" or not Managers.state.network:game() then
			CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
			CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")
			_locomotion_extension:force_on_ground(true)
		end

		if not self._screenspace_effect_id then
			self._first_person_extension:destroy_screen_particles(self._screenspace_effect_id)

			self._screenspace_effect_id = nil
		end
	end
end

EnemyCharacterStateLeaping.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(_status_extension) then
		_csm:change_state("overcharge_exploding")

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

	self._time_spent_in_leap = arg_4_5 - self._time_entered_leap

	local _update_movement, var_4_10, var_4_11 = self:_update_movement(arg_4_1, arg_4_3, arg_4_5)

	if not _update_movement then
		self:_finish(arg_4_1, arg_4_5)

		if not var_4_10 then
			_csm:change_state("walking", self._temp_params)
			_first_person_extension:change_state("walking")

			self._leap_done = true

			return
		end

		local current_velocity = _locomotion_extension:current_velocity()

		if self._csm.state_next or current_velocity.z <= 0 or not var_4_11 then
			if not var_4_11 then
				current_velocity.y = 0
			end

			self._locomotion_extension:set_wanted_velocity(Vector3.zero())
			self._locomotion_extension:set_forced_velocity(Vector3.zero())
			_csm:change_state("falling", self._temp_params)
			_first_person_extension:change_state("falling")

			self._leap_done = true

			return
		end
	end

	local var_4_13 = POSITION_LOOKUP[arg_4_1]
	local unbox = self._leap_data.starting_pos:unbox()
	local unbox_2 = self._leap_data.projected_hit_pos:unbox()

	self._percentage_done = Vector3.length(var_4_13 - unbox) / Vector3.length(unbox_2 - unbox)

	if not self._leap_data.update_leap_anim_variable then
		self._leap_data.update_leap_anim_variable(self, arg_4_1)
	end

	if Vector3.distance_squared(var_4_13, unbox_2) < 0.25 then
		self._leap_done = true
	end

	local var_4_16
	local var_4_17

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension, var_4_16, var_4_17)
end

local function fn(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return (math.clamp(arg_5_2, arg_5_0, arg_5_1) - arg_5_0) / (arg_5_1 - arg_5_0)
end

PlayerCharacterStateLeaping._reset_speed_and_gravity = function (self, arg_6_1)
	-- function 6
	local locomotion_extension = self.locomotion_extension

	PlayerUnitMovementSettings.get_movement_settings_table(arg_6_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration

	locomotion_extension:set_forced_velocity(Vector3.zero())
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:reset_maximum_upwards_velocity()
	locomotion_extension:set_external_velocity_enabled(true)
end

EnemyCharacterStateLeaping._move_in_air = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local _locomotion_extension = self._locomotion_extension
	local var_7_1 = POSITION_LOOKUP[arg_7_1]
	local unbox = self._leap_data.starting_pos:unbox()
	local unbox_2 = self._leap_data.projected_hit_pos:unbox()
	local flat = Vector3.flat(var_7_1 - unbox)
	local flat_2 = Vector3.flat(unbox_2 - unbox)
	local dot = Vector3.dot(flat, flat_2)
	local length = Vector3.length(flat_2)
	local num = dot / length
	local normalize = Vector3.normalize(self._leap_data.direction:unbox())
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_7_1)
	local movement_settings = self._leap_data.movement_settings

	movement_settings = movement_settings or PlayerUnitMovementSettings.get_movement_settings_table(arg_7_1)

	local num_2 = self._leap_data.speed * self._status_extension:current_move_speed_multiplier()^2 * movement_settings.player_speed_scale
	local lerp_data = self._leap_data.lerp_data
	local num_3 = length * lerp_data.zero_distance

	num_3 = num_3 or 0

	local num_4 = length * lerp_data.start_accel_distance

	num_4 = num_4 or 0.1

	local num_5 = length * lerp_data.end_accel_distance

	num_5 = num_5 or 0.2

	local num_6 = length * lerp_data.glide_distance

	num_6 = num_6 or 0.7

	local num_7 = length * lerp_data.slow_distance

	num_7 = num_7 or 0.95

	local num_8 = length * lerp_data.full_distance

	num_8 = num_8 or 1
	self._old_position = var_7_1

	local var_7_20

	if num <= num_4 then
		var_7_20 = "start_acceleration"

		local var_7_21 = fn(num_3, num_4, num)
		local ease_out_exp = math.ease_out_exp(var_7_21)

		num_2 = num_2 * math.lerp(0, 1.25, ease_out_exp)

		local num_9 = 0.05

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_9

		local clamp = math.clamp(movement_settings.move_speed, 0, movement_settings.max_move_speed)
		local current_velocity = _locomotion_extension:current_velocity()
		local num_10 = (Vector3.normalize(current_velocity) + normalize) * num_2
		local length_2 = Vector3.length(num_10)
		local clamp_2 = math.clamp(length_2, 0, clamp * movement_settings.player_speed_scale)
		local normalize_2 = Vector3.normalize(num_10)

		_locomotion_extension:set_wanted_velocity(normalize_2 * clamp_2)
	elseif num <= num_5 then
		var_7_20 = "end_acceleration"

		local var_7_30 = fn(num_4, num_5, num)
		local easeOutCubic = math.easeOutCubic(var_7_30)

		num_2 = num_2 * math.lerp(1.25, 0.8, easeOutCubic)

		local num_11 = 0.1

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_11

		local clamp_3 = math.clamp(movement_settings.move_speed, 0, movement_settings.max_move_speed)
		local current_velocity_2 = _locomotion_extension:current_velocity()
		local num_12 = (Vector3.normalize(current_velocity_2) + normalize) * num_2
		local length_3, clamp_4 = Vector3.length(num_12), math.clamp
		local num_13 = 0
		local player_speed_scale = movement_settings.player_speed_scale

		player_speed_scale = player_speed_scale or 1

		local var_7_40 = clamp_4(length_3, num_13, clamp_3 * player_speed_scale)
		local normalize_3 = Vector3.normalize(num_12)

		_locomotion_extension:set_wanted_velocity(normalize_3 * var_7_40)
	elseif num <= num_6 then
		var_7_20 = "glide"

		local var_7_42 = fn(num_5, num_6, num)
		local ease_in_exp = math.ease_in_exp(var_7_42)

		num_2 = num_2 * math.lerp(0.8, 0.7, ease_in_exp)

		_locomotion_extension:set_mover_filter_property("enemy_leap_state", false)

		local num_14 = 1

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_14

		local clamp_5 = math.clamp(movement_settings.move_speed, 0, movement_settings.max_move_speed)
		local current_velocity_3 = _locomotion_extension:current_velocity()
		local num_15 = (Vector3.normalize(current_velocity_3) + normalize) * num_2
		local length_4, clamp_6 = Vector3.length(num_15), math.clamp
		local num_16 = 0
		local player_speed_scale_2 = movement_settings.player_speed_scale

		player_speed_scale_2 = player_speed_scale_2 or 1

		local var_7_52 = clamp_6(length_4, num_16, clamp_5 * player_speed_scale_2)
		local normalize_4 = Vector3.normalize(num_15)

		_locomotion_extension:set_wanted_velocity(normalize_4 * var_7_52)
	elseif num <= num_7 then
		var_7_20 = "slow"

		local var_7_54 = fn(num_6, num_7, num)
		local ease_out_quad = math.ease_out_quad(var_7_54)

		num_2 = num_2 * math.lerp(0.7, 0.6, ease_out_quad)
		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * ease_out_quad

		local clamp_7 = math.clamp(movement_settings.move_speed, 0, movement_settings.max_move_speed)
		local current_velocity_4 = _locomotion_extension:current_velocity()
		local num_17 = (Vector3.normalize(current_velocity_4) + normalize) * num_2
		local length_5, clamp_8 = Vector3.length(num_17), math.clamp
		local num_18 = 0
		local num_19 = clamp_7 * movement_settings.player_speed_scale

		num_19 = num_19 or 1

		local var_7_63 = clamp_8(length_5, num_18, num_19)
		local normalize_5 = Vector3.normalize(num_17)

		_locomotion_extension:set_wanted_velocity(normalize_5 * var_7_63)
	else
		var_7_20 = "slam"

		_locomotion_extension:set_mover_filter_property("enemy_leap_state", false)

		local var_7_65 = fn(num_7, num_8, num)
		local ease_out_quad_2 = math.ease_out_quad(var_7_65)
		local num_20 = num_2 * math.lerp(0.6, 1.2, ease_out_quad_2)
		local lerp = math.lerp(0.25, 0, ease_out_quad_2)
		local lerp_2 = math.lerp(0, 0.75, ease_out_quad_2)
		local num_21 = 2

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_21

		local clamp_9 = math.clamp(movement_settings.slam_speed, 0, movement_settings.max_slam_speed)
		local current_velocity_5 = _locomotion_extension:current_velocity()
		local num_22 = Vector3.normalize(Vector3.flat(normalize)) * lerp + Vector3.normalize(unbox_2 - var_7_1) * lerp_2
		local num_23 = (Vector3.normalize(current_velocity_5) + num_22) * num_20
		local length_6 = Vector3.length(num_23)
		local clamp_10 = math.clamp(length_6, 0, clamp_9 * movement_settings.player_speed_scale)
		local normalize_6 = Vector3.normalize(num_23)

		_locomotion_extension:set_forced_velocity(normalize_6 * clamp_10)
	end

	return var_7_20
end

EnemyCharacterStateLeaping._update_movement = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not self._leap_done then
		return true
	end

	local _move_in_air = self:_move_in_air(arg_8_1, arg_8_2, arg_8_3)
	local is_colliding_down = CharacterStateHelper.is_colliding_down(arg_8_1)
	local current_velocity = self._locomotion_extension:current_velocity()
	local flat = Vector3.flat(current_velocity)
	local dot = Vector3.dot(Vector3.normalize(Vector3Box.unbox(self.initial_jump_direction)), Vector3.normalize(flat))
	local var_8_5

	if not (_move_in_air == "start_acceleration" or not (dot < 0)) then
		var_8_5 = true
	end

	self._leap_done = is_colliding_down or var_8_5

	return self._leap_done, is_colliding_down, var_8_5
end

EnemyCharacterStateLeaping._finish = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension

	_first_person_extension:play_camera_effect_sequence("landed_leap", arg_9_2)

	local sfx_event_land = self._leap_data.sfx_event_land

	if not (not sfx_event_land and self._played_landing_event) then
		_first_person_extension:play_unit_sound_event(sfx_event_land, arg_9_1, 0, true)

		self._played_landing_event = true
	end

	PlayerUnitMovementSettings.get_movement_settings_table(arg_9_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration

	_locomotion_extension:set_forced_velocity(Vector3.zero())
	_locomotion_extension:set_wanted_velocity(Vector3.zero())

	if not self._leap_data.leap_events.finished then
		local var_9_3 = POSITION_LOOKUP[arg_9_1]

		self._leap_data.leap_events.finished(self, arg_9_1, false, var_9_3)
	end

	self:_camera_effects(arg_9_1, 0)

	self._leap_done = true
end

EnemyCharacterStateLeaping._start_leap = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension

	_first_person_extension:play_camera_effect_sequence("jump", arg_10_2)

	if not self._leap_data.anim_start_event_1p then
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, self._leap_data.anim_start_event_1p)
	end

	if not self._leap_data.anim_start_event_3p then
		CharacterStateHelper.play_animation_event(arg_10_1, self._leap_data.anim_start_event_3p)
	end

	local sfx_event_jump = self._leap_data.sfx_event_jump

	if not sfx_event_jump then
		_first_person_extension:play_unit_sound_event(sfx_event_jump, arg_10_1, 0, true)
	end

	local leap_events = self._leap_data.leap_events

	if not leap_events and not leap_events.start then
		leap_events.start(self, arg_10_1)
	end

	local num = self._leap_data.direction:unbox() * PlayerUnitMovementSettings.leap.jump_speed + Vector3.up()

	_locomotion_extension:set_maximum_upwards_velocity(num.z)
	_locomotion_extension:set_forced_velocity(num)
	_locomotion_extension:set_wanted_velocity(num)

	local movement_settings = self._leap_data.movement_settings

	movement_settings = movement_settings or PlayerUnitMovementSettings.get_movement_settings_table(arg_10_1)
	movement_settings.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * 0
	self._leap_done = false
end

EnemyCharacterStateLeaping._camera_effects = function (self, arg_11_1, arg_11_2)
	-- function 11
	local num = 1.5
	local lerp = math.lerp(1, num, arg_11_2)

	Managers.state.camera:set_additional_fov_multiplier(lerp)

	local str = "fx/speedlines_01_1p"

	if arg_11_2 >= 0.25 then
		if not self._screenspace_effect_id then
			self._screenspace_effect_id = self._first_person_extension:create_screen_particles(str)
		end
	elseif not (arg_11_2 <= 0) or not self._screenspace_effect_id then
		self._first_person_extension:destroy_screen_particles(self._screenspace_effect_id)

		self._screenspace_effect_id = nil
	end
end
