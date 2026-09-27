-- chunkname: @scripts/unit_extensions/weapons/actions/action_throw_grimoire.lua

ActionThrowGrimoire = class(ActionThrowGrimoire, ActionBase)

ActionThrowGrimoire.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionThrowGrimoire.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionThrowGrimoire.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionThrowGrimoire.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
	self.ammo_extension = ScriptUnit.extension(self.weapon_unit, "ammo_system")
end

ActionThrowGrimoire.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionThrowGrimoire.finish = function (self, arg_4_1)
	-- function 4
	if arg_4_1 ~= "action_complete" then
		return
	end

	local ammo_usage = self.current_action.ammo_usage

	self.ammo_extension:use_ammo(ammo_usage)

	local extension_input = ScriptUnit.extension_input(self.owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	alloc_table.item_type = "grimoire"

	extension_input:trigger_networked_dialogue_event("throwing_item", alloc_table)

	local unit_owner = Managers.player:unit_owner(self.owner_unit)
	local var_4_4 = POSITION_LOOKUP[self.owner_unit]

	Managers.telemetry_events:player_used_item(unit_owner, self.item_name, var_4_4)

	local is_player_controlled = unit_owner:is_player_controlled()
	local peer_id = unit_owner.peer_id
	local str = "discarded_grimoire"
	local name = unit_owner:name()

	if not IS_CONSOLE then
		name = not is_player_controlled and not rawget(_G, "Steam") and Steam.user_name(peer_id) and tostring(peer_id) or unit_owner:name()
	end

	local flag = true
	local format = string.format(Localize("system_chat_player_discarded_grimoire"), name)

	Managers.chat:add_local_system_message(1, format, flag)
	Managers.state.event:trigger("add_coop_feedback", unit_owner:stats_id(), not unit_owner.bot_player, str, unit_owner)

	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_coop_feedback", unit_owner:network_id(), unit_owner:local_player_id(), NetworkLookup.coop_feedback[str], unit_owner:network_id(), unit_owner:local_player_id())
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_coop_feedback", unit_owner:network_id(), unit_owner:local_player_id(), NetworkLookup.coop_feedback[str], unit_owner:network_id(), unit_owner:local_player_id())
	end
end
