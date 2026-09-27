-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_brain.lua

require("scripts/settings/player_bots_settings")
require("scripts/entity_system/systems/behaviour/behaviour_tree")
require("scripts/entity_system/systems/behaviour/bt_minion")
require("scripts/entity_system/systems/behaviour/bt_bot")
require("scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_globadier")

AIBrain = class(AIBrain)

local BLACKBOARDS = BLACKBOARDS

AIBrain.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	self._unit = arg_1_2
	BLACKBOARDS[arg_1_2] = arg_1_3
	self._blackboard = arg_1_3
	arg_1_3.attacks_done = 0
	arg_1_3.breed = arg_1_4
	arg_1_3.destination_dist = 0
	arg_1_3.nav_target_dist_sq = 0

	self:load_brain(arg_1_5)
	self:init_utility_actions(arg_1_3, arg_1_4)
end

AIBrain.destroy = function (self)
	-- function 2
	if not Network.game_session() then
		return
	end

	self:exit_last_action()
end

AIBrain.unfreeze = function (self, arg_3_1, arg_3_2)
	-- function 3
	arg_3_1.attacks_done = 0
	arg_3_1.destination_dist = 0
	arg_3_1.nav_target_dist_sq = 0

	self:load_brain(arg_3_2)
	self:init_utility_actions(arg_3_1, arg_3_1.breed)
end

AIBrain.init_utility_actions = function (self, arg_4_1, arg_4_2)
	-- function 4
	local tbl = {}
	local action_data = self._bt:action_data()

	for k, v in pairs(action_data) do
		if not v.considerations then
			tbl[k] = {
				last_time = -math.huge,
				time_since_last = math.huge,
				last_done_time = -math.huge,
				time_since_last_done = math.huge
			}

			if not v.init_blackboard then
				for k_2, v_2 in pairs(v.init_blackboard) do
					arg_4_1[k_2] = v_2
				end
			end
		end
	end

	arg_4_1.utility_actions = tbl
end

AIBrain.load_brain = function (self, arg_5_1)
	-- function 5
	self._bt = Managers.state.entity:system("ai_system"):behavior_tree(arg_5_1)

	fassert(self._bt, "Cannot find behavior tree '%s' specified for unit '%s'", arg_5_1, self._unit)
end

AIBrain.bt = function (self)
	-- function 6
	return self._bt
end

AIBrain.exit_last_action = function (self)
	-- function 7
	local _blackboard = self._blackboard

	_blackboard.exit_last_action = true

	local root = self._bt:root()
	local time = Managers.time:time("game")

	root:set_running_child(self._unit, _blackboard, time, nil, "aborted", true)
end

AIBrain.update = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local evaluate = self._bt:root():evaluate(arg_8_1, self._blackboard, arg_8_2, arg_8_3)
end
