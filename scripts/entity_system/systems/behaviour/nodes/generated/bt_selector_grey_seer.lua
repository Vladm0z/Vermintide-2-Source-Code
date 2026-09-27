-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_grey_seer.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_grey_seer = class(BTSelector_grey_seer, BTNode)
BTSelector_grey_seer.name = "BTSelector_grey_seer"

BTSelector_grey_seer.init = function (self, ...)
	-- function 2
	BTSelector_grey_seer.super.init(self, ...)

	self._children = {}
end

BTSelector_grey_seer.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_grey_seer.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local time = Managers.time:time("game")
	local intro_timer = arg_4_2.intro_timer

	intro_timer = not intro_timer and time < arg_4_2.intro_timer

	if not intro_timer then
		self:set_running_child(arg_4_1, arg_4_2, time, var_4_7, "aborted")

		local run_2, var_4_11 = var_4_7:run(arg_4_1, arg_4_2, time, arg_4_4)

		if run_2 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, time, nil, run_2)
		end

		if run_2 ~= "failed" then
			return run_2, var_4_11
		end
	elseif var_4_7 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, time, nil, "failed")
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

	if not arg_4_2.waiting_for_pickup then
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
	local mount_unit = arg_4_2.mounted_data.mount_unit

	if not (not not arg_4_2.knocked_off_mount or HEALTH_ALIVE[mount_unit]) then
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

	if not (arg_4_2.current_phase == 6) then
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

	if not (arg_4_2.current_phase == 5) then
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

	if not arg_4_2.call_stormfiend then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_28, "aborted")

		local run_8, var_4_30 = var_4_28:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_8 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_8)
		end

		if run_8 ~= "failed" then
			return run_8, var_4_30
		end
	elseif var_4_28 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_31 = _children[9]
	local var_4_32

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_32 = not arg_4_2.about_to_mount
		end
	end

	if not var_4_32 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_31, "aborted")

		local run_9, var_4_34 = var_4_31:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_9 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_9)
		end

		if run_9 ~= "failed" then
			return run_9, var_4_34
		end
	elseif var_4_31 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_35 = _children[10]
	local ready_to_summon = arg_4_2.ready_to_summon

	ready_to_summon = not ready_to_summon and not not arg_4_2.about_to_mount or HEALTH_ALIVE[arg_4_2.target_unit]

	if not ready_to_summon then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_35, "aborted")

		local run_10, var_4_38 = var_4_35:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_10 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_10)
		end

		if run_10 ~= "failed" then
			return run_10, var_4_38
		end
	elseif var_4_35 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_39 = _children[11]

	if not ((arg_4_2.knocked_off_mount or not HEALTH_ALIVE[arg_4_2.mounted_data.mount_unit]) and HEALTH_ALIVE[arg_4_2.target_unit]) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_39, "aborted")

		local run_11, var_4_41 = var_4_39:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_11 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_11)
		end

		if run_11 ~= "failed" then
			return run_11, var_4_41
		end
	elseif var_4_39 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_42 = _children[12]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_42, "aborted")

	local run_12, var_4_44 = var_4_42:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_12 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_12)
	end

	if run_12 ~= "failed" then
		return run_12, var_4_44
	end

	local var_4_45 = _children[13]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_45, "aborted")

	local run_13, var_4_47 = var_4_45:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_13 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_13)
	end

	if run_13 ~= "failed" then
		return run_13, var_4_47
	end
end

BTSelector_grey_seer.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
