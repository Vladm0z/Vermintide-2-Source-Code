-- chunkname: @scripts/managers/conflict_director/horde_spawner.lua

HordeSpawner = class(HordeSpawner)

local tbl = {
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{}
}
local tbl_2 = {
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{}
}
local count = #tbl
local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}

HordeSpawner.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.cover_broadphase = arg_1_2
	self.hordes = {}
	self.lookup_horde = {}
	self.conflict_director = Managers.state.conflict
	self.spawner_system = Managers.state.entity:system("spawner_system")
	self.num_paced_hordes = 0
	self.world = arg_1_1
	self.physics_world = World.physics_world(arg_1_1)
end

local function fn(self, arg_2_1)
	-- function 2
	local count = #self

	self[arg_2_1] = self[count]
	self[count] = nil
end

local function fn_2(self, arg_3_1)
	-- function 3
	local count = #self
	local count_2 = #arg_3_1

	for i = 1, count do
		arg_3_1[i] = self[i]
	end

	for j = count + 1, count_2 do
		arg_3_1[j] = nil
	end
end

HordeSpawner.horde = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	print("horde requested: ", arg_4_1)

	if arg_4_1 == "vector" then
		self:execute_vector_horde(arg_4_2, arg_4_3, arg_4_4)
	elseif arg_4_1 == "vector_blob" then
		self:execute_vector_blob_horde(arg_4_2, arg_4_3, arg_4_4)
	else
		self:execute_ambush_horde(arg_4_2, arg_4_3, arg_4_4, nil, arg_4_5)
	end
end

HordeSpawner.execute_fallback = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if not arg_5_3 then
		if not script_data.debug_player_intensity then
			self.conflict_director.pacing:annotate_graph("Failed horde fb", "red")
		end

		print("Failed to start horde, all fallbacks failed at this place")

		return
	end

	print(arg_5_4)

	if arg_5_1 == "ambush" then
		self:execute_vector_horde(arg_5_5, arg_5_2, "fallback")
	elseif arg_5_1 == "vector" then
		self:execute_ambush_horde(arg_5_5, arg_5_2, "fallback")
	end
end

HordeSpawner._add_horde = function (self, arg_6_1)
	-- function 6
	local hordes = self.hordes

	hordes[#hordes + 1] = arg_6_1

	if not Managers.state.conflict:is_horde_alive() then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("horde")
	end
end

HordeSpawner.execute_event_horde = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12)
	-- function 7
	local _execute_event_horde = self:_execute_event_horde(arg_7_1, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12)

	if type(arg_7_2) == "string" then
		_execute_event_horde.terror_event_ids = {
			arg_7_2
		}
	elseif type(arg_7_2) == "table" then
		_execute_event_horde.terror_event_ids = arg_7_2
	end

	self:_add_horde(_execute_event_horde)

	return _execute_event_horde
end

HordeSpawner._execute_event_horde = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11)
	-- function 8
	local var_8_0

	fassert(arg_8_2, "Missing side id in event horde")

	if not HordeCompositions[arg_8_3] then
		local get_difficulty_rank, var_8_2 = Managers.state.difficulty:get_difficulty_rank()
		local num = DifficultyTweak.converters.composition_rank(get_difficulty_rank, var_8_2) - 1

		var_8_0 = CurrentHordeSettings.compositions[arg_8_3][num]
	elseif not HordeCompositionsPacing[arg_8_3] then
		var_8_0 = CurrentHordeSettings.compositions_pacing[arg_8_3]
	end

	local var_8_4 = var_8_0[LoadedDice.roll_easy(var_8_0.loaded_probs)]
	local str = "event"
	local flag = arg_8_8 or var_8_0.sound_settings
	local tbl = {
		composition_type = arg_8_3,
		limit_spawners = arg_8_4
	}
	local start_time = var_8_0.start_time

	start_time = start_time or 4
	tbl.start_time = arg_8_1 + start_time

	local start_time_2 = var_8_0.start_time

	start_time_2 = start_time_2 or 4

	local num_2 = arg_8_1 + start_time_2
	local end_time = var_8_0.end_time

	end_time = end_time or 20
	tbl.end_time = num_2 + end_time
	tbl.horde_type = str
	tbl.silent = arg_8_5
	tbl.group_template = arg_8_6
	tbl.group_id = not arg_8_6 and arg_8_6.id
	tbl.strictly = arg_8_7
	tbl.use_closest_spawners = arg_8_9
	tbl.variant = var_8_4
	tbl.source_unit = arg_8_10
	tbl.sound_settings = flag
	tbl.side_id = arg_8_2
	tbl.optional_data = arg_8_11

	return tbl
end

HordeSpawner.max_composition_size = function (arg_9_0, arg_9_1)
	-- function 9
	local num = 0
	local var_9_1 = CurrentHordeSettings.compositions[arg_9_1]

	for i = 1, #var_9_1 do
		local breeds = var_9_1[i].breeds
		local num_2 = 0

		for j = 1, #breeds, 2 do
			local var_9_4 = breeds[i]
			local var_9_5 = breeds[i + 1]
			local max

			if type(var_9_5) == "table" then
				max = math.max(var_9_5[1], var_9_5[2])

				if not max then
					-- Nothing
				end
			end

			max = var_9_5

			::label_9_0::

			num_2 = num_2 + max
		end

		if num < num_2 then
			num = num_2
		end
	end

	return num
end

HordeSpawner.running_horde = function (self)
	-- function 10
	return self._running_horde_type, self._running_horde_sound_settings
end

function random_array_insert(self, arg_11_1, arg_11_2)
	-- function 11
	local random = math.random(1, arg_11_1)

	self[random], self[arg_11_1 + 1] = arg_11_2, self[random]
end

local tbl_6 = {
	skaven_clan_rat = true,
	skaven_slave = true
}
local tbl_7 = {}
local tbl_8 = {}

HordeSpawner.compose_horde_spawn_list = function (arg_12_0, arg_12_1)
	-- function 12
	local num = 1

	table.clear_array(tbl_7, #tbl_7)
	table.clear_array(tbl_8, #tbl_8)

	local breeds = arg_12_1.breeds

	for i = 1, #breeds, 2 do
		local var_12_2 = breeds[i]
		local var_12_3 = breeds[i + 1]
		local random_interval = ConflictUtils.random_interval(var_12_3)

		if not script_data.big_hordes then
			local round = math.round
			local var_12_6 = tonumber(script_data.big_hordes)

			var_12_6 = var_12_6 or 1
			random_interval = round(random_interval * var_12_6)
		end

		local var_12_7

		if not tbl_6[var_12_2] then
			var_12_7 = tbl_7

			if not var_12_7 then
				-- Nothing
			end
		end

		var_12_7 = tbl_8

		::label_12_0::

		local count = #var_12_7

		for j = count + 1, count + random_interval do
			var_12_7[j] = var_12_2
		end
	end

	table.shuffle(tbl_7)
	table.shuffle(tbl_8)

	local count_2 = #tbl_7
	local count_3 = #tbl_8

	return count_2 + count_3, count_2, count_3
end

HordeSpawner.compose_blob_horde_spawn_list = function (arg_13_0, arg_13_1)
	-- function 13
	local var_13_0 = CurrentHordeSettings.compositions_pacing[arg_13_1]
	local var_13_1 = var_13_0[LoadedDice.roll_easy(var_13_0.loaded_probs)]
	local num = 1
	local var_13_3 = tbl_7

	table.clear_array(tbl_7, #tbl_7)

	local breeds = var_13_1.breeds

	for i = 1, #breeds, 2 do
		local var_13_5 = breeds[i]
		local var_13_6 = breeds[i + 1]
		local random_interval = ConflictUtils.random_interval(var_13_6)

		if not script_data.big_hordes then
			local round = math.round
			local var_13_9 = tonumber(script_data.big_hordes)

			var_13_9 = var_13_9 or 1
			random_interval = round(random_interval * var_13_9)
		end

		local num_2 = #var_13_3 + 1

		for j = num_2, num_2 + random_interval do
			var_13_3[j] = var_13_5
		end
	end

	table.shuffle(var_13_3)

	return var_13_3, #var_13_3
end

local function fn_3(self)
	-- function 14
	local count = #self

	if count > 0 then
		local var_14_1 = self[count]

		self[count] = nil

		return var_14_1
	end
end

local flag = false

HordeSpawner.pop_random_any_breed = function (arg_15_0)
	-- function 15
	flag = not flag

	local var_15_0

	if not flag then
		var_15_0 = fn_3(tbl_7) or fn_3(tbl_8)
	else
		var_15_0 = fn_3(tbl_8) or fn_3(tbl_7)
	end

	return var_15_0
end

HordeSpawner.pop_random_horde_breed_only = function (arg_16_0)
	-- function 16
	return (fn_3(tbl_7))
end

HordeSpawner.execute_ambush_horde = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	print("setting up ambush-horde")

	local ambush = CurrentHordeSettings.ambush
	local min_spawners = ambush.min_spawners
	local max_spawners = ambush.max_spawners
	local min_horde_spawner_dist = ambush.min_horde_spawner_dist
	local max_horde_spawner_dist = ambush.max_horde_spawner_dist
	local min_hidden_spawner_dist = ambush.min_hidden_spawner_dist
	local max_hidden_spawner_dist = ambush.max_hidden_spawner_dist
	local start_delay = ambush.start_delay
	local var_17_8
	local var_17_9
	local flag = not arg_17_1 and arg_17_1.override_composition_type
	local get_difficulty_rank, var_17_12 = Managers.state.difficulty:get_difficulty_rank()

	if not flag and not CurrentHordeSettings.compositions[flag] then
		var_17_9 = CurrentHordeSettings.compositions[flag][DifficultyTweak.converters.composition_rank(get_difficulty_rank, var_17_12) - 1]

		fassert(var_17_9.loaded_probs, " Ambush horde %s is missing loaded probabilty table!", flag)

		var_17_8 = flag
	else
		local var_17_13
		local flag_2 = not arg_17_1 and arg_17_1.optional_wave_composition

		if not flag_2 then
			local var_17_15 = HordeWaveCompositions[flag_2]

			var_17_13 = var_17_15[math.random(#var_17_15)]
		else
			var_17_13 = CurrentHordeSettings.vector_composition or "medium"
		end

		var_17_8 = flag or var_17_13

		fassert(var_17_8, "Ambush Horde missing composition_type")
	end

	local flag_3 = var_17_9 or CurrentHordeSettings.compositions_pacing[var_17_8]
	local var_17_17 = flag_3[LoadedDice.roll_easy(flag_3.loaded_probs)]

	print("Composing horde '" .. var_17_8 .. "' .. using variant '" .. var_17_17.name .. "'")

	local ENEMY_PLAYER_AND_BOT_POSITIONS = Managers.state.side:get_side(arg_17_2).ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_17_19
	local var_17_20
	local var_17_21
	local var_17_22
	local var_17_23

	if not arg_17_4 then
		var_17_23 = arg_17_4
		var_17_22 = arg_17_4
	else
		local cluster_positions, var_17_25 = ConflictUtils.cluster_positions(ENEMY_PLAYER_AND_BOT_POSITIONS, 7)
		local var_17_26 = var_17_25

		var_17_23 = cluster_positions[ConflictUtils.get_biggest_cluster(var_17_26)]
		var_17_22 = var_17_23
	end

	if not var_17_22 then
		print("Failed ambush horde, cant suitable epicenter position. ")

		return
	end

	local enabled_spawners = self.spawner_system:enabled_spawners()
	local hidden_spawners_lookup = self.spawner_system:hidden_spawners_lookup()
	local filter_horde_spawners, var_17_30 = ConflictUtils.filter_horde_spawners(ENEMY_PLAYER_AND_BOT_POSITIONS, enabled_spawners, hidden_spawners_lookup, min_horde_spawner_dist, max_horde_spawner_dist)

	self:reset_sectors(tbl)
	self:calc_sectors(var_17_22, filter_horde_spawners, tbl)

	if not script_data.debug_hordes then
		self:render_sectors(tbl)
	end

	local count_2 = #filter_horde_spawners
	local count_3 = #var_17_30

	table.clear_array(tbl_3, #tbl_3)
	self:hidden_cover_points(self.cover_broadphase, var_17_22, ENEMY_PLAYER_AND_BOT_POSITIONS, tbl_3, min_hidden_spawner_dist, max_hidden_spawner_dist)
	self:reset_sectors(tbl_2)
	self:calc_sectors(var_17_22, tbl_3, tbl_2)

	if not script_data.debug_hordes then
		self:render_sectors(tbl_2)
	end

	if min_spawners >= #tbl_3 + count_2 then
		if not (count_3 <= 0) or not var_17_17.must_use_hidden_spawners then
			self:execute_fallback("ambush", arg_17_2, arg_17_3, "ambush horde failed to find any kind of hidden spawners for their none-horde compatable units, starts a vector-horde instead", arg_17_1)
		else
			self:execute_fallback("ambush", arg_17_2, arg_17_3, "ambush horde failed to find spawners, starts a vector-horde instead", arg_17_1)
		end

		return
	end

	local compose_horde_spawn_list = self:compose_horde_spawn_list(var_17_17)

	print("-> spawning:", compose_horde_spawn_list)

	local generate_group_id = Managers.state.entity:system("ai_group_system"):generate_group_id()
	local tbl_4 = {
		template = "horde",
		id = generate_group_id,
		size = compose_horde_spawn_list,
		group_data = arg_17_1
	}
	local time = Managers.time:time("game")
	local sound_settings

	if not arg_17_1 then
		sound_settings = arg_17_1.sound_settings

		if not sound_settings then
			-- Nothing
		end
	end

	sound_settings = flag_3.sound_settings

	::label_17_0::

	local tbl_5 = {
		horde_type = "ambush",
		spawned = 0,
		num_to_spawn = compose_horde_spawn_list,
		main_target_pos = Vector3Box(var_17_23),
		start_time = time + start_delay,
		group_template = tbl_4,
		sound_settings = sound_settings,
		group_id = generate_group_id,
		side_id = arg_17_2,
		optional_data = arg_17_5
	}

	print("horde crated with id", generate_group_id, "of type ", tbl_5.horde_type)

	if #filter_horde_spawners > 0 then
		tbl_5.horde_spawns = {}
	end

	if #tbl_3 > 0 then
		tbl_5.cover_spawns = {}
	end

	if compose_horde_spawn_list < max_spawners then
		local var_17_39 = compose_horde_spawn_list
	end

	local num = 0
	local num_2 = -1
	local num_3 = 1
	local num_4 = 0

	while not (num_2 == num or not (num < compose_horde_spawn_list)) do
		num_2 = num

		local num_5 = time - 0.05

		for i = 1, count do
			local var_17_45 = tbl[i][num_3]

			if not var_17_45 then
				local var_17_46 = hidden_spawners_lookup[var_17_45]
				local pop_random_any_breed

				if not var_17_46 then
					pop_random_any_breed = self:pop_random_any_breed()

					if not pop_random_any_breed then
						-- Nothing
					end
				end

				pop_random_any_breed = self:pop_random_horde_breed_only()

				::label_17_1::

				if not pop_random_any_breed then
					tbl_5.horde_spawns[#tbl_5.horde_spawns + 1] = {
						num_to_spawn = 1,
						spawner = var_17_45,
						spawn_list = {
							pop_random_any_breed
						},
						hidden = var_17_46
					}
					num = num + 1
				end
			end

			local var_17_48 = tbl_2[i][num_3]

			if not var_17_48 then
				local pop_random_any_breed_2 = self:pop_random_any_breed()

				if not pop_random_any_breed_2 then
					tbl_5.cover_spawns[#tbl_5.cover_spawns + 1] = {
						num_to_spawn = 1,
						next_spawn_time = num_5,
						cover_point_unit = var_17_48,
						spawn_list = {
							pop_random_any_breed_2
						}
					}
					num = num + 1
					num_5 = num_5 + 0.1
				end
			end
		end

		num_3 = num_3 + 1
		num_4 = num_4 + 1

		if num_4 > 1000 then
			self:execute_fallback("ambush", arg_17_3, "Ambush horde spawn failed A - no matching spawners found!", arg_17_1)

			return
		end
	end

	if num < compose_horde_spawn_list then
		local num_6 = compose_horde_spawn_list - num
		local num_7 = 1
		local count_4

		if not tbl_5.horde_spawns then
			count_4 = #tbl_5.horde_spawns

			if not count_4 then
				-- Nothing
			end
		end

		count_4 = 0

		do
			local count_5
		end

		::label_17_2::

		if not tbl_5.cover_spawns then
			count_5 = #tbl_5.cover_spawns

			if not count_5 then
				-- Nothing
			end
		end

		count_5 = 0

		::label_17_3::

		local num_8 = 1
		local num_9 = 0

		while num_6 > 0 do
			local var_17_56
			local var_17_57

			if count_4 > 0 then
				local var_17_58 = tbl_5.horde_spawns[num_7]
				local pop_random_any_breed_3

				if not var_17_58.hidden then
					pop_random_any_breed_3 = self:pop_random_any_breed()

					if not pop_random_any_breed_3 then
						-- Nothing
					end
				end

				pop_random_any_breed_3 = self:pop_random_horde_breed_only()

				::label_17_4::

				if not pop_random_any_breed_3 then
					var_17_58.num_to_spawn = var_17_58.num_to_spawn + 1
					var_17_58.spawn_list[#var_17_58.spawn_list + 1] = pop_random_any_breed_3
					num_7 = num_7 % count_4 + 1
					num_6 = num_6 - 1

					if num_6 <= 0 then
						break
					end
				else
					num_7 = num_7 % count_4 + 1
				end
			end

			if count_5 > 0 then
				local pop_random_any_breed_4 = self:pop_random_any_breed()

				if not pop_random_any_breed_4 then
					local var_17_61 = tbl_5.cover_spawns[num_8]

					num_8 = num_8 % count_5 + 1
					var_17_61.num_to_spawn = var_17_61.num_to_spawn + 1
					var_17_61.spawn_list[#var_17_61.spawn_list + 1] = pop_random_any_breed_4
					num_6 = num_6 - 1

					if num_6 <= 0 then
						break
					end
				end
			end

			num_9 = num_9 + 1

			if num_9 > 1000 then
				self:execute_fallback("ambush", arg_17_2, arg_17_3, "Ambush horde spawn failed B - no matching spawners found!", arg_17_1)

				return
			end
		end
	end

	if not script_data.debug_player_intensity then
		self.conflict_director.pacing:annotate_graph("(A)Horde:" .. compose_horde_spawn_list, "lime")
	end

	self:_add_horde(tbl_5)

	self.last_paced_horde_type = "ambush"
	self.num_paced_hordes = self.num_paced_hordes + 1

	print("ambush horde has started")
end

HordeSpawner.replace_hidden_spawners = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if not arg_18_2.dont_move then
		return
	end

	local local_position = Unit.local_position(arg_18_2.cover_point_unit, 0)
	local num = 10
	local num_2 = 20
	local var_18_3 = arg_18_3
	local var_18_4 = tbl_3

	table.clear_array(var_18_4, #var_18_4)
	self:hidden_cover_points(self.cover_broadphase, local_position, {
		local_position
	}, var_18_4, num, num_2, var_18_3)

	local count = #var_18_4

	print("replace_hidden_spawners -> first try found:", count, "cover points")

	if count <= 0 then
		local num_3 = 0
		local num_4 = 30
		local num_5 = 20
		local get_point_on_main_path = self:get_point_on_main_path(var_18_3, num_5)

		if not get_point_on_main_path then
			print("replace_hidden_spawners -> no alternate epicenter_pos found. failed! pos:", var_18_3)

			arg_18_2.dont_move = true

			return
		end

		table.clear_array(var_18_4, #var_18_4)
		self:hidden_cover_points(self.cover_broadphase, get_point_on_main_path, {
			get_point_on_main_path
		}, var_18_4, num_3, num_4, var_18_3)

		count = #var_18_4

		print("replace_hidden_spawners -> second try try found:", count, "cover points")
	end

	if count <= 0 then
		print("replace_hidden_spawners -> no alternate cover found. failed!")

		arg_18_2.dont_move = true

		return
	end

	print("replace_hidden_spawners -> replacing hidden spawners!")

	local num_6 = 1

	for i = 1, #arg_18_1 do
		local var_18_11 = arg_18_1[i]

		if var_18_11.num_to_spawn > 0 then
			var_18_11.cover_point_unit = var_18_4[(num_6 - 1) % count + 1]
			num_6 = num_6 + 1

			print("->moving spawner")
		end
	end

	return true
end

HordeSpawner.find_vector_horde_spawners = function (self, arg_19_1, arg_19_2)
	-- function 19
	local vector = CurrentHordeSettings.vector
	local min_horde_spawner_dist = vector.min_horde_spawner_dist
	local max_horde_spawner_dist = vector.max_horde_spawner_dist
	local min_hidden_spawner_dist = vector.min_hidden_spawner_dist
	local max_hidden_spawner_dist = vector.max_hidden_spawner_dist

	if not script_data.debug_hordes then
		QuickDrawerStay:sphere(arg_19_1, 4, Color(240, 208, 100, 240))
	end

	local enabled_spawners = self.spawner_system:enabled_spawners()
	local filter_positions = ConflictUtils.filter_positions(arg_19_1, arg_19_2, enabled_spawners, min_horde_spawner_dist, max_horde_spawner_dist)

	table.clear_array(tbl_3, #tbl_3)
	self:hidden_cover_points(self.cover_broadphase, arg_19_1, {
		arg_19_1
	}, tbl_3, min_hidden_spawner_dist, max_hidden_spawner_dist, arg_19_2)

	if not (not (#filter_positions <= 0) or not (#tbl_3 <= 0)) then
		return
	end

	return "success", filter_positions, tbl_3
end

HordeSpawner.find_good_vector_horde_pos = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local var_20_0
	local var_20_1
	local var_20_2
	local get_point_on_main_path = self:get_point_on_main_path(arg_20_1, arg_20_2, arg_20_3)

	if not get_point_on_main_path then
		var_20_0, var_20_1, var_20_2 = self:find_vector_horde_spawners(get_point_on_main_path, arg_20_1)

		if not var_20_0 then
			get_point_on_main_path = self:get_point_on_main_path(arg_20_1, arg_20_2 + 10, arg_20_3)

			if not get_point_on_main_path then
				var_20_0, var_20_1, var_20_2 = self:find_vector_horde_spawners(get_point_on_main_path, arg_20_1)
			end
		end
	else
		get_point_on_main_path = self:get_point_on_main_path(arg_20_1, arg_20_2 + 10, arg_20_3)

		if not get_point_on_main_path then
			var_20_0, var_20_1, var_20_2 = self:find_vector_horde_spawners(get_point_on_main_path, arg_20_1)
		end
	end

	return var_20_0, var_20_1, var_20_2, get_point_on_main_path
end

HordeSpawner.execute_vector_horde = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local vector = CurrentHordeSettings.vector
	local max_spawners = vector.max_spawners
	local start_delay

	if not arg_21_1 then
		start_delay = arg_21_1.start_delay

		if not start_delay then
			-- Nothing
		end
	end

	start_delay = vector.start_delay

	::label_21_0::

	local flag = not arg_21_1 and arg_21_1.only_behind
	local flag_2 = not arg_21_1 and arg_21_1.silent
	local ENEMY_PLAYER_AND_BOT_POSITIONS = Managers.state.side:get_side(arg_21_2).ENEMY_PLAYER_AND_BOT_POSITIONS

	print("setting up vector-horde")

	local cluster_positions, var_21_7 = ConflictUtils.cluster_positions(ENEMY_PLAYER_AND_BOT_POSITIONS, 7)
	local var_21_8 = cluster_positions[ConflictUtils.get_biggest_cluster(var_21_7)]
	local var_21_9
	local var_21_10
	local var_21_11
	local var_21_12
	local var_21_13
	local flag_3 = not arg_21_1 and arg_21_1.override_composition_type
	local flag_4 = not arg_21_1 and arg_21_1.optional_wave_composition

	if not flag_3 and not CurrentHordeSettings.compositions[flag_3] then
		local var_21_16 = CurrentHordeSettings.compositions[flag_3]
		local get_difficulty_rank, var_21_18 = Managers.state.difficulty:get_difficulty_rank()

		var_21_13 = var_21_16[DifficultyTweak.converters.composition_rank(get_difficulty_rank, var_21_18) - 1]

		fassert(var_21_13.loaded_probs, " Vector horde override type %s is missing loaded probabilty table!", flag_3)

		var_21_12 = flag_3
	elseif not flag_4 then
		local var_21_19 = HordeWaveCompositions[flag_4]

		var_21_12 = var_21_19[math.random(#var_21_19)]
	else
		var_21_12 = CurrentHordeSettings.vector_composition or "medium"
	end

	assert(var_21_12, "Vector Horde missing composition_type")

	local flag_5 = var_21_13 or CurrentHordeSettings.compositions_pacing[var_21_12]
	local var_21_21 = flag_5[LoadedDice.roll_easy(flag_5.loaded_probs)]

	print("Composing horde '" .. var_21_12 .. "' .. using variant '" .. var_21_21.name .. "'")

	local var_21_22

	if not var_21_8 then
		self:execute_fallback("vector", arg_21_2, arg_21_3, "WARNING: vector horde could not find an main_target_pos, use fallback instead", arg_21_1)

		return
	end

	local random = math.random()
	local flag_6 = not not flag or random <= vector.main_path_chance_spawning_ahead
	local flag_7 = true
	local main_path_dist_from_players = vector.main_path_dist_from_players

	if not flag_6 then
		main_path_dist_from_players = -main_path_dist_from_players
	end

	local print = print
	local str = "--> horde wants to "
	local flag_8

	flag_8 = not flag_6 and "spawn ahead of players" and "spawn behind players"

	print(str .. flag_8 .. " (" .. random .. "/" .. vector.main_path_chance_spawning_ahead)

	local find_good_vector_horde_pos, var_21_31, var_21_32, var_21_33 = self:find_good_vector_horde_pos(var_21_8, main_path_dist_from_players, flag_7)

	if not (find_good_vector_horde_pos or flag) then
		flag_6 = not flag_6

		local print_2 = print
		local str_2 = "--> can't find spawners in this direction, switching to "
		local flag_9

		flag_9 = not flag_6 and "ahead" and "behind"

		print_2(str_2 .. flag_9)

		find_good_vector_horde_pos, var_21_31, var_21_32, var_21_33 = self:find_good_vector_horde_pos(var_21_8, -main_path_dist_from_players, flag_7)
	end

	if not find_good_vector_horde_pos then
		self:execute_fallback("vector", arg_21_3, "vector horde could not find an epicenter or spawners, use fallback instead", arg_21_1)

		return
	end

	local compose_horde_spawn_list, var_21_38, var_21_39 = self:compose_horde_spawn_list(var_21_21)

	print("-> spawning:", compose_horde_spawn_list)

	local generate_group_id = Managers.state.entity:system("ai_group_system"):generate_group_id()
	local tbl = {
		template = "horde",
		id = generate_group_id,
		size = compose_horde_spawn_list,
		sneaky = flag_6,
		group_data = arg_21_1
	}
	local time = Managers.time:time("game")
	local sound_settings = flag_5.sound_settings
	local tbl_2 = {
		horde_type = "vector",
		spawned = 0,
		num_to_spawn = compose_horde_spawn_list,
		main_target_pos = Vector3Box(var_21_8),
		epicenter_pos = Vector3Box(var_21_33),
		start_time = time + start_delay,
		group_template = tbl,
		sound_settings = sound_settings,
		group_id = generate_group_id,
		side_id = arg_21_2,
		silent = flag_2
	}

	print("horde crated with id", generate_group_id, "of type ", tbl_2.horde_type)

	local count = #var_21_31
	local count_2 = #var_21_32

	if count > 0 then
		tbl_2.horde_spawns = {}

		fn_2(var_21_31, tbl_4)
	end

	if count_2 > 0 then
		tbl_2.cover_spawns = {}

		fn_2(var_21_32, tbl_5)
	end

	if compose_horde_spawn_list < max_spawners then
		max_spawners = compose_horde_spawn_list
	end

	local num = count + count_2

	if num < max_spawners then
		max_spawners = num
	end

	local hidden_spawners_lookup = self.spawner_system:hidden_spawners_lookup()
	local num_2 = 0
	local num_3 = compose_horde_spawn_list / max_spawners
	local floor = math.floor(num_3)
	local var_21_52 = num_3
	local num_4 = 0
	local var_21_54
	local horde_spawns = tbl_2.horde_spawns

	for i = 1, count do
		local var_21_56 = tbl_4[i]
		local var_21_57 = hidden_spawners_lookup[var_21_56]
		local pop_random_any_breed

		if not var_21_57 then
			pop_random_any_breed = self:pop_random_any_breed()

			if not pop_random_any_breed then
				-- Nothing
			end
		end

		pop_random_any_breed = self:pop_random_horde_breed_only()

		::label_21_1::

		horde_spawns[#horde_spawns + 1] = {
			num_to_spawn = 1,
			spawner = var_21_56,
			spawn_list = {
				pop_random_any_breed
			},
			hidden = var_21_57
		}
		num_4 = num_4 + 1
	end

	local num_5 = time - 0.05
	local cover_spawns = tbl_2.cover_spawns

	for j = 1, count_2 do
		if compose_horde_spawn_list <= num_4 then
			break
		end

		local var_21_61 = tbl_5[j]
		local pop_random_any_breed_2 = self:pop_random_any_breed()

		cover_spawns[#cover_spawns + 1] = {
			num_to_spawn = 1,
			next_spawn_time = num_5,
			cover_point_unit = var_21_61,
			spawn_list = {
				pop_random_any_breed_2
			}
		}
		num_4 = num_4 + 1
		num_5 = num_5 + 0.1
	end

	local num_6 = 0

	while num_4 < compose_horde_spawn_list do
		for k = 1, count do
			local var_21_64 = horde_spawns[k]
			local pop_random_any_breed_3

			if not var_21_64.hidden then
				pop_random_any_breed_3 = self:pop_random_any_breed()

				if not pop_random_any_breed_3 then
					-- Nothing
				end
			end

			pop_random_any_breed_3 = self:pop_random_horde_breed_only()

			::label_21_2::

			if not pop_random_any_breed_3 then
				break
			end

			local spawn_list = var_21_64.spawn_list

			var_21_64.num_to_spawn = var_21_64.num_to_spawn + 1
			spawn_list[#spawn_list + 1] = pop_random_any_breed_3
			num_4 = num_4 + 1
		end

		for l = 1, count_2 do
			local pop_random_any_breed_4 = self:pop_random_any_breed()

			if not pop_random_any_breed_4 then
				break
			end

			local var_21_68 = cover_spawns[l]
			local spawn_list_2 = var_21_68.spawn_list

			spawn_list_2[#spawn_list_2 + 1] = pop_random_any_breed_4
			var_21_68.num_to_spawn = var_21_68.num_to_spawn + 1
			num_4 = num_4 + 1
		end

		if num_4 == var_21_54 then
			if num_4 == 0 then
				self:execute_fallback("vector", arg_21_2, arg_21_3, "Vector horde spawn failed A - no matching spawners found!", arg_21_1)

				return
			end

			break
		end

		var_21_54 = num_4
		num_6 = num_6 + 1

		if num_6 > 1000 then
			self:execute_fallback("vector", arg_21_2, arg_21_3, "Vector horde spawn failed B - no matching spawners found!", arg_21_1)

			return
		end
	end

	local conflict_director = self.conflict_director

	if not script_data.debug_player_intensity then
		conflict_director.pacing:annotate_graph("(V)Horde:" .. compose_horde_spawn_list, "lime")
	end

	self:_add_horde(tbl_2)

	local flag_10 = not arg_21_1 and arg_21_1.horde_wave

	if not (flag_2 or flag_10 == "multi_first_wave" or flag_10 ~= "single") then
		local stinger_sound_event = sound_settings.stinger_sound_event

		stinger_sound_event = stinger_sound_event or "enemy_horde_stinger"

		self:play_sound(stinger_sound_event, tbl_2.epicenter_pos:unbox())
	end

	self.last_paced_horde_type = "vector"
	self.num_paced_hordes = self.num_paced_hordes + 1
	tbl_2.is_done_spawning = false

	print("vector horde has started")
end

HordeSpawner.execute_custom_horde = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local vector_blob = CurrentHordeSettings.vector_blob
	local random = math.random()
	local flag = arg_22_2 or random <= vector_blob.main_path_chance_spawning_ahead
	local print = print
	local str = "wants to spawn "
	local flag_2

	flag_2 = not flag and "ahead" and "behind"

	print(str .. flag_2 .. " within distance: ", vector_blob.main_path_dist_from_players)

	local get_pos_ahead_or_behind_players_on_mainpath, var_22_7, var_22_8 = self:get_pos_ahead_or_behind_players_on_mainpath(flag, vector_blob.main_path_dist_from_players, vector_blob.raw_dist_from_players, arg_22_3)

	if not get_pos_ahead_or_behind_players_on_mainpath then
		local get_pos_ahead_or_behind_players_on_mainpath_2, var_22_10, var_22_11 = self:get_pos_ahead_or_behind_players_on_mainpath(not flag, vector_blob.main_path_dist_from_players, vector_blob.raw_dist_from_players, arg_22_3)

		var_22_8 = var_22_11
		var_22_7 = var_22_10

		if not get_pos_ahead_or_behind_players_on_mainpath_2 then
			local flag_3 = math.random() <= vector_blob.main_path_chance_spawning_ahead
			local num = 20
			local get_pos_ahead_or_behind_players_on_mainpath_3

			get_pos_ahead_or_behind_players_on_mainpath_3, var_22_7, var_22_8 = self:get_pos_ahead_or_behind_players_on_mainpath(flag_3, vector_blob.main_path_dist_from_players + num, vector_blob.raw_dist_from_players, arg_22_3)
		end
	end

	if not var_22_7 then
		print("\no spawn position found at all, failing horde")

		return
	end

	local count = #arg_22_1
	local num_2 = 6
	local num_3 = 0
	local look = Quaternion.look(Vector3(var_22_8.x, var_22_8.y, 1))
	local num_4 = 8
	local conflict_director = self.conflict_director
	local nav_world = conflict_director.nav_world

	for i = 1, count do
		local var_22_22

		for j = 1, num_4 do
			local var_22_23

			if j == 1 then
				var_22_23 = Vector3(-num_2 / 2 + i % num_2, -num_2 / 2 + math.floor(i / num_2), 0)
			else
				var_22_23 = Vector3(4 * math.random() - 2, 4 * math.random() - 2, 0)
			end

			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_22_7 + var_22_23 * 2)

			if not pos_on_mesh then
				local var_22_25 = Breeds[arg_22_1[i]]
				local tbl = {
					side_id = arg_22_3
				}

				conflict_director:spawn_queued_unit(var_22_25, Vector3Box(pos_on_mesh), QuaternionBox(look), "hidden_spawn", nil, "horde_hidden", tbl, nil)

				num_3 = num_3 + 1

				break
			end
		end
	end

	print("custom blob horde has started")
end

HordeSpawner.get_pos_ahead_or_behind_players_on_mainpath = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local conflict = Managers.state.conflict
	local main_path_info = conflict.main_path_info
	local ahead_unit

	if not arg_23_1 then
		ahead_unit = main_path_info.ahead_unit

		if not ahead_unit then
			-- Nothing
		end
	end

	ahead_unit = main_path_info.behind_unit

	::label_23_0::

	local var_23_3
	local var_23_4
	local flag = true

	if not ahead_unit then
		local travel_dist = conflict.main_path_player_info[ahead_unit].travel_dist
		local flag_2

		flag_2 = not arg_23_1 and 1 and -1

		local num = travel_dist + arg_23_2 * flag_2

		if num < 0 then
			return false
		end

		local point_on_mainpath, var_23_10 = MainPathUtils.point_on_mainpath(nil, num)

		if not point_on_mainpath then
			var_23_4, var_23_3 = POSITION_LOOKUP[ahead_unit] - point_on_mainpath, point_on_mainpath
		end
	end

	if not var_23_3 then
		local ENEMY_PLAYER_POSITIONS = Managers.state.side:get_side(arg_23_4).ENEMY_PLAYER_POSITIONS
		local var_23_12 = Vector3(0, 0, 1)

		for i = 1, #ENEMY_PLAYER_POSITIONS do
			local var_23_13 = ENEMY_PLAYER_POSITIONS[i]

			if not PerceptionUtils.position_has_line_of_sight_to_any_player(var_23_3 + var_23_12) then
				flag = false

				print("Horde spawn position is within line of sight of players, aborting")

				break
			end
		end
	end

	local flag_3 = false

	if not (not flag and not var_23_4 and not (arg_23_3 < Vector3.length(var_23_4))) then
		flag_3 = true
	end

	if not flag and not flag_3 then
		return true, var_23_3, var_23_4
	else
		return false
	end
end

HordeSpawner.execute_vector_blob_horde = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local vector_blob = CurrentHordeSettings.vector_blob
	local flag = math.random() <= vector_blob.main_path_chance_spawning_ahead
	local print = print
	local str = "wants to spawn "
	local flag_2

	flag_2 = not flag and "ahead" and "behind"

	print(str .. flag_2 .. " within distance: ", vector_blob.main_path_dist_from_players)

	local get_pos_ahead_or_behind_players_on_mainpath, var_24_6, var_24_7 = self:get_pos_ahead_or_behind_players_on_mainpath(flag, vector_blob.main_path_dist_from_players, vector_blob.raw_dist_from_players, arg_24_2)

	if not get_pos_ahead_or_behind_players_on_mainpath then
		local print_2 = print
		local str_2 = "\tcould not, tries to spawn"
		local flag_3

		flag_3 = flag or not "ahead" or "behind"

		print_2(str_2 .. flag_3)

		local get_pos_ahead_or_behind_players_on_mainpath_2, var_24_12, var_24_13 = self:get_pos_ahead_or_behind_players_on_mainpath(not flag, vector_blob.main_path_dist_from_players, vector_blob.raw_dist_from_players, arg_24_2)

		var_24_7 = var_24_13
		var_24_6 = var_24_12

		if not get_pos_ahead_or_behind_players_on_mainpath_2 then
			local flag_4 = math.random() <= vector_blob.main_path_chance_spawning_ahead
			local num = 20
			local get_pos_ahead_or_behind_players_on_mainpath_3

			get_pos_ahead_or_behind_players_on_mainpath_3, var_24_6, var_24_7 = self:get_pos_ahead_or_behind_players_on_mainpath(flag_4, vector_blob.main_path_dist_from_players + num, vector_blob.raw_dist_from_players, arg_24_2)
		end
	end

	if not var_24_6 then
		print("\no spawn position found at all, failing horde")

		return
	end

	local var_24_17
	local flag_5 = not arg_24_1 and arg_24_1.optional_wave_composition

	if not flag_5 then
		local var_24_19 = HordeWaveCompositions[flag_5]

		var_24_17 = var_24_19[math.random(#var_24_19)]
	else
		var_24_17 = not arg_24_1 and arg_24_1.override_composition_type and CurrentHordeSettings.vector_composition or "medium"
	end

	assert(var_24_17, "Vector Blob Horde missing composition_type")

	local var_24_20 = CurrentHordeSettings.compositions_pacing[var_24_17]
	local var_24_21
	local var_24_22

	if not arg_24_1 and not arg_24_1.spawn_list then
		var_24_22 = #arg_24_1.spawn_list
		var_24_21 = arg_24_1.spawn_list
	else
		var_24_21, var_24_22 = self:compose_blob_horde_spawn_list(var_24_17)
	end

	local generate_group_id = Managers.state.entity:system("ai_group_system"):generate_group_id()
	local tbl = {
		template = "horde",
		id = generate_group_id,
		size = var_24_22,
		sneaky = flag,
		group_data = arg_24_1
	}
	local time = Managers.time:time("game")
	local sound_settings = var_24_20.sound_settings
	local tbl_2 = {
		horde_type = "vector_blob",
		spawned = 0,
		num_to_spawn = var_24_22,
		epicenter_pos = Vector3Box(var_24_6),
		start_time = time + vector_blob.start_delay,
		group_template = tbl,
		sound_settings = sound_settings,
		group_id = generate_group_id
	}

	print("horde crated with id", generate_group_id, "of type ", tbl_2.horde_type)

	local num_2 = 6
	local num_3 = 0
	local look = Quaternion.look(Vector3(var_24_7.x, var_24_7.y, 1))
	local num_4 = 8
	local conflict_director = self.conflict_director
	local nav_world = conflict_director.nav_world

	for i = 1, var_24_22 do
		local var_24_34

		for j = 1, num_4 do
			local var_24_35

			if j == 1 then
				var_24_35 = Vector3(-num_2 / 2 + i % num_2, -num_2 / 2 + math.floor(i / num_2), 0)
			else
				var_24_35 = Vector3(4 * math.random() - 2, 4 * math.random() - 2, 0)
			end

			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_24_6 + var_24_35 * 2)

			if not pos_on_mesh then
				local var_24_37 = Breeds[var_24_21[i]]
				local tbl_3 = {
					side_id = arg_24_2
				}

				conflict_director:spawn_queued_unit(var_24_37, Vector3Box(pos_on_mesh), QuaternionBox(look), "hidden_spawn", nil, "horde_hidden", tbl_3, tbl)

				num_3 = num_3 + 1

				break
			end
		end
	end

	conflict_director:add_horde(num_3)

	tbl_2.spawned = num_3

	print("managed to spawn " .. tostring(num_3) .. "/" .. tostring(var_24_22) .. " horde enemies")

	local conflict_director_2 = self.conflict_director

	if not script_data.debug_player_intensity then
		conflict_director_2.pacing:annotate_graph("(B)Horde:" .. num_3 .. "/" .. var_24_22, "lime")
	end

	local flag_6 = not arg_24_1 and arg_24_1.horde_wave

	if not (flag_6 == "multi_first_wave" or flag_6 ~= "single") then
		local stinger_sound_event = sound_settings.stinger_sound_event

		stinger_sound_event = stinger_sound_event or "enemy_horde_stinger"

		self:play_sound(stinger_sound_event, tbl_2.epicenter_pos:unbox())
	end

	self:_add_horde(tbl_2)

	self.last_paced_horde_type = "vector_blob"
	self.num_paced_hordes = self.num_paced_hordes + 1

	print("vector blob horde has started")
end

HordeSpawner.spawn_unit = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	local cover_point_unit = arg_25_1.cover_point_unit
	local local_position = Unit.local_position(cover_point_unit, 0)
	local num = arg_25_3 - local_position
	local look = Quaternion.look(Vector3(num.x, num.y, 1))
	local str = "horde_hidden"
	local str_2 = "hidden_spawn"
	local var_25_6 = Breeds[arg_25_2]
	local optional_data = arg_25_4.optional_data

	optional_data = optional_data or {}
	optional_data.side_id = arg_25_4.side_id

	local var_25_8

	self.conflict_director:spawn_queued_unit(var_25_6, Vector3Box(local_position), QuaternionBox(look), str_2, var_25_8, str, optional_data, arg_25_4.group_template)
	self.conflict_director:add_horde(1)
end

HordeSpawner.play_sound = function (self, arg_26_1, arg_26_2)
	-- function 26
	local wwise_world = Managers.world:wwise_world(self.world)
	local trigger_event, var_26_2 = WwiseWorld.trigger_event(wwise_world, arg_26_1, arg_26_2)

	Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_event_at_pos", NetworkLookup.sound_events[arg_26_1], arg_26_2)
end

HordeSpawner.create_event_horde_no_horde_spawners = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local conflict = Managers.state.conflict
	local behind_unit = conflict.main_path_info.behind_unit

	if not behind_unit then
		local num = 0
		local num_2 = conflict.main_path_player_info[behind_unit].travel_dist - 45
		local point_on_mainpath, var_27_5 = MainPathUtils.point_on_mainpath(nil, num_2)
		local ENEMY_PLAYER_POSITIONS = Managers.state.side:get_side(arg_27_4).ENEMY_PLAYER_POSITIONS
		local hidden_cover_points, var_27_8 = ConflictUtils.hidden_cover_points(point_on_mainpath, ENEMY_PLAYER_POSITIONS, 0, 10)

		if hidden_cover_points > 0 then
			local var_27_9 = var_27_8[math.random(1, hidden_cover_points)]
			local tbl = {}

			arg_27_1.cover_spawns = {
				num_to_spawn = 0,
				next_spawn_time = arg_27_3,
				cover_point_unit = var_27_9,
				spawn_list = tbl
			}

			local difficulty = Managers.state.difficulty.difficulty
			local difficulty_breeds = arg_27_2.difficulty_breeds
			local var_27_13

			if not difficulty_breeds then
				var_27_13 = difficulty_breeds[difficulty]

				if not var_27_13 then
					-- Nothing
				end
			end

			var_27_13 = arg_27_2.breeds

			::label_27_0::

			for i = 1, #var_27_13, 2 do
				local var_27_14 = var_27_13[i]
				local var_27_15 = var_27_13[i + 1]
				local random

				if type(var_27_15) == "table" then
					random = Math.random(var_27_15[1], var_27_15[2])

					if not random then
						-- Nothing
					end
				end

				random = var_27_15

				::label_27_1::

				if not script_data.big_hordes then
					local round = math.round
					local var_27_18 = tonumber(script_data.big_hordes)

					var_27_18 = var_27_18 or 1
					random = round(random * var_27_18)
				end

				for j = 1, random do
					tbl[#tbl + 1] = var_27_14
				end

				num = num + random
			end

			arg_27_1.num_to_spawn = num
			arg_27_1.spawned = 0

			return true, num
		end
	end

	return false
end

HordeSpawner.update_event_horde_no_horde_spawners = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not arg_28_1.started then
		if arg_28_2 > arg_28_1.start_time then
			local create_event_horde_no_horde_spawners, var_28_1 = self:create_event_horde_no_horde_spawners(arg_28_1, arg_28_1.variant, arg_28_2, arg_28_1.side_id)

			if not create_event_horde_no_horde_spawners then
				arg_28_1.started = true
				arg_28_1.amount = var_28_1
			else
				arg_28_1.failed = true

				print("event horde failed")

				return true
			end
		end
	else
		return self:update_horde(arg_28_1, arg_28_2)
	end

	return false
end

HordeSpawner.update_event_horde = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not arg_29_1.started then
		if arg_29_2 > arg_29_1.start_time then
			local spawn_horde_from_terror_event_ids, var_29_1 = self.spawner_system:spawn_horde_from_terror_event_ids(arg_29_1.terror_event_ids, arg_29_1.variant, arg_29_1.limit_spawners, arg_29_1.group_template, arg_29_1.strictly, arg_29_1.side_id, arg_29_1.use_closest_spawners, arg_29_1.source_unit, arg_29_1.optional_data)

			if not spawn_horde_from_terror_event_ids then
				arg_29_1.started = true
				arg_29_1.amount = var_29_1
			else
				arg_29_1.failed = true

				print("event horde failed")

				return true
			end
		end
	elseif arg_29_2 > arg_29_1.end_time then
		print("event horde ends!")

		return true
	end

	return false
end

HordeSpawner.spawner_in_view_of_players = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	arg_30_3 = arg_30_3 or Unit.local_position(arg_30_1.cover_point_unit, 0) + Vector3(0, 0, 1)

	local ENEMY_PLAYER_AND_BOT_POSITIONS = Managers.state.side:get_side(arg_30_2).ENEMY_PLAYER_AND_BOT_POSITIONS
	local up = Vector3.up()

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		local num = ENEMY_PLAYER_AND_BOT_POSITIONS[i] + Vector3(0, 0, 1)
		local num_2 = num - arg_30_3
		local length = Vector3.length(num_2)

		if length < 3 then
			return num
		end

		if length < 30 then
			local normalize = Vector3.normalize(num_2)
			local immediate_raycast, var_30_7, var_30_8, var_30_9, var_30_10 = PhysicsWorld.immediate_raycast(self.physics_world, arg_30_3 + up, normalize, length, "collision_filter", "filter_ai_line_of_sight_check")

			if not immediate_raycast then
				return num
			end
		end
	end
end

HordeSpawner.update_horde = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not arg_31_1.started then
		if arg_31_2 > arg_31_1.start_time then
			local horde_spawns = arg_31_1.horde_spawns

			if not horde_spawns then
				local tbl = {}

				for i = 1, #horde_spawns do
					local var_31_2 = horde_spawns[i]
					local spawner = var_31_2.spawner
					local local_position = Unit.local_position(spawner, 0)

					if not self:spawner_in_view_of_players(nil, arg_31_1.side_id, local_position) then
						table.append(tbl, var_31_2.spawn_list)

						horde_spawns[i] = nil
					end
				end

				local tbl_2 = {}

				for j = 1, #horde_spawns do
					local var_31_6 = horde_spawns[j]

					if not var_31_6 then
						local spawner_2 = var_31_6.spawner
						local spawn_list = var_31_6.spawn_list

						if #tbl > 0 then
							table.append(spawn_list, tbl)

							tbl = {}
							var_31_6.num_to_spawn = #spawn_list
						end

						var_31_6.all_done_spawned_time = arg_31_2 + 1 / self.spawner_system:spawn_horde(spawner_2, spawn_list, arg_31_1.side_id, arg_31_1.group_template, arg_31_1.optional_data) * var_31_6.num_to_spawn
						tbl_2[#tbl_2 + 1] = var_31_6
					end
				end

				arg_31_1.horde_spawns = tbl_2
			end

			arg_31_1.started = true
		else
			return
		end
	end

	local flag = true
	local horde_spawns_2 = arg_31_1.horde_spawns

	if not horde_spawns_2 then
		for k = 1, #horde_spawns_2 do
			local var_31_11 = horde_spawns_2[k]

			if not var_31_11.done then
				if arg_31_2 > var_31_11.all_done_spawned_time then
					var_31_11.done = true
					arg_31_1.spawned = arg_31_1.spawned + var_31_11.num_to_spawn
				end

				flag = false
			end
		end
	end

	local cover_spawns = arg_31_1.cover_spawns

	if not cover_spawns then
		for l = 1, #cover_spawns do
			local var_31_13 = cover_spawns[l]

			if var_31_13.num_to_spawn > 0 then
				flag = false

				if arg_31_2 > var_31_13.next_spawn_time then
					local spawner_in_view_of_players = self:spawner_in_view_of_players(var_31_13, arg_31_1.side_id)

					if not spawner_in_view_of_players then
						if not self:replace_hidden_spawners(cover_spawns, var_31_13, spawner_in_view_of_players) then
							break
						else
							local flag_2

							flag_2 = l ~= #cover_spawns or not 1 or l + 1

							local var_31_16 = cover_spawns[flag_2]

							var_31_16.num_to_spawn = var_31_16.num_to_spawn + var_31_13.num_to_spawn

							table.append(var_31_16.spawn_list, var_31_13.spawn_list)
							table.clear(var_31_13.spawn_list)

							var_31_13.num_to_spawn = 0

							print("Spawner visible and can't replace it. Using the next spawner in the list")
						end
					else
						local var_31_17 = fn_3(var_31_13.spawn_list)

						self:spawn_unit(var_31_13, var_31_17, arg_31_1.main_target_pos:unbox(), arg_31_1)

						arg_31_1.spawned = arg_31_1.spawned + 1
						var_31_13.num_to_spawn = var_31_13.num_to_spawn - 1
						var_31_13.next_spawn_time = var_31_13.next_spawn_time + 1
					end
				end
			end
		end
	end

	local flag_3 = arg_31_1.spawned >= arg_31_1.num_to_spawn or flag
	local is_done_spawning = arg_31_1.is_done_spawning
	local flag_4 = arg_31_1.horde_type == "vector" or arg_31_1.horde_type == "ambush"

	if not (flag_3 or flag_4 or is_done_spawning) then
		return true
	end
end

HordeSpawner.update = function (self, arg_32_1, arg_32_2)
	-- function 32
	local hordes = self.hordes
	local count = #hordes

	self._running_horde_type = nil
	self._running_horde_sound_settings = nil

	local num = 1

	while num <= count do
		local var_32_3 = hordes[num]
		local var_32_4

		if var_32_3.horde_type == "vector_blob" then
			if not var_32_3.silent then
				self._running_horde_type = var_32_3.horde_type
				self._running_horde_sound_settings = var_32_3.sound_settings
			end

			var_32_4 = true
		elseif not (var_32_3.horde_type == "vector" or var_32_3.horde_type ~= "ambush") then
			if not var_32_3.silent then
				self._running_horde_type = var_32_3.horde_type
				self._running_horde_sound_settings = var_32_3.sound_settings
			end

			var_32_4 = self:update_horde(var_32_3, arg_32_1)
		elseif var_32_3.horde_type == "event" then
			var_32_4 = self:update_event_horde(var_32_3, arg_32_1)

			if not var_32_3.silent then
				self._running_horde_type = "event"
				self._running_horde_sound_settings = var_32_3.sound_settings
			end
		else
			var_32_4 = self:update_event_horde_no_horde_spawners(var_32_3, arg_32_1)

			if not var_32_3.silent then
				self._running_horde_type = "event"
				self._running_horde_sound_settings = var_32_3.sound_settings
			end
		end

		if not var_32_4 then
			hordes[num] = hordes[count]
			hordes[count] = nil
			count = count - 1
		else
			num = num + 1
		end
	end

	if not script_data.debug_hordes then
		self:debug_hordes(arg_32_1)
	end
end

HordeSpawner.set_horde_has_spawned = function (self, arg_33_1)
	-- function 33
	local hordes = self.hordes

	for i = 1, #hordes do
		local var_33_1 = hordes[i]
		local group_id = var_33_1.group_id

		if not (not group_id and group_id ~= arg_33_1) then
			var_33_1.is_done_spawning = true
		end
	end
end

HordeSpawner.set_horde_is_done = function (self, arg_34_1)
	-- function 34
	local hordes = self.hordes

	for i = 1, #hordes do
		local var_34_1 = hordes[i]
		local group_id = var_34_1.group_id

		if not (not group_id and group_id ~= arg_34_1) then
			var_34_1.is_dead = true
		end
	end
end

HordeSpawner.debug_hordes = function (self, arg_35_1)
	-- function 35
	local str = "Hordes - now: "
	local horde_size = self.conflict_director:horde_size()
	local str_2 = " ("
	local tostring = tostring
	local _running_horde_type = self._running_horde_type

	_running_horde_type = _running_horde_type or "none"

	local str_3 = str .. horde_size .. str_2 .. tostring(_running_horde_type) .. ") "
	local hordes = self.hordes

	for i = 1, #hordes do
		local var_35_7 = hordes[i]
		local horde_type = var_35_7.horde_type
		local silent = var_35_7.silent
		local var_35_10 = str_3
		local str_4 = "| "
		local var_35_12 = horde_type
		local flag

		flag = not var_35_7.silent and "(silent), " and ""
		str_3 = var_35_10 .. str_4 .. var_35_12 .. flag .. " |"
	end

	Debug.text(str_3)
end

local tbl_9 = {}

HordeSpawner.hidden_cover_points = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
	-- function 36
	local distance_squared = Vector3.distance_squared
	local normalize = Vector3.normalize
	local dot = Vector3.dot
	local forward = Quaternion.forward
	local local_position = Unit.local_position
	local local_rotation = Unit.local_rotation

	table.clear_array(tbl_9, #tbl_9)

	local count = #arg_36_3
	local num = 0
	local query = Broadphase.query(arg_36_1, arg_36_2, arg_36_6, tbl_9)
	local flag = not arg_36_7 and distance_squared(arg_36_3[1], arg_36_7)

	arg_36_5 = arg_36_5 * arg_36_5
	arg_36_6 = arg_36_6 * arg_36_6

	for i = 1, query do
		local var_36_10 = tbl_9[i]
		local var_36_11 = local_position(var_36_10, 0)
		local flag_2 = true

		if not (not arg_36_7 and not (flag > distance_squared(var_36_11, arg_36_7))) then
			flag_2 = false
		end

		if not flag_2 then
			for j = 1, count do
				local var_36_13 = arg_36_3[j]
				local var_36_14 = distance_squared(var_36_11, var_36_13)

				if not (not (arg_36_5 <= var_36_14) or not (var_36_14 <= arg_36_6)) then
					local var_36_15 = local_rotation(var_36_10, 0)
					local var_36_16 = normalize(var_36_11 - arg_36_2)
					local flag_3

					flag_3 = not (var_36_14 < 625) or not -0.9 or -0.6

					if not (flag_3 > dot(forward(var_36_15), var_36_16)) then
						num = num + 1
						arg_36_4[num] = var_36_10
					end
				end
			end
		end
	end
end

HordeSpawner.calc_sectors = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	local local_position = Unit.local_position
	local normalize = Vector3.normalize
	local atan2 = math.atan2
	local pi = math.pi

	for i = 1, #arg_37_2 do
		local var_37_4 = arg_37_2[i]
		local var_37_5 = local_position(var_37_4, 0)
		local var_37_6 = normalize(var_37_5 - arg_37_1)
		local var_37_7 = atan2(var_37_6.y, var_37_6.x)
		local var_37_8 = arg_37_3[math.max(1, math.ceil((var_37_7 + pi) / (2 * pi) * count))]

		var_37_8[#var_37_8 + 1] = var_37_4
	end
end

HordeSpawner.render_sectors = function (arg_38_0, arg_38_1)
	-- function 38
	local local_position = Unit.local_position
	local tbl = {
		Color(255, 255, 0, 0),
		Color(255, 255, 128, 0),
		Color(255, 0, 255, 0),
		Color(255, 128, 255, 0),
		Color(255, 0, 0, 255),
		Color(255, 0, 128, 255),
		Color(255, 0, 255, 255),
		Color(255, 255, 0, 255)
	}

	for i = 1, count do
		local var_38_2 = arg_38_1[i]
		local var_38_3 = tbl[i]

		print("Sector:", i, "size:", #var_38_2)

		for j = 1, #var_38_2 do
			local var_38_4 = var_38_2[j]
			local var_38_5 = local_position(var_38_4, 0)

			QuickDrawerStay:sphere(var_38_5, 2, var_38_3)
		end
	end
end

HordeSpawner.reset_sectors = function (arg_39_0, arg_39_1)
	-- function 39
	for i = 1, count do
		local var_39_0 = arg_39_1[i]

		for j = 1, #var_39_0 do
			var_39_0[j] = nil
		end
	end
end

function test_sectors()
	-- function 40
	local local_position = Unit.local_position
	local normalize = Vector3.normalize
	local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local var_40_3 = local_position(PLAYER_UNITS[1], 0)
	local tbl = {
		Color(255, 255, 0, 0),
		Color(255, 255, 128, 0),
		Color(255, 0, 255, 0),
		Color(255, 128, 255, 0),
		Color(255, 0, 0, 255),
		Color(255, 0, 128, 255),
		Color(255, 0, 255, 255),
		Color(255, 255, 0, 255)
	}
	local pi = math.pi

	for i = 1, 300 do
		local var_40_6 = Vector3(math.random(-30, 30), math.random(-30, 30), 1)

		print("xapa:", i, var_40_6, var_40_3)

		local num = var_40_3 + var_40_6
		local var_40_8 = normalize(num - var_40_3)
		local atan2 = math.atan2(var_40_8.y, var_40_8.x)
		local max = math.max(1, math.ceil((atan2 + pi) / (2 * pi) * count))

		if max <= count then
			QuickDrawerStay:sphere(num, 1.2, tbl[max])
		else
			print("BAd sector index: ", max)
		end
	end
end

HordeSpawner.filter_dist = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	local distance_squared = Vector3.distance_squared
	local count = #arg_41_2
	local num = 1

	while num <= count do
		local var_41_3 = arg_41_2[num]
		local var_41_4 = distance_squared(arg_41_1, var_41_3)

		if not (not (arg_41_3 <= var_41_4) or not (var_41_4 <= arg_41_4)) then
			num = num + 1
		else
			arg_41_2[num] = arg_41_2[count]
			count = count - 1
		end
	end
end

HordeSpawner.filter_angle = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	arg_42_3 = arg_42_3 or -0.9

	local normalize = Vector3.normalize
	local dot = Vector3.dot
	local forward = Quaternion.forward
	local count = #arg_42_2
	local num = 1

	while num <= count do
		local var_42_5 = arg_42_2[num]
		local local_rotation = Unit.local_rotation(var_42_5, 0)
		local var_42_7 = normalize(pos - arg_42_1)

		if arg_42_3 > dot(forward(local_rotation), var_42_7) then
			num = num + 1
		else
			arg_42_2[num] = arg_42_2[count]
			count = count - 1
		end
	end
end

HordeSpawner.get_point_on_main_path = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local get_main_paths = self.conflict_director.level_analysis:get_main_paths()
	local closest_pos_at_main_path, var_43_2 = MainPathUtils.closest_pos_at_main_path(get_main_paths, arg_43_1)
	local point_on_mainpath = MainPathUtils.point_on_mainpath(get_main_paths, var_43_2 + arg_43_2)

	if true or not arg_43_3 then
		return not Managers.state.conflict.navigation_group_manager:a_star_cached_between_positions(arg_43_1, point_on_mainpath) and point_on_mainpath
	end

	return point_on_mainpath
end
