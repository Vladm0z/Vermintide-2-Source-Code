-- chunkname: @scripts/managers/conflict_director/patrol_analysis.lua

PatrolAnalysis = class(PatrolAnalysis)

local var_0_0 = {
	jumps = 1.5,
	ledges_with_fence = 1.5,
	doors = 1.5,
	teleporters = 5,
	ledges = 1.5
}
local var_0_1 = {
	jumps = 20,
	ledges_with_fence = 20,
	doors = 20,
	teleporters = 5,
	ledges = 20
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = #arg_1_0

	arg_1_0[var_1_0 + 1] = {
		255,
		0,
		arg_1_1,
		0
	}
	arg_1_0[var_1_0 + 2] = {
		255,
		0,
		0,
		arg_1_1
	}
	arg_1_0[var_1_0 + 3] = {
		255,
		arg_1_1,
		0,
		0
	}
	arg_1_0[var_1_0 + 4] = {
		255,
		arg_1_1,
		arg_1_1,
		0
	}
	arg_1_0[var_1_0 + 5] = {
		255,
		0,
		arg_1_1,
		arg_1_1
	}
	arg_1_0[var_1_0 + 6] = {
		255,
		arg_1_1,
		0,
		arg_1_1
	}
	arg_1_0[var_1_0 + 7] = {
		255,
		arg_1_2,
		arg_1_2,
		arg_1_1
	}
	arg_1_0[var_1_0 + 8] = {
		255,
		arg_1_1,
		arg_1_2,
		arg_1_2
	}
	arg_1_0[var_1_0 + 9] = {
		255,
		arg_1_2,
		arg_1_1,
		arg_1_2
	}
	arg_1_0[var_1_0 + 10] = {
		255,
		arg_1_1,
		arg_1_2,
		0
	}
	arg_1_0[var_1_0 + 11] = {
		255,
		arg_1_1,
		0,
		arg_1_2
	}
	arg_1_0[var_1_0 + 12] = {
		255,
		0,
		arg_1_2,
		arg_1_1
	}
	arg_1_0[var_1_0 + 1] = {
		255,
		arg_1_2,
		0,
		arg_1_1
	}
end

local var_0_3 = {}

var_0_2(var_0_3, 192, 64)
var_0_2(var_0_3, 128, 255)

local var_0_4 = #var_0_3

PatrolAnalysis.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.nav_world = arg_2_1
	arg_2_0.using_editor = arg_2_2
	arg_2_0.line_drawer = arg_2_3

	local var_2_0 = GwNavTagLayerCostTable.create()

	arg_2_0:setup_nav(var_0_0, var_2_0)

	local var_2_1 = GwNavCostMap.create_tag_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(var_2_1)

	local var_2_2 = GwNavTagLayerCostTable.create()

	arg_2_0:setup_nav(var_0_1, var_2_2)

	local var_2_3 = GwNavCostMap.create_tag_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(var_2_3)

	arg_2_0.patrol_waypoints = {}
	arg_2_0.running_splines = {}
	arg_2_0.ready_waypoints = {}
	arg_2_0.free_navbots_lists = {
		standard = {},
		roaming = {}
	}
	arg_2_0.navbot_setups = {
		standard = {
			nav_cost_map_cost_table = var_2_1,
			nav_cost_table = var_2_0
		},
		roaming = {
			nav_cost_map_cost_table = var_2_3,
			nav_cost_table = var_2_2
		}
	}
end

PatrolAnalysis.destroy = function (arg_3_0)
	local var_3_0 = arg_3_0.navbot_setups

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_1 = iter_3_1.nav_cost_table
		local var_3_2 = iter_3_1.nav_cost_map_cost_table

		GwNavTagLayerCostTable.destroy(var_3_1)
		GwNavCostMap.destroy_tag_cost_table(var_3_2)
	end

	local var_3_3 = arg_3_0.running_splines
	local var_3_4 = #var_3_3

	for iter_3_2 = 1, var_3_4 do
		local var_3_5 = var_3_3[iter_3_2].navbot

		GwNavBot.destroy(var_3_5)
	end

	local var_3_6 = arg_3_0.free_navbots_lists

	for iter_3_3, iter_3_4 in pairs(var_3_6) do
		for iter_3_5 = 1, #iter_3_4 do
			local var_3_7 = iter_3_4[iter_3_5]

			GwNavBot.destroy(var_3_7)
		end
	end
end

PatrolAnalysis.setup_nav = function (arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		local var_4_0 = LAYER_ID_MAPPING[iter_4_0]

		GwNavTagLayerCostTable.allow_layer(arg_4_2, var_4_0)
		GwNavTagLayerCostTable.set_layer_cost_multiplier(arg_4_2, var_4_0, iter_4_1)
	end
end

PatrolAnalysis.generate_patrol_splines = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	print("Generating patrol splines for level", arg_5_1)

	if not arg_5_1 then
		local var_5_0 = Managers.state.game_mode:level_key()

		arg_5_1 = LevelSettings[var_5_0].level_name
	end

	arg_5_0.running_splines = {}
	arg_5_0.ready_waypoints = {}
	arg_5_0.patrol_waypoints = {}
	arg_5_0.free_navbots_lists = {
		standard = {},
		roaming = {}
	}
	arg_5_0._spline_counter = 1

	local var_5_1 = arg_5_0:_generate_patrol_spline(arg_5_1, arg_5_2, "units/hub_elements/boss_waypoint", "boss_waypoint", arg_5_3, "standard")

	if var_5_1 ~= "success" then
		return var_5_1
	end

	local var_5_2 = arg_5_0:_generate_patrol_spline(arg_5_1, arg_5_2, "units/hub_elements/patrol_waypoint", "patrol_waypoint", arg_5_3, "roaming")

	if var_5_2 ~= "success" then
		return var_5_2
	end

	local var_5_3 = arg_5_0:_generate_patrol_spline(arg_5_1, arg_5_2, "units/hub_elements/event_waypoint", "event_waypoint", arg_5_3, "standard")

	if var_5_3 ~= "success" then
		return var_5_3
	end

	return (arg_5_0:_finilize_splines(arg_5_2, arg_5_3))
end

PatrolAnalysis._finilize_splines = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = "success"
	local var_6_1 = arg_6_0.patrol_waypoints
	local var_6_2

	for iter_6_0, iter_6_1 in pairs(var_6_1) do
		local var_6_3 = false

		while not var_6_3 do
			var_6_3 = true

			for iter_6_2 = 1, #iter_6_1 - 1 do
				if iter_6_1[iter_6_2].order > iter_6_1[iter_6_2 + 1].order then
					local var_6_4 = iter_6_1[iter_6_2]

					iter_6_1[iter_6_2] = iter_6_1[iter_6_2 + 1]
					iter_6_1[iter_6_2 + 1] = var_6_4
					var_6_3 = false
				end
			end
		end
	end

	for iter_6_3, iter_6_4 in pairs(var_6_1) do
		if #iter_6_4 <= 1 then
			var_6_0 = string.format("Spline of type '%s' with id '%s' has only one waypoint. Needs at least 2 waypoints.", iter_6_4.patrol_type, tostring(iter_6_4.id))
		end

		local var_6_5 = iter_6_4[1].pos:unbox()
		local var_6_6, var_6_7, var_6_8, var_6_9 = MainPathUtils.closest_pos_at_main_path_lua(arg_6_1, var_6_5)

		if not var_6_7 then
			var_6_0 = string.format("Patrol waypoint id '%s' cannot reach the main path. (%s) ", tostring(iter_6_4.id), iter_6_4.patrol_type)
		end

		iter_6_4.travel_dist = var_6_7

		print("Found spline of type:", iter_6_4.patrol_type, " with id:", iter_6_3, " ,points:", #iter_6_4)

		local var_6_10 = Vector3(0, 0, 1)
		local var_6_11

		for iter_6_5 = 1, #iter_6_4 do
			local var_6_12 = iter_6_4[iter_6_5]
			local var_6_13 = var_6_12.pos:unbox()
			local var_6_14, var_6_15, var_6_16, var_6_17 = MainPathUtils.closest_pos_at_main_path_lua(arg_6_1, var_6_5)

			var_6_12.travel_dist = var_6_15

			local var_6_18 = iter_6_4.patrol_type == "boss_waypoint" and Color(255, 125, 0) or Color(255, 255, 0)

			arg_6_2:line(var_6_5 + var_6_10, var_6_13 + var_6_10, var_6_18)

			var_6_5 = var_6_13
		end
	end

	return var_6_0
end

PatrolAnalysis._generate_patrol_spline = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = arg_7_0.patrol_waypoints
	local var_7_1 = "success"

	print("[PatrolAnalysis] Generating " .. arg_7_4 .. " splines for level:", arg_7_1, " Using gizmo-unit:", arg_7_3)

	local var_7_2 = Script.index_offset()
	local var_7_3 = LevelEditor.objects

	for iter_7_0, iter_7_1 in pairs(var_7_3) do
		local var_7_4 = iter_7_1._unit

		if Unit.alive(var_7_4) and Unit.is_a(var_7_4, arg_7_3) then
			local var_7_5 = Unit.local_position(var_7_4, var_7_2)
			local var_7_6 = iter_7_1:script_data_overrides()
			local var_7_7 = Unit.get_data(var_7_4, "patrol_id")
			local var_7_8 = Unit.get_data(var_7_4, "map_section")
			local var_7_9 = Unit.get_data(var_7_4, "one_directional")
			local var_7_10 = var_7_0[var_7_7]

			if not var_7_10 then
				var_7_10 = {
					wp_index = 2,
					id = var_7_7,
					patrol_type = arg_7_4,
					map_section = var_7_8,
					navbot_kind = arg_7_6,
					index = arg_7_0._spline_counter,
					one_directional = var_7_9
				}
				var_7_0[var_7_7] = var_7_10
				arg_7_0._spline_counter = arg_7_0._spline_counter + 1
			end

			local var_7_11 = Unit.get_data(var_7_4, "order")
			local var_7_12 = tonumber(var_7_11)
			local var_7_13 = #var_7_10 + 1

			print("FOUND WAYPOINT:", var_7_7, var_7_12)

			if not GwNavTraversal.get_seed_triangle(arg_7_0.nav_world, var_7_5) then
				var_7_1 = string.format("Patrol id '%s', waypoint with order '%s' is outside of navigation mesh. (%s)", tostring(var_7_7), tostring(var_7_12), iter_7_1.name)
			end

			for iter_7_2 = 1, #var_7_10 do
				if var_7_12 < var_7_10[iter_7_2].order then
					var_7_13 = iter_7_2

					break
				elseif var_7_12 == var_7_10[iter_7_2].order then
					var_7_13 = iter_7_2
					var_7_1 = string.format("Patrol id '%s', has two waypoints with the same order order '%s' (%s)", tostring(var_7_7), tostring(var_7_12), iter_7_1.name)

					break
				end
			end

			table.insert(var_7_10, var_7_13, {
				travel_dist = 0,
				pos = Vector3Box(var_7_5),
				order = var_7_12
			})
		end
	end

	return var_7_1
end

local var_0_5 = 0.38
local var_0_6 = true

PatrolAnalysis.create_navbot = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = 5
	local var_8_1 = 1.6
	local var_8_2 = arg_8_0.navbot_setups[arg_8_3]
	local var_8_3 = var_8_2.nav_cost_table
	local var_8_4 = var_8_2.nav_cost_map_cost_table
	local var_8_5 = false
	local var_8_6 = GwNavBot.create(arg_8_1, var_8_1, var_0_5, var_8_0, arg_8_2, var_8_4, var_8_5)

	GwNavBot.set_use_avoidance(var_8_6, false)
	GwNavBot.set_navtag_layer_cost_table(var_8_6, var_8_3)

	if var_0_6 then
		local var_8_7 = 4
		local var_8_8 = 30
		local var_8_9 = 30
		local var_8_10 = 1
		local var_8_11 = 20

		GwNavBot.set_channel_computer_configuration(var_8_6, var_8_7, var_8_8, var_8_9, var_8_10, var_8_11)

		local var_8_12 = false
		local var_8_13 = 5
		local var_8_14 = 100
		local var_8_15 = 0.5
		local var_8_16 = 1
		local var_8_17 = 0

		GwNavBot.set_spline_trajectory_configuration(var_8_6, var_8_12, var_8_13, var_8_14, var_8_15, var_8_16, var_8_17)
		GwNavBot.set_use_channel(var_8_6, true)
	end

	return var_8_6
end

local var_0_7 = 0.01

PatrolAnalysis.inject_spline_path = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.navbot
	local var_9_1 = GwNavBot.get_path_nodes_count(var_9_0)
	local var_9_2 = arg_9_1.spline_points or {}
	local var_9_3 = arg_9_1.spline_points_index or 1

	if not arg_9_0.using_editor then
		local var_9_4 = script_data.debug_patrols
	end

	if var_9_1 > 0 then
		local var_9_5 = GwNavBot.get_path_current_node_index(var_9_0)
		local var_9_6 = Vector3.up() * 0.05

		for iter_9_0 = 0, var_9_1 - 1 do
			local var_9_7 = GwNavBot.get_path_node_pos(var_9_0, iter_9_0)

			var_9_2[var_9_3] = Vector3Box(var_9_7)
			var_9_3 = var_9_3 + 1
		end
	end

	for iter_9_1 = #var_9_2, 2, -1 do
		local var_9_8 = var_9_2[iter_9_1]:unbox()
		local var_9_9 = var_9_2[iter_9_1 - 1]:unbox()

		if Vector3.distance(var_9_8, var_9_9) < var_0_7 then
			table.remove(var_9_2, iter_9_1)

			var_9_3 = var_9_3 - 1

			print("PATROL ANALYSIS removed bad spline point - too close to each other:", Vector3.distance(var_9_8, var_9_9), arg_9_1.id)
		end
	end

	arg_9_1.spline_points = var_9_2
	arg_9_1.spline_points_index = var_9_3
end

local var_0_8 = 10

PatrolAnalysis.compute_spline_path = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = {
		unique_navbot = true,
		wp_index = 2,
		id = arg_10_1,
		navbot_kind = arg_10_3
	}

	for iter_10_0, iter_10_1 in ipairs(arg_10_2) do
		table.insert(var_10_0, iter_10_0, {
			pos = iter_10_1,
			order = iter_10_0
		})
	end

	arg_10_0.patrol_waypoints[arg_10_1] = var_10_0
end

PatrolAnalysis.spline = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.ready_waypoints

	for iter_11_0, iter_11_1 in ipairs(var_11_0) do
		if iter_11_1.id == arg_11_1 then
			return iter_11_1
		end
	end
end

PatrolAnalysis.draw_raw_spline = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:spline(arg_12_1)
	local var_12_1 = var_12_0[1].pos:unbox()

	QuickDrawerStay:sphere(var_12_1, 0.33, Color(0, 200, 175))

	for iter_12_0 = 2, #var_12_0 do
		local var_12_2 = var_12_0[iter_12_0].pos:unbox()

		QuickDrawerStay:sphere(var_12_1, 0.33, Color(200, 40, 0))
		QuickDrawerStay:line(var_12_1, var_12_2, Color(0, 200, 175))

		var_12_1 = var_12_2
	end
end

PatrolAnalysis.draw_astar_spline = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1[1]:unbox()

	QuickDrawerStay:sphere(var_13_0, 0.33, Color(0, 200, 175))

	for iter_13_0 = 2, #arg_13_1 do
		local var_13_1 = arg_13_1[iter_13_0]:unbox()

		QuickDrawerStay:sphere(var_13_0, 0.23, Color(0, 200, 175))
		QuickDrawerStay:line(var_13_0, var_13_1, Color(0, 200, 175))

		var_13_0 = var_13_1
	end
end

local var_0_9 = Vector3.distance
local var_0_10 = Vector3.length

PatrolAnalysis.get_path_point = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_2 or arg_14_0:get_path_length(arg_14_1)
	local var_14_1 = 0
	local var_14_2 = arg_14_3 * var_14_0

	for iter_14_0 = 1, #arg_14_1 - 1 do
		local var_14_3 = arg_14_1[iter_14_0]:unbox()
		local var_14_4 = arg_14_1[iter_14_0 + 1]:unbox() - var_14_3
		local var_14_5 = var_0_10(var_14_4)

		var_14_1 = var_14_1 + var_14_5

		if var_14_2 < var_14_1 then
			return var_14_3 + var_14_4 * ((var_14_5 - (var_14_1 - var_14_2)) / var_14_5), iter_14_0
		end
	end

	return arg_14_1[#arg_14_1]:unbox(), #arg_14_1
end

PatrolAnalysis.get_path_length = function (arg_15_0, arg_15_1)
	local var_15_0 = 0
	local var_15_1 = arg_15_1[1]:unbox()

	for iter_15_0 = 2, #arg_15_1 do
		local var_15_2 = arg_15_1[iter_15_0]:unbox()

		var_15_0 = var_15_0 + var_0_9(var_15_1, var_15_2)
		var_15_1 = var_15_2
	end

	return var_15_0
end

PatrolAnalysis.run = function (arg_16_0)
	local var_16_0 = arg_16_0.line_drawer
	local var_16_1 = arg_16_0.running_splines
	local var_16_2 = arg_16_0.free_navbots_lists
	local var_16_3 = arg_16_0.patrol_waypoints
	local var_16_4 = arg_16_0.ready_waypoints

	while #var_16_1 < var_0_8 do
		local var_16_5, var_16_6 = next(var_16_3)

		if var_16_6 then
			var_16_1[#var_16_1 + 1] = var_16_6
			var_16_3[var_16_5] = nil

			local var_16_7 = var_16_6[1].pos:unbox()
			local var_16_8 = var_16_6[2].pos:unbox()
			local var_16_9
			local var_16_10 = var_16_6.navbot_kind or "standard"
			local var_16_11 = var_16_2[var_16_10]
			local var_16_12 = #var_16_11
			local var_16_13 = var_16_6.unique_navbot

			if var_16_12 == 0 or var_16_13 then
				print("> starting new spline, using new navbot:", var_16_10, ", id:", var_16_5)

				var_16_9 = arg_16_0:create_navbot(arg_16_0.nav_world, var_16_7, var_16_10)
			else
				print("> starting new spline, recycling navbot of kind:", var_16_10, ", id:", var_16_5)

				var_16_9 = var_16_11[var_16_12]
				var_16_11[var_16_12] = nil
			end

			var_16_6.navbot = var_16_9

			GwNavBot.update_position(var_16_9, var_16_7)
			GwNavBot.compute_new_path(var_16_9, var_16_8)
		else
			break
		end
	end

	local var_16_14 = #var_16_1
	local var_16_15 = 1

	while var_16_15 <= var_16_14 do
		local var_16_16 = var_16_1[var_16_15]
		local var_16_17 = var_16_16.navbot

		if not GwNavBot.is_computing_new_path(var_16_17) then
			local var_16_18 = var_16_16.wp_index
			local var_16_19 = var_16_16.retries or 0

			if GwNavBot.get_path_nodes_count(var_16_17) > 0 then
				arg_16_0:inject_spline_path(var_16_16, var_16_0)
			else
				print("\t> spline segment failed", var_16_16.id, "index:", var_16_18, "retries:", var_16_19)

				var_16_18 = math.max(var_16_18 - 1, 1)
				var_16_16.retries = var_16_19 + 1
				var_16_16.failed = var_16_16.retries >= 3
			end

			if var_16_18 < #var_16_16 and not var_16_16.failed then
				print("\t> continuing spline", var_16_16.id, "index:", var_16_18, "retries:", var_16_19)

				local var_16_20 = var_16_16[var_16_18].pos:unbox()

				GwNavBot.update_position(var_16_17, var_16_20)

				local var_16_21 = var_16_18 + 1
				local var_16_22 = var_16_16[var_16_21].pos:unbox()

				GwNavBot.compute_new_path(var_16_17, var_16_22)

				var_16_16.wp_index = var_16_21
				var_16_15 = var_16_15 + 1
			else
				print("\t> spline completed", var_16_16.id, "retries:", var_16_19)

				if not var_16_16.spline_points then
					local var_16_23 = var_16_16[1].pos:unbox()
					local var_16_24 = var_16_16[2].pos:unbox()
					local var_16_25 = Vector3.normalize(var_16_24 - var_16_23)

					var_16_16.spline_points = {
						Vector3Box(var_16_23),
						Vector3Box(var_16_23 + var_16_25)
					}
					var_16_16.spline_points_index = 2

					print("\t> spline segment aborted after 3 tries -> " .. table.tostring(var_16_16))
				end

				if var_16_16.unique_navbot then
					GwNavBot.destroy(var_16_17)
				else
					local var_16_26 = var_16_2[var_16_16.navbot_kind or "standard"]

					var_16_26[#var_16_26 + 1] = var_16_17
				end

				var_16_16.navbot = nil
				var_16_1[var_16_15] = var_16_1[var_16_14]
				var_16_1[var_16_14] = nil
				var_16_4[#var_16_4 + 1] = var_16_16
				var_16_14 = var_16_14 - 1
			end
		else
			var_16_15 = var_16_15 + 1
		end
	end

	if var_16_14 <= 0 then
		for iter_16_0, iter_16_1 in pairs(var_16_2) do
			for iter_16_2 = 1, #iter_16_1 do
				local var_16_27 = iter_16_1[iter_16_2]

				GwNavBot.destroy(var_16_27)
			end
		end

		return "success", var_16_4
	end
end
