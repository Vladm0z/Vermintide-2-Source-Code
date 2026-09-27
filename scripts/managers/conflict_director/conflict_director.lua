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

local POSITION_LOOKUP = POSITION_LOOKUP
local BLACKBOARDS = BLACKBOARDS
local distance_squared = Vector3.distance_squared
local RecycleSettings = RecycleSettings
local flag = true
local tbl = {
	"rpc_terror_event_trigger_flow"
}
local script_data = script_data
local debug_terror = script_data.debug_terror

debug_terror = debug_terror or Development.parameter("debug_terror")
script_data.debug_terror = debug_terror

local ai_roaming_spawning_disabled = script_data.ai_roaming_spawning_disabled

ai_roaming_spawning_disabled = ai_roaming_spawning_disabled or Development.parameter("ai_roaming_spawning_disabled")
script_data.ai_roaming_spawning_disabled = ai_roaming_spawning_disabled

local ai_specials_spawning_disabled = script_data.ai_specials_spawning_disabled

ai_specials_spawning_disabled = ai_specials_spawning_disabled or Development.parameter("ai_specials_spawning_disabled")
script_data.ai_specials_spawning_disabled = ai_specials_spawning_disabled

local ai_horde_spawning_disabled = script_data.ai_horde_spawning_disabled

ai_horde_spawning_disabled = ai_horde_spawning_disabled or Development.parameter("ai_horde_spawning_disabled")
script_data.ai_horde_spawning_disabled = ai_horde_spawning_disabled

local ai_pacing_disabled = script_data.ai_pacing_disabled

ai_pacing_disabled = ai_pacing_disabled or Development.parameter("ai_pacing_disabled")
script_data.ai_pacing_disabled = ai_pacing_disabled

local ai_far_off_despawn_disabled = script_data.ai_far_off_despawn_disabled

ai_far_off_despawn_disabled = ai_far_off_despawn_disabled or Development.parameter("ai_far_off_despawn_disabled")
script_data.ai_far_off_despawn_disabled = ai_far_off_despawn_disabled

local debug_player_positioning = script_data.debug_player_positioning

debug_player_positioning = debug_player_positioning or Development.parameter("debug_player_positioning")
script_data.debug_player_positioning = debug_player_positioning

local function fn(self, arg_1_1)
	-- function 1
	local tbl = {}

	for i = 1, arg_1_1 do
		local var_1_1 = self[i]

		if not var_1_1.peak then
			tbl[#tbl + 1] = var_1_1.travel_dist
		end
	end

	return tbl
end

local testify = script_data.testify

testify = not testify and require("scripts/managers/conflict_director/conflict_director_testify")
ConflictDirector = class(ConflictDirector)

ConflictDirector.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	self._world = arg_2_1
	self._time = 0
	self._level_key = arg_2_2
	self._conflict_data_by_side = {}
	self.num_spawned_by_breed = {}
	self._num_spawned_ai = 0
	self._all_spawned_units = Script.new_array(128)
	self._all_spawned_units_lookup = {}
	self.num_queued_spawn_by_breed = {}

	TerrorEventUtils.set_seed(arg_2_4)

	self._current_debug_list_index = 1
	self._debug_list = {
		"none"
	}

	local var_2_0 = LevelSettings[arg_2_2]

	self.initial_conflict_settings = arg_2_6

	self:set_updated_settings(arg_2_6)

	self.pacing = Pacing:new(arg_2_1)
	self.enemy_recycler = nil
	self.specials_pacing = nil
	self.navigation_group_manager = NavigationGroupManager:new()
	self._alive_specials = {}
	self._alive_bosses = {}
	self._alive_standards = {}
	self._next_pacing_update = Math.random()
	self._next_threat_update = self._next_pacing_update + 0.1
	self._living_horde = 0
	self._horde_ends_at = math.huge
	self._num_angry_bosses = 0
	self._next_horde_time = math.huge
	self._player_directions = {}
	self._drop_crumb_time = 0
	self.world_gui = World.create_world_gui(arg_2_1, Matrix4x4.identity(), 1, 1, "immediate", "material", "materials/fonts/gw_fonts")
	self._player_areas = {}

	self:reset_queued_spawn_by_breed()
	TerrorEventMixer.reset()

	self._rushing_checks = {}
	self._next_rush_check_unit = nil
	self._next_rush_check = math.huge
	self.spawn_queue = {}
	self.first_spawn_index = 1
	self.spawn_queue_size = 0
	self.spawn_queue_id = 0
	self.main_path_player_info = {}
	self._spawn_queue_id_lut = Script.new_array(1024)

	self:_setup_sides_to_update_recycler()

	local get_side_from_name = Managers.state.side:get_side_from_name("dark_pact")

	if not get_side_from_name then
		self.default_enemy_side_id = get_side_from_name.side_id

		fassert(self.default_enemy_side_id, "default enemy side id is missing")
	else
		self.default_enemy_side_id = 2
		get_side_from_name = Managers.state.side:get_side(2)
	end

	self._enemy_side = get_side_from_name
	self._master_event_id = 0

	local _conflict_data_by_side = self._conflict_data_by_side
	local sides = Managers.state.side:sides()

	for k, v in pairs(sides) do
		_conflict_data_by_side[k] = {
			num_spawned_ai_event = 0,
			num_spawned_ai = 0,
			spawned = {},
			spawned_lookup = {},
			spawned_units_by_breed = {},
			num_spawned_by_breed = {},
			num_spawned_by_breed_during_event = {}
		}

		self:_reset_spawned_by_breed(k)
		self:_reset_spawned_by_breed_during_event(k)
	end

	local get_side_from_name_2 = Managers.state.side:get_side_from_name("heroes")

	get_side_from_name_2 = get_side_from_name_2 or Managers.state.side:get_side(1)
	self._hero_side = get_side_from_name_2

	local var_2_5
	local var_2_6

	if not get_side_from_name_2 then
		self.default_hero_side_id = get_side_from_name_2.side_id

		local PLAYER_UNITS = get_side_from_name_2.PLAYER_UNITS

		var_2_5 = PLAYER_UNITS[1]
		var_2_6 = PLAYER_UNITS[1]
	end

	self.main_path_info = {
		current_path_index = 1,
		behind_percent = 1,
		ahead_percent = 0,
		ahead_travel_dist = 0,
		main_path_player_info_index = 0,
		ahead_unit = var_2_5,
		behind_unit = var_2_6,
		player_info_by_travel_distance = {}
	}
	self._main_path_obstacles = {}
	self._next_progression_percent = 0.1
	self._next_rushing_intervention_time = 5.1
	self._rushing_intervention_travel_dist = 50
	self.rushing_intervention_data = {
		ahead_dist = 0,
		loneliness_value = 0
	}
	self._next_speed_running_intervention_time = 5.1
	self.speed_running_intervention_data = {
		next_travel_dist_check_t = 10,
		player_travel_distances = {},
		total_travel_distances = {}
	}
	self.in_safe_zone = true
	self.disabled = false
	self._mini_patrol_state = "waiting"
	self._next_mini_patrol_timer = 15

	local level_name = var_2_0.level_name

	self.level_analysis = LevelAnalysis:new(nil, false, level_name, arg_2_4)
	self._network_event_delegate = arg_2_3

	arg_2_3:register(self, unpack(tbl))

	self.frozen_intensity_decay_until = 0
	self.threat_value = 0
	self.num_aggroed = 0

	local get_difficulty, var_2_10 = Managers.state.difficulty:get_difficulty()

	self._delay_horde = nil

	local tweaked_delay_threat_value

	if not CurrentPacing.delay_horde_threat_value then
		tweaked_delay_threat_value = DifficultyTweak.converters.tweaked_delay_threat_value(get_difficulty, var_2_10, CurrentPacing.delay_horde_threat_value)

		if not tweaked_delay_threat_value then
			-- Nothing
		end
	end

	tweaked_delay_threat_value = math.huge

	::label_2_0::

	self.delay_horde_threat_value = tweaked_delay_threat_value

	local tweaked_delay_threat_value_2

	if not CurrentPacing.delay_mini_patrol_threat_value then
		tweaked_delay_threat_value_2 = DifficultyTweak.converters.tweaked_delay_threat_value(get_difficulty, var_2_10, CurrentPacing.delay_mini_patrol_threat_value)

		if not tweaked_delay_threat_value_2 then
			-- Nothing
		end
	end

	tweaked_delay_threat_value_2 = math.huge

	::label_2_1::

	self.delay_mini_patrol_threat_value = tweaked_delay_threat_value_2

	local tweaked_delay_threat_value_3

	if not CurrentPacing.delay_specials_threat_value then
		tweaked_delay_threat_value_3 = DifficultyTweak.converters.tweaked_delay_threat_value(get_difficulty, var_2_10, CurrentPacing.delay_specials_threat_value)

		if not tweaked_delay_threat_value_3 then
			-- Nothing
		end
	end

	tweaked_delay_threat_value_3 = math.huge

	::label_2_2::

	self.delay_specials_threat_value = tweaked_delay_threat_value_3

	Managers.state.event:register(self, "event_delay_pacing", "event_delay_pacing")
end

ConflictDirector._setup_sides_to_update_recycler = function (self)
	-- function 3
	local tbl = {}
	local sides = Managers.state.side:sides()
	local num = 1

	for i = 1, #sides do
		local var_3_3 = sides[i]

		if not var_3_3.using_enemy_recycler then
			tbl[num] = var_3_3
			num = num + 1
		end
	end

	self.sides_to_update_recycler = tbl
end

ConflictDirector.rpc_terror_event_trigger_flow = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = NetworkLookup.terror_flow_events[arg_4_2]

	self:level_flow_event(var_4_0)
end

local function fn_2(self, arg_5_1)
	-- function 5
	local count = #self

	for i = 1, count do
		if self[i] == arg_5_1 then
			self[i] = self[count]
			self[count] = nil

			return
		end
	end
end

ConflictDirector.alive_specials_count = function (self)
	-- function 6
	local num = 0

	for i, v in ipairs(self._alive_specials) do
		if not ALIVE[v] then
			num = num + 1
		end
	end

	return num
end

ConflictDirector.alive_specials = function (self, arg_7_1)
	-- function 7
	local flag = arg_7_1 or {}

	for i, v in ipairs(self._alive_specials) do
		if not ALIVE[v] then
			flag[#flag + 1] = v
		end
	end

	return flag
end

ConflictDirector.alive_bosses = function (self)
	-- function 8
	return self._alive_bosses
end

ConflictDirector.alive_standards = function (self)
	-- function 9
	return self._alive_standards
end

ConflictDirector.reset_queued_spawn_by_breed = function (arg_10_0)
	-- function 10
	for k, v in pairs(Breeds) do
		arg_10_0.num_queued_spawn_by_breed[k] = 0
	end
end

ConflictDirector._reset_spawned_by_breed = function (self, arg_11_1)
	-- function 11
	local var_11_0 = self._conflict_data_by_side[arg_11_1 or self.default_enemy_side_id]

	for k, v in pairs(Breeds) do
		var_11_0.num_spawned_by_breed[k] = 0
		var_11_0.spawned_units_by_breed[k] = {}
		self.num_spawned_by_breed[k] = 0
	end
end

ConflictDirector._reset_spawned_by_breed_during_event = function (self, arg_12_1)
	-- function 12
	self._master_event_id = self._master_event_id + 1

	local var_12_0 = self._conflict_data_by_side[arg_12_1 or self.default_enemy_side_id]

	for k, v in pairs(Breeds) do
		var_12_0.num_spawned_by_breed_during_event[k] = 0
	end

	var_12_0.num_spawned_ai_event = 0
end

ConflictDirector.destroy = function (self)
	-- function 13
	local event = Managers.state.event

	if not event then
		event:unregister("event_delay_pacing", self)
	end

	self.navigation_group_manager:destroy(self._world)

	if not self.nav_tag_volume_handler then
		self.nav_tag_volume_handler:destroy()

		self.nav_tag_volume_handler = nil
	end

	if not self.patrol_analysis then
		self.patrol_analysis:destroy()

		self.patrol_analysis = nil
	end

	self.level_analysis:destroy()
	self._network_event_delegate:unregister(self)

	self._main_path_obstacles = nil

	if not self.breed_freezer then
		self.breed_freezer:destroy()
	end

	local main_path_player_info = self.main_path_player_info

	if not main_path_player_info then
		for k, v in pairs(main_path_player_info) do
			local astar = v.astar

			if not astar then
				GwNavAStar.destroy(astar)

				v.astar = nil
			end
		end
	end
end

ConflictDirector.get_player_unit_segment = function (self, arg_14_1)
	-- function 14
	local var_14_0 = self.main_path_player_info[arg_14_1]
	local path_index

	if not var_14_0 then
		path_index = var_14_0.path_index

		if not path_index then
			-- Nothing
		end
	end

	path_index = nil

	::label_14_0::

	return path_index
end

ConflictDirector.get_player_unit_travel_distance = function (self, arg_15_1)
	-- function 15
	local var_15_0 = self.main_path_player_info[arg_15_1]
	local travel_dist

	if not var_15_0 then
		travel_dist = var_15_0.travel_dist

		if not travel_dist then
			-- Nothing
		end
	end

	travel_dist = nil

	::label_15_0::

	return travel_dist
end

ConflictDirector.stop_rush_check = function (self, arg_16_1)
	-- function 16
	self._next_rush_check = math.huge

	table.clear(self._rushing_checks)
end

ConflictDirector.init_rush_check = function (self, arg_17_1)
	-- function 17
	self.players_speeding_dist = 0
	self._next_rush_check = 0
end

ConflictDirector.are_players_rushing = function (self, arg_18_1)
	-- function 18
	if arg_18_1 > self._next_rush_check then
		local main_path_player_info = self.main_path_player_info
		local PLAYER_UNITS = self._hero_side.PLAYER_UNITS

		self._next_rush_check_unit = next(PLAYER_UNITS, self._next_rush_check_unit)

		local var_18_2 = PLAYER_UNITS[self._next_rush_check_unit]

		if not var_18_2 then
			local var_18_3 = main_path_player_info[var_18_2]

			if not var_18_3 then
				return
			end

			local _rushing_checks = self._rushing_checks
			local var_18_5 = _rushing_checks[var_18_2]

			if not var_18_5 then
				var_18_5 = {
					start_pos = Vector3Box(var_18_3.path_pos:unbox()),
					start_dist = var_18_3.travel_dist
				}
				_rushing_checks[var_18_2] = var_18_5

				return
			end

			local num = main_path_player_info[var_18_2].travel_dist - var_18_5.start_dist

			if num > self.players_speeding_dist then
				self.players_speeding_dist = num
			end

			if num > CurrentPacing.relax_rushing_distance then
				return true
			end
		else
			self._next_rush_check = arg_18_1 + 1
		end
	end
end

ConflictDirector.main_path_completion = function (self, arg_19_1)
	-- function 19
	local num = 0
	local var_19_1 = self.main_path_player_info[arg_19_1]
	local move_percent

	if not var_19_1 then
		move_percent = var_19_1.move_percent

		if not move_percent then
			-- Nothing
		end
	end

	move_percent = 0

	::label_19_0::

	return move_percent
end

ConflictDirector.sort_player_info_by_travel_distance = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local player_info_by_travel_distance = arg_20_1.player_info_by_travel_distance

	table.clear(player_info_by_travel_distance)

	local num = 0

	for k, v in pairs(arg_20_2) do
		num = num + 1
		player_info_by_travel_distance[num] = v
	end

	if num > 0 then
		table.sort(player_info_by_travel_distance, function (self, arg_21_1)
			-- function 21
			return self.travel_dist < arg_21_1.travel_dist
		end)

		local var_20_2 = player_info_by_travel_distance[1]

		arg_20_1.ahead_unit = var_20_2.unit
		arg_20_1.ahead_percent = var_20_2.move_percent
		arg_20_1.ahead_travel_dist = var_20_2.travel_dist
		arg_20_1.behind_unit = player_info_by_travel_distance[num].unit
		arg_20_1.behind_percent = var_20_2.move_percent
	else
		arg_20_1.ahead_unit = nil
		arg_20_1.ahead_percent = 0
		arg_20_1.ahead_travel_dist = 0
		arg_20_1.behind_unit = nil
		arg_20_1.behind_percent = 1
	end
end

ConflictDirector.main_path_player_far_away_check = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	local flag = math.abs(arg_22_2 - arg_22_1.travel_dist) > 100

	if not flag then
		local astar = arg_22_1.astar

		if not astar then
			if not GwNavAStar.processing_finished(astar) then
				if not GwNavAStar.path_found(astar) then
					flag = false
				end

				GwNavAStar.destroy(astar)

				arg_22_1.astar = nil
				arg_22_1.astar_timer = 0
				arg_22_1.astar_timer = arg_22_5 + 3
			end
		elseif arg_22_5 > arg_22_1.astar_timer then
			print("main_path_player_far_away_check started")

			local var_22_2 = GwNavAStar.create(self.nav_world)
			local traverse_logic = Managers.state.bot_nav_transition:traverse_logic()

			GwNavAStar.start_with_propagation_box(var_22_2, self.nav_world, arg_22_4, arg_22_3, 30, traverse_logic)

			arg_22_1.astar = var_22_2
			arg_22_1.astar_timer = arg_22_5 + 3
		end
	end

	return flag
end

ConflictDirector.update_main_path_player_info = function (self, arg_23_1, arg_23_2)
	-- function 23
	local main_path_info = self.main_path_info

	if not main_path_info.main_paths then
		return
	end

	local main_path_player_info = self.main_path_player_info
	local num = main_path_info.main_path_player_info_index + 1
	local PLAYER_AND_BOT_UNITS = arg_23_1.PLAYER_AND_BOT_UNITS
	local PLAYER_AND_BOT_POSITIONS = arg_23_1.PLAYER_AND_BOT_POSITIONS

	if num > #PLAYER_AND_BOT_UNITS then
		num = 1
	end

	main_path_info.main_path_player_info_index = num

	local var_23_5 = PLAYER_AND_BOT_UNITS[num]

	if not var_23_5 then
		local var_23_6 = PLAYER_AND_BOT_POSITIONS[num]
		local navigation_group_manager = self.navigation_group_manager
		local get_group_from_position = navigation_group_manager:get_group_from_position(var_23_6)

		if not get_group_from_position then
			local num_2 = 1
			local num_3 = 3
			local num_4 = 3
			local num_5 = 0.1
			local nav_world = self.nav_world
			local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, var_23_6, num_2, num_3, num_4, num_5)

			if not inside_position_from_outside_position then
				get_group_from_position = navigation_group_manager:get_group_from_position(inside_position_from_outside_position)
			else
				get_group_from_position = self._player_areas[num]
			end
		end

		local var_23_15

		if not get_group_from_position then
			var_23_15 = get_group_from_position:get_main_path_index()
		end

		local closest_pos_at_main_path, var_23_17, var_23_18, var_23_19, var_23_20 = MainPathUtils.closest_pos_at_main_path(nil, var_23_6, var_23_15)
		local var_23_21 = main_path_player_info[var_23_5]

		if not var_23_21 then
			var_23_21 = {
				astar_timer = 0,
				path_pos = Vector3Box(),
				unit = var_23_5,
				total_path_dist = MainPathUtils.total_path_dist(),
				travel_dist = var_23_17
			}
			main_path_player_info[var_23_5] = var_23_21
		end

		if not self:main_path_player_far_away_check(var_23_21, var_23_17, closest_pos_at_main_path, var_23_6, arg_23_2) then
			var_23_21.travel_dist, var_23_21.move_percent, var_23_21.sub_index, var_23_21.path_index = var_23_17, var_23_18, var_23_19, var_23_20

			var_23_21.path_pos:store(closest_pos_at_main_path)

			if not var_23_20 then
				main_path_info.current_path_index = math.max(var_23_20, main_path_info.current_path_index)
			end

			if not (var_23_18 >= main_path_info.ahead_percent or main_path_info.ahead_unit ~= var_23_5) then
				local get_zone_segment_from_travel_dist, var_23_23, var_23_24 = self.spawn_zone_baker:get_zone_segment_from_travel_dist(var_23_17)
				local var_23_25

				if not var_23_24 then
					var_23_25 = self:check_update_mutators(var_23_24.mutators)
				end

				local flag = false

				if not (script_data.override_conflict_settings or not var_23_24 and self.current_conflict_settings == var_23_24.conflict_setting.name or self.level_settings.ignore_zone_conflict_settings) then
					local name = var_23_24.conflict_setting.name

					flag = self:check_updated_settings(name)
				end

				if not (not var_23_25 and flag) then
					self:refresh_conflict_director_patches()
				end

				if var_23_18 >= self._next_progression_percent then
					Managers.telemetry_events:level_progression(self._next_progression_percent)

					self._next_progression_percent = self._next_progression_percent + 0.1
				end

				main_path_info.ahead_percent = var_23_18
				main_path_info.ahead_unit = var_23_5
				main_path_info.ahead_travel_dist = var_23_17
				main_path_info.zone_index = get_zone_segment_from_travel_dist
			end

			if not (var_23_18 <= main_path_info.behind_percent or main_path_info.behind_unit ~= var_23_5) then
				main_path_info.behind_percent = var_23_18
				main_path_info.behind_unit = var_23_5
			end
		end
	end

	local flag_2 = false

	for k, v in pairs(main_path_player_info) do
		if not ALIVE[k] then
			main_path_player_info[k] = nil
			flag_2 = true
		end
	end

	if not flag_2 then
		self:sort_player_info_by_travel_distance(main_path_info, main_path_player_info)
	end
end

ConflictDirector.get_main_path_player_data = function (self, arg_24_1)
	-- function 24
	return self.main_path_player_info[arg_24_1]
end

ConflictDirector.get_cluster_and_loneliness = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	if not self._cluster_and_loneliness[arg_25_1] then
		local var_25_0 = self._cluster_and_loneliness[arg_25_1]

		return var_25_0[1], var_25_0[2], var_25_0[3], var_25_0[4]
	end

	local cluster_weight_and_loneliness, var_25_2, var_25_3 = ConflictUtils.cluster_weight_and_loneliness(arg_25_2, arg_25_1 or 10)
	local var_25_4 = arg_25_3[var_25_2]
	local alloc_table = FrameTable.alloc_table()

	alloc_table[1] = cluster_weight_and_loneliness
	alloc_table[2] = arg_25_2[var_25_2]
	alloc_table[3] = var_25_3
	alloc_table[4] = var_25_4
	self._cluster_and_loneliness[arg_25_1] = alloc_table

	return cluster_weight_and_loneliness, arg_25_2[var_25_2], var_25_3, var_25_4
end

ConflictDirector.update_player_areas = function (self, arg_26_1)
	-- function 26
	local _player_areas = self._player_areas

	table.clear_array(_player_areas, #_player_areas)

	if not self.navigation_group_manager.operational then
		for i = 1, #arg_26_1 do
			local PLAYER_UNITS = arg_26_1[i].PLAYER_UNITS

			for j = 1, #PLAYER_UNITS do
				local var_26_2 = PLAYER_UNITS[j]
				local last_position_on_navmesh = ScriptUnit.extension(var_26_2, "whereabouts_system"):last_position_on_navmesh()
				local flag = not last_position_on_navmesh and self.navigation_group_manager:get_group_from_position(last_position_on_navmesh)

				if not flag then
					_player_areas[j] = flag
				else
					_player_areas[j] = false
				end
			end
		end
	end
end

ConflictDirector.add_horde = function (self, arg_27_1, arg_27_2)
	-- function 27
	self._living_horde = self._living_horde + arg_27_1

	if not arg_27_2 then
		local var_27_0 = self._spawned_units_by_breed_during_event[arg_27_2]

		var_27_0[breed_name] = var_27_0[breed_name] + 1
	end
end

ConflictDirector.set_master_event_running = function (self, arg_28_1)
	-- function 28
	if self.running_master_event ~= arg_28_1 then
		self:_reset_spawned_by_breed_during_event()
	end

	self.running_master_event = arg_28_1
end

ConflictDirector.spawned_during_event = function (self, arg_29_1)
	-- function 29
	return self._conflict_data_by_side[arg_29_1].num_spawned_ai_event
end

ConflictDirector.enemies_spawned_during_event = function (self)
	-- function 30
	return self._conflict_data_by_side[self.default_enemy_side_id].num_spawned_ai_event
end

ConflictDirector.horde_size = function (self)
	-- function 31
	return self._living_horde, self._horde_ends_at
end

ConflictDirector.has_horde = function (self)
	-- function 32
	if not self.horde_spawner then
		return self.horde_spawner:running_horde()
	end
end

ConflictDirector.is_horde_alive = function (self)
	-- function 33
	local has_horde, var_33_1 = self:has_horde()

	return self:horde_size() >= 1 or has_horde, has_horde, var_33_1
end

ConflictDirector.mini_patrol = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	-- function 34
	local flag = true
	local num = 1
	local flag_2 = true

	self._last_mini_patrol_composition = arg_34_4

	self.horde_spawner:execute_event_horde(arg_34_1, arg_34_2, arg_34_3, arg_34_4, num, flag_2, arg_34_5, flag, nil, nil, nil, arg_34_6)
end

ConflictDirector.mini_patrol_killed = function (arg_35_0, arg_35_1)
	-- function 35
	print("Mini patrol killed!", arg_35_1)
end

ConflictDirector.event_horde = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9)
	-- function 36
	if not script_data.ai_horde_spawning_disabled then
		arg_36_3 = arg_36_3 or self.default_enemy_side_id

		return (self.horde_spawner:execute_event_horde(arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, nil, arg_36_8, nil, nil, arg_36_9))
	end
end

ConflictDirector.check_updated_settings = function (self, arg_37_1)
	-- function 37
	local current_conflict_settings = self.current_conflict_settings
	local var_37_1 = script_data

	if not (not var_37_1.override_conflict_settings and var_37_1.override_conflict_settings == current_conflict_settings) then
		arg_37_1 = var_37_1.override_conflict_settings
	end

	if not (not arg_37_1 and current_conflict_settings ~= arg_37_1) then
		local current_level_settings = LevelHelper:current_level_settings()

		self.level_settings = current_level_settings

		local conflict_settings = current_level_settings.conflict_settings

		if not conflict_settings and not ConflictDirectors[conflict_settings].disabled then
			return
		end

		local flag = arg_37_1 or self.current_conflict_settings

		flag = flag or conflict_settings or "default"

		self:set_updated_settings(flag)

		return true
	end

	return false
end

ConflictDirector.check_update_mutators = function (self, arg_38_1)
	-- function 38
	local _current_zone_mutators = self._current_zone_mutators
	local var_38_1
	local var_38_2

	if not _current_zone_mutators then
		var_38_2 = arg_38_1
	elseif arg_38_1 ~= _current_zone_mutators then
		var_38_1 = {}
		var_38_2 = {}

		for i, v in ipairs(_current_zone_mutators) do
			if table.index_of(arg_38_1, v) == -1 then
				var_38_1[#var_38_1 + 1] = v
			end
		end

		for i_2, v_2 in ipairs(arg_38_1) do
			if table.index_of(_current_zone_mutators, v_2) == -1 then
				var_38_2[#var_38_2 + 1] = v_2
			end
		end
	end

	local flag = false

	if not var_38_1 then
		for i_3, v_3 in ipairs(var_38_1) do
			Managers.state.game_mode._mutator_handler:deactivate_mutator(v_3)

			flag = flag or MutatorTemplates[v_3].update_conflict_settings ~= nil
		end
	end

	if not var_38_2 then
		for i_4, v_4 in ipairs(var_38_2) do
			Managers.state.game_mode._mutator_handler:initialize_mutators({
				v_4
			})
			Managers.state.game_mode._mutator_handler:activate_mutator(v_4)

			flag = flag or MutatorTemplates[v_4].update_conflict_settings ~= nil
		end
	end

	self._current_zone_mutators = arg_38_1

	return flag
end

ConflictDirector.set_updated_settings = function (self, arg_39_1)
	-- function 39
	fassert(arg_39_1 ~= "random", "Should not get a 'random' setting in ConflictDirector:set_updated_settings")

	local var_39_0 = ConflictDirectors[arg_39_1]

	CurrentConflictSettings = var_39_0
	self.current_conflict_settings = arg_39_1

	self:refresh_conflict_director_patches()

	local var_39_1 = var_39_0

	print("Switching ConflictSettings: to: " .. tostring(var_39_1.name))

	for k, v in pairs(var_39_1) do
		if type(v) == "table" then
			print("\t" .. tostring(k) .. "=" .. tostring(v.name))
		else
			print("\t" .. tostring(k) .. "=" .. tostring(v))
		end
	end

	print("---")
end

ConflictDirector.refresh_conflict_director_patches = function (self)
	-- function 40
	local var_40_0 = ConflictDirectors[self.current_conflict_settings]
	local get_difficulty, var_40_2 = Managers.state.difficulty:get_difficulty()
	local fallback_difficulty = Managers.state.difficulty.fallback_difficulty
	local composition = DifficultyTweak.converters.composition(get_difficulty, var_40_2)
	local pacing = DifficultyTweak.converters.pacing(get_difficulty, var_40_2)
	local intensity = DifficultyTweak.converters.intensity(get_difficulty, var_40_2)

	CurrentIntensitySettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.intensity), intensity, fallback_difficulty)
	CurrentPacing = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.pacing), pacing, fallback_difficulty)
	CurrentBossSettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.boss), get_difficulty, fallback_difficulty)
	CurrentSpecialsSettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.specials), composition, fallback_difficulty)
	CurrentHordeSettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.horde), composition, fallback_difficulty)
	CurrentRoamingSettings = table.clone(var_40_0.roaming)
	CurrentPackSpawningSettings = ConflictUtils.patch_settings_with_difficulty(table.clone(var_40_0.pack_spawning), composition, fallback_difficulty)

	if not Managers.state.game_mode then
		Managers.state.game_mode:conflict_director_updated_settings()
	end
end

ConflictDirector.update_horde_pacing = function (self, arg_41_1, arg_41_2)
	-- function 41
	local pacing = self.pacing

	if not (pacing:horde_population() < 1 or pacing.pacing_state ~= "pacing_frozen") then
		self._next_horde_time = nil

		return
	end

	if not self._next_horde_time then
		self._next_horde_time = arg_41_1 + ConflictUtils.random_interval(CurrentPacing.horde_frequency)
	end

	if not (not (arg_41_1 > self._next_horde_time) or self.delay_horde) then
		local var_41_1 = self._conflict_data_by_side[self.default_enemy_side_id]
		local count = #var_41_1.spawned

		if not (count > RecycleSettings.push_horde_if_num_alive_grunts_above) then
			local CurrentPacing = CurrentPacing

			if not RecycleSettings.push_horde_in_time then
				print("HORDE: Pushing horde in time; too many units out " .. count)

				self._next_horde_time = arg_41_1 + 5

				pacing:annotate_graph("Pushed horde", "red")
			else
				print("HORDE: Skipped horde; too many units out")

				self._next_horde_time = arg_41_1 + ConflictUtils.random_interval(CurrentPacing.horde_frequency)

				pacing:annotate_graph("Failed horde", "red")
			end

			return
		end

		local var_41_4
		local var_41_5
		local var_41_6
		local var_41_7

		if not script_data.ai_pacing_disabled then
			self._next_horde_time = math.huge
			self._multiple_horde_count = nil
			var_41_4 = "unknown"
			self._wave = var_41_4
		else
			local var_41_8
			local CurrentPacing_2 = CurrentPacing

			if not CurrentPacing_2.multiple_hordes then
				if not self._multiple_horde_count then
					self._multiple_horde_count = self._multiple_horde_count - 1

					if self._multiple_horde_count <= 0 then
						print("HORDE: last wave, reset to standard horde delay")

						var_41_7 = self._current_wave_composition
						self._next_horde_time = arg_41_1 + ConflictUtils.random_interval(CurrentPacing_2.max_delay_until_next_horde)
						self._multiple_horde_count = nil
						self._current_wave_composition = nil
						var_41_4 = "multi_last_wave"
					else
						local random_interval = ConflictUtils.random_interval(CurrentPacing_2.multiple_horde_frequency)

						print("HORDE: next wave, multiple_horde_frequency -> Time delay", random_interval)

						self._next_horde_time = arg_41_1 + random_interval
						var_41_4 = "multi_consecutive_wave"
						var_41_7 = self._current_wave_composition
					end

					var_41_5 = "multi_followup"
					var_41_6 = true
				else
					self._multiple_horde_count = CurrentPacing_2.multiple_hordes - 1
					self._next_horde_time = arg_41_1 + ConflictUtils.random_interval(CurrentPacing_2.multiple_horde_frequency)
					var_41_4 = "multi_first_wave"
				end
			else
				self._next_horde_time = arg_41_1 + ConflictUtils.random_interval(CurrentPacing_2.horde_frequency)
				var_41_4 = "single_wave"
			end

			self._wave = var_41_4
		end

		local CurrentHordeSettings = CurrentHordeSettings

		if not var_41_5 then
			if not CurrentHordeSettings.mix_paced_hordes then
				if self.horde_spawner.num_paced_hordes % 2 == 0 then
					var_41_5 = not (math.random() < CurrentHordeSettings.chance_of_vector) or not "vector" or "ambush"
				else
					var_41_5 = self.horde_spawner.last_paced_horde_type ~= "vector" or not "ambush" or "vector"
				end
			else
				var_41_5 = not (math.random() < CurrentHordeSettings.chance_of_vector) or not "vector" or "ambush"
			end

			if not (var_41_5 ~= "vector" or not (math.random() <= CurrentHordeSettings.chance_of_vector_blob)) then
				var_41_5 = "vector_blob"
			end

			local vector_composition

			if var_41_5 == "vector" then
				vector_composition = CurrentHordeSettings.vector_composition

				if not vector_composition then
					-- Nothing
				end
			end

			if var_41_5 == "vector_blob" then
				vector_composition = CurrentHordeSettings.vector_blob_composition

				if not vector_composition then
					-- Nothing
				end
			end

			vector_composition = CurrentHordeSettings.ambush_composition

			::label_41_0::

			if not (not var_41_4 and type(vector_composition) ~= "table") then
				var_41_7 = vector_composition[math.random(#vector_composition)]

				printf("HORDE: Chosing horde wave composition %s", var_41_7)

				self._current_wave_composition = var_41_7
			end
		elseif var_41_5 == "multi_followup" then
			var_41_5 = self.horde_spawner.last_paced_horde_type
		end

		print("Time for new HOOORDE!", var_41_4)

		self._horde_ends_at = arg_41_1 + 120

		local tbl = {
			multiple_horde_count = self._multiple_horde_count,
			horde_wave = var_41_4,
			optional_wave_composition = var_41_7
		}
		local default_enemy_side_id = self.default_enemy_side_id

		print("HORDE: Spawning hordes while " .. #var_41_1.spawned .. " other ai are spawned")
		self.horde_spawner:horde(var_41_5, tbl, default_enemy_side_id, var_41_6)
	end
end

ConflictDirector.horde_killed = function (self, arg_42_1)
	-- function 42
	if not arg_42_1 then
		return
	end

	if not self._multiple_horde_count then
		local CurrentPacing = CurrentPacing

		self._next_horde_time = Managers.time:time("game") + ConflictUtils.random_interval(CurrentPacing.horde_frequency)

		print("Horde killed: ", arg_42_1)
	else
		self._next_horde_time = 0

		print("Horde killed: ", arg_42_1)
	end
end

ConflictDirector.going_to_relax_state = function (self)
	-- function 43
	self._multiple_horde_count = nil
end

ConflictDirector.get_horde_data = function (self)
	-- function 44
	return self._next_horde_time, self.horde_spawner.hordes, self._multiple_horde_count
end

ConflictDirector.get_horde_timer = function (self)
	-- function 45
	return self._next_horde_time, self.delay_horde
end

ConflictDirector.start_terror_event = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	-- function 46
	local flag = arg_46_2 or 0

	return TerrorEventMixer.add_to_start_event_list(arg_46_1, flag, arg_46_3, arg_46_4)
end

ConflictDirector.terror_event_finished = function (arg_47_0, arg_47_1)
	-- function 47
	return table.contains(TerrorEventMixer.finished_events, arg_47_1)
end

ConflictDirector.start_terror_event_from_template = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	fassert(arg_48_2 ~= nil, "Starting a terror event from template should not be done if 'spawner_id' is nil!")

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local format = string.format("%s_%s", arg_48_1, arg_48_2)

	if not TerrorEventBlueprints[get_current_level_keys][format] then
		self:start_terror_event(format, arg_48_3)

		return
	end

	local var_48_2 = TerrorEventBlueprints[get_current_level_keys][arg_48_1]

	fassert(var_48_2 ~= nil, string.format("Tried to get non-existing terror event '%s'", arg_48_1))

	local clone = table.clone(var_48_2)

	for i, v in ipairs(clone) do
		if not v.spawner_id then
			v.spawner_id = arg_48_2
		end
	end

	TerrorEventBlueprints[get_current_level_keys][format] = clone

	self:start_terror_event(format, arg_48_3)
end

ConflictDirector.handle_speed_runners = function (self, arg_49_1)
	-- function 49
	local flag = self:get_threat_value() > self.delay_specials_threat_value
	local speed_running_intervention_data = self.speed_running_intervention_data
	local speed_running_intervention = CurrentSpecialsSettings.speed_running_intervention

	speed_running_intervention = speed_running_intervention or SpecialsSettings.default.speed_running_intervention

	local pacing = self.pacing

	if not (not flag and self.specials_pacing:is_disabled() or pacing:get_state() ~= "pacing_frozen") then
		speed_running_intervention_data.started_speed_intervention_check_t = nil
		speed_running_intervention_data.player_travel_distances = nil
		speed_running_intervention_data.total_travel_distances = nil
		speed_running_intervention_data.has_traveled_far = false

		return
	end

	if not speed_running_intervention_data.started_speed_intervention_check_t then
		speed_running_intervention_data.started_speed_intervention_check_t = arg_49_1
	end

	if arg_49_1 - speed_running_intervention_data.started_speed_intervention_check_t < speed_running_intervention.required_time_spent_in_high_threat then
		return
	end

	local player_travel_distances = speed_running_intervention_data.player_travel_distances

	player_travel_distances = player_travel_distances or {}

	local total_travel_distances = speed_running_intervention_data.total_travel_distances

	total_travel_distances = total_travel_distances or {}
	speed_running_intervention_data.player_travel_distances = player_travel_distances
	speed_running_intervention_data.total_travel_distances = total_travel_distances

	local has_traveled_far = speed_running_intervention_data.has_traveled_far
	local target_speed_runner = speed_running_intervention_data.target_speed_runner

	if arg_49_1 > speed_running_intervention_data.next_travel_dist_check_t then
		speed_running_intervention_data.has_traveled_far = false

		local ahead_unit = self.main_path_info.ahead_unit
		local var_49_9 = self.main_path_player_info[ahead_unit]
		local var_49_10 = player_travel_distances[ahead_unit]

		if not var_49_9 and not var_49_10 then
			local num = var_49_9.travel_dist - var_49_10

			if num >= speed_running_intervention.travel_distance_threshold then
				speed_running_intervention_data.has_traveled_far = true
				speed_running_intervention_data.target_speed_runner = ahead_unit

				local var_49_12 = total_travel_distances[ahead_unit]

				var_49_12 = var_49_12 or 0
				total_travel_distances[ahead_unit] = var_49_12 + num
			end
		end

		for k, v in pairs(self.main_path_player_info) do
			player_travel_distances[k] = v.travel_dist
		end

		speed_running_intervention_data.next_travel_dist_check_t = arg_49_1 + speed_running_intervention.travel_distance_check_frequency
	end

	if not has_traveled_far then
		return
	end

	if not (pacing.total_intensity > CurrentPacing.peak_intensity_threshold) then
		if pacing:get_state() == "pacing_peak_fade" then
			if arg_49_1 - pacing._state_start_time < speed_running_intervention.time_required_in_pacing_peak_to_ignore_high_intensity then
				return
			end
		else
			return
		end
	end

	local get_active_respawn_units = Managers.state.game_mode:game_mode():get_active_respawn_units()

	if #get_active_respawn_units > 0 then
		local ahead_unit_2 = self.main_path_info.ahead_unit
		local travel_dist = self.main_path_player_info[ahead_unit_2].travel_dist

		for k_2 = 1, #get_active_respawn_units do
			local var_49_16 = get_active_respawn_units[k_2]
			local world_position = Unit.world_position(var_49_16, 0)
			local closest_pos_at_main_path, var_49_19 = MainPathUtils.closest_pos_at_main_path(self.main_path_info.main_paths, world_position)

			if travel_dist < var_49_19 then
				return
			end
		end
	end

	if not (speed_running_intervention.chance_of_vector_horde >= math.random()) then
		local var_49_20 = speed_running_intervention.vector_horde_breeds[math.random(1, #speed_running_intervention.vector_horde_breeds)]
		local var_49_21 = speed_running_intervention.vector_horde_config[var_49_20]
		local random = math.random(var_49_21[1], var_49_21[2])
		local tbl = {}

		for l = 1, random do
			tbl[#tbl + 1] = var_49_20
		end

		local conflict = Managers.state.conflict
		local default_enemy_side_id = self.default_enemy_side_id

		conflict.horde_spawner:execute_custom_horde(tbl, true, default_enemy_side_id)

		local delay_between_speed_running_intervention_horde_spawn = speed_running_intervention.delay_between_speed_running_intervention_horde_spawn

		self._next_speed_running_intervention_time = arg_49_1 + math.random(delay_between_speed_running_intervention_horde_spawn[1], delay_between_speed_running_intervention_horde_spawn[2])
	elseif not Unit.alive(target_speed_runner) then
		local request_speed_running_intervention, var_49_28 = self.specials_pacing:request_speed_running_intervention(arg_49_1, target_speed_runner, self.main_path_player_info)

		if not request_speed_running_intervention then
			local delay_between_speed_running_intervention_special_spawn = speed_running_intervention.delay_between_speed_running_intervention_special_spawn
			local num_2 = 1
			local var_49_31 = total_travel_distances[target_speed_runner]

			var_49_31 = var_49_31 or 0

			local total_travel_distance_scaling_thresholds = speed_running_intervention.total_travel_distance_scaling_thresholds

			for i4 = 1, #total_travel_distance_scaling_thresholds do
				local var_49_33 = total_travel_distance_scaling_thresholds[i4]

				num_2 = i4

				if var_49_31 < var_49_33 then
					break
				end
			end

			local var_49_34 = delay_between_speed_running_intervention_special_spawn[num_2]

			self._next_speed_running_intervention_time = arg_49_1 + math.random(var_49_34[1], var_49_34[2])
		else
			self._next_speed_running_intervention_time = arg_49_1 + 5
		end
	end
end

ConflictDirector.handle_alone_player = function (self, arg_50_1, arg_50_2)
	-- function 50
	local ENEMY_PLAYER_AND_BOT_UNITS = arg_50_2.ENEMY_PLAYER_AND_BOT_UNITS
	local rushing_intervention_data = self.rushing_intervention_data
	local setting = Managers.state.game_mode:setting("disable_rush_intervention")

	if not setting and not setting.all then
		rushing_intervention_data.disabled = "No rush intervention, since game mode disabled it"

		return
	end

	if #ENEMY_PLAYER_AND_BOT_UNITS == 1 then
		rushing_intervention_data.disabled = "No rush intervention, since only one player alive"

		return
	else
		rushing_intervention_data.disabled = nil
	end

	local main_path_info = self.main_path_info
	local ahead_unit = main_path_info.ahead_unit

	if not ahead_unit then
		local rush_intervention = CurrentSpecialsSettings.rush_intervention
		local get_cluster_and_loneliness, var_50_7, var_50_8, var_50_9 = self:get_cluster_and_loneliness(10, arg_50_2.ENEMY_PLAYER_AND_BOT_POSITIONS, arg_50_2.ENEMY_PLAYER_AND_BOT_UNITS)

		rushing_intervention_data.loneliness_value = var_50_8

		if not (ahead_unit == var_50_9 or #ENEMY_PLAYER_AND_BOT_UNITS ~= 2) then
			local var_50_10 = self.main_path_player_info[ahead_unit]
			local num = var_50_10.travel_dist - self._rushing_intervention_travel_dist

			rushing_intervention_data.player_travel_dist = var_50_10.travel_dist
			rushing_intervention_data.ahead_dist = num
			rushing_intervention_data.ahead_unit = ahead_unit

			if num <= 0 then
				return
			end

			if var_50_8 > rush_intervention.loneliness_value_for_special then
				print("going to make a rush intervention, since loneliness_value=", var_50_8, " and dist=", num)

				local request_rushing_intervention, var_50_13 = self.specials_pacing:request_rushing_intervention(arg_50_1, ahead_unit, main_path_info, self.main_path_player_info, setting)

				if not request_rushing_intervention then
					self.pacing:annotate_graph("Rush intervention - special", "red")

					rushing_intervention_data.message = "spawning: " .. var_50_13
				else
					rushing_intervention_data.message = var_50_13
				end

				local delay_between_interventions = rush_intervention.delay_between_interventions

				if not (not setting and setting.horde and not (var_50_8 > rush_intervention.loneliness_value_for_ambush_horde) or not (Math.random() < rush_intervention.chance_of_ambush_horde)) then
					print("rush intervention - ambush horde!")
					self.pacing:annotate_graph("Rush intervention - horde", "red")

					local ambush_composition = CurrentHordeSettings.ambush_composition
					local var_50_16

					if type(ambush_composition) == "table" then
						local var_50_17 = ambush_composition[math.random(#ambush_composition)]

						var_50_16 = {
							optional_wave_composition = var_50_17
						}
					end

					if not (script_data.ai_horde_spawning_disabled or Managers.state.game_mode:setting("horde_spawning_disabled")) then
						self.horde_spawner:execute_ambush_horde(var_50_16, self.default_enemy_side_id, false, POSITION_LOOKUP[ahead_unit])
					end

					delay_between_interventions = delay_between_interventions + 10
					request_rushing_intervention = true
				end

				if not request_rushing_intervention then
					self._next_rushing_intervention_time = arg_50_1 + delay_between_interventions
					self._rushing_intervention_travel_dist = var_50_10.travel_dist + rush_intervention.distance_until_next_intervention
				end
			end
		end
	end
end

ConflictDirector.respawn_level = function (self, arg_51_1)
	-- function 51
	self:destroy_all_units()

	if not arg_51_1 then
		Managers.state.entity:system("ai_interest_point_system"):set_seed(arg_51_1)
		self.enemy_recycler:set_seed(arg_51_1)
		self.level_analysis:set_random_seed(nil, arg_51_1)
		self.spawn_zone_baker:set_seed(arg_51_1)
		TerrorEventUtils.set_seed(arg_51_1)
	else
		self.level_analysis:set_random_seed(nil, self.level_analysis.seed)
		self.spawn_zone_baker:set_seed(self.spawn_zone_baker.seed)
		TerrorEventUtils.set_seed(self.level_analysis.seed)
	end

	local var_51_0
	local var_51_1

	self._spawn_pos_list, self._pack_sizes, self._pack_rotations, var_51_1, self._zone_data_list = self:generate_spawns()

	self.enemy_recycler:setup(self._spawn_pos_list, self._pack_sizes, self._pack_rotations, var_51_1, self._zone_data_list)
	self.level_analysis:remove_crossroads_extra_path_branches()
	self.level_analysis:generate_boss_paths()
	self.level_analysis:reset_debug()

	self.main_path_info.main_paths = self.level_analysis:get_main_paths()

	self.spawn_zone_baker:draw_pack_density_graph()
end

ConflictDirector.create_debug_list = function (self)
	-- function 52
	self._debug_list = {
		"none",
		self.pacing,
		self.spawn_zone_baker
	}
end

ConflictDirector.update_mini_patrol = function (self, arg_53_1, arg_53_2)
	-- function 53
	local pacing = self.pacing
	local mini_patrol = CurrentPacing.mini_patrol
	local _next_mini_patrol_timer = self._next_mini_patrol_timer

	if self._mini_patrol_state == "spawning" then
		if _next_mini_patrol_timer < arg_53_1 then
			self._mini_patrol_state = "running"
			self._next_mini_patrol_timer = arg_53_1 + mini_patrol.override_timer
		end
	elseif self._mini_patrol_state == "running" then
		local num_spawned_by_breed = self._conflict_data_by_side[self.default_enemy_side_id].num_spawned_by_breed

		if not (not (num_spawned_by_breed.skaven_clan_rat < 3) or not (num_spawned_by_breed.skaven_storm_vermin <= 1) or not (_next_mini_patrol_timer < arg_53_1)) then
			self._mini_patrol_state = "waiting"
			self._next_mini_patrol_timer = arg_53_1 + ConflictUtils.random_interval(mini_patrol.frequency)
		end
	elseif _next_mini_patrol_timer < arg_53_1 then
		local var_53_4 = self._conflict_data_by_side[self.default_enemy_side_id]

		if not (not (pacing.total_intensity <= mini_patrol.only_spawn_below_intensity) or not (pacing.total_intensity >= mini_patrol.only_spawn_above_intensity) or not (RecycleSettings.max_grunts - #var_53_4.spawned >= 0) or not self.delay_mini_patrol) then
			self._next_mini_patrol_timer = arg_53_1 + 5

			local mini_patrol_composition = CurrentHordeSettings.mini_patrol_composition

			print("spawning mini patrol")

			local tbl = {
				size = 0,
				template = "mini_patrol",
				id = Managers.state.entity:system("ai_group_system"):generate_group_id()
			}
			local default_enemy_side_id = self.default_enemy_side_id

			self:mini_patrol(arg_53_1, nil, default_enemy_side_id, mini_patrol_composition, tbl)

			self._mini_patrol_state = "spawning"
		else
			self._next_mini_patrol_timer = arg_53_1 + 2
		end
	end

	if not script_data.debug_mini_patrols then
		Debug.text("Mini patrol: active=%s, timer=%.1f last=[%s]", tostring(self._mini_patrol_state), self._next_mini_patrol_timer - arg_53_1, tostring(self._last_mini_patrol_composition))
	end
end

ConflictDirector.reset_data = function (self)
	-- function 54
	self._cluster_and_loneliness = FrameTable.alloc_table()
end

ConflictDirector.update = function (self, arg_55_1, arg_55_2)
	-- function 55
	self._time = arg_55_2

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end

	local tbl = {}
	local sides_to_update_recycler = self.sides_to_update_recycler

	for i = 1, #sides_to_update_recycler do
		table.append(tbl, sides_to_update_recycler[i].PLAYER_AND_BOT_POSITIONS)
	end

	if not self.level_analysis then
		self.level_analysis:update(arg_55_2, arg_55_1)

		if not self._hero_side then
			self:update_main_path_player_info(self._hero_side, arg_55_2)
		end
	end

	if not self.disabled then
		return
	end

	local var_55_2 = script_data

	self:check_updated_settings()

	local CurrentConflictSettings = CurrentConflictSettings

	if not CurrentConflictSettings.disabled then
		return
	end

	if arg_55_2 > self._next_threat_update then
		self:calculate_threat_value()
		self:check_pacing_event_delay()

		self._next_threat_update = arg_55_2 + 1
	end

	local pacing = self.pacing

	if not (var_55_2.ai_pacing_disabled or CurrentConflictSettings.pacing.disabled) then
		if arg_55_2 > self._next_pacing_update then
			local _hero_side = self._hero_side

			if not _hero_side then
				local PLAYER_AND_BOT_UNITS = _hero_side.PLAYER_AND_BOT_UNITS

				pacing:update(arg_55_2, arg_55_1, PLAYER_AND_BOT_UNITS)

				self._next_pacing_update = arg_55_2 + 1

				if pacing:get_state() ~= "pacing_relax" or not self:are_players_rushing(arg_55_2) then
					if not CurrentPacing.leave_relax_if_rushing then
						print("players are progressing too fast, leave relax")
						pacing:advance_pacing(arg_55_2, "players are rushing")
					end

					if not CurrentPacing.horde_in_relax_if_rushing then
						print("players are progressing too fast, punish with a horde")

						self._next_horde_time = arg_55_2
					end
				end
			end
		end

		if not (var_55_2.ai_rush_intervention_disabled or not (arg_55_2 > self._next_rushing_intervention_time)) then
			self._next_rushing_intervention_time = arg_55_2 + 1

			self:handle_alone_player(arg_55_2, self._enemy_side)
		end

		local speed_running_intervention = CurrentSpecialsSettings.speed_running_intervention

		speed_running_intervention = speed_running_intervention or SpecialsSettings.default.speed_running_intervention

		if not (speed_running_intervention.disabled or var_55_2.ai_speed_running_intervention_disabled or not (arg_55_2 > self._next_speed_running_intervention_time)) then
			self._next_speed_running_intervention_time = arg_55_2 + 2.5

			self:handle_speed_runners(arg_55_2)
		end
	end

	if not self.in_safe_zone then
		if not Managers.state.game_mode:is_round_started() then
			print("Players are leaving the safe zone")

			self.in_safe_zone = false

			Managers.state.game_mode:players_left_safe_zone()

			if not self.specials_pacing then
				self.specials_pacing:start(arg_55_2)

				if not var_55_2.ai_pacing_disabled then
					local CurrentPacing = CurrentPacing

					self._next_horde_time = arg_55_2 + ConflictUtils.random_interval(CurrentPacing.horde_startup_time)
				end
			end
		end
	else
		if not (CurrentConflictSettings.specials.disabled or not self.specials_pacing and var_55_2.ai_specials_spawning_disabled or Managers.state.game_mode:setting("ai_specials_spawning_disabled")) then
			local specials_population = pacing:specials_population()

			self.specials_pacing:update(arg_55_2, self._alive_specials, specials_population, tbl)
		end

		if not (var_55_2.ai_horde_spawning_disabled or CurrentConflictSettings.horde.disabled or Managers.state.game_mode:setting("horde_spawning_disabled")) then
			self:update_horde_pacing(arg_55_2, arg_55_1)
		else
			local CurrentPacing_2 = CurrentPacing

			self._next_horde_time = arg_55_2 + ConflictUtils.random_interval(CurrentPacing_2.horde_frequency)
		end

		if not ((var_55_2.ai_mini_patrol_disabled or not self.level_settings.use_mini_patrols) and pacing.pacing_state ~= "pacing_build_up") then
			self:update_mini_patrol(arg_55_2, arg_55_1)
		end

		if not self.horde_spawner then
			self.horde_spawner:update(arg_55_2, arg_55_1)
		end
	end

	if not USE_ENGINE_SLOID_SYSTEM then
		local debug_unit = var_55_2.debug_unit

		debug_unit = not debug_unit and ScriptUnit.has_extension(var_55_2.debug_unit, "ai_slot_system")

		local flag_2 = not debug_unit and debug_unit.sloid_id
		local local_player = Managers.player:local_player(1)
		local camera_rotation = Managers.state.camera:camera_rotation(local_player.viewport_name)
		local var_55_15 = Vector3(0, 0, 0)
		local from_quaternion_position = Matrix4x4.from_quaternion_position(camera_rotation, var_55_15)
		local sloid_system_update = EngineOptimized.sloid_system_update
		local var_55_18 = arg_55_2
		local var_55_19 = arg_55_1
		local infighting_draw_mode = var_55_2.infighting_draw_mode

		infighting_draw_mode = infighting_draw_mode or -1

		sloid_system_update(var_55_18, var_55_19, infighting_draw_mode, var_55_2.debug_unit, flag_2, from_quaternion_position)
		Gathering.write_dogpiled_attackers(nil, self.dogpiled_attackers_on_unit)
	else
		self.gathering:update(arg_55_2, arg_55_1)
	end

	if not self.director_is_ai_ready then
		local system = Managers.state.entity:system("ai_system")
		local update = TerrorEventMixer.update
		local var_55_23 = arg_55_2
		local var_55_24 = arg_55_1
		local ai_debugger = system.ai_debugger

		ai_debugger = not ai_debugger and system.ai_debugger.screen_gui

		update(var_55_23, var_55_24, ai_debugger)
	elseif (flag or not self.navigation_group_manager.form_groups_running) and not self.navigation_group_manager:form_groups_update() then
		local get_level_seed = Managers.mechanism:get_level_seed()

		self:ai_nav_groups_ready(get_level_seed)
	end

	local var_55_27 = tbl

	if not (not self.enemy_recycler and var_55_2.ai_roaming_spawning_disabled or CurrentConflictSettings.roaming.disabled) then
		local threat_population = pacing:threat_population()
		local var_55_29 = self._conflict_data_by_side[self.default_enemy_side_id]

		if RecycleSettings.max_grunts - #var_55_29.spawned <= 0 then
			threat_population = 0
		end

		local operational = self.navigation_group_manager.operational

		if not var_55_2.recycler_in_freeflight then
			if not var_55_2.recycler_in_cutscene then
				local local_player_2 = Managers.player:local_player(1)
				local camera_position = Managers.state.camera:camera_position(local_player_2.viewport_name)

				if not camera_position then
					var_55_27 = not self._recycler_extra_pos and {
						camera_position,
						self._recycler_extra_pos:unbox()
					} and {
						camera_position
					}
					operational = false
				end
			else
				local get_free_flight_pos = self:get_free_flight_pos()

				if not get_free_flight_pos then
					var_55_27 = not self._recycler_extra_pos and {
						get_free_flight_pos,
						self._recycler_extra_pos:unbox()
					} and {
						get_free_flight_pos
					}
					operational = false
				end
			end

			if not (not self._recycler_extra_pos and not (arg_55_2 > self._recycler_extra_end_time)) then
				self._recycler_extra_pos = nil
			end
		end

		self:update_player_areas(sides_to_update_recycler)
		self.enemy_recycler:update(arg_55_2, arg_55_1, var_55_27, threat_population, self._player_areas, operational)
	end

	if not self.in_safe_zone then
		self.enemy_recycler:update_main_path_events(arg_55_2)
	end

	self:update_spawn_queue(arg_55_2)

	if not (not self.enemy_recycler and var_55_2.ai_far_off_despawn_disabled) then
		local var_55_34 = self._conflict_data_by_side[self.default_enemy_side_id]

		self.enemy_recycler:far_off_despawn(arg_55_2, arg_55_1, var_55_27, var_55_34.spawned)
	end

	if not self._spline_groups_to_spawn then
		for k, v in pairs(self._spline_groups_to_spawn) do
			local spline_ready = Managers.state.entity:system("ai_group_system"):spline_ready(k)

			if not spline_ready then
				if spline_ready == "failed" or not spline_ready.failed then
					print("spline is in fail state, cancelling the spline spawn.", k)

					self._spline_groups_to_spawn[k] = nil
				else
					self:_spawn_spline_group(v, spline_ready)

					self._spline_groups_to_spawn[k] = nil
				end
			end
		end
	end

	local _peak_delayer = self._peak_delayer

	if not _peak_delayer then
		local var_55_37
		local main_path_info = self.main_path_info

		if not main_path_info.ahead_unit then
			return
		end

		local travel_dist = self.main_path_player_info[main_path_info.ahead_unit].travel_dist

		_peak_delayer:update(travel_dist, arg_55_2)
	end
end

ConflictDirector.pre_update = function (self)
	-- function 56
	if not (not self.breed_freezer and script_data.disable_breed_freeze_opt) then
		self.breed_freezer:commit_freezes()
	end
end

ConflictDirector.post_update = function (self)
	-- function 57
	if not (not self.breed_freezer and script_data.disable_breed_freeze_opt) then
		self.breed_freezer:commit_freezes()
	end
end

ConflictDirector.set_recycler_extra_pos = function (self, arg_58_1, arg_58_2)
	-- function 58
	self._recycler_extra_pos = arg_58_1
	self._recycler_extra_end_time = arg_58_2
end

ConflictDirector.get_free_flight_pos = function (arg_59_0)
	-- function 59
	local var_59_0
	local global = Managers.free_flight.data.global

	if not global.viewport_world_name then
		local world = Managers.world:world(global.viewport_world_name)
		local global_free_flight_viewport = ScriptWorld.global_free_flight_viewport(world)
		local frustum_freeze_camera = global.frustum_freeze_camera

		frustum_freeze_camera = frustum_freeze_camera or ScriptViewport.camera(global_free_flight_viewport)
		var_59_0 = ScriptCamera.position(frustum_freeze_camera)
	end

	return var_59_0
end

ConflictDirector.spawn_queued_unit = function (self, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5, arg_60_6, arg_60_7, arg_60_8, arg_60_9)
	-- function 60
	arg_60_7 = arg_60_7 or {}

	local side_id = arg_60_7.side_id

	side_id = side_id or self.default_enemy_side_id
	arg_60_7.side_id = side_id

	local enemy_package_loader = self.enemy_package_loader

	if not enemy_package_loader:is_breed_processed(arg_60_1.name) then
		local flag = not arg_60_7 and arg_60_7.ignore_breed_limits
		local request_breed, var_60_4 = enemy_package_loader:request_breed(arg_60_1.name, flag, arg_60_4)

		if not request_breed then
			printf("[ConflictDirector] Replacing wanted breed (%s) with %s", arg_60_1.name, var_60_4 or "nil")

			arg_60_1 = Breeds[var_60_4]
		end
	end

	local spawn_queue = self.spawn_queue
	local num = self.first_spawn_index + self.spawn_queue_size

	self.spawn_queue_size = self.spawn_queue_size + 1
	self.spawn_queue_id = self.spawn_queue_id + 1

	local var_60_7 = spawn_queue[num]

	fassert(arg_60_1, "no supplied breed")

	if not var_60_7 then
		var_60_7[1] = arg_60_1
		var_60_7[2] = arg_60_2
		var_60_7[3] = arg_60_3
		var_60_7[4] = arg_60_4
		var_60_7[5] = arg_60_5
		var_60_7[6] = arg_60_6
		var_60_7[7] = arg_60_7
		var_60_7[8] = arg_60_8
		var_60_7[9] = arg_60_9
		var_60_7[10] = self.spawn_queue_id
	else
		spawn_queue[num] = {
			arg_60_1,
			arg_60_2,
			arg_60_3,
			arg_60_4,
			arg_60_5,
			arg_60_6,
			arg_60_7,
			arg_60_8,
			arg_60_9,
			self.spawn_queue_id
		}
	end

	local name = arg_60_1.name

	self.num_queued_spawn_by_breed[name] = self.num_queued_spawn_by_breed[name] + 1

	return self.spawn_queue_id
end

ConflictDirector.get_spawned_unit = function (self, arg_61_1)
	-- function 61
	return self._spawn_queue_id_lut[arg_61_1]
end

ConflictDirector._get_spawned_unit_id = function (self, arg_62_1)
	-- function 62
	return self._spawn_queue_id_lut[arg_62_1]
end

ConflictDirector.remove_queued_unit = function (self, arg_63_1)
	-- function 63
	local spawn_queue = self.spawn_queue
	local first_spawn_index = self.first_spawn_index
	local spawn_queue_size = self.spawn_queue_size
	local first_spawn_index_2 = self.first_spawn_index
	local num = first_spawn_index_2 + spawn_queue_size - 1

	for i = first_spawn_index_2, num do
		local var_63_5 = spawn_queue[i]

		fassert(var_63_5, "Missing spawn_queue item")

		if var_63_5[10] == arg_63_1 then
			local var_63_6 = var_63_5[1]

			self.num_queued_spawn_by_breed[var_63_6.name] = self.num_queued_spawn_by_breed[var_63_6.name] - 1
			spawn_queue[num], spawn_queue[i] = spawn_queue[i], spawn_queue[num]
			self.spawn_queue_size = self.spawn_queue_size - 1

			if self.spawn_queue_size == 0 then
				self.first_spawn_index = 1
			end

			return var_63_5
		end
	end

	ferror("Spawn_queue id not found %s", tostring(arg_63_1))
end

ConflictDirector.update_spawn_queue = function (self, arg_64_1)
	-- function 64
	if self.spawn_queue_size == 0 then
		return
	end

	local first_spawn_index = self.first_spawn_index
	local spawn_queue = self.spawn_queue
	local var_64_2 = spawn_queue[first_spawn_index]
	local var_64_3 = var_64_2[1]
	local name = var_64_3.name
	local enemy_package_loader = self.enemy_package_loader

	while not enemy_package_loader:is_breed_loaded_on_all_peers(name) do
		first_spawn_index = first_spawn_index + 1

		if first_spawn_index == self.first_spawn_index + self.spawn_queue_size then
			return
		end

		var_64_2 = spawn_queue[first_spawn_index]
		var_64_3 = var_64_2[1]
		name = var_64_3.name
	end

	local breed_freezer

	if not script_data.disable_breed_freeze_opt then
		breed_freezer = self.breed_freezer

		if not breed_freezer then
			breed_freezer = self.breed_freezer:try_unfreeze_breed(var_64_3, var_64_2)
		end
	else
		breed_freezer = false
	end

	if false then
		breed_freezer = true
	end

	if not breed_freezer then
		local breed = BLACKBOARDS[breed_freezer].breed
		local go_id = Managers.state.unit_storage:go_id(breed_freezer)

		self:_post_spawn_unit(breed_freezer, go_id, breed, var_64_2[2]:unbox(), var_64_2[4], var_64_2[5], var_64_2[7], var_64_2[6], var_64_2[10])
	else
		breed_freezer = self:_spawn_unit(var_64_2[1], var_64_2[2]:unbox(), var_64_2[3]:unbox(), var_64_2[4], var_64_2[5], var_64_2[6], var_64_2[7], var_64_2[8], var_64_2[10])
	end

	self.num_queued_spawn_by_breed[name] = self.num_queued_spawn_by_breed[name] - 1

	local var_64_9 = var_64_2[9]

	if not var_64_9 then
		var_64_9[1] = breed_freezer
	end

	if first_spawn_index ~= self.first_spawn_index then
		local var_64_10 = self.spawn_queue[first_spawn_index]

		self.spawn_queue[first_spawn_index] = self.spawn_queue[self.first_spawn_index]
		self.spawn_queue[self.first_spawn_index] = var_64_10
	end

	self.spawn_queue_size = self.spawn_queue_size - 1
	self.first_spawn_index = self.first_spawn_index + 1

	if self.spawn_queue_size == 0 then
		self.first_spawn_index = 1
	end
end

ConflictDirector.spawn_unit_immediate = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8)
	-- function 65
	self.spawn_queue_id = self.spawn_queue_id + 1

	local _spawn_unit, var_65_1 = self:_spawn_unit(arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, self.spawn_queue_id)

	return _spawn_unit, var_65_1
end

local tbl_2 = {
	faction = "enemy"
}

ConflictDirector._spawn_unit = function (self, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8, arg_66_9)
	-- function 66
	local opt_base_unit

	if not script_data.use_optimized_breed_units then
		opt_base_unit = arg_66_1.opt_base_unit

		if not opt_base_unit then
			-- Nothing
		end
	end

	opt_base_unit = arg_66_1.base_unit

	::label_66_0::

	local flag = type(opt_base_unit) ~= "string" or not opt_base_unit or opt_base_unit[Math.random(#opt_base_unit)]
	local unit_template = arg_66_1.unit_template
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	arg_66_7.spawn_queue_index = arg_66_9

	local var_66_4

	if not arg_66_1.has_inventory then
		local opt_default_inventory_template

		if not script_data.use_optimized_breed_units then
			opt_default_inventory_template = arg_66_1.opt_default_inventory_template

			if not opt_default_inventory_template then
				-- Nothing
			end
		end

		opt_default_inventory_template = arg_66_1.default_inventory_template

		::label_66_1::

		local flag_2 = type(opt_default_inventory_template) ~= "string" or not opt_default_inventory_template or opt_default_inventory_template[Math.random(#opt_default_inventory_template)]

		var_66_4 = {
			optional_spawn_data = arg_66_7,
			inventory_template = flag_2,
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

	tbl_2.breed_name = arg_66_1.name

	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local max_health = arg_66_1.max_health

	max_health = not max_health and arg_66_1.max_health[get_difficulty_rank]

	if not max_health then
		local max_health_modifier = arg_66_7.max_health_modifier

		max_health_modifier = max_health_modifier or 1
		max_health = max_health * max_health_modifier
	end

	local side_id = arg_66_7.side_id
	local tbl = {
		health_system = {
			health = max_health,
			optional_data = arg_66_7,
			breed = arg_66_1
		},
		ai_system = {
			size_variation = 1,
			size_variation_normalized = 1,
			breed = arg_66_1,
			nav_world = nav_world,
			spawn_type = arg_66_6,
			spawn_category = arg_66_4,
			optional_spawn_data = arg_66_7,
			side_id = side_id
		},
		locomotion_system = {
			nav_world = nav_world,
			breed = arg_66_1
		},
		ai_navigation_system = {
			nav_world = nav_world
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
		dialogue_system = tbl_2,
		aim_system = var_66_7,
		proximity_system = {
			breed = arg_66_1
		},
		buff_system = {
			breed = arg_66_1
		},
		animation_movement_system = var_66_8
	}

	if not arg_66_7.prepare_func then
		arg_66_7.prepare_func(arg_66_1, tbl, arg_66_7, arg_66_2, arg_66_3)
	end

	Managers.state.game_mode:pre_ai_spawned(arg_66_1, arg_66_7)

	local from_quaternion_position = Matrix4x4.from_quaternion_position(arg_66_3, arg_66_2)
	local size_variation_range = arg_66_7.size_variation_range

	size_variation_range = size_variation_range or arg_66_1.size_variation_range

	if not size_variation_range then
		local random = Math.random()
		local lerp = math.lerp(size_variation_range[1], size_variation_range[2], random)

		tbl.ai_system.size_variation = lerp
		tbl.ai_system.size_variation_normalized = random

		Matrix4x4.set_scale(from_quaternion_position, Vector3(lerp, lerp, lerp))
	end

	local spawn_network_unit, var_66_19 = Managers.state.unit_spawner:spawn_network_unit(flag, unit_template, tbl, from_quaternion_position)

	self:_post_spawn_unit(spawn_network_unit, var_66_19, arg_66_1, arg_66_2, arg_66_4, arg_66_5, arg_66_7, arg_66_6, arg_66_9)

	return spawn_network_unit, var_66_19
end

ConflictDirector._post_spawn_unit = function (self, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6, arg_67_7, arg_67_8, arg_67_9)
	-- function 67
	self._spawn_queue_id_lut[arg_67_9] = arg_67_1
	self._spawn_queue_id_lut[arg_67_1] = arg_67_9
	arg_67_7 = arg_67_7 or {}

	Managers.state.game_mode:post_ai_spawned(arg_67_1, arg_67_3, arg_67_7)

	local var_67_0 = BLACKBOARDS[arg_67_1]

	var_67_0.enemy_id = arg_67_7.spawn_queue_index

	if not arg_67_7.enhancements then
		TerrorEventUtils.apply_breed_enhancements(arg_67_1, arg_67_3, arg_67_7)
	end

	local name = arg_67_3.name

	Unit.set_data(arg_67_1, "spawn_type", arg_67_8)

	local climate_type = self.level_settings.climate_type

	climate_type = climate_type or "default"

	Unit.set_flow_variable(arg_67_1, "climate_type", climate_type)
	Unit.flow_event(arg_67_1, "climate_type_set")

	if not arg_67_7.enhancements then
		Managers.telemetry_events:ai_spawned(var_67_0.enemy_id, arg_67_3.name, arg_67_4, arg_67_7.enhancements)
	end

	var_67_0.spawn_animation = arg_67_6
	var_67_0.optional_spawn_data = arg_67_7

	local side_id = arg_67_7.side_id

	side_id = side_id or Managers.state.side.side_by_unit[arg_67_1].side_id

	local var_67_4 = self._conflict_data_by_side[side_id]
	local spawned = var_67_4.spawned
	local spawned_lookup = var_67_4.spawned_lookup
	local num = var_67_4.num_spawned_ai + 1

	var_67_4.num_spawned_ai = num
	spawned[num] = arg_67_1
	spawned_lookup[arg_67_1] = num
	self._num_spawned_ai = self._num_spawned_ai + 1
	self._all_spawned_units[self._num_spawned_ai] = arg_67_1
	self._all_spawned_units_lookup[arg_67_1] = self._num_spawned_ai
	self.num_spawned_by_breed[name] = self.num_spawned_by_breed[name] + 1

	local num_spawned_by_breed = var_67_4.num_spawned_by_breed
	local num_spawned_by_breed_max = var_67_4.num_spawned_by_breed_max
	local spawned_units_by_breed = var_67_4.spawned_units_by_breed

	num_spawned_by_breed[name] = num_spawned_by_breed[name] + 1
	spawned_units_by_breed[name][arg_67_1] = arg_67_1

	if arg_67_7.ignore_event_counter or not self.running_master_event then
		var_67_0.master_event_id = self._master_event_id
		var_67_4.num_spawned_ai_event = var_67_4.num_spawned_ai_event + 1
		var_67_4.num_spawned_by_breed_during_event[name] = var_67_4.num_spawned_by_breed_during_event[name] + 1
	else
		var_67_0.master_event_id = nil
	end

	Managers.state.event:trigger("ai_unit_spawned", arg_67_1, name, side_id, var_67_0.master_event_id)

	if not arg_67_3.spawn_stinger then
		local wwise_world = Managers.world:wwise_world(self._world)
		local trigger_event, var_67_13 = WwiseWorld.trigger_event(wwise_world, arg_67_3.spawn_stinger)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_event", NetworkLookup.sound_events[arg_67_3.spawn_stinger])
	end

	local locomotion_extension = var_67_0.locomotion_extension

	if not locomotion_extension then
		locomotion_extension:ready(arg_67_2, var_67_0)
	end

	if not arg_67_7.spawned_func then
		arg_67_7.spawned_func(arg_67_1, arg_67_3, arg_67_7)
	end

	if not USE_ENGINE_SLOID_SYSTEM then
		EngineOptimized.add_static_unit_data(arg_67_1, 2.2, arg_67_7.side_id)
	end

	if not arg_67_3.boss then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_new_spawn_monster")

		if not arg_67_7.force_boss_health_ui then
			Managers.state.event:trigger("force_add_boss_health_ui", arg_67_1)
		end
	end

	Unit.flow_event(arg_67_1, "lua_ai_unit_spawned")
end

ConflictDirector.set_disabled = function (self, arg_68_1)
	-- function 68
	self.disabled = arg_68_1
end

ConflictDirector.spawned_units_by_side = function (self, arg_69_1)
	-- function 69
	return self._conflict_data_by_side[arg_69_1].spawned
end

ConflictDirector.spawned_enemies = function (self)
	-- function 70
	return self._conflict_data_by_side[self.default_enemy_side_id].spawned
end

ConflictDirector.count_units_by_breed = function (self, arg_71_1, arg_71_2)
	-- function 71
	arg_71_2 = arg_71_2 or self.default_enemy_side_id

	return self._conflict_data_by_side[arg_71_2].num_spawned_by_breed[arg_71_1]
end

ConflictDirector.spawned_units_by_breed = function (self, arg_72_1, arg_72_2)
	-- function 72
	arg_72_2 = arg_72_2 or self.default_enemy_side_id

	return self._conflict_data_by_side[arg_72_2].spawned_units_by_breed[arg_72_1]
end

ConflictDirector.spawned_units_by_breed_table = function (self, arg_73_1)
	-- function 73
	arg_73_1 = arg_73_1 or self.default_enemy_side_id

	return self._conflict_data_by_side[arg_73_1].spawned_units_by_breed
end

ConflictDirector.count_units_by_breed_during_event = function (self, arg_74_1, arg_74_2)
	-- function 74
	arg_74_2 = arg_74_2 or self.default_enemy_side_id

	local var_74_0 = self._conflict_data_by_side[arg_74_2].num_spawned_by_breed_during_event[arg_74_1]

	var_74_0 = var_74_0 or 0

	return var_74_0
end

ConflictDirector.all_spawned_units = function (self)
	-- function 75
	return self._all_spawned_units, self._num_spawned_ai
end

ConflictDirector.total_num_ai_spawned = function (self)
	-- function 76
	return self._num_spawned_ai
end

ConflictDirector.add_unit_to_bosses = function (arg_77_0, arg_77_1)
	-- function 77
	arg_77_0._alive_bosses[#arg_77_0._alive_bosses + 1] = arg_77_1
end

ConflictDirector.remove_unit_from_bosses = function (self, arg_78_1)
	-- function 78
	fn_2(self._alive_bosses, arg_78_1)
end

ConflictDirector.add_unit_to_standards = function (arg_79_0, arg_79_1)
	-- function 79
	arg_79_0._alive_standards[#arg_79_0._alive_standards + 1] = arg_79_1
end

ConflictDirector.remove_unit_from_standards = function (self, arg_80_1)
	-- function 80
	fn_2(self._alive_standards, arg_80_1)
end

ConflictDirector._remove_unit_from_spawned = function (self, arg_81_1, arg_81_2, arg_81_3)
	-- function 81
	local var_81_0 = Managers.state.side.side_by_unit[arg_81_1]

	if not var_81_0 then
		return
	end

	local side_id = var_81_0.side_id
	local var_81_2 = self._conflict_data_by_side[side_id]
	local spawned_lookup = var_81_2.spawned_lookup
	local var_81_4 = spawned_lookup[arg_81_1]

	if not var_81_4 then
		return
	end

	local var_81_5 = self._spawn_queue_id_lut[arg_81_1]

	if not var_81_5 then
		self._spawn_queue_id_lut[arg_81_1] = nil
		self._spawn_queue_id_lut[var_81_5] = nil
	end

	local breed = arg_81_2.breed
	local spawn_type = arg_81_2.spawn_type

	if not (spawn_type == "horde" or spawn_type ~= "horde_hidden") then
		self:add_horde(-1)
	end

	if spawn_type == "roam" then
		local var_81_8 = BREED_DIE_LOOKUP[arg_81_1]

		if not var_81_8 then
			var_81_8[1](arg_81_1, var_81_8[2])

			BREED_DIE_LOOKUP[arg_81_1] = nil
		end
	end

	local spawned = var_81_2.spawned
	local count = #spawned
	local var_81_11 = spawned[count]

	table.swap_delete(spawned, var_81_4)

	spawned_lookup[arg_81_1] = nil

	if var_81_4 ~= count then
		spawned_lookup[var_81_11] = var_81_4
	end

	local _all_spawned_units = self._all_spawned_units
	local _all_spawned_units_lookup = self._all_spawned_units_lookup
	local var_81_14 = _all_spawned_units_lookup[arg_81_1]
	local _num_spawned_ai = self._num_spawned_ai
	local var_81_16 = _all_spawned_units[_num_spawned_ai]

	table.swap_delete(_all_spawned_units, var_81_14)

	_all_spawned_units_lookup[arg_81_1] = nil

	if var_81_14 ~= _num_spawned_ai then
		_all_spawned_units_lookup[var_81_16] = var_81_14
	end

	self._num_spawned_ai = self._num_spawned_ai - 1

	if not arg_81_2.optional_spawn_data and not arg_81_2.optional_spawn_data.despawned_func then
		arg_81_2.optional_spawn_data.despawned_func(arg_81_1, breed, arg_81_2.optional_spawn_data)
	end

	local name = breed.name

	self.num_spawned_by_breed[name] = self.num_spawned_by_breed[name] - 1
	var_81_2.num_spawned_by_breed[name] = var_81_2.num_spawned_by_breed[name] - 1
	var_81_2.spawned_units_by_breed[name][arg_81_1] = nil
	var_81_2.num_spawned_ai = var_81_2.num_spawned_ai - 1

	if not (not arg_81_2.master_event_id and arg_81_2.master_event_id ~= self._master_event_id) then
		var_81_2.num_spawned_by_breed_during_event[name] = var_81_2.num_spawned_by_breed_during_event[name] - 1
		var_81_2.num_spawned_ai_event = var_81_2.num_spawned_ai_event - 1
	end

	if not breed.special then
		fn_2(self._alive_specials, arg_81_1)
	end

	if not breed.boss then
		fn_2(self._alive_bosses, arg_81_1)
	end

	if not USE_ENGINE_SLOID_SYSTEM then
		EngineOptimized.remove_static_unit_data(arg_81_1)
	end

	if not arg_81_3 then
		Managers.state.event:trigger("ai_unit_despawned", arg_81_1, name, side_id, arg_81_2.master_event_id)
	end
end

local tbl_3 = {}

for k, v in pairs(Breeds) do
	local override_threat_value = override_threat_value

	if not override_threat_value then
		override_threat_value = v.threat_value
		override_threat_value = override_threat_value or 0
	end

	tbl_3[k] = override_threat_value

	if not v.threat_value then
		ferror("missing threat in breed %s", k)
	end
end

ConflictDirector.get_threat_value = function (self)
	-- function 82
	return self.threat_value, self.num_aggroed
end

ConflictDirector.get_num_aggroed_enemies = function (self)
	-- function 83
	return self.num_aggroed
end

ConflictDirector.set_threat_value = function (arg_84_0, arg_84_1, arg_84_2)
	-- function 84
	tbl_3[arg_84_1] = arg_84_2
end

ConflictDirector.calculate_threat_value = function (self)
	-- function 85
	local num = 0
	local num_2 = 0
	local activated_per_breed = Managers.state.performance:activated_per_breed()

	for k, v in pairs(activated_per_breed) do
		num = num + tbl_3[k] * v
		num_2 = num_2 + v
	end

	self.delay_horde = num > self.delay_horde_threat_value
	self.delay_mini_patrol = num > self.delay_mini_patrol_threat_value
	self.delay_specials = num > self.delay_specials_threat_value
	self.threat_value = num
	self.num_aggroed = num_2
end

ConflictDirector.check_pacing_event_delay = function (self)
	-- function 86
	if not self.event_delay then
		self.delay_horde = true
		self.delay_mini_patrol = true
		self.delay_specials = true
	end
end

local SOURCE_ATTACKER_UNIT = DamageDataIndex.SOURCE_ATTACKER_UNIT

ConflictDirector.register_unit_killed = function (self, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
	-- function 87
	self:_remove_unit_from_spawned(arg_87_1, arg_87_2)

	local _hero_side = self._hero_side
	local side = arg_87_2.side

	if not Managers.state.side:is_enemy_by_side(_hero_side, side) then
		local PLAYER_AND_BOT_UNITS = _hero_side.PLAYER_AND_BOT_UNITS

		self.pacing:enemy_killed(arg_87_1, PLAYER_AND_BOT_UNITS)
	end

	local name = arg_87_2.breed.name
	local var_87_4 = POSITION_LOOKUP[arg_87_1]
	local var_87_5
	local get_attributes = Managers.state.entity:system("ai_system"):get_attributes(arg_87_1)
	local breed_enhancements

	if not get_attributes.grudge_marked then
		breed_enhancements = get_attributes.breed_enhancements

		if not breed_enhancements then
			-- Nothing
		end
	end

	breed_enhancements = nil

	::label_87_0::

	if not breed_enhancements then
		Managers.telemetry_events:ai_died(arg_87_2.enemy_id, name, var_87_4)
	end

	Managers.state.event:trigger("on_unit_killed", arg_87_1, arg_87_3, arg_87_4)
end

ConflictDirector.register_unit_destroyed = function (self, arg_88_1, arg_88_2, arg_88_3)
	-- function 88
	local breed = arg_88_2.breed
	local name = breed.name
	local var_88_2 = POSITION_LOOKUP[arg_88_1]

	Managers.telemetry_events:ai_despawned(name, var_88_2, arg_88_3)
	Managers.state.event:trigger_referenced(arg_88_1, "on_ai_unit_destroyed")

	if not breed.run_on_despawn then
		breed.run_on_despawn(arg_88_1, arg_88_2)
	end

	if not ((script_data.disable_breed_freeze_opt or not self.breed_freezer) and self.breed_freezer:try_mark_unit_for_freeze(breed, arg_88_1)) then
		Managers.state.unit_spawner:mark_for_deletion(arg_88_1)
	end

	arg_88_2.about_to_be_destroyed = true
end

ConflictDirector.event_delay_pacing = function (self, arg_89_1)
	-- function 89
	self.event_delay = arg_89_1

	if not arg_89_1 then
		local time = Managers.time:time("game")

		self.specials_pacing:delay_spawning(time, 10, 15)
	end
end

ConflictDirector.destroy_unit = function (self, arg_90_1, arg_90_2, arg_90_3)
	-- function 90
	if not ALIVE[arg_90_1] then
		Managers.state.event:trigger("on_ai_unit_destroyed", arg_90_1, arg_90_2, arg_90_3)

		if not USE_ENGINE_SLOID_SYSTEM then
			notify_attackers(arg_90_1, self.dogpiled_attackers_on_unit)
		else
			self.gathering:notify_attackers(arg_90_1)
		end

		self:_remove_unit_from_spawned(arg_90_1, arg_90_2)
		self:register_unit_destroyed(arg_90_1, arg_90_2, arg_90_3)
	end
end

ConflictDirector.destroy_all_units = function (self, arg_91_1)
	-- function 91
	print("ConflictDirector - destroy all units")

	if not Managers.state.network:game() then
		return
	end

	local var_91_0 = BLACKBOARDS
	local _conflict_data_by_side = self._conflict_data_by_side

	for k, v in pairs(_conflict_data_by_side) do
		local spawned = v.spawned

		for k_2 = #spawned, 1, -1 do
			local var_91_3 = spawned[k_2]

			if not ALIVE[var_91_3] then
				local var_91_4 = var_91_0[var_91_3]
				local breed = var_91_4.breed

				if not (not arg_91_1 and breed.debug_despawn_immunity) then
					local str = "destroy_all_units"

					self:destroy_unit(var_91_3, var_91_4, str)
				end
			end
		end
	end

	Managers.state.event:trigger("ai_units_all_destroyed")

	self._living_horde = 0
end

ConflictDirector.destroy_close_units = function (self, arg_92_1, arg_92_2, arg_92_3)
	-- function 92
	if not Managers.state.network:game() then
		return
	end

	arg_92_1 = arg_92_1 or POSITION_LOOKUP[Managers.player:local_player().player_unit]

	if not arg_92_1 then
		return
	end

	local num = 0
	local _conflict_data_by_side = self._conflict_data_by_side

	for k, v in pairs(_conflict_data_by_side) do
		local spawned = v.spawned
		local count = #spawned
		local num_2 = 1
		local var_92_5 = BLACKBOARDS

		while num_2 <= count do
			local var_92_6 = spawned[num_2]
			local var_92_7

			if not (not ALIVE[var_92_6] and var_92_6 == arg_92_2) then
				local local_position = Unit.local_position(var_92_6, 0)

				var_92_7 = arg_92_3 > distance_squared(arg_92_1, local_position)
			else
				var_92_7 = false
			end

			if not var_92_7 then
				local var_92_9 = var_92_5[var_92_6]
				local breed = var_92_9.breed
				local str = "destroy_close_units"

				num = num + 1

				if not Managers.weave:get_active_weave() then
					local tbl = {
						breed = breed
					}
					local player_unit = Managers.player:local_player().player_unit

					Managers.state.entity:system("objective_system"):on_ai_killed(var_92_6, player_unit, tbl)
				end

				self:destroy_unit(var_92_6, var_92_9, str)

				count = count - 1
			else
				num_2 = num_2 + 1
			end
		end
	end

	print("debug destroy close units", num)
end

ConflictDirector.destroy_specials = function (self)
	-- function 93
	print("debug destroy specials")

	local _alive_specials = self._alive_specials
	local count = #_alive_specials
	local var_93_2 = BLACKBOARDS

	for i = count, 1, -1 do
		local var_93_3 = _alive_specials[i]

		if not ALIVE[var_93_3] then
			local var_93_4 = var_93_2[var_93_3]
			local breed = var_93_4.breed
			local str = "destroy_specials"

			self:destroy_unit(var_93_3, var_93_4, str)
		end
	end

	fassert(#self._alive_specials == 0, "Something bad happend when debug despawned all specials")

	local PLAYER_AND_BOT_UNITS = self._hero_side.PLAYER_AND_BOT_UNITS

	for i_2, v in ipairs(PLAYER_AND_BOT_UNITS) do
		local extension = ScriptUnit.extension(v, "status_system")

		if not (not extension.pack_master_status and extension.pack_master_status ~= "pack_master_hanging") then
			StatusUtils.set_grabbed_by_pack_master_network("pack_master_dropping", v, true, nil)
		end
	end
end

ConflictDirector.debug_spawn_breed = function (self, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	-- function 94
	local var_94_0 = Breeds[arg_94_1]
	local var_94_1 = arg_94_4
	local var_94_2 = var_94_1[1]
	local var_94_3 = var_94_1[2]

	if not var_94_3 and not self[var_94_3] and not self[var_94_3](self, var_94_1[3], var_94_1[4], var_94_1[5], var_94_1[6]) then
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
	local debug_spawn_func_name = var_94_0.debug_spawn_func_name

	if not debug_spawn_func_name then
		var_94_4 = self[debug_spawn_func_name](self, var_94_0, false, arg_94_2, arg_94_3)
	else
		var_94_4 = self:aim_spawning(var_94_0, false, arg_94_2, arg_94_3)
	end

	return var_94_4
end

local flag_2 = true

ConflictDirector.debug_spawn_all_breeds = function (self, arg_95_1, arg_95_2)
	-- function 95
	local aim_spawning = self:aim_spawning(nil, true)

	if not aim_spawning then
		return
	end

	local tbl = {}

	if not arg_95_2 then
		for k, v in pairs(arg_95_1) do
			tbl[#tbl + 1] = Breeds[k]
		end
	else
		for k_2, v_2 in pairs(Breeds) do
			if not arg_95_1[k_2] then
				tbl[#tbl + 1] = v_2
			end
		end
	end

	local count = #tbl
	local ceil = math.ceil(math.sqrt(count))
	local var_95_4 = Quaternion(Vector3.up(), math.degrees_to_radians(math.random(1, 360)))

	if not flag_2 then
		local num = 1
		local traverse_logic = Managers.state.entity:system("ai_slot_system"):traverse_logic()

		for i4 = 1, ceil do
			for i5 = 1, ceil do
				if count < num then
					break
				end

				local var_95_7 = Vector3((i4 - ceil * 0.5) * 4, (i5 - ceil * 0.5) * 4, 0)
				local raycast, var_95_9 = GwNavQueries.raycast(GLOBAL_AI_NAVWORLD, aim_spawning, aim_spawning + var_95_7, traverse_logic)

				if not raycast then
					local tbl_2 = {
						ignore_breed_limits = true,
						side_id = self.debug_spawn_side_id
					}
					local var_95_11 = tbl[num]

					num = num + 1

					self:spawn_queued_unit(var_95_11, Vector3Box(var_95_9), QuaternionBox(var_95_4), "debug_spawn", nil, nil, tbl_2)
				end
			end
		end
	else
		local num_2 = 8

		for i6 = 1, count do
			local var_95_13

			for i7 = 1, num_2 do
				local var_95_14 = Vector3(4 * math.random() - 2, 4 * math.random() - 2, 0)

				if i7 == 1 then
					var_95_14 = Vector3(-ceil / 2 + i6 % ceil, -ceil / 2 + math.floor(i6 / ceil), 0)
				end

				local pos_on_mesh = LocomotionUtils.pos_on_mesh(self.nav_world, aim_spawning + var_95_14)

				if not pos_on_mesh then
					local tbl_3 = {
						ignore_breed_limits = true,
						side_id = self.debug_spawn_side_id
					}
					local var_95_17 = tbl[i6]

					self:spawn_queued_unit(var_95_17, Vector3Box(pos_on_mesh), QuaternionBox(var_95_4), "debug_spawn", nil, nil, tbl_3)

					break
				end
			end
		end
	end

	return true
end

ConflictDirector.debug_spawn_breed_at_hidden_spawner = function (self, arg_96_1)
	-- function 96
	local var_96_0 = Breeds[arg_96_1]

	print("Debug spawning from hidden spawner: " .. arg_96_1)

	local var_96_1 = self._hero_side.PLAYER_POSITIONS[1]

	if not var_96_1 then
		local get_random_hidden_spawner = ConflictUtils.get_random_hidden_spawner(var_96_1, 40)

		if not get_random_hidden_spawner then
			print("No hidden spawner units found")

			return
		end

		local local_position = Unit.local_position(get_random_hidden_spawner, 0)
		local str = "debug_spawn"
		local var_96_5 = Quaternion(Vector3.up(), math.degrees_to_radians(math.random(1, 360)))
		local tbl = {
			ignore_breed_limits = true,
			side_id = self.debug_spawn_side_id
		}

		self:spawn_queued_unit(var_96_0, Vector3Box(local_position), QuaternionBox(var_96_5), str, nil, nil, tbl)
	end
end

ConflictDirector.rpc_debug_conflict_director_command = function (self, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5, arg_97_6)
	-- function 97
	self._debug_spawn_breed_position = arg_97_4
	self._debug_spawn_breed_enhancements = table.set(string.split_deprecated(arg_97_5, ","))

	if arg_97_2 == "debug_spawn_breed" then
		self:debug_spawn_breed(arg_97_3, false, arg_97_4, arg_97_6)
	elseif arg_97_2 == "debug_spawn_group" then
		self:debug_spawn_group(arg_97_3)
	elseif arg_97_2 == "debug_spawn_roaming_patrol" then
		self:debug_spawn_roaming_patrol(arg_97_4)
	elseif arg_97_2 == "debug_spawn_group_at_main_path" then
		self:debug_spawn_group_at_main_path(nil, nil)
	elseif arg_97_2 == "debug_spawn_breed_at_hidden_spawner" then
		self:debug_spawn_breed_at_hidden_spawner(arg_97_3)
	elseif arg_97_2 == "destroy_close_units" then
		local var_97_0 = self
		local destroy_close_units = self.destroy_close_units
		local var_97_2 = arg_97_4
		local var_97_3
		local var_97_4 = tonumber(arg_97_6[1])

		var_97_4 = var_97_4 or 12

		destroy_close_units(var_97_0, var_97_2, var_97_3, var_97_4^2)
	elseif arg_97_2 == "destroy_all_units" then
		self:destroy_all_units(true)
	elseif arg_97_2 == "destroy_specials" then
		self:destroy_specials()
	end

	self._debug_spawn_breed_position = nil
	self._debug_spawn_breed_enhancements = nil
end

ConflictDirector.rpc_debug_conflict_director_command = NOP

ConflictDirector.debug_spawn_group = function (self, arg_98_1)
	-- function 98
	local var_98_0 = Breeds[arg_98_1]

	print("Spawning group: " .. arg_98_1)
	self:aim_spawning_group(var_98_0, true)
end

ConflictDirector.debug_spawn_group_at_main_path = function (self, arg_99_1, arg_99_2)
	-- function 99
	local skaven_storm_vermin = Breeds.skaven_storm_vermin
	local str = "spline_patrol"

	RecycleSettings.destroy_los_distance_squared = math.huge

	local main_paths = self.main_path_info.main_paths
	local var_99_3

	if not arg_99_1 then
		var_99_3 = main_paths[arg_99_1]

		if not var_99_3 then
			-- Nothing
		end
	end

	var_99_3 = main_paths[math.random(1, #main_paths)]

	do
		local var_99_4
	end

	::label_99_0::

	if not arg_99_2 then
		var_99_4 = var_99_3.nodes[arg_99_2]

		if not var_99_4 then
			-- Nothing
		end
	end

	var_99_4 = var_99_3.nodes[math.random(1, #var_99_3.nodes)]

	::label_99_1::

	local tbl = {
		wanted_size = 5,
		group_type = "main_path_patrol",
		breed = skaven_storm_vermin
	}

	self:spawn_group(str, var_99_4:unbox(), tbl)
end

ConflictDirector.debug_spawn_horde = function (self)
	-- function 100
	if not self.in_safe_zone then
		print("Can't spawn horde in safe zone")

		return
	end

	local ai_set_horde_type_debug = script_data.ai_set_horde_type_debug
	local default_enemy_side_id = self.default_enemy_side_id
	local tbl = {
		horde_wave = "single"
	}

	if not (not ai_set_horde_type_debug and ai_set_horde_type_debug ~= "random") then
		local tbl_2 = {
			"vector",
			"vector_blob",
			"ambush"
		}

		ai_set_horde_type_debug = tbl_2[math.random(1, #tbl_2)]
	end

	print("DEBUG_HORDE: ", ai_set_horde_type_debug)

	if type(CurrentHordeSettings.vector_composition) == "table" then
		local var_100_4 = CurrentHordeSettings.vector_composition[math.random(#CurrentHordeSettings.vector_composition)]

		tbl.optional_wave_composition = var_100_4

		print("DEBUG_HORDE: Wave composition ", var_100_4)
	end

	self.horde_spawner:horde(ai_set_horde_type_debug, tbl, default_enemy_side_id)
end

ConflictDirector.debug_speed_running_intervention = function (self, arg_101_1)
	-- function 101
	local speed_running_intervention_data = self.speed_running_intervention_data

	if not speed_running_intervention_data.debug_state then
		Debug.text(string.format("%0.1f", self._next_speed_running_intervention_time - arg_101_1) .. " SPEED RUN intervention: " .. speed_running_intervention_data.debug_state)
	end

	if not speed_running_intervention_data.total_travel_distances then
		for k, v in pairs(speed_running_intervention_data.total_travel_distances) do
			local owner = Managers.player:owner(k)

			if not owner then
				local display_name = SPProfiles[owner:profile_index()].display_name

				Debug.text(display_name .. " total travel distance: " .. v)
			end
		end
	end
end

local function fn_3()
	-- function 102
	local active = Managers.free_flight:active("global")
	local var_102_1

	if not active then
		var_102_1 = Managers.input:get_service("FreeFlight")
	else
		var_102_1 = Managers.input:get_service("Player")
	end

	return var_102_1
end

local function fn_4()
	-- function 103
	if not Managers.free_flight:active("global") then
		local get_service = Managers.free_flight.input_manager:get_service("FreeFlight")
		local global = Managers.free_flight.data.global
		local world = Managers.world:world(global.viewport_world_name)
		local global_free_flight_viewport = ScriptWorld.global_free_flight_viewport(world)
		local frustum_freeze_camera = global.frustum_freeze_camera

		frustum_freeze_camera = frustum_freeze_camera or ScriptViewport.camera(global_free_flight_viewport)

		local get = get_service:get("cursor")
		local screen_to_world = Camera.screen_to_world(frustum_freeze_camera, Vector3(get.x, get.y, 0), 0)
		local num = Camera.screen_to_world(frustum_freeze_camera, Vector3(get.x, get.y, 0), 1) - screen_to_world
		local normalize = Vector3.normalize(num)

		return screen_to_world, normalize
	else
		local local_player = Managers.player:local_player(1)
		local camera_position = Managers.state.camera:camera_position(local_player.viewport_name)
		local camera_rotation = Managers.state.camera:camera_rotation(local_player.viewport_name)
		local forward = Quaternion.forward(camera_rotation)

		return camera_position, forward
	end
end

ConflictDirector.player_aim_raycast = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
	-- function 104
	local var_104_0, var_104_1 = fn_4()
	local player_unit = Managers.player:local_player(1).player_unit
	local get_data = World.get_data(arg_104_1, "physics_world")
	local immediate_raycast = PhysicsWorld.immediate_raycast(get_data, var_104_0, var_104_1, 100, "all", "collision_filter", arg_104_3)

	if not immediate_raycast then
		local count = #immediate_raycast

		for i = 1, count do
			local var_104_6 = immediate_raycast[i]
			local var_104_7 = var_104_6[4]
			local unit = Actor.unit(var_104_7)

			if not (unit == player_unit) then
				local get_data_2 = Unit.get_data(unit, "breed")

				if not arg_104_2 then
					if not get_data_2 then
						return get_data_2, var_104_6[1], var_104_6[2], var_104_6[3], var_104_6[4], var_104_1
					end
				else
					return var_104_6[1], var_104_6[2], var_104_6[3], var_104_6[4], var_104_1
				end
			end
		end
	end

	return nil
end

ConflictDirector.debug_spawn_tentacle_blob = function (self, arg_105_1, arg_105_2, arg_105_3, arg_105_4)
	-- function 105
	print("DEBUG SPAWN TENTACLE")

	local player_aim_raycast, var_105_1, var_105_2, var_105_3 = self:player_aim_raycast(self._world, arg_105_2, "filter_ray_horde_spawn")

	if not player_aim_raycast then
		return
	end

	local var_105_4 = player_aim_raycast

	QuickDrawerStay:sphere(var_105_4, 0.33, Color(255, 0, 0))

	local str = "debug_spawn"
	local var_105_6 = Quaternion(Vector3.up(), math.degrees_to_radians(math.random(1, 360)))
	local debug_spawn_optional_data = arg_105_1.debug_spawn_optional_data

	debug_spawn_optional_data = debug_spawn_optional_data or {}

	debug_spawn_optional_data.spawned_func = function (arg_106_0, arg_106_1, arg_106_2)
		-- function 106
		if not arg_106_1.special then
			self._alive_specials[#self._alive_specials + 1] = arg_106_0
		end

		local system = Managers.state.entity:system("ai_system")

		if not (not system.ai_debugger and HEALTH_ALIVE[system.ai_debugger.active_unit] or script_data.ai_disable_auto_ai_debugger_target) then
			system.ai_debugger.active_unit = arg_106_0
			script_data.debug_unit = arg_106_0
		end
	end

	debug_spawn_optional_data.ignore_breed_limits = true
	debug_spawn_optional_data.side_id = self.debug_spawn_side_id

	self:spawn_queued_unit(arg_105_1, Vector3Box(var_105_4), QuaternionBox(var_105_6), str, nil, nil, debug_spawn_optional_data)
end

ConflictDirector.aim_spawning_surface = function (self, arg_107_1, arg_107_2, arg_107_3, arg_107_4)
	-- function 107
	local player_aim_raycast, var_107_1, var_107_2, var_107_3 = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")

	if not arg_107_1.inside_wall_spawn_distance then
		player_aim_raycast = player_aim_raycast - var_107_2 * arg_107_1.inside_wall_spawn_distance
	end

	local str = "debug_spawn"
	local look = Quaternion.look(var_107_2, Vector3.up())
	local debug_spawn_optional_data = arg_107_1.debug_spawn_optional_data

	debug_spawn_optional_data = debug_spawn_optional_data or {}
	debug_spawn_optional_data.side_id = self.debug_spawn_side_id

	debug_spawn_optional_data.spawned_func = function (arg_108_0, arg_108_1, arg_108_2)
		-- function 108
		if not arg_108_1.special then
			self._alive_specials[#self._alive_specials + 1] = arg_108_0
		end

		local system = Managers.state.entity:system("ai_system")

		if not (not system.ai_debugger and HEALTH_ALIVE[system.ai_debugger.active_unit] or script_data.ai_disable_auto_ai_debugger_target) then
			system.ai_debugger.active_unit = arg_108_0
			script_data.debug_unit = arg_108_0
		end
	end

	debug_spawn_optional_data.ignore_breed_limits = true

	self:spawn_queued_unit(arg_107_1, Vector3Box(player_aim_raycast), QuaternionBox(look), str, nil, nil, debug_spawn_optional_data)
end

ConflictDirector.set_debug_spawn_side = function (self, arg_109_1)
	-- function 109
	self.debug_spawn_side_id = arg_109_1
end

ConflictDirector.cycle_debug_spawn_side = function (self)
	-- function 110
	self.debug_spawn_side_id = self.debug_spawn_side_id % #Managers.state.side:sides() + 1
end

ConflictDirector.aim_spawning_air = function (self, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
	-- function 111
	local player_aim_raycast, var_111_1, var_111_2, var_111_3 = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")
	local str = "debug_spawn"
	local identity = Quaternion.identity()

	if not player_aim_raycast then
		local var_111_6
		local var_111_7

		player_aim_raycast, var_111_7 = fn_4()
		player_aim_raycast = player_aim_raycast + var_111_7 * arg_111_1.air_spawning_distance
	elseif not arg_111_1.inside_wall_spawn_distance then
		player_aim_raycast = player_aim_raycast - var_111_2 * arg_111_1.inside_wall_spawn_distance
	end

	local debug_spawn_optional_data = arg_111_1.debug_spawn_optional_data

	debug_spawn_optional_data = debug_spawn_optional_data or {}
	debug_spawn_optional_data.side_id = self.debug_spawn_side_id

	debug_spawn_optional_data.spawned_func = function (arg_112_0, arg_112_1, arg_112_2)
		-- function 112
		if not arg_112_1.special then
			self._alive_specials[#self._alive_specials + 1] = arg_112_0
		end

		local system = Managers.state.entity:system("ai_system")

		if not (not system.ai_debugger and HEALTH_ALIVE[system.ai_debugger.active_unit] or script_data.ai_disable_auto_ai_debugger_target) then
			system.ai_debugger.active_unit = arg_112_0
			script_data.debug_unit = arg_112_0
		end
	end

	debug_spawn_optional_data.ignore_breed_limits = true

	self:spawn_queued_unit(arg_111_1, Vector3Box(player_aim_raycast), QuaternionBox(identity), str, nil, nil, debug_spawn_optional_data)
end

ConflictDirector.aim_spawning = function (self, arg_113_1, arg_113_2, arg_113_3, arg_113_4, arg_113_5)
	-- function 113
	local var_113_0
	local var_113_1
	local var_113_2
	local var_113_3

	if not (DEDICATED_SERVER or arg_113_4) then
		local var_113_4, var_113_5, var_113_6

		var_113_0, var_113_4, var_113_5, var_113_6 = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")
	end

	if not arg_113_3 then
		return var_113_0
	elseif not arg_113_4 then
		var_113_0 = arg_113_4
	elseif not self._debug_spawn_breed_position then
		var_113_0 = self._debug_spawn_breed_position
	end

	if not var_113_0 then
		return
	end

	local var_113_7

	if not arg_113_2 then
		var_113_7 = LocomotionUtils.pos_on_mesh(self.nav_world, var_113_0)
	else
		var_113_7 = var_113_0
	end

	if not arg_113_1 then
		local str = "debug_spawn"
		local var_113_9 = Quaternion(Vector3.up(), math.degrees_to_radians(math.random(1, 360)))
		local debug_spawn_optional_data = arg_113_1.debug_spawn_optional_data

		debug_spawn_optional_data = debug_spawn_optional_data or {}
		debug_spawn_optional_data.ignore_breed_limits = true
		debug_spawn_optional_data.side_id = self.debug_spawn_side_id

		debug_spawn_optional_data.spawned_func = function (arg_114_0, arg_114_1, arg_114_2)
			-- function 114
			if not arg_114_1.special then
				self._alive_specials[#self._alive_specials + 1] = arg_114_0
			end

			local system = Managers.state.entity:system("ai_system")

			if not (not system.ai_debugger and HEALTH_ALIVE[system.ai_debugger.active_unit] or script_data.ai_disable_auto_ai_debugger_target) then
				system.ai_debugger.active_unit = arg_114_0
				script_data.debug_unit = arg_114_0
			end
		end

		if not arg_113_5 then
			table.merge(debug_spawn_optional_data, arg_113_5)
		end

		self:spawn_queued_unit(arg_113_1, Vector3Box(var_113_7), QuaternionBox(var_113_9), str, nil, nil, debug_spawn_optional_data)
	else
		return var_113_7
	end
end

ConflictDirector.debug_spawn_roaming_patrol = function (self, arg_115_1)
	-- function 115
	if not arg_115_1 then
		return
	end

	local system = Managers.state.entity:system("ai_group_system")

	if not system:level_has_splines("roaming") then
		local random_roaming_formation = PatrolFormationSettings.random_roaming_formation(BreedPacks.beastmen[3])
		local get_best_spline = system:get_best_spline(arg_115_1, "roaming")

		if not get_best_spline then
			Debug.sticky_text("no roaming spline within max distance")

			return
		end

		local tbl = {
			Vector3Box(28, -243, 0),
			Vector3Box(37, -143, 0)
		}
		local tbl_2 = {
			spawn_all_at_same_position = false,
			group_type = "roaming_patrol",
			formation = random_roaming_formation,
			spline_name = get_best_spline,
			spline_way_points = tbl
		}

		self:spawn_spline_group("spline_patrol", arg_115_1, tbl_2)
	end
end

ConflictDirector.debug_spawn_spline_patrol_closest_spawner = function (self)
	-- function 116
	local local_player = Managers.player:local_player()
	local get_free_flight_pos = self:get_free_flight_pos()

	get_free_flight_pos = get_free_flight_pos or POSITION_LOOKUP[local_player.player_unit]

	local debug_get_closest_boss_patrol_spawn, var_116_3 = Managers.state.conflict.level_analysis:debug_get_closest_boss_patrol_spawn(get_free_flight_pos)
	local tbl = {
		spline_type = "patrol",
		event_kind = "event_spline_patrol",
		spline_id = debug_get_closest_boss_patrol_spawn.id,
		spline_way_points = var_116_3,
		one_directional = debug_get_closest_boss_patrol_spawn.one_directional
	}

	TerrorEventMixer.start_event("boss_event_chaos_spline_patrol", tbl)
end

ConflictDirector.aim_patrol_spawning = function (self, arg_117_1)
	-- function 117
	self:aim_spawning_group(nil, true, arg_117_1)

	return true
end

ConflictDirector.inject_event_patrol = function (self)
	-- function 118
	local get_closest_roaming_spline, var_118_1, var_118_2 = self.conflict_director.level_analysis:get_closest_roaming_spline(area_position:unbox())

	if not get_closest_roaming_spline then
		return false
	end

	local waypoints = var_118_1.waypoints
	local boxify_waypoint_table = self:boxify_waypoint_table(waypoints)
end

ConflictDirector.aim_spawning_group = function (self, arg_119_1, arg_119_2, arg_119_3)
	-- function 119
	local player_aim_raycast, var_119_1, var_119_2, var_119_3 = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")

	if not self._debug_spawn_breed_position then
		player_aim_raycast = self._debug_spawn_breed_position
	end

	if not player_aim_raycast then
		return
	end

	if not arg_119_3 then
		local tbl = {
			wanted_size = 50,
			group_type = "grid",
			breed = arg_119_1
		}

		self:spawn_group("spline_patrol", player_aim_raycast, tbl)
	else
		local system = Managers.state.entity:system("ai_group_system")
		local str = "patrol"
		local flag = false

		if not str then
			local get_difficulty = Managers.state.difficulty:get_difficulty()
			local var_119_9 = PatrolFormationSettings[arg_119_3][get_difficulty]

			var_119_9.settings = PatrolFormationSettings[arg_119_3].settings

			local var_119_10
			local var_119_11
			local var_119_12
			local var_119_13
			local get_best_spline = system:get_best_spline(player_aim_raycast, str)

			if not get_best_spline then
				var_119_11 = {
					Vector3Box(110, 0, 0),
					Vector3Box(1, -220, 0)
				}
			else
				local var_119_15

				get_best_spline, var_119_11, var_119_15 = self.level_analysis:get_closest_waypoint_spline(player_aim_raycast)

				if not get_best_spline then
					player_aim_raycast = var_119_15
					flag = true
				else
					print("No patrol spline found")

					return
				end
			end

			local tbl_2 = {
				spawn_all_at_same_position = false,
				group_type = "spline_patrol",
				formation = var_119_9,
				spline_name = get_best_spline,
				spline_way_points = var_119_11,
				despawn_at_end = flag
			}

			self:spawn_spline_group("spline_patrol", player_aim_raycast, tbl_2)
		else
			local tbl_3 = {
				group_type = "main_path_patrol",
				breed = arg_119_1 or Breeds.skaven_storm_vermin
			}

			self:spawn_group("spline_patrol", player_aim_raycast, tbl_3)
		end
	end
end

local tbl_4 = {}

ConflictDirector.spawn_group = function (self, arg_120_1, arg_120_2, arg_120_3)
	-- function 120
	if type(arg_120_3) ~= "table" then
		print("wrong spawn type")

		return
	end

	local group_type = arg_120_3.group_type
	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local wanted_size = arg_120_3.wanted_size

	wanted_size = wanted_size or 0

	local num = 8
	local num_2 = 0
	local flag = group_type == "grid"
	local flag_2 = not flag and math.ceil(math.sqrt(wanted_size))

	for i = 1, wanted_size do
		local var_120_7

		for j = 1, num do
			local var_120_8 = Vector3(4 * Math.random() - 2, 4 * Math.random() - 2, 0)

			if not (not flag and j ~= 1) then
				var_120_8 = Vector3(-flag_2 / 2 + i % flag_2, -flag_2 / 2 + math.floor(i / flag_2), 0)
			end

			local pos_on_mesh = LocomotionUtils.pos_on_mesh(self.nav_world, arg_120_2 + var_120_8)

			if not pos_on_mesh then
				num_2 = num_2 + 1
				tbl_4[num_2] = pos_on_mesh

				break
			end
		end
	end

	if num_2 == 0 then
		return
	end

	local var_120_10

	if group_type == "main_path_patrol" then
		var_120_10 = {
			id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
			template = arg_120_1,
			size = num_2,
			group_type = group_type
		}
	end

	local str = "patrol"
	local var_120_12 = Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360)))
	local tbl = {
		ignore_breed_limits = true
	}
	local debug_spawn_side_id = self.debug_spawn_side_id

	debug_spawn_side_id = debug_spawn_side_id or arg_120_3.side_id
	tbl.side_id = debug_spawn_side_id

	for k = 1, num_2 do
		local var_120_15 = tbl_4[k]
		local breed = arg_120_3.breed

		self:spawn_queued_unit(breed, Vector3Box(var_120_15), QuaternionBox(var_120_12), str, nil, nil, tbl, var_120_10)
	end
end

ConflictDirector.spawn_spline_group = function (self, arg_121_1, arg_121_2, arg_121_3)
	-- function 121
	local group_type = arg_121_3.group_type
	local spline_name = arg_121_3.spline_name
	local formation = arg_121_3.formation
	local zone_data = arg_121_3.zone_data
	local spawn_all_at_same_position = arg_121_3.spawn_all_at_same_position
	local system = Managers.state.entity:system("ai_group_system")
	local flag = not arg_121_2 and Vector3Box(arg_121_2)
	local get_side = Managers.state.side:get_side(self.default_enemy_side_id)
	local tbl = {
		id = system:generate_group_id(),
		template = arg_121_1,
		spline_name = spline_name,
		formation = formation,
		group_type = group_type,
		group_start_position = flag,
		data = arg_121_3,
		zone_data = zone_data,
		despawn_at_end = arg_121_3.despawn_at_end,
		spawn_all_at_same_position = spawn_all_at_same_position,
		side = get_side
	}
	local spline = system:spline(spline_name)

	if not spline then
		print("Spline already found!")

		if not spline.failed then
			self:_spawn_spline_group(tbl)
		else
			print("spline is in fail state, cancelling the spline spawn.", spline_name)
		end
	elseif not arg_121_3.spline_way_points then
		system:create_spline_from_way_points(spline_name, arg_121_3.spline_way_points, arg_121_3.spline_type)

		local _spline_groups_to_spawn = self._spline_groups_to_spawn

		_spline_groups_to_spawn = _spline_groups_to_spawn or {}
		self._spline_groups_to_spawn = _spline_groups_to_spawn
		self._spline_groups_to_spawn[spline_name] = tbl
	else
		ferror("Missing spline: %s", spline_name)
	end
end

ConflictDirector._check_hi_data_override = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3)
	-- function 122
	local name = arg_122_1.name
	local var_122_1 = arg_122_2[name]

	if not var_122_1 then
		var_122_1.count = var_122_1.count + 1

		if var_122_1.count > var_122_1.max_amount then
			arg_122_1 = var_122_1.switch_breed
			var_122_1.switch_count = var_122_1.switch_count + 1

			return arg_122_1, name
		end
	end

	return arg_122_1
end

ConflictDirector.set_breed_override_lookup = function (self, arg_123_1)
	-- function 123
	self._breed_override_lookup = arg_123_1
end

ConflictDirector._spawn_spline_group = function (self, arg_124_1, arg_124_2)
	-- function 124
	local str = "patrol"
	local formation = arg_124_1.formation
	local spline_name = arg_124_1.spline_name
	local system = Managers.state.entity:system("ai_group_system")
	local spawn_all_at_same_position = arg_124_1.spawn_all_at_same_position
	local group_start_position = arg_124_1.group_start_position

	group_start_position = not group_start_position and arg_124_1.group_start_position:unbox()

	local flag = group_start_position or system:spline_start_position(spline_name)
	local create_formation_data = system:create_formation_data(flag, formation, spline_name, spawn_all_at_same_position, arg_124_1)

	arg_124_1.formation = create_formation_data
	arg_124_1.group_start_position = Vector3Box(flag)

	local group_size = create_formation_data.group_size

	if group_size == 0 then
		return
	end

	local zone_data = arg_124_1.zone_data
	local var_124_10

	if not zone_data then
		local hi_data = zone_data.hi_data

		var_124_10 = not hi_data and hi_data.breed_count
	end

	arg_124_1.size = group_size

	local _breed_override_lookup = self._breed_override_lookup

	for i, v in ipairs(create_formation_data) do
		for i_2, v_2 in ipairs(v) do
			repeat
				local breed_name = v_2.breed_name

				if not Breeds[breed_name] then
					break
				end

				local tbl = {}
				local var_124_15 = Breeds[breed_name]

				if not var_124_10 then
					local var_124_16
					local var_124_17

					var_124_15, var_124_17 = self:_check_hi_data_override(var_124_15, var_124_10, zone_data)
				end

				if not _breed_override_lookup then
					local var_124_18 = _breed_override_lookup[var_124_15.name]

					if not var_124_18 then
						var_124_15 = Breeds[var_124_18]
					end
				end

				local unbox = v_2.start_position:unbox()
				local unbox_2 = v_2.start_direction:unbox()
				local look = Quaternion.look(unbox_2, Vector3.up())
				local shallow_copy = table.shallow_copy(arg_124_1)

				shallow_copy.breed = breed_name
				shallow_copy.group_position = {
					row = i,
					column = i_2
				}
				tbl.far_off_despawn_immunity = true

				self:spawn_queued_unit(var_124_15, Vector3Box(unbox), QuaternionBox(look), str, nil, nil, tbl, shallow_copy)
			until true
		end
	end
end

ConflictDirector.spawn_one = function (self, arg_125_1, arg_125_2, arg_125_3, arg_125_4, arg_125_5)
	-- function 125
	if not arg_125_1.special and not Managers.state.game_mode:setting("ai_specials_spawning_disabled") then
		return
	end

	local str = "spawn_one"
	local PLAYER_POSITIONS = self._hero_side.PLAYER_POSITIONS
	local var_125_2 = PLAYER_POSITIONS[1]

	if not var_125_2 then
		for i = 1, #PLAYER_POSITIONS do
			local var_125_3 = PLAYER_POSITIONS[i]

			if not var_125_3 then
				var_125_2 = var_125_3

				break
			end
		end
	end

	if not var_125_2 then
		return
	end

	local flag = arg_125_2 or ConflictUtils.get_spawn_pos_on_circle(self.nav_world, var_125_2, 20, 8, 30)

	if not flag then
		local var_125_5 = arg_125_5

		var_125_5 = var_125_5 or Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360)))

		self:spawn_queued_unit(arg_125_1, Vector3Box(flag), QuaternionBox(var_125_5), str, nil, nil, arg_125_4, arg_125_3)
	end
end

local function fn_5(arg_126_0, arg_126_1, arg_126_2)
	-- function 126
	local system = Managers.state.entity:system("play_go_tutorial_system")

	if not system then
		local spawner_unit = arg_126_2.spawner_unit
		local _get_spawned_unit_id = Managers.state.conflict:_get_spawned_unit_id(arg_126_0)

		system:register_unit(spawner_unit, arg_126_0, _get_spawned_unit_id)
	end
end

ConflictDirector.spawn_at_raw_spawner = function (self, arg_127_1, arg_127_2, arg_127_3, arg_127_4)
	-- function 127
	local get_raw_spawner_unit, var_127_1 = Managers.state.entity:system("spawner_system"):get_raw_spawner_unit(arg_127_2)

	if not get_raw_spawner_unit then
		local local_position = Unit.local_position(get_raw_spawner_unit, 0)
		local local_rotation = Unit.local_rotation(get_raw_spawner_unit, 0)

		arg_127_3 = arg_127_3 or {}
		arg_127_3.idle_animation = var_127_1
		arg_127_3.spawner_unit = get_raw_spawner_unit

		if not arg_127_3.spawned_func then
			local spawned_func = arg_127_3.spawned_func

			arg_127_3.spawned_func = function (arg_128_0, arg_128_1, arg_128_2)
				-- function 128
				spawned_func(arg_128_0, arg_128_1, arg_128_2)
				fn_5(arg_128_0, arg_128_1, arg_128_2)
			end
		else
			arg_127_3.spawned_func = fn_5
		end

		local side_id = arg_127_3.side_id

		side_id = side_id or arg_127_4 or self.default_enemy_side_id
		arg_127_3.side_id = side_id

		self:spawn_queued_unit(arg_127_1, Vector3Box(local_position), QuaternionBox(local_rotation), "raw_spawner", nil, nil, arg_127_3, nil, nil)
	end
end

ConflictDirector.debug_spawn_at_raw = function (self, arg_129_1, arg_129_2, arg_129_3)
	-- function 129
	local player_aim_raycast = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")

	if not self._debug_spawn_breed_position then
		player_aim_raycast = self._debug_spawn_breed_position
	end

	local identity = Quaternion.identity()

	arg_129_2 = arg_129_2 or {}

	if not arg_129_2.spawned_func then
		local spawned_func = arg_129_2.spawned_func

		arg_129_2.spawned_func = function (arg_130_0, arg_130_1, arg_130_2)
			-- function 130
			spawned_func(arg_130_0, arg_130_1, arg_130_2)
			fn_5(arg_130_0, arg_130_1, arg_130_2)
		end
	else
		arg_129_2.spawned_func = fn_5
	end

	local side_id = arg_129_2.side_id

	side_id = side_id or arg_129_3 or self.default_enemy_side_id
	arg_129_2.side_id = side_id

	self:spawn_queued_unit(arg_129_1, Vector3Box(player_aim_raycast), QuaternionBox(identity), "raw_spawner", nil, nil, arg_129_2, nil, nil)
end

ConflictDirector.generate_spawns = function (self)
	-- function 131
	local var_131_0
	local var_131_1
	local var_131_2
	local var_131_3
	local var_131_4
	local get_start_and_finish, var_131_6 = self.level_analysis:get_start_and_finish()

	fassert(var_131_6, "Missing path marker at the end of the level")

	local get_seed_triangle = GwNavTraversal.get_seed_triangle(self.nav_world, var_131_6:unbox())

	fassert(get_seed_triangle, "The path marker at the end of the level is outside the navmesh")
	self.navigation_group_manager:setup(self._world, self.nav_world)

	if not flag then
		print("Forming navigation groups in one frame")
		self.navigation_group_manager:form_groups(nil, var_131_6)
	else
		self.navigation_group_manager:form_groups_start(nil, var_131_6)
	end

	if not CurrentConflictSettings.roaming.disabled then
		print("roaming spawning is disabled")

		return {}
	end

	if not (not self.spawn_zone_baker.spawn_zones_available and self.level_settings.skip_generate_spawns) then
		local num = 0.5
		local current_conflict_settings = self.current_conflict_settings

		current_conflict_settings = current_conflict_settings or "default"

		local pack_spawning = ConflictDirectors[current_conflict_settings].pack_spawning

		pack_spawning = pack_spawning or PackSpawningSettings.default

		local basics = pack_spawning.basics
		local spawn_cycle_length = basics.spawn_cycle_length
		local area_density_coefficient = pack_spawning.area_density_coefficient
		local length_density_coefficient = basics.length_density_coefficient
		local mutators = Managers.state.game_mode:mutators()
		local keys = table.keys(mutators)
		local generate_spawns, var_131_18, var_131_19, var_131_20, var_131_21 = self.spawn_zone_baker:generate_spawns(spawn_cycle_length, num, area_density_coefficient, length_density_coefficient, current_conflict_settings, keys)
		local var_131_22 = var_131_21
		local var_131_23 = var_131_20
		local var_131_24 = var_131_19
		local var_131_25 = var_131_18

		return generate_spawns, var_131_25, var_131_24, var_131_23, var_131_22
	else
		print("This level is missing spawn_zones. No roaming enemies will spawn at all.")
	end

	return {}
end

ConflictDirector.register_main_path_obstacle = function (self, arg_132_1, arg_132_2)
	-- function 132
	local _main_path_obstacles = self._main_path_obstacles

	_main_path_obstacles[#_main_path_obstacles + 1] = {
		position = arg_132_1,
		radius_sq = arg_132_2
	}
end

ConflictDirector.ai_ready = function (self, arg_133_1)
	-- function 133
	self.enemy_package_loader = Managers.level_transition_handler.enemy_package_loader

	print("CurrentConflictSettings", self.current_conflict_settings)

	if not CurrentConflictSettings.disabled then
		Managers.state.event:trigger("conflict_director_setup_done")

		return
	end

	print("[ConflictDirector] conflict_director is ai_ready")

	self.level_settings = LevelHelper:current_level_settings()
	self.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self.patrol_analysis = PatrolAnalysis:new(self.nav_world, false, QuickDrawerStay)

	Managers.state.entity:system("ai_group_system"):ai_ready(self.patrol_analysis)

	if not USE_ENGINE_SLOID_SYSTEM then
		fassert(EngineOptimized.init_sloid_system, "You are running the wrong executable. sloid_system is missing")

		self.sloid_broadphase = Broadphase(1, 128)

		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local traverse_logic = Managers.state.entity:system("ai_slot_system"):traverse_logic()

		EngineOptimized.init_sloid_system(self._world, self.sloid_broadphase, broadphase, self.nav_world, traverse_logic)

		self.dogpiled_attackers_on_unit = {}
	else
		local traverse_logic_2 = Managers.state.entity:system("ai_slot_system"):traverse_logic()

		self.gathering = Gathering:new(self.nav_world, traverse_logic_2)
	end

	self.nav_tag_volume_handler = NavTagVolumeHandler:new(self._world, self.nav_world)
	self.level_analysis.nav_world = self.nav_world
	self.level_analysis.level_settings = self.level_settings
	self.spawn_zone_baker = SpawnZoneBaker:new(self._world, self.nav_world, self.level_analysis, arg_133_1)

	local zones = self.spawn_zone_baker.zones
	local num_main_zones = self.spawn_zone_baker.num_main_zones
	local var_133_5 = fn(zones, num_main_zones)

	self._peak_delayer = PeakDelayer:new(var_133_5)
	self.spawn_zone_baker.zones = Managers.state.game_mode._mutator_handler:tweak_zones(self.current_conflict_settings, zones, self.spawn_zone_baker.num_main_zones)

	if not self.spawn_zone_baker:loaded_spawn_zones_available() then
		-- Nothing
	else
		local generate_main_path = self.level_analysis:generate_main_path()

		self.level_analysis:remove_crossroads_extra_path_branches()

		if generate_main_path ~= "success" then
			Debug.sticky_text("Level fail: %s", generate_main_path, "delay", 20)

			return
		end
	end

	self.main_path_info.main_paths = self.level_analysis:get_main_paths()

	local num = 3
	local node_list_from_main_paths, var_133_9, var_133_10, var_133_11 = MainPathUtils.node_list_from_main_paths(self.nav_world, self.main_path_info.main_paths, num, self._main_path_obstacles)

	self.main_path_info.merged_main_paths = {
		forward_list = node_list_from_main_paths,
		reversed_list = var_133_9,
		forward_break_list = var_133_10,
		reversed_break_list = var_133_11
	}
	self.specials_pacing = SpecialsPacing:new(self._world, self.nav_world, self.nav_tag_volume_handler, self._enemy_side)

	local tbl = {
		self.level_analysis:get_start_and_finish()
	}

	fassert(tbl, "The path marker at the start of level is outside nav mesh")

	self._spawn_pos_list, self._pack_sizes, self._pack_rotations, self.pack_members, self._zone_data_list = self:generate_spawns()

	if not flag then
		self:ai_nav_groups_ready(arg_133_1)
	end

	if not LevelHelper:should_load_enemies(self._level_key) then
		self.breed_freezer = BreedFreezer:new(self._world, Managers.state.entity, self._network_event_delegate, self.enemy_package_loader)
	end
end

ConflictDirector.ai_nav_groups_ready = function (self, arg_134_1)
	-- function 134
	self.enemy_recycler = EnemyRecycler:new(self._world, self.nav_world, self._spawn_pos_list, self._pack_sizes, self._pack_rotations, self.pack_members, self._zone_data_list, arg_134_1)

	self.level_analysis:set_enemy_recycler(self.enemy_recycler)

	self.horde_spawner = HordeSpawner:new(self._world, self.level_analysis.cover_points_broadphase)

	if not (not self.spawn_zone_baker:loaded_spawn_zones_available() and not CurrentBossSettings and CurrentBossSettings.disabled) then
		self.level_analysis:generate_boss_paths()
	end

	local main_paths = self.main_path_info.main_paths

	self.navigation_group_manager:assign_main_path_indexes(main_paths)

	self.in_safe_zone = true
	self.director_is_ai_ready = true

	Managers.state.event:trigger("conflict_director_setup_done")
	self:create_debug_list()
end

ConflictDirector.a_star_area_pos_search = function (self, arg_135_1, arg_135_2)
	-- function 135
	local get_seed_triangle = GwNavTraversal.get_seed_triangle(self.nav_world, arg_135_1)
	local get_seed_triangle_2 = GwNavTraversal.get_seed_triangle(self.nav_world, arg_135_2)

	if not (not get_seed_triangle and get_seed_triangle_2) then
		return false
	end

	local get_polygon_group = self.navigation_group_manager:get_polygon_group(get_seed_triangle)
	local get_polygon_group_2 = self.navigation_group_manager:get_polygon_group(get_seed_triangle_2)

	if not get_polygon_group and not get_polygon_group_2 then
		local a_star_cached, var_135_5 = self.navigation_group_manager:a_star_cached(get_polygon_group, get_polygon_group_2)

		return a_star_cached, var_135_5
	end
end

ConflictDirector.freeze_intensity_decay = function (self, arg_136_1)
	-- function 136
	self.frozen_intensity_decay_until = self._time + arg_136_1
end

ConflictDirector.intensity_decay_frozen = function (self, arg_137_1)
	-- function 137
	return self._time < self.frozen_intensity_decay_until
end

ConflictDirector.boss_event_running = function (self, arg_138_1)
	-- function 138
	arg_138_1 = arg_138_1 or self.default_enemy_side_id

	local num_spawned_by_breed = self._conflict_data_by_side[arg_138_1].num_spawned_by_breed

	return num_spawned_by_breed.skaven_rat_ogre > 0 or num_spawned_by_breed.skaven_stormfiend > 0 or num_spawned_by_breed.chaos_troll > 0 or num_spawned_by_breed.chaos_spawn > 0 or num_spawned_by_breed.beastmen_minotaur > 0 or num_spawned_by_breed.chaos_troll_chief > 0
end

ConflictDirector.angry_boss = function (self)
	-- function 139
	return self._num_angry_bosses > 0
end

ConflictDirector.add_angry_boss = function (self, arg_140_1, arg_140_2)
	-- function 140
	self._num_angry_bosses = math.clamp(self._num_angry_bosses + arg_140_1, 0, 255)

	if not arg_140_2 then
		AiUtils.activate_unit(arg_140_2)
	end
end

ConflictDirector.level_flow_event = function (self, arg_141_1)
	-- function 141
	LevelHelper:flow_event(self._world, arg_141_1)
end

ConflictDirector.jslots = function (arg_142_0, arg_142_1, arg_142_2)
	-- function 142
	local var_142_0 = POSITION_LOOKUP[arg_142_1]
	local var_142_1 = POSITION_LOOKUP[arg_142_1]
end

ConflictDirector.update_server_debug = function (self, arg_143_1, arg_143_2)
	-- function 143
	local _hero_side = self._hero_side
	local flag = not _hero_side and _hero_side.PLAYER_POSITIONS

	if not script_data.debug_zone_baker_on_screen then
		self.spawn_zone_baker:draw_zone_info_on_screen()
	end

	if not script_data.debug_current_threat_value then
		local get_threat_value, var_143_3 = self:get_threat_value()

		Debug.text("DELAY: HORDE %s, SPECIALS %s, MINI_PATROL %s, Threat value: %.2f, num aggroed: %d", tostring(self.delay_horde), tostring(self.delay_specials), tostring(self.delay_mini_patrol), get_threat_value, var_143_3)
	end

	if not script_data.show_current_conflict_settings then
		Debug.text("Current ConflictSettings [%s]", CurrentConflictSettings.name)
	end

	if not script_data.debug_conflict_director_breeds then
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local var_143_5 = CurrentConflictSettings.contained_breeds[get_difficulty]

		Debug.text("Conflict Director Breeds:")

		for k, v in pairs(var_143_5) do
			Debug.text("   %s", k)
		end
	end

	if not DebugKeyHandler.key_pressed("t", "test terror", "ai", "left shift") then
		print("Pressed t")

		if not ConflictDirectorTests.start_test(self, arg_143_1, arg_143_2) then
			return
		end
	end

	local var_143_6 = fn_3()

	if var_143_6:get("wield_7") or not var_143_6:get("keyboard_7") then
		Debug.sticky_text("{#color(200,200,200)} debug_spawn_side: {#color(200,0,0)} %d {#reset()}", 1, "delay", 2)
		self:set_debug_spawn_side(1)
	end

	if var_143_6:get("wield_8") or not var_143_6:get("keyboard_8") then
		Debug.sticky_text("{#color(200,200,200)} debug_spawn_side: {#color(0,0,200)} %d {#reset()}", 2, "delay", 2)
		self:set_debug_spawn_side(2)
	end

	if not DebugKeyHandler.key_pressed("f", "toggle debug graphs", "ai", "left shift") then
		local count = #self._debug_list

		for k_2 = 2, count do
			self._debug_list[k_2]:show_debug(false)
		end

		for l = 1, count do
			local num = self._current_debug_list_index % count + 1

			if num == 1 then
				self._current_debug_list_index = num

				break
			elseif not self._debug_list[num]:show_debug(true) then
				self._current_debug_list_index = num

				break
			end
		end

		print("toggle debug graphs:", self._current_debug_list_index)
	end

	if not DebugKeyHandler.key_pressed("g", "execute debug graphs", "ai", "left shift") then
		local var_143_9 = self._debug_list[self._current_debug_list_index]

		if not var_143_9 and type(var_143_9) ~= "table" or not var_143_9.execute_debug then
			var_143_9:execute_debug()
		end
	end

	if not script_data.show_alive_ai then
		local var_143_10 = self._conflict_data_by_side[self.default_enemy_side_id]

		ConflictUtils.display_number_of_breeds("TOTAL: ", #var_143_10.spawned, var_143_10.num_spawned_by_breed)

		if not self.running_master_event then
			local num_2 = 0

			for k_3, v_2 in pairs(var_143_10.num_spawned_by_breed_during_event) do
				num_2 = num_2 + v_2
			end

			ConflictUtils.display_number_of_breeds("EVENT: ", num_2, var_143_10.num_spawned_by_breed_during_event)
		end
	end

	if not script_data.show_where_ai_is then
		local var_143_12 = self._conflict_data_by_side[self.default_enemy_side_id]

		ConflictUtils.show_where_ai_is(var_143_12.spawned)
	end

	if not DebugKeyHandler.key_pressed("o", "draw spawn zones", "ai", "left shift") then
		local draw_all_zones = self.draw_all_zones

		draw_all_zones = (draw_all_zones ~= nil or not "all" or draw_all_zones ~= "all") and (not "last" or (draw_all_zones ~= "last" or not "last_naive" or draw_all_zones ~= "last_naive") and nil)

		if draw_all_zones == "all" then
			self.spawn_zone_baker:draw_zones(self.nav_world)
		elseif draw_all_zones == "last_naive" then
			-- Nothing
		elseif draw_all_zones == "last" then
			-- Nothing
		else
			self.spawn_zone_baker:draw_zones(self.nav_world)
		end

		self.draw_all_zones = draw_all_zones
	end

	local draw_all_zones_2 = self.draw_all_zones

	if draw_all_zones_2 ~= "nil" then
		if draw_all_zones_2 == "all" then
			Debug.text("Draw Zone-segment (all)")
		elseif draw_all_zones_2 == "last" then
			local get_main_paths = self.level_analysis:get_main_paths()
			local ahead_travel_dist = self.main_path_info.ahead_travel_dist

			ahead_travel_dist = ahead_travel_dist or 0

			local get_zone_segment_from_travel_dist = self.spawn_zone_baker:get_zone_segment_from_travel_dist(ahead_travel_dist)

			if not get_zone_segment_from_travel_dist then
				Debug.text("Draw Zone-segment: %d (last) travel_dist: %.1f", get_zone_segment_from_travel_dist, ahead_travel_dist)
				self.spawn_zone_baker:draw_zones(self.nav_world, get_zone_segment_from_travel_dist)
			else
				Debug.text("Draw Zone-segment not precalculated (last)")
			end
		elseif draw_all_zones_2 == "last_naive" then
			local get_main_paths_2 = self.level_analysis:get_main_paths()
			local zone_segment_on_mainpath = MainPathUtils.zone_segment_on_mainpath(get_main_paths_2, flag[1])

			self.spawn_zone_baker:draw_zones(self.nav_world, zone_segment_on_mainpath)
			Debug.text("Draw Zone-segment: %d (last_naive)", zone_segment_on_mainpath)
		end
	end

	if not script_data.debug_ai_pacing then
		local PLAYER_AND_BOT_UNITS = self._hero_side.PLAYER_AND_BOT_UNITS

		if not DebugKeyHandler.key_pressed("numpad_plus", "Increase intensity +25", "Pacing & Intensity") then
			self.pacing:debug_add_intensity(PLAYER_AND_BOT_UNITS, 25)
		end

		if not DebugKeyHandler.key_pressed("numpad_minus", "Decrease intensity -25", "Pacing & Intensity") then
			self.pacing:debug_add_intensity(PLAYER_AND_BOT_UNITS, -25)
		end

		local var_143_21 = self._conflict_data_by_side[self.default_enemy_side_id]

		Debug.text("Total enemies alive: " .. tostring(#var_143_21.spawned))
	end

	if not script_data.debug_rush_intervention then
		local rushing_intervention_data = self.rushing_intervention_data

		if not ALIVE[rushing_intervention_data.ahead_unit] then
			rushing_intervention_data.ahead_unit_name = Managers.player:unit_owner(rushing_intervention_data.ahead_unit):profile_display_name()
		else
			rushing_intervention_data.ahead_unit_name = "?"
		end

		local clamp = math.clamp(self._next_rushing_intervention_time - arg_143_1, 0, 999999)
		local rush_intervention = CurrentSpecialsSettings.rush_intervention

		if not rushing_intervention_data.disabled then
			Debug.text("Rusher: %s ", rushing_intervention_data.disabled)
		else
			Debug.text("Rusher: %s loneliness: %.1f / ( special: %.1f, horde: %.1f ) (%s) ahead-dist: %.1f, time: %.1f ", rushing_intervention_data.ahead_unit_name, rushing_intervention_data.loneliness_value, rush_intervention.loneliness_value_for_special, rush_intervention.loneliness_value_for_ambush_horde, tostring(rushing_intervention_data.message), rushing_intervention_data.ahead_dist, clamp)
		end
	end

	if not (not DebugKeyHandler.key_pressed("h", "spawn_horde", "ai") and DamageUtils.is_in_inn) then
		self:debug_spawn_horde()
	end

	if not DebugKeyHandler.key_pressed("a", "force target switch", "ai", "left shift") then
		local debug_unit = script_data.debug_unit

		if not ALIVE[debug_unit] then
			ScriptUnit.extension(debug_unit, "ai_system"):blackboard().target_changed = true
		end
	end

	if not script_data.debug_ai_pacing then
		for k_4, v_3 in pairs(self._rushing_checks) do
			ConflictUtils.draw_stack_of_balls(v_3.start_pos:unbox(), 255, 255, 30, 0)

			local var_143_26 = self.main_path_player_info[k_4]

			if not var_143_26 and not var_143_26.path_pos then
				ConflictUtils.draw_stack_of_balls(var_143_26.path_pos:unbox(), 255, 30, 255, 0)
			end
		end
	end

	if not script_data.debug_near_cover_points then
		ConflictUtils.hidden_cover_points(flag[1], flag, 1, 35, nil)
	end

	if not script_data.debug_player_positioning then
		local _enemy_side = self._enemy_side
		local get_cluster_and_loneliness, var_143_29, var_143_30, var_143_31 = self:get_cluster_and_loneliness(10, _enemy_side.ENEMY_PLAYER_POSITIONS, _enemy_side.ENEMY_PLAYER_UNITS)

		if not var_143_31 then
			QuickDrawer:sphere(POSITION_LOOKUP[var_143_31], 0.88)
		end

		local num_3 = 7
		local PLAYER_AND_BOT_POSITIONS = self._hero_side.PLAYER_AND_BOT_POSITIONS
		local cluster_positions, var_143_35 = ConflictUtils.cluster_positions(PLAYER_AND_BOT_POSITIONS, num_3)

		for i8 = 1, #cluster_positions do
			QuickDrawer:sphere(cluster_positions[i8], num_3)

			for i9 = 1, var_143_35[i8] do
				QuickDrawer:sphere(cluster_positions[i8] + Vector3(0, 0, 2 + i9), 0.6)
			end
		end

		local main_path_info = self.main_path_info
		local ahead_unit = main_path_info.ahead_unit
		local num_4 = 0

		if not ahead_unit then
			local var_143_39 = self.main_path_player_info[ahead_unit]

			num_4 = self._rushing_intervention_travel_dist - var_143_39.travel_dist

			local unbox = var_143_39.path_pos:unbox()
			local var_143_41 = Color(0, 200, 30)
			local var_143_42 = POSITION_LOOKUP[ahead_unit]
			local num_5 = unbox + Vector3(0, 0, 0.5)
			local num_6 = unbox + Vector3(0, 0, 1)
			local num_7 = unbox + Vector3(0, 0, 1.5)

			QuickDrawer:cone(unbox, num_5, 0.3, var_143_41, 8, 8)
			QuickDrawer:cone(num_5, num_6, 0.3, var_143_41, 8, 8)
			QuickDrawer:cone(num_6, num_7, 0.3, var_143_41, 8, 8)
			QuickDrawer:cone(var_143_42, var_143_42 + Vector3(0, 0, 2), 0.3, var_143_41, 8, 8)
			QuickDrawer:line(var_143_42 + Vector3(0, 0, 1), unbox + Vector3(0, 0, 1), var_143_41)

			local num_8 = main_path_info.ahead_percent * 100
			local num_9 = self._next_progression_percent * 100

			Debug.text("Ahead unit travel dist: %.1f, progression %d/%d", var_143_39.travel_dist, num_8, num_9)
		end

		local behind_unit = main_path_info.behind_unit

		if not behind_unit then
			local unbox_2 = self.main_path_player_info[behind_unit].path_pos:unbox()
			local var_143_50 = Color(200, 200, 0)
			local var_143_51 = POSITION_LOOKUP[behind_unit]
			local num_10 = unbox_2 + Vector3(0, 0, 0.5)
			local num_11 = unbox_2 + Vector3(0, 0, 1)
			local num_12 = unbox_2 + Vector3(0, 0, 1.5)

			QuickDrawer:cone(unbox_2, num_10, 0.3, var_143_50, 8, 7)
			QuickDrawer:cone(num_10, num_11, 0.3, var_143_50, 8, 7)
			QuickDrawer:cone(num_11, num_12, 0.3, var_143_50, 8, 7)
			QuickDrawer:cone(var_143_51, var_143_51 + Vector3(0, 0, 2), 0.3, var_143_50, 8, 8)
			QuickDrawer:line(var_143_51 + Vector3(0, 0, 1), unbox_2 + Vector3(0, 0, 1), var_143_50)
		end

		local num_13 = self._next_rushing_intervention_time - arg_143_1

		Debug.text("cluster-utility: %s, lone-value: %.1f, intervention dist: %.1f, intervention timer: %.1f", tostring(get_cluster_and_loneliness), var_143_30, num_4, num_13)
	end
end

ConflictDirector.client_ready = function (self)
	-- function 144
	if not LevelHelper:should_load_enemies(self._level_key) then
		local enemy_package_loader = Managers.level_transition_handler.enemy_package_loader

		self.breed_freezer = BreedFreezer:new(self._world, Managers.state.entity, self._network_event_delegate, enemy_package_loader)
	end
end

ConflictDirector.update_client = function (arg_145_0, arg_145_1, arg_145_2)
	-- function 145
	return
end

ConflictDirector.hot_join_sync = function (self, arg_146_1)
	-- function 146
	if not self.breed_freezer then
		self.breed_freezer:hot_join_sync(arg_146_1)
	end
end

ConflictDirector.set_peaks = function (self, arg_147_1)
	-- function 147
	self._peak_delayer:set_peaks(arg_147_1)
end

ConflictDirector.get_peaks = function (self)
	-- function 148
	return self._peak_delayer:get_peaks()
end

ConflictDirector.is_near_or_in_a_peak = function (self)
	-- function 149
	return self._peak_delayer:is_near_or_in_a_peak()
end

ConflictDirector.spawn_breed_func = function (self, arg_150_1)
	-- function 150
	local _debug_spawn_breed_enhancements = self._debug_spawn_breed_enhancements

	if not _debug_spawn_breed_enhancements and not next(_debug_spawn_breed_enhancements) then
		self:debug_spawn_variant(arg_150_1, _debug_spawn_breed_enhancements)

		return true
	end
end

ConflictDirector.debug_spawn_variant = function (self, arg_151_1, arg_151_2, arg_151_3)
	-- function 151
	local var_151_0 = Breeds[arg_151_1]

	if not arg_151_2 then
		local generate_enhanced_breed_from_set = TerrorEventUtils.generate_enhanced_breed_from_set(arg_151_2)
		local tbl = {
			enhancements = generate_enhanced_breed_from_set
		}

		return self:aim_spawning(var_151_0, false, nil, nil, tbl)
	elseif not arg_151_3 then
		local generate_enhanced_breed = TerrorEventUtils.generate_enhanced_breed(arg_151_3, arg_151_1, BossGrudgeMarks)
		local tbl_2 = {
			enhancements = generate_enhanced_breed
		}

		return self:aim_spawning(var_151_0, false, nil, nil, tbl_2)
	end

	return var_151_0
end

ConflictDirector.world = function (self)
	-- function 152
	return self._world
end

ConflictDirector.debug_spawn_encampment = function (self, arg_153_1)
	-- function 153
	local mirrored_encampment_spawning = Managers.state.debug.debug_breed_picker.mirrored_encampment_spawning
	local player_aim_raycast, var_153_2, var_153_3, var_153_4, var_153_5 = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")

	if not player_aim_raycast then
		print("No spawn pos found")

		return
	end

	local var_153_6 = EncampmentTemplates[arg_153_1]
	local var_153_7 = Vector3(var_153_5[1], var_153_5[2], 0)
	local look = Quaternion.look(var_153_7)
	local random = math.random(1, #var_153_6.unit_compositions)
	local var_153_10 = var_153_6.unit_compositions[random]
	local make_encampment = FormationUtils.make_encampment(var_153_6)
	local flag

	flag = not mirrored_encampment_spawning and 1 and self.debug_spawn_side_id

	FormationUtils.spawn_encampment(make_encampment, player_aim_raycast, look, var_153_10, flag)

	if not mirrored_encampment_spawning then
		local look_2 = Quaternion.look(-var_153_7)
		local random_2 = math.random(1, #var_153_6.unit_compositions)
		local var_153_15 = var_153_6.unit_compositions[random_2]
		local make_encampment_2 = FormationUtils.make_encampment(var_153_6)

		FormationUtils.spawn_encampment(make_encampment_2, player_aim_raycast + Quaternion.rotate(look_2, Vector3(0, -8, 0)), look_2, var_153_15, 2)
	end
end

ConflictDirector.spawn_encampment = function (self, arg_154_1)
	-- function 154
	print("spawn_encampent")

	local player_aim_raycast, var_154_1, var_154_2, var_154_3, var_154_4 = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")

	if not (not player_aim_raycast and var_154_4) then
		print("No spawn pos found")

		return
	end

	local look = Quaternion.look(-Vector3(var_154_4[1], var_154_4[2], 0))

	look = look or Quaternion.look(Vector3(0, 1, 0))

	local var_154_6 = EncampmentTemplates[arg_154_1]
	local random = math.random(1, #var_154_6.unit_compositions)
	local var_154_8 = var_154_6.unit_compositions[random]
	local var_154_9 = EncampmentTemplates[arg_154_1]
	local make_encampment = FormationUtils.make_encampment(var_154_9)

	FormationUtils.spawn_encampment(make_encampment, player_aim_raycast, look, var_154_8, self.debug_spawn_side_id)
end

ConflictDirector.pick_enhancement = function (arg_155_0, arg_155_1)
	-- function 155
	print("Picked:", arg_155_1)
end
