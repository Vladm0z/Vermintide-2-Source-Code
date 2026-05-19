-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_activate_ability_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotActivateAbilityAction = class(BTBotActivateAbilityAction, BTNode)

function BTBotActivateAbilityAction.init(arg_1_0, ...)
	BTBotActivateAbilityAction.super.init(arg_1_0, ...)
end

BTBotActivateAbilityAction.name = "BTBotActivateAbilityAction"

function BTBotActivateAbilityAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data[arg_2_2.career_extension:career_name()]
	local var_2_1 = arg_2_2.inventory_extension
	local var_2_2 = arg_2_2.activate_ability_data

	var_2_2.is_using_ability = true
	var_2_2.do_start_input = true
	var_2_2.started = false
	var_2_2.enter_time = arg_2_3
	var_2_2.next_repath_t = arg_2_3
	var_2_2.activation = var_2_0.activation
	var_2_2.wait_action = var_2_0.wait_action
	var_2_2.end_condition = var_2_0.end_condition
	var_2_2.is_weapon_ability = var_2_1:get_slot_data("slot_career_skill_weapon") ~= nil

	if var_2_2.activation.action == "aim_at_target" then
		local var_2_3 = var_2_2.aim_position:unbox()
		local var_2_4 = arg_2_2.input_extension
		local var_2_5 = not var_2_0.fast_aim

		var_2_4:set_aiming(true, var_2_5, false)
		var_2_4:set_aim_position(var_2_3)
	end
end

function BTBotActivateAbilityAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_2.activate_ability_data

	if var_3_0.activation.action == "aim_at_target" then
		arg_3_2.input_extension:set_aiming(false)
	end

	var_3_0.is_using_ability = false
	var_3_0.move_to_position_set = false

	if arg_3_4 ~= "done" then
		arg_3_0:_cancel_ability(var_3_0, arg_3_2, arg_3_3)
	end
end

function BTBotActivateAbilityAction._start_ability(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = false
	local var_4_1 = arg_4_1.do_start_input
	local var_4_2 = arg_4_1.activation
	local var_4_3 = var_4_2.action

	if var_4_1 then
		arg_4_2.input_extension:activate_ability()

		if arg_4_3 >= arg_4_1.enter_time + (var_4_2.min_hold_time or 0) then
			if var_4_3 == "aim_at_target" then
				local var_4_4 = arg_4_2.first_person_extension
				local var_4_5 = var_4_4:current_position()
				local var_4_6 = var_4_4:current_rotation()
				local var_4_7 = Quaternion.forward(var_4_6)
				local var_4_8 = arg_4_1.aim_position:unbox()
				local var_4_9 = Vector3.normalize(var_4_8 - var_4_5)

				if Vector3.dot(var_4_7, var_4_9) >= 0.995 then
					var_4_1 = var_4_2.max_distance_sq and Vector3.distance_squared(var_4_5, var_4_8) > var_4_2.max_distance_sq
				else
					var_4_1 = true
				end
			else
				var_4_1 = false
			end
		else
			var_4_1 = true
		end
	elseif arg_4_1.is_weapon_ability then
		if arg_4_2.inventory_extension:get_wielded_slot_data().id ~= "slot_career_skill_weapon" then
			var_4_1, var_4_0 = true, false
		else
			var_4_1, var_4_0 = false, true
		end
	else
		var_4_1, var_4_0 = false, true
	end

	return var_4_1, var_4_0
end

function BTBotActivateAbilityAction._cancel_ability(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_2.input_extension:cancel_ability()
end

function BTBotActivateAbilityAction._perform_wait_action(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1.wait_action

	if var_6_0.input then
		local var_6_1 = arg_6_3.input_extension

		var_6_1[var_6_0.input](var_6_1)
	end
end

function BTBotActivateAbilityAction._evaluate_end_condition(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_1.end_condition

	if var_7_0 == nil then
		return "done"
	end

	if var_7_0.is_slot_not_wielded then
		local var_7_1 = arg_7_3.inventory_extension:equipment().wielded_slot

		if not table.contains(var_7_0.is_slot_not_wielded, var_7_1) then
			return "done"
		end
	end

	if var_7_0.buffs then
		local var_7_2 = ScriptUnit.extension(arg_7_2, "buff_system")
		local var_7_3
		local var_7_4 = var_7_0.buffs
		local var_7_5 = #var_7_4

		for iter_7_0 = 1, var_7_5 do
			local var_7_6 = var_7_4[iter_7_0]

			var_7_3 = var_7_2:get_non_stacking_buff(var_7_6)

			if var_7_3 then
				break
			end
		end

		local var_7_7 = var_7_0.offset_time

		if var_7_3 == nil or var_7_7 and var_7_3 and var_7_3.end_time and arg_7_4 > var_7_3.end_time - var_7_7 then
			return "done"
		end
	end

	if var_7_0.done_when_arriving_at_destination then
		local var_7_8 = arg_7_3.navigation_extension
		local var_7_9 = arg_7_3.locomotion_extension:current_velocity()
		local var_7_10 = Vector3.length_squared(var_7_9)
		local var_7_11 = 0.04000000000000001

		if arg_7_4 - arg_7_1.enter_time > 0.5 and (var_7_8:destination_reached() or var_7_10 <= var_7_11) then
			return "done"
		end
	end

	return "running"
end

function BTBotActivateAbilityAction.run(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_2.activate_ability_data
	local var_8_1 = var_8_0.activation

	if var_8_1.dynamic_target_unit then
		local var_8_2 = var_8_1.custom_target_unit and var_8_0.target_unit or arg_8_2.target_unit

		if ALIVE[var_8_2] then
			if var_8_2 == arg_8_1 then
				local var_8_3 = arg_8_2.input_extension

				var_8_3:set_aiming(true, true, false)

				local var_8_4 = arg_8_2.first_person_extension
				local var_8_5 = var_8_4:current_position()
				local var_8_6 = var_8_4:current_rotation()
				local var_8_7 = Quaternion.forward(var_8_6)

				var_8_3:set_aim_position(var_8_5 + var_8_7)
			else
				local var_8_8 = AiUtils.bot_melee_aim_pos(arg_8_1, var_8_2, var_8_0.aim_position)
				local var_8_9 = arg_8_2.input_extension

				var_8_9:set_aiming(true, true, false)
				var_8_9:set_aim_position(var_8_8)

				if var_8_1.move_to_target_unit and arg_8_3 >= var_8_0.next_repath_t then
					arg_8_2.navigation_destination_override:store(var_8_8)

					var_8_0.move_to_position_set = true
					var_8_0.next_repath_t = arg_8_3 + 0.5
				end
			end
		else
			return "failed"
		end
	end

	if arg_8_2.status_extension:is_disabled() then
		return "failed"
	end

	if not var_8_0.started then
		var_8_0.do_start_input, var_8_0.started = arg_8_0:_start_ability(var_8_0, arg_8_2, arg_8_3)

		return "running"
	end

	if var_8_0.is_weapon_ability and var_8_0.started then
		arg_8_2.input_extension:release_ability_hold()
	end

	if var_8_0.wait_action then
		arg_8_0:_perform_wait_action(var_8_0, arg_8_1, arg_8_2)
	end

	return arg_8_0:_evaluate_end_condition(var_8_0, arg_8_1, arg_8_2, arg_8_3)
end
