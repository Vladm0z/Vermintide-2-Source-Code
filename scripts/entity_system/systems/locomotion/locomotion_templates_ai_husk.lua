-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_templates_ai_husk.lua

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

LocomotionTemplates_2.AiHuskLocomotionExtension = {}

LocomotionTemplates_2.AiHuskLocomotionExtension.init = function (self, arg_3_1)
	-- function 3
	self.nav_world = arg_3_1
	self.destroy_units = {}
	self.all_update_units = {}
	self.affected_by_gravity_update_units = {}
	self.pure_network_update_units = {}
	self.other_update_units = {}
end

local flag_2 = false

LocomotionTemplates_2.AiHuskLocomotionExtension.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	local game = Managers.state.network:game()

	if game == nil then
		return
	end

	self.game = game

	if not flag_2 then
		LocomotionTemplates_2.AiHuskLocomotionExtension.update_alive(self, arg_4_1, arg_4_2)
		LocomotionTemplates_2.AiHuskLocomotionExtension.update_pure_network_update_units(self, arg_4_1, arg_4_2)
		LocomotionTemplates_2.AiHuskLocomotionExtension.update_other_update_units_navmesh_check(self, arg_4_1, arg_4_2)
		LocomotionTemplates_2.AiHuskLocomotionExtension.update_other_update_units(self, arg_4_1, arg_4_2)
	else
		LocomotionTemplates_2.AiHuskLocomotionExtension.update_other_update_units_navmesh_check(self, arg_4_1, arg_4_2)
		EngineOptimizedExtensions.ai_husk_locomotion_update(arg_4_2, game, self.all_update_units)
	end
end

LocomotionTemplates_2.AiHuskLocomotionExtension.update_alive = function (self, arg_5_1, arg_5_2)
	-- function 5
	local all_update_units = self.all_update_units
	local pure_network_update_units = self.pure_network_update_units
	local other_update_units = self.other_update_units

	for k, v in pairs(all_update_units) do
		if not HEALTH_ALIVE[k] then
			all_update_units[k] = nil
			pure_network_update_units[k] = nil
			other_update_units[k] = nil
		end
	end
end

LocomotionTemplates_2.AiHuskLocomotionExtension.update_pure_network_update_units = function (self, arg_6_1, arg_6_2)
	-- function 6
	local game_object_field = GameSession.game_object_field
	local length_squared = Vector3.length_squared
	local length = Vector3.length
	local record_statistics = Profiler.record_statistics
	local set_local_position = Unit.set_local_position
	local set_local_rotation = Unit.set_local_rotation
	local local_rotation = Unit.local_rotation
	local lerp = Quaternion.lerp
	local min = math.min
	local max = math.max
	local zero = Vector3.zero()
	local POSITION_LOOKUP = POSITION_LOOKUP
	local num = NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON
	local num_2 = 0.0001
	local num_3 = 0.1
	local num_4 = 0.97
	local min_2 = math.min(arg_6_2 * 15, 1)
	local game = self.game
	local unit_storage = Managers.state.unit_storage

	for k, v in pairs(self.pure_network_update_units) do
		local var_6_19 = POSITION_LOOKUP[k]
		local go_id = unit_storage:go_id(k)
		local var_6_21 = game_object_field(game, go_id, "position")
		local var_6_22 = game_object_field(game, go_id, "has_teleported")
		local var_6_23 = game_object_field(game, go_id, "yaw_rot")
		local var_6_24 = game_object_field(game, go_id, "velocity")

		if num > length_squared(var_6_24) then
			var_6_24 = Vector3(0, 0, 0)
		end

		local var_6_25

		if v.has_teleported ~= var_6_22 then
			v.has_teleported = var_6_22
			v._pos_lerp_time = 0

			v.last_lerp_position:store(var_6_21)
			v.last_lerp_position_offset:store(zero)
			v.accumulated_movement:store(zero)

			var_6_25 = var_6_21
		else
			local unbox = v.last_lerp_position:unbox()
			local unbox_2 = v.last_lerp_position_offset:unbox()
			local unbox_3 = v.accumulated_movement:unbox()

			v._pos_lerp_time = v._pos_lerp_time + arg_6_2

			local num_5 = v._pos_lerp_time / num_3
			local num_6 = unbox_3 + var_6_24 * arg_6_2
			local lerp_2 = Vector3.lerp(unbox_2, zero, min(num_5, 1))

			var_6_25 = unbox + num_6 + lerp_2

			if num_2 < length_squared(var_6_21 - unbox) then
				v._pos_lerp_time = 0

				v.last_lerp_position:store(var_6_21)
				v.last_lerp_position_offset:store(var_6_25 - var_6_21)
				v.accumulated_movement:store(zero)
			else
				v.accumulated_movement:store(num_6)
			end
		end

		if not v.is_constrained then
			var_6_25 = Vector3.clamp_3d(var_6_25, v.constrain_min, v.constrain_max)
		end

		set_local_position(k, 0, var_6_25)

		local var_6_32 = local_rotation(k, 0)
		local var_6_33 = Quaternion(Vector3.up(), var_6_23)

		set_local_rotation(k, 0, lerp(var_6_32, var_6_33, min_2))
		v._velocity:store(var_6_24)

		local mover = Unit.mover(k)

		assert(mover == nil, "remove this assert if you see this")

		local var_6_35 = Vector3(var_6_24.x, var_6_24.y, 0)
		local length_2 = Vector3.length(var_6_35)

		Unit.animation_set_variable(k, v._move_speed_anim_var, max(length_2, num_4))
	end
end

local num = 0.5

LocomotionTemplates_2.AiHuskLocomotionExtension.update_other_update_units_navmesh_check = function (self, arg_7_1, arg_7_2)
	-- function 7
	local nav_world = self.nav_world
	local var_7_1
	local var_7_2

	for k, v in pairs(self.other_update_units) do
		if not (v.is_network_driven or v.hit_wall or Unit.mover(k) ~= nil) then
			local local_position = Unit.local_position(k, 0)

			var_7_2 = var_7_2 or v:traverse_logic()
			var_7_1 = var_7_1 or World.physics_world(v._world)

			local current_velocity = v:current_velocity()
			local navmesh_movement_check = LocomotionUtils.navmesh_movement_check(local_position, current_velocity, nav_world, var_7_1, var_7_2)

			if navmesh_movement_check == "navmesh_hit_wall" then
				v.hit_wall = true
			elseif navmesh_movement_check == "navmesh_use_mover" then
				v:set_mover_disable_reason("not_constrained_by_mover", false)

				local mover = Unit.mover(k)

				if not mover then
					local override_mover_move_distance = v.breed.override_mover_move_distance

					override_mover_move_distance = override_mover_move_distance or num

					Mover.set_position(mover, local_position)

					if not LocomotionUtils.separate_mover_fallbacks(mover, override_mover_move_distance) then
						local position = Mover.position(mover)

						Unit.set_local_position(k, 0, position)
					else
						v:set_mover_disable_reason("not_constrained_by_mover", true)

						v.hit_wall = true
					end
				end
			end
		end
	end
end

LocomotionTemplates_2.AiHuskLocomotionExtension.update_other_update_units = function (self, arg_8_1, arg_8_2)
	-- function 8
	local game_object_field = GameSession.game_object_field
	local length_squared = Vector3.length_squared
	local length = Vector3.length
	local set_local_position = Unit.set_local_position
	local set_local_rotation = Unit.set_local_rotation
	local local_rotation = Unit.local_rotation
	local lerp = Quaternion.lerp
	local num = NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON
	local num_2 = 0.97
	local game = self.game
	local unit_storage = Managers.state.unit_storage
	local nav_world = self.nav_world
	local var_8_12

	for k, v in pairs(self.other_update_units) do
		local go_id = unit_storage:go_id(k)
		local local_position = Unit.local_position(k, 0)

		var_8_12 = var_8_12 or v:traverse_logic()

		local animation_wanted_root_pose = Unit.animation_wanted_root_pose(k)
		local translation = Matrix4x4.translation(animation_wanted_root_pose)
		local var_8_17

		if not v.has_network_driven_rotation then
			local var_8_18 = game_object_field(game, go_id, "yaw_rot")

			var_8_17 = Quaternion(Vector3.up(), var_8_18)
		else
			local rotation = Matrix4x4.rotation(animation_wanted_root_pose)
			local local_rotation_2 = Unit.local_rotation(k, 0)
			local up = Quaternion.up(local_rotation_2)
			local inverse = Quaternion.inverse(local_rotation_2)
			local multiply = Quaternion.multiply(inverse, rotation)
			local num_3 = Quaternion.yaw(multiply) * v._animation_rotation_scale

			var_8_17 = Quaternion.multiply(local_rotation_2, Quaternion(up, num_3))
		end

		local var_8_25 = game_object_field(game, go_id, "velocity")

		if num > length_squared(var_8_25) then
			var_8_25 = Vector3(0, 0, 0)
		end

		local var_8_26 = var_8_25
		local var_8_27
		local var_8_28
		local mover = Unit.mover(k)

		if not (not v.is_affected_by_gravity and mover == nil) then
			var_8_26.z = v._velocity:unbox().z - 9.82 * arg_8_2

			Mover.move(mover, var_8_26 * arg_8_2, arg_8_2)

			var_8_27 = Mover.position(mover)
			var_8_28 = (var_8_27 - local_position) / arg_8_2

			if not (not Mover.collides_down(mover) and not (Mover.standing_frames(mover) > 0)) then
				var_8_28.z = 0
			else
				var_8_28.z = var_8_26.z
			end
		else
			var_8_27 = GwNavQueries.move_on_navmesh(nav_world, local_position, var_8_26, arg_8_2, var_8_12)
			var_8_28 = var_8_26
		end

		if not v.is_constrained then
			var_8_27 = Vector3.clamp_3d(var_8_27, v.constrain_min, v.constrain_max)
		end

		set_local_position(k, 0, var_8_27)
		set_local_rotation(k, 0, var_8_17)
		v._velocity:store(var_8_28)

		v._pos_lerp_time = 0

		v.last_lerp_position:store(var_8_27)
		v.last_lerp_position_offset:store(Vector3(0, 0, 0))
		v.accumulated_movement:store(Vector3(0, 0, 0))

		if mover ~= nil then
			Mover.set_position(mover, var_8_27)
		end

		local var_8_30 = Vector3(var_8_28.x, var_8_28.y, 0)
		local var_8_31 = length(var_8_30)

		Unit.animation_set_variable(k, v._move_speed_anim_var, math.max(var_8_31, num_2))
	end
end
