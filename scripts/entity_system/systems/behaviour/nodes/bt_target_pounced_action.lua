-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_target_pounced_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTargetPouncedAction = class(BTTargetPouncedAction, BTNode)

function BTTargetPouncedAction.init(arg_1_0, ...)
	BTTargetPouncedAction.super.init(arg_1_0, ...)
end

BTTargetPouncedAction.name = "BTTargetPouncedAction"

local var_0_0 = POSITION_LOOKUP

function BTTargetPouncedAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.locomotion_extension
	local var_2_1 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_1
	arg_2_2.active_node = BTTargetPouncedAction
	arg_2_2.start_pouncing_time = arg_2_3

	local var_2_2 = arg_2_2.jump_data
	local var_2_3 = var_2_2.target_unit
	local var_2_4 = var_0_0[var_2_3]

	if not AiUtils.is_of_interest_to_gutter_runner(arg_2_1, var_2_2.target_unit, arg_2_2, true) then
		arg_2_2.already_pounced = true

		Mover.set_position(Unit.mover(arg_2_1), var_2_4)
		var_2_0:set_wanted_velocity(Vector3(0, 0, 0))
		var_2_0:set_affected_by_gravity(true)

		return
	end

	local var_2_5 = arg_2_2.breed

	if var_2_1.stab_until_target_is_killed then
		ScriptUnit.extension(arg_2_1, "ai_system"):set_perception("perception_no_seeing", "pick_no_targets")
	end

	arg_2_2.pouncing_target = true

	arg_2_2.navigation_extension:set_enabled(false)

	local var_2_6 = var_0_0[var_2_3]
	local var_2_7 = Unit.local_rotation(var_2_3, 0)

	var_2_0:set_wanted_velocity(Vector3.zero())
	var_2_0:teleport_to(var_2_6)

	local var_2_8 = Unit.mover(arg_2_1)

	Mover.set_position(var_2_8, var_2_6)
	LocomotionUtils.separate_mover_fallbacks(var_2_8, 1)

	local var_2_9 = Mover.position(var_2_8)

	Unit.set_local_position(arg_2_1, 0, var_2_9)

	local var_2_10 = Managers.state.network
	local var_2_11 = var_2_10:unit_game_object_id(arg_2_1)

	var_2_10.network_transmit:send_rpc_clients("rpc_teleport_unit_to", var_2_11, var_2_9, Quaternion.identity())
	LocomotionUtils.set_animation_driven_movement(arg_2_1, true, true, false)

	local var_2_12 = ScriptUnit.extension(var_2_3, "status_system")

	var_2_12:set_pounced_down(true, arg_2_1)
	var_2_12:add_pacing_intensity(CurrentIntensitySettings.intensity_add_pounced_down)

	local var_2_13 = var_2_2.total_distance
	local var_2_14 = var_2_5.name
	local var_2_15 = DamageUtils.calculate_damage(var_2_5.pounce_impact_damage) + var_2_13 * var_2_5.pounce_bonus_dmg_per_meter

	DamageUtils.add_damage_network(var_2_3, arg_2_1, var_2_15, "torso", "cutting", nil, Vector3(1, 0, 0), var_2_14, nil, nil, nil, var_2_1.hit_react_type, nil, nil, nil, nil, nil, nil, 1)
	BTTargetPouncedAction.impact_pushback(arg_2_1, var_2_6, var_2_1.close_impact_radius, var_2_1.far_impact_radius, var_2_1.impact_speed_given, arg_2_2.target_unit)

	local var_2_16 = arg_2_2.group_blackboard.disabled_by_special

	if not var_2_16[var_2_3] then
		var_2_16[var_2_3] = arg_2_1
	end

	if script_data.debug_player_intensity then
		Managers.state.conflict.pacing:annotate_graph("pounced", "red")
	end
end

function BTTargetPouncedAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	aiprint("LEAVE TARGET POUNCED ACTION")

	local var_3_0 = arg_3_2.jump_data.target_unit

	arg_3_2.active_node = nil

	if not arg_3_2.already_pounced then
		if arg_3_2.action.stab_until_target_is_killed then
			local var_3_1 = arg_3_2.breed

			ScriptUnit.extension(arg_3_1, "ai_system"):set_perception(var_3_1.perception, var_3_1.target_selection)
		end

		local var_3_2 = arg_3_2.group_blackboard.disabled_by_special

		if var_3_2[var_3_0] == arg_3_1 then
			var_3_2[var_3_0] = nil
		end

		if Unit.alive(var_3_0) then
			ScriptUnit.extension(var_3_0, "status_system"):set_pounced_down(false, arg_3_1)

			if not arg_3_5 then
				LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
			end
		end

		if not arg_3_5 then
			arg_3_2.locomotion_extension:set_wanted_rotation(nil)
		end
	else
		arg_3_2.already_pounced = nil
	end

	arg_3_2.high_ground_opportunity = nil
	arg_3_2.jump_data = nil
	arg_3_2.action = nil
	arg_3_2.pouncing_target = nil

	if not arg_3_5 then
		arg_3_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	arg_3_2.navigation_extension:set_enabled(true)

	if arg_3_2.stagger then
		arg_3_2.ninja_vanish = true
	end
end

function BTTargetPouncedAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.already_pounced then
		return "failed"
	end

	local var_4_0 = arg_4_2.jump_data

	if not AiUtils.is_of_interest_to_gutter_runner(arg_4_1, var_4_0.target_unit, arg_4_2, arg_4_2.action.stab_until_target_is_killed) then
		local var_4_1 = Managers.state.network

		if arg_4_2.action.foff_after_pounce_kill then
			arg_4_2.ninja_vanish = true
		else
			var_4_1:anim_event(arg_4_1, "idle")
		end

		return "failed"
	end

	return "running"
end

function BTTargetPouncedAction.impact_pushback(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = Managers.state.side.side_by_unit[arg_5_0].ENEMY_PLAYER_AND_BOT_UNITS

	for iter_5_0 = 1, #var_5_0 do
		local var_5_1 = var_5_0[iter_5_0]

		if var_5_1 ~= arg_5_5 and not ScriptUnit.extension(var_5_1, "status_system"):is_disabled() then
			local var_5_2 = var_0_0[var_5_1] - arg_5_1
			local var_5_3 = Vector3.length(var_5_2)

			if var_5_3 < arg_5_3 then
				local var_5_4

				if var_5_3 <= arg_5_2 then
					var_5_4 = Vector3.normalize(var_5_2) * arg_5_4
				else
					var_5_4 = Vector3.normalize(var_5_2) * (1 - (var_5_3 - arg_5_2) / (arg_5_3 - arg_5_2)) * arg_5_4
				end

				if script_data.debug_ai_movement then
					aiprint("Gutter runner pounced: push-speed:", Vector3.length(var_5_4), "dist:", var_5_3, "unit:", var_5_1)
				end

				ScriptUnit.extension(var_5_1, "locomotion_system"):add_external_velocity(var_5_4)
			end
		end
	end
end

local var_0_1 = {
	0,
	0,
	0
}

function BTTargetPouncedAction.direct_damage(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.action

	if not var_6_0 then
		return
	end

	local var_6_1 = Managers.state.difficulty:get_difficulty_rank()
	local var_6_2 = var_6_0.time_before_ramping_damage[var_6_1] or var_6_0.time_before_ramping_damage[2]
	local var_6_3 = var_6_0.time_to_reach_final_damage_multiplier[var_6_1] or var_6_0.time_to_reach_final_damage_multiplier[2]
	local var_6_4 = (Managers.time:time("game") - arg_6_1.start_pouncing_time - var_6_2) / var_6_3
	local var_6_5 = math.clamp(var_6_4, 0, 1)
	local var_6_6 = var_6_0.damage * (1 + var_6_5 * var_6_0.final_damage_multiplier)
	local var_6_7 = arg_6_1.jump_data.target_unit

	AiUtils.damage_target(var_6_7, arg_6_0, arg_6_1.action, var_6_6)
end
