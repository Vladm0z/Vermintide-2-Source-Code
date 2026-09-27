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

local tbl = {}

for i = 1, #SPProfiles do
	tbl[SPProfiles[i].index] = i + 1
end

PlayerManager.init = function (self)
	-- function 1
	self._players = {}
	self._players_by_peer = {}
	self._num_human_players = 0
	self._human_players = {}
	self._unit_owners = {}
	self._player_units_owners = {}
	self._local_human_player = nil
	self._player_loadouts = {}
	self._ui_id_increment = 0
end

local tbl_2 = {
	"rpc_to_client_spawn_player",
	"rpc_set_observed_unit",
	"rpc_sync_loadout_slot"
}

PlayerManager.set_is_server = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self.is_server = arg_2_1

	arg_2_2:register(self, unpack(tbl_2))

	self.network_event_delegate = arg_2_2
	self.network_manager = arg_2_3

	for k, v in pairs(self._players) do
		if not v.remote then
			v.is_server = arg_2_1
		end

		v.network_manager = arg_2_3
	end
end

PlayerManager.set_statistics_db = function (self, arg_3_1)
	-- function 3
	self._statistics_db = arg_3_1
end

PlayerManager.statistics_db = function (self)
	-- function 4
	return self._statistics_db
end

PlayerManager.player_loadouts = function (self)
	-- function 5
	return self._player_loadouts
end

PlayerManager.rpc_sync_loadout_slot = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	-- function 6
	if not Managers.state.network:in_game_session() then
		return
	end

	local create_loadout_item_from_rpc_data, var_6_1 = LoadoutUtils.create_loadout_item_from_rpc_data(arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	local unique_player_id = PlayerUtils.unique_player_id(arg_6_2, arg_6_3)
	local _player_loadouts = self._player_loadouts
	local var_6_4 = self._player_loadouts[unique_player_id]

	var_6_4 = var_6_4 or {}
	_player_loadouts[unique_player_id] = var_6_4
	self._player_loadouts[unique_player_id][create_loadout_item_from_rpc_data] = var_6_1

	if not (not self.is_server and arg_6_2 == Network.peer_id()) then
		self.network_manager.network_transmit:send_rpc_clients("rpc_sync_loadout_slot", arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	end
end

PlayerManager.rpc_to_client_spawn_player = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12, arg_7_13, arg_7_14, arg_7_15, arg_7_16)
	-- function 7
	if not script_data.network_debug_connections then
		printf("PlayerManager:rpc_to_client_spawn_player(%s, %s, %s, %s)", tostring(arg_7_1), tostring(arg_7_3), tostring(arg_7_5), tostring(arg_7_6))
	end

	if not (not self.is_server and Managers.state.network:in_game_session()) then
		return
	end

	local peer_id = Network.peer_id()
	local player = self:player(peer_id, arg_7_2)
	local flag = not not player.bot_player
	local flag_2 = false
	local profile_synchronizer = Managers.state.network.profile_synchronizer

	if profile_synchronizer:own_loaded_inventory_id() == 0 then
		flag_2 = true
	else
		local hash_inventory = profile_synchronizer:hash_inventory(arg_7_3, arg_7_4, flag)
		local cached_inventory_hash = profile_synchronizer:cached_inventory_hash(peer_id, arg_7_2)

		if not (hash_inventory ~= cached_inventory_hash or hash_inventory == string.pad_left(arg_7_16, 16, "0")) then
			if hash_inventory ~= cached_inventory_hash then
				local flag_3 = true

				profile_synchronizer:resync_loadout(peer_id, arg_7_2, flag, flag_3, hash_inventory)
			end

			flag_2 = true
		end
	end

	if not flag_2 then
		self.network_manager.network_transmit:send_rpc_server("rpc_to_server_spawn_failed", arg_7_2)

		return
	end

	if CHANNEL_TO_PEER_ID[arg_7_1] == peer_id then
		Managers.state.game_mode:host_player_spawned()
	end

	local tbl = {}

	if not arg_7_15 then
		for i, v in ipairs(arg_7_15) do
			local var_7_9 = NetworkLookup.buff_templates[v]

			table.insert(tbl, var_7_9)
		end
	end

	local num = arg_7_8 * 0.01
	local num_2 = arg_7_9 * 0.01

	player:set_profile_index(arg_7_3)
	player:set_career_index(arg_7_4)

	local unnetpack_additional_items = SpawningHelper.unnetpack_additional_items(arg_7_14)
	local player_unit = player.player_unit

	if not (player_unit == nil or Unit.alive(player_unit)) then
		player:spawn(arg_7_5, arg_7_6, arg_7_7, num, num_2, NetworkLookup.item_names[arg_7_11], NetworkLookup.item_names[arg_7_12], NetworkLookup.item_names[arg_7_13], arg_7_10, unnetpack_additional_items, tbl)
	else
		if not player:needs_despawn() then
			Managers.state.spawn:delayed_despawn(player)
		end

		local var_7_14 = Vector3Box(arg_7_5)
		local var_7_15 = QuaternionBox(arg_7_6)

		local function fn()
			-- function 8
			if not (player._destroyed or player.player_unit) then
				player:spawn(var_7_14:unbox(), var_7_15:unbox(), arg_7_7, num, num_2, NetworkLookup.item_names[arg_7_11], NetworkLookup.item_names[arg_7_12], NetworkLookup.item_names[arg_7_13], arg_7_10, unnetpack_additional_items, tbl)
			end
		end

		Managers.state.unit_spawner:add_destroy_listener(player_unit, "delayed_client_spawn_player", fn)
	end
end

PlayerManager.exit_ingame = function (self)
	-- function 9
	for k, v in pairs(self._players) do
		if not v.remote then
			self:remove_player(v:network_id(), v:local_player_id())
		end
	end

	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self.is_server = nil
	self.network_manager = nil

	for k_2, v_2 in pairs(self._players) do
		v_2.network_manager = nil
	end
end

PlayerManager.assign_unit_ownership = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not script_data.network_debug_connections then
		printf("PlayerManager:assign_unit_ownership %s %s %i", arg_10_2:name(), tostring(arg_10_2:network_id()), arg_10_2:local_player_id())
	end

	arg_10_0._unit_owners[arg_10_1] = arg_10_2
	arg_10_2.owned_units[arg_10_1] = arg_10_1

	if not arg_10_3 then
		arg_10_0._player_units_owners[arg_10_1] = arg_10_2

		arg_10_2:set_player_unit(arg_10_1)

		local get_party_from_player_id = Managers.party:get_party_from_player_id(arg_10_2:network_id(), arg_10_2:local_player_id())
		local side = Managers.state.side
		local var_10_2 = side.side_by_party[get_party_from_player_id]

		side:add_player_unit_to_side(arg_10_1, var_10_2.side_id)
	end

	Managers.state.unit_spawner:add_destroy_listener(arg_10_1, "player_manager", callback(arg_10_0, "unit_destroy_callback"))
end

PlayerManager.unit_destroy_callback = function (self, arg_11_1)
	-- function 11
	self:relinquish_unit_ownership(arg_11_1)
end

PlayerManager.unit_owner = function (self, arg_12_1)
	-- function 12
	return self._unit_owners[arg_12_1]
end

PlayerManager.player_from_unique_id = function (self, arg_13_1)
	-- function 13
	return self._players[arg_13_1]
end

PlayerManager.player_from_stats_id = function (self, arg_14_1)
	-- function 14
	return self:player_from_unique_id(arg_14_1)
end

PlayerManager.player_from_game_object_id = function (self, arg_15_1)
	-- function 15
	for k, v in pairs(self._players) do
		if v.game_object_id == arg_15_1 then
			return v
		end
	end
end

PlayerManager.relinquish_unit_ownership = function (self, arg_16_1)
	-- function 16
	fassert(self._unit_owners[arg_16_1], "[PlayerManager:relinquish_unit_ownership] Unit %s ownership cannot be relinquished, not owned.", arg_16_1)

	local var_16_0 = self._unit_owners[arg_16_1]
	local var_16_1 = self._player_units_owners[arg_16_1]

	if not var_16_1 then
		if arg_16_1 == var_16_0.player_unit then
			var_16_0.player_unit = nil
		end

		Managers.state.side:remove_player_unit_from_side(arg_16_1)

		self._player_units_owners[arg_16_1] = nil

		Managers.state.event:trigger("player_unit_relinquished", var_16_1, arg_16_1, var_16_1:unique_id())
	end

	self._unit_owners[arg_16_1] = nil
	var_16_0.owned_units[arg_16_1] = nil

	Managers.state.unit_spawner:remove_destroy_listener(arg_16_1, "player_manager")
end

PlayerManager.add_player = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	if not script_data.network_debug_connections then
		printf("PlayerManager:add_player %s", tostring(arg_17_2))
	end

	local peer_id = Network.peer_id()
	local unique_player_id = PlayerUtils.unique_player_id(peer_id, arg_17_4)
	local _create_ui_id = self:_create_ui_id()
	local player_id = Managers.backend:player_id()
	local var_17_4 = BulldozerPlayer:new(self.network_manager, arg_17_1, arg_17_2, arg_17_3, self.is_server, arg_17_4, unique_player_id, _create_ui_id, player_id)

	self._players[unique_player_id] = var_17_4
	self._num_human_players = self._num_human_players + 1
	self._human_players[unique_player_id] = var_17_4
	self._local_human_player = var_17_4

	local _players_by_peer = self._players_by_peer
	local var_17_6 = _players_by_peer[peer_id]

	var_17_6 = var_17_6 or {}
	_players_by_peer[peer_id] = var_17_6
	_players_by_peer[peer_id][arg_17_4] = var_17_4

	local get_stats = Managers.backend:get_interface("statistics"):get_stats()

	self._statistics_db:register(var_17_4:stats_id(), "player", get_stats)
	Managers.party:register_player(var_17_4, unique_player_id)

	if not self.is_server and not var_17_4:is_player_controlled() then
		Managers.telemetry_events:player_joined(var_17_4, self._num_human_players)
	end

	if not IS_WINDOWS then
		Managers.account:update_presence()
	end

	return var_17_4
end

PlayerManager.add_remote_player = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	if not script_data.network_debug_connections then
		printf("PlayerManager:add_remote_player %s", tostring(arg_18_1))
	end

	local unique_player_id = PlayerUtils.unique_player_id(arg_18_1, arg_18_3)
	local _create_ui_id = self:_create_ui_id()
	local var_18_2 = RemotePlayer:new(self.network_manager, arg_18_1, arg_18_2, self.is_server, arg_18_3, unique_player_id, arg_18_4, _create_ui_id, arg_18_5)
	local network_transmit = Managers.state.network.network_transmit

	self._players[unique_player_id] = var_18_2

	if not arg_18_2 then
		self._num_human_players = self._num_human_players + 1
		self._human_players[unique_player_id] = var_18_2

		if not IS_WINDOWS then
			Managers.account:update_presence()
		end
	end

	if not self.is_server and not arg_18_2 then
		Managers.telemetry_events:player_joined(var_18_2, self._num_human_players)
	end

	local _players_by_peer = self._players_by_peer
	local var_18_5 = _players_by_peer[arg_18_1]

	var_18_5 = var_18_5 or {}
	_players_by_peer[arg_18_1] = var_18_5
	_players_by_peer[arg_18_1][arg_18_3] = var_18_2

	self._statistics_db:register(var_18_2:stats_id(), "player")
	visual_assert(table.size(self._players) <= 4, "Too many players after remote player added.")
	Managers.party:register_player(var_18_2, unique_player_id)

	return var_18_2
end

PlayerManager.player_exists = function (self, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = self._players_by_peer[arg_19_1]
	local var_19_1

	if not var_19_0 then
		var_19_1 = var_19_0[arg_19_2 or 1]

		if not var_19_1 then
			-- Nothing
		end
	end

	var_19_1 = false

	::label_19_0::

	return var_19_1
end

PlayerManager.owner = function (self, arg_20_1)
	-- function 20
	return self._unit_owners[arg_20_1]
end

PlayerManager.is_player_unit = function (self, arg_21_1)
	-- function 21
	local var_21_0 = self._unit_owners[arg_21_1]

	if not (not var_21_0 and var_21_0.player_unit ~= arg_21_1) then
		return true
	end

	return false
end

PlayerManager._create_ui_id = function (self)
	-- function 22
	self._ui_id_increment = self._ui_id_increment % 1000 + 1

	return self._ui_id_increment
end

PlayerManager.add_bot_player = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	-- function 23
	local peer_id = Network.peer_id()
	local unique_player_id = PlayerUtils.unique_player_id(peer_id, arg_23_6)
	local _create_ui_id = self:_create_ui_id()
	local var_23_3 = PlayerBot:new(self.network_manager, arg_23_1, arg_23_3, self.is_server, arg_23_4, arg_23_5, arg_23_6, unique_player_id, _create_ui_id)

	self._players[unique_player_id] = var_23_3

	local _players_by_peer = self._players_by_peer
	local var_23_5 = _players_by_peer[peer_id]

	var_23_5 = var_23_5 or {}
	_players_by_peer[peer_id] = var_23_5
	_players_by_peer[peer_id][arg_23_6] = var_23_3

	local stats_id = var_23_3:stats_id()

	self._statistics_db:register(stats_id, "player")
	Managers.party:register_player(var_23_3, unique_player_id)

	return var_23_3
end

PlayerManager.clear_all_players = function (self)
	-- function 24
	for k, v in pairs(self._players) do
		self:remove_player(v:network_id(), v:local_player_id())
	end
end

PlayerManager.remove_all_players_from_peer = function (self, arg_25_1)
	-- function 25
	local var_25_0 = self._players_by_peer[arg_25_1]

	if not var_25_0 then
		for k, v in pairs(var_25_0) do
			self:remove_player(arg_25_1, k)
		end
	end
end

PlayerManager.set_stats_backend = function (self, arg_26_1)
	-- function 26
	if not arg_26_1.local_player then
		local tbl = {}

		self._statistics_db:generate_backend_stats(arg_26_1:stats_id(), tbl)
		Managers.backend:set_stats(tbl)
	end
end

PlayerManager.remove_player = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not script_data.network_debug_connections then
		printf("PlayerManager:remove_player peer_id=%s %i", tostring(arg_27_1), arg_27_2 or -1)
	end

	local unique_player_id = PlayerUtils.unique_player_id(arg_27_1, arg_27_2)

	self._player_loadouts[unique_player_id] = nil

	local var_27_1 = self._players[unique_player_id]

	if not var_27_1 then
		if var_27_1 == self._local_human_player then
			self._local_human_player = nil
		end

		local owned_units = var_27_1.owned_units

		for k, v in pairs(owned_units) do
			self:relinquish_unit_ownership(k)
		end

		self._players[unique_player_id] = nil
		self._human_players[unique_player_id] = nil

		local var_27_3 = self._players_by_peer[arg_27_1]

		var_27_3[arg_27_2] = nil

		if not table.is_empty(var_27_3) then
			self._players_by_peer[arg_27_1] = nil
		end

		if not var_27_1:is_player_controlled() then
			self._num_human_players = self._num_human_players - 1
		end

		if not self.is_server and not var_27_1:is_player_controlled() then
			Managers.telemetry_events:player_left(var_27_1, self._num_human_players)
		end

		self._statistics_db:unregister(var_27_1:stats_id())
		var_27_1:destroy()

		if not IS_WINDOWS then
			Managers.account:update_presence()
		end
	end
end

PlayerManager.player = function (self, arg_28_1, arg_28_2)
	-- function 28
	fassert(not arg_28_1 and arg_28_2, "Required peer id and local player id.")

	return self:player_from_peer_id(arg_28_1, arg_28_2)
end

PlayerManager.player_from_peer_id = function (self, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0 = self._players_by_peer[arg_29_1]

	if not var_29_0 then
		return nil
	end

	return var_29_0[arg_29_2 or 1]
end

PlayerManager.players_at_peer = function (self, arg_30_1)
	-- function 30
	return self._players_by_peer[arg_30_1]
end

PlayerManager.human_players = function (self)
	-- function 31
	return self._human_players
end

PlayerManager.human_and_bot_players = function (self)
	-- function 32
	return self._players
end

PlayerManager.players = function (self)
	-- function 33
	return self._players
end

PlayerManager.num_human_players = function (self)
	-- function 34
	return self._num_human_players
end

PlayerManager.num_alive_allies = function (arg_35_0, arg_35_1)
	-- function 35
	local human_and_bot_players = Managers.player:human_and_bot_players()
	local num = 0

	for k, v in pairs(human_and_bot_players) do
		if arg_35_1 ~= v then
			local player_unit = v.player_unit

			if not (not Unit.alive(player_unit) and ScriptUnit.extension(player_unit, "status_system"):is_disabled()) then
				num = num + 1
			end
		end
	end

	return num
end

PlayerManager.server_player = function (self)
	-- function 36
	local network_transmit = Managers.state.network.network_transmit
	local flag = network_transmit.server_peer_id or network_transmit.peer_id

	return self:player_from_peer_id(flag, 1)
end

PlayerManager.party_leader_player = function (self)
	-- function 37
	if not (not Managers.party and Managers.party.leader) then
		Application.warning("[PlayerManager:party_leader_player] Could not get the party leader -> using local player")

		return Managers.player:local_player()
	else
		local leader = Managers.party:leader()

		if not leader then
			Application.warning("[PlayerManager:party_leader_player] Could not get the party leader -> using local player")

			return Managers.player:local_player()
		end

		local player_from_peer_id = self:player_from_peer_id(leader, 1)

		if not player_from_peer_id then
			Application.warning("[PlayerManager:party_leader_player] Could not fetch party player from peer_id %s", leader)
		end

		return player_from_peer_id
	end
end

PlayerManager.next_available_local_player_id = function (self, arg_38_1, arg_38_2)
	-- function 38
	local num = 2
	local var_38_1 = self._players_by_peer[arg_38_1]

	if not var_38_1 then
		if not arg_38_2 then
			local var_38_2 = tbl[arg_38_2]

			if not (not var_38_2 and var_38_1[var_38_2]) then
				return var_38_2
			end

			Application.warning("[PlayerManager:next_available_local_player_id] static bot local id [%d] for profile [%s] is already in use, falling back to random one.", var_38_2, tostring(arg_38_2))
		end

		while not var_38_1[num] do
			num = num + 1
		end
	end

	return num
end

PlayerManager.num_players = function (self)
	-- function 39
	local num = 0

	for k, v in pairs(self._players) do
		num = num + 1
	end

	return num
end

PlayerManager.local_player = function (self, arg_40_1)
	-- function 40
	if not DEDICATED_SERVER then
		return nil
	end

	return self:player(Network.peer_id(), arg_40_1 or 1)
end

PlayerManager.local_player_safe = function (self, arg_41_1)
	-- function 41
	local state = Managers.state

	state = not state and Managers.state.network

	if not (not state and state:game()) then
		return
	end

	return self:player(Network.peer_id(), arg_41_1 or 1)
end

PlayerManager.local_human_player = function (self)
	-- function 42
	return self._local_human_player
end

PlayerManager.bots = function (self)
	-- function 43
	local tbl = {}

	for k, v in pairs(self._players) do
		if not v.bot_player then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

function DEBUG_PLAYERS()
	-- function 44
	local players = Managers.player:players()

	print("players -----------------------------------------------------------")

	for k, v in pairs(players) do
		print("PLAYER id:" .. tostring(k) .. ", unit:" .. tostring(v.player_unit) .. ", remote:" .. tostring(v.remote) .. ", peer_id:" .. tostring(v.peer_id))
	end

	print(" ")
end

PlayerManager.rpc_set_observed_unit = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	-- function 45
	fassert(self.is_server, "Only server should get this")

	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_45_3, arg_45_4)

	if not game_object_or_level_unit then
		local var_45_1 = CHANNEL_TO_PEER_ID[arg_45_1]

		Managers.player:player(var_45_1, arg_45_2):set_observed_unit(game_object_or_level_unit)
	end
end
