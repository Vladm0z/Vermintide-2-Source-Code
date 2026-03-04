-- chunkname: @scripts/managers/conflict_director/horde_spawner.lua

HordeSpawner = class(HordeSpawner)

local var_0_0 = {
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{}
}
local var_0_1 = {
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{}
}
local var_0_2 = #var_0_0
local var_0_3 = {}
local var_0_4 = {}
local var_0_5 = {}

function HordeSpawner.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.cover_broadphase = arg_1_2
	arg_1_0.hordes = {}
	arg_1_0.lookup_horde = {}
	arg_1_0.conflict_director = Managers.state.conflict
	arg_1_0.spawner_system = Managers.state.entity:system("spawner_system")
	arg_1_0.num_paced_hordes = 0
	arg_1_0.world = arg_1_1
	arg_1_0.physics_world = World.physics_world(arg_1_1)
end

local function var_0_6(arg_2_0, arg_2_1)
	local var_2_0 = #arg_2_0

	arg_2_0[arg_2_1] = arg_2_0[var_2_0]
	arg_2_0[var_2_0] = nil
end

local function var_0_7(arg_3_0, arg_3_1)
	local var_3_0 = #arg_3_0
	local var_3_1 = #arg_3_1

	for iter_3_0 = 1, var_3_0 do
		arg_3_1[iter_3_0] = arg_3_0[iter_3_0]
	end

	for iter_3_1 = var_3_0 + 1, var_3_1 do
		arg_3_1[iter_3_1] = nil
	end
end

function HordeSpawner.horde(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	print("horde requested: ", arg_4_1)

	if arg_4_1 == "vector" then
		arg_4_0:execute_vector_horde(arg_4_2, arg_4_3, arg_4_4)
	elseif arg_4_1 == "vector_blob" then
		arg_4_0:execute_vector_blob_horde(arg_4_2, arg_4_3, arg_4_4)
	else
		arg_4_0:execute_ambush_horde(arg_4_2, arg_4_3, arg_4_4, nil, arg_4_5)
	end
end

function HordeSpawner.execute_fallback(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_3 then
		if script_data.debug_player_intensity then
			arg_5_0.conflict_director.pacing:annotate_graph("Failed horde fb", "red")
		end

		print("Failed to start horde, all fallbacks failed at this place")

		return
	end

	print(arg_5_4)

	if arg_5_1 == "ambush" then
		arg_5_0:execute_vector_horde(arg_5_5, arg_5_2, "fallback")
	elseif arg_5_1 == "vector" then
		arg_5_0:execute_ambush_horde(arg_5_5, arg_5_2, "fallback")
	end
end

function HordeSpawner._add_horde(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.hordes

	var_6_0[#var_6_0 + 1] = arg_6_1

	if not Managers.state.conflict:is_horde_alive() then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("horde")
	end
end

function HordeSpawner.execute_event_horde(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12)
	local var_7_0 = arg_7_0:_execute_event_horde(arg_7_1, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12)

	if type(arg_7_2) == "string" then
		var_7_0.terror_event_ids = {
			arg_7_2
		}
	elseif type(arg_7_2) == "table" then
		var_7_0.terror_event_ids = arg_7_2
	end

	arg_7_0:_add_horde(var_7_0)

	return var_7_0
end

function HordeSpawner._execute_event_horde(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11)
	local var_8_0

	fassert(arg_8_2, "Missing side id in event horde")

	if HordeCompositions[arg_8_3] then
		local var_8_1, var_8_2 = Managers.state.difficulty:get_difficulty_rank()
		local var_8_3 = DifficultyTweak.converters.composition_rank(var_8_1, var_8_2) - 1

		var_8_0 = CurrentHordeSettings.compositions[arg_8_3][var_8_3]
	elseif HordeCompositionsPacing[arg_8_3] then
		var_8_0 = CurrentHordeSettings.compositions_pacing[arg_8_3]
	end

	local var_8_4 = var_8_0[LoadedDice.roll_easy(var_8_0.loaded_probs)]
	local var_8_5 = "event"
	local var_8_6 = arg_8_8 or var_8_0.sound_settings

	return {
		composition_type = arg_8_3,
		limit_spawners = arg_8_4,
		start_time = arg_8_1 + (var_8_0.start_time or 4),
		end_time = arg_8_1 + (var_8_0.start_time or 4) + (var_8_0.end_time or 20),
		horde_type = var_8_5,
		silent = arg_8_5,
		group_template = arg_8_6,
		group_id = arg_8_6 and arg_8_6.id,
		strictly = arg_8_7,
		use_closest_spawners = arg_8_9,
		variant = var_8_4,
		source_unit = arg_8_10,
		sound_settings = var_8_6,
		side_id = arg_8_2,
		optional_data = arg_8_11
	}
end

function HordeSpawner.max_composition_size(arg_9_0, arg_9_1)
	local var_9_0 = 0
	local var_9_1 = CurrentHordeSettings.compositions[arg_9_1]

	for iter_9_0 = 1, #var_9_1 do
		local var_9_2 = var_9_1[iter_9_0].breeds
		local var_9_3 = 0

		for iter_9_1 = 1, #var_9_2, 2 do
			local var_9_4 = var_9_2[iter_9_0]
			local var_9_5 = var_9_2[iter_9_0 + 1]

			var_9_3 = var_9_3 + (type(var_9_5) == "table" and math.max(var_9_5[1], var_9_5[2]) or var_9_5)
		end

		if var_9_0 < var_9_3 then
			var_9_0 = var_9_3
		end
	end

	return var_9_0
end

function HordeSpawner.running_horde(arg_10_0)
	return arg_10_0._running_horde_type, arg_10_0._running_horde_sound_settings
end

function random_array_insert(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = math.random(1, arg_11_1)

	arg_11_0[var_11_0], arg_11_0[arg_11_1 + 1] = arg_11_2, arg_11_0[var_11_0]
end

local var_0_8 = {
	skaven_clan_rat = true,
	skaven_slave = true
}
local var_0_9 = {}
local var_0_10 = {}

function HordeSpawner.compose_horde_spawn_list(arg_12_0, arg_12_1)
	local var_12_0 = 1

	table.clear_array(var_0_9, #var_0_9)
	table.clear_array(var_0_10, #var_0_10)

	local var_12_1 = arg_12_1.breeds

	for iter_12_0 = 1, #var_12_1, 2 do
		local var_12_2 = var_12_1[iter_12_0]
		local var_12_3 = var_12_1[iter_12_0 + 1]
		local var_12_4 = ConflictUtils.random_interval(var_12_3)

		if script_data.big_hordes then
			var_12_4 = math.round(var_12_4 * (tonumber(script_data.big_hordes) or 1))
		end

		local var_12_5 = var_0_8[var_12_2] and var_0_9 or var_0_10
		local var_12_6 = #var_12_5

		for iter_12_1 = var_12_6 + 1, var_12_6 + var_12_4 do
			var_12_5[iter_12_1] = var_12_2
		end
	end

	table.shuffle(var_0_9)
	table.shuffle(var_0_10)

	local var_12_7 = #var_0_9
	local var_12_8 = #var_0_10

	return var_12_7 + var_12_8, var_12_7, var_12_8
end

function HordeSpawner.compose_blob_horde_spawn_list(arg_13_0, arg_13_1)
	local var_13_0 = CurrentHordeSettings.compositions_pacing[arg_13_1]
	local var_13_1 = var_13_0[LoadedDice.roll_easy(var_13_0.loaded_probs)]
	local var_13_2 = 1
	local var_13_3 = var_0_9

	table.clear_array(var_0_9, #var_0_9)

	local var_13_4 = var_13_1.breeds

	for iter_13_0 = 1, #var_13_4, 2 do
		local var_13_5 = var_13_4[iter_13_0]
		local var_13_6 = var_13_4[iter_13_0 + 1]
		local var_13_7 = ConflictUtils.random_interval(var_13_6)

		if script_data.big_hordes then
			var_13_7 = math.round(var_13_7 * (tonumber(script_data.big_hordes) or 1))
		end

		local var_13_8 = #var_13_3 + 1

		for iter_13_1 = var_13_8, var_13_8 + var_13_7 do
			var_13_3[iter_13_1] = var_13_5
		end
	end

	table.shuffle(var_13_3)

	return var_13_3, #var_13_3
end

local function var_0_11(arg_14_0)
	local var_14_0 = #arg_14_0

	if var_14_0 > 0 then
		local var_14_1 = arg_14_0[var_14_0]

		arg_14_0[var_14_0] = nil

		return var_14_1
	end
end

local var_0_12 = false

function HordeSpawner.pop_random_any_breed(arg_15_0)
	var_0_12 = not var_0_12

	local var_15_0

	if var_0_12 then
		var_15_0 = var_0_11(var_0_9) or var_0_11(var_0_10)
	else
		var_15_0 = var_0_11(var_0_10) or var_0_11(var_0_9)
	end

	return var_15_0
end

function HordeSpawner.pop_random_horde_breed_only(arg_16_0)
	return (var_0_11(var_0_9))
end

function HordeSpawner.execute_ambush_horde(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	print("setting up ambush-horde")

	local var_17_0 = CurrentHordeSettings.ambush
	local var_17_1 = var_17_0.min_spawners
	local var_17_2 = var_17_0.max_spawners
	local var_17_3 = var_17_0.min_horde_spawner_dist
	local var_17_4 = var_17_0.max_horde_spawner_dist
	local var_17_5 = var_17_0.min_hidden_spawner_dist
	local var_17_6 = var_17_0.max_hidden_spawner_dist
	local var_17_7 = var_17_0.start_delay
	local var_17_8
	local var_17_9
	local var_17_10 = arg_17_1 and arg_17_1.override_composition_type

	if var_17_10 and CurrentHordeSettings.compositions[var_17_10] then
		local var_17_11 = CurrentHordeSettings.compositions[var_17_10]
		local var_17_12, var_17_13 = Managers.state.difficulty:get_difficulty_rank()

		var_17_9 = var_17_11[DifficultyTweak.converters.composition_rank(var_17_12, var_17_13) - 1]

		fassert(var_17_9.loaded_probs, " Ambush horde %s is missing loaded probabilty table!", var_17_10)

		var_17_8 = var_17_10
	else
		local var_17_14
		local var_17_15 = arg_17_1 and arg_17_1.optional_wave_composition

		if var_17_15 then
			local var_17_16 = HordeWaveCompositions[var_17_15]

			var_17_14 = var_17_16[math.random(#var_17_16)]
		else
			var_17_14 = CurrentHordeSettings.vector_composition or "medium"
		end

		var_17_8 = var_17_10 or var_17_14

		fassert(var_17_8, "Ambush Horde missing composition_type")
	end

	local var_17_17 = var_17_9 or CurrentHordeSettings.compositions_pacing[var_17_8]
	local var_17_18 = var_17_17[LoadedDice.roll_easy(var_17_17.loaded_probs)]

	print("Composing horde '" .. var_17_8 .. "' .. using variant '" .. var_17_18.name .. "'")

	local var_17_19 = Managers.state.side:get_side(arg_17_2).ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_17_20
	local var_17_21
	local var_17_22
	local var_17_23
	local var_17_24

	if arg_17_4 then
		var_17_24 = arg_17_4
		var_17_23 = arg_17_4
	else
		local var_17_25, var_17_26 = ConflictUtils.cluster_positions(var_17_19, 7)
		local var_17_27 = var_17_26

		var_17_24 = var_17_25[ConflictUtils.get_biggest_cluster(var_17_27)]
		var_17_23 = var_17_24
	end

	if not var_17_23 then
		print("Failed ambush horde, cant suitable epicenter position. ")

		return
	end

	local var_17_28 = arg_17_0.spawner_system:enabled_spawners()
	local var_17_29 = arg_17_0.spawner_system:hidden_spawners_lookup()
	local var_17_30, var_17_31 = ConflictUtils.filter_horde_spawners(var_17_19, var_17_28, var_17_29, var_17_3, var_17_4)

	arg_17_0:reset_sectors(var_0_0)
	arg_17_0:calc_sectors(var_17_23, var_17_30, var_0_0)

	if script_data.debug_hordes then
		arg_17_0:render_sectors(var_0_0)
	end

	local var_17_32 = #var_17_30
	local var_17_33 = #var_17_31

	table.clear_array(var_0_3, #var_0_3)
	arg_17_0:hidden_cover_points(arg_17_0.cover_broadphase, var_17_23, var_17_19, var_0_3, var_17_5, var_17_6)
	arg_17_0:reset_sectors(var_0_1)
	arg_17_0:calc_sectors(var_17_23, var_0_3, var_0_1)

	if script_data.debug_hordes then
		arg_17_0:render_sectors(var_0_1)
	end

	if var_17_1 >= #var_0_3 + var_17_32 then
		if var_17_33 <= 0 and var_17_18.must_use_hidden_spawners then
			arg_17_0:execute_fallback("ambush", arg_17_2, arg_17_3, "ambush horde failed to find any kind of hidden spawners for their none-horde compatable units, starts a vector-horde instead", arg_17_1)
		else
			arg_17_0:execute_fallback("ambush", arg_17_2, arg_17_3, "ambush horde failed to find spawners, starts a vector-horde instead", arg_17_1)
		end

		return
	end

	local var_17_34 = arg_17_0:compose_horde_spawn_list(var_17_18)

	print("-> spawning:", var_17_34)

	local var_17_35 = Managers.state.entity:system("ai_group_system"):generate_group_id()
	local var_17_36 = {
		template = "horde",
		id = var_17_35,
		size = var_17_34,
		group_data = arg_17_1
	}
	local var_17_37 = Managers.time:time("game")
	local var_17_38 = arg_17_1 and arg_17_1.sound_settings or var_17_17.sound_settings
	local var_17_39 = {
		horde_type = "ambush",
		spawned = 0,
		num_to_spawn = var_17_34,
		main_target_pos = Vector3Box(var_17_24),
		start_time = var_17_37 + var_17_7,
		group_template = var_17_36,
		sound_settings = var_17_38,
		group_id = var_17_35,
		side_id = arg_17_2,
		optional_data = arg_17_5
	}

	print("horde crated with id", var_17_35, "of type ", var_17_39.horde_type)

	if #var_17_30 > 0 then
		var_17_39.horde_spawns = {}
	end

	if #var_0_3 > 0 then
		var_17_39.cover_spawns = {}
	end

	if var_17_34 < var_17_2 then
		local var_17_40 = var_17_34
	end

	local var_17_41 = 0
	local var_17_42 = -1
	local var_17_43 = 1
	local var_17_44 = 0

	while var_17_42 ~= var_17_41 and var_17_41 < var_17_34 do
		var_17_42 = var_17_41

		local var_17_45 = var_17_37 - 0.05

		for iter_17_0 = 1, var_0_2 do
			local var_17_46 = var_0_0[iter_17_0][var_17_43]

			if var_17_46 then
				local var_17_47 = var_17_29[var_17_46]
				local var_17_48 = var_17_47 and arg_17_0:pop_random_any_breed() or arg_17_0:pop_random_horde_breed_only()

				if var_17_48 then
					var_17_39.horde_spawns[#var_17_39.horde_spawns + 1] = {
						num_to_spawn = 1,
						spawner = var_17_46,
						spawn_list = {
							var_17_48
						},
						hidden = var_17_47
					}
					var_17_41 = var_17_41 + 1
				end
			end

			local var_17_49 = var_0_1[iter_17_0][var_17_43]

			if var_17_49 then
				local var_17_50 = arg_17_0:pop_random_any_breed()

				if var_17_50 then
					var_17_39.cover_spawns[#var_17_39.cover_spawns + 1] = {
						num_to_spawn = 1,
						next_spawn_time = var_17_45,
						cover_point_unit = var_17_49,
						spawn_list = {
							var_17_50
						}
					}
					var_17_41 = var_17_41 + 1
					var_17_45 = var_17_45 + 0.1
				end
			end
		end

		var_17_43 = var_17_43 + 1
		var_17_44 = var_17_44 + 1

		if var_17_44 > 1000 then
			arg_17_0:execute_fallback("ambush", arg_17_3, "Ambush horde spawn failed A - no matching spawners found!", arg_17_1)

			return
		end
	end

	if var_17_41 < var_17_34 then
		local var_17_51 = var_17_34 - var_17_41
		local var_17_52 = 1
		local var_17_53 = var_17_39.horde_spawns and #var_17_39.horde_spawns or 0
		local var_17_54 = var_17_39.cover_spawns and #var_17_39.cover_spawns or 0
		local var_17_55 = 1
		local var_17_56 = 0

		while var_17_51 > 0 do
			local var_17_57
			local var_17_58

			if var_17_53 > 0 then
				local var_17_59 = var_17_39.horde_spawns[var_17_52]
				local var_17_60 = var_17_59.hidden and arg_17_0:pop_random_any_breed() or arg_17_0:pop_random_horde_breed_only()

				if var_17_60 then
					var_17_59.num_to_spawn = var_17_59.num_to_spawn + 1
					var_17_59.spawn_list[#var_17_59.spawn_list + 1] = var_17_60
					var_17_52 = var_17_52 % var_17_53 + 1
					var_17_51 = var_17_51 - 1

					if var_17_51 <= 0 then
						break
					end
				else
					var_17_52 = var_17_52 % var_17_53 + 1
				end
			end

			if var_17_54 > 0 then
				local var_17_61 = arg_17_0:pop_random_any_breed()

				if var_17_61 then
					local var_17_62 = var_17_39.cover_spawns[var_17_55]

					var_17_55 = var_17_55 % var_17_54 + 1
					var_17_62.num_to_spawn = var_17_62.num_to_spawn + 1
					var_17_62.spawn_list[#var_17_62.spawn_list + 1] = var_17_61
					var_17_51 = var_17_51 - 1

					if var_17_51 <= 0 then
						break
					end
				end
			end

			var_17_56 = var_17_56 + 1

			if var_17_56 > 1000 then
				arg_17_0:execute_fallback("ambush", arg_17_2, arg_17_3, "Ambush horde spawn failed B - no matching spawners found!", arg_17_1)

				return
			end
		end
	end

	if script_data.debug_player_intensity then
		arg_17_0.conflict_director.pacing:annotate_graph("(A)Horde:" .. var_17_34, "lime")
	end

	arg_17_0:_add_horde(var_17_39)

	arg_17_0.last_paced_horde_type = "ambush"
	arg_17_0.num_paced_hordes = arg_17_0.num_paced_hordes + 1

	print("ambush horde has started")
end

function HordeSpawner.replace_hidden_spawners(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_2.dont_move then
		return
	end

	local var_18_0 = Unit.local_position(arg_18_2.cover_point_unit, 0)
	local var_18_1 = 10
	local var_18_2 = 20
	local var_18_3 = arg_18_3
	local var_18_4 = var_0_3

	table.clear_array(var_18_4, #var_18_4)
	arg_18_0:hidden_cover_points(arg_18_0.cover_broadphase, var_18_0, {
		var_18_0
	}, var_18_4, var_18_1, var_18_2, var_18_3)

	local var_18_5 = #var_18_4

	print("replace_hidden_spawners -> first try found:", var_18_5, "cover points")

	if var_18_5 <= 0 then
		local var_18_6 = 0
		local var_18_7 = 30
		local var_18_8 = 20
		local var_18_9 = arg_18_0:get_point_on_main_path(var_18_3, var_18_8)

		if not var_18_9 then
			print("replace_hidden_spawners -> no alternate epicenter_pos found. failed! pos:", var_18_3)

			arg_18_2.dont_move = true

			return
		end

		table.clear_array(var_18_4, #var_18_4)
		arg_18_0:hidden_cover_points(arg_18_0.cover_broadphase, var_18_9, {
			var_18_9
		}, var_18_4, var_18_6, var_18_7, var_18_3)

		var_18_5 = #var_18_4

		print("replace_hidden_spawners -> second try try found:", var_18_5, "cover points")
	end

	if var_18_5 <= 0 then
		print("replace_hidden_spawners -> no alternate cover found. failed!")

		arg_18_2.dont_move = true

		return
	end

	print("replace_hidden_spawners -> replacing hidden spawners!")

	local var_18_10 = 1

	for iter_18_0 = 1, #arg_18_1 do
		local var_18_11 = arg_18_1[iter_18_0]

		if var_18_11.num_to_spawn > 0 then
			var_18_11.cover_point_unit = var_18_4[(var_18_10 - 1) % var_18_5 + 1]
			var_18_10 = var_18_10 + 1

			print("->moving spawner")
		end
	end

	return true
end

function HordeSpawner.find_vector_horde_spawners(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = CurrentHordeSettings.vector
	local var_19_1 = var_19_0.min_horde_spawner_dist
	local var_19_2 = var_19_0.max_horde_spawner_dist
	local var_19_3 = var_19_0.min_hidden_spawner_dist
	local var_19_4 = var_19_0.max_hidden_spawner_dist

	if script_data.debug_hordes then
		QuickDrawerStay:sphere(arg_19_1, 4, Color(240, 208, 100, 240))
	end

	local var_19_5 = arg_19_0.spawner_system:enabled_spawners()
	local var_19_6 = ConflictUtils.filter_positions(arg_19_1, arg_19_2, var_19_5, var_19_1, var_19_2)

	table.clear_array(var_0_3, #var_0_3)
	arg_19_0:hidden_cover_points(arg_19_0.cover_broadphase, arg_19_1, {
		arg_19_1
	}, var_0_3, var_19_3, var_19_4, arg_19_2)

	if #var_19_6 <= 0 and #var_0_3 <= 0 then
		return
	end

	return "success", var_19_6, var_0_3
end

function HordeSpawner.find_good_vector_horde_pos(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0
	local var_20_1
	local var_20_2
	local var_20_3 = arg_20_0:get_point_on_main_path(arg_20_1, arg_20_2, arg_20_3)

	if var_20_3 then
		var_20_0, var_20_1, var_20_2 = arg_20_0:find_vector_horde_spawners(var_20_3, arg_20_1)

		if not var_20_0 then
			var_20_3 = arg_20_0:get_point_on_main_path(arg_20_1, arg_20_2 + 10, arg_20_3)

			if var_20_3 then
				var_20_0, var_20_1, var_20_2 = arg_20_0:find_vector_horde_spawners(var_20_3, arg_20_1)
			end
		end
	else
		var_20_3 = arg_20_0:get_point_on_main_path(arg_20_1, arg_20_2 + 10, arg_20_3)

		if var_20_3 then
			var_20_0, var_20_1, var_20_2 = arg_20_0:find_vector_horde_spawners(var_20_3, arg_20_1)
		end
	end

	return var_20_0, var_20_1, var_20_2, var_20_3
end

function HordeSpawner.execute_vector_horde(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = CurrentHordeSettings.vector
	local var_21_1 = var_21_0.max_spawners
	local var_21_2 = arg_21_1 and arg_21_1.start_delay or var_21_0.start_delay
	local var_21_3 = arg_21_1 and arg_21_1.only_behind
	local var_21_4 = arg_21_1 and arg_21_1.silent
	local var_21_5 = Managers.state.side:get_side(arg_21_2).ENEMY_PLAYER_AND_BOT_POSITIONS

	print("setting up vector-horde")

	local var_21_6, var_21_7 = ConflictUtils.cluster_positions(var_21_5, 7)
	local var_21_8 = var_21_6[ConflictUtils.get_biggest_cluster(var_21_7)]
	local var_21_9
	local var_21_10
	local var_21_11
	local var_21_12
	local var_21_13
	local var_21_14 = arg_21_1 and arg_21_1.override_composition_type
	local var_21_15 = arg_21_1 and arg_21_1.optional_wave_composition

	if var_21_14 and CurrentHordeSettings.compositions[var_21_14] then
		local var_21_16 = CurrentHordeSettings.compositions[var_21_14]
		local var_21_17, var_21_18 = Managers.state.difficulty:get_difficulty_rank()

		var_21_13 = var_21_16[DifficultyTweak.converters.composition_rank(var_21_17, var_21_18) - 1]

		fassert(var_21_13.loaded_probs, " Vector horde override type %s is missing loaded probabilty table!", var_21_14)

		var_21_12 = var_21_14
	elseif var_21_15 then
		local var_21_19 = HordeWaveCompositions[var_21_15]

		var_21_12 = var_21_19[math.random(#var_21_19)]
	else
		var_21_12 = CurrentHordeSettings.vector_composition or "medium"
	end

	assert(var_21_12, "Vector Horde missing composition_type")

	local var_21_20 = var_21_13 or CurrentHordeSettings.compositions_pacing[var_21_12]
	local var_21_21 = var_21_20[LoadedDice.roll_easy(var_21_20.loaded_probs)]

	print("Composing horde '" .. var_21_12 .. "' .. using variant '" .. var_21_21.name .. "'")

	local var_21_22

	if not var_21_8 then
		arg_21_0:execute_fallback("vector", arg_21_2, arg_21_3, "WARNING: vector horde could not find an main_target_pos, use fallback instead", arg_21_1)

		return
	end

	local var_21_23 = math.random()
	local var_21_24 = not var_21_3 and var_21_23 <= var_21_0.main_path_chance_spawning_ahead
	local var_21_25 = true
	local var_21_26 = var_21_0.main_path_dist_from_players

	if not var_21_24 then
		var_21_26 = -var_21_26
	end

	print("--> horde wants to " .. (var_21_24 and "spawn ahead of players" or "spawn behind players") .. " (" .. var_21_23 .. "/" .. var_21_0.main_path_chance_spawning_ahead)

	local var_21_27, var_21_28, var_21_29, var_21_30 = arg_21_0:find_good_vector_horde_pos(var_21_8, var_21_26, var_21_25)

	if not var_21_27 and not var_21_3 then
		var_21_24 = not var_21_24

		print("--> can't find spawners in this direction, switching to " .. (var_21_24 and "ahead" or "behind"))

		var_21_27, var_21_28, var_21_29, var_21_30 = arg_21_0:find_good_vector_horde_pos(var_21_8, -var_21_26, var_21_25)
	end

	if not var_21_27 then
		arg_21_0:execute_fallback("vector", arg_21_3, "vector horde could not find an epicenter or spawners, use fallback instead", arg_21_1)

		return
	end

	local var_21_31, var_21_32, var_21_33 = arg_21_0:compose_horde_spawn_list(var_21_21)

	print("-> spawning:", var_21_31)

	local var_21_34 = Managers.state.entity:system("ai_group_system"):generate_group_id()
	local var_21_35 = {
		template = "horde",
		id = var_21_34,
		size = var_21_31,
		sneaky = var_21_24,
		group_data = arg_21_1
	}
	local var_21_36 = Managers.time:time("game")
	local var_21_37 = var_21_20.sound_settings
	local var_21_38 = {
		horde_type = "vector",
		spawned = 0,
		num_to_spawn = var_21_31,
		main_target_pos = Vector3Box(var_21_8),
		epicenter_pos = Vector3Box(var_21_30),
		start_time = var_21_36 + var_21_2,
		group_template = var_21_35,
		sound_settings = var_21_37,
		group_id = var_21_34,
		side_id = arg_21_2,
		silent = var_21_4
	}

	print("horde crated with id", var_21_34, "of type ", var_21_38.horde_type)

	local var_21_39 = #var_21_28
	local var_21_40 = #var_21_29

	if var_21_39 > 0 then
		var_21_38.horde_spawns = {}

		var_0_7(var_21_28, var_0_4)
	end

	if var_21_40 > 0 then
		var_21_38.cover_spawns = {}

		var_0_7(var_21_29, var_0_5)
	end

	if var_21_31 < var_21_1 then
		var_21_1 = var_21_31
	end

	local var_21_41 = var_21_39 + var_21_40

	if var_21_41 < var_21_1 then
		var_21_1 = var_21_41
	end

	local var_21_42 = arg_21_0.spawner_system:hidden_spawners_lookup()
	local var_21_43 = 0
	local var_21_44 = var_21_31 / var_21_1
	local var_21_45 = math.floor(var_21_44)
	local var_21_46 = var_21_44
	local var_21_47 = 0
	local var_21_48
	local var_21_49 = var_21_38.horde_spawns

	for iter_21_0 = 1, var_21_39 do
		local var_21_50 = var_0_4[iter_21_0]
		local var_21_51 = var_21_42[var_21_50]
		local var_21_52 = var_21_51 and arg_21_0:pop_random_any_breed() or arg_21_0:pop_random_horde_breed_only()

		var_21_49[#var_21_49 + 1] = {
			num_to_spawn = 1,
			spawner = var_21_50,
			spawn_list = {
				var_21_52
			},
			hidden = var_21_51
		}
		var_21_47 = var_21_47 + 1
	end

	local var_21_53 = var_21_36 - 0.05
	local var_21_54 = var_21_38.cover_spawns

	for iter_21_1 = 1, var_21_40 do
		if var_21_31 <= var_21_47 then
			break
		end

		local var_21_55 = var_0_5[iter_21_1]
		local var_21_56 = arg_21_0:pop_random_any_breed()

		var_21_54[#var_21_54 + 1] = {
			num_to_spawn = 1,
			next_spawn_time = var_21_53,
			cover_point_unit = var_21_55,
			spawn_list = {
				var_21_56
			}
		}
		var_21_47 = var_21_47 + 1
		var_21_53 = var_21_53 + 0.1
	end

	local var_21_57 = 0

	while var_21_47 < var_21_31 do
		for iter_21_2 = 1, var_21_39 do
			local var_21_58 = var_21_49[iter_21_2]
			local var_21_59 = var_21_58.hidden and arg_21_0:pop_random_any_breed() or arg_21_0:pop_random_horde_breed_only()

			if not var_21_59 then
				break
			end

			local var_21_60 = var_21_58.spawn_list

			var_21_58.num_to_spawn = var_21_58.num_to_spawn + 1
			var_21_60[#var_21_60 + 1] = var_21_59
			var_21_47 = var_21_47 + 1
		end

		for iter_21_3 = 1, var_21_40 do
			local var_21_61 = arg_21_0:pop_random_any_breed()

			if not var_21_61 then
				break
			end

			local var_21_62 = var_21_54[iter_21_3]
			local var_21_63 = var_21_62.spawn_list

			var_21_63[#var_21_63 + 1] = var_21_61
			var_21_62.num_to_spawn = var_21_62.num_to_spawn + 1
			var_21_47 = var_21_47 + 1
		end

		if var_21_47 == var_21_48 then
			if var_21_47 == 0 then
				arg_21_0:execute_fallback("vector", arg_21_2, arg_21_3, "Vector horde spawn failed A - no matching spawners found!", arg_21_1)

				return
			end

			break
		end

		var_21_48 = var_21_47
		var_21_57 = var_21_57 + 1

		if var_21_57 > 1000 then
			arg_21_0:execute_fallback("vector", arg_21_2, arg_21_3, "Vector horde spawn failed B - no matching spawners found!", arg_21_1)

			return
		end
	end

	local var_21_64 = arg_21_0.conflict_director

	if script_data.debug_player_intensity then
		var_21_64.pacing:annotate_graph("(V)Horde:" .. var_21_31, "lime")
	end

	arg_21_0:_add_horde(var_21_38)

	local var_21_65 = arg_21_1 and arg_21_1.horde_wave

	if not var_21_4 and (var_21_65 == "multi_first_wave" or var_21_65 == "single") then
		local var_21_66 = var_21_37.stinger_sound_event or "enemy_horde_stinger"

		arg_21_0:play_sound(var_21_66, var_21_38.epicenter_pos:unbox())
	end

	arg_21_0.last_paced_horde_type = "vector"
	arg_21_0.num_paced_hordes = arg_21_0.num_paced_hordes + 1
	var_21_38.is_done_spawning = false

	print("vector horde has started")
end

function HordeSpawner.execute_custom_horde(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = CurrentHordeSettings.vector_blob
	local var_22_1 = math.random()
	local var_22_2 = arg_22_2 or var_22_1 <= var_22_0.main_path_chance_spawning_ahead

	print("wants to spawn " .. (var_22_2 and "ahead" or "behind") .. " within distance: ", var_22_0.main_path_dist_from_players)

	local var_22_3, var_22_4, var_22_5 = arg_22_0:get_pos_ahead_or_behind_players_on_mainpath(var_22_2, var_22_0.main_path_dist_from_players, var_22_0.raw_dist_from_players, arg_22_3)

	if not var_22_3 then
		local var_22_6, var_22_7, var_22_8 = arg_22_0:get_pos_ahead_or_behind_players_on_mainpath(not var_22_2, var_22_0.main_path_dist_from_players, var_22_0.raw_dist_from_players, arg_22_3)

		var_22_5 = var_22_8
		var_22_4 = var_22_7

		if not var_22_6 then
			local var_22_9 = math.random() <= var_22_0.main_path_chance_spawning_ahead
			local var_22_10 = 20
			local var_22_11

			var_22_11, var_22_4, var_22_5 = arg_22_0:get_pos_ahead_or_behind_players_on_mainpath(var_22_9, var_22_0.main_path_dist_from_players + var_22_10, var_22_0.raw_dist_from_players, arg_22_3)
		end
	end

	if not var_22_4 then
		print("\no spawn position found at all, failing horde")

		return
	end

	local var_22_12 = #arg_22_1
	local var_22_13 = 6
	local var_22_14 = 0
	local var_22_15 = Quaternion.look(Vector3(var_22_5.x, var_22_5.y, 1))
	local var_22_16 = 8
	local var_22_17 = arg_22_0.conflict_director
	local var_22_18 = var_22_17.nav_world

	for iter_22_0 = 1, var_22_12 do
		local var_22_19

		for iter_22_1 = 1, var_22_16 do
			local var_22_20

			if iter_22_1 == 1 then
				var_22_20 = Vector3(-var_22_13 / 2 + iter_22_0 % var_22_13, -var_22_13 / 2 + math.floor(iter_22_0 / var_22_13), 0)
			else
				var_22_20 = Vector3(4 * math.random() - 2, 4 * math.random() - 2, 0)
			end

			local var_22_21 = LocomotionUtils.pos_on_mesh(var_22_18, var_22_4 + var_22_20 * 2)

			if var_22_21 then
				local var_22_22 = Breeds[arg_22_1[iter_22_0]]
				local var_22_23 = {
					side_id = arg_22_3
				}

				var_22_17:spawn_queued_unit(var_22_22, Vector3Box(var_22_21), QuaternionBox(var_22_15), "hidden_spawn", nil, "horde_hidden", var_22_23, nil)

				var_22_14 = var_22_14 + 1

				break
			end
		end
	end

	print("custom blob horde has started")
end

function HordeSpawner.get_pos_ahead_or_behind_players_on_mainpath(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = Managers.state.conflict
	local var_23_1 = var_23_0.main_path_info
	local var_23_2 = arg_23_1 and var_23_1.ahead_unit or var_23_1.behind_unit
	local var_23_3
	local var_23_4
	local var_23_5 = true

	if var_23_2 then
		local var_23_6 = var_23_0.main_path_player_info[var_23_2].travel_dist + arg_23_2 * (arg_23_1 and 1 or -1)

		if var_23_6 < 0 then
			return false
		end

		local var_23_7, var_23_8 = MainPathUtils.point_on_mainpath(nil, var_23_6)

		if var_23_7 then
			var_23_4, var_23_3 = POSITION_LOOKUP[var_23_2] - var_23_7, var_23_7
		end
	end

	if var_23_3 then
		local var_23_9 = Managers.state.side:get_side(arg_23_4).ENEMY_PLAYER_POSITIONS
		local var_23_10 = Vector3(0, 0, 1)

		for iter_23_0 = 1, #var_23_9 do
			local var_23_11 = var_23_9[iter_23_0]

			if PerceptionUtils.position_has_line_of_sight_to_any_player(var_23_3 + var_23_10) then
				var_23_5 = false

				print("Horde spawn position is within line of sight of players, aborting")

				break
			end
		end
	end

	local var_23_12 = false

	if var_23_5 and var_23_4 and arg_23_3 < Vector3.length(var_23_4) then
		var_23_12 = true
	end

	if var_23_5 and var_23_12 then
		return true, var_23_3, var_23_4
	else
		return false
	end
end

function HordeSpawner.execute_vector_blob_horde(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = CurrentHordeSettings.vector_blob
	local var_24_1 = math.random() <= var_24_0.main_path_chance_spawning_ahead

	print("wants to spawn " .. (var_24_1 and "ahead" or "behind") .. " within distance: ", var_24_0.main_path_dist_from_players)

	local var_24_2, var_24_3, var_24_4 = arg_24_0:get_pos_ahead_or_behind_players_on_mainpath(var_24_1, var_24_0.main_path_dist_from_players, var_24_0.raw_dist_from_players, arg_24_2)

	if not var_24_2 then
		print("\tcould not, tries to spawn" .. (not var_24_1 and "ahead" or "behind"))

		local var_24_5, var_24_6, var_24_7 = arg_24_0:get_pos_ahead_or_behind_players_on_mainpath(not var_24_1, var_24_0.main_path_dist_from_players, var_24_0.raw_dist_from_players, arg_24_2)

		var_24_4 = var_24_7
		var_24_3 = var_24_6

		if not var_24_5 then
			local var_24_8 = math.random() <= var_24_0.main_path_chance_spawning_ahead
			local var_24_9 = 20
			local var_24_10

			var_24_10, var_24_3, var_24_4 = arg_24_0:get_pos_ahead_or_behind_players_on_mainpath(var_24_8, var_24_0.main_path_dist_from_players + var_24_9, var_24_0.raw_dist_from_players, arg_24_2)
		end
	end

	if not var_24_3 then
		print("\no spawn position found at all, failing horde")

		return
	end

	local var_24_11
	local var_24_12 = arg_24_1 and arg_24_1.optional_wave_composition

	if var_24_12 then
		local var_24_13 = HordeWaveCompositions[var_24_12]

		var_24_11 = var_24_13[math.random(#var_24_13)]
	else
		var_24_11 = arg_24_1 and arg_24_1.override_composition_type or CurrentHordeSettings.vector_composition or "medium"
	end

	assert(var_24_11, "Vector Blob Horde missing composition_type")

	local var_24_14 = CurrentHordeSettings.compositions_pacing[var_24_11]
	local var_24_15
	local var_24_16

	if arg_24_1 and arg_24_1.spawn_list then
		var_24_16 = #arg_24_1.spawn_list
		var_24_15 = arg_24_1.spawn_list
	else
		var_24_15, var_24_16 = arg_24_0:compose_blob_horde_spawn_list(var_24_11)
	end

	local var_24_17 = Managers.state.entity:system("ai_group_system"):generate_group_id()
	local var_24_18 = {
		template = "horde",
		id = var_24_17,
		size = var_24_16,
		sneaky = var_24_1,
		group_data = arg_24_1
	}
	local var_24_19 = Managers.time:time("game")
	local var_24_20 = var_24_14.sound_settings
	local var_24_21 = {
		horde_type = "vector_blob",
		spawned = 0,
		num_to_spawn = var_24_16,
		epicenter_pos = Vector3Box(var_24_3),
		start_time = var_24_19 + var_24_0.start_delay,
		group_template = var_24_18,
		sound_settings = var_24_20,
		group_id = var_24_17
	}

	print("horde crated with id", var_24_17, "of type ", var_24_21.horde_type)

	local var_24_22 = 6
	local var_24_23 = 0
	local var_24_24 = Quaternion.look(Vector3(var_24_4.x, var_24_4.y, 1))
	local var_24_25 = 8
	local var_24_26 = arg_24_0.conflict_director
	local var_24_27 = var_24_26.nav_world

	for iter_24_0 = 1, var_24_16 do
		local var_24_28

		for iter_24_1 = 1, var_24_25 do
			local var_24_29

			if iter_24_1 == 1 then
				var_24_29 = Vector3(-var_24_22 / 2 + iter_24_0 % var_24_22, -var_24_22 / 2 + math.floor(iter_24_0 / var_24_22), 0)
			else
				var_24_29 = Vector3(4 * math.random() - 2, 4 * math.random() - 2, 0)
			end

			local var_24_30 = LocomotionUtils.pos_on_mesh(var_24_27, var_24_3 + var_24_29 * 2)

			if var_24_30 then
				local var_24_31 = Breeds[var_24_15[iter_24_0]]
				local var_24_32 = {
					side_id = arg_24_2
				}

				var_24_26:spawn_queued_unit(var_24_31, Vector3Box(var_24_30), QuaternionBox(var_24_24), "hidden_spawn", nil, "horde_hidden", var_24_32, var_24_18)

				var_24_23 = var_24_23 + 1

				break
			end
		end
	end

	var_24_26:add_horde(var_24_23)

	var_24_21.spawned = var_24_23

	print("managed to spawn " .. tostring(var_24_23) .. "/" .. tostring(var_24_16) .. " horde enemies")

	local var_24_33 = arg_24_0.conflict_director

	if script_data.debug_player_intensity then
		var_24_33.pacing:annotate_graph("(B)Horde:" .. var_24_23 .. "/" .. var_24_16, "lime")
	end

	local var_24_34 = arg_24_1 and arg_24_1.horde_wave

	if var_24_34 == "multi_first_wave" or var_24_34 == "single" then
		local var_24_35 = var_24_20.stinger_sound_event or "enemy_horde_stinger"

		arg_24_0:play_sound(var_24_35, var_24_21.epicenter_pos:unbox())
	end

	arg_24_0:_add_horde(var_24_21)

	arg_24_0.last_paced_horde_type = "vector_blob"
	arg_24_0.num_paced_hordes = arg_24_0.num_paced_hordes + 1

	print("vector blob horde has started")
end

function HordeSpawner.spawn_unit(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = arg_25_1.cover_point_unit
	local var_25_1 = Unit.local_position(var_25_0, 0)
	local var_25_2 = arg_25_3 - var_25_1
	local var_25_3 = Quaternion.look(Vector3(var_25_2.x, var_25_2.y, 1))
	local var_25_4 = "horde_hidden"
	local var_25_5 = "hidden_spawn"
	local var_25_6 = Breeds[arg_25_2]
	local var_25_7 = arg_25_4.optional_data or {}

	var_25_7.side_id = arg_25_4.side_id

	local var_25_8

	arg_25_0.conflict_director:spawn_queued_unit(var_25_6, Vector3Box(var_25_1), QuaternionBox(var_25_3), var_25_5, var_25_8, var_25_4, var_25_7, arg_25_4.group_template)
	arg_25_0.conflict_director:add_horde(1)
end

function HordeSpawner.play_sound(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = Managers.world:wwise_world(arg_26_0.world)
	local var_26_1, var_26_2 = WwiseWorld.trigger_event(var_26_0, arg_26_1, arg_26_2)

	Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_event_at_pos", NetworkLookup.sound_events[arg_26_1], arg_26_2)
end

function HordeSpawner.create_event_horde_no_horde_spawners(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = Managers.state.conflict
	local var_27_1 = var_27_0.main_path_info.behind_unit

	if var_27_1 then
		local var_27_2 = 0
		local var_27_3 = var_27_0.main_path_player_info[var_27_1].travel_dist - 45
		local var_27_4, var_27_5 = MainPathUtils.point_on_mainpath(nil, var_27_3)
		local var_27_6 = Managers.state.side:get_side(arg_27_4).ENEMY_PLAYER_POSITIONS
		local var_27_7, var_27_8 = ConflictUtils.hidden_cover_points(var_27_4, var_27_6, 0, 10)

		if var_27_7 > 0 then
			local var_27_9 = var_27_8[math.random(1, var_27_7)]
			local var_27_10 = {}

			arg_27_1.cover_spawns = {
				num_to_spawn = 0,
				next_spawn_time = arg_27_3,
				cover_point_unit = var_27_9,
				spawn_list = var_27_10
			}

			local var_27_11 = Managers.state.difficulty.difficulty
			local var_27_12 = arg_27_2.difficulty_breeds
			local var_27_13 = var_27_12 and var_27_12[var_27_11] or arg_27_2.breeds

			for iter_27_0 = 1, #var_27_13, 2 do
				local var_27_14 = var_27_13[iter_27_0]
				local var_27_15 = var_27_13[iter_27_0 + 1]
				local var_27_16 = type(var_27_15) == "table" and Math.random(var_27_15[1], var_27_15[2]) or var_27_15

				if script_data.big_hordes then
					var_27_16 = math.round(var_27_16 * (tonumber(script_data.big_hordes) or 1))
				end

				for iter_27_1 = 1, var_27_16 do
					var_27_10[#var_27_10 + 1] = var_27_14
				end

				var_27_2 = var_27_2 + var_27_16
			end

			arg_27_1.num_to_spawn = var_27_2
			arg_27_1.spawned = 0

			return true, var_27_2
		end
	end

	return false
end

function HordeSpawner.update_event_horde_no_horde_spawners(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_1.started then
		if arg_28_2 > arg_28_1.start_time then
			local var_28_0, var_28_1 = arg_28_0:create_event_horde_no_horde_spawners(arg_28_1, arg_28_1.variant, arg_28_2, arg_28_1.side_id)

			if var_28_0 then
				arg_28_1.started = true
				arg_28_1.amount = var_28_1
			else
				arg_28_1.failed = true

				print("event horde failed")

				return true
			end
		end
	else
		return arg_28_0:update_horde(arg_28_1, arg_28_2)
	end

	return false
end

function HordeSpawner.update_event_horde(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_1.started then
		if arg_29_2 > arg_29_1.start_time then
			local var_29_0, var_29_1 = arg_29_0.spawner_system:spawn_horde_from_terror_event_ids(arg_29_1.terror_event_ids, arg_29_1.variant, arg_29_1.limit_spawners, arg_29_1.group_template, arg_29_1.strictly, arg_29_1.side_id, arg_29_1.use_closest_spawners, arg_29_1.source_unit, arg_29_1.optional_data)

			if var_29_0 then
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

function HordeSpawner.spawner_in_view_of_players(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_3 = arg_30_3 or Unit.local_position(arg_30_1.cover_point_unit, 0) + Vector3(0, 0, 1)

	local var_30_0 = Managers.state.side:get_side(arg_30_2).ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_30_1 = Vector3.up()

	for iter_30_0 = 1, #var_30_0 do
		local var_30_2 = var_30_0[iter_30_0] + Vector3(0, 0, 1)
		local var_30_3 = var_30_2 - arg_30_3
		local var_30_4 = Vector3.length(var_30_3)

		if var_30_4 < 3 then
			return var_30_2
		end

		if var_30_4 < 30 then
			local var_30_5 = Vector3.normalize(var_30_3)
			local var_30_6, var_30_7, var_30_8, var_30_9, var_30_10 = PhysicsWorld.immediate_raycast(arg_30_0.physics_world, arg_30_3 + var_30_1, var_30_5, var_30_4, "collision_filter", "filter_ai_line_of_sight_check")

			if not var_30_6 then
				return var_30_2
			end
		end
	end
end

function HordeSpawner.update_horde(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_1.started then
		if arg_31_2 > arg_31_1.start_time then
			local var_31_0 = arg_31_1.horde_spawns

			if var_31_0 then
				local var_31_1 = {}

				for iter_31_0 = 1, #var_31_0 do
					local var_31_2 = var_31_0[iter_31_0]
					local var_31_3 = var_31_2.spawner
					local var_31_4 = Unit.local_position(var_31_3, 0)

					if arg_31_0:spawner_in_view_of_players(nil, arg_31_1.side_id, var_31_4) then
						table.append(var_31_1, var_31_2.spawn_list)

						var_31_0[iter_31_0] = nil
					end
				end

				local var_31_5 = {}

				for iter_31_1 = 1, #var_31_0 do
					local var_31_6 = var_31_0[iter_31_1]

					if var_31_6 then
						local var_31_7 = var_31_6.spawner
						local var_31_8 = var_31_6.spawn_list

						if #var_31_1 > 0 then
							table.append(var_31_8, var_31_1)

							var_31_1 = {}
							var_31_6.num_to_spawn = #var_31_8
						end

						var_31_6.all_done_spawned_time = arg_31_2 + 1 / arg_31_0.spawner_system:spawn_horde(var_31_7, var_31_8, arg_31_1.side_id, arg_31_1.group_template, arg_31_1.optional_data) * var_31_6.num_to_spawn
						var_31_5[#var_31_5 + 1] = var_31_6
					end
				end

				arg_31_1.horde_spawns = var_31_5
			end

			arg_31_1.started = true
		else
			return
		end
	end

	local var_31_9 = true
	local var_31_10 = arg_31_1.horde_spawns

	if var_31_10 then
		for iter_31_2 = 1, #var_31_10 do
			local var_31_11 = var_31_10[iter_31_2]

			if not var_31_11.done then
				if arg_31_2 > var_31_11.all_done_spawned_time then
					var_31_11.done = true
					arg_31_1.spawned = arg_31_1.spawned + var_31_11.num_to_spawn
				end

				var_31_9 = false
			end
		end
	end

	local var_31_12 = arg_31_1.cover_spawns

	if var_31_12 then
		for iter_31_3 = 1, #var_31_12 do
			local var_31_13 = var_31_12[iter_31_3]

			if var_31_13.num_to_spawn > 0 then
				var_31_9 = false

				if arg_31_2 > var_31_13.next_spawn_time then
					local var_31_14 = arg_31_0:spawner_in_view_of_players(var_31_13, arg_31_1.side_id)

					if var_31_14 then
						if arg_31_0:replace_hidden_spawners(var_31_12, var_31_13, var_31_14) then
							break
						else
							local var_31_15 = var_31_12[iter_31_3 == #var_31_12 and 1 or iter_31_3 + 1]

							var_31_15.num_to_spawn = var_31_15.num_to_spawn + var_31_13.num_to_spawn

							table.append(var_31_15.spawn_list, var_31_13.spawn_list)
							table.clear(var_31_13.spawn_list)

							var_31_13.num_to_spawn = 0

							print("Spawner visible and can't replace it. Using the next spawner in the list")
						end
					else
						local var_31_16 = var_0_11(var_31_13.spawn_list)

						arg_31_0:spawn_unit(var_31_13, var_31_16, arg_31_1.main_target_pos:unbox(), arg_31_1)

						arg_31_1.spawned = arg_31_1.spawned + 1
						var_31_13.num_to_spawn = var_31_13.num_to_spawn - 1
						var_31_13.next_spawn_time = var_31_13.next_spawn_time + 1
					end
				end
			end
		end
	end

	local var_31_17 = arg_31_1.spawned >= arg_31_1.num_to_spawn or var_31_9
	local var_31_18 = arg_31_1.is_done_spawning
	local var_31_19 = arg_31_1.horde_type == "vector" or arg_31_1.horde_type == "ambush"

	if var_31_17 or not var_31_19 and not var_31_18 then
		return true
	end
end

function HordeSpawner.update(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0.hordes
	local var_32_1 = #var_32_0

	arg_32_0._running_horde_type = nil
	arg_32_0._running_horde_sound_settings = nil

	local var_32_2 = 1

	while var_32_2 <= var_32_1 do
		local var_32_3 = var_32_0[var_32_2]
		local var_32_4

		if var_32_3.horde_type == "vector_blob" then
			if not var_32_3.silent then
				arg_32_0._running_horde_type = var_32_3.horde_type
				arg_32_0._running_horde_sound_settings = var_32_3.sound_settings
			end

			var_32_4 = true
		elseif var_32_3.horde_type == "vector" or var_32_3.horde_type == "ambush" then
			if not var_32_3.silent then
				arg_32_0._running_horde_type = var_32_3.horde_type
				arg_32_0._running_horde_sound_settings = var_32_3.sound_settings
			end

			var_32_4 = arg_32_0:update_horde(var_32_3, arg_32_1)
		elseif var_32_3.horde_type == "event" then
			var_32_4 = arg_32_0:update_event_horde(var_32_3, arg_32_1)

			if not var_32_3.silent then
				arg_32_0._running_horde_type = "event"
				arg_32_0._running_horde_sound_settings = var_32_3.sound_settings
			end
		else
			var_32_4 = arg_32_0:update_event_horde_no_horde_spawners(var_32_3, arg_32_1)

			if not var_32_3.silent then
				arg_32_0._running_horde_type = "event"
				arg_32_0._running_horde_sound_settings = var_32_3.sound_settings
			end
		end

		if var_32_4 then
			var_32_0[var_32_2] = var_32_0[var_32_1]
			var_32_0[var_32_1] = nil
			var_32_1 = var_32_1 - 1
		else
			var_32_2 = var_32_2 + 1
		end
	end

	if script_data.debug_hordes then
		arg_32_0:debug_hordes(arg_32_1)
	end
end

function HordeSpawner.set_horde_has_spawned(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0.hordes

	for iter_33_0 = 1, #var_33_0 do
		local var_33_1 = var_33_0[iter_33_0]
		local var_33_2 = var_33_1.group_id

		if var_33_2 and var_33_2 == arg_33_1 then
			var_33_1.is_done_spawning = true
		end
	end
end

function HordeSpawner.set_horde_is_done(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.hordes

	for iter_34_0 = 1, #var_34_0 do
		local var_34_1 = var_34_0[iter_34_0]
		local var_34_2 = var_34_1.group_id

		if var_34_2 and var_34_2 == arg_34_1 then
			var_34_1.is_dead = true
		end
	end
end

function HordeSpawner.debug_hordes(arg_35_0, arg_35_1)
	local var_35_0 = "Hordes - now: " .. arg_35_0.conflict_director:horde_size() .. " (" .. tostring(arg_35_0._running_horde_type or "none") .. ") "
	local var_35_1 = arg_35_0.hordes

	for iter_35_0 = 1, #var_35_1 do
		local var_35_2 = var_35_1[iter_35_0]
		local var_35_3 = var_35_2.horde_type
		local var_35_4 = var_35_2.silent

		var_35_0 = var_35_0 .. "| " .. var_35_3 .. (var_35_2.silent and "(silent), " or "") .. " |"
	end

	Debug.text(var_35_0)
end

local var_0_13 = {}

function HordeSpawner.hidden_cover_points(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
	local var_36_0 = Vector3.distance_squared
	local var_36_1 = Vector3.normalize
	local var_36_2 = Vector3.dot
	local var_36_3 = Quaternion.forward
	local var_36_4 = Unit.local_position
	local var_36_5 = Unit.local_rotation

	table.clear_array(var_0_13, #var_0_13)

	local var_36_6 = #arg_36_3
	local var_36_7 = 0
	local var_36_8 = Broadphase.query(arg_36_1, arg_36_2, arg_36_6, var_0_13)
	local var_36_9 = arg_36_7 and var_36_0(arg_36_3[1], arg_36_7)

	arg_36_5 = arg_36_5 * arg_36_5
	arg_36_6 = arg_36_6 * arg_36_6

	for iter_36_0 = 1, var_36_8 do
		local var_36_10 = var_0_13[iter_36_0]
		local var_36_11 = var_36_4(var_36_10, 0)
		local var_36_12 = true

		if arg_36_7 and var_36_9 > var_36_0(var_36_11, arg_36_7) then
			var_36_12 = false
		end

		if var_36_12 then
			for iter_36_1 = 1, var_36_6 do
				local var_36_13 = arg_36_3[iter_36_1]
				local var_36_14 = var_36_0(var_36_11, var_36_13)

				if arg_36_5 <= var_36_14 and var_36_14 <= arg_36_6 then
					local var_36_15 = var_36_5(var_36_10, 0)
					local var_36_16 = var_36_1(var_36_11 - arg_36_2)

					if (var_36_14 < 625 and -0.9 or -0.6) > var_36_2(var_36_3(var_36_15), var_36_16) then
						var_36_7 = var_36_7 + 1
						arg_36_4[var_36_7] = var_36_10
					end
				end
			end
		end
	end
end

function HordeSpawner.calc_sectors(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = Unit.local_position
	local var_37_1 = Vector3.normalize
	local var_37_2 = math.atan2
	local var_37_3 = math.pi

	for iter_37_0 = 1, #arg_37_2 do
		local var_37_4 = arg_37_2[iter_37_0]
		local var_37_5 = var_37_0(var_37_4, 0)
		local var_37_6 = var_37_1(var_37_5 - arg_37_1)
		local var_37_7 = var_37_2(var_37_6.y, var_37_6.x)
		local var_37_8 = arg_37_3[math.max(1, math.ceil((var_37_7 + var_37_3) / (2 * var_37_3) * var_0_2))]

		var_37_8[#var_37_8 + 1] = var_37_4
	end
end

function HordeSpawner.render_sectors(arg_38_0, arg_38_1)
	local var_38_0 = Unit.local_position
	local var_38_1 = {
		Color(255, 255, 0, 0),
		Color(255, 255, 128, 0),
		Color(255, 0, 255, 0),
		Color(255, 128, 255, 0),
		Color(255, 0, 0, 255),
		Color(255, 0, 128, 255),
		Color(255, 0, 255, 255),
		Color(255, 255, 0, 255)
	}

	for iter_38_0 = 1, var_0_2 do
		local var_38_2 = arg_38_1[iter_38_0]
		local var_38_3 = var_38_1[iter_38_0]

		print("Sector:", iter_38_0, "size:", #var_38_2)

		for iter_38_1 = 1, #var_38_2 do
			local var_38_4 = var_38_2[iter_38_1]
			local var_38_5 = var_38_0(var_38_4, 0)

			QuickDrawerStay:sphere(var_38_5, 2, var_38_3)
		end
	end
end

function HordeSpawner.reset_sectors(arg_39_0, arg_39_1)
	for iter_39_0 = 1, var_0_2 do
		local var_39_0 = arg_39_1[iter_39_0]

		for iter_39_1 = 1, #var_39_0 do
			var_39_0[iter_39_1] = nil
		end
	end
end

function test_sectors()
	local var_40_0 = Unit.local_position
	local var_40_1 = Vector3.normalize
	local var_40_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local var_40_3 = var_40_0(var_40_2[1], 0)
	local var_40_4 = {
		Color(255, 255, 0, 0),
		Color(255, 255, 128, 0),
		Color(255, 0, 255, 0),
		Color(255, 128, 255, 0),
		Color(255, 0, 0, 255),
		Color(255, 0, 128, 255),
		Color(255, 0, 255, 255),
		Color(255, 255, 0, 255)
	}
	local var_40_5 = math.pi

	for iter_40_0 = 1, 300 do
		local var_40_6 = Vector3(math.random(-30, 30), math.random(-30, 30), 1)

		print("xapa:", iter_40_0, var_40_6, var_40_3)

		local var_40_7 = var_40_3 + var_40_6
		local var_40_8 = var_40_1(var_40_7 - var_40_3)
		local var_40_9 = math.atan2(var_40_8.y, var_40_8.x)
		local var_40_10 = math.max(1, math.ceil((var_40_9 + var_40_5) / (2 * var_40_5) * var_0_2))

		if var_40_10 <= var_0_2 then
			QuickDrawerStay:sphere(var_40_7, 1.2, var_40_4[var_40_10])
		else
			print("BAd sector index: ", var_40_10)
		end
	end
end

function HordeSpawner.filter_dist(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	local var_41_0 = Vector3.distance_squared
	local var_41_1 = #arg_41_2
	local var_41_2 = 1

	while var_41_2 <= var_41_1 do
		local var_41_3 = arg_41_2[var_41_2]
		local var_41_4 = var_41_0(arg_41_1, var_41_3)

		if arg_41_3 <= var_41_4 and var_41_4 <= arg_41_4 then
			var_41_2 = var_41_2 + 1
		else
			arg_41_2[var_41_2] = arg_41_2[var_41_1]
			var_41_1 = var_41_1 - 1
		end
	end
end

function HordeSpawner.filter_angle(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	arg_42_3 = arg_42_3 or -0.9

	local var_42_0 = Vector3.normalize
	local var_42_1 = Vector3.dot
	local var_42_2 = Quaternion.forward
	local var_42_3 = #arg_42_2
	local var_42_4 = 1

	while var_42_4 <= var_42_3 do
		local var_42_5 = arg_42_2[var_42_4]
		local var_42_6 = Unit.local_rotation(var_42_5, 0)
		local var_42_7 = var_42_0(pos - arg_42_1)

		if arg_42_3 > var_42_1(var_42_2(var_42_6), var_42_7) then
			var_42_4 = var_42_4 + 1
		else
			arg_42_2[var_42_4] = arg_42_2[var_42_3]
			var_42_3 = var_42_3 - 1
		end
	end
end

function HordeSpawner.get_point_on_main_path(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = arg_43_0.conflict_director.level_analysis:get_main_paths()
	local var_43_1, var_43_2 = MainPathUtils.closest_pos_at_main_path(var_43_0, arg_43_1)
	local var_43_3 = MainPathUtils.point_on_mainpath(var_43_0, var_43_2 + arg_43_2)

	if false and arg_43_3 then
		return Managers.state.conflict.navigation_group_manager:a_star_cached_between_positions(arg_43_1, var_43_3) and var_43_3
	end

	return var_43_3
end
