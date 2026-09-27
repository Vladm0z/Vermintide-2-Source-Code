-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_loot_rat_dodge_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTLootRatDodgeAction = class(BTLootRatDodgeAction, BTNode)

BTLootRatDodgeAction.init = function (arg_1_0, ...)
	-- function 1
	BTLootRatDodgeAction.super.init(arg_1_0, ...)
end

BTLootRatDodgeAction.name = "BTLootRatDodgeAction"

local POSITION_LOOKUP = POSITION_LOOKUP
local script_data = script_data

BTLootRatDodgeAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	local unbox = arg_2_2.dodge_vector:unbox()
	local unbox_2 = arg_2_2.threat_vector:unbox()
	local dodge, var_2_4, var_2_5 = self:dodge(arg_2_1, arg_2_2, unbox, unbox_2)

	if not dodge then
		arg_2_2.is_dodging = true
		arg_2_2.pass_check_position = Vector3Box(var_2_4)
		arg_2_2.dodge_end_time = arg_2_3 + action_data.dodge_time
		arg_2_2.move_state = nil

		LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

		local navigation_extension = arg_2_2.navigation_extension

		navigation_extension:set_max_speed(arg_2_2.breed.run_speed)
		navigation_extension:move_to(dodge)

		local locomotion_extension = arg_2_2.locomotion_extension

		locomotion_extension:set_rotation_speed(20)
		locomotion_extension:set_movement_type("snap_to_navmesh")

		local network = Managers.state.network
		local var_2_9 = network
		local anim_event = network.anim_event
		local var_2_11 = arg_2_1
		local dodge_right_anim

		if not var_2_5 then
			dodge_right_anim = action_data.dodge_right_anim

			if not dodge_right_anim then
				-- Nothing
			end
		end

		if not var_2_5 then
			dodge_right_anim = action_data.dodge_left_anim

			if not dodge_right_anim then
				-- Nothing
			end
		end

		dodge_right_anim = action_data.dodge_anim

		::label_2_0::

		anim_event(var_2_9, var_2_11, dodge_right_anim)

		if not script_data.debug_ai_movement then
			local var_2_13 = POSITION_LOOKUP[arg_2_1]

			QuickDrawerStay:sphere(dodge, 0.2, Color(255, 255, 0))
			QuickDrawerStay:sphere(var_2_4, 0.2, Color(255, 0, 0))
			QuickDrawerStay:line(var_2_13, dodge, Color(255, 255, 0))
		end
	end
end

BTLootRatDodgeAction.run = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not arg_3_2.is_dodging then
		return "done"
	end

	if not arg_3_2.anim_cb_dodge_finished then
		return "done"
	end

	if arg_3_3 > arg_3_2.dodge_end_time then
		return "done"
	end

	local num = arg_3_2.pass_check_position:unbox() - POSITION_LOOKUP[arg_3_1]
	local local_rotation = Unit.local_rotation(arg_3_1, 0)
	local forward = Quaternion.forward(local_rotation)
	local dot = Vector3.dot(Vector3.normalize(num), forward)

	if not (arg_3_2.do_pass_check or not (dot > 0.5)) then
		arg_3_2.do_pass_check = true
	end

	if not (not arg_3_2.do_pass_check and not (dot < 0)) then
		return "done"
	end

	return "running"
end

BTLootRatDodgeAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.action = nil
	arg_4_2.is_dodging = nil
	arg_4_2.pass_check_position = nil
	arg_4_2.dodge_end_time = nil
	arg_4_2.do_pass_check = nil
	arg_4_2.dodge_vector = nil
	arg_4_2.threat_vector = nil
	arg_4_2.anim_cb_dodge_finished = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(get_default_breed_move_speed)

	if not script_data.debug_ai_movement then
		local var_4_1 = POSITION_LOOKUP[arg_4_1]

		QuickDrawerStay:sphere(var_4_1, 0.25, Color(0, 255, 0))
	end
end

BTLootRatDodgeAction.dodge = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local current_velocity = arg_5_2.locomotion_extension:current_velocity()
	local normalize = Vector3.normalize(current_velocity)
	local normalize_2 = Vector3.normalize(arg_5_3)
	local cross = Vector3.cross(-arg_5_4, Vector3.up())

	if Vector3.cross(normalize_2, arg_5_4).z > 0 then
		cross = -cross
	end

	local num = cross * 2 + normalize
	local dodge_distance = arg_5_2.action.dodge_distance
	local num_2 = dodge_distance - 0.3
	local num_3 = var_5_0 + num * dodge_distance
	local try_dodge_position = self:try_dodge_position(arg_5_1, arg_5_2, var_5_0, num_3)

	if not try_dodge_position then
		local num_4 = var_5_0 + num * num_2

		return try_dodge_position, num_4, Vector3.cross(num, normalize).z > 0
	end

	local num_5 = var_5_0 - num * dodge_distance
	local try_dodge_position_2 = self:try_dodge_position(arg_5_1, arg_5_2, var_5_0, num_5)

	if not try_dodge_position_2 then
		local num_6 = var_5_0 - num * num_2

		return try_dodge_position_2, num_6, Vector3.cross(-num, normalize).z > 0
	end
end

BTLootRatDodgeAction.try_dodge_position = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local triangle_from_position, var_6_1 = GwNavQueries.triangle_from_position(arg_6_2.nav_world, arg_6_4, 3, 3)

	if not triangle_from_position then
		Vector3.set_z(arg_6_4, var_6_1)

		if not GwNavQueries.raycast(arg_6_2.nav_world, arg_6_3, arg_6_4) then
			return arg_6_4
		end
	end
end
