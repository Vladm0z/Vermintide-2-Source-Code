-- chunkname: @scripts/managers/bot_nav_transition/bot_nav_transition_manager.lua

local function fn(arg_1_0, ...)
	-- function 1
	if script_data.ai_bots_debug or not script_data.ai_bot_transition_debug then
		printf("[BotNavTransitionManager] " .. arg_1_0, ...)
	end
end

local flag = false
local num = 0.1

BotNavTransitionManager = class(BotNavTransitionManager)
BotNavTransitionManager.TRANSITION_LAYERS = {
	end_zone = 1,
	bot_poison_wind = 20,
	fire_grenade = 30,
	barrel_explosion = 50,
	bot_damage_drops = 10,
	bot_jumps = 1,
	temporary_wall = 1,
	bot_leap_of_faith = 3,
	bot_ratling_gun_fire = 30,
	doors = 0.1,
	planks = 0.1,
	bot_ladders = 5,
	bot_drops = 1
}
BotNavTransitionManager.NAV_COST_MAP_LAYERS = {
	plague_wave = 30,
	mutator_heavens_zone = 50,
	lamp_oil_fire = 30,
	warpfire_thrower_warpfire = 30,
	vortex_near = 50,
	stormfiend_warpfire = 50,
	vortex_danger_zone = 75,
	troll_bile = 30
}

BotNavTransitionManager.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	self._world = arg_2_1
	self._physics_world = arg_2_2
	self._nav_world = arg_2_3
	self._index_offset = 471100
	self._current_index = self._index_offset + 1
	self._max_amount = 100
	self._bot_nav_transitions = {}
	self._bot_nav_transition_lookup = {}

	local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

	self._nav_cost_map_cost_table = create_tag_cost_table

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table, BotNavTransitionManager.NAV_COST_MAP_LAYERS)

	self._navtag_layer_cost_table = GwNavTagLayerCostTable.create()
	self._layerless_traverse_logic = GwNavTraverseLogic.create(arg_2_3, create_tag_cost_table)
	self._traverse_logic = GwNavTraverseLogic.create(arg_2_3, create_tag_cost_table)

	local clone = table.clone(BotNavTransitionManager.TRANSITION_LAYERS)

	table.merge(clone, NAV_TAG_VOLUME_LAYER_COST_BOTS)
	AiUtils.initialize_cost_table(self._navtag_layer_cost_table, clone)
	GwNavTraverseLogic.set_navtag_layer_cost_table(self._traverse_logic, self._navtag_layer_cost_table)

	self._ladder_smart_object_index = self._index_offset + self._max_amount
	self._ladder_transitions = {}
	self._debug_ladder_smart_objects_created = 0
	self._is_server = arg_2_4

	if not arg_2_6 then
		self._network_event_delegate = arg_2_5

		arg_2_5:register(self, "rpc_create_bot_nav_transition")
	end
end

BotNavTransitionManager.traverse_logic = function (self)
	-- function 3
	return self._traverse_logic
end

BotNavTransitionManager.update = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return
end

BotNavTransitionManager.clear_transitions = function (self)
	-- function 5
	local _bot_nav_transitions = self._bot_nav_transitions

	for k, v in pairs(_bot_nav_transitions) do
		self:_destroy_transition(_bot_nav_transitions, k)
	end
end

BotNavTransitionManager.destroy = function (self)
	-- function 6
	self._network_event_delegate:unregister(self)
	GwNavTagLayerCostTable.destroy(self._navtag_layer_cost_table)
	GwNavCostMap.destroy_tag_cost_table(self._nav_cost_map_cost_table)
	GwNavTraverseLogic.destroy(self._traverse_logic)
	GwNavTraverseLogic.destroy(self._layerless_traverse_logic)
end

BotNavTransitionManager._find_matching_layer = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local num = arg_7_2 - arg_7_1
	local length = Vector3.length(Vector3.flat(num))
	local z = num.z

	if not arg_7_3 then
		return "bot_leap_of_faith"
	end

	local heights = PlayerUnitMovementSettings.fall.heights
	local FALL_DAMAGE_MULTIPLIER = heights.FALL_DAMAGE_MULTIPLIER
	local MIN_FALL_DAMAGE_HEIGHT = heights.MIN_FALL_DAMAGE_HEIGHT
	local MIN_FALL_DAMAGE_PERCENTAGE = heights.MIN_FALL_DAMAGE_PERCENTAGE
	local MAX_FALL_DAMAGE_PERCENTAGE = heights.MAX_FALL_DAMAGE_PERCENTAGE
	local num_2 = 100
	local num_3 = num_2 * MIN_FALL_DAMAGE_PERCENTAGE
	local num_4 = num_2 * MAX_FALL_DAMAGE_PERCENTAGE

	if z < -(MIN_FALL_DAMAGE_HEIGHT + (num_2 * 0.5 - num_3) / FALL_DAMAGE_MULTIPLIER) then
		return nil
	elseif z < -MIN_FALL_DAMAGE_HEIGHT then
		return "bot_damage_drops"
	elseif z < -0.5 then
		return "bot_drops"
	end

	if z > 0.3 then
		return "bot_jumps"
	end
end

BotNavTransitionManager._destroy_transition = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = arg_8_1[arg_8_2]

	arg_8_1[arg_8_2] = nil
	self._bot_nav_transition_lookup[var_8_0.unit] = nil

	local graph = var_8_0.graph

	GwNavGraph.destroy(graph)
	World.destroy_unit(self._world, var_8_0.unit)
end

BotNavTransitionManager.rpc_create_bot_nav_transition = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	self:create_transition(arg_9_2, arg_9_3, arg_9_4, arg_9_5)
end

BotNavTransitionManager.create_transition = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	if not self._is_server then
		Managers.state.network.network_transmit:send_rpc_server("rpc_create_bot_nav_transition", arg_10_1, arg_10_2, arg_10_3, arg_10_4 or false)

		return
	end

	local _world = self._world
	local _physics_world = self._physics_world
	local immediate_overlap = PhysicsWorld.immediate_overlap(_physics_world, "position", arg_10_1, "shape", "sphere", "size", 0.1, "collision_filter", "filter_bot_nav_transition_overlap")

	if not (not immediate_overlap and #immediate_overlap > 0) then
		return false
	end

	local _nav_world = self._nav_world
	local num_2 = 0.3
	local num_3 = 0.3
	local triangle_from_position, var_10_7 = GwNavQueries.triangle_from_position(_nav_world, arg_10_3, num_2, num_3, self._layerless_traverse_logic)

	if not triangle_from_position then
		local num_4 = 0.9
		local var_10_9 = arg_10_3

		arg_10_3 = GwNavQueries.inside_position_from_outside_position(_nav_world, arg_10_3, num_2, num_3, num_4)

		if not arg_10_3 then
			var_10_7 = arg_10_3.z
		else
			return false
		end
	end

	local var_10_10 = Vector3(arg_10_3.x, arg_10_3.y, var_10_7)

	if not GwNavQueries.raycango(_nav_world, arg_10_1, var_10_10, self._traverse_logic) then
		return false
	end

	local _find_matching_layer = self:_find_matching_layer(arg_10_1, var_10_10, arg_10_4)

	if not _find_matching_layer then
		return false
	end

	local _current_index = self._current_index
	local _bot_nav_transitions = self._bot_nav_transitions

	if not _bot_nav_transitions[_current_index] then
		self:_destroy_transition(_bot_nav_transitions, _current_index)
	end

	local var_10_14 = LAYER_ID_MAPPING[_find_matching_layer]

	fassert(var_10_14, "Layer %s is not defined.", _find_matching_layer)

	local var_10_15

	if not arg_10_4 then
		var_10_15 = arg_10_2
	else
		local normalize = Vector3.normalize(Vector3.flat(arg_10_2 - arg_10_1))

		if Vector3.length_squared(normalize) > 0.001 then
			local num_5 = arg_10_2 + normalize * num
			local immediate_raycast, var_10_19 = PhysicsWorld.immediate_raycast(_physics_world, arg_10_2, normalize, num, "closest", "collision_filter", "filter_player_mover")

			if not immediate_raycast then
				var_10_15 = var_10_19
			else
				var_10_15 = num_5
			end
		else
			var_10_15 = arg_10_2
		end
	end

	local var_10_20 = GwNavGraph.create(_nav_world, flag, {
		arg_10_1,
		var_10_15,
		var_10_10
	}, Colors.get("blue"), var_10_14, _current_index)

	GwNavGraph.add_to_database(var_10_20)

	local spawn_unit = World.spawn_unit(_world, "scripts/managers/bot_nav_transition/bot_nav_transition", arg_10_1)

	Unit.set_data(spawn_unit, "bot_nav_transition_manager_index", _current_index)

	_bot_nav_transitions[_current_index] = {
		graph = var_10_20,
		from = Vector3Box(arg_10_1),
		waypoint = Vector3Box(var_10_15),
		to = Vector3Box(var_10_10),
		unit = spawn_unit,
		type = _find_matching_layer,
		permanent = arg_10_5 or false
	}
	self._bot_nav_transition_lookup[spawn_unit] = _current_index

	local var_10_22 = _current_index

	repeat
		var_10_22 = (var_10_22 - self._index_offset) % self._max_amount + 1 + self._index_offset
	until not (not _bot_nav_transitions[var_10_22] and _bot_nav_transitions[var_10_22].permanent)

	self._current_index = var_10_22

	return true, spawn_unit
end

BotNavTransitionManager.unregister_transition = function (self, arg_11_1)
	-- function 11
	local var_11_0 = self._bot_nav_transition_lookup[arg_11_1]

	fassert(var_11_0, "No transition index found for unit %s.", arg_11_1)
	self:_destroy_transition(self._bot_nav_transitions, var_11_0)
end

BotNavTransitionManager.transition_data = function (self, arg_12_1)
	-- function 12
	local var_12_0 = self._ladder_transitions[arg_12_1]

	if not var_12_0 then
		return "ladder", var_12_0.from:unbox(), var_12_0.to:unbox()
	else
		local var_12_1 = self._bot_nav_transition_lookup[arg_12_1]
		local var_12_2 = self._bot_nav_transitions[var_12_1]

		return var_12_2.type, var_12_2.from:unbox(), var_12_2.to:unbox(), var_12_2.waypoint:unbox()
	end
end

BotNavTransitionManager.register_ladder = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local tbl = {}
	local var_13_1
	local flag = arg_13_2 or 0

	self._ladder_transitions[arg_13_1] = tbl

	local _nav_world = self._nav_world
	local node = Unit.node(arg_13_1, "c_platform")
	local world_rotation = Unit.world_rotation(arg_13_1, flag)
	local num = -Quaternion.forward(world_rotation)
	local normalize = Vector3.normalize(Vector3.flat(num))
	local num_2 = -Quaternion.up(world_rotation)
	local world_position = Unit.world_position(arg_13_1, node)
	local get_data = Unit.get_data(arg_13_1, "bottom_node")
	local node_2

	if not get_data then
		node_2 = Unit.node(arg_13_1, get_data)

		if not node_2 then
			-- Nothing
		end
	end

	node_2 = flag

	::label_13_0::

	local world_position_2 = Unit.world_position(arg_13_1, node_2)
	local dot = Vector3.dot(world_position_2 - world_position, num_2)
	local _physics_world = self._physics_world
	local num_3 = world_position + num * 1
	local num_4 = dot + 10
	local immediate_raycast, var_13_18 = PhysicsWorld.immediate_raycast(_physics_world, num_3, num_2, num_4, "closest", "collision_filter", "filter_bot_nav_transition_ladder_ray")

	if not immediate_raycast then
		tbl.failed = true
		tbl.to = Vector3Box(num_3)
		tbl.from = Vector3Box(num_3 + num_2 * num_4)

		return var_13_1
	end

	local var_13_19
	local var_13_20
	local var_13_21
	local var_13_22
	local num_5 = world_position_2 - num_2 * dot
	local triangle_from_position, var_13_25 = GwNavQueries.triangle_from_position(_nav_world, num_5, 0.3, 0.5, self._layerless_traverse_logic)

	if not triangle_from_position then
		var_13_20 = Vector3(num_5.x, num_5.y, var_13_25)
	else
		local num_6 = 0.2
		local num_7 = 5

		for i = 1, num_7 do
			local num_8 = num_5 - normalize * num_6 * i
			local var_13_29

			triangle_from_position, var_13_29 = GwNavQueries.triangle_from_position(_nav_world, num_8, 0.3, 0.5, self._layerless_traverse_logic)

			if not triangle_from_position then
				var_13_20 = num_8
				var_13_20.z = var_13_29

				break
			end
		end

		if not triangle_from_position then
			tbl.failed = true
			var_13_20 = num_5
		end
	end

	local triangle_from_position_2, var_13_31 = GwNavQueries.triangle_from_position(_nav_world, var_13_18, 0.3, 0.5, self._layerless_traverse_logic)

	if not triangle_from_position_2 then
		var_13_19 = Vector3(var_13_18.x, var_13_18.y, var_13_31)
	else
		local num_9 = 0.2
		local num_10 = 5

		for j = 1, num_10 do
			local num_11 = var_13_18 + normalize * num_9 * j
			local var_13_35

			triangle_from_position_2, var_13_35 = GwNavQueries.triangle_from_position(_nav_world, num_11, 0.3, 0.5, self._layerless_traverse_logic)

			if not triangle_from_position_2 then
				var_13_19 = num_11
				var_13_19.z = var_13_35

				break
			end
		end

		if not triangle_from_position_2 then
			tbl.failed = true
			var_13_19 = var_13_18
		end
	end

	if not tbl.failed then
		-- Nothing
	else
		local num_12 = self._ladder_smart_object_index + 1
		local num_13 = 1.5
		local flag_2 = var_13_18.z > world_position_2.z - num_13
		local str = "bot_ladders"
		local var_13_40 = LAYER_ID_MAPPING[str]

		fassert(var_13_40, "Layer %s is not defined.", str)

		local var_13_41 = GwNavGraph.create(_nav_world, flag_2, {
			var_13_20,
			world_position,
			var_13_18 + num * 0.2,
			var_13_19
		}, Colors.get("blue"), var_13_40, num_12)

		GwNavGraph.add_to_database(var_13_41)

		self._ladder_smart_object_index = num_12
		tbl.index = num_12
		tbl.graph = var_13_41
		self._debug_ladder_smart_objects_created = self._debug_ladder_smart_objects_created + 1
	end

	tbl.from = Vector3Box(var_13_19)
	tbl.to = Vector3Box(var_13_20)

	return var_13_1
end

BotNavTransitionManager.get_ladder_coordinates = function (self, arg_14_1)
	-- function 14
	local var_14_0 = self._ladder_transitions[arg_14_1]

	return var_14_0.from:unbox(), var_14_0.to:unbox(), var_14_0.failed
end

BotNavTransitionManager.debug_refresh_ladders = function (self)
	-- function 15
	print("[BotNavTransitionManager] Refreshing ladders...")

	local tbl = {}

	for k, v in pairs(self._ladder_transitions) do
		self:unregister_ladder(k)

		tbl[#tbl + 1] = k
	end

	self._ladder_smart_object_index = self._index_offset + self._max_amount

	fassert(self._debug_ladder_smart_objects_created == 0, "Failed to clean up all ladder smart objects during refresh, %i left.", self._debug_ladder_smart_objects_created)

	for i, v_2 in ipairs(tbl) do
		self:register_ladder(v_2)
	end
end

BotNavTransitionManager.clear_ladder_transitions = function (self)
	-- function 16
	local _ladder_transitions = self._ladder_transitions

	for k, v in pairs(_ladder_transitions) do
		self:unregister_ladder(k)
	end
end

BotNavTransitionManager.unregister_ladder = function (self, arg_17_1)
	-- function 17
	local var_17_0 = self._ladder_transitions[arg_17_1]
	local graph = var_17_0.graph

	if not var_17_0.failed then
		GwNavGraph.destroy(graph)

		self._debug_ladder_smart_objects_created = self._debug_ladder_smart_objects_created - 1
	end

	self._ladder_transitions[arg_17_1] = nil
end

BotNavTransitionManager.allow_layer = function (self, arg_18_1, arg_18_2)
	-- function 18
	local var_18_0 = LAYER_ID_MAPPING[arg_18_1]

	if not arg_18_2 then
		GwNavTagLayerCostTable.allow_layer(self._navtag_layer_cost_table, var_18_0)
	else
		GwNavTagLayerCostTable.forbid_layer(self._navtag_layer_cost_table, var_18_0)
	end
end

BotNavTransitionManager.set_layer_cost = function (self, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = LAYER_ID_MAPPING[arg_19_1]

	GwNavTagLayerCostTable.set_layer_cost_multiplier(self._navtag_layer_cost_table, var_19_0, arg_19_2)
end
