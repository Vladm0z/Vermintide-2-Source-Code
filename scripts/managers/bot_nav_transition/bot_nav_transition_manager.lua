-- chunkname: @scripts/managers/bot_nav_transition/bot_nav_transition_manager.lua

local function var_0_0(arg_1_0, ...)
	if script_data.ai_bots_debug or script_data.ai_bot_transition_debug then
		printf("[BotNavTransitionManager] " .. arg_1_0, ...)
	end
end

local var_0_1 = false
local var_0_2 = 0.1

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

BotNavTransitionManager.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_0._world = arg_2_1
	arg_2_0._physics_world = arg_2_2
	arg_2_0._nav_world = arg_2_3
	arg_2_0._index_offset = 471100
	arg_2_0._current_index = arg_2_0._index_offset + 1
	arg_2_0._max_amount = 100
	arg_2_0._bot_nav_transitions = {}
	arg_2_0._bot_nav_transition_lookup = {}

	local var_2_0 = GwNavCostMap.create_tag_cost_table()

	arg_2_0._nav_cost_map_cost_table = var_2_0

	AiUtils.initialize_nav_cost_map_cost_table(var_2_0, BotNavTransitionManager.NAV_COST_MAP_LAYERS)

	arg_2_0._navtag_layer_cost_table = GwNavTagLayerCostTable.create()
	arg_2_0._layerless_traverse_logic = GwNavTraverseLogic.create(arg_2_3, var_2_0)
	arg_2_0._traverse_logic = GwNavTraverseLogic.create(arg_2_3, var_2_0)

	local var_2_1 = table.clone(BotNavTransitionManager.TRANSITION_LAYERS)

	table.merge(var_2_1, NAV_TAG_VOLUME_LAYER_COST_BOTS)
	AiUtils.initialize_cost_table(arg_2_0._navtag_layer_cost_table, var_2_1)
	GwNavTraverseLogic.set_navtag_layer_cost_table(arg_2_0._traverse_logic, arg_2_0._navtag_layer_cost_table)

	arg_2_0._ladder_smart_object_index = arg_2_0._index_offset + arg_2_0._max_amount
	arg_2_0._ladder_transitions = {}
	arg_2_0._debug_ladder_smart_objects_created = 0
	arg_2_0._is_server = arg_2_4

	if not arg_2_6 then
		arg_2_0._network_event_delegate = arg_2_5

		arg_2_5:register(arg_2_0, "rpc_create_bot_nav_transition")
	end
end

BotNavTransitionManager.traverse_logic = function (arg_3_0)
	return arg_3_0._traverse_logic
end

BotNavTransitionManager.update = function (arg_4_0, arg_4_1, arg_4_2)
	return
end

BotNavTransitionManager.clear_transitions = function (arg_5_0)
	local var_5_0 = arg_5_0._bot_nav_transitions

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		arg_5_0:_destroy_transition(var_5_0, iter_5_0)
	end
end

BotNavTransitionManager.destroy = function (arg_6_0)
	arg_6_0._network_event_delegate:unregister(arg_6_0)
	GwNavTagLayerCostTable.destroy(arg_6_0._navtag_layer_cost_table)
	GwNavCostMap.destroy_tag_cost_table(arg_6_0._nav_cost_map_cost_table)
	GwNavTraverseLogic.destroy(arg_6_0._traverse_logic)
	GwNavTraverseLogic.destroy(arg_6_0._layerless_traverse_logic)
end

BotNavTransitionManager._find_matching_layer = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2 - arg_7_1
	local var_7_1 = Vector3.length(Vector3.flat(var_7_0))
	local var_7_2 = var_7_0.z

	if arg_7_3 then
		return "bot_leap_of_faith"
	end

	local var_7_3 = PlayerUnitMovementSettings.fall.heights
	local var_7_4 = var_7_3.FALL_DAMAGE_MULTIPLIER
	local var_7_5 = var_7_3.MIN_FALL_DAMAGE_HEIGHT
	local var_7_6 = var_7_3.MIN_FALL_DAMAGE_PERCENTAGE
	local var_7_7 = var_7_3.MAX_FALL_DAMAGE_PERCENTAGE
	local var_7_8 = 100
	local var_7_9 = var_7_8 * var_7_6
	local var_7_10 = var_7_8 * var_7_7

	if var_7_2 < -(var_7_5 + (var_7_8 * 0.5 - var_7_9) / var_7_4) then
		return nil
	elseif var_7_2 < -var_7_5 then
		return "bot_damage_drops"
	elseif var_7_2 < -0.5 then
		return "bot_drops"
	end

	if var_7_2 > 0.3 then
		return "bot_jumps"
	end
end

BotNavTransitionManager._destroy_transition = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1[arg_8_2]

	arg_8_1[arg_8_2] = nil
	arg_8_0._bot_nav_transition_lookup[var_8_0.unit] = nil

	local var_8_1 = var_8_0.graph

	GwNavGraph.destroy(var_8_1)
	World.destroy_unit(arg_8_0._world, var_8_0.unit)
end

BotNavTransitionManager.rpc_create_bot_nav_transition = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	arg_9_0:create_transition(arg_9_2, arg_9_3, arg_9_4, arg_9_5)
end

BotNavTransitionManager.create_transition = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	if not arg_10_0._is_server then
		Managers.state.network.network_transmit:send_rpc_server("rpc_create_bot_nav_transition", arg_10_1, arg_10_2, arg_10_3, arg_10_4 or false)

		return
	end

	local var_10_0 = arg_10_0._world
	local var_10_1 = arg_10_0._physics_world
	local var_10_2 = PhysicsWorld.immediate_overlap(var_10_1, "position", arg_10_1, "shape", "sphere", "size", 0.1, "collision_filter", "filter_bot_nav_transition_overlap")

	if var_10_2 and #var_10_2 > 0 then
		return false
	end

	local var_10_3 = arg_10_0._nav_world
	local var_10_4 = 0.3
	local var_10_5 = 0.3
	local var_10_6, var_10_7 = GwNavQueries.triangle_from_position(var_10_3, arg_10_3, var_10_4, var_10_5, arg_10_0._layerless_traverse_logic)

	if not var_10_6 then
		local var_10_8 = 0.9
		local var_10_9 = arg_10_3

		arg_10_3 = GwNavQueries.inside_position_from_outside_position(var_10_3, arg_10_3, var_10_4, var_10_5, var_10_8)

		if arg_10_3 then
			var_10_7 = arg_10_3.z
		else
			return false
		end
	end

	local var_10_10 = Vector3(arg_10_3.x, arg_10_3.y, var_10_7)

	if GwNavQueries.raycango(var_10_3, arg_10_1, var_10_10, arg_10_0._traverse_logic) then
		return false
	end

	local var_10_11 = arg_10_0:_find_matching_layer(arg_10_1, var_10_10, arg_10_4)

	if not var_10_11 then
		return false
	end

	local var_10_12 = arg_10_0._current_index
	local var_10_13 = arg_10_0._bot_nav_transitions

	if var_10_13[var_10_12] then
		arg_10_0:_destroy_transition(var_10_13, var_10_12)
	end

	local var_10_14 = LAYER_ID_MAPPING[var_10_11]

	fassert(var_10_14, "Layer %s is not defined.", var_10_11)

	local var_10_15

	if arg_10_4 then
		var_10_15 = arg_10_2
	else
		local var_10_16 = Vector3.normalize(Vector3.flat(arg_10_2 - arg_10_1))

		if Vector3.length_squared(var_10_16) > 0.001 then
			local var_10_17 = arg_10_2 + var_10_16 * var_0_2
			local var_10_18, var_10_19 = PhysicsWorld.immediate_raycast(var_10_1, arg_10_2, var_10_16, var_0_2, "closest", "collision_filter", "filter_player_mover")

			if var_10_18 then
				var_10_15 = var_10_19
			else
				var_10_15 = var_10_17
			end
		else
			var_10_15 = arg_10_2
		end
	end

	local var_10_20 = GwNavGraph.create(var_10_3, var_0_1, {
		arg_10_1,
		var_10_15,
		var_10_10
	}, Colors.get("blue"), var_10_14, var_10_12)

	GwNavGraph.add_to_database(var_10_20)

	local var_10_21 = World.spawn_unit(var_10_0, "scripts/managers/bot_nav_transition/bot_nav_transition", arg_10_1)

	Unit.set_data(var_10_21, "bot_nav_transition_manager_index", var_10_12)

	var_10_13[var_10_12] = {
		graph = var_10_20,
		from = Vector3Box(arg_10_1),
		waypoint = Vector3Box(var_10_15),
		to = Vector3Box(var_10_10),
		unit = var_10_21,
		type = var_10_11,
		permanent = arg_10_5 or false
	}
	arg_10_0._bot_nav_transition_lookup[var_10_21] = var_10_12

	local var_10_22 = var_10_12

	repeat
		var_10_22 = (var_10_22 - arg_10_0._index_offset) % arg_10_0._max_amount + 1 + arg_10_0._index_offset
	until not var_10_13[var_10_22] or not var_10_13[var_10_22].permanent

	arg_10_0._current_index = var_10_22

	return true, var_10_21
end

BotNavTransitionManager.unregister_transition = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._bot_nav_transition_lookup[arg_11_1]

	fassert(var_11_0, "No transition index found for unit %s.", arg_11_1)
	arg_11_0:_destroy_transition(arg_11_0._bot_nav_transitions, var_11_0)
end

BotNavTransitionManager.transition_data = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._ladder_transitions[arg_12_1]

	if var_12_0 then
		return "ladder", var_12_0.from:unbox(), var_12_0.to:unbox()
	else
		local var_12_1 = arg_12_0._bot_nav_transition_lookup[arg_12_1]
		local var_12_2 = arg_12_0._bot_nav_transitions[var_12_1]

		return var_12_2.type, var_12_2.from:unbox(), var_12_2.to:unbox(), var_12_2.waypoint:unbox()
	end
end

BotNavTransitionManager.register_ladder = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = {}
	local var_13_1
	local var_13_2 = arg_13_2 or 0

	arg_13_0._ladder_transitions[arg_13_1] = var_13_0

	local var_13_3 = arg_13_0._nav_world
	local var_13_4 = Unit.node(arg_13_1, "c_platform")
	local var_13_5 = Unit.world_rotation(arg_13_1, var_13_2)
	local var_13_6 = -Quaternion.forward(var_13_5)
	local var_13_7 = Vector3.normalize(Vector3.flat(var_13_6))
	local var_13_8 = -Quaternion.up(var_13_5)
	local var_13_9 = Unit.world_position(arg_13_1, var_13_4)
	local var_13_10 = Unit.get_data(arg_13_1, "bottom_node")
	local var_13_11 = var_13_10 and Unit.node(arg_13_1, var_13_10) or var_13_2
	local var_13_12 = Unit.world_position(arg_13_1, var_13_11)
	local var_13_13 = Vector3.dot(var_13_12 - var_13_9, var_13_8)
	local var_13_14 = arg_13_0._physics_world
	local var_13_15 = var_13_9 + var_13_6 * 1
	local var_13_16 = var_13_13 + 10
	local var_13_17, var_13_18 = PhysicsWorld.immediate_raycast(var_13_14, var_13_15, var_13_8, var_13_16, "closest", "collision_filter", "filter_bot_nav_transition_ladder_ray")

	if not var_13_17 then
		var_13_0.failed = true
		var_13_0.to = Vector3Box(var_13_15)
		var_13_0.from = Vector3Box(var_13_15 + var_13_8 * var_13_16)

		return var_13_1
	end

	local var_13_19
	local var_13_20
	local var_13_21
	local var_13_22
	local var_13_23 = var_13_12 - var_13_8 * var_13_13
	local var_13_24, var_13_25 = GwNavQueries.triangle_from_position(var_13_3, var_13_23, 0.3, 0.5, arg_13_0._layerless_traverse_logic)

	if var_13_24 then
		var_13_20 = Vector3(var_13_23.x, var_13_23.y, var_13_25)
	else
		local var_13_26 = 0.2
		local var_13_27 = 5

		for iter_13_0 = 1, var_13_27 do
			local var_13_28 = var_13_23 - var_13_7 * var_13_26 * iter_13_0
			local var_13_29

			var_13_24, var_13_29 = GwNavQueries.triangle_from_position(var_13_3, var_13_28, 0.3, 0.5, arg_13_0._layerless_traverse_logic)

			if var_13_24 then
				var_13_20 = var_13_28
				var_13_20.z = var_13_29

				break
			end
		end

		if not var_13_24 then
			var_13_0.failed = true
			var_13_20 = var_13_23
		end
	end

	local var_13_30, var_13_31 = GwNavQueries.triangle_from_position(var_13_3, var_13_18, 0.3, 0.5, arg_13_0._layerless_traverse_logic)

	if var_13_30 then
		var_13_19 = Vector3(var_13_18.x, var_13_18.y, var_13_31)
	else
		local var_13_32 = 0.2
		local var_13_33 = 5

		for iter_13_1 = 1, var_13_33 do
			local var_13_34 = var_13_18 + var_13_7 * var_13_32 * iter_13_1
			local var_13_35

			var_13_30, var_13_35 = GwNavQueries.triangle_from_position(var_13_3, var_13_34, 0.3, 0.5, arg_13_0._layerless_traverse_logic)

			if var_13_30 then
				var_13_19 = var_13_34
				var_13_19.z = var_13_35

				break
			end
		end

		if not var_13_30 then
			var_13_0.failed = true
			var_13_19 = var_13_18
		end
	end

	if var_13_0.failed then
		-- Nothing
	else
		local var_13_36 = arg_13_0._ladder_smart_object_index + 1
		local var_13_37 = 1.5
		local var_13_38 = var_13_18.z > var_13_12.z - var_13_37
		local var_13_39 = "bot_ladders"
		local var_13_40 = LAYER_ID_MAPPING[var_13_39]

		fassert(var_13_40, "Layer %s is not defined.", var_13_39)

		local var_13_41 = GwNavGraph.create(var_13_3, var_13_38, {
			var_13_20,
			var_13_9,
			var_13_18 + var_13_6 * 0.2,
			var_13_19
		}, Colors.get("blue"), var_13_40, var_13_36)

		GwNavGraph.add_to_database(var_13_41)

		arg_13_0._ladder_smart_object_index = var_13_36
		var_13_0.index = var_13_36
		var_13_0.graph = var_13_41
		arg_13_0._debug_ladder_smart_objects_created = arg_13_0._debug_ladder_smart_objects_created + 1
	end

	var_13_0.from = Vector3Box(var_13_19)
	var_13_0.to = Vector3Box(var_13_20)

	return var_13_1
end

BotNavTransitionManager.get_ladder_coordinates = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._ladder_transitions[arg_14_1]

	return var_14_0.from:unbox(), var_14_0.to:unbox(), var_14_0.failed
end

BotNavTransitionManager.debug_refresh_ladders = function (arg_15_0)
	print("[BotNavTransitionManager] Refreshing ladders...")

	local var_15_0 = {}

	for iter_15_0, iter_15_1 in pairs(arg_15_0._ladder_transitions) do
		arg_15_0:unregister_ladder(iter_15_0)

		var_15_0[#var_15_0 + 1] = iter_15_0
	end

	arg_15_0._ladder_smart_object_index = arg_15_0._index_offset + arg_15_0._max_amount

	fassert(arg_15_0._debug_ladder_smart_objects_created == 0, "Failed to clean up all ladder smart objects during refresh, %i left.", arg_15_0._debug_ladder_smart_objects_created)

	for iter_15_2, iter_15_3 in ipairs(var_15_0) do
		arg_15_0:register_ladder(iter_15_3)
	end
end

BotNavTransitionManager.clear_ladder_transitions = function (arg_16_0)
	local var_16_0 = arg_16_0._ladder_transitions

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		arg_16_0:unregister_ladder(iter_16_0)
	end
end

BotNavTransitionManager.unregister_ladder = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ladder_transitions[arg_17_1]
	local var_17_1 = var_17_0.graph

	if not var_17_0.failed then
		GwNavGraph.destroy(var_17_1)

		arg_17_0._debug_ladder_smart_objects_created = arg_17_0._debug_ladder_smart_objects_created - 1
	end

	arg_17_0._ladder_transitions[arg_17_1] = nil
end

BotNavTransitionManager.allow_layer = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = LAYER_ID_MAPPING[arg_18_1]

	if arg_18_2 then
		GwNavTagLayerCostTable.allow_layer(arg_18_0._navtag_layer_cost_table, var_18_0)
	else
		GwNavTagLayerCostTable.forbid_layer(arg_18_0._navtag_layer_cost_table, var_18_0)
	end
end

BotNavTransitionManager.set_layer_cost = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = LAYER_ID_MAPPING[arg_19_1]

	GwNavTagLayerCostTable.set_layer_cost_multiplier(arg_19_0._navtag_layer_cost_table, var_19_0, arg_19_2)
end
