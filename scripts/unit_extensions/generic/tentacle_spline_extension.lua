-- chunkname: @scripts/unit_extensions/generic/tentacle_spline_extension.lua

require("foundation/scripts/util/spline_curve")

TentacleSplineExtension = class(TentacleSplineExtension)

local var_0_0 = false
local var_0_1 = false
local var_0_2 = false
local var_0_3 = false

TentacleSplineExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.is_server, arg_1_0._unit = Managers.player.is_server, arg_1_2
	arg_1_0.world = arg_1_1.world

	local var_1_0 = arg_1_3.tentacle_template_name

	arg_1_0.tentacle_template, arg_1_0.tentacle_template_name = TentacleTemplates[var_1_0], var_1_0
	arg_1_0.portal_unit = arg_1_3.portal_unit
	arg_1_0.side_id = arg_1_3.side_id
end

TentacleSplineExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = BLACKBOARDS[arg_2_2] or {}

	arg_2_0.blackboard = var_2_0

	local var_2_1 = Managers.state.entity:system("ai_system"):nav_world()

	arg_2_0.nav_world = var_2_1

	local var_2_2 = arg_2_0.tentacle_template
	local var_2_3 = arg_2_0.is_server
	local var_2_4 = Managers.time:time("game")
	local var_2_5, var_2_6 = arg_2_0:spawn_chaos_tentacle(arg_2_2, var_2_0, var_2_1, var_2_3, var_2_4, arg_2_0.portal_unit, var_2_2, arg_2_0.side_id)

	arg_2_0.tentacle_data = var_2_5
	var_2_0.tentacle_data = var_2_5
	arg_2_0.portal_unit = var_2_5.portal_unit
	arg_2_0.breed = var_2_6

	print("TENTACLE BREED", var_2_6)

	arg_2_0._last_good_ground_pos = Vector3Box(0, 0, 0)

	if var_2_2.use_ik_chain then
		local var_2_7 = var_2_5.wall_pos:unbox()
		local var_2_8 = arg_2_0.target_unit and POSITION_LOOKUP[arg_2_0.target_unit] or var_2_5.last_target_pos:unbox()
		local var_2_9 = {}
		local var_2_10 = 0.5
		local var_2_11 = var_2_10 * 10

		for iter_2_0 = 1, 10 do
			var_2_9[iter_2_0] = Vector3(0, 0, iter_2_0 * var_2_10)
		end

		arg_2_0.ik_tentacle = IkChain:new(var_2_9, var_2_7, var_2_8, 0.01)

		arg_2_0.ik_tentacle:solve(var_2_4, 0.03333333333333333)
	end

	local var_2_12
	local var_2_13
	local var_2_14
	local var_2_15
	local var_2_16 = var_2_6.node_data

	if var_2_16 then
		var_2_12 = var_2_16.bone_nodes
		var_2_13 = var_2_16.node_spacing
		var_2_14 = var_2_16.max_length
		var_2_15 = var_2_16.spiral_length
	else
		var_2_12, var_2_13, var_2_14 = arg_2_0:parse_nodes(arg_2_2, "j_tip")
		var_2_15 = arg_2_0:get_spiral_length(var_2_13)
		var_2_6.node_data = {
			bone_nodes = var_2_12,
			node_spacing = var_2_13,
			max_length = var_2_14,
			spiral_length = var_2_15
		}
	end

	var_2_5.dists = {
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
	var_2_5.node_spacings = var_2_13
	var_2_5.bone_nodes = var_2_12
	var_2_5.num_bone_nodes = #var_2_12
	var_2_5.max_length = var_2_14
	var_2_5.spiral_length = var_2_15
	var_2_5.travel_node_dir = Vector3Box()

	if var_2_3 then
		Unit.set_unit_visibility(arg_2_2, false)

		local var_2_17 = GwNavCostMap.create_tag_cost_table()

		AiUtils.initialize_nav_cost_map_cost_table(var_2_17, nil, 1)

		local var_2_18 = GwNavTraverseLogic.create(var_2_1, var_2_17)
		local var_2_19 = GwNavTagLayerCostTable.create()

		GwNavTraverseLogic.set_navtag_layer_cost_table(var_2_18, var_2_19)

		var_2_5.a_star = GwNavAStar.create(var_2_1)
		var_2_5.traverse_logic = var_2_18
		var_2_5.navtag_layer_cost_table = var_2_19
		var_2_5.nav_cost_map_cost_table = var_2_17
	else
		arg_2_0._server_time_delta = 0
	end
end

TentacleSplineExtension.get_spiral_length = function (arg_3_0, arg_3_1)
	local var_3_0 = #arg_3_1
	local var_3_1 = 0

	for iter_3_0 = var_3_0 - 21, var_3_0 do
		var_3_1 = var_3_1 + arg_3_1[iter_3_0]
	end

	return var_3_1
end

TentacleSplineExtension.parse_nodes = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {}
	local var_4_1 = {}
	local var_4_2 = 0
	local var_4_3 = Unit.node(arg_4_1, arg_4_2)

	var_4_0[1] = var_4_3

	local var_4_4 = 2

	while var_4_3 do
		var_4_3 = Unit.scene_graph_parent(arg_4_1, var_4_3)

		if var_4_3 then
			var_4_0[var_4_4] = var_4_3
		end

		var_4_4 = var_4_4 + 1
	end

	var_4_0[#var_4_0] = nil

	table.reverse(var_4_0)

	local var_4_5 = Unit.world_position(arg_4_1, 0)
	local var_4_6

	for iter_4_0 = 1, #var_4_0 do
		local var_4_7 = Unit.world_position(arg_4_1, var_4_0[iter_4_0])
		local var_4_8 = Vector3.distance(var_4_5, var_4_7)

		var_4_1[iter_4_0] = var_4_8
		var_4_2 = var_4_2 + var_4_8
		var_4_5 = var_4_7
	end

	if var_0_0 then
		print("Num tentacle nodes:", #var_4_0, "max_length:", var_4_2)
		table.dump(var_4_1)
	end

	return var_4_0, var_4_1, var_4_2
end

TentacleSplineExtension.get_ground_pos_at_wall = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_3 + Quaternion.forward(Unit.local_rotation(arg_5_1, 0)) * 1.5
	local var_5_1, var_5_2, var_5_3, var_5_4, var_5_5 = GwNavQueries.triangle_from_position(arg_5_2, var_5_0, 0.3, 5)

	if var_5_1 then
		return (Vector3(var_5_0.x, var_5_0.y, var_5_2))
	end
end

TentacleSplineExtension.get_ground_pos_at_floor = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_0.target_unit
	local var_6_1 = Vector3.normalize(arg_6_4 - arg_6_3)
	local var_6_2 = arg_6_3 + Vector3(0, 0, 1.3) + var_6_1
	local var_6_3, var_6_4, var_6_5, var_6_6, var_6_7 = GwNavQueries.triangle_from_position(arg_6_2, var_6_2, 1, 5)

	if var_6_3 then
		return (Vector3(var_6_2.x, var_6_2.y, var_6_4))
	end
end

TentacleSplineExtension.spawn_chaos_tentacle = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8)
	local var_7_0 = arg_7_2.breed or Breeds.chaos_tentacle
	local var_7_1 = var_7_0.inside_wall_spawn_distance or 0
	local var_7_2 = POSITION_LOOKUP[arg_7_1]
	local var_7_3 = Unit.local_rotation(arg_7_1, 0)
	local var_7_4 = Vector3.normalize(Quaternion.forward(var_7_3))
	local var_7_5 = var_7_2 + var_7_4 * var_7_1

	if arg_7_4 then
		local var_7_6 = arg_7_7.portal_unit_name
		local var_7_7 = {
			health_system = {
				health = 255
			},
			death_system = {
				death_reaction_template = "chaos_tentacle_portal",
				is_husk = false
			}
		}

		;({}).side_id = arg_7_8
		arg_7_6 = Managers.state.unit_spawner:spawn_network_unit(var_7_6, "ai_unit_tentacle_portal", var_7_7, var_7_5, var_7_3)
	end

	if Unit.has_node(arg_7_6, "a_surface_center") then
		local var_7_8 = Unit.node(arg_7_6, "a_surface_center")

		WwiseUtils.trigger_unit_event(arg_7_0.world, "Play_enemy_sorcerer_portal_activate", arg_7_6, var_7_8)
	end

	local var_7_9 = Vector3.dot(var_7_4, Vector3(0, 0, 1)) > 0.707 and "floor" or "wall"
	local var_7_10

	if var_7_9 == "wall" then
		var_7_10 = arg_7_0:get_ground_pos_at_wall(arg_7_1, arg_7_3, var_7_5)
	end

	local var_7_11
	local var_7_12

	return {
		state = "startup",
		current_length = 0,
		unit = arg_7_1,
		startup_time = arg_7_5 + var_7_0.startup_time,
		root_pos = Vector3Box(var_7_2),
		ground_pos = var_7_10 and Vector3Box(var_7_10),
		wall_pos = Vector3Box(var_7_5),
		spline_points = var_7_11,
		spline = var_7_12,
		last_target_pos = Vector3Box(var_7_2),
		path_type = arg_7_0.is_server and "no_path" or "straight",
		inside_wall_distance = var_7_1,
		portal_unit = arg_7_6,
		portal_spawn_type = var_7_9,
		tentacle_template = arg_7_7
	}, var_7_0
end

TentacleSplineExtension.destroy = function (arg_8_0)
	local var_8_0 = arg_8_0._unit

	if Unit.alive(var_8_0) then
		local var_8_1 = arg_8_0.breed
		local var_8_2 = Unit.node(var_8_0, var_8_1.sound_head_node)

		WwiseUtils.trigger_unit_event(arg_8_0.world, "Stop_tentacle_movement", var_8_0, var_8_2)
		arg_8_0:update_global_movement_sound_intensity(arg_8_0.unit, arg_8_0.breed, 1)
	end

	arg_8_0.portal_unit = nil

	if arg_8_0.is_server then
		local var_8_3 = arg_8_0.tentacle_data

		GwNavTagLayerCostTable.destroy(var_8_3.navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(var_8_3.nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(var_8_3.traverse_logic)

		local var_8_4 = var_8_3.astar

		if var_8_4 then
			GwNavAStar.destroy(var_8_4)
		end
	end
end

TentacleSplineExtension.reset = function (arg_9_0)
	return
end

local var_0_4 = {
	attack = function (arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = arg_10_2

		arg_10_2 = arg_10_2 + 1

		local var_10_1 = 0.7
		local var_10_2 = 0.55
		local var_10_3 = 0.35
		local var_10_4 = 0.55
		local var_10_5 = true

		if var_10_5 then
			local var_10_6 = Unit.node(arg_10_0, "j_head")
			local var_10_7 = Unit.world_position(arg_10_0, var_10_6)
			local var_10_8 = Unit.node(arg_10_0, "j_hips")
			local var_10_9 = Unit.world_position(arg_10_0, var_10_8)
			local var_10_10 = Unit.world_rotation(arg_10_0, var_10_8)
			local var_10_11 = var_10_7 - var_10_9
			local var_10_12 = Quaternion.forward(var_10_10)
			local var_10_13 = Vector3.cross(var_10_12, var_10_11)
			local var_10_14 = Vector3.cross(var_10_13, var_10_11)
			local var_10_15 = var_10_9

			arg_10_1[arg_10_2] = var_10_15 + var_10_13 * var_10_2 - var_10_11 * 0.2
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + var_10_14 * var_10_3 - var_10_11 * 0.1
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - var_10_13 * var_10_2 - var_10_11 * 0
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - var_10_14 * var_10_3 + var_10_11 * 0.1
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + var_10_13 * var_10_2 + var_10_11 * 0.2
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + var_10_14 * var_10_3 + var_10_11 * 0.3
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - var_10_13 * var_10_2 + var_10_11 * 0.4
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - var_10_14 * var_10_4 + var_10_11 * 0.5
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + var_10_13 * var_10_2 + var_10_11 * 0.6
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 + var_10_14 * var_10_3 + var_10_11 * 0.7
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_15 - var_10_13 * var_10_2 + var_10_11 * 0.8
		else
			local var_10_16 = POSITION_LOOKUP[arg_10_0]

			arg_10_1[arg_10_2] = var_10_16 + side * var_10_2 + Vector3(0, 0, var_10_1 - 0.3)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + to_player_dir * var_10_3 + Vector3(0, 0, var_10_1 - 0.2)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - side * var_10_2 + Vector3(0, 0, var_10_1 - 0.1)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - to_player_dir * var_10_3 + Vector3(0, 0, var_10_1 + 0)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + side * var_10_2 + Vector3(0, 0, var_10_1 + 0.1)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + to_player_dir * var_10_3 + Vector3(0, 0, var_10_1 + 0.2)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - side * var_10_2 + Vector3(0, 0, var_10_1 + 0.3)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - to_player_dir * var_10_3 + Vector3(0, 0, var_10_1 + 0.4)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + side * var_10_2 + Vector3(0, 0, var_10_1 + 0.5)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 + to_player_dir * var_10_3 + Vector3(0, 0, var_10_1 + 0.6)
			arg_10_2 = arg_10_2 + 1
			arg_10_1[arg_10_2] = var_10_16 - side * var_10_2 + Vector3(0, 0, var_10_1 + 0.7)
		end

		return var_10_0
	end,
	evaded = function (arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = arg_11_2

		arg_11_2 = arg_11_2 + 1

		local var_11_1 = 0.7
		local var_11_2 = 0.55
		local var_11_3 = 0.35
		local var_11_4 = 0.55
		local var_11_5 = Unit.node(arg_11_0, "j_head")
		local var_11_6 = Unit.world_position(arg_11_0, var_11_5)
		local var_11_7 = Unit.node(arg_11_0, "j_hips")
		local var_11_8 = Unit.world_position(arg_11_0, var_11_7)
		local var_11_9 = Unit.world_rotation(arg_11_0, var_11_7)
		local var_11_10 = var_11_6 - var_11_8
		local var_11_11 = Quaternion.forward(var_11_9)
		local var_11_12 = Vector3.cross(var_11_11, var_11_10)
		local var_11_13 = Vector3.cross(var_11_12, var_11_10)
		local var_11_14 = var_11_8

		arg_11_1[arg_11_2] = var_11_14 + var_11_12 * var_11_2 - var_11_10 * 0.2
		arg_11_2 = arg_11_2 + 1
		arg_11_1[arg_11_2] = var_11_14 - var_11_13 * 1.5 - var_11_10 * 0.1
		arg_11_2 = arg_11_2 + 1
		arg_11_1[arg_11_2] = var_11_14 - var_11_13 * 5 - var_11_10 * 0.5

		return var_11_0
	end
}

TentacleSplineExtension.set_target = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_0.target_unit = arg_12_2
	arg_12_0.active_template_name = arg_12_1
	arg_12_0.tentacle_data.active_template_name = arg_12_1
	arg_12_0.reach_dist = math.clamp(arg_12_3, 0, 31)
end

TentacleSplineExtension.set_reach_dist = function (arg_13_0, arg_13_1)
	arg_13_0.reach_dist = math.clamp(arg_13_1, 0, 31)
end

TentacleSplineExtension.set_target_unit = function (arg_14_0, arg_14_1)
	arg_14_0.target_unit = arg_14_1
end

TentacleSplineExtension.set_server_time = function (arg_15_0, arg_15_1)
	arg_15_0._server_time_delta = arg_15_1 - Managers.time:time("main")
end

TentacleSplineExtension.set_astar_points = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.tentacle_data
	local var_16_1 = #arg_16_1

	if var_16_1 > 0 then
		local var_16_2 = var_16_0.root_pos:unbox()
		local var_16_3 = var_16_0.ground_pos:unbox()
		local var_16_4 = Unit.local_position(arg_16_0.portal_unit, 0)
		local var_16_5 = Vector3(var_16_3.x, var_16_3.y, var_16_2.z)

		table.insert(arg_16_1, 1, var_16_2)
		table.insert(arg_16_1, 2, var_16_4)
		table.insert(arg_16_1, 3, var_16_5)

		local var_16_6 = var_16_1 + 3

		var_16_0.travel_node_dir:store(Vector3.normalize(arg_16_1[var_16_6 - 1] - arg_16_1[var_16_6]))
		LevelAnalysis.boxify_pos_array(arg_16_1)

		var_16_0.astar_node_list = arg_16_1
		var_16_0.path_type = "follow_astar"
		var_16_0.travel_to_node_index = var_16_6 - 1
	else
		var_16_0.path_type = "straight"
	end

	var_16_0.reset = true
	var_16_0.astar_node_list = arg_16_1
end

TentacleSplineExtension.update_global_movement_sound_intensity = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0.previous_reach_dist or 0
	local var_17_1 = arg_17_0.reach_dist or var_17_0
	local var_17_2 = arg_17_2.movement_sound_scaling
	local var_17_3 = arg_17_2.movement_sound_max_intensity
	local var_17_4 = math.min(math.abs(var_17_0 - var_17_1) / arg_17_3 * var_17_2, var_17_3)
	local var_17_5 = arg_17_2.movement_sound_parameter

	Managers.state.entity:system("audio_system"):set_global_parameter_with_lerp(var_17_5, var_17_4)
end

TentacleSplineExtension.update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	if not Unit.alive(arg_18_0.target_unit) then
		return
	end

	local var_18_0 = arg_18_0.breed
	local var_18_1 = arg_18_0.tentacle_data

	if var_18_1.state == "startup" and arg_18_5 > var_18_1.startup_time then
		var_18_1.state = "recalc_path"

		local var_18_2 = Unit.node(arg_18_1, var_18_0.sound_head_node)
		local var_18_3 = Unit.node(arg_18_1, var_18_0.sound_body_node)

		WwiseUtils.trigger_unit_event(arg_18_0.world, "Play_tentacle_movement_head", arg_18_1, var_18_2)
		WwiseUtils.trigger_unit_event(arg_18_0.world, "Play_tentacle_movement_body", arg_18_1, var_18_3)
		WwiseUtils.trigger_unit_event(arg_18_0.world, "Play_enemy_sorcerer_tentacle_foley_grab_swing", arg_18_1, var_18_2)
	end

	if arg_18_0.is_server then
		local var_18_4 = arg_18_0.target_unit
		local var_18_5 = arg_18_0.target_unit and POSITION_LOOKUP[arg_18_0.target_unit] or var_18_1.last_target_pos:unbox()
		local var_18_6 = var_18_1.root_pos:unbox()
		local var_18_7 = arg_18_0.blackboard

		if var_18_1.state == "spline_update" then
			Unit.set_unit_visibility(arg_18_1, true)
			arg_18_0:align_tentacle(arg_18_0.active_template_name, var_18_1, var_18_5, arg_18_0.reach_dist, arg_18_5, arg_18_3)

			local var_18_8 = Managers.state.network:game()
			local var_18_9 = Managers.state.unit_storage:go_id(arg_18_0._unit)

			GameSession.set_game_object_field(var_18_8, var_18_9, "reach_distance", arg_18_0.reach_dist)
			var_18_1.last_target_pos:store(var_18_5)
		elseif var_18_1.state == "calculate_path" then
			arg_18_0:calculate_tentacle_path(arg_18_1, var_18_1, var_18_6, var_18_5)
		elseif var_18_1.state == "recalc_path" then
			local var_18_10 = var_18_7.nav_world

			if not var_18_1.ground_pos and var_18_1.portal_spawn_type == "floor" then
				local var_18_11 = var_18_1.wall_pos:unbox()
				local var_18_12 = arg_18_0:get_ground_pos_at_floor(arg_18_1, var_18_10, var_18_11, var_18_5)

				if var_18_12 then
					var_18_1.ground_pos = Vector3Box(var_18_12)
				end
			end

			local var_18_13, var_18_14 = GwNavQueries.triangle_from_position(var_18_10, var_18_5, 1, 1)

			if not var_18_13 then
				local var_18_15 = GwNavQueries.inside_position_from_outside_position(var_18_10, var_18_5, 1, 4, 4, 1)

				if var_18_15 then
					print("Target was outside mesh, found a close position, near it")

					var_18_5 = var_18_15
				end
			end

			if var_18_1.ground_pos then
				var_18_1.last_target_pos:store(var_18_5)

				local var_18_16 = var_18_1.a_star
				local var_18_17 = var_18_1.ground_pos:unbox()

				GwNavAStar.start(var_18_16, var_18_10, var_18_1.ground_pos:unbox(), var_18_5, var_18_1.traverse_logic)

				var_18_1.state = "calculate_path"
			else
				print("fallback w/o a-star")

				arg_18_0.tentacle_data.state = "spline_update"
				arg_18_0.tentacle_data.path_type = "straight"
			end
		elseif var_18_1.state == "no_path_found" and Vector3.distance_squared(var_18_5, var_18_1.last_target_pos:unbox()) > 1 then
			var_18_1.state = "recalc_path"
		end
	else
		if arg_18_0.tentacle_data.reset then
			arg_18_0.tentacle_data.reset = nil
		end

		local var_18_18 = arg_18_5 + arg_18_0._server_time_delta
		local var_18_19 = arg_18_0.target_unit and POSITION_LOOKUP[arg_18_0.target_unit] or var_18_1.last_target_pos:unbox()
		local var_18_20 = Managers.state.network:game()
		local var_18_21 = Managers.state.unit_storage:go_id(arg_18_1)
		local var_18_22 = GameSession.game_object_field(var_18_20, var_18_21, "reach_distance")

		arg_18_0.reach_dist = var_18_22

		arg_18_0:align_tentacle(arg_18_0.active_template_name, arg_18_0.tentacle_data, var_18_19, var_18_22, var_18_18, arg_18_3)
		var_18_1.last_target_pos:store(var_18_19)
	end

	arg_18_0:update_global_movement_sound_intensity(arg_18_1, var_18_0, arg_18_3)

	arg_18_0.previous_reach_dist = arg_18_0.reach_dist
end

TentacleSplineExtension.get_last_ground_pos = function (arg_19_0)
	return arg_19_0._last_good_ground_pos:unbox()
end

local function var_0_5(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1 or QuickDrawer

	for iter_20_0 = 1, #arg_20_0 do
		var_20_0:sphere(arg_20_0[iter_20_0]:unbox(), 0.4, Color(0, 255, 124))
	end
end

local var_0_6 = 0.6

TentacleSplineExtension.calculate_tentacle_path = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_2.a_star

	if GwNavAStar.processing_finished(var_21_0) then
		if GwNavAStar.path_found(var_21_0) then
			local var_21_1 = GwNavAStar.node_count(var_21_0)

			print("Tentacle Found path! node-count:", var_21_1)

			local var_21_2 = GwNavAStar.path_cost(var_21_0)
			local var_21_3 = GwNavAStar.path_distance(var_21_0)

			arg_21_2.state = "spline_update"

			if var_21_1 == 2 then
				arg_21_2.path_type = "straight"
			else
				arg_21_2.path_type = "follow_astar"

				local var_21_4 = Vector3(0, 0, 1.3)
				local var_21_5 = {}

				for iter_21_0 = 2, var_21_1 do
					var_21_5[iter_21_0 - 1] = GwNavAStar.node_at_index(var_21_0, iter_21_0) + var_21_4
				end

				local var_21_6 = Managers.state.network
				local var_21_7 = var_21_6:unit_game_object_id(arg_21_1)

				if var_0_0 then
					table.dump(var_21_5, "node-list:")
				end

				var_21_6.network_transmit:send_rpc_clients("rpc_sync_tentacle_path", var_21_7, var_21_5)

				local var_21_8 = arg_21_2.root_pos:unbox()
				local var_21_9 = arg_21_2.ground_pos:unbox()
				local var_21_10 = Unit.local_position(arg_21_0.portal_unit, 0)
				local var_21_11 = Vector3(var_21_9.x, var_21_9.y, var_21_8.z)

				table.insert(var_21_5, 1, var_21_8)
				table.insert(var_21_5, 2, var_21_10)
				table.insert(var_21_5, 3, var_21_11)

				local var_21_12 = var_21_1 + 2
				local var_21_13 = var_21_5[var_21_12]
				local var_21_14 = Vector3.normalize(var_21_5[var_21_12 - 1] - var_21_13)

				arg_21_2.travel_node_dir:store(var_21_14)

				arg_21_2.travel_to_node_index = var_21_12 - 1

				LevelAnalysis.boxify_pos_array(var_21_5)

				arg_21_2.astar_node_list = var_21_5
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

local var_0_7 = {
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
	for iter_22_0 = arg_22_3, #arg_22_4 do
		local var_22_0 = arg_22_4[iter_22_0]
		local var_22_1 = arg_22_2[var_22_0]
		local var_22_2, var_22_3 = GwNavQueries.triangle_from_position(arg_22_1, var_22_1, 4, 1)

		if var_22_2 and var_22_3 > var_22_1.z then
			local var_22_4 = var_22_1.z - var_22_3

			arg_22_2[var_22_0] = Vector3(var_22_1.x, var_22_1.y, var_22_3 - var_22_4)
		end
	end
end

TentacleSplineExtension.funnel_tentacle_to_center = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	local var_23_0 = 4

	Debug.text("influence dist: %.2f", var_23_0)

	for iter_23_0 = arg_23_2, arg_23_3 do
		local var_23_1 = arg_23_1[iter_23_0]
		local var_23_2 = Geometry.closest_point_on_line(var_23_1, arg_23_5, arg_23_4 + arg_23_6 * var_23_0)
		local var_23_3 = Vector3.length(var_23_2 - arg_23_5)
		local var_23_4 = var_23_3 - arg_23_7
		local var_23_5 = math.clamp(var_23_4, 0, var_23_3, var_23_0)
		local var_23_6 = 1 - math.clamp(var_23_5 / var_23_0, 0, 1)

		Debug.text("D %d %.2f total dist: %.2f rdist: %.2f", iter_23_0, var_23_6, Vector3.length(var_23_2 - arg_23_5) - arg_23_7, arg_23_7)

		local var_23_7 = var_23_1 - var_23_2
		local var_23_8 = 1

		if arg_23_8 then
			local var_23_9 = Vector3.length(var_23_7)
			local var_23_10 = 1 - math.clamp(var_23_9 / arg_23_8, 0, 1)

			var_23_2 = var_23_1 - var_23_7 * (var_23_6 + var_23_10 * var_23_10) * 0.5
		else
			var_23_2 = var_23_1 - var_23_7 * var_23_6
		end

		arg_23_1[iter_23_0] = var_23_2
	end
end

TentacleSplineExtension.funnel_one_point = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	local var_24_0 = 4
	local var_24_1 = Geometry.closest_point_on_line(arg_24_1, arg_24_3, arg_24_2 + arg_24_4 * var_24_0)
	local var_24_2 = Vector3.length(var_24_1 - arg_24_3)
	local var_24_3 = math.clamp(var_24_2 - arg_24_5, 0, var_24_2)
	local var_24_4 = 1 - math.clamp(var_24_3 / var_24_0, 0, 1)
	local var_24_5 = arg_24_1 - var_24_1
	local var_24_6 = 1

	if arg_24_6 then
		local var_24_7 = Vector3.length(var_24_5)

		var_24_6 = 1 - math.clamp(var_24_7 / arg_24_6, 0, 1)
		var_24_6 = var_24_6 * var_24_6
	end

	return arg_24_1 - var_24_5 * (var_24_4 + var_24_6) * 0.5, Vector3.length(var_24_5)
end

local function var_0_8(arg_25_0, arg_25_1)
	local var_25_0 = 0

	for iter_25_0 = #arg_25_0 - 1, 1, -1 do
		local var_25_1 = arg_25_0[iter_25_0 + 1]:unbox()
		local var_25_2 = arg_25_0[iter_25_0]:unbox() - var_25_1
		local var_25_3 = Vector3.length(var_25_2)

		var_25_0 = var_25_0 + var_25_3

		if arg_25_1 < var_25_0 then
			return var_25_1 + var_25_2 * ((var_25_3 - (var_25_0 - arg_25_1)) / var_25_3), iter_25_0
		end
	end

	return path_list[1]:unbox(), 1
end

TentacleSplineExtension.align_tentacle = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	local var_26_0 = arg_26_2.spline
	local var_26_1 = Quaternion.forward(Unit.local_rotation(arg_26_2.portal_unit, 0))
	local var_26_2 = arg_26_2.root_pos:unbox()
	local var_26_3 = arg_26_2.wall_pos:unbox()
	local var_26_4 = arg_26_3 - var_26_2
	local var_26_5 = Vector3.normalize(var_26_4)
	local var_26_6 = Vector3.length(var_26_4)
	local var_26_7 = arg_26_2.portal_spawn_type
	local var_26_8 = Vector3.cross(var_26_5, Vector3.up())
	local var_26_9 = {}
	local var_26_10
	local var_26_11 = 0

	if arg_26_2.path_type == "straight" then
		local var_26_12 = var_0_7.first_part

		if arg_26_0.ik_tentacle then
			arg_26_0.ik_tentacle:set_target_pos(arg_26_3 + Vector3(0, 0, 1), 2)
			arg_26_0.ik_tentacle:solve(arg_26_5, arg_26_6)

			local var_26_13 = arg_26_0.ik_tentacle.joints

			for iter_26_0 = 1, #var_26_13 do
				var_26_9[iter_26_0] = var_26_13[iter_26_0]:unbox()
			end

			var_26_11 = #var_26_9
		elseif var_26_6 < 30 then
			var_26_12 = var_0_7.attack_a

			local var_26_14 = 1.5
			local var_26_15 = arg_26_5 * 1.5

			if var_26_7 == "wall" then
				local var_26_16 = var_26_6
				local var_26_17 = var_26_2 + Vector3(0, 0, 0.5)

				var_26_9[1] = var_26_2
				var_26_9[2] = var_26_17 + var_26_5 * var_26_16 * 0.1
				var_26_9[3] = var_26_17 + var_26_5 * var_26_16 * 0.2
				var_26_9[4] = var_26_17 + var_26_5 * var_26_16 * 0.3
				var_26_9[5] = var_26_17 + var_26_5 * var_26_16 * 0.4
				var_26_9[6] = var_26_17 + var_26_5 * var_26_16 * 0.5
				var_26_9[7] = var_26_17 + var_26_5 * var_26_16 * 0.6
				var_26_9[8] = var_26_17 + var_26_5 * var_26_16 * 0.7
				var_26_9[9] = var_26_17 + var_26_5 * var_26_16 * 0.8
				var_26_9[10] = var_26_17 + var_26_5 * var_26_16 * 0.9
				var_26_9[11] = var_26_17 + var_26_5 * var_26_16 * 1

				for iter_26_1 = 1, #var_26_9 do
					QuickDrawer:sphere(var_26_9[iter_26_1], 0.26, Color(0, 255, 0))
				end
			else
				local var_26_18 = Vector3.length

				local function var_26_19(arg_27_0, arg_27_1, arg_27_2)
					local var_27_0 = var_26_18(arg_27_0)
					local var_27_1 = math.clamp(var_27_0 / 4, 0, 1)

					return Vector3(arg_27_0.x, arg_27_0.y, var_27_1 * arg_27_1 + (var_27_1 - 1) * arg_27_2)
				end

				local var_26_20 = Vector3(0, 0, 1)
				local var_26_21 = {
					var_26_5 * var_26_6 * 0.1,
					var_26_5 * var_26_6 * 0.25 + var_26_8 * 0.25 * math.sin((var_26_15 + 0) * var_26_14) + Vector3(0, 0, 0.5 + math.sin((var_26_15 + 0) * 0.5)) * 0.25,
					var_26_5 * var_26_6 * 0.5 + var_26_8 * 0.5 * math.sin((var_26_15 + 0.6) * var_26_14) + Vector3(0, 0, 0.5 + math.sin((var_26_15 + 0.1) * 0.5)) * 0.5,
					var_26_5 * var_26_6 * 0.75 + var_26_8 * math.sin((var_26_15 + 0.9) * var_26_14 * 0.5) + Vector3(0, 0, 0.5 + math.sin((var_26_15 + 0.2) * 0.5))
				}

				var_26_9[1] = var_26_2

				local var_26_22 = var_26_3 - var_26_2

				for iter_26_2 = 1, 4 do
					var_26_9[iter_26_2 + 1] = var_26_2 + var_26_19(var_26_21[iter_26_2], var_26_22.z + 1, 0) + var_26_20
				end
			end

			var_26_11 = 5
			var_26_11 = #var_26_9
		else
			var_26_9[1] = var_26_2
			var_26_9[2] = var_26_2 + var_26_1 * 3
			var_26_9[3] = var_26_2 + var_26_5 * (6 + 1 * math.sin(arg_26_5 * 2)) + Vector3.cross(var_26_5, Vector3.up()) * 2.5 * math.sin(arg_26_5 * 1.5)
			var_26_9[4] = var_26_2 + var_26_5 * 8.5 - Vector3.cross(var_26_5, Vector3.up()) * 0.5 * (0.7 + 0.3 * math.cos(arg_26_5 * 3))
			var_26_11 = 4
		end

		local var_26_23
		local var_26_24

		if var_26_7 == "floor" then
			local var_26_25 = var_26_11
			local var_26_26 = 4

			arg_26_0:funnel_tentacle_to_center(var_26_9, 2, var_26_25, var_26_3, var_26_2, var_26_1, var_26_26, 3)
		else
			local var_26_27 = var_26_11
			local var_26_28 = 2.5

			arg_26_0:keep_tentacle_above_ground(arg_26_0.nav_world, var_26_9, 4, var_26_12)
			arg_26_0:funnel_tentacle_to_center(var_26_9, 2, var_26_27, var_26_3, var_26_2, var_26_1, var_26_28)
		end

		if arg_26_1 == "attack" then
			var_26_10 = var_0_4.attack(arg_26_0.target_unit, var_26_9, var_26_11)
		elseif arg_26_1 == "launch_out" then
			var_26_11 = var_26_11 + 1
			var_26_9[var_26_11] = arg_26_3 + var_26_8 * 0.55 + Vector3(0, 0, 2)
		elseif arg_26_1 == "evaded" then
			var_26_10 = var_0_4.evaded(arg_26_0.target_unit, var_26_9, var_26_11)
		end

		Debug.reset_sticky_world_texts()
	elseif arg_26_2.path_type == "follow_astar" then
		local var_26_29 = arg_26_2.astar_node_list
		local var_26_30 = arg_26_2.travel_to_node_index
		local var_26_31 = arg_26_3 + Vector3(0, 0, 1.3)

		var_26_29[var_26_30 + 1]:store(var_26_31)

		local var_26_32 = var_26_29[var_26_30]:unbox() - var_26_31
		local var_26_33 = Vector3.normalize(var_26_32)
		local var_26_34 = arg_26_2.travel_node_dir:unbox()
		local var_26_35
		local var_26_36
		local var_26_37
		local var_26_38, var_26_39 = var_0_8(var_26_29, var_0_6)

		if var_26_39 < var_26_30 then
			var_26_37 = var_26_39
		end

		local var_26_40 = var_26_38

		arg_26_2.look_dir = Vector3Box(Vector3.normalize(var_26_40 - var_26_31))

		local var_26_41 = var_0_3 and var_26_40 - arg_26_2.look_dir:unbox() * 0.2 or nil

		if Vector3.dot(var_26_32, var_26_34) < 0 and var_26_30 > 1 then
			arg_26_2.travel_node_dir:store(Vector3.normalize(var_26_29[var_26_30 - 1]:unbox() - var_26_29[var_26_30]:unbox()))

			arg_26_2.travel_to_node_index = var_26_30 - 1
			var_26_29[var_26_30] = var_26_29[var_26_30 + 1]
			var_26_29[var_26_30 + 1] = nil
		end

		var_26_9 = {}

		local var_26_42 = #var_26_29 - 1
		local var_26_43 = 2 * math.pi / var_26_42

		for iter_26_3 = 1, var_26_42 do
			var_26_9[iter_26_3] = var_26_29[iter_26_3]:unbox()
		end

		local var_26_44 = var_26_42 + 1

		if var_26_37 then
			var_26_9[var_26_37 + 1] = var_26_40

			for iter_26_4 = var_26_37 + 2, #var_26_9 do
				var_26_9[iter_26_4] = nil
			end

			var_26_44 = var_26_37 + 1
		else
			var_26_9[var_26_44] = var_26_40
		end

		if var_0_3 then
			var_26_44 = var_26_44 + 1
			var_26_9[var_26_44] = var_26_41
		end

		if arg_26_1 == "attack" then
			var_26_10 = var_0_4.attack(arg_26_0.target_unit, var_26_9, var_26_44)
		end
	end

	local var_26_45 = SplineCurve:new(var_26_9, "Hermite", "SplineMovementHermiteInterpolatedMetered", "Tentacle", 3)

	arg_26_0.spline = var_26_45
	arg_26_2.spline = var_26_45

	local var_26_46

	if var_26_10 then
		var_26_46 = var_26_45:get_travel_dist_to_spline_point(var_26_10) + 2
		arg_26_0.lock_point_dist = var_26_46

		local var_26_47, var_26_48, var_26_49 = var_26_45:get_point_at_distance(var_26_46)
		local var_26_50 = var_26_47 + Vector3(0, 0, 0.66)

		QuickDrawer:line(var_26_47, var_26_50, Color(255, 128, 0))
		QuickDrawer:sphere(var_26_47, 0.25, Color(200, 128, 0))
	end

	local var_26_51 = arg_26_2.unit
	local var_26_52 = arg_26_2.root_pos:unbox()
	local var_26_53 = arg_26_2.bone_nodes
	local var_26_54 = arg_26_2.num_bone_nodes
	local var_26_55 = 1
	local var_26_56 = var_26_52
	local var_26_57 = Unit.local_rotation(var_26_51, 0)
	local var_26_58 = Matrix4x4.from_quaternion_position(var_26_57, var_26_52)
	local var_26_59 = arg_26_2.node_spacings
	local var_26_60 = #var_26_59
	local var_26_61 = arg_26_4
	local var_26_62 = arg_26_2.dists

	for iter_26_5 = var_26_60, 1, -1 do
		var_26_62[iter_26_5] = var_26_61
		var_26_61 = var_26_61 - var_26_59[iter_26_5]

		if var_26_61 < 0 then
			var_26_61 = 0
		end
	end

	local var_26_63 = 20 * math.pi / var_26_60

	for iter_26_6 = 1, var_26_60 do
		local var_26_64 = var_26_53[iter_26_6]
		local var_26_65, var_26_66, var_26_67 = var_26_45:get_point_at_distance(var_26_62[iter_26_6])

		if var_26_10 and var_26_62[iter_26_6] < var_26_46 - 2 then
			local var_26_68 = math.sin(arg_26_5 * 6 + var_26_63 * iter_26_6) * 0.065

			var_26_65 = var_26_65 + Vector3(var_26_68, var_26_68, var_26_68)
		end

		local var_26_69 = Quaternion.look(var_26_66, Vector3.up())
		local var_26_70 = Matrix4x4.from_quaternion_position(var_26_69, var_26_65)
		local var_26_71 = Matrix4x4.multiply(var_26_70, Matrix4x4.inverse(var_26_58))

		Unit.set_local_pose(var_26_51, var_26_64, var_26_71)

		local var_26_72 = var_26_65

		var_26_58 = var_26_70
	end
end
