-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_drag_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterDragAction = class(BTPackMasterDragAction, BTNode)

local num = 10
local num_2 = 1
local num_3 = 2
local script_data = script_data

BTPackMasterDragAction.init = function (self, ...)
	-- function 1
	BTPackMasterDragAction.super.init(self, ...)

	self.navigation_group_manager = Managers.state.conflict.navigation_group_manager
end

BTPackMasterDragAction.name = "BTPackMasterDragAction"

BTPackMasterDragAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.active_node = BTPackMasterDragAction
	arg_2_2.drag_check_radius = 4
	arg_2_2.drag_check_index = 1
	arg_2_2.drag_check_time = 0
	arg_2_2.threatened = false
	arg_2_2.find_destination = true
	arg_2_2.hoist_time = arg_2_3 + action_data.force_hoist_time
	arg_2_2.hoist_pos = nil
	arg_2_2.time_to_damage = arg_2_3 + action_data.time_to_damage

	StatusUtils.set_grabbed_by_pack_master_network("pack_master_dragging", arg_2_2.drag_target_unit, true, arg_2_1)

	local walk_speed = arg_2_2.breed.walk_speed
	local navigation_extension = arg_2_2.navigation_extension
	local var_2_3 = navigation_extension
	local set_max_speed = navigation_extension.set_max_speed
	local override_movement_speed = action_data.override_movement_speed

	override_movement_speed = override_movement_speed or walk_speed

	set_max_speed(var_2_3, override_movement_speed)
	AiUtils.allow_smart_object_layers(navigation_extension, false)

	arg_2_2.destination_test_astar = GwNavAStar.create()
	arg_2_2.packmaster_destinations = {}

	for i = 1, num do
		arg_2_2.packmaster_destinations[i] = {}
	end

	arg_2_2.last_path_direction = Vector3Box(Vector3.normalize(POSITION_LOOKUP[arg_2_1] - POSITION_LOOKUP[arg_2_2.drag_target_unit]))

	local find_escape_destination, var_2_7 = self:find_escape_destination(arg_2_1, arg_2_2)

	if not find_escape_destination then
		navigation_extension:move_to(var_2_7)
	end
end

BTPackMasterDragAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.drag_check_radius = nil
	arg_3_2.drag_check_index = nil
	arg_3_2.drag_check_time = nil
	arg_3_2.threatened = nil
	arg_3_2.find_destination = nil

	if arg_3_4 ~= "done" then
		if not Unit.alive(arg_3_2.drag_target_unit) then
			StatusUtils.set_grabbed_by_pack_master_network("pack_master_dragging", arg_3_2.drag_target_unit, false, arg_3_1)
		end

		arg_3_2.drag_target_unit = nil
		arg_3_2.target_unit = nil

		AiUtils.show_polearm(arg_3_1, true)
	end

	arg_3_2.packmaster_destinations = nil
	arg_3_2.destination_test_index = nil
	arg_3_2.test_destinations = nil
	arg_3_2.test_next_destination = nil
	arg_3_2.last_path_direction = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local navigation_extension = arg_3_2.navigation_extension

	navigation_extension:set_max_speed(get_default_breed_move_speed)
	AiUtils.allow_smart_object_layers(navigation_extension, true)

	arg_3_2.attack_cooldown = arg_3_3 + arg_3_2.action.cooldown

	GwNavAStar.destroy(arg_3_2.destination_test_astar)
end

local function fn(arg_4_0, arg_4_1)
	-- function 4
	local triangle_from_position, var_4_1 = GwNavQueries.triangle_from_position(arg_4_0, arg_4_1, 0.5, 0.5)

	if not triangle_from_position then
		return Vector3(arg_4_1.x, arg_4_1.y, var_4_1)
	end
end

local num_4 = math.pi / 9

BTPackMasterDragAction.find_hoist_pos = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_2]
	local var_5_1 = POSITION_LOOKUP[arg_5_3.drag_target_unit]
	local num = Vector3.normalize(var_5_0 - var_5_1) * 2.26
	local var_5_3 = fn(arg_5_1, var_5_1 + num)

	if not var_5_3 then
		return var_5_3
	end

	local num_2 = 0

	for i = 1, 6 do
		num_2 = num_2 + num_4

		local rotate = Quaternion.rotate(Quaternion(Vector3.up(), num_2), num)

		var_5_3 = fn(arg_5_1, var_5_1 + rotate)

		if not var_5_3 then
			break
		end

		local rotate_2 = Quaternion.rotate(Quaternion(Vector3.up(), -num_2), num)

		var_5_3 = fn(arg_5_1, var_5_1 + rotate_2)

		if not var_5_3 then
			break
		end
	end

	return var_5_3
end

BTPackMasterDragAction.can_hoist = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local safe_hoist_max_height_differance = arg_6_2.action.safe_hoist_max_height_differance
	local var_6_1 = POSITION_LOOKUP[arg_6_1]
	local var_6_2 = POSITION_LOOKUP[arg_6_2.drag_target_unit]

	return safe_hoist_max_height_differance >= math.abs(var_6_2.z - var_6_1.z)
end

BTPackMasterDragAction.safe_to_hoist = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = POSITION_LOOKUP[arg_7_1]
	local distance_squared = Vector3.distance_squared
	local side = arg_7_2.side
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local safe_hoist_dist_squared_from_humans = arg_7_2.action.safe_hoist_dist_squared_from_humans

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not (arg_7_2.drag_target_unit == v or ScriptUnit.extension(v, "status_system"):is_disabled()) then
			local var_7_6 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]

			if safe_hoist_dist_squared_from_humans > distance_squared(var_7_6, var_7_0) then
				return false
			end
		end
	end

	return true
end

BTPackMasterDragAction.run = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local drag_target_unit = arg_8_2.drag_target_unit

	if not Unit.alive(drag_target_unit) then
		return "failed"
	end

	if ConflictUtils.average_player_position(drag_target_unit) == nil then
		return "failed"
	end

	local extension = ScriptUnit.extension(drag_target_unit, "status_system")

	if not extension:is_grabbed_by_pack_master() then
		return "failed"
	end

	if not extension:is_dead() then
		return "failed"
	end

	if not extension:is_knocked_down() then
		arg_8_2.hoist_time = 0
	end

	local var_8_2 = POSITION_LOOKUP[arg_8_1]
	local nav_world = arg_8_2.nav_world

	if arg_8_3 > arg_8_2.hoist_time then
		if not self:can_hoist(arg_8_1, arg_8_2) and not self:safe_to_hoist(arg_8_1, arg_8_2) then
			if not arg_8_2.hoist_pos then
				if Vector3.distance_squared(var_8_2, arg_8_2.hoist_pos:unbox()) < 0.1 then
					return "done"
				end

				return "running"
			else
				local find_hoist_pos = self:find_hoist_pos(nav_world, arg_8_1, arg_8_2)

				if not find_hoist_pos then
					arg_8_2.hoist_pos = Vector3Box(find_hoist_pos)

					arg_8_2.navigation_extension:move_to(find_hoist_pos)
				end
			end
		else
			arg_8_2.hoist_pos = nil
		end
	end

	local locomotion_extension = arg_8_2.locomotion_extension
	local flat = Vector3.flat(-locomotion_extension:current_velocity())
	local look = Quaternion.look(flat, Vector3(0, 0, 1))

	arg_8_2.locomotion_extension:set_wanted_rotation(look)

	if arg_8_3 > arg_8_2.time_to_damage then
		local action = arg_8_2.action

		DamageUtils.add_damage_network(drag_target_unit, arg_8_1, action.damage_amount, action.hit_zone_name, action.damage_type, nil, Vector3.up(), arg_8_2.breed.name, nil, nil, nil, action.hit_react_type, nil, nil, nil, nil, nil, nil, 1)

		arg_8_2.time_to_damage = arg_8_3 + action.time_to_damage
	end

	if not arg_8_2.test_destinations and self:test_destinations(arg_8_1, arg_8_2) then
		return "running"
	end

	if not (not arg_8_2.navigation_extension:has_reached_destination(2) and arg_8_2.test_destinations) then
		arg_8_2.find_destination = true
	end

	local flag = false

	if arg_8_3 > arg_8_2.drag_check_time then
		arg_8_2.drag_check_time = arg_8_3 + 1

		if not arg_8_2.threatened then
			arg_8_2.threatened = find_position_to_avoid(arg_8_1, arg_8_2)
			flag = true

			if not arg_8_2.threatened then
				arg_8_2.find_destination = true
			end
		end
	end

	if not arg_8_2.find_destination then
		return "running"
	end

	if not flag then
		arg_8_2.threatened = find_position_to_avoid(arg_8_1, arg_8_2)
	end

	self:find_destinations(arg_8_1, arg_8_2, arg_8_3, arg_8_4)

	arg_8_2.find_destination = false

	return "running"
end

BTPackMasterDragAction.find_destinations = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local var_9_0 = POSITION_LOOKUP[arg_9_1]
	local flag = false
	local flag_2 = false
	local unbox = arg_9_2.threat_pos:unbox()
	local normalize = Vector3.normalize(var_9_0 - unbox)
	local threatened = arg_9_2.threatened

	if not (threatened or self:find_valid_interest_points(var_9_0, arg_9_2.packmaster_destinations, normalize) or self:find_nav_group_neighbour(arg_9_2, var_9_0, normalize, unbox)) then
		threatened = true
	end

	if not threatened then
		self:find_valid_covers(var_9_0, arg_9_2.packmaster_destinations, normalize, unbox)
	end

	self:setup_destination_test(arg_9_1, arg_9_2)

	if not script_data.debug_ai_movement then
		QuickDrawerStay:vector(var_9_0, arg_9_2.last_path_direction:unbox() * 2, Colors.get("purple"))

		local QuickDrawerStay = QuickDrawerStay
		local var_9_7 = QuickDrawerStay
		local sphere = QuickDrawerStay.sphere
		local num = var_9_0 + Vector3.up() * 1.7
		local num_2 = 0.5
		local get

		if not arg_9_2.threatened then
			get = Colors.get("red")

			if not get then
				-- Nothing
			end
		end

		get = Colors.get("yellow")

		::label_9_0::

		sphere(var_9_7, num, num_2, get)
	end
end

function find_position_to_avoid(arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local safe_hoist_dist_squared_from_humans = arg_10_1.action.safe_hoist_dist_squared_from_humans
	local var_10_1 = POSITION_LOOKUP[arg_10_0]
	local var_10_2 = Vector3(0, 0, 0)
	local num = 0
	local side = arg_10_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for k, v in pairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not (arg_10_1.drag_target_unit == v or ScriptUnit.extension(v, "status_system"):is_disabled()) then
			num = num + 1

			local var_10_7 = ENEMY_PLAYER_AND_BOT_POSITIONS[k]
			local distance_squared = Vector3.distance_squared(var_10_7, var_10_1)

			if not (not (distance_squared > 0) or not (distance_squared < safe_hoist_dist_squared_from_humans)) then
				local num_2 = var_10_7 - var_10_1

				var_10_2 = var_10_2 - Vector3.normalize(num_2) / math.sqrt(distance_squared)
			end
		end
	end

	arg_10_1.threat_pos = Vector3Box(var_10_1 - var_10_2)

	if not script_data.debug_ai_movement then
		QuickDrawer:sphere(var_10_1 - var_10_2 * 4, 1, Color(0, 255, 0))
	end

	return num > 0
end

local function fn_2(self, arg_11_1)
	-- function 11
	return self[num_3] > arg_11_1[num_3]
end

BTPackMasterDragAction.find_valid_covers = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local local_position = Unit.local_position
	local distance_squared = Vector3.distance_squared
	local distance = Vector3.distance
	local normalize = Vector3.normalize
	local dot = Vector3.dot
	local max = math.max
	local alloc_table = FrameTable.alloc_table()
	local var_12_7 = distance(arg_12_4, arg_12_1)
	local num_2 = 19
	local num_3 = 3
	local cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase
	local query = Broadphase.query(cover_points_broadphase, arg_12_1, num_2, alloc_table)
	local num_4 = num_3 * num_3
	local num_5 = num_2 * num_2

	if not script_data.debug_ai_movement then
		QuickDrawerStay:sphere(arg_12_4, 2, Colors.get("deep_sky_blue"))
	end

	local num_6 = 1

	for i = 1, query do
		local var_12_15 = alloc_table[i]
		local var_12_16 = local_position(var_12_15, 0)
		local var_12_17 = distance_squared(var_12_16, arg_12_1)

		if not (not (num_4 <= var_12_17) or not (var_12_17 < num_5)) then
			local local_rotation = Unit.local_rotation(var_12_15, 0)
			local num_7 = var_12_16 - arg_12_1
			local var_12_20 = normalize(var_12_16 - arg_12_4)
			local var_12_21 = dot(normalize(num_7), arg_12_3)
			local var_12_22 = dot(Quaternion.forward(local_rotation), -var_12_20)
			local var_12_23 = distance(var_12_16, arg_12_4)
			local var_12_24 = max(0, var_12_21)
			local num_8 = max(0, var_12_22) + 1
			local num_9 = var_12_23 * var_12_24 * num_8

			if not script_data.debug_ai_movement then
				local var_12_27 = Color(255, 255 * max(-var_12_21, 0), 255 * max(var_12_21, 0), 255 * max(0, var_12_22))

				QuickDrawerStay:sphere(var_12_16, 1, var_12_27)
				QuickDrawerStay:line(var_12_16 + Vector3(0, 0, 1), var_12_16 + Quaternion.forward(local_rotation) * 2 + Vector3(0, 0, 1), var_12_27)
			end

			arg_12_2[num_6][1] = Vector3Box(var_12_16)
			arg_12_2[num_6][2] = num_9
			num_6 = num_6 + 1

			if num_6 > num then
				break
			end
		end
	end

	for j = num_6, num do
		arg_12_2[j][2] = -math.huge
	end
end

BTPackMasterDragAction.find_valid_interest_points = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local tbl = {}
	local num_2 = 19
	local num_3 = 5
	local broadphase = Managers.state.entity:system("ai_interest_point_system").broadphase
	local query = Broadphase.query(broadphase, arg_13_1, num_2, tbl)
	local local_position = Unit.local_position
	local distance = Vector3.distance
	local normalize = Vector3.normalize
	local dot = Vector3.dot
	local num_4 = 1

	for i = 1, query do
		local var_13_10 = tbl[i]

		if not (not Unit.alive(var_13_10) and not Unit.get_data(var_13_10, "interest_point", "enabled") and not (ScriptUnit.extension(var_13_10, "ai_interest_point_system").num_claimed_points > 0)) then
			local var_13_11 = local_position(var_13_10, 0)
			local var_13_12 = distance(var_13_11, arg_13_1)

			if not (not (num_3 < var_13_12) or not (var_13_12 < num_2)) then
				local num_5 = var_13_11 - arg_13_1
				local num_6 = dot(normalize(num_5), arg_13_3) * 2 + 2
				local num_7 = (num_2 - var_13_12) * num_6

				if not script_data.debug_ai_movement then
					QuickDrawerStay:sphere(var_13_11, 1, Colors.get("pink"))
				end

				arg_13_2[num_4][1] = Vector3Box(var_13_11)
				arg_13_2[num_4][2] = num_7
				num_4 = num_4 + 1

				if num_4 > num then
					break
				end
			end
		end
	end

	for j = num_4, num do
		arg_13_2[j][2] = -math.huge
	end

	return num_4 > 1
end

BTPackMasterDragAction.find_nav_group_neighbour = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local packmaster_destinations = arg_14_1.packmaster_destinations
	local get_group_from_position = Managers.state.conflict.navigation_group_manager:get_group_from_position(arg_14_2)

	if not get_group_from_position then
		print("Packmaster was not on nav_group")

		if not script_data.debug_ai_movement then
			QuickDrawerStay:sphere(arg_14_2, 0.5, Colors.get("red"))
		end

		return false
	end

	local get_group_neighbours = get_group_from_position:get_group_neighbours()
	local num_4 = 1

	for k, v in pairs(get_group_neighbours) do
		local unbox = k:get_group_center():unbox()
		local num_5 = unbox - arg_14_2
		local normalize = Vector3.normalize(num_5)
		local dot = Vector3.dot(normalize, arg_14_3)
		local max = math.max(0, dot)

		if not script_data.debug_ai_movement then
			local QuickDrawerStay = QuickDrawerStay
			local var_14_10 = QuickDrawerStay
			local sphere = QuickDrawerStay.sphere
			local var_14_12 = unbox
			local num_6 = 3
			local get

			if dot > -0.25 then
				get = Colors.get("yellow")

				if not get then
					-- Nothing
				end
			end

			get = Colors.get("red")

			::label_14_0::

			sphere(var_14_10, var_14_12, num_6, get)

			local QuickDrawerStay_2 = QuickDrawerStay
			local var_14_16 = QuickDrawerStay_2
			local line = QuickDrawerStay_2.line
			local var_14_18 = unbox
			local var_14_19 = arg_14_2
			local get_2

			if dot > -0.25 then
				get_2 = Colors.get("yellow")

				if not get_2 then
					-- Nothing
				end
			end

			get_2 = Colors.get("red")

			::label_14_1::

			line(var_14_16, var_14_18, var_14_19, get_2)
		end

		if dot > -0.25 then
			local num_7 = Vector3.distance_squared(arg_14_4, unbox) * max
			local triangle_from_position, var_14_23 = GwNavQueries.triangle_from_position(arg_14_1.nav_world, unbox, 1.5, 1.5)

			if not triangle_from_position then
				unbox.z = var_14_23
			else
				local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(arg_14_1.nav_world, unbox, 4, 4, 2.5, 0.38)

				if not inside_position_from_outside_position then
					unbox = inside_position_from_outside_position
				elseif not script_data.debug_ai_movement then
					QuickDrawerStay:sphere(unbox, 2, (Colors.get("purple")))
					QuickDrawerStay:sphere(unbox, 4, (Colors.get("purple")))
				end
			end

			packmaster_destinations[num_4][num_2] = Vector3Box(unbox)
			packmaster_destinations[num_4][num_3] = num_7
			num_4 = num_4 + 1

			if num_4 > num then
				break
			end
		end
	end

	for k_2 = num_4, num do
		packmaster_destinations[k_2][num_3] = -math.huge
	end

	return num_4 > 1
end

BTPackMasterDragAction.find_escape_destination = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local unbox = arg_15_2.last_path_direction:unbox()
	local num = POSITION_LOOKUP[arg_15_1] + Vector3(0, 0, 0.5)
	local flag = false
	local var_15_3
	local atan2 = math.atan2(unbox.y, unbox.x, 0)
	local num_2 = 5
	local num_3 = math.pi / (num_2 - 1)
	local traverse_logic = arg_15_2.navigation_extension:traverse_logic()
	local nav_world = arg_15_2.nav_world

	for i = 1, num_2 do
		local num_4 = atan2 + math.ceil((i - 1) * 0.5) * (i % 2 * 2 - 1) * num_3
		local var_15_10 = Vector3(math.cos(num_4), math.sin(num_4), 0)
		local num_5 = num + var_15_10 * 3
		local triangle_from_position, var_15_13 = GwNavQueries.triangle_from_position(nav_world, num_5, 0.5, 1)

		if not triangle_from_position and not GwNavQueries.raycango(nav_world, num, num_5, traverse_logic) then
			num_5.z = var_15_13
			var_15_3 = num_5

			local num_6 = num + var_15_10 * 5
			local triangle_from_position_2, var_15_16 = GwNavQueries.triangle_from_position(nav_world, num_6, 0.5, 1)

			if not triangle_from_position_2 and not GwNavQueries.raycango(nav_world, num, num_6, traverse_logic) then
				num_6.z = var_15_16
				var_15_3 = num_6

				if not script_data.debug_ai_movement then
					QuickDrawerStay:vector(num, num_6 - num, Colors.get("gold"))
				end
			end

			flag = true

			break
		end

		if not script_data.debug_ai_movement then
			QuickDrawerStay:vector(num, num_5 - num, Colors.get("orange"))
		end
	end

	return flag, var_15_3
end

BTPackMasterDragAction.setup_destination_test = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	arg_16_2.destination_test_index = 0
	arg_16_2.test_destinations = true
	arg_16_2.test_next_destination = true
	arg_16_2.best_destination = nil
	arg_16_2.best_destination_score = -math.huge

	table.sort(arg_16_2.packmaster_destinations, fn_2)

	local normalize = Vector3.normalize(POSITION_LOOKUP[arg_16_1] - POSITION_LOOKUP[arg_16_2.drag_target_unit])

	arg_16_2.last_path_direction = Vector3Box(normalize)
end

BTPackMasterDragAction.test_destinations = function (self, arg_17_1, arg_17_2)
	-- function 17
	local destination_test_astar = arg_17_2.destination_test_astar
	local nav_world = arg_17_2.nav_world
	local packmaster_destinations = arg_17_2.packmaster_destinations
	local destination_test_index = arg_17_2.destination_test_index
	local test_next_destination = arg_17_2.test_next_destination
	local var_17_5 = POSITION_LOOKUP[arg_17_1]
	local unbox = Vector3Box.unbox(arg_17_2.last_path_direction)
	local navigation_extension = arg_17_2.navigation_extension
	local traverse_logic = navigation_extension:traverse_logic()

	if not test_next_destination then
		destination_test_index = destination_test_index + 1
		arg_17_2.destination_test_index = destination_test_index

		if not (not packmaster_destinations[destination_test_index] and packmaster_destinations[destination_test_index][num_3] == -math.huge) then
			local unbox_2 = packmaster_destinations[destination_test_index][1]:unbox()

			GwNavAStar.start(destination_test_astar, nav_world, var_17_5, unbox_2, traverse_logic)
		else
			arg_17_2.test_destinations = false
			arg_17_2.test_next_destination = false

			local best_destination_score = arg_17_2.best_destination_score
			local flag = true

			if best_destination_score < 0.01 then
				local var_17_12
				local var_17_13

				flag, var_17_13 = self:find_escape_destination(arg_17_1, arg_17_2)

				if not flag then
					arg_17_2.best_destination = Vector3Box(var_17_13)
				end
			end

			if not flag then
				return false
			end

			navigation_extension:move_to(arg_17_2.best_destination:unbox())

			return true
		end
	end

	if not GwNavAStar.processing_finished(destination_test_astar) then
		if not GwNavAStar.path_found(destination_test_astar) then
			local path_distance = GwNavAStar.path_distance(destination_test_astar)

			fassert(path_distance > 0, "Path length is 0, this will cause div by 0")

			local num = path_distance * path_distance
			local unbox_3 = packmaster_destinations[destination_test_index][1]:unbox()
			local var_17_17 = packmaster_destinations[destination_test_index][2]
			local num_2 = unbox_3 - var_17_5
			local length_squared = Vector3.length_squared(num_2)
			local num_4 = GwNavAStar.node_at_index(destination_test_astar, 2) - GwNavAStar.node_at_index(destination_test_astar, 1)
			local normalize = Vector3.normalize(num_4)
			local num_5 = Vector3.dot(unbox, normalize) * 0.75 + 0.25
			local num_6 = length_squared / num
			local num_7 = var_17_17 * (num_6 * num_5)

			packmaster_destinations[destination_test_index][2] = num_7

			local flag_2 = not (num_6 > 0.4444444444444444) or num_5 > 0

			if not flag_2 then
				for i = 2, GwNavAStar.node_count(destination_test_astar) do
					local node_at_index = GwNavAStar.node_at_index(destination_test_astar, i - 1)
					local node_at_index_2 = GwNavAStar.node_at_index(destination_test_astar, i)

					if not GwNavQueries.raycango(nav_world, node_at_index, node_at_index_2, traverse_logic) then
						flag_2 = false

						break
					end
				end
			end

			if not flag_2 then
				arg_17_2.test_destinations = false
				arg_17_2.test_next_destination = false

				navigation_extension:move_to(unbox_3)
			else
				arg_17_2.test_next_destination = true

				if num_7 > arg_17_2.best_destination_score then
					arg_17_2.best_destination_score = num_7
					arg_17_2.best_destination = Vector3Box(unbox_3)
				end
			end

			if not script_data.debug_ai_movement then
				local node_count = GwNavAStar.node_count(destination_test_astar)

				for j = 1, node_count do
					local node_at_index_3 = GwNavAStar.node_at_index(destination_test_astar, j)
					local QuickDrawerStay = QuickDrawerStay
					local var_17_31 = QuickDrawerStay
					local sphere = QuickDrawerStay.sphere
					local var_17_33 = node_at_index_3
					local num_8 = 0.1
					local get

					if not flag_2 then
						get = Colors.get("yellow")

						if not get then
							-- Nothing
						end
					end

					get = Colors.get("red")

					::label_17_0::

					sphere(var_17_31, var_17_33, num_8, get)

					local node_at_index_4 = GwNavAStar.node_at_index(destination_test_astar, j + 1)

					if not node_at_index_4 then
						local QuickDrawerStay_2 = QuickDrawerStay
						local var_17_38 = QuickDrawerStay_2
						local line = QuickDrawerStay_2.line
						local var_17_40 = node_at_index_3
						local var_17_41 = node_at_index_4
						local get_2

						if not flag_2 then
							get_2 = Colors.get("yellow")

							if not get_2 then
								-- Nothing
							end
						end

						get_2 = Colors.get("red")

						::label_17_1::

						line(var_17_38, var_17_40, var_17_41, get_2)
					end
				end
			end
		else
			arg_17_2.test_next_destination = true
		end
	else
		arg_17_2.test_next_destination = false
	end

	return true
end
