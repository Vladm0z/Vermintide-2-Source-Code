-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_templates_player.lua

local LocomotionTemplates = LocomotionTemplates

LocomotionTemplates = LocomotionTemplates or {}
LocomotionTemplates = LocomotionTemplates

local LocomotionTemplates_2 = LocomotionTemplates
local LEVEL_EDITOR_TEST = LEVEL_EDITOR_TEST
local var_0_3
local var_0_4
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

local flag_2 = false

LocomotionTemplates_2.PlayerUnitLocomotionExtension = {}

local PlayerUnitLocomotionExtension = LocomotionTemplates_2.PlayerUnitLocomotionExtension

PlayerUnitLocomotionExtension.init = function (self, arg_3_1)
	-- function 3
	self.nav_world = arg_3_1
	self.all_update_units = {}
	self.all_disabled_units = {}

	if not flag_2 then
		self.drawer = Managers.state.debug:drawer({
			mode = "immediate",
			name = "PlayerUnitLocomotionExtension"
		})

		GraphHelper.create("PlayerUnitLocomotionExtension", {
			"move_speed"
		}, {
			"move_velocity"
		})
		GraphHelper.set_range("PlayerUnitLocomotionExtension", -10, 10)
		GraphHelper.hide("PlayerUnitLocomotionExtension")
	end
end

PlayerUnitLocomotionExtension.update = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	PlayerUnitLocomotionExtension.update_movement(arg_4_0, arg_4_1, arg_4_2)
	PlayerUnitLocomotionExtension.update_rotation(arg_4_0, arg_4_1, arg_4_2)
	PlayerUnitLocomotionExtension.update_network(arg_4_0, arg_4_2)
	PlayerUnitLocomotionExtension.update_average_velocity(arg_4_0, arg_4_1, arg_4_2)
	PlayerUnitLocomotionExtension.update_disabled_units(arg_4_0, arg_4_2)
end

PlayerUnitLocomotionExtension.update_average_velocity = function (self, arg_5_1, arg_5_2)
	-- function 5
	local all_update_units = self.all_update_units
	local num = 0.125
	local var_5_2, var_5_3 = next(all_update_units, self.last_average_velocity_unit)

	if not var_5_2 then
		var_5_2, var_5_3 = next(all_update_units)
	end

	if not var_5_2 then
		local _sample_velocity_time = var_5_3._sample_velocity_time
		local _sample_velocity_index = var_5_3._sample_velocity_index
		local _sample_velocities = var_5_3._sample_velocities
		local count = #_sample_velocities
		local var_5_8

		while num < arg_5_1 - _sample_velocity_time do
			_sample_velocity_time = _sample_velocity_time + num
			_sample_velocity_index = _sample_velocity_index % count + 1

			_sample_velocities[_sample_velocity_index]:store(var_5_3.velocity_current:unbox())

			var_5_8 = true
		end

		if not var_5_8 then
			var_5_3._sample_velocity_index = _sample_velocity_index
			var_5_3._sample_velocity_time = _sample_velocity_time

			local var_5_9 = Vector3(0, 0, 0)

			for i, v in ipairs(_sample_velocities) do
				var_5_9 = var_5_9 + v:unbox()
			end

			var_5_3._average_velocity:store(var_5_9 / count)

			local num_2 = 7
			local var_5_11 = Vector3(0, 0, 0)
			local var_5_12 = _sample_velocity_index

			for k = 1, num_2 do
				var_5_11 = var_5_11 + _sample_velocities[var_5_12]:unbox()
				var_5_12 = var_5_12 - 1

				if var_5_12 == 0 then
					var_5_12 = count
				end
			end

			var_5_3._small_sample_size_average_velocity:store(var_5_11 / num_2)
		end
	end

	self.last_average_velocity_unit = var_5_2
end

local num = 0.2

PlayerUnitLocomotionExtension.update_movement = function (self, arg_6_1, arg_6_2)
	-- function 6
	local world = Managers.world:world("level_world")
	local get_data = World.get_data(world, "physics_world")

	for k, v in pairs(self.all_update_units) do
		v.IS_NEW_FRAME = false

		if not Mover.collides_down(Unit.mover(k)) then
			v.time_since_last_down_collide = 0
			v.collides_down = true
		else
			v.time_since_last_down_collide = v.time_since_last_down_collide + arg_6_2
			v.collides_down = not (v.time_since_last_down_collide < num) or v.collides_down
		end

		local on_ground = v.on_ground
		local num_2 = 0.3
		local look = Quaternion.look(Vector3(0, 0, 1))

		if not on_ground then
			local immediate_overlap, var_6_6 = PhysicsWorld.immediate_overlap(get_data, "shape", "sphere", "position", POSITION_LOOKUP[k], "rotation", look, "size", num_2, "collision_filter", v._default_mover_filter)

			v.on_ground = var_6_6 > 0 or Mover.flying_frames(Unit.mover(k)) ~= 0 or v.velocity_wanted:unbox().z <= 0
		else
			v.on_ground = Mover.flying_frames(Unit.mover(k)) ~= 0 or v.velocity_wanted:unbox().z <= 0
		end

		local state = v.state

		if state ~= "script_driven" then
			v.external_velocity = nil
		end

		if state == "script_driven" then
			local flag = true

			v:update_script_driven_movement(k, arg_6_2, arg_6_1, flag)
		elseif state == "animation_driven" then
			v:update_animation_driven_movement(k, arg_6_2, arg_6_1)
		elseif state == "animation_driven_entrance_and_exit_no_mover" then
			v:update_animation_driven_movement_entrance_and_exit_no_mover(k, arg_6_2, arg_6_1)
		elseif state == "animation_driven_with_rotation_no_mover" then
			v:update_animation_driven_movement_with_rotation_no_mover(k, arg_6_2, arg_6_1)
		elseif state == "linked_movement" then
			v:update_linked_movement(k, arg_6_2, arg_6_1)
		elseif state == "script_driven_ladder" then
			local flag_2 = false

			v:update_script_driven_movement(k, arg_6_2, arg_6_1, flag_2)
		elseif state == "script_driven_ladder_transition_movement" then
			v:update_script_driven_ladder_transition_movement(k, arg_6_2, arg_6_1)
		elseif state == "script_driven_no_mover" then
			v:update_script_driven_no_mover_movement(k, arg_6_2, arg_6_1)
		elseif state == "wanted_position_mover" then
			v:update_wanted_position_movement(k, arg_6_2, arg_6_1)
		end

		if not v.has_moved_from_start_position then
			local unbox = v._start_position:unbox()
			local var_6_11 = POSITION_LOOKUP[k]

			if Vector3.distance_squared(unbox, var_6_11) > 0.25 then
				v.has_moved_from_start_position = true
			end
		end
	end
end

PlayerUnitLocomotionExtension.update_network = function (self, arg_7_1)
	-- function 7
	local game = Managers.state.network:game()

	if not game and not LEVEL_EDITOR_TEST then
		return
	end

	local num = 99.9999
	local position = NetworkConstants.position
	local min = position.min
	local max = position.max
	local min_2 = NetworkConstants.velocity.min
	local max_2 = NetworkConstants.velocity.max
	local local_rotation = Unit.local_rotation
	local set_game_object_field = GameSession.set_game_object_field
	local local_position = Unit.local_position

	for k, v in pairs(self.all_update_units) do
		local go_id = Managers.state.unit_storage:go_id(k)
		local var_7_11 = local_rotation(k, 0)
		local yaw = Quaternion.yaw(var_7_11)
		local pitch = Quaternion.pitch(var_7_11)

		set_game_object_field(game, go_id, "yaw", yaw)
		set_game_object_field(game, go_id, "pitch", pitch)

		local var_7_14 = local_position(k, 0)
		local unbox = v.velocity_network:unbox()
		local get_moving_platform, var_7_17 = v:get_moving_platform()

		if not get_moving_platform then
			var_7_14 = var_7_14 - Unit.local_position(get_moving_platform, 0)
			var_7_14 = var_7_14 - var_7_17:visual_delta()
		end

		set_game_object_field(game, go_id, "position", Vector3.clamp(var_7_14, min, max))
		set_game_object_field(game, go_id, "has_moved_from_start_position", v.has_moved_from_start_position)

		local min_3 = math.min
		local anim_move_speed = v.anim_move_speed

		anim_move_speed = anim_move_speed or Vector3.length(v.velocity_current:unbox())

		local var_7_20 = min_3(anim_move_speed, num)

		Unit.animation_set_variable(k, v.move_speed_anim_var, var_7_20)
		set_game_object_field(game, go_id, "velocity", Vector3.clamp(unbox, min_2, max_2))
		set_game_object_field(game, go_id, "average_velocity", Vector3.clamp(v._average_velocity:unbox(), min_2, max_2))
		set_game_object_field(game, go_id, "small_sample_size_average_velocity", Vector3.clamp(v._small_sample_size_average_velocity:unbox(), min_2, max_2))
	end
end

PlayerUnitLocomotionExtension.update_statistics = function (self, arg_8_1, arg_8_2)
	-- function 8
	for k, v in pairs(self.all_update_units) do
		GraphHelper.record_statistics("move_velocity", v.velocity_current:unbox())
		GraphHelper.record_statistics("move_speed", Vector3.length(v.velocity_current:unbox()))
	end
end

PlayerUnitLocomotionExtension.update_rotation = function (self, arg_9_1, arg_9_2)
	-- function 9
	local is_server = Managers.player.is_server
	local set_local_rotation = Unit.set_local_rotation
	local lerp = Quaternion.lerp
	local look = Quaternion.look
	local forward = Quaternion.forward
	local smoothstep = math.smoothstep
	local normalize = Vector3.normalize
	local flat = Vector3.flat
	local dot = Vector3.dot

	for k, v in pairs(self.all_update_units) do
		if not v.disable_rotation_update then
			if not v.rotate_along_direction then
				local current_rotation = v.first_person_extension:current_rotation()
				local var_9_10 = flat(forward(current_rotation))
				local unbox = v.velocity_current:unbox()

				unbox.z = 0

				local var_9_12 = dot(unbox, var_9_10)

				if var_9_12 == 0 then
					local var_9_13 = normalize(var_9_10)
					local unbox_2 = v.target_rotation:unbox()
					local var_9_15 = flat(forward(unbox_2))
					local var_9_16 = normalize(var_9_15)

					if not (dot(var_9_13, var_9_16) < 0) then
						v.target_rotation:store(current_rotation)

						v.disable_rotation_update_when_still = false
					end

					unbox = var_9_15
				else
					v.target_rotation:store(current_rotation)
				end

				if var_9_12 < -0.1 then
					unbox = -unbox
				end

				local var_9_17 = look(unbox)

				Unit.set_local_rotation(k, 0, lerp(Unit.local_rotation(k, 0), var_9_17, arg_9_2 * 5))
			elseif not v.target_rotation_data then
				local target_rotation_data = v.target_rotation_data
				local unbox_3 = target_rotation_data.start_rotation:unbox()
				local unbox_4 = target_rotation_data.target_rotation:unbox()
				local start_time = target_rotation_data.start_time
				local end_time = target_rotation_data.end_time
				local var_9_23 = smoothstep(arg_9_1, start_time, end_time)

				set_local_rotation(k, 0, lerp(unbox_3, unbox_4, var_9_23))
			end
		end

		if not is_server then
			local world_position = Unit.world_position(k, 0)
			local triangle_from_position, var_9_26 = GwNavQueries.triangle_from_position(v._nav_world, world_position, 0.1, 0.3, v._nav_traverse_logic)

			if not triangle_from_position then
				v._latest_position_on_navmesh:store(Vector3(world_position.x, world_position.y, world_position.z))
			end
		end

		v.disable_rotation_update = false
	end
end

PlayerUnitLocomotionExtension.update_disabled_units = function (self, arg_10_1)
	-- function 10
	for k, v in pairs(self.all_disabled_units) do
		v.run_func(k, arg_10_1, v)

		local game = Managers.state.network:game()
		local go_id = Managers.state.unit_storage:go_id(k)

		if not game and not go_id then
			v:sync_network_rotation(game, go_id)
			v:sync_network_position(game, go_id)
			v:sync_network_velocity(game, go_id, arg_10_1)
		end

		return
	end
end

PlayerUnitLocomotionExtension.update_debug_anims = function (self)
	-- function 11
	for k, v in pairs(self.all_update_units) do
		local get_first_person_unit = v.first_person_extension:get_first_person_unit()

		if not (not script_data.debug_first_person_player_animations and v.debugging_1p_animations) then
			v.debugging_1p_animations = true

			Unit.set_animation_logging(get_first_person_unit, true)
		elseif not (not v.debugging_1p_animations and script_data.debug_first_person_player_animations) then
			v.debugging_1p_animations = false

			Unit.set_animation_logging(get_first_person_unit, false)
		end

		if not (not script_data.debug_player_animations and v.debugging_animations) then
			v.debugging_animations = true

			Unit.set_animation_logging(k, true)
		elseif not (not v.debugging_animations and script_data.debug_player_animations) then
			v.debugging_animations = false

			Unit.set_animation_logging(k, false)
		end
	end
end
