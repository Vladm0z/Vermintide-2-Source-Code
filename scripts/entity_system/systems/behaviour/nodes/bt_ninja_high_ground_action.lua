-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ninja_high_ground_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTNinjaHighGroundAction = class(BTNinjaHighGroundAction, BTClimbAction)

local var_0_0 = POSITION_LOOKUP
local var_0_1 = ALIVE

function BTNinjaHighGroundAction.init(arg_1_0, ...)
	BTNinjaHighGroundAction.super.init(arg_1_0, ...)
end

BTNinjaHighGroundAction.name = "BTNinjaHighGroundAction"

function BTNinjaHighGroundAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.high_ground_opportunity = nil

	if var_0_1[arg_2_2.target_unit] then
		local var_2_0 = arg_2_2.next_smart_object_data
		local var_2_1 = var_2_0.entrance_pos:unbox()
		local var_2_2 = var_2_0.exit_pos:unbox()

		if var_2_0.smart_object_type == "ledges_with_fence" and arg_2_2.breed.allow_fence_jumping then
			arg_2_2.fence_jumping = true

			print("fence jumping")
		elseif var_2_0.smart_object_type == "ledges" and var_2_1.z > var_2_2.z and arg_2_0:try_jump(arg_2_1, arg_2_2, arg_2_3, var_2_1) then
			arg_2_2.high_ground_opportunity = true
		end
	end

	if not arg_2_2.high_ground_opportunity then
		BTClimbAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	end
end

function BTNinjaHighGroundAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_2.high_ground_opportunity then
		if arg_3_4 == "aborted" then
			arg_3_2.high_ground_opportunity = nil
		end

		if arg_3_2.fence_jumping then
			local var_3_0 = arg_3_2.navigation_extension
			local var_3_1 = arg_3_2.locomotion_extension

			var_3_0:set_enabled(true)

			local var_3_2 = arg_3_2.climb_exit_pos:unbox()

			var_3_0:set_navbot_position(var_3_2)

			if not arg_3_5 then
				var_3_1:set_wanted_velocity(Vector3.zero())
				var_3_1:set_movement_type("script_driven")
				var_3_1:teleport_to(arg_3_2.ledge_position:unbox(), Unit.local_rotation(arg_3_1, 0))
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

			if var_3_0:is_using_smart_object() then
				local var_3_3 = var_3_0:use_smart_object(false)
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

function BTNinjaHighGroundAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.high_ground_opportunity then
		return "running"
	else
		if arg_4_2.fence_jumping and arg_4_2.climb_state == "waiting_for_finished_climb_anim" and arg_4_2.jump_climb_finished then
			if arg_4_0:try_jump(arg_4_1, arg_4_2, arg_4_3, arg_4_2.ledge_position:unbox()) then
				arg_4_2.high_ground_opportunity = true

				return "failed"
			else
				arg_4_2.fence_jumping = false
			end
		end

		return BTClimbAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	end
end

function BTNinjaHighGroundAction.try_jump(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_2.target_unit

	if not var_0_1[var_5_0] then
		return
	end

	local var_5_1 = World.get_data(arg_5_2.world, "physics_world")
	local var_5_2 = arg_5_4 + Vector3(0, 0, 1)
	local var_5_3 = Unit.node(arg_5_2.target_unit, "j_neck")
	local var_5_4 = Unit.world_position(var_5_0, 0) + Vector3(0, 0, 0.2)
	local var_5_5 = Unit.local_rotation(arg_5_1, 0)
	local var_5_6 = Quaternion.forward(var_5_5)
	local var_5_7 = var_5_4 - POSITION_LOOKUP[arg_5_1]

	if Vector3.dot(var_5_6, var_5_7) > 0.3 then
		local var_5_8 = {}
		local var_5_9 = Vector3(0, 0, 0.05)
		local var_5_10, var_5_11, var_5_12 = BTPrepareForCrazyJumpAction.test_trajectory(arg_5_2, var_5_2 + Vector3(0, 0, 0, 5), var_5_4 + var_5_9, var_5_8, true)

		if var_5_10 then
			arg_5_2.jump_data = {
				delay_jump_start = true,
				segment_list = var_5_8,
				jump_target_pos = Vector3Box(var_5_4),
				jump_velocity_boxed = Vector3Box(var_5_11),
				total_distance = Vector3.distance(var_5_2, var_5_4),
				enemy_spine_node = var_5_3
			}
			arg_5_2.skulk_pos = Vector3Box(arg_5_4)

			arg_5_2.navigation_extension:move_to(arg_5_4)

			local var_5_13 = Managers.state.network

			var_5_13:anim_event(arg_5_1, "to_crouch")

			if arg_5_5 then
				var_5_13:anim_event(arg_5_1, "idle")
			end

			local var_5_14 = Quaternion.look(var_5_4 - var_5_2, Vector3.up())

			arg_5_2.locomotion_extension:set_wanted_rotation(var_5_14)

			return true
		else
			print("ready to jump failed")
		end
	else
		print("simple los failed")
	end
end
