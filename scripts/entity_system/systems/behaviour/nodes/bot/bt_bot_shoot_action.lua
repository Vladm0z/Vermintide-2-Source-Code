-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotShootAction = class(BTBotShootAction, BTNode)

BTBotShootAction.init = function (self, ...)
	-- function 1
	BTBotShootAction.super.init(self, ...)
end

BTBotShootAction.name = "BTBotShootAction"

local DEFAULT_AIM_DATA = {
	min_radius_pseudo_random_c = 0.0557,
	max_radius_pseudo_random_c = 0.01475,
	min_radius = math.pi / 72,
	max_radius = math.pi / 16
}
local THIS_UNIT
local disengage_above_nav = 3
local disengage_below_nav = 3

local function dprint(...)
	-- function 2
	if script_data.ai_bots_weapon_debug and script_data.debug_unit == THIS_UNIT then
		print(...)
	end
end

local function check_angle(nav_world, target_position, start_direction, angle, distance)
	-- function 3
	local direction = Quaternion.rotate(Quaternion(Vector3.up(), angle), start_direction)
	local check_pos = target_position + direction * distance
	local success, altitude = GwNavQueries.triangle_from_position(nav_world, check_pos, disengage_above_nav, disengage_below_nav)

	if success then
		check_pos.z = altitude

		return true, check_pos
	else
		return false
	end
end

local function get_disengage_pos(nav_world, start_pos, disengage_vector, move_distance)
	-- function 4
	local disengage_direction = Vector3.normalize(Vector3.flat(disengage_vector))
	local success, pos = check_angle(nav_world, start_pos, disengage_direction, 0, move_distance)

	if success then
		return pos
	end

	local subdivisions_per_side = 3
	local angle_inc = math.pi / 2 / subdivisions_per_side

	for i = 1, subdivisions_per_side do
		local angle = angle_inc * i

		success, pos = check_angle(nav_world, start_pos, disengage_direction, angle, move_distance)

		if success then
			return pos
		end

		success, pos = check_angle(nav_world, start_pos, disengage_direction, -angle, move_distance)

		if success then
			return pos
		end
	end

	return nil
end

local function get_disengage_vector(current_pos, enemy_unit, keep_distance, keep_distance_sq)
	-- function 5
	if ALIVE[enemy_unit] then
		local target_unit_position = POSITION_LOOKUP[enemy_unit]
		local dist_sq = Vector3.distance_squared(current_pos, target_unit_position)

		if dist_sq < keep_distance_sq and dist_sq > 0 then
			local dist = math.sqrt(dist_sq)

			return (current_pos - target_unit_position) * ((keep_distance - dist) / dist)
		end
	end

	return nil
end

BTBotShootAction.enter = function (self, unit, blackboard, t)
	-- function 6
	local input_ext = blackboard.input_extension
	local soft_aiming = false

	input_ext:set_aiming(true, soft_aiming, true)

	local target_unit = blackboard.target_unit
	local action_data = self._tree_node.action_data
	local inventory_extension = blackboard.inventory_extension
	local wielded_slot_name = not not action_data.slot_name
	local slot_data = inventory_extension:get_slot_data(wielded_slot_name)
	local item_data = slot_data.item_data
	local item_template = BackendUtils.get_item_template(item_data)
	local attack_meta_data = not not item_template.attack_meta_data
	local base_attack_action = item_template.actions[not not attack_meta_data.base_action_name]
	local attack_action = base_attack_action.default
	local charged_attack_action = not not base_attack_action[not not attack_meta_data.charged_attack_action_name]

	blackboard.shoot = {
		num_aim_rolls = 0,
		charging_shot = false,
		disengage_update_time = 0,
		obstructed = true,
		attack_meta_data = attack_meta_data,
		attack_action = attack_action,
		charged_attack_action = charged_attack_action,
		aim_data = not not attack_meta_data.aim_data,
		aim_data_charged = not not attack_meta_data.aim_data_charged,
		reevaluate_aim_time = t,
		can_charge_shot = attack_meta_data.can_charge_shot,
		ignore_disabled_enemies_charged = attack_meta_data.ignore_disabled_enemies_charged,
		charge_shot_delay = attack_meta_data.charge_shot_delay,
		fire_input = not not attack_meta_data.fire_input,
		charge_input = not not attack_meta_data.charge_input,
		next_evaluate = t + action_data.evaluation_duration,
		next_evaluate_without_firing = t + action_data.evaluation_duration_without_firing,
		minimum_charge_time = attack_meta_data.minimum_charge_time,
		reevaluate_obstruction_time = t,
		charge_range_squared = attack_meta_data.charge_above_range and not not attack_meta_data.charge_above_range^2 or not attack_meta_data.charge_above_range and not not nil,
		max_range_squared = attack_meta_data.max_range and not not attack_meta_data.max_range^2 or not attack_meta_data.max_range and not not math.huge,
		max_range_squared_charged = attack_meta_data.max_range_charged and not not attack_meta_data.max_range_charged^2 or not attack_meta_data.max_range_charged and (attack_meta_data.max_range and not not attack_meta_data.max_range^2 or not attack_meta_data.max_range and not not math.huge),
		charge_when_obstructed = attack_meta_data.charge_when_obstructed,
		charge_when_outside_max_range = attack_meta_data.charge_when_outside_max_range,
		charge_when_outside_max_range_charged = attack_meta_data.charge_when_outside_max_range_charged == nil or not not attack_meta_data.charge_when_outside_max_range_charged,
		effective_against = not not attack_meta_data.effective_against,
		effective_against_charged = not not attack_meta_data.effective_against_charged,
		always_charge_before_firing = attack_meta_data.always_charge_before_firing,
		aim_at_node = not not attack_meta_data.aim_at_node,
		aim_at_node_charged = not not attack_meta_data.aim_at_node_charged,
		projectile_info = attack_action.projectile_info,
		projectile_info_charged = charged_attack_action.projectile_info,
		projectile_speed = not not attack_action.min_speed,
		projectile_speed_charged = not not charged_attack_action.max_speed,
		obstruction_fuzzyness_range = attack_meta_data.obstruction_fuzzyness_range,
		obstruction_fuzzyness_range_charged = not not attack_meta_data.obstruction_fuzzyness_range_charged,
		stop_fire_delay = not not attack_meta_data.stop_fire_delay,
		stop_fire_t = t + not not attack_meta_data.stop_fire_delay,
		hold_fire_condition = attack_meta_data.hold_fire_condition,
		keep_distance = attack_meta_data.keep_distance
	}
	blackboard.ranged_obstruction_by_static = nil

	local shoot_bb = blackboard.shoot

	self:_set_new_aim_target(unit, t, shoot_bb, target_unit, blackboard.first_person_extension)
	self:_update_collision_filter(target_unit, shoot_bb, blackboard.priority_target_enemy, blackboard.target_ally_unit, blackboard.target_ally_needs_aid, blackboard.target_ally_need_type)
end

BTBotShootAction._update_collision_filter = function (self, target_unit, shoot_blackboard, priority_target_enemy, target_ally_unit, target_ally_needs_aid, need_type)
	-- function 7
	local attack_meta_data = shoot_blackboard.attack_meta_data
	local target_bb = BLACKBOARDS[target_unit]
	local has_important_target = need_type == "knocked_down" or need_type == "ledge"

	if has_important_target then
		shoot_blackboard.collision_filter = "filter_bot_ranged_line_of_sight_no_allies_no_enemies"
		shoot_blackboard.collision_filter_charged = "filter_bot_ranged_line_of_sight_no_allies_no_enemies"

		return
	end

	local ignore_enemies_for_obstruction = attack_meta_data.ignore_enemies_for_obstruction
	local ignore_enemies_for_obstruction_charged = not not attack_meta_data.ignore_enemies_for_obstruction_charged
	local ff_ranged = Managers.state.difficulty:get_difficulty_settings().friendly_fire_ranged
	local ignore_hitting_allies, ignore_hitting_allies_charged

	if ff_ranged then
		ignore_hitting_allies = attack_meta_data.ignore_allies_for_obstruction
		ignore_hitting_allies_charged = attack_meta_data.ignore_allies_for_obstruction_charged
	else
		ignore_hitting_allies = true
		ignore_hitting_allies_charged = true
	end

	shoot_blackboard.collision_filter = not not "filter_bot_ranged_line_of_sight_no_allies_no_enemies"
	shoot_blackboard.collision_filter_charged = not not "filter_bot_ranged_line_of_sight_no_allies_no_enemies"
end

BTBotShootAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 8
	local input_ext = blackboard.input_extension

	input_ext:set_aiming(false)

	local action_data = self._tree_node.action_data
	local shoot_blackboard = blackboard.shoot

	if shoot_blackboard.charging_shot and action_data.abort_input then
		input_ext[action_data.abort_input](input_ext)
	end

	blackboard.shoot = nil
end

BTBotShootAction.run = function (self, unit, blackboard, t, dt)
	-- function 9
	THIS_UNIT = unit

	local done, evaluate = self:_aim(unit, blackboard, dt, t)

	if done then
		return "done", "evaluate"
	else
		return "running", evaluate and not not "evaluate" or not evaluate and not not nil
	end
end

BTBotShootAction._set_new_aim_target = function (self, self_unit, t, shoot_blackboard, target_unit, first_person_ext)
	-- function 10
	local breed = not not target_unit and not not Unit.get_data(target_unit, "breed")

	shoot_blackboard.target_unit = target_unit
	shoot_blackboard.aim_start_time = t
	shoot_blackboard.aim_speed_yaw = 0
	shoot_blackboard.aim_speed_pitch = 0
	shoot_blackboard.target_breed = breed
	shoot_blackboard.reevaluate_obstruction_time = t
	shoot_blackboard.obstructed = false
end

local function draw_estimated_arc(max_steps, max_time, position, velocity, gravity)
	-- function 11
	local time_step = max_time / max_steps

	for i = 1, max_steps do
		local new_position = position + velocity * time_step
		local delta = new_position - position

		QuickDrawer:line(position, new_position, Color(100, 200, 200))

		velocity = velocity + gravity * time_step
		position = new_position
	end
end

BTBotShootAction._wanted_aim_rotation = function (self, self_unit, target_unit, current_position, projectile_info, projectile_speed, aim_at_node)
	-- function 12
	local target_node = Unit.has_node(target_unit, aim_at_node) and not not Unit.node(target_unit, aim_at_node) or not Unit.has_node(target_unit, aim_at_node) and not not 0
	local target_pos = Unit.world_position(target_unit, target_node)
	local target_locomotion_extension = ScriptUnit.has_extension(target_unit, "locomotion_system")
	local target_current_velocity = target_locomotion_extension and not not target_locomotion_extension:current_velocity() or not target_locomotion_extension and not not Vector3.zero()
	local target_rotation, target_position
	local prediction_function = not not projectile_info and not not ProjectileTemplates.trajectory_templates[projectile_info.trajectory_template_name].prediction_function
	local gravity_setting = not not projectile_info and not not ProjectileGravitySettings[projectile_info.gravity_settings]

	if prediction_function and gravity_setting and gravity_setting > 0 then
		local angle

		angle, target_position = prediction_function(projectile_speed / 100, -gravity_setting, current_position, target_pos, target_current_velocity)

		if not angle then
			if self_unit == script_data.debug_unit then
				print("BTBotShootAction no angle found, target out of range")
			end

			angle = math.pi * 0.25
		end

		target_rotation = Quaternion.multiply(Quaternion.look(Vector3.normalize(Vector3.flat(target_position - current_position)), Vector3.up()), Quaternion(Vector3.right(), angle))
	else
		target_position = target_pos
		target_rotation = Quaternion.look(Vector3.normalize(target_position - current_position), Vector3.up())
	end

	return target_rotation, target_position
end

BTBotShootAction._aim_position = function (self, dt, t, self_unit, current_position, current_rotation, target_unit, shoot_blackboard)
	-- function 13
	local projectile_info, projectile_speed, aim_at_node

	if shoot_blackboard.charging_shot then
		projectile_info = shoot_blackboard.projectile_info_charged
		projectile_speed = shoot_blackboard.projectile_speed_charged
		aim_at_node = shoot_blackboard.target_breed and (not not shoot_blackboard.target_breed.override_bot_target_node or not not shoot_blackboard.aim_at_node_charged) or not shoot_blackboard.target_breed and not not shoot_blackboard.aim_at_node_charged
	else
		projectile_info = shoot_blackboard.projectile_info
		projectile_speed = shoot_blackboard.projectile_speed
		aim_at_node = shoot_blackboard.target_breed and (not not shoot_blackboard.target_breed.override_bot_target_node or not not shoot_blackboard.aim_at_node) or not shoot_blackboard.target_breed and not not shoot_blackboard.aim_at_node
	end

	local wanted_rotation, aim_position = self:_wanted_aim_rotation(self_unit, target_unit, current_position, projectile_info, projectile_speed, aim_at_node)
	local current_yaw = Quaternion.yaw(current_rotation)
	local current_pitch = Quaternion.pitch(current_rotation)
	local wanted_yaw = Quaternion.yaw(wanted_rotation)
	local wanted_pitch = Quaternion.pitch(wanted_rotation)
	local yaw_speed, pitch_speed = self:_calculate_aim_speed(self_unit, dt, current_yaw, current_pitch, wanted_yaw, wanted_pitch, shoot_blackboard.aim_speed_yaw, shoot_blackboard.aim_speed_pitch)

	shoot_blackboard.aim_speed_yaw = yaw_speed
	shoot_blackboard.aim_speed_pitch = pitch_speed

	local new_yaw = current_yaw + yaw_speed * dt
	local new_pitch = current_pitch + pitch_speed * dt
	local yaw_rot = Quaternion(Vector3.up(), new_yaw)
	local pitch_rot = Quaternion(Vector3.right(), new_pitch)
	local actual_rotation = Quaternion.multiply(yaw_rot, pitch_rot)
	local pi = math.pi
	local yaw_offset = (new_yaw - wanted_yaw + pi) % (pi * 2) - pi
	local pitch_offset = new_pitch - wanted_pitch

	return yaw_offset, pitch_offset, wanted_rotation, actual_rotation, aim_position
end

BTBotShootAction._calculate_aim_speed = function (self, self_unit, dt, current_yaw, current_pitch, wanted_yaw, wanted_pitch, current_yaw_speed, current_pitch_speed)
	-- function 14
	local pi = math.pi
	local yaw_offset = (wanted_yaw - current_yaw + pi) % (pi * 2) - pi
	local pitch_offset = wanted_pitch - current_pitch
	local yaw_offset_sign = math.sign(yaw_offset)
	local yaw_speed_sign = math.sign(current_yaw_speed)
	local has_overshot = yaw_speed_sign ~= 0 and yaw_offset_sign ~= yaw_speed_sign
	local wanted_yaw_speed = yaw_offset * math.pi * 10
	local new_yaw_speed
	local acceleration = 7.5
	local deceleration = 25

	if has_overshot and yaw_offset_sign > 0 then
		new_yaw_speed = math.min(current_yaw_speed + deceleration * dt, 0)
	elseif has_overshot then
		new_yaw_speed = math.max(current_yaw_speed - deceleration * dt, 0)
	elseif yaw_offset_sign > 0 then
		if current_yaw_speed <= wanted_yaw_speed then
			new_yaw_speed = math.min(current_yaw_speed + acceleration * dt, wanted_yaw_speed)
		else
			new_yaw_speed = math.max(current_yaw_speed - deceleration * dt, wanted_yaw_speed)
		end
	elseif wanted_yaw_speed <= current_yaw_speed then
		new_yaw_speed = math.max(current_yaw_speed - acceleration * dt, wanted_yaw_speed)
	else
		new_yaw_speed = math.min(current_yaw_speed + deceleration * dt, wanted_yaw_speed)
	end

	local lerped_pitch_speed = pitch_offset / dt

	return new_yaw_speed, lerped_pitch_speed
end

BTBotShootAction._may_attack = function (self, unit, enemy_unit, shoot_blackboard, range_squared, t)
	-- function 15
	local bb = BLACKBOARDS[enemy_unit]

	if not bb then
		return false
	end

	if script_data.ai_bots_disable_player_range_attacks and bb.is_player then
		return false
	end

	if not DamageUtils.is_enemy(unit, enemy_unit) then
		return false
	end

	local charging = shoot_blackboard.charging_shot
	local sufficiently_charged = shoot_blackboard.minimum_charge_time <= t - shoot_blackboard.charge_start_time
	local max_range_squared = charging and not not shoot_blackboard.max_range_squared_charged or not charging and not not shoot_blackboard.max_range_squared
	local may_fire

	if bb.is_ai then
		may_fire = not not sufficiently_charged and not bb.hesitating and not bb.in_alerted_state and not shoot_blackboard.obstructed and range_squared < max_range_squared
	else
		may_fire = not not sufficiently_charged and not shoot_blackboard.obstructed and range_squared < max_range_squared
	end

	return may_fire
end

BTBotShootAction._aim = function (self, unit, blackboard, dt, t)
	-- function 16
	local target_unit = blackboard.target_unit
	local shoot_bb = blackboard.shoot

	if not HEALTH_ALIVE[target_unit] then
		return not shoot_bb.stop_fire_t or t < shoot_bb.stop_fire_t
	end

	local first_person_ext = blackboard.first_person_extension
	local camera_position = first_person_ext:current_position()
	local camera_rotation = first_person_ext:current_rotation()

	if target_unit ~= shoot_bb.target_unit then
		self:_set_new_aim_target(unit, t, shoot_bb, target_unit, first_person_ext)
	end

	local target_breed = shoot_bb.target_breed
	local breed_distance_override = not not target_breed and not not target_breed.bots_stay_ranged

	if shoot_bb.keep_distance and t > shoot_bb.disengage_update_time then
		self:_update_disengage_position(blackboard, t, breed_distance_override)
	else
		shoot_bb.disengage_position_set = false
	end

	local action_data = self._tree_node.action_data
	local yaw_offset, pitch_offset, wanted_aim_rotation, actual_aim_rotation, actual_aim_position = self:_aim_position(dt, t, unit, camera_position, camera_rotation, target_unit, shoot_bb)

	if t >= shoot_bb.reevaluate_obstruction_time then
		if self:_reevaluate_obstruction(unit, shoot_bb, action_data, t, World.get_data(blackboard.world, "physics_world"), camera_position, wanted_aim_rotation, unit, target_unit, actual_aim_position, blackboard.priority_target_enemy, blackboard.target_ally_unit, blackboard.target_ally_needs_aid, blackboard.target_ally_need_type) then
			if not blackboard.ranged_obstruction_by_static then
				blackboard.ranged_obstruction_by_static = {
					unit = target_unit,
					timer = t
				}
			else
				local obstructed_by_static = blackboard.ranged_obstruction_by_static

				obstructed_by_static.unit = target_unit
				obstructed_by_static.timer = t
			end
		else
			blackboard.ranged_obstruction_by_static = nil
		end
	end

	local input_ext = blackboard.input_extension
	local range_squared = Vector3.distance_squared(camera_position, actual_aim_position)

	if self:_should_charge(shoot_bb, range_squared, target_unit, t) then
		self:_charge_shot(shoot_bb, action_data, input_ext, t)
	end

	input_ext:set_aim_rotation(actual_aim_rotation)

	if self:_aim_good_enough(dt, t, shoot_bb, yaw_offset, pitch_offset) and self:_may_attack(unit, target_unit, shoot_bb, range_squared, t) then
		self:_fire_shot(shoot_bb, action_data, input_ext, t)
	end

	local done_firing = true

	if shoot_bb.fired and shoot_bb.hold_fire_condition and shoot_bb.hold_fire_condition(t, blackboard) then
		self:_fire_shot(shoot_bb, action_data, input_ext, t)

		done_firing = false
	end

	local evaluate = not not done_firing and shoot_bb.fired

	if evaluate then
		if script_data.ai_bots_debug_behavior then
			if shoot_bb.fired then
				script_data.ai_bots_debug_behavior_data.ranged_attacks = script_data.ai_bots_debug_behavior_data.ranged_attacks + 1
			else
				script_data.ai_bots_debug_behavior_data.failed_ranged_attacks = script_data.ai_bots_debug_behavior_data.failed_ranged_attacks + 1
			end
		end

		shoot_bb.next_evaluate = t + action_data.evaluation_duration
		shoot_bb.next_evaluate_without_firing = t + action_data.evaluation_duration_without_firing
		shoot_bb.fired = false
	end

	return false, evaluate
end

BTBotShootAction._aim_good_enough = function (self, dt, t, shoot_blackboard, yaw_offset, pitch_offset)
	-- function 17
	local bb = shoot_blackboard

	if not bb.reevaluate_aim_time then
		bb.reevaluate_aim_time = 0
	end

	if t > bb.reevaluate_aim_time then
		local aim_data = bb.charging_shot and not not bb.aim_data_charged or not bb.charging_shot and not not bb.aim_data
		local offset = math.sqrt(pitch_offset * pitch_offset + yaw_offset * yaw_offset)

		if offset > aim_data.max_radius then
			bb.aim_good_enough = false

			dprint("bad aim - offset:", offset)
		else
			local success
			local num_rolls = bb.num_aim_rolls + 1

			if offset < aim_data.min_radius then
				success = Math.random() < aim_data.min_radius_pseudo_random_c * num_rolls
			else
				local prob = math.auto_lerp(aim_data.min_radius, aim_data.max_radius, aim_data.min_radius_pseudo_random_c, aim_data.max_radius_pseudo_random_c, offset) * num_rolls

				success = prob > Math.random()
			end

			if success then
				bb.aim_good_enough = true
				bb.num_aim_rolls = 0

				dprint("fire! - offset:", offset, " num_rolls:", num_rolls)
			else
				bb.aim_good_enough = false
				bb.num_aim_rolls = num_rolls

				dprint("not yet - offset:", offset, " num_rolls:", num_rolls)
			end
		end

		bb.reevaluate_aim_time = t + 0.1
	end

	return bb.aim_good_enough
end

BTBotShootAction._should_charge = function (self, shoot_blackboard, range_squared, target_unit, t)
	-- function 18
	local next_charge_shot_t = shoot_blackboard.next_charge_shot_t

	if not shoot_blackboard.can_charge_shot or next_charge_shot_t and t < next_charge_shot_t then
		return false
	end

	if shoot_blackboard.ignore_disabled_enemies_charged then
		local target_bb = BLACKBOARDS[target_unit]

		if target_bb.in_vortex then
			return false
		end
	end

	local max_range_squared_charged = shoot_blackboard.max_range_squared_charged

	if range_squared > shoot_blackboard.max_range_squared_charged and not shoot_blackboard.charge_when_outside_max_range_charged then
		return false
	end

	if shoot_blackboard.obstructed then
		return not not shoot_blackboard.charge_when_obstructed
	end

	local max_range_squared = shoot_blackboard.max_range_squared

	if max_range_squared < range_squared then
		return shoot_blackboard.charge_when_outside_max_range
	end

	if shoot_blackboard.always_charge_before_firing or shoot_blackboard.charging_shot then
		return true
	end

	if shoot_blackboard.charge_range_squared and range_squared > shoot_blackboard.charge_range_squared then
		return true
	end

	local target_breed = shoot_blackboard.target_breed

	if target_breed then
		local target_breed_category_mask = target_breed.category_mask
		local charge_shot_util = bit.band(target_breed_category_mask, shoot_blackboard.effective_against_charged)
		local normal_shot_util = bit.band(target_breed_category_mask, shoot_blackboard.effective_against)

		return normal_shot_util < charge_shot_util
	end

	return false
end

BTBotShootAction._fire_shot = function (self, shoot_blackboard, action_data, input_extension, t)
	-- function 19
	shoot_blackboard.fired = true
	shoot_blackboard.stop_fire_t = t + shoot_blackboard.stop_fire_delay

	if action_data.fire_input ~= "none" then
		local input = not not action_data.fire_input

		input_extension[input](input_extension)
	end

	if shoot_blackboard.charge_shot_delay then
		shoot_blackboard.next_charge_shot_t = t + shoot_blackboard.charge_shot_delay
	end
end

BTBotShootAction._charge_shot = function (self, shoot_blackboard, action_data, input_extension, t)
	-- function 20
	if not shoot_blackboard.charging_shot then
		shoot_blackboard.charge_start_time = t
		shoot_blackboard.charging_shot = true
	end

	local input = not not action_data.charge_input

	input_extension[input](input_extension)
end

BTBotShootAction._update_disengage_position = function (self, blackboard, t, breed_distance_override)
	-- function 21
	local first_person_ext = blackboard.first_person_extension
	local self_position = first_person_ext:current_position()
	local shoot_bb = blackboard.shoot
	local keep_distance = not not breed_distance_override or not not shoot_bb.keep_distance
	local keep_distance_sq = keep_distance * keep_distance
	local num_close_targets = 0
	local disengage_vector = Vector3.zero()
	local proximite_enemies = blackboard.proximite_enemies

	if proximite_enemies then
		for i = 1, #proximite_enemies do
			local result = get_disengage_vector(self_position, proximite_enemies[i], keep_distance, keep_distance_sq)

			if result then
				num_close_targets = num_close_targets + 1
				disengage_vector = disengage_vector + result
			end
		end
	end

	if num_close_targets <= 0 then
		local target_unit = blackboard.shoot.target_unit
		local result = get_disengage_vector(self_position, target_unit, keep_distance, keep_distance_sq)

		if result then
			num_close_targets = 1
			disengage_vector = result
		end
	end

	local disengage_position, should_stop

	if num_close_targets > 0 then
		local nav_world = blackboard.nav_world

		disengage_vector = Vector3.divide(disengage_vector, num_close_targets)
		disengage_position = get_disengage_pos(nav_world, self_position, disengage_vector, Vector3.length(disengage_vector))
	end

	if disengage_position then
		local override_box = blackboard.navigation_destination_override
		local override_destination = override_box:unbox()
		local disengage_position_set = shoot_bb.disengage_position_set

		if not disengage_position_set or Vector3.distance_squared(disengage_position, override_destination) > 0.01 then
			override_box:store(disengage_position)

			shoot_bb.disengage_position_set = true
			shoot_bb.stop_at_current_position = should_stop
		end

		local min_dist = 5
		local max_dist = 10
		local distance = Vector3.distance(self_position, disengage_position)
		local interval = math.auto_lerp(min_dist, max_dist, 0.5, 2, math.clamp(distance, min_dist, max_dist))

		shoot_bb.disengage_update_time = t + interval
	end
end

BTBotShootAction._reevaluate_obstruction = function (self, unit, shoot_blackboard, action_data, t, physics_world, ray_from, wanted_aim_rotation, self_unit, target_unit, actual_aim_position, priority_target_enemy, target_ally_unit, target_ally_needs_aid, target_ally_need_type)
	-- function 22
	self:_update_collision_filter(target_unit, shoot_blackboard, priority_target_enemy, target_ally_unit, target_ally_needs_aid, target_ally_need_type)

	local direction = Quaternion.forward(wanted_aim_rotation)
	local min = action_data.minimum_obstruction_reevaluation_time
	local max = action_data.maximum_obstruction_reevaluation_time
	local collision_filter = shoot_blackboard.charging_shot and not not shoot_blackboard.collision_filter_charged or not shoot_blackboard.charging_shot and not not shoot_blackboard.collision_filter
	local obstructed, distance_from_target, obstructed_by_static = self:_is_shot_obstructed(physics_world, ray_from, direction, unit, target_unit, actual_aim_position, collision_filter)
	local fuzzyness

	if obstructed then
		if shoot_blackboard.charging_shot then
			fuzzyness = shoot_blackboard.obstruction_fuzzyness_range_charged
		else
			fuzzyness = shoot_blackboard.obstruction_fuzzyness_range
		end

		if fuzzyness and distance_from_target <= fuzzyness then
			obstructed = false
		end
	end

	shoot_blackboard.obstructed = obstructed
	shoot_blackboard.reevaluate_obstruction_time = t + min + Math.random() * (max - min)

	return obstructed_by_static
end

local INDEX_POSITION = 1
local INDEX_DISTANCE = 2
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4

BTBotShootAction._is_shot_obstructed = function (self, physics_world, from, direction, self_unit, target_unit, actual_aim_position, collision_filter)
	-- function 23
	local max_distance = Vector3.length(actual_aim_position - from)

	PhysicsWorld.prepare_actors_for_raycast(physics_world, from, direction, 0.01, 0.5, max_distance * max_distance)

	local raycast_hits = PhysicsWorld.immediate_raycast(physics_world, from, direction, max_distance, "all", "collision_filter", collision_filter)

	if not raycast_hits then
		return false
	end

	local num_hits = #raycast_hits

	for i = 1, num_hits do
		local hit = raycast_hits[i]
		local hit_actor = hit[INDEX_ACTOR]
		local hit_unit = Actor.unit(hit_actor)

		if hit_unit == target_unit then
			return false
		elseif hit_unit ~= self_unit then
			local obstructed_by_static = Actor.is_static(hit_actor)

			return true, max_distance - hit[INDEX_DISTANCE], obstructed_by_static
		end
	end

	return false
end
