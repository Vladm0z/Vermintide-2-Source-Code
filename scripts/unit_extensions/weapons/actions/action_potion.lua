-- chunkname: @scripts/unit_extensions/weapons/actions/action_potion.lua

ActionPotion = class(ActionPotion, ActionBase)

function ActionPotion.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionPotion.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end
end

function ActionPotion.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionPotion.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1
end

function ActionPotion.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

function ActionPotion.finish(arg_4_0, arg_4_1)
	if arg_4_1 ~= "action_complete" then
		return
	end

	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = var_4_0.buff_template
	local var_4_3 = ScriptUnit.extension(var_4_1, "buff_system")
	local var_4_4 = ScriptUnit.has_extension(var_4_1, "career_system")
	local var_4_5 = var_4_3:has_buff_perk("cooldown_reduction_override") and var_4_2 == "cooldown_reduction_potion"
	local var_4_6 = var_4_3:has_buff_type("trait_ring_potion_spread") or var_4_3:has_buff_type("weave_trait_ring_potion_spread")
	local var_4_7 = {
		var_4_1
	}
	local var_4_8 = TrinketSpreadDistance
	local var_4_9

	if var_4_6 then
		local var_4_10 = Managers.state.side.side_by_unit[var_4_1].PLAYER_AND_BOT_UNITS
		local var_4_11 = #var_4_10
		local var_4_12 = POSITION_LOOKUP[var_4_1]

		for iter_4_0 = 1, var_4_11 do
			local var_4_13 = var_4_10[iter_4_0]

			if Unit.alive(var_4_13) and var_4_13 ~= var_4_1 then
				local var_4_14 = POSITION_LOOKUP[var_4_13]
				local var_4_15 = Vector3.distance(var_4_12, var_4_14)

				if var_4_15 <= var_4_8 then
					var_4_8 = var_4_15
					var_4_9 = var_4_13
				end
			end
		end
	end

	if var_4_9 then
		var_4_7[#var_4_7 + 1] = var_4_9
	end

	local var_4_16 = var_4_2 .. "_increased"

	if var_4_3:has_buff_perk("potion_duration") and BuffUtils.get_buff_template(var_4_16) then
		var_4_2 = var_4_16
	end

	local var_4_17 = #var_4_7
	local var_4_18 = Managers.state.network
	local var_4_19 = NetworkLookup.buff_templates[var_4_2]
	local var_4_20 = var_4_18:unit_game_object_id(var_4_1)

	Managers.razer_chroma:play_animation(var_4_0.buff_template, false, RAZER_ADD_ANIMATION_TYPE.REPLACE)

	if not var_4_3:has_buff_type("trait_ring_all_potions") and not var_4_3:has_buff_type("weave_trait_ring_all_potions") then
		for iter_4_1 = 1, var_4_17 do
			local var_4_21 = var_4_7[iter_4_1]
			local var_4_22 = var_4_18:unit_game_object_id(var_4_21)
			local var_4_23 = ScriptUnit.extension(var_4_21, "buff_system")

			if var_4_5 and var_4_4 then
				var_4_4:set_activated_ability_cooldown_unpaused()
				var_4_4:reduce_activated_ability_cooldown_percent(1)
			end

			if arg_4_0.is_server then
				var_4_23:add_buff(var_4_2)
				var_4_18.network_transmit:send_rpc_clients("rpc_add_buff", var_4_22, var_4_19, var_4_20, 0, false)
			else
				var_4_18.network_transmit:send_rpc_server("rpc_add_buff", var_4_22, var_4_19, var_4_20, 0, true)
			end
		end
	else
		local var_4_24 = {
			"speed_boost_potion_reduced",
			"damage_boost_potion_reduced",
			"cooldown_reduction_potion_reduced"
		}

		if var_4_5 and var_4_4 then
			var_4_4:set_activated_ability_cooldown_unpaused()
			var_4_4:reduce_activated_ability_cooldown_percent(0.5)
		end

		for iter_4_2 = 1, #var_4_24 do
			local var_4_25 = NetworkLookup.buff_templates[var_4_24[iter_4_2]]

			if arg_4_0.is_server then
				var_4_3:add_buff(var_4_24[iter_4_2])
				var_4_18.network_transmit:send_rpc_clients("rpc_add_buff", var_4_20, var_4_25, var_4_20, 0, false)
			else
				var_4_18.network_transmit:send_rpc_server("rpc_add_buff", var_4_20, var_4_25, var_4_20, 0, true)
			end
		end
	end

	if arg_4_0.ammo_extension then
		local var_4_26 = var_4_0.ammo_usage
		local var_4_27, var_4_28 = var_4_3:apply_buffs_to_value(0, "not_consume_potion")

		if not var_4_28 then
			arg_4_0.ammo_extension:use_ammo(var_4_26)
		else
			ScriptUnit.extension(var_4_1, "inventory_system"):wield_previous_weapon()

			if var_4_3:has_buff_type("trait_ring_not_consume_potion_damage") then
				DamageUtils.add_damage_network(arg_4_0.owner_unit, arg_4_0.owner_unit, 20, "torso", "buff", nil, Vector3(0, 0, 1), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end

	var_4_3:trigger_procs("on_potion_consumed", arg_4_0.item_name)

	local var_4_29 = Managers.player:unit_owner(var_4_1)
	local var_4_30 = POSITION_LOOKUP[var_4_1]

	Managers.telemetry_events:player_used_item(var_4_29, arg_4_0.item_name, var_4_30)
end
