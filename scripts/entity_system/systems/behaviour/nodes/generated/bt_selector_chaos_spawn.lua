-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_spawn.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_chaos_spawn = class(BTSelector_chaos_spawn, BTNode)
BTSelector_chaos_spawn.name = "BTSelector_chaos_spawn"

BTSelector_chaos_spawn.init = function (arg_2_0, ...)
	BTSelector_chaos_spawn.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

BTSelector_chaos_spawn.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_chaos_spawn.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if arg_4_2.keep_target then
		var_4_8 = false
	end

	if var_4_8 == nil then
		var_4_8 = BTConditions.at_smartobject(arg_4_2)
	end

	if var_4_8 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_7, "aborted")

		local var_4_9, var_4_10 = var_4_7:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_9 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_9)
		end

		if var_4_9 ~= "failed" then
			return var_4_9, var_4_10
		end
	elseif var_4_7 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_11 = var_4_3[3]
	local var_4_12

	if arg_4_2.stagger then
		if arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_12 = true
		end
	end

	if var_4_12 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_11, "aborted")

		local var_4_13, var_4_14 = var_4_11:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_13 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_13)
		end

		if var_4_13 ~= "failed" then
			return var_4_13, var_4_14
		end
	elseif var_4_11 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_15 = var_4_3[4]

	if arg_4_2.has_grabbed_victim then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_15, "aborted")

		local var_4_16, var_4_17 = var_4_15:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_16 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_16)
		end

		if var_4_16 ~= "failed" then
			return var_4_16, var_4_17
		end
	elseif var_4_15 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_18 = var_4_3[5]

	if var_0_0(arg_4_2.target_unit) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_18, "aborted")

		local var_4_19, var_4_20 = var_4_18:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_19 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_19)
		end

		if var_4_19 ~= "failed" then
			return var_4_19, var_4_20
		end
	elseif var_4_18 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_21 = var_4_3[6]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_21, "aborted")

	local var_4_22, var_4_23 = var_4_21:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_22 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_22)
	end

	if var_4_22 ~= "failed" then
		return var_4_22, var_4_23
	end
end

BTSelector_chaos_spawn.add_child = function (arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
