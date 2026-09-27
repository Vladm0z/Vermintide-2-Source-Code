-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_navigation.lua

PlayerBotNavigation = class(PlayerBotNavigation)

PlayerBotNavigation.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._nav_world = arg_1_3.nav_world
	self._final_goal_reached = false
	self._position_when_final_goal_reached = Vector3Box(0, 0, 0)
	self._player = Managers.player:owner(arg_1_2)
	self._destination = Vector3Box(0, 0, 0)
	self._traverse_data = Managers.state.bot_nav_transition:traverse_logic()
	self._has_queued_target = false
	self._queued_target_position = Vector3Box(0, 0, 0)
	self._available_nav_transitions = {}
	self._active_nav_transition = nil
	self._astar = GwNavAStar.create()
	self._running_astar = false
	self._path = nil
	self._last_successful_path = 0
	self._successive_failed_paths = 0
	self._close_to_goal_time = nil
	self._astar_cancelled = false
end

PlayerBotNavigation.destroy = function (self)
	-- function 2
	GwNavAStar.destroy(self._astar)

	self._astar = nil
end

PlayerBotNavigation.reset = function (arg_3_0)
	-- function 3
	return
end

PlayerBotNavigation.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not self._astar_cancelled then
		self._astar_cancelled = false
	end

	if not self._running_astar then
		self:_update_astar(arg_4_5)
	end

	self:_update_path(arg_4_5)
end

local cos = math.cos(math.pi / 8)

PlayerBotNavigation.move_to = function (self, arg_5_1, arg_5_2)
	-- function 5
	fassert(not arg_5_2 and type(arg_5_2) == "function", "Tried to pass invalid callback value to PlayerBotNavigation:move_to()")

	if not self._astar_cancelled then
		print("Can't path, AStar was cancelled, need to wait for command queue to be flushed")

		return false
	end

	local _current_transition = self._current_transition

	if not (not _current_transition and not (Managers.time:time("game") - _current_transition.t < 10)) then
		return false
	end

	if not self._running_astar then
		self._has_queued_target = true

		self._queued_target_position:store(arg_5_1)

		self._queued_path_callback = arg_5_2

		return true
	end

	local var_5_1 = POSITION_LOOKUP[self._unit]
	local num = 0.75
	local num_2 = 0.5
	local triangle_from_position, var_5_5 = GwNavQueries.triangle_from_position(self._nav_world, var_5_1, num, num_2)

	if not triangle_from_position then
		var_5_1 = Vector3(var_5_1.x, var_5_1.y, var_5_5)
	end

	if not Vector3.equal(var_5_1, arg_5_1) then
		print("Bot tried to move to its current position, AStar will probably fail.")
	end

	GwNavAStar.start_with_propagation_box(self._astar, self._nav_world, var_5_1, arg_5_1, 30, self._traverse_data)

	self._running_astar = true

	if not (self._final_goal_reached or not (Vector3.dot(Vector3.normalize(arg_5_1 - var_5_1), Vector3.normalize(self._destination:unbox() - var_5_1)) > cos)) then
		self._last_path = self._path
		self._last_path_index = self._path_index
	end

	self._path = nil
	self._current_transition = nil
	self._path_index = 0
	self._close_to_goal_time = nil
	self._final_goal_reached = false

	self._destination:store(arg_5_1)

	self._path_callback = arg_5_2

	return true
end

PlayerBotNavigation.teleport = function (self, arg_6_1)
	-- function 6
	if not self._astar then
		return
	end

	if not (not self._running_astar and GwNavAStar.processing_finished(self._astar)) then
		GwNavAStar.cancel(self._astar)

		self._running_astar = false
		self._astar_cancelled = true
	end

	self._has_queued_target = false
	self._queued_path_callback = nil
	self._final_goal_reached = true

	self._position_when_final_goal_reached:store(arg_6_1)

	self._path = nil
	self._path_index = 0
	self._path_callback = nil

	self._destination:store(arg_6_1)

	self._successive_failed_paths = 0
	self._close_to_goal_time = nil
	self._last_path = nil
	self._last_path_index = nil
	self._current_transition = nil
end

PlayerBotNavigation.stop = function (self)
	-- function 7
	local var_7_0 = POSITION_LOOKUP[self._unit]

	self:teleport(var_7_0)
end

PlayerBotNavigation.is_path_safe_from_vortex = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _path = self._path

	if not _path and not self._final_goal_reached then
		return true
	end

	local spawned_units_by_breed = Managers.state.conflict:spawned_units_by_breed("chaos_vortex")
	local _path_index = self._path_index
	local count = #_path
	local _unit = self._unit
	local var_8_5 = POSITION_LOOKUP[_unit]
	local var_8_6
	local num = 0
	local flag = false
	local flag_2 = true

	for i = _path_index, count do
		local unbox = _path[i]:unbox()
		local num_2 = unbox - var_8_5
		local num_3 = num + Vector3.length(num_2)

		if arg_8_1 <= num_3 then
			flag = true
			flag_2 = num_3 == arg_8_1
		end

		for k, v in pairs(spawned_units_by_breed) do
			local var_8_13 = POSITION_LOOKUP[k]
			local extension = ScriptUnit.extension(k, "ai_supplementary_system")
			local unbox_2 = _path[i - 1]:unbox()
			local closest_point_on_line = Geometry.closest_point_on_line(var_8_13, unbox_2, unbox)
			local flag_3 = true
			local num_4 = closest_point_on_line - var_8_5

			if i == _path_index then
				flag_3 = Vector3.dot(num_4, num_2) > 0
			end

			local flag_4 = not flag_3 and num + Vector3.length(num_4)

			flag_3 = not flag_3 and flag_4 <= arg_8_1

			if not flag_3 then
				var_8_6 = extension:is_position_inside(closest_point_on_line, arg_8_2)
			end

			if var_8_6 or not flag_2 then
				var_8_6 = extension:is_position_inside(unbox, arg_8_2)
			end

			if not var_8_6 then
				return false
			end
		end

		if not flag then
			break
		end

		num = num_3
		var_8_5 = unbox
	end

	return true
end

local function fn(arg_9_0, arg_9_1)
	-- function 9
	local num = arg_9_0 - arg_9_1

	if math.abs(num.z) > 0.1 then
		return false
	else
		local x = num.x
		local y = num.y

		return x * x + y * y < 0.0001
	end
end

PlayerBotNavigation._update_path = function (self, arg_10_1)
	-- function 10
	local _path = self._path

	if not _path and not self._final_goal_reached then
		self._current_transition = nil

		return
	end

	local _unit = self._unit
	local var_10_2 = POSITION_LOOKUP[_unit]
	local unbox = _path[self._path_index]:unbox()
	local unbox_2 = _path[self._path_index - 1]:unbox()

	if not self:_goal_reached(var_10_2, unbox, unbox_2, arg_10_1) then
		self._path_index = self._path_index + 1

		local flag = self._path_index > #_path

		self._final_goal_reached = flag

		if not flag then
			self._position_when_final_goal_reached:store(var_10_2)

			self._current_transition = nil
		else
			local unbox_3 = _path[self._path_index]:unbox()

			self:_reevaluate_current_nav_transition(_unit, var_10_2, unbox, unbox_3)
		end
	end
end

PlayerBotNavigation._reevaluate_current_nav_transition = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local _current_transition = self._current_transition

	self._current_transition = nil

	local var_11_1 = BLACKBOARDS[arg_11_1]

	var_11_1.breakable_object = nil

	local var_11_2
	local huge = math.huge

	for k, v in pairs(self._available_nav_transitions) do
		if v.type == "ladder" then
			local distance_squared = Vector3.distance_squared(arg_11_2, (v.from:unbox() + v.to:unbox()) * 0.5)

			if distance_squared < huge then
				huge = distance_squared
				var_11_2 = v
			end
		elseif v.type == "planks" then
			local unbox = v.from:unbox()
			local unbox_2 = v.to:unbox()
			local var_11_7

			if not fn(arg_11_3, unbox) and not fn(arg_11_4, unbox_2) then
				var_11_7 = "to"
			elseif not fn(arg_11_3, unbox_2) and not fn(arg_11_4, unbox) then
				var_11_7 = "from"
			end

			if not var_11_7 then
				v.goal = var_11_7
				self._current_transition = v
				var_11_1.breakable_object = v.unit

				if v ~= _current_transition then
					v.t = Managers.time:time("game")
				end

				return
			end
		else
			local unbox_3 = v.waypoint:unbox()
			local unbox_4 = v.from:unbox()
			local unbox_5 = v.to:unbox()
			local var_11_11

			if not fn(arg_11_3, unbox_4) and not fn(arg_11_4, unbox_3) then
				var_11_11 = "waypoint"
			elseif not fn(arg_11_3, unbox_3) and not fn(arg_11_4, unbox_5) then
				var_11_11 = "to"
			end

			if not var_11_11 then
				v.goal = var_11_11
				self._current_transition = v

				if v ~= _current_transition then
					v.t = Managers.time:time("game")
				end

				return
			end
		end
	end

	if not _current_transition and (_current_transition.type == "ladder" or not _current_transition.waypoint) and not fn(arg_11_3, _current_transition.waypoint:unbox()) and not fn(arg_11_4, _current_transition.to:unbox()) then
		_current_transition.goal = "to"
		self._current_transition = _current_transition

		return
	elseif not var_11_2 then
		self._current_transition = var_11_2

		if var_11_2 ~= _current_transition then
			var_11_2.t = Managers.time:time("game")
		end
	end
end

local num = 0.05
local num_2 = 0.25
local num_3 = 0.2
local num_4 = 0.25
local num_5 = (num_3 - num) / num_4

PlayerBotNavigation._goal_reached = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local num_4 = arg_12_2 - arg_12_1
	local num_6 = arg_12_2 - arg_12_3
	local flag = Vector3.dot(num_4, num_6) < 0
	local num_7 = arg_12_2 - arg_12_1
	local z = num_7.z
	local length = Vector3.length(Vector3.flat(num_7))
	local var_12_6 = num

	if not self._close_to_goal_time then
		var_12_6 = math.clamp(var_12_6 + (arg_12_4 - self._close_to_goal_time - num_2) * num_5, num, num_3)
	end

	local flag_2 = not (length < var_12_6) or not (z > -0.35) or z < 0.5
	local flag_3 = flag or flag_2

	if not flag_3 then
		self._close_to_goal_time = nil
	elseif not (not (length < num_3) or self._close_to_goal_time) then
		self._close_to_goal_time = arg_12_4
	end

	return flag_3
end

PlayerBotNavigation.current_goal = function (self)
	-- function 13
	if not self._final_goal_reached then
		return nil
	elseif not self._path then
		return self._path[self._path_index]:unbox()
	elseif not self._last_path then
		return self._last_path[self._last_path_index]:unbox()
	else
		return nil
	end
end

PlayerBotNavigation.is_following_last_goal = function (self)
	-- function 14
	if not self._final_goal_reached then
		return false
	elseif not self._path then
		return self._path_index == #self._path
	elseif not self._last_path then
		return self._last_path_index == #self._last_path
	else
		return false
	end
end

PlayerBotNavigation.destination_reached = function (self)
	-- function 15
	return self._final_goal_reached
end

PlayerBotNavigation._update_astar = function (self, arg_16_1)
	-- function 16
	local _astar = self._astar

	if not GwNavAStar.processing_finished(_astar) then
		if not GwNavAStar.path_found(_astar) then
			local node_count = GwNavAStar.node_count(_astar)

			fassert(node_count > 0, "Number of nodes in returned path is not greater than 0.")

			local node_at_index = GwNavAStar.node_at_index(_astar, node_count)
			local triangle_from_position, var_16_4 = GwNavQueries.triangle_from_position(self._nav_world, node_at_index, 0.3, 0.3, self._traverse_data)
			local var_16_5

			if not triangle_from_position then
				var_16_5 = Vector3Box(node_at_index.x, node_at_index.y, var_16_4)
			else
				var_16_5 = nil
			end

			if not (triangle_from_position or not (node_count <= 2)) then
				self:_path_failed(arg_16_1)
			else
				self._path = Script.new_array(node_count)

				self:_path_successful(arg_16_1)

				for i = 1, node_count - 1 do
					local node_at_index_2 = GwNavAStar.node_at_index(_astar, i)

					self._path[i] = Vector3Box(node_at_index_2)
				end

				self._path[node_count] = var_16_5
				self._path_index = 2
				self._close_to_goal_time = nil
			end
		else
			self:_path_failed(arg_16_1)
		end

		self._running_astar = false
		self._last_path = nil
		self._last_path_index = nil

		if not self._has_queued_target then
			self._has_queued_target = false

			self:move_to(self._queued_target_position:unbox(), self._queued_path_callback)

			self._queued_path_callback = nil
		end
	end
end

PlayerBotNavigation.path_callback = function (self)
	-- function 17
	return self._path_callback
end

PlayerBotNavigation._path_failed = function (self, arg_18_1)
	-- function 18
	if not script_data.debug_ai_movement then
		print("AI bot failed to find path")
	end

	self._successive_failed_paths = self._successive_failed_paths + 1

	local _path_callback = self._path_callback

	if not _path_callback then
		_path_callback(false, self._destination:unbox())
	end
end

PlayerBotNavigation._path_successful = function (self, arg_19_1)
	-- function 19
	self._last_successful_path = arg_19_1
	self._successive_failed_paths = 0

	local _path_callback = self._path_callback

	if not _path_callback then
		_path_callback(true, self._destination:unbox())
	end
end

PlayerBotNavigation.successive_failed_paths = function (self)
	-- function 20
	return self._successive_failed_paths, self._last_successful_path
end

PlayerBotNavigation.destination = function (self)
	-- function 21
	if not self._has_queued_target then
		return self._queued_target_position:unbox()
	else
		return self._destination:unbox()
	end
end

PlayerBotNavigation.position_when_destination_reached = function (self)
	-- function 22
	if not self._final_goal_reached then
		return self._position_when_final_goal_reached:unbox()
	else
		return nil
	end
end

PlayerBotNavigation._debug_draw_path = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	if not script_data.ai_bots_debug then
		local unbox = self._player.color:unbox()
		local drawer = Managers.state.debug:drawer(debug_drawer_info)

		drawer:vector(arg_23_2, arg_23_1 - arg_23_2, unbox)
		drawer:vector(arg_23_1, arg_23_3 - arg_23_1, unbox)

		local _path = self._path
		local count = #_path

		for i = 1, count - 1 do
			local unbox_2 = _path[i]:unbox()
			local unbox_3 = _path[i + 1]:unbox()

			drawer:vector(unbox_2, unbox_3 - unbox_2, unbox)

			local lerp = math.lerp(0.15, 0.3, (i - 1) / (count - 1))

			drawer:sphere(unbox_2, lerp, unbox)
		end

		local unbox_4 = _path[count]:unbox()
		local lerp_2 = math.lerp(0.15, 0.3, (count - 1) / (count - 1))

		drawer:sphere(unbox_4, lerp_2, unbox)
	end
end

PlayerBotNavigation.is_in_transition = function (self)
	-- function 24
	return self._current_transition ~= nil
end

PlayerBotNavigation.transition_type = function (self)
	-- function 25
	return self._current_transition.type
end

PlayerBotNavigation.transition_requires_jump = function (self, arg_26_1, arg_26_2)
	-- function 26
	local current_goal = self:current_goal()

	fassert(self._current_transition, "Trying to check if transition requires jump with no active transition")
	fassert(current_goal, "Current transition but no current goal?")

	local _current_transition = self._current_transition

	if not (_current_transition.type ~= "bot_leap_of_faith" or _current_transition.goal ~= "to" or not (Vector3.distance_squared(self._path[self._path_index - 1]:unbox(), arg_26_1) < 1)) then
		return true
	end

	return false
end

PlayerBotNavigation.flow_cb_entered_nav_transition = function (self, arg_27_1, arg_27_2)
	-- function 27
	local _available_nav_transitions = self._available_nav_transitions
	local get_data = Unit.get_data(arg_27_1, "bot_nav_transition_manager_index")
	local transition_data, var_27_3, var_27_4, var_27_5 = Managers.state.bot_nav_transition:transition_data(arg_27_1)
	local tbl = {
		type = transition_data,
		from = Vector3Box(var_27_3),
		to = Vector3Box(var_27_4)
	}

	if transition_data ~= "ladder" then
		tbl.waypoint = Vector3Box(var_27_5)
	end

	_available_nav_transitions[arg_27_1] = tbl

	if not (transition_data ~= "ladder" or self._current_transition) then
		self._current_transition = tbl
		tbl.t = Managers.time:time("game")
	end
end

PlayerBotNavigation.flow_cb_left_nav_transition = function (self, arg_28_1, arg_28_2)
	-- function 28
	local _available_nav_transitions = self._available_nav_transitions
	local get_data = Unit.get_data(arg_28_1, "bot_nav_transition_manager_index")

	_available_nav_transitions[arg_28_1] = nil
end

PlayerBotNavigation.traverse_logic = function (self)
	-- function 29
	return self._traverse_data
end

PlayerBotNavigation.add_transition = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	local tbl = {
		unit = arg_30_1,
		type = arg_30_2,
		from = Vector3Box(arg_30_3),
		to = Vector3Box(arg_30_4)
	}

	arg_30_0._available_nav_transitions[arg_30_1] = tbl
end

PlayerBotNavigation.remove_transition = function (arg_31_0, arg_31_1)
	-- function 31
	arg_31_0._available_nav_transitions[arg_31_1] = nil
end
