-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_grey_seer.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_grey_seer = class(BTSelector_grey_seer, BTNode)
BTSelector_grey_seer.name = "BTSelector_grey_seer"

function BTSelector_grey_seer.init(arg_2_0, ...)
	BTSelector_grey_seer.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

function BTSelector_grey_seer.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

function BTSelector_grey_seer.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if arg_4_2.should_mount_unit ~= nil then
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

	if arg_4_2.waiting_for_pickup then
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
	local var_4_18 = arg_4_2.mounted_data.mount_unit

	if not arg_4_2.knocked_off_mount and HEALTH_ALIVE[var_4_18] then
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

	if arg_4_2.current_phase == 6 then
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

	if arg_4_2.current_phase == 5 then
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

	if arg_4_2.call_stormfiend then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_27, "aborted")

		local var_4_28, var_4_29 = var_4_27:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_28 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_28)
		end

		if var_4_28 ~= "failed" then
			return var_4_28, var_4_29
		end
	elseif var_4_27 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_30 = var_4_3[9]
	local var_4_31

	if arg_4_2.stagger then
		if arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_31 = not arg_4_2.about_to_mount
		end
	end

	if var_4_31 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_30, "aborted")

		local var_4_32, var_4_33 = var_4_30:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_32 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_32)
		end

		if var_4_32 ~= "failed" then
			return var_4_32, var_4_33
		end
	elseif var_4_30 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_34 = var_4_3[10]

	if arg_4_2.ready_to_summon and not arg_4_2.about_to_mount and HEALTH_ALIVE[arg_4_2.target_unit] then
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

	local var_4_37 = var_4_3[11]

	if (arg_4_2.knocked_off_mount or not HEALTH_ALIVE[arg_4_2.mounted_data.mount_unit]) and HEALTH_ALIVE[arg_4_2.target_unit] then
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

	local var_4_40 = var_4_3[12]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_40, "aborted")

	local var_4_41, var_4_42 = var_4_40:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_41 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_41)
	end

	if var_4_41 ~= "failed" then
		return var_4_41, var_4_42
	end

	local var_4_43 = var_4_3[13]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_43, "aborted")

	local var_4_44, var_4_45 = var_4_43:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_44 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_44)
	end

	if var_4_44 ~= "failed" then
		return var_4_44, var_4_45
	end
end

function BTSelector_grey_seer.add_child(arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
