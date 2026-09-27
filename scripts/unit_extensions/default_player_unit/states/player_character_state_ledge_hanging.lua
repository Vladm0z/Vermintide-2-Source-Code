-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_ledge_hanging.lua

PlayerCharacterStateLedgeHanging = class(PlayerCharacterStateLedgeHanging, PlayerCharacterState)

PlayerCharacterStateLedgeHanging.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "ledge_hanging")

	local var_1_0 = arg_1_1

	self.lerp_target_position = Vector3Box()
	self.lerp_start_position = Vector3Box()
end

PlayerCharacterStateLedgeHanging.on_enter_animation = function (self)
	-- function 2
	local unit = self.unit

	CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, "idle")
	CharacterStateHelper.play_animation_event(unit, "hanging")
end

PlayerCharacterStateLedgeHanging.change_to_third_person_camera = function (self)
	-- function 3
	CharacterStateHelper.change_camera_state(self.player, "follow_third_person_ledge")
	self.first_person_extension:set_first_person_mode(false)

	local flag = true

	CharacterStateHelper.show_inventory_3p(self.unit, false, flag, self.is_server, self.inventory_extension)
end

PlayerCharacterStateLedgeHanging.on_enter = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	-- function 4
	local unit = self.unit

	self.ledge_unit = arg_4_7.ledge_unit

	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "ledge_hanging")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "ledge_hanging")
	self.locomotion_extension:enable_script_driven_ladder_movement()
	self.locomotion_extension:set_forced_velocity(Vector3:zero())

	self.fall_down_time = arg_4_5 + PlayerUnitMovementSettings.get_movement_settings_table(unit).ledge_hanging.time_until_fall_down

	self:calculate_and_start_rotation_to_ledge()
	self:calculate_start_position()
	self:calculate_offset_rotation()
	self:on_enter_animation()
	self:change_to_third_person_camera()
	CharacterStateHelper.set_is_on_ledge(self.ledge_unit, unit, true, self.is_server, self.status_extension)
end

PlayerCharacterStateLedgeHanging.on_exit = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	self.rotate_timer_yaw = nil
	self.position_lerp_timer = nil
	self.start_rotation = nil

	if arg_5_6 ~= "leave_ledge_hanging_pull_up" then
		if arg_5_6 ~= "leave_ledge_hanging_falling" then
			CharacterStateHelper.change_camera_state(self.player, "follow")
			self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
		end

		local status_extension = self.status_extension

		self.locomotion_extension:enable_script_driven_movement()

		local flag = false

		CharacterStateHelper.show_inventory_3p(arg_5_1, true, flag, self.is_server, self.inventory_extension)

		if not Managers.state.network:game() then
			CharacterStateHelper.set_is_on_ledge(self.ledge_unit, arg_5_1, false, self.is_server, self.status_extension)
		end
	elseif not (arg_5_6 == "leave_ledge_hanging_pull_up" or arg_5_6 ~= "leave_ledge_hanging_falling") then
		CharacterStateHelper.change_camera_state(self.player, "follow_third_person")
	end
end

PlayerCharacterStateLedgeHanging.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local csm = self.csm
	local unit = self.unit
	local locomotion_extension = self.locomotion_extension
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension

	if status_extension:is_pulled_up() or not DebugKeyHandler.key_pressed("c", "pull up from ledge hanging", "player") then
		local temp_params = self.temp_params

		temp_params.ledge_unit = self.ledge_unit
		temp_params.start_rotation_box = self.start_rotation_box

		csm:change_state("leave_ledge_hanging_pull_up", temp_params)

		return
	end

	if arg_6_5 > self.fall_down_time or not CharacterStateHelper.is_knocked_down(status_extension) then
		local temp_params_2 = self.temp_params

		temp_params_2.ledge_unit = self.ledge_unit

		csm:change_state("leave_ledge_hanging_falling", temp_params_2)
		Unit.set_local_rotation(unit, 0, self.start_rotation_box:unbox())

		return
	end

	if not self.position_lerp_timer then
		self.position_lerp_timer = self.position_lerp_timer + arg_6_3

		local clamp = math.clamp(self.position_lerp_timer / self.time_for_position_lerp, 0, 1)
		local unbox = self.lerp_start_position:unbox()
		local num = unbox + (self.lerp_target_position:unbox() - unbox) * clamp

		locomotion_extension:teleport_to(num)

		if clamp == 1 then
			self.time_for_position_lerp = nil
			self.position_lerp_timer = nil
		end
	end

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm, "ledge_hanging") then
		return
	end

	self.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
	self.locomotion_extension:set_forced_velocity(Vector3:zero())
end

PlayerCharacterStateLedgeHanging.calculate_start_position = function (self)
	-- function 7
	local unit = self.unit
	local ledge_unit = self.ledge_unit
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local local_scale = Unit.local_scale(ledge_unit, 0)
	local node = Unit.node(ledge_unit, "g_gameplay_ledge_trigger_box")
	local world_position = Unit.world_position(ledge_unit, node)
	local world_rotation = Unit.world_rotation(ledge_unit, node)
	local local_position = Unit.local_position(unit, 0)
	local right = Quaternion.right(world_rotation)
	local num = local_position - world_position
	local dot = Vector3.dot(right, num)
	local node_2 = Unit.node(ledge_unit, "g_gameplay_ledge_finger_box")
	local world_position_2 = Unit.world_position(ledge_unit, node_2)
	local world_rotation_2 = Unit.world_rotation(ledge_unit, node_2)
	local local_scale_2 = Unit.local_scale(ledge_unit, node_2)
	local right_2 = Quaternion.right(world_rotation_2)
	local num_2 = (1 - 0.3 * (1 / local_scale.x) * (1 / local_scale_2.x)) * local_scale.x * local_scale_2.x
	local num_3 = world_position_2 - right_2 * num_2
	local num_4 = world_position_2 + right_2 * num_2
	local closest_point_on_line = Geometry.closest_point_on_line(local_position, num_3, num_4)
	local distance = Vector3.distance(local_position, closest_point_on_line)

	self.lerp_start_position:store(local_position)
	self.lerp_target_position:store(closest_point_on_line)

	self.time_for_position_lerp = distance * get_movement_settings_table.ledge_hanging.attach_position_lerp_time_per_meter
	self.position_lerp_timer = 0

	local num_5 = 0.5
	local num_6 = closest_point_on_line - Quaternion.forward(world_rotation) * num_5

	ScriptUnit.extension(unit, "whereabouts_system"):set_new_hang_ledge_position(num_6)
end

PlayerCharacterStateLedgeHanging.calculate_and_start_rotation_to_ledge = function (self)
	-- function 8
	local unit = self.unit
	local ledge_unit = self.ledge_unit
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local node = Unit.node(ledge_unit, "g_gameplay_ledge_finger_box")
	local world_rotation = Unit.world_rotation(ledge_unit, node)
	local yaw = Quaternion.yaw(world_rotation)
	local var_8_6 = Quaternion(Vector3.up(), yaw + math.pi)
	local forward = Quaternion.forward(var_8_6)

	self.start_rotation_box = QuaternionBox(Quaternion.look(-forward))

	Unit.set_local_rotation(unit, 0, var_8_6)
end

PlayerCharacterStateLedgeHanging.calculate_offset_rotation = function (self)
	-- function 9
	local unit = self.unit
	local ledge_unit = self.ledge_unit
	local local_rotation = Unit.local_rotation(unit, 0)
	local forward = Quaternion.forward(local_rotation)
	local unbox = self.lerp_target_position:unbox()
	local num = Vector3.up() * 0.25
	local num_2 = unbox + forward * 0.25 + num
	local physics_world = World.physics_world(self.world)
	local is_position_in_line_of_sight = PerceptionUtils.is_position_in_line_of_sight
	local num_3 = num_2 - Vector3.up() * 2.25
	local var_9_10, var_9_11 = is_position_in_line_of_sight(unit, num_2, num_3, physics_world)

	if not var_9_10 then
		local var_9_12
		local var_9_13
		local var_9_14
		local num_4 = 5

		for i = 1, num_4 do
			var_9_14 = num_3 + forward * 0.5 * i

			local var_9_16

			var_9_12, var_9_16 = is_position_in_line_of_sight(unit, num_2, var_9_14, physics_world)

			if not var_9_12 then
				break
			end
		end

		if not var_9_12 then
			local right = Quaternion.right(local_rotation)
			local normalize = Vector3.normalize(var_9_14 - unbox)
			local cross = Vector3.cross(right, normalize)

			local_rotation = Quaternion.look(cross)
		elseif not script_data.debug_hang_ledges then
			-- Nothing
		end
	end

	Unit.set_local_rotation(unit, 0, local_rotation)
end
