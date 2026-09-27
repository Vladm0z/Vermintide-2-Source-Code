-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_standard_bearer.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_standard_bearer = class(BTSelector_standard_bearer, BTNode)
BTSelector_standard_bearer.name = "BTSelector_standard_bearer"

BTSelector_standard_bearer.init = function (self, ...)
	-- function 2
	BTSelector_standard_bearer.super.init(self, ...)

	self._children = {}
end

BTSelector_standard_bearer.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_standard_bearer.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local switching_weapons = arg_4_2.switching_weapons

	switching_weapons = not switching_weapons and not arg_4_2.defensive_mode_duration

	if not switching_weapons then
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
	local var_4_22
	local next_smart_object_data = arg_4_2.next_smart_object_data

	if not (next_smart_object_data.next_smart_object_id ~= nil) then
		var_4_22 = false
	end

	local is_smart_objecting = arg_4_2.is_smart_objecting
	local system = Managers.state.entity:system("nav_graph_system")
	local smart_object_data = next_smart_object_data.smart_object_data

	smart_object_data = not smart_object_data and next_smart_object_data.smart_object_data.unit

	local has_nav_graph, var_4_28 = system:has_nav_graph(smart_object_data)

	if not (not has_nav_graph and var_4_28 or is_smart_objecting or var_4_22 ~= nil) then
		var_4_22 = false
	end

	local is_in_smartobject_range = arg_4_2.is_in_smartobject_range
	local flag = arg_4_2.move_state == "moving"

	if var_4_22 == nil then
		var_4_22 = not is_in_smartobject_range and flag and is_smart_objecting
	end

	if not var_4_22 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_21, "aborted")

		local run_6, var_4_32 = var_4_21:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_6 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_6)
		end

		if run_6 ~= "failed" then
			return run_6, var_4_32
		end
	elseif var_4_21 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_33 = _children[7]

	if not arg_4_2.move_and_place_standard then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_33, "aborted")

		local run_7, var_4_35 = var_4_33:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_7 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_7)
		end

		if run_7 ~= "failed" then
			return run_7, var_4_35
		end
	elseif var_4_33 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_36 = _children[8]
	local var_4_37

	if not arg_4_2.ignore_standard_pickup then
		var_4_37 = false
	end

	local target_distance_to_standard = arg_4_2.target_distance_to_standard

	if not arg_4_2.moving_to_pick_up_standard then
		if var_4_37 == nil then
			var_4_37 = true
		end
	elseif var_4_37 == nil then
		var_4_37 = not arg_4_2.has_placed_standard and not alive(arg_4_2.target_unit) and not HEALTH_ALIVE[arg_4_2.standard_unit] and not target_distance_to_standard and target_distance_to_standard > arg_4_2.breed.pickup_standard_distance
	end

	if not var_4_37 then
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
	local var_4_42

	if not arg_4_2.stagger then
		if not arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_42 = true
		end
	end

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

	if not arg_4_2.blocked then
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

	var_4_49 = not var_4_49 and not arg_4_2.has_placed_standard

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
	local pickup_standard_distance = arg_4_2.breed.pickup_standard_distance
	local defensive_threshold_distance = arg_4_2.breed.defensive_threshold_distance
	local var_4_55 = alive(arg_4_2.target_unit)

	if not var_4_55 then
		var_4_55 = arg_4_2.confirmed_player_sighting
		var_4_55 = not var_4_55 and arg_4_2.has_placed_standard
	end

	local target_distance_to_standard_2 = arg_4_2.target_distance_to_standard
	local flag_2 = not target_distance_to_standard_2 and not (defensive_threshold_distance <= target_distance_to_standard_2) or target_distance_to_standard_2 <= pickup_standard_distance
	local flag_3 = arg_4_2.move_state ~= "attacking"

	if not (not var_4_55 and not flag_2 and flag_3) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_52, "aborted")

		local run_12, var_4_60 = var_4_52:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_12 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_12)
		end

		if run_12 ~= "failed" then
			return run_12, var_4_60
		end
	elseif var_4_52 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_61 = _children[13]
	local var_4_62 = alive(arg_4_2.target_unit)

	if not var_4_62 then
		var_4_62 = arg_4_2.confirmed_player_sighting
		var_4_62 = not var_4_62 and arg_4_2.has_placed_standard
	end

	if not var_4_62 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_61, "aborted")

		local run_13, var_4_64 = var_4_61:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_13 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_13)
		end

		if run_13 ~= "failed" then
			return run_13, var_4_64
		end
	elseif var_4_61 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_65 = _children[14]

	if not (arg_4_2.goal_destination ~= nil) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_65, "aborted")

		local run_14, var_4_67 = var_4_65:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_14 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_14)
		end

		if run_14 ~= "failed" then
			return run_14, var_4_67
		end
	elseif var_4_65 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_68 = _children[15]
	local var_4_69 = alive(arg_4_2.target_unit)

	var_4_69 = not var_4_69 and not arg_4_2.confirmed_player_sighting

	if not var_4_69 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_68, "aborted")

		local run_15, var_4_71 = var_4_68:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_15 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_15)
		end

		if run_15 ~= "failed" then
			return run_15, var_4_71
		end
	elseif var_4_68 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_72 = _children[16]

	if not not alive(arg_4_2.target_unit) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_72, "aborted")

		local run_16, var_4_74 = var_4_72:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_16 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_16)
		end

		if run_16 ~= "failed" then
			return run_16, var_4_74
		end
	elseif var_4_72 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_75 = _children[17]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_75, "aborted")

	local run_17, var_4_77 = var_4_75:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_17 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_17)
	end

	if run_17 ~= "failed" then
		return run_17, var_4_77
	end
end

BTSelector_standard_bearer.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
