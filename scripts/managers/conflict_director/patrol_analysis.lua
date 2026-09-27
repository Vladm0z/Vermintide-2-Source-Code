-- chunkname: @scripts/managers/conflict_director/patrol_analysis.lua

PatrolAnalysis = class(PatrolAnalysis)

local tbl = {
	jumps = 1.5,
	ledges_with_fence = 1.5,
	doors = 1.5,
	teleporters = 5,
	ledges = 1.5
}
local tbl_2 = {
	jumps = 20,
	ledges_with_fence = 20,
	doors = 20,
	teleporters = 5,
	ledges = 20
}

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	local count = #self

	self[count + 1] = {
		255,
		0,
		arg_1_1,
		0
	}
	self[count + 2] = {
		255,
		0,
		0,
		arg_1_1
	}
	self[count + 3] = {
		255,
		arg_1_1,
		0,
		0
	}
	self[count + 4] = {
		255,
		arg_1_1,
		arg_1_1,
		0
	}
	self[count + 5] = {
		255,
		0,
		arg_1_1,
		arg_1_1
	}
	self[count + 6] = {
		255,
		arg_1_1,
		0,
		arg_1_1
	}
	self[count + 7] = {
		255,
		arg_1_2,
		arg_1_2,
		arg_1_1
	}
	self[count + 8] = {
		255,
		arg_1_1,
		arg_1_2,
		arg_1_2
	}
	self[count + 9] = {
		255,
		arg_1_2,
		arg_1_1,
		arg_1_2
	}
	self[count + 10] = {
		255,
		arg_1_1,
		arg_1_2,
		0
	}
	self[count + 11] = {
		255,
		arg_1_1,
		0,
		arg_1_2
	}
	self[count + 12] = {
		255,
		0,
		arg_1_2,
		arg_1_1
	}
	self[count + 1] = {
		255,
		arg_1_2,
		0,
		arg_1_1
	}
end

local tbl_3 = {}

fn(tbl_3, 192, 64)
fn(tbl_3, 128, 255)

local count = #tbl_3

PatrolAnalysis.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self.nav_world = arg_2_1
	self.using_editor = arg_2_2
	self.line_drawer = arg_2_3

	local var_2_0 = GwNavTagLayerCostTable.create()

	self:setup_nav(tbl, var_2_0)

	local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table)

	local var_2_2 = GwNavTagLayerCostTable.create()

	self:setup_nav(tbl_2, var_2_2)

	local create_tag_cost_table_2 = GwNavCostMap.create_tag_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table_2)

	self.patrol_waypoints = {}
	self.running_splines = {}
	self.ready_waypoints = {}
	self.free_navbots_lists = {
		standard = {},
		roaming = {}
	}
	self.navbot_setups = {
		standard = {
			nav_cost_map_cost_table = create_tag_cost_table,
			nav_cost_table = var_2_0
		},
		roaming = {
			nav_cost_map_cost_table = create_tag_cost_table_2,
			nav_cost_table = var_2_2
		}
	}
end

PatrolAnalysis.destroy = function (self)
	-- function 3
	local navbot_setups = self.navbot_setups

	for k, v in pairs(navbot_setups) do
		local nav_cost_table = v.nav_cost_table
		local nav_cost_map_cost_table = v.nav_cost_map_cost_table

		GwNavTagLayerCostTable.destroy(nav_cost_table)
		GwNavCostMap.destroy_tag_cost_table(nav_cost_map_cost_table)
	end

	local running_splines = self.running_splines
	local count = #running_splines

	for k_2 = 1, count do
		local navbot = running_splines[k_2].navbot

		GwNavBot.destroy(navbot)
	end

	local free_navbots_lists = self.free_navbots_lists

	for k_3, v_2 in pairs(free_navbots_lists) do
		for i5 = 1, #v_2 do
			local var_3_7 = v_2[i5]

			GwNavBot.destroy(var_3_7)
		end
	end
end

PatrolAnalysis.setup_nav = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	for k, v in pairs(arg_4_1) do
		local var_4_0 = LAYER_ID_MAPPING[k]

		GwNavTagLayerCostTable.allow_layer(arg_4_2, var_4_0)
		GwNavTagLayerCostTable.set_layer_cost_multiplier(arg_4_2, var_4_0, v)
	end
end

PatrolAnalysis.generate_patrol_splines = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	print("Generating patrol splines for level", arg_5_1)

	if not arg_5_1 then
		local level_key = Managers.state.game_mode:level_key()

		arg_5_1 = LevelSettings[level_key].level_name
	end

	self.running_splines = {}
	self.ready_waypoints = {}
	self.patrol_waypoints = {}
	self.free_navbots_lists = {
		standard = {},
		roaming = {}
	}
	self._spline_counter = 1

	local _generate_patrol_spline = self:_generate_patrol_spline(arg_5_1, arg_5_2, "units/hub_elements/boss_waypoint", "boss_waypoint", arg_5_3, "standard")

	if _generate_patrol_spline ~= "success" then
		return _generate_patrol_spline
	end

	local _generate_patrol_spline_2 = self:_generate_patrol_spline(arg_5_1, arg_5_2, "units/hub_elements/patrol_waypoint", "patrol_waypoint", arg_5_3, "roaming")

	if _generate_patrol_spline_2 ~= "success" then
		return _generate_patrol_spline_2
	end

	local _generate_patrol_spline_3 = self:_generate_patrol_spline(arg_5_1, arg_5_2, "units/hub_elements/event_waypoint", "event_waypoint", arg_5_3, "standard")

	if _generate_patrol_spline_3 ~= "success" then
		return _generate_patrol_spline_3
	end

	return (self:_finilize_splines(arg_5_2, arg_5_3))
end

PatrolAnalysis._finilize_splines = function (self, arg_6_1, arg_6_2)
	-- function 6
	local str = "success"
	local patrol_waypoints = self.patrol_waypoints
	local var_6_2

	for k, v in pairs(patrol_waypoints) do
		local flag = false

		while not flag do
			flag = true

			for k_2 = 1, #v - 1 do
				if v[k_2].order > v[k_2 + 1].order then
					local var_6_4 = v[k_2]

					v[k_2] = v[k_2 + 1]
					v[k_2 + 1] = var_6_4
					flag = false
				end
			end
		end
	end

	for k_3, v_2 in pairs(patrol_waypoints) do
		if #v_2 <= 1 then
			str = string.format("Spline of type '%s' with id '%s' has only one waypoint. Needs at least 2 waypoints.", v_2.patrol_type, tostring(v_2.id))
		end

		local unbox = v_2[1].pos:unbox()
		local closest_pos_at_main_path_lua, var_6_7, var_6_8, var_6_9 = MainPathUtils.closest_pos_at_main_path_lua(arg_6_1, unbox)

		if not var_6_7 then
			str = string.format("Patrol waypoint id '%s' cannot reach the main path. (%s) ", tostring(v_2.id), v_2.patrol_type)
		end

		v_2.travel_dist = var_6_7

		print("Found spline of type:", v_2.patrol_type, " with id:", k_3, " ,points:", #v_2)

		local var_6_10 = Vector3(0, 0, 1)
		local var_6_11

		for i5 = 1, #v_2 do
			local var_6_12 = v_2[i5]
			local unbox_2 = var_6_12.pos:unbox()
			local closest_pos_at_main_path_lua_2, var_6_15, var_6_16, var_6_17 = MainPathUtils.closest_pos_at_main_path_lua(arg_6_1, unbox)

			var_6_12.travel_dist = var_6_15

			local var_6_18

			if v_2.patrol_type == "boss_waypoint" then
				var_6_18 = Color(255, 125, 0)

				if not var_6_18 then
					-- Nothing
				end
			end

			var_6_18 = Color(255, 255, 0)

			::label_6_0::

			arg_6_2:line(unbox + var_6_10, unbox_2 + var_6_10, var_6_18)

			unbox = unbox_2
		end
	end

	return str
end

PatrolAnalysis._generate_patrol_spline = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local patrol_waypoints = self.patrol_waypoints
	local str = "success"

	print("[PatrolAnalysis] Generating " .. arg_7_4 .. " splines for level:", arg_7_1, " Using gizmo-unit:", arg_7_3)

	local index_offset = Script.index_offset()
	local objects = LevelEditor.objects

	for k, v in pairs(objects) do
		local _unit = v._unit

		if not Unit.alive(_unit) and not Unit.is_a(_unit, arg_7_3) then
			local local_position = Unit.local_position(_unit, index_offset)
			local script_data_overrides = v:script_data_overrides()
			local get_data = Unit.get_data(_unit, "patrol_id")
			local get_data_2 = Unit.get_data(_unit, "map_section")
			local get_data_3 = Unit.get_data(_unit, "one_directional")
			local var_7_10 = patrol_waypoints[get_data]

			if not var_7_10 then
				var_7_10 = {
					wp_index = 2,
					id = get_data,
					patrol_type = arg_7_4,
					map_section = get_data_2,
					navbot_kind = arg_7_6,
					index = self._spline_counter,
					one_directional = get_data_3
				}
				patrol_waypoints[get_data] = var_7_10
				self._spline_counter = self._spline_counter + 1
			end

			local get_data_4 = Unit.get_data(_unit, "order")
			local var_7_12 = tonumber(get_data_4)
			local num = #var_7_10 + 1

			print("FOUND WAYPOINT:", get_data, var_7_12)

			if not GwNavTraversal.get_seed_triangle(self.nav_world, local_position) then
				str = string.format("Patrol id '%s', waypoint with order '%s' is outside of navigation mesh. (%s)", tostring(get_data), tostring(var_7_12), v.name)
			end

			for k_2 = 1, #var_7_10 do
				if var_7_12 < var_7_10[k_2].order then
					num = k_2

					break
				elseif var_7_12 == var_7_10[k_2].order then
					num = k_2
					str = string.format("Patrol id '%s', has two waypoints with the same order order '%s' (%s)", tostring(get_data), tostring(var_7_12), v.name)

					break
				end
			end

			table.insert(var_7_10, num, {
				travel_dist = 0,
				pos = Vector3Box(local_position),
				order = var_7_12
			})
		end
	end

	return str
end

local num = 0.38
local flag = true

PatrolAnalysis.create_navbot = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local num_2 = 5
	local num_3 = 1.6
	local var_8_2 = self.navbot_setups[arg_8_3]
	local nav_cost_table = var_8_2.nav_cost_table
	local nav_cost_map_cost_table = var_8_2.nav_cost_map_cost_table
	local flag_2 = false
	local var_8_6 = GwNavBot.create(arg_8_1, num_3, num, num_2, arg_8_2, nav_cost_map_cost_table, flag_2)

	GwNavBot.set_use_avoidance(var_8_6, false)
	GwNavBot.set_navtag_layer_cost_table(var_8_6, nav_cost_table)

	if not flag then
		local num_4 = 4
		local num_5 = 30
		local num_6 = 30
		local num_7 = 1
		local num_8 = 20

		GwNavBot.set_channel_computer_configuration(var_8_6, num_4, num_5, num_6, num_7, num_8)

		local flag_3 = false
		local num_9 = 5
		local num_10 = 100
		local num_11 = 0.5
		local num_12 = 1
		local num_13 = 0

		GwNavBot.set_spline_trajectory_configuration(var_8_6, flag_3, num_9, num_10, num_11, num_12, num_13)
		GwNavBot.set_use_channel(var_8_6, true)
	end

	return var_8_6
end

local num_2 = 0.01

PatrolAnalysis.inject_spline_path = function (self, arg_9_1, arg_9_2)
	-- function 9
	local navbot = arg_9_1.navbot
	local get_path_nodes_count = GwNavBot.get_path_nodes_count(navbot)
	local spline_points = arg_9_1.spline_points

	spline_points = spline_points or {}

	local spline_points_index = arg_9_1.spline_points_index

	spline_points_index = spline_points_index or 1

	if not self.using_editor then
		local debug_patrols = script_data.debug_patrols
	end

	if get_path_nodes_count > 0 then
		local get_path_current_node_index = GwNavBot.get_path_current_node_index(navbot)
		local num = Vector3.up() * 0.05

		for i = 0, get_path_nodes_count - 1 do
			local get_path_node_pos = GwNavBot.get_path_node_pos(navbot, i)

			spline_points[spline_points_index] = Vector3Box(get_path_node_pos)
			spline_points_index = spline_points_index + 1
		end
	end

	for j = #spline_points, 2, -1 do
		local unbox = spline_points[j]:unbox()
		local unbox_2 = spline_points[j - 1]:unbox()

		if Vector3.distance(unbox, unbox_2) < num_2 then
			table.remove(spline_points, j)

			spline_points_index = spline_points_index - 1

			print("PATROL ANALYSIS removed bad spline point - too close to each other:", Vector3.distance(unbox, unbox_2), arg_9_1.id)
		end
	end

	arg_9_1.spline_points = spline_points
	arg_9_1.spline_points_index = spline_points_index
end

local num_3 = 10

PatrolAnalysis.compute_spline_path = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local tbl = {
		unique_navbot = true,
		wp_index = 2,
		id = arg_10_1,
		navbot_kind = arg_10_3
	}

	for i, v in ipairs(arg_10_2) do
		table.insert(tbl, i, {
			pos = v,
			order = i
		})
	end

	arg_10_0.patrol_waypoints[arg_10_1] = tbl
end

PatrolAnalysis.spline = function (self, arg_11_1)
	-- function 11
	local ready_waypoints = self.ready_waypoints

	for i, v in ipairs(ready_waypoints) do
		if v.id == arg_11_1 then
			return v
		end
	end
end

PatrolAnalysis.draw_raw_spline = function (self, arg_12_1)
	-- function 12
	local spline = self:spline(arg_12_1)
	local unbox = spline[1].pos:unbox()

	QuickDrawerStay:sphere(unbox, 0.33, Color(0, 200, 175))

	for i = 2, #spline do
		local unbox_2 = spline[i].pos:unbox()

		QuickDrawerStay:sphere(unbox, 0.33, Color(200, 40, 0))
		QuickDrawerStay:line(unbox, unbox_2, Color(0, 200, 175))

		unbox = unbox_2
	end
end

PatrolAnalysis.draw_astar_spline = function (arg_13_0, arg_13_1)
	-- function 13
	local unbox = arg_13_1[1]:unbox()

	QuickDrawerStay:sphere(unbox, 0.33, Color(0, 200, 175))

	for i = 2, #arg_13_1 do
		local unbox_2 = arg_13_1[i]:unbox()

		QuickDrawerStay:sphere(unbox, 0.23, Color(0, 200, 175))
		QuickDrawerStay:line(unbox, unbox_2, Color(0, 200, 175))

		unbox = unbox_2
	end
end

local distance = Vector3.distance
local length = Vector3.length

PatrolAnalysis.get_path_point = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local flag = arg_14_2 or self:get_path_length(arg_14_1)
	local num = 0
	local num_2 = arg_14_3 * flag

	for i = 1, #arg_14_1 - 1 do
		local unbox = arg_14_1[i]:unbox()
		local num_3 = arg_14_1[i + 1]:unbox() - unbox
		local var_14_5 = length(num_3)

		num = num + var_14_5

		if num_2 < num then
			return unbox + num_3 * ((var_14_5 - (num - num_2)) / var_14_5), i
		end
	end

	return arg_14_1[#arg_14_1]:unbox(), #arg_14_1
end

PatrolAnalysis.get_path_length = function (arg_15_0, arg_15_1)
	-- function 15
	local num = 0
	local unbox = arg_15_1[1]:unbox()

	for i = 2, #arg_15_1 do
		local unbox_2 = arg_15_1[i]:unbox()

		num = num + distance(unbox, unbox_2)
		unbox = unbox_2
	end

	return num
end

PatrolAnalysis.run = function (self)
	-- function 16
	local line_drawer = self.line_drawer
	local running_splines = self.running_splines
	local free_navbots_lists = self.free_navbots_lists
	local patrol_waypoints = self.patrol_waypoints
	local ready_waypoints = self.ready_waypoints

	while #running_splines < num_3 do
		local var_16_5, var_16_6 = next(patrol_waypoints)

		if not var_16_6 then
			running_splines[#running_splines + 1] = var_16_6
			patrol_waypoints[var_16_5] = nil

			local unbox = var_16_6[1].pos:unbox()
			local unbox_2 = var_16_6[2].pos:unbox()
			local var_16_9
			local navbot_kind = var_16_6.navbot_kind

			navbot_kind = navbot_kind or "standard"

			local var_16_11 = free_navbots_lists[navbot_kind]
			local count = #var_16_11
			local unique_navbot = var_16_6.unique_navbot

			if count == 0 or not unique_navbot then
				print("> starting new spline, using new navbot:", navbot_kind, ", id:", var_16_5)

				var_16_9 = self:create_navbot(self.nav_world, unbox, navbot_kind)
			else
				print("> starting new spline, recycling navbot of kind:", navbot_kind, ", id:", var_16_5)

				var_16_9 = var_16_11[count]
				var_16_11[count] = nil
			end

			var_16_6.navbot = var_16_9

			GwNavBot.update_position(var_16_9, unbox)
			GwNavBot.compute_new_path(var_16_9, unbox_2)
		else
			break
		end
	end

	local count_2 = #running_splines
	local num = 1

	while num <= count_2 do
		local var_16_16 = running_splines[num]
		local navbot = var_16_16.navbot

		if not not GwNavBot.is_computing_new_path(navbot) then
			local wp_index = var_16_16.wp_index
			local retries = var_16_16.retries

			retries = retries or 0

			if GwNavBot.get_path_nodes_count(navbot) > 0 then
				self:inject_spline_path(var_16_16, line_drawer)
			else
				print("\t> spline segment failed", var_16_16.id, "index:", wp_index, "retries:", retries)

				wp_index = math.max(wp_index - 1, 1)
				var_16_16.retries = retries + 1
				var_16_16.failed = var_16_16.retries >= 3
			end

			if not (not (wp_index < #var_16_16) or var_16_16.failed) then
				print("\t> continuing spline", var_16_16.id, "index:", wp_index, "retries:", retries)

				local unbox_3 = var_16_16[wp_index].pos:unbox()

				GwNavBot.update_position(navbot, unbox_3)

				local num_2 = wp_index + 1
				local unbox_4 = var_16_16[num_2].pos:unbox()

				GwNavBot.compute_new_path(navbot, unbox_4)

				var_16_16.wp_index = num_2
				num = num + 1
			else
				print("\t> spline completed", var_16_16.id, "retries:", retries)

				if not var_16_16.spline_points then
					local unbox_5 = var_16_16[1].pos:unbox()
					local unbox_6 = var_16_16[2].pos:unbox()
					local normalize = Vector3.normalize(unbox_6 - unbox_5)

					var_16_16.spline_points = {
						Vector3Box(unbox_5),
						Vector3Box(unbox_5 + normalize)
					}
					var_16_16.spline_points_index = 2

					print("\t> spline segment aborted after 3 tries -> " .. table.tostring(var_16_16))
				end

				if not var_16_16.unique_navbot then
					GwNavBot.destroy(navbot)
				else
					local navbot_kind_2 = var_16_16.navbot_kind

					navbot_kind_2 = navbot_kind_2 or "standard"

					local var_16_27 = free_navbots_lists[navbot_kind_2]

					var_16_27[#var_16_27 + 1] = navbot
				end

				var_16_16.navbot = nil
				running_splines[num] = running_splines[count_2]
				running_splines[count_2] = nil
				ready_waypoints[#ready_waypoints + 1] = var_16_16
				count_2 = count_2 - 1
			end
		else
			num = num + 1
		end
	end

	if count_2 <= 0 then
		for k, v in pairs(free_navbots_lists) do
			for k_2 = 1, #v do
				local var_16_28 = v[k_2]

				GwNavBot.destroy(var_16_28)
			end
		end

		return "success", ready_waypoints
	end
end
