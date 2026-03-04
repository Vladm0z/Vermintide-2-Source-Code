-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_brain.lua

require("scripts/settings/player_bots_settings")
require("scripts/entity_system/systems/behaviour/behaviour_tree")
require("scripts/entity_system/systems/behaviour/bt_minion")
require("scripts/entity_system/systems/behaviour/bt_bot")
require("scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_globadier")

AIBrain = class(AIBrain)

local var_0_0 = BLACKBOARDS

AIBrain.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0._unit = arg_1_2
	var_0_0[arg_1_2] = arg_1_3
	arg_1_0._blackboard = arg_1_3
	arg_1_3.attacks_done = 0
	arg_1_3.breed = arg_1_4
	arg_1_3.destination_dist = 0
	arg_1_3.nav_target_dist_sq = 0

	arg_1_0:load_brain(arg_1_5)
	arg_1_0:init_utility_actions(arg_1_3, arg_1_4)
end

AIBrain.destroy = function (arg_2_0)
	if not Network.game_session() then
		return
	end

	arg_2_0:exit_last_action()
end

AIBrain.unfreeze = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_1.attacks_done = 0
	arg_3_1.destination_dist = 0
	arg_3_1.nav_target_dist_sq = 0

	arg_3_0:load_brain(arg_3_2)
	arg_3_0:init_utility_actions(arg_3_1, arg_3_1.breed)
end

AIBrain.init_utility_actions = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {}
	local var_4_1 = arg_4_0._bt:action_data()

	for iter_4_0, iter_4_1 in pairs(var_4_1) do
		if iter_4_1.considerations then
			var_4_0[iter_4_0] = {
				last_time = -math.huge,
				time_since_last = math.huge,
				last_done_time = -math.huge,
				time_since_last_done = math.huge
			}

			if iter_4_1.init_blackboard then
				for iter_4_2, iter_4_3 in pairs(iter_4_1.init_blackboard) do
					arg_4_1[iter_4_2] = iter_4_3
				end
			end
		end
	end

	arg_4_1.utility_actions = var_4_0
end

AIBrain.load_brain = function (arg_5_0, arg_5_1)
	arg_5_0._bt = Managers.state.entity:system("ai_system"):behavior_tree(arg_5_1)

	fassert(arg_5_0._bt, "Cannot find behavior tree '%s' specified for unit '%s'", arg_5_1, arg_5_0._unit)
end

AIBrain.bt = function (arg_6_0)
	return arg_6_0._bt
end

AIBrain.exit_last_action = function (arg_7_0)
	local var_7_0 = arg_7_0._blackboard

	var_7_0.exit_last_action = true

	local var_7_1 = arg_7_0._bt:root()
	local var_7_2 = Managers.time:time("game")

	var_7_1:set_running_child(arg_7_0._unit, var_7_0, var_7_2, nil, "aborted", true)
end

AIBrain.update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._bt:root():evaluate(arg_8_1, arg_8_0._blackboard, arg_8_2, arg_8_3)
end
