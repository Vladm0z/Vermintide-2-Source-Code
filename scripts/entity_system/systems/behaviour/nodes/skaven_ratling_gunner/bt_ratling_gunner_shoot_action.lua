-- chunkname: @scripts/entity_system/systems/behaviour/nodes/skaven_ratling_gunner/bt_ratling_gunner_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatlingGunnerShootAction = class(BTRatlingGunnerShootAction, BTNode)

local var_0_0 = math.pi
local var_0_1 = var_0_0 * 2
local var_0_2 = 0.25

CLIENT_CONTROLLED_RATLING_GUN = true

function BTRatlingGunnerShootAction.init(arg_1_0, ...)
	BTRatlingGunnerShootAction.super.init(arg_1_0, ...)
end

BTRatlingGunnerShootAction.name = "BTRatlingGunnerShootAction"

function BTRatlingGunnerShootAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.attack_pattern_data or {}
	local var_2_2, var_2_3, var_2_4 = PerceptionUtils.pick_ratling_gun_target(arg_2_1, arg_2_2)
	local var_2_5 = var_2_2 or var_2_1.target_unit

	arg_2_2.action = var_2_0
	var_2_1.target_unit = var_2_5
	var_2_1.target_node_name = var_2_3 or var_2_1.target_node_name

	if not Unit.alive(var_2_5) then
		return
	end

	var_2_1.shoot_start = nil
	var_2_1.shots_fired = nil
	var_2_1.time_between_shots_at_start = 1 / var_2_0.fire_rate_at_start
	var_2_1.time_between_shots_at_end = 1 / var_2_0.fire_rate_at_end
	var_2_1.max_fire_rate_at_percentage_modifier = 1 / var_2_0.max_fire_rate_at_percentage
	var_2_1.target_switch_distance_squared = AiUtils.random(var_2_0.target_switch_distance[1], var_2_0.target_switch_distance[2])^2
	var_2_1.target_obscured = false
	var_2_1.target_check = arg_2_3 + 0.2 + Math.random() * 0.1
	var_2_1.peer_id = var_2_1.peer_id or Network.peer_id()
	var_2_1.update_bot_threat_t = arg_2_3
	arg_2_0._use_obstacle = false

	if arg_2_0._use_obstacle then
		local var_2_6, var_2_7 = arg_2_0:_create_nav_obstacles(arg_2_1, var_2_5, arg_2_2.nav_world, var_2_0)

		var_2_1.line_of_fire_nav_obstacle = var_2_6
		var_2_1.arc_of_sight_nav_obstacle = var_2_7
	end

	arg_2_2.first_shots_fired = true
	arg_2_2.attack_pattern_data = var_2_1

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	var_2_1.shoot_direction_box = Vector3Box(Quaternion.forward(Unit.world_rotation(arg_2_1, Unit.node(arg_2_1, "c_spine"))))

	arg_2_0:_start_align_towards_target(arg_2_1, arg_2_2, var_2_1, var_2_5, arg_2_3)
	arg_2_2.locomotion_extension:use_lerp_rotation(false)
	arg_2_0:_notify_attacking(arg_2_1, var_2_5)
end

function BTRatlingGunnerShootAction._create_nav_obstacles(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = POSITION_LOOKUP[arg_3_1]
	local var_3_1 = POSITION_LOOKUP[arg_3_2]
	local var_3_2 = Vector3(0, 0, 0)
	local var_3_3 = arg_3_4.line_of_fire_nav_obstacle_half_extents:unbox()
	local var_3_4 = arg_3_4.arc_of_sight_nav_obstacle_half_extents:unbox()
	local var_3_5 = false
	local var_3_6 = Color(255, 0, 0)
	local var_3_7 = LAYER_ID_MAPPING[arg_3_4.nav_obstacle_layer_name]
	local var_3_8 = GwNavBoxObstacle.create(arg_3_3, var_3_0, var_3_2, var_3_3, var_3_5, var_3_6, var_3_7)
	local var_3_9 = GwNavBoxObstacle.create(arg_3_3, var_3_0, var_3_2, var_3_4, var_3_5, var_3_6, var_3_7)

	return var_3_8, var_3_9
end

function BTRatlingGunnerShootAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.anim_cb_attack_shoot_start_finished = nil
	arg_4_2.anim_cb_attack_shoot_random_shot = nil

	Managers.state.debug:drawer({
		mode = "retained",
		name = "BTRatlingGunnerShootAction"
	}):reset()

	local var_4_0 = arg_4_2.attack_pattern_data

	var_4_0.shoot_direction_box = nil
	var_4_0.aim_position_box = nil
	var_4_0.current_aim_rotation = nil
	var_4_0.shoot_duration = nil
	var_4_0.shoot_start = nil
	var_4_0.shots_fired = nil
	var_4_0.time_between_shots_at_start = nil
	var_4_0.time_between_shots_at_end = nil
	var_4_0.max_fire_rate_at_percentage_modifier = nil
	var_4_0.target_switch_distance_squared = nil
	var_4_0.target_obscured = nil
	var_4_0.last_known_target_position = nil
	var_4_0.last_known_unit_position = nil
	var_4_0.last_fired = arg_4_3

	if var_4_0.is_shooting then
		arg_4_0:stop_shooting(arg_4_1, var_4_0)
	end

	if arg_4_0._use_obstacle and var_4_0.line_of_fire_nav_obstacle and var_4_0.arc_of_sight_nav_obstacle then
		GwNavBoxObstacle.destroy(var_4_0.line_of_fire_nav_obstacle)
		GwNavBoxObstacle.destroy(var_4_0.arc_of_sight_nav_obstacle)

		var_4_0.line_of_fire_nav_obstacle = nil
		var_4_0.arc_of_sight_nav_obstacle = nil
	end

	arg_4_0:_notify_no_longer_attacking(arg_4_1, var_4_0.target_unit)

	if not arg_4_5 then
		arg_4_2.locomotion_extension:use_lerp_rotation(true)
	end

	arg_4_2.navigation_extension:set_enabled(true)
end

function BTRatlingGunnerShootAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.attack_pattern_data
	local var_5_1 = var_5_0.target_unit

	if not HEALTH_ALIVE[var_5_1] then
		return "done"
	end

	if var_5_0.state == "align" then
		if arg_5_0:_update_target(arg_5_1, arg_5_2, arg_5_0._tree_node.action_data, var_5_0, arg_5_3, arg_5_4) then
			arg_5_0:_start_align_towards_target(arg_5_1, arg_5_2, var_5_0, var_5_0.target_unit, arg_5_3)
		end

		if arg_5_0:_update_align_towards_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4) and not script_data.disable_ratling_gun_fire then
			arg_5_0:_end_align_towards_target(arg_5_1, var_5_0)
		end

		return "running"
	elseif var_5_0.state == "ready" then
		local var_5_2 = arg_5_0:_aim_at_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		local var_5_3 = arg_5_0:_update_target(arg_5_1, arg_5_2, arg_5_0._tree_node.action_data, var_5_0, arg_5_3, arg_5_4)

		if var_5_2 or var_5_3 then
			arg_5_0:_start_align_towards_target(arg_5_1, arg_5_2, var_5_0, var_5_0.target_unit, arg_5_3)

			return "running"
		end

		if arg_5_2.anim_cb_attack_shoot_random_shot then
			arg_5_0:_start_shooting(arg_5_2, arg_5_1, var_5_0, arg_5_3)
		end

		return "running"
	elseif var_5_0.state == "shoot" then
		if arg_5_0:_update_target(arg_5_1, arg_5_2, arg_5_0._tree_node.action_data, var_5_0, arg_5_3, arg_5_4) then
			arg_5_0:stop_shooting(arg_5_1, var_5_0)
			arg_5_0:_start_align_towards_target(arg_5_1, arg_5_2, var_5_0, var_5_0.target_unit, arg_5_3)

			return "running"
		end

		if arg_5_0:_aim_at_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4) then
			arg_5_0:stop_shooting(arg_5_1, var_5_0)
			arg_5_0:_start_align_towards_target(arg_5_1, arg_5_2, var_5_0, var_5_0.target_unit, arg_5_3)

			return "running"
		end

		arg_5_0:_update_shooting(arg_5_1, arg_5_2, var_5_0, arg_5_3, arg_5_4)

		if arg_5_3 > var_5_0.shoot_start + var_5_0.shoot_duration then
			return "done"
		end

		return "running"
	end
end

function BTRatlingGunnerShootAction._notify_attacking(arg_6_0, arg_6_1, arg_6_2)
	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_6_1, arg_6_2, "ratling_gun_fire")

	if Unit.alive(arg_6_2) then
		ScriptUnit.extension(arg_6_2, "status_system").under_ratling_gunner_attack = true
	end
end

function BTRatlingGunnerShootAction._notify_no_longer_attacking(arg_7_0, arg_7_1, arg_7_2)
	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_7_1, arg_7_2, "ratling_gun_fire")

	if Unit.alive(arg_7_2) then
		ScriptUnit.extension(arg_7_2, "status_system").under_ratling_gunner_attack = false
	end
end

function BTRatlingGunnerShootAction.stop_shooting(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2.is_shooting = nil

	local var_8_0 = Managers.state.unit_storage:go_id(arg_8_1)

	Managers.state.network.network_transmit:send_rpc_clients("rpc_ai_weapon_shoot_end", var_8_0)
	Managers.state.entity:system("weapon_system"):rpc_ai_weapon_shoot_end(Network.peer_id(), var_8_0)

	if arg_8_0._use_obstacle then
		GwNavBoxObstacle.remove_from_world(arg_8_2.line_of_fire_nav_obstacle)
		GwNavBoxObstacle.remove_from_world(arg_8_2.arc_of_sight_nav_obstacle)
	end

	if CLIENT_CONTROLLED_RATLING_GUN then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_clients_continuous_shoot_stop", var_8_0)
	end
end

function BTRatlingGunnerShootAction._update_shooting(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_4 - arg_9_3.shoot_start
	local var_9_1 = math.clamp(var_9_0 / arg_9_3.shoot_duration * arg_9_3.max_fire_rate_at_percentage_modifier, 0, 1)
	local var_9_2 = math.lerp(arg_9_3.time_between_shots_at_start, arg_9_3.time_between_shots_at_end, var_9_1)
	local var_9_3 = math.floor(var_9_0 / var_9_2) + 1 - arg_9_3.shots_fired

	for iter_9_0 = 1, var_9_3 do
		arg_9_3.shots_fired = arg_9_3.shots_fired + 1

		arg_9_0:_shoot(arg_9_1, arg_9_2, arg_9_4, arg_9_5)
	end

	if arg_9_4 > arg_9_3.update_bot_threat_t then
		arg_9_0:_create_bot_threat_box(arg_9_1, arg_9_3, var_0_2, arg_9_2, arg_9_3)

		arg_9_3.update_bot_threat_t = arg_9_4 + var_0_2
	end

	if arg_9_0._use_obstacle then
		local var_9_4 = arg_9_2.action.line_of_fire_nav_obstacle_half_extents:unbox()
		local var_9_5 = arg_9_2.action.arc_of_sight_nav_obstacle_half_extents:unbox()
		local var_9_6, var_9_7 = arg_9_0:_fire_from_position_direction(arg_9_2, arg_9_3)
		local var_9_8 = Vector3.normalize(var_9_7)
		local var_9_9 = var_9_6 + var_9_8 * var_9_4.y
		local var_9_10 = var_9_6 + var_9_8 * var_9_5.y
		local var_9_11 = Quaternion.look(var_9_8, Vector3.up())
		local var_9_12 = Matrix4x4.from_quaternion_position(var_9_11, var_9_9)
		local var_9_13 = Matrix4x4.from_quaternion_position(var_9_11, var_9_10)

		arg_9_0.last_t = arg_9_0.last_t or arg_9_4

		local var_9_14 = arg_9_3.line_of_fire_nav_obstacle
		local var_9_15 = arg_9_3.arc_of_sight_nav_obstacle

		if arg_9_4 > arg_9_0.last_t + 1 then
			GwNavBoxObstacle.set_does_trigger_tagvolume(var_9_14, false)
			GwNavBoxObstacle.remove_from_world(var_9_14)
			GwNavBoxObstacle.set_transform(var_9_14, var_9_12)
			GwNavBoxObstacle.add_to_world(var_9_14)
			GwNavBoxObstacle.set_does_trigger_tagvolume(var_9_14, true)
			GwNavBoxObstacle.set_does_trigger_tagvolume(var_9_15, false)
			GwNavBoxObstacle.remove_from_world(var_9_15)
			GwNavBoxObstacle.set_transform(var_9_15, var_9_13)
			GwNavBoxObstacle.add_to_world(var_9_15)
			GwNavBoxObstacle.set_does_trigger_tagvolume(var_9_15, true)

			arg_9_0.last_t = arg_9_4
		end
	end
end

function BTRatlingGunnerShootAction._start_shooting(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = math.round(arg_10_3.shoot_duration * 100)
	local var_10_1 = Managers.state.unit_storage:go_id(arg_10_2)

	Managers.state.network.network_transmit:send_rpc_clients("rpc_ai_weapon_shoot_start", var_10_1, var_10_0)
	Managers.state.entity:system("weapon_system"):rpc_ai_weapon_shoot_start(Network.peer_id(), var_10_1, var_10_0)

	arg_10_3.is_shooting = true
	arg_10_3.shoot_start = arg_10_4
	arg_10_3.shots_fired = 0
	arg_10_3.state = "shoot"

	Managers.state.entity:system("dialogue_system"):trigger_targeted_by_ratling(arg_10_3.target_unit)

	if arg_10_0._use_obstacle then
		local var_10_2 = arg_10_3.line_of_fire_nav_obstacle

		GwNavBoxObstacle.add_to_world(var_10_2)

		local var_10_3 = arg_10_3.arc_of_sight_nav_obstacle

		GwNavBoxObstacle.add_to_world(var_10_3)

		local var_10_4 = arg_10_1.action.line_of_fire_nav_obstacle_half_extents:unbox()
		local var_10_5 = arg_10_1.action.arc_of_sight_nav_obstacle_half_extents:unbox()
		local var_10_6, var_10_7 = arg_10_0:_fire_from_position_direction(arg_10_1, arg_10_3)
		local var_10_8 = Vector3.normalize(var_10_7)
		local var_10_9 = var_10_6 + var_10_8 * var_10_4.y
		local var_10_10 = var_10_6 + var_10_8 * var_10_5.y
		local var_10_11 = Quaternion.look(var_10_8, Vector3.up())
		local var_10_12 = Matrix4x4.from_quaternion_position(var_10_11, var_10_9)
		local var_10_13 = Matrix4x4.from_quaternion_position(var_10_11, var_10_10)

		GwNavBoxObstacle.set_transform(var_10_2, var_10_12)
		GwNavBoxObstacle.set_transform(var_10_3, var_10_13)
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_10_2, true)
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_10_3, true)
	end

	if CLIENT_CONTROLLED_RATLING_GUN then
		local var_10_14 = arg_10_1.action
		local var_10_15 = arg_10_1.breed.name
		local var_10_16 = NetworkLookup.breeds[var_10_15]
		local var_10_17 = arg_10_3.shoot_duration
		local var_10_18 = arg_10_1.action.name
		local var_10_19 = NetworkLookup.bt_action_names[var_10_18]
		local var_10_20, var_10_21 = Managers.state.network:game_object_or_level_id(arg_10_2)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_clients_continuous_shoot_start", var_10_20, var_10_21, var_10_16, var_10_19, var_10_17, arg_10_3.peer_id)
	end
end

local var_0_3 = 0.7071067

function BTRatlingGunnerShootAction._update_target(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	local var_11_0 = false

	if arg_11_5 > arg_11_4.target_check then
		local var_11_1 = arg_11_4.target_unit
		local var_11_2, var_11_3, var_11_4, var_11_5, var_11_6, var_11_7 = PerceptionUtils.pick_ratling_gun_target(arg_11_1, arg_11_2, var_11_1, var_0_3, arg_11_4.shoot_direction_box:unbox())

		if var_11_2 and var_11_2 ~= var_11_1 then
			local var_11_8 = POSITION_LOOKUP[var_11_2]
			local var_11_9 = POSITION_LOOKUP[arg_11_4.target_unit]
			local var_11_10 = POSITION_LOOKUP[arg_11_1]
			local var_11_11 = arg_11_4.target_switch_distance_squared

			if var_11_2 == arg_11_2.taunt_unit or var_11_6 < var_11_11 and var_11_11 < var_11_7 then
				arg_11_4.target_unit = var_11_2
				arg_11_4.target_node_name = var_11_3
				arg_11_4.target_obscured = false
				var_11_0 = true

				arg_11_0:_notify_no_longer_attacking(arg_11_1, var_11_1)
				arg_11_0:_notify_attacking(arg_11_1, var_11_2)

				arg_11_4.target_check = arg_11_5 + 0.1 + Math.random() * 0.05
			elseif var_11_4 then
				arg_11_4.target_obscured = false
				arg_11_4.target_node_name = var_11_5
				arg_11_4.target_check = arg_11_5 + 0.1 + Math.random() * 0.05
			else
				arg_11_4.target_check = arg_11_5 + 0.5 + Math.random() * 0.25
				arg_11_4.target_obscured = true
			end
		elseif var_11_4 then
			arg_11_4.target_obscured = false
			arg_11_4.target_node_name = var_11_5
			arg_11_4.target_check = arg_11_5 + 0.1 + Math.random() * 0.05
		else
			arg_11_4.target_obscured = true
			arg_11_4.target_check = arg_11_5 + 0.5 + Math.random() * 0.25
		end

		if not arg_11_4.target_obscured then
			local var_11_12 = arg_11_4.target_unit

			arg_11_4.last_known_target_position:store(Unit.world_position(var_11_12, Unit.node(var_11_12, arg_11_4.target_node_name)))
			arg_11_4.last_known_unit_position:store(Unit.world_position(arg_11_1, Unit.node(arg_11_1, "c_spine")))
		end
	end

	return var_11_0
end

function BTRatlingGunnerShootAction._calculate_wanted_target_position(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0
	local var_12_1
	local var_12_2 = arg_12_3.target_obscured

	if arg_12_3.target_obscured then
		var_12_0 = arg_12_3.last_known_target_position:unbox()
		var_12_1 = arg_12_3.last_known_unit_position:unbox()
	else
		var_12_0 = Unit.world_position(arg_12_2, Unit.node(arg_12_2, arg_12_3.target_node_name))
		var_12_1 = Unit.world_position(arg_12_1, Unit.node(arg_12_1, "c_spine"))
	end

	local var_12_3 = LocomotionUtils.look_at_position_flat(arg_12_1, var_12_0)

	return var_12_0, var_12_3, var_12_1
end

function BTRatlingGunnerShootAction._start_align_towards_target(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	arg_13_3.state = "align"

	local var_13_0 = arg_13_3.shoot_direction_box:unbox()
	local var_13_1, var_13_2, var_13_3 = arg_13_0:_calculate_wanted_target_position(arg_13_1, arg_13_4, arg_13_3)
	local var_13_4 = Vector3.normalize(Vector3.flat(var_13_0))
	local var_13_5 = Vector3.normalize(Vector3.flat(var_13_1 - var_13_3))
	local var_13_6 = Vector3.flat_angle(var_13_4, var_13_5)
	local var_13_7 = arg_13_2.action

	arg_13_3.align_start = arg_13_5
	arg_13_3.shoot_direction_start_box = Vector3Box(var_13_0)
	arg_13_3.shoot_duration = AiUtils.random(var_13_7.attack_time[1], var_13_7.attack_time[2])
	arg_13_3.align_speed = 0
	arg_13_3.aim_position_box = nil
	arg_13_3.current_aim_rotation = nil
	arg_13_2.anim_cb_attack_shoot_random_shot = nil

	Managers.state.network:anim_event(arg_13_1, "attack_shoot_align")
end

function BTRatlingGunnerShootAction._end_align_towards_target(arg_14_0, arg_14_1, arg_14_2)
	arg_14_2.state = "ready"
	arg_14_2.align_start = nil
	arg_14_2.shoot_direction_start = nil
	arg_14_2.align_speed = nil
	arg_14_2.aim_position_box = Vector3Box()
	arg_14_2.current_aim_rotation = QuaternionBox(Quaternion.look(arg_14_2.shoot_direction_box:unbox(), Vector3.up()))

	Managers.state.network:anim_event(arg_14_1, "attack_shoot_start")
end

local var_0_4 = 5
local var_0_5 = 1
local var_0_6 = var_0_5 * 0.5
local var_0_7 = var_0_0 / 12
local var_0_8 = var_0_0 * 12
local var_0_9 = var_0_0 * 6
local var_0_10 = var_0_0 / 32
local var_0_11 = 0.7

function BTRatlingGunnerShootAction._update_align_towards_target(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_2.attack_pattern_data
	local var_15_1 = arg_15_2.action
	local var_15_2 = var_15_0.target_unit
	local var_15_3, var_15_4, var_15_5 = arg_15_0:_calculate_wanted_target_position(arg_15_1, var_15_2, var_15_0)
	local var_15_6 = Unit.local_rotation(arg_15_1, 0)
	local var_15_7 = var_15_0.align_speed
	local var_15_8 = arg_15_0:_remaining_angle(var_15_6, var_15_4)
	local var_15_9 = arg_15_0:_angle_to_speed(var_15_8)

	if var_15_9 == 0 and var_15_7 > 0 then
		var_15_7 = math.max(var_15_7 - var_0_9 * arg_15_4, 0)
	elseif var_15_9 == 0 and var_15_7 < 0 then
		var_15_7 = math.min(var_15_7 + var_0_9 * arg_15_4, 0)
	elseif var_15_7 < var_15_9 and var_15_9 > 0 then
		var_15_7 = math.min(var_15_7 + var_0_8 * arg_15_4, var_15_9)
	elseif var_15_9 < var_15_7 and var_15_9 < 0 then
		var_15_7 = math.max(var_15_7 - var_0_8 * arg_15_4, var_15_9)
	elseif var_15_7 < var_15_9 and var_15_9 < 0 then
		var_15_7 = math.min(var_15_7 + var_0_9 * arg_15_4, var_15_9)
	else
		var_15_7 = math.max(var_15_7 - var_0_8 * arg_15_4, var_15_9)
	end

	var_15_0.align_speed = var_15_7

	local var_15_10 = 0 + var_15_7 * arg_15_4
	local var_15_11 = Quaternion.multiply(var_15_6, Quaternion(Vector3.up(), var_15_10))

	arg_15_2.locomotion_extension:set_wanted_rotation(var_15_11)

	local var_15_12 = math.min(arg_15_4 * 3, 1)
	local var_15_13 = Vector3.lerp(var_15_0.shoot_direction_box:unbox(), Quaternion.forward(var_15_11), var_15_12)

	var_15_0.shoot_direction_box:store(var_15_13)

	return math.abs(var_15_8) < var_0_10
end

function BTRatlingGunnerShootAction._angle_to_speed(arg_16_0, arg_16_1)
	if arg_16_1 > var_0_7 then
		return var_0_4
	elseif arg_16_1 < -var_0_7 then
		return -var_0_4
	elseif arg_16_1 > 0 then
		return math.auto_lerp(var_0_7, 0, var_0_4, var_0_5, arg_16_1)
	else
		return math.auto_lerp(-var_0_7, 0, -var_0_4, -var_0_5, arg_16_1)
	end
end

function BTRatlingGunnerShootAction._aim_at_target(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = arg_17_2.attack_pattern_data
	local var_17_1 = arg_17_2.action
	local var_17_2 = var_17_0.target_unit
	local var_17_3, var_17_4, var_17_5 = arg_17_0:_calculate_wanted_target_position(arg_17_1, var_17_2, var_17_0)
	local var_17_6 = Unit.local_rotation(arg_17_1, 0)
	local var_17_7 = ((Quaternion.yaw(var_17_4) - Quaternion.yaw(var_17_6)) % var_0_1 + var_0_0) % var_0_1 - var_0_0
	local var_17_8 = POSITION_LOOKUP[arg_17_1] + Vector3(0, 0, var_0_11)
	local var_17_9 = var_17_3 - var_17_8
	local var_17_10 = Quaternion.look(var_17_9, Vector3.up())
	local var_17_11 = var_17_0.current_aim_rotation:unbox()
	local var_17_12 = arg_17_0:_rotate_from_to(var_17_11, var_17_10, var_17_1.radial_speed_upper_body_shooting, arg_17_4)
	local var_17_13 = var_17_8 + Quaternion.forward(var_17_12) * Vector3.length(var_17_9)

	var_17_0.current_aim_rotation:store(var_17_12)

	local var_17_14, var_17_15 = arg_17_0:_rotate_from_to(var_17_6, var_17_4, var_17_1.radial_speed_feet_shooting, arg_17_4)

	arg_17_2.locomotion_extension:set_wanted_rotation(var_17_14)
	var_17_0.aim_position_box:store(var_17_13)
	var_17_0.shoot_direction_box:store(var_17_13 - var_17_8)

	local var_17_16, var_17_17 = Managers.state.network:game_object_or_level_id(arg_17_1)

	if not var_17_17 then
		local var_17_18 = Managers.state.network:game()
		local var_17_19 = NetworkConstants.position
		local var_17_20 = var_17_19.min
		local var_17_21 = var_17_19.max

		GameSession.set_game_object_field(var_17_18, var_17_16, "aim_position", Vector3.clamp(var_17_13, var_17_20, var_17_21))
	end

	local var_17_22 = var_17_7 > var_0_0 / 3 or var_17_7 < -var_0_0
	local var_17_23 = World.get_data(arg_17_2.world, "physics_world")

	PhysicsWorld.prepare_actors_for_raycast(var_17_23, var_17_8, Vector3.normalize(var_17_13 - var_17_8), var_17_1.spread)

	return var_17_22
end

function BTRatlingGunnerShootAction._remaining_angle(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = Quaternion.forward(arg_18_1)
	local var_18_1 = Quaternion.forward(arg_18_2)
	local var_18_2 = math.atan2(var_18_0.y, var_18_0.x)
	local var_18_3 = math.atan2(var_18_1.y, var_18_1.x)
	local var_18_4 = var_0_0
	local var_18_5 = var_18_4 * 2

	return ((var_18_3 - var_18_2) % var_18_5 + var_18_4) % var_18_5 - var_18_4
end

function BTRatlingGunnerShootAction._rotate_from_to(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_3 * arg_19_4
	local var_19_1 = Quaternion.dot(arg_19_2, arg_19_1)
	local var_19_2 = 2 * math.acos(math.clamp(var_19_1, -1, 1))
	local var_19_3 = math.abs((var_19_2 % var_0_1 + var_0_0) % var_0_1 - var_0_0)
	local var_19_4 = var_19_2 == 0 and 1 or math.min(var_19_0 / var_19_2, 1)

	return Quaternion.lerp(arg_19_1, arg_19_2, var_19_4), math.max(var_19_3 - var_19_0, 0)
end

function BTRatlingGunnerShootAction._fire_from_position_direction(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_2.ratling_gun_unit
	local var_20_1 = Unit.node(var_20_0, "p_fx")
	local var_20_2 = Unit.world_position(var_20_0, var_20_1)
	local var_20_3

	if arg_20_1.in_hit_reaction then
		var_20_3 = Quaternion.forward(Unit.world_rotation(var_20_0, var_20_1))
	else
		var_20_3 = arg_20_2.aim_position_box:unbox() - var_20_2
	end

	return var_20_2 - Vector3.normalize(var_20_3) * 0.25, var_20_3
end

function BTRatlingGunnerShootAction._shoot(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_2.action
	local var_21_1 = arg_21_2.attack_pattern_data
	local var_21_2 = var_21_0.light_weight_projectile_template_name
	local var_21_3 = LightWeightProjectiles[var_21_2]
	local var_21_4, var_21_5 = arg_21_0:_fire_from_position_direction(arg_21_2, var_21_1)
	local var_21_6 = Vector3.normalize(var_21_5)
	local var_21_7 = Math.random() * var_21_3.spread
	local var_21_8 = Quaternion.look(var_21_6, Vector3.up())
	local var_21_9 = Quaternion(Vector3.right(), var_21_7)
	local var_21_10 = Quaternion(Vector3.forward(), Math.random() * var_0_1)
	local var_21_11 = Quaternion.multiply(Quaternion.multiply(var_21_8, var_21_10), var_21_9)
	local var_21_12 = Quaternion.forward(var_21_11)
	local var_21_13 = "filter_enemy_player_afro_ray_projectile"
	local var_21_14 = Managers.state.difficulty:get_difficulty_rank()
	local var_21_15 = var_21_3.attack_power_level[var_21_14] or var_21_3.attack_power_level[2]
	local var_21_16 = {
		power_level = var_21_15,
		damage_profile = var_21_3.damage_profile,
		hit_effect = var_21_3.hit_effect,
		player_push_velocity = Vector3Box(var_21_6 * var_21_3.impact_push_speed),
		projectile_linker = var_21_3.projectile_linker,
		first_person_hit_flow_events = var_21_3.first_person_hit_flow_events
	}
	local var_21_17 = Managers.state.entity:system("projectile_system")
	local var_21_18 = var_21_1.peer_id
	local var_21_19 = CLIENT_CONTROLLED_RATLING_GUN

	var_21_17:create_light_weight_projectile(arg_21_2.breed.name, arg_21_1, var_21_4, var_21_12, var_21_3.projectile_speed, nil, nil, var_21_3.projectile_max_range, var_21_13, var_21_16, var_21_3.light_weight_projectile_effect, var_21_18, nil, var_21_19)
end

function BTRatlingGunnerShootAction._create_bot_threat_box(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0 = POSITION_LOOKUP[arg_22_1]
	local var_22_1 = POSITION_LOOKUP[arg_22_2.target_unit]

	if var_22_0 and var_22_1 then
		local var_22_2, var_22_3 = arg_22_0:_fire_from_position_direction(arg_22_4, arg_22_5)
		local var_22_4 = Vector3.length(var_22_2 - var_22_1)
		local var_22_5, var_22_6, var_22_7 = AiUtils.calculate_oobb(var_22_4 * 2, var_22_0, Quaternion.look(var_22_3), nil, 3)

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_22_5, "oobb", var_22_7, var_22_6, arg_22_3, "Ratling Gunner")
	end
end
