-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_exalted_sorcerer_drachenfels.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_chaos_exalted_sorcerer_drachenfels = class(BTSelector_chaos_exalted_sorcerer_drachenfels, BTNode)
BTSelector_chaos_exalted_sorcerer_drachenfels.name = "BTSelector_chaos_exalted_sorcerer_drachenfels"

function BTSelector_chaos_exalted_sorcerer_drachenfels.init(arg_2_0, ...)
	BTSelector_chaos_exalted_sorcerer_drachenfels.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

function BTSelector_chaos_exalted_sorcerer_drachenfels.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

function BTSelector_chaos_exalted_sorcerer_drachenfels.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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
	local var_4_12
	local var_4_13 = arg_4_2.next_smart_object_data

	if not (var_4_13.next_smart_object_id ~= nil) then
		var_4_12 = false
	end

	local var_4_14 = arg_4_2.is_smart_objecting
	local var_4_15 = Managers.state.entity:system("nav_graph_system")
	local var_4_16 = var_4_13.smart_object_data and var_4_13.smart_object_data.unit
	local var_4_17, var_4_18 = var_4_15:has_nav_graph(var_4_16)

	if var_4_17 and not var_4_18 and not var_4_14 and var_4_12 == nil then
		var_4_12 = false
	end

	local var_4_19 = arg_4_2.is_in_smartobject_range
	local var_4_20 = arg_4_2.move_state == "moving"

	if var_4_12 == nil then
		var_4_12 = var_4_19 and var_4_20 or var_4_14
	end

	if var_4_12 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_11, "aborted")

		local var_4_21, var_4_22 = var_4_11:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_21 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_21)
		end

		if var_4_21 ~= "failed" then
			return var_4_21, var_4_22
		end
	elseif var_4_11 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_23 = var_4_3[4]

	if arg_4_2.mode == "defensive" and not arg_4_2.is_summoning then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_23, "aborted")

		local var_4_24, var_4_25 = var_4_23:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_24 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_24)
		end

		if var_4_24 ~= "failed" then
			return var_4_24, var_4_25
		end
	elseif var_4_23 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_26 = var_4_3[5]

	if var_0_0(arg_4_2.target_unit) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_26, "aborted")

		local var_4_27, var_4_28 = var_4_26:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_27 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_27)
		end

		if var_4_27 ~= "failed" then
			return var_4_27, var_4_28
		end
	elseif var_4_26 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_29 = var_4_3[6]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_29, "aborted")

	local var_4_30, var_4_31 = var_4_29:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_30 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_30)
	end

	if var_4_30 ~= "failed" then
		return var_4_30, var_4_31
	end
end

function BTSelector_chaos_exalted_sorcerer_drachenfels.add_child(arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
