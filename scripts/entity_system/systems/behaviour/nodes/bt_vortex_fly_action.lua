-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_vortex_fly_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVortexFlyAction = class(BTVortexFlyAction, BTNode)

BTVortexFlyAction.init = function (arg_1_0, ...)
	-- function 1
	BTVortexFlyAction.super.init(arg_1_0, ...)
end

BTVortexFlyAction.name = "BTVortexFlyAction"

BTVortexFlyAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local next_smart_object_data = arg_2_2.next_smart_object_data
	local unbox = next_smart_object_data.entrance_pos:unbox()
	local unbox_2 = next_smart_object_data.exit_pos:unbox()

	arg_2_2.fly_entrance_pos = Vector3Box(unbox)
	arg_2_2.fly_exit_pos = Vector3Box(unbox_2)

	local smart_object_data = next_smart_object_data.smart_object_data
	local ledge_position = smart_object_data.ledge_position

	ledge_position = not ledge_position and Vector3Aux.unbox(smart_object_data.ledge_position)

	if not ledge_position then
		arg_2_2.fly_middle_pos = Vector3Box(ledge_position)
	end

	arg_2_2.fly_state = "moving_to_within_smartobject_range"
end

BTVortexFlyAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.fly_entrance_pos = nil
	arg_3_2.fly_middle_pos = nil
	arg_3_2.fly_exit_pos = nil
	arg_3_2.fly_state = nil
	arg_3_2.is_smart_objecting = nil
	arg_3_2.is_flying = nil

	if not arg_3_5 then
		arg_3_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	local navigation_extension = arg_3_2.navigation_extension

	navigation_extension:set_enabled(true)

	if not navigation_extension:is_using_smart_object() then
		local use_smart_object = navigation_extension:use_smart_object(false)
	end
end

BTVortexFlyAction._move_to_destination = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local num = arg_4_2 - arg_4_1
	local length = Vector3.length(num)

	if length > 0.1 then
		local var_4_2 = arg_4_5

		if length < var_4_2 * arg_4_4 then
			var_4_2 = length / arg_4_4
		end

		local num_2 = Vector3.normalize(num) * var_4_2

		arg_4_3:set_wanted_velocity(num_2)

		return false
	else
		arg_4_3:teleport_to(arg_4_2)

		return true
	end
end

BTVortexFlyAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local locomotion_extension = arg_5_2.locomotion_extension
	local run_speed = arg_5_2.breed.run_speed
	local var_5_2 = POSITION_LOOKUP[arg_5_1]

	if arg_5_2.fly_state == "moving_to_within_smartobject_range" then
		local unbox = arg_5_2.fly_entrance_pos:unbox()

		if Vector3.distance_squared(unbox, var_5_2) < 1 then
			locomotion_extension:set_wanted_velocity(Vector3.zero())
			locomotion_extension:set_movement_type("script_driven")

			local navigation_extension = arg_5_2.navigation_extension

			navigation_extension:set_enabled(false)

			if not navigation_extension:use_smart_object(true) then
				arg_5_2.is_smart_objecting = true
				arg_5_2.is_flying = true
				arg_5_2.fly_state = "moving_towards_entrance_pos"
			else
				print("BTVortexFlyAction - Failing to use smart object")

				return "failed"
			end
		end
	elseif arg_5_2.fly_state == "moving_towards_entrance_pos" then
		local unbox_2 = arg_5_2.fly_entrance_pos:unbox()

		if not self:_move_to_destination(var_5_2, unbox_2, locomotion_extension, arg_5_4, run_speed) then
			if not arg_5_2.fly_middle_pos then
				arg_5_2.fly_state = "moving_towards_middle_pos"
			else
				arg_5_2.fly_state = "moving_towards_exit_pos"
			end
		end
	elseif arg_5_2.fly_state == "moving_towards_middle_pos" then
		local unbox_3 = arg_5_2.fly_middle_pos:unbox()

		if not self:_move_to_destination(var_5_2, unbox_3, locomotion_extension, arg_5_4, run_speed) then
			arg_5_2.fly_state = "moving_towards_exit_pos"
		end
	elseif arg_5_2.fly_state == "moving_towards_exit_pos" then
		local unbox_4 = arg_5_2.fly_exit_pos:unbox()

		if not self:_move_to_destination(var_5_2, unbox_4, locomotion_extension, arg_5_4, run_speed) then
			arg_5_2.fly_state = "done"
		end
	end

	if arg_5_2.fly_state == "done" then
		return "done"
	else
		return "running"
	end
end
