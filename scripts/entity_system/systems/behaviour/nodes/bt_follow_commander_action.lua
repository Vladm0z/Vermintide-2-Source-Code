-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_follow_commander_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFollowCommanderAction = class(BTFollowCommanderAction, BTNode)

BTFollowCommanderAction.init = function (arg_1_0, ...)
	-- function 1
	BTFollowCommanderAction.super.init(arg_1_0, ...)
end

BTFollowCommanderAction.name = "BTFollowCommanderAction"

BTFollowCommanderAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.time_to_next_evaluate = arg_2_3 + 0.5
	arg_2_2.time_to_next_friend_alert = arg_2_3 + 0.3

	local commander_extension = arg_2_2.commander_extension

	commander_extension:register_follow_node_update(arg_2_1)

	arg_2_2.follow_node_position, arg_2_2.commander_extension = commander_extension:follow_node_position(arg_2_1), commander_extension
	arg_2_2.new_follow_node_pos = true

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

	local speed_animation_variable = arg_2_2.speed_animation_variable

	if not speed_animation_variable then
		speed_animation_variable = Unit.animation_has_variable(arg_2_1, "move_speed")
		speed_animation_variable = not speed_animation_variable and Unit.animation_find_variable(arg_2_1, "move_speed")
	end

	arg_2_2.speed_animation_variable = speed_animation_variable
end

BTFollowCommanderAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not arg_3_5 then
		self:toggle_start_move_animation_lock(arg_3_1, false, arg_3_2)
	end

	if not arg_3_2.commander_extension then
		arg_3_2.commander_extension:unregister_follow_node_update(arg_3_1)
	end

	arg_3_2.start_anim_locked = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.start_anim_done = nil
	arg_3_2.skip_move_rotation = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)

	if not arg_3_2.speed_animation_variable then
		Unit.animation_set_variable(arg_3_1, arg_3_2.speed_animation_variable, get_default_breed_move_speed)

		arg_3_2.speed_animation_variable = nil
	end
end

BTFollowCommanderAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local navigation_extension = arg_4_2.navigation_extension

	if not arg_4_2.commander_extension:follow_node_pending(arg_4_2) then
		return "running"
	end

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
		local unbox = arg_4_2.follow_node_position:unbox()
		local var_4_2 = POSITION_LOOKUP[arg_4_1]

		if not arg_4_2.new_follow_node_pos then
			navigation_extension:move_to(unbox)

			arg_4_2.new_follow_node_pos = nil
			arg_4_2.finalized_new_follow_node_pos = nil
		end

		if not navigation_extension:has_reached_destination() then
			arg_4_2.follow_node_position = nil

			return "done"
		end

		local num = 0
		local has_extension = ScriptUnit.has_extension(arg_4_2.commander_unit, "locomotion_system")

		if not has_extension then
			num = Vector3.length(has_extension:current_velocity())
		end

		local distance = Vector3.distance(var_4_2, unbox)
		local max = math.max(arg_4_2.breed.run_speed, num)
		local max_2 = math.max(arg_4_2.breed.min_run_speed, num)
		local run_max_speed_distance = arg_4_2.breed.run_max_speed_distance
		local run_min_speed_distance = arg_4_2.breed.run_min_speed_distance
		local lerp = math.lerp(max_2, max, math.clamp01((distance - run_min_speed_distance) / run_max_speed_distance))

		navigation_extension:set_max_speed(lerp)

		if not arg_4_2.speed_animation_variable then
			Unit.animation_set_variable(arg_4_1, arg_4_2.speed_animation_variable, lerp)
		end
	end

	local var_4_11

	if arg_4_3 > arg_4_2.time_to_next_evaluate or arg_4_2.new_follow_node_pos or not navigation_extension:has_reached_destination() then
		var_4_11 = "evaluate"
		arg_4_2.time_to_next_evaluate = arg_4_3 + 0.5
	end

	return "running", var_4_11
end

BTFollowCommanderAction.start_move_animation = function (self, arg_5_1, arg_5_2)
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

BTFollowCommanderAction.start_move_rotation = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
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

BTFollowCommanderAction.toggle_start_move_animation_lock = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
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
