-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_conditions.lua

BTConditions = not not BTConditions

require("scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_conditions")

local unit_alive = Unit.alive
local ScriptUnit = ScriptUnit

BTConditions.always_true = function (blackboard)
	-- function 1
	return true
end

BTConditions.always_false = function (blackboard)
	-- function 2
	return false
end

BTConditions.spawn = function (blackboard)
	-- function 3
	return blackboard.spawn
end

BTConditions.blocked = function (blackboard)
	-- function 4
	return blackboard.blocked
end

BTConditions.start_or_continue = function (blackboard)
	-- function 5
	return blackboard.attack_token == nil or not not blackboard.attack_token
end

BTConditions.ask_target_before_attacking = function (blackboard, condition_args, action)
	-- function 6
	if blackboard.attack_token then
		return blackboard.attack_token
	end

	local want_an_attack = true
	local target_unit = blackboard.target_unit
	local target_unit_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if target_unit_attack_intensity_extension then
		local attack_type = not not action.attack_intensity_type

		want_an_attack = target_unit_attack_intensity_extension:want_an_attack(attack_type)
	end

	return want_an_attack
end

BTConditions.first_shots_fired = function (blackboard)
	-- function 7
	return blackboard.first_shots_fired
end

BTConditions.stagger = function (blackboard)
	-- function 8
	if blackboard.stagger then
		if blackboard.stagger_prohibited then
			blackboard.stagger = false
		else
			return true
		end
	end
end

BTConditions.stagger_activated = function (blackboard)
	-- function 9
	if blackboard.stagger_activated then
		return true
	end

	return false
end

BTConditions.grey_seer_stagger = function (blackboard)
	-- function 10
	if blackboard.stagger then
		if blackboard.stagger_prohibited then
			blackboard.stagger = false
		else
			return not blackboard.about_to_mount
		end
	end
end

BTConditions.reset_attack = function (blackboard)
	-- function 11
	return blackboard.reset_attack
end

BTConditions.lord_intro = function (blackboard)
	-- function 12
	local t = Managers.time:time("game")

	return not not blackboard.intro_timer
end

BTConditions.warlord_jump_down = function (blackboard)
	-- function 13
	return blackboard.jump_from_pos
end

BTConditions.quick_teleport = function (blackboard)
	-- function 14
	return blackboard.quick_teleport
end

BTConditions.fling_skaven = function (blackboard)
	-- function 15
	return blackboard.fling_skaven
end

BTConditions.secondary_target = function (blackboard)
	-- function 16
	return blackboard.secondary_target
end

BTConditions.quick_jump = function (blackboard)
	-- function 17
	return blackboard.high_ground_opportunity
end

BTConditions.ninja_vanish = function (blackboard)
	-- function 18
	return blackboard.ninja_vanish
end

BTConditions.target_changed = function (blackboard)
	-- function 19
	return blackboard.target_changed
end

BTConditions.victim_grabbed = function (blackboard)
	-- function 20
	return blackboard.has_grabbed_victim
end

BTConditions.nurgling_spawned_by_altar = function (blackboard)
	-- function 21
	return blackboard.nurgling_spawned_by_altar
end

BTConditions.target_changed_and_distant = function (blackboard)
	-- function 22
	if blackboard.target_changed then
		if blackboard.previous_target_unit == nil then
			return true
		elseif blackboard.target_dist and blackboard.target_dist > 15 then
			local t = Managers.time:time("game")

			return not not blackboard.next_rage_time
		else
			blackboard.target_changed = nil
		end
	end

	return false
end

BTConditions.stormfiend_boss_rage = function (blackboard)
	-- function 23
	return blackboard.intro_rage
end

BTConditions.ratogre_target_reachable = function (blackboard)
	-- function 24
	return not not blackboard.jump_slam_data
end

BTConditions.chaos_spawn_grabbed_combat = function (blackboard)
	-- function 25
	return not not HEALTH_ALIVE[blackboard.victim_grabbed]
end

BTConditions.chaos_spawn_grabbed_throw = function (blackboard)
	-- function 26
	local knocked_down = AiUtils.unit_knocked_down(blackboard.victim_grabbed)

	return not not HEALTH_ALIVE[blackboard.victim_grabbed]
end

BTConditions.path_found = function (blackboard)
	-- function 27
	return not blackboard.no_path_found
end

BTConditions.ratogre_jump_dist = function (blackboard)
	-- function 28
	return not blackboard.target_outside_navmesh and not not blackboard.target_dist
end

BTConditions.ratogre_walking = function (blackboard)
	-- function 29
	return blackboard.ratogre_walking
end

BTConditions.escorting_rat_ogre = function (blackboard)
	-- function 30
	return blackboard.escorting_rat_ogre
end

BTConditions.in_vortex = function (blackboard)
	-- function 31
	return blackboard.in_vortex
end

BTConditions.in_gravity_well = function (blackboard)
	-- function 32
	return blackboard.gravity_well_position
end

BTConditions.at_smartobject = function (blackboard)
	-- function 33
	local next_smart_object_data = blackboard.next_smart_object_data
	local smartobject_is_next = next_smart_object_data.next_smart_object_id ~= nil

	if not smartobject_is_next then
		return false
	end

	local is_smart_objecting = blackboard.is_smart_objecting
	local nav_graph_system = Managers.state.entity:system("nav_graph_system")
	local smart_object_unit = not not next_smart_object_data.smart_object_data
	local has_nav_graph_extension, nav_graph_enabled = nav_graph_system:has_nav_graph(smart_object_unit)

	if has_nav_graph_extension and not nav_graph_enabled and not is_smart_objecting then
		return false
	end

	local is_in_smartobject_range = blackboard.is_in_smartobject_range
	local moving_state = blackboard.move_state == "moving"

	return is_in_smartobject_range and (not not moving_state or not not is_smart_objecting) or not is_in_smartobject_range and not not is_smart_objecting
end

BTConditions.gutter_runner_at_smartobject = function (blackboard)
	-- function 34
	if blackboard.jump_data then
		return false
	end

	return BTConditions.at_smartobject(blackboard)
end

BTConditions.ratogre_at_smartobject = function (blackboard)
	-- function 35
	if blackboard.keep_target then
		return false
	end

	return BTConditions.at_smartobject(blackboard)
end

BTConditions.stormfiend_boss_intro_jump_down = function (blackboard)
	-- function 36
	local is_in_intro = blackboard.jump_down_intro

	return not not BTConditions.at_smartobject(blackboard)
end

BTConditions.at_teleport_smartobject = function (blackboard)
	-- function 37
	local smart_object_type = blackboard.next_smart_object_data.smart_object_type
	local is_smart_object_teleporter = smart_object_type == "teleporters"
	local is_teleporting = blackboard.is_teleporting

	return not not is_smart_object_teleporter or not not is_teleporting
end

BTConditions.vortex_at_climb_or_jump = function (blackboard)
	-- function 38
	local at_climb = BTConditions.at_climb_smartobject(blackboard)
	local at_jump = BTConditions.at_jump_smartobject(blackboard)

	return not not at_climb or not not at_jump or not not blackboard.is_flying
end

BTConditions.at_climb_smartobject = function (blackboard)
	-- function 39
	local smart_object_type = blackboard.next_smart_object_data.smart_object_type
	local is_smart_object_ledge = smart_object_type == "ledges" or smart_object_type == "ledges_with_fence"
	local is_climbing = blackboard.is_climbing

	return not not is_smart_object_ledge or not not is_climbing
end

BTConditions.at_jump_smartobject = function (blackboard)
	-- function 40
	local is_smart_object_jump = blackboard.next_smart_object_data.smart_object_type == "jumps"
	local is_jumping = blackboard.is_jumping

	return not not is_smart_object_jump or not not is_jumping
end

BTConditions.at_door_smartobject = function (blackboard)
	-- function 41
	local smart_object_type = blackboard.next_smart_object_data.smart_object_type
	local is_smart_object_door = smart_object_type == "doors" or smart_object_type == "planks" or smart_object_type == "big_boy_destructible" or smart_object_type == "destructible_wall"
	local is_smashing_door = blackboard.is_smashing_door
	local is_scurrying_under_door = blackboard.is_scurrying_under_door

	return not not is_smart_object_door or not not is_smashing_door or not not is_scurrying_under_door
end

BTConditions.at_smart_object_and_door = function (blackboard)
	-- function 42
	return not not BTConditions.at_smartobject(blackboard)
end

BTConditions.has_destructible_as_target = function (blackboard)
	-- function 43
	local target = blackboard.target_unit
	local is_destructible_static = not ScriptUnit.has_extension(target, "locomotion_system")

	return not not unit_alive(target)
end

BTConditions.can_see_player = function (blackboard)
	-- function 44
	return unit_alive(blackboard.target_unit)
end

BTConditions.has_target = function (blackboard)
	-- function 45
	return unit_alive(blackboard.target_unit)
end

BTConditions.no_target = function (blackboard)
	-- function 46
	return not unit_alive(blackboard.target_unit)
end

BTConditions.tentacle_found_target = function (blackboard)
	-- function 47
	return not not unit_alive(blackboard.target_unit)
end

BTConditions.at_half_health = function (blackboard)
	-- function 48
	return blackboard.current_health_percent <= 0.5
end

BTConditions.at_one_third_health = function (blackboard)
	-- function 49
	return blackboard.current_health_percent <= 0.33
end

BTConditions.at_two_thirds_health = function (blackboard)
	-- function 50
	return blackboard.current_health_percent <= 0.66
end

BTConditions.at_one_fifth_health = function (blackboard)
	-- function 51
	return blackboard.current_health_percent <= 0.2
end

BTConditions.at_three_fifths_health = function (blackboard)
	-- function 52
	return blackboard.current_health_percent <= 0.6
end

BTConditions.less_than_one_health = function (blackboard)
	-- function 53
	return blackboard.current_health <= 1
end

BTConditions.can_transition_half_health = function (blackboard)
	-- function 54
	return blackboard.current_health_percent <= 0.5 and not not not blackboard.half_transition_done
end

BTConditions.can_transition_one_third_health = function (blackboard)
	-- function 55
	return blackboard.current_health_percent <= 0.33 and not not not blackboard.one_third_transition_done
end

BTConditions.dummy_not_escaped = function (blackboard)
	-- function 56
	return not blackboard.anim_cb_escape_finished
end

BTConditions.can_transition_two_thirds_health = function (blackboard)
	-- function 57
	return blackboard.current_health_percent <= 0.66 and not not not blackboard.two_thirds_transition_done
end

BTConditions.can_transition_one_fifth_health = function (blackboard)
	-- function 58
	return blackboard.current_health_percent <= 0.2 and not not not blackboard.one_fifth_transition_done
end

BTConditions.can_transition_three_fifths_health = function (blackboard)
	-- function 59
	return blackboard.current_health_percent <= 0.6 and not not not blackboard.three_fifths_transition_done
end

BTConditions.transitioned_half_health = function (blackboard)
	-- function 60
	return blackboard.current_health_percent <= 0.5 and not not blackboard.half_transition_done
end

BTConditions.transitioned_three_fifths_health = function (blackboard)
	-- function 61
	return blackboard.current_health_percent <= 0.6 and not not blackboard.three_fifths_transition_done
end

BTConditions.transitioned_one_fifth_health = function (blackboard)
	-- function 62
	return blackboard.current_health_percent <= 0.2 and not not blackboard.one_fifth_transition_done
end

BTConditions.transitioned_one_third_health = function (blackboard)
	-- function 63
	return blackboard.current_health_percent <= 0.33 and not not blackboard.one_third_transition_done
end

BTConditions.transitioned_two_thirds_health = function (blackboard)
	-- function 64
	return blackboard.current_health_percent <= 0.66 and not not blackboard.two_thirds_transition_done
end

BTConditions.sorcerer_allow_tricke_spawn = function (blackboard)
	-- function 65
	return blackboard.sorcerer_allow_tricke_spawn
end

BTConditions.spawned_allies_dead_or_time = function (blackboard)
	-- function 66
	return blackboard.spawn_allies_horde and not not blackboard.spawn_allies_horde.is_dead or not blackboard.spawn_allies_horde and blackboard.defensive_phase_duration == 0
end

BTConditions.first_ring_summon = function (blackboard)
	-- function 67
	return blackboard.ring_summonings_finished == 0
end

BTConditions.ready_to_summon_rings = function (blackboard)
	-- function 68
	return blackboard.ring_cooldown == 0
end

BTConditions.ready_to_charge = function (blackboard)
	-- function 69
	return blackboard.charge_cooldown == 0
end

BTConditions.ready_to_teleport = function (blackboard)
	-- function 70
	return blackboard.teleport_cooldown == 0
end

BTConditions.ready_to_summon_wave = function (blackboard)
	-- function 71
	return blackboard.wave_cooldown == 0
end

BTConditions.not_ready_to_summon_wave = function (blackboard)
	-- function 72
	return not blackboard.ready_to_summon or blackboard.summoning
end

BTConditions.ready_to_summon = function (blackboard)
	-- function 73
	return not not blackboard.ready_to_summon
end

BTConditions.ready_to_summon_vortex = function (blackboard)
	-- function 74
	return blackboard.current_spell_name == "vortex"
end

BTConditions.ready_to_summon_plague_wave = function (blackboard)
	-- function 75
	return blackboard.current_spell_name == "plague_wave"
end

BTConditions.ready_to_summon_tentacle = function (blackboard)
	-- function 76
	return blackboard.current_spell_name == "tentacle"
end

BTConditions.ready_to_cast_missile = function (blackboard)
	-- function 77
	return blackboard.current_spell_name == "magic_missile"
end

BTConditions.ready_to_cast_seeking_bomb_missile = function (blackboard)
	-- function 78
	return blackboard.current_spell_name == "seeking_bomb_missile"
end

BTConditions.sorcerer_in_defensive_mode = function (blackboard)
	-- function 79
	return blackboard.mode == "defensive" and not not not blackboard.is_summoning
end

BTConditions.sorcerer_in_setup_mode = function (blackboard)
	-- function 80
	return blackboard.mode == "setup" and not not not blackboard.setup_done
end

BTConditions.escape_teleport = function (blackboard)
	-- function 81
	return blackboard.escape_teleport
end

BTConditions.defensive_mode_starts = function (blackboard)
	-- function 82
	return blackboard.phase == "defensive_starts"
end

BTConditions.sorcerer_defensive_combat = function (blackboard)
	-- function 83
	return blackboard.phase == "defensive_combat"
end

BTConditions.defensive_mode_ends = function (blackboard)
	-- function 84
	return blackboard.phase == "defensive_ends"
end

BTConditions.ready_to_explode = function (blackboard)
	-- function 85
	return blackboard.ready_to_summon
end

BTConditions.player_spotted = function (blackboard)
	-- function 86
	return not not unit_alive(blackboard.target_unit)
end

BTConditions.in_melee_range = function (blackboard)
	-- function 87
	return not not unit_alive(blackboard.target_unit)
end

BTConditions.approach_target = function (blackboard)
	-- function 88
	return blackboard.approach_target
end

BTConditions.comitted_to_target = function (blackboard)
	-- function 89
	local t = Managers.time:time("game")
	local pounce_timer_is_finished = t > blackboard.initial_pounce_timer

	return blackboard.target_unit and not not pounce_timer_is_finished or not blackboard.target_unit and not not blackboard.comitted_to_target
end

BTConditions.in_sprint_dist = function (blackboard)
	-- function 90
	return not not blackboard.closing
end

BTConditions.in_run_dist = function (blackboard)
	-- function 91
	return blackboard.target_dist <= 8
end

BTConditions.troll_downed = function (blackboard)
	-- function 92
	return not not blackboard.can_get_downed
end

BTConditions.troll_chief_phase_success = function (blackboard)
	-- function 93
	local _, _, _, _, phase = blackboard.health_extension:respawn_thresholds()

	return phase > blackboard.downed_phase
end

BTConditions.needs_to_crouch = function (blackboard)
	-- function 94
	return not not blackboard.needs_to_crouch
end

BTConditions.reset_utility = function (blackboard)
	-- function 95
	return not blackboard.reset_utility
end

BTConditions.is_alerted = function (blackboard)
	-- function 96
	local alerted = not not unit_alive(blackboard.target_unit)
	local is_taunted = unit_alive(blackboard.taunt_unit)
	local taunt_hesitate = not not is_taunted and not blackboard.taunt_hesitate_finished and not not not blackboard.no_taunt_hesitate

	return not not alerted or not not taunt_hesitate
end

BTConditions.confirmed_player_sighting = function (blackboard)
	-- function 97
	return not not unit_alive(blackboard.target_unit)
end

BTConditions.commander_disabled_or_resuming = function (blackboard)
	-- function 98
	return ALIVE[blackboard.commander_unit] and not not ScriptUnit.extension(blackboard.commander_unit, "status_system"):is_disabled() or not ALIVE[blackboard.commander_unit] and not not blackboard.disabled_resume_time
end

BTConditions.commander_disabled = function (blackboard)
	-- function 99
	return not not ALIVE[blackboard.commander_unit]
end

BTConditions.has_commander_and_follow_node = function (blackboard)
	-- function 100
	local commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(blackboard.unit)

	return not not commander_unit and not not blackboard.is_navbot_following_path
end

BTConditions.confirmed_enemy_sighting_within_commander = function (blackboard)
	-- function 101
	return not not unit_alive(blackboard.target_unit)
end

BTConditions.confirmed_enemy_sighting_within_commander_sticky = function (blackboard)
	-- function 102
	return ALIVE[blackboard.target_unit] and not not blackboard.confirmed_enemy_sighting_within_commander or not ALIVE[blackboard.target_unit] and not not blackboard.attack_locked_in_t
end

BTConditions.should_teleport_to_commander = function (blackboard)
	-- function 103
	local controlled_unit = blackboard.unit
	local commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(controlled_unit)

	if commander_unit then
		local max_commander_distance = blackboard.breed.max_commander_distance

		if max_commander_distance then
			local commander_position = POSITION_LOOKUP[commander_unit]
			local self_position = POSITION_LOOKUP[controlled_unit]
			local distance_sq = Vector3.distance_squared(commander_position, self_position)

			if distance_sq > max_commander_distance * max_commander_distance then
				return true
			end
		end
	end

	return false
end

BTConditions.has_command_attack = function (blackboard)
	-- function 104
	return blackboard.new_command_attack and (ALIVE[blackboard.target_unit] and not not blackboard.new_command_attack or not ALIVE[blackboard.target_unit] and (ALIVE[blackboard.locked_target_unit] and not not blackboard.undergoing_command_attack or not ALIVE[blackboard.locked_target_unit] and not not blackboard.attack_locked_in_t)) or not blackboard.new_command_attack and not not blackboard.undergoing_command_attack
end

BTConditions.pet_skeleton_is_armored = function (blackboard)
	-- function 105
	return blackboard.breed.name == "pet_skeleton_armored"
end

BTConditions.pet_skeleton_is_dual_wield = function (blackboard)
	-- function 106
	return blackboard.breed.name == "pet_skeleton_dual_wield"
end

BTConditions.pet_skeleton_has_shield = function (blackboard)
	-- function 107
	return blackboard.breed.name == "pet_skeleton_with_shield"
end

BTConditions.pet_skeleton_default = function (blackboard)
	-- function 108
	return blackboard.breed.name == "pet_skeleton"
end

BTConditions.has_charge_target = function (blackboard)
	-- function 109
	return blackboard.charge_target
end

BTConditions.wants_stand_ground = function (blackboard)
	-- function 110
	return blackboard.command_state == CommandStates.StandingGround
end

BTConditions.necromancer_not_exploded = function (blackboard)
	-- function 111
	return not blackboard.explosion_triggered
end

BTConditions.suiciding_whilst_staggering = function (blackboard)
	-- function 112
	return not not blackboard.stagger
end

BTConditions.has_goal_destination = function (blackboard)
	-- function 113
	return blackboard.goal_destination ~= nil
end

BTConditions.should_mount_unit = function (blackboard)
	-- function 114
	return blackboard.should_mount_unit ~= nil
end

BTConditions.is_falling = function (blackboard)
	-- function 115
	return not not blackboard.is_falling
end

BTConditions.is_gutter_runner_falling = function (blackboard)
	-- function 116
	return blackboard.fall_state ~= nil
end

BTConditions.pack_master_needs_hook = function (blackboard)
	-- function 117
	return blackboard.needs_hook
end

BTConditions.look_for_players = function (blackboard)
	-- function 118
	return blackboard.look_for_players
end

BTConditions.suicide_run = function (blackboard)
	-- function 119
	return blackboard.current_health_percent < 0.7
end

BTConditions.should_use_interest_point = function (blackboard)
	-- function 120
	return not blackboard.ignore_interest_points and not not not blackboard.confirmed_player_sighting
end

BTConditions.give_command = function (blackboard)
	-- function 121
	return not not blackboard.give_command
end

BTConditions.is_fleeing = function (blackboard)
	-- function 122
	return not not unit_alive(blackboard.target_unit)
end

BTConditions.loot_rat_stagger = function (blackboard)
	-- function 123
	return not not BTConditions.stagger(blackboard)
end

BTConditions.loot_rat_dodge = function (blackboard)
	-- function 124
	return not not blackboard.dodge_vector
end

BTConditions.loot_rat_flee = function (blackboard)
	-- function 125
	return not not BTConditions.confirmed_player_sighting(blackboard)
end

BTConditions.defend = function (blackboard)
	-- function 126
	return blackboard.defend
end

BTConditions.defend_get_in_position = function (blackboard)
	-- function 127
	return blackboard.defend_get_in_position
end

BTConditions.can_trigger_move_to = function (blackboard)
	-- function 128
	local t = Managers.time:time("game")
	local trigger_time = not not blackboard.trigger_time

	return trigger_time < t and not not unit_alive(blackboard.target_unit)
end

BTConditions.globadier_skulked_for_too_long = function (blackboard)
	-- function 129
	local adv_data = blackboard.advance_towards_players
	local skulk_timeout = 15

	if adv_data then
		local t = Managers.time:time("game")
		local throw_globe_data = blackboard.throw_globe_data

		if throw_globe_data and throw_globe_data.next_throw_at then
			return t > throw_globe_data.next_throw_at + skulk_timeout
		else
			return adv_data.timer > adv_data.time_until_first_throw + skulk_timeout
		end
	end

	return false
end

BTConditions.ratling_gunner_skulked_for_too_long = function (blackboard)
	-- function 130
	if unit_alive(blackboard.target_unit) then
		local skulk_timeout = 15
		local pattern_data = blackboard.attack_pattern_data
		local last_fired = not not pattern_data and not not pattern_data.last_fired
		local t = Managers.time:time("game")
		local lurk_start = blackboard.lurk_start

		if last_fired then
			return t > last_fired + skulk_timeout
		elseif lurk_start then
			return t > lurk_start + skulk_timeout
		end
	end

	return false
end

BTConditions.should_defensive_idle = function (blackboard)
	-- function 131
	local t = Managers.time:time("game")
	local time_since_surrounding_players = t - blackboard.surrounding_players_last

	return not not blackboard.defensive_mode_duration
end

BTConditions.should_be_defensive = function (blackboard)
	-- function 132
	return not not blackboard.defensive_mode_duration
end

BTConditions.boss_phase_two = function (blackboard)
	-- function 133
	return blackboard.current_phase == 2
end

BTConditions.warlord_dual_wielding = function (blackboard)
	-- function 134
	return blackboard.dual_wield_mode
end

BTConditions.warlord_halberding = function (blackboard)
	-- function 135
	return not blackboard.dual_wield_mode
end

BTConditions.switching_weapons = function (blackboard)
	-- function 136
	return not not blackboard.switching_weapons
end

BTConditions.warcamp_retaliation_aoe = function (blackboard)
	-- function 137
	return not not Unit.alive(blackboard.target_unit)
end

BTConditions.is_mounted = function (blackboard)
	-- function 138
	local mount_unit = blackboard.mounted_data.mount_unit

	return not blackboard.knocked_off_mount and not not HEALTH_ALIVE[mount_unit]
end

BTConditions.knocked_off_mount = function (blackboard)
	-- function 139
	return blackboard.knocked_off_mount and not not HEALTH_ALIVE[blackboard.target_unit] or not blackboard.knocked_off_mount and not HEALTH_ALIVE[blackboard.mounted_data.mount_unit] and not not HEALTH_ALIVE[blackboard.target_unit]
end

BTConditions.ready_to_cast_spell = function (blackboard)
	-- function 140
	return not not blackboard.ready_to_summon
end

BTConditions.grey_seer_teleport_spell = function (blackboard)
	-- function 141
	return blackboard.current_spell_name == "teleport" and not not blackboard.quick_teleport
end

BTConditions.grey_seer_vermintide_spell = function (blackboard)
	-- function 142
	return blackboard.current_spell_name == "vermintide"
end

BTConditions.grey_seer_warp_lightning_spell = function (blackboard)
	-- function 143
	return blackboard.current_spell_name == "warp_lightning"
end

BTConditions.grey_seer_waiting_death = function (blackboard)
	-- function 144
	return blackboard.current_phase == 6
end

BTConditions.grey_seer_death = function (blackboard)
	-- function 145
	return blackboard.current_phase == 5
end

BTConditions.grey_seer_call_stormfiend = function (blackboard)
	-- function 146
	return blackboard.call_stormfiend
end

BTConditions.grey_seer_waiting_for_pickup = function (blackboard)
	-- function 147
	return blackboard.waiting_for_pickup
end

BTConditions.should_use_emote = function (blackboard)
	-- function 148
	return blackboard.should_use_emote
end

BTConditions.should_wait_idle = function (blackboard)
	-- function 149
	if blackboard.idle_time then
		local t = Managers.time:time("game")
		local time_spent_in_idle = t - blackboard.idle_time

		return time_spent_in_idle >= 3
	else
		return false
	end
end

BTConditions.beastmen_standard_bearer_place_standard = function (blackboard)
	-- function 150
	return not not unit_alive(blackboard.target_unit)
end

BTConditions.beastmen_standard_bearer_pickup_standard = function (blackboard)
	-- function 151
	if blackboard.ignore_standard_pickup then
		return false
	end

	local target_distance_to_standard = blackboard.target_distance_to_standard

	if blackboard.moving_to_pick_up_standard then
		return true
	else
		return not not blackboard.has_placed_standard
	end
end

BTConditions.beastmen_standard_bearer_move_and_place_standard = function (blackboard)
	-- function 152
	local has_move_and_place_standard_position = blackboard.move_and_place_standard

	return has_move_and_place_standard_position
end

BTConditions.ungor_archer_enter_melee_combat = function (blackboard)
	-- function 153
	return not not blackboard.confirmed_player_sighting
end

BTConditions.bestigor_at_smartobject = function (blackboard)
	-- function 154
	local in_charge_action = blackboard.charge_state ~= nil
	local at_smartobject = not in_charge_action and not not BTConditions.at_smartobject(blackboard)

	return at_smartobject
end

BTConditions.confirmed_player_sighting_standard_bearer = function (blackboard)
	-- function 155
	return not not unit_alive(blackboard.target_unit)
end

BTConditions.standard_bearer_should_be_defensive = function (blackboard)
	-- function 156
	local pickup_standard_distance = blackboard.breed.pickup_standard_distance
	local defensive_threshold_distance = blackboard.breed.defensive_threshold_distance
	local in_combat = not not unit_alive(blackboard.target_unit)
	local target_distance_to_standard = blackboard.target_distance_to_standard
	local target_is_within_range = not not target_distance_to_standard and defensive_threshold_distance <= target_distance_to_standard and target_distance_to_standard <= pickup_standard_distance
	local not_attacking = blackboard.move_state ~= "attacking"

	return not not in_combat and not not target_is_within_range and not not not_attacking
end

BTConditions.switch_to_melee_weapon = function (blackboard)
	-- function 157
	return not not BTConditions.ungor_archer_enter_melee_combat(blackboard)
end

BTConditions.confirmed_player_sighting_and_has_switched_weapons = function (blackboard)
	-- function 158
	return not not blackboard.confirmed_player_sighting
end

BTConditions.player_controller_is_alive = function (blackboard)
	-- function 159
	return not not blackboard.player_controller_unit
end

BTConditions.player_controller_is_in_combat = function (blackboard)
	-- function 160
	return not not blackboard.player_controller_unit
end

BTConditions.is_in_inn = function (blackboard)
	-- function 161
	return not not blackboard.inn_idle_spots
end

BTConditions.has_no_idle_spot = function (blackboard)
	-- function 162
	return not blackboard.has_idle_spot
end

BTConditions.is_transported = function (blackboard)
	-- function 163
	return blackboard.is_transported
end
