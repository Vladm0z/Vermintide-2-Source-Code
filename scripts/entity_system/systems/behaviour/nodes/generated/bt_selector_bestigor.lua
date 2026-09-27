-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_bestigor.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_bestigor = class(BTSelector_bestigor, BTNode)
BTSelector_bestigor.name = "BTSelector_bestigor"

BTSelector_bestigor.init = function (self, ...)
	-- function 2
	BTSelector_bestigor.super.init(self, ...)

	self._children = {}
end

BTSelector_bestigor.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_bestigor.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if not arg_4_2.in_vortex then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_7, "aborted")

		local run_2, var_4_9 = var_4_7:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_2 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_2)
		end

		if run_2 ~= "failed" then
			return run_2, var_4_9
		end
	elseif var_4_7 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_10 = _children[3]

	if not arg_4_2.gravity_well_position then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_10, "aborted")

		local run_3, var_4_12 = var_4_10:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_3 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_3)
		end

		if run_3 ~= "failed" then
			return run_3, var_4_12
		end
	elseif var_4_10 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_13 = _children[4]
	local is_falling = arg_4_2.is_falling

	is_falling = is_falling or arg_4_2.fall_state ~= nil

	if not is_falling then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_13, "aborted")

		local run_4, var_4_16 = var_4_13:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_4 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_4)
		end

		if run_4 ~= "failed" then
			return run_4, var_4_16
		end
	elseif var_4_13 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_17 = _children[5]
	local var_4_18

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_18 = true
		end
	end

	if not var_4_18 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_17, "aborted")

		local run_5, var_4_20 = var_4_17:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_5 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_5)
		end

		if run_5 ~= "failed" then
			return run_5, var_4_20
		end
	elseif var_4_17 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_21 = _children[6]

	if not arg_4_2.blocked then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_21, "aborted")

		local run_6, var_4_23 = var_4_21:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_6 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_6)
		end

		if run_6 ~= "failed" then
			return run_6, var_4_23
		end
	elseif var_4_21 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_24 = _children[7]

	if not (not not (arg_4_2.charge_state ~= nil) or BTConditions.at_smartobject(arg_4_2)) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_24, "aborted")

		local run_7, var_4_26 = var_4_24:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_7 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_7)
		end

		if run_7 ~= "failed" then
			return run_7, var_4_26
		end
	elseif var_4_24 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_27 = _children[8]
	local var_4_28 = alive(arg_4_2.target_unit)

	var_4_28 = not var_4_28 and arg_4_2.confirmed_player_sighting

	if not var_4_28 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_27, "aborted")

		local run_8, var_4_30 = var_4_27:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_8 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_8)
		end

		if run_8 ~= "failed" then
			return run_8, var_4_30
		end
	elseif var_4_27 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_31 = _children[9]

	if not (arg_4_2.goal_destination ~= nil) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_31, "aborted")

		local run_9, var_4_33 = var_4_31:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_9 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_9)
		end

		if run_9 ~= "failed" then
			return run_9, var_4_33
		end
	elseif var_4_31 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_34 = _children[10]
	local var_4_35 = alive(arg_4_2.target_unit)

	var_4_35 = not var_4_35 and not arg_4_2.confirmed_player_sighting

	if not var_4_35 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_34, "aborted")

		local run_10, var_4_37 = var_4_34:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_10 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_10)
		end

		if run_10 ~= "failed" then
			return run_10, var_4_37
		end
	elseif var_4_34 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_38 = _children[11]

	if not not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_38, "aborted")

		local run_11, var_4_40 = var_4_38:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_11 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_11)
		end

		if run_11 ~= "failed" then
			return run_11, var_4_40
		end
	elseif var_4_38 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_41 = _children[12]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_41, "aborted")

	local run_12, var_4_43 = var_4_41:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_12 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_12)
	end

	if run_12 ~= "failed" then
		return run_12, var_4_43
	end
end

BTSelector_bestigor.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
