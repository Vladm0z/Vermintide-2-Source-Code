-- chunkname: @scripts/unit_extensions/weapons/actions/action_throw_grimoire.lua

ActionThrowGrimoire = class(ActionThrowGrimoire, ActionBase)

ActionThrowGrimoire.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionThrowGrimoire.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionThrowGrimoire.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2)
	ActionThrowGrimoire.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1
	arg_2_0.ammo_extension = ScriptUnit.extension(arg_2_0.weapon_unit, "ammo_system")
end

ActionThrowGrimoire.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

ActionThrowGrimoire.finish = function (arg_4_0, arg_4_1)
	if arg_4_1 ~= "action_complete" then
		return
	end

	local var_4_0 = arg_4_0.current_action.ammo_usage

	arg_4_0.ammo_extension:use_ammo(var_4_0)

	local var_4_1 = ScriptUnit.extension_input(arg_4_0.owner_unit, "dialogue_system")
	local var_4_2 = FrameTable.alloc_table()

	var_4_2.item_type = "grimoire"

	var_4_1:trigger_networked_dialogue_event("throwing_item", var_4_2)

	local var_4_3 = Managers.player:unit_owner(arg_4_0.owner_unit)
	local var_4_4 = POSITION_LOOKUP[arg_4_0.owner_unit]

	Managers.telemetry_events:player_used_item(var_4_3, arg_4_0.item_name, var_4_4)

	local var_4_5 = var_4_3:is_player_controlled()
	local var_4_6 = var_4_3.peer_id
	local var_4_7 = "discarded_grimoire"
	local var_4_8 = var_4_3:name()

	if not IS_CONSOLE then
		var_4_8 = var_4_5 and (rawget(_G, "Steam") and Steam.user_name(var_4_6) or tostring(var_4_6)) or var_4_3:name()
	end

	local var_4_9 = true
	local var_4_10 = string.format(Localize("system_chat_player_discarded_grimoire"), var_4_8)

	Managers.chat:add_local_system_message(1, var_4_10, var_4_9)
	Managers.state.event:trigger("add_coop_feedback", var_4_3:stats_id(), not var_4_3.bot_player, var_4_7, var_4_3)

	if arg_4_0.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_coop_feedback", var_4_3:network_id(), var_4_3:local_player_id(), NetworkLookup.coop_feedback[var_4_7], var_4_3:network_id(), var_4_3:local_player_id())
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_coop_feedback", var_4_3:network_id(), var_4_3:local_player_id(), NetworkLookup.coop_feedback[var_4_7], var_4_3:network_id(), var_4_3:local_player_id())
	end
end
