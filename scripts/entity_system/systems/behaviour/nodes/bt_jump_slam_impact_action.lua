-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_jump_slam_impact_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")
local POSITION_LOOKUP = POSITION_LOOKUP

BTJumpSlamImpactAction = class(BTJumpSlamImpactAction, BTNode)

BTJumpSlamImpactAction.init = function (arg_1_0, ...)
	-- function 1
	BTJumpSlamImpactAction.super.init(arg_1_0, ...)
end

BTJumpSlamImpactAction.name = "BTJumpSlamImpactAction"

BTJumpSlamImpactAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local target_unit

	arg_2_2.action, target_unit = self._tree_node.action_data, arg_2_2.target_unit
	arg_2_2.active_node = BTJumpSlamImpactAction
	arg_2_2.attack_finished = nil
	arg_2_2.attacking_target = target_unit
end

BTJumpSlamImpactAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
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

BTJumpSlamImpactAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not arg_4_2.anim_cb_damage then
		arg_4_2.anim_cb_damage = nil

		if not arg_4_2.is_illusion then
			self:jump_slam_impact(arg_4_1, arg_4_2, arg_4_3)
		end

		arg_4_2.attacking_target = nil
	elseif not arg_4_2.attack_finished then
		return "done"
	end

	return "running"
end

BTJumpSlamImpactAction.jump_slam_impact = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local action = arg_5_2.action
	local var_5_1 = POSITION_LOOKUP[arg_5_1]

	BTJumpSlamImpactAction.impact_damage(arg_5_1, arg_5_3, action.stagger_radius, action.stagger_distance, action.stagger_impact, action.damage, action.damage_type, action.hit_react_type, action.max_damage_radius, var_5_1)

	if not action.catapult_players then
		local ENEMY_PLAYER_AND_BOT_UNITS = arg_5_2.side.ENEMY_PLAYER_AND_BOT_UNITS

		BTJumpSlamImpactAction.catapult_players(ENEMY_PLAYER_AND_BOT_UNITS, var_5_1, action.catapult_within_radius, action.catapulted_player_speed)
	end
end

BTJumpSlamImpactAction.catapult_players = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	for i = 1, #self do
		local var_6_0 = self[i]

		BTJumpSlamImpactAction.catapult_player(var_6_0, arg_6_1, arg_6_2, arg_6_3)
	end
end

BTJumpSlamImpactAction.catapult_player = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local num = POSITION_LOOKUP[arg_7_0] - arg_7_1

	if arg_7_2 < Vector3.length(num) then
		return
	end

	local num_2 = math.pi / 6
	local normalize = Vector3.normalize(Vector3.flat(num))
	local num_3 = arg_7_3 * math.cos(num_2)
	local num_4

	num_4.z, num_4 = arg_7_3 * math.sin(num_2), normalize * num_3

	StatusUtils.set_catapulted_network(arg_7_0, true, num_4)
end

local tbl = {}

BTJumpSlamImpactAction.impact_damage = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9)
	-- function 8
	local num = arg_8_2 - arg_8_8
	local broadphase_query = AiUtils.broadphase_query(arg_8_9, arg_8_2, tbl)
	local BLACKBOARDS = BLACKBOARDS

	for i = 1, broadphase_query do
		local var_8_3 = tbl[i]

		if var_8_3 == arg_8_0 or not HEALTH_ALIVE[var_8_3] then
			local num_2 = POSITION_LOOKUP[var_8_3] - arg_8_9
			local calculate_stagger, var_8_6 = DamageUtils.calculate_stagger(arg_8_4, nil, var_8_3, arg_8_0)
			local num_3 = 1
			local var_8_8 = BLACKBOARDS[var_8_3]

			if calculate_stagger > scripts_utils_stagger_types.none then
				AiUtils.stagger(var_8_3, var_8_8, arg_8_0, num_2, arg_8_3, calculate_stagger, num_3, nil, arg_8_1)
			end

			if not (not arg_8_5 and not (arg_8_5 > 0)) then
				local normalize = Vector3.normalize(Vector3(Vector3.x(num_2), Vector3.y(num_2), 0))
				local length = Vector3.length(num_2)

				if not (length < arg_8_2) then
					local var_8_11

					if arg_8_8 < length then
						var_8_11 = arg_8_5 * ((length - arg_8_8) / num)
					else
						var_8_11 = arg_8_5
					end

					DamageUtils.add_damage_network(var_8_3, arg_8_0, var_8_11, "full", arg_8_6, nil, Vector3(0, 0, -1), nil, nil, nil, nil, arg_8_7, nil, nil, nil, nil, nil, nil, i)
				end
			end
		end
	end
end
