-- chunkname: @scripts/unit_extensions/human/ai_player_unit/perception_utils.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_utils")

PerceptionUtils = {}

local var_0_0 = HEALTH_ALIVE
local var_0_1 = AiUtils.unit_knocked_down
local var_0_2 = POSITION_LOOKUP
local var_0_3 = AI_UTILS
local var_0_4 = ScriptUnit.extension

PerceptionUtils.troll_crouch_check = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = World.get_data(arg_1_1.world, "physics_world")
	local var_1_1 = 1.2
	local var_1_2 = Unit.local_position(arg_1_0, 0)
	local var_1_3 = Vector3.normalize(Quaternion.forward(Unit.world_rotation(arg_1_0, 0)))
	local var_1_4 = var_1_2 + Vector3(0, 0, 2)
	local var_1_5 = var_1_4 + var_1_3
	local var_1_6, var_1_7 = PhysicsWorld.immediate_raycast(var_1_0, var_1_5, Vector3(0, 0, 1), var_1_1, "closest", "collision_filter", "filter_ai_mover")
	local var_1_8, var_1_9 = PhysicsWorld.immediate_raycast(var_1_0, var_1_4, Vector3(0, 0, 1), var_1_1, "closest", "collision_filter", "filter_ai_mover")

	if var_1_6 and var_1_7 or var_1_8 and var_1_9 then
		arg_1_1.crouch_sticky_timer = arg_1_2 + 1
	end

	arg_1_1.needs_to_crouch = arg_1_2 < arg_1_1.crouch_sticky_timer
end

PerceptionUtils.perception_continuous_chaos_troll = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	AiUtils.push_intersecting_players(arg_2_0, arg_2_0, arg_2_1.displaced_units, arg_2_2.displace_players_data, arg_2_3, arg_2_4)
	PerceptionUtils.troll_crouch_check(arg_2_0, arg_2_1, arg_2_3)
	AiUtils.update_aggro(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	return true
end

PerceptionUtils.perception_continuous_chaos_spawn = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	AiUtils.update_aggro(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_1.grabbed_time = arg_3_1.grabbed_time + arg_3_4

	return true
end

PerceptionUtils.perception_continuous_rat_ogre = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	AiUtils.update_aggro(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	return true
end

PerceptionUtils.perception_continuous_keep_target = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_1.target_unit
	local var_5_1 = arg_5_1.side

	return not var_0_0[var_5_0] or DamageUtils.is_player_unit(var_5_0) and not var_5_1.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_5_0]
end

PerceptionUtils.perception_no_seeing = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	return
end

PerceptionUtils.perception_all_seeing = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_1.target_unit
	local var_7_1, var_7_2 = arg_7_3(arg_7_0, arg_7_1, arg_7_2)

	if var_7_1 then
		if var_7_1 ~= var_7_0 then
			if arg_7_2.special then
				local var_7_3 = arg_7_1.group_blackboard.special_targets

				if var_7_0 then
					var_7_3[var_7_0] = nil
				end

				var_7_3[var_7_1] = arg_7_0
			end

			arg_7_1.previous_target_unit = arg_7_1.target_unit
			arg_7_1.target_unit = var_7_1
			arg_7_1.target_unit_found_time = arg_7_4
			arg_7_1.is_passive = false
		end

		arg_7_1.target_dist = var_7_2
	else
		if arg_7_2.special and var_7_0 then
			arg_7_1.group_blackboard.special_targets[var_7_0] = nil
		end

		arg_7_1.previous_target_unit = arg_7_1.target_unit
		arg_7_1.target_unit = nil
		arg_7_1.target_dist = math.huge
	end
end

PerceptionUtils.perception_all_seeing_boss = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	PerceptionUtils.perception_all_seeing(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)

	if arg_8_1.aggro_unit ~= arg_8_1.target_unit then
		local var_8_0 = arg_8_1.aggro_unit
		local var_8_1 = arg_8_1.target_unit

		arg_8_1.aggro_unit = var_8_1

		if arg_8_2.trigger_dialogue_on_target_switch and var_8_1 then
			local var_8_2 = ScriptUnit.extension_input(arg_8_0, "dialogue_system")
			local var_8_3 = FrameTable.alloc_table()

			var_8_3.attack_tag = arg_8_2.dialogue_target_switch_attack_tag or "enemy_target_changed"
			var_8_3.target_name = ScriptUnit.extension(var_8_1, "dialogue_system").context.player_profile

			var_8_2:trigger_networked_dialogue_event(arg_8_2.dialogue_target_switch_event or "enemy_target_changed", var_8_3)
		end

		local var_8_4 = Managers.state.entity:system("sound_effect_system")

		var_8_4:aggro_unit_changed(var_8_0, arg_8_0, false)
		var_8_4:aggro_unit_changed(var_8_1, arg_8_0, true)
	end
end

PerceptionUtils.perception_standard_bearer = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if arg_9_1.spawn_category == "patrol" then
		local var_9_0 = ScriptUnit.has_extension(arg_9_0, "ai_group_system")

		if var_9_0 and var_9_0.in_patrol then
			return
		end
	end

	local var_9_1 = arg_9_1.target_unit
	local var_9_2, var_9_3 = arg_9_3(arg_9_0, arg_9_1, arg_9_2)

	if var_9_2 and var_9_2 ~= var_9_1 then
		local var_9_4 = arg_9_1.group_blackboard.special_targets

		if var_9_1 then
			var_9_4[var_9_1] = nil
		end

		var_9_4[var_9_2] = arg_9_0
		arg_9_1.previous_target_unit = arg_9_1.target_unit
		arg_9_1.target_unit = var_9_2
		arg_9_1.target_unit_found_time = arg_9_4
		arg_9_1.target_dist = var_9_3
		arg_9_1.is_passive = false
	elseif var_9_2 then
		arg_9_1.target_dist = var_9_3
	else
		if var_9_1 then
			arg_9_1.group_blackboard.special_targets[var_9_1] = nil
		end

		arg_9_1.previous_target_unit = arg_9_1.target_unit
		arg_9_1.target_unit = nil
		arg_9_1.target_dist = math.huge
	end
end

PerceptionUtils.perception_tether_sorcerer = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0, var_10_1 = arg_10_3(arg_10_0, arg_10_1, arg_10_2)

	if var_10_0 ~= arg_10_1.target_unit then
		arg_10_1.target_unit = var_10_0
		arg_10_1.target_unit_found_time = arg_10_4
		arg_10_1.target_dist = var_10_1
	end
end

PerceptionUtils.perception_pack_master = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if arg_11_1.drag_target_unit then
		return
	end

	local var_11_0 = arg_11_1.target_unit
	local var_11_1, var_11_2 = arg_11_3(arg_11_0, arg_11_1, arg_11_2)

	if var_11_1 and var_11_1 ~= var_11_0 then
		local var_11_3 = arg_11_1.group_blackboard.special_targets

		if var_11_0 then
			var_11_3[var_11_0] = nil
		end

		var_11_3[var_11_1] = arg_11_0
		arg_11_1.previous_target_unit = arg_11_1.target_unit
		arg_11_1.target_unit = var_11_1
		arg_11_1.target_unit_found_time = arg_11_4
		arg_11_1.target_dist = var_11_2
		arg_11_1.is_passive = false
	elseif var_11_1 then
		arg_11_1.target_dist = var_11_2
	else
		if var_11_0 then
			arg_11_1.group_blackboard.special_targets[var_11_0] = nil
		end

		arg_11_1.previous_target_unit = arg_11_1.target_unit
		arg_11_1.target_unit = nil
		arg_11_1.target_dist = math.huge
	end
end

PerceptionUtils.perception_rat_ogre = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if arg_12_1.keep_target then
		return
	end

	PerceptionUtils.perception_all_seeing_re_evaluate(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)

	local var_12_0 = arg_12_1.target_unit

	if ALIVE[var_12_0] then
		local var_12_1 = ScriptUnit.has_extension(var_12_0, "status_system")

		if var_12_1 then
			arg_12_1.target_is_not_downed = not var_12_1.is_ledge_hanging and not var_12_1.knocked_down

			local var_12_2 = var_0_2[arg_12_0]
			local var_12_3 = var_0_2[var_12_0] - var_12_2
			local var_12_4 = var_12_3.x
			local var_12_5 = var_12_3.y

			arg_12_1.target_height_distance, arg_12_1.target_flat_distance = var_12_3.z, math.sqrt(var_12_4 * var_12_4 + var_12_5 * var_12_5)

			local var_12_6, var_12_7 = var_12_1:get_is_on_ladder()

			if var_12_6 then
				local var_12_8, var_12_9 = ScriptUnit.extension(var_12_7, "ladder_system"):ladder_extents()

				arg_12_1.target_on_ladder = var_12_7

				local var_12_10 = var_12_2 - var_12_8
				local var_12_11 = var_12_9 - var_12_8
				local var_12_12 = Vector3.normalize(var_12_11)
				local var_12_13 = Vector3.dot(var_12_10, var_12_12)

				if var_12_13 < 0 then
					arg_12_1.ladder_distance = Vector3.length(var_12_10)
				elseif var_12_13 > Vector3.length(var_12_11) then
					arg_12_1.ladder_distance = Vector3.length(var_12_2 - var_12_9)
				else
					arg_12_1.ladder_distance = Vector3.length(var_12_10 - var_12_12 * var_12_13)
				end
			else
				arg_12_1.ladder_distance = math.huge
			end
		else
			arg_12_1.target_is_not_downed = true
		end
	end

	if arg_12_1.aggro_unit ~= var_12_0 then
		local var_12_14 = arg_12_1.aggro_unit
		local var_12_15 = var_12_0

		arg_12_1.aggro_unit = var_12_15

		local var_12_16 = arg_12_1.aggro_list[var_12_14]

		if var_12_16 then
			arg_12_1.aggro_list[var_12_14] = var_12_16 * arg_12_2.perception_weights.old_target_aggro_mul
		end

		if arg_12_2.trigger_dialogue_on_target_switch and var_12_15 then
			local var_12_17 = ScriptUnit.extension_input(arg_12_0, "dialogue_system")
			local var_12_18 = FrameTable.alloc_table()

			var_12_18.attack_tag = arg_12_2.dialogue_target_switch_attack_tag or "rat_ogre_change_target"
			var_12_18.target_name = ScriptUnit.extension(var_12_15, "dialogue_system").context.player_profile

			var_12_17:trigger_networked_dialogue_event(arg_12_2.dialogue_target_switch_event or "enemy_attack", var_12_18)
		end

		local var_12_19 = Managers.state.entity:system("sound_effect_system")

		var_12_19:aggro_unit_changed(var_12_14, arg_12_0, false)
		var_12_19:aggro_unit_changed(var_12_15, arg_12_0, true)
	end
end

PerceptionUtils.perception_all_seeing_re_evaluate = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_1.target_unit
	local var_13_1 = var_0_0[var_13_0]
	local var_13_2, var_13_3, var_13_4 = arg_13_3(arg_13_0, arg_13_1, arg_13_2, arg_13_4)

	if var_13_1 and var_13_2 == var_13_0 then
		arg_13_1.target_dist = var_13_3
		arg_13_1.urgency_to_engage = var_13_4
	elseif var_13_2 and var_13_2 ~= var_13_0 then
		if arg_13_2.special then
			local var_13_5 = arg_13_1.group_blackboard.special_targets

			if var_13_0 then
				var_13_5[var_13_0] = nil
			end

			var_13_5[var_13_2] = arg_13_0
		end

		arg_13_1.previous_target_unit = arg_13_1.target_unit
		arg_13_1.target_changed = true
		arg_13_1.target_unit = var_13_2
		arg_13_1.target_unit_found_time = arg_13_4
		arg_13_1.target_dist = var_13_3
		arg_13_1.urgency_to_engage = var_13_4
		arg_13_1.remembered_threat_pos = nil
	else
		if arg_13_2.special then
			local var_13_6 = arg_13_1.group_blackboard.special_targets

			if var_13_6[var_13_0] == arg_13_0 then
				var_13_6[var_13_0] = nil
			end
		end

		arg_13_1.previous_target_unit = arg_13_1.target_unit
		arg_13_1.target_unit = nil
		arg_13_1.target_dist = math.huge
		arg_13_1.urgency_to_engage = nil
	end
end

PerceptionUtils.perception_regular = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if arg_14_1.keep_target then
		return false
	end

	local var_14_0 = arg_14_1.target_unit
	local var_14_1 = var_0_0[var_14_0]
	local var_14_2 = arg_14_3(arg_14_0, arg_14_1, arg_14_2, arg_14_4)

	if var_14_0 and var_14_1 and var_14_2 == var_14_0 then
		local var_14_3 = ScriptUnit.has_extension(var_14_0, "status_system")

		if var_14_3 then
			arg_14_1.target_is_not_downed = not var_14_3.is_ledge_hanging and not var_14_3.knocked_down
		else
			arg_14_1.target_is_not_downed = true
		end
	else
		if var_14_2 and var_14_2 ~= var_14_0 then
			arg_14_1.previous_target_unit = arg_14_1.target_unit
			arg_14_1.target_unit = var_14_2
			arg_14_1.target_unit_found_time = arg_14_4
			arg_14_1.slot = nil
			arg_14_1.slot_layer = nil
			arg_14_1.is_passive = false
			arg_14_1.target_changed = true
		elseif arg_14_1.delayed_target_unit and var_0_0[arg_14_1.delayed_target_unit] and arg_14_1.target_unit == nil then
			arg_14_1.previous_target_unit = arg_14_1.target_unit
			arg_14_1.target_unit = arg_14_1.delayed_target_unit
			arg_14_1.target_unit_found_time = arg_14_4
			arg_14_1.is_passive = false
			arg_14_1.target_changed = true
		else
			arg_14_1.previous_target_unit = arg_14_1.target_unit
			arg_14_1.target_unit = nil

			if arg_14_1.confirmed_player_sighting and not (arg_14_1.spawn_type == "horde" or arg_14_1.spawn_type == "horde_hidden") then
				AiUtils.deactivate_unit(arg_14_1)
			end
		end

		arg_14_1.delayed_target_unit = nil
	end
end

PerceptionUtils.keep_target_until_invalid = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_1.target_unit
	local var_15_1 = ScriptUnit.has_extension(var_15_0, "health_system")
	local var_15_2 = ScriptUnit.has_extension(var_15_0, "status_system")

	if not ALIVE[var_15_0] or var_15_1 and var_15_1:is_dead() or var_15_2 and var_15_2:is_invisible() then
		arg_15_1.override_target_selection_name = nil
	end

	return var_15_0
end

PerceptionUtils.perception_regular_update_aggro = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	AiUtils.update_aggro(arg_16_0, arg_16_1, arg_16_2, arg_16_4, arg_16_5)
	PerceptionUtils.perception_regular(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)

	if arg_16_1.aggro_unit ~= arg_16_1.target_unit then
		local var_16_0 = arg_16_1.aggro_unit
		local var_16_1 = arg_16_1.target_unit

		arg_16_1.aggro_unit = var_16_1

		local var_16_2 = arg_16_1.aggro_list[var_16_0]

		if var_16_2 then
			arg_16_1.aggro_list[var_16_0] = var_16_2 * arg_16_2.perception_weights.old_target_aggro_mul
		end

		if arg_16_2.trigger_dialogue_on_target_switch and var_16_1 then
			local var_16_3 = ScriptUnit.extension_input(arg_16_0, "dialogue_system")
			local var_16_4 = FrameTable.alloc_table()

			var_16_4.attack_tag = "enemy_target_changed"
			var_16_4.target_name = ScriptUnit.extension(var_16_1, "dialogue_system").context.player_profile

			var_16_3:trigger_networked_dialogue_event("enemy_target_changed", var_16_4)
		end

		local var_16_5 = Managers.state.entity:system("sound_effect_system")

		var_16_5:aggro_unit_changed(var_16_0, arg_16_0, false)
		var_16_5:aggro_unit_changed(var_16_1, arg_16_0, true)
	end
end

local var_0_5 = {}

PerceptionUtils.alert_enemies_within_range = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	if not arg_17_2 then
		return
	end

	local var_17_0 = ScriptUnit.extension
	local var_17_1
	local var_17_2 = BLACKBOARDS[arg_17_1]

	if var_17_2 then
		var_17_1 = var_17_2.side.enemy_broadphase_categories
	end

	local var_17_3 = AiUtils.broadphase_query(arg_17_3, arg_17_4, var_0_5, var_17_1)

	for iter_17_0 = 1, var_17_3 do
		local var_17_4 = var_0_5[iter_17_0]

		var_17_0(var_17_4, "ai_system"):enemy_alert(var_17_4, arg_17_1)
	end
end

PerceptionUtils.pack_master_has_line_of_sight_for_attack = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = Unit.world_position(arg_18_1, Unit.node(arg_18_1, "j_spine"))
	local var_18_1 = Unit.world_position(arg_18_2, Unit.node(arg_18_2, "j_neck"))
	local var_18_2 = 0.15
	local var_18_3 = 1
	local var_18_4 = var_18_0 - var_18_1
	local var_18_5
	local var_18_6 = PhysicsWorld.linear_sphere_sweep(arg_18_0, var_18_0, var_18_1, var_18_2, var_18_3, "types", "both", "collision_filter", "filter_ai_mover", "report_initial_overlap")
	local var_18_9

	if var_18_6 then
		local var_18_7 = var_18_6[1].position - var_18_0
		local var_18_8 = var_18_1 - var_18_0

		if Vector3.dot(var_18_7, Vector3.normalize(var_18_8)) > Vector3.length(var_18_8) then
			var_18_9 = true
		else
			var_18_9 = false
		end
	else
		var_18_9 = true
	end

	return var_18_9
end

PerceptionUtils.clear_target_unit = function (arg_19_0)
	if arg_19_0.breed.special then
		local var_19_0 = arg_19_0.group_blackboard.special_targets

		if var_19_0[target_unit] == unit then
			var_19_0[target_unit] = nil
		end
	end

	arg_19_0.previous_target_unit = arg_19_0.target_unit
	arg_19_0.target_unit = nil
	arg_19_0.target_dist = math.huge
	arg_19_0.urgency_to_engage = nil
end

local var_0_6 = {}
local var_0_7 = {}
local var_0_8 = {}
local var_0_9 = 0

PerceptionUtils.special_opportunity = function (arg_20_0, arg_20_1)
	var_0_9 = 0

	local var_20_0 = arg_20_1.side
	local var_20_1 = var_20_0.ENEMY_PLAYER_AND_BOT_UNITS
	local var_20_2 = var_20_0.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_20_3 = var_20_0.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_20_4 = #var_20_1
	local var_20_5 = 0

	for iter_20_0 = 1, #var_0_8 do
		var_0_8[iter_20_0] = nil
	end

	for iter_20_1 = 1, var_20_4 do
		local var_20_6 = var_20_1[iter_20_1]
		local var_20_7 = ScriptUnit.extension(var_20_6, "status_system")

		if var_20_2[var_20_6] and not var_20_7.using_transport then
			if var_20_7:is_knocked_down() then
				var_20_5 = 10
			elseif var_20_7:is_grabbed_by_pack_master() then
				var_20_5 = 10
			elseif var_20_7:get_is_ledge_hanging() then
				var_20_5 = 10
			elseif var_20_7:is_pounced_down() then
				var_20_5 = 10
			elseif var_20_7.under_ratling_gunner_attack then
				var_20_5 = 10
			elseif ScriptUnit.extension(var_20_6, "health_system"):is_alive() then
				var_0_9 = var_0_9 + 1
				var_0_7[var_0_9] = var_20_6
				var_0_8[var_0_9] = var_20_3[iter_20_1]
			end
		end
	end

	if var_0_9 <= 0 then
		return 0
	end

	if arg_20_1.total_slots_count / var_0_9 >= 4 then
		var_20_5 = 10
	end

	if var_20_5 > 0 then
		local var_20_8 = var_0_2[arg_20_0]
		local var_20_9 = math.huge
		local var_20_10

		for iter_20_2 = 1, var_0_9 do
			local var_20_11 = var_0_7[iter_20_2]
			local var_20_12 = Vector3.distance_squared(var_20_8, var_0_8[iter_20_2])

			if var_20_12 < var_20_9 then
				var_20_9 = var_20_12
				var_20_10 = var_20_11
			end
		end

		return 10, var_20_10
	end

	do return 0 end

	local var_20_13, var_20_14, var_20_15, var_20_16 = conflictutils.cluster_weight_and_loneliness(var_0_8, 10)
	local var_20_17 = var_0_7[var_20_14]
	local var_20_18 = Vector3.distance_squared(var_0_8[var_20_14], var_0_2[arg_20_0])

	if var_20_18 < 30 then
		var_20_5 = 10

		local var_20_19 = math.sqrt(var_20_18)

		return var_20_17, var_20_19, var_20_5
	end

	return var_20_5
end
