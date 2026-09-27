-- chunkname: @scripts/entity_system/systems/behaviour/nodes/skaven_ratling_gunner/bt_ratling_gunner_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatlingGunnerShootAction = class(BTRatlingGunnerShootAction, BTNode)

local pi = math.pi
local num = pi * 2
local num_2 = 0.25

CLIENT_CONTROLLED_RATLING_GUN = true

BTRatlingGunnerShootAction.init = function (arg_1_0, ...)
	-- function 1
	BTRatlingGunnerShootAction.super.init(arg_1_0, ...)
end

BTRatlingGunnerShootAction.name = "BTRatlingGunnerShootAction"

BTRatlingGunnerShootAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local attack_pattern_data = arg_2_2.attack_pattern_data

	attack_pattern_data = attack_pattern_data or {}

	local pick_ratling_gun_target, var_2_3, var_2_4 = PerceptionUtils.pick_ratling_gun_target(arg_2_1, arg_2_2)
	local flag = pick_ratling_gun_target or attack_pattern_data.target_unit

	arg_2_2.action = action_data
	attack_pattern_data.target_unit = flag
	attack_pattern_data.target_node_name = var_2_3 or attack_pattern_data.target_node_name

	if not Unit.alive(flag) then
		return
	end

	attack_pattern_data.shoot_start = nil
	attack_pattern_data.shots_fired = nil
	attack_pattern_data.time_between_shots_at_start = 1 / action_data.fire_rate_at_start
	attack_pattern_data.time_between_shots_at_end = 1 / action_data.fire_rate_at_end
	attack_pattern_data.max_fire_rate_at_percentage_modifier = 1 / action_data.max_fire_rate_at_percentage
	attack_pattern_data.target_switch_distance_squared = AiUtils.random(action_data.target_switch_distance[1], action_data.target_switch_distance[2])^2
	attack_pattern_data.target_obscured = false
	attack_pattern_data.target_check = arg_2_3 + 0.2 + Math.random() * 0.1

	local peer_id = attack_pattern_data.peer_id

	peer_id = peer_id or Network.peer_id()
	attack_pattern_data.peer_id = peer_id
	attack_pattern_data.update_bot_threat_t = arg_2_3
	self._use_obstacle = false

	if not self._use_obstacle then
		local _create_nav_obstacles, var_2_8 = self:_create_nav_obstacles(arg_2_1, flag, arg_2_2.nav_world, action_data)

		attack_pattern_data.line_of_fire_nav_obstacle = _create_nav_obstacles
		attack_pattern_data.arc_of_sight_nav_obstacle = var_2_8
	end

	arg_2_2.first_shots_fired = true
	arg_2_2.attack_pattern_data = attack_pattern_data

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	attack_pattern_data.shoot_direction_box = Vector3Box(Quaternion.forward(Unit.world_rotation(arg_2_1, Unit.node(arg_2_1, "c_spine"))))

	self:_start_align_towards_target(arg_2_1, arg_2_2, attack_pattern_data, flag, arg_2_3)
	arg_2_2.locomotion_extension:use_lerp_rotation(false)
	self:_notify_attacking(arg_2_1, flag)
end

BTRatlingGunnerShootAction._create_nav_obstacles = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local var_3_0 = POSITION_LOOKUP[arg_3_1]
	local var_3_1 = POSITION_LOOKUP[arg_3_2]
	local var_3_2 = Vector3(0, 0, 0)
	local unbox = arg_3_4.line_of_fire_nav_obstacle_half_extents:unbox()
	local unbox_2 = arg_3_4.arc_of_sight_nav_obstacle_half_extents:unbox()
	local flag = false
	local var_3_6 = Color(255, 0, 0)
	local var_3_7 = LAYER_ID_MAPPING[arg_3_4.nav_obstacle_layer_name]
	local var_3_8 = GwNavBoxObstacle.create(arg_3_3, var_3_0, var_3_2, unbox, flag, var_3_6, var_3_7)
	local var_3_9 = GwNavBoxObstacle.create(arg_3_3, var_3_0, var_3_2, unbox_2, flag, var_3_6, var_3_7)

	return var_3_8, var_3_9
end

BTRatlingGunnerShootAction.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.anim_cb_attack_shoot_start_finished = nil
	arg_4_2.anim_cb_attack_shoot_random_shot = nil

	Managers.state.debug:drawer({
		mode = "retained",
		name = "BTRatlingGunnerShootAction"
	}):reset()

	local attack_pattern_data = arg_4_2.attack_pattern_data

	attack_pattern_data.shoot_direction_box = nil
	attack_pattern_data.aim_position_box = nil
	attack_pattern_data.current_aim_rotation = nil
	attack_pattern_data.shoot_duration = nil
	attack_pattern_data.shoot_start = nil
	attack_pattern_data.shots_fired = nil
	attack_pattern_data.time_between_shots_at_start = nil
	attack_pattern_data.time_between_shots_at_end = nil
	attack_pattern_data.max_fire_rate_at_percentage_modifier = nil
	attack_pattern_data.target_switch_distance_squared = nil
	attack_pattern_data.target_obscured = nil
	attack_pattern_data.last_known_target_position = nil
	attack_pattern_data.last_known_unit_position = nil
	attack_pattern_data.last_fired = arg_4_3

	if not attack_pattern_data.is_shooting then
		self:stop_shooting(arg_4_1, attack_pattern_data)
	end

	if not self._use_obstacle and not attack_pattern_data.line_of_fire_nav_obstacle and not attack_pattern_data.arc_of_sight_nav_obstacle then
		GwNavBoxObstacle.destroy(attack_pattern_data.line_of_fire_nav_obstacle)
		GwNavBoxObstacle.destroy(attack_pattern_data.arc_of_sight_nav_obstacle)

		attack_pattern_data.line_of_fire_nav_obstacle = nil
		attack_pattern_data.arc_of_sight_nav_obstacle = nil
	end

	self:_notify_no_longer_attacking(arg_4_1, attack_pattern_data.target_unit)

	if not arg_4_5 then
		arg_4_2.locomotion_extension:use_lerp_rotation(true)
	end

	arg_4_2.navigation_extension:set_enabled(true)
end

BTRatlingGunnerShootAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local attack_pattern_data = arg_5_2.attack_pattern_data
	local target_unit = attack_pattern_data.target_unit

	if not HEALTH_ALIVE[target_unit] then
		return "done"
	end

	if attack_pattern_data.state == "align" then
		if not self:_update_target(arg_5_1, arg_5_2, self._tree_node.action_data, attack_pattern_data, arg_5_3, arg_5_4) then
			self:_start_align_towards_target(arg_5_1, arg_5_2, attack_pattern_data, attack_pattern_data.target_unit, arg_5_3)
		end

		if not (not self:_update_align_towards_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4) and script_data.disable_ratling_gun_fire) then
			self:_end_align_towards_target(arg_5_1, attack_pattern_data)
		end

		return "running"
	elseif attack_pattern_data.state == "ready" then
		local _aim_at_target = self:_aim_at_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		local _update_target = self:_update_target(arg_5_1, arg_5_2, self._tree_node.action_data, attack_pattern_data, arg_5_3, arg_5_4)

		if _aim_at_target or not _update_target then
			self:_start_align_towards_target(arg_5_1, arg_5_2, attack_pattern_data, attack_pattern_data.target_unit, arg_5_3)

			return "running"
		end

		if not arg_5_2.anim_cb_attack_shoot_random_shot then
			self:_start_shooting(arg_5_2, arg_5_1, attack_pattern_data, arg_5_3)
		end

		return "running"
	elseif attack_pattern_data.state == "shoot" then
		if not self:_update_target(arg_5_1, arg_5_2, self._tree_node.action_data, attack_pattern_data, arg_5_3, arg_5_4) then
			self:stop_shooting(arg_5_1, attack_pattern_data)
			self:_start_align_towards_target(arg_5_1, arg_5_2, attack_pattern_data, attack_pattern_data.target_unit, arg_5_3)

			return "running"
		end

		if not self:_aim_at_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4) then
			self:stop_shooting(arg_5_1, attack_pattern_data)
			self:_start_align_towards_target(arg_5_1, arg_5_2, attack_pattern_data, attack_pattern_data.target_unit, arg_5_3)

			return "running"
		end

		self:_update_shooting(arg_5_1, arg_5_2, attack_pattern_data, arg_5_3, arg_5_4)

		if arg_5_3 > attack_pattern_data.shoot_start + attack_pattern_data.shoot_duration then
			return "done"
		end

		return "running"
	end
end

BTRatlingGunnerShootAction._notify_attacking = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_6_1, arg_6_2, "ratling_gun_fire")

	if not Unit.alive(arg_6_2) then
		ScriptUnit.extension(arg_6_2, "status_system").under_ratling_gunner_attack = true
	end
end

BTRatlingGunnerShootAction._notify_no_longer_attacking = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_7_1, arg_7_2, "ratling_gun_fire")

	if not Unit.alive(arg_7_2) then
		ScriptUnit.extension(arg_7_2, "status_system").under_ratling_gunner_attack = false
	end
end

BTRatlingGunnerShootAction.stop_shooting = function (self, arg_8_1, arg_8_2)
	-- function 8
	arg_8_2.is_shooting = nil

	local go_id = Managers.state.unit_storage:go_id(arg_8_1)

	Managers.state.network.network_transmit:send_rpc_clients("rpc_ai_weapon_shoot_end", go_id)
	Managers.state.entity:system("weapon_system"):rpc_ai_weapon_shoot_end(Network.peer_id(), go_id)

	if not self._use_obstacle then
		GwNavBoxObstacle.remove_from_world(arg_8_2.line_of_fire_nav_obstacle)
		GwNavBoxObstacle.remove_from_world(arg_8_2.arc_of_sight_nav_obstacle)
	end

	if not CLIENT_CONTROLLED_RATLING_GUN then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_clients_continuous_shoot_stop", go_id)
	end
end

BTRatlingGunnerShootAction._update_shooting = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local num = arg_9_4 - arg_9_3.shoot_start
	local clamp = math.clamp(num / arg_9_3.shoot_duration * arg_9_3.max_fire_rate_at_percentage_modifier, 0, 1)
	local lerp = math.lerp(arg_9_3.time_between_shots_at_start, arg_9_3.time_between_shots_at_end, clamp)
	local num_3 = math.floor(num / lerp) + 1 - arg_9_3.shots_fired

	for i = 1, num_3 do
		arg_9_3.shots_fired = arg_9_3.shots_fired + 1

		self:_shoot(arg_9_1, arg_9_2, arg_9_4, arg_9_5)
	end

	if arg_9_4 > arg_9_3.update_bot_threat_t then
		self:_create_bot_threat_box(arg_9_1, arg_9_3, num_2, arg_9_2, arg_9_3)

		arg_9_3.update_bot_threat_t = arg_9_4 + num_2
	end

	if not self._use_obstacle then
		local unbox = arg_9_2.action.line_of_fire_nav_obstacle_half_extents:unbox()
		local unbox_2 = arg_9_2.action.arc_of_sight_nav_obstacle_half_extents:unbox()
		local _fire_from_position_direction, var_9_7 = self:_fire_from_position_direction(arg_9_2, arg_9_3)
		local normalize = Vector3.normalize(var_9_7)
		local num_4 = _fire_from_position_direction + normalize * unbox.y
		local num_5 = _fire_from_position_direction + normalize * unbox_2.y
		local look = Quaternion.look(normalize, Vector3.up())
		local from_quaternion_position = Matrix4x4.from_quaternion_position(look, num_4)
		local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(look, num_5)
		local last_t = self.last_t

		last_t = last_t or arg_9_4
		self.last_t = last_t

		local line_of_fire_nav_obstacle = arg_9_3.line_of_fire_nav_obstacle
		local arc_of_sight_nav_obstacle = arg_9_3.arc_of_sight_nav_obstacle

		if arg_9_4 > self.last_t + 1 then
			GwNavBoxObstacle.set_does_trigger_tagvolume(line_of_fire_nav_obstacle, false)
			GwNavBoxObstacle.remove_from_world(line_of_fire_nav_obstacle)
			GwNavBoxObstacle.set_transform(line_of_fire_nav_obstacle, from_quaternion_position)
			GwNavBoxObstacle.add_to_world(line_of_fire_nav_obstacle)
			GwNavBoxObstacle.set_does_trigger_tagvolume(line_of_fire_nav_obstacle, true)
			GwNavBoxObstacle.set_does_trigger_tagvolume(arc_of_sight_nav_obstacle, false)
			GwNavBoxObstacle.remove_from_world(arc_of_sight_nav_obstacle)
			GwNavBoxObstacle.set_transform(arc_of_sight_nav_obstacle, from_quaternion_position_2)
			GwNavBoxObstacle.add_to_world(arc_of_sight_nav_obstacle)
			GwNavBoxObstacle.set_does_trigger_tagvolume(arc_of_sight_nav_obstacle, true)

			self.last_t = arg_9_4
		end
	end
end

BTRatlingGunnerShootAction._start_shooting = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local round = math.round(arg_10_3.shoot_duration * 100)
	local go_id = Managers.state.unit_storage:go_id(arg_10_2)

	Managers.state.network.network_transmit:send_rpc_clients("rpc_ai_weapon_shoot_start", go_id, round)
	Managers.state.entity:system("weapon_system"):rpc_ai_weapon_shoot_start(Network.peer_id(), go_id, round)

	arg_10_3.is_shooting = true
	arg_10_3.shoot_start = arg_10_4
	arg_10_3.shots_fired = 0
	arg_10_3.state = "shoot"

	Managers.state.entity:system("dialogue_system"):trigger_targeted_by_ratling(arg_10_3.target_unit)

	if not self._use_obstacle then
		local line_of_fire_nav_obstacle = arg_10_3.line_of_fire_nav_obstacle

		GwNavBoxObstacle.add_to_world(line_of_fire_nav_obstacle)

		local arc_of_sight_nav_obstacle = arg_10_3.arc_of_sight_nav_obstacle

		GwNavBoxObstacle.add_to_world(arc_of_sight_nav_obstacle)

		local unbox = arg_10_1.action.line_of_fire_nav_obstacle_half_extents:unbox()
		local unbox_2 = arg_10_1.action.arc_of_sight_nav_obstacle_half_extents:unbox()
		local _fire_from_position_direction, var_10_7 = self:_fire_from_position_direction(arg_10_1, arg_10_3)
		local normalize = Vector3.normalize(var_10_7)
		local num = _fire_from_position_direction + normalize * unbox.y
		local num_2 = _fire_from_position_direction + normalize * unbox_2.y
		local look = Quaternion.look(normalize, Vector3.up())
		local from_quaternion_position = Matrix4x4.from_quaternion_position(look, num)
		local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(look, num_2)

		GwNavBoxObstacle.set_transform(line_of_fire_nav_obstacle, from_quaternion_position)
		GwNavBoxObstacle.set_transform(arc_of_sight_nav_obstacle, from_quaternion_position_2)
		GwNavBoxObstacle.set_does_trigger_tagvolume(line_of_fire_nav_obstacle, true)
		GwNavBoxObstacle.set_does_trigger_tagvolume(arc_of_sight_nav_obstacle, true)
	end

	if not CLIENT_CONTROLLED_RATLING_GUN then
		local action = arg_10_1.action
		local name = arg_10_1.breed.name
		local var_10_16 = NetworkLookup.breeds[name]
		local shoot_duration = arg_10_3.shoot_duration
		local name_2 = arg_10_1.action.name
		local var_10_19 = NetworkLookup.bt_action_names[name_2]
		local game_object_or_level_id, var_10_21 = Managers.state.network:game_object_or_level_id(arg_10_2)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_clients_continuous_shoot_start", game_object_or_level_id, var_10_21, var_10_16, var_10_19, shoot_duration, arg_10_3.peer_id)
	end
end

local num_3 = 0.7071067

BTRatlingGunnerShootAction._update_target = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	-- function 11
	local flag = false

	if arg_11_5 > arg_11_4.target_check then
		local target_unit = arg_11_4.target_unit
		local pick_ratling_gun_target, var_11_3, var_11_4, var_11_5, var_11_6, var_11_7 = PerceptionUtils.pick_ratling_gun_target(arg_11_1, arg_11_2, target_unit, num_3, arg_11_4.shoot_direction_box:unbox())

		if not (not pick_ratling_gun_target and pick_ratling_gun_target == target_unit) then
			local var_11_8 = POSITION_LOOKUP[pick_ratling_gun_target]
			local var_11_9 = POSITION_LOOKUP[arg_11_4.target_unit]
			local var_11_10 = POSITION_LOOKUP[arg_11_1]
			local target_switch_distance_squared = arg_11_4.target_switch_distance_squared

			if not (pick_ratling_gun_target == arg_11_2.taunt_unit or not (var_11_6 < target_switch_distance_squared) or not (target_switch_distance_squared < var_11_7)) then
				arg_11_4.target_unit = pick_ratling_gun_target
				arg_11_4.target_node_name = var_11_3
				arg_11_4.target_obscured = false
				flag = true

				self:_notify_no_longer_attacking(arg_11_1, target_unit)
				self:_notify_attacking(arg_11_1, pick_ratling_gun_target)

				arg_11_4.target_check = arg_11_5 + 0.1 + Math.random() * 0.05
			elseif not var_11_4 then
				arg_11_4.target_obscured = false
				arg_11_4.target_node_name = var_11_5
				arg_11_4.target_check = arg_11_5 + 0.1 + Math.random() * 0.05
			else
				arg_11_4.target_check = arg_11_5 + 0.5 + Math.random() * 0.25
				arg_11_4.target_obscured = true
			end
		elseif not var_11_4 then
			arg_11_4.target_obscured = false
			arg_11_4.target_node_name = var_11_5
			arg_11_4.target_check = arg_11_5 + 0.1 + Math.random() * 0.05
		else
			arg_11_4.target_obscured = true
			arg_11_4.target_check = arg_11_5 + 0.5 + Math.random() * 0.25
		end

		if not arg_11_4.target_obscured then
			local target_unit_2 = arg_11_4.target_unit

			arg_11_4.last_known_target_position:store(Unit.world_position(target_unit_2, Unit.node(target_unit_2, arg_11_4.target_node_name)))
			arg_11_4.last_known_unit_position:store(Unit.world_position(arg_11_1, Unit.node(arg_11_1, "c_spine")))
		end
	end

	return flag
end

BTRatlingGunnerShootAction._calculate_wanted_target_position = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0
	local var_12_1
	local target_obscured = arg_12_3.target_obscured

	if not arg_12_3.target_obscured then
		var_12_0 = arg_12_3.last_known_target_position:unbox()
		var_12_1 = arg_12_3.last_known_unit_position:unbox()
	else
		var_12_0 = Unit.world_position(arg_12_2, Unit.node(arg_12_2, arg_12_3.target_node_name))
		var_12_1 = Unit.world_position(arg_12_1, Unit.node(arg_12_1, "c_spine"))
	end

	local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_12_1, var_12_0)

	return var_12_0, look_at_position_flat, var_12_1
end

BTRatlingGunnerShootAction._start_align_towards_target = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	arg_13_3.state = "align"

	local unbox = arg_13_3.shoot_direction_box:unbox()
	local _calculate_wanted_target_position, var_13_2, var_13_3 = self:_calculate_wanted_target_position(arg_13_1, arg_13_4, arg_13_3)
	local normalize = Vector3.normalize(Vector3.flat(unbox))
	local normalize_2 = Vector3.normalize(Vector3.flat(_calculate_wanted_target_position - var_13_3))
	local flat_angle = Vector3.flat_angle(normalize, normalize_2)
	local action = arg_13_2.action

	arg_13_3.align_start = arg_13_5
	arg_13_3.shoot_direction_start_box = Vector3Box(unbox)
	arg_13_3.shoot_duration = AiUtils.random(action.attack_time[1], action.attack_time[2])
	arg_13_3.align_speed = 0
	arg_13_3.aim_position_box = nil
	arg_13_3.current_aim_rotation = nil
	arg_13_2.anim_cb_attack_shoot_random_shot = nil

	Managers.state.network:anim_event(arg_13_1, "attack_shoot_align")
end

BTRatlingGunnerShootAction._end_align_towards_target = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	arg_14_2.state = "ready"
	arg_14_2.align_start = nil
	arg_14_2.shoot_direction_start = nil
	arg_14_2.align_speed = nil
	arg_14_2.aim_position_box = Vector3Box()
	arg_14_2.current_aim_rotation = QuaternionBox(Quaternion.look(arg_14_2.shoot_direction_box:unbox(), Vector3.up()))

	Managers.state.network:anim_event(arg_14_1, "attack_shoot_start")
end

local num_4 = 5
local num_5 = 1
local num_6 = num_5 * 0.5
local num_7 = pi / 12
local num_8 = pi * 12
local num_9 = pi * 6
local num_10 = pi / 32
local num_11 = 0.7

BTRatlingGunnerShootAction._update_align_towards_target = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local attack_pattern_data = arg_15_2.attack_pattern_data
	local action = arg_15_2.action
	local target_unit = attack_pattern_data.target_unit
	local _calculate_wanted_target_position, var_15_4, var_15_5 = self:_calculate_wanted_target_position(arg_15_1, target_unit, attack_pattern_data)
	local local_rotation = Unit.local_rotation(arg_15_1, 0)
	local align_speed = attack_pattern_data.align_speed
	local _remaining_angle = self:_remaining_angle(local_rotation, var_15_4)
	local _angle_to_speed = self:_angle_to_speed(_remaining_angle)

	if not (_angle_to_speed ~= 0 or not (align_speed > 0)) then
		align_speed = math.max(align_speed - num_9 * arg_15_4, 0)
	elseif not (_angle_to_speed ~= 0 or not (align_speed < 0)) then
		align_speed = math.min(align_speed + num_9 * arg_15_4, 0)
	elseif not (not (align_speed < _angle_to_speed) or not (_angle_to_speed > 0)) then
		align_speed = math.min(align_speed + num_8 * arg_15_4, _angle_to_speed)
	elseif not (not (_angle_to_speed < align_speed) or not (_angle_to_speed < 0)) then
		align_speed = math.max(align_speed - num_8 * arg_15_4, _angle_to_speed)
	elseif not (not (align_speed < _angle_to_speed) or not (_angle_to_speed < 0)) then
		align_speed = math.min(align_speed + num_9 * arg_15_4, _angle_to_speed)
	else
		align_speed = math.max(align_speed - num_8 * arg_15_4, _angle_to_speed)
	end

	attack_pattern_data.align_speed = align_speed

	local num = 0 + align_speed * arg_15_4
	local multiply = Quaternion.multiply(local_rotation, Quaternion(Vector3.up(), num))

	arg_15_2.locomotion_extension:set_wanted_rotation(multiply)

	local min = math.min(arg_15_4 * 3, 1)
	local lerp = Vector3.lerp(attack_pattern_data.shoot_direction_box:unbox(), Quaternion.forward(multiply), min)

	attack_pattern_data.shoot_direction_box:store(lerp)

	return math.abs(_remaining_angle) < num_10
end

BTRatlingGunnerShootAction._angle_to_speed = function (arg_16_0, arg_16_1)
	-- function 16
	if arg_16_1 > num_7 then
		return num_4
	elseif arg_16_1 < -num_7 then
		return -num_4
	elseif arg_16_1 > 0 then
		return math.auto_lerp(num_7, 0, num_4, num_5, arg_16_1)
	else
		return math.auto_lerp(-num_7, 0, -num_4, -num_5, arg_16_1)
	end
end

BTRatlingGunnerShootAction._aim_at_target = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local attack_pattern_data = arg_17_2.attack_pattern_data
	local action = arg_17_2.action
	local target_unit = attack_pattern_data.target_unit
	local _calculate_wanted_target_position, var_17_4, var_17_5 = self:_calculate_wanted_target_position(arg_17_1, target_unit, attack_pattern_data)
	local local_rotation = Unit.local_rotation(arg_17_1, 0)
	local num_2 = ((Quaternion.yaw(var_17_4) - Quaternion.yaw(local_rotation)) % num + pi) % num - pi
	local num_3 = POSITION_LOOKUP[arg_17_1] + Vector3(0, 0, num_11)
	local num_4 = _calculate_wanted_target_position - num_3
	local look = Quaternion.look(num_4, Vector3.up())
	local unbox = attack_pattern_data.current_aim_rotation:unbox()
	local _rotate_from_to = self:_rotate_from_to(unbox, look, action.radial_speed_upper_body_shooting, arg_17_4)
	local num_5 = num_3 + Quaternion.forward(_rotate_from_to) * Vector3.length(num_4)

	attack_pattern_data.current_aim_rotation:store(_rotate_from_to)

	local _rotate_from_to_2, var_17_15 = self:_rotate_from_to(local_rotation, var_17_4, action.radial_speed_feet_shooting, arg_17_4)

	arg_17_2.locomotion_extension:set_wanted_rotation(_rotate_from_to_2)
	attack_pattern_data.aim_position_box:store(num_5)
	attack_pattern_data.shoot_direction_box:store(num_5 - num_3)

	local game_object_or_level_id, var_17_17 = Managers.state.network:game_object_or_level_id(arg_17_1)

	if not var_17_17 then
		local game = Managers.state.network:game()
		local position = NetworkConstants.position
		local min = position.min
		local max = position.max

		GameSession.set_game_object_field(game, game_object_or_level_id, "aim_position", Vector3.clamp(num_5, min, max))
	end

	local flag = num_2 > pi / 3 or num_2 < -pi
	local get_data = World.get_data(arg_17_2.world, "physics_world")

	PhysicsWorld.prepare_actors_for_raycast(get_data, num_3, Vector3.normalize(num_5 - num_3), action.spread)

	return flag
end

BTRatlingGunnerShootAction._remaining_angle = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local forward = Quaternion.forward(arg_18_1)
	local forward_2 = Quaternion.forward(arg_18_2)
	local atan2 = math.atan2(forward.y, forward.x)
	local atan2_2 = math.atan2(forward_2.y, forward_2.x)
	local var_18_4 = pi
	local num = var_18_4 * 2

	return ((atan2_2 - atan2) % num + var_18_4) % num - var_18_4
end

BTRatlingGunnerShootAction._rotate_from_to = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local num_2 = arg_19_3 * arg_19_4
	local dot = Quaternion.dot(arg_19_2, arg_19_1)
	local num_3 = 2 * math.acos(math.clamp(dot, -1, 1))
	local abs = math.abs((num_3 % num + pi) % num - pi)
	local flag

	flag = num_3 ~= 0 or not 1 or math.min(num_2 / num_3, 1)

	return Quaternion.lerp(arg_19_1, arg_19_2, flag), math.max(abs - num_2, 0)
end

BTRatlingGunnerShootAction._fire_from_position_direction = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local ratling_gun_unit = arg_20_2.ratling_gun_unit
	local node = Unit.node(ratling_gun_unit, "p_fx")
	local world_position = Unit.world_position(ratling_gun_unit, node)
	local var_20_3

	if not arg_20_1.in_hit_reaction then
		var_20_3 = Quaternion.forward(Unit.world_rotation(ratling_gun_unit, node))
	else
		var_20_3 = arg_20_2.aim_position_box:unbox() - world_position
	end

	return world_position - Vector3.normalize(var_20_3) * 0.25, var_20_3
end

BTRatlingGunnerShootAction._shoot = function (self, arg_21_1, arg_21_2)
	-- function 21
	local action = arg_21_2.action
	local attack_pattern_data = arg_21_2.attack_pattern_data
	local light_weight_projectile_template_name = action.light_weight_projectile_template_name
	local var_21_3 = LightWeightProjectiles[light_weight_projectile_template_name]
	local _fire_from_position_direction, var_21_5 = self:_fire_from_position_direction(arg_21_2, attack_pattern_data)
	local normalize = Vector3.normalize(var_21_5)
	local num_2 = Math.random() * var_21_3.spread
	local look = Quaternion.look(normalize, Vector3.up())
	local var_21_9 = Quaternion(Vector3.right(), num_2)
	local var_21_10 = Quaternion(Vector3.forward(), Math.random() * num)
	local multiply = Quaternion.multiply(Quaternion.multiply(look, var_21_10), var_21_9)
	local forward = Quaternion.forward(multiply)
	local str = "filter_enemy_player_afro_ray_projectile"
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_21_15 = var_21_3.attack_power_level[get_difficulty_rank]

	var_21_15 = var_21_15 or var_21_3.attack_power_level[2]

	local tbl = {
		power_level = var_21_15,
		damage_profile = var_21_3.damage_profile,
		hit_effect = var_21_3.hit_effect,
		player_push_velocity = Vector3Box(normalize * var_21_3.impact_push_speed),
		projectile_linker = var_21_3.projectile_linker,
		first_person_hit_flow_events = var_21_3.first_person_hit_flow_events
	}
	local system = Managers.state.entity:system("projectile_system")
	local peer_id = attack_pattern_data.peer_id
	local CLIENT_CONTROLLED_RATLING_GUN = CLIENT_CONTROLLED_RATLING_GUN

	system:create_light_weight_projectile(arg_21_2.breed.name, arg_21_1, _fire_from_position_direction, forward, var_21_3.projectile_speed, nil, nil, var_21_3.projectile_max_range, str, tbl, var_21_3.light_weight_projectile_effect, peer_id, nil, CLIENT_CONTROLLED_RATLING_GUN)
end

BTRatlingGunnerShootAction._create_bot_threat_box = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	local var_22_0 = POSITION_LOOKUP[arg_22_1]
	local var_22_1 = POSITION_LOOKUP[arg_22_2.target_unit]

	if not var_22_0 and not var_22_1 then
		local _fire_from_position_direction, var_22_3 = self:_fire_from_position_direction(arg_22_4, arg_22_5)
		local length = Vector3.length(_fire_from_position_direction - var_22_1)
		local calculate_oobb, var_22_6, var_22_7 = AiUtils.calculate_oobb(length * 2, var_22_0, Quaternion.look(var_22_3), nil, 3)

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(calculate_oobb, "oobb", var_22_7, var_22_6, arg_22_3, "Ratling Gunner")
	end
end
