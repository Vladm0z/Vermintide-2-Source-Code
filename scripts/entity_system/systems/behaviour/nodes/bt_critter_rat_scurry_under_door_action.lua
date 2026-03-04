-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_rat_scurry_under_door_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterRatScurryUnderDoorAction = class(BTCritterRatScurryUnderDoorAction, BTNode)

function BTCritterRatScurryUnderDoorAction.init(arg_1_0, ...)
	BTCritterRatScurryUnderDoorAction.super.init(arg_1_0, ...)
end

BTCritterRatScurryUnderDoorAction.name = "BTCritterRatScurryUnderDoorAction"

function BTCritterRatScurryUnderDoorAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	local var_2_0 = arg_2_2.next_smart_object_data
	local var_2_1 = var_2_0.entrance_pos:unbox()
	local var_2_2 = var_2_0.exit_pos:unbox()

	arg_2_2.scurry_under_entrance_pos = Vector3Box(var_2_1)
	arg_2_2.scurry_under_exit_pos = Vector3Box(var_2_2)
	arg_2_2.scurry_under_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(var_2_2 - var_2_1)))

	arg_2_2.locomotion_extension:set_movement_type("snap_to_navmesh")

	if arg_2_2.move_state ~= "moving" then
		Managers.state.network:anim_event(arg_2_1, "move_fwd")

		arg_2_2.move_state = "moving"
	end

	arg_2_2.scurry_state = "moving_to_door"
end

function BTCritterRatScurryUnderDoorAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
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

	local var_3_0 = arg_3_2.navigation_extension

	var_3_0:set_enabled(true)

	if var_3_0:is_using_smart_object() and not var_3_0:use_smart_object(false) and not arg_3_2.exit_last_action then
		print("Could not release smart object, since nav mesh was not found. Killing AI", arg_3_1)

		local var_3_1 = "forced"
		local var_3_2 = Vector3(0, 0, -1)

		AiUtils.kill_unit(arg_3_1, nil, nil, var_3_1, var_3_2)
	end
end

function BTCritterRatScurryUnderDoorAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = POSITION_LOOKUP[arg_4_1]
	local var_4_1 = arg_4_2.locomotion_extension
	local var_4_2 = arg_4_2.navigation_extension

	if arg_4_2.next_smart_object_data.next_smart_object_id == nil then
		aiprint("Critter rat lost smart object during door action")

		return "failed"
	end

	if arg_4_2.scurry_state == "moving_to_door" and not arg_4_0:_moving_to_door_update(arg_4_1, arg_4_2) then
		return "failed"
	end

	if arg_4_2.scurry_state == "moving_towards_smartobject_entrance" then
		arg_4_0:_move_towards_smartobject_entrance_update(arg_4_1, arg_4_2, arg_4_4)
	end

	if arg_4_2.scurry_state == "waiting_to_reach_end" then
		arg_4_0:_waiting_to_reach_end_update(arg_4_1, arg_4_2)
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

function BTCritterRatScurryUnderDoorAction._moving_to_door_update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local var_5_1 = arg_5_2.scurry_under_entrance_pos:unbox()

	if Vector3.distance(var_5_1, var_5_0) < 1 then
		local var_5_2 = arg_5_2.locomotion_extension

		var_5_2:set_wanted_velocity(Vector3.zero())
		var_5_2:set_movement_type("script_driven")

		local var_5_3 = arg_5_2.navigation_extension

		var_5_3:set_enabled(false)

		if var_5_3:use_smart_object(true) then
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

function BTCritterRatScurryUnderDoorAction._move_towards_smartobject_entrance_update(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = POSITION_LOOKUP[arg_6_1]
	local var_6_1 = arg_6_2.scurry_under_entrance_pos:unbox()
	local var_6_2 = arg_6_2.scurry_under_lookat_direction:unbox()
	local var_6_3 = Quaternion.look(var_6_2)
	local var_6_4 = var_6_1 - var_6_0
	local var_6_5 = Vector3.length(var_6_4)
	local var_6_6 = arg_6_2.locomotion_extension

	if var_6_5 > 0.1 then
		local var_6_7 = arg_6_2.breed.run_speed

		if var_6_5 < var_6_7 * arg_6_3 then
			var_6_7 = arg_6_3 == 0 and 0 or var_6_5 / arg_6_3
		end

		local var_6_8 = Vector3.normalize(var_6_4)

		var_6_6:set_wanted_velocity(var_6_8 * var_6_7)
		var_6_6:set_wanted_rotation(var_6_3)
	else
		LocomotionUtils.set_animation_driven_movement(arg_6_1, true, false, false)
		var_6_6:teleport_to(var_6_1, var_6_3)
		Managers.state.network:anim_event(arg_6_1, "dig_door")

		arg_6_2.scurry_state = "waiting_to_reach_end"
	end
end

function BTCritterRatScurryUnderDoorAction._waiting_to_reach_end_update(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2.anim_cb_scurry_under_finished then
		local var_7_0 = arg_7_2.scurry_under_exit_pos:unbox()

		arg_7_2.navigation_extension:set_navbot_position(var_7_0)
		arg_7_2.locomotion_extension:teleport_to(var_7_0)
		Managers.state.network:anim_event(arg_7_1, "move_fwd")

		arg_7_2.spawn_to_running = true
		arg_7_2.scurry_state = "done"
	end
end
