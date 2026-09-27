-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_activate_ability_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotActivateAbilityAction = class(BTBotActivateAbilityAction, BTNode)

BTBotActivateAbilityAction.init = function (arg_1_0, ...)
	-- function 1
	BTBotActivateAbilityAction.super.init(arg_1_0, ...)
end

BTBotActivateAbilityAction.name = "BTBotActivateAbilityAction"

BTBotActivateAbilityAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local var_2_0 = self._tree_node.action_data[arg_2_2.career_extension:career_name()]
	local inventory_extension = arg_2_2.inventory_extension
	local activate_ability_data = arg_2_2.activate_ability_data

	activate_ability_data.is_using_ability = true
	activate_ability_data.do_start_input = true
	activate_ability_data.started = false
	activate_ability_data.enter_time = arg_2_3
	activate_ability_data.next_repath_t = arg_2_3
	activate_ability_data.activation = var_2_0.activation
	activate_ability_data.wait_action = var_2_0.wait_action
	activate_ability_data.end_condition = var_2_0.end_condition
	activate_ability_data.is_weapon_ability = inventory_extension:get_slot_data("slot_career_skill_weapon") ~= nil

	if activate_ability_data.activation.action == "aim_at_target" then
		local unbox = activate_ability_data.aim_position:unbox()
		local input_extension = arg_2_2.input_extension
		local flag = not var_2_0.fast_aim

		input_extension:set_aiming(true, flag, false)
		input_extension:set_aim_position(unbox)
	end
end

BTBotActivateAbilityAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local activate_ability_data = arg_3_2.activate_ability_data

	if activate_ability_data.activation.action == "aim_at_target" then
		arg_3_2.input_extension:set_aiming(false)
	end

	activate_ability_data.is_using_ability = false
	activate_ability_data.move_to_position_set = false

	if arg_3_4 ~= "done" then
		self:_cancel_ability(activate_ability_data, arg_3_2, arg_3_3)
	end
end

BTBotActivateAbilityAction._start_ability = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local flag = false
	local do_start_input = arg_4_1.do_start_input
	local activation = arg_4_1.activation
	local action = activation.action

	if not do_start_input then
		arg_4_2.input_extension:activate_ability()

		local enter_time = arg_4_1.enter_time
		local min_hold_time = activation.min_hold_time

		min_hold_time = min_hold_time or 0

		if arg_4_3 >= enter_time + min_hold_time then
			if action == "aim_at_target" then
				local first_person_extension = arg_4_2.first_person_extension
				local current_position = first_person_extension:current_position()
				local current_rotation = first_person_extension:current_rotation()
				local forward = Quaternion.forward(current_rotation)
				local unbox = arg_4_1.aim_position:unbox()
				local normalize = Vector3.normalize(unbox - current_position)

				if Vector3.dot(forward, normalize) >= 0.995 then
					do_start_input = not activation.max_distance_sq and Vector3.distance_squared(current_position, unbox) > activation.max_distance_sq
				else
					do_start_input = true
				end
			else
				do_start_input = false
			end
		else
			do_start_input = true
		end
	elseif not arg_4_1.is_weapon_ability then
		if arg_4_2.inventory_extension:get_wielded_slot_data().id ~= "slot_career_skill_weapon" then
			do_start_input, flag = true, false
		else
			do_start_input, flag = false, true
		end
	else
		do_start_input, flag = false, true
	end

	return do_start_input, flag
end

BTBotActivateAbilityAction._cancel_ability = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	arg_5_2.input_extension:cancel_ability()
end

BTBotActivateAbilityAction._perform_wait_action = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local wait_action = arg_6_1.wait_action

	if not wait_action.input then
		local input_extension = arg_6_3.input_extension

		input_extension[wait_action.input](input_extension)
	end
end

BTBotActivateAbilityAction._evaluate_end_condition = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local end_condition = arg_7_1.end_condition

	if end_condition == nil then
		return "done"
	end

	if not end_condition.is_slot_not_wielded then
		local wielded_slot = arg_7_3.inventory_extension:equipment().wielded_slot

		if not table.contains(end_condition.is_slot_not_wielded, wielded_slot) then
			return "done"
		end
	end

	if not end_condition.buffs then
		local extension = ScriptUnit.extension(arg_7_2, "buff_system")
		local var_7_3
		local buffs = end_condition.buffs
		local count = #buffs

		for i = 1, count do
			local var_7_6 = buffs[i]

			var_7_3 = extension:get_non_stacking_buff(var_7_6)

			if not var_7_3 then
				break
			end
		end

		local offset_time = end_condition.offset_time

		if not ((var_7_3 == nil or not offset_time) and not var_7_3 and not var_7_3.end_time and not (arg_7_4 > var_7_3.end_time - offset_time)) then
			return "done"
		end
	end

	if not end_condition.done_when_arriving_at_destination then
		local navigation_extension = arg_7_3.navigation_extension
		local current_velocity = arg_7_3.locomotion_extension:current_velocity()
		local length_squared = Vector3.length_squared(current_velocity)
		local num = 0.04000000000000001

		if not (not (arg_7_4 - arg_7_1.enter_time > 0.5) or navigation_extension:destination_reached() or not (length_squared <= num)) then
			return "done"
		end
	end

	return "running"
end

BTBotActivateAbilityAction.run = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local activate_ability_data = arg_8_2.activate_ability_data
	local activation = activate_ability_data.activation

	if not activation.dynamic_target_unit then
		local target_unit

		if not activation.custom_target_unit then
			target_unit = activate_ability_data.target_unit

			if not target_unit then
				-- Nothing
			end
		end

		target_unit = arg_8_2.target_unit

		::label_8_0::

		if not ALIVE[target_unit] then
			if target_unit == arg_8_1 then
				local input_extension = arg_8_2.input_extension

				input_extension:set_aiming(true, true, false)

				local first_person_extension = arg_8_2.first_person_extension
				local current_position = first_person_extension:current_position()
				local current_rotation = first_person_extension:current_rotation()
				local forward = Quaternion.forward(current_rotation)

				input_extension:set_aim_position(current_position + forward)
			else
				local bot_melee_aim_pos = AiUtils.bot_melee_aim_pos(arg_8_1, target_unit, activate_ability_data.aim_position)
				local input_extension_2 = arg_8_2.input_extension

				input_extension_2:set_aiming(true, true, false)
				input_extension_2:set_aim_position(bot_melee_aim_pos)

				if not (not activation.move_to_target_unit and not (arg_8_3 >= activate_ability_data.next_repath_t)) then
					arg_8_2.navigation_destination_override:store(bot_melee_aim_pos)

					activate_ability_data.move_to_position_set = true
					activate_ability_data.next_repath_t = arg_8_3 + 0.5
				end
			end
		else
			return "failed"
		end
	end

	if not arg_8_2.status_extension:is_disabled() then
		return "failed"
	end

	if not activate_ability_data.started then
		activate_ability_data.do_start_input, activate_ability_data.started = self:_start_ability(activate_ability_data, arg_8_2, arg_8_3)

		return "running"
	end

	if not activate_ability_data.is_weapon_ability and not activate_ability_data.started then
		arg_8_2.input_extension:release_ability_hold()
	end

	if not activate_ability_data.wait_action then
		self:_perform_wait_action(activate_ability_data, arg_8_1, arg_8_2)
	end

	return self:_evaluate_end_condition(activate_ability_data, arg_8_1, arg_8_2, arg_8_3)
end
