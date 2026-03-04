-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_templates_player.lua

LocomotionTemplates = LocomotionTemplates or {}

local var_0_0 = LocomotionTemplates
local var_0_1 = LEVEL_EDITOR_TEST
local var_0_2
local var_0_3
local var_0_4 = true

if var_0_4 then
	local var_0_5 = Profiler.start
	local var_0_6 = Profiler.stop
else
	local function var_0_7()
		return
	end

	local function var_0_8()
		return
	end
end

local var_0_9 = false

var_0_0.PlayerUnitLocomotionExtension = {}

local var_0_10 = var_0_0.PlayerUnitLocomotionExtension

function var_0_10.init(arg_3_0, arg_3_1)
	arg_3_0.nav_world = arg_3_1
	arg_3_0.all_update_units = {}
	arg_3_0.all_disabled_units = {}

	if var_0_9 then
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

function var_0_10.update(arg_4_0, arg_4_1, arg_4_2)
	var_0_10.update_movement(arg_4_0, arg_4_1, arg_4_2)
	var_0_10.update_rotation(arg_4_0, arg_4_1, arg_4_2)
	var_0_10.update_network(arg_4_0, arg_4_2)
	var_0_10.update_average_velocity(arg_4_0, arg_4_1, arg_4_2)
	var_0_10.update_disabled_units(arg_4_0, arg_4_2)
end

function var_0_10.update_average_velocity(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.all_update_units
	local var_5_1 = 0.125
	local var_5_2, var_5_3 = next(var_5_0, arg_5_0.last_average_velocity_unit)

	if not var_5_2 then
		var_5_2, var_5_3 = next(var_5_0)
	end

	if var_5_2 then
		local var_5_4 = var_5_3._sample_velocity_time
		local var_5_5 = var_5_3._sample_velocity_index
		local var_5_6 = var_5_3._sample_velocities
		local var_5_7 = #var_5_6
		local var_5_8

		while var_5_1 < arg_5_1 - var_5_4 do
			var_5_4 = var_5_4 + var_5_1
			var_5_5 = var_5_5 % var_5_7 + 1

			var_5_6[var_5_5]:store(var_5_3.velocity_current:unbox())

			var_5_8 = true
		end

		if var_5_8 then
			var_5_3._sample_velocity_index = var_5_5
			var_5_3._sample_velocity_time = var_5_4

			local var_5_9 = Vector3(0, 0, 0)

			for iter_5_0, iter_5_1 in ipairs(var_5_6) do
				var_5_9 = var_5_9 + iter_5_1:unbox()
			end

			var_5_3._average_velocity:store(var_5_9 / var_5_7)

			local var_5_10 = 7
			local var_5_11 = Vector3(0, 0, 0)
			local var_5_12 = var_5_5

			for iter_5_2 = 1, var_5_10 do
				var_5_11 = var_5_11 + var_5_6[var_5_12]:unbox()
				var_5_12 = var_5_12 - 1

				if var_5_12 == 0 then
					var_5_12 = var_5_7
				end
			end

			var_5_3._small_sample_size_average_velocity:store(var_5_11 / var_5_10)
		end
	end

	arg_5_0.last_average_velocity_unit = var_5_2
end

local var_0_11 = 0.2

function var_0_10.update_movement(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.world:world("level_world")
	local var_6_1 = World.get_data(var_6_0, "physics_world")

	for iter_6_0, iter_6_1 in pairs(arg_6_0.all_update_units) do
		iter_6_1.IS_NEW_FRAME = false

		if Mover.collides_down(Unit.mover(iter_6_0)) then
			iter_6_1.time_since_last_down_collide = 0
			iter_6_1.collides_down = true
		else
			iter_6_1.time_since_last_down_collide = iter_6_1.time_since_last_down_collide + arg_6_2
			iter_6_1.collides_down = iter_6_1.time_since_last_down_collide < var_0_11 and iter_6_1.collides_down
		end

		local var_6_2 = iter_6_1.on_ground
		local var_6_3 = 0.3
		local var_6_4 = Quaternion.look(Vector3(0, 0, 1))

		if var_6_2 then
			local var_6_5, var_6_6 = PhysicsWorld.immediate_overlap(var_6_1, "shape", "sphere", "position", POSITION_LOOKUP[iter_6_0], "rotation", var_6_4, "size", var_6_3, "collision_filter", iter_6_1._default_mover_filter)

			iter_6_1.on_ground = var_6_6 > 0 or Mover.flying_frames(Unit.mover(iter_6_0)) == 0 and iter_6_1.velocity_wanted:unbox().z <= 0
		else
			iter_6_1.on_ground = Mover.flying_frames(Unit.mover(iter_6_0)) == 0 and iter_6_1.velocity_wanted:unbox().z <= 0
		end

		local var_6_7 = iter_6_1.state

		if var_6_7 ~= "script_driven" then
			iter_6_1.external_velocity = nil
		end

		if var_6_7 == "script_driven" then
			local var_6_8 = true

			iter_6_1:update_script_driven_movement(iter_6_0, arg_6_2, arg_6_1, var_6_8)
		elseif var_6_7 == "animation_driven" then
			iter_6_1:update_animation_driven_movement(iter_6_0, arg_6_2, arg_6_1)
		elseif var_6_7 == "animation_driven_entrance_and_exit_no_mover" then
			iter_6_1:update_animation_driven_movement_entrance_and_exit_no_mover(iter_6_0, arg_6_2, arg_6_1)
		elseif var_6_7 == "animation_driven_with_rotation_no_mover" then
			iter_6_1:update_animation_driven_movement_with_rotation_no_mover(iter_6_0, arg_6_2, arg_6_1)
		elseif var_6_7 == "linked_movement" then
			iter_6_1:update_linked_movement(iter_6_0, arg_6_2, arg_6_1)
		elseif var_6_7 == "script_driven_ladder" then
			local var_6_9 = false

			iter_6_1:update_script_driven_movement(iter_6_0, arg_6_2, arg_6_1, var_6_9)
		elseif var_6_7 == "script_driven_ladder_transition_movement" then
			iter_6_1:update_script_driven_ladder_transition_movement(iter_6_0, arg_6_2, arg_6_1)
		elseif var_6_7 == "script_driven_no_mover" then
			iter_6_1:update_script_driven_no_mover_movement(iter_6_0, arg_6_2, arg_6_1)
		elseif var_6_7 == "wanted_position_mover" then
			iter_6_1:update_wanted_position_movement(iter_6_0, arg_6_2, arg_6_1)
		end

		if not iter_6_1.has_moved_from_start_position then
			local var_6_10 = iter_6_1._start_position:unbox()
			local var_6_11 = POSITION_LOOKUP[iter_6_0]

			if Vector3.distance_squared(var_6_10, var_6_11) > 0.25 then
				iter_6_1.has_moved_from_start_position = true
			end
		end
	end
end

function var_0_10.update_network(arg_7_0, arg_7_1)
	local var_7_0 = Managers.state.network:game()

	if not var_7_0 or var_0_1 then
		return
	end

	local var_7_1 = 99.9999
	local var_7_2 = NetworkConstants.position
	local var_7_3 = var_7_2.min
	local var_7_4 = var_7_2.max
	local var_7_5 = NetworkConstants.velocity.min
	local var_7_6 = NetworkConstants.velocity.max
	local var_7_7 = Unit.local_rotation
	local var_7_8 = GameSession.set_game_object_field
	local var_7_9 = Unit.local_position

	for iter_7_0, iter_7_1 in pairs(arg_7_0.all_update_units) do
		local var_7_10 = Managers.state.unit_storage:go_id(iter_7_0)
		local var_7_11 = var_7_7(iter_7_0, 0)
		local var_7_12 = Quaternion.yaw(var_7_11)
		local var_7_13 = Quaternion.pitch(var_7_11)

		var_7_8(var_7_0, var_7_10, "yaw", var_7_12)
		var_7_8(var_7_0, var_7_10, "pitch", var_7_13)

		local var_7_14 = var_7_9(iter_7_0, 0)
		local var_7_15 = iter_7_1.velocity_network:unbox()
		local var_7_16, var_7_17 = iter_7_1:get_moving_platform()

		if var_7_16 then
			var_7_14 = var_7_14 - Unit.local_position(var_7_16, 0)
			var_7_14 = var_7_14 - var_7_17:visual_delta()
		end

		var_7_8(var_7_0, var_7_10, "position", Vector3.clamp(var_7_14, var_7_3, var_7_4))
		var_7_8(var_7_0, var_7_10, "has_moved_from_start_position", iter_7_1.has_moved_from_start_position)

		local var_7_18 = math.min(iter_7_1.anim_move_speed or Vector3.length(iter_7_1.velocity_current:unbox()), var_7_1)

		Unit.animation_set_variable(iter_7_0, iter_7_1.move_speed_anim_var, var_7_18)
		var_7_8(var_7_0, var_7_10, "velocity", Vector3.clamp(var_7_15, var_7_5, var_7_6))
		var_7_8(var_7_0, var_7_10, "average_velocity", Vector3.clamp(iter_7_1._average_velocity:unbox(), var_7_5, var_7_6))
		var_7_8(var_7_0, var_7_10, "small_sample_size_average_velocity", Vector3.clamp(iter_7_1._small_sample_size_average_velocity:unbox(), var_7_5, var_7_6))
	end
end

function var_0_10.update_statistics(arg_8_0, arg_8_1, arg_8_2)
	for iter_8_0, iter_8_1 in pairs(arg_8_0.all_update_units) do
		GraphHelper.record_statistics("move_velocity", iter_8_1.velocity_current:unbox())
		GraphHelper.record_statistics("move_speed", Vector3.length(iter_8_1.velocity_current:unbox()))
	end
end

function var_0_10.update_rotation(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = Managers.player.is_server
	local var_9_1 = Unit.set_local_rotation
	local var_9_2 = Quaternion.lerp
	local var_9_3 = Quaternion.look
	local var_9_4 = Quaternion.forward
	local var_9_5 = math.smoothstep
	local var_9_6 = Vector3.normalize
	local var_9_7 = Vector3.flat
	local var_9_8 = Vector3.dot

	for iter_9_0, iter_9_1 in pairs(arg_9_0.all_update_units) do
		if not iter_9_1.disable_rotation_update then
			if iter_9_1.rotate_along_direction then
				local var_9_9 = iter_9_1.first_person_extension:current_rotation()
				local var_9_10 = var_9_7(var_9_4(var_9_9))
				local var_9_11 = iter_9_1.velocity_current:unbox()

				var_9_11.z = 0

				local var_9_12 = var_9_8(var_9_11, var_9_10)

				if var_9_12 == 0 then
					local var_9_13 = var_9_6(var_9_10)
					local var_9_14 = iter_9_1.target_rotation:unbox()
					local var_9_15 = var_9_7(var_9_4(var_9_14))
					local var_9_16 = var_9_6(var_9_15)

					if var_9_8(var_9_13, var_9_16) < 0 then
						iter_9_1.target_rotation:store(var_9_9)

						iter_9_1.disable_rotation_update_when_still = false
					end

					var_9_11 = var_9_15
				else
					iter_9_1.target_rotation:store(var_9_9)
				end

				if var_9_12 < -0.1 then
					var_9_11 = -var_9_11
				end

				local var_9_17 = var_9_3(var_9_11)

				Unit.set_local_rotation(iter_9_0, 0, var_9_2(Unit.local_rotation(iter_9_0, 0), var_9_17, arg_9_2 * 5))
			elseif iter_9_1.target_rotation_data then
				local var_9_18 = iter_9_1.target_rotation_data
				local var_9_19 = var_9_18.start_rotation:unbox()
				local var_9_20 = var_9_18.target_rotation:unbox()
				local var_9_21 = var_9_18.start_time
				local var_9_22 = var_9_18.end_time
				local var_9_23 = var_9_5(arg_9_1, var_9_21, var_9_22)

				var_9_1(iter_9_0, 0, var_9_2(var_9_19, var_9_20, var_9_23))
			end
		end

		if var_9_0 then
			local var_9_24 = Unit.world_position(iter_9_0, 0)
			local var_9_25, var_9_26 = GwNavQueries.triangle_from_position(iter_9_1._nav_world, var_9_24, 0.1, 0.3, iter_9_1._nav_traverse_logic)

			if var_9_25 then
				iter_9_1._latest_position_on_navmesh:store(Vector3(var_9_24.x, var_9_24.y, var_9_24.z))
			end
		end

		iter_9_1.disable_rotation_update = false
	end
end

function var_0_10.update_disabled_units(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0.all_disabled_units) do
		iter_10_1.run_func(iter_10_0, arg_10_1, iter_10_1)

		local var_10_0 = Managers.state.network:game()
		local var_10_1 = Managers.state.unit_storage:go_id(iter_10_0)

		if var_10_0 and var_10_1 then
			iter_10_1:sync_network_rotation(var_10_0, var_10_1)
			iter_10_1:sync_network_position(var_10_0, var_10_1)
			iter_10_1:sync_network_velocity(var_10_0, var_10_1, arg_10_1)
		end

		return
	end
end

function var_0_10.update_debug_anims(arg_11_0)
	for iter_11_0, iter_11_1 in pairs(arg_11_0.all_update_units) do
		local var_11_0 = iter_11_1.first_person_extension:get_first_person_unit()

		if script_data.debug_first_person_player_animations and not iter_11_1.debugging_1p_animations then
			iter_11_1.debugging_1p_animations = true

			Unit.set_animation_logging(var_11_0, true)
		elseif iter_11_1.debugging_1p_animations and not script_data.debug_first_person_player_animations then
			iter_11_1.debugging_1p_animations = false

			Unit.set_animation_logging(var_11_0, false)
		end

		if script_data.debug_player_animations and not iter_11_1.debugging_animations then
			iter_11_1.debugging_animations = true

			Unit.set_animation_logging(iter_11_0, true)
		elseif iter_11_1.debugging_animations and not script_data.debug_player_animations then
			iter_11_1.debugging_animations = false

			Unit.set_animation_logging(iter_11_0, false)
		end
	end
end
