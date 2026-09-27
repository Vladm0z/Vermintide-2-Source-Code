-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ninja_high_ground_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTNinjaHighGroundAction = class(BTNinjaHighGroundAction, BTClimbAction)

local POSITION_LOOKUP = POSITION_LOOKUP
local ALIVE = ALIVE

BTNinjaHighGroundAction.init = function (arg_1_0, ...)
	-- function 1
	BTNinjaHighGroundAction.super.init(arg_1_0, ...)
end

BTNinjaHighGroundAction.name = "BTNinjaHighGroundAction"

BTNinjaHighGroundAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.high_ground_opportunity = nil

	if not ALIVE[arg_2_2.target_unit] then
		local next_smart_object_data = arg_2_2.next_smart_object_data
		local unbox = next_smart_object_data.entrance_pos:unbox()
		local unbox_2 = next_smart_object_data.exit_pos:unbox()

		if next_smart_object_data.smart_object_type ~= "ledges_with_fence" or not arg_2_2.breed.allow_fence_jumping then
			arg_2_2.fence_jumping = true

			print("fence jumping")
		elseif next_smart_object_data.smart_object_type ~= "ledges" or not (unbox.z > unbox_2.z) or not self:try_jump(arg_2_1, arg_2_2, arg_2_3, unbox) then
			arg_2_2.high_ground_opportunity = true
		end
	end

	if not arg_2_2.high_ground_opportunity then
		BTClimbAction.enter(self, arg_2_1, arg_2_2, arg_2_3)
	end
end

BTNinjaHighGroundAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not arg_3_2.high_ground_opportunity then
		if arg_3_4 == "aborted" then
			arg_3_2.high_ground_opportunity = nil
		end

		if not arg_3_2.fence_jumping then
			local navigation_extension = arg_3_2.navigation_extension
			local locomotion_extension = arg_3_2.locomotion_extension

			navigation_extension:set_enabled(true)

			local unbox = arg_3_2.climb_exit_pos:unbox()

			navigation_extension:set_navbot_position(unbox)

			if not arg_3_5 then
				locomotion_extension:set_wanted_velocity(Vector3.zero())
				locomotion_extension:set_movement_type("script_driven")
				locomotion_extension:teleport_to(arg_3_2.ledge_position:unbox(), Unit.local_rotation(arg_3_1, 0))
			end

			arg_3_2.climb_spline_ground = nil
			arg_3_2.climb_spline_ledge = nil
			arg_3_2.climb_entrance_pos = nil
			arg_3_2.climb_state = nil
			arg_3_2.climb_upwards = nil
			arg_3_2.is_climbing = nil
			arg_3_2.stagger_prohibited = nil
			arg_3_2.climb_jump_height = nil
			arg_3_2.climb_ledge_lookat_direction = nil
			arg_3_2.climb_entrance_pos = nil
			arg_3_2.climb_exit_pos = nil
			arg_3_2.is_smart_objecting = nil
			arg_3_2.jump_climb_finished = nil
			arg_3_2.climb_align_end_time = nil
			arg_3_2.smart_object_data = nil
			arg_3_2.ledge_position = nil

			if not arg_3_5 then
				LocomotionUtils.set_animation_translation_scale(arg_3_1, Vector3(1, 1, 1))
				LocomotionUtils.constrain_on_clients(arg_3_1, false)
			end

			ScriptUnit.extension(arg_3_1, "hit_reaction_system").force_ragdoll_on_death = nil

			if not navigation_extension:is_using_smart_object() then
				local use_smart_object = navigation_extension:use_smart_object(false)
			end
		end
	else
		BTClimbAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	end

	if arg_3_4 == "aborted" then
		arg_3_2.jump_data = nil
	end

	arg_3_2.fence_jumping = false
end

BTNinjaHighGroundAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not arg_4_2.high_ground_opportunity then
		return "running"
	else
		if not arg_4_2.fence_jumping and arg_4_2.climb_state ~= "waiting_for_finished_climb_anim" or not arg_4_2.jump_climb_finished then
			if not self:try_jump(arg_4_1, arg_4_2, arg_4_3, arg_4_2.ledge_position:unbox()) then
				arg_4_2.high_ground_opportunity = true

				return "failed"
			else
				arg_4_2.fence_jumping = false
			end
		end

		return BTClimbAction.run(self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	end
end

BTNinjaHighGroundAction.try_jump = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local target_unit = arg_5_2.target_unit

	if not ALIVE[target_unit] then
		return
	end

	local get_data = World.get_data(arg_5_2.world, "physics_world")
	local num = arg_5_4 + Vector3(0, 0, 1)
	local node = Unit.node(arg_5_2.target_unit, "j_neck")
	local num_2 = Unit.world_position(target_unit, 0) + Vector3(0, 0, 0.2)
	local local_rotation = Unit.local_rotation(arg_5_1, 0)
	local forward = Quaternion.forward(local_rotation)
	local num_3 = num_2 - POSITION_LOOKUP[arg_5_1]

	if not (Vector3.dot(forward, num_3) > 0.3) then
		local tbl = {}
		local var_5_9 = Vector3(0, 0, 0.05)
		local test_trajectory, var_5_11, var_5_12 = BTPrepareForCrazyJumpAction.test_trajectory(arg_5_2, num + Vector3(0, 0, 0, 5), num_2 + var_5_9, tbl, true)

		if not test_trajectory then
			arg_5_2.jump_data = {
				delay_jump_start = true,
				segment_list = tbl,
				jump_target_pos = Vector3Box(num_2),
				jump_velocity_boxed = Vector3Box(var_5_11),
				total_distance = Vector3.distance(num, num_2),
				enemy_spine_node = node
			}
			arg_5_2.skulk_pos = Vector3Box(arg_5_4)

			arg_5_2.navigation_extension:move_to(arg_5_4)

			local network = Managers.state.network

			network:anim_event(arg_5_1, "to_crouch")

			if not arg_5_5 then
				network:anim_event(arg_5_1, "idle")
			end

			local look = Quaternion.look(num_2 - num, Vector3.up())

			arg_5_2.locomotion_extension:set_wanted_rotation(look)

			return true
		else
			print("ready to jump failed")
		end
	else
		print("simple los failed")
	end
end
