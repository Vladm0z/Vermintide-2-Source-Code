-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_simple_extension.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension_c")
require("scripts/unit_extensions/human/ai_player_unit/ai_husk_locomotion_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_navigation_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_brain")
require("scripts/unit_extensions/human/ai_player_unit/perception_utils")
require("scripts/unit_extensions/human/ai_player_unit/target_selection_utils")

local alive = Unit.alive

AISimpleExtension = class(AISimpleExtension)

AISimpleExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self._world = extension_init_context.world
	self._unit = unit
	self._nav_world = extension_init_data.nav_world

	local ai_system = Managers.state.entity:system("ai_system")
	local spawn_type = extension_init_data.spawn_type
	local is_horde = spawn_type == "horde_hidden" or spawn_type == "horde"
	local breed = extension_init_data.breed

	Unit.set_data(unit, "breed", breed)

	self._breed = breed

	fassert(extension_init_data.side_id, "no side_id")

	self._side_id = extension_init_data.side_id

	local flag

	if breed.initial_is_passive == nil then
		flag = true

		goto label_1_0
	end

	flag = breed.initial_is_passive

	local is_passive = flag

	::label_1_0::

	local new_map = Script.new_map
	local blackboard_allocation_size = breed.blackboard_allocation_size

	blackboard_allocation_size = not not blackboard_allocation_size or not not 75

	local blackboard = new_map(blackboard_allocation_size)
	local optional_spawn_data = extension_init_data.optional_spawn_data

	blackboard.world = extension_init_context.world
	blackboard.unit = unit
	blackboard.level = LevelHelper:current_level(extension_init_context.world)
	blackboard.nav_world = self._nav_world
	blackboard.node_data = {}
	blackboard.running_nodes = {}
	blackboard.is_passive = is_passive
	blackboard.system_api = extension_init_context.system_api
	blackboard.group_blackboard = ai_system.group_blackboard
	blackboard.target_dist = math.huge
	blackboard.spawn_type = spawn_type
	blackboard.stuck_check_time = Managers.time:time("game") + RecycleSettings.ai_stuck_check_start_time
	blackboard.is_in_attack_cooldown = false
	blackboard.attack_cooldown_at = 0
	blackboard.stagger_count = 0
	blackboard.stagger_count_reset_at = 0
	blackboard.override_targets = {}
	blackboard.optional_spawn_data = optional_spawn_data
	blackboard.spawn_category = extension_init_data.spawn_category
	blackboard.is_ai = true
	blackboard.lean_unit_list = {}
	blackboard.next_lean_index = 0

	local blackboard_init_data = breed.blackboard_init_data

	if blackboard_init_data and blackboard_init_data.player_locomotion_constrain_radius ~= nil then
		local player_locomotion_constrain_radius = blackboard_init_data.player_locomotion_constrain_radius

		player_locomotion_constrain_radius = not not player_locomotion_constrain_radius or not not nil
		self.player_locomotion_constrain_radius = player_locomotion_constrain_radius
	else
		local player_locomotion_constrain_radius_2 = breed.player_locomotion_constrain_radius

		player_locomotion_constrain_radius_2 = not not player_locomotion_constrain_radius_2 or not not nil
		self.player_locomotion_constrain_radius = player_locomotion_constrain_radius_2
	end

	blackboard.lean_dogpile = 0
	blackboard.crowded_slots = breed.infighting.crowded_slots

	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	self._health_extension = health_extension

	local locomotion_extension = ScriptUnit.has_extension(unit, "locomotion_system")

	self._locomotion = locomotion_extension
	blackboard.locomotion_extension = locomotion_extension

	local ai_navigation_extension = ScriptUnit.has_extension(unit, "ai_navigation_system")

	self._navigation = ai_navigation_extension
	blackboard.navigation_extension = ai_navigation_extension

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	blackboard.buff_extension = buff_extension
	blackboard.health_extension = ScriptUnit.has_extension(unit, "health_system")

	local blackboard_init_data = breed.blackboard_init_data

	if blackboard_init_data then
		table.merge(blackboard, blackboard_init_data)
	end

	self._blackboard = blackboard

	if not breed.hit_zones_lookup then
		DamageUtils.create_hit_zone_lookup(unit, breed)
	end

	if breed.special_on_spawn_stinger then
		WwiseUtils.trigger_unit_event(self._world, breed.special_on_spawn_stinger, unit, 0)
	end

	local behavior_2

	if optional_spawn_data then
		behavior_2 = optional_spawn_data.behavior

		if not behavior_2 then
			-- Nothing
		end
	end

	if is_horde then
		behavior_2 = breed.horde_behavior

		if not behavior_2 then
			-- Nothing
		end
	end

	behavior_2 = breed.behavior

	local behavior = behavior_2

	::label_1_1::

	self:_init_brain(behavior, is_horde)
	self:_set_size_variation(extension_init_data.size_variation, extension_init_data.size_variation_normalized)

	self.attributes = nil
end

AISimpleExtension.unit_removed_from_game = function (self)
	-- function 2
	Managers.state.side:remove_unit_from_side(self._unit)

	self._side_id = nil
end

AISimpleExtension.destroy = function (self)
	-- function 3
	local blackboard = self._blackboard

	AiUtils.special_dead_cleanup(self._unit, self._blackboard)
	self._brain:destroy()
end

local STATIC_BLACKBOARD_KEYS = STATIC_BLACKBOARD_KEYS

STATIC_BLACKBOARD_KEYS = not not STATIC_BLACKBOARD_KEYS or not not {
	target_dist = true,
	stagger_count = true,
	node_data = true,
	spawn_type = true,
	next_lean_index = true,
	health_extension = true,
	override_targets = true,
	lean_dogpile = true,
	navigation_extension = true,
	locomotion_extension = true,
	system_api = true,
	lean_slots = true,
	next_smart_object_data = true,
	unit = true,
	optional_spawn_data = true,
	level = true,
	stagger_count_reset_at = true,
	lean_unit_list = true,
	world = true,
	running_nodes = true,
	is_in_attack_cooldown = true,
	group_blackboard = true,
	attack_cooldown_at = true,
	stuck_check_time = true,
	inventory_extension = true,
	is_passive = true,
	breed = true,
	nav_world = true
}
STATIC_BLACKBOARD_KEYS = STATIC_BLACKBOARD_KEYS

AISimpleExtension.freeze = function (self)
	-- function 4
	self._brain:exit_last_action()

	self._side_id = nil
end

AISimpleExtension.unfreeze = function (self, unit, data)
	-- function 5
	local blackboard = self._blackboard

	for k, v in pairs(blackboard) do
		if not STATIC_BLACKBOARD_KEYS[k] then
			blackboard[k] = nil
		end
	end

	local spawn_category = data[4]
	local spawn_type = data[6]
	local optional_spawn_data = data[7]
	local side_id = optional_spawn_data.side_id

	self._side_id = side_id

	fassert(side_id ~= nil, "no side_id")

	local side = Managers.state.side:add_unit_to_side(self._unit, side_id)

	table.clear(blackboard.node_data)
	table.clear(blackboard.running_nodes)
	table.clear(blackboard.override_targets)

	if self.attributes then
		table.clear(self.attributes)
	end

	blackboard.target_dist = math.huge
	blackboard.spawn_type = spawn_type
	blackboard.spawn_category = spawn_category

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	blackboard.buff_extension = buff_extension
	blackboard.stuck_check_time = Managers.time:time("game") + RecycleSettings.ai_stuck_check_start_time
	blackboard.is_in_attack_cooldown = false
	blackboard.attack_cooldown_at = 0
	blackboard.stagger_count = 0
	blackboard.stagger_count_reset_at = 0
	blackboard.optional_spawn_data = optional_spawn_data
	blackboard.side = side

	local breed = blackboard.breed

	blackboard.lean_dogpile = 0
	blackboard.crowded_slots = breed.infighting.crowded_slots

	table.clear(blackboard.lean_unit_list)

	blackboard.next_lean_index = 0

	local is_horde = spawn_type == "horde_hidden" or spawn_type == "horde"
	local behavior_2

	if optional_spawn_data then
		behavior_2 = optional_spawn_data.behavior

		if not behavior_2 then
			-- Nothing
		end
	end

	if is_horde then
		behavior_2 = breed.horde_behavior

		if not behavior_2 then
			-- Nothing
		end
	end

	behavior_2 = breed.behavior

	local behavior = behavior_2

	::label_5_0::

	self._brain:unfreeze(blackboard, behavior)
	self:init_perception(breed, is_horde)

	if breed.far_off_despawn_immunity or optional_spawn_data and optional_spawn_data.far_off_despawn_immunity then
		blackboard.far_off_despawn_immunity = true
	end

	if breed.run_on_spawn then
		breed.run_on_spawn(unit, blackboard)
	end

	Managers.state.game_mode:ai_spawned(unit)
end

AISimpleExtension.extensions_ready = function (self, world, unit)
	-- function 6
	local blackboard = self._blackboard
	local side_id = self._side_id
	local side = Managers.state.side:add_unit_to_side(unit, side_id)

	blackboard.side = side

	local breed = self._breed
	local spawn_type = blackboard.spawn_type
	local is_horde = spawn_type == "horde_hidden" or spawn_type == "horde"

	self:init_perception(breed, is_horde)

	if self._health_extension then
		self.broadphase_id = Broadphase.add(blackboard.group_blackboard.broadphase, unit, Unit.local_position(unit, 0), 1, side.broadphase_category)
	end

	local optional_spawn_data = blackboard.optional_spawn_data

	if breed.far_off_despawn_immunity or optional_spawn_data and optional_spawn_data.far_off_despawn_immunity then
		blackboard.far_off_despawn_immunity = true
	end

	if breed.run_on_spawn then
		breed.run_on_spawn(unit, blackboard)
	end

	Managers.state.game_mode:ai_spawned(unit)
	Unit.flow_event(unit, "lua_trigger_variation")

	local level_settings = LevelSettings[Managers.state.game_mode:level_key()]
	local climate_type_2 = level_settings.climate_type

	if not climate_type_2 then
		-- Nothing
	end

	climate_type_2 = "default"

	local climate_type = climate_type_2

	::label_6_0::

	Unit.set_flow_variable(unit, "climate_type", climate_type)
	Unit.flow_event(unit, "climate_type_set")
end

AISimpleExtension.get_overlap_context = function (self)
	-- function 7
	if self._overlap_context then
		self._overlap_context.num_hits = 0
	else
		self._overlap_context = {
			has_gotten_callback = false,
			spine_node = false,
			num_hits = 0,
			overlap_units = {}
		}

		GarbageLeakDetector.register_object(self._overlap_context, "ai_overlap_context")
	end

	return self._overlap_context
end

AISimpleExtension.set_properties = function (self, params)
	-- function 8
	for _, property in pairs(params) do
		local prop_name, prop_value = property:match("(%S+) (%S+)")
		local prop_type = type(self._breed.properties[prop_name])

		if prop_type == "table" then
			prop_value = AIProperties

			local prop_iterator = property:gmatch("(%S+)")

			prop_iterator()

			for i = 1, 10 do
				local index = prop_iterator()

				if index == nil then
					break
				end

				fassert(prop_value[index], "Table index %q not found in AIProperties", index)

				prop_value = prop_value[index]
			end
		elseif prop_type == "number" then
			prop_value = tonumber(prop_value)
		elseif prop_type == "boolean" then
			prop_value = to_boolean(prop_value)
		end

		self._breed.properties[prop_name] = prop_value
	end
end

AISimpleExtension._parse_properties = function (self)
	-- function 9
	for prop_name, prop_value in pairs(self._breed.properties) do
		if type(prop_value) == "table" then
			for key, value in pairs(prop_value) do
				self._breed.properties[key] = value
			end
		end
	end
end

AISimpleExtension.init_perception = function (self, breed, is_horde)
	-- function 10
	if breed.perception then
		local horde_perception

		if is_horde then
			horde_perception = breed.horde_perception

			if not horde_perception then
				-- Nothing
			end
		end

		horde_perception = breed.perception

		::label_10_0::

		self._perception_func_name = horde_perception
	else
		self._perception_func_name = "perception_regular"
	end

	if breed.target_selection then
		local horde_target_selection

		if is_horde then
			horde_target_selection = breed.horde_target_selection

			if not horde_target_selection then
				-- Nothing
			end
		end

		horde_target_selection = breed.target_selection

		::label_10_1::

		self._target_selection_func_name = horde_target_selection
	else
		self._target_selection_func_name = "pick_closest_target_with_spillover"
	end
end

AISimpleExtension.set_perception = function (self, perception_func_name, target_selection_func_name)
	-- function 11
	if perception_func_name then
		self._perception_func_name = perception_func_name
	else
		self._perception_func_name = "perception_regular"
	end

	if target_selection_func_name then
		self._target_selection_func_name = target_selection_func_name
	else
		self._target_selection_func_name = "pick_closest_target_with_spillover"
	end
end

AISimpleExtension._init_brain = function (self, behavior, is_horde)
	-- function 12
	self._brain = AIBrain:new(self._world, self._unit, self._blackboard, self._breed, behavior)
end

AISimpleExtension._set_size_variation = function (self, size_variation, size_variation_normalized)
	-- function 13
	self._size_variation = not not size_variation or not not 1
	self._size_variation_normalized = not not size_variation_normalized or not not 1
end

AISimpleExtension.locomotion = function (self)
	-- function 14
	return self._locomotion
end

AISimpleExtension.navigation = function (self)
	-- function 15
	return self._navigation
end

AISimpleExtension.brain = function (self)
	-- function 16
	return self._brain
end

AISimpleExtension.breed = function (self)
	-- function 17
	return self._breed
end

AISimpleExtension.blackboard = function (self)
	-- function 18
	return self._blackboard
end

AISimpleExtension.size_variation = function (self)
	-- function 19
	return self._size_variation, self._size_variation_normalized
end

AISimpleExtension.force_enemy_detection = function (self, t)
	-- function 20
	local side = Managers.state.side.side_by_unit[self._unit]
	local enemy_player_and_bot_units = side.ENEMY_PLAYER_AND_BOT_UNITS
	local num_targets = #enemy_player_and_bot_units

	if num_targets == 0 then
		return
	end

	local target = Math.random(1, num_targets)
	local random_enemy = enemy_player_and_bot_units[target]

	if random_enemy then
		self:enemy_aggro(self._unit, random_enemy)
	end
end

AISimpleExtension.current_action_name = function (self)
	-- function 21
	local blackboard = self._blackboard
	local name

	if blackboard.action then
		name = blackboard.action.name

		if not name then
			-- Nothing
		end
	end

	name = "n/a"

	::label_21_0::

	return name
end

AISimpleExtension.die = function (self, killer_unit, killing_blow)
	-- function 22
	local blackboard = self._blackboard
	local unit = self._unit

	self._brain:exit_last_action()

	if self._blackboard.group_blackboard then
		AiUtils.special_dead_cleanup(unit, blackboard)
	end

	local conflict_director = Managers.state.conflict

	conflict_director:register_unit_killed(unit, blackboard, killer_unit, killing_blow)
end

AISimpleExtension.attacked = function (self, attacker_unit, t, damage_hit)
	-- function 23
	local unit = self._unit
	local blackboard = self._blackboard
	local side = blackboard.side

	attacker_unit = AiUtils.get_actual_attacker_unit(attacker_unit)

	local is_enemy = side.enemy_units_lookup[attacker_unit]

	if is_enemy then
		if damage_hit and blackboard.confirmed_player_sighting and blackboard.target_unit == nil then
			blackboard.target_unit = attacker_unit
			blackboard.target_unit_found_time = t

			AiUtils.alert_nearby_friends_of_enemy(unit, blackboard.group_blackboard.broadphase, attacker_unit)
		end

		blackboard.previous_attacker = attacker_unit

		if not damage_hit and blackboard.stagger == 1 and HEALTH_ALIVE[unit] then
			StatisticsUtil.check_save(attacker_unit, unit)
		end
	end
end

AISimpleExtension.enemy_aggro = function (self, alerting_unit, enemy_unit)
	-- function 24
	local blackboard = self._blackboard

	if blackboard.confirmed_player_sighting or blackboard.only_trust_your_own_eyes then
		return
	end

	local self_unit = self._unit
	local attacked_by_ally = not Managers.state.side:is_enemy(self_unit, enemy_unit)

	if attacked_by_ally then
		return
	end

	blackboard.delayed_target_unit = enemy_unit

	AiUtils.activate_unit(blackboard)

	blackboard.no_hesitation = true

	local slot_extension = ScriptUnit.has_extension(self_unit, "ai_slot_system")

	if slot_extension then
		slot_extension.do_search = true
	end

	if ScriptUnit.has_extension(self_unit, "ai_inventory_system") then
		local network_manager = Managers.state.network
		local self_unit_id = network_manager:unit_game_object_id(self_unit)

		network_manager.network_transmit:send_rpc_all("rpc_ai_inventory_wield", self_unit_id, 1)
	end
end

AISimpleExtension.enemy_alert = function (self, alerting_unit, enemy_unit)
	-- function 25
	local blackboard = self._blackboard
	local run_on_alerted = self._breed.run_on_alerted

	if run_on_alerted then
		run_on_alerted(self._unit, self._blackboard, alerting_unit, enemy_unit)
	end

	if blackboard.confirmed_player_sighting or blackboard.only_trust_your_own_eyes then
		return
	end

	if blackboard.hesitating or blackboard.in_alerted_state and blackboard.alerted_deadline_reached then
		self:enemy_aggro(alerting_unit, enemy_unit)
	end

	local attacked_by_ally = not Managers.state.side:is_enemy(self._unit, enemy_unit)

	if attacked_by_ally then
		return
	end

	self._blackboard.delayed_target_unit = enemy_unit
end

local DEFAULT_STAGGER_RESET_TIME = 10

AISimpleExtension.increase_stagger_count = function (self)
	-- function 26
	local blackboard = self._blackboard
	local breed = self._breed
	local stagger_count = blackboard.stagger_count
	local stagger_count_reset_time = breed.stagger_count_reset_time

	if not stagger_count_reset_time then
		-- Nothing
	end

	stagger_count_reset_time = DEFAULT_STAGGER_RESET_TIME

	local reset_time = stagger_count_reset_time

	::label_26_0::

	local t = Managers.time:time("main")

	blackboard.stagger_count = stagger_count + 1
	blackboard.stagger_count_reset_at = t + reset_time
end

AISimpleExtension.reset_stagger_count = function (self)
	-- function 27
	local blackboard = self._blackboard

	blackboard.stagger_count_reset_at = 0
	blackboard.stagger_count = 0
end

AISimpleExtension.update_stagger_count = function (self)
	-- function 28
	local blackboard = self._blackboard
	local reset_at = blackboard.stagger_count_reset_at
	local t = Managers.time:time("main")

	if reset_at < t and blackboard.stagger_count > 0 then
		blackboard.stagger_count = 0
	end
end
