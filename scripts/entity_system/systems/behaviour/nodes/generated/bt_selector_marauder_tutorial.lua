-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_marauder_tutorial.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_marauder_tutorial = class(BTSelector_marauder_tutorial, BTNode)
BTSelector_marauder_tutorial.name = "BTSelector_marauder_tutorial"

BTSelector_marauder_tutorial.init = function (arg_2_0, ...)
	BTSelector_marauder_tutorial.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

BTSelector_marauder_tutorial.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_marauder_tutorial.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = var_0_1.start
	local var_4_1 = var_0_1.stop
	local var_4_2 = arg_4_0:current_running_child(arg_4_2)
	local var_4_3 = arg_4_0._children
	local var_4_4 = var_4_3[1]

	if arg_4_2.spawn then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_4, "aborted")

		local var_4_5, var_4_6 = var_4_4:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_5 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_5)
		end

		if var_4_5 ~= "failed" then
			return var_4_5, var_4_6
		end
	elseif var_4_4 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_7 = var_4_3[2]

	if arg_4_2.is_falling or arg_4_2.fall_state ~= nil then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_7, "aborted")

		local var_4_8, var_4_9 = var_4_7:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_8 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_8)
		end

		if var_4_8 ~= "failed" then
			return var_4_8, var_4_9
		end
	elseif var_4_7 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_10 = var_4_3[3]
	local var_4_11

	if arg_4_2.stagger then
		if arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_11 = true
		end
	end

	if var_4_11 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_10, "aborted")

		local var_4_12, var_4_13 = var_4_10:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_12 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_12)
		end

		if var_4_12 ~= "failed" then
			return var_4_12, var_4_13
		end
	elseif var_4_10 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_14 = var_4_3[4]

	if arg_4_2.blocked then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_14, "aborted")

		local var_4_15, var_4_16 = var_4_14:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_15 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_15)
		end

		if var_4_15 ~= "failed" then
			return var_4_15, var_4_16
		end
	elseif var_4_14 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_17 = var_4_3[5]
	local var_4_18
	local var_4_19 = arg_4_2.next_smart_object_data

	if not (var_4_19.next_smart_object_id ~= nil) then
		var_4_18 = false
	end

	local var_4_20 = arg_4_2.is_smart_objecting
	local var_4_21 = Managers.state.entity:system("nav_graph_system")
	local var_4_22 = var_4_19.smart_object_data and var_4_19.smart_object_data.unit
	local var_4_23, var_4_24 = var_4_21:has_nav_graph(var_4_22)

	if var_4_23 and not var_4_24 and not var_4_20 and var_4_18 == nil then
		var_4_18 = false
	end

	local var_4_25 = arg_4_2.is_in_smartobject_range
	local var_4_26 = arg_4_2.move_state == "moving"

	if var_4_18 == nil then
		var_4_18 = var_4_25 and var_4_26 or var_4_20
	end

	if var_4_18 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_17, "aborted")

		local var_4_27, var_4_28 = var_4_17:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_27 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_27)
		end

		if var_4_27 ~= "failed" then
			return var_4_27, var_4_28
		end
	elseif var_4_17 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_29 = var_4_3[6]
	local var_4_30 = var_0_0(arg_4_2.target_unit) and arg_4_2.is_alerted and (not arg_4_2.confirmed_player_sighting or arg_4_2.hesitating)
	local var_4_31 = var_0_0(arg_4_2.taunt_unit) and not arg_4_2.taunt_hesitate_finished and not arg_4_2.no_taunt_hesitate

	if var_4_30 or var_4_31 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_29, "aborted")

		local var_4_32, var_4_33 = var_4_29:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_32 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_32)
		end

		if var_4_32 ~= "failed" then
			return var_4_32, var_4_33
		end
	elseif var_4_29 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_34 = var_4_3[7]

	if var_0_0(arg_4_2.target_unit) and arg_4_2.confirmed_player_sighting then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_34, "aborted")

		local var_4_35, var_4_36 = var_4_34:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_35 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_35)
		end

		if var_4_35 ~= "failed" then
			return var_4_35, var_4_36
		end
	elseif var_4_34 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_37 = var_4_3[8]

	if var_0_0(arg_4_2.target_unit) and not arg_4_2.confirmed_player_sighting then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_37, "aborted")

		local var_4_38, var_4_39 = var_4_37:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_38 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_38)
		end

		if var_4_38 ~= "failed" then
			return var_4_38, var_4_39
		end
	elseif var_4_37 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_40 = var_4_3[9]

	if arg_4_2.goal_destination ~= nil then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_40, "aborted")

		local var_4_41, var_4_42 = var_4_40:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_41 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_41)
		end

		if var_4_41 ~= "failed" then
			return var_4_41, var_4_42
		end
	elseif var_4_40 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_43 = var_4_3[10]

	if not var_0_0(arg_4_2.target_unit) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_43, "aborted")

		local var_4_44, var_4_45 = var_4_43:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_44 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_44)
		end

		if var_4_44 ~= "failed" then
			return var_4_44, var_4_45
		end
	elseif var_4_43 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_46 = var_4_3[11]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_46, "aborted")

	local var_4_47, var_4_48 = var_4_46:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_47 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_47)
	end

	if var_4_47 ~= "failed" then
		return var_4_47, var_4_48
	end
end

BTSelector_marauder_tutorial.add_child = function (arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
