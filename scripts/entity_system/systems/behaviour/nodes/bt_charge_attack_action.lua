-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_charge_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")

BTChargeAttackAction = class(BTChargeAttackAction, BTNode)

BTChargeAttackAction.init = function (arg_1_0, ...)
	BTChargeAttackAction.super.init(arg_1_0, ...)
end

BTChargeAttackAction.name = "BTChargeAttackAction"

local function var_0_1(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTChargeAttackAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTChargeAttackAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.locked_attack_rotation = false
	arg_3_2.ray_can_go_update_time = arg_3_3
	arg_3_2.attack_token = true
	arg_3_2.anim_cb_charge_impact_finished = nil
	arg_3_2.lunge_data = var_3_0.lunge

	local var_3_1 = arg_3_2.target_unit
	local var_3_2 = ScriptUnit.has_extension(var_3_1, "status_system")

	if var_3_2 then
		var_3_2.num_charges_targeting_player = (var_3_2.num_charges_targeting_player or 0) + 1
	end

	arg_3_2.animation_movement_extension = ScriptUnit.has_extension(arg_3_1, "animation_movement_system")

	local var_3_3 = Managers.state.network

	arg_3_2.target_unit_status_extension = var_3_2

	local var_3_4 = var_0_1(var_3_0.start_animation)

	var_3_3:anim_event(arg_3_1, var_3_4)

	arg_3_2.spawn_to_running = nil
	arg_3_2.charge_state = "starting"
	arg_3_2.attacking_target = arg_3_2.target_unit

	local var_3_5 = arg_3_2.navigation_extension
	local var_3_6 = arg_3_2.locomotion_extension

	var_3_6:set_wanted_velocity(Vector3.zero())
	var_3_5:set_enabled(false)
	var_3_5:reset_destination()
	var_3_6:use_lerp_rotation(true)

	arg_3_2.stored_rotation = QuaternionBox(Quaternion.identity())
	arg_3_2.hit_units = {}
	arg_3_2.pushed_units = {}

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	ScriptUnit.extension(arg_3_1, "hit_reaction_system").force_ragdoll_on_death = true

	AiUtils.add_attack_intensity(var_3_1, var_3_0, arg_3_2)

	arg_3_2.lean_target_position_boxed = Vector3Box()

	AiUtils.alert_nearby_friends_of_enemy(arg_3_1, arg_3_2.group_blackboard.broadphase, arg_3_2.attacking_target, 8)

	arg_3_2.old_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table()

	local var_3_7 = arg_3_2.navigation_extension:get_navtag_layer_cost_table("charge")

	if var_3_7 then
		local var_3_8 = arg_3_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(var_3_8, var_3_7)
	end
end

BTChargeAttackAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if arg_4_2.action.fallback_to_idle and arg_4_2.move_state ~= "idle" and HEALTH_ALIVE[arg_4_1] then
		if not arg_4_2.blocked then
			Managers.state.network:anim_event(arg_4_1, "idle")
		end

		arg_4_2.move_state = "idle"
	end

	arg_4_2.attack_token = false

	if HEALTH_ALIVE[arg_4_1] then
		local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
		local var_4_1 = arg_4_2.navigation_extension

		var_4_1:set_enabled(true)
		var_4_1:set_max_speed(var_4_0)
		arg_4_2.locomotion_extension:set_rotation_speed(nil)

		local var_4_2 = arg_4_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(var_4_2, arg_4_2.old_navtag_layer_cost_table)

		arg_4_2.old_navtag_layer_cost_table = nil
		ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil

		arg_4_2.locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)
	end

	local var_4_3 = ScriptUnit.has_extension(arg_4_2.attacking_target, "status_system")

	if var_4_3 then
		var_4_3.num_charges_targeting_player = (var_4_3.num_charges_targeting_player or 0) - 1

		StatusUtils.set_charged_network(arg_4_2.attacking_target, false)
	end

	if arg_4_2.stagger and arg_4_2.charge_state == "charging" or arg_4_2.charge_state == "approaching" or arg_4_2.charge_state == "lunge" and not arg_4_2.anim_cb_disable_charge_collision then
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

	arg_4_0:_set_leaning_enabled(arg_4_1, arg_4_2, false)

	arg_4_2.animation_movement_extension = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)
end

BTChargeAttackAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.attacking_target

	if not Unit.alive(var_5_0) then
		return "done"
	end

	if arg_5_2.attack_aborted then
		return "done"
	end

	local var_5_1 = arg_5_2.charge_state

	if arg_5_3 > arg_5_2.ray_can_go_update_time and Unit.alive(var_5_0) then
		local var_5_2 = arg_5_2.nav_world
		local var_5_3 = POSITION_LOOKUP[var_5_0]

		arg_5_2.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(var_5_2, POSITION_LOOKUP[arg_5_1], var_5_3, nil, 1, 1)
		arg_5_2.ray_can_go_update_time = arg_5_3 + 0.25
	end

	local var_5_4

	if var_5_1 == "starting" then
		arg_5_0:_run_starting(arg_5_1, arg_5_2)
	elseif var_5_1 == "approaching" then
		arg_5_0:_run_approaching(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif var_5_1 == "charging" then
		arg_5_0:_run_charging(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif var_5_1 == "pre_lunge" then
		arg_5_0:_run_pre_lunge(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif var_5_1 == "lunge" then
		arg_5_0:_run_lunge(arg_5_1, arg_5_2, arg_5_2.lunge_data, arg_5_3, arg_5_4)
	elseif var_5_1 == "impact" then
		arg_5_0:_run_impact(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif var_5_1 == "align_to_target" then
		arg_5_0:_run_align_to_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	elseif var_5_1 == "finished" then
		return "done"
	elseif var_5_1 == "cancel" then
		arg_5_0:_run_cancel(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	end

	return "running", var_5_4
end

BTChargeAttackAction._start_charging = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.action
	local var_6_1 = Managers.time:time("game")
	local var_6_2, var_6_3 = arg_6_0:_select_charging_animation_and_duration(var_6_0, arg_6_1, arg_6_2.attacking_target, arg_6_2)

	arg_6_0:_set_leaning_enabled(arg_6_1, arg_6_2, true)

	arg_6_2.charge_state = "charging"
	arg_6_2.charge_tracking_duration = var_6_1 + var_6_3

	Managers.state.network:anim_event(arg_6_1, var_6_2)
	arg_6_2.locomotion_extension:set_rotation_speed(var_6_0.charge_rotation_speed)

	arg_6_2.charge_started_at_t = var_6_1

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "incoming_attack", DialogueSettings.special_proximity_distance_heard, "enemy_tag", arg_6_2.breed.name)
end

BTChargeAttackAction._start_approaching = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.action

	arg_7_2.charge_state = "approaching"

	arg_7_0:_set_leaning_enabled(arg_7_1, arg_7_2, true)

	local var_7_1 = arg_7_2.navigation_extension
	local var_7_2 = arg_7_2.current_charge_speed or var_7_0.charge_speed_min

	var_7_1:set_enabled(true)
	var_7_1:set_max_speed(var_7_2)

	arg_7_2.move_state = "moving"
end

BTChargeAttackAction._start_lunge = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_2.action
	local var_8_1 = arg_8_3.max_angle_to_allow

	if var_8_1 then
		local var_8_2 = POSITION_LOOKUP[arg_8_1]
		local var_8_3 = POSITION_LOOKUP[arg_8_2.attacking_target]
		local var_8_4 = Vector3.normalize(var_8_3 - var_8_2)
		local var_8_5 = Quaternion.forward(Unit.local_rotation(arg_8_1, 0))
		local var_8_6 = Vector3.dot(var_8_5, var_8_4)

		if var_8_1 < math.radians_to_degrees(math.acos(var_8_6)) then
			arg_8_0:_cancel_charge(arg_8_1, arg_8_2)

			return
		end
	end

	arg_8_2.charge_state = "lunge"

	arg_8_0:_set_leaning_enabled(arg_8_1, arg_8_2, true)

	local var_8_7 = arg_8_3.enter_thresholds
	local var_8_8 = arg_8_0:_pick_distance_identifier(var_8_7, arg_8_4)

	if arg_8_3.animations then
		local var_8_9 = arg_8_3.animations[var_8_8]

		Managers.state.network:anim_event(arg_8_1, var_8_9)
	elseif arg_8_3.lean_variables then
		arg_8_2.lean_during_lunge = true
		arg_8_2.lean_downwards = true

		arg_8_0:_update_leaning_position(arg_8_1, arg_8_2, 0, Vector3:zero())
	end

	local var_8_10 = arg_8_2.locomotion_extension
	local var_8_11 = var_8_10:current_velocity()
	local var_8_12 = arg_8_3.velocity_scaling[var_8_8]
	local var_8_13 = 1 + arg_8_4 / var_8_7[var_8_8]

	var_8_10:set_wanted_velocity(var_8_11 * var_8_12 * var_8_13)
	var_8_10:set_rotation_speed(arg_8_3.rotation_speed)

	arg_8_2.current_lunge_velocity_scale = var_8_12

	if var_8_0.slow_down_start_time then
		arg_8_2.start_slowing_down_at_t = arg_8_5 + var_8_0.slow_down_start_time
	end
end

BTChargeAttackAction._start_impact = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	local var_9_0 = arg_9_2.action

	arg_9_2.charge_state = "impact"

	arg_9_0:_set_leaning_enabled(arg_9_1, arg_9_2, false)

	local var_9_1 = arg_9_2.locomotion_extension

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
	else
		var_9_1:set_wanted_rotation(arg_9_2.stored_rotation:unbox())
	end

	if arg_9_6 then
		local var_9_7 = var_9_0.hit_during_impact_t

		if var_9_7 then
			arg_9_2.hit_during_impact_t = Managers.time:time("game") + var_9_7
		end
	end

	arg_9_2.hit_target = arg_9_3
end

BTChargeAttackAction._start_align_to_target = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_2.action

	if not var_10_0.align_to_target_animation then
		arg_10_2.charge_state = "finished"

		return
	end

	local var_10_1 = arg_10_2.attacking_target
	local var_10_2 = Unit.world_position(var_10_1, 0)
	local var_10_3 = Unit.world_position(arg_10_1, 0)
	local var_10_4 = Vector3.normalize(var_10_3 - var_10_2)
	local var_10_5 = Quaternion.forward(Unit.local_rotation(arg_10_1, 0))
	local var_10_6 = Vector3.dot(var_10_5, var_10_4)

	if not (var_10_6 >= 0.4 and var_10_6 <= 1) then
		arg_10_2.charge_state = "finished"

		return
	end

	local var_10_7 = Managers.time:time("game")

	arg_10_2.charge_state = "align_to_target"

	local var_10_8 = var_10_0.align_to_target_animation

	Managers.state.network:anim_event(arg_10_1, var_10_8)

	local var_10_9 = var_10_7

	arg_10_2.end_align_t, arg_10_2.start_align_t = var_10_7 + var_10_0.end_align_t, var_10_9

	arg_10_2.locomotion_extension:use_lerp_rotation(true)
end

BTChargeAttackAction._cancel_charge = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_2.navigation_extension:set_enabled(false)

	local var_11_0 = arg_11_2.action.cancel_animation

	Managers.state.network:anim_event(arg_11_1, var_11_0)

	arg_11_2.charge_state = "cancel"

	arg_11_2.locomotion_extension:set_rotation_speed(nil)
	arg_11_0:_set_leaning_enabled(arg_11_1, arg_11_2, false)
end

BTChargeAttackAction._check_unit_and_wall_collision = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_2.action
	local var_12_1, var_12_2 = arg_12_0:_check_overlap(arg_12_1, arg_12_2, var_12_0)

	if var_12_1 then
		arg_12_0:_start_impact(arg_12_1, arg_12_2, true, false, var_12_2)
	end

	if not arg_12_4 and arg_12_0:_check_wall_collision(arg_12_1, arg_12_2, arg_12_3) then
		arg_12_0:_start_impact(arg_12_1, arg_12_2, false, true)
	end
end

local var_0_2 = {}

BTChargeAttackAction._check_overlap = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
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
	local var_13_8
	local var_13_9
	local var_13_10 = arg_13_2.side
	local var_13_11 = var_13_10.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_13_0 = 1, #var_13_11 do
		local var_13_12 = var_13_11[iter_13_0]
		local var_13_13 = POSITION_LOOKUP[var_13_12]
		local var_13_14 = Vector3.normalize(var_13_13 - var_13_5)
		local var_13_15 = var_13_13 - var_13_5
		local var_13_16 = Vector3.length(var_13_15)

		if Vector3.dot(var_13_14, var_13_7) > 0 then
			local var_13_17 = ScriptUnit.extension(var_13_12, "status_system")

			if var_13_17 and var_13_17:get_is_dodging() then
				var_13_2 = arg_13_3.target_dodged_radius
			end

			local var_13_18 = var_13_3[var_13_12]
			local var_13_19 = var_13_4[var_13_12]

			if not var_13_18 and var_13_16 < var_13_2 and var_13_17 and not var_13_17:is_invisible() then
				var_13_8, var_13_9 = arg_13_0:_hit_player(arg_13_1, arg_13_2, var_13_12, arg_13_3, var_13_14)
				var_13_3[var_13_12] = true
			elseif not var_13_18 and not var_13_19 and var_13_16 < var_13_1 and var_13_17 and not var_13_17:is_invisible() then
				arg_13_0:_push_player(arg_13_1, var_13_12, arg_13_2, arg_13_3)

				var_13_4[var_13_12] = true
			end
		end
	end

	local var_13_20 = arg_13_2.group_blackboard.broadphase
	local var_13_21 = arg_13_3.hit_ai_radius
	local var_13_22

	if arg_13_3.ignore_friendly_ai then
		var_13_22 = var_13_10.enemy_broadphase_categories
	end

	local var_13_23 = Broadphase.query(var_13_20, var_13_5, var_13_21, var_0_2, var_13_22)

	for iter_13_1 = 1, var_13_23 do
		local var_13_24 = var_0_2[iter_13_1]
		local var_13_25 = POSITION_LOOKUP[var_13_24]
		local var_13_26 = Vector3.normalize(var_13_25 - var_13_5)

		if Vector3.dot(var_13_26, var_13_7) > 0 and var_13_24 ~= arg_13_1 and not var_13_3[var_13_24] then
			arg_13_0:_hit_ai(arg_13_1, var_13_24, arg_13_3, arg_13_2, var_13_0)
		end

		var_13_8 = var_13_8 or var_13_24 == arg_13_2.target_unit
		var_13_3[var_13_24] = true
		var_0_2[iter_13_1] = nil
	end

	return var_13_8, var_13_9
end

BTChargeAttackAction._charged_at_player = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if arg_14_4.catapult_player then
		local var_14_0 = POSITION_LOOKUP[arg_14_2] - POSITION_LOOKUP[arg_14_1]
		local var_14_1 = arg_14_3.locomotion_extension:current_velocity()
		local var_14_2 = Vector3.length(var_14_1) * Vector3.normalize(var_14_0)

		Vector3.set_z(var_14_2, arg_14_4.catapult_force_z or 3)
		StatusUtils.set_catapulted_network(arg_14_2, true, var_14_2)
	else
		StatusUtils.set_charged_network(arg_14_2, true)
	end
end

BTChargeAttackAction._push_player = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = POSITION_LOOKUP[arg_15_2] - POSITION_LOOKUP[arg_15_1]
	local var_15_1 = arg_15_4.dodge_past_push_speed * Vector3.normalize(var_15_0)

	if not (arg_15_2 == arg_15_3.attacking_target) and arg_15_4.catapult_on_push_other_targets then
		local var_15_2 = arg_15_4.catapult_on_push_z

		Vector3.set_z(var_15_1, var_15_2 or 3)
		StatusUtils.set_catapulted_network(arg_15_2, true, var_15_1)
	else
		if arg_15_5 and arg_15_4.blocked_velocity_scale then
			var_15_1 = var_15_1 * arg_15_4.blocked_velocity_scale
		end

		ScriptUnit.extension(arg_15_2, "locomotion_system"):add_external_velocity(var_15_1)
	end
end

BTChargeAttackAction._hit_player = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_3 == arg_16_2.attacking_target
	local var_16_1 = ScriptUnit.has_extension(arg_16_3, "status_system")
	local var_16_2 = not arg_16_4.unblockable_by_normal_blocks and DamageUtils.check_block(arg_16_1, arg_16_3, arg_16_4.fatigue_type)
	local var_16_3 = DamageUtils.check_ranged_block(arg_16_1, arg_16_3, arg_16_4.shield_blocked_fatigue_type or "ogre_shove")

	if var_16_0 and not var_16_3 and not var_16_2 then
		AiUtils.damage_target(arg_16_3, arg_16_1, arg_16_4, arg_16_4.damage)
	end

	if arg_16_4.player_push_speed and not var_16_1.knocked_down then
		if var_16_0 and not var_16_3 then
			arg_16_0:_charged_at_player(arg_16_1, arg_16_3, arg_16_2, arg_16_4)
		else
			arg_16_0:_push_player(arg_16_1, arg_16_3, arg_16_2, arg_16_4, var_16_3 or var_16_2)
		end
	end

	if var_16_0 then
		return true
	end

	return false
end

BTChargeAttackAction._hit_ai = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	local var_17_0 = arg_17_3.push_ai
	local var_17_1 = arg_17_3.immune_breeds
	local var_17_2 = BLACKBOARDS[arg_17_2]
	local var_17_3 = var_17_2.breed and var_17_2.breed.name

	if var_17_1 and var_17_1[var_17_3] then
		return
	end

	if var_17_0 then
		local var_17_4, var_17_5 = DamageUtils.calculate_stagger(var_17_0.stagger_impact, var_17_0.stagger_duration, arg_17_2, arg_17_1)

		if var_17_4 > var_0_0.none then
			local var_17_6 = POSITION_LOOKUP[arg_17_1]
			local var_17_7 = POSITION_LOOKUP[arg_17_2]
			local var_17_8 = Vector3.normalize(var_17_7 - var_17_6)
			local var_17_9 = Quaternion.right(Unit.local_rotation(arg_17_1, 0))
			local var_17_10 = Vector3.dot(var_17_9, var_17_8)
			local var_17_11 = -var_17_9

			if var_17_10 > 0 then
				var_17_11 = -var_17_11
			end

			AiUtils.stagger(arg_17_2, var_17_2, arg_17_1, var_17_11, var_17_0.stagger_distance, var_17_4, var_17_5, nil, arg_17_5, nil, nil, nil, true)

			if not DEDICATED_SERVER and var_17_3 == "chaos_warrior" and (arg_17_4.breed and arg_17_4.breed.name) == "beastmen_bestigor" then
				local var_17_12 = "scorpion_bestigor_charge_chaos_warrior"
				local var_17_13 = NetworkLookup.statistics[var_17_12]
				local var_17_14 = Managers.player:statistics_db()
				local var_17_15 = Managers.player:local_player():stats_id()

				var_17_14:increment_stat(var_17_15, var_17_12)
				Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_17_13)
			end
		end
	end

	if not arg_17_3.ignore_ai_damage then
		AiUtils.damage_target(arg_17_2, arg_17_1, arg_17_3, arg_17_3.damage)
	end

	if arg_17_3.hit_ai_func then
		arg_17_3.hit_ai_func(arg_17_1, arg_17_4, arg_17_2, arg_17_3, arg_17_3)
	end

	AiUtils.alert_nearby_friends_of_enemy(arg_17_1, arg_17_4.group_blackboard.broadphase, arg_17_4.attacking_target)
end

BTChargeAttackAction._check_wall_collision = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
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

BTChargeAttackAction._is_at_edge = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
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

BTChargeAttackAction._check_smartobjects = function (arg_20_0, arg_20_1, arg_20_2)
	if BTConditions.at_smartobject(arg_20_2) then
		if BTConditions.at_door_smartobject(arg_20_2) then
			local var_20_0 = arg_20_2.next_smart_object_data.smart_object_data.unit

			if Unit.alive(var_20_0) then
				AiUtils.kill_unit(var_20_0, arg_20_1)
			end
		else
			arg_20_0:_cancel_charge(arg_20_1, arg_20_2)
		end
	end
end

BTChargeAttackAction._run_starting = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = LocomotionUtils.rotation_towards_unit_flat(arg_21_1, arg_21_2.attacking_target)

	arg_21_2.locomotion_extension:set_wanted_rotation(var_21_0)
end

BTChargeAttackAction._run_approaching = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = arg_22_2.navigation_extension

	if arg_22_2.no_path_found then
		if not arg_22_2.cancel_approaching_t then
			arg_22_2.cancel_approaching_t = arg_22_3 + 2
		elseif arg_22_3 > arg_22_2.cancel_approaching_t then
			arg_22_0:_cancel_charge(arg_22_1, arg_22_2)
		end
	else
		arg_22_2.cancel_approaching_t = nil
	end

	if arg_22_2.ray_can_go_to_target then
		var_22_0:set_enabled(false)
		arg_22_0:_start_charging(arg_22_1, arg_22_2)
	else
		local var_22_1 = arg_22_2.attacking_target
		local var_22_2 = POSITION_LOOKUP[var_22_1]
		local var_22_3 = Vector3.distance(POSITION_LOOKUP[arg_22_1], var_22_2)
		local var_22_4 = arg_22_2.lunge_data

		if var_22_4 and var_22_3 <= var_22_4.enter_thresholds.short then
			arg_22_0:_cancel_charge(arg_22_1, arg_22_2)
		else
			local var_22_5 = 1
			local var_22_6 = 2
			local var_22_7 = arg_22_2.nav_world
			local var_22_8, var_22_9 = GwNavQueries.triangle_from_position(var_22_7, var_22_2, var_22_5, var_22_6)

			if var_22_8 then
				arg_22_2.stored_position = arg_22_2.stored_position or Vector3Box()

				local var_22_10 = Vector3(var_22_2.x, var_22_2.y, var_22_9)

				var_22_0:move_to(var_22_10)
				arg_22_2.stored_position:store(var_22_10)
			elseif arg_22_2.stored_position then
				local var_22_11 = arg_22_2.stored_position:unbox()

				if Vector3.distance_squared(var_22_11, POSITION_LOOKUP[arg_22_1]) > 1 then
					var_22_0:move_to(var_22_11)
				else
					arg_22_0:_cancel_charge(arg_22_1, arg_22_2)
				end
			else
				local var_22_12 = GwNavQueries.inside_position_from_outside_position(var_22_7, var_22_2, 3, 3, 1, 1)

				if var_22_12 then
					var_22_0:move_to(var_22_12)
				else
					arg_22_0:_cancel_charge(arg_22_1, arg_22_2)
				end
			end
		end
	end

	local var_22_13 = arg_22_2.action

	arg_22_0:_check_overlap(arg_22_1, arg_22_2, var_22_13)
	arg_22_0:_check_smartobjects(arg_22_1, arg_22_2)
	arg_22_0:_update_animation_movement_speed(arg_22_1, arg_22_2, arg_22_4)

	local var_22_14 = 4
	local var_22_15, var_22_16 = var_22_0:get_current_and_node_position_in_nav_path(var_22_14)

	if var_22_15 == nil or var_22_16 == nil then
		return
	end

	local var_22_17 = Vector3.normalize(var_22_16 - var_22_15)
	local var_22_18 = arg_22_0:_get_turn_slowdown_percentage(arg_22_1, arg_22_2, arg_22_4, var_22_17)

	if var_22_18 then
		local var_22_19 = (arg_22_2.current_charge_speed or arg_22_2.action.charge_speed_min) * var_22_18

		var_22_0:set_max_speed(var_22_19)
	end

	local var_22_20 = POSITION_LOOKUP[arg_22_1]

	Vector3.set_z(var_22_16, var_22_20[3])
	arg_22_0:_update_leaning_position(arg_22_1, arg_22_2, arg_22_4, var_22_16)
end

BTChargeAttackAction._run_charging = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	if not arg_23_2.ray_can_go_to_target then
		arg_23_0:_start_approaching(arg_23_1, arg_23_2)

		return
	end

	local var_23_0 = arg_23_2.action
	local var_23_1 = arg_23_2.attacking_target
	local var_23_2 = arg_23_2.locomotion_extension
	local var_23_3 = arg_23_2.navigation_extension
	local var_23_4 = POSITION_LOOKUP[arg_23_1]
	local var_23_5 = LocomotionUtils.rotation_towards_unit_flat(arg_23_1, var_23_1)

	if arg_23_3 < arg_23_2.charge_tracking_duration then
		var_23_2:set_wanted_rotation(var_23_5)
		arg_23_2.stored_rotation:store(var_23_5)
	else
		var_23_2:set_wanted_rotation(arg_23_2.stored_rotation:unbox())
	end

	local var_23_6 = arg_23_3 - arg_23_2.charge_started_at_t
	local var_23_7 = var_23_0.charge_speed_min
	local var_23_8 = var_23_0.charge_speed_max
	local var_23_9 = var_23_6 / var_23_0.charge_max_speed_at
	local var_23_10 = math.min(var_23_7 + var_23_9 * (var_23_8 - var_23_7), var_23_8)
	local var_23_11
	local var_23_12 = ScriptUnit.has_extension(var_23_1, "locomotion_system")

	if var_23_12 then
		var_23_11 = var_23_12:current_velocity()

		if not var_23_11 then
			var_23_11 = var_23_12:average_velocity()
		end
	else
		var_23_11 = Vector3.zero()
	end

	local var_23_13 = POSITION_LOOKUP[var_23_1] + var_23_11 * var_23_0.target_extrapolation_length_scale * arg_23_4
	local var_23_14 = Vector3.normalize(Vector3.flat(var_23_13 - var_23_4))
	local var_23_15 = arg_23_0:_get_turn_slowdown_percentage(arg_23_1, arg_23_2, arg_23_4, var_23_14)

	if var_23_15 then
		var_23_10 = var_23_8 * var_23_15
	end

	var_23_3:set_max_speed(var_23_10)

	local var_23_16 = Quaternion.forward(Unit.local_rotation(arg_23_1, 0)) * var_23_10

	var_23_2:set_wanted_velocity(var_23_16)

	arg_23_2.current_charge_speed = var_23_10

	if var_23_8 <= var_23_10 then
		if not arg_23_2.stop_charge_at_t then
			arg_23_2.stop_charge_at_t = arg_23_3 + var_23_0.charge_at_max_speed_duration
		elseif arg_23_3 > arg_23_2.stop_charge_at_t then
			arg_23_0:_cancel_charge(arg_23_1, arg_23_2)
		end
	end

	arg_23_0:_check_unit_and_wall_collision(arg_23_1, arg_23_2, arg_23_4, false)

	local var_23_17 = Vector3.distance(var_23_4, var_23_13)
	local var_23_18 = arg_23_2.lunge_data

	if var_23_18 and var_23_17 <= var_23_18.enter_thresholds.far then
		arg_23_0:_start_lunge(arg_23_1, arg_23_2, var_23_18, var_23_17, arg_23_3)
	end

	Vector3.set_z(var_23_13, var_23_4[3])
	arg_23_0:_update_leaning_position(arg_23_1, arg_23_2, arg_23_4, var_23_13)
	arg_23_0:_update_animation_movement_speed(arg_23_1, arg_23_2, arg_23_4)
	arg_23_0:_check_smartobjects(arg_23_1, arg_23_2)
end

BTChargeAttackAction._run_lunge = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	local var_24_0 = arg_24_2.locomotion_extension
	local var_24_1 = arg_24_2.action
	local var_24_2 = var_24_1.slow_down_speed

	if arg_24_3.get_position_at_distance and not arg_24_2.target_lunge_position then
		local var_24_3 = arg_24_3.get_position_at_distance
		local var_24_4 = POSITION_LOOKUP[arg_24_2.attacking_target]
		local var_24_5 = POSITION_LOOKUP[arg_24_1]

		if var_24_3 >= Vector3.distance(var_24_5, var_24_4) then
			arg_24_2.target_lunge_position = Vector3Box(var_24_4)

			local var_24_6 = Quaternion.look(var_24_4 - var_24_5, Vector3.up())
			local var_24_7 = Vector3(2.5, arg_24_3.get_position_at_distance + 4, 2)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_24_4 + (var_24_4 - var_24_5) * 0.5, "oobb", var_24_7, var_24_6, 1, "Charge Attack")

			if arg_24_3.get_position_duration then
				arg_24_2.get_lunge_position_duration = arg_24_4 + arg_24_3.get_position_duration
			end
		elseif not arg_24_2.ray_can_go_to_target then
			arg_24_0:_start_impact(arg_24_1, arg_24_2, false, false, false, true)
		end
	end

	if not arg_24_2.stop_lunge_rotation then
		if arg_24_2.anim_cb_rotation_stop then
			var_24_0:set_wanted_rotation(arg_24_2.stored_rotation:unbox())

			arg_24_2.stop_lunge_rotation = true
		else
			local var_24_8

			if arg_24_2.target_lunge_position then
				local var_24_9 = Vector3.normalize(arg_24_2.target_lunge_position:unbox() - POSITION_LOOKUP[arg_24_1])
				local var_24_10 = Quaternion.forward(Unit.local_rotation(arg_24_1, 0))
				local var_24_11 = Vector3.dot(var_24_10, var_24_9)
				local var_24_12 = arg_24_2.get_lunge_position_duration

				if var_24_11 < 0 or var_24_12 < arg_24_4 or not arg_24_2.ray_can_go_to_target then
					arg_24_0:_start_impact(arg_24_1, arg_24_2, false, false, false, true)
				end

				var_24_8 = Quaternion.look(var_24_9)
			else
				var_24_8 = LocomotionUtils.rotation_towards_unit_flat(arg_24_1, arg_24_2.attacking_target)
			end

			var_24_0:set_wanted_rotation(var_24_8)
			arg_24_2.stored_rotation:store(var_24_8)

			if arg_24_2.current_lunge_velocity_scale then
				local var_24_13 = Quaternion.forward(Unit.local_rotation(arg_24_1, 0)) * arg_24_2.current_charge_speed

				var_24_0:set_wanted_velocity(var_24_13 * arg_24_2.current_lunge_velocity_scale)
			end
		end

		if arg_24_2.lean_during_lunge then
			arg_24_0:_update_animation_movement_speed(arg_24_1, arg_24_2, arg_24_5)
		end
	else
		var_24_0:use_lerp_rotation(false)
		var_24_0:set_rotation_speed(nil)

		local var_24_14 = Unit.animation_wanted_root_pose(arg_24_1)
		local var_24_15 = Matrix4x4.rotation(var_24_14)

		var_24_0:set_wanted_rotation(var_24_15)

		var_24_2 = arg_24_3.rotation_slow_down_speed
	end

	if not arg_24_2.anim_cb_disable_charge_collision then
		arg_24_0:_check_unit_and_wall_collision(arg_24_1, arg_24_2, arg_24_5, false)

		if not arg_24_2.triggered_dodge_sound then
			local var_24_16 = ScriptUnit.has_extension(arg_24_2.attacking_target, "status_system")

			if var_24_16 and var_24_16:get_is_dodging() then
				local var_24_17 = var_24_1.dodge_past_sound_event or "Play_generic_pushed_impact_small"

				Managers.state.entity:system("audio_system"):play_audio_unit_event(var_24_17, arg_24_1)

				arg_24_2.triggered_dodge_sound = true
			end
		end
	end

	if arg_24_2.start_slowing_down_at_t and arg_24_4 < arg_24_2.start_slowing_down_at_t then
		return
	end

	arg_24_0:_slow_down(arg_24_1, arg_24_2, var_24_2, arg_24_4, arg_24_5)
	arg_24_0:_check_smartobjects(arg_24_1, arg_24_2)
end

BTChargeAttackAction._run_impact = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	if arg_25_2.hit_target then
		local var_25_0 = LocomotionUtils.rotation_towards_unit_flat(arg_25_1, arg_25_2.attacking_target)

		arg_25_2.locomotion_extension:set_wanted_rotation(var_25_0)
	elseif arg_25_2.hit_during_impact_t and arg_25_3 < arg_25_2.hit_during_impact_t and arg_25_0:_check_overlap(arg_25_1, arg_25_2, arg_25_2.action) then
		arg_25_2.hit_during_impact_t = nil
	end

	local var_25_1 = arg_25_2.hit_target and arg_25_2.action.hit_target_slow_down_speed or arg_25_2.action.slow_down_speed

	arg_25_0:_slow_down(arg_25_1, arg_25_2, var_25_1, arg_25_3, arg_25_4)
end

BTChargeAttackAction._run_align_to_target = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	if arg_26_3 > arg_26_2.end_align_t then
		arg_26_2.charge_state = "finished"
	elseif arg_26_3 > arg_26_2.start_align_t then
		local var_26_0 = arg_26_2.start_align_t
		local var_26_1 = arg_26_2.end_align_t
		local var_26_2 = var_26_1 - var_26_0
		local var_26_3 = (var_26_1 - arg_26_3) / var_26_2
		local var_26_4 = Unit.local_rotation(arg_26_1, 0)
		local var_26_5 = Quaternion.look(-Quaternion.right(var_26_4))
		local var_26_6 = Quaternion.lerp(var_26_5, var_26_4, var_26_3)

		arg_26_2.locomotion_extension:set_wanted_rotation(var_26_6)
	end
end

BTChargeAttackAction._run_cancel = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = arg_27_2.action.cancel_slow_down_speed

	arg_27_0:_slow_down(arg_27_1, arg_27_2, var_27_0, arg_27_3, arg_27_4)
end

BTChargeAttackAction._select_charging_animation_and_duration = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_1.charging_animations
	local var_28_1 = arg_28_1.charging_distance_thresholds
	local var_28_2 = arg_28_1.tracking_durations
	local var_28_3 = POSITION_LOOKUP[arg_28_2]
	local var_28_4 = POSITION_LOOKUP[arg_28_3] or Unit.world_position(arg_28_2, 0)
	local var_28_5 = Vector3.distance(Vector3.flat(var_28_3), Vector3.flat(var_28_4))
	local var_28_6 = arg_28_0:_pick_distance_identifier(var_28_1, var_28_5)

	return var_28_0[var_28_6], var_28_2[var_28_6]
end

BTChargeAttackAction._pick_distance_identifier = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0
	local var_29_1
	local var_29_2 = 0

	for iter_29_0, iter_29_1 in pairs(arg_29_1) do
		if arg_29_2 < iter_29_1 and var_29_2 < arg_29_2 then
			var_29_0 = iter_29_0

			break
		end

		var_29_2 = iter_29_1
		var_29_1 = iter_29_0
	end

	var_29_0 = var_29_0 or var_29_1

	return var_29_0
end

BTChargeAttackAction._slow_down = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	local var_30_0 = arg_30_2.locomotion_extension
	local var_30_1 = var_30_0:current_velocity()
	local var_30_2 = Vector3.zero()
	local var_30_3 = math.min(arg_30_5 * arg_30_3, 1)
	local var_30_4 = Vector3.lerp(var_30_1, var_30_2, var_30_3)

	var_30_0:set_wanted_velocity(var_30_4)
end

BTChargeAttackAction._set_leaning_enabled = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_2.animation_movement_extension

	if var_31_0 then
		local var_31_1 = Managers.state.unit_storage:go_id(arg_31_1)

		if arg_31_3 and not var_31_0.enabled then
			Managers.state.network.network_transmit:send_rpc_all("rpc_enable_animation_movement_system", var_31_1, arg_31_3)
		elseif not arg_31_3 and var_31_0.enabled then
			Managers.state.network.network_transmit:send_rpc_all("rpc_enable_animation_movement_system", var_31_1, arg_31_3)
		end
	end
end

BTChargeAttackAction._update_leaning_position = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	arg_32_2.lean_target_position_boxed:store(arg_32_4)
end

BTChargeAttackAction._update_animation_movement_speed = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = arg_33_2.locomotion_extension:current_velocity()
	local var_33_1 = Vector3.length(var_33_0)
	local var_33_2 = Unit.animation_find_variable(arg_33_1, "move_speed")

	Unit.animation_set_variable(arg_33_1, var_33_2, var_33_1)
end

BTChargeAttackAction._get_turn_slowdown_percentage = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = arg_34_2.action
	local var_34_1 = Unit.local_rotation(arg_34_1, 0)
	local var_34_2 = Quaternion.forward(var_34_1)
	local var_34_3 = Vector3.dot(var_34_2, arg_34_4)
	local var_34_4 = math.radians_to_degrees(math.acos(var_34_3))
	local var_34_5 = var_34_0.min_slowdown_angle
	local var_34_6 = var_34_0.max_slowdown_angle

	if var_34_3 > 1 or var_34_4 <= var_34_5 then
		return
	end

	return 1 - math.min((var_34_4 - var_34_5) / var_34_6, 1) * var_34_0.max_slowdown_percentage
end

BTChargeAttackAction.anim_cb_charge_start_finished = function (arg_35_0, arg_35_1, arg_35_2)
	if arg_35_2.ray_can_go_to_target then
		arg_35_0:_start_charging(arg_35_1, arg_35_2)
	else
		arg_35_0:_start_approaching(arg_35_1, arg_35_2)
	end

	if Managers.state.network:game() then
		local var_35_0 = arg_35_2.action.charge_notification_sound_event

		if var_35_0 and Unit.alive(arg_35_2.attacking_target) then
			local var_35_1 = Managers.player:unit_owner(arg_35_2.attacking_target)

			if var_35_1 then
				local var_35_2 = var_35_1:network_id()

				Managers.state.network.network_transmit:send_rpc("rpc_server_audio_event", var_35_2, NetworkLookup.sound_events[var_35_0])
			end
		end
	end
end

BTChargeAttackAction.anim_cb_charge_charging_finished = function (arg_36_0, arg_36_1, arg_36_2)
	if arg_36_2.charge_state == "charging" then
		arg_36_0:_start_impact(arg_36_1, arg_36_2)
	end
end

BTChargeAttackAction.anim_cb_charge_impact_finished = function (arg_37_0, arg_37_1, arg_37_2)
	arg_37_0:_start_align_to_target(arg_37_1, arg_37_2)

	arg_37_2.anim_cb_charge_impact_finished = true
end

BTChargeAttackAction.anim_cb_disable_charge_collision = function (arg_38_0, arg_38_1, arg_38_2)
	arg_38_2.anim_cb_disable_charge_collision = true
end
