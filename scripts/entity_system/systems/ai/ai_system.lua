-- chunkname: @scripts/entity_system/systems/ai/ai_system.lua

require("scripts/utils/ai_debugger")
require("scripts/helpers/level_helper")
require("scripts/helpers/network_utils")
require("scripts/settings/terror_events/terror_event_utils")

UNIT_UNIQUE_IDS = UNIT_UNIQUE_IDS or 0
VISUAL_DEBUGGING_ENABLED = VISUAL_DEBUGGING_ENABLED or false
GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD or {}
AISystem = class(AISystem, ExtensionSystemBase)

local var_0_0 = script_data
local var_0_1 = POSITION_LOOKUP
local var_0_2 = Vector3.distance
local var_0_3 = Vector3.dot
local var_0_4 = Vector3.normalize
local var_0_5 = math.sqrt
local var_0_6 = Unit.alive
local var_0_7 = {}

var_0_0.disable_ai_perception = var_0_0.disable_ai_perception or Development.parameter("disable_ai_perception")

local var_0_8 = false
local var_0_9 = 1024
local var_0_10 = 128
local var_0_11 = 0.5
local var_0_12 = {
	"rpc_alert_enemies_within_range",
	"rpc_set_allowed_nav_layer",
	"rpc_change_tentacle_state",
	"rpc_sync_tentacle_path",
	"rpc_set_ward_state",
	"rpc_set_hit_reaction_template",
	"rpc_set_corruptor_beam_state",
	"rpc_check_trigger_backstab_sfx",
	"rpc_set_attribute_bool",
	"rpc_set_attribute_int",
	"rpc_remove_attribute"
}
local var_0_13 = {
	"AISimpleExtension",
	"AiHuskBaseExtension",
	"PlayerBotBase"
}

AttributeDefinition = {
	grudge_marked = {
		name_index = function (arg_1_0, arg_1_1)
			if arg_1_1 then
				Unit.flow_event(arg_1_0, "enable_grudge")
				print("New enhanced breed spawned")
			else
				Unit.flow_event(arg_1_0, "disable_grudge")
			end
		end
	},
	breed_enhancements = {},
	training_dummy = {
		armor = function (arg_2_0, arg_2_1)
			local var_2_0 = arg_2_1

			Unit.set_visibility(arg_2_0, "vg_armor", var_2_0)

			local var_2_1 = var_2_0 and 2 or 1

			Unit.set_data(arg_2_0, "armor", var_2_1)

			local var_2_2 = var_2_0 and "skaven" or "chaos"

			Unit.set_data(arg_2_0, "race", var_2_2)
		end
	}
}

for iter_0_0, iter_0_1 in pairs(BreedEnhancements) do
	if not iter_0_1.no_attribute then
		AttributeDefinition.breed_enhancements[iter_0_0] = false
	end
end

AISystem.init = function (arg_3_0, arg_3_1, arg_3_2)
	AISystem.super.init(arg_3_0, arg_3_1, arg_3_2, var_0_13)

	local var_3_0 = {}
	local var_3_1 = Managers.state.side:sides()

	for iter_3_0 = 1, #var_3_1 do
		local var_3_2 = var_3_1[iter_3_0]

		var_3_0[#var_3_0 + 1] = var_3_2:name()
	end

	arg_3_0.broadphase = Broadphase(50, 128, var_3_0)
	arg_3_0._behavior_trees = {}
	arg_3_0.group_blackboard = {
		rats_currently_moving_to_ip = 0,
		special_targets = {},
		disabled_by_special = {},
		broadphase = arg_3_0.broadphase,
		slots = {},
		slots_cleared = {}
	}

	arg_3_0:create_all_trees()

	local var_3_3 = GwNavWorld.create(Matrix4x4.identity())

	arg_3_0._nav_world = var_3_3
	GLOBAL_AI_NAVWORLD = var_3_3

	if PLATFORM ~= Application.WIN32 then
		GwNavWorld.set_pathfinder_budget(var_3_3, 0.0045)
	end

	if not var_0_0.disable_crowd_dispersion then
		GwNavWorld.enable_crowd_dispersion(var_3_3)
	end

	if var_0_0.debug_enabled and var_0_0.navigation_visual_debug_enabled and not VISUAL_DEBUGGING_ENABLED then
		VISUAL_DEBUGGING_ENABLED = true

		GwNavWorld.init_visual_debug_server(var_3_3, 4888)
	end

	if not var_0_0.navigation_thread_disabled then
		GwNavWorld.init_async_update(var_3_3)
	end

	local var_3_4 = LevelHelper:current_level_settings()
	local var_3_5 = var_3_4.level_name
	local var_3_6 = arg_3_1.world

	if LEVEL_EDITOR_TEST then
		var_3_5 = Application.get_data("LevelEditor", "level_resource_name")
	end

	if not var_3_4.no_nav_mesh then
		local var_3_7 = LevelResource.nested_level_count(var_3_5)
		local var_3_8 = {}

		var_3_8[#var_3_8 + 1] = GwNavWorld.add_navdata(var_3_3, var_3_5)

		for iter_3_1 = 0, var_3_7 - 1 do
			local var_3_9 = LevelResource.nested_level_resource_name(var_3_5, iter_3_1)

			print("nested_level_name", var_3_9)

			var_3_8[#var_3_8 + 1] = GwNavWorld.add_navdata(var_3_3, var_3_9)
		end

		arg_3_0._nav_data = var_3_8

		if var_0_0.debug_enabled then
			arg_3_0.ai_debugger = AIDebugger:new(var_3_6, var_3_3, arg_3_0.group_blackboard, arg_3_0.is_server, arg_3_1.free_flight_manager)
		end
	end

	arg_3_0._nav_cost_map_id_data = {
		size = 0,
		current_id = 1,
		ids = Script.new_array(var_0_10),
		max_size = var_0_10
	}
	arg_3_0._nav_cost_map_volume_id_data = {
		size = 0,
		current_id = 1,
		ids = Script.new_array(var_0_9),
		max_size = var_0_9
	}
	arg_3_0._nav_cost_maps_data = Script.new_array(var_0_10)
	arg_3_0._should_recompute_nav_cost_maps = false
	arg_3_0._previous_nav_cost_map_recomputation_t = 0
	arg_3_0.unit_extension_data = {}
	arg_3_0.frozen_unit_extension_data = {}
	arg_3_0.blackboards = BLACKBOARDS
	arg_3_0.ai_blackboard_updates = {}
	arg_3_0.ai_blackboard_prioritized_updates = {}
	arg_3_0.ai_update_index = 1
	arg_3_0._units_to_destroy = {}
	arg_3_0.ai_units_alive = {}
	arg_3_0.ai_units_perception_continuous = {}
	arg_3_0.ai_units_perception = {}
	arg_3_0.ai_units_perception_prioritized = {}
	arg_3_0.num_perception_units = 0
	arg_3_0.world = arg_3_1.world
	arg_3_0.number_ordinary_aggroed_enemies = 0
	arg_3_0.number_special_aggored_enemies = 0
	arg_3_0.start_prio_index = 1

	local var_3_10 = arg_3_1.network_event_delegate

	arg_3_0._network_event_delegate = var_3_10

	var_3_10:register(arg_3_0, unpack(var_0_12))

	if not arg_3_0.is_server then
		arg_3_0:_initialize_client_traverse_logic(var_3_3)
	end

	arg_3_0._hot_join_sync_units = {}

	for iter_3_2, iter_3_3 in pairs(NAV_TAG_VOLUME_LAYER_COST_AI) do
		local var_3_11 = DEFAULT_NAV_TAG_VOLUME_LAYER_COST_AI[iter_3_2] or 1

		NAV_TAG_VOLUME_LAYER_COST_AI[iter_3_2] = var_3_11
	end

	for iter_3_4, iter_3_5 in pairs(NAV_TAG_VOLUME_LAYER_COST_BOTS) do
		local var_3_12 = DEFAULT_NAV_TAG_VOLUME_LAYER_COST_BOTS[iter_3_4] or 1

		NAV_TAG_VOLUME_LAYER_COST_BOTS[iter_3_4] = var_3_12
	end
end

AISystem.get_nav_cost_maps_data = function (arg_4_0)
	return arg_4_0._nav_cost_maps_data, var_0_10
end

AISystem.create_nav_cost_map = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._nav_cost_map_id_data
	local var_5_1 = var_5_0.current_id
	local var_5_2 = var_5_0.ids
	local var_5_3 = var_5_0.size
	local var_5_4 = var_5_0.max_size
	local var_5_5 = NAV_COST_MAP_LAYER_ID_MAPPING[arg_5_1]

	fassert(var_5_3 < var_5_4, "Error! Too many Nav Cost Maps!")

	while var_5_2[var_5_1] do
		var_5_1 = var_5_1 % var_5_4 + 1
	end

	local var_5_6 = arg_5_0._nav_world

	arg_5_0._nav_cost_maps_data[var_5_1] = {
		recompute = false,
		cost_map = GwNavCostMap.create(var_5_6, var_5_5),
		volumes = Script.new_map(arg_5_2)
	}
	var_5_0.size = var_5_3 + 1
	var_5_0.current_id = var_5_1
	var_5_2[var_5_1] = true

	return var_5_1
end

AISystem.destroy_nav_cost_map = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._nav_cost_map_id_data
	local var_6_1 = var_6_0.size
	local var_6_2 = var_6_0.ids
	local var_6_3 = arg_6_0._nav_cost_maps_data[arg_6_1]

	fassert(var_6_3, "Error! Trying to Destroy Unknown Nav Cost Map!")

	local var_6_4 = var_6_3.volumes

	fassert(table.is_empty(var_6_4), "Error! You must remove associated Nav Cost Map Volumes before destroying the Nav Cost Map!")
	GwNavCostMap.destroy(var_6_3.cost_map)

	arg_6_0._nav_cost_maps_data[arg_6_1] = nil
	var_6_2[arg_6_1] = false
	var_6_0.size = var_6_1 - 1
	arg_6_0._should_recompute_nav_cost_maps = true
end

AISystem.add_nav_cost_map_box_volume = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0._nav_cost_map_volume_id_data
	local var_7_1 = var_7_0.current_id
	local var_7_2 = var_7_0.ids
	local var_7_3 = var_7_0.size
	local var_7_4 = var_7_0.max_size

	fassert(var_7_3 < var_7_4, "Error! Too many Nav Cost Map Volumes!")

	while var_7_2[var_7_1] do
		var_7_1 = var_7_1 % var_7_4 + 1
	end

	local var_7_5 = arg_7_0._nav_cost_maps_data[arg_7_3]

	fassert(var_7_5 ~= nil, "Error! Trying to Add Volume to Unknown Nav Cost Map!")

	local var_7_6 = var_7_5.cost_map
	local var_7_7 = GwNavCostMap.create_box_volume(arg_7_1, arg_7_2)

	GwNavCostMap.add_volume(var_7_6, var_7_7)

	var_7_5.recompute = true
	var_7_5.volumes[var_7_1] = var_7_7
	var_7_0.size = var_7_3 + 1
	var_7_0.current_id = var_7_1
	var_7_2[var_7_1] = true
	arg_7_0._should_recompute_nav_cost_maps = true

	return var_7_1
end

AISystem.add_nav_cost_map_sphere_volume = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._nav_cost_map_volume_id_data
	local var_8_1 = var_8_0.current_id
	local var_8_2 = var_8_0.ids
	local var_8_3 = var_8_0.size
	local var_8_4 = var_8_0.max_size

	fassert(var_8_3 < var_8_4, "Error! Too many Nav Cost Map Volumes!")

	while var_8_2[var_8_1] do
		var_8_1 = var_8_1 % var_8_4 + 1
	end

	local var_8_5 = arg_8_0._nav_cost_maps_data[arg_8_3]

	fassert(var_8_5 ~= nil, "Error! Trying to Add Volume to Unknown Nav Cost Map!")

	local var_8_6 = var_8_5.cost_map
	local var_8_7 = GwNavCostMap.create_sphere_volume(arg_8_1, arg_8_2)

	GwNavCostMap.add_volume(var_8_6, var_8_7)

	var_8_5.recompute = true
	var_8_5.volumes[var_8_1] = var_8_7
	var_8_0.size = var_8_3 + 1
	var_8_0.current_id = var_8_1
	var_8_2[var_8_1] = true
	arg_8_0._should_recompute_nav_cost_maps = true

	return var_8_1
end

AISystem.set_nav_cost_map_volume_transform = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0._nav_cost_map_volume_id_data.ids

	fassert(var_9_0[arg_9_1], "Error! Trying to Set Transform for Unknown Nav Cost Map Volume!")

	local var_9_1 = arg_9_0._nav_cost_maps_data[arg_9_2]

	fassert(var_9_1 ~= nil, "Error! Trying to Set Transform for Volume from Unknown Nav Cost Map!")

	local var_9_2 = var_9_1.volumes[arg_9_1]

	GwNavCostMap.set_volume_transform(var_9_2, arg_9_3)

	local var_9_3 = var_9_1.cost_map

	var_9_1.recompute = true
	arg_9_0._should_recompute_nav_cost_maps = true
end

AISystem.set_nav_cost_map_volume_scale = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0._nav_cost_map_volume_id_data.ids

	fassert(var_10_0[arg_10_1], "Error! Trying to Set Scale for Unknown Nav Cost Map Volume!")

	local var_10_1 = arg_10_0._nav_cost_maps_data[arg_10_2]

	fassert(var_10_1 ~= nil, "Error! Trying to Set Scale for Volume from Unknown Nav Cost Map!")

	local var_10_2 = var_10_1.volumes[arg_10_1]

	GwNavCostMap.set_volume_scale(var_10_2, arg_10_3)

	local var_10_3 = var_10_1.cost_map

	var_10_1.recompute = true
	arg_10_0._should_recompute_nav_cost_maps = true
end

AISystem.remove_nav_cost_map_volume = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._nav_cost_map_volume_id_data
	local var_11_1 = var_11_0.size
	local var_11_2 = var_11_0.ids

	fassert(var_11_2[arg_11_1], "Error! Trying to Remove Unknown Nav Cost Map Volume!")

	local var_11_3 = arg_11_0._nav_cost_maps_data[arg_11_2]

	fassert(var_11_3 ~= nil, "Error! Trying to Remove Volume from Unknown Nav Cost Map!")

	local var_11_4 = var_11_3.volumes[arg_11_1]
	local var_11_5 = var_11_3.cost_map

	GwNavCostMap.remove_volume(var_11_5, var_11_4)
	GwNavCostMap.destroy_volume(var_11_4)

	var_11_3.recompute = true
	var_11_3.volumes[arg_11_1] = nil
	var_11_2[arg_11_1] = false
	var_11_0.size = var_11_1 - 1
	arg_11_0._should_recompute_nav_cost_maps = true
end

AISystem._recompute_nav_cost_maps = function (arg_12_0)
	local var_12_0 = arg_12_0._nav_cost_maps_data

	for iter_12_0 = 1, var_0_10 do
		local var_12_1 = var_12_0[iter_12_0]

		if var_12_1 and var_12_1.recompute then
			local var_12_2 = var_12_1.cost_map

			GwNavCostMap.recompute(var_12_2)

			var_12_1.recompute = false
		end
	end
end

AISystem._initialize_client_traverse_logic = function (arg_13_0, arg_13_1)
	local var_13_0 = {
		bot_poison_wind = 1,
		bot_ratling_gun_fire = 1,
		fire_grenade = 1
	}

	table.merge(var_13_0, NAV_TAG_VOLUME_LAYER_COST_AI)

	local var_13_1 = GwNavTagLayerCostTable.create()

	arg_13_0._navtag_layer_cost_table = var_13_1

	AiUtils.initialize_cost_table(var_13_1, var_13_0)

	local var_13_2 = GwNavCostMap.create_tag_cost_table()

	arg_13_0._nav_cost_map_cost_table = var_13_2

	AiUtils.initialize_nav_cost_map_cost_table(var_13_2, nil, 1)

	arg_13_0._traverse_logic = GwNavTraverseLogic.create(arg_13_1, var_13_2)

	GwNavTraverseLogic.set_navtag_layer_cost_table(arg_13_0._traverse_logic, var_13_1)
end

AISystem.destroy = function (arg_14_0)
	AISystem.super.destroy(arg_14_0)

	if arg_14_0.ai_debugger then
		arg_14_0.ai_debugger:destroy()
	end

	arg_14_0.broadphase = nil

	Managers.state.bot_nav_transition:clear_transitions()

	local var_14_0 = arg_14_0._nav_cost_maps_data

	for iter_14_0 = 1, var_0_10 do
		local var_14_1 = var_14_0[iter_14_0]

		if var_14_1 then
			local var_14_2 = var_14_1.cost_map

			GwNavCostMap.destroy(var_14_2)
		end
	end

	arg_14_0._nav_cost_maps_data = nil

	if arg_14_0._nav_data then
		local var_14_3 = arg_14_0._nav_data

		for iter_14_1 = 1, #var_14_3 do
			local var_14_4 = var_14_3[iter_14_1]

			GwNavWorld.remove_navdata(nil, var_14_4)
		end
	end

	GwNavWorld.destroy(arg_14_0._nav_world)
	arg_14_0._network_event_delegate:unregister(arg_14_0)

	arg_14_0._network_event_delegate = nil

	if not arg_14_0.is_server and arg_14_0._traverse_logic ~= nil then
		GwNavTagLayerCostTable.destroy(arg_14_0._navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(arg_14_0._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(arg_14_0._traverse_logic)
	end
end

AISystem.on_add_extension = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = AISystem.super.on_add_extension(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)

	arg_15_0.unit_extension_data[arg_15_2] = var_15_0

	if not var_15_0.is_husk then
		if not var_15_0.is_bot then
			arg_15_0.ai_blackboard_updates[#arg_15_0.ai_blackboard_updates + 1] = arg_15_2
		end

		local var_15_1 = var_15_0:blackboard()

		arg_15_0.blackboards[arg_15_2] = var_15_1

		arg_15_0:set_default_blackboard_values(arg_15_2, var_15_1)
	end

	if arg_15_3 == "AISimpleExtension" then
		arg_15_0.ai_units_alive[arg_15_2] = var_15_0

		local var_15_2 = var_15_0._breed

		if var_15_2.perception_continuous then
			arg_15_0.ai_units_perception_continuous[arg_15_2] = var_15_0
		else
			arg_15_0.ai_units_perception[arg_15_2] = var_15_0
		end

		if var_15_2.immediate_threat then
			AiUtils.activate_unit(var_15_0._blackboard)
		end

		local var_15_3 = var_15_2.hot_join_sync

		if var_15_3 then
			arg_15_0._hot_join_sync_units[arg_15_2] = var_15_3
		end

		arg_15_0.num_perception_units = arg_15_0.num_perception_units + 1
	end

	return var_15_0
end

AISystem.use_perception_continuous = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.ai_units_alive[arg_16_1]

	if arg_16_2 then
		arg_16_0.ai_units_perception_continuous[arg_16_1] = var_16_0
		arg_16_0.ai_units_perception[arg_16_1] = nil
	else
		arg_16_0.ai_units_perception_continuous[arg_16_1] = nil
		arg_16_0.ai_units_perception[arg_16_1] = var_16_0
	end
end

AISystem.set_default_blackboard_values = function (arg_17_0, arg_17_1, arg_17_2)
	arg_17_2.destination_dist = 0
	arg_17_2.current_health_percent = 1
	arg_17_2.have_slot = 0
	arg_17_2.wait_slot_distance = math.huge
	arg_17_2.target_dist = math.huge
	arg_17_2.target_dist_z_abs = math.huge
	arg_17_2.target_dist_xy_sq = math.huge
	arg_17_2.ally_distance = math.huge
	arg_17_2.move_speed = 0
	arg_17_2.total_slots_count = 0
	arg_17_2.total_occupied_slots = 0
	arg_17_2.target_num_occupied_slots = 0
	arg_17_2.target_num_disabled_slots = 0
	arg_17_2.target_speed_away = 0
	arg_17_2.target_speed_away_small_sample = 0
	arg_17_2.spawn = true
	arg_17_2.about_to_be_destroyed = nil
	UNIT_UNIQUE_IDS = UNIT_UNIQUE_IDS + 1
	arg_17_2.unique_id = UNIT_UNIQUE_IDS
end

AISystem.on_remove_extension = function (arg_18_0, arg_18_1, arg_18_2)
	(arg_18_0.unit_extension_data[arg_18_1] or arg_18_0.frozen_unit_extension_data[arg_18_1]):unit_removed_from_game()
	arg_18_0:_cleanup_extension(arg_18_1, arg_18_2)

	arg_18_0.blackboards[arg_18_1] = nil

	AISystem.super.on_remove_extension(arg_18_0, arg_18_1, arg_18_2)
end

AISystem.on_freeze_extension = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.unit_extension_data[arg_19_1]

	fassert(var_19_0, "Unit was already frozen.")

	arg_19_0.frozen_unit_extension_data[arg_19_1] = var_19_0

	arg_19_0:_cleanup_extension(arg_19_1, arg_19_2)
end

AISystem._cleanup_extension = function (arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0.unit_extension_data[arg_20_1] == nil then
		return
	end

	local var_20_0 = arg_20_0.unit_extension_data[arg_20_1]

	if var_20_0.broadphase_id then
		Broadphase.remove(arg_20_0.broadphase, var_20_0.broadphase_id)

		var_20_0.broadphase_id = nil
	end

	arg_20_0._hot_join_sync_units[arg_20_1] = nil
	arg_20_0.unit_extension_data[arg_20_1] = nil

	if arg_20_2 == "AISimpleExtension" then
		if USE_ENGINE_SLOID_SYSTEM then
			notify_attackers(arg_20_1, Managers.state.conflict.dogpiled_attackers_on_unit)
		else
			Managers.state.conflict.gathering:notify_attackers(arg_20_1)
		end

		local var_20_1 = arg_20_0.blackboards[arg_20_1]

		if var_20_1 then
			var_20_1.activation_lock = true

			AiUtils.deactivate_unit(var_20_1)
		end

		local var_20_2 = arg_20_0.ai_blackboard_updates
		local var_20_3 = #var_20_2
		local var_20_4 = arg_20_0.ai_blackboard_prioritized_updates
		local var_20_5 = #var_20_4

		for iter_20_0 = 1, var_20_3 do
			if var_20_2[iter_20_0] == arg_20_1 then
				var_20_2[iter_20_0] = var_20_2[var_20_3]
				var_20_2[var_20_3] = nil

				break
			end
		end

		for iter_20_1 = 1, var_20_5 do
			if var_20_4[iter_20_1] == arg_20_1 then
				var_20_4[iter_20_1] = var_20_4[var_20_5]
				var_20_4[var_20_5] = nil

				break
			end
		end

		arg_20_0.ai_units_alive[arg_20_1] = nil
		arg_20_0.ai_units_perception[arg_20_1] = nil
		arg_20_0.ai_units_perception_continuous[arg_20_1] = nil
		arg_20_0.ai_units_perception_prioritized[arg_20_1] = nil
		arg_20_0.num_perception_units = arg_20_0.num_perception_units - 1
	end
end

AISystem.freeze = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0.frozen_unit_extension_data
	local var_21_1 = var_21_0[arg_21_1]

	if var_21_1 then
		var_21_1:unit_removed_from_game()

		return
	end

	local var_21_2 = arg_21_0:get_attributes(arg_21_1)

	for iter_21_0, iter_21_1 in pairs(var_21_2) do
		for iter_21_2 in pairs(iter_21_1) do
			arg_21_0:set_attribute(arg_21_1, iter_21_2, iter_21_0, nil, true)
		end
	end

	local var_21_3 = arg_21_0.unit_extension_data[arg_21_1]

	var_21_0[arg_21_1] = var_21_3

	if var_21_3.freeze then
		var_21_3:freeze(arg_21_1)
	end

	arg_21_0:_cleanup_extension(arg_21_1, arg_21_2)
	var_21_3:unit_removed_from_game()
end

AISystem.unfreeze = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0.frozen_unit_extension_data[arg_22_1]

	fassert(var_22_0, "Unit to unfreeze didn't have frozen extension")

	arg_22_0.frozen_unit_extension_data[arg_22_1] = nil
	arg_22_0.unit_extension_data[arg_22_1] = var_22_0

	if var_22_0.unfreeze then
		var_22_0:unfreeze(arg_22_1, arg_22_3)
	end

	if arg_22_2 == "AISimpleExtension" then
		fassert(not var_22_0.is_husk, "bot freeze?")

		arg_22_0.ai_units_alive[arg_22_1] = var_22_0
		arg_22_0.num_perception_units = arg_22_0.num_perception_units + 1
		arg_22_0.ai_blackboard_updates[#arg_22_0.ai_blackboard_updates + 1] = arg_22_1

		local var_22_1 = var_22_0._breed

		if var_22_1.perception_continuous then
			arg_22_0.ai_units_perception_continuous[arg_22_1] = var_22_0
		else
			arg_22_0.ai_units_perception[arg_22_1] = var_22_0
		end

		var_22_0._blackboard.activation_lock = nil

		if var_22_1.immediate_threat then
			AiUtils.activate_unit(var_22_0._blackboard)
		end

		local var_22_2 = var_22_1.hot_join_sync

		if var_22_2 then
			arg_22_0._hot_join_sync_units[arg_22_1] = var_22_2
		end

		arg_22_0:set_default_blackboard_values(arg_22_1, var_22_0._blackboard)

		arg_22_0.num_perception_units = arg_22_0.num_perception_units + 1
	end

	if var_22_0._health_extension then
		local var_22_3 = Managers.state.side.side_by_unit[arg_22_1]

		var_22_0.broadphase_id = Broadphase.add(arg_22_0.broadphase, arg_22_1, var_0_1[arg_22_1], 1, var_22_3.broadphase_category)
	end
end

AISystem.register_prioritized_perception_unit_update = function (arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.ai_units_perception_prioritized[arg_23_1] = arg_23_2
end

AISystem.update = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_1.dt

	if not var_0_8 then
		arg_24_0:create_all_trees()
	end

	arg_24_0:update_extension("PlayerBotBase", var_24_0, arg_24_1, arg_24_2)
	arg_24_0:update_extension("AiHuskBaseExtension", var_24_0, arg_24_1, arg_24_2)

	if arg_24_0._should_recompute_nav_cost_maps and arg_24_2 > arg_24_0._previous_nav_cost_map_recomputation_t + var_0_11 then
		arg_24_0:_recompute_nav_cost_maps()

		arg_24_0._should_recompute_nav_cost_maps = false
		arg_24_0._previous_nav_cost_map_recomputation_t = arg_24_2
	end

	arg_24_0:update_alive()
	arg_24_0:update_perception(arg_24_2, var_24_0)
	arg_24_0:update_brains(arg_24_2, var_24_0)
	arg_24_0:update_game_objects()
	arg_24_0:update_broadphase()

	if var_0_0.debug_enabled then
		arg_24_0:update_debug_unit(arg_24_2)
		arg_24_0:update_debug_draw(arg_24_2)
	end

	for iter_24_0, iter_24_1 in pairs(arg_24_0._units_to_destroy) do
		local var_24_1 = arg_24_0.ai_units_alive[iter_24_1]

		Managers.state.conflict:destroy_unit(iter_24_1, var_24_1._blackboard, "intentionally_destroyed")

		arg_24_0._units_to_destroy[iter_24_0] = nil
	end
end

AISystem.physics_async_update = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_1.dt

	arg_25_0:update_ai_blackboards_prioritized(arg_25_2, var_25_0)
	arg_25_0:update_ai_blackboards(arg_25_2, var_25_0)
end

AISystem.update_alive = function (arg_26_0)
	for iter_26_0, iter_26_1 in pairs(arg_26_0.ai_units_alive) do
		if not (iter_26_1._health_extension == nil or HEALTH_ALIVE[iter_26_0]) then
			arg_26_0.ai_units_alive[iter_26_0] = nil
			arg_26_0.ai_units_perception[iter_26_0] = nil
			arg_26_0.ai_units_perception_continuous[iter_26_0] = nil
			arg_26_0.ai_units_perception_prioritized[iter_26_0] = nil
		end
	end
end

AISystem._update_taunt = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_2.taunt_end_time
	local var_27_1 = arg_27_2.taunt_unit

	if var_27_0 and (var_27_0 < arg_27_1 or not Unit.alive(var_27_1)) then
		arg_27_2.taunt_unit = nil
		arg_27_2.taunt_end_time = nil
	elseif var_27_0 then
		arg_27_2.target_unit = arg_27_2.taunt_unit
	end
end

AISystem.update_perception = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = PerceptionUtils
	local var_28_1 = arg_28_0.ai_units_perception

	for iter_28_0, iter_28_1 in pairs(arg_28_0.ai_units_perception_continuous) do
		local var_28_2 = iter_28_1._blackboard
		local var_28_3 = iter_28_1._breed

		var_28_1[iter_28_0] = var_28_0[var_28_3.perception_continuous](iter_28_0, var_28_2, var_28_3, arg_28_1, arg_28_2) and iter_28_1 or nil

		arg_28_0:_update_taunt(arg_28_1, var_28_2)
	end

	local var_28_4 = arg_28_0.ai_units_perception_prioritized

	for iter_28_2, iter_28_3 in pairs(var_28_4) do
		local var_28_5 = iter_28_3._blackboard
		local var_28_6 = iter_28_3._breed
		local var_28_7 = iter_28_3._target_selection_func_name
		local var_28_8 = var_28_0[iter_28_3._perception_func_name]
		local var_28_9 = var_28_0[var_28_7]

		var_28_8(iter_28_2, var_28_5, var_28_6, var_28_9, arg_28_1, arg_28_2)
		arg_28_0:_update_taunt(arg_28_1, var_28_5)

		var_28_4[iter_28_2] = nil
	end

	local var_28_10 = arg_28_0.current_perception_unit

	var_28_10 = arg_28_0.ai_units_perception[var_28_10] ~= nil and var_28_10 or nil

	local var_28_11 = 1
	local var_28_12 = arg_28_0.num_perception_units
	local var_28_13 = math.ceil(var_28_12 * arg_28_2 / var_28_11)

	for iter_28_4 = 1, var_28_13 do
		var_28_10 = next(var_28_1, var_28_10)

		if var_28_10 == nil then
			break
		end

		local var_28_14 = var_28_1[var_28_10]
		local var_28_15 = var_28_14._blackboard
		local var_28_16 = var_28_14._breed
		local var_28_17 = var_28_15.override_target_selection_name or var_28_14._target_selection_func_name
		local var_28_18 = var_28_0[var_28_14._perception_func_name]
		local var_28_19 = var_28_0[var_28_17]

		var_28_18(var_28_10, var_28_15, var_28_16, var_28_19, arg_28_1, arg_28_2)
		arg_28_0:_update_taunt(arg_28_1, var_28_15)
	end

	arg_28_0.current_perception_unit = var_28_10
end

AISystem.update_brains = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = 0
	local var_29_1 = 0

	for iter_29_0, iter_29_1 in pairs(arg_29_0.ai_units_alive) do
		local var_29_2 = iter_29_1._brain._bt
		local var_29_3 = iter_29_1._blackboard

		if var_29_3.activated ~= nil then
			if var_29_3.activated then
				AiUtils.enter_combat(iter_29_0, var_29_3)
			else
				AiUtils.enter_passive(iter_29_0, var_29_3)
			end

			var_29_3.activated = nil
		end

		local var_29_4 = var_29_2:root():evaluate(iter_29_0, var_29_3, arg_29_1, arg_29_2)
		local var_29_5 = var_29_3.breed

		if var_29_5.special then
			if var_29_3.target_unit then
				var_29_1 = var_29_1 + 1
			end
		elseif var_29_3.target_unit and var_29_3.confirmed_player_sighting then
			var_29_0 = var_29_0 + 1
		end

		if var_29_5.run_on_game_update then
			var_29_5.run_on_game_update(iter_29_0, var_29_3, arg_29_1, arg_29_2)
		end
	end

	arg_29_0.number_ordinary_aggroed_enemies = var_29_0
	arg_29_0.number_special_aggored_enemies = var_29_1
end

AISystem.update_game_objects = function (arg_30_0)
	local var_30_0 = Managers.state.network:game()
	local var_30_1 = NetworkLookup.bt_action_names
	local var_30_2 = GameSession.set_game_object_field
	local var_30_3 = Managers.state.unit_storage

	for iter_30_0, iter_30_1 in pairs(arg_30_0.ai_units_alive) do
		local var_30_4 = var_30_3:go_id(iter_30_0)
		local var_30_5 = var_30_1[iter_30_1:current_action_name()]

		var_30_2(var_30_0, var_30_4, "bt_action_name", var_30_5)

		local var_30_6 = BLACKBOARDS[iter_30_0].target_unit
		local var_30_7 = var_30_3:go_id(var_30_6) or NetworkConstants.invalid_game_object_id

		var_30_2(var_30_0, var_30_4, "target_unit_id", var_30_7)
	end
end

AISystem.update_broadphase = function (arg_31_0)
	local var_31_0 = var_0_1
	local var_31_1 = arg_31_0.broadphase

	for iter_31_0, iter_31_1 in pairs(arg_31_0.ai_units_alive) do
		if iter_31_1.broadphase_id then
			local var_31_2 = var_31_0[iter_31_0]

			Broadphase.move(var_31_1, iter_31_1.broadphase_id, var_31_2)
		end
	end
end

AISystem.update_debug_unit = function (arg_32_0, arg_32_1)
	local var_32_0 = var_0_0.debug_unit

	if not ALIVE[var_32_0] then
		return
	end

	local var_32_1 = arg_32_0.ai_units_alive[var_32_0]

	if var_32_1 == nil then
		return
	end

	local var_32_2 = var_32_1._blackboard
	local var_32_3 = var_32_1._brain._bt:root()

	while var_32_3 and var_32_3:current_running_child(var_32_2) do
		var_32_3 = var_32_3:current_running_child(var_32_2)
	end

	var_32_2.btnode_name = var_32_3 and var_32_3:id() or "unknown_node"

	local var_32_4 = var_32_1._breed
	local var_32_5 = var_32_4.debug_flag

	if not var_0_0[var_32_5] then
		if var_32_5 then
			Debug.text("Enable debug setting %q for additional debugging of ai unit", var_32_5)
		end

		return
	end

	var_32_4.debug_class.update(var_32_0, var_32_2, arg_32_1)
end

AISystem.update_debug_draw = function (arg_33_0, arg_33_1)
	if var_0_0.debug_behaviour_trees then
		for iter_33_0, iter_33_1 in pairs(arg_33_0.ai_units_alive) do
			iter_33_1._brain:debug_draw_behaviours()
		end

		if not arg_33_0._debug_behaviour_trees then
			arg_33_0._debug_behaviour_trees = true
		end
	elseif arg_33_0._debug_behaviour_trees then
		for iter_33_2, iter_33_3 in pairs(arg_33_0.ai_units_alive) do
			Managers.state.debug_text:clear_unit_text(iter_33_2, "behavior_tree")
		end
	end

	for iter_33_4, iter_33_5 in pairs(arg_33_0.ai_units_alive) do
		if var_0_0.debug_ai_targets then
			local var_33_0 = iter_33_5._blackboard.target_unit

			if var_0_6(var_33_0) then
				local var_33_1 = Unit.local_position(iter_33_4, 0) + Vector3.up() * 2

				QuickDrawer:line(var_33_1, Unit.world_position(var_33_0, 0) + Vector3(0, 0, 1.5), Color(125, 255, 0, 0))
				QuickDrawer:box(Unit.world_pose(var_33_0, 0), Vector3(0.5, 0.5, 1.5), Color(125, 255, 0, 0))
			end
		end

		if var_0_0.debug_ai_heights then
			local var_33_2 = var_0_1[iter_33_4]
			local var_33_3 = AiUtils.breed_height(iter_33_4)

			if var_33_3 then
				local var_33_4 = var_0_1[iter_33_4] + Vector3(0, 0, var_33_3)

				QuickDrawer:sphere(var_33_2, 0.5, Colors.get("yellow"))
				QuickDrawer:line(var_33_2, var_33_4, Colors.get("yellow"))
				QuickDrawer:sphere(var_33_4, 0.5, Colors.get("yellow"))
			else
				QuickDrawer:sphere(var_33_2 + Vector3(0, 0, 1), 1.5, Colors.get("red"))
			end
		end

		if var_0_0.debug_stagger then
			local var_33_5 = iter_33_5._blackboard
			local var_33_6 = var_33_5.stagger_immunity

			if var_33_6 then
				local var_33_7 = Managers.state.debug:color(iter_33_4)
				local var_33_8, var_33_9, var_33_10, var_33_11 = Quaternion.to_elements(var_33_7)
				local var_33_12 = Vector3(var_33_9, var_33_10, var_33_11)
				local var_33_13 = "player_1"
				local var_33_14 = Unit.node(iter_33_4, "c_head")

				Managers.state.debug_text:clear_unit_text(iter_33_4, "stagger_immunity")

				local var_33_15 = var_33_5.current_health_percent
				local var_33_16 = "health:" .. var_33_15
				local var_33_17 = var_33_6.health_threshold
				local var_33_18 = 1

				Managers.state.debug_text:output_unit_text(var_33_16, 0.2, iter_33_4, var_33_14, Vector3.up() * 0.2 * var_33_18, 0.1, "stagger_immunity", var_33_12, var_33_13)

				local var_33_19 = var_33_18 + 1

				if var_33_17 < var_33_15 then
					Managers.state.debug_text:output_unit_text("damage left:" .. var_33_15 - var_33_17, 0.2, iter_33_4, var_33_14, Vector3.up() * 0.2 * var_33_19, 0.1, "stagger_immunity", var_33_12, var_33_13)

					var_33_19 = var_33_19 + 1

					Managers.state.debug_text:output_unit_text("STAGGER_IMMUNE:HIGH_HEALTH", 0.2, iter_33_4, var_33_14, Vector3.up() * 0.2 * var_33_19, 0.1, "stagger_immunity", var_33_12, var_33_13)
				else
					local var_33_20 = var_33_5.action
					local var_33_21 = var_33_20 and var_33_20.ignore_staggers

					if var_33_21 then
						local var_33_22 = var_33_20.name .. ": "

						for iter_33_6 = 1, 7 do
							local var_33_23 = type(var_33_21[iter_33_6]) == "table" and tostring(var_33_15 > var_33_21[iter_33_6].health.min and var_33_15 <= var_33_21[iter_33_6].health.max) or tostring(var_33_21[iter_33_6])

							var_33_22 = var_33_22 .. "[" .. var_33_23 .. "]"
						end

						Managers.state.debug_text:output_unit_text(var_33_22, 0.2, iter_33_4, var_33_14, Vector3.up() * 0.2 * var_33_19, 0.1, "stagger_immunity", var_33_12, var_33_13)

						var_33_19 = var_33_19 + 1
					end

					local var_33_24 = false

					if var_33_6.stagger_immune_at then
						var_33_24 = arg_33_1 < var_33_6.stagger_immune_at + var_33_6.time and var_33_6.debug_damage_left > 0

						if var_33_24 then
							local var_33_25 = math.round_with_precision(var_33_6.stagger_immune_at + var_33_6.time - arg_33_1, 2)

							Managers.state.debug_text:output_unit_text("time left:" .. var_33_25, 0.2, iter_33_4, var_33_14, Vector3.up() * 0.2 * var_33_19, 0.1, "stagger_immunity", var_33_12, var_33_13)

							var_33_19 = var_33_19 + 1

							Managers.state.debug_text:output_unit_text("damage left:" .. var_33_6.debug_damage_left, 0.2, iter_33_4, var_33_14, Vector3.up() * 0.2 * var_33_19, 0.1, "stagger_immunity", var_33_12, var_33_13)

							var_33_19 = var_33_19 + 1

							Managers.state.debug_text:output_unit_text("STAGGER_IMMUNE:HITS", 0.2, iter_33_4, var_33_14, Vector3.up() * 0.2 * var_33_19, 0.1, "stagger_immunity", var_33_12, var_33_13)

							var_33_19 = var_33_19 + 1
						end
					end

					if not var_33_24 then
						local var_33_26 = "hits_until_stagger_immunity:" .. var_33_6.num_attacks - (var_33_6.num_hits or 0)

						Managers.state.debug_text:output_unit_text(var_33_26, 0.2, iter_33_4, var_33_14, Vector3.up() * 0.2 * var_33_19, 0.1, "stagger_immunity", var_33_12, var_33_13)
					end
				end
			end
		end

		if var_0_0.debug_ai_attack_pattern then
			local var_33_27 = BLACKBOARDS[iter_33_4]
			local var_33_28 = Unit.has_node(iter_33_4, "j_spine") and Unit.node(iter_33_4, "j_spine")

			if var_33_28 then
				local var_33_29 = Unit.world_position(iter_33_4, var_33_28)
				local var_33_30 = var_33_27.have_slot
				local var_33_31 = Managers.state.debug_text

				var_33_31:clear_unit_text(iter_33_4, "attack_type")

				if var_33_27.stagger or var_33_27.blocked then
					QuickDrawer:sphere(var_33_29, 0.25, Colors.get("blue"))
				elseif var_33_30 > 0 then
					local var_33_32 = var_33_27.attack_cooldown_at

					if var_33_27.attack_token then
						QuickDrawer:sphere(var_33_29, 0.35, Colors.get("red"))

						local var_33_33 = var_33_27.action.attack_intensity_type and var_33_27.action.attack_intensity_type or "normal"

						var_33_31:output_unit_text(var_33_33, 0.16, iter_33_4, var_33_28, Vector3.zero(), nil, "attack_type", Vector3(255, 255, 255), "player_1")
					elseif arg_33_1 < var_33_32 then
						QuickDrawer:sphere(var_33_29, 0.35, Colors.get("orange"))
					else
						QuickDrawer:sphere(var_33_29, 0.25, Colors.get("lime"))
					end
				else
					QuickDrawer:sphere(var_33_29, 0.25, Colors.get("gray"))
				end
			end
		end
	end

	if var_0_0.debug_nav_tag_volume_layers then
		Debug.text("Nav Tag Volume Layers Status (20-39):")

		for iter_33_7 = NavTagVolumeStartLayer, 39 do
			local var_33_34 = LAYER_ID_MAPPING[iter_33_7]
			local var_33_35 = NAV_TAG_VOLUME_LAYER_COST_AI[var_33_34] > 0

			Debug.text("%s=%s", var_33_34, var_33_35)
		end
	end
end

local var_0_14 = 10

local function var_0_15(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	fassert(arg_34_1, "Tried to update a non-existing blackboard!")

	local var_34_0 = var_0_1

	for iter_34_0, iter_34_1 in pairs(arg_34_1.utility_actions) do
		iter_34_1.time_since_last = arg_34_2 - iter_34_1.last_time
		iter_34_1.time_since_last_done = arg_34_2 - iter_34_1.last_done_time
	end

	if arg_34_1.is_in_attack_cooldown then
		arg_34_1.is_in_attack_cooldown = arg_34_2 < arg_34_1.attack_cooldown_at
	end

	ScriptUnit.extension(arg_34_0, "ai_system"):update_stagger_count()

	local var_34_1 = ScriptUnit.has_extension(arg_34_0, "health_system")

	if var_34_1 then
		arg_34_1.current_health_percent = var_34_1:current_health_percent()
		arg_34_1.current_health = var_34_1:current_health()
	end

	local var_34_2 = var_34_0[arg_34_0]
	local var_34_3 = arg_34_1.navigation_extension

	if var_34_3 then
		arg_34_1.destination_dist = var_34_3:distance_to_destination(var_34_2)
	end

	local var_34_4 = Managers.state.entity:system("ai_slot_system")

	arg_34_1.have_slot = var_34_4:ai_unit_have_slot(arg_34_0) and 1 or 0
	arg_34_1.wait_slot_distance = var_34_4:ai_unit_wait_slot_distance(arg_34_0)
	arg_34_1.total_slots_count = var_34_4.num_total_enemies

	local var_34_5 = arg_34_1.target_unit
	local var_34_6 = var_0_6(var_34_5)
	local var_34_7 = arg_34_1.breed

	if var_34_7.wake_up_push and var_34_6 and arg_34_1.stagger > 0 then
		arg_34_1.wake_up_push = 0
	end

	if var_34_7.using_combo then
		if var_34_6 then
			local var_34_8 = Unit.get_data(var_34_5, "last_combo_t")

			if var_34_8 then
				arg_34_1.time_since_last_combo = arg_34_2 - var_34_8
			else
				arg_34_1.time_since_last_combo = 9999
			end
		else
			arg_34_1.time_since_last_combo = 9999
		end
	end

	if var_34_6 and var_34_7.has_running_attack then
		local var_34_9 = ScriptUnit.has_extension(var_34_5, "locomotion_system")

		if var_34_9 then
			if var_34_9.average_velocity then
				arg_34_1.target_speed_away = var_0_3(var_34_9:average_velocity(), var_0_4(var_34_0[var_34_5] - var_34_2))
			elseif var_34_9.current_velocity then
				arg_34_1.target_speed_away = var_0_3(var_34_9:current_velocity(), var_0_4(var_34_0[var_34_5] - var_34_2))
			else
				arg_34_1.target_speed_away = 0
			end

			if var_34_9.small_sample_size_average_velocity then
				arg_34_1.target_speed_away_small_sample = var_0_3(var_34_9:small_sample_size_average_velocity(), var_0_4(var_34_0[var_34_5] - var_34_2))
			else
				arg_34_1.target_speed_away_small_sample = 0
			end
		else
			arg_34_1.target_speed_away = 0
			arg_34_1.target_speed_away_small_sample = 0
		end

		local var_34_10 = ScriptUnit.has_extension(var_34_5, "ai_slot_system")

		if var_34_10 and var_34_10.has_slots_attached then
			arg_34_1.total_occupied_slots = var_34_10.num_occupied_slots

			local var_34_11 = var_34_4:disabled_slots_count(var_34_5)

			arg_34_1.target_num_disabled_slots = arg_34_1.have_slot > 0 and 0 or var_34_11
		else
			arg_34_1.total_occupied_slots = 0
			arg_34_1.target_num_disabled_slots = 0
		end
	else
		arg_34_1.target_speed_away = 0
		arg_34_1.target_speed_away_small_sample = 0
	end

	local var_34_12 = arg_34_1.active_node
	local var_34_13 = var_34_12 and var_34_12.name

	arg_34_1.is_following_target = var_34_13 and var_34_13 == "BTClanRatFollowAction"

	local var_34_14 = arg_34_1.locomotion_extension

	arg_34_1.is_falling = var_34_14 and var_34_14:is_falling()
	arg_34_1.move_speed = var_34_14 and var_34_14.move_speed

	if var_34_7.run_on_update then
		var_34_7.run_on_update(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	end

	local var_34_15 = arg_34_1.attacking_target
	local var_34_16 = var_0_6(var_34_15)
	local var_34_17

	if var_34_16 then
		local var_34_18 = Unit.get_data(var_34_15, "breed")

		if var_34_18 and var_34_18.is_player then
			var_34_17 = arg_34_1.side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_34_15]
		else
			var_34_17 = HEALTH_ALIVE[var_34_15]
		end
	else
		var_34_17 = true
	end

	arg_34_1.target_num_occupied_slots = 0

	if var_34_6 and var_34_17 then
		local var_34_19 = var_34_0[arg_34_0]
		local var_34_20 = var_34_0[var_34_5] - var_34_19
		local var_34_21 = var_34_20.z
		local var_34_22 = var_34_20.x
		local var_34_23 = var_34_20.y
		local var_34_24 = var_34_22 * var_34_22 + var_34_23 * var_34_23

		arg_34_1.target_dist_z_abs = math.abs(var_34_21)
		arg_34_1.target_dist_xy_sq = var_34_24

		local var_34_25 = var_0_5(var_34_24 + var_34_21 * var_34_21)
		local var_34_26 = var_34_25 < var_0_14

		arg_34_1.target_dist = var_34_25

		local var_34_27 = ScriptUnit.has_extension(var_34_5, "ai_slot_system")

		if var_34_27 then
			arg_34_1.target_num_occupied_slots = var_34_27.num_occupied_slots or 0
		else
			arg_34_1.target_num_occupied_slots = 0
		end

		return var_34_26
	elseif not var_34_6 or not var_34_17 then
		arg_34_1.target_unit = nil
		arg_34_1.target_dist = math.huge
		arg_34_1.target_dist_z_abs = math.huge
		arg_34_1.target_dist_xy_sq = math.huge

		if not var_34_17 then
			arg_34_1.attack_aborted = true
		end
	end
end

local var_0_16 = IS_WINDOWS and 40 or 20

AISystem.update_ai_blackboards_prioritized = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0.ai_blackboard_updates
	local var_35_1 = #var_35_0
	local var_35_2 = arg_35_0.ai_blackboard_prioritized_updates
	local var_35_3 = #var_35_2
	local var_35_4 = arg_35_0.blackboards
	local var_35_5 = arg_35_0.start_prio_index
	local var_35_6 = var_0_16

	if var_35_3 < var_35_6 then
		var_35_6 = var_35_3
		var_35_5 = 1
	end

	local var_35_7 = 1

	while var_35_7 <= var_35_6 do
		if var_35_3 < var_35_5 then
			var_35_5 = 1
		end

		local var_35_8 = var_35_2[var_35_5]
		local var_35_9 = var_35_4[var_35_8]

		if not var_0_15(var_35_8, var_35_9, arg_35_1, arg_35_2) then
			var_35_2[var_35_5] = var_35_2[var_35_3]
			var_35_2[var_35_3] = nil
			var_35_0[var_35_1 + 1] = var_35_8
			var_35_1 = var_35_1 + 1
			var_35_3 = var_35_3 - 1
		else
			var_35_5 = var_35_5 + 1
		end

		var_35_7 = var_35_7 + 1
	end

	arg_35_0.start_prio_index = var_35_5
end

local var_0_17 = 2

AISystem.update_ai_blackboards = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0.ai_blackboard_updates
	local var_36_1 = #var_36_0
	local var_36_2 = arg_36_0.ai_blackboard_prioritized_updates
	local var_36_3 = #var_36_2
	local var_36_4 = arg_36_0.blackboards
	local var_36_5 = 0
	local var_36_6 = arg_36_0.ai_update_index

	var_36_6 = var_36_1 < var_36_6 and 1 or var_36_6

	while var_36_6 <= var_36_1 do
		local var_36_7 = var_36_0[var_36_6]
		local var_36_8 = var_36_4[var_36_7]

		if var_0_15(var_36_7, var_36_8, arg_36_1, arg_36_2) then
			var_36_0[var_36_6] = var_36_0[var_36_1]
			var_36_0[var_36_1] = nil
			var_36_2[var_36_3 + 1] = var_36_7
			var_36_1 = #var_36_0
			var_36_3 = #var_36_2
		else
			var_36_6 = var_36_6 + 1
		end

		var_36_5 = var_36_5 + 1

		if var_36_5 >= var_0_17 then
			break
		end
	end

	arg_36_0.ai_update_index = var_36_6
end

AISystem.nav_world = function (arg_37_0)
	return arg_37_0._nav_world
end

AISystem.client_traverse_logic = function (arg_38_0)
	return arg_38_0._traverse_logic
end

AISystem.get_tri_on_navmesh = function (arg_39_0, arg_39_1)
	return GwNavQueries.triangle_from_position(arg_39_0._nav_world, arg_39_1, 30, 30)
end

AISystem.set_allowed_layer = function (arg_40_0, arg_40_1, arg_40_2)
	if arg_40_0.is_server then
		local var_40_0 = Managers.state.entity
		local var_40_1 = arg_40_0._nav_world
		local var_40_2 = LAYER_ID_MAPPING[arg_40_1]
		local var_40_3 = Managers.state.conflict

		NAV_TAG_VOLUME_LAYER_COST_AI[arg_40_1] = arg_40_2 and 1 or 0
		NAV_TAG_VOLUME_LAYER_COST_BOTS[arg_40_1] = arg_40_2 and 1 or 0

		local var_40_4 = var_40_0:get_entities("AINavigationExtension")

		for iter_40_0, iter_40_1 in pairs(var_40_4) do
			iter_40_1:allow_layer(arg_40_1, arg_40_2)

			if not arg_40_2 then
				local var_40_5 = iter_40_1._unit

				if ALIVE[var_40_5] then
					local var_40_6 = var_0_1[var_40_5]

					if NavTagVolumeUtils.inside_nav_tag_layer(var_40_1, var_40_6, 0.5, 0.5, arg_40_1) then
						if ScriptUnit.has_extension(var_40_5, "health_system") then
							AiUtils.kill_unit(var_40_5, nil, nil, "inside_forbidden_tag_volume", Vector3(0, 0, 0))
						else
							local var_40_7 = BLACKBOARDS[var_40_5]

							var_40_3:destroy_unit(var_40_5, var_40_7, "inside_forbidden_tag_volume")
						end
					else
						local var_40_8 = iter_40_1:destination()

						if NavTagVolumeUtils.inside_nav_tag_layer(var_40_1, var_40_8, 0.5, 0.5, arg_40_1) then
							iter_40_1:reset_destination()
						end
					end
				end
			end
		end

		Managers.state.bot_nav_transition:allow_layer(arg_40_1, arg_40_2)
		Managers.state.entity:system("ai_slot_system"):set_allowed_layer(arg_40_1, arg_40_2)
		Managers.state.entity:system("ai_group_system"):set_allowed_layer(arg_40_1, arg_40_2)
		arg_40_0.network_transmit:send_rpc_clients("rpc_set_allowed_nav_layer", var_40_2, arg_40_2)
	end
end

AISystem.alert_enemies_within_range = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if not NetworkUtils.network_safe_position(arg_41_2) then
		Application.warning("Trying to alert enemies outside of safe network position")

		return
	end

	if arg_41_0.is_server then
		PerceptionUtils.alert_enemies_within_range(arg_41_0.world, arg_41_1, true, arg_41_2, arg_41_3)
	else
		local var_41_0 = Managers.state.unit_storage:go_id(arg_41_1)

		arg_41_0.network_transmit:send_rpc_server("rpc_alert_enemies_within_range", var_41_0, arg_41_2, arg_41_3)
	end
end

AISystem.rpc_alert_enemies_within_range = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	local var_42_0 = Managers.state.unit_storage:unit(arg_42_2)

	arg_42_0:alert_enemies_within_range(var_42_0, arg_42_3, arg_42_4)
end

AISystem.rpc_set_ward_state = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = Managers.state.unit_storage:unit(arg_43_2)

	AiUtils.stormvermin_champion_set_ward_state(var_43_0, arg_43_3, false)
end

AISystem.rpc_set_hit_reaction_template = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = Managers.state.unit_storage:unit(arg_44_2)

	ScriptUnit.extension(var_44_0, "hit_reaction_system"):set_hit_effect_template_id(arg_44_3)
end

AISystem.rpc_change_tentacle_state = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	local var_45_0 = Managers.state.unit_storage:unit(arg_45_2)
	local var_45_1 = Managers.state.unit_storage:unit(arg_45_3)
	local var_45_2 = NetworkLookup.tentacle_template[arg_45_4]
	local var_45_3 = ScriptUnit.has_extension(var_45_0, "ai_supplementary_system")

	if var_45_3 then
		var_45_3:set_target(var_45_2, var_45_1, arg_45_5)
		var_45_3:set_server_time(arg_45_6)
	end
end

AISystem.rpc_sync_tentacle_path = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = Managers.state.unit_storage:unit(arg_46_2)
	local var_46_1 = ScriptUnit.has_extension(var_46_0, "ai_supplementary_system")

	if var_46_1 then
		var_46_1:set_astar_points(arg_46_3)
	end
end

AISystem.rpc_set_corruptor_beam_state = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	local var_47_0 = Managers.state.unit_storage:unit(arg_47_2)
	local var_47_1 = Managers.state.unit_storage:unit(arg_47_4)
	local var_47_2 = ScriptUnit.has_extension(var_47_0, "ai_beam_effect_system")

	if var_47_0 and var_47_2 then
		var_47_2:set_state(arg_47_3, Managers.player:is_player_unit(var_47_1) and var_47_1)
	end
end

AISystem.rpc_set_allowed_nav_layer = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = LAYER_ID_MAPPING[arg_48_2]

	NAV_TAG_VOLUME_LAYER_COST_AI[var_48_0] = arg_48_3 and 1 or 0
	NAV_TAG_VOLUME_LAYER_COST_BOTS[var_48_0] = arg_48_3 and 1 or 0

	if arg_48_3 then
		GwNavTagLayerCostTable.allow_layer(arg_48_0._navtag_layer_cost_table, arg_48_2)
	else
		GwNavTagLayerCostTable.forbid_layer(arg_48_0._navtag_layer_cost_table, arg_48_2)
	end
end

AISystem.rpc_check_trigger_backstab_sfx = function (arg_49_0, arg_49_1, arg_49_2)
	if DEDICATED_SERVER then
		return
	end

	local var_49_0 = Managers.state.network:game_object_or_level_unit(arg_49_2)
	local var_49_1 = Managers.player:local_player()
	local var_49_2 = var_49_1 and var_49_1.player_unit

	if not ALIVE[var_49_2] then
		return
	end

	local var_49_3 = ScriptUnit.has_extension(var_49_2, "first_person_system")

	if var_49_3 then
		local var_49_4 = Quaternion.forward(var_49_3:current_rotation())

		if AiUtils.unit_is_flanking_player(var_49_0, var_49_2, var_49_4) then
			local var_49_5 = ScriptUnit.extension(var_49_0, "dialogue_system")
			local var_49_6, var_49_7 = WwiseUtils.make_unit_auto_source(arg_49_0.world, var_49_0, var_49_5.voice_node)
			local var_49_8 = Unit.get_data(var_49_0, "breed").backstab_player_sound_event

			Managers.state.entity:system("audio_system"):_play_event_with_source(var_49_7, var_49_8, var_49_6)
		end
	end
end

function write_attribute(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	local var_50_0 = arg_50_0.attributes

	if not var_50_0 then
		var_50_0 = {}
		arg_50_0.attributes = var_50_0
	end

	var_50_0[arg_50_3] = var_50_0[arg_50_3] or {}
	var_50_0[arg_50_3][arg_50_2] = arg_50_4

	local var_50_1 = AttributeDefinition[arg_50_3][arg_50_2]

	if var_50_1 then
		var_50_1(arg_50_1, arg_50_4)
	end
end

AISystem.set_attribute = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	local var_51_0 = arg_51_0.unit_extension_data[arg_51_1]

	write_attribute(var_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)

	if arg_51_5 then
		return
	end

	local var_51_1 = Managers.state.network:unit_game_object_id(arg_51_1)
	local var_51_2 = NetworkLookup.attributes[arg_51_2]
	local var_51_3 = NetworkLookup.attribute_categories[arg_51_3]
	local var_51_4 = type(arg_51_4)

	if var_51_4 == "boolean" then
		arg_51_0.network_transmit:send_rpc_clients("rpc_set_attribute_bool", var_51_1, var_51_2, var_51_3, arg_51_4)
	elseif var_51_4 == "number" then
		arg_51_0.network_transmit:send_rpc_clients("rpc_set_attribute_int", var_51_1, var_51_2, var_51_3, arg_51_4)
	else
		arg_51_0.network_transmit:send_rpc_clients("rpc_remove_attribute", var_51_1, var_51_2, var_51_3)
	end
end

AISystem.get_attributes = function (arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.unit_extension_data[arg_52_1]

	return var_52_0 and var_52_0.attributes or var_0_7
end

AISystem.rpc_set_attribute_bool = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	print("rpc_set_attribute_bool", arg_53_2, arg_53_3, arg_53_4, arg_53_5)

	local var_53_0 = Managers.state.unit_storage:unit(arg_53_2)
	local var_53_1 = arg_53_0.unit_extension_data[var_53_0]
	local var_53_2 = NetworkLookup.attributes[arg_53_3]
	local var_53_3 = NetworkLookup.attribute_categories[arg_53_4]

	write_attribute(var_53_1, var_53_0, var_53_2, var_53_3, arg_53_5)
end

AISystem.rpc_set_attribute_int = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	print("rpc_set_attribute_int", arg_54_2, arg_54_3, arg_54_4, arg_54_5)

	local var_54_0 = Managers.state.unit_storage:unit(arg_54_2)
	local var_54_1 = arg_54_0.unit_extension_data[var_54_0]
	local var_54_2 = NetworkLookup.attributes[arg_54_3]
	local var_54_3 = NetworkLookup.attribute_categories[arg_54_4]

	write_attribute(var_54_1, var_54_0, var_54_2, var_54_3, arg_54_5)
end

AISystem.rpc_remove_attribute = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	print("rpc_remove_attribute", arg_55_2, arg_55_3, arg_55_4, nil)

	local var_55_0 = Managers.state.unit_storage:unit(arg_55_2)
	local var_55_1 = arg_55_0.unit_extension_data[var_55_0]
	local var_55_2 = NetworkLookup.attributes[arg_55_3]
	local var_55_3 = NetworkLookup.attribute_categories[arg_55_4]

	write_attribute(var_55_1, var_55_0, var_55_2, var_55_3, nil)
end

AISystem.hot_join_sync = function (arg_56_0, arg_56_1)
	local var_56_0 = #LAYER_ID_MAPPING

	for iter_56_0 = NavTagVolumeStartLayer, var_56_0 do
		local var_56_1 = LAYER_ID_MAPPING[iter_56_0]

		if NAV_TAG_VOLUME_LAYER_COST_AI[var_56_1] <= 0 then
			arg_56_0.network_transmit:send_rpc("rpc_set_allowed_nav_layer", arg_56_1, iter_56_0, false)
		end
	end

	for iter_56_1, iter_56_2 in pairs(arg_56_0.unit_extension_data) do
		local var_56_2 = iter_56_2.attributes

		if var_56_2 and next(var_56_2) then
			local var_56_3 = Managers.state.network
			local var_56_4 = Managers.state.network:unit_game_object_id(iter_56_1)

			for iter_56_3, iter_56_4 in pairs(var_56_2) do
				local var_56_5 = NetworkLookup.attribute_categories[iter_56_3]

				for iter_56_5, iter_56_6 in pairs(iter_56_4) do
					local var_56_6 = NetworkLookup.attributes[iter_56_5]

					if type(iter_56_6) == "boolean" then
						arg_56_0.network_transmit:send_rpc("rpc_set_attribute_bool", arg_56_1, var_56_4, var_56_6, var_56_5, iter_56_6)
					else
						arg_56_0.network_transmit:send_rpc("rpc_set_attribute_int", arg_56_1, var_56_4, var_56_6, var_56_5, iter_56_6)
					end
				end
			end
		end
	end

	for iter_56_7, iter_56_8 in pairs(arg_56_0._hot_join_sync_units) do
		iter_56_8(arg_56_1, iter_56_7)
	end
end

AISystem.create_all_trees = function (arg_57_0)
	var_0_8 = true

	for iter_57_0, iter_57_1 in pairs(BreedBehaviors) do
		local var_57_0 = BehaviorTree:new(iter_57_1, iter_57_0)

		arg_57_0._behavior_trees[iter_57_0] = var_57_0
	end

	for iter_57_2, iter_57_3 in pairs(BotBehaviors) do
		local var_57_1 = BehaviorTree:new(iter_57_3, iter_57_2)

		arg_57_0._behavior_trees[iter_57_2] = var_57_1
	end
end

AISystem.behavior_tree = function (arg_58_0, arg_58_1)
	return arg_58_0._behavior_trees[arg_58_1]
end

AISystem.register_unit_for_destruction = function (arg_59_0, arg_59_1)
	arg_59_0._units_to_destroy[arg_59_1] = arg_59_1
end
