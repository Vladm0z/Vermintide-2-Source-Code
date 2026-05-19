-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_skulk_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererSkulkApproachAction = class(BTChaosSorcererSkulkApproachAction, BTNode)

local var_0_0 = BTChaosSorcererSkulkApproachAction
local var_0_1 = Unit.alive
local var_0_2 = POSITION_LOOKUP

function var_0_0.init(arg_1_0, ...)
	var_0_0.super.init(arg_1_0, ...)

	arg_1_0.cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase
end

var_0_0.name = "BTChaosSorcererSkulkApproachAction"

function var_0_0.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.breed
	local var_2_2 = arg_2_2.skulk_data or {}

	arg_2_2.skulk_data = var_2_2
	var_2_2.direction = var_2_2.direction or 1 - math.random(0, 1) * 2
	var_2_2.radius = var_2_2.radius or arg_2_2.target_dist
	arg_2_2.action = var_2_0

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:idle(arg_2_1, arg_2_2)
	end

	arg_2_2.navigation_extension:set_max_speed(var_2_1.run_speed)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if arg_2_2.move_pos then
		local var_2_3 = arg_2_2.move_pos:unbox()

		arg_2_0:move_to(var_2_3, arg_2_1, arg_2_2)
	end

	arg_2_2.ready_to_summon = false
	arg_2_2.num_summons = arg_2_2.num_summons or 0

	if var_2_0.sorcerer_type == "tentacle" then
		if not arg_2_2.portal_data then
			arg_2_2.portal_data = {
				chance_to_look_for_wall_spawn = 0.5,
				search_counter = 0,
				portal_spawn_type = "n/a",
				portal_search_timer = arg_2_3 + 3,
				cover_units = {},
				portal_spawn_pos = Vector3Box(),
				portal_spawn_rot = QuaternionBox(),
				physics_world = World.get_data(arg_2_2.world, "physics_world")
			}
			arg_2_2.spell = arg_2_2.portal_data
		end
	elseif var_2_0.sorcerer_type == "vortex" and not arg_2_2.vortex_data then
		arg_2_0:initialize_vortex_data(arg_2_2, var_2_0.vortex_template_name)

		arg_2_2.spell = arg_2_2.vortex_data
	end

	if arg_2_2.teleport_health_percent == nil or arg_2_2.set_teleport_hp then
		local var_2_4 = ScriptUnit.extension(arg_2_1, "health_system")

		arg_2_2.health_extension = var_2_4
		arg_2_2.teleport_health_percent = var_2_4:current_health_percent() - var_2_0.part_hp_lost_to_teleport
		arg_2_2.set_teleport_hp = nil
	end

	arg_2_2.travel_teleport_timer = arg_2_3 + ConflictUtils.random_interval(var_2_0.teleport_cooldown)
end

local var_0_3 = math.pi / 4

function var_0_0.initialize_vortex_data(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = VortexTemplates[arg_3_2]
	local var_3_1 = var_3_0.full_inner_radius
	local var_3_2 = Vector3.forward() * var_3_1
	local var_3_3 = {}

	for iter_3_0 = 1, 8 do
		local var_3_4 = Quaternion(Vector3.up(), var_0_3 * (iter_3_0 - 1))
		local var_3_5 = Quaternion.rotate(var_3_4, var_3_2)

		var_3_3[iter_3_0] = Vector3Box(var_3_5)
	end

	arg_3_1.vortex_data = {
		spawn_timer = 3,
		physics_world = World.get_data(arg_3_1.world, "physics_world"),
		vortex_spawn_pos = Vector3Box(),
		vortex_units = {},
		queued_vortex = {},
		radius_check_directions = var_3_3,
		vortex_template = var_3_0
	}
end

function var_0_0.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_2.skulk_data
	local var_4_1 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local var_4_2 = arg_4_2.navigation_extension

	var_4_2:set_max_speed(var_4_1)

	if arg_4_4 == "aborted" then
		local var_4_3 = var_4_2:is_following_path()

		if arg_4_2.move_pos and var_4_3 and arg_4_2.move_state == "idle" then
			arg_4_0:start_move_animation(arg_4_1, arg_4_2)
		end
	end

	var_4_0.animation_state = nil
	arg_4_2.action = nil
end

function var_0_0.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.navigation_extension
	local var_5_1 = var_5_0:is_following_path()
	local var_5_2 = var_5_0:number_failed_move_attempts()
	local var_5_3 = arg_5_2.action

	if arg_5_0[var_5_3.search_func_name](arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_2.spell) then
		return "done"
	end

	local var_5_4 = arg_5_2.skulk_data

	if arg_5_2.move_pos and var_5_1 and arg_5_2.move_state == "idle" then
		arg_5_0:start_move_animation(arg_5_1, arg_5_2)
	end

	if arg_5_2.health_extension:current_health_percent() < arg_5_2.teleport_health_percent then
		local var_5_5 = var_0_2[arg_5_1]
		local var_5_6 = math.random() * 5 + math.random() * 5 + math.random() * 5
		local var_5_7 = var_5_6 * 0.5 + var_5_3.preferred_distance
		local var_5_8 = 5
		local var_5_9 = ConflictUtils.get_spawn_pos_on_circle(arg_5_2.nav_world, var_5_5, var_5_7, var_5_6, var_5_8)

		if var_5_9 then
			arg_5_2.set_teleport_hp = true
			arg_5_2.quick_teleport_exit_pos = Vector3Box(var_5_9)
			arg_5_2.quick_teleport = true
			var_5_4.direction = nil
			arg_5_2.move_pos = nil

			return "done"
		end
	elseif arg_5_3 > arg_5_2.travel_teleport_timer then
		local var_5_10 = arg_5_0:get_skulk_target(arg_5_1, arg_5_2, true)

		if var_5_10 then
			arg_5_2.quick_teleport_exit_pos = Vector3Box(var_5_10)
			arg_5_2.quick_teleport = true
			arg_5_2.move_pos = nil

			return "done"
		end
	end

	if arg_5_2.move_pos then
		if arg_5_0:at_goal(arg_5_1, arg_5_2) or var_5_2 > 0 then
			arg_5_2.move_pos = nil
		end

		return "running"
	end

	local var_5_11 = arg_5_0:get_skulk_target(arg_5_1, arg_5_2)

	if var_5_11 then
		arg_5_0:move_to(var_5_11, arg_5_1, arg_5_2)

		return "running"
	end

	if arg_5_2.move_state ~= "idle" then
		arg_5_0:idle(arg_5_1, arg_5_2)
	end

	return "running"
end

function var_0_0.at_goal(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.move_pos

	if not var_6_0 then
		return false
	end

	local var_6_1 = var_6_0:unbox()

	if Vector3.distance_squared(var_6_1, var_0_2[arg_6_1]) < 0.25 then
		return true
	end
end

function var_0_0.move_to(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_3.navigation_extension:move_to(arg_7_1)

	arg_7_3.move_pos = Vector3Box(arg_7_1)
end

function var_0_0.idle(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:anim_event(arg_8_1, arg_8_2, "idle")

	arg_8_2.move_state = "idle"
end

function var_0_0.start_move_animation(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.action.move_animation

	arg_9_0:anim_event(arg_9_1, arg_9_2, var_9_0)

	arg_9_2.move_state = "moving"
end

function var_0_0.anim_event(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_2.skulk_data

	if var_10_0.animation_state ~= arg_10_3 then
		Managers.state.network:anim_event(arg_10_1, arg_10_3)

		var_10_0.animation_state = arg_10_3
	end
end

local var_0_4 = 15

function var_0_0.get_skulk_target(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2.action
	local var_11_1 = arg_11_2.nav_world
	local var_11_2 = arg_11_2.skulk_data
	local var_11_3 = var_11_2.direction
	local var_11_4 = arg_11_2.target_unit
	local var_11_5 = var_0_2[var_11_4]
	local var_11_6 = var_0_2[arg_11_1]
	local var_11_7 = arg_11_2.target_dist
	local var_11_8 = var_11_6 - var_11_5
	local var_11_9 = Vector3.normalize(var_11_8)
	local var_11_10 = var_11_0.preferred_distance

	if arg_11_2.is_close then
		if var_11_7 < var_11_10 then
			var_11_8 = var_11_8 + var_11_9 * (1 + math.random())
		else
			arg_11_2.is_close = false
			var_11_8 = var_11_8 + var_11_9
		end
	elseif var_11_7 < var_11_0.close_distance then
		arg_11_2.is_close = true
		var_11_8 = var_11_8 + var_11_9
	end

	local var_11_11 = Vector3(0, 0, var_11_3)
	local var_11_12 = 0.1
	local var_11_13 = math.pi * math.clamp(var_11_12 * 20 / var_11_7, 0.01, 0.15)

	if arg_11_3 then
		var_11_13 = var_11_13 * 1.5
	end

	for iter_11_0 = 1, var_0_4 do
		local var_11_14 = var_11_8 - var_11_9 * 0.5

		if arg_11_2.num_summons and arg_11_2.num_summons >= (var_11_0.teleport_closer_summon_limit or 3) then
			var_11_14 = Vector3.normalize(var_11_5 - var_11_6) * var_11_0.teleport_closer_range
		end

		local var_11_15 = var_11_5 + Quaternion.rotate(Quaternion(var_11_11, var_11_13 * iter_11_0), var_11_14)
		local var_11_16 = ConflictUtils.find_center_tri(var_11_1, var_11_15)

		if var_11_16 then
			return var_11_16
		end
	end

	var_11_2.direction = var_11_2.direction * -1
end

function var_0_0.debug_show_skulk_circle(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.skulk_data
	local var_12_1 = arg_12_2.target_unit
	local var_12_2 = var_0_2[var_12_1]
	local var_12_3 = Vector3.up() * 0.2

	QuickDrawer:circle(var_12_2 + var_12_3, arg_12_2.target_dist, Vector3.up(), Colors.get("light_green"))
	QuickDrawer:circle(var_12_2 + var_12_3, var_12_0.radius, Vector3.up(), Colors.get("light_green"))

	var_12_0.radius = arg_12_2.target_dist
end

function var_0_0.update_dummie(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	return false
end

function var_0_0._update_vortex_search(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if arg_14_3 > arg_14_4.spawn_timer then
		local var_14_0 = arg_14_4.vortex_units
		local var_14_1 = #var_14_0
		local var_14_2 = 1

		while var_14_2 <= var_14_1 do
			local var_14_3 = var_14_0[var_14_2]

			if not var_0_1(var_14_3) then
				var_14_0[var_14_2] = var_14_0[var_14_1]
				var_14_0[var_14_1] = nil
				var_14_1 = var_14_1 - 1
			else
				var_14_2 = var_14_2 + 1
			end
		end

		local var_14_4 = arg_14_2.action
		local var_14_5 = arg_14_2.target_dist
		local var_14_6 = var_14_5 and var_14_5 > var_14_4.min_cast_vortex_distance and var_14_5 < var_14_4.max_cast_vortex_distance

		if not arg_14_2.freeze_spell_casting and var_14_1 < arg_14_2.max_vortex_units and var_14_6 then
			local var_14_7 = arg_14_2.target_unit
			local var_14_8 = Unit.node(arg_14_1, "j_head")
			local var_14_9 = Unit.world_position(arg_14_1, var_14_8)
			local var_14_10 = Unit.node(var_14_7, "j_head")
			local var_14_11 = Unit.world_position(var_14_7, var_14_10)
			local var_14_12 = arg_14_4.physics_world

			if not PerceptionUtils.is_position_in_line_of_sight(arg_14_1, var_14_9, var_14_11, var_14_12) then
				arg_14_4.spawn_timer = arg_14_3 + var_14_4.vortex_check_timer

				return false
			end

			local var_14_13, var_14_14 = var_0_0._get_vortex_cast_position(arg_14_1, arg_14_2, arg_14_4, var_14_12)

			if not var_14_13 then
				arg_14_4.spawn_timer = arg_14_3 + var_14_4.vortex_check_timer

				return false
			end

			arg_14_2.ready_to_summon = true
			arg_14_2.num_summons = arg_14_2.num_summons + 1

			arg_14_4.vortex_spawn_pos:store(var_14_13)

			arg_14_4.vortex_spawn_radius = var_14_14
			arg_14_4.spawn_timer = arg_14_3 + var_14_4.vortex_spawn_timer

			return true
		else
			arg_14_4.spawn_timer = arg_14_3 + var_14_4.vortex_check_timer
		end
	end
end

function var_0_0._get_vortex_cast_position(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_1.action
	local var_15_1 = FrameTable.alloc_table()
	local var_15_2 = arg_15_1.target_dist
	local var_15_3 = arg_15_1.navigation_extension:traverse_logic()

	var_15_1.nav_world = arg_15_1.nav_world
	var_15_1.physics_world = arg_15_3
	var_15_1.from_unit = arg_15_0
	var_15_1.from_node_name = "j_head"
	var_15_1.to_unit = arg_15_1.target_unit
	var_15_1.to_node_name = "j_head"
	var_15_1.min_distance = var_15_0.min_player_vortex_distance
	var_15_1.max_distance = math.min(var_15_2, var_15_0.max_player_vortex_distance)
	var_15_1.max_tries = 3
	var_15_1.outside_goal_tries = 3
	var_15_1.above = 15
	var_15_1.below = 15
	var_15_1.min_angle_step = 4
	var_15_1.max_angle_step = 8
	var_15_1.traverse_logic = var_15_3
	var_15_1.min_wanted_radius = VortexTemplates[var_15_0.vortex_template_name].min_inner_radius
	var_15_1.radius_check_directions = arg_15_2.radius_check_directions

	local var_15_4, var_15_5 = LocomotionUtils.pick_visible_outside_goal(var_15_1)

	return var_15_4, var_15_5
end

local var_0_5 = 7
local var_0_6 = 20
local var_0_7 = 1.5
local var_0_8 = false
local var_0_9 = false

function var_0_0.update_portal_search(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if arg_16_2.target_unit and not var_0_1(arg_16_2.portal_unit) then
		if arg_16_4.portal_search_active then
			local var_16_0 = var_0_2[arg_16_2.target_unit]
			local var_16_1 = var_0_0.try_next_portal_location(arg_16_4, arg_16_2.nav_world, var_16_0)

			if var_16_1 == "success" then
				arg_16_2.ready_to_summon = true
				arg_16_4.portal_search_active = false

				return "done"
			elseif var_16_1 == "failed" then
				arg_16_4.portal_search_timer = 0
				arg_16_4.portal_search_active = false
				arg_16_4.portal_search_timer = arg_16_3 + 1
			end
		elseif arg_16_3 > arg_16_4.portal_search_timer and not arg_16_2.portal_unit then
			local var_16_2 = var_0_2[arg_16_2.target_unit]
			local var_16_3 = var_0_0.get_portal_location_list(arg_16_4, var_16_2)

			arg_16_4.search_counter = var_16_3 and 0 or arg_16_4.search_counter + 1
			arg_16_4.portal_search_active = var_16_3
			arg_16_4.portal_search_timer = arg_16_3 + 1
		end
	end
end

function var_0_0.get_portal_location_list(arg_17_0, arg_17_1)
	if math.random() <= arg_17_0.chance_to_look_for_wall_spawn then
		if var_0_0.prepare_wall_search(arg_17_0, arg_17_1) then
			arg_17_0.placement = "wall"

			return true
		else
			arg_17_0.floor_search_count = 0
			arg_17_0.placement = "floor"

			return true
		end
	end

	arg_17_0.floor_search_count = 0
	arg_17_0.placement = "floor"

	return true
end

function var_0_0.prepare_wall_search(arg_18_0, arg_18_1)
	local var_18_0 = Managers.state.conflict.level_analysis.cover_points_broadphase
	local var_18_1 = 30
	local var_18_2 = arg_18_0.cover_units
	local var_18_3 = Broadphase.query(var_18_0, arg_18_1, var_18_1, var_18_2)

	if var_18_3 <= 0 then
		return false
	end

	arg_18_0.num_cover_points = var_18_3
	arg_18_0.cover_point_index = 1
	arg_18_0.placement = "wall"

	if var_0_9 then
		local var_18_4 = Unit.local_rotation
		local var_18_5 = Unit.local_position
		local var_18_6 = Color(255, 255, 0)
		local var_18_7 = Color(70, 255, 0)
		local var_18_8 = Vector3(0, 0, 1)

		for iter_18_0 = 1, var_18_3 do
			local var_18_9 = var_18_2[iter_18_0]
			local var_18_10 = var_18_5(var_18_9, 0)
			local var_18_11 = var_18_10 + var_18_8
			local var_18_12 = var_18_4(var_18_9, 0)
			local var_18_13 = Quaternion.forward(var_18_12)
			local var_18_14 = -Quaternion.right(var_18_12) * 0.85
			local var_18_15 = -Quaternion.up(var_18_12) * 0.85

			QuickDrawerStay:sphere(var_18_10, 0.15, var_18_7)
			QuickDrawerStay:sphere(var_18_11, 0.1, var_18_6)
			QuickDrawerStay:line(var_18_11, var_18_11 + var_18_13, var_18_6)
			QuickDrawerStay:line(var_18_11 + var_18_14, var_18_11 + var_18_14 + var_18_13, var_18_6)
			QuickDrawerStay:line(var_18_11 - var_18_14, var_18_11 - var_18_14 + var_18_13, var_18_6)
			QuickDrawerStay:line(var_18_11 + var_18_15, var_18_11 + var_18_15 + var_18_13, var_18_6)
			QuickDrawerStay:line(var_18_11 - var_18_15, var_18_11 - var_18_15 + var_18_13, var_18_6)
		end
	end

	return true
end

local function var_0_10(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = Vector3(arg_19_1 + (math.random() - 0.5) * arg_19_2, 0, 1)

	return arg_19_0 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_19_0)
end

function var_0_0.evaluate_floor(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = var_0_10(arg_20_2, var_0_6, 10)
	local var_20_1
	local var_20_2
	local var_20_3
	local var_20_4
	local var_20_5

	if var_20_0 then
		local var_20_6

		var_20_6, var_20_1 = GwNavQueries.raycast(arg_20_1, arg_20_2, var_20_0)
		var_20_2 = GwNavQueries.inside_position_from_outside_position(arg_20_1, var_20_1, 1, 1, 5, var_0_7)

		if var_20_2 then
			local var_20_7 = var_20_2 - arg_20_2

			if Vector3.length(var_20_7) > var_0_5 then
				local var_20_8 = GwNavTraversal.get_seed_triangle(arg_20_1, var_20_2)
				local var_20_9, var_20_10, var_20_11 = GwNavTraversal.get_triangle_vertices(arg_20_1, var_20_8)

				var_20_4 = Vector3.normalize(Vector3.cross(var_20_10 - var_20_9, var_20_11 - var_20_9))

				local var_20_12 = Quaternion.look(var_20_4, Vector3.normalize(var_20_7))

				if arg_20_0.portal_spawn_pos then
					arg_20_0.portal_spawn_pos:store(var_20_2)
					arg_20_0.portal_spawn_rot:store(var_20_12)
				end

				arg_20_0.portal_spawn_type = "floor"
				arg_20_0.portal_search_active = false
				var_20_3 = "success"

				Debug.sticky_text("Found floor pos")
			end
		end
	end

	if var_0_8 and var_20_0 then
		QuickDrawer:sphere(var_20_0, 0.25, Color(0, 200, 200))
		QuickDrawer:line(var_20_0, arg_20_2, Color(0, 200, 125))

		if var_20_1 then
			QuickDrawerStay:sphere(var_20_1, 0.5, Color(20, 200, 70))
		end

		if var_20_3 then
			QuickDrawer:line(var_20_1, var_20_2, Color(20, 200, 70))
			QuickDrawer:sphere(var_20_2, var_0_7, Color(20, 200, 70))
			QuickDrawer:line(var_20_2, var_20_2 + var_20_4, Color(20, 200, 70))
		else
			Debug.sticky_text("no random floor pick pos found")
		end
	end

	return var_20_3
end

local var_0_11 = 25

function var_0_0.evaluate_wall(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0.cover_point_index
	local var_21_1 = arg_21_0.num_cover_points
	local var_21_2 = var_21_0 + arg_21_3
	local var_21_3 = arg_21_0.cover_units
	local var_21_4 = Unit.local_rotation
	local var_21_5 = Unit.local_position

	while var_21_0 < var_21_2 do
		if var_21_1 < var_21_0 then
			arg_21_0.portal_search_active = false

			return "failed"
		end

		local var_21_6 = var_21_3[var_21_0]
		local var_21_7 = var_21_5(var_21_6, 0)

		if Vector3.distance_squared(var_21_7, arg_21_2) > var_0_11 then
			local var_21_8 = var_21_4(var_21_6, 0)
			local var_21_9 = Quaternion.forward(var_21_8)
			local var_21_10 = true

			if var_21_10 then
				local var_21_11, var_21_12, var_21_13, var_21_14 = PhysicsWorld.immediate_raycast(arg_21_0.physics_world, var_21_7 + Vector3(0, 0, 1), var_21_9, 1.5, "closest", "collision_filter", "filter_ai_mover")

				if var_21_11 then
					if arg_21_0.portal_spawn_pos then
						local var_21_15 = Quaternion.look(var_21_14, Vector3.up())

						arg_21_0.portal_spawn_pos:store(var_21_12)
						arg_21_0.portal_spawn_rot:store(var_21_15)
					end

					arg_21_0.portal_spawn_type = "wall"
					arg_21_0.portal_search_active = false

					if var_0_9 then
						QuickDrawerStay:cylinder(var_21_12, var_21_12 + var_21_14, var_0_7, Color(220, 60, 70), 10)
						QuickDrawerStay:sphere(var_21_12, var_0_7 * 0.5, Color(220, 30, 30))
					end

					return "success"
				end
			end
		end

		var_21_0 = var_21_0 + 1
	end

	arg_21_0.cover_point_index = var_21_0
end

function var_0_0.try_next_portal_location(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.placement
	local var_22_1, var_22_2 = GwNavQueries.triangle_from_position(arg_22_1, arg_22_2, 3, 3)

	if var_22_1 then
		arg_22_2 = Vector3.copy(arg_22_2)

		Vector3.set_z(arg_22_2, var_22_2)
	end

	if var_22_0 == "floor" then
		local var_22_3 = 3

		for iter_22_0 = 1, var_22_3 do
			local var_22_4 = var_0_0.evaluate_floor(arg_22_0, arg_22_1, arg_22_2)

			if var_22_4 then
				return var_22_4
			end
		end

		arg_22_0.floor_search_count = arg_22_0.floor_search_count + var_22_3

		if arg_22_0.floor_search_count > 30 then
			return "failed"
		end
	elseif var_22_0 == "wall" then
		local var_22_5 = 3

		return var_0_0.evaluate_wall(arg_22_0, arg_22_1, arg_22_2, var_22_5)
	end
end
