-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotShootAction = class(BTBotShootAction, BTNode)

function BTBotShootAction.init(arg_1_0, ...)
	BTBotShootAction.super.init(arg_1_0, ...)
end

BTBotShootAction.name = "BTBotShootAction"

local var_0_0 = {
	min_radius_pseudo_random_c = 0.0557,
	max_radius_pseudo_random_c = 0.01475,
	min_radius = math.pi / 72,
	max_radius = math.pi / 16
}
local var_0_1
local var_0_2 = 3
local var_0_3 = 3

local function var_0_4(...)
	if script_data.ai_bots_weapon_debug and script_data.debug_unit == var_0_1 then
		print(...)
	end
end

local function var_0_5(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_1 + Quaternion.rotate(Quaternion(Vector3.up(), arg_3_3), arg_3_2) * arg_3_4
	local var_3_1, var_3_2 = GwNavQueries.triangle_from_position(arg_3_0, var_3_0, var_0_2, var_0_3)

	if var_3_1 then
		var_3_0.z = var_3_2

		return true, var_3_0
	else
		return false
	end
end

local function var_0_6(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = Vector3.normalize(Vector3.flat(arg_4_2))
	local var_4_1, var_4_2 = var_0_5(arg_4_0, arg_4_1, var_4_0, 0, arg_4_3)

	if var_4_1 then
		return var_4_2
	end

	local var_4_3 = 3
	local var_4_4 = math.pi / 2 / var_4_3

	for iter_4_0 = 1, var_4_3 do
		local var_4_5 = var_4_4 * iter_4_0
		local var_4_6, var_4_7 = var_0_5(arg_4_0, arg_4_1, var_4_0, var_4_5, arg_4_3)
		local var_4_8 = var_4_7

		if var_4_6 then
			return var_4_8
		end

		local var_4_9, var_4_10 = var_0_5(arg_4_0, arg_4_1, var_4_0, -var_4_5, arg_4_3)
		local var_4_11 = var_4_10

		if var_4_9 then
			return var_4_11
		end
	end

	return nil
end

local function var_0_7(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if ALIVE[arg_5_1] then
		local var_5_0 = POSITION_LOOKUP[arg_5_1]
		local var_5_1 = Vector3.distance_squared(arg_5_0, var_5_0)

		if var_5_1 < arg_5_3 and var_5_1 > 0 then
			local var_5_2 = math.sqrt(var_5_1)

			return (arg_5_0 - var_5_0) * ((arg_5_2 - var_5_2) / var_5_2)
		end
	end

	return nil
end

function BTBotShootAction.enter(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_2.input_extension
	local var_6_1 = false

	var_6_0:set_aiming(true, var_6_1, true)

	local var_6_2 = arg_6_2.target_unit
	local var_6_3 = arg_6_0._tree_node.action_data
	local var_6_4 = arg_6_2.inventory_extension
	local var_6_5 = var_6_3.slot_name or var_6_4:get_wielded_slot_name()
	local var_6_6 = var_6_4:get_slot_data(var_6_5).item_data
	local var_6_7 = BackendUtils.get_item_template(var_6_6)
	local var_6_8 = var_6_7.attack_meta_data or {}
	local var_6_9 = var_6_7.actions[var_6_8.base_action_name or "action_one"]
	local var_6_10 = var_6_9.default
	local var_6_11 = var_6_9[var_6_8.charged_attack_action_name or "shoot_charged"] or var_6_10

	arg_6_2.shoot = {
		num_aim_rolls = 0,
		charging_shot = false,
		disengage_update_time = 0,
		obstructed = true,
		attack_meta_data = var_6_8,
		attack_action = var_6_10,
		charged_attack_action = var_6_11,
		aim_data = var_6_8.aim_data or var_0_0,
		aim_data_charged = var_6_8.aim_data_charged or var_6_8.aim_data or var_0_0,
		reevaluate_aim_time = arg_6_3,
		can_charge_shot = var_6_8.can_charge_shot,
		ignore_disabled_enemies_charged = var_6_8.ignore_disabled_enemies_charged,
		charge_shot_delay = var_6_8.charge_shot_delay,
		fire_input = var_6_8.fire_input or "fire",
		charge_input = var_6_8.charge_input or "charge_shot",
		next_evaluate = arg_6_3 + var_6_3.evaluation_duration,
		next_evaluate_without_firing = arg_6_3 + var_6_3.evaluation_duration_without_firing,
		minimum_charge_time = var_6_8.minimum_charge_time,
		reevaluate_obstruction_time = arg_6_3,
		charge_range_squared = var_6_8.charge_above_range and var_6_8.charge_above_range^2 or nil,
		max_range_squared = var_6_8.max_range and var_6_8.max_range^2 or math.huge,
		max_range_squared_charged = var_6_8.max_range_charged and var_6_8.max_range_charged^2 or var_6_8.max_range and var_6_8.max_range^2 or math.huge,
		charge_when_obstructed = var_6_8.charge_when_obstructed,
		charge_when_outside_max_range = var_6_8.charge_when_outside_max_range,
		charge_when_outside_max_range_charged = var_6_8.charge_when_outside_max_range_charged == nil or var_6_8.charge_when_outside_max_range_charged,
		effective_against = var_6_8.effective_against or 0,
		effective_against_charged = var_6_8.effective_against_charged or 0,
		always_charge_before_firing = var_6_8.always_charge_before_firing,
		aim_at_node = var_6_8.aim_at_node or "j_spine",
		aim_at_node_charged = var_6_8.aim_at_node_charged or var_6_8.aim_at_node or "j_spine",
		projectile_info = var_6_10.projectile_info,
		projectile_info_charged = var_6_11.projectile_info,
		projectile_speed = var_6_10.min_speed or var_6_10.speed,
		projectile_speed_charged = var_6_11.max_speed or var_6_11.min_speed or var_6_11.speed,
		obstruction_fuzzyness_range = var_6_8.obstruction_fuzzyness_range,
		obstruction_fuzzyness_range_charged = var_6_8.obstruction_fuzzyness_range_charged or var_6_8.obstruction_fuzzyness_range,
		stop_fire_delay = var_6_8.stop_fire_delay or 0,
		stop_fire_t = arg_6_3 + (var_6_8.stop_fire_delay or 0),
		hold_fire_condition = var_6_8.hold_fire_condition,
		keep_distance = var_6_8.keep_distance
	}
	arg_6_2.ranged_obstruction_by_static = nil

	local var_6_12 = arg_6_2.shoot

	arg_6_0:_set_new_aim_target(arg_6_1, arg_6_3, var_6_12, var_6_2, arg_6_2.first_person_extension)
	arg_6_0:_update_collision_filter(var_6_2, var_6_12, arg_6_2.priority_target_enemy, arg_6_2.target_ally_unit, arg_6_2.target_ally_needs_aid, arg_6_2.target_ally_need_type)
end

function BTBotShootAction._update_collision_filter(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = arg_7_2.attack_meta_data
	local var_7_1 = BLACKBOARDS[arg_7_1]

	if arg_7_1 == arg_7_3 or arg_7_5 and (arg_7_6 == "hook" or arg_7_6 == "knocked_down" or arg_7_6 == "ledge") and var_7_1 and var_7_1.target_unit == arg_7_4 then
		arg_7_2.collision_filter = "filter_bot_ranged_line_of_sight_no_allies_no_enemies"
		arg_7_2.collision_filter_charged = "filter_bot_ranged_line_of_sight_no_allies_no_enemies"

		return
	end

	local var_7_2 = var_7_0.ignore_enemies_for_obstruction
	local var_7_3 = var_7_0.ignore_enemies_for_obstruction_charged == nil and var_7_2 or var_7_0.ignore_enemies_for_obstruction_charged
	local var_7_4 = Managers.state.difficulty:get_difficulty_settings().friendly_fire_ranged
	local var_7_5
	local var_7_6

	if var_7_4 then
		var_7_5 = var_7_0.ignore_allies_for_obstruction
		var_7_6 = var_7_0.ignore_allies_for_obstruction_charged
	else
		var_7_5 = true
		var_7_6 = true
	end

	arg_7_2.collision_filter = var_7_2 and var_7_5 and "filter_bot_ranged_line_of_sight_no_allies_no_enemies" or var_7_5 and "filter_bot_ranged_line_of_sight_no_allies" or var_7_2 and "filter_bot_ranged_line_of_sight_no_enemies" or "filter_bot_ranged_line_of_sight"
	arg_7_2.collision_filter_charged = var_7_3 and var_7_6 and "filter_bot_ranged_line_of_sight_no_allies_no_enemies" or var_7_6 and "filter_bot_ranged_line_of_sight_no_allies" or var_7_3 and "filter_bot_ranged_line_of_sight_no_enemies" or "filter_bot_ranged_line_of_sight"
end

function BTBotShootAction.leave(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_2.input_extension

	var_8_0:set_aiming(false)

	local var_8_1 = arg_8_0._tree_node.action_data

	if arg_8_2.shoot.charging_shot and var_8_1.abort_input then
		var_8_0[var_8_1.abort_input](var_8_0)
	end

	arg_8_2.shoot = nil
end

function BTBotShootAction.run(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	var_0_1 = arg_9_1

	local var_9_0, var_9_1 = arg_9_0:_aim(arg_9_1, arg_9_2, arg_9_4, arg_9_3)

	if var_9_0 then
		return "done", "evaluate"
	else
		return "running", var_9_1 and "evaluate" or nil
	end
end

function BTBotShootAction._set_new_aim_target(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = arg_10_4 and Unit.get_data(arg_10_4, "breed")

	arg_10_3.target_unit = arg_10_4
	arg_10_3.aim_start_time = arg_10_2
	arg_10_3.aim_speed_yaw = 0
	arg_10_3.aim_speed_pitch = 0
	arg_10_3.target_breed = var_10_0
	arg_10_3.reevaluate_obstruction_time = arg_10_2
	arg_10_3.obstructed = false
end

local function var_0_8(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_1 / arg_11_0

	for iter_11_0 = 1, arg_11_0 do
		local var_11_1 = arg_11_2 + arg_11_3 * var_11_0
		local var_11_2 = var_11_1 - arg_11_2

		QuickDrawer:line(arg_11_2, var_11_1, Color(100, 200, 200))

		arg_11_3 = arg_11_3 + arg_11_4 * var_11_0
		arg_11_2 = var_11_1
	end
end

function BTBotShootAction._wanted_aim_rotation(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = Unit.has_node(arg_12_2, arg_12_6) and Unit.node(arg_12_2, arg_12_6) or 0
	local var_12_1 = Unit.world_position(arg_12_2, var_12_0)
	local var_12_2 = ScriptUnit.has_extension(arg_12_2, "locomotion_system")
	local var_12_3 = var_12_2 and var_12_2:current_velocity() or Vector3.zero()
	local var_12_4
	local var_12_5
	local var_12_6 = arg_12_4 and ProjectileTemplates.trajectory_templates[arg_12_4.trajectory_template_name].prediction_function
	local var_12_7 = arg_12_4 and ProjectileGravitySettings[arg_12_4.gravity_settings]

	if var_12_6 and var_12_7 and var_12_7 > 0 then
		local var_12_8
		local var_12_9

		var_12_9, var_12_5 = var_12_6(arg_12_5 / 100, -var_12_7, arg_12_3, var_12_1, var_12_3)

		if not var_12_9 then
			if arg_12_1 == script_data.debug_unit then
				print("BTBotShootAction no angle found, target out of range")
			end

			var_12_9 = math.pi * 0.25
		end

		var_12_4 = Quaternion.multiply(Quaternion.look(Vector3.normalize(Vector3.flat(var_12_5 - arg_12_3)), Vector3.up()), Quaternion(Vector3.right(), var_12_9))
	else
		var_12_5 = var_12_1
		var_12_4 = Quaternion.look(Vector3.normalize(var_12_5 - arg_12_3), Vector3.up())
	end

	return var_12_4, var_12_5
end

function BTBotShootAction._aim_position(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
	local var_13_0
	local var_13_1
	local var_13_2

	if arg_13_7.charging_shot then
		var_13_0 = arg_13_7.projectile_info_charged
		var_13_1 = arg_13_7.projectile_speed_charged
		var_13_2 = arg_13_7.target_breed and arg_13_7.target_breed.override_bot_target_node or arg_13_7.aim_at_node_charged
	else
		var_13_0 = arg_13_7.projectile_info
		var_13_1 = arg_13_7.projectile_speed
		var_13_2 = arg_13_7.target_breed and arg_13_7.target_breed.override_bot_target_node or arg_13_7.aim_at_node
	end

	local var_13_3, var_13_4 = arg_13_0:_wanted_aim_rotation(arg_13_3, arg_13_6, arg_13_4, var_13_0, var_13_1, var_13_2)
	local var_13_5 = Quaternion.yaw(arg_13_5)
	local var_13_6 = Quaternion.pitch(arg_13_5)
	local var_13_7 = Quaternion.yaw(var_13_3)
	local var_13_8 = Quaternion.pitch(var_13_3)
	local var_13_9, var_13_10 = arg_13_0:_calculate_aim_speed(arg_13_3, arg_13_1, var_13_5, var_13_6, var_13_7, var_13_8, arg_13_7.aim_speed_yaw, arg_13_7.aim_speed_pitch)

	arg_13_7.aim_speed_yaw = var_13_9
	arg_13_7.aim_speed_pitch = var_13_10

	local var_13_11 = var_13_5 + var_13_9 * arg_13_1
	local var_13_12 = var_13_6 + var_13_10 * arg_13_1
	local var_13_13 = Quaternion(Vector3.up(), var_13_11)
	local var_13_14 = Quaternion(Vector3.right(), var_13_12)
	local var_13_15 = Quaternion.multiply(var_13_13, var_13_14)
	local var_13_16 = math.pi
	local var_13_17 = (var_13_11 - var_13_7 + var_13_16) % (var_13_16 * 2) - var_13_16
	local var_13_18 = var_13_12 - var_13_8

	return var_13_17, var_13_18, var_13_3, var_13_15, var_13_4
end

function BTBotShootAction._calculate_aim_speed(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8)
	local var_14_0 = math.pi
	local var_14_1 = (arg_14_5 - arg_14_3 + var_14_0) % (var_14_0 * 2) - var_14_0
	local var_14_2 = arg_14_6 - arg_14_4
	local var_14_3 = math.sign(var_14_1)
	local var_14_4 = math.sign(arg_14_7)
	local var_14_5 = var_14_4 ~= 0 and var_14_3 ~= var_14_4
	local var_14_6 = var_14_1 * math.pi * 10
	local var_14_7
	local var_14_8 = 7.5
	local var_14_9 = 25

	if var_14_5 and var_14_3 > 0 then
		var_14_7 = math.min(arg_14_7 + var_14_9 * arg_14_2, 0)
	elseif var_14_5 then
		var_14_7 = math.max(arg_14_7 - var_14_9 * arg_14_2, 0)
	elseif var_14_3 > 0 then
		if arg_14_7 <= var_14_6 then
			var_14_7 = math.min(arg_14_7 + var_14_8 * arg_14_2, var_14_6)
		else
			var_14_7 = math.max(arg_14_7 - var_14_9 * arg_14_2, var_14_6)
		end
	elseif var_14_6 <= arg_14_7 then
		var_14_7 = math.max(arg_14_7 - var_14_8 * arg_14_2, var_14_6)
	else
		var_14_7 = math.min(arg_14_7 + var_14_9 * arg_14_2, var_14_6)
	end

	local var_14_10 = var_14_2 / arg_14_2

	return var_14_7, var_14_10
end

function BTBotShootAction._may_attack(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = BLACKBOARDS[arg_15_2]

	if not var_15_0 then
		return false
	end

	if script_data.ai_bots_disable_player_range_attacks and var_15_0.is_player then
		return false
	end

	if not DamageUtils.is_enemy(arg_15_1, arg_15_2) then
		return false
	end

	local var_15_1 = arg_15_3.charging_shot
	local var_15_2 = not arg_15_3.minimum_charge_time or not arg_15_3.always_charge_before_firing and not var_15_1 or var_15_1 and arg_15_3.minimum_charge_time <= arg_15_5 - arg_15_3.charge_start_time
	local var_15_3 = var_15_1 and arg_15_3.max_range_squared_charged or arg_15_3.max_range_squared
	local var_15_4

	if var_15_0.is_ai then
		var_15_4 = var_15_2 and not var_15_0.hesitating and not var_15_0.in_alerted_state and not arg_15_3.obstructed and arg_15_4 < var_15_3
	else
		var_15_4 = var_15_2 and not arg_15_3.obstructed and arg_15_4 < var_15_3
	end

	return var_15_4
end

function BTBotShootAction._aim(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_2.target_unit
	local var_16_1 = arg_16_2.shoot

	if not HEALTH_ALIVE[var_16_0] then
		return not var_16_1.stop_fire_t or arg_16_4 < var_16_1.stop_fire_t
	end

	local var_16_2 = arg_16_2.first_person_extension
	local var_16_3 = var_16_2:current_position()
	local var_16_4 = var_16_2:current_rotation()

	if var_16_0 ~= var_16_1.target_unit then
		arg_16_0:_set_new_aim_target(arg_16_1, arg_16_4, var_16_1, var_16_0, var_16_2)
	end

	local var_16_5 = var_16_1.target_breed
	local var_16_6 = var_16_5 and var_16_5.bots_stay_ranged

	if (var_16_6 and not var_16_1.obstructed or var_16_1.keep_distance) and arg_16_4 > var_16_1.disengage_update_time then
		arg_16_0:_update_disengage_position(arg_16_2, arg_16_4, var_16_6)
	else
		var_16_1.disengage_position_set = false
	end

	local var_16_7 = arg_16_0._tree_node.action_data
	local var_16_8, var_16_9, var_16_10, var_16_11, var_16_12 = arg_16_0:_aim_position(arg_16_3, arg_16_4, arg_16_1, var_16_3, var_16_4, var_16_0, var_16_1)

	if arg_16_4 >= var_16_1.reevaluate_obstruction_time then
		if arg_16_0:_reevaluate_obstruction(arg_16_1, var_16_1, var_16_7, arg_16_4, World.get_data(arg_16_2.world, "physics_world"), var_16_3, var_16_10, arg_16_1, var_16_0, var_16_12, arg_16_2.priority_target_enemy, arg_16_2.target_ally_unit, arg_16_2.target_ally_needs_aid, arg_16_2.target_ally_need_type) then
			if not arg_16_2.ranged_obstruction_by_static then
				arg_16_2.ranged_obstruction_by_static = {
					unit = var_16_0,
					timer = arg_16_4
				}
			else
				local var_16_13 = arg_16_2.ranged_obstruction_by_static

				var_16_13.unit = var_16_0
				var_16_13.timer = arg_16_4
			end
		else
			arg_16_2.ranged_obstruction_by_static = nil
		end
	end

	local var_16_14 = arg_16_2.input_extension
	local var_16_15 = Vector3.distance_squared(var_16_3, var_16_12)

	if arg_16_0:_should_charge(var_16_1, var_16_15, var_16_0, arg_16_4) then
		arg_16_0:_charge_shot(var_16_1, var_16_7, var_16_14, arg_16_4)
	end

	var_16_14:set_aim_rotation(var_16_11)

	if arg_16_0:_aim_good_enough(arg_16_3, arg_16_4, var_16_1, var_16_8, var_16_9) and arg_16_0:_may_attack(arg_16_1, var_16_0, var_16_1, var_16_15, arg_16_4) then
		arg_16_0:_fire_shot(var_16_1, var_16_7, var_16_14, arg_16_4)
	end

	local var_16_16 = true

	if var_16_1.fired and var_16_1.hold_fire_condition and var_16_1.hold_fire_condition(arg_16_4, arg_16_2) then
		arg_16_0:_fire_shot(var_16_1, var_16_7, var_16_14, arg_16_4)

		var_16_16 = false
	end

	local var_16_17 = var_16_16 and (var_16_1.fired and arg_16_4 > var_16_1.next_evaluate or arg_16_4 > var_16_1.next_evaluate_without_firing)

	if var_16_17 then
		if script_data.ai_bots_debug_behavior then
			if var_16_1.fired then
				script_data.ai_bots_debug_behavior_data.ranged_attacks = script_data.ai_bots_debug_behavior_data.ranged_attacks + 1
			else
				script_data.ai_bots_debug_behavior_data.failed_ranged_attacks = script_data.ai_bots_debug_behavior_data.failed_ranged_attacks + 1
			end
		end

		var_16_1.next_evaluate = arg_16_4 + var_16_7.evaluation_duration
		var_16_1.next_evaluate_without_firing = arg_16_4 + var_16_7.evaluation_duration_without_firing
		var_16_1.fired = false
	end

	return false, var_16_17
end

function BTBotShootAction._aim_good_enough(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	local var_17_0 = arg_17_3

	if not var_17_0.reevaluate_aim_time then
		var_17_0.reevaluate_aim_time = 0
	end

	if arg_17_2 > var_17_0.reevaluate_aim_time then
		local var_17_1 = var_17_0.charging_shot and var_17_0.aim_data_charged or var_17_0.aim_data
		local var_17_2 = math.sqrt(arg_17_5 * arg_17_5 + arg_17_4 * arg_17_4)

		if var_17_2 > var_17_1.max_radius then
			var_17_0.aim_good_enough = false

			var_0_4("bad aim - offset:", var_17_2)
		else
			local var_17_3
			local var_17_4 = var_17_0.num_aim_rolls + 1

			if var_17_2 < var_17_1.min_radius then
				var_17_3 = Math.random() < var_17_1.min_radius_pseudo_random_c * var_17_4
			else
				var_17_3 = math.auto_lerp(var_17_1.min_radius, var_17_1.max_radius, var_17_1.min_radius_pseudo_random_c, var_17_1.max_radius_pseudo_random_c, var_17_2) * var_17_4 > Math.random()
			end

			if var_17_3 then
				var_17_0.aim_good_enough = true
				var_17_0.num_aim_rolls = 0

				var_0_4("fire! - offset:", var_17_2, " num_rolls:", var_17_4)
			else
				var_17_0.aim_good_enough = false
				var_17_0.num_aim_rolls = var_17_4

				var_0_4("not yet - offset:", var_17_2, " num_rolls:", var_17_4)
			end
		end

		var_17_0.reevaluate_aim_time = arg_17_2 + 0.1
	end

	return var_17_0.aim_good_enough
end

function BTBotShootAction._should_charge(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_1.next_charge_shot_t

	if not arg_18_1.can_charge_shot or var_18_0 and arg_18_4 < var_18_0 then
		return false
	end

	if arg_18_1.ignore_disabled_enemies_charged and BLACKBOARDS[arg_18_3].in_vortex then
		return false
	end

	local var_18_1 = arg_18_1.max_range_squared_charged

	if arg_18_2 > arg_18_1.max_range_squared_charged and not arg_18_1.charge_when_outside_max_range_charged then
		return false
	end

	if arg_18_1.obstructed then
		return arg_18_1.charge_when_obstructed or false
	end

	if arg_18_2 > arg_18_1.max_range_squared then
		return arg_18_1.charge_when_outside_max_range
	end

	if arg_18_1.always_charge_before_firing or arg_18_1.charging_shot then
		return true
	end

	if arg_18_1.charge_range_squared and arg_18_2 > arg_18_1.charge_range_squared then
		return true
	end

	local var_18_2 = arg_18_1.target_breed

	if var_18_2 then
		local var_18_3 = var_18_2.category_mask

		return bit.band(var_18_3, arg_18_1.effective_against_charged) > bit.band(var_18_3, arg_18_1.effective_against)
	end

	return false
end

function BTBotShootAction._fire_shot(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	arg_19_1.fired = true
	arg_19_1.stop_fire_t = arg_19_4 + arg_19_1.stop_fire_delay

	if arg_19_2.fire_input ~= "none" then
		arg_19_3[arg_19_2.fire_input or arg_19_1.fire_input](arg_19_3)
	end

	if arg_19_1.charge_shot_delay then
		arg_19_1.next_charge_shot_t = arg_19_4 + arg_19_1.charge_shot_delay
	end
end

function BTBotShootAction._charge_shot(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if not arg_20_1.charging_shot then
		arg_20_1.charge_start_time = arg_20_4
		arg_20_1.charging_shot = true
	end

	arg_20_3[arg_20_2.charge_input or arg_20_1.charge_input](arg_20_3)
end

function BTBotShootAction._update_disengage_position(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_1.first_person_extension:current_position()
	local var_21_1 = arg_21_1.shoot
	local var_21_2 = arg_21_3 or var_21_1.keep_distance
	local var_21_3 = var_21_2 * var_21_2
	local var_21_4 = 0
	local var_21_5 = Vector3.zero()
	local var_21_6 = arg_21_1.proximite_enemies

	if var_21_6 then
		for iter_21_0 = 1, #var_21_6 do
			local var_21_7 = var_0_7(var_21_0, var_21_6[iter_21_0], var_21_2, var_21_3)

			if var_21_7 then
				var_21_4 = var_21_4 + 1
				var_21_5 = var_21_5 + var_21_7
			end
		end
	end

	if var_21_4 <= 0 then
		local var_21_8 = arg_21_1.shoot.target_unit
		local var_21_9 = var_0_7(var_21_0, var_21_8, var_21_2, var_21_3)

		if var_21_9 then
			var_21_4 = 1
			var_21_5 = var_21_9
		end
	end

	local var_21_10
	local var_21_11

	if var_21_4 > 0 then
		local var_21_12 = arg_21_1.nav_world
		local var_21_13 = Vector3.divide(var_21_5, var_21_4)

		var_21_10 = var_0_6(var_21_12, var_21_0, var_21_13, Vector3.length(var_21_13))
	end

	if var_21_10 then
		local var_21_14 = arg_21_1.navigation_destination_override
		local var_21_15 = var_21_14:unbox()

		if not var_21_1.disengage_position_set or Vector3.distance_squared(var_21_10, var_21_15) > 0.01 then
			var_21_14:store(var_21_10)

			var_21_1.disengage_position_set = true
			var_21_1.stop_at_current_position = var_21_11
		end

		local var_21_16 = 5
		local var_21_17 = 10
		local var_21_18 = Vector3.distance(var_21_0, var_21_10)

		var_21_1.disengage_update_time = arg_21_2 + math.auto_lerp(var_21_16, var_21_17, 0.5, 2, math.clamp(var_21_18, var_21_16, var_21_17))
	end
end

function BTBotShootAction._reevaluate_obstruction(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11, arg_22_12, arg_22_13, arg_22_14)
	arg_22_0:_update_collision_filter(arg_22_9, arg_22_2, arg_22_11, arg_22_12, arg_22_13, arg_22_14)

	local var_22_0 = Quaternion.forward(arg_22_7)
	local var_22_1 = arg_22_3.minimum_obstruction_reevaluation_time
	local var_22_2 = arg_22_3.maximum_obstruction_reevaluation_time
	local var_22_3 = arg_22_2.charging_shot and arg_22_2.collision_filter_charged or arg_22_2.collision_filter
	local var_22_4, var_22_5, var_22_6 = arg_22_0:_is_shot_obstructed(arg_22_5, arg_22_6, var_22_0, arg_22_1, arg_22_9, arg_22_10, var_22_3)
	local var_22_7

	if var_22_4 then
		if arg_22_2.charging_shot then
			var_22_7 = arg_22_2.obstruction_fuzzyness_range_charged
		else
			var_22_7 = arg_22_2.obstruction_fuzzyness_range
		end

		if var_22_7 and var_22_5 <= var_22_7 then
			var_22_4 = false
		end
	end

	arg_22_2.obstructed = var_22_4
	arg_22_2.reevaluate_obstruction_time = arg_22_4 + var_22_1 + Math.random() * (var_22_2 - var_22_1)

	return var_22_6
end

local var_0_9 = 1
local var_0_10 = 2
local var_0_11 = 3
local var_0_12 = 4

function BTBotShootAction._is_shot_obstructed(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7)
	local var_23_0 = Vector3.length(arg_23_6 - arg_23_2)

	PhysicsWorld.prepare_actors_for_raycast(arg_23_1, arg_23_2, arg_23_3, 0.01, 0.5, var_23_0 * var_23_0)

	local var_23_1 = PhysicsWorld.immediate_raycast(arg_23_1, arg_23_2, arg_23_3, var_23_0, "all", "collision_filter", arg_23_7)

	if not var_23_1 then
		return false
	end

	local var_23_2 = #var_23_1

	for iter_23_0 = 1, var_23_2 do
		local var_23_3 = var_23_1[iter_23_0]
		local var_23_4 = var_23_3[var_0_12]
		local var_23_5 = Actor.unit(var_23_4)

		if var_23_5 == arg_23_5 then
			return false
		elseif var_23_5 ~= arg_23_4 then
			local var_23_6 = Actor.is_static(var_23_4)

			return true, var_23_0 - var_23_3[var_0_10], var_23_6
		end
	end

	return false
end
