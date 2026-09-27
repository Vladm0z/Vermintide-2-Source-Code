-- chunkname: @scripts/entity_system/systems/ai/nav_graph_system.lua

NavGraphSystem = class(NavGraphSystem, ExtensionSystemBase)

local str = "2017.MAY.05.05"
local tbl = {
	"NavGraphConnectorExtension",
	"LevelUnitSmartObjectExtension",
	"DynamicUnitSmartObjectExtension",
	"DarkPactClimbingExtension"
}
local script_data = script_data
local nav_mesh_debug = script_data.nav_mesh_debug

nav_mesh_debug = nav_mesh_debug or Development.parameter("nav_mesh_debug")
script_data.nav_mesh_debug = nav_mesh_debug
use_simple_jump_units = true

NavGraphSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local entity_manager = arg_1_1.entity_manager

	entity_manager:register_system(self, arg_1_2, tbl)

	self.entity_manager = entity_manager
	self.world = arg_1_1.world
	self._is_server = arg_1_1.is_server
	self.unit_extension_data = {}
	self._use_level_jumps = Managers.state.game_mode:setting("use_level_jumps")

	if not self._use_level_jumps then
		self.level_jumps = {}
		self._level_jumps_ready = false
		self.jumps_broadphase_max_dist = 25
		self.jumps_broadphase = Broadphase(self.jumps_broadphase_max_dist, 2048)
	end

	self.nav_world = Managers.state.entity:system("ai_system"):nav_world()

	local var_1_1
	local current_level_settings = LevelHelper:current_level_settings(self.world)
	local level_name = current_level_settings.level_name

	if not LEVEL_EDITOR_TEST then
		level_name = Application.get_data("LevelEditor", "level_resource_name")
	end

	if LevelResource.nested_level_count(level_name) > 0 then
		level_name = LevelResource.nested_level_resource_name(level_name, 0)
	end

	if not current_level_settings.no_nav_mesh then
		self.ledgelator_version = str
		self.smart_objects = {}
		self.no_nav_mesh = true
	elseif not level_name then
		local str_2 = level_name .. "_smartobjects"
		local str_3 = level_name .. "_ledges"

		if not Application.can_get("lua", str_2) then
			local var_1_6 = require(str_2)

			self.smart_objects, self.smart_object_count = var_1_6.smart_objects, var_1_6.smart_object_count, var_1_6.version
			self.ledgelator_version = var_1_6.ledgelator_version

			if self.smart_objects == nil then
				self.smart_objects = var_1_6
			end

			package.loaded[str_2] = nil
			package.load_order[#package.load_order] = nil
		elseif not Application.can_get("lua", str_3) then
			self.smart_objects = require(str_3)
			package.loaded[str_3] = nil
			package.load_order[#package.load_order] = nil
		else
			self.smart_objects = {}
		end

		printf("Nav graph ledgelator version: Found version=%s Wanted version=%s", tostring(self.ledgelator_version), str)
	end

	self.fallback_smart_object_index = 0
	self.smart_object_types = {}
	self.smart_object_data = {}
	self.smart_object_ids = {}
	self.line_object = World.create_line_object(self.world)
	self.initialized_unit_nav_graphs = {}
	self.dynamic_smart_object_index = 1

	Managers.state.event:register(self, "level_start_local_player_spawned", "_event_local_player_spawned")
end

NavGraphSystem.destroy = function (self)
	-- function 2
	World.destroy_line_object(self.world, self.line_object)

	self.line_object = nil
	self.initialized_unit_nav_graphs = nil

	local event = Managers.state.event

	if not event then
		event:unregister("level_start_local_player_spawned", self)
	end
end

local tbl_2 = {}
local tbl_3 = {}

NavGraphSystem.init_nav_graphs = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local nav_world = self.nav_world
	local smart_objects = self.smart_objects
	local get = Colors.get("orange")
	local var_3_3 = smart_objects[arg_3_2]
	local get_data = Unit.get_data(arg_3_1, "ledge_enabled_vs")
	local num = 0
	local count = #var_3_3

	for i = 1, count do
		local var_3_7 = var_3_3[i]
		local smart_object_type = var_3_7.smart_object_type

		smart_object_type = smart_object_type or "ledges"

		local var_3_9 = LAYER_ID_MAPPING[smart_object_type]

		tbl_2[1] = Vector3Aux.unbox(var_3_7.pos1)
		tbl_2[2] = Vector3Aux.unbox(var_3_7.pos2)

		local flag = true

		if not (var_3_3.is_one_way or smart_object_type == "teleporters" or not (math.abs(tbl_2[1].z - tbl_2[2].z) > SmartObjectSettings.jump_up_max_height)) then
			flag = false
		end

		var_3_7.data.is_bidirectional = flag

		local smart_object_index = var_3_7.smart_object_index

		self.smart_object_types[smart_object_index] = smart_object_type
		self.smart_object_data[smart_object_index] = var_3_7.data

		local var_3_12 = GwNavGraph.create(nav_world, flag, tbl_2, get, var_3_9, smart_object_index)

		if not (get_data or script_data.disable_crowd_dispersion) then
			GwNavWorld.register_all_navgraphedges_for_crowd_dispersion(nav_world, var_3_12, 1, 100)
		end

		GwNavGraph.add_to_database(var_3_12)

		arg_3_3.navgraphs[#arg_3_3.navgraphs + 1] = var_3_12
	end

	if not self._use_level_jumps and not get_data then
		local var_3_13 = var_3_3[1]

		self:spawn_versus_jump_unit(arg_3_1, var_3_13)

		local smart_object_type_2 = var_3_13.smart_object_type

		smart_object_type_2 = smart_object_type_2 or "ledges"

		if not (not var_3_13.data.is_bidirectional and smart_object_type_2 == "jumps" and smart_object_type_2 == "ledges_with_fence" and var_3_13.data.is_on_small_fence) then
			self:spawn_versus_jump_unit(arg_3_1, var_3_13, true)
		end
	end

	self.initialized_unit_nav_graphs[arg_3_1] = true
end

local num = 1.1

NavGraphSystem.spawn_versus_jump_unit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local ledge_position = arg_4_2.data.ledge_position

	ledge_position = not ledge_position and Vector3Aux.unbox(ledge_position)

	local num_2 = Vector3Aux.unbox(arg_4_2.pos1) + Vector3(0, 0, num)
	local num_3 = Vector3Aux.unbox(arg_4_2.pos2) + Vector3(0, 0, num)
	local tbl = {
		jump_object_data = arg_4_2
	}
	local var_4_4

	if not ledge_position then
		var_4_4 = ledge_position
	else
		var_4_4 = (num_2 + num_3) / 2
	end

	local var_4_5
	local var_4_6

	if not arg_4_3 then
		var_4_5 = Vector3.normalize(var_4_4 - num_2)
		var_4_6 = num_2
		tbl.swap_entrance_exit = true
	else
		var_4_5 = Vector3.normalize(var_4_4 - num_3)
		var_4_6 = num_3
	end

	local normalize = Vector3.normalize(Vector3.cross(var_4_5, Vector3.up()))
	local normalize_2 = Vector3.normalize(Vector3.cross(normalize, var_4_5))
	local look = Quaternion.look(var_4_5, normalize_2)
	local tbl_2 = {
		nav_graph_system = {
			smart_object_index = arg_4_2.smart_object_index,
			swap = arg_4_3
		}
	}
	local spawn_local_unit_with_extensions = Managers.state.unit_spawner:spawn_local_unit_with_extensions("units/test_unit/jump_marker_ground_pactsworn", "versus_dark_pact_climbing_interaction_unit", tbl_2, var_4_6, look)
	local node = Unit.node(spawn_local_unit_with_extensions, "c_interaction")

	Unit.set_local_scale(spawn_local_unit_with_extensions, node, Vector3(1, 2, 1))

	arg_4_0.level_jumps[spawn_local_unit_with_extensions] = tbl

	local get_data = Unit.get_data(arg_4_1, "allow_boss_traversal")

	Unit.set_data(spawn_local_unit_with_extensions, "allow_boss_traversal", get_data)
end

NavGraphSystem.level_jump_units = function (self)
	-- function 5
	local _level_jumps_ready = self._level_jumps_ready

	_level_jumps_ready = not _level_jumps_ready and self.level_jumps

	return _level_jumps_ready
end

NavGraphSystem.on_add_extension = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local tbl = {
		navgraphs = {}
	}
	local tbl_2 = {}

	ScriptUnit.set_extension(arg_6_2, "nav_graph_system", tbl, tbl_2)

	self.unit_extension_data[arg_6_2] = tbl

	if arg_6_3 == "NavGraphConnectorExtension" then
		local get_data = Unit.get_data(arg_6_2, "smart_object_id")

		get_data = get_data or Unit.get_data(arg_6_2, "ledge_id")

		if not (not get_data and not self.smart_objects[get_data] and self.no_nav_mesh or not Unit.has_data(arg_6_2, "enabled_on_spawn") or Unit.get_data(arg_6_2, "enabled_on_spawn") ~= true) then
			self:init_nav_graphs(arg_6_2, get_data, tbl)
		end
	end

	if arg_6_3 == "LevelUnitSmartObjectExtension" then
		local _level_unit_smart_object_id = self:_level_unit_smart_object_id(arg_6_2)
		local smart_object_from_unit_data = self:smart_object_from_unit_data(arg_6_2, _level_unit_smart_object_id)

		self.smart_objects[_level_unit_smart_object_id] = smart_object_from_unit_data
		self.smart_object_ids[arg_6_2] = _level_unit_smart_object_id

		if not self.no_nav_mesh then
			self:init_nav_graphs(arg_6_2, _level_unit_smart_object_id, tbl)
		end
	end

	if arg_6_3 == "DynamicUnitSmartObjectExtension" then
		local _dynamic_unit_smart_object_id = self:_dynamic_unit_smart_object_id(arg_6_2)
		local smart_object_from_unit_data_2 = self:smart_object_from_unit_data(arg_6_2, _dynamic_unit_smart_object_id)

		self.smart_objects[_dynamic_unit_smart_object_id] = smart_object_from_unit_data_2
		self.smart_object_ids[arg_6_2] = _dynamic_unit_smart_object_id

		if not self.no_nav_mesh then
			local function fn()
				-- function 7
				self:init_nav_graphs(arg_6_2, _dynamic_unit_smart_object_id, tbl)
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)
		end
	end

	if arg_6_3 == "DarkPactClimbingExtension" then
		local smart_object_index = arg_6_4.smart_object_index

		tbl.swap, tbl.smart_object_index = arg_6_4.swap, smart_object_index
	end

	return tbl
end

NavGraphSystem.on_remove_extension = function (self, arg_8_1, arg_8_2)
	-- function 8
	NavGraphSystem.super.on_remove_extension(self, arg_8_1, arg_8_2)

	if arg_8_2 == "DynamicUnitSmartObjectExtension" then
		local var_8_0 = self.smart_object_ids[arg_8_1]

		self.smart_objects[var_8_0] = nil
		self.smart_object_ids[arg_8_1] = nil

		self:remove_nav_graph(arg_8_1)
	end
end

NavGraphSystem.extensions_ready = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if arg_9_3 == "DarkPactClimbingExtension" then
		self._level_jumps_ready = true
	end
end

NavGraphSystem._level_unit_smart_object_id = function (self, arg_10_1)
	-- function 10
	local current_level = LevelHelper:current_level(self.world)
	local num = 10000 + Level.unit_index(current_level, arg_10_1)

	fassert(not self.smart_objects[num], "Smart Object with id %s already registered!", num)

	return num
end

NavGraphSystem._dynamic_unit_smart_object_id = function (self, arg_11_1)
	-- function 11
	local num = 1000000 + self.dynamic_smart_object_index

	fassert(not self.smart_objects[num], "Smart Object with id %s already registered!", num)

	self.dynamic_smart_object_index = self.dynamic_smart_object_index + 1

	return num
end

NavGraphSystem.queue_add_nav_graph_from_flow = function (self, arg_12_1)
	-- function 12
	local var_12_0 = self.unit_extension_data[arg_12_1]

	fassert(var_12_0, "Tried to add nav graph from flow for a unit without nav graph extension. %s", arg_12_1)

	local nav_graphs_units_to_add = self.nav_graphs_units_to_add

	nav_graphs_units_to_add = nav_graphs_units_to_add or {}
	self.nav_graphs_units_to_add = nav_graphs_units_to_add
	self.nav_graphs_units_to_add[#self.nav_graphs_units_to_add + 1] = arg_12_1
end

NavGraphSystem.queue_remove_nav_graph_from_flow = function (self, arg_13_1)
	-- function 13
	local var_13_0 = self.unit_extension_data[arg_13_1]

	fassert(var_13_0, "Tried to remove nav graph from flow for a unit without nav graph extension. %s", arg_13_1)

	local nav_graphs_units_to_remove = self.nav_graphs_units_to_remove

	nav_graphs_units_to_remove = nav_graphs_units_to_remove or {}
	self.nav_graphs_units_to_remove = nav_graphs_units_to_remove
	self.nav_graphs_units_to_remove[#self.nav_graphs_units_to_remove + 1] = arg_13_1
end

NavGraphSystem.add_nav_graph = function (self, arg_14_1)
	-- function 14
	local var_14_0 = self.unit_extension_data[arg_14_1]

	fassert(var_14_0, "Tried to add nav graph from flow for a unit without nav graph extension. %s", arg_14_1)

	if not var_14_0.nav_graph_removed then
		local navgraphs = var_14_0.navgraphs

		for i = 1, #navgraphs do
			local var_14_2 = navgraphs[i]

			GwNavGraph.add_to_database(var_14_2)
			printf("[NavGraphSystem] Adding navgraph(s) for [%q]", tostring(arg_14_1))
		end

		var_14_0.nav_graph_removed = false
	end
end

NavGraphSystem.remove_nav_graph = function (self, arg_15_1)
	-- function 15
	local var_15_0 = self.unit_extension_data[arg_15_1]

	fassert(var_15_0, "Tried to remove nav graph from flow for a unit without nav graph extension. %s", arg_15_1)

	if not var_15_0.nav_graph_removed then
		local navgraphs = var_15_0.navgraphs

		for i = 1, #navgraphs do
			local var_15_2 = navgraphs[i]

			GwNavGraph.remove_from_database(var_15_2)
			printf("[NavGraphSystem] Removing navgraph(s) for [%q]", tostring(arg_15_1))
		end

		var_15_0.nav_graph_removed = true
	end
end

NavGraphSystem.init_nav_graph_from_flow = function (self, arg_16_1)
	-- function 16
	local var_16_0 = self.unit_extension_data[arg_16_1]

	fassert(var_16_0, "Tried to init nav graph from flow for a unit without nav graph extension. %s", arg_16_1)

	local has_data = Unit.has_data(arg_16_1, "enabled_on_spawn")

	has_data = not has_data and Unit.get_data(arg_16_1, "enabled_on_spawn") == false

	fassert(has_data, "Tried to init nav graph from flow for a unit without script data \"enabled_on_spawn\" set to false. %s", arg_16_1)
	fassert(not self.initialized_unit_nav_graphs[arg_16_1], "Tried to init nav graph from flow for a unit but the nav graph has already been initialized. %s", arg_16_1)

	local get_data = Unit.get_data(arg_16_1, "smart_object_id")

	get_data = get_data or Unit.get_data(arg_16_1, "ledge_id")

	if not (not get_data and not self.smart_objects[get_data] and self.no_nav_mesh) then
		self:init_nav_graphs(arg_16_1, get_data, var_16_0)
	end
end

NavGraphSystem.smart_object_from_unit_data = function (self, arg_17_1, arg_17_2)
	-- function 17
	local tbl = {}
	local num = 0

	while not Unit.has_data(arg_17_1, "smart_objects", num) do
		local var_17_2
		local var_17_3
		local get_data = Unit.get_data(arg_17_1, "smart_objects", num, "type")
		local get_data_2 = Unit.get_data(arg_17_1, "smart_objects", num, "is_one_way")

		if not Unit.has_data(arg_17_1, "smart_objects", num, "entrance_node") then
			local get_data_3 = Unit.get_data(arg_17_1, "smart_objects", num, "entrance_node")
			local get_data_4 = Unit.get_data(arg_17_1, "smart_objects", num, "exit_node")
			local nav_world = self.nav_world
			local num_2 = 0.5
			local num_3 = 0.5
			local num_4 = 0.5
			local num_5 = 0.1
			local node = Unit.node(arg_17_1, get_data_3)

			var_17_2 = Unit.world_position(arg_17_1, node)

			local triangle_from_position, var_17_15 = GwNavQueries.triangle_from_position(nav_world, var_17_2, num_2, num_3)

			if not triangle_from_position then
				var_17_2.z = var_17_15
			else
				local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, var_17_2, num_2, num_3, num_4, num_5)

				fassert(inside_position_from_outside_position, "[NavGraphSystem] While creating smart object of type %q could not find nav mesh for entrance position at %s.", get_data, var_17_2)

				var_17_2 = inside_position_from_outside_position
			end

			local node_2 = Unit.node(arg_17_1, get_data_4)

			var_17_3 = Unit.world_position(arg_17_1, node_2)

			local triangle_from_position_2, var_17_19 = GwNavQueries.triangle_from_position(nav_world, var_17_3, num_2, num_3)

			if not triangle_from_position_2 then
				var_17_3.z = var_17_19
			else
				local inside_position_from_outside_position_2 = GwNavQueries.inside_position_from_outside_position(nav_world, var_17_3, num_2, num_3, num_4, num_5)

				fassert(inside_position_from_outside_position_2, "[NavGraphSystem] While creating smart object of type %q could not find nav mesh for exit position at %s.", get_data, var_17_3)

				var_17_3 = inside_position_from_outside_position_2
			end
		else
			local get_data_5 = Unit.get_data(arg_17_1, "smart_objects", num, "node")
			local get_data_6 = Unit.get_data(arg_17_1, "smart_objects", num, "entrance", "offset_x")
			local get_data_7 = Unit.get_data(arg_17_1, "smart_objects", num, "entrance", "offset_y")
			local get_data_8 = Unit.get_data(arg_17_1, "smart_objects", num, "entrance", "offset_z")
			local get_data_9 = Unit.get_data(arg_17_1, "smart_objects", num, "exit", "offset_x")
			local get_data_10 = Unit.get_data(arg_17_1, "smart_objects", num, "exit", "offset_y")
			local get_data_11 = Unit.get_data(arg_17_1, "smart_objects", num, "exit", "offset_z")
			local node_3 = Unit.node(arg_17_1, get_data_5)
			local world_position = Unit.world_position(arg_17_1, node_3)
			local world_rotation = Unit.world_rotation(arg_17_1, node_3)
			local right = Quaternion.right(world_rotation)
			local forward = Quaternion.forward(world_rotation)
			local up = Quaternion.up(world_rotation)

			var_17_2 = world_position + right * get_data_6 + forward * get_data_7 + up * get_data_8
			var_17_3 = world_position + right * get_data_9 + forward * get_data_10 + up * get_data_11
		end

		num = num + 1
		tbl[num] = {
			data = {
				unit = arg_17_1
			},
			smart_object_type = get_data,
			smart_object_index = arg_17_2,
			pos1 = Vector3Aux.box(nil, var_17_2),
			pos2 = Vector3Aux.box(nil, var_17_3),
			is_one_way = get_data_2
		}
	end

	return tbl
end

NavGraphSystem.on_remove_extension = function (self, arg_18_1, arg_18_2)
	-- function 18
	ScriptUnit.remove_extension(arg_18_1, self.NAME)

	local var_18_0 = self.unit_extension_data[arg_18_1]

	for i = 1, #var_18_0.navgraphs do
		local var_18_1 = var_18_0.navgraphs[i]

		GwNavGraph.destroy(var_18_1)
	end

	self.unit_extension_data[arg_18_1] = nil
end

NavGraphSystem.update = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not self.nav_graphs_units_to_add then
		for i = 1, #self.nav_graphs_units_to_add do
			local var_19_0 = self.nav_graphs_units_to_add[i]

			self:add_nav_graph(var_19_0)
		end

		self.nav_graphs_units_to_add = nil
	elseif not self.nav_graphs_units_to_remove then
		for j = 1, #self.nav_graphs_units_to_remove do
			local var_19_1 = self.nav_graphs_units_to_remove[j]

			self:remove_nav_graph(var_19_1)
		end

		self.nav_graphs_units_to_remove = nil
	end
end

NavGraphSystem.hot_join_sync = function (arg_20_0, arg_20_1)
	-- function 20
	return
end

NavGraphSystem.get_smart_object_type = function (self, arg_21_1)
	-- function 21
	return self.smart_object_types[arg_21_1]
end

NavGraphSystem.get_smart_object_data = function (self, arg_22_1)
	-- function 22
	return self.smart_object_data[arg_22_1]
end

NavGraphSystem.get_smart_objects = function (self, arg_23_1)
	-- function 23
	return self.smart_objects[arg_23_1]
end

NavGraphSystem.get_smart_object_id = function (self, arg_24_1)
	-- function 24
	return self.smart_object_ids[arg_24_1]
end

NavGraphSystem.has_nav_graph = function (self, arg_25_1)
	-- function 25
	local var_25_0 = self.unit_extension_data[arg_25_1]

	if not var_25_0 then
		return true, not var_25_0.nav_graph_removed
	else
		return false, false
	end
end

local enum = table.enum("shown", "hidden", "partial")

NavGraphSystem._event_local_player_spawned = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	if not self._use_level_jumps and not Managers.state.game_mode:setting("hide_level_jumps") then
		return
	end

	if arg_26_3:name() ~= "dark_pact" then
		if self._level_jump_state ~= enum.hidden then
			for k in pairs(self.level_jumps) do
				ScriptUnit.extension(k, "interactable_system"):set_enabled(false)
			end
		end
	else
		local boss = arg_26_4.boss

		if not (not boss and self._level_jump_state == enum.partial) then
			for k_2 in pairs(self.level_jumps) do
				local get_data = Unit.get_data(k_2, "allow_boss_traversal")

				ScriptUnit.extension(k_2, "interactable_system"):set_enabled(get_data)
			end
		elseif not (boss or self._level_jump_state == enum.shown) then
			for k_3 in pairs(self.level_jumps) do
				ScriptUnit.extension(k_3, "interactable_system"):set_enabled(true)
			end
		end
	end
end
