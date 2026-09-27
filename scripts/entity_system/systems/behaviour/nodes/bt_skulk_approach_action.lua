-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_skulk_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSkulkApproachAction = class(BTSkulkApproachAction, BTNode)
BTSkulkApproachAction.name = "BTSkulkApproachAction"

BTSkulkApproachAction.init = function (arg_1_0, ...)
	-- function 1
	BTSkulkApproachAction.super.init(arg_1_0, ...)
end

BTSkulkApproachAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local target_dist = arg_2_2.target_dist
	local min

	if not target_dist then
		min = math.min(action_data.skulk_init_distance, target_dist)

		if not min then
			-- Nothing
		end
	end

	min = action_data.skulk_init_distance

	::label_2_0::

	local skulk_data = arg_2_2.skulk_data

	skulk_data = skulk_data or {}

	local direction = skulk_data.direction

	direction = direction or 1 - math.random(0, 1) * 2
	skulk_data.direction = direction

	local radius = skulk_data.radius

	radius = radius or min
	skulk_data.radius = radius

	local skulk_around_time = skulk_data.skulk_around_time

	skulk_around_time = skulk_around_time or 0
	skulk_data.skulk_around_time = skulk_around_time
	skulk_data.next_random_goal_at_radius = skulk_data.radius
	arg_2_2.skulk_data = skulk_data
	arg_2_2.action = action_data

	if arg_2_2.move_state ~= "idle" then
		self:idle(arg_2_1, arg_2_2)
	end

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if not arg_2_2.move_pos then
		local unbox = arg_2_2.move_pos:unbox()

		self:move_to(unbox, arg_2_1, arg_2_2)
	end

	local network = Managers.state.network
	local tutorial_message_template = action_data.tutorial_message_template

	if not tutorial_message_template then
		local var_2_10 = NetworkLookup.tutorials[tutorial_message_template]
		local var_2_11 = NetworkLookup.tutorials[arg_2_2.breed.name]

		network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_10, var_2_11)
	end
end

BTSkulkApproachAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.skulk_data.animation_state = nil
	arg_3_2.action = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local navigation_extension = arg_3_2.navigation_extension

	navigation_extension:set_max_speed(get_default_breed_move_speed)

	if arg_3_4 == "aborted" then
		local is_following_path = navigation_extension:is_following_path()

		if not (not arg_3_2.move_pos and not is_following_path and arg_3_2.move_state ~= "idle") then
			self:start_move_animation(arg_3_1, arg_3_2)
		end
	end
end

local num = 0.5

BTSkulkApproachAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	self:update_skulk_data(arg_4_1, arg_4_2, arg_4_4)

	local navigation_extension = arg_4_2.navigation_extension
	local is_following_path = navigation_extension:is_following_path()
	local number_failed_move_attempts = navigation_extension:number_failed_move_attempts()

	if not (not arg_4_2.move_pos and not is_following_path and arg_4_2.move_state ~= "idle") then
		self:start_move_animation(arg_4_1, arg_4_2)
	end

	local skulk_data = arg_4_2.skulk_data
	local action = arg_4_2.action

	if not self:commit_to_target(arg_4_1, arg_4_2, arg_4_4) then
		skulk_data.radius = action.skulk_init_distance

		return "done"
	end

	if not arg_4_2.move_pos then
		if not (self:at_goal(arg_4_1, arg_4_2) or not (number_failed_move_attempts > 0)) then
			arg_4_2.move_pos = nil
		end

		return "running"
	end

	if skulk_data.radius <= skulk_data.next_random_goal_at_radius then
		local get_random_goal_on_circle = self:get_random_goal_on_circle(arg_4_1, arg_4_2)

		if not get_random_goal_on_circle then
			self:move_to(get_random_goal_on_circle, arg_4_1, arg_4_2)

			return "running"
		end

		skulk_data.next_random_goal_at_radius = skulk_data.radius - num
	end

	if arg_4_2.move_state ~= "idle" then
		self:idle(arg_4_1, arg_4_2)
	end

	return "running"
end

BTSkulkApproachAction.update_skulk_data = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local action = arg_5_2.action
	local skulk_init_distance = action.skulk_init_distance
	local skulk_data = arg_5_2.skulk_data
	local var_5_3

	if not arg_5_2.move_pos then
		var_5_3 = arg_5_3 * action.decrease_radius_speed
	else
		var_5_3 = num
	end

	local num_2 = skulk_data.radius - var_5_3

	skulk_data.radius = math.clamp(num_2, 0, skulk_init_distance)
	skulk_data.skulk_around_time = skulk_data.skulk_around_time + arg_5_3
end

local num_2 = 5

BTSkulkApproachAction.commit_to_target = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local action = arg_6_2.action
	local previous_attacker = arg_6_2.previous_attacker

	return arg_6_2.target_dist < action.commit_distance or previous_attacker or arg_6_2.skulk_data.radius <= num_2
end

BTSkulkApproachAction.at_goal = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local skulk_data = arg_7_2.skulk_data
	local move_pos = arg_7_2.move_pos

	if not move_pos then
		return false
	end

	local unbox = move_pos:unbox()

	if Vector3.distance_squared(unbox, POSITION_LOOKUP[arg_7_1]) < 0.25 then
		return true
	end
end

BTSkulkApproachAction.move_to = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local skulk_data = arg_8_3.skulk_data

	arg_8_3.navigation_extension:move_to(arg_8_1)

	arg_8_3.move_pos = Vector3Box(arg_8_1)
end

BTSkulkApproachAction.idle = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:anim_event(arg_9_1, arg_9_2, "idle")

	arg_9_2.move_state = "idle"
end

BTSkulkApproachAction.start_move_animation = function (self, arg_10_1, arg_10_2)
	-- function 10
	self:anim_event(arg_10_1, arg_10_2, "move_fwd_run")

	arg_10_2.move_state = "moving"
end

BTSkulkApproachAction.anim_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local skulk_data = arg_11_2.skulk_data

	if skulk_data.animation_state ~= arg_11_3 then
		Managers.state.network:anim_event(arg_11_1, arg_11_3)

		skulk_data.animation_state = arg_11_3
	end
end

local num_3 = 15

BTSkulkApproachAction.get_random_goal_on_circle = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local skulk_data = arg_12_2.skulk_data
	local radius = skulk_data.radius
	local target_unit = arg_12_2.target_unit
	local var_12_3 = POSITION_LOOKUP[target_unit]
	local var_12_4 = POSITION_LOOKUP[arg_12_1]
	local direction = skulk_data.direction
	local num = Vector3.up() * 0.2
	local num_2 = var_12_4 - var_12_3
	local look = Quaternion.look(num_2, Vector3.up())
	local forward = Quaternion.forward(look)
	local forward_2 = Vector3.forward()
	local get_angle_between_vectors, var_12_12 = AiUtils.get_angle_between_vectors(forward, forward_2)

	for i = 1, num_3 do
		local num_4 = (i * 3 + Math.random(0, 3)) * direction

		if i == num_3 then
			num_4 = 2 * direction
		end

		local num_5 = var_12_12 + num_4
		local degrees_to_radians = math.degrees_to_radians(num_5)
		local num_6 = radius + Math.random(-1, 0)
		local axis_angle = Quaternion.axis_angle(Vector3.up(), degrees_to_radians)
		local num_7 = var_12_3 + Quaternion.forward(axis_angle) * num_6
		local nav_world = arg_12_2.nav_world
		local triangle_from_position, var_12_21 = GwNavQueries.triangle_from_position(nav_world, num_7, 5, 5)

		if not triangle_from_position then
			num_7.z = var_12_21

			if not script_data.ai_globadier_behavior then
				QuickDrawerStay:sphere(num_7 + num, 0.25, Colors.get("aqua_marine"))
			end

			arg_12_2.wanted_distance = num_6

			return num_7
		elseif not script_data.ai_globadier_behavior then
			QuickDrawerStay:sphere(num_7 + num, 0.25, Colors.get_color_with_alpha("aqua_marine", 100))
		end
	end

	return false
end

BTSkulkApproachAction.debug_show_skulk_circle = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local skulk_init_distance = arg_13_2.action.skulk_init_distance
	local radius = arg_13_2.skulk_data.radius
	local target_unit = arg_13_2.target_unit
	local var_13_3 = POSITION_LOOKUP[target_unit]
	local num = Vector3.up() * 0.2

	QuickDrawer:circle(var_13_3 + num, radius, Vector3.up(), Colors.get("light_green"))
	QuickDrawer:circle(var_13_3 + num, skulk_init_distance, Vector3.up(), Colors.get("light_green"))
end
