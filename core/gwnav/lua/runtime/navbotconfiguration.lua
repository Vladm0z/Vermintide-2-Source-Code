-- chunkname: @core/gwnav/lua/runtime/navbotconfiguration.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navhelpers")
local var_0_3 = stingray.Unit
local var_0_4 = stingray.GwNavTagLayerCostTable

var_0_1.get_configuration_value = function (arg_1_0, arg_1_1, ...)
	return var_0_2.unit_script_data(arg_1_0.unit, arg_1_1, ...)
end

var_0_1.init = function (arg_2_0, arg_2_1)
	arg_2_0.unit = arg_2_1
	arg_2_0.config_name = "GwNavBotConfiguration"
	arg_2_0.navtag_layer_cost_table = var_0_4.create()
	arg_2_0.height = arg_2_0:get_configuration_value(1.8, arg_2_0.config_name, "height")
	arg_2_0.radius = arg_2_0:get_configuration_value(0.4, arg_2_0.config_name, "radius")
	arg_2_0.speed = arg_2_0:get_configuration_value(5, arg_2_0.config_name, "speed")
	arg_2_0.enable_avoidance = arg_2_0:get_configuration_value(false, arg_2_0.config_name, "avoidance", "enable")
	arg_2_0.collider_collector_half_height = arg_2_0:get_configuration_value(5, arg_2_0.config_name, "avoidance", "collider_collector", "half_height")
	arg_2_0.collider_collector_radius = arg_2_0:get_configuration_value(30, arg_2_0.config_name, "avoidance", "collider_collector", "radius")
	arg_2_0.collider_collector_frame_delay = arg_2_0:get_configuration_value(15, arg_2_0.config_name, "avoidance", "collider_collector", "frame_delay")
	arg_2_0.avoidance_angle_span = arg_2_0:get_configuration_value(90, arg_2_0.config_name, "avoidance", "computer", "angle_span")
	arg_2_0.avoidance_minimal_time_to_collision = arg_2_0:get_configuration_value(3, arg_2_0.config_name, "avoidance", "computer", "minimal_time_to_collision")
	arg_2_0.avoidance_sample_count = arg_2_0:get_configuration_value(20, arg_2_0.config_name, "avoidance", "computer", "sample_count")
	arg_2_0.avoidance_enable_slowing_down = arg_2_0:get_configuration_value(true, arg_2_0.config_name, "avoidance", "behavior", "enable_slowing_down")
	arg_2_0.avoidance_enable_force_passage = arg_2_0:get_configuration_value(true, arg_2_0.config_name, "avoidance", "behavior", "enable_force_passage")
	arg_2_0.avoidance_enable_stop = arg_2_0:get_configuration_value(true, arg_2_0.config_name, "avoidance", "behavior", "enable_stop")
	arg_2_0.avoidance_stop_wait_time_s = arg_2_0:get_configuration_value(0.5, arg_2_0.config_name, "avoidance", "behavior", "stop_wait_time_s")
	arg_2_0.avoidance_force_passage_time_limit_s = arg_2_0:get_configuration_value(0.5, arg_2_0.config_name, "avoidance", "behavior", "force_passage_time_limit_s")
	arg_2_0.avoidance_wait_passage_time_limit_s = arg_2_0:get_configuration_value(1, arg_2_0.config_name, "avoidance", "behavior", "wait_passage_time_limit_s")
	arg_2_0.use_channel = arg_2_0:get_configuration_value(false, arg_2_0.config_name, "use_channel")
	arg_2_0.channel_radius = arg_2_0:get_configuration_value(4, arg_2_0.config_name, "channel", "channel_radius")
	arg_2_0.turn_sampling_angle = arg_2_0:get_configuration_value(30, arg_2_0.config_name, "channel", "turn_sampling_angle")
	arg_2_0.channel_smoothing_angle = arg_2_0:get_configuration_value(30, arg_2_0.config_name, "channel", "channel_smoothing_angle")
	arg_2_0.min_distance_between_gates = arg_2_0:get_configuration_value(0.5, arg_2_0.config_name, "channel", "min_distance_between_gates")
	arg_2_0.max_distance_between_gates = arg_2_0:get_configuration_value(10, arg_2_0.config_name, "channel", "max_distance_between_gates")
	arg_2_0.animation_driven = arg_2_0:get_configuration_value(true, arg_2_0.config_name, "splinetrajectory", "animation_driven")
	arg_2_0.max_distance_to_spline_position = arg_2_0:get_configuration_value(0.3, arg_2_0.config_name, "splinetrajectory", "max_distance_to_spline_position")
	arg_2_0.spline_length = arg_2_0:get_configuration_value(100, arg_2_0.config_name, "splinetrajectory", "spline_length")
	arg_2_0.spline_distance_to_borders = arg_2_0:get_configuration_value(0.2, arg_2_0.config_name, "splinetrajectory", "spline_distance_to_borders")
	arg_2_0.spline_recomputation_distance = arg_2_0:get_configuration_value(0.3, arg_2_0.config_name, "splinetrajectory", "spline_recomputation_distance_ratio")
	arg_2_0.target_on_spline_distance = arg_2_0:get_configuration_value(0.6, arg_2_0.config_name, "splinetrajectory", "target_on_spline_distance")
	arg_2_0.pathfinder_from_outside_navmesh_distance = arg_2_0:get_configuration_value(1, arg_2_0.config_name, "pathfinder", "from_outside_navmesh_distance")
	arg_2_0.pathfinder_propagation_box_extent = arg_2_0:get_configuration_value(200, arg_2_0.config_name, "pathfinder", "propagation_box_extent")
	arg_2_0.pathfinder_to_outside_navmesh_distance = arg_2_0:get_configuration_value(0.5, arg_2_0.config_name, "pathfinder", "to_outside_navmesh_distance")

	if arg_2_0.unit and var_0_3.alive(arg_2_0.unit) and var_0_3.has_data(arg_2_0.unit, arg_2_0.config_name, "navtag_layers") then
		local var_2_0 = 0

		while var_0_3.has_data(arg_2_0.unit, arg_2_0.config_name, "navtag_layers", var_2_0) == true do
			local var_2_1 = var_0_3.get_data(arg_2_0.unit, arg_2_0.config_name, "navtag_layers", var_2_0, "layer_id")
			local var_2_2 = var_0_3.get_data(arg_2_0.unit, arg_2_0.config_name, "navtag_layers", var_2_0, "layer_cost_multiplier")

			var_0_4.set_layer_cost_multiplier(arg_2_0.navtag_layer_cost_table, var_2_1, var_2_2)

			var_2_0 = var_2_0 + 1
		end
	end

	arg_2_0.target_group = arg_2_0:get_configuration_value("default", arg_2_0.config_name, "target_group")
	arg_2_0.is_player = arg_2_0:get_configuration_value(false, arg_2_0.config_name, "is_player")
end

var_0_1.configure_bot = function (arg_3_0, arg_3_1)
	arg_3_1:set_use_avoidance(arg_3_0.enable_avoidance)
	arg_3_1:set_use_channel(arg_3_0.use_channel)
	arg_3_1:set_avoidance_computer_config(arg_3_0.avoidance_angle_span, arg_3_0.avoidance_minimal_time_to_collision, arg_3_0.avoidance_sample_count)
	arg_3_1:set_avoidance_collider_collector_config(arg_3_0.collider_collector_half_height, arg_3_0.collider_collector_radius, arg_3_0.collider_collector_frame_delay)
	arg_3_1:set_avoidance_behavior(arg_3_0.avoidance_enable_slowing_down, arg_3_0.avoidance_enable_force_passage, arg_3_0.avoidance_enable_stop, arg_3_0.avoidance_stop_wait_time_s, arg_3_0.avoidance_force_passage_time_limit_s, arg_3_0.avoidance_wait_passage_time_limit_s)
	arg_3_1:set_channel_config(arg_3_0.channel_radius, arg_3_0.turn_sampling_angle, arg_3_0.channel_smoothing_angle, arg_3_0.min_distance_between_gates, arg_3_0.max_distance_between_gates)
	arg_3_1:set_spline_trajectory_config(arg_3_0.animation_driven, arg_3_0.max_distance_to_spline_position, arg_3_0.spline_length, arg_3_0.spline_distance_to_borders, arg_3_0.spline_recomputation_distance, arg_3_0.target_on_spline_distance)
	arg_3_1:set_propagation_box(arg_3_0.pathfinder_propagation_box_extent)
	arg_3_1:set_outside_navmesh_distance(arg_3_0.pathfinder_from_outside_navmesh_distance, arg_3_0.pathfinder_to_outside_navmesh_distance)
	arg_3_1:set_navtag_layer_cost_table(arg_3_0.navtag_layer_cost_table)
end

var_0_1.shutdown = function (arg_4_0)
	var_0_4.destroy(arg_4_0.navtag_layer_cost_table)

	arg_4_0.navtag_layer_cost_table = nil
end

return var_0_1
