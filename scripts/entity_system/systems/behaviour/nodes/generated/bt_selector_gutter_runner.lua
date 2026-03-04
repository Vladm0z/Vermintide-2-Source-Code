-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_gutter_runner.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_gutter_runner = class(BTSelector_gutter_runner, BTNode)
BTSelector_gutter_runner.name = "BTSelector_gutter_runner"

BTSelector_gutter_runner.init = function (arg_2_0, ...)
	BTSelector_gutter_runner.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

BTSelector_gutter_runner.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_gutter_runner.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = var_0_1.start
	local var_4_1 = var_0_1.stop
	local var_4_2 = arg_4_0:current_running_child(arg_4_2)
	local var_4_3 = arg_4_0._children
	local var_4_4 = var_4_3[1]

	if not arg_4_2.high_ground_opportunity and not arg_4_2.pouncing_target and (arg_4_2.is_falling or arg_4_2.fall_state ~= nil) then
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

	if arg_4_2.stagger then
		if arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_8 = true
		end
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

	if arg_4_2.spawn then
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

	if arg_4_2.in_vortex then
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

	if arg_4_2.jump_data then
		var_4_18 = false
	end

	if var_4_18 == nil then
		var_4_18 = BTConditions.at_smartobject(arg_4_2)
	end

	if var_4_18 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_17, "aborted")

		local var_4_19, var_4_20 = var_4_17:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_19 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_19)
		end

		if var_4_19 ~= "failed" then
			return var_4_19, var_4_20
		end
	elseif var_4_17 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_21 = var_4_3[6]

	if arg_4_2.ninja_vanish then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_21, "aborted")

		local var_4_22, var_4_23 = var_4_21:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_22 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_22)
		end

		if var_4_22 ~= "failed" then
			return var_4_22, var_4_23
		end
	elseif var_4_21 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_24 = var_4_3[7]

	if arg_4_2.high_ground_opportunity then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_24, "aborted")

		local var_4_25, var_4_26 = var_4_24:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_25 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_25)
		end

		if var_4_25 ~= "failed" then
			return var_4_25, var_4_26
		end
	elseif var_4_24 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_27 = var_4_3[8]
	local var_4_28 = Managers.time:time("game")
	local var_4_29 = var_4_28 > arg_4_2.initial_pounce_timer

	if (arg_4_2.target_unit or arg_4_2.comitted_to_target) and var_4_29 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, var_4_28, var_4_27, "aborted")

		local var_4_30, var_4_31 = var_4_27:run(arg_4_1, arg_4_2, var_4_28, arg_4_4)

		if var_4_30 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, var_4_28, nil, var_4_30)
		end

		if var_4_30 ~= "failed" then
			return var_4_30, var_4_31
		end
	elseif var_4_27 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, var_4_28, nil, "failed")
	end

	local var_4_32 = var_4_3[9]

	if var_0_0(arg_4_2.target_unit) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_32, "aborted")

		local var_4_33, var_4_34 = var_4_32:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_33 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_33)
		end

		if var_4_33 ~= "failed" then
			return var_4_33, var_4_34
		end
	elseif var_4_32 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_35 = var_4_3[10]

	if arg_4_2.secondary_target then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_35, "aborted")

		local var_4_36, var_4_37 = var_4_35:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_36 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_36)
		end

		if var_4_36 ~= "failed" then
			return var_4_36, var_4_37
		end
	elseif var_4_35 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_38 = var_4_3[11]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_38, "aborted")

	local var_4_39, var_4_40 = var_4_38:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_39 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_39)
	end

	if var_4_39 ~= "failed" then
		return var_4_39, var_4_40
	end
end

BTSelector_gutter_runner.add_child = function (arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
