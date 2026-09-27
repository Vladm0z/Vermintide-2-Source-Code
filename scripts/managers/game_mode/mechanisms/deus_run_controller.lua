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

local tbl = {
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
local num = 1
local num_2 = 10000
local tbl_2 = {
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
local tbl_3 = {
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

local print = print

local function fn(...)
	-- function 1
	if not script_data.deus_run_controller_debug then
		print("[DeusRunController] ", ...)
	end
end

local function fn_2(...)
	-- function 2
	print("[DeusRunController] ", ...)
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	if not (arg_3_0 or arg_3_1) then
		return true
	elseif not (not arg_3_0 and arg_3_1) then
		return false
	end

	return math.round_with_precision(arg_3_0, 2) == math.round_with_precision(arg_3_1, 2)
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local var_4_0
	local var_4_1
	local num = arg_4_2 / arg_4_3

	if arg_4_0 <= 1 - DeusShopSettings.heal_amount then
		var_4_0 = arg_4_2
	else
		var_4_0 = 1 - arg_4_0
	end

	local ceil = math.ceil(var_4_0 / num)

	if arg_4_1 < ceil then
		ceil = arg_4_1
		var_4_0 = ceil * num
	end

	return var_4_0, ceil
end

DeusRunController.init = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
	-- function 5
	self._run_state = DeusRunState:new(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
	self._network_handler = arg_5_3
end

DeusRunController.network_context_created = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	self._run_state:network_context_created(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)

	self._network_handler = arg_6_5

	local num = self._run_state:get_host_migration_count() + 1

	self._run_state:set_host_migration_count(num)
end

DeusRunController.register_rpcs = function (self, arg_7_1)
	-- function 7
	self._network_event_delegate = arg_7_1

	arg_7_1:register(self, unpack(tbl))
	self._run_state:register_rpcs(arg_7_1)
end

DeusRunController.unregister_rpcs = function (self)
	-- function 8
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)
	end

	self._network_event_delegate = nil

	self._run_state:unregister_rpcs()
end

DeusRunController.full_sync = function (self)
	-- function 9
	self._run_state:full_sync()
end

DeusRunController.is_server = function (self)
	-- function 10
	return self._run_state:is_server()
end

DeusRunController.get_server_peer_id = function (self)
	-- function 11
	return self._run_state:server_peer_id()
end

DeusRunController.get_own_peer_id = function (self)
	-- function 12
	return self._run_state:own_peer_id()
end

DeusRunController.destroy = function (self)
	-- function 13
	self:unregister_rpcs()
	self._run_state:destroy()

	self._destroyed = true
end

DeusRunController.get_run_ended = function (self)
	-- function 14
	return self._run_state:get_run_ended()
end

DeusRunController.handle_run_ended = function (self)
	-- function 15
	self._run_state:set_run_ended(true)
end

DeusRunController.setup_run = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	-- function 16
	self._run_state:set_run_seed(arg_16_1)
	self._run_state:set_run_difficulty(arg_16_2)
	self._run_state:set_journey_name(arg_16_3)
	self._run_state:set_dominant_god(arg_16_4)
	self._run_state:set_belakor_enabled(arg_16_7)
	self._run_state:set_event_mutators(arg_16_8)
	self._run_state:set_event_boons(arg_16_9)

	local var_16_0 = DEUS_MAP_POPULATE_SETTINGS[arg_16_3]

	var_16_0 = var_16_0 or DEUS_MAP_POPULATE_SETTINGS.default
	self._path_graph = deus_generate_graph(arg_16_1, arg_16_3, arg_16_4, var_16_0, arg_16_7)

	self._run_state:set_current_node_key("start")

	self._run_start_time = os.time()

	self._run_state:set_own_player_telemetry_id(arg_16_6)

	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_profile, var_16_3 = self._run_state:get_player_profile(get_own_peer_id, num)
	local var_16_4
	local var_16_5
	local var_16_6

	if get_player_profile ~= 0 then
		local name = SPProfiles[get_player_profile].careers[var_16_3].name

		var_16_6 = self._run_state:get_own_initial_talents()[name]

		local var_16_8 = self._run_state:get_own_initial_loadout()[name]
		local slot_melee = var_16_8.slot_melee
		local slot_ranged = var_16_8.slot_ranged

		var_16_4 = DeusWeaponGeneration.serialize_weapon(slot_melee)
		var_16_5 = DeusWeaponGeneration.serialize_weapon(slot_ranged)
	end

	local get_run_id = self._run_state:get_run_id()

	if not self._run_state:is_server() then
		self._run_state:set_player_soft_currency(get_own_peer_id, num, arg_16_5)
		self._run_state:set_peer_initialized(get_own_peer_id, true)

		if get_player_profile ~= 0 then
			self:_add_initial_power_ups(get_own_peer_id, num, get_player_profile, var_16_3, var_16_6)
			self:_add_initial_weapons_to_loadout(get_own_peer_id, num, get_player_profile, var_16_3, var_16_4, var_16_5)
			self._run_state:set_profile_initialized(get_own_peer_id, num, get_player_profile, var_16_3, true)
		end

		Managers.telemetry_events:deus_run_started(get_run_id, arg_16_3, arg_16_1, arg_16_4, arg_16_2, #arg_16_8 > 0, arg_16_8, arg_16_9)
		self:_add_coin_tracking_entry(get_own_peer_id, num, arg_16_5, "set initial soft currency")
	else
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_16_13 = PEER_ID_TO_CHANNEL[get_server_peer_id]

		RPC.rpc_deus_set_initial_soft_currency(var_16_13, arg_16_5)

		if get_player_profile ~= 0 then
			self:_add_initial_power_ups(get_own_peer_id, num, get_player_profile, var_16_3, var_16_6)
			self:_add_initial_weapons_to_loadout(get_own_peer_id, num, get_player_profile, var_16_3, var_16_4, var_16_5)
			RPC.rpc_deus_set_initial_setup(var_16_13, get_player_profile, var_16_3, var_16_6, var_16_4, var_16_5)
		end
	end

	fn_2(sprintf("starting <%s> with seed <%s> on difficulty <%s> and dominant god <%s> with belakor <%s>", arg_16_3, arg_16_1, arg_16_2, arg_16_4, arg_16_7))
end

DeusRunController.is_weekly_event_packages_loaded = function (self)
	-- function 17
	return self._run_state:is_weekly_event_packages_loaded()
end

DeusRunController.get_state_revision = function (self)
	-- function 18
	return self._run_state:get_revision()
end

DeusRunController.rpc_deus_set_initial_soft_currency = function (self, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = CHANNEL_TO_PEER_ID[arg_19_1]

	if not self._run_state:get_peer_initialized(var_19_0) then
		local var_19_1
		local get_current_node_key = self._run_state:get_current_node_key()
		local _get_graph_data = self:_get_graph_data()
		local var_19_4 = _get_graph_data[get_current_node_key]

		if var_19_4.node_type == "ingame" then
			var_19_1 = var_19_4.run_progress
		else
			local get_traversed_nodes = self._run_state:get_traversed_nodes()

			for i = #get_traversed_nodes, 1, -1 do
				local var_19_6 = _get_graph_data[get_traversed_nodes[i]]

				if var_19_6.node_type == "ingame" then
					var_19_1 = var_19_6.run_progress

					break
				end
			end
		end

		var_19_1 = var_19_1 or 0

		local num_2 = DeusNewLoadoutSettings.coin_formula(var_19_1) + arg_19_2

		self._run_state:set_player_soft_currency(var_19_0, num, num_2)
		self._run_state:set_peer_initialized(var_19_0, true)
		self:_add_coin_tracking_entry(var_19_0, num, num_2, "set initial soft currency")
	end
end

DeusRunController.rpc_deus_set_initial_setup = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	-- function 20
	local var_20_0 = CHANNEL_TO_PEER_ID[arg_20_1]

	if not self._run_state:get_profile_initialized(var_20_0, num, arg_20_2, arg_20_3) then
		self:_add_initial_power_ups(var_20_0, num, arg_20_2, arg_20_3, arg_20_4)
		self:_add_initial_weapons_to_loadout(var_20_0, num, arg_20_2, arg_20_3, arg_20_5, arg_20_6)
		self._run_state:set_profile_initialized(var_20_0, num, arg_20_2, arg_20_3, true)
	end

	local get_granted_non_party_end_of_level_power_ups = self._run_state:get_granted_non_party_end_of_level_power_ups(var_20_0, num, arg_20_2, arg_20_3)

	for k, v in pairs(self:_get_graph_data()) do
		if not (not v.grant_random_power_up_count and table.index_of(get_granted_non_party_end_of_level_power_ups, k) ~= -1) then
			RPC.rpc_deus_grant_end_of_level_power_ups(arg_20_1, k)
		end
	end
end

DeusRunController.rpc_deus_grant_end_of_level_power_ups = function (self, arg_21_1, arg_21_2)
	-- function 21
	local var_21_0 = self:_get_graph_data()[arg_21_2]
	local grant_random_power_up_count = var_21_0.grant_random_power_up_count
	local terror_event_power_up_rarity = var_21_0.terror_event_power_up_rarity
	local get_own_peer_id = self._run_state:get_own_peer_id()
	local power_ups = var_21_0.system_seeds.power_ups

	power_ups = power_ups or 0

	local fnv32_hash = HashUtils.fnv32_hash(get_own_peer_id .. "_" .. power_ups)
	local run_progress = var_21_0.run_progress
	local get_player_profile, var_21_8 = self._run_state:get_player_profile(get_own_peer_id, num)
	local get_player_power_ups = self._run_state:get_player_power_ups(get_own_peer_id, num, get_player_profile, var_21_8)
	local name = SPProfiles[get_player_profile].careers[var_21_8].name
	local var_21_11
	local generate_random_power_ups, var_21_13 = DeusPowerUpUtils.generate_random_power_ups(fnv32_hash, grant_random_power_up_count, get_player_power_ups, self._run_state:get_run_difficulty(), run_progress, DeusPowerUpAvailabilityTypes.weapon_chest, name, terror_event_power_up_rarity)
	local flag = true
	local clone = table.clone(get_player_power_ups, flag)

	table.append(clone, var_21_13)

	local power_ups_to_encoded_string = DeusPowerUpUtils.power_ups_to_encoded_string(var_21_13)
	local get_server_peer_id = self._run_state:get_server_peer_id()
	local var_21_18 = PEER_ID_TO_CHANNEL[get_server_peer_id]
	local var_21_19 = arg_21_2

	RPC.rpc_deus_add_power_ups(var_21_18, power_ups_to_encoded_string, var_21_19)
end

DeusRunController.profile_changed = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	if self._run_state:get_own_peer_id() ~= arg_22_1 then
		return
	end

	if not self._run_state:get_profile_initialized(arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5) then
		return
	end

	local get_own_initial_bot_talents

	if not arg_22_5 then
		get_own_initial_bot_talents = self._run_state:get_own_initial_bot_talents()

		if not get_own_initial_bot_talents then
			-- Nothing
		end
	end

	get_own_initial_bot_talents = self._run_state:get_own_initial_talents()

	::label_22_0::

	local name = SPProfiles[arg_22_3].careers[arg_22_4].name
	local var_22_2 = get_own_initial_bot_talents[name]
	local get_own_initial_bot_loadout

	if not arg_22_5 then
		get_own_initial_bot_loadout = self._run_state:get_own_initial_bot_loadout()

		if not get_own_initial_bot_loadout then
			-- Nothing
		end
	end

	get_own_initial_bot_loadout = self._run_state:get_own_initial_loadout()

	::label_22_1::

	local var_22_4 = get_own_initial_bot_loadout[name]
	local slot_melee = var_22_4.slot_melee
	local slot_ranged = var_22_4.slot_ranged
	local serialize_weapon = DeusWeaponGeneration.serialize_weapon(slot_melee)
	local serialize_weapon_2 = DeusWeaponGeneration.serialize_weapon(slot_ranged)

	self:_add_initial_power_ups(arg_22_1, arg_22_2, arg_22_3, arg_22_4, var_22_2)
	self:_add_initial_weapons_to_loadout(arg_22_1, arg_22_2, arg_22_3, arg_22_4, serialize_weapon, serialize_weapon_2)

	if not self._run_state:is_server() then
		fassert(arg_22_3 ~= 0, "the host must have a profile assigned already")
		self._run_state:set_profile_initialized(arg_22_1, arg_22_2, arg_22_3, arg_22_4, true)
	else
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_22_10 = PEER_ID_TO_CHANNEL[get_server_peer_id]

		RPC.rpc_deus_set_initial_setup(var_22_10, arg_22_3, arg_22_4, var_22_2, serialize_weapon, serialize_weapon_2)
	end
end

DeusRunController._add_initial_power_ups = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	local tbl = {}

	for i = 1, #arg_23_5 do
		local var_23_1 = arg_23_5[i]

		if var_23_1 ~= 0 then
			local get_talent_power_up_from_tier_and_column, var_23_3 = DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(i, var_23_1)

			tbl[#tbl + 1] = DeusPowerUpUtils.generate_specific_power_up(get_talent_power_up_from_tier_and_column.name, var_23_3)
		end
	end

	local get_player_power_ups = self._run_state:get_player_power_ups(arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local flag = true
	local clone = table.clone(get_player_power_ups, flag)

	table.append(clone, tbl)

	local get_event_boons = self._run_state:get_event_boons()

	table.append(clone, get_event_boons)
	self._run_state:set_player_power_ups(arg_23_1, arg_23_2, arg_23_3, arg_23_4, clone)
end

DeusRunController._add_initial_weapons_to_loadout = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	self._run_state:set_player_loadout(arg_24_1, arg_24_2, arg_24_3, arg_24_4, "slot_melee", arg_24_5)
	self._run_state:set_player_loadout(arg_24_1, arg_24_2, arg_24_3, arg_24_4, "slot_ranged", arg_24_6)
end

DeusRunController.get_run_id = function (self)
	-- function 25
	return self._run_state:get_run_id()
end

DeusRunController.get_run_seed = function (self)
	-- function 26
	return self._run_state:get_run_seed()
end

DeusRunController.get_run_difficulty = function (self)
	-- function 27
	return self._run_state:get_run_difficulty()
end

DeusRunController.get_journey_name = function (self)
	-- function 28
	return self._run_state:get_journey_name()
end

DeusRunController.get_dominant_god = function (self)
	-- function 29
	return self._run_state:get_dominant_god()
end

DeusRunController.get_event_boons = function (self)
	-- function 30
	return self._run_state:get_event_boons()
end

DeusRunController.get_event_mutators = function (self)
	-- function 31
	return self._run_state:get_event_mutators()
end

DeusRunController.handle_level_won = function (self)
	-- function 32
	self:_blessings_handle_level_won()

	local num = self._run_state:get_completed_level_count() + 1

	self._run_state:set_completed_level_count(num)

	local get_traversed_nodes = self._run_state:get_traversed_nodes()
	local get_current_node_key = self._run_state:get_current_node_key()
	local flag = true
	local clone = table.clone(get_traversed_nodes, flag)

	clone[#clone + 1] = get_current_node_key

	self._run_state:set_traversed_nodes(clone)

	if not self:_get_graph_data()[get_current_node_key].curse then
		local get_peers = self._network_handler:get_peers()

		for i, v in ipairs(get_peers) do
			local num_2 = self._run_state:get_cursed_levels_completed(v) + 1

			self._run_state:set_cursed_levels_completed(v, num_2)
		end
	end
end

DeusRunController.handle_map_exited = function (self)
	-- function 33
	if not self._run_state:get_arena_belakor_node() then
		local get_peers = self._network_handler:get_peers()

		for i, v in ipairs(get_peers) do
			if not self._run_state:get_seen_arena_belakor_node(v) then
				self._run_state:set_seen_arena_belakor_node(v, true)
			end
		end
	end
end

DeusRunController.get_belakor_enabled = function (self)
	-- function 34
	return self._run_state:get_belakor_enabled()
end

DeusRunController.has_completed_current_node = function (self)
	-- function 35
	local get_current_node_key = self._run_state:get_current_node_key()

	if get_current_node_key == "start" then
		return false
	else
		local get_traversed_nodes = self._run_state:get_traversed_nodes()

		return table.contains(get_traversed_nodes, get_current_node_key)
	end
end

DeusRunController.handle_shrine_entered = function (self, arg_36_1)
	-- function 36
	self._run_state:set_current_node_key(arg_36_1)

	local get_traversed_nodes = self._run_state:get_traversed_nodes()
	local flag = true
	local clone = table.clone(get_traversed_nodes, flag)

	clone[#clone + 1] = arg_36_1

	self._run_state:set_traversed_nodes(clone)
end

DeusRunController.get_traversed_nodes = function (self)
	-- function 37
	local get_traversed_nodes = self._run_state:get_traversed_nodes()

	get_traversed_nodes = get_traversed_nodes or {}

	return get_traversed_nodes
end

DeusRunController.get_unreachable_nodes = function (self)
	-- function 38
	local get_current_node_key = self:get_current_node_key()
	local tbl = {
		[get_current_node_key] = true
	}
	local get_traversed_nodes = self._run_state:get_traversed_nodes()

	for i, v in ipairs(get_traversed_nodes) do
		tbl[v] = true
	end

	local _get_graph_data = self:_get_graph_data()

	local function fn(arg_39_0)
		-- function 39
		local var_39_0 = _get_graph_data[arg_39_0]

		for i, v in ipairs(var_39_0.next) do
			tbl[v] = true

			fn(v)
		end
	end

	fn(get_current_node_key)

	local tbl_2 = {}

	for k, v_2 in pairs(_get_graph_data) do
		if not tbl[k] then
			tbl_2[#tbl_2 + 1] = k
		end
	end

	return tbl_2
end

DeusRunController.get_visited_nodes = function (self)
	-- function 40
	local get_traversed_nodes = self:get_traversed_nodes()
	local get_current_node_key = self:get_current_node_key()
	local flag = true
	local clone = table.clone(get_traversed_nodes, flag)

	if not table.contains(clone, get_current_node_key) then
		table.insert(clone, get_current_node_key)
	end

	return clone
end

DeusRunController.get_completed_level_count = function (self)
	-- function 41
	return self._run_state:get_completed_level_count()
end

DeusRunController.get_map_visibility = function (self)
	-- function 42
	local _get_graph_data = self:_get_graph_data()
	local get_current_node_key = self._run_state:get_current_node_key()
	local get_traversed_nodes = self._run_state:get_traversed_nodes()

	get_traversed_nodes = get_traversed_nodes or {}

	local tbl = {}

	for k, v in pairs(_get_graph_data) do
		tbl[k] = DeusMapVisibilitySettings.STRONG_FOG_LEVEL
	end

	local function fn(arg_43_0)
		-- function 43
		tbl[arg_43_0] = DeusMapVisibilitySettings.WEAK_FOG_LEVEL

		local function fn(arg_44_0, arg_44_1)
			-- function 44
			if arg_44_1 > DeusMapVisibilitySettings.STRONG_FOG_LEVEL then
				return
			end

			tbl[arg_44_0] = math.min(tbl[arg_44_0], arg_44_1)

			for i, v in ipairs(_get_graph_data[arg_44_0].next) do
				fn(v, arg_44_1 + 1)
			end
		end

		for i, v in ipairs(_get_graph_data[arg_43_0].next) do
			fn(v, DeusMapVisibilitySettings.WEAK_FOG_LEVEL)
		end
	end

	fn(get_current_node_key)

	if not script_data.deus_fog_with_no_memory then
		for i, v_2 in ipairs(get_traversed_nodes) do
			tbl[v_2] = DeusMapVisibilitySettings.WEAK_FOG_LEVEL
		end

		tbl.start = DeusMapVisibilitySettings.WEAK_FOG_LEVEL
	else
		for i_2, v_3 in ipairs(get_traversed_nodes) do
			fn(v_3)
		end

		fn("start")
	end

	local get_arena_belakor_node = self._run_state:get_arena_belakor_node()

	if not get_arena_belakor_node then
		tbl[get_arena_belakor_node] = 0
	end

	tbl.final = 0

	return tbl
end

DeusRunController.get_end_of_level_rewards_arguments = function (self, arg_45_1, arg_45_2)
	-- function 45
	local get_completed_level_count = self._run_state:get_completed_level_count()
	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_soft_currency = self._run_state:get_player_soft_currency(get_own_peer_id, num)
	local get_current_node_key = self._run_state:get_current_node_key()
	local run_progress = self:_get_graph_data()[get_current_node_key].run_progress
	local get_run_difficulty = self._run_state:get_run_difficulty()
	local var_45_6 = tbl_3[get_run_difficulty][1]
	local var_45_7 = tbl_3[get_run_difficulty][2]

	return {
		deus_completed_level_count = get_completed_level_count,
		deus_soft_currency = get_player_soft_currency,
		deus_item_name = var_45_6,
		deus_num_duplicates = var_45_7,
		chest_upgrade_data = {
			quickplay = arg_45_2,
			game_won = arg_45_1,
			cursed_chests_purified = self._run_state:get_cursed_chests_purified(get_own_peer_id),
			cursed_levels_completed = self._run_state:get_cursed_levels_completed(get_own_peer_id),
			coin_chests_collected = self._run_state:get_coin_chests_collected(get_own_peer_id),
			run_progress = run_progress
		}
	}
end

DeusRunController.get_mission_results = function (self)
	-- function 46
	local tbl = {}
	local get_own_peer_id = self._run_state:get_own_peer_id()

	tbl[#tbl + 1] = {
		text = "deus_cursed_chests_purified",
		experience = self._run_state:get_cursed_chests_purified(get_own_peer_id) * DeusExperienceSettings.CURSED_CHESTS
	}
	tbl[#tbl + 1] = {
		text = "deus_cursed_levels_beaten",
		experience = self._run_state:get_cursed_levels_completed(get_own_peer_id) * DeusExperienceSettings.CURSES
	}
	tbl[#tbl + 1] = {
		text = "deus_coin_chests_collected",
		experience = self._run_state:get_coin_chests_collected(get_own_peer_id) * DeusExperienceSettings.COINS
	}

	return tbl
end

DeusRunController.record_cursed_chest_purified = function (self)
	-- function 47
	local get_peers = self._network_handler:get_peers()

	for i, v in ipairs(get_peers) do
		local num = self._run_state:get_cursed_chests_purified(v) + 1

		self._run_state:set_cursed_chests_purified(v, num)
	end
end

DeusRunController.save_persisted_score = function (self, arg_48_1, arg_48_2)
	-- function 48
	local split_unique_player_id, var_48_1 = PlayerUtils.split_unique_player_id(arg_48_2)
	local tbl = {}

	for i, v in ipairs(tbl_2) do
		if not arg_48_1:has_stat(unpack(v)) then
			tbl[i] = arg_48_1:get_stat(arg_48_2, unpack(v))
		else
			tbl[i] = 0
		end
	end

	self._run_state:set_persisted_score(split_unique_player_id, var_48_1, tbl)
end

DeusRunController.restore_persisted_score = function (self, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local unique_player_id = PlayerUtils.unique_player_id(arg_49_2, arg_49_3)
	local get_persisted_score = self._run_state:get_persisted_score(arg_49_2, arg_49_3)

	for i, v in ipairs(tbl_2) do
		local var_49_2 = get_persisted_score[i]
		local clone = table.clone(v)

		clone[#clone + 1] = var_49_2 or 0

		arg_49_1:set_non_persistent_stat(unique_player_id, unpack(clone))
	end
end

DeusRunController.save_scoreboard = function (self, arg_50_1)
	-- function 50
	self._run_state:set_scoreboard(arg_50_1)
end

DeusRunController.get_scoreboard = function (self)
	-- function 51
	return self._run_state:get_scoreboard()
end

DeusRunController.get_own_peer_id = function (self)
	-- function 52
	return self._run_state:get_own_peer_id()
end

DeusRunController.get_server_peer_id = function (self)
	-- function 53
	return self._run_state:get_server_peer_id()
end

DeusRunController.get_own_initial_talents = function (self)
	-- function 54
	return self._run_state:get_own_initial_talents()
end

DeusRunController.get_peers = function (self)
	-- function 55
	return self._network_handler:get_peers()
end

DeusRunController.set_own_player_avatar_info = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	-- function 56
	self._run_state:set_own_player_level(arg_56_1)
	self._run_state:set_own_versus_player_level(arg_56_4)
	self._run_state:set_own_player_frame(arg_56_3)
	self._run_state:set_own_player_name(arg_56_2)
end

DeusRunController.get_own_loadout = function (self)
	-- function 57
	if not self._destroyed then
		local get_own_peer_id = self._run_state:get_own_peer_id()
		local get_player_profile, var_57_2 = self._run_state:get_player_profile(get_own_peer_id, num)
		local name = SPProfiles[get_player_profile].careers[var_57_2].name
		local var_57_4 = self._run_state:get_own_initial_loadout()[name]
		local slot_melee = var_57_4.slot_melee
		local slot_ranged = var_57_4.slot_ranged

		return slot_melee, slot_ranged
	else
		local get_own_loadout_serialized, var_57_8 = self:get_own_loadout_serialized()
		local deserialize_weapon = DeusWeaponGeneration.deserialize_weapon(get_own_loadout_serialized)
		local deserialize_weapon_2 = DeusWeaponGeneration.deserialize_weapon(var_57_8)

		return deserialize_weapon, deserialize_weapon_2
	end
end

DeusRunController.get_own_loadout_serialized = function (self)
	-- function 58
	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_profile, var_58_2 = self._run_state:get_player_profile(get_own_peer_id, num)
	local get_player_loadout = self._run_state:get_player_loadout(get_own_peer_id, num, get_player_profile, var_58_2, "slot_melee")
	local get_player_loadout_2 = self._run_state:get_player_loadout(get_own_peer_id, num, get_player_profile, var_58_2, "slot_ranged")

	return get_player_loadout, get_player_loadout_2
end

DeusRunController.get_loadout = function (self, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	-- function 59
	local get_player_loadout = self._run_state:get_player_loadout(arg_59_1, arg_59_2, arg_59_3, arg_59_4, "slot_melee")
	local get_player_loadout_2 = self._run_state:get_player_loadout(arg_59_1, arg_59_2, arg_59_3, arg_59_4, "slot_ranged")
	local flag = not get_player_loadout and DeusWeaponGeneration.deserialize_weapon(get_player_loadout)
	local flag_2 = not get_player_loadout_2 and DeusWeaponGeneration.deserialize_weapon(get_player_loadout_2)

	return flag, flag_2
end

DeusRunController.save_loadout = function (self, arg_60_1, arg_60_2)
	-- function 60
	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_profile, var_60_2 = self._run_state:get_player_profile(get_own_peer_id, num)
	local serialize_weapon = DeusWeaponGeneration.serialize_weapon(arg_60_1)

	self._run_state:set_player_loadout(get_own_peer_id, num, get_player_profile, var_60_2, arg_60_2, serialize_weapon)

	if not self._run_state:is_server() then
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_60_5 = PEER_ID_TO_CHANNEL[get_server_peer_id]

		RPC.rpc_deus_save_loadout(var_60_5, arg_60_2, serialize_weapon)
	end
end

DeusRunController.rpc_deus_save_loadout = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	local var_61_0 = CHANNEL_TO_PEER_ID[arg_61_1]
	local get_player_profile, var_61_2 = self._run_state:get_player_profile(var_61_0, num)

	self._run_state:set_player_loadout(var_61_0, num, get_player_profile, var_61_2, arg_61_2, arg_61_3)
end

DeusRunController.on_soft_currency_picked_up = function (self, arg_62_1, arg_62_2)
	-- function 62
	local get_own_peer_id = self._run_state:get_own_peer_id()

	self:_add_soft_currency_to_peer(get_own_peer_id, arg_62_1)

	if not self._run_state:is_server() then
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_62_2 = PEER_ID_TO_CHANNEL[get_server_peer_id]

		RPC.rpc_deus_soft_currency_picked_up(var_62_2, arg_62_1, arg_62_2)
	elseif arg_62_2 == DeusSoftCurrencySettings.types.GROUND then
		local num = self._run_state:get_ground_coins_picked_up() + 1

		self._run_state:set_ground_coins_picked_up(num)
	elseif arg_62_2 == DeusSoftCurrencySettings.types.MONSTER then
		local num_2 = self._run_state:get_monster_coins_picked_up() + 1

		self._run_state:set_monster_coins_picked_up(num_2)
	end
end

DeusRunController.get_player_soft_currency = function (self, arg_63_1)
	-- function 63
	return self._run_state:get_player_soft_currency(arg_63_1, num)
end

DeusRunController.rpc_deus_soft_currency_picked_up = function (self, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	local var_64_0 = CHANNEL_TO_PEER_ID[arg_64_1]

	self:_add_soft_currency_to_peer(var_64_0, arg_64_2)
end

DeusRunController._add_soft_currency_to_peer = function (self, arg_65_1, arg_65_2)
	-- function 65
	local num_2 = self._run_state:get_coin_chests_collected(arg_65_1) + 1

	self._run_state:set_coin_chests_collected(arg_65_1, num_2)

	local num_3 = self._run_state:get_player_soft_currency(arg_65_1, num) + arg_65_2

	self._run_state:set_player_soft_currency(arg_65_1, num, num_3)
	self:_add_coin_tracking_entry(arg_65_1, num, arg_65_2, "add coins")
end

DeusRunController.grant_soft_currency = function (self, arg_66_1, arg_66_2)
	-- function 66
	self:_add_soft_currency_to_peer(arg_66_1, arg_66_2)
end

DeusRunController.get_shop_heal_data = function (self)
	-- function 67
	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_profile, var_67_2 = self._run_state:get_player_profile(get_own_peer_id, num)
	local get_player_health_percentage = self._run_state:get_player_health_percentage(get_own_peer_id, num, get_player_profile, var_67_2)
	local get_player_soft_currency = self._run_state:get_player_soft_currency(get_own_peer_id, num)
	local heal_amount = DeusShopSettings.heal_amount
	local heal_cost = DeusShopSettings.heal_cost
	local var_67_7, var_67_8 = fn_4(get_player_health_percentage, get_player_soft_currency, heal_amount, heal_cost)
	local var_67_9 = var_67_8

	return var_67_7, var_67_9
end

DeusRunController.shop_buy_health = function (self)
	-- function 68
	local get_own_peer_id = self._run_state:get_own_peer_id()

	if not (not self:_try_buy_health(get_own_peer_id) and self._run_state:is_server()) then
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_68_2 = PEER_ID_TO_CHANNEL[get_server_peer_id]

		RPC.rpc_deus_shop_heal_player(var_68_2)
	end
end

DeusRunController.shop_buy_blessing = function (self, arg_69_1)
	-- function 69
	if not (not self:_try_buy_blessing(self._run_state:get_own_peer_id(), arg_69_1) and self._run_state:is_server()) then
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_69_1 = PEER_ID_TO_CHANNEL[get_server_peer_id]

		RPC.rpc_deus_shop_blessing_selected(var_69_1, arg_69_1)
	end
end

DeusRunController.shop_buy_power_up = function (self, arg_70_1, arg_70_2)
	-- function 70
	local _try_buy_power_up = self:_try_buy_power_up(self._run_state:get_own_peer_id(), arg_70_1, arg_70_2)

	if not (not _try_buy_power_up and self._run_state:is_server()) then
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_70_2 = PEER_ID_TO_CHANNEL[get_server_peer_id]

		RPC.rpc_deus_shop_power_up_bought(var_70_2, arg_70_1.rarity, arg_70_1.name, arg_70_1.client_id, math.round(arg_70_2 * num_2))
	end

	if not _try_buy_power_up then
		local get_own_peer_id = self._run_state:get_own_peer_id()

		self:_check_set_completed(arg_70_1, true, get_own_peer_id, num)
	end
end

DeusRunController._try_buy_health = function (self, arg_71_1)
	-- function 71
	local get_player_profile, var_71_1 = self._run_state:get_player_profile(arg_71_1, num)
	local get_player_health_percentage = self._run_state:get_player_health_percentage(arg_71_1, num, get_player_profile, var_71_1)
	local get_player_soft_currency = self._run_state:get_player_soft_currency(arg_71_1, num)

	if get_player_health_percentage < 1 then
		local heal_amount = DeusShopSettings.heal_amount
		local heal_cost = DeusShopSettings.heal_cost
		local var_71_6, var_71_7 = fn_4(get_player_health_percentage, get_player_soft_currency, heal_amount, heal_cost)

		if var_71_7 <= get_player_soft_currency then
			local clamp = math.clamp(get_player_health_percentage + var_71_6, 0, 1)

			self._run_state:set_player_soft_currency(arg_71_1, num, get_player_soft_currency - var_71_7)
			self._run_state:set_player_health_percentage(arg_71_1, num, get_player_profile, var_71_1, clamp)
			self:_add_coin_tracking_entry(arg_71_1, num, -var_71_7, "health")

			return true
		end
	end

	return false
end

DeusRunController.rpc_deus_shop_heal_player = function (self, arg_72_1)
	-- function 72
	local var_72_0 = CHANNEL_TO_PEER_ID[arg_72_1]

	if not self:_try_buy_health(var_72_0) then
		local get_player_profile, var_72_2 = self._run_state:get_player_profile(var_72_0, num)
		local get_player_health_percentage = self._run_state:get_player_health_percentage(var_72_0, num, get_player_profile, var_72_2)
		local get_player_soft_currency = self._run_state:get_player_soft_currency(var_72_0, num)

		self._run_state:set_player_soft_currency(var_72_0, num, get_player_soft_currency)
		self._run_state:set_player_health_percentage(var_72_0, num, get_player_profile, var_72_2, get_player_health_percentage)
	end
end

DeusRunController.rpc_deus_shop_blessing_selected = function (self, arg_73_1, arg_73_2)
	-- function 73
	local var_73_0 = CHANNEL_TO_PEER_ID[arg_73_1]

	if not self:_try_buy_blessing(var_73_0, arg_73_2) then
		local get_blessings_with_buyer = self._run_state:get_blessings_with_buyer()
		local get_player_soft_currency = self._run_state:get_player_soft_currency(var_73_0, num)

		self._run_state:set_blessings_with_buyer(get_blessings_with_buyer)
		self._run_state:set_player_soft_currency(var_73_0, num, get_player_soft_currency)
	end
end

DeusRunController.rpc_deus_shop_power_up_bought = function (self, arg_74_1, arg_74_2, arg_74_3, arg_74_4, arg_74_5)
	-- function 74
	local var_74_0 = CHANNEL_TO_PEER_ID[arg_74_1]

	arg_74_5 = arg_74_5 / num_2

	local flag = true
	local clone = table.clone(DeusPowerUps[arg_74_2][arg_74_3], flag)

	clone.client_id = arg_74_4

	if not self:_try_buy_power_up(var_74_0, clone, arg_74_5) then
		local get_player_profile, var_74_4 = self._run_state:get_player_profile(var_74_0, num)
		local get_player_power_ups = self._run_state:get_player_power_ups(var_74_0, num, get_player_profile, var_74_4)
		local get_player_soft_currency = self._run_state:get_player_soft_currency(var_74_0, num)

		self._run_state:set_player_power_ups(var_74_0, num, get_player_profile, var_74_4, get_player_power_ups)
		self._run_state:set_player_soft_currency(var_74_0, num, get_player_soft_currency)
	end
end

DeusRunController.get_player_power_ups = function (self, arg_75_1, arg_75_2)
	-- function 75
	local get_player_profile, var_75_1 = self._run_state:get_player_profile(arg_75_1, arg_75_2)

	return (self._run_state:get_player_power_ups(arg_75_1, arg_75_2, get_player_profile, var_75_1))
end

DeusRunController.get_power_ups = function (self, arg_76_1, arg_76_2, arg_76_3, arg_76_4)
	-- function 76
	return (self._run_state:get_player_power_ups(arg_76_1, arg_76_2, arg_76_3, arg_76_4))
end

DeusRunController.get_party_power_ups = function (self)
	-- function 77
	return (self._run_state:get_party_power_ups())
end

DeusRunController.generate_random_power_ups = function (self, arg_78_1, arg_78_2, arg_78_3)
	-- function 78
	arg_78_3 = arg_78_3 or "0"

	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_current_node_key = self._run_state:get_current_node_key()
	local var_78_2 = self:_get_graph_data()[get_current_node_key]
	local power_ups = var_78_2.system_seeds.power_ups

	power_ups = power_ups or 0

	local fnv32_hash = HashUtils.fnv32_hash(arg_78_3 .. "_" .. get_own_peer_id .. "_" .. power_ups)
	local run_progress = var_78_2.run_progress
	local get_player_profile, var_78_7 = self._run_state:get_player_profile(get_own_peer_id, num)
	local get_player_power_ups = self._run_state:get_player_power_ups(get_own_peer_id, num, get_player_profile, var_78_7)
	local name = SPProfiles[get_player_profile].careers[var_78_7].name
	local var_78_10
	local generate_random_power_ups, var_78_12 = DeusPowerUpUtils.generate_random_power_ups(fnv32_hash, arg_78_1, get_player_power_ups, self._run_state:get_run_difficulty(), run_progress, arg_78_2, name)

	return var_78_12
end

local function fn_5(self, arg_79_1)
	-- function 79
	return table.find_func(self.rewards, function (arg_80_0, arg_80_1)
		-- function 80
		return arg_80_1.name ~= arg_79_1.name or arg_80_1.rarity == arg_79_1.rarity
	end)
end

DeusRunController.add_power_ups = function (self, arg_81_1, arg_81_2, arg_81_3)
	-- function 81
	if #arg_81_1 == 0 then
		return
	end

	fassert(arg_81_2, "Invalid local_player_id")

	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_profile, var_81_2 = self._run_state:get_player_profile(get_own_peer_id, arg_81_2)
	local get_player_power_ups = self._run_state:get_player_power_ups(get_own_peer_id, arg_81_2, get_player_profile, var_81_2)
	local flag = true
	local clone = table.clone(get_player_power_ups, flag)

	table.append(clone, arg_81_1)
	self._run_state:set_player_power_ups(get_own_peer_id, arg_81_2, get_player_profile, var_81_2, clone)

	if not self._run_state:is_server() then
		local power_ups_to_encoded_string = DeusPowerUpUtils.power_ups_to_encoded_string(arg_81_1)
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_81_8 = PEER_ID_TO_CHANNEL[get_server_peer_id]
		local str = ""

		RPC.rpc_deus_add_power_ups(var_81_8, power_ups_to_encoded_string, str)
	end

	local player = Managers.player:player(get_own_peer_id, arg_81_2)

	if not player then
		local has_extension = ScriptUnit.has_extension(player.player_unit, "buff_system")

		if not has_extension then
			has_extension:trigger_procs("on_boon_granted")
		end
	end

	local flag_2 = not player and player.player_unit

	if not flag_2 then
		local system = Managers.state.entity:system("buff_system")
		local get_talents_interface = Managers.backend:get_talents_interface()
		local get_interface = Managers.backend:get_interface("deus")

		for i = 1, #arg_81_1 do
			local var_81_16 = arg_81_1[i]

			DeusPowerUpUtils.activate_deus_power_up(var_81_16, system, get_talents_interface, get_interface, self, flag_2, get_player_profile, var_81_2)

			if not arg_81_3 then
				Managers.state.event:trigger("present_rewards", {
					{
						type = "deus_power_up",
						power_up = var_81_16
					}
				})
			end
		end
	end

	for j = 1, #arg_81_1 do
		local var_81_17 = arg_81_1[j]

		self:_check_set_completed(var_81_17, arg_81_3, get_own_peer_id, arg_81_2)
	end
end

DeusRunController.remove_power_ups = function (self, arg_82_1, arg_82_2)
	-- function 82
	fassert(arg_82_2, "[DeusRunController:remove_power_ups] Invalid local_player_id")

	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_profile, var_82_2 = self._run_state:get_player_profile(get_own_peer_id, arg_82_2)
	local get_player_power_ups = self._run_state:get_player_power_ups(get_own_peer_id, arg_82_2, get_player_profile, var_82_2)
	local var_82_4 = NetworkLookup.deus_power_up_templates[arg_82_1]
	local flag = true
	local clone = table.clone(get_player_power_ups, flag)
	local num = -1

	for i = 1, #clone do
		if clone[i].name == arg_82_1 then
			num = i

			break
		end
	end

	if num ~= -1 then
		local player = Managers.player:player(get_own_peer_id, arg_82_2)

		if not player then
			local has_extension = ScriptUnit.has_extension(player.player_unit, "buff_system")

			if not has_extension then
				local var_82_10 = clone[num]

				if not var_82_10 then
					local var_82_11 = DeusPowerUps[var_82_10.rarity][var_82_10.name]

					if not var_82_11 then
						local get_buff_type = has_extension:get_buff_type(var_82_11.buff_name)
						local flag_2 = not get_buff_type and get_buff_type.id

						if not flag_2 then
							has_extension:remove_buff(flag_2)
						end
					end
				end
			end
		end

		if not self._run_state:is_server() then
			table.swap_delete(clone, num)
			self._run_state:set_player_power_ups(get_own_peer_id, arg_82_2, get_player_profile, var_82_2, clone)
		else
			local get_server_peer_id = self._run_state:get_server_peer_id()
			local var_82_15 = PEER_ID_TO_CHANNEL[get_server_peer_id]

			RPC.rpc_deus_remove_power_up(var_82_15, var_82_4)
		end

		return true
	else
		return false
	end
end

DeusRunController._check_set_completed = function (self, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	-- function 83
	local var_83_0 = DeusPowerUpSetLookup[arg_83_1.rarity]

	var_83_0 = not var_83_0 and DeusPowerUpSetLookup[arg_83_1.rarity][arg_83_1.name]

	if not var_83_0 then
		return
	end

	for i = 1, #var_83_0 do
		repeat
			local var_83_1 = var_83_0[i]

			if not fn_5(var_83_1, arg_83_1) then
				break
			end

			local num = 0

			for j = 1, #var_83_1.pieces do
				local var_83_3 = var_83_1.pieces[j]

				if not self:has_power_up_by_name(arg_83_3, var_83_3.name, var_83_3.rarity) then
					num = num + 1
				end
			end

			local num_required_pieces = var_83_1.num_required_pieces

			num_required_pieces = num_required_pieces or #var_83_1.pieces

			if num == num_required_pieces then
				local select_array = table.select_array(var_83_1.rewards, function (arg_84_0, arg_84_1)
					-- function 84
					if not self:has_power_up_by_name(arg_83_3, arg_84_1.name, arg_84_1.rarity) then
						return DeusPowerUpUtils.generate_specific_power_up(arg_84_1.name, arg_84_1.rarity)
					end
				end)

				if not table.is_empty(select_array) then
					self:add_power_ups(select_array, arg_83_4, arg_83_2)
				end
			end
		until true
	end
end

DeusRunController.try_grant_end_of_level_deus_power_ups = function (self)
	-- function 85
	local get_current_node_key = self:get_current_node_key()
	local var_85_1 = self:_get_graph_data()[get_current_node_key]
	local grant_random_power_up_count = var_85_1.grant_random_power_up_count
	local terror_event_power_up_rarity = var_85_1.terror_event_power_up_rarity

	if not grant_random_power_up_count then
		local get_own_peer_id = self._run_state:get_own_peer_id()
		local power_ups = var_85_1.system_seeds.power_ups

		power_ups = power_ups or 0

		local fnv32_hash = HashUtils.fnv32_hash(get_own_peer_id .. "_" .. power_ups)
		local run_progress = var_85_1.run_progress
		local get_player_profile, var_85_9 = self._run_state:get_player_profile(get_own_peer_id, num)
		local get_player_power_ups = self._run_state:get_player_power_ups(get_own_peer_id, num, get_player_profile, var_85_9)
		local name = SPProfiles[get_player_profile].careers[var_85_9].name
		local generate_random_power_ups, var_85_13 = DeusPowerUpUtils.generate_random_power_ups(fnv32_hash, grant_random_power_up_count, get_player_power_ups, self._run_state:get_run_difficulty(), run_progress, DeusPowerUpAvailabilityTypes.weapon_chest, name, terror_event_power_up_rarity)
		local flag = true
		local clone = table.clone(get_player_power_ups, flag)

		table.append(clone, var_85_13)
		self._run_state:set_player_power_ups(get_own_peer_id, num, get_player_profile, var_85_9, clone)

		local get_granted_non_party_end_of_level_power_ups = self._run_state:get_granted_non_party_end_of_level_power_ups(get_own_peer_id, num, get_player_profile, var_85_9)
		local clone_2 = table.clone(get_granted_non_party_end_of_level_power_ups, flag)

		clone_2[#clone_2 + 1] = get_current_node_key

		self._run_state:set_granted_non_party_end_of_level_power_ups(get_own_peer_id, num, get_player_profile, var_85_9, clone_2)

		if not self._run_state:is_server() then
			local power_ups_to_encoded_string = DeusPowerUpUtils.power_ups_to_encoded_string(var_85_13)
			local get_server_peer_id = self._run_state:get_server_peer_id()
			local var_85_20 = PEER_ID_TO_CHANNEL[get_server_peer_id]
			local var_85_21 = get_current_node_key

			RPC.rpc_deus_add_power_ups(var_85_20, power_ups_to_encoded_string, var_85_21)
		end

		for i = 1, #var_85_13 do
			local var_85_22 = var_85_13[i]

			self:_check_set_completed(var_85_22, true, get_own_peer_id, num)
		end

		return var_85_13
	else
		local terror_event_power_up = var_85_1.terror_event_power_up

		if not terror_event_power_up then
			local generate_specific_power_up = DeusPowerUpUtils.generate_specific_power_up(terror_event_power_up, terror_event_power_up_rarity)
			local get_party_power_ups = self._run_state:get_party_power_ups()
			local flag_2 = true
			local clone_3 = table.clone(get_party_power_ups, flag_2)

			clone_3[#clone_3 + 1] = generate_specific_power_up

			self._run_state:set_party_power_ups(clone_3)

			return {
				generate_specific_power_up
			}
		end
	end
end

DeusRunController.get_arena_belakor_node = function (self)
	-- function 86
	return self._run_state:get_arena_belakor_node()
end

DeusRunController.has_own_seen_arena_belakor_node = function (self)
	-- function 87
	local get_own_peer_id = self._run_state:get_own_peer_id()

	return self._run_state:get_seen_arena_belakor_node(get_own_peer_id)
end

DeusRunController.rpc_deus_add_power_ups = function (self, arg_88_1, arg_88_2, arg_88_3)
	-- function 88
	local var_88_0 = CHANNEL_TO_PEER_ID[arg_88_1]
	local encoded_string_to_power_ups = DeusPowerUpUtils.encoded_string_to_power_ups(arg_88_2)
	local get_player_profile, var_88_3 = self._run_state:get_player_profile(var_88_0, num)
	local get_player_power_ups = self._run_state:get_player_power_ups(var_88_0, num, get_player_profile, var_88_3)
	local flag = true
	local clone = table.clone(get_player_power_ups, flag)

	table.append(encoded_string_to_power_ups, clone)
	self._run_state:set_player_power_ups(var_88_0, num, get_player_profile, var_88_3, encoded_string_to_power_ups)

	if arg_88_3 ~= "" then
		local get_granted_non_party_end_of_level_power_ups = self._run_state:get_granted_non_party_end_of_level_power_ups(var_88_0, num, get_player_profile, var_88_3)
		local clone_2 = table.clone(get_granted_non_party_end_of_level_power_ups, flag)

		clone_2[#clone_2 + 1] = arg_88_3

		self._run_state:set_granted_non_party_end_of_level_power_ups(var_88_0, num, get_player_profile, var_88_3, clone_2)
	end

	local player = Managers.player:player(var_88_0, num)

	if not player then
		local has_extension = ScriptUnit.has_extension(player.player_unit, "buff_system")

		if not has_extension then
			has_extension:trigger_procs("on_boon_granted")
		end
	end
end

DeusRunController.rpc_deus_remove_power_up = function (self, arg_89_1, arg_89_2)
	-- function 89
	local var_89_0 = CHANNEL_TO_PEER_ID[arg_89_1]
	local get_player_profile, var_89_2 = self._run_state:get_player_profile(var_89_0, num)
	local get_player_power_ups = self._run_state:get_player_power_ups(var_89_0, num, get_player_profile, var_89_2)
	local var_89_4 = NetworkLookup.deus_power_up_templates[arg_89_2]
	local flag = true
	local clone = table.clone(get_player_power_ups, flag)
	local num_2 = -1

	for i = 1, #clone do
		if clone[i].name == var_89_4 then
			num_2 = i

			break
		end
	end

	local player = Managers.player:player(var_89_0, num)

	if not player then
		local has_extension = ScriptUnit.has_extension(player.player_unit, "buff_system")

		if not has_extension then
			local var_89_10 = clone[num_2]

			if not var_89_10 then
				local var_89_11 = DeusPowerUps[var_89_10.rarity][var_89_10.name]

				if not var_89_11 then
					local get_buff_type = has_extension:get_buff_type(var_89_11.buff_name)
					local flag_2 = not get_buff_type and get_buff_type.id

					if not flag_2 then
						has_extension:remove_buff(flag_2)
					end
				end
			end
		end
	end

	table.swap_delete(clone, num_2)
	self._run_state:set_player_power_ups(var_89_0, num, get_player_profile, var_89_2, clone)
end

DeusRunController.get_blessings = function (self)
	-- function 90
	return self._run_state:get_blessings()
end

DeusRunController.get_blessings_with_buyer = function (self)
	-- function 91
	return self._run_state:get_blessings_with_buyer()
end

DeusRunController.has_blessing = function (self, arg_92_1)
	-- function 92
	local get_blessings = self._run_state:get_blessings()

	return table.contains(get_blessings, arg_92_1)
end

DeusRunController.generate_random_blessing_name = function (self)
	-- function 93
	local var_93_0
	local tbl = {}
	local get_current_node_key = self._run_state:get_current_node_key()
	local blessings = self:_get_graph_data()[get_current_node_key].system_seeds.blessings

	blessings = blessings or 0

	local DeusBlessingSettings = DeusBlessingSettings
	local get_blessings = self._run_state:get_blessings()

	for k, v in pairs(DeusBlessingSettings) do
		if not table.contains(get_blessings, k) then
			table.insert(tbl, k)
		end
	end

	if #tbl > 0 then
		local next_random, var_93_7 = Math.next_random(blessings, 1, #tbl)

		var_93_0 = tbl[var_93_7]
	end

	return var_93_0
end

DeusRunController.remove_blessing = function (self, arg_94_1)
	-- function 94
	local get_blessings_with_buyer = self._run_state:get_blessings_with_buyer()
	local flag = true
	local clone = table.clone(get_blessings_with_buyer, flag)

	for k, v in pairs(clone) do
		if arg_94_1 == k then
			clone[k] = nil
		end
	end

	self._run_state:set_blessings_with_buyer(clone)
end

DeusRunController.has_power_up = function (self, arg_95_1, arg_95_2)
	-- function 95
	local get_player_profile, var_95_1 = self._run_state:get_player_profile(arg_95_1, num)
	local get_player_power_ups = self._run_state:get_player_power_ups(arg_95_1, num, get_player_profile, var_95_1)

	for i, v in ipairs(get_player_power_ups) do
		if v.client_id == arg_95_2 then
			return true
		end
	end

	return false
end

DeusRunController.has_power_up_by_name = function (self, arg_96_1, arg_96_2, arg_96_3)
	-- function 96
	local get_player_profile, var_96_1 = self._run_state:get_player_profile(arg_96_1, num)
	local get_player_power_ups = self._run_state:get_player_power_ups(arg_96_1, num, get_player_profile, var_96_1)

	for i = 1, #get_player_power_ups do
		local var_96_3 = get_player_power_ups[i]

		if not (var_96_3.name ~= arg_96_2 or var_96_3.rarity ~= arg_96_3) then
			return true
		end
	end

	return false
end

DeusRunController.reached_max_power_ups = function (self, arg_97_1, arg_97_2)
	-- function 97
	local get_player_profile, var_97_1 = self._run_state:get_player_profile(arg_97_1, num)
	local get_player_power_ups = self._run_state:get_player_power_ups(arg_97_1, num, get_player_profile, var_97_1)
	local max_amount = DeusPowerUpTemplates[arg_97_2].max_amount
	local num_2 = 0

	for i, v in ipairs(get_player_power_ups) do
		if v.name == arg_97_2 then
			num_2 = num_2 + 1

			if max_amount <= num_2 then
				return true
			end
		end
	end

	return false
end

DeusRunController._blessings_handle_level_won = function (self)
	-- function 98
	local get_blessings_with_buyer = self._run_state:get_blessings_with_buyer()
	local tbl = {}

	for k, v in pairs(get_blessings_with_buyer) do
		local var_98_2 = DeusBlessingSettings[k]
		local flag = true

		if not var_98_2.is_permanent then
			local num = self._run_state:get_blessing_lifetime(k) - 1

			self._run_state:set_blessing_lifetime(k, num)

			if num <= 0 then
				flag = false
			end
		end

		if not flag then
			tbl[k] = v
		end
	end

	self._run_state:set_blessings_with_buyer(tbl)
end

DeusRunController._try_buy_blessing = function (self, arg_99_1, arg_99_2)
	-- function 99
	local var_99_0 = DeusBlessingSettings[arg_99_2]

	fassert(var_99_0, "No blessing with the name [%s] was found, check the blessings settings", arg_99_2)

	if not self:has_blessing(arg_99_2) then
		return false
	end

	local get_player_soft_currency = self._run_state:get_player_soft_currency(arg_99_1, num)
	local var_99_2 = DeusCostSettings.shop.blessings[arg_99_2]

	if get_player_soft_currency < var_99_2 then
		return false
	end

	if not var_99_0.grant_item then
		local grant_item = var_99_0.grant_item
		local item_name = grant_item.item_name
		local slot_name = grant_item.slot_name
		local get_player_profile, var_99_7 = self._run_state:get_player_profile(arg_99_1, num)
		local get_player_additional_items = self._run_state:get_player_additional_items(arg_99_1, num, get_player_profile, var_99_7)

		local function fn()
			-- function 100
			local name = SPProfiles[get_player_profile].careers[var_99_7].name
			local var_100_1 = CareerSettings[name]
			local flag = not var_100_1 and var_100_1.additional_item_slots

			if not flag then
				local var_100_3 = flag[slot_name]

				if not var_100_3 then
					local count

					if not get_player_additional_items[slot_name] then
						count = #get_player_additional_items[slot_name].items

						if not count then
							-- Nothing
						end
					end

					count = 0

					::label_100_0::

					return count < var_100_3
				else
					return false
				end
			else
				return false
			end
		end

		local function fn_2()
			-- function 101
			get_player_additional_items = table.clone(get_player_additional_items)

			local var_101_0 = get_player_additional_items[slot_name]

			var_101_0 = var_101_0 or {
				items = {}
			}
			var_101_0.items[#var_101_0.items + 1] = ItemMasterList[item_name]
			get_player_additional_items[slot_name] = var_101_0

			self._run_state:set_player_additional_items(arg_99_1, num, get_player_profile, var_99_7, get_player_additional_items)
		end

		if slot_name == "slot_grenade" then
			if not (not self._run_state:get_player_consumable_grenade_slot(arg_99_1, num, get_player_profile, var_99_7) and fn()) then
				self._run_state:set_player_consumable_grenade_slot(arg_99_1, num, get_player_profile, var_99_7, item_name)
			else
				fn_2()
			end
		elseif slot_name == "slot_potion" then
			self._run_state:set_player_consumable_potion_slot(arg_99_1, num, get_player_profile, var_99_7, item_name)

			if not (not self._run_state:get_player_consumable_potion_slot(arg_99_1, num, get_player_profile, var_99_7) and fn()) then
				self._run_state:set_player_consumable_potion_slot(arg_99_1, num, get_player_profile, var_99_7, item_name)
			else
				fn_2()
			end
		elseif slot_name == "slot_healthkit" then
			self._run_state:set_player_consumable_healthkit_slot(arg_99_1, num, get_player_profile, var_99_7, item_name)

			if not (not self._run_state:get_player_consumable_healthkit_slot(arg_99_1, num, get_player_profile, var_99_7) and fn()) then
				self._run_state:set_player_consumable_healthkit_slot(arg_99_1, num, get_player_profile, var_99_7, item_name)
			else
				fn_2()
			end
		end
	elseif not var_99_0.improve_all_weapons then
		local improve_all_weapons = var_99_0.improve_all_weapons
		local get_run_difficulty = self._run_state:get_run_difficulty()
		local var_99_13 = improve_all_weapons[DifficultySettings[get_run_difficulty].rank]

		var_99_13 = var_99_13 or improve_all_weapons[DifficultySettings.normal.rank]

		local get_peers = self._network_handler:get_peers()

		for i = 1, #get_peers do
			local var_99_15 = get_peers[i]
			local get_player_profile_2, var_99_17 = self._run_state:get_player_profile(var_99_15, num)
			local get_player_loadout = self._run_state:get_player_loadout(var_99_15, num, get_player_profile_2, var_99_17, "slot_melee")
			local get_player_loadout_2 = self._run_state:get_player_loadout(var_99_15, num, get_player_profile_2, var_99_17, "slot_ranged")

			if not get_player_loadout then
				local deserialize_weapon = DeusWeaponGeneration.deserialize_weapon(get_player_loadout)

				deserialize_weapon.power_level = deserialize_weapon.power_level + var_99_13

				local serialize_weapon = DeusWeaponGeneration.serialize_weapon(deserialize_weapon)

				self._run_state:set_player_loadout(var_99_15, num, get_player_profile_2, var_99_17, "slot_melee", serialize_weapon)
			end

			if not get_player_loadout_2 then
				local deserialize_weapon_2 = DeusWeaponGeneration.deserialize_weapon(get_player_loadout_2)

				deserialize_weapon_2.power_level = deserialize_weapon_2.power_level + var_99_13

				local serialize_weapon_2 = DeusWeaponGeneration.serialize_weapon(deserialize_weapon_2)

				self._run_state:set_player_loadout(var_99_15, num, get_player_profile_2, var_99_17, "slot_ranged", serialize_weapon_2)
			end
		end
	end

	local get_blessings_with_buyer = self._run_state:get_blessings_with_buyer()
	local flag = true
	local clone = table.clone(get_blessings_with_buyer, flag)

	clone[arg_99_2] = arg_99_1

	self._run_state:set_blessings_with_buyer(clone)
	self._run_state:set_player_soft_currency(arg_99_1, num, get_player_soft_currency - var_99_2)

	local get_bought_blessings = self._run_state:get_bought_blessings()
	local clone_2 = table.clone(get_bought_blessings, flag)

	clone_2[#clone_2 + 1] = arg_99_2

	self._run_state:set_bought_blessings(clone_2)
	self:_add_coin_tracking_entry(arg_99_1, num, -var_99_2, "blessing")

	return true
end

DeusRunController._try_buy_power_up = function (self, arg_102_1, arg_102_2, arg_102_3)
	-- function 102
	if not self:has_power_up(arg_102_1, arg_102_2.client_id) then
		return false
	end

	local rarity = arg_102_2.rarity
	local var_102_1 = DeusCostSettings.shop.power_ups[rarity]
	local num_2 = var_102_1 - math.round(var_102_1 * arg_102_3)
	local get_player_profile, var_102_4 = self._run_state:get_player_profile(arg_102_1, num)
	local get_player_soft_currency = self._run_state:get_player_soft_currency(arg_102_1, num)

	if get_player_soft_currency < num_2 then
		return false
	end

	local get_player_power_ups = self._run_state:get_player_power_ups(arg_102_1, num, get_player_profile, var_102_4)
	local flag = true
	local clone = table.clone(get_player_power_ups, flag)

	table.insert(clone, arg_102_2)
	self._run_state:set_player_power_ups(arg_102_1, num, get_player_profile, var_102_4, clone)

	local num_3 = get_player_soft_currency - num_2

	self._run_state:set_player_soft_currency(arg_102_1, num, num_3)

	local str

	if arg_102_3 == 0 then
		str = rarity .. "_power_up"

		if not str then
			-- Nothing
		end
	end

	str = rarity .. "_discounted_power_up"

	::label_102_0::

	self:_add_coin_tracking_entry(arg_102_1, num, -num_2, str)

	local get_bought_power_ups = self._run_state:get_bought_power_ups()
	local clone_2 = table.clone(get_bought_power_ups, flag)

	clone_2[#clone_2 + 1] = arg_102_2.name

	self._run_state:set_bought_power_ups(clone_2)

	return true
end

DeusRunController.grant_party_power_up = function (self, arg_103_1, arg_103_2)
	-- function 103
	if not self._run_state:is_server() then
		ferror("DeusRunController:grant_party_power_up is designed to only be called on the server")
	end

	local generate_specific_power_up = DeusPowerUpUtils.generate_specific_power_up(arg_103_1, arg_103_2)
	local get_party_power_ups = self._run_state:get_party_power_ups()
	local flag = true
	local clone = table.clone(get_party_power_ups, flag)

	clone[#clone + 1] = generate_specific_power_up

	self._run_state:set_party_power_ups(clone)

	return generate_specific_power_up
end

DeusRunController.get_player_profile = function (self, arg_104_1, arg_104_2)
	-- function 104
	local get_player_profile, var_104_1 = self._run_state:get_player_profile(arg_104_1, arg_104_2)

	return get_player_profile, var_104_1
end

DeusRunController.get_player_level = function (self, arg_105_1)
	-- function 105
	return self._run_state:get_player_level(arg_105_1)
end

DeusRunController.get_versus_player_level = function (self, arg_106_1)
	-- function 106
	return self._run_state:get_versus_player_level(arg_106_1)
end

DeusRunController.get_player_name = function (self, arg_107_1)
	-- function 107
	return self._run_state:get_player_name(arg_107_1)
end

DeusRunController.get_player_frame = function (self, arg_108_1)
	-- function 108
	return self._run_state:get_player_frame(arg_108_1)
end

DeusRunController.get_player_health_state = function (self, arg_109_1, arg_109_2)
	-- function 109
	local get_player_profile, var_109_1 = self._run_state:get_player_profile(arg_109_1, arg_109_2)

	return self._run_state:get_player_health_state(arg_109_1, arg_109_2, get_player_profile, var_109_1)
end

DeusRunController.get_player_health_percentage = function (self, arg_110_1, arg_110_2)
	-- function 110
	local get_player_profile, var_110_1 = self._run_state:get_player_profile(arg_110_1, arg_110_2)

	return self._run_state:get_player_health_percentage(arg_110_1, arg_110_2, get_player_profile, var_110_1)
end

DeusRunController.get_player_melee_ammo = function (self, arg_111_1, arg_111_2)
	-- function 111
	local get_player_profile, var_111_1 = self._run_state:get_player_profile(arg_111_1, arg_111_2)

	return self._run_state:get_player_melee_ammo(arg_111_1, arg_111_2, get_player_profile, var_111_1)
end

DeusRunController.get_player_ranged_ammo = function (self, arg_112_1, arg_112_2)
	-- function 112
	local get_player_profile, var_112_1 = self._run_state:get_player_profile(arg_112_1, arg_112_2)

	return self._run_state:get_player_ranged_ammo(arg_112_1, arg_112_2, get_player_profile, var_112_1)
end

DeusRunController.get_player_health_percentage = function (self, arg_113_1, arg_113_2)
	-- function 113
	local get_player_profile, var_113_1 = self._run_state:get_player_profile(arg_113_1, arg_113_2)

	return self._run_state:get_player_health_percentage(arg_113_1, arg_113_2, get_player_profile, var_113_1)
end

DeusRunController.get_player_consumable_healthkit_slot = function (self, arg_114_1, arg_114_2)
	-- function 114
	local get_player_profile, var_114_1 = self._run_state:get_player_profile(arg_114_1, arg_114_2)

	return self._run_state:get_player_consumable_healthkit_slot(arg_114_1, arg_114_2, get_player_profile, var_114_1)
end

DeusRunController.get_player_consumable_potion_slot = function (self, arg_115_1, arg_115_2)
	-- function 115
	local get_player_profile, var_115_1 = self._run_state:get_player_profile(arg_115_1, arg_115_2)

	return self._run_state:get_player_consumable_potion_slot(arg_115_1, arg_115_2, get_player_profile, var_115_1)
end

DeusRunController.get_player_additional_items = function (self, arg_116_1, arg_116_2)
	-- function 116
	local get_player_profile, var_116_1 = self._run_state:get_player_profile(arg_116_1, arg_116_2)

	return self._run_state:get_player_additional_items(arg_116_1, arg_116_2, get_player_profile, var_116_1)
end

DeusRunController.get_player_consumable_grenade_slot = function (self, arg_117_1, arg_117_2)
	-- function 117
	local get_player_profile, var_117_1 = self._run_state:get_player_profile(arg_117_1, arg_117_2)

	return self._run_state:get_player_consumable_grenade_slot(arg_117_1, arg_117_2, get_player_profile, var_117_1)
end

DeusRunController.get_player_persistent_buffs = function (self, arg_118_1, arg_118_2)
	-- function 118
	local get_player_profile, var_118_1 = self._run_state:get_player_profile(arg_118_1, arg_118_2)

	return self._run_state:get_player_persistent_buffs(arg_118_1, arg_118_2, get_player_profile, var_118_1)
end

DeusRunController.restore_game_mode_data = function (self, arg_119_1, arg_119_2, arg_119_3, arg_119_4)
	-- function 119
	local tbl = {}

	if not self._run_state:get_player_spawned_once(arg_119_1, arg_119_2, arg_119_3, arg_119_4) then
		tbl.health_state = "alive"
		tbl.health_percentage = 1
		tbl.ammo = {
			slot_ranged = 1,
			slot_melee = 1
		}
		tbl.consumables = {}
		tbl.additional_items = {}

		local get_run_difficulty = self._run_state:get_run_difficulty()
		local var_119_2 = DifficultySettings[get_run_difficulty]

		tbl.consumables.slot_healthkit = var_119_2.slot_healthkit
		tbl.consumables.slot_potion = var_119_2.slot_potion
		tbl.consumables.slot_grenade = var_119_2.slot_grenade

		self._run_state:set_player_spawned_once(arg_119_1, arg_119_2, arg_119_3, arg_119_4, true)
		self:save_game_mode_data(arg_119_1, arg_119_2, arg_119_3, arg_119_4, tbl)
	else
		tbl.health_state = self._run_state:get_player_health_state(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		tbl.health_percentage = self._run_state:get_player_health_percentage(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		tbl.ammo = {
			slot_melee = self._run_state:get_player_melee_ammo(arg_119_1, arg_119_2, arg_119_3, arg_119_4),
			slot_ranged = self._run_state:get_player_ranged_ammo(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		}
		tbl.consumables = {}
		tbl.consumables.slot_healthkit = self._run_state:get_player_consumable_healthkit_slot(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		tbl.consumables.slot_potion = self._run_state:get_player_consumable_potion_slot(arg_119_1, arg_119_2, arg_119_3, arg_119_4)
		tbl.consumables.slot_grenade = self._run_state:get_player_consumable_grenade_slot(arg_119_1, arg_119_2, arg_119_3, arg_119_4)

		local flag = true

		tbl.additional_items = table.clone(self._run_state:get_player_additional_items(arg_119_1, arg_119_2, arg_119_3, arg_119_4), flag)
	end

	return tbl
end

DeusRunController.save_game_mode_data = function (self, arg_120_1, arg_120_2, arg_120_3, arg_120_4, arg_120_5)
	-- function 120
	if not self._destroyed then
		return
	end

	local get_player_health_state = self._run_state:get_player_health_state(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local health_state = arg_120_5.health_state

	if get_player_health_state ~= health_state then
		self._run_state:set_player_health_state(arg_120_1, arg_120_2, arg_120_3, arg_120_4, health_state)
	end

	local get_player_health_percentage = self._run_state:get_player_health_percentage(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local health_percentage = arg_120_5.health_percentage

	if not fn_3(get_player_health_percentage, health_percentage) then
		self._run_state:set_player_health_percentage(arg_120_1, arg_120_2, arg_120_3, arg_120_4, health_percentage)
	end

	local get_player_melee_ammo = self._run_state:get_player_melee_ammo(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local slot_melee = arg_120_5.ammo.slot_melee

	if not fn_3(get_player_melee_ammo, slot_melee) then
		self._run_state:set_player_melee_ammo(arg_120_1, arg_120_2, arg_120_3, arg_120_4, slot_melee)
	end

	local get_player_ranged_ammo = self._run_state:get_player_ranged_ammo(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local slot_ranged = arg_120_5.ammo.slot_ranged

	if not fn_3(get_player_ranged_ammo, slot_ranged) then
		self._run_state:set_player_ranged_ammo(arg_120_1, arg_120_2, arg_120_3, arg_120_4, slot_ranged)
	end

	local get_player_consumable_healthkit_slot = self._run_state:get_player_consumable_healthkit_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local slot_healthkit = arg_120_5.consumables.slot_healthkit

	if get_player_consumable_healthkit_slot ~= slot_healthkit then
		self._run_state:set_player_consumable_healthkit_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4, slot_healthkit)
	end

	local get_player_consumable_potion_slot = self._run_state:get_player_consumable_potion_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local slot_potion = arg_120_5.consumables.slot_potion

	if get_player_consumable_potion_slot ~= slot_potion then
		self._run_state:set_player_consumable_potion_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4, slot_potion)
	end

	local get_player_consumable_grenade_slot = self._run_state:get_player_consumable_grenade_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local slot_grenade = arg_120_5.consumables.slot_grenade

	if get_player_consumable_grenade_slot ~= slot_grenade then
		self._run_state:set_player_consumable_grenade_slot(arg_120_1, arg_120_2, arg_120_3, arg_120_4, slot_grenade)
	end

	local get_player_additional_items = self._run_state:get_player_additional_items(arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	local additional_items = arg_120_5.additional_items
	local flag = false

	for k, v in pairs(arg_120_5.additional_items) do
		local var_120_17 = get_player_additional_items[k]

		if not var_120_17 then
			flag = true

			break
		end

		local items = v.items
		local items_2 = var_120_17.items

		if #items ~= #items_2 then
			flag = true

			break
		end

		for k_2 = 1, #items do
			if items[k_2].key ~= items_2[k_2].key then
				flag = true

				break
			end
		end

		if not flag then
			break
		end
	end

	if not flag then
		local clone = table.clone(additional_items)

		self._run_state:set_player_additional_items(arg_120_1, arg_120_2, arg_120_3, arg_120_4, clone)
	end
end

DeusRunController.save_persistent_buffs = function (self, arg_121_1, arg_121_2, arg_121_3, arg_121_4, arg_121_5)
	-- function 121
	if not self._destroyed then
		return
	end

	local get_player_persistent_buffs = self._run_state:get_player_persistent_buffs(arg_121_1, arg_121_2, arg_121_3, arg_121_4)
	local flag = false

	if #get_player_persistent_buffs ~= #arg_121_5 then
		flag = true
	else
		for i, v in ipairs(get_player_persistent_buffs) do
			flag = flag or get_player_persistent_buffs[i] ~= arg_121_5[i]
		end
	end

	if not flag then
		arg_121_5 = table.clone(arg_121_5)

		self._run_state:set_player_persistent_buffs(arg_121_1, arg_121_2, arg_121_3, arg_121_4, arg_121_5)
	end
end

DeusRunController.get_graph_data = function (self)
	-- function 122
	return self:_get_graph_data()
end

DeusRunController._get_graph_data = function (self)
	-- function 123
	local get_arena_belakor_node = self._run_state:get_arena_belakor_node()

	if not (not get_arena_belakor_node and self._swapped_arena_belakor_node) then
		local var_123_1 = self._path_graph[get_arena_belakor_node]

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
		self._swapped_arena_belakor_node = true
	end

	return self._path_graph
end

DeusRunController.set_current_node_key = function (self, arg_124_1)
	-- function 124
	self._run_state:set_current_node_key(arg_124_1)
end

DeusRunController.get_current_node_key = function (self)
	-- function 125
	return self._run_state:get_current_node_key()
end

DeusRunController.get_coins_spent = function (self)
	-- function 126
	return self._run_state:get_coins_spent()
end

DeusRunController.get_cursed_chests_purified = function (self, arg_127_1)
	-- function 127
	return self._run_state:get_cursed_chests_purified(arg_127_1)
end

DeusRunController.get_current_node = function (self)
	-- function 128
	local get_current_node_key = self:get_current_node_key()

	return self:_get_graph_data()[get_current_node_key]
end

DeusRunController.get_node = function (self, arg_129_1)
	-- function 129
	return self:_get_graph_data()[arg_129_1]
end

DeusRunController.can_spawn_belakor_locus = function (self)
	-- function 130
	local var_130_0 = self:_get_graph_data()[self._run_state:get_current_node_key()]

	if var_130_0.base_level == "arena_belakor" then
		return true
	end

	if var_130_0.theme ~= "belakor" then
		return false
	end

	return var_130_0.possible_arena_belakor_nodes ~= nil
end

DeusRunController.unlock_arena_belakor = function (self)
	-- function 131
	if not self._run_state:is_server() then
		ferror("DeusRunController:unlock_arena_belakor is designed to only be called on the server")
	end

	local var_131_0 = self:_get_graph_data()[self._run_state:get_current_node_key()]
	local possible_arena_belakor_nodes = var_131_0.possible_arena_belakor_nodes

	if not possible_arena_belakor_nodes then
		local level_seed = var_131_0.level_seed
		local next_random, var_131_4 = Math.next_random(level_seed, 1, #possible_arena_belakor_nodes)
		local var_131_5 = possible_arena_belakor_nodes[var_131_4]

		self._run_state:set_arena_belakor_node(var_131_5)
	end
end

DeusRunController.get_weapon_pool = function (self)
	-- function 132
	local get_base_weapon_pool = self:get_base_weapon_pool()
	local clone = table.clone(get_base_weapon_pool)
	local get_own_weapon_pool_excludes = self._run_state:get_own_weapon_pool_excludes()
	local clone_2 = table.clone(get_own_weapon_pool_excludes)

	for k, v in pairs(clone_2) do
		for k_2, v_2 in pairs(v) do
			clone[k][k_2] = nil
		end
	end

	local get_weapon_pool_slot_amounts = DeusWeaponGeneration.get_weapon_pool_slot_amounts(get_base_weapon_pool, clone)
	local DeusWeaponGroups = DeusWeaponGroups
	local tbl = {}

	for k_3, v_3 in pairs(clone) do
		table.clear(tbl)

		for k_4, v_4 in pairs(get_weapon_pool_slot_amounts[k_3]) do
			if v_4 == 0 then
				table.insert(tbl, k_4)
			end
		end

		if #tbl > 0 then
			for k_5, v_5 in pairs(get_base_weapon_pool[k_3]) do
				local slot_type = DeusWeaponGroups[k_5].slot_type

				if not table.contains(tbl, slot_type) then
					get_own_weapon_pool_excludes[k_3][k_5] = nil
					clone[k_3][k_5] = get_base_weapon_pool[k_3][k_5]
				end
			end
		end
	end

	self._run_state:set_own_weapon_pool_excludes(get_own_weapon_pool_excludes)

	return clone
end

DeusRunController.get_slot_chances = function (self)
	-- function 133
	local melee = DeusSlotChance.melee
	local ranged = DeusSlotChance.ranged
	local slot_chance_multiplier = DeusSlotChance.slot_chance_multiplier
	local get_own_loadout, var_133_4 = self:get_own_loadout()

	if not get_own_loadout and not var_133_4 then
		local order = RaritySettings[get_own_loadout.rarity].order
		local order_2 = RaritySettings[var_133_4.rarity].order

		if order_2 < order then
			ranged = ranged * slot_chance_multiplier
		elseif order < order_2 then
			melee = melee * slot_chance_multiplier
		end
	end

	return melee, ranged
end

DeusRunController.get_own_weapon_pool_excludes = function (self)
	-- function 134
	return self._run_state:get_own_weapon_pool_excludes()
end

DeusRunController.get_base_weapon_pool = function (self)
	-- function 135
	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_profile, var_135_2 = self._run_state:get_player_profile(get_own_peer_id, num)
	local name = SPProfiles[get_player_profile].careers[var_135_2].name
	local get_own_weapon_pool_data = self._run_state:get_own_weapon_pool_data()

	if not (not get_own_weapon_pool_data and get_own_weapon_pool_data.career_index ~= var_135_2 or get_own_weapon_pool_data.profile_index == get_player_profile) then
		local generate_weapon_pool = DeusWeaponGeneration.generate_weapon_pool(name, self._run_state:get_weapon_group_whitelist())

		get_own_weapon_pool_data = {
			profile_index = get_player_profile,
			career_index = var_135_2,
			base_weapon_pool = generate_weapon_pool
		}

		self._run_state:set_own_weapon_pool_data(get_own_weapon_pool_data)
	end

	return get_own_weapon_pool_data.base_weapon_pool
end

DeusRunController.purchase_chest = function (self, arg_136_1, arg_136_2, arg_136_3)
	-- function 136
	local get_own_peer_id = self._run_state:get_own_peer_id()
	local get_player_soft_currency = self._run_state:get_player_soft_currency(get_own_peer_id, num)

	if get_player_soft_currency < arg_136_3 then
		return false
	end

	local num_2 = get_player_soft_currency - arg_136_3

	self._run_state:set_player_soft_currency(get_own_peer_id, num, num_2)

	local str

	if not arg_136_1 then
		str = arg_136_1 .. "_"

		if not str then
			-- Nothing
		end
	end

	str = ""

	::label_136_0::

	local str_2 = str .. arg_136_2 .. "_chest"

	self:_add_coin_tracking_entry(get_own_peer_id, num, -arg_136_3, str_2)
	self:_record_chest_purchased_for_tracking(arg_136_1, arg_136_2)

	if not self._run_state:is_server() then
		local get_server_peer_id = self._run_state:get_server_peer_id()
		local var_136_6 = PEER_ID_TO_CHANNEL[get_server_peer_id]
		local var_136_7 = NetworkLookup.rarities[arg_136_1 or "common"]
		local var_136_8 = NetworkLookup.deus_chest_types[arg_136_2]

		RPC.rpc_deus_chest_unlocked(var_136_6, arg_136_3, var_136_7, var_136_8)
	end

	return true
end

DeusRunController.remove_weapon_from_pool = function (self, arg_137_1, arg_137_2)
	-- function 137
	self:_remove_weapon_from_pool(arg_137_1, arg_137_2)
end

DeusRunController._remove_weapon_from_pool = function (self, arg_138_1, arg_138_2)
	-- function 138
	local get_own_weapon_pool_excludes = self._run_state:get_own_weapon_pool_excludes()
	local base_item = DeusWeapons[arg_138_2].base_item
	local get_lower_rarities = RarityUtils.get_lower_rarities(arg_138_1)

	table.insert(get_lower_rarities, arg_138_1)

	for i, v in ipairs(get_lower_rarities) do
		local var_138_3 = get_own_weapon_pool_excludes[v]

		var_138_3 = var_138_3 or {}
		get_own_weapon_pool_excludes[v] = var_138_3
		get_own_weapon_pool_excludes[v][base_item] = true
	end

	self._run_state:set_own_weapon_pool_excludes(get_own_weapon_pool_excludes)
end

DeusRunController.rpc_deus_chest_unlocked = function (self, arg_139_1, arg_139_2, arg_139_3, arg_139_4)
	-- function 139
	local var_139_0 = CHANNEL_TO_PEER_ID[arg_139_1]
	local var_139_1 = NetworkLookup.rarities[arg_139_3]
	local var_139_2 = NetworkLookup.deus_chest_types[arg_139_4]
	local num_2 = self._run_state:get_player_soft_currency(var_139_0, num) - arg_139_2

	self._run_state:set_player_soft_currency(var_139_0, num, num_2)
	self:_record_chest_purchased_for_tracking(var_139_1, var_139_2)

	local var_139_4

	if var_139_2 == DEUS_CHEST_TYPES.power_up then
		var_139_4 = var_139_2 .. "_chest"
	else
		var_139_4 = var_139_1 .. "_" .. var_139_2 .. "_chest"
	end

	self:_add_coin_tracking_entry(var_139_0, num, -arg_139_2, var_139_4)
end

DeusRunController._record_chest_purchased_for_tracking = function (self, arg_140_1, arg_140_2)
	-- function 140
	if arg_140_2 == DEUS_CHEST_TYPES.power_up then
		local num = self._run_state:get_power_up_chests_used() + 1

		self._run_state:set_power_up_chests_used(num)
	else
		local var_140_1

		if arg_140_2 == DEUS_CHEST_TYPES.swap_melee then
			var_140_1 = self._run_state:get_melee_swap_chests_used()
		elseif arg_140_2 == DEUS_CHEST_TYPES.swap_ranged then
			var_140_1 = self._run_state:get_ranged_swap_chests_used()
		elseif arg_140_2 == DEUS_CHEST_TYPES.upgrade then
			var_140_1 = self._run_state:get_upgrade_chests_used()
		end

		fassert(var_140_1, "unknown %s chest_type", arg_140_2)

		local flag = true
		local clone = table.clone(var_140_1, flag)
		local num_2

		if not clone[arg_140_1] then
			num_2 = clone[arg_140_1] + 1

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = 1

		::label_140_0::

		clone[arg_140_1] = num_2

		if arg_140_2 == DEUS_CHEST_TYPES.swap_melee then
			self._run_state:set_melee_swap_chests_used(clone)
		elseif arg_140_2 == DEUS_CHEST_TYPES.swap_ranged then
			self._run_state:set_ranged_swap_chests_used(clone)
		elseif arg_140_2 == DEUS_CHEST_TYPES.upgrade then
			self._run_state:set_upgrade_chests_used(clone)
		end
	end
end

DeusRunController.set_twitch_level_vote = function (self, arg_141_1)
	-- function 141
	self._run_state:set_twitch_level_vote(arg_141_1)
end

DeusRunController.get_twitch_level_vote = function (self)
	-- function 142
	return self._run_state:get_twitch_level_vote()
end

DeusRunController.request_standard_twitch_level_vote = function (self, arg_143_1)
	-- function 143
	local get_graph_data = self:get_graph_data()
	local next = self:get_current_node().next
	local var_143_2 = get_graph_data[next[1]]
	local var_143_3 = get_graph_data[next[2]]
	local tbl = {
		TwitchVoteDeusSelectLevelNames[var_143_2.base_level],
		TwitchVoteDeusSelectLevelNames[var_143_3.base_level]
	}
	local user_setting = Application.user_setting("twitch_vote_time")

	user_setting = user_setting or TwitchSettings.default_vote_time

	arg_143_1:register_vote(user_setting, "standard_vote", nil, tbl, true)
end

DeusRunController.map_finished_voting = function (self)
	-- function 144
	self._run_state:set_twitch_level_vote(nil)
end

DeusRunController._add_coin_tracking_entry = function (self, arg_145_1, arg_145_2, arg_145_3, arg_145_4)
	-- function 145
	local _run_state = self._run_state

	if not _run_state:is_server() then
		return
	end

	local get_player_telemetry_id = _run_state:get_player_telemetry_id(arg_145_1, arg_145_2)
	local get_run_id = _run_state:get_run_id()

	Managers.telemetry_events:deus_coins_changed(get_player_telemetry_id, get_run_id, arg_145_3, arg_145_4)

	if arg_145_3 > 0 then
		local num = self._run_state:get_coins_earned() + arg_145_3

		self._run_state:set_coins_earned(num)
	else
		local num_2 = self._run_state:get_coins_spent() + arg_145_3

		self._run_state:set_coins_spent(num_2)
	end
end

DeusRunController.handle_level_start = function (self)
	-- function 146
	self._level_start_time = os.time()
end

DeusRunController.handle_start_next_round = function (self)
	-- function 147
	self._deus_weapon_chest_distribution = nil
end

DeusRunController.get_deus_weapon_chest_type = function (self)
	-- function 148
	local _deus_weapon_chest_distribution = self._deus_weapon_chest_distribution

	if not (not _deus_weapon_chest_distribution and #_deus_weapon_chest_distribution ~= 0) then
		local get_current_node_key = self._run_state:get_current_node_key()
		local var_148_2 = self:_get_graph_data()[get_current_node_key]
		local level = var_148_2.level
		local deus_weapon_chest_distribution = LevelSettings[level].deus_weapon_chest_distribution

		assert(deus_weapon_chest_distribution, string.format("No deus_weapon_chest_distribution set for %s", level))

		_deus_weapon_chest_distribution = {}

		for k, v in pairs(deus_weapon_chest_distribution) do
			for k_2 = 1, v do
				_deus_weapon_chest_distribution[#_deus_weapon_chest_distribution + 1] = k
			end
		end

		local level_seed = var_148_2.level_seed
		local fnv32_hash = HashUtils.fnv32_hash(level_seed)

		table.shuffle(_deus_weapon_chest_distribution, fnv32_hash)

		self._deus_weapon_chest_distribution = _deus_weapon_chest_distribution
	end

	local var_148_7 = _deus_weapon_chest_distribution[#_deus_weapon_chest_distribution]

	_deus_weapon_chest_distribution[#_deus_weapon_chest_distribution] = nil

	return var_148_7
end

DeusRunController.get_level_ended_tracking_data = function (self, arg_149_1, arg_149_2, arg_149_3)
	-- function 149
	local _level_start_time = self._level_start_time

	fassert(_level_start_time, " DeusRunController:handle_level_start was never called")

	local difftime = os.difftime(os.time(), _level_start_time)
	local _run_state = self._run_state
	local get_current_node_key = _run_state:get_current_node_key()
	local var_149_4 = self:_get_graph_data()[get_current_node_key]
	local run_progress = var_149_4.run_progress
	local get_own_peer_id = self._run_state:get_own_peer_id()
	local unique_player_id = PlayerUtils.unique_player_id(get_own_peer_id, num)
	local get_stat = arg_149_1:get_stat(unique_player_id, "times_revived")
	local round = math.round(math.lerp(-DifficultyTweak.range, DifficultyTweak.range, run_progress))
	local tbl = {
		run_id = _run_state:get_run_id(),
		peer_ids = self._network_handler:get_peers(),
		run_seed = _run_state:get_run_seed(),
		journey_name = _run_state:get_journey_name(),
		dominant_god = _run_state:get_dominant_god(),
		difficulty = _run_state:get_run_difficulty(),
		difficulty_tweak = round,
		level = var_149_4.base_level,
		path = var_149_4.path
	}
	local curse = var_149_4.curse

	curse = curse or "None"
	tbl.curse = curse
	tbl.theme = var_149_4.theme
	tbl.level_duration_in_seconds = difftime
	tbl.game_won = arg_149_2
	tbl.times_revived = get_stat
	tbl.num_bots = arg_149_3

	return tbl
end

DeusRunController.get_level_started_tracking_data = function (self, arg_150_1, arg_150_2)
	-- function 150
	local _run_state = self._run_state
	local get_current_node_key = _run_state:get_current_node_key()
	local var_150_2 = self:_get_graph_data()[get_current_node_key]
	local run_progress = var_150_2.run_progress
	local round = math.round(math.lerp(-DifficultyTweak.range, DifficultyTweak.range, run_progress))
	local tbl = {
		run_id = _run_state:get_run_id(),
		peer_ids = self._network_handler:get_peers(),
		run_seed = _run_state:get_run_seed(),
		journey_name = _run_state:get_journey_name(),
		dominant_god = _run_state:get_dominant_god(),
		difficulty = _run_state:get_run_difficulty(),
		difficulty_tweak = round,
		level = var_150_2.base_level,
		path = var_150_2.path
	}
	local curse = var_150_2.curse

	curse = curse or "None"
	tbl.curse = curse
	tbl.theme = var_150_2.theme
	tbl.num_bots = arg_150_2

	return tbl
end

DeusRunController.get_run_tracking_data = function (self, arg_151_1)
	-- function 151
	local _run_start_time = self._run_start_time

	fassert(_run_start_time, " DeusRunController:setup_run was never called")

	local difftime = os.difftime(os.time(), _run_start_time)
	local _run_state = self._run_state
	local get_own_peer_id = _run_state:get_own_peer_id()
	local get_traversed_nodes = _run_state:get_traversed_nodes()
	local tbl = {}
	local num = 0
	local num_2 = 0
	local num_3 = 0
	local _get_graph_data = self:_get_graph_data()

	for i, v in ipairs(get_traversed_nodes) do
		local var_151_10 = _get_graph_data[v]

		tbl[#tbl + 1] = var_151_10.level

		if var_151_10.level_type == "SIGNATURE" then
			num_3 = num_3 + 1
		elseif var_151_10.level_type == "TRAVEL" then
			num_2 = num_2 + 1
		elseif var_151_10.level_type == "SHOP" then
			num = num + 1
		end
	end

	return {
		run_id = _run_state:get_run_id(),
		run_duration_in_seconds = difftime,
		completed_levels = tbl,
		game_won = arg_151_1,
		blessings_boughts = _run_state:get_bought_blessings(),
		power_ups_bought = _run_state:get_bought_power_ups(),
		ground_coins_picked_up = _run_state:get_ground_coins_picked_up(),
		monster_coins_picked_up = _run_state:get_monster_coins_picked_up(),
		melee_swap_chests_used = _run_state:get_melee_swap_chests_used(),
		ranged_swap_chests_used = _run_state:get_ranged_swap_chests_used(),
		upgrade_chests_used = _run_state:get_upgrade_chests_used(),
		power_up_chests_used = _run_state:get_power_up_chests_used(),
		cursed_chests_used = _run_state:get_cursed_chests_purified(get_own_peer_id),
		coins_earned = _run_state:get_coins_earned(),
		coins_spent = _run_state:get_coins_spent(),
		shops_visited = num,
		signature_levels_completed = num_3,
		travel_levels_completed = num_2,
		host_migration_count = _run_state:get_host_migration_count()
	}
end
