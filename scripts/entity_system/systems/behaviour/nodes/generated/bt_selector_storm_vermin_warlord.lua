-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_storm_vermin_warlord.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_storm_vermin_warlord = class(BTSelector_storm_vermin_warlord, BTNode)
BTSelector_storm_vermin_warlord.name = "BTSelector_storm_vermin_warlord"

BTSelector_storm_vermin_warlord.init = function (arg_2_0, ...)
	BTSelector_storm_vermin_warlord.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

BTSelector_storm_vermin_warlord.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_storm_vermin_warlord.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local var_4_8 = Managers.time:time("game")

	if arg_4_2.intro_timer and var_4_8 < arg_4_2.intro_timer then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, var_4_8, var_4_7, "aborted")

		local var_4_9, var_4_10 = var_4_7:run(arg_4_1, arg_4_2, var_4_8, arg_4_4)

		if var_4_9 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, var_4_8, nil, var_4_9)
		end

		if var_4_9 ~= "failed" then
			return var_4_9, var_4_10
		end
	elseif var_4_7 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, var_4_8, nil, "failed")
	end

	local var_4_11 = var_4_3[3]

	if arg_4_2.switching_weapons and not arg_4_2.defensive_mode_duration then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_11, "aborted")

		local var_4_12, var_4_13 = var_4_11:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_12 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_12)
		end

		if var_4_12 ~= "failed" then
			return var_4_12, var_4_13
		end
	elseif var_4_11 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_14 = var_4_3[4]

	if arg_4_2.jump_from_pos then
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

	if arg_4_2.is_falling or arg_4_2.fall_state ~= nil then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_17, "aborted")

		local var_4_18, var_4_19 = var_4_17:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_18 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_18)
		end

		if var_4_18 ~= "failed" then
			return var_4_18, var_4_19
		end
	elseif var_4_17 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_20 = var_4_3[6]
	local var_4_21
	local var_4_22 = arg_4_2.next_smart_object_data

	if not (var_4_22.next_smart_object_id ~= nil) then
		var_4_21 = false
	end

	local var_4_23 = arg_4_2.is_smart_objecting
	local var_4_24 = Managers.state.entity:system("nav_graph_system")
	local var_4_25 = var_4_22.smart_object_data and var_4_22.smart_object_data.unit
	local var_4_26, var_4_27 = var_4_24:has_nav_graph(var_4_25)

	if var_4_26 and not var_4_27 and not var_4_23 and var_4_21 == nil then
		var_4_21 = false
	end

	local var_4_28 = arg_4_2.is_in_smartobject_range
	local var_4_29 = arg_4_2.move_state == "moving"

	if var_4_21 == nil then
		var_4_21 = var_4_28 and var_4_29 or var_4_23
	end

	if var_4_21 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_20, "aborted")

		local var_4_30, var_4_31 = var_4_20:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_30 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_30)
		end

		if var_4_30 ~= "failed" then
			return var_4_30, var_4_31
		end
	elseif var_4_20 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_32 = var_4_3[7]
	local var_4_33

	if arg_4_2.stagger then
		if arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_33 = true
		end
	end

	if var_4_33 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_32, "aborted")

		local var_4_34, var_4_35 = var_4_32:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_34 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_34)
		end

		if var_4_34 ~= "failed" then
			return var_4_34, var_4_35
		end
	elseif var_4_32 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_36 = var_4_3[8]

	if arg_4_2.defensive_mode_duration and var_0_0(arg_4_2.target_unit) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_36, "aborted")

		local var_4_37, var_4_38 = var_4_36:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_37 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_37)
		end

		if var_4_37 ~= "failed" then
			return var_4_37, var_4_38
		end
	elseif var_4_36 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_39 = var_4_3[9]

	if var_0_0(arg_4_2.target_unit) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_39, "aborted")

		local var_4_40, var_4_41 = var_4_39:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_40 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_40)
		end

		if var_4_40 ~= "failed" then
			return var_4_40, var_4_41
		end
	elseif var_4_39 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_42 = var_4_3[10]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_42, "aborted")

	local var_4_43, var_4_44 = var_4_42:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_43 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_43)
	end

	if var_4_43 ~= "failed" then
		return var_4_43, var_4_44
	end

	local var_4_45 = var_4_3[11]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_45, "aborted")

	local var_4_46, var_4_47 = var_4_45:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_46 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_46)
	end

	if var_4_46 ~= "failed" then
		return var_4_46, var_4_47
	end
end

BTSelector_storm_vermin_warlord.add_child = function (arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
