-- chunkname: @scripts/managers/game_mode/spawning_components/simple_spawning.lua

require("scripts/managers/game_mode/spawning_components/spawning_helper")

SimpleSpawning = class(SimpleSpawning)

local tbl = {
	"rpc_to_server_spawn_failed"
}

SimpleSpawning.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._profile_synchronizer = arg_1_1
	self._spawn_point_groups = {}
	self._peers_ongoing_game_object_sync = {}
	self._use_spawn_point_groups = arg_1_2
end

SimpleSpawning.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	arg_2_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_2_1
end

SimpleSpawning.unregister_rpcs = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

SimpleSpawning.setup_data = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	Managers.party:get_player_status(arg_4_1, arg_4_2).game_mode_data = {
		health_state = "alive",
		spawn_pos_stored = false,
		spawn_state = "not_spawned",
		health_percentage = 1,
		temporary_health_percentage = 0,
		position = Vector3Box(),
		rotation = QuaternionBox(),
		ammo = {
			slot_ranged = 1,
			slot_melee = 1
		}
	}
end

SimpleSpawning._get_random_spawn_point = function (self)
	-- function 5
	local var_5_0 = self._spawn_point_groups[1]
	local var_5_1 = var_5_0[Math.random(1, #var_5_0)]
	local unbox = var_5_1.pos:unbox()
	local unbox_2 = var_5_1.rot:unbox()

	return unbox, unbox_2
end

SimpleSpawning._get_free_spawn_point = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = self._spawn_point_groups[arg_6_1][arg_6_2]
	local unbox = var_6_0.pos:unbox()
	local unbox_2 = var_6_0.rot:unbox()

	return unbox, unbox_2
end

SimpleSpawning.update = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not Managers.state.network:game() then
		local player = Managers.player
		local peers_ongoing_game_object_sync, var_7_2 = Managers.state.network.network_server:peers_ongoing_game_object_sync(self._peers_ongoing_game_object_sync)

		for i = 1, var_7_2 do
			local var_7_3 = peers_ongoing_game_object_sync[i]

			if not self._profile_synchronizer:all_synced_for_peer(var_7_3, 1) then
				return
			end
		end

		local parties = Managers.party:parties()

		for j = 1, #parties do
			local occupied_slots = parties[j].occupied_slots

			for k = 1, #occupied_slots do
				local var_7_6 = occupied_slots[k]
				local peer_id = var_7_6.peer_id
				local local_player_id = var_7_6.local_player_id

				if not self._profile_synchronizer:all_synced_for_peer(peer_id, local_player_id) then
					return
				end
			end
		end

		local occupied_slots_2 = arg_7_3.occupied_slots

		for l = 1, #occupied_slots_2 do
			local var_7_10 = occupied_slots_2[l]
			local game_mode_data = var_7_10.game_mode_data
			local spawn_state = game_mode_data.spawn_state

			if spawn_state == "not_spawned" then
				local _profile_synchronizer = self._profile_synchronizer
				local peer_id_2 = var_7_10.peer_id
				local local_player_id_2 = var_7_10.local_player_id
				local profile_by_peer, var_7_17 = _profile_synchronizer:profile_by_peer(peer_id_2, local_player_id_2)

				if not player:player(peer_id_2, local_player_id_2) and not profile_by_peer and not var_7_17 and not _profile_synchronizer:all_synced() then
					local var_7_18
					local var_7_19

					if not game_mode_data.spawn_pos_stored then
						var_7_18 = game_mode_data.position:unbox()
						var_7_19 = game_mode_data.rotation:unbox()
					elseif not self._use_spawn_point_groups then
						var_7_18, var_7_19 = self:_get_free_spawn_point(arg_7_3.party_id, l)
					else
						var_7_18, var_7_19 = self:_get_random_spawn_point()
					end

					local flag = false
					local num = 100
					local num_2 = 100
					local num_3 = 100
					local var_7_24 = NetworkLookup.item_names["n/a"]
					local cached_inventory_hash = self._profile_synchronizer:cached_inventory_hash(peer_id_2, local_player_id_2)

					Managers.state.network.network_transmit:send_rpc("rpc_to_client_spawn_player", peer_id_2, local_player_id_2, profile_by_peer, var_7_17, var_7_18, var_7_19, flag, num, num_2, num_3, var_7_24, var_7_24, var_7_24, {}, {}, cached_inventory_hash)

					game_mode_data.spawn_state = "spawning"
				end
			elseif spawn_state == "spawning" then
				local peer_id_3 = var_7_10.peer_id
				local local_player_id_3 = var_7_10.local_player_id

				if not player:player(peer_id_3, local_player_id_3).player_unit then
					game_mode_data.spawn_state = "spawned"
				end
			elseif spawn_state == "spawned" then
				local peer_id_4 = var_7_10.peer_id
				local local_player_id_4 = var_7_10.local_player_id
				local player_unit = player:player(peer_id_4, local_player_id_4).player_unit

				if not player_unit then
					game_mode_data.spawn_state = "not_spawned"
				else
					local last_position_on_navmesh = ScriptUnit.extension(player_unit, "locomotion_system"):last_position_on_navmesh()

					game_mode_data.position:store(last_position_on_navmesh)
					game_mode_data.rotation:store(Unit.local_rotation(player_unit, 0))

					game_mode_data.spawn_pos_stored = true
				end
			end
		end
	end
end

SimpleSpawning.flow_callback_add_spawn_point = function (self, arg_8_1)
	-- function 8
	local local_position = Unit.local_position(arg_8_1, 0)
	local local_rotation = Unit.local_rotation(arg_8_1, 0)
	local tbl = {
		pos = Vector3Box(local_position),
		rot = QuaternionBox(local_rotation)
	}
	local var_8_3

	if not self._use_spawn_point_groups then
		var_8_3 = tonumber(Unit.get_data(arg_8_1, "group"))

		if not var_8_3 then
			-- Nothing
		end
	end

	var_8_3 = 1

	::label_8_0::

	local var_8_4 = self._spawn_point_groups[var_8_3]

	if not var_8_4 then
		var_8_4 = {}
		self._spawn_point_groups[var_8_3] = var_8_4
	end

	var_8_4[#var_8_4 + 1] = tbl
end

SimpleSpawning.rpc_to_server_spawn_failed = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	print("[SimpleSpawning] Client detected spawning mismatch. Trying again.")

	local var_9_0 = CHANNEL_TO_PEER_ID[arg_9_1]
	local parties = Managers.party:parties()

	for i = 1, #parties do
		local occupied_slots = parties[i].occupied_slots

		for j = 1, #occupied_slots do
			local var_9_3 = occupied_slots[j]
			local peer_id = var_9_3.peer_id
			local local_player_id = var_9_3.local_player_id

			if not (var_9_0 ~= peer_id or arg_9_2 ~= local_player_id) then
				local game_mode_data = var_9_3.game_mode_data

				if game_mode_data.spawn_state == "spawning" then
					game_mode_data.spawn_state = "not_spawned"

					break
				end

				print("[SimpleSpawning] This shouldn't happen. How did we leave spawning?")

				break
			end
		end
	end
end
