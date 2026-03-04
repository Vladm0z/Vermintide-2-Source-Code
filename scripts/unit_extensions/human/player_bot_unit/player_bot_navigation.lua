-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_navigation.lua

PlayerBotNavigation = class(PlayerBotNavigation)

PlayerBotNavigation.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._nav_world = arg_1_3.nav_world
	arg_1_0._final_goal_reached = false
	arg_1_0._position_when_final_goal_reached = Vector3Box(0, 0, 0)
	arg_1_0._player = Managers.player:owner(arg_1_2)
	arg_1_0._destination = Vector3Box(0, 0, 0)
	arg_1_0._traverse_data = Managers.state.bot_nav_transition:traverse_logic()
	arg_1_0._has_queued_target = false
	arg_1_0._queued_target_position = Vector3Box(0, 0, 0)
	arg_1_0._available_nav_transitions = {}
	arg_1_0._active_nav_transition = nil
	arg_1_0._astar = GwNavAStar.create()
	arg_1_0._running_astar = false
	arg_1_0._path = nil
	arg_1_0._last_successful_path = 0
	arg_1_0._successive_failed_paths = 0
	arg_1_0._close_to_goal_time = nil
	arg_1_0._astar_cancelled = false
end

PlayerBotNavigation.destroy = function (arg_2_0)
	GwNavAStar.destroy(arg_2_0._astar)

	arg_2_0._astar = nil
end

PlayerBotNavigation.reset = function (arg_3_0)
	return
end

PlayerBotNavigation.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if arg_4_0._astar_cancelled then
		arg_4_0._astar_cancelled = false
	end

	if arg_4_0._running_astar then
		arg_4_0:_update_astar(arg_4_5)
	end

	arg_4_0:_update_path(arg_4_5)
end

local var_0_0 = math.cos(math.pi / 8)

PlayerBotNavigation.move_to = function (arg_5_0, arg_5_1, arg_5_2)
	fassert(not arg_5_2 or type(arg_5_2) == "function", "Tried to pass invalid callback value to PlayerBotNavigation:move_to()")

	if arg_5_0._astar_cancelled then
		print("Can't path, AStar was cancelled, need to wait for command queue to be flushed")

		return false
	end

	local var_5_0 = arg_5_0._current_transition

	if var_5_0 and Managers.time:time("game") - var_5_0.t < 10 then
		return false
	end

	if arg_5_0._running_astar then
		arg_5_0._has_queued_target = true

		arg_5_0._queued_target_position:store(arg_5_1)

		arg_5_0._queued_path_callback = arg_5_2

		return true
	end

	local var_5_1 = POSITION_LOOKUP[arg_5_0._unit]
	local var_5_2 = 0.75
	local var_5_3 = 0.5
	local var_5_4, var_5_5 = GwNavQueries.triangle_from_position(arg_5_0._nav_world, var_5_1, var_5_2, var_5_3)

	if var_5_4 then
		var_5_1 = Vector3(var_5_1.x, var_5_1.y, var_5_5)
	end

	if Vector3.equal(var_5_1, arg_5_1) then
		print("Bot tried to move to its current position, AStar will probably fail.")
	end

	GwNavAStar.start_with_propagation_box(arg_5_0._astar, arg_5_0._nav_world, var_5_1, arg_5_1, 30, arg_5_0._traverse_data)

	arg_5_0._running_astar = true

	if not arg_5_0._final_goal_reached and Vector3.dot(Vector3.normalize(arg_5_1 - var_5_1), Vector3.normalize(arg_5_0._destination:unbox() - var_5_1)) > var_0_0 then
		arg_5_0._last_path = arg_5_0._path
		arg_5_0._last_path_index = arg_5_0._path_index
	end

	arg_5_0._path = nil
	arg_5_0._current_transition = nil
	arg_5_0._path_index = 0
	arg_5_0._close_to_goal_time = nil
	arg_5_0._final_goal_reached = false

	arg_5_0._destination:store(arg_5_1)

	arg_5_0._path_callback = arg_5_2

	return true
end

PlayerBotNavigation.teleport = function (arg_6_0, arg_6_1)
	if not arg_6_0._astar then
		return
	end

	if arg_6_0._running_astar and not GwNavAStar.processing_finished(arg_6_0._astar) then
		GwNavAStar.cancel(arg_6_0._astar)

		arg_6_0._running_astar = false
		arg_6_0._astar_cancelled = true
	end

	arg_6_0._has_queued_target = false
	arg_6_0._queued_path_callback = nil
	arg_6_0._final_goal_reached = true

	arg_6_0._position_when_final_goal_reached:store(arg_6_1)

	arg_6_0._path = nil
	arg_6_0._path_index = 0
	arg_6_0._path_callback = nil

	arg_6_0._destination:store(arg_6_1)

	arg_6_0._successive_failed_paths = 0
	arg_6_0._close_to_goal_time = nil
	arg_6_0._last_path = nil
	arg_6_0._last_path_index = nil
	arg_6_0._current_transition = nil
end

PlayerBotNavigation.stop = function (arg_7_0)
	local var_7_0 = POSITION_LOOKUP[arg_7_0._unit]

	arg_7_0:teleport(var_7_0)
end

PlayerBotNavigation.is_path_safe_from_vortex = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._path

	if not var_8_0 or arg_8_0._final_goal_reached then
		return true
	end

	local var_8_1 = Managers.state.conflict:spawned_units_by_breed("chaos_vortex")
	local var_8_2 = arg_8_0._path_index
	local var_8_3 = #var_8_0
	local var_8_4 = arg_8_0._unit
	local var_8_5 = POSITION_LOOKUP[var_8_4]
	local var_8_6
	local var_8_7 = 0
	local var_8_8 = false
	local var_8_9 = true

	for iter_8_0 = var_8_2, var_8_3 do
		local var_8_10 = var_8_0[iter_8_0]:unbox()
		local var_8_11 = var_8_10 - var_8_5
		local var_8_12 = var_8_7 + Vector3.length(var_8_11)

		if arg_8_1 <= var_8_12 then
			var_8_8 = true
			var_8_9 = var_8_12 == arg_8_1
		end

		for iter_8_1, iter_8_2 in pairs(var_8_1) do
			local var_8_13 = POSITION_LOOKUP[iter_8_1]
			local var_8_14 = ScriptUnit.extension(iter_8_1, "ai_supplementary_system")
			local var_8_15 = var_8_0[iter_8_0 - 1]:unbox()
			local var_8_16 = Geometry.closest_point_on_line(var_8_13, var_8_15, var_8_10)
			local var_8_17 = true
			local var_8_18 = var_8_16 - var_8_5

			if iter_8_0 == var_8_2 then
				var_8_17 = Vector3.dot(var_8_18, var_8_11) > 0
			end

			local var_8_19 = var_8_17 and var_8_7 + Vector3.length(var_8_18)

			var_8_17 = var_8_17 and var_8_19 <= arg_8_1

			if var_8_17 then
				var_8_6 = var_8_14:is_position_inside(var_8_16, arg_8_2)
			end

			if not var_8_6 and var_8_9 then
				var_8_6 = var_8_14:is_position_inside(var_8_10, arg_8_2)
			end

			if var_8_6 then
				return false
			end
		end

		if var_8_8 then
			break
		end

		var_8_7 = var_8_12
		var_8_5 = var_8_10
	end

	return true
end

local function var_0_1(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0 - arg_9_1

	if math.abs(var_9_0.z) > 0.1 then
		return false
	else
		local var_9_1 = var_9_0.x
		local var_9_2 = var_9_0.y

		return var_9_1 * var_9_1 + var_9_2 * var_9_2 < 0.0001
	end
end

PlayerBotNavigation._update_path = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._path

	if not var_10_0 or arg_10_0._final_goal_reached then
		arg_10_0._current_transition = nil

		return
	end

	local var_10_1 = arg_10_0._unit
	local var_10_2 = POSITION_LOOKUP[var_10_1]
	local var_10_3 = var_10_0[arg_10_0._path_index]:unbox()
	local var_10_4 = var_10_0[arg_10_0._path_index - 1]:unbox()

	if arg_10_0:_goal_reached(var_10_2, var_10_3, var_10_4, arg_10_1) then
		arg_10_0._path_index = arg_10_0._path_index + 1

		local var_10_5 = arg_10_0._path_index > #var_10_0

		arg_10_0._final_goal_reached = var_10_5

		if var_10_5 then
			arg_10_0._position_when_final_goal_reached:store(var_10_2)

			arg_10_0._current_transition = nil
		else
			local var_10_6 = var_10_0[arg_10_0._path_index]:unbox()

			arg_10_0:_reevaluate_current_nav_transition(var_10_1, var_10_2, var_10_3, var_10_6)
		end
	end
end

PlayerBotNavigation._reevaluate_current_nav_transition = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_0._current_transition

	arg_11_0._current_transition = nil

	local var_11_1 = BLACKBOARDS[arg_11_1]

	var_11_1.breakable_object = nil

	local var_11_2
	local var_11_3 = math.huge

	for iter_11_0, iter_11_1 in pairs(arg_11_0._available_nav_transitions) do
		if iter_11_1.type == "ladder" then
			local var_11_4 = Vector3.distance_squared(arg_11_2, (iter_11_1.from:unbox() + iter_11_1.to:unbox()) * 0.5)

			if var_11_4 < var_11_3 then
				var_11_3 = var_11_4
				var_11_2 = iter_11_1
			end
		elseif iter_11_1.type == "planks" then
			local var_11_5 = iter_11_1.from:unbox()
			local var_11_6 = iter_11_1.to:unbox()
			local var_11_7

			if var_0_1(arg_11_3, var_11_5) and var_0_1(arg_11_4, var_11_6) then
				var_11_7 = "to"
			elseif var_0_1(arg_11_3, var_11_6) and var_0_1(arg_11_4, var_11_5) then
				var_11_7 = "from"
			end

			if var_11_7 then
				iter_11_1.goal = var_11_7
				arg_11_0._current_transition = iter_11_1
				var_11_1.breakable_object = iter_11_1.unit

				if iter_11_1 ~= var_11_0 then
					iter_11_1.t = Managers.time:time("game")
				end

				return
			end
		else
			local var_11_8 = iter_11_1.waypoint:unbox()
			local var_11_9 = iter_11_1.from:unbox()
			local var_11_10 = iter_11_1.to:unbox()
			local var_11_11

			if var_0_1(arg_11_3, var_11_9) and var_0_1(arg_11_4, var_11_8) then
				var_11_11 = "waypoint"
			elseif var_0_1(arg_11_3, var_11_8) and var_0_1(arg_11_4, var_11_10) then
				var_11_11 = "to"
			end

			if var_11_11 then
				iter_11_1.goal = var_11_11
				arg_11_0._current_transition = iter_11_1

				if iter_11_1 ~= var_11_0 then
					iter_11_1.t = Managers.time:time("game")
				end

				return
			end
		end
	end

	if var_11_0 and var_11_0.type ~= "ladder" and var_11_0.waypoint and var_0_1(arg_11_3, var_11_0.waypoint:unbox()) and var_0_1(arg_11_4, var_11_0.to:unbox()) then
		var_11_0.goal = "to"
		arg_11_0._current_transition = var_11_0

		return
	elseif var_11_2 then
		arg_11_0._current_transition = var_11_2

		if var_11_2 ~= var_11_0 then
			var_11_2.t = Managers.time:time("game")
		end
	end
end

local var_0_2 = 0.05
local var_0_3 = 0.25
local var_0_4 = 0.2
local var_0_5 = 0.25
local var_0_6 = (var_0_4 - var_0_2) / var_0_5

PlayerBotNavigation._goal_reached = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_2 - arg_12_1
	local var_12_1 = arg_12_2 - arg_12_3
	local var_12_2 = Vector3.dot(var_12_0, var_12_1) < 0
	local var_12_3 = arg_12_2 - arg_12_1
	local var_12_4 = var_12_3.z
	local var_12_5 = Vector3.length(Vector3.flat(var_12_3))
	local var_12_6 = var_0_2

	if arg_12_0._close_to_goal_time then
		var_12_6 = math.clamp(var_12_6 + (arg_12_4 - arg_12_0._close_to_goal_time - var_0_3) * var_0_6, var_0_2, var_0_4)
	end

	local var_12_7 = var_12_5 < var_12_6 and var_12_4 > -0.35 and var_12_4 < 0.5
	local var_12_8 = var_12_2 or var_12_7

	if var_12_8 then
		arg_12_0._close_to_goal_time = nil
	elseif var_12_5 < var_0_4 and not arg_12_0._close_to_goal_time then
		arg_12_0._close_to_goal_time = arg_12_4
	end

	return var_12_8
end

PlayerBotNavigation.current_goal = function (arg_13_0)
	if arg_13_0._final_goal_reached then
		return nil
	elseif arg_13_0._path then
		return arg_13_0._path[arg_13_0._path_index]:unbox()
	elseif arg_13_0._last_path then
		return arg_13_0._last_path[arg_13_0._last_path_index]:unbox()
	else
		return nil
	end
end

PlayerBotNavigation.is_following_last_goal = function (arg_14_0)
	if arg_14_0._final_goal_reached then
		return false
	elseif arg_14_0._path then
		return arg_14_0._path_index == #arg_14_0._path
	elseif arg_14_0._last_path then
		return arg_14_0._last_path_index == #arg_14_0._last_path
	else
		return false
	end
end

PlayerBotNavigation.destination_reached = function (arg_15_0)
	return arg_15_0._final_goal_reached
end

PlayerBotNavigation._update_astar = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._astar

	if GwNavAStar.processing_finished(var_16_0) then
		if GwNavAStar.path_found(var_16_0) then
			local var_16_1 = GwNavAStar.node_count(var_16_0)

			fassert(var_16_1 > 0, "Number of nodes in returned path is not greater than 0.")

			local var_16_2 = GwNavAStar.node_at_index(var_16_0, var_16_1)
			local var_16_3, var_16_4 = GwNavQueries.triangle_from_position(arg_16_0._nav_world, var_16_2, 0.3, 0.3, arg_16_0._traverse_data)
			local var_16_5

			if var_16_3 then
				var_16_5 = Vector3Box(var_16_2.x, var_16_2.y, var_16_4)
			else
				var_16_5 = nil
			end

			if not var_16_3 and var_16_1 <= 2 then
				arg_16_0:_path_failed(arg_16_1)
			else
				arg_16_0._path = Script.new_array(var_16_1)

				arg_16_0:_path_successful(arg_16_1)

				for iter_16_0 = 1, var_16_1 - 1 do
					local var_16_6 = GwNavAStar.node_at_index(var_16_0, iter_16_0)

					arg_16_0._path[iter_16_0] = Vector3Box(var_16_6)
				end

				arg_16_0._path[var_16_1] = var_16_5
				arg_16_0._path_index = 2
				arg_16_0._close_to_goal_time = nil
			end
		else
			arg_16_0:_path_failed(arg_16_1)
		end

		arg_16_0._running_astar = false
		arg_16_0._last_path = nil
		arg_16_0._last_path_index = nil

		if arg_16_0._has_queued_target then
			arg_16_0._has_queued_target = false

			arg_16_0:move_to(arg_16_0._queued_target_position:unbox(), arg_16_0._queued_path_callback)

			arg_16_0._queued_path_callback = nil
		end
	end
end

PlayerBotNavigation.path_callback = function (arg_17_0)
	return arg_17_0._path_callback
end

PlayerBotNavigation._path_failed = function (arg_18_0, arg_18_1)
	if script_data.debug_ai_movement then
		print("AI bot failed to find path")
	end

	arg_18_0._successive_failed_paths = arg_18_0._successive_failed_paths + 1

	local var_18_0 = arg_18_0._path_callback

	if var_18_0 then
		var_18_0(false, arg_18_0._destination:unbox())
	end
end

PlayerBotNavigation._path_successful = function (arg_19_0, arg_19_1)
	arg_19_0._last_successful_path = arg_19_1
	arg_19_0._successive_failed_paths = 0

	local var_19_0 = arg_19_0._path_callback

	if var_19_0 then
		var_19_0(true, arg_19_0._destination:unbox())
	end
end

PlayerBotNavigation.successive_failed_paths = function (arg_20_0)
	return arg_20_0._successive_failed_paths, arg_20_0._last_successful_path
end

PlayerBotNavigation.destination = function (arg_21_0)
	if arg_21_0._has_queued_target then
		return arg_21_0._queued_target_position:unbox()
	else
		return arg_21_0._destination:unbox()
	end
end

PlayerBotNavigation.position_when_destination_reached = function (arg_22_0)
	if arg_22_0._final_goal_reached then
		return arg_22_0._position_when_final_goal_reached:unbox()
	else
		return nil
	end
end

PlayerBotNavigation._debug_draw_path = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if script_data.ai_bots_debug then
		local var_23_0 = arg_23_0._player.color:unbox()
		local var_23_1 = Managers.state.debug:drawer(debug_drawer_info)

		var_23_1:vector(arg_23_2, arg_23_1 - arg_23_2, var_23_0)
		var_23_1:vector(arg_23_1, arg_23_3 - arg_23_1, var_23_0)

		local var_23_2 = arg_23_0._path
		local var_23_3 = #var_23_2

		for iter_23_0 = 1, var_23_3 - 1 do
			local var_23_4 = var_23_2[iter_23_0]:unbox()
			local var_23_5 = var_23_2[iter_23_0 + 1]:unbox()

			var_23_1:vector(var_23_4, var_23_5 - var_23_4, var_23_0)

			local var_23_6 = math.lerp(0.15, 0.3, (iter_23_0 - 1) / (var_23_3 - 1))

			var_23_1:sphere(var_23_4, var_23_6, var_23_0)
		end

		local var_23_7 = var_23_2[var_23_3]:unbox()
		local var_23_8 = math.lerp(0.15, 0.3, (var_23_3 - 1) / (var_23_3 - 1))

		var_23_1:sphere(var_23_7, var_23_8, var_23_0)
	end
end

PlayerBotNavigation.is_in_transition = function (arg_24_0)
	return arg_24_0._current_transition ~= nil
end

PlayerBotNavigation.transition_type = function (arg_25_0)
	return arg_25_0._current_transition.type
end

PlayerBotNavigation.transition_requires_jump = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0:current_goal()

	fassert(arg_26_0._current_transition, "Trying to check if transition requires jump with no active transition")
	fassert(var_26_0, "Current transition but no current goal?")

	local var_26_1 = arg_26_0._current_transition

	if var_26_1.type == "bot_leap_of_faith" and var_26_1.goal == "to" and Vector3.distance_squared(arg_26_0._path[arg_26_0._path_index - 1]:unbox(), arg_26_1) < 1 then
		return true
	end

	return false
end

PlayerBotNavigation.flow_cb_entered_nav_transition = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0._available_nav_transitions
	local var_27_1 = Unit.get_data(arg_27_1, "bot_nav_transition_manager_index")
	local var_27_2, var_27_3, var_27_4, var_27_5 = Managers.state.bot_nav_transition:transition_data(arg_27_1)
	local var_27_6 = {
		type = var_27_2,
		from = Vector3Box(var_27_3),
		to = Vector3Box(var_27_4)
	}

	if var_27_2 ~= "ladder" then
		var_27_6.waypoint = Vector3Box(var_27_5)
	end

	var_27_0[arg_27_1] = var_27_6

	if var_27_2 == "ladder" and not arg_27_0._current_transition then
		arg_27_0._current_transition = var_27_6
		var_27_6.t = Managers.time:time("game")
	end
end

PlayerBotNavigation.flow_cb_left_nav_transition = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0._available_nav_transitions
	local var_28_1 = Unit.get_data(arg_28_1, "bot_nav_transition_manager_index")

	var_28_0[arg_28_1] = nil
end

PlayerBotNavigation.traverse_logic = function (arg_29_0)
	return arg_29_0._traverse_data
end

PlayerBotNavigation.add_transition = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	local var_30_0 = {
		unit = arg_30_1,
		type = arg_30_2,
		from = Vector3Box(arg_30_3),
		to = Vector3Box(arg_30_4)
	}

	arg_30_0._available_nav_transitions[arg_30_1] = var_30_0
end

PlayerBotNavigation.remove_transition = function (arg_31_0, arg_31_1)
	arg_31_0._available_nav_transitions[arg_31_1] = nil
end
