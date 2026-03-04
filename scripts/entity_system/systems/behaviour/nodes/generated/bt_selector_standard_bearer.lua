-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_standard_bearer.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_standard_bearer = class(BTSelector_standard_bearer, BTNode)
BTSelector_standard_bearer.name = "BTSelector_standard_bearer"

BTSelector_standard_bearer.init = function (arg_2_0, ...)
	BTSelector_standard_bearer.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

BTSelector_standard_bearer.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_standard_bearer.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if arg_4_2.in_vortex then
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

	if arg_4_2.gravity_well_position then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_10, "aborted")

		local var_4_11, var_4_12 = var_4_10:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_11 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_11)
		end

		if var_4_11 ~= "failed" then
			return var_4_11, var_4_12
		end
	elseif var_4_10 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_13 = var_4_3[4]

	if arg_4_2.is_falling or arg_4_2.fall_state ~= nil then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_13, "aborted")

		local var_4_14, var_4_15 = var_4_13:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_14 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_14)
		end

		if var_4_14 ~= "failed" then
			return var_4_14, var_4_15
		end
	elseif var_4_13 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_16 = var_4_3[5]

	if arg_4_2.switching_weapons and not arg_4_2.defensive_mode_duration then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_16, "aborted")

		local var_4_17, var_4_18 = var_4_16:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_17 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_17)
		end

		if var_4_17 ~= "failed" then
			return var_4_17, var_4_18
		end
	elseif var_4_16 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_19 = var_4_3[6]
	local var_4_20
	local var_4_21 = arg_4_2.next_smart_object_data

	if not (var_4_21.next_smart_object_id ~= nil) then
		var_4_20 = false
	end

	local var_4_22 = arg_4_2.is_smart_objecting
	local var_4_23 = Managers.state.entity:system("nav_graph_system")
	local var_4_24 = var_4_21.smart_object_data and var_4_21.smart_object_data.unit
	local var_4_25, var_4_26 = var_4_23:has_nav_graph(var_4_24)

	if var_4_25 and not var_4_26 and not var_4_22 and var_4_20 == nil then
		var_4_20 = false
	end

	local var_4_27 = arg_4_2.is_in_smartobject_range
	local var_4_28 = arg_4_2.move_state == "moving"

	if var_4_20 == nil then
		var_4_20 = var_4_27 and var_4_28 or var_4_22
	end

	if var_4_20 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_19, "aborted")

		local var_4_29, var_4_30 = var_4_19:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_29 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_29)
		end

		if var_4_29 ~= "failed" then
			return var_4_29, var_4_30
		end
	elseif var_4_19 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_31 = var_4_3[7]

	if arg_4_2.move_and_place_standard then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_31, "aborted")

		local var_4_32, var_4_33 = var_4_31:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_32 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_32)
		end

		if var_4_32 ~= "failed" then
			return var_4_32, var_4_33
		end
	elseif var_4_31 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_34 = var_4_3[8]
	local var_4_35

	if arg_4_2.ignore_standard_pickup then
		var_4_35 = false
	end

	local var_4_36 = arg_4_2.target_distance_to_standard

	if arg_4_2.moving_to_pick_up_standard then
		if var_4_35 == nil then
			var_4_35 = true
		end
	elseif var_4_35 == nil then
		var_4_35 = arg_4_2.has_placed_standard and var_0_0(arg_4_2.target_unit) and HEALTH_ALIVE[arg_4_2.standard_unit] and var_4_36 and var_4_36 > arg_4_2.breed.pickup_standard_distance
	end

	if var_4_35 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_34, "aborted")

		local var_4_37, var_4_38 = var_4_34:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_37 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_37)
		end

		if var_4_37 ~= "failed" then
			return var_4_37, var_4_38
		end
	elseif var_4_34 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_39 = var_4_3[9]
	local var_4_40

	if arg_4_2.stagger then
		if arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_40 = true
		end
	end

	if var_4_40 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_39, "aborted")

		local var_4_41, var_4_42 = var_4_39:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_41 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_41)
		end

		if var_4_41 ~= "failed" then
			return var_4_41, var_4_42
		end
	elseif var_4_39 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_43 = var_4_3[10]

	if arg_4_2.blocked then
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

	if var_0_0(arg_4_2.target_unit) and not arg_4_2.has_placed_standard then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_46, "aborted")

		local var_4_47, var_4_48 = var_4_46:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_47 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_47)
		end

		if var_4_47 ~= "failed" then
			return var_4_47, var_4_48
		end
	elseif var_4_46 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_49 = var_4_3[12]
	local var_4_50 = arg_4_2.breed.pickup_standard_distance
	local var_4_51 = arg_4_2.breed.defensive_threshold_distance
	local var_4_52 = var_0_0(arg_4_2.target_unit) and arg_4_2.confirmed_player_sighting and arg_4_2.has_placed_standard
	local var_4_53 = arg_4_2.target_distance_to_standard
	local var_4_54 = var_4_53 and var_4_51 <= var_4_53 and var_4_53 <= var_4_50
	local var_4_55 = arg_4_2.move_state ~= "attacking"

	if var_4_52 and var_4_54 and var_4_55 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_49, "aborted")

		local var_4_56, var_4_57 = var_4_49:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_56 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_56)
		end

		if var_4_56 ~= "failed" then
			return var_4_56, var_4_57
		end
	elseif var_4_49 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_58 = var_4_3[13]

	if var_0_0(arg_4_2.target_unit) and arg_4_2.confirmed_player_sighting and arg_4_2.has_placed_standard then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_58, "aborted")

		local var_4_59, var_4_60 = var_4_58:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_59 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_59)
		end

		if var_4_59 ~= "failed" then
			return var_4_59, var_4_60
		end
	elseif var_4_58 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_61 = var_4_3[14]

	if arg_4_2.goal_destination ~= nil then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_61, "aborted")

		local var_4_62, var_4_63 = var_4_61:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_62 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_62)
		end

		if var_4_62 ~= "failed" then
			return var_4_62, var_4_63
		end
	elseif var_4_61 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_64 = var_4_3[15]

	if var_0_0(arg_4_2.target_unit) and not arg_4_2.confirmed_player_sighting then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_64, "aborted")

		local var_4_65, var_4_66 = var_4_64:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_65 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_65)
		end

		if var_4_65 ~= "failed" then
			return var_4_65, var_4_66
		end
	elseif var_4_64 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_67 = var_4_3[16]

	if not var_0_0(arg_4_2.target_unit) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_67, "aborted")

		local var_4_68, var_4_69 = var_4_67:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_68 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_68)
		end

		if var_4_68 ~= "failed" then
			return var_4_68, var_4_69
		end
	elseif var_4_67 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_70 = var_4_3[17]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_70, "aborted")

	local var_4_71, var_4_72 = var_4_70:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_71 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_71)
	end

	if var_4_71 ~= "failed" then
		return var_4_71, var_4_72
	end
end

BTSelector_standard_bearer.add_child = function (arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
