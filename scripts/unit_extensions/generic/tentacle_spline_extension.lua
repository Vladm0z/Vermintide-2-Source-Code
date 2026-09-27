-- chunkname: @scripts/unit_extensions/generic/tentacle_spline_extension.lua

require("foundation/scripts/util/spline_curve")

TentacleSplineExtension = class(TentacleSplineExtension)

local flag = false
local flag_2 = false
local flag_3 = false
local flag_4 = false

TentacleSplineExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.is_server, self._unit = Managers.player.is_server, arg_1_2
	self.world = arg_1_1.world

	local tentacle_template_name = arg_1_3.tentacle_template_name

	self.tentacle_template, self.tentacle_template_name = TentacleTemplates[tentacle_template_name], tentacle_template_name
	self.portal_unit = arg_1_3.portal_unit
	self.side_id = arg_1_3.side_id
end

TentacleSplineExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = BLACKBOARDS[arg_2_2]

	var_2_0 = var_2_0 or {}
	self.blackboard = var_2_0

	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	self.nav_world = nav_world

	local tentacle_template = self.tentacle_template
	local is_server = self.is_server
	local time = Managers.time:time("game")
	local spawn_chaos_tentacle, var_2_6 = self:spawn_chaos_tentacle(arg_2_2, var_2_0, nav_world, is_server, time, self.portal_unit, tentacle_template, self.side_id)

	self.tentacle_data = spawn_chaos_tentacle
	var_2_0.tentacle_data = spawn_chaos_tentacle
	self.portal_unit = spawn_chaos_tentacle.portal_unit
	self.breed = var_2_6

	print("TENTACLE BREED", var_2_6)

	self._last_good_ground_pos = Vector3Box(0, 0, 0)

	if not tentacle_template.use_ik_chain then
		local unbox = spawn_chaos_tentacle.wall_pos:unbox()
		local var_2_8

		if not self.target_unit then
			var_2_8 = POSITION_LOOKUP[self.target_unit]

			if not var_2_8 then
				-- Nothing
			end
		end

		var_2_8 = spawn_chaos_tentacle.last_target_pos:unbox()

		::label_2_0::

		local tbl = {}
		local num = 0.5
		local num_2 = num * 10

		for i = 1, 10 do
			tbl[i] = Vector3(0, 0, i * num)
		end

		self.ik_tentacle = IkChain:new(tbl, unbox, var_2_8, 0.01)

		self.ik_tentacle:solve(time, 0.03333333333333333)
	end

	local var_2_12
	local var_2_13
	local var_2_14
	local var_2_15
	local node_data = var_2_6.node_data

	if not node_data then
		var_2_12 = node_data.bone_nodes
		var_2_13 = node_data.node_spacing
		var_2_14 = node_data.max_length
		var_2_15 = node_data.spiral_length
	else
		var_2_12, var_2_13, var_2_14 = self:parse_nodes(arg_2_2, "j_tip")
		var_2_15 = self:get_spiral_length(var_2_13)
		var_2_6.node_data = {
			bone_nodes = var_2_12,
			node_spacing = var_2_13,
			max_length = var_2_14,
			spiral_length = var_2_15
		}
	end

	spawn_chaos_tentacle.dists = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
	spawn_chaos_tentacle.node_spacings = var_2_13
	spawn_chaos_tentacle.bone_nodes = var_2_12
	spawn_chaos_tentacle.num_bone_nodes = #var_2_12
	spawn_chaos_tentacle.max_length = var_2_14
	spawn_chaos_tentacle.spiral_length = var_2_15
	spawn_chaos_tentacle.travel_node_dir = Vector3Box()

	if not is_server then
		Unit.set_unit_visibility(arg_2_2, false)

		local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

		AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table, nil, 1)

		local var_2_18 = GwNavTraverseLogic.create(nav_world, create_tag_cost_table)
		local var_2_19 = GwNavTagLayerCostTable.create()

		GwNavTraverseLogic.set_navtag_layer_cost_table(var_2_18, var_2_19)

		spawn_chaos_tentacle.a_star = GwNavAStar.create(nav_world)
		spawn_chaos_tentacle.traverse_logic = var_2_18
		spawn_chaos_tentacle.navtag_layer_cost_table = var_2_19
		spawn_chaos_tentacle.nav_cost_map_cost_table = create_tag_cost_table
	else
		self._server_time_delta = 0
	end
end

TentacleSplineExtension.get_spiral_length = function (arg_3_0, arg_3_1)
	-- function 3
	local count = #arg_3_1
	local num = 0

	for i = count - 21, count do
		num = num + arg_3_1[i]
	end

	return num
end

TentacleSplineExtension.parse_nodes = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local tbl = {}
	local tbl_2 = {}
	local num = 0
	local node = Unit.node(arg_4_1, arg_4_2)

	tbl[1] = node

	local num_2 = 2

	while not node do
		node = Unit.scene_graph_parent(arg_4_1, node)

		if not node then
			tbl[num_2] = node
		end

		num_2 = num_2 + 1
	end

	tbl[#tbl] = nil

	table.reverse(tbl)

	local world_position = Unit.world_position(arg_4_1, 0)
	local var_4_6

	for i = 1, #tbl do
		local world_position_2 = Unit.world_position(arg_4_1, tbl[i])
		local distance = Vector3.distance(world_position, world_position_2)

		tbl_2[i] = distance
		num = num + distance
		world_position = world_position_2
	end

	if not flag then
		print("Num tentacle nodes:", #tbl, "max_length:", num)
		table.dump(tbl_2)
	end

	return tbl, tbl_2, num
end

TentacleSplineExtension.get_ground_pos_at_wall = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local num = arg_5_3 + Quaternion.forward(Unit.local_rotation(arg_5_1, 0)) * 1.5
	local triangle_from_position, var_5_2, var_5_3, var_5_4, var_5_5 = GwNavQueries.triangle_from_position(arg_5_2, num, 0.3, 5)

	if not triangle_from_position then
		return (Vector3(num.x, num.y, var_5_2))
	end
end

TentacleSplineExtension.get_ground_pos_at_floor = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local target_unit = self.target_unit
	local normalize = Vector3.normalize(arg_6_4 - arg_6_3)
	local num = arg_6_3 + Vector3(0, 0, 1.3) + normalize
	local triangle_from_position, var_6_4, var_6_5, var_6_6, var_6_7 = GwNavQueries.triangle_from_position(arg_6_2, num, 1, 5)

	if not triangle_from_position then
		return (Vector3(num.x, num.y, var_6_4))
	end
end

TentacleSplineExtension.spawn_chaos_tentacle = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8)
	-- function 7
	local breed = arg_7_2.breed

	breed = breed or Breeds.chaos_tentacle

	local inside_wall_spawn_distance = breed.inside_wall_spawn_distance

	inside_wall_spawn_distance = inside_wall_spawn_distance or 0

	local var_7_2 = POSITION_LOOKUP[arg_7_1]
	local local_rotation = Unit.local_rotation(arg_7_1, 0)
	local normalize = Vector3.normalize(Quaternion.forward(local_rotation))
	local num = var_7_2 + normalize * inside_wall_spawn_distance

	if not arg_7_4 then
		local portal_unit_name = arg_7_7.portal_unit_name
		local tbl = {
			health_system = {
				health = 255
			},
			death_system = {
				death_reaction_template = "chaos_tentacle_portal",
				is_husk = false
			}
		}

		;({}).side_id = arg_7_8
		arg_7_6 = Managers.state.unit_spawner:spawn_network_unit(portal_unit_name, "ai_unit_tentacle_portal", tbl, num, local_rotation)
	end

	if not Unit.has_node(arg_7_6, "a_surface_center") then
		local node = Unit.node(arg_7_6, "a_surface_center")

		WwiseUtils.trigger_unit_event(self.world, "Play_enemy_sorcerer_portal_activate", arg_7_6, node)
	end

	local flag

	flag = not (Vector3.dot(normalize, Vector3(0, 0, 1)) > 0.707) or not "floor" or "wall"

	local var_7_10

	if flag == "wall" then
		var_7_10 = self:get_ground_pos_at_wall(arg_7_1, arg_7_3, num)
	end

	local var_7_11
	local var_7_12
	local tbl_2 = {
		state = "startup",
		current_length = 0,
		unit = arg_7_1,
		startup_time = arg_7_5 + breed.startup_time,
		root_pos = Vector3Box(var_7_2),
		ground_pos = not var_7_10 and Vector3Box(var_7_10),
		wall_pos = Vector3Box(num),
		spline_points = var_7_11,
		spline = var_7_12,
		last_target_pos = Vector3Box(var_7_2)
	}
	local flag_2

	flag_2 = not self.is_server and "no_path" and "straight"
	tbl_2.path_type = flag_2
	tbl_2.inside_wall_distance = inside_wall_spawn_distance
	tbl_2.portal_unit = arg_7_6
	tbl_2.portal_spawn_type = flag
	tbl_2.tentacle_template = arg_7_7

	return tbl_2, breed
end

TentacleSplineExtension.destroy = function (self)
	-- function 8
	local _unit = self._unit

	if not Unit.alive(_unit) then
		local breed = self.breed
		local node = Unit.node(_unit, breed.sound_head_node)

		WwiseUtils.trigger_unit_event(self.world, "Stop_tentacle_movement", _unit, node)
		self:update_global_movement_sound_intensity(self.unit, self.breed, 1)
	end

	self.portal_unit = nil

	if not self.is_server then
		local tentacle_data = self.tentacle_data

		GwNavTagLayerCostTable.destroy(tentacle_data.navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(tentacle_data.nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(tentacle_data.traverse_logic)

		local astar = tentacle_data.astar

		if not astar then
			GwNavAStar.destroy(astar)
		end
	end
end

TentacleSplineExtension.reset = function (arg_9_0)
	-- function 9
	return
end

local tbl = {
	attack = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		local var_10_0 = arg_10_2

		arg_10_2 = arg_10_2 + 1

		local num = 0.7
		local num_2 = 0.55
		local num_3 = 0.35
		local num_4 = 0.55
		local flag = true

		if not flag then
			local node = Unit.node(arg_10_0, "j_head")
			local world_position = Unit.world_position(arg_10_0, node)
			local node_2 = Unit.node(arg_10_0, "j_hips")
			local world_position_2 = Unit.world_position(arg_10_0, node_2)
			local world_rotation = Unit.world_rotation(arg_10_0, node_2)
			local num_5 = world_position - world_position_2
			local forward = Quaternion.forward(world_rotation)
			local cross = Vector3.cross(forward, num_5)
			local cross_2 = Vector3.cross(cross, num_5)
			local var_10_15 = world_position_2

			arg_10_1[arg_10_2] = var_10_15 + cross * num_2 - num_5 * 0.2
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + cross_2 * num_3 - num_5 * 0.1
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - cross * num_2 - num_5 * 0
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - cross_2 * num_3 + num_5 * 0.1
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + cross * num_2 + num_5 * 0.2
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + cross_2 * num_3 + num_5 * 0.3
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - cross * num_2 + num_5 * 0.4
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - cross_2 * num_4 + num_5 * 0.5
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + cross * num_2 + num_5 * 0.6
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + cross_2 * num_3 + num_5 * 0.7
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - cross * num_2 + num_5 * 0.8
		else
			local var_10_16 = POSITION_LOOKUP[arg_10_0]

			arg_10_1[arg_10_2] = var_10_16 + side * num_2 + Vector3(0, 0, num - 0.3)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + to_player_dir * num_3 + Vector3(0, 0, num - 0.2)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - side * num_2 + Vector3(0, 0, num - 0.1)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - to_player_dir * num_3 + Vector3(0, 0, num + 0)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + side * num_2 + Vector3(0, 0, num + 0.1)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + to_player_dir * num_3 + Vector3(0, 0, num + 0.2)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - side * num_2 + Vector3(0, 0, num + 0.3)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - to_player_dir * num_3 + Vector3(0, 0, num + 0.4)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + side * num_2 + Vector3(0, 0, num + 0.5)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + to_player_dir * num_3 + Vector3(0, 0, num + 0.6)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - side * num_2 + Vector3(0, 0, num + 0.7)
		end

		return var_10_0
	end,
	evaded = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		local var_11_0 = arg_11_2

		arg_11_2 = arg_11_2 + 1

		local num = 0.7
		local num_2 = 0.55
		local num_3 = 0.35
		local num_4 = 0.55
		local node = Unit.node(arg_11_0, "j_head")
		local world_position = Unit.world_position(arg_11_0, node)
		local node_2 = Unit.node(arg_11_0, "j_hips")
		local world_position_2 = Unit.world_position(arg_11_0, node_2)
		local world_rotation = Unit.world_rotation(arg_11_0, node_2)
		local num_5 = world_position - world_position_2
		local forward = Quaternion.forward(world_rotation)
		local cross = Vector3.cross(forward, num_5)
		local cross_2 = Vector3.cross(cross, num_5)
		local var_11_14 = world_position_2

		arg_11_1[arg_11_2] = var_11_14 + cross * num_2 - num_5 * 0.2
		arg_11_2 = arg_11_2 + 1
		arg_11_1[arg_11_2] = var_11_14 - cross_2 * 1.5 - num_5 * 0.1
		arg_11_2 = arg_11_2 + 1
		arg_11_1[arg_11_2] = var_11_14 - cross_2 * 5 - num_5 * 0.5

		return var_11_0
	end
}

TentacleSplineExtension.set_target = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	self.target_unit = arg_12_2
	self.active_template_name = arg_12_1
	self.tentacle_data.active_template_name = arg_12_1
	self.reach_dist = math.clamp(arg_12_3, 0, 31)
end

TentacleSplineExtension.set_reach_dist = function (self, arg_13_1)
	-- function 13
	self.reach_dist = math.clamp(arg_13_1, 0, 31)
end

TentacleSplineExtension.set_target_unit = function (self, arg_14_1)
	-- function 14
	self.target_unit = arg_14_1
end

TentacleSplineExtension.set_server_time = function (self, arg_15_1)
	-- function 15
	self._server_time_delta = arg_15_1 - Managers.time:time("main")
end

TentacleSplineExtension.set_astar_points = function (self, arg_16_1)
	-- function 16
	local tentacle_data = self.tentacle_data
	local count = #arg_16_1

	if count > 0 then
		local unbox = tentacle_data.root_pos:unbox()
		local unbox_2 = tentacle_data.ground_pos:unbox()
		local local_position = Unit.local_position(self.portal_unit, 0)
		local var_16_5 = Vector3(unbox_2.x, unbox_2.y, unbox.z)

		table.insert(arg_16_1, 1, unbox)
		table.insert(arg_16_1, 2, local_position)
		table.insert(arg_16_1, 3, var_16_5)

		local num = count + 3

		tentacle_data.travel_node_dir:store(Vector3.normalize(arg_16_1[num - 1] - arg_16_1[num]))
		LevelAnalysis.boxify_pos_array(arg_16_1)

		tentacle_data.astar_node_list = arg_16_1
		tentacle_data.path_type = "follow_astar"
		tentacle_data.travel_to_node_index = num - 1
	else
		tentacle_data.path_type = "straight"
	end

	tentacle_data.reset = true
	tentacle_data.astar_node_list = arg_16_1
end

TentacleSplineExtension.update_global_movement_sound_intensity = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local previous_reach_dist = self.previous_reach_dist

	previous_reach_dist = previous_reach_dist or 0

	local reach_dist = self.reach_dist

	reach_dist = reach_dist or previous_reach_dist

	local movement_sound_scaling = arg_17_2.movement_sound_scaling
	local movement_sound_max_intensity = arg_17_2.movement_sound_max_intensity
	local min = math.min(math.abs(previous_reach_dist - reach_dist) / arg_17_3 * movement_sound_scaling, movement_sound_max_intensity)
	local movement_sound_parameter = arg_17_2.movement_sound_parameter

	Managers.state.entity:system("audio_system"):set_global_parameter_with_lerp(movement_sound_parameter, min)
end

TentacleSplineExtension.update = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	if not Unit.alive(self.target_unit) then
		return
	end

	local breed = self.breed
	local tentacle_data = self.tentacle_data

	if not (tentacle_data.state ~= "startup" or not (arg_18_5 > tentacle_data.startup_time)) then
		tentacle_data.state = "recalc_path"

		local node = Unit.node(arg_18_1, breed.sound_head_node)
		local node_2 = Unit.node(arg_18_1, breed.sound_body_node)

		WwiseUtils.trigger_unit_event(self.world, "Play_tentacle_movement_head", arg_18_1, node)
		WwiseUtils.trigger_unit_event(self.world, "Play_tentacle_movement_body", arg_18_1, node_2)
		WwiseUtils.trigger_unit_event(self.world, "Play_enemy_sorcerer_tentacle_foley_grab_swing", arg_18_1, node)
	end

	if not self.is_server then
		local target_unit = self.target_unit
		local var_18_5

		if not self.target_unit then
			var_18_5 = POSITION_LOOKUP[self.target_unit]

			if not var_18_5 then
				-- Nothing
			end
		end

		var_18_5 = tentacle_data.last_target_pos:unbox()

		::label_18_0::

		local unbox = tentacle_data.root_pos:unbox()
		local blackboard = self.blackboard

		if tentacle_data.state == "spline_update" then
			Unit.set_unit_visibility(arg_18_1, true)
			self:align_tentacle(self.active_template_name, tentacle_data, var_18_5, self.reach_dist, arg_18_5, arg_18_3)

			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(self._unit)

			GameSession.set_game_object_field(game, go_id, "reach_distance", self.reach_dist)
			tentacle_data.last_target_pos:store(var_18_5)
		elseif tentacle_data.state == "calculate_path" then
			self:calculate_tentacle_path(arg_18_1, tentacle_data, unbox, var_18_5)
		elseif tentacle_data.state == "recalc_path" then
			local nav_world = blackboard.nav_world

			if not (tentacle_data.ground_pos or tentacle_data.portal_spawn_type ~= "floor") then
				local unbox_2 = tentacle_data.wall_pos:unbox()
				local get_ground_pos_at_floor = self:get_ground_pos_at_floor(arg_18_1, nav_world, unbox_2, var_18_5)

				if not get_ground_pos_at_floor then
					tentacle_data.ground_pos = Vector3Box(get_ground_pos_at_floor)
				end
			end

			local triangle_from_position, var_18_14 = GwNavQueries.triangle_from_position(nav_world, var_18_5, 1, 1)

			if not triangle_from_position then
				local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, var_18_5, 1, 4, 4, 1)

				if not inside_position_from_outside_position then
					print("Target was outside mesh, found a close position, near it")

					var_18_5 = inside_position_from_outside_position
				end
			end

			if not tentacle_data.ground_pos then
				tentacle_data.last_target_pos:store(var_18_5)

				local a_star = tentacle_data.a_star
				local unbox_3 = tentacle_data.ground_pos:unbox()

				GwNavAStar.start(a_star, nav_world, tentacle_data.ground_pos:unbox(), var_18_5, tentacle_data.traverse_logic)

				tentacle_data.state = "calculate_path"
			else
				print("fallback w/o a-star")

				self.tentacle_data.state = "spline_update"
				self.tentacle_data.path_type = "straight"
			end
		elseif not (tentacle_data.state ~= "no_path_found" or not (Vector3.distance_squared(var_18_5, tentacle_data.last_target_pos:unbox()) > 1)) then
			tentacle_data.state = "recalc_path"
		end
	else
		if not self.tentacle_data.reset then
			self.tentacle_data.reset = nil
		end

		local num = arg_18_5 + self._server_time_delta
		local var_18_19

		if not self.target_unit then
			var_18_19 = POSITION_LOOKUP[self.target_unit]

			if not var_18_19 then
				-- Nothing
			end
		end

		var_18_19 = tentacle_data.last_target_pos:unbox()

		::label_18_1::

		local game_2 = Managers.state.network:game()
		local go_id_2 = Managers.state.unit_storage:go_id(arg_18_1)
		local game_object_field = GameSession.game_object_field(game_2, go_id_2, "reach_distance")

		self.reach_dist = game_object_field

		self:align_tentacle(self.active_template_name, self.tentacle_data, var_18_19, game_object_field, num, arg_18_3)
		tentacle_data.last_target_pos:store(var_18_19)
	end

	self:update_global_movement_sound_intensity(arg_18_1, breed, arg_18_3)

	self.previous_reach_dist = self.reach_dist
end

TentacleSplineExtension.get_last_ground_pos = function (self)
	-- function 19
	return self._last_good_ground_pos:unbox()
end

local function fn(self, arg_20_1)
	-- function 20
	local flag = arg_20_1 or QuickDrawer

	for i = 1, #self do
		flag:sphere(self[i]:unbox(), 0.4, Color(0, 255, 124))
	end
end

local num = 0.6

TentacleSplineExtension.calculate_tentacle_path = function (self, arg_21_1, arg_21_2)
	-- function 21
	local a_star = arg_21_2.a_star

	if not GwNavAStar.processing_finished(a_star) then
		if not GwNavAStar.path_found(a_star) then
			local node_count = GwNavAStar.node_count(a_star)

			print("Tentacle Found path! node-count:", node_count)

			local path_cost = GwNavAStar.path_cost(a_star)
			local path_distance = GwNavAStar.path_distance(a_star)

			arg_21_2.state = "spline_update"

			if node_count == 2 then
				arg_21_2.path_type = "straight"
			else
				arg_21_2.path_type = "follow_astar"

				local var_21_4 = Vector3(0, 0, 1.3)
				local tbl = {}

				for i = 2, node_count do
					tbl[i - 1] = GwNavAStar.node_at_index(a_star, i) + var_21_4
				end

				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(arg_21_1)

				if not flag then
					table.dump(tbl, "node-list:")
				end

				network.network_transmit:send_rpc_clients("rpc_sync_tentacle_path", unit_game_object_id, tbl)

				local unbox = arg_21_2.root_pos:unbox()
				local unbox_2 = arg_21_2.ground_pos:unbox()
				local local_position = Unit.local_position(self.portal_unit, 0)
				local var_21_11 = Vector3(unbox_2.x, unbox_2.y, unbox.z)

				table.insert(tbl, 1, unbox)
				table.insert(tbl, 2, local_position)
				table.insert(tbl, 3, var_21_11)

				local num = node_count + 2
				local var_21_13 = tbl[num]
				local normalize = Vector3.normalize(tbl[num - 1] - var_21_13)

				arg_21_2.travel_node_dir:store(normalize)

				arg_21_2.travel_to_node_index = num - 1

				LevelAnalysis.boxify_pos_array(tbl)

				arg_21_2.astar_node_list = tbl
			end

			arg_21_2.use_old_path = false
		elseif arg_21_2.path_type ~= "no_path" then
			print("Tentacle failed no path found")

			arg_21_2.state = "no_path_found"
		else
			print("Tentacle failed no path found - using old path")

			arg_21_2.state = "spline_update"
			arg_21_2.use_old_path = true
		end
	end
end

local tbl_2 = {
	first_part = {
		2,
		3
	},
	attack_test = {
		3,
		4,
		5,
		6,
		7
	},
	attack_a = {
		2,
		3,
		4,
		5
	}
}

TentacleSplineExtension.keep_tentacle_above_ground = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	for i = arg_22_3, #arg_22_4 do
		local var_22_0 = arg_22_4[i]
		local var_22_1 = arg_22_2[var_22_0]
		local triangle_from_position, var_22_3 = GwNavQueries.triangle_from_position(arg_22_1, var_22_1, 4, 1)

		if not (not triangle_from_position and not (var_22_3 > var_22_1.z)) then
			local num = var_22_1.z - var_22_3

			arg_22_2[var_22_0] = Vector3(var_22_1.x, var_22_1.y, var_22_3 - num)
		end
	end
end

TentacleSplineExtension.funnel_tentacle_to_center = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	-- function 23
	local num = 4

	Debug.text("influence dist: %.2f", num)

	for i = arg_23_2, arg_23_3 do
		local var_23_1 = arg_23_1[i]
		local closest_point_on_line = Geometry.closest_point_on_line(var_23_1, arg_23_5, arg_23_4 + arg_23_6 * num)
		local length = Vector3.length(closest_point_on_line - arg_23_5)
		local num_2 = length - arg_23_7
		local clamp = math.clamp(num_2, 0, length, num)
		local num_3 = 1 - math.clamp(clamp / num, 0, 1)

		Debug.text("D %d %.2f total dist: %.2f rdist: %.2f", i, num_3, Vector3.length(closest_point_on_line - arg_23_5) - arg_23_7, arg_23_7)

		local num_4 = var_23_1 - closest_point_on_line
		local num_5 = 1

		if not arg_23_8 then
			local length_2 = Vector3.length(num_4)
			local num_6 = 1 - math.clamp(length_2 / arg_23_8, 0, 1)

			closest_point_on_line = var_23_1 - num_4 * (num_3 + num_6 * num_6) * 0.5
		else
			closest_point_on_line = var_23_1 - num_4 * num_3
		end

		arg_23_1[i] = closest_point_on_line
	end
end

TentacleSplineExtension.funnel_one_point = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	local num = 4
	local closest_point_on_line = Geometry.closest_point_on_line(arg_24_1, arg_24_3, arg_24_2 + arg_24_4 * num)
	local length = Vector3.length(closest_point_on_line - arg_24_3)
	local clamp = math.clamp(length - arg_24_5, 0, length)
	local num_2 = 1 - math.clamp(clamp / num, 0, 1)
	local num_3 = arg_24_1 - closest_point_on_line
	local num_4 = 1

	if not arg_24_6 then
		local length_2 = Vector3.length(num_3)

		num_4 = 1 - math.clamp(length_2 / arg_24_6, 0, 1)
		num_4 = num_4 * num_4
	end

	return arg_24_1 - num_3 * (num_2 + num_4) * 0.5, Vector3.length(num_3)
end

local function fn_2(self, arg_25_1)
	-- function 25
	local num = 0

	for i = #self - 1, 1, -1 do
		local unbox = self[i + 1]:unbox()
		local num_2 = self[i]:unbox() - unbox
		local length = Vector3.length(num_2)

		num = num + length

		if arg_25_1 < num then
			return unbox + num_2 * ((length - (num - arg_25_1)) / length), i
		end
	end

	return path_list[1]:unbox(), 1
end

TentacleSplineExtension.align_tentacle = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	-- function 26
	local spline = arg_26_2.spline
	local forward = Quaternion.forward(Unit.local_rotation(arg_26_2.portal_unit, 0))
	local unbox = arg_26_2.root_pos:unbox()
	local unbox_2 = arg_26_2.wall_pos:unbox()
	local num_2 = arg_26_3 - unbox
	local normalize = Vector3.normalize(num_2)
	local length = Vector3.length(num_2)
	local portal_spawn_type = arg_26_2.portal_spawn_type
	local cross = Vector3.cross(normalize, Vector3.up())
	local tbl_3 = {}
	local var_26_10
	local num_3 = 0

	if arg_26_2.path_type == "straight" then
		local first_part = tbl_2.first_part

		if not self.ik_tentacle then
			self.ik_tentacle:set_target_pos(arg_26_3 + Vector3(0, 0, 1), 2)
			self.ik_tentacle:solve(arg_26_5, arg_26_6)

			local joints = self.ik_tentacle.joints

			for i = 1, #joints do
				tbl_3[i] = joints[i]:unbox()
			end

			num_3 = #tbl_3
		elseif length < 30 then
			first_part = tbl_2.attack_a

			local num_4 = 1.5
			local num_5 = arg_26_5 * 1.5

			if portal_spawn_type == "wall" then
				local var_26_16 = length
				local num_6 = unbox + Vector3(0, 0, 0.5)

				tbl_3[1] = unbox
				tbl_3[2] = num_6 + normalize * var_26_16 * 0.1
				tbl_3[3] = num_6 + normalize * var_26_16 * 0.2
				tbl_3[4] = num_6 + normalize * var_26_16 * 0.3
				tbl_3[5] = num_6 + normalize * var_26_16 * 0.4
				tbl_3[6] = num_6 + normalize * var_26_16 * 0.5
				tbl_3[7] = num_6 + normalize * var_26_16 * 0.6
				tbl_3[8] = num_6 + normalize * var_26_16 * 0.7
				tbl_3[9] = num_6 + normalize * var_26_16 * 0.8
				tbl_3[10] = num_6 + normalize * var_26_16 * 0.9
				tbl_3[11] = num_6 + normalize * var_26_16 * 1

				for j = 1, #tbl_3 do
					QuickDrawer:sphere(tbl_3[j], 0.26, Color(0, 255, 0))
				end
			else
				local length_2 = Vector3.length

				local function fn(self, arg_27_1, arg_27_2)
					-- function 27
					local var_27_0 = length_2(self)
					local clamp = math.clamp(var_27_0 / 4, 0, 1)

					return Vector3(self.x, self.y, clamp * arg_27_1 + (clamp - 1) * arg_27_2)
				end

				local var_26_20 = Vector3(0, 0, 1)
				local tbl_4 = {
					normalize * length * 0.1,
					normalize * length * 0.25 + cross * 0.25 * math.sin((num_5 + 0) * num_4) + Vector3(0, 0, 0.5 + math.sin((num_5 + 0) * 0.5)) * 0.25,
					normalize * length * 0.5 + cross * 0.5 * math.sin((num_5 + 0.6) * num_4) + Vector3(0, 0, 0.5 + math.sin((num_5 + 0.1) * 0.5)) * 0.5,
					normalize * length * 0.75 + cross * math.sin((num_5 + 0.9) * num_4 * 0.5) + Vector3(0, 0, 0.5 + math.sin((num_5 + 0.2) * 0.5))
				}

				tbl_3[1] = unbox

				local num_7 = unbox_2 - unbox

				for k = 1, 4 do
					tbl_3[k + 1] = unbox + fn(tbl_4[k], num_7.z + 1, 0) + var_26_20
				end
			end

			num_3 = 5
			num_3 = #tbl_3
		else
			tbl_3[1] = unbox
			tbl_3[2] = unbox + forward * 3
			tbl_3[3] = unbox + normalize * (6 + 1 * math.sin(arg_26_5 * 2)) + Vector3.cross(normalize, Vector3.up()) * 2.5 * math.sin(arg_26_5 * 1.5)
			tbl_3[4] = unbox + normalize * 8.5 - Vector3.cross(normalize, Vector3.up()) * 0.5 * (0.7 + 0.3 * math.cos(arg_26_5 * 3))
			num_3 = 4
		end

		local var_26_23
		local var_26_24

		if portal_spawn_type == "floor" then
			local var_26_25 = num_3
			local num_8 = 4

			self:funnel_tentacle_to_center(tbl_3, 2, var_26_25, unbox_2, unbox, forward, num_8, 3)
		else
			local var_26_27 = num_3
			local num_9 = 2.5

			self:keep_tentacle_above_ground(self.nav_world, tbl_3, 4, first_part)
			self:funnel_tentacle_to_center(tbl_3, 2, var_26_27, unbox_2, unbox, forward, num_9)
		end

		if arg_26_1 == "attack" then
			var_26_10 = tbl.attack(self.target_unit, tbl_3, num_3)
		elseif arg_26_1 == "launch_out" then
			num_3 = num_3 + 1
			tbl_3[num_3] = arg_26_3 + cross * 0.55 + Vector3(0, 0, 2)
		elseif arg_26_1 == "evaded" then
			var_26_10 = tbl.evaded(self.target_unit, tbl_3, num_3)
		end

		Debug.reset_sticky_world_texts()
	elseif arg_26_2.path_type == "follow_astar" then
		local astar_node_list = arg_26_2.astar_node_list
		local travel_to_node_index = arg_26_2.travel_to_node_index
		local num_10 = arg_26_3 + Vector3(0, 0, 1.3)

		astar_node_list[travel_to_node_index + 1]:store(num_10)

		local num_11 = astar_node_list[travel_to_node_index]:unbox() - num_10
		local normalize_2 = Vector3.normalize(num_11)
		local unbox_3 = arg_26_2.travel_node_dir:unbox()
		local var_26_35
		local var_26_36
		local var_26_37
		local var_26_38, var_26_39 = fn_2(astar_node_list, num)

		if var_26_39 < travel_to_node_index then
			var_26_37 = var_26_39
		end

		local var_26_40 = var_26_38

		arg_26_2.look_dir = Vector3Box(Vector3.normalize(var_26_40 - num_10))

		local num_12

		if not flag_4 then
			num_12 = var_26_40 - arg_26_2.look_dir:unbox() * 0.2

			if not num_12 then
				-- Nothing
			end
		end

		num_12 = nil

		::label_26_0::

		if not (not (Vector3.dot(num_11, unbox_3) < 0) or not (travel_to_node_index > 1)) then
			arg_26_2.travel_node_dir:store(Vector3.normalize(astar_node_list[travel_to_node_index - 1]:unbox() - astar_node_list[travel_to_node_index]:unbox()))

			arg_26_2.travel_to_node_index = travel_to_node_index - 1
			astar_node_list[travel_to_node_index] = astar_node_list[travel_to_node_index + 1]
			astar_node_list[travel_to_node_index + 1] = nil
		end

		tbl_3 = {}

		local num_13 = #astar_node_list - 1
		local num_14 = 2 * math.pi / num_13

		for l = 1, num_13 do
			tbl_3[l] = astar_node_list[l]:unbox()
		end

		local num_15 = num_13 + 1

		if not var_26_37 then
			tbl_3[var_26_37 + 1] = var_26_40

			for i4 = var_26_37 + 2, #tbl_3 do
				tbl_3[i4] = nil
			end

			num_15 = var_26_37 + 1
		else
			tbl_3[num_15] = var_26_40
		end

		if not flag_4 then
			num_15 = num_15 + 1
			tbl_3[num_15] = num_12
		end

		if arg_26_1 == "attack" then
			var_26_10 = tbl.attack(self.target_unit, tbl_3, num_15)
		end
	end

	local var_26_45 = SplineCurve:new(tbl_3, "Hermite", "SplineMovementHermiteInterpolatedMetered", "Tentacle", 3)

	self.spline = var_26_45
	arg_26_2.spline = var_26_45

	local var_26_46

	if not var_26_10 then
		var_26_46 = var_26_45:get_travel_dist_to_spline_point(var_26_10) + 2
		self.lock_point_dist = var_26_46

		local get_point_at_distance, var_26_48, var_26_49 = var_26_45:get_point_at_distance(var_26_46)
		local num_16 = get_point_at_distance + Vector3(0, 0, 0.66)

		QuickDrawer:line(get_point_at_distance, num_16, Color(255, 128, 0))
		QuickDrawer:sphere(get_point_at_distance, 0.25, Color(200, 128, 0))
	end

	local unit = arg_26_2.unit
	local unbox_4 = arg_26_2.root_pos:unbox()
	local bone_nodes = arg_26_2.bone_nodes
	local num_bone_nodes = arg_26_2.num_bone_nodes
	local num_17 = 1
	local var_26_56 = unbox_4
	local local_rotation = Unit.local_rotation(unit, 0)
	local from_quaternion_position = Matrix4x4.from_quaternion_position(local_rotation, unbox_4)
	local node_spacings = arg_26_2.node_spacings
	local count = #node_spacings
	local var_26_61 = arg_26_4
	local dists = arg_26_2.dists

	for i5 = count, 1, -1 do
		dists[i5] = var_26_61
		var_26_61 = var_26_61 - node_spacings[i5]

		if var_26_61 < 0 then
			var_26_61 = 0
		end
	end

	local num_18 = 20 * math.pi / count

	for i6 = 1, count do
		local var_26_64 = bone_nodes[i6]
		local get_point_at_distance_2, var_26_66, var_26_67 = var_26_45:get_point_at_distance(dists[i6])

		if not (not var_26_10 and not (dists[i6] < var_26_46 - 2)) then
			local num_19 = math.sin(arg_26_5 * 6 + num_18 * i6) * 0.065

			get_point_at_distance_2 = get_point_at_distance_2 + Vector3(num_19, num_19, num_19)
		end

		local look = Quaternion.look(var_26_66, Vector3.up())
		local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(look, get_point_at_distance_2)
		local multiply = Matrix4x4.multiply(from_quaternion_position_2, Matrix4x4.inverse(from_quaternion_position))

		Unit.set_local_pose(unit, var_26_64, multiply)

		local var_26_72 = get_point_at_distance_2

		from_quaternion_position = from_quaternion_position_2
	end
end
