-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_shadow_totem.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_shadow_totem = class(BTSelector_shadow_totem, BTNode)
BTSelector_shadow_totem.name = "BTSelector_shadow_totem"

BTSelector_shadow_totem.init = function (self, ...)
	-- function 2
	BTSelector_shadow_totem.super.init(self, ...)

	self._children = {}
end

BTSelector_shadow_totem.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_shadow_totem.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local start = Profiler.start
	local stop = Profiler.stop
	local current_running_child = self:current_running_child(arg_4_2)
	local var_4_3 = self._children[1]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_3, "aborted")

	local run, var_4_5 = var_4_3:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run)
	end

	if run ~= "failed" then
		return run, var_4_5
	end
end

BTSelector_shadow_totem.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
