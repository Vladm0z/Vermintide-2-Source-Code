-- chunkname: @core/gwnav/lua/runtime/navbotconfiguration.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navhelpers")
local Unit = stingray.Unit
local GwNavTagLayerCostTable = stingray.GwNavTagLayerCostTable

var_0_1.get_configuration_value = function (self, arg_1_1, ...)
	-- function 1
	return var_0_2.unit_script_data(self.unit, arg_1_1, ...)
end

var_0_1.init = function (self, arg_2_1)
	-- function 2
	self.unit = arg_2_1
	self.config_name = "GwNavBotConfiguration"
	self.navtag_layer_cost_table = GwNavTagLayerCostTable.create()
	self.height = self:get_configuration_value(1.8, self.config_name, "height")
	self.radius = self:get_configuration_value(0.4, self.config_name, "radius")
	self.speed = self:get_configuration_value(5, self.config_name, "speed")
	self.enable_avoidance = self:get_configuration_value(false, self.config_name, "avoidance", "enable")
	self.collider_collector_half_height = self:get_configuration_value(5, self.config_name, "avoidance", "collider_collector", "half_height")
	self.collider_collector_radius = self:get_configuration_value(30, self.config_name, "avoidance", "collider_collector", "radius")
	self.collider_collector_frame_delay = self:get_configuration_value(15, self.config_name, "avoidance", "collider_collector", "frame_delay")
	self.avoidance_angle_span = self:get_configuration_value(90, self.config_name, "avoidance", "computer", "angle_span")
	self.avoidance_minimal_time_to_collision = self:get_configuration_value(3, self.config_name, "avoidance", "computer", "minimal_time_to_collision")
	self.avoidance_sample_count = self:get_configuration_value(20, self.config_name, "avoidance", "computer", "sample_count")
	self.avoidance_enable_slowing_down = self:get_configuration_value(true, self.config_name, "avoidance", "behavior", "enable_slowing_down")
	self.avoidance_enable_force_passage = self:get_configuration_value(true, self.config_name, "avoidance", "behavior", "enable_force_passage")
	self.avoidance_enable_stop = self:get_configuration_value(true, self.config_name, "avoidance", "behavior", "enable_stop")
	self.avoidance_stop_wait_time_s = self:get_configuration_value(0.5, self.config_name, "avoidance", "behavior", "stop_wait_time_s")
	self.avoidance_force_passage_time_limit_s = self:get_configuration_value(0.5, self.config_name, "avoidance", "behavior", "force_passage_time_limit_s")
	self.avoidance_wait_passage_time_limit_s = self:get_configuration_value(1, self.config_name, "avoidance", "behavior", "wait_passage_time_limit_s")
	self.use_channel = self:get_configuration_value(false, self.config_name, "use_channel")
	self.channel_radius = self:get_configuration_value(4, self.config_name, "channel", "channel_radius")
	self.turn_sampling_angle = self:get_configuration_value(30, self.config_name, "channel", "turn_sampling_angle")
	self.channel_smoothing_angle = self:get_configuration_value(30, self.config_name, "channel", "channel_smoothing_angle")
	self.min_distance_between_gates = self:get_configuration_value(0.5, self.config_name, "channel", "min_distance_between_gates")
	self.max_distance_between_gates = self:get_configuration_value(10, self.config_name, "channel", "max_distance_between_gates")
	self.animation_driven = self:get_configuration_value(true, self.config_name, "splinetrajectory", "animation_driven")
	self.max_distance_to_spline_position = self:get_configuration_value(0.3, self.config_name, "splinetrajectory", "max_distance_to_spline_position")
	self.spline_length = self:get_configuration_value(100, self.config_name, "splinetrajectory", "spline_length")
	self.spline_distance_to_borders = self:get_configuration_value(0.2, self.config_name, "splinetrajectory", "spline_distance_to_borders")
	self.spline_recomputation_distance = self:get_configuration_value(0.3, self.config_name, "splinetrajectory", "spline_recomputation_distance_ratio")
	self.target_on_spline_distance = self:get_configuration_value(0.6, self.config_name, "splinetrajectory", "target_on_spline_distance")
	self.pathfinder_from_outside_navmesh_distance = self:get_configuration_value(1, self.config_name, "pathfinder", "from_outside_navmesh_distance")
	self.pathfinder_propagation_box_extent = self:get_configuration_value(200, self.config_name, "pathfinder", "propagation_box_extent")
	self.pathfinder_to_outside_navmesh_distance = self:get_configuration_value(0.5, self.config_name, "pathfinder", "to_outside_navmesh_distance")

	if not self.unit and not Unit.alive(self.unit) and not Unit.has_data(self.unit, self.config_name, "navtag_layers") then
		local num = 0

		while Unit.has_data(self.unit, self.config_name, "navtag_layers", num) == true do
			local get_data = Unit.get_data(self.unit, self.config_name, "navtag_layers", num, "layer_id")
			local get_data_2 = Unit.get_data(self.unit, self.config_name, "navtag_layers", num, "layer_cost_multiplier")

			GwNavTagLayerCostTable.set_layer_cost_multiplier(self.navtag_layer_cost_table, get_data, get_data_2)

			num = num + 1
		end
	end

	self.target_group = self:get_configuration_value("default", self.config_name, "target_group")
	self.is_player = self:get_configuration_value(false, self.config_name, "is_player")
end

var_0_1.configure_bot = function (self, arg_3_1)
	-- function 3
	arg_3_1:set_use_avoidance(self.enable_avoidance)
	arg_3_1:set_use_channel(self.use_channel)
	arg_3_1:set_avoidance_computer_config(self.avoidance_angle_span, self.avoidance_minimal_time_to_collision, self.avoidance_sample_count)
	arg_3_1:set_avoidance_collider_collector_config(self.collider_collector_half_height, self.collider_collector_radius, self.collider_collector_frame_delay)
	arg_3_1:set_avoidance_behavior(self.avoidance_enable_slowing_down, self.avoidance_enable_force_passage, self.avoidance_enable_stop, self.avoidance_stop_wait_time_s, self.avoidance_force_passage_time_limit_s, self.avoidance_wait_passage_time_limit_s)
	arg_3_1:set_channel_config(self.channel_radius, self.turn_sampling_angle, self.channel_smoothing_angle, self.min_distance_between_gates, self.max_distance_between_gates)
	arg_3_1:set_spline_trajectory_config(self.animation_driven, self.max_distance_to_spline_position, self.spline_length, self.spline_distance_to_borders, self.spline_recomputation_distance, self.target_on_spline_distance)
	arg_3_1:set_propagation_box(self.pathfinder_propagation_box_extent)
	arg_3_1:set_outside_navmesh_distance(self.pathfinder_from_outside_navmesh_distance, self.pathfinder_to_outside_navmesh_distance)
	arg_3_1:set_navtag_layer_cost_table(self.navtag_layer_cost_table)
end

var_0_1.shutdown = function (self)
	-- function 4
	GwNavTagLayerCostTable.destroy(self.navtag_layer_cost_table)

	self.navtag_layer_cost_table = nil
end

return var_0_1
