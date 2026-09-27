-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_templates_ai.lua

local LocomotionTemplates = LocomotionTemplates

LocomotionTemplates = LocomotionTemplates or {}
LocomotionTemplates = LocomotionTemplates

local LocomotionTemplates_2 = LocomotionTemplates
local var_0_2
local var_0_3
local flag = true

if not flag then
	local start = Profiler.start
	local stop = Profiler.stop
else
	local function fn()
		-- function 1
		return
	end

	local function fn_2()
		-- function 2
		return
	end
end

LocomotionTemplates_2.AILocomotionExtension = {}

LocomotionTemplates_2.AILocomotionExtension.init = function (self, arg_3_1)
	-- function 3
	self.nav_world = arg_3_1
	self.destroy_units = {}
	self.all_update_units = {}
	self.affected_by_gravity_update_units = {}
	self.animation_update_units = {}
	self.animation_and_script_update_units = {}
	self.rotation_speed_modifier_update_units = {}
	self.script_driven_update_units = {}
	self.snap_to_navmesh_update_units = {}
	self.get_to_navmesh_update_units = {}
	self.mover_constrained_update_units = {}
end

LocomotionTemplates_2.AILocomotionExtension.update = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	LocomotionTemplates_2.AILocomotionExtension.validate2(arg_4_0, arg_4_1, arg_4_2)
	LocomotionTemplates_2.AILocomotionExtension.update_alive(arg_4_0, arg_4_1, arg_4_2)
	LocomotionTemplates_2.AILocomotionExtension.update_velocity(arg_4_0, arg_4_1, arg_4_2)
	LocomotionTemplates_2.AILocomotionExtension.update_animation_driven_units(arg_4_0, arg_4_1, arg_4_2)
	LocomotionTemplates_2.AILocomotionExtension.update_gravity(arg_4_0, arg_4_1, arg_4_2)
	LocomotionTemplates_2.AILocomotionExtension.update_rotation(arg_4_0, arg_4_1, arg_4_2)
	LocomotionTemplates_2.AILocomotionExtension.update_position(arg_4_0, arg_4_1, arg_4_2)
	LocomotionTemplates_2.AILocomotionExtension.update_out_of_range(arg_4_0, arg_4_1, arg_4_2)
	LocomotionTemplates_2.AILocomotionExtension.update_network(arg_4_0, arg_4_1, arg_4_2)
end

LocomotionTemplates_2.AILocomotionExtension.validate2 = function (self, arg_5_1, arg_5_2)
	-- function 5
	local all_update_units = self.all_update_units
	local snap_to_navmesh_update_units = self.snap_to_navmesh_update_units
	local get_to_navmesh_update_units = self.get_to_navmesh_update_units
	local mover_constrained_update_units = self.mover_constrained_update_units
	local script_driven_update_units = self.script_driven_update_units

	for k, v in pairs(all_update_units) do
		assert(script_driven_update_units[k] ~= nil or snap_to_navmesh_update_units[k] ~= nil or mover_constrained_update_units[k] ~= nil or get_to_navmesh_update_units[k] ~= nil)

		local _wanted_velocity = v._wanted_velocity

		if not _wanted_velocity then
			fassert(Vector3.is_valid(_wanted_velocity), "Invalid velocity %s", _wanted_velocity)
		end
	end
end

LocomotionTemplates_2.AILocomotionExtension.update_alive = function (self, arg_6_1, arg_6_2)
	-- function 6
	for k, v in pairs(self.destroy_units) do
		self.destroy_units[k] = nil
		self.all_update_units[k] = nil
		self.affected_by_gravity_update_units[k] = nil
		self.animation_update_units[k] = nil
		self.animation_and_script_update_units[k] = nil
		self.rotation_speed_modifier_update_units[k] = nil
		self.script_driven_update_units[k] = nil
		self.snap_to_navmesh_update_units[k] = nil
		self.get_to_navmesh_update_units[k] = nil
		self.mover_constrained_update_units[k] = nil
	end
end

LocomotionTemplates_2.AILocomotionExtension.update_velocity = function (self, arg_7_1, arg_7_2)
	-- function 7
	for k, v in pairs(self.all_update_units) do
		local _wanted_velocity = v._wanted_velocity

		_wanted_velocity = _wanted_velocity or v._velocity:unbox()
		v._wanted_velocity = _wanted_velocity
	end
end

LocomotionTemplates_2.AILocomotionExtension.update_gravity = function (self, arg_8_1, arg_8_2)
	-- function 8
	for k, v in pairs(self.affected_by_gravity_update_units) do
		v._wanted_velocity.z = v._velocity.z - v._gravity * arg_8_2
	end
end

LocomotionTemplates_2.AILocomotionExtension.update_animation_driven_units = function (self, arg_9_1, arg_9_2)
	-- function 9
	for k, v in pairs(self.animation_update_units) do
		local animation_wanted_root_pose = Unit.animation_wanted_root_pose(k)
		local translation = Matrix4x4.translation(animation_wanted_root_pose)
		local rotation = Matrix4x4.rotation(animation_wanted_root_pose)
		local local_position = Unit.local_position(k, 0)
		local local_rotation = Unit.local_rotation(k, 0)
		local up = Quaternion.up(local_rotation)
		local inverse = Quaternion.inverse(local_rotation)
		local multiply = Quaternion.multiply(inverse, rotation)
		local num = Quaternion.yaw(multiply) * v._animation_rotation_scale
		local multiply_2 = Quaternion.multiply(local_rotation, Quaternion(up, num))
		local num_2 = (translation - local_position) / arg_9_2

		v._wanted_velocity = Vector3.multiply_elements(num_2, v:get_animation_translation_scale())
		v._wanted_rotation = multiply_2
	end

	for k_2, v_2 in pairs(self.animation_and_script_update_units) do
		local animation_wanted_root_pose_2 = Unit.animation_wanted_root_pose(k_2)
		local num_3 = (Matrix4x4.translation(animation_wanted_root_pose_2) - Unit.local_position(k_2, 0)) / arg_9_2

		v_2._wanted_velocity = Vector3.multiply_elements(num_3, v_2:get_animation_translation_scale())
	end
end

LocomotionTemplates_2.AILocomotionExtension.update_rotation = function (self, arg_10_1, arg_10_2)
	-- function 10
	local length_squared = Vector3.length_squared
	local flat = Vector3.flat
	local look = Quaternion.look
	local up = Vector3.up()
	local set_local_rotation = Unit.set_local_rotation
	local local_rotation = Unit.local_rotation
	local lerp = Quaternion.lerp

	for k, v in pairs(self.all_update_units) do
		repeat
			local _wanted_velocity = v._wanted_velocity
			local _wanted_rotation = v._wanted_rotation

			if not _wanted_rotation then
				local var_10_9 = flat(_wanted_velocity)

				if length_squared(var_10_9) < 0.010000000000000002 then
					break
				end

				_wanted_rotation = look(var_10_9, up)
			end

			v._wanted_rotation = nil

			if not v._lerp_rotation then
				local num = v._rotation_speed * v._rotation_speed_modifier * arg_10_2

				if num >= 1 then
					local var_10_11 = _wanted_rotation

					set_local_rotation(k, 0, var_10_11)

					break
				end

				local var_10_12 = local_rotation(k, 0)
				local var_10_13 = lerp(var_10_12, _wanted_rotation, num)

				set_local_rotation(k, 0, var_10_13)

				break
			end

			set_local_rotation(k, 0, _wanted_rotation)
		until true
	end

	for k_2, v_2 in pairs(self.rotation_speed_modifier_update_units) do
		local num_2 = v_2._rotation_speed_modifier_lerp_end_time - v_2._rotation_speed_modifier_lerp_start_time
		local num_3 = math.max(0, arg_10_1 - v_2._rotation_speed_modifier_lerp_start_time) / num_2

		if num_3 >= 1 then
			v_2._rotation_speed_modifier = 1
			v_2._rotation_speed_modifier_lerp_end_time = nil
			v_2._rotation_speed_modifier_lerp_start_time = nil
			v_2._rotation_speed_modifier_lerp_start_value = nil
			self.rotation_speed_modifier_update_units[k_2] = nil
		else
			v_2._rotation_speed_modifier = math.lerp(v_2._rotation_speed_modifier_lerp_start_value, 1, num_3)
		end
	end
end

LocomotionTemplates_2.AILocomotionExtension.update_position = function (self, arg_11_1, arg_11_2)
	-- function 11
	local local_position = Unit.local_position
	local set_local_position = Unit.set_local_position
	local mover = Unit.mover
	local move = Mover.move
	local nav_world = self.nav_world
	local num = 0.0001

	if arg_11_2 == 0 then
		arg_11_2 = 0.00016666666666666666
	end

	for k, v in pairs(self.script_driven_update_units) do
		local _wanted_velocity = v._wanted_velocity
		local num_2 = local_position(k, 0) + _wanted_velocity * arg_11_2

		v._velocity:store(_wanted_velocity)
		set_local_position(k, 0, num_2)
	end

	for k_2, v_2 in pairs(self.get_to_navmesh_update_units) do
		local var_11_8
		local var_11_9
		local var_11_10 = POSITION_LOOKUP[k_2]
		local var_11_11 = BLACKBOARDS[k_2]

		if not var_11_11.navigation_extension:has_reached_destination(0.1) then
			var_11_8 = Vector3(0, 0, 0)
			var_11_9 = var_11_10
		else
			local triangle_from_position, var_11_13 = GwNavQueries.triangle_from_position(nav_world, var_11_10, 0.5, 0.5)

			if not triangle_from_position then
				self.get_to_navmesh_update_units[k_2] = nil
				self.snap_to_navmesh_update_units[k_2] = v_2
			else
				local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, var_11_10, 1, 1, 5)

				if not inside_position_from_outside_position then
					if not self.animation_update_units[k_2] then
						var_11_8 = v_2._wanted_velocity
						var_11_9 = var_11_10 - var_11_8 * arg_11_2
					else
						local run_speed = var_11_11.breed.run_speed
						local num_3 = var_11_10 - inside_position_from_outside_position

						var_11_8 = Vector3.normalize(num_3) * run_speed
						var_11_9 = var_11_10 - var_11_8 * arg_11_2
						var_11_8.z = 0
					end
				else
					var_11_8 = Vector3(0, 0, 0)
					var_11_9 = var_11_10
				end

				v_2._velocity:store(var_11_8)
				set_local_position(k_2, 0, var_11_9)
			end
		end
	end

	local length_squared = Vector3.length_squared
	local move_on_navmesh = GwNavQueries.move_on_navmesh
	local triangle_from_position_2 = GwNavQueries.triangle_from_position

	for k_3, v_3 in pairs(self.snap_to_navmesh_update_units) do
		local _wanted_velocity_2 = v_3._wanted_velocity
		local var_11_21 = local_position(k_3, 0)
		local var_11_22 = length_squared(Vector3.flat(_wanted_velocity_2))
		local var_11_23
		local var_11_24
		local var_11_25 = move_on_navmesh(nav_world, var_11_21, _wanted_velocity_2, arg_11_2)
		local num_4 = (var_11_25 - var_11_21) / arg_11_2

		v_3._velocity:store(num_4)
		set_local_position(k_3, 0, var_11_25)
	end

	for k_4, v_4 in pairs(self.mover_constrained_update_units) do
		local var_11_27

		if not v_4._mover_displacement_duration then
			v_4._mover_displacement_t = v_4._mover_displacement_t - arg_11_2
			var_11_27 = v_4._mover_displacement:unbox() * (v_4._mover_displacement_t / v_4._mover_displacement_duration)

			if v_4._mover_displacement_t <= 0 then
				v_4._mover_displacement_duration = nil
			end
		else
			var_11_27 = Vector3(0, 0, 0)
		end

		local var_11_28 = local_position(k_4, 0)
		local _wanted_velocity_3 = v_4._wanted_velocity
		local mover_2 = Unit.mover(k_4)

		move(mover_2, _wanted_velocity_3 * arg_11_2, arg_11_2)

		local num_5 = Mover.position(mover_2) - var_11_27
		local num_6 = (num_5 - var_11_28) / arg_11_2

		if not (not Mover.collides_down(mover_2) and not (Mover.standing_frames(mover_2) > 0)) then
			num_6.z = 0
			v_4._is_falling = false
		else
			num_6.z = _wanted_velocity_3.z

			if not v_4._check_falling then
				local distance_squared = Vector3.distance_squared(v_4._last_fall_position:unbox(), num_5)

				if not (not v_4._is_falling and not (distance_squared > 0.0625)) then
					local get_data = World.get_data(v_4._world, "physics_world")
					local num_7 = 0.5
					local num_8 = 1.5
					local var_11_37 = Vector3(num_7, num_8, num_7)
					local look = Quaternion.look(Vector3(0, 0, 1))
					local num_9 = num_5 + Vector3(0, 0, -1)
					local flag

					flag = not (num_8 - num_7 > 0) or not "capsule" or "sphere"

					local immediate_overlap, var_11_42 = PhysicsWorld.immediate_overlap(get_data, "shape", flag, "position", num_9, "rotation", look, "size", var_11_37, "collision_filter", "filter_environment_overlap")

					v_4._is_falling = var_11_42 == 0

					v_4._last_fall_position:store(num_5)
				end
			end
		end

		v_4._velocity:store(num_6)
		set_local_position(k_4, 0, num_5)
	end

	local set_position = Mover.set_position

	for k_5, v_5 in pairs(self.all_update_units) do
		v_5._wanted_velocity = nil

		local var_11_44 = mover(k_5)

		if not (not var_11_44 and self.mover_constrained_update_units[k_5] ~= nil) then
			set_position(var_11_44, local_position(k_5, 0))
		end
	end
end

LocomotionTemplates_2.AILocomotionExtension.update_out_of_range = function (self, arg_12_1, arg_12_2)
	-- function 12
	local conflict = Managers.state.conflict
	local local_position = Unit.local_position
	local extension = ScriptUnit.extension
	local min = NetworkConstants.position.min
	local max = NetworkConstants.position.max

	for k, v in pairs(self.all_update_units) do
		local var_12_5 = local_position(k, 0)
		local x = var_12_5.x
		local y = var_12_5.y
		local z = var_12_5.z
		local flag = x < min or max < x
		local flag_2 = y < min or max < y
		local flag_3 = z < min or max < z

		if flag or flag_2 or not flag_3 then
			local _blackboard = extension(k, "ai_system")._blackboard

			self.all_update_units[k] = nil

			conflict:destroy_unit(k, _blackboard, "out_of_range")
		end
	end
end

LocomotionTemplates_2.AILocomotionExtension.update_network = function (self, arg_13_1, arg_13_2)
	-- function 13
	local game = Managers.state.network:game()

	if game == nil then
		return
	end

	local unit_storage = Managers.state.unit_storage
	local local_position = Unit.local_position
	local local_rotation = Unit.local_rotation
	local min = Vector3.min
	local max = Vector3.max
	local set_game_object_field = GameSession.set_game_object_field
	local enemy_velocity = NetworkConstants.enemy_velocity
	local min_2 = enemy_velocity.min
	local max_2 = enemy_velocity.max
	local var_13_10 = Vector3(min_2, min_2, min_2)
	local var_13_11 = Vector3(max_2, max_2, max_2)

	for k, v in pairs(self.all_update_units) do
		local go_id = unit_storage:go_id(k)
		local var_13_13 = local_position(k, 0)
		local var_13_14 = local_rotation(k, 0)
		local yaw = Quaternion.yaw(var_13_14)
		local unbox = v._velocity:unbox()

		set_game_object_field(game, go_id, "position", var_13_13)
		set_game_object_field(game, go_id, "yaw_rot", yaw)

		local var_13_17 = min(max(unbox, var_13_10), var_13_11)

		set_game_object_field(game, go_id, "velocity", var_13_17)
	end
end
