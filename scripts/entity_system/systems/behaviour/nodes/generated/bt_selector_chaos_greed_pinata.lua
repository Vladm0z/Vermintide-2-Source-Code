-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_greed_pinata.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_chaos_greed_pinata = class(BTSelector_chaos_greed_pinata, BTNode)
BTSelector_chaos_greed_pinata.name = "BTSelector_chaos_greed_pinata"

BTSelector_chaos_greed_pinata.init = function (arg_2_0, ...)
	BTSelector_chaos_greed_pinata.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

BTSelector_chaos_greed_pinata.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_chaos_greed_pinata.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local var_4_8
	local var_4_9 = arg_4_2.next_smart_object_data

	if not (var_4_9.next_smart_object_id ~= nil) then
		var_4_8 = false
	end

	local var_4_10 = arg_4_2.is_smart_objecting
	local var_4_11 = Managers.state.entity:system("nav_graph_system")
	local var_4_12 = var_4_9.smart_object_data and var_4_9.smart_object_data.unit
	local var_4_13, var_4_14 = var_4_11:has_nav_graph(var_4_12)

	if var_4_13 and not var_4_14 and not var_4_10 and var_4_8 == nil then
		var_4_8 = false
	end

	local var_4_15 = arg_4_2.is_in_smartobject_range
	local var_4_16 = arg_4_2.move_state == "moving"

	if var_4_8 == nil then
		var_4_8 = var_4_15 and var_4_16 or var_4_10
	end

	if var_4_8 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_7, "aborted")

		local var_4_17, var_4_18 = var_4_7:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_17 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_17)
		end

		if var_4_17 ~= "failed" then
			return var_4_17, var_4_18
		end
	elseif var_4_7 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_19 = var_4_3[3]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_19, "aborted")

	local var_4_20, var_4_21 = var_4_19:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_20 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_20)
	end

	if var_4_20 ~= "failed" then
		return var_4_20, var_4_21
	end

	local var_4_22 = var_4_3[4]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_22, "aborted")

	local var_4_23, var_4_24 = var_4_22:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_23 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_23)
	end

	if var_4_23 ~= "failed" then
		return var_4_23, var_4_24
	end
end

BTSelector_chaos_greed_pinata.add_child = function (arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
