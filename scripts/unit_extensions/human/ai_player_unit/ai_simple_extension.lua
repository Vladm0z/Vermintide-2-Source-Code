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

AISimpleExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._unit = arg_1_2
	self._nav_world = arg_1_3.nav_world

	local system = Managers.state.entity:system("ai_system")
	local spawn_type = arg_1_3.spawn_type
	local flag = spawn_type == "horde_hidden" or spawn_type == "horde"
	local breed = arg_1_3.breed

	Unit.set_data(arg_1_2, "breed", breed)

	self._breed = breed

	fassert(arg_1_3.side_id, "no side_id")

	self._side_id = arg_1_3.side_id

	local flag_2

	flag_2 = breed.initial_is_passive ~= nil or not true or breed.initial_is_passive

	local new_map = Script.new_map
	local blackboard_allocation_size = breed.blackboard_allocation_size

	blackboard_allocation_size = blackboard_allocation_size or 75

	local var_1_7 = new_map(blackboard_allocation_size)
	local optional_spawn_data = arg_1_3.optional_spawn_data

	var_1_7.world = arg_1_1.world
	var_1_7.unit = arg_1_2
	var_1_7.level = LevelHelper:current_level(arg_1_1.world)
	var_1_7.nav_world = self._nav_world
	var_1_7.node_data = {}
	var_1_7.running_nodes = {}
	var_1_7.is_passive = flag_2
	var_1_7.system_api = arg_1_1.system_api
	var_1_7.group_blackboard = system.group_blackboard
	var_1_7.target_dist = math.huge
	var_1_7.spawn_type = spawn_type
	var_1_7.stuck_check_time = Managers.time:time("game") + RecycleSettings.ai_stuck_check_start_time
	var_1_7.is_in_attack_cooldown = false
	var_1_7.attack_cooldown_at = 0
	var_1_7.stagger_count = 0
	var_1_7.stagger_count_reset_at = 0
	var_1_7.override_targets = {}
	var_1_7.optional_spawn_data = optional_spawn_data
	var_1_7.spawn_category = arg_1_3.spawn_category
	var_1_7.is_ai = true
	var_1_7.lean_unit_list = {}
	var_1_7.next_lean_index = 0

	local blackboard_init_data = breed.blackboard_init_data

	if not (not blackboard_init_data and blackboard_init_data.player_locomotion_constrain_radius == nil) then
		local player_locomotion_constrain_radius = blackboard_init_data.player_locomotion_constrain_radius

		player_locomotion_constrain_radius = player_locomotion_constrain_radius or nil
		self.player_locomotion_constrain_radius = player_locomotion_constrain_radius
	else
		local player_locomotion_constrain_radius_2 = breed.player_locomotion_constrain_radius

		player_locomotion_constrain_radius_2 = player_locomotion_constrain_radius_2 or nil
		self.player_locomotion_constrain_radius = player_locomotion_constrain_radius_2
	end

	var_1_7.lean_dogpile = 0
	var_1_7.crowded_slots = breed.infighting.crowded_slots
	self._health_extension = ScriptUnit.has_extension(arg_1_2, "health_system")

	local has_extension = ScriptUnit.has_extension(arg_1_2, "locomotion_system")

	self._locomotion = has_extension
	var_1_7.locomotion_extension = has_extension

	local has_extension_2 = ScriptUnit.has_extension(arg_1_2, "ai_navigation_system")

	self._navigation = has_extension_2
	var_1_7.navigation_extension = has_extension_2
	var_1_7.buff_extension = ScriptUnit.has_extension(arg_1_2, "buff_system")
	var_1_7.health_extension = ScriptUnit.has_extension(arg_1_2, "health_system")

	local blackboard_init_data_2 = breed.blackboard_init_data

	if not blackboard_init_data_2 then
		table.merge(var_1_7, blackboard_init_data_2)
	end

	self._blackboard = var_1_7

	if not breed.hit_zones_lookup then
		DamageUtils.create_hit_zone_lookup(arg_1_2, breed)
	end

	if not breed.special_on_spawn_stinger then
		WwiseUtils.trigger_unit_event(self._world, breed.special_on_spawn_stinger, arg_1_2, 0)
	end

	local behavior

	if not optional_spawn_data then
		behavior = optional_spawn_data.behavior

		if not behavior then
			-- Nothing
		end
	end

	if not flag then
		behavior = breed.horde_behavior

		if not behavior then
			-- Nothing
		end
	end

	behavior = breed.behavior

	::label_1_0::

	self:_init_brain(behavior, flag)
	self:_set_size_variation(arg_1_3.size_variation, arg_1_3.size_variation_normalized)

	self.attributes = nil
end

AISimpleExtension.unit_removed_from_game = function (self)
	-- function 2
	Managers.state.side:remove_unit_from_side(self._unit)

	self._side_id = nil
end

AISimpleExtension.destroy = function (self)
	-- function 3
	local _blackboard = self._blackboard

	AiUtils.special_dead_cleanup(self._unit, self._blackboard)
	self._brain:destroy()
end

local STATIC_BLACKBOARD_KEYS = STATIC_BLACKBOARD_KEYS

STATIC_BLACKBOARD_KEYS = STATIC_BLACKBOARD_KEYS or {
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

AISimpleExtension.unfreeze = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _blackboard = self._blackboard

	for k, v in pairs(_blackboard) do
		if not STATIC_BLACKBOARD_KEYS[k] then
			_blackboard[k] = nil
		end
	end

	local var_5_1 = arg_5_2[4]
	local var_5_2 = arg_5_2[6]
	local var_5_3 = arg_5_2[7]
	local side_id = var_5_3.side_id

	self._side_id = side_id

	fassert(side_id ~= nil, "no side_id")

	local add_unit_to_side = Managers.state.side:add_unit_to_side(self._unit, side_id)

	table.clear(_blackboard.node_data)
	table.clear(_blackboard.running_nodes)
	table.clear(_blackboard.override_targets)

	if not self.attributes then
		table.clear(self.attributes)
	end

	_blackboard.target_dist = math.huge
	_blackboard.spawn_type = var_5_2
	_blackboard.spawn_category = var_5_1
	_blackboard.buff_extension = ScriptUnit.has_extension(arg_5_1, "buff_system")
	_blackboard.stuck_check_time = Managers.time:time("game") + RecycleSettings.ai_stuck_check_start_time
	_blackboard.is_in_attack_cooldown = false
	_blackboard.attack_cooldown_at = 0
	_blackboard.stagger_count = 0
	_blackboard.stagger_count_reset_at = 0
	_blackboard.optional_spawn_data = var_5_3
	_blackboard.side = add_unit_to_side

	local breed = _blackboard.breed

	_blackboard.lean_dogpile = 0
	_blackboard.crowded_slots = breed.infighting.crowded_slots

	table.clear(_blackboard.lean_unit_list)

	_blackboard.next_lean_index = 0

	local flag = var_5_2 == "horde_hidden" or var_5_2 == "horde"
	local behavior

	if not var_5_3 then
		behavior = var_5_3.behavior

		if not behavior then
			-- Nothing
		end
	end

	if not flag then
		behavior = breed.horde_behavior

		if not behavior then
			-- Nothing
		end
	end

	behavior = breed.behavior

	::label_5_0::

	self._brain:unfreeze(_blackboard, behavior)
	self:init_perception(breed, flag)

	if breed.far_off_despawn_immunity or not var_5_3 or not var_5_3.far_off_despawn_immunity then
		_blackboard.far_off_despawn_immunity = true
	end

	if not breed.run_on_spawn then
		breed.run_on_spawn(arg_5_1, _blackboard)
	end

	Managers.state.game_mode:ai_spawned(arg_5_1)
end

AISimpleExtension.extensions_ready = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _blackboard = self._blackboard
	local _side_id = self._side_id
	local add_unit_to_side = Managers.state.side:add_unit_to_side(arg_6_2, _side_id)

	_blackboard.side = add_unit_to_side

	local _breed = self._breed
	local spawn_type = _blackboard.spawn_type
	local flag = spawn_type == "horde_hidden" or spawn_type == "horde"

	self:init_perception(_breed, flag)

	if not self._health_extension then
		self.broadphase_id = Broadphase.add(_blackboard.group_blackboard.broadphase, arg_6_2, Unit.local_position(arg_6_2, 0), 1, add_unit_to_side.broadphase_category)
	end

	local optional_spawn_data = _blackboard.optional_spawn_data

	if _breed.far_off_despawn_immunity or not optional_spawn_data or not optional_spawn_data.far_off_despawn_immunity then
		_blackboard.far_off_despawn_immunity = true
	end

	if not _breed.run_on_spawn then
		_breed.run_on_spawn(arg_6_2, _blackboard)
	end

	Managers.state.game_mode:ai_spawned(arg_6_2)
	Unit.flow_event(arg_6_2, "lua_trigger_variation")

	local climate_type = LevelSettings[Managers.state.game_mode:level_key()].climate_type

	climate_type = climate_type or "default"

	Unit.set_flow_variable(arg_6_2, "climate_type", climate_type)
	Unit.flow_event(arg_6_2, "climate_type_set")
end

AISimpleExtension.get_overlap_context = function (self)
	-- function 7
	if not self._overlap_context then
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

AISimpleExtension.set_properties = function (self, arg_8_1)
	-- function 8
	for k, v in pairs(arg_8_1) do
		local match, var_8_1 = v:match("(%S+) (%S+)")
		local var_8_2 = type(self._breed.properties[match])

		if var_8_2 == "table" then
			var_8_1 = AIProperties

			local gmatch = v:gmatch("(%S+)")

			gmatch()

			for k_2 = 1, 10 do
				local var_8_4 = gmatch()

				if var_8_4 == nil then
					break
				end

				fassert(var_8_1[var_8_4], "Table index %q not found in AIProperties", var_8_4)

				var_8_1 = var_8_1[var_8_4]
			end
		elseif var_8_2 == "number" then
			var_8_1 = tonumber(var_8_1)
		elseif var_8_2 == "boolean" then
			var_8_1 = to_boolean(var_8_1)
		end

		self._breed.properties[match] = var_8_1
	end
end

AISimpleExtension._parse_properties = function (self)
	-- function 9
	for k, v in pairs(self._breed.properties) do
		if type(v) == "table" then
			for k_2, v_2 in pairs(v) do
				self._breed.properties[k_2] = v_2
			end
		end
	end
end

AISimpleExtension.init_perception = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not arg_10_1.perception then
		local horde_perception

		if not arg_10_2 then
			horde_perception = arg_10_1.horde_perception

			if not horde_perception then
				-- Nothing
			end
		end

		horde_perception = arg_10_1.perception

		::label_10_0::

		self._perception_func_name = horde_perception
	else
		self._perception_func_name = "perception_regular"
	end

	if not arg_10_1.target_selection then
		local horde_target_selection

		if not arg_10_2 then
			horde_target_selection = arg_10_1.horde_target_selection

			if not horde_target_selection then
				-- Nothing
			end
		end

		horde_target_selection = arg_10_1.target_selection

		::label_10_1::

		self._target_selection_func_name = horde_target_selection
	else
		self._target_selection_func_name = "pick_closest_target_with_spillover"
	end
end

AISimpleExtension.set_perception = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not arg_11_1 then
		self._perception_func_name = arg_11_1
	else
		self._perception_func_name = "perception_regular"
	end

	if not arg_11_2 then
		self._target_selection_func_name = arg_11_2
	else
		self._target_selection_func_name = "pick_closest_target_with_spillover"
	end
end

AISimpleExtension._init_brain = function (self, arg_12_1, arg_12_2)
	-- function 12
	self._brain = AIBrain:new(self._world, self._unit, self._blackboard, self._breed, arg_12_1)
end

AISimpleExtension._set_size_variation = function (self, arg_13_1, arg_13_2)
	-- function 13
	self._size_variation = arg_13_1 or 1
	self._size_variation_normalized = arg_13_2 or 1
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

AISimpleExtension.force_enemy_detection = function (self, arg_20_1)
	-- function 20
	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[self._unit].ENEMY_PLAYER_AND_BOT_UNITS
	local count = #ENEMY_PLAYER_AND_BOT_UNITS

	if count == 0 then
		return
	end

	local var_20_2 = ENEMY_PLAYER_AND_BOT_UNITS[Math.random(1, count)]

	if not var_20_2 then
		self:enemy_aggro(self._unit, var_20_2)
	end
end

AISimpleExtension.current_action_name = function (self)
	-- function 21
	local _blackboard = self._blackboard
	local name

	if not _blackboard.action then
		name = _blackboard.action.name

		if not name then
			-- Nothing
		end
	end

	name = "n/a"

	::label_21_0::

	return name
end

AISimpleExtension.die = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _blackboard = self._blackboard
	local _unit = self._unit

	self._brain:exit_last_action()

	if not self._blackboard.group_blackboard then
		AiUtils.special_dead_cleanup(_unit, _blackboard)
	end

	Managers.state.conflict:register_unit_killed(_unit, _blackboard, arg_22_1, arg_22_2)
end

AISimpleExtension.attacked = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local _unit = self._unit
	local _blackboard = self._blackboard
	local side = _blackboard.side

	arg_23_1 = AiUtils.get_actual_attacker_unit(arg_23_1)

	if not side.enemy_units_lookup[arg_23_1] then
		if not (not arg_23_3 and not _blackboard.confirmed_player_sighting and _blackboard.target_unit ~= nil) then
			_blackboard.target_unit = arg_23_1
			_blackboard.target_unit_found_time = arg_23_2

			AiUtils.alert_nearby_friends_of_enemy(_unit, _blackboard.group_blackboard.broadphase, arg_23_1)
		end

		_blackboard.previous_attacker = arg_23_1

		if arg_23_3 or _blackboard.stagger ~= 1 or not HEALTH_ALIVE[_unit] then
			StatisticsUtil.check_save(arg_23_1, _unit)
		end
	end
end

AISimpleExtension.enemy_aggro = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _blackboard = self._blackboard

	if _blackboard.confirmed_player_sighting or not _blackboard.only_trust_your_own_eyes then
		return
	end

	local _unit = self._unit

	if not not Managers.state.side:is_enemy(_unit, arg_24_2) then
		return
	end

	_blackboard.delayed_target_unit = arg_24_2

	AiUtils.activate_unit(_blackboard)

	_blackboard.no_hesitation = true

	local has_extension = ScriptUnit.has_extension(_unit, "ai_slot_system")

	if not has_extension then
		has_extension.do_search = true
	end

	if not ScriptUnit.has_extension(_unit, "ai_inventory_system") then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(_unit)

		network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, 1)
	end
end

AISimpleExtension.enemy_alert = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _blackboard = self._blackboard
	local run_on_alerted = self._breed.run_on_alerted

	if not run_on_alerted then
		run_on_alerted(self._unit, self._blackboard, arg_25_1, arg_25_2)
	end

	if _blackboard.confirmed_player_sighting or not _blackboard.only_trust_your_own_eyes then
		return
	end

	if _blackboard.hesitating or not _blackboard.in_alerted_state or not _blackboard.alerted_deadline_reached then
		self:enemy_aggro(arg_25_1, arg_25_2)
	end

	if not not Managers.state.side:is_enemy(self._unit, arg_25_2) then
		return
	end

	self._blackboard.delayed_target_unit = arg_25_2
end

local num = 10

AISimpleExtension.increase_stagger_count = function (self)
	-- function 26
	local _blackboard = self._blackboard
	local _breed = self._breed
	local stagger_count = _blackboard.stagger_count
	local stagger_count_reset_time = _breed.stagger_count_reset_time

	stagger_count_reset_time = stagger_count_reset_time or num

	local time = Managers.time:time("main")

	_blackboard.stagger_count = stagger_count + 1
	_blackboard.stagger_count_reset_at = time + stagger_count_reset_time
end

AISimpleExtension.reset_stagger_count = function (self)
	-- function 27
	local _blackboard = self._blackboard

	_blackboard.stagger_count_reset_at = 0
	_blackboard.stagger_count = 0
end

AISimpleExtension.update_stagger_count = function (self)
	-- function 28
	local _blackboard = self._blackboard

	if not (not (_blackboard.stagger_count_reset_at < Managers.time:time("main")) or not (_blackboard.stagger_count > 0)) then
		_blackboard.stagger_count = 0
	end
end
