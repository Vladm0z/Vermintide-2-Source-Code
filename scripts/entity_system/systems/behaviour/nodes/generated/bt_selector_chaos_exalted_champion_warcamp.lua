-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_exalted_champion_warcamp.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_chaos_exalted_champion_warcamp = class(BTSelector_chaos_exalted_champion_warcamp, BTNode)
BTSelector_chaos_exalted_champion_warcamp.name = "BTSelector_chaos_exalted_champion_warcamp"

BTSelector_chaos_exalted_champion_warcamp.init = function (self, ...)
	-- function 2
	BTSelector_chaos_exalted_champion_warcamp.super.init(self, ...)

	self._children = {}
end

BTSelector_chaos_exalted_champion_warcamp.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_chaos_exalted_champion_warcamp.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local is_falling = arg_4_2.is_falling

	is_falling = is_falling or arg_4_2.fall_state ~= nil

	if not is_falling then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_12, "aborted")

		local run_3, var_4_15 = var_4_12:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_3 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_3)
		end

		if run_3 ~= "failed" then
			return run_3, var_4_15
		end
	elseif var_4_12 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_16 = _children[4]
	local var_4_17
	local next_smart_object_data = arg_4_2.next_smart_object_data

	if not (next_smart_object_data.next_smart_object_id ~= nil) then
		var_4_17 = false
	end

	local is_smart_objecting = arg_4_2.is_smart_objecting
	local system = Managers.state.entity:system("nav_graph_system")
	local smart_object_data = next_smart_object_data.smart_object_data

	smart_object_data = not smart_object_data and next_smart_object_data.smart_object_data.unit

	local has_nav_graph, var_4_23 = system:has_nav_graph(smart_object_data)

	if not (not has_nav_graph and var_4_23 or is_smart_objecting or var_4_17 ~= nil) then
		var_4_17 = false
	end

	local is_in_smartobject_range = arg_4_2.is_in_smartobject_range
	local flag = arg_4_2.move_state == "moving"

	if var_4_17 == nil then
		var_4_17 = not is_in_smartobject_range and flag and is_smart_objecting
	end

	if not var_4_17 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_16, "aborted")

		local run_4, var_4_27 = var_4_16:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_4 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_4)
		end

		if run_4 ~= "failed" then
			return run_4, var_4_27
		end
	elseif var_4_16 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_28 = _children[5]
	local alive_2 = Unit.alive(arg_4_2.target_unit)

	if not alive_2 then
		alive_2 = arg_4_2.num_chain_stagger
		alive_2 = not alive_2 and arg_4_2.num_chain_stagger > 2
	end

	if not alive_2 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_28, "aborted")

		local run_5, var_4_31 = var_4_28:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_5 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_5)
		end

		if run_5 ~= "failed" then
			return run_5, var_4_31
		end
	elseif var_4_28 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_32 = _children[6]
	local var_4_33

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_33 = true
		end
	end

	if not var_4_33 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_32, "aborted")

		local run_6, var_4_35 = var_4_32:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_6 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_6)
		end

		if run_6 ~= "failed" then
			return run_6, var_4_35
		end
	elseif var_4_32 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_36 = _children[7]
	local defensive_mode_duration = arg_4_2.defensive_mode_duration

	defensive_mode_duration = not defensive_mode_duration and alive(arg_4_2.target_unit)

	if not defensive_mode_duration then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_36, "aborted")

		local run_7, var_4_39 = var_4_36:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_7 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_7)
		end

		if run_7 ~= "failed" then
			return run_7, var_4_39
		end
	elseif var_4_36 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_40 = _children[8]

	if not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_40, "aborted")

		local run_8, var_4_42 = var_4_40:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_8 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_8)
		end

		if run_8 ~= "failed" then
			return run_8, var_4_42
		end
	elseif var_4_40 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_43 = _children[9]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_43, "aborted")

	local run_9, var_4_45 = var_4_43:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_9 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_9)
	end

	if run_9 ~= "failed" then
		return run_9, var_4_45
	end

	local var_4_46 = _children[10]

	if not not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_46, "aborted")

		local run_10, var_4_48 = var_4_46:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_10 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_10)
		end

		if run_10 ~= "failed" then
			return run_10, var_4_48
		end
	elseif var_4_46 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_49 = _children[11]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_49, "aborted")

	local run_11, var_4_51 = var_4_49:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_11 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_11)
	end

	if run_11 ~= "failed" then
		return run_11, var_4_51
	end
end

BTSelector_chaos_exalted_champion_warcamp.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
