-- chunkname: @scripts/unit_extensions/weapons/actions/action_healing_draught.lua

ActionHealingDraught = class(ActionHealingDraught, ActionBase)

ActionHealingDraught.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionHealingDraught.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end
end

ActionHealingDraught.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionHealingDraught.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
end

ActionHealingDraught.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionHealingDraught.finish = function (self, arg_4_1)
	-- function 4
	if not (arg_4_1 == "dead" or arg_4_1 == "knocked_down" or arg_4_1 ~= "weapon_wielded") then
		return
	end

	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local network = Managers.state.network
	local network_transmit = network.network_transmit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local str = "healing_draught"

	if not current_action.dialogue_event then
		local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event(current_action.dialogue_event, alloc_table)
	end

	if not extension:has_buff_perk("no_permanent_health") then
		str = "healing_draught_temp_health"
	end

	local setting = Managers.state.game_mode:setting("healing_draught_heal_amount")

	setting = setting or 75

	if self.is_server or not LEVEL_EDITOR_TEST then
		DamageUtils.heal_network(owner_unit, owner_unit, setting, str)
	else
		local unit_game_object_id = network:unit_game_object_id(owner_unit)
		local var_4_10 = NetworkLookup.heal_types[str]

		network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, setting, var_4_10)
	end

	local ammo_extension = self.ammo_extension

	if not ammo_extension then
		local ammo_usage = current_action.ammo_usage
		local apply_buffs_to_value, var_4_14 = extension:apply_buffs_to_value(0, "not_consume_medpack")
		local has_extension = ScriptUnit.has_extension(owner_unit, "inventory_system")

		if not var_4_14 then
			ammo_extension:use_ammo(ammo_usage)
		else
			has_extension:wield_previous_weapon()
		end
	end

	local unit_owner = Managers.player:unit_owner(owner_unit)
	local var_4_17 = POSITION_LOOKUP[owner_unit]

	Managers.telemetry_events:player_used_item(unit_owner, self.item_name, var_4_17)
end
