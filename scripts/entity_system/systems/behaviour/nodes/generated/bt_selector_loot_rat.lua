-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_loot_rat.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_loot_rat = class(BTSelector_loot_rat, BTNode)
BTSelector_loot_rat.name = "BTSelector_loot_rat"

function BTSelector_loot_rat.init(arg_2_0, ...)
	BTSelector_loot_rat.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

function BTSelector_loot_rat.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

function BTSelector_loot_rat.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if arg_4_2.is_falling or arg_4_2.fall_state ~= nil then
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

	if BTConditions.stagger(arg_4_2) and not arg_4_2.dodge_damage_success then
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
	local var_4_17
	local var_4_18 = arg_4_2.next_smart_object_data

	if not (var_4_18.next_smart_object_id ~= nil) then
		var_4_17 = false
	end

	local var_4_19 = arg_4_2.is_smart_objecting
	local var_4_20 = Managers.state.entity:system("nav_graph_system")
	local var_4_21 = var_4_18.smart_object_data and var_4_18.smart_object_data.unit
	local var_4_22, var_4_23 = var_4_20:has_nav_graph(var_4_21)

	if var_4_22 and not var_4_23 and not var_4_19 and var_4_17 == nil then
		var_4_17 = false
	end

	local var_4_24 = arg_4_2.is_in_smartobject_range
	local var_4_25 = arg_4_2.move_state == "moving"

	if var_4_17 == nil then
		var_4_17 = var_4_24 and var_4_25 or var_4_19
	end

	if var_4_17 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_16, "aborted")

		local var_4_26, var_4_27 = var_4_16:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_26 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_26)
		end

		if var_4_26 ~= "failed" then
			return var_4_26, var_4_27
		end
	elseif var_4_16 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_28 = var_4_3[6]

	if arg_4_2.dodge_vector or arg_4_2.is_dodging then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_28, "aborted")

		local var_4_29, var_4_30 = var_4_28:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_29 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_29)
		end

		if var_4_29 ~= "failed" then
			return var_4_29, var_4_30
		end
	elseif var_4_28 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_31 = var_4_3[7]

	if BTConditions.confirmed_player_sighting(arg_4_2) or arg_4_2.is_fleeing then
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

	if var_0_0(arg_4_2.target_unit) then
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

	local var_4_37 = var_4_3[9]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_37, "aborted")

	local var_4_38, var_4_39 = var_4_37:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_38 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_38)
	end

	if var_4_38 ~= "failed" then
		return var_4_38, var_4_39
	end
end

function BTSelector_loot_rat.add_child(arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
