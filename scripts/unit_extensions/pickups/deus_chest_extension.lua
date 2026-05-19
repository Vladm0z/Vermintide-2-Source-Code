-- chunkname: @scripts/unit_extensions/pickups/deus_chest_extension.lua

require("scripts/managers/game_mode/mechanisms/deus_weapon_generation")
require("scripts/settings/dlcs/morris/rarity_settings")
require("scripts/utils/hash_utils")

local var_0_0 = {
	"rpc_deus_chest_looted"
}
local var_0_1 = 1
local var_0_2 = 10
local var_0_3 = 12
local var_0_4 = {
	default = {
		swap_melee = {
			"melee"
		},
		swap_ranged = {
			"ranged"
		}
	},
	dr_slayer = {
		swap_melee = {
			"melee"
		},
		swap_ranged = {
			"melee",
			"ranged"
		}
	},
	es_questingknight = {
		swap_melee = {
			"melee"
		},
		swap_ranged = {
			"melee"
		}
	},
	wh_priest = {
		swap_melee = {
			"melee"
		},
		swap_ranged = {
			"melee"
		}
	}
}
local var_0_5 = {}
local var_0_6 = RaritySettings

for iter_0_0, iter_0_1 in pairs(var_0_6) do
	var_0_5[iter_0_0] = "lua_update_" .. iter_0_0
end

DeusChestExtension = class(DeusChestExtension, PickupUnitExtension)

function DeusChestExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	DeusChestExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._is_server = Managers.player.is_server
	arg_1_0._profile_index = 0
	arg_1_0._career_index = 0
	arg_1_0._animation_state = nil
	arg_1_0._sound_state = nil
	arg_1_0._sound_state_interact = nil
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0.world)

	arg_1_0:register_rpcs(arg_1_1.network_transmit.network_event_delegate)
end

function DeusChestExtension.game_object_initialized(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_0._is_server then
		local var_2_0 = arg_2_0._chest_type_override or arg_2_0._deus_run_controller:get_deus_weapon_chest_type()

		arg_2_0:_set_server_chest_type(var_2_0)
	end
end

function DeusChestExtension.extensions_ready(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	fassert(arg_3_0._deus_run_controller, "deus pickup unit can only be used in a deus run")

	arg_3_0._telemetry_data = {
		altar_type = "n/a",
		activated = false,
		currency_when_found = -1,
		level_count = arg_3_0._deus_run_controller:get_completed_level_count() + 1,
		run_id = arg_3_0._deus_run_controller:get_run_id()
	}
end

function DeusChestExtension.destroy(arg_4_0)
	if arg_4_0._telemetry_data.currency_when_found ~= -1 then
		Managers.telemetry_events:deus_altar_passed(arg_4_0._telemetry_data)
	end

	arg_4_0:unregister_rpcs()
end

function DeusChestExtension.register_rpcs(arg_5_0, arg_5_1)
	arg_5_1:register(arg_5_0, unpack(var_0_0))

	arg_5_0._network_event_delegate = arg_5_1
end

function DeusChestExtension.unregister_rpcs(arg_6_0)
	arg_6_0._network_event_delegate:unregister(arg_6_0)

	arg_6_0._network_event_delegate = nil
end

function DeusChestExtension.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = Managers.player:local_player()
	local var_7_1 = var_7_0.player_unit

	if not arg_7_0._inventory_extension or arg_7_0._player_unit ~= var_7_1 then
		arg_7_0._inventory_extension = ScriptUnit.has_extension(var_7_1, "inventory_system")
		arg_7_0._player = var_7_0
		arg_7_0._player_unit = var_7_1
	end

	if not var_7_1 or not ALIVE[var_7_1] then
		return
	end

	local var_7_2 = arg_7_0._go_id or Managers.state.unit_storage:go_id(arg_7_0.unit)
	local var_7_3 = arg_7_0._deus_run_controller
	local var_7_4 = var_7_3:get_own_peer_id()
	local var_7_5, var_7_6 = var_7_3:get_player_profile(var_7_4, var_0_1)

	if var_7_2 and (var_7_5 ~= arg_7_0._profile_index or var_7_6 ~= arg_7_0._career_index) then
		local var_7_7 = arg_7_0:_get_server_chest_type()

		if var_7_7 then
			local var_7_8 = arg_7_0._deus_run_controller:get_current_node()
			local var_7_9 = HashUtils.fnv32_hash(var_7_2 .. "_" .. var_7_8.weapon_pickup_seed)
			local var_7_10 = arg_7_0:_setup_rarity(var_7_9, var_7_7)

			Unit.flow_event(arg_7_0.unit, "lua_update_" .. var_7_7)

			if var_7_7 == DEUS_CHEST_TYPES.power_up then
				arg_7_0:_generate_stored_power_up(var_7_9)
				Unit.set_data(arg_7_0.unit, "interaction_data", "hud_description", "deus_weapon_chest_power_up_hud_desc")
				Unit.set_data(arg_7_0.unit, "interaction_data", "hud_action", "deus_weapon_chest_power_up_action")
			elseif var_7_7 == DEUS_CHEST_TYPES.upgrade then
				Unit.set_data(arg_7_0.unit, "interaction_data", "hud_description", "deus_weapon_chest_upgrade_hud_desc")
				Unit.set_data(arg_7_0.unit, "interaction_data", "hud_action", "deus_weapon_chest_upgrade_action")
			else
				local var_7_11 = SPProfiles[var_7_5]
				local var_7_12 = var_7_11 and var_7_11.careers[var_7_6].name
				local var_7_13 = (var_0_4[var_7_12] or var_0_4.default)[var_7_7]

				arg_7_0:_generate_stored_weapon(var_7_13, var_7_10, var_7_2, var_7_5, var_7_6)

				local var_7_14

				if var_7_7 == DEUS_CHEST_TYPES.swap_melee then
					var_7_14 = "melee"
				elseif var_7_7 == DEUS_CHEST_TYPES.swap_ranged then
					var_7_14 = "ranged"
				end

				Unit.set_data(arg_7_0.unit, "interaction_data", "hud_description", "deus_weapon_chest_swap_" .. var_7_14 .. "_hud_desc")
				Unit.set_data(arg_7_0.unit, "interaction_data", "hud_action", "deus_weapon_chest_swap_" .. var_7_14 .. "_action")
			end

			local var_7_15 = Managers.state.network:game()
			local var_7_16 = GameSession.game_object_field(var_7_15, var_7_2, "collected_by_peers")
			local var_7_17 = var_7_3:get_own_peer_id()
			local var_7_18 = arg_7_0._is_purchased
			local var_7_19 = not arg_7_0._stored_purchase and var_7_7 ~= DEUS_CHEST_TYPES.upgrade or table.contains(var_7_16, var_7_17)

			if var_7_18 ~= var_7_19 and var_7_19 == true then
				arg_7_0._is_purchased = var_7_19
				arg_7_0._animation_state = "looted"

				Unit.flow_event(arg_7_0.unit, "lua_update_collected")
			end

			arg_7_0._profile_index = var_7_5
			arg_7_0._career_index = var_7_6
			arg_7_0._go_id = var_7_2
			arg_7_0._chest_type = var_7_7
		end
	end

	arg_7_0:update_upgrade_chest_color()
	arg_7_0:_update_chest_interaction_time()

	if arg_7_0._animation_state ~= "looted" then
		arg_7_0:_update_chest_animation_and_sound_state(arg_7_1)
	end

	arg_7_0:_update_telemetry(arg_7_1)
end

function DeusChestExtension._update_chest_interaction_time(arg_8_0)
	local var_8_0 = arg_8_0:can_be_unlocked() and 0.5 or 0

	if var_8_0 ~= arg_8_0._interaction_length then
		Unit.set_data(arg_8_0.unit, "interaction_data", "interaction_length", var_8_0)

		arg_8_0._interaction_length = var_8_0
	end
end

function DeusChestExtension.update_upgrade_chest_color(arg_9_0)
	if arg_9_0._chest_type ~= DEUS_CHEST_TYPES.upgrade then
		return
	end

	local var_9_0 = arg_9_0._rarity

	if not var_9_0 then
		return
	end

	if arg_9_0._is_purchased then
		return
	end

	local var_9_1 = arg_9_0:_get_wielded_weapon()

	if not var_9_1 then
		return
	end

	local var_9_2 = var_0_6[var_9_1.rarity].order
	local var_9_3 = var_0_6[var_9_0].order
	local var_9_4
	local var_9_5 = var_9_3 <= var_9_2 and "lua_interact_disabled" or var_0_5[var_9_0]

	if not arg_9_0._prev_update_upgrade_chest_color_event or arg_9_0._prev_update_upgrade_chest_color_event ~= var_9_5 then
		Unit.flow_event(arg_9_0.unit, var_9_5)

		arg_9_0._prev_update_upgrade_chest_color_event = var_9_5
	end
end

function DeusChestExtension.can_interact(arg_10_0)
	if arg_10_0._is_purchased then
		return false
	end

	local var_10_0 = arg_10_0._player_unit
	local var_10_1 = arg_10_0._inventory_extension

	if not var_10_0 or not ALIVE[var_10_0] or not var_10_1 then
		return false
	end

	if var_10_1:resyncing_loadout() then
		return false
	end

	return true
end

function DeusChestExtension.get_interact_hud_description(arg_11_0)
	if arg_11_0._is_purchased then
		return "deus_weapon_chest_already_picked_up_hud_desc"
	else
		return "deus_weapon_chest_hud_desc"
	end
end

function DeusChestExtension.get_purchase_cost(arg_12_0)
	local var_12_0 = arg_12_0._chest_type

	if var_12_0 == DEUS_CHEST_TYPES.upgrade then
		local var_12_1 = arg_12_0:_get_wielded_weapon().rarity

		return DeusCostSettings.deus_chest[var_12_0][var_12_1][arg_12_0._rarity]
	elseif var_12_0 == DEUS_CHEST_TYPES.swap_melee then
		local var_12_2 = arg_12_0._deus_run_controller:get_own_loadout().rarity

		return DeusCostSettings.deus_chest[var_12_0][var_12_2][arg_12_0._rarity]
	elseif var_12_0 == DEUS_CHEST_TYPES.swap_ranged then
		local var_12_3, var_12_4 = arg_12_0._deus_run_controller:get_own_loadout()
		local var_12_5 = var_12_4.rarity

		return DeusCostSettings.deus_chest[var_12_0][var_12_5][arg_12_0._rarity]
	elseif var_12_0 == DEUS_CHEST_TYPES.power_up then
		return DeusCostSettings.deus_chest.power_up
	end

	return math.huge
end

function DeusChestExtension.purchase(arg_13_0)
	local var_13_0 = arg_13_0:get_purchase_cost()

	arg_13_0._deus_run_controller:purchase_chest(arg_13_0._rarity, arg_13_0._chest_type, var_13_0)

	arg_13_0._is_purchased = true

	Unit.flow_event(arg_13_0.unit, "lua_update_collected")

	arg_13_0._animation_state = "looted"

	if not arg_13_0._is_server then
		local var_13_1 = Managers.state.unit_storage:go_id(arg_13_0.unit)

		Managers.state.network.network_transmit:send_rpc_server("rpc_deus_chest_looted", var_13_1)
	end
end

function DeusChestExtension._get_wielded_weapon(arg_14_0)
	local var_14_0 = arg_14_0._inventory_extension

	if not var_14_0 then
		return
	end

	local var_14_1, var_14_2 = arg_14_0._deus_run_controller:get_own_loadout()
	local var_14_3 = var_14_0:get_wielded_slot_name() == "slot_melee" and "slot_melee" or "slot_ranged"

	return var_14_3 == "slot_melee" and var_14_1 or var_14_2, var_14_3
end

function DeusChestExtension.on_interact(arg_15_0)
	if arg_15_0._chest_type == DEUS_CHEST_TYPES.upgrade then
		local var_15_0, var_15_1 = arg_15_0:_get_wielded_weapon()

		if var_15_0 and var_15_0 ~= arg_15_0._previous_wielded_weapon then
			arg_15_0:_generate_upgraded_weapon(var_15_0, var_15_1, arg_15_0._rarity, arg_15_0._go_id, arg_15_0._profile_index, arg_15_0._career_index)

			arg_15_0._previous_wielded_weapon = var_15_0
		end
	end
end

function DeusChestExtension._setup_rarity(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_2 == DEUS_CHEST_TYPES.power_up then
		return nil
	else
		local var_16_0 = arg_16_0._deus_run_controller:get_current_node()
		local var_16_1 = arg_16_0._deus_run_controller:get_run_difficulty()
		local var_16_2 = var_16_0.run_progress

		arg_16_0._rarity = DeusWeaponGeneration.get_random_rarity(var_16_1, var_16_2, arg_16_1)

		Unit.flow_event(arg_16_0.unit, "lua_update_" .. arg_16_0._rarity)

		return arg_16_0._rarity
	end
end

function DeusChestExtension.get_rarity(arg_17_0)
	if arg_17_0._chest_type == DEUS_CHEST_TYPES.power_up then
		return arg_17_0._stored_purchase.rarity
	else
		return arg_17_0._rarity
	end
end

function DeusChestExtension.get_stored_purchase(arg_18_0)
	if arg_18_0._chest_type == DEUS_CHEST_TYPES.power_up then
		local var_18_0 = arg_18_0._deus_run_controller
		local var_18_1 = var_18_0:get_own_peer_id()

		if arg_18_0._stored_purchase then
			local var_18_2 = arg_18_0._stored_purchase.name

			if var_18_0:reached_max_power_ups(var_18_1, var_18_2) then
				local var_18_3 = arg_18_0._go_id or Managers.state.unit_storage:go_id(arg_18_0.unit)
				local var_18_4 = arg_18_0._deus_run_controller:get_current_node()
				local var_18_5 = HashUtils.fnv32_hash(var_18_3 .. "_" .. var_18_4.weapon_pickup_seed)

				arg_18_0:_generate_stored_power_up(var_18_5)
			end
		end
	end

	return arg_18_0._stored_purchase
end

function DeusChestExtension.get_chest_type(arg_19_0)
	return arg_19_0._chest_type
end

function DeusChestExtension._generate_stored_power_up(arg_20_0, arg_20_1)
	arg_20_0._stored_purchase = arg_20_0._deus_run_controller:generate_random_power_ups(DeusPowerUpSettings.weapon_chest_choice_amount, DeusPowerUpAvailabilityTypes.weapon_chest, arg_20_1)[1]
end

function DeusChestExtension._generate_stored_weapon(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	local var_21_0 = arg_21_0._deus_run_controller
	local var_21_1 = var_21_0:get_current_node()
	local var_21_2 = var_21_1.run_progress
	local var_21_3 = var_21_0:get_run_difficulty()
	local var_21_4 = var_21_0:get_weapon_pool()
	local var_21_5 = HashUtils.fnv32_hash(string.format("%s_%s_%s_%s_%s", arg_21_4, arg_21_5, var_21_1.weapon_pickup_seed, arg_21_3, 1))
	local var_21_6 = table.contains(arg_21_1, "melee") and 1 or 0
	local var_21_7 = table.contains(arg_21_1, "ranged") and 1 or 0
	local var_21_8 = DeusWeaponGeneration.generate_weapon(var_21_3, var_21_2, arg_21_2, var_21_5, var_21_4, var_21_6, var_21_7)

	var_21_0:remove_weapon_from_pool(arg_21_2, var_21_8.deus_item_key)

	local var_21_9 = Managers.backend:get_interface("deus")

	var_21_9:grant_deus_weapon(var_21_8)
	var_21_9:refresh_deus_weapons_in_items_backend()

	arg_21_0._stored_purchase = var_21_8
end

function DeusChestExtension._generate_upgraded_weapon(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	local var_22_0 = arg_22_0._deus_run_controller
	local var_22_1 = var_22_0:get_current_node()
	local var_22_2 = var_22_1.run_progress
	local var_22_3 = var_22_0:get_run_difficulty()
	local var_22_4 = HashUtils.fnv32_hash(string.format("%s_%s_%s_%s_%s", arg_22_5, arg_22_6, var_22_1.weapon_pickup_seed, arg_22_4, 1))
	local var_22_5 = DeusWeaponGeneration.upgrade_item(arg_22_1, var_22_3, var_22_2, arg_22_3, var_22_4)

	var_22_5.preferred_slot_name = arg_22_2

	local var_22_6 = Managers.backend:get_interface("deus")

	var_22_6:grant_deus_weapon(var_22_5)
	var_22_6:refresh_deus_weapons_in_items_backend()

	arg_22_0._stored_purchase = var_22_5

	Unit.set_data(arg_22_0.unit, "interaction_data", "hud_description", "deus_weapon_chest_upgrade_hud_desc")
	Unit.set_data(arg_22_0.unit, "interaction_data", "hud_action", "deus_weapon_chest_upgrade_action")
end

function DeusChestExtension._get_server_chest_type(arg_23_0)
	local var_23_0 = Managers.state.network:game()
	local var_23_1 = Managers.state.unit_storage:go_id(arg_23_0.unit)

	if not var_23_0 or not var_23_1 then
		return nil
	end

	local var_23_2 = GameSession.game_object_field(var_23_0, var_23_1, "server_chest_type")

	return var_23_2 ~= 0 and NetworkLookup.deus_chest_types[var_23_2] or nil
end

function DeusChestExtension._set_server_chest_type(arg_24_0, arg_24_1)
	local var_24_0 = Managers.state.network:game()
	local var_24_1 = Managers.state.unit_storage:go_id(arg_24_0.unit)

	fassert(var_24_0 and var_24_1, "setting state without network setup done")

	local var_24_2 = NetworkLookup.deus_chest_types[arg_24_1]

	GameSession.set_game_object_field(var_24_0, var_24_1, "server_chest_type", var_24_2)
end

local var_0_7 = {
	unlock_chest = "hud_morris_weapon_chest_unlock",
	unlock_power_up = "morris_reliquarys_get_boon",
	close_chest_ui = "hud_morris_weapon_chest_close",
	button_hover = "hud_morris_hover",
	exchange_weapon = "hud_morris_weapon_chest_change_weapon",
	open_chest_ui = "hud_morris_weapon_chest_open",
	unlock_chest_rarity_sounds = {
		common = "play_hud_rewards_tier1",
		plentiful = "play_hud_rewards_tier1",
		exotic = "play_hud_rewards_tier3",
		rare = "play_hud_rewards_tier2",
		unique = "play_hud_rewards_tier4"
	}
}

function DeusChestExtension.can_be_unlocked(arg_25_0)
	if not arg_25_0:can_interact() then
		return false
	end

	if not arg_25_0._stored_purchase and arg_25_0._chest_type ~= DEUS_CHEST_TYPES.upgrade then
		return false
	end

	local var_25_0 = arg_25_0._deus_run_controller:get_own_peer_id()
	local var_25_1 = arg_25_0._deus_run_controller:get_player_soft_currency(var_25_0)
	local var_25_2 = arg_25_0:get_purchase_cost() or math.huge
	local var_25_3 = script_data.unlock_all_deus_chests or var_25_2 <= var_25_1
	local var_25_4 = arg_25_0._chest_type

	if var_25_4 == DEUS_CHEST_TYPES.upgrade then
		local var_25_5 = arg_25_0:_get_wielded_weapon()

		if var_25_5 then
			local var_25_6 = var_0_6

			if var_25_6[var_25_5.rarity].order >= var_25_6[arg_25_0._rarity].order then
				var_25_3 = false
			end
		end
	end

	if not var_25_3 then
		return false
	end

	local var_25_7 = true

	if var_25_4 ~= DEUS_CHEST_TYPES.power_up then
		var_25_7 = Managers.state.network.profile_synchronizer:others_actually_ingame()
	end

	if not var_25_7 then
		return false
	end

	return true
end

function DeusChestExtension.open_chest(arg_26_0)
	local var_26_0 = arg_26_0._deus_run_controller

	arg_26_0._telemetry_data.currency_when_found = var_26_0:get_player_soft_currency(var_26_0:get_own_peer_id())
	arg_26_0._telemetry_data.activated = true

	if arg_26_0._chest_type == DEUS_CHEST_TYPES.power_up then
		local var_26_1 = arg_26_0._stored_purchase

		var_26_0:add_power_ups({
			var_26_1
		}, var_0_1, true)
		arg_26_0:_play_sound(var_0_7.unlock_power_up)
		arg_26_0:_post_chest_unlock(arg_26_0._stored_purchase)
	else
		if not arg_26_0._stored_purchase then
			local var_26_2, var_26_3 = arg_26_0:_get_wielded_weapon()

			arg_26_0:_generate_upgraded_weapon(var_26_2, var_26_3, arg_26_0._rarity, arg_26_0._go_id, arg_26_0._profile_index, arg_26_0._career_index)

			arg_26_0._previous_wielded_weapon = var_26_2
		end

		local var_26_4 = arg_26_0:get_rarity()
		local var_26_5 = var_0_7.unlock_chest_rarity_sounds[var_26_4]

		if var_26_5 then
			arg_26_0:_play_sound(var_26_5)
		end

		if arg_26_0._chest_type == DEUS_CHEST_TYPES.swap_ranged or arg_26_0._chest_type == DEUS_CHEST_TYPES.swap_melee then
			ScriptUnit.extension_input(arg_26_0._player_unit, "dialogue_system"):trigger_networked_dialogue_event("deus_using_a_weapon_shrine")
		end

		arg_26_0:_post_chest_unlock(arg_26_0._stored_purchase)
		arg_26_0:_equip_weapon(var_26_0, arg_26_0._stored_purchase)
		arg_26_0:_play_sound(var_0_7.exchange_weapon)
	end
end

function DeusChestExtension._equip_weapon(arg_27_0, arg_27_1, arg_27_2)
	print("[DeusChestExtension] equipped:")
	table.dump(arg_27_2, "deus_weapon")

	local var_27_0 = arg_27_2.backend_id
	local var_27_1 = arg_27_0._inventory_extension
	local var_27_2 = arg_27_0._profile_index
	local var_27_3 = SPProfiles[var_27_2]
	local var_27_4 = arg_27_0._career_index
	local var_27_5 = var_27_3.careers[var_27_4]
	local var_27_6 = var_27_5.name
	local var_27_7
	local var_27_8 = arg_27_0._chest_type
	local var_27_9 = var_27_8 == DEUS_CHEST_TYPES.swap_melee and "slot_melee" or var_27_8 == DEUS_CHEST_TYPES.swap_ranged and "slot_ranged" or arg_27_0:_get_best_slot_name(arg_27_2, var_27_8, var_27_5, var_27_1)

	BackendUtils.set_loadout_item(var_27_0, var_27_6, var_27_9)
	var_27_1:create_equipment_in_slot(var_27_9, var_27_0, 1)
	arg_27_1:save_loadout(arg_27_2, var_27_9)
end

function DeusChestExtension._get_best_slot_name(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0
	local var_28_1 = arg_28_1.data.slot_type
	local var_28_2 = InventorySettings.slots_by_slot_index

	for iter_28_0, iter_28_1 in pairs(var_28_2) do
		if var_28_1 == iter_28_1.type then
			var_28_0 = iter_28_1.name
		end
	end

	local var_28_3
	local var_28_4 = arg_28_4:equipment()
	local var_28_5 = var_28_4.wielded.backend_id

	for iter_28_2, iter_28_3 in pairs(var_28_4.slots) do
		if iter_28_3.item_data.backend_id == var_28_5 then
			var_28_3 = iter_28_3.id

			break
		end
	end

	if arg_28_2 == DEUS_CHEST_TYPES.upgrade then
		return arg_28_1.preferred_slot_name
	else
		local var_28_6 = arg_28_3.item_slot_types_by_slot_name[var_28_3]

		return var_28_6 and table.contains(var_28_6, var_28_1) and var_28_3 or var_28_0, var_28_1
	end
end

function DeusChestExtension._post_chest_unlock(arg_29_0, arg_29_1)
	arg_29_0:_play_sound(var_0_7.unlock_chest)
	arg_29_0:purchase()

	local var_29_0 = Managers.player:local_player()

	Managers.state.event:trigger("player_pickup_deus_weapon_chest", var_29_0)

	if arg_29_1 and arg_29_0._chest_type ~= DEUS_CHEST_TYPES.power_up then
		Managers.state.event:trigger("present_rewards", {
			{
				type = "deus_item_tooltip",
				backend_id = arg_29_1.backend_id
			}
		})
	end

	StatisticsUtil.register_open_shrine(arg_29_0._chest_type)
end

function DeusChestExtension._play_sound(arg_30_0, arg_30_1)
	WwiseWorld.trigger_event(arg_30_0._wwise_world, arg_30_1)
end

function DeusChestExtension._update_chest_animation_and_sound_state(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._player_unit
	local var_31_1 = POSITION_LOOKUP[var_31_0]
	local var_31_2 = POSITION_LOOKUP[arg_31_1]
	local var_31_3 = Vector3.distance_squared(var_31_1, var_31_2)
	local var_31_4 = ScriptUnit.extension(var_31_0, "interactor_system"):interactable_unit() == arg_31_1
	local var_31_5 = arg_31_0._animation_state
	local var_31_6 = arg_31_0._sound_state
	local var_31_7 = arg_31_0._sound_state_interact

	if not arg_31_0._stored_purchase and arg_31_0._chest_type ~= DEUS_CHEST_TYPES.upgrade then
		var_31_5 = "player_far"
		var_31_6 = "sound_player_far"
		var_31_7 = "interact_false"
	elseif var_31_4 then
		var_31_5 = "player_interacting"
		var_31_7 = "interact_true"
	elseif var_31_3 < var_0_2 * var_0_2 then
		var_31_5 = "player_near"
		var_31_6 = "sound_player_near"
		var_31_7 = "interact_false"
	elseif var_31_3 > var_0_3 * var_0_3 then
		var_31_5 = "player_far"
		var_31_6 = "sound_player_far"
		var_31_7 = "interact_false"
	end

	if var_31_5 ~= arg_31_0._animation_state then
		arg_31_0._animation_state = var_31_5

		Unit.flow_event(arg_31_1, var_31_5)
	end

	if var_31_6 ~= arg_31_0._sound_state then
		Unit.flow_event(arg_31_1, var_31_6)

		arg_31_0._sound_state = var_31_6
	end

	if var_31_7 ~= arg_31_0._sound_state_interact then
		Unit.flow_event(arg_31_1, var_31_7)

		arg_31_0._sound_state_interact = var_31_7
	end
end

function DeusChestExtension._update_telemetry(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._player_unit
	local var_32_1 = POSITION_LOOKUP[var_32_0]

	if not var_32_1 then
		return
	end

	local var_32_2 = arg_32_0._telemetry_data

	if var_32_2.altar_type == "n/a" then
		var_32_2.altar_type = arg_32_0:_get_server_chest_type() or "n/a"
	end

	if var_32_2.currency_when_found == -1 then
		local var_32_3 = POSITION_LOOKUP[arg_32_1]

		if Vector3.distance_squared(var_32_1, var_32_3) < 625 then
			local var_32_4 = arg_32_0._deus_run_controller
			local var_32_5 = var_32_4:get_own_peer_id()

			var_32_2.currency_when_found = var_32_4:get_player_soft_currency(var_32_5)
		end
	end
end

function DeusChestExtension.rpc_deus_chest_looted(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = Managers.state.unit_storage:go_id(arg_33_0.unit)

	if arg_33_2 ~= var_33_0 then
		return
	end

	local var_33_1 = Managers.state.network:game()

	fassert(var_33_1 and var_33_0, "setting state without network setup done")

	local var_33_2 = GameSession.game_object_field(var_33_1, var_33_0, "collected_by_peers")
	local var_33_3 = CHANNEL_TO_PEER_ID[arg_33_1]

	table.insert(var_33_2, var_33_3)
	GameSession.set_game_object_field(var_33_1, var_33_0, "collected_by_peers", var_33_2)
end
