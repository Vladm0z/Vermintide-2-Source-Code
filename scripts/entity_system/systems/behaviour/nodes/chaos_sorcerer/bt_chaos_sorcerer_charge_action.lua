-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_charge_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")

BTChaosSorcererChargeAction = class(BTChaosSorcererChargeAction, BTNode)

function BTChaosSorcererChargeAction.init(arg_1_0, ...)
	BTChaosSorcererChargeAction.super.init(arg_1_0, ...)
end

BTChaosSorcererChargeAction.name = "BTChaosSorcererChargeAction"

local function var_0_1(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTChaosSorcererChargeAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTChaosSorcererChargeAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.locked_attack_rotation = false
	arg_3_2.ray_can_go_update_time = arg_3_3
	arg_3_2.attack_token = true
	arg_3_2.test_start_time = arg_3_3 + 1
	arg_3_2.charge_target_position = Vector3Box(0, 0, 0)
	arg_3_2.charge_target_unit = arg_3_2.target_unit
	arg_3_2.lunge_data = var_3_0.lunge

	local var_3_1 = var_0_1(var_3_0.start_animation)

	Managers.state.network:anim_event(arg_3_1, var_3_1)

	arg_3_2.spawn_to_running = nil
	arg_3_2.charge_state = "starting"

	local var_3_2 = arg_3_2.navigation_extension
	local var_3_3 = arg_3_2.locomotion_extension

	var_3_3:set_wanted_velocity(Vector3.zero())
	var_3_2:set_enabled(false)
	var_3_2:reset_destination()
	var_3_3:use_lerp_rotation(true)

	arg_3_2.stored_rotation = QuaternionBox(Quaternion.identity())
	arg_3_2.hit_units = {}
	arg_3_2.pushed_units = {}

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	ScriptUnit.extension(arg_3_1, "hit_reaction_system").force_ragdoll_on_death = true

	AiUtils.add_attack_intensity(arg_3_2.charge_target_unit, var_3_0, arg_3_2)

	arg_3_2.lean_target_position_boxed = Vector3Box()
	arg_3_2.old_navtag_layer_cost_table = arg_3_2.navigation_extension:get_navtag_layer_cost_table()

	local var_3_4 = arg_3_2.navigation_extension:get_navtag_layer_cost_table("charge")

	if var_3_4 then
		local var_3_5 = arg_3_2.navigation_extension:traverse_logic()

		GwNavTraverseLogic.set_navtag_layer_cost_table(var_3_5, var_3_4)
	end
end

function BTChaosSorcererChargeAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if arg_4_2.move_state ~= "idle" and HEALTH_ALIVE[arg_4_1] then
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

	local var_4_3 = ScriptUnit.has_extension(arg_4_2.charge_target_unit, "status_system")

	if var_4_3 then
		var_4_3.num_charges_targeting_player = (var_4_3.num_charges_targeting_player or 0) - 1

		StatusUtils.set_charged_network(arg_4_2.charge_target_unit, false)
	end

	if arg_4_2.stagger and arg_4_2.charge_state == "charging" or arg_4_2.charge_state == "lunge" and not arg_4_2.anim_cb_disable_charge_collision then
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

function BTChaosSorcererChargeAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.charge_target_unit

	if not Unit.alive(var_5_0) then
		return "done"
	end

	if arg_5_2.attack_aborted then
		return "done"
	end

	local var_5_1 = arg_5_2.charge_state

	if var_5_1 == "starting" then
		if arg_5_3 > arg_5_2.test_start_time then
			arg_5_0:anim_cb_start_finished(arg_5_1, arg_5_2)

			arg_5_2.test_start_time = nil
		end
	elseif var_5_1 == "impact" then
		arg_5_2.test_start_time = arg_5_2.test_start_time or arg_5_3 + 1

		if arg_5_3 > arg_5_2.test_start_time then
			arg_5_0:anim_cb_charge_impact_finished(arg_5_1, arg_5_2)

			arg_5_2.test_start_time = arg_5_3 + 1
		end
	end

	if arg_5_3 > arg_5_2.ray_can_go_update_time and Unit.alive(var_5_0) then
		local var_5_2 = arg_5_2.nav_world
		local var_5_3 = POSITION_LOOKUP[var_5_0]

		arg_5_2.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(var_5_2, POSITION_LOOKUP[arg_5_1], var_5_3, nil, 1, 1)
		arg_5_2.ray_can_go_update_time = arg_5_3 + 0.25
	end

	local var_5_4

	if var_5_1 == "starting" then
		arg_5_0:_run_starting(arg_5_1, arg_5_2)
	elseif var_5_1 == "charging" then
		if arg_5_0:_run_charging(arg_5_1, arg_5_2, arg_5_3, arg_5_4) then
			return "done"
		end
	elseif var_5_1 == "finished" then
		return "done"
	elseif var_5_1 == "cancel" then
		arg_5_0:_run_cancel(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	end

	return "running", var_5_4
end

function BTChaosSorcererChargeAction._start_charging(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.action
	local var_6_1 = Managers.time:time("game")

	arg_6_2.charge_state = "charging"

	arg_6_2.locomotion_extension:set_rotation_speed(var_6_0.charge_rotation_speed)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_sorcerer_boss_fly_charge", arg_6_1)

	arg_6_2.charge_started_at_t = var_6_1
end

function BTChaosSorcererChargeAction._start_lunge(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_2.charge_state = "lunge"
	arg_7_2.time_to_impact = arg_7_5 + 0.25

	local var_7_0 = arg_7_3.enter_thresholds
	local var_7_1 = arg_7_0:_pick_distance_identifier(var_7_0, arg_7_4)

	if arg_7_3.animations then
		local var_7_2 = arg_7_3.animations[var_7_1]
	end

	local var_7_3 = arg_7_2.locomotion_extension
	local var_7_4 = var_7_3:current_velocity()
	local var_7_5 = arg_7_3.velocity_scaling[var_7_1]
	local var_7_6 = arg_7_4 / var_7_0[var_7_1]

	var_7_3:set_wanted_velocity(var_7_4 * var_7_5 * var_7_6)
	var_7_3:set_rotation_speed(arg_7_3.rotation_speed)

	arg_7_2.current_lunge_velocity_scale = var_7_5
end

function BTChaosSorcererChargeAction._start_impact(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	arg_8_2.charge_state = "impact"
	arg_8_2.hit_target = arg_8_3
end

function BTChaosSorcererChargeAction._start_align_to_target(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.action

	if not var_9_0.align_to_target_animation then
		arg_9_2.charge_state = "finished"

		return
	end

	local var_9_1 = arg_9_2.charge_target_unit
	local var_9_2 = Unit.world_position(var_9_1, 0)
	local var_9_3 = Unit.world_position(arg_9_1, 0)
	local var_9_4 = Vector3.normalize(var_9_3 - var_9_2)
	local var_9_5 = Quaternion.forward(Unit.local_rotation(arg_9_1, 0))
	local var_9_6 = Vector3.dot(var_9_5, var_9_4)

	if not (var_9_6 >= 0.4 and var_9_6 <= 1) then
		arg_9_2.charge_state = "finished"

		return
	end

	local var_9_7 = Managers.time:time("game")

	arg_9_2.charge_state = "align_to_target"

	local var_9_8 = var_9_0.align_to_target_animation
	local var_9_9 = var_9_7

	arg_9_2.end_align_t, arg_9_2.start_align_t = var_9_7 + var_9_0.end_align_t, var_9_9

	arg_9_2.locomotion_extension:use_lerp_rotation(true)
end

function BTChaosSorcererChargeAction._cancel_charge(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2.navigation_extension:set_enabled(false)

	local var_10_0 = arg_10_2.action.cancel_animation

	arg_10_2.charge_state = "cancel"

	arg_10_2.locomotion_extension:set_rotation_speed(nil)
end

function BTChaosSorcererChargeAction._check_lunge(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2.action

	arg_11_0:_check_overlap(arg_11_1, arg_11_2, var_11_0)

	if arg_11_3 > arg_11_2.time_to_impact then
		arg_11_0:_start_impact(arg_11_1, arg_11_2, true, false, false)
	end
end

local var_0_2 = {}

function BTChaosSorcererChargeAction._check_overlap(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = Managers.time:time("game")
	local var_12_1 = arg_12_3.radius
	local var_12_2 = arg_12_3.hit_radius
	local var_12_3 = arg_12_2.hit_units
	local var_12_4 = arg_12_2.pushed_units
	local var_12_5 = Unit.local_position(arg_12_1, 0) - Vector3.down()
	local var_12_6 = Unit.world_position(arg_12_1, Unit.node(arg_12_1, "j_head"))
	local var_12_7 = Quaternion.forward(Unit.local_rotation(arg_12_1, 0))
	local var_12_8
	local var_12_9
	local var_12_10 = arg_12_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_12_0 = 1, #var_12_10 do
		local var_12_11 = var_12_10[iter_12_0]
		local var_12_12 = POSITION_LOOKUP[var_12_11]
		local var_12_13 = Vector3.normalize(var_12_12 - var_12_5)
		local var_12_14 = var_12_12 - var_12_5
		local var_12_15 = Vector3.length(var_12_14)
		local var_12_16 = ScriptUnit.extension(var_12_11, "status_system")

		if var_12_16 and var_12_16:get_is_dodging() then
			var_12_2 = arg_12_3.target_dodged_radius
		end

		local var_12_17 = var_12_3[var_12_11]
		local var_12_18 = var_12_4[var_12_11]

		if not var_12_17 and var_12_15 < var_12_2 and var_12_16 and not var_12_16:is_invisible() then
			var_12_8, var_12_9 = arg_12_0:_hit_player(arg_12_1, arg_12_2, var_12_11, arg_12_3, var_12_13)
			var_12_3[var_12_11] = true
		elseif not var_12_17 and not var_12_18 and var_12_15 < var_12_1 and var_12_16 and not var_12_16:is_invisible() then
			arg_12_0:_push_player(arg_12_1, var_12_11, arg_12_2, arg_12_3)

			var_12_4[var_12_11] = true
		end
	end

	local var_12_19 = arg_12_2.group_blackboard.broadphase
	local var_12_20 = arg_12_3.hit_ai_radius
	local var_12_21 = Broadphase.query(var_12_19, var_12_5, var_12_20, var_0_2)

	for iter_12_1 = 1, var_12_21 do
		local var_12_22 = var_0_2[iter_12_1]
		local var_12_23 = POSITION_LOOKUP[var_12_22]
		local var_12_24 = Vector3.normalize(var_12_23 - var_12_5)

		if Vector3.dot(var_12_24, var_12_7) > 0 and var_12_22 ~= arg_12_1 and not var_12_3[var_12_22] then
			arg_12_0:_hit_ai(arg_12_1, var_12_22, arg_12_3, arg_12_2, var_12_0)
		end

		var_12_3[var_12_22] = true
		var_0_2[iter_12_1] = nil
	end

	return var_12_8, var_12_9
end

function BTChaosSorcererChargeAction._charged_at_player(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	if arg_13_4.catapult_player then
		local var_13_0 = POSITION_LOOKUP[arg_13_2] - POSITION_LOOKUP[arg_13_1]
		local var_13_1 = arg_13_3.locomotion_extension:current_velocity()
		local var_13_2 = Vector3.length(var_13_1) * Vector3.normalize(var_13_0)

		Vector3.set_z(var_13_2, arg_13_4.catapult_force_z or 3)
		StatusUtils.set_catapulted_network(arg_13_2, true, var_13_2)
	else
		StatusUtils.set_charged_network(arg_13_2, true)
	end
end

function BTChaosSorcererChargeAction._push_player(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = POSITION_LOOKUP[arg_14_2] - POSITION_LOOKUP[arg_14_1]
	local var_14_1 = arg_14_4.dodge_past_push_speed * Vector3.normalize(var_14_0)

	if not (arg_14_2 == arg_14_3.charge_target_unit) and arg_14_4.catapult_on_push_other_targets then
		local var_14_2 = arg_14_4.catapult_on_push_z

		Vector3.set_z(var_14_1, var_14_2 or 3)
		StatusUtils.set_catapulted_network(arg_14_2, true, var_14_1)
	else
		if arg_14_5 and arg_14_4.blocked_velocity_scale then
			var_14_1 = var_14_1 * arg_14_4.blocked_velocity_scale
		end

		ScriptUnit.extension(arg_14_2, "locomotion_system"):add_external_velocity(var_14_1)
	end
end

function BTChaosSorcererChargeAction._hit_player(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = arg_15_3 == arg_15_2.charge_target_unit
	local var_15_1 = ScriptUnit.has_extension(arg_15_3, "status_system")

	AiUtils.damage_target(arg_15_3, arg_15_1, arg_15_4, arg_15_4.damage)

	if arg_15_4.player_push_speed and not var_15_1.knocked_down then
		arg_15_0:_charged_at_player(arg_15_1, arg_15_3, arg_15_2, arg_15_4)
	end

	if var_15_0 then
		return true
	end

	return false
end

function BTChaosSorcererChargeAction._hit_ai(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	local var_16_0 = arg_16_3.push_ai
	local var_16_1 = BLACKBOARDS[arg_16_2]

	if var_16_0 then
		local var_16_2, var_16_3 = DamageUtils.calculate_stagger(var_16_0.stagger_impact, var_16_0.stagger_duration, arg_16_2, arg_16_1)

		if var_16_2 > var_0_0.none then
			local var_16_4 = POSITION_LOOKUP[arg_16_1]
			local var_16_5 = POSITION_LOOKUP[arg_16_2]
			local var_16_6 = Vector3.normalize(var_16_5 - var_16_4)
			local var_16_7 = Quaternion.right(Unit.local_rotation(arg_16_1, 0))
			local var_16_8 = Vector3.dot(var_16_7, var_16_6)
			local var_16_9 = -var_16_7

			if var_16_8 > 0 then
				var_16_9 = -var_16_9
			end

			AiUtils.stagger(arg_16_2, var_16_1, arg_16_1, var_16_9, var_16_0.stagger_distance, var_16_2, var_16_3, nil, arg_16_5, nil, nil, nil, true)
		end
	end

	AiUtils.damage_target(arg_16_2, arg_16_1, arg_16_3, arg_16_3.damage)
end

function BTChaosSorcererChargeAction._run_starting(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = LocomotionUtils.rotation_towards_unit_flat(arg_17_1, arg_17_2.charge_target_unit)

	arg_17_2.locomotion_extension:set_wanted_rotation(var_17_0)
	arg_17_2.charge_target_position:store(POSITION_LOOKUP[arg_17_2.charge_target_unit])
end

function BTChaosSorcererChargeAction._run_charging(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_2.action
	local var_18_1 = arg_18_2.charge_target_position:unbox()
	local var_18_2 = arg_18_2.locomotion_extension
	local var_18_3 = arg_18_2.navigation_extension
	local var_18_4 = POSITION_LOOKUP[arg_18_1]
	local var_18_5 = LocomotionUtils.rotation_towards_unit_flat(arg_18_1, arg_18_2.charge_target_unit)

	var_18_2:set_wanted_rotation(var_18_5)
	arg_18_2.stored_rotation:store(var_18_5)

	local var_18_6 = arg_18_3 - arg_18_2.charge_started_at_t
	local var_18_7 = var_18_0.charge_speed_min
	local var_18_8 = var_18_0.charge_speed_max
	local var_18_9 = var_18_6 / var_18_0.charge_max_speed_at
	local var_18_10 = math.min(var_18_7 + var_18_9 * (var_18_8 - var_18_7), var_18_8)
	local var_18_11 = Vector3.normalize(Vector3.flat(var_18_1 - var_18_4))
	local var_18_12 = arg_18_0:_get_turn_slowdown_percentage(arg_18_1, arg_18_2, arg_18_4, var_18_11)

	if var_18_12 then
		var_18_10 = var_18_8 * var_18_12
	end

	var_18_3:set_max_speed(var_18_10)

	local var_18_13 = Quaternion.forward(Unit.local_rotation(arg_18_1, 0)) * var_18_10

	var_18_2:set_wanted_velocity(var_18_13)

	arg_18_2.current_charge_speed = var_18_10

	local var_18_14 = Vector3.distance(var_18_4, var_18_1)
	local var_18_15 = arg_18_2.lunge_data

	if var_18_15 and var_18_14 <= var_18_15.enter_thresholds.far then
		return true
	end

	return false
end

function BTChaosSorcererChargeAction._run_lunge(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local var_19_0 = arg_19_2.locomotion_extension
	local var_19_1

	var_19_0:use_lerp_rotation(false)
	var_19_0:set_rotation_speed(nil)

	local var_19_2 = Unit.animation_wanted_root_pose(arg_19_1)
	local var_19_3 = Matrix4x4.rotation(var_19_2)

	var_19_0:set_wanted_rotation(var_19_3)

	local var_19_4 = arg_19_3.rotation_slow_down_speed

	arg_19_0:_check_lunge(arg_19_1, arg_19_2, arg_19_4)
	arg_19_0:_slow_down(arg_19_1, arg_19_2, var_19_4, arg_19_4, arg_19_5)
end

function BTChaosSorcererChargeAction._run_impact(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if arg_20_2.hit_target then
		local var_20_0 = LocomotionUtils.rotation_towards_unit_flat(arg_20_1, arg_20_2.charge_target_unit)

		arg_20_2.locomotion_extension:set_wanted_rotation(var_20_0)
	elseif arg_20_2.hit_during_impact_t and arg_20_3 < arg_20_2.hit_during_impact_t and arg_20_0:_check_overlap(arg_20_1, arg_20_2, arg_20_2.action) then
		arg_20_2.hit_during_impact_t = nil
	end

	local var_20_1 = arg_20_2.hit_target and arg_20_2.action.hit_target_slow_down_speed or arg_20_2.action.slow_down_speed

	arg_20_0:_slow_down(arg_20_1, arg_20_2, var_20_1, arg_20_3, arg_20_4)
end

function BTChaosSorcererChargeAction._run_cancel(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_2.action.cancel_slow_down_speed

	arg_21_0:_slow_down(arg_21_1, arg_21_2, var_21_0, arg_21_3, arg_21_4)
end

function BTChaosSorcererChargeAction._pick_distance_identifier(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0
	local var_22_1
	local var_22_2 = 0

	for iter_22_0, iter_22_1 in pairs(arg_22_1) do
		if arg_22_2 < iter_22_1 and var_22_2 < arg_22_2 then
			var_22_0 = iter_22_0

			break
		end

		var_22_2 = iter_22_1
		var_22_1 = iter_22_0
	end

	var_22_0 = var_22_0 or var_22_1

	return var_22_0
end

function BTChaosSorcererChargeAction._slow_down(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	local var_23_0 = arg_23_2.locomotion_extension
	local var_23_1 = var_23_0:current_velocity()
	local var_23_2 = Vector3.zero()
	local var_23_3 = math.min(arg_23_5 * arg_23_3, 1)
	local var_23_4 = Vector3.lerp(var_23_1, var_23_2, var_23_3)

	var_23_0:set_wanted_velocity(var_23_4)
end

function BTChaosSorcererChargeAction._get_turn_slowdown_percentage(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_2.action
	local var_24_1 = Unit.local_rotation(arg_24_1, 0)
	local var_24_2 = Quaternion.forward(var_24_1)
	local var_24_3 = Vector3.dot(var_24_2, arg_24_4)
	local var_24_4 = math.radians_to_degrees(math.acos(var_24_3))
	local var_24_5 = var_24_0.min_slowdown_angle
	local var_24_6 = var_24_0.max_slowdown_angle

	if var_24_3 > 1 or var_24_4 <= var_24_5 then
		return
	end

	return 1 - math.min((var_24_4 - var_24_5) / var_24_6, 1) * var_24_0.max_slowdown_percentage
end

function BTChaosSorcererChargeAction.anim_cb_start_finished(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0:_start_charging(arg_25_1, arg_25_2)

	if Managers.state.network:game() then
		local var_25_0 = arg_25_2.action.charge_notification_sound_event

		if var_25_0 and Unit.alive(arg_25_2.charge_target_unit) then
			local var_25_1 = Managers.player:unit_owner(arg_25_2.charge_target_unit):network_id()

			Managers.state.network.network_transmit:send_rpc("rpc_server_audio_event", var_25_1, NetworkLookup.sound_events[var_25_0])
		end
	end
end

function BTChaosSorcererChargeAction.anim_cb_charge_charging_finished(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_2.charge_state == "charging" then
		arg_26_0:_start_impact(arg_26_1, arg_26_2)
	end
end

function BTChaosSorcererChargeAction.anim_cb_charge_impact_finished(arg_27_0, arg_27_1, arg_27_2)
	arg_27_0:_start_align_to_target(arg_27_1, arg_27_2)
end

function BTChaosSorcererChargeAction.anim_cb_attack_finished(arg_28_0, arg_28_1, arg_28_2)
	return
end

function BTChaosSorcererChargeAction.anim_cb_disable_charge_collision(arg_29_0, arg_29_1, arg_29_2)
	arg_29_2.anim_cb_disable_charge_collision = true
end
