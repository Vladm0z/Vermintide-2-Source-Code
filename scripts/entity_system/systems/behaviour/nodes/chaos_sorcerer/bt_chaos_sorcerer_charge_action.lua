-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_charge_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

BTChaosSorcererChargeAction = class(BTChaosSorcererChargeAction, BTNode)

BTChaosSorcererChargeAction.init = function (arg_1_0, ...)
	-- function 1
	BTChaosSorcererChargeAction.super.init(arg_1_0, ...)
end

BTChaosSorcererChargeAction.name = "BTChaosSorcererChargeAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTChaosSorcererChargeAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTChaosSorcererChargeAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.locked_attack_rotation = false
	arg_3_2.ray_can_go_update_time = arg_3_3
	arg_3_2.attack_token = true
	arg_3_2.test_start_time = arg_3_3 + 1
	arg_3_2.charge_target_position = Vector3Box(0, 0, 0)
	arg_3_2.charge_target_unit = arg_3_2.target_unit
	arg_3_2.lunge_data = action_data.lunge

	local var_3_1 = fn(action_data.start_animation)

	Managers.state.network:anim_event(arg_3_1, var_3_1)

	arg_3_2.spawn_to_running = nil
	arg_3_2.charge_state = "starting"

	local navigation_extension = arg_3_2.navigation_extension
	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:set_wanted_velocity(Vector3.zero())
	navigation_extension:set_enabled(false)
	navigation_extension:reset_destination()
	locomotion_extension:use_lerp_rotation(true)

	arg_3_2.stored_rotation = QuaternionBox(Quaternion.identity())
	arg_3_2.hit_units = {}
	arg_3_2.pushed_units = {}

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	ScriptUnit.extension(arg_3_1, "hit_reaction_system").force_ragdoll_on_death = true

	AiUtils.add_attack_intensity(arg_3_2.charge_target_unit, action_data, arg_3_2)

	arg_3_2.lean_target_position_boxed = Vector3Box()
	arg_3_2.old_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table()

	local get_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table("charge")

	if not get_navtag_layer_cost_table then
		local traverse_logic = arg_3_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, get_navtag_layer_cost_table)
	end
end

BTChaosSorcererChargeAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if arg_4_2.move_state == "idle" or not HEALTH_ALIVE[arg_4_1] then
		if not arg_4_2.blocked then
			Managers.state.network:anim_event(arg_4_1, "idle")
		end

		arg_4_2.move_state = "idle"
	end

	arg_4_2.attack_token = false

	if not HEALTH_ALIVE[arg_4_1] then
		local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
		local navigation_extension = arg_4_2.navigation_extension

		navigation_extension:set_enabled(true)
		navigation_extension:set_max_speed(get_default_breed_move_speed)
		arg_4_2.locomotion_extension:set_rotation_speed(nil)

		local traverse_logic = arg_4_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, arg_4_2.old_navtag_layer_cost_table)

		arg_4_2.old_navtag_layer_cost_table = nil
		ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil

		arg_4_2.locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)
	end

	local has_extension = ScriptUnit.has_extension(arg_4_2.charge_target_unit, "status_system")

	if not has_extension then
		local num_charges_targeting_player = has_extension.num_charges_targeting_player

		num_charges_targeting_player = num_charges_targeting_player or 0
		has_extension.num_charges_targeting_player = num_charges_targeting_player - 1

		StatusUtils.set_charged_network(arg_4_2.charge_target_unit, false)
	end

	if not (not arg_4_2.stagger and arg_4_2.charge_state == "charging" or arg_4_2.charge_state ~= "lunge" or arg_4_2.anim_cb_disable_charge_collision) then
		arg_4_2.charge_stagger = true
	end

	arg_4_2.action = nil
	arg_4_2.active_node = nil
	arg_4_2.anim_cb_disable_charge_collision = nil
	arg_4_2.attack_aborted = nil
	arg_4_2.charge_target_unit = nil
	arg_4_2.charge_started_at_t = nil
	arg_4_2.charge_state = nil
	arg_4_2.current_charge_speed = nil
	arg_4_2.hit_target = nil
	arg_4_2.hit_units = nil
	arg_4_2.lean_target_position_boxed = nil
	arg_4_2.pushed_units = nil
	arg_4_2.stop_lunge_rotation = nil
	arg_4_2.stored_rotation = nil
	arg_4_2.target_lunge_position = nil
	arg_4_2.target_unit_status_extension = nil
	arg_4_2.triggered_dodge_sound = nil
	arg_4_2.charge_target_position = nil
	arg_4_2.lunge_data = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)
end

BTChaosSorcererChargeAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local charge_target_unit = arg_5_2.charge_target_unit

	if not Unit.alive(charge_target_unit) then
		return "done"
	end

	if not arg_5_2.attack_aborted then
		return "done"
	end

	local charge_state = arg_5_2.charge_state

	if charge_state == "starting" then
		if arg_5_3 > arg_5_2.test_start_time then
			self:anim_cb_start_finished(arg_5_1, arg_5_2)

			arg_5_2.test_start_time = nil
		end
	elseif charge_state == "impact" then
		local test_start_time = arg_5_2.test_start_time

		test_start_time = test_start_time or arg_5_3 + 1
		arg_5_2.test_start_time = test_start_time

		if arg_5_3 > arg_5_2.test_start_time then
			self:anim_cb_charge_impact_finished(arg_5_1, arg_5_2)

			arg_5_2.test_start_time = arg_5_3 + 1
		end
	end

	if not (arg_5_3 > arg_5_2.ray_can_go_update_time) or not Unit.alive(charge_target_unit) then
		local nav_world = arg_5_2.nav_world
		local var_5_4 = POSITION_LOOKUP[charge_target_unit]

		arg_5_2.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(nav_world, POSITION_LOOKUP[arg_5_1], var_5_4, nil, 1, 1)
		arg_5_2.ray_can_go_update_time = arg_5_3 + 0.25
	end

	local var_5_5

	if charge_state == "starting" then
		self:_run_starting(arg_5_1, arg_5_2)
	elseif charge_state == "charging" then
		if not self:_run_charging(arg_5_1, arg_5_2, arg_5_3, arg_5_4) then
			return "done"
		end
	elseif charge_state == "finished" then
		return "done"
	elseif charge_state == "cancel" then
		self:_run_cancel(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	end

	return "running", var_5_5
end

BTChaosSorcererChargeAction._start_charging = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local action = arg_6_2.action
	local time = Managers.time:time("game")

	arg_6_2.charge_state = "charging"

	arg_6_2.locomotion_extension:set_rotation_speed(action.charge_rotation_speed)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_sorcerer_boss_fly_charge", arg_6_1)

	arg_6_2.charge_started_at_t = time
end

BTChaosSorcererChargeAction._start_lunge = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	arg_7_2.charge_state = "lunge"
	arg_7_2.time_to_impact = arg_7_5 + 0.25

	local enter_thresholds = arg_7_3.enter_thresholds
	local _pick_distance_identifier = self:_pick_distance_identifier(enter_thresholds, arg_7_4)

	if not arg_7_3.animations then
		local var_7_2 = arg_7_3.animations[_pick_distance_identifier]
	end

	local locomotion_extension = arg_7_2.locomotion_extension
	local current_velocity = locomotion_extension:current_velocity()
	local var_7_5 = arg_7_3.velocity_scaling[_pick_distance_identifier]
	local num = arg_7_4 / enter_thresholds[_pick_distance_identifier]

	locomotion_extension:set_wanted_velocity(current_velocity * var_7_5 * num)
	locomotion_extension:set_rotation_speed(arg_7_3.rotation_speed)

	arg_7_2.current_lunge_velocity_scale = var_7_5
end

BTChaosSorcererChargeAction._start_impact = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	arg_8_2.charge_state = "impact"
	arg_8_2.hit_target = arg_8_3
end

BTChaosSorcererChargeAction._start_align_to_target = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local action = arg_9_2.action

	if not action.align_to_target_animation then
		arg_9_2.charge_state = "finished"

		return
	end

	local charge_target_unit = arg_9_2.charge_target_unit
	local world_position = Unit.world_position(charge_target_unit, 0)
	local world_position_2 = Unit.world_position(arg_9_1, 0)
	local normalize = Vector3.normalize(world_position_2 - world_position)
	local forward = Quaternion.forward(Unit.local_rotation(arg_9_1, 0))
	local dot = Vector3.dot(forward, normalize)

	if not (not (dot >= 0.4) or dot <= 1) then
		arg_9_2.charge_state = "finished"

		return
	end

	local time = Managers.time:time("game")

	arg_9_2.charge_state = "align_to_target"

	local align_to_target_animation = action.align_to_target_animation
	local var_9_9 = time

	arg_9_2.end_align_t, arg_9_2.start_align_t = time + action.end_align_t, var_9_9

	arg_9_2.locomotion_extension:use_lerp_rotation(true)
end

BTChaosSorcererChargeAction._cancel_charge = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	arg_10_2.navigation_extension:set_enabled(false)

	local cancel_animation = arg_10_2.action.cancel_animation

	arg_10_2.charge_state = "cancel"

	arg_10_2.locomotion_extension:set_rotation_speed(nil)
end

BTChaosSorcererChargeAction._check_lunge = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local action = arg_11_2.action

	self:_check_overlap(arg_11_1, arg_11_2, action)

	if arg_11_3 > arg_11_2.time_to_impact then
		self:_start_impact(arg_11_1, arg_11_2, true, false, false)
	end
end

local tbl = {}

BTChaosSorcererChargeAction._check_overlap = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local time = Managers.time:time("game")
	local radius = arg_12_3.radius
	local hit_radius = arg_12_3.hit_radius
	local hit_units = arg_12_2.hit_units
	local pushed_units = arg_12_2.pushed_units
	local num = Unit.local_position(arg_12_1, 0) - Vector3.down()
	local world_position = Unit.world_position(arg_12_1, Unit.node(arg_12_1, "j_head"))
	local forward = Quaternion.forward(Unit.local_rotation(arg_12_1, 0))
	local var_12_8
	local var_12_9
	local ENEMY_PLAYER_AND_BOT_UNITS = arg_12_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_12_11 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local var_12_12 = POSITION_LOOKUP[var_12_11]
		local normalize = Vector3.normalize(var_12_12 - num)
		local num_2 = var_12_12 - num
		local length = Vector3.length(num_2)
		local extension = ScriptUnit.extension(var_12_11, "status_system")

		if not extension and not extension:get_is_dodging() then
			hit_radius = arg_12_3.target_dodged_radius
		end

		local var_12_17 = hit_units[var_12_11]
		local var_12_18 = pushed_units[var_12_11]

		if not ((var_12_17 or not (length < hit_radius) or not extension) and extension:is_invisible()) then
			var_12_8, var_12_9 = self:_hit_player(arg_12_1, arg_12_2, var_12_11, arg_12_3, normalize)
			hit_units[var_12_11] = true
		elseif not ((var_12_17 or var_12_18 or not (length < radius) or not extension) and extension:is_invisible()) then
			self:_push_player(arg_12_1, var_12_11, arg_12_2, arg_12_3)

			pushed_units[var_12_11] = true
		end
	end

	local broadphase = arg_12_2.group_blackboard.broadphase
	local hit_ai_radius = arg_12_3.hit_ai_radius
	local query = Broadphase.query(broadphase, num, hit_ai_radius, tbl)

	for j = 1, query do
		local var_12_22 = tbl[j]
		local var_12_23 = POSITION_LOOKUP[var_12_22]
		local normalize_2 = Vector3.normalize(var_12_23 - num)

		if not (not (Vector3.dot(normalize_2, forward) > 0) or var_12_22 == arg_12_1 or hit_units[var_12_22]) then
			self:_hit_ai(arg_12_1, var_12_22, arg_12_3, arg_12_2, time)
		end

		hit_units[var_12_22] = true
		tbl[j] = nil
	end

	return var_12_8, var_12_9
end

BTChaosSorcererChargeAction._charged_at_player = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	if not arg_13_4.catapult_player then
		local num = POSITION_LOOKUP[arg_13_2] - POSITION_LOOKUP[arg_13_1]
		local current_velocity = arg_13_3.locomotion_extension:current_velocity()
		local num_2 = Vector3.length(current_velocity) * Vector3.normalize(num)
		local set_z = Vector3.set_z
		local var_13_4 = num_2
		local catapult_force_z = arg_13_4.catapult_force_z

		catapult_force_z = catapult_force_z or 3

		set_z(var_13_4, catapult_force_z)
		StatusUtils.set_catapulted_network(arg_13_2, true, num_2)
	else
		StatusUtils.set_charged_network(arg_13_2, true)
	end
end

BTChaosSorcererChargeAction._push_player = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local num = POSITION_LOOKUP[arg_14_2] - POSITION_LOOKUP[arg_14_1]
	local num_2 = arg_14_4.dodge_past_push_speed * Vector3.normalize(num)

	if arg_14_2 == arg_14_3.charge_target_unit or not arg_14_4.catapult_on_push_other_targets then
		local catapult_on_push_z = arg_14_4.catapult_on_push_z

		Vector3.set_z(num_2, catapult_on_push_z or 3)
		StatusUtils.set_catapulted_network(arg_14_2, true, num_2)
	else
		if not arg_14_5 and not arg_14_4.blocked_velocity_scale then
			num_2 = num_2 * arg_14_4.blocked_velocity_scale
		end

		ScriptUnit.extension(arg_14_2, "locomotion_system"):add_external_velocity(num_2)
	end
end

BTChaosSorcererChargeAction._hit_player = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local flag = arg_15_3 == arg_15_2.charge_target_unit
	local has_extension = ScriptUnit.has_extension(arg_15_3, "status_system")

	AiUtils.damage_target(arg_15_3, arg_15_1, arg_15_4, arg_15_4.damage)

	if not (not arg_15_4.player_push_speed and has_extension.knocked_down) then
		self:_charged_at_player(arg_15_1, arg_15_3, arg_15_2, arg_15_4)
	end

	if not flag then
		return true
	end

	return false
end

BTChaosSorcererChargeAction._hit_ai = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	local push_ai = arg_16_3.push_ai
	local var_16_1 = BLACKBOARDS[arg_16_2]

	if not push_ai then
		local calculate_stagger, var_16_3 = DamageUtils.calculate_stagger(push_ai.stagger_impact, push_ai.stagger_duration, arg_16_2, arg_16_1)

		if calculate_stagger > scripts_utils_stagger_types.none then
			local var_16_4 = POSITION_LOOKUP[arg_16_1]
			local var_16_5 = POSITION_LOOKUP[arg_16_2]
			local normalize = Vector3.normalize(var_16_5 - var_16_4)
			local right = Quaternion.right(Unit.local_rotation(arg_16_1, 0))
			local dot = Vector3.dot(right, normalize)
			local num = -right

			if dot > 0 then
				num = -num
			end

			AiUtils.stagger(arg_16_2, var_16_1, arg_16_1, num, push_ai.stagger_distance, calculate_stagger, var_16_3, nil, arg_16_5, nil, nil, nil, true)
		end
	end

	AiUtils.damage_target(arg_16_2, arg_16_1, arg_16_3, arg_16_3.damage)
end

BTChaosSorcererChargeAction._run_starting = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_17_1, arg_17_2.charge_target_unit)

	arg_17_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	arg_17_2.charge_target_position:store(POSITION_LOOKUP[arg_17_2.charge_target_unit])
end

BTChaosSorcererChargeAction._run_charging = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local action = arg_18_2.action
	local unbox = arg_18_2.charge_target_position:unbox()
	local locomotion_extension = arg_18_2.locomotion_extension
	local navigation_extension = arg_18_2.navigation_extension
	local var_18_4 = POSITION_LOOKUP[arg_18_1]
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_18_1, arg_18_2.charge_target_unit)

	locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	arg_18_2.stored_rotation:store(rotation_towards_unit_flat)

	local num = arg_18_3 - arg_18_2.charge_started_at_t
	local charge_speed_min = action.charge_speed_min
	local charge_speed_max = action.charge_speed_max
	local num_2 = num / action.charge_max_speed_at
	local min = math.min(charge_speed_min + num_2 * (charge_speed_max - charge_speed_min), charge_speed_max)
	local normalize = Vector3.normalize(Vector3.flat(unbox - var_18_4))
	local _get_turn_slowdown_percentage = self:_get_turn_slowdown_percentage(arg_18_1, arg_18_2, arg_18_4, normalize)

	if not _get_turn_slowdown_percentage then
		min = charge_speed_max * _get_turn_slowdown_percentage
	end

	navigation_extension:set_max_speed(min)

	local num_3 = Quaternion.forward(Unit.local_rotation(arg_18_1, 0)) * min

	locomotion_extension:set_wanted_velocity(num_3)

	arg_18_2.current_charge_speed = min

	local distance = Vector3.distance(var_18_4, unbox)
	local lunge_data = arg_18_2.lunge_data

	if not (not lunge_data and not (distance <= lunge_data.enter_thresholds.far)) then
		return true
	end

	return false
end

BTChaosSorcererChargeAction._run_lunge = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	local locomotion_extension = arg_19_2.locomotion_extension
	local var_19_1

	locomotion_extension:use_lerp_rotation(false)
	locomotion_extension:set_rotation_speed(nil)

	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_19_1)
	local rotation = Matrix4x4.rotation(animation_wanted_root_pose)

	locomotion_extension:set_wanted_rotation(rotation)

	local rotation_slow_down_speed = arg_19_3.rotation_slow_down_speed

	self:_check_lunge(arg_19_1, arg_19_2, arg_19_4)
	self:_slow_down(arg_19_1, arg_19_2, rotation_slow_down_speed, arg_19_4, arg_19_5)
end

BTChaosSorcererChargeAction._run_impact = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	if not arg_20_2.hit_target then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_20_1, arg_20_2.charge_target_unit)

		arg_20_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	elseif not arg_20_2.hit_during_impact_t and not (arg_20_3 < arg_20_2.hit_during_impact_t) or not self:_check_overlap(arg_20_1, arg_20_2, arg_20_2.action) then
		arg_20_2.hit_during_impact_t = nil
	end

	local hit_target_slow_down_speed

	if not arg_20_2.hit_target then
		hit_target_slow_down_speed = arg_20_2.action.hit_target_slow_down_speed

		if not hit_target_slow_down_speed then
			-- Nothing
		end
	end

	hit_target_slow_down_speed = arg_20_2.action.slow_down_speed

	::label_20_0::

	self:_slow_down(arg_20_1, arg_20_2, hit_target_slow_down_speed, arg_20_3, arg_20_4)
end

BTChaosSorcererChargeAction._run_cancel = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local cancel_slow_down_speed = arg_21_2.action.cancel_slow_down_speed

	self:_slow_down(arg_21_1, arg_21_2, cancel_slow_down_speed, arg_21_3, arg_21_4)
end

BTChaosSorcererChargeAction._pick_distance_identifier = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	local var_22_0
	local var_22_1
	local num = 0

	for k, v in pairs(arg_22_1) do
		if not (not (arg_22_2 < v) or not (num < arg_22_2)) then
			var_22_0 = k

			break
		end

		num = v
		var_22_1 = k
	end

	var_22_0 = var_22_0 or var_22_1

	return var_22_0
end

BTChaosSorcererChargeAction._slow_down = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	local locomotion_extension = arg_23_2.locomotion_extension
	local current_velocity = locomotion_extension:current_velocity()
	local zero = Vector3.zero()
	local min = math.min(arg_23_5 * arg_23_3, 1)
	local lerp = Vector3.lerp(current_velocity, zero, min)

	locomotion_extension:set_wanted_velocity(lerp)
end

BTChaosSorcererChargeAction._get_turn_slowdown_percentage = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local action = arg_24_2.action
	local local_rotation = Unit.local_rotation(arg_24_1, 0)
	local forward = Quaternion.forward(local_rotation)
	local dot = Vector3.dot(forward, arg_24_4)
	local radians_to_degrees = math.radians_to_degrees(math.acos(dot))
	local min_slowdown_angle = action.min_slowdown_angle
	local max_slowdown_angle = action.max_slowdown_angle

	if not (dot > 1 or not (radians_to_degrees <= min_slowdown_angle)) then
		return
	end

	return 1 - math.min((radians_to_degrees - min_slowdown_angle) / max_slowdown_angle, 1) * action.max_slowdown_percentage
end

BTChaosSorcererChargeAction.anim_cb_start_finished = function (self, arg_25_1, arg_25_2)
	-- function 25
	self:_start_charging(arg_25_1, arg_25_2)

	if not Managers.state.network:game() then
		local charge_notification_sound_event = arg_25_2.action.charge_notification_sound_event

		if not charge_notification_sound_event and not Unit.alive(arg_25_2.charge_target_unit) then
			local network_id = Managers.player:unit_owner(arg_25_2.charge_target_unit):network_id()

			Managers.state.network.network_transmit:send_rpc("rpc_server_audio_event", network_id, NetworkLookup.sound_events[charge_notification_sound_event])
		end
	end
end

BTChaosSorcererChargeAction.anim_cb_charge_charging_finished = function (self, arg_26_1, arg_26_2)
	-- function 26
	if arg_26_2.charge_state == "charging" then
		self:_start_impact(arg_26_1, arg_26_2)
	end
end

BTChaosSorcererChargeAction.anim_cb_charge_impact_finished = function (self, arg_27_1, arg_27_2)
	-- function 27
	self:_start_align_to_target(arg_27_1, arg_27_2)
end

BTChaosSorcererChargeAction.anim_cb_attack_finished = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	return
end

BTChaosSorcererChargeAction.anim_cb_disable_charge_collision = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	arg_29_2.anim_cb_disable_charge_collision = true
end
