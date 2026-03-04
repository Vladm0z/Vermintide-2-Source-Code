-- chunkname: @scripts/managers/spawn/respawn_handler.lua

RespawnHandler = class(RespawnHandler)

local var_0_0 = 70
local var_0_1 = 20
local var_0_2 = 30
local var_0_3 = 10
local var_0_4 = 2
local var_0_5 = {
	"rpc_to_client_respawn_player",
	"rpc_respawn_confirmed"
}

RespawnHandler.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._profile_synchronizer = arg_1_1
	arg_1_0._respawn_units = {}
	arg_1_0._respawn_gate_units = {}
	arg_1_0._respawn_gate_units_n = 0
	arg_1_0._respawner_groups = {}
	arg_1_0._disabled_respawn_groups = {}
	arg_1_0._active_overridden_units = {}
	arg_1_0._active_overrides = {}
	arg_1_0._delayed_respawn_queue = {}
	arg_1_0._world = Managers.world:world("level_world")
	arg_1_0._id = 0
	arg_1_0._path_break_points = {}
	arg_1_0._boss_door_dist_lookup = {}
	arg_1_0._next_move_players_t = 0
	arg_1_0._respawn_distance = var_0_0
	arg_1_0._is_server = arg_1_2

	local var_1_0, var_1_1, var_1_2 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "hero_rescues_enabled")

	if var_1_0 and var_1_2 and var_1_1 then
		arg_1_0._custom_game_respawn_time_override = var_0_2
		arg_1_0._respawn_distance = var_0_1
	end
end

RespawnHandler.register_rpcs = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_1:register(arg_2_0, unpack(var_0_5))

	arg_2_0._network_event_delegate = arg_2_1
	arg_2_0._network_transmit = arg_2_2
end

RespawnHandler.unregister_rpcs = function (arg_3_0)
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil
	arg_3_0._network_transmit = nil
end

RespawnHandler.set_respawn_unit_available = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0:find_respawn_data_from_unit(arg_4_1)

	if var_4_0 then
		var_4_0.available = true
	end
end

RespawnHandler.find_respawn_data_from_unit = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._respawn_units
	local var_5_1 = #var_5_0

	for iter_5_0 = 1, var_5_1 do
		local var_5_2 = var_5_0[iter_5_0]

		if arg_5_1 == var_5_2.unit then
			return var_5_2
		end
	end

	return nil
end

local function var_0_6(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.distance_through_level
	local var_6_1 = arg_6_1.distance_through_level

	fassert(var_6_0, "ctrl-shift-l needs running on loaded level for respawn points")
	fassert(var_6_1, "ctrl-shift-l needs running on loaded level for respawn points")

	return var_6_0 < var_6_1
end

RespawnHandler.set_override_respawn_group = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._respawner_groups[arg_7_1]

	if not var_7_0 then
		print("WARNING: Override Player Respawning, bad group-id: '" .. tostring(arg_7_1) .. "'' (not registered).")

		return
	end

	print("Override Player Respawning", arg_7_1, arg_7_2)

	local var_7_1 = arg_7_0._active_overridden_units
	local var_7_2 = arg_7_0._active_overrides

	if arg_7_2 then
		var_7_2[arg_7_1] = true

		for iter_7_0, iter_7_1 in pairs(var_7_0) do
			var_7_1[iter_7_0] = iter_7_1
		end
	else
		var_7_2[arg_7_1] = nil

		for iter_7_2, iter_7_3 in pairs(var_7_0) do
			var_7_1[iter_7_2] = nil
		end
	end
end

RespawnHandler.set_respawn_group_enabled = function (arg_8_0, arg_8_1, arg_8_2)
	print("Setting player respawning group enabled", arg_8_1, arg_8_2)

	local var_8_0 = arg_8_0._disabled_respawn_groups

	if not arg_8_2 then
		var_8_0[arg_8_1] = true
	else
		var_8_0[arg_8_1] = nil
	end
end

RespawnHandler.set_respawn_gate_enabled = function (arg_9_0, arg_9_1, arg_9_2)
	print("Setting player respawning gate enabled", arg_9_2)

	local var_9_0 = arg_9_0._respawn_gate_units

	for iter_9_0 = 1, arg_9_0._respawn_gate_units_n do
		local var_9_1 = var_9_0[iter_9_0]

		if var_9_1.unit == arg_9_1 then
			print("gate at travel distance set enabled", var_9_1.distance_through_level, arg_9_2)

			var_9_1.enabled = arg_9_2

			return
		end
	end
end

RespawnHandler.respawn_unit_spawned = function (arg_10_0, arg_10_1)
	local var_10_0 = Unit.get_data(arg_10_1, "distance_through_level")
	local var_10_1 = Unit.get_data(arg_10_1, "respawn_group_id")

	arg_10_0._id = arg_10_0._id + 1

	local var_10_2 = {
		available = true,
		id = arg_10_0._id,
		unit = arg_10_1,
		distance_through_level = var_10_0,
		group_id = var_10_1
	}

	arg_10_0._respawn_units[#arg_10_0._respawn_units + 1] = var_10_2

	table.sort(arg_10_0._respawn_units, var_0_6)

	if var_10_1 and var_10_1 ~= "" then
		local var_10_3 = arg_10_0._respawner_groups[var_10_1]

		if not var_10_3 then
			var_10_3 = {}
			arg_10_0._respawner_groups[var_10_1] = var_10_3
		end

		var_10_2.group_data = var_10_3
		var_10_3[arg_10_1] = var_10_2

		print("respawn_unit_spawned with group id:", var_10_1)
	end
end

RespawnHandler.respawn_gate_unit_spawned = function (arg_11_0, arg_11_1)
	local var_11_0 = Unit.get_data(arg_11_1, "distance_through_level")
	local var_11_1 = Unit.get_data(arg_11_1, "gate_enabled")
	local var_11_2 = {
		unit = arg_11_1,
		distance_through_level = var_11_0,
		enabled = var_11_1
	}

	arg_11_0._respawn_gate_units_n = arg_11_0._respawn_gate_units_n + 1
	arg_11_0._respawn_gate_units[arg_11_0._respawn_gate_units_n] = var_11_2

	table.sort(arg_11_0._respawn_gate_units, var_0_6)
end

RespawnHandler.remove_respawn_units_due_to_crossroads = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = script_data.debug_player_respawns
	local var_12_1 = Vector3(0, 0, 1.5)
	local var_12_2 = {}
	local var_12_3 = #arg_12_1
	local var_12_4 = arg_12_0._respawn_units

	for iter_12_0 = 1, #var_12_4 do
		local var_12_5 = var_12_4[iter_12_0]
		local var_12_6 = var_12_5.distance_through_level

		for iter_12_1 = 1, var_12_3 do
			local var_12_7 = arg_12_1[iter_12_1]

			if var_12_6 >= var_12_7[1] - 1 and var_12_6 <= var_12_7[2] + 1 then
				var_12_2[#var_12_2 + 1] = iter_12_0

				if var_12_5.group_data then
					var_12_5.group_data[var_12_5.unit] = nil
					arg_12_0._active_overridden_units[var_12_5.unit] = nil
				end

				break
			end
		end
	end

	local var_12_8 = arg_12_0._respawner_groups

	for iter_12_2 = #var_12_2, 1, -1 do
		if var_12_0 then
			local var_12_9 = var_12_4[var_12_2[iter_12_2]]
			local var_12_10 = Unit.local_position(var_12_9.unit, 0) + var_12_1

			QuickDrawerStay:sphere(var_12_10, 0.33, Color(255, 0, 70))

			local var_12_11 = string.format("respawer removed, old-dist: %d", var_12_9.distance_through_level)

			Debug.world_sticky_text(var_12_10 + var_12_1, var_12_11, "yellow")
		end

		table.remove(var_12_4, var_12_2[iter_12_2])

		var_12_2[iter_12_2] = nil
	end
end

RespawnHandler.recalc_respawner_dist_due_to_crossroads = function (arg_13_0)
	local var_13_0 = arg_13_0._respawn_units
	local var_13_1 = Unit.local_position

	for iter_13_0 = 1, #var_13_0 do
		local var_13_2 = var_13_0[iter_13_0]
		local var_13_3, var_13_4, var_13_5, var_13_6, var_13_7 = MainPathUtils.closest_pos_at_main_path(nil, var_13_1(var_13_2.unit, 0))

		var_13_2.distance_through_level = var_13_4
	end
end

RespawnHandler.update = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._delayed_respawn_queue
	local var_14_1 = #var_14_0
	local var_14_2 = arg_14_0._is_server

	for iter_14_0 = var_14_1, 1, -1 do
		local var_14_3 = var_14_0[iter_14_0]
		local var_14_4 = var_14_3[1]
		local var_14_5 = var_14_3[9]
		local var_14_6 = var_14_2 and Managers.player:player(var_14_5.peer_id, var_14_5.local_player_id)

		if var_14_2 and var_14_6 ~= var_14_4 then
			var_14_5.game_mode_data.health_state = "dead"

			table.swap_delete(var_14_0, iter_14_0)
			print("Player changed before respawn queue was being processed, resetting state to dead.", var_14_5.peer_id, var_14_5.local_player_id)
		elseif var_14_4 then
			local var_14_7 = var_14_4.player_unit

			if var_14_7 == nil or not Unit.alive(var_14_7) then
				arg_14_0:_respawn_player(unpack(var_14_3))
				table.swap_delete(var_14_0, iter_14_0)
			end
		else
			table.swap_delete(var_14_0, iter_14_0)
		end
	end
end

RespawnHandler._check_all_synced = function (arg_15_0)
	if not arg_15_0._all_synced_checked then
		arg_15_0._all_synced_checked = true
		arg_15_0._all_synced = arg_15_0._profile_synchronizer:all_synced()
	end

	return arg_15_0._all_synced
end

RespawnHandler.server_update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_0._all_synced_checked = false
	arg_16_0._all_synced = false

	local var_16_0 = false

	for iter_16_0 = 1, #arg_16_3 do
		local var_16_1 = arg_16_3[iter_16_0]
		local var_16_2 = var_16_1.game_mode_data
		local var_16_3 = var_16_2.health_state == "dead"

		if var_16_3 then
			if not var_16_2.ready_for_respawn and not var_16_2.respawn_timer then
				local var_16_4 = var_16_1.peer_id
				local var_16_5 = var_16_1.local_player_id
				local var_16_6

				if Development.parameter("fast_respawns") then
					var_16_6 = var_0_4
				elseif arg_16_0._custom_game_respawn_time_override then
					var_16_6 = arg_16_0._custom_game_respawn_time_override
				elseif Managers.mechanism:setting("hero_respawn_time") then
					var_16_6 = Managers.mechanism:setting("hero_respawn_time")
				else
					var_16_6 = var_0_2
				end

				if var_16_4 and var_16_5 then
					local var_16_7 = Managers.player:player(var_16_4, var_16_5).player_unit

					if var_16_7 and Unit.alive(var_16_7) then
						var_16_6 = ScriptUnit.extension(var_16_7, "buff_system"):apply_buffs_to_value(var_16_6, "faster_respawn")
					end
				end

				var_16_2.respawn_timer = arg_16_2 + var_16_6
			elseif not var_16_2.ready_for_respawn and arg_16_2 > var_16_2.respawn_timer then
				var_16_2.respawn_timer = nil
				var_16_2.ready_for_respawn = true
			end
		elseif var_16_2.respawn_timer then
			var_16_2.respawn_timer = nil
		end

		if var_16_3 and var_16_2.ready_for_respawn and var_16_1.peer_id and arg_16_0:_check_all_synced() then
			local var_16_8 = var_16_2.respawn_unit
			local var_16_9

			if var_16_8 and Unit.alive(var_16_8) then
				var_16_9 = var_16_8
			else
				var_16_9 = arg_16_0:find_best_respawn_point(true, false)
			end

			if var_16_9 then
				local var_16_10 = Network.peer_id()
				local var_16_11 = Managers.state.difficulty:get_difficulty_settings()

				var_16_2.health_state = "respawning"
				var_16_2.respawn_unit = var_16_9
				var_16_2.health_percentage = var_16_11.respawn.health_percentage
				var_16_2.temporary_health_percentage = var_16_11.respawn.temporary_health_percentage

				if var_16_10 == var_16_1.peer_id then
					local var_16_12 = Managers.player:player(var_16_1.peer_id, var_16_1.local_player_id)
					local var_16_13 = var_16_1.profile_index
					local var_16_14 = var_16_1.career_index
					local var_16_15 = var_16_2.additional_items
					local var_16_16 = var_16_2.consumables.slot_health_kit
					local var_16_17 = var_16_2.consumables.slot_potion
					local var_16_18 = var_16_2.consumables.slot_grenade

					if var_16_2.spawn_state == "spawned" then
						arg_16_0:_delayed_respawn_player(var_16_12, var_16_13, var_16_14, var_16_9, var_16_16, var_16_17, var_16_18, var_16_15, var_16_1)
					else
						arg_16_0:_respawn_player(var_16_12, var_16_13, var_16_14, var_16_9, var_16_16, var_16_17, var_16_18, var_16_15)
					end
				else
					local var_16_19 = Managers.state.network:level_object_id(var_16_9)
					local var_16_20 = SpawningHelper.netpack_consumables(var_16_2.consumables)
					local var_16_21, var_16_22, var_16_23 = unpack(var_16_20)
					local var_16_24 = SpawningHelper.netpack_additional_items(var_16_2.additional_items)

					Managers.state.network.network_transmit:send_rpc("rpc_to_client_respawn_player", var_16_1.peer_id, var_16_1.local_player_id, var_16_1.profile_index, var_16_1.career_index, var_16_19, iter_16_0, var_16_21, var_16_22, var_16_23, var_16_24)
				end
			end
		elseif arg_16_0._move_players and var_16_2.health_state == "respawn" and arg_16_0:_check_all_synced() then
			local var_16_25 = var_16_2.respawn_unit
			local var_16_26 = arg_16_0:find_respawn_data_from_unit(var_16_25)

			if var_16_26 and not arg_16_0:_is_respawn_reachable(var_16_26) or arg_16_0._force_move then
				local var_16_27, var_16_28 = arg_16_0:find_best_respawn_point(false, false)

				if var_16_28 and (var_16_28.group_id == "" or var_16_28.group_id ~= var_16_26.group_id) then
					local var_16_29 = var_16_1.peer_id
					local var_16_30 = var_16_1.local_player_id

					if var_16_29 and var_16_30 then
						local var_16_31 = Managers.player:player(var_16_29, var_16_30).player_unit
						local var_16_32 = Managers.state.network:unit_game_object_id(var_16_31)
						local var_16_33 = ScriptUnit.extension(var_16_31, "locomotion_system")

						var_16_28.available = false

						local var_16_34 = Unit.local_position(var_16_27, 0)
						local var_16_35 = Unit.local_rotation(var_16_27, 0)

						LocomotionUtils.enable_linked_movement(arg_16_0._world, var_16_31, var_16_27, 0, Vector3.zero())
						var_16_33:teleport_to(var_16_34, var_16_35)
						Managers.state.network.network_transmit:send_rpc_clients("rpc_teleport_unit_to", var_16_32, var_16_34, var_16_35)
						arg_16_0:set_respawn_unit_available(var_16_25)

						var_16_2.respawn_unit = var_16_27
					end
				end
			end
		end

		var_16_0 = var_16_0 or var_16_2.health_state == "respawn"
	end

	if arg_16_0._move_players and arg_16_0:_check_all_synced() then
		arg_16_0._move_players = false
		arg_16_0._force_move = false
	elseif var_16_0 and arg_16_2 > arg_16_0._next_move_players_t then
		arg_16_0._next_move_players_t = arg_16_2 + var_0_3
		arg_16_0._move_players = true
	end
end

RespawnHandler.set_move_dead_players_to_next_respawn = function (arg_17_0, arg_17_1)
	arg_17_0._move_players = arg_17_1
end

RespawnHandler.queue_force_move_dead_players = function (arg_18_0)
	arg_18_0._move_players = true
	arg_18_0._force_move = true
end

local var_0_7 = {
	boss_event_chaos_spawn = true,
	boss_event_storm_fiend = true,
	boss_event_chaos_troll = true,
	boss_event_minotaur = true,
	boss_event_rat_ogre = true
}

RespawnHandler.destroy = function (arg_19_0)
	return
end

RespawnHandler.get_active_respawn_units = function (arg_20_0)
	local var_20_0 = arg_20_0._respawn_units
	local var_20_1 = {}

	for iter_20_0 = 1, #var_20_0 do
		local var_20_2 = var_20_0[iter_20_0]

		if not var_20_2.available then
			var_20_1[#var_20_1 + 1] = var_20_2.unit
		end
	end

	return var_20_1
end

RespawnHandler.get_available_and_active_respawn_units = function (arg_21_0)
	return arg_21_0._respawn_units
end

RespawnHandler.rpc_to_client_respawn_player = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10)
	local var_22_0 = CHANNEL_TO_PEER_ID[arg_22_1]

	printf("RespawnSystem:rpc_to_client_respawn_player(%s, %s)", tostring(var_22_0), tostring(arg_22_3))

	local var_22_1 = Managers.state.network:game_object_or_level_unit(arg_22_5, true)
	local var_22_2 = Managers.player:local_player(arg_22_2)
	local var_22_3 = SpawningHelper.unnetpack_additional_items(arg_22_10)

	if var_22_2:needs_despawn() or Unit.alive(var_22_2.player_unit) then
		Managers.state.spawn:delayed_despawn(var_22_2)
		arg_22_0:_delayed_respawn_player(var_22_2, arg_22_3, arg_22_4, var_22_1, NetworkLookup.item_names[arg_22_7], NetworkLookup.item_names[arg_22_8], NetworkLookup.item_names[arg_22_9], var_22_3)
	else
		arg_22_0:_respawn_player(var_22_2, arg_22_3, arg_22_4, var_22_1, NetworkLookup.item_names[arg_22_7], NetworkLookup.item_names[arg_22_8], NetworkLookup.item_names[arg_22_9], var_22_3)
	end
end

RespawnHandler._respawn_player = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	arg_23_1:set_profile_index(arg_23_2)
	arg_23_1:set_career_index(arg_23_3)

	local var_23_0 = Unit.local_position(arg_23_4, 0)
	local var_23_1 = Unit.local_rotation(arg_23_4, 0)
	local var_23_2 = Managers.state.difficulty:get_difficulty_settings().respawn
	local var_23_3 = var_23_2.ammo_melee
	local var_23_4 = var_23_2.ammo_ranged
	local var_23_5 = 0
	local var_23_6 = arg_23_1:spawn(var_23_0, var_23_1, false, var_23_3, var_23_4, arg_23_5, arg_23_6, arg_23_7, var_23_5, arg_23_8, nil, arg_23_4)
	local var_23_7 = Managers.state.network
	local var_23_8 = var_23_7:unit_game_object_id(var_23_6)
	local var_23_9 = var_23_7:level_object_id(arg_23_4)

	var_23_7.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.ready_for_assisted_respawn, true, var_23_8, var_23_9)
	var_23_7.network_transmit:send_rpc_server("rpc_respawn_confirmed", arg_23_1:local_player_id())
end

RespawnHandler.rpc_respawn_confirmed = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = CHANNEL_TO_PEER_ID[arg_24_1]

	Managers.party:get_player_status(var_24_0, arg_24_2).game_mode_data.ready_for_respawn = false
end

RespawnHandler.force_respawn_dead_players = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1.occupied_slots

	for iter_25_0 = 1, #var_25_0 do
		var_25_0[iter_25_0].game_mode_data.respawn_timer = 0
	end
end

RespawnHandler._delayed_respawn_player = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	local var_26_0 = {
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

	table.insert(arg_26_0._delayed_respawn_queue, var_26_0)
end

RespawnHandler.is_respawn_enabled = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._active_overridden_units

	if next(var_27_0) then
		return var_27_0[arg_27_1.unit]
	end

	return not arg_27_0._disabled_respawn_groups[arg_27_1.group_id]
end

RespawnHandler.is_spawn_group_override_active = function (arg_28_0, arg_28_1)
	return arg_28_0._active_overrides[arg_28_1]
end

RespawnHandler.get_boss_door_dist = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._boss_door_dist_lookup[arg_29_2]

	if var_29_0 then
		return var_29_0
	end

	local var_29_1 = Unit.world_position(arg_29_2, 0)
	local var_29_2, var_29_3 = MainPathUtils.closest_pos_at_main_path(arg_29_1, var_29_1)

	arg_29_0._boss_door_dist_lookup[arg_29_2] = var_29_3

	return var_29_3
end

RespawnHandler.get_next_boss_door_dist = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_1.main_paths
	local var_30_1 = Managers.state.conflict.enemy_recycler
	local var_30_2 = var_30_1.main_path_events[var_30_1.current_main_path_event_id]
	local var_30_3 = var_30_2 and var_30_2[3]
	local var_30_4 = var_0_7[var_30_3]
	local var_30_5 = var_30_1.current_main_path_event_activation_dist
	local var_30_6 = Managers.state.entity:system("door_system"):get_boss_door_units()
	local var_30_7 = math.huge
	local var_30_8 = math.huge
	local var_30_9 = math.huge
	local var_30_10 = math.huge

	for iter_30_0 = 1, #var_30_6 do
		local var_30_11 = var_30_6[iter_30_0]
		local var_30_12 = arg_30_0:get_boss_door_dist(var_30_0, var_30_11)
		local var_30_13 = var_30_12 - arg_30_2

		if var_30_13 < var_30_7 and var_30_13 >= 0 then
			local var_30_14 = ScriptUnit.extension(var_30_11, "door_system").current_state

			if var_30_14 and var_30_14 == "closed" then
				var_30_7 = var_30_13
				var_30_8 = var_30_12
			end
		end

		if var_30_4 then
			local var_30_15 = var_30_12 - var_30_5

			if var_30_15 >= 0 and var_30_15 < var_30_9 then
				var_30_9 = var_30_13
				var_30_10 = var_30_12
			end
		end
	end

	return math.min(var_30_8, var_30_10)
end

RespawnHandler.get_next_respawn_gate_dist = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._respawn_gate_units

	for iter_31_0 = 1, arg_31_0._respawn_gate_units_n do
		local var_31_1 = var_31_0[iter_31_0]

		if var_31_1.enabled and arg_31_1 < var_31_1.distance_through_level then
			return var_31_1.distance_through_level
		end
	end

	return math.huge
end

RespawnHandler.get_main_path_segment_start = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_1.current_path_index

	return arg_32_1.main_paths[var_32_0].travel_dist[1]
end

RespawnHandler.get_behind_unit_segment_start = function (arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1.behind_unit

	if ALIVE[var_33_0] then
		local var_33_1 = Unit.local_position(var_33_0, 0)
		local var_33_2, var_33_3, var_33_4, var_33_5, var_33_6 = MainPathUtils.closest_pos_at_main_path(nil, var_33_1, nil)

		return arg_33_1.main_paths[var_33_6].travel_dist[1]
	end

	return 0
end

RespawnHandler.get_respawn_dist_range = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0:get_main_path_segment_start(arg_34_1)
	local var_34_1 = math.huge
	local var_34_2 = arg_34_0:get_next_boss_door_dist(arg_34_1, arg_34_2)
	local var_34_3 = math.min(var_34_1, var_34_2)
	local var_34_4 = arg_34_0:get_next_respawn_gate_dist(arg_34_2)
	local var_34_5 = math.min(var_34_3, var_34_4)

	return var_34_0, var_34_5
end

RespawnHandler._is_respawn_reachable = function (arg_35_0, arg_35_1)
	if not arg_35_1 then
		return false
	end

	if arg_35_0._active_overridden_units[arg_35_1.unit] then
		return true
	end

	local var_35_0 = Managers.state.conflict.main_path_info
	local var_35_1 = arg_35_0:get_behind_unit_segment_start(var_35_0)

	return arg_35_1.distance_through_level >= var_35_1 - 0.01
end

RespawnHandler.find_best_respawn_point = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = Managers.state.conflict.main_path_info
	local var_36_1 = var_36_0.ahead_travel_dist
	local var_36_2 = var_36_1 + arg_36_0._respawn_distance
	local var_36_3, var_36_4 = arg_36_0:get_respawn_dist_range(var_36_0, var_36_1)
	local var_36_5 = arg_36_0._respawn_units
	local var_36_6 = arg_36_0._active_overridden_units
	local var_36_7 = next(var_36_6) ~= nil
	local var_36_8 = arg_36_0._disabled_respawn_groups
	local var_36_9
	local var_36_10 = 0

	for iter_36_0 = 1, #var_36_5 do
		local var_36_11 = var_36_5[iter_36_0]
		local var_36_12 = var_36_11.distance_through_level
		local var_36_13 = 0

		if var_36_11.available then
			if var_36_6[var_36_11.unit] then
				var_36_13 = 3
			elseif not var_36_8[var_36_11.group_id] and var_36_12 <= var_36_4 then
				if not var_36_7 and var_36_2 <= var_36_12 then
					var_36_13 = 3
				elseif var_36_1 <= var_36_12 then
					var_36_13 = 2
				elseif var_36_3 <= var_36_12 then
					var_36_13 = 1
				end
			end
		end

		if not var_36_9 or var_36_10 < var_36_13 or var_36_10 == var_36_13 and (var_36_13 < 3 and var_36_12 > var_36_9.distance_through_level and var_36_12 < var_36_2 or var_36_13 >= 3 and var_36_12 < var_36_9.distance_through_level) then
			var_36_10 = var_36_13
			var_36_9 = var_36_11

			if not arg_36_2 and (var_36_13 >= 3 or var_36_4 < var_36_12) then
				break
			end
		end
	end

	if var_36_9 then
		if arg_36_1 then
			var_36_9.available = false
		end

		local var_36_14 = var_36_9.unit

		if var_36_7 and not var_36_6[var_36_14] then
			print("[RespawnHandler] Overrides active, but no respawn units available, falling back to noraml respawn point.")
			print(string.format("[RespawnHandler] min_dist %.2f, max_dist %.2f, ahead_unit_travel_dist %.2f", var_36_3, var_36_4, var_36_1))
			print("[RespawnHandler] Active Override:")

			for iter_36_1 in pairs(arg_36_0._active_overrides) do
				print(iter_36_1)
			end
		end

		if not arg_36_2 then
			print(string.format("[RespawnHandler] Picking spawn point at %.2f, params: min_dist %.2f, max_dist %.2f, ahead_unit_travel_dist %.2f", var_36_9.distance_through_level, var_36_3, var_36_4, var_36_1))

			local var_36_15 = var_36_0.ahead_unit

			print("[RespawnHandler] Ahead player position", POSITION_LOOKUP[var_36_15])
		end

		return var_36_14, var_36_9
	end

	return nil, nil
end
