-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_melee_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")

BTBotMeleeAction = class(BTBotMeleeAction, BTNode)

function BTBotMeleeAction.init(arg_1_0, ...)
	BTBotMeleeAction.super.init(arg_1_0, ...)
end

BTBotMeleeAction.name = "BTBotMeleeAction"

local var_0_1 = 50
local var_0_2 = 5
local var_0_3 = 0.5
local var_0_4 = 25

local function var_0_5(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_1 - Quaternion.rotate(Quaternion(Vector3.up(), arg_2_3), arg_2_2) * arg_2_4
	local var_2_1, var_2_2 = GwNavQueries.triangle_from_position(arg_2_0, var_2_0, 0.5, 0.5)

	if var_2_1 then
		var_2_0.z = var_2_2

		return true, var_2_0
	else
		return false
	end
end

local function var_0_6(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = Vector3.normalize(Vector3.flat(arg_3_2))
	local var_3_1, var_3_2 = var_0_5(arg_3_0, arg_3_1, var_3_0, 0, arg_3_3)

	if var_3_1 then
		return var_3_2
	end

	local var_3_3 = 3
	local var_3_4 = math.pi / (var_3_3 + 1)

	for iter_3_0 = 1, var_3_3 do
		local var_3_5 = var_3_4 * iter_3_0
		local var_3_6, var_3_7 = var_0_5(arg_3_0, arg_3_1, var_3_0, var_3_5, arg_3_3)
		local var_3_8 = var_3_7

		if var_3_6 then
			return var_3_8
		end

		local var_3_9, var_3_10 = var_0_5(arg_3_0, arg_3_1, var_3_0, -var_3_5, arg_3_3)
		local var_3_11 = var_3_10

		if var_3_9 then
			return var_3_11
		end
	end

	local var_3_12, var_3_13 = var_0_5(arg_3_0, arg_3_1, var_3_0, math.pi, arg_3_3)
	local var_3_14 = var_3_13

	if var_3_12 then
		return var_3_14
	end

	return nil
end

function BTBotMeleeAction.enter(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_2.node_timer = arg_4_3
	arg_4_2.melee = {
		engage_update_time = 0,
		engage_position_set = false,
		engage_change_time = 0,
		engaging = false,
		engage_position = Vector3Box(0, 0, 0)
	}

	local var_4_0 = arg_4_2.inventory_extension
	local var_4_1 = var_4_0:get_wielded_slot_name()
	local var_4_2 = var_4_0:get_slot_data(var_4_1).item_data

	arg_4_2.wielded_item_template = BackendUtils.get_item_template(var_4_2)

	local var_4_3 = arg_4_2.input_extension
	local var_4_4 = true

	var_4_3:set_aiming(true, var_4_4)
end

function BTBotMeleeAction.leave(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_2.input_extension:set_aiming(false)

	if arg_5_2.melee.engaging then
		arg_5_0:_disengage(arg_5_1, arg_5_3, arg_5_2)
	end

	arg_5_0:_clear_pending_attack(arg_5_2)

	if arg_5_0:_should_stop_attack_on_leave(arg_5_2) then
		arg_5_0:_stop_attack(arg_5_2)
	end

	arg_5_2.wielded_item_template = nil
end

function BTBotMeleeAction.run(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0, var_6_1 = arg_6_0:_update_melee(arg_6_1, arg_6_2, arg_6_4, arg_6_3)

	if var_6_0 then
		return "done", "evaluate"
	else
		return "running", var_6_1 and "evaluate" or nil
	end
end

function BTBotMeleeAction._update_engage_position(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_3.nav_world
	local var_7_1 = POSITION_LOOKUP[arg_7_1]
	local var_7_2 = arg_7_0:_target_unit_position(var_7_1, arg_7_2, var_7_0)
	local var_7_3
	local var_7_4
	local var_7_5
	local var_7_6, var_7_7 = arg_7_0:_is_targeting_me(arg_7_1, arg_7_2)
	local var_7_8 = var_7_2 - var_7_1
	local var_7_9 = arg_7_5 - 0.5
	local var_7_10 = var_7_9^2
	local var_7_11 = ScriptUnit.has_extension(arg_7_2, "locomotion_system")

	if var_7_11 then
		local var_7_12 = var_7_11:current_velocity()

		if Vector3.length_squared(var_7_12) > 4 then
			var_7_9 = 0
			var_7_10 = 0
		end
	end

	if var_7_7 and (not var_7_6 or var_7_7.bots_flank_while_targeted) and var_7_7.bots_should_flank then
		local var_7_13 = Unit.local_rotation(arg_7_2, 0)
		local var_7_14 = Quaternion.forward(var_7_13)

		if Vector3.dot(var_7_14, var_7_8) > -0.25 then
			var_7_4 = var_7_8
		else
			local var_7_15 = Vector3.normalize(Vector3.flat(var_7_14))
			local var_7_16 = Vector3.normalize(Vector3.flat(var_7_8))
			local var_7_17 = Vector3.flat_angle(-var_7_16, var_7_15)
			local var_7_18

			if var_7_17 > 0 then
				var_7_18 = var_7_17 + math.pi / 8
			else
				var_7_18 = var_7_17 - math.pi / 8
			end

			local var_7_19 = Quaternion.multiply(Quaternion(Vector3.up(), -var_7_18), var_7_13)

			var_7_4 = -Quaternion.forward(var_7_19)
		end

		var_7_3 = var_0_6(var_7_0, var_7_2, var_7_4, var_7_9)
	elseif var_7_10 >= Vector3.distance_squared(var_7_1, var_7_2) then
		var_7_3 = var_7_1
		var_7_5 = true
	else
		var_7_3 = var_0_6(var_7_0, var_7_2, var_7_8, var_7_9)
	end

	if var_7_3 then
		local var_7_20 = arg_7_3.melee
		local var_7_21 = arg_7_3.navigation_destination_override
		local var_7_22 = var_7_21:unbox()
		local var_7_23 = var_7_20.engage_position_set

		fassert(not var_7_23 or Vector3.is_valid(var_7_22))

		if not var_7_23 or Vector3.distance_squared(var_7_3, var_7_22) > 0.01 then
			var_7_21:store(var_7_3)

			var_7_20.engage_position_set = true
			var_7_20.stop_at_current_position = var_7_5
		end

		local var_7_24 = Vector3.distance(var_7_1, var_7_3)
		local var_7_25 = 3
		local var_7_26 = 7

		var_7_20.engage_update_time = arg_7_4 + math.auto_lerp(var_7_25, var_7_26, 0.2, 2, math.clamp(var_7_24, var_7_25, var_7_26))
	end
end

local var_0_7 = {
	tap_attack = {
		arc = 0,
		max_range = var_0_2
	},
	hold_attack = {
		arc = 2,
		max_range = var_0_2
	}
}

function BTBotMeleeAction._choose_attack(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0
	local var_8_1
	local var_8_2 = arg_8_1.wielded_slot_name
	local var_8_3 = var_8_2 and arg_8_1.weapon_scores
	local var_8_4 = var_8_3 and var_8_3[var_8_2]

	if var_8_4 then
		var_8_0 = var_8_4.input
		var_8_1 = var_8_4.meta
	else
		local var_8_5 = AiUtils.get_combat_conditions(arg_8_1)
		local var_8_6 = arg_8_1.wielded_item_template

		var_8_0, var_8_1 = AiUtils.get_melee_weapon_score(var_8_5, var_8_6)
	end

	return var_8_0, var_8_1
end

function BTBotMeleeAction._is_in_melee_range(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0 = ScriptUnit.has_extension(arg_9_7, "locomotion_system")
	local var_9_1 = var_9_0 and var_9_0:current_velocity() or Vector3.zero()
	local var_9_2 = arg_9_1 + (arg_9_6.locomotion_extension:current_velocity() - var_9_1) * math.max(arg_9_0:_time_to_next_attack(arg_9_4, arg_9_6, arg_9_5) or 0, 0)

	return arg_9_3^2 > Vector3.distance_squared(arg_9_2, var_9_2)
end

function BTBotMeleeAction._is_in_engage_range(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = AiUtils.get_party_danger()
	local var_10_1 = math.lerp(arg_10_4.engage_range_near_follow_pos, arg_10_4.engage_range_near_follow_pos_threat, var_10_0)
	local var_10_2 = math.lerp(arg_10_4.engage_range, arg_10_4.engage_range_threat, var_10_0)
	local var_10_3 = POSITION_LOOKUP[arg_10_1]
	local var_10_4 = math.clamp(Vector3.distance_squared(arg_10_5, var_10_3) / var_0_4, 0, 1)
	local var_10_5 = math.lerp(var_10_1, var_10_2, var_10_4)
	local var_10_6 = arg_10_0:_target_unit_position(var_10_3, arg_10_2, arg_10_3)

	return Vector3.distance_squared(var_10_3, var_10_6) < var_10_5 * var_10_5
end

function BTBotMeleeAction._target_unit_position(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0

	if arg_11_0._tree_node.action_data.destroy_object then
		local var_11_1 = Managers.state.entity:system("nav_graph_system")
		local var_11_2 = var_11_1:get_smart_object_id(arg_11_2)

		if var_11_2 then
			local var_11_3 = var_11_1:get_smart_objects(var_11_2)[1]
			local var_11_4 = Vector3Aux.unbox(var_11_3.pos1)
			local var_11_5 = Vector3Aux.unbox(var_11_3.pos2)

			var_11_0 = math.closest_position(arg_11_1, var_11_4, var_11_5)
		else
			local var_11_6 = "rp_center"
			local var_11_7 = Unit.has_node(arg_11_2, var_11_6) and Unit.node(arg_11_2, var_11_6) or 0
			local var_11_8 = Unit.world_position(arg_11_2, var_11_7)

			var_11_0 = LocomotionUtils.pos_on_mesh(arg_11_3, var_11_8, 0.5, 2) or var_11_8
		end
	else
		var_11_0 = POSITION_LOOKUP[arg_11_2]
	end

	return var_11_0
end

function BTBotMeleeAction._is_being_attacked(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_2.proximite_enemies

	for iter_12_0 = 1, #var_12_0 do
		repeat
			local var_12_1 = var_12_0[iter_12_0]
			local var_12_2 = BLACKBOARDS[var_12_1]

			if not var_12_2 then
				break
			end

			local var_12_3 = ScriptUnit.has_extension(var_12_1, "buff_system")

			if var_12_3 and var_12_3:has_buff_perk("ai_unblockable") then
				break
			end

			local var_12_4 = var_12_2.attack_finished_t

			if var_12_2.attack_finished or var_12_4 and var_12_4 < arg_12_3 then
				break
			end

			local var_12_5 = var_12_2.action

			if not (var_12_5 and var_12_5.unblockable) and var_12_2.attacking_target == arg_12_1 and not var_12_2.past_damage_in_attack then
				return true
			end
		until true
	end

	return false
end

function BTBotMeleeAction._is_targeting_me(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = ScriptUnit.has_extension(arg_13_2, "ai_system")

	if not var_13_0 then
		return false
	end

	local var_13_1 = var_13_0:blackboard()

	return var_13_1.target_unit == arg_13_1, var_13_1.breed
end

function BTBotMeleeAction._allow_engage(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
	local var_14_0 = Managers.state.conflict
	local var_14_1 = AiUtils.get_party_danger()
	local var_14_2 = arg_14_4.override_engage_range_to_follow_pos
	local var_14_3 = arg_14_4.override_engage_range_to_follow_pos_threat
	local var_14_4 = math.lerp(var_14_2, var_14_3, var_14_1)
	local var_14_5 = Vector3.distance(arg_14_6, arg_14_7)

	if var_14_4 < var_14_5 - (arg_14_5 and 3 or 0) then
		return false
	end

	local var_14_6 = arg_14_3.target_ally_unit
	local var_14_7 = arg_14_3.target_ally_need_type and var_14_6 or arg_14_3.ai_bot_group_extension.data.follow_unit

	if var_14_7 then
		local var_14_8 = var_14_0:get_player_unit_segment(arg_14_1)
		local var_14_9 = var_14_0:get_player_unit_segment(var_14_7)

		if var_14_8 and var_14_9 and var_14_8 < var_14_9 then
			return false
		end
	end

	local var_14_10 = arg_14_3.ai_extension

	if arg_14_3.target_ally_needs_aid and Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(arg_14_1, var_14_6) then
		local var_14_11 = ScriptUnit.has_extension(arg_14_2, "ai_system")

		if not var_14_11 then
			return false
		end

		if not var_14_10:within_aid_range(arg_14_3) then
			return false
		end

		local var_14_12 = arg_14_3.force_aid
		local var_14_13 = ScriptUnit.extension(var_14_6, "health_system"):current_health_percent()
		local var_14_14 = var_14_11:blackboard().breed
		local var_14_15 = arg_14_3.proximite_enemies

		if not (var_14_13 > 0.3 and BTConditions.is_there_threat_to_aid(arg_14_1, var_14_15, var_14_12)) then
			return false
		end

		if arg_14_2 == arg_14_3.urgent_target_enemy and arg_14_3.revive_with_urgent_target then
			return false
		end
	end

	local var_14_16 = arg_14_3.priority_target_enemy

	if arg_14_2 ~= var_14_16 and var_14_16 then
		return false
	end

	local var_14_17, var_14_18 = var_14_10:should_stay_near_player()

	if var_14_17 and var_14_18 < var_14_5 then
		return false
	end

	if Managers.state.entity:system("darkness_system"):is_in_darkness(POSITION_LOOKUP[arg_14_2] or Unit.world_position(arg_14_2, 0), DarknessSystem.TOTAL_DARKNESS_THRESHOLD) and arg_14_2 ~= arg_14_3.breakable_object and arg_14_2 ~= var_14_16 and arg_14_2 ~= arg_14_3.urgent_target_enemy and arg_14_2 ~= arg_14_3.opportunity_target_enemy and not arg_14_3.aggressive_mode and not arg_14_3.target_ally_needs_aid then
		return false
	end

	return true
end

function BTBotMeleeAction._calculate_melee_range(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2.max_range
	local var_15_1 = Unit.get_data(arg_15_1, "breed")

	return var_15_0 + (var_15_1 and (var_15_1.bot_hitbox_radius_approximation or var_0_3) or 0)
end

function BTBotMeleeAction._update_melee(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_0._tree_node.action_data
	local var_16_1 = var_16_0.destroy_object and arg_16_2.breakable_object or arg_16_2.target_unit

	if not HEALTH_ALIVE[var_16_1] then
		return true
	end

	if script_data.ai_bots_disable_player_melee_attacks then
		local var_16_2 = BLACKBOARDS[var_16_1]

		if var_16_2 and var_16_2.is_player then
			return false
		end
	end

	local var_16_3 = AiUtils.bot_melee_aim_pos(arg_16_1, var_16_1)
	local var_16_4 = arg_16_2.input_extension

	var_16_4:set_aim_position(var_16_3)

	local var_16_5
	local var_16_6
	local var_16_7 = arg_16_2.first_person_extension:current_position()
	local var_16_8 = arg_16_2.follow and arg_16_2.follow.target_position:unbox() or var_16_7
	local var_16_9, var_16_10 = arg_16_0:_choose_attack(arg_16_2, var_16_1)
	local var_16_11 = arg_16_0:_calculate_melee_range(var_16_1, var_16_10)
	local var_16_12 = false
	local var_16_13 = arg_16_2.melee
	local var_16_14 = var_16_13.engaging

	if arg_16_0:_is_in_melee_range(var_16_7, var_16_3, var_16_11, var_16_9, arg_16_4, arg_16_2, var_16_1) then
		if not arg_16_0:_defend(arg_16_1, arg_16_2, var_16_1, var_16_4, arg_16_4, true, arg_16_3) then
			arg_16_0:_attack(var_16_9, arg_16_2, arg_16_3)

			local var_16_15 = true
		end

		var_16_5 = arg_16_2.aggressive_mode or var_16_13.engaging and arg_16_4 - var_16_13.engage_change_time < 5
		var_16_6 = 2
	elseif arg_16_0:_is_in_engage_range(arg_16_1, var_16_1, arg_16_2.nav_world, var_16_0, var_16_8) then
		arg_16_0:_defend(arg_16_1, arg_16_2, var_16_1, var_16_4, arg_16_4, false, arg_16_3)

		var_16_5 = true
		var_16_6 = 1
	else
		arg_16_0:_defend(arg_16_1, arg_16_2, var_16_1, var_16_4, arg_16_4, false, arg_16_3)

		var_16_5 = var_16_13.engaging and arg_16_4 - var_16_13.engage_change_time <= 0
		var_16_6 = 3
	end

	if arg_16_0:_is_starting_attack(arg_16_2) then
		var_16_6 = math.huge
	end

	local var_16_16 = var_16_5 and arg_16_0:_allow_engage(arg_16_1, var_16_1, arg_16_2, var_16_0, var_16_14, var_16_3, var_16_8)

	if var_16_16 and not var_16_14 then
		arg_16_0:_engage(arg_16_4, arg_16_2)

		var_16_14 = true
	elseif not var_16_16 and var_16_14 then
		arg_16_0:_disengage(arg_16_1, arg_16_4, arg_16_2)

		var_16_14 = false
	end

	if var_16_14 and (not var_16_13.engage_update_time or arg_16_4 > var_16_13.engage_update_time) and not var_16_0.do_not_update_engage_position then
		arg_16_0:_update_engage_position(arg_16_1, var_16_1, arg_16_2, arg_16_4, var_16_11)
	end

	return false, arg_16_0:_evaluation_timer(arg_16_2, arg_16_4, var_16_6)
end

local var_0_8 = {
	push = "medium"
}

function BTBotMeleeAction._defend(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	local var_17_0 = arg_17_2.wielded_item_template.defense_meta_data or var_0_8
	local var_17_1, var_17_2 = ScriptUnit.extension(arg_17_1, "status_system"):current_fatigue_points()
	local var_17_3 = var_17_2 - var_17_1
	local var_17_4 = var_17_0.push
	local var_17_5 = var_17_4 == "light" and var_17_3 <= 2 or var_17_3 <= 3
	local var_17_6 = arg_17_0:_is_being_attacked(arg_17_1, arg_17_2, arg_17_5)
	local var_17_7 = not var_17_5 and var_17_4 ~= "light" and arg_17_0:_is_pushable_shield_wearer(arg_17_3)
	local var_17_8 = (var_17_6 or var_17_7) and arg_17_0:_can_stagger_target(arg_17_1, arg_17_3, arg_17_2.wielded_item_template)

	if var_17_6 or var_17_7 and var_17_8 then
		arg_17_0:_clear_pending_attack(arg_17_2)

		local var_17_9 = #arg_17_2.proximite_enemies

		if not var_17_8 or not arg_17_6 or var_17_4 == "light" and var_17_9 > 2 or var_17_5 then
			arg_17_4:defend()
		else
			arg_17_4:melee_push()
		end

		if script_data.ai_bots_debug_behavior then
			local var_17_10 = script_data.ai_bots_debug_behavior_data

			var_17_10.time_spent_defending = var_17_10.time_spent_defending + arg_17_7
		end

		return true
	else
		return false
	end
end

function BTBotMeleeAction._is_pushable_shield_wearer(arg_18_0, arg_18_1)
	local var_18_0 = Unit.get_data(arg_18_1, "breed")

	if not var_18_0 then
		return false
	end

	if var_18_0.name == "chaos_bulwark" then
		return false
	end

	local var_18_1 = ScriptUnit.has_extension(arg_18_1, "ai_shield_system")

	return var_18_1 and var_18_1.is_blocking
end

function BTBotMeleeAction._can_stagger_target(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not BLACKBOARDS[arg_19_2] then
		return
	end

	local var_19_0 = ScriptUnit.extension(arg_19_1, "inventory_system"):get_wielded_slot_name()
	local var_19_1 = ScriptUnit.extension(arg_19_1, "inventory_system"):get_item_name(var_19_0)

	if not var_19_1 then
		return false
	end

	local var_19_2 = false
	local var_19_3 = arg_19_3.actions
	local var_19_4 = var_19_3 and var_19_3.action_one and var_19_3.action_one.push
	local var_19_5 = var_19_4 and DamageProfileTemplates[var_19_4.damage_profile_inner]

	if not var_19_5 then
		return false
	end

	local var_19_6 = 1
	local var_19_7 = AiUtils.attack_is_shield_blocked(arg_19_2, arg_19_1)
	local var_19_8 = ScriptUnit.extension(arg_19_1, "career_system"):get_career_power_level()
	local var_19_9

	return DamageUtils.calculate_stagger_player(ImpactTypeOutput, arg_19_2, arg_19_1, "torso", var_19_8, var_19_9, var_19_2, var_19_5, var_19_6, var_19_7, var_19_1) ~= var_0_0.none
end

function BTBotMeleeAction._time_to_next_attack(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = AiUtils.get_bot_weapon_extension(arg_20_2)

	if var_20_0 then
		local var_20_1 = arg_20_2.wielded_item_template
		local var_20_2 = (var_20_1.attack_meta_data or var_0_7)[arg_20_1]

		return var_20_0:time_to_next_attack(arg_20_1, var_20_1.actions, var_20_1.name, arg_20_3, var_20_2.attack_chain)
	end
end

function BTBotMeleeAction._attack(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = AiUtils.get_bot_weapon_extension(arg_21_2)

	if var_21_0 then
		local var_21_1 = arg_21_2.wielded_item_template
		local var_21_2 = (var_21_1.attack_meta_data or var_0_7)[arg_21_1]

		var_21_0:request_bot_attack_action(arg_21_1, var_21_1.actions, var_21_1.name, var_21_2.attack_chain)

		if script_data.ai_bots_debug_behavior then
			local var_21_3 = script_data.ai_bots_debug_behavior_data

			if arg_21_1 == "tap_attack" then
				var_21_3.time_in_light_attack = var_21_3.time_in_light_attack + arg_21_3
			elseif arg_21_1 == "hold_attack" then
				var_21_3.time_in_heavy_attack = var_21_3.time_in_heavy_attack + arg_21_3
			end

			var_21_3.time_spent_attacking = var_21_3.time_spent_attacking + arg_21_3
		end
	end
end

function BTBotMeleeAction._should_stop_attack_on_leave(arg_22_0, arg_22_1)
	local var_22_0 = AiUtils.get_bot_weapon_extension(arg_22_1)

	if var_22_0 then
		return var_22_0:bot_should_stop_attack_on_leave()
	end
end

function BTBotMeleeAction._stop_attack(arg_23_0, arg_23_1)
	local var_23_0 = AiUtils.get_bot_weapon_extension(arg_23_1)

	if var_23_0 then
		var_23_0:stop_action()
	end
end

function BTBotMeleeAction._clear_pending_attack(arg_24_0, arg_24_1)
	local var_24_0 = AiUtils.get_bot_weapon_extension(arg_24_1)

	if var_24_0 then
		var_24_0:clear_bot_attack_request()
	end
end

function BTBotMeleeAction._is_starting_attack(arg_25_0, arg_25_1)
	local var_25_0 = AiUtils.get_bot_weapon_extension(arg_25_1)

	if var_25_0 then
		return var_25_0:is_starting_attack()
	else
		return false
	end
end

function BTBotMeleeAction._evaluation_timer(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if arg_26_3 < arg_26_2 - arg_26_1.node_timer then
		arg_26_1.node_timer = arg_26_2

		return true
	else
		return false
	end
end

function BTBotMeleeAction._disengage(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = arg_27_3.melee

	var_27_0.engaging = false
	var_27_0.engage_change_time = arg_27_2

	if arg_27_3.follow then
		var_27_0.engage_position_set = false
	end
end

function BTBotMeleeAction._engage(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_2.melee

	var_28_0.engaging = true
	var_28_0.engage_change_time = arg_28_1
end

function BTBotMeleeAction._debug_draw_melee_range(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9)
	local var_29_0 = arg_29_7.max_range
	local var_29_1 = arg_29_0:_calculate_melee_range(arg_29_2, arg_29_7)
	local var_29_2 = arg_29_0:_is_in_melee_range(arg_29_4, arg_29_5, var_29_1, arg_29_6, arg_29_9, arg_29_3, arg_29_2) and Colors.get("green") or Colors.get("red")

	QuickDrawer:sphere(arg_29_4, var_29_0, var_29_2)

	local var_29_3 = Vector3(0, 0, 2.5)
	local var_29_4 = "player_1"
	local var_29_5 = 0
	local var_29_6 = arg_29_8 and Colors.get_table("green") or Colors.get_table("red")
	local var_29_7 = Vector3(var_29_6[2], var_29_6[3], var_29_6[4])
	local var_29_8 = 0.25
	local var_29_9 = string.format("%s %sm", arg_29_6, var_29_0)
	local var_29_10 = "bot_weapon_debug"
	local var_29_11 = Managers.state.debug_text

	var_29_11:clear_unit_text(arg_29_1, var_29_10)
	var_29_11:output_unit_text(var_29_9, var_29_8, arg_29_1, var_29_5, var_29_3, 0.5, var_29_10, var_29_7, var_29_4)

	local var_29_12 = var_29_3 + Vector3.up() * var_29_8
	local var_29_13 = arg_29_3.wielded_item_template.name

	var_29_11:output_unit_text(var_29_13, var_29_8, arg_29_1, var_29_5, var_29_12, 0.5, var_29_10, var_29_7, var_29_4)
end
