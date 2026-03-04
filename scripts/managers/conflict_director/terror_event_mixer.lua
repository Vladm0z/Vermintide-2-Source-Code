-- chunkname: @scripts/managers/conflict_director/terror_event_mixer.lua

require("scripts/settings/terror_event_blueprints")

function create_spawn_counter()
	local var_1_0 = {}
	local var_1_1 = {
		__index = function ()
			return 0
		end
	}

	setmetatable(var_1_0, var_1_1)

	return var_1_0
end

local function var_0_0(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1 = arg_3_1 or {}

	local function var_3_0(arg_4_0, arg_4_1, arg_4_2)
		arg_3_0.data.spawn_counter = arg_3_0.data.spawn_counter or create_spawn_counter()
		arg_3_0.data.spawn_counter[arg_3_2] = (arg_3_0.data.spawn_counter[arg_3_2] or 0) + 1
	end

	local function var_3_1(arg_5_0, arg_5_1, arg_5_2)
		arg_3_0.data.spawn_counter[arg_3_2] = arg_3_0.data.spawn_counter[arg_3_2] - 1
	end

	if not arg_3_1.spawned_func then
		arg_3_1.spawned_func = var_3_0
	else
		local var_3_2 = arg_3_1.spawned_func

		arg_3_1.spawned_func = function (arg_6_0, arg_6_1, arg_6_2)
			var_3_2(arg_6_0, arg_6_1, arg_6_2)
			var_3_0(arg_6_0, arg_6_1, arg_6_2)
		end
	end

	if not arg_3_1.despawned_func then
		arg_3_1.despawned_func = var_3_1
	else
		local var_3_3 = arg_3_1.despawned_func

		arg_3_1.despawned_func = function (arg_7_0, arg_7_1, arg_7_2)
			var_3_3(arg_7_0, arg_7_1, arg_7_2)
			var_3_1(arg_7_0, arg_7_1, arg_7_2)
		end
	end

	return arg_3_1
end

TerrorEventMixer = TerrorEventMixer or {}

local var_0_1 = TerrorEventMixer

var_0_1.active_events = var_0_1.active_events or {}
var_0_1.active_event_i = -1
var_0_1.start_event_list = var_0_1.start_event_list or {}
var_0_1.finished_events = var_0_1.finished_events or {}
var_0_1.optional_data = var_0_1.optional_data or {}
var_0_1.incrementing_id = 1
var_0_1.init_functions = {
	text = function (arg_8_0, arg_8_1, arg_8_2)
		arg_8_0.ends_at = arg_8_2 + ConflictUtils.random_interval(arg_8_1.duration)
	end,
	delay = function (arg_9_0, arg_9_1, arg_9_2)
		arg_9_0.ends_at = arg_9_2 + ConflictUtils.random_interval(arg_9_1.duration)
	end,
	spawn = function (arg_10_0, arg_10_1, arg_10_2)
		return
	end,
	spawn_special = function (arg_11_0, arg_11_1, arg_11_2)
		return
	end,
	spawn_weave_special = function (arg_12_0, arg_12_1, arg_12_2)
		return
	end,
	spawn_weave_special_event = function (arg_13_0, arg_13_1, arg_13_2)
		return
	end,
	spawn_at_raw = function (arg_14_0, arg_14_1, arg_14_2)
		return
	end,
	spawn_patrol = function (arg_15_0, arg_15_1, arg_15_2)
		return
	end,
	roaming_patrol = function (arg_16_0, arg_16_1, arg_16_2)
		return
	end,
	spawn_around_player = function (arg_17_0, arg_17_1, arg_17_2)
		return
	end,
	spawn_around_origin_unit = function (arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = arg_18_1.breed_spawn_table_per_difficulty

		if not var_18_0 then
			local var_18_1 = arg_18_1.breed_name
			local var_18_2 = arg_18_1.amount or 1
			local var_18_3 = arg_18_1.difficulty_amount

			if type(var_18_1) == "table" then
				var_18_1 = var_18_1[Math.random(1, #var_18_1)]
			end

			if var_18_3 then
				local var_18_4 = Managers.state.difficulty:get_difficulty_value_from_table(var_18_3) or var_18_3.hardest

				if type(var_18_4) == "table" then
					var_18_2 = var_18_4[Math.random(1, #var_18_4)]
				else
					var_18_2 = var_18_4
				end
			elseif type(var_18_2) == "table" then
				var_18_2 = var_18_2[Math.random(1, #var_18_2)]
			end

			local var_18_5 = {}

			for iter_18_0 = 1, var_18_2 do
				var_18_5[iter_18_0] = var_18_1
			end

			var_18_0 = {
				default = var_18_5
			}
		end

		local var_18_6, var_18_7 = Managers.state.difficulty:get_difficulty()
		local var_18_8 = var_18_0[var_18_6] or var_18_0.default
		local var_18_9 = #var_18_8
		local var_18_10 = arg_18_1.distance_to_enemies or 2
		local var_18_11 = {}

		for iter_18_1 = 1, var_18_9 do
			local var_18_12 = arg_18_1.optional_data and table.clone(arg_18_1.optional_data) or {}

			if arg_18_1.spawn_counter_category then
				var_18_12 = var_0_0(arg_18_0, var_18_12, arg_18_1.spawn_counter_category)
			end

			local var_18_13 = var_18_8[iter_18_1]

			if arg_18_1.pre_spawn_func then
				var_18_12 = arg_18_1.pre_spawn_func(var_18_12, var_18_6, var_18_13, arg_18_0, var_18_7, arg_18_1.enhancement_list)
			end

			var_18_11[iter_18_1] = var_18_12
		end

		arg_18_0.optional_data_table = var_18_11

		local var_18_14 = {}
		local var_18_15 = Managers.state.entity:system("ai_system"):nav_world()
		local var_18_16 = {}

		arg_18_0.spawn_at = arg_18_2 + (arg_18_1.spawn_delay or 0)
		arg_18_0.spawn_positions = var_18_16
		arg_18_0.optional_data_table = var_18_11
		arg_18_0.spawn_table = var_18_8

		local var_18_17 = arg_18_0.data.origin_unit
		local var_18_18 = arg_18_0.data.origin_position

		if var_18_17 and Unit.alive(var_18_17) then
			var_18_18 = Unit.local_position(var_18_17, 0)
		elseif not var_18_18 then
			Application.warning("[TerrorEventMixer] spawn_around_origin_unit present in a terror event that is started without an origin_unit or origin_position, falling back to a random player")

			local var_18_19 = PlayerUtils.get_random_alive_hero()

			var_18_18 = POSITION_LOOKUP[var_18_19]
		end

		local var_18_20 = arg_18_1.row_distance
		local var_18_21 = arg_18_1.circle_subdivision
		local var_18_22 = arg_18_1.min_distance
		local var_18_23 = arg_18_1.max_distance
		local var_18_24 = arg_18_1.above_max
		local var_18_25 = arg_18_1.below_max
		local var_18_26 = arg_18_1.tries or 30
		local var_18_27 = var_18_17 and arg_18_1.check_line_of_sight or false
		local var_18_28 = Managers.world:world("level_world")
		local var_18_29 = World.physics_world(var_18_28)

		ConflictUtils.find_positions_around_position(var_18_18, var_18_16, var_18_15, var_18_22, var_18_23, var_18_9, var_18_14, var_18_10, var_18_26, var_18_21, var_18_20, var_18_24, var_18_25, var_18_27, var_18_29, var_18_17)

		arg_18_0.center_position = Vector3Box(var_18_18)

		for iter_18_2 = 1, #var_18_16 do
			local var_18_30 = var_18_16[iter_18_2]
			local var_18_31 = Vector3Box(var_18_30)

			if arg_18_1.pre_spawn_unit_func then
				local var_18_32 = var_18_8[iter_18_2]

				arg_18_1.pre_spawn_unit_func(arg_18_0, arg_18_1, var_18_31, var_18_32)
			end

			var_18_16[iter_18_2] = var_18_31
		end

		if arg_18_1.spawn_failed_func and table.is_empty(var_18_16) then
			arg_18_1.spawn_failed_func(var_18_18)
		end

		return true
	end,
	vs_assign_boss_profile = function (arg_19_0, arg_19_1, arg_19_2)
		Managers.state.game_mode:game_mode():set_playable_boss_can_be_picked(true)

		if script_data.debug_playable_boss then
			-- Nothing
		end
	end,
	spawn_around_origin_unit_staggered = function (arg_20_0, arg_20_1, arg_20_2)
		return var_0_1.init_functions.spawn_around_origin_unit(arg_20_0, arg_20_1, arg_20_2)
	end,
	continue_when = function (arg_21_0, arg_21_1, arg_21_2)
		if arg_21_1.duration then
			arg_21_0.ends_at = arg_21_2 + ConflictUtils.random_interval(arg_21_1.duration)
		end
	end,
	control_hordes = function (arg_22_0, arg_22_1, arg_22_2)
		Managers.state.conflict.pacing:enable_hordes(arg_22_1.enable)
	end,
	control_specials = function (arg_23_0, arg_23_1, arg_23_2)
		local var_23_0 = Managers.state.conflict.specials_pacing

		if var_23_0 then
			var_23_0:enable(arg_23_1.enable)

			if arg_23_1.enable then
				local var_23_1 = math.random(20, 30)
				local var_23_2 = math.random(8, 16)
				local var_23_3 = Managers.time:time("game")

				var_23_0:delay_spawning(var_23_3, var_23_1, var_23_2, true)
			end
		end
	end,
	control_pacing = function (arg_24_0, arg_24_1, arg_24_2)
		local var_24_0 = Managers.state.conflict

		if arg_24_1.enable then
			var_24_0.pacing:enable()
		else
			var_24_0.pacing:disable()
		end
	end,
	debug_horde = function (arg_25_0, arg_25_1, arg_25_2)
		arg_25_0.ends_at = arg_25_2 + (arg_25_1.duration and ConflictUtils.random_interval(arg_25_1.duration) or 0)
	end,
	event_horde = function (arg_26_0, arg_26_1, arg_26_2)
		arg_26_0.ends_at = arg_26_2 + (arg_26_1.duration and ConflictUtils.random_interval(arg_26_1.duration) or 0)

		local var_26_0 = Managers.state.conflict
		local var_26_1 = arg_26_1.spawner_id or arg_26_1.spawner_ids
		local var_26_2 = arg_26_1.optional_data and table.clone(arg_26_1.optional_data)

		if arg_26_1.spawn_counter_category then
			var_26_2 = var_0_0(arg_26_0, var_26_2, arg_26_1.spawn_counter_category)
		end

		local var_26_3 = arg_26_1.limit_spawner_ids

		if var_26_3 then
			var_26_1 = table.clone(arg_26_1.spawner_ids)

			table.shuffle(var_26_1)

			for iter_26_0 = var_26_3 + 1, #var_26_1 do
				var_26_1[iter_26_0] = nil
			end
		end

		arg_26_1.horde_data = var_26_0:event_horde(arg_26_2, var_26_1, arg_26_1.side_id, arg_26_1.composition_type, arg_26_1.limit_spawners, arg_26_1.horde_silent, nil, arg_26_1.sound_settings, var_26_2)
	end,
	ambush_horde = function (arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = arg_27_1.optional_data and table.clone(arg_27_1.optional_data)

		if arg_27_1.spawn_counter_category then
			var_27_0 = var_0_0(arg_27_0, var_27_0, arg_27_1.spawn_counter_category)
		end

		arg_27_0.ends_at = arg_27_2 + (arg_27_1.duration and ConflictUtils.random_interval(arg_27_1.duration) or 0)

		local var_27_1 = Managers.state.conflict
		local var_27_2
		local var_27_3 = arg_27_1.composition_type

		if arg_27_0.data and arg_27_0.data.main_path_trigger_distance then
			var_27_2 = MainPathUtils.point_on_mainpath(nil, arg_27_0.data.main_path_trigger_distance)
		end

		local var_27_4 = {
			sound_settings = arg_27_1.sound_settings,
			override_composition_type = var_27_3
		}

		arg_27_1.horde_data = var_27_1.horde_spawner:execute_ambush_horde(var_27_4, var_27_1.default_enemy_side_id, false, var_27_2, var_27_0)
	end,
	reset_event_horde = function (arg_28_0, arg_28_1, arg_28_2)
		Managers.state.entity:system("spawner_system"):reset_spawners_with_event_id(arg_28_1.event_id)
	end,
	force_horde = function (arg_29_0, arg_29_1, arg_29_2)
		arg_29_0.ends_at = arg_29_2 + (arg_29_1.duration and ConflictUtils.random_interval(arg_29_1.duration) or 0)

		local var_29_0 = arg_29_1.horde_type
		local var_29_1 = var_29_0 == "vector" or var_29_0 == "ambush" or var_29_0 == "" or var_29_0 == "random" or not var_29_0

		assert(var_29_1, "Bad terror events element 'horde_type' was set to %s", var_29_0)

		if var_29_0 == "" or var_29_0 == "random" then
			var_29_0 = nil
		end

		local var_29_2 = arg_29_1.side_id
		local var_29_3

		Managers.state.conflict.horde_spawner:horde(var_29_0, var_29_3, var_29_2)
	end,
	start_event = function (arg_30_0, arg_30_1, arg_30_2)
		print("starting terror event: ", arg_30_1.start_event_name)

		local var_30_0 = var_0_1.start_event_list
		local var_30_1 = var_0_1.incrementing_id

		var_0_1.incrementing_id = var_0_1.incrementing_id + 1
		var_30_0[#var_30_0 + 1] = {
			name = arg_30_1.start_event_name,
			data = {},
			id = var_30_1
		}
	end,
	stop_event = function (arg_31_0, arg_31_1, arg_31_2)
		print("stopping terror event: ", arg_31_1.stop_event_name)

		local var_31_0 = var_0_1.find_event(arg_31_1.stop_event_name)

		if var_31_0 then
			var_31_0.destroy = true
		end
	end,
	start_mission = function (arg_32_0, arg_32_1, arg_32_2)
		local var_32_0 = arg_32_1.mission_name

		Managers.state.entity:system("mission_system"):request_mission(var_32_0)
	end,
	end_mission = function (arg_33_0, arg_33_1, arg_33_2)
		local var_33_0 = arg_33_1.mission_name

		Managers.state.entity:system("mission_system"):end_mission(var_33_0, true)
	end,
	set_master_event_running = function (arg_34_0, arg_34_1, arg_34_2)
		Managers.state.conflict:set_master_event_running(arg_34_1.name)
	end,
	stop_master_event = function (arg_35_0, arg_35_1, arg_35_2)
		Managers.state.conflict:set_master_event_running()
	end,
	flow_event = function (arg_36_0, arg_36_1, arg_36_2)
		local var_36_0 = Managers.state.conflict
		local var_36_1 = arg_36_1.flow_event_name

		var_36_0:level_flow_event(var_36_1)

		local var_36_2 = Managers.state.network

		if not arg_36_1.disable_network_send and var_36_2:game() then
			local var_36_3 = NetworkLookup.terror_flow_events[var_36_1]

			var_36_2.network_transmit:send_rpc_clients("rpc_terror_event_trigger_flow", var_36_3)
		end
	end,
	play_stinger = function (arg_37_0, arg_37_1, arg_37_2)
		local var_37_0 = arg_37_1.stinger_name or "enemy_terror_event_stinger"
		local var_37_1 = arg_37_1.use_origin_unit_position
		local var_37_2 = arg_37_0.data.origin_unit
		local var_37_3 = arg_37_1.optional_pos or var_37_1 and Unit.alive(var_37_2) and Unit.local_position(var_37_2, 0)
		local var_37_4 = Managers.state.conflict._world
		local var_37_5 = Managers.world:wwise_world(var_37_4)

		if var_37_3 then
			local var_37_6 = Vector3(var_37_3[1], var_37_3[2], var_37_3[3])

			if not DEDICATED_SERVER then
				WwiseUtils.trigger_position_event(var_37_4, var_37_0, var_37_6)
			end

			local var_37_7 = var_37_3 and "rpc_server_audio_position_event" or "rpc_server_audio_event"

			Managers.state.network.network_transmit:send_rpc_clients(var_37_7, NetworkLookup.sound_events[var_37_0], var_37_6)
		else
			if not DEDICATED_SERVER then
				WwiseWorld.trigger_event(var_37_5, var_37_0)
			end

			Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_event", NetworkLookup.sound_events[var_37_0])
		end
	end,
	force_load_breed_package = function (arg_38_0, arg_38_1, arg_38_2)
		local var_38_0 = Managers.level_transition_handler.enemy_package_loader
		local var_38_1 = arg_38_1.breed_name

		print("terror_event_mixer->force_load_breed_package, breed_name=", var_38_1)

		if not var_38_0:is_breed_processed(var_38_1) then
			local var_38_2 = true

			var_38_0:request_breed(var_38_1, var_38_2)
		end
	end,
	enable_bots_in_carry_event = function (arg_39_0, arg_39_1, arg_39_2)
		local var_39_0 = Managers.state.side:get_side_from_name("heroes")

		Managers.state.entity:system("ai_bot_group_system"):set_in_carry_event(true, var_39_0)
	end,
	disable_bots_in_carry_event = function (arg_40_0, arg_40_1, arg_40_2)
		local var_40_0 = Managers.state.side:get_side_from_name("heroes")

		Managers.state.entity:system("ai_bot_group_system"):set_in_carry_event(false, var_40_0)
	end,
	enable_kick = function (arg_41_0, arg_41_1, arg_41_2)
		Managers.state.voting:set_vote_kick_enabled(true)
	end,
	disable_kick = function (arg_42_0, arg_42_1, arg_42_2)
		Managers.state.voting:set_vote_kick_enabled(false)
	end,
	set_freeze_condition = function (arg_43_0, arg_43_1, arg_43_2)
		arg_43_0.max_active_enemies = arg_43_1.max_active_enemies or math.huge
	end,
	set_breed_event_horde_spawn_limit = function (arg_44_0, arg_44_1, arg_44_2)
		Managers.state.entity:system("spawner_system"):set_breed_event_horde_spawn_limit(arg_44_1.breed_name, arg_44_1.limit)
	end,
	create_boss_door_group = function (arg_45_0, arg_45_1, arg_45_2)
		local var_45_0 = arg_45_0.data
		local var_45_1 = Managers.state.entity:system("ai_group_system")

		var_45_0.group_data = {
			template = "boss_door_closers",
			id = var_45_1:generate_group_id(),
			size = arg_45_1.group_size
		}
	end,
	close_boss_doors = function (arg_46_0, arg_46_1, arg_46_2)
		local var_46_0 = arg_46_0.data
		local var_46_1 = var_46_0.map_section or arg_46_1.map_section
		local var_46_2 = var_46_0.group_data.id

		if var_46_1 then
			local var_46_3 = arg_46_1.breed_name

			Managers.state.entity:system("door_system"):close_boss_doors(var_46_1, var_46_2, var_46_3)
		end
	end,
	spawn_encampment = function (arg_47_0, arg_47_1, arg_47_2)
		local var_47_0
		local var_47_1
		local var_47_2
		local var_47_3 = arg_47_0.data

		if var_47_3.gizmo_unit then
			var_47_0 = var_47_3.encampment_id
			var_47_1 = var_47_3.unit_compositions_id
			var_47_2 = Unit.local_rotation(var_47_3.gizmo_unit, 0)
		else
			var_47_0 = arg_47_1.encampment_id
			var_47_1 = arg_47_1.unit_compositions_id

			local var_47_4 = var_47_3.dir

			var_47_2 = var_47_4 and Quaternion.look(Vector3(var_47_4[1], var_47_4[2], 0)) or Quaternion.look(Vector3(0, 1, 0))
		end

		local var_47_5 = var_47_3.side_id or arg_47_1.side_id or 2
		local var_47_6
		local var_47_7 = var_47_3.optional_pos

		if var_47_7 then
			var_47_6 = var_47_7:unbox()
		else
			local var_47_8 = arg_47_1.optional_pos

			var_47_6 = Vector3(var_47_8[1], var_47_8[2], var_47_8[3])
		end

		print("encampment_id:", var_47_0, "unit_compositions_id:", var_47_1, var_47_3)

		local var_47_9 = EncampmentTemplates[var_47_0]
		local var_47_10 = FormationUtils.make_encampment(var_47_9)
		local var_47_11 = var_47_9.unit_compositions[var_47_1]

		FormationUtils.spawn_encampment(var_47_10, var_47_6, var_47_2, var_47_11, var_47_5)
	end,
	teleport_player = function (arg_48_0, arg_48_1, arg_48_2)
		local var_48_0 = Managers.player:local_player()

		if var_48_0 then
			local var_48_1 = var_48_0.player_unit

			if Unit.alive(var_48_1) then
				local var_48_2 = ConflictUtils.get_teleporter_portals()
				local var_48_3 = arg_48_1.portal_id
				local var_48_4 = var_48_2[var_48_3][1]:unbox()
				local var_48_5 = var_48_2[var_48_3][2]:unbox()
				local var_48_6 = ScriptUnit.extension(var_48_1, "locomotion_system")
				local var_48_7 = Managers.world:world("level_world")

				LevelHelper:flow_event(var_48_7, "teleport_" .. var_48_3)
				var_48_6:teleport_to(var_48_4, var_48_5)
			end
		end
	end,
	run_benchmark_func = function (arg_49_0, arg_49_1, arg_49_2)
		local var_49_0 = arg_49_1.func_name

		Managers.benchmark[var_49_0](Managers.benchmark, arg_49_1, arg_49_2)
	end,
	set_time_challenge = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
		local var_50_0 = var_0_1.optional_data
		local var_50_1 = arg_50_1.time_challenge_name
		local var_50_2 = arg_50_2 + QuestSettings[var_50_1]
		local var_50_3 = Managers.state.difficulty:get_difficulty()

		if QuestSettings.allowed_difficulties[var_50_1][var_50_3] and not var_50_0[var_50_1] then
			var_50_0[var_50_1] = var_50_2
		end
	end,
	has_completed_time_challenge = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
		local var_51_0 = var_0_1.optional_data
		local var_51_1 = arg_51_1.time_challenge_name
		local var_51_2 = var_51_0[var_51_1]

		if var_51_2 then
			local var_51_3 = arg_51_2 < var_51_2
			local var_51_4 = math.abs(arg_51_2 - var_51_2)

			if var_51_3 then
				var_51_0[var_51_1] = nil

				local var_51_5 = var_51_1

				Managers.player:statistics_db():increment_stat_and_sync_to_clients(var_51_5)
			else
				var_51_0[var_51_1] = nil
			end
		end
	end,
	do_volume_challenge = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
		local var_52_0 = var_0_1.optional_data
		local var_52_1 = arg_52_1.volume_name

		fassert(var_52_0[var_52_1] == nil, "Already started a volume challenge for volume_name=(%s)", var_52_1)

		local var_52_2 = arg_52_1.challenge_name
		local var_52_3 = QuestSettings[var_52_2]
		local var_52_4 = not QuestSettings.allowed_difficulties[var_52_2][Managers.state.difficulty:get_difficulty()]

		var_52_0[var_52_1] = {
			time_inside = 0,
			duration = var_52_3,
			player_units = {},
			terminate = var_52_4
		}
	end,
	increase_weave_progress = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
		if not Managers.weave:get_active_weave() then
			return
		end

		local var_53_0 = arg_53_1.amount

		fassert(var_53_0 ~= nil, string.format("'amount' in 'increase_weave_progress' event in terror event '%s' is not defined", arg_53_0.name))
		Managers.weave:increase_bar_score(var_53_0)
	end,
	complete_weave = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
		local var_54_0 = Managers.weave

		if not var_54_0:get_active_weave() then
			return
		end

		var_54_0:final_objective_completed()
		Managers.state.game_mode:complete_level()
	end,
	activate_mutator = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
		return
	end,
	set_wwise_override_state = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
		return
	end,
	freeze_story_trigger = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
		return
	end,
	continue_when_spawned_count = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
		if arg_58_1.duration then
			arg_58_0.ends_at = arg_58_2 + ConflictUtils.random_interval(arg_58_1.duration)
		end
	end,
	run_func = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
		return
	end
}
var_0_1.run_functions = {
	vs_assign_boss_profile = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
		return
	end,
	spawn = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
		local var_61_0 = arg_61_0.data
		local var_61_1 = arg_61_1.optional_data and table.clone(arg_61_1.optional_data)
		local var_61_2 = var_61_0.gizmo_unit

		if var_61_2 then
			local var_61_3 = Unit.get_data(var_61_2, "is_behind_door")

			if var_61_3 then
				var_61_1 = var_61_1 or {}
				var_61_1.spawn_behind_door = var_61_3
			end
		end

		if arg_61_1.spawn_counter_category then
			var_61_1 = var_0_0(arg_61_0, var_61_1, arg_61_1.spawn_counter_category)
		end

		local var_61_4 = var_61_0.optional_pos and var_61_0.optional_pos:unbox() or var_61_0.origin_position and var_61_0.origin_position:unbox()
		local var_61_5 = Managers.state.conflict
		local var_61_6 = var_61_0.group_data
		local var_61_7 = arg_61_1.breed_name

		if type(var_61_7) == "table" then
			var_61_7 = var_61_7[Math.random(1, #var_61_7)]
		end

		if arg_61_1.pre_spawn_func then
			local var_61_8, var_61_9 = Managers.state.difficulty:get_difficulty()

			var_61_1 = arg_61_1.pre_spawn_func(var_61_1, var_61_8, var_61_7, arg_61_0, var_61_9, arg_61_1.enhancement_list)
		end

		var_61_5:spawn_one(Breeds[var_61_7], var_61_4, var_61_6, var_61_1)

		return true
	end,
	spawn_special = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		local var_62_0
		local var_62_1 = arg_62_1.breed_name
		local var_62_2 = arg_62_1.amount or 1
		local var_62_3 = arg_62_1.difficulty_amount
		local var_62_4 = arg_62_1.optional_data and table.clone(arg_62_1.optional_data)

		if arg_62_1.spawn_counter_category then
			var_62_4 = var_0_0(arg_62_0, var_62_4, arg_62_1.spawn_counter_category)
		end

		local var_62_5 = Managers.state.conflict

		if var_62_3 then
			local var_62_6 = Managers.state.difficulty:get_difficulty_value_from_table(var_62_3) or var_62_3.hardest

			if type(var_62_6) == "table" then
				var_62_2 = var_62_6[Math.random(1, #var_62_6)]
			else
				var_62_2 = var_62_6
			end
		elseif type(var_62_2) == "table" then
			var_62_2 = var_62_2[Math.random(1, #var_62_2)]
		end

		if type(var_62_1) == "table" then
			var_62_0 = var_62_1[Math.random(1, #var_62_1)]
		else
			var_62_0 = var_62_1
		end

		for iter_62_0 = 1, var_62_2 do
			local var_62_7 = var_62_5.specials_pacing:get_special_spawn_pos()

			var_62_5:spawn_one(Breeds[var_62_0], var_62_7, nil, var_62_4)
		end

		return true
	end,
	spawn_weave_special = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		local var_63_0 = arg_63_1.breed_name
		local var_63_1 = arg_63_1.amount or 1
		local var_63_2 = Managers.state.conflict
		local var_63_3 = arg_63_0.data
		local var_63_4 = var_63_3.main_path_trigger_distance
		local var_63_5 = arg_63_1.optional_data and table.clone(arg_63_1.optional_data)

		if arg_63_1.spawn_counter_category then
			var_63_5 = var_0_0(arg_63_0, var_63_5, arg_63_1.spawn_counter_category)
		end

		for iter_63_0 = 1, var_63_1 do
			local var_63_6 = MainPathUtils.point_on_mainpath(nil, var_63_4)
			local var_63_7 = Managers.weave:weave_spawner():get_hidden_spawn_pos_from_position_seeded(var_63_6)
			local var_63_8

			if type(var_63_0) == "table" then
				local var_63_9, var_63_10 = Math.next_random(var_63_3.seed, 1, #var_63_0)

				var_63_8 = var_63_0[var_63_10]
				var_63_3.seed = var_63_9
			else
				var_63_8 = var_63_0
			end

			var_63_2:spawn_one(Breeds[var_63_8], var_63_7, nil, var_63_5)
		end

		return true
	end,
	spawn_weave_special_event = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
		local var_64_0
		local var_64_1 = arg_64_1.breed_name
		local var_64_2 = arg_64_1.amount or 1
		local var_64_3 = arg_64_1.difficulty_amount
		local var_64_4 = arg_64_1.optional_data and table.clone(arg_64_1.optional_data)

		if arg_64_1.spawn_counter_category then
			var_64_4 = var_0_0(arg_64_0, var_64_4, arg_64_1.spawn_counter_category)
		end

		local var_64_5 = arg_64_0.data
		local var_64_6 = var_64_5.seed
		local var_64_7 = Managers.state.conflict

		if var_64_3 then
			local var_64_8 = Managers.state.difficulty:get_difficulty_value_from_table(var_64_3) or var_64_3.hardest

			if type(var_64_8) == "table" then
				local var_64_9
				local var_64_10

				var_64_6, var_64_10 = Math.next_random(var_64_6, 1, #var_64_8)
				var_64_2 = var_64_8[var_64_10]
			else
				var_64_2 = var_64_8
			end
		elseif type(var_64_2) == "table" then
			local var_64_11
			local var_64_12

			var_64_6, var_64_12 = Math.next_random(var_64_6, 1, #var_64_2)
			var_64_2 = var_64_2[var_64_12]
		end

		if type(var_64_1) == "table" then
			local var_64_13
			local var_64_14

			var_64_6, var_64_14 = Math.next_random(var_64_6, 1, #var_64_1)
			var_64_0 = var_64_1[var_64_14]
		else
			var_64_0 = var_64_1
		end

		for iter_64_0 = 1, var_64_2 do
			local var_64_15 = var_64_7.specials_pacing:get_special_spawn_pos()

			var_64_7:spawn_one(Breeds[var_64_0], var_64_15, nil, var_64_4)
		end

		var_64_5.seed = var_64_6

		return true
	end,
	spawn_at_raw = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
		if Managers.player.is_server then
			local var_65_0
			local var_65_1 = arg_65_1.breed_name
			local var_65_2 = arg_65_1.amount or 1
			local var_65_3 = arg_65_1.difficulty_amount
			local var_65_4 = arg_65_1.optional_data and table.clone(arg_65_1.optional_data)

			if arg_65_1.spawn_counter_category then
				var_65_4 = var_0_0(arg_65_0, var_65_4, arg_65_1.spawn_counter_category)
			end

			if var_65_3 then
				local var_65_5 = Managers.state.difficulty:get_difficulty_value_from_table(var_65_3) or var_65_3.hardest

				if type(var_65_5) == "table" then
					var_65_2 = var_65_5[Math.random(1, #var_65_5)]
				else
					var_65_2 = var_65_5
				end
			elseif type(var_65_2) == "table" then
				var_65_2 = var_65_2[Math.random(1, #var_65_2)]
			end

			if type(var_65_1) == "table" then
				var_65_0 = var_65_1[Math.random(1, #var_65_1)]
			else
				var_65_0 = var_65_1
			end

			if arg_65_1.pre_spawn_func then
				local var_65_6, var_65_7 = Managers.state.difficulty:get_difficulty()

				var_65_4 = arg_65_1.pre_spawn_func(var_65_4, var_65_6, var_65_0, arg_65_0, var_65_7, arg_65_1.enhancement_list)
			end

			local var_65_8 = Managers.state.conflict

			for iter_65_0 = 1, var_65_2 do
				local var_65_9

				if arg_65_1.spawner_ids then
					local var_65_10 = arg_65_1.spawner_ids

					var_65_9 = var_65_10[Math.random(1, #var_65_10)]
				else
					var_65_9 = arg_65_1.spawner_id
				end

				var_65_8:spawn_at_raw_spawner(Breeds[var_65_0], var_65_9, var_65_4, arg_65_1.side_id)
			end
		end

		return true
	end,
	spawn_patrol = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
		local var_66_0 = arg_66_0.data
		local var_66_1 = var_66_0 and var_66_0.optional_pos and var_66_0.optional_pos:unbox()
		local var_66_2 = Managers.state.conflict
		local var_66_3 = arg_66_1.patrol_template
		local var_66_4 = arg_66_1.main_path_patrol
		local var_66_5 = {}

		if var_66_4 then
			var_66_5.breed = Breeds[arg_66_1.breed_name]
			var_66_5.group_type = "main_path_patrol"
			var_66_5.side_id = arg_66_1.side_id

			local var_66_6 = arg_66_1.side_id

			var_66_2:spawn_group(var_66_3, var_66_1, var_66_5)
		else
			local var_66_7 = var_66_0 and var_66_0.formations or arg_66_1.formations
			local var_66_8 = #var_66_7
			local var_66_9 = var_66_7[var_66_8 > 1 and math.random(var_66_8) or 1]

			assert(PatrolFormationSettings[var_66_9], "No such formation exists in PatrolFormationSettings")

			local var_66_10
			local var_66_11 = arg_66_1.splines

			if var_66_11 then
				local var_66_12 = #var_66_11

				var_66_10 = var_66_11[var_66_12 > 1 and math.random(var_66_12) or 1]
			else
				var_66_10 = var_66_0 and var_66_0.spline_id
			end

			local var_66_13
			local var_66_14 = Managers.state.difficulty:get_difficulty_value_from_table(PatrolFormationSettings[var_66_9])
			local var_66_15 = var_66_0.one_directional

			var_66_14.settings = PatrolFormationSettings[var_66_9].settings

			local var_66_16 = var_66_0 and var_66_0.spline_way_points

			if not var_66_16 then
				local var_66_17, var_66_18, var_66_19, var_66_20 = var_66_2.level_analysis:get_waypoint_spline(var_66_10)

				if var_66_17 then
					var_66_16 = var_66_18
					var_66_13 = var_66_19
					var_66_15 = var_66_20
				end
			end

			local var_66_21 = var_66_0 and var_66_0.spline_type or arg_66_1.spline_type

			var_66_5.spline_name = var_66_10
			var_66_5.formation = var_66_14
			var_66_5.group_type = "spline_patrol"
			var_66_5.spline_way_points = var_66_16
			var_66_5.spline_type = var_66_21
			var_66_5.despawn_at_end = var_66_15
			var_66_5.spawn_all_at_same_position = true

			var_66_2:spawn_spline_group(var_66_3, var_66_13, var_66_5)
		end

		return true
	end,
	roaming_patrol = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
		local var_67_0 = arg_67_0.data
		local var_67_1 = var_67_0.optional_pos and var_67_0.optional_pos:unbox()
		local var_67_2 = Managers.state.conflict
		local var_67_3 = arg_67_1.patrol_template or "spline_patrol"
		local var_67_4 = {}
		local var_67_5 = var_67_0.spline_name
		local var_67_6 = var_67_0.pack

		var_67_4.formation, var_67_4.spline_name = PatrolFormationSettings.random_roaming_formation(var_67_6), var_67_5
		var_67_4.group_type = "roaming_patrol"
		var_67_4.spline_way_points = var_67_0.spline_way_points
		var_67_4.spline_type = var_67_0.spline_type
		var_67_4.despawn_at_end = false
		var_67_4.zone_data = var_67_0.zone_data
		var_67_4.spawn_all_at_same_position = false

		var_67_2:spawn_spline_group(var_67_3, var_67_1, var_67_4)

		return true
	end,
	spawn_around_player = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
		local var_68_0
		local var_68_1 = arg_68_1.breed_name
		local var_68_2 = arg_68_1.amount or 1
		local var_68_3 = arg_68_1.difficulty_amount

		if type(var_68_1) == "table" then
			var_68_0 = var_68_1[Math.random(1, #var_68_1)]
		else
			var_68_0 = var_68_1
		end

		if var_68_3 then
			local var_68_4 = Managers.state.difficulty:get_difficulty_value_from_table(var_68_3) or var_68_3.hardest

			if type(var_68_4) == "table" then
				var_68_2 = var_68_4[Math.random(1, #var_68_4)]
			else
				var_68_2 = var_68_4
			end
		elseif type(var_68_2) == "table" then
			var_68_2 = var_68_2[Math.random(1, #var_68_2)]
		end

		local var_68_5 = arg_68_1.optional_data and table.clone(arg_68_1.optional_data)

		if arg_68_1.spawn_counter_category then
			var_68_5 = var_0_0(arg_68_0, var_68_5, arg_68_1.spawn_counter_category)
		end

		local var_68_6 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_POSITIONS
		local var_68_7 = arg_68_1.distance_to_players or 2
		local var_68_8 = arg_68_1.distance_to_enemies or 2

		local function var_68_9(arg_69_0, arg_69_1)
			local var_69_0 = math.pow(var_68_7, 2)

			for iter_69_0 = 1, #var_68_6 do
				if var_69_0 > Vector3.distance_squared(arg_69_0, var_68_6[iter_69_0]) then
					return false
				end
			end

			local var_69_1 = math.pow(var_68_8, 2)

			for iter_69_1 = 1, #arg_69_1 do
				if var_69_1 > Vector3.distance_squared(arg_69_0, arg_69_1[iter_69_1]) then
					return false
				end
			end

			return true
		end

		if arg_68_1.pre_spawn_func then
			local var_68_10, var_68_11 = Managers.state.difficulty:get_difficulty()

			var_68_5 = arg_68_1.pre_spawn_func(var_68_5, var_68_10, var_68_0, arg_68_0, var_68_11, arg_68_1.enhancement_list)
		end

		local var_68_12 = {}
		local var_68_13 = Managers.state.entity:system("ai_system"):nav_world()
		local var_68_14 = Managers.state.conflict

		for iter_68_0 = 1, var_68_2 do
			local var_68_15 = PlayerUtils.get_random_alive_hero()
			local var_68_16 = POSITION_LOOKUP[var_68_15]
			local var_68_17 = arg_68_1.spawn_distance or 10
			local var_68_18 = arg_68_1.spread or 10
			local var_68_19 = ConflictUtils.get_spawn_pos_on_circle_with_func(var_68_13, var_68_16, var_68_17, var_68_18, 30, var_68_9, var_68_12)

			if var_68_19 then
				table.insert(var_68_12, var_68_19)
				var_68_14:spawn_one(Breeds[var_68_0], var_68_19, nil, var_68_5)
			end
		end

		return true
	end,
	spawn_around_origin_unit = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
		if arg_70_2 > arg_70_0.spawn_at then
			local var_70_0 = Managers.state.conflict
			local var_70_1 = arg_70_0.spawn_table
			local var_70_2 = arg_70_0.optional_data_table
			local var_70_3 = arg_70_0.spawn_positions
			local var_70_4

			if arg_70_1.group_template then
				var_70_4 = {
					id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
					size = #var_70_3,
					template = arg_70_1.group_template
				}
			end

			local var_70_5 = arg_70_0.center_position:unbox()

			for iter_70_0 = 1, #var_70_3 do
				local var_70_6 = var_70_3[iter_70_0]
				local var_70_7 = var_70_6:unbox()
				local var_70_8 = var_70_1[iter_70_0]
				local var_70_9 = Breeds[var_70_8]
				local var_70_10 = var_70_2[iter_70_0]
				local var_70_11

				if arg_70_1.face_unit then
					local var_70_12 = var_70_5 - var_70_7

					var_70_11 = Quaternion.look(var_70_12, Vector3.up())
				end

				if arg_70_1.face_nearest_player_of_side then
					local var_70_13 = Managers.state.side:get_side_from_name(arg_70_1.face_nearest_player_of_side)
					local var_70_14 = var_70_13.PLAYER_AND_BOT_POSITIONS
					local var_70_15 = var_70_13.PLAYER_AND_BOT_UNITS

					if #var_70_14 then
						local var_70_16 = math.huge
						local var_70_17

						for iter_70_1 = 1, #var_70_14 do
							local var_70_18 = var_70_14[iter_70_1]
							local var_70_19 = Vector3.length_squared(var_70_7 - var_70_18)
							local var_70_20 = var_70_15[iter_70_1]

							if ALIVE[var_70_20] and not ScriptUnit.extension(var_70_20, "status_system"):is_invisible() and var_70_19 < var_70_16 then
								var_70_17 = var_70_18
							end
						end

						if var_70_17 then
							local var_70_21 = var_70_17 - var_70_7

							var_70_11 = Quaternion.look(var_70_21, Vector3.up())
						end
					end
				end

				var_70_11 = var_70_11 or Quaternion.identity()

				var_70_0:spawn_one(var_70_9, var_70_7, var_70_4, var_70_10, var_70_11)

				if arg_70_1.post_spawn_unit_func then
					arg_70_1.post_spawn_unit_func(arg_70_0, arg_70_1, var_70_6)
				end
			end

			arg_70_0.spawn_positions = nil

			return true
		end

		return false
	end,
	spawn_around_origin_unit_staggered = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
		if arg_71_2 >= arg_71_0.spawn_at and (not arg_71_0.next_spawn_t or arg_71_2 >= arg_71_0.next_spawn_t) then
			local var_71_0 = Managers.state.conflict
			local var_71_1 = arg_71_0.spawn_table
			local var_71_2 = arg_71_0.optional_data_table
			local var_71_3 = arg_71_0.spawn_positions
			local var_71_4 = arg_71_0.group_data

			if arg_71_1.group_template and not var_71_4 then
				var_71_4 = {
					id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
					size = #var_71_3,
					template = arg_71_1.group_template
				}
				arg_71_0.group_data = var_71_4
			end

			local var_71_5 = arg_71_0.center_position:unbox()
			local var_71_6 = #var_71_3
			local var_71_7 = arg_71_0.num_spawned and arg_71_0.num_spawned + 1 or 1
			local var_71_8 = Math.random(arg_71_1.staggered_spawn_batch_size[1], arg_71_1.staggered_spawn_batch_size[2])
			local var_71_9 = math.min(var_71_7 + var_71_8, var_71_6)

			for iter_71_0 = var_71_7, var_71_9 do
				local var_71_10 = var_71_3[iter_71_0]
				local var_71_11 = var_71_10:unbox()
				local var_71_12 = var_71_1[iter_71_0]
				local var_71_13 = Breeds[var_71_12]
				local var_71_14 = var_71_2[iter_71_0]
				local var_71_15

				if arg_71_1.face_unit then
					local var_71_16 = var_71_5 - var_71_11

					var_71_15 = Quaternion.look(var_71_16, Vector3.up())
				end

				var_71_0:spawn_one(var_71_13, var_71_11, var_71_4, var_71_14, var_71_15)

				if arg_71_1.post_spawn_unit_func then
					arg_71_1.post_spawn_unit_func(arg_71_0, arg_71_1, var_71_10)
				end
			end

			if var_71_9 <= var_71_7 then
				arg_71_0.next_spawn_t = nil
				arg_71_0.num_spawned = nil
				arg_71_0.spawn_positions = nil

				return true
			end

			arg_71_0.num_spawned = var_71_9

			local var_71_17 = arg_71_1.staggered_spawn_delay[1]
			local var_71_18 = arg_71_1.staggered_spawn_delay[2] - var_71_17

			arg_71_0.next_spawn_t = arg_71_2 + math.random() * var_71_18 + var_71_17
		end

		return false
	end,
	continue_when = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
		if arg_72_1.duration and arg_72_2 > arg_72_0.ends_at then
			return true
		end

		return arg_72_1.condition(arg_72_2)
	end,
	control_pacing = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
		return true
	end,
	control_specials = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
		return true
	end,
	control_hordes = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
		return true
	end,
	event_horde = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
		if arg_76_2 > arg_76_0.ends_at then
			return true
		end
	end,
	ambush_horde = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
		if arg_77_2 > arg_77_0.ends_at then
			return true
		end
	end,
	reset_event_horde = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
		return true
	end,
	force_horde = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
		if arg_79_2 > arg_79_0.ends_at then
			return true
		end
	end,
	debug_horde = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
		if arg_80_2 > arg_80_0.ends_at then
			return true
		end

		local var_80_0 = Managers.state.conflict

		if #var_80_0:spawned_enemies() < arg_80_1.amount then
			local var_80_1 = Managers.state.side:get_side(var_80_0.default_hero_side_id).PLAYER_AND_BOT_POSITIONS[1]
			local var_80_2 = ConflictUtils.get_spawn_pos_on_circle(var_80_0.nav_world, var_80_1, 25, 15, 5)

			if var_80_2 then
				local var_80_3 = var_80_1 - var_80_2
				local var_80_4 = Quaternion.look(Vector3(var_80_3.x, var_80_3.y, 1))
				local var_80_5 = Breeds[var_80_0._debug_breed or "skaven_slave"]
				local var_80_6

				var_80_0:spawn_queued_unit(var_80_5, Vector3Box(var_80_2), QuaternionBox(var_80_4), "constant_70", nil, "horde_hidden", var_80_6)
			end
		end
	end,
	delay = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
		if arg_81_2 > arg_81_0.ends_at then
			return true
		end
	end,
	text = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
		if arg_82_0.ends_at - arg_82_2 >= 0 then
			Debug.text(tostring(arg_82_1.text))
		else
			return true
		end
	end,
	start_event = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
		return true
	end,
	stop_event = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
		return true
	end,
	start_mission = function (arg_85_0, arg_85_1, arg_85_2)
		return true
	end,
	end_mission = function (arg_86_0, arg_86_1, arg_86_2)
		return true
	end,
	flow_event = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
		return true
	end,
	play_stinger = function (arg_88_0, arg_88_1, arg_88_2)
		return true
	end,
	force_load_breed_package = function (arg_89_0, arg_89_1, arg_89_2)
		return true
	end,
	set_master_event_running = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
		return true
	end,
	stop_master_event = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
		return true
	end,
	enable_bots_in_carry_event = function (arg_92_0, arg_92_1, arg_92_2)
		return true
	end,
	disable_bots_in_carry_event = function (arg_93_0, arg_93_1, arg_93_2)
		return true
	end,
	enable_kick = function (arg_94_0, arg_94_1, arg_94_2)
		return true
	end,
	disable_kick = function (arg_95_0, arg_95_1, arg_95_2)
		return true
	end,
	set_freeze_condition = function (arg_96_0, arg_96_1, arg_96_2)
		return true
	end,
	set_breed_event_horde_spawn_limit = function (arg_97_0, arg_97_1, arg_97_2)
		return true
	end,
	create_boss_door_group = function (arg_98_0, arg_98_1, arg_98_2)
		return true
	end,
	close_boss_doors = function (arg_99_0, arg_99_1, arg_99_2)
		return true
	end,
	spawn_encampment = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3)
		return true
	end,
	teleport_player = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3)
		return true
	end,
	run_benchmark_func = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3)
		return true
	end,
	set_time_challenge = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3)
		return true
	end,
	has_completed_time_challenge = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
		return true
	end,
	do_volume_challenge = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3)
		local var_105_0 = arg_105_1.volume_name
		local var_105_1 = var_0_1.optional_data[var_105_0]

		if var_105_1.terminate then
			return true
		end

		local var_105_2 = var_105_1.player_units
		local var_105_3 = true
		local var_105_4 = Managers.player:human_players()

		for iter_105_0, iter_105_1 in pairs(var_105_4) do
			local var_105_5 = iter_105_1.player_unit

			if not HEALTH_ALIVE[var_105_5] then
				var_105_3 = false

				break
			end

			var_105_2[#var_105_2 + 1] = var_105_5
		end

		if var_105_3 then
			local var_105_6 = Managers.state.entity:system("volume_system")

			var_105_3 = EngineOptimizedExtensions.volume_has_all_units_inside(var_105_6._volume_system, var_105_0, unpack(var_105_2))
		end

		table.clear(var_105_2)

		if var_105_3 then
			var_105_1.time_inside = var_105_1.time_inside + arg_105_3
		else
			var_105_1.time_inside = 0
		end

		if var_105_1.time_inside >= var_105_1.duration then
			local var_105_7 = arg_105_1.increment_stat_name

			Managers.player:statistics_db():increment_stat_and_sync_to_clients(var_105_7)

			return true
		else
			return false
		end
	end,
	increase_weave_progress = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3)
		return true
	end,
	complete_weave = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3)
		return true
	end,
	activate_mutator = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3)
		local var_108_0 = arg_108_1.name

		if Managers.state.game_mode then
			local var_108_1 = Managers.state.game_mode._mutator_handler

			if not var_108_1:has_activated_mutator(var_108_0) then
				var_108_1:initialize_mutators({
					var_108_0
				})
				var_108_1:activate_mutator(var_108_0)
			end
		end

		return true
	end,
	set_wwise_override_state = function (arg_109_0, arg_109_1, arg_109_2, arg_109_3)
		local var_109_0 = arg_109_1.name

		Managers.music:set_music_group_state("combat_music", "override", var_109_0)

		return true
	end,
	freeze_story_trigger = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3)
		local var_110_0 = arg_110_1.freeze
		local var_110_1 = Managers.state.entity:system("dialogue_system")

		if var_110_0 then
			var_110_1:freeze_story_trigger()
		else
			var_110_1:unfreeze_story_trigger()
		end

		return true
	end,
	continue_when_spawned_count = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3)
		if arg_111_1.duration and arg_111_2 > arg_111_0.ends_at then
			return true
		end

		arg_111_0.data.spawn_counter = arg_111_0.data.spawn_counter or create_spawn_counter()

		return not arg_111_1.condition or arg_111_1.condition(arg_111_0.data.spawn_counter)
	end,
	run_func = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3)
		arg_112_1.func()

		return true
	end
}
var_0_1.debug_functions = {
	vs_assign_boss_profile = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3)
		return "vs_assign_boss_profile"
	end,
	control_pacing = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3)
		return arg_114_1.enable and "enable" or "disable"
	end,
	control_specials = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3)
		return arg_115_1.enable and "enable" or "disable"
	end,
	delay = function (arg_116_0, arg_116_1, arg_116_2, arg_116_3)
		return
	end,
	set_freeze_condition = function (arg_117_0, arg_117_1, arg_117_2, arg_117_3)
		return string.format(": max enemies %d", arg_117_0.max_active_enemies)
	end,
	debug_horde = function (arg_118_0, arg_118_1, arg_118_2, arg_118_3)
		local var_118_0 = #Managers.state.conflict:spawned_enemies()

		return string.format(" alive: %d, max-amount: %d", var_118_0, arg_118_1.amount)
	end,
	event_horde = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3)
		local var_119_0 = arg_119_1.horde_data

		if var_119_0 then
			if var_119_0.started then
				if var_119_0.failed then
					return string.format(" horde failed!")
				else
					return string.format(" amount: %d ", var_119_0.amount)
				end
			else
				return "waiting to start..."
			end
		else
			return string.format("waiting to start...")
		end
	end,
	ambush_horde = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3)
		local var_120_0 = arg_120_1.horde_data

		if var_120_0 then
			if var_120_0.started then
				if var_120_0.failed then
					return string.format(" horde failed!")
				else
					return string.format(" amount: %d ", var_120_0.amount)
				end
			else
				return "waiting to start..."
			end
		else
			return string.format("waiting to start...")
		end
	end,
	reset_event_horde = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3)
		return string.format(arg_121_1.event_id)
	end,
	force_horde = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3)
		return string.format(arg_122_1.horde_type)
	end,
	spawn = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3)
		return arg_123_1.breed_name
	end,
	spawn_at_raw = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3)
		local var_124_0

		if type(arg_124_1.breed_name) == "table" then
			var_124_0 = table.dump_string(arg_124_1.breed_name)
		else
			var_124_0 = arg_124_1.breed_name
		end

		return (arg_124_1.spawner_id or table.tostring(arg_124_1.spawner_ids)) .. " -> " .. var_124_0
	end,
	spawn_patrol = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3)
		return arg_125_1.breed_name
	end,
	roaming_patrol = function (arg_126_0, arg_126_1, arg_126_2, arg_126_3)
		return "roaming_patrol"
	end,
	start_event = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3)
		return "event_name: " .. arg_127_1.start_event_name
	end,
	stop_event = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3)
		return "event_name: " .. arg_128_1.stop_event_name
	end,
	start_mission = function (arg_129_0, arg_129_1, arg_129_2)
		return "mission_name: " .. arg_129_1.mission_name
	end,
	end_mission = function (arg_130_0, arg_130_1, arg_130_2)
		return "mission_name: " .. arg_130_1.mission_name
	end,
	flow_event = function (arg_131_0, arg_131_1, arg_131_2, arg_131_3)
		return "event_name: " .. tostring(arg_131_1.flow_event_name)
	end,
	set_master_event_running = function (arg_132_0, arg_132_1, arg_132_2, arg_132_3)
		return "name: " .. arg_132_1.name
	end,
	play_stinger = function (arg_133_0, arg_133_1, arg_133_2)
		local var_133_0 = arg_133_1.optional_pos

		if var_133_0 then
			return string.format(" stinger-name: %s, pos: (%.1f,%.1f,%.1f) ", arg_133_1.stinger_name, var_133_0[1], var_133_0[2], var_133_0[3])
		else
			return " stinger-name:" .. arg_133_1.stinger_name
		end
	end,
	force_load_breed_package = function (arg_134_0, arg_134_1, arg_134_2, arg_134_3)
		return "breed_name: " .. arg_134_1.breed_name
	end,
	stop_master_event = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3)
		return ""
	end,
	spawn_encampment = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3)
		return ""
	end,
	teleport_player = function (arg_137_0, arg_137_1, arg_137_2, arg_137_3)
		return "teleport to portal_id:" .. arg_137_1.portal_id
	end,
	run_benchmark_func = function (arg_138_0, arg_138_1, arg_138_2, arg_138_3)
		return "func_name:" .. arg_138_1.func_name
	end,
	set_time_challenge = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3)
		return "Time challenge started "
	end,
	do_volume_challenge = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3)
		local var_140_0 = arg_140_1.volume_name
		local var_140_1 = var_0_1.optional_data[var_140_0]
		local var_140_2 = var_140_1.time_inside
		local var_140_3 = var_140_1.duration
		local var_140_4 = var_140_2 / var_140_3

		return string.format("%.2f/%.2f - %.2f", var_140_2, var_140_3, var_140_4)
	end,
	activate_mutator = function (arg_141_0, arg_141_1, arg_141_2, arg_141_3)
		return arg_141_1.name
	end,
	set_wwise_override_state = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3)
		return arg_142_1.name
	end,
	freeze_story_trigger = function (arg_143_0, arg_143_1, arg_143_2, arg_143_3)
		return arg_143_1.freeze
	end
}

var_0_1.reset = function ()
	table.clear(var_0_1.active_events)
	table.clear(var_0_1.start_event_list)
	table.clear(var_0_1.finished_events)
	table.clear(var_0_1.optional_data)
end

var_0_1.add_to_start_event_list = function (arg_145_0, arg_145_1, arg_145_2, arg_145_3)
	local var_145_0 = var_0_1.start_event_list
	local var_145_1 = var_0_1.incrementing_id

	var_0_1.incrementing_id = var_0_1.incrementing_id + 1
	var_145_0[#var_145_0 + 1] = {
		name = arg_145_0,
		data = {
			seed = arg_145_1,
			origin_unit = arg_145_2,
			origin_position = arg_145_3
		},
		id = var_145_1
	}

	return var_145_1
end

var_0_1.start_random_event = function (arg_146_0)
	local var_146_0 = Managers.level_transition_handler

	if var_146_0:needs_level_load() then
		print("TerrorEventMixer.start_random_event:", arg_146_0, " ignored because game is transitioning away.")

		return
	end

	local var_146_1 = var_146_0:get_current_level_keys()
	local var_146_2 = WeightedRandomTerrorEvents[var_146_1][arg_146_0]

	fassert(var_146_2, "Cannot find a WeightedRandomTerrorEvent called %s", tostring(arg_146_0))

	local var_146_3 = var_146_2[LoadedDice.roll_easy(var_146_2.loaded_probability_table) * 2 - 1]
	local var_146_4 = var_0_1.add_to_start_event_list(var_146_3)

	print("TerrorEventMixer.start_random_event:", arg_146_0, "->", var_146_3)

	return var_146_4
end

local function var_0_2(arg_147_0, arg_147_1)
	local var_147_0 = arg_147_1.active_tags
	local var_147_1 = arg_147_1.factions
	local var_147_2 = arg_147_1.current_difficulty
	local var_147_3 = arg_147_1.current_difficulty_tweak

	if arg_147_0.minimum_difficulty_tweak and var_147_3 < arg_147_0.minimum_difficulty_tweak then
		return false
	end

	if arg_147_0.difficulty_requirement then
		if var_147_2 < arg_147_0.difficulty_requirement then
			return false
		end
	elseif arg_147_0.only_on_difficulty and var_147_2 ~= arg_147_0.only_on_difficulty then
		return false
	end

	if var_147_1 and arg_147_0.faction_requirement then
		local var_147_4 = arg_147_0.faction_requirement

		if not table.contains(var_147_1, var_147_4) then
			return false
		end
	end

	if var_147_1 and arg_147_0.faction_requirement_list then
		local var_147_5 = arg_147_0.faction_requirement_list

		for iter_147_0, iter_147_1 in ipairs(var_147_5) do
			if not table.contains(var_147_1, iter_147_1) then
				return false
			end
		end
	end

	if arg_147_0.tag_requirement_list then
		local var_147_6 = arg_147_0.tag_requirement_list

		for iter_147_2, iter_147_3 in ipairs(var_147_6) do
			if not var_147_0 or not table.contains(var_147_0, iter_147_3) then
				return false
			end
		end
	end

	return true
end

local var_0_3

local function var_0_4(arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
	if arg_148_0[1] == "inject_event" then
		local var_148_0

		if arg_148_0.event_name_list then
			local var_148_1, var_148_2 = Math.next_random(arg_148_1.seed, 1, #arg_148_0.event_name_list)

			var_148_0 = arg_148_0.event_name_list[var_148_2]
			arg_148_1.seed = var_148_1
		elseif arg_148_0.weighted_event_names then
			local var_148_3 = 0

			for iter_148_0, iter_148_1 in ipairs(arg_148_0.weighted_event_names) do
				var_148_3 = var_148_3 + iter_148_1.weight
			end

			local var_148_4, var_148_5 = Math.next_random(arg_148_1.seed, 0, var_148_3)

			arg_148_1.seed = var_148_4

			local var_148_6 = 0

			for iter_148_2, iter_148_3 in ipairs(arg_148_0.weighted_event_names) do
				var_148_6 = var_148_6 + iter_148_3.weight

				if var_148_5 <= var_148_6 then
					var_148_0 = iter_148_3.event_name

					break
				end
			end

			if var_148_0 == nil then
				assert(false, "Failed getting a random weighted element.")
			end
		else
			var_148_0 = arg_148_0.event_name
		end

		var_0_3(arg_148_2, arg_148_1, arg_148_4 + 1, var_148_0)
	elseif arg_148_0[1] == "one_of" then
		for iter_148_4, iter_148_5 in ipairs(arg_148_0[2]) do
			if var_0_2(iter_148_5, arg_148_1) then
				var_0_4(iter_148_5, arg_148_1, arg_148_2, arg_148_3, arg_148_4)

				break
			end
		end
	else
		arg_148_0.base_event_name = arg_148_3
		arg_148_2[#arg_148_2 + 1] = arg_148_0
	end
end

local var_0_5 = 10

function var_0_3(arg_149_0, arg_149_1, arg_149_2, arg_149_3)
	fassert(arg_149_2 < var_0_5, "Injecting terror events lead to high level of recursion, please check if there is a possible loop, or increase MAX_INJECTION_DEPTH.")

	local var_149_0 = Managers.level_transition_handler:get_current_level_keys()
	local var_149_1 = TerrorEventBlueprints[var_149_0][arg_149_3] or GenericTerrorEvents[arg_149_3]

	fassert(var_149_1, "No terror event called '%s', exists. Make sure it is added to level %s, or generic, terror event file if its supposed to be there.", arg_149_3, var_149_0)

	for iter_149_0, iter_149_1 in ipairs(var_149_1) do
		if var_0_2(iter_149_1, arg_149_1) then
			var_0_4(iter_149_1, arg_149_1, arg_149_0, arg_149_3, arg_149_2)
		end
	end

	return arg_149_0
end

local function var_0_6(arg_150_0, arg_150_1)
	local var_150_0 = Managers.state.game_mode._mutator_handler:get_terror_event_tags()
	local var_150_1 = Managers.state.conflict
	local var_150_2 = ConflictDirectors[var_150_1.initial_conflict_settings].factions
	local var_150_3, var_150_4 = Managers.state.difficulty:get_difficulty_rank()

	arg_150_0.current_difficulty = var_150_3
	arg_150_0.current_difficulty_tweak = var_150_4
	arg_150_0.factions = var_150_2
	arg_150_0.active_tags = var_150_0

	local var_150_5 = var_0_3({}, arg_150_0, 0, arg_150_1)

	if script_data.debug_terror then
		print("process_terror_event: " .. table.tostring(var_150_5))
	end

	return var_150_5
end

var_0_1.start_event = function (arg_151_0, arg_151_1, arg_151_2)
	if script_data.only_allowed_terror_event ~= arg_151_0 and script_data.ai_terror_events_disabled then
		return
	end

	if arg_151_1 then
		arg_151_1.seed = arg_151_1.seed or 0
	else
		arg_151_1 = {
			seed = 0
		}
	end

	local var_151_0, var_151_1 = Math.next_random(arg_151_1.seed)

	arg_151_1.seed = var_151_0

	print(string.format("TerrorEventMixer.start_event: %s (seed: %d)", arg_151_0, arg_151_1.seed))

	local var_151_2 = var_0_1.active_events
	local var_151_3 = var_0_6(arg_151_1, arg_151_0)

	Managers.state.game_mode:post_process_terror_event(var_151_3)

	if not arg_151_2 then
		arg_151_2 = var_0_1.incrementing_id
		var_0_1.incrementing_id = var_0_1.incrementing_id + 1
	end

	if #var_151_3 > 0 then
		local var_151_4 = {
			index = 1,
			ends_at = 0,
			name = arg_151_0,
			elements = var_151_3,
			data = arg_151_1,
			max_active_enemies = math.huge,
			id = arg_151_2
		}

		var_151_2[#var_151_2 + 1] = var_151_4

		local var_151_5 = var_151_3[1]
		local var_151_6 = var_151_5[1]
		local var_151_7 = Managers.time:time("game")

		var_0_1.init_functions[var_151_6](var_151_4, var_151_5, var_151_7)
	end

	Managers.telemetry_events:terror_event_started(arg_151_0)
end

var_0_1.stop_event = function (arg_152_0)
	print("TerrorEventMixer.stop_event:", arg_152_0)

	local var_152_0 = var_0_1.active_events
	local var_152_1 = #var_152_0

	for iter_152_0 = 1, var_152_1 do
		local var_152_2 = var_152_0[iter_152_0]

		if var_152_2.name == arg_152_0 then
			table.remove(var_152_0, iter_152_0)
			table.insert(var_0_1.finished_events, var_152_2.name)

			if iter_152_0 <= var_0_1.active_event_i then
				var_0_1.active_event_i = var_0_1.active_event_i - 1
			end

			break
		end
	end
end

var_0_1.find_event = function (arg_153_0)
	local var_153_0 = var_0_1.active_events
	local var_153_1 = #var_153_0

	for iter_153_0 = 1, var_153_1 do
		local var_153_2 = var_153_0[iter_153_0]

		if var_153_2.name == arg_153_0 then
			return var_153_2
		end
	end
end

var_0_1.is_event_id_active_or_pending = function (arg_154_0)
	local var_154_0 = var_0_1.active_events
	local var_154_1 = #var_154_0

	for iter_154_0 = 1, var_154_1 do
		if var_154_0[iter_154_0].id == arg_154_0 then
			return true
		end
	end

	local var_154_2 = var_0_1.start_event_list
	local var_154_3 = #var_154_2

	for iter_154_1 = 1, var_154_3 do
		if var_154_2[iter_154_1].id == arg_154_0 then
			return true
		end
	end

	return false
end

var_0_1.update = function (arg_155_0, arg_155_1, arg_155_2)
	local var_155_0 = var_0_1.active_events

	var_0_1.active_event_i = 1

	while var_0_1.active_event_i <= #var_155_0 do
		local var_155_1 = var_155_0[var_0_1.active_event_i]

		if var_0_1.run_event(var_155_1, arg_155_0, arg_155_1) and var_0_1.find_event(var_155_1.name) then
			table.remove(var_155_0, var_0_1.active_event_i)
			table.insert(var_0_1.finished_events, var_155_1.name)
		else
			var_0_1.active_event_i = var_0_1.active_event_i + 1
		end
	end

	var_0_1.active_event_i = -1

	local var_155_2 = var_0_1.start_event_list

	for iter_155_0 = 1, #var_155_2 do
		local var_155_3 = var_155_2[iter_155_0]
		local var_155_4 = var_155_3.name
		local var_155_5 = var_155_3.data
		local var_155_6 = var_155_3.id

		var_0_1.start_event(var_155_4, var_155_5, var_155_6)

		var_155_2[iter_155_0] = nil
	end

	if script_data.debug_terror and arg_155_2 then
		var_0_1.debug(arg_155_2, var_155_0, arg_155_0, arg_155_1)
	end
end

var_0_1.run_event = function (arg_156_0, arg_156_1, arg_156_2)
	local var_156_0 = arg_156_0.elements
	local var_156_1 = arg_156_0.index
	local var_156_2 = var_156_0[var_156_1]

	if Managers.state.performance:num_active_enemies() > arg_156_0.max_active_enemies then
		var_156_2.ends_at = (var_156_2.ends_at or 0) + arg_156_2
	else
		local var_156_3 = var_156_2[1]
		local var_156_4 = var_156_2 and var_156_2.composition_type or var_156_2.breed_name

		if script_data.debug_terror and var_156_4 then
			printf("[Terror event] Started terror even function: %s with %s", var_156_3, var_156_4)
		end

		if var_0_1.run_functions[var_156_3](arg_156_0, var_156_2, arg_156_1, arg_156_2) then
			if arg_156_0.destroy then
				return true
			end

			local var_156_5 = var_156_1 + 1

			if var_156_5 > #var_156_0 then
				return true
			end

			arg_156_0.index = var_156_5

			local var_156_6 = var_156_0[var_156_5]
			local var_156_7 = var_156_6[1]

			var_0_1.init_functions[var_156_7](arg_156_0, var_156_6, arg_156_1)
		end
	end
end

local var_0_7 = 12
local var_0_8 = "arial"
local var_0_9 = "materials/fonts/" .. var_0_8
local var_0_10, var_0_11 = Application.resolution()
local var_0_12 = 400
local var_0_13 = 0

var_0_1.debug = function (arg_157_0, arg_157_1, arg_157_2, arg_157_3)
	if DebugKeyHandler.key_pressed("mouse_middle_held", "pan terror event mixer", "ai debugger") then
		local var_157_0 = Managers.free_flight.input_manager:get_service("Debug"):get("look")

		var_0_13 = var_0_13 - var_157_0.x * 0.001
	end

	local var_157_1 = 0
	local var_157_2 = 0

	for iter_157_0 = 1, #arg_157_1 do
		local var_157_3 = arg_157_1[iter_157_0]

		if var_157_3 then
			var_0_1.debug_event(arg_157_0, var_157_3, arg_157_2, arg_157_3, var_157_1, var_157_2, var_0_13 * var_0_10, iter_157_0 == 1)

			var_157_1 = var_157_1 + var_0_12 + 15
		end
	end

	for iter_157_1, iter_157_2 in pairs(var_0_1.optional_data) do
		if type(iter_157_2) == "number" then
			local var_157_4 = math.abs(arg_157_2 - iter_157_2)

			Debug.text("Time challenge running: %s Time left: %0.1f ", iter_157_1, var_157_4)
		end
	end
end

var_0_1.debug_event = function (arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4, arg_158_5, arg_158_6, arg_158_7)
	local var_158_0 = arg_158_1.elements
	local var_158_1 = arg_158_1.index
	local var_158_2 = var_158_0[var_158_1][1]
	local var_158_3 = 20 + arg_158_6
	local var_158_4 = 280

	arg_158_4 = arg_158_4 + var_158_3 + 20
	arg_158_5 = arg_158_5 + var_158_4 + 40

	local var_158_5 = arg_158_5
	local var_158_6 = 200
	local var_158_7 = Colors.get_color_with_alpha("gray", 255)
	local var_158_8 = Colors.get_color_with_alpha("cyan", 255)
	local var_158_9 = Colors.get_color_with_alpha("lavender", 255)
	local var_158_10 = Colors.get_color_with_alpha("cadet_blue", 255)
	local var_158_11 = Colors.get_color_with_alpha("orange", 255)

	ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, "Event: " .. arg_158_1.name, var_0_9, var_0_7, var_0_8, arg_158_4 - 10, var_158_5, var_158_6, var_158_11)

	local var_158_12 = var_158_5 + 20

	if arg_158_1.data.spawn_counter then
		for iter_158_0, iter_158_1 in pairs(arg_158_1.data.spawn_counter) do
			local var_158_13 = string.format("#%s:%d", iter_158_0, iter_158_1)

			ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, var_158_13, var_0_9, var_0_7, var_0_8, arg_158_4, var_158_12, var_158_6, var_158_10)

			var_158_12 = var_158_12 + 20
		end
	end

	local var_158_14 = 1

	if var_158_1 > 9 then
		var_158_14 = var_158_1 - 9
	end

	local var_158_15 = #var_158_0

	if var_158_15 - var_158_14 > 18 then
		var_158_15 = var_158_14 + 18
	end

	for iter_158_2 = var_158_14, var_158_1 - 1 do
		local var_158_16 = var_158_0[iter_158_2]
		local var_158_17 = var_158_16[1]
		local var_158_18 = var_158_16.base_event_name
		local var_158_19 = var_0_1.debug_functions[var_158_17] and var_0_1.debug_functions[var_158_17](arg_158_1, var_158_16, arg_158_2, arg_158_3) or ""
		local var_158_20 = string.format(" %d] %s: %s %s", iter_158_2, var_158_18, var_158_17, var_158_19)

		ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, var_158_20, var_0_9, var_0_7, var_0_8, arg_158_4, var_158_12, var_158_6, var_158_7)

		var_158_12 = var_158_12 + 20
	end

	local var_158_21 = Managers.state.performance:num_active_enemies()
	local var_158_22

	if var_158_21 > arg_158_1.max_active_enemies then
		var_158_22 = true
	end

	local var_158_23 = var_158_0[var_158_1]
	local var_158_24 = var_158_23[1]
	local var_158_25 = var_158_23.base_event_name
	local var_158_26 = var_0_1.debug_functions[var_158_24] and var_0_1.debug_functions[var_158_24](arg_158_1, var_158_23, arg_158_2, arg_158_3) or ""
	local var_158_27 = var_158_23.duration and string.format("time: %.1f", arg_158_1.ends_at - arg_158_2) or ""
	local var_158_28

	if var_158_22 then
		var_158_28 = string.format(" %d] %s: %s %s %s FROZEN: %d / %d", var_158_1, var_158_25, var_158_24, var_158_26, var_158_27, var_158_21, arg_158_1.max_active_enemies)
	else
		var_158_28 = string.format(" %d] %s: %s %s %s", var_158_1, var_158_25, var_158_24, var_158_26, var_158_27)
	end

	ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, "==>", var_0_9, var_0_7, var_0_8, arg_158_4 - 20, var_158_12, var_158_6, var_158_22 and var_158_8 or var_158_9)
	ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, var_158_28, var_0_9, var_0_7, var_0_8, arg_158_4, var_158_12, var_158_6, var_158_22 and var_158_8 or var_158_9)

	local var_158_29 = var_158_12 + 20

	for iter_158_3 = var_158_1 + 1, var_158_15 do
		local var_158_30 = var_158_0[iter_158_3]
		local var_158_31 = var_158_30[1]
		local var_158_32 = var_158_30.base_event_name
		local var_158_33 = ""
		local var_158_34 = string.format(" %d] %s: %s %s", iter_158_3, var_158_32, var_158_31, var_158_33)

		ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, var_158_34, var_0_9, var_0_7, var_0_8, arg_158_4, var_158_29, var_158_6, var_158_10)

		var_158_29 = var_158_29 + 20
	end

	ScriptGUI.icrect(arg_158_0, var_0_10, var_0_11, var_158_3, var_158_4, arg_158_4 + var_0_12, var_158_29, var_158_6 - 1, Color(200, 20, 20, 20))

	if arg_158_7 then
		local var_158_35 = Colors.get_color_with_alpha("red", 255)
		local var_158_36 = Colors.get_color_with_alpha("lawn_green", 255)
		local var_158_37 = Managers.state.conflict.running_master_event

		if var_158_37 then
			ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, "Master Event: ", var_0_9, var_0_7, var_0_8, arg_158_4 - 10, var_158_4 - 6, var_158_6, var_158_11)
			ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, var_158_37, var_0_9, var_0_7, var_0_8, arg_158_4 - 10 + 100, var_158_4 - 6, var_158_6, var_158_36)
		else
			ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, "Master Event: ", var_0_9, var_0_7, var_0_8, arg_158_4 - 10, var_158_4 - 6, var_158_6, var_158_11)
			ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, "disabled", var_0_9, var_0_7, var_0_8, arg_158_4 - 10 + 75, var_158_4 - 6, var_158_6, var_158_35)
		end

		ScriptGUI.ictext(arg_158_0, var_0_10, var_0_11, string.format("Active enemies: %d / %d", var_158_21, arg_158_1.max_active_enemies), var_0_9, var_0_7, var_0_8, arg_158_4 - 10, var_158_4 + 12, var_158_6, var_158_22 and var_158_35 or var_158_36)
		ScriptGUI.icrect(arg_158_0, var_0_10, var_0_11, var_158_3, var_158_4 - 22, arg_158_4 + var_0_12, var_158_4, var_158_6 - 1, Color(200, 20, 20, 20))
	end
end

local var_0_14
local var_0_15 = "\n"

for iter_0_0, iter_0_1 in pairs(TerrorEventBlueprints) do
	for iter_0_2 = 1, #iter_0_1 do
		local var_0_16 = iter_0_1[iter_0_2][1]

		if not var_0_1.init_functions[var_0_16] then
			var_0_15 = var_0_15 .. string.format("Bad terror event: '%s', there is no element called '%s'. \n", tostring(iter_0_0), tostring(var_0_16))
			var_0_14 = true
		end
	end
end

if var_0_14 then
	assert(false, var_0_15)
end
