-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_loot_rat_alerted_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTLootRatAlertedAction = class(BTLootRatAlertedAction, BTNode)

BTLootRatAlertedAction.init = function (arg_1_0, ...)
	BTLootRatAlertedAction.super.init(arg_1_0, ...)
end

BTLootRatAlertedAction.name = "BTLootRatAlertedAction"

BTLootRatAlertedAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.move_animation_name = nil
	arg_2_2.anim_cb_rotation_start = false
	arg_2_2.anim_cb_move = false

	if arg_2_2.confirmed_player_sighting == nil then
		arg_2_0:init_alerted(arg_2_1, arg_2_2)
	end

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

BTLootRatAlertedAction.init_alerted = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Managers.state.network
	local var_3_1 = var_3_0:unit_game_object_id(arg_3_1)

	if script_data.enable_alert_icon then
		local var_3_2 = "detect"
		local var_3_3 = Unit.node(arg_3_1, "c_head")
		local var_3_4 = "player_1"
		local var_3_5 = Vector3(255, 0, 0)
		local var_3_6 = Vector3(0, 0, 1)
		local var_3_7 = 0.5
		local var_3_8 = "!"

		Managers.state.debug_text:output_unit_text(var_3_8, var_3_7, arg_3_1, var_3_3, var_3_6, nil, var_3_2, var_3_5, var_3_4)
		var_3_0.network_transmit:send_rpc_clients("rpc_enemy_is_alerted", var_3_1, true)
	end

	local var_3_9 = "alerted"

	var_3_0:anim_event(arg_3_1, var_3_9)

	arg_3_2.move_animation_name = var_3_9

	if ScriptUnit.has_extension(arg_3_1, "ai_inventory_system") then
		var_3_0.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_3_1, 1)
	end
end

BTLootRatAlertedAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if script_data.enable_alert_icon then
		local var_4_0 = "detect"

		Managers.state.debug_text:clear_unit_text(arg_4_1, var_4_0)

		local var_4_1 = Managers.state.network
		local var_4_2 = var_4_1:unit_game_object_id(arg_4_1)

		var_4_1.network_transmit:send_rpc_clients("rpc_enemy_is_alerted", var_4_2, false)
	end

	if not arg_4_5 then
		arg_4_2.locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_4_1, 1)
	end

	arg_4_2.navigation_extension:set_enabled(true)
	AiUtils.activate_unit(arg_4_2)

	arg_4_2.spawn_to_running = true
end

BTLootRatAlertedAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.confirmed_player_sighting then
		return "done"
	end

	if arg_5_2.anim_cb_move then
		arg_5_2.anim_cb_move = false
		arg_5_2.move_state = "moving"
		arg_5_2.anim_locked = 0

		return "done"
	else
		return "running"
	end
end
