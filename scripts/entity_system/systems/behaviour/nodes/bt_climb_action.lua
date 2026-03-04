-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_climb_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function var_0_0(arg_1_0)
	if type(arg_1_0) == "table" then
		return arg_1_0[Math.random(1, #arg_1_0)]
	else
		return arg_1_0
	end
end

BTClimbAction = class(BTClimbAction, BTNode)

function BTClimbAction.init(arg_2_0, ...)
	BTClimbAction.super.init(arg_2_0, ...)
end

BTClimbAction.name = "BTClimbAction"

function BTClimbAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_2.next_smart_object_data
	local var_3_1 = var_3_0.entrance_pos:unbox()
	local var_3_2 = var_3_0.exit_pos:unbox()
	local var_3_3 = var_3_0.smart_object_data
	local var_3_4 = Vector3Aux.unbox(var_3_3.ledge_position)

	arg_3_2.smart_object_data = var_3_3
	arg_3_2.ledge_position = Vector3Box(var_3_4)
	arg_3_2.climb_upwards = true
	arg_3_2.climb_entrance_pos = Vector3Box(var_3_1)
	arg_3_2.climb_exit_pos = Vector3Box(var_3_2)
	arg_3_2.climb_action_in_combat = arg_3_2.in_combat

	local var_3_5 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_5

	if var_3_5 and var_3_5.catapult_players then
		arg_3_2.units_catapulted = {}
	end

	local var_3_6 = ScriptUnit.has_extension(arg_3_1, "ai_shield_system")

	if var_3_6 then
		var_3_6:set_is_blocking(false)
	end

	if not var_3_3.is_on_edge then
		if var_3_3.ledge_position1 then
			local var_3_7 = Vector3Aux.unbox(var_3_3.ledge_position1)
			local var_3_8 = Vector3Aux.unbox(var_3_3.ledge_position2)
			local var_3_9 = Vector3.distance_squared(var_3_7, var_3_1) < Vector3.distance_squared(var_3_8, var_3_1) and var_3_7 or var_3_8

			arg_3_2.climb_jump_height = var_3_9.z - var_3_1.z

			arg_3_2.ledge_position:store(var_3_9)
		else
			arg_3_2.climb_jump_height = var_3_4.z - var_3_1.z

			if arg_3_2.climb_jump_height < 0 then
				var_3_3.is_on_edge = true
			end
		end
	end

	if var_3_3.is_on_edge then
		if var_3_1.z > var_3_2.z then
			arg_3_2.climb_jump_height = var_3_1.z - var_3_2.z
			arg_3_2.climb_upwards = false
		else
			arg_3_2.climb_jump_height = var_3_2.z - var_3_1.z
		end
	end

	fassert(arg_3_2.climb_jump_height >= 0, "Ledge with non-positive climb height=%.2f at %s -> %s", arg_3_2.climb_jump_height, tostring(var_3_1), tostring(var_3_2))

	arg_3_2.climb_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(var_3_2 - var_3_1)))

	local var_3_10 = arg_3_2.locomotion_extension

	var_3_10:set_affected_by_gravity(false)
	var_3_10:set_movement_type("snap_to_navmesh")
	var_3_10:set_rotation_speed(10)

	arg_3_2.climb_state = "moving_to_within_smartobject_range"
end

function BTClimbAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.action = nil
	arg_4_2.climb_spline_ground = nil
	arg_4_2.climb_spline_ledge = nil
	arg_4_2.climb_entrance_pos = nil
	arg_4_2.climb_state = nil
	arg_4_2.climb_upwards = nil
	arg_4_2.is_climbing = nil
	arg_4_2.stagger_prohibited = nil
	arg_4_2.climb_jump_height = nil
	arg_4_2.climb_ledge_lookat_direction = nil
	arg_4_2.climb_entrance_pos = nil
	arg_4_2.climb_exit_pos = nil
	arg_4_2.is_smart_objecting = nil
	arg_4_2.jump_climb_finished = nil
	arg_4_2.climb_align_end_time = nil
	arg_4_2.smart_object_data = nil
	arg_4_2.ledge_position = nil
	arg_4_2.climb_moving_to_enter_entrance_timeout = nil
	arg_4_2.units_catapulted = nil
	arg_4_2.jump_down_land_animation = nil
	arg_4_2.climb_action_in_combat = nil

	if not arg_4_5 then
		LocomotionUtils.set_animation_translation_scale(arg_4_1, Vector3(1, 1, 1))
		LocomotionUtils.constrain_on_clients(arg_4_1, false)
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)

		local var_4_0 = arg_4_2.locomotion_extension

		var_4_0:set_movement_type("snap_to_navmesh")
		var_4_0:set_affected_by_gravity(true)
	end

	local var_4_1 = arg_4_2.navigation_extension

	var_4_1:set_enabled(true)

	ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil

	local var_4_2 = ScriptUnit.has_extension(arg_4_1, "ai_shield_system")

	if var_4_2 then
		var_4_2:set_is_blocking(true)
	end

	if var_4_1:is_using_smart_object() then
		local var_4_3 = var_4_1:use_smart_object(false)
	end
end

local var_0_1 = 2.1
local var_0_2 = 0.125

function BTClimbAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.navigation_extension
	local var_5_1 = arg_5_2.locomotion_extension
	local var_5_2 = POSITION_LOOKUP[arg_5_1]
	local var_5_3 = arg_5_2.smart_object_data.is_on_edge

	if arg_5_2.smart_object_data ~= arg_5_2.next_smart_object_data.smart_object_data then
		return "failed"
	end

	if arg_5_2.climb_action_in_combat ~= arg_5_2.in_combat then
		return "failed"
	end

	if arg_5_2.climb_state == "moving_to_within_smartobject_range" then
		local var_5_4 = Vector3.normalize(var_5_0:desired_velocity())

		if Vector3.length(Vector3.flat(var_5_4)) < 0.05 and Vector3.dot(var_5_4, Vector3.normalize(arg_5_2.climb_exit_pos:unbox() - var_5_2)) > 0.99 then
			arg_5_2.climb_moving_to_enter_entrance_timeout = arg_5_2.climb_moving_to_enter_entrance_timeout or arg_5_3 + 0.3
		else
			arg_5_2.climb_moving_to_enter_entrance_timeout = nil
		end

		if arg_5_2.is_in_smartobject_range or arg_5_2.climb_moving_to_enter_entrance_timeout and arg_5_3 > arg_5_2.climb_moving_to_enter_entrance_timeout then
			var_5_1:set_wanted_velocity(Vector3.zero())
			var_5_1:set_movement_type("script_driven")
			var_5_0:set_enabled(false)

			if var_5_0:use_smart_object(true) then
				arg_5_2.is_smart_objecting = true
				arg_5_2.is_climbing = true
				arg_5_2.stagger_prohibited = true
				arg_5_2.climb_state = "moving_to_to_entrance"
			else
				print("BTClimbAction - failing to use smart object")

				return "failed"
			end
		elseif script_data.ai_debug_smartobject then
			local var_5_5 = Vector3.distance_squared(arg_5_2.climb_entrance_pos:unbox(), var_5_2)

			QuickDrawer:circle(arg_5_2.climb_entrance_pos:unbox(), math.max(var_5_5 - 1, 0.5), Vector3.up())
		end
	end

	if arg_5_2.climb_state == "moving_to_to_entrance" then
		local var_5_6 = arg_5_2.climb_entrance_pos:unbox()
		local var_5_7 = var_5_6 - var_5_2
		local var_5_8 = Vector3.length(var_5_7)
		local var_5_9 = arg_5_2.climb_ledge_lookat_direction:unbox()
		local var_5_10 = Quaternion.look(var_5_9)

		if var_5_8 > 0.1 then
			local var_5_11 = arg_5_2.breed.run_speed

			if var_5_8 < var_5_11 * arg_5_4 then
				var_5_11 = var_5_8 / arg_5_4
			end

			local var_5_12 = Vector3.normalize(var_5_7)

			var_5_1:set_wanted_velocity(var_5_12 * var_5_11)
			var_5_1:set_wanted_rotation(var_5_10)

			if script_data.ai_debug_smartobject then
				QuickDrawer:vector(var_5_2 + Vector3.up() * 0.3, var_5_7)
			end
		else
			var_5_1:teleport_to(var_5_6, var_5_10)

			var_5_2 = var_5_6

			var_5_1:set_wanted_velocity(Vector3.zero())

			local var_5_13 = arg_5_2.climb_exit_pos:unbox()
			local var_5_14 = arg_5_2.ledge_position:unbox() + Vector3.up()

			LocomotionUtils.constrain_on_clients(arg_5_1, true, Vector3.min(var_5_6, var_5_13), Vector3.max(var_5_14, Vector3.max(var_5_6, var_5_13)))
			LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, false)

			ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = true

			local var_5_15 = SmartObjectSettings.templates[arg_5_2.breed.smart_object_template]

			if arg_5_2.climb_upwards or not var_5_3 then
				local var_5_16 = 1 / ScriptUnit.extension(arg_5_1, "ai_system"):size_variation()
				local var_5_17 = var_5_15.jump_up_anim_thresholds
				local var_5_18 = arg_5_2.climb_jump_height

				for iter_5_0 = 1, #var_5_17 do
					local var_5_19 = var_5_17[iter_5_0]

					if var_5_18 < var_5_19.height_threshold then
						local var_5_20 = var_5_3 and var_5_19.animation_edge or var_5_19.animation_fence

						Managers.state.network:anim_event(arg_5_1, var_0_0(var_5_20))

						local var_5_21 = var_5_19.fence_vertical_length or var_5_19.vertical_length
						local var_5_22 = var_5_19.vertical_length
						local var_5_23 = var_5_3 and var_5_22 or var_5_21

						var_5_16 = var_5_16 * var_5_18 / var_5_23

						break
					end
				end

				LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(1, 1, var_5_16))
				var_5_1:set_wanted_velocity(Vector3.zero())

				arg_5_2.climb_state = "waiting_for_finished_climb_anim"
			else
				local var_5_24 = var_5_15.jump_down_anim_thresholds
				local var_5_25 = math.abs(arg_5_2.climb_jump_height)

				for iter_5_1 = 1, #var_5_24 do
					local var_5_26 = var_5_24[iter_5_1]

					if var_5_25 < var_5_26.height_threshold then
						local var_5_27 = var_5_3 and var_5_26.animation_edge or var_5_26.animation_fence

						Managers.state.network:anim_event(arg_5_1, var_0_0(var_5_27))

						local var_5_28 = var_5_26.animation_land or "jump_down_land"

						arg_5_2.jump_down_land_animation = var_0_0(var_5_28)

						break
					end
				end

				arg_5_2.climb_state = "waiting_to_reach_ground"
			end
		end
	end

	if arg_5_2.climb_state == "waiting_for_finished_climb_anim" then
		local var_5_29 = arg_5_2.action
		local var_5_30 = var_5_29 and var_5_29.catapult_players

		if var_5_30 then
			arg_5_0:_catapult_players(arg_5_1, arg_5_2, var_5_30)
		end

		if arg_5_2.jump_climb_finished then
			arg_5_2.jump_climb_finished = nil

			local var_5_31 = arg_5_2.climb_exit_pos:unbox()
			local var_5_32 = var_5_3 and var_5_31 or arg_5_2.ledge_position:unbox()

			if var_5_3 then
				Managers.state.network:anim_event(arg_5_1, "move_fwd")

				arg_5_2.spawn_to_running = true

				var_5_1:teleport_to(var_5_32)

				local var_5_33 = arg_5_2.climb_entrance_pos:unbox()

				if var_5_32.z - var_5_33.z < var_0_1 then
					var_5_0:set_navbot_position(var_5_32 + Vector3.up() * var_0_2)
				else
					var_5_0:set_navbot_position(var_5_32)
				end

				var_5_1:set_wanted_velocity(Vector3.zero())
				LocomotionUtils.set_animation_driven_movement(arg_5_1, false)

				arg_5_2.climb_state = "done"
			else
				local var_5_34 = SmartObjectSettings.templates[arg_5_2.breed.smart_object_template].jump_down_anim_thresholds
				local var_5_35 = var_5_32.z - var_5_31.z

				for iter_5_2 = 1, #var_5_34 do
					local var_5_36 = var_5_34[iter_5_2]

					if var_5_35 < var_5_36.height_threshold then
						local var_5_37 = ScriptUnit.extension(arg_5_1, "ai_system"):size_variation()
						local var_5_38 = var_5_36.fence_horizontal_length
						local var_5_39 = Vector3.length(Vector3.flat(var_5_2 - var_5_31)) - var_5_36.fence_land_length
						local var_5_40 = math.clamp(var_5_39 / (var_5_38 * var_5_37), -10, 10)

						LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(var_5_40, var_5_40, 1))

						local var_5_41 = var_5_36.animation_fence

						Managers.state.network:anim_event(arg_5_1, var_0_0(var_5_41))

						local var_5_42 = var_5_36.animation_land or "jump_down_land"

						arg_5_2.jump_down_land_animation = var_0_0(var_5_42)

						break
					end
				end

				arg_5_2.climb_state = "waiting_to_reach_ground"
			end
		end
	end

	if arg_5_2.climb_state == "waiting_to_reach_ground" then
		local var_5_43 = arg_5_2.action
		local var_5_44 = var_5_43 and var_5_43.catapult_players

		if var_5_44 then
			arg_5_0:_catapult_players(arg_5_1, arg_5_2, var_5_44)
		end

		local var_5_45 = arg_5_2.climb_exit_pos:unbox()
		local var_5_46 = var_5_1:current_velocity()

		if var_5_2.z + var_5_46.z * arg_5_4 * 2 <= var_5_45.z then
			LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, false)
			LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(1, 1, 1))

			local var_5_47 = arg_5_2.jump_down_land_animation

			Managers.state.network:anim_event(arg_5_1, var_5_47)

			ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil
			arg_5_2.climb_state = "waiting_for_finished_land_anim"
		end
	elseif arg_5_2.climb_state == "waiting_for_finished_land_anim" then
		local var_5_48 = arg_5_2.climb_exit_pos:unbox()
		local var_5_49 = Vector3(var_5_2.x, var_5_2.y, var_5_48.z)

		var_5_1:teleport_to(var_5_49)

		if arg_5_2.jump_climb_finished then
			local var_5_50 = arg_5_2.climb_exit_pos:unbox()

			LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
			Managers.state.network:anim_event(arg_5_1, "move_fwd")

			arg_5_2.spawn_to_running = true

			local var_5_51 = Vector3.distance(var_5_2, var_5_50)

			if var_5_51 < 0.01 then
				local var_5_52, var_5_53 = GwNavQueries.triangle_from_position(arg_5_2.nav_world, var_5_50, 0.4, 0.4)

				if var_5_53 then
					var_5_50.z = var_5_53
				end

				local var_5_54 = arg_5_2.climb_entrance_pos:unbox()

				if math.abs(var_5_50.z - var_5_54.z) < var_0_1 then
					var_5_0:set_navbot_position(var_5_50 + Vector3.up() * var_0_2)
				else
					var_5_0:set_navbot_position(var_5_50)
				end

				var_5_1:teleport_to(var_5_50)
				var_5_1:set_wanted_velocity(Vector3.zero())

				arg_5_2.climb_state = "done"
			else
				arg_5_2.climb_align_end_time = arg_5_3 + var_5_51 / arg_5_2.breed.run_speed
				arg_5_2.climb_state = "aligning_to_navmesh"
			end
		end
	end

	if arg_5_2.climb_state == "aligning_to_navmesh" then
		local var_5_55 = arg_5_2.climb_exit_pos:unbox()

		if arg_5_3 > arg_5_2.climb_align_end_time then
			local var_5_56, var_5_57 = GwNavQueries.triangle_from_position(arg_5_2.nav_world, var_5_55, 0.4, 0.4)

			if not var_5_56 then
				local var_5_58, var_5_59 = GwNavQueries.triangle_from_position(arg_5_2.nav_world, var_5_55, 1.5, 1.5)
				local var_5_60 = var_5_59

				if var_5_58 then
					printf("WTF navmesh pos @ move_target %s, actual altitude=%f", tostring(var_5_55), var_5_60)
				end
			end

			var_5_0:set_navbot_position(var_5_55)
			var_5_1:teleport_to(var_5_55)
			var_5_1:set_wanted_velocity(Vector3.zero())

			arg_5_2.climb_state = "done"
		else
			local var_5_61 = arg_5_2.breed.run_speed
			local var_5_62 = Vector3.normalize(var_5_55 - var_5_2) * var_5_61

			var_5_1:set_wanted_velocity(var_5_62)
		end
	end

	if arg_5_2.climb_state == "done" then
		arg_5_2.climb_state = "done_for_reals"
	elseif arg_5_2.climb_state == "done_for_reals" then
		arg_5_2.climb_state = "done_for_reals2"
	elseif arg_5_2.climb_state == "done_for_reals2" then
		return "done"
	end

	return "running"
end

function BTClimbAction._catapult_players(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_3.shape
	local var_6_1 = arg_6_3.radius
	local var_6_2 = Unit.world_position(arg_6_1, 0)
	local var_6_3 = arg_6_2.side
	local var_6_4 = var_6_3.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_6_5 = var_6_3.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_6_0 = 1, #var_6_4 do
		local var_6_6 = var_6_4[iter_6_0]
		local var_6_7 = var_6_5[iter_6_0]
		local var_6_8 = var_6_6 - var_6_2
		local var_6_9 = Vector3.length_squared(var_6_8)

		if not arg_6_2.units_catapulted[var_6_7] and var_6_9 < var_6_1 * var_6_1 then
			local var_6_10 = arg_6_3.speed
			local var_6_11 = arg_6_3.angle
			local var_6_12 = Vector3.normalize(Vector3.flat(var_6_8))
			local var_6_13 = var_6_10 * math.cos(var_6_11)
			local var_6_14

			var_6_14.z, var_6_14 = var_6_10 * math.sin(var_6_11), var_6_12 * var_6_13

			StatusUtils.set_catapulted_network(var_6_7, true, var_6_14)

			arg_6_2.units_catapulted[var_6_7] = var_6_7
		end
	end
end
