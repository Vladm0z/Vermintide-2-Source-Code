-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_gutter_runner.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_gutter_runner = class(BTSelector_gutter_runner, BTNode)
BTSelector_gutter_runner.name = "BTSelector_gutter_runner"

BTSelector_gutter_runner.init = function (self, ...)
	-- function 2
	BTSelector_gutter_runner.super.init(self, ...)

	self._children = {}
end

BTSelector_gutter_runner.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_gutter_runner.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local start = Profiler.start
	local stop = Profiler.stop
	local current_running_child = self:current_running_child(arg_4_2)
	local _children = self._children
	local var_4_4 = _children[1]
	local is_falling

	if not (arg_4_2.high_ground_opportunity or arg_4_2.pouncing_target) then
		is_falling = arg_4_2.is_falling

		if not is_falling then
			-- Nothing
		end

		if arg_4_2.fall_state == nil then
			-- Nothing
		end
	end

	is_falling = false

	goto label_4_1

	::label_4_0::

	is_falling = true

	::label_4_1::

	if not is_falling then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_4, "aborted")

		local run, var_4_7 = var_4_4:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run)
		end

		if run ~= "failed" then
			return run, var_4_7
		end
	elseif var_4_4 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_8 = _children[2]
	local var_4_9

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_9 = true
		end
	end

	if not var_4_9 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_8, "aborted")

		local run_2, var_4_11 = var_4_8:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_2 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_2)
		end

		if run_2 ~= "failed" then
			return run_2, var_4_11
		end
	elseif var_4_8 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_12 = _children[3]

	if not arg_4_2.spawn then
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

	if not arg_4_2.in_vortex then
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
	local var_4_19

	if not arg_4_2.jump_data then
		var_4_19 = false
	end

	if var_4_19 == nil then
		var_4_19 = BTConditions.at_smartobject(arg_4_2)
	end

	if not var_4_19 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_18, "aborted")

		local run_5, var_4_21 = var_4_18:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_5 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_5)
		end

		if run_5 ~= "failed" then
			return run_5, var_4_21
		end
	elseif var_4_18 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_22 = _children[6]

	if not arg_4_2.ninja_vanish then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_22, "aborted")

		local run_6, var_4_24 = var_4_22:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_6 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_6)
		end

		if run_6 ~= "failed" then
			return run_6, var_4_24
		end
	elseif var_4_22 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_25 = _children[7]

	if not arg_4_2.high_ground_opportunity then
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
	local time = Managers.time:time("game")
	local flag = time > arg_4_2.initial_pounce_timer
	local comitted_to_target

	if not arg_4_2.target_unit then
		comitted_to_target = arg_4_2.comitted_to_target

		if not comitted_to_target then
			-- Nothing
		end
	end

	comitted_to_target = flag

	::label_4_2::

	if not comitted_to_target then
		self:set_running_child(arg_4_1, arg_4_2, time, var_4_28, "aborted")

		local run_8, var_4_33 = var_4_28:run(arg_4_1, arg_4_2, time, arg_4_4)

		if run_8 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, time, nil, run_8)
		end

		if run_8 ~= "failed" then
			return run_8, var_4_33
		end
	elseif var_4_28 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, time, nil, "failed")
	end

	local var_4_34 = _children[9]

	if not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_34, "aborted")

		local run_9, var_4_36 = var_4_34:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_9 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_9)
		end

		if run_9 ~= "failed" then
			return run_9, var_4_36
		end
	elseif var_4_34 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_37 = _children[10]

	if not arg_4_2.secondary_target then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_37, "aborted")

		local run_10, var_4_39 = var_4_37:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_10 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_10)
		end

		if run_10 ~= "failed" then
			return run_10, var_4_39
		end
	elseif var_4_37 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_40 = _children[11]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_40, "aborted")

	local run_11, var_4_42 = var_4_40:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_11 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_11)
	end

	if run_11 ~= "failed" then
		return run_11, var_4_42
	end
end

BTSelector_gutter_runner.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
