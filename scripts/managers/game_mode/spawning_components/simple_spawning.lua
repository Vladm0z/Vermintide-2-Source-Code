-- chunkname: @scripts/managers/game_mode/spawning_components/simple_spawning.lua

require("scripts/managers/game_mode/spawning_components/spawning_helper")

SimpleSpawning = class(SimpleSpawning)

local var_0_0 = {
	"rpc_to_server_spawn_failed"
}

SimpleSpawning.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._profile_synchronizer = arg_1_1
	arg_1_0._spawn_point_groups = {}
	arg_1_0._peers_ongoing_game_object_sync = {}
	arg_1_0._use_spawn_point_groups = arg_1_2
end

SimpleSpawning.register_rpcs = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_1:register(arg_2_0, unpack(var_0_0))

	arg_2_0._network_event_delegate = arg_2_1
end

SimpleSpawning.unregister_rpcs = function (arg_3_0)
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil
end

SimpleSpawning.setup_data = function (arg_4_0, arg_4_1, arg_4_2)
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

SimpleSpawning._get_random_spawn_point = function (arg_5_0)
	local var_5_0 = arg_5_0._spawn_point_groups[1]
	local var_5_1 = var_5_0[Math.random(1, #var_5_0)]
	local var_5_2 = var_5_1.pos:unbox()
	local var_5_3 = var_5_1.rot:unbox()

	return var_5_2, var_5_3
end

SimpleSpawning._get_free_spawn_point = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._spawn_point_groups[arg_6_1][arg_6_2]
	local var_6_1 = var_6_0.pos:unbox()
	local var_6_2 = var_6_0.rot:unbox()

	return var_6_1, var_6_2
end

SimpleSpawning.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if Managers.state.network:game() then
		local var_7_0 = Managers.player
		local var_7_1, var_7_2 = Managers.state.network.network_server:peers_ongoing_game_object_sync(arg_7_0._peers_ongoing_game_object_sync)

		for iter_7_0 = 1, var_7_2 do
			local var_7_3 = var_7_1[iter_7_0]

			if not arg_7_0._profile_synchronizer:all_synced_for_peer(var_7_3, 1) then
				return
			end
		end

		local var_7_4 = Managers.party:parties()

		for iter_7_1 = 1, #var_7_4 do
			local var_7_5 = var_7_4[iter_7_1].occupied_slots

			for iter_7_2 = 1, #var_7_5 do
				local var_7_6 = var_7_5[iter_7_2]
				local var_7_7 = var_7_6.peer_id
				local var_7_8 = var_7_6.local_player_id

				if not arg_7_0._profile_synchronizer:all_synced_for_peer(var_7_7, var_7_8) then
					return
				end
			end
		end

		local var_7_9 = arg_7_3.occupied_slots

		for iter_7_3 = 1, #var_7_9 do
			local var_7_10 = var_7_9[iter_7_3]
			local var_7_11 = var_7_10.game_mode_data
			local var_7_12 = var_7_11.spawn_state

			if var_7_12 == "not_spawned" then
				local var_7_13 = arg_7_0._profile_synchronizer
				local var_7_14 = var_7_10.peer_id
				local var_7_15 = var_7_10.local_player_id
				local var_7_16, var_7_17 = var_7_13:profile_by_peer(var_7_14, var_7_15)

				if var_7_0:player(var_7_14, var_7_15) and var_7_16 and var_7_17 and var_7_13:all_synced() then
					local var_7_18
					local var_7_19

					if var_7_11.spawn_pos_stored then
						var_7_18 = var_7_11.position:unbox()
						var_7_19 = var_7_11.rotation:unbox()
					elseif arg_7_0._use_spawn_point_groups then
						var_7_18, var_7_19 = arg_7_0:_get_free_spawn_point(arg_7_3.party_id, iter_7_3)
					else
						var_7_18, var_7_19 = arg_7_0:_get_random_spawn_point()
					end

					local var_7_20 = false
					local var_7_21 = 100
					local var_7_22 = 100
					local var_7_23 = 100
					local var_7_24 = NetworkLookup.item_names["n/a"]
					local var_7_25 = arg_7_0._profile_synchronizer:cached_inventory_hash(var_7_14, var_7_15)

					Managers.state.network.network_transmit:send_rpc("rpc_to_client_spawn_player", var_7_14, var_7_15, var_7_16, var_7_17, var_7_18, var_7_19, var_7_20, var_7_21, var_7_22, var_7_23, var_7_24, var_7_24, var_7_24, {}, {}, var_7_25)

					var_7_11.spawn_state = "spawning"
				end
			elseif var_7_12 == "spawning" then
				local var_7_26 = var_7_10.peer_id
				local var_7_27 = var_7_10.local_player_id

				if var_7_0:player(var_7_26, var_7_27).player_unit then
					var_7_11.spawn_state = "spawned"
				end
			elseif var_7_12 == "spawned" then
				local var_7_28 = var_7_10.peer_id
				local var_7_29 = var_7_10.local_player_id
				local var_7_30 = var_7_0:player(var_7_28, var_7_29).player_unit

				if not var_7_30 then
					var_7_11.spawn_state = "not_spawned"
				else
					local var_7_31 = ScriptUnit.extension(var_7_30, "locomotion_system"):last_position_on_navmesh()

					var_7_11.position:store(var_7_31)
					var_7_11.rotation:store(Unit.local_rotation(var_7_30, 0))

					var_7_11.spawn_pos_stored = true
				end
			end
		end
	end
end

SimpleSpawning.flow_callback_add_spawn_point = function (arg_8_0, arg_8_1)
	local var_8_0 = Unit.local_position(arg_8_1, 0)
	local var_8_1 = Unit.local_rotation(arg_8_1, 0)
	local var_8_2 = {
		pos = Vector3Box(var_8_0),
		rot = QuaternionBox(var_8_1)
	}
	local var_8_3 = arg_8_0._use_spawn_point_groups and tonumber(Unit.get_data(arg_8_1, "group")) or 1
	local var_8_4 = arg_8_0._spawn_point_groups[var_8_3]

	if not var_8_4 then
		var_8_4 = {}
		arg_8_0._spawn_point_groups[var_8_3] = var_8_4
	end

	var_8_4[#var_8_4 + 1] = var_8_2
end

SimpleSpawning.rpc_to_server_spawn_failed = function (arg_9_0, arg_9_1, arg_9_2)
	print("[SimpleSpawning] Client detected spawning mismatch. Trying again.")

	local var_9_0 = CHANNEL_TO_PEER_ID[arg_9_1]
	local var_9_1 = Managers.party:parties()

	for iter_9_0 = 1, #var_9_1 do
		local var_9_2 = var_9_1[iter_9_0].occupied_slots

		for iter_9_1 = 1, #var_9_2 do
			local var_9_3 = var_9_2[iter_9_1]
			local var_9_4 = var_9_3.peer_id
			local var_9_5 = var_9_3.local_player_id

			if var_9_0 == var_9_4 and arg_9_2 == var_9_5 then
				local var_9_6 = var_9_3.game_mode_data

				if var_9_6.spawn_state == "spawning" then
					var_9_6.spawn_state = "not_spawned"

					break
				end

				print("[SimpleSpawning] This shouldn't happen. How did we leave spawning?")

				break
			end
		end
	end
end
