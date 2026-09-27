-- chunkname: @scripts/managers/spawn/respawn_handler.lua

RespawnHandler = class(RespawnHandler)

local num = 70
local num_2 = 20
local num_3 = 30
local num_4 = 10
local num_5 = 2
local tbl = {
	"rpc_to_client_respawn_player",
	"rpc_respawn_confirmed"
}

RespawnHandler.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._profile_synchronizer = arg_1_1
	self._respawn_units = {}
	self._respawn_gate_units = {}
	self._respawn_gate_units_n = 0
	self._respawner_groups = {}
	self._disabled_respawn_groups = {}
	self._active_overridden_units = {}
	self._active_overrides = {}
	self._delayed_respawn_queue = {}
	self._world = Managers.world:world("level_world")
	self._id = 0
	self._path_break_points = {}
	self._boss_door_dist_lookup = {}
	self._next_move_players_t = 0
	self._respawn_distance = num
	self._is_server = arg_1_2

	local mechanism_try_call, var_1_1, var_1_2 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "hero_rescues_enabled")

	if not mechanism_try_call and not var_1_2 and not var_1_1 then
		self._custom_game_respawn_time_override = num_3
		self._respawn_distance = num_2
	end
end

RespawnHandler.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	arg_2_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_2_1
	self._network_transmit = arg_2_2
end

RespawnHandler.unregister_rpcs = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._network_transmit = nil
end

RespawnHandler.set_respawn_unit_available = function (self, arg_4_1)
	-- function 4
	local find_respawn_data_from_unit = self:find_respawn_data_from_unit(arg_4_1)

	if not find_respawn_data_from_unit then
		find_respawn_data_from_unit.available = true
	end
end

RespawnHandler.find_respawn_data_from_unit = function (self, arg_5_1)
	-- function 5
	local _respawn_units = self._respawn_units
	local count = #_respawn_units

	for i = 1, count do
		local var_5_2 = _respawn_units[i]

		if arg_5_1 == var_5_2.unit then
			return var_5_2
		end
	end

	return nil
end

local function fn(self, arg_6_1)
	-- function 6
	local distance_through_level = self.distance_through_level
	local distance_through_level_2 = arg_6_1.distance_through_level

	fassert(distance_through_level, "ctrl-shift-l needs running on loaded level for respawn points")
	fassert(distance_through_level_2, "ctrl-shift-l needs running on loaded level for respawn points")

	return distance_through_level < distance_through_level_2
end

RespawnHandler.set_override_respawn_group = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self._respawner_groups[arg_7_1]

	if not var_7_0 then
		print("WARNING: Override Player Respawning, bad group-id: '" .. tostring(arg_7_1) .. "'' (not registered).")

		return
	end

	print("Override Player Respawning", arg_7_1, arg_7_2)

	local _active_overridden_units = self._active_overridden_units
	local _active_overrides = self._active_overrides

	if not arg_7_2 then
		_active_overrides[arg_7_1] = true

		for k, v in pairs(var_7_0) do
			_active_overridden_units[k] = v
		end
	else
		_active_overrides[arg_7_1] = nil

		for k_2, v_2 in pairs(var_7_0) do
			_active_overridden_units[k_2] = nil
		end
	end
end

RespawnHandler.set_respawn_group_enabled = function (self, arg_8_1, arg_8_2)
	-- function 8
	print("Setting player respawning group enabled", arg_8_1, arg_8_2)

	local _disabled_respawn_groups = self._disabled_respawn_groups

	if not arg_8_2 then
		_disabled_respawn_groups[arg_8_1] = true
	else
		_disabled_respawn_groups[arg_8_1] = nil
	end
end

RespawnHandler.set_respawn_gate_enabled = function (self, arg_9_1, arg_9_2)
	-- function 9
	print("Setting player respawning gate enabled", arg_9_2)

	local _respawn_gate_units = self._respawn_gate_units

	for i = 1, self._respawn_gate_units_n do
		local var_9_1 = _respawn_gate_units[i]

		if var_9_1.unit == arg_9_1 then
			print("gate at travel distance set enabled", var_9_1.distance_through_level, arg_9_2)

			var_9_1.enabled = arg_9_2

			return
		end
	end
end

RespawnHandler.respawn_unit_spawned = function (self, arg_10_1)
	-- function 10
	local get_data = Unit.get_data(arg_10_1, "distance_through_level")
	local get_data_2 = Unit.get_data(arg_10_1, "respawn_group_id")

	self._id = self._id + 1

	local tbl = {
		available = true,
		id = self._id,
		unit = arg_10_1,
		distance_through_level = get_data,
		group_id = get_data_2
	}

	self._respawn_units[#self._respawn_units + 1] = tbl

	table.sort(self._respawn_units, fn)

	if not (not get_data_2 and get_data_2 == "") then
		local var_10_3 = self._respawner_groups[get_data_2]

		if not var_10_3 then
			var_10_3 = {}
			self._respawner_groups[get_data_2] = var_10_3
		end

		tbl.group_data = var_10_3
		var_10_3[arg_10_1] = tbl

		print("respawn_unit_spawned with group id:", get_data_2)
	end
end

RespawnHandler.respawn_gate_unit_spawned = function (self, arg_11_1)
	-- function 11
	local get_data = Unit.get_data(arg_11_1, "distance_through_level")
	local get_data_2 = Unit.get_data(arg_11_1, "gate_enabled")
	local tbl = {
		unit = arg_11_1,
		distance_through_level = get_data,
		enabled = get_data_2
	}

	self._respawn_gate_units_n = self._respawn_gate_units_n + 1
	self._respawn_gate_units[self._respawn_gate_units_n] = tbl

	table.sort(self._respawn_gate_units, fn)
end

RespawnHandler.remove_respawn_units_due_to_crossroads = function (self, arg_12_1, arg_12_2)
	-- function 12
	local debug_player_respawns = script_data.debug_player_respawns
	local var_12_1 = Vector3(0, 0, 1.5)
	local tbl = {}
	local count = #arg_12_1
	local _respawn_units = self._respawn_units

	for i = 1, #_respawn_units do
		local var_12_5 = _respawn_units[i]
		local distance_through_level = var_12_5.distance_through_level

		for j = 1, count do
			local var_12_7 = arg_12_1[j]

			if not (not (distance_through_level >= var_12_7[1] - 1) or not (distance_through_level <= var_12_7[2] + 1)) then
				tbl[#tbl + 1] = i

				if not var_12_5.group_data then
					var_12_5.group_data[var_12_5.unit] = nil
					self._active_overridden_units[var_12_5.unit] = nil
				end

				break
			end
		end
	end

	local _respawner_groups = self._respawner_groups

	for k = #tbl, 1, -1 do
		if not debug_player_respawns then
			local var_12_9 = _respawn_units[tbl[k]]
			local num = Unit.local_position(var_12_9.unit, 0) + var_12_1

			QuickDrawerStay:sphere(num, 0.33, Color(255, 0, 70))

			local format = string.format("respawer removed, old-dist: %d", var_12_9.distance_through_level)

			Debug.world_sticky_text(num + var_12_1, format, "yellow")
		end

		table.remove(_respawn_units, tbl[k])

		tbl[k] = nil
	end
end

RespawnHandler.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 13
	local _respawn_units = self._respawn_units
	local local_position = Unit.local_position

	for i = 1, #_respawn_units do
		local var_13_2 = _respawn_units[i]
		local closest_pos_at_main_path, var_13_4, var_13_5, var_13_6, var_13_7 = MainPathUtils.closest_pos_at_main_path(nil, local_position(var_13_2.unit, 0))

		var_13_2.distance_through_level = var_13_4
	end
end

RespawnHandler.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _delayed_respawn_queue = self._delayed_respawn_queue
	local count = #_delayed_respawn_queue
	local _is_server = self._is_server

	for i = count, 1, -1 do
		local var_14_3 = _delayed_respawn_queue[i]
		local var_14_4 = var_14_3[1]
		local var_14_5 = var_14_3[9]
		local flag = not _is_server and Managers.player:player(var_14_5.peer_id, var_14_5.local_player_id)

		if not (not _is_server and flag == var_14_4) then
			var_14_5.game_mode_data.health_state = "dead"

			table.swap_delete(_delayed_respawn_queue, i)
			print("Player changed before respawn queue was being processed, resetting state to dead.", var_14_5.peer_id, var_14_5.local_player_id)
		elseif not var_14_4 then
			local player_unit = var_14_4.player_unit

			if not (player_unit == nil or Unit.alive(player_unit)) then
				self:_respawn_player(unpack(var_14_3))
				table.swap_delete(_delayed_respawn_queue, i)
			end
		else
			table.swap_delete(_delayed_respawn_queue, i)
		end
	end
end

RespawnHandler._check_all_synced = function (self)
	-- function 15
	if not self._all_synced_checked then
		self._all_synced_checked = true
		self._all_synced = self._profile_synchronizer:all_synced()
	end

	return self._all_synced
end

RespawnHandler.server_update = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	self._all_synced_checked = false
	self._all_synced = false

	local flag = false

	for i = 1, #arg_16_3 do
		local var_16_1 = arg_16_3[i]
		local game_mode_data = var_16_1.game_mode_data
		local flag_2 = game_mode_data.health_state == "dead"

		if not flag_2 then
			if not (game_mode_data.ready_for_respawn or game_mode_data.respawn_timer) then
				local peer_id = var_16_1.peer_id
				local local_player_id = var_16_1.local_player_id
				local var_16_6

				if not Development.parameter("fast_respawns") then
					var_16_6 = num_5
				elseif not self._custom_game_respawn_time_override then
					var_16_6 = self._custom_game_respawn_time_override
				elseif not Managers.mechanism:setting("hero_respawn_time") then
					var_16_6 = Managers.mechanism:setting("hero_respawn_time")
				else
					var_16_6 = num_3
				end

				if not peer_id and not local_player_id then
					local player_unit = Managers.player:player(peer_id, local_player_id).player_unit

					if not player_unit and not Unit.alive(player_unit) then
						var_16_6 = ScriptUnit.extension(player_unit, "buff_system"):apply_buffs_to_value(var_16_6, "faster_respawn")
					end
				end

				game_mode_data.respawn_timer = arg_16_2 + var_16_6
			elseif not (game_mode_data.ready_for_respawn or not (arg_16_2 > game_mode_data.respawn_timer)) then
				game_mode_data.respawn_timer = nil
				game_mode_data.ready_for_respawn = true
			end
		elseif not game_mode_data.respawn_timer then
			game_mode_data.respawn_timer = nil
		end

		if not flag_2 and not game_mode_data.ready_for_respawn and not var_16_1.peer_id and not self:_check_all_synced() then
			local respawn_unit = game_mode_data.respawn_unit
			local var_16_9

			if not respawn_unit and not Unit.alive(respawn_unit) then
				var_16_9 = respawn_unit
			else
				var_16_9 = self:find_best_respawn_point(true, false)
			end

			if not var_16_9 then
				local peer_id_2 = Network.peer_id()
				local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()

				game_mode_data.health_state = "respawning"
				game_mode_data.respawn_unit = var_16_9
				game_mode_data.health_percentage = get_difficulty_settings.respawn.health_percentage
				game_mode_data.temporary_health_percentage = get_difficulty_settings.respawn.temporary_health_percentage

				if peer_id_2 == var_16_1.peer_id then
					local player = Managers.player:player(var_16_1.peer_id, var_16_1.local_player_id)
					local profile_index = var_16_1.profile_index
					local career_index = var_16_1.career_index
					local additional_items = game_mode_data.additional_items
					local slot_health_kit = game_mode_data.consumables.slot_health_kit
					local slot_potion = game_mode_data.consumables.slot_potion
					local slot_grenade = game_mode_data.consumables.slot_grenade

					if game_mode_data.spawn_state == "spawned" then
						self:_delayed_respawn_player(player, profile_index, career_index, var_16_9, slot_health_kit, slot_potion, slot_grenade, additional_items, var_16_1)
					else
						self:_respawn_player(player, profile_index, career_index, var_16_9, slot_health_kit, slot_potion, slot_grenade, additional_items)
					end
				else
					local level_object_id = Managers.state.network:level_object_id(var_16_9)
					local netpack_consumables = SpawningHelper.netpack_consumables(game_mode_data.consumables)
					local var_16_21, var_16_22, var_16_23 = unpack(netpack_consumables)
					local netpack_additional_items = SpawningHelper.netpack_additional_items(game_mode_data.additional_items)

					Managers.state.network.network_transmit:send_rpc("rpc_to_client_respawn_player", var_16_1.peer_id, var_16_1.local_player_id, var_16_1.profile_index, var_16_1.career_index, level_object_id, i, var_16_21, var_16_22, var_16_23, netpack_additional_items)
				end
			end
		elseif not self._move_players and game_mode_data.health_state ~= "respawn" or not self:_check_all_synced() then
			local respawn_unit_2 = game_mode_data.respawn_unit
			local find_respawn_data_from_unit = self:find_respawn_data_from_unit(respawn_unit_2)

			if not find_respawn_data_from_unit and self:_is_respawn_reachable(find_respawn_data_from_unit) and not self._force_move then
				local find_best_respawn_point, var_16_28 = self:find_best_respawn_point(false, false)

				if not (not var_16_28 and var_16_28.group_id == "" or var_16_28.group_id == find_respawn_data_from_unit.group_id) then
					local peer_id_3 = var_16_1.peer_id
					local local_player_id_2 = var_16_1.local_player_id

					if not peer_id_3 and not local_player_id_2 then
						local player_unit_2 = Managers.player:player(peer_id_3, local_player_id_2).player_unit
						local unit_game_object_id = Managers.state.network:unit_game_object_id(player_unit_2)
						local extension = ScriptUnit.extension(player_unit_2, "locomotion_system")

						var_16_28.available = false

						local local_position = Unit.local_position(find_best_respawn_point, 0)
						local local_rotation = Unit.local_rotation(find_best_respawn_point, 0)

						LocomotionUtils.enable_linked_movement(self._world, player_unit_2, find_best_respawn_point, 0, Vector3.zero())
						extension:teleport_to(local_position, local_rotation)
						Managers.state.network.network_transmit:send_rpc_clients("rpc_teleport_unit_to", unit_game_object_id, local_position, local_rotation)
						self:set_respawn_unit_available(respawn_unit_2)

						game_mode_data.respawn_unit = find_best_respawn_point
					end
				end
			end
		end

		flag = flag or game_mode_data.health_state == "respawn"
	end

	if not self._move_players and not self:_check_all_synced() then
		self._move_players = false
		self._force_move = false
	elseif not (not flag and not (arg_16_2 > self._next_move_players_t)) then
		self._next_move_players_t = arg_16_2 + num_4
		self._move_players = true
	end
end

RespawnHandler.set_move_dead_players_to_next_respawn = function (self, arg_17_1)
	-- function 17
	self._move_players = arg_17_1
end

RespawnHandler.queue_force_move_dead_players = function (self)
	-- function 18
	self._move_players = true
	self._force_move = true
end

local tbl_2 = {
	boss_event_chaos_spawn = true,
	boss_event_storm_fiend = true,
	boss_event_chaos_troll = true,
	boss_event_minotaur = true,
	boss_event_rat_ogre = true
}

RespawnHandler.destroy = function (arg_19_0)
	-- function 19
	return
end

RespawnHandler.get_active_respawn_units = function (self)
	-- function 20
	local _respawn_units = self._respawn_units
	local tbl = {}

	for i = 1, #_respawn_units do
		local var_20_2 = _respawn_units[i]

		if not var_20_2.available then
			tbl[#tbl + 1] = var_20_2.unit
		end
	end

	return tbl
end

RespawnHandler.get_available_and_active_respawn_units = function (self)
	-- function 21
	return self._respawn_units
end

RespawnHandler.rpc_to_client_respawn_player = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10)
	-- function 22
	local var_22_0 = CHANNEL_TO_PEER_ID[arg_22_1]

	printf("RespawnSystem:rpc_to_client_respawn_player(%s, %s)", tostring(var_22_0), tostring(arg_22_3))

	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_22_5, true)
	local local_player = Managers.player:local_player(arg_22_2)
	local unnetpack_additional_items = SpawningHelper.unnetpack_additional_items(arg_22_10)

	if local_player:needs_despawn() or not Unit.alive(local_player.player_unit) then
		Managers.state.spawn:delayed_despawn(local_player)
		self:_delayed_respawn_player(local_player, arg_22_3, arg_22_4, game_object_or_level_unit, NetworkLookup.item_names[arg_22_7], NetworkLookup.item_names[arg_22_8], NetworkLookup.item_names[arg_22_9], unnetpack_additional_items)
	else
		self:_respawn_player(local_player, arg_22_3, arg_22_4, game_object_or_level_unit, NetworkLookup.item_names[arg_22_7], NetworkLookup.item_names[arg_22_8], NetworkLookup.item_names[arg_22_9], unnetpack_additional_items)
	end
end

RespawnHandler._respawn_player = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	-- function 23
	arg_23_1:set_profile_index(arg_23_2)
	arg_23_1:set_career_index(arg_23_3)

	local local_position = Unit.local_position(arg_23_4, 0)
	local local_rotation = Unit.local_rotation(arg_23_4, 0)
	local respawn = Managers.state.difficulty:get_difficulty_settings().respawn
	local ammo_melee = respawn.ammo_melee
	local ammo_ranged = respawn.ammo_ranged
	local num = 0
	local spawn = arg_23_1:spawn(local_position, local_rotation, false, ammo_melee, ammo_ranged, arg_23_5, arg_23_6, arg_23_7, num, arg_23_8, nil, arg_23_4)
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(spawn)
	local level_object_id = network:level_object_id(arg_23_4)

	network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.ready_for_assisted_respawn, true, unit_game_object_id, level_object_id)
	network.network_transmit:send_rpc_server("rpc_respawn_confirmed", arg_23_1:local_player_id())
end

RespawnHandler.rpc_respawn_confirmed = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local var_24_0 = CHANNEL_TO_PEER_ID[arg_24_1]

	Managers.party:get_player_status(var_24_0, arg_24_2).game_mode_data.ready_for_respawn = false
end

RespawnHandler.force_respawn_dead_players = function (arg_25_0, arg_25_1)
	-- function 25
	local occupied_slots = arg_25_1.occupied_slots

	for i = 1, #occupied_slots do
		occupied_slots[i].game_mode_data.respawn_timer = 0
	end
end

RespawnHandler._delayed_respawn_player = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	-- function 26
	local tbl = {
		arg_26_1,
		arg_26_2,
		arg_26_3,
		arg_26_4,
		arg_26_5,
		arg_26_6,
		arg_26_7,
		arg_26_8,
		arg_26_9
	}

	table.insert(self._delayed_respawn_queue, tbl)
end

RespawnHandler.is_respawn_enabled = function (self, arg_27_1)
	-- function 27
	local _active_overridden_units = self._active_overridden_units

	if not next(_active_overridden_units) then
		return _active_overridden_units[arg_27_1.unit]
	end

	return not self._disabled_respawn_groups[arg_27_1.group_id]
end

RespawnHandler.is_spawn_group_override_active = function (self, arg_28_1)
	-- function 28
	return self._active_overrides[arg_28_1]
end

RespawnHandler.get_boss_door_dist = function (self, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0 = self._boss_door_dist_lookup[arg_29_2]

	if not var_29_0 then
		return var_29_0
	end

	local world_position = Unit.world_position(arg_29_2, 0)
	local closest_pos_at_main_path, var_29_3 = MainPathUtils.closest_pos_at_main_path(arg_29_1, world_position)

	self._boss_door_dist_lookup[arg_29_2] = var_29_3

	return var_29_3
end

RespawnHandler.get_next_boss_door_dist = function (self, arg_30_1, arg_30_2)
	-- function 30
	local main_paths = arg_30_1.main_paths
	local enemy_recycler = Managers.state.conflict.enemy_recycler
	local var_30_2 = enemy_recycler.main_path_events[enemy_recycler.current_main_path_event_id]
	local flag = not var_30_2 and var_30_2[3]
	local var_30_4 = tbl_2[flag]
	local current_main_path_event_activation_dist = enemy_recycler.current_main_path_event_activation_dist
	local get_boss_door_units = Managers.state.entity:system("door_system"):get_boss_door_units()
	local huge = math.huge
	local huge_2 = math.huge
	local huge_3 = math.huge
	local huge_4 = math.huge

	for i = 1, #get_boss_door_units do
		local var_30_11 = get_boss_door_units[i]
		local get_boss_door_dist = self:get_boss_door_dist(main_paths, var_30_11)
		local num = get_boss_door_dist - arg_30_2

		if not (not (num < huge) or not (num >= 0)) then
			local current_state = ScriptUnit.extension(var_30_11, "door_system").current_state

			if not (not current_state and current_state ~= "closed") then
				huge = num
				huge_2 = get_boss_door_dist
			end
		end

		if not var_30_4 then
			local num_2 = get_boss_door_dist - current_main_path_event_activation_dist

			if not (not (num_2 >= 0) or not (num_2 < huge_3)) then
				huge_3 = num
				huge_4 = get_boss_door_dist
			end
		end
	end

	return math.min(huge_2, huge_4)
end

RespawnHandler.get_next_respawn_gate_dist = function (self, arg_31_1)
	-- function 31
	local _respawn_gate_units = self._respawn_gate_units

	for i = 1, self._respawn_gate_units_n do
		local var_31_1 = _respawn_gate_units[i]

		if not (not var_31_1.enabled and not (arg_31_1 < var_31_1.distance_through_level)) then
			return var_31_1.distance_through_level
		end
	end

	return math.huge
end

RespawnHandler.get_main_path_segment_start = function (arg_32_0, arg_32_1)
	-- function 32
	local current_path_index = arg_32_1.current_path_index

	return arg_32_1.main_paths[current_path_index].travel_dist[1]
end

RespawnHandler.get_behind_unit_segment_start = function (arg_33_0, arg_33_1)
	-- function 33
	local behind_unit = arg_33_1.behind_unit

	if not ALIVE[behind_unit] then
		local local_position = Unit.local_position(behind_unit, 0)
		local closest_pos_at_main_path, var_33_3, var_33_4, var_33_5, var_33_6 = MainPathUtils.closest_pos_at_main_path(nil, local_position, nil)

		return arg_33_1.main_paths[var_33_6].travel_dist[1]
	end

	return 0
end

RespawnHandler.get_respawn_dist_range = function (self, arg_34_1, arg_34_2)
	-- function 34
	local get_main_path_segment_start = self:get_main_path_segment_start(arg_34_1)
	local huge = math.huge
	local get_next_boss_door_dist = self:get_next_boss_door_dist(arg_34_1, arg_34_2)
	local min = math.min(huge, get_next_boss_door_dist)
	local get_next_respawn_gate_dist = self:get_next_respawn_gate_dist(arg_34_2)
	local min_2 = math.min(min, get_next_respawn_gate_dist)

	return get_main_path_segment_start, min_2
end

RespawnHandler._is_respawn_reachable = function (self, arg_35_1)
	-- function 35
	if not arg_35_1 then
		return false
	end

	if not self._active_overridden_units[arg_35_1.unit] then
		return true
	end

	local main_path_info = Managers.state.conflict.main_path_info
	local get_behind_unit_segment_start = self:get_behind_unit_segment_start(main_path_info)

	return arg_35_1.distance_through_level >= get_behind_unit_segment_start - 0.01
end

RespawnHandler.find_best_respawn_point = function (self, arg_36_1, arg_36_2)
	-- function 36
	local main_path_info = Managers.state.conflict.main_path_info
	local ahead_travel_dist = main_path_info.ahead_travel_dist
	local num = ahead_travel_dist + self._respawn_distance
	local get_respawn_dist_range, var_36_4 = self:get_respawn_dist_range(main_path_info, ahead_travel_dist)
	local _respawn_units = self._respawn_units
	local _active_overridden_units = self._active_overridden_units
	local flag = next(_active_overridden_units) ~= nil
	local _disabled_respawn_groups = self._disabled_respawn_groups
	local var_36_9
	local num_2 = 0

	for i = 1, #_respawn_units do
		local var_36_11 = _respawn_units[i]
		local distance_through_level = var_36_11.distance_through_level
		local num_3 = 0

		if not var_36_11.available then
			if not _active_overridden_units[var_36_11.unit] then
				num_3 = 3
			elseif not (_disabled_respawn_groups[var_36_11.group_id] or not (distance_through_level <= var_36_4)) then
				if not (flag or not (num <= distance_through_level)) then
					num_3 = 3
				elseif ahead_travel_dist <= distance_through_level then
					num_3 = 2
				elseif get_respawn_dist_range <= distance_through_level then
					num_3 = 1
				end
			end
		end

		if not (not var_36_9 and (num_2 < num_3 or num_2 ~= num_3 or not (num_3 < 3) or not (distance_through_level > var_36_9.distance_through_level) or not (distance_through_level < num) or not (num_3 >= 3)) and not (distance_through_level < var_36_9.distance_through_level)) then
			num_2 = num_3
			var_36_9 = var_36_11

			if not (arg_36_2 or num_3 >= 3 or not (var_36_4 < distance_through_level)) then
				break
			end
		end
	end

	if not var_36_9 then
		if not arg_36_1 then
			var_36_9.available = false
		end

		local unit = var_36_9.unit

		if not (not flag and _active_overridden_units[unit]) then
			print("[RespawnHandler] Overrides active, but no respawn units available, falling back to noraml respawn point.")
			print(string.format("[RespawnHandler] min_dist %.2f, max_dist %.2f, ahead_unit_travel_dist %.2f", get_respawn_dist_range, var_36_4, ahead_travel_dist))
			print("[RespawnHandler] Active Override:")

			for k in pairs(self._active_overrides) do
				print(k)
			end
		end

		if not arg_36_2 then
			print(string.format("[RespawnHandler] Picking spawn point at %.2f, params: min_dist %.2f, max_dist %.2f, ahead_unit_travel_dist %.2f", var_36_9.distance_through_level, get_respawn_dist_range, var_36_4, ahead_travel_dist))

			local ahead_unit = main_path_info.ahead_unit

			print("[RespawnHandler] Ahead player position", POSITION_LOOKUP[ahead_unit])
		end

		return unit, var_36_9
	end

	return nil, nil
end
