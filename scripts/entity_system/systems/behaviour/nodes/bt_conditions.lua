-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_conditions.lua

BTConditions = BTConditions or {}

require("scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_conditions")

local var_0_0 = Unit.alive
local var_0_1 = ScriptUnit

function BTConditions.always_true(arg_1_0)
	return true
end

function BTConditions.always_false(arg_2_0)
	return false
end

function BTConditions.spawn(arg_3_0)
	return arg_3_0.spawn
end

function BTConditions.blocked(arg_4_0)
	return arg_4_0.blocked
end

function BTConditions.start_or_continue(arg_5_0)
	return arg_5_0.attack_token == nil or arg_5_0.attack_token
end

function BTConditions.ask_target_before_attacking(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0.attack_token then
		return arg_6_0.attack_token
	end

	local var_6_0 = true
	local var_6_1 = arg_6_0.target_unit
	local var_6_2 = var_0_1.has_extension(var_6_1, "attack_intensity_system")

	if var_6_2 then
		local var_6_3 = arg_6_2.attack_intensity_type or "normal"

		var_6_0 = var_6_2:want_an_attack(var_6_3)
	end

	return var_6_0
end

function BTConditions.first_shots_fired(arg_7_0)
	return arg_7_0.first_shots_fired
end

function BTConditions.stagger(arg_8_0)
	if arg_8_0.stagger then
		if arg_8_0.stagger_prohibited then
			arg_8_0.stagger = false
		else
			return true
		end
	end
end

function BTConditions.stagger_activated(arg_9_0)
	if arg_9_0.stagger_activated then
		return true
	end

	return false
end

function BTConditions.grey_seer_stagger(arg_10_0)
	if arg_10_0.stagger then
		if arg_10_0.stagger_prohibited then
			arg_10_0.stagger = false
		else
			return not arg_10_0.about_to_mount
		end
	end
end

function BTConditions.reset_attack(arg_11_0)
	return arg_11_0.reset_attack
end

function BTConditions.lord_intro(arg_12_0)
	local var_12_0 = Managers.time:time("game")

	return arg_12_0.intro_timer and var_12_0 < arg_12_0.intro_timer
end

function BTConditions.warlord_jump_down(arg_13_0)
	return arg_13_0.jump_from_pos
end

function BTConditions.quick_teleport(arg_14_0)
	return arg_14_0.quick_teleport
end

function BTConditions.fling_skaven(arg_15_0)
	return arg_15_0.fling_skaven
end

function BTConditions.secondary_target(arg_16_0)
	return arg_16_0.secondary_target
end

function BTConditions.quick_jump(arg_17_0)
	return arg_17_0.high_ground_opportunity
end

function BTConditions.ninja_vanish(arg_18_0)
	return arg_18_0.ninja_vanish
end

function BTConditions.target_changed(arg_19_0)
	return arg_19_0.target_changed
end

function BTConditions.victim_grabbed(arg_20_0)
	return arg_20_0.has_grabbed_victim
end

function BTConditions.nurgling_spawned_by_altar(arg_21_0)
	return arg_21_0.nurgling_spawned_by_altar
end

function BTConditions.target_changed_and_distant(arg_22_0)
	if arg_22_0.target_changed then
		if arg_22_0.previous_target_unit == nil then
			return true
		elseif arg_22_0.target_dist and arg_22_0.target_dist > 15 then
			local var_22_0 = Managers.time:time("game")

			return arg_22_0.next_rage_time and var_22_0 > arg_22_0.next_rage_time
		else
			arg_22_0.target_changed = nil
		end
	end

	return false
end

function BTConditions.stormfiend_boss_rage(arg_23_0)
	return arg_23_0.intro_rage
end

function BTConditions.ratogre_target_reachable(arg_24_0)
	return arg_24_0.jump_slam_data or not arg_24_0.target_outside_navmesh or arg_24_0.target_dist and arg_24_0.target_dist <= arg_24_0.breed.reach_distance
end

function BTConditions.chaos_spawn_grabbed_combat(arg_25_0)
	return HEALTH_ALIVE[arg_25_0.victim_grabbed] and not AiUtils.unit_knocked_down(arg_25_0.victim_grabbed) and not arg_25_0.wants_to_throw
end

function BTConditions.chaos_spawn_grabbed_throw(arg_26_0)
	local var_26_0 = AiUtils.unit_knocked_down(arg_26_0.victim_grabbed)

	return HEALTH_ALIVE[arg_26_0.victim_grabbed] and (var_26_0 or arg_26_0.wants_to_throw)
end

function BTConditions.path_found(arg_27_0)
	return not arg_27_0.no_path_found
end

function BTConditions.ratogre_jump_dist(arg_28_0)
	return not arg_28_0.target_outside_navmesh and arg_28_0.target_dist and arg_28_0.target_dist <= 15
end

function BTConditions.ratogre_walking(arg_29_0)
	return arg_29_0.ratogre_walking
end

function BTConditions.escorting_rat_ogre(arg_30_0)
	return arg_30_0.escorting_rat_ogre
end

function BTConditions.in_vortex(arg_31_0)
	return arg_31_0.in_vortex
end

function BTConditions.in_gravity_well(arg_32_0)
	return arg_32_0.gravity_well_position
end

function BTConditions.at_smartobject(arg_33_0)
	local var_33_0 = arg_33_0.next_smart_object_data

	if not (var_33_0.next_smart_object_id ~= nil) then
		return false
	end

	local var_33_1 = arg_33_0.is_smart_objecting
	local var_33_2 = Managers.state.entity:system("nav_graph_system")
	local var_33_3 = var_33_0.smart_object_data and var_33_0.smart_object_data.unit
	local var_33_4, var_33_5 = var_33_2:has_nav_graph(var_33_3)

	if var_33_4 and not var_33_5 and not var_33_1 then
		return false
	end

	local var_33_6 = arg_33_0.is_in_smartobject_range
	local var_33_7 = arg_33_0.move_state == "moving"

	return var_33_6 and var_33_7 or var_33_1
end

function BTConditions.gutter_runner_at_smartobject(arg_34_0)
	if arg_34_0.jump_data then
		return false
	end

	return BTConditions.at_smartobject(arg_34_0)
end

function BTConditions.ratogre_at_smartobject(arg_35_0)
	if arg_35_0.keep_target then
		return false
	end

	return BTConditions.at_smartobject(arg_35_0)
end

function BTConditions.stormfiend_boss_intro_jump_down(arg_36_0)
	local var_36_0 = arg_36_0.jump_down_intro

	return BTConditions.at_smartobject(arg_36_0) and var_36_0
end

function BTConditions.at_teleport_smartobject(arg_37_0)
	local var_37_0 = arg_37_0.next_smart_object_data.smart_object_type == "teleporters"
	local var_37_1 = arg_37_0.is_teleporting

	return var_37_0 or var_37_1
end

function BTConditions.vortex_at_climb_or_jump(arg_38_0)
	local var_38_0 = BTConditions.at_climb_smartobject(arg_38_0)
	local var_38_1 = BTConditions.at_jump_smartobject(arg_38_0)

	return var_38_0 or var_38_1 or arg_38_0.is_flying
end

function BTConditions.at_climb_smartobject(arg_39_0)
	local var_39_0 = arg_39_0.next_smart_object_data.smart_object_type
	local var_39_1 = var_39_0 == "ledges" or var_39_0 == "ledges_with_fence"
	local var_39_2 = arg_39_0.is_climbing

	return var_39_1 or var_39_2
end

function BTConditions.at_jump_smartobject(arg_40_0)
	local var_40_0 = arg_40_0.next_smart_object_data.smart_object_type == "jumps"
	local var_40_1 = arg_40_0.is_jumping

	return var_40_0 or var_40_1
end

function BTConditions.at_door_smartobject(arg_41_0)
	local var_41_0 = arg_41_0.next_smart_object_data.smart_object_type
	local var_41_1 = var_41_0 == "doors" or var_41_0 == "planks" or var_41_0 == "big_boy_destructible" or var_41_0 == "destructible_wall"
	local var_41_2 = arg_41_0.is_smashing_door
	local var_41_3 = arg_41_0.is_scurrying_under_door

	return var_41_1 or var_41_2 or var_41_3
end

function BTConditions.at_smart_object_and_door(arg_42_0)
	return BTConditions.at_smartobject(arg_42_0) and BTConditions.at_door_smartobject(arg_42_0)
end

function BTConditions.has_destructible_as_target(arg_43_0)
	local var_43_0 = arg_43_0.target_unit
	local var_43_1 = not var_0_1.has_extension(var_43_0, "locomotion_system")

	return var_0_0(var_43_0) and arg_43_0.confirmed_player_sighting and var_43_1
end

function BTConditions.can_see_player(arg_44_0)
	return var_0_0(arg_44_0.target_unit)
end

function BTConditions.has_target(arg_45_0)
	return var_0_0(arg_45_0.target_unit)
end

function BTConditions.no_target(arg_46_0)
	return not var_0_0(arg_46_0.target_unit)
end

function BTConditions.tentacle_found_target(arg_47_0)
	return var_0_0(arg_47_0.target_unit) and not arg_47_0.tentacle_satisfied
end

function BTConditions.at_half_health(arg_48_0)
	return arg_48_0.current_health_percent <= 0.5
end

function BTConditions.at_one_third_health(arg_49_0)
	return arg_49_0.current_health_percent <= 0.33
end

function BTConditions.at_two_thirds_health(arg_50_0)
	return arg_50_0.current_health_percent <= 0.66
end

function BTConditions.at_one_fifth_health(arg_51_0)
	return arg_51_0.current_health_percent <= 0.2
end

function BTConditions.at_three_fifths_health(arg_52_0)
	return arg_52_0.current_health_percent <= 0.6
end

function BTConditions.less_than_one_health(arg_53_0)
	return arg_53_0.current_health <= 1
end

function BTConditions.can_transition_half_health(arg_54_0)
	return arg_54_0.current_health_percent <= 0.5 and not arg_54_0.half_transition_done
end

function BTConditions.can_transition_one_third_health(arg_55_0)
	return arg_55_0.current_health_percent <= 0.33 and not arg_55_0.one_third_transition_done
end

function BTConditions.dummy_not_escaped(arg_56_0)
	return not arg_56_0.anim_cb_escape_finished
end

function BTConditions.can_transition_two_thirds_health(arg_57_0)
	return arg_57_0.current_health_percent <= 0.66 and not arg_57_0.two_thirds_transition_done
end

function BTConditions.can_transition_one_fifth_health(arg_58_0)
	return arg_58_0.current_health_percent <= 0.2 and not arg_58_0.one_fifth_transition_done
end

function BTConditions.can_transition_three_fifths_health(arg_59_0)
	return arg_59_0.current_health_percent <= 0.6 and not arg_59_0.three_fifths_transition_done
end

function BTConditions.transitioned_half_health(arg_60_0)
	return arg_60_0.current_health_percent <= 0.5 and arg_60_0.half_transition_done
end

function BTConditions.transitioned_three_fifths_health(arg_61_0)
	return arg_61_0.current_health_percent <= 0.6 and arg_61_0.three_fifths_transition_done
end

function BTConditions.transitioned_one_fifth_health(arg_62_0)
	return arg_62_0.current_health_percent <= 0.2 and arg_62_0.one_fifth_transition_done
end

function BTConditions.transitioned_one_third_health(arg_63_0)
	return arg_63_0.current_health_percent <= 0.33 and arg_63_0.one_third_transition_done
end

function BTConditions.transitioned_two_thirds_health(arg_64_0)
	return arg_64_0.current_health_percent <= 0.66 and arg_64_0.two_thirds_transition_done
end

function BTConditions.sorcerer_allow_tricke_spawn(arg_65_0)
	return arg_65_0.sorcerer_allow_tricke_spawn
end

function BTConditions.spawned_allies_dead_or_time(arg_66_0)
	return arg_66_0.spawn_allies_horde and arg_66_0.spawn_allies_horde.is_dead or arg_66_0.defensive_phase_duration == 0
end

function BTConditions.first_ring_summon(arg_67_0)
	return arg_67_0.ring_summonings_finished == 0
end

function BTConditions.ready_to_summon_rings(arg_68_0)
	return arg_68_0.ring_cooldown == 0
end

function BTConditions.ready_to_charge(arg_69_0)
	return arg_69_0.charge_cooldown == 0
end

function BTConditions.ready_to_teleport(arg_70_0)
	return arg_70_0.teleport_cooldown == 0
end

function BTConditions.ready_to_summon_wave(arg_71_0)
	return arg_71_0.wave_cooldown == 0
end

function BTConditions.not_ready_to_summon_wave(arg_72_0)
	return not arg_72_0.ready_to_summon or not arg_72_0.summoning and not Unit.alive(arg_72_0.target_unit) or arg_72_0.wave_cooldown ~= 0
end

function BTConditions.ready_to_summon(arg_73_0)
	return arg_73_0.ready_to_summon and (arg_73_0.summoning or Unit.alive(arg_73_0.target_unit))
end

function BTConditions.ready_to_summon_vortex(arg_74_0)
	return arg_74_0.current_spell_name == "vortex"
end

function BTConditions.ready_to_summon_plague_wave(arg_75_0)
	return arg_75_0.current_spell_name == "plague_wave"
end

function BTConditions.ready_to_summon_tentacle(arg_76_0)
	return arg_76_0.current_spell_name == "tentacle"
end

function BTConditions.ready_to_cast_missile(arg_77_0)
	return arg_77_0.current_spell_name == "magic_missile"
end

function BTConditions.ready_to_cast_seeking_bomb_missile(arg_78_0)
	return arg_78_0.current_spell_name == "seeking_bomb_missile"
end

function BTConditions.sorcerer_in_defensive_mode(arg_79_0)
	return arg_79_0.mode == "defensive" and not arg_79_0.is_summoning
end

function BTConditions.sorcerer_in_setup_mode(arg_80_0)
	return arg_80_0.mode == "setup" and not arg_80_0.setup_done
end

function BTConditions.escape_teleport(arg_81_0)
	return arg_81_0.escape_teleport
end

function BTConditions.defensive_mode_starts(arg_82_0)
	return arg_82_0.phase == "defensive_starts"
end

function BTConditions.sorcerer_defensive_combat(arg_83_0)
	return arg_83_0.phase == "defensive_combat"
end

function BTConditions.defensive_mode_ends(arg_84_0)
	return arg_84_0.phase == "defensive_ends"
end

function BTConditions.ready_to_explode(arg_85_0)
	return arg_85_0.ready_to_summon
end

function BTConditions.player_spotted(arg_86_0)
	return var_0_0(arg_86_0.target_unit) and not arg_86_0.confirmed_player_sighting
end

function BTConditions.in_melee_range(arg_87_0)
	return var_0_0(arg_87_0.target_unit) and arg_87_0.in_melee_range
end

function BTConditions.approach_target(arg_88_0)
	return arg_88_0.approach_target
end

function BTConditions.comitted_to_target(arg_89_0)
	local var_89_0 = Managers.time:time("game") > arg_89_0.initial_pounce_timer

	return (arg_89_0.target_unit or arg_89_0.comitted_to_target) and var_89_0
end

function BTConditions.in_sprint_dist(arg_90_0)
	return arg_90_0.closing or arg_90_0.target_dist > 7
end

function BTConditions.in_run_dist(arg_91_0)
	return arg_91_0.target_dist <= 7 or arg_91_0.movement_inited and arg_91_0.target_dist <= 8
end

function BTConditions.troll_downed(arg_92_0)
	return arg_92_0.can_get_downed and arg_92_0.downed_state
end

function BTConditions.troll_chief_phase_success(arg_93_0)
	local var_93_0, var_93_1, var_93_2, var_93_3, var_93_4 = arg_93_0.health_extension:respawn_thresholds()

	return var_93_4 > arg_93_0.downed_phase
end

function BTConditions.needs_to_crouch(arg_94_0)
	return arg_94_0.needs_to_crouch and BTConditions.ratogre_target_reachable(arg_94_0)
end

function BTConditions.reset_utility(arg_95_0)
	return not arg_95_0.reset_utility
end

function BTConditions.is_alerted(arg_96_0)
	local var_96_0 = var_0_0(arg_96_0.target_unit) and arg_96_0.is_alerted and (not arg_96_0.confirmed_player_sighting or arg_96_0.hesitating)
	local var_96_1 = var_0_0(arg_96_0.taunt_unit) and not arg_96_0.taunt_hesitate_finished and not arg_96_0.no_taunt_hesitate

	return var_96_0 or var_96_1
end

function BTConditions.confirmed_player_sighting(arg_97_0)
	return var_0_0(arg_97_0.target_unit) and arg_97_0.confirmed_player_sighting
end

function BTConditions.commander_disabled_or_resuming(arg_98_0)
	return ALIVE[arg_98_0.commander_unit] and var_0_1.extension(arg_98_0.commander_unit, "status_system"):is_disabled() or arg_98_0.disabled_resume_time and Managers.time:time("game") < arg_98_0.disabled_resume_time
end

function BTConditions.commander_disabled(arg_99_0)
	return ALIVE[arg_99_0.commander_unit] and var_0_1.extension(arg_99_0.commander_unit, "status_system"):is_disabled()
end

function BTConditions.has_commander_and_follow_node(arg_100_0)
	return Managers.state.entity:system("ai_commander_system"):get_commander_unit(arg_100_0.unit) and arg_100_0.is_navbot_following_path
end

function BTConditions.confirmed_enemy_sighting_within_commander(arg_101_0)
	return var_0_0(arg_101_0.target_unit) and arg_101_0.dist_to_commander and arg_101_0.target_dist + arg_101_0.dist_to_commander < arg_101_0.max_combat_range
end

function BTConditions.confirmed_enemy_sighting_within_commander_sticky(arg_102_0)
	return ALIVE[arg_102_0.target_unit] and arg_102_0.confirmed_enemy_sighting_within_commander or arg_102_0.attack_locked_in_t
end

function BTConditions.should_teleport_to_commander(arg_103_0)
	local var_103_0 = arg_103_0.unit
	local var_103_1 = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_103_0)

	if var_103_1 then
		local var_103_2 = arg_103_0.breed.max_commander_distance

		if var_103_2 then
			local var_103_3 = POSITION_LOOKUP[var_103_1]
			local var_103_4 = POSITION_LOOKUP[var_103_0]

			if Vector3.distance_squared(var_103_3, var_103_4) > var_103_2 * var_103_2 then
				return true
			end
		end
	end

	return false
end

function BTConditions.has_command_attack(arg_104_0)
	return (arg_104_0.new_command_attack or arg_104_0.undergoing_command_attack) and (ALIVE[arg_104_0.target_unit] and arg_104_0.new_command_attack or (ALIVE[arg_104_0.locked_target_unit] or arg_104_0.attack_locked_in_t) and arg_104_0.undergoing_command_attack)
end

function BTConditions.pet_skeleton_is_armored(arg_105_0)
	return arg_105_0.breed.name == "pet_skeleton_armored"
end

function BTConditions.pet_skeleton_is_dual_wield(arg_106_0)
	return arg_106_0.breed.name == "pet_skeleton_dual_wield"
end

function BTConditions.pet_skeleton_has_shield(arg_107_0)
	return arg_107_0.breed.name == "pet_skeleton_with_shield"
end

function BTConditions.pet_skeleton_default(arg_108_0)
	return arg_108_0.breed.name == "pet_skeleton"
end

function BTConditions.has_charge_target(arg_109_0)
	return arg_109_0.charge_target
end

function BTConditions.wants_stand_ground(arg_110_0)
	return arg_110_0.command_state == CommandStates.StandingGround
end

function BTConditions.necromancer_not_exploded(arg_111_0)
	return not arg_111_0.explosion_triggered
end

function BTConditions.suiciding_whilst_staggering(arg_112_0)
	return arg_112_0.stagger and arg_112_0.suicide_run ~= nil and arg_112_0.suicide_run.explosion_started
end

function BTConditions.has_goal_destination(arg_113_0)
	return arg_113_0.goal_destination ~= nil
end

function BTConditions.should_mount_unit(arg_114_0)
	return arg_114_0.should_mount_unit ~= nil
end

function BTConditions.is_falling(arg_115_0)
	return arg_115_0.is_falling or arg_115_0.fall_state ~= nil
end

function BTConditions.is_gutter_runner_falling(arg_116_0)
	return not arg_116_0.high_ground_opportunity and not arg_116_0.pouncing_target and (arg_116_0.is_falling or arg_116_0.fall_state ~= nil)
end

function BTConditions.pack_master_needs_hook(arg_117_0)
	return arg_117_0.needs_hook
end

function BTConditions.look_for_players(arg_118_0)
	return arg_118_0.look_for_players
end

function BTConditions.suicide_run(arg_119_0)
	return arg_119_0.current_health_percent < 0.7
end

function BTConditions.should_use_interest_point(arg_120_0)
	return not arg_120_0.ignore_interest_points and not arg_120_0.confirmed_player_sighting
end

function BTConditions.give_command(arg_121_0)
	return arg_121_0.give_command and var_0_0(arg_121_0.target_unit) and arg_121_0.confirmed_player_sighting
end

function BTConditions.is_fleeing(arg_122_0)
	return var_0_0(arg_122_0.target_unit) or arg_122_0.is_fleeing
end

function BTConditions.loot_rat_stagger(arg_123_0)
	return BTConditions.stagger(arg_123_0) and not arg_123_0.dodge_damage_success
end

function BTConditions.loot_rat_dodge(arg_124_0)
	return arg_124_0.dodge_vector or arg_124_0.is_dodging
end

function BTConditions.loot_rat_flee(arg_125_0)
	return BTConditions.confirmed_player_sighting(arg_125_0) or arg_125_0.is_fleeing
end

function BTConditions.defend(arg_126_0)
	return arg_126_0.defend
end

function BTConditions.defend_get_in_position(arg_127_0)
	return arg_127_0.defend_get_in_position
end

function BTConditions.can_trigger_move_to(arg_128_0)
	return Managers.time:time("game") > (arg_128_0.trigger_time or 0) and var_0_0(arg_128_0.target_unit)
end

function BTConditions.globadier_skulked_for_too_long(arg_129_0)
	local var_129_0 = arg_129_0.advance_towards_players
	local var_129_1 = 15

	if var_129_0 then
		local var_129_2 = Managers.time:time("game")
		local var_129_3 = arg_129_0.throw_globe_data

		if var_129_3 and var_129_3.next_throw_at then
			return var_129_2 > var_129_3.next_throw_at + var_129_1
		else
			return var_129_0.timer > var_129_0.time_until_first_throw + var_129_1
		end
	end

	return false
end

function BTConditions.ratling_gunner_skulked_for_too_long(arg_130_0)
	if var_0_0(arg_130_0.target_unit) then
		local var_130_0 = 15
		local var_130_1 = arg_130_0.attack_pattern_data
		local var_130_2 = var_130_1 and var_130_1.last_fired
		local var_130_3 = Managers.time:time("game")
		local var_130_4 = arg_130_0.lurk_start

		if var_130_2 then
			return var_130_3 > var_130_2 + var_130_0
		elseif var_130_4 then
			return var_130_3 > var_130_4 + var_130_0
		end
	end

	return false
end

function BTConditions.should_defensive_idle(arg_131_0)
	local var_131_0 = Managers.time:time("game") - arg_131_0.surrounding_players_last

	return arg_131_0.defensive_mode_duration and var_131_0 >= 3
end

function BTConditions.should_be_defensive(arg_132_0)
	return arg_132_0.defensive_mode_duration and var_0_0(arg_132_0.target_unit)
end

function BTConditions.boss_phase_two(arg_133_0)
	return arg_133_0.current_phase == 2
end

function BTConditions.warlord_dual_wielding(arg_134_0)
	return arg_134_0.dual_wield_mode
end

function BTConditions.warlord_halberding(arg_135_0)
	return not arg_135_0.dual_wield_mode
end

function BTConditions.switching_weapons(arg_136_0)
	return arg_136_0.switching_weapons and not arg_136_0.defensive_mode_duration
end

function BTConditions.warcamp_retaliation_aoe(arg_137_0)
	return Unit.alive(arg_137_0.target_unit) and arg_137_0.num_chain_stagger and arg_137_0.num_chain_stagger > 2
end

function BTConditions.is_mounted(arg_138_0)
	local var_138_0 = arg_138_0.mounted_data.mount_unit

	return not arg_138_0.knocked_off_mount and HEALTH_ALIVE[var_138_0]
end

function BTConditions.knocked_off_mount(arg_139_0)
	return (arg_139_0.knocked_off_mount or not HEALTH_ALIVE[arg_139_0.mounted_data.mount_unit]) and HEALTH_ALIVE[arg_139_0.target_unit]
end

function BTConditions.ready_to_cast_spell(arg_140_0)
	return arg_140_0.ready_to_summon and not arg_140_0.about_to_mount and HEALTH_ALIVE[arg_140_0.target_unit]
end

function BTConditions.grey_seer_teleport_spell(arg_141_0)
	return arg_141_0.current_spell_name == "teleport" and arg_141_0.quick_teleport
end

function BTConditions.grey_seer_vermintide_spell(arg_142_0)
	return arg_142_0.current_spell_name == "vermintide"
end

function BTConditions.grey_seer_warp_lightning_spell(arg_143_0)
	return arg_143_0.current_spell_name == "warp_lightning"
end

function BTConditions.grey_seer_waiting_death(arg_144_0)
	return arg_144_0.current_phase == 6
end

function BTConditions.grey_seer_death(arg_145_0)
	return arg_145_0.current_phase == 5
end

function BTConditions.grey_seer_call_stormfiend(arg_146_0)
	return arg_146_0.call_stormfiend
end

function BTConditions.grey_seer_waiting_for_pickup(arg_147_0)
	return arg_147_0.waiting_for_pickup
end

function BTConditions.should_use_emote(arg_148_0)
	return arg_148_0.should_use_emote
end

function BTConditions.should_wait_idle(arg_149_0)
	if arg_149_0.idle_time then
		return Managers.time:time("game") - arg_149_0.idle_time >= 3
	else
		return false
	end
end

function BTConditions.beastmen_standard_bearer_place_standard(arg_150_0)
	return var_0_0(arg_150_0.target_unit) and not arg_150_0.has_placed_standard
end

function BTConditions.beastmen_standard_bearer_pickup_standard(arg_151_0)
	if arg_151_0.ignore_standard_pickup then
		return false
	end

	local var_151_0 = arg_151_0.target_distance_to_standard

	if arg_151_0.moving_to_pick_up_standard then
		return true
	else
		return arg_151_0.has_placed_standard and var_0_0(arg_151_0.target_unit) and HEALTH_ALIVE[arg_151_0.standard_unit] and var_151_0 and var_151_0 > arg_151_0.breed.pickup_standard_distance
	end
end

function BTConditions.beastmen_standard_bearer_move_and_place_standard(arg_152_0)
	return arg_152_0.move_and_place_standard
end

function BTConditions.ungor_archer_enter_melee_combat(arg_153_0)
	return arg_153_0.confirmed_player_sighting and var_0_0(arg_153_0.target_unit) and (arg_153_0.has_switched_weapons or arg_153_0.target_dist and arg_153_0.target_dist < 5)
end

function BTConditions.bestigor_at_smartobject(arg_154_0)
	return not (arg_154_0.charge_state ~= nil) and BTConditions.at_smartobject(arg_154_0)
end

function BTConditions.confirmed_player_sighting_standard_bearer(arg_155_0)
	return var_0_0(arg_155_0.target_unit) and arg_155_0.confirmed_player_sighting and arg_155_0.has_placed_standard
end

function BTConditions.standard_bearer_should_be_defensive(arg_156_0)
	local var_156_0 = arg_156_0.breed.pickup_standard_distance
	local var_156_1 = arg_156_0.breed.defensive_threshold_distance
	local var_156_2 = var_0_0(arg_156_0.target_unit) and arg_156_0.confirmed_player_sighting and arg_156_0.has_placed_standard
	local var_156_3 = arg_156_0.target_distance_to_standard
	local var_156_4 = var_156_3 and var_156_1 <= var_156_3 and var_156_3 <= var_156_0
	local var_156_5 = arg_156_0.move_state ~= "attacking"

	return var_156_2 and var_156_4 and var_156_5
end

function BTConditions.switch_to_melee_weapon(arg_157_0)
	return BTConditions.ungor_archer_enter_melee_combat(arg_157_0) and not arg_157_0.has_switched_weapons
end

function BTConditions.confirmed_player_sighting_and_has_switched_weapons(arg_158_0)
	return arg_158_0.confirmed_player_sighting and arg_158_0.has_switched_weapons
end

function BTConditions.player_controller_is_alive(arg_159_0)
	return arg_159_0.player_controller_unit and var_0_0(arg_159_0.player_controller_unit) and not arg_159_0.target_is_in_combat
end

function BTConditions.player_controller_is_in_combat(arg_160_0)
	return arg_160_0.player_controller_unit and arg_160_0.target_is_in_combat
end

function BTConditions.is_in_inn(arg_161_0)
	return arg_161_0.inn_idle_spots and global_is_inside_inn
end

function BTConditions.has_no_idle_spot(arg_162_0)
	return not arg_162_0.has_idle_spot
end

function BTConditions.is_transported(arg_163_0)
	return arg_163_0.is_transported
end
