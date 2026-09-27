-- chunkname: @scripts/managers/conflict_director/terror_event_mixer.lua

require("scripts/settings/terror_event_blueprints")

function create_spawn_counter()
	-- function 1
	local tbl = {}
	local tbl_2 = {
		__index = function ()
			-- function 2
			return 0
		end
	}

	setmetatable(tbl, tbl_2)

	return tbl
end

local function fn(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	arg_3_1 = arg_3_1 or {}

	local function fn(arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		local data = arg_3_0.data
		local spawn_counter = arg_3_0.data.spawn_counter

		spawn_counter = spawn_counter or create_spawn_counter()
		data.spawn_counter = spawn_counter

		local spawn_counter_2 = arg_3_0.data.spawn_counter
		local var_4_3 = arg_3_2
		local var_4_4 = arg_3_0.data.spawn_counter[arg_3_2]

		var_4_4 = var_4_4 or 0
		spawn_counter_2[var_4_3] = var_4_4 + 1
	end

	local function fn_2(arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		arg_3_0.data.spawn_counter[arg_3_2] = arg_3_0.data.spawn_counter[arg_3_2] - 1
	end

	if not arg_3_1.spawned_func then
		arg_3_1.spawned_func = fn
	else
		local spawned_func = arg_3_1.spawned_func

		arg_3_1.spawned_func = function (arg_6_0, arg_6_1, arg_6_2)
			-- function 6
			spawned_func(arg_6_0, arg_6_1, arg_6_2)
			fn(arg_6_0, arg_6_1, arg_6_2)
		end
	end

	if not arg_3_1.despawned_func then
		arg_3_1.despawned_func = fn_2
	else
		local despawned_func = arg_3_1.despawned_func

		arg_3_1.despawned_func = function (arg_7_0, arg_7_1, arg_7_2)
			-- function 7
			despawned_func(arg_7_0, arg_7_1, arg_7_2)
			fn_2(arg_7_0, arg_7_1, arg_7_2)
		end
	end

	return arg_3_1
end

local TerrorEventMixer = TerrorEventMixer

TerrorEventMixer = TerrorEventMixer or {}
TerrorEventMixer = TerrorEventMixer

local TerrorEventMixer_2 = TerrorEventMixer
local active_events = TerrorEventMixer_2.active_events

active_events = active_events or {}
TerrorEventMixer_2.active_events = active_events
TerrorEventMixer_2.active_event_i = -1

local start_event_list = TerrorEventMixer_2.start_event_list

start_event_list = start_event_list or {}
TerrorEventMixer_2.start_event_list = start_event_list

local finished_events = TerrorEventMixer_2.finished_events

finished_events = finished_events or {}
TerrorEventMixer_2.finished_events = finished_events

local optional_data = TerrorEventMixer_2.optional_data

optional_data = optional_data or {}
TerrorEventMixer_2.optional_data = optional_data
TerrorEventMixer_2.incrementing_id = 1
TerrorEventMixer_2.init_functions = {
	text = function (self, arg_8_1, arg_8_2)
		-- function 8
		self.ends_at = arg_8_2 + ConflictUtils.random_interval(arg_8_1.duration)
	end,
	delay = function (self, arg_9_1, arg_9_2)
		-- function 9
		self.ends_at = arg_9_2 + ConflictUtils.random_interval(arg_9_1.duration)
	end,
	spawn = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		return
	end,
	spawn_special = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		return
	end,
	spawn_weave_special = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		return
	end,
	spawn_weave_special_event = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		return
	end,
	spawn_at_raw = function (arg_14_0, arg_14_1, arg_14_2)
		-- function 14
		return
	end,
	spawn_patrol = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		return
	end,
	roaming_patrol = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		return
	end,
	spawn_around_player = function (arg_17_0, arg_17_1, arg_17_2)
		-- function 17
		return
	end,
	spawn_around_origin_unit = function (self, arg_18_1, arg_18_2)
		-- function 18
		local breed_spawn_table_per_difficulty = arg_18_1.breed_spawn_table_per_difficulty

		if not breed_spawn_table_per_difficulty then
			local breed_name = arg_18_1.breed_name
			local amount = arg_18_1.amount

			amount = amount or 1

			local difficulty_amount = arg_18_1.difficulty_amount

			if type(breed_name) == "table" then
				breed_name = breed_name[Math.random(1, #breed_name)]
			end

			if not difficulty_amount then
				local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(difficulty_amount)

				get_difficulty_value_from_table = get_difficulty_value_from_table or difficulty_amount.hardest

				if type(get_difficulty_value_from_table) == "table" then
					amount = get_difficulty_value_from_table[Math.random(1, #get_difficulty_value_from_table)]
				else
					amount = get_difficulty_value_from_table
				end
			elseif type(amount) == "table" then
				amount = amount[Math.random(1, #amount)]
			end

			local tbl = {}

			for i = 1, amount do
				tbl[i] = breed_name
			end

			breed_spawn_table_per_difficulty = {
				default = tbl
			}
		end

		local get_difficulty, var_18_7 = Managers.state.difficulty:get_difficulty()
		local var_18_8 = breed_spawn_table_per_difficulty[get_difficulty]

		var_18_8 = var_18_8 or breed_spawn_table_per_difficulty.default

		local count = #var_18_8
		local distance_to_enemies = arg_18_1.distance_to_enemies

		distance_to_enemies = distance_to_enemies or 2

		local tbl_2 = {}

		for j = 1, count do
			local clone

			if not arg_18_1.optional_data then
				clone = table.clone(arg_18_1.optional_data)

				if not clone then
					-- Nothing
				end
			end

			clone = {}

			::label_18_0::

			if not arg_18_1.spawn_counter_category then
				clone = fn(self, clone, arg_18_1.spawn_counter_category)
			end

			local var_18_13 = var_18_8[j]

			if not arg_18_1.pre_spawn_func then
				clone = arg_18_1.pre_spawn_func(clone, get_difficulty, var_18_13, self, var_18_7, arg_18_1.enhancement_list)
			end

			tbl_2[j] = clone
		end

		self.optional_data_table = tbl_2

		local tbl_3 = {}
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local tbl_4 = {}
		local spawn_delay = arg_18_1.spawn_delay

		spawn_delay = spawn_delay or 0
		self.spawn_at = arg_18_2 + spawn_delay
		self.spawn_positions = tbl_4
		self.optional_data_table = tbl_2
		self.spawn_table = var_18_8

		local origin_unit = self.data.origin_unit
		local origin_position = self.data.origin_position

		if not origin_unit and not Unit.alive(origin_unit) then
			origin_position = Unit.local_position(origin_unit, 0)
		elseif not origin_position then
			Application.warning("[TerrorEventMixer] spawn_around_origin_unit present in a terror event that is started without an origin_unit or origin_position, falling back to a random player")

			local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

			origin_position = POSITION_LOOKUP[get_random_alive_hero]
		end

		local row_distance = arg_18_1.row_distance
		local circle_subdivision = arg_18_1.circle_subdivision
		local min_distance = arg_18_1.min_distance
		local max_distance = arg_18_1.max_distance
		local above_max = arg_18_1.above_max
		local below_max = arg_18_1.below_max
		local tries = arg_18_1.tries

		tries = tries or 30

		local check_line_of_sight

		if not origin_unit then
			check_line_of_sight = arg_18_1.check_line_of_sight

			if not check_line_of_sight then
				-- Nothing
			end
		end

		check_line_of_sight = false

		::label_18_1::

		local world = Managers.world:world("level_world")
		local physics_world = World.physics_world(world)

		ConflictUtils.find_positions_around_position(origin_position, tbl_4, nav_world, min_distance, max_distance, count, tbl_3, distance_to_enemies, tries, circle_subdivision, row_distance, above_max, below_max, check_line_of_sight, physics_world, origin_unit)

		self.center_position = Vector3Box(origin_position)

		for k = 1, #tbl_4 do
			local var_18_31 = tbl_4[k]
			local var_18_32 = Vector3Box(var_18_31)

			if not arg_18_1.pre_spawn_unit_func then
				local var_18_33 = var_18_8[k]

				arg_18_1.pre_spawn_unit_func(self, arg_18_1, var_18_32, var_18_33)
			end

			tbl_4[k] = var_18_32
		end

		if not arg_18_1.spawn_failed_func and not table.is_empty(tbl_4) then
			arg_18_1.spawn_failed_func(origin_position)
		end

		return true
	end,
	vs_assign_boss_profile = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		Managers.state.game_mode:game_mode():set_playable_boss_can_be_picked(true)

		if not script_data.debug_playable_boss then
			-- Nothing
		end
	end,
	spawn_around_origin_unit_staggered = function (arg_20_0, arg_20_1, arg_20_2)
		-- function 20
		return TerrorEventMixer_2.init_functions.spawn_around_origin_unit(arg_20_0, arg_20_1, arg_20_2)
	end,
	continue_when = function (self, arg_21_1, arg_21_2)
		-- function 21
		if not arg_21_1.duration then
			self.ends_at = arg_21_2 + ConflictUtils.random_interval(arg_21_1.duration)
		end
	end,
	control_hordes = function (arg_22_0, arg_22_1, arg_22_2)
		-- function 22
		Managers.state.conflict.pacing:enable_hordes(arg_22_1.enable)
	end,
	control_specials = function (arg_23_0, arg_23_1, arg_23_2)
		-- function 23
		local specials_pacing = Managers.state.conflict.specials_pacing

		if not specials_pacing then
			specials_pacing:enable(arg_23_1.enable)

			if not arg_23_1.enable then
				local random = math.random(20, 30)
				local random_2 = math.random(8, 16)
				local time = Managers.time:time("game")

				specials_pacing:delay_spawning(time, random, random_2, true)
			end
		end
	end,
	control_pacing = function (arg_24_0, arg_24_1, arg_24_2)
		-- function 24
		local conflict = Managers.state.conflict

		if not arg_24_1.enable then
			conflict.pacing:enable()
		else
			conflict.pacing:disable()
		end
	end,
	debug_horde = function (self, arg_25_1, arg_25_2)
		-- function 25
		local random_interval

		if not arg_25_1.duration then
			random_interval = ConflictUtils.random_interval(arg_25_1.duration)

			if not random_interval then
				-- Nothing
			end
		end

		random_interval = 0

		::label_25_0::

		self.ends_at = arg_25_2 + random_interval
	end,
	event_horde = function (self, arg_26_1, arg_26_2)
		-- function 26
		local random_interval

		if not arg_26_1.duration then
			random_interval = ConflictUtils.random_interval(arg_26_1.duration)

			if not random_interval then
				-- Nothing
			end
		end

		random_interval = 0

		::label_26_0::

		self.ends_at = arg_26_2 + random_interval

		local conflict = Managers.state.conflict
		local spawner_id = arg_26_1.spawner_id

		spawner_id = spawner_id or arg_26_1.spawner_ids

		local optional_data = arg_26_1.optional_data

		optional_data = not optional_data and table.clone(arg_26_1.optional_data)

		if not arg_26_1.spawn_counter_category then
			optional_data = fn(self, optional_data, arg_26_1.spawn_counter_category)
		end

		local limit_spawner_ids = arg_26_1.limit_spawner_ids

		if not limit_spawner_ids then
			spawner_id = table.clone(arg_26_1.spawner_ids)

			table.shuffle(spawner_id)

			for i = limit_spawner_ids + 1, #spawner_id do
				spawner_id[i] = nil
			end
		end

		arg_26_1.horde_data = conflict:event_horde(arg_26_2, spawner_id, arg_26_1.side_id, arg_26_1.composition_type, arg_26_1.limit_spawners, arg_26_1.horde_silent, nil, arg_26_1.sound_settings, optional_data)
	end,
	ambush_horde = function (self, arg_27_1, arg_27_2)
		-- function 27
		local optional_data = arg_27_1.optional_data

		optional_data = not optional_data and table.clone(arg_27_1.optional_data)

		if not arg_27_1.spawn_counter_category then
			optional_data = fn(self, optional_data, arg_27_1.spawn_counter_category)
		end

		local random_interval

		if not arg_27_1.duration then
			random_interval = ConflictUtils.random_interval(arg_27_1.duration)

			if not random_interval then
				-- Nothing
			end
		end

		random_interval = 0

		::label_27_0::

		self.ends_at = arg_27_2 + random_interval

		local conflict = Managers.state.conflict
		local var_27_3
		local composition_type = arg_27_1.composition_type

		if not self.data and not self.data.main_path_trigger_distance then
			var_27_3 = MainPathUtils.point_on_mainpath(nil, self.data.main_path_trigger_distance)
		end

		local tbl = {
			sound_settings = arg_27_1.sound_settings,
			override_composition_type = composition_type
		}

		arg_27_1.horde_data = conflict.horde_spawner:execute_ambush_horde(tbl, conflict.default_enemy_side_id, false, var_27_3, optional_data)
	end,
	reset_event_horde = function (arg_28_0, arg_28_1, arg_28_2)
		-- function 28
		Managers.state.entity:system("spawner_system"):reset_spawners_with_event_id(arg_28_1.event_id)
	end,
	force_horde = function (self, arg_29_1, arg_29_2)
		-- function 29
		local random_interval

		if not arg_29_1.duration then
			random_interval = ConflictUtils.random_interval(arg_29_1.duration)

			if not random_interval then
				-- Nothing
			end
		end

		random_interval = 0

		::label_29_0::

		self.ends_at = arg_29_2 + random_interval

		local horde_type = arg_29_1.horde_type
		local flag = horde_type == "vector" or horde_type == "ambush" or horde_type == "" or horde_type == "random" or not horde_type

		assert(flag, "Bad terror events element 'horde_type' was set to %s", horde_type)

		if not (horde_type == "" or horde_type ~= "random") then
			horde_type = nil
		end

		local side_id = arg_29_1.side_id
		local var_29_4

		Managers.state.conflict.horde_spawner:horde(horde_type, var_29_4, side_id)
	end,
	start_event = function (arg_30_0, arg_30_1, arg_30_2)
		-- function 30
		print("starting terror event: ", arg_30_1.start_event_name)

		local start_event_list = TerrorEventMixer_2.start_event_list
		local incrementing_id = TerrorEventMixer_2.incrementing_id

		TerrorEventMixer_2.incrementing_id = TerrorEventMixer_2.incrementing_id + 1
		start_event_list[#start_event_list + 1] = {
			name = arg_30_1.start_event_name,
			data = {},
			id = incrementing_id
		}
	end,
	stop_event = function (arg_31_0, arg_31_1, arg_31_2)
		-- function 31
		print("stopping terror event: ", arg_31_1.stop_event_name)

		local find_event = TerrorEventMixer_2.find_event(arg_31_1.stop_event_name)

		if not find_event then
			find_event.destroy = true
		end
	end,
	start_mission = function (arg_32_0, arg_32_1, arg_32_2)
		-- function 32
		local mission_name = arg_32_1.mission_name

		Managers.state.entity:system("mission_system"):request_mission(mission_name)
	end,
	end_mission = function (arg_33_0, arg_33_1, arg_33_2)
		-- function 33
		local mission_name = arg_33_1.mission_name

		Managers.state.entity:system("mission_system"):end_mission(mission_name, true)
	end,
	set_master_event_running = function (arg_34_0, arg_34_1, arg_34_2)
		-- function 34
		Managers.state.conflict:set_master_event_running(arg_34_1.name)
	end,
	stop_master_event = function (arg_35_0, arg_35_1, arg_35_2)
		-- function 35
		Managers.state.conflict:set_master_event_running()
	end,
	flow_event = function (arg_36_0, arg_36_1, arg_36_2)
		-- function 36
		local conflict = Managers.state.conflict
		local flow_event_name = arg_36_1.flow_event_name

		conflict:level_flow_event(flow_event_name)

		local network = Managers.state.network

		if arg_36_1.disable_network_send or not network:game() then
			local var_36_3 = NetworkLookup.terror_flow_events[flow_event_name]

			network.network_transmit:send_rpc_clients("rpc_terror_event_trigger_flow", var_36_3)
		end
	end,
	play_stinger = function (self, arg_37_1, arg_37_2)
		-- function 37
		local stinger_name = arg_37_1.stinger_name

		stinger_name = stinger_name or "enemy_terror_event_stinger"

		local use_origin_unit_position = arg_37_1.use_origin_unit_position
		local origin_unit = self.data.origin_unit
		local optional_pos = arg_37_1.optional_pos

		if optional_pos or not use_origin_unit_position then
			-- Nothing
		end

		::label_37_0::

		optional_pos = Unit.alive(origin_unit)
		optional_pos = not optional_pos and Unit.local_position(origin_unit, 0)

		::label_37_1::

		local _world = Managers.state.conflict._world
		local wwise_world = Managers.world:wwise_world(_world)

		if not optional_pos then
			local var_37_6 = Vector3(optional_pos[1], optional_pos[2], optional_pos[3])

			if not DEDICATED_SERVER then
				WwiseUtils.trigger_position_event(_world, stinger_name, var_37_6)
			end

			local flag

			flag = not optional_pos and "rpc_server_audio_position_event" and "rpc_server_audio_event"

			Managers.state.network.network_transmit:send_rpc_clients(flag, NetworkLookup.sound_events[stinger_name], var_37_6)
		else
			if not DEDICATED_SERVER then
				WwiseWorld.trigger_event(wwise_world, stinger_name)
			end

			Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_event", NetworkLookup.sound_events[stinger_name])
		end
	end,
	force_load_breed_package = function (arg_38_0, arg_38_1, arg_38_2)
		-- function 38
		local enemy_package_loader = Managers.level_transition_handler.enemy_package_loader
		local breed_name = arg_38_1.breed_name

		print("terror_event_mixer->force_load_breed_package, breed_name=", breed_name)

		if not enemy_package_loader:is_breed_processed(breed_name) then
			local flag = true

			enemy_package_loader:request_breed(breed_name, flag)
		end
	end,
	enable_bots_in_carry_event = function (arg_39_0, arg_39_1, arg_39_2)
		-- function 39
		local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

		Managers.state.entity:system("ai_bot_group_system"):set_in_carry_event(true, get_side_from_name)
	end,
	disable_bots_in_carry_event = function (arg_40_0, arg_40_1, arg_40_2)
		-- function 40
		local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

		Managers.state.entity:system("ai_bot_group_system"):set_in_carry_event(false, get_side_from_name)
	end,
	enable_kick = function (arg_41_0, arg_41_1, arg_41_2)
		-- function 41
		Managers.state.voting:set_vote_kick_enabled(true)
	end,
	disable_kick = function (arg_42_0, arg_42_1, arg_42_2)
		-- function 42
		Managers.state.voting:set_vote_kick_enabled(false)
	end,
	set_freeze_condition = function (self, arg_43_1, arg_43_2)
		-- function 43
		local max_active_enemies = arg_43_1.max_active_enemies

		max_active_enemies = max_active_enemies or math.huge
		self.max_active_enemies = max_active_enemies
	end,
	set_breed_event_horde_spawn_limit = function (arg_44_0, arg_44_1, arg_44_2)
		-- function 44
		Managers.state.entity:system("spawner_system"):set_breed_event_horde_spawn_limit(arg_44_1.breed_name, arg_44_1.limit)
	end,
	create_boss_door_group = function (self, arg_45_1, arg_45_2)
		-- function 45
		local data = self.data
		local system = Managers.state.entity:system("ai_group_system")

		data.group_data = {
			template = "boss_door_closers",
			id = system:generate_group_id(),
			size = arg_45_1.group_size
		}
	end,
	close_boss_doors = function (self, arg_46_1, arg_46_2)
		-- function 46
		local data = self.data
		local map_section = data.map_section

		map_section = map_section or arg_46_1.map_section

		local id = data.group_data.id

		if not map_section then
			local breed_name = arg_46_1.breed_name

			Managers.state.entity:system("door_system"):close_boss_doors(map_section, id, breed_name)
		end
	end,
	spawn_encampment = function (self, arg_47_1, arg_47_2)
		-- function 47
		local var_47_0
		local var_47_1
		local var_47_2
		local data = self.data

		if not data.gizmo_unit then
			var_47_0 = data.encampment_id
			var_47_1 = data.unit_compositions_id
			var_47_2 = Unit.local_rotation(data.gizmo_unit, 0)
		else
			var_47_0 = arg_47_1.encampment_id
			var_47_1 = arg_47_1.unit_compositions_id

			local dir = data.dir

			var_47_2 = not dir and Quaternion.look(Vector3(dir[1], dir[2], 0)) and Quaternion.look(Vector3(0, 1, 0))
		end

		local side_id = data.side_id

		if not side_id then
			side_id = arg_47_1.side_id
			side_id = side_id or 2
		end

		local var_47_6
		local optional_pos = data.optional_pos

		if not optional_pos then
			var_47_6 = optional_pos:unbox()
		else
			local optional_pos_2 = arg_47_1.optional_pos

			var_47_6 = Vector3(optional_pos_2[1], optional_pos_2[2], optional_pos_2[3])
		end

		print("encampment_id:", var_47_0, "unit_compositions_id:", var_47_1, data)

		local var_47_9 = EncampmentTemplates[var_47_0]
		local make_encampment = FormationUtils.make_encampment(var_47_9)
		local var_47_11 = var_47_9.unit_compositions[var_47_1]

		FormationUtils.spawn_encampment(make_encampment, var_47_6, var_47_2, var_47_11, side_id)
	end,
	teleport_player = function (arg_48_0, arg_48_1, arg_48_2)
		-- function 48
		local local_player = Managers.player:local_player()

		if not local_player then
			local player_unit = local_player.player_unit

			if not Unit.alive(player_unit) then
				local get_teleporter_portals = ConflictUtils.get_teleporter_portals()
				local portal_id = arg_48_1.portal_id
				local unbox = get_teleporter_portals[portal_id][1]:unbox()
				local unbox_2 = get_teleporter_portals[portal_id][2]:unbox()
				local extension = ScriptUnit.extension(player_unit, "locomotion_system")
				local world = Managers.world:world("level_world")

				LevelHelper:flow_event(world, "teleport_" .. portal_id)
				extension:teleport_to(unbox, unbox_2)
			end
		end
	end,
	run_benchmark_func = function (arg_49_0, arg_49_1, arg_49_2)
		-- function 49
		local func_name = arg_49_1.func_name

		Managers.benchmark[func_name](Managers.benchmark, arg_49_1, arg_49_2)
	end,
	set_time_challenge = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
		-- function 50
		local optional_data = TerrorEventMixer_2.optional_data
		local time_challenge_name = arg_50_1.time_challenge_name
		local num = arg_50_2 + QuestSettings[time_challenge_name]
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		if not (not QuestSettings.allowed_difficulties[time_challenge_name][get_difficulty] and optional_data[time_challenge_name]) then
			optional_data[time_challenge_name] = num
		end
	end,
	has_completed_time_challenge = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
		-- function 51
		local optional_data = TerrorEventMixer_2.optional_data
		local time_challenge_name = arg_51_1.time_challenge_name
		local var_51_2 = optional_data[time_challenge_name]

		if not var_51_2 then
			local flag = arg_51_2 < var_51_2
			local abs = math.abs(arg_51_2 - var_51_2)

			if not flag then
				optional_data[time_challenge_name] = nil

				local var_51_5 = time_challenge_name

				Managers.player:statistics_db():increment_stat_and_sync_to_clients(var_51_5)
			else
				optional_data[time_challenge_name] = nil
			end
		end
	end,
	do_volume_challenge = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
		-- function 52
		local optional_data = TerrorEventMixer_2.optional_data
		local volume_name = arg_52_1.volume_name

		fassert(optional_data[volume_name] == nil, "Already started a volume challenge for volume_name=(%s)", volume_name)

		local challenge_name = arg_52_1.challenge_name
		local var_52_3 = QuestSettings[challenge_name]
		local flag = not QuestSettings.allowed_difficulties[challenge_name][Managers.state.difficulty:get_difficulty()]

		optional_data[volume_name] = {
			time_inside = 0,
			duration = var_52_3,
			player_units = {},
			terminate = flag
		}
	end,
	increase_weave_progress = function (self, arg_53_1, arg_53_2, arg_53_3)
		-- function 53
		if not Managers.weave:get_active_weave() then
			return
		end

		local amount = arg_53_1.amount

		fassert(amount ~= nil, string.format("'amount' in 'increase_weave_progress' event in terror event '%s' is not defined", self.name))
		Managers.weave:increase_bar_score(amount)
	end,
	complete_weave = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
		-- function 54
		local weave = Managers.weave

		if not weave:get_active_weave() then
			return
		end

		weave:final_objective_completed()
		Managers.state.game_mode:complete_level()
	end,
	activate_mutator = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
		-- function 55
		return
	end,
	set_wwise_override_state = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
		-- function 56
		return
	end,
	freeze_story_trigger = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
		-- function 57
		return
	end,
	continue_when_spawned_count = function (self, arg_58_1, arg_58_2, arg_58_3)
		-- function 58
		if not arg_58_1.duration then
			self.ends_at = arg_58_2 + ConflictUtils.random_interval(arg_58_1.duration)
		end
	end,
	run_func = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
		-- function 59
		return
	end
}
TerrorEventMixer_2.run_functions = {
	vs_assign_boss_profile = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
		-- function 60
		return
	end,
	spawn = function (self, arg_61_1, arg_61_2, arg_61_3)
		-- function 61
		local data = self.data
		local optional_data = arg_61_1.optional_data

		optional_data = not optional_data and table.clone(arg_61_1.optional_data)

		local gizmo_unit = data.gizmo_unit

		if not gizmo_unit then
			local get_data = Unit.get_data(gizmo_unit, "is_behind_door")

			if not get_data then
				optional_data = optional_data or {}
				optional_data.spawn_behind_door = get_data
			end
		end

		if not arg_61_1.spawn_counter_category then
			optional_data = fn(self, optional_data, arg_61_1.spawn_counter_category)
		end

		local unbox

		if not data.optional_pos then
			unbox = data.optional_pos:unbox()

			if not unbox then
				-- Nothing
			end
		end

		unbox = data.origin_position
		unbox = not unbox and data.origin_position:unbox()

		::label_61_0::

		local conflict = Managers.state.conflict
		local group_data = data.group_data
		local breed_name = arg_61_1.breed_name

		if type(breed_name) == "table" then
			breed_name = breed_name[Math.random(1, #breed_name)]
		end

		if not arg_61_1.pre_spawn_func then
			local get_difficulty, var_61_9 = Managers.state.difficulty:get_difficulty()

			optional_data = arg_61_1.pre_spawn_func(optional_data, get_difficulty, breed_name, self, var_61_9, arg_61_1.enhancement_list)
		end

		conflict:spawn_one(Breeds[breed_name], unbox, group_data, optional_data)

		return true
	end,
	spawn_special = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		-- function 62
		local var_62_0
		local breed_name = arg_62_1.breed_name
		local amount = arg_62_1.amount

		amount = amount or 1

		local difficulty_amount = arg_62_1.difficulty_amount
		local optional_data = arg_62_1.optional_data

		optional_data = not optional_data and table.clone(arg_62_1.optional_data)

		if not arg_62_1.spawn_counter_category then
			optional_data = fn(arg_62_0, optional_data, arg_62_1.spawn_counter_category)
		end

		local conflict = Managers.state.conflict

		if not difficulty_amount then
			local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(difficulty_amount)

			get_difficulty_value_from_table = get_difficulty_value_from_table or difficulty_amount.hardest

			if type(get_difficulty_value_from_table) == "table" then
				amount = get_difficulty_value_from_table[Math.random(1, #get_difficulty_value_from_table)]
			else
				amount = get_difficulty_value_from_table
			end
		elseif type(amount) == "table" then
			amount = amount[Math.random(1, #amount)]
		end

		if type(breed_name) == "table" then
			var_62_0 = breed_name[Math.random(1, #breed_name)]
		else
			var_62_0 = breed_name
		end

		for i = 1, amount do
			local get_special_spawn_pos = conflict.specials_pacing:get_special_spawn_pos()

			conflict:spawn_one(Breeds[var_62_0], get_special_spawn_pos, nil, optional_data)
		end

		return true
	end,
	spawn_weave_special = function (self, arg_63_1, arg_63_2, arg_63_3)
		-- function 63
		local breed_name = arg_63_1.breed_name
		local amount = arg_63_1.amount

		amount = amount or 1

		local conflict = Managers.state.conflict
		local data = self.data
		local main_path_trigger_distance = data.main_path_trigger_distance
		local optional_data = arg_63_1.optional_data

		optional_data = not optional_data and table.clone(arg_63_1.optional_data)

		if not arg_63_1.spawn_counter_category then
			optional_data = fn(self, optional_data, arg_63_1.spawn_counter_category)
		end

		for i = 1, amount do
			local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, main_path_trigger_distance)
			local get_hidden_spawn_pos_from_position_seeded = Managers.weave:weave_spawner():get_hidden_spawn_pos_from_position_seeded(point_on_mainpath)
			local var_63_8

			if type(breed_name) == "table" then
				local next_random, var_63_10 = Math.next_random(data.seed, 1, #breed_name)

				var_63_8 = breed_name[var_63_10]
				data.seed = next_random
			else
				var_63_8 = breed_name
			end

			conflict:spawn_one(Breeds[var_63_8], get_hidden_spawn_pos_from_position_seeded, nil, optional_data)
		end

		return true
	end,
	spawn_weave_special_event = function (self, arg_64_1, arg_64_2, arg_64_3)
		-- function 64
		local var_64_0
		local breed_name = arg_64_1.breed_name
		local amount = arg_64_1.amount

		amount = amount or 1

		local difficulty_amount = arg_64_1.difficulty_amount
		local optional_data = arg_64_1.optional_data

		optional_data = not optional_data and table.clone(arg_64_1.optional_data)

		if not arg_64_1.spawn_counter_category then
			optional_data = fn(self, optional_data, arg_64_1.spawn_counter_category)
		end

		local data = self.data
		local seed = data.seed
		local conflict = Managers.state.conflict

		if not difficulty_amount then
			local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(difficulty_amount)

			get_difficulty_value_from_table = get_difficulty_value_from_table or difficulty_amount.hardest

			if type(get_difficulty_value_from_table) == "table" then
				local var_64_9
				local var_64_10

				seed, var_64_10 = Math.next_random(seed, 1, #get_difficulty_value_from_table)
				amount = get_difficulty_value_from_table[var_64_10]
			else
				amount = get_difficulty_value_from_table
			end
		elseif type(amount) == "table" then
			local var_64_11
			local var_64_12

			seed, var_64_12 = Math.next_random(seed, 1, #amount)
			amount = amount[var_64_12]
		end

		if type(breed_name) == "table" then
			local var_64_13
			local var_64_14

			seed, var_64_14 = Math.next_random(seed, 1, #breed_name)
			var_64_0 = breed_name[var_64_14]
		else
			var_64_0 = breed_name
		end

		for i = 1, amount do
			local get_special_spawn_pos = conflict.specials_pacing:get_special_spawn_pos()

			conflict:spawn_one(Breeds[var_64_0], get_special_spawn_pos, nil, optional_data)
		end

		data.seed = seed

		return true
	end,
	spawn_at_raw = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
		-- function 65
		if not Managers.player.is_server then
			local var_65_0
			local breed_name = arg_65_1.breed_name
			local amount = arg_65_1.amount

			amount = amount or 1

			local difficulty_amount = arg_65_1.difficulty_amount
			local optional_data = arg_65_1.optional_data

			optional_data = not optional_data and table.clone(arg_65_1.optional_data)

			if not arg_65_1.spawn_counter_category then
				optional_data = fn(arg_65_0, optional_data, arg_65_1.spawn_counter_category)
			end

			if not difficulty_amount then
				local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(difficulty_amount)

				get_difficulty_value_from_table = get_difficulty_value_from_table or difficulty_amount.hardest

				if type(get_difficulty_value_from_table) == "table" then
					amount = get_difficulty_value_from_table[Math.random(1, #get_difficulty_value_from_table)]
				else
					amount = get_difficulty_value_from_table
				end
			elseif type(amount) == "table" then
				amount = amount[Math.random(1, #amount)]
			end

			if type(breed_name) == "table" then
				var_65_0 = breed_name[Math.random(1, #breed_name)]
			else
				var_65_0 = breed_name
			end

			if not arg_65_1.pre_spawn_func then
				local get_difficulty, var_65_7 = Managers.state.difficulty:get_difficulty()

				optional_data = arg_65_1.pre_spawn_func(optional_data, get_difficulty, var_65_0, arg_65_0, var_65_7, arg_65_1.enhancement_list)
			end

			local conflict = Managers.state.conflict

			for i = 1, amount do
				local var_65_9

				if not arg_65_1.spawner_ids then
					local spawner_ids = arg_65_1.spawner_ids

					var_65_9 = spawner_ids[Math.random(1, #spawner_ids)]
				else
					var_65_9 = arg_65_1.spawner_id
				end

				conflict:spawn_at_raw_spawner(Breeds[var_65_0], var_65_9, optional_data, arg_65_1.side_id)
			end
		end

		return true
	end,
	spawn_patrol = function (self, arg_66_1, arg_66_2, arg_66_3)
		-- function 66
		local data = self.data

		if not data then
			-- Nothing
		end

		::label_66_0::

		local optional_pos = data.optional_pos

		optional_pos = not optional_pos and data.optional_pos:unbox()

		::label_66_1::

		local conflict = Managers.state.conflict
		local patrol_template = arg_66_1.patrol_template
		local main_path_patrol = arg_66_1.main_path_patrol
		local tbl = {}

		if not main_path_patrol then
			tbl.breed = Breeds[arg_66_1.breed_name]
			tbl.group_type = "main_path_patrol"
			tbl.side_id = arg_66_1.side_id

			local side_id = arg_66_1.side_id

			conflict:spawn_group(patrol_template, optional_pos, tbl)
		else
			local formations

			if not data then
				formations = data.formations

				if not formations then
					-- Nothing
				end
			end

			formations = arg_66_1.formations

			::label_66_2::

			local count = #formations
			local random

			if count > 1 then
				random = math.random(count)

				if not random then
					-- Nothing
				end
			end

			random = 1

			::label_66_3::

			local var_66_10 = formations[random]

			assert(PatrolFormationSettings[var_66_10], "No such formation exists in PatrolFormationSettings")

			local var_66_11
			local splines = arg_66_1.splines

			if not splines then
				local count_2 = #splines
				local random_2

				if count_2 > 1 then
					random_2 = math.random(count_2)

					if not random_2 then
						-- Nothing
					end
				end

				random_2 = 1

				::label_66_4::

				var_66_11 = splines[random_2]
			else
				var_66_11 = not data and data.spline_id
			end

			local var_66_15
			local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(PatrolFormationSettings[var_66_10])
			local one_directional = data.one_directional

			get_difficulty_value_from_table.settings = PatrolFormationSettings[var_66_10].settings

			local flag = not data and data.spline_way_points

			if not flag then
				local get_waypoint_spline, var_66_20, var_66_21, var_66_22 = conflict.level_analysis:get_waypoint_spline(var_66_11)

				if not get_waypoint_spline then
					flag = var_66_20
					var_66_15 = var_66_21
					one_directional = var_66_22
				end
			end

			local spline_type

			if not data then
				spline_type = data.spline_type

				if not spline_type then
					-- Nothing
				end
			end

			spline_type = arg_66_1.spline_type

			::label_66_5::

			tbl.spline_name = var_66_11
			tbl.formation = get_difficulty_value_from_table
			tbl.group_type = "spline_patrol"
			tbl.spline_way_points = flag
			tbl.spline_type = spline_type
			tbl.despawn_at_end = one_directional
			tbl.spawn_all_at_same_position = true

			conflict:spawn_spline_group(patrol_template, var_66_15, tbl)
		end

		return true
	end,
	roaming_patrol = function (self, arg_67_1, arg_67_2, arg_67_3)
		-- function 67
		local data = self.data
		local optional_pos = data.optional_pos

		optional_pos = not optional_pos and data.optional_pos:unbox()

		local conflict = Managers.state.conflict
		local patrol_template = arg_67_1.patrol_template

		patrol_template = patrol_template or "spline_patrol"

		local tbl = {}
		local spline_name = data.spline_name
		local pack = data.pack

		tbl.formation, tbl.spline_name = PatrolFormationSettings.random_roaming_formation(pack), spline_name
		tbl.group_type = "roaming_patrol"
		tbl.spline_way_points = data.spline_way_points
		tbl.spline_type = data.spline_type
		tbl.despawn_at_end = false
		tbl.zone_data = data.zone_data
		tbl.spawn_all_at_same_position = false

		conflict:spawn_spline_group(patrol_template, optional_pos, tbl)

		return true
	end,
	spawn_around_player = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
		-- function 68
		local var_68_0
		local breed_name = arg_68_1.breed_name
		local amount = arg_68_1.amount

		amount = amount or 1

		local difficulty_amount = arg_68_1.difficulty_amount

		if type(breed_name) == "table" then
			var_68_0 = breed_name[Math.random(1, #breed_name)]
		else
			var_68_0 = breed_name
		end

		if not difficulty_amount then
			local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(difficulty_amount)

			get_difficulty_value_from_table = get_difficulty_value_from_table or difficulty_amount.hardest

			if type(get_difficulty_value_from_table) == "table" then
				amount = get_difficulty_value_from_table[Math.random(1, #get_difficulty_value_from_table)]
			else
				amount = get_difficulty_value_from_table
			end
		elseif type(amount) == "table" then
			amount = amount[Math.random(1, #amount)]
		end

		local optional_data = arg_68_1.optional_data

		optional_data = not optional_data and table.clone(arg_68_1.optional_data)

		if not arg_68_1.spawn_counter_category then
			optional_data = fn(arg_68_0, optional_data, arg_68_1.spawn_counter_category)
		end

		local PLAYER_AND_BOT_POSITIONS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_POSITIONS
		local distance_to_players = arg_68_1.distance_to_players

		distance_to_players = distance_to_players or 2

		local distance_to_enemies = arg_68_1.distance_to_enemies

		distance_to_enemies = distance_to_enemies or 2

		local function fn_2(arg_69_0, arg_69_1)
			-- function 69
			local pow = math.pow(distance_to_players, 2)

			for i = 1, #PLAYER_AND_BOT_POSITIONS do
				if pow > Vector3.distance_squared(arg_69_0, PLAYER_AND_BOT_POSITIONS[i]) then
					return false
				end
			end

			local pow_2 = math.pow(distance_to_enemies, 2)

			for j = 1, #arg_69_1 do
				if pow_2 > Vector3.distance_squared(arg_69_0, arg_69_1[j]) then
					return false
				end
			end

			return true
		end

		if not arg_68_1.pre_spawn_func then
			local get_difficulty, var_68_11 = Managers.state.difficulty:get_difficulty()

			optional_data = arg_68_1.pre_spawn_func(optional_data, get_difficulty, var_68_0, arg_68_0, var_68_11, arg_68_1.enhancement_list)
		end

		local tbl = {}
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local conflict = Managers.state.conflict

		for i = 1, amount do
			local get_random_alive_hero = PlayerUtils.get_random_alive_hero()
			local var_68_16 = POSITION_LOOKUP[get_random_alive_hero]
			local spawn_distance = arg_68_1.spawn_distance

			spawn_distance = spawn_distance or 10

			local spread = arg_68_1.spread

			spread = spread or 10

			local get_spawn_pos_on_circle_with_func = ConflictUtils.get_spawn_pos_on_circle_with_func(nav_world, var_68_16, spawn_distance, spread, 30, fn_2, tbl)

			if not get_spawn_pos_on_circle_with_func then
				table.insert(tbl, get_spawn_pos_on_circle_with_func)
				conflict:spawn_one(Breeds[var_68_0], get_spawn_pos_on_circle_with_func, nil, optional_data)
			end
		end

		return true
	end,
	spawn_around_origin_unit = function (self, arg_70_1, arg_70_2, arg_70_3)
		-- function 70
		if arg_70_2 > self.spawn_at then
			local conflict = Managers.state.conflict
			local spawn_table = self.spawn_table
			local optional_data_table = self.optional_data_table
			local spawn_positions = self.spawn_positions
			local var_70_4

			if not arg_70_1.group_template then
				var_70_4 = {
					id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
					size = #spawn_positions,
					template = arg_70_1.group_template
				}
			end

			local unbox = self.center_position:unbox()

			for i = 1, #spawn_positions do
				local var_70_6 = spawn_positions[i]
				local unbox_2 = var_70_6:unbox()
				local var_70_8 = spawn_table[i]
				local var_70_9 = Breeds[var_70_8]
				local var_70_10 = optional_data_table[i]
				local var_70_11

				if not arg_70_1.face_unit then
					local num = unbox - unbox_2

					var_70_11 = Quaternion.look(num, Vector3.up())
				end

				if not arg_70_1.face_nearest_player_of_side then
					local get_side_from_name = Managers.state.side:get_side_from_name(arg_70_1.face_nearest_player_of_side)
					local PLAYER_AND_BOT_POSITIONS = get_side_from_name.PLAYER_AND_BOT_POSITIONS
					local PLAYER_AND_BOT_UNITS = get_side_from_name.PLAYER_AND_BOT_UNITS

					if not #PLAYER_AND_BOT_POSITIONS then
						local huge = math.huge
						local var_70_17

						for j = 1, #PLAYER_AND_BOT_POSITIONS do
							local var_70_18 = PLAYER_AND_BOT_POSITIONS[j]
							local length_squared = Vector3.length_squared(unbox_2 - var_70_18)
							local var_70_20 = PLAYER_AND_BOT_UNITS[j]

							if not (not ALIVE[var_70_20] and ScriptUnit.extension(var_70_20, "status_system"):is_invisible() or not (length_squared < huge)) then
								var_70_17 = var_70_18
							end
						end

						if not var_70_17 then
							local num_2 = var_70_17 - unbox_2

							var_70_11 = Quaternion.look(num_2, Vector3.up())
						end
					end
				end

				var_70_11 = var_70_11 or Quaternion.identity()

				conflict:spawn_one(var_70_9, unbox_2, var_70_4, var_70_10, var_70_11)

				if not arg_70_1.post_spawn_unit_func then
					arg_70_1.post_spawn_unit_func(self, arg_70_1, var_70_6)
				end
			end

			self.spawn_positions = nil

			return true
		end

		return false
	end,
	spawn_around_origin_unit_staggered = function (self, arg_71_1, arg_71_2, arg_71_3)
		-- function 71
		if not (not (arg_71_2 >= self.spawn_at) or not self.next_spawn_t or not (arg_71_2 >= self.next_spawn_t)) then
			local conflict = Managers.state.conflict
			local spawn_table = self.spawn_table
			local optional_data_table = self.optional_data_table
			local spawn_positions = self.spawn_positions
			local group_data = self.group_data

			if not (not arg_71_1.group_template and group_data) then
				group_data = {
					id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
					size = #spawn_positions,
					template = arg_71_1.group_template
				}
				self.group_data = group_data
			end

			local unbox = self.center_position:unbox()
			local count = #spawn_positions
			local num

			if not self.num_spawned then
				num = self.num_spawned + 1

				if not num then
					-- Nothing
				end
			end

			num = 1

			::label_71_0::

			local random = Math.random(arg_71_1.staggered_spawn_batch_size[1], arg_71_1.staggered_spawn_batch_size[2])
			local min = math.min(num + random, count)

			for i = num, min do
				local var_71_10 = spawn_positions[i]
				local unbox_2 = var_71_10:unbox()
				local var_71_12 = spawn_table[i]
				local var_71_13 = Breeds[var_71_12]
				local var_71_14 = optional_data_table[i]
				local var_71_15

				if not arg_71_1.face_unit then
					local num_2 = unbox - unbox_2

					var_71_15 = Quaternion.look(num_2, Vector3.up())
				end

				conflict:spawn_one(var_71_13, unbox_2, group_data, var_71_14, var_71_15)

				if not arg_71_1.post_spawn_unit_func then
					arg_71_1.post_spawn_unit_func(self, arg_71_1, var_71_10)
				end
			end

			if min <= num then
				self.next_spawn_t = nil
				self.num_spawned = nil
				self.spawn_positions = nil

				return true
			end

			self.num_spawned = min

			local var_71_17 = arg_71_1.staggered_spawn_delay[1]
			local num_3 = arg_71_1.staggered_spawn_delay[2] - var_71_17

			self.next_spawn_t = arg_71_2 + math.random() * num_3 + var_71_17
		end

		return false
	end,
	continue_when = function (self, arg_72_1, arg_72_2, arg_72_3)
		-- function 72
		if not (not arg_72_1.duration and not (arg_72_2 > self.ends_at)) then
			return true
		end

		return arg_72_1.condition(arg_72_2)
	end,
	control_pacing = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
		-- function 73
		return true
	end,
	control_specials = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
		-- function 74
		return true
	end,
	control_hordes = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
		-- function 75
		return true
	end,
	event_horde = function (self, arg_76_1, arg_76_2, arg_76_3)
		-- function 76
		if arg_76_2 > self.ends_at then
			return true
		end
	end,
	ambush_horde = function (self, arg_77_1, arg_77_2, arg_77_3)
		-- function 77
		if arg_77_2 > self.ends_at then
			return true
		end
	end,
	reset_event_horde = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
		-- function 78
		return true
	end,
	force_horde = function (self, arg_79_1, arg_79_2, arg_79_3)
		-- function 79
		if arg_79_2 > self.ends_at then
			return true
		end
	end,
	debug_horde = function (self, arg_80_1, arg_80_2, arg_80_3)
		-- function 80
		if arg_80_2 > self.ends_at then
			return true
		end

		local conflict = Managers.state.conflict

		if #conflict:spawned_enemies() < arg_80_1.amount then
			local var_80_1 = Managers.state.side:get_side(conflict.default_hero_side_id).PLAYER_AND_BOT_POSITIONS[1]
			local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(conflict.nav_world, var_80_1, 25, 15, 5)

			if not get_spawn_pos_on_circle then
				local num = var_80_1 - get_spawn_pos_on_circle
				local look = Quaternion.look(Vector3(num.x, num.y, 1))
				local Breeds = Breeds
				local _debug_breed = conflict._debug_breed

				_debug_breed = _debug_breed or "skaven_slave"

				local var_80_7 = Breeds[_debug_breed]
				local var_80_8

				conflict:spawn_queued_unit(var_80_7, Vector3Box(get_spawn_pos_on_circle), QuaternionBox(look), "constant_70", nil, "horde_hidden", var_80_8)
			end
		end
	end,
	delay = function (self, arg_81_1, arg_81_2, arg_81_3)
		-- function 81
		if arg_81_2 > self.ends_at then
			return true
		end
	end,
	text = function (self, arg_82_1, arg_82_2, arg_82_3)
		-- function 82
		if self.ends_at - arg_82_2 >= 0 then
			Debug.text(tostring(arg_82_1.text))
		else
			return true
		end
	end,
	start_event = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
		-- function 83
		return true
	end,
	stop_event = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
		-- function 84
		return true
	end,
	start_mission = function (arg_85_0, arg_85_1, arg_85_2)
		-- function 85
		return true
	end,
	end_mission = function (arg_86_0, arg_86_1, arg_86_2)
		-- function 86
		return true
	end,
	flow_event = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
		-- function 87
		return true
	end,
	play_stinger = function (arg_88_0, arg_88_1, arg_88_2)
		-- function 88
		return true
	end,
	force_load_breed_package = function (arg_89_0, arg_89_1, arg_89_2)
		-- function 89
		return true
	end,
	set_master_event_running = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
		-- function 90
		return true
	end,
	stop_master_event = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
		-- function 91
		return true
	end,
	enable_bots_in_carry_event = function (arg_92_0, arg_92_1, arg_92_2)
		-- function 92
		return true
	end,
	disable_bots_in_carry_event = function (arg_93_0, arg_93_1, arg_93_2)
		-- function 93
		return true
	end,
	enable_kick = function (arg_94_0, arg_94_1, arg_94_2)
		-- function 94
		return true
	end,
	disable_kick = function (arg_95_0, arg_95_1, arg_95_2)
		-- function 95
		return true
	end,
	set_freeze_condition = function (arg_96_0, arg_96_1, arg_96_2)
		-- function 96
		return true
	end,
	set_breed_event_horde_spawn_limit = function (arg_97_0, arg_97_1, arg_97_2)
		-- function 97
		return true
	end,
	create_boss_door_group = function (arg_98_0, arg_98_1, arg_98_2)
		-- function 98
		return true
	end,
	close_boss_doors = function (arg_99_0, arg_99_1, arg_99_2)
		-- function 99
		return true
	end,
	spawn_encampment = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3)
		-- function 100
		return true
	end,
	teleport_player = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3)
		-- function 101
		return true
	end,
	run_benchmark_func = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3)
		-- function 102
		return true
	end,
	set_time_challenge = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3)
		-- function 103
		return true
	end,
	has_completed_time_challenge = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
		-- function 104
		return true
	end,
	do_volume_challenge = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3)
		-- function 105
		local volume_name = arg_105_1.volume_name
		local var_105_1 = TerrorEventMixer_2.optional_data[volume_name]

		if not var_105_1.terminate then
			return true
		end

		local player_units = var_105_1.player_units
		local flag = true
		local human_players = Managers.player:human_players()

		for k, v in pairs(human_players) do
			local player_unit = v.player_unit

			if not HEALTH_ALIVE[player_unit] then
				flag = false

				break
			end

			player_units[#player_units + 1] = player_unit
		end

		if not flag then
			local system = Managers.state.entity:system("volume_system")

			flag = EngineOptimizedExtensions.volume_has_all_units_inside(system._volume_system, volume_name, unpack(player_units))
		end

		table.clear(player_units)

		if not flag then
			var_105_1.time_inside = var_105_1.time_inside + arg_105_3
		else
			var_105_1.time_inside = 0
		end

		if var_105_1.time_inside >= var_105_1.duration then
			local increment_stat_name = arg_105_1.increment_stat_name

			Managers.player:statistics_db():increment_stat_and_sync_to_clients(increment_stat_name)

			return true
		else
			return false
		end
	end,
	increase_weave_progress = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3)
		-- function 106
		return true
	end,
	complete_weave = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3)
		-- function 107
		return true
	end,
	activate_mutator = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3)
		-- function 108
		local name = arg_108_1.name

		if not Managers.state.game_mode then
			local _mutator_handler = Managers.state.game_mode._mutator_handler

			if not _mutator_handler:has_activated_mutator(name) then
				_mutator_handler:initialize_mutators({
					name
				})
				_mutator_handler:activate_mutator(name)
			end
		end

		return true
	end,
	set_wwise_override_state = function (arg_109_0, arg_109_1, arg_109_2, arg_109_3)
		-- function 109
		local name = arg_109_1.name

		Managers.music:set_music_group_state("combat_music", "override", name)

		return true
	end,
	freeze_story_trigger = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3)
		-- function 110
		local freeze = arg_110_1.freeze
		local system = Managers.state.entity:system("dialogue_system")

		if not freeze then
			system:freeze_story_trigger()
		else
			system:unfreeze_story_trigger()
		end

		return true
	end,
	continue_when_spawned_count = function (self, arg_111_1, arg_111_2, arg_111_3)
		-- function 111
		if not (not arg_111_1.duration and not (arg_111_2 > self.ends_at)) then
			return true
		end

		local data = self.data
		local spawn_counter = self.data.spawn_counter

		spawn_counter = spawn_counter or create_spawn_counter()
		data.spawn_counter = spawn_counter

		return not arg_111_1.condition and arg_111_1.condition(self.data.spawn_counter)
	end,
	run_func = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3)
		-- function 112
		arg_112_1.func()

		return true
	end
}
TerrorEventMixer_2.debug_functions = {
	vs_assign_boss_profile = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3)
		-- function 113
		return "vs_assign_boss_profile"
	end,
	control_pacing = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3)
		-- function 114
		local flag

		flag = not arg_114_1.enable and "enable" and "disable"

		return flag
	end,
	control_specials = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3)
		-- function 115
		local flag

		flag = not arg_115_1.enable and "enable" and "disable"

		return flag
	end,
	delay = function (arg_116_0, arg_116_1, arg_116_2, arg_116_3)
		-- function 116
		return
	end,
	set_freeze_condition = function (self, arg_117_1, arg_117_2, arg_117_3)
		-- function 117
		return string.format(": max enemies %d", self.max_active_enemies)
	end,
	debug_horde = function (arg_118_0, arg_118_1, arg_118_2, arg_118_3)
		-- function 118
		local count = #Managers.state.conflict:spawned_enemies()

		return string.format(" alive: %d, max-amount: %d", count, arg_118_1.amount)
	end,
	event_horde = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3)
		-- function 119
		local horde_data = arg_119_1.horde_data

		if not horde_data then
			if not horde_data.started then
				if not horde_data.failed then
					return string.format(" horde failed!")
				else
					return string.format(" amount: %d ", horde_data.amount)
				end
			else
				return "waiting to start..."
			end
		else
			return string.format("waiting to start...")
		end
	end,
	ambush_horde = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3)
		-- function 120
		local horde_data = arg_120_1.horde_data

		if not horde_data then
			if not horde_data.started then
				if not horde_data.failed then
					return string.format(" horde failed!")
				else
					return string.format(" amount: %d ", horde_data.amount)
				end
			else
				return "waiting to start..."
			end
		else
			return string.format("waiting to start...")
		end
	end,
	reset_event_horde = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3)
		-- function 121
		return string.format(arg_121_1.event_id)
	end,
	force_horde = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3)
		-- function 122
		return string.format(arg_122_1.horde_type)
	end,
	spawn = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3)
		-- function 123
		return arg_123_1.breed_name
	end,
	spawn_at_raw = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3)
		-- function 124
		local var_124_0

		if type(arg_124_1.breed_name) == "table" then
			var_124_0 = table.dump_string(arg_124_1.breed_name)
		else
			var_124_0 = arg_124_1.breed_name
		end

		local spawner_id = arg_124_1.spawner_id

		spawner_id = spawner_id or table.tostring(arg_124_1.spawner_ids)

		return spawner_id .. " -> " .. var_124_0
	end,
	spawn_patrol = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3)
		-- function 125
		return arg_125_1.breed_name
	end,
	roaming_patrol = function (arg_126_0, arg_126_1, arg_126_2, arg_126_3)
		-- function 126
		return "roaming_patrol"
	end,
	start_event = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3)
		-- function 127
		return "event_name: " .. arg_127_1.start_event_name
	end,
	stop_event = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3)
		-- function 128
		return "event_name: " .. arg_128_1.stop_event_name
	end,
	start_mission = function (arg_129_0, arg_129_1, arg_129_2)
		-- function 129
		return "mission_name: " .. arg_129_1.mission_name
	end,
	end_mission = function (arg_130_0, arg_130_1, arg_130_2)
		-- function 130
		return "mission_name: " .. arg_130_1.mission_name
	end,
	flow_event = function (arg_131_0, arg_131_1, arg_131_2, arg_131_3)
		-- function 131
		return "event_name: " .. tostring(arg_131_1.flow_event_name)
	end,
	set_master_event_running = function (arg_132_0, arg_132_1, arg_132_2, arg_132_3)
		-- function 132
		return "name: " .. arg_132_1.name
	end,
	play_stinger = function (arg_133_0, arg_133_1, arg_133_2)
		-- function 133
		local optional_pos = arg_133_1.optional_pos

		if not optional_pos then
			return string.format(" stinger-name: %s, pos: (%.1f,%.1f,%.1f) ", arg_133_1.stinger_name, optional_pos[1], optional_pos[2], optional_pos[3])
		else
			return " stinger-name:" .. arg_133_1.stinger_name
		end
	end,
	force_load_breed_package = function (arg_134_0, arg_134_1, arg_134_2, arg_134_3)
		-- function 134
		return "breed_name: " .. arg_134_1.breed_name
	end,
	stop_master_event = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3)
		-- function 135
		return ""
	end,
	spawn_encampment = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3)
		-- function 136
		return ""
	end,
	teleport_player = function (arg_137_0, arg_137_1, arg_137_2, arg_137_3)
		-- function 137
		return "teleport to portal_id:" .. arg_137_1.portal_id
	end,
	run_benchmark_func = function (arg_138_0, arg_138_1, arg_138_2, arg_138_3)
		-- function 138
		return "func_name:" .. arg_138_1.func_name
	end,
	set_time_challenge = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3)
		-- function 139
		return "Time challenge started "
	end,
	do_volume_challenge = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3)
		-- function 140
		local volume_name = arg_140_1.volume_name
		local var_140_1 = TerrorEventMixer_2.optional_data[volume_name]
		local time_inside = var_140_1.time_inside
		local duration = var_140_1.duration
		local num = time_inside / duration

		return string.format("%.2f/%.2f - %.2f", time_inside, duration, num)
	end,
	activate_mutator = function (arg_141_0, arg_141_1, arg_141_2, arg_141_3)
		-- function 141
		return arg_141_1.name
	end,
	set_wwise_override_state = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3)
		-- function 142
		return arg_142_1.name
	end,
	freeze_story_trigger = function (arg_143_0, arg_143_1, arg_143_2, arg_143_3)
		-- function 143
		return arg_143_1.freeze
	end
}

TerrorEventMixer_2.reset = function ()
	-- function 144
	table.clear(TerrorEventMixer_2.active_events)
	table.clear(TerrorEventMixer_2.start_event_list)
	table.clear(TerrorEventMixer_2.finished_events)
	table.clear(TerrorEventMixer_2.optional_data)
end

TerrorEventMixer_2.add_to_start_event_list = function (arg_145_0, arg_145_1, arg_145_2, arg_145_3)
	-- function 145
	local start_event_list = TerrorEventMixer_2.start_event_list
	local incrementing_id = TerrorEventMixer_2.incrementing_id

	TerrorEventMixer_2.incrementing_id = TerrorEventMixer_2.incrementing_id + 1
	start_event_list[#start_event_list + 1] = {
		name = arg_145_0,
		data = {
			seed = arg_145_1,
			origin_unit = arg_145_2,
			origin_position = arg_145_3
		},
		id = incrementing_id
	}

	return incrementing_id
end

TerrorEventMixer_2.start_random_event = function (arg_146_0)
	-- function 146
	local level_transition_handler = Managers.level_transition_handler

	if not level_transition_handler:needs_level_load() then
		print("TerrorEventMixer.start_random_event:", arg_146_0, " ignored because game is transitioning away.")

		return
	end

	local get_current_level_keys = level_transition_handler:get_current_level_keys()
	local var_146_2 = WeightedRandomTerrorEvents[get_current_level_keys][arg_146_0]

	fassert(var_146_2, "Cannot find a WeightedRandomTerrorEvent called %s", tostring(arg_146_0))

	local var_146_3 = var_146_2[LoadedDice.roll_easy(var_146_2.loaded_probability_table) * 2 - 1]
	local add_to_start_event_list = TerrorEventMixer_2.add_to_start_event_list(var_146_3)

	print("TerrorEventMixer.start_random_event:", arg_146_0, "->", var_146_3)

	return add_to_start_event_list
end

local function fn_2(self, arg_147_1)
	-- function 147
	local active_tags = arg_147_1.active_tags
	local factions = arg_147_1.factions
	local current_difficulty = arg_147_1.current_difficulty
	local current_difficulty_tweak = arg_147_1.current_difficulty_tweak

	if not (not self.minimum_difficulty_tweak and not (current_difficulty_tweak < self.minimum_difficulty_tweak)) then
		return false
	end

	if not self.difficulty_requirement then
		if current_difficulty < self.difficulty_requirement then
			return false
		end
	elseif not (not self.only_on_difficulty and current_difficulty == self.only_on_difficulty) then
		return false
	end

	if not factions and not self.faction_requirement then
		local faction_requirement = self.faction_requirement

		if not table.contains(factions, faction_requirement) then
			return false
		end
	end

	if not factions and not self.faction_requirement_list then
		local faction_requirement_list = self.faction_requirement_list

		for i, v in ipairs(faction_requirement_list) do
			if not table.contains(factions, v) then
				return false
			end
		end
	end

	if not self.tag_requirement_list then
		local tag_requirement_list = self.tag_requirement_list

		for i_2, v_2 in ipairs(tag_requirement_list) do
			if not (not active_tags and table.contains(active_tags, v_2)) then
				return false
			end
		end
	end

	return true
end

local var_0_8

local function fn_3(self, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
	-- function 148
	if self[1] == "inject_event" then
		local var_148_0

		if not self.event_name_list then
			local next_random, var_148_2 = Math.next_random(arg_148_1.seed, 1, #self.event_name_list)

			var_148_0 = self.event_name_list[var_148_2]
			arg_148_1.seed = next_random
		elseif not self.weighted_event_names then
			local num = 0

			for i, v in ipairs(self.weighted_event_names) do
				num = num + v.weight
			end

			local next_random_2, var_148_5 = Math.next_random(arg_148_1.seed, 0, num)

			arg_148_1.seed = next_random_2

			local num_2 = 0

			for i_2, v_2 in ipairs(self.weighted_event_names) do
				num_2 = num_2 + v_2.weight

				if var_148_5 <= num_2 then
					var_148_0 = v_2.event_name

					break
				end
			end

			if var_148_0 == nil then
				assert(false, "Failed getting a random weighted element.")
			end
		else
			var_148_0 = self.event_name
		end

		var_0_8(arg_148_2, arg_148_1, arg_148_4 + 1, var_148_0)
	elseif self[1] == "one_of" then
		for i_3, v_3 in ipairs(self[2]) do
			if not fn_2(v_3, arg_148_1) then
				fn_3(v_3, arg_148_1, arg_148_2, arg_148_3, arg_148_4)

				break
			end
		end
	else
		self.base_event_name = arg_148_3
		arg_148_2[#arg_148_2 + 1] = self
	end
end

local num = 10

function var_0_8(arg_149_0, arg_149_1, arg_149_2, arg_149_3)
	-- function 149
	fassert(arg_149_2 < num, "Injecting terror events lead to high level of recursion, please check if there is a possible loop, or increase MAX_INJECTION_DEPTH.")

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local var_149_1 = TerrorEventBlueprints[get_current_level_keys][arg_149_3]

	var_149_1 = var_149_1 or GenericTerrorEvents[arg_149_3]

	fassert(var_149_1, "No terror event called '%s', exists. Make sure it is added to level %s, or generic, terror event file if its supposed to be there.", arg_149_3, get_current_level_keys)

	for i, v in ipairs(var_149_1) do
		if not fn_2(v, arg_149_1) then
			fn_3(v, arg_149_1, arg_149_0, arg_149_3, arg_149_2)
		end
	end

	return arg_149_0
end

local function fn_4(self, arg_150_1)
	-- function 150
	local get_terror_event_tags = Managers.state.game_mode._mutator_handler:get_terror_event_tags()
	local conflict = Managers.state.conflict
	local factions = ConflictDirectors[conflict.initial_conflict_settings].factions
	local get_difficulty_rank, var_150_4 = Managers.state.difficulty:get_difficulty_rank()

	self.current_difficulty = get_difficulty_rank
	self.current_difficulty_tweak = var_150_4
	self.factions = factions
	self.active_tags = get_terror_event_tags

	local var_150_5 = var_0_8({}, self, 0, arg_150_1)

	if not script_data.debug_terror then
		print("process_terror_event: " .. table.tostring(var_150_5))
	end

	return var_150_5
end

TerrorEventMixer_2.start_event = function (arg_151_0, arg_151_1, arg_151_2)
	-- function 151
	if script_data.only_allowed_terror_event == arg_151_0 or not script_data.ai_terror_events_disabled then
		return
	end

	if not arg_151_1 then
		local seed = arg_151_1.seed

		seed = seed or 0
		arg_151_1.seed = seed
	else
		arg_151_1 = {
			seed = 0
		}
	end

	local next_random, var_151_2 = Math.next_random(arg_151_1.seed)

	arg_151_1.seed = next_random

	print(string.format("TerrorEventMixer.start_event: %s (seed: %d)", arg_151_0, arg_151_1.seed))

	local active_events = TerrorEventMixer_2.active_events
	local var_151_4 = fn_4(arg_151_1, arg_151_0)

	Managers.state.game_mode:post_process_terror_event(var_151_4)

	if not arg_151_2 then
		arg_151_2 = TerrorEventMixer_2.incrementing_id
		TerrorEventMixer_2.incrementing_id = TerrorEventMixer_2.incrementing_id + 1
	end

	if #var_151_4 > 0 then
		local tbl = {
			index = 1,
			ends_at = 0,
			name = arg_151_0,
			elements = var_151_4,
			data = arg_151_1,
			max_active_enemies = math.huge,
			id = arg_151_2
		}

		active_events[#active_events + 1] = tbl

		local var_151_6 = var_151_4[1]
		local var_151_7 = var_151_6[1]
		local time = Managers.time:time("game")

		TerrorEventMixer_2.init_functions[var_151_7](tbl, var_151_6, time)
	end

	Managers.telemetry_events:terror_event_started(arg_151_0)
end

TerrorEventMixer_2.stop_event = function (arg_152_0)
	-- function 152
	print("TerrorEventMixer.stop_event:", arg_152_0)

	local active_events = TerrorEventMixer_2.active_events
	local count = #active_events

	for i = 1, count do
		local var_152_2 = active_events[i]

		if var_152_2.name == arg_152_0 then
			table.remove(active_events, i)
			table.insert(TerrorEventMixer_2.finished_events, var_152_2.name)

			if i <= TerrorEventMixer_2.active_event_i then
				TerrorEventMixer_2.active_event_i = TerrorEventMixer_2.active_event_i - 1
			end

			break
		end
	end
end

TerrorEventMixer_2.find_event = function (arg_153_0)
	-- function 153
	local active_events = TerrorEventMixer_2.active_events
	local count = #active_events

	for i = 1, count do
		local var_153_2 = active_events[i]

		if var_153_2.name == arg_153_0 then
			return var_153_2
		end
	end
end

TerrorEventMixer_2.is_event_id_active_or_pending = function (arg_154_0)
	-- function 154
	local active_events = TerrorEventMixer_2.active_events
	local count = #active_events

	for i = 1, count do
		if active_events[i].id == arg_154_0 then
			return true
		end
	end

	local start_event_list = TerrorEventMixer_2.start_event_list
	local count_2 = #start_event_list

	for j = 1, count_2 do
		if start_event_list[j].id == arg_154_0 then
			return true
		end
	end

	return false
end

TerrorEventMixer_2.update = function (arg_155_0, arg_155_1, arg_155_2)
	-- function 155
	local active_events = TerrorEventMixer_2.active_events

	TerrorEventMixer_2.active_event_i = 1

	while TerrorEventMixer_2.active_event_i <= #active_events do
		local var_155_1 = active_events[TerrorEventMixer_2.active_event_i]

		if not TerrorEventMixer_2.run_event(var_155_1, arg_155_0, arg_155_1) and not TerrorEventMixer_2.find_event(var_155_1.name) then
			table.remove(active_events, TerrorEventMixer_2.active_event_i)
			table.insert(TerrorEventMixer_2.finished_events, var_155_1.name)
		else
			TerrorEventMixer_2.active_event_i = TerrorEventMixer_2.active_event_i + 1
		end
	end

	TerrorEventMixer_2.active_event_i = -1

	local start_event_list = TerrorEventMixer_2.start_event_list

	for i = 1, #start_event_list do
		local var_155_3 = start_event_list[i]
		local name = var_155_3.name
		local data = var_155_3.data
		local id = var_155_3.id

		TerrorEventMixer_2.start_event(name, data, id)

		start_event_list[i] = nil
	end

	if not script_data.debug_terror and not arg_155_2 then
		TerrorEventMixer_2.debug(arg_155_2, active_events, arg_155_0, arg_155_1)
	end
end

TerrorEventMixer_2.run_event = function (self, arg_156_1, arg_156_2)
	-- function 156
	local elements = self.elements
	local index = self.index
	local var_156_2 = elements[index]

	if Managers.state.performance:num_active_enemies() > self.max_active_enemies then
		local ends_at = var_156_2.ends_at

		ends_at = ends_at or 0
		var_156_2.ends_at = ends_at + arg_156_2
	else
		local var_156_4 = var_156_2[1]
		local composition_type

		if not var_156_2 then
			composition_type = var_156_2.composition_type

			if not composition_type then
				-- Nothing
			end
		end

		composition_type = var_156_2.breed_name

		::label_156_0::

		if not script_data.debug_terror and not composition_type then
			printf("[Terror event] Started terror even function: %s with %s", var_156_4, composition_type)
		end

		if not TerrorEventMixer_2.run_functions[var_156_4](self, var_156_2, arg_156_1, arg_156_2) then
			if not self.destroy then
				return true
			end

			local num = index + 1

			if num > #elements then
				return true
			end

			self.index = num

			local var_156_7 = elements[num]
			local var_156_8 = var_156_7[1]

			TerrorEventMixer_2.init_functions[var_156_8](self, var_156_7, arg_156_1)
		end
	end
end

local num_2 = 12
local str = "arial"
local str_2 = "materials/fonts/" .. str
local resolution, var_0_16 = Application.resolution()
local num_3 = 400
local num_4 = 0

TerrorEventMixer_2.debug = function (arg_157_0, arg_157_1, arg_157_2, arg_157_3)
	-- function 157
	if not DebugKeyHandler.key_pressed("mouse_middle_held", "pan terror event mixer", "ai debugger") then
		local get = Managers.free_flight.input_manager:get_service("Debug"):get("look")

		num_4 = num_4 - get.x * 0.001
	end

	local num = 0
	local num_2 = 0

	for i = 1, #arg_157_1 do
		local var_157_3 = arg_157_1[i]

		if not var_157_3 then
			TerrorEventMixer_2.debug_event(arg_157_0, var_157_3, arg_157_2, arg_157_3, num, num_2, num_4 * resolution, i == 1)

			num = num + num_3 + 15
		end
	end

	for k, v in pairs(TerrorEventMixer_2.optional_data) do
		if type(v) == "number" then
			local abs = math.abs(arg_157_2 - v)

			Debug.text("Time challenge running: %s Time left: %0.1f ", k, abs)
		end
	end
end

TerrorEventMixer_2.debug_event = function (arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4, arg_158_5, arg_158_6, arg_158_7)
	-- function 158
	local elements = arg_158_1.elements
	local index = arg_158_1.index
	local var_158_2 = elements[index][1]
	local num = 20 + arg_158_6
	local num_4 = 280

	arg_158_4 = arg_158_4 + num + 20
	arg_158_5 = arg_158_5 + num_4 + 40

	local var_158_5 = arg_158_5
	local num_5 = 200
	local get_color_with_alpha = Colors.get_color_with_alpha("gray", 255)
	local get_color_with_alpha_2 = Colors.get_color_with_alpha("cyan", 255)
	local get_color_with_alpha_3 = Colors.get_color_with_alpha("lavender", 255)
	local get_color_with_alpha_4 = Colors.get_color_with_alpha("cadet_blue", 255)
	local get_color_with_alpha_5 = Colors.get_color_with_alpha("orange", 255)

	ScriptGUI.ictext(arg_158_0, resolution, var_0_16, "Event: " .. arg_158_1.name, str_2, num_2, str, arg_158_4 - 10, var_158_5, num_5, get_color_with_alpha_5)

	local num_6 = var_158_5 + 20

	if not arg_158_1.data.spawn_counter then
		for k, v in pairs(arg_158_1.data.spawn_counter) do
			local format = string.format("#%s:%d", k, v)

			ScriptGUI.ictext(arg_158_0, resolution, var_0_16, format, str_2, num_2, str, arg_158_4, num_6, num_5, get_color_with_alpha_4)

			num_6 = num_6 + 20
		end
	end

	local num_7 = 1

	if index > 9 then
		num_7 = index - 9
	end

	local count = #elements

	if count - num_7 > 18 then
		count = num_7 + 18
	end

	for k_2 = num_7, index - 1 do
		local var_158_16 = elements[k_2]
		local var_158_17 = var_158_16[1]
		local base_event_name = var_158_16.base_event_name
		local var_158_19

		if not TerrorEventMixer_2.debug_functions[var_158_17] then
			var_158_19 = TerrorEventMixer_2.debug_functions[var_158_17](arg_158_1, var_158_16, arg_158_2, arg_158_3)

			if not var_158_19 then
				-- Nothing
			end
		end

		var_158_19 = ""

		::label_158_0::

		local format_2 = string.format(" %d] %s: %s %s", k_2, base_event_name, var_158_17, var_158_19)

		ScriptGUI.ictext(arg_158_0, resolution, var_0_16, format_2, str_2, num_2, str, arg_158_4, num_6, num_5, get_color_with_alpha)

		num_6 = num_6 + 20
	end

	local num_active_enemies = Managers.state.performance:num_active_enemies()
	local var_158_22

	if num_active_enemies > arg_158_1.max_active_enemies then
		var_158_22 = true
	end

	local var_158_23 = elements[index]
	local var_158_24 = var_158_23[1]
	local base_event_name_2 = var_158_23.base_event_name
	local var_158_26

	if not TerrorEventMixer_2.debug_functions[var_158_24] then
		var_158_26 = TerrorEventMixer_2.debug_functions[var_158_24](arg_158_1, var_158_23, arg_158_2, arg_158_3)

		if not var_158_26 then
			-- Nothing
		end
	end

	var_158_26 = ""

	do
		local format_3
	end

	::label_158_1::

	if not var_158_23.duration then
		format_3 = string.format("time: %.1f", arg_158_1.ends_at - arg_158_2)

		if not format_3 then
			-- Nothing
		end
	end

	format_3 = ""

	::label_158_2::

	local var_158_28

	if not var_158_22 then
		var_158_28 = string.format(" %d] %s: %s %s %s FROZEN: %d / %d", index, base_event_name_2, var_158_24, var_158_26, format_3, num_active_enemies, arg_158_1.max_active_enemies)
	else
		var_158_28 = string.format(" %d] %s: %s %s %s", index, base_event_name_2, var_158_24, var_158_26, format_3)
	end

	ScriptGUI.ictext(arg_158_0, resolution, var_0_16, "==>", str_2, num_2, str, arg_158_4 - 20, num_6, num_5, not var_158_22 and get_color_with_alpha_2 and get_color_with_alpha_3)
	ScriptGUI.ictext(arg_158_0, resolution, var_0_16, var_158_28, str_2, num_2, str, arg_158_4, num_6, num_5, not var_158_22 and get_color_with_alpha_2 and get_color_with_alpha_3)

	local num_8 = num_6 + 20

	for l = index + 1, count do
		local var_158_30 = elements[l]
		local var_158_31 = var_158_30[1]
		local base_event_name_3 = var_158_30.base_event_name
		local str_3 = ""
		local format_4 = string.format(" %d] %s: %s %s", l, base_event_name_3, var_158_31, str_3)

		ScriptGUI.ictext(arg_158_0, resolution, var_0_16, format_4, str_2, num_2, str, arg_158_4, num_8, num_5, get_color_with_alpha_4)

		num_8 = num_8 + 20
	end

	ScriptGUI.icrect(arg_158_0, resolution, var_0_16, num, num_4, arg_158_4 + num_3, num_8, num_5 - 1, Color(200, 20, 20, 20))

	if not arg_158_7 then
		local get_color_with_alpha_6 = Colors.get_color_with_alpha("red", 255)
		local get_color_with_alpha_7 = Colors.get_color_with_alpha("lawn_green", 255)
		local running_master_event = Managers.state.conflict.running_master_event

		if not running_master_event then
			ScriptGUI.ictext(arg_158_0, resolution, var_0_16, "Master Event: ", str_2, num_2, str, arg_158_4 - 10, num_4 - 6, num_5, get_color_with_alpha_5)
			ScriptGUI.ictext(arg_158_0, resolution, var_0_16, running_master_event, str_2, num_2, str, arg_158_4 - 10 + 100, num_4 - 6, num_5, get_color_with_alpha_7)
		else
			ScriptGUI.ictext(arg_158_0, resolution, var_0_16, "Master Event: ", str_2, num_2, str, arg_158_4 - 10, num_4 - 6, num_5, get_color_with_alpha_5)
			ScriptGUI.ictext(arg_158_0, resolution, var_0_16, "disabled", str_2, num_2, str, arg_158_4 - 10 + 75, num_4 - 6, num_5, get_color_with_alpha_6)
		end

		ScriptGUI.ictext(arg_158_0, resolution, var_0_16, string.format("Active enemies: %d / %d", num_active_enemies, arg_158_1.max_active_enemies), str_2, num_2, str, arg_158_4 - 10, num_4 + 12, num_5, not var_158_22 and get_color_with_alpha_6 and get_color_with_alpha_7)
		ScriptGUI.icrect(arg_158_0, resolution, var_0_16, num, num_4 - 22, arg_158_4 + num_3, num_4, num_5 - 1, Color(200, 20, 20, 20))
	end
end

local var_0_19
local str_3 = "\n"

for k, v in pairs(TerrorEventBlueprints) do
	for k_2 = 1, #v do
		local var_0_21 = v[k_2][1]

		if not TerrorEventMixer_2.init_functions[var_0_21] then
			str_3 = str_3 .. string.format("Bad terror event: '%s', there is no element called '%s'. \n", tostring(k), tostring(var_0_21))
			var_0_19 = true
		end
	end
end

if not var_0_19 then
	assert(false, str_3)
end
