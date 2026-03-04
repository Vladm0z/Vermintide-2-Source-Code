-- chunkname: @scripts/unit_extensions/weapons/actions/action_healing_draught.lua

ActionHealingDraught = class(ActionHealingDraught, ActionBase)

ActionHealingDraught.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionHealingDraught.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end
end

ActionHealingDraught.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2)
	ActionHealingDraught.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1
end

ActionHealingDraught.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

ActionHealingDraught.finish = function (arg_4_0, arg_4_1)
	if arg_4_1 == "dead" or arg_4_1 == "knocked_down" or arg_4_1 == "weapon_wielded" then
		return
	end

	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = Managers.state.network
	local var_4_3 = var_4_2.network_transmit
	local var_4_4 = ScriptUnit.extension(var_4_1, "buff_system")
	local var_4_5 = "healing_draught"

	if var_4_0.dialogue_event then
		local var_4_6 = ScriptUnit.extension_input(var_4_1, "dialogue_system")
		local var_4_7 = FrameTable.alloc_table()

		var_4_6:trigger_networked_dialogue_event(var_4_0.dialogue_event, var_4_7)
	end

	if var_4_4:has_buff_perk("no_permanent_health") then
		var_4_5 = "healing_draught_temp_health"
	end

	local var_4_8 = Managers.state.game_mode:setting("healing_draught_heal_amount") or 75

	if arg_4_0.is_server or LEVEL_EDITOR_TEST then
		DamageUtils.heal_network(var_4_1, var_4_1, var_4_8, var_4_5)
	else
		local var_4_9 = var_4_2:unit_game_object_id(var_4_1)
		local var_4_10 = NetworkLookup.heal_types[var_4_5]

		var_4_3:send_rpc_server("rpc_request_heal", var_4_9, var_4_8, var_4_10)
	end

	local var_4_11 = arg_4_0.ammo_extension

	if var_4_11 then
		local var_4_12 = var_4_0.ammo_usage
		local var_4_13, var_4_14 = var_4_4:apply_buffs_to_value(0, "not_consume_medpack")
		local var_4_15 = ScriptUnit.has_extension(var_4_1, "inventory_system")

		if not var_4_14 then
			var_4_11:use_ammo(var_4_12)
		else
			var_4_15:wield_previous_weapon()
		end
	end

	local var_4_16 = Managers.player:unit_owner(var_4_1)
	local var_4_17 = POSITION_LOOKUP[var_4_1]

	Managers.telemetry_events:player_used_item(var_4_16, arg_4_0.item_name, var_4_17)
end
