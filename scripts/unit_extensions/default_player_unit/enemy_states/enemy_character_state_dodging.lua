-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_dodging.lua

EnemyCharacterStateDodging = class(EnemyCharacterStateDodging, EnemyCharacterState)

EnemyCharacterStateDodging.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "dodging")

	local var_1_0 = arg_1_1

	self.movement_speed = 0
	self.dodge_direction = Vector3Box(0, 0, 0)
	self.last_position = Vector3Box(0, 0, 0)
end

EnemyCharacterStateDodging.on_enter_animation = function (self, arg_2_1)
	-- function 2
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local unbox = self.dodge_direction:unbox()
	local x = Vector3.x(unbox)
	local y = Vector3.y(unbox)
	local str = "dodge_time"
	local estimated_dodge_time = self.estimated_dodge_time
	local _first_person_extension = self._first_person_extension

	if math.abs(y) > math.abs(x) then
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, "dodge_bwd", str, estimated_dodge_time)
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "dodge_bwd")
	elseif x > 0 then
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, "dodge_left", str, estimated_dodge_time)
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "dodge_left")
	else
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, "dodge_right", str, estimated_dodge_time)
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "dodge_right")
	end
end

EnemyCharacterStateDodging.on_enter = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local _unit = self._unit
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension

	self.dodge_direction:store(arg_3_7.dodge_direction)

	arg_3_7.dodge_direction = nil

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)

	_status_extension:set_dodge_jump_override_t(arg_3_5, get_movement_settings_table.dodging.dodge_jump_override_timer)
	self:start_dodge(_unit, arg_3_5)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_3_5, _unit, _input_extension, _inventory_extension, _health_extension)
	self:on_enter_animation(_unit)
	self._locomotion_extension:enable_rotation_towards_velocity(false)

	local forward = Quaternion.forward(_first_person_extension:current_rotation())

	Vector3.set_z(forward, 0)

	local normalize = Vector3.normalize(forward)
	local look = Quaternion.look(normalize, Vector3(0, 0, 1))

	Unit.set_local_rotation(_unit, 0, look)
end

EnemyCharacterStateDodging.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local max = math.max(get_movement_settings_table.dodging.dodge_cd, get_movement_settings_table.dodging.dodge_jump_override_timer - self.time_in_dodge)

	self._status_extension:set_dodge_cd(arg_4_5, max)

	self.dodge_timer = nil
	self.dodge_stand_still_timer = nil
	self.dodge_return_timer = nil

	self._locomotion_extension:enable_rotation_towards_velocity(true)
	self._status_extension:start_dodge_cooldown(arg_4_5)

	local network = Managers.state.network

	if not network:game() then
		CharacterStateHelper.play_animation_event(arg_4_1, "dodge_end")

		if not LEVEL_EDITOR_TEST then
			local unit_game_object_id = network:unit_game_object_id(arg_4_1)

			self._status_extension:set_is_dodging(false)
			network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, unit_game_object_id, 0)
		end
	end
end

EnemyCharacterStateDodging.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local _csm = self._csm
	local _unit = self._unit
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension

	self.time_in_dodge = self.time_in_dodge + arg_5_3

	ScriptUnit.extension(_unit, "whereabouts_system"):set_is_onground()

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

	if not self._locomotion_extension:is_animation_driven() then
		return
	end

	if (_input_extension:get("jump") or not _input_extension:get("jump_only") or not _status_extension:can_override_dodge_with_jump(arg_5_5)) and not self._locomotion_extension:jump_allowed() then
		local _temp_params = self._temp_params

		_temp_params.post_dodge_jump = true

		_csm:change_state("jumping", _temp_params)

		return
	end

	CharacterStateHelper.update_dodge_lock(_unit, self._input_extension, _status_extension)

	if not (self._csm.state_next or self._locomotion_extension:is_on_ground()) then
		_csm:change_state("falling", self._temp_params)

		return
	end

	if not self:update_dodge(_unit, arg_5_3, arg_5_5) then
		local _temp_params_2 = self._temp_params

		_csm:change_state("walking", _temp_params_2)
	end

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension)

	local get_move_animation = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, _status_extension, self.move_anim)

	if get_move_animation ~= self.move_anim then
		CharacterStateHelper.play_animation_event(_unit, get_move_animation)

		self.move_anim = get_move_animation
	end
end

local tbl = {}

EnemyCharacterStateDodging.update_dodge = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_1)
	local distance_left = self.distance_left
	local get_dodge_cooldown = self._status_extension:get_dodge_cooldown()
	local speed_modifier = get_movement_settings_table.dodging.speed_modifier
	local distance_modifier = get_movement_settings_table.dodging.distance_modifier

	if Vector3.distance(Unit.world_position(arg_6_1, 0), self.last_position:unbox()) / self.distance_supposed_to_move < get_movement_settings_table.dodging.stop_threshold then
		return false
	end

	if self.distance_left <= 0 then
		return false
	end

	local num = self.time_in_dodge * get_dodge_cooldown
	local speed_at_times = get_movement_settings_table.dodging.speed_at_times
	local flag = false
	local num_2 = self.current_speed_setting_index + 1

	self.current_speed_setting_index = #speed_at_times

	for i = num_2, #speed_at_times do
		if num <= speed_at_times[i].time_in_dodge then
			self.current_speed_setting_index = i - 1

			break
		end
	end

	local flag_2 = false
	local current_speed_setting_index = self.current_speed_setting_index
	local num_3 = current_speed_setting_index + 1

	if num_3 <= #speed_at_times then
		local num_4 = speed_at_times[num_3].time_in_dodge - speed_at_times[current_speed_setting_index].time_in_dodge
		local num_5 = (num - speed_at_times[current_speed_setting_index].time_in_dodge) / num_4

		self.speed = math.lerp(speed_at_times[current_speed_setting_index].speed, speed_at_times[num_3].speed, num_5) * speed_modifier * get_dodge_cooldown
	else
		self.speed = speed_at_times[current_speed_setting_index].speed * speed_modifier * get_dodge_cooldown
	end

	local current_rotation = self._first_person_extension:current_rotation()
	local look = Quaternion.look(Vector3.flat(Quaternion.forward(current_rotation)), Vector3.up())
	local rotate = Quaternion.rotate(look, self.dodge_direction:unbox())

	self._locomotion_extension:set_wanted_velocity(rotate * self.speed)

	local num_6 = self.speed * arg_6_2

	self.distance_supposed_to_move = num_6
	self.distance_left = self.distance_left - num_6

	return true
end

EnemyCharacterStateDodging.get_is_dodging = function (self)
	-- function 7
	local dodge_timer = self.dodge_timer

	if not dodge_timer then
		dodge_timer = self.dodge_stand_still_timer
		dodge_timer = dodge_timer or self.dodge_return_timer
	end

	return dodge_timer
end

EnemyCharacterStateDodging.start_dodge = function (self, arg_8_1, arg_8_2)
	-- function 8
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_8_1)
	local network = Managers.state.network

	if not (not network:game() and LEVEL_EDITOR_TEST) then
		local unit_game_object_id = network:unit_game_object_id(arg_8_1)

		self._status_extension:set_is_dodging(true)
		network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_game_object_id, 0)
	end

	assert(#get_movement_settings_table.dodging.speed_at_times > 1, "not enough speed at times in movementsettings")

	self.current_speed_setting_index = 1
	self.speed = get_movement_settings_table.dodging.speed_at_times[self.current_speed_setting_index].speed
	self.distance_supposed_to_move = 0
	self.time_in_dodge = 0
	self.distance_left = get_movement_settings_table.dodging.distance * get_movement_settings_table.dodging.distance_modifier * self._status_extension:get_dodge_cooldown()

	self.last_position:store(Unit.world_position(arg_8_1, 0))
	self:calculate_dodge_total_time(arg_8_1)
end

EnemyCharacterStateDodging.calculate_dodge_total_time = function (self, arg_9_1)
	-- function 9
	local num = 0.016666666666666666
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_9_1)
	local flag = true
	local num_2 = 0
	local num_3 = 1
	local num_4 = 0
	local dodge_fatigue = self.dodge_fatigue
	local get_dodge_cooldown = self._status_extension:get_dodge_cooldown()
	local speed_modifier = get_movement_settings_table.dodging.speed_modifier
	local num_5 = get_movement_settings_table.dodging.distance_modifier * get_dodge_cooldown
	local num_6 = get_movement_settings_table.dodging.speed_at_times[1].speed * speed_modifier * get_dodge_cooldown

	while not flag do
		num_2 = num_2 + num

		local speed_at_times = get_movement_settings_table.dodging.speed_at_times
		local flag_2 = false
		local num_7 = num_3 + 1

		num_3 = #speed_at_times

		for i = num_7, #speed_at_times do
			if num_2 <= speed_at_times[i].time_in_dodge then
				num_3 = i - 1

				break
			end
		end

		local num_8 = num_3 + 1

		if num_8 <= #speed_at_times then
			local num_9 = speed_at_times[num_8].time_in_dodge - speed_at_times[num_3].time_in_dodge
			local num_10 = (num_2 - speed_at_times[num_3].time_in_dodge) / num_9

			num_6 = math.lerp(speed_at_times[num_3].speed, speed_at_times[num_8].speed, num_10) * speed_modifier * get_dodge_cooldown
		else
			num_6 = speed_at_times[num_3].speed * speed_modifier
		end

		num_4 = num_4 + num_6 * num

		if num_4 > get_movement_settings_table.dodging.distance * num_5 * get_dodge_cooldown then
			flag = false
		end
	end

	self.estimated_dodge_time = num_2
end
