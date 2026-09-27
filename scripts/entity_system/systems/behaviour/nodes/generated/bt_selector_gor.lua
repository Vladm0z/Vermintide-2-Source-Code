-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_gor.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_gor = class(BTSelector_gor, BTNode)
BTSelector_gor.name = "BTSelector_gor"

BTSelector_gor.init = function (self, ...)
	-- function 2
	BTSelector_gor.super.init(self, ...)

	self._children = {}
end

BTSelector_gor.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_gor.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local var_4_25
	local next_smart_object_data = arg_4_2.next_smart_object_data

	if not (next_smart_object_data.next_smart_object_id ~= nil) then
		var_4_25 = false
	end

	local is_smart_objecting = arg_4_2.is_smart_objecting
	local system = Managers.state.entity:system("nav_graph_system")
	local smart_object_data = next_smart_object_data.smart_object_data

	smart_object_data = not smart_object_data and next_smart_object_data.smart_object_data.unit

	local has_nav_graph, var_4_31 = system:has_nav_graph(smart_object_data)

	if not (not has_nav_graph and var_4_31 or is_smart_objecting or var_4_25 ~= nil) then
		var_4_25 = false
	end

	local is_in_smartobject_range = arg_4_2.is_in_smartobject_range
	local flag = arg_4_2.move_state == "moving"

	if var_4_25 == nil then
		var_4_25 = not is_in_smartobject_range and flag and is_smart_objecting
	end

	if not var_4_25 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_24, "aborted")

		local run_7, var_4_35 = var_4_24:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_7 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_7)
		end

		if run_7 ~= "failed" then
			return run_7, var_4_35
		end
	elseif var_4_24 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_36 = _children[8]
	local var_4_37 = alive(arg_4_2.target_unit)

	if not var_4_37 then
		var_4_37 = arg_4_2.is_alerted
		var_4_37 = not var_4_37 and not arg_4_2.confirmed_player_sighting and arg_4_2.hesitating
	end

	local flag_2 = not alive(arg_4_2.taunt_unit) and not not arg_4_2.taunt_hesitate_finished or not arg_4_2.no_taunt_hesitate

	if not (var_4_37 or flag_2) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_36, "aborted")

		local run_8, var_4_40 = var_4_36:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_8 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_8)
		end

		if run_8 ~= "failed" then
			return run_8, var_4_40
		end
	elseif var_4_36 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_41 = _children[9]
	local var_4_42 = alive(arg_4_2.target_unit)

	var_4_42 = not var_4_42 and arg_4_2.confirmed_player_sighting

	if not var_4_42 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_41, "aborted")

		local run_9, var_4_44 = var_4_41:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_9 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_9)
		end

		if run_9 ~= "failed" then
			return run_9, var_4_44
		end
	elseif var_4_41 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_45 = _children[10]

	if not (arg_4_2.goal_destination ~= nil) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_45, "aborted")

		local run_10, var_4_47 = var_4_45:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_10 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_10)
		end

		if run_10 ~= "failed" then
			return run_10, var_4_47
		end
	elseif var_4_45 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_48 = _children[11]
	local var_4_49 = alive(arg_4_2.target_unit)

	var_4_49 = not var_4_49 and not arg_4_2.confirmed_player_sighting

	if not var_4_49 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_48, "aborted")

		local run_11, var_4_51 = var_4_48:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_11 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_11)
		end

		if run_11 ~= "failed" then
			return run_11, var_4_51
		end
	elseif var_4_48 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_52 = _children[12]

	if not not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_52, "aborted")

		local run_12, var_4_54 = var_4_52:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_12 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_12)
		end

		if run_12 ~= "failed" then
			return run_12, var_4_54
		end
	elseif var_4_52 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_55 = _children[13]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_55, "aborted")

	local run_13, var_4_57 = var_4_55:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_13 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_13)
	end

	if run_13 ~= "failed" then
		return run_13, var_4_57
	end
end

BTSelector_gor.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
