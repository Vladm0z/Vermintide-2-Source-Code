-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_conditions.lua

BTConditions = BTConditions or {}

require("scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_conditions")

local var_0_0 = Unit.alive
local var_0_1 = ScriptUnit

BTConditions.always_true = function (arg_1_0)
	return true
end

BTConditions.always_false = function (arg_2_0)
	return false
end

BTConditions.spawn = function (arg_3_0)
	return arg_3_0.spawn
end

BTConditions.blocked = function (arg_4_0)
	return arg_4_0.blocked
end

BTConditions.start_or_continue = function (arg_5_0)
	return arg_5_0.attack_token == nil or arg_5_0.attack_token
end

BTConditions.ask_target_before_attacking = function (arg_6_0, arg_6_1, arg_6_2)
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

BTConditions.first_shots_fired = function (arg_7_0)
	return arg_7_0.first_shots_fired
end

BTConditions.stagger = function (arg_8_0)
	if arg_8_0.stagger then
		if arg_8_0.stagger_prohibited then
			arg_8_0.stagger = false
		else
			return true
		end
	end
end

BTConditions.stagger_activated = function (arg_9_0)
	if arg_9_0.stagger_activated then
		return true
	end

	return false
end

BTConditions.grey_seer_stagger = function (arg_10_0)
	if arg_10_0.stagger then
		if arg_10_0.stagger_prohibited then
			arg_10_0.stagger = false
		else
			return not arg_10_0.about_to_mount
		end
	end
end

BTConditions.reset_attack = function (arg_11_0)
	return arg_11_0.reset_attack
end

BTConditions.lord_intro = function (arg_12_0)
	local var_12_0 = Managers.time:time("game")

	return arg_12_0.intro_timer and var_12_0 < arg_12_0.intro_timer
end

BTConditions.warlord_jump_down = function (arg_13_0)
	return arg_13_0.jump_from_pos
end

BTConditions.quick_teleport = function (arg_14_0)
	return arg_14_0.quick_teleport
end

BTConditions.fling_skaven = function (arg_15_0)
	return arg_15_0.fling_skaven
end

BTConditions.secondary_target = function (arg_16_0)
	return arg_16_0.secondary_target
end

BTConditions.quick_jump = function (arg_17_0)
	return arg_17_0.high_ground_opportunity
end

BTConditions.ninja_vanish = function (arg_18_0)
	return arg_18_0.ninja_vanish
end

BTConditions.target_changed = function (arg_19_0)
	return arg_19_0.target_changed
end

BTConditions.victim_grabbed = function (arg_20_0)
	return arg_20_0.has_grabbed_victim
end

BTConditions.nurgling_spawned_by_altar = function (arg_21_0)
	return arg_21_0.nurgling_spawned_by_altar
end

BTConditions.target_changed_and_distant = function (arg_22_0)
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

BTConditions.stormfiend_boss_rage = function (arg_23_0)
	return arg_23_0.intro_rage
end

BTConditions.ratogre_target_reachable = function (arg_24_0)
	return arg_24_0.jump_slam_data or not arg_24_0.target_outside_navmesh or arg_24_0.target_dist and arg_24_0.target_dist <= arg_24_0.breed.reach_distance
end

BTConditions.chaos_spawn_grabbed_combat = function (arg_25_0)
	return HEALTH_ALIVE[arg_25_0.victim_grabbed] and not AiUtils.unit_knocked_down(arg_25_0.victim_grabbed) and not arg_25_0.wants_to_throw
end

BTConditions.chaos_spawn_grabbed_throw = function (arg_26_0)
	local var_26_0 = AiUtils.unit_knocked_down(arg_26_0.victim_grabbed)

	return HEALTH_ALIVE[arg_26_0.victim_grabbed] and (var_26_0 or arg_26_0.wants_to_throw)
end

BTConditions.path_found = function (arg_27_0)
	return not arg_27_0.no_path_found
end

BTConditions.ratogre_jump_dist = function (arg_28_0)
	return not arg_28_0.target_outside_navmesh and arg_28_0.target_dist and arg_28_0.target_dist <= 15
end

BTConditions.ratogre_walking = function (arg_29_0)
	return arg_29_0.ratogre_walking
end

BTConditions.escorting_rat_ogre = function (arg_30_0)
	return arg_30_0.escorting_rat_ogre
end

BTConditions.in_vortex = function (arg_31_0)
	return arg_31_0.in_vortex
end

BTConditions.in_gravity_well = function (arg_32_0)
	return arg_32_0.gravity_well_position
end

BTConditions.at_smartobject = function (arg_33_0)
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

BTConditions.gutter_runner_at_smartobject = function (arg_34_0)
	if arg_34_0.jump_data then
		return false
	end

	return BTConditions.at_smartobject(arg_34_0)
end

BTConditions.ratogre_at_smartobject = function (arg_35_0)
	if arg_35_0.keep_target then
		return false
	end

	return BTConditions.at_smartobject(arg_35_0)
end

BTConditions.stormfiend_boss_intro_jump_down = function (arg_36_0)
	local var_36_0 = arg_36_0.jump_down_intro

	return BTConditions.at_smartobject(arg_36_0) and var_36_0
end

BTConditions.at_teleport_smartobject = function (arg_37_0)
	local var_37_0 = arg_37_0.next_smart_object_data.smart_object_type == "teleporters"
	local var_37_1 = arg_37_0.is_teleporting

	return var_37_0 or var_37_1
end

BTConditions.vortex_at_climb_or_jump = function (arg_38_0)
	local var_38_0 = BTConditions.at_climb_smartobject(arg_38_0)
	local var_38_1 = BTConditions.at_jump_smartobject(arg_38_0)

	return var_38_0 or var_38_1 or arg_38_0.is_flying
end

BTConditions.at_climb_smartobject = function (arg_39_0)
	local var_39_0 = arg_39_0.next_smart_object_data.smart_object_type
	local var_39_1 = var_39_0 == "ledges" or var_39_0 == "ledges_with_fence"
	local var_39_2 = arg_39_0.is_climbing

	return var_39_1 or var_39_2
end

BTConditions.at_jump_smartobject = function (arg_40_0)
	local var_40_0 = arg_40_0.next_smart_object_data.smart_object_type == "jumps"
	local var_40_1 = arg_40_0.is_jumping

	return var_40_0 or var_40_1
end

BTConditions.at_door_smartobject = function (arg_41_0)
	local var_41_0 = arg_41_0.next_smart_object_data.smart_object_type
	local var_41_1 = var_41_0 == "doors" or var_41_0 == "planks" or var_41_0 == "big_boy_destructible" or var_41_0 == "destructible_wall"
	local var_41_2 = arg_41_0.is_smashing_door
	local var_41_3 = arg_41_0.is_scurrying_under_door

	return var_41_1 or var_41_2 or var_41_3
end

BTConditions.at_smart_object_and_door = function (arg_42_0)
	return BTConditions.at_smartobject(arg_42_0) and BTConditions.at_door_smartobject(arg_42_0)
end

BTConditions.has_destructible_as_target = function (arg_43_0)
	local var_43_0 = arg_43_0.target_unit
	local var_43_1 = not var_0_1.has_extension(var_43_0, "locomotion_system")

	return var_0_0(var_43_0) and arg_43_0.confirmed_player_sighting and var_43_1
end

BTConditions.can_see_player = function (arg_44_0)
	return var_0_0(arg_44_0.target_unit)
end

BTConditions.has_target = function (arg_45_0)
	return var_0_0(arg_45_0.target_unit)
end

BTConditions.no_target = function (arg_46_0)
	return not var_0_0(arg_46_0.target_unit)
end

BTConditions.tentacle_found_target = function (arg_47_0)
	return var_0_0(arg_47_0.target_unit) and not arg_47_0.tentacle_satisfied
end

BTConditions.at_half_health = function (arg_48_0)
	return arg_48_0.current_health_percent <= 0.5
end

BTConditions.at_one_third_health = function (arg_49_0)
	return arg_49_0.current_health_percent <= 0.33
end

BTConditions.at_two_thirds_health = function (arg_50_0)
	return arg_50_0.current_health_percent <= 0.66
end

BTConditions.at_one_fifth_health = function (arg_51_0)
	return arg_51_0.current_health_percent <= 0.2
end

BTConditions.at_three_fifths_health = function (arg_52_0)
	return arg_52_0.current_health_percent <= 0.6
end

BTConditions.less_than_one_health = function (arg_53_0)
	return arg_53_0.current_health <= 1
end

BTConditions.can_transition_half_health = function (arg_54_0)
	return arg_54_0.current_health_percent <= 0.5 and not arg_54_0.half_transition_done
end

BTConditions.can_transition_one_third_health = function (arg_55_0)
	return arg_55_0.current_health_percent <= 0.33 and not arg_55_0.one_third_transition_done
end

BTConditions.dummy_not_escaped = function (arg_56_0)
	return not arg_56_0.anim_cb_escape_finished
end

BTConditions.can_transition_two_thirds_health = function (arg_57_0)
	return arg_57_0.current_health_percent <= 0.66 and not arg_57_0.two_thirds_transition_done
end

BTConditions.can_transition_one_fifth_health = function (arg_58_0)
	return arg_58_0.current_health_percent <= 0.2 and not arg_58_0.one_fifth_transition_done
end

BTConditions.can_transition_three_fifths_health = function (arg_59_0)
	return arg_59_0.current_health_percent <= 0.6 and not arg_59_0.three_fifths_transition_done
end

BTConditions.transitioned_half_health = function (arg_60_0)
	return arg_60_0.current_health_percent <= 0.5 and arg_60_0.half_transition_done
end

BTConditions.transitioned_three_fifths_health = function (arg_61_0)
	return arg_61_0.current_health_percent <= 0.6 and arg_61_0.three_fifths_transition_done
end

BTConditions.transitioned_one_fifth_health = function (arg_62_0)
	return arg_62_0.current_health_percent <= 0.2 and arg_62_0.one_fifth_transition_done
end

BTConditions.transitioned_one_third_health = function (arg_63_0)
	return arg_63_0.current_health_percent <= 0.33 and arg_63_0.one_third_transition_done
end

BTConditions.transitioned_two_thirds_health = function (arg_64_0)
	return arg_64_0.current_health_percent <= 0.66 and arg_64_0.two_thirds_transition_done
end

BTConditions.sorcerer_allow_tricke_spawn = function (arg_65_0)
	return arg_65_0.sorcerer_allow_tricke_spawn
end

BTConditions.spawned_allies_dead_or_time = function (arg_66_0)
	return arg_66_0.spawn_allies_horde and arg_66_0.spawn_allies_horde.is_dead or arg_66_0.defensive_phase_duration == 0
end

BTConditions.first_ring_summon = function (arg_67_0)
	return arg_67_0.ring_summonings_finished == 0
end

BTConditions.ready_to_summon_rings = function (arg_68_0)
	return arg_68_0.ring_cooldown == 0
end

BTConditions.ready_to_charge = function (arg_69_0)
	return arg_69_0.charge_cooldown == 0
end

BTConditions.ready_to_teleport = function (arg_70_0)
	return arg_70_0.teleport_cooldown == 0
end

BTConditions.ready_to_summon_wave = function (arg_71_0)
	return arg_71_0.wave_cooldown == 0
end

BTConditions.not_ready_to_summon_wave = function (arg_72_0)
	return not arg_72_0.ready_to_summon or not arg_72_0.summoning and not Unit.alive(arg_72_0.target_unit) or arg_72_0.wave_cooldown ~= 0
end

BTConditions.ready_to_summon = function (arg_73_0)
	return arg_73_0.ready_to_summon and (arg_73_0.summoning or Unit.alive(arg_73_0.target_unit))
end

BTConditions.ready_to_summon_vortex = function (arg_74_0)
	return arg_74_0.current_spell_name == "vortex"
end

BTConditions.ready_to_summon_plague_wave = function (arg_75_0)
	return arg_75_0.current_spell_name == "plague_wave"
end

BTConditions.ready_to_summon_tentacle = function (arg_76_0)
	return arg_76_0.current_spell_name == "tentacle"
end

BTConditions.ready_to_cast_missile = function (arg_77_0)
	return arg_77_0.current_spell_name == "magic_missile"
end

BTConditions.ready_to_cast_seeking_bomb_missile = function (arg_78_0)
	return arg_78_0.current_spell_name == "seeking_bomb_missile"
end

BTConditions.sorcerer_in_defensive_mode = function (arg_79_0)
	return arg_79_0.mode == "defensive" and not arg_79_0.is_summoning
end

BTConditions.sorcerer_in_setup_mode = function (arg_80_0)
	return arg_80_0.mode == "setup" and not arg_80_0.setup_done
end

BTConditions.escape_teleport = function (arg_81_0)
	return arg_81_0.escape_teleport
end

BTConditions.defensive_mode_starts = function (arg_82_0)
	return arg_82_0.phase == "defensive_starts"
end

BTConditions.sorcerer_defensive_combat = function (arg_83_0)
	return arg_83_0.phase == "defensive_combat"
end

BTConditions.defensive_mode_ends = function (arg_84_0)
	return arg_84_0.phase == "defensive_ends"
end

BTConditions.ready_to_explode = function (arg_85_0)
	return arg_85_0.ready_to_summon
end

BTConditions.player_spotted = function (arg_86_0)
	return var_0_0(arg_86_0.target_unit) and not arg_86_0.confirmed_player_sighting
end

BTConditions.in_melee_range = function (arg_87_0)
	return var_0_0(arg_87_0.target_unit) and arg_87_0.in_melee_range
end

BTConditions.approach_target = function (arg_88_0)
	return arg_88_0.approach_target
end

BTConditions.comitted_to_target = function (arg_89_0)
	local var_89_0 = Managers.time:time("game") > arg_89_0.initial_pounce_timer

	return (arg_89_0.target_unit or arg_89_0.comitted_to_target) and var_89_0
end

BTConditions.in_sprint_dist = function (arg_90_0)
	return arg_90_0.closing or arg_90_0.target_dist > 7
end

BTConditions.in_run_dist = function (arg_91_0)
	return arg_91_0.target_dist <= 7 or arg_91_0.movement_inited and arg_91_0.target_dist <= 8
end

BTConditions.troll_downed = function (arg_92_0)
	return arg_92_0.can_get_downed and arg_92_0.downed_state
end

BTConditions.troll_chief_phase_success = function (arg_93_0)
	local var_93_0, var_93_1, var_93_2, var_93_3, var_93_4 = arg_93_0.health_extension:respawn_thresholds()

	return var_93_4 > arg_93_0.downed_phase
end

BTConditions.needs_to_crouch = function (arg_94_0)
	return arg_94_0.needs_to_crouch and BTConditions.ratogre_target_reachable(arg_94_0)
end

BTConditions.reset_utility = function (arg_95_0)
	return not arg_95_0.reset_utility
end

BTConditions.is_alerted = function (arg_96_0)
	local var_96_0 = var_0_0(arg_96_0.target_unit) and arg_96_0.is_alerted and (not arg_96_0.confirmed_player_sighting or arg_96_0.hesitating)
	local var_96_1 = var_0_0(arg_96_0.taunt_unit) and not arg_96_0.taunt_hesitate_finished and not arg_96_0.no_taunt_hesitate

	return var_96_0 or var_96_1
end

BTConditions.confirmed_player_sighting = function (arg_97_0)
	return var_0_0(arg_97_0.target_unit) and arg_97_0.confirmed_player_sighting
end

BTConditions.commander_disabled_or_resuming = function (arg_98_0)
	return ALIVE[arg_98_0.commander_unit] and var_0_1.extension(arg_98_0.commander_unit, "status_system"):is_disabled() or arg_98_0.disabled_resume_time and Managers.time:time("game") < arg_98_0.disabled_resume_time
end

BTConditions.commander_disabled = function (arg_99_0)
	return ALIVE[arg_99_0.commander_unit] and var_0_1.extension(arg_99_0.commander_unit, "status_system"):is_disabled()
end

BTConditions.has_commander_and_follow_node = function (arg_100_0)
	return Managers.state.entity:system("ai_commander_system"):get_commander_unit(arg_100_0.unit) and arg_100_0.is_navbot_following_path
end

BTConditions.confirmed_enemy_sighting_within_commander = function (arg_101_0)
	return var_0_0(arg_101_0.target_unit) and arg_101_0.dist_to_commander and arg_101_0.target_dist + arg_101_0.dist_to_commander < arg_101_0.max_combat_range
end

BTConditions.confirmed_enemy_sighting_within_commander_sticky = function (arg_102_0)
	return ALIVE[arg_102_0.target_unit] and arg_102_0.confirmed_enemy_sighting_within_commander or arg_102_0.attack_locked_in_t
end

BTConditions.should_teleport_to_commander = function (arg_103_0)
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

BTConditions.has_command_attack = function (arg_104_0)
	return (arg_104_0.new_command_attack or arg_104_0.undergoing_command_attack) and (ALIVE[arg_104_0.target_unit] and arg_104_0.new_command_attack or (ALIVE[arg_104_0.locked_target_unit] or arg_104_0.attack_locked_in_t) and arg_104_0.undergoing_command_attack)
end

BTConditions.pet_skeleton_is_armored = function (arg_105_0)
	return arg_105_0.breed.name == "pet_skeleton_armored"
end

BTConditions.pet_skeleton_is_dual_wield = function (arg_106_0)
	return arg_106_0.breed.name == "pet_skeleton_dual_wield"
end

BTConditions.pet_skeleton_has_shield = function (arg_107_0)
	return arg_107_0.breed.name == "pet_skeleton_with_shield"
end

BTConditions.pet_skeleton_default = function (arg_108_0)
	return arg_108_0.breed.name == "pet_skeleton"
end

BTConditions.has_charge_target = function (arg_109_0)
	return arg_109_0.charge_target
end

BTConditions.wants_stand_ground = function (arg_110_0)
	return arg_110_0.command_state == CommandStates.StandingGround
end

BTConditions.necromancer_not_exploded = function (arg_111_0)
	return not arg_111_0.explosion_triggered
end

BTConditions.suiciding_whilst_staggering = function (arg_112_0)
	return arg_112_0.stagger and arg_112_0.suicide_run ~= nil and arg_112_0.suicide_run.explosion_started
end

BTConditions.has_goal_destination = function (arg_113_0)
	return arg_113_0.goal_destination ~= nil
end

BTConditions.should_mount_unit = function (arg_114_0)
	return arg_114_0.should_mount_unit ~= nil
end

BTConditions.is_falling = function (arg_115_0)
	return arg_115_0.is_falling or arg_115_0.fall_state ~= nil
end

BTConditions.is_gutter_runner_falling = function (arg_116_0)
	return not arg_116_0.high_ground_opportunity and not arg_116_0.pouncing_target and (arg_116_0.is_falling or arg_116_0.fall_state ~= nil)
end

BTConditions.pack_master_needs_hook = function (arg_117_0)
	return arg_117_0.needs_hook
end

BTConditions.look_for_players = function (arg_118_0)
	return arg_118_0.look_for_players
end

BTConditions.suicide_run = function (arg_119_0)
	return arg_119_0.current_health_percent < 0.7
end

BTConditions.should_use_interest_point = function (arg_120_0)
	return not arg_120_0.ignore_interest_points and not arg_120_0.confirmed_player_sighting
end

BTConditions.give_command = function (arg_121_0)
	return arg_121_0.give_command and var_0_0(arg_121_0.target_unit) and arg_121_0.confirmed_player_sighting
end

BTConditions.is_fleeing = function (arg_122_0)
	return var_0_0(arg_122_0.target_unit) or arg_122_0.is_fleeing
end

BTConditions.loot_rat_stagger = function (arg_123_0)
	return BTConditions.stagger(arg_123_0) and not arg_123_0.dodge_damage_success
end

BTConditions.loot_rat_dodge = function (arg_124_0)
	return arg_124_0.dodge_vector or arg_124_0.is_dodging
end

BTConditions.loot_rat_flee = function (arg_125_0)
	return BTConditions.confirmed_player_sighting(arg_125_0) or arg_125_0.is_fleeing
end

BTConditions.defend = function (arg_126_0)
	return arg_126_0.defend
end

BTConditions.defend_get_in_position = function (arg_127_0)
	return arg_127_0.defend_get_in_position
end

BTConditions.can_trigger_move_to = function (arg_128_0)
	return Managers.time:time("game") > (arg_128_0.trigger_time or 0) and var_0_0(arg_128_0.target_unit)
end

BTConditions.globadier_skulked_for_too_long = function (arg_129_0)
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

BTConditions.ratling_gunner_skulked_for_too_long = function (arg_130_0)
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

BTConditions.should_defensive_idle = function (arg_131_0)
	local var_131_0 = Managers.time:time("game") - arg_131_0.surrounding_players_last

	return arg_131_0.defensive_mode_duration and var_131_0 >= 3
end

BTConditions.should_be_defensive = function (arg_132_0)
	return arg_132_0.defensive_mode_duration and var_0_0(arg_132_0.target_unit)
end

BTConditions.boss_phase_two = function (arg_133_0)
	return arg_133_0.current_phase == 2
end

BTConditions.warlord_dual_wielding = function (arg_134_0)
	return arg_134_0.dual_wield_mode
end

BTConditions.warlord_halberding = function (arg_135_0)
	return not arg_135_0.dual_wield_mode
end

BTConditions.switching_weapons = function (arg_136_0)
	return arg_136_0.switching_weapons and not arg_136_0.defensive_mode_duration
end

BTConditions.warcamp_retaliation_aoe = function (arg_137_0)
	return Unit.alive(arg_137_0.target_unit) and arg_137_0.num_chain_stagger and arg_137_0.num_chain_stagger > 2
end

BTConditions.is_mounted = function (arg_138_0)
	local var_138_0 = arg_138_0.mounted_data.mount_unit

	return not arg_138_0.knocked_off_mount and HEALTH_ALIVE[var_138_0]
end

BTConditions.knocked_off_mount = function (arg_139_0)
	return (arg_139_0.knocked_off_mount or not HEALTH_ALIVE[arg_139_0.mounted_data.mount_unit]) and HEALTH_ALIVE[arg_139_0.target_unit]
end

BTConditions.ready_to_cast_spell = function (arg_140_0)
	return arg_140_0.ready_to_summon and not arg_140_0.about_to_mount and HEALTH_ALIVE[arg_140_0.target_unit]
end

BTConditions.grey_seer_teleport_spell = function (arg_141_0)
	return arg_141_0.current_spell_name == "teleport" and arg_141_0.quick_teleport
end

BTConditions.grey_seer_vermintide_spell = function (arg_142_0)
	return arg_142_0.current_spell_name == "vermintide"
end

BTConditions.grey_seer_warp_lightning_spell = function (arg_143_0)
	return arg_143_0.current_spell_name == "warp_lightning"
end

BTConditions.grey_seer_waiting_death = function (arg_144_0)
	return arg_144_0.current_phase == 6
end

BTConditions.grey_seer_death = function (arg_145_0)
	return arg_145_0.current_phase == 5
end

BTConditions.grey_seer_call_stormfiend = function (arg_146_0)
	return arg_146_0.call_stormfiend
end

BTConditions.grey_seer_waiting_for_pickup = function (arg_147_0)
	return arg_147_0.waiting_for_pickup
end

BTConditions.should_use_emote = function (arg_148_0)
	return arg_148_0.should_use_emote
end

BTConditions.should_wait_idle = function (arg_149_0)
	if arg_149_0.idle_time then
		return Managers.time:time("game") - arg_149_0.idle_time >= 3
	else
		return false
	end
end

BTConditions.beastmen_standard_bearer_place_standard = function (arg_150_0)
	return var_0_0(arg_150_0.target_unit) and not arg_150_0.has_placed_standard
end

BTConditions.beastmen_standard_bearer_pickup_standard = function (arg_151_0)
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

BTConditions.beastmen_standard_bearer_move_and_place_standard = function (arg_152_0)
	return arg_152_0.move_and_place_standard
end

BTConditions.ungor_archer_enter_melee_combat = function (arg_153_0)
	return arg_153_0.confirmed_player_sighting and var_0_0(arg_153_0.target_unit) and (arg_153_0.has_switched_weapons or arg_153_0.target_dist and arg_153_0.target_dist < 5)
end

BTConditions.bestigor_at_smartobject = function (arg_154_0)
	return not (arg_154_0.charge_state ~= nil) and BTConditions.at_smartobject(arg_154_0)
end

BTConditions.confirmed_player_sighting_standard_bearer = function (arg_155_0)
	return var_0_0(arg_155_0.target_unit) and arg_155_0.confirmed_player_sighting and arg_155_0.has_placed_standard
end

BTConditions.standard_bearer_should_be_defensive = function (arg_156_0)
	local var_156_0 = arg_156_0.breed.pickup_standard_distance
	local var_156_1 = arg_156_0.breed.defensive_threshold_distance
	local var_156_2 = var_0_0(arg_156_0.target_unit) and arg_156_0.confirmed_player_sighting and arg_156_0.has_placed_standard
	local var_156_3 = arg_156_0.target_distance_to_standard
	local var_156_4 = var_156_3 and var_156_1 <= var_156_3 and var_156_3 <= var_156_0
	local var_156_5 = arg_156_0.move_state ~= "attacking"

	return var_156_2 and var_156_4 and var_156_5
end

BTConditions.switch_to_melee_weapon = function (arg_157_0)
	return BTConditions.ungor_archer_enter_melee_combat(arg_157_0) and not arg_157_0.has_switched_weapons
end

BTConditions.confirmed_player_sighting_and_has_switched_weapons = function (arg_158_0)
	return arg_158_0.confirmed_player_sighting and arg_158_0.has_switched_weapons
end

BTConditions.player_controller_is_alive = function (arg_159_0)
	return arg_159_0.player_controller_unit and var_0_0(arg_159_0.player_controller_unit) and not arg_159_0.target_is_in_combat
end

BTConditions.player_controller_is_in_combat = function (arg_160_0)
	return arg_160_0.player_controller_unit and arg_160_0.target_is_in_combat
end

BTConditions.is_in_inn = function (arg_161_0)
	return arg_161_0.inn_idle_spots and global_is_inside_inn
end

BTConditions.has_no_idle_spot = function (arg_162_0)
	return not arg_162_0.has_idle_spot
end

BTConditions.is_transported = function (arg_163_0)
	return arg_163_0.is_transported
end
