-- chunkname: @scripts/managers/conflict_director/conflict_director.lua

USE_ENGINE_SLOID_SYSTEM = EngineOptimized.init_sloid_system ~= nil

require("scripts/settings/breeds")
require("scripts/managers/conflict_director/terror_event_mixer")
require("scripts/settings/conflict_settings")
require("scripts/managers/conflict_director/conflict_utils")
require("scripts/managers/conflict_director/main_path_utils")
require("scripts/managers/conflict_director/pack_spawner_utils")
require("scripts/managers/conflict_director/formation_utils")
require("scripts/managers/conflict_director/breed_packs")
require("scripts/managers/conflict_director/encampment_templates")
require("scripts/managers/conflict_director/pacing")
require("scripts/managers/conflict_director/enemy_recycler")
require("scripts/managers/conflict_director/level_analysis")
require("scripts/managers/conflict_director/patrol_analysis")
require("scripts/managers/conflict_director/horde_spawner")
require("scripts/managers/conflict_director/a_star")
require("scripts/managers/conflict_director/specials_pacing")
require("scripts/managers/conflict_director/perlin_path")
require("scripts/managers/conflict_director/spawn_zone_baker")
require("scripts/managers/conflict_director/nav_tag_volume_handler")
require("scripts/managers/conflict_director/conflict_director_tests")
require("scripts/managers/conflict_director/breed_freezer")
require("scripts/managers/conflict_director/peak_delayer")
require("scripts/managers/conflict_director/gathering")
require("scripts/settings/level_settings")
require("scripts/utils/perlin_noise")
require("scripts/utils/navigation_group_manager")
require("scripts/settings/syntax_watchdog")
require("scripts/settings/patrol_formation_settings")
require("scripts/utils/debug_list_picker")
require("scripts/utils/ik_chain")

local var_0_0 = POSITION_LOOKUP
local var_0_1 = BLACKBOARDS
local var_0_2 = Vector3.distance_squared
local var_0_3 = RecycleSettings
local var_0_4 = true
local var_0_5 = {
	"rpc_terror_event_trigger_flow"
}
local var_0_6 = script_data

var_0_6.debug_terror = var_0_6.debug_terror or Development.parameter("debug_terror")
var_0_6.ai_roaming_spawning_disabled = var_0_6.ai_roaming_spawning_disabled or Development.parameter("ai_roaming_spawning_disabled")
var_0_6.ai_specials_spawning_disabled = var_0_6.ai_specials_spawning_disabled or Development.parameter("ai_specials_spawning_disabled")
var_0_6.ai_horde_spawning_disabled = var_0_6.ai_horde_spawning_disabled or Development.parameter("ai_horde_spawning_disabled")
var_0_6.ai_pacing_disabled = var_0_6.ai_pacing_disabled or Development.parameter("ai_pacing_disabled")
var_0_6.ai_far_off_despawn_disabled = var_0_6.ai_far_off_despawn_disabled or Development.parameter("ai_far_off_despawn_disabled")
var_0_6.debug_player_positioning = var_0_6.debug_player_positioning or Development.parameter("debug_player_positioning")

local function var_0_7(arg_1_0, arg_1_1)
	local var_1_0 = {}

	for iter_1_0 = 1, arg_1_1 do
		local var_1_1 = arg_1_0[iter_1_0]

		if var_1_1.peak then
			var_1_0[#var_1_0 + 1] = var_1_1.travel_dist
		end
	end

	return var_1_0
end

local var_0_8 = var_0_6.testify and require("scripts/managers/conflict_director/conflict_director_testify")

ConflictDirector = class(ConflictDirector)

function ConflictDirector.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_0._world = arg_2_1
	arg_2_0._time = 0
	arg_2_0._level_key = arg_2_2
	arg_2_0._conflict_data_by_side = {}
	arg_2_0.num_spawned_by_breed = {}
	arg_2_0._num_spawned_ai = 0
	arg_2_0._all_spawned_units = Script.new_array(128)
	arg_2_0._all_spawned_units_lookup = {}
	arg_2_0.num_queued_spawn_by_breed = {}

	TerrorEventUtils.set_seed(arg_2_4)

	arg_2_0._current_debug_list_index = 1
	arg_2_0._debug_list = {
		"none"
	}

	local var_2_0 = LevelSettings[arg_2_2]

	arg_2_0.initial_conflict_settings = arg_2_6

	arg_2_0:set_updated_settings(arg_2_6)

	arg_2_0.pacing = Pacing:new(arg_2_1)
	arg_2_0.enemy_recycler = nil
	arg_2_0.specials_pacing = nil
	arg_2_0.navigation_group_manager = NavigationGroupManager:new()
	arg_2_0._alive_specials = {}
	arg_2_0._alive_bosses = {}
	arg_2_0._alive_standards = {}
	arg_2_0._next_pacing_update = Math.random()
	arg_2_0._next_threat_update = arg_2_0._next_pacing_update + 0.1
	arg_2_0._living_horde = 0
	arg_2_0._horde_ends_at = math.huge
	arg_2_0._num_angry_bosses = 0
	arg_2_0._next_horde_time = math.huge
	arg_2_0._player_directions = {}
	arg_2_0._drop_crumb_time = 0
	arg_2_0.world_gui = World.create_world_gui(arg_2_1, Matrix4x4.identity(), 1, 1, "immediate", "material", "materials/fonts/gw_fonts")
	arg_2_0._player_areas = {}

	arg_2_0:reset_queued_spawn_by_breed()
	TerrorEventMixer.reset()

	arg_2_0._rushing_checks = {}
	arg_2_0._next_rush_check_unit = nil
	arg_2_0._next_rush_check = math.huge
	arg_2_0.spawn_queue = {}
	arg_2_0.first_spawn_index = 1
	arg_2_0.spawn_queue_size = 0
	arg_2_0.spawn_queue_id = 0
	arg_2_0.main_path_player_info = {}
	arg_2_0._spawn_queue_id_lut = Script.new_array(1024)

	arg_2_0:_setup_sides_to_update_recycler()

	local var_2_1 = Managers.state.side:get_side_from_name("dark_pact")

	if var_2_1 then
		arg_2_0.default_enemy_side_id = var_2_1.side_id

		fassert(arg_2_0.default_enemy_side_id, "default enemy side id is missing")
	else
		arg_2_0.default_enemy_side_id = 2
		var_2_1 = Managers.state.side:get_side(2)
	end

	arg_2_0._enemy_side = var_2_1
	arg_2_0._master_event_id = 0

	local var_2_2 = arg_2_0._conflict_data_by_side
	local var_2_3 = Managers.state.side:sides()

	for iter_2_0, iter_2_1 in pairs(var_2_3) do
		var_2_2[iter_2_0] = {
			num_spawned_ai_event = 0,
			num_spawned_ai = 0,
			spawned = {},
			spawned_lookup = {},
			spawned_units_by_breed = {},
			num_spawned_by_breed = {},
			num_spawned_by_breed_during_event = {}
		}

		arg_2_0:_reset_spawned_by_breed(iter_2_0)
		arg_2_0:_reset_spawned_by_breed_during_event(iter_2_0)
	end

	local var_2_4 = Managers.state.side:get_side_from_name("heroes") or Managers.state.side:get_side(1)

	arg_2_0._hero_side = var_2_4

	local var_2_5
	local var_2_6

	if var_2_4 then
		arg_2_0.default_hero_side_id = var_2_4.side_id

		local var_2_7 = var_2_4.PLAYER_UNITS

		var_2_5 = var_2_7[1]
		var_2_6 = var_2_7[1]
	end

	arg_2_0.main_path_info = {
		current_path_index = 1,
		behind_percent = 1,
		ahead_percent = 0,
		ahead_travel_dist = 0,
		main_path_player_info_index = 0,
		ahead_unit = var_2_5,
		behind_unit = var_2_6,
		player_info_by_travel_distance = {}
	}
	arg_2_0._main_path_obstacles = {}
	arg_2_0._next_progression_percent = 0.1
	arg_2_0._next_rushing_intervention_time = 5.1
	arg_2_0._rushing_intervention_travel_dist = 50
	arg_2_0.rushing_intervention_data = {
		ahead_dist = 0,
		loneliness_value = 0
	}
	arg_2_0._next_speed_running_intervention_time = 5.1
	arg_2_0.speed_running_intervention_data = {
		next_travel_dist_check_t = 10,
		player_travel_distances = {},
		total_travel_distances = {}
	}
	arg_2_0.in_safe_zone = true
	arg_2_0.disabled = false
	arg_2_0._mini_patrol_state = "waiting"
	arg_2_0._next_mini_patrol_timer = 15

	local var_2_8 = var_2_0.level_name

	arg_2_0.level_analysis = LevelAnalysis:new(nil, false, var_2_8, arg_2_4)
	arg_2_0._network_event_delegate = arg_2_3

	arg_2_3:register(arg_2_0, unpack(var_0_5))

	arg_2_0.frozen_intensity_decay_until = 0
	arg_2_0.threat_value = 0
	arg_2_0.num_aggroed = 0

	local var_2_9, var_2_10 = Managers.state.difficulty:get_difficulty()

	arg_2_0._delay_horde = nil
	arg_2_0.delay_horde_threat_value = CurrentPacing.delay_horde_threat_value and DifficultyTweak.converters.tweaked_delay_threat_value(var_2_9, var_2_10, CurrentPacing.delay_horde_threat_value) or math.huge
	arg_2_0.delay_mini_patrol_threat_value = CurrentPacing.delay_mini_patrol_threat_value and DifficultyTweak.converters.tweaked_delay_threat_value(var_2_9, var_2_10, CurrentPacing.delay_mini_patrol_threat_value) or math.huge
	arg_2_0.delay_specials_threat_value = CurrentPacing.delay_specials_threat_value and DifficultyTweak.converters.tweaked_delay_threat_value(var_2_9, var_2_10, CurrentPacing.delay_specials_threat_value) or math.huge

	Managers.state.event:register(arg_2_0, "event_delay_pacing", "event_delay_pacing")
end

function ConflictDirector._setup_sides_to_update_recycler(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = Managers.state.side:sides()
	local var_3_2 = 1

	for iter_3_0 = 1, #var_3_1 do
		local var_3_3 = var_3_1[iter_3_0]

		if var_3_3.using_enemy_recycler then
			var_3_0[var_3_2] = var_3_3
			var_3_2 = var_3_2 + 1
		end
	end

	arg_3_0.sides_to_update_recycler = var_3_0
end

function ConflictDirector.rpc_terror_event_trigger_flow(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = NetworkLookup.terror_flow_events[arg_4_2]

	arg_4_0:level_flow_event(var_4_0)
end

local function var_0_9(arg_5_0, arg_5_1)
	local var_5_0 = #arg_5_0

	for iter_5_0 = 1, var_5_0 do
		if arg_5_0[iter_5_0] == arg_5_1 then
			arg_5_0[iter_5_0] = arg_5_0[var_5_0]
			arg_5_0[var_5_0] = nil

			return
		end
	end
end

function ConflictDirector.alive_specials_count(arg_6_0)
	local var_6_0 = 0

	for iter_6_0, iter_6_1 in ipairs(arg_6_0._alive_specials) do
		if ALIVE[iter_6_1] then
			var_6_0 = var_6_0 + 1
		end
	end

	return var_6_0
end

function ConflictDirector.alive_specials(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1 or {}

	for iter_7_0, iter_7_1 in ipairs(arg_7_0._alive_specials) do
		if ALIVE[iter_7_1] then
			var_7_0[#var_7_0 + 1] = iter_7_1
		end
	end

	return var_7_0
end

function ConflictDirector.alive_bosses(arg_8_0)
	return arg_8_0._alive_bosses
end

function ConflictDirector.alive_standards(arg_9_0)
	return arg_9_0._alive_standards
end

function ConflictDirector.reset_queued_spawn_by_breed(arg_10_0)
	for iter_10_0, iter_10_1 in pairs(Breeds) do
		arg_10_0.num_queued_spawn_by_breed[iter_10_0] = 0
	end
end

function ConflictDirector._reset_spawned_by_breed(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._conflict_data_by_side[arg_11_1 or arg_11_0.default_enemy_side_id]

	for iter_11_0, iter_11_1 in pairs(Breeds) do
		var_11_0.num_spawned_by_breed[iter_11_0] = 0
		var_11_0.spawned_units_by_breed[iter_11_0] = {}
		arg_11_0.num_spawned_by_breed[iter_11_0] = 0
	end
end

function ConflictDirector._reset_spawned_by_breed_during_event(arg_12_0, arg_12_1)
	arg_12_0._master_event_id = arg_12_0._master_event_id + 1

	local var_12_0 = arg_12_0._conflict_data_by_side[arg_12_1 or arg_12_0.default_enemy_side_id]

	for iter_12_0, iter_12_1 in pairs(Breeds) do
		var_12_0.num_spawned_by_breed_during_event[iter_12_0] = 0
	end

	var_12_0.num_spawned_ai_event = 0
end

function ConflictDirector.destroy(arg_13_0)
	local var_13_0 = Managers.state.event

	if var_13_0 then
		var_13_0:unregister("event_delay_pacing", arg_13_0)
	end

	arg_13_0.navigation_group_manager:destroy(arg_13_0._world)

	if arg_13_0.nav_tag_volume_handler then
		arg_13_0.nav_tag_volume_handler:destroy()

		arg_13_0.nav_tag_volume_handler = nil
	end

	if arg_13_0.patrol_analysis then
		arg_13_0.patrol_analysis:destroy()

		arg_13_0.patrol_analysis = nil
	end

	arg_13_0.level_analysis:destroy()
	arg_13_0._network_event_delegate:unregister(arg_13_0)

	arg_13_0._main_path_obstacles = nil

	if arg_13_0.breed_freezer then
		arg_13_0.breed_freezer:destroy()
	end

	local var_13_1 = arg_13_0.main_path_player_info

	if var_13_1 then
		for iter_13_0, iter_13_1 in pairs(var_13_1) do
			local var_13_2 = iter_13_1.astar

			if var_13_2 then
				GwNavAStar.destroy(var_13_2)

				iter_13_1.astar = nil
			end
		end
	end
end

function ConflictDirector.get_player_unit_segment(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.main_path_player_info[arg_14_1]

	return var_14_0 and var_14_0.path_index or nil
end

function ConflictDirector.get_player_unit_travel_distance(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.main_path_player_info[arg_15_1]

	return var_15_0 and var_15_0.travel_dist or nil
end

function ConflictDirector.stop_rush_check(arg_16_0, arg_16_1)
	arg_16_0._next_rush_check = math.huge

	table.clear(arg_16_0._rushing_checks)
end

function ConflictDirector.init_rush_check(arg_17_0, arg_17_1)
	arg_17_0.players_speeding_dist = 0
	arg_17_0._next_rush_check = 0
end

function ConflictDirector.are_players_rushing(arg_18_0, arg_18_1)
	if arg_18_1 > arg_18_0._next_rush_check then
		local var_18_0 = arg_18_0.main_path_player_info
		local var_18_1 = arg_18_0._hero_side.PLAYER_UNITS

		arg_18_0._next_rush_check_unit = next(var_18_1, arg_18_0._next_rush_check_unit)

		local var_18_2 = var_18_1[arg_18_0._next_rush_check_unit]

		if var_18_2 then
			local var_18_3 = var_18_0[var_18_2]

			if not var_18_3 then
				return
			end

			local var_18_4 = arg_18_0._rushing_checks
			local var_18_5 = var_18_4[var_18_2]

			if not var_18_5 then
				var_18_5 = {
					start_pos = Vector3Box(var_18_3.path_pos:unbox()),
					start_dist = var_18_3.travel_dist
				}
				var_18_4[var_18_2] = var_18_5

				return
			end

			local var_18_6 = var_18_0[var_18_2].travel_dist - var_18_5.start_dist

			if var_18_6 > arg_18_0.players_speeding_dist then
				arg_18_0.players_speeding_dist = var_18_6
			end

			if var_18_6 > CurrentPacing.relax_rushing_distance then
				return true
			end
		else
			arg_18_0._next_rush_check = arg_18_1 + 1
		end
	end
end

function ConflictDirector.main_path_completion(arg_19_0, arg_19_1)
	local var_19_0 = 0
	local var_19_1 = arg_19_0.main_path_player_info[arg_19_1]

	return var_19_1 and var_19_1.move_percent or 0
end

function ConflictDirector.sort_player_info_by_travel_distance(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1.player_info_by_travel_distance

	table.clear(var_20_0)

	local var_20_1 = 0

	for iter_20_0, iter_20_1 in pairs(arg_20_2) do
		var_20_1 = var_20_1 + 1
		var_20_0[var_20_1] = iter_20_1
	end

	if var_20_1 > 0 then
		table.sort(var_20_0, function(arg_21_0, arg_21_1)
			return arg_21_0.travel_dist < arg_21_1.travel_dist
		end)

		local var_20_2 = var_20_0[1]

		arg_20_1.ahead_unit = var_20_2.unit
		arg_20_1.ahead_percent = var_20_2.move_percent
		arg_20_1.ahead_travel_dist = var_20_2.travel_dist
		arg_20_1.behind_unit = var_20_0[var_20_1].unit
		arg_20_1.behind_percent = var_20_2.move_percent
	else
		arg_20_1.ahead_unit = nil
		arg_20_1.ahead_percent = 0
		arg_20_1.ahead_travel_dist = 0
		arg_20_1.behind_unit = nil
		arg_20_1.behind_percent = 1
	end
end

function ConflictDirector.main_path_player_far_away_check(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0 = math.abs(arg_22_2 - arg_22_1.travel_dist) > 100

	if var_22_0 then
		local var_22_1 = arg_22_1.astar

		if var_22_1 then
			if GwNavAStar.processing_finished(var_22_1) then
				if GwNavAStar.path_found(var_22_1) then
					var_22_0 = false
				end

				GwNavAStar.destroy(var_22_1)

				arg_22_1.astar = nil
				arg_22_1.astar_timer = 0
				arg_22_1.astar_timer = arg_22_5 + 3
			end
		elseif arg_22_5 > arg_22_1.astar_timer then
			print("main_path_player_far_away_check started")

			local var_22_2 = GwNavAStar.create(arg_22_0.nav_world)
			local var_22_3 = Managers.state.bot_nav_transition:traverse_logic()

			GwNavAStar.start_with_propagation_box(var_22_2, arg_22_0.nav_world, arg_22_4, arg_22_3, 30, var_22_3)

			arg_22_1.astar = var_22_2
			arg_22_1.astar_timer = arg_22_5 + 3
		end
	end

	return var_22_0
end

function ConflictDirector.update_main_path_player_info(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.main_path_info

	if not var_23_0.main_paths then
		return
	end

	local var_23_1 = arg_23_0.main_path_player_info
	local var_23_2 = var_23_0.main_path_player_info_index + 1
	local var_23_3 = arg_23_1.PLAYER_AND_BOT_UNITS
	local var_23_4 = arg_23_1.PLAYER_AND_BOT_POSITIONS

	if var_23_2 > #var_23_3 then
		var_23_2 = 1
	end

	var_23_0.main_path_player_info_index = var_23_2

	local var_23_5 = var_23_3[var_23_2]

	if var_23_5 then
		local var_23_6 = var_23_4[var_23_2]
		local var_23_7 = arg_23_0.navigation_group_manager
		local var_23_8 = var_23_7:get_group_from_position(var_23_6)

		if not var_23_8 then
			local var_23_9 = 1
			local var_23_10 = 3
			local var_23_11 = 3
			local var_23_12 = 0.1
			local var_23_13 = arg_23_0.nav_world
			local var_23_14 = GwNavQueries.inside_position_from_outside_position(var_23_13, var_23_6, var_23_9, var_23_10, var_23_11, var_23_12)

			if var_23_14 then
				var_23_8 = var_23_7:get_group_from_position(var_23_14)
			else
				var_23_8 = arg_23_0._player_areas[var_23_2]
			end
		end

		local var_23_15

		if var_23_8 then
			var_23_15 = var_23_8:get_main_path_index()
		end

		local var_23_16, var_23_17, var_23_18, var_23_19, var_23_20 = MainPathUtils.closest_pos_at_main_path(nil, var_23_6, var_23_15)
		local var_23_21 = var_23_1[var_23_5]

		if not var_23_21 then
			var_23_21 = {
				astar_timer = 0,
				path_pos = Vector3Box(),
				unit = var_23_5,
				total_path_dist = MainPathUtils.total_path_dist(),
				travel_dist = var_23_17
			}
			var_23_1[var_23_5] = var_23_21
		end

		if not arg_23_0:main_path_player_far_away_check(var_23_21, var_23_17, var_23_16, var_23_6, arg_23_2) then
			var_23_21.travel_dist, var_23_21.move_percent, var_23_21.sub_index, var_23_21.path_index = var_23_17, var_23_18, var_23_19, var_23_20

			var_23_21.path_pos:store(var_23_16)

			if var_23_20 then
				var_23_0.current_path_index = math.max(var_23_20, var_23_0.current_path_index)
			end

			if var_23_18 >= var_23_0.ahead_percent or var_23_0.ahead_unit == var_23_5 then
				local var_23_22, var_23_23, var_23_24 = arg_23_0.spawn_zone_baker:get_zone_segment_from_travel_dist(var_23_17)
				local var_23_25

				if var_23_24 then
					var_23_25 = arg_23_0:check_update_mutators(var_23_24.mutators)
				end

				local var_23_26 = false

				if not var_0_6.override_conflict_settings and var_23_24 and arg_23_0.current_conflict_settings ~= var_23_24.conflict_setting.name and not arg_23_0.level_settings.ignore_zone_conflict_settings then
					local var_23_27 = var_23_24.conflict_setting.name

					var_23_26 = arg_23_0:check_updated_settings(var_23_27)
				end

				if var_23_25 and not var_23_26 then
					arg_23_0:refresh_conflict_director_patches()
				end

				if var_23_18 >= arg_23_0._next_progression_percent then
					Managers.telemetry_events:level_progression(arg_23_0._next_progression_percent)

					arg_23_0._next_progression_percent = arg_23_0._next_progression_percent + 0.1
				end

				var_23_0.ahead_percent = var_23_18
				var_23_0.ahead_unit = var_23_5
				var_23_0.ahead_travel_dist = var_23_17
				var_23_0.zone_index = var_23_22
			end

			if var_23_18 <= var_23_0.behind_percent or var_23_0.behind_unit == var_23_5 then
				var_23_0.behind_percent = var_23_18
				var_23_0.behind_unit = var_23_5
			end
		end
	end

	local var_23_28 = false

	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		if not ALIVE[iter_23_0] then
			var_23_1[iter_23_0] = nil
			var_23_28 = true
		end
	end

	if var_23_28 then
		arg_23_0:sort_player_info_by_travel_distance(var_23_0, var_23_1)
	end
end

function ConflictDirector.get_main_path_player_data(arg_24_0, arg_24_1)
	return arg_24_0.main_path_player_info[arg_24_1]
end

function ConflictDirector.get_cluster_and_loneliness(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_0._cluster_and_loneliness[arg_25_1] then
		local var_25_0 = arg_25_0._cluster_and_loneliness[arg_25_1]

		return var_25_0[1], var_25_0[2], var_25_0[3], var_25_0[4]
	end

	local var_25_1, var_25_2, var_25_3 = ConflictUtils.cluster_weight_and_loneliness(arg_25_2, arg_25_1 or 10)
	local var_25_4 = arg_25_3[var_25_2]
	local var_25_5 = FrameTable.alloc_table()

	var_25_5[1] = var_25_1
	var_25_5[2] = arg_25_2[var_25_2]
	var_25_5[3] = var_25_3
	var_25_5[4] = var_25_4
	arg_25_0._cluster_and_loneliness[arg_25_1] = var_25_5

	return var_25_1, arg_25_2[var_25_2], var_25_3, var_25_4
end

function ConflictDirector.update_player_areas(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._player_areas

	table.clear_array(var_26_0, #var_26_0)

	if arg_26_0.navigation_group_manager.operational then
		for iter_26_0 = 1, #arg_26_1 do
			local var_26_1 = arg_26_1[iter_26_0].PLAYER_UNITS

			for iter_26_1 = 1, #var_26_1 do
				local var_26_2 = var_26_1[iter_26_1]
				local var_26_3 = ScriptUnit.extension(var_26_2, "whereabouts_system"):last_position_on_navmesh()
				local var_26_4 = var_26_3 and arg_26_0.navigation_group_manager:get_group_from_position(var_26_3)

				if var_26_4 then
					var_26_0[iter_26_1] = var_26_4
				else
					var_26_0[iter_26_1] = false
				end
			end
		end
	end
end

function ConflictDirector.add_horde(arg_27_0, arg_27_1, arg_27_2)
	arg_27_0._living_horde = arg_27_0._living_horde + arg_27_1

	if arg_27_2 then
		local var_27_0 = arg_27_0._spawned_units_by_breed_during_event[arg_27_2]

		var_27_0[breed_name] = var_27_0[breed_name] + 1
	end
end

function ConflictDirector.set_master_event_running(arg_28_0, arg_28_1)
	if arg_28_0.running_master_event ~= arg_28_1 then
		arg_28_0:_reset_spawned_by_breed_during_event()
	end

	arg_28_0.running_master_event = arg_28_1
end

function ConflictDirector.spawned_during_event(arg_29_0, arg_29_1)
	return arg_29_0._conflict_data_by_side[arg_29_1].num_spawned_ai_event
end

function ConflictDirector.enemies_spawned_during_event(arg_30_0)
	return arg_30_0._conflict_data_by_side[arg_30_0.default_enemy_side_id].num_spawned_ai_event
end

function ConflictDirector.horde_size(arg_31_0)
	return arg_31_0._living_horde, arg_31_0._horde_ends_at
end

function ConflictDirector.has_horde(arg_32_0)
	if arg_32_0.horde_spawner then
		return arg_32_0.horde_spawner:running_horde()
	end
end

function ConflictDirector.is_horde_alive(arg_33_0)
	local var_33_0, var_33_1 = arg_33_0:has_horde()

	return arg_33_0:horde_size() >= 1 or var_33_0, var_33_0, var_33_1
end

function ConflictDirector.mini_patrol(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	local var_34_0 = true
	local var_34_1 = 1
	local var_34_2 = true

	arg_34_0._last_mini_patrol_composition = arg_34_4

	arg_34_0.horde_spawner:execute_event_horde(arg_34_1, arg_34_2, arg_34_3, arg_34_4, var_34_1, var_34_2, arg_34_5, var_34_0, nil, nil, nil, arg_34_6)
end

function ConflictDirector.mini_patrol_killed(arg_35_0, arg_35_1)
	print("Mini patrol killed!", arg_35_1)
end

function ConflictDirector.event_horde(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9)
	if not var_0_6.ai_horde_spawning_disabled then
		arg_36_3 = arg_36_3 or arg_36_0.default_enemy_side_id

		return (arg_36_0.horde_spawner:execute_event_horde(arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, nil, arg_36_8, nil, nil, arg_36_9))
	end
end

function ConflictDirector.check_updated_settings(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.current_conflict_settings
	local var_37_1 = var_0_6

	if var_37_1.override_conflict_settings and var_37_1.override_conflict_settings ~= var_37_0 then
		arg_37_1 = var_37_1.override_conflict_settings
	end

	if arg_37_1 and var_37_0 ~= arg_37_1 then
		local var_37_2 = LevelHelper:current_level_settings()

		arg_37_0.level_settings = var_37_2

		local var_37_3 = var_37_2.conflict_settings

		if var_37_3 and ConflictDirectors[var_37_3].disabled then
			return
		end

		local var_37_4 = arg_37_1 or arg_37_0.current_conflict_settings

		var_37_4 = var_37_4 or var_37_3 or "default"

		arg_37_0:set_updated_settings(var_37_4)

		return true
	end

	return false
end

function ConflictDirector.check_update_mutators(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._current_zone_mutators
	local var_38_1
	local var_38_2

	if not var_38_0 then
		var_38_2 = arg_38_1
	elseif arg_38_1 ~= var_38_0 then
		var_38_1 = {}
		var_38_2 = {}

		for iter_38_0, iter_38_1 in ipairs(var_38_0) do
			if table.index_of(arg_38_1, iter_38_1) == -1 then
				var_38_1[#var_38_1 + 1] = iter_38_1
			end
		end

		for iter_38_2, iter_38_3 in ipairs(arg_38_1) do
			if table.index_of(var_38_0, iter_38_3) == -1 then
				var_38_2[#var_38_2 + 1] = iter_38_3
			end
		end
	end

	local var_38_3 = false

	if var_38_1 then
		for iter_38_4, iter_38_5 in ipairs(var_38_1) do
			Managers.state.game_mode._mutator_handler:deactivate_mutator(iter_38_5)

			var_38_3 = var_38_3 or MutatorTemplates[iter_38_5].update_conflict_settings ~= nil
		end
	end

	if var_38_2 then
		for iter_38_6, iter_38_7 in ipairs(var_38_2) do
			Managers.state.game_mode._mutator_handler:initialize_mutators({
				iter_38_7
			})
			Managers.state.game_mode._mutator_handler:activate_mutator(iter_38_7)

			var_38_3 = var_38_3 or MutatorTemplates[iter_38_7].update_conflict_settings ~= nil
		end
	end

	arg_38_0._current_zone_mutators = arg_38_1

	return var_38_3
end

function ConflictDirector.set_updated_settings(arg_39_0, arg_39_1)
	fassert(arg_39_1 ~= "random", "Should not get a 'random' setting in ConflictDirector:set_updated_settings")

	local var_39_0 = ConflictDirectors[arg_39_1]

	CurrentConflictSettings = var_39_0
	arg_39_0.current_conflict_settings = arg_39_1

	arg_39_0:refresh_conflict_director_patches()

	local var_39_1 = var_39_0

	print("Switching ConflictSettings: to: " .. tostring(var_39_1.name))

	for iter_39_0, iter_39_1 in pairs(var_39_1) do
		if type(iter_39_1) == "table" then
			print("\t" .. tostring(iter_39_0) .. "=" .. tostring(iter_39_1.name))
		else
			print("\t" .. tostring(iter_39_0) .. "=" .. tostring(iter_39_1))
		end
	end

	print("---")
end

function ConflictDirector.refresh_conflict_director_patches(arg_40_0)
	local var_40_0 = ConflictDirectors[arg_40_0.current_conflict_settings]
	local var_40_1, var_40_2 = Managers.state.difficulty:get_difficulty()
	local var_40_3 = Managers.state.difficulty.fallback_difficulty
	local var_40_4 = DifficultyTweak.converters.composition(var_40_1, var_40_2)
	local var_40_5 = DifficultyTweak.converters.pacing(var_40_1, var_40_2)
	local var_40_6 = DifficultyTweak.converters.intensity(var_40_1, var_40_2)

	CurrentIntensitySettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.intensity), var_40_6, var_40_3)
	CurrentPacing = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.pacing), var_40_5, var_40_3)
	CurrentBossSettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.boss), var_40_1, var_40_3)
	CurrentSpecialsSettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.specials), var_40_4, var_40_3)
	CurrentHordeSettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.horde), var_40_4, var_40_3)
	CurrentRoamingSettings = table.clone(var_40_0.roaming)
	CurrentPackSpawningSettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.pack_spawning), var_40_4, var_40_3)

	if Managers.state.game_mode then
		Managers.state.game_mode:conflict_director_updated_settings()
	end
end

function ConflictDirector.update_horde_pacing(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0.pacing

	if var_41_0:horde_population() < 1 or var_41_0.pacing_state == "pacing_frozen" then
		arg_41_0._next_horde_time = nil

		return
	end

	if not arg_41_0._next_horde_time then
		arg_41_0._next_horde_time = arg_41_1 + ConflictUtils.random_interval(CurrentPacing.horde_frequency)
	end

	if arg_41_1 > arg_41_0._next_horde_time and not arg_41_0.delay_horde then
		local var_41_1 = arg_41_0._conflict_data_by_side[arg_41_0.default_enemy_side_id]
		local var_41_2 = #var_41_1.spawned

		if var_41_2 > var_0_3.push_horde_if_num_alive_grunts_above then
			local var_41_3 = CurrentPacing

			if var_0_3.push_horde_in_time then
				print("HORDE: Pushing horde in time; too many units out " .. var_41_2)

				arg_41_0._next_horde_time = arg_41_1 + 5

				var_41_0:annotate_graph("Pushed horde", "red")
			else
				print("HORDE: Skipped horde; too many units out")

				arg_41_0._next_horde_time = arg_41_1 + ConflictUtils.random_interval(var_41_3.horde_frequency)

				var_41_0:annotate_graph("Failed horde", "red")
			end

			return
		end

		local var_41_4
		local var_41_5
		local var_41_6
		local var_41_7

		if var_0_6.ai_pacing_disabled then
			arg_41_0._next_horde_time = math.huge
			arg_41_0._multiple_horde_count = nil
			var_41_4 = "unknown"
			arg_41_0._wave = var_41_4
		else
			local var_41_8
			local var_41_9 = CurrentPacing

			if var_41_9.multiple_hordes then
				if arg_41_0._multiple_horde_count then
					arg_41_0._multiple_horde_count = arg_41_0._multiple_horde_count - 1

					if arg_41_0._multiple_horde_count <= 0 then
						print("HORDE: last wave, reset to standard horde delay")

						var_41_7 = arg_41_0._current_wave_composition
						arg_41_0._next_horde_time = arg_41_1 + ConflictUtils.random_interval(var_41_9.max_delay_until_next_horde)
						arg_41_0._multiple_horde_count = nil
						arg_41_0._current_wave_composition = nil
						var_41_4 = "multi_last_wave"
					else
						local var_41_10 = ConflictUtils.random_interval(var_41_9.multiple_horde_frequency)

						print("HORDE: next wave, multiple_horde_frequency -> Time delay", var_41_10)

						arg_41_0._next_horde_time = arg_41_1 + var_41_10
						var_41_4 = "multi_consecutive_wave"
						var_41_7 = arg_41_0._current_wave_composition
					end

					var_41_5 = "multi_followup"
					var_41_6 = true
				else
					arg_41_0._multiple_horde_count = var_41_9.multiple_hordes - 1
					arg_41_0._next_horde_time = arg_41_1 + ConflictUtils.random_interval(var_41_9.multiple_horde_frequency)
					var_41_4 = "multi_first_wave"
				end
			else
				arg_41_0._next_horde_time = arg_41_1 + ConflictUtils.random_interval(var_41_9.horde_frequency)
				var_41_4 = "single_wave"
			end

			arg_41_0._wave = var_41_4
		end

		local var_41_11 = CurrentHordeSettings

		if not var_41_5 then
			if var_41_11.mix_paced_hordes then
				if arg_41_0.horde_spawner.num_paced_hordes % 2 == 0 then
					var_41_5 = math.random() < var_41_11.chance_of_vector and "vector" or "ambush"
				else
					var_41_5 = arg_41_0.horde_spawner.last_paced_horde_type == "vector" and "ambush" or "vector"
				end
			else
				var_41_5 = math.random() < var_41_11.chance_of_vector and "vector" or "ambush"
			end

			if var_41_5 == "vector" and math.random() <= var_41_11.chance_of_vector_blob then
				var_41_5 = "vector_blob"
			end

			local var_41_12 = var_41_5 == "vector" and var_41_11.vector_composition or var_41_5 == "vector_blob" and var_41_11.vector_blob_composition or var_41_11.ambush_composition

			if var_41_4 and type(var_41_12) == "table" then
				var_41_7 = var_41_12[math.random(#var_41_12)]

				printf("HORDE: Chosing horde wave composition %s", var_41_7)

				arg_41_0._current_wave_composition = var_41_7
			end
		elseif var_41_5 == "multi_followup" then
			var_41_5 = arg_41_0.horde_spawner.last_paced_horde_type
		end

		print("Time for new HOOORDE!", var_41_4)

		arg_41_0._horde_ends_at = arg_41_1 + 120

		local var_41_13 = {
			multiple_horde_count = arg_41_0._multiple_horde_count,
			horde_wave = var_41_4,
			optional_wave_composition = var_41_7
		}
		local var_41_14 = arg_41_0.default_enemy_side_id

		print("HORDE: Spawning hordes while " .. #var_41_1.spawned .. " other ai are spawned")
		arg_41_0.horde_spawner:horde(var_41_5, var_41_13, var_41_14, var_41_6)
	end
end

function ConflictDirector.horde_killed(arg_42_0, arg_42_1)
	if not arg_42_1 then
		return
	end

	if not arg_42_0._multiple_horde_count then
		local var_42_0 = CurrentPacing

		arg_42_0._next_horde_time = Managers.time:time("game") + ConflictUtils.random_interval(var_42_0.horde_frequency)

		print("Horde killed: ", arg_42_1)
	else
		arg_42_0._next_horde_time = 0

		print("Horde killed: ", arg_42_1)
	end
end

function ConflictDirector.going_to_relax_state(arg_43_0)
	arg_43_0._multiple_horde_count = nil
end

function ConflictDirector.get_horde_data(arg_44_0)
	return arg_44_0._next_horde_time, arg_44_0.horde_spawner.hordes, arg_44_0._multiple_horde_count
end

function ConflictDirector.get_horde_timer(arg_45_0)
	return arg_45_0._next_horde_time, arg_45_0.delay_horde
end

function ConflictDirector.start_terror_event(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	local var_46_0 = arg_46_2 or 0

	return TerrorEventMixer.add_to_start_event_list(arg_46_1, var_46_0, arg_46_3, arg_46_4)
end

function ConflictDirector.terror_event_finished(arg_47_0, arg_47_1)
	return table.contains(TerrorEventMixer.finished_events, arg_47_1)
end

function ConflictDirector.start_terror_event_from_template(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	fassert(arg_48_2 ~= nil, "Starting a terror event from template should not be done if 'spawner_id' is nil!")

	local var_48_0 = Managers.level_transition_handler:get_current_level_keys()
	local var_48_1 = string.format("%s_%s", arg_48_1, arg_48_2)

	if TerrorEventBlueprints[var_48_0][var_48_1] then
		arg_48_0:start_terror_event(var_48_1, arg_48_3)

		return
	end

	local var_48_2 = TerrorEventBlueprints[var_48_0][arg_48_1]

	fassert(var_48_2 ~= nil, string.format("Tried to get non-existing terror event '%s'", arg_48_1))

	local var_48_3 = table.clone(var_48_2)

	for iter_48_0, iter_48_1 in ipairs(var_48_3) do
		if iter_48_1.spawner_id then
			iter_48_1.spawner_id = arg_48_2
		end
	end

	TerrorEventBlueprints[var_48_0][var_48_1] = var_48_3

	arg_48_0:start_terror_event(var_48_1, arg_48_3)
end

function ConflictDirector.handle_speed_runners(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0:get_threat_value() > arg_49_0.delay_specials_threat_value
	local var_49_1 = arg_49_0.speed_running_intervention_data
	local var_49_2 = CurrentSpecialsSettings.speed_running_intervention or SpecialsSettings.default.speed_running_intervention
	local var_49_3 = arg_49_0.pacing

	if not var_49_0 or arg_49_0.specials_pacing:is_disabled() or var_49_3:get_state() == "pacing_frozen" then
		var_49_1.started_speed_intervention_check_t = nil
		var_49_1.player_travel_distances = nil
		var_49_1.total_travel_distances = nil
		var_49_1.has_traveled_far = false

		return
	end

	if not var_49_1.started_speed_intervention_check_t then
		var_49_1.started_speed_intervention_check_t = arg_49_1
	end

	if arg_49_1 - var_49_1.started_speed_intervention_check_t < var_49_2.required_time_spent_in_high_threat then
		return
	end

	local var_49_4 = var_49_1.player_travel_distances or {}
	local var_49_5 = var_49_1.total_travel_distances or {}

	var_49_1.player_travel_distances = var_49_4
	var_49_1.total_travel_distances = var_49_5

	local var_49_6 = var_49_1.has_traveled_far
	local var_49_7 = var_49_1.target_speed_runner

	if arg_49_1 > var_49_1.next_travel_dist_check_t then
		var_49_1.has_traveled_far = false

		local var_49_8 = arg_49_0.main_path_info.ahead_unit
		local var_49_9 = arg_49_0.main_path_player_info[var_49_8]
		local var_49_10 = var_49_4[var_49_8]

		if var_49_9 and var_49_10 then
			local var_49_11 = var_49_9.travel_dist - var_49_10

			if var_49_11 >= var_49_2.travel_distance_threshold then
				var_49_1.has_traveled_far = true
				var_49_1.target_speed_runner = var_49_8
				var_49_5[var_49_8] = (var_49_5[var_49_8] or 0) + var_49_11
			end
		end

		for iter_49_0, iter_49_1 in pairs(arg_49_0.main_path_player_info) do
			var_49_4[iter_49_0] = iter_49_1.travel_dist
		end

		var_49_1.next_travel_dist_check_t = arg_49_1 + var_49_2.travel_distance_check_frequency
	end

	if not var_49_6 then
		return
	end

	if var_49_3.total_intensity > CurrentPacing.peak_intensity_threshold then
		if var_49_3:get_state() == "pacing_peak_fade" then
			if arg_49_1 - var_49_3._state_start_time < var_49_2.time_required_in_pacing_peak_to_ignore_high_intensity then
				return
			end
		else
			return
		end
	end

	local var_49_12 = Managers.state.game_mode:game_mode():get_active_respawn_units()

	if #var_49_12 > 0 then
		local var_49_13 = arg_49_0.main_path_info.ahead_unit
		local var_49_14 = arg_49_0.main_path_player_info[var_49_13].travel_dist

		for iter_49_2 = 1, #var_49_12 do
			local var_49_15 = var_49_12[iter_49_2]
			local var_49_16 = Unit.world_position(var_49_15, 0)
			local var_49_17, var_49_18 = MainPathUtils.closest_pos_at_main_path(arg_49_0.main_path_info.main_paths, var_49_16)

			if var_49_14 < var_49_18 then
				return
			end
		end
	end

	if var_49_2.chance_of_vector_horde >= math.random() then
		local var_49_19 = var_49_2.vector_horde_breeds[math.random(1, #var_49_2.vector_horde_breeds)]
		local var_49_20 = var_49_2.vector_horde_config[var_49_19]
		local var_49_21 = math.random(var_49_20[1], var_49_20[2])
		local var_49_22 = {}

		for iter_49_3 = 1, var_49_21 do
			var_49_22[#var_49_22 + 1] = var_49_19
		end

		local var_49_23 = Managers.state.conflict
		local var_49_24 = arg_49_0.default_enemy_side_id

		var_49_23.horde_spawner:execute_custom_horde(var_49_22, true, var_49_24)

		local var_49_25 = var_49_2.delay_between_speed_running_intervention_horde_spawn

		arg_49_0._next_speed_running_intervention_time = arg_49_1 + math.random(var_49_25[1], var_49_25[2])
	elseif Unit.alive(var_49_7) then
		local var_49_26, var_49_27 = arg_49_0.specials_pacing:request_speed_running_intervention(arg_49_1, var_49_7, arg_49_0.main_path_player_info)

		if var_49_26 then
			local var_49_28 = var_49_2.delay_between_speed_running_intervention_special_spawn
			local var_49_29 = 1
			local var_49_30 = var_49_5[var_49_7] or 0
			local var_49_31 = var_49_2.total_travel_distance_scaling_thresholds

			for iter_49_4 = 1, #var_49_31 do
				local var_49_32 = var_49_31[iter_49_4]

				var_49_29 = iter_49_4

				if var_49_30 < var_49_32 then
					break
				end
			end

			local var_49_33 = var_49_28[var_49_29]

			arg_49_0._next_speed_running_intervention_time = arg_49_1 + math.random(var_49_33[1], var_49_33[2])
		else
			arg_49_0._next_speed_running_intervention_time = arg_49_1 + 5
		end
	end
end

function ConflictDirector.handle_alone_player(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_2.ENEMY_PLAYER_AND_BOT_UNITS
	local var_50_1 = arg_50_0.rushing_intervention_data
	local var_50_2 = Managers.state.game_mode:setting("disable_rush_intervention")

	if var_50_2 and var_50_2.all then
		var_50_1.disabled = "No rush intervention, since game mode disabled it"

		return
	end

	if #var_50_0 == 1 then
		var_50_1.disabled = "No rush intervention, since only one player alive"

		return
	else
		var_50_1.disabled = nil
	end

	local var_50_3 = arg_50_0.main_path_info
	local var_50_4 = var_50_3.ahead_unit

	if var_50_4 then
		local var_50_5 = CurrentSpecialsSettings.rush_intervention
		local var_50_6, var_50_7, var_50_8, var_50_9 = arg_50_0:get_cluster_and_loneliness(10, arg_50_2.ENEMY_PLAYER_AND_BOT_POSITIONS, arg_50_2.ENEMY_PLAYER_AND_BOT_UNITS)

		var_50_1.loneliness_value = var_50_8

		if var_50_4 == var_50_9 or #var_50_0 == 2 then
			local var_50_10 = arg_50_0.main_path_player_info[var_50_4]
			local var_50_11 = var_50_10.travel_dist - arg_50_0._rushing_intervention_travel_dist

			var_50_1.player_travel_dist = var_50_10.travel_dist
			var_50_1.ahead_dist = var_50_11
			var_50_1.ahead_unit = var_50_4

			if var_50_11 <= 0 then
				return
			end

			if var_50_8 > var_50_5.loneliness_value_for_special then
				print("going to make a rush intervention, since loneliness_value=", var_50_8, " and dist=", var_50_11)

				local var_50_12, var_50_13 = arg_50_0.specials_pacing:request_rushing_intervention(arg_50_1, var_50_4, var_50_3, arg_50_0.main_path_player_info, var_50_2)

				if var_50_12 then
					arg_50_0.pacing:annotate_graph("Rush intervention - special", "red")

					var_50_1.message = "spawning: " .. var_50_13
				else
					var_50_1.message = var_50_13
				end

				local var_50_14 = var_50_5.delay_between_interventions

				if (not var_50_2 or not var_50_2.horde) and var_50_8 > var_50_5.loneliness_value_for_ambush_horde and Math.random() < var_50_5.chance_of_ambush_horde then
					print("rush intervention - ambush horde!")
					arg_50_0.pacing:annotate_graph("Rush intervention - horde", "red")

					local var_50_15 = CurrentHordeSettings.ambush_composition
					local var_50_16

					if type(var_50_15) == "table" then
						local var_50_17 = var_50_15[math.random(#var_50_15)]

						var_50_16 = {
							optional_wave_composition = var_50_17
						}
					end

					if not var_0_6.ai_horde_spawning_disabled and not Managers.state.game_mode:setting("horde_spawning_disabled") then
						arg_50_0.horde_spawner:execute_ambush_horde(var_50_16, arg_50_0.default_enemy_side_id, false, var_0_0[var_50_4])
					end

					var_50_14 = var_50_14 + 10
					var_50_12 = true
				end

				if var_50_12 then
					arg_50_0._next_rushing_intervention_time = arg_50_1 + var_50_14
					arg_50_0._rushing_intervention_travel_dist = var_50_10.travel_dist + var_50_5.distance_until_next_intervention
				end
			end
		end
	end
end

function ConflictDirector.respawn_level(arg_51_0, arg_51_1)
	arg_51_0:destroy_all_units()

	if arg_51_1 then
		Managers.state.entity:system("ai_interest_point_system"):set_seed(arg_51_1)
		arg_51_0.enemy_recycler:set_seed(arg_51_1)
		arg_51_0.level_analysis:set_random_seed(nil, arg_51_1)
		arg_51_0.spawn_zone_baker:set_seed(arg_51_1)
		TerrorEventUtils.set_seed(arg_51_1)
	else
		arg_51_0.level_analysis:set_random_seed(nil, arg_51_0.level_analysis.seed)
		arg_51_0.spawn_zone_baker:set_seed(arg_51_0.spawn_zone_baker.seed)
		TerrorEventUtils.set_seed(arg_51_0.level_analysis.seed)
	end

	local var_51_0
	local var_51_1

	arg_51_0._spawn_pos_list, arg_51_0._pack_sizes, arg_51_0._pack_rotations, var_51_1, arg_51_0._zone_data_list = arg_51_0:generate_spawns()

	arg_51_0.enemy_recycler:setup(arg_51_0._spawn_pos_list, arg_51_0._pack_sizes, arg_51_0._pack_rotations, var_51_1, arg_51_0._zone_data_list)
	arg_51_0.level_analysis:remove_crossroads_extra_path_branches()
	arg_51_0.level_analysis:generate_boss_paths()
	arg_51_0.level_analysis:reset_debug()

	arg_51_0.main_path_info.main_paths = arg_51_0.level_analysis:get_main_paths()

	arg_51_0.spawn_zone_baker:draw_pack_density_graph()
end

function ConflictDirector.create_debug_list(arg_52_0)
	arg_52_0._debug_list = {
		"none",
		arg_52_0.pacing,
		arg_52_0.spawn_zone_baker
	}
end

function ConflictDirector.update_mini_patrol(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0.pacing
	local var_53_1 = CurrentPacing.mini_patrol
	local var_53_2 = arg_53_0._next_mini_patrol_timer

	if arg_53_0._mini_patrol_state == "spawning" then
		if var_53_2 < arg_53_1 then
			arg_53_0._mini_patrol_state = "running"
			arg_53_0._next_mini_patrol_timer = arg_53_1 + var_53_1.override_timer
		end
	elseif arg_53_0._mini_patrol_state == "running" then
		local var_53_3 = arg_53_0._conflict_data_by_side[arg_53_0.default_enemy_side_id].num_spawned_by_breed

		if var_53_3.skaven_clan_rat < 3 and var_53_3.skaven_storm_vermin <= 1 or var_53_2 < arg_53_1 then
			arg_53_0._mini_patrol_state = "waiting"
			arg_53_0._next_mini_patrol_timer = arg_53_1 + ConflictUtils.random_interval(var_53_1.frequency)
		end
	elseif var_53_2 < arg_53_1 then
		local var_53_4 = arg_53_0._conflict_data_by_side[arg_53_0.default_enemy_side_id]

		if var_53_0.total_intensity <= var_53_1.only_spawn_below_intensity and var_53_0.total_intensity >= var_53_1.only_spawn_above_intensity and var_0_3.max_grunts - #var_53_4.spawned >= 0 and not arg_53_0.delay_mini_patrol then
			arg_53_0._next_mini_patrol_timer = arg_53_1 + 5

			local var_53_5 = CurrentHordeSettings.mini_patrol_composition

			print("spawning mini patrol")

			local var_53_6 = {
				size = 0,
				template = "mini_patrol",
				id = Managers.state.entity:system("ai_group_system"):generate_group_id()
			}
			local var_53_7 = arg_53_0.default_enemy_side_id

			arg_53_0:mini_patrol(arg_53_1, nil, var_53_7, var_53_5, var_53_6)

			arg_53_0._mini_patrol_state = "spawning"
		else
			arg_53_0._next_mini_patrol_timer = arg_53_1 + 2
		end
	end

	if var_0_6.debug_mini_patrols then
		Debug.text("Mini patrol: active=%s, timer=%.1f last=[%s]", tostring(arg_53_0._mini_patrol_state), arg_53_0._next_mini_patrol_timer - arg_53_1, tostring(arg_53_0._last_mini_patrol_composition))
	end
end

function ConflictDirector.reset_data(arg_54_0)
	arg_54_0._cluster_and_loneliness = FrameTable.alloc_table()
end

function ConflictDirector.update(arg_55_0, arg_55_1, arg_55_2)
	arg_55_0._time = arg_55_2

	if var_0_6.testify then
		Testify:poll_requests_through_handler(var_0_8, arg_55_0)
	end

	local var_55_0 = {}
	local var_55_1 = arg_55_0.sides_to_update_recycler

	for iter_55_0 = 1, #var_55_1 do
		table.append(var_55_0, var_55_1[iter_55_0].PLAYER_AND_BOT_POSITIONS)
	end

	if arg_55_0.level_analysis then
		arg_55_0.level_analysis:update(arg_55_2, arg_55_1)

		if arg_55_0._hero_side then
			arg_55_0:update_main_path_player_info(arg_55_0._hero_side, arg_55_2)
		end
	end

	if arg_55_0.disabled then
		return
	end

	local var_55_2 = var_0_6

	arg_55_0:check_updated_settings()

	local var_55_3 = CurrentConflictSettings

	if var_55_3.disabled then
		return
	end

	if arg_55_2 > arg_55_0._next_threat_update then
		arg_55_0:calculate_threat_value()
		arg_55_0:check_pacing_event_delay()

		arg_55_0._next_threat_update = arg_55_2 + 1
	end

	local var_55_4 = arg_55_0.pacing

	if not var_55_2.ai_pacing_disabled and not var_55_3.pacing.disabled then
		if arg_55_2 > arg_55_0._next_pacing_update then
			local var_55_5 = arg_55_0._hero_side

			if var_55_5 then
				local var_55_6 = var_55_5.PLAYER_AND_BOT_UNITS

				var_55_4:update(arg_55_2, arg_55_1, var_55_6)

				arg_55_0._next_pacing_update = arg_55_2 + 1

				if var_55_4:get_state() == "pacing_relax" and arg_55_0:are_players_rushing(arg_55_2) then
					if CurrentPacing.leave_relax_if_rushing then
						print("players are progressing too fast, leave relax")
						var_55_4:advance_pacing(arg_55_2, "players are rushing")
					end

					if CurrentPacing.horde_in_relax_if_rushing then
						print("players are progressing too fast, punish with a horde")

						arg_55_0._next_horde_time = arg_55_2
					end
				end
			end
		end

		if not var_55_2.ai_rush_intervention_disabled and arg_55_2 > arg_55_0._next_rushing_intervention_time then
			arg_55_0._next_rushing_intervention_time = arg_55_2 + 1

			arg_55_0:handle_alone_player(arg_55_2, arg_55_0._enemy_side)
		end

		if not (CurrentSpecialsSettings.speed_running_intervention or SpecialsSettings.default.speed_running_intervention).disabled and not var_55_2.ai_speed_running_intervention_disabled and arg_55_2 > arg_55_0._next_speed_running_intervention_time then
			arg_55_0._next_speed_running_intervention_time = arg_55_2 + 2.5

			arg_55_0:handle_speed_runners(arg_55_2)
		end
	end

	if arg_55_0.in_safe_zone then
		if Managers.state.game_mode:is_round_started() then
			print("Players are leaving the safe zone")

			arg_55_0.in_safe_zone = false

			Managers.state.game_mode:players_left_safe_zone()

			if arg_55_0.specials_pacing then
				arg_55_0.specials_pacing:start(arg_55_2)

				if not var_55_2.ai_pacing_disabled then
					local var_55_7 = CurrentPacing

					arg_55_0._next_horde_time = arg_55_2 + ConflictUtils.random_interval(var_55_7.horde_startup_time)
				end
			end
		end
	else
		if not var_55_3.specials.disabled and arg_55_0.specials_pacing and not var_55_2.ai_specials_spawning_disabled and not Managers.state.game_mode:setting("ai_specials_spawning_disabled") then
			local var_55_8 = var_55_4:specials_population()

			arg_55_0.specials_pacing:update(arg_55_2, arg_55_0._alive_specials, var_55_8, var_55_0)
		end

		if not var_55_2.ai_horde_spawning_disabled and not var_55_3.horde.disabled and not Managers.state.game_mode:setting("horde_spawning_disabled") then
			arg_55_0:update_horde_pacing(arg_55_2, arg_55_1)
		else
			local var_55_9 = CurrentPacing

			arg_55_0._next_horde_time = arg_55_2 + ConflictUtils.random_interval(var_55_9.horde_frequency)
		end

		if not var_55_2.ai_mini_patrol_disabled and arg_55_0.level_settings.use_mini_patrols and var_55_4.pacing_state == "pacing_build_up" then
			arg_55_0:update_mini_patrol(arg_55_2, arg_55_1)
		end

		if arg_55_0.horde_spawner then
			arg_55_0.horde_spawner:update(arg_55_2, arg_55_1)
		end
	end

	if USE_ENGINE_SLOID_SYSTEM then
		local var_55_10 = var_55_2.debug_unit and ScriptUnit.has_extension(var_55_2.debug_unit, "ai_slot_system")
		local var_55_11 = var_55_10 and var_55_10.sloid_id
		local var_55_12 = Managers.player:local_player(1)
		local var_55_13 = Managers.state.camera:camera_rotation(var_55_12.viewport_name)
		local var_55_14 = Vector3(0, 0, 0)
		local var_55_15 = Matrix4x4.from_quaternion_position(var_55_13, var_55_14)

		EngineOptimized.sloid_system_update(arg_55_2, arg_55_1, var_55_2.infighting_draw_mode or -1, var_55_2.debug_unit, var_55_11, var_55_15)
		Gathering.write_dogpiled_attackers(nil, arg_55_0.dogpiled_attackers_on_unit)
	else
		arg_55_0.gathering:update(arg_55_2, arg_55_1)
	end

	if arg_55_0.director_is_ai_ready then
		local var_55_16 = Managers.state.entity:system("ai_system")

		TerrorEventMixer.update(arg_55_2, arg_55_1, var_55_16.ai_debugger and var_55_16.ai_debugger.screen_gui)
	elseif not var_0_4 and arg_55_0.navigation_group_manager.form_groups_running and arg_55_0.navigation_group_manager:form_groups_update() then
		local var_55_17 = Managers.mechanism:get_level_seed()

		arg_55_0:ai_nav_groups_ready(var_55_17)
	end

	local var_55_18 = var_55_0

	if arg_55_0.enemy_recycler and not var_55_2.ai_roaming_spawning_disabled and not var_55_3.roaming.disabled then
		local var_55_19 = var_55_4:threat_population()
		local var_55_20 = arg_55_0._conflict_data_by_side[arg_55_0.default_enemy_side_id]

		if var_0_3.max_grunts - #var_55_20.spawned <= 0 then
			var_55_19 = 0
		end

		local var_55_21 = arg_55_0.navigation_group_manager.operational

		if var_55_2.recycler_in_freeflight then
			if var_55_2.recycler_in_cutscene then
				local var_55_22 = Managers.player:local_player(1)
				local var_55_23 = Managers.state.camera:camera_position(var_55_22.viewport_name)

				if var_55_23 then
					var_55_18 = arg_55_0._recycler_extra_pos and {
						var_55_23,
						arg_55_0._recycler_extra_pos:unbox()
					} or {
						var_55_23
					}
					var_55_21 = false
				end
			else
				local var_55_24 = arg_55_0:get_free_flight_pos()

				if var_55_24 then
					var_55_18 = arg_55_0._recycler_extra_pos and {
						var_55_24,
						arg_55_0._recycler_extra_pos:unbox()
					} or {
						var_55_24
					}
					var_55_21 = false
				end
			end

			if arg_55_0._recycler_extra_pos and arg_55_2 > arg_55_0._recycler_extra_end_time then
				arg_55_0._recycler_extra_pos = nil
			end
		end

		arg_55_0:update_player_areas(var_55_1)
		arg_55_0.enemy_recycler:update(arg_55_2, arg_55_1, var_55_18, var_55_19, arg_55_0._player_areas, var_55_21)
	end

	if not arg_55_0.in_safe_zone then
		arg_55_0.enemy_recycler:update_main_path_events(arg_55_2)
	end

	arg_55_0:update_spawn_queue(arg_55_2)

	if arg_55_0.enemy_recycler and not var_55_2.ai_far_off_despawn_disabled then
		local var_55_25 = arg_55_0._conflict_data_by_side[arg_55_0.default_enemy_side_id]

		arg_55_0.enemy_recycler:far_off_despawn(arg_55_2, arg_55_1, var_55_18, var_55_25.spawned)
	end

	if arg_55_0._spline_groups_to_spawn then
		for iter_55_1, iter_55_2 in pairs(arg_55_0._spline_groups_to_spawn) do
			local var_55_26 = Managers.state.entity:system("ai_group_system"):spline_ready(iter_55_1)

			if var_55_26 then
				if var_55_26 == "failed" or var_55_26.failed then
					print("spline is in fail state, cancelling the spline spawn.", iter_55_1)

					arg_55_0._spline_groups_to_spawn[iter_55_1] = nil
				else
					arg_55_0:_spawn_spline_group(iter_55_2, var_55_26)

					arg_55_0._spline_groups_to_spawn[iter_55_1] = nil
				end
			end
		end
	end

	local var_55_27 = arg_55_0._peak_delayer

	if var_55_27 then
		local var_55_28
		local var_55_29 = arg_55_0.main_path_info

		if not var_55_29.ahead_unit then
			return
		end

		local var_55_30 = arg_55_0.main_path_player_info[var_55_29.ahead_unit].travel_dist

		var_55_27:update(var_55_30, arg_55_2)
	end
end

function ConflictDirector.pre_update(arg_56_0)
	if arg_56_0.breed_freezer and not var_0_6.disable_breed_freeze_opt then
		arg_56_0.breed_freezer:commit_freezes()
	end
end

function ConflictDirector.post_update(arg_57_0)
	if arg_57_0.breed_freezer and not var_0_6.disable_breed_freeze_opt then
		arg_57_0.breed_freezer:commit_freezes()
	end
end

function ConflictDirector.set_recycler_extra_pos(arg_58_0, arg_58_1, arg_58_2)
	arg_58_0._recycler_extra_pos = arg_58_1
	arg_58_0._recycler_extra_end_time = arg_58_2
end

function ConflictDirector.get_free_flight_pos(arg_59_0)
	local var_59_0
	local var_59_1 = Managers.free_flight.data.global

	if var_59_1.viewport_world_name then
		local var_59_2 = Managers.world:world(var_59_1.viewport_world_name)
		local var_59_3 = ScriptWorld.global_free_flight_viewport(var_59_2)
		local var_59_4 = var_59_1.frustum_freeze_camera or ScriptViewport.camera(var_59_3)

		var_59_0 = ScriptCamera.position(var_59_4)
	end

	return var_59_0
end

function ConflictDirector.spawn_queued_unit(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5, arg_60_6, arg_60_7, arg_60_8, arg_60_9)
	arg_60_7 = arg_60_7 or {}
	arg_60_7.side_id = arg_60_7.side_id or arg_60_0.default_enemy_side_id

	local var_60_0 = arg_60_0.enemy_package_loader

	if not var_60_0:is_breed_processed(arg_60_1.name) then
		local var_60_1 = arg_60_7 and arg_60_7.ignore_breed_limits
		local var_60_2, var_60_3 = var_60_0:request_breed(arg_60_1.name, var_60_1, arg_60_4)

		if not var_60_2 then
			printf("[ConflictDirector] Replacing wanted breed (%s) with %s", arg_60_1.name, var_60_3 or "nil")

			arg_60_1 = Breeds[var_60_3]
		end
	end

	local var_60_4 = arg_60_0.spawn_queue
	local var_60_5 = arg_60_0.first_spawn_index + arg_60_0.spawn_queue_size

	arg_60_0.spawn_queue_size = arg_60_0.spawn_queue_size + 1
	arg_60_0.spawn_queue_id = arg_60_0.spawn_queue_id + 1

	local var_60_6 = var_60_4[var_60_5]

	fassert(arg_60_1, "no supplied breed")

	if var_60_6 then
		var_60_6[1] = arg_60_1
		var_60_6[2] = arg_60_2
		var_60_6[3] = arg_60_3
		var_60_6[4] = arg_60_4
		var_60_6[5] = arg_60_5
		var_60_6[6] = arg_60_6
		var_60_6[7] = arg_60_7
		var_60_6[8] = arg_60_8
		var_60_6[9] = arg_60_9
		var_60_6[10] = arg_60_0.spawn_queue_id
	else
		var_60_4[var_60_5] = {
			arg_60_1,
			arg_60_2,
			arg_60_3,
			arg_60_4,
			arg_60_5,
			arg_60_6,
			arg_60_7,
			arg_60_8,
			arg_60_9,
			arg_60_0.spawn_queue_id
		}
	end

	local var_60_7 = arg_60_1.name

	arg_60_0.num_queued_spawn_by_breed[var_60_7] = arg_60_0.num_queued_spawn_by_breed[var_60_7] + 1

	return arg_60_0.spawn_queue_id
end

function ConflictDirector.get_spawned_unit(arg_61_0, arg_61_1)
	return arg_61_0._spawn_queue_id_lut[arg_61_1]
end

function ConflictDirector._get_spawned_unit_id(arg_62_0, arg_62_1)
	return arg_62_0._spawn_queue_id_lut[arg_62_1]
end

function ConflictDirector.remove_queued_unit(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0.spawn_queue
	local var_63_1 = arg_63_0.first_spawn_index
	local var_63_2 = arg_63_0.spawn_queue_size
	local var_63_3 = arg_63_0.first_spawn_index
	local var_63_4 = var_63_3 + var_63_2 - 1

	for iter_63_0 = var_63_3, var_63_4 do
		local var_63_5 = var_63_0[iter_63_0]

		fassert(var_63_5, "Missing spawn_queue item")

		if var_63_5[10] == arg_63_1 then
			local var_63_6 = var_63_5[1]

			arg_63_0.num_queued_spawn_by_breed[var_63_6.name] = arg_63_0.num_queued_spawn_by_breed[var_63_6.name] - 1
			var_63_0[var_63_4], var_63_0[iter_63_0] = var_63_0[iter_63_0], var_63_0[var_63_4]
			arg_63_0.spawn_queue_size = arg_63_0.spawn_queue_size - 1

			if arg_63_0.spawn_queue_size == 0 then
				arg_63_0.first_spawn_index = 1
			end

			return var_63_5
		end
	end

	ferror("Spawn_queue id not found %s", tostring(arg_63_1))
end

function ConflictDirector.update_spawn_queue(arg_64_0, arg_64_1)
	if arg_64_0.spawn_queue_size == 0 then
		return
	end

	local var_64_0 = arg_64_0.first_spawn_index
	local var_64_1 = arg_64_0.spawn_queue
	local var_64_2 = var_64_1[var_64_0]
	local var_64_3 = var_64_2[1]
	local var_64_4 = var_64_3.name
	local var_64_5 = arg_64_0.enemy_package_loader

	while not var_64_5:is_breed_loaded_on_all_peers(var_64_4) do
		var_64_0 = var_64_0 + 1

		if var_64_0 == arg_64_0.first_spawn_index + arg_64_0.spawn_queue_size then
			return
		end

		var_64_2 = var_64_1[var_64_0]
		var_64_3 = var_64_2[1]
		var_64_4 = var_64_3.name
	end

	local var_64_6 = not var_0_6.disable_breed_freeze_opt and arg_64_0.breed_freezer and arg_64_0.breed_freezer:try_unfreeze_breed(var_64_3, var_64_2)

	if var_64_6 then
		local var_64_7 = var_0_1[var_64_6].breed
		local var_64_8 = Managers.state.unit_storage:go_id(var_64_6)

		arg_64_0:_post_spawn_unit(var_64_6, var_64_8, var_64_7, var_64_2[2]:unbox(), var_64_2[4], var_64_2[5], var_64_2[7], var_64_2[6], var_64_2[10])
	else
		var_64_6 = arg_64_0:_spawn_unit(var_64_2[1], var_64_2[2]:unbox(), var_64_2[3]:unbox(), var_64_2[4], var_64_2[5], var_64_2[6], var_64_2[7], var_64_2[8], var_64_2[10])
	end

	arg_64_0.num_queued_spawn_by_breed[var_64_4] = arg_64_0.num_queued_spawn_by_breed[var_64_4] - 1

	local var_64_9 = var_64_2[9]

	if var_64_9 then
		var_64_9[1] = var_64_6
	end

	if var_64_0 ~= arg_64_0.first_spawn_index then
		local var_64_10 = arg_64_0.spawn_queue[var_64_0]

		arg_64_0.spawn_queue[var_64_0] = arg_64_0.spawn_queue[arg_64_0.first_spawn_index]
		arg_64_0.spawn_queue[arg_64_0.first_spawn_index] = var_64_10
	end

	arg_64_0.spawn_queue_size = arg_64_0.spawn_queue_size - 1
	arg_64_0.first_spawn_index = arg_64_0.first_spawn_index + 1

	if arg_64_0.spawn_queue_size == 0 then
		arg_64_0.first_spawn_index = 1
	end
end

function ConflictDirector.spawn_unit_immediate(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8)
	arg_65_0.spawn_queue_id = arg_65_0.spawn_queue_id + 1

	local var_65_0, var_65_1 = arg_65_0:_spawn_unit(arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_0.spawn_queue_id)

	return var_65_0, var_65_1
end

local var_0_10 = {
	faction = "enemy"
}

function ConflictDirector._spawn_unit(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8, arg_66_9)
	local var_66_0 = var_0_6.use_optimized_breed_units and arg_66_1.opt_base_unit or arg_66_1.base_unit
	local var_66_1 = type(var_66_0) == "string" and var_66_0 or var_66_0[Math.random(#var_66_0)]
	local var_66_2 = arg_66_1.unit_template
	local var_66_3 = Managers.state.entity:system("ai_system"):nav_world()

	arg_66_7.spawn_queue_index = arg_66_9

	local var_66_4

	if arg_66_1.has_inventory then
		local var_66_5 = var_0_6.use_optimized_breed_units and arg_66_1.opt_default_inventory_template or arg_66_1.default_inventory_template
		local var_66_6 = type(var_66_5) == "string" and var_66_5 or var_66_5[Math.random(#var_66_5)]

		var_66_4 = {
			optional_spawn_data = arg_66_7,
			inventory_template = var_66_6,
			inventory_configuration_name = arg_66_7.inventory_configuration_name
		}
	end

	local var_66_7

	if arg_66_1.aim_template ~= nil then
		var_66_7 = {
			husk = false,
			template = arg_66_1.aim_template
		}
	end

	local var_66_8

	if arg_66_1.animation_movement_template ~= nil then
		var_66_8 = {
			husk = false,
			template = arg_66_1.animation_movement_template
		}
	end

	var_0_10.breed_name = arg_66_1.name

	local var_66_9 = Managers.state.difficulty:get_difficulty_rank()
	local var_66_10 = arg_66_1.max_health and arg_66_1.max_health[var_66_9]

	var_66_10 = var_66_10 and var_66_10 * (arg_66_7.max_health_modifier or 1)

	local var_66_11 = arg_66_7.side_id
	local var_66_12 = {
		health_system = {
			health = var_66_10,
			optional_data = arg_66_7,
			breed = arg_66_1
		},
		ai_system = {
			size_variation = 1,
			size_variation_normalized = 1,
			breed = arg_66_1,
			nav_world = var_66_3,
			spawn_type = arg_66_6,
			spawn_category = arg_66_4,
			optional_spawn_data = arg_66_7,
			side_id = var_66_11
		},
		locomotion_system = {
			nav_world = var_66_3,
			breed = arg_66_1
		},
		ai_navigation_system = {
			nav_world = var_66_3
		},
		death_system = {
			is_husk = false,
			death_reaction_template = arg_66_1.death_reaction,
			disable_second_hit_ragdoll = arg_66_1.disable_second_hit_ragdoll
		},
		hit_reaction_system = {
			is_husk = false,
			hit_reaction_template = arg_66_1.hit_reaction,
			hit_effect_template = arg_66_1.hit_effect_template
		},
		ai_inventory_system = var_66_4,
		ai_group_system = arg_66_8,
		dialogue_system = var_0_10,
		aim_system = var_66_7,
		proximity_system = {
			breed = arg_66_1
		},
		buff_system = {
			breed = arg_66_1
		},
		animation_movement_system = var_66_8
	}

	if arg_66_7.prepare_func then
		arg_66_7.prepare_func(arg_66_1, var_66_12, arg_66_7, arg_66_2, arg_66_3)
	end

	Managers.state.game_mode:pre_ai_spawned(arg_66_1, arg_66_7)

	local var_66_13 = Matrix4x4.from_quaternion_position(arg_66_3, arg_66_2)
	local var_66_14 = arg_66_7.size_variation_range or arg_66_1.size_variation_range

	if var_66_14 then
		local var_66_15 = Math.random()
		local var_66_16 = math.lerp(var_66_14[1], var_66_14[2], var_66_15)

		var_66_12.ai_system.size_variation = var_66_16
		var_66_12.ai_system.size_variation_normalized = var_66_15

		Matrix4x4.set_scale(var_66_13, Vector3(var_66_16, var_66_16, var_66_16))
	end

	local var_66_17, var_66_18 = Managers.state.unit_spawner:spawn_network_unit(var_66_1, var_66_2, var_66_12, var_66_13)

	arg_66_0:_post_spawn_unit(var_66_17, var_66_18, arg_66_1, arg_66_2, arg_66_4, arg_66_5, arg_66_7, arg_66_6, arg_66_9)

	return var_66_17, var_66_18
end

function ConflictDirector._post_spawn_unit(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6, arg_67_7, arg_67_8, arg_67_9)
	arg_67_0._spawn_queue_id_lut[arg_67_9] = arg_67_1
	arg_67_0._spawn_queue_id_lut[arg_67_1] = arg_67_9
	arg_67_7 = arg_67_7 or {}

	Managers.state.game_mode:post_ai_spawned(arg_67_1, arg_67_3, arg_67_7)

	local var_67_0 = var_0_1[arg_67_1]

	var_67_0.enemy_id = arg_67_7.spawn_queue_index

	if arg_67_7.enhancements then
		TerrorEventUtils.apply_breed_enhancements(arg_67_1, arg_67_3, arg_67_7)
	end

	local var_67_1 = arg_67_3.name

	Unit.set_data(arg_67_1, "spawn_type", arg_67_8)

	local var_67_2 = arg_67_0.level_settings.climate_type or "default"

	Unit.set_flow_variable(arg_67_1, "climate_type", var_67_2)
	Unit.flow_event(arg_67_1, "climate_type_set")

	if arg_67_7.enhancements then
		Managers.telemetry_events:ai_spawned(var_67_0.enemy_id, arg_67_3.name, arg_67_4, arg_67_7.enhancements)
	end

	var_67_0.spawn_animation = arg_67_6
	var_67_0.optional_spawn_data = arg_67_7

	local var_67_3 = arg_67_7.side_id or Managers.state.side.side_by_unit[arg_67_1].side_id
	local var_67_4 = arg_67_0._conflict_data_by_side[var_67_3]
	local var_67_5 = var_67_4.spawned
	local var_67_6 = var_67_4.spawned_lookup
	local var_67_7 = var_67_4.num_spawned_ai + 1

	var_67_4.num_spawned_ai = var_67_7
	var_67_5[var_67_7] = arg_67_1
	var_67_6[arg_67_1] = var_67_7
	arg_67_0._num_spawned_ai = arg_67_0._num_spawned_ai + 1
	arg_67_0._all_spawned_units[arg_67_0._num_spawned_ai] = arg_67_1
	arg_67_0._all_spawned_units_lookup[arg_67_1] = arg_67_0._num_spawned_ai
	arg_67_0.num_spawned_by_breed[var_67_1] = arg_67_0.num_spawned_by_breed[var_67_1] + 1

	local var_67_8 = var_67_4.num_spawned_by_breed
	local var_67_9 = var_67_4.num_spawned_by_breed_max
	local var_67_10 = var_67_4.spawned_units_by_breed

	var_67_8[var_67_1] = var_67_8[var_67_1] + 1
	var_67_10[var_67_1][arg_67_1] = arg_67_1

	if not arg_67_7.ignore_event_counter and arg_67_0.running_master_event then
		var_67_0.master_event_id = arg_67_0._master_event_id
		var_67_4.num_spawned_ai_event = var_67_4.num_spawned_ai_event + 1
		var_67_4.num_spawned_by_breed_during_event[var_67_1] = var_67_4.num_spawned_by_breed_during_event[var_67_1] + 1
	else
		var_67_0.master_event_id = nil
	end

	Managers.state.event:trigger("ai_unit_spawned", arg_67_1, var_67_1, var_67_3, var_67_0.master_event_id)

	if arg_67_3.spawn_stinger then
		local var_67_11 = Managers.world:wwise_world(arg_67_0._world)
		local var_67_12, var_67_13 = WwiseWorld.trigger_event(var_67_11, arg_67_3.spawn_stinger)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_event", NetworkLookup.sound_events[arg_67_3.spawn_stinger])
	end

	local var_67_14 = var_67_0.locomotion_extension

	if var_67_14 then
		var_67_14:ready(arg_67_2, var_67_0)
	end

	if arg_67_7.spawned_func then
		arg_67_7.spawned_func(arg_67_1, arg_67_3, arg_67_7)
	end

	if USE_ENGINE_SLOID_SYSTEM then
		EngineOptimized.add_static_unit_data(arg_67_1, 2.2, arg_67_7.side_id)
	end

	if arg_67_3.boss then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_new_spawn_monster")

		if arg_67_7.force_boss_health_ui then
			Managers.state.event:trigger("force_add_boss_health_ui", arg_67_1)
		end
	end

	Unit.flow_event(arg_67_1, "lua_ai_unit_spawned")
end

function ConflictDirector.set_disabled(arg_68_0, arg_68_1)
	arg_68_0.disabled = arg_68_1
end

function ConflictDirector.spawned_units_by_side(arg_69_0, arg_69_1)
	return arg_69_0._conflict_data_by_side[arg_69_1].spawned
end

function ConflictDirector.spawned_enemies(arg_70_0)
	return arg_70_0._conflict_data_by_side[arg_70_0.default_enemy_side_id].spawned
end

function ConflictDirector.count_units_by_breed(arg_71_0, arg_71_1, arg_71_2)
	arg_71_2 = arg_71_2 or arg_71_0.default_enemy_side_id

	return arg_71_0._conflict_data_by_side[arg_71_2].num_spawned_by_breed[arg_71_1]
end

function ConflictDirector.spawned_units_by_breed(arg_72_0, arg_72_1, arg_72_2)
	arg_72_2 = arg_72_2 or arg_72_0.default_enemy_side_id

	return arg_72_0._conflict_data_by_side[arg_72_2].spawned_units_by_breed[arg_72_1]
end

function ConflictDirector.spawned_units_by_breed_table(arg_73_0, arg_73_1)
	arg_73_1 = arg_73_1 or arg_73_0.default_enemy_side_id

	return arg_73_0._conflict_data_by_side[arg_73_1].spawned_units_by_breed
end

function ConflictDirector.count_units_by_breed_during_event(arg_74_0, arg_74_1, arg_74_2)
	arg_74_2 = arg_74_2 or arg_74_0.default_enemy_side_id

	return arg_74_0._conflict_data_by_side[arg_74_2].num_spawned_by_breed_during_event[arg_74_1] or 0
end

function ConflictDirector.all_spawned_units(arg_75_0)
	return arg_75_0._all_spawned_units, arg_75_0._num_spawned_ai
end

function ConflictDirector.total_num_ai_spawned(arg_76_0)
	return arg_76_0._num_spawned_ai
end

function ConflictDirector.add_unit_to_bosses(arg_77_0, arg_77_1)
	arg_77_0._alive_bosses[#arg_77_0._alive_bosses + 1] = arg_77_1
end

function ConflictDirector.remove_unit_from_bosses(arg_78_0, arg_78_1)
	var_0_9(arg_78_0._alive_bosses, arg_78_1)
end

function ConflictDirector.add_unit_to_standards(arg_79_0, arg_79_1)
	arg_79_0._alive_standards[#arg_79_0._alive_standards + 1] = arg_79_1
end

function ConflictDirector.remove_unit_from_standards(arg_80_0, arg_80_1)
	var_0_9(arg_80_0._alive_standards, arg_80_1)
end

function ConflictDirector._remove_unit_from_spawned(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	local var_81_0 = Managers.state.side.side_by_unit[arg_81_1]

	if not var_81_0 then
		return
	end

	local var_81_1 = var_81_0.side_id
	local var_81_2 = arg_81_0._conflict_data_by_side[var_81_1]
	local var_81_3 = var_81_2.spawned_lookup
	local var_81_4 = var_81_3[arg_81_1]

	if not var_81_4 then
		return
	end

	local var_81_5 = arg_81_0._spawn_queue_id_lut[arg_81_1]

	if var_81_5 then
		arg_81_0._spawn_queue_id_lut[arg_81_1] = nil
		arg_81_0._spawn_queue_id_lut[var_81_5] = nil
	end

	local var_81_6 = arg_81_2.breed
	local var_81_7 = arg_81_2.spawn_type

	if var_81_7 == "horde" or var_81_7 == "horde_hidden" then
		arg_81_0:add_horde(-1)
	end

	if var_81_7 == "roam" then
		local var_81_8 = BREED_DIE_LOOKUP[arg_81_1]

		if var_81_8 then
			var_81_8[1](arg_81_1, var_81_8[2])

			BREED_DIE_LOOKUP[arg_81_1] = nil
		end
	end

	local var_81_9 = var_81_2.spawned
	local var_81_10 = #var_81_9
	local var_81_11 = var_81_9[var_81_10]

	table.swap_delete(var_81_9, var_81_4)

	var_81_3[arg_81_1] = nil

	if var_81_4 ~= var_81_10 then
		var_81_3[var_81_11] = var_81_4
	end

	local var_81_12 = arg_81_0._all_spawned_units
	local var_81_13 = arg_81_0._all_spawned_units_lookup
	local var_81_14 = var_81_13[arg_81_1]
	local var_81_15 = arg_81_0._num_spawned_ai
	local var_81_16 = var_81_12[var_81_15]

	table.swap_delete(var_81_12, var_81_14)

	var_81_13[arg_81_1] = nil

	if var_81_14 ~= var_81_15 then
		var_81_13[var_81_16] = var_81_14
	end

	arg_81_0._num_spawned_ai = arg_81_0._num_spawned_ai - 1

	if arg_81_2.optional_spawn_data and arg_81_2.optional_spawn_data.despawned_func then
		arg_81_2.optional_spawn_data.despawned_func(arg_81_1, var_81_6, arg_81_2.optional_spawn_data)
	end

	local var_81_17 = var_81_6.name

	arg_81_0.num_spawned_by_breed[var_81_17] = arg_81_0.num_spawned_by_breed[var_81_17] - 1
	var_81_2.num_spawned_by_breed[var_81_17] = var_81_2.num_spawned_by_breed[var_81_17] - 1
	var_81_2.spawned_units_by_breed[var_81_17][arg_81_1] = nil
	var_81_2.num_spawned_ai = var_81_2.num_spawned_ai - 1

	if arg_81_2.master_event_id and arg_81_2.master_event_id == arg_81_0._master_event_id then
		var_81_2.num_spawned_by_breed_during_event[var_81_17] = var_81_2.num_spawned_by_breed_during_event[var_81_17] - 1
		var_81_2.num_spawned_ai_event = var_81_2.num_spawned_ai_event - 1
	end

	if var_81_6.special then
		var_0_9(arg_81_0._alive_specials, arg_81_1)
	end

	if var_81_6.boss then
		var_0_9(arg_81_0._alive_bosses, arg_81_1)
	end

	if USE_ENGINE_SLOID_SYSTEM then
		EngineOptimized.remove_static_unit_data(arg_81_1)
	end

	if not arg_81_3 then
		Managers.state.event:trigger("ai_unit_despawned", arg_81_1, var_81_17, var_81_1, arg_81_2.master_event_id)
	end
end

local var_0_11 = {}

for iter_0_0, iter_0_1 in pairs(Breeds) do
	var_0_11[iter_0_0] = override_threat_value or iter_0_1.threat_value or 0

	if not iter_0_1.threat_value then
		ferror("missing threat in breed %s", iter_0_0)
	end
end

function ConflictDirector.get_threat_value(arg_82_0)
	return arg_82_0.threat_value, arg_82_0.num_aggroed
end

function ConflictDirector.get_num_aggroed_enemies(arg_83_0)
	return arg_83_0.num_aggroed
end

function ConflictDirector.set_threat_value(arg_84_0, arg_84_1, arg_84_2)
	var_0_11[arg_84_1] = arg_84_2
end

function ConflictDirector.calculate_threat_value(arg_85_0)
	local var_85_0 = 0
	local var_85_1 = 0
	local var_85_2 = Managers.state.performance:activated_per_breed()

	for iter_85_0, iter_85_1 in pairs(var_85_2) do
		var_85_0 = var_85_0 + var_0_11[iter_85_0] * iter_85_1
		var_85_1 = var_85_1 + iter_85_1
	end

	arg_85_0.delay_horde = var_85_0 > arg_85_0.delay_horde_threat_value
	arg_85_0.delay_mini_patrol = var_85_0 > arg_85_0.delay_mini_patrol_threat_value
	arg_85_0.delay_specials = var_85_0 > arg_85_0.delay_specials_threat_value
	arg_85_0.threat_value = var_85_0
	arg_85_0.num_aggroed = var_85_1
end

function ConflictDirector.check_pacing_event_delay(arg_86_0)
	if arg_86_0.event_delay then
		arg_86_0.delay_horde = true
		arg_86_0.delay_mini_patrol = true
		arg_86_0.delay_specials = true
	end
end

local var_0_12 = DamageDataIndex.SOURCE_ATTACKER_UNIT

function ConflictDirector.register_unit_killed(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
	arg_87_0:_remove_unit_from_spawned(arg_87_1, arg_87_2)

	local var_87_0 = arg_87_0._hero_side
	local var_87_1 = arg_87_2.side

	if Managers.state.side:is_enemy_by_side(var_87_0, var_87_1) then
		local var_87_2 = var_87_0.PLAYER_AND_BOT_UNITS

		arg_87_0.pacing:enemy_killed(arg_87_1, var_87_2)
	end

	local var_87_3 = arg_87_2.breed.name
	local var_87_4 = POSITION_LOOKUP[arg_87_1]
	local var_87_5
	local var_87_6 = Managers.state.entity:system("ai_system"):get_attributes(arg_87_1)

	if var_87_6.grudge_marked and var_87_6.breed_enhancements or nil then
		Managers.telemetry_events:ai_died(arg_87_2.enemy_id, var_87_3, var_87_4)
	end

	Managers.state.event:trigger("on_unit_killed", arg_87_1, arg_87_3, arg_87_4)
end

function ConflictDirector.register_unit_destroyed(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
	local var_88_0 = arg_88_2.breed
	local var_88_1 = var_88_0.name
	local var_88_2 = POSITION_LOOKUP[arg_88_1]

	Managers.telemetry_events:ai_despawned(var_88_1, var_88_2, arg_88_3)
	Managers.state.event:trigger_referenced(arg_88_1, "on_ai_unit_destroyed")

	if var_88_0.run_on_despawn then
		var_88_0.run_on_despawn(arg_88_1, arg_88_2)
	end

	if var_0_6.disable_breed_freeze_opt or not arg_88_0.breed_freezer or not arg_88_0.breed_freezer:try_mark_unit_for_freeze(var_88_0, arg_88_1) then
		Managers.state.unit_spawner:mark_for_deletion(arg_88_1)
	end

	arg_88_2.about_to_be_destroyed = true
end

function ConflictDirector.event_delay_pacing(arg_89_0, arg_89_1)
	arg_89_0.event_delay = arg_89_1

	if not arg_89_1 then
		local var_89_0 = Managers.time:time("game")

		arg_89_0.specials_pacing:delay_spawning(var_89_0, 10, 15)
	end
end

function ConflictDirector.destroy_unit(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	if ALIVE[arg_90_1] then
		Managers.state.event:trigger("on_ai_unit_destroyed", arg_90_1, arg_90_2, arg_90_3)

		if USE_ENGINE_SLOID_SYSTEM then
			notify_attackers(arg_90_1, arg_90_0.dogpiled_attackers_on_unit)
		else
			arg_90_0.gathering:notify_attackers(arg_90_1)
		end

		arg_90_0:_remove_unit_from_spawned(arg_90_1, arg_90_2)
		arg_90_0:register_unit_destroyed(arg_90_1, arg_90_2, arg_90_3)
	end
end

function ConflictDirector.destroy_all_units(arg_91_0, arg_91_1)
	print("ConflictDirector - destroy all units")

	if not Managers.state.network:game() then
		return
	end

	local var_91_0 = var_0_1
	local var_91_1 = arg_91_0._conflict_data_by_side

	for iter_91_0, iter_91_1 in pairs(var_91_1) do
		local var_91_2 = iter_91_1.spawned

		for iter_91_2 = #var_91_2, 1, -1 do
			local var_91_3 = var_91_2[iter_91_2]

			if ALIVE[var_91_3] then
				local var_91_4 = var_91_0[var_91_3]
				local var_91_5 = var_91_4.breed

				if not arg_91_1 or not var_91_5.debug_despawn_immunity then
					local var_91_6 = "destroy_all_units"

					arg_91_0:destroy_unit(var_91_3, var_91_4, var_91_6)
				end
			end
		end
	end

	Managers.state.event:trigger("ai_units_all_destroyed")

	arg_91_0._living_horde = 0
end

function ConflictDirector.destroy_close_units(arg_92_0, arg_92_1, arg_92_2, arg_92_3)
	if not Managers.state.network:game() then
		return
	end

	arg_92_1 = arg_92_1 or POSITION_LOOKUP[Managers.player:local_player().player_unit]

	if not arg_92_1 then
		return
	end

	local var_92_0 = 0
	local var_92_1 = arg_92_0._conflict_data_by_side

	for iter_92_0, iter_92_1 in pairs(var_92_1) do
		local var_92_2 = iter_92_1.spawned
		local var_92_3 = #var_92_2
		local var_92_4 = 1
		local var_92_5 = var_0_1

		while var_92_4 <= var_92_3 do
			local var_92_6 = var_92_2[var_92_4]
			local var_92_7

			if ALIVE[var_92_6] and var_92_6 ~= arg_92_2 then
				local var_92_8 = Unit.local_position(var_92_6, 0)

				var_92_7 = arg_92_3 > var_0_2(arg_92_1, var_92_8)
			else
				var_92_7 = false
			end

			if var_92_7 then
				local var_92_9 = var_92_5[var_92_6]
				local var_92_10 = var_92_9.breed
				local var_92_11 = "destroy_close_units"

				var_92_0 = var_92_0 + 1

				if Managers.weave:get_active_weave() then
					local var_92_12 = {
						breed = var_92_10
					}
					local var_92_13 = Managers.player:local_player().player_unit

					Managers.state.entity:system("objective_system"):on_ai_killed(var_92_6, var_92_13, var_92_12)
				end

				arg_92_0:destroy_unit(var_92_6, var_92_9, var_92_11)

				var_92_3 = var_92_3 - 1
			else
				var_92_4 = var_92_4 + 1
			end
		end
	end

	print("debug destroy close units", var_92_0)
end

function ConflictDirector.destroy_specials(arg_93_0)
	print("debug destroy specials")

	local var_93_0 = arg_93_0._alive_specials
	local var_93_1 = #var_93_0
	local var_93_2 = var_0_1

	for iter_93_0 = var_93_1, 1, -1 do
		local var_93_3 = var_93_0[iter_93_0]

		if ALIVE[var_93_3] then
			local var_93_4 = var_93_2[var_93_3]
			local var_93_5 = var_93_4.breed
			local var_93_6 = "destroy_specials"

			arg_93_0:destroy_unit(var_93_3, var_93_4, var_93_6)
		end
	end

	fassert(#arg_93_0._alive_specials == 0, "Something bad happend when debug despawned all specials")

	local var_93_7 = arg_93_0._hero_side.PLAYER_AND_BOT_UNITS

	for iter_93_1, iter_93_2 in ipairs(var_93_7) do
		local var_93_8 = ScriptUnit.extension(iter_93_2, "status_system")

		if var_93_8.pack_master_status and var_93_8.pack_master_status == "pack_master_hanging" then
			StatusUtils.set_grabbed_by_pack_master_network("pack_master_dropping", iter_93_2, true, nil)
		end
	end
end

function ConflictDirector.debug_spawn_breed(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	local var_94_0 = Breeds[arg_94_1]
	local var_94_1 = arg_94_4
	local var_94_2 = var_94_1[1]
	local var_94_3 = var_94_1[2]

	if var_94_3 and arg_94_0[var_94_3] and arg_94_0[var_94_3](arg_94_0, var_94_1[3], var_94_1[4], var_94_1[5], var_94_1[6]) then
		return
	end

	if not var_94_0 then
		print("debug spawning - missing breed")

		return
	end

	if not Managers.state.unit_spawner.unit_template_lut[var_94_0.unit_template] then
		printf("Failed to spawn '%s' - No unit template found", var_94_0.name)

		return
	end

	print("Debug spawning: " .. var_94_0.name)

	local var_94_4
	local var_94_5 = var_94_0.debug_spawn_func_name

	if var_94_5 then
		var_94_4 = arg_94_0[var_94_5](arg_94_0, var_94_0, false, arg_94_2, arg_94_3)
	else
		var_94_4 = arg_94_0:aim_spawning(var_94_0, false, arg_94_2, arg_94_3)
	end

	return var_94_4
end

local var_0_13 = true

function ConflictDirector.debug_spawn_all_breeds(arg_95_0, arg_95_1, arg_95_2)
	local var_95_0 = arg_95_0:aim_spawning(nil, true)

	if not var_95_0 then
		return
	end

	local var_95_1 = {}

	if arg_95_2 then
		for iter_95_0, iter_95_1 in pairs(arg_95_1) do
			var_95_1[#var_95_1 + 1] = Breeds[iter_95_0]
		end
	else
		for iter_95_2, iter_95_3 in pairs(Breeds) do
			if not arg_95_1[iter_95_2] then
				var_95_1[#var_95_1 + 1] = iter_95_3
			end
		end
	end

	local var_95_2 = #var_95_1
	local var_95_3 = math.ceil(math.sqrt(var_95_2))
	local var_95_4 = Quaternion(Vector3.up(), math.degrees_to_radians(math.random(1, 360)))

	if var_0_13 then
		local var_95_5 = 1
		local var_95_6 = Managers.state.entity:system("ai_slot_system"):traverse_logic()

		for iter_95_4 = 1, var_95_3 do
			for iter_95_5 = 1, var_95_3 do
				if var_95_2 < var_95_5 then
					break
				end

				local var_95_7 = Vector3((iter_95_4 - var_95_3 * 0.5) * 4, (iter_95_5 - var_95_3 * 0.5) * 4, 0)
				local var_95_8, var_95_9 = GwNavQueries.raycast(GLOBAL_AI_NAVWORLD, var_95_0, var_95_0 + var_95_7, var_95_6)

				if var_95_8 then
					local var_95_10 = {
						ignore_breed_limits = true,
						side_id = arg_95_0.debug_spawn_side_id
					}
					local var_95_11 = var_95_1[var_95_5]

					var_95_5 = var_95_5 + 1

					arg_95_0:spawn_queued_unit(var_95_11, Vector3Box(var_95_9), QuaternionBox(var_95_4), "debug_spawn", nil, nil, var_95_10)
				end
			end
		end
	else
		local var_95_12 = 8

		for iter_95_6 = 1, var_95_2 do
			local var_95_13

			for iter_95_7 = 1, var_95_12 do
				local var_95_14 = Vector3(4 * math.random() - 2, 4 * math.random() - 2, 0)

				if iter_95_7 == 1 then
					var_95_14 = Vector3(-var_95_3 / 2 + iter_95_6 % var_95_3, -var_95_3 / 2 + math.floor(iter_95_6 / var_95_3), 0)
				end

				local var_95_15 = LocomotionUtils.pos_on_mesh(arg_95_0.nav_world, var_95_0 + var_95_14)

				if var_95_15 then
					local var_95_16 = {
						ignore_breed_limits = true,
						side_id = arg_95_0.debug_spawn_side_id
					}
					local var_95_17 = var_95_1[iter_95_6]

					arg_95_0:spawn_queued_unit(var_95_17, Vector3Box(var_95_15), QuaternionBox(var_95_4), "debug_spawn", nil, nil, var_95_16)

					break
				end
			end
		end
	end

	return true
end

function ConflictDirector.debug_spawn_breed_at_hidden_spawner(arg_96_0, arg_96_1)
	local var_96_0 = Breeds[arg_96_1]

	print("Debug spawning from hidden spawner: " .. arg_96_1)

	local var_96_1 = arg_96_0._hero_side.PLAYER_POSITIONS[1]

	if var_96_1 then
		local var_96_2 = ConflictUtils.get_random_hidden_spawner(var_96_1, 40)

		if not var_96_2 then
			print("No hidden spawner units found")

			return
		end

		local var_96_3 = Unit.local_position(var_96_2, 0)
		local var_96_4 = "debug_spawn"
		local var_96_5 = Quaternion(Vector3.up(), math.degrees_to_radians(math.random(1, 360)))
		local var_96_6 = {
			ignore_breed_limits = true,
			side_id = arg_96_0.debug_spawn_side_id
		}

		arg_96_0:spawn_queued_unit(var_96_0, Vector3Box(var_96_3), QuaternionBox(var_96_5), var_96_4, nil, nil, var_96_6)
	end
end

function ConflictDirector.rpc_debug_conflict_director_command(arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5, arg_97_6)
	arg_97_0._debug_spawn_breed_position = arg_97_4
	arg_97_0._debug_spawn_breed_enhancements = table.set(string.split_deprecated(arg_97_5, ","))

	if arg_97_2 == "debug_spawn_breed" then
		arg_97_0:debug_spawn_breed(arg_97_3, false, arg_97_4, arg_97_6)
	elseif arg_97_2 == "debug_spawn_group" then
		arg_97_0:debug_spawn_group(arg_97_3)
	elseif arg_97_2 == "debug_spawn_roaming_patrol" then
		arg_97_0:debug_spawn_roaming_patrol(arg_97_4)
	elseif arg_97_2 == "debug_spawn_group_at_main_path" then
		arg_97_0:debug_spawn_group_at_main_path(nil, nil)
	elseif arg_97_2 == "debug_spawn_breed_at_hidden_spawner" then
		arg_97_0:debug_spawn_breed_at_hidden_spawner(arg_97_3)
	elseif arg_97_2 == "destroy_close_units" then
		arg_97_0:destroy_close_units(arg_97_4, nil, (tonumber(arg_97_6[1]) or 12)^2)
	elseif arg_97_2 == "destroy_all_units" then
		arg_97_0:destroy_all_units(true)
	elseif arg_97_2 == "destroy_specials" then
		arg_97_0:destroy_specials()
	end

	arg_97_0._debug_spawn_breed_position = nil
	arg_97_0._debug_spawn_breed_enhancements = nil
end

ConflictDirector.rpc_debug_conflict_director_command = NOP

function ConflictDirector.debug_spawn_group(arg_98_0, arg_98_1)
	local var_98_0 = Breeds[arg_98_1]

	print("Spawning group: " .. arg_98_1)
	arg_98_0:aim_spawning_group(var_98_0, true)
end

function ConflictDirector.debug_spawn_group_at_main_path(arg_99_0, arg_99_1, arg_99_2)
	local var_99_0 = Breeds.skaven_storm_vermin
	local var_99_1 = "spline_patrol"

	var_0_3.destroy_los_distance_squared = math.huge

	local var_99_2 = arg_99_0.main_path_info.main_paths
	local var_99_3 = arg_99_1 and var_99_2[arg_99_1] or var_99_2[math.random(1, #var_99_2)]
	local var_99_4 = arg_99_2 and var_99_3.nodes[arg_99_2] or var_99_3.nodes[math.random(1, #var_99_3.nodes)]
	local var_99_5 = {
		wanted_size = 5,
		group_type = "main_path_patrol",
		breed = var_99_0
	}

	arg_99_0:spawn_group(var_99_1, var_99_4:unbox(), var_99_5)
end

function ConflictDirector.debug_spawn_horde(arg_100_0)
	if arg_100_0.in_safe_zone then
		print("Can't spawn horde in safe zone")

		return
	end

	local var_100_0 = var_0_6.ai_set_horde_type_debug
	local var_100_1 = arg_100_0.default_enemy_side_id
	local var_100_2 = {
		horde_wave = "single"
	}

	if not var_100_0 or var_100_0 == "random" then
		local var_100_3 = {
			"vector",
			"vector_blob",
			"ambush"
		}

		var_100_0 = var_100_3[math.random(1, #var_100_3)]
	end

	print("DEBUG_HORDE: ", var_100_0)

	if type(CurrentHordeSettings.vector_composition) == "table" then
		local var_100_4 = CurrentHordeSettings.vector_composition[math.random(#CurrentHordeSettings.vector_composition)]

		var_100_2.optional_wave_composition = var_100_4

		print("DEBUG_HORDE: Wave composition ", var_100_4)
	end

	arg_100_0.horde_spawner:horde(var_100_0, var_100_2, var_100_1)
end

function ConflictDirector.debug_speed_running_intervention(arg_101_0, arg_101_1)
	local var_101_0 = arg_101_0.speed_running_intervention_data

	if var_101_0.debug_state then
		Debug.text(string.format("%0.1f", arg_101_0._next_speed_running_intervention_time - arg_101_1) .. " SPEED RUN intervention: " .. var_101_0.debug_state)
	end

	if var_101_0.total_travel_distances then
		for iter_101_0, iter_101_1 in pairs(var_101_0.total_travel_distances) do
			local var_101_1 = Managers.player:owner(iter_101_0)

			if var_101_1 then
				local var_101_2 = SPProfiles[var_101_1:profile_index()].display_name

				Debug.text(var_101_2 .. " total travel distance: " .. iter_101_1)
			end
		end
	end
end

local function var_0_14()
	local var_102_0 = Managers.free_flight:active("global")
	local var_102_1

	if var_102_0 then
		var_102_1 = Managers.input:get_service("FreeFlight")
	else
		var_102_1 = Managers.input:get_service("Player")
	end

	return var_102_1
end

local function var_0_15()
	if Managers.free_flight:active("global") then
		local var_103_0 = Managers.free_flight.input_manager:get_service("FreeFlight")
		local var_103_1 = Managers.free_flight.data.global
		local var_103_2 = Managers.world:world(var_103_1.viewport_world_name)
		local var_103_3 = ScriptWorld.global_free_flight_viewport(var_103_2)
		local var_103_4 = var_103_1.frustum_freeze_camera or ScriptViewport.camera(var_103_3)
		local var_103_5 = var_103_0:get("cursor")
		local var_103_6 = Camera.screen_to_world(var_103_4, Vector3(var_103_5.x, var_103_5.y, 0), 0)
		local var_103_7 = Camera.screen_to_world(var_103_4, Vector3(var_103_5.x, var_103_5.y, 0), 1) - var_103_6
		local var_103_8 = Vector3.normalize(var_103_7)

		return var_103_6, var_103_8
	else
		local var_103_9 = Managers.player:local_player(1)
		local var_103_10 = Managers.state.camera:camera_position(var_103_9.viewport_name)
		local var_103_11 = Managers.state.camera:camera_rotation(var_103_9.viewport_name)
		local var_103_12 = Quaternion.forward(var_103_11)

		return var_103_10, var_103_12
	end
end

function ConflictDirector.player_aim_raycast(arg_104_0, arg_104_1, arg_104_2, arg_104_3)
	local var_104_0, var_104_1 = var_0_15()
	local var_104_2 = Managers.player:local_player(1).player_unit
	local var_104_3 = World.get_data(arg_104_1, "physics_world")
	local var_104_4 = PhysicsWorld.immediate_raycast(var_104_3, var_104_0, var_104_1, 100, "all", "collision_filter", arg_104_3)

	if var_104_4 then
		local var_104_5 = #var_104_4

		for iter_104_0 = 1, var_104_5 do
			local var_104_6 = var_104_4[iter_104_0]
			local var_104_7 = var_104_6[4]
			local var_104_8 = Actor.unit(var_104_7)

			if not (var_104_8 == var_104_2) then
				local var_104_9 = Unit.get_data(var_104_8, "breed")

				if arg_104_2 then
					if var_104_9 then
						return var_104_9, var_104_6[1], var_104_6[2], var_104_6[3], var_104_6[4], var_104_1
					end
				else
					return var_104_6[1], var_104_6[2], var_104_6[3], var_104_6[4], var_104_1
				end
			end
		end
	end

	return nil
end

function ConflictDirector.debug_spawn_tentacle_blob(arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4)
	print("DEBUG SPAWN TENTACLE")

	local var_105_0, var_105_1, var_105_2, var_105_3 = arg_105_0:player_aim_raycast(arg_105_0._world, arg_105_2, "filter_ray_horde_spawn")

	if not var_105_0 then
		return
	end

	local var_105_4 = var_105_0

	QuickDrawerStay:sphere(var_105_4, 0.33, Color(255, 0, 0))

	local var_105_5 = "debug_spawn"
	local var_105_6 = Quaternion(Vector3.up(), math.degrees_to_radians(math.random(1, 360)))
	local var_105_7 = arg_105_1.debug_spawn_optional_data or {}

	function var_105_7.spawned_func(arg_106_0, arg_106_1, arg_106_2)
		if arg_106_1.special then
			arg_105_0._alive_specials[#arg_105_0._alive_specials + 1] = arg_106_0
		end

		local var_106_0 = Managers.state.entity:system("ai_system")

		if var_106_0.ai_debugger and not HEALTH_ALIVE[var_106_0.ai_debugger.active_unit] and not var_0_6.ai_disable_auto_ai_debugger_target then
			var_106_0.ai_debugger.active_unit = arg_106_0
			var_0_6.debug_unit = arg_106_0
		end
	end

	var_105_7.ignore_breed_limits = true
	var_105_7.side_id = arg_105_0.debug_spawn_side_id

	arg_105_0:spawn_queued_unit(arg_105_1, Vector3Box(var_105_4), QuaternionBox(var_105_6), var_105_5, nil, nil, var_105_7)
end

function ConflictDirector.aim_spawning_surface(arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4)
	local var_107_0, var_107_1, var_107_2, var_107_3 = arg_107_0:player_aim_raycast(arg_107_0._world, false, "filter_ray_horde_spawn")

	if arg_107_1.inside_wall_spawn_distance then
		var_107_0 = var_107_0 - var_107_2 * arg_107_1.inside_wall_spawn_distance
	end

	local var_107_4 = "debug_spawn"
	local var_107_5 = Quaternion.look(var_107_2, Vector3.up())
	local var_107_6 = arg_107_1.debug_spawn_optional_data or {}

	var_107_6.side_id = arg_107_0.debug_spawn_side_id

	function var_107_6.spawned_func(arg_108_0, arg_108_1, arg_108_2)
		if arg_108_1.special then
			arg_107_0._alive_specials[#arg_107_0._alive_specials + 1] = arg_108_0
		end

		local var_108_0 = Managers.state.entity:system("ai_system")

		if var_108_0.ai_debugger and not HEALTH_ALIVE[var_108_0.ai_debugger.active_unit] and not var_0_6.ai_disable_auto_ai_debugger_target then
			var_108_0.ai_debugger.active_unit = arg_108_0
			var_0_6.debug_unit = arg_108_0
		end
	end

	var_107_6.ignore_breed_limits = true

	arg_107_0:spawn_queued_unit(arg_107_1, Vector3Box(var_107_0), QuaternionBox(var_107_5), var_107_4, nil, nil, var_107_6)
end

function ConflictDirector.set_debug_spawn_side(arg_109_0, arg_109_1)
	arg_109_0.debug_spawn_side_id = arg_109_1
end

function ConflictDirector.cycle_debug_spawn_side(arg_110_0)
	arg_110_0.debug_spawn_side_id = arg_110_0.debug_spawn_side_id % #Managers.state.side:sides() + 1
end

function ConflictDirector.aim_spawning_air(arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
	local var_111_0, var_111_1, var_111_2, var_111_3 = arg_111_0:player_aim_raycast(arg_111_0._world, false, "filter_ray_horde_spawn")
	local var_111_4 = "debug_spawn"
	local var_111_5 = Quaternion.identity()

	if not var_111_0 then
		local var_111_6
		local var_111_7

		var_111_0, var_111_7 = var_0_15()
		var_111_0 = var_111_0 + var_111_7 * arg_111_1.air_spawning_distance
	elseif arg_111_1.inside_wall_spawn_distance then
		var_111_0 = var_111_0 - var_111_2 * arg_111_1.inside_wall_spawn_distance
	end

	local var_111_8 = arg_111_1.debug_spawn_optional_data or {}

	var_111_8.side_id = arg_111_0.debug_spawn_side_id

	function var_111_8.spawned_func(arg_112_0, arg_112_1, arg_112_2)
		if arg_112_1.special then
			arg_111_0._alive_specials[#arg_111_0._alive_specials + 1] = arg_112_0
		end

		local var_112_0 = Managers.state.entity:system("ai_system")

		if var_112_0.ai_debugger and not HEALTH_ALIVE[var_112_0.ai_debugger.active_unit] and not var_0_6.ai_disable_auto_ai_debugger_target then
			var_112_0.ai_debugger.active_unit = arg_112_0
			var_0_6.debug_unit = arg_112_0
		end
	end

	var_111_8.ignore_breed_limits = true

	arg_111_0:spawn_queued_unit(arg_111_1, Vector3Box(var_111_0), QuaternionBox(var_111_5), var_111_4, nil, nil, var_111_8)
end

function ConflictDirector.aim_spawning(arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4, arg_113_5)
	local var_113_0
	local var_113_1
	local var_113_2
	local var_113_3

	if not DEDICATED_SERVER and not arg_113_4 then
		local var_113_4, var_113_5, var_113_6

		var_113_0, var_113_4, var_113_5, var_113_6 = arg_113_0:player_aim_raycast(arg_113_0._world, false, "filter_ray_horde_spawn")
	end

	if arg_113_3 then
		return var_113_0
	elseif arg_113_4 then
		var_113_0 = arg_113_4
	elseif arg_113_0._debug_spawn_breed_position then
		var_113_0 = arg_113_0._debug_spawn_breed_position
	end

	if not var_113_0 then
		return
	end

	local var_113_7

	if arg_113_2 then
		var_113_7 = LocomotionUtils.pos_on_mesh(arg_113_0.nav_world, var_113_0)
	else
		var_113_7 = var_113_0
	end

	if arg_113_1 then
		local var_113_8 = "debug_spawn"
		local var_113_9 = Quaternion(Vector3.up(), math.degrees_to_radians(math.random(1, 360)))
		local var_113_10 = arg_113_1.debug_spawn_optional_data or {}

		var_113_10.ignore_breed_limits = true
		var_113_10.side_id = arg_113_0.debug_spawn_side_id

		function var_113_10.spawned_func(arg_114_0, arg_114_1, arg_114_2)
			if arg_114_1.special then
				arg_113_0._alive_specials[#arg_113_0._alive_specials + 1] = arg_114_0
			end

			local var_114_0 = Managers.state.entity:system("ai_system")

			if var_114_0.ai_debugger and not HEALTH_ALIVE[var_114_0.ai_debugger.active_unit] and not var_0_6.ai_disable_auto_ai_debugger_target then
				var_114_0.ai_debugger.active_unit = arg_114_0
				var_0_6.debug_unit = arg_114_0
			end
		end

		if arg_113_5 then
			table.merge(var_113_10, arg_113_5)
		end

		arg_113_0:spawn_queued_unit(arg_113_1, Vector3Box(var_113_7), QuaternionBox(var_113_9), var_113_8, nil, nil, var_113_10)
	else
		return var_113_7
	end
end

function ConflictDirector.debug_spawn_roaming_patrol(arg_115_0, arg_115_1)
	if not arg_115_1 then
		return
	end

	local var_115_0 = Managers.state.entity:system("ai_group_system")

	if var_115_0:level_has_splines("roaming") then
		local var_115_1 = PatrolFormationSettings.random_roaming_formation(BreedPacks.beastmen[3])
		local var_115_2 = var_115_0:get_best_spline(arg_115_1, "roaming")

		if not var_115_2 then
			Debug.sticky_text("no roaming spline within max distance")

			return
		end

		local var_115_3 = {
			Vector3Box(28, -243, 0),
			Vector3Box(37, -143, 0)
		}
		local var_115_4 = {
			spawn_all_at_same_position = false,
			group_type = "roaming_patrol",
			formation = var_115_1,
			spline_name = var_115_2,
			spline_way_points = var_115_3
		}

		arg_115_0:spawn_spline_group("spline_patrol", arg_115_1, var_115_4)
	end
end

function ConflictDirector.debug_spawn_spline_patrol_closest_spawner(arg_116_0)
	local var_116_0 = Managers.player:local_player()
	local var_116_1 = arg_116_0:get_free_flight_pos() or POSITION_LOOKUP[var_116_0.player_unit]
	local var_116_2, var_116_3 = Managers.state.conflict.level_analysis:debug_get_closest_boss_patrol_spawn(var_116_1)
	local var_116_4 = {
		spline_type = "patrol",
		event_kind = "event_spline_patrol",
		spline_id = var_116_2.id,
		spline_way_points = var_116_3,
		one_directional = var_116_2.one_directional
	}

	TerrorEventMixer.start_event("boss_event_chaos_spline_patrol", var_116_4)
end

function ConflictDirector.aim_patrol_spawning(arg_117_0, arg_117_1)
	arg_117_0:aim_spawning_group(nil, true, arg_117_1)

	return true
end

function ConflictDirector.inject_event_patrol(arg_118_0)
	local var_118_0, var_118_1, var_118_2 = arg_118_0.conflict_director.level_analysis:get_closest_roaming_spline(area_position:unbox())

	if not var_118_0 then
		return false
	end

	local var_118_3 = var_118_1.waypoints
	local var_118_4 = arg_118_0:boxify_waypoint_table(var_118_3)
end

function ConflictDirector.aim_spawning_group(arg_119_0, arg_119_1, arg_119_2, arg_119_3)
	local var_119_0, var_119_1, var_119_2, var_119_3 = arg_119_0:player_aim_raycast(arg_119_0._world, false, "filter_ray_horde_spawn")

	if arg_119_0._debug_spawn_breed_position then
		var_119_0 = arg_119_0._debug_spawn_breed_position
	end

	if not var_119_0 then
		return
	end

	if not arg_119_3 then
		local var_119_4 = {
			wanted_size = 50,
			group_type = "grid",
			breed = arg_119_1
		}

		arg_119_0:spawn_group("spline_patrol", var_119_0, var_119_4)
	else
		local var_119_5 = Managers.state.entity:system("ai_group_system")
		local var_119_6 = "patrol"
		local var_119_7 = false

		if var_119_6 then
			local var_119_8 = Managers.state.difficulty:get_difficulty()
			local var_119_9 = PatrolFormationSettings[arg_119_3][var_119_8]

			var_119_9.settings = PatrolFormationSettings[arg_119_3].settings

			local var_119_10
			local var_119_11
			local var_119_12
			local var_119_13
			local var_119_14 = var_119_5:get_best_spline(var_119_0, var_119_6)

			if var_119_14 then
				var_119_11 = {
					Vector3Box(110, 0, 0),
					Vector3Box(1, -220, 0)
				}
			else
				local var_119_15

				var_119_14, var_119_11, var_119_15 = arg_119_0.level_analysis:get_closest_waypoint_spline(var_119_0)

				if var_119_14 then
					var_119_0 = var_119_15
					var_119_7 = true
				else
					print("No patrol spline found")

					return
				end
			end

			local var_119_16 = {
				spawn_all_at_same_position = false,
				group_type = "spline_patrol",
				formation = var_119_9,
				spline_name = var_119_14,
				spline_way_points = var_119_11,
				despawn_at_end = var_119_7
			}

			arg_119_0:spawn_spline_group("spline_patrol", var_119_0, var_119_16)
		else
			local var_119_17 = {
				group_type = "main_path_patrol",
				breed = arg_119_1 or Breeds.skaven_storm_vermin
			}

			arg_119_0:spawn_group("spline_patrol", var_119_0, var_119_17)
		end
	end
end

local var_0_16 = {}

function ConflictDirector.spawn_group(arg_120_0, arg_120_1, arg_120_2, arg_120_3)
	if type(arg_120_3) ~= "table" then
		print("wrong spawn type")

		return
	end

	local var_120_0 = arg_120_3.group_type
	local var_120_1 = Managers.state.difficulty:get_difficulty_settings()
	local var_120_2 = arg_120_3.wanted_size or 0
	local var_120_3 = 8
	local var_120_4 = 0
	local var_120_5 = var_120_0 == "grid"
	local var_120_6 = var_120_5 and math.ceil(math.sqrt(var_120_2))

	for iter_120_0 = 1, var_120_2 do
		local var_120_7

		for iter_120_1 = 1, var_120_3 do
			local var_120_8 = Vector3(4 * Math.random() - 2, 4 * Math.random() - 2, 0)

			if var_120_5 and iter_120_1 == 1 then
				var_120_8 = Vector3(-var_120_6 / 2 + iter_120_0 % var_120_6, -var_120_6 / 2 + math.floor(iter_120_0 / var_120_6), 0)
			end

			local var_120_9 = LocomotionUtils.pos_on_mesh(arg_120_0.nav_world, arg_120_2 + var_120_8)

			if var_120_9 then
				var_120_4 = var_120_4 + 1
				var_0_16[var_120_4] = var_120_9

				break
			end
		end
	end

	if var_120_4 == 0 then
		return
	end

	local var_120_10

	if var_120_0 == "main_path_patrol" then
		var_120_10 = {
			id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
			template = arg_120_1,
			size = var_120_4,
			group_type = var_120_0
		}
	end

	local var_120_11 = "patrol"
	local var_120_12 = Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360)))
	local var_120_13 = {
		ignore_breed_limits = true,
		side_id = arg_120_0.debug_spawn_side_id or arg_120_3.side_id
	}

	for iter_120_2 = 1, var_120_4 do
		local var_120_14 = var_0_16[iter_120_2]
		local var_120_15 = arg_120_3.breed

		arg_120_0:spawn_queued_unit(var_120_15, Vector3Box(var_120_14), QuaternionBox(var_120_12), var_120_11, nil, nil, var_120_13, var_120_10)
	end
end

function ConflictDirector.spawn_spline_group(arg_121_0, arg_121_1, arg_121_2, arg_121_3)
	local var_121_0 = arg_121_3.group_type
	local var_121_1 = arg_121_3.spline_name
	local var_121_2 = arg_121_3.formation
	local var_121_3 = arg_121_3.zone_data
	local var_121_4 = arg_121_3.spawn_all_at_same_position
	local var_121_5 = Managers.state.entity:system("ai_group_system")
	local var_121_6 = arg_121_2 and Vector3Box(arg_121_2)
	local var_121_7 = Managers.state.side:get_side(arg_121_0.default_enemy_side_id)
	local var_121_8 = {
		id = var_121_5:generate_group_id(),
		template = arg_121_1,
		spline_name = var_121_1,
		formation = var_121_2,
		group_type = var_121_0,
		group_start_position = var_121_6,
		data = arg_121_3,
		zone_data = var_121_3,
		despawn_at_end = arg_121_3.despawn_at_end,
		spawn_all_at_same_position = var_121_4,
		side = var_121_7
	}
	local var_121_9 = var_121_5:spline(var_121_1)

	if var_121_9 then
		print("Spline already found!")

		if not var_121_9.failed then
			arg_121_0:_spawn_spline_group(var_121_8)
		else
			print("spline is in fail state, cancelling the spline spawn.", var_121_1)
		end
	elseif arg_121_3.spline_way_points then
		var_121_5:create_spline_from_way_points(var_121_1, arg_121_3.spline_way_points, arg_121_3.spline_type)

		arg_121_0._spline_groups_to_spawn = arg_121_0._spline_groups_to_spawn or {}
		arg_121_0._spline_groups_to_spawn[var_121_1] = var_121_8
	else
		ferror("Missing spline: %s", var_121_1)
	end
end

function ConflictDirector._check_hi_data_override(arg_122_0, arg_122_1, arg_122_2, arg_122_3)
	local var_122_0 = arg_122_1.name
	local var_122_1 = arg_122_2[var_122_0]

	if var_122_1 then
		var_122_1.count = var_122_1.count + 1

		if var_122_1.count > var_122_1.max_amount then
			arg_122_1 = var_122_1.switch_breed
			var_122_1.switch_count = var_122_1.switch_count + 1

			return arg_122_1, var_122_0
		end
	end

	return arg_122_1
end

function ConflictDirector.set_breed_override_lookup(arg_123_0, arg_123_1)
	arg_123_0._breed_override_lookup = arg_123_1
end

function ConflictDirector._spawn_spline_group(arg_124_0, arg_124_1, arg_124_2)
	local var_124_0 = "patrol"
	local var_124_1 = arg_124_1.formation
	local var_124_2 = arg_124_1.spline_name
	local var_124_3 = Managers.state.entity:system("ai_group_system")
	local var_124_4 = arg_124_1.spawn_all_at_same_position
	local var_124_5 = arg_124_1.group_start_position and arg_124_1.group_start_position:unbox() or var_124_3:spline_start_position(var_124_2)
	local var_124_6 = var_124_3:create_formation_data(var_124_5, var_124_1, var_124_2, var_124_4, arg_124_1)

	arg_124_1.formation = var_124_6
	arg_124_1.group_start_position = Vector3Box(var_124_5)

	local var_124_7 = var_124_6.group_size

	if var_124_7 == 0 then
		return
	end

	local var_124_8 = arg_124_1.zone_data
	local var_124_9

	if var_124_8 then
		local var_124_10 = var_124_8.hi_data

		var_124_9 = var_124_10 and var_124_10.breed_count
	end

	arg_124_1.size = var_124_7

	local var_124_11 = arg_124_0._breed_override_lookup

	for iter_124_0, iter_124_1 in ipairs(var_124_6) do
		for iter_124_2, iter_124_3 in ipairs(iter_124_1) do
			repeat
				local var_124_12 = iter_124_3.breed_name

				if not Breeds[var_124_12] then
					break
				end

				local var_124_13 = {}
				local var_124_14 = Breeds[var_124_12]

				if var_124_9 then
					local var_124_15
					local var_124_16

					var_124_14, var_124_16 = arg_124_0:_check_hi_data_override(var_124_14, var_124_9, var_124_8)
				end

				if var_124_11 then
					local var_124_17 = var_124_11[var_124_14.name]

					if var_124_17 then
						var_124_14 = Breeds[var_124_17]
					end
				end

				local var_124_18 = iter_124_3.start_position:unbox()
				local var_124_19 = iter_124_3.start_direction:unbox()
				local var_124_20 = Quaternion.look(var_124_19, Vector3.up())
				local var_124_21 = table.shallow_copy(arg_124_1)

				var_124_21.breed = var_124_12
				var_124_21.group_position = {
					row = iter_124_0,
					column = iter_124_2
				}
				var_124_13.far_off_despawn_immunity = true

				arg_124_0:spawn_queued_unit(var_124_14, Vector3Box(var_124_18), QuaternionBox(var_124_20), var_124_0, nil, nil, var_124_13, var_124_21)
			until true
		end
	end
end

function ConflictDirector.spawn_one(arg_125_0, arg_125_1, arg_125_2, arg_125_3, arg_125_4, arg_125_5)
	if arg_125_1.special and Managers.state.game_mode:setting("ai_specials_spawning_disabled") then
		return
	end

	local var_125_0 = "spawn_one"
	local var_125_1 = arg_125_0._hero_side.PLAYER_POSITIONS
	local var_125_2 = var_125_1[1]

	if not var_125_2 then
		for iter_125_0 = 1, #var_125_1 do
			local var_125_3 = var_125_1[iter_125_0]

			if var_125_3 then
				var_125_2 = var_125_3

				break
			end
		end
	end

	if not var_125_2 then
		return
	end

	local var_125_4 = arg_125_2 or ConflictUtils.get_spawn_pos_on_circle(arg_125_0.nav_world, var_125_2, 20, 8, 30)

	if var_125_4 then
		local var_125_5 = arg_125_5 or Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360)))

		arg_125_0:spawn_queued_unit(arg_125_1, Vector3Box(var_125_4), QuaternionBox(var_125_5), var_125_0, nil, nil, arg_125_4, arg_125_3)
	end
end

local function var_0_17(arg_126_0, arg_126_1, arg_126_2)
	local var_126_0 = Managers.state.entity:system("play_go_tutorial_system")

	if var_126_0 then
		local var_126_1 = arg_126_2.spawner_unit
		local var_126_2 = Managers.state.conflict:_get_spawned_unit_id(arg_126_0)

		var_126_0:register_unit(var_126_1, arg_126_0, var_126_2)
	end
end

function ConflictDirector.spawn_at_raw_spawner(arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4)
	local var_127_0, var_127_1 = Managers.state.entity:system("spawner_system"):get_raw_spawner_unit(arg_127_2)

	if var_127_0 then
		local var_127_2 = Unit.local_position(var_127_0, 0)
		local var_127_3 = Unit.local_rotation(var_127_0, 0)

		arg_127_3 = arg_127_3 or {}
		arg_127_3.idle_animation = var_127_1
		arg_127_3.spawner_unit = var_127_0

		if arg_127_3.spawned_func then
			local var_127_4 = arg_127_3.spawned_func

			function arg_127_3.spawned_func(arg_128_0, arg_128_1, arg_128_2)
				var_127_4(arg_128_0, arg_128_1, arg_128_2)
				var_0_17(arg_128_0, arg_128_1, arg_128_2)
			end
		else
			arg_127_3.spawned_func = var_0_17
		end

		arg_127_3.side_id = arg_127_3.side_id or arg_127_4 or arg_127_0.default_enemy_side_id

		arg_127_0:spawn_queued_unit(arg_127_1, Vector3Box(var_127_2), QuaternionBox(var_127_3), "raw_spawner", nil, nil, arg_127_3, nil, nil)
	end
end

function ConflictDirector.debug_spawn_at_raw(arg_129_0, arg_129_1, arg_129_2, arg_129_3)
	local var_129_0 = arg_129_0:player_aim_raycast(arg_129_0._world, false, "filter_ray_horde_spawn")

	if arg_129_0._debug_spawn_breed_position then
		var_129_0 = arg_129_0._debug_spawn_breed_position
	end

	local var_129_1 = Quaternion.identity()

	arg_129_2 = arg_129_2 or {}

	if arg_129_2.spawned_func then
		local var_129_2 = arg_129_2.spawned_func

		function arg_129_2.spawned_func(arg_130_0, arg_130_1, arg_130_2)
			var_129_2(arg_130_0, arg_130_1, arg_130_2)
			var_0_17(arg_130_0, arg_130_1, arg_130_2)
		end
	else
		arg_129_2.spawned_func = var_0_17
	end

	arg_129_2.side_id = arg_129_2.side_id or arg_129_3 or arg_129_0.default_enemy_side_id

	arg_129_0:spawn_queued_unit(arg_129_1, Vector3Box(var_129_0), QuaternionBox(var_129_1), "raw_spawner", nil, nil, arg_129_2, nil, nil)
end

function ConflictDirector.generate_spawns(arg_131_0)
	local var_131_0
	local var_131_1
	local var_131_2
	local var_131_3
	local var_131_4
	local var_131_5, var_131_6 = arg_131_0.level_analysis:get_start_and_finish()

	fassert(var_131_6, "Missing path marker at the end of the level")

	local var_131_7 = GwNavTraversal.get_seed_triangle(arg_131_0.nav_world, var_131_6:unbox())

	fassert(var_131_7, "The path marker at the end of the level is outside the navmesh")
	arg_131_0.navigation_group_manager:setup(arg_131_0._world, arg_131_0.nav_world)

	if var_0_4 then
		print("Forming navigation groups in one frame")
		arg_131_0.navigation_group_manager:form_groups(nil, var_131_6)
	else
		arg_131_0.navigation_group_manager:form_groups_start(nil, var_131_6)
	end

	if CurrentConflictSettings.roaming.disabled then
		print("roaming spawning is disabled")

		return {}
	end

	if arg_131_0.spawn_zone_baker.spawn_zones_available and not arg_131_0.level_settings.skip_generate_spawns then
		local var_131_8 = 0.5
		local var_131_9 = arg_131_0.current_conflict_settings or "default"
		local var_131_10 = ConflictDirectors[var_131_9].pack_spawning or PackSpawningSettings.default
		local var_131_11 = var_131_10.basics
		local var_131_12 = var_131_11.spawn_cycle_length
		local var_131_13 = var_131_10.area_density_coefficient
		local var_131_14 = var_131_11.length_density_coefficient
		local var_131_15 = Managers.state.game_mode:mutators()
		local var_131_16 = table.keys(var_131_15)
		local var_131_17, var_131_18, var_131_19, var_131_20, var_131_21 = arg_131_0.spawn_zone_baker:generate_spawns(var_131_12, var_131_8, var_131_13, var_131_14, var_131_9, var_131_16)
		local var_131_22 = var_131_21
		local var_131_23 = var_131_20
		local var_131_24 = var_131_19
		local var_131_25 = var_131_18

		return var_131_17, var_131_25, var_131_24, var_131_23, var_131_22
	else
		print("This level is missing spawn_zones. No roaming enemies will spawn at all.")
	end

	return {}
end

function ConflictDirector.register_main_path_obstacle(arg_132_0, arg_132_1, arg_132_2)
	local var_132_0 = arg_132_0._main_path_obstacles

	var_132_0[#var_132_0 + 1] = {
		position = arg_132_1,
		radius_sq = arg_132_2
	}
end

function ConflictDirector.ai_ready(arg_133_0, arg_133_1)
	arg_133_0.enemy_package_loader = Managers.level_transition_handler.enemy_package_loader

	print("CurrentConflictSettings", arg_133_0.current_conflict_settings)

	if CurrentConflictSettings.disabled then
		Managers.state.event:trigger("conflict_director_setup_done")

		return
	end

	print("[ConflictDirector] conflict_director is ai_ready")

	arg_133_0.level_settings = LevelHelper:current_level_settings()
	arg_133_0.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_133_0.patrol_analysis = PatrolAnalysis:new(arg_133_0.nav_world, false, QuickDrawerStay)

	Managers.state.entity:system("ai_group_system"):ai_ready(arg_133_0.patrol_analysis)

	if USE_ENGINE_SLOID_SYSTEM then
		fassert(EngineOptimized.init_sloid_system, "You are running the wrong executable. sloid_system is missing")

		arg_133_0.sloid_broadphase = Broadphase(1, 128)

		local var_133_0 = Managers.state.entity:system("ai_system").broadphase
		local var_133_1 = Managers.state.entity:system("ai_slot_system"):traverse_logic()

		EngineOptimized.init_sloid_system(arg_133_0._world, arg_133_0.sloid_broadphase, var_133_0, arg_133_0.nav_world, var_133_1)

		arg_133_0.dogpiled_attackers_on_unit = {}
	else
		local var_133_2 = Managers.state.entity:system("ai_slot_system"):traverse_logic()

		arg_133_0.gathering = Gathering:new(arg_133_0.nav_world, var_133_2)
	end

	arg_133_0.nav_tag_volume_handler = NavTagVolumeHandler:new(arg_133_0._world, arg_133_0.nav_world)
	arg_133_0.level_analysis.nav_world = arg_133_0.nav_world
	arg_133_0.level_analysis.level_settings = arg_133_0.level_settings
	arg_133_0.spawn_zone_baker = SpawnZoneBaker:new(arg_133_0._world, arg_133_0.nav_world, arg_133_0.level_analysis, arg_133_1)

	local var_133_3 = arg_133_0.spawn_zone_baker.zones
	local var_133_4 = arg_133_0.spawn_zone_baker.num_main_zones
	local var_133_5 = var_0_7(var_133_3, var_133_4)

	arg_133_0._peak_delayer = PeakDelayer:new(var_133_5)
	arg_133_0.spawn_zone_baker.zones = Managers.state.game_mode._mutator_handler:tweak_zones(arg_133_0.current_conflict_settings, var_133_3, arg_133_0.spawn_zone_baker.num_main_zones)

	if arg_133_0.spawn_zone_baker:loaded_spawn_zones_available() then
		-- block empty
	else
		local var_133_6 = arg_133_0.level_analysis:generate_main_path()

		arg_133_0.level_analysis:remove_crossroads_extra_path_branches()

		if var_133_6 ~= "success" then
			Debug.sticky_text("Level fail: %s", var_133_6, "delay", 20)

			return
		end
	end

	arg_133_0.main_path_info.main_paths = arg_133_0.level_analysis:get_main_paths()

	local var_133_7 = 3
	local var_133_8, var_133_9, var_133_10, var_133_11 = MainPathUtils.node_list_from_main_paths(arg_133_0.nav_world, arg_133_0.main_path_info.main_paths, var_133_7, arg_133_0._main_path_obstacles)

	arg_133_0.main_path_info.merged_main_paths = {
		forward_list = var_133_8,
		reversed_list = var_133_9,
		forward_break_list = var_133_10,
		reversed_break_list = var_133_11
	}
	arg_133_0.specials_pacing = SpecialsPacing:new(arg_133_0._world, arg_133_0.nav_world, arg_133_0.nav_tag_volume_handler, arg_133_0._enemy_side)

	local var_133_12 = {
		arg_133_0.level_analysis:get_start_and_finish()
	}

	fassert(var_133_12, "The path marker at the start of level is outside nav mesh")

	arg_133_0._spawn_pos_list, arg_133_0._pack_sizes, arg_133_0._pack_rotations, arg_133_0.pack_members, arg_133_0._zone_data_list = arg_133_0:generate_spawns()

	if var_0_4 then
		arg_133_0:ai_nav_groups_ready(arg_133_1)
	end

	if LevelHelper:should_load_enemies(arg_133_0._level_key) then
		arg_133_0.breed_freezer = BreedFreezer:new(arg_133_0._world, Managers.state.entity, arg_133_0._network_event_delegate, arg_133_0.enemy_package_loader)
	end
end

function ConflictDirector.ai_nav_groups_ready(arg_134_0, arg_134_1)
	arg_134_0.enemy_recycler = EnemyRecycler:new(arg_134_0._world, arg_134_0.nav_world, arg_134_0._spawn_pos_list, arg_134_0._pack_sizes, arg_134_0._pack_rotations, arg_134_0.pack_members, arg_134_0._zone_data_list, arg_134_1)

	arg_134_0.level_analysis:set_enemy_recycler(arg_134_0.enemy_recycler)

	arg_134_0.horde_spawner = HordeSpawner:new(arg_134_0._world, arg_134_0.level_analysis.cover_points_broadphase)

	if arg_134_0.spawn_zone_baker:loaded_spawn_zones_available() and CurrentBossSettings and not CurrentBossSettings.disabled then
		arg_134_0.level_analysis:generate_boss_paths()
	end

	local var_134_0 = arg_134_0.main_path_info.main_paths

	arg_134_0.navigation_group_manager:assign_main_path_indexes(var_134_0)

	arg_134_0.in_safe_zone = true
	arg_134_0.director_is_ai_ready = true

	Managers.state.event:trigger("conflict_director_setup_done")
	arg_134_0:create_debug_list()
end

function ConflictDirector.a_star_area_pos_search(arg_135_0, arg_135_1, arg_135_2)
	local var_135_0 = GwNavTraversal.get_seed_triangle(arg_135_0.nav_world, arg_135_1)
	local var_135_1 = GwNavTraversal.get_seed_triangle(arg_135_0.nav_world, arg_135_2)

	if not var_135_0 or not var_135_1 then
		return false
	end

	local var_135_2 = arg_135_0.navigation_group_manager:get_polygon_group(var_135_0)
	local var_135_3 = arg_135_0.navigation_group_manager:get_polygon_group(var_135_1)

	if var_135_2 and var_135_3 then
		local var_135_4, var_135_5 = arg_135_0.navigation_group_manager:a_star_cached(var_135_2, var_135_3)

		return var_135_4, var_135_5
	end
end

function ConflictDirector.freeze_intensity_decay(arg_136_0, arg_136_1)
	arg_136_0.frozen_intensity_decay_until = arg_136_0._time + arg_136_1
end

function ConflictDirector.intensity_decay_frozen(arg_137_0, arg_137_1)
	return arg_137_0._time < arg_137_0.frozen_intensity_decay_until
end

function ConflictDirector.boss_event_running(arg_138_0, arg_138_1)
	arg_138_1 = arg_138_1 or arg_138_0.default_enemy_side_id

	local var_138_0 = arg_138_0._conflict_data_by_side[arg_138_1].num_spawned_by_breed

	return var_138_0.skaven_rat_ogre > 0 or var_138_0.skaven_stormfiend > 0 or var_138_0.chaos_troll > 0 or var_138_0.chaos_spawn > 0 or var_138_0.beastmen_minotaur > 0 or var_138_0.chaos_troll_chief > 0
end

function ConflictDirector.angry_boss(arg_139_0)
	return arg_139_0._num_angry_bosses > 0
end

function ConflictDirector.add_angry_boss(arg_140_0, arg_140_1, arg_140_2)
	arg_140_0._num_angry_bosses = math.clamp(arg_140_0._num_angry_bosses + arg_140_1, 0, 255)

	if arg_140_2 then
		AiUtils.activate_unit(arg_140_2)
	end
end

function ConflictDirector.level_flow_event(arg_141_0, arg_141_1)
	LevelHelper:flow_event(arg_141_0._world, arg_141_1)
end

function ConflictDirector.jslots(arg_142_0, arg_142_1, arg_142_2)
	local var_142_0 = POSITION_LOOKUP[arg_142_1]
	local var_142_1 = POSITION_LOOKUP[arg_142_1]
end

function ConflictDirector.update_server_debug(arg_143_0, arg_143_1, arg_143_2)
	local var_143_0 = arg_143_0._hero_side
	local var_143_1 = var_143_0 and var_143_0.PLAYER_POSITIONS

	if var_0_6.debug_zone_baker_on_screen then
		arg_143_0.spawn_zone_baker:draw_zone_info_on_screen()
	end

	if var_0_6.debug_current_threat_value then
		local var_143_2, var_143_3 = arg_143_0:get_threat_value()

		Debug.text("DELAY: HORDE %s, SPECIALS %s, MINI_PATROL %s, Threat value: %.2f, num aggroed: %d", tostring(arg_143_0.delay_horde), tostring(arg_143_0.delay_specials), tostring(arg_143_0.delay_mini_patrol), var_143_2, var_143_3)
	end

	if var_0_6.show_current_conflict_settings then
		Debug.text("Current ConflictSettings [%s]", CurrentConflictSettings.name)
	end

	if var_0_6.debug_conflict_director_breeds then
		local var_143_4 = Managers.state.difficulty:get_difficulty()
		local var_143_5 = CurrentConflictSettings.contained_breeds[var_143_4]

		Debug.text("Conflict Director Breeds:")

		for iter_143_0, iter_143_1 in pairs(var_143_5) do
			Debug.text("   %s", iter_143_0)
		end
	end

	if DebugKeyHandler.key_pressed("t", "test terror", "ai", "left shift") then
		print("Pressed t")

		if ConflictDirectorTests.start_test(arg_143_0, arg_143_1, arg_143_2) then
			return
		end
	end

	local var_143_6 = var_0_14()

	if var_143_6:get("wield_7") or var_143_6:get("keyboard_7") then
		Debug.sticky_text("{#color(200,200,200)} debug_spawn_side: {#color(200,0,0)} %d {#reset()}", 1, "delay", 2)
		arg_143_0:set_debug_spawn_side(1)
	end

	if var_143_6:get("wield_8") or var_143_6:get("keyboard_8") then
		Debug.sticky_text("{#color(200,200,200)} debug_spawn_side: {#color(0,0,200)} %d {#reset()}", 2, "delay", 2)
		arg_143_0:set_debug_spawn_side(2)
	end

	if DebugKeyHandler.key_pressed("f", "toggle debug graphs", "ai", "left shift") then
		local var_143_7 = #arg_143_0._debug_list

		for iter_143_2 = 2, var_143_7 do
			arg_143_0._debug_list[iter_143_2]:show_debug(false)
		end

		for iter_143_3 = 1, var_143_7 do
			local var_143_8 = arg_143_0._current_debug_list_index % var_143_7 + 1

			if var_143_8 == 1 then
				arg_143_0._current_debug_list_index = var_143_8

				break
			elseif arg_143_0._debug_list[var_143_8]:show_debug(true) then
				arg_143_0._current_debug_list_index = var_143_8

				break
			end
		end

		print("toggle debug graphs:", arg_143_0._current_debug_list_index)
	end

	if DebugKeyHandler.key_pressed("g", "execute debug graphs", "ai", "left shift") then
		local var_143_9 = arg_143_0._debug_list[arg_143_0._current_debug_list_index]

		if var_143_9 and type(var_143_9) == "table" and var_143_9.execute_debug then
			var_143_9:execute_debug()
		end
	end

	if var_0_6.show_alive_ai then
		local var_143_10 = arg_143_0._conflict_data_by_side[arg_143_0.default_enemy_side_id]

		ConflictUtils.display_number_of_breeds("TOTAL: ", #var_143_10.spawned, var_143_10.num_spawned_by_breed)

		if arg_143_0.running_master_event then
			local var_143_11 = 0

			for iter_143_4, iter_143_5 in pairs(var_143_10.num_spawned_by_breed_during_event) do
				var_143_11 = var_143_11 + iter_143_5
			end

			ConflictUtils.display_number_of_breeds("EVENT: ", var_143_11, var_143_10.num_spawned_by_breed_during_event)
		end
	end

	if var_0_6.show_where_ai_is then
		local var_143_12 = arg_143_0._conflict_data_by_side[arg_143_0.default_enemy_side_id]

		ConflictUtils.show_where_ai_is(var_143_12.spawned)
	end

	if DebugKeyHandler.key_pressed("o", "draw spawn zones", "ai", "left shift") then
		local var_143_13 = arg_143_0.draw_all_zones

		var_143_13 = var_143_13 == nil and "all" or var_143_13 == "all" and "last" or var_143_13 == "last" and "last_naive" or var_143_13 == "last_naive" and nil

		if var_143_13 == "all" then
			arg_143_0.spawn_zone_baker:draw_zones(arg_143_0.nav_world)
		elseif var_143_13 == "last_naive" then
			-- block empty
		elseif var_143_13 == "last" then
			-- block empty
		else
			arg_143_0.spawn_zone_baker:draw_zones(arg_143_0.nav_world)
		end

		arg_143_0.draw_all_zones = var_143_13
	end

	local var_143_14 = arg_143_0.draw_all_zones

	if var_143_14 ~= "nil" then
		if var_143_14 == "all" then
			Debug.text("Draw Zone-segment (all)")
		elseif var_143_14 == "last" then
			local var_143_15 = arg_143_0.level_analysis:get_main_paths()
			local var_143_16 = arg_143_0.main_path_info.ahead_travel_dist or 0
			local var_143_17 = arg_143_0.spawn_zone_baker:get_zone_segment_from_travel_dist(var_143_16)

			if var_143_17 then
				Debug.text("Draw Zone-segment: %d (last) travel_dist: %.1f", var_143_17, var_143_16)
				arg_143_0.spawn_zone_baker:draw_zones(arg_143_0.nav_world, var_143_17)
			else
				Debug.text("Draw Zone-segment not precalculated (last)")
			end
		elseif var_143_14 == "last_naive" then
			local var_143_18 = arg_143_0.level_analysis:get_main_paths()
			local var_143_19 = MainPathUtils.zone_segment_on_mainpath(var_143_18, var_143_1[1])

			arg_143_0.spawn_zone_baker:draw_zones(arg_143_0.nav_world, var_143_19)
			Debug.text("Draw Zone-segment: %d (last_naive)", var_143_19)
		end
	end

	if var_0_6.debug_ai_pacing then
		local var_143_20 = arg_143_0._hero_side.PLAYER_AND_BOT_UNITS

		if DebugKeyHandler.key_pressed("numpad_plus", "Increase intensity +25", "Pacing & Intensity") then
			arg_143_0.pacing:debug_add_intensity(var_143_20, 25)
		end

		if DebugKeyHandler.key_pressed("numpad_minus", "Decrease intensity -25", "Pacing & Intensity") then
			arg_143_0.pacing:debug_add_intensity(var_143_20, -25)
		end

		local var_143_21 = arg_143_0._conflict_data_by_side[arg_143_0.default_enemy_side_id]

		Debug.text("Total enemies alive: " .. tostring(#var_143_21.spawned))
	end

	if var_0_6.debug_rush_intervention then
		local var_143_22 = arg_143_0.rushing_intervention_data

		if ALIVE[var_143_22.ahead_unit] then
			var_143_22.ahead_unit_name = Managers.player:unit_owner(var_143_22.ahead_unit):profile_display_name()
		else
			var_143_22.ahead_unit_name = "?"
		end

		local var_143_23 = math.clamp(arg_143_0._next_rushing_intervention_time - arg_143_1, 0, 999999)
		local var_143_24 = CurrentSpecialsSettings.rush_intervention

		if var_143_22.disabled then
			Debug.text("Rusher: %s ", var_143_22.disabled)
		else
			Debug.text("Rusher: %s loneliness: %.1f / ( special: %.1f, horde: %.1f ) (%s) ahead-dist: %.1f, time: %.1f ", var_143_22.ahead_unit_name, var_143_22.loneliness_value, var_143_24.loneliness_value_for_special, var_143_24.loneliness_value_for_ambush_horde, tostring(var_143_22.message), var_143_22.ahead_dist, var_143_23)
		end
	end

	if DebugKeyHandler.key_pressed("h", "spawn_horde", "ai") and not DamageUtils.is_in_inn then
		arg_143_0:debug_spawn_horde()
	end

	if DebugKeyHandler.key_pressed("a", "force target switch", "ai", "left shift") then
		local var_143_25 = var_0_6.debug_unit

		if ALIVE[var_143_25] then
			ScriptUnit.extension(var_143_25, "ai_system"):blackboard().target_changed = true
		end
	end

	if var_0_6.debug_ai_pacing then
		for iter_143_6, iter_143_7 in pairs(arg_143_0._rushing_checks) do
			ConflictUtils.draw_stack_of_balls(iter_143_7.start_pos:unbox(), 255, 255, 30, 0)

			local var_143_26 = arg_143_0.main_path_player_info[iter_143_6]

			if var_143_26 and var_143_26.path_pos then
				ConflictUtils.draw_stack_of_balls(var_143_26.path_pos:unbox(), 255, 30, 255, 0)
			end
		end
	end

	if var_0_6.debug_near_cover_points then
		ConflictUtils.hidden_cover_points(var_143_1[1], var_143_1, 1, 35, nil)
	end

	if var_0_6.debug_player_positioning then
		local var_143_27 = arg_143_0._enemy_side
		local var_143_28, var_143_29, var_143_30, var_143_31 = arg_143_0:get_cluster_and_loneliness(10, var_143_27.ENEMY_PLAYER_POSITIONS, var_143_27.ENEMY_PLAYER_UNITS)

		if var_143_31 then
			QuickDrawer:sphere(var_0_0[var_143_31], 0.88)
		end

		local var_143_32 = 7
		local var_143_33 = arg_143_0._hero_side.PLAYER_AND_BOT_POSITIONS
		local var_143_34, var_143_35 = ConflictUtils.cluster_positions(var_143_33, var_143_32)

		for iter_143_8 = 1, #var_143_34 do
			QuickDrawer:sphere(var_143_34[iter_143_8], var_143_32)

			for iter_143_9 = 1, var_143_35[iter_143_8] do
				QuickDrawer:sphere(var_143_34[iter_143_8] + Vector3(0, 0, 2 + iter_143_9), 0.6)
			end
		end

		local var_143_36 = arg_143_0.main_path_info
		local var_143_37 = var_143_36.ahead_unit
		local var_143_38 = 0

		if var_143_37 then
			local var_143_39 = arg_143_0.main_path_player_info[var_143_37]

			var_143_38 = arg_143_0._rushing_intervention_travel_dist - var_143_39.travel_dist

			local var_143_40 = var_143_39.path_pos:unbox()
			local var_143_41 = Color(0, 200, 30)
			local var_143_42 = POSITION_LOOKUP[var_143_37]
			local var_143_43 = var_143_40 + Vector3(0, 0, 0.5)
			local var_143_44 = var_143_40 + Vector3(0, 0, 1)
			local var_143_45 = var_143_40 + Vector3(0, 0, 1.5)

			QuickDrawer:cone(var_143_40, var_143_43, 0.3, var_143_41, 8, 8)
			QuickDrawer:cone(var_143_43, var_143_44, 0.3, var_143_41, 8, 8)
			QuickDrawer:cone(var_143_44, var_143_45, 0.3, var_143_41, 8, 8)
			QuickDrawer:cone(var_143_42, var_143_42 + Vector3(0, 0, 2), 0.3, var_143_41, 8, 8)
			QuickDrawer:line(var_143_42 + Vector3(0, 0, 1), var_143_40 + Vector3(0, 0, 1), var_143_41)

			local var_143_46 = var_143_36.ahead_percent * 100
			local var_143_47 = arg_143_0._next_progression_percent * 100

			Debug.text("Ahead unit travel dist: %.1f, progression %d/%d", var_143_39.travel_dist, var_143_46, var_143_47)
		end

		local var_143_48 = var_143_36.behind_unit

		if var_143_48 then
			local var_143_49 = arg_143_0.main_path_player_info[var_143_48].path_pos:unbox()
			local var_143_50 = Color(200, 200, 0)
			local var_143_51 = POSITION_LOOKUP[var_143_48]
			local var_143_52 = var_143_49 + Vector3(0, 0, 0.5)
			local var_143_53 = var_143_49 + Vector3(0, 0, 1)
			local var_143_54 = var_143_49 + Vector3(0, 0, 1.5)

			QuickDrawer:cone(var_143_49, var_143_52, 0.3, var_143_50, 8, 7)
			QuickDrawer:cone(var_143_52, var_143_53, 0.3, var_143_50, 8, 7)
			QuickDrawer:cone(var_143_53, var_143_54, 0.3, var_143_50, 8, 7)
			QuickDrawer:cone(var_143_51, var_143_51 + Vector3(0, 0, 2), 0.3, var_143_50, 8, 8)
			QuickDrawer:line(var_143_51 + Vector3(0, 0, 1), var_143_49 + Vector3(0, 0, 1), var_143_50)
		end

		local var_143_55 = arg_143_0._next_rushing_intervention_time - arg_143_1

		Debug.text("cluster-utility: %s, lone-value: %.1f, intervention dist: %.1f, intervention timer: %.1f", tostring(var_143_28), var_143_30, var_143_38, var_143_55)
	end
end

function ConflictDirector.client_ready(arg_144_0)
	if LevelHelper:should_load_enemies(arg_144_0._level_key) then
		local var_144_0 = Managers.level_transition_handler.enemy_package_loader

		arg_144_0.breed_freezer = BreedFreezer:new(arg_144_0._world, Managers.state.entity, arg_144_0._network_event_delegate, var_144_0)
	end
end

function ConflictDirector.update_client(arg_145_0, arg_145_1, arg_145_2)
	return
end

function ConflictDirector.hot_join_sync(arg_146_0, arg_146_1)
	if arg_146_0.breed_freezer then
		arg_146_0.breed_freezer:hot_join_sync(arg_146_1)
	end
end

function ConflictDirector.set_peaks(arg_147_0, arg_147_1)
	arg_147_0._peak_delayer:set_peaks(arg_147_1)
end

function ConflictDirector.get_peaks(arg_148_0)
	return arg_148_0._peak_delayer:get_peaks()
end

function ConflictDirector.is_near_or_in_a_peak(arg_149_0)
	return arg_149_0._peak_delayer:is_near_or_in_a_peak()
end

function ConflictDirector.spawn_breed_func(arg_150_0, arg_150_1)
	local var_150_0 = arg_150_0._debug_spawn_breed_enhancements

	if var_150_0 and next(var_150_0) then
		arg_150_0:debug_spawn_variant(arg_150_1, var_150_0)

		return true
	end
end

function ConflictDirector.debug_spawn_variant(arg_151_0, arg_151_1, arg_151_2, arg_151_3)
	local var_151_0 = Breeds[arg_151_1]

	if arg_151_2 then
		local var_151_1 = TerrorEventUtils.generate_enhanced_breed_from_set(arg_151_2)
		local var_151_2 = {
			enhancements = var_151_1
		}

		return arg_151_0:aim_spawning(var_151_0, false, nil, nil, var_151_2)
	elseif arg_151_3 then
		local var_151_3 = TerrorEventUtils.generate_enhanced_breed(arg_151_3, arg_151_1, BossGrudgeMarks)
		local var_151_4 = {
			enhancements = var_151_3
		}

		return arg_151_0:aim_spawning(var_151_0, false, nil, nil, var_151_4)
	end

	return var_151_0
end

function ConflictDirector.world(arg_152_0)
	return arg_152_0._world
end

function ConflictDirector.debug_spawn_encampment(arg_153_0, arg_153_1)
	local var_153_0 = Managers.state.debug.debug_breed_picker.mirrored_encampment_spawning
	local var_153_1, var_153_2, var_153_3, var_153_4, var_153_5 = arg_153_0:player_aim_raycast(arg_153_0._world, false, "filter_ray_horde_spawn")

	if not var_153_1 then
		print("No spawn pos found")

		return
	end

	local var_153_6 = EncampmentTemplates[arg_153_1]
	local var_153_7 = Vector3(var_153_5[1], var_153_5[2], 0)
	local var_153_8 = Quaternion.look(var_153_7)
	local var_153_9 = math.random(1, #var_153_6.unit_compositions)
	local var_153_10 = var_153_6.unit_compositions[var_153_9]
	local var_153_11 = FormationUtils.make_encampment(var_153_6)
	local var_153_12 = var_153_0 and 1 or arg_153_0.debug_spawn_side_id

	FormationUtils.spawn_encampment(var_153_11, var_153_1, var_153_8, var_153_10, var_153_12)

	if var_153_0 then
		local var_153_13 = Quaternion.look(-var_153_7)
		local var_153_14 = math.random(1, #var_153_6.unit_compositions)
		local var_153_15 = var_153_6.unit_compositions[var_153_14]
		local var_153_16 = FormationUtils.make_encampment(var_153_6)

		FormationUtils.spawn_encampment(var_153_16, var_153_1 + Quaternion.rotate(var_153_13, Vector3(0, -8, 0)), var_153_13, var_153_15, 2)
	end
end

function ConflictDirector.spawn_encampment(arg_154_0, arg_154_1)
	print("spawn_encampent")

	local var_154_0, var_154_1, var_154_2, var_154_3, var_154_4 = arg_154_0:player_aim_raycast(arg_154_0._world, false, "filter_ray_horde_spawn")

	if not var_154_0 or not var_154_4 then
		print("No spawn pos found")

		return
	end

	local var_154_5 = Quaternion.look(-Vector3(var_154_4[1], var_154_4[2], 0)) or Quaternion.look(Vector3(0, 1, 0))
	local var_154_6 = EncampmentTemplates[arg_154_1]
	local var_154_7 = math.random(1, #var_154_6.unit_compositions)
	local var_154_8 = var_154_6.unit_compositions[var_154_7]
	local var_154_9 = EncampmentTemplates[arg_154_1]
	local var_154_10 = FormationUtils.make_encampment(var_154_9)

	FormationUtils.spawn_encampment(var_154_10, var_154_0, var_154_5, var_154_8, arg_154_0.debug_spawn_side_id)
end

function ConflictDirector.pick_enhancement(arg_155_0, arg_155_1)
	print("Picked:", arg_155_1)
end
