-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_interact_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotInteractAction = class(BTBotInteractAction, BTNode)

BTBotInteractAction.init = function (arg_1_0, ...)
	BTBotInteractAction.super.init(arg_1_0, ...)
end

BTBotInteractAction.name = "BTBotInteractAction"

local var_0_0 = Unit.alive

BTBotInteractAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.interaction_unit

	arg_2_2.current_interaction_unit = var_2_0

	local var_2_1 = arg_2_2.interaction_extension

	var_2_1:set_exclusive_interaction_unit(var_2_0)

	arg_2_2.interact = {
		tried = false,
		wait_on_previous_interaction = var_2_1:is_interacting()
	}

	local var_2_2 = arg_2_2.input_extension
	local var_2_3 = true

	var_2_2:set_aiming(true, var_2_3)
end

BTBotInteractAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.interact = false

	arg_3_2.interaction_extension:set_exclusive_interaction_unit(nil)
	arg_3_2.input_extension:set_aiming(false)

	arg_3_2.current_interaction_unit = nil
end

BTBotInteractAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.current_interaction_unit

	if not var_0_0(var_4_0) or var_4_0 ~= arg_4_2.interaction_unit and arg_4_2.interaction_unit then
		return "failed"
	end

	local var_4_1 = arg_4_0._tree_node.action_data
	local var_4_2 = arg_4_2.status_extension
	local var_4_3 = arg_4_2.interaction_extension
	local var_4_4 = arg_4_2.input_extension
	local var_4_5 = var_4_3.state
	local var_4_6 = arg_4_2.interact
	local var_4_7 = true

	if var_4_1 and var_4_1.use_block_interaction then
		var_4_4:defend()

		var_4_7 = var_4_2:is_blocking()
	end

	if var_4_7 then
		local var_4_8 = var_4_1 and var_4_1.input or InteractionHelper.interaction_action_names(arg_4_1)

		if var_4_6.wait_on_previous_interaction then
			var_4_6.wait_on_previous_interaction = false
		elseif var_4_5 == "waiting_to_interact" and not var_4_6.tried then
			var_4_4[var_4_8](var_4_4)

			var_4_6.tried = true
		elseif var_4_5 == "waiting_to_interact" then
			var_4_6.tried = false
		else
			var_4_4[var_4_8](var_4_4)
		end
	end

	local var_4_9

	if var_4_1 and Unit.has_node(var_4_0, var_4_1.aim_node) then
		var_4_9 = Unit.world_position(var_4_0, Unit.node(var_4_0, var_4_1.aim_node))
	else
		var_4_9 = Unit.world_position(var_4_0, 0)
	end

	var_4_4:set_aim_position(var_4_9)

	return "running"
end
