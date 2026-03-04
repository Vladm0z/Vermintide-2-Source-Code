-- chunkname: @scripts/managers/game_mode/spawning_components/adventure_spawning.lua

require("scripts/managers/spawn/respawn_handler")
require("scripts/managers/game_mode/spawning_components/spawning_helper")

local var_0_0 = 1
local var_0_1 = {
	"rpc_to_server_spawn_failed"
}

AdventureSpawning = class(AdventureSpawning)

AdventureSpawning.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0._profile_synchronizer = arg_1_1
	arg_1_0._side = arg_1_2
	arg_1_0._is_server = arg_1_3
	arg_1_0._network_server = arg_1_4
	arg_1_0._respawns_enabled = true
	arg_1_0._spawning = true
	arg_1_0._respawn_handler = RespawnHandler:new(arg_1_1, arg_1_3)
	arg_1_0._spawn_points = {}
	arg_1_0._num_spawn_points_used = 0
	arg_1_0._delayed_clients = {}
	arg_1_0._peers_ongoing_game_object_sync = {}
	arg_1_0._saved_game_mode_data = arg_1_5 or {}

	arg_1_0:_setup_game_mode_data(arg_1_2, arg_1_0._saved_game_mode_data)
end

AdventureSpawning._setup_game_mode_data = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_1.party.num_slots

	for iter_2_0 = 1, var_2_0 do
		arg_2_2[iter_2_0] = arg_2_2[iter_2_0] or {}
	end
end

AdventureSpawning.get_saved_game_mode_data = function (arg_3_0)
	return arg_3_0._saved_game_mode_data
end

AdventureSpawning.register_rpcs = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_1:register(arg_4_0, unpack(var_0_1))

	arg_4_0._network_event_delegate = arg_4_1

	arg_4_0._respawn_handler:register_rpcs(arg_4_1, arg_4_2)
end

AdventureSpawning.unregister_rpcs = function (arg_5_0)
	arg_5_0._respawn_handler:unregister_rpcs()
	arg_5_0._network_event_delegate:unregister(arg_5_0)

	arg_5_0._network_event_delegate = nil
end

AdventureSpawning._assign_data_to_slot = function (arg_6_0, arg_6_1, arg_6_2)
	if table.is_empty(arg_6_2) then
		local var_6_0
		local var_6_1

		if arg_6_0._spawn_groups then
			local var_6_2 = Managers.mechanism:game_mechanism():get_current_spawn_group()

			var_6_0, var_6_1 = arg_6_0:get_spawn_point_from_spawn_group(var_6_2)
		else
			var_6_0, var_6_1 = arg_6_0:get_spawn_point()
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

		local var_6_3 = Managers.state.difficulty:get_difficulty_settings()
		local var_6_4 = Managers.state.game_mode:settings()
		local var_6_5 = {}

		SpawningHelper.default_spawn_items(var_6_5, var_6_3, var_6_4)

		arg_6_2.consumables = var_6_5
	end

	if not arg_6_2.position or not arg_6_2.rotation then
		local var_6_6, var_6_7 = arg_6_0:get_spawn_point()

		arg_6_2.position = var_6_6
		arg_6_2.rotation = var_6_7
	end

	if not arg_6_2.ammo then
		arg_6_2.ammo = {
			slot_ranged = 1,
			slot_melee = 1
		}
	end

	if not arg_6_2.consumables then
		local var_6_8 = Managers.state.difficulty:get_difficulty_settings()
		local var_6_9 = Managers.state.game_mode:settings()
		local var_6_10 = {}

		SpawningHelper.default_spawn_items(var_6_10, var_6_8, var_6_9)

		arg_6_2.consumables = var_6_10
	end

	if not arg_6_2.additional_items then
		arg_6_2.additional_items = {}
	end

	local var_6_11 = arg_6_2.health_state ~= "dead"

	if arg_6_2.spawn_state == nil or var_6_11 then
		local var_6_12 = Managers.time:time("client_ingame")

		arg_6_2.spawn_state = (var_6_12 == nil or var_6_12 < 10) and "is_initial_spawn" or "spawn"
	end

	local var_6_13 = arg_6_1.peer_id
	local var_6_14 = Network.peer_id()

	if not var_6_11 and var_6_13 ~= var_6_14 then
		local var_6_15 = arg_6_1.local_player_id
		local var_6_16 = PEER_ID_TO_CHANNEL[var_6_13]

		RPC.rpc_set_observer_camera(var_6_16, var_6_15)
	end

	arg_6_1.game_mode_data = arg_6_2
end

AdventureSpawning._unassign_data_from_slot = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.health_state

	if var_7_0 == "respawning" or var_7_0 == "respawn" then
		arg_7_2.health_state = "dead"
		arg_7_2.ready_for_respawn = true
	end

	local var_7_1 = arg_7_2.spawn_state

	if var_7_1 == "spawned" or var_7_1 == "spawning" or var_7_1 == "spawn" then
		arg_7_2.spawn_state = "despawned"
	else
		arg_7_2.spawn_state = "not_spawned"
	end

	arg_7_1.game_mode_data = {}
end

AdventureSpawning.player_entered_game_session = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Managers.party:get_party_from_player_id(arg_8_1, arg_8_2)
	local var_8_1 = arg_8_0._side.party

	if var_8_0 ~= var_8_1 then
		return
	end

	local var_8_2 = Managers.party:get_player_status(arg_8_1, arg_8_2).slot_id
	local var_8_3 = var_8_1.slots[var_8_2]
	local var_8_4 = arg_8_0._saved_game_mode_data[var_8_2]

	arg_8_0:_assign_data_to_slot(var_8_3, var_8_4)
end

AdventureSpawning.player_joined_party = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_0._side.party

	if var_9_0.party_id ~= arg_9_3 then
		return
	end

	local var_9_1 = var_9_0.slots[arg_9_4]
	local var_9_2 = arg_9_0._saved_game_mode_data[arg_9_4]

	arg_9_0:_assign_data_to_slot(var_9_1, var_9_2)
end

AdventureSpawning.player_left_party = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	if arg_10_0._side.party.party_id ~= arg_10_3 then
		return
	end

	local var_10_0 = arg_10_0._saved_game_mode_data[arg_10_4]

	arg_10_0:_unassign_data_from_slot(arg_10_5, var_10_0)
end

AdventureSpawning.update = function (arg_11_0, arg_11_1, arg_11_2)
	if Managers.state.network:game() then
		arg_11_0._respawn_handler:update(arg_11_2, arg_11_1)
	end
end

AdventureSpawning.server_update = function (arg_12_0, arg_12_1, arg_12_2)
	if Managers.state.network:game() then
		local var_12_0 = arg_12_0._side.party
		local var_12_1 = var_12_0.occupied_slots

		arg_12_0:_update_player_status(arg_12_1, arg_12_2, var_12_1)

		local var_12_2 = Managers.state.difficulty:get_difficulty_settings().allow_respawns

		if arg_12_0._respawns_enabled and var_12_2 then
			arg_12_0._respawn_handler:server_update(arg_12_2, arg_12_1, var_12_1)
		end

		arg_12_0:_update_spawning(arg_12_2, arg_12_1, var_12_1, var_12_0.party_id)
		arg_12_0:_update_joining_clients(arg_12_2, arg_12_1)
	end
end

AdventureSpawning._update_player_status = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = Managers.player
	local var_13_1 = ScriptUnit.extension

	for iter_13_0 = 1, #arg_13_3 do
		local var_13_2 = arg_13_3[iter_13_0]
		local var_13_3 = var_13_2.game_mode_data
		local var_13_4 = var_13_2.peer_id
		local var_13_5 = var_13_2.local_player_id

		if var_13_4 and var_13_5 then
			local var_13_6 = Managers.player:player(var_13_4, var_13_5)

			if var_13_6 then
				local var_13_7 = var_13_3.spawn_state

				if var_13_7 == "force_respawn" then
					if not ALIVE[var_13_6.player_unit] and arg_13_0._profile_synchronizer:all_ingame_synced() then
						var_13_3.spawn_state = "spawn"
					end
				elseif var_13_7 == "spawned" then
					local var_13_8 = var_13_6.player_unit

					if var_13_8 then
						local var_13_9 = var_13_1(var_13_8, "locomotion_system"):last_position_on_navmesh()

						var_13_3.position:store(var_13_9)
						var_13_3.rotation:store(Unit.local_rotation(var_13_8, 0))

						local var_13_10 = var_13_1(var_13_8, "status_system")
						local var_13_11 = var_13_3.health_state
						local var_13_12 = var_13_10:is_dead()

						if var_13_12 then
							if var_13_3.health_state ~= "respawning" then
								var_13_3.health_state = "dead"
							end
						elseif var_13_10:is_ready_for_assisted_respawn() then
							var_13_3.health_state = "respawn"
						elseif var_13_10:is_knocked_down() then
							var_13_3.health_state = "knocked_down"
						elseif var_13_10:is_disabled() and not var_13_10:is_in_vortex() and not var_13_10:is_grabbed_by_corruptor() and not var_13_10:is_grabbed_by_chaos_spawn() and not var_13_10:is_overpowered() then
							var_13_3.health_state = "disabled"
						else
							var_13_3.health_state = "alive"

							local var_13_13 = var_13_3.respawn_unit

							if var_13_13 then
								arg_13_0._respawn_handler:set_respawn_unit_available(var_13_13)

								var_13_3.respawn_unit = nil
							end
						end

						local var_13_14 = var_13_1(var_13_8, "health_system")
						local var_13_15 = var_13_1(var_13_8, "career_system")

						if not var_13_12 or var_13_3.health_state ~= "respawning" then
							var_13_3.health_percentage = var_13_14:current_permanent_health_percent()
							var_13_3.temporary_health_percentage = var_13_14:current_temporary_health_percent()
							var_13_3.ability_cooldown_percentage = var_13_15:current_ability_cooldown_percentage()
						end

						if not DamageUtils.is_in_inn then
							local var_13_16 = var_13_1(var_13_8, "inventory_system")

							SpawningHelper.fill_consumable_table(var_13_3.consumables, var_13_16)
							SpawningHelper.fill_ammo_percentage(var_13_3.ammo, var_13_16, var_13_8)

							var_13_3.additional_items = var_13_16:get_additional_items_table()
						end
					end
				elseif var_13_7 == "spawning" or var_13_7 == "initial_spawning" then
					if var_13_6.player_unit then
						var_13_3.spawn_state = "spawned"
					end
				elseif (var_13_7 == "despawned" or var_13_7 == "not_spawned") and var_13_6.player_unit then
					var_13_3.spawn_state = "spawned"
				end
			end
		end
	end
end

AdventureSpawning._update_spawning = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if arg_14_0._spawning then
		local var_14_0 = Network.peer_id()
		local var_14_1 = false
		local var_14_2, var_14_3 = Managers.state.network.network_server:peers_ongoing_game_object_sync(arg_14_0._peers_ongoing_game_object_sync)

		for iter_14_0 = 1, var_14_3 do
			local var_14_4 = var_14_2[iter_14_0]

			if not arg_14_0._profile_synchronizer:all_synced_for_peer(var_14_4, 1) then
				return
			end
		end

		local var_14_5 = Managers.party:parties()

		for iter_14_1 = 1, #var_14_5 do
			local var_14_6 = var_14_5[iter_14_1].occupied_slots

			for iter_14_2 = 1, #var_14_6 do
				local var_14_7 = var_14_6[iter_14_2]
				local var_14_8 = var_14_7.peer_id
				local var_14_9 = var_14_7.local_player_id

				if not arg_14_0._profile_synchronizer:all_synced_for_peer(var_14_8, var_14_9) then
					return
				end

				if DEDICATED_SERVER or var_14_8 == var_14_0 and var_14_9 == var_0_0 then
					var_14_1 = true
				end
			end
		end

		if not var_14_1 then
			return
		end

		local var_14_10 = arg_14_0._network_server

		for iter_14_3 = 1, #arg_14_3 do
			local var_14_11 = arg_14_3[iter_14_3]
			local var_14_12 = var_14_11.game_mode_data.spawn_state
			local var_14_13

			if DEDICATED_SERVER then
				var_14_13 = var_14_10.game_session ~= nil
			else
				var_14_13 = var_14_10:is_peer_ingame(var_14_11.peer_id)
			end

			local var_14_14 = var_14_12 == "is_initial_spawn" or var_14_12 == "spawn"

			if var_14_13 and var_14_14 then
				if var_14_11.is_bot then
					arg_14_0:_spawn_bot(var_14_11)
				else
					arg_14_0:_spawn_player(var_14_11)
				end
			end
		end
	end
end

AdventureSpawning.add_delayed_client = function (arg_15_0, arg_15_1, arg_15_2)
	arg_15_0._delayed_clients[#arg_15_0._delayed_clients + 1] = {
		peer_id = arg_15_1,
		local_player_id = arg_15_2
	}
end

AdventureSpawning.remove_delayed_client = function (arg_16_0, arg_16_1, arg_16_2)
	for iter_16_0 = #arg_16_0._delayed_clients, 1, -1 do
		local var_16_0 = arg_16_0._delayed_clients[iter_16_0]

		if var_16_0.peer_id == arg_16_1 and var_16_0.local_player_id == arg_16_2 then
			table.remove(arg_16_0._delayed_clients, iter_16_0)

			return
		end
	end
end

AdventureSpawning._update_joining_clients = function (arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0._spawning and arg_17_0._profile_synchronizer:all_synced() then
		local var_17_0 = arg_17_0._network_server

		for iter_17_0 = #arg_17_0._delayed_clients, 1, -1 do
			local var_17_1 = arg_17_0._delayed_clients[iter_17_0]
			local var_17_2 = var_17_1.peer_id
			local var_17_3 = var_17_1.local_player_id

			if var_17_0:is_peer_ingame(var_17_2) then
				arg_17_0:_add_client_to_party(var_17_2, var_17_3)
				table.remove(arg_17_0._delayed_clients, iter_17_0)
			end
		end
	end
end

AdventureSpawning._add_client_to_party = function (arg_18_0, arg_18_1, arg_18_2)
	if arg_18_1 ~= Network.peer_id() then
		local var_18_0 = true
		local var_18_1 = 1
		local var_18_2 = Managers.state.game_mode:remove_bot(var_18_1, arg_18_1, arg_18_2, var_18_0)

		if Managers.party:get_player_status(arg_18_1, arg_18_2).party_id ~= 1 then
			Managers.party:request_join_party(arg_18_1, arg_18_2, var_18_1, nil, var_18_2)
		end
	end
end

AdventureSpawning._spawn_player = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.game_mode_data
	local var_19_1, var_19_2 = arg_19_0:_find_spawn_point(arg_19_1)
	local var_19_3 = var_19_0.spawn_state == "is_initial_spawn"

	if Managers.state.network:game() then
		local var_19_4 = arg_19_1.peer_id
		local var_19_5 = arg_19_1.local_player_id
		local var_19_6 = arg_19_1.profile_index
		local var_19_7 = arg_19_1.career_index
		local var_19_8 = SpawningHelper.netpack_consumables(var_19_0.consumables)
		local var_19_9, var_19_10, var_19_11 = unpack(var_19_8)
		local var_19_12 = SpawningHelper.netpack_additional_items(var_19_0.additional_items)
		local var_19_13 = {}

		if var_19_0.persistent_buffs then
			for iter_19_0, iter_19_1 in pairs(var_19_0.persistent_buffs.buff_names) do
				local var_19_14 = NetworkLookup.buff_templates[iter_19_1]

				table.insert(var_19_13, var_19_14)
			end
		end

		local var_19_15 = var_19_0.ammo
		local var_19_16 = math.floor(var_19_15.slot_melee * 100)
		local var_19_17 = math.floor(var_19_15.slot_ranged * 100)
		local var_19_18 = var_19_0.ability_cooldown_percentage or 1
		local var_19_19 = math.floor(var_19_18 * 100)
		local var_19_20 = arg_19_0._profile_synchronizer:cached_inventory_hash(var_19_4, var_19_5)

		Managers.state.network.network_transmit:send_rpc("rpc_to_client_spawn_player", var_19_4, var_19_5, var_19_6, var_19_7, var_19_1, var_19_2, var_19_3, var_19_16, var_19_17, var_19_19, var_19_9, var_19_10, var_19_11, var_19_12, var_19_13, var_19_20)
	end

	var_19_0.spawn_state = var_19_3 and "initial_spawning" or "spawning"
end

AdventureSpawning._spawn_bot = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.game_mode_data
	local var_20_1 = var_20_0.position:unbox()
	local var_20_2 = var_20_0.rotation:unbox()
	local var_20_3 = var_20_0.spawn_state == "is_initial_spawn"
	local var_20_4 = var_20_0.consumables
	local var_20_5 = var_20_0.ammo
	local var_20_6 = arg_20_1.peer_id
	local var_20_7 = arg_20_1.local_player_id
	local var_20_8 = Managers.player:player(var_20_6, var_20_7)

	fassert(var_20_8.bot_player, "Trying to spawn a player as a bot, status info isn't correct")

	local var_20_9 = var_20_0.ability_cooldown_percentage or 1
	local var_20_10 = math.floor(var_20_9 * 100)

	var_20_8:spawn(var_20_1, var_20_2, var_20_3, var_20_5.slot_melee, var_20_5.slot_ranged, var_20_4.slot_healthkit, var_20_4.slot_potion, var_20_4.slot_grenade, var_20_10)

	var_20_0.spawn_state = "spawned"
end

AdventureSpawning._find_spawn_point = function (arg_21_0, arg_21_1)
	local var_21_0
	local var_21_1
	local var_21_2 = Managers.state.room

	if var_21_2 then
		var_21_0, var_21_1 = arg_21_0:_spawn_pos_rot_from_index(var_21_2:get_spawn_point_by_peer(arg_21_1.peer_id))
	else
		local var_21_3 = arg_21_1.game_mode_data

		fassert(var_21_3.position, "This level is missing spawn-points for the players.")

		var_21_0 = var_21_3.position:unbox()
		var_21_1 = var_21_3.rotation:unbox()
	end

	return var_21_0, var_21_1
end

AdventureSpawning.force_update_spawn_positions = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._saved_game_mode_data

	for iter_22_0 = 1, #var_22_0 do
		local var_22_1 = var_22_0[iter_22_0]

		if var_22_1.position and var_22_1.rotation then
			var_22_1.position:store(arg_22_1)
			var_22_1.rotation:store(arg_22_2)
		end
	end
end

AdventureSpawning.set_respawning_enabled = function (arg_23_0, arg_23_1)
	fassert(arg_23_0._respawns_enabled ~= arg_23_1, "Respawns already enabled=%s", tostring(arg_23_1))

	arg_23_0._respawns_enabled = arg_23_1
end

AdventureSpawning.set_spawning_disabled = function (arg_24_0, arg_24_1)
	arg_24_0._spawning = not arg_24_1
end

AdventureSpawning.add_spawn_point = function (arg_25_0, arg_25_1)
	local var_25_0 = Unit.local_position(arg_25_1, 0)
	local var_25_1 = Unit.local_rotation(arg_25_1, 0)
	local var_25_2 = {
		pos = Vector3Box(var_25_0),
		rot = QuaternionBox(var_25_1)
	}
	local var_25_3 = Unit.get_data(arg_25_1, "from_game_mode")
	local var_25_4 = var_25_3 ~= "" and var_25_3 or "default"

	arg_25_0._spawn_points[var_25_4] = arg_25_0._spawn_points[var_25_4] or {}
	arg_25_0._spawn_points[var_25_4][#arg_25_0._spawn_points[var_25_4] + 1] = var_25_2
end

AdventureSpawning.get_spawn_point = function (arg_26_0)
	local var_26_0 = "default"
	local var_26_1 = Managers.mechanism:get_last_mechanism_switch()
	local var_26_2 = Managers.mechanism:get_prior_state() or var_26_0
	local var_26_3 = arg_26_0._spawn_points[var_26_2] or arg_26_0._spawn_points[var_26_1] or arg_26_0._spawn_points[var_26_0]

	arg_26_0._num_spawn_points_used = arg_26_0._num_spawn_points_used + 1

	if arg_26_0._num_spawn_points_used > #var_26_3 then
		arg_26_0._num_spawn_points_used = 1
	end

	local var_26_4 = var_26_3[arg_26_0._num_spawn_points_used]

	return var_26_4.pos, var_26_4.rot
end

AdventureSpawning.respawn_unit_spawned = function (arg_27_0, arg_27_1)
	arg_27_0._respawn_handler:respawn_unit_spawned(arg_27_1)
end

AdventureSpawning.respawn_gate_unit_spawned = function (arg_28_0, arg_28_1)
	arg_28_0._respawn_handler:respawn_gate_unit_spawned(arg_28_1)
end

AdventureSpawning.remove_respawn_units_due_to_crossroads = function (arg_29_0, arg_29_1, arg_29_2)
	arg_29_0._respawn_handler:remove_respawn_units_due_to_crossroads(arg_29_1, arg_29_2)
end

AdventureSpawning.recalc_respawner_dist_due_to_crossroads = function (arg_30_0)
	arg_30_0._respawn_handler:recalc_respawner_dist_due_to_crossroads()
end

AdventureSpawning.teleport_despawned_players = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._side.party.occupied_slots
	local var_31_1 = Managers.player

	for iter_31_0 = 1, #var_31_0 do
		local var_31_2 = var_31_0[iter_31_0]
		local var_31_3 = var_31_2.peer_id
		local var_31_4 = var_31_2.local_player_id
		local var_31_5 = var_31_3 and var_31_4 and var_31_1:player(var_31_3, var_31_4)

		if not var_31_5 or not var_31_5.player_unit then
			var_31_2.game_mode_data.position:store(arg_31_1)
		end
	end
end

AdventureSpawning.force_respawn = function (arg_32_0, arg_32_1, arg_32_2)
	Managers.party:get_player_status(arg_32_1, arg_32_2).game_mode_data.spawn_state = "force_respawn"
end

AdventureSpawning.force_respawn_dead_players = function (arg_33_0)
	local var_33_0 = arg_33_0._side.party

	arg_33_0._respawn_handler:force_respawn_dead_players(var_33_0)
end

AdventureSpawning.set_override_respawn_group = function (arg_34_0, arg_34_1, arg_34_2)
	arg_34_0._respawn_handler:set_override_respawn_group(arg_34_1, arg_34_2)
end

AdventureSpawning.set_respawn_group_enabled = function (arg_35_0, arg_35_1, arg_35_2)
	arg_35_0._respawn_handler:set_respawn_group_enabled(arg_35_1, arg_35_2)
end

AdventureSpawning.set_respawn_gate_enabled = function (arg_36_0, arg_36_1, arg_36_2)
	arg_36_0._respawn_handler:set_respawn_gate_enabled(arg_36_1, arg_36_2)
end

AdventureSpawning.get_active_respawn_units = function (arg_37_0)
	return arg_37_0._respawn_handler:get_active_respawn_units()
end

AdventureSpawning.get_available_and_active_respawn_units = function (arg_38_0)
	return arg_38_0._respawn_handler:get_available_and_active_respawn_units()
end

AdventureSpawning.set_move_dead_players_to_next_respawn = function (arg_39_0, arg_39_1)
	arg_39_0._respawn_handler:set_move_dead_players_to_next_respawn(arg_39_1)
end

AdventureSpawning.get_respawn_handler = function (arg_40_0)
	return arg_40_0._respawn_handler
end

AdventureSpawning.add_spawn_point_to_spawn_group = function (arg_41_0, arg_41_1)
	if not arg_41_0._spawn_groups then
		arg_41_0._spawn_groups = {}
	end

	local var_41_0 = Unit.local_position(arg_41_1, 0)
	local var_41_1 = Unit.local_rotation(arg_41_1, 0)
	local var_41_2 = {
		pos = Vector3Box(var_41_0),
		rot = QuaternionBox(var_41_1)
	}
	local var_41_3 = Unit.get_data(arg_41_1, "spawn_group")

	fassert(var_41_3, "spawn group property missing from spawn point unit")

	if not arg_41_0._spawn_groups[var_41_3] then
		arg_41_0._spawn_groups[var_41_3] = {}
	end

	local var_41_4 = #arg_41_0._spawn_groups[var_41_3]

	arg_41_0._spawn_groups[var_41_3][var_41_4 + 1] = var_41_2
end

AdventureSpawning.get_spawn_point_from_spawn_group = function (arg_42_0, arg_42_1)
	if not arg_42_0._used_spawn_group_positions then
		arg_42_0._used_spawn_group_positions = {}
	end

	local var_42_0 = arg_42_0._spawn_groups[arg_42_1]
	local var_42_1 = var_42_0 and #var_42_0

	fassert(var_42_1, "no spawn points exists for indicated spawn group: ", arg_42_1)

	if arg_42_0._used_spawn_group_positions[arg_42_1] then
		arg_42_0._used_spawn_group_positions[arg_42_1] = arg_42_0._used_spawn_group_positions[arg_42_1] + 1
	else
		arg_42_0._used_spawn_group_positions[arg_42_1] = 1
	end

	local var_42_2 = var_42_0[arg_42_0._used_spawn_group_positions[arg_42_1]]

	return var_42_2.pos, var_42_2.rot
end

AdventureSpawning.rpc_to_server_spawn_failed = function (arg_43_0, arg_43_1, arg_43_2)
	print("[AdventureSpawning] Client detected spawning mismatch. Trying again.")

	local var_43_0 = CHANNEL_TO_PEER_ID[arg_43_1]
	local var_43_1 = arg_43_0._side.party.occupied_slots

	for iter_43_0 = 1, #var_43_1 do
		local var_43_2 = var_43_1[iter_43_0]
		local var_43_3 = var_43_2.peer_id
		local var_43_4 = var_43_2.local_player_id

		if var_43_0 == var_43_3 and arg_43_2 == var_43_4 then
			local var_43_5 = var_43_2.game_mode_data

			if var_43_5.spawn_state == "initial_spawning" then
				var_43_5.spawn_state = "is_initial_spawn"

				break
			end

			if var_43_5.spawn_state == "spawning" then
				var_43_5.spawn_state = "spawn"

				break
			end

			print("[AdventureSpawning] This shouldn't happen. How did we leave spawning?")

			break
		end
	end
end
