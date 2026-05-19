-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_vortex_fly_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVortexFlyAction = class(BTVortexFlyAction, BTNode)

function BTVortexFlyAction.init(arg_1_0, ...)
	BTVortexFlyAction.super.init(arg_1_0, ...)
end

BTVortexFlyAction.name = "BTVortexFlyAction"

function BTVortexFlyAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.next_smart_object_data
	local var_2_1 = var_2_0.entrance_pos:unbox()
	local var_2_2 = var_2_0.exit_pos:unbox()

	arg_2_2.fly_entrance_pos = Vector3Box(var_2_1)
	arg_2_2.fly_exit_pos = Vector3Box(var_2_2)

	local var_2_3 = var_2_0.smart_object_data
	local var_2_4 = var_2_3.ledge_position and Vector3Aux.unbox(var_2_3.ledge_position)

	if var_2_4 then
		arg_2_2.fly_middle_pos = Vector3Box(var_2_4)
	end

	arg_2_2.fly_state = "moving_to_within_smartobject_range"
end

function BTVortexFlyAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.fly_entrance_pos = nil
	arg_3_2.fly_middle_pos = nil
	arg_3_2.fly_exit_pos = nil
	arg_3_2.fly_state = nil
	arg_3_2.is_smart_objecting = nil
	arg_3_2.is_flying = nil

	if not arg_3_5 then
		arg_3_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	local var_3_0 = arg_3_2.navigation_extension

	var_3_0:set_enabled(true)

	if var_3_0:is_using_smart_object() then
		local var_3_1 = var_3_0:use_smart_object(false)
	end
end

function BTVortexFlyAction._move_to_destination(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_2 - arg_4_1
	local var_4_1 = Vector3.length(var_4_0)

	if var_4_1 > 0.1 then
		local var_4_2 = arg_4_5

		if var_4_1 < var_4_2 * arg_4_4 then
			var_4_2 = var_4_1 / arg_4_4
		end

		local var_4_3 = Vector3.normalize(var_4_0) * var_4_2

		arg_4_3:set_wanted_velocity(var_4_3)

		return false
	else
		arg_4_3:teleport_to(arg_4_2)

		return true
	end
end

function BTVortexFlyAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.locomotion_extension
	local var_5_1 = arg_5_2.breed.run_speed
	local var_5_2 = POSITION_LOOKUP[arg_5_1]

	if arg_5_2.fly_state == "moving_to_within_smartobject_range" then
		local var_5_3 = arg_5_2.fly_entrance_pos:unbox()

		if Vector3.distance_squared(var_5_3, var_5_2) < 1 then
			var_5_0:set_wanted_velocity(Vector3.zero())
			var_5_0:set_movement_type("script_driven")

			local var_5_4 = arg_5_2.navigation_extension

			var_5_4:set_enabled(false)

			if var_5_4:use_smart_object(true) then
				arg_5_2.is_smart_objecting = true
				arg_5_2.is_flying = true
				arg_5_2.fly_state = "moving_towards_entrance_pos"
			else
				print("BTVortexFlyAction - Failing to use smart object")

				return "failed"
			end
		end
	elseif arg_5_2.fly_state == "moving_towards_entrance_pos" then
		local var_5_5 = arg_5_2.fly_entrance_pos:unbox()

		if arg_5_0:_move_to_destination(var_5_2, var_5_5, var_5_0, arg_5_4, var_5_1) then
			if arg_5_2.fly_middle_pos then
				arg_5_2.fly_state = "moving_towards_middle_pos"
			else
				arg_5_2.fly_state = "moving_towards_exit_pos"
			end
		end
	elseif arg_5_2.fly_state == "moving_towards_middle_pos" then
		local var_5_6 = arg_5_2.fly_middle_pos:unbox()

		if arg_5_0:_move_to_destination(var_5_2, var_5_6, var_5_0, arg_5_4, var_5_1) then
			arg_5_2.fly_state = "moving_towards_exit_pos"
		end
	elseif arg_5_2.fly_state == "moving_towards_exit_pos" then
		local var_5_7 = arg_5_2.fly_exit_pos:unbox()

		if arg_5_0:_move_to_destination(var_5_2, var_5_7, var_5_0, arg_5_4, var_5_1) then
			arg_5_2.fly_state = "done"
		end
	end

	if arg_5_2.fly_state == "done" then
		return "done"
	else
		return "running"
	end
end
