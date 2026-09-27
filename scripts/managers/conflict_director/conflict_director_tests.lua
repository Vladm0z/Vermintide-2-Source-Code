-- chunkname: @scripts/managers/conflict_director/conflict_director_tests.lua

ConflictDirectorTests = {}

local flag = false

ConflictDirectorTests.start_utility_comparison = function ()
	-- function 1
	flag = true
end

local function fn()
	-- function 2
	local distance_to_target = UtilityConsiderations.storm_vermin_push_attack.distance_to_target
	local num = 0.7
	local utility_from_spline = EngineOptimized.utility_from_spline
	local var_2_3

	for i = 1, 1000 do
		local var_2_4 = utility_from_spline(distance_to_target.engine_spline_index, num)
	end

	local clamp = math.clamp(num / distance_to_target.max_value, 0, 1)
	local GetUtilityValueFromSpline = Utility.GetUtilityValueFromSpline

	for j = 1, 1000 do
		local var_2_7 = GetUtilityValueFromSpline(distance_to_target.spline, clamp)
	end
end

local function fn_2(self, arg_3_1)
	-- function 3
	local var_3_0 = Vector3(0, 0, 0)
	local huge = math.huge
	local num = -1
	local unbox = self[1]:unbox()

	for i = 1, #self - 1 do
		local unbox_2 = self[i + 1]:unbox()
		local closest_point_on_line = Geometry.closest_point_on_line(arg_3_1, unbox, unbox_2)
		local distance_squared = Vector3.distance_squared(arg_3_1, closest_point_on_line)

		if distance_squared < huge then
			huge = distance_squared
			num = i

			Vector3.set_xyz(var_3_0, Vector3.to_elements(closest_point_on_line))
		end

		unbox = unbox_2
	end

	Debug.text("SS: %.2f %d, %s", huge, num, tostring(var_3_0))

	return var_3_0
end

local flag_2 = false
local flag_3 = false

ConflictDirectorTests.test_main_path_optimization = function (self, arg_4_1, arg_4_2)
	-- function 4
	local main_paths = self.main_path_info.main_paths

	if not main_paths then
		return
	end

	local num = 100

	if not flag_2 then
		local point_on_mainpath = MainPathUtils.point_on_mainpath(main_paths, 10)
		local closest_pos_at_main_path, var_4_4, var_4_5, var_4_6, var_4_7 = MainPathUtils.closest_pos_at_main_path(main_paths, point_on_mainpath)
		local total_path_dist = MainPathUtils.total_path_dist()

		flag_2 = {
			Vector3Box(point_on_mainpath)
		}

		for i = 2, num do
			local num_2 = total_path_dist / num * i
			local point_on_mainpath_2, var_4_11 = MainPathUtils.point_on_mainpath(main_paths, num_2)

			if not point_on_mainpath_2 then
				point_on_mainpath_2 = flag_2[1]:unbox()

				local num_3 = 1
			end

			local num_4 = #flag_2 + 1

			flag_2[num_4] = Vector3Box(point_on_mainpath_2)
		end
	end

	local main_path_info = self.main_path_info
	local closest_pos_at_collapsed_main_path = MainPathUtils.closest_pos_at_collapsed_main_path
	local point_on_mainpath_3 = MainPathUtils.point_on_mainpath
	local main_path_data = self.level_analysis.main_path_data
	local count = #main_path_data.collapsed_path
	local unbox = main_path_data.collapsed_path[count]:unbox()

	QuickDrawer:sphere(unbox, 10 + math.sin(arg_4_1 * 5) * 5)
	Debug.text("DISTANCE point: %d, distance %.1f", count, main_path_data.collapsed_travel_dists[count])

	for j = 1, num do
		closest_pos_at_collapsed_main_path(main_path_data.collapsed_path, main_path_data.collapsed_travel_dists, main_path_data.breaks_lookup, unbox, count)
	end

	local closest_pos_at_main_path_2 = EngineOptimized.closest_pos_at_main_path
	local point_on_mainpath_4 = EngineOptimized.point_on_mainpath

	for k = 1, num do
		closest_pos_at_main_path_2(unbox)
	end

	local var_4_22 = self.hero_player_positions[1]
	local var_4_23 = Vector3(100, 20, 130)
	local var_4_24 = Vector3(-100, -420, 30)
	local var_4_25
	local closest_point_on_line = EngineOptimized.closest_point_on_line

	for l = 1, 250 do
		local var_4_27 = closest_point_on_line(var_4_22, var_4_23, var_4_24)
	end

	local closest_point_on_line_2 = Geometry.closest_point_on_line

	for i4 = 1, 250 do
		local var_4_29 = closest_point_on_line_2(var_4_22, var_4_23, var_4_24)
	end

	local collapsed_path = self.level_analysis.main_path_data.collapsed_path
	local var_4_31 = fn_2(collapsed_path, var_4_22)
	local closest_pos_at_main_path_3, var_4_33, var_4_34 = EngineOptimized.closest_pos_at_main_path(var_4_22)
	local closest_pos_at_main_path_lua, var_4_36, var_4_37 = MainPathUtils.closest_pos_at_main_path_lua(main_paths, var_4_22)

	QuickDrawer:sphere(closest_pos_at_main_path_3, 1.05, Color(255, 0, 0))
	QuickDrawer:sphere(var_4_31, 1.2, Color(255, 255, 0))
	QuickDrawer:sphere(closest_pos_at_main_path_lua, 0.9, Color(155, 155, 255))
	QuickDrawer:line(collapsed_path[1]:unbox(), collapsed_path[2]:unbox(), Color(100, 255, 0))

	local random = math.random()
end

function test_spawn_pos_ahead_half_sphere(self)
	-- function 5
	local main_path_info = self.main_path_info
	local ahead_unit = main_path_info.ahead_unit

	if not ahead_unit then
		local var_5_2 = POSITION_LOOKUP[ahead_unit]
		local get_relative_main_path_pos = self.specials_pacing:get_relative_main_path_pos(main_path_info.main_paths, self.main_path_player_info[ahead_unit], 20)

		QuickDrawer:cone(var_5_2, var_5_2 + Vector3(0, 0, 2.5), 1, Color(200, 200, 0), 8, 8)

		local num = get_relative_main_path_pos - var_5_2
		local num_2 = 25
		local current_level = LevelHelper:current_level(self._world)
		local nav_tag_volume_handler = self.nav_tag_volume_handler

		for i = 1, 25 do
			local get_hidden_pos = ConflictUtils.get_hidden_pos(self._world, self.nav_world, current_level, nav_tag_volume_handler, true, get_relative_main_path_pos, self.hero_player_and_bot_positions, 30, 10, num_2, 10, num, math.pi)

			if not get_hidden_pos then
				QuickDrawer:sphere(get_hidden_pos, 1)
			end
		end
	end
end

function test_umbra_los(self)
	-- function 6
	local _world = self._world

	if not World.umbra_available(_world) then
		return
	end

	local main_path_info = self.main_path_info
	local ahead_unit = main_path_info.ahead_unit
	local behind_unit = main_path_info.behind_unit

	if not ahead_unit and not behind_unit then
		local var_6_4 = POSITION_LOOKUP[ahead_unit]
		local var_6_5 = POSITION_LOOKUP[behind_unit]
		local var_6_6 = Vector3(0, 0, 1)

		if not World.umbra_has_line_of_sight(_world, var_6_4 + var_6_6, var_6_5 + var_6_6) then
			QuickDrawer:line(var_6_4 + var_6_6, var_6_5 + var_6_6, Color(0, 90, 200))
		else
			QuickDrawer:line(var_6_4 + var_6_6, var_6_5 + var_6_6, Color(255, 0, 0))
		end
	end
end

function debug_bot_transitions(arg_7_0, arg_7_1)
	-- function 7
	local system = Managers.state.entity:system("ai_system")
	local ai_debugger = system.ai_debugger

	ai_debugger = not ai_debugger and system.ai_debugger.screen_gui

	AiUtils.debug_bot_transitions(ai_debugger, arg_7_1, 0, 0)
end

function test_player_path_pos_and_50m_ahead(self)
	-- function 8
	local var_8_0 = self.hero_player_positions[1]
	local main_paths = self.level_analysis.main_paths
	local closest_pos_at_main_path, var_8_3 = MainPathUtils.closest_pos_at_main_path(main_paths, var_8_0)
	local total_path_dist = MainPathUtils.total_path_dist()
	local point_on_mainpath = MainPathUtils.point_on_mainpath(main_paths, var_8_3 + 10)

	point_on_mainpath = point_on_mainpath or MainPathUtils.point_on_mainpath(main_paths, total_path_dist - 10)

	QuickDrawer:sphere(point_on_mainpath, 3)

	local point_on_mainpath_2 = MainPathUtils.point_on_mainpath(main_paths, total_path_dist - 50)

	if not point_on_mainpath_2 then
		QuickDrawer:sphere(point_on_mainpath_2, 2.5, Color(255, 120, 0, 0))
	end
end

function test_angled_trajectory(self)
	-- function 9
	local var_9_0 = Vector3(0, 0, 2)
	local var_9_1 = Vector3(19, 16, 2)
	local get_data = World.get_data(self._world, "physics_world")
	local num = -9.82
	local var_9_4
	local degrees_to_radians = math.degrees_to_radians(45)
	local test_angled_trajectory, var_9_7, var_9_8 = WeaponHelper.test_angled_trajectory(get_data, var_9_0, var_9_1, num, var_9_4, degrees_to_radians)

	QuickDrawer:sphere(var_9_0, 1)
	QuickDrawer:sphere(var_9_1, 1)
	Debug.text("Trajectory Success: " .. tostring(test_angled_trajectory))
end

ConflictDirectorTests.setup_reachable_coverpoints_test = function (self)
	-- function 10
	local tbl = {}
	local hidden_cover_points, var_10_2 = ConflictUtils.hidden_cover_points(self.hero_player_positions[1], self.hero_player_positions, 2, 45, 1)

	for i = 1, hidden_cover_points do
		tbl[i] = Vector3Box(Unit.local_position(var_10_2[i], 0))
	end

	self._reachable_processing = LevelAnalysis.setup_unreachable_processing(self.nav_world, self.main_path_info.main_paths, tbl, {
		max_concurrent_astars = 5,
		line_object = QuickDrawerStay
	})

	print("Points to test:", hidden_cover_points)
end

ConflictDirectorTests.process_reachable_coverpoints_test = function (self)
	-- function 11
	if not self._reachable_processing and not self.level_analysis.process_unreachable(self._reachable_processing) then
		self._reachable_processing = nil

		print("astar connect complete")
	end
end

function setup_reachable_navgraph_test(self)
	-- function 12
	local tbl = {}
	local level_key = Managers.state.game_mode:level_key()
	local level_name = LevelSettings[level_key].level_name
	local unit_indices = LevelResource.unit_indices(level_name, "core/gwnav/units/seedpoint/seedpoint")

	for i, v in ipairs(unit_indices) do
		tbl[#tbl + 1] = Vector3Box(LevelResource.unit_position(level_name, v))
	end

	self._reachable_navgraph_processing = LevelAnalysis.setup_unreachable_processing(self.nav_world, self.main_path_info.main_paths, tbl, {
		max_concurrent_astars = 5,
		line_object = QuickDrawerStay,
		fail_color = Color(212, 48, 0)
	})

	print("Points to test:", #tbl)
end

function process_reachable_navgraph_test(self)
	-- function 13
	if not self._reachable_navgraph_processing and not self.level_analysis.process_unreachable(self._reachable_navgraph_processing) then
		self._reachable_navgraph_processing = nil

		print("astar connect complete")
	end
end

function print_point(self)
	-- function 14
	print("(" .. self.x .. ", " .. self.y .. ")")

	return nil
end

function print_points(self, arg_15_1)
	-- function 15
	print("[")

	for i = 1, arg_15_1 do
		local var_15_0 = self[i]

		if i > 1 then
			print(", ")
		end

		print_point(var_15_0)
	end

	print("]")

	return nil
end

function ccw(self, arg_16_1, arg_16_2)
	-- function 16
	return (arg_16_1.x - self.x) * (arg_16_2.y - self.y) > (arg_16_1.y - self.y) * (arg_16_2.x - self.x)
end

local function fn_3(self, arg_17_1)
	-- function 17
	return self.x < arg_17_1.x
end

function convex_hull(self, arg_18_1)
	-- function 18
	local count = #self

	if count == 0 then
		return arg_18_1, 0
	end

	table.sort(self, fn_3)

	local num = 0

	for i = 1, count do
		local var_18_2 = self[i]

		while not (not (num >= 2) or ccw(arg_18_1[num - 1], arg_18_1[num], var_18_2)) do
			num = num - 1
		end

		num = num + 1
		arg_18_1[num] = var_18_2
	end

	local num_2 = num + 1

	for j = count, 1, -1 do
		local var_18_4 = self[j]

		while not (not (num_2 <= num) or ccw(arg_18_1[num - 1], arg_18_1[num], var_18_4)) do
			num = num - 1
		end

		num = num + 1
		arg_18_1[num] = var_18_4
	end

	local num_3 = num - 1

	return arg_18_1, num_3
end

function make_points_for_hull_test()
	-- function 19
	local units_lookup = Managers.state.side:get_side(Managers.state.conflict.default_enemy_side_id).units_lookup
	local clone = table.clone(units_lookup)

	for k, v in pairs(units_lookup) do
		if not HEALTH_ALIVE[k] then
			clone[#clone + 1] = POSITION_LOOKUP[k]
		end
	end

	return clone
end

ConflictDirectorTests.update_jslots = function (arg_20_0, arg_20_1)
	-- function 20
	local tbl = {
		num = 0,
		slots = {},
		units = {},
		adjusted_dirs = {}
	}
	local var_20_1 = POSITION_LOOKUP[arg_20_1]

	if not var_20_1 then
		return
	end

	local broadphase_query = AiUtils.broadphase_query(var_20_1, 7, RESULT_TABLE)

	for i = 1, broadphase_query do
		local var_20_3 = RESULT_TABLE[i]
		local units = tbl.units

		if not units[var_20_3] then
			local var_20_5 = POSITION_LOOKUP[var_20_3]
			local slots = tbl.slots
			local var_20_7 = slots[1]
			local num = 2
			local num_2 = 1

			if not var_20_7 then
				local normalize = Vector3.normalize(var_20_5 - var_20_1)
				local num_3 = tbl.num + 1

				slots[num_3] = normalize * num
				tbl.num = num_3
				units[var_20_3] = tbl.num
			else
				local normalize_2 = Vector3.normalize(var_20_5 - var_20_1)

				tbl.slots[1] = normalize_2 * num
				tbl.num = 1
				units[var_20_3] = 1
			end
		end
	end

	local slots_2 = tbl.slots
	local adjusted_dirs = tbl.adjusted_dirs

	for j = 1, #slots_2 do
		QuickDrawer:line(var_20_1, var_20_1 + slots_2[j], Color(23, 223, 100))
	end
end

local tbl = {}
local num = 0.3
local num_2 = 0.3

ConflictDirectorTests.draw_sparse_grid = function (self)
	-- function 21
	if not self then
		return
	end

	local floor = math.floor
	local var_21_1 = floor(self.x / num + 0.5)
	local var_21_2 = floor(self.y / num + 0.5)
	local var_21_3 = floor(self.z / num_2 + 0.5)
	local num_3 = var_21_1 * 0.0001 + var_21_2 + var_21_3 * 10000

	QuickDrawer:sphere(Vector3(floor(self.x / num) * num, floor(self.y / num) * num, floor(self.z / num_2) * num_2), num * 0.5 - 0.01, Color(0, 200, 200))
	QuickDrawer:sphere(self, 0.1, Color(255, 200, 100))

	for k, v in pairs(tbl) do
		QuickDrawer:sphere(Vector3(v.x, v.y, v.z), num * 0.5, Color(0, 0, 200))
	end
end

ConflictDirectorTests.sparse_grid_test = function (self, arg_22_1)
	-- function 22
	local floor = math.floor
	local var_22_1 = floor(self.x / num + 0.5)
	local var_22_2 = floor(self.y / num + 0.5)
	local var_22_3 = floor(self.z / num_2 + 0.5)
	local num_3 = var_22_1 * 0.0001 + var_22_2 + var_22_3 * 10000

	if not tbl[num_3] then
		Debug.text("SPARSE GRID: OCCUPIED")
	else
		tbl[num_3] = {
			u = arg_22_1,
			x = var_22_1 * num,
			y = var_22_2 * num,
			z = var_22_3 * num_2
		}

		print("SPARSE GRID:", num_3, self)
		QuickDrawer:sphere(self, 0.7, Color(200, 0, 0))
	end
end

ConflictDirectorTests.lean_slot_test = function ()
	-- function 23
	local num = 10
	local num_2 = 3
	local num_3 = 2 * math.pi / num
	local lean_slots = ConflictDirectorTests.lean_slots
	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	get_side_from_name = get_side_from_name or Managers.state.side:get_side(1)

	local var_23_5 = get_side_from_name.PLAYER_POSITIONS[1]

	if not var_23_5 then
		return
	end

	if not lean_slots then
		local num_4 = lean_slots.lean_dogpile + 1

		if num < num_4 then
			ConflictDirectorTests.lean_slots = nil
		else
			lean_slots.lean_dogpile = num_4

			local num_5 = lean_slots.center_angle + (num_4 - 1) * num_3
			local num_6 = num_2 * 0.5
			local num_7 = math.cos(num_5) * num_6
			local num_8 = math.sin(num_5) * num_6

			lean_slots[num_4] = {
				num_7,
				num_8,
				var_23_5.z
			}
		end
	else
		local num_9 = var_23_5.x + math.random(-5, 5)
		local num_10 = var_23_5.y + math.random(-5, 5)

		QuickDrawerStay:sphere(var_23_5, 0.44, Color(250, 0, 0))
		QuickDrawerStay:sphere(Vector3(num_9, num_10, var_23_5.z), 0.75, Color(0, 0, 255))

		local atan2 = math.atan2(num_10 - var_23_5.y, num_9 - var_23_5.x)
		local num_11 = num_2 * 0.5
		local num_12 = math.cos(atan2) * num_11
		local num_13 = math.sin(atan2) * num_11
		local tbl = {
			{
				num_12,
				num_13,
				var_23_5.z
			},
			lean_dogpile = 1,
			center_angle = atan2
		}

		ConflictDirectorTests.lean_slots = tbl
	end
end

ConflictDirectorTests.lean_slot_test_update = function (self)
	-- function 24
	local lean_slots = ConflictDirectorTests.lean_slots

	if not lean_slots then
		Debug.text("Slots %d", lean_slots.lean_dogpile)

		local var_24_1 = self.PLAYER_POSITIONS[1]

		for i = 1, #lean_slots do
			local var_24_2 = lean_slots[i]

			QuickDrawer:sphere(Vector3(var_24_1.x + var_24_2[1], var_24_1.y + var_24_2[2], var_24_2[3]), 0.5, Color(255, 255, 0))
		end
	end
end

ConflictDirectorTests.drag_test_start = function (self)
	-- function 25
	if not ConflictDirectorTests.drag_test then
		ConflictDirectorTests.drag_test = nil
	else
		local num = self.PLAYER_POSITIONS[1] + Vector3(0, 0, 1.8)
		local num_2 = self.PLAYER_POSITIONS[1] + Vector3(2, 0, 1.8)

		ConflictDirectorTests.drag_test = {
			pole_length = 2,
			apos = Vector3Box(num),
			bpos = Vector3Box(num_2)
		}
	end
end

ConflictDirectorTests.drag_test_update = function (self)
	-- function 26
	if not ConflictDirectorTests.drag_test then
		local drag_test = ConflictDirectorTests.drag_test
		local unbox = drag_test.apos:unbox()
		local unbox_2 = drag_test.bpos:unbox()
		local num = self.PLAYER_POSITIONS[1] + Vector3(0, 0, 1.8)
		local num_2 = num + Vector3.normalize(unbox_2 - num) * drag_test.pole_length

		drag_test.bpos:store(num_2)
		drag_test.apos:store(num)
		QuickDrawer:sphere(num_2, 0.3, Color(0, 200, 40))
		QuickDrawer:line(num_2, num, Color(0, 200, 40))
	end
end

ConflictDirectorTests.tentacle_test_start = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not ConflictDirectorTests.ik_tentacle then
		ConflictDirectorTests.ik_tentacle = nil
	else
		print("Creating tentacle")

		local num = self.PLAYER_POSITIONS[1] + Vector3(1, 0, 0)
		local num_2 = self.PLAYER_POSITIONS[1] + Vector3(0, 0, 1)
		local tbl = {}

		for i = 1, 14 do
			tbl[i] = Vector3(0, 0, i * 0.5)
		end

		ConflictDirectorTests.ik_tentacle = IkChain:new(tbl, num, num_2, 0.01, 0.8)

		ConflictDirectorTests.ik_tentacle:solve(arg_27_1, arg_27_2)
	end
end

ConflictDirectorTests.tentacle_test_update = function (self, arg_28_1, arg_28_2)
	-- function 28
	local PLAYER_POSITIONS = self.PLAYER_POSITIONS
	local ik_tentacle = ConflictDirectorTests.ik_tentacle

	if not ik_tentacle then
		ik_tentacle:set_target_pos(self.PLAYER_POSITIONS[1] + Vector3(0, 0, 1), 20)
		ik_tentacle:solve(arg_28_1, arg_28_2)
	end
end

local tbl_2 = {}
local str = "spawn"
local str_2 = "soft"

ConflictDirectorTests.spawn_mesh_cut = function (self)
	-- function 29
	local _world = self._world
	local nav_world = self.nav_world
	local player_aim_raycast, var_29_3, var_29_4, var_29_5 = self:player_aim_raycast(_world, false, "filter_ray_horde_spawn")

	if not player_aim_raycast then
		print("No spawn pos found")

		return
	end

	for k, v in pairs(tbl_2) do
		GwNavCylinderObstacle.set_does_trigger_tagvolume(k, false)
		GwNavCylinderObstacle.remove_from_world(k)
		GwNavCylinderObstacle.destroy(k)
	end

	table.clear(tbl_2)

	local pos_on_mesh = LocomotionUtils.pos_on_mesh(self.nav_world, player_aim_raycast)

	if not pos_on_mesh then
		print("No mesh found at spawn pos")

		return
	end

	local num = 1
	local num_2 = 2
	local num_3 = 2
	local num_4 = num_3 / 2 + 0.3

	for k_2 = -num, num do
		for l = -num_2, num_2 do
			local num_5 = pos_on_mesh + Vector3(k_2 * num_3, l * num_3, -1)

			QuickDrawerStay:sphere(num_5, num_4)

			local var_29_12

			if str_2 == "soft" then
				var_29_12 = GwNavCylinderObstacle.create(nav_world, num_5, 3, num_4, false, Color(255, 255, 0), LAYER_ID_MAPPING.fire_grenade)

				GwNavCylinderObstacle.add_to_world(var_29_12)
				GwNavCylinderObstacle.set_does_trigger_tagvolume(var_29_12, true)
			elseif str_2 == "hard" then
				var_29_12 = GwNavCylinderObstacle.create_exclusive(nav_world, num_5, 3, num_4)

				GwNavCylinderObstacle.add_to_world(var_29_12)
				GwNavCylinderObstacle.set_does_trigger_tagvolume(var_29_12, true)
			else
				local get_seed_triangle = GwNavTraversal.get_seed_triangle(nav_world, num_5)
				local get_triangle_vertices, var_29_15, var_29_16 = GwNavTraversal.get_triangle_vertices(nav_world, get_seed_triangle)

				GwNavTraversal.get_neighboring_triangles(poly)
				GwNavNavTagVolume.create(nav_world, poly_line, num_5.z - 2, num_5.z + 2, false, Color(0, 200, 45), LAYER_ID_MAPPING.fire_grenade)
			end

			tbl_2[var_29_12] = true
		end
	end
end

ConflictDirectorTests.spawn_liquid_blob = function (self, arg_30_1, arg_30_2)
	-- function 30
	local player_aim_raycast, var_30_1, var_30_2, var_30_3 = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")

	if not player_aim_raycast then
		print("No spawn pos found")

		return
	end

	local tbl = {
		props_system = {
			start_size = 0.3,
			duration = 0.5,
			end_size = 1
		}
	}
	local str = "units/props/nurgle_liquid_blob/nurgle_liquid_blob_01"
	local str_2 = "nurgle_liquid_blob"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "nurgle_liquid_blob", tbl, player_aim_raycast)
end

ConflictDirectorTests.test_cover_points = function (self, arg_31_1)
	-- function 31
	local PLAYER_POSITIONS = arg_31_1.PLAYER_POSITIONS

	if not PLAYER_POSITIONS[1] then
		return
	end

	local cover_points_broadphase = self.level_analysis.cover_points_broadphase
	local var_31_2 = Color(255, 0, 240, 0)
	local var_31_3 = Color(255, 240, 0, 0)
	local tbl = {}

	Broadphase.query(cover_points_broadphase, PLAYER_POSITIONS[1], 20, tbl)

	local var_31_5 = PLAYER_POSITIONS[1]

	for i = 1, #tbl do
		local var_31_6 = tbl[i]
		local local_position = Unit.local_position(var_31_6, 0)
		local local_rotation = Unit.local_rotation(var_31_6, 0)
		local normalize = Vector3.normalize(var_31_5 - local_position)

		if not (Vector3.dot(Quaternion.forward(local_rotation), normalize) > 0.9) then
			QuickDrawerStay:sphere(local_position, 1, var_31_2)
			QuickDrawerStay:line(local_position + Vector3(0, 0, 1), local_position + Quaternion.forward(local_rotation) * 2 + Vector3(0, 0, 1), var_31_2)
		else
			QuickDrawerStay:sphere(local_position, 1, var_31_3)
			QuickDrawerStay:line(local_position + Vector3(0, 0, 1), local_position + Quaternion.forward(local_rotation) * 2 + Vector3(0, 0, 1), var_31_3)
		end
	end

	self.specials_pacing:get_special_spawn_pos()
end

ConflictDirectorTests.update_kill_tester = function (self)
	-- function 32
	if not script_data.kill_test then
		return
	end

	local tbl = {
		"skaven_slave",
		"skaven_slave",
		"skaven_slave",
		"skaven_clan_rat",
		"chaos_marauder",
		"chaos_fanatic",
		"chaos_fanatic",
		"chaos_fanatic"
	}

	if not self._kill_list then
		self._kill_list = {}
		self._kill_spawn_index = 1
	end

	local num = self._kill_spawn_index % #tbl + 1

	self._kill_spawn_index = num

	local _kill_list = self._kill_list
	local var_32_3 = tbl[num]
	local var_32_4 = Breeds[var_32_3]
	local tbl_2 = {
		ignore_breed_limits = true,
		spawned_func = function (arg_33_0, arg_33_1, arg_33_2)
			-- function 33
			table.insert(self._kill_list, 1, arg_33_0)
		end
	}
	local var_32_6 = Vector3Box(Vector3(0, 0, 0) + Vector3(num * 1, 0, 0))
	local var_32_7 = QuaternionBox()

	self:spawn_queued_unit(var_32_4, var_32_6, var_32_7, "debug_spawn", nil, nil, tbl_2)

	local count = #_kill_list

	if count >= 3 then
		local var_32_9 = _kill_list[count]

		_kill_list[count] = nil

		local has_extension = ScriptUnit.has_extension(var_32_9, "health_system")

		if not has_extension and not has_extension:is_alive() then
			local num_2 = 255
			local str = "full"
			local str_2 = "forced"
			local var_32_14 = Vector3(0, 0, 1)

			DamageUtils.add_damage_network(var_32_9, var_32_9, num_2, str, str_2, nil, var_32_14, "debug", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end
end

ConflictDirectorTests.nav_group_astar_test = function (self, arg_34_1)
	-- function 34
	if not self.astar_path then
		print("ASTAR")

		local get_start_and_finish, var_34_1 = self.level_analysis:get_start_and_finish()
		local get_seed_triangle = GwNavTraversal.get_seed_triangle(self.nav_world, arg_34_1.PLAYER_POSITIONS[1])
		local get_seed_triangle_2 = GwNavTraversal.get_seed_triangle(self.nav_world, var_34_1:unbox())

		if not (not get_seed_triangle and get_seed_triangle_2) then
			return false
		end

		local get_polygon_group = self.navigation_group_manager:get_polygon_group(get_seed_triangle)
		local get_polygon_group_2 = self.navigation_group_manager:get_polygon_group(get_seed_triangle_2)
		local _navigation_groups = self.navigation_group_manager._navigation_groups
		local a_star_plain, var_34_8 = LuaAStar.a_star_plain(_navigation_groups, get_polygon_group, get_polygon_group_2)

		self.astar_path = a_star_plain

		print("Generated path:", #a_star_plain, var_34_8)
	end
end

ConflictDirectorTests.update_group_astar_test = function (self, arg_35_1)
	-- function 35
	if not self.astar_path then
		local astar_path = self.astar_path
		local var_35_1

		for i = 1, #astar_path do
			local unbox = astar_path[i]:get_group_center():unbox()

			QuickDrawer:sphere(unbox, 2)

			if not var_35_1 then
				QuickDrawer:line(unbox + Vector3(0, 0, 1), var_35_1 + Vector3(0, 0, 1), Color(255, 244, 143, 7))
			end

			var_35_1 = unbox
		end
	end
end

local function fn_4(self, arg_36_1, arg_36_2)
	-- function 36
	out_list = {}

	for i = 1, #self do
		local var_36_0 = self[i]
		local var_36_1 = Vector3(var_36_0.pos[1], var_36_0.pos[2], 0)

		if arg_36_2 > Vector3.distance(arg_36_1, var_36_0) then
			out_list[#out_list + 1] = var_36_0
		end
	end

	return num
end

local function fn_5(self)
	-- function 37
	local num = 99
	local var_37_1
	local var_37_2

	for i = 1, #self do
		local var_37_3 = self[i]
		local var_37_4 = BLACKBOARDS[var_37_3]
		local lean_dogpile = var_37_4.lean_dogpile

		if not ((var_37_4 == blackboard or not enemy_units_lookup[var_37_3]) and not (lean_dogpile < num)) then
			num = lean_dogpile
			var_37_2 = var_37_3

			if blackboard.lean_target_unit == var_37_3 then
				break
			end

			if i > 5 then
				break
			end
		end
	end

	if not var_37_2 then
		return var_37_2, true
	else
		return nil, false
	end
end

function slot_testing(arg_38_0)
	-- function 38
	for i = 1, #a do
		unit = a[i]
	end
end

function setup_slot_testing()
	-- function 39
	local tbl = {
		{
			lean_dogpile = 0,
			pos = {
				-1,
				3
			}
		},
		{
			lean_dogpile = 0,
			pos = {
				0,
				3
			}
		},
		{
			lean_dogpile = 0,
			pos = {
				1,
				3
			}
		},
		{
			lean_dogpile = 0,
			pos = {
				2,
				3
			}
		},
		{
			lean_dogpile = 0,
			pos = {
				3,
				3
			}
		}
	}
	local tbl_2 = {
		{
			lean_dogpile = 0,
			pos = {
				1,
				0
			}
		},
		{
			lean_dogpile = 0,
			pos = {
				2,
				0
			}
		}
	}

	slot_testing(tbl, tbl_2)
end

ConflictDirectorTests.start_test = function (self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	get_side_from_name = get_side_from_name or Managers.state.side:get_side(1)
	arg_40_3 = arg_40_3 or "spawn_encampment"
	self.conflict_director_tests_name = arg_40_3

	print("starting test:", arg_40_3)

	if arg_40_3 == "sparse" then
		for i = 1, 30 do
			for j = 1, 30 do
				local var_40_1 = get_side_from_name.PLAYER_POSITIONS[1]
				local var_40_2 = Vector3(var_40_1[1] + i * 0.3, var_40_1[2] + j * 0.3, var_40_1[3])

				ConflictDirectorTests.sparse_grid_test(var_40_2, get_side_from_name.PLAYER_UNITS[1])
			end
		end

		return
	elseif arg_40_3 == "lean_slot" then
		ConflictDirectorTests.lean_slot_test()
	elseif arg_40_3 == "drag_test" then
		ConflictDirectorTests.drag_test_start(get_side_from_name)
	elseif arg_40_3 == "tentacle" then
		ConflictDirectorTests.tentacle_test_start(get_side_from_name, arg_40_1, arg_40_2)
	elseif arg_40_3 == "mesh_cut" then
		ConflictDirectorTests.spawn_mesh_cut(self)
	elseif arg_40_3 == "liquid_blob" then
		ConflictDirectorTests.spawn_liquid_blob(self)
	elseif arg_40_3 == "reachable_coverpoints" then
		ConflictDirectorTests.setup_reachable_coverpoints_test(self)
	elseif arg_40_3 == "reachable_navgraph" then
		ConflictDirectorTests.process_reachable_coverpoints_test(self)
	elseif arg_40_3 == "test_cover_points" then
		ConflictDirectorTests.test_cover_points(self, get_side_from_name)
	elseif arg_40_3 == "kill_tester" then
		script_data.kill_test = not script_data.kill_test
	elseif arg_40_3 == "nav_group_astar" then
		ConflictDirectorTests.nav_group_astar_test(self, get_side_from_name)
	elseif arg_40_3 == "spawn_encampment" then
		if not GenericTerrorEvents.encampment then
			print("Missing terror event: encampment")

			return
		end

		local player_aim_raycast, var_40_4, var_40_5, var_40_6 = self:player_aim_raycast(self._world, false, "filter_ray_horde_spawn")

		if not player_aim_raycast then
			print("No spawn pos found")

			return
		end

		local tbl = {
			side_id = self.debug_spawn_side_id,
			debug_pos = player_aim_raycast,
			debug_dir = {
				0,
				1
			}
		}

		TerrorEventMixer.start_event("encampment4", tbl)

		local tbl_2 = {
			side_id = 1,
			debug_pos = player_aim_raycast + Vector3(0, 8, 0),
			debug_dir = {
				0,
				-1
			}
		}

		TerrorEventMixer.start_event("encampment4", tbl_2)

		return
	elseif arg_40_3 == "hull_test" then
		local var_40_9 = make_points_for_hull_test()
		local var_40_10, var_40_11 = convex_hull(var_40_9, {})
		local num = 0.5

		for k = 1, var_40_11 do
			local var_40_13 = var_40_10[k]
			local var_40_14

			if k == var_40_11 then
				var_40_14 = var_40_10[1]
			else
				var_40_14 = var_40_10[k + 1]
			end

			local var_40_15 = Vector3(var_40_13.x, var_40_13.y, num)
			local var_40_16 = Vector3(var_40_14.x, var_40_14.y, num)

			QuickDrawerStay:line(var_40_15, var_40_16, Color(200, 100, 100))
		end

		print("Convex Hull: ")
		print_points(var_40_10, var_40_11)
		print()
		print("Correct Output: Convex Hull: [(-9, -3), (-3, -9), (19, -8), (17, 5), (12, 17), (5, 19), (-3, 15)]")
	end
end

ConflictDirectorTests.update = function (self, arg_41_1, arg_41_2)
	-- function 41
	local conflict_director_tests_name = self.conflict_director_tests_name
	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	get_side_from_name = get_side_from_name or Managers.state.side:get_side(1)
	self.hero_player_and_bot_positions = get_side_from_name.PLAYER_AND_BOT_POSITIONS
	self.hero_player_positions = get_side_from_name.PLAYER_POSITIONS

	if conflict_director_tests_name == "sparse" then
		ConflictDirectorTests.draw_sparse_grid(get_side_from_name.PLAYER_POSITIONS[1])
	elseif conflict_director_tests_name == "jslots" then
		ConflictDirectorTests.update_jslots(get_side_from_name.PLAYER_UNITS[1])
	elseif conflict_director_tests_name == "lean_slot" then
		ConflictDirectorTests.lean_slot_test_update(get_side_from_name)
	elseif conflict_director_tests_name == "drag_test" then
		ConflictDirectorTests.drag_test_update(get_side_from_name)
	elseif conflict_director_tests_name == "tentacle" then
		ConflictDirectorTests.tentacle_test_update(get_side_from_name, arg_41_1, arg_41_2)
	elseif conflict_director_tests_name == "kill_test" then
		ConflictDirectorTests.update_kill_tester(self, get_side_from_name)
	elseif conflict_director_tests_name == "nav_group_astar" then
		ConflictDirectorTests.update_group_astar_test(self, get_side_from_name)
	end
end
