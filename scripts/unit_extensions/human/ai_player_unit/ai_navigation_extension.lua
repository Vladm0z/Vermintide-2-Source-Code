-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_navigation_extension.lua

local var_0_0 = 0.38

script_data.debug_ai_movement = script_data.debug_ai_movement or Development.parameter("debug_ai_movement")
AINavigationExtension = class(AINavigationExtension)

AINavigationExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._nav_world = arg_1_3.nav_world
	arg_1_0._unit = arg_1_2
	arg_1_0._enabled = true
	arg_1_0._max_speed = 0
	arg_1_0._movement_modifier = 1
	arg_1_0._current_speed = 0
	arg_1_0._wanted_destination = Vector3Box(Unit.local_position(arg_1_2, 0))
	arg_1_0._destination = Vector3Box()
	arg_1_0._using_smartobject = false
	arg_1_0._next_smartobject_interval = GwNavSmartObjectInterval.create(arg_1_0._nav_world)
	arg_1_0._backup_destination = Vector3Box()
	arg_1_0._original_backup_destination = Vector3Box()
	arg_1_0._is_navbot_following_path = false
	arg_1_0._is_computing_path = false
	arg_1_0._failed_move_attempts = 0
	arg_1_0._wait_timer = 0
	arg_1_0._raycast_timer = 0

	local var_1_0 = 8

	arg_1_0._movement_modifiers = Script.new_array(var_1_0)
	arg_1_0._num_movement_modifiers = 0
	arg_1_0._movement_modifier_table_size = var_1_0
	arg_1_0._last_movement_modifier_index = 1
end

AINavigationExtension.extensions_ready = function (arg_2_0)
	local var_2_0 = BLACKBOARDS[arg_2_0._unit]

	arg_2_0._blackboard = var_2_0
	var_2_0.next_smart_object_data = {
		entrance_pos = Vector3Box(),
		exit_pos = Vector3Box()
	}
	arg_2_0._far_pathing_allowed = var_2_0.breed.cannot_far_path ~= true
end

AINavigationExtension.destroy = function (arg_3_0)
	arg_3_0:release_bot()
	GwNavSmartObjectInterval.destroy(arg_3_0._next_smartobject_interval)
	arg_3_0:_destroy_reusable_astars()
	arg_3_0:destroy_reusable_traverse_logic()
	arg_3_0:_destroy_navtag_layer_cost_tables()
	arg_3_0:_destroy_nav_cost_map_cost_tables()
end

AINavigationExtension.freeze = function (arg_4_0)
	arg_4_0:release_bot()
end

AINavigationExtension.unfreeze = function (arg_5_0)
	local var_5_0 = arg_5_0._blackboard
	local var_5_1 = var_5_0.next_smart_object_data

	var_5_1.next_smart_object_id = nil
	var_5_1.smart_object_type = nil
	arg_5_0._far_pathing_allowed = var_5_0.breed.cannot_far_path ~= true
	arg_5_0._enabled = true
	arg_5_0._using_smartobject = false
	arg_5_0._is_navbot_following_path = false
	arg_5_0._is_computing_path = false
	arg_5_0._failed_move_attempts = 0
	arg_5_0._wait_timer = 0
	arg_5_0._raycast_timer = 0
	arg_5_0._num_movement_modifiers = 0
	arg_5_0._last_movement_modifier_index = 1
end

AINavigationExtension.set_far_pathing_allowed = function (arg_6_0, arg_6_1)
	arg_6_0._far_pathing_allowed = arg_6_1
end

AINavigationExtension.release_bot = function (arg_7_0)
	if arg_7_0._nav_bot then
		GwNavBot.destroy(arg_7_0._nav_bot)

		arg_7_0._nav_bot = nil
	end

	arg_7_0._traverse_logic = nil
end

local var_0_1 = {
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

AINavigationExtension.init_position = function (arg_8_0)
	local var_8_0 = arg_8_0._unit
	local var_8_1 = arg_8_0._nav_world
	local var_8_2 = Unit.get_data(var_8_0, "breed")
	local var_8_3 = 1.6
	local var_8_4 = var_8_2.run_speed
	local var_8_5 = Unit.local_position(var_8_0, 0)
	local var_8_6 = not script_data.disable_crowd_dispersion and not var_8_2.disable_crowd_dispersion
	local var_8_7 = {}

	if var_8_2.nav_cost_map_allowed_layers then
		table.merge(var_8_7, var_8_2.nav_cost_map_allowed_layers)
	end

	local var_8_8 = arg_8_0:nav_cost_map_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(var_8_8, var_8_7)

	local var_8_9 = GwNavBot.create(var_8_1, var_8_3, var_0_0, var_8_4, var_8_5, var_8_8, var_8_6)

	fassert(arg_8_0._nav_bot == nil, "Tried to create navbot but already had one, freeze bug?")

	arg_8_0._nav_bot = var_8_9
	arg_8_0._max_speed = var_8_4

	arg_8_0._destination:store(var_8_5)
	arg_8_0._wanted_destination:store(var_8_5)

	arg_8_0._is_avoiding = var_8_2.use_avoidance == true

	GwNavBot.set_use_avoidance(var_8_9, arg_8_0._is_avoiding)

	if arg_8_0._is_avoiding then
		local var_8_10 = var_8_2.avoidance_config or var_0_1

		GwNavBot.set_avoidance_behavior(var_8_9, var_8_10.enable_slowing, var_8_10.enable_forcing, var_8_10.enable_stop, var_8_10.stop_wait_time_s, var_8_10.forcing_time_s, var_8_10.forcing_wait_time_s)
		GwNavBot.set_avoidance_collider_collector_configuration(var_8_9, var_8_10.half_height, var_8_10.radius, var_8_10.forcing_wait_time_s)
		GwNavBot.set_avoidance_computer_configuration(var_8_9, var_8_10.angle_span, var_8_10.time_to_collision, var_8_10.sample_count)
	end

	if not var_8_2.ignore_nav_propagation_box then
		GwNavBot.set_propagation_box(var_8_9, 30)
	end

	local var_8_11 = GwNavBot.traverse_logic_data(var_8_9)

	fassert(arg_8_0._traverse_logic == nil, "Tried to create _traverse_logic but already had one, freeze bug?")

	arg_8_0._traverse_logic = var_8_11

	local var_8_12 = {}

	if var_8_2.allowed_layers then
		table.merge(var_8_12, var_8_2.allowed_layers)
	end

	table.merge(var_8_12, NAV_TAG_VOLUME_LAYER_COST_AI)

	local var_8_13 = arg_8_0:get_navtag_layer_cost_table()

	AiUtils.initialize_cost_table(var_8_13, var_8_12)
	GwNavBot.set_navtag_layer_cost_table(var_8_9, var_8_13)

	local var_8_14 = arg_8_0._blackboard.locomotion_extension._engine_extension_id

	if var_8_14 then
		EngineOptimizedExtensions.ai_locomotion_set_traverse_logic(var_8_14, var_8_11)
	end

	if var_8_2.use_navigation_path_splines then
		local var_8_15 = var_8_2.navigation_path_spline_config
		local var_8_16 = var_8_15 and var_8_15.navigation_channel_radius or 4
		local var_8_17 = var_8_15 and var_8_15.turn_sampling_angle or 30
		local var_8_18 = var_8_15 and var_8_15.channel_smoothing_anle or 30
		local var_8_19 = var_8_15 and var_8_15.min_distance_between_gates or 0.5
		local var_8_20 = var_8_15 and var_8_15.max_distance_between_gates or 10

		GwNavBot.set_channel_computer_configuration(var_8_9, var_8_16, var_8_17, var_8_18, var_8_19, var_8_20)

		local var_8_21 = false
		local var_8_22 = var_8_15 and var_8_15.max_distance_to_spline_position or 5
		local var_8_23 = var_8_15 and var_8_15.spline_length or 100
		local var_8_24 = var_8_15 and var_8_15.spline_distance_to_borders or 1
		local var_8_25 = var_8_15 and var_8_15.spline_recomputation_ratio or 1
		local var_8_26 = 0

		GwNavBot.set_spline_trajectory_configuration(var_8_9, var_8_21, var_8_22, var_8_23, var_8_24, var_8_25, var_8_26)

		if not var_8_2.deactivate_navigation_path_splines_on_spawn then
			GwNavBot.set_use_channel(var_8_9, true)
		end
	end
end

AINavigationExtension.traverse_logic = function (arg_9_0)
	return arg_9_0._traverse_logic
end

AINavigationExtension.nav_world = function (arg_10_0)
	return arg_10_0._nav_world
end

AINavigationExtension.desired_velocity = function (arg_11_0)
	return GwNavBot.output_velocity(arg_11_0._nav_bot)
end

AINavigationExtension.set_enabled = function (arg_12_0, arg_12_1)
	if arg_12_0._nav_bot == nil then
		return
	end

	local var_12_0 = arg_12_0._enabled

	arg_12_0._enabled = arg_12_1

	if not arg_12_1 then
		arg_12_0._is_navbot_following_path = false
	end

	if arg_12_1 and not var_12_0 then
		local var_12_1 = Unit.local_position(arg_12_0._unit, 0)

		GwNavBot.update_position(arg_12_0._nav_bot, var_12_1)
	end
end

AINavigationExtension.set_avoidance_enabled = function (arg_13_0, arg_13_1)
	if arg_13_0._nav_bot == nil then
		return
	end

	arg_13_0._is_avoiding = arg_13_1

	GwNavBot.set_use_avoidance(arg_13_0._nav_bot, arg_13_1)
end

AINavigationExtension.add_movement_modifier = function (arg_14_0, arg_14_1)
	fassert(arg_14_1, "[AINavigationExtension] Trying to set invalid modifier")

	local var_14_0 = arg_14_0._movement_modifier_table_size
	local var_14_1 = arg_14_0._num_movement_modifiers

	if var_14_0 <= var_14_1 then
		var_14_0 = var_14_0 * 2

		if BUILD == "dev" then
			fassert(false, "[AINavigationExtension] More than %i movement modifers at the same time", arg_14_0._movement_modifier_table_size)
		else
			printf("[AINavigationExtension] Doubled size of movement modifiers for %s to %i", tostring(arg_14_0._unit), var_14_0)
		end

		arg_14_0._movement_modifier_table_size = var_14_0
	end

	local var_14_2 = arg_14_0._movement_modifiers
	local var_14_3 = arg_14_0._last_movement_modifier_index

	while var_14_2[var_14_3] do
		var_14_3 = var_14_3 % var_14_0 + 1
	end

	var_14_2[var_14_3] = arg_14_1
	arg_14_0._num_movement_modifiers = var_14_1 + 1
	arg_14_0._last_movement_modifier_index = var_14_3

	arg_14_0:_recalculate_max_speed()

	return var_14_3
end

AINavigationExtension.remove_movement_modifier = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._movement_modifiers

	fassert(var_15_0[arg_15_1], "[AINavigationExtension] Trying to remove unexisting modifier with id %i", arg_15_1)

	var_15_0[arg_15_1] = nil
	arg_15_0._num_movement_modifiers = arg_15_0._num_movement_modifiers - 1

	arg_15_0:_recalculate_max_speed()
end

AINavigationExtension._recalculate_max_speed = function (arg_16_0)
	if arg_16_0._nav_bot == nil then
		return
	end

	local var_16_0 = 1
	local var_16_1 = arg_16_0._movement_modifiers

	for iter_16_0 = 1, arg_16_0._movement_modifier_table_size do
		local var_16_2 = var_16_1[iter_16_0]

		if var_16_2 then
			var_16_0 = var_16_2 * var_16_0
		end
	end

	arg_16_0._movement_modifier = var_16_0

	GwNavBot.set_max_desired_linear_speed(arg_16_0._nav_bot, var_16_0 * arg_16_0._max_speed)
end

AINavigationExtension.set_max_speed = function (arg_17_0, arg_17_1)
	if arg_17_0._max_speed == arg_17_1 then
		return
	end

	arg_17_0._max_speed = arg_17_1

	arg_17_0:_recalculate_max_speed()
end

AINavigationExtension.get_movement_modifier = function (arg_18_0)
	return arg_18_0._movement_modifier
end

AINavigationExtension.get_max_speed = function (arg_19_0)
	return arg_19_0._max_speed
end

AINavigationExtension.set_navbot_position = function (arg_20_0, arg_20_1)
	if arg_20_0._nav_bot == nil then
		return
	end

	GwNavBot.update_position(arg_20_0._nav_bot, arg_20_1)
end

AINavigationExtension.move_to = function (arg_21_0, arg_21_1)
	if arg_21_0._nav_bot == nil then
		return
	end

	if arg_21_0._blackboard.far_path then
		arg_21_0._backup_destination:store(arg_21_1)

		return
	end

	arg_21_0._wanted_destination:store(arg_21_1)

	arg_21_0._failed_move_attempts = 0
end

AINavigationExtension.stop = function (arg_22_0)
	local var_22_0 = arg_22_0._unit
	local var_22_1 = POSITION_LOOKUP[var_22_0]

	arg_22_0._wanted_destination:store(var_22_1)
	arg_22_0._destination:store(var_22_1)

	arg_22_0._failed_move_attempts = 0
	arg_22_0._has_started_pathfind = nil

	local var_22_2 = arg_22_0._blackboard

	var_22_2.far_path = nil
	var_22_2.current_far_path_index = nil
	var_22_2.num_far_path_nodes = nil

	local var_22_3 = arg_22_0._nav_bot

	if arg_22_0._is_computing_path then
		GwNavBot.cancel_async_path_computation(var_22_3)
	end

	GwNavBot.clear_followed_path(var_22_3)
end

AINavigationExtension.number_failed_move_attempts = function (arg_23_0)
	return arg_23_0._failed_move_attempts
end

AINavigationExtension.is_following_path = function (arg_24_0)
	return arg_24_0._is_navbot_following_path
end

AINavigationExtension.is_computing_path = function (arg_25_0)
	return arg_25_0._is_computing_path
end

AINavigationExtension.reset_destination = function (arg_26_0, arg_26_1)
	if arg_26_0._nav_bot == nil then
		return
	end

	local var_26_0 = arg_26_0._unit
	local var_26_1 = arg_26_1 or POSITION_LOOKUP[var_26_0]

	arg_26_0._wanted_destination:store(var_26_1)
	arg_26_0._destination:store(var_26_1)

	arg_26_0._failed_move_attempts = 0

	local var_26_2 = arg_26_0._blackboard

	var_26_2.far_path = nil
	var_26_2.current_far_path_index = nil
	var_26_2.num_far_path_nodes = nil

	GwNavBot.compute_new_path(arg_26_0._nav_bot, var_26_1)
end

AINavigationExtension.destination = function (arg_27_0)
	if arg_27_0._blackboard.far_path then
		return arg_27_0._backup_destination:unbox()
	else
		return arg_27_0._wanted_destination:unbox()
	end
end

AINavigationExtension.distance_to_destination = function (arg_28_0, arg_28_1)
	arg_28_1 = arg_28_1 or Unit.local_position(arg_28_0._unit, 0)

	local var_28_0 = arg_28_0:destination()

	return Vector3.distance(arg_28_1, var_28_0)
end

AINavigationExtension.distance_to_destination_sq = function (arg_29_0, arg_29_1)
	arg_29_1 = arg_29_1 or Unit.local_position(arg_29_0._unit, 0)

	local var_29_0 = arg_29_0:destination()

	return Vector3.distance_squared(arg_29_1, var_29_0)
end

local var_0_2 = 0.3

AINavigationExtension.has_reached_destination = function (arg_30_0, arg_30_1)
	return (arg_30_1 or var_0_2)^2 > arg_30_0:distance_to_destination_sq()
end

AINavigationExtension.next_smart_object_data = function (arg_31_0)
	return arg_31_0._next_smart_object_data
end

AINavigationExtension.use_smart_object = function (arg_32_0, arg_32_1)
	if arg_32_0._nav_bot == nil then
		return
	end

	local var_32_0

	if arg_32_1 then
		fassert(arg_32_0._blackboard.next_smart_object_data.next_smart_object_id ~= nil, "Tried to use smart object with a nil smart object id")

		var_32_0 = GwNavBot.enter_manual_control(arg_32_0._nav_bot, arg_32_0._next_smartobject_interval)

		if not var_32_0 then
			-- Nothing
		end
	else
		var_32_0 = GwNavBot.exit_manual_control(arg_32_0._nav_bot)

		if not var_32_0 then
			GwNavBot.clear_followed_path(arg_32_0._nav_bot)
		end
	end

	arg_32_0._using_smartobject = arg_32_1 and var_32_0

	return var_32_0
end

AINavigationExtension.is_using_smart_object = function (arg_33_0)
	return arg_33_0._using_smartobject
end

AINavigationExtension.allow_layer = function (arg_34_0, arg_34_1, arg_34_2)
	if arg_34_0._nav_bot == nil then
		return
	end

	local var_34_0 = arg_34_0:get_navtag_layer_cost_table()
	local var_34_1 = LAYER_ID_MAPPING[arg_34_1]

	if arg_34_2 then
		GwNavTagLayerCostTable.allow_layer(var_34_0, var_34_1)
	else
		GwNavTagLayerCostTable.forbid_layer(var_34_0, var_34_1)
	end
end

AINavigationExtension.set_layer_cost = function (arg_35_0, arg_35_1, arg_35_2)
	if arg_35_0._nav_bot == nil then
		return
	end

	local var_35_0 = LAYER_ID_MAPPING[arg_35_1]

	GwNavTagLayerCostTable.set_layer_cost_multiplier(arg_35_0:get_navtag_layer_cost_table(), var_35_0, arg_35_2)
end

AINavigationExtension.nav_cost_map_cost_table = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_1 or "_default"

	arg_36_0._nav_cost_map_cost_tables = arg_36_0._nav_cost_map_cost_tables or {}
	arg_36_0._nav_cost_map_cost_tables[var_36_0] = arg_36_0._nav_cost_map_cost_tables[var_36_0] or GwNavCostMap.create_tag_cost_table()

	return arg_36_0._nav_cost_map_cost_tables[var_36_0]
end

AINavigationExtension.get_navtag_layer_cost_table = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_1 or "_default"

	arg_37_0._navtag_layer_cost_tables = arg_37_0._navtag_layer_cost_tables or {}
	arg_37_0._navtag_layer_cost_tables[var_37_0] = arg_37_0._navtag_layer_cost_tables[var_37_0] or GwNavTagLayerCostTable.create()

	return arg_37_0._navtag_layer_cost_tables[var_37_0]
end

AINavigationExtension.get_current_and_next_node_positions_in_nav_path = function (arg_38_0)
	local var_38_0 = arg_38_0._nav_bot

	if var_38_0 == nil then
		return nil, nil
	end

	if not arg_38_0._is_navbot_following_path then
		return nil, nil
	end

	local var_38_1 = GwNavBot.get_path_nodes_count(var_38_0)

	if var_38_1 < 1 then
		return nil, nil
	end

	local var_38_2 = GwNavBot.get_path_current_node_index(var_38_0)
	local var_38_3 = GwNavBot.get_path_node_pos(var_38_0, var_38_2)
	local var_38_4 = var_38_2 + 1

	if var_38_4 == var_38_1 then
		return var_38_3, nil
	end

	local var_38_5 = GwNavBot.get_path_node_pos(var_38_0, var_38_4)
	local var_38_6 = var_38_2 + 2

	if var_38_6 == var_38_1 then
		return var_38_3, var_38_5
	end

	local var_38_7 = GwNavBot.get_path_node_pos(var_38_0, var_38_6)

	return var_38_3, var_38_5, var_38_7
end

AINavigationExtension.get_current_and_node_position_in_nav_path = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0._nav_bot

	if var_39_0 == nil then
		return nil, nil
	end

	if not arg_39_0._is_navbot_following_path then
		return nil, nil
	end

	local var_39_1 = GwNavBot.get_path_nodes_count(var_39_0)

	if var_39_1 < 1 then
		return nil, nil
	end

	local var_39_2 = GwNavBot.get_path_current_node_index(var_39_0)
	local var_39_3 = GwNavBot.get_path_node_pos(var_39_0, var_39_2)
	local var_39_4 = var_39_2 + arg_39_1

	if var_39_1 <= var_39_4 then
		var_39_4 = var_39_1

		return nil, nil
	end

	local var_39_5 = GwNavBot.get_path_node_pos(var_39_0, var_39_4)

	return var_39_3, var_39_5
end

AINavigationExtension.get_path_node_count = function (arg_40_0)
	local var_40_0 = arg_40_0._nav_bot

	if var_40_0 == nil then
		return 0
	end

	if not arg_40_0._is_navbot_following_path then
		return 0
	end

	return (GwNavBot.get_path_nodes_count(var_40_0))
end

AINavigationExtension.get_remaining_distance_from_progress_to_end_of_path = function (arg_41_0)
	local var_41_0 = arg_41_0._nav_bot

	if var_41_0 == nil then
		return
	end

	if not arg_41_0._is_navbot_following_path then
		return
	end

	return (GwNavBot.get_remaining_distance_from_progress_to_end_of_path(var_41_0))
end

AINavigationExtension.get_reusable_astar = function (arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_0._reusable_astars then
		arg_42_0._reusable_astars = {}
	end

	if not arg_42_2 and not arg_42_0._reusable_astars[arg_42_1] then
		arg_42_0._reusable_astars[arg_42_1] = GwNavAStar.create()
	end

	return arg_42_0._reusable_astars[arg_42_1]
end

AINavigationExtension.destroy_reusable_astar = function (arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._reusable_astars[arg_43_1]

	GwNavAStar.destroy(var_43_0)

	arg_43_0._reusable_astars[arg_43_1] = nil
end

AINavigationExtension._destroy_reusable_astars = function (arg_44_0)
	if not arg_44_0._reusable_astars then
		return
	end

	for iter_44_0 in pairs(arg_44_0._reusable_astars) do
		arg_44_0:destroy_reusable_astar(iter_44_0)
	end

	arg_44_0._reusable_astars = nil
end

AINavigationExtension._destroy_navtag_layer_cost_tables = function (arg_45_0)
	if not arg_45_0._navtag_layer_cost_tables then
		return
	end

	for iter_45_0, iter_45_1 in pairs(arg_45_0._navtag_layer_cost_tables) do
		GwNavTagLayerCostTable.destroy(iter_45_1)
	end

	arg_45_0._navtag_layer_cost_tables = nil
end

AINavigationExtension._destroy_nav_cost_map_cost_tables = function (arg_46_0)
	if not arg_46_0._nav_cost_map_cost_tables then
		return
	end

	for iter_46_0, iter_46_1 in pairs(arg_46_0._nav_cost_map_cost_tables) do
		GwNavCostMap.destroy_tag_cost_table(iter_46_1)
	end

	arg_46_0._nav_cost_map_cost_tables = nil
end

AINavigationExtension.get_reusable_traverse_logic = function (arg_47_0, arg_47_1, arg_47_2)
	arg_47_0._reusable_traverse_logics = arg_47_0._reusable_traverse_logics or {}
	arg_47_0._reusable_traverse_logics[arg_47_1] = arg_47_0._reusable_traverse_logics[arg_47_1] or GwNavTraverseLogic.create(arg_47_0._nav_world, arg_47_2)

	return arg_47_0._reusable_traverse_logics[arg_47_1]
end

AINavigationExtension.destroy_reusable_traverse_logic = function (arg_48_0)
	if not arg_48_0._reusable_traverse_logics then
		return
	end

	for iter_48_0, iter_48_1 in pairs(arg_48_0._reusable_traverse_logics) do
		GwNavTraverseLogic.destroy(iter_48_1)
	end

	arg_48_0._reusable_traverse_logics = nil
end
