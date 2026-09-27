-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_conditions.lua

local BTConditions = BTConditions

BTConditions = BTConditions or {}
BTConditions = BTConditions

require("scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_conditions")

local alive = Unit.alive
local ScriptUnit = ScriptUnit

BTConditions.always_true = function (arg_1_0)
	-- function 1
	return true
end

BTConditions.always_false = function (arg_2_0)
	-- function 2
	return false
end

BTConditions.spawn = function (self)
	-- function 3
	return self.spawn
end

BTConditions.blocked = function (self)
	-- function 4
	return self.blocked
end

BTConditions.start_or_continue = function (self)
	-- function 5
	return self.attack_token == nil or self.attack_token
end

BTConditions.ask_target_before_attacking = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self.attack_token then
		return self.attack_token
	end

	local flag = true
	local target_unit = self.target_unit
	local has_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not has_extension then
		local attack_intensity_type = arg_6_2.attack_intensity_type

		attack_intensity_type = attack_intensity_type or "normal"
		flag = has_extension:want_an_attack(attack_intensity_type)
	end

	return flag
end

BTConditions.first_shots_fired = function (self)
	-- function 7
	return self.first_shots_fired
end

BTConditions.stagger = function (self)
	-- function 8
	if not self.stagger then
		if not self.stagger_prohibited then
			self.stagger = false
		else
			return true
		end
	end
end

BTConditions.stagger_activated = function (self)
	-- function 9
	if not self.stagger_activated then
		return true
	end

	return false
end

BTConditions.grey_seer_stagger = function (self)
	-- function 10
	if not self.stagger then
		if not self.stagger_prohibited then
			self.stagger = false
		else
			return not self.about_to_mount
		end
	end
end

BTConditions.reset_attack = function (self)
	-- function 11
	return self.reset_attack
end

BTConditions.lord_intro = function (self)
	-- function 12
	local time = Managers.time:time("game")
	local intro_timer = self.intro_timer

	intro_timer = not intro_timer and time < self.intro_timer

	return intro_timer
end

BTConditions.warlord_jump_down = function (self)
	-- function 13
	return self.jump_from_pos
end

BTConditions.quick_teleport = function (self)
	-- function 14
	return self.quick_teleport
end

BTConditions.fling_skaven = function (self)
	-- function 15
	return self.fling_skaven
end

BTConditions.secondary_target = function (self)
	-- function 16
	return self.secondary_target
end

BTConditions.quick_jump = function (self)
	-- function 17
	return self.high_ground_opportunity
end

BTConditions.ninja_vanish = function (self)
	-- function 18
	return self.ninja_vanish
end

BTConditions.target_changed = function (self)
	-- function 19
	return self.target_changed
end

BTConditions.victim_grabbed = function (self)
	-- function 20
	return self.has_grabbed_victim
end

BTConditions.nurgling_spawned_by_altar = function (self)
	-- function 21
	return self.nurgling_spawned_by_altar
end

BTConditions.target_changed_and_distant = function (self)
	-- function 22
	if not self.target_changed then
		if self.previous_target_unit == nil then
			return true
		elseif not (not self.target_dist and not (self.target_dist > 15)) then
			local time = Managers.time:time("game")
			local next_rage_time = self.next_rage_time

			next_rage_time = not next_rage_time and time > self.next_rage_time

			return next_rage_time
		else
			self.target_changed = nil
		end
	end

	return false
end

BTConditions.stormfiend_boss_rage = function (self)
	-- function 23
	return self.intro_rage
end

BTConditions.ratogre_target_reachable = function (self)
	-- function 24
	local jump_slam_data = self.jump_slam_data

	if not jump_slam_data then
		if not self.target_outside_navmesh then
			jump_slam_data = self.target_dist

			if not jump_slam_data then
				-- Nothing
			end

			if not (self.target_dist <= self.breed.reach_distance) then
				jump_slam_data = false

				goto label_24_0
			end
		end

		jump_slam_data = true
	end

	::label_24_0::

	return jump_slam_data
end

BTConditions.chaos_spawn_grabbed_combat = function (self)
	-- function 25
	local var_25_0 = HEALTH_ALIVE[self.victim_grabbed]

	var_25_0 = not var_25_0 and not not AiUtils.unit_knocked_down(self.victim_grabbed) or not self.wants_to_throw

	return var_25_0
end

BTConditions.chaos_spawn_grabbed_throw = function (self)
	-- function 26
	local unit_knocked_down = AiUtils.unit_knocked_down(self.victim_grabbed)

	return unit_knocked_down or self.wants_to_throw or not HEALTH_ALIVE[self.victim_grabbed]
end

BTConditions.path_found = function (self)
	-- function 27
	return not self.no_path_found
end

BTConditions.ratogre_jump_dist = function (self)
	-- function 28
	local target_dist

	if not self.target_outside_navmesh then
		target_dist = self.target_dist

		if not target_dist then
			-- Nothing
		end

		if not (self.target_dist <= 15) then
			-- Nothing
		end
	end

	target_dist = false

	goto label_28_1

	::label_28_0::

	target_dist = true

	::label_28_1::

	return target_dist
end

BTConditions.ratogre_walking = function (self)
	-- function 29
	return self.ratogre_walking
end

BTConditions.escorting_rat_ogre = function (self)
	-- function 30
	return self.escorting_rat_ogre
end

BTConditions.in_vortex = function (self)
	-- function 31
	return self.in_vortex
end

BTConditions.in_gravity_well = function (self)
	-- function 32
	return self.gravity_well_position
end

BTConditions.at_smartobject = function (self)
	-- function 33
	local next_smart_object_data = self.next_smart_object_data

	if not (next_smart_object_data.next_smart_object_id ~= nil) then
		return false
	end

	local is_smart_objecting = self.is_smart_objecting
	local system = Managers.state.entity:system("nav_graph_system")
	local smart_object_data = next_smart_object_data.smart_object_data

	smart_object_data = not smart_object_data and next_smart_object_data.smart_object_data.unit

	local has_nav_graph, var_33_5 = system:has_nav_graph(smart_object_data)

	if not (not has_nav_graph and var_33_5 or is_smart_objecting) then
		return false
	end

	local is_in_smartobject_range = self.is_in_smartobject_range
	local flag = self.move_state == "moving"

	return not is_in_smartobject_range and flag and is_smart_objecting
end

BTConditions.gutter_runner_at_smartobject = function (self)
	-- function 34
	if not self.jump_data then
		return false
	end

	return BTConditions.at_smartobject(self)
end

BTConditions.ratogre_at_smartobject = function (self)
	-- function 35
	if not self.keep_target then
		return false
	end

	return BTConditions.at_smartobject(self)
end

BTConditions.stormfiend_boss_intro_jump_down = function (self)
	-- function 36
	local jump_down_intro = self.jump_down_intro
	local at_smartobject = BTConditions.at_smartobject(self)

	at_smartobject = not at_smartobject and jump_down_intro

	return at_smartobject
end

BTConditions.at_teleport_smartobject = function (self)
	-- function 37
	local flag = self.next_smart_object_data.smart_object_type == "teleporters"
	local is_teleporting = self.is_teleporting

	return flag or is_teleporting
end

BTConditions.vortex_at_climb_or_jump = function (self)
	-- function 38
	local at_climb_smartobject = BTConditions.at_climb_smartobject(self)
	local at_jump_smartobject = BTConditions.at_jump_smartobject(self)

	return at_climb_smartobject or at_jump_smartobject or self.is_flying
end

BTConditions.at_climb_smartobject = function (self)
	-- function 39
	local smart_object_type = self.next_smart_object_data.smart_object_type
	local flag = smart_object_type == "ledges" or smart_object_type == "ledges_with_fence"
	local is_climbing = self.is_climbing

	return flag or is_climbing
end

BTConditions.at_jump_smartobject = function (self)
	-- function 40
	local flag = self.next_smart_object_data.smart_object_type == "jumps"
	local is_jumping = self.is_jumping

	return flag or is_jumping
end

BTConditions.at_door_smartobject = function (self)
	-- function 41
	local smart_object_type = self.next_smart_object_data.smart_object_type
	local flag = smart_object_type == "doors" or smart_object_type == "planks" or smart_object_type == "big_boy_destructible" or smart_object_type == "destructible_wall"
	local is_smashing_door = self.is_smashing_door
	local is_scurrying_under_door = self.is_scurrying_under_door

	return flag or is_smashing_door or is_scurrying_under_door
end

BTConditions.at_smart_object_and_door = function (arg_42_0)
	-- function 42
	local at_smartobject = BTConditions.at_smartobject(arg_42_0)

	at_smartobject = not at_smartobject and BTConditions.at_door_smartobject(arg_42_0)

	return at_smartobject
end

BTConditions.has_destructible_as_target = function (self)
	-- function 43
	local target_unit = self.target_unit
	local flag = not ScriptUnit.has_extension(target_unit, "locomotion_system")
	local var_43_2 = alive(target_unit)

	if not var_43_2 then
		var_43_2 = self.confirmed_player_sighting
		var_43_2 = not var_43_2 and flag
	end

	return var_43_2
end

BTConditions.can_see_player = function (self)
	-- function 44
	return alive(self.target_unit)
end

BTConditions.has_target = function (self)
	-- function 45
	return alive(self.target_unit)
end

BTConditions.no_target = function (self)
	-- function 46
	return not alive(self.target_unit)
end

BTConditions.tentacle_found_target = function (self)
	-- function 47
	local var_47_0 = alive(self.target_unit)

	var_47_0 = not var_47_0 and not self.tentacle_satisfied

	return var_47_0
end

BTConditions.at_half_health = function (self)
	-- function 48
	return self.current_health_percent <= 0.5
end

BTConditions.at_one_third_health = function (self)
	-- function 49
	return self.current_health_percent <= 0.33
end

BTConditions.at_two_thirds_health = function (self)
	-- function 50
	return self.current_health_percent <= 0.66
end

BTConditions.at_one_fifth_health = function (self)
	-- function 51
	return self.current_health_percent <= 0.2
end

BTConditions.at_three_fifths_health = function (self)
	-- function 52
	return self.current_health_percent <= 0.6
end

BTConditions.less_than_one_health = function (self)
	-- function 53
	return self.current_health <= 1
end

BTConditions.can_transition_half_health = function (self)
	-- function 54
	return not (self.current_health_percent <= 0.5) or not self.half_transition_done
end

BTConditions.can_transition_one_third_health = function (self)
	-- function 55
	return not (self.current_health_percent <= 0.33) or not self.one_third_transition_done
end

BTConditions.dummy_not_escaped = function (self)
	-- function 56
	return not self.anim_cb_escape_finished
end

BTConditions.can_transition_two_thirds_health = function (self)
	-- function 57
	return not (self.current_health_percent <= 0.66) or not self.two_thirds_transition_done
end

BTConditions.can_transition_one_fifth_health = function (self)
	-- function 58
	return not (self.current_health_percent <= 0.2) or not self.one_fifth_transition_done
end

BTConditions.can_transition_three_fifths_health = function (self)
	-- function 59
	return not (self.current_health_percent <= 0.6) or not self.three_fifths_transition_done
end

BTConditions.transitioned_half_health = function (self)
	-- function 60
	return not (self.current_health_percent <= 0.5) or self.half_transition_done
end

BTConditions.transitioned_three_fifths_health = function (self)
	-- function 61
	return not (self.current_health_percent <= 0.6) or self.three_fifths_transition_done
end

BTConditions.transitioned_one_fifth_health = function (self)
	-- function 62
	return not (self.current_health_percent <= 0.2) or self.one_fifth_transition_done
end

BTConditions.transitioned_one_third_health = function (self)
	-- function 63
	return not (self.current_health_percent <= 0.33) or self.one_third_transition_done
end

BTConditions.transitioned_two_thirds_health = function (self)
	-- function 64
	return not (self.current_health_percent <= 0.66) or self.two_thirds_transition_done
end

BTConditions.sorcerer_allow_tricke_spawn = function (self)
	-- function 65
	return self.sorcerer_allow_tricke_spawn
end

BTConditions.spawned_allies_dead_or_time = function (self)
	-- function 66
	local is_dead

	if not self.spawn_allies_horde then
		is_dead = self.spawn_allies_horde.is_dead

		if not is_dead then
			-- Nothing
		end
	end

	is_dead = self.defensive_phase_duration == 0

	::label_66_0::

	return is_dead
end

BTConditions.first_ring_summon = function (self)
	-- function 67
	return self.ring_summonings_finished == 0
end

BTConditions.ready_to_summon_rings = function (self)
	-- function 68
	return self.ring_cooldown == 0
end

BTConditions.ready_to_charge = function (self)
	-- function 69
	return self.charge_cooldown == 0
end

BTConditions.ready_to_teleport = function (self)
	-- function 70
	return self.teleport_cooldown == 0
end

BTConditions.ready_to_summon_wave = function (self)
	-- function 71
	return self.wave_cooldown == 0
end

BTConditions.not_ready_to_summon_wave = function (self)
	-- function 72
	return not self.ready_to_summon and self.summoning and not Unit.alive(self.target_unit) and self.wave_cooldown ~= 0
end

BTConditions.ready_to_summon = function (self)
	-- function 73
	local ready_to_summon = self.ready_to_summon

	if not ready_to_summon then
		ready_to_summon = self.summoning
		ready_to_summon = ready_to_summon or Unit.alive(self.target_unit)
	end

	return ready_to_summon
end

BTConditions.ready_to_summon_vortex = function (self)
	-- function 74
	return self.current_spell_name == "vortex"
end

BTConditions.ready_to_summon_plague_wave = function (self)
	-- function 75
	return self.current_spell_name == "plague_wave"
end

BTConditions.ready_to_summon_tentacle = function (self)
	-- function 76
	return self.current_spell_name == "tentacle"
end

BTConditions.ready_to_cast_missile = function (self)
	-- function 77
	return self.current_spell_name == "magic_missile"
end

BTConditions.ready_to_cast_seeking_bomb_missile = function (self)
	-- function 78
	return self.current_spell_name == "seeking_bomb_missile"
end

BTConditions.sorcerer_in_defensive_mode = function (self)
	-- function 79
	return self.mode ~= "defensive" or not self.is_summoning
end

BTConditions.sorcerer_in_setup_mode = function (self)
	-- function 80
	return self.mode ~= "setup" or not self.setup_done
end

BTConditions.escape_teleport = function (self)
	-- function 81
	return self.escape_teleport
end

BTConditions.defensive_mode_starts = function (self)
	-- function 82
	return self.phase == "defensive_starts"
end

BTConditions.sorcerer_defensive_combat = function (self)
	-- function 83
	return self.phase == "defensive_combat"
end

BTConditions.defensive_mode_ends = function (self)
	-- function 84
	return self.phase == "defensive_ends"
end

BTConditions.ready_to_explode = function (self)
	-- function 85
	return self.ready_to_summon
end

BTConditions.player_spotted = function (self)
	-- function 86
	local var_86_0 = alive(self.target_unit)

	var_86_0 = not var_86_0 and not self.confirmed_player_sighting

	return var_86_0
end

BTConditions.in_melee_range = function (self)
	-- function 87
	local var_87_0 = alive(self.target_unit)

	var_87_0 = not var_87_0 and self.in_melee_range

	return var_87_0
end

BTConditions.approach_target = function (self)
	-- function 88
	return self.approach_target
end

BTConditions.comitted_to_target = function (self)
	-- function 89
	local flag = Managers.time:time("game") > self.initial_pounce_timer
	local comitted_to_target

	if not self.target_unit then
		comitted_to_target = self.comitted_to_target

		if not comitted_to_target then
			-- Nothing
		end
	end

	comitted_to_target = flag

	::label_89_0::

	return comitted_to_target
end

BTConditions.in_sprint_dist = function (self)
	-- function 90
	local closing = self.closing

	closing = closing or self.target_dist > 7

	return closing
end

BTConditions.in_run_dist = function (self)
	-- function 91
	local movement_inited

	if not (self.target_dist <= 7) then
		movement_inited = self.movement_inited

		if not movement_inited then
			-- Nothing
		end

		if not (self.target_dist <= 8) then
			movement_inited = false

			goto label_91_0
		end
	end

	movement_inited = true

	::label_91_0::

	return movement_inited
end

BTConditions.troll_downed = function (self)
	-- function 92
	local can_get_downed = self.can_get_downed

	can_get_downed = not can_get_downed and self.downed_state

	return can_get_downed
end

BTConditions.troll_chief_phase_success = function (self)
	-- function 93
	local respawn_thresholds, var_93_1, var_93_2, var_93_3, var_93_4 = self.health_extension:respawn_thresholds()

	return var_93_4 > self.downed_phase
end

BTConditions.needs_to_crouch = function (self)
	-- function 94
	local needs_to_crouch = self.needs_to_crouch

	needs_to_crouch = not needs_to_crouch and BTConditions.ratogre_target_reachable(self)

	return needs_to_crouch
end

BTConditions.reset_utility = function (self)
	-- function 95
	return not self.reset_utility
end

BTConditions.is_alerted = function (self)
	-- function 96
	local var_96_0 = alive(self.target_unit)

	if not var_96_0 then
		var_96_0 = self.is_alerted
		var_96_0 = not var_96_0 and not self.confirmed_player_sighting and self.hesitating
	end

	local flag = not alive(self.taunt_unit) and not not self.taunt_hesitate_finished or not self.no_taunt_hesitate

	return var_96_0 or flag
end

BTConditions.confirmed_player_sighting = function (self)
	-- function 97
	local var_97_0 = alive(self.target_unit)

	var_97_0 = not var_97_0 and self.confirmed_player_sighting

	return var_97_0
end

BTConditions.commander_disabled_or_resuming = function (self)
	-- function 98
	local is_disabled

	if not ALIVE[self.commander_unit] then
		is_disabled = ScriptUnit.extension(self.commander_unit, "status_system"):is_disabled()

		if not is_disabled then
			-- Nothing
		end
	end

	is_disabled = self.disabled_resume_time
	is_disabled = not is_disabled and Managers.time:time("game") < self.disabled_resume_time

	::label_98_0::

	return is_disabled
end

BTConditions.commander_disabled = function (self)
	-- function 99
	local var_99_0 = ALIVE[self.commander_unit]

	var_99_0 = not var_99_0 and ScriptUnit.extension(self.commander_unit, "status_system"):is_disabled()

	return var_99_0
end

BTConditions.has_commander_and_follow_node = function (self)
	-- function 100
	return not Managers.state.entity:system("ai_commander_system"):get_commander_unit(self.unit) and self.is_navbot_following_path
end

BTConditions.confirmed_enemy_sighting_within_commander = function (self)
	-- function 101
	local var_101_0 = alive(self.target_unit)

	if not var_101_0 then
		var_101_0 = self.dist_to_commander
		var_101_0 = not var_101_0 and self.target_dist + self.dist_to_commander < self.max_combat_range
	end

	return var_101_0
end

BTConditions.confirmed_enemy_sighting_within_commander_sticky = function (self)
	-- function 102
	local confirmed_enemy_sighting_within_commander

	if not ALIVE[self.target_unit] then
		confirmed_enemy_sighting_within_commander = self.confirmed_enemy_sighting_within_commander

		if not confirmed_enemy_sighting_within_commander then
			-- Nothing
		end
	end

	confirmed_enemy_sighting_within_commander = self.attack_locked_in_t

	::label_102_0::

	return confirmed_enemy_sighting_within_commander
end

BTConditions.should_teleport_to_commander = function (self)
	-- function 103
	local unit = self.unit
	local get_commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(unit)

	if not get_commander_unit then
		local max_commander_distance = self.breed.max_commander_distance

		if not max_commander_distance then
			local var_103_3 = POSITION_LOOKUP[get_commander_unit]
			local var_103_4 = POSITION_LOOKUP[unit]

			if Vector3.distance_squared(var_103_3, var_103_4) > max_commander_distance * max_commander_distance then
				return true
			end
		end
	end

	return false
end

BTConditions.has_command_attack = function (self)
	-- function 104
	local undergoing_command_attack

	if not self.new_command_attack then
		undergoing_command_attack = self.undergoing_command_attack

		if not undergoing_command_attack then
			-- Nothing
		end
	end

	if not ALIVE[self.target_unit] then
		undergoing_command_attack = self.new_command_attack

		if not undergoing_command_attack then
			-- Nothing
		end
	end

	if not ALIVE[self.locked_target_unit] then
		undergoing_command_attack = self.attack_locked_in_t

		if not undergoing_command_attack then
			-- Nothing
		end
	end

	undergoing_command_attack = self.undergoing_command_attack

	::label_104_0::

	return undergoing_command_attack
end

BTConditions.pet_skeleton_is_armored = function (self)
	-- function 105
	return self.breed.name == "pet_skeleton_armored"
end

BTConditions.pet_skeleton_is_dual_wield = function (self)
	-- function 106
	return self.breed.name == "pet_skeleton_dual_wield"
end

BTConditions.pet_skeleton_has_shield = function (self)
	-- function 107
	return self.breed.name == "pet_skeleton_with_shield"
end

BTConditions.pet_skeleton_default = function (self)
	-- function 108
	return self.breed.name == "pet_skeleton"
end

BTConditions.has_charge_target = function (self)
	-- function 109
	return self.charge_target
end

BTConditions.wants_stand_ground = function (self)
	-- function 110
	return self.command_state == CommandStates.StandingGround
end

BTConditions.necromancer_not_exploded = function (self)
	-- function 111
	return not self.explosion_triggered
end

BTConditions.suiciding_whilst_staggering = function (self)
	-- function 112
	local stagger = self.stagger

	stagger = not stagger and self.suicide_run == nil or self.suicide_run.explosion_started

	return stagger
end

BTConditions.has_goal_destination = function (self)
	-- function 113
	return self.goal_destination ~= nil
end

BTConditions.should_mount_unit = function (self)
	-- function 114
	return self.should_mount_unit ~= nil
end

BTConditions.is_falling = function (self)
	-- function 115
	local is_falling = self.is_falling

	is_falling = is_falling or self.fall_state ~= nil

	return is_falling
end

BTConditions.is_gutter_runner_falling = function (self)
	-- function 116
	local is_falling

	if not (self.high_ground_opportunity or self.pouncing_target) then
		is_falling = self.is_falling

		if not is_falling then
			-- Nothing
		end

		if self.fall_state == nil then
			-- Nothing
		end
	end

	is_falling = false

	goto label_116_1

	::label_116_0::

	is_falling = true

	::label_116_1::

	return is_falling
end

BTConditions.pack_master_needs_hook = function (self)
	-- function 117
	return self.needs_hook
end

BTConditions.look_for_players = function (self)
	-- function 118
	return self.look_for_players
end

BTConditions.suicide_run = function (self)
	-- function 119
	return self.current_health_percent < 0.7
end

BTConditions.should_use_interest_point = function (self)
	-- function 120
	return not not self.ignore_interest_points or not self.confirmed_player_sighting
end

BTConditions.give_command = function (self)
	-- function 121
	local give_command = self.give_command

	if not give_command then
		give_command = alive(self.target_unit)
		give_command = not give_command and self.confirmed_player_sighting
	end

	return give_command
end

BTConditions.is_fleeing = function (self)
	-- function 122
	local var_122_0 = alive(self.target_unit)

	var_122_0 = var_122_0 or self.is_fleeing

	return var_122_0
end

BTConditions.loot_rat_stagger = function (self)
	-- function 123
	local stagger = BTConditions.stagger(self)

	stagger = not stagger and not self.dodge_damage_success

	return stagger
end

BTConditions.loot_rat_dodge = function (self)
	-- function 124
	local dodge_vector = self.dodge_vector

	dodge_vector = dodge_vector or self.is_dodging

	return dodge_vector
end

BTConditions.loot_rat_flee = function (self)
	-- function 125
	local confirmed_player_sighting = BTConditions.confirmed_player_sighting(self)

	confirmed_player_sighting = confirmed_player_sighting or self.is_fleeing

	return confirmed_player_sighting
end

BTConditions.defend = function (self)
	-- function 126
	return self.defend
end

BTConditions.defend_get_in_position = function (self)
	-- function 127
	return self.defend_get_in_position
end

BTConditions.can_trigger_move_to = function (self)
	-- function 128
	local time = Managers.time:time("game")
	local trigger_time = self.trigger_time

	trigger_time = trigger_time or 0

	return not (trigger_time < time) or alive(self.target_unit)
end

BTConditions.globadier_skulked_for_too_long = function (self)
	-- function 129
	local advance_towards_players = self.advance_towards_players
	local num = 15

	if not advance_towards_players then
		local time = Managers.time:time("game")
		local throw_globe_data = self.throw_globe_data

		if not throw_globe_data and not throw_globe_data.next_throw_at then
			return time > throw_globe_data.next_throw_at + num
		else
			return advance_towards_players.timer > advance_towards_players.time_until_first_throw + num
		end
	end

	return false
end

BTConditions.ratling_gunner_skulked_for_too_long = function (self)
	-- function 130
	if not alive(self.target_unit) then
		local num = 15
		local attack_pattern_data = self.attack_pattern_data
		local flag = not attack_pattern_data and attack_pattern_data.last_fired
		local time = Managers.time:time("game")
		local lurk_start = self.lurk_start

		if not flag then
			return time > flag + num
		elseif not lurk_start then
			return time > lurk_start + num
		end
	end

	return false
end

BTConditions.should_defensive_idle = function (self)
	-- function 131
	local num = Managers.time:time("game") - self.surrounding_players_last
	local defensive_mode_duration = self.defensive_mode_duration

	defensive_mode_duration = not defensive_mode_duration and num >= 3

	return defensive_mode_duration
end

BTConditions.should_be_defensive = function (self)
	-- function 132
	local defensive_mode_duration = self.defensive_mode_duration

	defensive_mode_duration = not defensive_mode_duration and alive(self.target_unit)

	return defensive_mode_duration
end

BTConditions.boss_phase_two = function (self)
	-- function 133
	return self.current_phase == 2
end

BTConditions.warlord_dual_wielding = function (self)
	-- function 134
	return self.dual_wield_mode
end

BTConditions.warlord_halberding = function (self)
	-- function 135
	return not self.dual_wield_mode
end

BTConditions.switching_weapons = function (self)
	-- function 136
	local switching_weapons = self.switching_weapons

	switching_weapons = not switching_weapons and not self.defensive_mode_duration

	return switching_weapons
end

BTConditions.warcamp_retaliation_aoe = function (self)
	-- function 137
	local alive = Unit.alive(self.target_unit)

	if not alive then
		alive = self.num_chain_stagger
		alive = not alive and self.num_chain_stagger > 2
	end

	return alive
end

BTConditions.is_mounted = function (self)
	-- function 138
	local mount_unit = self.mounted_data.mount_unit

	return not not self.knocked_off_mount or HEALTH_ALIVE[mount_unit]
end

BTConditions.knocked_off_mount = function (self)
	-- function 139
	return (self.knocked_off_mount or not HEALTH_ALIVE[self.mounted_data.mount_unit]) and HEALTH_ALIVE[self.target_unit]
end

BTConditions.ready_to_cast_spell = function (self)
	-- function 140
	local ready_to_summon = self.ready_to_summon

	ready_to_summon = not ready_to_summon and not not self.about_to_mount or HEALTH_ALIVE[self.target_unit]

	return ready_to_summon
end

BTConditions.grey_seer_teleport_spell = function (self)
	-- function 141
	return self.current_spell_name ~= "teleport" or self.quick_teleport
end

BTConditions.grey_seer_vermintide_spell = function (self)
	-- function 142
	return self.current_spell_name == "vermintide"
end

BTConditions.grey_seer_warp_lightning_spell = function (self)
	-- function 143
	return self.current_spell_name == "warp_lightning"
end

BTConditions.grey_seer_waiting_death = function (self)
	-- function 144
	return self.current_phase == 6
end

BTConditions.grey_seer_death = function (self)
	-- function 145
	return self.current_phase == 5
end

BTConditions.grey_seer_call_stormfiend = function (self)
	-- function 146
	return self.call_stormfiend
end

BTConditions.grey_seer_waiting_for_pickup = function (self)
	-- function 147
	return self.waiting_for_pickup
end

BTConditions.should_use_emote = function (self)
	-- function 148
	return self.should_use_emote
end

BTConditions.should_wait_idle = function (self)
	-- function 149
	if not self.idle_time then
		return Managers.time:time("game") - self.idle_time >= 3
	else
		return false
	end
end

BTConditions.beastmen_standard_bearer_place_standard = function (self)
	-- function 150
	local var_150_0 = alive(self.target_unit)

	var_150_0 = not var_150_0 and not self.has_placed_standard

	return var_150_0
end

BTConditions.beastmen_standard_bearer_pickup_standard = function (self)
	-- function 151
	if not self.ignore_standard_pickup then
		return false
	end

	local target_distance_to_standard = self.target_distance_to_standard

	if not self.moving_to_pick_up_standard then
		return true
	else
		local has_placed_standard = self.has_placed_standard

		if not has_placed_standard then
			has_placed_standard = alive(self.target_unit)

			if not has_placed_standard then
				has_placed_standard = HEALTH_ALIVE[self.standard_unit]
				has_placed_standard = not has_placed_standard and not target_distance_to_standard and target_distance_to_standard > self.breed.pickup_standard_distance
			end
		end

		return has_placed_standard
	end
end

BTConditions.beastmen_standard_bearer_move_and_place_standard = function (self)
	-- function 152
	return self.move_and_place_standard
end

BTConditions.ungor_archer_enter_melee_combat = function (self)
	-- function 153
	local confirmed_player_sighting = self.confirmed_player_sighting

	if not confirmed_player_sighting then
		confirmed_player_sighting = alive(self.target_unit)

		if not confirmed_player_sighting then
			confirmed_player_sighting = self.has_switched_weapons

			if not confirmed_player_sighting then
				confirmed_player_sighting = self.target_dist
				confirmed_player_sighting = not confirmed_player_sighting and self.target_dist < 5
			end
		end
	end

	return confirmed_player_sighting
end

BTConditions.bestigor_at_smartobject = function (self)
	-- function 154
	return not not (self.charge_state ~= nil) or BTConditions.at_smartobject(self)
end

BTConditions.confirmed_player_sighting_standard_bearer = function (self)
	-- function 155
	local var_155_0 = alive(self.target_unit)

	if not var_155_0 then
		var_155_0 = self.confirmed_player_sighting
		var_155_0 = not var_155_0 and self.has_placed_standard
	end

	return var_155_0
end

BTConditions.standard_bearer_should_be_defensive = function (self)
	-- function 156
	local pickup_standard_distance = self.breed.pickup_standard_distance
	local defensive_threshold_distance = self.breed.defensive_threshold_distance
	local var_156_2 = alive(self.target_unit)

	if not var_156_2 then
		var_156_2 = self.confirmed_player_sighting
		var_156_2 = not var_156_2 and self.has_placed_standard
	end

	local target_distance_to_standard = self.target_distance_to_standard
	local flag = not target_distance_to_standard and not (defensive_threshold_distance <= target_distance_to_standard) or target_distance_to_standard <= pickup_standard_distance
	local flag_2 = self.move_state ~= "attacking"

	return not var_156_2 and not flag and flag_2
end

BTConditions.switch_to_melee_weapon = function (self)
	-- function 157
	local ungor_archer_enter_melee_combat = BTConditions.ungor_archer_enter_melee_combat(self)

	ungor_archer_enter_melee_combat = not ungor_archer_enter_melee_combat and not self.has_switched_weapons

	return ungor_archer_enter_melee_combat
end

BTConditions.confirmed_player_sighting_and_has_switched_weapons = function (self)
	-- function 158
	local confirmed_player_sighting = self.confirmed_player_sighting

	confirmed_player_sighting = not confirmed_player_sighting and self.has_switched_weapons

	return confirmed_player_sighting
end

BTConditions.player_controller_is_alive = function (self)
	-- function 159
	local player_controller_unit = self.player_controller_unit

	if not player_controller_unit then
		player_controller_unit = alive(self.player_controller_unit)
		player_controller_unit = not player_controller_unit and not self.target_is_in_combat
	end

	return player_controller_unit
end

BTConditions.player_controller_is_in_combat = function (self)
	-- function 160
	local player_controller_unit = self.player_controller_unit

	player_controller_unit = not player_controller_unit and self.target_is_in_combat

	return player_controller_unit
end

BTConditions.is_in_inn = function (self)
	-- function 161
	local inn_idle_spots = self.inn_idle_spots

	inn_idle_spots = not inn_idle_spots and global_is_inside_inn

	return inn_idle_spots
end

BTConditions.has_no_idle_spot = function (self)
	-- function 162
	return not self.has_idle_spot
end

BTConditions.is_transported = function (self)
	-- function 163
	return self.is_transported
end
