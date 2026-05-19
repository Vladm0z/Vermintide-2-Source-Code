-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_drag_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterDragAction = class(BTPackMasterDragAction, BTNode)

local var_0_0 = 10
local var_0_1 = 1
local var_0_2 = 2
local var_0_3 = script_data

function BTPackMasterDragAction.init(arg_1_0, ...)
	BTPackMasterDragAction.super.init(arg_1_0, ...)

	arg_1_0.navigation_group_manager = Managers.state.conflict.navigation_group_manager
end

BTPackMasterDragAction.name = "BTPackMasterDragAction"

function BTPackMasterDragAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.active_node = BTPackMasterDragAction
	arg_2_2.drag_check_radius = 4
	arg_2_2.drag_check_index = 1
	arg_2_2.drag_check_time = 0
	arg_2_2.threatened = false
	arg_2_2.find_destination = true
	arg_2_2.hoist_time = arg_2_3 + var_2_0.force_hoist_time
	arg_2_2.hoist_pos = nil
	arg_2_2.time_to_damage = arg_2_3 + var_2_0.time_to_damage

	StatusUtils.set_grabbed_by_pack_master_network("pack_master_dragging", arg_2_2.drag_target_unit, true, arg_2_1)

	local var_2_1 = arg_2_2.breed.walk_speed
	local var_2_2 = arg_2_2.navigation_extension

	var_2_2:set_max_speed(var_2_0.override_movement_speed or var_2_1)
	AiUtils.allow_smart_object_layers(var_2_2, false)

	arg_2_2.destination_test_astar = GwNavAStar.create()
	arg_2_2.packmaster_destinations = {}

	for iter_2_0 = 1, var_0_0 do
		arg_2_2.packmaster_destinations[iter_2_0] = {}
	end

	arg_2_2.last_path_direction = Vector3Box(Vector3.normalize(POSITION_LOOKUP[arg_2_1] - POSITION_LOOKUP[arg_2_2.drag_target_unit]))

	local var_2_3, var_2_4 = arg_2_0:find_escape_destination(arg_2_1, arg_2_2)

	if var_2_3 then
		var_2_2:move_to(var_2_4)
	end
end

function BTPackMasterDragAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.drag_check_radius = nil
	arg_3_2.drag_check_index = nil
	arg_3_2.drag_check_time = nil
	arg_3_2.threatened = nil
	arg_3_2.find_destination = nil

	if arg_3_4 ~= "done" then
		if Unit.alive(arg_3_2.drag_target_unit) then
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

	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local var_3_1 = arg_3_2.navigation_extension

	var_3_1:set_max_speed(var_3_0)
	AiUtils.allow_smart_object_layers(var_3_1, true)

	arg_3_2.attack_cooldown = arg_3_3 + arg_3_2.action.cooldown

	GwNavAStar.destroy(arg_3_2.destination_test_astar)
end

local function var_0_4(arg_4_0, arg_4_1)
	local var_4_0, var_4_1 = GwNavQueries.triangle_from_position(arg_4_0, arg_4_1, 0.5, 0.5)

	if var_4_0 then
		return Vector3(arg_4_1.x, arg_4_1.y, var_4_1)
	end
end

local var_0_5 = math.pi / 9

function BTPackMasterDragAction.find_hoist_pos(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = POSITION_LOOKUP[arg_5_2]
	local var_5_1 = POSITION_LOOKUP[arg_5_3.drag_target_unit]
	local var_5_2 = Vector3.normalize(var_5_0 - var_5_1) * 2.26
	local var_5_3 = var_0_4(arg_5_1, var_5_1 + var_5_2)

	if var_5_3 then
		return var_5_3
	end

	local var_5_4 = 0

	for iter_5_0 = 1, 6 do
		var_5_4 = var_5_4 + var_0_5

		local var_5_5 = Quaternion.rotate(Quaternion(Vector3.up(), var_5_4), var_5_2)

		var_5_3 = var_0_4(arg_5_1, var_5_1 + var_5_5)

		if var_5_3 then
			break
		end

		local var_5_6 = Quaternion.rotate(Quaternion(Vector3.up(), -var_5_4), var_5_2)

		var_5_3 = var_0_4(arg_5_1, var_5_1 + var_5_6)

		if var_5_3 then
			break
		end
	end

	return var_5_3
end

function BTPackMasterDragAction.can_hoist(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.action.safe_hoist_max_height_differance
	local var_6_1 = POSITION_LOOKUP[arg_6_1]
	local var_6_2 = POSITION_LOOKUP[arg_6_2.drag_target_unit]

	return var_6_0 >= math.abs(var_6_2.z - var_6_1.z)
end

function BTPackMasterDragAction.safe_to_hoist(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = POSITION_LOOKUP[arg_7_1]
	local var_7_1 = Vector3.distance_squared
	local var_7_2 = arg_7_2.side
	local var_7_3 = var_7_2.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_7_4 = var_7_2.ENEMY_PLAYER_AND_BOT_UNITS
	local var_7_5 = arg_7_2.action.safe_hoist_dist_squared_from_humans

	for iter_7_0, iter_7_1 in ipairs(var_7_4) do
		if arg_7_2.drag_target_unit ~= iter_7_1 and not ScriptUnit.extension(iter_7_1, "status_system"):is_disabled() then
			local var_7_6 = var_7_3[iter_7_0]

			if var_7_5 > var_7_1(var_7_6, var_7_0) then
				return false
			end
		end
	end

	return true
end

function BTPackMasterDragAction.run(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_2.drag_target_unit

	if not Unit.alive(var_8_0) then
		return "failed"
	end

	if ConflictUtils.average_player_position(var_8_0) == nil then
		return "failed"
	end

	local var_8_1 = ScriptUnit.extension(var_8_0, "status_system")

	if not var_8_1:is_grabbed_by_pack_master() then
		return "failed"
	end

	if var_8_1:is_dead() then
		return "failed"
	end

	if var_8_1:is_knocked_down() then
		arg_8_2.hoist_time = 0
	end

	local var_8_2 = POSITION_LOOKUP[arg_8_1]
	local var_8_3 = arg_8_2.nav_world

	if arg_8_3 > arg_8_2.hoist_time then
		if arg_8_0:can_hoist(arg_8_1, arg_8_2) and arg_8_0:safe_to_hoist(arg_8_1, arg_8_2) then
			if arg_8_2.hoist_pos then
				if Vector3.distance_squared(var_8_2, arg_8_2.hoist_pos:unbox()) < 0.1 then
					return "done"
				end

				return "running"
			else
				local var_8_4 = arg_8_0:find_hoist_pos(var_8_3, arg_8_1, arg_8_2)

				if var_8_4 then
					arg_8_2.hoist_pos = Vector3Box(var_8_4)

					arg_8_2.navigation_extension:move_to(var_8_4)
				end
			end
		else
			arg_8_2.hoist_pos = nil
		end
	end

	local var_8_5 = arg_8_2.locomotion_extension
	local var_8_6 = Vector3.flat(-var_8_5:current_velocity())
	local var_8_7 = Quaternion.look(var_8_6, Vector3(0, 0, 1))

	arg_8_2.locomotion_extension:set_wanted_rotation(var_8_7)

	if arg_8_3 > arg_8_2.time_to_damage then
		local var_8_8 = arg_8_2.action

		DamageUtils.add_damage_network(var_8_0, arg_8_1, var_8_8.damage_amount, var_8_8.hit_zone_name, var_8_8.damage_type, nil, Vector3.up(), arg_8_2.breed.name, nil, nil, nil, var_8_8.hit_react_type, nil, nil, nil, nil, nil, nil, 1)

		arg_8_2.time_to_damage = arg_8_3 + var_8_8.time_to_damage
	end

	if arg_8_2.test_destinations and (arg_8_0:test_destinations(arg_8_1, arg_8_2) or true) then
		return "running"
	end

	if arg_8_2.navigation_extension:has_reached_destination(2) and not arg_8_2.test_destinations then
		arg_8_2.find_destination = true
	end

	local var_8_9 = false

	if arg_8_3 > arg_8_2.drag_check_time then
		arg_8_2.drag_check_time = arg_8_3 + 1

		if not arg_8_2.threatened then
			arg_8_2.threatened = find_position_to_avoid(arg_8_1, arg_8_2)
			var_8_9 = true

			if arg_8_2.threatened then
				arg_8_2.find_destination = true
			end
		end
	end

	if not arg_8_2.find_destination then
		return "running"
	end

	if not var_8_9 then
		arg_8_2.threatened = find_position_to_avoid(arg_8_1, arg_8_2)
	end

	arg_8_0:find_destinations(arg_8_1, arg_8_2, arg_8_3, arg_8_4)

	arg_8_2.find_destination = false

	return "running"
end

function BTPackMasterDragAction.find_destinations(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = POSITION_LOOKUP[arg_9_1]
	local var_9_1 = false
	local var_9_2 = false
	local var_9_3 = arg_9_2.threat_pos:unbox()
	local var_9_4 = Vector3.normalize(var_9_0 - var_9_3)
	local var_9_5 = arg_9_2.threatened

	if not var_9_5 and not arg_9_0:find_valid_interest_points(var_9_0, arg_9_2.packmaster_destinations, var_9_4) and not arg_9_0:find_nav_group_neighbour(arg_9_2, var_9_0, var_9_4, var_9_3) then
		var_9_5 = true
	end

	if var_9_5 then
		arg_9_0:find_valid_covers(var_9_0, arg_9_2.packmaster_destinations, var_9_4, var_9_3)
	end

	arg_9_0:setup_destination_test(arg_9_1, arg_9_2)

	if var_0_3.debug_ai_movement then
		QuickDrawerStay:vector(var_9_0, arg_9_2.last_path_direction:unbox() * 2, Colors.get("purple"))
		QuickDrawerStay:sphere(var_9_0 + Vector3.up() * 1.7, 0.5, arg_9_2.threatened and Colors.get("red") or Colors.get("yellow"))
	end
end

function find_position_to_avoid(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.action.safe_hoist_dist_squared_from_humans
	local var_10_1 = POSITION_LOOKUP[arg_10_0]
	local var_10_2 = Vector3(0, 0, 0)
	local var_10_3 = 0
	local var_10_4 = arg_10_1.side
	local var_10_5 = var_10_4.ENEMY_PLAYER_AND_BOT_UNITS
	local var_10_6 = var_10_4.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_10_0, iter_10_1 in pairs(var_10_5) do
		if arg_10_1.drag_target_unit ~= iter_10_1 and not ScriptUnit.extension(iter_10_1, "status_system"):is_disabled() then
			var_10_3 = var_10_3 + 1

			local var_10_7 = var_10_6[iter_10_0]
			local var_10_8 = Vector3.distance_squared(var_10_7, var_10_1)

			if var_10_8 > 0 and var_10_8 < var_10_0 then
				local var_10_9 = var_10_7 - var_10_1

				var_10_2 = var_10_2 - Vector3.normalize(var_10_9) / math.sqrt(var_10_8)
			end
		end
	end

	arg_10_1.threat_pos = Vector3Box(var_10_1 - var_10_2)

	if var_0_3.debug_ai_movement then
		QuickDrawer:sphere(var_10_1 - var_10_2 * 4, 1, Color(0, 255, 0))
	end

	return var_10_3 > 0
end

local function var_0_6(arg_11_0, arg_11_1)
	return arg_11_0[var_0_2] > arg_11_1[var_0_2]
end

function BTPackMasterDragAction.find_valid_covers(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = Unit.local_position
	local var_12_1 = Vector3.distance_squared
	local var_12_2 = Vector3.distance
	local var_12_3 = Vector3.normalize
	local var_12_4 = Vector3.dot
	local var_12_5 = math.max
	local var_12_6 = FrameTable.alloc_table()
	local var_12_7 = var_12_2(arg_12_4, arg_12_1)
	local var_12_8 = 19
	local var_12_9 = 3
	local var_12_10 = Managers.state.conflict.level_analysis.cover_points_broadphase
	local var_12_11 = Broadphase.query(var_12_10, arg_12_1, var_12_8, var_12_6)
	local var_12_12 = var_12_9 * var_12_9
	local var_12_13 = var_12_8 * var_12_8

	if var_0_3.debug_ai_movement then
		QuickDrawerStay:sphere(arg_12_4, 2, Colors.get("deep_sky_blue"))
	end

	local var_12_14 = 1

	for iter_12_0 = 1, var_12_11 do
		local var_12_15 = var_12_6[iter_12_0]
		local var_12_16 = var_12_0(var_12_15, 0)
		local var_12_17 = var_12_1(var_12_16, arg_12_1)

		if var_12_12 <= var_12_17 and var_12_17 < var_12_13 then
			local var_12_18 = Unit.local_rotation(var_12_15, 0)
			local var_12_19 = var_12_16 - arg_12_1
			local var_12_20 = var_12_3(var_12_16 - arg_12_4)
			local var_12_21 = var_12_4(var_12_3(var_12_19), arg_12_3)
			local var_12_22 = var_12_4(Quaternion.forward(var_12_18), -var_12_20)
			local var_12_23 = var_12_2(var_12_16, arg_12_4)
			local var_12_24 = var_12_5(0, var_12_21)
			local var_12_25 = var_12_5(0, var_12_22) + 1
			local var_12_26 = var_12_23 * var_12_24 * var_12_25

			if var_0_3.debug_ai_movement then
				local var_12_27 = Color(255, 255 * var_12_5(-var_12_21, 0), 255 * var_12_5(var_12_21, 0), 255 * var_12_5(0, var_12_22))

				QuickDrawerStay:sphere(var_12_16, 1, var_12_27)
				QuickDrawerStay:line(var_12_16 + Vector3(0, 0, 1), var_12_16 + Quaternion.forward(var_12_18) * 2 + Vector3(0, 0, 1), var_12_27)
			end

			arg_12_2[var_12_14][1] = Vector3Box(var_12_16)
			arg_12_2[var_12_14][2] = var_12_26
			var_12_14 = var_12_14 + 1

			if var_12_14 > var_0_0 then
				break
			end
		end
	end

	for iter_12_1 = var_12_14, var_0_0 do
		arg_12_2[iter_12_1][2] = -math.huge
	end
end

function BTPackMasterDragAction.find_valid_interest_points(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = {}
	local var_13_1 = 19
	local var_13_2 = 5
	local var_13_3 = Managers.state.entity:system("ai_interest_point_system").broadphase
	local var_13_4 = Broadphase.query(var_13_3, arg_13_1, var_13_1, var_13_0)
	local var_13_5 = Unit.local_position
	local var_13_6 = Vector3.distance
	local var_13_7 = Vector3.normalize
	local var_13_8 = Vector3.dot
	local var_13_9 = 1

	for iter_13_0 = 1, var_13_4 do
		local var_13_10 = var_13_0[iter_13_0]

		if Unit.alive(var_13_10) and Unit.get_data(var_13_10, "interest_point", "enabled") and ScriptUnit.extension(var_13_10, "ai_interest_point_system").num_claimed_points > 0 then
			local var_13_11 = var_13_5(var_13_10, 0)
			local var_13_12 = var_13_6(var_13_11, arg_13_1)

			if var_13_2 < var_13_12 and var_13_12 < var_13_1 then
				local var_13_13 = var_13_11 - arg_13_1
				local var_13_14 = var_13_8(var_13_7(var_13_13), arg_13_3) * 2 + 2
				local var_13_15 = (var_13_1 - var_13_12) * var_13_14

				if var_0_3.debug_ai_movement then
					QuickDrawerStay:sphere(var_13_11, 1, Colors.get("pink"))
				end

				arg_13_2[var_13_9][1] = Vector3Box(var_13_11)
				arg_13_2[var_13_9][2] = var_13_15
				var_13_9 = var_13_9 + 1

				if var_13_9 > var_0_0 then
					break
				end
			end
		end
	end

	for iter_13_1 = var_13_9, var_0_0 do
		arg_13_2[iter_13_1][2] = -math.huge
	end

	return var_13_9 > 1
end

function BTPackMasterDragAction.find_nav_group_neighbour(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = arg_14_1.packmaster_destinations
	local var_14_1 = Managers.state.conflict.navigation_group_manager:get_group_from_position(arg_14_2)

	if not var_14_1 then
		print("Packmaster was not on nav_group")

		if var_0_3.debug_ai_movement then
			QuickDrawerStay:sphere(arg_14_2, 0.5, Colors.get("red"))
		end

		return false
	end

	local var_14_2 = var_14_1:get_group_neighbours()
	local var_14_3 = 1

	for iter_14_0, iter_14_1 in pairs(var_14_2) do
		local var_14_4 = iter_14_0:get_group_center():unbox()
		local var_14_5 = var_14_4 - arg_14_2
		local var_14_6 = Vector3.normalize(var_14_5)
		local var_14_7 = Vector3.dot(var_14_6, arg_14_3)
		local var_14_8 = math.max(0, var_14_7)

		if var_0_3.debug_ai_movement then
			QuickDrawerStay:sphere(var_14_4, 3, var_14_7 > -0.25 and Colors.get("yellow") or Colors.get("red"))
			QuickDrawerStay:line(var_14_4, arg_14_2, var_14_7 > -0.25 and Colors.get("yellow") or Colors.get("red"))
		end

		if var_14_7 > -0.25 then
			local var_14_9 = Vector3.distance_squared(arg_14_4, var_14_4) * var_14_8
			local var_14_10, var_14_11 = GwNavQueries.triangle_from_position(arg_14_1.nav_world, var_14_4, 1.5, 1.5)

			if var_14_10 then
				var_14_4.z = var_14_11
			else
				local var_14_12 = GwNavQueries.inside_position_from_outside_position(arg_14_1.nav_world, var_14_4, 4, 4, 2.5, 0.38)

				if var_14_12 then
					var_14_4 = var_14_12
				elseif var_0_3.debug_ai_movement then
					QuickDrawerStay:sphere(var_14_4, 2, (Colors.get("purple")))
					QuickDrawerStay:sphere(var_14_4, 4, (Colors.get("purple")))
				end
			end

			var_14_0[var_14_3][var_0_1] = Vector3Box(var_14_4)
			var_14_0[var_14_3][var_0_2] = var_14_9
			var_14_3 = var_14_3 + 1

			if var_14_3 > var_0_0 then
				break
			end
		end
	end

	for iter_14_2 = var_14_3, var_0_0 do
		var_14_0[iter_14_2][var_0_2] = -math.huge
	end

	return var_14_3 > 1
end

function BTPackMasterDragAction.find_escape_destination(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2.last_path_direction:unbox()
	local var_15_1 = POSITION_LOOKUP[arg_15_1] + Vector3(0, 0, 0.5)
	local var_15_2 = false
	local var_15_3
	local var_15_4 = math.atan2(var_15_0.y, var_15_0.x, 0)
	local var_15_5 = 5
	local var_15_6 = math.pi / (var_15_5 - 1)
	local var_15_7 = arg_15_2.navigation_extension:traverse_logic()
	local var_15_8 = arg_15_2.nav_world

	for iter_15_0 = 1, var_15_5 do
		local var_15_9 = var_15_4 + math.ceil((iter_15_0 - 1) * 0.5) * (iter_15_0 % 2 * 2 - 1) * var_15_6
		local var_15_10 = Vector3(math.cos(var_15_9), math.sin(var_15_9), 0)
		local var_15_11 = var_15_1 + var_15_10 * 3
		local var_15_12, var_15_13 = GwNavQueries.triangle_from_position(var_15_8, var_15_11, 0.5, 1)

		if var_15_12 and GwNavQueries.raycango(var_15_8, var_15_1, var_15_11, var_15_7) then
			var_15_11.z = var_15_13
			var_15_3 = var_15_11

			local var_15_14 = var_15_1 + var_15_10 * 5
			local var_15_15, var_15_16 = GwNavQueries.triangle_from_position(var_15_8, var_15_14, 0.5, 1)

			if var_15_15 and GwNavQueries.raycango(var_15_8, var_15_1, var_15_14, var_15_7) then
				var_15_14.z = var_15_16
				var_15_3 = var_15_14

				if var_0_3.debug_ai_movement then
					QuickDrawerStay:vector(var_15_1, var_15_14 - var_15_1, Colors.get("gold"))
				end
			end

			var_15_2 = true

			break
		end

		if var_0_3.debug_ai_movement then
			QuickDrawerStay:vector(var_15_1, var_15_11 - var_15_1, Colors.get("orange"))
		end
	end

	return var_15_2, var_15_3
end

function BTPackMasterDragAction.setup_destination_test(arg_16_0, arg_16_1, arg_16_2)
	arg_16_2.destination_test_index = 0
	arg_16_2.test_destinations = true
	arg_16_2.test_next_destination = true
	arg_16_2.best_destination = nil
	arg_16_2.best_destination_score = -math.huge

	table.sort(arg_16_2.packmaster_destinations, var_0_6)

	local var_16_0 = Vector3.normalize(POSITION_LOOKUP[arg_16_1] - POSITION_LOOKUP[arg_16_2.drag_target_unit])

	arg_16_2.last_path_direction = Vector3Box(var_16_0)
end

function BTPackMasterDragAction.test_destinations(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_2.destination_test_astar
	local var_17_1 = arg_17_2.nav_world
	local var_17_2 = arg_17_2.packmaster_destinations
	local var_17_3 = arg_17_2.destination_test_index
	local var_17_4 = arg_17_2.test_next_destination
	local var_17_5 = POSITION_LOOKUP[arg_17_1]
	local var_17_6 = Vector3Box.unbox(arg_17_2.last_path_direction)
	local var_17_7 = arg_17_2.navigation_extension
	local var_17_8 = var_17_7:traverse_logic()

	if var_17_4 then
		var_17_3 = var_17_3 + 1
		arg_17_2.destination_test_index = var_17_3

		if var_17_2[var_17_3] and var_17_2[var_17_3][var_0_2] ~= -math.huge then
			local var_17_9 = var_17_2[var_17_3][1]:unbox()

			GwNavAStar.start(var_17_0, var_17_1, var_17_5, var_17_9, var_17_8)
		else
			arg_17_2.test_destinations = false
			arg_17_2.test_next_destination = false

			local var_17_10 = arg_17_2.best_destination_score
			local var_17_11 = true

			if var_17_10 < 0.01 then
				local var_17_12
				local var_17_13

				var_17_11, var_17_13 = arg_17_0:find_escape_destination(arg_17_1, arg_17_2)

				if var_17_11 then
					arg_17_2.best_destination = Vector3Box(var_17_13)
				end
			end

			if not var_17_11 then
				return false
			end

			var_17_7:move_to(arg_17_2.best_destination:unbox())

			return true
		end
	end

	if GwNavAStar.processing_finished(var_17_0) then
		if GwNavAStar.path_found(var_17_0) then
			local var_17_14 = GwNavAStar.path_distance(var_17_0)

			fassert(var_17_14 > 0, "Path length is 0, this will cause div by 0")

			local var_17_15 = var_17_14 * var_17_14
			local var_17_16 = var_17_2[var_17_3][1]:unbox()
			local var_17_17 = var_17_2[var_17_3][2]
			local var_17_18 = var_17_16 - var_17_5
			local var_17_19 = Vector3.length_squared(var_17_18)
			local var_17_20 = GwNavAStar.node_at_index(var_17_0, 2) - GwNavAStar.node_at_index(var_17_0, 1)
			local var_17_21 = Vector3.normalize(var_17_20)
			local var_17_22 = Vector3.dot(var_17_6, var_17_21) * 0.75 + 0.25
			local var_17_23 = var_17_19 / var_17_15
			local var_17_24 = var_17_17 * (var_17_23 * var_17_22)

			var_17_2[var_17_3][2] = var_17_24

			local var_17_25 = var_17_23 > 0.4444444444444444 and var_17_22 > 0

			if var_17_25 then
				for iter_17_0 = 2, GwNavAStar.node_count(var_17_0) do
					local var_17_26 = GwNavAStar.node_at_index(var_17_0, iter_17_0 - 1)
					local var_17_27 = GwNavAStar.node_at_index(var_17_0, iter_17_0)

					if not GwNavQueries.raycango(var_17_1, var_17_26, var_17_27, var_17_8) then
						var_17_25 = false

						break
					end
				end
			end

			if var_17_25 then
				arg_17_2.test_destinations = false
				arg_17_2.test_next_destination = false

				var_17_7:move_to(var_17_16)
			else
				arg_17_2.test_next_destination = true

				if var_17_24 > arg_17_2.best_destination_score then
					arg_17_2.best_destination_score = var_17_24
					arg_17_2.best_destination = Vector3Box(var_17_16)
				end
			end

			if var_0_3.debug_ai_movement then
				local var_17_28 = GwNavAStar.node_count(var_17_0)

				for iter_17_1 = 1, var_17_28 do
					local var_17_29 = GwNavAStar.node_at_index(var_17_0, iter_17_1)

					QuickDrawerStay:sphere(var_17_29, 0.1, var_17_25 and Colors.get("yellow") or Colors.get("red"))

					local var_17_30 = GwNavAStar.node_at_index(var_17_0, iter_17_1 + 1)

					if var_17_30 then
						QuickDrawerStay:line(var_17_29, var_17_30, var_17_25 and Colors.get("yellow") or Colors.get("red"))
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
