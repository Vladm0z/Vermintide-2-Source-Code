-- chunkname: @scripts/unit_extensions/human/ai_player_unit/perception_utils.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_utils")

PerceptionUtils = {}

local HEALTH_ALIVE = HEALTH_ALIVE
local unit_knocked_down = AiUtils.unit_knocked_down
local POSITION_LOOKUP = POSITION_LOOKUP
local AI_UTILS = AI_UTILS
local extension = ScriptUnit.extension

PerceptionUtils.troll_crouch_check = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local get_data = World.get_data(arg_1_1.world, "physics_world")
	local num = 1.2
	local local_position = Unit.local_position(arg_1_0, 0)
	local normalize = Vector3.normalize(Quaternion.forward(Unit.world_rotation(arg_1_0, 0)))
	local num_2 = local_position + Vector3(0, 0, 2)
	local num_3 = num_2 + normalize
	local immediate_raycast, var_1_7 = PhysicsWorld.immediate_raycast(get_data, num_3, Vector3(0, 0, 1), num, "closest", "collision_filter", "filter_ai_mover")
	local immediate_raycast_2, var_1_9 = PhysicsWorld.immediate_raycast(get_data, num_2, Vector3(0, 0, 1), num, "closest", "collision_filter", "filter_ai_mover")

	if not (not immediate_raycast and var_1_7 and not immediate_raycast_2 or var_1_9) then
		arg_1_1.crouch_sticky_timer = arg_1_2 + 1
	end

	arg_1_1.needs_to_crouch = arg_1_2 < arg_1_1.crouch_sticky_timer
end

PerceptionUtils.perception_continuous_chaos_troll = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	AiUtils.push_intersecting_players(arg_2_0, arg_2_0, arg_2_1.displaced_units, arg_2_2.displace_players_data, arg_2_3, arg_2_4)
	PerceptionUtils.troll_crouch_check(arg_2_0, arg_2_1, arg_2_3)
	AiUtils.update_aggro(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	return true
end

PerceptionUtils.perception_continuous_chaos_spawn = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	AiUtils.update_aggro(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_1.grabbed_time = arg_3_1.grabbed_time + arg_3_4

	return true
end

PerceptionUtils.perception_continuous_rat_ogre = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	AiUtils.update_aggro(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	return true
end

PerceptionUtils.perception_continuous_keep_target = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local target_unit = arg_5_1.target_unit
	local side = arg_5_1.side
	local is_player_unit

	if not HEALTH_ALIVE[target_unit] then
		is_player_unit = DamageUtils.is_player_unit(target_unit)

		if not is_player_unit then
			is_player_unit = not side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[target_unit]
		end

		if false then
			is_player_unit = false
		end
	else
		is_player_unit = true
	end

	return is_player_unit
end

PerceptionUtils.perception_no_seeing = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	return
end

PerceptionUtils.perception_all_seeing = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local target_unit = arg_7_1.target_unit
	local var_7_1, var_7_2 = arg_7_3(arg_7_0, arg_7_1, arg_7_2)

	if not var_7_1 then
		if var_7_1 ~= target_unit then
			if not arg_7_2.special then
				local special_targets = arg_7_1.group_blackboard.special_targets

				if not target_unit then
					special_targets[target_unit] = nil
				end

				special_targets[var_7_1] = arg_7_0
			end

			arg_7_1.previous_target_unit = arg_7_1.target_unit
			arg_7_1.target_unit = var_7_1
			arg_7_1.target_unit_found_time = arg_7_4
			arg_7_1.is_passive = false
		end

		arg_7_1.target_dist = var_7_2
	else
		if not arg_7_2.special and not target_unit then
			arg_7_1.group_blackboard.special_targets[target_unit] = nil
		end

		arg_7_1.previous_target_unit = arg_7_1.target_unit
		arg_7_1.target_unit = nil
		arg_7_1.target_dist = math.huge
	end
end

PerceptionUtils.perception_all_seeing_boss = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	PerceptionUtils.perception_all_seeing(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)

	if arg_8_1.aggro_unit ~= arg_8_1.target_unit then
		local aggro_unit = arg_8_1.aggro_unit
		local target_unit = arg_8_1.target_unit

		arg_8_1.aggro_unit = target_unit

		if not arg_8_2.trigger_dialogue_on_target_switch and not target_unit then
			local extension_input = ScriptUnit.extension_input(arg_8_0, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()
			local dialogue_target_switch_attack_tag = arg_8_2.dialogue_target_switch_attack_tag

			dialogue_target_switch_attack_tag = dialogue_target_switch_attack_tag or "enemy_target_changed"
			alloc_table.attack_tag = dialogue_target_switch_attack_tag
			alloc_table.target_name = ScriptUnit.extension(target_unit, "dialogue_system").context.player_profile

			local var_8_5 = extension_input
			local trigger_networked_dialogue_event = extension_input.trigger_networked_dialogue_event
			local dialogue_target_switch_event = arg_8_2.dialogue_target_switch_event

			dialogue_target_switch_event = dialogue_target_switch_event or "enemy_target_changed"

			trigger_networked_dialogue_event(var_8_5, dialogue_target_switch_event, alloc_table)
		end

		local system = Managers.state.entity:system("sound_effect_system")

		system:aggro_unit_changed(aggro_unit, arg_8_0, false)
		system:aggro_unit_changed(target_unit, arg_8_0, true)
	end
end

PerceptionUtils.perception_standard_bearer = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if arg_9_1.spawn_category == "patrol" then
		local has_extension = ScriptUnit.has_extension(arg_9_0, "ai_group_system")

		if not has_extension and not has_extension.in_patrol then
			return
		end
	end

	local target_unit = arg_9_1.target_unit
	local var_9_2, var_9_3 = arg_9_3(arg_9_0, arg_9_1, arg_9_2)

	if not (not var_9_2 and var_9_2 == target_unit) then
		local special_targets = arg_9_1.group_blackboard.special_targets

		if not target_unit then
			special_targets[target_unit] = nil
		end

		special_targets[var_9_2] = arg_9_0
		arg_9_1.previous_target_unit = arg_9_1.target_unit
		arg_9_1.target_unit = var_9_2
		arg_9_1.target_unit_found_time = arg_9_4
		arg_9_1.target_dist = var_9_3
		arg_9_1.is_passive = false
	elseif not var_9_2 then
		arg_9_1.target_dist = var_9_3
	else
		if not target_unit then
			arg_9_1.group_blackboard.special_targets[target_unit] = nil
		end

		arg_9_1.previous_target_unit = arg_9_1.target_unit
		arg_9_1.target_unit = nil
		arg_9_1.target_dist = math.huge
	end
end

PerceptionUtils.perception_tether_sorcerer = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local var_10_0, var_10_1 = arg_10_3(arg_10_0, arg_10_1, arg_10_2)

	if var_10_0 ~= arg_10_1.target_unit then
		arg_10_1.target_unit = var_10_0
		arg_10_1.target_unit_found_time = arg_10_4
		arg_10_1.target_dist = var_10_1
	end
end

PerceptionUtils.perception_pack_master = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	if not arg_11_1.drag_target_unit then
		return
	end

	local target_unit = arg_11_1.target_unit
	local var_11_1, var_11_2 = arg_11_3(arg_11_0, arg_11_1, arg_11_2)

	if not (not var_11_1 and var_11_1 == target_unit) then
		local special_targets = arg_11_1.group_blackboard.special_targets

		if not target_unit then
			special_targets[target_unit] = nil
		end

		special_targets[var_11_1] = arg_11_0
		arg_11_1.previous_target_unit = arg_11_1.target_unit
		arg_11_1.target_unit = var_11_1
		arg_11_1.target_unit_found_time = arg_11_4
		arg_11_1.target_dist = var_11_2
		arg_11_1.is_passive = false
	elseif not var_11_1 then
		arg_11_1.target_dist = var_11_2
	else
		if not target_unit then
			arg_11_1.group_blackboard.special_targets[target_unit] = nil
		end

		arg_11_1.previous_target_unit = arg_11_1.target_unit
		arg_11_1.target_unit = nil
		arg_11_1.target_dist = math.huge
	end
end

PerceptionUtils.perception_rat_ogre = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	if not arg_12_1.keep_target then
		return
	end

	PerceptionUtils.perception_all_seeing_re_evaluate(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)

	local target_unit = arg_12_1.target_unit

	if not ALIVE[target_unit] then
		local has_extension = ScriptUnit.has_extension(target_unit, "status_system")

		if not has_extension then
			arg_12_1.target_is_not_downed = not not has_extension.is_ledge_hanging or not has_extension.knocked_down

			local var_12_2 = POSITION_LOOKUP[arg_12_0]
			local num = POSITION_LOOKUP[target_unit] - var_12_2
			local x = num.x
			local y = num.y

			arg_12_1.target_height_distance, arg_12_1.target_flat_distance = num.z, math.sqrt(x * x + y * y)

			local get_is_on_ladder, var_12_7 = has_extension:get_is_on_ladder()

			if not get_is_on_ladder then
				local ladder_extents, var_12_9 = ScriptUnit.extension(var_12_7, "ladder_system"):ladder_extents()

				arg_12_1.target_on_ladder = var_12_7

				local num_2 = var_12_2 - ladder_extents
				local num_3 = var_12_9 - ladder_extents
				local normalize = Vector3.normalize(num_3)
				local dot = Vector3.dot(num_2, normalize)

				if dot < 0 then
					arg_12_1.ladder_distance = Vector3.length(num_2)
				elseif dot > Vector3.length(num_3) then
					arg_12_1.ladder_distance = Vector3.length(var_12_2 - var_12_9)
				else
					arg_12_1.ladder_distance = Vector3.length(num_2 - normalize * dot)
				end
			else
				arg_12_1.ladder_distance = math.huge
			end
		else
			arg_12_1.target_is_not_downed = true
		end
	end

	if arg_12_1.aggro_unit ~= target_unit then
		local aggro_unit = arg_12_1.aggro_unit
		local var_12_15 = target_unit

		arg_12_1.aggro_unit = var_12_15

		local var_12_16 = arg_12_1.aggro_list[aggro_unit]

		if not var_12_16 then
			arg_12_1.aggro_list[aggro_unit] = var_12_16 * arg_12_2.perception_weights.old_target_aggro_mul
		end

		if not arg_12_2.trigger_dialogue_on_target_switch and not var_12_15 then
			local extension_input = ScriptUnit.extension_input(arg_12_0, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()
			local dialogue_target_switch_attack_tag = arg_12_2.dialogue_target_switch_attack_tag

			dialogue_target_switch_attack_tag = dialogue_target_switch_attack_tag or "rat_ogre_change_target"
			alloc_table.attack_tag = dialogue_target_switch_attack_tag
			alloc_table.target_name = ScriptUnit.extension(var_12_15, "dialogue_system").context.player_profile

			local var_12_20 = extension_input
			local trigger_networked_dialogue_event = extension_input.trigger_networked_dialogue_event
			local dialogue_target_switch_event = arg_12_2.dialogue_target_switch_event

			dialogue_target_switch_event = dialogue_target_switch_event or "enemy_attack"

			trigger_networked_dialogue_event(var_12_20, dialogue_target_switch_event, alloc_table)
		end

		local system = Managers.state.entity:system("sound_effect_system")

		system:aggro_unit_changed(aggro_unit, arg_12_0, false)
		system:aggro_unit_changed(var_12_15, arg_12_0, true)
	end
end

PerceptionUtils.perception_all_seeing_re_evaluate = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local target_unit = arg_13_1.target_unit
	local var_13_1 = HEALTH_ALIVE[target_unit]
	local var_13_2, var_13_3, var_13_4 = arg_13_3(arg_13_0, arg_13_1, arg_13_2, arg_13_4)

	if not (not var_13_1 and var_13_2 ~= target_unit) then
		arg_13_1.target_dist = var_13_3
		arg_13_1.urgency_to_engage = var_13_4
	elseif not (not var_13_2 and var_13_2 == target_unit) then
		if not arg_13_2.special then
			local special_targets = arg_13_1.group_blackboard.special_targets

			if not target_unit then
				special_targets[target_unit] = nil
			end

			special_targets[var_13_2] = arg_13_0
		end

		arg_13_1.previous_target_unit = arg_13_1.target_unit
		arg_13_1.target_changed = true
		arg_13_1.target_unit = var_13_2
		arg_13_1.target_unit_found_time = arg_13_4
		arg_13_1.target_dist = var_13_3
		arg_13_1.urgency_to_engage = var_13_4
		arg_13_1.remembered_threat_pos = nil
	else
		if not arg_13_2.special then
			local special_targets_2 = arg_13_1.group_blackboard.special_targets

			if special_targets_2[target_unit] == arg_13_0 then
				special_targets_2[target_unit] = nil
			end
		end

		arg_13_1.previous_target_unit = arg_13_1.target_unit
		arg_13_1.target_unit = nil
		arg_13_1.target_dist = math.huge
		arg_13_1.urgency_to_engage = nil
	end
end

PerceptionUtils.perception_regular = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if not arg_14_1.keep_target then
		return false
	end

	local target_unit = arg_14_1.target_unit
	local var_14_1 = HEALTH_ALIVE[target_unit]
	local var_14_2 = arg_14_3(arg_14_0, arg_14_1, arg_14_2, arg_14_4)

	if not (not target_unit and not var_14_1 and var_14_2 ~= target_unit) then
		local has_extension = ScriptUnit.has_extension(target_unit, "status_system")

		if not has_extension then
			arg_14_1.target_is_not_downed = not not has_extension.is_ledge_hanging or not has_extension.knocked_down
		else
			arg_14_1.target_is_not_downed = true
		end
	else
		if not (not var_14_2 and var_14_2 == target_unit) then
			arg_14_1.previous_target_unit = arg_14_1.target_unit
			arg_14_1.target_unit = var_14_2
			arg_14_1.target_unit_found_time = arg_14_4
			arg_14_1.slot = nil
			arg_14_1.slot_layer = nil
			arg_14_1.is_passive = false
			arg_14_1.target_changed = true
		elseif not (not arg_14_1.delayed_target_unit and not HEALTH_ALIVE[arg_14_1.delayed_target_unit] and arg_14_1.target_unit ~= nil) then
			arg_14_1.previous_target_unit = arg_14_1.target_unit
			arg_14_1.target_unit = arg_14_1.delayed_target_unit
			arg_14_1.target_unit_found_time = arg_14_4
			arg_14_1.is_passive = false
			arg_14_1.target_changed = true
		else
			arg_14_1.previous_target_unit = arg_14_1.target_unit
			arg_14_1.target_unit = nil

			if not (not arg_14_1.confirmed_player_sighting and (arg_14_1.spawn_type == "horde" or arg_14_1.spawn_type == "horde_hidden")) then
				AiUtils.deactivate_unit(arg_14_1)
			end
		end

		arg_14_1.delayed_target_unit = nil
	end
end

PerceptionUtils.keep_target_until_invalid = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local target_unit = arg_15_1.target_unit
	local has_extension = ScriptUnit.has_extension(target_unit, "health_system")
	local has_extension_2 = ScriptUnit.has_extension(target_unit, "status_system")

	if not ALIVE[target_unit] and not has_extension and has_extension:is_dead() and not has_extension_2 or not has_extension_2:is_invisible() then
		arg_15_1.override_target_selection_name = nil
	end

	return target_unit
end

PerceptionUtils.perception_regular_update_aggro = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	AiUtils.update_aggro(arg_16_0, arg_16_1, arg_16_2, arg_16_4, arg_16_5)
	PerceptionUtils.perception_regular(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)

	if arg_16_1.aggro_unit ~= arg_16_1.target_unit then
		local aggro_unit = arg_16_1.aggro_unit
		local target_unit = arg_16_1.target_unit

		arg_16_1.aggro_unit = target_unit

		local var_16_2 = arg_16_1.aggro_list[aggro_unit]

		if not var_16_2 then
			arg_16_1.aggro_list[aggro_unit] = var_16_2 * arg_16_2.perception_weights.old_target_aggro_mul
		end

		if not arg_16_2.trigger_dialogue_on_target_switch and not target_unit then
			local extension_input = ScriptUnit.extension_input(arg_16_0, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.attack_tag = "enemy_target_changed"
			alloc_table.target_name = ScriptUnit.extension(target_unit, "dialogue_system").context.player_profile

			extension_input:trigger_networked_dialogue_event("enemy_target_changed", alloc_table)
		end

		local system = Managers.state.entity:system("sound_effect_system")

		system:aggro_unit_changed(aggro_unit, arg_16_0, false)
		system:aggro_unit_changed(target_unit, arg_16_0, true)
	end
end

local tbl = {}

PerceptionUtils.alert_enemies_within_range = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	if not arg_17_2 then
		return
	end

	local extension = ScriptUnit.extension
	local var_17_1
	local var_17_2 = BLACKBOARDS[arg_17_1]

	if not var_17_2 then
		var_17_1 = var_17_2.side.enemy_broadphase_categories
	end

	local broadphase_query = AiUtils.broadphase_query(arg_17_3, arg_17_4, tbl, var_17_1)

	for i = 1, broadphase_query do
		local var_17_4 = tbl[i]

		extension(var_17_4, "ai_system"):enemy_alert(var_17_4, arg_17_1)
	end
end

PerceptionUtils.pack_master_has_line_of_sight_for_attack = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local world_position = Unit.world_position(arg_18_1, Unit.node(arg_18_1, "j_spine"))
	local world_position_2 = Unit.world_position(arg_18_2, Unit.node(arg_18_2, "j_neck"))
	local num = 0.15
	local num_2 = 1
	local num_3 = world_position - world_position_2
	local var_18_5
	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(arg_18_0, world_position, world_position_2, num, num_2, "types", "both", "collision_filter", "filter_ai_mover", "report_initial_overlap")
	local flag

	if not linear_sphere_sweep then
		local num_4 = linear_sphere_sweep[1].position - world_position
		local num_5 = world_position_2 - world_position

		if Vector3.dot(num_4, Vector3.normalize(num_5)) > Vector3.length(num_5) then
			flag = true
		else
			flag = false
		end
	else
		flag = true
	end

	return flag
end

PerceptionUtils.clear_target_unit = function (self)
	-- function 19
	if not self.breed.special then
		local special_targets = self.group_blackboard.special_targets

		if special_targets[target_unit] == unit then
			special_targets[target_unit] = nil
		end
	end

	self.previous_target_unit = self.target_unit
	self.target_unit = nil
	self.target_dist = math.huge
	self.urgency_to_engage = nil
end

local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {}
local num = 0

PerceptionUtils.special_opportunity = function (arg_20_0, arg_20_1)
	-- function 20
	num = 0

	local side = arg_20_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local count = #ENEMY_PLAYER_AND_BOT_UNITS
	local num_2 = 0

	for i = 1, #tbl_4 do
		tbl_4[i] = nil
	end

	for j = 1, count do
		local var_20_6 = ENEMY_PLAYER_AND_BOT_UNITS[j]
		local extension = ScriptUnit.extension(var_20_6, "status_system")

		if not (not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_20_6] and extension.using_transport) then
			if not extension:is_knocked_down() then
				num_2 = 10
			elseif not extension:is_grabbed_by_pack_master() then
				num_2 = 10
			elseif not extension:get_is_ledge_hanging() then
				num_2 = 10
			elseif not extension:is_pounced_down() then
				num_2 = 10
			elseif not extension.under_ratling_gunner_attack then
				num_2 = 10
			elseif not ScriptUnit.extension(var_20_6, "health_system"):is_alive() then
				num = num + 1
				tbl_3[num] = var_20_6
				tbl_4[num] = ENEMY_PLAYER_AND_BOT_POSITIONS[j]
			end
		end
	end

	if num <= 0 then
		return 0
	end

	if arg_20_1.total_slots_count / num >= 4 then
		num_2 = 10
	end

	if num_2 > 0 then
		local var_20_8 = POSITION_LOOKUP[arg_20_0]
		local huge = math.huge
		local var_20_10

		for k = 1, num do
			local var_20_11 = tbl_3[k]
			local distance_squared = Vector3.distance_squared(var_20_8, tbl_4[k])

			if distance_squared < huge then
				huge = distance_squared
				var_20_10 = var_20_11
			end
		end

		return 10, var_20_10
	end

	do return 0 end

	local cluster_weight_and_loneliness, var_20_14, var_20_15, var_20_16 = conflictutils.cluster_weight_and_loneliness(tbl_4, 10)
	local var_20_17 = tbl_3[var_20_14]
	local distance_squared_2 = Vector3.distance_squared(tbl_4[var_20_14], POSITION_LOOKUP[arg_20_0])

	if distance_squared_2 < 30 then
		num_2 = 10

		local sqrt = math.sqrt(distance_squared_2)

		return var_20_17, sqrt, num_2
	end

	return num_2
end
