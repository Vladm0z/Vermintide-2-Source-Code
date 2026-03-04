-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_jump_slam_impact_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")
local var_0_1 = POSITION_LOOKUP

BTJumpSlamImpactAction = class(BTJumpSlamImpactAction, BTNode)

BTJumpSlamImpactAction.init = function (arg_1_0, ...)
	BTJumpSlamImpactAction.super.init(arg_1_0, ...)
end

BTJumpSlamImpactAction.name = "BTJumpSlamImpactAction"

BTJumpSlamImpactAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0

	arg_2_2.action, var_2_0 = arg_2_0._tree_node.action_data, arg_2_2.target_unit
	arg_2_2.active_node = BTJumpSlamImpactAction
	arg_2_2.attack_finished = nil
	arg_2_2.attacking_target = var_2_0
end

BTJumpSlamImpactAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.action = nil
	arg_3_2.active_node = nil
	arg_3_2.attacking_target = nil
	arg_3_2.keep_target = nil
	arg_3_2.jump_slam_data = nil

	arg_3_2.navigation_extension:set_enabled(true)

	if not arg_3_5 then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false, true)
	end
end

BTJumpSlamImpactAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.anim_cb_damage then
		arg_4_2.anim_cb_damage = nil

		if not arg_4_2.is_illusion then
			arg_4_0:jump_slam_impact(arg_4_1, arg_4_2, arg_4_3)
		end

		arg_4_2.attacking_target = nil
	elseif arg_4_2.attack_finished then
		return "done"
	end

	return "running"
end

BTJumpSlamImpactAction.jump_slam_impact = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_2.action
	local var_5_1 = var_0_1[arg_5_1]

	BTJumpSlamImpactAction.impact_damage(arg_5_1, arg_5_3, var_5_0.stagger_radius, var_5_0.stagger_distance, var_5_0.stagger_impact, var_5_0.damage, var_5_0.damage_type, var_5_0.hit_react_type, var_5_0.max_damage_radius, var_5_1)

	if var_5_0.catapult_players then
		local var_5_2 = arg_5_2.side.ENEMY_PLAYER_AND_BOT_UNITS

		BTJumpSlamImpactAction.catapult_players(var_5_2, var_5_1, var_5_0.catapult_within_radius, var_5_0.catapulted_player_speed)
	end
end

BTJumpSlamImpactAction.catapult_players = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	for iter_6_0 = 1, #arg_6_0 do
		local var_6_0 = arg_6_0[iter_6_0]

		BTJumpSlamImpactAction.catapult_player(var_6_0, arg_6_1, arg_6_2, arg_6_3)
	end
end

BTJumpSlamImpactAction.catapult_player = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = var_0_1[arg_7_0] - arg_7_1

	if arg_7_2 < Vector3.length(var_7_0) then
		return
	end

	local var_7_1 = math.pi / 6
	local var_7_2 = Vector3.normalize(Vector3.flat(var_7_0))
	local var_7_3 = arg_7_3 * math.cos(var_7_1)
	local var_7_4

	var_7_4.z, var_7_4 = arg_7_3 * math.sin(var_7_1), var_7_2 * var_7_3

	StatusUtils.set_catapulted_network(arg_7_0, true, var_7_4)
end

local var_0_2 = {}

BTJumpSlamImpactAction.impact_damage = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9)
	local var_8_0 = arg_8_2 - arg_8_8
	local var_8_1 = AiUtils.broadphase_query(arg_8_9, arg_8_2, var_0_2)
	local var_8_2 = BLACKBOARDS

	for iter_8_0 = 1, var_8_1 do
		local var_8_3 = var_0_2[iter_8_0]

		if var_8_3 ~= arg_8_0 and HEALTH_ALIVE[var_8_3] then
			local var_8_4 = var_0_1[var_8_3] - arg_8_9
			local var_8_5, var_8_6 = DamageUtils.calculate_stagger(arg_8_4, nil, var_8_3, arg_8_0)
			local var_8_7 = 1
			local var_8_8 = var_8_2[var_8_3]

			if var_8_5 > var_0_0.none then
				AiUtils.stagger(var_8_3, var_8_8, arg_8_0, var_8_4, arg_8_3, var_8_5, var_8_7, nil, arg_8_1)
			end

			if arg_8_5 and arg_8_5 > 0 then
				local var_8_9 = Vector3.normalize(Vector3(Vector3.x(var_8_4), Vector3.y(var_8_4), 0))
				local var_8_10 = Vector3.length(var_8_4)

				if var_8_10 < arg_8_2 then
					local var_8_11

					if arg_8_8 < var_8_10 then
						var_8_11 = arg_8_5 * ((var_8_10 - arg_8_8) / var_8_0)
					else
						var_8_11 = arg_8_5
					end

					DamageUtils.add_damage_network(var_8_3, arg_8_0, var_8_11, "full", arg_8_6, nil, Vector3(0, 0, -1), nil, nil, nil, nil, arg_8_7, nil, nil, nil, nil, nil, nil, iter_8_0)
				end
			end
		end
	end
end
