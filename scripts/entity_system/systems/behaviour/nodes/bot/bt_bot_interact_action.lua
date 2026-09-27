-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_interact_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotInteractAction = class(BTBotInteractAction, BTNode)

BTBotInteractAction.init = function (arg_1_0, ...)
	-- function 1
	BTBotInteractAction.super.init(arg_1_0, ...)
end

BTBotInteractAction.name = "BTBotInteractAction"

local alive = Unit.alive

BTBotInteractAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local interaction_unit = arg_2_2.interaction_unit

	arg_2_2.current_interaction_unit = interaction_unit

	local interaction_extension = arg_2_2.interaction_extension

	interaction_extension:set_exclusive_interaction_unit(interaction_unit)

	arg_2_2.interact = {
		tried = false,
		wait_on_previous_interaction = interaction_extension:is_interacting()
	}

	local input_extension = arg_2_2.input_extension
	local flag = true

	input_extension:set_aiming(true, flag)
end

BTBotInteractAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.interact = false

	arg_3_2.interaction_extension:set_exclusive_interaction_unit(nil)
	arg_3_2.input_extension:set_aiming(false)

	arg_3_2.current_interaction_unit = nil
end

BTBotInteractAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local current_interaction_unit = arg_4_2.current_interaction_unit

	if not alive(current_interaction_unit) and current_interaction_unit == arg_4_2.interaction_unit or not arg_4_2.interaction_unit then
		return "failed"
	end

	local action_data = self._tree_node.action_data
	local status_extension = arg_4_2.status_extension
	local interaction_extension = arg_4_2.interaction_extension
	local input_extension = arg_4_2.input_extension
	local state = interaction_extension.state
	local interact = arg_4_2.interact
	local flag = true

	if not action_data and not action_data.use_block_interaction then
		input_extension:defend()

		flag = status_extension:is_blocking()
	end

	if not flag then
		local input

		if not action_data then
			input = action_data.input

			if not input then
				-- Nothing
			end
		end

		input = InteractionHelper.interaction_action_names(arg_4_1)

		::label_4_0::

		if not interact.wait_on_previous_interaction then
			interact.wait_on_previous_interaction = false
		elseif not (state ~= "waiting_to_interact" or interact.tried) then
			input_extension[input](input_extension)

			interact.tried = true
		elseif state == "waiting_to_interact" then
			interact.tried = false
		else
			input_extension[input](input_extension)
		end
	end

	local var_4_9

	if not action_data and not Unit.has_node(current_interaction_unit, action_data.aim_node) then
		var_4_9 = Unit.world_position(current_interaction_unit, Unit.node(current_interaction_unit, action_data.aim_node))
	else
		var_4_9 = Unit.world_position(current_interaction_unit, 0)
	end

	input_extension:set_aim_position(var_4_9)

	return "running"
end
