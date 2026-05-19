-- chunkname: @scripts/managers/game_mode/spawning_components/versus_spawning.lua

require("scripts/managers/game_mode/spawning_components/spawning_helper")

VersusSpawning = class(VersusSpawning)

local var_0_0 = {
	"rpc_from_server_send_spawn_state",
	"rpc_to_server_spawn_failed"
}

function VersusSpawning.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0._side_name = arg_1_1
	arg_1_0._profile_synchronizer = arg_1_2
	arg_1_0._available_profiles = arg_1_3
	arg_1_0._available_special_profiles = arg_1_3
	arg_1_0._settings = arg_1_5
	arg_1_0._respawn_timer_margin = arg_1_5.dark_pact_respawn_timer_margin
	arg_1_0._is_server = arg_1_4
	arg_1_0._server_peer_id = Managers.mechanism:server_peer_id()
	arg_1_0._mechanism = Managers.mechanism:game_mechanism()
	arg_1_0._win_conditions = arg_1_0._mechanism:win_conditions()
	arg_1_0._career_delegator = arg_1_6
	arg_1_0._spawn_points = {}
	arg_1_0._spawn_groups = {}
	arg_1_0._used_spawn_group_positions = {}
	arg_1_0._num_spawn_points_used = 0

	local var_1_0, var_1_1, var_1_2 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "pactsworn_respawn_timer")

	if var_1_0 and var_1_2 and var_1_1 ~= "default" then
		arg_1_0._respawn_time_override = var_1_1
	end
end

function VersusSpawning.register_rpcs(arg_2_0, arg_2_1, arg_2_2)
	arg_2_1:register(arg_2_0, unpack(var_0_0))

	arg_2_0._network_event_delegate = arg_2_1
	arg_2_0._network_transmit = arg_2_2
end

function VersusSpawning.unregister_rpcs(arg_3_0)
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil
	arg_3_0._network_transmit = nil
end

function get_special_profiles(arg_4_0)
	local var_4_0 = {}

	for iter_4_0 = 1, #arg_4_0 do
		local var_4_1 = arg_4_0[iter_4_0]

		if PROFILES_BY_NAME[var_4_1].role == "special" then
			var_4_0[#var_4_0 + 1] = var_4_1
		end
	end

	return var_4_0
end

function VersusSpawning.get_spawn_time(arg_5_0, arg_5_1)
	if arg_5_0._respawn_time_override then
		return arg_5_0._respawn_time_override
	end

	local var_5_0 = arg_5_1
	local var_5_1 = Managers.state.side:get_side_from_name("heroes").party.party_id
	local var_5_2 = arg_5_1.num_used_slots
	local var_5_3 = arg_5_0._settings.dark_pact_respawn_timers[var_5_2]
	local var_5_4 = arg_5_0._settings.dark_pact_minimum_spawn_time
	local var_5_5 = -200
	local var_5_6 = 0
	local var_5_7 = (arg_5_0._win_conditions:get_total_score(var_5_0) - arg_5_0._win_conditions:get_total_score(var_5_1) - var_5_5) / (var_5_6 - var_5_5)
	local var_5_8 = math.clamp(var_5_7, 0, 1)
	local var_5_9 = math.ceil(math.lerp(var_5_3.min, var_5_3.max, var_5_8)) or 20

	if arg_5_0._mechanism:get_current_set() == 1 then
		var_5_9 = var_5_3.max or 20
	end

	return (math.clamp(var_5_9, var_5_4, math.huge))
end

local function var_0_1(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.bot_data

	var_6_0.state = "alive"
	var_6_0.unit = arg_6_0
end

function VersusSpawning.update(arg_7_0, arg_7_1, arg_7_2)
	if Managers.state.network:game() then
		local var_7_0 = arg_7_0._side_name
		local var_7_1 = FindProfileIndex("vs_undecided")
		local var_7_2 = Managers.state.side:get_party_from_side_name(var_7_0)
		local var_7_3 = var_7_2.occupied_slots

		for iter_7_0 = 1, #var_7_3 do
			local var_7_4 = var_7_3[iter_7_0]
			local var_7_5 = Managers.player:player_from_unique_id(var_7_4.unique_id)

			if var_7_5 then
				local var_7_6 = var_7_4.game_mode_data
				local var_7_7 = var_7_6.spawn_state

				if var_7_7 == "w8_for_profile" then
					local var_7_8 = var_7_4.peer_id
					local var_7_9 = var_7_4.local_player_id
					local var_7_10 = arg_7_0._profile_synchronizer:profile_by_peer(var_7_8, var_7_9)

					if var_7_10 and var_7_10 ~= var_7_1 then
						arg_7_0:set_spawn_state(var_7_8, var_7_9, "w8_to_spawn", 0, 0, false)
					end
				elseif var_7_7 == "w8_to_spawn" then
					if not var_7_5.player_unit or not Unit.alive(var_7_5.player_unit) then
						arg_7_0:_spawn_enemy(var_7_4)
						arg_7_0:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "spawning", 0, 0, false)
					end
				elseif var_7_7 == "spawning" then
					if var_7_5.player_unit then
						arg_7_0:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "spawned", 0, 0, false)
					end
				elseif var_7_7 == "spawned" then
					local var_7_11 = var_7_5.player_unit

					if Unit.alive(var_7_11) then
						if ScriptUnit.extension(var_7_11, "status_system"):is_dead() then
							arg_7_0:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "dead", 0, 0, false)
						end
					else
						local var_7_12 = arg_7_0:get_spawn_time(var_7_2)

						arg_7_0:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "dead", 0, var_7_12, true)
					end
				elseif var_7_7 == "dead" then
					local var_7_13 = var_7_6.delayed_death_timer

					if not var_7_13 then
						var_7_6.delayed_death_timer = arg_7_1 + arg_7_0._settings.side_settings.dark_pact.spawn_times.delayed_death_time or 0
					elseif arg_7_1 - var_7_13 >= 0 then
						var_7_6.delayed_death_timer = nil

						Managers.state.game_mode:game_mode():assign_temporary_dark_pact_profile(var_7_4)

						local var_7_14 = arg_7_0:get_spawn_time(var_7_2)

						arg_7_0:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "w8_for_profile", 0, var_7_14, true)
					end
				end
			end
		end
	end
end

function VersusSpawning.client_update(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	return
end

function VersusSpawning.add_spawn_point(arg_9_0, arg_9_1)
	local var_9_0 = Unit.local_position(arg_9_1, 0)
	local var_9_1 = Unit.local_rotation(arg_9_1, 0)
	local var_9_2 = {
		pos = Vector3Box(var_9_0),
		rot = QuaternionBox(var_9_1),
		unit = arg_9_1
	}
	local var_9_3 = Unit.get_data(arg_9_1, "spawn_group")

	fassert(var_9_3, "spawn group property missing from spawn point unit")

	if not arg_9_0._spawn_groups[var_9_3] then
		arg_9_0._spawn_groups[var_9_3] = {}
	end

	local var_9_4 = #arg_9_0._spawn_groups[var_9_3]

	arg_9_0._spawn_groups[var_9_3][var_9_4 + 1] = var_9_2
end

function VersusSpawning.get_spawn_point(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._spawn_groups[arg_10_1]

	if not var_10_0 then
		return nil, nil, nil
	end

	local var_10_1 = var_10_0[arg_10_2 or 1]

	if var_10_1 then
		return var_10_1.pos, var_10_1.rot, var_10_1.unit
	end
end

function VersusSpawning._check_spawn_observer(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._settings.side_settings.dark_pact.spawn_at_players_on_side
	local var_11_1 = arg_11_1:observed_unit()

	if Unit.alive(var_11_1) then
		local var_11_2 = Managers.state.side.side_by_unit[var_11_1]
		local var_11_3 = Unit.local_position(var_11_1, 0)
		local var_11_4 = Unit.local_rotation(var_11_1, 0)

		if var_11_2 then
			local var_11_5 = var_11_0[var_11_2:name()]

			if var_11_5 and var_11_5() then
				return var_11_3, var_11_4
			end
		else
			return var_11_3, var_11_4
		end
	end

	local var_11_6 = table.keys(var_11_0)

	while #var_11_6 > 0 do
		local var_11_7 = math.random(1, #var_11_6)
		local var_11_8 = table.remove(var_11_6, var_11_7)

		if var_11_0[var_11_8]() then
			local var_11_9 = Managers.state.side:get_side_from_name(var_11_8).PLAYER_AND_BOT_UNITS
			local var_11_10 = #var_11_9
			local var_11_11 = math.random(1, var_11_10)

			for iter_11_0 = 1, var_11_10 do
				local var_11_12 = var_11_9[math.index_wrapper(iter_11_0 + var_11_11 - 1, var_11_10)]
				local var_11_13 = POSITION_LOOKUP[var_11_12]

				if var_11_13 then
					local var_11_14 = Unit.local_rotation(var_11_12, 0)

					return var_11_13 + Vector3(0, 0, 0.1), var_11_14
				end
			end
		end
	end

	return nil, nil
end

function VersusSpawning._get_fallback_spawn_position(arg_12_0, arg_12_1)
	local var_12_0
	local var_12_1 = Managers.state.conflict.main_path_info.ahead_travel_dist
	local var_12_2 = MainPathUtils.point_on_mainpath(nil, var_12_1)

	if not var_12_2 then
		local var_12_3 = MainPathUtils.total_path_dist()

		var_12_2 = MainPathUtils.point_on_mainpath(nil, var_12_3 - 0.1)
	end

	return var_12_2
end

function VersusSpawning._get_allowed_spawn_position(arg_13_0, arg_13_1)
	local var_13_0, var_13_1 = arg_13_0:_check_spawn_observer(arg_13_1)

	if not var_13_0 and not Managers.state.game_mode:is_round_started() then
		local var_13_2 = Managers.mechanism:game_mechanism():get_current_spawn_group()

		if table.size(arg_13_0._spawn_points) > 0 or arg_13_0._spawn_groups[var_13_2] then
			var_13_0, var_13_1 = arg_13_0:get_spawn_point(var_13_2)
			var_13_0 = var_13_0:unbox()
			var_13_1 = var_13_1:unbox()
		end
	end

	var_13_0 = var_13_0 or arg_13_0:_get_fallback_spawn_position(arg_13_1)
	var_13_1 = var_13_1 or Quaternion.identity()

	return var_13_0, var_13_1
end

function VersusSpawning._spawn_enemy(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.peer_id
	local var_14_1 = arg_14_1.local_player_id
	local var_14_2 = arg_14_1.profile_index
	local var_14_3 = arg_14_1.career_index
	local var_14_4 = Managers.mechanism:game_mechanism():get_current_spawn_group()
	local var_14_5, var_14_6 = arg_14_0:_get_allowed_spawn_position(arg_14_1.player)
	local var_14_7 = not arg_14_1.has_done_initial_spawn or not arg_14_1.has_done_initial_spawn[var_14_4]

	arg_14_1.has_done_initial_spawn = arg_14_1.has_done_initial_spawn or {}
	arg_14_1.has_done_initial_spawn[var_14_4] = true

	local var_14_8 = arg_14_1.game_mode_data
	local var_14_9 = SpawningHelper.netpack_consumables(var_14_8.consumables or {})
	local var_14_10, var_14_11, var_14_12 = unpack(var_14_9)
	local var_14_13 = SpawningHelper.netpack_additional_items(var_14_8.additional_items)
	local var_14_14 = 0
	local var_14_15 = 0
	local var_14_16 = 100
	local var_14_17 = var_14_8.ammo

	if var_14_17 then
		var_14_14 = math.floor(var_14_17.slot_melee * 100)
		var_14_15 = math.floor(var_14_17.slot_ranged * 100)
	end

	local var_14_18 = {}

	if var_14_8.persistent_buffs then
		for iter_14_0, iter_14_1 in pairs(var_14_8.persistent_buffs.buff_names) do
			local var_14_19 = NetworkLookup.buff_templates[iter_14_1]

			table.insert(var_14_18, var_14_19)
		end
	end

	print("Spawning versus enemy player")

	if Managers.state.network:game() then
		local var_14_20 = arg_14_0._profile_synchronizer:cached_inventory_hash(var_14_0, var_14_1)

		Managers.state.network.network_transmit:send_rpc("rpc_to_client_spawn_player", var_14_0, var_14_1, var_14_2, var_14_3, var_14_5, var_14_6, var_14_7, var_14_14, var_14_15, var_14_16, var_14_10, var_14_11, var_14_12, var_14_13, var_14_18, var_14_20)
	end
end

function VersusSpawning.setup_data(arg_15_0, arg_15_1, arg_15_2)
	Managers.party:get_player_status(arg_15_1, arg_15_2).game_mode_data = {
		health_percentage = 1,
		temporary_health_percentage = 0,
		health_state = "alive",
		last_update = -math.huge,
		ammo = {
			slot_ranged = 1,
			slot_melee = 1
		},
		consumables = {},
		additional_items = {}
	}
end

function VersusSpawning.handle_transporter(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	return
end

function VersusSpawning.force_respawn(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Managers.party:get_player_status(arg_17_1, arg_17_2).game_mode_data

	if not var_17_0.spawn_timer then
		var_17_0.spawn_timer = 0
	end

	arg_17_0:set_spawn_state(arg_17_1, arg_17_2, "w8_to_spawn", 0, 0, false)
end

function VersusSpawning.rpc_from_server_send_spawn_state(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	local var_18_0 = NetworkLookup.spawn_states[arg_18_4]

	arg_18_0:set_spawn_state(arg_18_2, arg_18_3, var_18_0, arg_18_5, arg_18_6, arg_18_7)
end

function VersusSpawning.set_spawn_state(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	local var_19_0 = Managers
	local var_19_1 = var_19_0.party:get_player_status(arg_19_1, arg_19_2)

	if not var_19_1 then
		return
	end

	local var_19_2 = var_19_1.game_mode_data

	if arg_19_3 == "w8_for_profile" then
		local var_19_3 = var_19_0.player:player(arg_19_1, arg_19_2)
		local var_19_4 = var_19_0.time:time("game") + arg_19_5

		var_19_2.spawn_timer = var_19_4

		local var_19_5 = var_19_0.party:get_local_player_party()

		if Network.peer_id() == arg_19_1 or var_19_5 and var_19_1.party_id == var_19_5.party_id then
			local var_19_6 = not var_19_3.remote and not var_19_3.bot_player
			local var_19_7 = arg_19_6

			var_19_0.state.event:trigger("add_respawn_counter_event", var_19_3, var_19_6, var_19_4, var_19_7)
		end
	end

	var_19_2.spawn_state = arg_19_3

	if arg_19_0._is_server then
		local var_19_8 = NetworkLookup.spawn_states[arg_19_3]

		var_19_0.state.network.network_transmit:send_rpc_clients("rpc_from_server_send_spawn_state", arg_19_1, arg_19_2, var_19_8, arg_19_4, arg_19_5, arg_19_6)
	end
end

function VersusSpawning._play_sound(arg_20_0, arg_20_1)
	local var_20_0 = Managers.world:world("level_world")
	local var_20_1 = Managers.world:wwise_world(var_20_0)

	WwiseWorld.trigger_event(var_20_1, arg_20_1)
end

function VersusSpawning.rpc_to_server_spawn_failed(arg_21_0, arg_21_1, arg_21_2)
	print("[VersusSpawning] Client detected spawning mismatch. Trying again.")

	local var_21_0 = CHANNEL_TO_PEER_ID[arg_21_1]
	local var_21_1 = arg_21_0._side_name
	local var_21_2 = Managers.state.side:get_party_from_side_name(var_21_1).occupied_slots

	for iter_21_0 = 1, #var_21_2 do
		local var_21_3 = var_21_2[iter_21_0]
		local var_21_4 = var_21_3.peer_id
		local var_21_5 = var_21_3.local_player_id

		if var_21_0 == var_21_4 and arg_21_2 == var_21_5 then
			local var_21_6 = var_21_3.game_mode_data

			if var_21_6.spawn_state == "spawning" then
				var_21_6.spawn_state = "w8_to_spawn"

				break
			end

			print("[VersusSpawning] This shouldn't happen. How did we leave spawning?")

			break
		end
	end
end
