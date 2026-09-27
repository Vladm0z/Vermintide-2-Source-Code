-- chunkname: @scripts/entity_system/systems/ai/ai_system.lua

require("scripts/utils/ai_debugger")
require("scripts/helpers/level_helper")
require("scripts/helpers/network_utils")
require("scripts/settings/terror_events/terror_event_utils")

local UNIT_UNIQUE_IDS = UNIT_UNIQUE_IDS

UNIT_UNIQUE_IDS = UNIT_UNIQUE_IDS or 0
UNIT_UNIQUE_IDS = UNIT_UNIQUE_IDS

local VISUAL_DEBUGGING_ENABLED = VISUAL_DEBUGGING_ENABLED

VISUAL_DEBUGGING_ENABLED = VISUAL_DEBUGGING_ENABLED or false
VISUAL_DEBUGGING_ENABLED = VISUAL_DEBUGGING_ENABLED

local GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD

GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD or {}
GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD
AISystem = class(AISystem, ExtensionSystemBase)

local script_data = script_data
local POSITION_LOOKUP = POSITION_LOOKUP
local distance = Vector3.distance
local dot = Vector3.dot
local normalize = Vector3.normalize
local sqrt = math.sqrt
local alive = Unit.alive
local tbl = {}
local disable_ai_perception = script_data.disable_ai_perception

disable_ai_perception = disable_ai_perception or Development.parameter("disable_ai_perception")
script_data.disable_ai_perception = disable_ai_perception

local flag = false
local num = 1024
local num_2 = 128
local num_3 = 0.5
local tbl_2 = {
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
local tbl_3 = {
	"AISimpleExtension",
	"AiHuskBaseExtension",
	"PlayerBotBase"
}

AttributeDefinition = {
	grudge_marked = {
		name_index = function (arg_1_0, arg_1_1)
			-- function 1
			if not arg_1_1 then
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
			-- function 2
			local var_2_0 = arg_2_1

			Unit.set_visibility(arg_2_0, "vg_armor", var_2_0)

			local flag

			flag = not var_2_0 and 2 and 1

			Unit.set_data(arg_2_0, "armor", flag)

			local flag_2

			flag_2 = not var_2_0 and "skaven" and "chaos"

			Unit.set_data(arg_2_0, "race", flag_2)
		end
	}
}

for k, v in pairs(BreedEnhancements) do
	if not v.no_attribute then
		AttributeDefinition.breed_enhancements[k] = false
	end
end

AISystem.init = function (self, arg_3_1, arg_3_2)
	-- function 3
	AISystem.super.init(self, arg_3_1, arg_3_2, tbl_3)

	local tbl = {}
	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		local var_3_2 = sides[i]

		tbl[#tbl + 1] = var_3_2:name()
	end

	self.broadphase = Broadphase(50, 128, tbl)
	self._behavior_trees = {}
	self.group_blackboard = {
		rats_currently_moving_to_ip = 0,
		special_targets = {},
		disabled_by_special = {},
		broadphase = self.broadphase,
		slots = {},
		slots_cleared = {}
	}

	self:create_all_trees()

	local var_3_3 = GwNavWorld.create(Matrix4x4.identity())

	self._nav_world = var_3_3
	GLOBAL_AI_NAVWORLD = var_3_3

	if PLATFORM ~= Application.WIN32 then
		GwNavWorld.set_pathfinder_budget(var_3_3, 0.0045)
	end

	if not script_data.disable_crowd_dispersion then
		GwNavWorld.enable_crowd_dispersion(var_3_3)
	end

	if not (not script_data.debug_enabled and not script_data.navigation_visual_debug_enabled and VISUAL_DEBUGGING_ENABLED) then
		VISUAL_DEBUGGING_ENABLED = true

		GwNavWorld.init_visual_debug_server(var_3_3, 4888)
	end

	if not script_data.navigation_thread_disabled then
		GwNavWorld.init_async_update(var_3_3)
	end

	local current_level_settings = LevelHelper:current_level_settings()
	local level_name = current_level_settings.level_name
	local world = arg_3_1.world

	if not LEVEL_EDITOR_TEST then
		level_name = Application.get_data("LevelEditor", "level_resource_name")
	end

	if not current_level_settings.no_nav_mesh then
		local nested_level_count = LevelResource.nested_level_count(level_name)
		local tbl_4 = {}

		tbl_4[#tbl_4 + 1] = GwNavWorld.add_navdata(var_3_3, level_name)

		for j = 0, nested_level_count - 1 do
			local nested_level_resource_name = LevelResource.nested_level_resource_name(level_name, j)

			print("nested_level_name", nested_level_resource_name)

			tbl_4[#tbl_4 + 1] = GwNavWorld.add_navdata(var_3_3, nested_level_resource_name)
		end

		self._nav_data = tbl_4

		if not script_data.debug_enabled then
			self.ai_debugger = AIDebugger:new(world, var_3_3, self.group_blackboard, self.is_server, arg_3_1.free_flight_manager)
		end
	end

	self._nav_cost_map_id_data = {
		size = 0,
		current_id = 1,
		ids = Script.new_array(num_2),
		max_size = num_2
	}
	self._nav_cost_map_volume_id_data = {
		size = 0,
		current_id = 1,
		ids = Script.new_array(num),
		max_size = num
	}
	self._nav_cost_maps_data = Script.new_array(num_2)
	self._should_recompute_nav_cost_maps = false
	self._previous_nav_cost_map_recomputation_t = 0
	self.unit_extension_data = {}
	self.frozen_unit_extension_data = {}
	self.blackboards = BLACKBOARDS
	self.ai_blackboard_updates = {}
	self.ai_blackboard_prioritized_updates = {}
	self.ai_update_index = 1
	self._units_to_destroy = {}
	self.ai_units_alive = {}
	self.ai_units_perception_continuous = {}
	self.ai_units_perception = {}
	self.ai_units_perception_prioritized = {}
	self.num_perception_units = 0
	self.world = arg_3_1.world
	self.number_ordinary_aggroed_enemies = 0
	self.number_special_aggored_enemies = 0
	self.start_prio_index = 1

	local network_event_delegate = arg_3_1.network_event_delegate

	self._network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl_2))

	if not self.is_server then
		self:_initialize_client_traverse_logic(var_3_3)
	end

	self._hot_join_sync_units = {}

	for k, v in pairs(NAV_TAG_VOLUME_LAYER_COST_AI) do
		local var_3_11 = DEFAULT_NAV_TAG_VOLUME_LAYER_COST_AI[k]

		var_3_11 = var_3_11 or 1
		NAV_TAG_VOLUME_LAYER_COST_AI[k] = var_3_11
	end

	for k_2, v_2 in pairs(NAV_TAG_VOLUME_LAYER_COST_BOTS) do
		local var_3_12 = DEFAULT_NAV_TAG_VOLUME_LAYER_COST_BOTS[k_2]

		var_3_12 = var_3_12 or 1
		NAV_TAG_VOLUME_LAYER_COST_BOTS[k_2] = var_3_12
	end
end

AISystem.get_nav_cost_maps_data = function (self)
	-- function 4
	return self._nav_cost_maps_data, num_2
end

AISystem.create_nav_cost_map = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _nav_cost_map_id_data = self._nav_cost_map_id_data
	local current_id = _nav_cost_map_id_data.current_id
	local ids = _nav_cost_map_id_data.ids
	local size = _nav_cost_map_id_data.size
	local max_size = _nav_cost_map_id_data.max_size
	local var_5_5 = NAV_COST_MAP_LAYER_ID_MAPPING[arg_5_1]

	fassert(size < max_size, "Error! Too many Nav Cost Maps!")

	while not ids[current_id] do
		current_id = current_id % max_size + 1
	end

	local _nav_world = self._nav_world

	self._nav_cost_maps_data[current_id] = {
		recompute = false,
		cost_map = GwNavCostMap.create(_nav_world, var_5_5),
		volumes = Script.new_map(arg_5_2)
	}
	_nav_cost_map_id_data.size = size + 1
	_nav_cost_map_id_data.current_id = current_id
	ids[current_id] = true

	return current_id
end

AISystem.destroy_nav_cost_map = function (self, arg_6_1)
	-- function 6
	local _nav_cost_map_id_data = self._nav_cost_map_id_data
	local size = _nav_cost_map_id_data.size
	local ids = _nav_cost_map_id_data.ids
	local var_6_3 = self._nav_cost_maps_data[arg_6_1]

	fassert(var_6_3, "Error! Trying to Destroy Unknown Nav Cost Map!")

	local volumes = var_6_3.volumes

	fassert(table.is_empty(volumes), "Error! You must remove associated Nav Cost Map Volumes before destroying the Nav Cost Map!")
	GwNavCostMap.destroy(var_6_3.cost_map)

	self._nav_cost_maps_data[arg_6_1] = nil
	ids[arg_6_1] = false
	_nav_cost_map_id_data.size = size - 1
	self._should_recompute_nav_cost_maps = true
end

AISystem.add_nav_cost_map_box_volume = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local _nav_cost_map_volume_id_data = self._nav_cost_map_volume_id_data
	local current_id = _nav_cost_map_volume_id_data.current_id
	local ids = _nav_cost_map_volume_id_data.ids
	local size = _nav_cost_map_volume_id_data.size
	local max_size = _nav_cost_map_volume_id_data.max_size

	fassert(size < max_size, "Error! Too many Nav Cost Map Volumes!")

	while not ids[current_id] do
		current_id = current_id % max_size + 1
	end

	local var_7_5 = self._nav_cost_maps_data[arg_7_3]

	fassert(var_7_5 ~= nil, "Error! Trying to Add Volume to Unknown Nav Cost Map!")

	local cost_map = var_7_5.cost_map
	local create_box_volume = GwNavCostMap.create_box_volume(arg_7_1, arg_7_2)

	GwNavCostMap.add_volume(cost_map, create_box_volume)

	var_7_5.recompute = true
	var_7_5.volumes[current_id] = create_box_volume
	_nav_cost_map_volume_id_data.size = size + 1
	_nav_cost_map_volume_id_data.current_id = current_id
	ids[current_id] = true
	self._should_recompute_nav_cost_maps = true

	return current_id
end

AISystem.add_nav_cost_map_sphere_volume = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _nav_cost_map_volume_id_data = self._nav_cost_map_volume_id_data
	local current_id = _nav_cost_map_volume_id_data.current_id
	local ids = _nav_cost_map_volume_id_data.ids
	local size = _nav_cost_map_volume_id_data.size
	local max_size = _nav_cost_map_volume_id_data.max_size

	fassert(size < max_size, "Error! Too many Nav Cost Map Volumes!")

	while not ids[current_id] do
		current_id = current_id % max_size + 1
	end

	local var_8_5 = self._nav_cost_maps_data[arg_8_3]

	fassert(var_8_5 ~= nil, "Error! Trying to Add Volume to Unknown Nav Cost Map!")

	local cost_map = var_8_5.cost_map
	local create_sphere_volume = GwNavCostMap.create_sphere_volume(arg_8_1, arg_8_2)

	GwNavCostMap.add_volume(cost_map, create_sphere_volume)

	var_8_5.recompute = true
	var_8_5.volumes[current_id] = create_sphere_volume
	_nav_cost_map_volume_id_data.size = size + 1
	_nav_cost_map_volume_id_data.current_id = current_id
	ids[current_id] = true
	self._should_recompute_nav_cost_maps = true

	return current_id
end

AISystem.set_nav_cost_map_volume_transform = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local ids = self._nav_cost_map_volume_id_data.ids

	fassert(ids[arg_9_1], "Error! Trying to Set Transform for Unknown Nav Cost Map Volume!")

	local var_9_1 = self._nav_cost_maps_data[arg_9_2]

	fassert(var_9_1 ~= nil, "Error! Trying to Set Transform for Volume from Unknown Nav Cost Map!")

	local var_9_2 = var_9_1.volumes[arg_9_1]

	GwNavCostMap.set_volume_transform(var_9_2, arg_9_3)

	local cost_map = var_9_1.cost_map

	var_9_1.recompute = true
	self._should_recompute_nav_cost_maps = true
end

AISystem.set_nav_cost_map_volume_scale = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local ids = self._nav_cost_map_volume_id_data.ids

	fassert(ids[arg_10_1], "Error! Trying to Set Scale for Unknown Nav Cost Map Volume!")

	local var_10_1 = self._nav_cost_maps_data[arg_10_2]

	fassert(var_10_1 ~= nil, "Error! Trying to Set Scale for Volume from Unknown Nav Cost Map!")

	local var_10_2 = var_10_1.volumes[arg_10_1]

	GwNavCostMap.set_volume_scale(var_10_2, arg_10_3)

	local cost_map = var_10_1.cost_map

	var_10_1.recompute = true
	self._should_recompute_nav_cost_maps = true
end

AISystem.remove_nav_cost_map_volume = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _nav_cost_map_volume_id_data = self._nav_cost_map_volume_id_data
	local size = _nav_cost_map_volume_id_data.size
	local ids = _nav_cost_map_volume_id_data.ids

	fassert(ids[arg_11_1], "Error! Trying to Remove Unknown Nav Cost Map Volume!")

	local var_11_3 = self._nav_cost_maps_data[arg_11_2]

	fassert(var_11_3 ~= nil, "Error! Trying to Remove Volume from Unknown Nav Cost Map!")

	local var_11_4 = var_11_3.volumes[arg_11_1]
	local cost_map = var_11_3.cost_map

	GwNavCostMap.remove_volume(cost_map, var_11_4)
	GwNavCostMap.destroy_volume(var_11_4)

	var_11_3.recompute = true
	var_11_3.volumes[arg_11_1] = nil
	ids[arg_11_1] = false
	_nav_cost_map_volume_id_data.size = size - 1
	self._should_recompute_nav_cost_maps = true
end

AISystem._recompute_nav_cost_maps = function (self)
	-- function 12
	local _nav_cost_maps_data = self._nav_cost_maps_data

	for i = 1, num_2 do
		local var_12_1 = _nav_cost_maps_data[i]

		if not var_12_1 and not var_12_1.recompute then
			local cost_map = var_12_1.cost_map

			GwNavCostMap.recompute(cost_map)

			var_12_1.recompute = false
		end
	end
end

AISystem._initialize_client_traverse_logic = function (self, arg_13_1)
	-- function 13
	local tbl = {
		bot_poison_wind = 1,
		bot_ratling_gun_fire = 1,
		fire_grenade = 1
	}

	table.merge(tbl, NAV_TAG_VOLUME_LAYER_COST_AI)

	local var_13_1 = GwNavTagLayerCostTable.create()

	self._navtag_layer_cost_table = var_13_1

	AiUtils.initialize_cost_table(var_13_1, tbl)

	local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

	self._nav_cost_map_cost_table = create_tag_cost_table

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table, nil, 1)

	self._traverse_logic = GwNavTraverseLogic.create(arg_13_1, create_tag_cost_table)

	GwNavTraverseLogic.set_navtag_layer_cost_table(self._traverse_logic, var_13_1)
end

AISystem.destroy = function (self)
	-- function 14
	AISystem.super.destroy(self)

	if not self.ai_debugger then
		self.ai_debugger:destroy()
	end

	self.broadphase = nil

	Managers.state.bot_nav_transition:clear_transitions()

	local _nav_cost_maps_data = self._nav_cost_maps_data

	for i = 1, num_2 do
		local var_14_1 = _nav_cost_maps_data[i]

		if not var_14_1 then
			local cost_map = var_14_1.cost_map

			GwNavCostMap.destroy(cost_map)
		end
	end

	self._nav_cost_maps_data = nil

	if not self._nav_data then
		local _nav_data = self._nav_data

		for j = 1, #_nav_data do
			local var_14_4 = _nav_data[j]

			GwNavWorld.remove_navdata(nil, var_14_4)
		end
	end

	GwNavWorld.destroy(self._nav_world)
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil

	if not (self.is_server or self._traverse_logic == nil) then
		GwNavTagLayerCostTable.destroy(self._navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(self._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(self._traverse_logic)
	end
end

AISystem.on_add_extension = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local on_add_extension = AISystem.super.on_add_extension(self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)

	self.unit_extension_data[arg_15_2] = on_add_extension

	if not on_add_extension.is_husk then
		if not on_add_extension.is_bot then
			self.ai_blackboard_updates[#self.ai_blackboard_updates + 1] = arg_15_2
		end

		local blackboard = on_add_extension:blackboard()

		self.blackboards[arg_15_2] = blackboard

		self:set_default_blackboard_values(arg_15_2, blackboard)
	end

	if arg_15_3 == "AISimpleExtension" then
		self.ai_units_alive[arg_15_2] = on_add_extension

		local _breed = on_add_extension._breed

		if not _breed.perception_continuous then
			self.ai_units_perception_continuous[arg_15_2] = on_add_extension
		else
			self.ai_units_perception[arg_15_2] = on_add_extension
		end

		if not _breed.immediate_threat then
			AiUtils.activate_unit(on_add_extension._blackboard)
		end

		local hot_join_sync = _breed.hot_join_sync

		if not hot_join_sync then
			self._hot_join_sync_units[arg_15_2] = hot_join_sync
		end

		self.num_perception_units = self.num_perception_units + 1
	end

	return on_add_extension
end

AISystem.use_perception_continuous = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = self.ai_units_alive[arg_16_1]

	if not arg_16_2 then
		self.ai_units_perception_continuous[arg_16_1] = var_16_0
		self.ai_units_perception[arg_16_1] = nil
	else
		self.ai_units_perception_continuous[arg_16_1] = nil
		self.ai_units_perception[arg_16_1] = var_16_0
	end
end

AISystem.set_default_blackboard_values = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
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

AISystem.on_remove_extension = function (self, arg_18_1, arg_18_2)
	-- function 18
	local var_18_0 = self.unit_extension_data[arg_18_1]

	var_18_0 = var_18_0 or self.frozen_unit_extension_data[arg_18_1]

	var_18_0:unit_removed_from_game()
	self:_cleanup_extension(arg_18_1, arg_18_2)

	self.blackboards[arg_18_1] = nil

	AISystem.super.on_remove_extension(self, arg_18_1, arg_18_2)
end

AISystem.on_freeze_extension = function (self, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = self.unit_extension_data[arg_19_1]

	fassert(var_19_0, "Unit was already frozen.")

	self.frozen_unit_extension_data[arg_19_1] = var_19_0

	self:_cleanup_extension(arg_19_1, arg_19_2)
end

AISystem._cleanup_extension = function (self, arg_20_1, arg_20_2)
	-- function 20
	if self.unit_extension_data[arg_20_1] == nil then
		return
	end

	local var_20_0 = self.unit_extension_data[arg_20_1]

	if not var_20_0.broadphase_id then
		Broadphase.remove(self.broadphase, var_20_0.broadphase_id)

		var_20_0.broadphase_id = nil
	end

	self._hot_join_sync_units[arg_20_1] = nil
	self.unit_extension_data[arg_20_1] = nil

	if arg_20_2 == "AISimpleExtension" then
		if not USE_ENGINE_SLOID_SYSTEM then
			notify_attackers(arg_20_1, Managers.state.conflict.dogpiled_attackers_on_unit)
		else
			Managers.state.conflict.gathering:notify_attackers(arg_20_1)
		end

		local var_20_1 = self.blackboards[arg_20_1]

		if not var_20_1 then
			var_20_1.activation_lock = true

			AiUtils.deactivate_unit(var_20_1)
		end

		local ai_blackboard_updates = self.ai_blackboard_updates
		local count = #ai_blackboard_updates
		local ai_blackboard_prioritized_updates = self.ai_blackboard_prioritized_updates
		local count_2 = #ai_blackboard_prioritized_updates

		for i = 1, count do
			if ai_blackboard_updates[i] == arg_20_1 then
				ai_blackboard_updates[i] = ai_blackboard_updates[count]
				ai_blackboard_updates[count] = nil

				break
			end
		end

		for j = 1, count_2 do
			if ai_blackboard_prioritized_updates[j] == arg_20_1 then
				ai_blackboard_prioritized_updates[j] = ai_blackboard_prioritized_updates[count_2]
				ai_blackboard_prioritized_updates[count_2] = nil

				break
			end
		end

		self.ai_units_alive[arg_20_1] = nil
		self.ai_units_perception[arg_20_1] = nil
		self.ai_units_perception_continuous[arg_20_1] = nil
		self.ai_units_perception_prioritized[arg_20_1] = nil
		self.num_perception_units = self.num_perception_units - 1
	end
end

AISystem.freeze = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local frozen_unit_extension_data = self.frozen_unit_extension_data
	local var_21_1 = frozen_unit_extension_data[arg_21_1]

	if not var_21_1 then
		var_21_1:unit_removed_from_game()

		return
	end

	local get_attributes = self:get_attributes(arg_21_1)

	for k, v in pairs(get_attributes) do
		for k_2 in pairs(v) do
			self:set_attribute(arg_21_1, k_2, k, nil, true)
		end
	end

	local var_21_3 = self.unit_extension_data[arg_21_1]

	frozen_unit_extension_data[arg_21_1] = var_21_3

	if not var_21_3.freeze then
		var_21_3:freeze(arg_21_1)
	end

	self:_cleanup_extension(arg_21_1, arg_21_2)
	var_21_3:unit_removed_from_game()
end

AISystem.unfreeze = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local var_22_0 = self.frozen_unit_extension_data[arg_22_1]

	fassert(var_22_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extension_data[arg_22_1] = nil
	self.unit_extension_data[arg_22_1] = var_22_0

	if not var_22_0.unfreeze then
		var_22_0:unfreeze(arg_22_1, arg_22_3)
	end

	if arg_22_2 == "AISimpleExtension" then
		fassert(not var_22_0.is_husk, "bot freeze?")

		self.ai_units_alive[arg_22_1] = var_22_0
		self.num_perception_units = self.num_perception_units + 1
		self.ai_blackboard_updates[#self.ai_blackboard_updates + 1] = arg_22_1

		local _breed = var_22_0._breed

		if not _breed.perception_continuous then
			self.ai_units_perception_continuous[arg_22_1] = var_22_0
		else
			self.ai_units_perception[arg_22_1] = var_22_0
		end

		var_22_0._blackboard.activation_lock = nil

		if not _breed.immediate_threat then
			AiUtils.activate_unit(var_22_0._blackboard)
		end

		local hot_join_sync = _breed.hot_join_sync

		if not hot_join_sync then
			self._hot_join_sync_units[arg_22_1] = hot_join_sync
		end

		self:set_default_blackboard_values(arg_22_1, var_22_0._blackboard)

		self.num_perception_units = self.num_perception_units + 1
	end

	if not var_22_0._health_extension then
		local var_22_3 = Managers.state.side.side_by_unit[arg_22_1]

		var_22_0.broadphase_id = Broadphase.add(self.broadphase, arg_22_1, POSITION_LOOKUP[arg_22_1], 1, var_22_3.broadphase_category)
	end
end

AISystem.register_prioritized_perception_unit_update = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	arg_23_0.ai_units_perception_prioritized[arg_23_1] = arg_23_2
end

AISystem.update = function (self, arg_24_1, arg_24_2)
	-- function 24
	local dt = arg_24_1.dt

	if not flag then
		self:create_all_trees()
	end

	self:update_extension("PlayerBotBase", dt, arg_24_1, arg_24_2)
	self:update_extension("AiHuskBaseExtension", dt, arg_24_1, arg_24_2)

	if not (not self._should_recompute_nav_cost_maps and not (arg_24_2 > self._previous_nav_cost_map_recomputation_t + num_3)) then
		self:_recompute_nav_cost_maps()

		self._should_recompute_nav_cost_maps = false
		self._previous_nav_cost_map_recomputation_t = arg_24_2
	end

	self:update_alive()
	self:update_perception(arg_24_2, dt)
	self:update_brains(arg_24_2, dt)
	self:update_game_objects()
	self:update_broadphase()

	if not script_data.debug_enabled then
		self:update_debug_unit(arg_24_2)
		self:update_debug_draw(arg_24_2)
	end

	for k, v in pairs(self._units_to_destroy) do
		local var_24_1 = self.ai_units_alive[v]

		Managers.state.conflict:destroy_unit(v, var_24_1._blackboard, "intentionally_destroyed")

		self._units_to_destroy[k] = nil
	end
end

AISystem.physics_async_update = function (self, arg_25_1, arg_25_2)
	-- function 25
	local dt = arg_25_1.dt

	self:update_ai_blackboards_prioritized(arg_25_2, dt)
	self:update_ai_blackboards(arg_25_2, dt)
end

AISystem.update_alive = function (self)
	-- function 26
	for k, v in pairs(self.ai_units_alive) do
		if not (v._health_extension == nil or HEALTH_ALIVE[k]) then
			self.ai_units_alive[k] = nil
			self.ai_units_perception[k] = nil
			self.ai_units_perception_continuous[k] = nil
			self.ai_units_perception_prioritized[k] = nil
		end
	end
end

AISystem._update_taunt = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local taunt_end_time = arg_27_2.taunt_end_time
	local taunt_unit = arg_27_2.taunt_unit

	if not (not taunt_end_time and taunt_end_time < arg_27_1 or Unit.alive(taunt_unit)) then
		arg_27_2.taunt_unit = nil
		arg_27_2.taunt_end_time = nil
	elseif not taunt_end_time then
		arg_27_2.target_unit = arg_27_2.taunt_unit
	end
end

AISystem.update_perception = function (self, arg_28_1, arg_28_2)
	-- function 28
	local PerceptionUtils = PerceptionUtils
	local ai_units_perception = self.ai_units_perception

	for k, v in pairs(self.ai_units_perception_continuous) do
		local _blackboard = v._blackboard
		local _breed = v._breed

		ai_units_perception[k] = not PerceptionUtils[_breed.perception_continuous](k, _blackboard, _breed, arg_28_1, arg_28_2) and v and nil

		self:_update_taunt(arg_28_1, _blackboard)
	end

	local ai_units_perception_prioritized = self.ai_units_perception_prioritized

	for k_2, v_2 in pairs(ai_units_perception_prioritized) do
		local _blackboard_2 = v_2._blackboard
		local _breed_2 = v_2._breed
		local _target_selection_func_name = v_2._target_selection_func_name
		local var_28_8 = PerceptionUtils[v_2._perception_func_name]
		local var_28_9 = PerceptionUtils[_target_selection_func_name]

		var_28_8(k_2, _blackboard_2, _breed_2, var_28_9, arg_28_1, arg_28_2)
		self:_update_taunt(arg_28_1, _blackboard_2)

		ai_units_perception_prioritized[k_2] = nil
	end

	local current_perception_unit = self.current_perception_unit

	current_perception_unit = self.ai_units_perception[current_perception_unit] == nil or not current_perception_unit or nil

	local num = 1
	local num_perception_units = self.num_perception_units
	local ceil = math.ceil(num_perception_units * arg_28_2 / num)

	for i4 = 1, ceil do
		current_perception_unit = next(ai_units_perception, current_perception_unit)

		if current_perception_unit == nil then
			break
		end

		local var_28_14 = ai_units_perception[current_perception_unit]
		local _blackboard_3 = var_28_14._blackboard
		local _breed_3 = var_28_14._breed
		local override_target_selection_name = _blackboard_3.override_target_selection_name

		override_target_selection_name = override_target_selection_name or var_28_14._target_selection_func_name

		local var_28_18 = PerceptionUtils[var_28_14._perception_func_name]
		local var_28_19 = PerceptionUtils[override_target_selection_name]

		var_28_18(current_perception_unit, _blackboard_3, _breed_3, var_28_19, arg_28_1, arg_28_2)
		self:_update_taunt(arg_28_1, _blackboard_3)
	end

	self.current_perception_unit = current_perception_unit
end

AISystem.update_brains = function (self, arg_29_1, arg_29_2)
	-- function 29
	local num = 0
	local num_2 = 0

	for k, v in pairs(self.ai_units_alive) do
		local _bt = v._brain._bt
		local _blackboard = v._blackboard

		if _blackboard.activated ~= nil then
			if not _blackboard.activated then
				AiUtils.enter_combat(k, _blackboard)
			else
				AiUtils.enter_passive(k, _blackboard)
			end

			_blackboard.activated = nil
		end

		local evaluate = _bt:root():evaluate(k, _blackboard, arg_29_1, arg_29_2)
		local breed = _blackboard.breed

		if not breed.special then
			if not _blackboard.target_unit then
				num_2 = num_2 + 1
			end
		elseif not _blackboard.target_unit and not _blackboard.confirmed_player_sighting then
			num = num + 1
		end

		if not breed.run_on_game_update then
			breed.run_on_game_update(k, _blackboard, arg_29_1, arg_29_2)
		end
	end

	self.number_ordinary_aggroed_enemies = num
	self.number_special_aggored_enemies = num_2
end

AISystem.update_game_objects = function (self)
	-- function 30
	local game = Managers.state.network:game()
	local bt_action_names = NetworkLookup.bt_action_names
	local set_game_object_field = GameSession.set_game_object_field
	local unit_storage = Managers.state.unit_storage

	for k, v in pairs(self.ai_units_alive) do
		local go_id = unit_storage:go_id(k)
		local var_30_5 = bt_action_names[v:current_action_name()]

		set_game_object_field(game, go_id, "bt_action_name", var_30_5)

		local target_unit = BLACKBOARDS[k].target_unit
		local go_id_2 = unit_storage:go_id(target_unit)

		go_id_2 = go_id_2 or NetworkConstants.invalid_game_object_id

		set_game_object_field(game, go_id, "target_unit_id", go_id_2)
	end
end

AISystem.update_broadphase = function (self)
	-- function 31
	local var_31_0 = POSITION_LOOKUP
	local broadphase = self.broadphase

	for k, v in pairs(self.ai_units_alive) do
		if not v.broadphase_id then
			local var_31_2 = var_31_0[k]

			Broadphase.move(broadphase, v.broadphase_id, var_31_2)
		end
	end
end

AISystem.update_debug_unit = function (self, arg_32_1)
	-- function 32
	local debug_unit = script_data.debug_unit

	if not ALIVE[debug_unit] then
		return
	end

	local var_32_1 = self.ai_units_alive[debug_unit]

	if var_32_1 == nil then
		return
	end

	local _blackboard = var_32_1._blackboard
	local root = var_32_1._brain._bt:root()

	while not root and not root:current_running_child(_blackboard) do
		root = root:current_running_child(_blackboard)
	end

	local id

	if not root then
		id = root:id()

		if not id then
			-- Nothing
		end
	end

	id = "unknown_node"

	::label_32_0::

	_blackboard.btnode_name = id

	local _breed = var_32_1._breed
	local debug_flag = _breed.debug_flag

	if not script_data[debug_flag] then
		if not debug_flag then
			Debug.text("Enable debug setting %q for additional debugging of ai unit", debug_flag)
		end

		return
	end

	_breed.debug_class.update(debug_unit, _blackboard, arg_32_1)
end

AISystem.update_debug_draw = function (self, arg_33_1)
	-- function 33
	if not script_data.debug_behaviour_trees then
		for k, v in pairs(self.ai_units_alive) do
			v._brain:debug_draw_behaviours()
		end

		if not self._debug_behaviour_trees then
			self._debug_behaviour_trees = true
		end
	elseif not self._debug_behaviour_trees then
		for k_2, v_2 in pairs(self.ai_units_alive) do
			Managers.state.debug_text:clear_unit_text(k_2, "behavior_tree")
		end
	end

	for k_3, v_3 in pairs(self.ai_units_alive) do
		if not script_data.debug_ai_targets then
			local target_unit = v_3._blackboard.target_unit

			if not alive(target_unit) then
				local num = Unit.local_position(k_3, 0) + Vector3.up() * 2

				QuickDrawer:line(num, Unit.world_position(target_unit, 0) + Vector3(0, 0, 1.5), Color(125, 255, 0, 0))
				QuickDrawer:box(Unit.world_pose(target_unit, 0), Vector3(0.5, 0.5, 1.5), Color(125, 255, 0, 0))
			end
		end

		if not script_data.debug_ai_heights then
			local var_33_2 = POSITION_LOOKUP[k_3]
			local breed_height = AiUtils.breed_height(k_3)

			if not breed_height then
				local num_2 = POSITION_LOOKUP[k_3] + Vector3(0, 0, breed_height)

				QuickDrawer:sphere(var_33_2, 0.5, Colors.get("yellow"))
				QuickDrawer:line(var_33_2, num_2, Colors.get("yellow"))
				QuickDrawer:sphere(num_2, 0.5, Colors.get("yellow"))
			else
				QuickDrawer:sphere(var_33_2 + Vector3(0, 0, 1), 1.5, Colors.get("red"))
			end
		end

		if not script_data.debug_stagger then
			local _blackboard = v_3._blackboard
			local stagger_immunity = _blackboard.stagger_immunity

			if not stagger_immunity then
				local color = Managers.state.debug:color(k_3)
				local to_elements, var_33_9, var_33_10, var_33_11 = Quaternion.to_elements(color)
				local var_33_12 = Vector3(var_33_9, var_33_10, var_33_11)
				local str = "player_1"
				local node = Unit.node(k_3, "c_head")

				Managers.state.debug_text:clear_unit_text(k_3, "stagger_immunity")

				local current_health_percent = _blackboard.current_health_percent
				local str_2 = "health:" .. current_health_percent
				local health_threshold = stagger_immunity.health_threshold
				local num_3 = 1

				Managers.state.debug_text:output_unit_text(str_2, 0.2, k_3, node, Vector3.up() * 0.2 * num_3, 0.1, "stagger_immunity", var_33_12, str)

				local num_4 = num_3 + 1

				if health_threshold < current_health_percent then
					Managers.state.debug_text:output_unit_text("damage left:" .. current_health_percent - health_threshold, 0.2, k_3, node, Vector3.up() * 0.2 * num_4, 0.1, "stagger_immunity", var_33_12, str)

					num_4 = num_4 + 1

					Managers.state.debug_text:output_unit_text("STAGGER_IMMUNE:HIGH_HEALTH", 0.2, k_3, node, Vector3.up() * 0.2 * num_4, 0.1, "stagger_immunity", var_33_12, str)
				else
					local action = _blackboard.action
					local flag = not action and action.ignore_staggers

					if not flag then
						local str_3 = action.name .. ": "

						for i6 = 1, 7 do
							local var_33_23

							if type(flag[i6]) == "table" then
								var_33_23 = tostring(not (current_health_percent > flag[i6].health.min) or current_health_percent <= flag[i6].health.max)

								if not var_33_23 then
									-- Nothing
								end
							end

							var_33_23 = tostring(flag[i6])

							::label_33_0::

							str_3 = str_3 .. "[" .. var_33_23 .. "]"
						end

						Managers.state.debug_text:output_unit_text(str_3, 0.2, k_3, node, Vector3.up() * 0.2 * num_4, 0.1, "stagger_immunity", var_33_12, str)

						num_4 = num_4 + 1
					end

					local flag_2 = false

					if not stagger_immunity.stagger_immune_at then
						flag_2 = not (arg_33_1 < stagger_immunity.stagger_immune_at + stagger_immunity.time) or stagger_immunity.debug_damage_left > 0

						if not flag_2 then
							local round_with_precision = math.round_with_precision(stagger_immunity.stagger_immune_at + stagger_immunity.time - arg_33_1, 2)

							Managers.state.debug_text:output_unit_text("time left:" .. round_with_precision, 0.2, k_3, node, Vector3.up() * 0.2 * num_4, 0.1, "stagger_immunity", var_33_12, str)

							num_4 = num_4 + 1

							Managers.state.debug_text:output_unit_text("damage left:" .. stagger_immunity.debug_damage_left, 0.2, k_3, node, Vector3.up() * 0.2 * num_4, 0.1, "stagger_immunity", var_33_12, str)

							num_4 = num_4 + 1

							Managers.state.debug_text:output_unit_text("STAGGER_IMMUNE:HITS", 0.2, k_3, node, Vector3.up() * 0.2 * num_4, 0.1, "stagger_immunity", var_33_12, str)

							num_4 = num_4 + 1
						end
					end

					if not flag_2 then
						local str_4 = "hits_until_stagger_immunity:"
						local num_attacks = stagger_immunity.num_attacks
						local num_hits = stagger_immunity.num_hits

						num_hits = num_hits or 0

						local str_5 = str_4 .. num_attacks - num_hits

						Managers.state.debug_text:output_unit_text(str_5, 0.2, k_3, node, Vector3.up() * 0.2 * num_4, 0.1, "stagger_immunity", var_33_12, str)
					end
				end
			end
		end

		if not script_data.debug_ai_attack_pattern then
			local var_33_30 = BLACKBOARDS[k_3]
			local has_node = Unit.has_node(k_3, "j_spine")

			has_node = not has_node and Unit.node(k_3, "j_spine")

			if not has_node then
				local world_position = Unit.world_position(k_3, has_node)
				local have_slot = var_33_30.have_slot
				local debug_text = Managers.state.debug_text

				debug_text:clear_unit_text(k_3, "attack_type")

				if var_33_30.stagger or not var_33_30.blocked then
					QuickDrawer:sphere(world_position, 0.25, Colors.get("blue"))
				elseif have_slot > 0 then
					local attack_cooldown_at = var_33_30.attack_cooldown_at

					if not var_33_30.attack_token then
						QuickDrawer:sphere(world_position, 0.35, Colors.get("red"))

						local attack_intensity_type

						if not var_33_30.action.attack_intensity_type then
							attack_intensity_type = var_33_30.action.attack_intensity_type

							if not attack_intensity_type then
								-- Nothing
							end
						end

						attack_intensity_type = "normal"

						::label_33_1::

						debug_text:output_unit_text(attack_intensity_type, 0.16, k_3, has_node, Vector3.zero(), nil, "attack_type", Vector3(255, 255, 255), "player_1")
					elseif arg_33_1 < attack_cooldown_at then
						QuickDrawer:sphere(world_position, 0.35, Colors.get("orange"))
					else
						QuickDrawer:sphere(world_position, 0.25, Colors.get("lime"))
					end
				else
					QuickDrawer:sphere(world_position, 0.25, Colors.get("gray"))
				end
			end
		end
	end

	if not script_data.debug_nav_tag_volume_layers then
		Debug.text("Nav Tag Volume Layers Status (20-39):")

		for i7 = NavTagVolumeStartLayer, 39 do
			local var_33_37 = LAYER_ID_MAPPING[i7]
			local flag_3 = NAV_TAG_VOLUME_LAYER_COST_AI[var_33_37] > 0

			Debug.text("%s=%s", var_33_37, flag_3)
		end
	end
end

local num_4 = 10

local function fn(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	fassert(arg_34_1, "Tried to update a non-existing blackboard!")

	local var_34_0 = POSITION_LOOKUP

	for k, v in pairs(arg_34_1.utility_actions) do
		v.time_since_last = arg_34_2 - v.last_time
		v.time_since_last_done = arg_34_2 - v.last_done_time
	end

	if not arg_34_1.is_in_attack_cooldown then
		arg_34_1.is_in_attack_cooldown = arg_34_2 < arg_34_1.attack_cooldown_at
	end

	ScriptUnit.extension(arg_34_0, "ai_system"):update_stagger_count()

	local has_extension = ScriptUnit.has_extension(arg_34_0, "health_system")

	if not has_extension then
		arg_34_1.current_health_percent = has_extension:current_health_percent()
		arg_34_1.current_health = has_extension:current_health()
	end

	local var_34_2 = var_34_0[arg_34_0]
	local navigation_extension = arg_34_1.navigation_extension

	if not navigation_extension then
		arg_34_1.destination_dist = navigation_extension:distance_to_destination(var_34_2)
	end

	local system = Managers.state.entity:system("ai_slot_system")
	local flag

	flag = not system:ai_unit_have_slot(arg_34_0) and 1 and 0
	arg_34_1.have_slot = flag
	arg_34_1.wait_slot_distance = system:ai_unit_wait_slot_distance(arg_34_0)
	arg_34_1.total_slots_count = system.num_total_enemies

	local target_unit = arg_34_1.target_unit
	local var_34_7 = alive(target_unit)
	local breed = arg_34_1.breed

	if not (not breed.wake_up_push and not var_34_7 and not (arg_34_1.stagger > 0)) then
		arg_34_1.wake_up_push = 0
	end

	if not breed.using_combo then
		if not var_34_7 then
			local get_data = Unit.get_data(target_unit, "last_combo_t")

			if not get_data then
				arg_34_1.time_since_last_combo = arg_34_2 - get_data
			else
				arg_34_1.time_since_last_combo = 9999
			end
		else
			arg_34_1.time_since_last_combo = 9999
		end
	end

	if not var_34_7 and not breed.has_running_attack then
		local has_extension_2 = ScriptUnit.has_extension(target_unit, "locomotion_system")

		if not has_extension_2 then
			if not has_extension_2.average_velocity then
				arg_34_1.target_speed_away = dot(has_extension_2:average_velocity(), normalize(var_34_0[target_unit] - var_34_2))
			elseif not has_extension_2.current_velocity then
				arg_34_1.target_speed_away = dot(has_extension_2:current_velocity(), normalize(var_34_0[target_unit] - var_34_2))
			else
				arg_34_1.target_speed_away = 0
			end

			if not has_extension_2.small_sample_size_average_velocity then
				arg_34_1.target_speed_away_small_sample = dot(has_extension_2:small_sample_size_average_velocity(), normalize(var_34_0[target_unit] - var_34_2))
			else
				arg_34_1.target_speed_away_small_sample = 0
			end
		else
			arg_34_1.target_speed_away = 0
			arg_34_1.target_speed_away_small_sample = 0
		end

		local has_extension_3 = ScriptUnit.has_extension(target_unit, "ai_slot_system")

		if not has_extension_3 and not has_extension_3.has_slots_attached then
			arg_34_1.total_occupied_slots = has_extension_3.num_occupied_slots

			local disabled_slots_count = system:disabled_slots_count(target_unit)
			local flag_2

			flag_2 = not (arg_34_1.have_slot > 0) or not 0 or disabled_slots_count
			arg_34_1.target_num_disabled_slots = flag_2
		else
			arg_34_1.total_occupied_slots = 0
			arg_34_1.target_num_disabled_slots = 0
		end
	else
		arg_34_1.target_speed_away = 0
		arg_34_1.target_speed_away_small_sample = 0
	end

	local active_node = arg_34_1.active_node
	local flag_3 = not active_node and active_node.name

	arg_34_1.is_following_target = not flag_3 and flag_3 == "BTClanRatFollowAction"

	local locomotion_extension = arg_34_1.locomotion_extension

	arg_34_1.is_falling = not locomotion_extension and locomotion_extension:is_falling()
	arg_34_1.move_speed = not locomotion_extension and locomotion_extension.move_speed

	if not breed.run_on_update then
		breed.run_on_update(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	end

	local attacking_target = arg_34_1.attacking_target
	local var_34_18 = alive(attacking_target)
	local var_34_19

	if not var_34_18 then
		local get_data_2 = Unit.get_data(attacking_target, "breed")

		if not get_data_2 and not get_data_2.is_player then
			var_34_19 = arg_34_1.side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[attacking_target]
		else
			var_34_19 = HEALTH_ALIVE[attacking_target]
		end
	else
		var_34_19 = true
	end

	arg_34_1.target_num_occupied_slots = 0

	if not var_34_7 and not var_34_19 then
		local var_34_21 = var_34_0[arg_34_0]
		local num = var_34_0[target_unit] - var_34_21
		local z = num.z
		local x = num.x
		local y = num.y
		local num_2 = x * x + y * y

		arg_34_1.target_dist_z_abs = math.abs(z)
		arg_34_1.target_dist_xy_sq = num_2

		local var_34_27 = sqrt(num_2 + z * z)
		local flag_4 = var_34_27 < num_4

		arg_34_1.target_dist = var_34_27

		local has_extension_4 = ScriptUnit.has_extension(target_unit, "ai_slot_system")

		if not has_extension_4 then
			arg_34_1.target_num_occupied_slots = has_extension_4.num_occupied_slots or 0
		else
			arg_34_1.target_num_occupied_slots = 0
		end

		return flag_4
	elseif not (not var_34_7 and var_34_19) then
		arg_34_1.target_unit = nil
		arg_34_1.target_dist = math.huge
		arg_34_1.target_dist_z_abs = math.huge
		arg_34_1.target_dist_xy_sq = math.huge

		if not var_34_19 then
			arg_34_1.attack_aborted = true
		end
	end
end

local flag_2

flag_2 = not IS_WINDOWS and 40 and 20

AISystem.update_ai_blackboards_prioritized = function (self, arg_35_1, arg_35_2)
	-- function 35
	local ai_blackboard_updates = self.ai_blackboard_updates
	local count = #ai_blackboard_updates
	local ai_blackboard_prioritized_updates = self.ai_blackboard_prioritized_updates
	local count_2 = #ai_blackboard_prioritized_updates
	local blackboards = self.blackboards
	local start_prio_index = self.start_prio_index
	local var_35_6 = flag_2

	if count_2 < var_35_6 then
		var_35_6 = count_2
		start_prio_index = 1
	end

	local num = 1

	while num <= var_35_6 do
		if count_2 < start_prio_index then
			start_prio_index = 1
		end

		local var_35_8 = ai_blackboard_prioritized_updates[start_prio_index]
		local var_35_9 = blackboards[var_35_8]

		if not fn(var_35_8, var_35_9, arg_35_1, arg_35_2) then
			ai_blackboard_prioritized_updates[start_prio_index] = ai_blackboard_prioritized_updates[count_2]
			ai_blackboard_prioritized_updates[count_2] = nil
			ai_blackboard_updates[count + 1] = var_35_8
			count = count + 1
			count_2 = count_2 - 1
		else
			start_prio_index = start_prio_index + 1
		end

		num = num + 1
	end

	self.start_prio_index = start_prio_index
end

local num_5 = 2

AISystem.update_ai_blackboards = function (self, arg_36_1, arg_36_2)
	-- function 36
	local ai_blackboard_updates = self.ai_blackboard_updates
	local count = #ai_blackboard_updates
	local ai_blackboard_prioritized_updates = self.ai_blackboard_prioritized_updates
	local count_2 = #ai_blackboard_prioritized_updates
	local blackboards = self.blackboards
	local num = 0
	local ai_update_index = self.ai_update_index

	ai_update_index = not (count < ai_update_index) or not 1 or ai_update_index

	while ai_update_index <= count do
		local var_36_7 = ai_blackboard_updates[ai_update_index]
		local var_36_8 = blackboards[var_36_7]

		if not fn(var_36_7, var_36_8, arg_36_1, arg_36_2) then
			ai_blackboard_updates[ai_update_index] = ai_blackboard_updates[count]
			ai_blackboard_updates[count] = nil
			ai_blackboard_prioritized_updates[count_2 + 1] = var_36_7
			count = #ai_blackboard_updates
			count_2 = #ai_blackboard_prioritized_updates
		else
			ai_update_index = ai_update_index + 1
		end

		num = num + 1

		if num >= num_5 then
			break
		end
	end

	self.ai_update_index = ai_update_index
end

AISystem.nav_world = function (self)
	-- function 37
	return self._nav_world
end

AISystem.client_traverse_logic = function (self)
	-- function 38
	return self._traverse_logic
end

AISystem.get_tri_on_navmesh = function (self, arg_39_1)
	-- function 39
	return GwNavQueries.triangle_from_position(self._nav_world, arg_39_1, 30, 30)
end

AISystem.set_allowed_layer = function (self, arg_40_1, arg_40_2)
	-- function 40
	if not self.is_server then
		local entity = Managers.state.entity
		local _nav_world = self._nav_world
		local var_40_2 = LAYER_ID_MAPPING[arg_40_1]
		local conflict = Managers.state.conflict
		local NAV_TAG_VOLUME_LAYER_COST_AI = NAV_TAG_VOLUME_LAYER_COST_AI
		local flag

		flag = not arg_40_2 and 1 and 0
		NAV_TAG_VOLUME_LAYER_COST_AI[arg_40_1] = flag

		local NAV_TAG_VOLUME_LAYER_COST_BOTS = NAV_TAG_VOLUME_LAYER_COST_BOTS
		local flag_2

		flag_2 = not arg_40_2 and 1 and 0
		NAV_TAG_VOLUME_LAYER_COST_BOTS[arg_40_1] = flag_2

		local get_entities = entity:get_entities("AINavigationExtension")

		for k, v in pairs(get_entities) do
			v:allow_layer(arg_40_1, arg_40_2)

			if not arg_40_2 then
				local _unit = v._unit

				if not ALIVE[_unit] then
					local var_40_10 = POSITION_LOOKUP[_unit]

					if not NavTagVolumeUtils.inside_nav_tag_layer(_nav_world, var_40_10, 0.5, 0.5, arg_40_1) then
						if not ScriptUnit.has_extension(_unit, "health_system") then
							AiUtils.kill_unit(_unit, nil, nil, "inside_forbidden_tag_volume", Vector3(0, 0, 0))
						else
							local var_40_11 = BLACKBOARDS[_unit]

							conflict:destroy_unit(_unit, var_40_11, "inside_forbidden_tag_volume")
						end
					else
						local destination = v:destination()

						if not NavTagVolumeUtils.inside_nav_tag_layer(_nav_world, destination, 0.5, 0.5, arg_40_1) then
							v:reset_destination()
						end
					end
				end
			end
		end

		Managers.state.bot_nav_transition:allow_layer(arg_40_1, arg_40_2)
		Managers.state.entity:system("ai_slot_system"):set_allowed_layer(arg_40_1, arg_40_2)
		Managers.state.entity:system("ai_group_system"):set_allowed_layer(arg_40_1, arg_40_2)
		self.network_transmit:send_rpc_clients("rpc_set_allowed_nav_layer", var_40_2, arg_40_2)
	end
end

AISystem.alert_enemies_within_range = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	if not NetworkUtils.network_safe_position(arg_41_2) then
		Application.warning("Trying to alert enemies outside of safe network position")

		return
	end

	if not self.is_server then
		PerceptionUtils.alert_enemies_within_range(self.world, arg_41_1, true, arg_41_2, arg_41_3)
	else
		local go_id = Managers.state.unit_storage:go_id(arg_41_1)

		self.network_transmit:send_rpc_server("rpc_alert_enemies_within_range", go_id, arg_41_2, arg_41_3)
	end
end

AISystem.rpc_alert_enemies_within_range = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	-- function 42
	local unit = Managers.state.unit_storage:unit(arg_42_2)

	self:alert_enemies_within_range(unit, arg_42_3, arg_42_4)
end

AISystem.rpc_set_ward_state = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local unit = Managers.state.unit_storage:unit(arg_43_2)

	AiUtils.stormvermin_champion_set_ward_state(unit, arg_43_3, false)
end

AISystem.rpc_set_hit_reaction_template = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local unit = Managers.state.unit_storage:unit(arg_44_2)

	ScriptUnit.extension(unit, "hit_reaction_system"):set_hit_effect_template_id(arg_44_3)
end

AISystem.rpc_change_tentacle_state = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	-- function 45
	local unit = Managers.state.unit_storage:unit(arg_45_2)
	local unit_2 = Managers.state.unit_storage:unit(arg_45_3)
	local var_45_2 = NetworkLookup.tentacle_template[arg_45_4]
	local has_extension = ScriptUnit.has_extension(unit, "ai_supplementary_system")

	if not has_extension then
		has_extension:set_target(var_45_2, unit_2, arg_45_5)
		has_extension:set_server_time(arg_45_6)
	end
end

AISystem.rpc_sync_tentacle_path = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local unit = Managers.state.unit_storage:unit(arg_46_2)
	local has_extension = ScriptUnit.has_extension(unit, "ai_supplementary_system")

	if not has_extension then
		has_extension:set_astar_points(arg_46_3)
	end
end

AISystem.rpc_set_corruptor_beam_state = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	-- function 47
	local unit = Managers.state.unit_storage:unit(arg_47_2)
	local unit_2 = Managers.state.unit_storage:unit(arg_47_4)
	local has_extension = ScriptUnit.has_extension(unit, "ai_beam_effect_system")

	if not unit and not has_extension then
		local var_47_3 = has_extension
		local set_state = has_extension.set_state
		local var_47_5 = arg_47_3
		local is_player_unit = Managers.player:is_player_unit(unit_2)

		is_player_unit = not is_player_unit and unit_2

		set_state(var_47_3, var_47_5, is_player_unit)
	end
end

AISystem.rpc_set_allowed_nav_layer = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local var_48_0 = LAYER_ID_MAPPING[arg_48_2]
	local NAV_TAG_VOLUME_LAYER_COST_AI = NAV_TAG_VOLUME_LAYER_COST_AI
	local flag

	flag = not arg_48_3 and 1 and 0
	NAV_TAG_VOLUME_LAYER_COST_AI[var_48_0] = flag

	local NAV_TAG_VOLUME_LAYER_COST_BOTS = NAV_TAG_VOLUME_LAYER_COST_BOTS
	local flag_2

	flag_2 = not arg_48_3 and 1 and 0
	NAV_TAG_VOLUME_LAYER_COST_BOTS[var_48_0] = flag_2

	if not arg_48_3 then
		GwNavTagLayerCostTable.allow_layer(self._navtag_layer_cost_table, arg_48_2)
	else
		GwNavTagLayerCostTable.forbid_layer(self._navtag_layer_cost_table, arg_48_2)
	end
end

AISystem.rpc_check_trigger_backstab_sfx = function (self, arg_49_1, arg_49_2)
	-- function 49
	if not DEDICATED_SERVER then
		return
	end

	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_49_2)
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not ALIVE[flag] then
		return
	end

	local has_extension = ScriptUnit.has_extension(flag, "first_person_system")

	if not has_extension then
		local forward = Quaternion.forward(has_extension:current_rotation())

		if not AiUtils.unit_is_flanking_player(game_object_or_level_unit, flag, forward) then
			local extension = ScriptUnit.extension(game_object_or_level_unit, "dialogue_system")
			local make_unit_auto_source, var_49_7 = WwiseUtils.make_unit_auto_source(self.world, game_object_or_level_unit, extension.voice_node)
			local backstab_player_sound_event = Unit.get_data(game_object_or_level_unit, "breed").backstab_player_sound_event

			Managers.state.entity:system("audio_system"):_play_event_with_source(var_49_7, backstab_player_sound_event, make_unit_auto_source)
		end
	end
end

function write_attribute(self, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	-- function 50
	local attributes = self.attributes

	if not attributes then
		attributes = {}
		self.attributes = attributes
	end

	local var_50_1 = attributes[arg_50_3]

	var_50_1 = var_50_1 or {}
	attributes[arg_50_3] = var_50_1
	attributes[arg_50_3][arg_50_2] = arg_50_4

	local var_50_2 = AttributeDefinition[arg_50_3][arg_50_2]

	if not var_50_2 then
		var_50_2(arg_50_1, arg_50_4)
	end
end

AISystem.set_attribute = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	-- function 51
	local var_51_0 = self.unit_extension_data[arg_51_1]

	write_attribute(var_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)

	if not arg_51_5 then
		return
	end

	local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_51_1)
	local var_51_2 = NetworkLookup.attributes[arg_51_2]
	local var_51_3 = NetworkLookup.attribute_categories[arg_51_3]
	local var_51_4 = type(arg_51_4)

	if var_51_4 == "boolean" then
		self.network_transmit:send_rpc_clients("rpc_set_attribute_bool", unit_game_object_id, var_51_2, var_51_3, arg_51_4)
	elseif var_51_4 == "number" then
		self.network_transmit:send_rpc_clients("rpc_set_attribute_int", unit_game_object_id, var_51_2, var_51_3, arg_51_4)
	else
		self.network_transmit:send_rpc_clients("rpc_remove_attribute", unit_game_object_id, var_51_2, var_51_3)
	end
end

AISystem.get_attributes = function (self, arg_52_1)
	-- function 52
	local var_52_0 = self.unit_extension_data[arg_52_1]
	local attributes

	if not var_52_0 then
		attributes = var_52_0.attributes

		if not attributes then
			-- Nothing
		end
	end

	attributes = tbl

	::label_52_0::

	return attributes
end

AISystem.rpc_set_attribute_bool = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	-- function 53
	print("rpc_set_attribute_bool", arg_53_2, arg_53_3, arg_53_4, arg_53_5)

	local unit = Managers.state.unit_storage:unit(arg_53_2)
	local var_53_1 = self.unit_extension_data[unit]
	local var_53_2 = NetworkLookup.attributes[arg_53_3]
	local var_53_3 = NetworkLookup.attribute_categories[arg_53_4]

	write_attribute(var_53_1, unit, var_53_2, var_53_3, arg_53_5)
end

AISystem.rpc_set_attribute_int = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	-- function 54
	print("rpc_set_attribute_int", arg_54_2, arg_54_3, arg_54_4, arg_54_5)

	local unit = Managers.state.unit_storage:unit(arg_54_2)
	local var_54_1 = self.unit_extension_data[unit]
	local var_54_2 = NetworkLookup.attributes[arg_54_3]
	local var_54_3 = NetworkLookup.attribute_categories[arg_54_4]

	write_attribute(var_54_1, unit, var_54_2, var_54_3, arg_54_5)
end

AISystem.rpc_remove_attribute = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	print("rpc_remove_attribute", arg_55_2, arg_55_3, arg_55_4, nil)

	local unit = Managers.state.unit_storage:unit(arg_55_2)
	local var_55_1 = self.unit_extension_data[unit]
	local var_55_2 = NetworkLookup.attributes[arg_55_3]
	local var_55_3 = NetworkLookup.attribute_categories[arg_55_4]

	write_attribute(var_55_1, unit, var_55_2, var_55_3, nil)
end

AISystem.hot_join_sync = function (self, arg_56_1)
	-- function 56
	local count = #LAYER_ID_MAPPING

	for i = NavTagVolumeStartLayer, count do
		local var_56_1 = LAYER_ID_MAPPING[i]

		if NAV_TAG_VOLUME_LAYER_COST_AI[var_56_1] <= 0 then
			self.network_transmit:send_rpc("rpc_set_allowed_nav_layer", arg_56_1, i, false)
		end
	end

	for k, v in pairs(self.unit_extension_data) do
		local attributes = v.attributes

		if not attributes and not next(attributes) then
			local network = Managers.state.network
			local unit_game_object_id = Managers.state.network:unit_game_object_id(k)

			for k_2, v_2 in pairs(attributes) do
				local var_56_5 = NetworkLookup.attribute_categories[k_2]

				for k_3, v_3 in pairs(v_2) do
					local var_56_6 = NetworkLookup.attributes[k_3]

					if type(v_3) == "boolean" then
						self.network_transmit:send_rpc("rpc_set_attribute_bool", arg_56_1, unit_game_object_id, var_56_6, var_56_5, v_3)
					else
						self.network_transmit:send_rpc("rpc_set_attribute_int", arg_56_1, unit_game_object_id, var_56_6, var_56_5, v_3)
					end
				end
			end
		end
	end

	for k_4, v_4 in pairs(self._hot_join_sync_units) do
		v_4(arg_56_1, k_4)
	end
end

AISystem.create_all_trees = function (arg_57_0)
	-- function 57
	flag = true

	for k, v in pairs(BreedBehaviors) do
		local var_57_0 = BehaviorTree:new(v, k)

		arg_57_0._behavior_trees[k] = var_57_0
	end

	for k_2, v_2 in pairs(BotBehaviors) do
		local var_57_1 = BehaviorTree:new(v_2, k_2)

		arg_57_0._behavior_trees[k_2] = var_57_1
	end
end

AISystem.behavior_tree = function (self, arg_58_1)
	-- function 58
	return self._behavior_trees[arg_58_1]
end

AISystem.register_unit_for_destruction = function (arg_59_0, arg_59_1)
	-- function 59
	arg_59_0._units_to_destroy[arg_59_1] = arg_59_1
end
