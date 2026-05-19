-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_shield_user_extension.lua

AIShieldUserExtension = class(AIShieldUserExtension)

function AIShieldUserExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0.is_blocking = arg_1_3.is_blocking or true
	arg_1_0.is_dodging = arg_1_3.is_dodging or false
	arg_1_0.shield_broken = false
end

function AIShieldUserExtension.destroy(arg_2_0)
	return
end

function AIShieldUserExtension.extensions_ready(arg_3_0, arg_3_1, arg_3_2)
	assert(Managers.state.network.is_server)

	local var_3_0 = ScriptUnit.extension(arg_3_2, "ai_system"):blackboard()
	local var_3_1 = var_3_0.spawn_type

	arg_3_0.is_blocking = var_3_1 == "horde" or var_3_1 == "horde_hidden"
	arg_3_0._blackboard = var_3_0
	arg_3_0.blocked_previous_attack = false
	var_3_0.shield_user = true
end

function AIShieldUserExtension.set_is_blocking(arg_4_0, arg_4_1)
	if arg_4_0.shield_broken then
		return
	end

	local var_4_0 = arg_4_0._unit
	local var_4_1 = Managers.state.unit_storage:go_id(var_4_0)
	local var_4_2 = Managers.state.network:game()

	if var_4_2 and var_4_1 then
		GameSession.set_game_object_field(var_4_2, var_4_1, "is_blocking", arg_4_1)
	end

	arg_4_0.is_blocking = arg_4_1
end

function AIShieldUserExtension.set_is_dodging(arg_5_0, arg_5_1)
	if arg_5_0.shield_broken then
		return
	end

	local var_5_0 = arg_5_0._unit
	local var_5_1 = Managers.state.unit_storage:go_id(var_5_0)
	local var_5_2 = Managers.state.network:game()

	if var_5_2 and var_5_1 then
		GameSession.set_game_object_field(var_5_2, var_5_1, "is_dodging", arg_5_1)
	end

	arg_5_0.is_dodging = arg_5_1
end

function AIShieldUserExtension.break_shield(arg_6_0)
	arg_6_0:set_is_blocking(false)

	arg_6_0.shield_broken = true

	local var_6_0 = arg_6_0._unit
	local var_6_1 = arg_6_0._blackboard

	var_6_1.shield_breaking_hit = true
	var_6_1.shield_user = false

	local var_6_2 = ScriptUnit.extension(var_6_0, "ai_inventory_system")
	local var_6_3 = var_6_2.inventory_item_definitions
	local var_6_4 = "shield_break"
	local var_6_5 = Managers.state.network.network_transmit
	local var_6_6 = Managers.state.unit_storage:go_id(var_6_0)
	local var_6_7 = NetworkLookup.item_drop_reasons[var_6_4]
	local var_6_8 = false

	for iter_6_0 = 1, #var_6_3 do
		local var_6_9 = var_6_3[iter_6_0]
		local var_6_10, var_6_11 = var_6_2:drop_single_item(iter_6_0, var_6_4)

		if var_6_10 then
			var_6_8 = true

			var_6_5:send_rpc_clients("rpc_ai_drop_single_item", var_6_6, iter_6_0, var_6_7)
		end
	end

	return var_6_8
end

function AIShieldUserExtension.can_block_attack(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	assert(arg_7_1)

	local var_7_0 = arg_7_0._unit

	if not arg_7_0.is_blocking or not HEALTH_ALIVE[var_7_0] then
		return false
	end

	local var_7_1 = Unit.world_position(arg_7_1, 0)
	local var_7_2 = Unit.world_position(var_7_0, 0)
	local var_7_3 = Vector3.normalize(var_7_2 - var_7_1)
	local var_7_4 = Quaternion.forward(Unit.local_rotation(var_7_0, 0))
	local var_7_5
	local var_7_6

	if arg_7_2 then
		local var_7_7 = Vector3.dot(var_7_4, arg_7_3)

		var_7_6 = var_7_7 >= -0.75 and var_7_7 <= 1
	else
		local var_7_8 = Vector3.dot(var_7_4, var_7_3)

		var_7_6 = var_7_8 >= 0.55 and var_7_8 <= 1
	end

	return not var_7_6
end
