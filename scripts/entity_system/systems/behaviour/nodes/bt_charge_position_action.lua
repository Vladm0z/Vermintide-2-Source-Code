-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_charge_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")

BTChargePositionAction = class(BTChargePositionAction, BTNode)

BTChargePositionAction.init = function (arg_1_0, ...)
	BTChargePositionAction.super.init(arg_1_0, ...)
end

BTChargePositionAction.name = "BTChargePositionAction"

local function var_0_1(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTChargePositionAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTChargePositionAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.locked_attack_rotation = false
	arg_3_2.ray_can_go_update_time = arg_3_3
	arg_3_2.attack_token = true
	arg_3_2.requested_charge_position = arg_3_2.charge_position
	arg_3_2.action_enter_t = arg_3_3
	arg_3_2.total_distance_ran = 0
	arg_3_2.last_frame_pos = Vector3Box(POSITION_LOOKUP[arg_3_1])

	local var_3_1 = Managers.state.network
	local var_3_2 = var_0_1(var_3_0.start_animation)

	var_3_1:anim_event(arg_3_1, var_3_2)

	arg_3_2.spawn_to_running = nil
	arg_3_2.keep_position_if_interrupted = var_3_0.keep_position_if_interrupted

	arg_3_0:_start_starting(arg_3_1, arg_3_2, arg_3_3)

	local var_3_3 = arg_3_2.navigation_extension
	local var_3_4 = arg_3_2.locomotion_extension

	var_3_4:set_wanted_velocity(Vector3.zero())
	var_3_4:use_lerp_rotation(true)
	var_3_3:reset_destination()
	var_3_3:set_enabled(false)

	arg_3_2.hit_units = {}
	arg_3_2.pushed_units = {}

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	ScriptUnit.extension(arg_3_1, "hit_reaction_system").force_ragdoll_on_death = true
	arg_3_2.old_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table()

	local var_3_5 = arg_3_2.navigation_extension:get_navtag_layer_cost_table("charge")

	if var_3_5 then
		local var_3_6 = arg_3_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(var_3_6, var_3_5)
	end
end

BTChargePositionAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.attack_token = false

	if HEALTH_ALIVE[arg_4_1] then
		local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
		local var_4_1 = arg_4_2.navigation_extension

		var_4_1:set_enabled(true)
		var_4_1:set_max_speed(var_4_0)

		local var_4_2 = arg_4_2.locomotion_extension

		var_4_2:set_rotation_speed(nil)
		var_4_2:use_lerp_rotation(true)

		local var_4_3 = arg_4_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(var_4_3, arg_4_2.old_navtag_layer_cost_table)

		arg_4_2.old_navtag_layer_cost_table = nil
		ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil
	end

	if arg_4_2.stagger and arg_4_2.charge_state == "charging" then
		arg_4_2.charge_stagger = true
	end

	if arg_4_2.action.stick_to_enemy_t then
		arg_4_2.stick_to_enemy_t = arg_4_3 + arg_4_2.action.stick_to_enemy_t
	end

	arg_4_2.action = nil
	arg_4_2.active_node = nil
	arg_4_2.anim_cb_disable_charge_collision = nil
	arg_4_2.attack_aborted = nil
	arg_4_2.cancel_approaching_t = nil
	arg_4_2.charge_started_at_t = nil
	arg_4_2.charge_state = nil
	arg_4_2.current_charge_speed = nil
	arg_4_2.hit_target = nil
	arg_4_2.hit_units = nil
	arg_4_2.pushed_units = nil
	arg_4_2.ray_can_go_to_target = nil
	arg_4_2.ray_can_go_update_time = nil
	arg_4_2.anim_cb_attack_finished = nil

	if not arg_4_2.keep_position_if_interrupted and arg_4_2.requested_charge_position == arg_4_2.charge_position then
		arg_4_2.charge_position = nil
	end

	arg_4_2.requested_charge_position = nil
	arg_4_2.total_distance_ran = nil
	arg_4_2.last_frame_pos = nil
	arg_4_2.action_enter_t = nil
	arg_4_2.distance_to_target_sq = nil
	arg_4_2.charge_start_pos = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)
end

BTChargePositionAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.attack_aborted then
		return "done"
	end

	if not arg_5_2.requested_charge_position then
		return "done"
	end

	if arg_5_3 > arg_5_2.ray_can_go_update_time then
		local var_5_0 = arg_5_2.nav_world
		local var_5_1 = arg_5_2.requested_charge_position:unbox()

		arg_5_2.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(var_5_0, POSITION_LOOKUP[arg_5_1], var_5_1, nil, 1, 1)
		arg_5_2.ray_can_go_update_time = arg_5_3 + 0.25
	end

	local var_5_2 = arg_5_2.charge_state
	local var_5_3

	if var_5_2 == "starting" then
		arg_5_0:_run_starting(arg_5_1, arg_5_2, arg_5_3)
	elseif var_5_2 == "approaching" then
		arg_5_0:_run_approaching(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif var_5_2 == "charging" then
		arg_5_0:_run_charging(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif var_5_2 == "impact" then
		arg_5_0:_run_impact(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif var_5_2 == "finished" then
		return "done"
	elseif var_5_2 == "cancel" then
		arg_5_0:_run_cancel(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	end

	return "running", var_5_3
end

BTChargePositionAction._start_starting = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_2.charge_state = "starting"
end

BTChargePositionAction._start_charging = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.action
	local var_7_1 = Managers.time:time("game")
	local var_7_2 = var_0_1(var_7_0.charge_animation)

	arg_7_2.move_state = "moving"
	arg_7_2.charge_state = "charging"

	Managers.state.network:anim_event(arg_7_1, var_7_2)
	arg_7_2.locomotion_extension:set_rotation_speed(var_7_0.charge_rotation_speed)

	arg_7_2.charge_started_at_t = var_7_1

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_7_1, "incoming_attack", DialogueSettings.special_proximity_distance_heard, "enemy_tag", arg_7_2.breed.name)
end

BTChargePositionAction._start_approaching = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2.action

	arg_8_2.charge_state = "approaching"
	arg_8_2.goal_destination = arg_8_2.requested_charge_position

	local var_8_1 = arg_8_2.navigation_extension
	local var_8_2 = arg_8_2.current_charge_speed or var_8_0.charge_speed_min

	var_8_1:set_enabled(true)
	var_8_1:set_max_speed(var_8_2)
	var_8_1:move_to(arg_8_2.goal_destination:unbox())

	arg_8_2.move_state = "moving"
end

BTChargePositionAction._start_impact = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	local var_9_0 = arg_9_2.action

	arg_9_2.charge_state = "impact"

	local var_9_1 = arg_9_2.locomotion_extension

	arg_9_2.navigation_extension:set_enabled(false)

	if arg_9_4 then
		local var_9_2 = var_9_0.charge_blocked_animation
		local var_9_3 = var_0_1(var_9_2)

		Managers.state.network:anim_event(arg_9_1, var_9_3)
		var_9_1:set_wanted_velocity(Vector3.zero())
		var_9_1:set_rotation_speed(nil)
	elseif arg_9_3 or arg_9_6 then
		local var_9_4 = arg_9_5 and var_9_0.charge_blocked_animation or var_9_0.impact_animation
		local var_9_5 = var_0_1(var_9_4)

		Managers.state.network:anim_event(arg_9_1, var_9_5)

		local var_9_6 = var_9_1:current_velocity()

		var_9_1:set_wanted_velocity(var_9_6 * 0.5)
		var_9_1:set_rotation_speed(nil)
	end

	arg_9_2.hit_target = arg_9_3
	arg_9_2.charge_position = nil
end

BTChargePositionAction._pause_charge = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_2.navigation_extension:set_enabled(false)

	local var_10_0 = var_0_1(arg_10_2.action.cancel_animation)

	Managers.state.network:anim_event(arg_10_1, var_10_0)

	arg_10_2.charge_state = "cancel"

	arg_10_2.locomotion_extension:set_rotation_speed(nil)
end

BTChargePositionAction._cancel_charge = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_0:_pause_charge(arg_11_1, arg_11_2)

	arg_11_2.charge_position = nil
end

BTChargePositionAction._check_unit_and_wall_collision = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_2.action
	local var_12_1 = arg_12_0:_check_overlap(arg_12_1, arg_12_2, var_12_0)

	if var_12_1 then
		arg_12_0:_start_impact(arg_12_1, arg_12_2, true, false, var_12_1)
	end

	if not arg_12_4 and arg_12_0:_check_wall_collision(arg_12_1, arg_12_2, arg_12_3) then
		arg_12_0:_start_impact(arg_12_1, arg_12_2, false, true)
	end
end

local var_0_2 = {}

BTChargePositionAction._check_overlap = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_2.is_illusion then
		return false, false
	end

	local var_13_0 = Managers.time:time("game")
	local var_13_1 = arg_13_3.radius
	local var_13_2 = arg_13_3.head_radius
	local var_13_3 = arg_13_2.hit_units
	local var_13_4 = arg_13_2.pushed_units
	local var_13_5 = Unit.local_position(arg_13_1, 0)
	local var_13_6 = Unit.world_position(arg_13_1, Unit.node(arg_13_1, "j_head"))
	local var_13_7 = Quaternion.forward(Unit.local_rotation(arg_13_1, 0))
	local var_13_8 = arg_13_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_13_0 = 1, #var_13_8 do
		local var_13_9 = var_13_8[iter_13_0]
		local var_13_10 = POSITION_LOOKUP[var_13_9]
		local var_13_11 = Vector3.normalize(var_13_10 - var_13_5)
		local var_13_12 = var_13_10 - var_13_5
		local var_13_13 = Vector3.length(var_13_12)

		if Vector3.dot(var_13_11, var_13_7) > 0 then
			local var_13_14 = ScriptUnit.extension(var_13_9, "status_system")

			if var_13_14 and var_13_14:get_is_dodging() then
				var_13_2 = arg_13_3.target_dodged_radius
			end

			local var_13_15 = var_13_3[var_13_9]
			local var_13_16 = var_13_4[var_13_9]

			if not var_13_15 and var_13_13 < var_13_2 and var_13_14 and not var_13_14:is_invisible() then
				arg_13_0:_hit_player(arg_13_1, arg_13_2, var_13_9, arg_13_3, var_13_11)

				var_13_3[var_13_9] = true
			elseif not var_13_15 and not var_13_16 and var_13_13 < var_13_1 and var_13_14 and not var_13_14:is_invisible() then
				arg_13_0:_push_player(arg_13_1, var_13_9, arg_13_2, arg_13_3)

				var_13_4[var_13_9] = true
			end
		end
	end

	local var_13_17 = arg_13_2.group_blackboard.broadphase
	local var_13_18 = arg_13_3.hit_ai_radius
	local var_13_19 = Broadphase.query(var_13_17, var_13_5, var_13_18, var_0_2)

	for iter_13_1 = 1, var_13_19 do
		local var_13_20 = var_0_2[iter_13_1]
		local var_13_21 = POSITION_LOOKUP[var_13_20]
		local var_13_22 = Vector3.normalize(var_13_21 - var_13_5)

		if Vector3.dot(var_13_22, var_13_7) > 0 and var_13_20 ~= arg_13_1 and not var_13_3[var_13_20] then
			arg_13_0:_hit_ai(arg_13_1, var_13_20, arg_13_3, arg_13_2, var_13_0)
		end

		var_13_3[var_13_20] = true
		var_0_2[iter_13_1] = nil
	end

	return var_13_3[arg_13_2.target_unit]
end

BTChargePositionAction._charged_at_player = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	return
end

BTChargePositionAction._push_player = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = POSITION_LOOKUP[arg_15_2] - POSITION_LOOKUP[arg_15_1]
	local var_15_1 = arg_15_4.dodge_past_push_speed * Vector3.normalize(var_15_0)

	Vector3.set_z(var_15_1, 3)
	StatusUtils.set_catapulted_network(arg_15_2, true, var_15_1)
end

BTChargePositionAction._hit_player = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = ScriptUnit.has_extension(arg_16_3, "status_system")
	local var_16_1 = DamageUtils.check_block(arg_16_1, arg_16_3, arg_16_4.fatigue_type)
	local var_16_2 = DamageUtils.check_ranged_block(arg_16_1, arg_16_3, arg_16_4.shield_blocked_fatigue_type or "ogre_shove")

	if not var_16_2 and not var_16_1 then
		AiUtils.damage_target(arg_16_3, arg_16_1, arg_16_4, arg_16_4.damage)
	end

	if arg_16_4.player_push_speed and not var_16_0.knocked_down then
		if not var_16_2 then
			arg_16_0:_charged_at_player(arg_16_1, arg_16_3, arg_16_2, arg_16_4)
		else
			arg_16_0:_push_player(arg_16_1, arg_16_3, arg_16_2, arg_16_4, var_16_2 or var_16_1)
		end
	end

	return var_16_1
end

BTChargePositionAction._hit_ai = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	local var_17_0 = arg_17_3.push_ai
	local var_17_1 = BLACKBOARDS[arg_17_2]
	local var_17_2 = var_17_1.breed and var_17_1.breed.name

	if Managers.state.side.side_by_unit[arg_17_1] == Managers.state.side.side_by_unit[arg_17_2] then
		return
	end

	if var_17_0 then
		local var_17_3, var_17_4 = DamageUtils.calculate_stagger(var_17_0.stagger_impact, var_17_0.stagger_duration, arg_17_2, arg_17_1)

		if var_17_3 > var_0_0.none then
			local var_17_5 = POSITION_LOOKUP[arg_17_1]
			local var_17_6 = POSITION_LOOKUP[arg_17_2]
			local var_17_7 = Vector3.normalize(var_17_6 - var_17_5)
			local var_17_8 = Unit.local_rotation(arg_17_1, 0)
			local var_17_9 = Quaternion.right(var_17_8)
			local var_17_10 = Quaternion.forward(var_17_8)
			local var_17_11 = Vector3.dot(var_17_9, var_17_7)
			local var_17_12 = -var_17_9

			if var_17_11 > 0 then
				var_17_12 = -var_17_12
			end

			local var_17_13 = Vector3.normalize(var_17_12 + var_17_10)

			AiUtils.stagger(arg_17_2, var_17_1, arg_17_1, var_17_13, var_17_0.stagger_distance, var_17_3, var_17_4, nil, arg_17_5, nil, nil, nil, true)

			if var_17_2 == "chaos_warrior" and (arg_17_4.breed and arg_17_4.breed.name) == "beastmen_bestigor" then
				local var_17_14 = "scorpion_bestigor_charge_chaos_warrior"
				local var_17_15 = NetworkLookup.statistics[var_17_14]
				local var_17_16 = Managers.player:statistics_db()
				local var_17_17 = Managers.player:local_player():stats_id()

				var_17_16:increment_stat(var_17_17, var_17_14)
				Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_17_15)
			end
		end
	end

	if not arg_17_3.ignore_ai_damage then
		AiUtils.damage_target(arg_17_2, arg_17_1, arg_17_3, arg_17_3.damage)
	end

	AiUtils.alert_nearby_friends_of_enemy(arg_17_1, arg_17_4.group_blackboard.broadphase, arg_17_2)
end

BTChargePositionAction._check_wall_collision = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_2.action.wall_collision_check_range
	local var_18_1 = 1
	local var_18_2 = 1
	local var_18_3 = arg_18_2.nav_world
	local var_18_4 = POSITION_LOOKUP[arg_18_1]
	local var_18_5, var_18_6 = GwNavQueries.triangle_from_position(var_18_3, var_18_4, var_18_1, var_18_2)

	if not var_18_5 then
		return true
	end

	local var_18_7 = arg_18_2.locomotion_extension:current_velocity()
	local var_18_8 = Vector3.length(var_18_7)
	local var_18_9

	if var_18_8 > 0.01 then
		var_18_9 = Vector3.normalize(var_18_7)
	else
		local var_18_10 = Unit.local_rotation(arg_18_1, 0)

		var_18_9 = Quaternion.forward(var_18_10)
	end

	local var_18_11 = var_18_4 + var_18_9 * (var_18_0 + arg_18_3 * var_18_8)
	local var_18_12, var_18_13 = GwNavQueries.triangle_from_position(var_18_3, var_18_11, var_18_1, var_18_2)

	if not var_18_12 then
		if not arg_18_2.action.ignore_ledge_death and arg_18_0:_is_at_edge(arg_18_1, arg_18_2, var_18_4, var_18_9) then
			local var_18_14 = "charge_death"

			AiUtils.kill_unit(arg_18_1, arg_18_1, "torso", var_18_14, Vector3.normalize(var_18_7))

			arg_18_2.charge_state = "finished"

			return false
		end

		return true
	end

	local var_18_15 = Vector3(var_18_4.x, var_18_4.y, var_18_6)
	local var_18_16 = Vector3(var_18_11.x, var_18_11.y, var_18_13)
	local var_18_17 = arg_18_2.navigation_extension:traverse_logic()

	return not GwNavQueries.raycango(var_18_3, var_18_15, var_18_16, var_18_17)
end

BTChargePositionAction._is_at_edge = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = World.get_data(arg_19_2.world, "physics_world")
	local var_19_1 = arg_19_3 + Vector3(0, 0, 1)
	local var_19_2 = 4
	local var_19_3 = var_19_1 + arg_19_4 * var_19_2
	local var_19_4 = var_19_3 - var_19_1

	if PhysicsWorld.raycast(var_19_0, var_19_1, var_19_4, var_19_2, "closest", "collision_filter", "filter_ai_line_of_sight_check") then
		return false
	end

	local var_19_5 = var_19_3
	local var_19_6 = 4
	local var_19_7 = var_19_3 + -Vector3.up() * var_19_6 - var_19_5

	if not PhysicsWorld.raycast(var_19_0, var_19_5, var_19_7, var_19_6, "closest", "collision_filter", "filter_ai_line_of_sight_check") then
		return true
	end
end

BTChargePositionAction._check_smartobjects = function (arg_20_0, arg_20_1, arg_20_2)
	if BTConditions.at_smartobject(arg_20_2) then
		if BTConditions.at_door_smartobject(arg_20_2) then
			local var_20_0 = arg_20_2.next_smart_object_data.smart_object_data.unit

			if Unit.alive(var_20_0) then
				AiUtils.kill_unit(var_20_0, arg_20_1)
			end
		else
			arg_20_0:_pause_charge(arg_20_1, arg_20_2)
		end
	end
end

BTChargePositionAction._run_starting = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_2.requested_charge_position:unbox()
	local var_21_1 = LocomotionUtils.look_at_position_flat(arg_21_1, var_21_0)

	arg_21_2.locomotion_extension:set_wanted_rotation(var_21_1)
end

BTChargePositionAction._run_approaching = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = arg_22_2.navigation_extension

	if arg_22_2.no_path_found then
		if not arg_22_2.cancel_approaching_t then
			arg_22_2.cancel_approaching_t = arg_22_3 + 2
		elseif arg_22_3 > arg_22_2.cancel_approaching_t then
			arg_22_0:_cancel_charge(arg_22_1, arg_22_2)

			return
		end
	else
		arg_22_2.cancel_approaching_t = nil
	end

	if arg_22_2.ray_can_go_to_target then
		var_22_0:set_enabled(false)
		arg_22_0:_start_charging(arg_22_1, arg_22_2)

		return
	end

	local var_22_1 = arg_22_2.requested_charge_position:unbox()

	var_22_0:move_to(var_22_1)

	local var_22_2 = arg_22_2.action

	arg_22_0:_check_overlap(arg_22_1, arg_22_2, var_22_2)
	arg_22_0:_check_smartobjects(arg_22_1, arg_22_2)
	arg_22_0:_update_animation_movement_speed(arg_22_1, arg_22_2, arg_22_4)

	local var_22_3 = arg_22_2.locomotion_extension:current_velocity()
	local var_22_4 = Quaternion.look(var_22_3)

	arg_22_2.locomotion_extension:set_wanted_rotation(var_22_4)

	local var_22_5 = 4
	local var_22_6, var_22_7 = var_22_0:get_current_and_node_position_in_nav_path(var_22_5)

	if var_22_6 == nil or var_22_7 == nil then
		return
	end

	local var_22_8 = Vector3.normalize(var_22_7 - var_22_6)
	local var_22_9 = arg_22_0:_get_turn_slowdown_percentage(arg_22_1, arg_22_2, arg_22_4, var_22_8)

	if var_22_9 then
		local var_22_10 = arg_22_2.action.charge_speed_min * var_22_9

		var_22_0:set_max_speed(var_22_10)
	end

	if arg_22_3 - arg_22_2.action_enter_t > var_22_2.max_charge_t then
		arg_22_0:_cancel_charge(arg_22_1, arg_22_2)

		return
	end

	local var_22_11 = POSITION_LOOKUP[arg_22_1]
	local var_22_12 = arg_22_2.last_frame_pos:unbox()
	local var_22_13 = Vector3.distance(var_22_11, var_22_12)

	arg_22_2.total_distance_ran = arg_22_2.total_distance_ran + var_22_13

	arg_22_2.last_frame_pos:store(var_22_11)

	if arg_22_2.total_distance_ran > var_22_2.max_charge_distance then
		arg_22_0:_cancel_charge(arg_22_1, arg_22_2)

		return
	end
end

BTChargePositionAction._run_charging = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	if arg_23_2.requested_charge_position ~= arg_23_2.charge_position then
		arg_23_0:_pause_charge(arg_23_1, arg_23_2)

		return
	end

	if not arg_23_2.ray_can_go_to_target then
		arg_23_0:_start_approaching(arg_23_1, arg_23_2)

		return
	end

	local var_23_0 = arg_23_2.action

	if var_23_0.allow_target_unit_override and arg_23_2.using_override_target and ALIVE[arg_23_2.target_unit] then
		arg_23_2.requested_charge_position:store(POSITION_LOOKUP[arg_23_2.target_unit])
	end

	local var_23_1 = arg_23_2.requested_charge_position:unbox()
	local var_23_2 = arg_23_2.navigation_extension

	var_23_2:move_to(var_23_1)

	local var_23_3 = arg_23_2.locomotion_extension
	local var_23_4 = LocomotionUtils.look_at_position_flat(arg_23_1, var_23_1)

	var_23_3:set_wanted_rotation(var_23_4)

	local var_23_5 = arg_23_3 - arg_23_2.charge_started_at_t
	local var_23_6 = var_23_0.charge_speed_min
	local var_23_7 = var_23_0.charge_speed_max
	local var_23_8 = var_23_5 / var_23_0.charge_max_speed_at
	local var_23_9 = math.min(var_23_6 + var_23_8 * (var_23_7 - var_23_6), var_23_7)
	local var_23_10 = Quaternion.forward(Unit.local_rotation(arg_23_1, 0)) * var_23_9

	var_23_3:set_wanted_velocity(var_23_10)
	var_23_2:set_max_speed(var_23_9)

	arg_23_2.current_charge_speed = var_23_9

	arg_23_0:_check_unit_and_wall_collision(arg_23_1, arg_23_2, arg_23_4, false)
	arg_23_0:_update_animation_movement_speed(arg_23_1, arg_23_2, arg_23_4)
	arg_23_0:_check_smartobjects(arg_23_1, arg_23_2)

	if arg_23_3 - arg_23_2.action_enter_t > var_23_0.max_charge_t then
		arg_23_0:_cancel_charge(arg_23_1, arg_23_2)

		return
	end

	local var_23_11 = POSITION_LOOKUP[arg_23_1]
	local var_23_12 = arg_23_2.last_frame_pos:unbox()

	if not var_23_0.allow_target_unit_override or not arg_23_2.using_override_target or not ALIVE[arg_23_2.target_unit] then
		local var_23_13 = arg_23_2.distance_to_target_sq or Vector3.distance_squared(var_23_1, var_23_11)
		local var_23_14 = arg_23_2.charge_start_pos or Vector3Box(var_23_11)

		if var_23_13 < Vector3.distance_squared(var_23_14:unbox(), var_23_11) then
			arg_23_0:_cancel_charge(arg_23_1, arg_23_2)

			return
		end

		arg_23_2.distance_to_target_sq = var_23_13
		arg_23_2.charge_start_pos = var_23_14
	else
		arg_23_2.distance_to_target_sq = nil
		arg_23_2.charge_start_pos = nil
	end

	local var_23_15 = var_23_11 - var_23_12
	local var_23_16 = Vector3.length(var_23_15)

	arg_23_2.total_distance_ran = arg_23_2.total_distance_ran + var_23_16

	arg_23_2.last_frame_pos:store(var_23_11)

	if arg_23_2.total_distance_ran > var_23_0.max_charge_distance then
		arg_23_0:_cancel_charge(arg_23_1, arg_23_2)

		return
	end
end

BTChargePositionAction._run_impact = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_2.hit_target and arg_24_2.action.hit_target_slow_down_speed or arg_24_2.action.slow_down_speed

	arg_24_0:_slow_down(arg_24_1, arg_24_2, var_24_0, arg_24_3, arg_24_4)

	if arg_24_2.anim_cb_attack_finished then
		arg_24_2.charge_state = "finished"
	end
end

BTChargePositionAction._run_cancel = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = arg_25_2.action.cancel_slow_down_speed

	arg_25_0:_slow_down(arg_25_1, arg_25_2, var_25_0, arg_25_3, arg_25_4)

	if arg_25_2.anim_cb_attack_finished then
		arg_25_2.charge_state = "finished"
	end
end

BTChargePositionAction._slow_down = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	local var_26_0 = arg_26_2.locomotion_extension
	local var_26_1 = var_26_0:current_velocity()
	local var_26_2 = Vector3.zero()
	local var_26_3 = math.min(arg_26_5 * arg_26_3, 1)
	local var_26_4 = Vector3.lerp(var_26_1, var_26_2, var_26_3)

	var_26_0:set_wanted_velocity(var_26_4)
end

BTChargePositionAction._update_animation_movement_speed = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_2.locomotion_extension:current_velocity()
	local var_27_1 = Vector3.length(var_27_0)
	local var_27_2 = Unit.animation_find_variable(arg_27_1, "move_speed")

	Unit.animation_set_variable(arg_27_1, var_27_2, var_27_1)
end

BTChargePositionAction._get_turn_slowdown_percentage = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_2.action
	local var_28_1 = Unit.local_rotation(arg_28_1, 0)
	local var_28_2 = Quaternion.forward(var_28_1)
	local var_28_3 = Vector3.dot(var_28_2, arg_28_4)
	local var_28_4 = math.radians_to_degrees(math.acos(var_28_3))
	local var_28_5 = var_28_0.min_slowdown_angle
	local var_28_6 = var_28_0.max_slowdown_angle

	if var_28_3 > 1 or var_28_4 <= var_28_5 then
		return
	end

	return 1 - math.min((var_28_4 - var_28_5) / var_28_6, 1) * var_28_0.max_slowdown_percentage
end

BTChargePositionAction.anim_cb_charge_start_finished = function (arg_29_0, arg_29_1, arg_29_2)
	arg_29_0:_start_charging(arg_29_1, arg_29_2)
end

BTChargePositionAction.anim_cb_charge_charging_finished = function (arg_30_0, arg_30_1, arg_30_2)
	if arg_30_2.charge_state == "charging" then
		arg_30_0:_start_impact(arg_30_1, arg_30_2)
	end
end

BTChargePositionAction.anim_cb_disable_charge_collision = function (arg_31_0, arg_31_1, arg_31_2)
	arg_31_2.anim_cb_disable_charge_collision = true
end

BTChargePositionAction.anim_cb_attack_finished = function (arg_32_0, arg_32_1, arg_32_2)
	arg_32_2.anim_cb_attack_finished = true
end
