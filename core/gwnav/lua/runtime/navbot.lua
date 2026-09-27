-- chunkname: @core/gwnav/lua/runtime/navbot.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navdefaultsmartobjectfollower")
local Math = stingray.Math
local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Matrix4x4 = stingray.Matrix4x4
local Matrix4x4Box = stingray.Matrix4x4Box
local Quaternion = stingray.Quaternion
local QuaternionBox = stingray.QuaternionBox
local Gui = stingray.Gui
local World = stingray.World
local Unit = stingray.Unit
local Application = stingray.Application
local Color = stingray.Color
local LineObject = stingray.LineObject
local Level = stingray.Level
local Mover = stingray.Mover
local GwNavWorld = stingray.GwNavWorld
local GwNavBot = stingray.GwNavBot
local GwNavSmartObjectInterval = stingray.GwNavSmartObjectInterval
local GwNavQueries = stingray.GwNavQueries
local GwNavAStar = stingray.GwNavAStar
local GwNavSmartObject = stingray.GwNavSmartObject
local GwNavTagVolume = stingray.GwNavTagVolume
local GwNavBoxObstacle = stingray.GwNavBoxObstacle
local GwNavCylinderObstacle = stingray.GwNavCylinderObstacle
local GwNavGraph = stingray.GwNavGraph
local GwNavTraversal = stingray.GwNavTraversal
local tbl = {}

var_0_1.get_navbot = function (arg_1_0)
	-- function 1
	return tbl[arg_1_0]
end

var_0_1.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self.navworld = arg_2_1
	self.unit = arg_2_2
	self.config = arg_2_3
	tbl[self.unit] = self

	local local_position = Unit.local_position(self.unit, 1)

	self.route = {}
	self.arrival_distance = 1
	self.smartobjects = arg_2_1.smartobjects
	self.next_smartobject_max_distance = 2
	self.is_smartobject_driven = false
	self.follower = var_0_2(self)
	self.gwnavbot = GwNavBot.create(arg_2_1.gwnavworld, self.config.height, self.config.radius, self.config.speed, local_position)
	self.interval = GwNavSmartObjectInterval.create(self.navworld.gwnavworld)

	arg_2_3:configure_bot(self)

	self.destination = Vector3Box(local_position)
	self.has_destination = false
	self.target_route_vertex = 1
	self.moving = false

	arg_2_1:add_bot(self)
end

var_0_1.set_use_avoidance = function (self, arg_3_1)
	-- function 3
	GwNavBot.set_use_avoidance(self.gwnavbot, arg_3_1)
end

var_0_1.set_navtag_layer_cost_table = function (self, arg_4_1)
	-- function 4
	GwNavBot.set_navtag_layer_cost_table(self.gwnavbot, arg_4_1)
end

var_0_1.set_use_channel = function (self, arg_5_1)
	-- function 5
	GwNavBot.set_use_channel(self.gwnavbot, arg_5_1)
end

var_0_1.get_target_group = function (self)
	-- function 6
	return self.config.target_group
end

var_0_1.set_destination = function (self, arg_7_1)
	-- function 7
	if arg_7_1 == self.destination:unbox() then
		self:on_recompute_path_to_similar_destination_for_crowd_dispersion()
	else
		self:on_compute_path_to_brand_new_destination_for_crowd_dispersion()
	end

	self.destination:store(arg_7_1)
	GwNavBot.compute_new_path(self.gwnavbot, arg_7_1)

	self.has_destination = true
end

var_0_1.set_route = function (self, arg_8_1)
	-- function 8
	self.route = arg_8_1
end

var_0_1.velocity = function (self)
	-- function 9
	return GwNavBot.velocity(self.gwnavbot)
end

var_0_1.output_velocity = function (self)
	-- function 10
	if not self:has_arrived() then
		return GwNavBot.output_velocity(self.gwnavbot)
	else
		return Vector3(0, 0, 0)
	end
end

var_0_1.set_layer_cost_multiplier = function (self, arg_11_1, arg_11_2)
	-- function 11
	local navtag_layer_cost_table = GwNavBot.navtag_layer_cost_table(self.gwnavbot)

	if navtag_layer_cost_table ~= nil then
		GwNavTagLayerCostTable.set_layer_cost_multiplier(navtag_layer_cost_table, arg_11_1, arg_11_2)
	end
end

var_0_1.allow_layer = function (self, arg_12_1)
	-- function 12
	local navtag_layer_cost_table = GwNavBot.navtag_layer_cost_table(self.gwnavbot)

	if navtag_layer_cost_table ~= nil then
		GwNavTagLayerCostTable.allow_layer(navtag_layer_cost_table, arg_12_1)
	end
end

var_0_1.forbid_layer = function (self, arg_13_1)
	-- function 13
	local navtag_layer_cost_table = GwNavBot.navtag_layer_cost_table(self.gwnavbot)

	if navtag_layer_cost_table ~= nil then
		GwNavTagLayerCostTable.forbid_layer(navtag_layer_cost_table, arg_13_1)
	end
end

var_0_1.repath = function (self)
	-- function 14
	self:set_destination(self.route[self.target_route_vertex + 1]:unbox())
end

var_0_1.force_repath = function (self)
	-- function 15
	if not (self.has_destination ~= true or self.is_smartobject_driven ~= false) then
		self:repath()
	end
end

var_0_1.set_avoidance_computer_config = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	GwNavBot.set_avoidance_computer_configuration(self.gwnavbot, arg_16_1, arg_16_2, arg_16_3)
end

var_0_1.set_avoidance_collider_collector_config = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	GwNavBot.set_avoidance_collider_collector_configuration(self.gwnavbot, arg_17_1, arg_17_2, arg_17_3)
end

var_0_1.set_avoidance_behavior = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	-- function 18
	GwNavBot.set_avoidance_behavior(self.gwnavbot, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
end

var_0_1.set_channel_config = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	GwNavBot.set_channel_computer_configuration(self.gwnavbot, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
end

var_0_1.set_spline_trajectory_config = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	-- function 20
	GwNavBot.set_spline_trajectory_configuration(self.gwnavbot, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
end

var_0_1.set_propagation_box = function (self, arg_21_1)
	-- function 21
	GwNavBot.set_propagation_box(self.gwnavbot, arg_21_1)
end

var_0_1.set_outside_navmesh_distance = function (self, arg_22_1, arg_22_2)
	-- function 22
	GwNavBot.set_outside_navmesh_distance(self.gwnavbot, arg_22_1, arg_22_2)
end

var_0_1.visual_debug_draw_line = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	-- function 23
	return
end

var_0_1.get_remaining_distance_from_progress_to_end_of_path = function (self)
	-- function 24
	return GwNavBot.get_remaining_distance_from_progress_to_end_of_path(self.gwnavbot)
end

var_0_1.shutdown = function (self)
	-- function 25
	self.navworld:remove_bot(self)
	GwNavSmartObjectInterval.destroy(self.interval)
	GwNavBot.destroy(self.gwnavbot)

	self.gwnavworld = nil
	self.gwnavbot = nil
	self.interval = nil
	self.route = {}
	tbl[self.unit] = nil
end

var_0_1.update_crowd_dispersion = function (self)
	-- function 26
	local update_logic_for_crowd_dispersion = GwNavBot.update_logic_for_crowd_dispersion(self.gwnavbot)

	if update_logic_for_crowd_dispersion == 1 then
		if not GwNavBot.is_computing_path(self.gwnavbot) then
			self:next_route_index()
			self:set_destination(self.route[self.target_route_vertex]:unbox())
		end
	elseif update_logic_for_crowd_dispersion ~= 2 or not GwNavBot.is_computing_path(self.gwnavbot) then
		print("self:cancel()")
	end
end

var_0_1.on_recompute_path_to_similar_destination_for_crowd_dispersion = function (self)
	-- function 27
	GwNavBot.on_recompute_path_to_similar_destination_for_crowd_dispersion(self.gwnavbot)
end

var_0_1.on_compute_path_to_brand_new_destination_for_crowd_dispersion = function (self)
	-- function 28
	GwNavBot.on_compute_path_to_brand_new_destination_for_crowd_dispersion(self.gwnavbot)
end

var_0_1.next_route_index = function (self)
	-- function 29
	self.target_route_vertex = math.max((self.target_route_vertex + 1) % (table.getn(self.route) + 1), 1)
end

var_0_1.update_route = function (self)
	-- function 30
	local getn = table.getn(self.route)

	if getn == 0 then
		return
	end

	if GwNavBot.is_computing_new_path(self.gwnavbot) or not GwNavBot.is_path_recomputation_needed(self.gwnavbot) then
		self:set_destination(self.route[self.target_route_vertex]:unbox())
	end

	if self.has_destination == false then
		self:next_route_index()
		self:set_destination(self.route[self.target_route_vertex]:unbox())
	end

	if not self:has_arrived() then
		if getn == 1 then
			self.has_destination = false
			self.route = {}
		else
			self:next_route_index()
			self:set_destination(self.route[self.target_route_vertex]:unbox())
		end
	end
end

var_0_1.has_arrived = function (self)
	-- function 31
	return Vector3.distance(self:get_position(), self.destination:unbox()) < self.arrival_distance
end

var_0_1.visual_debug_next_smartobject = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	self:visual_debug_draw_line("next_smart_object", "stingray", arg_32_1, arg_32_3, Color(0, 255, 0, 0), true)

	if arg_32_2 == true then
		self:visual_debug_draw_line("next_smart_object", "stingray", arg_32_1, arg_32_1 + Vector3(0, 0, 3), Color(255, 100, 20, 0), true)
	else
		self:visual_debug_draw_line("next_smart_object", "stingray", arg_32_1, arg_32_1 + Vector3(0, 0, 3), Color(0, 255, 0, 0), true)
	end

	if arg_32_4 == true then
		self:visual_debug_draw_line("next_smart_object", "stingray", arg_32_3, arg_32_3 + Vector3(0, 0, 3), Color(255, 100, 20, 0), true)
	else
		self:visual_debug_draw_line("next_smart_object", "stingray", arg_32_3, arg_32_3 + Vector3(0, 0, 3), Color(0, 255, 0, 0), true)
	end
end

var_0_1.update_next_smartobject = function (self)
	-- function 33
	if GwNavBot.current_or_next_smartobject_interval(self.gwnavbot, self.interval, self.next_smartobject_max_distance) == false then
		return
	end

	local entrance_position, var_33_1 = GwNavSmartObjectInterval.entrance_position(self.interval)
	local exit_position, var_33_3 = GwNavSmartObjectInterval.exit_position(self.interval)

	self:visual_debug_next_smartobject(entrance_position, var_33_1, exit_position, var_33_3)
	self.follower:handle_next_smartobject(self:get_position(), self.interval, entrance_position, var_33_1, exit_position, var_33_3)
end

var_0_1.verbose_smartobject_management = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	-- function 34
	if arg_34_3 == true then
		local get_smartobject_type = self.follower:get_smartobject_type(arg_34_2)

		print("Inside smartobject", get_smartobject_type)

		if arg_34_4 == true then
			print("End of path is inside this smartobject")
		end
	elseif arg_34_6 > Vector3.distance(arg_34_5, arg_34_1) then
		local get_smartobject_type_2 = self.follower:get_smartobject_type(arg_34_2)

		print("Approaching smartobject", get_smartobject_type_2)

		if arg_34_4 == true then
			print("End of path is inside this smartobject")
		end
	end
end

var_0_1.update = function (self, arg_35_1)
	-- function 35
	self:update_next_smartobject()
	self:update_crowd_dispersion()
	self:update_route()

	if self.is_smartobject_driven == true then
		self.follower:update_follow(arg_35_1)
	end

	if not self.custom_update then
		self:custom_update(arg_35_1)
	end

	if GwNavBot.is_computing_new_path(self.gwnavbot) or not GwNavBot.is_path_recomputation_needed(self.gwnavbot) then
		self:set_destination(self.destination:unbox())
	end

	GwNavBot.update_position(self.gwnavbot, self:get_position(), arg_35_1)
end

var_0_1.get_position = function (self)
	-- function 36
	return Unit.local_position(self.unit, 1)
end

var_0_1.debug_draw = function (self, arg_37_1)
	-- function 37
	if arg_37_1 == nil then
		return
	end

	local local_pose = Unit.local_pose(self.unit, 1)
	local translation = Matrix4x4.translation(local_pose)

	LineObject.add_line(arg_37_1, Color(255, 0, 0, 255), translation, translation + Matrix4x4.x(local_pose))
	LineObject.add_line(arg_37_1, Color(255, 0, 255, 0), translation, translation + Matrix4x4.y(local_pose))
	LineObject.add_line(arg_37_1, Color(255, 255, 0, 0), translation, translation + Matrix4x4.z(local_pose))
end

var_0_1.compute_height_on_navmesh = function (self, arg_38_1)
	-- function 38
	local triangle_from_position, var_38_1, var_38_2, var_38_3 = GwNavQueries.triangle_from_position(self.navworld.gwnavworld, arg_38_1)

	if triangle_from_position ~= nil then
		arg_38_1[3] = triangle_from_position
	end

	return arg_38_1
end

var_0_1.update_pose = function (self, arg_39_1, arg_39_2)
	-- function 39
	local local_pose = Unit.local_pose(self.unit, 1)

	if Vector3.length(arg_39_1) ~= 0 then
		Matrix4x4.set_forward(local_pose, arg_39_1)
		Matrix4x4.set_right(local_pose, Vector3.cross(arg_39_1, Matrix4x4.up(local_pose)))
	end

	Matrix4x4.set_translation(local_pose, arg_39_2)
	Unit.set_local_pose(self.unit, 1, local_pose)
end

var_0_1.move_unit = function (self, arg_40_1)
	-- function 40
	if self.is_smartobject_driven == false then
		local output_velocity = GwNavBot.output_velocity(self.gwnavbot)

		self:update_pose(Vector3.normalize(output_velocity), GwNavBot.compute_move_on_navmesh(self.gwnavbot, arg_40_1, output_velocity))
	else
		self.follower:move_unit(arg_40_1)
	end

	GwNavBot.update_position(self.gwnavbot, self:get_position(), arg_40_1)
end

var_0_1.animation_wanted_delta = function (self)
	-- function 41
	if not (not Unit.has_animation_state_machine(self.unit) and Unit.animation_root_mode(self.unit) ~= "ignore") then
		return Vector3.length(Matrix4x4.translation(Unit.animation_wanted_root_pose(self.unit)) - Unit.local_position(self.unit, 1))
	end

	return nil
end

var_0_1.move_unit_with_mover = function (self, arg_42_1, arg_42_2)
	-- function 42
	if self.is_smartobject_driven == false then
		local mover = Unit.mover(self.unit)

		if mover == nil then
			return
		end

		local output_velocity = GwNavBot.output_velocity(self.gwnavbot)
		local num = output_velocity * arg_42_1

		num.z = num.z - arg_42_1 * arg_42_2

		Mover.move(mover, num, arg_42_1)
		self:update_pose(Vector3.normalize(output_velocity), Mover.position(mover))
	else
		self.follower:move_unit_with_mover(arg_42_1, mover)
	end

	GwNavBot.update_position(self.gwnavbot, self:get_position(), arg_42_1)
end

return var_0_1
