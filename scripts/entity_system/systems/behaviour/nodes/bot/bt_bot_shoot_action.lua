-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotShootAction = class(BTBotShootAction, BTNode)

BTBotShootAction.init = function (arg_1_0, ...)
	-- function 1
	BTBotShootAction.super.init(arg_1_0, ...)
end

BTBotShootAction.name = "BTBotShootAction"

local tbl = {
	min_radius_pseudo_random_c = 0.0557,
	max_radius_pseudo_random_c = 0.01475,
	min_radius = math.pi / 72,
	max_radius = math.pi / 16
}
local var_0_1
local num = 3
local num_2 = 3

local function fn(...)
	-- function 2
	if not (not script_data.ai_bots_weapon_debug and script_data.debug_unit ~= var_0_1) then
		print(...)
	end
end

local function fn_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local num_3 = arg_3_1 + Quaternion.rotate(Quaternion(Vector3.up(), arg_3_3), arg_3_2) * arg_3_4
	local triangle_from_position, var_3_2 = GwNavQueries.triangle_from_position(arg_3_0, num_3, num, num_2)

	if not triangle_from_position then
		num_3.z = var_3_2

		return true, num_3
	else
		return false
	end
end

local function fn_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local normalize = Vector3.normalize(Vector3.flat(arg_4_2))
	local var_4_1, var_4_2 = fn_2(arg_4_0, arg_4_1, normalize, 0, arg_4_3)

	if not var_4_1 then
		return var_4_2
	end

	local num = 3
	local num_2 = math.pi / 2 / num

	for i = 1, num do
		local num_3 = num_2 * i
		local var_4_6, var_4_7 = fn_2(arg_4_0, arg_4_1, normalize, num_3, arg_4_3)
		local var_4_8 = var_4_7

		if not var_4_6 then
			return var_4_8
		end

		local var_4_9, var_4_10 = fn_2(arg_4_0, arg_4_1, normalize, -num_3, arg_4_3)
		local var_4_11 = var_4_10

		if not var_4_9 then
			return var_4_11
		end
	end

	return nil
end

local function fn_4(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if not ALIVE[arg_5_1] then
		local var_5_0 = POSITION_LOOKUP[arg_5_1]
		local distance_squared = Vector3.distance_squared(arg_5_0, var_5_0)

		if not (not (distance_squared < arg_5_3) or not (distance_squared > 0)) then
			local sqrt = math.sqrt(distance_squared)

			return (arg_5_0 - var_5_0) * ((arg_5_2 - sqrt) / sqrt)
		end
	end

	return nil
end

BTBotShootAction.enter = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local input_extension = arg_6_2.input_extension
	local flag = false

	input_extension:set_aiming(true, flag, true)

	local target_unit = arg_6_2.target_unit
	local action_data = self._tree_node.action_data
	local inventory_extension = arg_6_2.inventory_extension
	local slot_name = action_data.slot_name

	slot_name = slot_name or inventory_extension:get_wielded_slot_name()

	local item_data = inventory_extension:get_slot_data(slot_name).item_data
	local get_item_template = BackendUtils.get_item_template(item_data)
	local attack_meta_data = get_item_template.attack_meta_data

	attack_meta_data = attack_meta_data or {}

	local actions = get_item_template.actions
	local base_action_name = attack_meta_data.base_action_name

	base_action_name = base_action_name or "action_one"

	local var_6_11 = actions[base_action_name]
	local default = var_6_11.default
	local charged_attack_action_name = attack_meta_data.charged_attack_action_name

	charged_attack_action_name = charged_attack_action_name or "shoot_charged"

	local var_6_14 = var_6_11[charged_attack_action_name]

	var_6_14 = var_6_14 or default

	local tbl_2 = {
		num_aim_rolls = 0,
		charging_shot = false,
		disengage_update_time = 0,
		obstructed = true,
		attack_meta_data = attack_meta_data,
		attack_action = default,
		charged_attack_action = var_6_14
	}
	local aim_data = attack_meta_data.aim_data

	aim_data = aim_data or tbl
	tbl_2.aim_data = aim_data

	local aim_data_charged = attack_meta_data.aim_data_charged

	if not aim_data_charged then
		aim_data_charged = attack_meta_data.aim_data
		aim_data_charged = aim_data_charged or tbl
	end

	tbl_2.aim_data_charged = aim_data_charged
	tbl_2.reevaluate_aim_time = arg_6_3
	tbl_2.can_charge_shot = attack_meta_data.can_charge_shot
	tbl_2.ignore_disabled_enemies_charged = attack_meta_data.ignore_disabled_enemies_charged
	tbl_2.charge_shot_delay = attack_meta_data.charge_shot_delay

	local fire_input = attack_meta_data.fire_input

	fire_input = fire_input or "fire"
	tbl_2.fire_input = fire_input

	local charge_input = attack_meta_data.charge_input

	charge_input = charge_input or "charge_shot"
	tbl_2.charge_input = charge_input
	tbl_2.next_evaluate = arg_6_3 + action_data.evaluation_duration
	tbl_2.next_evaluate_without_firing = arg_6_3 + action_data.evaluation_duration_without_firing
	tbl_2.minimum_charge_time = attack_meta_data.minimum_charge_time
	tbl_2.reevaluate_obstruction_time = arg_6_3

	local num

	if not attack_meta_data.charge_above_range then
		num = attack_meta_data.charge_above_range^2

		if not num then
			-- Nothing
		end
	end

	num = nil

	::label_6_0::

	tbl_2.charge_range_squared = num

	local num_2

	if not attack_meta_data.max_range then
		num_2 = attack_meta_data.max_range^2

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = math.huge

	::label_6_1::

	tbl_2.max_range_squared = num_2

	local num_3

	if not attack_meta_data.max_range_charged then
		num_3 = attack_meta_data.max_range_charged^2

		if not num_3 then
			-- Nothing
		end
	end

	if not attack_meta_data.max_range then
		num_3 = attack_meta_data.max_range^2

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = math.huge

	::label_6_2::

	tbl_2.max_range_squared_charged = num_3
	tbl_2.charge_when_obstructed = attack_meta_data.charge_when_obstructed
	tbl_2.charge_when_outside_max_range = attack_meta_data.charge_when_outside_max_range
	tbl_2.charge_when_outside_max_range_charged = attack_meta_data.charge_when_outside_max_range_charged == nil or attack_meta_data.charge_when_outside_max_range_charged

	local effective_against = attack_meta_data.effective_against

	effective_against = effective_against or 0
	tbl_2.effective_against = effective_against

	local effective_against_charged = attack_meta_data.effective_against_charged

	effective_against_charged = effective_against_charged or 0
	tbl_2.effective_against_charged = effective_against_charged
	tbl_2.always_charge_before_firing = attack_meta_data.always_charge_before_firing

	local aim_at_node = attack_meta_data.aim_at_node

	aim_at_node = aim_at_node or "j_spine"
	tbl_2.aim_at_node = aim_at_node

	local aim_at_node_charged = attack_meta_data.aim_at_node_charged

	if not aim_at_node_charged then
		aim_at_node_charged = attack_meta_data.aim_at_node
		aim_at_node_charged = aim_at_node_charged or "j_spine"
	end

	tbl_2.aim_at_node_charged = aim_at_node_charged
	tbl_2.projectile_info = default.projectile_info
	tbl_2.projectile_info_charged = var_6_14.projectile_info

	local min_speed = default.min_speed

	min_speed = min_speed or default.speed
	tbl_2.projectile_speed = min_speed

	local max_speed = var_6_14.max_speed

	if not max_speed then
		max_speed = var_6_14.min_speed
		max_speed = max_speed or var_6_14.speed
	end

	tbl_2.projectile_speed_charged = max_speed
	tbl_2.obstruction_fuzzyness_range = attack_meta_data.obstruction_fuzzyness_range

	local obstruction_fuzzyness_range_charged = attack_meta_data.obstruction_fuzzyness_range_charged

	obstruction_fuzzyness_range_charged = obstruction_fuzzyness_range_charged or attack_meta_data.obstruction_fuzzyness_range
	tbl_2.obstruction_fuzzyness_range_charged = obstruction_fuzzyness_range_charged

	local stop_fire_delay = attack_meta_data.stop_fire_delay

	stop_fire_delay = stop_fire_delay or 0
	tbl_2.stop_fire_delay = stop_fire_delay

	local stop_fire_delay_2 = attack_meta_data.stop_fire_delay

	stop_fire_delay_2 = stop_fire_delay_2 or 0
	tbl_2.stop_fire_t = arg_6_3 + stop_fire_delay_2
	tbl_2.hold_fire_condition = attack_meta_data.hold_fire_condition
	tbl_2.keep_distance = attack_meta_data.keep_distance
	arg_6_2.shoot = tbl_2
	arg_6_2.ranged_obstruction_by_static = nil

	local shoot = arg_6_2.shoot

	self:_set_new_aim_target(arg_6_1, arg_6_3, shoot, target_unit, arg_6_2.first_person_extension)
	self:_update_collision_filter(target_unit, shoot, arg_6_2.priority_target_enemy, arg_6_2.target_ally_unit, arg_6_2.target_ally_needs_aid, arg_6_2.target_ally_need_type)
end

BTBotShootAction._update_collision_filter = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local attack_meta_data = arg_7_2.attack_meta_data
	local var_7_1 = BLACKBOARDS[arg_7_1]

	if not (arg_7_1 == arg_7_3 or not arg_7_5 or (arg_7_6 == "hook" or arg_7_6 == "knocked_down" or arg_7_6 == "ledge" or not var_7_1) and var_7_1.target_unit == arg_7_4) then
		arg_7_2.collision_filter = "filter_bot_ranged_line_of_sight_no_allies_no_enemies"
		arg_7_2.collision_filter_charged = "filter_bot_ranged_line_of_sight_no_allies_no_enemies"

		return
	end

	local ignore_enemies_for_obstruction = attack_meta_data.ignore_enemies_for_obstruction
	local flag = attack_meta_data.ignore_enemies_for_obstruction_charged ~= nil or not ignore_enemies_for_obstruction or attack_meta_data.ignore_enemies_for_obstruction_charged
	local friendly_fire_ranged = Managers.state.difficulty:get_difficulty_settings().friendly_fire_ranged
	local var_7_5
	local var_7_6

	if not friendly_fire_ranged then
		var_7_5 = attack_meta_data.ignore_allies_for_obstruction
		var_7_6 = attack_meta_data.ignore_allies_for_obstruction_charged
	else
		var_7_5 = true
		var_7_6 = true
	end

	local flag_2

	flag_2 = not ignore_enemies_for_obstruction and not var_7_5 and "filter_bot_ranged_line_of_sight_no_allies_no_enemies" and not var_7_5 or "filter_bot_ranged_line_of_sight_no_allies" and not ignore_enemies_for_obstruction and "filter_bot_ranged_line_of_sight_no_enemies" and "filter_bot_ranged_line_of_sight"
	arg_7_2.collision_filter = flag_2

	local flag_3

	flag_3 = not flag and not var_7_6 and "filter_bot_ranged_line_of_sight_no_allies_no_enemies" and not var_7_6 or "filter_bot_ranged_line_of_sight_no_allies" and not flag and "filter_bot_ranged_line_of_sight_no_enemies" and "filter_bot_ranged_line_of_sight"
	arg_7_2.collision_filter_charged = flag_3
end

BTBotShootAction.leave = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local input_extension = arg_8_2.input_extension

	input_extension:set_aiming(false)

	local action_data = self._tree_node.action_data

	if not arg_8_2.shoot.charging_shot and not action_data.abort_input then
		input_extension[action_data.abort_input](input_extension)
	end

	arg_8_2.shoot = nil
end

BTBotShootAction.run = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	var_0_1 = arg_9_1

	local _aim, var_9_1 = self:_aim(arg_9_1, arg_9_2, arg_9_4, arg_9_3)

	if not _aim then
		return "done", "evaluate"
	else
		local str = "running"
		local flag

		flag = not var_9_1 and "evaluate" and nil

		return str, flag
	end
end

BTBotShootAction._set_new_aim_target = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local flag = not arg_10_4 and Unit.get_data(arg_10_4, "breed")

	arg_10_3.target_unit = arg_10_4
	arg_10_3.aim_start_time = arg_10_2
	arg_10_3.aim_speed_yaw = 0
	arg_10_3.aim_speed_pitch = 0
	arg_10_3.target_breed = flag
	arg_10_3.reevaluate_obstruction_time = arg_10_2
	arg_10_3.obstructed = false
end

local function fn_5(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local num = arg_11_1 / arg_11_0

	for i = 1, arg_11_0 do
		local num_2 = arg_11_2 + arg_11_3 * num
		local num_3 = num_2 - arg_11_2

		QuickDrawer:line(arg_11_2, num_2, Color(100, 200, 200))

		arg_11_3 = arg_11_3 + arg_11_4 * num
		arg_11_2 = num_2
	end
end

BTBotShootAction._wanted_aim_rotation = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	local node

	if not Unit.has_node(arg_12_2, arg_12_6) then
		node = Unit.node(arg_12_2, arg_12_6)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_12_0::

	local world_position = Unit.world_position(arg_12_2, node)
	local has_extension = ScriptUnit.has_extension(arg_12_2, "locomotion_system")
	local current_velocity

	if not has_extension then
		current_velocity = has_extension:current_velocity()

		if not current_velocity then
			-- Nothing
		end
	end

	current_velocity = Vector3.zero()

	::label_12_1::

	local var_12_4
	local var_12_5
	local flag = not arg_12_4 and ProjectileTemplates.trajectory_templates[arg_12_4.trajectory_template_name].prediction_function
	local flag_2 = not arg_12_4 and ProjectileGravitySettings[arg_12_4.gravity_settings]

	if not (not flag and not flag_2 and not (flag_2 > 0)) then
		local var_12_8
		local var_12_9

		var_12_9, var_12_5 = flag(arg_12_5 / 100, -flag_2, arg_12_3, world_position, current_velocity)

		if not var_12_9 then
			if arg_12_1 == script_data.debug_unit then
				print("BTBotShootAction no angle found, target out of range")
			end

			var_12_9 = math.pi * 0.25
		end

		var_12_4 = Quaternion.multiply(Quaternion.look(Vector3.normalize(Vector3.flat(var_12_5 - arg_12_3)), Vector3.up()), Quaternion(Vector3.right(), var_12_9))
	else
		var_12_5 = world_position
		var_12_4 = Quaternion.look(Vector3.normalize(var_12_5 - arg_12_3), Vector3.up())
	end

	return var_12_4, var_12_5
end

BTBotShootAction._aim_position = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
	-- function 13
	local var_13_0
	local var_13_1
	local var_13_2

	if not arg_13_7.charging_shot then
		var_13_0 = arg_13_7.projectile_info_charged
		var_13_1 = arg_13_7.projectile_speed_charged
		var_13_2 = not arg_13_7.target_breed and arg_13_7.target_breed.override_bot_target_node and arg_13_7.aim_at_node_charged
	else
		var_13_0 = arg_13_7.projectile_info
		var_13_1 = arg_13_7.projectile_speed
		var_13_2 = not arg_13_7.target_breed and arg_13_7.target_breed.override_bot_target_node and arg_13_7.aim_at_node
	end

	local _wanted_aim_rotation, var_13_4 = self:_wanted_aim_rotation(arg_13_3, arg_13_6, arg_13_4, var_13_0, var_13_1, var_13_2)
	local yaw = Quaternion.yaw(arg_13_5)
	local pitch = Quaternion.pitch(arg_13_5)
	local yaw_2 = Quaternion.yaw(_wanted_aim_rotation)
	local pitch_2 = Quaternion.pitch(_wanted_aim_rotation)
	local _calculate_aim_speed, var_13_10 = self:_calculate_aim_speed(arg_13_3, arg_13_1, yaw, pitch, yaw_2, pitch_2, arg_13_7.aim_speed_yaw, arg_13_7.aim_speed_pitch)

	arg_13_7.aim_speed_yaw = _calculate_aim_speed
	arg_13_7.aim_speed_pitch = var_13_10

	local num = yaw + _calculate_aim_speed * arg_13_1
	local num_2 = pitch + var_13_10 * arg_13_1
	local var_13_13 = Quaternion(Vector3.up(), num)
	local var_13_14 = Quaternion(Vector3.right(), num_2)
	local multiply = Quaternion.multiply(var_13_13, var_13_14)
	local pi = math.pi
	local num_3 = (num - yaw_2 + pi) % (pi * 2) - pi
	local num_4 = num_2 - pitch_2

	return num_3, num_4, _wanted_aim_rotation, multiply, var_13_4
end

BTBotShootAction._calculate_aim_speed = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8)
	-- function 14
	local pi = math.pi
	local num = (arg_14_5 - arg_14_3 + pi) % (pi * 2) - pi
	local num_2 = arg_14_6 - arg_14_4
	local sign = math.sign(num)
	local sign_2 = math.sign(arg_14_7)
	local flag = sign_2 == 0 or sign ~= sign_2
	local num_3 = num * math.pi * 10
	local var_14_7
	local num_4 = 7.5
	local num_5 = 25

	if not (not flag and not (sign > 0)) then
		var_14_7 = math.min(arg_14_7 + num_5 * arg_14_2, 0)
	elseif not flag then
		var_14_7 = math.max(arg_14_7 - num_5 * arg_14_2, 0)
	elseif sign > 0 then
		if arg_14_7 <= num_3 then
			var_14_7 = math.min(arg_14_7 + num_4 * arg_14_2, num_3)
		else
			var_14_7 = math.max(arg_14_7 - num_5 * arg_14_2, num_3)
		end
	elseif num_3 <= arg_14_7 then
		var_14_7 = math.max(arg_14_7 - num_4 * arg_14_2, num_3)
	else
		var_14_7 = math.min(arg_14_7 + num_5 * arg_14_2, num_3)
	end

	local num_6 = num_2 / arg_14_2

	return var_14_7, num_6
end

BTBotShootAction._may_attack = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local var_15_0 = BLACKBOARDS[arg_15_2]

	if not var_15_0 then
		return false
	end

	if not script_data.ai_bots_disable_player_range_attacks and not var_15_0.is_player then
		return false
	end

	if not DamageUtils.is_enemy(arg_15_1, arg_15_2) then
		return false
	end

	local charging_shot = arg_15_3.charging_shot
	local flag = not arg_15_3.minimum_charge_time and arg_15_3.always_charge_before_firing and not charging_shot and not charging_shot and arg_15_3.minimum_charge_time <= arg_15_5 - arg_15_3.charge_start_time
	local max_range_squared_charged

	if not charging_shot then
		max_range_squared_charged = arg_15_3.max_range_squared_charged

		if not max_range_squared_charged then
			-- Nothing
		end
	end

	max_range_squared_charged = arg_15_3.max_range_squared

	::label_15_0::

	local var_15_4

	if not var_15_0.is_ai then
		var_15_4 = not flag and not not var_15_0.hesitating and not not var_15_0.in_alerted_state and not not arg_15_3.obstructed or arg_15_4 < max_range_squared_charged
	else
		var_15_4 = not flag and not not arg_15_3.obstructed or arg_15_4 < max_range_squared_charged
	end

	return var_15_4
end

BTBotShootAction._aim = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local target_unit = arg_16_2.target_unit
	local shoot = arg_16_2.shoot

	if not HEALTH_ALIVE[target_unit] then
		return not shoot.stop_fire_t and arg_16_4 < shoot.stop_fire_t
	end

	local first_person_extension = arg_16_2.first_person_extension
	local current_position = first_person_extension:current_position()
	local current_rotation = first_person_extension:current_rotation()

	if target_unit ~= shoot.target_unit then
		self:_set_new_aim_target(arg_16_1, arg_16_4, shoot, target_unit, first_person_extension)
	end

	local target_breed = shoot.target_breed
	local flag = not target_breed and target_breed.bots_stay_ranged

	if not (not flag and shoot.obstructed and not shoot.keep_distance and not (arg_16_4 > shoot.disengage_update_time)) then
		self:_update_disengage_position(arg_16_2, arg_16_4, flag)
	else
		shoot.disengage_position_set = false
	end

	local action_data = self._tree_node.action_data
	local _aim_position, var_16_9, var_16_10, var_16_11, var_16_12 = self:_aim_position(arg_16_3, arg_16_4, arg_16_1, current_position, current_rotation, target_unit, shoot)

	if arg_16_4 >= shoot.reevaluate_obstruction_time then
		if not self:_reevaluate_obstruction(arg_16_1, shoot, action_data, arg_16_4, World.get_data(arg_16_2.world, "physics_world"), current_position, var_16_10, arg_16_1, target_unit, var_16_12, arg_16_2.priority_target_enemy, arg_16_2.target_ally_unit, arg_16_2.target_ally_needs_aid, arg_16_2.target_ally_need_type) then
			if not arg_16_2.ranged_obstruction_by_static then
				arg_16_2.ranged_obstruction_by_static = {
					unit = target_unit,
					timer = arg_16_4
				}
			else
				local ranged_obstruction_by_static = arg_16_2.ranged_obstruction_by_static

				ranged_obstruction_by_static.unit = target_unit
				ranged_obstruction_by_static.timer = arg_16_4
			end
		else
			arg_16_2.ranged_obstruction_by_static = nil
		end
	end

	local input_extension = arg_16_2.input_extension
	local distance_squared = Vector3.distance_squared(current_position, var_16_12)

	if not self:_should_charge(shoot, distance_squared, target_unit, arg_16_4) then
		self:_charge_shot(shoot, action_data, input_extension, arg_16_4)
	end

	input_extension:set_aim_rotation(var_16_11)

	if not self:_aim_good_enough(arg_16_3, arg_16_4, shoot, _aim_position, var_16_9) and not self:_may_attack(arg_16_1, target_unit, shoot, distance_squared, arg_16_4) then
		self:_fire_shot(shoot, action_data, input_extension, arg_16_4)
	end

	local flag_2 = true

	if not shoot.fired and not shoot.hold_fire_condition and not shoot.hold_fire_condition(arg_16_4, arg_16_2) then
		self:_fire_shot(shoot, action_data, input_extension, arg_16_4)

		flag_2 = false
	end

	local flag_3 = not flag_2 and not shoot.fired and arg_16_4 > shoot.next_evaluate and arg_16_4 > shoot.next_evaluate_without_firing

	if not flag_3 then
		if not script_data.ai_bots_debug_behavior then
			if not shoot.fired then
				script_data.ai_bots_debug_behavior_data.ranged_attacks = script_data.ai_bots_debug_behavior_data.ranged_attacks + 1
			else
				script_data.ai_bots_debug_behavior_data.failed_ranged_attacks = script_data.ai_bots_debug_behavior_data.failed_ranged_attacks + 1
			end
		end

		shoot.next_evaluate = arg_16_4 + action_data.evaluation_duration
		shoot.next_evaluate_without_firing = arg_16_4 + action_data.evaluation_duration_without_firing
		shoot.fired = false
	end

	return false, flag_3
end

BTBotShootAction._aim_good_enough = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	local var_17_0 = arg_17_3

	if not var_17_0.reevaluate_aim_time then
		var_17_0.reevaluate_aim_time = 0
	end

	if arg_17_2 > var_17_0.reevaluate_aim_time then
		local aim_data_charged

		if not var_17_0.charging_shot then
			aim_data_charged = var_17_0.aim_data_charged

			if not aim_data_charged then
				-- Nothing
			end
		end

		aim_data_charged = var_17_0.aim_data

		::label_17_0::

		local sqrt = math.sqrt(arg_17_5 * arg_17_5 + arg_17_4 * arg_17_4)

		if sqrt > aim_data_charged.max_radius then
			var_17_0.aim_good_enough = false

			fn("bad aim - offset:", sqrt)
		else
			local var_17_3
			local num = var_17_0.num_aim_rolls + 1

			if sqrt < aim_data_charged.min_radius then
				var_17_3 = Math.random() < aim_data_charged.min_radius_pseudo_random_c * num
			else
				var_17_3 = math.auto_lerp(aim_data_charged.min_radius, aim_data_charged.max_radius, aim_data_charged.min_radius_pseudo_random_c, aim_data_charged.max_radius_pseudo_random_c, sqrt) * num > Math.random()
			end

			if not var_17_3 then
				var_17_0.aim_good_enough = true
				var_17_0.num_aim_rolls = 0

				fn("fire! - offset:", sqrt, " num_rolls:", num)
			else
				var_17_0.aim_good_enough = false
				var_17_0.num_aim_rolls = num

				fn("not yet - offset:", sqrt, " num_rolls:", num)
			end
		end

		var_17_0.reevaluate_aim_time = arg_17_2 + 0.1
	end

	return var_17_0.aim_good_enough
end

BTBotShootAction._should_charge = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local next_charge_shot_t = arg_18_1.next_charge_shot_t

	if not (not arg_18_1.can_charge_shot and not next_charge_shot_t and not (arg_18_4 < next_charge_shot_t)) then
		return false
	end

	if not arg_18_1.ignore_disabled_enemies_charged and not BLACKBOARDS[arg_18_3].in_vortex then
		return false
	end

	local max_range_squared_charged = arg_18_1.max_range_squared_charged

	if not (not (arg_18_2 > arg_18_1.max_range_squared_charged) or arg_18_1.charge_when_outside_max_range_charged) then
		return false
	end

	if not arg_18_1.obstructed then
		local charge_when_obstructed = arg_18_1.charge_when_obstructed

		charge_when_obstructed = charge_when_obstructed or false

		return charge_when_obstructed
	end

	if arg_18_2 > arg_18_1.max_range_squared then
		return arg_18_1.charge_when_outside_max_range
	end

	if arg_18_1.always_charge_before_firing or not arg_18_1.charging_shot then
		return true
	end

	if not (not arg_18_1.charge_range_squared and not (arg_18_2 > arg_18_1.charge_range_squared)) then
		return true
	end

	local target_breed = arg_18_1.target_breed

	if not target_breed then
		local category_mask = target_breed.category_mask

		return bit.band(category_mask, arg_18_1.effective_against_charged) > bit.band(category_mask, arg_18_1.effective_against)
	end

	return false
end

BTBotShootAction._fire_shot = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	arg_19_1.fired = true
	arg_19_1.stop_fire_t = arg_19_4 + arg_19_1.stop_fire_delay

	if arg_19_2.fire_input ~= "none" then
		local fire_input = arg_19_2.fire_input

		fire_input = fire_input or arg_19_1.fire_input

		arg_19_3[fire_input](arg_19_3)
	end

	if not arg_19_1.charge_shot_delay then
		arg_19_1.next_charge_shot_t = arg_19_4 + arg_19_1.charge_shot_delay
	end
end

BTBotShootAction._charge_shot = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	if not arg_20_1.charging_shot then
		arg_20_1.charge_start_time = arg_20_4
		arg_20_1.charging_shot = true
	end

	local charge_input = arg_20_2.charge_input

	charge_input = charge_input or arg_20_1.charge_input

	arg_20_3[charge_input](arg_20_3)
end

BTBotShootAction._update_disengage_position = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local current_position = arg_21_1.first_person_extension:current_position()
	local shoot = arg_21_1.shoot
	local flag = arg_21_3 or shoot.keep_distance
	local num = flag * flag
	local num_2 = 0
	local zero = Vector3.zero()
	local proximite_enemies = arg_21_1.proximite_enemies

	if not proximite_enemies then
		for i = 1, #proximite_enemies do
			local var_21_7 = fn_4(current_position, proximite_enemies[i], flag, num)

			if not var_21_7 then
				num_2 = num_2 + 1
				zero = zero + var_21_7
			end
		end
	end

	if num_2 <= 0 then
		local target_unit = arg_21_1.shoot.target_unit
		local var_21_9 = fn_4(current_position, target_unit, flag, num)

		if not var_21_9 then
			num_2 = 1
			zero = var_21_9
		end
	end

	local var_21_10
	local var_21_11

	if num_2 > 0 then
		local nav_world = arg_21_1.nav_world
		local divide = Vector3.divide(zero, num_2)

		var_21_10 = fn_3(nav_world, current_position, divide, Vector3.length(divide))
	end

	if not var_21_10 then
		local navigation_destination_override = arg_21_1.navigation_destination_override
		local unbox = navigation_destination_override:unbox()

		if not (not shoot.disengage_position_set and not (Vector3.distance_squared(var_21_10, unbox) > 0.01)) then
			navigation_destination_override:store(var_21_10)

			shoot.disengage_position_set = true
			shoot.stop_at_current_position = var_21_11
		end

		local num_3 = 5
		local num_4 = 10
		local distance = Vector3.distance(current_position, var_21_10)

		shoot.disengage_update_time = arg_21_2 + math.auto_lerp(num_3, num_4, 0.5, 2, math.clamp(distance, num_3, num_4))
	end
end

BTBotShootAction._reevaluate_obstruction = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11, arg_22_12, arg_22_13, arg_22_14)
	-- function 22
	self:_update_collision_filter(arg_22_9, arg_22_2, arg_22_11, arg_22_12, arg_22_13, arg_22_14)

	local forward = Quaternion.forward(arg_22_7)
	local minimum_obstruction_reevaluation_time = arg_22_3.minimum_obstruction_reevaluation_time
	local maximum_obstruction_reevaluation_time = arg_22_3.maximum_obstruction_reevaluation_time
	local collision_filter_charged

	if not arg_22_2.charging_shot then
		collision_filter_charged = arg_22_2.collision_filter_charged

		if not collision_filter_charged then
			-- Nothing
		end
	end

	collision_filter_charged = arg_22_2.collision_filter

	::label_22_0::

	local _is_shot_obstructed, var_22_5, var_22_6 = self:_is_shot_obstructed(arg_22_5, arg_22_6, forward, arg_22_1, arg_22_9, arg_22_10, collision_filter_charged)
	local var_22_7

	if not _is_shot_obstructed then
		if not arg_22_2.charging_shot then
			var_22_7 = arg_22_2.obstruction_fuzzyness_range_charged
		else
			var_22_7 = arg_22_2.obstruction_fuzzyness_range
		end

		if not (not var_22_7 and not (var_22_5 <= var_22_7)) then
			_is_shot_obstructed = false
		end
	end

	arg_22_2.obstructed = _is_shot_obstructed
	arg_22_2.reevaluate_obstruction_time = arg_22_4 + minimum_obstruction_reevaluation_time + Math.random() * (maximum_obstruction_reevaluation_time - minimum_obstruction_reevaluation_time)

	return var_22_6
end

local num_3 = 1
local num_4 = 2
local num_5 = 3
local num_6 = 4

BTBotShootAction._is_shot_obstructed = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7)
	-- function 23
	local length = Vector3.length(arg_23_6 - arg_23_2)

	PhysicsWorld.prepare_actors_for_raycast(arg_23_1, arg_23_2, arg_23_3, 0.01, 0.5, length * length)

	local immediate_raycast = PhysicsWorld.immediate_raycast(arg_23_1, arg_23_2, arg_23_3, length, "all", "collision_filter", arg_23_7)

	if not immediate_raycast then
		return false
	end

	local count = #immediate_raycast

	for i = 1, count do
		local var_23_3 = immediate_raycast[i]
		local var_23_4 = var_23_3[num_6]
		local unit = Actor.unit(var_23_4)

		if unit == arg_23_5 then
			return false
		elseif unit ~= arg_23_4 then
			local is_static = Actor.is_static(var_23_4)

			return true, length - var_23_3[num_4], is_static
		end
	end

	return false
end
