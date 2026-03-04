-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_alerted_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTAlertedAction = class(BTAlertedAction, BTNode)

BTAlertedAction.init = function (arg_1_0, ...)
	BTAlertedAction.super.init(arg_1_0, ...)
end

BTAlertedAction.name = "BTAlertedAction"

BTAlertedAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.alerted_action = arg_2_2.alerted_action or {}
	arg_2_2.move_animation_name = nil
	arg_2_2.anim_cb_rotation_start = false
	arg_2_2.anim_cb_move = false
	arg_2_2.alerted_deadline_reached = false
	arg_2_2.alerted_deadline_reached_and_sighted_enemy = false

	arg_2_0:should_hesitate(arg_2_1, arg_2_2, var_2_0)
	arg_2_0:decide_deadline(arg_2_1, arg_2_2, arg_2_3)

	arg_2_2.no_alert = not arg_2_0:init_alerted(arg_2_1, arg_2_2, arg_2_3)

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.in_alerted_state = true
	arg_2_2.move_state = "idle"
end

BTAlertedAction.init_alerted = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = Managers.state.network
	local var_3_1 = var_3_0:unit_game_object_id(arg_3_1)

	if script_data.enable_alert_icon then
		local var_3_2 = "detect"
		local var_3_3 = Unit.node(arg_3_1, "c_head")
		local var_3_4 = "player_1"
		local var_3_5 = Vector3(255, 0, 0)
		local var_3_6 = Vector3(0, 0, 1)
		local var_3_7 = 0.5
		local var_3_8 = "!"

		Managers.state.debug_text:output_unit_text(var_3_8, var_3_7, arg_3_1, var_3_3, var_3_6, nil, var_3_2, var_3_5, var_3_4)
		var_3_0.network_transmit:send_rpc_clients("rpc_enemy_is_alerted", var_3_1, true)
	end

	if ScriptUnit.has_extension(arg_3_1, "ai_inventory_system") then
		var_3_0.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_3_1, 1)
	end

	local var_3_9 = POSITION_LOOKUP[arg_3_2.target_unit]
	local var_3_10 = POSITION_LOOKUP[arg_3_1]
	local var_3_11 = Vector3.distance(var_3_9, var_3_10)

	if var_3_11 > 6 or arg_3_2.action.close_range_alert_idle then
		local var_3_12 = arg_3_2.action.alerted_anims

		if var_3_12 then
			local var_3_13 = var_3_12[math.random(1, #var_3_12)]

			var_3_0:anim_event(arg_3_1, var_3_13)
		else
			var_3_0:anim_event(arg_3_1, "alerted")
		end
	end

	local var_3_14 = ScriptUnit.extension_input(arg_3_1, "dialogue_system")
	local var_3_15 = FrameTable.alloc_table()

	var_3_14:trigger_networked_dialogue_event("startled", var_3_15)

	local var_3_16 = arg_3_2.world
	local var_3_17 = World.physics_world(var_3_16)

	if PerceptionUtils.raycast_spine_to_spine(arg_3_1, arg_3_2.target_unit, var_3_17) and not arg_3_2.action.no_hesitation and var_3_11 < 12 then
		arg_3_2.alerted_action.deadline = arg_3_2.alerted_action.deadline - 0

		return false
	end

	return true
end

BTAlertedAction.decide_deadline = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_2.target_unit
	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local var_4_2 = POSITION_LOOKUP[var_4_0]
	local var_4_3 = Vector3.normalize(Vector3.flat(var_4_2 - var_4_1))
	local var_4_4 = Unit.local_rotation(arg_4_1, 0)
	local var_4_5 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_4_4)))
	local var_4_6 = Vector3.dot(var_4_5, var_4_3)
	local var_4_7 = var_4_6 > 0.25 and 0.5 or 1
	local var_4_8 = math.max(var_4_7, 2 - var_4_6 * 2)
	local var_4_9 = 0
	local var_4_10 = arg_4_2.breed
	local var_4_11 = arg_4_2.action

	if var_4_11.override_time_alerted then
		var_4_9 = var_4_11.override_time_alerted
	elseif var_4_11.close_range_alert_idle then
		arg_4_2.no_alert_override = true
	end

	arg_4_2.alerted_action.deadline = var_4_9 + arg_4_3
end

BTAlertedAction.should_hesitate = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_3.no_hesitation then
		arg_5_2.no_hesitation = true
	elseif not arg_5_2.no_hestitation then
		local var_5_0 = arg_5_2.target_unit
		local var_5_1 = POSITION_LOOKUP[var_5_0]
		local var_5_2 = POSITION_LOOKUP[arg_5_1]
		local var_5_3 = arg_5_2.nav_world
		local var_5_4, var_5_5 = GwNavQueries.triangle_from_position(var_5_3, var_5_1, 0.25, 1.5)
		local var_5_6, var_5_7 = GwNavQueries.triangle_from_position(var_5_3, var_5_2, 0.25, 0.25)

		if var_5_4 and var_5_6 then
			local var_5_8 = Vector3(var_5_2.x, var_5_2.y, var_5_7)
			local var_5_9 = Vector3(var_5_1.x, var_5_1.y, var_5_5)
			local var_5_10, var_5_11 = GwNavQueries.raycast(var_5_3, var_5_8, var_5_9)

			if not var_5_10 then
				local var_5_12, var_5_13 = GwNavQueries.raycast(var_5_3, var_5_9, var_5_8)
				local var_5_14 = var_5_11 - var_5_13
				local var_5_15 = var_5_14.z

				arg_5_2.no_hesitation = var_5_15 > 2 and math.asin(var_5_15 / Vector3.length(var_5_14)) > math.pi / 3
			end
		else
			arg_5_2.no_hesitation = true
		end
	end
end

BTAlertedAction.leave = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = Managers.state.network

	if script_data.enable_alert_icon then
		local var_6_1 = "detect"

		Managers.state.debug_text:clear_unit_text(arg_6_1, var_6_1)

		local var_6_2 = var_6_0:unit_game_object_id(arg_6_1)

		var_6_0.network_transmit:send_rpc_clients("rpc_enemy_is_alerted", var_6_2, false)
	end

	if arg_6_2.no_hesitation then
		AiUtils.activate_unit(arg_6_2)
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_6_1, true)

		if arg_6_2.move_animation_name and not arg_6_5 then
			arg_6_2.locomotion_extension:use_lerp_rotation(true)
			LocomotionUtils.set_animation_driven_movement(arg_6_1, false)
			LocomotionUtils.set_animation_rotation_scale(arg_6_1, 1)

			if arg_6_4 ~= "aborted" then
				arg_6_2.move_state = "moving"
				arg_6_2.anim_locked = 0
				arg_6_2.spawn_to_running = true

				var_6_0:anim_event(arg_6_1, "move_fwd")
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

	if ScriptUnit.has_extension(arg_6_1, "ai_shield_system") then
		ScriptUnit.extension(arg_6_1, "ai_shield_system"):set_is_blocking(true)
	end

	if not arg_6_2.confirmed_player_sighting then
		AiUtils.enter_passive(arg_6_1, arg_6_2)
	end

	arg_6_2.lerp_into_follow = arg_6_2.breed.lerp_alerted_into_follow_speed or nil
end

local function var_0_0(arg_7_0, arg_7_1)
	if type(arg_7_0) == "table" then
		return table.contains(arg_7_0, arg_7_1)
	else
		return arg_7_0 == arg_7_1
	end
end

BTAlertedAction.check_if_should_start_moving = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2.action
	local var_8_1 = arg_8_2.target_unit
	local var_8_2 = POSITION_LOOKUP[var_8_1]
	local var_8_3 = arg_8_2.alerted_deadline_reached_and_sighted_enemy
	local var_8_4 = arg_8_2.move_animation_name and true

	if var_8_3 and not var_8_4 then
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_8_1, true)
		arg_8_2.navigation_extension:set_enabled(true)
		arg_8_2.locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_8_1, true, false, false)

		local var_8_5 = AiAnimUtils.get_start_move_animation(arg_8_1, var_8_2, var_8_0.start_anims_name)

		fassert(var_8_5, "Move animation was nil!  Have you added start_anims_name entry to breeds?")
		Managers.state.network:anim_event(arg_8_1, var_8_5)

		arg_8_2.move_animation_name = var_8_5
	end

	if var_8_3 and arg_8_2.anim_cb_rotation_start then
		local var_8_6 = arg_8_2.move_animation_name
		local var_8_7 = var_8_0.start_anims_name.fwd

		if var_0_0(var_8_7, var_8_6) then
			local var_8_8 = arg_8_2.locomotion_extension

			var_8_8:use_lerp_rotation(true)
			LocomotionUtils.set_animation_driven_movement(arg_8_1, false)

			local var_8_9 = LocomotionUtils.rotation_towards_unit_flat(arg_8_1, var_8_1)

			var_8_8:set_wanted_rotation(var_8_9)
		elseif var_8_6 then
			arg_8_2.anim_cb_rotation_start = false

			local var_8_10 = AiAnimUtils.get_animation_rotation_scale(arg_8_1, var_8_2, var_8_6, var_8_0.start_anims_data)

			LocomotionUtils.set_animation_rotation_scale(arg_8_1, var_8_10)
		end
	end
end

BTAlertedAction.run = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_2.action
	local var_9_1 = arg_9_2.target_unit

	if arg_9_2.previous_attacker or arg_9_2.no_alert and arg_9_3 > arg_9_2.alerted_action.deadline then
		arg_9_2.is_alerted = true

		return "done"
	end

	local var_9_2 = POSITION_LOOKUP[arg_9_1]
	local var_9_3 = POSITION_LOOKUP[var_9_1]
	local var_9_4 = Vector3.distance_squared(var_9_3, var_9_2)
	local var_9_5 = var_9_4 < 2500

	if arg_9_3 > arg_9_2.alerted_action.deadline and not arg_9_2.alerted_deadline_reached_and_sighted_enemy then
		arg_9_2.alerted_deadline_reached = true

		if arg_9_2.breed.berzerker_alert then
			arg_9_2.alerted_deadline_reached_and_sighted_enemy = true
		elseif var_9_5 then
			local var_9_6 = arg_9_2.world
			local var_9_7 = World.physics_world(var_9_6)

			if PerceptionUtils.raycast_spine_to_spine(arg_9_1, var_9_1, var_9_7) then
				arg_9_2.alerted_deadline_reached_and_sighted_enemy = true
			else
				arg_9_2.alerted_action.deadline = arg_9_3 + 0.5
			end
		end
	end

	if var_9_4 < 36 and not arg_9_2.no_alert_override then
		local var_9_8 = arg_9_2.world
		local var_9_9 = World.physics_world(var_9_8)

		if PerceptionUtils.raycast_spine_to_spine(arg_9_1, var_9_1, var_9_9) then
			local var_9_10 = Unit.world_rotation(arg_9_1, 0)
			local var_9_11 = Vector3.normalize(Quaternion.forward(var_9_10))
			local var_9_12 = Vector3.normalize(var_9_3 - var_9_2)

			if Vector3.dot(var_9_12, var_9_11) > -0.5 or var_9_4 < 36 then
				arg_9_2.no_hesitation = true

				return "done"
			end
		end
	end

	if var_9_0.no_hesitation then
		arg_9_0:check_if_should_start_moving(arg_9_1, arg_9_2)

		if arg_9_2.anim_cb_move and arg_9_2.move_animation_name then
			arg_9_2.move_state = "moving"

			return "done"
		end
	end

	if not arg_9_2.no_alert and arg_9_2.alerted_deadline_reached_and_sighted_enemy and (arg_9_2.anim_cb_move or not arg_9_2.move_animation_name) then
		arg_9_2.is_alerted = true

		return "done"
	else
		return "running"
	end
end
