-- chunkname: @scripts/unit_extensions/weapons/actions/action_potion.lua

ActionPotion = class(ActionPotion, ActionBase)

ActionPotion.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionPotion.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end
end

ActionPotion.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionPotion.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
end

ActionPotion.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionPotion.finish = function (self, arg_4_1)
	-- function 4
	if arg_4_1 ~= "action_complete" then
		return
	end

	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local buff_template = current_action.buff_template
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local has_extension = ScriptUnit.has_extension(owner_unit, "career_system")
	local has_buff_perk = extension:has_buff_perk("cooldown_reduction_override")

	has_buff_perk = not has_buff_perk and buff_template == "cooldown_reduction_potion"

	local has_buff_type = extension:has_buff_type("trait_ring_potion_spread")

	has_buff_type = has_buff_type or extension:has_buff_type("weave_trait_ring_potion_spread")

	local tbl = {
		owner_unit
	}
	local TrinketSpreadDistance = TrinketSpreadDistance
	local var_4_9

	if not has_buff_type then
		local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[owner_unit].PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local var_4_12 = POSITION_LOOKUP[owner_unit]

		for i = 1, count do
			local var_4_13 = PLAYER_AND_BOT_UNITS[i]

			if not (not Unit.alive(var_4_13) and var_4_13 == owner_unit) then
				local var_4_14 = POSITION_LOOKUP[var_4_13]
				local distance = Vector3.distance(var_4_12, var_4_14)

				if distance <= TrinketSpreadDistance then
					TrinketSpreadDistance = distance
					var_4_9 = var_4_13
				end
			end
		end
	end

	if not var_4_9 then
		tbl[#tbl + 1] = var_4_9
	end

	local str = buff_template .. "_increased"

	if not extension:has_buff_perk("potion_duration") and not BuffUtils.get_buff_template(str) then
		buff_template = str
	end

	local count_2 = #tbl
	local network = Managers.state.network
	local var_4_19 = NetworkLookup.buff_templates[buff_template]
	local unit_game_object_id = network:unit_game_object_id(owner_unit)

	Managers.razer_chroma:play_animation(current_action.buff_template, false, RAZER_ADD_ANIMATION_TYPE.REPLACE)

	if not (extension:has_buff_type("trait_ring_all_potions") or extension:has_buff_type("weave_trait_ring_all_potions")) then
		for j = 1, count_2 do
			local var_4_21 = tbl[j]
			local unit_game_object_id_2 = network:unit_game_object_id(var_4_21)
			local extension_2 = ScriptUnit.extension(var_4_21, "buff_system")

			if not has_buff_perk and not has_extension then
				has_extension:set_activated_ability_cooldown_unpaused()
				has_extension:reduce_activated_ability_cooldown_percent(1)
			end

			if not self.is_server then
				extension_2:add_buff(buff_template)
				network.network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id_2, var_4_19, unit_game_object_id, 0, false)
			else
				network.network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id_2, var_4_19, unit_game_object_id, 0, true)
			end
		end
	else
		local tbl_2 = {
			"speed_boost_potion_reduced",
			"damage_boost_potion_reduced",
			"cooldown_reduction_potion_reduced"
		}

		if not has_buff_perk and not has_extension then
			has_extension:set_activated_ability_cooldown_unpaused()
			has_extension:reduce_activated_ability_cooldown_percent(0.5)
		end

		for k = 1, #tbl_2 do
			local var_4_25 = NetworkLookup.buff_templates[tbl_2[k]]

			if not self.is_server then
				extension:add_buff(tbl_2[k])
				network.network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_4_25, unit_game_object_id, 0, false)
			else
				network.network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_4_25, unit_game_object_id, 0, true)
			end
		end
	end

	if not self.ammo_extension then
		local ammo_usage = current_action.ammo_usage
		local apply_buffs_to_value, var_4_28 = extension:apply_buffs_to_value(0, "not_consume_potion")

		if not var_4_28 then
			self.ammo_extension:use_ammo(ammo_usage)
		else
			ScriptUnit.extension(owner_unit, "inventory_system"):wield_previous_weapon()

			if not extension:has_buff_type("trait_ring_not_consume_potion_damage") then
				DamageUtils.add_damage_network(self.owner_unit, self.owner_unit, 20, "torso", "buff", nil, Vector3(0, 0, 1), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end

	extension:trigger_procs("on_potion_consumed", self.item_name)

	local unit_owner = Managers.player:unit_owner(owner_unit)
	local var_4_30 = POSITION_LOOKUP[owner_unit]

	Managers.telemetry_events:player_used_item(unit_owner, self.item_name, var_4_30)
end
