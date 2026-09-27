-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_target_pounced_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTargetPouncedAction = class(BTTargetPouncedAction, BTNode)

BTTargetPouncedAction.init = function (arg_1_0, ...)
	-- function 1
	BTTargetPouncedAction.super.init(arg_1_0, ...)
end

BTTargetPouncedAction.name = "BTTargetPouncedAction"

local POSITION_LOOKUP = POSITION_LOOKUP

BTTargetPouncedAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local locomotion_extension = arg_2_2.locomotion_extension
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.active_node = BTTargetPouncedAction
	arg_2_2.start_pouncing_time = arg_2_3

	local jump_data = arg_2_2.jump_data
	local target_unit = jump_data.target_unit
	local var_2_4 = POSITION_LOOKUP[target_unit]

	if not AiUtils.is_of_interest_to_gutter_runner(arg_2_1, jump_data.target_unit, arg_2_2, true) then
		arg_2_2.already_pounced = true

		Mover.set_position(Unit.mover(arg_2_1), var_2_4)
		locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
		locomotion_extension:set_affected_by_gravity(true)

		return
	end

	local breed = arg_2_2.breed

	if not action_data.stab_until_target_is_killed then
		ScriptUnit.extension(arg_2_1, "ai_system"):set_perception("perception_no_seeing", "pick_no_targets")
	end

	arg_2_2.pouncing_target = true

	arg_2_2.navigation_extension:set_enabled(false)

	local var_2_6 = POSITION_LOOKUP[target_unit]
	local local_rotation = Unit.local_rotation(target_unit, 0)

	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:teleport_to(var_2_6)

	local mover = Unit.mover(arg_2_1)

	Mover.set_position(mover, var_2_6)
	LocomotionUtils.separate_mover_fallbacks(mover, 1)

	local position = Mover.position(mover)

	Unit.set_local_position(arg_2_1, 0, position)

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_2_1)

	network.network_transmit:send_rpc_clients("rpc_teleport_unit_to", unit_game_object_id, position, Quaternion.identity())
	LocomotionUtils.set_animation_driven_movement(arg_2_1, true, true, false)

	local extension = ScriptUnit.extension(target_unit, "status_system")

	extension:set_pounced_down(true, arg_2_1)
	extension:add_pacing_intensity(CurrentIntensitySettings.intensity_add_pounced_down)

	local total_distance = jump_data.total_distance
	local name = breed.name
	local num = DamageUtils.calculate_damage(breed.pounce_impact_damage) + total_distance * breed.pounce_bonus_dmg_per_meter

	DamageUtils.add_damage_network(target_unit, arg_2_1, num, "torso", "cutting", nil, Vector3(1, 0, 0), name, nil, nil, nil, action_data.hit_react_type, nil, nil, nil, nil, nil, nil, 1)
	BTTargetPouncedAction.impact_pushback(arg_2_1, var_2_6, action_data.close_impact_radius, action_data.far_impact_radius, action_data.impact_speed_given, arg_2_2.target_unit)

	local disabled_by_special = arg_2_2.group_blackboard.disabled_by_special

	if not disabled_by_special[target_unit] then
		disabled_by_special[target_unit] = arg_2_1
	end

	if not script_data.debug_player_intensity then
		Managers.state.conflict.pacing:annotate_graph("pounced", "red")
	end
end

BTTargetPouncedAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	aiprint("LEAVE TARGET POUNCED ACTION")

	local target_unit = arg_3_2.jump_data.target_unit

	arg_3_2.active_node = nil

	if not arg_3_2.already_pounced then
		if not arg_3_2.action.stab_until_target_is_killed then
			local breed = arg_3_2.breed

			ScriptUnit.extension(arg_3_1, "ai_system"):set_perception(breed.perception, breed.target_selection)
		end

		local disabled_by_special = arg_3_2.group_blackboard.disabled_by_special

		if disabled_by_special[target_unit] == arg_3_1 then
			disabled_by_special[target_unit] = nil
		end

		if not Unit.alive(target_unit) then
			ScriptUnit.extension(target_unit, "status_system"):set_pounced_down(false, arg_3_1)

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

	if not arg_3_2.stagger then
		arg_3_2.ninja_vanish = true
	end
end

BTTargetPouncedAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not arg_4_2.already_pounced then
		return "failed"
	end

	local jump_data = arg_4_2.jump_data

	if not AiUtils.is_of_interest_to_gutter_runner(arg_4_1, jump_data.target_unit, arg_4_2, arg_4_2.action.stab_until_target_is_killed) then
		local network = Managers.state.network

		if not arg_4_2.action.foff_after_pounce_kill then
			arg_4_2.ninja_vanish = true
		else
			network:anim_event(arg_4_1, "idle")
		end

		return "failed"
	end

	return "running"
end

BTTargetPouncedAction.impact_pushback = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_5_0].ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_5_1 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not (var_5_1 == arg_5_5 or ScriptUnit.extension(var_5_1, "status_system"):is_disabled()) then
			local num = POSITION_LOOKUP[var_5_1] - arg_5_1
			local length = Vector3.length(num)

			if length < arg_5_3 then
				local var_5_4

				if length <= arg_5_2 then
					var_5_4 = Vector3.normalize(num) * arg_5_4
				else
					var_5_4 = Vector3.normalize(num) * (1 - (length - arg_5_2) / (arg_5_3 - arg_5_2)) * arg_5_4
				end

				if not script_data.debug_ai_movement then
					aiprint("Gutter runner pounced: push-speed:", Vector3.length(var_5_4), "dist:", length, "unit:", var_5_1)
				end

				ScriptUnit.extension(var_5_1, "locomotion_system"):add_external_velocity(var_5_4)
			end
		end
	end
end

local tbl = {
	0,
	0,
	0
}

BTTargetPouncedAction.direct_damage = function (arg_6_0, arg_6_1)
	-- function 6
	local action = arg_6_1.action

	if not action then
		return
	end

	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_6_2 = action.time_before_ramping_damage[get_difficulty_rank]

	var_6_2 = var_6_2 or action.time_before_ramping_damage[2]

	local var_6_3 = action.time_to_reach_final_damage_multiplier[get_difficulty_rank]

	var_6_3 = var_6_3 or action.time_to_reach_final_damage_multiplier[2]

	local num = (Managers.time:time("game") - arg_6_1.start_pouncing_time - var_6_2) / var_6_3
	local clamp = math.clamp(num, 0, 1)
	local num_2 = action.damage * (1 + clamp * action.final_damage_multiplier)
	local target_unit = arg_6_1.jump_data.target_unit

	AiUtils.damage_target(target_unit, arg_6_0, arg_6_1.action, num_2)
end
