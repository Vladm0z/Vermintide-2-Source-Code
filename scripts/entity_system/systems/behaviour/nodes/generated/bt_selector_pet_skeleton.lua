-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_pet_skeleton.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local Profiler = Profiler

local function fn()
	-- function 1
	return
end

BTSelector_pet_skeleton = class(BTSelector_pet_skeleton, BTNode)
BTSelector_pet_skeleton.name = "BTSelector_pet_skeleton"

BTSelector_pet_skeleton.init = function (self, ...)
	-- function 2
	BTSelector_pet_skeleton.super.init(self, ...)

	self._children = {}
end

BTSelector_pet_skeleton.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_pet_skeleton.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if not arg_4_2.is_transported then
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

	if not arg_4_2.in_vortex then
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
	local var_4_37
	local unit = arg_4_2.unit
	local get_commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(unit)

	if not get_commander_unit then
		local max_commander_distance = arg_4_2.breed.max_commander_distance

		if not max_commander_distance then
			local var_4_41 = POSITION_LOOKUP[get_commander_unit]
			local var_4_42 = POSITION_LOOKUP[unit]

			if Vector3.distance_squared(var_4_41, var_4_42) > max_commander_distance * max_commander_distance then
				var_4_37 = true
			end
		end
	end

	if var_4_37 == nil then
		var_4_37 = false
	end

	if not var_4_37 then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_36, "aborted")

		local run_8, var_4_44 = var_4_36:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_8 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_8)
		end

		if run_8 ~= "failed" then
			return run_8, var_4_44
		end
	elseif var_4_36 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_45 = _children[9]
	local is_disabled

	if not ALIVE[arg_4_2.commander_unit] then
		is_disabled = ScriptUnit.extension(arg_4_2.commander_unit, "status_system"):is_disabled()

		if not is_disabled then
			-- Nothing
		end
	end

	is_disabled = arg_4_2.disabled_resume_time
	is_disabled = not is_disabled and Managers.time:time("game") < arg_4_2.disabled_resume_time

	::label_4_0::

	if not is_disabled then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_45, "aborted")

		local run_9, var_4_48 = var_4_45:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_9 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_9)
		end

		if run_9 ~= "failed" then
			return run_9, var_4_48
		end
	elseif var_4_45 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_49 = _children[10]

	if not arg_4_2.charge_target then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_49, "aborted")

		local run_10, var_4_51 = var_4_49:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_10 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_10)
		end

		if run_10 ~= "failed" then
			return run_10, var_4_51
		end
	elseif var_4_49 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_52 = _children[11]
	local undergoing_command_attack

	if not arg_4_2.new_command_attack then
		undergoing_command_attack = arg_4_2.undergoing_command_attack

		if not undergoing_command_attack then
			-- Nothing
		end
	end

	if not ALIVE[arg_4_2.target_unit] then
		undergoing_command_attack = arg_4_2.new_command_attack

		if not undergoing_command_attack then
			-- Nothing
		end
	end

	if not ALIVE[arg_4_2.locked_target_unit] then
		undergoing_command_attack = arg_4_2.attack_locked_in_t

		if not undergoing_command_attack then
			-- Nothing
		end
	end

	undergoing_command_attack = arg_4_2.undergoing_command_attack

	::label_4_1::

	if not undergoing_command_attack then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_52, "aborted")

		local run_11, var_4_55 = var_4_52:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_11 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_11)
		end

		if run_11 ~= "failed" then
			return run_11, var_4_55
		end
	elseif var_4_52 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_56 = _children[12]
	local confirmed_enemy_sighting_within_commander

	if not ALIVE[arg_4_2.target_unit] then
		confirmed_enemy_sighting_within_commander = arg_4_2.confirmed_enemy_sighting_within_commander

		if not confirmed_enemy_sighting_within_commander then
			-- Nothing
		end
	end

	confirmed_enemy_sighting_within_commander = arg_4_2.attack_locked_in_t

	::label_4_2::

	if not confirmed_enemy_sighting_within_commander then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_56, "aborted")

		local run_12, var_4_59 = var_4_56:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_12 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_12)
		end

		if run_12 ~= "failed" then
			return run_12, var_4_59
		end
	elseif var_4_56 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_60 = _children[13]

	if not (arg_4_2.command_state == CommandStates.StandingGround) then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_60, "aborted")

		local run_13, var_4_62 = var_4_60:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if run_13 ~= "running" then
			self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_13)
		end

		if run_13 ~= "failed" then
			return run_13, var_4_62
		end
	elseif var_4_60 == current_running_child then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_63 = _children[14]

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_63, "aborted")

	local run_14, var_4_65 = var_4_63:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if run_14 ~= "running" then
		self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, run_14)
	end

	if run_14 ~= "failed" then
		return run_14, var_4_65
	end
end

BTSelector_pet_skeleton.add_child = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
