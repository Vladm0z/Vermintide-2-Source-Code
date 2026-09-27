-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_jump_to_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function fn(self)
	-- function 1
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTJumpToPositionAction = class(BTJumpToPositionAction, BTNode)

BTJumpToPositionAction.init = function (arg_2_0, ...)
	-- function 2
	BTJumpToPositionAction.super.init(arg_2_0, ...)
end

BTJumpToPositionAction.name = "BTJumpToPositionAction"

BTJumpToPositionAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_2.action = self._tree_node.action_data

	Managers.state.debug:drawer({
		mode = "retained",
		name = "BTJumpToPositionAction"
	}):reset()

	local assert = assert
	local jump_from_pos = arg_3_2.jump_from_pos

	jump_from_pos = not jump_from_pos and arg_3_2.exit_pos

	assert(jump_from_pos, "BTJumpToPositionAction needs jump_from_pos and exit_pos defined in blackboard.")

	local unbox = arg_3_2.jump_from_pos:unbox()
	local unbox_2 = arg_3_2.exit_pos:unbox()

	arg_3_2.jump_entrance_pos = Vector3Box(unbox)
	arg_3_2.jump_exit_pos = Vector3Box(unbox_2)
	arg_3_2.jump_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(unbox_2 - unbox)))

	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_rotation_speed(10)

	arg_3_2.jump_state = "moving_to_ledge"
end

BTJumpToPositionAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
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
	-- function 5
	local navigation_extension = arg_5_2.navigation_extension
	local locomotion_extension = arg_5_2.locomotion_extension
	local var_5_2 = POSITION_LOOKUP[arg_5_1]
	local unbox = arg_5_2.jump_entrance_pos:unbox()
	local unbox_2 = arg_5_2.jump_exit_pos:unbox()

	if not (arg_5_2.jump_state ~= "moving_to_ledge" or not (Vector3.distance_squared(unbox, var_5_2) < 1)) then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
		locomotion_extension:set_wanted_velocity(Vector3.zero())
		locomotion_extension:set_movement_type("script_driven")
		navigation_extension:set_enabled(false)

		arg_5_2.is_jumping = true
		arg_5_2.jump_state = "moving_towards_smartobject_entrance"
	end

	if arg_5_2.jump_state == "moving_towards_smartobject_entrance" then
		local var_5_5 = unbox
		local unbox_3 = arg_5_2.jump_ledge_lookat_direction:unbox()
		local look = Quaternion.look(unbox_3)
		local num = var_5_5 - var_5_2
		local length = Vector3.length(num)

		if length > 0.1 then
			local run_speed = arg_5_2.breed.run_speed

			if length < run_speed * arg_5_4 then
				run_speed = length / arg_5_4
			end

			local num_2 = Vector3.normalize(num) * run_speed

			locomotion_extension:set_wanted_velocity(num_2)
			locomotion_extension:set_wanted_rotation(look)
		else
			locomotion_extension:teleport_to(var_5_5, look)
			LocomotionUtils.set_animation_driven_movement(arg_5_1, true)
			Managers.state.network:anim_event(arg_5_1, arg_5_2.action.jump_animation)

			ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = true

			local num_3 = unbox_2 - unbox
			local num_4 = Vector3.length(Vector3.flat(num_3)) / arg_5_2.action.horizontal_length
			local z = num_3.z

			arg_5_2.jump_state = "waiting_to_reach_end"
		end
	end

	if arg_5_2.jump_state ~= "waiting_to_reach_end" or not arg_5_2.jump_start_finished then
		navigation_extension:set_navbot_position(unbox_2)
		locomotion_extension:teleport_to(unbox_2)
		Managers.state.network:anim_event(arg_5_1, arg_5_2.action.land_animation)

		arg_5_2.spawn_to_running = true
		arg_5_2.jump_state = "waiting_for_landing_finished"
	end

	if arg_5_2.jump_state ~= "waiting_for_landing_finished" or not arg_5_2.landing_finished then
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
