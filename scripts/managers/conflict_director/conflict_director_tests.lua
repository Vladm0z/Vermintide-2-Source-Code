-- chunkname: @scripts/managers/conflict_director/conflict_director_tests.lua

ConflictDirectorTests = {}

local var_0_0 = false

ConflictDirectorTests.start_utility_comparison = function ()
	var_0_0 = true
end

local function var_0_1()
	local var_2_0 = UtilityConsiderations.storm_vermin_push_attack.distance_to_target
	local var_2_1 = 0.7
	local var_2_2 = EngineOptimized.utility_from_spline
	local var_2_3

	for iter_2_0 = 1, 1000 do
		local var_2_4 = var_2_2(var_2_0.engine_spline_index, var_2_1)
	end

	local var_2_5 = math.clamp(var_2_1 / var_2_0.max_value, 0, 1)
	local var_2_6 = Utility.GetUtilityValueFromSpline

	for iter_2_1 = 1, 1000 do
		local var_2_7 = var_2_6(var_2_0.spline, var_2_5)
	end
end

local function var_0_2(arg_3_0, arg_3_1)
	local var_3_0 = Vector3(0, 0, 0)
	local var_3_1 = math.huge
	local var_3_2 = -1
	local var_3_3 = arg_3_0[1]:unbox()

	for iter_3_0 = 1, #arg_3_0 - 1 do
		local var_3_4 = arg_3_0[iter_3_0 + 1]:unbox()
		local var_3_5 = Geometry.closest_point_on_line(arg_3_1, var_3_3, var_3_4)
		local var_3_6 = Vector3.distance_squared(arg_3_1, var_3_5)

		if var_3_6 < var_3_1 then
			var_3_1 = var_3_6
			var_3_2 = iter_3_0

			Vector3.set_xyz(var_3_0, Vector3.to_elements(var_3_5))
		end

		var_3_3 = var_3_4
	end

	Debug.text("SS: %.2f %d, %s", var_3_1, var_3_2, tostring(var_3_0))

	return var_3_0
end

local var_0_3 = false
local var_0_4 = false

ConflictDirectorTests.test_main_path_optimization = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.main_path_info.main_paths

	if not var_4_0 then
		return
	end

	local var_4_1 = 100

	if not var_0_3 then
		local var_4_2 = MainPathUtils.point_on_mainpath(var_4_0, 10)
		local var_4_3, var_4_4, var_4_5, var_4_6, var_4_7 = MainPathUtils.closest_pos_at_main_path(var_4_0, var_4_2)
		local var_4_8 = MainPathUtils.total_path_dist()

		var_0_3 = {
			Vector3Box(var_4_2)
		}

		for iter_4_0 = 2, var_4_1 do
			local var_4_9 = var_4_8 / var_4_1 * iter_4_0
			local var_4_10, var_4_11 = MainPathUtils.point_on_mainpath(var_4_0, var_4_9)

			if not var_4_10 then
				var_4_10 = var_0_3[1]:unbox()

				local var_4_12 = 1
			end

			local var_4_13 = #var_0_3 + 1

			var_0_3[var_4_13] = Vector3Box(var_4_10)
		end
	end

	local var_4_14 = arg_4_0.main_path_info
	local var_4_15 = MainPathUtils.closest_pos_at_collapsed_main_path
	local var_4_16 = MainPathUtils.point_on_mainpath
	local var_4_17 = arg_4_0.level_analysis.main_path_data
	local var_4_18 = #var_4_17.collapsed_path
	local var_4_19 = var_4_17.collapsed_path[var_4_18]:unbox()

	QuickDrawer:sphere(var_4_19, 10 + math.sin(arg_4_1 * 5) * 5)
	Debug.text("DISTANCE point: %d, distance %.1f", var_4_18, var_4_17.collapsed_travel_dists[var_4_18])

	for iter_4_1 = 1, var_4_1 do
		var_4_15(var_4_17.collapsed_path, var_4_17.collapsed_travel_dists, var_4_17.breaks_lookup, var_4_19, var_4_18)
	end

	local var_4_20 = EngineOptimized.closest_pos_at_main_path
	local var_4_21 = EngineOptimized.point_on_mainpath

	for iter_4_2 = 1, var_4_1 do
		var_4_20(var_4_19)
	end

	local var_4_22 = arg_4_0.hero_player_positions[1]
	local var_4_23 = Vector3(100, 20, 130)
	local var_4_24 = Vector3(-100, -420, 30)
	local var_4_25
	local var_4_26 = EngineOptimized.closest_point_on_line

	for iter_4_3 = 1, 250 do
		local var_4_27 = var_4_26(var_4_22, var_4_23, var_4_24)
	end

	local var_4_28 = Geometry.closest_point_on_line

	for iter_4_4 = 1, 250 do
		local var_4_29 = var_4_28(var_4_22, var_4_23, var_4_24)
	end

	local var_4_30 = arg_4_0.level_analysis.main_path_data.collapsed_path
	local var_4_31 = var_0_2(var_4_30, var_4_22)
	local var_4_32, var_4_33, var_4_34 = EngineOptimized.closest_pos_at_main_path(var_4_22)
	local var_4_35, var_4_36, var_4_37 = MainPathUtils.closest_pos_at_main_path_lua(var_4_0, var_4_22)

	QuickDrawer:sphere(var_4_32, 1.05, Color(255, 0, 0))
	QuickDrawer:sphere(var_4_31, 1.2, Color(255, 255, 0))
	QuickDrawer:sphere(var_4_35, 0.9, Color(155, 155, 255))
	QuickDrawer:line(var_4_30[1]:unbox(), var_4_30[2]:unbox(), Color(100, 255, 0))

	local var_4_38 = math.random()
end

function test_spawn_pos_ahead_half_sphere(arg_5_0)
	local var_5_0 = arg_5_0.main_path_info
	local var_5_1 = var_5_0.ahead_unit

	if var_5_1 then
		local var_5_2 = POSITION_LOOKUP[var_5_1]
		local var_5_3 = arg_5_0.specials_pacing:get_relative_main_path_pos(var_5_0.main_paths, arg_5_0.main_path_player_info[var_5_1], 20)

		QuickDrawer:cone(var_5_2, var_5_2 + Vector3(0, 0, 2.5), 1, Color(200, 200, 0), 8, 8)

		local var_5_4 = var_5_3 - var_5_2
		local var_5_5 = 25
		local var_5_6 = LevelHelper:current_level(arg_5_0._world)
		local var_5_7 = arg_5_0.nav_tag_volume_handler

		for iter_5_0 = 1, 25 do
			local var_5_8 = ConflictUtils.get_hidden_pos(arg_5_0._world, arg_5_0.nav_world, var_5_6, var_5_7, true, var_5_3, arg_5_0.hero_player_and_bot_positions, 30, 10, var_5_5, 10, var_5_4, math.pi)

			if var_5_8 then
				QuickDrawer:sphere(var_5_8, 1)
			end
		end
	end
end

function test_umbra_los(arg_6_0)
	local var_6_0 = arg_6_0._world

	if not World.umbra_available(var_6_0) then
		return
	end

	local var_6_1 = arg_6_0.main_path_info
	local var_6_2 = var_6_1.ahead_unit
	local var_6_3 = var_6_1.behind_unit

	if var_6_2 and var_6_3 then
		local var_6_4 = POSITION_LOOKUP[var_6_2]
		local var_6_5 = POSITION_LOOKUP[var_6_3]
		local var_6_6 = Vector3(0, 0, 1)

		if World.umbra_has_line_of_sight(var_6_0, var_6_4 + var_6_6, var_6_5 + var_6_6) then
			QuickDrawer:line(var_6_4 + var_6_6, var_6_5 + var_6_6, Color(0, 90, 200))
		else
			QuickDrawer:line(var_6_4 + var_6_6, var_6_5 + var_6_6, Color(255, 0, 0))
		end
	end
end

function debug_bot_transitions(arg_7_0, arg_7_1)
	local var_7_0 = Managers.state.entity:system("ai_system")
	local var_7_1 = var_7_0.ai_debugger and var_7_0.ai_debugger.screen_gui

	AiUtils.debug_bot_transitions(var_7_1, arg_7_1, 0, 0)
end

function test_player_path_pos_and_50m_ahead(arg_8_0)
	local var_8_0 = arg_8_0.hero_player_positions[1]
	local var_8_1 = arg_8_0.level_analysis.main_paths
	local var_8_2, var_8_3 = MainPathUtils.closest_pos_at_main_path(var_8_1, var_8_0)
	local var_8_4 = MainPathUtils.total_path_dist()
	local var_8_5 = MainPathUtils.point_on_mainpath(var_8_1, var_8_3 + 10) or MainPathUtils.point_on_mainpath(var_8_1, var_8_4 - 10)

	QuickDrawer:sphere(var_8_5, 3)

	local var_8_6 = MainPathUtils.point_on_mainpath(var_8_1, var_8_4 - 50)

	if var_8_6 then
		QuickDrawer:sphere(var_8_6, 2.5, Color(255, 120, 0, 0))
	end
end

function test_angled_trajectory(arg_9_0)
	local var_9_0 = Vector3(0, 0, 2)
	local var_9_1 = Vector3(19, 16, 2)
	local var_9_2 = World.get_data(arg_9_0._world, "physics_world")
	local var_9_3 = -9.82
	local var_9_4
	local var_9_5 = math.degrees_to_radians(45)
	local var_9_6, var_9_7, var_9_8 = WeaponHelper.test_angled_trajectory(var_9_2, var_9_0, var_9_1, var_9_3, var_9_4, var_9_5)

	QuickDrawer:sphere(var_9_0, 1)
	QuickDrawer:sphere(var_9_1, 1)
	Debug.text("Trajectory Success: " .. tostring(var_9_6))
end

ConflictDirectorTests.setup_reachable_coverpoints_test = function (arg_10_0)
	local var_10_0 = {}
	local var_10_1, var_10_2 = ConflictUtils.hidden_cover_points(arg_10_0.hero_player_positions[1], arg_10_0.hero_player_positions, 2, 45, 1)

	for iter_10_0 = 1, var_10_1 do
		var_10_0[iter_10_0] = Vector3Box(Unit.local_position(var_10_2[iter_10_0], 0))
	end

	arg_10_0._reachable_processing = LevelAnalysis.setup_unreachable_processing(arg_10_0.nav_world, arg_10_0.main_path_info.main_paths, var_10_0, {
		max_concurrent_astars = 5,
		line_object = QuickDrawerStay
	})

	print("Points to test:", var_10_1)
end

ConflictDirectorTests.process_reachable_coverpoints_test = function (arg_11_0)
	if arg_11_0._reachable_processing and arg_11_0.level_analysis.process_unreachable(arg_11_0._reachable_processing) then
		arg_11_0._reachable_processing = nil

		print("astar connect complete")
	end
end

function setup_reachable_navgraph_test(arg_12_0)
	local var_12_0 = {}
	local var_12_1 = Managers.state.game_mode:level_key()
	local var_12_2 = LevelSettings[var_12_1].level_name
	local var_12_3 = LevelResource.unit_indices(var_12_2, "core/gwnav/units/seedpoint/seedpoint")

	for iter_12_0, iter_12_1 in ipairs(var_12_3) do
		var_12_0[#var_12_0 + 1] = Vector3Box(LevelResource.unit_position(var_12_2, iter_12_1))
	end

	arg_12_0._reachable_navgraph_processing = LevelAnalysis.setup_unreachable_processing(arg_12_0.nav_world, arg_12_0.main_path_info.main_paths, var_12_0, {
		max_concurrent_astars = 5,
		line_object = QuickDrawerStay,
		fail_color = Color(212, 48, 0)
	})

	print("Points to test:", #var_12_0)
end

function process_reachable_navgraph_test(arg_13_0)
	if arg_13_0._reachable_navgraph_processing and arg_13_0.level_analysis.process_unreachable(arg_13_0._reachable_navgraph_processing) then
		arg_13_0._reachable_navgraph_processing = nil

		print("astar connect complete")
	end
end

function print_point(arg_14_0)
	print("(" .. arg_14_0.x .. ", " .. arg_14_0.y .. ")")

	return nil
end

function print_points(arg_15_0, arg_15_1)
	print("[")

	for iter_15_0 = 1, arg_15_1 do
		local var_15_0 = arg_15_0[iter_15_0]

		if iter_15_0 > 1 then
			print(", ")
		end

		print_point(var_15_0)
	end

	print("]")

	return nil
end

function ccw(arg_16_0, arg_16_1, arg_16_2)
	return (arg_16_1.x - arg_16_0.x) * (arg_16_2.y - arg_16_0.y) > (arg_16_1.y - arg_16_0.y) * (arg_16_2.x - arg_16_0.x)
end

local function var_0_5(arg_17_0, arg_17_1)
	return arg_17_0.x < arg_17_1.x
end

function convex_hull(arg_18_0, arg_18_1)
	local var_18_0 = #arg_18_0

	if var_18_0 == 0 then
		return arg_18_1, 0
	end

	table.sort(arg_18_0, var_0_5)

	local var_18_1 = 0

	for iter_18_0 = 1, var_18_0 do
		local var_18_2 = arg_18_0[iter_18_0]

		while var_18_1 >= 2 and not ccw(arg_18_1[var_18_1 - 1], arg_18_1[var_18_1], var_18_2) do
			var_18_1 = var_18_1 - 1
		end

		var_18_1 = var_18_1 + 1
		arg_18_1[var_18_1] = var_18_2
	end

	local var_18_3 = var_18_1 + 1

	for iter_18_1 = var_18_0, 1, -1 do
		local var_18_4 = arg_18_0[iter_18_1]

		while var_18_3 <= var_18_1 and not ccw(arg_18_1[var_18_1 - 1], arg_18_1[var_18_1], var_18_4) do
			var_18_1 = var_18_1 - 1
		end

		var_18_1 = var_18_1 + 1
		arg_18_1[var_18_1] = var_18_4
	end

	local var_18_5 = var_18_1 - 1

	return arg_18_1, var_18_5
end

function make_points_for_hull_test()
	local var_19_0 = Managers.state.side:get_side(Managers.state.conflict.default_enemy_side_id).units_lookup
	local var_19_1 = table.clone(var_19_0)

	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		if HEALTH_ALIVE[iter_19_0] then
			var_19_1[#var_19_1 + 1] = POSITION_LOOKUP[iter_19_0]
		end
	end

	return var_19_1
end

ConflictDirectorTests.update_jslots = function (arg_20_0, arg_20_1)
	local var_20_0 = {
		num = 0,
		slots = {},
		units = {},
		adjusted_dirs = {}
	}
	local var_20_1 = POSITION_LOOKUP[arg_20_1]

	if not var_20_1 then
		return
	end

	local var_20_2 = AiUtils.broadphase_query(var_20_1, 7, RESULT_TABLE)

	for iter_20_0 = 1, var_20_2 do
		local var_20_3 = RESULT_TABLE[iter_20_0]
		local var_20_4 = var_20_0.units

		if not var_20_4[var_20_3] then
			local var_20_5 = POSITION_LOOKUP[var_20_3]
			local var_20_6 = var_20_0.slots
			local var_20_7 = var_20_6[1]
			local var_20_8 = 2
			local var_20_9 = 1

			if var_20_7 then
				local var_20_10 = Vector3.normalize(var_20_5 - var_20_1)
				local var_20_11 = var_20_0.num + 1

				var_20_6[var_20_11] = var_20_10 * var_20_8
				var_20_0.num = var_20_11
				var_20_4[var_20_3] = var_20_0.num
			else
				local var_20_12 = Vector3.normalize(var_20_5 - var_20_1)

				var_20_0.slots[1] = var_20_12 * var_20_8
				var_20_0.num = 1
				var_20_4[var_20_3] = 1
			end
		end
	end

	local var_20_13 = var_20_0.slots
	local var_20_14 = var_20_0.adjusted_dirs

	for iter_20_1 = 1, #var_20_13 do
		QuickDrawer:line(var_20_1, var_20_1 + var_20_13[iter_20_1], Color(23, 223, 100))
	end
end

local var_0_6 = {}
local var_0_7 = 0.3
local var_0_8 = 0.3

ConflictDirectorTests.draw_sparse_grid = function (arg_21_0)
	if not arg_21_0 then
		return
	end

	local var_21_0 = math.floor
	local var_21_1 = var_21_0(arg_21_0.x / var_0_7 + 0.5)
	local var_21_2 = var_21_0(arg_21_0.y / var_0_7 + 0.5)
	local var_21_3 = var_21_0(arg_21_0.z / var_0_8 + 0.5)
	local var_21_4 = var_21_1 * 0.0001 + var_21_2 + var_21_3 * 10000

	QuickDrawer:sphere(Vector3(var_21_0(arg_21_0.x / var_0_7) * var_0_7, var_21_0(arg_21_0.y / var_0_7) * var_0_7, var_21_0(arg_21_0.z / var_0_8) * var_0_8), var_0_7 * 0.5 - 0.01, Color(0, 200, 200))
	QuickDrawer:sphere(arg_21_0, 0.1, Color(255, 200, 100))

	for iter_21_0, iter_21_1 in pairs(var_0_6) do
		QuickDrawer:sphere(Vector3(iter_21_1.x, iter_21_1.y, iter_21_1.z), var_0_7 * 0.5, Color(0, 0, 200))
	end
end

ConflictDirectorTests.sparse_grid_test = function (arg_22_0, arg_22_1)
	local var_22_0 = math.floor
	local var_22_1 = var_22_0(arg_22_0.x / var_0_7 + 0.5)
	local var_22_2 = var_22_0(arg_22_0.y / var_0_7 + 0.5)
	local var_22_3 = var_22_0(arg_22_0.z / var_0_8 + 0.5)
	local var_22_4 = var_22_1 * 0.0001 + var_22_2 + var_22_3 * 10000

	if var_0_6[var_22_4] then
		Debug.text("SPARSE GRID: OCCUPIED")
	else
		var_0_6[var_22_4] = {
			u = arg_22_1,
			x = var_22_1 * var_0_7,
			y = var_22_2 * var_0_7,
			z = var_22_3 * var_0_8
		}

		print("SPARSE GRID:", var_22_4, arg_22_0)
		QuickDrawer:sphere(arg_22_0, 0.7, Color(200, 0, 0))
	end
end

ConflictDirectorTests.lean_slot_test = function ()
	local var_23_0 = 10
	local var_23_1 = 3
	local var_23_2 = 2 * math.pi / var_23_0
	local var_23_3 = ConflictDirectorTests.lean_slots
	local var_23_4 = (Managers.state.side:get_side_from_name("heroes") or Managers.state.side:get_side(1)).PLAYER_POSITIONS[1]

	if not var_23_4 then
		return
	end

	if var_23_3 then
		local var_23_5 = var_23_3.lean_dogpile + 1

		if var_23_0 < var_23_5 then
			ConflictDirectorTests.lean_slots = nil
		else
			var_23_3.lean_dogpile = var_23_5

			local var_23_6 = var_23_3.center_angle + (var_23_5 - 1) * var_23_2
			local var_23_7 = var_23_1 * 0.5
			local var_23_8 = math.cos(var_23_6) * var_23_7
			local var_23_9 = math.sin(var_23_6) * var_23_7

			var_23_3[var_23_5] = {
				var_23_8,
				var_23_9,
				var_23_4.z
			}
		end
	else
		local var_23_10 = var_23_4.x + math.random(-5, 5)
		local var_23_11 = var_23_4.y + math.random(-5, 5)

		QuickDrawerStay:sphere(var_23_4, 0.44, Color(250, 0, 0))
		QuickDrawerStay:sphere(Vector3(var_23_10, var_23_11, var_23_4.z), 0.75, Color(0, 0, 255))

		local var_23_12 = math.atan2(var_23_11 - var_23_4.y, var_23_10 - var_23_4.x)
		local var_23_13 = var_23_1 * 0.5
		local var_23_14 = math.cos(var_23_12) * var_23_13
		local var_23_15 = math.sin(var_23_12) * var_23_13
		local var_23_16 = {
			{
				var_23_14,
				var_23_15,
				var_23_4.z
			},
			lean_dogpile = 1,
			center_angle = var_23_12
		}

		ConflictDirectorTests.lean_slots = var_23_16
	end
end

ConflictDirectorTests.lean_slot_test_update = function (arg_24_0)
	local var_24_0 = ConflictDirectorTests.lean_slots

	if var_24_0 then
		Debug.text("Slots %d", var_24_0.lean_dogpile)

		local var_24_1 = arg_24_0.PLAYER_POSITIONS[1]

		for iter_24_0 = 1, #var_24_0 do
			local var_24_2 = var_24_0[iter_24_0]

			QuickDrawer:sphere(Vector3(var_24_1.x + var_24_2[1], var_24_1.y + var_24_2[2], var_24_2[3]), 0.5, Color(255, 255, 0))
		end
	end
end

ConflictDirectorTests.drag_test_start = function (arg_25_0)
	if ConflictDirectorTests.drag_test then
		ConflictDirectorTests.drag_test = nil
	else
		local var_25_0 = arg_25_0.PLAYER_POSITIONS[1] + Vector3(0, 0, 1.8)
		local var_25_1 = arg_25_0.PLAYER_POSITIONS[1] + Vector3(2, 0, 1.8)

		ConflictDirectorTests.drag_test = {
			pole_length = 2,
			apos = Vector3Box(var_25_0),
			bpos = Vector3Box(var_25_1)
		}
	end
end

ConflictDirectorTests.drag_test_update = function (arg_26_0)
	if ConflictDirectorTests.drag_test then
		local var_26_0 = ConflictDirectorTests.drag_test
		local var_26_1 = var_26_0.apos:unbox()
		local var_26_2 = var_26_0.bpos:unbox()
		local var_26_3 = arg_26_0.PLAYER_POSITIONS[1] + Vector3(0, 0, 1.8)
		local var_26_4 = var_26_3 + Vector3.normalize(var_26_2 - var_26_3) * var_26_0.pole_length

		var_26_0.bpos:store(var_26_4)
		var_26_0.apos:store(var_26_3)
		QuickDrawer:sphere(var_26_4, 0.3, Color(0, 200, 40))
		QuickDrawer:line(var_26_4, var_26_3, Color(0, 200, 40))
	end
end

ConflictDirectorTests.tentacle_test_start = function (arg_27_0, arg_27_1, arg_27_2)
	if ConflictDirectorTests.ik_tentacle then
		ConflictDirectorTests.ik_tentacle = nil
	else
		print("Creating tentacle")

		local var_27_0 = arg_27_0.PLAYER_POSITIONS[1] + Vector3(1, 0, 0)
		local var_27_1 = arg_27_0.PLAYER_POSITIONS[1] + Vector3(0, 0, 1)
		local var_27_2 = {}

		for iter_27_0 = 1, 14 do
			var_27_2[iter_27_0] = Vector3(0, 0, iter_27_0 * 0.5)
		end

		ConflictDirectorTests.ik_tentacle = IkChain:new(var_27_2, var_27_0, var_27_1, 0.01, 0.8)

		ConflictDirectorTests.ik_tentacle:solve(arg_27_1, arg_27_2)
	end
end

ConflictDirectorTests.tentacle_test_update = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.PLAYER_POSITIONS
	local var_28_1 = ConflictDirectorTests.ik_tentacle

	if var_28_1 then
		var_28_1:set_target_pos(arg_28_0.PLAYER_POSITIONS[1] + Vector3(0, 0, 1), 20)
		var_28_1:solve(arg_28_1, arg_28_2)
	end
end

local var_0_9 = {}
local var_0_10 = "spawn"
local var_0_11 = "soft"

ConflictDirectorTests.spawn_mesh_cut = function (arg_29_0)
	local var_29_0 = arg_29_0._world
	local var_29_1 = arg_29_0.nav_world
	local var_29_2, var_29_3, var_29_4, var_29_5 = arg_29_0:player_aim_raycast(var_29_0, false, "filter_ray_horde_spawn")

	if not var_29_2 then
		print("No spawn pos found")

		return
	end

	for iter_29_0, iter_29_1 in pairs(var_0_9) do
		GwNavCylinderObstacle.set_does_trigger_tagvolume(iter_29_0, false)
		GwNavCylinderObstacle.remove_from_world(iter_29_0)
		GwNavCylinderObstacle.destroy(iter_29_0)
	end

	table.clear(var_0_9)

	local var_29_6 = LocomotionUtils.pos_on_mesh(arg_29_0.nav_world, var_29_2)

	if not var_29_6 then
		print("No mesh found at spawn pos")

		return
	end

	local var_29_7 = 1
	local var_29_8 = 2
	local var_29_9 = 2
	local var_29_10 = var_29_9 / 2 + 0.3

	for iter_29_2 = -var_29_7, var_29_7 do
		for iter_29_3 = -var_29_8, var_29_8 do
			local var_29_11 = var_29_6 + Vector3(iter_29_2 * var_29_9, iter_29_3 * var_29_9, -1)

			QuickDrawerStay:sphere(var_29_11, var_29_10)

			local var_29_12

			if var_0_11 == "soft" then
				var_29_12 = GwNavCylinderObstacle.create(var_29_1, var_29_11, 3, var_29_10, false, Color(255, 255, 0), LAYER_ID_MAPPING.fire_grenade)

				GwNavCylinderObstacle.add_to_world(var_29_12)
				GwNavCylinderObstacle.set_does_trigger_tagvolume(var_29_12, true)
			elseif var_0_11 == "hard" then
				var_29_12 = GwNavCylinderObstacle.create_exclusive(var_29_1, var_29_11, 3, var_29_10)

				GwNavCylinderObstacle.add_to_world(var_29_12)
				GwNavCylinderObstacle.set_does_trigger_tagvolume(var_29_12, true)
			else
				local var_29_13 = GwNavTraversal.get_seed_triangle(var_29_1, var_29_11)
				local var_29_14, var_29_15, var_29_16 = GwNavTraversal.get_triangle_vertices(var_29_1, var_29_13)

				GwNavTraversal.get_neighboring_triangles(poly)
				GwNavNavTagVolume.create(var_29_1, poly_line, var_29_11.z - 2, var_29_11.z + 2, false, Color(0, 200, 45), LAYER_ID_MAPPING.fire_grenade)
			end

			var_0_9[var_29_12] = true
		end
	end
end

ConflictDirectorTests.spawn_liquid_blob = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0, var_30_1, var_30_2, var_30_3 = arg_30_0:player_aim_raycast(arg_30_0._world, false, "filter_ray_horde_spawn")

	if not var_30_0 then
		print("No spawn pos found")

		return
	end

	local var_30_4 = {
		props_system = {
			start_size = 0.3,
			duration = 0.5,
			end_size = 1
		}
	}
	local var_30_5 = "units/props/nurgle_liquid_blob/nurgle_liquid_blob_01"
	local var_30_6 = "nurgle_liquid_blob"
	local var_30_7 = Managers.state.unit_spawner:spawn_network_unit(var_30_5, "nurgle_liquid_blob", var_30_4, var_30_0)
end

ConflictDirectorTests.test_cover_points = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1.PLAYER_POSITIONS

	if not var_31_0[1] then
		return
	end

	local var_31_1 = arg_31_0.level_analysis.cover_points_broadphase
	local var_31_2 = Color(255, 0, 240, 0)
	local var_31_3 = Color(255, 240, 0, 0)
	local var_31_4 = {}

	Broadphase.query(var_31_1, var_31_0[1], 20, var_31_4)

	local var_31_5 = var_31_0[1]

	for iter_31_0 = 1, #var_31_4 do
		local var_31_6 = var_31_4[iter_31_0]
		local var_31_7 = Unit.local_position(var_31_6, 0)
		local var_31_8 = Unit.local_rotation(var_31_6, 0)
		local var_31_9 = Vector3.normalize(var_31_5 - var_31_7)

		if Vector3.dot(Quaternion.forward(var_31_8), var_31_9) > 0.9 then
			QuickDrawerStay:sphere(var_31_7, 1, var_31_2)
			QuickDrawerStay:line(var_31_7 + Vector3(0, 0, 1), var_31_7 + Quaternion.forward(var_31_8) * 2 + Vector3(0, 0, 1), var_31_2)
		else
			QuickDrawerStay:sphere(var_31_7, 1, var_31_3)
			QuickDrawerStay:line(var_31_7 + Vector3(0, 0, 1), var_31_7 + Quaternion.forward(var_31_8) * 2 + Vector3(0, 0, 1), var_31_3)
		end
	end

	arg_31_0.specials_pacing:get_special_spawn_pos()
end

ConflictDirectorTests.update_kill_tester = function (arg_32_0)
	if not script_data.kill_test then
		return
	end

	local var_32_0 = {
		"skaven_slave",
		"skaven_slave",
		"skaven_slave",
		"skaven_clan_rat",
		"chaos_marauder",
		"chaos_fanatic",
		"chaos_fanatic",
		"chaos_fanatic"
	}

	if not arg_32_0._kill_list then
		arg_32_0._kill_list = {}
		arg_32_0._kill_spawn_index = 1
	end

	local var_32_1 = arg_32_0._kill_spawn_index % #var_32_0 + 1

	arg_32_0._kill_spawn_index = var_32_1

	local var_32_2 = arg_32_0._kill_list
	local var_32_3 = var_32_0[var_32_1]
	local var_32_4 = Breeds[var_32_3]
	local var_32_5 = {
		ignore_breed_limits = true,
		spawned_func = function (arg_33_0, arg_33_1, arg_33_2)
			table.insert(arg_32_0._kill_list, 1, arg_33_0)
		end
	}
	local var_32_6 = Vector3Box(Vector3(0, 0, 0) + Vector3(var_32_1 * 1, 0, 0))
	local var_32_7 = QuaternionBox()

	arg_32_0:spawn_queued_unit(var_32_4, var_32_6, var_32_7, "debug_spawn", nil, nil, var_32_5)

	local var_32_8 = #var_32_2

	if var_32_8 >= 3 then
		local var_32_9 = var_32_2[var_32_8]

		var_32_2[var_32_8] = nil

		local var_32_10 = ScriptUnit.has_extension(var_32_9, "health_system")

		if var_32_10 and var_32_10:is_alive() then
			local var_32_11 = 255
			local var_32_12 = "full"
			local var_32_13 = "forced"
			local var_32_14 = Vector3(0, 0, 1)

			DamageUtils.add_damage_network(var_32_9, var_32_9, var_32_11, var_32_12, var_32_13, nil, var_32_14, "debug", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end
end

ConflictDirectorTests.nav_group_astar_test = function (arg_34_0, arg_34_1)
	if not arg_34_0.astar_path then
		print("ASTAR")

		local var_34_0, var_34_1 = arg_34_0.level_analysis:get_start_and_finish()
		local var_34_2 = GwNavTraversal.get_seed_triangle(arg_34_0.nav_world, arg_34_1.PLAYER_POSITIONS[1])
		local var_34_3 = GwNavTraversal.get_seed_triangle(arg_34_0.nav_world, var_34_1:unbox())

		if not var_34_2 or not var_34_3 then
			return false
		end

		local var_34_4 = arg_34_0.navigation_group_manager:get_polygon_group(var_34_2)
		local var_34_5 = arg_34_0.navigation_group_manager:get_polygon_group(var_34_3)
		local var_34_6 = arg_34_0.navigation_group_manager._navigation_groups
		local var_34_7, var_34_8 = LuaAStar.a_star_plain(var_34_6, var_34_4, var_34_5)

		arg_34_0.astar_path = var_34_7

		print("Generated path:", #var_34_7, var_34_8)
	end
end

ConflictDirectorTests.update_group_astar_test = function (arg_35_0, arg_35_1)
	if arg_35_0.astar_path then
		local var_35_0 = arg_35_0.astar_path
		local var_35_1

		for iter_35_0 = 1, #var_35_0 do
			local var_35_2 = var_35_0[iter_35_0]:get_group_center():unbox()

			QuickDrawer:sphere(var_35_2, 2)

			if var_35_1 then
				QuickDrawer:line(var_35_2 + Vector3(0, 0, 1), var_35_1 + Vector3(0, 0, 1), Color(255, 244, 143, 7))
			end

			var_35_1 = var_35_2
		end
	end
end

local function var_0_12(arg_36_0, arg_36_1, arg_36_2)
	out_list = {}

	for iter_36_0 = 1, #arg_36_0 do
		local var_36_0 = arg_36_0[iter_36_0]
		local var_36_1 = Vector3(var_36_0.pos[1], var_36_0.pos[2], 0)

		if arg_36_2 > Vector3.distance(arg_36_1, var_36_0) then
			out_list[#out_list + 1] = var_36_0
		end
	end

	return num
end

local function var_0_13(arg_37_0)
	local var_37_0 = 99
	local var_37_1
	local var_37_2

	for iter_37_0 = 1, #arg_37_0 do
		local var_37_3 = arg_37_0[iter_37_0]
		local var_37_4 = BLACKBOARDS[var_37_3]
		local var_37_5 = var_37_4.lean_dogpile

		if var_37_4 ~= blackboard and enemy_units_lookup[var_37_3] and var_37_5 < var_37_0 then
			var_37_0 = var_37_5
			var_37_2 = var_37_3

			if blackboard.lean_target_unit == var_37_3 then
				break
			end

			if iter_37_0 > 5 then
				break
			end
		end
	end

	if var_37_2 then
		return var_37_2, true
	else
		return nil, false
	end
end

function slot_testing(arg_38_0)
	for iter_38_0 = 1, #a do
		unit = a[iter_38_0]
	end
end

function setup_slot_testing()
	local var_39_0 = {
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
	local var_39_1 = {
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

	slot_testing(var_39_0, var_39_1)
end

ConflictDirectorTests.start_test = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = Managers.state.side:get_side_from_name("heroes") or Managers.state.side:get_side(1)

	arg_40_3 = arg_40_3 or "spawn_encampment"
	arg_40_0.conflict_director_tests_name = arg_40_3

	print("starting test:", arg_40_3)

	if arg_40_3 == "sparse" then
		for iter_40_0 = 1, 30 do
			for iter_40_1 = 1, 30 do
				local var_40_1 = var_40_0.PLAYER_POSITIONS[1]
				local var_40_2 = Vector3(var_40_1[1] + iter_40_0 * 0.3, var_40_1[2] + iter_40_1 * 0.3, var_40_1[3])

				ConflictDirectorTests.sparse_grid_test(var_40_2, var_40_0.PLAYER_UNITS[1])
			end
		end

		return
	elseif arg_40_3 == "lean_slot" then
		ConflictDirectorTests.lean_slot_test()
	elseif arg_40_3 == "drag_test" then
		ConflictDirectorTests.drag_test_start(var_40_0)
	elseif arg_40_3 == "tentacle" then
		ConflictDirectorTests.tentacle_test_start(var_40_0, arg_40_1, arg_40_2)
	elseif arg_40_3 == "mesh_cut" then
		ConflictDirectorTests.spawn_mesh_cut(arg_40_0)
	elseif arg_40_3 == "liquid_blob" then
		ConflictDirectorTests.spawn_liquid_blob(arg_40_0)
	elseif arg_40_3 == "reachable_coverpoints" then
		ConflictDirectorTests.setup_reachable_coverpoints_test(arg_40_0)
	elseif arg_40_3 == "reachable_navgraph" then
		ConflictDirectorTests.process_reachable_coverpoints_test(arg_40_0)
	elseif arg_40_3 == "test_cover_points" then
		ConflictDirectorTests.test_cover_points(arg_40_0, var_40_0)
	elseif arg_40_3 == "kill_tester" then
		script_data.kill_test = not script_data.kill_test
	elseif arg_40_3 == "nav_group_astar" then
		ConflictDirectorTests.nav_group_astar_test(arg_40_0, var_40_0)
	elseif arg_40_3 == "spawn_encampment" then
		if not GenericTerrorEvents.encampment then
			print("Missing terror event: encampment")

			return
		end

		local var_40_3, var_40_4, var_40_5, var_40_6 = arg_40_0:player_aim_raycast(arg_40_0._world, false, "filter_ray_horde_spawn")

		if not var_40_3 then
			print("No spawn pos found")

			return
		end

		local var_40_7 = {
			side_id = arg_40_0.debug_spawn_side_id,
			debug_pos = var_40_3,
			debug_dir = {
				0,
				1
			}
		}

		TerrorEventMixer.start_event("encampment4", var_40_7)

		local var_40_8 = {
			side_id = 1,
			debug_pos = var_40_3 + Vector3(0, 8, 0),
			debug_dir = {
				0,
				-1
			}
		}

		TerrorEventMixer.start_event("encampment4", var_40_8)

		return
	elseif arg_40_3 == "hull_test" then
		local var_40_9 = make_points_for_hull_test()
		local var_40_10, var_40_11 = convex_hull(var_40_9, {})
		local var_40_12 = 0.5

		for iter_40_2 = 1, var_40_11 do
			local var_40_13 = var_40_10[iter_40_2]
			local var_40_14

			if iter_40_2 == var_40_11 then
				var_40_14 = var_40_10[1]
			else
				var_40_14 = var_40_10[iter_40_2 + 1]
			end

			local var_40_15 = Vector3(var_40_13.x, var_40_13.y, var_40_12)
			local var_40_16 = Vector3(var_40_14.x, var_40_14.y, var_40_12)

			QuickDrawerStay:line(var_40_15, var_40_16, Color(200, 100, 100))
		end

		print("Convex Hull: ")
		print_points(var_40_10, var_40_11)
		print()
		print("Correct Output: Convex Hull: [(-9, -3), (-3, -9), (19, -8), (17, 5), (12, 17), (5, 19), (-3, 15)]")
	end
end

ConflictDirectorTests.update = function (arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0.conflict_director_tests_name
	local var_41_1 = Managers.state.side:get_side_from_name("heroes") or Managers.state.side:get_side(1)

	arg_41_0.hero_player_and_bot_positions = var_41_1.PLAYER_AND_BOT_POSITIONS
	arg_41_0.hero_player_positions = var_41_1.PLAYER_POSITIONS

	if var_41_0 == "sparse" then
		ConflictDirectorTests.draw_sparse_grid(var_41_1.PLAYER_POSITIONS[1])
	elseif var_41_0 == "jslots" then
		ConflictDirectorTests.update_jslots(var_41_1.PLAYER_UNITS[1])
	elseif var_41_0 == "lean_slot" then
		ConflictDirectorTests.lean_slot_test_update(var_41_1)
	elseif var_41_0 == "drag_test" then
		ConflictDirectorTests.drag_test_update(var_41_1)
	elseif var_41_0 == "tentacle" then
		ConflictDirectorTests.tentacle_test_update(var_41_1, arg_41_1, arg_41_2)
	elseif var_41_0 == "kill_test" then
		ConflictDirectorTests.update_kill_tester(arg_41_0, var_41_1)
	elseif var_41_0 == "nav_group_astar" then
		ConflictDirectorTests.update_group_astar_test(arg_41_0, var_41_1)
	end
end
