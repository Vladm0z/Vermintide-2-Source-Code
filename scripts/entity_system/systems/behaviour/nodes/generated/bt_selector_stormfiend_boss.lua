-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_stormfiend_boss.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_stormfiend_boss = class(BTSelector_stormfiend_boss, BTNode)
BTSelector_stormfiend_boss.name = "BTSelector_stormfiend_boss"

BTSelector_stormfiend_boss.init = function (self, ...)
	-- function 2
	BTSelector_stormfiend_boss.super.init(self, ...)

	self._children = {}
end

BTSelector_stormfiend_boss.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_stormfiend_boss.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local start = Profiler.start
	local stop = Profiler.stop
	local current_running_child = self:current_running_child(arg_4_2)
	local _children = self._children
	local var_4_4 = _children[1]

	if not arg_4_2.spawn then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_4, "aborted")

		local run, var_4_6 = var_4_4:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run)
		end

		if run ~= "failed" then
			return run, var_4_6
		end
	elseif var_4_4 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_7 = _children[2]
	local jump_down_intro = arg_4_2.jump_down_intro
	local at_smartobject = BTConditions.at_smartobject(arg_4_2)

	at_smartobject = not at_smartobject and jump_down_intro

	if not at_smartobject then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_7, "aborted")

		local run_2, var_4_11 = var_4_7:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_2 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_2)
		end

		if run_2 ~= "failed" then
			return run_2, var_4_11
		end
	elseif var_4_7 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_12 = _children[3]

	if not (arg_4_2.should_mount_unit ~= nil) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_12, "aborted")

		local run_3, var_4_14 = var_4_12:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_3 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_3)
		end

		if run_3 ~= "failed" then
			return run_3, var_4_14
		end
	elseif var_4_12 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_15 = _children[4]

	if not (arg_4_2.goal_destination ~= nil) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_15, "aborted")

		local run_4, var_4_17 = var_4_15:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_4 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_4)
		end

		if run_4 ~= "failed" then
			return run_4, var_4_17
		end
	elseif var_4_15 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_18 = _children[5]

	if not arg_4_2.intro_rage then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_18, "aborted")

		local run_5, var_4_20 = var_4_18:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_5 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_5)
		end

		if run_5 ~= "failed" then
			return run_5, var_4_20
		end
	elseif var_4_18 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_21 = _children[6]
	local var_4_22

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_22 = true
		end
	end

	if not var_4_22 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_21, "aborted")

		local run_6, var_4_24 = var_4_21:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_6 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_6)
		end

		if run_6 ~= "failed" then
			return run_6, var_4_24
		end
	elseif var_4_21 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_25 = _children[7]

	if not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_25, "aborted")

		local run_7, var_4_27 = var_4_25:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_7 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_7)
		end

		if run_7 ~= "failed" then
			return run_7, var_4_27
		end
	elseif var_4_25 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_28 = _children[8]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_28, "aborted")

	local run_8, var_4_30 = var_4_28:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_8 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_8)
	end

	if run_8 ~= "failed" then
		return run_8, var_4_30
	end
end

BTSelector_stormfiend_boss.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
