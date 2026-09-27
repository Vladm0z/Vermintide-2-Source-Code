-- chunkname: @scripts/managers/game_mode/spawning_components/adventure_spawning.lua

require("scripts/managers/spawn/respawn_handler")
require("scripts/managers/game_mode/spawning_components/spawning_helper")

local num = 1
local tbl = {
	"rpc_to_server_spawn_failed"
}

AdventureSpawning = class(AdventureSpawning)

AdventureSpawning.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	self._profile_synchronizer = arg_1_1
	self._side = arg_1_2
	self._is_server = arg_1_3
	self._network_server = arg_1_4
	self._respawns_enabled = true
	self._spawning = true
	self._respawn_handler = RespawnHandler:new(arg_1_1, arg_1_3)
	self._spawn_points = {}
	self._num_spawn_points_used = 0
	self._delayed_clients = {}
	self._peers_ongoing_game_object_sync = {}
	self._saved_game_mode_data = arg_1_5 or {}

	self:_setup_game_mode_data(arg_1_2, self._saved_game_mode_data)
end

AdventureSpawning._setup_game_mode_data = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local num_slots = arg_2_1.party.num_slots

	for i = 1, num_slots do
		local var_2_1 = arg_2_2[i]

		var_2_1 = var_2_1 or {}
		arg_2_2[i] = var_2_1
	end
end

AdventureSpawning.get_saved_game_mode_data = function (self)
	-- function 3
	return self._saved_game_mode_data
end

AdventureSpawning.register_rpcs = function (self, arg_4_1, arg_4_2)
	-- function 4
	arg_4_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_4_1

	self._respawn_handler:register_rpcs(arg_4_1, arg_4_2)
end

AdventureSpawning.unregister_rpcs = function (self)
	-- function 5
	self._respawn_handler:unregister_rpcs()
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

AdventureSpawning._assign_data_to_slot = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not table.is_empty(arg_6_2) then
		local var_6_0
		local var_6_1

		if not self._spawn_groups then
			local get_current_spawn_group = Managers.mechanism:game_mechanism():get_current_spawn_group()

			var_6_0, var_6_1 = self:get_spawn_point_from_spawn_group(get_current_spawn_group)
		else
			var_6_0, var_6_1 = self:get_spawn_point()
		end

		arg_6_2.health_state = "alive"
		arg_6_2.health_percentage = 1
		arg_6_2.temporary_health_percentage = 0
		arg_6_2.position = var_6_0
		arg_6_2.rotation = var_6_1
		arg_6_2.respawn_timer = nil
		arg_6_2.ability_cooldown_percentage = 1
		arg_6_2.last_update = -math.huge
		arg_6_2.ammo = {
			slot_ranged = 1,
			slot_melee = 1
		}

		local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
		local settings = Managers.state.game_mode:settings()
		local tbl = {}

		SpawningHelper.default_spawn_items(tbl, get_difficulty_settings, settings)

		arg_6_2.consumables = tbl
	end

	if not (not arg_6_2.position and arg_6_2.rotation) then
		local get_spawn_point, var_6_7 = self:get_spawn_point()

		arg_6_2.position = get_spawn_point
		arg_6_2.rotation = var_6_7
	end

	if not arg_6_2.ammo then
		arg_6_2.ammo = {
			slot_ranged = 1,
			slot_melee = 1
		}
	end

	if not arg_6_2.consumables then
		local get_difficulty_settings_2 = Managers.state.difficulty:get_difficulty_settings()
		local settings_2 = Managers.state.game_mode:settings()
		local tbl_2 = {}

		SpawningHelper.default_spawn_items(tbl_2, get_difficulty_settings_2, settings_2)

		arg_6_2.consumables = tbl_2
	end

	if not arg_6_2.additional_items then
		arg_6_2.additional_items = {}
	end

	local flag = arg_6_2.health_state ~= "dead"

	if arg_6_2.spawn_state == nil or not flag then
		local time = Managers.time:time("client_ingame")
		local flag_2

		flag_2 = not (time == nil or time < 10) and "is_initial_spawn" and "spawn"
		arg_6_2.spawn_state = flag_2
	end

	local peer_id = arg_6_1.peer_id
	local peer_id_2 = Network.peer_id()

	if not (flag or peer_id == peer_id_2) then
		local local_player_id = arg_6_1.local_player_id
		local var_6_17 = PEER_ID_TO_CHANNEL[peer_id]

		RPC.rpc_set_observer_camera(var_6_17, local_player_id)
	end

	arg_6_1.game_mode_data = arg_6_2
end

AdventureSpawning._unassign_data_from_slot = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local health_state = arg_7_2.health_state

	if not (health_state == "respawning" or health_state ~= "respawn") then
		arg_7_2.health_state = "dead"
		arg_7_2.ready_for_respawn = true
	end

	local spawn_state = arg_7_2.spawn_state

	if not (spawn_state == "spawned" or spawn_state == "spawning" or spawn_state ~= "spawn") then
		arg_7_2.spawn_state = "despawned"
	else
		arg_7_2.spawn_state = "not_spawned"
	end

	arg_7_1.game_mode_data = {}
end

AdventureSpawning.player_entered_game_session = function (self, arg_8_1, arg_8_2)
	-- function 8
	local get_party_from_player_id = Managers.party:get_party_from_player_id(arg_8_1, arg_8_2)
	local party = self._side.party

	if get_party_from_player_id ~= party then
		return
	end

	local slot_id = Managers.party:get_player_status(arg_8_1, arg_8_2).slot_id
	local var_8_3 = party.slots[slot_id]
	local var_8_4 = self._saved_game_mode_data[slot_id]

	self:_assign_data_to_slot(var_8_3, var_8_4)
end

AdventureSpawning.player_joined_party = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local party = self._side.party

	if party.party_id ~= arg_9_3 then
		return
	end

	local var_9_1 = party.slots[arg_9_4]
	local var_9_2 = self._saved_game_mode_data[arg_9_4]

	self:_assign_data_to_slot(var_9_1, var_9_2)
end

AdventureSpawning.player_left_party = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	if self._side.party.party_id ~= arg_10_3 then
		return
	end

	local var_10_0 = self._saved_game_mode_data[arg_10_4]

	self:_unassign_data_from_slot(arg_10_5, var_10_0)
end

AdventureSpawning.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not Managers.state.network:game() then
		self._respawn_handler:update(arg_11_2, arg_11_1)
	end
end

AdventureSpawning.server_update = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not Managers.state.network:game() then
		local party = self._side.party
		local occupied_slots = party.occupied_slots

		self:_update_player_status(arg_12_1, arg_12_2, occupied_slots)

		local allow_respawns = Managers.state.difficulty:get_difficulty_settings().allow_respawns

		if not self._respawns_enabled and not allow_respawns then
			self._respawn_handler:server_update(arg_12_2, arg_12_1, occupied_slots)
		end

		self:_update_spawning(arg_12_2, arg_12_1, occupied_slots, party.party_id)
		self:_update_joining_clients(arg_12_2, arg_12_1)
	end
end

AdventureSpawning._update_player_status = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local player = Managers.player
	local extension = ScriptUnit.extension

	for i = 1, #arg_13_3 do
		local var_13_2 = arg_13_3[i]
		local game_mode_data = var_13_2.game_mode_data
		local peer_id = var_13_2.peer_id
		local local_player_id = var_13_2.local_player_id

		if not peer_id and not local_player_id then
			local player_2 = Managers.player:player(peer_id, local_player_id)

			if not player_2 then
				local spawn_state = game_mode_data.spawn_state

				if spawn_state == "force_respawn" then
					if ALIVE[player_2.player_unit] or not self._profile_synchronizer:all_ingame_synced() then
						game_mode_data.spawn_state = "spawn"
					end
				elseif spawn_state == "spawned" then
					local player_unit = player_2.player_unit

					if not player_unit then
						local last_position_on_navmesh = extension(player_unit, "locomotion_system"):last_position_on_navmesh()

						game_mode_data.position:store(last_position_on_navmesh)
						game_mode_data.rotation:store(Unit.local_rotation(player_unit, 0))

						local var_13_10 = extension(player_unit, "status_system")
						local health_state = game_mode_data.health_state
						local is_dead = var_13_10:is_dead()

						if not is_dead then
							if game_mode_data.health_state ~= "respawning" then
								game_mode_data.health_state = "dead"
							end
						elseif not var_13_10:is_ready_for_assisted_respawn() then
							game_mode_data.health_state = "respawn"
						elseif not var_13_10:is_knocked_down() then
							game_mode_data.health_state = "knocked_down"
						elseif not (not var_13_10:is_disabled() and var_13_10:is_in_vortex() or var_13_10:is_grabbed_by_corruptor() or var_13_10:is_grabbed_by_chaos_spawn() or var_13_10:is_overpowered()) then
							game_mode_data.health_state = "disabled"
						else
							game_mode_data.health_state = "alive"

							local respawn_unit = game_mode_data.respawn_unit

							if not respawn_unit then
								self._respawn_handler:set_respawn_unit_available(respawn_unit)

								game_mode_data.respawn_unit = nil
							end
						end

						local var_13_14 = extension(player_unit, "health_system")
						local var_13_15 = extension(player_unit, "career_system")

						if not (not is_dead and game_mode_data.health_state == "respawning") then
							game_mode_data.health_percentage = var_13_14:current_permanent_health_percent()
							game_mode_data.temporary_health_percentage = var_13_14:current_temporary_health_percent()
							game_mode_data.ability_cooldown_percentage = var_13_15:current_ability_cooldown_percentage()
						end

						if not DamageUtils.is_in_inn then
							local var_13_16 = extension(player_unit, "inventory_system")

							SpawningHelper.fill_consumable_table(game_mode_data.consumables, var_13_16)
							SpawningHelper.fill_ammo_percentage(game_mode_data.ammo, var_13_16, player_unit)

							game_mode_data.additional_items = var_13_16:get_additional_items_table()
						end
					end
				elseif not (spawn_state == "spawning" or spawn_state ~= "initial_spawning") then
					if not player_2.player_unit then
						game_mode_data.spawn_state = "spawned"
					end
				elseif spawn_state == "despawned" or spawn_state == "not_spawned" or not player_2.player_unit then
					game_mode_data.spawn_state = "spawned"
				end
			end
		end
	end
end

AdventureSpawning._update_spawning = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if not self._spawning then
		local peer_id = Network.peer_id()
		local flag = false
		local peers_ongoing_game_object_sync, var_14_3 = Managers.state.network.network_server:peers_ongoing_game_object_sync(self._peers_ongoing_game_object_sync)

		for i = 1, var_14_3 do
			local var_14_4 = peers_ongoing_game_object_sync[i]

			if not self._profile_synchronizer:all_synced_for_peer(var_14_4, 1) then
				return
			end
		end

		local parties = Managers.party:parties()

		for j = 1, #parties do
			local occupied_slots = parties[j].occupied_slots

			for k = 1, #occupied_slots do
				local var_14_7 = occupied_slots[k]
				local peer_id_2 = var_14_7.peer_id
				local local_player_id = var_14_7.local_player_id

				if not self._profile_synchronizer:all_synced_for_peer(peer_id_2, local_player_id) then
					return
				end

				if not (DEDICATED_SERVER or peer_id_2 ~= peer_id or local_player_id ~= num) then
					flag = true
				end
			end
		end

		if not flag then
			return
		end

		local _network_server = self._network_server

		for l = 1, #arg_14_3 do
			local var_14_11 = arg_14_3[l]
			local spawn_state = var_14_11.game_mode_data.spawn_state
			local var_14_13

			if not DEDICATED_SERVER then
				var_14_13 = _network_server.game_session ~= nil
			else
				var_14_13 = _network_server:is_peer_ingame(var_14_11.peer_id)
			end

			local flag_2 = spawn_state == "is_initial_spawn" or spawn_state == "spawn"

			if not var_14_13 and not flag_2 then
				if not var_14_11.is_bot then
					self:_spawn_bot(var_14_11)
				else
					self:_spawn_player(var_14_11)
				end
			end
		end
	end
end

AdventureSpawning.add_delayed_client = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	arg_15_0._delayed_clients[#arg_15_0._delayed_clients + 1] = {
		peer_id = arg_15_1,
		local_player_id = arg_15_2
	}
end

AdventureSpawning.remove_delayed_client = function (self, arg_16_1, arg_16_2)
	-- function 16
	for i = #self._delayed_clients, 1, -1 do
		local var_16_0 = self._delayed_clients[i]

		if not (var_16_0.peer_id ~= arg_16_1 or var_16_0.local_player_id ~= arg_16_2) then
			table.remove(self._delayed_clients, i)

			return
		end
	end
end

AdventureSpawning._update_joining_clients = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not self._spawning and not self._profile_synchronizer:all_synced() then
		local _network_server = self._network_server

		for i = #self._delayed_clients, 1, -1 do
			local var_17_1 = self._delayed_clients[i]
			local peer_id = var_17_1.peer_id
			local local_player_id = var_17_1.local_player_id

			if not _network_server:is_peer_ingame(peer_id) then
				self:_add_client_to_party(peer_id, local_player_id)
				table.remove(self._delayed_clients, i)
			end
		end
	end
end

AdventureSpawning._add_client_to_party = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	if arg_18_1 ~= Network.peer_id() then
		local flag = true
		local num = 1
		local remove_bot = Managers.state.game_mode:remove_bot(num, arg_18_1, arg_18_2, flag)

		if Managers.party:get_player_status(arg_18_1, arg_18_2).party_id ~= 1 then
			Managers.party:request_join_party(arg_18_1, arg_18_2, num, nil, remove_bot)
		end
	end
end

AdventureSpawning._spawn_player = function (self, arg_19_1)
	-- function 19
	local game_mode_data = arg_19_1.game_mode_data
	local _find_spawn_point, var_19_2 = self:_find_spawn_point(arg_19_1)
	local flag = game_mode_data.spawn_state == "is_initial_spawn"

	if not Managers.state.network:game() then
		local peer_id = arg_19_1.peer_id
		local local_player_id = arg_19_1.local_player_id
		local profile_index = arg_19_1.profile_index
		local career_index = arg_19_1.career_index
		local netpack_consumables = SpawningHelper.netpack_consumables(game_mode_data.consumables)
		local var_19_9, var_19_10, var_19_11 = unpack(netpack_consumables)
		local netpack_additional_items = SpawningHelper.netpack_additional_items(game_mode_data.additional_items)
		local tbl = {}

		if not game_mode_data.persistent_buffs then
			for k, v in pairs(game_mode_data.persistent_buffs.buff_names) do
				local var_19_14 = NetworkLookup.buff_templates[v]

				table.insert(tbl, var_19_14)
			end
		end

		local ammo = game_mode_data.ammo
		local floor = math.floor(ammo.slot_melee * 100)
		local floor_2 = math.floor(ammo.slot_ranged * 100)
		local ability_cooldown_percentage = game_mode_data.ability_cooldown_percentage

		ability_cooldown_percentage = ability_cooldown_percentage or 1

		local floor_3 = math.floor(ability_cooldown_percentage * 100)
		local cached_inventory_hash = self._profile_synchronizer:cached_inventory_hash(peer_id, local_player_id)

		Managers.state.network.network_transmit:send_rpc("rpc_to_client_spawn_player", peer_id, local_player_id, profile_index, career_index, _find_spawn_point, var_19_2, flag, floor, floor_2, floor_3, var_19_9, var_19_10, var_19_11, netpack_additional_items, tbl, cached_inventory_hash)
	end

	local flag_2

	flag_2 = not flag and "initial_spawning" and "spawning"
	game_mode_data.spawn_state = flag_2
end

AdventureSpawning._spawn_bot = function (arg_20_0, arg_20_1)
	-- function 20
	local game_mode_data = arg_20_1.game_mode_data
	local unbox = game_mode_data.position:unbox()
	local unbox_2 = game_mode_data.rotation:unbox()
	local flag = game_mode_data.spawn_state == "is_initial_spawn"
	local consumables = game_mode_data.consumables
	local ammo = game_mode_data.ammo
	local peer_id = arg_20_1.peer_id
	local local_player_id = arg_20_1.local_player_id
	local player = Managers.player:player(peer_id, local_player_id)

	fassert(player.bot_player, "Trying to spawn a player as a bot, status info isn't correct")

	local ability_cooldown_percentage = game_mode_data.ability_cooldown_percentage

	ability_cooldown_percentage = ability_cooldown_percentage or 1

	local floor = math.floor(ability_cooldown_percentage * 100)

	player:spawn(unbox, unbox_2, flag, ammo.slot_melee, ammo.slot_ranged, consumables.slot_healthkit, consumables.slot_potion, consumables.slot_grenade, floor)

	game_mode_data.spawn_state = "spawned"
end

AdventureSpawning._find_spawn_point = function (self, arg_21_1)
	-- function 21
	local var_21_0
	local var_21_1
	local room = Managers.state.room

	if not room then
		var_21_0, var_21_1 = self:_spawn_pos_rot_from_index(room:get_spawn_point_by_peer(arg_21_1.peer_id))
	else
		local game_mode_data = arg_21_1.game_mode_data

		fassert(game_mode_data.position, "This level is missing spawn-points for the players.")

		var_21_0 = game_mode_data.position:unbox()
		var_21_1 = game_mode_data.rotation:unbox()
	end

	return var_21_0, var_21_1
end

AdventureSpawning.force_update_spawn_positions = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _saved_game_mode_data = self._saved_game_mode_data

	for i = 1, #_saved_game_mode_data do
		local var_22_1 = _saved_game_mode_data[i]

		if not var_22_1.position and not var_22_1.rotation then
			var_22_1.position:store(arg_22_1)
			var_22_1.rotation:store(arg_22_2)
		end
	end
end

AdventureSpawning.set_respawning_enabled = function (self, arg_23_1)
	-- function 23
	fassert(self._respawns_enabled ~= arg_23_1, "Respawns already enabled=%s", tostring(arg_23_1))

	self._respawns_enabled = arg_23_1
end

AdventureSpawning.set_spawning_disabled = function (self, arg_24_1)
	-- function 24
	self._spawning = not arg_24_1
end

AdventureSpawning.add_spawn_point = function (self, arg_25_1)
	-- function 25
	local local_position = Unit.local_position(arg_25_1, 0)
	local local_rotation = Unit.local_rotation(arg_25_1, 0)
	local tbl = {
		pos = Vector3Box(local_position),
		rot = QuaternionBox(local_rotation)
	}
	local get_data = Unit.get_data(arg_25_1, "from_game_mode")
	local flag = get_data == "" or not get_data or "default"
	local _spawn_points = self._spawn_points
	local var_25_6 = self._spawn_points[flag]

	var_25_6 = var_25_6 or {}
	_spawn_points[flag] = var_25_6
	self._spawn_points[flag][#self._spawn_points[flag] + 1] = tbl
end

AdventureSpawning.get_spawn_point = function (self)
	-- function 26
	local str = "default"
	local get_last_mechanism_switch = Managers.mechanism:get_last_mechanism_switch()
	local get_prior_state = Managers.mechanism:get_prior_state()

	get_prior_state = get_prior_state or str

	local var_26_3 = self._spawn_points[get_prior_state]

	if not var_26_3 then
		var_26_3 = self._spawn_points[get_last_mechanism_switch]
		var_26_3 = var_26_3 or self._spawn_points[str]
	end

	self._num_spawn_points_used = self._num_spawn_points_used + 1

	if self._num_spawn_points_used > #var_26_3 then
		self._num_spawn_points_used = 1
	end

	local var_26_4 = var_26_3[self._num_spawn_points_used]

	return var_26_4.pos, var_26_4.rot
end

AdventureSpawning.respawn_unit_spawned = function (self, arg_27_1)
	-- function 27
	self._respawn_handler:respawn_unit_spawned(arg_27_1)
end

AdventureSpawning.respawn_gate_unit_spawned = function (self, arg_28_1)
	-- function 28
	self._respawn_handler:respawn_gate_unit_spawned(arg_28_1)
end

AdventureSpawning.remove_respawn_units_due_to_crossroads = function (self, arg_29_1, arg_29_2)
	-- function 29
	self._respawn_handler:remove_respawn_units_due_to_crossroads(arg_29_1, arg_29_2)
end

AdventureSpawning.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 30
	self._respawn_handler:recalc_respawner_dist_due_to_crossroads()
end

AdventureSpawning.teleport_despawned_players = function (self, arg_31_1)
	-- function 31
	local occupied_slots = self._side.party.occupied_slots
	local player = Managers.player

	for i = 1, #occupied_slots do
		local var_31_2 = occupied_slots[i]
		local peer_id = var_31_2.peer_id
		local local_player_id = var_31_2.local_player_id
		local flag = not peer_id and not local_player_id and player:player(peer_id, local_player_id)

		if not (not flag and flag.player_unit) then
			var_31_2.game_mode_data.position:store(arg_31_1)
		end
	end
end

AdventureSpawning.force_respawn = function (arg_32_0, arg_32_1, arg_32_2)
	-- function 32
	Managers.party:get_player_status(arg_32_1, arg_32_2).game_mode_data.spawn_state = "force_respawn"
end

AdventureSpawning.force_respawn_dead_players = function (self)
	-- function 33
	local party = self._side.party

	self._respawn_handler:force_respawn_dead_players(party)
end

AdventureSpawning.set_override_respawn_group = function (self, arg_34_1, arg_34_2)
	-- function 34
	self._respawn_handler:set_override_respawn_group(arg_34_1, arg_34_2)
end

AdventureSpawning.set_respawn_group_enabled = function (self, arg_35_1, arg_35_2)
	-- function 35
	self._respawn_handler:set_respawn_group_enabled(arg_35_1, arg_35_2)
end

AdventureSpawning.set_respawn_gate_enabled = function (self, arg_36_1, arg_36_2)
	-- function 36
	self._respawn_handler:set_respawn_gate_enabled(arg_36_1, arg_36_2)
end

AdventureSpawning.get_active_respawn_units = function (self)
	-- function 37
	return self._respawn_handler:get_active_respawn_units()
end

AdventureSpawning.get_available_and_active_respawn_units = function (self)
	-- function 38
	return self._respawn_handler:get_available_and_active_respawn_units()
end

AdventureSpawning.set_move_dead_players_to_next_respawn = function (self, arg_39_1)
	-- function 39
	self._respawn_handler:set_move_dead_players_to_next_respawn(arg_39_1)
end

AdventureSpawning.get_respawn_handler = function (self)
	-- function 40
	return self._respawn_handler
end

AdventureSpawning.add_spawn_point_to_spawn_group = function (self, arg_41_1)
	-- function 41
	if not self._spawn_groups then
		self._spawn_groups = {}
	end

	local local_position = Unit.local_position(arg_41_1, 0)
	local local_rotation = Unit.local_rotation(arg_41_1, 0)
	local tbl = {
		pos = Vector3Box(local_position),
		rot = QuaternionBox(local_rotation)
	}
	local get_data = Unit.get_data(arg_41_1, "spawn_group")

	fassert(get_data, "spawn group property missing from spawn point unit")

	if not self._spawn_groups[get_data] then
		self._spawn_groups[get_data] = {}
	end

	local count = #self._spawn_groups[get_data]

	self._spawn_groups[get_data][count + 1] = tbl
end

AdventureSpawning.get_spawn_point_from_spawn_group = function (self, arg_42_1)
	-- function 42
	if not self._used_spawn_group_positions then
		self._used_spawn_group_positions = {}
	end

	local var_42_0 = self._spawn_groups[arg_42_1]
	local flag = not var_42_0 and #var_42_0

	fassert(flag, "no spawn points exists for indicated spawn group: ", arg_42_1)

	if not self._used_spawn_group_positions[arg_42_1] then
		self._used_spawn_group_positions[arg_42_1] = self._used_spawn_group_positions[arg_42_1] + 1
	else
		self._used_spawn_group_positions[arg_42_1] = 1
	end

	local var_42_2 = var_42_0[self._used_spawn_group_positions[arg_42_1]]

	return var_42_2.pos, var_42_2.rot
end

AdventureSpawning.rpc_to_server_spawn_failed = function (self, arg_43_1, arg_43_2)
	-- function 43
	print("[AdventureSpawning] Client detected spawning mismatch. Trying again.")

	local var_43_0 = CHANNEL_TO_PEER_ID[arg_43_1]
	local occupied_slots = self._side.party.occupied_slots

	for i = 1, #occupied_slots do
		local var_43_2 = occupied_slots[i]
		local peer_id = var_43_2.peer_id
		local local_player_id = var_43_2.local_player_id

		if not (var_43_0 ~= peer_id or arg_43_2 ~= local_player_id) then
			local game_mode_data = var_43_2.game_mode_data

			if game_mode_data.spawn_state == "initial_spawning" then
				game_mode_data.spawn_state = "is_initial_spawn"

				break
			end

			if game_mode_data.spawn_state == "spawning" then
				game_mode_data.spawn_state = "spawn"

				break
			end

			print("[AdventureSpawning] This shouldn't happen. How did we leave spawning?")

			break
		end
	end
end
