-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_climb_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function fn(self)
	-- function 1
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTClimbAction = class(BTClimbAction, BTNode)

BTClimbAction.init = function (arg_2_0, ...)
	-- function 2
	BTClimbAction.super.init(arg_2_0, ...)
end

BTClimbAction.name = "BTClimbAction"

BTClimbAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local next_smart_object_data = arg_3_2.next_smart_object_data
	local unbox = next_smart_object_data.entrance_pos:unbox()
	local unbox_2 = next_smart_object_data.exit_pos:unbox()
	local smart_object_data = next_smart_object_data.smart_object_data
	local unbox_3 = Vector3Aux.unbox(smart_object_data.ledge_position)

	arg_3_2.smart_object_data = smart_object_data
	arg_3_2.ledge_position = Vector3Box(unbox_3)
	arg_3_2.climb_upwards = true
	arg_3_2.climb_entrance_pos = Vector3Box(unbox)
	arg_3_2.climb_exit_pos = Vector3Box(unbox_2)
	arg_3_2.climb_action_in_combat = arg_3_2.in_combat

	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data

	if not action_data and not action_data.catapult_players then
		arg_3_2.units_catapulted = {}
	end

	local has_extension = ScriptUnit.has_extension(arg_3_1, "ai_shield_system")

	if not has_extension then
		has_extension:set_is_blocking(false)
	end

	if not smart_object_data.is_on_edge then
		if not smart_object_data.ledge_position1 then
			local unbox_4 = Vector3Aux.unbox(smart_object_data.ledge_position1)
			local unbox_5 = Vector3Aux.unbox(smart_object_data.ledge_position2)
			local flag = not (Vector3.distance_squared(unbox_4, unbox) < Vector3.distance_squared(unbox_5, unbox)) or not unbox_4 or unbox_5

			arg_3_2.climb_jump_height = flag.z - unbox.z

			arg_3_2.ledge_position:store(flag)
		else
			arg_3_2.climb_jump_height = unbox_3.z - unbox.z

			if arg_3_2.climb_jump_height < 0 then
				smart_object_data.is_on_edge = true
			end
		end
	end

	if not smart_object_data.is_on_edge then
		if unbox.z > unbox_2.z then
			arg_3_2.climb_jump_height = unbox.z - unbox_2.z
			arg_3_2.climb_upwards = false
		else
			arg_3_2.climb_jump_height = unbox_2.z - unbox.z
		end
	end

	fassert(arg_3_2.climb_jump_height >= 0, "Ledge with non-positive climb height=%.2f at %s -> %s", arg_3_2.climb_jump_height, tostring(unbox), tostring(unbox_2))

	arg_3_2.climb_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(unbox_2 - unbox)))

	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_rotation_speed(10)

	arg_3_2.climb_state = "moving_to_within_smartobject_range"
end

BTClimbAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
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

		local locomotion_extension = arg_4_2.locomotion_extension

		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:set_affected_by_gravity(true)
	end

	local navigation_extension = arg_4_2.navigation_extension

	navigation_extension:set_enabled(true)

	ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil

	local has_extension = ScriptUnit.has_extension(arg_4_1, "ai_shield_system")

	if not has_extension then
		has_extension:set_is_blocking(true)
	end

	if not navigation_extension:is_using_smart_object() then
		local use_smart_object = navigation_extension:use_smart_object(false)
	end
end

local num = 2.1
local num_2 = 0.125

BTClimbAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local navigation_extension = arg_5_2.navigation_extension
	local locomotion_extension = arg_5_2.locomotion_extension
	local var_5_2 = POSITION_LOOKUP[arg_5_1]
	local is_on_edge = arg_5_2.smart_object_data.is_on_edge

	if arg_5_2.smart_object_data ~= arg_5_2.next_smart_object_data.smart_object_data then
		return "failed"
	end

	if arg_5_2.climb_action_in_combat ~= arg_5_2.in_combat then
		return "failed"
	end

	if arg_5_2.climb_state == "moving_to_within_smartobject_range" then
		local normalize = Vector3.normalize(navigation_extension:desired_velocity())

		if not (not (Vector3.length(Vector3.flat(normalize)) < 0.05) or not (Vector3.dot(normalize, Vector3.normalize(arg_5_2.climb_exit_pos:unbox() - var_5_2)) > 0.99)) then
			local climb_moving_to_enter_entrance_timeout = arg_5_2.climb_moving_to_enter_entrance_timeout

			climb_moving_to_enter_entrance_timeout = climb_moving_to_enter_entrance_timeout or arg_5_3 + 0.3
			arg_5_2.climb_moving_to_enter_entrance_timeout = climb_moving_to_enter_entrance_timeout
		else
			arg_5_2.climb_moving_to_enter_entrance_timeout = nil
		end

		if not ((arg_5_2.is_in_smartobject_range or not arg_5_2.climb_moving_to_enter_entrance_timeout) and not (arg_5_3 > arg_5_2.climb_moving_to_enter_entrance_timeout)) then
			locomotion_extension:set_wanted_velocity(Vector3.zero())
			locomotion_extension:set_movement_type("script_driven")
			navigation_extension:set_enabled(false)

			if not navigation_extension:use_smart_object(true) then
				arg_5_2.is_smart_objecting = true
				arg_5_2.is_climbing = true
				arg_5_2.stagger_prohibited = true
				arg_5_2.climb_state = "moving_to_to_entrance"
			else
				print("BTClimbAction - failing to use smart object")

				return "failed"
			end
		elseif not script_data.ai_debug_smartobject then
			local distance_squared = Vector3.distance_squared(arg_5_2.climb_entrance_pos:unbox(), var_5_2)

			QuickDrawer:circle(arg_5_2.climb_entrance_pos:unbox(), math.max(distance_squared - 1, 0.5), Vector3.up())
		end
	end

	if arg_5_2.climb_state == "moving_to_to_entrance" then
		local unbox = arg_5_2.climb_entrance_pos:unbox()
		local num_3 = unbox - var_5_2
		local length = Vector3.length(num_3)
		local unbox_2 = arg_5_2.climb_ledge_lookat_direction:unbox()
		local look = Quaternion.look(unbox_2)

		if length > 0.1 then
			local run_speed = arg_5_2.breed.run_speed

			if length < run_speed * arg_5_4 then
				run_speed = length / arg_5_4
			end

			local normalize_2 = Vector3.normalize(num_3)

			locomotion_extension:set_wanted_velocity(normalize_2 * run_speed)
			locomotion_extension:set_wanted_rotation(look)

			if not script_data.ai_debug_smartobject then
				QuickDrawer:vector(var_5_2 + Vector3.up() * 0.3, num_3)
			end
		else
			locomotion_extension:teleport_to(unbox, look)

			var_5_2 = unbox

			locomotion_extension:set_wanted_velocity(Vector3.zero())

			local unbox_3 = arg_5_2.climb_exit_pos:unbox()
			local num_4 = arg_5_2.ledge_position:unbox() + Vector3.up()

			LocomotionUtils.constrain_on_clients(arg_5_1, true, Vector3.min(unbox, unbox_3), Vector3.max(num_4, Vector3.max(unbox, unbox_3)))
			LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, false)

			ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = true

			local var_5_16 = SmartObjectSettings.templates[arg_5_2.breed.smart_object_template]

			if not (arg_5_2.climb_upwards or is_on_edge) then
				local num_5 = 1 / ScriptUnit.extension(arg_5_1, "ai_system"):size_variation()
				local jump_up_anim_thresholds = var_5_16.jump_up_anim_thresholds
				local climb_jump_height = arg_5_2.climb_jump_height

				for i = 1, #jump_up_anim_thresholds do
					local var_5_20 = jump_up_anim_thresholds[i]

					if climb_jump_height < var_5_20.height_threshold then
						local animation_edge

						if not is_on_edge then
							animation_edge = var_5_20.animation_edge

							if not animation_edge then
								-- Nothing
							end
						end

						animation_edge = var_5_20.animation_fence

						::label_5_0::

						Managers.state.network:anim_event(arg_5_1, fn(animation_edge))

						local fence_vertical_length = var_5_20.fence_vertical_length

						fence_vertical_length = fence_vertical_length or var_5_20.vertical_length

						local vertical_length = var_5_20.vertical_length
						local flag = not is_on_edge and vertical_length and fence_vertical_length

						num_5 = num_5 * climb_jump_height / flag

						break
					end
				end

				LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(1, 1, num_5))
				locomotion_extension:set_wanted_velocity(Vector3.zero())

				arg_5_2.climb_state = "waiting_for_finished_climb_anim"
			else
				local jump_down_anim_thresholds = var_5_16.jump_down_anim_thresholds
				local abs = math.abs(arg_5_2.climb_jump_height)

				for j = 1, #jump_down_anim_thresholds do
					local var_5_27 = jump_down_anim_thresholds[j]

					if abs < var_5_27.height_threshold then
						local animation_edge_2

						if not is_on_edge then
							animation_edge_2 = var_5_27.animation_edge

							if not animation_edge_2 then
								-- Nothing
							end
						end

						animation_edge_2 = var_5_27.animation_fence

						::label_5_1::

						Managers.state.network:anim_event(arg_5_1, fn(animation_edge_2))

						local animation_land = var_5_27.animation_land

						animation_land = animation_land or "jump_down_land"
						arg_5_2.jump_down_land_animation = fn(animation_land)

						break
					end
				end

				arg_5_2.climb_state = "waiting_to_reach_ground"
			end
		end
	end

	if arg_5_2.climb_state == "waiting_for_finished_climb_anim" then
		local action = arg_5_2.action
		local flag_2 = not action and action.catapult_players

		if not flag_2 then
			self:_catapult_players(arg_5_1, arg_5_2, flag_2)
		end

		if not arg_5_2.jump_climb_finished then
			arg_5_2.jump_climb_finished = nil

			local unbox_4 = arg_5_2.climb_exit_pos:unbox()
			local flag_3 = not is_on_edge and unbox_4 and arg_5_2.ledge_position:unbox()

			if not is_on_edge then
				Managers.state.network:anim_event(arg_5_1, "move_fwd")

				arg_5_2.spawn_to_running = true

				locomotion_extension:teleport_to(flag_3)

				local unbox_5 = arg_5_2.climb_entrance_pos:unbox()

				if flag_3.z - unbox_5.z < num then
					navigation_extension:set_navbot_position(flag_3 + Vector3.up() * num_2)
				else
					navigation_extension:set_navbot_position(flag_3)
				end

				locomotion_extension:set_wanted_velocity(Vector3.zero())
				LocomotionUtils.set_animation_driven_movement(arg_5_1, false)

				arg_5_2.climb_state = "done"
			else
				local jump_down_anim_thresholds_2 = SmartObjectSettings.templates[arg_5_2.breed.smart_object_template].jump_down_anim_thresholds
				local num_6 = flag_3.z - unbox_4.z

				for k = 1, #jump_down_anim_thresholds_2 do
					local var_5_37 = jump_down_anim_thresholds_2[k]

					if num_6 < var_5_37.height_threshold then
						local size_variation = ScriptUnit.extension(arg_5_1, "ai_system"):size_variation()
						local fence_horizontal_length = var_5_37.fence_horizontal_length
						local num_7 = Vector3.length(Vector3.flat(var_5_2 - unbox_4)) - var_5_37.fence_land_length
						local clamp = math.clamp(num_7 / (fence_horizontal_length * size_variation), -10, 10)

						LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(clamp, clamp, 1))

						local animation_fence = var_5_37.animation_fence

						Managers.state.network:anim_event(arg_5_1, fn(animation_fence))

						local animation_land_2 = var_5_37.animation_land

						animation_land_2 = animation_land_2 or "jump_down_land"
						arg_5_2.jump_down_land_animation = fn(animation_land_2)

						break
					end
				end

				arg_5_2.climb_state = "waiting_to_reach_ground"
			end
		end
	end

	if arg_5_2.climb_state == "waiting_to_reach_ground" then
		local action_2 = arg_5_2.action
		local flag_4 = not action_2 and action_2.catapult_players

		if not flag_4 then
			self:_catapult_players(arg_5_1, arg_5_2, flag_4)
		end

		local unbox_6 = arg_5_2.climb_exit_pos:unbox()
		local current_velocity = locomotion_extension:current_velocity()

		if var_5_2.z + current_velocity.z * arg_5_4 * 2 <= unbox_6.z then
			LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, false)
			LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(1, 1, 1))

			local jump_down_land_animation = arg_5_2.jump_down_land_animation

			Managers.state.network:anim_event(arg_5_1, jump_down_land_animation)

			ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil
			arg_5_2.climb_state = "waiting_for_finished_land_anim"
		end
	elseif arg_5_2.climb_state == "waiting_for_finished_land_anim" then
		local unbox_7 = arg_5_2.climb_exit_pos:unbox()
		local var_5_50 = Vector3(var_5_2.x, var_5_2.y, unbox_7.z)

		locomotion_extension:teleport_to(var_5_50)

		if not arg_5_2.jump_climb_finished then
			local unbox_8 = arg_5_2.climb_exit_pos:unbox()

			LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
			Managers.state.network:anim_event(arg_5_1, "move_fwd")

			arg_5_2.spawn_to_running = true

			local distance = Vector3.distance(var_5_2, unbox_8)

			if distance < 0.01 then
				local triangle_from_position, var_5_54 = GwNavQueries.triangle_from_position(arg_5_2.nav_world, unbox_8, 0.4, 0.4)

				if not var_5_54 then
					unbox_8.z = var_5_54
				end

				local unbox_9 = arg_5_2.climb_entrance_pos:unbox()

				if math.abs(unbox_8.z - unbox_9.z) < num then
					navigation_extension:set_navbot_position(unbox_8 + Vector3.up() * num_2)
				else
					navigation_extension:set_navbot_position(unbox_8)
				end

				locomotion_extension:teleport_to(unbox_8)
				locomotion_extension:set_wanted_velocity(Vector3.zero())

				arg_5_2.climb_state = "done"
			else
				arg_5_2.climb_align_end_time = arg_5_3 + distance / arg_5_2.breed.run_speed
				arg_5_2.climb_state = "aligning_to_navmesh"
			end
		end
	end

	if arg_5_2.climb_state == "aligning_to_navmesh" then
		local unbox_10 = arg_5_2.climb_exit_pos:unbox()

		if arg_5_3 > arg_5_2.climb_align_end_time then
			local triangle_from_position_2, var_5_58 = GwNavQueries.triangle_from_position(arg_5_2.nav_world, unbox_10, 0.4, 0.4)

			if not triangle_from_position_2 then
				local triangle_from_position_3, var_5_60 = GwNavQueries.triangle_from_position(arg_5_2.nav_world, unbox_10, 1.5, 1.5)
				local var_5_61 = var_5_60

				if not triangle_from_position_3 then
					printf("WTF navmesh pos @ move_target %s, actual altitude=%f", tostring(unbox_10), var_5_61)
				end
			end

			navigation_extension:set_navbot_position(unbox_10)
			locomotion_extension:teleport_to(unbox_10)
			locomotion_extension:set_wanted_velocity(Vector3.zero())

			arg_5_2.climb_state = "done"
		else
			local run_speed_2 = arg_5_2.breed.run_speed
			local num_8 = Vector3.normalize(unbox_10 - var_5_2) * run_speed_2

			locomotion_extension:set_wanted_velocity(num_8)
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

BTClimbAction._catapult_players = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local shape = arg_6_3.shape
	local radius = arg_6_3.radius
	local world_position = Unit.world_position(arg_6_1, 0)
	local side = arg_6_2.side
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		local var_6_6 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
		local var_6_7 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local num = var_6_6 - world_position
		local length_squared = Vector3.length_squared(num)

		if not (arg_6_2.units_catapulted[var_6_7] or not (length_squared < radius * radius)) then
			local speed = arg_6_3.speed
			local angle = arg_6_3.angle
			local normalize = Vector3.normalize(Vector3.flat(num))
			local num_2 = speed * math.cos(angle)
			local num_3

			num_3.z, num_3 = speed * math.sin(angle), normalize * num_2

			StatusUtils.set_catapulted_network(var_6_7, true, num_3)

			arg_6_2.units_catapulted[var_6_7] = var_6_7
		end
	end
end
