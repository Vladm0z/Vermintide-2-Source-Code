-- chunkname: @scripts/managers/player/player_manager.lua

require("scripts/helpers/player_utils")
require("scripts/settings/player_unit_damage_settings")
require("scripts/managers/player/bulldozer_player")
require("scripts/managers/player/remote_player")
require("scripts/managers/player/player_bot")
require("scripts/managers/player/player_sync_data")
require("scripts/helpers/loadout_utils")

PlayerManager = class(PlayerManager)
PlayerManager.MAX_PLAYERS = 4

local var_0_0 = {}

for iter_0_0 = 1, #SPProfiles do
	var_0_0[SPProfiles[iter_0_0].index] = iter_0_0 + 1
end

PlayerManager.init = function (arg_1_0)
	arg_1_0._players = {}
	arg_1_0._players_by_peer = {}
	arg_1_0._num_human_players = 0
	arg_1_0._human_players = {}
	arg_1_0._unit_owners = {}
	arg_1_0._player_units_owners = {}
	arg_1_0._local_human_player = nil
	arg_1_0._player_loadouts = {}
	arg_1_0._ui_id_increment = 0
end

local var_0_1 = {
	"rpc_to_client_spawn_player",
	"rpc_set_observed_unit",
	"rpc_sync_loadout_slot"
}

PlayerManager.set_is_server = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.is_server = arg_2_1

	arg_2_2:register(arg_2_0, unpack(var_0_1))

	arg_2_0.network_event_delegate = arg_2_2
	arg_2_0.network_manager = arg_2_3

	for iter_2_0, iter_2_1 in pairs(arg_2_0._players) do
		if not iter_2_1.remote then
			iter_2_1.is_server = arg_2_1
		end

		iter_2_1.network_manager = arg_2_3
	end
end

PlayerManager.set_statistics_db = function (arg_3_0, arg_3_1)
	arg_3_0._statistics_db = arg_3_1
end

PlayerManager.statistics_db = function (arg_4_0)
	return arg_4_0._statistics_db
end

PlayerManager.player_loadouts = function (arg_5_0)
	return arg_5_0._player_loadouts
end

PlayerManager.rpc_sync_loadout_slot = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	if not Managers.state.network:in_game_session() then
		return
	end

	local var_6_0, var_6_1 = LoadoutUtils.create_loadout_item_from_rpc_data(arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	local var_6_2 = PlayerUtils.unique_player_id(arg_6_2, arg_6_3)

	arg_6_0._player_loadouts[var_6_2] = arg_6_0._player_loadouts[var_6_2] or {}
	arg_6_0._player_loadouts[var_6_2][var_6_0] = var_6_1

	if arg_6_0.is_server and arg_6_2 ~= Network.peer_id() then
		arg_6_0.network_manager.network_transmit:send_rpc_clients("rpc_sync_loadout_slot", arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	end
end

PlayerManager.rpc_to_client_spawn_player = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12, arg_7_13, arg_7_14, arg_7_15, arg_7_16)
	if script_data.network_debug_connections then
		printf("PlayerManager:rpc_to_client_spawn_player(%s, %s, %s, %s)", tostring(arg_7_1), tostring(arg_7_3), tostring(arg_7_5), tostring(arg_7_6))
	end

	if arg_7_0.is_server and not Managers.state.network:in_game_session() then
		return
	end

	local var_7_0 = Network.peer_id()
	local var_7_1 = arg_7_0:player(var_7_0, arg_7_2)
	local var_7_2 = not not var_7_1.bot_player
	local var_7_3 = false
	local var_7_4 = Managers.state.network.profile_synchronizer

	if var_7_4:own_loaded_inventory_id() == 0 then
		var_7_3 = true
	else
		local var_7_5 = var_7_4:hash_inventory(arg_7_3, arg_7_4, var_7_2)
		local var_7_6 = var_7_4:cached_inventory_hash(var_7_0, arg_7_2)

		if var_7_5 ~= var_7_6 or var_7_5 ~= string.pad_left(arg_7_16, 16, "0") then
			if var_7_5 ~= var_7_6 then
				local var_7_7 = true

				var_7_4:resync_loadout(var_7_0, arg_7_2, var_7_2, var_7_7, var_7_5)
			end

			var_7_3 = true
		end
	end

	if var_7_3 then
		arg_7_0.network_manager.network_transmit:send_rpc_server("rpc_to_server_spawn_failed", arg_7_2)

		return
	end

	if CHANNEL_TO_PEER_ID[arg_7_1] == var_7_0 then
		Managers.state.game_mode:host_player_spawned()
	end

	local var_7_8 = {}

	if arg_7_15 then
		for iter_7_0, iter_7_1 in ipairs(arg_7_15) do
			local var_7_9 = NetworkLookup.buff_templates[iter_7_1]

			table.insert(var_7_8, var_7_9)
		end
	end

	local var_7_10 = arg_7_8 * 0.01
	local var_7_11 = arg_7_9 * 0.01

	var_7_1:set_profile_index(arg_7_3)
	var_7_1:set_career_index(arg_7_4)

	local var_7_12 = SpawningHelper.unnetpack_additional_items(arg_7_14)
	local var_7_13 = var_7_1.player_unit

	if var_7_13 == nil or not Unit.alive(var_7_13) then
		var_7_1:spawn(arg_7_5, arg_7_6, arg_7_7, var_7_10, var_7_11, NetworkLookup.item_names[arg_7_11], NetworkLookup.item_names[arg_7_12], NetworkLookup.item_names[arg_7_13], arg_7_10, var_7_12, var_7_8)
	else
		if var_7_1:needs_despawn() then
			Managers.state.spawn:delayed_despawn(var_7_1)
		end

		local var_7_14 = Vector3Box(arg_7_5)
		local var_7_15 = QuaternionBox(arg_7_6)

		local function var_7_16()
			if not var_7_1._destroyed and not var_7_1.player_unit then
				var_7_1:spawn(var_7_14:unbox(), var_7_15:unbox(), arg_7_7, var_7_10, var_7_11, NetworkLookup.item_names[arg_7_11], NetworkLookup.item_names[arg_7_12], NetworkLookup.item_names[arg_7_13], arg_7_10, var_7_12, var_7_8)
			end
		end

		Managers.state.unit_spawner:add_destroy_listener(var_7_13, "delayed_client_spawn_player", var_7_16)
	end
end

PlayerManager.exit_ingame = function (arg_9_0)
	for iter_9_0, iter_9_1 in pairs(arg_9_0._players) do
		if iter_9_1.remote then
			arg_9_0:remove_player(iter_9_1:network_id(), iter_9_1:local_player_id())
		end
	end

	arg_9_0.network_event_delegate:unregister(arg_9_0)

	arg_9_0.network_event_delegate = nil
	arg_9_0.is_server = nil
	arg_9_0.network_manager = nil

	for iter_9_2, iter_9_3 in pairs(arg_9_0._players) do
		iter_9_3.network_manager = nil
	end
end

PlayerManager.assign_unit_ownership = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if script_data.network_debug_connections then
		printf("PlayerManager:assign_unit_ownership %s %s %i", arg_10_2:name(), tostring(arg_10_2:network_id()), arg_10_2:local_player_id())
	end

	arg_10_0._unit_owners[arg_10_1] = arg_10_2
	arg_10_2.owned_units[arg_10_1] = arg_10_1

	if arg_10_3 then
		arg_10_0._player_units_owners[arg_10_1] = arg_10_2

		arg_10_2:set_player_unit(arg_10_1)

		local var_10_0 = Managers.party:get_party_from_player_id(arg_10_2:network_id(), arg_10_2:local_player_id())
		local var_10_1 = Managers.state.side
		local var_10_2 = var_10_1.side_by_party[var_10_0]

		var_10_1:add_player_unit_to_side(arg_10_1, var_10_2.side_id)
	end

	Managers.state.unit_spawner:add_destroy_listener(arg_10_1, "player_manager", callback(arg_10_0, "unit_destroy_callback"))
end

PlayerManager.unit_destroy_callback = function (arg_11_0, arg_11_1)
	arg_11_0:relinquish_unit_ownership(arg_11_1)
end

PlayerManager.unit_owner = function (arg_12_0, arg_12_1)
	return arg_12_0._unit_owners[arg_12_1]
end

PlayerManager.player_from_unique_id = function (arg_13_0, arg_13_1)
	return arg_13_0._players[arg_13_1]
end

PlayerManager.player_from_stats_id = function (arg_14_0, arg_14_1)
	return arg_14_0:player_from_unique_id(arg_14_1)
end

PlayerManager.player_from_game_object_id = function (arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_0._players) do
		if iter_15_1.game_object_id == arg_15_1 then
			return iter_15_1
		end
	end
end

PlayerManager.relinquish_unit_ownership = function (arg_16_0, arg_16_1)
	fassert(arg_16_0._unit_owners[arg_16_1], "[PlayerManager:relinquish_unit_ownership] Unit %s ownership cannot be relinquished, not owned.", arg_16_1)

	local var_16_0 = arg_16_0._unit_owners[arg_16_1]
	local var_16_1 = arg_16_0._player_units_owners[arg_16_1]

	if var_16_1 then
		if arg_16_1 == var_16_0.player_unit then
			var_16_0.player_unit = nil
		end

		Managers.state.side:remove_player_unit_from_side(arg_16_1)

		arg_16_0._player_units_owners[arg_16_1] = nil

		Managers.state.event:trigger("player_unit_relinquished", var_16_1, arg_16_1, var_16_1:unique_id())
	end

	arg_16_0._unit_owners[arg_16_1] = nil
	var_16_0.owned_units[arg_16_1] = nil

	Managers.state.unit_spawner:remove_destroy_listener(arg_16_1, "player_manager")
end

PlayerManager.add_player = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	if script_data.network_debug_connections then
		printf("PlayerManager:add_player %s", tostring(arg_17_2))
	end

	local var_17_0 = Network.peer_id()
	local var_17_1 = PlayerUtils.unique_player_id(var_17_0, arg_17_4)
	local var_17_2 = arg_17_0:_create_ui_id()
	local var_17_3 = Managers.backend:player_id()
	local var_17_4 = BulldozerPlayer:new(arg_17_0.network_manager, arg_17_1, arg_17_2, arg_17_3, arg_17_0.is_server, arg_17_4, var_17_1, var_17_2, var_17_3)

	arg_17_0._players[var_17_1] = var_17_4
	arg_17_0._num_human_players = arg_17_0._num_human_players + 1
	arg_17_0._human_players[var_17_1] = var_17_4
	arg_17_0._local_human_player = var_17_4

	local var_17_5 = arg_17_0._players_by_peer

	var_17_5[var_17_0] = var_17_5[var_17_0] or {}
	var_17_5[var_17_0][arg_17_4] = var_17_4

	local var_17_6 = Managers.backend:get_interface("statistics"):get_stats()

	arg_17_0._statistics_db:register(var_17_4:stats_id(), "player", var_17_6)
	Managers.party:register_player(var_17_4, var_17_1)

	if arg_17_0.is_server and var_17_4:is_player_controlled() then
		Managers.telemetry_events:player_joined(var_17_4, arg_17_0._num_human_players)
	end

	if IS_WINDOWS then
		Managers.account:update_presence()
	end

	return var_17_4
end

PlayerManager.add_remote_player = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	if script_data.network_debug_connections then
		printf("PlayerManager:add_remote_player %s", tostring(arg_18_1))
	end

	local var_18_0 = PlayerUtils.unique_player_id(arg_18_1, arg_18_3)
	local var_18_1 = arg_18_0:_create_ui_id()
	local var_18_2 = RemotePlayer:new(arg_18_0.network_manager, arg_18_1, arg_18_2, arg_18_0.is_server, arg_18_3, var_18_0, arg_18_4, var_18_1, arg_18_5)
	local var_18_3 = Managers.state.network.network_transmit

	arg_18_0._players[var_18_0] = var_18_2

	if arg_18_2 then
		arg_18_0._num_human_players = arg_18_0._num_human_players + 1
		arg_18_0._human_players[var_18_0] = var_18_2

		if IS_WINDOWS then
			Managers.account:update_presence()
		end
	end

	if arg_18_0.is_server and arg_18_2 then
		Managers.telemetry_events:player_joined(var_18_2, arg_18_0._num_human_players)
	end

	local var_18_4 = arg_18_0._players_by_peer

	var_18_4[arg_18_1] = var_18_4[arg_18_1] or {}
	var_18_4[arg_18_1][arg_18_3] = var_18_2

	arg_18_0._statistics_db:register(var_18_2:stats_id(), "player")
	visual_assert(table.size(arg_18_0._players) <= 4, "Too many players after remote player added.")
	Managers.party:register_player(var_18_2, var_18_0)

	return var_18_2
end

PlayerManager.player_exists = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._players_by_peer[arg_19_1]

	return var_19_0 and var_19_0[arg_19_2 or 1] or false
end

PlayerManager.owner = function (arg_20_0, arg_20_1)
	return arg_20_0._unit_owners[arg_20_1]
end

PlayerManager.is_player_unit = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._unit_owners[arg_21_1]

	if var_21_0 and var_21_0.player_unit == arg_21_1 then
		return true
	end

	return false
end

PlayerManager._create_ui_id = function (arg_22_0)
	arg_22_0._ui_id_increment = arg_22_0._ui_id_increment % 1000 + 1

	return arg_22_0._ui_id_increment
end

PlayerManager.add_bot_player = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	local var_23_0 = Network.peer_id()
	local var_23_1 = PlayerUtils.unique_player_id(var_23_0, arg_23_6)
	local var_23_2 = arg_23_0:_create_ui_id()
	local var_23_3 = PlayerBot:new(arg_23_0.network_manager, arg_23_1, arg_23_3, arg_23_0.is_server, arg_23_4, arg_23_5, arg_23_6, var_23_1, var_23_2)

	arg_23_0._players[var_23_1] = var_23_3

	local var_23_4 = arg_23_0._players_by_peer

	var_23_4[var_23_0] = var_23_4[var_23_0] or {}
	var_23_4[var_23_0][arg_23_6] = var_23_3

	local var_23_5 = var_23_3:stats_id()

	arg_23_0._statistics_db:register(var_23_5, "player")
	Managers.party:register_player(var_23_3, var_23_1)

	return var_23_3
end

PlayerManager.clear_all_players = function (arg_24_0)
	for iter_24_0, iter_24_1 in pairs(arg_24_0._players) do
		arg_24_0:remove_player(iter_24_1:network_id(), iter_24_1:local_player_id())
	end
end

PlayerManager.remove_all_players_from_peer = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._players_by_peer[arg_25_1]

	if var_25_0 then
		for iter_25_0, iter_25_1 in pairs(var_25_0) do
			arg_25_0:remove_player(arg_25_1, iter_25_0)
		end
	end
end

PlayerManager.set_stats_backend = function (arg_26_0, arg_26_1)
	if arg_26_1.local_player then
		local var_26_0 = {}

		arg_26_0._statistics_db:generate_backend_stats(arg_26_1:stats_id(), var_26_0)
		Managers.backend:set_stats(var_26_0)
	end
end

PlayerManager.remove_player = function (arg_27_0, arg_27_1, arg_27_2)
	if script_data.network_debug_connections then
		printf("PlayerManager:remove_player peer_id=%s %i", tostring(arg_27_1), arg_27_2 or -1)
	end

	local var_27_0 = PlayerUtils.unique_player_id(arg_27_1, arg_27_2)

	arg_27_0._player_loadouts[var_27_0] = nil

	local var_27_1 = arg_27_0._players[var_27_0]

	if var_27_1 then
		if var_27_1 == arg_27_0._local_human_player then
			arg_27_0._local_human_player = nil
		end

		local var_27_2 = var_27_1.owned_units

		for iter_27_0, iter_27_1 in pairs(var_27_2) do
			arg_27_0:relinquish_unit_ownership(iter_27_0)
		end

		arg_27_0._players[var_27_0] = nil
		arg_27_0._human_players[var_27_0] = nil

		local var_27_3 = arg_27_0._players_by_peer[arg_27_1]

		var_27_3[arg_27_2] = nil

		if table.is_empty(var_27_3) then
			arg_27_0._players_by_peer[arg_27_1] = nil
		end

		if var_27_1:is_player_controlled() then
			arg_27_0._num_human_players = arg_27_0._num_human_players - 1
		end

		if arg_27_0.is_server and var_27_1:is_player_controlled() then
			Managers.telemetry_events:player_left(var_27_1, arg_27_0._num_human_players)
		end

		arg_27_0._statistics_db:unregister(var_27_1:stats_id())
		var_27_1:destroy()

		if IS_WINDOWS then
			Managers.account:update_presence()
		end
	end
end

PlayerManager.player = function (arg_28_0, arg_28_1, arg_28_2)
	fassert(arg_28_1 and arg_28_2, "Required peer id and local player id.")

	return arg_28_0:player_from_peer_id(arg_28_1, arg_28_2)
end

PlayerManager.player_from_peer_id = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._players_by_peer[arg_29_1]

	if not var_29_0 then
		return nil
	end

	return var_29_0[arg_29_2 or 1]
end

PlayerManager.players_at_peer = function (arg_30_0, arg_30_1)
	return arg_30_0._players_by_peer[arg_30_1]
end

PlayerManager.human_players = function (arg_31_0)
	return arg_31_0._human_players
end

PlayerManager.human_and_bot_players = function (arg_32_0)
	return arg_32_0._players
end

PlayerManager.players = function (arg_33_0)
	return arg_33_0._players
end

PlayerManager.num_human_players = function (arg_34_0)
	return arg_34_0._num_human_players
end

PlayerManager.num_alive_allies = function (arg_35_0, arg_35_1)
	local var_35_0 = Managers.player:human_and_bot_players()
	local var_35_1 = 0

	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		if arg_35_1 ~= iter_35_1 then
			local var_35_2 = iter_35_1.player_unit

			if Unit.alive(var_35_2) and not ScriptUnit.extension(var_35_2, "status_system"):is_disabled() then
				var_35_1 = var_35_1 + 1
			end
		end
	end

	return var_35_1
end

PlayerManager.server_player = function (arg_36_0)
	local var_36_0 = Managers.state.network.network_transmit
	local var_36_1 = var_36_0.server_peer_id or var_36_0.peer_id

	return arg_36_0:player_from_peer_id(var_36_1, 1)
end

PlayerManager.party_leader_player = function (arg_37_0)
	if not Managers.party or not Managers.party.leader then
		Application.warning("[PlayerManager:party_leader_player] Could not get the party leader -> using local player")

		return Managers.player:local_player()
	else
		local var_37_0 = Managers.party:leader()

		if not var_37_0 then
			Application.warning("[PlayerManager:party_leader_player] Could not get the party leader -> using local player")

			return Managers.player:local_player()
		end

		local var_37_1 = arg_37_0:player_from_peer_id(var_37_0, 1)

		if not var_37_1 then
			Application.warning("[PlayerManager:party_leader_player] Could not fetch party player from peer_id %s", var_37_0)
		end

		return var_37_1
	end
end

PlayerManager.next_available_local_player_id = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = 2
	local var_38_1 = arg_38_0._players_by_peer[arg_38_1]

	if var_38_1 then
		if arg_38_2 then
			local var_38_2 = var_0_0[arg_38_2]

			if var_38_2 and not var_38_1[var_38_2] then
				return var_38_2
			end

			Application.warning("[PlayerManager:next_available_local_player_id] static bot local id [%d] for profile [%s] is already in use, falling back to random one.", var_38_2, tostring(arg_38_2))
		end

		while var_38_1[var_38_0] do
			var_38_0 = var_38_0 + 1
		end
	end

	return var_38_0
end

PlayerManager.num_players = function (arg_39_0)
	local var_39_0 = 0

	for iter_39_0, iter_39_1 in pairs(arg_39_0._players) do
		var_39_0 = var_39_0 + 1
	end

	return var_39_0
end

PlayerManager.local_player = function (arg_40_0, arg_40_1)
	if DEDICATED_SERVER then
		return nil
	end

	return arg_40_0:player(Network.peer_id(), arg_40_1 or 1)
end

PlayerManager.local_player_safe = function (arg_41_0, arg_41_1)
	local var_41_0 = Managers.state and Managers.state.network

	if not var_41_0 or not var_41_0:game() then
		return
	end

	return arg_41_0:player(Network.peer_id(), arg_41_1 or 1)
end

PlayerManager.local_human_player = function (arg_42_0)
	return arg_42_0._local_human_player
end

PlayerManager.bots = function (arg_43_0)
	local var_43_0 = {}

	for iter_43_0, iter_43_1 in pairs(arg_43_0._players) do
		if iter_43_1.bot_player then
			var_43_0[#var_43_0 + 1] = iter_43_1
		end
	end

	return var_43_0
end

function DEBUG_PLAYERS()
	local var_44_0 = Managers.player:players()

	print("players -----------------------------------------------------------")

	for iter_44_0, iter_44_1 in pairs(var_44_0) do
		print("PLAYER id:" .. tostring(iter_44_0) .. ", unit:" .. tostring(iter_44_1.player_unit) .. ", remote:" .. tostring(iter_44_1.remote) .. ", peer_id:" .. tostring(iter_44_1.peer_id))
	end

	print(" ")
end

PlayerManager.rpc_set_observed_unit = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	fassert(arg_45_0.is_server, "Only server should get this")

	local var_45_0 = Managers.state.network:game_object_or_level_unit(arg_45_3, arg_45_4)

	if var_45_0 then
		local var_45_1 = CHANNEL_TO_PEER_ID[arg_45_1]

		Managers.player:player(var_45_1, arg_45_2):set_observed_unit(var_45_0)
	end
end
