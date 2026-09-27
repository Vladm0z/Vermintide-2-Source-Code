-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_navigation_extension.lua

local num = 0.38
local script_data = script_data
local debug_ai_movement = script_data.debug_ai_movement

debug_ai_movement = debug_ai_movement or Development.parameter("debug_ai_movement")
script_data.debug_ai_movement = debug_ai_movement
AINavigationExtension = class(AINavigationExtension)

AINavigationExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._nav_world = arg_1_3.nav_world
	self._unit = arg_1_2
	self._enabled = true
	self._max_speed = 0
	self._movement_modifier = 1
	self._current_speed = 0
	self._wanted_destination = Vector3Box(Unit.local_position(arg_1_2, 0))
	self._destination = Vector3Box()
	self._using_smartobject = false
	self._next_smartobject_interval = GwNavSmartObjectInterval.create(self._nav_world)
	self._backup_destination = Vector3Box()
	self._original_backup_destination = Vector3Box()
	self._is_navbot_following_path = false
	self._is_computing_path = false
	self._failed_move_attempts = 0
	self._wait_timer = 0
	self._raycast_timer = 0

	local num = 8

	self._movement_modifiers = Script.new_array(num)
	self._num_movement_modifiers = 0
	self._movement_modifier_table_size = num
	self._last_movement_modifier_index = 1
end

AINavigationExtension.extensions_ready = function (self)
	-- function 2
	local var_2_0 = BLACKBOARDS[self._unit]

	self._blackboard = var_2_0
	var_2_0.next_smart_object_data = {
		entrance_pos = Vector3Box(),
		exit_pos = Vector3Box()
	}
	self._far_pathing_allowed = var_2_0.breed.cannot_far_path ~= true
end

AINavigationExtension.destroy = function (self)
	-- function 3
	self:release_bot()
	GwNavSmartObjectInterval.destroy(self._next_smartobject_interval)
	self:_destroy_reusable_astars()
	self:destroy_reusable_traverse_logic()
	self:_destroy_navtag_layer_cost_tables()
	self:_destroy_nav_cost_map_cost_tables()
end

AINavigationExtension.freeze = function (self)
	-- function 4
	self:release_bot()
end

AINavigationExtension.unfreeze = function (self)
	-- function 5
	local _blackboard = self._blackboard
	local next_smart_object_data = _blackboard.next_smart_object_data

	next_smart_object_data.next_smart_object_id = nil
	next_smart_object_data.smart_object_type = nil
	self._far_pathing_allowed = _blackboard.breed.cannot_far_path ~= true
	self._enabled = true
	self._using_smartobject = false
	self._is_navbot_following_path = false
	self._is_computing_path = false
	self._failed_move_attempts = 0
	self._wait_timer = 0
	self._raycast_timer = 0
	self._num_movement_modifiers = 0
	self._last_movement_modifier_index = 1
end

AINavigationExtension.set_far_pathing_allowed = function (self, arg_6_1)
	-- function 6
	self._far_pathing_allowed = arg_6_1
end

AINavigationExtension.release_bot = function (self)
	-- function 7
	if not self._nav_bot then
		GwNavBot.destroy(self._nav_bot)

		self._nav_bot = nil
	end

	self._traverse_logic = nil
end

local tbl = {
	half_height = 0.5,
	radius = 4,
	frame_delay = 45,
	enable_forcing = true,
	sample_count = 20,
	enable_stop = false,
	stop_wait_time_s = 1,
	enable_slowing = true,
	forcing_time_s = 1,
	angle_span = 75,
	time_to_collision = 1.25,
	forcing_wait_time_s = 0.2
}

AINavigationExtension.init_position = function (self)
	-- function 8
	local _unit = self._unit
	local _nav_world = self._nav_world
	local get_data = Unit.get_data(_unit, "breed")
	local num_2 = 1.6
	local run_speed = get_data.run_speed
	local local_position = Unit.local_position(_unit, 0)
	local flag = not not script_data.disable_crowd_dispersion or not get_data.disable_crowd_dispersion
	local tbl_2 = {}

	if not get_data.nav_cost_map_allowed_layers then
		table.merge(tbl_2, get_data.nav_cost_map_allowed_layers)
	end

	local nav_cost_map_cost_table = self:nav_cost_map_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(nav_cost_map_cost_table, tbl_2)

	local var_8_9 = GwNavBot.create(_nav_world, num_2, num, run_speed, local_position, nav_cost_map_cost_table, flag)

	fassert(self._nav_bot == nil, "Tried to create navbot but already had one, freeze bug?")

	self._nav_bot = var_8_9
	self._max_speed = run_speed

	self._destination:store(local_position)
	self._wanted_destination:store(local_position)

	self._is_avoiding = get_data.use_avoidance == true

	GwNavBot.set_use_avoidance(var_8_9, self._is_avoiding)

	if not self._is_avoiding then
		local avoidance_config = get_data.avoidance_config

		avoidance_config = avoidance_config or tbl

		GwNavBot.set_avoidance_behavior(var_8_9, avoidance_config.enable_slowing, avoidance_config.enable_forcing, avoidance_config.enable_stop, avoidance_config.stop_wait_time_s, avoidance_config.forcing_time_s, avoidance_config.forcing_wait_time_s)
		GwNavBot.set_avoidance_collider_collector_configuration(var_8_9, avoidance_config.half_height, avoidance_config.radius, avoidance_config.forcing_wait_time_s)
		GwNavBot.set_avoidance_computer_configuration(var_8_9, avoidance_config.angle_span, avoidance_config.time_to_collision, avoidance_config.sample_count)
	end

	if not get_data.ignore_nav_propagation_box then
		GwNavBot.set_propagation_box(var_8_9, 30)
	end

	local traverse_logic_data = GwNavBot.traverse_logic_data(var_8_9)

	fassert(self._traverse_logic == nil, "Tried to create _traverse_logic but already had one, freeze bug?")

	self._traverse_logic = traverse_logic_data

	local tbl_3 = {}

	if not get_data.allowed_layers then
		table.merge(tbl_3, get_data.allowed_layers)
	end

	table.merge(tbl_3, NAV_TAG_VOLUME_LAYER_COST_AI)

	local get_navtag_layer_cost_table = self:get_navtag_layer_cost_table()

	AiUtils.initialize_cost_table(get_navtag_layer_cost_table, tbl_3)
	GwNavBot.set_navtag_layer_cost_table(var_8_9, get_navtag_layer_cost_table)

	local _engine_extension_id = self._blackboard.locomotion_extension._engine_extension_id

	if not _engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_set_traverse_logic(_engine_extension_id, traverse_logic_data)
	end

	if not get_data.use_navigation_path_splines then
		local navigation_path_spline_config = get_data.navigation_path_spline_config
		local navigation_channel_radius

		if not navigation_path_spline_config then
			navigation_channel_radius = navigation_path_spline_config.navigation_channel_radius

			if not navigation_channel_radius then
				-- Nothing
			end
		end

		navigation_channel_radius = 4

		do
			local turn_sampling_angle
		end

		::label_8_0::

		if not navigation_path_spline_config then
			turn_sampling_angle = navigation_path_spline_config.turn_sampling_angle

			if not turn_sampling_angle then
				-- Nothing
			end
		end

		turn_sampling_angle = 30

		do
			local channel_smoothing_anle
		end

		::label_8_1::

		if not navigation_path_spline_config then
			channel_smoothing_anle = navigation_path_spline_config.channel_smoothing_anle

			if not channel_smoothing_anle then
				-- Nothing
			end
		end

		channel_smoothing_anle = 30

		do
			local min_distance_between_gates
		end

		::label_8_2::

		if not navigation_path_spline_config then
			min_distance_between_gates = navigation_path_spline_config.min_distance_between_gates

			if not min_distance_between_gates then
				-- Nothing
			end
		end

		min_distance_between_gates = 0.5

		do
			local max_distance_between_gates
		end

		::label_8_3::

		if not navigation_path_spline_config then
			max_distance_between_gates = navigation_path_spline_config.max_distance_between_gates

			if not max_distance_between_gates then
				-- Nothing
			end
		end

		max_distance_between_gates = 10

		::label_8_4::

		GwNavBot.set_channel_computer_configuration(var_8_9, navigation_channel_radius, turn_sampling_angle, channel_smoothing_anle, min_distance_between_gates, max_distance_between_gates)

		local flag_2 = false
		local max_distance_to_spline_position

		if not navigation_path_spline_config then
			max_distance_to_spline_position = navigation_path_spline_config.max_distance_to_spline_position

			if not max_distance_to_spline_position then
				-- Nothing
			end
		end

		max_distance_to_spline_position = 5

		do
			local spline_length
		end

		::label_8_5::

		if not navigation_path_spline_config then
			spline_length = navigation_path_spline_config.spline_length

			if not spline_length then
				-- Nothing
			end
		end

		spline_length = 100

		do
			local spline_distance_to_borders
		end

		::label_8_6::

		if not navigation_path_spline_config then
			spline_distance_to_borders = navigation_path_spline_config.spline_distance_to_borders

			if not spline_distance_to_borders then
				-- Nothing
			end
		end

		spline_distance_to_borders = 1

		do
			local spline_recomputation_ratio
		end

		::label_8_7::

		if not navigation_path_spline_config then
			spline_recomputation_ratio = navigation_path_spline_config.spline_recomputation_ratio

			if not spline_recomputation_ratio then
				-- Nothing
			end
		end

		spline_recomputation_ratio = 1

		::label_8_8::

		local num_3 = 0

		GwNavBot.set_spline_trajectory_configuration(var_8_9, flag_2, max_distance_to_spline_position, spline_length, spline_distance_to_borders, spline_recomputation_ratio, num_3)

		if not get_data.deactivate_navigation_path_splines_on_spawn then
			GwNavBot.set_use_channel(var_8_9, true)
		end
	end
end

AINavigationExtension.traverse_logic = function (self)
	-- function 9
	return self._traverse_logic
end

AINavigationExtension.nav_world = function (self)
	-- function 10
	return self._nav_world
end

AINavigationExtension.desired_velocity = function (self)
	-- function 11
	return GwNavBot.output_velocity(self._nav_bot)
end

AINavigationExtension.set_enabled = function (self, arg_12_1)
	-- function 12
	if self._nav_bot == nil then
		return
	end

	local _enabled = self._enabled

	self._enabled = arg_12_1

	if not arg_12_1 then
		self._is_navbot_following_path = false
	end

	if not (not arg_12_1 and _enabled) then
		local local_position = Unit.local_position(self._unit, 0)

		GwNavBot.update_position(self._nav_bot, local_position)
	end
end

AINavigationExtension.set_avoidance_enabled = function (self, arg_13_1)
	-- function 13
	if self._nav_bot == nil then
		return
	end

	self._is_avoiding = arg_13_1

	GwNavBot.set_use_avoidance(self._nav_bot, arg_13_1)
end

AINavigationExtension.add_movement_modifier = function (self, arg_14_1)
	-- function 14
	fassert(arg_14_1, "[AINavigationExtension] Trying to set invalid modifier")

	local _movement_modifier_table_size = self._movement_modifier_table_size
	local _num_movement_modifiers = self._num_movement_modifiers

	if _movement_modifier_table_size <= _num_movement_modifiers then
		_movement_modifier_table_size = _movement_modifier_table_size * 2

		if BUILD == "dev" then
			fassert(false, "[AINavigationExtension] More than %i movement modifers at the same time", self._movement_modifier_table_size)
		else
			printf("[AINavigationExtension] Doubled size of movement modifiers for %s to %i", tostring(self._unit), _movement_modifier_table_size)
		end

		self._movement_modifier_table_size = _movement_modifier_table_size
	end

	local _movement_modifiers = self._movement_modifiers
	local _last_movement_modifier_index = self._last_movement_modifier_index

	while not _movement_modifiers[_last_movement_modifier_index] do
		_last_movement_modifier_index = _last_movement_modifier_index % _movement_modifier_table_size + 1
	end

	_movement_modifiers[_last_movement_modifier_index] = arg_14_1
	self._num_movement_modifiers = _num_movement_modifiers + 1
	self._last_movement_modifier_index = _last_movement_modifier_index

	self:_recalculate_max_speed()

	return _last_movement_modifier_index
end

AINavigationExtension.remove_movement_modifier = function (self, arg_15_1)
	-- function 15
	local _movement_modifiers = self._movement_modifiers

	fassert(_movement_modifiers[arg_15_1], "[AINavigationExtension] Trying to remove unexisting modifier with id %i", arg_15_1)

	_movement_modifiers[arg_15_1] = nil
	self._num_movement_modifiers = self._num_movement_modifiers - 1

	self:_recalculate_max_speed()
end

AINavigationExtension._recalculate_max_speed = function (self)
	-- function 16
	if self._nav_bot == nil then
		return
	end

	local num = 1
	local _movement_modifiers = self._movement_modifiers

	for i = 1, self._movement_modifier_table_size do
		local var_16_2 = _movement_modifiers[i]

		if not var_16_2 then
			num = var_16_2 * num
		end
	end

	self._movement_modifier = num

	GwNavBot.set_max_desired_linear_speed(self._nav_bot, num * self._max_speed)
end

AINavigationExtension.set_max_speed = function (self, arg_17_1)
	-- function 17
	if self._max_speed == arg_17_1 then
		return
	end

	self._max_speed = arg_17_1

	self:_recalculate_max_speed()
end

AINavigationExtension.get_movement_modifier = function (self)
	-- function 18
	return self._movement_modifier
end

AINavigationExtension.get_max_speed = function (self)
	-- function 19
	return self._max_speed
end

AINavigationExtension.set_navbot_position = function (self, arg_20_1)
	-- function 20
	if self._nav_bot == nil then
		return
	end

	GwNavBot.update_position(self._nav_bot, arg_20_1)
end

AINavigationExtension.move_to = function (self, arg_21_1)
	-- function 21
	if self._nav_bot == nil then
		return
	end

	if not self._blackboard.far_path then
		self._backup_destination:store(arg_21_1)

		return
	end

	self._wanted_destination:store(arg_21_1)

	self._failed_move_attempts = 0
end

AINavigationExtension.stop = function (self)
	-- function 22
	local _unit = self._unit
	local var_22_1 = POSITION_LOOKUP[_unit]

	self._wanted_destination:store(var_22_1)
	self._destination:store(var_22_1)

	self._failed_move_attempts = 0
	self._has_started_pathfind = nil

	local _blackboard = self._blackboard

	_blackboard.far_path = nil
	_blackboard.current_far_path_index = nil
	_blackboard.num_far_path_nodes = nil

	local _nav_bot = self._nav_bot

	if not self._is_computing_path then
		GwNavBot.cancel_async_path_computation(_nav_bot)
	end

	GwNavBot.clear_followed_path(_nav_bot)
end

AINavigationExtension.number_failed_move_attempts = function (self)
	-- function 23
	return self._failed_move_attempts
end

AINavigationExtension.is_following_path = function (self)
	-- function 24
	return self._is_navbot_following_path
end

AINavigationExtension.is_computing_path = function (self)
	-- function 25
	return self._is_computing_path
end

AINavigationExtension.reset_destination = function (self, arg_26_1)
	-- function 26
	if self._nav_bot == nil then
		return
	end

	local _unit = self._unit
	local flag = arg_26_1 or POSITION_LOOKUP[_unit]

	self._wanted_destination:store(flag)
	self._destination:store(flag)

	self._failed_move_attempts = 0

	local _blackboard = self._blackboard

	_blackboard.far_path = nil
	_blackboard.current_far_path_index = nil
	_blackboard.num_far_path_nodes = nil

	GwNavBot.compute_new_path(self._nav_bot, flag)
end

AINavigationExtension.destination = function (self)
	-- function 27
	if not self._blackboard.far_path then
		return self._backup_destination:unbox()
	else
		return self._wanted_destination:unbox()
	end
end

AINavigationExtension.distance_to_destination = function (self, arg_28_1)
	-- function 28
	arg_28_1 = arg_28_1 or Unit.local_position(self._unit, 0)

	local destination = self:destination()

	return Vector3.distance(arg_28_1, destination)
end

AINavigationExtension.distance_to_destination_sq = function (self, arg_29_1)
	-- function 29
	arg_29_1 = arg_29_1 or Unit.local_position(self._unit, 0)

	local destination = self:destination()

	return Vector3.distance_squared(arg_29_1, destination)
end

local num_2 = 0.3

AINavigationExtension.has_reached_destination = function (self, arg_30_1)
	-- function 30
	return (arg_30_1 or num_2)^2 > self:distance_to_destination_sq()
end

AINavigationExtension.next_smart_object_data = function (self)
	-- function 31
	return self._next_smart_object_data
end

AINavigationExtension.use_smart_object = function (self, arg_32_1)
	-- function 32
	if self._nav_bot == nil then
		return
	end

	local var_32_0

	if not arg_32_1 then
		fassert(self._blackboard.next_smart_object_data.next_smart_object_id ~= nil, "Tried to use smart object with a nil smart object id")

		var_32_0 = GwNavBot.enter_manual_control(self._nav_bot, self._next_smartobject_interval)

		if not var_32_0 then
			-- Nothing
		end
	else
		var_32_0 = GwNavBot.exit_manual_control(self._nav_bot)

		if not var_32_0 then
			GwNavBot.clear_followed_path(self._nav_bot)
		end
	end

	self._using_smartobject = not arg_32_1 and var_32_0

	return var_32_0
end

AINavigationExtension.is_using_smart_object = function (self)
	-- function 33
	return self._using_smartobject
end

AINavigationExtension.allow_layer = function (self, arg_34_1, arg_34_2)
	-- function 34
	if self._nav_bot == nil then
		return
	end

	local get_navtag_layer_cost_table = self:get_navtag_layer_cost_table()
	local var_34_1 = LAYER_ID_MAPPING[arg_34_1]

	if not arg_34_2 then
		GwNavTagLayerCostTable.allow_layer(get_navtag_layer_cost_table, var_34_1)
	else
		GwNavTagLayerCostTable.forbid_layer(get_navtag_layer_cost_table, var_34_1)
	end
end

AINavigationExtension.set_layer_cost = function (self, arg_35_1, arg_35_2)
	-- function 35
	if self._nav_bot == nil then
		return
	end

	local var_35_0 = LAYER_ID_MAPPING[arg_35_1]

	GwNavTagLayerCostTable.set_layer_cost_multiplier(self:get_navtag_layer_cost_table(), var_35_0, arg_35_2)
end

AINavigationExtension.nav_cost_map_cost_table = function (self, arg_36_1)
	-- function 36
	local flag = arg_36_1 or "_default"
	local _nav_cost_map_cost_tables = self._nav_cost_map_cost_tables

	_nav_cost_map_cost_tables = _nav_cost_map_cost_tables or {}
	self._nav_cost_map_cost_tables = _nav_cost_map_cost_tables

	local _nav_cost_map_cost_tables_2 = self._nav_cost_map_cost_tables
	local var_36_3 = self._nav_cost_map_cost_tables[flag]

	var_36_3 = var_36_3 or GwNavCostMap.create_tag_cost_table()
	_nav_cost_map_cost_tables_2[flag] = var_36_3

	return self._nav_cost_map_cost_tables[flag]
end

AINavigationExtension.get_navtag_layer_cost_table = function (self, arg_37_1)
	-- function 37
	local flag = arg_37_1 or "_default"
	local _navtag_layer_cost_tables = self._navtag_layer_cost_tables

	_navtag_layer_cost_tables = _navtag_layer_cost_tables or {}
	self._navtag_layer_cost_tables = _navtag_layer_cost_tables

	local _navtag_layer_cost_tables_2 = self._navtag_layer_cost_tables
	local var_37_3 = self._navtag_layer_cost_tables[flag]

	var_37_3 = var_37_3 or GwNavTagLayerCostTable.create()
	_navtag_layer_cost_tables_2[flag] = var_37_3

	return self._navtag_layer_cost_tables[flag]
end

AINavigationExtension.get_current_and_next_node_positions_in_nav_path = function (self)
	-- function 38
	local _nav_bot = self._nav_bot

	if _nav_bot == nil then
		return nil, nil
	end

	if not self._is_navbot_following_path then
		return nil, nil
	end

	local get_path_nodes_count = GwNavBot.get_path_nodes_count(_nav_bot)

	if get_path_nodes_count < 1 then
		return nil, nil
	end

	local get_path_current_node_index = GwNavBot.get_path_current_node_index(_nav_bot)
	local get_path_node_pos = GwNavBot.get_path_node_pos(_nav_bot, get_path_current_node_index)
	local num = get_path_current_node_index + 1

	if num == get_path_nodes_count then
		return get_path_node_pos, nil
	end

	local get_path_node_pos_2 = GwNavBot.get_path_node_pos(_nav_bot, num)
	local num_2 = get_path_current_node_index + 2

	if num_2 == get_path_nodes_count then
		return get_path_node_pos, get_path_node_pos_2
	end

	local get_path_node_pos_3 = GwNavBot.get_path_node_pos(_nav_bot, num_2)

	return get_path_node_pos, get_path_node_pos_2, get_path_node_pos_3
end

AINavigationExtension.get_current_and_node_position_in_nav_path = function (self, arg_39_1)
	-- function 39
	local _nav_bot = self._nav_bot

	if _nav_bot == nil then
		return nil, nil
	end

	if not self._is_navbot_following_path then
		return nil, nil
	end

	local get_path_nodes_count = GwNavBot.get_path_nodes_count(_nav_bot)

	if get_path_nodes_count < 1 then
		return nil, nil
	end

	local get_path_current_node_index = GwNavBot.get_path_current_node_index(_nav_bot)
	local get_path_node_pos = GwNavBot.get_path_node_pos(_nav_bot, get_path_current_node_index)
	local num = get_path_current_node_index + arg_39_1

	if get_path_nodes_count <= num then
		num = get_path_nodes_count

		return nil, nil
	end

	local get_path_node_pos_2 = GwNavBot.get_path_node_pos(_nav_bot, num)

	return get_path_node_pos, get_path_node_pos_2
end

AINavigationExtension.get_path_node_count = function (self)
	-- function 40
	local _nav_bot = self._nav_bot

	if _nav_bot == nil then
		return 0
	end

	if not self._is_navbot_following_path then
		return 0
	end

	return (GwNavBot.get_path_nodes_count(_nav_bot))
end

AINavigationExtension.get_remaining_distance_from_progress_to_end_of_path = function (self)
	-- function 41
	local _nav_bot = self._nav_bot

	if _nav_bot == nil then
		return
	end

	if not self._is_navbot_following_path then
		return
	end

	return (GwNavBot.get_remaining_distance_from_progress_to_end_of_path(_nav_bot))
end

AINavigationExtension.get_reusable_astar = function (self, arg_42_1, arg_42_2)
	-- function 42
	if not self._reusable_astars then
		self._reusable_astars = {}
	end

	if not (arg_42_2 or self._reusable_astars[arg_42_1]) then
		self._reusable_astars[arg_42_1] = GwNavAStar.create()
	end

	return self._reusable_astars[arg_42_1]
end

AINavigationExtension.destroy_reusable_astar = function (self, arg_43_1)
	-- function 43
	local var_43_0 = self._reusable_astars[arg_43_1]

	GwNavAStar.destroy(var_43_0)

	self._reusable_astars[arg_43_1] = nil
end

AINavigationExtension._destroy_reusable_astars = function (self)
	-- function 44
	if not self._reusable_astars then
		return
	end

	for k in pairs(self._reusable_astars) do
		self:destroy_reusable_astar(k)
	end

	self._reusable_astars = nil
end

AINavigationExtension._destroy_navtag_layer_cost_tables = function (self)
	-- function 45
	if not self._navtag_layer_cost_tables then
		return
	end

	for k, v in pairs(self._navtag_layer_cost_tables) do
		GwNavTagLayerCostTable.destroy(v)
	end

	self._navtag_layer_cost_tables = nil
end

AINavigationExtension._destroy_nav_cost_map_cost_tables = function (self)
	-- function 46
	if not self._nav_cost_map_cost_tables then
		return
	end

	for k, v in pairs(self._nav_cost_map_cost_tables) do
		GwNavCostMap.destroy_tag_cost_table(v)
	end

	self._nav_cost_map_cost_tables = nil
end

AINavigationExtension.get_reusable_traverse_logic = function (self, arg_47_1, arg_47_2)
	-- function 47
	local _reusable_traverse_logics = self._reusable_traverse_logics

	_reusable_traverse_logics = _reusable_traverse_logics or {}
	self._reusable_traverse_logics = _reusable_traverse_logics

	local _reusable_traverse_logics_2 = self._reusable_traverse_logics
	local var_47_2 = self._reusable_traverse_logics[arg_47_1]

	var_47_2 = var_47_2 or GwNavTraverseLogic.create(self._nav_world, arg_47_2)
	_reusable_traverse_logics_2[arg_47_1] = var_47_2

	return self._reusable_traverse_logics[arg_47_1]
end

AINavigationExtension.destroy_reusable_traverse_logic = function (self)
	-- function 48
	if not self._reusable_traverse_logics then
		return
	end

	for k, v in pairs(self._reusable_traverse_logics) do
		GwNavTraverseLogic.destroy(v)
	end

	self._reusable_traverse_logics = nil
end
