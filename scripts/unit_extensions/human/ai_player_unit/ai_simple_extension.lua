-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_simple_extension.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension_c")
require("scripts/unit_extensions/human/ai_player_unit/ai_husk_locomotion_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_navigation_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_brain")
require("scripts/unit_extensions/human/ai_player_unit/perception_utils")
require("scripts/unit_extensions/human/ai_player_unit/target_selection_utils")

local var_0_0 = Unit.alive

AISimpleExtension = class(AISimpleExtension)

AISimpleExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2
	arg_1_0._nav_world = arg_1_3.nav_world

	local var_1_0 = Managers.state.entity:system("ai_system")
	local var_1_1 = arg_1_3.spawn_type
	local var_1_2 = var_1_1 == "horde_hidden" or var_1_1 == "horde"
	local var_1_3 = arg_1_3.breed

	Unit.set_data(arg_1_2, "breed", var_1_3)

	arg_1_0._breed = var_1_3

	fassert(arg_1_3.side_id, "no side_id")

	arg_1_0._side_id = arg_1_3.side_id

	local var_1_4 = var_1_3.initial_is_passive == nil and true or var_1_3.initial_is_passive
	local var_1_5 = Script.new_map(var_1_3.blackboard_allocation_size or 75)
	local var_1_6 = arg_1_3.optional_spawn_data

	var_1_5.world = arg_1_1.world
	var_1_5.unit = arg_1_2
	var_1_5.level = LevelHelper:current_level(arg_1_1.world)
	var_1_5.nav_world = arg_1_0._nav_world
	var_1_5.node_data = {}
	var_1_5.running_nodes = {}
	var_1_5.is_passive = var_1_4
	var_1_5.system_api = arg_1_1.system_api
	var_1_5.group_blackboard = var_1_0.group_blackboard
	var_1_5.target_dist = math.huge
	var_1_5.spawn_type = var_1_1
	var_1_5.stuck_check_time = Managers.time:time("game") + RecycleSettings.ai_stuck_check_start_time
	var_1_5.is_in_attack_cooldown = false
	var_1_5.attack_cooldown_at = 0
	var_1_5.stagger_count = 0
	var_1_5.stagger_count_reset_at = 0
	var_1_5.override_targets = {}
	var_1_5.optional_spawn_data = var_1_6
	var_1_5.spawn_category = arg_1_3.spawn_category
	var_1_5.is_ai = true
	var_1_5.lean_unit_list = {}
	var_1_5.next_lean_index = 0

	local var_1_7 = var_1_3.blackboard_init_data

	if var_1_7 and var_1_7.player_locomotion_constrain_radius ~= nil then
		arg_1_0.player_locomotion_constrain_radius = var_1_7.player_locomotion_constrain_radius or nil
	else
		arg_1_0.player_locomotion_constrain_radius = var_1_3.player_locomotion_constrain_radius or nil
	end

	var_1_5.lean_dogpile = 0
	var_1_5.crowded_slots = var_1_3.infighting.crowded_slots
	arg_1_0._health_extension = ScriptUnit.has_extension(arg_1_2, "health_system")

	local var_1_8 = ScriptUnit.has_extension(arg_1_2, "locomotion_system")

	arg_1_0._locomotion = var_1_8
	var_1_5.locomotion_extension = var_1_8

	local var_1_9 = ScriptUnit.has_extension(arg_1_2, "ai_navigation_system")

	arg_1_0._navigation = var_1_9
	var_1_5.navigation_extension = var_1_9
	var_1_5.buff_extension = ScriptUnit.has_extension(arg_1_2, "buff_system")
	var_1_5.health_extension = ScriptUnit.has_extension(arg_1_2, "health_system")

	local var_1_10 = var_1_3.blackboard_init_data

	if var_1_10 then
		table.merge(var_1_5, var_1_10)
	end

	arg_1_0._blackboard = var_1_5

	if not var_1_3.hit_zones_lookup then
		DamageUtils.create_hit_zone_lookup(arg_1_2, var_1_3)
	end

	if var_1_3.special_on_spawn_stinger then
		WwiseUtils.trigger_unit_event(arg_1_0._world, var_1_3.special_on_spawn_stinger, arg_1_2, 0)
	end

	local var_1_11 = var_1_6 and var_1_6.behavior or var_1_2 and var_1_3.horde_behavior or var_1_3.behavior

	arg_1_0:_init_brain(var_1_11, var_1_2)
	arg_1_0:_set_size_variation(arg_1_3.size_variation, arg_1_3.size_variation_normalized)

	arg_1_0.attributes = nil
end

AISimpleExtension.unit_removed_from_game = function (arg_2_0)
	Managers.state.side:remove_unit_from_side(arg_2_0._unit)

	arg_2_0._side_id = nil
end

AISimpleExtension.destroy = function (arg_3_0)
	local var_3_0 = arg_3_0._blackboard

	AiUtils.special_dead_cleanup(arg_3_0._unit, arg_3_0._blackboard)
	arg_3_0._brain:destroy()
end

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

AISimpleExtension.freeze = function (arg_4_0)
	arg_4_0._brain:exit_last_action()

	arg_4_0._side_id = nil
end

AISimpleExtension.unfreeze = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._blackboard

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if not STATIC_BLACKBOARD_KEYS[iter_5_0] then
			var_5_0[iter_5_0] = nil
		end
	end

	local var_5_1 = arg_5_2[4]
	local var_5_2 = arg_5_2[6]
	local var_5_3 = arg_5_2[7]
	local var_5_4 = var_5_3.side_id

	arg_5_0._side_id = var_5_4

	fassert(var_5_4 ~= nil, "no side_id")

	local var_5_5 = Managers.state.side:add_unit_to_side(arg_5_0._unit, var_5_4)

	table.clear(var_5_0.node_data)
	table.clear(var_5_0.running_nodes)
	table.clear(var_5_0.override_targets)

	if arg_5_0.attributes then
		table.clear(arg_5_0.attributes)
	end

	var_5_0.target_dist = math.huge
	var_5_0.spawn_type = var_5_2
	var_5_0.spawn_category = var_5_1
	var_5_0.buff_extension = ScriptUnit.has_extension(arg_5_1, "buff_system")
	var_5_0.stuck_check_time = Managers.time:time("game") + RecycleSettings.ai_stuck_check_start_time
	var_5_0.is_in_attack_cooldown = false
	var_5_0.attack_cooldown_at = 0
	var_5_0.stagger_count = 0
	var_5_0.stagger_count_reset_at = 0
	var_5_0.optional_spawn_data = var_5_3
	var_5_0.side = var_5_5

	local var_5_6 = var_5_0.breed

	var_5_0.lean_dogpile = 0
	var_5_0.crowded_slots = var_5_6.infighting.crowded_slots

	table.clear(var_5_0.lean_unit_list)

	var_5_0.next_lean_index = 0

	local var_5_7 = var_5_2 == "horde_hidden" or var_5_2 == "horde"
	local var_5_8 = var_5_3 and var_5_3.behavior or var_5_7 and var_5_6.horde_behavior or var_5_6.behavior

	arg_5_0._brain:unfreeze(var_5_0, var_5_8)
	arg_5_0:init_perception(var_5_6, var_5_7)

	if var_5_6.far_off_despawn_immunity or var_5_3 and var_5_3.far_off_despawn_immunity then
		var_5_0.far_off_despawn_immunity = true
	end

	if var_5_6.run_on_spawn then
		var_5_6.run_on_spawn(arg_5_1, var_5_0)
	end

	Managers.state.game_mode:ai_spawned(arg_5_1)
end

AISimpleExtension.extensions_ready = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._blackboard
	local var_6_1 = arg_6_0._side_id
	local var_6_2 = Managers.state.side:add_unit_to_side(arg_6_2, var_6_1)

	var_6_0.side = var_6_2

	local var_6_3 = arg_6_0._breed
	local var_6_4 = var_6_0.spawn_type
	local var_6_5 = var_6_4 == "horde_hidden" or var_6_4 == "horde"

	arg_6_0:init_perception(var_6_3, var_6_5)

	if arg_6_0._health_extension then
		arg_6_0.broadphase_id = Broadphase.add(var_6_0.group_blackboard.broadphase, arg_6_2, Unit.local_position(arg_6_2, 0), 1, var_6_2.broadphase_category)
	end

	local var_6_6 = var_6_0.optional_spawn_data

	if var_6_3.far_off_despawn_immunity or var_6_6 and var_6_6.far_off_despawn_immunity then
		var_6_0.far_off_despawn_immunity = true
	end

	if var_6_3.run_on_spawn then
		var_6_3.run_on_spawn(arg_6_2, var_6_0)
	end

	Managers.state.game_mode:ai_spawned(arg_6_2)
	Unit.flow_event(arg_6_2, "lua_trigger_variation")

	local var_6_7 = LevelSettings[Managers.state.game_mode:level_key()].climate_type or "default"

	Unit.set_flow_variable(arg_6_2, "climate_type", var_6_7)
	Unit.flow_event(arg_6_2, "climate_type_set")
end

AISimpleExtension.get_overlap_context = function (arg_7_0)
	if arg_7_0._overlap_context then
		arg_7_0._overlap_context.num_hits = 0
	else
		arg_7_0._overlap_context = {
			has_gotten_callback = false,
			spine_node = false,
			num_hits = 0,
			overlap_units = {}
		}

		GarbageLeakDetector.register_object(arg_7_0._overlap_context, "ai_overlap_context")
	end

	return arg_7_0._overlap_context
end

AISimpleExtension.set_properties = function (arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		local var_8_0, var_8_1 = iter_8_1:match("(%S+) (%S+)")
		local var_8_2 = type(arg_8_0._breed.properties[var_8_0])

		if var_8_2 == "table" then
			var_8_1 = AIProperties

			local var_8_3 = iter_8_1:gmatch("(%S+)")

			var_8_3()

			for iter_8_2 = 1, 10 do
				local var_8_4 = var_8_3()

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

		arg_8_0._breed.properties[var_8_0] = var_8_1
	end
end

AISimpleExtension._parse_properties = function (arg_9_0)
	for iter_9_0, iter_9_1 in pairs(arg_9_0._breed.properties) do
		if type(iter_9_1) == "table" then
			for iter_9_2, iter_9_3 in pairs(iter_9_1) do
				arg_9_0._breed.properties[iter_9_2] = iter_9_3
			end
		end
	end
end

AISimpleExtension.init_perception = function (arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1.perception then
		arg_10_0._perception_func_name = arg_10_2 and arg_10_1.horde_perception or arg_10_1.perception
	else
		arg_10_0._perception_func_name = "perception_regular"
	end

	if arg_10_1.target_selection then
		arg_10_0._target_selection_func_name = arg_10_2 and arg_10_1.horde_target_selection or arg_10_1.target_selection
	else
		arg_10_0._target_selection_func_name = "pick_closest_target_with_spillover"
	end
end

AISimpleExtension.set_perception = function (arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 then
		arg_11_0._perception_func_name = arg_11_1
	else
		arg_11_0._perception_func_name = "perception_regular"
	end

	if arg_11_2 then
		arg_11_0._target_selection_func_name = arg_11_2
	else
		arg_11_0._target_selection_func_name = "pick_closest_target_with_spillover"
	end
end

AISimpleExtension._init_brain = function (arg_12_0, arg_12_1, arg_12_2)
	arg_12_0._brain = AIBrain:new(arg_12_0._world, arg_12_0._unit, arg_12_0._blackboard, arg_12_0._breed, arg_12_1)
end

AISimpleExtension._set_size_variation = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._size_variation = arg_13_1 or 1
	arg_13_0._size_variation_normalized = arg_13_2 or 1
end

AISimpleExtension.locomotion = function (arg_14_0)
	return arg_14_0._locomotion
end

AISimpleExtension.navigation = function (arg_15_0)
	return arg_15_0._navigation
end

AISimpleExtension.brain = function (arg_16_0)
	return arg_16_0._brain
end

AISimpleExtension.breed = function (arg_17_0)
	return arg_17_0._breed
end

AISimpleExtension.blackboard = function (arg_18_0)
	return arg_18_0._blackboard
end

AISimpleExtension.size_variation = function (arg_19_0)
	return arg_19_0._size_variation, arg_19_0._size_variation_normalized
end

AISimpleExtension.force_enemy_detection = function (arg_20_0, arg_20_1)
	local var_20_0 = Managers.state.side.side_by_unit[arg_20_0._unit].ENEMY_PLAYER_AND_BOT_UNITS
	local var_20_1 = #var_20_0

	if var_20_1 == 0 then
		return
	end

	local var_20_2 = var_20_0[Math.random(1, var_20_1)]

	if var_20_2 then
		arg_20_0:enemy_aggro(arg_20_0._unit, var_20_2)
	end
end

AISimpleExtension.current_action_name = function (arg_21_0)
	local var_21_0 = arg_21_0._blackboard

	return var_21_0.action and var_21_0.action.name or "n/a"
end

AISimpleExtension.die = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._blackboard
	local var_22_1 = arg_22_0._unit

	arg_22_0._brain:exit_last_action()

	if arg_22_0._blackboard.group_blackboard then
		AiUtils.special_dead_cleanup(var_22_1, var_22_0)
	end

	Managers.state.conflict:register_unit_killed(var_22_1, var_22_0, arg_22_1, arg_22_2)
end

AISimpleExtension.attacked = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0._unit
	local var_23_1 = arg_23_0._blackboard
	local var_23_2 = var_23_1.side

	arg_23_1 = AiUtils.get_actual_attacker_unit(arg_23_1)

	if var_23_2.enemy_units_lookup[arg_23_1] then
		if arg_23_3 and var_23_1.confirmed_player_sighting and var_23_1.target_unit == nil then
			var_23_1.target_unit = arg_23_1
			var_23_1.target_unit_found_time = arg_23_2

			AiUtils.alert_nearby_friends_of_enemy(var_23_0, var_23_1.group_blackboard.broadphase, arg_23_1)
		end

		var_23_1.previous_attacker = arg_23_1

		if not arg_23_3 and var_23_1.stagger == 1 and HEALTH_ALIVE[var_23_0] then
			StatisticsUtil.check_save(arg_23_1, var_23_0)
		end
	end
end

AISimpleExtension.enemy_aggro = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._blackboard

	if var_24_0.confirmed_player_sighting or var_24_0.only_trust_your_own_eyes then
		return
	end

	local var_24_1 = arg_24_0._unit

	if not Managers.state.side:is_enemy(var_24_1, arg_24_2) then
		return
	end

	var_24_0.delayed_target_unit = arg_24_2

	AiUtils.activate_unit(var_24_0)

	var_24_0.no_hesitation = true

	local var_24_2 = ScriptUnit.has_extension(var_24_1, "ai_slot_system")

	if var_24_2 then
		var_24_2.do_search = true
	end

	if ScriptUnit.has_extension(var_24_1, "ai_inventory_system") then
		local var_24_3 = Managers.state.network
		local var_24_4 = var_24_3:unit_game_object_id(var_24_1)

		var_24_3.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_24_4, 1)
	end
end

AISimpleExtension.enemy_alert = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._blackboard
	local var_25_1 = arg_25_0._breed.run_on_alerted

	if var_25_1 then
		var_25_1(arg_25_0._unit, arg_25_0._blackboard, arg_25_1, arg_25_2)
	end

	if var_25_0.confirmed_player_sighting or var_25_0.only_trust_your_own_eyes then
		return
	end

	if var_25_0.hesitating or var_25_0.in_alerted_state and var_25_0.alerted_deadline_reached then
		arg_25_0:enemy_aggro(arg_25_1, arg_25_2)
	end

	if not Managers.state.side:is_enemy(arg_25_0._unit, arg_25_2) then
		return
	end

	arg_25_0._blackboard.delayed_target_unit = arg_25_2
end

local var_0_1 = 10

AISimpleExtension.increase_stagger_count = function (arg_26_0)
	local var_26_0 = arg_26_0._blackboard
	local var_26_1 = arg_26_0._breed
	local var_26_2 = var_26_0.stagger_count
	local var_26_3 = var_26_1.stagger_count_reset_time or var_0_1
	local var_26_4 = Managers.time:time("main")

	var_26_0.stagger_count = var_26_2 + 1
	var_26_0.stagger_count_reset_at = var_26_4 + var_26_3
end

AISimpleExtension.reset_stagger_count = function (arg_27_0)
	local var_27_0 = arg_27_0._blackboard

	var_27_0.stagger_count_reset_at = 0
	var_27_0.stagger_count = 0
end

AISimpleExtension.update_stagger_count = function (arg_28_0)
	local var_28_0 = arg_28_0._blackboard

	if var_28_0.stagger_count_reset_at < Managers.time:time("main") and var_28_0.stagger_count > 0 then
		var_28_0.stagger_count = 0
	end
end
