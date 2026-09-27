-- chunkname: @scripts/managers/game_mode/spawning_components/versus_spawning.lua

require("scripts/managers/game_mode/spawning_components/spawning_helper")

VersusSpawning = class(VersusSpawning)

local tbl = {
	"rpc_from_server_send_spawn_state",
	"rpc_to_server_spawn_failed"
}

VersusSpawning.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	self._side_name = arg_1_1
	self._profile_synchronizer = arg_1_2
	self._available_profiles = arg_1_3
	self._available_special_profiles = arg_1_3
	self._settings = arg_1_5
	self._respawn_timer_margin = arg_1_5.dark_pact_respawn_timer_margin
	self._is_server = arg_1_4
	self._server_peer_id = Managers.mechanism:server_peer_id()
	self._mechanism = Managers.mechanism:game_mechanism()
	self._win_conditions = self._mechanism:win_conditions()
	self._career_delegator = arg_1_6
	self._spawn_points = {}
	self._spawn_groups = {}
	self._used_spawn_group_positions = {}
	self._num_spawn_points_used = 0

	local mechanism_try_call, var_1_1, var_1_2 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "pactsworn_respawn_timer")

	if not (not mechanism_try_call and not var_1_2 and var_1_1 == "default") then
		self._respawn_time_override = var_1_1
	end
end

VersusSpawning.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	arg_2_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_2_1
	self._network_transmit = arg_2_2
end

VersusSpawning.unregister_rpcs = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._network_transmit = nil
end

function get_special_profiles(self)
	-- function 4
	local tbl = {}

	for i = 1, #self do
		local var_4_1 = self[i]

		if PROFILES_BY_NAME[var_4_1].role == "special" then
			tbl[#tbl + 1] = var_4_1
		end
	end

	return tbl
end

VersusSpawning.get_spawn_time = function (self, arg_5_1)
	-- function 5
	if not self._respawn_time_override then
		return self._respawn_time_override
	end

	local var_5_0 = arg_5_1
	local party_id = Managers.state.side:get_side_from_name("heroes").party.party_id
	local num_used_slots = arg_5_1.num_used_slots
	local var_5_3 = self._settings.dark_pact_respawn_timers[num_used_slots]
	local dark_pact_minimum_spawn_time = self._settings.dark_pact_minimum_spawn_time
	local num = -200
	local num_2 = 0
	local num_3 = (self._win_conditions:get_total_score(var_5_0) - self._win_conditions:get_total_score(party_id) - num) / (num_2 - num)
	local clamp = math.clamp(num_3, 0, 1)
	local ceil = math.ceil(math.lerp(var_5_3.min, var_5_3.max, clamp))

	ceil = ceil or 20

	if self._mechanism:get_current_set() == 1 then
		ceil = var_5_3.max or 20
	end

	return (math.clamp(ceil, dark_pact_minimum_spawn_time, math.huge))
end

local function fn(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local bot_data = arg_6_2.bot_data

	bot_data.state = "alive"
	bot_data.unit = arg_6_0
end

VersusSpawning.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not Managers.state.network:game() then
		local _side_name = self._side_name
		local var_7_1 = FindProfileIndex("vs_undecided")
		local get_party_from_side_name = Managers.state.side:get_party_from_side_name(_side_name)
		local occupied_slots = get_party_from_side_name.occupied_slots

		for i = 1, #occupied_slots do
			local var_7_4 = occupied_slots[i]
			local player_from_unique_id = Managers.player:player_from_unique_id(var_7_4.unique_id)

			if not player_from_unique_id then
				local game_mode_data = var_7_4.game_mode_data
				local spawn_state = game_mode_data.spawn_state

				if spawn_state == "w8_for_profile" then
					local peer_id = var_7_4.peer_id
					local local_player_id = var_7_4.local_player_id
					local profile_by_peer = self._profile_synchronizer:profile_by_peer(peer_id, local_player_id)

					if not (not profile_by_peer and profile_by_peer == var_7_1) then
						self:set_spawn_state(peer_id, local_player_id, "w8_to_spawn", 0, 0, false)
					end
				elseif spawn_state == "w8_to_spawn" then
					if not (not player_from_unique_id.player_unit and Unit.alive(player_from_unique_id.player_unit)) then
						self:_spawn_enemy(var_7_4)
						self:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "spawning", 0, 0, false)
					end
				elseif spawn_state == "spawning" then
					if not player_from_unique_id.player_unit then
						self:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "spawned", 0, 0, false)
					end
				elseif spawn_state == "spawned" then
					local player_unit = player_from_unique_id.player_unit

					if not Unit.alive(player_unit) then
						if not ScriptUnit.extension(player_unit, "status_system"):is_dead() then
							self:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "dead", 0, 0, false)
						end
					else
						local get_spawn_time = self:get_spawn_time(get_party_from_side_name)

						self:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "dead", 0, get_spawn_time, true)
					end
				elseif spawn_state == "dead" then
					local delayed_death_timer = game_mode_data.delayed_death_timer

					if not delayed_death_timer then
						local num = arg_7_1 + self._settings.side_settings.dark_pact.spawn_times.delayed_death_time

						num = num or 0
						game_mode_data.delayed_death_timer = num
					elseif arg_7_1 - delayed_death_timer >= 0 then
						game_mode_data.delayed_death_timer = nil

						Managers.state.game_mode:game_mode():assign_temporary_dark_pact_profile(var_7_4)

						local get_spawn_time_2 = self:get_spawn_time(get_party_from_side_name)

						self:set_spawn_state(var_7_4.peer_id, var_7_4.local_player_id, "w8_for_profile", 0, get_spawn_time_2, true)
					end
				end
			end
		end
	end
end

VersusSpawning.client_update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	return
end

VersusSpawning.add_spawn_point = function (self, arg_9_1)
	-- function 9
	local local_position = Unit.local_position(arg_9_1, 0)
	local local_rotation = Unit.local_rotation(arg_9_1, 0)
	local tbl = {
		pos = Vector3Box(local_position),
		rot = QuaternionBox(local_rotation),
		unit = arg_9_1
	}
	local get_data = Unit.get_data(arg_9_1, "spawn_group")

	fassert(get_data, "spawn group property missing from spawn point unit")

	if not self._spawn_groups[get_data] then
		self._spawn_groups[get_data] = {}
	end

	local count = #self._spawn_groups[get_data]

	self._spawn_groups[get_data][count + 1] = tbl
end

VersusSpawning.get_spawn_point = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = self._spawn_groups[arg_10_1]

	if not var_10_0 then
		return nil, nil, nil
	end

	local var_10_1 = var_10_0[arg_10_2 or 1]

	if not var_10_1 then
		return var_10_1.pos, var_10_1.rot, var_10_1.unit
	end
end

VersusSpawning._check_spawn_observer = function (self, arg_11_1)
	-- function 11
	local spawn_at_players_on_side = self._settings.side_settings.dark_pact.spawn_at_players_on_side
	local observed_unit = arg_11_1:observed_unit()

	if not Unit.alive(observed_unit) then
		local var_11_2 = Managers.state.side.side_by_unit[observed_unit]
		local local_position = Unit.local_position(observed_unit, 0)
		local local_rotation = Unit.local_rotation(observed_unit, 0)

		if not var_11_2 then
			local var_11_5 = spawn_at_players_on_side[var_11_2:name()]

			if not var_11_5 and not var_11_5() then
				return local_position, local_rotation
			end
		else
			return local_position, local_rotation
		end
	end

	local keys = table.keys(spawn_at_players_on_side)

	while #keys > 0 do
		local random = math.random(1, #keys)
		local remove = table.remove(keys, random)

		if not spawn_at_players_on_side[remove]() then
			local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name(remove).PLAYER_AND_BOT_UNITS
			local count = #PLAYER_AND_BOT_UNITS
			local random_2 = math.random(1, count)

			for i = 1, count do
				local var_11_12 = PLAYER_AND_BOT_UNITS[math.index_wrapper(i + random_2 - 1, count)]
				local var_11_13 = POSITION_LOOKUP[var_11_12]

				if not var_11_13 then
					local local_rotation_2 = Unit.local_rotation(var_11_12, 0)

					return var_11_13 + Vector3(0, 0, 0.1), local_rotation_2
				end
			end
		end
	end

	return nil, nil
end

VersusSpawning._get_fallback_spawn_position = function (arg_12_0, arg_12_1)
	-- function 12
	local var_12_0
	local ahead_travel_dist = Managers.state.conflict.main_path_info.ahead_travel_dist
	local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, ahead_travel_dist)

	if not point_on_mainpath then
		local total_path_dist = MainPathUtils.total_path_dist()

		point_on_mainpath = MainPathUtils.point_on_mainpath(nil, total_path_dist - 0.1)
	end

	return point_on_mainpath
end

VersusSpawning._get_allowed_spawn_position = function (self, arg_13_1)
	-- function 13
	local _check_spawn_observer, var_13_1 = self:_check_spawn_observer(arg_13_1)

	if not (_check_spawn_observer or Managers.state.game_mode:is_round_started()) then
		local get_current_spawn_group = Managers.mechanism:game_mechanism():get_current_spawn_group()

		if not (table.size(self._spawn_points) > 0 or self._spawn_groups[get_current_spawn_group]) then
			_check_spawn_observer, var_13_1 = self:get_spawn_point(get_current_spawn_group)
			_check_spawn_observer = _check_spawn_observer:unbox()
			var_13_1 = var_13_1:unbox()
		end
	end

	_check_spawn_observer = _check_spawn_observer or self:_get_fallback_spawn_position(arg_13_1)
	var_13_1 = var_13_1 or Quaternion.identity()

	return _check_spawn_observer, var_13_1
end

VersusSpawning._spawn_enemy = function (self, arg_14_1)
	-- function 14
	local peer_id = arg_14_1.peer_id
	local local_player_id = arg_14_1.local_player_id
	local profile_index = arg_14_1.profile_index
	local career_index = arg_14_1.career_index
	local get_current_spawn_group = Managers.mechanism:game_mechanism():get_current_spawn_group()
	local _get_allowed_spawn_position, var_14_6 = self:_get_allowed_spawn_position(arg_14_1.player)
	local flag = not arg_14_1.has_done_initial_spawn and not arg_14_1.has_done_initial_spawn[get_current_spawn_group]
	local has_done_initial_spawn = arg_14_1.has_done_initial_spawn

	has_done_initial_spawn = has_done_initial_spawn or {}
	arg_14_1.has_done_initial_spawn = has_done_initial_spawn
	arg_14_1.has_done_initial_spawn[get_current_spawn_group] = true

	local game_mode_data = arg_14_1.game_mode_data
	local netpack_consumables = SpawningHelper.netpack_consumables
	local consumables = game_mode_data.consumables

	consumables = consumables or {}

	local var_14_12 = netpack_consumables(consumables)
	local var_14_13, var_14_14, var_14_15 = unpack(var_14_12)
	local netpack_additional_items = SpawningHelper.netpack_additional_items(game_mode_data.additional_items)
	local num = 0
	local num_2 = 0
	local num_3 = 100
	local ammo = game_mode_data.ammo

	if not ammo then
		num = math.floor(ammo.slot_melee * 100)
		num_2 = math.floor(ammo.slot_ranged * 100)
	end

	local tbl = {}

	if not game_mode_data.persistent_buffs then
		for k, v in pairs(game_mode_data.persistent_buffs.buff_names) do
			local var_14_22 = NetworkLookup.buff_templates[v]

			table.insert(tbl, var_14_22)
		end
	end

	print("Spawning versus enemy player")

	if not Managers.state.network:game() then
		local cached_inventory_hash = self._profile_synchronizer:cached_inventory_hash(peer_id, local_player_id)

		Managers.state.network.network_transmit:send_rpc("rpc_to_client_spawn_player", peer_id, local_player_id, profile_index, career_index, _get_allowed_spawn_position, var_14_6, flag, num, num_2, num_3, var_14_13, var_14_14, var_14_15, netpack_additional_items, tbl, cached_inventory_hash)
	end
end

VersusSpawning.setup_data = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
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

VersusSpawning.handle_transporter = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	return
end

VersusSpawning.force_respawn = function (self, arg_17_1, arg_17_2)
	-- function 17
	local game_mode_data = Managers.party:get_player_status(arg_17_1, arg_17_2).game_mode_data

	if not game_mode_data.spawn_timer then
		game_mode_data.spawn_timer = 0
	end

	self:set_spawn_state(arg_17_1, arg_17_2, "w8_to_spawn", 0, 0, false)
end

VersusSpawning.rpc_from_server_send_spawn_state = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	-- function 18
	local var_18_0 = NetworkLookup.spawn_states[arg_18_4]

	self:set_spawn_state(arg_18_2, arg_18_3, var_18_0, arg_18_5, arg_18_6, arg_18_7)
end

VersusSpawning.set_spawn_state = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	-- function 19
	local Managers = Managers
	local get_player_status = Managers.party:get_player_status(arg_19_1, arg_19_2)

	if not get_player_status then
		return
	end

	local game_mode_data = get_player_status.game_mode_data

	if arg_19_3 == "w8_for_profile" then
		local player = Managers.player:player(arg_19_1, arg_19_2)
		local num = Managers.time:time("game") + arg_19_5

		game_mode_data.spawn_timer = num

		local get_local_player_party = Managers.party:get_local_player_party()

		if not ((Network.peer_id() == arg_19_1 or not get_local_player_party) and get_player_status.party_id ~= get_local_player_party.party_id) then
			local flag = not not player.remote or not player.bot_player
			local var_19_7 = arg_19_6

			Managers.state.event:trigger("add_respawn_counter_event", player, flag, num, var_19_7)
		end
	end

	game_mode_data.spawn_state = arg_19_3

	if not self._is_server then
		local var_19_8 = NetworkLookup.spawn_states[arg_19_3]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_from_server_send_spawn_state", arg_19_1, arg_19_2, var_19_8, arg_19_4, arg_19_5, arg_19_6)
	end
end

VersusSpawning._play_sound = function (arg_20_0, arg_20_1)
	-- function 20
	local world = Managers.world:world("level_world")
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.trigger_event(wwise_world, arg_20_1)
end

VersusSpawning.rpc_to_server_spawn_failed = function (self, arg_21_1, arg_21_2)
	-- function 21
	print("[VersusSpawning] Client detected spawning mismatch. Trying again.")

	local var_21_0 = CHANNEL_TO_PEER_ID[arg_21_1]
	local _side_name = self._side_name
	local occupied_slots = Managers.state.side:get_party_from_side_name(_side_name).occupied_slots

	for i = 1, #occupied_slots do
		local var_21_3 = occupied_slots[i]
		local peer_id = var_21_3.peer_id
		local local_player_id = var_21_3.local_player_id

		if not (var_21_0 ~= peer_id or arg_21_2 ~= local_player_id) then
			local game_mode_data = var_21_3.game_mode_data

			if game_mode_data.spawn_state == "spawning" then
				game_mode_data.spawn_state = "w8_to_spawn"

				break
			end

			print("[VersusSpawning] This shouldn't happen. How did we leave spawning?")

			break
		end
	end
end
