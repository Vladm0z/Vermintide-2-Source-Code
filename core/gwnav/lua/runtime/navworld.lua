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
local var_0_9 = stingray.Math
local var_0_10 = stingray.Vector2
local var_0_11 = stingray.Vector3
local var_0_12 = stingray.Vector3Box
local var_0_13 = stingray.Matrix4x4
local var_0_14 = stingray.Matrix4x4Box
local var_0_15 = stingray.Quaternion
local var_0_16 = stingray.QuaternionBox
local var_0_17 = stingray.Gui
local var_0_18 = stingray.World
local var_0_19 = stingray.Unit
local var_0_20 = stingray.Camera
local var_0_21 = stingray.Color
local var_0_22 = stingray.LineObject
local var_0_23 = stingray.Level
local var_0_24 = stingray.Script
local var_0_25 = stingray.GwNavWorld
local var_0_26 = stingray.GwNavBot
local var_0_27 = stingray.GwNavQueries
local var_0_28 = stingray.GwNavAStar
local var_0_29 = stingray.GwNavTagVolume
local var_0_30 = stingray.GwNavBoxObstacle
local var_0_31 = stingray.GwNavCylinderObstacle
local var_0_32 = stingray.GwNavGraph
local var_0_33 = stingray.GwNavTraversal
local var_0_34 = {}

function var_0_1.get_navworld(arg_1_0)
	return var_0_34[arg_1_0]
end

function var_0_1.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.world = arg_2_1
	arg_2_0.level = arg_2_2
	arg_2_0.transform = var_0_14(var_0_23.pose(arg_2_2))
	arg_2_0.bot_configurations = {}
	arg_2_0.bots = {}
	arg_2_0.navgraphs = {}
	arg_2_0.navtagvolumes = {}
	arg_2_0.navboxobstacles = {}
	arg_2_0.navcylinderobstacles = {}
	arg_2_0.smartobject_types = {}
	arg_2_0.markers = {}
	arg_2_0.gwnavworld = var_0_25.create(arg_2_0.transform:unbox())
	arg_2_0.render_mesh = false

	local var_2_0 = 4888
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_23.units(arg_2_2)) do
		if var_0_19.alive(iter_2_1) and var_0_19.has_data(iter_2_1, "GwNavWorld") then
			arg_2_0:init_fromnavworldunit(iter_2_1)
			var_0_25.init_visual_debug_server(arg_2_0.gwnavworld, var_2_0)
		elseif var_0_19.alive(iter_2_1) and var_0_19.has_data(iter_2_1, "GwNavBotConfiguration") then
			arg_2_0:init_bot_configuration(iter_2_1)
		elseif var_0_19.alive(iter_2_1) and var_0_19.has_data(iter_2_1, "GwNavGraphConnector") then
			arg_2_0:init_graph_connector(iter_2_1)
		elseif var_0_19.alive(iter_2_1) and var_0_19.has_data(iter_2_1, "GwNavTagBox") then
			arg_2_0:init_tagbox(iter_2_1)
		elseif var_0_19.alive(iter_2_1) and var_0_19.has_data(iter_2_1, "GwNavBoxObstacle") then
			arg_2_0:add_boxobstacle(iter_2_1)
		elseif var_0_19.alive(iter_2_1) and var_0_19.has_data(iter_2_1, "GwNavCylinderObstacle") then
			arg_2_0:add_cylinderobstacle(iter_2_1)
		elseif var_0_19.alive(iter_2_1) and var_0_19.has_data(iter_2_1, "GwNavMarker") then
			arg_2_0:init_navmarker(iter_2_1)
		elseif var_0_19.alive(iter_2_1) and var_0_19.has_data(iter_2_1, "GwNavBot") then
			var_2_1[#var_2_1 + 1] = iter_2_1
		end
	end

	for iter_2_2, iter_2_3 in pairs(var_2_1) do
		arg_2_0:init_bot(iter_2_3)
	end

	var_0_34[arg_2_2] = arg_2_0
end

function var_0_1.add_navdata(arg_3_0, arg_3_1)
	arg_3_0.navdata = var_0_25.add_navdata(arg_3_0.gwnavworld, arg_3_1)
end

function var_0_1.init_bot(arg_4_0, arg_4_1)
	local var_4_0 = var_0_19.get_data(arg_4_1, "GwNavBot", "configuration_name")
	local var_4_1 = arg_4_0.bot_configurations[var_4_0]

	if var_4_1 then
		return var_0_3(arg_4_0, arg_4_1, var_4_1)
	end

	return nil
end

function var_0_1.init_bot_from_unit(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = var_0_19.get_data(arg_5_2, "GwNavBotConfiguration", "configuration_name")
	local var_5_1 = arg_5_0.bot_configurations[var_5_0]

	if var_5_1 then
		return var_0_3(arg_5_0, arg_5_1, var_5_1)
	end

	return nil
end

function var_0_1.get_navbot(arg_6_0, arg_6_1)
	return arg_6_0.bots[arg_6_1]
end

function var_0_1.init_navmarker(arg_7_0, arg_7_1)
	arg_7_0.markers[#arg_7_0.markers + 1] = arg_7_1
end

function var_0_1.set_smartobject_cost_multiplier(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0.smartobject_types[arg_8_1] = arg_8_3

	var_0_25.set_smartobject_cost_multiplier(arg_8_0.gwnavworld, arg_8_1, arg_8_2)
end

function var_0_1.unset_smartobject(arg_9_0, arg_9_1)
	var_0_25.unset_smartobject(arg_9_0.gwnavworld, arg_9_1)
end

function var_0_1.allow_smartobject(arg_10_0, arg_10_1)
	var_0_25.allow_smartobject(arg_10_0.gwnavworld, arg_10_1)
end

function var_0_1.forbid_smartobject(arg_11_0, arg_11_1)
	var_0_25.forbid_smartobject(arg_11_0.gwnavworld, arg_11_1)
end

function var_0_1.get_smartobject_type(arg_12_0, arg_12_1)
	return arg_12_0.smartobject_types[arg_12_1]
end

function var_0_1.set_dynamicnavmesh_budget(arg_13_0, arg_13_1)
	var_0_25.set_dynamicnavmesh_budget(arg_13_0.gwnavworld, arg_13_1)
end

function var_0_1.set_pathfinder_budget_in_ms(arg_14_0, arg_14_1)
	var_0_25.set_pathfinder_budget(arg_14_0.gwnavworld, arg_14_1)
end

function var_0_1.init_fromnavworldunit(arg_15_0, arg_15_1)
	if var_0_19.has_data(arg_15_1, "GwNavWorld", "dynamicnavmesh_budget") then
		arg_15_0:set_dynamicnavmesh_budget(var_0_19.get_data(arg_15_1, "GwNavWorld", "dynamicnavmesh_budget"))
	end

	if var_0_19.has_data(arg_15_1, "GwNavWorld", "pathfinder_budget") then
		arg_15_0:set_pathfinder_budget_in(var_0_19.get_data(arg_15_1, "GwNavWorld", "pathfinder_budget"))
	end

	if var_0_19.has_data(arg_15_1, "GwNavWorld", "render_navdata") then
		arg_15_0.render_mesh = var_0_19.get_data(arg_15_1, "GwNavWorld", "render_navdata")
	end

	if var_0_19.has_data(arg_15_1, "GwNavWorld", "enable_crowd_dispersion_navtag") then
		arg_15_0:set_pathvariety_mode(var_0_19.get_data(arg_15_1, "GwNavWorld", "enable_crowd_dispersion_navtag"))
	end
end

function var_0_1.init_bot_configuration(arg_16_0, arg_16_1)
	local var_16_0 = var_0_19.get_data(arg_16_1, "GwNavBotConfiguration", "configuration_name")

	arg_16_0.bot_configurations[var_16_0] = var_0_8(arg_16_1)
end

function var_0_1.init_graph_connector(arg_17_0, arg_17_1)
	local var_17_0 = math.max(1, var_0_2.unit_script_data(arg_17_1, 1, "GwNavGraphConnector", "sampling_step"))
	local var_17_1 = var_0_13.transform(arg_17_0.transform:unbox(), var_0_19.world_position(arg_17_1, 1))
	local var_17_2 = var_0_19.world_rotation(arg_17_1, 1)
	local var_17_3 = var_0_19.local_scale(arg_17_1, 1)
	local var_17_4 = var_0_15.forward(var_17_2)
	local var_17_5 = var_0_15.right(var_17_2)
	local var_17_6 = var_0_15.up(var_17_2)
	local var_17_7 = var_0_2.unit_script_data(arg_17_1, true, "GwNavGraphConnector", "down_up")
	local var_17_8 = var_0_2.unit_script_data(arg_17_1, true, "GwNavGraphConnector", "up_down")
	local var_17_9 = var_17_7 and var_17_8
	local var_17_10 = math.floor(0.5 * var_17_3[1] / var_17_0)
	local var_17_11 = var_17_10 * var_17_0
	local var_17_12 = var_17_10 * 2 + 1
	local var_17_13, var_17_14, var_17_15, var_17_16, var_17_17 = var_0_2.get_layer_and_smartobject(arg_17_1, "GwNavGraphConnector")

	if var_17_13 then
		error("NavGraph should not have exclusive navtag it will be ignored")
	elseif var_17_16 == -1 then
		print_warning("NavGraph should be associated to a smartobject id, it will be defaulted to 0")

		var_17_16 = 0
	end

	if var_17_16 >= 0 then
		arg_17_0:set_smartobject_cost_multiplier(var_17_16, 1, "Jump")
	end

	local var_17_18 = var_17_1
	local var_17_19 = var_17_1 - var_17_4 * var_17_3[2] + var_17_6 * var_17_3[3]

	for iter_17_0 = 1, var_17_12 do
		local var_17_20 = {}
		local var_17_21 = 1
		local var_17_22 = 2

		if var_17_9 == false and var_17_8 == true then
			var_17_21 = 2
			var_17_22 = 1
		end

		var_17_20[var_17_21] = var_17_18 - var_17_5 * var_17_11
		var_17_20[var_17_22] = var_17_19 - var_17_5 * var_17_11

		local var_17_23 = var_0_6(arg_17_0.gwnavworld, var_17_9, var_17_20, var_17_14, var_17_15, var_17_16, var_17_17)

		arg_17_0.navgraphs[#arg_17_0.navgraphs + 1] = var_17_23

		arg_17_0.navgraphs[#arg_17_0.navgraphs]:add_to_database()

		var_17_11 = var_17_11 - var_17_0
	end
end

function var_0_1.init_tagbox(arg_18_0, arg_18_1)
	local var_18_0 = var_0_2.unit_script_data(arg_18_1, 1, "GwNavTagBox", "half_extent", "x")
	local var_18_1 = var_0_2.unit_script_data(arg_18_1, 1, "GwNavTagBox", "half_extent", "y")
	local var_18_2 = var_0_2.unit_script_data(arg_18_1, 1, "GwNavTagBox", "half_extent", "z")
	local var_18_3 = var_0_11(var_0_2.unit_script_data(arg_18_1, 0, "GwNavTagBox", "offset", "x"), var_0_2.unit_script_data(arg_18_1, 0, "GwNavTagBox", "offset", "y"), var_0_2.unit_script_data(arg_18_1, 0, "GwNavTagBox", "offset", "z"))
	local var_18_4, var_18_5, var_18_6, var_18_7 = var_0_2.get_layer_and_smartobject(arg_18_1, "GwNavTagBox")
	local var_18_8 = var_0_19.world_position(arg_18_1, 1) + var_18_3
	local var_18_9 = var_0_19.world_rotation(arg_18_1, 1)
	local var_18_10 = var_0_15.forward(var_18_9)
	local var_18_11 = var_0_15.right(var_18_9)
	local var_18_12 = var_0_15.up(var_18_9)
	local var_18_13 = {
		var_18_8 + var_18_10 * var_18_0 - var_18_11 * var_18_1,
		var_18_8 + var_18_10 * var_18_0 + var_18_11 * var_18_1,
		var_18_8 - var_18_10 * var_18_0 + var_18_11 * var_18_1,
		var_18_8 - var_18_10 * var_18_0 - var_18_11 * var_18_1
	}
	local var_18_14 = var_18_8[3] - var_18_2
	local var_18_15 = var_18_8[3] + var_18_2

	arg_18_0.navtagvolumes[#arg_18_0.navtagvolumes + 1] = var_0_7(arg_18_0.gwnavworld, var_18_13, var_18_14, var_18_15, var_18_4, var_18_5, var_18_6, var_18_7)

	arg_18_0.navtagvolumes[#arg_18_0.navtagvolumes]:add_to_world()
end

function var_0_1.add_boxobstacle(arg_19_0, arg_19_1)
	arg_19_0.navboxobstacles[arg_19_1] = var_0_4(arg_19_0, arg_19_1)

	arg_19_0.navboxobstacles[arg_19_1]:add_to_world()
end

function var_0_1.remove_boxobstacle(arg_20_0, arg_20_1)
	if arg_20_0.navboxobstacles[arg_20_1] then
		arg_20_0.navboxobstacles[arg_20_1]:remove_from_world()

		arg_20_0.navboxobstacles[arg_20_1] = nil
	end
end

function var_0_1.add_cylinderobstacle(arg_21_0, arg_21_1)
	arg_21_0.navcylinderobstacles[arg_21_1] = var_0_5(arg_21_0, arg_21_1)

	arg_21_0.navcylinderobstacles[arg_21_1]:add_to_world()
end

function var_0_1.remove_cylinderobstacle(arg_22_0, arg_22_1)
	if arg_22_0.navcylinderobstacles[arg_22_1] then
		arg_22_0.navcylinderobstacles[arg_22_1]:remove_from_world()

		arg_22_0.navcylinderobstacles[arg_22_1] = nil
	end
end

function var_0_1.add_bot(arg_23_0, arg_23_1)
	arg_23_0.bots[arg_23_1.unit] = arg_23_1
end

function var_0_1.remove_bot(arg_24_0, arg_24_1)
	arg_24_0.bots[arg_24_1.unit] = nil
end

function var_0_1.force_all_bots_to_repath(arg_25_0)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.bots) do
		iter_25_1:force_repath()
	end
end

function var_0_1.update(arg_26_0, arg_26_1)
	if arg_26_1 <= 0 then
		arg_26_1 = 0.001
	end

	for iter_26_0, iter_26_1 in pairs(arg_26_0.bots) do
		iter_26_1:update(arg_26_1)
	end

	for iter_26_2, iter_26_3 in pairs(arg_26_0.navboxobstacles) do
		iter_26_3:update(arg_26_1)
	end

	for iter_26_4, iter_26_5 in pairs(arg_26_0.navcylinderobstacles) do
		iter_26_5:update(arg_26_1)
	end

	var_0_25.update(arg_26_0.gwnavworld, arg_26_1)
end

function var_0_1.shutdown(arg_27_0)
	arg_27_0.markers = {}

	arg_27_0:clear_bot_configuration()
	arg_27_0:clear_bots()
	arg_27_0:clear_navgraphs()
	arg_27_0:clear_tagboxes()
	arg_27_0:clear_boxobstacles()
	arg_27_0:clear_cylinderobstacles()
	var_0_25.remove_navdata(arg_27_0.gwnavworld, arg_27_0.navdata)

	arg_27_0.navdata = nil

	var_0_25.destroy(arg_27_0.gwnavworld)

	arg_27_0.gwnavworld = nil
	var_0_34[arg_27_0.level] = nil
end

function var_0_1.clear_bot_configuration(arg_28_0)
	for iter_28_0, iter_28_1 in pairs(arg_28_0.bot_configurations) do
		iter_28_1:shutdown()
	end

	arg_28_0.bot_configurations = {}
end

function var_0_1.clear_navgraphs(arg_29_0)
	for iter_29_0, iter_29_1 in pairs(arg_29_0.navgraphs) do
		iter_29_1:shutdown()
	end

	arg_29_0.navgraphs = {}
end

function var_0_1.clear_tagboxes(arg_30_0)
	for iter_30_0, iter_30_1 in pairs(arg_30_0.navtagvolumes) do
		iter_30_1:remove_from_world()
		iter_30_1:shutdown()
	end

	arg_30_0.navtagvolumes = {}
end

function var_0_1.clear_boxobstacles(arg_31_0)
	for iter_31_0, iter_31_1 in pairs(arg_31_0.navboxobstacles) do
		iter_31_1:remove_from_world()
		iter_31_1:shutdown()
	end

	arg_31_0.navboxobstacles = {}
end

function var_0_1.clear_cylinderobstacles(arg_32_0)
	for iter_32_0, iter_32_1 in pairs(arg_32_0.navcylinderobstacles) do
		iter_32_1:remove_from_world()
		iter_32_1:shutdown()
	end

	arg_32_0.navcylinderobstacles = {}
end

function var_0_1.clear_bots(arg_33_0)
	for iter_33_0, iter_33_1 in pairs(arg_33_0.bots) do
		iter_33_1:shutdown()
	end

	arg_33_0.bots = {}
end

function var_0_1.debug_draw(arg_34_0, arg_34_1, arg_34_2)
	if arg_34_0.render_mesh == false then
		return
	end

	var_0_25.build_database_visual_representation(arg_34_0.gwnavworld)

	local var_34_0 = var_0_25.database_tile_count(arg_34_0.gwnavworld)
	local var_34_1 = var_0_21(255, 0, 0, 0)

	for iter_34_0 = 1, var_34_0 do
		local var_34_2 = var_0_25.database_tile_triangle_count(arg_34_0.gwnavworld, iter_34_0)

		for iter_34_1 = 1, var_34_2 do
			local var_34_3 = var_0_24.temp_byte_count()
			local var_34_4, var_34_5, var_34_6, var_34_7 = var_0_25.database_triangle(arg_34_0.gwnavworld, iter_34_0, iter_34_1)

			if var_34_4 ~= nil then
				var_0_17.triangle(arg_34_1, var_34_4, var_34_5, var_34_6, 1, var_34_7)
				var_0_22.add_line(arg_34_2, var_34_1, var_34_4, var_34_5)
				var_0_22.add_line(arg_34_2, var_34_1, var_34_5, var_34_6)
				var_0_22.add_line(arg_34_2, var_34_1, var_34_6, var_34_4)
			end

			var_0_24.set_temp_byte_count(var_34_3)
		end
	end
end

function var_0_1.visual_debug_camera(arg_35_0, arg_35_1)
	local var_35_0 = var_0_20.world_position(arg_35_1)
	local var_35_1 = var_0_20.world_pose(arg_35_1)
	local var_35_2 = var_0_13.forward(var_35_1)
	local var_35_3 = var_0_13.up(var_35_1)

	var_0_25.set_visual_debug_camera_transform(arg_35_0.gwnavworld, var_35_0, var_35_0 + var_35_2, var_35_3)
end

return var_0_1
