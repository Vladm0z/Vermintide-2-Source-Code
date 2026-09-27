-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_charge_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

BTChargeAttackAction = class(BTChargeAttackAction, BTNode)

BTChargeAttackAction.init = function (arg_1_0, ...)
	-- function 1
	BTChargeAttackAction.super.init(arg_1_0, ...)
end

BTChargeAttackAction.name = "BTChargeAttackAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTChargeAttackAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTChargeAttackAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.locked_attack_rotation = false
	arg_3_2.ray_can_go_update_time = arg_3_3
	arg_3_2.attack_token = true
	arg_3_2.anim_cb_charge_impact_finished = nil
	arg_3_2.lunge_data = action_data.lunge

	local target_unit = arg_3_2.target_unit
	local has_extension = ScriptUnit.has_extension(target_unit, "status_system")

	if not has_extension then
		local num_charges_targeting_player = has_extension.num_charges_targeting_player

		num_charges_targeting_player = num_charges_targeting_player or 0
		has_extension.num_charges_targeting_player = num_charges_targeting_player + 1
	end

	arg_3_2.animation_movement_extension = ScriptUnit.has_extension(arg_3_1, "animation_movement_system")

	local network = Managers.state.network

	arg_3_2.target_unit_status_extension = has_extension

	local var_3_5 = fn(action_data.start_animation)

	network:anim_event(arg_3_1, var_3_5)

	arg_3_2.spawn_to_running = nil
	arg_3_2.charge_state = "starting"
	arg_3_2.attacking_target = arg_3_2.target_unit

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

	AiUtils.add_attack_intensity(target_unit, action_data, arg_3_2)

	arg_3_2.lean_target_position_boxed = Vector3Box()

	AiUtils.alert_nearby_friends_of_enemy(arg_3_1, arg_3_2.group_blackboard.broadphase, arg_3_2.attacking_target, 8)

	arg_3_2.old_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table()

	local get_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table("charge")

	if not get_navtag_layer_cost_table then
		local traverse_logic = arg_3_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, get_navtag_layer_cost_table)
	end
end

BTChargeAttackAction.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not arg_4_2.action.fallback_to_idle and arg_4_2.move_state == "idle" or not HEALTH_ALIVE[arg_4_1] then
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

	local has_extension = ScriptUnit.has_extension(arg_4_2.attacking_target, "status_system")

	if not has_extension then
		local num_charges_targeting_player = has_extension.num_charges_targeting_player

		num_charges_targeting_player = num_charges_targeting_player or 0
		has_extension.num_charges_targeting_player = num_charges_targeting_player - 1

		StatusUtils.set_charged_network(arg_4_2.attacking_target, false)
	end

	if not (not arg_4_2.stagger and arg_4_2.charge_state == "charging" and arg_4_2.charge_state == "approaching" or arg_4_2.charge_state ~= "lunge" or arg_4_2.anim_cb_disable_charge_collision) then
		arg_4_2.charge_stagger = true
	end

	arg_4_2.action = nil
	arg_4_2.active_node = nil
	arg_4_2.anim_cb_disable_charge_collision = nil
	arg_4_2.anim_cb_rotation_stop = nil
	arg_4_2.attack_aborted = nil
	arg_4_2.attacking_target = nil
	arg_4_2.cancel_approaching_t = nil
	arg_4_2.charge_started_at_t = nil
	arg_4_2.charge_state = nil
	arg_4_2.current_charge_speed = nil
	arg_4_2.current_lean_direction = nil
	arg_4_2.current_lean_value = nil
	arg_4_2.has_valid_astar_path = nil
	arg_4_2.hit_target = nil
	arg_4_2.hit_units = nil
	arg_4_2.lean_during_lunge = nil
	arg_4_2.lean_target_position_boxed = nil
	arg_4_2.lean_time = nil
	arg_4_2.lean_variable = nil
	arg_4_2.lean_variables = nil
	arg_4_2.pushed_units = nil
	arg_4_2.ran_past_target_timer = nil
	arg_4_2.start_slowing_down_at_t = nil
	arg_4_2.stop_lunge_rotation = nil
	arg_4_2.stored_position = nil
	arg_4_2.stored_rotation = nil
	arg_4_2.target_lunge_position = nil
	arg_4_2.target_unit_status_extension = nil
	arg_4_2.triggered_dodge_sound = nil

	self:_set_leaning_enabled(arg_4_1, arg_4_2, false)

	arg_4_2.animation_movement_extension = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)
end

BTChargeAttackAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local attacking_target = arg_5_2.attacking_target

	if not Unit.alive(attacking_target) then
		return "done"
	end

	if not arg_5_2.attack_aborted then
		return "done"
	end

	local charge_state = arg_5_2.charge_state

	if not (arg_5_3 > arg_5_2.ray_can_go_update_time) or not Unit.alive(attacking_target) then
		local nav_world = arg_5_2.nav_world
		local var_5_3 = POSITION_LOOKUP[attacking_target]

		arg_5_2.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(nav_world, POSITION_LOOKUP[arg_5_1], var_5_3, nil, 1, 1)
		arg_5_2.ray_can_go_update_time = arg_5_3 + 0.25
	end

	local var_5_4

	if charge_state == "starting" then
		self:_run_starting(arg_5_1, arg_5_2)
	elseif charge_state == "approaching" then
		self:_run_approaching(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif charge_state == "charging" then
		self:_run_charging(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif charge_state == "pre_lunge" then
		self:_run_pre_lunge(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif charge_state == "lunge" then
		self:_run_lunge(arg_5_1, arg_5_2, arg_5_2.lunge_data, arg_5_3, arg_5_4)
	elseif charge_state == "impact" then
		self:_run_impact(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif charge_state == "align_to_target" then
		self:_run_align_to_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif charge_state == "finished" then
		return "done"
	elseif charge_state == "cancel" then
		self:_run_cancel(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	end

	return "running", var_5_4
end

BTChargeAttackAction._start_charging = function (self, arg_6_1, arg_6_2)
	-- function 6
	local action = arg_6_2.action
	local time = Managers.time:time("game")
	local _select_charging_animation_and_duration, var_6_3 = self:_select_charging_animation_and_duration(action, arg_6_1, arg_6_2.attacking_target, arg_6_2)

	self:_set_leaning_enabled(arg_6_1, arg_6_2, true)

	arg_6_2.charge_state = "charging"
	arg_6_2.charge_tracking_duration = time + var_6_3

	Managers.state.network:anim_event(arg_6_1, _select_charging_animation_and_duration)
	arg_6_2.locomotion_extension:set_rotation_speed(action.charge_rotation_speed)

	arg_6_2.charge_started_at_t = time

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "incoming_attack", DialogueSettings.special_proximity_distance_heard, "enemy_tag", arg_6_2.breed.name)
end

BTChargeAttackAction._start_approaching = function (self, arg_7_1, arg_7_2)
	-- function 7
	local action = arg_7_2.action

	arg_7_2.charge_state = "approaching"

	self:_set_leaning_enabled(arg_7_1, arg_7_2, true)

	local navigation_extension = arg_7_2.navigation_extension
	local current_charge_speed = arg_7_2.current_charge_speed

	current_charge_speed = current_charge_speed or action.charge_speed_min

	navigation_extension:set_enabled(true)
	navigation_extension:set_max_speed(current_charge_speed)

	arg_7_2.move_state = "moving"
end

BTChargeAttackAction._start_lunge = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local action = arg_8_2.action
	local max_angle_to_allow = arg_8_3.max_angle_to_allow

	if not max_angle_to_allow then
		local var_8_2 = POSITION_LOOKUP[arg_8_1]
		local var_8_3 = POSITION_LOOKUP[arg_8_2.attacking_target]
		local normalize = Vector3.normalize(var_8_3 - var_8_2)
		local forward = Quaternion.forward(Unit.local_rotation(arg_8_1, 0))
		local dot = Vector3.dot(forward, normalize)

		if max_angle_to_allow < math.radians_to_degrees(math.acos(dot)) then
			self:_cancel_charge(arg_8_1, arg_8_2)

			return
		end
	end

	arg_8_2.charge_state = "lunge"

	self:_set_leaning_enabled(arg_8_1, arg_8_2, true)

	local enter_thresholds = arg_8_3.enter_thresholds
	local _pick_distance_identifier = self:_pick_distance_identifier(enter_thresholds, arg_8_4)

	if not arg_8_3.animations then
		local var_8_9 = arg_8_3.animations[_pick_distance_identifier]

		Managers.state.network:anim_event(arg_8_1, var_8_9)
	elseif not arg_8_3.lean_variables then
		arg_8_2.lean_during_lunge = true
		arg_8_2.lean_downwards = true

		self:_update_leaning_position(arg_8_1, arg_8_2, 0, Vector3:zero())
	end

	local locomotion_extension = arg_8_2.locomotion_extension
	local current_velocity = locomotion_extension:current_velocity()
	local var_8_12 = arg_8_3.velocity_scaling[_pick_distance_identifier]
	local num = 1 + arg_8_4 / enter_thresholds[_pick_distance_identifier]

	locomotion_extension:set_wanted_velocity(current_velocity * var_8_12 * num)
	locomotion_extension:set_rotation_speed(arg_8_3.rotation_speed)

	arg_8_2.current_lunge_velocity_scale = var_8_12

	if not action.slow_down_start_time then
		arg_8_2.start_slowing_down_at_t = arg_8_5 + action.slow_down_start_time
	end
end

BTChargeAttackAction._start_impact = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	local action = arg_9_2.action

	arg_9_2.charge_state = "impact"

	self:_set_leaning_enabled(arg_9_1, arg_9_2, false)

	local locomotion_extension = arg_9_2.locomotion_extension

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
	else
		locomotion_extension:set_wanted_rotation(arg_9_2.stored_rotation:unbox())
	end

	if not arg_9_6 then
		local hit_during_impact_t = action.hit_during_impact_t

		if not hit_during_impact_t then
			arg_9_2.hit_during_impact_t = Managers.time:time("game") + hit_during_impact_t
		end
	end

	arg_9_2.hit_target = arg_9_3
end

BTChargeAttackAction._start_align_to_target = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local action = arg_10_2.action

	if not action.align_to_target_animation then
		arg_10_2.charge_state = "finished"

		return
	end

	local attacking_target = arg_10_2.attacking_target
	local world_position = Unit.world_position(attacking_target, 0)
	local world_position_2 = Unit.world_position(arg_10_1, 0)
	local normalize = Vector3.normalize(world_position_2 - world_position)
	local forward = Quaternion.forward(Unit.local_rotation(arg_10_1, 0))
	local dot = Vector3.dot(forward, normalize)

	if not (not (dot >= 0.4) or dot <= 1) then
		arg_10_2.charge_state = "finished"

		return
	end

	local time = Managers.time:time("game")

	arg_10_2.charge_state = "align_to_target"

	local align_to_target_animation = action.align_to_target_animation

	Managers.state.network:anim_event(arg_10_1, align_to_target_animation)

	local var_10_9 = time

	arg_10_2.end_align_t, arg_10_2.start_align_t = time + action.end_align_t, var_10_9

	arg_10_2.locomotion_extension:use_lerp_rotation(true)
end

BTChargeAttackAction._cancel_charge = function (self, arg_11_1, arg_11_2)
	-- function 11
	arg_11_2.navigation_extension:set_enabled(false)

	local cancel_animation = arg_11_2.action.cancel_animation

	Managers.state.network:anim_event(arg_11_1, cancel_animation)

	arg_11_2.charge_state = "cancel"

	arg_11_2.locomotion_extension:set_rotation_speed(nil)
	self:_set_leaning_enabled(arg_11_1, arg_11_2, false)
end

BTChargeAttackAction._check_unit_and_wall_collision = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local action = arg_12_2.action
	local _check_overlap, var_12_2 = self:_check_overlap(arg_12_1, arg_12_2, action)

	if not _check_overlap then
		self:_start_impact(arg_12_1, arg_12_2, true, false, var_12_2)
	end

	if arg_12_4 or not self:_check_wall_collision(arg_12_1, arg_12_2, arg_12_3) then
		self:_start_impact(arg_12_1, arg_12_2, false, true)
	end
end

local tbl = {}

BTChargeAttackAction._check_overlap = function (self, arg_13_1, arg_13_2, arg_13_3)
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
	local var_13_8
	local var_13_9
	local side = arg_13_2.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_13_12 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local var_13_13 = POSITION_LOOKUP[var_13_12]
		local normalize = Vector3.normalize(var_13_13 - local_position)
		local num = var_13_13 - local_position
		local length = Vector3.length(num)

		if Vector3.dot(normalize, forward) > 0 then
			local extension = ScriptUnit.extension(var_13_12, "status_system")

			if not extension and not extension:get_is_dodging() then
				head_radius = arg_13_3.target_dodged_radius
			end

			local var_13_18 = hit_units[var_13_12]
			local var_13_19 = pushed_units[var_13_12]

			if not ((var_13_18 or not (length < head_radius) or not extension) and extension:is_invisible()) then
				var_13_8, var_13_9 = self:_hit_player(arg_13_1, arg_13_2, var_13_12, arg_13_3, normalize)
				hit_units[var_13_12] = true
			elseif not ((var_13_18 or var_13_19 or not (length < radius) or not extension) and extension:is_invisible()) then
				self:_push_player(arg_13_1, var_13_12, arg_13_2, arg_13_3)

				pushed_units[var_13_12] = true
			end
		end
	end

	local broadphase = arg_13_2.group_blackboard.broadphase
	local hit_ai_radius = arg_13_3.hit_ai_radius
	local var_13_22

	if not arg_13_3.ignore_friendly_ai then
		var_13_22 = side.enemy_broadphase_categories
	end

	local query = Broadphase.query(broadphase, local_position, hit_ai_radius, tbl, var_13_22)

	for j = 1, query do
		local var_13_24 = tbl[j]
		local var_13_25 = POSITION_LOOKUP[var_13_24]
		local normalize_2 = Vector3.normalize(var_13_25 - local_position)

		if not (not (Vector3.dot(normalize_2, forward) > 0) or var_13_24 == arg_13_1 or hit_units[var_13_24]) then
			self:_hit_ai(arg_13_1, var_13_24, arg_13_3, arg_13_2, time)
		end

		var_13_8 = var_13_8 or var_13_24 == arg_13_2.target_unit
		hit_units[var_13_24] = true
		tbl[j] = nil
	end

	return var_13_8, var_13_9
end

BTChargeAttackAction._charged_at_player = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if not arg_14_4.catapult_player then
		local num = POSITION_LOOKUP[arg_14_2] - POSITION_LOOKUP[arg_14_1]
		local current_velocity = arg_14_3.locomotion_extension:current_velocity()
		local num_2 = Vector3.length(current_velocity) * Vector3.normalize(num)
		local set_z = Vector3.set_z
		local var_14_4 = num_2
		local catapult_force_z = arg_14_4.catapult_force_z

		catapult_force_z = catapult_force_z or 3

		set_z(var_14_4, catapult_force_z)
		StatusUtils.set_catapulted_network(arg_14_2, true, num_2)
	else
		StatusUtils.set_charged_network(arg_14_2, true)
	end
end

BTChargeAttackAction._push_player = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local num = POSITION_LOOKUP[arg_15_2] - POSITION_LOOKUP[arg_15_1]
	local num_2 = arg_15_4.dodge_past_push_speed * Vector3.normalize(num)

	if arg_15_2 == arg_15_3.attacking_target or not arg_15_4.catapult_on_push_other_targets then
		local catapult_on_push_z = arg_15_4.catapult_on_push_z

		Vector3.set_z(num_2, catapult_on_push_z or 3)
		StatusUtils.set_catapulted_network(arg_15_2, true, num_2)
	else
		if not arg_15_5 and not arg_15_4.blocked_velocity_scale then
			num_2 = num_2 * arg_15_4.blocked_velocity_scale
		end

		ScriptUnit.extension(arg_15_2, "locomotion_system"):add_external_velocity(num_2)
	end
end

BTChargeAttackAction._hit_player = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local flag = arg_16_3 == arg_16_2.attacking_target
	local has_extension = ScriptUnit.has_extension(arg_16_3, "status_system")
	local flag_2 = not not arg_16_4.unblockable_by_normal_blocks or DamageUtils.check_block(arg_16_1, arg_16_3, arg_16_4.fatigue_type)
	local check_ranged_block = DamageUtils.check_ranged_block
	local var_16_4 = arg_16_1
	local var_16_5 = arg_16_3
	local shield_blocked_fatigue_type = arg_16_4.shield_blocked_fatigue_type

	shield_blocked_fatigue_type = shield_blocked_fatigue_type or "ogre_shove"

	local var_16_7 = check_ranged_block(var_16_4, var_16_5, shield_blocked_fatigue_type)

	if not (not flag and var_16_7 or flag_2) then
		AiUtils.damage_target(arg_16_3, arg_16_1, arg_16_4, arg_16_4.damage)
	end

	if not (not arg_16_4.player_push_speed and has_extension.knocked_down) then
		if not (not flag and var_16_7) then
			self:_charged_at_player(arg_16_1, arg_16_3, arg_16_2, arg_16_4)
		else
			self:_push_player(arg_16_1, arg_16_3, arg_16_2, arg_16_4, var_16_7 or flag_2)
		end
	end

	if not flag then
		return true
	end

	return false
end

BTChargeAttackAction._hit_ai = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	local push_ai = arg_17_3.push_ai
	local immune_breeds = arg_17_3.immune_breeds
	local var_17_2 = BLACKBOARDS[arg_17_2]
	local breed = var_17_2.breed

	breed = not breed and var_17_2.breed.name

	if not immune_breeds and not immune_breeds[breed] then
		return
	end

	if not push_ai then
		local calculate_stagger, var_17_5 = DamageUtils.calculate_stagger(push_ai.stagger_impact, push_ai.stagger_duration, arg_17_2, arg_17_1)

		if calculate_stagger > scripts_utils_stagger_types.none then
			local var_17_6 = POSITION_LOOKUP[arg_17_1]
			local var_17_7 = POSITION_LOOKUP[arg_17_2]
			local normalize = Vector3.normalize(var_17_7 - var_17_6)
			local right = Quaternion.right(Unit.local_rotation(arg_17_1, 0))
			local dot = Vector3.dot(right, normalize)
			local num = -right

			if dot > 0 then
				num = -num
			end

			AiUtils.stagger(arg_17_2, var_17_2, arg_17_1, num, push_ai.stagger_distance, calculate_stagger, var_17_5, nil, arg_17_5, nil, nil, nil, true)

			if not (DEDICATED_SERVER or breed ~= "chaos_warrior") then
				local breed_2 = arg_17_4.breed

				breed_2 = not breed_2 and arg_17_4.breed.name

				if breed_2 == "beastmen_bestigor" then
					local str = "scorpion_bestigor_charge_chaos_warrior"
					local var_17_14 = NetworkLookup.statistics[str]
					local statistics_db = Managers.player:statistics_db()
					local stats_id = Managers.player:local_player():stats_id()

					statistics_db:increment_stat(stats_id, str)
					Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_17_14)
				end
			end
		end
	end

	if not arg_17_3.ignore_ai_damage then
		AiUtils.damage_target(arg_17_2, arg_17_1, arg_17_3, arg_17_3.damage)
	end

	if not arg_17_3.hit_ai_func then
		arg_17_3.hit_ai_func(arg_17_1, arg_17_4, arg_17_2, arg_17_3, arg_17_3)
	end

	AiUtils.alert_nearby_friends_of_enemy(arg_17_1, arg_17_4.group_blackboard.broadphase, arg_17_4.attacking_target)
end

BTChargeAttackAction._check_wall_collision = function (self, arg_18_1, arg_18_2, arg_18_3)
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

BTChargeAttackAction._is_at_edge = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
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

BTChargeAttackAction._check_smartobjects = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not BTConditions.at_smartobject(arg_20_2) then
		if not BTConditions.at_door_smartobject(arg_20_2) then
			local unit = arg_20_2.next_smart_object_data.smart_object_data.unit

			if not Unit.alive(unit) then
				AiUtils.kill_unit(unit, arg_20_1)
			end
		else
			self:_cancel_charge(arg_20_1, arg_20_2)
		end
	end
end

BTChargeAttackAction._run_starting = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_21_1, arg_21_2.attacking_target)

	arg_21_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
end

BTChargeAttackAction._run_approaching = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local navigation_extension = arg_22_2.navigation_extension

	if not arg_22_2.no_path_found then
		if not arg_22_2.cancel_approaching_t then
			arg_22_2.cancel_approaching_t = arg_22_3 + 2
		elseif arg_22_3 > arg_22_2.cancel_approaching_t then
			self:_cancel_charge(arg_22_1, arg_22_2)
		end
	else
		arg_22_2.cancel_approaching_t = nil
	end

	if not arg_22_2.ray_can_go_to_target then
		navigation_extension:set_enabled(false)
		self:_start_charging(arg_22_1, arg_22_2)
	else
		local attacking_target = arg_22_2.attacking_target
		local var_22_2 = POSITION_LOOKUP[attacking_target]
		local distance = Vector3.distance(POSITION_LOOKUP[arg_22_1], var_22_2)
		local lunge_data = arg_22_2.lunge_data

		if not (not lunge_data and not (distance <= lunge_data.enter_thresholds.short)) then
			self:_cancel_charge(arg_22_1, arg_22_2)
		else
			local num = 1
			local num_2 = 2
			local nav_world = arg_22_2.nav_world
			local triangle_from_position, var_22_9 = GwNavQueries.triangle_from_position(nav_world, var_22_2, num, num_2)

			if not triangle_from_position then
				local stored_position = arg_22_2.stored_position

				stored_position = stored_position or Vector3Box()
				arg_22_2.stored_position = stored_position

				local var_22_11 = Vector3(var_22_2.x, var_22_2.y, var_22_9)

				navigation_extension:move_to(var_22_11)
				arg_22_2.stored_position:store(var_22_11)
			elseif not arg_22_2.stored_position then
				local unbox = arg_22_2.stored_position:unbox()

				if Vector3.distance_squared(unbox, POSITION_LOOKUP[arg_22_1]) > 1 then
					navigation_extension:move_to(unbox)
				else
					self:_cancel_charge(arg_22_1, arg_22_2)
				end
			else
				local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, var_22_2, 3, 3, 1, 1)

				if not inside_position_from_outside_position then
					navigation_extension:move_to(inside_position_from_outside_position)
				else
					self:_cancel_charge(arg_22_1, arg_22_2)
				end
			end
		end
	end

	local action = arg_22_2.action

	self:_check_overlap(arg_22_1, arg_22_2, action)
	self:_check_smartobjects(arg_22_1, arg_22_2)
	self:_update_animation_movement_speed(arg_22_1, arg_22_2, arg_22_4)

	local num_3 = 4
	local get_current_and_node_position_in_nav_path, var_22_17 = navigation_extension:get_current_and_node_position_in_nav_path(num_3)

	if not (get_current_and_node_position_in_nav_path == nil or var_22_17 ~= nil) then
		return
	end

	local normalize = Vector3.normalize(var_22_17 - get_current_and_node_position_in_nav_path)
	local _get_turn_slowdown_percentage = self:_get_turn_slowdown_percentage(arg_22_1, arg_22_2, arg_22_4, normalize)

	if not _get_turn_slowdown_percentage then
		local current_charge_speed = arg_22_2.current_charge_speed

		current_charge_speed = current_charge_speed or arg_22_2.action.charge_speed_min

		local num_4 = current_charge_speed * _get_turn_slowdown_percentage

		navigation_extension:set_max_speed(num_4)
	end

	local var_22_22 = POSITION_LOOKUP[arg_22_1]

	Vector3.set_z(var_22_17, var_22_22[3])
	self:_update_leaning_position(arg_22_1, arg_22_2, arg_22_4, var_22_17)
end

BTChargeAttackAction._run_charging = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	if not arg_23_2.ray_can_go_to_target then
		self:_start_approaching(arg_23_1, arg_23_2)

		return
	end

	local action = arg_23_2.action
	local attacking_target = arg_23_2.attacking_target
	local locomotion_extension = arg_23_2.locomotion_extension
	local navigation_extension = arg_23_2.navigation_extension
	local var_23_4 = POSITION_LOOKUP[arg_23_1]
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_23_1, attacking_target)

	if arg_23_3 < arg_23_2.charge_tracking_duration then
		locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
		arg_23_2.stored_rotation:store(rotation_towards_unit_flat)
	else
		locomotion_extension:set_wanted_rotation(arg_23_2.stored_rotation:unbox())
	end

	local num = arg_23_3 - arg_23_2.charge_started_at_t
	local charge_speed_min = action.charge_speed_min
	local charge_speed_max = action.charge_speed_max
	local num_2 = num / action.charge_max_speed_at
	local min = math.min(charge_speed_min + num_2 * (charge_speed_max - charge_speed_min), charge_speed_max)
	local var_23_11
	local has_extension = ScriptUnit.has_extension(attacking_target, "locomotion_system")

	if not has_extension then
		var_23_11 = has_extension:current_velocity()

		if not var_23_11 then
			var_23_11 = has_extension:average_velocity()
		end
	else
		var_23_11 = Vector3.zero()
	end

	local num_3 = POSITION_LOOKUP[attacking_target] + var_23_11 * action.target_extrapolation_length_scale * arg_23_4
	local normalize = Vector3.normalize(Vector3.flat(num_3 - var_23_4))
	local _get_turn_slowdown_percentage = self:_get_turn_slowdown_percentage(arg_23_1, arg_23_2, arg_23_4, normalize)

	if not _get_turn_slowdown_percentage then
		min = charge_speed_max * _get_turn_slowdown_percentage
	end

	navigation_extension:set_max_speed(min)

	local num_4 = Quaternion.forward(Unit.local_rotation(arg_23_1, 0)) * min

	locomotion_extension:set_wanted_velocity(num_4)

	arg_23_2.current_charge_speed = min

	if charge_speed_max <= min then
		if not arg_23_2.stop_charge_at_t then
			arg_23_2.stop_charge_at_t = arg_23_3 + action.charge_at_max_speed_duration
		elseif arg_23_3 > arg_23_2.stop_charge_at_t then
			self:_cancel_charge(arg_23_1, arg_23_2)
		end
	end

	self:_check_unit_and_wall_collision(arg_23_1, arg_23_2, arg_23_4, false)

	local distance = Vector3.distance(var_23_4, num_3)
	local lunge_data = arg_23_2.lunge_data

	if not (not lunge_data and not (distance <= lunge_data.enter_thresholds.far)) then
		self:_start_lunge(arg_23_1, arg_23_2, lunge_data, distance, arg_23_3)
	end

	Vector3.set_z(num_3, var_23_4[3])
	self:_update_leaning_position(arg_23_1, arg_23_2, arg_23_4, num_3)
	self:_update_animation_movement_speed(arg_23_1, arg_23_2, arg_23_4)
	self:_check_smartobjects(arg_23_1, arg_23_2)
end

BTChargeAttackAction._run_lunge = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	local locomotion_extension = arg_24_2.locomotion_extension
	local action = arg_24_2.action
	local slow_down_speed = action.slow_down_speed

	if not (not arg_24_3.get_position_at_distance and arg_24_2.target_lunge_position) then
		local get_position_at_distance = arg_24_3.get_position_at_distance
		local var_24_4 = POSITION_LOOKUP[arg_24_2.attacking_target]
		local var_24_5 = POSITION_LOOKUP[arg_24_1]

		if get_position_at_distance >= Vector3.distance(var_24_5, var_24_4) then
			arg_24_2.target_lunge_position = Vector3Box(var_24_4)

			local look = Quaternion.look(var_24_4 - var_24_5, Vector3.up())
			local var_24_7 = Vector3(2.5, arg_24_3.get_position_at_distance + 4, 2)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_24_4 + (var_24_4 - var_24_5) * 0.5, "oobb", var_24_7, look, 1, "Charge Attack")

			if not arg_24_3.get_position_duration then
				arg_24_2.get_lunge_position_duration = arg_24_4 + arg_24_3.get_position_duration
			end
		elseif not arg_24_2.ray_can_go_to_target then
			self:_start_impact(arg_24_1, arg_24_2, false, false, false, true)
		end
	end

	if not arg_24_2.stop_lunge_rotation then
		if not arg_24_2.anim_cb_rotation_stop then
			locomotion_extension:set_wanted_rotation(arg_24_2.stored_rotation:unbox())

			arg_24_2.stop_lunge_rotation = true
		else
			local var_24_8

			if not arg_24_2.target_lunge_position then
				local normalize = Vector3.normalize(arg_24_2.target_lunge_position:unbox() - POSITION_LOOKUP[arg_24_1])
				local forward = Quaternion.forward(Unit.local_rotation(arg_24_1, 0))
				local dot = Vector3.dot(forward, normalize)
				local get_lunge_position_duration = arg_24_2.get_lunge_position_duration

				if not (dot < 0 or get_lunge_position_duration < arg_24_4 or arg_24_2.ray_can_go_to_target) then
					self:_start_impact(arg_24_1, arg_24_2, false, false, false, true)
				end

				var_24_8 = Quaternion.look(normalize)
			else
				var_24_8 = LocomotionUtils.rotation_towards_unit_flat(arg_24_1, arg_24_2.attacking_target)
			end

			locomotion_extension:set_wanted_rotation(var_24_8)
			arg_24_2.stored_rotation:store(var_24_8)

			if not arg_24_2.current_lunge_velocity_scale then
				local num = Quaternion.forward(Unit.local_rotation(arg_24_1, 0)) * arg_24_2.current_charge_speed

				locomotion_extension:set_wanted_velocity(num * arg_24_2.current_lunge_velocity_scale)
			end
		end

		if not arg_24_2.lean_during_lunge then
			self:_update_animation_movement_speed(arg_24_1, arg_24_2, arg_24_5)
		end
	else
		locomotion_extension:use_lerp_rotation(false)
		locomotion_extension:set_rotation_speed(nil)

		local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_24_1)
		local rotation = Matrix4x4.rotation(animation_wanted_root_pose)

		locomotion_extension:set_wanted_rotation(rotation)

		slow_down_speed = arg_24_3.rotation_slow_down_speed
	end

	if not arg_24_2.anim_cb_disable_charge_collision then
		self:_check_unit_and_wall_collision(arg_24_1, arg_24_2, arg_24_5, false)

		if not arg_24_2.triggered_dodge_sound then
			local has_extension = ScriptUnit.has_extension(arg_24_2.attacking_target, "status_system")

			if not (not has_extension and has_extension:get_is_dodging()) then
				local dodge_past_sound_event = action.dodge_past_sound_event

				dodge_past_sound_event = dodge_past_sound_event or "Play_generic_pushed_impact_small"

				Managers.state.entity:system("audio_system"):play_audio_unit_event(dodge_past_sound_event, arg_24_1)

				arg_24_2.triggered_dodge_sound = true
			end
		end
	end

	if not (not arg_24_2.start_slowing_down_at_t and not (arg_24_4 < arg_24_2.start_slowing_down_at_t)) then
		return
	end

	self:_slow_down(arg_24_1, arg_24_2, slow_down_speed, arg_24_4, arg_24_5)
	self:_check_smartobjects(arg_24_1, arg_24_2)
end

BTChargeAttackAction._run_impact = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	if not arg_25_2.hit_target then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_25_1, arg_25_2.attacking_target)

		arg_25_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	elseif not arg_25_2.hit_during_impact_t and not (arg_25_3 < arg_25_2.hit_during_impact_t) or not self:_check_overlap(arg_25_1, arg_25_2, arg_25_2.action) then
		arg_25_2.hit_during_impact_t = nil
	end

	local hit_target_slow_down_speed

	if not arg_25_2.hit_target then
		hit_target_slow_down_speed = arg_25_2.action.hit_target_slow_down_speed

		if not hit_target_slow_down_speed then
			-- Nothing
		end
	end

	hit_target_slow_down_speed = arg_25_2.action.slow_down_speed

	::label_25_0::

	self:_slow_down(arg_25_1, arg_25_2, hit_target_slow_down_speed, arg_25_3, arg_25_4)
end

BTChargeAttackAction._run_align_to_target = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	if arg_26_3 > arg_26_2.end_align_t then
		arg_26_2.charge_state = "finished"
	elseif arg_26_3 > arg_26_2.start_align_t then
		local start_align_t = arg_26_2.start_align_t
		local end_align_t = arg_26_2.end_align_t
		local num = end_align_t - start_align_t
		local num_2 = (end_align_t - arg_26_3) / num
		local local_rotation = Unit.local_rotation(arg_26_1, 0)
		local look = Quaternion.look(-Quaternion.right(local_rotation))
		local lerp = Quaternion.lerp(look, local_rotation, num_2)

		arg_26_2.locomotion_extension:set_wanted_rotation(lerp)
	end
end

BTChargeAttackAction._run_cancel = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local cancel_slow_down_speed = arg_27_2.action.cancel_slow_down_speed

	self:_slow_down(arg_27_1, arg_27_2, cancel_slow_down_speed, arg_27_3, arg_27_4)
end

BTChargeAttackAction._select_charging_animation_and_duration = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local charging_animations = arg_28_1.charging_animations
	local charging_distance_thresholds = arg_28_1.charging_distance_thresholds
	local tracking_durations = arg_28_1.tracking_durations
	local var_28_3 = POSITION_LOOKUP[arg_28_2]
	local var_28_4 = POSITION_LOOKUP[arg_28_3]

	var_28_4 = var_28_4 or Unit.world_position(arg_28_2, 0)

	local distance = Vector3.distance(Vector3.flat(var_28_3), Vector3.flat(var_28_4))
	local _pick_distance_identifier = self:_pick_distance_identifier(charging_distance_thresholds, distance)

	return charging_animations[_pick_distance_identifier], tracking_durations[_pick_distance_identifier]
end

BTChargeAttackAction._pick_distance_identifier = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0
	local var_29_1
	local num = 0

	for k, v in pairs(arg_29_1) do
		if not (not (arg_29_2 < v) or not (num < arg_29_2)) then
			var_29_0 = k

			break
		end

		num = v
		var_29_1 = k
	end

	var_29_0 = var_29_0 or var_29_1

	return var_29_0
end

BTChargeAttackAction._slow_down = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	-- function 30
	local locomotion_extension = arg_30_2.locomotion_extension
	local current_velocity = locomotion_extension:current_velocity()
	local zero = Vector3.zero()
	local min = math.min(arg_30_5 * arg_30_3, 1)
	local lerp = Vector3.lerp(current_velocity, zero, min)

	locomotion_extension:set_wanted_velocity(lerp)
end

BTChargeAttackAction._set_leaning_enabled = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local animation_movement_extension = arg_31_2.animation_movement_extension

	if not animation_movement_extension then
		local go_id = Managers.state.unit_storage:go_id(arg_31_1)

		if not (not arg_31_3 and animation_movement_extension.enabled) then
			Managers.state.network.network_transmit:send_rpc_all("rpc_enable_animation_movement_system", go_id, arg_31_3)
		elseif arg_31_3 or not animation_movement_extension.enabled then
			Managers.state.network.network_transmit:send_rpc_all("rpc_enable_animation_movement_system", go_id, arg_31_3)
		end
	end
end

BTChargeAttackAction._update_leaning_position = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	arg_32_2.lean_target_position_boxed:store(arg_32_4)
end

BTChargeAttackAction._update_animation_movement_speed = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	local current_velocity = arg_33_2.locomotion_extension:current_velocity()
	local length = Vector3.length(current_velocity)
	local animation_find_variable = Unit.animation_find_variable(arg_33_1, "move_speed")

	Unit.animation_set_variable(arg_33_1, animation_find_variable, length)
end

BTChargeAttackAction._get_turn_slowdown_percentage = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	-- function 34
	local action = arg_34_2.action
	local local_rotation = Unit.local_rotation(arg_34_1, 0)
	local forward = Quaternion.forward(local_rotation)
	local dot = Vector3.dot(forward, arg_34_4)
	local radians_to_degrees = math.radians_to_degrees(math.acos(dot))
	local min_slowdown_angle = action.min_slowdown_angle
	local max_slowdown_angle = action.max_slowdown_angle

	if not (dot > 1 or not (radians_to_degrees <= min_slowdown_angle)) then
		return
	end

	return 1 - math.min((radians_to_degrees - min_slowdown_angle) / max_slowdown_angle, 1) * action.max_slowdown_percentage
end

BTChargeAttackAction.anim_cb_charge_start_finished = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not arg_35_2.ray_can_go_to_target then
		self:_start_charging(arg_35_1, arg_35_2)
	else
		self:_start_approaching(arg_35_1, arg_35_2)
	end

	if not Managers.state.network:game() then
		local charge_notification_sound_event = arg_35_2.action.charge_notification_sound_event

		if not charge_notification_sound_event and not Unit.alive(arg_35_2.attacking_target) then
			local unit_owner = Managers.player:unit_owner(arg_35_2.attacking_target)

			if not unit_owner then
				local network_id = unit_owner:network_id()

				Managers.state.network.network_transmit:send_rpc("rpc_server_audio_event", network_id, NetworkLookup.sound_events[charge_notification_sound_event])
			end
		end
	end
end

BTChargeAttackAction.anim_cb_charge_charging_finished = function (self, arg_36_1, arg_36_2)
	-- function 36
	if arg_36_2.charge_state == "charging" then
		self:_start_impact(arg_36_1, arg_36_2)
	end
end

BTChargeAttackAction.anim_cb_charge_impact_finished = function (self, arg_37_1, arg_37_2)
	-- function 37
	self:_start_align_to_target(arg_37_1, arg_37_2)

	arg_37_2.anim_cb_charge_impact_finished = true
end

BTChargeAttackAction.anim_cb_disable_charge_collision = function (arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	arg_38_2.anim_cb_disable_charge_collision = true
end
