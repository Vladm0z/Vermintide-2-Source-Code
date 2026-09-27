-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_melee_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

BTBotMeleeAction = class(BTBotMeleeAction, BTNode)

BTBotMeleeAction.init = function (arg_1_0, ...)
	-- function 1
	BTBotMeleeAction.super.init(arg_1_0, ...)
end

BTBotMeleeAction.name = "BTBotMeleeAction"

local num = 50
local num_2 = 5
local num_3 = 0.5
local num_4 = 25

local function fn(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local num = arg_2_1 - Quaternion.rotate(Quaternion(Vector3.up(), arg_2_3), arg_2_2) * arg_2_4
	local triangle_from_position, var_2_2 = GwNavQueries.triangle_from_position(arg_2_0, num, 0.5, 0.5)

	if not triangle_from_position then
		num.z = var_2_2

		return true, num
	else
		return false
	end
end

local function fn_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local normalize = Vector3.normalize(Vector3.flat(arg_3_2))
	local var_3_1, var_3_2 = fn(arg_3_0, arg_3_1, normalize, 0, arg_3_3)

	if not var_3_1 then
		return var_3_2
	end

	local num = 3
	local num_2 = math.pi / (num + 1)

	for i = 1, num do
		local num_3 = num_2 * i
		local var_3_6, var_3_7 = fn(arg_3_0, arg_3_1, normalize, num_3, arg_3_3)
		local var_3_8 = var_3_7

		if not var_3_6 then
			return var_3_8
		end

		local var_3_9, var_3_10 = fn(arg_3_0, arg_3_1, normalize, -num_3, arg_3_3)
		local var_3_11 = var_3_10

		if not var_3_9 then
			return var_3_11
		end
	end

	local var_3_12, var_3_13 = fn(arg_3_0, arg_3_1, normalize, math.pi, arg_3_3)
	local var_3_14 = var_3_13

	if not var_3_12 then
		return var_3_14
	end

	return nil
end

BTBotMeleeAction.enter = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	arg_4_2.node_timer = arg_4_3
	arg_4_2.melee = {
		engage_update_time = 0,
		engage_position_set = false,
		engage_change_time = 0,
		engaging = false,
		engage_position = Vector3Box(0, 0, 0)
	}

	local inventory_extension = arg_4_2.inventory_extension
	local get_wielded_slot_name = inventory_extension:get_wielded_slot_name()
	local item_data = inventory_extension:get_slot_data(get_wielded_slot_name).item_data

	arg_4_2.wielded_item_template = BackendUtils.get_item_template(item_data)

	local input_extension = arg_4_2.input_extension
	local flag = true

	input_extension:set_aiming(true, flag)
end

BTBotMeleeAction.leave = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	arg_5_2.input_extension:set_aiming(false)

	if not arg_5_2.melee.engaging then
		self:_disengage(arg_5_1, arg_5_3, arg_5_2)
	end

	self:_clear_pending_attack(arg_5_2)

	if not self:_should_stop_attack_on_leave(arg_5_2) then
		self:_stop_attack(arg_5_2)
	end

	arg_5_2.wielded_item_template = nil
end

BTBotMeleeAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local _update_melee, var_6_1 = self:_update_melee(arg_6_1, arg_6_2, arg_6_4, arg_6_3)

	if not _update_melee then
		return "done", "evaluate"
	else
		local str = "running"
		local flag

		flag = not var_6_1 and "evaluate" and nil

		return str, flag
	end
end

BTBotMeleeAction._update_engage_position = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local nav_world = arg_7_3.nav_world
	local var_7_1 = POSITION_LOOKUP[arg_7_1]
	local _target_unit_position = self:_target_unit_position(var_7_1, arg_7_2, nav_world)
	local var_7_3
	local var_7_4
	local var_7_5
	local _is_targeting_me, var_7_7 = self:_is_targeting_me(arg_7_1, arg_7_2)
	local num = _target_unit_position - var_7_1
	local num_2 = arg_7_5 - 0.5
	local num_3 = num_2^2
	local has_extension = ScriptUnit.has_extension(arg_7_2, "locomotion_system")

	if not has_extension then
		local current_velocity = has_extension:current_velocity()

		if Vector3.length_squared(current_velocity) > 4 then
			num_2 = 0
			num_3 = 0
		end
	end

	if not var_7_7 and not _is_targeting_me and var_7_7.bots_flank_while_targeted or not var_7_7.bots_should_flank then
		local local_rotation = Unit.local_rotation(arg_7_2, 0)
		local forward = Quaternion.forward(local_rotation)

		if Vector3.dot(forward, num) > -0.25 then
			var_7_4 = num
		else
			local normalize = Vector3.normalize(Vector3.flat(forward))
			local normalize_2 = Vector3.normalize(Vector3.flat(num))
			local flat_angle = Vector3.flat_angle(-normalize_2, normalize)
			local var_7_18

			if flat_angle > 0 then
				var_7_18 = flat_angle + math.pi / 8
			else
				var_7_18 = flat_angle - math.pi / 8
			end

			local multiply = Quaternion.multiply(Quaternion(Vector3.up(), -var_7_18), local_rotation)

			var_7_4 = -Quaternion.forward(multiply)
		end

		var_7_3 = fn_2(nav_world, _target_unit_position, var_7_4, num_2)
	elseif num_3 >= Vector3.distance_squared(var_7_1, _target_unit_position) then
		var_7_3 = var_7_1
		var_7_5 = true
	else
		var_7_3 = fn_2(nav_world, _target_unit_position, num, num_2)
	end

	if not var_7_3 then
		local melee = arg_7_3.melee
		local navigation_destination_override = arg_7_3.navigation_destination_override
		local unbox = navigation_destination_override:unbox()
		local engage_position_set = melee.engage_position_set

		fassert(not engage_position_set and Vector3.is_valid(unbox))

		if not (not engage_position_set and not (Vector3.distance_squared(var_7_3, unbox) > 0.01)) then
			navigation_destination_override:store(var_7_3)

			melee.engage_position_set = true
			melee.stop_at_current_position = var_7_5
		end

		local distance = Vector3.distance(var_7_1, var_7_3)
		local num_4 = 3
		local num_5 = 7

		melee.engage_update_time = arg_7_4 + math.auto_lerp(num_4, num_5, 0.2, 2, math.clamp(distance, num_4, num_5))
	end
end

local tbl = {
	tap_attack = {
		arc = 0,
		max_range = num_2
	},
	hold_attack = {
		arc = 2,
		max_range = num_2
	}
}

BTBotMeleeAction._choose_attack = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0
	local var_8_1
	local wielded_slot_name = arg_8_1.wielded_slot_name
	local flag = not wielded_slot_name and arg_8_1.weapon_scores
	local flag_2 = not flag and flag[wielded_slot_name]

	if not flag_2 then
		var_8_0 = flag_2.input
		var_8_1 = flag_2.meta
	else
		local get_combat_conditions = AiUtils.get_combat_conditions(arg_8_1)
		local wielded_item_template = arg_8_1.wielded_item_template

		var_8_0, var_8_1 = AiUtils.get_melee_weapon_score(get_combat_conditions, wielded_item_template)
	end

	return var_8_0, var_8_1
end

BTBotMeleeAction._is_in_melee_range = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	local has_extension = ScriptUnit.has_extension(arg_9_7, "locomotion_system")
	local current_velocity

	if not has_extension then
		current_velocity = has_extension:current_velocity()

		if not current_velocity then
			-- Nothing
		end
	end

	current_velocity = Vector3.zero()

	::label_9_0::

	local num = arg_9_6.locomotion_extension:current_velocity() - current_velocity
	local max = math.max
	local _time_to_next_attack = self:_time_to_next_attack(arg_9_4, arg_9_6, arg_9_5)

	_time_to_next_attack = _time_to_next_attack or 0

	local num_2 = arg_9_1 + num * max(_time_to_next_attack, 0)

	return arg_9_3^2 > Vector3.distance_squared(arg_9_2, num_2)
end

BTBotMeleeAction._is_in_engage_range = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local get_party_danger = AiUtils.get_party_danger()
	local lerp = math.lerp(arg_10_4.engage_range_near_follow_pos, arg_10_4.engage_range_near_follow_pos_threat, get_party_danger)
	local lerp_2 = math.lerp(arg_10_4.engage_range, arg_10_4.engage_range_threat, get_party_danger)
	local var_10_3 = POSITION_LOOKUP[arg_10_1]
	local clamp = math.clamp(Vector3.distance_squared(arg_10_5, var_10_3) / num_4, 0, 1)
	local lerp_3 = math.lerp(lerp, lerp_2, clamp)
	local _target_unit_position = self:_target_unit_position(var_10_3, arg_10_2, arg_10_3)

	return Vector3.distance_squared(var_10_3, _target_unit_position) < lerp_3 * lerp_3
end

BTBotMeleeAction._target_unit_position = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local var_11_0

	if not self._tree_node.action_data.destroy_object then
		local system = Managers.state.entity:system("nav_graph_system")
		local get_smart_object_id = system:get_smart_object_id(arg_11_2)

		if not get_smart_object_id then
			local var_11_3 = system:get_smart_objects(get_smart_object_id)[1]
			local unbox = Vector3Aux.unbox(var_11_3.pos1)
			local unbox_2 = Vector3Aux.unbox(var_11_3.pos2)

			var_11_0 = math.closest_position(arg_11_1, unbox, unbox_2)
		else
			local str = "rp_center"
			local node

			if not Unit.has_node(arg_11_2, str) then
				node = Unit.node(arg_11_2, str)

				if not node then
					-- Nothing
				end
			end

			node = 0

			::label_11_0::

			local world_position = Unit.world_position(arg_11_2, node)

			var_11_0 = LocomotionUtils.pos_on_mesh(arg_11_3, world_position, 0.5, 2) or world_position
		end
	else
		var_11_0 = POSITION_LOOKUP[arg_11_2]
	end

	return var_11_0
end

BTBotMeleeAction._is_being_attacked = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local proximite_enemies = arg_12_2.proximite_enemies

	for i = 1, #proximite_enemies do
		repeat
			local var_12_1 = proximite_enemies[i]
			local var_12_2 = BLACKBOARDS[var_12_1]

			if not var_12_2 then
				break
			end

			local has_extension = ScriptUnit.has_extension(var_12_1, "buff_system")

			if not has_extension and not has_extension:has_buff_perk("ai_unblockable") then
				break
			end

			local attack_finished_t = var_12_2.attack_finished_t

			if not ((var_12_2.attack_finished or not attack_finished_t) and not (attack_finished_t < arg_12_3)) then
				break
			end

			local action = var_12_2.action

			if not (not action and action.unblockable or var_12_2.attacking_target ~= arg_12_1 or var_12_2.past_damage_in_attack) then
				return true
			end
		until true
	end

	return false
end

BTBotMeleeAction._is_targeting_me = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local has_extension = ScriptUnit.has_extension(arg_13_2, "ai_system")

	if not has_extension then
		return false
	end

	local blackboard = has_extension:blackboard()

	return blackboard.target_unit == arg_13_1, blackboard.breed
end

BTBotMeleeAction._allow_engage = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
	-- function 14
	local conflict = Managers.state.conflict
	local get_party_danger = AiUtils.get_party_danger()
	local override_engage_range_to_follow_pos = arg_14_4.override_engage_range_to_follow_pos
	local override_engage_range_to_follow_pos_threat = arg_14_4.override_engage_range_to_follow_pos_threat
	local lerp = math.lerp(override_engage_range_to_follow_pos, override_engage_range_to_follow_pos_threat, get_party_danger)
	local distance = Vector3.distance(arg_14_6, arg_14_7)
	local flag

	flag = not arg_14_5 and 3 and 0

	if lerp < distance - flag then
		return false
	end

	local target_ally_unit = arg_14_3.target_ally_unit
	local flag_2 = not arg_14_3.target_ally_need_type and target_ally_unit and arg_14_3.ai_bot_group_extension.data.follow_unit

	if not flag_2 then
		local get_player_unit_segment = conflict:get_player_unit_segment(arg_14_1)
		local get_player_unit_segment_2 = conflict:get_player_unit_segment(flag_2)

		if not (not get_player_unit_segment and not get_player_unit_segment_2 and not (get_player_unit_segment < get_player_unit_segment_2)) then
			return false
		end
	end

	local ai_extension = arg_14_3.ai_extension

	if not arg_14_3.target_ally_needs_aid and not Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(arg_14_1, target_ally_unit) then
		local has_extension = ScriptUnit.has_extension(arg_14_2, "ai_system")

		if not has_extension then
			return false
		end

		if not ai_extension:within_aid_range(arg_14_3) then
			return false
		end

		local force_aid = arg_14_3.force_aid
		local current_health_percent = ScriptUnit.extension(target_ally_unit, "health_system"):current_health_percent()
		local breed = has_extension:blackboard().breed
		local proximite_enemies = arg_14_3.proximite_enemies

		if not (not (current_health_percent > 0.3) or BTConditions.is_there_threat_to_aid(arg_14_1, proximite_enemies, force_aid)) then
			return false
		end

		if arg_14_2 ~= arg_14_3.urgent_target_enemy or not arg_14_3.revive_with_urgent_target then
			return false
		end
	end

	local priority_target_enemy = arg_14_3.priority_target_enemy

	if arg_14_2 == priority_target_enemy or not priority_target_enemy then
		return false
	end

	local should_stay_near_player, var_14_19 = ai_extension:should_stay_near_player()

	if not (not should_stay_near_player and not (var_14_19 < distance)) then
		return false
	end

	local system = Managers.state.entity:system("darkness_system")
	local var_14_21 = system
	local is_in_darkness = system.is_in_darkness
	local var_14_23 = POSITION_LOOKUP[arg_14_2]

	var_14_23 = var_14_23 or Unit.world_position(arg_14_2, 0)

	if not (not is_in_darkness(var_14_21, var_14_23, DarknessSystem.TOTAL_DARKNESS_THRESHOLD) and arg_14_2 == arg_14_3.breakable_object or arg_14_2 == priority_target_enemy or arg_14_2 == arg_14_3.urgent_target_enemy or arg_14_2 == arg_14_3.opportunity_target_enemy or arg_14_3.aggressive_mode or arg_14_3.target_ally_needs_aid) then
		return false
	end

	return true
end

BTBotMeleeAction._calculate_melee_range = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local max_range = arg_15_2.max_range
	local get_data = Unit.get_data(arg_15_1, "breed")
	local bot_hitbox_radius_approximation

	if not get_data then
		bot_hitbox_radius_approximation = get_data.bot_hitbox_radius_approximation

		if not bot_hitbox_radius_approximation then
			-- Nothing
		end

		bot_hitbox_radius_approximation = num_3

		if not bot_hitbox_radius_approximation then
			-- Nothing
		end
	end

	bot_hitbox_radius_approximation = 0

	::label_15_0::

	return max_range + bot_hitbox_radius_approximation
end

BTBotMeleeAction._update_melee = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local action_data = self._tree_node.action_data
	local breakable_object

	if not action_data.destroy_object then
		breakable_object = arg_16_2.breakable_object

		if not breakable_object then
			-- Nothing
		end
	end

	breakable_object = arg_16_2.target_unit

	::label_16_0::

	if not HEALTH_ALIVE[breakable_object] then
		return true
	end

	if not script_data.ai_bots_disable_player_melee_attacks then
		local var_16_2 = BLACKBOARDS[breakable_object]

		if not var_16_2 and not var_16_2.is_player then
			return false
		end
	end

	local bot_melee_aim_pos = AiUtils.bot_melee_aim_pos(arg_16_1, breakable_object)
	local input_extension = arg_16_2.input_extension

	input_extension:set_aim_position(bot_melee_aim_pos)

	local var_16_5
	local var_16_6
	local current_position = arg_16_2.first_person_extension:current_position()
	local unbox

	if not arg_16_2.follow then
		unbox = arg_16_2.follow.target_position:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = current_position

	::label_16_1::

	local _choose_attack, var_16_10 = self:_choose_attack(arg_16_2, breakable_object)
	local _calculate_melee_range = self:_calculate_melee_range(breakable_object, var_16_10)
	local flag = false
	local melee = arg_16_2.melee
	local engaging = melee.engaging

	if not self:_is_in_melee_range(current_position, bot_melee_aim_pos, _calculate_melee_range, _choose_attack, arg_16_4, arg_16_2, breakable_object) then
		if not self:_defend(arg_16_1, arg_16_2, breakable_object, input_extension, arg_16_4, true, arg_16_3) then
			self:_attack(_choose_attack, arg_16_2, arg_16_3)

			local flag_2 = true
		end

		var_16_5 = (arg_16_2.aggressive_mode or not melee.engaging) and arg_16_4 - melee.engage_change_time < 5
		var_16_6 = 2
	elseif not self:_is_in_engage_range(arg_16_1, breakable_object, arg_16_2.nav_world, action_data, unbox) then
		self:_defend(arg_16_1, arg_16_2, breakable_object, input_extension, arg_16_4, false, arg_16_3)

		var_16_5 = true
		var_16_6 = 1
	else
		self:_defend(arg_16_1, arg_16_2, breakable_object, input_extension, arg_16_4, false, arg_16_3)

		var_16_5 = not melee.engaging and arg_16_4 - melee.engage_change_time <= 0
		var_16_6 = 3
	end

	if not self:_is_starting_attack(arg_16_2) then
		var_16_6 = math.huge
	end

	local flag_3 = not var_16_5 and self:_allow_engage(arg_16_1, breakable_object, arg_16_2, action_data, engaging, bot_melee_aim_pos, unbox)

	if not (not flag_3 and engaging) then
		self:_engage(arg_16_4, arg_16_2)

		engaging = true
	elseif flag_3 or not engaging then
		self:_disengage(arg_16_1, arg_16_4, arg_16_2)

		engaging = false
	end

	if not (not engaging and not melee.engage_update_time and not (arg_16_4 > melee.engage_update_time) and action_data.do_not_update_engage_position) then
		self:_update_engage_position(arg_16_1, breakable_object, arg_16_2, arg_16_4, _calculate_melee_range)
	end

	return false, self:_evaluation_timer(arg_16_2, arg_16_4, var_16_6)
end

local tbl_2 = {
	push = "medium"
}

BTBotMeleeAction._defend = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	-- function 17
	local defense_meta_data = arg_17_2.wielded_item_template.defense_meta_data

	defense_meta_data = defense_meta_data or tbl_2

	local current_fatigue_points, var_17_2 = ScriptUnit.extension(arg_17_1, "status_system"):current_fatigue_points()
	local num = var_17_2 - current_fatigue_points
	local push = defense_meta_data.push
	local flag = (push ~= "light" or not (num <= 2)) and num <= 3
	local _is_being_attacked = self:_is_being_attacked(arg_17_1, arg_17_2, arg_17_5)
	local flag_2 = not not flag or push == "light" or self:_is_pushable_shield_wearer(arg_17_3)
	local flag_3 = _is_being_attacked or not flag_2 or self:_can_stagger_target(arg_17_1, arg_17_3, arg_17_2.wielded_item_template)

	if _is_being_attacked or not flag_2 or not flag_3 then
		self:_clear_pending_attack(arg_17_2)

		local count = #arg_17_2.proximite_enemies

		if not flag_3 and not arg_17_6 and push ~= "light" and not (count > 2) and not flag then
			arg_17_4:defend()
		else
			arg_17_4:melee_push()
		end

		if not script_data.ai_bots_debug_behavior then
			local ai_bots_debug_behavior_data = script_data.ai_bots_debug_behavior_data

			ai_bots_debug_behavior_data.time_spent_defending = ai_bots_debug_behavior_data.time_spent_defending + arg_17_7
		end

		return true
	else
		return false
	end
end

BTBotMeleeAction._is_pushable_shield_wearer = function (arg_18_0, arg_18_1)
	-- function 18
	local get_data = Unit.get_data(arg_18_1, "breed")

	if not get_data then
		return false
	end

	if get_data.name == "chaos_bulwark" then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_18_1, "ai_shield_system")

	return not has_extension and has_extension.is_blocking
end

BTBotMeleeAction._can_stagger_target = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not BLACKBOARDS[arg_19_2] then
		return
	end

	local get_wielded_slot_name = ScriptUnit.extension(arg_19_1, "inventory_system"):get_wielded_slot_name()
	local get_item_name = ScriptUnit.extension(arg_19_1, "inventory_system"):get_item_name(get_wielded_slot_name)

	if not get_item_name then
		return false
	end

	local flag = false
	local actions = arg_19_3.actions

	if not actions then
		-- Nothing
	end

	::label_19_0::

	local action_one = actions.action_one

	action_one = not action_one and actions.action_one.push

	::label_19_1::

	local flag_2 = not action_one and DamageProfileTemplates[action_one.damage_profile_inner]

	if not flag_2 then
		return false
	end

	local num = 1
	local attack_is_shield_blocked = AiUtils.attack_is_shield_blocked(arg_19_2, arg_19_1)
	local get_career_power_level = ScriptUnit.extension(arg_19_1, "career_system"):get_career_power_level()
	local var_19_9

	return DamageUtils.calculate_stagger_player(ImpactTypeOutput, arg_19_2, arg_19_1, "torso", get_career_power_level, var_19_9, flag, flag_2, num, attack_is_shield_blocked, get_item_name) ~= scripts_utils_stagger_types.none
end

BTBotMeleeAction._time_to_next_attack = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local get_bot_weapon_extension = AiUtils.get_bot_weapon_extension(arg_20_2)

	if not get_bot_weapon_extension then
		local wielded_item_template = arg_20_2.wielded_item_template
		local attack_meta_data = wielded_item_template.attack_meta_data

		attack_meta_data = attack_meta_data or tbl

		local var_20_3 = attack_meta_data[arg_20_1]

		return get_bot_weapon_extension:time_to_next_attack(arg_20_1, wielded_item_template.actions, wielded_item_template.name, arg_20_3, var_20_3.attack_chain)
	end
end

BTBotMeleeAction._attack = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local get_bot_weapon_extension = AiUtils.get_bot_weapon_extension(arg_21_2)

	if not get_bot_weapon_extension then
		local wielded_item_template = arg_21_2.wielded_item_template
		local attack_meta_data = wielded_item_template.attack_meta_data

		attack_meta_data = attack_meta_data or tbl

		local var_21_3 = attack_meta_data[arg_21_1]

		get_bot_weapon_extension:request_bot_attack_action(arg_21_1, wielded_item_template.actions, wielded_item_template.name, var_21_3.attack_chain)

		if not script_data.ai_bots_debug_behavior then
			local ai_bots_debug_behavior_data = script_data.ai_bots_debug_behavior_data

			if arg_21_1 == "tap_attack" then
				ai_bots_debug_behavior_data.time_in_light_attack = ai_bots_debug_behavior_data.time_in_light_attack + arg_21_3
			elseif arg_21_1 == "hold_attack" then
				ai_bots_debug_behavior_data.time_in_heavy_attack = ai_bots_debug_behavior_data.time_in_heavy_attack + arg_21_3
			end

			ai_bots_debug_behavior_data.time_spent_attacking = ai_bots_debug_behavior_data.time_spent_attacking + arg_21_3
		end
	end
end

BTBotMeleeAction._should_stop_attack_on_leave = function (arg_22_0, arg_22_1)
	-- function 22
	local get_bot_weapon_extension = AiUtils.get_bot_weapon_extension(arg_22_1)

	if not get_bot_weapon_extension then
		return get_bot_weapon_extension:bot_should_stop_attack_on_leave()
	end
end

BTBotMeleeAction._stop_attack = function (arg_23_0, arg_23_1)
	-- function 23
	local get_bot_weapon_extension = AiUtils.get_bot_weapon_extension(arg_23_1)

	if not get_bot_weapon_extension then
		get_bot_weapon_extension:stop_action()
	end
end

BTBotMeleeAction._clear_pending_attack = function (arg_24_0, arg_24_1)
	-- function 24
	local get_bot_weapon_extension = AiUtils.get_bot_weapon_extension(arg_24_1)

	if not get_bot_weapon_extension then
		get_bot_weapon_extension:clear_bot_attack_request()
	end
end

BTBotMeleeAction._is_starting_attack = function (arg_25_0, arg_25_1)
	-- function 25
	local get_bot_weapon_extension = AiUtils.get_bot_weapon_extension(arg_25_1)

	if not get_bot_weapon_extension then
		return get_bot_weapon_extension:is_starting_attack()
	else
		return false
	end
end

BTBotMeleeAction._evaluation_timer = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	if not (arg_26_3 < arg_26_2 - arg_26_1.node_timer) then
		arg_26_1.node_timer = arg_26_2

		return true
	else
		return false
	end
end

BTBotMeleeAction._disengage = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local melee = arg_27_3.melee

	melee.engaging = false
	melee.engage_change_time = arg_27_2

	if not arg_27_3.follow then
		melee.engage_position_set = false
	end
end

BTBotMeleeAction._engage = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local melee = arg_28_2.melee

	melee.engaging = true
	melee.engage_change_time = arg_28_1
end

BTBotMeleeAction._debug_draw_melee_range = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9)
	-- function 29
	local max_range = arg_29_7.max_range
	local _calculate_melee_range = self:_calculate_melee_range(arg_29_2, arg_29_7)
	local get

	if not self:_is_in_melee_range(arg_29_4, arg_29_5, _calculate_melee_range, arg_29_6, arg_29_9, arg_29_3, arg_29_2) then
		get = Colors.get("green")

		if not get then
			-- Nothing
		end
	end

	get = Colors.get("red")

	::label_29_0::

	QuickDrawer:sphere(arg_29_4, max_range, get)

	local var_29_3 = Vector3(0, 0, 2.5)
	local str = "player_1"
	local num = 0
	local get_table

	if not arg_29_8 then
		get_table = Colors.get_table("green")

		if not get_table then
			-- Nothing
		end
	end

	get_table = Colors.get_table("red")

	::label_29_1::

	local var_29_7 = Vector3(get_table[2], get_table[3], get_table[4])
	local num_2 = 0.25
	local format = string.format("%s %sm", arg_29_6, max_range)
	local str_2 = "bot_weapon_debug"
	local debug_text = Managers.state.debug_text

	debug_text:clear_unit_text(arg_29_1, str_2)
	debug_text:output_unit_text(format, num_2, arg_29_1, num, var_29_3, 0.5, str_2, var_29_7, str)

	local num_3 = var_29_3 + Vector3.up() * num_2
	local name = arg_29_3.wielded_item_template.name

	debug_text:output_unit_text(name, num_2, arg_29_1, num, num_3, 0.5, str_2, var_29_7, str)
end
