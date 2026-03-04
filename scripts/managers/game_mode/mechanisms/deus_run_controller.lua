-- chunkname: @scripts/managers/game_mode/mechanisms/deus_run_controller.lua

require("scripts/helpers/deus_power_up_utils")
require("scripts/helpers/rarity_utils")
require("scripts/managers/game_mode/mechanisms/deus_generate_graph")
require("scripts/settings/dlcs/morris/deus_map_visibility_settings")
require("scripts/settings/dlcs/morris/deus_blessing_settings")
require("scripts/settings/dlcs/morris/deus_cost_settings")
require("scripts/settings/dlcs/morris/deus_new_loadout_settings")
require("scripts/settings/dlcs/morris/deus_experience_settings")
require("scripts/managers/game_mode/mechanisms/deus_run_state")
require("scripts/utils/hash_utils")

DeusRunController = class(DeusRunController)

local var_0_0 = {
	"rpc_deus_shop_heal_player",
	"rpc_deus_shop_blessing_selected",
	"rpc_deus_shop_power_up_bought",
	"rpc_deus_save_loadout",
	"rpc_deus_add_power_ups",
	"rpc_deus_set_initial_soft_currency",
	"rpc_deus_set_initial_setup",
	"rpc_deus_chest_unlocked",
	"rpc_deus_soft_currency_picked_up",
	"rpc_deus_grant_end_of_level_power_ups",
	"rpc_deus_remove_power_up"
}
local var_0_1 = 1
local var_0_2 = 10000
local var_0_3 = {
	{
		"kills_per_breed",
		"skaven_storm_vermin"
	},
	{
		"kills_per_breed",
		"skaven_storm_vermin_commander"
	},
	{
		"kills_per_breed",
		"skaven_storm_vermin_with_shield"
	},
	{
		"kills_per_breed",
		"skaven_plague_monk"
	},
	{
		"kills_per_breed",
		"chaos_warrior"
	},
	{
		"kills_per_breed",
		"chaos_berzerker"
	},
	{
		"kills_per_breed",
		"chaos_raider"
	},
	{
		"kills_per_breed",
		"beastmen_bestigor"
	},
	{
		"kills_per_breed",
		"skaven_gutter_runner"
	},
	{
		"kills_per_breed",
		"skaven_poison_wind_globadier"
	},
	{
		"kills_per_breed",
		"skaven_pack_master"
	},
	{
		"kills_per_breed",
		"skaven_ratling_gunner"
	},
	{
		"kills_per_breed",
		"skaven_warpfire_thrower"
	},
	{
		"kills_per_breed",
		"chaos_corruptor_sorcerer"
	},
	{
		"kills_per_breed",
		"chaos_vortex_sorcerer"
	},
	{
		"kills_per_breed",
		"beastmen_standard_bearer"
	},
	{
		"kills_total"
	},
	{
		"kills_melee"
	},
	{
		"kills_ranged"
	},
	{
		"damage_taken"
	},
	{
		"damage_dealt"
	},
	{
		"damage_dealt_per_breed",
		"skaven_rat_ogre"
	},
	{
		"damage_dealt_per_breed",
		"skaven_stormfiend"
	},
	{
		"damage_dealt_per_breed",
		"chaos_spawn"
	},
	{
		"damage_dealt_per_breed",
		"chaos_troll"
	},
	{
		"damage_dealt_per_breed",
		"beastmen_minotaur"
	},
	{
		"headshots"
	},
	{
		"saves"
	},
	{
		"revives"
	}
}
local var_0_4 = {
	normal = {
		"loot_chest_01_06",
		2
	},
	hard = {
		"loot_chest_02_06",
		2
	},
	harder = {
		"loot_chest_03_06",
		2
	},
	hardest = {
		"loot_chest_04_06",
		2
	},
	cataclysm = {
		"loot_chest_04_06",
		2
	}
}

script_data.deus_run_controller_debug = true

local var_0_5 = print

local function var_0_6(...)
	if script_data.deus_run_controller_debug then
		var_0_5("[DeusRunController] ", ...)
	end
end

local function var_0_7(...)
	var_0_5("[DeusRunController] ", ...)
end

local function var_0_8(arg_3_0, arg_3_1)
	if not arg_3_0 and not arg_3_1 then
		return true
	elseif not arg_3_0 or not arg_3_1 then
		return false
	end

	return math.round_with_precision(arg_3_0, 2) == math.round_with_precision(arg_3_1, 2)
end

local function var_0_9(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0
	local var_4_1
	local var_4_2 = arg_4_2 / arg_4_3

	if arg_4_0 <= 1 - DeusShopSettings.heal_amount then
		var_4_0 = arg_4_2
	else
		var_4_0 = 1 - arg_4_0
	end

	local var_4_3 = math.ceil(var_4_0 / var_4_2)

	if arg_4_1 < var_4_3 then
		var_4_3 = arg_4_1
		var_4_0 = var_4_3 * var_4_2
	end

	return var_4_0, var_4_3
end

DeusRunController.init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
	arg_5_0._run_state = DeusRunState:new(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
	arg_5_0._network_handler = arg_5_3
end

DeusRunController.network_context_created = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_0._run_state:network_context_created(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)

	arg_6_0._network_handler = arg_6_5

	local var_6_0 = arg_6_0._run_state:get_host_migration_count() + 1

	arg_6_0._run_state:set_host_migration_count(var_6_0)
end

DeusRunController.register_rpcs = function (arg_7_0, arg_7_1)
	arg_7_0._network_event_delegate = arg_7_1

	arg_7_1:register(arg_7_0, unpack(var_0_0))
	arg_7_0._run_state:register_rpcs(arg_7_1)
end

DeusRunController.unregister_rpcs = function (arg_8_0)
	if arg_8_0._network_event_delegate then
		arg_8_0._network_event_delegate:unregister(arg_8_0)
	end

	arg_8_0._network_event_delegate = nil

	arg_8_0._run_state:unregister_rpcs()
end

DeusRunController.full_sync = function (arg_9_0)
	arg_9_0._run_state:full_sync()
end

DeusRunController.is_server = function (arg_10_0)
	return arg_10_0._run_state:is_server()
end

DeusRunController.get_server_peer_id = function (arg_11_0)
	return arg_11_0._run_state:server_peer_id()
end

DeusRunController.get_own_peer_id = function (arg_12_0)
	return arg_12_0._run_state:own_peer_id()
end

DeusRunController.destroy = function (arg_13_0)
	arg_13_0:unregister_rpcs()
	arg_13_0._run_state:destroy()

	arg_13_0._destroyed = true
end

DeusRunController.get_run_ended = function (arg_14_0)
	return arg_14_0._run_state:get_run_ended()
end

DeusRunController.handle_run_ended = function (arg_15_0)
	arg_15_0._run_state:set_run_ended(true)
end

DeusRunController.setup_run = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	arg_16_0._run_state:set_run_seed(arg_16_1)
	arg_16_0._run_state:set_run_difficulty(arg_16_2)
	arg_16_0._run_state:set_journey_name(arg_16_3)
	arg_16_0._run_state:set_dominant_god(arg_16_4)
	arg_16_0._run_state:set_belakor_enabled(arg_16_7)
	arg_16_0._run_state:set_event_mutators(arg_16_8)
	arg_16_0._run_state:set_event_boons(arg_16_9)

	local var_16_0 = DEUS_MAP_POPULATE_SETTINGS[arg_16_3] or DEUS_MAP_POPULATE_SETTINGS.default

	arg_16_0._path_graph = deus_generate_graph(arg_16_1, arg_16_3, arg_16_4, var_16_0, arg_16_7)

	arg_16_0._run_state:set_current_node_key("start")

	arg_16_0._run_start_time = os.time()

	arg_16_0._run_state:set_own_player_telemetry_id(arg_16_6)

	local var_16_1 = arg_16_0._run_state:get_own_peer_id()
	local var_16_2, var_16_3 = arg_16_0._run_state:get_player_profile(var_16_1, var_0_1)
	local var_16_4
	local var_16_5
	local var_16_6

	if var_16_2 ~= 0 then
		local var_16_7 = SPProfiles[var_16_2].careers[var_16_3].name

		var_16_6 = arg_16_0._run_state:get_own_initial_talents()[var_16_7]

		local var_16_8 = arg_16_0._run_state:get_own_initial_loadout()[var_16_7]
		local var_16_9 = var_16_8.slot_melee
		local var_16_10 = var_16_8.slot_ranged

		var_16_4 = DeusWeaponGeneration.serialize_weapon(var_16_9)
		var_16_5 = DeusWeaponGeneration.serialize_weapon(var_16_10)
	end

	local var_16_11 = arg_16_0._run_state:get_run_id()

	if arg_16_0._run_state:is_server() then
		arg_16_0._run_state:set_player_soft_currency(var_16_1, var_0_1, arg_16_5)
		arg_16_0._run_state:set_peer_initialized(var_16_1, true)

		if var_16_2 ~= 0 then
			arg_16_0:_add_initial_power_ups(var_16_1, var_0_1, var_16_2, var_16_3, var_16_6)
			arg_16_0:_add_initial_weapons_to_loadout(var_16_1, var_0_1, var_16_2, var_16_3, var_16_4, var_16_5)
			arg_16_0._run_state:set_profile_initialized(var_16_1, var_0_1, var_16_2, var_16_3, true)
		end

		Managers.telemetry_events:deus_run_started(var_16_11, arg_16_3, arg_16_1, arg_16_4, arg_16_2, #arg_16_8 > 0, arg_16_8, arg_16_9)
		arg_16_0:_add_coin_tracking_entry(var_16_1, var_0_1, arg_16_5, "set initial soft currency")
	else
		local var_16_12 = arg_16_0._run_state:get_server_peer_id()
		local var_16_13 = PEER_ID_TO_CHANNEL[var_16_12]

		RPC.rpc_deus_set_initial_soft_currency(var_16_13, arg_16_5)

		if var_16_2 ~= 0 then
			arg_16_0:_add_initial_power_ups(var_16_1, var_0_1, var_16_2, var_16_3, var_16_6)
			arg_16_0:_add_initial_weapons_to_loadout(var_16_1, var_0_1, var_16_2, var_16_3, var_16_4, var_16_5)
			RPC.rpc_deus_set_initial_setup(var_16_13, var_16_2, var_16_3, var_16_6, var_16_4, var_16_5)
		end
	end

	var_0_7(sprintf("starting <%s> with seed <%s> on difficulty <%s> and dominant god <%s> with belakor <%s>", arg_16_3, arg_16_1, arg_16_2, arg_16_4, arg_16_7))
end

DeusRunController.is_weekly_event_packages_loaded = function (arg_17_0)
	return arg_17_0._run_state:is_weekly_event_packages_loaded()
end

DeusRunController.get_state_revision = function (arg_18_0)
	return arg_18_0._run_state:get_revision()
end

DeusRunController.rpc_deus_set_initial_soft_currency = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = CHANNEL_TO_PEER_ID[arg_19_1]

	if not arg_19_0._run_state:get_peer_initialized(var_19_0) then
		local var_19_1
		local var_19_2 = arg_19_0._run_state:get_current_node_key()
		local var_19_3 = arg_19_0:_get_graph_data()
		local var_19_4 = var_19_3[var_19_2]

		if var_19_4.node_type == "ingame" then
			var_19_1 = var_19_4.run_progress
		else
			local var_19_5 = arg_19_0._run_state:get_traversed_nodes()

			for iter_19_0 = #var_19_5, 1, -1 do
				local var_19_6 = var_19_3[var_19_5[iter_19_0]]

				if var_19_6.node_type == "ingame" then
					var_19_1 = var_19_6.run_progress

					break
				end
			end
		end

		var_19_1 = var_19_1 or 0

		local var_19_7 = DeusNewLoadoutSettings.coin_formula(var_19_1) + arg_19_2

		arg_19_0._run_state:set_player_soft_currency(var_19_0, var_0_1, var_19_7)
		arg_19_0._run_state:set_peer_initialized(var_19_0, true)
		arg_19_0:_add_coin_tracking_entry(var_19_0, var_0_1, var_19_7, "set initial soft currency")
	end
end

DeusRunController.rpc_deus_set_initial_setup = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	local var_20_0 = CHANNEL_TO_PEER_ID[arg_20_1]

	if not arg_20_0._run_state:get_profile_initialized(var_20_0, var_0_1, arg_20_2, arg_20_3) then
		arg_20_0:_add_initial_power_ups(var_20_0, var_0_1, arg_20_2, arg_20_3, arg_20_4)
		arg_20_0:_add_initial_weapons_to_loadout(var_20_0, var_0_1, arg_20_2, arg_20_3, arg_20_5, arg_20_6)
		arg_20_0._run_state:set_profile_initialized(var_20_0, var_0_1, arg_20_2, arg_20_3, true)
	end

	local var_20_1 = arg_20_0._run_state:get_granted_non_party_end_of_level_power_ups(var_20_0, var_0_1, arg_20_2, arg_20_3)

	for iter_20_0, iter_20_1 in pairs(arg_20_0:_get_graph_data()) do
		if iter_20_1.grant_random_power_up_count and table.index_of(var_20_1, iter_20_0) == -1 then
			RPC.rpc_deus_grant_end_of_level_power_ups(arg_20_1, iter_20_0)
		end
	end
end

DeusRunController.rpc_deus_grant_end_of_level_power_ups = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0:_get_graph_data()[arg_21_2]
	local var_21_1 = var_21_0.grant_random_power_up_count
	local var_21_2 = var_21_0.terror_event_power_up_rarity
	local var_21_3 = arg_21_0._run_state:get_own_peer_id()
	local var_21_4 = var_21_0.system_seeds.power_ups or 0
	local var_21_5 = HashUtils.fnv32_hash(var_21_3 .. "_" .. var_21_4)
	local var_21_6 = var_21_0.run_progress
	local var_21_7, var_21_8 = arg_21_0._run_state:get_player_profile(var_21_3, var_0_1)
	local var_21_9 = arg_21_0._run_state:get_player_power_ups(var_21_3, var_0_1, var_21_7, var_21_8)
	local var_21_10 = SPProfiles[var_21_7].careers[var_21_8].name
	local var_21_11
	local var_21_12, var_21_13 = DeusPowerUpUtils.generate_random_power_ups(var_21_5, var_21_1, var_21_9, arg_21_0._run_state:get_run_difficulty(), var_21_6, DeusPowerUpAvailabilityTypes.weapon_chest, var_21_10, var_21_2)
	local var_21_14 = true
	local var_21_15 = table.clone(var_21_9, var_21_14)

	table.append(var_21_15, var_21_13)

	local var_21_16 = DeusPowerUpUtils.power_ups_to_encoded_string(var_21_13)
	local var_21_17 = arg_21_0._run_state:get_server_peer_id()
	local var_21_18 = PEER_ID_TO_CHANNEL[var_21_17]
	local var_21_19 = arg_21_2

	RPC.rpc_deus_add_power_ups(var_21_18, var_21_16, var_21_19)
end

DeusRunController.profile_changed = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	if arg_22_0._run_state:get_own_peer_id() ~= arg_22_1 then
		return
	end

	if arg_22_0._run_state:get_profile_initialized(arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5) then
		return
	end

	local var_22_0 = arg_22_5 and arg_22_0._run_state:get_own_initial_bot_talents() or arg_22_0._run_state:get_own_initial_talents()
	local var_22_1 = SPProfiles[arg_22_3].careers[arg_22_4].name
	local var_22_2 = var_22_0[var_22_1]
	local var_22_3 = (arg_22_5 and arg_22_0._run_state:get_own_initial_bot_loadout() or arg_22_0._run_state:get_own_initial_loadout())[var_22_1]
	local var_22_4 = var_22_3.slot_melee
	local var_22_5 = var_22_3.slot_ranged
	local var_22_6 = DeusWeaponGeneration.serialize_weapon(var_22_4)
	local var_22_7 = DeusWeaponGeneration.serialize_weapon(var_22_5)

	arg_22_0:_add_initial_power_ups(arg_22_1, arg_22_2, arg_22_3, arg_22_4, var_22_2)
	arg_22_0:_add_initial_weapons_to_loadout(arg_22_1, arg_22_2, arg_22_3, arg_22_4, var_22_6, var_22_7)

	if arg_22_0._run_state:is_server() then
		fassert(arg_22_3 ~= 0, "the host must have a profile assigned already")
		arg_22_0._run_state:set_profile_initialized(arg_22_1, arg_22_2, arg_22_3, arg_22_4, true)
	else
		local var_22_8 = arg_22_0._run_state:get_server_peer_id()
		local var_22_9 = PEER_ID_TO_CHANNEL[var_22_8]

		RPC.rpc_deus_set_initial_setup(var_22_9, arg_22_3, arg_22_4, var_22_2, var_22_6, var_22_7)
	end
end

DeusRunController._add_initial_power_ups = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	local var_23_0 = {}

	for iter_23_0 = 1, #arg_23_5 do
		local var_23_1 = arg_23_5[iter_23_0]

		if var_23_1 ~= 0 then
			local var_23_2, var_23_3 = DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(iter_23_0, var_23_1)

			var_23_0[#var_23_0 + 1] = DeusPowerUpUtils.generate_specific_power_up(var_23_2.name, var_23_3)
		end
	end

	local var_23_4 = arg_23_0._run_state:get_player_power_ups(arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_5 = true
	local var_23_6 = table.clone(var_23_4, var_23_5)

	table.append(var_23_6, var_23_0)

	local var_23_7 = arg_23_0._run_state:get_event_boons()

	table.append(var_23_6, var_23_7)
	arg_23_0._run_state:set_player_power_ups(arg_23_1, arg_23_2, arg_23_3, arg_23_4, var_23_6)
end

DeusRunController._add_initial_weapons_to_loadout = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	arg_24_0._run_state:set_player_loadout(arg_24_1, arg_24_2, arg_24_3, arg_24_4, "slot_melee", arg_24_5)
	arg_24_0._run_state:set_player_loadout(arg_24_1, arg_24_2, arg_24_3, arg_24_4, "slot_ranged", arg_24_6)
end

DeusRunController.get_run_id = function (arg_25_0)
	return arg_25_0._run_state:get_run_id()
end

DeusRunController.get_run_seed = function (arg_26_0)
	return arg_26_0._run_state:get_run_seed()
end

DeusRunController.get_run_difficulty = function (arg_27_0)
	return arg_27_0._run_state:get_run_difficulty()
end

DeusRunController.get_journey_name = function (arg_28_0)
	return arg_28_0._run_state:get_journey_name()
end

DeusRunController.get_dominant_god = function (arg_29_0)
	return arg_29_0._run_state:get_dominant_god()
end

DeusRunController.get_event_boons = function (arg_30_0)
	return arg_30_0._run_state:get_event_boons()
end

DeusRunController.get_event_mutators = function (arg_31_0)
	return arg_31_0._run_state:get_event_mutators()
end

DeusRunController.handle_level_won = function (arg_32_0)
	arg_32_0:_blessings_handle_level_won()

	local var_32_0 = arg_32_0._run_state:get_completed_level_count() + 1

	arg_32_0._run_state:set_completed_level_count(var_32_0)

	local var_32_1 = arg_32_0._run_state:get_traversed_nodes()
	local var_32_2 = arg_32_0._run_state:get_current_node_key()
	local var_32_3 = true
	local var_32_4 = table.clone(var_32_1, var_32_3)

	var_32_4[#var_32_4 + 1] = var_32_2

	arg_32_0._run_state:set_traversed_nodes(var_32_4)

	if arg_32_0:_get_graph_data()[var_32_2].curse then
		local var_32_5 = arg_32_0._network_handler:get_peers()

		for iter_32_0, iter_32_1 in ipairs(var_32_5) do
			local var_32_6 = arg_32_0._run_state:get_cursed_levels_completed(iter_32_1) + 1

			arg_32_0._run_state:set_cursed_levels_completed(iter_32_1, var_32_6)
		end
	end
end

DeusRunController.handle_map_exited = function (arg_33_0)
	if arg_33_0._run_state:get_arena_belakor_node() then
		local var_33_0 = arg_33_0._network_handler:get_peers()

		for iter_33_0, iter_33_1 in ipairs(var_33_0) do
			if not arg_33_0._run_state:get_seen_arena_belakor_node(iter_33_1) then
				arg_33_0._run_state:set_seen_arena_belakor_node(iter_33_1, true)
			end
		end
	end
end

DeusRunController.get_belakor_enabled = function (arg_34_0)
	return arg_34_0._run_state:get_belakor_enabled()
end

DeusRunController.has_completed_current_node = function (arg_35_0)
	local var_35_0 = arg_35_0._run_state:get_current_node_key()

	if var_35_0 == "start" then
		return false
	else
		local var_35_1 = arg_35_0._run_state:get_traversed_nodes()

		return table.contains(var_35_1, var_35_0)
	end
end

DeusRunController.handle_shrine_entered = function (arg_36_0, arg_36_1)
	arg_36_0._run_state:set_current_node_key(arg_36_1)

	local var_36_0 = arg_36_0._run_state:get_traversed_nodes()
	local var_36_1 = true
	local var_36_2 = table.clone(var_36_0, var_36_1)

	var_36_2[#var_36_2 + 1] = arg_36_1

	arg_36_0._run_state:set_traversed_nodes(var_36_2)
end

DeusRunController.get_traversed_nodes = function (arg_37_0)
	return arg_37_0._run_state:get_traversed_nodes() or {}
end

DeusRunController.get_unreachable_nodes = function (arg_38_0)
	local var_38_0 = arg_38_0:get_current_node_key()
	local var_38_1 = {
		[var_38_0] = true
	}
	local var_38_2 = arg_38_0._run_state:get_traversed_nodes()

	for iter_38_0, iter_38_1 in ipairs(var_38_2) do
		var_38_1[iter_38_1] = true
	end

	local var_38_3 = arg_38_0:_get_graph_data()

	local function var_38_4(arg_39_0)
		local var_39_0 = var_38_3[arg_39_0]

		for iter_39_0, iter_39_1 in ipairs(var_39_0.next) do
			var_38_1[iter_39_1] = true

			var_38_4(iter_39_1)
		end
	end

	var_38_4(var_38_0)

	local var_38_5 = {}

	for iter_38_2, iter_38_3 in pairs(var_38_3) do
		if not var_38_1[iter_38_2] then
			var_38_5[#var_38_5 + 1] = iter_38_2
		end
	end

	return var_38_5
end

DeusRunController.get_visited_nodes = function (arg_40_0)
	local var_40_0 = arg_40_0:get_traversed_nodes()
	local var_40_1 = arg_40_0:get_current_node_key()
	local var_40_2 = true
	local var_40_3 = table.clone(var_40_0, var_40_2)

	if not table.contains(var_40_3, var_40_1) then
		table.insert(var_40_3, var_40_1)
	end

	return var_40_3
end

DeusRunController.get_completed_level_count = function (arg_41_0)
	return arg_41_0._run_state:get_completed_level_count()
end

DeusRunController.get_map_visibility = function (arg_42_0)
	local var_42_0 = arg_42_0:_get_graph_data()
	local var_42_1 = arg_42_0._run_state:get_current_node_key()
	local var_42_2 = arg_42_0._run_state:get_traversed_nodes() or {}
	local var_42_3 = {}

	for iter_42_0, iter_42_1 in pairs(var_42_0) do
		var_42_3[iter_42_0] = DeusMapVisibilitySettings.STRONG_FOG_LEVEL
	end

	local function var_42_4(arg_43_0)
		var_42_3[arg_43_0] = DeusMapVisibilitySettings.WEAK_FOG_LEVEL

		local function var_43_0(arg_44_0, arg_44_1)
			if arg_44_1 > DeusMapVisibilitySettings.STRONG_FOG_LEVEL then
				return
			end

			var_42_3[arg_44_0] = math.min(var_42_3[arg_44_0], arg_44_1)

			for iter_44_0, iter_44_1 in ipairs(var_42_0[arg_44_0].next) do
				var_43_0(iter_44_1, arg_44_1 + 1)
			end
		end

		for iter_43_0, iter_43_1 in ipairs(var_42_0[arg_43_0].next) do
			var_43_0(iter_43_1, DeusMapVisibilitySettings.WEAK_FOG_LEVEL)
		end
	end

	var_42_4(var_42_1)

	if script_data.deus_fog_with_no_memory then
		for iter_42_2, iter_42_3 in ipairs(var_42_2) do
			var_42_3[iter_42_3] = DeusMapVisibilitySettings.WEAK_FOG_LEVEL
		end

		var_42_3.start = DeusMapVisibilitySettings.WEAK_FOG_LEVEL
	else
		for iter_42_4, iter_42_5 in ipairs(var_42_2) do
			var_42_4(iter_42_5)
		end

		var_42_4("start")
	end

	local var_42_5 = arg_42_0._run_state:get_arena_belakor_node()

	if var_42_5 then
		var_42_3[var_42_5] = 0
	end

	var_42_3.final = 0

	return var_42_3
end

DeusRunController.get_end_of_level_rewards_arguments = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0._run_state:get_completed_level_count()
	local var_45_1 = arg_45_0._run_state:get_own_peer_id()
	local var_45_2 = arg_45_0._run_state:get_player_soft_currency(var_45_1, var_0_1)
	local var_45_3 = arg_45_0._run_state:get_current_node_key()
	local var_45_4 = arg_45_0:_get_graph_data()[var_45_3].run_progress
	local var_45_5 = arg_45_0._run_state:get_run_difficulty()
	local var_45_6 = var_0_4[var_45_5][1]
	local var_45_7 = var_0_4[var_45_5][2]

	return {
		deus_completed_level_count = var_45_0,
		deus_soft_currency = var_45_2,
		deus_item_name = var_45_6,
		deus_num_duplicates = var_45_7,
		chest_upgrade_data = {
			quickplay = arg_45_2,
			game_won = arg_45_1,
			cursed_chests_purified = arg_45_0._run_state:get_cursed_chests_purified(var_45_1),
			cursed_levels_completed = arg_45_0._run_state:get_cursed_levels_completed(var_45_1),
			coin_chests_collected = arg_45_0._run_state:get_coin_chests_collected(var_45_1),
			run_progress = var_45_4
		}
	}
end

DeusRunController.get_mission_results = function (arg_46_0)
	local var_46_0 = {}
	local var_46_1 = arg_46_0._run_state:get_own_peer_id()

	var_46_0[#var_46_0 + 1] = {
		text = "deus_cursed_chests_purified",
		experience = arg_46_0._run_state:get_cursed_chests_purified(var_46_1) * DeusExperienceSettings.CURSED_CHESTS
	}
	var_46_0[#var_46_0 + 1] = {
		text = "deus_cursed_levels_beaten",
		experience = arg_46_0._run_state:get_cursed_levels_completed(var_46_1) * DeusExperienceSettings.CURSES
	}
	var_46_0[#var_46_0 + 1] = {
		text = "deus_coin_chests_collected",
		experience = arg_46_0._run_state:get_coin_chests_collected(var_46_1) * DeusExperienceSettings.COINS
	}

	return var_46_0
end

DeusRunController.record_cursed_chest_purified = function (arg_47_0)
	local var_47_0 = arg_47_0._network_handler:get_peers()

	for iter_47_0, iter_47_1 in ipairs(var_47_0) do
		local var_47_1 = arg_47_0._run_state:get_cursed_chests_purified(iter_47_1) + 1

		arg_47_0._run_state:set_cursed_chests_purified(iter_47_1, var_47_1)
	end
end

DeusRunController.save_persisted_score = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0, var_48_1 = PlayerUtils.split_unique_player_id(arg_48_2)
	local var_48_2 = {}

	for iter_48_0, iter_48_1 in ipairs(var_0_3) do
		if arg_48_1:has_stat(unpack(iter_48_1)) then
			var_48_2[iter_48_0] = arg_48_1:get_stat(arg_48_2, unpack(iter_48_1))
		else
			var_48_2[iter_48_0] = 0
		end
	end

	arg_48_0._run_state:set_persisted_score(var_48_0, var_48_1, var_48_2)
end

DeusRunController.restore_persisted_score = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = PlayerUtils.unique_player_id(arg_49_2, arg_49_3)
	local var_49_1 = arg_49_0._run_state:get_persisted_score(arg_49_2, arg_49_3)

	for iter_49_0, iter_49_1 in ipairs(var_0_3) do
		local var_49_2 = var_49_1[iter_49_0]
		local var_49_3 = table.clone(iter_49_1)

		var_49_3[#var_49_3 + 1] = var_49_2 or 0

		arg_49_1:set_non_persistent_stat(var_49_0, unpack(var_49_3))
	end
end

DeusRunController.save_scoreboard = function (arg_50_0, arg_50_1)
	arg_50_0._run_state:set_scoreboard(arg_50_1)
end

DeusRunController.get_scoreboard = function (arg_51_0)
	return arg_51_0._run_state:get_scoreboard()
end

DeusRunController.get_own_peer_id = function (arg_52_0)
	return arg_52_0._run_state:get_own_peer_id()
end

DeusRunController.get_server_peer_id = function (arg_53_0)
	return arg_53_0._run_state:get_server_peer_id()
end

DeusRunController.get_own_initial_talents = function (arg_54_0)
	return arg_54_0._run_state:get_own_initial_talents()
end

DeusRunController.get_peers = function (arg_55_0)
	return arg_55_0._network_handler:get_peers()
end

DeusRunController.set_own_player_avatar_info = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	arg_56_0._run_state:set_own_player_level(arg_56_1)
	arg_56_0._run_state:set_own_versus_player_level(arg_56_4)
	arg_56_0._run_state:set_own_player_frame(arg_56_3)
	arg_56_0._run_state:set_own_player_name(arg_56_2)
end

DeusRunController.get_own_loadout = function (arg_57_0)
	if arg_57_0._destroyed then
		local var_57_0 = arg_57_0._run_state:get_own_peer_id()
		local var_57_1, var_57_2 = arg_57_0._run_state:get_player_profile(var_57_0, var_0_1)
		local var_57_3 = SPProfiles[var_57_1].careers[var_57_2].name
		local var_57_4 = arg_57_0._run_state:get_own_initial_loadout()[var_57_3]
		local var_57_5 = var_57_4.slot_melee
		local var_57_6 = var_57_4.slot_ranged

		return var_57_5, var_57_6
	else
		local var_57_7, var_57_8 = arg_57_0:get_own_loadout_serialized()
		local var_57_9 = DeusWeaponGeneration.deserialize_weapon(var_57_7)
		local var_57_10 = DeusWeaponGeneration.deserialize_weapon(var_57_8)

		return var_57_9, var_57_10
	end
end

DeusRunController.get_own_loadout_serialized = function (arg_58_0)
	local var_58_0 = arg_58_0._run_state:get_own_peer_id()
	local var_58_1, var_58_2 = arg_58_0._run_state:get_player_profile(var_58_0, var_0_1)
	local var_58_3 = arg_58_0._run_state:get_player_loadout(var_58_0, var_0_1, var_58_1, var_58_2, "slot_melee")
	local var_58_4 = arg_58_0._run_state:get_player_loadout(var_58_0, var_0_1, var_58_1, var_58_2, "slot_ranged")

	return var_58_3, var_58_4
end

DeusRunController.get_loadout = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	local var_59_0 = arg_59_0._run_state:get_player_loadout(arg_59_1, arg_59_2, arg_59_3, arg_59_4, "slot_melee")
	local var_59_1 = arg_59_0._run_state:get_player_loadout(arg_59_1, arg_59_2, arg_59_3, arg_59_4, "slot_ranged")
	local var_59_2 = var_59_0 and DeusWeaponGeneration.deserialize_weapon(var_59_0)
	local var_59_3 = var_59_1 and DeusWeaponGeneration.deserialize_weapon(var_59_1)

	return var_59_2, var_59_3
end

DeusRunController.save_loadout = function (arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_0._run_state:get_own_peer_id()
	local var_60_1, var_60_2 = arg_60_0._run_state:get_player_profile(var_60_0, var_0_1)
	local var_60_3 = DeusWeaponGeneration.serialize_weapon(arg_60_1)

	arg_60_0._run_state:set_player_loadout(var_60_0, var_0_1, var_60_1, var_60_2, arg_60_2, var_60_3)

	if not arg_60_0._run_state:is_server() then
		local var_60_4 = arg_60_0._run_state:get_server_peer_id()
		local var_60_5 = PEER_ID_TO_CHANNEL[var_60_4]

		RPC.rpc_deus_save_loadout(var_60_5, arg_60_2, var_60_3)
	end
end

DeusRunController.rpc_deus_save_loadout = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = CHANNEL_TO_PEER_ID[arg_61_1]
	local var_61_1, var_61_2 = arg_61_0._run_state:get_player_profile(var_61_0, var_0_1)

	arg_61_0._run_state:set_player_loadout(var_61_0, var_0_1, var_61_1, var_61_2, arg_61_2, arg_61_3)
end

DeusRunController.on_soft_currency_picked_up = function (arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = arg_62_0._run_state:get_own_peer_id()

	arg_62_0:_add_soft_currency_to_peer(var_62_0, arg_62_1)

	if not arg_62_0._run_state:is_server() then
		local var_62_1 = arg_62_0._run_state:get_server_peer_id()
		local var_62_2 = PEER_ID_TO_CHANNEL[var_62_1]

		RPC.rpc_deus_soft_currency_picked_up(var_62_2, arg_62_1, arg_62_2)
	elseif arg_62_2 == DeusSoftCurrencySettings.types.GROUND then
		local var_62_3 = arg_62_0._run_state:get_ground_coins_picked_up() + 1

		arg_62_0._run_state:set_ground_coins_picked_up(var_62_3)
	elseif arg_62_2 == DeusSoftCurrencySettings.types.MONSTER then
		local var_62_4 = arg_62_0._run_state:get_monster_coins_picked_up() + 1

		arg_62_0._run_state:set_monster_coins_picked_up(var_62_4)
	end
end

DeusRunController.get_player_soft_currency = function (arg_63_0, arg_63_1)
	return arg_63_0._run_state:get_player_soft_currency(arg_63_1, var_0_1)
end

DeusRunController.rpc_deus_soft_currency_picked_up = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	local var_64_0 = CHANNEL_TO_PEER_ID[arg_64_1]

	arg_64_0:_add_soft_currency_to_peer(var_64_0, arg_64_2)
end

DeusRunController._add_soft_currency_to_peer = function (arg_65_0, arg_65_1, arg_65_2)
	local var_65_0 = arg_65_0._run_state:get_coin_chests_collected(arg_65_1) + 1

	arg_65_0._run_state:set_coin_chests_collected(arg_65_1, var_65_0)

	local var_65_1 = arg_65_0._run_state:get_player_soft_currency(arg_65_1, var_0_1) + arg_65_2

	arg_65_0._run_state:set_player_soft_currency(arg_65_1, var_0_1, var_65_1)
	arg_65_0:_add_coin_tracking_entry(arg_65_1, var_0_1, arg_65_2, "add coins")
end

DeusRunController.grant_soft_currency = function (arg_66_0, arg_66_1, arg_66_2)
	arg_66_0:_add_soft_currency_to_peer(arg_66_1, arg_66_2)
end

DeusRunController.get_shop_heal_data = function (arg_67_0)
	local var_67_0 = arg_67_0._run_state:get_own_peer_id()
	local var_67_1, var_67_2 = arg_67_0._run_state:get_player_profile(var_67_0, var_0_1)
	local var_67_3 = arg_67_0._run_state:get_player_health_percentage(var_67_0, var_0_1, var_67_1, var_67_2)
	local var_67_4 = arg_67_0._run_state:get_player_soft_currency(var_67_0, var_0_1)
	local var_67_5 = DeusShopSettings.heal_amount
	local var_67_6 = DeusShopSettings.heal_cost
	local var_67_7, var_67_8 = var_0_9(var_67_3, var_67_4, var_67_5, var_67_6)
	local var_67_9 = var_67_8

	return var_67_7, var_67_9
end

DeusRunController.shop_buy_health = function (arg_68_0)
	local var_68_0 = arg_68_0._run_state:get_own_peer_id()

	if arg_68_0:_try_buy_health(var_68_0) and not arg_68_0._run_state:is_server() then
		local var_68_1 = arg_68_0._run_state:get_server_peer_id()
		local var_68_2 = PEER_ID_TO_CHANNEL[var_68_1]

		RPC.rpc_deus_shop_heal_player(var_68_2)
	end
end

DeusRunController.shop_buy_blessing = function (arg_69_0, arg_69_1)
	if arg_69_0:_try_buy_blessing(arg_69_0._run_state:get_own_peer_id(), arg_69_1) and not arg_69_0._run_state:is_server() then
		local var_69_0 = arg_69_0._run_state:get_server_peer_id()
		local var_69_1 = PEER_ID_TO_CHANNEL[var_69_0]

		RPC.rpc_deus_shop_blessing_selected(var_69_1, arg_69_1)
	end
end

DeusRunController.shop_buy_power_up = function (arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = arg_70_0:_try_buy_power_up(arg_70_0._run_state:get_own_peer_id(), arg_70_1, arg_70_2)

	if var_70_0 and not arg_70_0._run_state:is_server() then
		local var_70_1 = arg_70_0._run_state:get_server_peer_id()
		local var_70_2 = PEER_ID_TO_CHANNEL[var_70_1]

		RPC.rpc_deus_shop_power_up_bought(var_70_2, arg_70_1.rarity, arg_70_1.name, arg_70_1.client_id, math.round(arg_70_2 * var_0_2))
	end

	if var_70_0 then
		local var_70_3 = arg_70_0._run_state:get_own_peer_id()

		arg_70_0:_check_set_completed(arg_70_1, true, var_70_3, var_0_1)
	end
end

DeusRunController._try_buy_health = function (arg_71_0, arg_71_1)
	local var_71_0, var_71_1 = arg_71_0._run_state:get_player_profile(arg_71_1, var_0_1)
	local var_71_2 = arg_71_0._run_state:get_player_health_percentage(arg_71_1, var_0_1, var_71_0, var_71_1)
	local var_71_3 = arg_71_0._run_state:get_player_soft_currency(arg_71_1, var_0_1)

	if var_71_2 < 1 then
		local var_71_4 = DeusShopSettings.heal_amount
		local var_71_5 = DeusShopSettings.heal_cost
		local var_71_6, var_71_7 = var_0_9(var_71_2, var_71_3, var_71_4, var_71_5)

		if var_71_7 <= var_71_3 then
			local var_71_8 = math.clamp(var_71_2 + var_71_6, 0, 1)

			arg_71_0._run_state:set_player_soft_currency(arg_71_1, var_0_1, var_71_3 - var_71_7)
			arg_71_0._run_state:set_player_health_percentage(arg_71_1, var_0_1, var_71_0, var_71_1, var_71_8)
			arg_71_0:_add_coin_tracking_entry(arg_71_1, var_0_1, -var_71_7, "health")

			return true
		end
	end

	return false
end

DeusRunController.rpc_deus_shop_heal_player = function (arg_72_0, arg_72_1)
	local var_72_0 = CHANNEL_TO_PEER_ID[arg_72_1]

	if not arg_72_0:_try_buy_health(var_72_0) then
		local var_72_1, var_72_2 = arg_72_0._run_state:get_player_profile(var_72_0, var_0_1)
		local var_72_3 = arg_72_0._run_state:get_player_health_percentage(var_72_0, var_0_1, var_72_1, var_72_2)
		local var_72_4 = arg_72_0._run_state:get_player_soft_currency(var_72_0, var_0_1)

		arg_72_0._run_state:set_player_soft_currency(var_72_0, var_0_1, var_72_4)
		arg_72_0._run_state:set_player_health_percentage(var_72_0, var_0_1, var_72_1, var_72_2, var_72_3)
	end
end

DeusRunController.rpc_deus_shop_blessing_selected = function (arg_73_0, arg_73_1, arg_73_2)
	local var_73_0 = CHANNEL_TO_PEER_ID[arg_73_1]

	if not arg_73_0:_try_buy_blessing(var_73_0, arg_73_2) then
		local var_73_1 = arg_73_0._run_state:get_blessings_with_buyer()
		local var_73_2 = arg_73_0._run_state:get_player_soft_currency(var_73_0, var_0_1)

		arg_73_0._run_state:set_blessings_with_buyer(var_73_1)
		arg_73_0._run_state:set_player_soft_currency(var_73_0, var_0_1, var_73_2)
	end
end

DeusRunController.rpc_deus_shop_power_up_bought = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4, arg_74_5)
	local var_74_0 = CHANNEL_TO_PEER_ID[arg_74_1]

	arg_74_5 = arg_74_5 / var_0_2

	local var_74_1 = true
	local var_74_2 = table.clone(DeusPowerUps[arg_74_2][arg_74_3], var_74_1)

	var_74_2.client_id = arg_74_4

	if not arg_74_0:_try_buy_power_up(var_74_0, var_74_2, arg_74_5) then
		local var_74_3, var_74_4 = arg_74_0._run_state:get_player_profile(var_74_0, var_0_1)
		local var_74_5 = arg_74_0._run_state:get_player_power_ups(var_74_0, var_0_1, var_74_3, var_74_4)
		local var_74_6 = arg_74_0._run_state:get_player_soft_currency(var_74_0, var_0_1)

		arg_74_0._run_state:set_player_power_ups(var_74_0, var_0_1, var_74_3, var_74_4, var_74_5)
		arg_74_0._run_state:set_player_soft_currency(var_74_0, var_0_1, var_74_6)
	end
end

DeusRunController.get_player_power_ups = function (arg_75_0, arg_75_1, arg_75_2)
	local var_75_0, var_75_1 = arg_75_0._run_state:get_player_profile(arg_75_1, arg_75_2)

	return (arg_75_0._run_state:get_player_power_ups(arg_75_1, arg_75_2, var_75_0, var_75_1))
end

DeusRunController.get_power_ups = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4)
	return (arg_76_0._run_state:get_player_power_ups(arg_76_1, arg_76_2, arg_76_3, arg_76_4))
end

DeusRunController.get_party_power_ups = function (arg_77_0)
	return (arg_77_0._run_state:get_party_power_ups())
end

DeusRunController.generate_random_power_ups = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
	arg_78_3 = arg_78_3 or "0"

	local var_78_0 = arg_78_0._run_state:get_own_peer_id()
	local var_78_1 = arg_78_0._run_state:get_current_node_key()
	local var_78_2 = arg_78_0:_get_graph_data()[var_78_1]
	local var_78_3 = var_78_2.system_seeds.power_ups or 0
	local var_78_4 = HashUtils.fnv32_hash(arg_78_3 .. "_" .. var_78_0 .. "_" .. var_78_3)
	local var_78_5 = var_78_2.run_progress
	local var_78_6, var_78_7 = arg_78_0._run_state:get_player_profile(var_78_0, var_0_1)
	local var_78_8 = arg_78_0._run_state:get_player_power_ups(var_78_0, var_0_1, var_78_6, var_78_7)
	local var_78_9 = SPProfiles[var_78_6].careers[var_78_7].name
	local var_78_10
	local var_78_11, var_78_12 = DeusPowerUpUtils.generate_random_power_ups(var_78_4, arg_78_1, var_78_8, arg_78_0._run_state:get_run_difficulty(), var_78_5, arg_78_2, var_78_9)

	return var_78_12
end

local function var_0_10(arg_79_0, arg_79_1)
	return table.find_func(arg_79_0.rewards, function (arg_80_0, arg_80_1)
		return arg_80_1.name == arg_79_1.name and arg_80_1.rarity == arg_79_1.rarity
	end)
end

DeusRunController.add_power_ups = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	if #arg_81_1 == 0 then
		return
	end

	fassert(arg_81_2, "Invalid local_player_id")

	local var_81_0 = arg_81_0._run_state:get_own_peer_id()
	local var_81_1, var_81_2 = arg_81_0._run_state:get_player_profile(var_81_0, arg_81_2)
	local var_81_3 = arg_81_0._run_state:get_player_power_ups(var_81_0, arg_81_2, var_81_1, var_81_2)
	local var_81_4 = true
	local var_81_5 = table.clone(var_81_3, var_81_4)

	table.append(var_81_5, arg_81_1)
	arg_81_0._run_state:set_player_power_ups(var_81_0, arg_81_2, var_81_1, var_81_2, var_81_5)

	if not arg_81_0._run_state:is_server() then
		local var_81_6 = DeusPowerUpUtils.power_ups_to_encoded_string(arg_81_1)
		local var_81_7 = arg_81_0._run_state:get_server_peer_id()
		local var_81_8 = PEER_ID_TO_CHANNEL[var_81_7]
		local var_81_9 = ""

		RPC.rpc_deus_add_power_ups(var_81_8, var_81_6, var_81_9)
	end

	local var_81_10 = Managers.player:player(var_81_0, arg_81_2)

	if var_81_10 then
		local var_81_11 = ScriptUnit.has_extension(var_81_10.player_unit, "buff_system")

		if var_81_11 then
			var_81_11:trigger_procs("on_boon_granted")
		end
	end

	local var_81_12 = var_81_10 and var_81_10.player_unit

	if var_81_12 then
		local var_81_13 = Managers.state.entity:system("buff_system")
		local var_81_14 = Managers.backend:get_talents_interface()
		local var_81_15 = Managers.backend:get_interface("deus")

		for iter_81_0 = 1, #arg_81_1 do
			local var_81_16 = arg_81_1[iter_81_0]

			DeusPowerUpUtils.activate_deus_power_up(var_81_16, var_81_13, var_81_14, var_81_15, arg_81_0, var_81_12, var_81_1, var_81_2)

			if arg_81_3 then
				Managers.state.event:trigger("present_rewards", {
					{
						type = "deus_power_up",
						power_up = var_81_16
					}
				})
			end
		end
	end

	for iter_81_1 = 1, #arg_81_1 do
		local var_81_17 = arg_81_1[iter_81_1]

		arg_81_0:_check_set_completed(var_81_17, arg_81_3, var_81_0, arg_81_2)
	end
end

DeusRunController.remove_power_ups = function (arg_82_0, arg_82_1, arg_82_2)
	fassert(arg_82_2, "[DeusRunController:remove_power_ups] Invalid local_player_id")

	local var_82_0 = arg_82_0._run_state:get_own_peer_id()
	local var_82_1, var_82_2 = arg_82_0._run_state:get_player_profile(var_82_0, arg_82_2)
	local var_82_3 = arg_82_0._run_state:get_player_power_ups(var_82_0, arg_82_2, var_82_1, var_82_2)
	local var_82_4 = NetworkLookup.deus_power_up_templates[arg_82_1]
	local var_82_5 = true
	local var_82_6 = table.clone(var_82_3, var_82_5)
	local var_82_7 = -1

	for iter_82_0 = 1, #var_82_6 do
		if var_82_6[iter_82_0].name == arg_82_1 then
			var_82_7 = iter_82_0

			break
		end
	end

	if var_82_7 ~= -1 then
		local var_82_8 = Managers.player:player(var_82_0, arg_82_2)

		if var_82_8 then
			local var_82_9 = ScriptUnit.has_extension(var_82_8.player_unit, "buff_system")

			if var_82_9 then
				local var_82_10 = var_82_6[var_82_7]

				if var_82_10 then
					local var_82_11 = DeusPowerUps[var_82_10.rarity][var_82_10.name]

					if var_82_11 then
						local var_82_12 = var_82_9:get_buff_type(var_82_11.buff_name)
						local var_82_13 = var_82_12 and var_82_12.id

						if var_82_13 then
							var_82_9:remove_buff(var_82_13)
						end
					end
				end
			end
		end

		if arg_82_0._run_state:is_server() then
			table.swap_delete(var_82_6, var_82_7)
			arg_82_0._run_state:set_player_power_ups(var_82_0, arg_82_2, var_82_1, var_82_2, var_82_6)
		else
			local var_82_14 = arg_82_0._run_state:get_server_peer_id()
			local var_82_15 = PEER_ID_TO_CHANNEL[var_82_14]

			RPC.rpc_deus_remove_power_up(var_82_15, var_82_4)
		end

		return true
	else
		return false
	end
end

DeusRunController._check_set_completed = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	local var_83_0 = DeusPowerUpSetLookup[arg_83_1.rarity] and DeusPowerUpSetLookup[arg_83_1.rarity][arg_83_1.name]

	if not var_83_0 then
		return
	end

	for iter_83_0 = 1, #var_83_0 do
		repeat
			local var_83_1 = var_83_0[iter_83_0]

			if var_0_10(var_83_1, arg_83_1) then
				break
			end

			local var_83_2 = 0

			for iter_83_1 = 1, #var_83_1.pieces do
				local var_83_3 = var_83_1.pieces[iter_83_1]

				if arg_83_0:has_power_up_by_name(arg_83_3, var_83_3.name, var_83_3.rarity) then
					var_83_2 = var_83_2 + 1
				end
			end

			if var_83_2 == (var_83_1.num_required_pieces or #var_83_1.pieces) then
				local var_83_4 = table.select_array(var_83_1.rewards, function (arg_84_0, arg_84_1)
					if not arg_83_0:has_power_up_by_name(arg_83_3, arg_84_1.name, arg_84_1.rarity) then
						return DeusPowerUpUtils.generate_specific_power_up(arg_84_1.name, arg_84_1.rarity)
					end
				end)

				if not table.is_empty(var_83_4) then
					arg_83_0:add_power_ups(var_83_4, arg_83_4, arg_83_2)
				end
			end
		until true
	end
end

DeusRunController.try_grant_end_of_level_deus_power_ups = function (arg_85_0)
	local var_85_0 = arg_85_0:get_current_node_key()
	local var_85_1 = arg_85_0:_get_graph_data()[var_85_0]
	local var_85_2 = var_85_1.grant_random_power_up_count
	local var_85_3 = var_85_1.terror_event_power_up_rarity

	if var_85_2 then
		local var_85_4 = arg_85_0._run_state:get_own_peer_id()
		local var_85_5 = var_85_1.system_seeds.power_ups or 0
		local var_85_6 = HashUtils.fnv32_hash(var_85_4 .. "_" .. var_85_5)
		local var_85_7 = var_85_1.run_progress
		local var_85_8, var_85_9 = arg_85_0._run_state:get_player_profile(var_85_4, var_0_1)
		local var_85_10 = arg_85_0._run_state:get_player_power_ups(var_85_4, var_0_1, var_85_8, var_85_9)
		local var_85_11 = SPProfiles[var_85_8].careers[var_85_9].name
		local var_85_12, var_85_13 = DeusPowerUpUtils.generate_random_power_ups(var_85_6, var_85_2, var_85_10, arg_85_0._run_state:get_run_difficulty(), var_85_7, DeusPowerUpAvailabilityTypes.weapon_chest, var_85_11, var_85_3)
		local var_85_14 = true
		local var_85_15 = table.clone(var_85_10, var_85_14)

		table.append(var_85_15, var_85_13)
		arg_85_0._run_state:set_player_power_ups(var_85_4, var_0_1, var_85_8, var_85_9, var_85_15)

		local var_85_16 = arg_85_0._run_state:get_granted_non_party_end_of_level_power_ups(var_85_4, var_0_1, var_85_8, var_85_9)
		local var_85_17 = table.clone(var_85_16, var_85_14)

		var_85_17[#var_85_17 + 1] = var_85_0

		arg_85_0._run_state:set_granted_non_party_end_of_level_power_ups(var_85_4, var_0_1, var_85_8, var_85_9, var_85_17)

		if not arg_85_0._run_state:is_server() then
			local var_85_18 = DeusPowerUpUtils.power_ups_to_encoded_string(var_85_13)
			local var_85_19 = arg_85_0._run_state:get_server_peer_id()
			local var_85_20 = PEER_ID_TO_CHANNEL[var_85_19]
			local var_85_21 = var_85_0

			RPC.rpc_deus_add_power_ups(var_85_20, var_85_18, var_85_21)
		end

		for iter_85_0 = 1, #var_85_13 do
			local var_85_22 = var_85_13[iter_85_0]

			arg_85_0:_check_set_completed(var_85_22, true, var_85_4, var_0_1)
		end

		return var_85_13
	else
		local var_85_23 = var_85_1.terror_event_power_up

		if var_85_23 then
			local var_85_24 = DeusPowerUpUtils.generate_specific_power_up(var_85_23, var_85_3)
			local var_85_25 = arg_85_0._run_state:get_party_power_ups()
			local var_85_26 = true
			local var_85_27 = table.clone(var_85_25, var_85_26)

			var_85_27[#var_85_27 + 1] = var_85_24

			arg_85_0._run_state:set_party_power_ups(var_85_27)

			return {
				var_85_24
			}
		end
	end
end

DeusRunController.get_arena_belakor_node = function (arg_86_0)
	return arg_86_0._run_state:get_arena_belakor_node()
end

DeusRunController.has_own_seen_arena_belakor_node = function (arg_87_0)
	local var_87_0 = arg_87_0._run_state:get_own_peer_id()

	return arg_87_0._run_state:get_seen_arena_belakor_node(var_87_0)
end

DeusRunController.rpc_deus_add_power_ups = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
	local var_88_0 = CHANNEL_TO_PEER_ID[arg_88_1]
	local var_88_1 = DeusPowerUpUtils.encoded_string_to_power_ups(arg_88_2)
	local var_88_2, var_88_3 = arg_88_0._run_state:get_player_profile(var_88_0, var_0_1)
	local var_88_4 = arg_88_0._run_state:get_player_power_ups(var_88_0, var_0_1, var_88_2, var_88_3)
	local var_88_5 = true
	local var_88_6 = table.clone(var_88_4, var_88_5)

	table.append(var_88_1, var_88_6)
	arg_88_0._run_state:set_player_power_ups(var_88_0, var_0_1, var_88_2, var_88_3, var_88_1)

	if arg_88_3 ~= "" then
		local var_88_7 = arg_88_0._run_state:get_granted_non_party_end_of_level_power_ups(var_88_0, var_0_1, var_88_2, var_88_3)
		local var_88_8 = table.clone(var_88_7, var_88_5)

		var_88_8[#var_88_8 + 1] = arg_88_3

		arg_88_0._run_state:set_granted_non_party_end_of_level_power_ups(var_88_0, var_0_1, var_88_2, var_88_3, var_88_8)
	end

	local var_88_9 = Managers.player:player(var_88_0, var_0_1)

	if var_88_9 then
		local var_88_10 = ScriptUnit.has_extension(var_88_9.player_unit, "buff_system")

		if var_88_10 then
			var_88_10:trigger_procs("on_boon_granted")
		end
	end
end

DeusRunController.rpc_deus_remove_power_up = function (arg_89_0, arg_89_1, arg_89_2)
	local var_89_0 = CHANNEL_TO_PEER_ID[arg_89_1]
	local var_89_1, var_89_2 = arg_89_0._run_state:get_player_profile(var_89_0, var_0_1)
	local var_89_3 = arg_89_0._run_state:get_player_power_ups(var_89_0, var_0_1, var_89_1, var_89_2)
	local var_89_4 = NetworkLookup.deus_power_up_templates[arg_89_2]
	local var_89_5 = true
	local var_89_6 = table.clone(var_89_3, var_89_5)
	local var_89_7 = -1

	for iter_89_0 = 1, #var_89_6 do
		if var_89_6[iter_89_0].name == var_89_4 then
			var_89_7 = iter_89_0

			break
		end
	end

	local var_89_8 = Managers.player:player(var_89_0, var_0_1)

	if var_89_8 then
		local var_89_9 = ScriptUnit.has_extension(var_89_8.player_unit, "buff_system")

		if var_89_9 then
			local var_89_10 = var_89_6[var_89_7]

			if var_89_10 then
				local var_89_11 = DeusPowerUps[var_89_10.rarity][var_89_10.name]

				if var_89_11 then
					local var_89_12 = var_89_9:get_buff_type(var_89_11.buff_name)
					local var_89_13 = var_89_12 and var_89_12.id

					if var_89_13 then
						var_89_9:remove_buff(var_89_13)
					end
				end
			end
		end
	end

	table.swap_delete(var_89_6, var_89_7)
	arg_89_0._run_state:set_player_power_ups(var_89_0, var_0_1, var_89_1, var_89_2, var_89_6)
end

DeusRunController.get_blessings = function (arg_90_0)
	return arg_90_0._run_state:get_blessings()
end

DeusRunController.get_blessings_with_buyer = function (arg_91_0)
	return arg_91_0._run_state:get_blessings_with_buyer()
end

DeusRunController.has_blessing = function (arg_92_0, arg_92_1)
	local var_92_0 = arg_92_0._run_state:get_blessings()

	return table.contains(var_92_0, arg_92_1)
end

DeusRunController.generate_random_blessing_name = function (arg_93_0)
	local var_93_0
	local var_93_1 = {}
	local var_93_2 = arg_93_0._run_state:get_current_node_key()
	local var_93_3 = arg_93_0:_get_graph_data()[var_93_2].system_seeds.blessings or 0
	local var_93_4 = DeusBlessingSettings
	local var_93_5 = arg_93_0._run_state:get_blessings()

	for iter_93_0, iter_93_1 in pairs(var_93_4) do
		if not table.contains(var_93_5, iter_93_0) then
			table.insert(var_93_1, iter_93_0)
		end
	end

	if #var_93_1 > 0 then
		local var_93_6, var_93_7 = Math.next_random(var_93_3, 1, #var_93_1)

		var_93_0 = var_93_1[var_93_7]
	end

	return var_93_0
end

DeusRunController.remove_blessing = function (arg_94_0, arg_94_1)
	local var_94_0 = arg_94_0._run_state:get_blessings_with_buyer()
	local var_94_1 = true
	local var_94_2 = table.clone(var_94_0, var_94_1)

	for iter_94_0, iter_94_1 in pairs(var_94_2) do
		if arg_94_1 == iter_94_0 then
			var_94_2[iter_94_0] = nil
		end
	end

	arg_94_0._run_state:set_blessings_with_buyer(var_94_2)
end

DeusRunController.has_power_up = function (arg_95_0, arg_95_1, arg_95_2)
	local var_95_0, var_95_1 = arg_95_0._run_state:get_player_profile(arg_95_1, var_0_1)
	local var_95_2 = arg_95_0._run_state:get_player_power_ups(arg_95_1, var_0_1, var_95_0, var_95_1)

	for iter_95_0, iter_95_1 in ipairs(var_95_2) do
		if iter_95_1.client_id == arg_95_2 then
			return true
		end
	end

	return false
end

DeusRunController.has_power_up_by_name = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	local var_96_0, var_96_1 = arg_96_0._run_state:get_player_profile(arg_96_1, var_0_1)
	local var_96_2 = arg_96_0._run_state:get_player_power_ups(arg_96_1, var_0_1, var_96_0, var_96_1)

	for iter_96_0 = 1, #var_96_2 do
		local var_96_3 = var_96_2[iter_96_0]

		if var_96_3.name == arg_96_2 and var_96_3.rarity == arg_96_3 then
			return true
		end
	end

	return false
end

DeusRunController.reached_max_power_ups = function (arg_97_0, arg_97_1, arg_97_2)
	local var_97_0, var_97_1 = arg_97_0._run_state:get_player_profile(arg_97_1, var_0_1)
	local var_97_2 = arg_97_0._run_state:get_player_power_ups(arg_97_1, var_0_1, var_97_0, var_97_1)
	local var_97_3 = DeusPowerUpTemplates[arg_97_2].max_amount
	local var_97_4 = 0

	for iter_97_0, iter_97_1 in ipairs(var_97_2) do
		if iter_97_1.name == arg_97_2 then
			var_97_4 = var_97_4 + 1

			if var_97_3 <= var_97_4 then
				return true
			end
		end
	end

	return false
end

DeusRunController._blessings_handle_level_won = function (arg_98_0)
	local var_98_0 = arg_98_0._run_state:get_blessings_with_buyer()
	local var_98_1 = {}

	for iter_98_0, iter_98_1 in pairs(var_98_0) do
		local var_98_2 = DeusBlessingSettings[iter_98_0]
		local var_98_3 = true

		if not var_98_2.is_permanent then
			local var_98_4 = arg_98_0._run_state:get_blessing_lifetime(iter_98_0) - 1

			arg_98_0._run_state:set_blessing_lifetime(iter_98_0, var_98_4)

			if var_98_4 <= 0 then
				var_98_3 = false
			end
		end

		if var_98_3 then
			var_98_1[iter_98_0] = iter_98_1
		end
	end

	arg_98_0._run_state:set_blessings_with_buyer(var_98_1)
end

DeusRunController._try_buy_blessing = function (arg_99_0, arg_99_1, arg_99_2)
	local var_99_0 = DeusBlessingSettings[arg_99_2]

	fassert(var_99_0, "No blessing with the name [%s] was found, check the blessings settings", arg_99_2)

	if arg_99_0:has_blessing(arg_99_2) then
		return false
	end

	local var_99_1 = arg_99_0._run_state:get_player_soft_currency(arg_99_1, var_0_1)
	local var_99_2 = DeusCostSettings.shop.blessings[arg_99_2]

	if var_99_1 < var_99_2 then
		return false
	end

	if var_99_0.grant_item then
		local var_99_3 = var_99_0.grant_item
		local var_99_4 = var_99_3.item_name
		local var_99_5 = var_99_3.slot_name
		local var_99_6, var_99_7 = arg_99_0._run_state:get_player_profile(arg_99_1, var_0_1)
		local var_99_8 = arg_99_0._run_state:get_player_additional_items(arg_99_1, var_0_1, var_99_6, var_99_7)

		local function var_99_9()
			local var_100_0 = SPProfiles[var_99_6].careers[var_99_7].name
			local var_100_1 = CareerSettings[var_100_0]
			local var_100_2 = var_100_1 and var_100_1.additional_item_slots

			if var_100_2 then
				local var_100_3 = var_100_2[var_99_5]

				if var_100_3 then
					return var_100_3 > (var_99_8[var_99_5] and #var_99_8[var_99_5].items or 0)
				else
					return false
				end
			else
				return false
			end
		end

		local function var_99_10()
			var_99_8 = table.clone(var_99_8)

			local var_101_0 = var_99_8[var_99_5] or {
				items = {}
			}

			var_101_0.items[#var_101_0.items + 1] = ItemMasterList[var_99_4]
			var_99_8[var_99_5] = var_101_0

			arg_99_0._run_state:set_player_additional_items(arg_99_1, var_0_1, var_99_6, var_99_7, var_99_8)
		end

		if var_99_5 == "slot_grenade" then
			if not arg_99_0._run_state:get_player_consumable_grenade_slot(arg_99_1, var_0_1, var_99_6, var_99_7) or not var_99_9() then
				arg_99_0._run_state:set_player_consumable_grenade_slot(arg_99_1, var_0_1, var_99_6, var_99_7, var_99_4)
			else
				var_99_10()
			end
		elseif var_99_5 == "slot_potion" then
			arg_99_0._run_state:set_player_consumable_potion_slot(arg_99_1, var_0_1, var_99_6, var_99_7, var_99_4)

			if not arg_99_0._run_state:get_player_consumable_potion_slot(arg_99_1, var_0_1, var_99_6, var_99_7) or not var_99_9() then
				arg_99_0._run_state:set_player_consumable_potion_slot(arg_99_1, var_0_1, var_99_6, var_99_7, var_99_4)
			else
				var_99_10()
			end
		elseif var_99_5 == "slot_healthkit" then
			arg_99_0._run_state:set_player_consumable_healthkit_slot(arg_99_1, var_0_1, var_99_6, var_99_7, var_99_4)

			if not arg_99_0._run_state:get_player_consumable_healthkit_slot(arg_99_1, var_0_1, var_99_6, var_99_7) or not var_99_9() then
				arg_99_0._run_state:set_player_consumable_healthkit_slot(arg_99_1, var_0_1, var_99_6, var_99_7, var_99_4)
			else
				var_99_10()
			end
		end
	elseif var_99_0.improve_all_weapons then
		local var_99_11 = var_99_0.improve_all_weapons
		local var_99_12 = arg_99_0._run_state:get_run_difficulty()
		local var_99_13 = var_99_11[DifficultySettings[var_99_12].rank] or var_99_11[DifficultySettings.normal.rank]
		local var_99_14 = arg_99_0._network_handler:get_peers()

		for iter_99_0 = 1, #var_99_14 do
			local var_99_15 = var_99_14[iter_99_0]
			local var_99_16, var_99_17 = arg_99_0._run_state:get_player_profile(var_99_15, var_0_1)
			local var_99_18 = arg_99_0._run_state:get_player_loadout(var_99_15, var_0_1, var_99_16, var_99_17, "slot_melee")
			local var_99_19 = arg_99_0._run_state:get_player_loadout(var_99_15, var_0_1, var_99_16, var_99_17, "slot_ranged")

			if var_99_18 then
				local var_99_20 = DeusWeaponGeneration.deserialize_weapon(var_99_18)

				var_99_20.power_level = var_99_20.power_level + var_99_13

				local var_99_21 = DeusWeaponGeneration.serialize_weapon(var_99_20)

				arg_99_0._run_state:set_player_loadout(var_99_15, var_0_1, var_99_16, var_99_17, "slot_melee", var_99_21)
			end

			if var_99_19 then
				local var_99_22 = DeusWeaponGeneration.deserialize_weapon(var_99_19)

				var_99_22.power_level = var_99_22.power_level + var_99_13

				local var_99_23 = DeusWeaponGeneration.serialize_weapon(var_99_22)

				arg_99_0._run_state:set_player_loadout(var_99_15, var_0_1, var_99_16, var_99_17, "slot_ranged", var_99_23)
			end
		end
	end

	local var_99_24 = arg_99_0._run_state:get_blessings_with_buyer()
	local var_99_25 = true
	local var_99_26 = table.clone(var_99_24, var_99_25)

	var_99_26[arg_99_2] = arg_99_1

	arg_99_0._run_state:set_blessings_with_buyer(var_99_26)
	arg_99_0._run_state:set_player_soft_currency(arg_99_1, var_0_1, var_99_1 - var_99_2)

	local var_99_27 = arg_99_0._run_state:get_bought_blessings()
	local var_99_28 = table.clone(var_99_27, var_99_25)

	var_99_28[#var_99_28 + 1] = arg_99_2

	arg_99_0._run_state:set_bought_blessings(var_99_28)
	arg_99_0:_add_coin_tracking_entry(arg_99_1, var_0_1, -var_99_2, "blessing")

	return true
end

DeusRunController._try_buy_power_up = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3)
	if arg_102_0:has_power_up(arg_102_1, arg_102_2.client_id) then
		return false
	end

	local var_102_0 = arg_102_2.rarity
	local var_102_1 = DeusCostSettings.shop.power_ups[var_102_0]
	local var_102_2 = var_102_1 - math.round(var_102_1 * arg_102_3)
	local var_102_3, var_102_4 = arg_102_0._run_state:get_player_profile(arg_102_1, var_0_1)
	local var_102_5 = arg_102_0._run_state:get_player_soft_currency(arg_102_1, var_0_1)

	if var_102_5 < var_102_2 then
		return false
	end

	local var_102_6 = arg_102_0._run_state:get_player_power_ups(arg_102_1, var_0_1, var_102_3, var_102_4)
	local var_102_7 = true
	local var_102_8 = table.clone(var_102_6, var_102_7)

	table.insert(var_102_8, arg_102_2)
	arg_102_0._run_state:set_player_power_ups(arg_102_1, var_0_1, var_102_3, var_102_4, var_102_8)

	local var_102_9 = var_102_5 - var_102_2

	arg_102_0._run_state:set_player_soft_currency(arg_102_1, var_0_1, var_102_9)

	local var_102_10 = arg_102_3 == 0 and var_102_0 .. "_power_up" or var_102_0 .. "_discounted_power_up"

	arg_102_0:_add_coin_tracking_entry(arg_102_1, var_0_1, -var_102_2, var_102_10)

	local var_102_11 = arg_102_0._run_state:get_bought_power_ups()
	local var_102_12 = table.clone(var_102_11, var_102_7)

	var_102_12[#var_102_12 + 1] = arg_102_2.name

	arg_102_0._run_state:set_bought_power_ups(var_102_12)

	return true
end

DeusRunController.grant_party_power_up = function (arg_103_0, arg_103_1, arg_103_2)
	if not arg_103_0._run_state:is_server() then
		ferror("DeusRunController:grant_party_power_up is designed to only be called on the server")
	end

	local var_103_0 = DeusPowerUpUtils.generate_specific_power_up(arg_103_1, arg_103_2)
	local var_103_1 = arg_103_0._run_state:get_party_power_ups()
	local var_103_2 = true
	local var_103_3 = table.clone(var_103_1, var_103_2)

	var_103_3[#var_103_3 + 1] = var_103_0

	arg_103_0._run_state:set_party_power_ups(var_103_3)

	return var_103_0
end

DeusRunController.get_player_profile = function (arg_104_0, arg_104_1, arg_104_2)
	local var_104_0, var_104_1 = arg_104_0._run_state:get_player_profile(arg_104_1, arg_104_2)

	return var_104_0, var_104_1
end

DeusRunController.get_player_level = function (arg_105_0, arg_105_1)
	return arg_105_0._run_state:get_player_level(arg_105_1)
end

DeusRunController.get_versus_player_level = function (arg_106_0, arg_106_1)
	return arg_106_0._run_state:get_versus_player_level(arg_106_1)
end

DeusRunController.get_player_name = function (arg_107_0, arg_107_1)
	return arg_107_0._run_state:get_player_name(arg_107_1)
end

DeusRunController.get_player_frame = function (arg_108_0, arg_108_1)
	return arg_108_0._run_state:get_player_frame(arg_108_1)
end

DeusRunController.get_player_health_state = function (arg_109_0, arg_109_1, arg_109_2)
	local var_109_0, var_109_1 = arg_109_0._run_state:get_player_profile(arg_109_1, arg_109_2)

	return arg_109_0._run_state:get_player_health_state(arg_109_1, arg_109_2, var_109_0, var_109_1)
end

DeusRunController.get_player_health_percentage = function (arg_110_0, arg_110_1, arg_110_2)
	local var_110_0, var_110_1 = arg_110_0._run_state:get_player_profile(arg_110_1, arg_110_2)

	return arg_110_0._run_state:get_player_health_percentage(arg_110_1, arg_110_2, var_110_0, var_110_1)
end

DeusRunController.get_player_melee_ammo = function (arg_111_0, arg_111_1, arg_111_2)
	local var_111_0, var_111_1 = arg_111_0._run_state:get_player_profile(arg_111_1, arg_111_2)

	return arg_111_0._run_state:get_player_melee_ammo(arg_111_1, arg_111_2, var_111_0, var_111_1)
end

DeusRunController.get_player_ranged_ammo = function (arg_112_0, arg_112_1, arg_112_2)
	local var_112_0, var_112_1 = arg_112_0._run_state:get_player_profile(arg_112_1, arg_112_2)

	return arg_112_0._run_state:get_player_ranged_ammo(arg_112_1, arg_112_2, var_112_0, var_112_1)
end

DeusRunController.get_player_health_percentage = function (arg_113_0, arg_113_1, arg_113_2)
	local var_113_0, var_113_1 = arg_113_0._run_state:get_player_profile(arg_113_1, arg_113_2)

	return arg_113_0._run_state:get_player_health_percentage(arg_113_1, arg_113_2, var_113_0, var_113_1)
end

DeusRunController.get_player_consumable_healthkit_slot = function (arg_114_0, arg_114_1, arg_114_2)
	local var_114_0, var_114_1 = arg_114_0._run_state:get_player_profile(arg_114_1, arg_114_2)

	return arg_114_0._run_state:get_player_consumable_healthkit_slot(arg_114_1, arg_114_2, var_114_0, var_114_1)
end

DeusRunController.get_player_consumable_potion_slot = function (arg_115_0, arg_115_1, arg_115_2)
	local var_115_0, var_115_1 = arg_115_0._run_state:get_player_profile(arg_115_1, arg_115_2)

	return arg_115_0._run_state:get_player_consumable_potion_slot(arg_115_1, arg_115_2, var_115_0, var_115_1)
end

DeusRunController.get_player_additional_items = function (arg_116_0, arg_116_1, arg_116_2)
	local var_116_0, var_116_1 = arg_116_0._run_state:get_player_profile(arg_116_1, arg_116_2)

	return arg_116_0._run_state:get_player_additional_items(arg_116_1, arg_116_2, var_116_0, var_116_1)
end

DeusRunController.get_player_consumable_grenade_slot = function (arg_117_0, arg_117_1, arg_117_2)
	local var_117_0, var_117_1 = arg_117_0._run_state:get_player_profile(arg_117_1, arg_117_2)

	return arg_117_0._run_state:get_player_consumable_grenade_slot(arg_117_1, arg_117_2, var_117_0, var_117_1)
end

DeusRunController.get_player_persistent_buffs = function (arg_118_0, arg_118_1, arg_118_2)
	local var_118_0, var_118_1 = arg_118_0._run_state:get_player_profile(arg_118_1, arg_118_2)

	return arg_118_0._run_state:get_player_persistent_buffs(arg_118_1, arg_118_2, var_118_0, var_118_1)
end

DeusRunController.restore_game_mode_data = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4)
	local var_119_0 = {}

	if not arg_119_0._run_state:get_player_spawned_once(arg_119_1, arg_119_2, arg_119_3, arg_119_4) then
		var_119_0.health_state = "alive"
		var_119_0.health_percentage = 1
		var_119_0.ammo = {
			slot_ranged = 1,
			slot_melee = 1
		}
		var_119_0.consumables = {}
		var_119_0.additional_items = {}

		local var_119_1 = arg_119_0._run_state:get_run_difficulty()
		local var_119_2 = DifficultySettings[var_119_1]

		var_119_0.consumables.slot_healthkit = var_119_2.slot_healthkit
		var_119_0.consumables.slot_potion = var_119_2.slot_potion
		var_119_0.consumables.slot_grenade = var_119_2.slot_grenade

		arg_119_0._run_state:set_player_spawned_once(arg_119_1, arg_119_2, arg_119_3, arg_119_4, true)
		arg_119_0:save_game_mode_data(arg_119_1, arg_119_2, arg_119_3, arg_119_4, var_119_0)
	else
		var_119_0.health_state = arg_119_0._run_state:get_player_health_state(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		var_119_0.health_percentage = arg_119_0._run_state:get_player_health_percentage(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		var_119_0.ammo = {
			slot_melee = arg_119_0._run_state:get_player_melee_ammo(arg_119_1, arg_119_2, arg_119_3, arg_119_4),
			slot_ranged = arg_119_0._run_state:get_player_ranged_ammo(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		}
		var_119_0.consumables = {}
		var_119_0.consumables.slot_healthkit = arg_119_0._run_state:get_player_consumable_healthkit_slot(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		var_119_0.consumables.slot_potion = arg_119_0._run_state:get_player_consumable_potion_slot(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		var_119_0.consumables.slot_grenade = arg_119_0._run_state:get_player_consumable_grenade_slot(arg_119_1, arg_119_2, arg_119_3, arg_119_4)

		local var_119_3 = true

		var_119_0.additional_items = table.clone(arg_119_0._run_state:get_player_additional_items(arg_119_1, arg_119_2, arg_119_3, arg_119_4), var_119_3)
	end

	return var_119_0
end

DeusRunController.save_game_mode_data = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4, arg_120_5)
	if arg_120_0._destroyed then
		return
	end

	local var_120_0 = arg_120_0._run_state:get_player_health_state(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local var_120_1 = arg_120_5.health_state

	if var_120_0 ~= var_120_1 then
		arg_120_0._run_state:set_player_health_state(arg_120_1, arg_120_2, arg_120_3, arg_120_4, var_120_1)
	end

	local var_120_2 = arg_120_0._run_state:get_player_health_percentage(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local var_120_3 = arg_120_5.health_percentage

	if not var_0_8(var_120_2, var_120_3) then
		arg_120_0._run_state:set_player_health_percentage(arg_120_1, arg_120_2, arg_120_3, arg_120_4, var_120_3)
	end

	local var_120_4 = arg_120_0._run_state:get_player_melee_ammo(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local var_120_5 = arg_120_5.ammo.slot_melee

	if not var_0_8(var_120_4, var_120_5) then
		arg_120_0._run_state:set_player_melee_ammo(arg_120_1, arg_120_2, arg_120_3, arg_120_4, var_120_5)
	end

	local var_120_6 = arg_120_0._run_state:get_player_ranged_ammo(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local var_120_7 = arg_120_5.ammo.slot_ranged

	if not var_0_8(var_120_6, var_120_7) then
		arg_120_0._run_state:set_player_ranged_ammo(arg_120_1, arg_120_2, arg_120_3, arg_120_4, var_120_7)
	end

	local var_120_8 = arg_120_0._run_state:get_player_consumable_healthkit_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local var_120_9 = arg_120_5.consumables.slot_healthkit

	if var_120_8 ~= var_120_9 then
		arg_120_0._run_state:set_player_consumable_healthkit_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4, var_120_9)
	end

	local var_120_10 = arg_120_0._run_state:get_player_consumable_potion_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local var_120_11 = arg_120_5.consumables.slot_potion

	if var_120_10 ~= var_120_11 then
		arg_120_0._run_state:set_player_consumable_potion_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4, var_120_11)
	end

	local var_120_12 = arg_120_0._run_state:get_player_consumable_grenade_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local var_120_13 = arg_120_5.consumables.slot_grenade

	if var_120_12 ~= var_120_13 then
		arg_120_0._run_state:set_player_consumable_grenade_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4, var_120_13)
	end

	local var_120_14 = arg_120_0._run_state:get_player_additional_items(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local var_120_15 = arg_120_5.additional_items
	local var_120_16 = false

	for iter_120_0, iter_120_1 in pairs(arg_120_5.additional_items) do
		local var_120_17 = var_120_14[iter_120_0]

		if not var_120_17 then
			var_120_16 = true

			break
		end

		local var_120_18 = iter_120_1.items
		local var_120_19 = var_120_17.items

		if #var_120_18 ~= #var_120_19 then
			var_120_16 = true

			break
		end

		for iter_120_2 = 1, #var_120_18 do
			if var_120_18[iter_120_2].key ~= var_120_19[iter_120_2].key then
				var_120_16 = true

				break
			end
		end

		if var_120_16 then
			break
		end
	end

	if var_120_16 then
		local var_120_20 = table.clone(var_120_15)

		arg_120_0._run_state:set_player_additional_items(arg_120_1, arg_120_2, arg_120_3, arg_120_4, var_120_20)
	end
end

DeusRunController.save_persistent_buffs = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3, arg_121_4, arg_121_5)
	if arg_121_0._destroyed then
		return
	end

	local var_121_0 = arg_121_0._run_state:get_player_persistent_buffs(arg_121_1, arg_121_2, arg_121_3, arg_121_4)
	local var_121_1 = false

	if #var_121_0 ~= #arg_121_5 then
		var_121_1 = true
	else
		for iter_121_0, iter_121_1 in ipairs(var_121_0) do
			var_121_1 = var_121_1 or var_121_0[iter_121_0] ~= arg_121_5[iter_121_0]
		end
	end

	if var_121_1 then
		arg_121_5 = table.clone(arg_121_5)

		arg_121_0._run_state:set_player_persistent_buffs(arg_121_1, arg_121_2, arg_121_3, arg_121_4, arg_121_5)
	end
end

DeusRunController.get_graph_data = function (arg_122_0)
	return arg_122_0:_get_graph_data()
end

DeusRunController._get_graph_data = function (arg_123_0)
	local var_123_0 = arg_123_0._run_state:get_arena_belakor_node()

	if var_123_0 and not arg_123_0._swapped_arena_belakor_node then
		local var_123_1 = arg_123_0._path_graph[var_123_0]

		var_123_1.minor_modifier_group = {}
		var_123_1.level_type = "ARENA"
		var_123_1.base_level = "arena_belakor"
		var_123_1.theme = "belakor"
		var_123_1.level = "arena_belakor"
		var_123_1.path = 1
		var_123_1.mutators = {}
		var_123_1.grant_random_power_up_count = 2
		var_123_1.curse = nil
		var_123_1.terror_event_power_up = nil
		var_123_1.terror_event_power_up_rarity = "unique"
		arg_123_0._swapped_arena_belakor_node = true
	end

	return arg_123_0._path_graph
end

DeusRunController.set_current_node_key = function (arg_124_0, arg_124_1)
	arg_124_0._run_state:set_current_node_key(arg_124_1)
end

DeusRunController.get_current_node_key = function (arg_125_0)
	return arg_125_0._run_state:get_current_node_key()
end

DeusRunController.get_coins_spent = function (arg_126_0)
	return arg_126_0._run_state:get_coins_spent()
end

DeusRunController.get_cursed_chests_purified = function (arg_127_0, arg_127_1)
	return arg_127_0._run_state:get_cursed_chests_purified(arg_127_1)
end

DeusRunController.get_current_node = function (arg_128_0)
	local var_128_0 = arg_128_0:get_current_node_key()

	return arg_128_0:_get_graph_data()[var_128_0]
end

DeusRunController.get_node = function (arg_129_0, arg_129_1)
	return arg_129_0:_get_graph_data()[arg_129_1]
end

DeusRunController.can_spawn_belakor_locus = function (arg_130_0)
	local var_130_0 = arg_130_0:_get_graph_data()[arg_130_0._run_state:get_current_node_key()]

	if var_130_0.base_level == "arena_belakor" then
		return true
	end

	if var_130_0.theme ~= "belakor" then
		return false
	end

	return var_130_0.possible_arena_belakor_nodes ~= nil
end

DeusRunController.unlock_arena_belakor = function (arg_131_0)
	if not arg_131_0._run_state:is_server() then
		ferror("DeusRunController:unlock_arena_belakor is designed to only be called on the server")
	end

	local var_131_0 = arg_131_0:_get_graph_data()[arg_131_0._run_state:get_current_node_key()]
	local var_131_1 = var_131_0.possible_arena_belakor_nodes

	if var_131_1 then
		local var_131_2 = var_131_0.level_seed
		local var_131_3, var_131_4 = Math.next_random(var_131_2, 1, #var_131_1)
		local var_131_5 = var_131_1[var_131_4]

		arg_131_0._run_state:set_arena_belakor_node(var_131_5)
	end
end

DeusRunController.get_weapon_pool = function (arg_132_0)
	local var_132_0 = arg_132_0:get_base_weapon_pool()
	local var_132_1 = table.clone(var_132_0)
	local var_132_2 = arg_132_0._run_state:get_own_weapon_pool_excludes()
	local var_132_3 = table.clone(var_132_2)

	for iter_132_0, iter_132_1 in pairs(var_132_3) do
		for iter_132_2, iter_132_3 in pairs(iter_132_1) do
			var_132_1[iter_132_0][iter_132_2] = nil
		end
	end

	local var_132_4 = DeusWeaponGeneration.get_weapon_pool_slot_amounts(var_132_0, var_132_1)
	local var_132_5 = DeusWeaponGroups
	local var_132_6 = {}

	for iter_132_4, iter_132_5 in pairs(var_132_1) do
		table.clear(var_132_6)

		for iter_132_6, iter_132_7 in pairs(var_132_4[iter_132_4]) do
			if iter_132_7 == 0 then
				table.insert(var_132_6, iter_132_6)
			end
		end

		if #var_132_6 > 0 then
			for iter_132_8, iter_132_9 in pairs(var_132_0[iter_132_4]) do
				local var_132_7 = var_132_5[iter_132_8].slot_type

				if table.contains(var_132_6, var_132_7) then
					var_132_2[iter_132_4][iter_132_8] = nil
					var_132_1[iter_132_4][iter_132_8] = var_132_0[iter_132_4][iter_132_8]
				end
			end
		end
	end

	arg_132_0._run_state:set_own_weapon_pool_excludes(var_132_2)

	return var_132_1
end

DeusRunController.get_slot_chances = function (arg_133_0)
	local var_133_0 = DeusSlotChance.melee
	local var_133_1 = DeusSlotChance.ranged
	local var_133_2 = DeusSlotChance.slot_chance_multiplier
	local var_133_3, var_133_4 = arg_133_0:get_own_loadout()

	if var_133_3 and var_133_4 then
		local var_133_5 = RaritySettings[var_133_3.rarity].order
		local var_133_6 = RaritySettings[var_133_4.rarity].order

		if var_133_6 < var_133_5 then
			var_133_1 = var_133_1 * var_133_2
		elseif var_133_5 < var_133_6 then
			var_133_0 = var_133_0 * var_133_2
		end
	end

	return var_133_0, var_133_1
end

DeusRunController.get_own_weapon_pool_excludes = function (arg_134_0)
	return arg_134_0._run_state:get_own_weapon_pool_excludes()
end

DeusRunController.get_base_weapon_pool = function (arg_135_0)
	local var_135_0 = arg_135_0._run_state:get_own_peer_id()
	local var_135_1, var_135_2 = arg_135_0._run_state:get_player_profile(var_135_0, var_0_1)
	local var_135_3 = SPProfiles[var_135_1].careers[var_135_2].name
	local var_135_4 = arg_135_0._run_state:get_own_weapon_pool_data()

	if not (var_135_4 and var_135_4.career_index == var_135_2 and var_135_4.profile_index == var_135_1) then
		local var_135_5 = DeusWeaponGeneration.generate_weapon_pool(var_135_3, arg_135_0._run_state:get_weapon_group_whitelist())

		var_135_4 = {
			profile_index = var_135_1,
			career_index = var_135_2,
			base_weapon_pool = var_135_5
		}

		arg_135_0._run_state:set_own_weapon_pool_data(var_135_4)
	end

	return var_135_4.base_weapon_pool
end

DeusRunController.purchase_chest = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3)
	local var_136_0 = arg_136_0._run_state:get_own_peer_id()
	local var_136_1 = arg_136_0._run_state:get_player_soft_currency(var_136_0, var_0_1)

	if var_136_1 < arg_136_3 then
		return false
	end

	local var_136_2 = var_136_1 - arg_136_3

	arg_136_0._run_state:set_player_soft_currency(var_136_0, var_0_1, var_136_2)

	local var_136_3 = (arg_136_1 and arg_136_1 .. "_" or "") .. arg_136_2 .. "_chest"

	arg_136_0:_add_coin_tracking_entry(var_136_0, var_0_1, -arg_136_3, var_136_3)
	arg_136_0:_record_chest_purchased_for_tracking(arg_136_1, arg_136_2)

	if not arg_136_0._run_state:is_server() then
		local var_136_4 = arg_136_0._run_state:get_server_peer_id()
		local var_136_5 = PEER_ID_TO_CHANNEL[var_136_4]
		local var_136_6 = NetworkLookup.rarities[arg_136_1 or "common"]
		local var_136_7 = NetworkLookup.deus_chest_types[arg_136_2]

		RPC.rpc_deus_chest_unlocked(var_136_5, arg_136_3, var_136_6, var_136_7)
	end

	return true
end

DeusRunController.remove_weapon_from_pool = function (arg_137_0, arg_137_1, arg_137_2)
	arg_137_0:_remove_weapon_from_pool(arg_137_1, arg_137_2)
end

DeusRunController._remove_weapon_from_pool = function (arg_138_0, arg_138_1, arg_138_2)
	local var_138_0 = arg_138_0._run_state:get_own_weapon_pool_excludes()
	local var_138_1 = DeusWeapons[arg_138_2].base_item
	local var_138_2 = RarityUtils.get_lower_rarities(arg_138_1)

	table.insert(var_138_2, arg_138_1)

	for iter_138_0, iter_138_1 in ipairs(var_138_2) do
		var_138_0[iter_138_1] = var_138_0[iter_138_1] or {}
		var_138_0[iter_138_1][var_138_1] = true
	end

	arg_138_0._run_state:set_own_weapon_pool_excludes(var_138_0)
end

DeusRunController.rpc_deus_chest_unlocked = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3, arg_139_4)
	local var_139_0 = CHANNEL_TO_PEER_ID[arg_139_1]
	local var_139_1 = NetworkLookup.rarities[arg_139_3]
	local var_139_2 = NetworkLookup.deus_chest_types[arg_139_4]
	local var_139_3 = arg_139_0._run_state:get_player_soft_currency(var_139_0, var_0_1) - arg_139_2

	arg_139_0._run_state:set_player_soft_currency(var_139_0, var_0_1, var_139_3)
	arg_139_0:_record_chest_purchased_for_tracking(var_139_1, var_139_2)

	local var_139_4

	if var_139_2 == DEUS_CHEST_TYPES.power_up then
		var_139_4 = var_139_2 .. "_chest"
	else
		var_139_4 = var_139_1 .. "_" .. var_139_2 .. "_chest"
	end

	arg_139_0:_add_coin_tracking_entry(var_139_0, var_0_1, -arg_139_2, var_139_4)
end

DeusRunController._record_chest_purchased_for_tracking = function (arg_140_0, arg_140_1, arg_140_2)
	if arg_140_2 == DEUS_CHEST_TYPES.power_up then
		local var_140_0 = arg_140_0._run_state:get_power_up_chests_used() + 1

		arg_140_0._run_state:set_power_up_chests_used(var_140_0)
	else
		local var_140_1

		if arg_140_2 == DEUS_CHEST_TYPES.swap_melee then
			var_140_1 = arg_140_0._run_state:get_melee_swap_chests_used()
		elseif arg_140_2 == DEUS_CHEST_TYPES.swap_ranged then
			var_140_1 = arg_140_0._run_state:get_ranged_swap_chests_used()
		elseif arg_140_2 == DEUS_CHEST_TYPES.upgrade then
			var_140_1 = arg_140_0._run_state:get_upgrade_chests_used()
		end

		fassert(var_140_1, "unknown %s chest_type", arg_140_2)

		local var_140_2 = true
		local var_140_3 = table.clone(var_140_1, var_140_2)

		var_140_3[arg_140_1] = var_140_3[arg_140_1] and var_140_3[arg_140_1] + 1 or 1

		if arg_140_2 == DEUS_CHEST_TYPES.swap_melee then
			arg_140_0._run_state:set_melee_swap_chests_used(var_140_3)
		elseif arg_140_2 == DEUS_CHEST_TYPES.swap_ranged then
			arg_140_0._run_state:set_ranged_swap_chests_used(var_140_3)
		elseif arg_140_2 == DEUS_CHEST_TYPES.upgrade then
			arg_140_0._run_state:set_upgrade_chests_used(var_140_3)
		end
	end
end

DeusRunController.set_twitch_level_vote = function (arg_141_0, arg_141_1)
	arg_141_0._run_state:set_twitch_level_vote(arg_141_1)
end

DeusRunController.get_twitch_level_vote = function (arg_142_0)
	return arg_142_0._run_state:get_twitch_level_vote()
end

DeusRunController.request_standard_twitch_level_vote = function (arg_143_0, arg_143_1)
	local var_143_0 = arg_143_0:get_graph_data()
	local var_143_1 = arg_143_0:get_current_node().next
	local var_143_2 = var_143_0[var_143_1[1]]
	local var_143_3 = var_143_0[var_143_1[2]]
	local var_143_4 = {
		TwitchVoteDeusSelectLevelNames[var_143_2.base_level],
		TwitchVoteDeusSelectLevelNames[var_143_3.base_level]
	}
	local var_143_5 = Application.user_setting("twitch_vote_time") or TwitchSettings.default_vote_time

	arg_143_1:register_vote(var_143_5, "standard_vote", nil, var_143_4, true)
end

DeusRunController.map_finished_voting = function (arg_144_0)
	arg_144_0._run_state:set_twitch_level_vote(nil)
end

DeusRunController._add_coin_tracking_entry = function (arg_145_0, arg_145_1, arg_145_2, arg_145_3, arg_145_4)
	local var_145_0 = arg_145_0._run_state

	if not var_145_0:is_server() then
		return
	end

	local var_145_1 = var_145_0:get_player_telemetry_id(arg_145_1, arg_145_2)
	local var_145_2 = var_145_0:get_run_id()

	Managers.telemetry_events:deus_coins_changed(var_145_1, var_145_2, arg_145_3, arg_145_4)

	if arg_145_3 > 0 then
		local var_145_3 = arg_145_0._run_state:get_coins_earned() + arg_145_3

		arg_145_0._run_state:set_coins_earned(var_145_3)
	else
		local var_145_4 = arg_145_0._run_state:get_coins_spent() + arg_145_3

		arg_145_0._run_state:set_coins_spent(var_145_4)
	end
end

DeusRunController.handle_level_start = function (arg_146_0)
	arg_146_0._level_start_time = os.time()
end

DeusRunController.handle_start_next_round = function (arg_147_0)
	arg_147_0._deus_weapon_chest_distribution = nil
end

DeusRunController.get_deus_weapon_chest_type = function (arg_148_0)
	local var_148_0 = arg_148_0._deus_weapon_chest_distribution

	if not var_148_0 or #var_148_0 == 0 then
		local var_148_1 = arg_148_0._run_state:get_current_node_key()
		local var_148_2 = arg_148_0:_get_graph_data()[var_148_1]
		local var_148_3 = var_148_2.level
		local var_148_4 = LevelSettings[var_148_3].deus_weapon_chest_distribution

		assert(var_148_4, string.format("No deus_weapon_chest_distribution set for %s", var_148_3))

		var_148_0 = {}

		for iter_148_0, iter_148_1 in pairs(var_148_4) do
			for iter_148_2 = 1, iter_148_1 do
				var_148_0[#var_148_0 + 1] = iter_148_0
			end
		end

		local var_148_5 = var_148_2.level_seed
		local var_148_6 = HashUtils.fnv32_hash(var_148_5)

		table.shuffle(var_148_0, var_148_6)

		arg_148_0._deus_weapon_chest_distribution = var_148_0
	end

	local var_148_7 = var_148_0[#var_148_0]

	var_148_0[#var_148_0] = nil

	return var_148_7
end

DeusRunController.get_level_ended_tracking_data = function (arg_149_0, arg_149_1, arg_149_2, arg_149_3)
	local var_149_0 = arg_149_0._level_start_time

	fassert(var_149_0, " DeusRunController:handle_level_start was never called")

	local var_149_1 = os.difftime(os.time(), var_149_0)
	local var_149_2 = arg_149_0._run_state
	local var_149_3 = var_149_2:get_current_node_key()
	local var_149_4 = arg_149_0:_get_graph_data()[var_149_3]
	local var_149_5 = var_149_4.run_progress
	local var_149_6 = arg_149_0._run_state:get_own_peer_id()
	local var_149_7 = PlayerUtils.unique_player_id(var_149_6, var_0_1)
	local var_149_8 = arg_149_1:get_stat(var_149_7, "times_revived")
	local var_149_9 = math.round(math.lerp(-DifficultyTweak.range, DifficultyTweak.range, var_149_5))

	return {
		run_id = var_149_2:get_run_id(),
		peer_ids = arg_149_0._network_handler:get_peers(),
		run_seed = var_149_2:get_run_seed(),
		journey_name = var_149_2:get_journey_name(),
		dominant_god = var_149_2:get_dominant_god(),
		difficulty = var_149_2:get_run_difficulty(),
		difficulty_tweak = var_149_9,
		level = var_149_4.base_level,
		path = var_149_4.path,
		curse = var_149_4.curse or "None",
		theme = var_149_4.theme,
		level_duration_in_seconds = var_149_1,
		game_won = arg_149_2,
		times_revived = var_149_8,
		num_bots = arg_149_3
	}
end

DeusRunController.get_level_started_tracking_data = function (arg_150_0, arg_150_1, arg_150_2)
	local var_150_0 = arg_150_0._run_state
	local var_150_1 = var_150_0:get_current_node_key()
	local var_150_2 = arg_150_0:_get_graph_data()[var_150_1]
	local var_150_3 = var_150_2.run_progress
	local var_150_4 = math.round(math.lerp(-DifficultyTweak.range, DifficultyTweak.range, var_150_3))

	return {
		run_id = var_150_0:get_run_id(),
		peer_ids = arg_150_0._network_handler:get_peers(),
		run_seed = var_150_0:get_run_seed(),
		journey_name = var_150_0:get_journey_name(),
		dominant_god = var_150_0:get_dominant_god(),
		difficulty = var_150_0:get_run_difficulty(),
		difficulty_tweak = var_150_4,
		level = var_150_2.base_level,
		path = var_150_2.path,
		curse = var_150_2.curse or "None",
		theme = var_150_2.theme,
		num_bots = arg_150_2
	}
end

DeusRunController.get_run_tracking_data = function (arg_151_0, arg_151_1)
	local var_151_0 = arg_151_0._run_start_time

	fassert(var_151_0, " DeusRunController:setup_run was never called")

	local var_151_1 = os.difftime(os.time(), var_151_0)
	local var_151_2 = arg_151_0._run_state
	local var_151_3 = var_151_2:get_own_peer_id()
	local var_151_4 = var_151_2:get_traversed_nodes()
	local var_151_5 = {}
	local var_151_6 = 0
	local var_151_7 = 0
	local var_151_8 = 0
	local var_151_9 = arg_151_0:_get_graph_data()

	for iter_151_0, iter_151_1 in ipairs(var_151_4) do
		local var_151_10 = var_151_9[iter_151_1]

		var_151_5[#var_151_5 + 1] = var_151_10.level

		if var_151_10.level_type == "SIGNATURE" then
			var_151_8 = var_151_8 + 1
		elseif var_151_10.level_type == "TRAVEL" then
			var_151_7 = var_151_7 + 1
		elseif var_151_10.level_type == "SHOP" then
			var_151_6 = var_151_6 + 1
		end
	end

	return {
		run_id = var_151_2:get_run_id(),
		run_duration_in_seconds = var_151_1,
		completed_levels = var_151_5,
		game_won = arg_151_1,
		blessings_boughts = var_151_2:get_bought_blessings(),
		power_ups_bought = var_151_2:get_bought_power_ups(),
		ground_coins_picked_up = var_151_2:get_ground_coins_picked_up(),
		monster_coins_picked_up = var_151_2:get_monster_coins_picked_up(),
		melee_swap_chests_used = var_151_2:get_melee_swap_chests_used(),
		ranged_swap_chests_used = var_151_2:get_ranged_swap_chests_used(),
		upgrade_chests_used = var_151_2:get_upgrade_chests_used(),
		power_up_chests_used = var_151_2:get_power_up_chests_used(),
		cursed_chests_used = var_151_2:get_cursed_chests_purified(var_151_3),
		coins_earned = var_151_2:get_coins_earned(),
		coins_spent = var_151_2:get_coins_spent(),
		shops_visited = var_151_6,
		signature_levels_completed = var_151_8,
		travel_levels_completed = var_151_7,
		host_migration_count = var_151_2:get_host_migration_count()
	}
end
