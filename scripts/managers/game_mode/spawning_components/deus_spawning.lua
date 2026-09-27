-- chunkname: @scripts/managers/game_mode/spawning_components/deus_spawning.lua

require("scripts/managers/spawn/respawn_handler")
require("scripts/managers/game_mode/spawning_components/spawning_helper")

local num = 0.5
local num_2 = 1
local tbl = {
	"rpc_to_server_spawn_failed"
}

DeusSpawning = class(DeusSpawning)

DeusSpawning.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	self._profile_synchronizer = arg_1_1
	self._side = arg_1_2
	self._is_server = arg_1_3
	self._network_server = arg_1_4
	self._respawns_enabled = true
	self._spawning = true
	self._respawn_handler = RespawnHandler:new(arg_1_1, arg_1_3)
	self._peers_ongoing_game_object_sync = {}
	self._spawn_points = {}
	self._num_spawn_points_used = 0
	self._status_updates_active = true
	self._delayed_clients = {}
	self._deus_run_controller = arg_1_5
end

DeusSpawning.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	arg_2_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_2_1

	self._respawn_handler:register_rpcs(arg_2_1, arg_2_2)
end

DeusSpawning.unregister_rpcs = function (self)
	-- function 3
	self._respawn_handler:unregister_rpcs()
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

DeusSpawning._restore_player_game_mode_data = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local restore_game_mode_data = self._deus_run_controller:restore_game_mode_data(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	restore_game_mode_data.temporary_health_percentage = 0
	restore_game_mode_data.ability_cooldown_percentage = 1
	restore_game_mode_data.last_update = -math.huge

	local time = Managers.time:time("client_ingame")
	local flag = time == nil or time < 10
	local var_4_3
	local var_4_4

	if not flag then
		var_4_3, var_4_4 = self:get_spawn_point()
	else
		local conflict = Managers.state.conflict
		local get_main_paths = conflict.level_analysis:get_main_paths()
		local main_path_info = conflict.main_path_info
		local main_path_player_info = conflict.main_path_player_info

		var_4_3, var_4_4 = MainPathUtils.get_main_path_point_between_players(get_main_paths, main_path_info, main_path_player_info)
	end

	restore_game_mode_data.position = var_4_3
	restore_game_mode_data.rotation = var_4_4

	if restore_game_mode_data.health_state ~= "alive" then
		restore_game_mode_data.health_state = "dead"
		restore_game_mode_data.ready_for_respawn = true
	end

	if restore_game_mode_data.health_state == "dead" then
		restore_game_mode_data.spawn_state = "not_spawned"
	elseif not flag then
		restore_game_mode_data.spawn_state = "is_initial_spawn"
	else
		restore_game_mode_data.spawn_state = "spawn"
	end

	if restore_game_mode_data.health_state == "alive" then
		local var_4_9 = num

		restore_game_mode_data.health_percentage = math.max(restore_game_mode_data.health_percentage, var_4_9)
	end

	restore_game_mode_data.needs_initial_buffs = true

	return restore_game_mode_data
end

DeusSpawning._check_observer_camera = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()

	if not (not (self._deus_run_controller:get_player_health_state(arg_5_1, arg_5_2) == "dead") and arg_5_1 == get_own_peer_id) then
		local var_5_1 = PEER_ID_TO_CHANNEL[arg_5_1]

		RPC.rpc_set_observer_camera(var_5_1, arg_5_2)
	end
end

DeusSpawning._unassign_data_from_slot = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_1.game_mode_data = {}
end

DeusSpawning.player_entered_game_session = function (self, arg_7_1, arg_7_2)
	-- function 7
	local get_player_status = Managers.party:get_player_status(arg_7_1, arg_7_2)

	if not get_player_status.career_index then
		get_player_status.game_mode_data = self:_restore_player_game_mode_data(arg_7_1, arg_7_2, get_player_status.profile_index, get_player_status.career_index)
	end
end

DeusSpawning.player_joined_party = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	return
end

DeusSpawning.player_left_party = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	return
end

DeusSpawning.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not Managers.state.network:game() then
		self._respawn_handler:update(arg_10_2, arg_10_1)
	end
end

DeusSpawning.server_update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not Managers.state.network:game() then
		local occupied_slots = self._side.party.occupied_slots

		if not self._status_updates_active then
			self:_update_player_status(arg_11_1, arg_11_2, occupied_slots)
		end

		local allow_respawns = Managers.state.difficulty:get_difficulty_settings().allow_respawns

		if not self._respawns_enabled and not allow_respawns then
			self._respawn_handler:server_update(arg_11_2, arg_11_1, occupied_slots)
		end

		self:_update_spawning(arg_11_2, arg_11_1, occupied_slots)
		self:_update_joining_clients(arg_11_2, arg_11_1)
	end
end

DeusSpawning.profile_changed = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local get_player_status = Managers.party:get_player_status(arg_12_1, arg_12_2)

	get_player_status.game_mode_data = self:_restore_player_game_mode_data(arg_12_1, arg_12_2, get_player_status.profile_index, get_player_status.career_index)
end

local tbl_2 = {}

DeusSpawning._update_player_status = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local player = Managers.player
	local extension = ScriptUnit.extension

	for i = 1, #arg_13_3 do
		local var_13_2 = arg_13_3[i]
		local game_mode_data = var_13_2.game_mode_data
		local peer_id = var_13_2.peer_id
		local local_player_id = var_13_2.local_player_id

		if not peer_id and not local_player_id then
			local player_2 = player:player(peer_id, local_player_id)

			if not player_2 then
				local spawn_state = game_mode_data.spawn_state

				if spawn_state == "force_respawn" then
					if Unit.alive(player_2.player_unit) or not self._profile_synchronizer:all_synced() then
						game_mode_data.spawn_state = "spawn"
					end
				elseif spawn_state == "spawned" then
					local player_unit = player_2.player_unit

					if not player_unit then
						game_mode_data.needs_initial_buffs = true
					else
						if not game_mode_data.needs_initial_buffs then
							self:_apply_initial_buffs(player_2)

							game_mode_data.needs_initial_buffs = false
						end

						local last_position_on_navmesh = extension(player_unit, "locomotion_system"):last_position_on_navmesh()

						game_mode_data.position:store(last_position_on_navmesh)
						game_mode_data.rotation:store(Unit.local_rotation(player_unit, 0))

						local var_13_10 = extension(player_unit, "status_system")
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

						local var_13_13 = extension(player_unit, "health_system")
						local var_13_14 = extension(player_unit, "career_system")

						if not (not is_dead and game_mode_data.health_state == "respawning") then
							game_mode_data.health_percentage = var_13_13:current_permanent_health_percent()
							game_mode_data.temporary_health_percentage = var_13_13:current_temporary_health_percent()
							game_mode_data.ability_cooldown_percentage = var_13_14:current_ability_cooldown_percentage()
						end

						if not DamageUtils.is_in_inn then
							local var_13_15 = extension(player_unit, "inventory_system")

							SpawningHelper.fill_consumable_table(game_mode_data.consumables, var_13_15)
							SpawningHelper.fill_ammo_percentage(game_mode_data.ammo, var_13_15, player_unit)

							game_mode_data.additional_items = var_13_15:get_additional_items_table()
						end

						local active_buffs = extension(player_unit, "buff_system"):active_buffs()

						table.clear(tbl_2)

						local num = 1

						for k, v in pairs(active_buffs) do
							local template = v.template

							if v.removed or not template.is_persistent then
								tbl_2[num] = template.name
								num = num + 1
							end
						end

						self._deus_run_controller:save_game_mode_data(peer_id, local_player_id, var_13_2.profile_index, var_13_2.career_index, game_mode_data)
						self._deus_run_controller:save_persistent_buffs(peer_id, local_player_id, var_13_2.profile_index, var_13_2.career_index, tbl_2)
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

DeusSpawning._apply_initial_buffs = function (self, arg_14_1)
	-- function 14
	local player_unit = arg_14_1.player_unit
	local network_id = arg_14_1:network_id()
	local local_player_id = arg_14_1:local_player_id()
	local system = Managers.state.entity:system("buff_system")
	local get_player_persistent_buffs = self._deus_run_controller:get_player_persistent_buffs(network_id, local_player_id)

	for i, v in ipairs(get_player_persistent_buffs) do
		system:add_buff(player_unit, v, player_unit)
	end

	local get_player_power_ups = self._deus_run_controller:get_player_power_ups(arg_14_1.peer_id, local_player_id)

	for i_2, v_2 in ipairs(get_player_power_ups) do
		local var_14_6 = DeusPowerUps[v_2.rarity][v_2.name]

		if not var_14_6.talent then
			system:add_buff(player_unit, var_14_6.buff_name, player_unit)
		end
	end

	local get_party_power_ups = self._deus_run_controller:get_party_power_ups()

	for i_3, v_3 in ipairs(get_party_power_ups) do
		local var_14_8 = DeusPowerUps[v_3.rarity][v_3.name]

		system:add_buff(player_unit, var_14_8.buff_name, player_unit)
	end
end

DeusSpawning._update_spawning = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	if not self._spawning then
		local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
		local flag = false
		local peers_ongoing_game_object_sync, var_15_3 = Managers.state.network.network_server:peers_ongoing_game_object_sync(self._peers_ongoing_game_object_sync)

		for i = 1, var_15_3 do
			local var_15_4 = peers_ongoing_game_object_sync[i]

			if not self._profile_synchronizer:all_synced_for_peer(var_15_4, 1) then
				return
			end
		end

		for j = 1, #arg_15_3 do
			local var_15_5 = arg_15_3[j]
			local peer_id = var_15_5.peer_id
			local local_player_id = var_15_5.local_player_id

			if not self._profile_synchronizer:all_synced_for_peer(peer_id, local_player_id) then
				return
			end

			if not (peer_id ~= get_own_peer_id or local_player_id ~= num_2) then
				flag = true
			end
		end

		if not flag then
			return
		end

		local _network_server = self._network_server

		for k = 1, #arg_15_3 do
			local var_15_9 = arg_15_3[k]
			local spawn_state = var_15_9.game_mode_data.spawn_state
			local var_15_11

			if not DEDICATED_SERVER then
				var_15_11 = _network_server.game_session ~= nil
			else
				var_15_11 = _network_server:is_peer_ingame(var_15_9.peer_id)
			end

			local flag_2 = spawn_state == "is_initial_spawn" or spawn_state == "spawn"

			if not var_15_11 and not flag_2 then
				if not var_15_9.is_bot then
					self:_spawn_bot(var_15_9)
				else
					self:_spawn_player(var_15_9)
				end
			end
		end
	end
end

DeusSpawning.add_delayed_client = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	arg_16_0._delayed_clients[#arg_16_0._delayed_clients + 1] = {
		peer_id = arg_16_1,
		local_player_id = arg_16_2
	}
end

DeusSpawning.remove_delayed_client = function (self, arg_17_1, arg_17_2)
	-- function 17
	for i = #self._delayed_clients, 1, -1 do
		local var_17_0 = self._delayed_clients[i]

		if not (var_17_0.peer_id ~= arg_17_1 or var_17_0.local_player_id ~= arg_17_2) then
			table.remove(self._delayed_clients, i)

			return
		end
	end
end

DeusSpawning._update_joining_clients = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not self._spawning and not self._profile_synchronizer:all_synced() then
		local _network_server = self._network_server

		for i = #self._delayed_clients, 1, -1 do
			local var_18_1 = self._delayed_clients[i]
			local peer_id = var_18_1.peer_id
			local local_player_id = var_18_1.local_player_id

			if not _network_server:is_peer_ingame(peer_id) then
				self:_add_client_to_party(peer_id, local_player_id)
				table.remove(self._delayed_clients, i)
			end
		end
	end
end

DeusSpawning._add_client_to_party = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local num = 1

	if Managers.party:get_player_status(arg_19_1, arg_19_2).party_id ~= num then
		local flag = true
		local remove_bot = Managers.state.game_mode:remove_bot(num, arg_19_1, arg_19_2, flag)

		Managers.party:request_join_party(arg_19_1, arg_19_2, num, nil, remove_bot)
	end
end

DeusSpawning._spawn_player = function (self, arg_20_1)
	-- function 20
	local game_mode_data = arg_20_1.game_mode_data
	local _find_spawn_point, var_20_2 = self:_find_spawn_point(arg_20_1)
	local flag = game_mode_data.spawn_state == "is_initial_spawn"

	if not Managers.state.network:game() then
		local peer_id = arg_20_1.peer_id
		local local_player_id = arg_20_1.local_player_id
		local profile_index = arg_20_1.profile_index
		local career_index = arg_20_1.career_index
		local netpack_consumables = SpawningHelper.netpack_consumables(game_mode_data.consumables)
		local var_20_9, var_20_10, var_20_11 = unpack(netpack_consumables)
		local netpack_additional_items = SpawningHelper.netpack_additional_items(game_mode_data.additional_items)
		local tbl = {}
		local ammo = game_mode_data.ammo
		local floor = math.floor(ammo.slot_melee * 100)
		local floor_2 = math.floor(ammo.slot_ranged * 100)
		local ability_cooldown_percentage = game_mode_data.ability_cooldown_percentage

		ability_cooldown_percentage = ability_cooldown_percentage or 1

		local floor_3 = math.floor(ability_cooldown_percentage * 100)

		printf("rpc_to_client_spawn_player %s %d", tostring(peer_id), local_player_id)

		local cached_inventory_hash = self._profile_synchronizer:cached_inventory_hash(peer_id, local_player_id)

		Managers.state.network.network_transmit:send_rpc("rpc_to_client_spawn_player", peer_id, local_player_id, profile_index, career_index, _find_spawn_point, var_20_2, flag, floor, floor_2, floor_3, var_20_9, var_20_10, var_20_11, netpack_additional_items, tbl, cached_inventory_hash)
	end

	local flag_2

	flag_2 = not flag and "initial_spawning" and "spawning"
	game_mode_data.spawn_state = flag_2
end

DeusSpawning._spawn_bot = function (arg_21_0, arg_21_1)
	-- function 21
	local game_mode_data = arg_21_1.game_mode_data
	local peer_id = arg_21_1.peer_id
	local local_player_id = arg_21_1.local_player_id
	local unbox = game_mode_data.position:unbox()
	local unbox_2 = game_mode_data.rotation:unbox()
	local flag = false
	local consumables = game_mode_data.consumables
	local ammo = game_mode_data.ammo
	local player = Managers.player:player(peer_id, local_player_id)

	fassert(player.bot_player, "Trying to spawn a player as a bot, status info isn't correct")

	local ability_cooldown_percentage = game_mode_data.ability_cooldown_percentage

	ability_cooldown_percentage = ability_cooldown_percentage or 1

	local floor = math.floor(ability_cooldown_percentage * 100)

	player:spawn(unbox, unbox_2, flag, ammo.slot_melee, ammo.slot_ranged, consumables.slot_healthkit, consumables.slot_potion, consumables.slot_grenade, floor)

	game_mode_data.spawn_state = "spawned"
end

DeusSpawning._find_spawn_point = function (self, arg_22_1)
	-- function 22
	local var_22_0
	local var_22_1
	local room = Managers.state.room

	if not room then
		var_22_0, var_22_1 = self:_spawn_pos_rot_from_index(room:get_spawn_point_by_peer(arg_22_1.peer_id))
	else
		local game_mode_data = arg_22_1.game_mode_data

		fassert(game_mode_data.position, "This level is missing spawn-points for the players.")

		var_22_0 = game_mode_data.position:unbox()
		var_22_1 = game_mode_data.rotation:unbox()
	end

	return var_22_0, var_22_1
end

DeusSpawning.force_update_spawn_positions = function (self, arg_23_1, arg_23_2)
	-- function 23
	local occupied_slots = self._side.party.occupied_slots

	for i = 1, #occupied_slots do
		local game_mode_data = occupied_slots[i].game_mode_data

		if not game_mode_data and not game_mode_data.position and not game_mode_data.rotation then
			game_mode_data.position:store(arg_23_1)
			game_mode_data.rotation:store(arg_23_2)
		end
	end
end

DeusSpawning.set_respawning_enabled = function (self, arg_24_1)
	-- function 24
	fassert(self._respawns_enabled ~= arg_24_1, "Respawns already enabled=%s", tostring(arg_24_1))

	self._respawns_enabled = arg_24_1
end

DeusSpawning.set_spawning_disabled = function (self, arg_25_1)
	-- function 25
	self._spawning = not arg_25_1
end

DeusSpawning.add_spawn_point = function (self, arg_26_1)
	-- function 26
	local local_position = Unit.local_position(arg_26_1, 0)
	local local_rotation = Unit.local_rotation(arg_26_1, 0)
	local tbl = {
		pos = Vector3Box(local_position),
		rot = QuaternionBox(local_rotation)
	}
	local get_data = Unit.get_data(arg_26_1, "from_game_mode")

	get_data = get_data == "" or not get_data or "default"

	local _spawn_points = self._spawn_points
	local var_26_5 = self._spawn_points[get_data]

	var_26_5 = var_26_5 or {}
	_spawn_points[get_data] = var_26_5
	self._spawn_points[get_data][#self._spawn_points[get_data] + 1] = tbl
end

DeusSpawning.get_spawn_point = function (self)
	-- function 27
	local str = "default"
	local get_prior_state = Managers.mechanism:get_prior_state()
	local var_27_2 = self._spawn_points[get_prior_state]

	var_27_2 = var_27_2 or self._spawn_points[str]
	self._num_spawn_points_used = self._num_spawn_points_used + 1

	if self._num_spawn_points_used > #var_27_2 then
		self._num_spawn_points_used = 1
	end

	local var_27_3 = var_27_2[self._num_spawn_points_used]

	return var_27_3.pos, var_27_3.rot
end

DeusSpawning.respawn_unit_spawned = function (self, arg_28_1)
	-- function 28
	self._respawn_handler:respawn_unit_spawned(arg_28_1)
end

DeusSpawning.respawn_gate_unit_spawned = function (self, arg_29_1)
	-- function 29
	self._respawn_handler:respawn_gate_unit_spawned(arg_29_1)
end

DeusSpawning.remove_respawn_units_due_to_crossroads = function (self, arg_30_1, arg_30_2)
	-- function 30
	self._respawn_handler:remove_respawn_units_due_to_crossroads(arg_30_1, arg_30_2)
end

DeusSpawning.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 31
	self._respawn_handler:recalc_respawner_dist_due_to_crossroads()
end

DeusSpawning.disable_status_updates = function (self)
	-- function 32
	self._status_updates_active = false
end

DeusSpawning.teleport_despawned_players = function (self, arg_33_1)
	-- function 33
	local occupied_slots = self._side.party.occupied_slots
	local player = Managers.player

	for i = 1, #occupied_slots do
		local var_33_2 = occupied_slots[i]
		local peer_id = var_33_2.peer_id
		local local_player_id = var_33_2.local_player_id
		local flag = not peer_id and not local_player_id and player:player(peer_id, local_player_id)

		if not (not flag and flag.player_unit) then
			var_33_2.game_mode_data.position:store(arg_33_1)
		end
	end
end

DeusSpawning.force_respawn = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	Managers.party:get_player_status(arg_34_1, arg_34_2).game_mode_data.spawn_state = "force_respawn"
end

DeusSpawning.force_respawn_dead_players = function (self)
	-- function 35
	local party = self._side.party

	self._respawn_handler:force_respawn_dead_players(party)
end

DeusSpawning.set_override_respawn_group = function (self, arg_36_1, arg_36_2)
	-- function 36
	self._respawn_handler:set_override_respawn_group(arg_36_1, arg_36_2)
end

DeusSpawning.set_respawn_group_enabled = function (self, arg_37_1, arg_37_2)
	-- function 37
	self._respawn_handler:set_respawn_group_enabled(arg_37_1, arg_37_2)
end

DeusSpawning.set_respawn_gate_enabled = function (self, arg_38_1, arg_38_2)
	-- function 38
	self._respawn_handler:set_respawn_gate_enabled(arg_38_1, arg_38_2)
end

DeusSpawning.get_active_respawn_units = function (self)
	-- function 39
	return self._respawn_handler:get_active_respawn_units()
end

DeusSpawning.get_available_and_active_respawn_units = function (self)
	-- function 40
	return self._respawn_handler:get_available_and_active_respawn_units()
end

DeusSpawning.get_respawn_handler = function (self)
	-- function 41
	return self._respawn_handler
end

DeusSpawning.rpc_to_server_spawn_failed = function (self, arg_42_1, arg_42_2)
	-- function 42
	print("[DeusSpawning] Client detected spawning mismatch. Trying again.")

	local var_42_0 = CHANNEL_TO_PEER_ID[arg_42_1]
	local occupied_slots = self._side.party.occupied_slots

	for i = 1, #occupied_slots do
		local var_42_2 = occupied_slots[i]
		local peer_id = var_42_2.peer_id
		local local_player_id = var_42_2.local_player_id

		if not (var_42_0 ~= peer_id or arg_42_2 ~= local_player_id) then
			local game_mode_data = var_42_2.game_mode_data

			if game_mode_data.spawn_state == "initial_spawning" then
				game_mode_data.spawn_state = "is_initial_spawn"

				break
			end

			if game_mode_data.spawn_state == "spawning" then
				game_mode_data.spawn_state = "spawn"

				break
			end

			print("[DeusSpawning] This shouldn't happen. How did we leave spawning?")

			break
		end
	end
end
