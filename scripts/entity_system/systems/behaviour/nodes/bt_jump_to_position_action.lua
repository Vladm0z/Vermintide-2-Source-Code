-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_jump_to_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function var_0_0(arg_1_0)
	if type(arg_1_0) == "table" then
		return arg_1_0[Math.random(1, #arg_1_0)]
	else
		return arg_1_0
	end
end

BTJumpToPositionAction = class(BTJumpToPositionAction, BTNode)

BTJumpToPositionAction.init = function (arg_2_0, ...)
	BTJumpToPositionAction.super.init(arg_2_0, ...)
end

BTJumpToPositionAction.name = "BTJumpToPositionAction"

BTJumpToPositionAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_2.action = arg_3_0._tree_node.action_data

	Managers.state.debug:drawer({
		mode = "retained",
		name = "BTJumpToPositionAction"
	}):reset()
	assert(arg_3_2.jump_from_pos and arg_3_2.exit_pos, "BTJumpToPositionAction needs jump_from_pos and exit_pos defined in blackboard.")

	local var_3_0 = arg_3_2.jump_from_pos:unbox()
	local var_3_1 = arg_3_2.exit_pos:unbox()

	arg_3_2.jump_entrance_pos = Vector3Box(var_3_0)
	arg_3_2.jump_exit_pos = Vector3Box(var_3_1)
	arg_3_2.jump_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(var_3_1 - var_3_0)))

	local var_3_2 = arg_3_2.locomotion_extension

	var_3_2:set_affected_by_gravity(false)
	var_3_2:set_movement_type("snap_to_navmesh")
	var_3_2:set_rotation_speed(10)

	arg_3_2.jump_state = "moving_to_ledge"
end

BTJumpToPositionAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.jump_spline_ground = nil
	arg_4_2.jump_spline_ledge = nil
	arg_4_2.jump_entrance_pos = nil
	arg_4_2.jump_state = nil
	arg_4_2.is_jumping = nil
	arg_4_2.jump_ledge_lookat_direction = nil
	arg_4_2.jump_entrance_pos = nil
	arg_4_2.jump_exit_pos = nil
	arg_4_2.is_smart_objecting = nil
	arg_4_2.jump_start_finished = nil
	arg_4_2.jump_from_pos = nil
	arg_4_2.exit_pos = nil

	if not arg_4_5 then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false, true)
		LocomotionUtils.set_animation_translation_scale(arg_4_1, Vector3(1, 1, 1))
		arg_4_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	arg_4_2.navigation_extension:set_enabled(true)

	ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

BTJumpToPositionAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.navigation_extension
	local var_5_1 = arg_5_2.locomotion_extension
	local var_5_2 = POSITION_LOOKUP[arg_5_1]
	local var_5_3 = arg_5_2.jump_entrance_pos:unbox()
	local var_5_4 = arg_5_2.jump_exit_pos:unbox()

	if arg_5_2.jump_state == "moving_to_ledge" and Vector3.distance_squared(var_5_3, var_5_2) < 1 then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
		var_5_1:set_wanted_velocity(Vector3.zero())
		var_5_1:set_movement_type("script_driven")
		var_5_0:set_enabled(false)

		arg_5_2.is_jumping = true
		arg_5_2.jump_state = "moving_towards_smartobject_entrance"
	end

	if arg_5_2.jump_state == "moving_towards_smartobject_entrance" then
		local var_5_5 = var_5_3
		local var_5_6 = arg_5_2.jump_ledge_lookat_direction:unbox()
		local var_5_7 = Quaternion.look(var_5_6)
		local var_5_8 = var_5_5 - var_5_2
		local var_5_9 = Vector3.length(var_5_8)

		if var_5_9 > 0.1 then
			local var_5_10 = arg_5_2.breed.run_speed

			if var_5_9 < var_5_10 * arg_5_4 then
				var_5_10 = var_5_9 / arg_5_4
			end

			local var_5_11 = Vector3.normalize(var_5_8) * var_5_10

			var_5_1:set_wanted_velocity(var_5_11)
			var_5_1:set_wanted_rotation(var_5_7)
		else
			var_5_1:teleport_to(var_5_5, var_5_7)
			LocomotionUtils.set_animation_driven_movement(arg_5_1, true)
			Managers.state.network:anim_event(arg_5_1, arg_5_2.action.jump_animation)

			ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = true

			local var_5_12 = var_5_4 - var_5_3
			local var_5_13 = Vector3.length(Vector3.flat(var_5_12)) / arg_5_2.action.horizontal_length
			local var_5_14 = var_5_12.z

			arg_5_2.jump_state = "waiting_to_reach_end"
		end
	end

	if arg_5_2.jump_state == "waiting_to_reach_end" and arg_5_2.jump_start_finished then
		var_5_0:set_navbot_position(var_5_4)
		var_5_1:teleport_to(var_5_4)
		Managers.state.network:anim_event(arg_5_1, arg_5_2.action.land_animation)

		arg_5_2.spawn_to_running = true
		arg_5_2.jump_state = "waiting_for_landing_finished"
	end

	if arg_5_2.jump_state == "waiting_for_landing_finished" and arg_5_2.landing_finished then
		arg_5_2.jump_state = "done"
	end

	if arg_5_2.jump_state == "done" then
		arg_5_2.jump_state = "done_for_reals"
	elseif arg_5_2.jump_state == "done_for_reals" then
		arg_5_2.jump_state = "done_for_reals2"
	elseif arg_5_2.jump_state == "done_for_reals2" then
		return "done"
	end

	return "running"
end
