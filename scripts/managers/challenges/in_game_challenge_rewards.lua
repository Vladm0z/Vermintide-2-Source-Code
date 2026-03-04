-- chunkname: @scripts/managers/challenges/in_game_challenge_rewards.lua

require("scripts/managers/challenges/boon_reactivation_rules")
require("scripts/managers/challenges/pickup_spawn_type")

InGameChallengeRewards = InGameChallengeRewards or {}
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

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	if BuffUtils.get_buff_template(arg_1_1, "adventure") then
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

	local var_1_0 = arg_1_0 .. "_improved"
	local var_1_1 = arg_1_1 .. "_improved"

	if InGameChallengeRewards[var_1_0] then
		if BuffUtils.get_buff_template(var_1_1, "adventure") then
			InGameChallengeRewards[var_1_0].description_values = {
				{
					value_type = "percent",
					value_fmt = "%+d%%",
					value = BuffUtils.get_buff_template(var_1_1, "adventure").buffs[1].multiplier
				}
			}
		else
			InGameChallengeRewards[var_1_0].description_values = {}
		end
	end
end

var_0_0("markus_questing_knight_passive_cooldown_reduction", "markus_questing_knight_passive_cooldown_reduction")
var_0_0("markus_questing_knight_passive_attack_speed", "markus_questing_knight_passive_attack_speed")
var_0_0("markus_questing_knight_passive_power_level", "markus_questing_knight_passive_power_level")
var_0_0("markus_questing_knight_passive_damage_taken", "markus_questing_knight_passive_damage_taken")

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_1 = iter_0_1.ingame_challenge_rewards_description

	if var_0_1 then
		for iter_0_2, iter_0_3 in pairs(var_0_1) do
			var_0_0(iter_0_2, iter_0_3)
		end
	end
end

InGameChallengeRewardTypes = {
	buff = function (arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = Managers.state.entity:system("buff_system")
		local var_2_1 = arg_2_0.buffs
		local var_2_2 = arg_2_0.server_controlled
		local var_2_3 = {}

		for iter_2_0 = 1, #arg_2_1 do
			local var_2_4 = arg_2_1[iter_2_0]

			if var_2_4 and Unit.alive(var_2_4) then
				local var_2_5 = {}

				for iter_2_1 = 1, #var_2_1 do
					var_2_5[iter_2_1] = var_2_0:add_buff(var_2_4, var_2_1[iter_2_1], var_2_4, var_2_2)
				end

				var_2_3[var_2_4] = var_2_5
			end
		end

		return var_2_3
	end,
	pickup = function (arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = arg_3_0.pickup_type
		local var_3_1 = Managers.state.network.network_transmit
		local var_3_2 = Managers.state.entity:system("pickup_system")

		for iter_3_0 = 1, #arg_3_1 do
			local var_3_3 = arg_3_1[iter_3_0]

			if var_3_3 and Unit.alive(var_3_3) then
				local var_3_4 = ScriptUnit.extension(var_3_3, "inventory_system")
				local var_3_5 = AllPickups[var_3_0]
				local var_3_6 = var_3_5.slot_name
				local var_3_7 = var_3_5.item_name
				local var_3_8 = var_3_4:get_slot_data(var_3_6)

				if arg_3_0.pickup_spawn_type ~= PickupSpawnType.Replace and (var_3_8 or arg_3_0.pickup_spawn_type == PickupSpawnType.AlwaysDrop) then
					if arg_3_0.pickup_spawn_type ~= PickupSpawnType.NeverDrop then
						local var_3_9 = POSITION_LOOKUP[var_3_3]

						var_3_2:buff_spawn_pickup(var_3_0, var_3_9, true)
					end
				else
					local var_3_10 = Managers.state.unit_storage:go_id(var_3_3)
					local var_3_11 = NetworkLookup.equipment_slots[var_3_6]
					local var_3_12 = NetworkLookup.item_names[var_3_7]
					local var_3_13 = NetworkLookup.weapon_skins["n/a"]
					local var_3_14 = Managers.player:owner(var_3_3)

					if var_3_14 and var_3_14.remote then
						var_3_1:send_rpc("rpc_add_inventory_slot_item", var_3_14.peer_id, var_3_10, var_3_11, var_3_12, var_3_13)
					else
						var_3_1:queue_local_rpc("rpc_add_inventory_slot_item", var_3_10, var_3_11, var_3_12, var_3_13)
					end
				end
			end
		end
	end,
	boon = function (arg_4_0, arg_4_1, arg_4_2)
		if Managers.player:player_from_unique_id(arg_4_2) then
			Managers.boon:add_boon(arg_4_2, arg_4_0.reward_id, arg_4_0.consume_type, arg_4_0.consume_value, arg_4_0.reactivation_rule)
		end
	end
}

DLCUtils.merge("ingame_challenge_reward_types", InGameChallengeRewardTypes)

InGameChallengeRewardRevokeTypes = {
	buff = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if not arg_5_0.server_controlled then
			return
		end

		local var_5_0 = Managers.state.entity:system("buff_system")

		for iter_5_0 = 1, #arg_5_1 do
			local var_5_1 = arg_5_1[iter_5_0]
			local var_5_2 = arg_5_3[var_5_1]

			if var_5_1 and Unit.alive(var_5_1) and var_5_2 then
				for iter_5_1 = 1, #var_5_2 do
					var_5_0:remove_server_controlled_buff(var_5_1, var_5_2[iter_5_1])
				end
			end
		end
	end
}

DLCUtils.merge("ingame_challenge_revoke_types", InGameChallengeRewardRevokeTypes)

local var_0_2 = {}

InGameChallengeRewardTargets = {
	owner = function (arg_6_0)
		local var_6_0 = Managers.player:player_from_unique_id(arg_6_0)

		if var_6_0 then
			return {
				var_6_0.player_unit
			}
		end

		return var_0_2
	end,
	party = function (arg_7_0)
		local var_7_0 = Managers.party
		local var_7_1 = var_7_0:get_status_from_unique_id(arg_7_0)
		local var_7_2 = var_7_1 and var_7_0:get_players_in_party(var_7_1.party_id)

		if var_7_2 then
			local var_7_3 = {}
			local var_7_4 = 0

			for iter_7_0 = 1, #var_7_2 do
				local var_7_5 = var_7_2[iter_7_0].player
				local var_7_6 = var_7_5 and var_7_5.player_unit

				if var_7_6 then
					var_7_4 = var_7_4 + 1
					var_7_3[var_7_4] = var_7_6
				end
			end

			return var_7_3
		end

		return var_0_2
	end
}

DLCUtils.merge("ingame_challenge_revoke_targets", InGameChallengeRewardTargets)
