-- chunkname: @scripts/unit_extensions/level/nav_graph_connector_extension.lua

local var_0_0 = require("scripts/settings/ledges")

NavGraphConnectorExtension = class(NavGraphConnectorExtension)

function NavGraphConnectorExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.nav_world = arg_1_3.nav_world or Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.navgraphs = {}

	local var_1_0 = Unit.get_data(arg_1_2, "ledge_id")

	if var_1_0 and var_0_0[var_1_0] then
		arg_1_0:init_nav_graphs(var_1_0)
	else
		local var_1_1 = Managers.state.debug:drawer({
			mode = "retained",
			name = "NavGraphConnectorExtension"
		})
		local var_1_2, var_1_3 = Unit.box(arg_1_2)

		var_1_1:box(var_1_2, var_1_3 * 1.1, Colors.get("purple"))
	end
end

local var_0_1 = {}
local var_0_2 = 0

function NavGraphConnectorExtension.init_nav_graphs(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.unit
	local var_2_1 = arg_2_0.world
	local var_2_2 = arg_2_0.nav_world
	local var_2_3 = LevelHelper:current_level(var_2_1)
	local var_2_4 = Level.unit_index(var_2_3, var_2_0)
	local var_2_5 = true
	local var_2_6 = 0

	var_0_2 = var_0_2 + 1

	local var_2_7 = var_0_0[arg_2_1]

	for iter_2_0, iter_2_1 in pairs(var_2_7) do
		var_0_1[1] = Vector3Aux.unbox(iter_2_1.ground_pos)
		var_0_1[2] = Vector3Aux.unbox(iter_2_1.ledge_pos)

		local var_2_8 = GwNavGraph.create(var_2_2, var_2_5, var_0_1, debug_color, var_2_6, var_2_4)

		GwNavGraph.add_to_database(var_2_8)

		arg_2_0.navgraphs[#arg_2_0.navgraphs + 1] = var_2_8

		if Development.parameter("visualize_ledges") then
			local var_2_9 = Managers.state.debug:drawer({
				mode = "retained",
				name = "NavGraphConnectorExtension"
			})
			local var_2_10 = Colors.get("dark_orange")
			local var_2_11 = Colors.get("red")

			var_2_9:line(var_0_1[1], var_0_1[2], var_2_10)

			if GwNavQueries.triangle_from_position(var_2_2, var_0_1[1]) then
				var_2_9:sphere(var_0_1[1], 0.05, var_2_10)
			else
				var_2_9:sphere(var_0_1[1], 0.05, var_2_11)
			end

			if GwNavQueries.triangle_from_position(var_2_2, var_0_1[2]) then
				var_2_9:sphere(var_0_1[2], 0.05, var_2_10)
			else
				var_2_9:sphere(var_0_1[2], 0.05, var_2_11)
			end
		end
	end
end

function NavGraphConnectorExtension.extensions_ready(arg_3_0)
	return
end

function NavGraphConnectorExtension.destroy(arg_4_0)
	for iter_4_0 = 1, #arg_4_0.navgraphs do
		local var_4_0 = arg_4_0.navgraphs[iter_4_0]

		GwNavGraph.destroy(var_4_0)
	end
end

function NavGraphConnectorExtension.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	return
end
