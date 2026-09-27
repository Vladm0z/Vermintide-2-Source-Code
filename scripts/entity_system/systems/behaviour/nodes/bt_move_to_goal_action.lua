-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_move_to_goal_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMoveToGoalAction = class(BTMoveToGoalAction, BTNode)

BTMoveToGoalAction.init = function (arg_1_0, ...)
	-- function 1
	BTMoveToGoalAction.super.init(arg_1_0, ...)
end

BTMoveToGoalAction.name = "BTMoveToGoalAction"

BTMoveToGoalAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	local eval_time = arg_2_2.action.eval_time

	eval_time = eval_time or 0.5
	arg_2_2.time_to_next_evaluate = arg_2_3 + eval_time
	arg_2_2.time_to_next_friend_alert = arg_2_3 + 0.3

	local unbox = arg_2_2.goal_destination:unbox()

	arg_2_2.navigation_extension:move_to(unbox)

	arg_2_2.new_move_to_goal = nil

	local network = Managers.state.network
	local breed = arg_2_2.breed
	local passive_in_patrol

	if breed.passive_in_patrol ~= nil then
		passive_in_patrol = breed.passive_in_patrol

		if not passive_in_patrol then
			passive_in_patrol = not arg_2_2.ignore_passive_on_patrol
		end

		if false then
			passive_in_patrol = false
		end
	else
		passive_in_patrol = true
	end

	if not passive_in_patrol then
		AiUtils.enter_passive(arg_2_1, arg_2_2)
	else
		AiUtils.enter_combat(arg_2_1, arg_2_2)
	end

	if not not breed.dont_wield_weapon_on_patrol and not ScriptUnit.has_extension(arg_2_1, "ai_inventory_system") then
		local unit_game_object_id = network:unit_game_object_id(arg_2_1)

		network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, 1)
	end

	local override_move_speed = arg_2_2.action.override_move_speed

	if not override_move_speed then
		arg_2_2.navigation_extension:set_max_speed(override_move_speed)
	end
end

BTMoveToGoalAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not arg_3_5 then
		self:toggle_start_move_animation_lock(arg_3_1, false, arg_3_2)
	end

	arg_3_2.start_anim_locked = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.start_anim_done = nil
	arg_3_2.skip_move_rotation = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
end

BTMoveToGoalAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not arg_4_2.start_anim_done then
		if not arg_4_2.start_anim_locked then
			self:start_move_animation(arg_4_1, arg_4_2)
		end

		if not arg_4_2.anim_cb_rotation_start then
			self:start_move_rotation(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		end

		if not arg_4_2.anim_cb_move then
			arg_4_2.anim_cb_move = false
			arg_4_2.move_state = "moving"

			self:toggle_start_move_animation_lock(arg_4_1, false, arg_4_2)

			arg_4_2.start_anim_locked = nil
			arg_4_2.start_anim_done = true
		end
	else
		local flag = false

		if not ScriptUnit.has_extension(arg_4_1, "ai_group_system") then
			flag = ScriptUnit.extension(arg_4_1, "ai_group_system").in_patrol
		end

		local action = arg_4_2.action

		if not flag then
			local var_4_2 = POSITION_LOOKUP[arg_4_1]
			local unbox = arg_4_2.goal_destination:unbox()
			local distance_squared = Vector3.distance_squared(var_4_2, unbox)
			local goal_margin = action.goal_margin

			goal_margin = goal_margin or 0.75

			if distance_squared < goal_margin * goal_margin then
				arg_4_2.goal_destination = nil
			end
		end

		if not action.move_speed_func then
			action.move_speed_func(arg_4_1, arg_4_2)
		end
	end

	local var_4_6
	local navigation_extension = arg_4_2.navigation_extension

	if arg_4_3 > arg_4_2.time_to_next_evaluate or not navigation_extension:has_reached_destination() then
		var_4_6 = "evaluate"

		local eval_time = arg_4_2.action.eval_time

		eval_time = eval_time or 0.5
		arg_4_2.time_to_next_evaluate = arg_4_3 + eval_time
	end

	if not arg_4_2.new_move_to_goal then
		if not arg_4_2.goal_destination then
			local unbox_2 = arg_4_2.goal_destination:unbox()

			navigation_extension:move_to(unbox_2)

			if arg_4_1 == script_data.debug_unit then
				QuickDrawer:sphere(unbox_2, 1, Colors.get("yellow"))
			end
		end

		arg_4_2.new_move_to_goal = nil
	end

	return "running", var_4_6
end

BTMoveToGoalAction.start_move_animation = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:toggle_start_move_animation_lock(arg_5_1, true, arg_5_2)

	local breed = arg_5_2.breed
	local flag = breed.passive_in_patrol == nil or breed.passive_in_patrol
	local str = "move_start_fwd"
	local passive_in_patrol_start_anim = breed.passive_in_patrol_start_anim

	if not flag and not passive_in_patrol_start_anim then
		arg_5_2.anim_cb_move = true
		str = type(passive_in_patrol_start_anim) ~= "table" or not passive_in_patrol_start_anim[math.random(1, #passive_in_patrol_start_anim)] or passive_in_patrol_start_anim
		arg_5_2.skip_move_rotation = true
	end

	Managers.state.network:anim_event(arg_5_1, str)

	arg_5_2.move_animation_name = str
	arg_5_2.start_anim_locked = true
end

BTMoveToGoalAction.start_move_rotation = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if arg_6_2.move_animation_name == "move_start_fwd" or not arg_6_2.skip_move_rotation then
		self:toggle_start_move_animation_lock(arg_6_1, false, arg_6_2)
	else
		arg_6_2.anim_cb_rotation_start = false

		local var_6_0 = POSITION_LOOKUP[arg_6_2.target_unit]

		if var_6_0 or not arg_6_2.goal_destination then
			var_6_0 = arg_6_2.goal_destination:unbox()
		end

		local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_6_1, var_6_0, arg_6_2.move_animation_name, arg_6_2.action.start_anims_data)

		LocomotionUtils.set_animation_rotation_scale(arg_6_1, get_animation_rotation_scale)
	end
end

BTMoveToGoalAction.toggle_start_move_animation_lock = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local locomotion_extension = arg_7_3.locomotion_extension

	if not locomotion_extension._engine_extension_id then
		return
	end

	if not arg_7_2 then
		locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_7_1, true, false, false)
	else
		locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_7_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_7_1, 1)
	end
end
