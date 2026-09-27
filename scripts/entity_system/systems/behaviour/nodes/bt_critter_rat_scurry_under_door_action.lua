-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_rat_scurry_under_door_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterRatScurryUnderDoorAction = class(BTCritterRatScurryUnderDoorAction, BTNode)

BTCritterRatScurryUnderDoorAction.init = function (arg_1_0, ...)
	-- function 1
	BTCritterRatScurryUnderDoorAction.super.init(arg_1_0, ...)
end

BTCritterRatScurryUnderDoorAction.name = "BTCritterRatScurryUnderDoorAction"

BTCritterRatScurryUnderDoorAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	local next_smart_object_data = arg_2_2.next_smart_object_data
	local unbox = next_smart_object_data.entrance_pos:unbox()
	local unbox_2 = next_smart_object_data.exit_pos:unbox()

	arg_2_2.scurry_under_entrance_pos = Vector3Box(unbox)
	arg_2_2.scurry_under_exit_pos = Vector3Box(unbox_2)
	arg_2_2.scurry_under_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(unbox_2 - unbox)))

	arg_2_2.locomotion_extension:set_movement_type("snap_to_navmesh")

	if arg_2_2.move_state ~= "moving" then
		Managers.state.network:anim_event(arg_2_1, "move_fwd")

		arg_2_2.move_state = "moving"
	end

	arg_2_2.scurry_state = "moving_to_door"
end

BTCritterRatScurryUnderDoorAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.scurry_under_entrance_pos = nil
	arg_3_2.scurry_under_exit_pos = nil
	arg_3_2.scurry_state = nil
	arg_3_2.scurry_under_lookat_direction = nil
	arg_3_2.is_scurrying_under_door = nil
	arg_3_2.anim_cb_scurry_under_finished = nil
	arg_3_2.is_smart_objecting = nil

	if not arg_3_5 then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
		arg_3_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	local navigation_extension = arg_3_2.navigation_extension

	navigation_extension:set_enabled(true)

	if not (not navigation_extension:is_using_smart_object() and navigation_extension:use_smart_object(false) or arg_3_2.exit_last_action) then
		print("Could not release smart object, since nav mesh was not found. Killing AI", arg_3_1)

		local str = "forced"
		local var_3_2 = Vector3(0, 0, -1)

		AiUtils.kill_unit(arg_3_1, nil, nil, str, var_3_2)
	end
end

BTCritterRatScurryUnderDoorAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local var_4_0 = POSITION_LOOKUP[arg_4_1]
	local locomotion_extension = arg_4_2.locomotion_extension
	local navigation_extension = arg_4_2.navigation_extension

	if arg_4_2.next_smart_object_data.next_smart_object_id == nil then
		aiprint("Critter rat lost smart object during door action")

		return "failed"
	end

	if not (arg_4_2.scurry_state ~= "moving_to_door" or self:_moving_to_door_update(arg_4_1, arg_4_2)) then
		return "failed"
	end

	if arg_4_2.scurry_state == "moving_towards_smartobject_entrance" then
		self:_move_towards_smartobject_entrance_update(arg_4_1, arg_4_2, arg_4_4)
	end

	if arg_4_2.scurry_state == "waiting_to_reach_end" then
		self:_waiting_to_reach_end_update(arg_4_1, arg_4_2)
	end

	if arg_4_2.scurry_state == "done" then
		arg_4_2.scurry_state = "done_for_reals"
	elseif arg_4_2.scurry_state == "done_for_reals" then
		arg_4_2.scurry_state = "done_for_reals2"
	elseif arg_4_2.scurry_state == "done_for_reals2" then
		return "done"
	end

	return "running"
end

BTCritterRatScurryUnderDoorAction._moving_to_door_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local unbox = arg_5_2.scurry_under_entrance_pos:unbox()

	if Vector3.distance(unbox, var_5_0) < 1 then
		local locomotion_extension = arg_5_2.locomotion_extension

		locomotion_extension:set_wanted_velocity(Vector3.zero())
		locomotion_extension:set_movement_type("script_driven")

		local navigation_extension = arg_5_2.navigation_extension

		navigation_extension:set_enabled(false)

		if not navigation_extension:use_smart_object(true) then
			arg_5_2.is_smart_objecting = true
			arg_5_2.is_scurrying_under_door = true
			arg_5_2.scurry_state = "moving_towards_smartobject_entrance"
		else
			print("BTCritterRatScurryUnderDoorAction - failing to use smart object")

			return false
		end
	end

	return true
end

BTCritterRatScurryUnderDoorAction._move_towards_smartobject_entrance_update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = POSITION_LOOKUP[arg_6_1]
	local unbox = arg_6_2.scurry_under_entrance_pos:unbox()
	local unbox_2 = arg_6_2.scurry_under_lookat_direction:unbox()
	local look = Quaternion.look(unbox_2)
	local num = unbox - var_6_0
	local length = Vector3.length(num)
	local locomotion_extension = arg_6_2.locomotion_extension

	if length > 0.1 then
		local run_speed = arg_6_2.breed.run_speed

		if length < run_speed * arg_6_3 then
			run_speed = arg_6_3 ~= 0 or not 0 or length / arg_6_3
		end

		local normalize = Vector3.normalize(num)

		locomotion_extension:set_wanted_velocity(normalize * run_speed)
		locomotion_extension:set_wanted_rotation(look)
	else
		LocomotionUtils.set_animation_driven_movement(arg_6_1, true, false, false)
		locomotion_extension:teleport_to(unbox, look)
		Managers.state.network:anim_event(arg_6_1, "dig_door")

		arg_6_2.scurry_state = "waiting_to_reach_end"
	end
end

BTCritterRatScurryUnderDoorAction._waiting_to_reach_end_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	if not arg_7_2.anim_cb_scurry_under_finished then
		local unbox = arg_7_2.scurry_under_exit_pos:unbox()

		arg_7_2.navigation_extension:set_navbot_position(unbox)
		arg_7_2.locomotion_extension:teleport_to(unbox)
		Managers.state.network:anim_event(arg_7_1, "move_fwd")

		arg_7_2.spawn_to_running = true
		arg_7_2.scurry_state = "done"
	end
end
