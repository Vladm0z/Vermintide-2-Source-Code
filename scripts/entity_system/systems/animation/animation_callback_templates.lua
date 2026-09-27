-- chunkname: @scripts/entity_system/systems/animation/animation_callback_templates.lua

local BLACKBOARDS = BLACKBOARDS
local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

AnimationCallbackTemplates = {}
AnimationCallbackTemplates.client = {}

AnimationCallbackTemplates.client.anim_cb_enable_second_hit_ragdoll = function (arg_1_0, arg_1_1)
	-- function 1
	ScriptUnit.extension(arg_1_0, "death_system"):enable_second_hit_ragdoll()
end

AnimationCallbackTemplates.client.anim_cb_push_finished = function (arg_2_0, arg_2_1)
	-- function 2
	local has_extension = ScriptUnit.has_extension(arg_2_0, "status_system")

	if not has_extension then
		has_extension:set_stagger_animation_done(true)
	end
end

AnimationCallbackTemplates.server = {}

AnimationCallbackTemplates.server.anim_cb_spawn_finished = function (arg_3_0, arg_3_1)
	-- function 3
	BLACKBOARDS[arg_3_0].spawning_finished = true
end

AnimationCallbackTemplates.server.anim_cb_push_finished = function (arg_4_0, arg_4_1)
	-- function 4
	BLACKBOARDS[arg_4_0].stagger_anim_done = true
end

AnimationCallbackTemplates.server.anim_cb_stunned_finished = function (arg_5_0, arg_5_1)
	-- function 5
	BLACKBOARDS[arg_5_0].blocked = nil
end

AnimationCallbackTemplates.server.anim_cb_stagger_light_finished = function (arg_6_0, arg_6_1)
	-- function 6
	if not ALIVE[arg_6_0] then
		return
	end

	local get_data = Unit.get_data(arg_6_0, "breed")
	local var_6_1 = BLACKBOARDS[arg_6_0]

	if not get_data.handle_stagger_anim_cb then
		get_data.handle_stagger_anim_cb(arg_6_0, var_6_1, "anim_cb_stagger_light_finished")
	end
end

AnimationCallbackTemplates.server.anim_cb_stagger_medium_finished = function (arg_7_0, arg_7_1)
	-- function 7
	if not ALIVE[arg_7_0] then
		return
	end

	local get_data = Unit.get_data(arg_7_0, "breed")
	local var_7_1 = BLACKBOARDS[arg_7_0]

	if not get_data.handle_stagger_anim_cb then
		get_data.handle_stagger_anim_cb(arg_7_0, var_7_1, "anim_cb_stagger_medium_finished")
	end
end

AnimationCallbackTemplates.server.anim_cb_stagger_heavy_finished = function (arg_8_0, arg_8_1)
	-- function 8
	if not ALIVE[arg_8_0] then
		return
	end

	local get_data = Unit.get_data(arg_8_0, "breed")
	local var_8_1 = BLACKBOARDS[arg_8_0]

	if not get_data.handle_stagger_anim_cb then
		get_data.handle_stagger_anim_cb(arg_8_0, var_8_1, "anim_cb_stagger_heavy_finished")
	end
end

AnimationCallbackTemplates.server.anim_cb_tp_end_enter = function (arg_9_0, arg_9_1)
	-- function 9
	local var_9_0 = BLACKBOARDS[arg_9_0]

	if not var_9_0.active_node and not var_9_0.active_node.anim_cb_tp_end_enter then
		var_9_0.active_node:anim_cb_tp_end_enter(arg_9_0, var_9_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_hesitate_finished = function (arg_10_0, arg_10_1)
	-- function 10
	local var_10_0 = BLACKBOARDS[arg_10_0]

	if not var_10_0.active_node and not var_10_0.active_node.anim_cb_hesitate_finished then
		var_10_0.active_node:anim_cb_hesitate_finished(arg_10_0, var_10_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_emote_finished = function (arg_11_0, arg_11_1)
	-- function 11
	local var_11_0 = BLACKBOARDS[arg_11_0]

	if not var_11_0.active_node and not var_11_0.active_node.anim_cb_emote_finished then
		var_11_0.active_node:anim_cb_emote_finished(arg_11_0, var_11_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_direct_damage = function (arg_12_0, arg_12_1)
	-- function 12
	local var_12_0 = BLACKBOARDS[arg_12_0]

	if not Unit.alive(var_12_0.target_unit) then
		return
	end

	if not var_12_0.action then
		return
	end

	local active_node = var_12_0.active_node

	if not active_node and not active_node.direct_damage then
		active_node.direct_damage(arg_12_0, var_12_0)
	end

	var_12_0.attacks_done = var_12_0.attacks_done + 1
end

local num = 0
local num_2 = 0.6
local num_3 = 0.3

AnimationCallbackTemplates.server.anim_cb_damage = function (arg_13_0, arg_13_1)
	-- function 13
	local var_13_0 = BLACKBOARDS[arg_13_0]
	local target_unit

	if not var_13_0.smash_door then
		target_unit = var_13_0.smash_door.target_unit

		if not target_unit then
			-- Nothing
		end
	end

	target_unit = var_13_0.attacking_target
	target_unit = target_unit or var_13_0.drag_target_unit

	::label_13_0::

	local action = var_13_0.action

	if not action then
		return
	end

	if not action.damage then
		return
	end

	local combo_attack_data = var_13_0.combo_attack_data

	if not combo_attack_data and not action.combo_attacks and not action.combo_attacks[combo_attack_data.current_attack_name].no_abort_attack then
		var_13_0.attack_aborted = false
	end

	if not var_13_0.active_node and not var_13_0.active_node.attack_cooldown then
		var_13_0.active_node:attack_cooldown(arg_13_0, var_13_0)
	end

	if not var_13_0.attack_aborted then
		return
	end

	if not var_13_0.buff_extension then
		var_13_0.buff_extension:trigger_procs("minion_attack_used")
	end

	if not var_13_0.active_node and not var_13_0.active_node.anim_cb_damage then
		var_13_0.active_node:anim_cb_damage(arg_13_0, var_13_0)

		return
	end

	var_13_0.anim_cb_damage = true

	if not (not Unit.alive(target_unit) and Unit.alive(arg_13_0)) then
		return
	end

	if not ((var_13_0.has_line_of_sight == false or not DamageUtils.check_distance(action, var_13_0, arg_13_0, target_unit)) and DamageUtils.check_infront(arg_13_0, target_unit)) then
		return
	end

	local attack_directions = action.attack_directions

	attack_directions = not attack_directions and action.attack_directions[var_13_0.attack_anim]

	if action.unblockable or not DamageUtils.check_block(arg_13_0, target_unit, action.fatigue_type, attack_directions) then
		if not var_13_0.active_node and not var_13_0.active_node.attack_blocked then
			var_13_0.active_node:attack_blocked(arg_13_0, var_13_0, attack_directions)
		end

		local time = Managers.time:time("game")
		local var_13_6 = BLACKBOARDS[target_unit]

		if not var_13_6.is_player then
			local var_13_7 = BLACKBOARDS[arg_13_0]
			local var_13_8 = POSITION_LOOKUP[arg_13_0]

			var_13_8 = var_13_8 or Unit.world_position(arg_13_0, 0)

			local var_13_9 = POSITION_LOOKUP[target_unit]

			var_13_9 = var_13_9 or Unit.local_position(target_unit, 0)

			local normalize = Vector3.normalize(var_13_9 - var_13_8)
			local calculate_ai_stagger_strength = AiUtils.calculate_ai_stagger_strength(var_13_7, var_13_6, time, true, scripts_utils_stagger_types.medium, 0.25)

			if calculate_ai_stagger_strength == scripts_utils_stagger_types.none then
				calculate_ai_stagger_strength = scripts_utils_stagger_types.weak
			elseif calculate_ai_stagger_strength == scripts_utils_stagger_types.heavy then
				calculate_ai_stagger_strength = scripts_utils_stagger_types.medium
			end

			local calculate_ai_stagger_impact, var_13_13 = AiUtils.calculate_ai_stagger_impact(calculate_ai_stagger_strength)

			AiUtils.stagger_target(arg_13_0, target_unit, var_13_13, calculate_ai_stagger_impact, normalize, time, nil, nil, nil, true)
		end

		return
	end

	AiUtils.damage_target(target_unit, arg_13_0, action, action.damage)

	if not var_13_0.active_node and not var_13_0.active_node.attack_success then
		var_13_0.active_node:attack_success(arg_13_0, var_13_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_special_damage = function (arg_14_0, arg_14_1)
	-- function 14
	local var_14_0 = BLACKBOARDS[arg_14_0]
	local action = var_14_0.action

	if not (not action and action.damage) then
		return
	end

	if not var_14_0.attack_aborted then
		return
	end

	if not var_14_0.buff_extension then
		var_14_0.buff_extension:trigger_procs("minion_attack_used")
	end

	if not var_14_0.active_node and not var_14_0.active_node.anim_cb_damage then
		var_14_0.active_node:anim_cb_damage(arg_14_0, var_14_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_reset_attack_animation_locked = function (arg_15_0, arg_15_1)
	-- function 15
	ScriptUnit.extension(arg_15_0, "ai_system"):blackboard().reset_attack_animation_locked = true
end

AnimationCallbackTemplates.server.anim_cb_unlink_unit = function (arg_16_0, arg_16_1)
	-- function 16
	ScriptUnit.extension(arg_16_0, "ai_system"):blackboard().unlink_unit = true
end

AnimationCallbackTemplates.server.anim_cb_mounted_knocked_off = function (arg_17_0, arg_17_1)
	-- function 17
	local blackboard = ScriptUnit.extension(arg_17_0, "ai_system"):blackboard()

	blackboard.knocked_off_mount = true

	local locomotion_extension = blackboard.locomotion_extension

	LocomotionUtils.set_animation_driven_movement(arg_17_0, false, false, true)
	locomotion_extension:use_lerp_rotation(true)
	locomotion_extension:set_movement_type("snap_to_navmesh")
end

AnimationCallbackTemplates.server.anim_cb_mounting_finished = function (arg_18_0, arg_18_1)
	-- function 18
	ScriptUnit.extension(arg_18_0, "ai_system"):blackboard().mounting_finished = true
end

AnimationCallbackTemplates.server.anim_cb_frenzy_damage = function (arg_19_0, arg_19_1)
	-- function 19
	local var_19_0 = BLACKBOARDS[arg_19_0]
	local action = var_19_0.action

	if not (not action and action.damage) then
		return
	end

	if not var_19_0.attack_aborted then
		return
	end

	if not var_19_0.active_node and not var_19_0.active_node.attack_cooldown then
		var_19_0.active_node:attack_cooldown(arg_19_0, var_19_0)
	end

	local active_node = var_19_0.active_node

	if not active_node and not active_node.anim_cb_frenzy_damage then
		active_node:anim_cb_frenzy_damage(arg_19_0, var_19_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_vce = function (arg_20_0, arg_20_1)
	-- function 20
	local var_20_0 = BLACKBOARDS[arg_20_0]
	local action = var_20_0.action

	if not var_20_0.attack_aborted then
		return
	end

	local active_node = var_20_0.active_node

	if not active_node and not active_node.anim_cb_attack_vce then
		active_node:anim_cb_attack_vce(arg_20_0, var_20_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_vce_long = function (arg_21_0, arg_21_1)
	-- function 21
	local var_21_0 = BLACKBOARDS[arg_21_0]
	local action = var_21_0.action

	if not var_21_0.attack_aborted then
		return
	end

	local active_node = var_21_0.active_node

	if not active_node and not active_node.anim_cb_attack_vce_long then
		active_node:anim_cb_attack_vce_long(arg_21_0, var_21_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_shout_vo = function (arg_22_0, arg_22_1)
	-- function 22
	local var_22_0 = BLACKBOARDS[arg_22_0]
	local active_node = var_22_0.active_node

	if not active_node and not active_node.anim_cb_shout_vo then
		active_node:anim_cb_shout_vo(arg_22_0, var_22_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_combo_damage = function (arg_23_0, arg_23_1)
	-- function 23
	local var_23_0 = BLACKBOARDS[arg_23_0]
	local action = var_23_0.action

	if not (not action and action.damage) then
		return
	end

	if not var_23_0.attack_aborted then
		return
	end

	local active_node = var_23_0.active_node

	if not active_node and not active_node.anim_cb_combo_damage then
		active_node.anim_cb_combo_damage(arg_23_0, var_23_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_rotation_start = function (arg_24_0, arg_24_1)
	-- function 24
	BLACKBOARDS[arg_24_0].anim_cb_rotation_start = true
end

AnimationCallbackTemplates.server.anim_cb_rotation_stop = function (arg_25_0, arg_25_1)
	-- function 25
	BLACKBOARDS[arg_25_0].anim_cb_rotation_stop = true
end

AnimationCallbackTemplates.server.anim_cb_picked_up_standard = function (arg_26_0, arg_26_1)
	-- function 26
	BLACKBOARDS[arg_26_0].anim_cb_picked_up_standard = true
end

AnimationCallbackTemplates.server.anim_cb_running_attack_start = function (arg_27_0, arg_27_1)
	-- function 27
	local var_27_0 = BLACKBOARDS[arg_27_0]

	if not var_27_0.active_node and not var_27_0.active_node.anim_cb_running_attack_start then
		var_27_0.active_node:anim_cb_running_attack_start(arg_27_0, var_27_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_running_attack_end = function (arg_28_0, arg_28_1)
	-- function 28
	local var_28_0 = BLACKBOARDS[arg_28_0]

	if not var_28_0.active_node and not var_28_0.active_node.anim_cb_running_attack_end then
		var_28_0.active_node:anim_cb_running_attack_end(arg_28_0, var_28_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_death_finished = function (arg_29_0, arg_29_1)
	-- function 29
	BLACKBOARDS[arg_29_0].anim_cb_death_finished = true
end

AnimationCallbackTemplates.server.anim_cb_move = function (arg_30_0, arg_30_1)
	-- function 30
	local var_30_0 = BLACKBOARDS[arg_30_0]
	local active_node = var_30_0.active_node

	var_30_0.anim_cb_move = true

	if not active_node and not var_30_0.attack_aborted then
		return
	end

	local anim_cb_move = active_node.anim_cb_move

	if not anim_cb_move then
		anim_cb_move(anim_cb_move, arg_30_0, var_30_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_move_stop = function (arg_31_0, arg_31_1)
	-- function 31
	BLACKBOARDS[arg_31_0].anim_cb_move_stop = true
end

AnimationCallbackTemplates.server.anim_cb_transform_finished = function (arg_32_0, arg_32_1)
	-- function 32
	local var_32_0 = BLACKBOARDS[arg_32_0]
	local active_node = var_32_0.active_node
	local flag = not active_node and active_node.anim_cb_transform_finished

	if not flag then
		flag(flag, arg_32_0, var_32_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_throw_weapon = function (arg_33_0, arg_33_1)
	-- function 33
	local var_33_0 = BLACKBOARDS[arg_33_0]
	local anim_cb_throw_weapon = var_33_0.active_node.anim_cb_throw_weapon

	if not anim_cb_throw_weapon then
		anim_cb_throw_weapon(anim_cb_throw_weapon, arg_33_0, var_33_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_throw_finished = function (arg_34_0, arg_34_1)
	-- function 34
	local var_34_0 = BLACKBOARDS[arg_34_0]
	local active_node = var_34_0.active_node
	local flag = not active_node and active_node.anim_cb_throw_finished

	if not flag then
		flag(flag, arg_34_0, var_34_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_charge_start_finished = function (arg_35_0, arg_35_1)
	-- function 35
	local var_35_0 = BLACKBOARDS[arg_35_0]
	local active_node = var_35_0.active_node

	if not active_node and not active_node.anim_cb_charge_start_finished then
		active_node:anim_cb_charge_start_finished(arg_35_0, var_35_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_charge_charging_finished = function (arg_36_0, arg_36_1)
	-- function 36
	local var_36_0 = BLACKBOARDS[arg_36_0]
	local active_node = var_36_0.active_node

	if not active_node and not active_node.anim_cb_charge_charging_finished then
		active_node:anim_cb_charge_charging_finished(arg_36_0, var_36_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_charge_impact_finished = function (arg_37_0, arg_37_1)
	-- function 37
	local var_37_0 = BLACKBOARDS[arg_37_0]
	local active_node = var_37_0.active_node

	if not active_node and not active_node.anim_cb_charge_impact_finished then
		active_node:anim_cb_charge_impact_finished(arg_37_0, var_37_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_disable_charge_collision = function (arg_38_0, arg_38_1)
	-- function 38
	local var_38_0 = BLACKBOARDS[arg_38_0]
	local active_node = var_38_0.active_node

	if not active_node and not active_node.anim_cb_disable_charge_collision then
		active_node:anim_cb_disable_charge_collision(arg_38_0, var_38_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_throw = function (arg_39_0, arg_39_1)
	-- function 39
	BLACKBOARDS[arg_39_0].anim_cb_throw = true
end

AnimationCallbackTemplates.server.anim_cb_spawn_projectile = function (arg_40_0, arg_40_1)
	-- function 40
	BLACKBOARDS[arg_40_0].anim_cb_spawn_projectile = true
end

AnimationCallbackTemplates.server.anim_cb_jump_start_finished = function (arg_41_0, arg_41_1)
	-- function 41
	BLACKBOARDS[arg_41_0].jump_start_finished = true
end

AnimationCallbackTemplates.server.anim_cb_jump_climb_finished = function (arg_42_0, arg_42_1)
	-- function 42
	BLACKBOARDS[arg_42_0].jump_climb_finished = true
end

AnimationCallbackTemplates.server.anim_cb_start_finished = function (arg_43_0, arg_43_1)
	-- function 43
	BLACKBOARDS[arg_43_0].start_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_start = function (arg_44_0, arg_44_1)
	-- function 44
	local var_44_0 = BLACKBOARDS[arg_44_0]
	local active_node = var_44_0.active_node

	if not active_node and not var_44_0.attack_aborted then
		return
	end

	local anim_cb_attack_start = active_node.anim_cb_attack_start

	if not anim_cb_attack_start then
		anim_cb_attack_start(anim_cb_attack_start, arg_44_0, var_44_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_finished = function (arg_45_0, arg_45_1)
	-- function 45
	local var_45_0 = BLACKBOARDS[arg_45_0]

	if not var_45_0.active_node and not var_45_0.active_node.anim_cb_attack_finished then
		local anim_cb_attack_finished = var_45_0.active_node.anim_cb_attack_finished

		anim_cb_attack_finished(anim_cb_attack_finished, arg_45_0, var_45_0)
	else
		var_45_0.attacks_done = var_45_0.attacks_done + 1
		var_45_0.attack_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_escape_finished = function (arg_46_0, arg_46_1)
	-- function 46
	BLACKBOARDS[arg_46_0].anim_cb_escape_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_cooldown = function (arg_47_0, arg_47_1)
	-- function 47
	BLACKBOARDS[arg_47_0].anim_cb_attack_cooldown = true
end

AnimationCallbackTemplates.server.anim_cb_blocked_cooldown = function (arg_48_0, arg_48_1)
	-- function 48
	BLACKBOARDS[arg_48_0].anim_cb_blocked_cooldown = true
end

AnimationCallbackTemplates.server.anim_cb_summoning_finished = function (arg_49_0, arg_49_1)
	-- function 49
	BLACKBOARDS[arg_49_0].summoning_finished = true
end

AnimationCallbackTemplates.server.anim_cb_shout_finished = function (arg_50_0, arg_50_1)
	-- function 50
	BLACKBOARDS[arg_50_0].anim_cb_shout_finished = true
end

AnimationCallbackTemplates.server.anim_cb_order_finished = function (arg_51_0, arg_51_1)
	-- function 51
	BLACKBOARDS[arg_51_0].anim_cb_order_finished = true
end

AnimationCallbackTemplates.server.anim_cb_scurry_under_finished = function (arg_52_0, arg_52_1)
	-- function 52
	BLACKBOARDS[arg_52_0].anim_cb_scurry_under_finished = true
end

AnimationCallbackTemplates.server.anim_cb_dig_finished = function (arg_53_0, arg_53_1)
	-- function 53
	BLACKBOARDS[arg_53_0].anim_cb_dig_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_throw_score_finished = function (arg_54_0, arg_54_1)
	-- function 54
	local has_extension = ScriptUnit.has_extension(arg_54_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().anim_cb_attack_throw_score_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_jump_start_finished = function (arg_55_0, arg_55_1)
	-- function 55
	local has_extension = ScriptUnit.has_extension(arg_55_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().anim_cb_attack_jump_start_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_shoot_start_finished = function (arg_56_0, arg_56_1)
	-- function 56
	local has_extension = ScriptUnit.has_extension(arg_56_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().anim_cb_attack_shoot_start_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_reload_start_finished = function (arg_57_0, arg_57_1)
	-- function 57
	local has_extension = ScriptUnit.has_extension(arg_57_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().anim_cb_reload_start_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_windup_start_finished = function (arg_58_0, arg_58_1)
	-- function 58
	local has_extension = ScriptUnit.has_extension(arg_58_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().anim_cb_attack_windup_start_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_shoot_random_shot = function (arg_59_0, arg_59_1)
	-- function 59
	local has_extension = ScriptUnit.has_extension(arg_59_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().anim_cb_attack_shoot_random_shot = true
	end
end

AnimationCallbackTemplates.server.anim_cb_stormvermin_voice = function (arg_60_0, arg_60_1)
	-- function 60
	local has_extension = ScriptUnit.has_extension(arg_60_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().anim_cb_stormvermin_voice = true
	end
end

AnimationCallbackTemplates.server.anim_cb_patrol_sound = function (arg_61_0, arg_61_1)
	-- function 61
	local has_extension = ScriptUnit.has_extension(arg_61_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().anim_cb_patrol_sound = true
	end
end

AnimationCallbackTemplates.server.anim_cb_exit_shooting_hit_react = function (arg_62_0, arg_62_1)
	-- function 62
	local has_extension = ScriptUnit.has_extension(arg_62_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().in_hit_reaction = nil
	end
end

AnimationCallbackTemplates.server.anim_cb_enter_shooting_hit_react = function (arg_63_0, arg_63_1)
	-- function 63
	local has_extension = ScriptUnit.has_extension(arg_63_0, "ai_system")

	if not has_extension then
		has_extension:blackboard().in_hit_reaction = true
	end
end

AnimationCallbackTemplates.server.anim_cb_place_standard = function (arg_64_0, arg_64_1)
	-- function 64
	local var_64_0 = BLACKBOARDS[arg_64_0]
	local active_node = var_64_0.active_node

	if not active_node then
		local anim_cb_place_standard = active_node.anim_cb_place_standard

		if not anim_cb_place_standard then
			anim_cb_place_standard(active_node, arg_64_0, var_64_0)
		end
	end
end

AnimationCallbackTemplates.server.anim_cb_pick_up_standard = function (arg_65_0, arg_65_1)
	-- function 65
	local var_65_0 = BLACKBOARDS[arg_65_0]
	local active_node = var_65_0.active_node

	if not active_node then
		local anim_cb_pick_up_standard = active_node.anim_cb_pick_up_standard

		if not anim_cb_pick_up_standard then
			anim_cb_pick_up_standard(active_node, arg_65_0, var_65_0)
		end
	end
end

AnimationCallbackTemplates.server.anim_cb_placed_standard = function (arg_66_0, arg_66_1)
	-- function 66
	local var_66_0 = BLACKBOARDS[arg_66_0]
	local active_node = var_66_0.active_node
	local flag = not active_node and active_node.anim_cb_placed_standard

	if not flag then
		flag(active_node, arg_66_0, var_66_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_stormvermin_push = function (arg_67_0, arg_67_1)
	-- function 67
	local var_67_0 = BLACKBOARDS[arg_67_0]
	local attacking_target = var_67_0.attacking_target
	local active_node = var_67_0.active_node

	if not (not active_node and var_67_0.attack_aborted or HEALTH_ALIVE[attacking_target]) then
		return
	end

	local anim_cb_stormvermin_push = active_node.anim_cb_stormvermin_push

	if not anim_cb_stormvermin_push then
		anim_cb_stormvermin_push(active_node, arg_67_0, var_67_0, attacking_target)
	end
end

AnimationCallbackTemplates.server.anim_cb_stormvermin_push_finished = function (arg_68_0, arg_68_1)
	-- function 68
	BLACKBOARDS[arg_68_0].attack_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_overlap_done = function (arg_69_0, arg_69_1)
	-- function 69
	local var_69_0 = BLACKBOARDS[arg_69_0]
	local active_node = var_69_0.active_node

	if not active_node and not var_69_0.attack_aborted then
		return
	end

	local anim_cb_attack_overlap_done = active_node.anim_cb_attack_overlap_done

	if not anim_cb_attack_overlap_done then
		anim_cb_attack_overlap_done(active_node, arg_69_0, var_69_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_vomit = function (arg_70_0, arg_70_1)
	-- function 70
	local var_70_0 = BLACKBOARDS[arg_70_0]
	local active_node = var_70_0.active_node

	if not active_node and not var_70_0.attack_aborted then
		return
	end

	local anim_cb_vomit = active_node.anim_cb_vomit

	if not anim_cb_vomit then
		anim_cb_vomit(anim_cb_vomit, arg_70_0, var_70_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_vomit_end = function (arg_71_0, arg_71_1)
	-- function 71
	BLACKBOARDS[arg_71_0].is_puking = nil
end

AnimationCallbackTemplates.server.anim_cb_dodge_finished = function (arg_72_0, arg_72_1)
	-- function 72
	BLACKBOARDS[arg_72_0].anim_cb_dodge_finished = true
end

AnimationCallbackTemplates.server.anim_cb_downed_end_finished = function (arg_73_0, arg_73_1)
	-- function 73
	BLACKBOARDS[arg_73_0].downed_end_finished = true
end

AnimationCallbackTemplates.server.anim_cb_rage_finished = function (arg_74_0, arg_74_1)
	-- function 74
	BLACKBOARDS[arg_74_0].rage_end_finished = true
end

AnimationCallbackTemplates.server.anim_cb_roar_begin = function (arg_75_0, arg_75_1)
	-- function 75
	BLACKBOARDS[arg_75_0].anim_cb_roar_begin = true
end

AnimationCallbackTemplates.server.anim_cb_roar_end = function (arg_76_0, arg_76_1)
	-- function 76
	BLACKBOARDS[arg_76_0].anim_cb_roar_end = true
end

AnimationCallbackTemplates.server.anim_cb_landing_finished = function (arg_77_0, arg_77_1)
	-- function 77
	BLACKBOARDS[arg_77_0].landing_finished = true
end

AnimationCallbackTemplates.server.anim_cb_teleport_finished = function (arg_78_0, arg_78_1)
	-- function 78
	BLACKBOARDS[arg_78_0].anim_cb_teleport_finished = true
end

AnimationCallbackTemplates.server.anim_cb_teleport_start_finished = function (arg_79_0, arg_79_1)
	-- function 79
	local var_79_0 = BLACKBOARDS[arg_79_0]
	local active_node = var_79_0.active_node

	if not active_node and not active_node.anim_cb_teleport_start_finished then
		active_node:anim_cb_teleport_start_finished(arg_79_0, var_79_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_teleport_end_finished = function (arg_80_0, arg_80_1)
	-- function 80
	local var_80_0 = BLACKBOARDS[arg_80_0]
	local active_node = var_80_0.active_node

	if not active_node and not active_node.anim_cb_teleport_end_finished then
		active_node:anim_cb_teleport_end_finished(arg_80_0, var_80_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_move_jump_finished = function (arg_81_0, arg_81_1)
	-- function 81
	local var_81_0 = BLACKBOARDS[arg_81_0]
	local active_node = var_81_0.active_node

	if not active_node and not active_node.anim_cb_move_jump_finished then
		active_node:anim_cb_move_jump_finished(arg_81_0, var_81_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_stagger_immune = function (arg_82_0, arg_82_1)
	-- function 82
	BLACKBOARDS[arg_82_0].anim_cb_stagger_immune = true
end

AnimationCallbackTemplates.server.anim_cb_push_cancel = function (arg_83_0, arg_83_1)
	-- function 83
	local var_83_0 = BLACKBOARDS[arg_83_0]
	local active_node = var_83_0.active_node

	if not active_node and not active_node.anim_cb_push_cancel then
		active_node:anim_cb_push_cancel(arg_83_0, var_83_0)
	end
end

AnimationCallbackTemplates.server.anim_cb_disable_invincibility = function (arg_84_0, arg_84_1)
	-- function 84
	local has_extension = ScriptUnit.has_extension(arg_84_0, "health_system")

	if not has_extension then
		has_extension.is_invincible = false
	end
end

AnimationCallbackTemplates.server.anim_cb_combat_step_stop = function (arg_85_0, arg_85_1)
	-- function 85
	local var_85_0 = BLACKBOARDS[arg_85_0]

	if not var_85_0.active_node and not var_85_0.active_node.anim_cb_combat_step_stop then
		var_85_0.active_node:anim_cb_combat_step_stop(arg_85_0, var_85_0)
	end
end

AnimationCallbackTemplates.client.anim_cb_hide_unit = function (arg_86_0, arg_86_1)
	-- function 86
	Unit.set_unit_visibility(arg_86_0, false)

	local has_extension = ScriptUnit.has_extension(arg_86_0, "inventory_system")

	if not has_extension then
		has_extension:show_third_person_inventory(false)
	end

	local has_extension_2 = ScriptUnit.has_extension(arg_86_0, "attachment_system")

	if not has_extension_2 then
		has_extension_2:show_attachments(false)
	end
end

AnimationCallbackTemplates.client.anim_cb_hide_weapons = function (arg_87_0, arg_87_1)
	-- function 87
	local unit_owner = Managers.player:unit_owner(arg_87_0)

	if not unit_owner then
		return
	end

	local local_player = unit_owner.local_player
	local flag = true

	if not local_player then
		flag = not ScriptUnit.extension(arg_87_0, "first_person_system").first_person_mode
	end

	local has_extension = ScriptUnit.has_extension(arg_87_0, "inventory_system")

	if not flag and not has_extension and not has_extension:is_showing_third_person_inventory() then
		has_extension:show_third_person_inventory(false)
	end
end

AnimationCallbackTemplates.client.anim_cb_unhide_weapons = function (arg_88_0, arg_88_1)
	-- function 88
	local unit_owner = Managers.player:unit_owner(arg_88_0)

	if not unit_owner then
		return
	end

	local local_player = unit_owner.local_player
	local flag = true

	if not local_player then
		flag = not ScriptUnit.extension(arg_88_0, "first_person_system").first_person_mode
	end

	local has_extension = ScriptUnit.has_extension(arg_88_0, "inventory_system")

	if not (not flag and not has_extension and has_extension:is_showing_third_person_inventory()) then
		has_extension:show_third_person_inventory(true)
	end
end

AnimationCallbackTemplates.client.anim_cb_climb_rotation_start = function (arg_89_0, arg_89_1)
	-- function 89
	ScriptUnit.extension(arg_89_0, "status_system").start_climb_rotation = true
end

AnimationCallbackTemplates.server.anim_cb_chew_attack = function (arg_90_0, arg_90_1)
	-- function 90
	local var_90_0 = BLACKBOARDS[arg_90_0]
	local active_node = var_90_0.active_node
	local victim_grabbed = var_90_0.victim_grabbed

	if not (not victim_grabbed and Unit.alive(victim_grabbed)) then
		return
	end

	if not active_node then
		local anim_cb_chew_attack = active_node.anim_cb_chew_attack

		if not anim_cb_chew_attack then
			anim_cb_chew_attack(active_node, arg_90_0, var_90_0)
		end
	end
end

AnimationCallbackTemplates.server.anim_cb_chew_attack_finished = function (arg_91_0, arg_91_1)
	-- function 91
	BLACKBOARDS[arg_91_0].anim_cb_chew_attack_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_grabbed_smash = function (arg_92_0, arg_92_1)
	-- function 92
	local var_92_0 = BLACKBOARDS[arg_92_0]
	local active_node = var_92_0.active_node
	local victim_grabbed = var_92_0.victim_grabbed

	if not (not victim_grabbed and Unit.alive(victim_grabbed)) then
		return
	end

	if not active_node then
		local anim_cb_attack_grabbed_smash = active_node.anim_cb_attack_grabbed_smash

		if not anim_cb_attack_grabbed_smash then
			anim_cb_attack_grabbed_smash(active_node, arg_92_0, var_92_0)
		end
	end
end

AnimationCallbackTemplates.client.anim_cb_enable_skeleton_collison = function (arg_93_0, arg_93_1)
	-- function 93
	local get_data = Unit.get_data(arg_93_0, "breed")
	local extension = ScriptUnit.extension(arg_93_0, "ai_system")
	local player_locomotion_constrain_radius = get_data.player_locomotion_constrain_radius

	player_locomotion_constrain_radius = player_locomotion_constrain_radius or nil
	extension.player_locomotion_constrain_radius = player_locomotion_constrain_radius
end

AnimationCallbackTemplates.server.anim_cb_shielded = function (arg_94_0, arg_94_1)
	-- function 94
	if not ScriptUnit.has_extension(arg_94_0, "ai_shield_system") then
		ScriptUnit.extension(arg_94_0, "ai_shield_system"):set_is_blocking(true)
	end

	BLACKBOARDS[arg_94_0].shield_is_up = true
end

AnimationCallbackTemplates.server.anim_cb_unshielded = function (arg_95_0, arg_95_1)
	-- function 95
	if not ScriptUnit.has_extension(arg_95_0, "ai_shield_system") then
		ScriptUnit.extension(arg_95_0, "ai_shield_system"):set_is_blocking(false)
	end

	BLACKBOARDS[arg_95_0].shield_is_up = false
end

DLCUtils.require_list("animation_callback_template_files")
