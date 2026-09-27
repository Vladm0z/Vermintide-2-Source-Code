-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_tower_homing_skull.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_tower_homing_skull = class(BTSelector_tower_homing_skull, BTNode)
BTSelector_tower_homing_skull.name = "BTSelector_tower_homing_skull"

BTSelector_tower_homing_skull.init = function (self, ...)
	-- function 2
	BTSelector_tower_homing_skull.super.init(self, ...)

	self._children = {}
end

BTSelector_tower_homing_skull.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_tower_homing_skull.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local start = Profiler.start
	local stop = Profiler.stop
	local current_running_child = self:current_running_child(arg_4_2)
	local var_4_3 = self._children[1]

	if not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_3, "aborted")

		local run, var_4_5 = var_4_3:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run)
		end

		if run ~= "failed" then
			return run, var_4_5
		end
	elseif var_4_3 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end
end

BTSelector_tower_homing_skull.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
