-- chunkname: @scripts/entity_system/systems/animation/animation_callback_templates.lua

local var_0_0 = BLACKBOARDS
local var_0_1 = require("scripts/utils/stagger_types")

AnimationCallbackTemplates = {}
AnimationCallbackTemplates.client = {}

function AnimationCallbackTemplates.client.anim_cb_enable_second_hit_ragdoll(arg_1_0, arg_1_1)
	ScriptUnit.extension(arg_1_0, "death_system"):enable_second_hit_ragdoll()
end

function AnimationCallbackTemplates.client.anim_cb_push_finished(arg_2_0, arg_2_1)
	local var_2_0 = ScriptUnit.has_extension(arg_2_0, "status_system")

	if var_2_0 then
		var_2_0:set_stagger_animation_done(true)
	end
end

AnimationCallbackTemplates.server = {}

function AnimationCallbackTemplates.server.anim_cb_spawn_finished(arg_3_0, arg_3_1)
	var_0_0[arg_3_0].spawning_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_push_finished(arg_4_0, arg_4_1)
	var_0_0[arg_4_0].stagger_anim_done = true
end

function AnimationCallbackTemplates.server.anim_cb_stunned_finished(arg_5_0, arg_5_1)
	var_0_0[arg_5_0].blocked = nil
end

function AnimationCallbackTemplates.server.anim_cb_stagger_light_finished(arg_6_0, arg_6_1)
	if not ALIVE[arg_6_0] then
		return
	end

	local var_6_0 = Unit.get_data(arg_6_0, "breed")
	local var_6_1 = var_0_0[arg_6_0]

	if var_6_0.handle_stagger_anim_cb then
		var_6_0.handle_stagger_anim_cb(arg_6_0, var_6_1, "anim_cb_stagger_light_finished")
	end
end

function AnimationCallbackTemplates.server.anim_cb_stagger_medium_finished(arg_7_0, arg_7_1)
	if not ALIVE[arg_7_0] then
		return
	end

	local var_7_0 = Unit.get_data(arg_7_0, "breed")
	local var_7_1 = var_0_0[arg_7_0]

	if var_7_0.handle_stagger_anim_cb then
		var_7_0.handle_stagger_anim_cb(arg_7_0, var_7_1, "anim_cb_stagger_medium_finished")
	end
end

function AnimationCallbackTemplates.server.anim_cb_stagger_heavy_finished(arg_8_0, arg_8_1)
	if not ALIVE[arg_8_0] then
		return
	end

	local var_8_0 = Unit.get_data(arg_8_0, "breed")
	local var_8_1 = var_0_0[arg_8_0]

	if var_8_0.handle_stagger_anim_cb then
		var_8_0.handle_stagger_anim_cb(arg_8_0, var_8_1, "anim_cb_stagger_heavy_finished")
	end
end

function AnimationCallbackTemplates.server.anim_cb_tp_end_enter(arg_9_0, arg_9_1)
	local var_9_0 = var_0_0[arg_9_0]

	if var_9_0.active_node and var_9_0.active_node.anim_cb_tp_end_enter then
		var_9_0.active_node:anim_cb_tp_end_enter(arg_9_0, var_9_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_hesitate_finished(arg_10_0, arg_10_1)
	local var_10_0 = var_0_0[arg_10_0]

	if var_10_0.active_node and var_10_0.active_node.anim_cb_hesitate_finished then
		var_10_0.active_node:anim_cb_hesitate_finished(arg_10_0, var_10_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_emote_finished(arg_11_0, arg_11_1)
	local var_11_0 = var_0_0[arg_11_0]

	if var_11_0.active_node and var_11_0.active_node.anim_cb_emote_finished then
		var_11_0.active_node:anim_cb_emote_finished(arg_11_0, var_11_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_direct_damage(arg_12_0, arg_12_1)
	local var_12_0 = var_0_0[arg_12_0]

	if not Unit.alive(var_12_0.target_unit) then
		return
	end

	if not var_12_0.action then
		return
	end

	local var_12_1 = var_12_0.active_node

	if var_12_1 and var_12_1.direct_damage then
		var_12_1.direct_damage(arg_12_0, var_12_0)
	end

	var_12_0.attacks_done = var_12_0.attacks_done + 1
end

local var_0_2 = 0
local var_0_3 = 0.6
local var_0_4 = 0.3

function AnimationCallbackTemplates.server.anim_cb_damage(arg_13_0, arg_13_1)
	local var_13_0 = var_0_0[arg_13_0]
	local var_13_1 = var_13_0.smash_door and var_13_0.smash_door.target_unit or var_13_0.attacking_target or var_13_0.drag_target_unit
	local var_13_2 = var_13_0.action

	if not var_13_2 then
		return
	end

	if not var_13_2.damage then
		return
	end

	local var_13_3 = var_13_0.combo_attack_data

	if var_13_3 and var_13_2.combo_attacks and var_13_2.combo_attacks[var_13_3.current_attack_name].no_abort_attack then
		var_13_0.attack_aborted = false
	end

	if var_13_0.active_node and var_13_0.active_node.attack_cooldown then
		var_13_0.active_node:attack_cooldown(arg_13_0, var_13_0)
	end

	if var_13_0.attack_aborted then
		return
	end

	if var_13_0.buff_extension then
		var_13_0.buff_extension:trigger_procs("minion_attack_used")
	end

	if var_13_0.active_node and var_13_0.active_node.anim_cb_damage then
		var_13_0.active_node:anim_cb_damage(arg_13_0, var_13_0)

		return
	end

	var_13_0.anim_cb_damage = true

	if not Unit.alive(var_13_1) or not Unit.alive(arg_13_0) then
		return
	end

	if var_13_0.has_line_of_sight == false or not DamageUtils.check_distance(var_13_2, var_13_0, arg_13_0, var_13_1) or not DamageUtils.check_infront(arg_13_0, var_13_1) then
		return
	end

	local var_13_4 = var_13_2.attack_directions and var_13_2.attack_directions[var_13_0.attack_anim]

	if not var_13_2.unblockable and DamageUtils.check_block(arg_13_0, var_13_1, var_13_2.fatigue_type, var_13_4) then
		if var_13_0.active_node and var_13_0.active_node.attack_blocked then
			var_13_0.active_node:attack_blocked(arg_13_0, var_13_0, var_13_4)
		end

		local var_13_5 = Managers.time:time("game")
		local var_13_6 = var_0_0[var_13_1]

		if not var_13_6.is_player then
			local var_13_7 = var_0_0[arg_13_0]
			local var_13_8 = POSITION_LOOKUP[arg_13_0] or Unit.world_position(arg_13_0, 0)
			local var_13_9 = POSITION_LOOKUP[var_13_1] or Unit.local_position(var_13_1, 0)
			local var_13_10 = Vector3.normalize(var_13_9 - var_13_8)
			local var_13_11 = AiUtils.calculate_ai_stagger_strength(var_13_7, var_13_6, var_13_5, true, var_0_1.medium, 0.25)

			if var_13_11 == var_0_1.none then
				var_13_11 = var_0_1.weak
			elseif var_13_11 == var_0_1.heavy then
				var_13_11 = var_0_1.medium
			end

			local var_13_12, var_13_13 = AiUtils.calculate_ai_stagger_impact(var_13_11)

			AiUtils.stagger_target(arg_13_0, var_13_1, var_13_13, var_13_12, var_13_10, var_13_5, nil, nil, nil, true)
		end

		return
	end

	AiUtils.damage_target(var_13_1, arg_13_0, var_13_2, var_13_2.damage)

	if var_13_0.active_node and var_13_0.active_node.attack_success then
		var_13_0.active_node:attack_success(arg_13_0, var_13_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_special_damage(arg_14_0, arg_14_1)
	local var_14_0 = var_0_0[arg_14_0]
	local var_14_1 = var_14_0.action

	if not var_14_1 or not var_14_1.damage then
		return
	end

	if var_14_0.attack_aborted then
		return
	end

	if var_14_0.buff_extension then
		var_14_0.buff_extension:trigger_procs("minion_attack_used")
	end

	if var_14_0.active_node and var_14_0.active_node.anim_cb_damage then
		var_14_0.active_node:anim_cb_damage(arg_14_0, var_14_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_reset_attack_animation_locked(arg_15_0, arg_15_1)
	ScriptUnit.extension(arg_15_0, "ai_system"):blackboard().reset_attack_animation_locked = true
end

function AnimationCallbackTemplates.server.anim_cb_unlink_unit(arg_16_0, arg_16_1)
	ScriptUnit.extension(arg_16_0, "ai_system"):blackboard().unlink_unit = true
end

function AnimationCallbackTemplates.server.anim_cb_mounted_knocked_off(arg_17_0, arg_17_1)
	local var_17_0 = ScriptUnit.extension(arg_17_0, "ai_system"):blackboard()

	var_17_0.knocked_off_mount = true

	local var_17_1 = var_17_0.locomotion_extension

	LocomotionUtils.set_animation_driven_movement(arg_17_0, false, false, true)
	var_17_1:use_lerp_rotation(true)
	var_17_1:set_movement_type("snap_to_navmesh")
end

function AnimationCallbackTemplates.server.anim_cb_mounting_finished(arg_18_0, arg_18_1)
	ScriptUnit.extension(arg_18_0, "ai_system"):blackboard().mounting_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_frenzy_damage(arg_19_0, arg_19_1)
	local var_19_0 = var_0_0[arg_19_0]
	local var_19_1 = var_19_0.action

	if not var_19_1 or not var_19_1.damage then
		return
	end

	if var_19_0.attack_aborted then
		return
	end

	if var_19_0.active_node and var_19_0.active_node.attack_cooldown then
		var_19_0.active_node:attack_cooldown(arg_19_0, var_19_0)
	end

	local var_19_2 = var_19_0.active_node

	if var_19_2 and var_19_2.anim_cb_frenzy_damage then
		var_19_2:anim_cb_frenzy_damage(arg_19_0, var_19_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_attack_vce(arg_20_0, arg_20_1)
	local var_20_0 = var_0_0[arg_20_0]
	local var_20_1 = var_20_0.action

	if var_20_0.attack_aborted then
		return
	end

	local var_20_2 = var_20_0.active_node

	if var_20_2 and var_20_2.anim_cb_attack_vce then
		var_20_2:anim_cb_attack_vce(arg_20_0, var_20_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_attack_vce_long(arg_21_0, arg_21_1)
	local var_21_0 = var_0_0[arg_21_0]
	local var_21_1 = var_21_0.action

	if var_21_0.attack_aborted then
		return
	end

	local var_21_2 = var_21_0.active_node

	if var_21_2 and var_21_2.anim_cb_attack_vce_long then
		var_21_2:anim_cb_attack_vce_long(arg_21_0, var_21_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_shout_vo(arg_22_0, arg_22_1)
	local var_22_0 = var_0_0[arg_22_0]
	local var_22_1 = var_22_0.active_node

	if var_22_1 and var_22_1.anim_cb_shout_vo then
		var_22_1:anim_cb_shout_vo(arg_22_0, var_22_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_combo_damage(arg_23_0, arg_23_1)
	local var_23_0 = var_0_0[arg_23_0]
	local var_23_1 = var_23_0.action

	if not var_23_1 or not var_23_1.damage then
		return
	end

	if var_23_0.attack_aborted then
		return
	end

	local var_23_2 = var_23_0.active_node

	if var_23_2 and var_23_2.anim_cb_combo_damage then
		var_23_2.anim_cb_combo_damage(arg_23_0, var_23_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_rotation_start(arg_24_0, arg_24_1)
	var_0_0[arg_24_0].anim_cb_rotation_start = true
end

function AnimationCallbackTemplates.server.anim_cb_rotation_stop(arg_25_0, arg_25_1)
	var_0_0[arg_25_0].anim_cb_rotation_stop = true
end

function AnimationCallbackTemplates.server.anim_cb_picked_up_standard(arg_26_0, arg_26_1)
	var_0_0[arg_26_0].anim_cb_picked_up_standard = true
end

function AnimationCallbackTemplates.server.anim_cb_running_attack_start(arg_27_0, arg_27_1)
	local var_27_0 = var_0_0[arg_27_0]

	if var_27_0.active_node and var_27_0.active_node.anim_cb_running_attack_start then
		var_27_0.active_node:anim_cb_running_attack_start(arg_27_0, var_27_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_running_attack_end(arg_28_0, arg_28_1)
	local var_28_0 = var_0_0[arg_28_0]

	if var_28_0.active_node and var_28_0.active_node.anim_cb_running_attack_end then
		var_28_0.active_node:anim_cb_running_attack_end(arg_28_0, var_28_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_death_finished(arg_29_0, arg_29_1)
	var_0_0[arg_29_0].anim_cb_death_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_move(arg_30_0, arg_30_1)
	local var_30_0 = var_0_0[arg_30_0]
	local var_30_1 = var_30_0.active_node

	var_30_0.anim_cb_move = true

	if not var_30_1 or var_30_0.attack_aborted then
		return
	end

	local var_30_2 = var_30_1.anim_cb_move

	if var_30_2 then
		var_30_2(var_30_2, arg_30_0, var_30_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_move_stop(arg_31_0, arg_31_1)
	var_0_0[arg_31_0].anim_cb_move_stop = true
end

function AnimationCallbackTemplates.server.anim_cb_transform_finished(arg_32_0, arg_32_1)
	local var_32_0 = var_0_0[arg_32_0]
	local var_32_1 = var_32_0.active_node
	local var_32_2 = var_32_1 and var_32_1.anim_cb_transform_finished

	if var_32_2 then
		var_32_2(var_32_2, arg_32_0, var_32_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_throw_weapon(arg_33_0, arg_33_1)
	local var_33_0 = var_0_0[arg_33_0]
	local var_33_1 = var_33_0.active_node.anim_cb_throw_weapon

	if var_33_1 then
		var_33_1(var_33_1, arg_33_0, var_33_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_throw_finished(arg_34_0, arg_34_1)
	local var_34_0 = var_0_0[arg_34_0]
	local var_34_1 = var_34_0.active_node
	local var_34_2 = var_34_1 and var_34_1.anim_cb_throw_finished

	if var_34_2 then
		var_34_2(var_34_2, arg_34_0, var_34_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_charge_start_finished(arg_35_0, arg_35_1)
	local var_35_0 = var_0_0[arg_35_0]
	local var_35_1 = var_35_0.active_node

	if var_35_1 and var_35_1.anim_cb_charge_start_finished then
		var_35_1:anim_cb_charge_start_finished(arg_35_0, var_35_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_charge_charging_finished(arg_36_0, arg_36_1)
	local var_36_0 = var_0_0[arg_36_0]
	local var_36_1 = var_36_0.active_node

	if var_36_1 and var_36_1.anim_cb_charge_charging_finished then
		var_36_1:anim_cb_charge_charging_finished(arg_36_0, var_36_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_charge_impact_finished(arg_37_0, arg_37_1)
	local var_37_0 = var_0_0[arg_37_0]
	local var_37_1 = var_37_0.active_node

	if var_37_1 and var_37_1.anim_cb_charge_impact_finished then
		var_37_1:anim_cb_charge_impact_finished(arg_37_0, var_37_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_disable_charge_collision(arg_38_0, arg_38_1)
	local var_38_0 = var_0_0[arg_38_0]
	local var_38_1 = var_38_0.active_node

	if var_38_1 and var_38_1.anim_cb_disable_charge_collision then
		var_38_1:anim_cb_disable_charge_collision(arg_38_0, var_38_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_throw(arg_39_0, arg_39_1)
	var_0_0[arg_39_0].anim_cb_throw = true
end

function AnimationCallbackTemplates.server.anim_cb_spawn_projectile(arg_40_0, arg_40_1)
	var_0_0[arg_40_0].anim_cb_spawn_projectile = true
end

function AnimationCallbackTemplates.server.anim_cb_jump_start_finished(arg_41_0, arg_41_1)
	var_0_0[arg_41_0].jump_start_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_jump_climb_finished(arg_42_0, arg_42_1)
	var_0_0[arg_42_0].jump_climb_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_start_finished(arg_43_0, arg_43_1)
	var_0_0[arg_43_0].start_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_attack_start(arg_44_0, arg_44_1)
	local var_44_0 = var_0_0[arg_44_0]
	local var_44_1 = var_44_0.active_node

	if not var_44_1 or var_44_0.attack_aborted then
		return
	end

	local var_44_2 = var_44_1.anim_cb_attack_start

	if var_44_2 then
		var_44_2(var_44_2, arg_44_0, var_44_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_attack_finished(arg_45_0, arg_45_1)
	local var_45_0 = var_0_0[arg_45_0]

	if var_45_0.active_node and var_45_0.active_node.anim_cb_attack_finished then
		local var_45_1 = var_45_0.active_node.anim_cb_attack_finished

		var_45_1(var_45_1, arg_45_0, var_45_0)
	else
		var_45_0.attacks_done = var_45_0.attacks_done + 1
		var_45_0.attack_finished = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_escape_finished(arg_46_0, arg_46_1)
	var_0_0[arg_46_0].anim_cb_escape_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_attack_cooldown(arg_47_0, arg_47_1)
	var_0_0[arg_47_0].anim_cb_attack_cooldown = true
end

function AnimationCallbackTemplates.server.anim_cb_blocked_cooldown(arg_48_0, arg_48_1)
	var_0_0[arg_48_0].anim_cb_blocked_cooldown = true
end

function AnimationCallbackTemplates.server.anim_cb_summoning_finished(arg_49_0, arg_49_1)
	var_0_0[arg_49_0].summoning_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_shout_finished(arg_50_0, arg_50_1)
	var_0_0[arg_50_0].anim_cb_shout_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_order_finished(arg_51_0, arg_51_1)
	var_0_0[arg_51_0].anim_cb_order_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_scurry_under_finished(arg_52_0, arg_52_1)
	var_0_0[arg_52_0].anim_cb_scurry_under_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_dig_finished(arg_53_0, arg_53_1)
	var_0_0[arg_53_0].anim_cb_dig_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_attack_throw_score_finished(arg_54_0, arg_54_1)
	local var_54_0 = ScriptUnit.has_extension(arg_54_0, "ai_system")

	if var_54_0 then
		var_54_0:blackboard().anim_cb_attack_throw_score_finished = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_attack_jump_start_finished(arg_55_0, arg_55_1)
	local var_55_0 = ScriptUnit.has_extension(arg_55_0, "ai_system")

	if var_55_0 then
		var_55_0:blackboard().anim_cb_attack_jump_start_finished = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_attack_shoot_start_finished(arg_56_0, arg_56_1)
	local var_56_0 = ScriptUnit.has_extension(arg_56_0, "ai_system")

	if var_56_0 then
		var_56_0:blackboard().anim_cb_attack_shoot_start_finished = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_reload_start_finished(arg_57_0, arg_57_1)
	local var_57_0 = ScriptUnit.has_extension(arg_57_0, "ai_system")

	if var_57_0 then
		var_57_0:blackboard().anim_cb_reload_start_finished = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_attack_windup_start_finished(arg_58_0, arg_58_1)
	local var_58_0 = ScriptUnit.has_extension(arg_58_0, "ai_system")

	if var_58_0 then
		var_58_0:blackboard().anim_cb_attack_windup_start_finished = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_attack_shoot_random_shot(arg_59_0, arg_59_1)
	local var_59_0 = ScriptUnit.has_extension(arg_59_0, "ai_system")

	if var_59_0 then
		var_59_0:blackboard().anim_cb_attack_shoot_random_shot = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_stormvermin_voice(arg_60_0, arg_60_1)
	local var_60_0 = ScriptUnit.has_extension(arg_60_0, "ai_system")

	if var_60_0 then
		var_60_0:blackboard().anim_cb_stormvermin_voice = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_patrol_sound(arg_61_0, arg_61_1)
	local var_61_0 = ScriptUnit.has_extension(arg_61_0, "ai_system")

	if var_61_0 then
		var_61_0:blackboard().anim_cb_patrol_sound = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_exit_shooting_hit_react(arg_62_0, arg_62_1)
	local var_62_0 = ScriptUnit.has_extension(arg_62_0, "ai_system")

	if var_62_0 then
		var_62_0:blackboard().in_hit_reaction = nil
	end
end

function AnimationCallbackTemplates.server.anim_cb_enter_shooting_hit_react(arg_63_0, arg_63_1)
	local var_63_0 = ScriptUnit.has_extension(arg_63_0, "ai_system")

	if var_63_0 then
		var_63_0:blackboard().in_hit_reaction = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_place_standard(arg_64_0, arg_64_1)
	local var_64_0 = var_0_0[arg_64_0]
	local var_64_1 = var_64_0.active_node

	if var_64_1 then
		local var_64_2 = var_64_1.anim_cb_place_standard

		if var_64_2 then
			var_64_2(var_64_1, arg_64_0, var_64_0)
		end
	end
end

function AnimationCallbackTemplates.server.anim_cb_pick_up_standard(arg_65_0, arg_65_1)
	local var_65_0 = var_0_0[arg_65_0]
	local var_65_1 = var_65_0.active_node

	if var_65_1 then
		local var_65_2 = var_65_1.anim_cb_pick_up_standard

		if var_65_2 then
			var_65_2(var_65_1, arg_65_0, var_65_0)
		end
	end
end

function AnimationCallbackTemplates.server.anim_cb_placed_standard(arg_66_0, arg_66_1)
	local var_66_0 = var_0_0[arg_66_0]
	local var_66_1 = var_66_0.active_node
	local var_66_2 = var_66_1 and var_66_1.anim_cb_placed_standard

	if var_66_2 then
		var_66_2(var_66_1, arg_66_0, var_66_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_stormvermin_push(arg_67_0, arg_67_1)
	local var_67_0 = var_0_0[arg_67_0]
	local var_67_1 = var_67_0.attacking_target
	local var_67_2 = var_67_0.active_node

	if not var_67_2 or var_67_0.attack_aborted or not HEALTH_ALIVE[var_67_1] then
		return
	end

	local var_67_3 = var_67_2.anim_cb_stormvermin_push

	if var_67_3 then
		var_67_3(var_67_2, arg_67_0, var_67_0, var_67_1)
	end
end

function AnimationCallbackTemplates.server.anim_cb_stormvermin_push_finished(arg_68_0, arg_68_1)
	var_0_0[arg_68_0].attack_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_attack_overlap_done(arg_69_0, arg_69_1)
	local var_69_0 = var_0_0[arg_69_0]
	local var_69_1 = var_69_0.active_node

	if not var_69_1 or var_69_0.attack_aborted then
		return
	end

	local var_69_2 = var_69_1.anim_cb_attack_overlap_done

	if var_69_2 then
		var_69_2(var_69_1, arg_69_0, var_69_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_vomit(arg_70_0, arg_70_1)
	local var_70_0 = var_0_0[arg_70_0]
	local var_70_1 = var_70_0.active_node

	if not var_70_1 or var_70_0.attack_aborted then
		return
	end

	local var_70_2 = var_70_1.anim_cb_vomit

	if var_70_2 then
		var_70_2(var_70_2, arg_70_0, var_70_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_vomit_end(arg_71_0, arg_71_1)
	var_0_0[arg_71_0].is_puking = nil
end

function AnimationCallbackTemplates.server.anim_cb_dodge_finished(arg_72_0, arg_72_1)
	var_0_0[arg_72_0].anim_cb_dodge_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_downed_end_finished(arg_73_0, arg_73_1)
	var_0_0[arg_73_0].downed_end_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_rage_finished(arg_74_0, arg_74_1)
	var_0_0[arg_74_0].rage_end_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_roar_begin(arg_75_0, arg_75_1)
	var_0_0[arg_75_0].anim_cb_roar_begin = true
end

function AnimationCallbackTemplates.server.anim_cb_roar_end(arg_76_0, arg_76_1)
	var_0_0[arg_76_0].anim_cb_roar_end = true
end

function AnimationCallbackTemplates.server.anim_cb_landing_finished(arg_77_0, arg_77_1)
	var_0_0[arg_77_0].landing_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_teleport_finished(arg_78_0, arg_78_1)
	var_0_0[arg_78_0].anim_cb_teleport_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_teleport_start_finished(arg_79_0, arg_79_1)
	local var_79_0 = var_0_0[arg_79_0]
	local var_79_1 = var_79_0.active_node

	if var_79_1 and var_79_1.anim_cb_teleport_start_finished then
		var_79_1:anim_cb_teleport_start_finished(arg_79_0, var_79_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_teleport_end_finished(arg_80_0, arg_80_1)
	local var_80_0 = var_0_0[arg_80_0]
	local var_80_1 = var_80_0.active_node

	if var_80_1 and var_80_1.anim_cb_teleport_end_finished then
		var_80_1:anim_cb_teleport_end_finished(arg_80_0, var_80_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_move_jump_finished(arg_81_0, arg_81_1)
	local var_81_0 = var_0_0[arg_81_0]
	local var_81_1 = var_81_0.active_node

	if var_81_1 and var_81_1.anim_cb_move_jump_finished then
		var_81_1:anim_cb_move_jump_finished(arg_81_0, var_81_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_stagger_immune(arg_82_0, arg_82_1)
	var_0_0[arg_82_0].anim_cb_stagger_immune = true
end

function AnimationCallbackTemplates.server.anim_cb_push_cancel(arg_83_0, arg_83_1)
	local var_83_0 = var_0_0[arg_83_0]
	local var_83_1 = var_83_0.active_node

	if var_83_1 and var_83_1.anim_cb_push_cancel then
		var_83_1:anim_cb_push_cancel(arg_83_0, var_83_0)
	end
end

function AnimationCallbackTemplates.server.anim_cb_disable_invincibility(arg_84_0, arg_84_1)
	local var_84_0 = ScriptUnit.has_extension(arg_84_0, "health_system")

	if var_84_0 then
		var_84_0.is_invincible = false
	end
end

function AnimationCallbackTemplates.server.anim_cb_combat_step_stop(arg_85_0, arg_85_1)
	local var_85_0 = var_0_0[arg_85_0]

	if var_85_0.active_node and var_85_0.active_node.anim_cb_combat_step_stop then
		var_85_0.active_node:anim_cb_combat_step_stop(arg_85_0, var_85_0)
	end
end

function AnimationCallbackTemplates.client.anim_cb_hide_unit(arg_86_0, arg_86_1)
	Unit.set_unit_visibility(arg_86_0, false)

	local var_86_0 = ScriptUnit.has_extension(arg_86_0, "inventory_system")

	if var_86_0 then
		var_86_0:show_third_person_inventory(false)
	end

	local var_86_1 = ScriptUnit.has_extension(arg_86_0, "attachment_system")

	if var_86_1 then
		var_86_1:show_attachments(false)
	end
end

function AnimationCallbackTemplates.client.anim_cb_hide_weapons(arg_87_0, arg_87_1)
	local var_87_0 = Managers.player:unit_owner(arg_87_0)

	if not var_87_0 then
		return
	end

	local var_87_1 = var_87_0.local_player
	local var_87_2 = true

	if var_87_1 then
		var_87_2 = not ScriptUnit.extension(arg_87_0, "first_person_system").first_person_mode
	end

	local var_87_3 = ScriptUnit.has_extension(arg_87_0, "inventory_system")

	if var_87_2 and var_87_3 and var_87_3:is_showing_third_person_inventory() then
		var_87_3:show_third_person_inventory(false)
	end
end

function AnimationCallbackTemplates.client.anim_cb_unhide_weapons(arg_88_0, arg_88_1)
	local var_88_0 = Managers.player:unit_owner(arg_88_0)

	if not var_88_0 then
		return
	end

	local var_88_1 = var_88_0.local_player
	local var_88_2 = true

	if var_88_1 then
		var_88_2 = not ScriptUnit.extension(arg_88_0, "first_person_system").first_person_mode
	end

	local var_88_3 = ScriptUnit.has_extension(arg_88_0, "inventory_system")

	if var_88_2 and var_88_3 and not var_88_3:is_showing_third_person_inventory() then
		var_88_3:show_third_person_inventory(true)
	end
end

function AnimationCallbackTemplates.client.anim_cb_climb_rotation_start(arg_89_0, arg_89_1)
	ScriptUnit.extension(arg_89_0, "status_system").start_climb_rotation = true
end

function AnimationCallbackTemplates.server.anim_cb_chew_attack(arg_90_0, arg_90_1)
	local var_90_0 = var_0_0[arg_90_0]
	local var_90_1 = var_90_0.active_node
	local var_90_2 = var_90_0.victim_grabbed

	if not var_90_2 or not Unit.alive(var_90_2) then
		return
	end

	if var_90_1 then
		local var_90_3 = var_90_1.anim_cb_chew_attack

		if var_90_3 then
			var_90_3(var_90_1, arg_90_0, var_90_0)
		end
	end
end

function AnimationCallbackTemplates.server.anim_cb_chew_attack_finished(arg_91_0, arg_91_1)
	var_0_0[arg_91_0].anim_cb_chew_attack_finished = true
end

function AnimationCallbackTemplates.server.anim_cb_attack_grabbed_smash(arg_92_0, arg_92_1)
	local var_92_0 = var_0_0[arg_92_0]
	local var_92_1 = var_92_0.active_node
	local var_92_2 = var_92_0.victim_grabbed

	if not var_92_2 or not Unit.alive(var_92_2) then
		return
	end

	if var_92_1 then
		local var_92_3 = var_92_1.anim_cb_attack_grabbed_smash

		if var_92_3 then
			var_92_3(var_92_1, arg_92_0, var_92_0)
		end
	end
end

function AnimationCallbackTemplates.client.anim_cb_enable_skeleton_collison(arg_93_0, arg_93_1)
	local var_93_0 = Unit.get_data(arg_93_0, "breed")

	ScriptUnit.extension(arg_93_0, "ai_system").player_locomotion_constrain_radius = var_93_0.player_locomotion_constrain_radius or nil
end

function AnimationCallbackTemplates.server.anim_cb_shielded(arg_94_0, arg_94_1)
	if ScriptUnit.has_extension(arg_94_0, "ai_shield_system") then
		ScriptUnit.extension(arg_94_0, "ai_shield_system"):set_is_blocking(true)
	end

	var_0_0[arg_94_0].shield_is_up = true
end

function AnimationCallbackTemplates.server.anim_cb_unshielded(arg_95_0, arg_95_1)
	if ScriptUnit.has_extension(arg_95_0, "ai_shield_system") then
		ScriptUnit.extension(arg_95_0, "ai_shield_system"):set_is_blocking(false)
	end

	var_0_0[arg_95_0].shield_is_up = false
end

DLCUtils.require_list("animation_callback_template_files")
