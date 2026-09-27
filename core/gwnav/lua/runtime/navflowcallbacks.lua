-- chunkname: @core/gwnav/lua/runtime/navflowcallbacks.lua

require("core/gwnav/lua/safe_require")

GwNavFlowCallbacks = safe_require_guard()

local var_0_0 = safe_require("core/gwnav/lua/runtime/navroute")
local var_0_1 = safe_require("core/gwnav/lua/runtime/navworld")
local var_0_2 = safe_require("core/gwnav/lua/runtime/navbot")
local var_0_3 = safe_require("core/gwnav/lua/runtime/navboxobstacle")
local var_0_4 = safe_require("core/gwnav/lua/runtime/navcylinderobstacle")
local Unit = stingray.Unit
local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Matrix4x4 = stingray.Matrix4x4
local tbl = {}

GwNavFlowCallbacks.create_navworld = function (self)
	-- function 1
	var_0_1(Unit.world(self.unit), Unit.level(self.unit))
end

GwNavFlowCallbacks.destroy_navworld = function (self)
	-- function 2
	var_0_1.get_navworld(Unit.level(self.unit)):shutdown()
end

GwNavFlowCallbacks.update_navworld = function (self)
	-- function 3
	var_0_1.get_navworld(Unit.level(self.unit)):update(self.delta_time)
end

GwNavFlowCallbacks.add_navmesh = function (self)
	-- function 4
	var_0_1.get_navworld(Unit.level(self.unit)):add_navdata(self.name)
end

GwNavFlowCallbacks.create_navbot = function (self)
	-- function 5
	local get_navworld = var_0_1.get_navworld(Unit.level(self.unit))

	if self.bot_configuration ~= nil then
		get_navworld:init_bot_from_unit(self.unit, self.bot_configuration)
	else
		get_navworld:init_bot(self.unit)
	end
end

GwNavFlowCallbacks.destroy_navbot = function (self)
	-- function 6
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		get_navbot:shutdown()
	end
end

GwNavFlowCallbacks.navbot_velocity = function (self)
	-- function 7
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		self.input_velocity = get_navbot:velocity()
	else
		self.input_velocity = Vector3(0, 0, 0)
	end

	return self
end

GwNavFlowCallbacks.navbot_output_velocity = function (self)
	-- function 8
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		self.output_velocity = get_navbot:output_velocity()
	else
		self.output_velocity = Vector3(0, 0, 0)
	end

	return self
end

GwNavFlowCallbacks.navbot_local_output_velocity = function (self)
	-- function 9
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		self.local_output_velocity = Matrix4x4.transform_without_translation(Matrix4x4.inverse(Unit.local_pose(self.unit, 1)), get_navbot:output_velocity())
	else
		self.local_output_velocity = Vector3(0, 0, 0)
	end

	return self
end

GwNavFlowCallbacks.navbot_destination = function (self)
	-- function 10
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		self.destination = get_navbot.destination:unbox()
	else
		self.destination = Vector3(0, 0, 0)
	end

	return self
end

GwNavFlowCallbacks.set_navbot_destination = function (self)
	-- function 11
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		get_navbot:set_destination(self.destination)
	end
end

GwNavFlowCallbacks.navbot_move_unit = function (self)
	-- function 12
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		get_navbot:move_unit(self.delta_time)
	end
end

GwNavFlowCallbacks.navbot_move_unit_with_mover = function (self)
	-- function 13
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		get_navbot:move_unit_with_mover(self.delta_time, self.gravity)
	end
end

GwNavFlowCallbacks.set_navbot_route = function (self)
	-- function 14
	local var_14_0 = tbl[self.id]

	if not var_14_0 then
		local get_navbot = var_0_2.get_navbot(self.unit)

		if not get_navbot then
			get_navbot:set_route(var_14_0:positions())
		end
	end
end

GwNavFlowCallbacks.navbot_set_layer_cost_multiplier = function (self)
	-- function 15
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		get_navbot:set_layer_cost_multiplier(self.layer, self.cost)
	end
end

GwNavFlowCallbacks.navbot_allow_layer = function (self)
	-- function 16
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		get_navbot:allow_layer(self.layer)
	end
end

GwNavFlowCallbacks.navbot_forbid_layer = function (self)
	-- function 17
	local get_navbot = var_0_2.get_navbot(self.unit)

	if not get_navbot then
		get_navbot:forbid_layer(self.layer)
	end
end

GwNavFlowCallbacks.create_route = function (self)
	-- function 18
	self.route_id = tostring(#tbl + 1)
	tbl[self.route_id] = var_0_0()

	return self
end

GwNavFlowCallbacks.add_position_to_route = function (self)
	-- function 19
	local var_19_0 = tbl[self.route_id]

	if not var_19_0 then
		var_19_0:add_position(Unit.local_position(self.unit, 1))
	end
end

GwNavFlowCallbacks.navboxobstacle_create = function (self)
	-- function 20
	var_0_1.get_navworld(Unit.level(self.world_unit)):add_boxobstacle(self.obstacle_unit)
end

GwNavFlowCallbacks.navboxobstacle_destroy = function (self)
	-- function 21
	local get_navboxstacle = var_0_3.get_navboxstacle(self.obstacle_unit)

	if not get_navboxstacle then
		get_navboxstacle:shutdown()
	end
end

GwNavFlowCallbacks.cylinderobstacle_create = function (self)
	-- function 22
	var_0_1.get_navworld(Unit.level(self.world_unit)):add_cylinderobstacle(self.obstacle_unit)
end

GwNavFlowCallbacks.cylinderobstacle_destroy = function (self)
	-- function 23
	local get_navcylinderostacle = var_0_4.get_navcylinderostacle(self.obstacle_unit)

	if not get_navcylinderostacle then
		get_navcylinderostacle:shutdown()
	end
end

return GwNavFlowCallbacks
