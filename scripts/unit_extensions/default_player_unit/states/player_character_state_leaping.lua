-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_leaping.lua

PlayerCharacterStateLeaping = class(PlayerCharacterStateLeaping, PlayerCharacterState)

PlayerCharacterStateLeaping.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "leaping")

	self._direction = Vector3Box()
end

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerCharacterStateLeaping.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self.temp_params)

	local player = self.player
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local inventory_extension = self.inventory_extension
	local first_person_extension = self.first_person_extension

	self._wwise_world = Managers.world:wwise_world(self.world)
	self._physics_world = World.get_data(self.world, "physics_world")

	local do_leap = self.status_extension.do_leap

	do_leap.starting_pos = Vector3Box(POSITION_LOOKUP[arg_2_1])
	do_leap.total_distance = Vector3.length(do_leap.projected_hit_pos:unbox() - POSITION_LOOKUP[arg_2_1])
	self._leap_data = do_leap
	status_extension.do_leap = false

	local current_rotation = first_person_extension:current_rotation()
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(current_rotation)))

	self._move_function = self[do_leap.move_function]
	self.jump_direction = Vector3Box(normalize)

	self:_start_leap(arg_2_1, arg_2_5)
	CharacterStateHelper.look(input_extension, player.viewport_name, first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, input_extension, inventory_extension, self.health_extension)
	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	if not player and player.remote or not Managers.state.network:game() then
		local go_id = Managers.state.unit_storage:go_id(self.unit)

		Managers.state.network.network_transmit:send_rpc_server("rpc_leap_start", go_id)
	end

	self._time_slided = 0
	self._play_landing_event = true
	self._played_landing_event = false
	self._last_slam_vertical_distance = 0
end

PlayerCharacterStateLeaping.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self:_reset_speed_and_gravity(arg_3_1)

	if not (arg_3_6 == "walking" or arg_3_6 ~= "standing") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	elseif not (not arg_3_6 and arg_3_6 == "falling") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end

	local player = self.player

	if not player and player.remote or not Managers.state.network:game() then
		local go_id = Managers.state.unit_storage:go_id(arg_3_1)

		Managers.state.network.network_transmit:send_rpc_server("rpc_leap_finished", go_id)
	end

	if not arg_3_6 and arg_3_6 == "falling" or not Managers.state.network:game() then
		CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
		CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")
	end

	if arg_3_6 == "catapulted" then
		self:_finish(arg_3_1, arg_3_5, true)
	end
end

PlayerCharacterStateLeaping.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local locomotion_extension = self.locomotion_extension
	local inventory_extension = self.inventory_extension
	local health_extension = self.health_extension

	self:_update_distance_travelled()

	local leap_events = self._leap_data.leap_events

	if not leap_events then
		local var_4_8 = leap_events[1]
		local _total_distance = self._total_distance
		local _distance_travelled = self._distance_travelled

		while not var_4_8 do
			if _distance_travelled >= _total_distance * var_4_8.distance_percentage then
				var_4_8.event_function(self)
				table.remove(leap_events, 1)

				var_4_8 = leap_events[1]
			else
				break
			end
		end
	end

	local flag = false

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		flag = true
	end

	if not CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("using_transport")

		flag = true
	end

	if not CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		flag = true
	end

	if not CharacterStateHelper.is_pushed(status_extension) then
		status_extension:set_pushed(false)
	end

	if not CharacterStateHelper.is_block_broken(status_extension) then
		status_extension:set_block_broken(false)
	end

	local _update_movement, var_4_13 = self:_update_movement(arg_4_1, arg_4_3, arg_4_5)

	if not flag then
		if not leap_events then
			local finished = leap_events.finished

			if not finished then
				finished(self, true, var_4_13 or POSITION_LOOKUP[arg_4_1])
			end
		end

		return
	end

	if not _update_movement then
		self:_finish(arg_4_1, arg_4_5, false, var_4_13)

		if not locomotion_extension:is_on_ground() then
			csm:change_state("walking", self.temp_params)
			first_person_extension:change_state("walking")

			return
		end

		if not (self.csm.state_next or not (locomotion_extension:current_velocity().z <= 0)) then
			csm:change_state("falling", self.temp_params)
			first_person_extension:change_state("falling")

			return
		end
	end

	local var_4_15
	local var_4_16

	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, inventory_extension, var_4_15, var_4_16)
	CharacterStateHelper.update_weapon_actions(arg_4_5, arg_4_1, input_extension, inventory_extension, health_extension)
end

PlayerCharacterStateLeaping._update_distance_travelled = function (self)
	-- function 5
	local unit = self.unit
	local _leap_data = self._leap_data
	local var_5_2 = POSITION_LOOKUP[unit]
	local unbox = _leap_data.starting_pos:unbox()
	local unbox_2 = _leap_data.projected_hit_pos:unbox()
	local flat = Vector3.flat(var_5_2 - unbox)
	local flat_2 = Vector3.flat(unbox_2 - unbox)
	local dot = Vector3.dot(flat, flat_2)
	local length = Vector3.length(flat_2)

	self._total_distance = length
	self._distance_travelled = dot / length
end

local function fn(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return (math.clamp(arg_6_2, arg_6_0, arg_6_1) - arg_6_0) / (arg_6_1 - arg_6_0)
end

PlayerCharacterStateLeaping.leap = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local locomotion_extension = self.locomotion_extension
	local var_7_1 = POSITION_LOOKUP[arg_7_1]
	local unbox = self._leap_data.starting_pos:unbox()
	local unbox_2 = self._leap_data.projected_hit_pos:unbox()
	local _total_distance = self._total_distance
	local _distance_travelled = self._distance_travelled
	local num = unbox.z - var_7_1.z
	local normalize = Vector3.normalize(self._leap_data.direction:unbox())
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_7_1)
	local speed = self._leap_data.speed
	local current_move_speed_multiplier = self.status_extension:current_move_speed_multiplier()
	local num_2 = speed * current_move_speed_multiplier * current_move_speed_multiplier * get_movement_settings_table.player_speed_scale
	local num_3 = _total_distance * 0
	local num_4 = _total_distance * 0.1
	local num_5 = _total_distance * 0.2
	local num_6 = _total_distance * 0.5
	local num_7 = _total_distance * 0.7
	local num_8 = _total_distance * 1

	if _distance_travelled <= num_4 then
		local var_7_18 = fn(num_3, num_4, _distance_travelled)
		local ease_out_exp = math.ease_out_exp(var_7_18)

		num_2 = num_2 * math.lerp(0, 1, ease_out_exp)

		local num_9 = 0.25

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_9

		local clamp = math.clamp(get_movement_settings_table.leap.move_speed, 0, PlayerUnitMovementSettings.leap.move_speed)
		local current_velocity = locomotion_extension:current_velocity()
		local num_10 = (Vector3.normalize(current_velocity) + normalize) * num_2
		local length = Vector3.length(num_10)
		local clamp_2 = math.clamp(length, 0, clamp * get_movement_settings_table.player_speed_scale)
		local normalize_2 = Vector3.normalize(num_10)

		locomotion_extension:set_wanted_velocity(normalize_2 * clamp_2)
	elseif _distance_travelled <= num_5 then
		local var_7_27 = fn(num_4, num_5, _distance_travelled)
		local easeOutCubic = math.easeOutCubic(var_7_27)

		num_2 = num_2 * math.lerp(1, 0.8, easeOutCubic)

		local num_11 = 0.5

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_11

		local clamp_3 = math.clamp(get_movement_settings_table.leap.move_speed, 0, PlayerUnitMovementSettings.leap.move_speed)
		local current_velocity_2 = locomotion_extension:current_velocity()
		local num_12 = (Vector3.normalize(current_velocity_2) + normalize) * num_2
		local length_2 = Vector3.length(num_12)
		local clamp_4 = math.clamp(length_2, 0, clamp_3 * get_movement_settings_table.player_speed_scale)
		local normalize_3 = Vector3.normalize(num_12)

		locomotion_extension:set_wanted_velocity(normalize_3 * clamp_4)
	elseif _distance_travelled <= num_6 then
		local var_7_36 = fn(num_5, num_6, _distance_travelled)
		local ease_in_exp = math.ease_in_exp(var_7_36)

		num_2 = num_2 * math.lerp(0.8, 0.7, ease_in_exp)

		local num_13 = 1

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_13

		local clamp_5 = math.clamp(get_movement_settings_table.leap.move_speed, 0, PlayerUnitMovementSettings.leap.move_speed)
		local current_velocity_3 = locomotion_extension:current_velocity()
		local num_14 = (Vector3.normalize(current_velocity_3) + normalize) * num_2
		local length_3 = Vector3.length(num_14)
		local clamp_6 = math.clamp(length_3, 0, clamp_5 * get_movement_settings_table.player_speed_scale)
		local normalize_4 = Vector3.normalize(num_14)

		locomotion_extension:set_wanted_velocity(normalize_4 * clamp_6)
	elseif _distance_travelled <= num_7 then
		local var_7_45 = fn(num_6, num_7, _distance_travelled)
		local ease_out_quad = math.ease_out_quad(var_7_45)

		num_2 = num_2 * math.lerp(0.7, 0.5, ease_out_quad)
		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * ease_out_quad

		local clamp_7 = math.clamp(get_movement_settings_table.leap.move_speed, 0, PlayerUnitMovementSettings.leap.move_speed)
		local current_velocity_4 = locomotion_extension:current_velocity()
		local num_15 = (Vector3.normalize(current_velocity_4) + normalize) * num_2
		local length_4 = Vector3.length(num_15)
		local clamp_8 = math.clamp(length_4, 0, clamp_7 * get_movement_settings_table.player_speed_scale)
		local normalize_5 = Vector3.normalize(num_15)

		locomotion_extension:set_wanted_velocity(normalize_5 * clamp_8)
	else
		local var_7_53 = fn(num_7, num_8, _distance_travelled)
		local ease_out_quad_2 = math.ease_out_quad(var_7_53)
		local num_16 = num_2 * math.lerp(0.5, 1.5, ease_out_quad_2)
		local lerp = math.lerp(0.25, 0, ease_out_quad_2)
		local lerp_2 = math.lerp(0, 0.75, ease_out_quad_2)
		local num_17 = 1.5

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_17

		local clamp_9 = math.clamp(get_movement_settings_table.leap.slam_speed, 0, PlayerUnitMovementSettings.leap.slam_speed)
		local current_velocity_5 = locomotion_extension:current_velocity()
		local num_18 = Vector3.normalize(Vector3.flat(normalize)) * lerp + Vector3.normalize(unbox_2 - var_7_1) * lerp_2
		local num_19 = (Vector3.normalize(current_velocity_5) + num_18) * num_16
		local length_5 = Vector3.length(num_19)
		local clamp_10 = math.clamp(length_5, 0, clamp_9 * get_movement_settings_table.player_speed_scale)
		local normalize_6 = Vector3.normalize(num_19)

		locomotion_extension:set_forced_velocity(normalize_6 * clamp_10)
		locomotion_extension:set_wanted_velocity(normalize_6 * clamp_10)

		local clamp_11 = math.clamp(num, 0, math.huge)

		if clamp_11 < self._last_slam_vertical_distance then
			self._play_landing_event = false

			return true, var_7_1
		end

		self._last_slam_vertical_distance = clamp_11
	end

	if num_8 < _distance_travelled then
		return true, var_7_1
	end

	return false
end

PlayerCharacterStateLeaping.teleleap = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local locomotion_extension = self.locomotion_extension
	local var_8_1 = POSITION_LOOKUP[arg_8_1]
	local unbox = self._leap_data.starting_pos:unbox()
	local unbox_2 = self._leap_data.projected_hit_pos:unbox()
	local _total_distance = self._total_distance
	local _distance_travelled = self._distance_travelled
	local normalize = Vector3.normalize(self._leap_data.direction:unbox())
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_8_1)
	local speed = self._leap_data.speed
	local current_move_speed_multiplier = self.status_extension:current_move_speed_multiplier()
	local num = speed * current_move_speed_multiplier * current_move_speed_multiplier * get_movement_settings_table.player_speed_scale
	local num_2 = _total_distance * 0
	local num_3 = _total_distance * 0.05
	local num_4 = _total_distance * 0.2
	local num_5 = _total_distance * 0.5
	local num_6 = _total_distance * 1
	local var_8_16 = fn(num_2, num_6, _distance_travelled)

	if _distance_travelled <= num_3 then
		local var_8_17 = fn(num_2, num_3, _distance_travelled)
		local ease_out_exp = math.ease_out_exp(var_8_17)

		num = num * math.lerp(0, 0.25, ease_out_exp)

		local lerp = math.lerp(5.5, 3, ease_out_exp)

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * lerp

		local clamp = math.clamp(get_movement_settings_table.teleleap.move_speed, 0, PlayerUnitMovementSettings.teleleap.move_speed)
		local current_velocity = locomotion_extension:current_velocity()
		local num_7 = (Vector3.normalize(current_velocity) + normalize) * num
		local length = Vector3.length(num_7)
		local clamp_2 = math.clamp(length, 0, clamp * get_movement_settings_table.player_speed_scale)
		local normalize_2 = Vector3.normalize(num_7)

		locomotion_extension:set_wanted_velocity(normalize_2 * clamp_2)
	elseif _distance_travelled <= num_4 then
		local var_8_26 = fn(num_3, num_4, _distance_travelled)
		local easeOutCubic = math.easeOutCubic(var_8_26)

		num = num * math.lerp(0.25, 3.5, easeOutCubic)

		local lerp_2 = math.lerp(0.75, 0.25, var_8_16)
		local lerp_3 = math.lerp(0, 0.75, var_8_16)
		local num_8 = 0.5

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_8

		local clamp_3 = math.clamp(get_movement_settings_table.teleleap.move_speed, 0, PlayerUnitMovementSettings.teleleap.move_speed)
		local current_velocity_2 = locomotion_extension:current_velocity()
		local num_9 = Vector3.normalize(Vector3.flat(normalize)) * lerp_2 + Vector3.normalize(unbox_2 - var_8_1) * lerp_3
		local num_10 = (Vector3.normalize(current_velocity_2) + num_9) * num
		local length_2 = Vector3.length(num_10)
		local clamp_4 = math.clamp(length_2, 0, clamp_3 * get_movement_settings_table.player_speed_scale)
		local normalize_3 = Vector3.normalize(num_10)

		locomotion_extension:set_forced_velocity(normalize_3 * clamp_4)
		locomotion_extension:set_wanted_velocity(normalize_3 * clamp_4)
	elseif _distance_travelled <= num_5 then
		local var_8_38 = fn(num_4, num_5, _distance_travelled)
		local ease_in_exp = math.ease_in_exp(var_8_38)
		local num_11 = num * math.lerp(3.5, 5.5, ease_in_exp)
		local lerp_4 = math.lerp(0.25, 0.25, var_8_16)
		local lerp_5 = math.lerp(0.75, 1, var_8_16)
		local num_12 = 1

		get_movement_settings_table.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * num_12

		local clamp_5 = math.clamp(get_movement_settings_table.teleleap.move_speed, 0, PlayerUnitMovementSettings.teleleap.move_speed)
		local current_velocity_3 = locomotion_extension:current_velocity()
		local num_13 = Vector3.normalize(Vector3.flat(normalize)) * lerp_4 + Vector3.normalize(unbox_2 - var_8_1) * lerp_5
		local num_14 = (Vector3.normalize(current_velocity_3) + num_13) * num_11
		local length_3 = Vector3.length(num_14)
		local clamp_6 = math.clamp(length_3, 0, clamp_5 * get_movement_settings_table.player_speed_scale)
		local normalize_4 = Vector3.normalize(num_14)

		locomotion_extension:set_forced_velocity(normalize_4 * clamp_6)
		locomotion_extension:set_wanted_velocity(normalize_4 * clamp_6)
	else
		local _teleport_to_with_collision = self:_teleport_to_with_collision(var_8_1, unbox_2, nil, "filter_mover_blocker")

		return true, _teleport_to_with_collision
	end

	return false
end

PlayerCharacterStateLeaping._teleport_to_with_collision = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local locomotion_extension = self.locomotion_extension
	local _physics_world = self._physics_world
	local num = 1
	local num_2 = 20
	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(_physics_world, arg_9_1, arg_9_2, num, num_2, "collision_filter", arg_9_4, "report_initial_overlap")
	local var_9_5

	if not linear_sphere_sweep then
		var_9_5 = arg_9_2
	else
		var_9_5 = arg_9_1
	end

	locomotion_extension:teleport_to(var_9_5, arg_9_3)

	return var_9_5
end

PlayerCharacterStateLeaping._update_movement = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not self._leap_done then
		return self._leap_done, self._final_position:unbox()
	end

	local num = 0.016666666666666666
	local num_2 = 0
	local var_10_2
	local var_10_3

	while not (var_10_2 or not (num_2 < arg_10_2)) do
		local min = math.min(num, arg_10_2 - num_2)

		num_2 = math.min(num_2 + num, arg_10_2)
		var_10_2, var_10_3 = self:_move_function(arg_10_1, min, arg_10_3)
	end

	local is_colliding_down = CharacterStateHelper.is_colliding_down(arg_10_1)

	self._leap_done = var_10_2 or is_colliding_down
	self._final_position = Vector3Box(not var_10_2 and var_10_3 and POSITION_LOOKUP[arg_10_1])

	return self._leap_done, var_10_3
end

PlayerCharacterStateLeaping._reset_speed_and_gravity = function (self, arg_11_1)
	-- function 11
	local locomotion_extension = self.locomotion_extension

	PlayerUnitMovementSettings.get_movement_settings_table(arg_11_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration

	locomotion_extension:set_forced_velocity(Vector3.zero())
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:reset_maximum_upwards_velocity()
	locomotion_extension:set_external_velocity_enabled(true)
end

PlayerCharacterStateLeaping._finish = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local locomotion_extension = self.locomotion_extension
	local first_person_extension = self.first_person_extension
	local _leap_data = self._leap_data
	local _play_landing_event = self._play_landing_event

	self:_reset_speed_and_gravity(arg_12_1)

	if not _play_landing_event then
		locomotion_extension:force_on_ground(true)

		if not _leap_data.camera_effect_sequence_land then
			first_person_extension:play_camera_effect_sequence(_leap_data.camera_effect_sequence_land, arg_12_2)
		end

		local sfx_event_land = _leap_data.sfx_event_land

		if not (not sfx_event_land and self._played_landing_event) then
			first_person_extension:play_unit_sound_event(sfx_event_land, arg_12_1, 0, true)

			self._played_landing_event = true
		end
	end

	local leap_events = _leap_data.leap_events

	if not leap_events then
		local finished = leap_events.finished

		if not finished then
			finished(self, arg_12_3 or not _play_landing_event, arg_12_4 or POSITION_LOOKUP[arg_12_1])
		end
	end

	self._leap_done = true
end

PlayerCharacterStateLeaping._start_leap = function (self, arg_13_1, arg_13_2)
	-- function 13
	local locomotion_extension = self.locomotion_extension
	local first_person_extension = self.first_person_extension
	local _leap_data = self._leap_data

	if not _leap_data.camera_effect_sequence_start then
		first_person_extension:play_camera_effect_sequence(_leap_data.camera_effect_sequence_start, arg_13_2)
	end

	if not _leap_data.anim_start_event_1p then
		CharacterStateHelper.play_animation_event_first_person(first_person_extension, _leap_data.anim_start_event_1p)
	end

	if not _leap_data.anim_start_event_3p then
		CharacterStateHelper.play_animation_event(arg_13_1, _leap_data.anim_start_event_3p)
	end

	local sfx_event_jump = self._leap_data.sfx_event_jump

	if not sfx_event_jump then
		first_person_extension:play_unit_sound_event(sfx_event_jump, arg_13_1, 0, true)
	end

	local num = _leap_data.direction:unbox() * _leap_data.initial_vertical_speed + Vector3.up()

	locomotion_extension:set_maximum_upwards_velocity(num.z)
	locomotion_extension:force_on_ground(false)
	locomotion_extension:set_forced_velocity(num)
	locomotion_extension:set_wanted_velocity(num)

	PlayerUnitMovementSettings.get_movement_settings_table(arg_13_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * 0

	local leap_events = _leap_data.leap_events

	if not leap_events then
		local start = leap_events.start

		if not start then
			start(self)
		end
	end

	self._leap_done = false
end
