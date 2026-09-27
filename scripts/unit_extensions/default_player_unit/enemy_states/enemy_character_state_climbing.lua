-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_climbing.lua

EnemyCharacterStateClimbing = class(EnemyCharacterStateClimbing, EnemyCharacterStateAnimatedJump)

local function fn(self)
	-- function 1
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

EnemyCharacterStateClimbing.init = function (arg_2_0, arg_2_1)
	-- function 2
	EnemyCharacterStateClimbing.super.init(arg_2_0, arg_2_1, "climbing")
end

EnemyCharacterStateClimbing.setup_transition = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self.smart_object_data = arg_3_2

	local var_3_0 = POSITION_LOOKUP[arg_3_1]

	arg_3_3.z = var_3_0.z

	local unbox = Vector3Aux.unbox(arg_3_2.ledge_position)

	self._ledge_position = Vector3Box(unbox)
	self._entrance_pos = Vector3Box(arg_3_3)
	self._exit_pos = Vector3Box(arg_3_4)
	self._climb_upwards = true
	self.jump_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(arg_3_4 - arg_3_3)))

	local num = arg_3_3 - var_3_0
	local length = Vector3.length(num)
	local Vector3Box = Vector3Box
	local divide

	if length > 0 then
		divide = Vector3.divide(num, length)

		if not divide then
			-- Nothing
		end
	end

	divide = Vector3.zero()

	::label_3_0::

	self._correction_dir = Vector3Box(divide)
	self._correction_amount = length

	if not arg_3_2.is_on_edge then
		if not arg_3_2.ledge_position1 then
			local unbox_2 = Vector3Aux.unbox(arg_3_2.ledge_position1)
			local unbox_3 = Vector3Aux.unbox(arg_3_2.ledge_position2)
			local flag = not (Vector3.distance_squared(unbox_2, arg_3_3) < Vector3.distance_squared(unbox_3, arg_3_3)) or not unbox_2 or unbox_3

			self._climb_jump_height = flag.z - arg_3_3.z

			self._ledge_position:store(flag)
		else
			self._climb_jump_height = unbox.z - arg_3_3.z

			if self._climb_jump_height < 0 then
				arg_3_2.is_on_edge = true
			end
		end
	end

	if not arg_3_2.is_on_edge then
		if arg_3_3.z > arg_3_4.z then
			self._climb_jump_height = arg_3_3.z - arg_3_4.z
			self._climb_upwards = false
		else
			self._climb_jump_height = arg_3_4.z - arg_3_3.z
		end
	end

	self._sub_state = "moving_to_to_entrance"
end

EnemyCharacterStateClimbing.do_the_transition = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local var_4_0 = POSITION_LOOKUP[arg_4_1]
	local var_4_1 = BLACKBOARDS[arg_4_1]
	local is_on_edge = self.smart_object_data.is_on_edge

	if self._sub_state == "moving_to_to_entrance" then
		local unbox = self._entrance_pos:unbox()
		local unbox_2 = self._exit_pos:unbox()

		arg_4_4:enable_animation_driven_movement_entrance_and_exit_no_mover(unbox, unbox_2)

		local unbox_3 = self.jump_ledge_lookat_direction:unbox()
		local look = Quaternion.look(unbox_3)

		self._first_person_extension:set_rotation(look)

		local var_4_7 = SmartObjectSettings.templates[self._breed.smart_object_template]

		if not (self._climb_upwards or is_on_edge) then
			local num = 1
			local jump_up_anim_thresholds = var_4_7.jump_up_anim_thresholds
			local _climb_jump_height = self._climb_jump_height

			for i = 1, #jump_up_anim_thresholds do
				local var_4_11 = jump_up_anim_thresholds[i]

				if _climb_jump_height < var_4_11.height_threshold then
					local animation_edge

					if not is_on_edge then
						animation_edge = var_4_11.animation_edge

						if not animation_edge then
							-- Nothing
						end
					end

					animation_edge = var_4_11.animation_fence

					::label_4_0::

					Managers.state.network:anim_event(arg_4_1, fn(animation_edge))

					local fence_vertical_length = var_4_11.fence_vertical_length

					fence_vertical_length = fence_vertical_length or var_4_11.vertical_length

					local vertical_length = var_4_11.vertical_length
					local flag = not is_on_edge and vertical_length and fence_vertical_length

					num = num * _climb_jump_height / flag

					arg_4_4:set_animation_translation_scale(Vector3(1, 1, num))

					break
				end
			end

			arg_4_4:set_wanted_velocity(Vector3.zero())

			self._sub_state = "waiting_for_finished_climb_anim"
		else
			local jump_down_anim_thresholds = var_4_7.jump_down_anim_thresholds
			local abs = math.abs(self._climb_jump_height)

			for j = 1, #jump_down_anim_thresholds do
				local var_4_18 = jump_down_anim_thresholds[j]

				if abs < var_4_18.height_threshold then
					local animation_edge_2

					if not is_on_edge then
						animation_edge_2 = var_4_18.animation_edge

						if not animation_edge_2 then
							-- Nothing
						end
					end

					animation_edge_2 = var_4_18.animation_fence

					::label_4_1::

					Managers.state.network:anim_event(arg_4_1, fn(animation_edge_2))

					local animation_land = var_4_18.animation_land

					animation_land = animation_land or "jump_down_land"
					self._jump_down_land_animation = fn(animation_land)

					break
				end
			end

			self._sub_state = "waiting_to_reach_ground"
		end
	end

	if self._sub_state == "waiting_for_finished_climb_anim" then
		self:_apply_position_correction(arg_4_1, var_4_0, arg_4_3)

		if not var_4_1.jump_climb_finished then
			var_4_1.jump_climb_finished = nil

			local unbox_4 = self._exit_pos:unbox()
			local flag_2 = not is_on_edge and unbox_4 and self._ledge_position:unbox()

			if not is_on_edge then
				self._sub_state = "done"
			else
				local jump_down_anim_thresholds_2 = SmartObjectSettings.templates[self._breed.smart_object_template].jump_down_anim_thresholds
				local num_2 = flag_2.z - unbox_4.z

				for k = 1, #jump_down_anim_thresholds_2 do
					local var_4_25 = jump_down_anim_thresholds_2[k]

					if num_2 < var_4_25.height_threshold then
						local num_3 = 1
						local fence_horizontal_length = var_4_25.fence_horizontal_length
						local num_4 = (Vector3.length(Vector3.flat(var_4_0 - unbox_4)) - var_4_25.fence_land_length) / (fence_horizontal_length * num_3)

						arg_4_4:set_animation_translation_scale(Vector3(num_4, num_4, 1))

						local animation_fence = var_4_25.animation_fence

						Managers.state.network:anim_event(arg_4_1, fn(animation_fence))

						local animation_land_2 = var_4_25.animation_land

						animation_land_2 = animation_land_2 or "jump_down_land"
						self._jump_down_land_animation = fn(animation_land_2)

						break
					end
				end

				self._sub_state = "waiting_to_reach_ground"
			end
		end
	end

	if self._sub_state == "waiting_to_reach_ground" then
		local unbox_5 = self._exit_pos:unbox()
		local current_velocity = arg_4_4:current_velocity()

		if var_4_0.z + current_velocity.z * arg_4_3 * 2 <= unbox_5.z then
			arg_4_4:set_animation_translation_scale(Vector3(1, 1, 1))

			local _jump_down_land_animation = self._jump_down_land_animation

			Managers.state.network:anim_event(arg_4_1, _jump_down_land_animation)

			self._sub_state = "done"
		end
	end

	if not (self._sub_state == "done" or not (arg_4_2 > self._fail_timer)) then
		if arg_4_2 > self._fail_timer then
			Application.warning("Breed " .. Unit.get_data(arg_4_1, "breed").name .. " failed to climb at position %q", self._entrance_pos:unbox())
		end

		return true
	end
end

EnemyCharacterStateClimbing._apply_position_correction = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local num = self._correction_amount * math.min(3 * arg_5_3, 1)

	self._correction_amount = self._correction_amount - num

	local num_2 = arg_5_2 + Vector3.multiply(self._correction_dir:unbox(), num)
	local mover = Unit.mover(arg_5_1)

	if not mover then
		Mover.set_position(mover, num_2)
		Unit.set_local_position(arg_5_1, 0, num_2)
	end
end
