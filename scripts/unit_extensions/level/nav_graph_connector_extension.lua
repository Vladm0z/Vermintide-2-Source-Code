-- chunkname: @scripts/unit_extensions/level/nav_graph_connector_extension.lua

local scripts_settings_ledges = require("scripts/settings/ledges")

NavGraphConnectorExtension = class(NavGraphConnectorExtension)

NavGraphConnectorExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2

	local nav_world = arg_1_3.nav_world

	nav_world = nav_world or Managers.state.entity:system("ai_system"):nav_world()
	self.nav_world = nav_world
	self.is_server = Managers.player.is_server
	self.navgraphs = {}

	local get_data = Unit.get_data(arg_1_2, "ledge_id")

	if not get_data and not scripts_settings_ledges[get_data] then
		self:init_nav_graphs(get_data)
	else
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "NavGraphConnectorExtension"
		})
		local box, var_1_4 = Unit.box(arg_1_2)

		drawer:box(box, var_1_4 * 1.1, Colors.get("purple"))
	end
end

local tbl = {}
local num = 0

NavGraphConnectorExtension.init_nav_graphs = function (self, arg_2_1)
	-- function 2
	local unit = self.unit
	local world = self.world
	local nav_world = self.nav_world
	local current_level = LevelHelper:current_level(world)
	local unit_index = Level.unit_index(current_level, unit)
	local flag = true
	local num_2 = 0

	num = num + 1

	local var_2_7 = scripts_settings_ledges[arg_2_1]

	for k, v in pairs(var_2_7) do
		tbl[1] = Vector3Aux.unbox(v.ground_pos)
		tbl[2] = Vector3Aux.unbox(v.ledge_pos)

		local var_2_8 = GwNavGraph.create(nav_world, flag, tbl, debug_color, num_2, unit_index)

		GwNavGraph.add_to_database(var_2_8)

		self.navgraphs[#self.navgraphs + 1] = var_2_8

		if not Development.parameter("visualize_ledges") then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "NavGraphConnectorExtension"
			})
			local get = Colors.get("dark_orange")
			local get_2 = Colors.get("red")

			drawer:line(tbl[1], tbl[2], get)

			if not GwNavQueries.triangle_from_position(nav_world, tbl[1]) then
				drawer:sphere(tbl[1], 0.05, get)
			else
				drawer:sphere(tbl[1], 0.05, get_2)
			end

			if not GwNavQueries.triangle_from_position(nav_world, tbl[2]) then
				drawer:sphere(tbl[2], 0.05, get)
			else
				drawer:sphere(tbl[2], 0.05, get_2)
			end
		end
	end
end

NavGraphConnectorExtension.extensions_ready = function (arg_3_0)
	-- function 3
	return
end

NavGraphConnectorExtension.destroy = function (self)
	-- function 4
	for i = 1, #self.navgraphs do
		local var_4_0 = self.navgraphs[i]

		GwNavGraph.destroy(var_4_0)
	end
end

NavGraphConnectorExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	return
end
