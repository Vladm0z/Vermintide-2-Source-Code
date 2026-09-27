-- chunkname: @scripts/managers/challenges/in_game_challenge_rewards.lua

require("scripts/managers/challenges/boon_reactivation_rules")
require("scripts/managers/challenges/pickup_spawn_type")

local InGameChallengeRewards = InGameChallengeRewards

InGameChallengeRewards = InGameChallengeRewards or {}
InGameChallengeRewards = InGameChallengeRewards
InGameChallengeRewards.test_buff = {
	target = "party",
	type = "buff",
	buffs = {
		"twitch_speed_boost"
	}
}
InGameChallengeRewards.test_pickup = {
	pickup_type = "damage_boost_potion",
	target = "party",
	type = "pickup",
	pickup_spawn_type = PickupSpawnType.DropIfFull
}
InGameChallengeRewards.markus_questing_knight_passive_cooldown_reduction_buff = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_cooldown_reduction"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_cooldown_reduction_buff_improved = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_cooldown_reduction_improved"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_cooldown_reduction_buff_vs = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_cooldown_reduction_vs"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_attack_speed_buff = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_attack_speed"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_attack_speed_buff_improved = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_attack_speed_improved"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_attack_speed_buff_vs = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_attack_speed_vs"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_power_level_buff = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_power_level"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_power_level_buff_improved = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_power_level_improved"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_power_level_buff_vs = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_power_level_vs"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_damage_taken_buff = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_damage_taken"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_damage_taken_buff_improved = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_damage_taken_improved"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_damage_taken_buff_vs = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_damage_taken_vs"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_health_regen_buff = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_health_regen"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_health_regen_buff_improved = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_health_regen_improved"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_health_regen_buff_vs = {
	server_controlled = true,
	target = "party",
	type = "buff",
	buffs = {
		"markus_questing_knight_passive_health_regen_vs"
	}
}
InGameChallengeRewards.markus_questing_knight_passive_speed_potion = {
	sound = "Play_hud_grail_knight_stamina",
	pickup_type = "speed_boost_potion",
	type = "pickup",
	icon = "icon_objective_potion",
	target = "owner",
	pickup_spawn_type = PickupSpawnType.DropIfFull
}
InGameChallengeRewards.markus_questing_knight_passive_strength_potion = {
	sound = "Play_hud_grail_knight_charge",
	pickup_type = "damage_boost_potion",
	type = "pickup",
	icon = "icon_objective_potion",
	target = "owner",
	pickup_spawn_type = PickupSpawnType.DropIfFull
}
InGameChallengeRewards.markus_questing_knight_passive_concentration_potion = {
	sound = "Play_hud_grail_knight_power",
	pickup_type = "cooldown_reduction_potion",
	type = "pickup",
	icon = "icon_objective_potion",
	target = "owner",
	pickup_spawn_type = PickupSpawnType.DropIfFull
}
InGameChallengeRewards.test_boon = {
	reward_id = "test_pickup",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	reactivation_rule = BoonReactivationRules.questing_knight
}
InGameChallengeRewards.markus_questing_knight_passive_cooldown_reduction = {
	reward_id = "markus_questing_knight_passive_cooldown_reduction_buff",
	sound = "Play_hud_grail_knight_stamina",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_cdr",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_cooldown_reduction_improved = {
	reward_id = "markus_questing_knight_passive_cooldown_reduction_buff_improved",
	sound = "Play_hud_grail_knight_stamina",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_cdr",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_cooldown_reduction_vs = {
	reward_id = "markus_questing_knight_passive_cooldown_reduction_buff_vs",
	sound = "Play_hud_grail_knight_stamina",
	type = "boon",
	consume_type = "round",
	icon = "icon_objective_cdr",
	target = "party",
	consume_value = 1,
	reactivation_rule = BoonReactivationRules.questing_knight
}
InGameChallengeRewards.markus_questing_knight_passive_attack_speed = {
	reward_id = "markus_questing_knight_passive_attack_speed_buff",
	sound = "Play_hud_grail_knight_attack",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_attack_speed",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_attack_speed_improved = {
	reward_id = "markus_questing_knight_passive_attack_speed_buff_improved",
	sound = "Play_hud_grail_knight_attack",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_attack_speed",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_attack_speed_vs = {
	reward_id = "markus_questing_knight_passive_attack_speed_buff_vs",
	sound = "Play_hud_grail_knight_attack",
	type = "boon",
	consume_type = "round",
	icon = "icon_objective_attack_speed",
	target = "party",
	consume_value = 1,
	reactivation_rule = BoonReactivationRules.questing_knight
}
InGameChallengeRewards.markus_questing_knight_passive_power_level = {
	reward_id = "markus_questing_knight_passive_power_level_buff",
	sound = "Play_hud_grail_knight_power",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_power_level",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_power_level_improved = {
	reward_id = "markus_questing_knight_passive_power_level_buff_improved",
	sound = "Play_hud_grail_knight_power",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_power_level",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_power_level_vs = {
	reward_id = "markus_questing_knight_passive_power_level_buff_vs",
	sound = "Play_hud_grail_knight_power",
	type = "boon",
	consume_type = "round",
	icon = "icon_objective_power_level",
	target = "party",
	consume_value = 1,
	reactivation_rule = BoonReactivationRules.questing_knight
}
InGameChallengeRewards.markus_questing_knight_passive_damage_taken = {
	reward_id = "markus_questing_knight_passive_damage_taken_buff",
	sound = "Play_hud_grail_knight_tank",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_damage_taken",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_damage_taken_improved = {
	reward_id = "markus_questing_knight_passive_damage_taken_buff_improved",
	sound = "Play_hud_grail_knight_tank",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_damage_taken",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_damage_taken_vs = {
	reward_id = "markus_questing_knight_passive_damage_taken_buff_vs",
	sound = "Play_hud_grail_knight_tank",
	type = "boon",
	consume_type = "round",
	icon = "icon_objective_damage_taken",
	target = "party",
	consume_value = 1,
	reactivation_rule = BoonReactivationRules.questing_knight
}
InGameChallengeRewards.markus_questing_knight_passive_health_regen = {
	reward_id = "markus_questing_knight_passive_health_regen_buff",
	sound = "Play_hud_grail_knight_heal",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_health_regen",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_health_regen_improved = {
	reward_id = "markus_questing_knight_passive_health_regen_buff_improved",
	sound = "Play_hud_grail_knight_heal",
	type = "boon",
	consume_type = "venture",
	target = "party",
	consume_value = 1,
	icon = "icon_objective_health_regen",
	reactivation_rule = BoonReactivationRules.questing_knight,
	mechanism_overrides = {
		versus = {
			consume_type = "round"
		}
	}
}
InGameChallengeRewards.markus_questing_knight_passive_health_regen_vs = {
	reward_id = "markus_questing_knight_passive_health_regen_buff_vs",
	sound = "Play_hud_grail_knight_heal",
	type = "boon",
	consume_type = "round",
	icon = "icon_objective_health_regen",
	target = "party",
	consume_value = 1,
	reactivation_rule = BoonReactivationRules.questing_knight
}

DLCUtils.merge("ingame_challenge_rewards", InGameChallengeRewards)

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	if not BuffUtils.get_buff_template(arg_1_1, "adventure") then
		InGameChallengeRewards[arg_1_0].description_values = {
			{
				value_type = "percent",
				value_fmt = "%+d%%",
				value = BuffUtils.get_buff_template(arg_1_1, "adventure").buffs[1].multiplier
			}
		}
	else
		InGameChallengeRewards[arg_1_0].description_values = {}
	end

	local str = arg_1_0 .. "_improved"
	local str_2 = arg_1_1 .. "_improved"

	if not InGameChallengeRewards[str] then
		if not BuffUtils.get_buff_template(str_2, "adventure") then
			InGameChallengeRewards[str].description_values = {
				{
					value_type = "percent",
					value_fmt = "%+d%%",
					value = BuffUtils.get_buff_template(str_2, "adventure").buffs[1].multiplier
				}
			}
		else
			InGameChallengeRewards[str].description_values = {}
		end
	end
end

fn("markus_questing_knight_passive_cooldown_reduction", "markus_questing_knight_passive_cooldown_reduction")
fn("markus_questing_knight_passive_attack_speed", "markus_questing_knight_passive_attack_speed")
fn("markus_questing_knight_passive_power_level", "markus_questing_knight_passive_power_level")
fn("markus_questing_knight_passive_damage_taken", "markus_questing_knight_passive_damage_taken")

for k, v in pairs(DLCSettings) do
	local ingame_challenge_rewards_description = v.ingame_challenge_rewards_description

	if not ingame_challenge_rewards_description then
		for k_2, v_2 in pairs(ingame_challenge_rewards_description) do
			fn(k_2, v_2)
		end
	end
end

InGameChallengeRewardTypes = {
	buff = function (self, arg_2_1, arg_2_2)
		-- function 2
		local system = Managers.state.entity:system("buff_system")
		local buffs = self.buffs
		local server_controlled = self.server_controlled
		local tbl = {}

		for i = 1, #arg_2_1 do
			local var_2_4 = arg_2_1[i]

			if not var_2_4 and not Unit.alive(var_2_4) then
				local tbl_2 = {}

				for j = 1, #buffs do
					tbl_2[j] = system:add_buff(var_2_4, buffs[j], var_2_4, server_controlled)
				end

				tbl[var_2_4] = tbl_2
			end
		end

		return tbl
	end,
	pickup = function (self, arg_3_1, arg_3_2)
		-- function 3
		local pickup_type = self.pickup_type
		local network_transmit = Managers.state.network.network_transmit
		local system = Managers.state.entity:system("pickup_system")

		for i = 1, #arg_3_1 do
			local var_3_3 = arg_3_1[i]

			if not var_3_3 and not Unit.alive(var_3_3) then
				local extension = ScriptUnit.extension(var_3_3, "inventory_system")
				local var_3_5 = AllPickups[pickup_type]
				local slot_name = var_3_5.slot_name
				local item_name = var_3_5.item_name
				local get_slot_data = extension:get_slot_data(slot_name)

				if not (self.pickup_spawn_type == PickupSpawnType.Replace or get_slot_data or self.pickup_spawn_type ~= PickupSpawnType.AlwaysDrop) then
					if self.pickup_spawn_type ~= PickupSpawnType.NeverDrop then
						local var_3_9 = POSITION_LOOKUP[var_3_3]

						system:buff_spawn_pickup(pickup_type, var_3_9, true)
					end
				else
					local go_id = Managers.state.unit_storage:go_id(var_3_3)
					local var_3_11 = NetworkLookup.equipment_slots[slot_name]
					local var_3_12 = NetworkLookup.item_names[item_name]
					local var_3_13 = NetworkLookup.weapon_skins["n/a"]
					local owner = Managers.player:owner(var_3_3)

					if not (not owner and owner.remote) then
						network_transmit:send_rpc("rpc_add_inventory_slot_item", owner.peer_id, go_id, var_3_11, var_3_12, var_3_13)
					else
						network_transmit:queue_local_rpc("rpc_add_inventory_slot_item", go_id, var_3_11, var_3_12, var_3_13)
					end
				end
			end
		end
	end,
	boon = function (self, arg_4_1, arg_4_2)
		-- function 4
		if not Managers.player:player_from_unique_id(arg_4_2) then
			Managers.boon:add_boon(arg_4_2, self.reward_id, self.consume_type, self.consume_value, self.reactivation_rule)
		end
	end
}

DLCUtils.merge("ingame_challenge_reward_types", InGameChallengeRewardTypes)

InGameChallengeRewardRevokeTypes = {
	buff = function (self, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		if not self.server_controlled then
			return
		end

		local system = Managers.state.entity:system("buff_system")

		for i = 1, #arg_5_1 do
			local var_5_1 = arg_5_1[i]
			local var_5_2 = arg_5_3[var_5_1]

			if not var_5_1 and not Unit.alive(var_5_1) and not var_5_2 then
				for j = 1, #var_5_2 do
					system:remove_server_controlled_buff(var_5_1, var_5_2[j])
				end
			end
		end
	end
}

DLCUtils.merge("ingame_challenge_revoke_types", InGameChallengeRewardRevokeTypes)

local tbl = {}

InGameChallengeRewardTargets = {
	owner = function (arg_6_0)
		-- function 6
		local player_from_unique_id = Managers.player:player_from_unique_id(arg_6_0)

		if not player_from_unique_id then
			return {
				player_from_unique_id.player_unit
			}
		end

		return tbl
	end,
	party = function (arg_7_0)
		-- function 7
		local party = Managers.party
		local get_status_from_unique_id = party:get_status_from_unique_id(arg_7_0)
		local flag = not get_status_from_unique_id and party:get_players_in_party(get_status_from_unique_id.party_id)

		if not flag then
			local tbl_2 = {}
			local num = 0

			for i = 1, #flag do
				local player = flag[i].player
				local flag_2 = not player and player.player_unit

				if not flag_2 then
					num = num + 1
					tbl_2[num] = flag_2
				end
			end

			return tbl_2
		end

		return tbl
	end
}

DLCUtils.merge("ingame_challenge_revoke_targets", InGameChallengeRewardTargets)
