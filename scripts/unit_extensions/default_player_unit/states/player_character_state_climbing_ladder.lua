-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_climbing_ladder.lua

PlayerCharacterStateClimbingLadder = class(PlayerCharacterStateClimbingLadder, PlayerCharacterState)

PlayerCharacterStateClimbingLadder.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "climbing_ladder")

	local var_1_0 = arg_1_1

	self.lerp_target_position = Vector3Box()
	self.lerp_start_position = Vector3Box()
end

PlayerCharacterStateClimbingLadder.on_enter_animation_event = function (self)
	-- function 2
	local unit = self.unit
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local var_2_2 = POSITION_LOOKUP[unit]
	local z = Vector3.z(var_2_2)

	if math.abs(self.jump_off_height - z) < get_movement_settings_table.ladder.animation_distance_threshold_from_top_node then
		self.entered_top = true

		CharacterStateHelper.play_animation_event(unit, "climb_top_enter_ladder")
	else
		self.entered_top = false

		CharacterStateHelper.play_animation_event(unit, "climb_enter_ladder")
	end

	self.first_person_extension:play_animation_event("climb_enter_ladder")
end

PlayerCharacterStateClimbingLadder.on_enter = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local unit = self.unit
	local input_extension = self.input_extension
	local first_person_extension = self.first_person_extension
	local ladder_unit = arg_3_7.ladder_unit

	table.clear(self.temp_params)

	self.accumilated_distance = 0
	self.ladder_unit = ladder_unit
	self.movement_speed = 1
	self.animation_state = "no_animation"

	local get_data = Unit.get_data(ladder_unit, "sfx_footstep_event")

	get_data = get_data or "player_footstep_ladder"
	self.climb_sfx_event = get_data

	local node = Unit.node(ladder_unit, "c_platform")

	self.jump_off_height = Vector3.z(Unit.world_position(ladder_unit, node))

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:enable_script_driven_ladder_movement()
	locomotion_extension:enable_rotation_towards_velocity(false, Unit.local_rotation(ladder_unit, 0), 0.5)

	local world_position = Unit.world_position(self.ladder_unit, 0)

	self.ladder_position_height = Vector3.z(world_position)

	if arg_3_6 ~= "enter_ladder_top" then
		CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "ladder")
		CharacterStateHelper.stop_career_abilities(self.career_extension, "ladder")

		local unit_game_object_id = Managers.state.network:unit_game_object_id(unit)
		local flag = false

		CharacterStateHelper.show_inventory_3p(unit, false, flag, self.is_server, self.inventory_extension)
		self.first_person_extension:hide_weapons("climbing")
		self:on_enter_animation_event()
		CharacterStateHelper.set_is_on_ladder(ladder_unit, unit, true, self.is_server, self.status_extension)
	end

	locomotion_extension:set_mover_filter_property("ladder", true)
end

PlayerCharacterStateClimbingLadder.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local locomotion_extension = self.locomotion_extension

	if not (not arg_4_6 and arg_4_6 == "leaving_ladder_top") then
		local status_extension = self.status_extension

		status_extension:set_falling_height(true)
		status_extension:set_left_ladder(arg_4_5)

		local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_4_1)
		local flag = false

		CharacterStateHelper.show_inventory_3p(arg_4_1, true, flag, self.is_server, self.inventory_extension)
		locomotion_extension:enable_script_driven_movement()
		locomotion_extension:enable_rotation_towards_velocity(true)
		self.first_person_extension:unhide_weapons("climbing")

		if not Managers.state.network:game() then
			CharacterStateHelper.play_animation_event(arg_4_1, "climb_end_ladder")
		end

		self.first_person_extension:play_animation_event("idle")

		if not Managers.state.network:game() then
			CharacterStateHelper.set_is_on_ladder(self.ladder_unit, arg_4_1, false, self.is_server, self.status_extension)
		end
	end

	locomotion_extension:set_mover_filter_property("ladder", false)
end

PlayerCharacterStateClimbingLadder.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension
	local player = self.player

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	local z = locomotion_extension:current_velocity().z

	if not (not CharacterStateHelper.is_colliding_down(unit) and not (z < 0)) then
		csm:change_state("walking")

		return
	end

	local is_shaking = ScriptUnit.extension(self.ladder_unit, "ladder_system"):is_shaking()

	if csm.state_next or input_extension:get("jump") or input_extension:get("jump_only") or not is_shaking then
		local temp_params = self.temp_params

		temp_params.ladder_unit = self.ladder_unit
		temp_params.shaking_ladder_unit = self.ladder_unit

		csm:change_state("jumping", temp_params)

		return
	end

	local is_colliding_with_gameplay_collision_box, var_5_10 = CharacterStateHelper.is_colliding_with_gameplay_collision_box(self.world, unit, "filter_ladder_collision")
	local z_2 = self.locomotion_extension:current_velocity().z
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local flag = self.jump_off_height - get_movement_settings_table.ladder.leaving_ladder_height_below_get_of_node <= Vector3.z(Unit.world_position(unit, 0))

	if not self.position_lerp_timer then
		if not (not flag and not (z_2 > 0)) then
			local temp_params_2 = self.temp_params

			temp_params_2.ladder_unit = self.ladder_unit

			csm:change_state("leaving_ladder_top", temp_params_2)

			return
		elseif not is_colliding_with_gameplay_collision_box then
			if not (not flag and not (z_2 > 0)) then
				local temp_params_3 = self.temp_params

				temp_params_3.ladder_unit = self.ladder_unit

				csm:change_state("leaving_ladder_top", temp_params_3)
			else
				csm:change_state("falling")
			end

			return
		end
	end

	local get_movement_settings_table_2 = PlayerUnitMovementSettings.get_movement_settings_table(unit)

	if not CharacterStateHelper.has_move_input(input_extension) then
		self.movement_speed = math.min(1, self.movement_speed + get_movement_settings_table_2.ladder.climb_move_acceleration_up * arg_5_3)
	else
		self.movement_speed = math.max(0, self.movement_speed - get_movement_settings_table_2.ladder.climb_move_acceleration_down * arg_5_3)
	end

	local current_move_speed_multiplier = status_extension:current_move_speed_multiplier()
	local num = get_movement_settings_table_2.ladder.climb_speed * current_move_speed_multiplier * get_movement_settings_table_2.ladder.player_ladder_speed_scale * self.movement_speed
	local local_rotation = Unit.local_rotation(self.ladder_unit, 0)
	local world_position = Unit.world_position(self.ladder_unit, 0)
	local num_2 = Vector3.dot(-Quaternion.forward(local_rotation), POSITION_LOOKUP[unit] - world_position) + get_movement_settings_table_2.ladder.climb_attach_to_ladder_position_in_ladder_space_y

	self:_move_on_ladder(self.first_person_extension, local_rotation, input_extension, self.locomotion_extension, unit, num, num_2)

	local time_in_ladder_move_animation = CharacterStateHelper.time_in_ladder_move_animation(unit, world_position.z)
	local animation_find_variable = Unit.animation_find_variable(unit, "climb_time")

	Unit.animation_set_variable(unit, animation_find_variable, time_in_ladder_move_animation)

	local degrees_to_radians = math.degrees_to_radians(get_movement_settings_table_2.ladder.look_horizontal_max_degrees)

	CharacterStateHelper.look_limited_rotation_freedom(input_extension, player.viewport_name, self.first_person_extension, unit, local_rotation, degrees_to_radians, degrees_to_radians, status_extension, self.inventory_extension)
	self:on_ladder_animation()

	self.accumilated_distance = self.accumilated_distance + math.abs(z_2) * arg_5_3

	if not (player.bot_player or not (self.accumilated_distance > 1)) then
		self.accumilated_distance = 0

		local world_position_2 = Unit.world_position(unit, 0)
		local make_position_auto_source, var_5_27 = WwiseUtils.make_position_auto_source(self.world, world_position_2)

		WwiseWorld.trigger_event(var_5_27, self.climb_sfx_event, make_position_auto_source)
	end
end

PlayerCharacterStateClimbingLadder._move_on_ladder = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	-- function 6
	local get_square_movement_input = CharacterStateHelper.get_square_movement_input(arg_6_3)
	local x = Vector3.x(get_square_movement_input)
	local y = Vector3.y(get_square_movement_input)
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_5)
	local mover = Unit.mover(arg_6_5)
	local var_6_5
	local collides_down = Mover.collides_down(mover)

	if not (not collides_down and not (y <= 0)) then
		var_6_5 = Vector3(x, y, 0)
	else
		local get_first_person_unit = arg_6_1:get_first_person_unit()
		local local_rotation = Unit.local_rotation(get_first_person_unit, 0)
		local num = Quaternion.pitch(local_rotation) + get_movement_settings_table.ladder.climb_pitch_offset

		if not (not collides_down and not (num < 0) or not (y > 0)) then
			num = 0
		end

		local degrees_to_radians = math.degrees_to_radians(get_movement_settings_table.ladder.climb_speed_lerp_interval)
		local clamp = math.clamp(math.auto_lerp(-degrees_to_radians, degrees_to_radians, -1, 1, num), -1, 1)

		if not (y > 0 or not (y < 0) or collides_down) then
			local var_6_12

			if clamp > 0 then
				var_6_12 = 1 - (1 - clamp) * (1 - clamp)
			else
				var_6_12 = -1 + (-1 - clamp) * (-1 - clamp)
			end

			y = y * var_6_12
		end

		if not collides_down then
			if y > 0 then
				var_6_5 = Vector3(x * get_movement_settings_table.ladder.climb_horizontals_multiplier, 0, y)
			else
				var_6_5 = Vector3(x, y, 0)
			end
		else
			if Vector3.dot(Quaternion.forward(local_rotation), Quaternion.forward(arg_6_2)) < 0 then
				x = -x
			end

			var_6_5 = Vector3(x * get_movement_settings_table.ladder.climb_horizontals_multiplier, 0, y)
		end
	end

	local rotate = Quaternion.rotate(arg_6_2, var_6_5)

	arg_6_4:set_wanted_velocity(rotate * arg_6_6 + arg_6_7 * Quaternion.forward(arg_6_2) * 4)
end

PlayerCharacterStateClimbingLadder.on_ladder_animation = function (self)
	-- function 7
	local unit = self.unit
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)

	if self.locomotion_extension:current_velocity().z == 0 then
		if self.animation_state ~= "animation_idle" then
			self.animation_state = "animation_idle"

			local time_in_ladder_move_animation = CharacterStateHelper.time_in_ladder_move_animation(unit, self.ladder_position_height)

			if time_in_ladder_move_animation <= get_movement_settings_table.ladder.threshold_for_idle_right then
				CharacterStateHelper.play_animation_event(unit, "climb_idle_right_ladder")
			elseif time_in_ladder_move_animation <= get_movement_settings_table.ladder.threshold_for_idle_middle then
				CharacterStateHelper.play_animation_event(unit, "climb_idle_mid_ladder")
			elseif time_in_ladder_move_animation <= get_movement_settings_table.ladder.threshold_for_idle_left then
				CharacterStateHelper.play_animation_event(unit, "climb_idle_left_ladder")
			else
				CharacterStateHelper.play_animation_event(unit, "climb_idle_right_ladder")
			end
		end
	elseif self.animation_state ~= "animation_climbing" then
		self.animation_state = "animation_climbing"

		CharacterStateHelper.play_animation_event(unit, "climb_move_ladder")

		self.currently_playing_move_animation = true
	end
end
