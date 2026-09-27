-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_loot_rat_alerted_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTLootRatAlertedAction = class(BTLootRatAlertedAction, BTNode)

BTLootRatAlertedAction.init = function (arg_1_0, ...)
	-- function 1
	BTLootRatAlertedAction.super.init(arg_1_0, ...)
end

BTLootRatAlertedAction.name = "BTLootRatAlertedAction"

BTLootRatAlertedAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.move_animation_name = nil
	arg_2_2.anim_cb_rotation_start = false
	arg_2_2.anim_cb_move = false

	if arg_2_2.confirmed_player_sighting == nil then
		self:init_alerted(arg_2_1, arg_2_2)
	end

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

BTLootRatAlertedAction.init_alerted = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_3_1)

	if not script_data.enable_alert_icon then
		local str = "detect"
		local node = Unit.node(arg_3_1, "c_head")
		local str_2 = "player_1"
		local var_3_5 = Vector3(255, 0, 0)
		local var_3_6 = Vector3(0, 0, 1)
		local num = 0.5
		local str_3 = "!"

		Managers.state.debug_text:output_unit_text(str_3, num, arg_3_1, node, var_3_6, nil, str, var_3_5, str_2)
		network.network_transmit:send_rpc_clients("rpc_enemy_is_alerted", unit_game_object_id, true)
	end

	local str_4 = "alerted"

	network:anim_event(arg_3_1, str_4)

	arg_3_2.move_animation_name = str_4

	if not ScriptUnit.has_extension(arg_3_1, "ai_inventory_system") then
		network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, 1)
	end
end

BTLootRatAlertedAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not script_data.enable_alert_icon then
		local str = "detect"

		Managers.state.debug_text:clear_unit_text(arg_4_1, str)

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_4_1)

		network.network_transmit:send_rpc_clients("rpc_enemy_is_alerted", unit_game_object_id, false)
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
	-- function 5
	if not arg_5_2.confirmed_player_sighting then
		return "done"
	end

	if not arg_5_2.anim_cb_move then
		arg_5_2.anim_cb_move = false
		arg_5_2.move_state = "moving"
		arg_5_2.anim_locked = 0

		return "done"
	else
		return "running"
	end
end
