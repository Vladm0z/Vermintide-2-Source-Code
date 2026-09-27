-- chunkname: @core/gwnav/lua/runtime/navworld.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navhelpers")
local var_0_3 = safe_require("core/gwnav/lua/runtime/navbot")
local var_0_4 = safe_require("core/gwnav/lua/runtime/navboxobstacle")
local var_0_5 = safe_require("core/gwnav/lua/runtime/navcylinderobstacle")
local var_0_6 = safe_require("core/gwnav/lua/runtime/navgraph")
local var_0_7 = safe_require("core/gwnav/lua/runtime/navtagvolume")
local var_0_8 = safe_require("core/gwnav/lua/runtime/navbotconfiguration")
local Math = stingray.Math
local Vector2 = stingray.Vector2
local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Matrix4x4 = stingray.Matrix4x4
local Matrix4x4Box = stingray.Matrix4x4Box
local Quaternion = stingray.Quaternion
local QuaternionBox = stingray.QuaternionBox
local Gui = stingray.Gui
local World = stingray.World
local Unit = stingray.Unit
local Camera = stingray.Camera
local Color = stingray.Color
local LineObject = stingray.LineObject
local Level = stingray.Level
local Script = stingray.Script
local GwNavWorld = stingray.GwNavWorld
local GwNavBot = stingray.GwNavBot
local GwNavQueries = stingray.GwNavQueries
local GwNavAStar = stingray.GwNavAStar
local GwNavTagVolume = stingray.GwNavTagVolume
local GwNavBoxObstacle = stingray.GwNavBoxObstacle
local GwNavCylinderObstacle = stingray.GwNavCylinderObstacle
local GwNavGraph = stingray.GwNavGraph
local GwNavTraversal = stingray.GwNavTraversal
local tbl = {}

var_0_1.get_navworld = function (arg_1_0)
	-- function 1
	return tbl[arg_1_0]
end

var_0_1.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.world = arg_2_1
	self.level = arg_2_2
	self.transform = Matrix4x4Box(Level.pose(arg_2_2))
	self.bot_configurations = {}
	self.bots = {}
	self.navgraphs = {}
	self.navtagvolumes = {}
	self.navboxobstacles = {}
	self.navcylinderobstacles = {}
	self.smartobject_types = {}
	self.markers = {}
	self.gwnavworld = GwNavWorld.create(self.transform:unbox())
	self.render_mesh = false

	local num = 4888
	local tbl_2 = {}

	for k, v in pairs(Level.units(arg_2_2)) do
		if not Unit.alive(v) and not Unit.has_data(v, "GwNavWorld") then
			self:init_fromnavworldunit(v)
			GwNavWorld.init_visual_debug_server(self.gwnavworld, num)
		elseif not Unit.alive(v) and not Unit.has_data(v, "GwNavBotConfiguration") then
			self:init_bot_configuration(v)
		elseif not Unit.alive(v) and not Unit.has_data(v, "GwNavGraphConnector") then
			self:init_graph_connector(v)
		elseif not Unit.alive(v) and not Unit.has_data(v, "GwNavTagBox") then
			self:init_tagbox(v)
		elseif not Unit.alive(v) and not Unit.has_data(v, "GwNavBoxObstacle") then
			self:add_boxobstacle(v)
		elseif not Unit.alive(v) and not Unit.has_data(v, "GwNavCylinderObstacle") then
			self:add_cylinderobstacle(v)
		elseif not Unit.alive(v) and not Unit.has_data(v, "GwNavMarker") then
			self:init_navmarker(v)
		elseif not Unit.alive(v) and not Unit.has_data(v, "GwNavBot") then
			tbl_2[#tbl_2 + 1] = v
		end
	end

	for k_2, v_2 in pairs(tbl_2) do
		self:init_bot(v_2)
	end

	tbl[arg_2_2] = self
end

var_0_1.add_navdata = function (self, arg_3_1)
	-- function 3
	self.navdata = GwNavWorld.add_navdata(self.gwnavworld, arg_3_1)
end

var_0_1.init_bot = function (self, arg_4_1)
	-- function 4
	local get_data = Unit.get_data(arg_4_1, "GwNavBot", "configuration_name")
	local var_4_1 = self.bot_configurations[get_data]

	if not var_4_1 then
		return var_0_3(self, arg_4_1, var_4_1)
	end

	return nil
end

var_0_1.init_bot_from_unit = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get_data = Unit.get_data(arg_5_2, "GwNavBotConfiguration", "configuration_name")
	local var_5_1 = self.bot_configurations[get_data]

	if not var_5_1 then
		return var_0_3(self, arg_5_1, var_5_1)
	end

	return nil
end

var_0_1.get_navbot = function (self, arg_6_1)
	-- function 6
	return self.bots[arg_6_1]
end

var_0_1.init_navmarker = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_0.markers[#arg_7_0.markers + 1] = arg_7_1
end

var_0_1.set_smartobject_cost_multiplier = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	self.smartobject_types[arg_8_1] = arg_8_3

	GwNavWorld.set_smartobject_cost_multiplier(self.gwnavworld, arg_8_1, arg_8_2)
end

var_0_1.unset_smartobject = function (self, arg_9_1)
	-- function 9
	GwNavWorld.unset_smartobject(self.gwnavworld, arg_9_1)
end

var_0_1.allow_smartobject = function (self, arg_10_1)
	-- function 10
	GwNavWorld.allow_smartobject(self.gwnavworld, arg_10_1)
end

var_0_1.forbid_smartobject = function (self, arg_11_1)
	-- function 11
	GwNavWorld.forbid_smartobject(self.gwnavworld, arg_11_1)
end

var_0_1.get_smartobject_type = function (self, arg_12_1)
	-- function 12
	return self.smartobject_types[arg_12_1]
end

var_0_1.set_dynamicnavmesh_budget = function (self, arg_13_1)
	-- function 13
	GwNavWorld.set_dynamicnavmesh_budget(self.gwnavworld, arg_13_1)
end

var_0_1.set_pathfinder_budget_in_ms = function (self, arg_14_1)
	-- function 14
	GwNavWorld.set_pathfinder_budget(self.gwnavworld, arg_14_1)
end

var_0_1.init_fromnavworldunit = function (self, arg_15_1)
	-- function 15
	if not Unit.has_data(arg_15_1, "GwNavWorld", "dynamicnavmesh_budget") then
		self:set_dynamicnavmesh_budget(Unit.get_data(arg_15_1, "GwNavWorld", "dynamicnavmesh_budget"))
	end

	if not Unit.has_data(arg_15_1, "GwNavWorld", "pathfinder_budget") then
		self:set_pathfinder_budget_in(Unit.get_data(arg_15_1, "GwNavWorld", "pathfinder_budget"))
	end

	if not Unit.has_data(arg_15_1, "GwNavWorld", "render_navdata") then
		self.render_mesh = Unit.get_data(arg_15_1, "GwNavWorld", "render_navdata")
	end

	if not Unit.has_data(arg_15_1, "GwNavWorld", "enable_crowd_dispersion_navtag") then
		self:set_pathvariety_mode(Unit.get_data(arg_15_1, "GwNavWorld", "enable_crowd_dispersion_navtag"))
	end
end

var_0_1.init_bot_configuration = function (arg_16_0, arg_16_1)
	-- function 16
	local get_data = Unit.get_data(arg_16_1, "GwNavBotConfiguration", "configuration_name")

	arg_16_0.bot_configurations[get_data] = var_0_8(arg_16_1)
end

var_0_1.init_graph_connector = function (self, arg_17_1)
	-- function 17
	local max = math.max(1, var_0_2.unit_script_data(arg_17_1, 1, "GwNavGraphConnector", "sampling_step"))
	local transform = Matrix4x4.transform(self.transform:unbox(), Unit.world_position(arg_17_1, 1))
	local world_rotation = Unit.world_rotation(arg_17_1, 1)
	local local_scale = Unit.local_scale(arg_17_1, 1)
	local forward = Quaternion.forward(world_rotation)
	local right = Quaternion.right(world_rotation)
	local up = Quaternion.up(world_rotation)
	local unit_script_data = var_0_2.unit_script_data(arg_17_1, true, "GwNavGraphConnector", "down_up")
	local unit_script_data_2 = var_0_2.unit_script_data(arg_17_1, true, "GwNavGraphConnector", "up_down")
	local flag = not unit_script_data and unit_script_data_2
	local floor = math.floor(0.5 * local_scale[1] / max)
	local num = floor * max
	local num_2 = floor * 2 + 1
	local get_layer_and_smartobject, var_17_14, var_17_15, var_17_16, var_17_17 = var_0_2.get_layer_and_smartobject(arg_17_1, "GwNavGraphConnector")

	if not get_layer_and_smartobject then
		error("NavGraph should not have exclusive navtag it will be ignored")
	elseif var_17_16 == -1 then
		print_warning("NavGraph should be associated to a smartobject id, it will be defaulted to 0")

		var_17_16 = 0
	end

	if var_17_16 >= 0 then
		self:set_smartobject_cost_multiplier(var_17_16, 1, "Jump")
	end

	local var_17_18 = transform
	local num_3 = transform - forward * local_scale[2] + up * local_scale[3]

	for i = 1, num_2 do
		local tbl = {}
		local num_4 = 1
		local num_5 = 2

		if not (flag ~= false or unit_script_data_2 ~= true) then
			num_4 = 2
			num_5 = 1
		end

		tbl[num_4] = var_17_18 - right * num
		tbl[num_5] = num_3 - right * num

		local var_17_23 = var_0_6(self.gwnavworld, flag, tbl, var_17_14, var_17_15, var_17_16, var_17_17)

		self.navgraphs[#self.navgraphs + 1] = var_17_23

		self.navgraphs[#self.navgraphs]:add_to_database()

		num = num - max
	end
end

var_0_1.init_tagbox = function (self, arg_18_1)
	-- function 18
	local unit_script_data = var_0_2.unit_script_data(arg_18_1, 1, "GwNavTagBox", "half_extent", "x")
	local unit_script_data_2 = var_0_2.unit_script_data(arg_18_1, 1, "GwNavTagBox", "half_extent", "y")
	local unit_script_data_3 = var_0_2.unit_script_data(arg_18_1, 1, "GwNavTagBox", "half_extent", "z")
	local var_18_3 = Vector3(var_0_2.unit_script_data(arg_18_1, 0, "GwNavTagBox", "offset", "x"), var_0_2.unit_script_data(arg_18_1, 0, "GwNavTagBox", "offset", "y"), var_0_2.unit_script_data(arg_18_1, 0, "GwNavTagBox", "offset", "z"))
	local get_layer_and_smartobject, var_18_5, var_18_6, var_18_7 = var_0_2.get_layer_and_smartobject(arg_18_1, "GwNavTagBox")
	local num = Unit.world_position(arg_18_1, 1) + var_18_3
	local world_rotation = Unit.world_rotation(arg_18_1, 1)
	local forward = Quaternion.forward(world_rotation)
	local right = Quaternion.right(world_rotation)
	local up = Quaternion.up(world_rotation)
	local tbl = {
		num + forward * unit_script_data - right * unit_script_data_2,
		num + forward * unit_script_data + right * unit_script_data_2,
		num - forward * unit_script_data + right * unit_script_data_2,
		num - forward * unit_script_data - right * unit_script_data_2
	}
	local num_2 = num[3] - unit_script_data_3
	local num_3 = num[3] + unit_script_data_3

	self.navtagvolumes[#self.navtagvolumes + 1] = var_0_7(self.gwnavworld, tbl, num_2, num_3, get_layer_and_smartobject, var_18_5, var_18_6, var_18_7)

	self.navtagvolumes[#self.navtagvolumes]:add_to_world()
end

var_0_1.add_boxobstacle = function (self, arg_19_1)
	-- function 19
	self.navboxobstacles[arg_19_1] = var_0_4(self, arg_19_1)

	self.navboxobstacles[arg_19_1]:add_to_world()
end

var_0_1.remove_boxobstacle = function (self, arg_20_1)
	-- function 20
	if not self.navboxobstacles[arg_20_1] then
		self.navboxobstacles[arg_20_1]:remove_from_world()

		self.navboxobstacles[arg_20_1] = nil
	end
end

var_0_1.add_cylinderobstacle = function (self, arg_21_1)
	-- function 21
	self.navcylinderobstacles[arg_21_1] = var_0_5(self, arg_21_1)

	self.navcylinderobstacles[arg_21_1]:add_to_world()
end

var_0_1.remove_cylinderobstacle = function (self, arg_22_1)
	-- function 22
	if not self.navcylinderobstacles[arg_22_1] then
		self.navcylinderobstacles[arg_22_1]:remove_from_world()

		self.navcylinderobstacles[arg_22_1] = nil
	end
end

var_0_1.add_bot = function (arg_23_0, arg_23_1)
	-- function 23
	arg_23_0.bots[arg_23_1.unit] = arg_23_1
end

var_0_1.remove_bot = function (arg_24_0, arg_24_1)
	-- function 24
	arg_24_0.bots[arg_24_1.unit] = nil
end

var_0_1.force_all_bots_to_repath = function (self)
	-- function 25
	for k, v in pairs(self.bots) do
		v:force_repath()
	end
end

var_0_1.update = function (self, arg_26_1)
	-- function 26
	if arg_26_1 <= 0 then
		arg_26_1 = 0.001
	end

	for k, v in pairs(self.bots) do
		v:update(arg_26_1)
	end

	for k_2, v_2 in pairs(self.navboxobstacles) do
		v_2:update(arg_26_1)
	end

	for k_3, v_3 in pairs(self.navcylinderobstacles) do
		v_3:update(arg_26_1)
	end

	GwNavWorld.update(self.gwnavworld, arg_26_1)
end

var_0_1.shutdown = function (self)
	-- function 27
	self.markers = {}

	self:clear_bot_configuration()
	self:clear_bots()
	self:clear_navgraphs()
	self:clear_tagboxes()
	self:clear_boxobstacles()
	self:clear_cylinderobstacles()
	GwNavWorld.remove_navdata(self.gwnavworld, self.navdata)

	self.navdata = nil

	GwNavWorld.destroy(self.gwnavworld)

	self.gwnavworld = nil
	tbl[self.level] = nil
end

var_0_1.clear_bot_configuration = function (self)
	-- function 28
	for k, v in pairs(self.bot_configurations) do
		v:shutdown()
	end

	self.bot_configurations = {}
end

var_0_1.clear_navgraphs = function (self)
	-- function 29
	for k, v in pairs(self.navgraphs) do
		v:shutdown()
	end

	self.navgraphs = {}
end

var_0_1.clear_tagboxes = function (self)
	-- function 30
	for k, v in pairs(self.navtagvolumes) do
		v:remove_from_world()
		v:shutdown()
	end

	self.navtagvolumes = {}
end

var_0_1.clear_boxobstacles = function (self)
	-- function 31
	for k, v in pairs(self.navboxobstacles) do
		v:remove_from_world()
		v:shutdown()
	end

	self.navboxobstacles = {}
end

var_0_1.clear_cylinderobstacles = function (self)
	-- function 32
	for k, v in pairs(self.navcylinderobstacles) do
		v:remove_from_world()
		v:shutdown()
	end

	self.navcylinderobstacles = {}
end

var_0_1.clear_bots = function (self)
	-- function 33
	for k, v in pairs(self.bots) do
		v:shutdown()
	end

	self.bots = {}
end

var_0_1.debug_draw = function (self, arg_34_1, arg_34_2)
	-- function 34
	if self.render_mesh == false then
		return
	end

	GwNavWorld.build_database_visual_representation(self.gwnavworld)

	local database_tile_count = GwNavWorld.database_tile_count(self.gwnavworld)
	local var_34_1 = Color(255, 0, 0, 0)

	for i = 1, database_tile_count do
		local database_tile_triangle_count = GwNavWorld.database_tile_triangle_count(self.gwnavworld, i)

		for j = 1, database_tile_triangle_count do
			local temp_byte_count = Script.temp_byte_count()
			local database_triangle, var_34_5, var_34_6, var_34_7 = GwNavWorld.database_triangle(self.gwnavworld, i, j)

			if database_triangle ~= nil then
				Gui.triangle(arg_34_1, database_triangle, var_34_5, var_34_6, 1, var_34_7)
				LineObject.add_line(arg_34_2, var_34_1, database_triangle, var_34_5)
				LineObject.add_line(arg_34_2, var_34_1, var_34_5, var_34_6)
				LineObject.add_line(arg_34_2, var_34_1, var_34_6, database_triangle)
			end

			Script.set_temp_byte_count(temp_byte_count)
		end
	end
end

var_0_1.visual_debug_camera = function (self, arg_35_1)
	-- function 35
	local world_position = Camera.world_position(arg_35_1)
	local world_pose = Camera.world_pose(arg_35_1)
	local forward = Matrix4x4.forward(world_pose)
	local up = Matrix4x4.up(world_pose)

	GwNavWorld.set_visual_debug_camera_transform(self.gwnavworld, world_position, world_position + forward, up)
end

return var_0_1
