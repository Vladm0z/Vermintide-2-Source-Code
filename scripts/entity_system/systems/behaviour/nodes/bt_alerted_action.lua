-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_alerted_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTAlertedAction = class(BTAlertedAction, BTNode)

BTAlertedAction.init = function (arg_1_0, ...)
	-- function 1
	BTAlertedAction.super.init(arg_1_0, ...)
end

BTAlertedAction.name = "BTAlertedAction"

BTAlertedAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	local alerted_action = arg_2_2.alerted_action

	alerted_action = alerted_action or {}
	arg_2_2.alerted_action = alerted_action
	arg_2_2.move_animation_name = nil
	arg_2_2.anim_cb_rotation_start = false
	arg_2_2.anim_cb_move = false
	arg_2_2.alerted_deadline_reached = false
	arg_2_2.alerted_deadline_reached_and_sighted_enemy = false

	self:should_hesitate(arg_2_1, arg_2_2, action_data)
	self:decide_deadline(arg_2_1, arg_2_2, arg_2_3)

	arg_2_2.no_alert = not self:init_alerted(arg_2_1, arg_2_2, arg_2_3)

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.in_alerted_state = true
	arg_2_2.move_state = "idle"
end

BTAlertedAction.init_alerted = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_3_1)

	if not script_data.enable_alert_icon then
		local str = "detect"
		local node = Unit.node(arg_3_1, "c_head")
		local str_2 = "player_1"
		local var_3_5 = Vector3(255, 0, 0)
		local var_3_6 = Vector3(0, 0, 1)
		local num = 0.5
		local str_3 = "!"

		Managers.state.debug_text:output_unit_text(str_3, num, arg_3_1, node, var_3_6, nil, str, var_3_5, str_2)
		network.network_transmit:send_rpc_clients("rpc_enemy_is_alerted", unit_game_object_id, true)
	end

	if not ScriptUnit.has_extension(arg_3_1, "ai_inventory_system") then
		network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, 1)
	end

	local var_3_9 = POSITION_LOOKUP[arg_3_2.target_unit]
	local var_3_10 = POSITION_LOOKUP[arg_3_1]
	local distance = Vector3.distance(var_3_9, var_3_10)

	if distance > 6 or not arg_3_2.action.close_range_alert_idle then
		local alerted_anims = arg_3_2.action.alerted_anims

		if not alerted_anims then
			local var_3_13 = alerted_anims[math.random(1, #alerted_anims)]

			network:anim_event(arg_3_1, var_3_13)
		else
			network:anim_event(arg_3_1, "alerted")
		end
	end

	local extension_input = ScriptUnit.extension_input(arg_3_1, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("startled", alloc_table)

	local world = arg_3_2.world
	local physics_world = World.physics_world(world)

	if not (not PerceptionUtils.raycast_spine_to_spine(arg_3_1, arg_3_2.target_unit, physics_world) and arg_3_2.action.no_hesitation or not (distance < 12)) then
		arg_3_2.alerted_action.deadline = arg_3_2.alerted_action.deadline - 0

		return false
	end

	return true
end

BTAlertedAction.decide_deadline = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local target_unit = arg_4_2.target_unit
	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local var_4_2 = POSITION_LOOKUP[target_unit]
	local normalize = Vector3.normalize(Vector3.flat(var_4_2 - var_4_1))
	local local_rotation = Unit.local_rotation(arg_4_1, 0)
	local normalize_2 = Vector3.normalize(Vector3.flat(Quaternion.forward(local_rotation)))
	local dot = Vector3.dot(normalize_2, normalize)
	local flag

	flag = not (dot > 0.25) or not 0.5 or 1

	local max = math.max(flag, 2 - dot * 2)
	local num = 0
	local breed = arg_4_2.breed
	local action = arg_4_2.action

	if not action.override_time_alerted then
		num = action.override_time_alerted
	elseif not action.close_range_alert_idle then
		arg_4_2.no_alert_override = true
	end

	arg_4_2.alerted_action.deadline = num + arg_4_3
end

BTAlertedAction.should_hesitate = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if not arg_5_3.no_hesitation then
		arg_5_2.no_hesitation = true
	elseif not arg_5_2.no_hestitation then
		local target_unit = arg_5_2.target_unit
		local var_5_1 = POSITION_LOOKUP[target_unit]
		local var_5_2 = POSITION_LOOKUP[arg_5_1]
		local nav_world = arg_5_2.nav_world
		local triangle_from_position, var_5_5 = GwNavQueries.triangle_from_position(nav_world, var_5_1, 0.25, 1.5)
		local triangle_from_position_2, var_5_7 = GwNavQueries.triangle_from_position(nav_world, var_5_2, 0.25, 0.25)

		if not triangle_from_position and not triangle_from_position_2 then
			local var_5_8 = Vector3(var_5_2.x, var_5_2.y, var_5_7)
			local var_5_9 = Vector3(var_5_1.x, var_5_1.y, var_5_5)
			local raycast, var_5_11 = GwNavQueries.raycast(nav_world, var_5_8, var_5_9)

			if not raycast then
				local raycast_2, var_5_13 = GwNavQueries.raycast(nav_world, var_5_9, var_5_8)
				local num = var_5_11 - var_5_13
				local z = num.z

				arg_5_2.no_hesitation = not (z > 2) or math.asin(z / Vector3.length(num)) > math.pi / 3
			end
		else
			arg_5_2.no_hesitation = true
		end
	end
end

BTAlertedAction.leave = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local network = Managers.state.network

	if not script_data.enable_alert_icon then
		local str = "detect"

		Managers.state.debug_text:clear_unit_text(arg_6_1, str)

		local unit_game_object_id = network:unit_game_object_id(arg_6_1)

		network.network_transmit:send_rpc_clients("rpc_enemy_is_alerted", unit_game_object_id, false)
	end

	if not arg_6_2.no_hesitation then
		AiUtils.activate_unit(arg_6_2)
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_6_1, true)

		if not (not arg_6_2.move_animation_name and arg_6_5) then
			arg_6_2.locomotion_extension:use_lerp_rotation(true)
			LocomotionUtils.set_animation_driven_movement(arg_6_1, false)
			LocomotionUtils.set_animation_rotation_scale(arg_6_1, 1)

			if arg_6_4 ~= "aborted" then
				arg_6_2.move_state = "moving"
				arg_6_2.anim_locked = 0
				arg_6_2.spawn_to_running = true

				network:anim_event(arg_6_1, "move_fwd")
			end
		end
	end

	arg_6_2.anim_cb_move = nil

	arg_6_2.navigation_extension:set_enabled(true)

	arg_6_2.action = nil
	arg_6_2.in_alerted_state = false
	arg_6_2.move_animation_name = nil
	arg_6_2.no_alert = nil
	arg_6_2.no_alert_override = nil

	if not ScriptUnit.has_extension(arg_6_1, "ai_shield_system") then
		ScriptUnit.extension(arg_6_1, "ai_shield_system"):set_is_blocking(true)
	end

	if not arg_6_2.confirmed_player_sighting then
		AiUtils.enter_passive(arg_6_1, arg_6_2)
	end

	local lerp_alerted_into_follow_speed = arg_6_2.breed.lerp_alerted_into_follow_speed

	lerp_alerted_into_follow_speed = lerp_alerted_into_follow_speed or nil
	arg_6_2.lerp_into_follow = lerp_alerted_into_follow_speed
end

local function fn(arg_7_0, arg_7_1)
	-- function 7
	if type(arg_7_0) == "table" then
		return table.contains(arg_7_0, arg_7_1)
	else
		return arg_7_0 == arg_7_1
	end
end

BTAlertedAction.check_if_should_start_moving = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local action = arg_8_2.action
	local target_unit = arg_8_2.target_unit
	local var_8_2 = POSITION_LOOKUP[target_unit]
	local alerted_deadline_reached_and_sighted_enemy = arg_8_2.alerted_deadline_reached_and_sighted_enemy
	local move_animation_name = arg_8_2.move_animation_name

	move_animation_name = not move_animation_name and true

	if not (not alerted_deadline_reached_and_sighted_enemy and move_animation_name) then
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_8_1, true)
		arg_8_2.navigation_extension:set_enabled(true)
		arg_8_2.locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_8_1, true, false, false)

		local get_start_move_animation = AiAnimUtils.get_start_move_animation(arg_8_1, var_8_2, action.start_anims_name)

		fassert(get_start_move_animation, "Move animation was nil!  Have you added start_anims_name entry to breeds?")
		Managers.state.network:anim_event(arg_8_1, get_start_move_animation)

		arg_8_2.move_animation_name = get_start_move_animation
	end

	if not alerted_deadline_reached_and_sighted_enemy and not arg_8_2.anim_cb_rotation_start then
		local move_animation_name_2 = arg_8_2.move_animation_name
		local fwd = action.start_anims_name.fwd

		if not fn(fwd, move_animation_name_2) then
			local locomotion_extension = arg_8_2.locomotion_extension

			locomotion_extension:use_lerp_rotation(true)
			LocomotionUtils.set_animation_driven_movement(arg_8_1, false)

			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_8_1, target_unit)

			locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
		elseif not move_animation_name_2 then
			arg_8_2.anim_cb_rotation_start = false

			local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_8_1, var_8_2, move_animation_name_2, action.start_anims_data)

			LocomotionUtils.set_animation_rotation_scale(arg_8_1, get_animation_rotation_scale)
		end
	end
end

BTAlertedAction.run = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local action = arg_9_2.action
	local target_unit = arg_9_2.target_unit

	if not ((arg_9_2.previous_attacker or not arg_9_2.no_alert) and not (arg_9_3 > arg_9_2.alerted_action.deadline)) then
		arg_9_2.is_alerted = true

		return "done"
	end

	local var_9_2 = POSITION_LOOKUP[arg_9_1]
	local var_9_3 = POSITION_LOOKUP[target_unit]
	local distance_squared = Vector3.distance_squared(var_9_3, var_9_2)
	local flag = distance_squared < 2500

	if not (not (arg_9_3 > arg_9_2.alerted_action.deadline) or arg_9_2.alerted_deadline_reached_and_sighted_enemy) then
		arg_9_2.alerted_deadline_reached = true

		if not arg_9_2.breed.berzerker_alert then
			arg_9_2.alerted_deadline_reached_and_sighted_enemy = true
		elseif not flag then
			local world = arg_9_2.world
			local physics_world = World.physics_world(world)

			if not PerceptionUtils.raycast_spine_to_spine(arg_9_1, target_unit, physics_world) then
				arg_9_2.alerted_deadline_reached_and_sighted_enemy = true
			else
				arg_9_2.alerted_action.deadline = arg_9_3 + 0.5
			end
		end
	end

	if not (not (distance_squared < 36) or arg_9_2.no_alert_override) then
		local world_2 = arg_9_2.world
		local physics_world_2 = World.physics_world(world_2)

		if not PerceptionUtils.raycast_spine_to_spine(arg_9_1, target_unit, physics_world_2) then
			local world_rotation = Unit.world_rotation(arg_9_1, 0)
			local normalize = Vector3.normalize(Quaternion.forward(world_rotation))
			local normalize_2 = Vector3.normalize(var_9_3 - var_9_2)

			if not (Vector3.dot(normalize_2, normalize) > -0.5 or not (distance_squared < 36)) then
				arg_9_2.no_hesitation = true

				return "done"
			end
		end
	end

	if not action.no_hesitation then
		self:check_if_should_start_moving(arg_9_1, arg_9_2)

		if not arg_9_2.anim_cb_move and not arg_9_2.move_animation_name then
			arg_9_2.move_state = "moving"

			return "done"
		end
	end

	if not ((arg_9_2.no_alert or not arg_9_2.alerted_deadline_reached_and_sighted_enemy) and arg_9_2.anim_cb_move or arg_9_2.move_animation_name) then
		arg_9_2.is_alerted = true

		return "done"
	else
		return "running"
	end
end
