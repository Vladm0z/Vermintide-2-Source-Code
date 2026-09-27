-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_charge_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

BTChargePositionAction = class(BTChargePositionAction, BTNode)

BTChargePositionAction.init = function (arg_1_0, ...)
	-- function 1
	BTChargePositionAction.super.init(arg_1_0, ...)
end

BTChargePositionAction.name = "BTChargePositionAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTChargePositionAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
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

	local network = Managers.state.network
	local var_3_2 = fn(action_data.start_animation)

	network:anim_event(arg_3_1, var_3_2)

	arg_3_2.spawn_to_running = nil
	arg_3_2.keep_position_if_interrupted = action_data.keep_position_if_interrupted

	self:_start_starting(arg_3_1, arg_3_2, arg_3_3)

	local navigation_extension = arg_3_2.navigation_extension
	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:use_lerp_rotation(true)
	navigation_extension:reset_destination()
	navigation_extension:set_enabled(false)

	arg_3_2.hit_units = {}
	arg_3_2.pushed_units = {}

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	ScriptUnit.extension(arg_3_1, "hit_reaction_system").force_ragdoll_on_death = true
	arg_3_2.old_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table()

	local get_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table("charge")

	if not get_navtag_layer_cost_table then
		local traverse_logic = arg_3_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, get_navtag_layer_cost_table)
	end
end

BTChargePositionAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.attack_token = false

	if not HEALTH_ALIVE[arg_4_1] then
		local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
		local navigation_extension = arg_4_2.navigation_extension

		navigation_extension:set_enabled(true)
		navigation_extension:set_max_speed(get_default_breed_move_speed)

		local locomotion_extension = arg_4_2.locomotion_extension

		locomotion_extension:set_rotation_speed(nil)
		locomotion_extension:use_lerp_rotation(true)

		local traverse_logic = arg_4_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, arg_4_2.old_navtag_layer_cost_table)

		arg_4_2.old_navtag_layer_cost_table = nil
		ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil
	end

	if not (not arg_4_2.stagger and arg_4_2.charge_state ~= "charging") then
		arg_4_2.charge_stagger = true
	end

	if not arg_4_2.action.stick_to_enemy_t then
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

	if not (arg_4_2.keep_position_if_interrupted or arg_4_2.requested_charge_position ~= arg_4_2.charge_position) then
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

BTChargePositionAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not arg_5_2.attack_aborted then
		return "done"
	end

	if not arg_5_2.requested_charge_position then
		return "done"
	end

	if arg_5_3 > arg_5_2.ray_can_go_update_time then
		local nav_world = arg_5_2.nav_world
		local unbox = arg_5_2.requested_charge_position:unbox()

		arg_5_2.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(nav_world, POSITION_LOOKUP[arg_5_1], unbox, nil, 1, 1)
		arg_5_2.ray_can_go_update_time = arg_5_3 + 0.25
	end

	local charge_state = arg_5_2.charge_state
	local var_5_3

	if charge_state == "starting" then
		self:_run_starting(arg_5_1, arg_5_2, arg_5_3)
	elseif charge_state == "approaching" then
		self:_run_approaching(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif charge_state == "charging" then
		self:_run_charging(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif charge_state == "impact" then
		self:_run_impact(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif charge_state == "finished" then
		return "done"
	elseif charge_state == "cancel" then
		self:_run_cancel(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	end

	return "running", var_5_3
end

BTChargePositionAction._start_starting = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_2.charge_state = "starting"
end

BTChargePositionAction._start_charging = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local action = arg_7_2.action
	local time = Managers.time:time("game")
	local var_7_2 = fn(action.charge_animation)

	arg_7_2.move_state = "moving"
	arg_7_2.charge_state = "charging"

	Managers.state.network:anim_event(arg_7_1, var_7_2)
	arg_7_2.locomotion_extension:set_rotation_speed(action.charge_rotation_speed)

	arg_7_2.charge_started_at_t = time

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_7_1, "incoming_attack", DialogueSettings.special_proximity_distance_heard, "enemy_tag", arg_7_2.breed.name)
end

BTChargePositionAction._start_approaching = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local action = arg_8_2.action

	arg_8_2.charge_state = "approaching"
	arg_8_2.goal_destination = arg_8_2.requested_charge_position

	local navigation_extension = arg_8_2.navigation_extension
	local current_charge_speed = arg_8_2.current_charge_speed

	current_charge_speed = current_charge_speed or action.charge_speed_min

	navigation_extension:set_enabled(true)
	navigation_extension:set_max_speed(current_charge_speed)
	navigation_extension:move_to(arg_8_2.goal_destination:unbox())

	arg_8_2.move_state = "moving"
end

BTChargePositionAction._start_impact = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	local action = arg_9_2.action

	arg_9_2.charge_state = "impact"

	local locomotion_extension = arg_9_2.locomotion_extension

	arg_9_2.navigation_extension:set_enabled(false)

	if not arg_9_4 then
		local charge_blocked_animation = action.charge_blocked_animation
		local var_9_3 = fn(charge_blocked_animation)

		Managers.state.network:anim_event(arg_9_1, var_9_3)
		locomotion_extension:set_wanted_velocity(Vector3.zero())
		locomotion_extension:set_rotation_speed(nil)
	elseif arg_9_3 or not arg_9_6 then
		local charge_blocked_animation_2

		if not arg_9_5 then
			charge_blocked_animation_2 = action.charge_blocked_animation

			if not charge_blocked_animation_2 then
				-- Nothing
			end
		end

		charge_blocked_animation_2 = action.impact_animation

		::label_9_0::

		local var_9_5 = fn(charge_blocked_animation_2)

		Managers.state.network:anim_event(arg_9_1, var_9_5)

		local current_velocity = locomotion_extension:current_velocity()

		locomotion_extension:set_wanted_velocity(current_velocity * 0.5)
		locomotion_extension:set_rotation_speed(nil)
	end

	arg_9_2.hit_target = arg_9_3
	arg_9_2.charge_position = nil
end

BTChargePositionAction._pause_charge = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	arg_10_2.navigation_extension:set_enabled(false)

	local var_10_0 = fn(arg_10_2.action.cancel_animation)

	Managers.state.network:anim_event(arg_10_1, var_10_0)

	arg_10_2.charge_state = "cancel"

	arg_10_2.locomotion_extension:set_rotation_speed(nil)
end

BTChargePositionAction._cancel_charge = function (self, arg_11_1, arg_11_2)
	-- function 11
	self:_pause_charge(arg_11_1, arg_11_2)

	arg_11_2.charge_position = nil
end

BTChargePositionAction._check_unit_and_wall_collision = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local action = arg_12_2.action
	local _check_overlap = self:_check_overlap(arg_12_1, arg_12_2, action)

	if not _check_overlap then
		self:_start_impact(arg_12_1, arg_12_2, true, false, _check_overlap)
	end

	if arg_12_4 or not self:_check_wall_collision(arg_12_1, arg_12_2, arg_12_3) then
		self:_start_impact(arg_12_1, arg_12_2, false, true)
	end
end

local tbl = {}

BTChargePositionAction._check_overlap = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not arg_13_2.is_illusion then
		return false, false
	end

	local time = Managers.time:time("game")
	local radius = arg_13_3.radius
	local head_radius = arg_13_3.head_radius
	local hit_units = arg_13_2.hit_units
	local pushed_units = arg_13_2.pushed_units
	local local_position = Unit.local_position(arg_13_1, 0)
	local world_position = Unit.world_position(arg_13_1, Unit.node(arg_13_1, "j_head"))
	local forward = Quaternion.forward(Unit.local_rotation(arg_13_1, 0))
	local ENEMY_PLAYER_AND_BOT_UNITS = arg_13_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_13_9 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local var_13_10 = POSITION_LOOKUP[var_13_9]
		local normalize = Vector3.normalize(var_13_10 - local_position)
		local num = var_13_10 - local_position
		local length = Vector3.length(num)

		if Vector3.dot(normalize, forward) > 0 then
			local extension = ScriptUnit.extension(var_13_9, "status_system")

			if not extension and not extension:get_is_dodging() then
				head_radius = arg_13_3.target_dodged_radius
			end

			local var_13_15 = hit_units[var_13_9]
			local var_13_16 = pushed_units[var_13_9]

			if not ((var_13_15 or not (length < head_radius) or not extension) and extension:is_invisible()) then
				self:_hit_player(arg_13_1, arg_13_2, var_13_9, arg_13_3, normalize)

				hit_units[var_13_9] = true
			elseif not ((var_13_15 or var_13_16 or not (length < radius) or not extension) and extension:is_invisible()) then
				self:_push_player(arg_13_1, var_13_9, arg_13_2, arg_13_3)

				pushed_units[var_13_9] = true
			end
		end
	end

	local broadphase = arg_13_2.group_blackboard.broadphase
	local hit_ai_radius = arg_13_3.hit_ai_radius
	local query = Broadphase.query(broadphase, local_position, hit_ai_radius, tbl)

	for j = 1, query do
		local var_13_20 = tbl[j]
		local var_13_21 = POSITION_LOOKUP[var_13_20]
		local normalize_2 = Vector3.normalize(var_13_21 - local_position)

		if not (not (Vector3.dot(normalize_2, forward) > 0) or var_13_20 == arg_13_1 or hit_units[var_13_20]) then
			self:_hit_ai(arg_13_1, var_13_20, arg_13_3, arg_13_2, time)
		end

		hit_units[var_13_20] = true
		tbl[j] = nil
	end

	return hit_units[arg_13_2.target_unit]
end

BTChargePositionAction._charged_at_player = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	return
end

BTChargePositionAction._push_player = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local num = POSITION_LOOKUP[arg_15_2] - POSITION_LOOKUP[arg_15_1]
	local num_2 = arg_15_4.dodge_past_push_speed * Vector3.normalize(num)

	Vector3.set_z(num_2, 3)
	StatusUtils.set_catapulted_network(arg_15_2, true, num_2)
end

BTChargePositionAction._hit_player = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local has_extension = ScriptUnit.has_extension(arg_16_3, "status_system")
	local check_block = DamageUtils.check_block(arg_16_1, arg_16_3, arg_16_4.fatigue_type)
	local check_ranged_block = DamageUtils.check_ranged_block
	local var_16_3 = arg_16_1
	local var_16_4 = arg_16_3
	local shield_blocked_fatigue_type = arg_16_4.shield_blocked_fatigue_type

	shield_blocked_fatigue_type = shield_blocked_fatigue_type or "ogre_shove"

	local var_16_6 = check_ranged_block(var_16_3, var_16_4, shield_blocked_fatigue_type)

	if not (var_16_6 or check_block) then
		AiUtils.damage_target(arg_16_3, arg_16_1, arg_16_4, arg_16_4.damage)
	end

	if not (not arg_16_4.player_push_speed and has_extension.knocked_down) then
		if not var_16_6 then
			self:_charged_at_player(arg_16_1, arg_16_3, arg_16_2, arg_16_4)
		else
			self:_push_player(arg_16_1, arg_16_3, arg_16_2, arg_16_4, var_16_6 or check_block)
		end
	end

	return check_block
end

BTChargePositionAction._hit_ai = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	local push_ai = arg_17_3.push_ai
	local var_17_1 = BLACKBOARDS[arg_17_2]
	local breed = var_17_1.breed

	breed = not breed and var_17_1.breed.name

	if Managers.state.side.side_by_unit[arg_17_1] == Managers.state.side.side_by_unit[arg_17_2] then
		return
	end

	if not push_ai then
		local calculate_stagger, var_17_4 = DamageUtils.calculate_stagger(push_ai.stagger_impact, push_ai.stagger_duration, arg_17_2, arg_17_1)

		if calculate_stagger > scripts_utils_stagger_types.none then
			local var_17_5 = POSITION_LOOKUP[arg_17_1]
			local var_17_6 = POSITION_LOOKUP[arg_17_2]
			local normalize = Vector3.normalize(var_17_6 - var_17_5)
			local local_rotation = Unit.local_rotation(arg_17_1, 0)
			local right = Quaternion.right(local_rotation)
			local forward = Quaternion.forward(local_rotation)
			local dot = Vector3.dot(right, normalize)
			local num = -right

			if dot > 0 then
				num = -num
			end

			local normalize_2 = Vector3.normalize(num + forward)

			AiUtils.stagger(arg_17_2, var_17_1, arg_17_1, normalize_2, push_ai.stagger_distance, calculate_stagger, var_17_4, nil, arg_17_5, nil, nil, nil, true)

			if breed == "chaos_warrior" then
				local breed_2 = arg_17_4.breed

				breed_2 = not breed_2 and arg_17_4.breed.name

				if breed_2 == "beastmen_bestigor" then
					local str = "scorpion_bestigor_charge_chaos_warrior"
					local var_17_16 = NetworkLookup.statistics[str]
					local statistics_db = Managers.player:statistics_db()
					local stats_id = Managers.player:local_player():stats_id()

					statistics_db:increment_stat(stats_id, str)
					Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_17_16)
				end
			end
		end
	end

	if not arg_17_3.ignore_ai_damage then
		AiUtils.damage_target(arg_17_2, arg_17_1, arg_17_3, arg_17_3.damage)
	end

	AiUtils.alert_nearby_friends_of_enemy(arg_17_1, arg_17_4.group_blackboard.broadphase, arg_17_2)
end

BTChargePositionAction._check_wall_collision = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local wall_collision_check_range = arg_18_2.action.wall_collision_check_range
	local num = 1
	local num_2 = 1
	local nav_world = arg_18_2.nav_world
	local var_18_4 = POSITION_LOOKUP[arg_18_1]
	local triangle_from_position, var_18_6 = GwNavQueries.triangle_from_position(nav_world, var_18_4, num, num_2)

	if not triangle_from_position then
		return true
	end

	local current_velocity = arg_18_2.locomotion_extension:current_velocity()
	local length = Vector3.length(current_velocity)
	local var_18_9

	if length > 0.01 then
		var_18_9 = Vector3.normalize(current_velocity)
	else
		local local_rotation = Unit.local_rotation(arg_18_1, 0)

		var_18_9 = Quaternion.forward(local_rotation)
	end

	local num_3 = var_18_4 + var_18_9 * (wall_collision_check_range + arg_18_3 * length)
	local triangle_from_position_2, var_18_13 = GwNavQueries.triangle_from_position(nav_world, num_3, num, num_2)

	if not triangle_from_position_2 then
		if arg_18_2.action.ignore_ledge_death or not self:_is_at_edge(arg_18_1, arg_18_2, var_18_4, var_18_9) then
			local str = "charge_death"

			AiUtils.kill_unit(arg_18_1, arg_18_1, "torso", str, Vector3.normalize(current_velocity))

			arg_18_2.charge_state = "finished"

			return false
		end

		return true
	end

	local var_18_15 = Vector3(var_18_4.x, var_18_4.y, var_18_6)
	local var_18_16 = Vector3(num_3.x, num_3.y, var_18_13)
	local traverse_logic = arg_18_2.navigation_extension:traverse_logic()

	return not GwNavQueries.raycango(nav_world, var_18_15, var_18_16, traverse_logic)
end

BTChargePositionAction._is_at_edge = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local get_data = World.get_data(arg_19_2.world, "physics_world")
	local num = arg_19_3 + Vector3(0, 0, 1)
	local num_2 = 4
	local num_3 = num + arg_19_4 * num_2
	local num_4 = num_3 - num

	if not PhysicsWorld.raycast(get_data, num, num_4, num_2, "closest", "collision_filter", "filter_ai_line_of_sight_check") then
		return false
	end

	local var_19_5 = num_3
	local num_5 = 4
	local num_6 = num_3 + -Vector3.up() * num_5 - var_19_5

	if not PhysicsWorld.raycast(get_data, var_19_5, num_6, num_5, "closest", "collision_filter", "filter_ai_line_of_sight_check") then
		return true
	end
end

BTChargePositionAction._check_smartobjects = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not BTConditions.at_smartobject(arg_20_2) then
		if not BTConditions.at_door_smartobject(arg_20_2) then
			local unit = arg_20_2.next_smart_object_data.smart_object_data.unit

			if not Unit.alive(unit) then
				AiUtils.kill_unit(unit, arg_20_1)
			end
		else
			self:_pause_charge(arg_20_1, arg_20_2)
		end
	end
end

BTChargePositionAction._run_starting = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local unbox = arg_21_2.requested_charge_position:unbox()
	local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_21_1, unbox)

	arg_21_2.locomotion_extension:set_wanted_rotation(look_at_position_flat)
end

BTChargePositionAction._run_approaching = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local navigation_extension = arg_22_2.navigation_extension

	if not arg_22_2.no_path_found then
		if not arg_22_2.cancel_approaching_t then
			arg_22_2.cancel_approaching_t = arg_22_3 + 2
		elseif arg_22_3 > arg_22_2.cancel_approaching_t then
			self:_cancel_charge(arg_22_1, arg_22_2)

			return
		end
	else
		arg_22_2.cancel_approaching_t = nil
	end

	if not arg_22_2.ray_can_go_to_target then
		navigation_extension:set_enabled(false)
		self:_start_charging(arg_22_1, arg_22_2)

		return
	end

	local unbox = arg_22_2.requested_charge_position:unbox()

	navigation_extension:move_to(unbox)

	local action = arg_22_2.action

	self:_check_overlap(arg_22_1, arg_22_2, action)
	self:_check_smartobjects(arg_22_1, arg_22_2)
	self:_update_animation_movement_speed(arg_22_1, arg_22_2, arg_22_4)

	local current_velocity = arg_22_2.locomotion_extension:current_velocity()
	local look = Quaternion.look(current_velocity)

	arg_22_2.locomotion_extension:set_wanted_rotation(look)

	local num = 4
	local get_current_and_node_position_in_nav_path, var_22_7 = navigation_extension:get_current_and_node_position_in_nav_path(num)

	if not (get_current_and_node_position_in_nav_path == nil or var_22_7 ~= nil) then
		return
	end

	local normalize = Vector3.normalize(var_22_7 - get_current_and_node_position_in_nav_path)
	local _get_turn_slowdown_percentage = self:_get_turn_slowdown_percentage(arg_22_1, arg_22_2, arg_22_4, normalize)

	if not _get_turn_slowdown_percentage then
		local num_2 = arg_22_2.action.charge_speed_min * _get_turn_slowdown_percentage

		navigation_extension:set_max_speed(num_2)
	end

	if arg_22_3 - arg_22_2.action_enter_t > action.max_charge_t then
		self:_cancel_charge(arg_22_1, arg_22_2)

		return
	end

	local var_22_11 = POSITION_LOOKUP[arg_22_1]
	local unbox_2 = arg_22_2.last_frame_pos:unbox()
	local distance = Vector3.distance(var_22_11, unbox_2)

	arg_22_2.total_distance_ran = arg_22_2.total_distance_ran + distance

	arg_22_2.last_frame_pos:store(var_22_11)

	if arg_22_2.total_distance_ran > action.max_charge_distance then
		self:_cancel_charge(arg_22_1, arg_22_2)

		return
	end
end

BTChargePositionAction._run_charging = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	if arg_23_2.requested_charge_position ~= arg_23_2.charge_position then
		self:_pause_charge(arg_23_1, arg_23_2)

		return
	end

	if not arg_23_2.ray_can_go_to_target then
		self:_start_approaching(arg_23_1, arg_23_2)

		return
	end

	local action = arg_23_2.action

	if not action.allow_target_unit_override and not arg_23_2.using_override_target and not ALIVE[arg_23_2.target_unit] then
		arg_23_2.requested_charge_position:store(POSITION_LOOKUP[arg_23_2.target_unit])
	end

	local unbox = arg_23_2.requested_charge_position:unbox()
	local navigation_extension = arg_23_2.navigation_extension

	navigation_extension:move_to(unbox)

	local locomotion_extension = arg_23_2.locomotion_extension
	local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_23_1, unbox)

	locomotion_extension:set_wanted_rotation(look_at_position_flat)

	local num = arg_23_3 - arg_23_2.charge_started_at_t
	local charge_speed_min = action.charge_speed_min
	local charge_speed_max = action.charge_speed_max
	local num_2 = num / action.charge_max_speed_at
	local min = math.min(charge_speed_min + num_2 * (charge_speed_max - charge_speed_min), charge_speed_max)
	local num_3 = Quaternion.forward(Unit.local_rotation(arg_23_1, 0)) * min

	locomotion_extension:set_wanted_velocity(num_3)
	navigation_extension:set_max_speed(min)

	arg_23_2.current_charge_speed = min

	self:_check_unit_and_wall_collision(arg_23_1, arg_23_2, arg_23_4, false)
	self:_update_animation_movement_speed(arg_23_1, arg_23_2, arg_23_4)
	self:_check_smartobjects(arg_23_1, arg_23_2)

	if arg_23_3 - arg_23_2.action_enter_t > action.max_charge_t then
		self:_cancel_charge(arg_23_1, arg_23_2)

		return
	end

	local var_23_11 = POSITION_LOOKUP[arg_23_1]
	local unbox_2 = arg_23_2.last_frame_pos:unbox()

	if not (not action.allow_target_unit_override and not arg_23_2.using_override_target and ALIVE[arg_23_2.target_unit]) then
		local distance_to_target_sq = arg_23_2.distance_to_target_sq

		distance_to_target_sq = distance_to_target_sq or Vector3.distance_squared(unbox, var_23_11)

		local charge_start_pos = arg_23_2.charge_start_pos

		charge_start_pos = charge_start_pos or Vector3Box(var_23_11)

		if distance_to_target_sq < Vector3.distance_squared(charge_start_pos:unbox(), var_23_11) then
			self:_cancel_charge(arg_23_1, arg_23_2)

			return
		end

		arg_23_2.distance_to_target_sq = distance_to_target_sq
		arg_23_2.charge_start_pos = charge_start_pos
	else
		arg_23_2.distance_to_target_sq = nil
		arg_23_2.charge_start_pos = nil
	end

	local num_4 = var_23_11 - unbox_2
	local length = Vector3.length(num_4)

	arg_23_2.total_distance_ran = arg_23_2.total_distance_ran + length

	arg_23_2.last_frame_pos:store(var_23_11)

	if arg_23_2.total_distance_ran > action.max_charge_distance then
		self:_cancel_charge(arg_23_1, arg_23_2)

		return
	end
end

BTChargePositionAction._run_impact = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local hit_target_slow_down_speed

	if not arg_24_2.hit_target then
		hit_target_slow_down_speed = arg_24_2.action.hit_target_slow_down_speed

		if not hit_target_slow_down_speed then
			-- Nothing
		end
	end

	hit_target_slow_down_speed = arg_24_2.action.slow_down_speed

	::label_24_0::

	self:_slow_down(arg_24_1, arg_24_2, hit_target_slow_down_speed, arg_24_3, arg_24_4)

	if not arg_24_2.anim_cb_attack_finished then
		arg_24_2.charge_state = "finished"
	end
end

BTChargePositionAction._run_cancel = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	local cancel_slow_down_speed = arg_25_2.action.cancel_slow_down_speed

	self:_slow_down(arg_25_1, arg_25_2, cancel_slow_down_speed, arg_25_3, arg_25_4)

	if not arg_25_2.anim_cb_attack_finished then
		arg_25_2.charge_state = "finished"
	end
end

BTChargePositionAction._slow_down = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	local locomotion_extension = arg_26_2.locomotion_extension
	local current_velocity = locomotion_extension:current_velocity()
	local zero = Vector3.zero()
	local min = math.min(arg_26_5 * arg_26_3, 1)
	local lerp = Vector3.lerp(current_velocity, zero, min)

	locomotion_extension:set_wanted_velocity(lerp)
end

BTChargePositionAction._update_animation_movement_speed = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local current_velocity = arg_27_2.locomotion_extension:current_velocity()
	local length = Vector3.length(current_velocity)
	local animation_find_variable = Unit.animation_find_variable(arg_27_1, "move_speed")

	Unit.animation_set_variable(arg_27_1, animation_find_variable, length)
end

BTChargePositionAction._get_turn_slowdown_percentage = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local action = arg_28_2.action
	local local_rotation = Unit.local_rotation(arg_28_1, 0)
	local forward = Quaternion.forward(local_rotation)
	local dot = Vector3.dot(forward, arg_28_4)
	local radians_to_degrees = math.radians_to_degrees(math.acos(dot))
	local min_slowdown_angle = action.min_slowdown_angle
	local max_slowdown_angle = action.max_slowdown_angle

	if not (dot > 1 or not (radians_to_degrees <= min_slowdown_angle)) then
		return
	end

	return 1 - math.min((radians_to_degrees - min_slowdown_angle) / max_slowdown_angle, 1) * action.max_slowdown_percentage
end

BTChargePositionAction.anim_cb_charge_start_finished = function (self, arg_29_1, arg_29_2)
	-- function 29
	self:_start_charging(arg_29_1, arg_29_2)
end

BTChargePositionAction.anim_cb_charge_charging_finished = function (self, arg_30_1, arg_30_2)
	-- function 30
	if arg_30_2.charge_state == "charging" then
		self:_start_impact(arg_30_1, arg_30_2)
	end
end

BTChargePositionAction.anim_cb_disable_charge_collision = function (arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	arg_31_2.anim_cb_disable_charge_collision = true
end

BTChargePositionAction.anim_cb_attack_finished = function (arg_32_0, arg_32_1, arg_32_2)
	-- function 32
	arg_32_2.anim_cb_attack_finished = true
end
