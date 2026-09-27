-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_skulk_around_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterSkulkAroundAction = class(BTPackMasterSkulkAroundAction, BTNode)

BTPackMasterSkulkAroundAction.init = function (self, ...)
	-- function 1
	BTPackMasterSkulkAroundAction.super.init(self, ...)

	self.navigation_group_manager = Managers.state.conflict.navigation_group_manager
end

BTPackMasterSkulkAroundAction.name = "BTPackMasterSkulkAroundAction"

BTPackMasterSkulkAroundAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)
	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)

	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	local skulk_time = arg_2_2.skulk_time

	skulk_time = skulk_time or arg_2_3 + action_data.skulk_time
	arg_2_2.skulk_time = skulk_time

	local skulk_time_force_attack = arg_2_2.skulk_time_force_attack

	skulk_time_force_attack = skulk_time_force_attack or arg_2_3 + action_data.skulk_time_force_attack
	arg_2_2.skulk_time_force_attack = skulk_time_force_attack
	arg_2_2.skulk_goal_get_fails = 0
	arg_2_2.skulk_debug_state = "enter"

	arg_2_2.locomotion_extension:set_rotation_speed(5)

	local attack_cooldown = arg_2_2.attack_cooldown

	attack_cooldown = attack_cooldown or 0
	arg_2_2.attack_cooldown = attack_cooldown
end

BTPackMasterSkulkAroundAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.action = nil
	arg_3_2.skulk_pos = nil
	arg_3_2.skulk_around_dir = nil
	arg_3_2.skulk_in_los = nil
	arg_3_2.skulk_dogpile = nil
	arg_3_2.skulk_debug_state = nil
	arg_3_2.skulk_goal_get_fails = nil

	if arg_3_4 == "failed" then
		arg_3_2.target_unit = nil
		arg_3_2.skulk_time = nil
		arg_3_2.skulk_time_left = nil
	end

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
end

local tbl = {}

BTPackMasterSkulkAroundAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not AiUtils.is_of_interest_to_packmaster(arg_4_1, arg_4_2.target_unit) then
		return "failed"
	end

	local locomotion_extension = arg_4_2.locomotion_extension
	local breed = arg_4_2.breed
	local var_4_2 = POSITION_LOOKUP[arg_4_2.target_unit]

	if not script_data.debug_ai_movement then
		arg_4_2.skulk_time_left = string.format("%.2f", arg_4_2.skulk_time - arg_4_3)

		self:debug(arg_4_1, arg_4_2)
	end

	if not (not (arg_4_3 > arg_4_2.skulk_time) or not (arg_4_3 > arg_4_2.attack_cooldown)) then
		local action = arg_4_2.action
		local flag = arg_4_3 > arg_4_2.skulk_time_force_attack
		local slots_count = Managers.state.entity:system("ai_slot_system"):slots_count(arg_4_2.target_unit)

		if slots_count >= action.dogpile_aggro_needed or script_data.ai_packmaster_ignore_dogpile or not flag then
			arg_4_2.skulk_pos = nil
			arg_4_2.skulk_around_dir = nil

			return "done"
		end

		arg_4_2.skulk_dogpile = slots_count
		arg_4_2.skulk_time = arg_4_3 + 1
	end

	if not arg_4_2.skulk_pos then
		self:get_new_goal(arg_4_1, arg_4_2)

		arg_4_2.skulk_debug_state = "get_new_goal"

		return "running"
	end

	local navigation_extension = arg_4_2.navigation_extension
	local is_computing_path = navigation_extension:is_computing_path()

	if not (arg_4_2.move_state == "moving" or is_computing_path) then
		local network = Managers.state.network

		arg_4_2.move_state = "moving"

		local var_4_9 = network
		local anim_event = network.anim_event
		local var_4_11 = arg_4_1
		local skulk_animation = arg_4_2.action.skulk_animation

		skulk_animation = skulk_animation or "move_fwd"

		anim_event(var_4_9, var_4_11, skulk_animation)
		navigation_extension:set_enabled(true)
	end

	local unbox = arg_4_2.skulk_pos:unbox()
	local var_4_14 = POSITION_LOOKUP[arg_4_1]
	local distance_squared = Vector3.distance_squared(unbox, var_4_14)

	locomotion_extension:set_wanted_rotation(nil)

	if distance_squared < 9 then
		if not self:get_new_goal(arg_4_1, arg_4_2) then
			arg_4_2.skulk_debug_state = "new goal found"
		else
			table.clear(tbl)

			local new_random_goal = LocomotionUtils.new_random_goal(arg_4_2.nav_world, arg_4_2, var_4_2, 15, 30, 10, tbl)

			if not new_random_goal then
				arg_4_2.skulk_debug_state = "fallback"
				arg_4_2.skulk_pos = Vector3Box(new_random_goal)

				navigation_extension:move_to(new_random_goal)
			else
				arg_4_2.skulk_debug_state = "fallback fail"
			end
		end
	end

	if not (not (Vector3.distance_squared(var_4_2, var_4_14) < arg_4_2.action.melee_override_distance_sqr) or not (arg_4_3 > arg_4_2.attack_cooldown)) then
		arg_4_2.skulk_pos = nil
		arg_4_2.skulk_around_dir = nil

		return "done"
	end

	return "running"
end

BTPackMasterSkulkAroundAction.get_new_goal = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local target_unit = arg_5_2.target_unit

	if not Unit.alive(target_unit) then
		local skulk_goal_get_fails = arg_5_2.skulk_goal_get_fails
		local var_5_2
		local num = 10
		local num_2 = 25
		local skulk_around_dir = arg_5_2.skulk_around_dir

		skulk_around_dir = skulk_around_dir or 1 - math.random(0, 1) * 2
		arg_5_2.skulk_around_dir = skulk_around_dir

		local num_3 = math.random(10, 180) * skulk_around_dir
		local num_4 = 5 + skulk_goal_get_fails * 5
		local outside_goal = LocomotionUtils.outside_goal(arg_5_2.nav_world, POSITION_LOOKUP[arg_5_1], POSITION_LOOKUP[target_unit], num, num_2, num_3, 5, num_4, num_4)

		if not outside_goal then
			arg_5_2.skulk_goal_get_fails = 0
			arg_5_2.skulk_pos = Vector3Box(outside_goal)

			arg_5_2.navigation_extension:move_to(outside_goal)

			return true
		else
			arg_5_2.skulk_goal_get_fails = skulk_goal_get_fails + 1
		end
	end
end

BTPackMasterSkulkAroundAction.debug = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = POSITION_LOOKUP[arg_6_1]

	if not arg_6_2.skulk_pos then
		local unbox = arg_6_2.skulk_pos:unbox()

		QuickDrawer:sphere(unbox + Vector3(0, 0, 1), 0.5, Color(255, 144, 43, 207))
		QuickDrawer:sphere(unbox + Vector3(0, 0, 1.5), 0.25, Color(255, 144, 43, 207))
		QuickDrawer:sphere(unbox + Vector3(0, 0, 1.725), 0.125, Color(255, 144, 43, 207))

		if not arg_6_2.in_los then
			QuickDrawer:sphere(unbox + Vector3(0, 0, 2), 0.25, Color(255, 144, 43, 43))
		end
	else
		QuickDrawer:sphere(var_6_0 + Vector3(0, 0, 1), 0.5, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_6_0 + Vector3(0, 0, 1.55), 0.25, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_6_0 + Vector3(0, 0, 1.725), 0.125, Color(255, 144, 43, 207))
	end

	if not arg_6_2.skulk_in_los then
		QuickDrawer:sphere(var_6_0 + Vector3(0, 0, 2), 0.25, Colors.get("red"))
	end

	for i = 1, #tbl do
		local unbox_2 = tbl[i]:unbox()

		QuickDrawer:sphere(unbox_2 + Vector3(0, 0, 2), 0.5, Color(255, 43, 43, 207))
	end
end
