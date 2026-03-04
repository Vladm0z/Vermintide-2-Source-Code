-- chunkname: @scripts/managers/game_mode/spawning_components/deus_spawning.lua

require("scripts/managers/spawn/respawn_handler")
require("scripts/managers/game_mode/spawning_components/spawning_helper")

local var_0_0 = 0.5
local var_0_1 = 1
local var_0_2 = {
	"rpc_to_server_spawn_failed"
}

DeusSpawning = class(DeusSpawning)

function DeusSpawning.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0._profile_synchronizer = arg_1_1
	arg_1_0._side = arg_1_2
	arg_1_0._is_server = arg_1_3
	arg_1_0._network_server = arg_1_4
	arg_1_0._respawns_enabled = true
	arg_1_0._spawning = true
	arg_1_0._respawn_handler = RespawnHandler:new(arg_1_1, arg_1_3)
	arg_1_0._peers_ongoing_game_object_sync = {}
	arg_1_0._spawn_points = {}
	arg_1_0._num_spawn_points_used = 0
	arg_1_0._status_updates_active = true
	arg_1_0._delayed_clients = {}
	arg_1_0._deus_run_controller = arg_1_5
end

function DeusSpawning.register_rpcs(arg_2_0, arg_2_1, arg_2_2)
	arg_2_1:register(arg_2_0, unpack(var_0_2))

	arg_2_0._network_event_delegate = arg_2_1

	arg_2_0._respawn_handler:register_rpcs(arg_2_1, arg_2_2)
end

function DeusSpawning.unregister_rpcs(arg_3_0)
	arg_3_0._respawn_handler:unregister_rpcs()
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil
end

function DeusSpawning._restore_player_game_mode_data(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0._deus_run_controller:restore_game_mode_data(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	var_4_0.temporary_health_percentage = 0
	var_4_0.ability_cooldown_percentage = 1
	var_4_0.last_update = -math.huge

	local var_4_1 = Managers.time:time("client_ingame")
	local var_4_2 = var_4_1 == nil or var_4_1 < 10
	local var_4_3
	local var_4_4

	if var_4_2 then
		var_4_3, var_4_4 = arg_4_0:get_spawn_point()
	else
		local var_4_5 = Managers.state.conflict
		local var_4_6 = var_4_5.level_analysis:get_main_paths()
		local var_4_7 = var_4_5.main_path_info
		local var_4_8 = var_4_5.main_path_player_info

		var_4_3, var_4_4 = MainPathUtils.get_main_path_point_between_players(var_4_6, var_4_7, var_4_8)
	end

	var_4_0.position = var_4_3
	var_4_0.rotation = var_4_4

	if var_4_0.health_state ~= "alive" then
		var_4_0.health_state = "dead"
		var_4_0.ready_for_respawn = true
	end

	if var_4_0.health_state == "dead" then
		var_4_0.spawn_state = "not_spawned"
	elseif var_4_2 then
		var_4_0.spawn_state = "is_initial_spawn"
	else
		var_4_0.spawn_state = "spawn"
	end

	if var_4_0.health_state == "alive" then
		local var_4_9 = var_0_0

		var_4_0.health_percentage = math.max(var_4_0.health_percentage, var_4_9)
	end

	var_4_0.needs_initial_buffs = true

	return var_4_0
end

function DeusSpawning._check_observer_camera(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._deus_run_controller:get_own_peer_id()

	if arg_5_0._deus_run_controller:get_player_health_state(arg_5_1, arg_5_2) == "dead" and arg_5_1 ~= var_5_0 then
		local var_5_1 = PEER_ID_TO_CHANNEL[arg_5_1]

		RPC.rpc_set_observer_camera(var_5_1, arg_5_2)
	end
end

function DeusSpawning._unassign_data_from_slot(arg_6_0, arg_6_1, arg_6_2)
	arg_6_1.game_mode_data = {}
end

function DeusSpawning.player_entered_game_session(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Managers.party:get_player_status(arg_7_1, arg_7_2)

	if var_7_0.career_index then
		var_7_0.game_mode_data = arg_7_0:_restore_player_game_mode_data(arg_7_1, arg_7_2, var_7_0.profile_index, var_7_0.career_index)
	end
end

function DeusSpawning.player_joined_party(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	return
end

function DeusSpawning.player_left_party(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	return
end

function DeusSpawning.update(arg_10_0, arg_10_1, arg_10_2)
	if Managers.state.network:game() then
		arg_10_0._respawn_handler:update(arg_10_2, arg_10_1)
	end
end

function DeusSpawning.server_update(arg_11_0, arg_11_1, arg_11_2)
	if Managers.state.network:game() then
		local var_11_0 = arg_11_0._side.party.occupied_slots

		if arg_11_0._status_updates_active then
			arg_11_0:_update_player_status(arg_11_1, arg_11_2, var_11_0)
		end

		local var_11_1 = Managers.state.difficulty:get_difficulty_settings().allow_respawns

		if arg_11_0._respawns_enabled and var_11_1 then
			arg_11_0._respawn_handler:server_update(arg_11_2, arg_11_1, var_11_0)
		end

		arg_11_0:_update_spawning(arg_11_2, arg_11_1, var_11_0)
		arg_11_0:_update_joining_clients(arg_11_2, arg_11_1)
	end
end

function DeusSpawning.profile_changed(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = Managers.party:get_player_status(arg_12_1, arg_12_2)

	var_12_0.game_mode_data = arg_12_0:_restore_player_game_mode_data(arg_12_1, arg_12_2, var_12_0.profile_index, var_12_0.career_index)
end

local var_0_3 = {}

function DeusSpawning._update_player_status(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = Managers.player
	local var_13_1 = ScriptUnit.extension

	for iter_13_0 = 1, #arg_13_3 do
		local var_13_2 = arg_13_3[iter_13_0]
		local var_13_3 = var_13_2.game_mode_data
		local var_13_4 = var_13_2.peer_id
		local var_13_5 = var_13_2.local_player_id

		if var_13_4 and var_13_5 then
			local var_13_6 = var_13_0:player(var_13_4, var_13_5)

			if var_13_6 then
				local var_13_7 = var_13_3.spawn_state

				if var_13_7 == "force_respawn" then
					if not Unit.alive(var_13_6.player_unit) and arg_13_0._profile_synchronizer:all_synced() then
						var_13_3.spawn_state = "spawn"
					end
				elseif var_13_7 == "spawned" then
					local var_13_8 = var_13_6.player_unit

					if not var_13_8 then
						var_13_3.needs_initial_buffs = true
					else
						if var_13_3.needs_initial_buffs then
							arg_13_0:_apply_initial_buffs(var_13_6)

							var_13_3.needs_initial_buffs = false
						end

						local var_13_9 = var_13_1(var_13_8, "locomotion_system"):last_position_on_navmesh()

						var_13_3.position:store(var_13_9)
						var_13_3.rotation:store(Unit.local_rotation(var_13_8, 0))

						local var_13_10 = var_13_1(var_13_8, "status_system")
						local var_13_11 = var_13_10:is_dead()

						if var_13_11 then
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

							local var_13_12 = var_13_3.respawn_unit

							if var_13_12 then
								arg_13_0._respawn_handler:set_respawn_unit_available(var_13_12)

								var_13_3.respawn_unit = nil
							end
						end

						local var_13_13 = var_13_1(var_13_8, "health_system")
						local var_13_14 = var_13_1(var_13_8, "career_system")

						if not var_13_11 or var_13_3.health_state ~= "respawning" then
							var_13_3.health_percentage = var_13_13:current_permanent_health_percent()
							var_13_3.temporary_health_percentage = var_13_13:current_temporary_health_percent()
							var_13_3.ability_cooldown_percentage = var_13_14:current_ability_cooldown_percentage()
						end

						if not DamageUtils.is_in_inn then
							local var_13_15 = var_13_1(var_13_8, "inventory_system")

							SpawningHelper.fill_consumable_table(var_13_3.consumables, var_13_15)
							SpawningHelper.fill_ammo_percentage(var_13_3.ammo, var_13_15, var_13_8)

							var_13_3.additional_items = var_13_15:get_additional_items_table()
						end

						local var_13_16 = var_13_1(var_13_8, "buff_system"):active_buffs()

						table.clear(var_0_3)

						local var_13_17 = 1

						for iter_13_1, iter_13_2 in pairs(var_13_16) do
							local var_13_18 = iter_13_2.template

							if not iter_13_2.removed and var_13_18.is_persistent then
								var_0_3[var_13_17] = var_13_18.name
								var_13_17 = var_13_17 + 1
							end
						end

						arg_13_0._deus_run_controller:save_game_mode_data(var_13_4, var_13_5, var_13_2.profile_index, var_13_2.career_index, var_13_3)
						arg_13_0._deus_run_controller:save_persistent_buffs(var_13_4, var_13_5, var_13_2.profile_index, var_13_2.career_index, var_0_3)
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

function DeusSpawning._apply_initial_buffs(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.player_unit
	local var_14_1 = arg_14_1:network_id()
	local var_14_2 = arg_14_1:local_player_id()
	local var_14_3 = Managers.state.entity:system("buff_system")
	local var_14_4 = arg_14_0._deus_run_controller:get_player_persistent_buffs(var_14_1, var_14_2)

	for iter_14_0, iter_14_1 in ipairs(var_14_4) do
		var_14_3:add_buff(var_14_0, iter_14_1, var_14_0)
	end

	local var_14_5 = arg_14_0._deus_run_controller:get_player_power_ups(arg_14_1.peer_id, var_14_2)

	for iter_14_2, iter_14_3 in ipairs(var_14_5) do
		local var_14_6 = DeusPowerUps[iter_14_3.rarity][iter_14_3.name]

		if not var_14_6.talent then
			var_14_3:add_buff(var_14_0, var_14_6.buff_name, var_14_0)
		end
	end

	local var_14_7 = arg_14_0._deus_run_controller:get_party_power_ups()

	for iter_14_4, iter_14_5 in ipairs(var_14_7) do
		local var_14_8 = DeusPowerUps[iter_14_5.rarity][iter_14_5.name]

		var_14_3:add_buff(var_14_0, var_14_8.buff_name, var_14_0)
	end
end

function DeusSpawning._update_spawning(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_0._spawning then
		local var_15_0 = arg_15_0._deus_run_controller:get_own_peer_id()
		local var_15_1 = false
		local var_15_2, var_15_3 = Managers.state.network.network_server:peers_ongoing_game_object_sync(arg_15_0._peers_ongoing_game_object_sync)

		for iter_15_0 = 1, var_15_3 do
			local var_15_4 = var_15_2[iter_15_0]

			if not arg_15_0._profile_synchronizer:all_synced_for_peer(var_15_4, 1) then
				return
			end
		end

		for iter_15_1 = 1, #arg_15_3 do
			local var_15_5 = arg_15_3[iter_15_1]
			local var_15_6 = var_15_5.peer_id
			local var_15_7 = var_15_5.local_player_id

			if not arg_15_0._profile_synchronizer:all_synced_for_peer(var_15_6, var_15_7) then
				return
			end

			if var_15_6 == var_15_0 and var_15_7 == var_0_1 then
				var_15_1 = true
			end
		end

		if not var_15_1 then
			return
		end

		local var_15_8 = arg_15_0._network_server

		for iter_15_2 = 1, #arg_15_3 do
			local var_15_9 = arg_15_3[iter_15_2]
			local var_15_10 = var_15_9.game_mode_data.spawn_state
			local var_15_11

			if DEDICATED_SERVER then
				var_15_11 = var_15_8.game_session ~= nil
			else
				var_15_11 = var_15_8:is_peer_ingame(var_15_9.peer_id)
			end

			local var_15_12 = var_15_10 == "is_initial_spawn" or var_15_10 == "spawn"

			if var_15_11 and var_15_12 then
				if var_15_9.is_bot then
					arg_15_0:_spawn_bot(var_15_9)
				else
					arg_15_0:_spawn_player(var_15_9)
				end
			end
		end
	end
end

function DeusSpawning.add_delayed_client(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0._delayed_clients[#arg_16_0._delayed_clients + 1] = {
		peer_id = arg_16_1,
		local_player_id = arg_16_2
	}
end

function DeusSpawning.remove_delayed_client(arg_17_0, arg_17_1, arg_17_2)
	for iter_17_0 = #arg_17_0._delayed_clients, 1, -1 do
		local var_17_0 = arg_17_0._delayed_clients[iter_17_0]

		if var_17_0.peer_id == arg_17_1 and var_17_0.local_player_id == arg_17_2 then
			table.remove(arg_17_0._delayed_clients, iter_17_0)

			return
		end
	end
end

function DeusSpawning._update_joining_clients(arg_18_0, arg_18_1, arg_18_2)
	if arg_18_0._spawning and arg_18_0._profile_synchronizer:all_synced() then
		local var_18_0 = arg_18_0._network_server

		for iter_18_0 = #arg_18_0._delayed_clients, 1, -1 do
			local var_18_1 = arg_18_0._delayed_clients[iter_18_0]
			local var_18_2 = var_18_1.peer_id
			local var_18_3 = var_18_1.local_player_id

			if var_18_0:is_peer_ingame(var_18_2) then
				arg_18_0:_add_client_to_party(var_18_2, var_18_3)
				table.remove(arg_18_0._delayed_clients, iter_18_0)
			end
		end
	end
end

function DeusSpawning._add_client_to_party(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = 1

	if Managers.party:get_player_status(arg_19_1, arg_19_2).party_id ~= var_19_0 then
		local var_19_1 = true
		local var_19_2 = Managers.state.game_mode:remove_bot(var_19_0, arg_19_1, arg_19_2, var_19_1)

		Managers.party:request_join_party(arg_19_1, arg_19_2, var_19_0, nil, var_19_2)
	end
end

function DeusSpawning._spawn_player(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.game_mode_data
	local var_20_1, var_20_2 = arg_20_0:_find_spawn_point(arg_20_1)
	local var_20_3 = var_20_0.spawn_state == "is_initial_spawn"

	if Managers.state.network:game() then
		local var_20_4 = arg_20_1.peer_id
		local var_20_5 = arg_20_1.local_player_id
		local var_20_6 = arg_20_1.profile_index
		local var_20_7 = arg_20_1.career_index
		local var_20_8 = SpawningHelper.netpack_consumables(var_20_0.consumables)
		local var_20_9, var_20_10, var_20_11 = unpack(var_20_8)
		local var_20_12 = SpawningHelper.netpack_additional_items(var_20_0.additional_items)
		local var_20_13 = {}
		local var_20_14 = var_20_0.ammo
		local var_20_15 = math.floor(var_20_14.slot_melee * 100)
		local var_20_16 = math.floor(var_20_14.slot_ranged * 100)
		local var_20_17 = var_20_0.ability_cooldown_percentage or 1
		local var_20_18 = math.floor(var_20_17 * 100)

		printf("rpc_to_client_spawn_player %s %d", tostring(var_20_4), var_20_5)

		local var_20_19 = arg_20_0._profile_synchronizer:cached_inventory_hash(var_20_4, var_20_5)

		Managers.state.network.network_transmit:send_rpc("rpc_to_client_spawn_player", var_20_4, var_20_5, var_20_6, var_20_7, var_20_1, var_20_2, var_20_3, var_20_15, var_20_16, var_20_18, var_20_9, var_20_10, var_20_11, var_20_12, var_20_13, var_20_19)
	end

	var_20_0.spawn_state = var_20_3 and "initial_spawning" or "spawning"
end

function DeusSpawning._spawn_bot(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.game_mode_data
	local var_21_1 = arg_21_1.peer_id
	local var_21_2 = arg_21_1.local_player_id
	local var_21_3 = var_21_0.position:unbox()
	local var_21_4 = var_21_0.rotation:unbox()
	local var_21_5 = false
	local var_21_6 = var_21_0.consumables
	local var_21_7 = var_21_0.ammo
	local var_21_8 = Managers.player:player(var_21_1, var_21_2)

	fassert(var_21_8.bot_player, "Trying to spawn a player as a bot, status info isn't correct")

	local var_21_9 = var_21_0.ability_cooldown_percentage or 1
	local var_21_10 = math.floor(var_21_9 * 100)

	var_21_8:spawn(var_21_3, var_21_4, var_21_5, var_21_7.slot_melee, var_21_7.slot_ranged, var_21_6.slot_healthkit, var_21_6.slot_potion, var_21_6.slot_grenade, var_21_10)

	var_21_0.spawn_state = "spawned"
end

function DeusSpawning._find_spawn_point(arg_22_0, arg_22_1)
	local var_22_0
	local var_22_1
	local var_22_2 = Managers.state.room

	if var_22_2 then
		var_22_0, var_22_1 = arg_22_0:_spawn_pos_rot_from_index(var_22_2:get_spawn_point_by_peer(arg_22_1.peer_id))
	else
		local var_22_3 = arg_22_1.game_mode_data

		fassert(var_22_3.position, "This level is missing spawn-points for the players.")

		var_22_0 = var_22_3.position:unbox()
		var_22_1 = var_22_3.rotation:unbox()
	end

	return var_22_0, var_22_1
end

function DeusSpawning.force_update_spawn_positions(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._side.party.occupied_slots

	for iter_23_0 = 1, #var_23_0 do
		local var_23_1 = var_23_0[iter_23_0].game_mode_data

		if var_23_1 and var_23_1.position and var_23_1.rotation then
			var_23_1.position:store(arg_23_1)
			var_23_1.rotation:store(arg_23_2)
		end
	end
end

function DeusSpawning.set_respawning_enabled(arg_24_0, arg_24_1)
	fassert(arg_24_0._respawns_enabled ~= arg_24_1, "Respawns already enabled=%s", tostring(arg_24_1))

	arg_24_0._respawns_enabled = arg_24_1
end

function DeusSpawning.set_spawning_disabled(arg_25_0, arg_25_1)
	arg_25_0._spawning = not arg_25_1
end

function DeusSpawning.add_spawn_point(arg_26_0, arg_26_1)
	local var_26_0 = Unit.local_position(arg_26_1, 0)
	local var_26_1 = Unit.local_rotation(arg_26_1, 0)
	local var_26_2 = {
		pos = Vector3Box(var_26_0),
		rot = QuaternionBox(var_26_1)
	}
	local var_26_3 = Unit.get_data(arg_26_1, "from_game_mode")

	var_26_3 = var_26_3 ~= "" and var_26_3 or "default"
	arg_26_0._spawn_points[var_26_3] = arg_26_0._spawn_points[var_26_3] or {}
	arg_26_0._spawn_points[var_26_3][#arg_26_0._spawn_points[var_26_3] + 1] = var_26_2
end

function DeusSpawning.get_spawn_point(arg_27_0)
	local var_27_0 = "default"
	local var_27_1 = Managers.mechanism:get_prior_state()
	local var_27_2 = arg_27_0._spawn_points[var_27_1] or arg_27_0._spawn_points[var_27_0]

	arg_27_0._num_spawn_points_used = arg_27_0._num_spawn_points_used + 1

	if arg_27_0._num_spawn_points_used > #var_27_2 then
		arg_27_0._num_spawn_points_used = 1
	end

	local var_27_3 = var_27_2[arg_27_0._num_spawn_points_used]

	return var_27_3.pos, var_27_3.rot
end

function DeusSpawning.respawn_unit_spawned(arg_28_0, arg_28_1)
	arg_28_0._respawn_handler:respawn_unit_spawned(arg_28_1)
end

function DeusSpawning.respawn_gate_unit_spawned(arg_29_0, arg_29_1)
	arg_29_0._respawn_handler:respawn_gate_unit_spawned(arg_29_1)
end

function DeusSpawning.remove_respawn_units_due_to_crossroads(arg_30_0, arg_30_1, arg_30_2)
	arg_30_0._respawn_handler:remove_respawn_units_due_to_crossroads(arg_30_1, arg_30_2)
end

function DeusSpawning.recalc_respawner_dist_due_to_crossroads(arg_31_0)
	arg_31_0._respawn_handler:recalc_respawner_dist_due_to_crossroads()
end

function DeusSpawning.disable_status_updates(arg_32_0)
	arg_32_0._status_updates_active = false
end

function DeusSpawning.teleport_despawned_players(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._side.party.occupied_slots
	local var_33_1 = Managers.player

	for iter_33_0 = 1, #var_33_0 do
		local var_33_2 = var_33_0[iter_33_0]
		local var_33_3 = var_33_2.peer_id
		local var_33_4 = var_33_2.local_player_id
		local var_33_5 = var_33_3 and var_33_4 and var_33_1:player(var_33_3, var_33_4)

		if not var_33_5 or not var_33_5.player_unit then
			var_33_2.game_mode_data.position:store(arg_33_1)
		end
	end
end

function DeusSpawning.force_respawn(arg_34_0, arg_34_1, arg_34_2)
	Managers.party:get_player_status(arg_34_1, arg_34_2).game_mode_data.spawn_state = "force_respawn"
end

function DeusSpawning.force_respawn_dead_players(arg_35_0)
	local var_35_0 = arg_35_0._side.party

	arg_35_0._respawn_handler:force_respawn_dead_players(var_35_0)
end

function DeusSpawning.set_override_respawn_group(arg_36_0, arg_36_1, arg_36_2)
	arg_36_0._respawn_handler:set_override_respawn_group(arg_36_1, arg_36_2)
end

function DeusSpawning.set_respawn_group_enabled(arg_37_0, arg_37_1, arg_37_2)
	arg_37_0._respawn_handler:set_respawn_group_enabled(arg_37_1, arg_37_2)
end

function DeusSpawning.set_respawn_gate_enabled(arg_38_0, arg_38_1, arg_38_2)
	arg_38_0._respawn_handler:set_respawn_gate_enabled(arg_38_1, arg_38_2)
end

function DeusSpawning.get_active_respawn_units(arg_39_0)
	return arg_39_0._respawn_handler:get_active_respawn_units()
end

function DeusSpawning.get_available_and_active_respawn_units(arg_40_0)
	return arg_40_0._respawn_handler:get_available_and_active_respawn_units()
end

function DeusSpawning.get_respawn_handler(arg_41_0)
	return arg_41_0._respawn_handler
end

function DeusSpawning.rpc_to_server_spawn_failed(arg_42_0, arg_42_1, arg_42_2)
	print("[DeusSpawning] Client detected spawning mismatch. Trying again.")

	local var_42_0 = CHANNEL_TO_PEER_ID[arg_42_1]
	local var_42_1 = arg_42_0._side.party.occupied_slots

	for iter_42_0 = 1, #var_42_1 do
		local var_42_2 = var_42_1[iter_42_0]
		local var_42_3 = var_42_2.peer_id
		local var_42_4 = var_42_2.local_player_id

		if var_42_0 == var_42_3 and arg_42_2 == var_42_4 then
			local var_42_5 = var_42_2.game_mode_data

			if var_42_5.spawn_state == "initial_spawning" then
				var_42_5.spawn_state = "is_initial_spawn"

				break
			end

			if var_42_5.spawn_state == "spawning" then
				var_42_5.spawn_state = "spawn"

				break
			end

			print("[DeusSpawning] This shouldn't happen. How did we leave spawning?")

			break
		end
	end
end
