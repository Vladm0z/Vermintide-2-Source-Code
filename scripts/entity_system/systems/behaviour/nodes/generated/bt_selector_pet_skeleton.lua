-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_pet_skeleton.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_pet_skeleton = class(BTSelector_pet_skeleton, BTNode)
BTSelector_pet_skeleton.name = "BTSelector_pet_skeleton"

function BTSelector_pet_skeleton.init(arg_2_0, ...)
	BTSelector_pet_skeleton.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

function BTSelector_pet_skeleton.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

function BTSelector_pet_skeleton.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
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

	if arg_4_2.is_transported then
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

	if arg_4_2.in_vortex then
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
	local var_4_17

	if arg_4_2.stagger then
		if arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_17 = true
		end
	end

	if var_4_17 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_16, "aborted")

		local var_4_18, var_4_19 = var_4_16:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_18 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_18)
		end

		if var_4_18 ~= "failed" then
			return var_4_18, var_4_19
		end
	elseif var_4_16 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_20 = var_4_3[6]

	if arg_4_2.blocked then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_20, "aborted")

		local var_4_21, var_4_22 = var_4_20:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_21 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_21)
		end

		if var_4_21 ~= "failed" then
			return var_4_21, var_4_22
		end
	elseif var_4_20 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_23 = var_4_3[7]
	local var_4_24
	local var_4_25 = arg_4_2.next_smart_object_data

	if not (var_4_25.next_smart_object_id ~= nil) then
		var_4_24 = false
	end

	local var_4_26 = arg_4_2.is_smart_objecting
	local var_4_27 = Managers.state.entity:system("nav_graph_system")
	local var_4_28 = var_4_25.smart_object_data and var_4_25.smart_object_data.unit
	local var_4_29, var_4_30 = var_4_27:has_nav_graph(var_4_28)

	if var_4_29 and not var_4_30 and not var_4_26 and var_4_24 == nil then
		var_4_24 = false
	end

	local var_4_31 = arg_4_2.is_in_smartobject_range
	local var_4_32 = arg_4_2.move_state == "moving"

	if var_4_24 == nil then
		var_4_24 = var_4_31 and var_4_32 or var_4_26
	end

	if var_4_24 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_23, "aborted")

		local var_4_33, var_4_34 = var_4_23:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_33 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_33)
		end

		if var_4_33 ~= "failed" then
			return var_4_33, var_4_34
		end
	elseif var_4_23 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_35 = var_4_3[8]
	local var_4_36
	local var_4_37 = arg_4_2.unit
	local var_4_38 = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_4_37)

	if var_4_38 then
		local var_4_39 = arg_4_2.breed.max_commander_distance

		if var_4_39 then
			local var_4_40 = POSITION_LOOKUP[var_4_38]
			local var_4_41 = POSITION_LOOKUP[var_4_37]

			if Vector3.distance_squared(var_4_40, var_4_41) > var_4_39 * var_4_39 then
				var_4_36 = true
			end
		end
	end

	if var_4_36 == nil then
		var_4_36 = false
	end

	if var_4_36 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_35, "aborted")

		local var_4_42, var_4_43 = var_4_35:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_42 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_42)
		end

		if var_4_42 ~= "failed" then
			return var_4_42, var_4_43
		end
	elseif var_4_35 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_44 = var_4_3[9]

	if ALIVE[arg_4_2.commander_unit] and ScriptUnit.extension(arg_4_2.commander_unit, "status_system"):is_disabled() or arg_4_2.disabled_resume_time and Managers.time:time("game") < arg_4_2.disabled_resume_time then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_44, "aborted")

		local var_4_45, var_4_46 = var_4_44:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_45 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_45)
		end

		if var_4_45 ~= "failed" then
			return var_4_45, var_4_46
		end
	elseif var_4_44 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_47 = var_4_3[10]

	if arg_4_2.charge_target then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_47, "aborted")

		local var_4_48, var_4_49 = var_4_47:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_48 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_48)
		end

		if var_4_48 ~= "failed" then
			return var_4_48, var_4_49
		end
	elseif var_4_47 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_50 = var_4_3[11]

	if (arg_4_2.new_command_attack or arg_4_2.undergoing_command_attack) and (ALIVE[arg_4_2.target_unit] and arg_4_2.new_command_attack or (ALIVE[arg_4_2.locked_target_unit] or arg_4_2.attack_locked_in_t) and arg_4_2.undergoing_command_attack) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_50, "aborted")

		local var_4_51, var_4_52 = var_4_50:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_51 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_51)
		end

		if var_4_51 ~= "failed" then
			return var_4_51, var_4_52
		end
	elseif var_4_50 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_53 = var_4_3[12]

	if ALIVE[arg_4_2.target_unit] and arg_4_2.confirmed_enemy_sighting_within_commander or arg_4_2.attack_locked_in_t then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_53, "aborted")

		local var_4_54, var_4_55 = var_4_53:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_54 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_54)
		end

		if var_4_54 ~= "failed" then
			return var_4_54, var_4_55
		end
	elseif var_4_53 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_56 = var_4_3[13]

	if arg_4_2.command_state == CommandStates.StandingGround then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_56, "aborted")

		local var_4_57, var_4_58 = var_4_56:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_57 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_57)
		end

		if var_4_57 ~= "failed" then
			return var_4_57, var_4_58
		end
	elseif var_4_56 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_59 = var_4_3[14]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_59, "aborted")

	local var_4_60, var_4_61 = var_4_59:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_60 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_60)
	end

	if var_4_60 ~= "failed" then
		return var_4_60, var_4_61
	end
end

function BTSelector_pet_skeleton.add_child(arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
