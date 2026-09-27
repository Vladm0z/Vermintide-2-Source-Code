-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_helper.lua

local CharacterStateHelper = CharacterStateHelper

CharacterStateHelper = CharacterStateHelper or {}
CharacterStateHelper = CharacterStateHelper

local CharacterStateHelper_2 = CharacterStateHelper

CharacterStateHelper_2.get_movement_input = function (self)
	-- function 1
	local get = self:get("move")

	get = get or Vector3(0, 0, 0)

	local get_2 = self:get("move_controller")

	get_2 = get_2 or Vector3(0, 0, 0)

	local var_1_2

	if Vector3.length(get) > Vector3.length(get_2) then
		var_1_2 = Vector3.normalize(get)
	else
		var_1_2 = get_2
	end

	return var_1_2
end

CharacterStateHelper_2.get_square_movement_input = function (self)
	-- function 2
	local get = self:get("move")

	get = get or Vector3(0, 0, 0)

	local get_2 = self:get("move_controller")

	get_2 = get_2 or Vector3(0, 0, 0)

	local var_2_2

	if Vector3.length(get) > Vector3.length(get_2) then
		var_2_2 = get
	else
		var_2_2 = math.circular_to_square_coordinates(get_2)
	end

	return var_2_2
end

CharacterStateHelper_2.get_look_input = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local unit = arg_3_1.unit
	local var_3_1

	if not ScriptUnit.has_extension(unit, "smart_targeting_system") then
		var_3_1 = ScriptUnit.extension(unit, "smart_targeting_system"):get_targeting_data()
	end

	local get = self:get("look")
	local var_3_3
	local is_zooming = arg_3_1:is_zooming()
	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_wielded_slot_name = arg_3_2:get_wielded_slot_name()
	local get_wielded_slot_item_template = arg_3_2:get_wielded_slot_item_template()

	if not is_device_active then
		if not is_zooming then
			var_3_3 = self:get("look_controller_zoom")
		elseif not arg_3_3 then
			var_3_3 = self:get("look_controller_3p")
		elseif get_wielded_slot_name == "slot_ranged" then
			var_3_3 = self:get("look_controller_ranged")
		elseif (get_wielded_slot_name ~= "slot_melee" or not var_3_1) and not var_3_1.targets_within_range then
			var_3_3 = self:get("look_controller_melee")
		else
			var_3_3 = self:get("look_controller")
		end
	end

	local var_3_8 = Vector3(0, 0, 0)

	if not get then
		var_3_8 = var_3_8 + get
	end

	if not var_3_3 then
		var_3_8 = var_3_8 + var_3_3
	end

	local apply_motion_controls = CharacterStateHelper_2.apply_motion_controls(var_3_8, self)

	if not script_data.attract_mode_spectate then
		apply_motion_controls = Vector3(0.005, 0, 0)
	end

	return apply_motion_controls
end

CharacterStateHelper_2.apply_motion_controls = function (self, arg_4_1)
	-- function 4
	if not MotionControlSettings.use_motion_controls then
		if not MotionControlSettings.motion_disable_right_stick_vertical then
			self.y = 0
		end

		local sensitivity_min_value = MotionControlSettings.sensitivity_min_value
		local sensitivity_base_value = MotionControlSettings.sensitivity_base_value
		local num = MotionControlSettings.sensitivity_yaw_max - MotionControlSettings.sensitivity_yaw_min
		local num_2 = (sensitivity_base_value - sensitivity_min_value) / (num * 0.5)
		local num_3 = sensitivity_base_value + MotionControlSettings.motion_sensitivity_yaw * num_2
		local num_4 = MotionControlSettings.sensitivity_pitch_max - MotionControlSettings.sensitivity_pitch_min
		local num_5 = (sensitivity_base_value - sensitivity_min_value) / (num_4 * 0.5)
		local num_6 = sensitivity_base_value + MotionControlSettings.motion_sensitivity_pitch * num_5
		local flag

		flag = not MotionControlSettings.motion_invert_yaw and -1 and 1

		local num_7 = num_3 * flag
		local flag_2

		flag_2 = not MotionControlSettings.motion_enable_yaw_motion and 1 and 0

		local num_8 = num_7 * flag_2
		local flag_3

		flag_3 = not MotionControlSettings.motion_invert_pitch and -1 and 1

		local num_9 = num_6 * flag_3
		local flag_4

		flag_4 = not MotionControlSettings.motion_enable_pitch_motion and 1 and 0

		local num_10 = num_9 * flag_4
		local get = arg_4_1:get("angular_velocity")
		local x

		if not get then
			x = get.x

			if not x then
				-- Nothing
			end
		end

		x = 0

		do
			local num_11
		end

		::label_4_0::

		if not get then
			num_11 = -get.y

			if not num_11 then
				-- Nothing
			end
		end

		num_11 = 0

		::label_4_1::

		self = self + Vector3(num_8 * num_11, num_10 * x, 0)
	end

	return self
end

CharacterStateHelper_2.update_dodge_lock = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not (not arg_5_2:dodge_locked() and arg_5_1:get("dodge_hold")) then
		arg_5_2:set_dodge_locked(false)
	end
end

local tbl = {
	move_left_pressed = Vector3Box(-Vector3.right()),
	move_right_pressed = Vector3Box(Vector3.right()),
	move_back_pressed = Vector3Box(-Vector3.forward())
}

CharacterStateHelper_2.check_to_start_dodge = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not (arg_6_2:dodge_locked() or arg_6_2:can_dodge(arg_6_3)) then
		return false
	end

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_0)
	local get_movement_input = CharacterStateHelper_2.get_movement_input(arg_6_1)
	local double_tap_dodge = arg_6_1.double_tap_dodge
	local flag = false
	local var_6_4 = Vector3(0, 0, 0)
	local get = arg_6_1:get("dodge_hold")
	local get_2 = arg_6_1:get("dodge")

	if not get_2 then
		-- Nothing
	end

	::label_6_0::

	local get_3 = arg_6_1:get("jump")

	get_3 = not get_3 and get

	::label_6_1::

	local length = Vector3.length(get_movement_input)
	local flag_2 = not Managers.input:is_device_active("gamepad")
	local user_setting = Application.user_setting("toggle_stationary_dodge")

	if not double_tap_dodge then
		for k, v in pairs(tbl) do
			if not arg_6_1:get(k) then
				local was_double_tap = arg_6_1:was_double_tap(k, arg_6_3, Application.user_setting("double_tap_dodge_threshold"))

				for k_2, v_2 in pairs(tbl) do
					arg_6_1:clear_double_tap(k_2)
				end

				if not was_double_tap then
					flag = true
					var_6_4 = v:unbox()

					break
				end

				arg_6_1:start_double_tap(k, arg_6_3)

				break
			end
		end
	end

	if not ((flag or not get_3) and not (length > arg_6_1.minimum_dodge_input)) then
		local num = get_movement_input / length
		local x = num.x
		local y = num.y
		local abs = math.abs(x)

		if not ((y <= 0 or flag_2 or not (abs > 0.9239)) and not get_2 and abs > 0.707) then
			flag = true

			if y > 0 then
				var_6_4 = Vector3(math.sign(x), 0, 0)
			else
				var_6_4 = num
			end
		end
	elseif not get_3 and not user_setting then
		flag = true
		var_6_4 = -Vector3.forward()
	end

	if not flag then
		Managers.state.entity:system("play_go_tutorial_system"):register_dodge(var_6_4)
		arg_6_2:add_fatigue_points("action_dodge")
		arg_6_2:set_dodge_locked(true)
		arg_6_2:add_dodge_cooldown()

		local extension = ScriptUnit.extension(arg_6_0, "first_person_system")
	end

	return flag, var_6_4
end

CharacterStateHelper_2.move_on_ground = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local current_rotation = self:current_rotation()
	local look = Quaternion.look(Vector3.flat(Quaternion.forward(current_rotation)), Vector3.up())
	local rotate = Quaternion.rotate(look, arg_7_3)

	if arg_7_3.y < 0 then
		arg_7_4 = arg_7_4 * PlayerUnitMovementSettings.get_movement_settings_table(arg_7_5).backward_move_scale
	end

	local dot = Vector3.dot(Quaternion.forward(look), rotate)
	local num

	if not arg_7_6 then
		num = 1 - arg_7_6

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_7_0::

	arg_7_4 = arg_7_4 - arg_7_4 * num * (1 - math.abs(dot))

	arg_7_2:set_wanted_velocity(rotate * arg_7_4)
end

CharacterStateHelper_2.packmaster_move_on_ground = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11)
	-- function 8
	local current_rotation = arg_8_1:current_rotation()
	local look = Quaternion.look(Vector3.flat(Quaternion.forward(current_rotation)), Vector3.up())
	local rotate = Quaternion.rotate(look, arg_8_4)
	local world = Managers.world:world("level_world")
	local get_data = World.get_data(world, "physics_world")
	local camera_rotation = Managers.state.camera:camera_rotation(arg_8_7.viewport_name)
	local forward = Quaternion.forward(camera_rotation)

	Vector3.set_z(forward, 0)
	Vector3.set_z(arg_8_8, 0)

	local normalize = Vector3.normalize(forward)

	arg_8_8 = Vector3.normalize(arg_8_8)

	local dot = Vector3.dot(arg_8_8, rotate)
	local flag = dot > 0
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_8_6)
	local clamp = math.clamp(1 - dot, get_movement_settings_table.packmaster_forward_move_scale, 1)

	if not flag then
		local flag_2

		flag_2 = not arg_8_10 and 1.5 and 1.1

		local var_8_13 = POSITION_LOOKUP[arg_8_9]
		local immediate_raycast, var_8_15, var_8_16, var_8_17, var_8_18 = PhysicsWorld.immediate_raycast(get_data, var_8_13 + Vector3(0, 0, 0.5), arg_8_8, flag_2, "closest", "types", "both", "collision_filter", "filter_ground_material_check")

		if not immediate_raycast then
			clamp = 0
		end
	else
		local node = Unit.node(arg_8_9, "j_neck")
		local world_position = Unit.world_position(arg_8_9, node)
		local node_2 = Unit.node(arg_8_6, "j_rightweaponcomponent10")
		local world_position_2 = Unit.world_position(arg_8_6, node_2)

		if Vector3.distance(world_position, world_position_2) > 3.25 then
			clamp = 0
		end
	end

	arg_8_5 = arg_8_5 * clamp

	arg_8_3:set_wanted_velocity(rotate * arg_8_5)
end

CharacterStateHelper_2.update_soft_collision_movement = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_9_3)
	local var_9_1 = Vector3(0, 0, 0)
	local var_9_2 = POSITION_LOOKUP[arg_9_3]
	local local_rotation = Unit.local_rotation(arg_9_3, 0)
	local PLAYER_UNITS = arg_9_6.PLAYER_UNITS

	if not Unit.alive(arg_9_3) then
		for k, v in pairs(PLAYER_UNITS) do
			if (v == arg_9_3 or not Unit.alive(v)) and not StatusUtils.use_soft_collision(v) then
				local num = var_9_2 - POSITION_LOOKUP[v]
				local abs = math.abs(Vector3.z(num))

				Vector3.set_z(num, 0)

				local length = Vector3.length(num)

				if not (not (abs <= get_movement_settings_table.soft_collision.max_height_diference) or not (length <= get_movement_settings_table.soft_collision.max_distance)) then
					local normalize = Vector3.normalize(num)
					local num_2 = 1 / (length + get_movement_settings_table.soft_collision.speed_modifier)

					var_9_1 = var_9_1 + normalize * (num_2 * num_2)
				end
			end
		end
	end

	local length_2 = Vector3.length(var_9_1)
	local normalize_2 = Vector3.normalize(var_9_1)
	local idle_speed_threshold = get_movement_settings_table.soft_collision.idle_speed_threshold

	if length_2 <= idle_speed_threshold then
		arg_9_2:set_wanted_velocity(Vector3(0, 0, 0))
	else
		length_2 = math.clamp(length_2, get_movement_settings_table.soft_collision.lowest_speed, get_movement_settings_table.soft_collision.highest_speed)

		arg_9_2:set_wanted_velocity(normalize_2 * length_2)
	end

	if length_2 <= idle_speed_threshold then
		if arg_9_5 ~= "idle" then
			CharacterStateHelper_2.play_animation_event(arg_9_3, "idle")
			CharacterStateHelper_2.play_animation_event_first_person(arg_9_0, "idle")

			arg_9_5 = "idle"
		end
	elseif Vector3.dot(normalize_2, Quaternion.forward(local_rotation)) >= 0 then
		if arg_9_5 ~= "move_fwd" then
			CharacterStateHelper_2.play_animation_event(arg_9_3, "move_fwd")
			CharacterStateHelper_2.play_animation_event_first_person(arg_9_0, "move_fwd")

			arg_9_5 = "move_fwd"
		end
	elseif arg_9_5 ~= "move_bwd" then
		CharacterStateHelper_2.play_animation_event(arg_9_3, "move_bwd")
		CharacterStateHelper_2.play_animation_event_first_person(arg_9_0, "move_bwd")

		arg_9_5 = "move_bwd"
	end

	return arg_9_5
end

CharacterStateHelper_2.do_common_state_transitions = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not CharacterStateHelper_2.is_dead(self) then
		arg_10_1:change_state("dead")

		return true
	end

	if not CharacterStateHelper_2.is_staggered(self) then
		arg_10_1:change_state("staggered")

		return true
	end

	if not CharacterStateHelper_2.is_knocked_down(self) then
		arg_10_1:change_state("knocked_down")

		return true
	end

	if not CharacterStateHelper_2.is_pounced_down(self) then
		arg_10_1:change_state("pounced_down")

		return true
	end

	local is_catapulted, var_10_1 = CharacterStateHelper_2.is_catapulted(self)

	if not is_catapulted then
		local tbl = {
			sound_event = "Play_hit_by_ratogre",
			direction = var_10_1
		}

		arg_10_1:change_state("catapulted", tbl)

		return true
	end

	if not CharacterStateHelper_2.is_grabbed_by_pack_master(self) then
		arg_10_1:change_state("grabbed_by_pack_master")

		return true
	end

	if not self.grabbed_by_corruptor then
		arg_10_1:change_state("grabbed_by_corruptor")

		return true
	end

	if not self.grabbed_by_tentacle then
		arg_10_1:change_state("grabbed_by_tentacle")

		return true
	end

	if not self.grabbed_by_chaos_spawn then
		arg_10_1:change_state("grabbed_by_chaos_spawn")

		return true
	end

	if not self.in_vortex then
		arg_10_1:change_state("in_vortex")

		return true
	end

	if not self.do_lunge then
		arg_10_1:change_state("lunging")

		return true
	end

	if not self.is_packmaster_dragging then
		local get_packmaster_dragged_unit = self:get_packmaster_dragged_unit()
		local extension = ScriptUnit.extension(get_packmaster_dragged_unit, "status_system")

		if not (extension.pack_master_status == "pack_master_hanging" or extension.pack_master_status == "pack_master_hoisting") then
			arg_10_1:change_state("packmaster_dragging")

			return true
		end
	end

	if not self.in_hanging_cage then
		local in_hanging_cage_animations = self.in_hanging_cage_animations
		local in_hanging_cage_unit = self.in_hanging_cage_unit
		local tbl_2 = {
			animations = in_hanging_cage_animations,
			cage_unit = in_hanging_cage_unit
		}

		arg_10_1:change_state("in_hanging_cage", tbl_2)

		return true
	end

	if arg_10_2 == "overpowered" or arg_10_2 == "ledge_hanging" or not self.overpowered then
		local var_10_8 = PlayerUnitMovementSettings.overpowered_templates[self.overpowered_template]

		arg_10_1:change_state("overpowered", var_10_8)

		return true
	end

	return false
end

CharacterStateHelper_2.is_colliding_with_gameplay_collision_box = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local get_data = World.get_data(arg_11_0, "physics_world")
	local position

	if not arg_11_3 then
		position = arg_11_3.position

		if not position then
			-- Nothing
		end
	end

	position = POSITION_LOOKUP[arg_11_1]

	::label_11_0::

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_11_1)
	local movement_settings_table_name

	if not arg_11_3 then
		movement_settings_table_name = arg_11_3.movement_settings_table_name

		if not movement_settings_table_name then
			-- Nothing
		end
	end

	movement_settings_table_name = "gameplay_collision_box"

	::label_11_1::

	local collision_check_player_half_height = get_movement_settings_table[movement_settings_table_name].collision_check_player_half_height
	local collision_check_player_height_offset = get_movement_settings_table[movement_settings_table_name].collision_check_player_height_offset
	local num = position + Vector3(0, 0, collision_check_player_height_offset)
	local local_rotation = Unit.local_rotation(arg_11_1, 0)
	local movement_settings_table_name_2

	if not arg_11_3 then
		movement_settings_table_name_2 = arg_11_3.movement_settings_table_name

		if not movement_settings_table_name_2 then
			-- Nothing
		end
	end

	movement_settings_table_name_2 = "gameplay_collision_box"

	::label_11_2::

	local collision_check_player_radius = get_movement_settings_table[movement_settings_table_name_2].collision_check_player_radius
	local var_11_10 = Vector3(collision_check_player_radius, collision_check_player_half_height, collision_check_player_radius)
	local flag

	flag = not (collision_check_player_half_height - collision_check_player_radius > 0) or not "capsule" or "sphere"

	local immediate_overlap = PhysicsWorld.immediate_overlap(get_data, "shape", flag, "position", num, "rotation", local_rotation, "size", var_11_10, "collision_filter", arg_11_2)
	local flag_2 = not immediate_overlap and immediate_overlap[1]
	local var_11_14
	local var_11_15

	if not flag_2 then
		var_11_14 = true
		var_11_15 = Actor.unit(flag_2)
	end

	return var_11_14, var_11_15
end

CharacterStateHelper_2.move_in_air = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	local get_movement_input = CharacterStateHelper_2.get_movement_input(arg_12_1)
	local num = 0

	if not (not arg_12_5 and not (arg_12_5 > 0)) then
		num = num - 1
	end

	if not (not arg_12_6 and not (arg_12_6 > 0)) then
		num = num + 1
	end

	if num ~= 0 then
		Vector3.set_y(get_movement_input, num)
	end

	local normalize = Vector3.normalize(get_movement_input)
	local current_rotation = self:current_rotation()
	local normalize_2 = Vector3.normalize(Vector3.flat(Quaternion.rotate(current_rotation, normalize)))
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_12_4)
	local clamp = math.clamp(get_movement_settings_table.move_speed, 0, PlayerUnitMovementSettings.move_speed)

	if get_movement_input.y < 0 then
		arg_12_3 = arg_12_3 * get_movement_settings_table.backward_move_scale
		clamp = clamp * get_movement_settings_table.backward_move_scale * 0.9
	end

	local num_2 = Vector3.flat(arg_12_2:current_velocity()) + normalize_2 * arg_12_3
	local length = Vector3.length(num_2)
	local clamp_2 = math.clamp(length, 0, clamp * get_movement_settings_table.player_speed_scale)
	local normalize_3 = Vector3.normalize(num_2)

	arg_12_2:set_wanted_velocity(normalize_3 * clamp_2)
end

CharacterStateHelper_2.move_in_air_pactsworn = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
	-- function 13
	local get_movement_input = CharacterStateHelper_2.get_movement_input(arg_13_1)
	local num = 0
	local get_data = Unit.get_data(arg_13_4, "breed")

	if not (not arg_13_5 and not (arg_13_5 > 0)) then
		num = num - 1
	end

	if not (not arg_13_6 and not (arg_13_6 > 0)) then
		num = num + 1
	end

	if num ~= 0 then
		Vector3.set_y(get_movement_input, num)
	end

	local normalize = Vector3.normalize(get_movement_input)
	local current_rotation = self:current_rotation()
	local normalize_2 = Vector3.normalize(Vector3.flat(Quaternion.rotate(current_rotation, normalize)))
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_13_4)
	local movement_speed_multiplier = get_data.movement_speed_multiplier
	local move_speed = get_movement_settings_table.move_speed

	if not ScriptUnit.extension(arg_13_4, "ghost_mode_system"):is_in_ghost_mode() then
		move_speed = get_movement_settings_table.ghost_move_speed
	end

	local num_2 = move_speed * movement_speed_multiplier * 0.7

	if get_movement_input.y < 0 then
		arg_13_3 = arg_13_3 * get_movement_settings_table.backward_move_scale
		num_2 = num_2 * get_movement_settings_table.backward_move_scale * 0.9
	end

	local num_3 = Vector3.flat(arg_13_2:current_velocity()) + normalize_2 * arg_13_3
	local length = Vector3.length(num_3)
	local clamp = math.clamp(length, 0, num_2 * get_movement_settings_table.player_speed_scale)
	local normalize_3 = Vector3.normalize(num_3)

	arg_13_2:set_wanted_velocity(normalize_3 * clamp)
end

CharacterStateHelper_2.looking_up = function (self, arg_14_1)
	-- function 14
	local get_first_person_unit = self:get_first_person_unit()
	local world_rotation = Unit.world_rotation(get_first_person_unit, 0)
	local forward = Quaternion.forward(world_rotation)
	local normalize = Vector3.normalize(forward)
	local flag

	flag = not (arg_14_1 < Vector3.dot(normalize, Vector3.up())) or not true or false

	return flag
end

CharacterStateHelper_2.looking_down = function (self, arg_15_1)
	-- function 15
	local get_first_person_unit = self:get_first_person_unit()
	local world_rotation = Unit.world_rotation(get_first_person_unit, 0)
	local forward = Quaternion.forward(world_rotation)
	local normalize = Vector3.normalize(forward)
	local flag

	flag = not (arg_15_1 > Vector3.dot(normalize, Vector3.up())) or not true or false

	return flag
end

CharacterStateHelper_2.look = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	-- function 16
	local camera = Managers.state.camera

	if not arg_16_5 then
		-- Nothing
	end

	do
		local num
	end

	::label_16_0::

	if not camera:has_viewport(arg_16_1) then
		num = camera:fov(arg_16_1) / 0.785

		if not num then
			-- Nothing
		end
	end

	num = 1

	::label_16_1::

	local unit = self.unit
	local num_2 = num * PlayerUnitMovementSettings.get_movement_settings_table(unit).look_input_sensitivity
	local flag = false
	local num_3 = CharacterStateHelper_2.get_look_input(self, arg_16_3, arg_16_4, flag) * num_2

	if not arg_16_6 then
		num_3 = num_3 + arg_16_6
	end

	arg_16_2:set_look_delta(num_3)
end

CharacterStateHelper_2.look_limited_rotation_freedom = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9)
	-- function 17
	local camera = Managers.state.camera

	if not arg_17_9 then
		-- Nothing
	end

	do
		local num
	end

	::label_17_0::

	if not camera:has_viewport(arg_17_1) then
		num = Managers.state.camera:fov(arg_17_1) / 0.785

		if not num then
			-- Nothing
		end
	end

	num = 1

	::label_17_1::

	local flag = false
	local num_2 = CharacterStateHelper_2.get_look_input(arg_17_0, arg_17_7, arg_17_8, flag) * num

	if not arg_17_5 then
		local num_3 = Quaternion.yaw(arg_17_4) - Quaternion.yaw(Unit.local_rotation(arg_17_2.first_person_unit, 0))
		local x = Vector3.x(num_2)

		if not (not (x > 0) or not (arg_17_5 < num_3)) then
			x = 0
		end

		if not (not (x < 0) or not (num_3 < -arg_17_5)) then
			x = 0
		end

		Vector3.set_x(num_2, x)
	end

	if not arg_17_6 then
		local num_4 = Quaternion.pitch(arg_17_4) - Quaternion.pitch(Unit.local_rotation(arg_17_2.first_person_unit, 0))
		local y = Vector3.y(num_2)
		local num_5 = math.pi / 2

		if not (not (y < 0) or not (arg_17_6 < num_4)) then
			y = 0
		end

		if not (not (y > 0) or not (num_4 < -arg_17_6)) then
			y = 0
		end

		Vector3.set_y(num_2, y)
	end

	arg_17_2:set_look_delta(num_2)
end

CharacterStateHelper_2.lerp_player_rotation_radian = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local var_18_0

	if not ((not (arg_18_1 >= 0) or not (arg_18_0 >= 0) or not (arg_18_1 <= 0)) and not (arg_18_0 <= 0)) then
		var_18_0 = arg_18_0 + (arg_18_1 - arg_18_0) * arg_18_3
	else
		local num = arg_18_2 * arg_18_3

		if arg_18_1 < 0 then
			if math.abs(arg_18_1) + arg_18_0 > math.pi then
				var_18_0 = arg_18_0 + num

				if var_18_0 >= math.pi then
					local num_2 = math.pi - math.abs(var_18_0)

					var_18_0 = math.pi - num_2
				end
			else
				var_18_0 = arg_18_0 - num
			end
		elseif arg_18_1 + math.abs(arg_18_0) > math.pi then
			var_18_0 = arg_18_0 - num

			if var_18_0 <= -math.pi then
				local num_3 = var_18_0 - math.pi

				var_18_0 = -math.pi + num_3
			end
		else
			var_18_0 = arg_18_0 + num
		end
	end

	return var_18_0
end

CharacterStateHelper_2.lerp_player_pitch_rotation = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local local_rotation = Unit.local_rotation(arg_19_3, 0)
	local lerp = math.lerp(arg_19_0, 0, arg_19_2)
	local yaw = Quaternion.yaw(local_rotation)
	local roll = Quaternion.roll(local_rotation)
	local var_19_4 = Quaternion(Vector3.up(), yaw)
	local var_19_5 = Quaternion(Vector3.right(), lerp)
	local var_19_6 = Quaternion(Vector3.forward(), roll)
	local multiply = Quaternion.multiply(var_19_4, var_19_5)
	local multiply_2 = Quaternion.multiply(multiply, var_19_6)

	arg_19_1:set_rotation(multiply_2)
	Unit.set_local_rotation(arg_19_3, 0, multiply_2)
end

CharacterStateHelper_2.lerp_player_yaw_rotation = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local get_first_person_unit = arg_20_3:get_first_person_unit()
	local local_rotation = Unit.local_rotation(get_first_person_unit, 0)
	local lerp_player_rotation_radian = CharacterStateHelper_2.lerp_player_rotation_radian(arg_20_0, arg_20_1, arg_20_2, arg_20_4)
	local pitch = Quaternion.pitch(local_rotation)
	local roll = Quaternion.roll(local_rotation)
	local var_20_5 = Quaternion(Vector3.up(), lerp_player_rotation_radian)
	local var_20_6 = Quaternion(Vector3.right(), pitch)
	local var_20_7 = Quaternion(Vector3.forward(), roll)
	local multiply = Quaternion.multiply(var_20_5, var_20_6)
	local multiply_2 = Quaternion.multiply(multiply, var_20_7)

	arg_20_3:set_rotation(multiply_2)
	Unit.set_local_rotation(arg_20_5, 0, multiply_2)
end

CharacterStateHelper_2.time_in_ladder_move_animation = function (arg_21_0, arg_21_1)
	-- function 21
	local world_position = Unit.world_position(arg_21_0, 0)
	local num = Vector3.z(world_position) - arg_21_1
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_21_0)

	return num % get_movement_settings_table.ladder.whole_movement_animation_distance / get_movement_settings_table.ladder.whole_movement_animation_distance * get_movement_settings_table.ladder.movement_animation_length
end

CharacterStateHelper_2.show_inventory_3p = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_22_0)

	if not network.game_session then
		return
	end

	if arg_22_2 or not arg_22_3 or not arg_22_4.is_bot then
		arg_22_4:show_third_person_inventory(arg_22_1)
	end

	if not arg_22_3 then
		network.network_transmit:send_rpc_clients("rpc_show_inventory", unit_game_object_id, arg_22_1)
	else
		network.network_transmit:send_rpc_server("rpc_show_inventory", unit_game_object_id, arg_22_1)
	end
end

CharacterStateHelper_2.set_is_on_ladder = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_23_1)
	local game_object_or_level_id, var_23_3 = network:game_object_or_level_id(arg_23_0)

	assert(var_23_3, "Ladder unit wasn't a level unit")

	if arg_23_3 or not LEVEL_EDITOR_TEST then
		Managers.state.entity:system("status_system"):rpc_status_change_bool(nil, NetworkLookup.statuses.ladder_climbing, arg_23_2, unit_game_object_id, game_object_or_level_id)
	else
		arg_23_4:set_is_on_ladder(arg_23_2, arg_23_0)
		network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.ladder_climbing, arg_23_2, unit_game_object_id, game_object_or_level_id)
	end
end

CharacterStateHelper_2.set_is_on_ledge = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_24_1)
	local game_object_or_level_id, var_24_3 = network:game_object_or_level_id(arg_24_0)

	arg_24_4:set_crouching(false)

	if not (not Managers.state.network:game() and LEVEL_EDITOR_TEST) then
		arg_24_4:set_is_ledge_hanging(arg_24_2, arg_24_0)
		network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.ledge_hanging, arg_24_2, unit_game_object_id, game_object_or_level_id)
	end
end

CharacterStateHelper_2.get_buffered_input = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local var_25_0
	local var_25_1

	if not arg_25_0 then
		var_25_0 = arg_25_1:get(arg_25_0)

		if not (not var_25_0 and not arg_25_4 and not (var_25_0 < arg_25_4)) then
			return false
		end

		if not arg_25_2 then
			if not var_25_0 then
				arg_25_1:add_buffer(arg_25_0, arg_25_3)
			else
				var_25_0 = arg_25_1:get_buffer(arg_25_0)
				var_25_1 = true
			end
		end
	end

	return var_25_0, var_25_1
end

CharacterStateHelper_2._check_cooldown = function (self, arg_26_1, arg_26_2)
	-- function 26
	local flag = false

	if not self then
		local get_action_cooldown = self:get_action_cooldown(arg_26_1)

		flag = not get_action_cooldown and arg_26_2 <= get_action_cooldown
	end

	return flag
end

CharacterStateHelper_2.wield_input = function (self, arg_27_1, arg_27_2)
	-- function 27
	if arg_27_2 ~= "action_wield" then
		return nil
	end

	local slots_by_name = InventorySettings.slots_by_name
	local slots_by_wield_input = InventorySettings.slots_by_wield_input
	local equipment = arg_27_1:equipment()
	local wielded_slot = equipment.wielded_slot
	local var_27_4 = slots_by_name[wielded_slot]
	local wield_input = var_27_4.wield_input
	local var_27_6
	local var_27_7

	if not CharacterStateHelper_2.get_buffered_input("wield_switch", self, nil, nil, nil, wielded_slot == "slot_melee") then
		var_27_6 = var_27_4.name == "slot_melee" or not "slot_melee" or "slot_ranged"
	end

	if not var_27_6 then
		for i, v in ipairs(slots_by_wield_input) do
			if v ~= var_27_4 or not arg_27_1:can_swap_from_storage(v.name, SwapFromStorageType.Unique) then
				local wield_input_2 = v.wield_input
				local name = v.name

				if not equipment.slots[name] and not CharacterStateHelper_2.get_buffered_input(wield_input_2, self, nil, nil, nil, wielded_slot == "slot_melee") then
					var_27_6 = name

					break
				end
			end

			local wield_input_alt = v.wield_input_alt

			if not wield_input_alt and not CharacterStateHelper_2.get_buffered_input(wield_input_alt, self, nil, nil, nil, wielded_slot == "slot_melee") and v ~= var_27_4 and not arg_27_1:can_swap_from_storage(v.name, SwapFromStorageType.LowestUnwieldPrio) then
				var_27_6 = v.name
				var_27_7 = SwapFromStorageType.LowestUnwieldPrio

				break
			end
		end
	end

	local num = 0

	if not self:get("wield_prev") then
		num = -1
	elseif not self:get("wield_next") then
		num = 1
	end

	local key_pressed = DebugKeyHandler.key_pressed("left shift")

	key_pressed = key_pressed or DebugKeyHandler.key_pressed("left alt")

	local user_setting = Application.user_setting("weapon_scroll_type")

	user_setting = user_setting or "scroll_wrap"

	if not (user_setting == "scroll_disabled" or var_27_6 or num == 0 or key_pressed) then
		local wield_index = var_27_4.wield_index

		wield_index = wield_index or 1

		local count = #slots_by_wield_input
		local sign = math.sign(num)
		local num_2 = wield_index + sign

		repeat
			local var_27_18 = slots_by_wield_input[num_2]
			local flag = not var_27_18 and equipment.slots[var_27_18.name]

			if not flag then
				if count < num_2 then
					if user_setting == "scroll_clamp" then
						num_2 = count
						sign = -1
					else
						num_2 = 1
					end
				elseif num_2 < 1 then
					if user_setting == "scroll_clamp" then
						num_2 = 1
						sign = 1
					else
						num_2 = count
					end
				else
					num_2 = num_2 + sign
				end
			end
		until not flag

		if var_27_4.wield_index ~= num_2 then
			var_27_6 = slots_by_wield_input[num_2].name
		end
	end

	if not (not var_27_6 and equipment.slots[var_27_6]) then
		var_27_6 = nil
	end

	return var_27_6, num, var_27_7
end

local tbl_2 = {}

CharacterStateHelper_2.get_item_data_and_weapon_extensions = function (self)
	-- function 28
	local equipment = self:equipment()
	local wielded = equipment.wielded

	if wielded == nil then
		return
	end

	local right_hand_wielded_unit = equipment.right_hand_wielded_unit
	local left_hand_wielded_unit = equipment.left_hand_wielded_unit
	local var_28_4
	local var_28_5

	if not Unit.alive(right_hand_wielded_unit) then
		var_28_4 = ScriptUnit.extension(right_hand_wielded_unit, "weapon_system")
	end

	if not Unit.alive(left_hand_wielded_unit) then
		var_28_5 = ScriptUnit.extension(left_hand_wielded_unit, "weapon_system")
	end

	if not (var_28_4 or var_28_5) then
		return
	end

	return wielded, var_28_4, var_28_5
end

CharacterStateHelper_2.get_current_action_data = function (self, arg_29_1)
	-- function 29
	local var_29_0
	local var_29_1
	local var_29_2

	if not self then
		local current_action_settings = self.current_action_settings

		if not current_action_settings then
			var_29_0 = current_action_settings
			var_29_1 = self
			var_29_2 = var_29_0.weapon_action_hand or "left"
		end
	end

	if not arg_29_1 then
		local current_action_settings_2 = arg_29_1.current_action_settings

		if not current_action_settings_2 then
			var_29_0 = current_action_settings_2
			var_29_1 = arg_29_1
			var_29_2 = var_29_0.weapon_action_hand or "right"
		end
	end

	return var_29_0, var_29_1, var_29_2
end

CharacterStateHelper_2._check_chain_action = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8)
	-- function 30
	local var_30_0
	local var_30_1
	local var_30_2
	local var_30_3
	local var_30_4
	local release_required = arg_30_1.release_required
	local flag = true

	if not release_required then
		flag = arg_30_4:released_input(release_required)
	end

	local hold_required = arg_30_1.hold_required

	if not hold_required then
		for k, v in pairs(hold_required) do
			if not arg_30_4:released_input(v) then
				flag = false

				break
			end
		end
	end

	local softbutton_required = arg_30_1.softbutton_required

	if not softbutton_required then
		for k_2, v_2 in pairs(softbutton_required) do
			local var_30_9 = arg_30_4
			local released_softbutton_input = arg_30_4.released_softbutton_input
			local input = v_2.input
			local softbutton_threshold = v_2.softbutton_threshold

			softbutton_threshold = softbutton_threshold or arg_30_1.softbutton_threshold

			if not released_softbutton_input(var_30_9, input, softbutton_threshold) then
				flag = false

				break
			end
		end
	end

	local input_2 = arg_30_1.input
	local softbutton_threshold_2 = arg_30_1.softbutton_threshold
	local var_30_15
	local var_30_16
	local no_buffer = arg_30_1.no_buffer
	local doubleclick_window = arg_30_1.doubleclick_window
	local blocking_input = arg_30_1.blocking_input
	local flag_2 = false

	if not blocking_input then
		flag_2 = arg_30_4:get(blocking_input)
	end

	if not (not flag and flag_2) then
		local wielded_slot = arg_30_5:equipment().wielded_slot

		var_30_15, var_30_16 = CharacterStateHelper_2.get_buffered_input(input_2, arg_30_4, no_buffer, doubleclick_window, softbutton_threshold_2, wielded_slot == "slot_melee")

		if var_30_15 or not arg_30_1.hold_allowed then
			var_30_15, var_30_16 = CharacterStateHelper_2.get_buffered_input(input_2 .. "_hold", arg_30_4, no_buffer, doubleclick_window, softbutton_threshold_2, wielded_slot == "slot_melee")
		end
	end

	if not var_30_15 then
		local action = arg_30_1.action
		local sub_action = arg_30_1.sub_action
		local var_30_24 = arg_30_2.actions[action]

		var_30_24 = not var_30_24 and arg_30_2.actions[action][sub_action]
		var_30_15 = not var_30_24 and var_30_24.kind ~= "block" or arg_30_4:is_input_blocked()
	end

	if not var_30_15 then
		arg_30_0 = CharacterStateHelper_2.wield_input(arg_30_4, arg_30_5, arg_30_1.action)
		var_30_15 = arg_30_0
	end

	local auto_chain = arg_30_1.auto_chain

	auto_chain = not auto_chain and flag

	if var_30_15 or not auto_chain then
		local select_chance = arg_30_1.select_chance

		select_chance = select_chance or 1

		local flag_3 = select_chance >= math.random()

		if not arg_30_3:is_chain_action_available(arg_30_1, arg_30_7) and not flag_3 then
			local sub_action_2 = arg_30_1.sub_action

			if not arg_30_1.blocker then
				return true, nil, nil, arg_30_0, nil, nil
			end

			if not sub_action_2 then
				local action_2 = arg_30_1.action
				local var_30_30 = sub_action_2
				local var_30_31 = arg_30_2.actions[action_2]

				var_30_31 = not var_30_31 and arg_30_2.actions[action_2][var_30_30]

				local flag_4 = not var_30_31 and var_30_31.chain_condition_func
				local flag_5 = false

				if not flag_4 then
					flag_5 = not flag_4(arg_30_6, arg_30_4, arg_30_8, arg_30_3)
				end

				local _check_cooldown = CharacterStateHelper_2._check_cooldown(arg_30_3, action_2, arg_30_7)

				if not (not var_30_31 and flag_5 or _check_cooldown) then
					local send_buffer = arg_30_1.send_buffer
					local clear_buffer = arg_30_1.clear_buffer

					var_30_4 = not var_30_16 and arg_30_1.input == "action_one_release" and "action_one_hold" and not auto_chain or arg_30_1.input == "action_wield" and var_30_4 or arg_30_1.input ~= "action_wield" and var_30_4

					return true, action_2, var_30_30, arg_30_0, send_buffer, clear_buffer, var_30_4
				end
			end
		end
	end

	return false
end

local tbl_3 = {
	sub_action = "default",
	start_time = 0,
	action = "N/A",
	input = "action_career"
}

CharacterStateHelper_2._get_chain_action_data = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)
	-- function 31
	local var_31_0
	local var_31_1
	local var_31_2
	local var_31_3
	local var_31_4
	local var_31_5
	local var_31_6
	local has_extension = ScriptUnit.has_extension(arg_31_5, "career_system")

	if not has_extension then
		local action_name = arg_31_2.lookup_data.action_name
		local ability_amount = has_extension:ability_amount()

		for i = 1, ability_amount do
			local get_activated_ability_data = has_extension:get_activated_ability_data(i)
			local action_name_2 = get_activated_ability_data.action_name

			if not (not action_name_2 and action_name_2 == action_name) then
				local var_31_12 = tbl_3

				var_31_12.action = action_name_2

				local _check_chain_action, var_31_14, var_31_15, var_31_16, var_31_17, var_31_18, var_31_19 = CharacterStateHelper_2._check_chain_action(var_31_3, var_31_12, self, arg_31_1, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)

				if not _check_chain_action then
					local activatable_on_wield_chain_only = get_activated_ability_data.activatable_on_wield_chain_only
					local flag = not activatable_on_wield_chain_only

					if not activatable_on_wield_chain_only then
						local allowed_chain_actions = arg_31_2.allowed_chain_actions

						if not allowed_chain_actions then
							for j = 1, #allowed_chain_actions do
								local var_31_23 = allowed_chain_actions[j]

								if var_31_23.input ~= "action_wield" or not arg_31_1:is_chain_action_available(var_31_23, arg_31_6) then
									flag = true

									break
								end
							end
						end
					end

					if not flag then
						local var_31_24 = _check_chain_action

						var_31_1 = var_31_14
						var_31_2 = var_31_15
						var_31_3 = var_31_16
						var_31_4 = var_31_17
						var_31_5 = var_31_18
						var_31_6 = var_31_19
					end
				end
			end
		end
	end

	if not var_31_1 then
		local allowed_chain_actions_2 = arg_31_2.allowed_chain_actions

		allowed_chain_actions_2 = allowed_chain_actions_2 or tbl_2

		for k = 1, #allowed_chain_actions_2 do
			local var_31_26 = allowed_chain_actions_2[k]
			local _check_chain_action_2, var_31_28, var_31_29, var_31_30, var_31_31, var_31_32, var_31_33 = CharacterStateHelper_2._check_chain_action(var_31_3, var_31_26, self, arg_31_1, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)

			var_31_6 = var_31_33
			var_31_5 = var_31_32
			var_31_4 = var_31_31
			var_31_3 = var_31_30
			var_31_2 = var_31_29
			var_31_1 = var_31_28

			if not _check_chain_action_2 then
				break
			end
		end
	end

	if not var_31_1 then
		local var_31_34 = self.actions[var_31_1]

		var_31_34 = not var_31_34 and self.actions[var_31_1][var_31_2]

		if not (var_31_5 or var_31_2 ~= "push") then
			arg_31_3:clear_input_buffer()
		elseif not (not var_31_34 and var_31_3 or var_31_34.keep_buffer or var_31_4) then
			arg_31_3:reset_input_buffer()
		end
	end

	return var_31_1, var_31_2, var_31_3, var_31_6
end

local function fn(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8, arg_32_9)
	-- function 32
	local input_override = arg_32_3.input_override

	input_override = input_override or arg_32_1

	local flag = not not arg_32_3.do_not_validate_with_hold or arg_32_3.hold_input
	local allow_hold_toggle = arg_32_3.allow_hold_toggle

	allow_hold_toggle = not allow_hold_toggle and arg_32_4.toggle_alternate_attack

	if not arg_32_6 then
		-- Nothing
	end

	::label_32_0::

	local get = arg_32_4:get(input_override)

	if not get then
		get = arg_32_4:get_buffer(input_override)

		if not get then
			get = arg_32_4:get(arg_32_3.attack_hold_input)

			if not get then
				if not allow_hold_toggle then
					get = arg_32_4:get(flag)

					if not get then
						-- Nothing
					end
				end

				get = arg_32_3.kind ~= "block" or arg_32_4:is_input_blocked()
			end
		end
	end

	::label_32_1::

	local var_32_4
	local var_32_5

	if not get then
		var_32_4 = CharacterStateHelper_2.wield_input(arg_32_4, arg_32_5, input_override)
		var_32_5 = true
	end

	if get or not var_32_4 then
		local condition_func = arg_32_3.condition_func

		if not (not condition_func and condition_func(arg_32_0, arg_32_4, arg_32_7, arg_32_8) and CharacterStateHelper_2._check_cooldown(arg_32_8, arg_32_1, arg_32_9)) then
			if not var_32_5 then
				var_32_4 = CharacterStateHelper_2.wield_input(arg_32_4, arg_32_5, input_override)
			end

			if not (var_32_4 or arg_32_3.keep_buffer) then
				arg_32_4:reset_input_buffer()
			end

			return arg_32_1, arg_32_2
		else
			arg_32_4:add_buffer(input_override)
		end
	end
end

CharacterStateHelper_2.validate_action = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9)
	-- function 33
	return fn(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9)
end

local tbl_4 = {
	cutting_berserker = true,
	cutting = true
}
local tbl_5 = {}

CharacterStateHelper_2.update_weapon_actions = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	-- function 34
	local get_item_data_and_weapon_extensions, var_34_1, var_34_2 = CharacterStateHelper_2.get_item_data_and_weapon_extensions(arg_34_3)

	table.clear(tbl_5)

	if not get_item_data_and_weapon_extensions then
		return
	end

	local var_34_3
	local var_34_4
	local var_34_5
	local var_34_6
	local var_34_7
	local var_34_8
	local var_34_9
	local get_current_action_data, var_34_11, var_34_12 = CharacterStateHelper_2.get_current_action_data(var_34_2, var_34_1)
	local get_item_template = BackendUtils.get_item_template(get_item_data_and_weapon_extensions)
	local recently_damaged, var_34_15 = arg_34_4:recently_damaged()
	local extension = ScriptUnit.extension(arg_34_1, "status_system")
	local extension_2 = ScriptUnit.extension(arg_34_1, "buff_system")
	local flag = false

	if not get_current_action_data then
		flag = not ActionUtils.is_melee_start_sub_action(get_current_action_data) and extension_2:has_buff_perk("uninterruptible_heavy")
	end

	local var_34_19
	local var_34_20
	local owner = Managers.player:owner(arg_34_1)
	local flag_2 = not owner and owner.bot_player
	local ammo_extension

	if not var_34_2 then
		ammo_extension = var_34_2.ammo_extension

		if not ammo_extension then
			-- Nothing
		end
	end

	ammo_extension = not var_34_1 and var_34_1.ammo_extension

	::label_34_0::

	local get_data = Unit.get_data(arg_34_1, "breed")

	if not (not recently_damaged and not tbl_4[recently_damaged] and get_data.boss) then
		if not ammo_extension then
			if not var_34_2 and not var_34_2.ammo_extension then
				var_34_20 = var_34_2.ammo_extension:is_reloading()
			end

			if not var_34_1 and not var_34_1.ammo_extension then
				var_34_20 = var_34_1.ammo_extension:is_reloading()
			end
		end

		local flag_3

		flag_3 = (not get_current_action_data and get_current_action_data.uninterruptible and script_data.uninterruptible or var_34_20 and flag_2 and extension_2:has_buff_perk("uninterruptible") and not flag) and false and recently_damaged ~= "cutting_berserker" or not true and extension:hitreact_interrupt()

		if not (not flag_3 and extension:is_disabled()) then
			if not extension_2:has_buff_perk("reduced_hit_react") then
				var_34_15 = "light"
			end

			if not get_current_action_data then
				var_34_11:stop_action("interrupted")
			end

			local extension_3 = ScriptUnit.extension(arg_34_1, "first_person_system")

			CharacterStateHelper_2.play_animation_event(arg_34_1, "hit_reaction")

			if var_34_15 == "medium" then
				extension_3:play_hud_sound_event("enemy_hit_medium")
			elseif var_34_15 == "heavy" then
				extension_3:play_hud_sound_event("enemy_hit_heavy")
			end

			if not Development.parameter("attract_mode") then
				if recently_damaged == "cutting_berserker" then
					extension:set_hit_react_type(var_34_15)
					extension:set_pushed_no_cooldown(true, arg_34_0)
				else
					extension:set_hit_react_type(var_34_15)
					extension:set_pushed(true, arg_34_0)
				end
			end

			return
		end
	end

	local var_34_27

	if not get_current_action_data then
		local var_34_28

		var_34_3, var_34_4, var_34_28, var_34_6 = CharacterStateHelper_2._get_chain_action_data(get_item_template, var_34_11, get_current_action_data, arg_34_2, arg_34_3, arg_34_1, arg_34_0, ammo_extension)

		if not var_34_3 then
			if not get_current_action_data.allow_hold_toggle and not arg_34_2.toggle_alternate_attack then
				local action_name = get_current_action_data.lookup_data.action_name

				if not action_name and not arg_34_2:get(action_name, true) and not var_34_11:can_stop_hold_action(arg_34_0) then
					var_34_11:stop_action("hold_input_released")
				end
			elseif not (get_current_action_data.kind ~= "block" or arg_34_2:is_input_blocked()) then
				local hold_input = get_current_action_data.hold_input

				if not hold_input and arg_34_2:get(hold_input) or not var_34_11:can_stop_hold_action(arg_34_0) then
					var_34_11:stop_action("hold_input_released")
				end
			end
		end
	elseif not get_item_template.next_action then
		local next_action = get_item_template.next_action

		var_34_27 = next_action.action_init_data

		local action = next_action.action
		local flag_4 = true
		local var_34_34 = get_item_template.actions[action]

		for k, v in pairs(var_34_34) do
			if k == "default" or not v.condition_func then
				var_34_3, var_34_4 = fn(arg_34_1, action, k, v, arg_34_2, arg_34_3, flag_4, nil, var_34_11, arg_34_0)

				if not var_34_3 and not var_34_4 then
					break
				end
			end
		end

		if not var_34_3 then
			local default = get_item_template.actions[action].default

			var_34_3, var_34_4 = fn(arg_34_1, action, "default", default, arg_34_2, arg_34_3, flag_4, nil, var_34_11, arg_34_0)
		end

		get_item_template.next_action = nil
	else
		local num = 0

		for k_2, v_2 in pairs(get_item_template.actions) do
			for k_3, v_3 in pairs(v_2) do
				if k_3 == "default" or not v_3.condition_func then
					local weapon_action_hand = v_3.weapon_action_hand

					weapon_action_hand = weapon_action_hand or "right"

					local action_priority = v_3.action_priority

					action_priority = action_priority or 1

					if num < action_priority then
						local flag_5 = weapon_action_hand ~= "right" or not var_34_1 or var_34_2
						local var_34_40, var_34_41 = fn(arg_34_1, k_2, k_3, v_3, arg_34_2, arg_34_3, false, ammo_extension, flag_5, arg_34_0)

						if not var_34_40 and not var_34_41 then
							var_34_3 = var_34_40
							var_34_4 = var_34_41
							num = action_priority
						end
					end
				end
			end

			local default_2 = get_item_template.actions[k_2].default

			if not default_2 then
				local weapon_action_hand_2 = default_2.weapon_action_hand

				weapon_action_hand_2 = weapon_action_hand_2 or "right"

				local action_priority_2 = default_2.action_priority

				action_priority_2 = action_priority_2 or 1

				if num < action_priority_2 then
					local flag_6 = weapon_action_hand_2 ~= "right" or not var_34_1 or var_34_2
					local var_34_46, var_34_47 = fn(arg_34_1, k_2, "default", default_2, arg_34_2, arg_34_3, false, ammo_extension, flag_6, arg_34_0)

					if not var_34_46 and not var_34_47 then
						var_34_3 = var_34_46
						var_34_4 = var_34_47
						num = action_priority_2
					end
				end
			end
		end
	end

	if not var_34_3 and not var_34_4 then
		local get_career_power_level = ScriptUnit.extension(arg_34_1, "career_system"):get_career_power_level()
		local var_34_49 = get_item_template.actions[var_34_3][var_34_4]
		local weapon_action_hand_3 = var_34_49.weapon_action_hand

		weapon_action_hand_3 = weapon_action_hand_3 or "right"
		tbl_5.new_action = var_34_3
		tbl_5.new_sub_action = var_34_4
		tbl_5.new_action_settings = var_34_49

		if weapon_action_hand_3 == "both" then
			assert(not var_34_2 and var_34_1, "tried to start a dual wield weapon action without both a left and right hand wielded unit")

			if var_34_12 == "left" then
				var_34_2:stop_action("new_interupting_action", tbl_5)
			elseif var_34_12 == "right" then
				var_34_1:stop_action("new_interupting_action", tbl_5)
			elseif var_34_12 == "both" then
				var_34_2:stop_action("new_interupting_action", tbl_5)
				var_34_1:stop_action("new_interupting_action", tbl_5)
			end

			local merge

			if not var_34_27 then
				merge = table.merge(var_34_27, {
					action_hand = "left"
				})

				if not merge then
					-- Nothing
				end
			end

			merge = {
				action_hand = "left"
			}

			do
				local merge_2
			end

			::label_34_1::

			if not var_34_27 then
				merge_2 = table.merge(var_34_27, {
					action_hand = "right"
				})

				if not merge_2 then
					-- Nothing
				end
			end

			merge_2 = {
				action_hand = "right"
			}

			::label_34_2::

			var_34_2:start_action(var_34_3, var_34_4, get_item_template.actions, arg_34_0, get_career_power_level, merge)
			var_34_1:start_action(var_34_3, var_34_4, get_item_template.actions, arg_34_0, get_career_power_level, merge_2)

			return
		end

		if weapon_action_hand_3 == "either" then
			weapon_action_hand_3 = not var_34_1 and "right" and "left"
		end

		if weapon_action_hand_3 == "left" then
			assert(var_34_2, "tried to start a left hand weapon action without a left hand wielded unit")

			if var_34_12 == "right" then
				var_34_1:stop_action("new_interupting_action", tbl_5)
			elseif var_34_12 == "both" then
				var_34_2:stop_action("new_interupting_action", tbl_5)
				var_34_1:stop_action("new_interupting_action", tbl_5)
			end

			var_34_2:start_action(var_34_3, var_34_4, get_item_template.actions, arg_34_0, get_career_power_level, var_34_27)

			return
		end

		assert(var_34_1, "tried to start a right hand weapon action without a right hand wielded unit")

		if var_34_12 == "left" then
			var_34_2:stop_action("new_interupting_action", tbl_5)
		elseif var_34_12 == "both" then
			var_34_2:stop_action("new_interupting_action", tbl_5)
			var_34_1:stop_action("new_interupting_action", tbl_5)
		end

		var_34_1:start_action(var_34_3, var_34_4, get_item_template.actions, arg_34_0, get_career_power_level, var_34_27)

		if not var_34_6 then
			arg_34_2:force_release_input(var_34_6)
		end
	end
end

CharacterStateHelper_2.stop_weapon_actions = function (self, arg_35_1)
	-- function 35
	local equipment = self:equipment()
	local right_hand_wielded_unit = equipment.right_hand_wielded_unit
	local left_hand_wielded_unit = equipment.left_hand_wielded_unit
	local alive = Unit.alive(right_hand_wielded_unit)

	alive = not alive and ScriptUnit.extension(right_hand_wielded_unit, "weapon_system")

	local alive_2 = Unit.alive(left_hand_wielded_unit)

	alive_2 = not alive_2 and ScriptUnit.extension(left_hand_wielded_unit, "weapon_system")

	if not alive and not alive.current_action_settings then
		alive:stop_action(arg_35_1)
	end

	if not alive_2 and not alive_2.current_action_settings then
		alive_2:stop_action(arg_35_1)
	end
end

CharacterStateHelper_2.stop_career_abilities = function (self, arg_36_1)
	-- function 36
	self:stop_ability(arg_36_1)
end

CharacterStateHelper_2.check_crouch = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	-- function 37
	local is_crouching = arg_37_2:is_crouching()
	local var_37_1 = is_crouching
	local get = arg_37_1:get("crouch")
	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_2 = arg_37_1:get("crouching")

	if not is_device_active and not Managers.matchmaking and not Managers.matchmaking:is_matchmaking_in_inn() then
		get = false
		get_2 = false
	end

	if not arg_37_3 and not get then
		var_37_1 = arg_37_2:crouch_toggle()
	elseif not (arg_37_3 or get_2) then
		var_37_1 = false
	elseif arg_37_3 or not get_2 then
		var_37_1 = true
	end

	if not (not var_37_1 and is_crouching) then
		CharacterStateHelper_2.crouch(arg_37_0, arg_37_5, arg_37_4, arg_37_2)
	elseif (var_37_1 or not is_crouching) and not CharacterStateHelper_2.can_uncrouch(arg_37_0) then
		CharacterStateHelper_2.uncrouch(arg_37_0, arg_37_5, arg_37_4, arg_37_2)
	end

	return is_crouching
end

CharacterStateHelper_2.can_uncrouch = function (arg_38_0)
	-- function 38
	local mover = Unit.mover(arg_38_0)
	local position = Mover.position(mover)

	return Unit.mover_fits_at(arg_38_0, "standing", position)
end

CharacterStateHelper_2.crouch = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	CharacterStateHelper_2.play_animation_event(arg_39_0, "to_crouch")
	CharacterStateHelper_2.play_animation_event_first_person(arg_39_2, "to_crouch")
	CharacterStateHelper_2.set_animation_var_first_person(arg_39_2, "is_crouched", 1)
	arg_39_2:set_wanted_player_height("crouch", arg_39_1)
	ScriptUnit.extension(arg_39_0, "locomotion_system"):set_active_mover("crouch")
	arg_39_3:set_crouching(true)
	ScriptUnit.extension(arg_39_0, "buff_system"):trigger_procs("on_crouch")
end

CharacterStateHelper_2.uncrouch = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	CharacterStateHelper_2.play_animation_event(arg_40_0, "to_uncrouch")
	CharacterStateHelper_2.play_animation_event_first_person(arg_40_2, "to_uncrouch")
	CharacterStateHelper_2.set_animation_var_first_person(arg_40_2, "is_crouched", 0)
	arg_40_2:set_wanted_player_height("stand", arg_40_1)
	ScriptUnit.extension(arg_40_0, "locomotion_system"):set_active_mover("standing")
	arg_40_3:set_crouching(false)
end

local num = 0.05
local num_2 = 2.1

CharacterStateHelper_2.get_move_animation = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	local get_movement_input = CharacterStateHelper_2.get_movement_input(arg_41_1)
	local str = "move_fwd"
	local str_2 = "move_bwd"
	local var_41_3

	if not arg_41_2.unit then
		local unit = arg_41_2.unit
		local get_data = Unit.get_data(unit, "breed")

		if not get_data then
			local run_threshold = get_data.run_threshold

			if not run_threshold then
				local walk_threshold = get_data.walk_threshold

				walk_threshold = walk_threshold or run_threshold * 0.9

				local var_41_8 = run_threshold

				if not (arg_41_3 == str or arg_41_3 ~= str_2) then
					var_41_8 = walk_threshold
				end

				var_41_3 = var_41_8 < Vector3.length(Vector3.flat(self:current_velocity()))
			end
		end
	end

	var_41_3 = var_41_3 or Vector3.length(Vector3.flat(self:current_velocity())) > num_2

	if Vector3.length(self:current_velocity()) < num then
		return "idle", "idle"
	end

	if get_movement_input.y < 0 then
		return str_2, not var_41_3 and str_2 and "walk_bwd"
	end

	return str, not var_41_3 and str and "walk_fwd"
end

CharacterStateHelper_2.is_colliding_down = function (arg_42_0)
	-- function 42
	local mover = Unit.mover(arg_42_0)

	return Mover.collides_down(mover)
end

CharacterStateHelper_2.is_colliding_sides = function (arg_43_0)
	-- function 43
	local mover = Unit.mover(arg_43_0)

	return Mover.collides_sides(mover)
end

CharacterStateHelper_2.has_move_input = function (arg_44_0)
	-- function 44
	local get_movement_input = CharacterStateHelper_2.get_movement_input(arg_44_0)

	return Vector3.length(get_movement_input) > 0
end

CharacterStateHelper_2.is_moving = function (self)
	-- function 45
	local current_velocity = self:current_velocity()

	return Vector3.length_squared(current_velocity) > 0.001
end

CharacterStateHelper_2.is_moving_backwards = function (self, arg_46_1)
	-- function 46
	local current_rotation = arg_46_1:current_rotation()
	local flat = Vector3.flat(self:current_velocity())

	return Vector3.dot(flat, current_rotation) < -0.1
end

CharacterStateHelper_2.is_knocked_down = function (self)
	-- function 47
	return self:is_knocked_down()
end

CharacterStateHelper_2.is_staggered = function (self)
	-- function 48
	return self:is_staggered()
end

CharacterStateHelper_2.is_pounced_down = function (self)
	-- function 49
	return self:is_pounced_down()
end

CharacterStateHelper_2.is_catapulted = function (self)
	-- function 50
	local is_catapulted, var_50_1 = self:is_catapulted()

	return is_catapulted, var_50_1
end

CharacterStateHelper_2.is_grabbed_by_pack_master = function (self)
	-- function 51
	return self:is_grabbed_by_pack_master()
end

CharacterStateHelper_2.is_grabbed_by_tentacle = function (self)
	-- function 52
	return self.grabbed_by_tentacle
end

CharacterStateHelper_2.is_in_vortex = function (self)
	-- function 53
	return self.in_vortex
end

CharacterStateHelper_2.is_overcharge_exploding = function (self)
	-- function 54
	return self:is_overcharge_exploding()
end

CharacterStateHelper_2.pack_master_status = function (self)
	-- function 55
	return self.pack_master_status
end

CharacterStateHelper_2.corruptor_status = function (self)
	-- function 56
	return self.corruptor_status
end

CharacterStateHelper_2.grabbed_by_tentacle_status = function (self)
	-- function 57
	return self.grabbed_by_tentacle_status
end

CharacterStateHelper_2.grabbed_by_chaos_spawn_status = function (self)
	-- function 58
	return self.grabbed_by_chaos_spawn_status, self.grabbed_by_chaos_spawn_status_count
end

CharacterStateHelper_2.is_waiting_for_assisted_respawn = function (self)
	-- function 59
	return self:is_ready_for_assisted_respawn()
end

CharacterStateHelper_2.is_assisted_respawning = function (self)
	-- function 60
	return self:is_assisted_respawning()
end

CharacterStateHelper_2.is_pushed = function (self)
	-- function 61
	return self:is_pushed()
end

CharacterStateHelper_2.is_charged = function (self)
	-- function 62
	return self:is_charged()
end

CharacterStateHelper_2.is_block_broken = function (self)
	-- function 63
	return self:is_block_broken()
end

CharacterStateHelper_2.is_dead = function (self)
	-- function 64
	return self:is_dead()
end

CharacterStateHelper_2.is_using_transport = function (self)
	-- function 65
	return self:is_using_transport()
end

CharacterStateHelper_2.is_zooming = function (self)
	-- function 66
	return self:is_zooming()
end

CharacterStateHelper_2.is_crouching = function (self)
	-- function 67
	return self:is_crouching()
end

CharacterStateHelper_2.is_starting_interaction = function (self, arg_68_1)
	-- function 68
	local can_interact, var_68_1, var_68_2, var_68_3 = arg_68_1:can_interact()

	if not GameSettingsDevelopment.disabled_interactions[var_68_2] then
		return false
	end

	local interaction_action_names = InteractionHelper.interaction_action_names(self.unit, var_68_3)

	return not can_interact and var_68_2 == "heal" and var_68_2 == "give_item" or self:get(interaction_action_names, true)
end

CharacterStateHelper_2.is_interacting = function (self)
	-- function 69
	return self:is_interacting()
end

CharacterStateHelper_2.is_waiting_for_interaction_approval = function (self)
	-- function 70
	return self:is_waiting_for_interaction_approval()
end

CharacterStateHelper_2.interact = function (self, arg_71_1)
	-- function 71
	if not arg_71_1:interaction_config().hold then
		local interaction_hold_input = arg_71_1:interaction_hold_input()

		if not self:get(interaction_hold_input) then
			arg_71_1:abort_interaction()

			return false
		end
	end

	return true
end

CharacterStateHelper_2.will_be_ledge_hanging = function (arg_72_0, arg_72_1, arg_72_2)
	-- function 72
	if not script_data.ledge_hanging_turned_off then
		local collision_filter = arg_72_2.collision_filter

		collision_filter = collision_filter or "filter_ledge_collision"

		local is_raycasting_to_gameplay_collision_box, var_72_2 = CharacterStateHelper_2.is_raycasting_to_gameplay_collision_box(arg_72_0, arg_72_1, collision_filter, arg_72_2)

		if not is_raycasting_to_gameplay_collision_box then
			local z = Vector3.z
			local ray_position

			if not arg_72_2 then
				ray_position = arg_72_2.ray_position

				if not ray_position then
					-- Nothing
				end
			end

			ray_position = Unit.world_position(arg_72_1, 0)

			::label_72_0::

			local var_72_5 = z(ray_position)
			local z_offset

			if not arg_72_2 then
				z_offset = arg_72_2.z_offset

				if not z_offset then
					-- Nothing
				end
			end

			z_offset = 0

			::label_72_1::

			local num = var_72_5 + z_offset
			local node = Unit.node(var_72_2, "g_gameplay_ledge_trigger_box")

			if not (num <= Vector3.z(Unit.world_position(var_72_2, node))) then
				arg_72_2.ledge_unit = var_72_2

				return true
			end
		end
	end

	return false
end

local num_3 = 4

CharacterStateHelper_2.is_raycasting_to_gameplay_collision_box = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
	-- function 73
	local get_data = World.get_data(arg_73_0, "physics_world")
	local ray_position

	if not arg_73_3 then
		ray_position = arg_73_3.ray_position

		if not ray_position then
			-- Nothing
		end
	end

	ray_position = POSITION_LOOKUP[arg_73_1]

	::label_73_0::

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_73_1)
	local movement_settings_table_name

	if not arg_73_3 then
		movement_settings_table_name = arg_73_3.movement_settings_table_name

		if not movement_settings_table_name then
			-- Nothing
		end
	end

	movement_settings_table_name = "gameplay_collision_box"

	::label_73_1::

	local collision_check_player_half_height = get_movement_settings_table[movement_settings_table_name].collision_check_player_half_height
	local collision_check_player_height_offset = get_movement_settings_table[movement_settings_table_name].collision_check_player_height_offset
	local num = ray_position + Vector3(0, 0, collision_check_player_height_offset * 2)
	local var_73_7
	local var_73_8
	local immediate_raycast, var_73_10 = PhysicsWorld.immediate_raycast(get_data, num, Vector3.down(), collision_check_player_half_height * 4, "all", "collision_filter", arg_73_2)

	for i = 1, var_73_10 do
		local var_73_11 = immediate_raycast[i][num_3]
		local unit = Actor.unit(var_73_11)

		if not Unit.get_data(unit, "is_ledge_unit") then
			var_73_7 = true
			var_73_8 = unit
		else
			var_73_7 = false
			var_73_8 = nil

			break
		end
	end

	if not var_73_7 and not var_73_8 then
		local radius

		if not arg_73_3 then
			radius = arg_73_3.radius

			if not radius then
				-- Nothing
			end
		end

		radius = 0.15

		::label_73_2::

		local num_2 = 4
		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(get_data, num, num + Vector3.down() * collision_check_player_half_height * 4, radius, num_2, "collision_filter", arg_73_2, "report_initial_overlap")

		if not linear_sphere_sweep then
			for j = 1, #linear_sphere_sweep do
				local actor = linear_sphere_sweep[j].actor
				local unit_2 = Actor.unit(actor)

				if not Unit.get_data(unit_2, "is_ledge_unit") then
					var_73_7 = true
					var_73_8 = unit_2
				else
					var_73_7 = false
					var_73_8 = nil

					break
				end
			end
		end
	end

	return var_73_7, var_73_8
end

CharacterStateHelper_2.is_ledge_hanging = function (arg_74_0, arg_74_1, arg_74_2)
	-- function 74
	if not script_data.ledge_hanging_turned_off then
		local is_colliding_with_gameplay_collision_box, var_74_1 = CharacterStateHelper_2.is_colliding_with_gameplay_collision_box(arg_74_0, arg_74_1, "filter_ledge_collision", arg_74_2)

		if not is_colliding_with_gameplay_collision_box then
			local z = Vector3.z
			local position

			if not arg_74_2 then
				position = arg_74_2.position

				if not position then
					-- Nothing
				end
			end

			position = Unit.world_position(arg_74_1, 0)

			::label_74_0::

			local var_74_4 = z(position)
			local z_offset

			if not arg_74_2 then
				z_offset = arg_74_2.z_offset

				if not z_offset then
					-- Nothing
				end
			end

			z_offset = 0

			::label_74_1::

			local num = var_74_4 + z_offset
			local node = Unit.node(var_74_1, "g_gameplay_ledge_trigger_box")

			if not (num <= Vector3.z(Unit.world_position(var_74_1, node))) then
				arg_74_2.ledge_unit = var_74_1

				return true
			end
		end
	end

	return false
end

CharacterStateHelper_2.recently_left_ladder = function (self, arg_75_1)
	-- function 75
	return self:has_recently_left_ladder(arg_75_1)
end

CharacterStateHelper_2.change_camera_state = function (self, arg_76_1, arg_76_2)
	-- function 76
	if not self.bot_player then
		return
	end

	if not (not Development.parameter("third_person_mode") and arg_76_1 ~= "follow") then
		arg_76_1 = "follow_third_person_over_shoulder"
	end

	Managers.state.entity:system("camera_system"):external_state_change(self, arg_76_1, arg_76_2)
end

CharacterStateHelper_2.change_camera_state_delayed = function (self, arg_77_1, arg_77_2, arg_77_3)
	-- function 77
	if not self.bot_player then
		return
	end

	if not (not Development.parameter("third_person_mode") and arg_77_1 ~= "follow") then
		arg_77_1 = "follow_third_person_over_shoulder"
	end

	Managers.state.entity:system("camera_system"):external_state_change_delayed(self, arg_77_1, arg_77_2, arg_77_3)
end

CharacterStateHelper_2.play_animation_event = function (arg_78_0, arg_78_1)
	-- function 78
	Managers.state.network:anim_event(arg_78_0, arg_78_1)
end

CharacterStateHelper_2.play_animation_event_first_person = function (self, arg_79_1)
	-- function 79
	self:animation_event(arg_79_1)
end

CharacterStateHelper_2.set_animation_var_first_person = function (self, arg_80_1, arg_80_2)
	-- function 80
	self:animation_set_variable(arg_80_1, arg_80_2)
end

CharacterStateHelper_2.play_animation_event_with_variable_float = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	-- function 81
	Managers.state.network:anim_event_with_variable_float(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
end

CharacterStateHelper_2.set_animation_variable_float = function (arg_82_0, arg_82_1, arg_82_2)
	-- function 82
	Managers.state.network:anim_set_variable_float(arg_82_0, arg_82_1, arg_82_2)
end

CharacterStateHelper_2.is_enemy_character = function (arg_83_0)
	-- function 83
	local var_83_0 = Managers.state.side.side_by_unit[arg_83_0]

	if not (not var_83_0 and var_83_0:name() ~= "dark_pact") then
		return true
	end

	return false
end

CharacterStateHelper_2.is_viable_stab_target = function (arg_84_0, arg_84_1, arg_84_2)
	-- function 84
	if not arg_84_2:disabled_by_other(arg_84_0) then
		return false
	end

	local is_using_transport = arg_84_2:is_using_transport()
	local is_enemy_character = CharacterStateHelper_2.is_enemy_character(arg_84_1)

	if is_using_transport or not is_enemy_character then
		return false
	end

	return true
end

CharacterStateHelper_2.ghost_mode = function (self, arg_85_1)
	-- function 85
	if not self:is_in_ghost_mode() then
		if not arg_85_1:get("ghost_mode_enter") and not self:allowed_to_enter() then
			self:try_enter_ghost_mode()
		end
	elseif not self:is_in_ghost_mode() then
		if not arg_85_1:get("ghost_mode_exit") and not self:allowed_to_leave() then
			local flag = false

			self:try_leave_ghost_mode(flag)
		elseif not arg_85_1:get("ghost_mode_enter") then
			local flag_2 = false

			self:teleport_player(flag_2)
		end
	end
end

CharacterStateHelper_2.handle_bot_ledge_hanging_failsafe = function (arg_86_0, arg_86_1)
	-- function 86
	if not arg_86_1 and not ALIVE[arg_86_0] then
		local var_86_0 = BLACKBOARDS[arg_86_0]
		local locomotion_extension = var_86_0.locomotion_extension

		if not locomotion_extension.external_velocity then
			return false
		else
			local current_goal = var_86_0.navigation_extension:current_goal()

			if not current_goal then
				local follow_unit = var_86_0.ai_bot_group_extension.data.follow_unit

				if not ALIVE[follow_unit] then
					current_goal = ScriptUnit.extension(follow_unit, "whereabouts_system"):last_position_on_navmesh()
				else
					current_goal = var_86_0.navigation_extension:destination()
				end
			end

			if not current_goal then
				locomotion_extension:teleport_to(current_goal)

				return true
			end
		end
	end

	return false
end
