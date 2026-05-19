-- chunkname: @scripts/entity_system/systems/ai/nav_graph_system.lua

NavGraphSystem = class(NavGraphSystem, ExtensionSystemBase)

local var_0_0 = "2017.MAY.05.05"
local var_0_1 = {
	"NavGraphConnectorExtension",
	"LevelUnitSmartObjectExtension",
	"DynamicUnitSmartObjectExtension",
	"DarkPactClimbingExtension"
}

script_data.nav_mesh_debug = script_data.nav_mesh_debug or Development.parameter("nav_mesh_debug")
use_simple_jump_units = true

function NavGraphSystem.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.entity_manager

	var_1_0:register_system(arg_1_0, arg_1_2, var_0_1)

	arg_1_0.entity_manager = var_1_0
	arg_1_0.world = arg_1_1.world
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0.unit_extension_data = {}
	arg_1_0._use_level_jumps = Managers.state.game_mode:setting("use_level_jumps")

	if arg_1_0._use_level_jumps then
		arg_1_0.level_jumps = {}
		arg_1_0._level_jumps_ready = false
		arg_1_0.jumps_broadphase_max_dist = 25
		arg_1_0.jumps_broadphase = Broadphase(arg_1_0.jumps_broadphase_max_dist, 2048)
	end

	arg_1_0.nav_world = Managers.state.entity:system("ai_system"):nav_world()

	local var_1_1
	local var_1_2 = LevelHelper:current_level_settings(arg_1_0.world)
	local var_1_3 = var_1_2.level_name

	if LEVEL_EDITOR_TEST then
		var_1_3 = Application.get_data("LevelEditor", "level_resource_name")
	end

	if LevelResource.nested_level_count(var_1_3) > 0 then
		var_1_3 = LevelResource.nested_level_resource_name(var_1_3, 0)
	end

	if var_1_2.no_nav_mesh then
		arg_1_0.ledgelator_version = var_0_0
		arg_1_0.smart_objects = {}
		arg_1_0.no_nav_mesh = true
	elseif var_1_3 then
		local var_1_4 = var_1_3 .. "_smartobjects"
		local var_1_5 = var_1_3 .. "_ledges"

		if Application.can_get("lua", var_1_4) then
			local var_1_6 = require(var_1_4)

			arg_1_0.smart_objects, arg_1_0.smart_object_count = var_1_6.smart_objects, var_1_6.smart_object_count, var_1_6.version
			arg_1_0.ledgelator_version = var_1_6.ledgelator_version

			if arg_1_0.smart_objects == nil then
				arg_1_0.smart_objects = var_1_6
			end

			package.loaded[var_1_4] = nil
			package.load_order[#package.load_order] = nil
		elseif Application.can_get("lua", var_1_5) then
			arg_1_0.smart_objects = require(var_1_5)
			package.loaded[var_1_5] = nil
			package.load_order[#package.load_order] = nil
		else
			arg_1_0.smart_objects = {}
		end

		printf("Nav graph ledgelator version: Found version=%s Wanted version=%s", tostring(arg_1_0.ledgelator_version), var_0_0)
	end

	arg_1_0.fallback_smart_object_index = 0
	arg_1_0.smart_object_types = {}
	arg_1_0.smart_object_data = {}
	arg_1_0.smart_object_ids = {}
	arg_1_0.line_object = World.create_line_object(arg_1_0.world)
	arg_1_0.initialized_unit_nav_graphs = {}
	arg_1_0.dynamic_smart_object_index = 1

	Managers.state.event:register(arg_1_0, "level_start_local_player_spawned", "_event_local_player_spawned")
end

function NavGraphSystem.destroy(arg_2_0)
	World.destroy_line_object(arg_2_0.world, arg_2_0.line_object)

	arg_2_0.line_object = nil
	arg_2_0.initialized_unit_nav_graphs = nil

	local var_2_0 = Managers.state.event

	if var_2_0 then
		var_2_0:unregister("level_start_local_player_spawned", arg_2_0)
	end
end

local var_0_2 = {}
local var_0_3 = {}

function NavGraphSystem.init_nav_graphs(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0.nav_world
	local var_3_1 = arg_3_0.smart_objects
	local var_3_2 = Colors.get("orange")
	local var_3_3 = var_3_1[arg_3_2]
	local var_3_4 = Unit.get_data(arg_3_1, "ledge_enabled_vs")
	local var_3_5 = 0
	local var_3_6 = #var_3_3

	for iter_3_0 = 1, var_3_6 do
		local var_3_7 = var_3_3[iter_3_0]
		local var_3_8 = var_3_7.smart_object_type or "ledges"
		local var_3_9 = LAYER_ID_MAPPING[var_3_8]

		var_0_2[1] = Vector3Aux.unbox(var_3_7.pos1)
		var_0_2[2] = Vector3Aux.unbox(var_3_7.pos2)

		local var_3_10 = true

		if var_3_3.is_one_way or var_3_8 ~= "teleporters" and math.abs(var_0_2[1].z - var_0_2[2].z) > SmartObjectSettings.jump_up_max_height then
			var_3_10 = false
		end

		var_3_7.data.is_bidirectional = var_3_10

		local var_3_11 = var_3_7.smart_object_index

		arg_3_0.smart_object_types[var_3_11] = var_3_8
		arg_3_0.smart_object_data[var_3_11] = var_3_7.data

		local var_3_12 = GwNavGraph.create(var_3_0, var_3_10, var_0_2, var_3_2, var_3_9, var_3_11)

		if not var_3_4 and not script_data.disable_crowd_dispersion then
			GwNavWorld.register_all_navgraphedges_for_crowd_dispersion(var_3_0, var_3_12, 1, 100)
		end

		GwNavGraph.add_to_database(var_3_12)

		arg_3_3.navgraphs[#arg_3_3.navgraphs + 1] = var_3_12
	end

	if arg_3_0._use_level_jumps and var_3_4 then
		local var_3_13 = var_3_3[1]

		arg_3_0:spawn_versus_jump_unit(arg_3_1, var_3_13)

		local var_3_14 = var_3_13.smart_object_type or "ledges"

		if var_3_13.data.is_bidirectional and (var_3_14 == "jumps" or var_3_14 == "ledges_with_fence") and not var_3_13.data.is_on_small_fence then
			arg_3_0:spawn_versus_jump_unit(arg_3_1, var_3_13, true)
		end
	end

	arg_3_0.initialized_unit_nav_graphs[arg_3_1] = true
end

local var_0_4 = 1.1

function NavGraphSystem.spawn_versus_jump_unit(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_2.data.ledge_position

	var_4_0 = var_4_0 and Vector3Aux.unbox(var_4_0)

	local var_4_1 = Vector3Aux.unbox(arg_4_2.pos1) + Vector3(0, 0, var_0_4)
	local var_4_2 = Vector3Aux.unbox(arg_4_2.pos2) + Vector3(0, 0, var_0_4)
	local var_4_3 = {
		jump_object_data = arg_4_2
	}
	local var_4_4

	if var_4_0 then
		var_4_4 = var_4_0
	else
		var_4_4 = (var_4_1 + var_4_2) / 2
	end

	local var_4_5
	local var_4_6

	if arg_4_3 then
		var_4_5 = Vector3.normalize(var_4_4 - var_4_1)
		var_4_6 = var_4_1
		var_4_3.swap_entrance_exit = true
	else
		var_4_5 = Vector3.normalize(var_4_4 - var_4_2)
		var_4_6 = var_4_2
	end

	local var_4_7 = Vector3.normalize(Vector3.cross(var_4_5, Vector3.up()))
	local var_4_8 = Vector3.normalize(Vector3.cross(var_4_7, var_4_5))
	local var_4_9 = Quaternion.look(var_4_5, var_4_8)
	local var_4_10 = {
		nav_graph_system = {
			smart_object_index = arg_4_2.smart_object_index,
			swap = arg_4_3
		}
	}
	local var_4_11 = Managers.state.unit_spawner:spawn_local_unit_with_extensions("units/test_unit/jump_marker_ground_pactsworn", "versus_dark_pact_climbing_interaction_unit", var_4_10, var_4_6, var_4_9)
	local var_4_12 = Unit.node(var_4_11, "c_interaction")

	Unit.set_local_scale(var_4_11, var_4_12, Vector3(1, 2, 1))

	arg_4_0.level_jumps[var_4_11] = var_4_3

	local var_4_13 = Unit.get_data(arg_4_1, "allow_boss_traversal")

	Unit.set_data(var_4_11, "allow_boss_traversal", var_4_13)
end

function NavGraphSystem.level_jump_units(arg_5_0)
	return arg_5_0._level_jumps_ready and arg_5_0.level_jumps
end

function NavGraphSystem.on_add_extension(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = {
		navgraphs = {}
	}
	local var_6_1 = {}

	ScriptUnit.set_extension(arg_6_2, "nav_graph_system", var_6_0, var_6_1)

	arg_6_0.unit_extension_data[arg_6_2] = var_6_0

	if arg_6_3 == "NavGraphConnectorExtension" then
		local var_6_2 = Unit.get_data(arg_6_2, "smart_object_id") or Unit.get_data(arg_6_2, "ledge_id")

		if var_6_2 and arg_6_0.smart_objects[var_6_2] and not arg_6_0.no_nav_mesh and (not Unit.has_data(arg_6_2, "enabled_on_spawn") or Unit.get_data(arg_6_2, "enabled_on_spawn") == true) then
			arg_6_0:init_nav_graphs(arg_6_2, var_6_2, var_6_0)
		end
	end

	if arg_6_3 == "LevelUnitSmartObjectExtension" then
		local var_6_3 = arg_6_0:_level_unit_smart_object_id(arg_6_2)
		local var_6_4 = arg_6_0:smart_object_from_unit_data(arg_6_2, var_6_3)

		arg_6_0.smart_objects[var_6_3] = var_6_4
		arg_6_0.smart_object_ids[arg_6_2] = var_6_3

		if not arg_6_0.no_nav_mesh then
			arg_6_0:init_nav_graphs(arg_6_2, var_6_3, var_6_0)
		end
	end

	if arg_6_3 == "DynamicUnitSmartObjectExtension" then
		local var_6_5 = arg_6_0:_dynamic_unit_smart_object_id(arg_6_2)
		local var_6_6 = arg_6_0:smart_object_from_unit_data(arg_6_2, var_6_5)

		arg_6_0.smart_objects[var_6_5] = var_6_6
		arg_6_0.smart_object_ids[arg_6_2] = var_6_5

		if not arg_6_0.no_nav_mesh then
			local function var_6_7()
				arg_6_0:init_nav_graphs(arg_6_2, var_6_5, var_6_0)
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_6_7)
		end
	end

	if arg_6_3 == "DarkPactClimbingExtension" then
		local var_6_8 = arg_6_4.smart_object_index

		var_6_0.swap, var_6_0.smart_object_index = arg_6_4.swap, var_6_8
	end

	return var_6_0
end

function NavGraphSystem.on_remove_extension(arg_8_0, arg_8_1, arg_8_2)
	NavGraphSystem.super.on_remove_extension(arg_8_0, arg_8_1, arg_8_2)

	if arg_8_2 == "DynamicUnitSmartObjectExtension" then
		local var_8_0 = arg_8_0.smart_object_ids[arg_8_1]

		arg_8_0.smart_objects[var_8_0] = nil
		arg_8_0.smart_object_ids[arg_8_1] = nil

		arg_8_0:remove_nav_graph(arg_8_1)
	end
end

function NavGraphSystem.extensions_ready(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_3 == "DarkPactClimbingExtension" then
		arg_9_0._level_jumps_ready = true
	end
end

function NavGraphSystem._level_unit_smart_object_id(arg_10_0, arg_10_1)
	local var_10_0 = LevelHelper:current_level(arg_10_0.world)
	local var_10_1 = 10000 + Level.unit_index(var_10_0, arg_10_1)

	fassert(not arg_10_0.smart_objects[var_10_1], "Smart Object with id %s already registered!", var_10_1)

	return var_10_1
end

function NavGraphSystem._dynamic_unit_smart_object_id(arg_11_0, arg_11_1)
	local var_11_0 = 1000000 + arg_11_0.dynamic_smart_object_index

	fassert(not arg_11_0.smart_objects[var_11_0], "Smart Object with id %s already registered!", var_11_0)

	arg_11_0.dynamic_smart_object_index = arg_11_0.dynamic_smart_object_index + 1

	return var_11_0
end

function NavGraphSystem.queue_add_nav_graph_from_flow(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.unit_extension_data[arg_12_1]

	fassert(var_12_0, "Tried to add nav graph from flow for a unit without nav graph extension. %s", arg_12_1)

	arg_12_0.nav_graphs_units_to_add = arg_12_0.nav_graphs_units_to_add or {}
	arg_12_0.nav_graphs_units_to_add[#arg_12_0.nav_graphs_units_to_add + 1] = arg_12_1
end

function NavGraphSystem.queue_remove_nav_graph_from_flow(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.unit_extension_data[arg_13_1]

	fassert(var_13_0, "Tried to remove nav graph from flow for a unit without nav graph extension. %s", arg_13_1)

	arg_13_0.nav_graphs_units_to_remove = arg_13_0.nav_graphs_units_to_remove or {}
	arg_13_0.nav_graphs_units_to_remove[#arg_13_0.nav_graphs_units_to_remove + 1] = arg_13_1
end

function NavGraphSystem.add_nav_graph(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.unit_extension_data[arg_14_1]

	fassert(var_14_0, "Tried to add nav graph from flow for a unit without nav graph extension. %s", arg_14_1)

	if var_14_0.nav_graph_removed then
		local var_14_1 = var_14_0.navgraphs

		for iter_14_0 = 1, #var_14_1 do
			local var_14_2 = var_14_1[iter_14_0]

			GwNavGraph.add_to_database(var_14_2)
			printf("[NavGraphSystem] Adding navgraph(s) for [%q]", tostring(arg_14_1))
		end

		var_14_0.nav_graph_removed = false
	end
end

function NavGraphSystem.remove_nav_graph(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.unit_extension_data[arg_15_1]

	fassert(var_15_0, "Tried to remove nav graph from flow for a unit without nav graph extension. %s", arg_15_1)

	if not var_15_0.nav_graph_removed then
		local var_15_1 = var_15_0.navgraphs

		for iter_15_0 = 1, #var_15_1 do
			local var_15_2 = var_15_1[iter_15_0]

			GwNavGraph.remove_from_database(var_15_2)
			printf("[NavGraphSystem] Removing navgraph(s) for [%q]", tostring(arg_15_1))
		end

		var_15_0.nav_graph_removed = true
	end
end

function NavGraphSystem.init_nav_graph_from_flow(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.unit_extension_data[arg_16_1]

	fassert(var_16_0, "Tried to init nav graph from flow for a unit without nav graph extension. %s", arg_16_1)

	local var_16_1 = Unit.has_data(arg_16_1, "enabled_on_spawn") and Unit.get_data(arg_16_1, "enabled_on_spawn") == false

	fassert(var_16_1, "Tried to init nav graph from flow for a unit without script data \"enabled_on_spawn\" set to false. %s", arg_16_1)
	fassert(not arg_16_0.initialized_unit_nav_graphs[arg_16_1], "Tried to init nav graph from flow for a unit but the nav graph has already been initialized. %s", arg_16_1)

	local var_16_2 = Unit.get_data(arg_16_1, "smart_object_id") or Unit.get_data(arg_16_1, "ledge_id")

	if var_16_2 and arg_16_0.smart_objects[var_16_2] and not arg_16_0.no_nav_mesh then
		arg_16_0:init_nav_graphs(arg_16_1, var_16_2, var_16_0)
	end
end

function NavGraphSystem.smart_object_from_unit_data(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = {}
	local var_17_1 = 0

	while Unit.has_data(arg_17_1, "smart_objects", var_17_1) do
		local var_17_2
		local var_17_3
		local var_17_4 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "type")
		local var_17_5 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "is_one_way")

		if Unit.has_data(arg_17_1, "smart_objects", var_17_1, "entrance_node") then
			local var_17_6 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "entrance_node")
			local var_17_7 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "exit_node")
			local var_17_8 = arg_17_0.nav_world
			local var_17_9 = 0.5
			local var_17_10 = 0.5
			local var_17_11 = 0.5
			local var_17_12 = 0.1
			local var_17_13 = Unit.node(arg_17_1, var_17_6)

			var_17_2 = Unit.world_position(arg_17_1, var_17_13)

			local var_17_14, var_17_15 = GwNavQueries.triangle_from_position(var_17_8, var_17_2, var_17_9, var_17_10)

			if var_17_14 then
				var_17_2.z = var_17_15
			else
				local var_17_16 = GwNavQueries.inside_position_from_outside_position(var_17_8, var_17_2, var_17_9, var_17_10, var_17_11, var_17_12)

				fassert(var_17_16, "[NavGraphSystem] While creating smart object of type %q could not find nav mesh for entrance position at %s.", var_17_4, var_17_2)

				var_17_2 = var_17_16
			end

			local var_17_17 = Unit.node(arg_17_1, var_17_7)

			var_17_3 = Unit.world_position(arg_17_1, var_17_17)

			local var_17_18, var_17_19 = GwNavQueries.triangle_from_position(var_17_8, var_17_3, var_17_9, var_17_10)

			if var_17_18 then
				var_17_3.z = var_17_19
			else
				local var_17_20 = GwNavQueries.inside_position_from_outside_position(var_17_8, var_17_3, var_17_9, var_17_10, var_17_11, var_17_12)

				fassert(var_17_20, "[NavGraphSystem] While creating smart object of type %q could not find nav mesh for exit position at %s.", var_17_4, var_17_3)

				var_17_3 = var_17_20
			end
		else
			local var_17_21 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "node")
			local var_17_22 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "entrance", "offset_x")
			local var_17_23 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "entrance", "offset_y")
			local var_17_24 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "entrance", "offset_z")
			local var_17_25 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "exit", "offset_x")
			local var_17_26 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "exit", "offset_y")
			local var_17_27 = Unit.get_data(arg_17_1, "smart_objects", var_17_1, "exit", "offset_z")
			local var_17_28 = Unit.node(arg_17_1, var_17_21)
			local var_17_29 = Unit.world_position(arg_17_1, var_17_28)
			local var_17_30 = Unit.world_rotation(arg_17_1, var_17_28)
			local var_17_31 = Quaternion.right(var_17_30)
			local var_17_32 = Quaternion.forward(var_17_30)
			local var_17_33 = Quaternion.up(var_17_30)

			var_17_2 = var_17_29 + var_17_31 * var_17_22 + var_17_32 * var_17_23 + var_17_33 * var_17_24
			var_17_3 = var_17_29 + var_17_31 * var_17_25 + var_17_32 * var_17_26 + var_17_33 * var_17_27
		end

		var_17_1 = var_17_1 + 1
		var_17_0[var_17_1] = {
			data = {
				unit = arg_17_1
			},
			smart_object_type = var_17_4,
			smart_object_index = arg_17_2,
			pos1 = Vector3Aux.box(nil, var_17_2),
			pos2 = Vector3Aux.box(nil, var_17_3),
			is_one_way = var_17_5
		}
	end

	return var_17_0
end

function NavGraphSystem.on_remove_extension(arg_18_0, arg_18_1, arg_18_2)
	ScriptUnit.remove_extension(arg_18_1, arg_18_0.NAME)

	local var_18_0 = arg_18_0.unit_extension_data[arg_18_1]

	for iter_18_0 = 1, #var_18_0.navgraphs do
		local var_18_1 = var_18_0.navgraphs[iter_18_0]

		GwNavGraph.destroy(var_18_1)
	end

	arg_18_0.unit_extension_data[arg_18_1] = nil
end

function NavGraphSystem.update(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if arg_19_0.nav_graphs_units_to_add then
		for iter_19_0 = 1, #arg_19_0.nav_graphs_units_to_add do
			local var_19_0 = arg_19_0.nav_graphs_units_to_add[iter_19_0]

			arg_19_0:add_nav_graph(var_19_0)
		end

		arg_19_0.nav_graphs_units_to_add = nil
	elseif arg_19_0.nav_graphs_units_to_remove then
		for iter_19_1 = 1, #arg_19_0.nav_graphs_units_to_remove do
			local var_19_1 = arg_19_0.nav_graphs_units_to_remove[iter_19_1]

			arg_19_0:remove_nav_graph(var_19_1)
		end

		arg_19_0.nav_graphs_units_to_remove = nil
	end
end

function NavGraphSystem.hot_join_sync(arg_20_0, arg_20_1)
	return
end

function NavGraphSystem.get_smart_object_type(arg_21_0, arg_21_1)
	return arg_21_0.smart_object_types[arg_21_1]
end

function NavGraphSystem.get_smart_object_data(arg_22_0, arg_22_1)
	return arg_22_0.smart_object_data[arg_22_1]
end

function NavGraphSystem.get_smart_objects(arg_23_0, arg_23_1)
	return arg_23_0.smart_objects[arg_23_1]
end

function NavGraphSystem.get_smart_object_id(arg_24_0, arg_24_1)
	return arg_24_0.smart_object_ids[arg_24_1]
end

function NavGraphSystem.has_nav_graph(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.unit_extension_data[arg_25_1]

	if var_25_0 then
		return true, not var_25_0.nav_graph_removed
	else
		return false, false
	end
end

local var_0_5 = table.enum("shown", "hidden", "partial")

function NavGraphSystem._event_local_player_spawned(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	if not arg_26_0._use_level_jumps or Managers.state.game_mode:setting("hide_level_jumps") then
		return
	end

	if arg_26_3:name() ~= "dark_pact" then
		if arg_26_0._level_jump_state ~= var_0_5.hidden then
			for iter_26_0 in pairs(arg_26_0.level_jumps) do
				ScriptUnit.extension(iter_26_0, "interactable_system"):set_enabled(false)
			end
		end
	else
		local var_26_0 = arg_26_4.boss

		if var_26_0 and arg_26_0._level_jump_state ~= var_0_5.partial then
			for iter_26_1 in pairs(arg_26_0.level_jumps) do
				local var_26_1 = Unit.get_data(iter_26_1, "allow_boss_traversal")

				ScriptUnit.extension(iter_26_1, "interactable_system"):set_enabled(var_26_1)
			end
		elseif not var_26_0 and arg_26_0._level_jump_state ~= var_0_5.shown then
			for iter_26_2 in pairs(arg_26_0.level_jumps) do
				ScriptUnit.extension(iter_26_2, "interactable_system"):set_enabled(true)
			end
		end
	end
end
