-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_skulk_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererSkulkApproachAction = class(BTChaosSorcererSkulkApproachAction, BTNode)

local BTChaosSorcererSkulkApproachAction = BTChaosSorcererSkulkApproachAction
local alive = Unit.alive
local POSITION_LOOKUP = POSITION_LOOKUP

BTChaosSorcererSkulkApproachAction.init = function (self, ...)
	-- function 1
	BTChaosSorcererSkulkApproachAction.super.init(self, ...)

	self.cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase
end

BTChaosSorcererSkulkApproachAction.name = "BTChaosSorcererSkulkApproachAction"

BTChaosSorcererSkulkApproachAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local breed = arg_2_2.breed
	local skulk_data = arg_2_2.skulk_data

	skulk_data = skulk_data or {}
	arg_2_2.skulk_data = skulk_data

	local direction = skulk_data.direction

	direction = direction or 1 - math.random(0, 1) * 2
	skulk_data.direction = direction

	local radius = skulk_data.radius

	radius = radius or arg_2_2.target_dist
	skulk_data.radius = radius
	arg_2_2.action = action_data

	if arg_2_2.move_state ~= "idle" then
		self:idle(arg_2_1, arg_2_2)
	end

	arg_2_2.navigation_extension:set_max_speed(breed.run_speed)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if not arg_2_2.move_pos then
		local unbox = arg_2_2.move_pos:unbox()

		self:move_to(unbox, arg_2_1, arg_2_2)
	end

	arg_2_2.ready_to_summon = false

	local num_summons = arg_2_2.num_summons

	num_summons = num_summons or 0
	arg_2_2.num_summons = num_summons

	if action_data.sorcerer_type == "tentacle" then
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
	elseif not (action_data.sorcerer_type ~= "vortex" or arg_2_2.vortex_data) then
		self:initialize_vortex_data(arg_2_2, action_data.vortex_template_name)

		arg_2_2.spell = arg_2_2.vortex_data
	end

	if arg_2_2.teleport_health_percent == nil or not arg_2_2.set_teleport_hp then
		local extension = ScriptUnit.extension(arg_2_1, "health_system")

		arg_2_2.health_extension = extension
		arg_2_2.teleport_health_percent = extension:current_health_percent() - action_data.part_hp_lost_to_teleport
		arg_2_2.set_teleport_hp = nil
	end

	arg_2_2.travel_teleport_timer = arg_2_3 + ConflictUtils.random_interval(action_data.teleport_cooldown)
end

local num = math.pi / 4

BTChaosSorcererSkulkApproachAction.initialize_vortex_data = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = VortexTemplates[arg_3_2]
	local full_inner_radius = var_3_0.full_inner_radius
	local num_2 = Vector3.forward() * full_inner_radius
	local tbl = {}

	for i = 1, 8 do
		local var_3_4 = Quaternion(Vector3.up(), num * (i - 1))
		local rotate = Quaternion.rotate(var_3_4, num_2)

		tbl[i] = Vector3Box(rotate)
	end

	arg_3_1.vortex_data = {
		spawn_timer = 3,
		physics_world = World.get_data(arg_3_1.world, "physics_world"),
		vortex_spawn_pos = Vector3Box(),
		vortex_units = {},
		queued_vortex = {},
		radius_check_directions = tbl,
		vortex_template = var_3_0
	}
end

BTChaosSorcererSkulkApproachAction.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local skulk_data = arg_4_2.skulk_data
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local navigation_extension = arg_4_2.navigation_extension

	navigation_extension:set_max_speed(get_default_breed_move_speed)

	if arg_4_4 == "aborted" then
		local is_following_path = navigation_extension:is_following_path()

		if not (not arg_4_2.move_pos and not is_following_path and arg_4_2.move_state ~= "idle") then
			self:start_move_animation(arg_4_1, arg_4_2)
		end
	end

	skulk_data.animation_state = nil
	arg_4_2.action = nil
end

BTChaosSorcererSkulkApproachAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local navigation_extension = arg_5_2.navigation_extension
	local is_following_path = navigation_extension:is_following_path()
	local number_failed_move_attempts = navigation_extension:number_failed_move_attempts()
	local action = arg_5_2.action

	if not self[action.search_func_name](self, arg_5_1, arg_5_2, arg_5_3, arg_5_2.spell) then
		return "done"
	end

	local skulk_data = arg_5_2.skulk_data

	if not (not arg_5_2.move_pos and not is_following_path and arg_5_2.move_state ~= "idle") then
		self:start_move_animation(arg_5_1, arg_5_2)
	end

	if arg_5_2.health_extension:current_health_percent() < arg_5_2.teleport_health_percent then
		local var_5_5 = POSITION_LOOKUP[arg_5_1]
		local num = math.random() * 5 + math.random() * 5 + math.random() * 5
		local num_2 = num * 0.5 + action.preferred_distance
		local num_3 = 5
		local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(arg_5_2.nav_world, var_5_5, num_2, num, num_3)

		if not get_spawn_pos_on_circle then
			arg_5_2.set_teleport_hp = true
			arg_5_2.quick_teleport_exit_pos = Vector3Box(get_spawn_pos_on_circle)
			arg_5_2.quick_teleport = true
			skulk_data.direction = nil
			arg_5_2.move_pos = nil

			return "done"
		end
	elseif arg_5_3 > arg_5_2.travel_teleport_timer then
		local get_skulk_target = self:get_skulk_target(arg_5_1, arg_5_2, true)

		if not get_skulk_target then
			arg_5_2.quick_teleport_exit_pos = Vector3Box(get_skulk_target)
			arg_5_2.quick_teleport = true
			arg_5_2.move_pos = nil

			return "done"
		end
	end

	if not arg_5_2.move_pos then
		if not (self:at_goal(arg_5_1, arg_5_2) or not (number_failed_move_attempts > 0)) then
			arg_5_2.move_pos = nil
		end

		return "running"
	end

	local get_skulk_target_2 = self:get_skulk_target(arg_5_1, arg_5_2)

	if not get_skulk_target_2 then
		self:move_to(get_skulk_target_2, arg_5_1, arg_5_2)

		return "running"
	end

	if arg_5_2.move_state ~= "idle" then
		self:idle(arg_5_1, arg_5_2)
	end

	return "running"
end

BTChaosSorcererSkulkApproachAction.at_goal = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local move_pos = arg_6_2.move_pos

	if not move_pos then
		return false
	end

	local unbox = move_pos:unbox()

	if Vector3.distance_squared(unbox, POSITION_LOOKUP[arg_6_1]) < 0.25 then
		return true
	end
end

BTChaosSorcererSkulkApproachAction.move_to = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	arg_7_3.navigation_extension:move_to(arg_7_1)

	arg_7_3.move_pos = Vector3Box(arg_7_1)
end

BTChaosSorcererSkulkApproachAction.idle = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:anim_event(arg_8_1, arg_8_2, "idle")

	arg_8_2.move_state = "idle"
end

BTChaosSorcererSkulkApproachAction.start_move_animation = function (self, arg_9_1, arg_9_2)
	-- function 9
	local move_animation = arg_9_2.action.move_animation

	self:anim_event(arg_9_1, arg_9_2, move_animation)

	arg_9_2.move_state = "moving"
end

BTChaosSorcererSkulkApproachAction.anim_event = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local skulk_data = arg_10_2.skulk_data

	if skulk_data.animation_state ~= arg_10_3 then
		Managers.state.network:anim_event(arg_10_1, arg_10_3)

		skulk_data.animation_state = arg_10_3
	end
end

local num_2 = 15

BTChaosSorcererSkulkApproachAction.get_skulk_target = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local action = arg_11_2.action
	local nav_world = arg_11_2.nav_world
	local skulk_data = arg_11_2.skulk_data
	local direction = skulk_data.direction
	local target_unit = arg_11_2.target_unit
	local var_11_5 = POSITION_LOOKUP[target_unit]
	local var_11_6 = POSITION_LOOKUP[arg_11_1]
	local target_dist = arg_11_2.target_dist
	local num = var_11_6 - var_11_5
	local normalize = Vector3.normalize(num)
	local preferred_distance = action.preferred_distance

	if not arg_11_2.is_close then
		if target_dist < preferred_distance then
			num = num + normalize * (1 + math.random())
		else
			arg_11_2.is_close = false
			num = num + normalize
		end
	elseif target_dist < action.close_distance then
		arg_11_2.is_close = true
		num = num + normalize
	end

	local var_11_11 = Vector3(0, 0, direction)
	local num_3 = 0.1
	local num_4 = math.pi * math.clamp(num_3 * 20 / target_dist, 0.01, 0.15)

	if not arg_11_3 then
		num_4 = num_4 * 1.5
	end

	for i = 1, num_2 do
		local num_5 = num - normalize * 0.5

		if not arg_11_2.num_summons then
			local num_summons = arg_11_2.num_summons
			local teleport_closer_summon_limit = action.teleport_closer_summon_limit

			teleport_closer_summon_limit = teleport_closer_summon_limit or 3

			if teleport_closer_summon_limit <= num_summons then
				num_5 = Vector3.normalize(var_11_5 - var_11_6) * action.teleport_closer_range
			end
		end

		local num_6 = var_11_5 + Quaternion.rotate(Quaternion(var_11_11, num_4 * i), num_5)
		local find_center_tri = ConflictUtils.find_center_tri(nav_world, num_6)

		if not find_center_tri then
			return find_center_tri
		end
	end

	skulk_data.direction = skulk_data.direction * -1
end

BTChaosSorcererSkulkApproachAction.debug_show_skulk_circle = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local skulk_data = arg_12_2.skulk_data
	local target_unit = arg_12_2.target_unit
	local var_12_2 = POSITION_LOOKUP[target_unit]
	local num = Vector3.up() * 0.2

	QuickDrawer:circle(var_12_2 + num, arg_12_2.target_dist, Vector3.up(), Colors.get("light_green"))
	QuickDrawer:circle(var_12_2 + num, skulk_data.radius, Vector3.up(), Colors.get("light_green"))

	skulk_data.radius = arg_12_2.target_dist
end

BTChaosSorcererSkulkApproachAction.update_dummie = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	return false
end

BTChaosSorcererSkulkApproachAction._update_vortex_search = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if arg_14_3 > arg_14_4.spawn_timer then
		local vortex_units = arg_14_4.vortex_units
		local count = #vortex_units
		local num = 1

		while num <= count do
			local var_14_3 = vortex_units[num]

			if not alive(var_14_3) then
				vortex_units[num] = vortex_units[count]
				vortex_units[count] = nil
				count = count - 1
			else
				num = num + 1
			end
		end

		local action = arg_14_2.action
		local target_dist = arg_14_2.target_dist
		local flag = not target_dist and not (target_dist > action.min_cast_vortex_distance) or target_dist < action.max_cast_vortex_distance

		if arg_14_2.freeze_spell_casting or not (count < arg_14_2.max_vortex_units) or not flag then
			local target_unit = arg_14_2.target_unit
			local node = Unit.node(arg_14_1, "j_head")
			local world_position = Unit.world_position(arg_14_1, node)
			local node_2 = Unit.node(target_unit, "j_head")
			local world_position_2 = Unit.world_position(target_unit, node_2)
			local physics_world = arg_14_4.physics_world

			if not PerceptionUtils.is_position_in_line_of_sight(arg_14_1, world_position, world_position_2, physics_world) then
				arg_14_4.spawn_timer = arg_14_3 + action.vortex_check_timer

				return false
			end

			local _get_vortex_cast_position, var_14_14 = BTChaosSorcererSkulkApproachAction._get_vortex_cast_position(arg_14_1, arg_14_2, arg_14_4, physics_world)

			if not _get_vortex_cast_position then
				arg_14_4.spawn_timer = arg_14_3 + action.vortex_check_timer

				return false
			end

			arg_14_2.ready_to_summon = true
			arg_14_2.num_summons = arg_14_2.num_summons + 1

			arg_14_4.vortex_spawn_pos:store(_get_vortex_cast_position)

			arg_14_4.vortex_spawn_radius = var_14_14
			arg_14_4.spawn_timer = arg_14_3 + action.vortex_spawn_timer

			return true
		else
			arg_14_4.spawn_timer = arg_14_3 + action.vortex_check_timer
		end
	end
end

BTChaosSorcererSkulkApproachAction._get_vortex_cast_position = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local action = arg_15_1.action
	local alloc_table = FrameTable.alloc_table()
	local target_dist = arg_15_1.target_dist
	local traverse_logic = arg_15_1.navigation_extension:traverse_logic()

	alloc_table.nav_world = arg_15_1.nav_world
	alloc_table.physics_world = arg_15_3
	alloc_table.from_unit = arg_15_0
	alloc_table.from_node_name = "j_head"
	alloc_table.to_unit = arg_15_1.target_unit
	alloc_table.to_node_name = "j_head"
	alloc_table.min_distance = action.min_player_vortex_distance
	alloc_table.max_distance = math.min(target_dist, action.max_player_vortex_distance)
	alloc_table.max_tries = 3
	alloc_table.outside_goal_tries = 3
	alloc_table.above = 15
	alloc_table.below = 15
	alloc_table.min_angle_step = 4
	alloc_table.max_angle_step = 8
	alloc_table.traverse_logic = traverse_logic
	alloc_table.min_wanted_radius = VortexTemplates[action.vortex_template_name].min_inner_radius
	alloc_table.radius_check_directions = arg_15_2.radius_check_directions

	local pick_visible_outside_goal, var_15_5 = LocomotionUtils.pick_visible_outside_goal(alloc_table)

	return pick_visible_outside_goal, var_15_5
end

local num_3 = 7
local num_4 = 20
local num_5 = 1.5
local flag = false
local flag_2 = false

BTChaosSorcererSkulkApproachAction.update_portal_search = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	if not (not arg_16_2.target_unit and alive(arg_16_2.portal_unit)) then
		if not arg_16_4.portal_search_active then
			local var_16_0 = POSITION_LOOKUP[arg_16_2.target_unit]
			local try_next_portal_location = BTChaosSorcererSkulkApproachAction.try_next_portal_location(arg_16_4, arg_16_2.nav_world, var_16_0)

			if try_next_portal_location == "success" then
				arg_16_2.ready_to_summon = true
				arg_16_4.portal_search_active = false

				return "done"
			elseif try_next_portal_location == "failed" then
				arg_16_4.portal_search_timer = 0
				arg_16_4.portal_search_active = false
				arg_16_4.portal_search_timer = arg_16_3 + 1
			end
		elseif not (not (arg_16_3 > arg_16_4.portal_search_timer) or arg_16_2.portal_unit) then
			local var_16_2 = POSITION_LOOKUP[arg_16_2.target_unit]
			local get_portal_location_list = BTChaosSorcererSkulkApproachAction.get_portal_location_list(arg_16_4, var_16_2)
			local flag

			flag = not get_portal_location_list and 0 and arg_16_4.search_counter + 1
			arg_16_4.search_counter = flag
			arg_16_4.portal_search_active = get_portal_location_list
			arg_16_4.portal_search_timer = arg_16_3 + 1
		end
	end
end

BTChaosSorcererSkulkApproachAction.get_portal_location_list = function (self, arg_17_1)
	-- function 17
	if math.random() <= self.chance_to_look_for_wall_spawn then
		if not BTChaosSorcererSkulkApproachAction.prepare_wall_search(self, arg_17_1) then
			self.placement = "wall"

			return true
		else
			self.floor_search_count = 0
			self.placement = "floor"

			return true
		end
	end

	self.floor_search_count = 0
	self.placement = "floor"

	return true
end

BTChaosSorcererSkulkApproachAction.prepare_wall_search = function (self, arg_18_1)
	-- function 18
	local cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase
	local num = 30
	local cover_units = self.cover_units
	local query = Broadphase.query(cover_points_broadphase, arg_18_1, num, cover_units)

	if query <= 0 then
		return false
	end

	self.num_cover_points = query
	self.cover_point_index = 1
	self.placement = "wall"

	if not flag_2 then
		local local_rotation = Unit.local_rotation
		local local_position = Unit.local_position
		local var_18_6 = Color(255, 255, 0)
		local var_18_7 = Color(70, 255, 0)
		local var_18_8 = Vector3(0, 0, 1)

		for i = 1, query do
			local var_18_9 = cover_units[i]
			local var_18_10 = local_position(var_18_9, 0)
			local num_2 = var_18_10 + var_18_8
			local var_18_12 = local_rotation(var_18_9, 0)
			local forward = Quaternion.forward(var_18_12)
			local num_3 = -Quaternion.right(var_18_12) * 0.85
			local num_4 = -Quaternion.up(var_18_12) * 0.85

			QuickDrawerStay:sphere(var_18_10, 0.15, var_18_7)
			QuickDrawerStay:sphere(num_2, 0.1, var_18_6)
			QuickDrawerStay:line(num_2, num_2 + forward, var_18_6)
			QuickDrawerStay:line(num_2 + num_3, num_2 + num_3 + forward, var_18_6)
			QuickDrawerStay:line(num_2 - num_3, num_2 - num_3 + forward, var_18_6)
			QuickDrawerStay:line(num_2 + num_4, num_2 + num_4 + forward, var_18_6)
			QuickDrawerStay:line(num_2 - num_4, num_2 - num_4 + forward, var_18_6)
		end
	end

	return true
end

local function fn(arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = Vector3(arg_19_1 + (math.random() - 0.5) * arg_19_2, 0, 1)

	return arg_19_0 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_19_0)
end

BTChaosSorcererSkulkApproachAction.evaluate_floor = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local var_20_0 = fn(arg_20_2, num_4, 10)
	local var_20_1
	local var_20_2
	local var_20_3
	local var_20_4
	local var_20_5

	if not var_20_0 then
		local raycast

		raycast, var_20_1 = GwNavQueries.raycast(arg_20_1, arg_20_2, var_20_0)
		var_20_2 = GwNavQueries.inside_position_from_outside_position(arg_20_1, var_20_1, 1, 1, 5, num_5)

		if not var_20_2 then
			local num = var_20_2 - arg_20_2

			if Vector3.length(num) > num_3 then
				local get_seed_triangle = GwNavTraversal.get_seed_triangle(arg_20_1, var_20_2)
				local get_triangle_vertices, var_20_10, var_20_11 = GwNavTraversal.get_triangle_vertices(arg_20_1, get_seed_triangle)

				var_20_4 = Vector3.normalize(Vector3.cross(var_20_10 - get_triangle_vertices, var_20_11 - get_triangle_vertices))

				local look = Quaternion.look(var_20_4, Vector3.normalize(num))

				if not self.portal_spawn_pos then
					self.portal_spawn_pos:store(var_20_2)
					self.portal_spawn_rot:store(look)
				end

				self.portal_spawn_type = "floor"
				self.portal_search_active = false
				var_20_3 = "success"

				Debug.sticky_text("Found floor pos")
			end
		end
	end

	if not flag and not var_20_0 then
		QuickDrawer:sphere(var_20_0, 0.25, Color(0, 200, 200))
		QuickDrawer:line(var_20_0, arg_20_2, Color(0, 200, 125))

		if not var_20_1 then
			QuickDrawerStay:sphere(var_20_1, 0.5, Color(20, 200, 70))
		end

		if not var_20_3 then
			QuickDrawer:line(var_20_1, var_20_2, Color(20, 200, 70))
			QuickDrawer:sphere(var_20_2, num_5, Color(20, 200, 70))
			QuickDrawer:line(var_20_2, var_20_2 + var_20_4, Color(20, 200, 70))
		else
			Debug.sticky_text("no random floor pick pos found")
		end
	end

	return var_20_3
end

local num_6 = 25

BTChaosSorcererSkulkApproachAction.evaluate_wall = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local cover_point_index = self.cover_point_index
	local num_cover_points = self.num_cover_points
	local num = cover_point_index + arg_21_3
	local cover_units = self.cover_units
	local local_rotation = Unit.local_rotation
	local local_position = Unit.local_position

	while cover_point_index < num do
		if num_cover_points < cover_point_index then
			self.portal_search_active = false

			return "failed"
		end

		local var_21_6 = cover_units[cover_point_index]
		local var_21_7 = local_position(var_21_6, 0)

		if Vector3.distance_squared(var_21_7, arg_21_2) > num_6 then
			local var_21_8 = local_rotation(var_21_6, 0)
			local forward = Quaternion.forward(var_21_8)
			local flag = true

			if not flag then
				local immediate_raycast, var_21_12, var_21_13, var_21_14 = PhysicsWorld.immediate_raycast(self.physics_world, var_21_7 + Vector3(0, 0, 1), forward, 1.5, "closest", "collision_filter", "filter_ai_mover")

				if not immediate_raycast then
					if not self.portal_spawn_pos then
						local look = Quaternion.look(var_21_14, Vector3.up())

						self.portal_spawn_pos:store(var_21_12)
						self.portal_spawn_rot:store(look)
					end

					self.portal_spawn_type = "wall"
					self.portal_search_active = false

					if not flag_2 then
						QuickDrawerStay:cylinder(var_21_12, var_21_12 + var_21_14, num_5, Color(220, 60, 70), 10)
						QuickDrawerStay:sphere(var_21_12, num_5 * 0.5, Color(220, 30, 30))
					end

					return "success"
				end
			end
		end

		cover_point_index = cover_point_index + 1
	end

	self.cover_point_index = cover_point_index
end

BTChaosSorcererSkulkApproachAction.try_next_portal_location = function (self, arg_22_1, arg_22_2)
	-- function 22
	local placement = self.placement
	local triangle_from_position, var_22_2 = GwNavQueries.triangle_from_position(arg_22_1, arg_22_2, 3, 3)

	if not triangle_from_position then
		arg_22_2 = Vector3.copy(arg_22_2)

		Vector3.set_z(arg_22_2, var_22_2)
	end

	if placement == "floor" then
		local num = 3

		for i = 1, num do
			local evaluate_floor = BTChaosSorcererSkulkApproachAction.evaluate_floor(self, arg_22_1, arg_22_2)

			if not evaluate_floor then
				return evaluate_floor
			end
		end

		self.floor_search_count = self.floor_search_count + num

		if self.floor_search_count > 30 then
			return "failed"
		end
	elseif placement == "wall" then
		local num_2 = 3

		return BTChaosSorcererSkulkApproachAction.evaluate_wall(self, arg_22_1, arg_22_2, num_2)
	end
end
