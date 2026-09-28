-- chunkname: @scripts/entity_system/systems/animation/animation_callback_templates.lua

local BLACKBOARDS = BLACKBOARDS
local stagger_types = require("scripts/utils/stagger_types")

AnimationCallbackTemplates = {}
AnimationCallbackTemplates.client = {}

AnimationCallbackTemplates.client.anim_cb_enable_second_hit_ragdoll = function (unit, param)
	-- function 1
	local death_ext = ScriptUnit.extension(unit, "death_system")

	death_ext:enable_second_hit_ragdoll()
end

AnimationCallbackTemplates.client.anim_cb_push_finished = function (unit, param)
	-- function 2
	local status_extension = ScriptUnit.has_extension(unit, "status_system")

	if status_extension then
		status_extension:set_stagger_animation_done(true)
	end
end

AnimationCallbackTemplates.server = {}

AnimationCallbackTemplates.server.anim_cb_spawn_finished = function (unit, param)
	-- function 3
	local blackboard = BLACKBOARDS[unit]

	blackboard.spawning_finished = true
end

AnimationCallbackTemplates.server.anim_cb_push_finished = function (unit, param)
	-- function 4
	local blackboard = BLACKBOARDS[unit]

	blackboard.stagger_anim_done = true
end

AnimationCallbackTemplates.server.anim_cb_stunned_finished = function (unit, param)
	-- function 5
	local blackboard = BLACKBOARDS[unit]

	blackboard.blocked = nil
end

AnimationCallbackTemplates.server.anim_cb_stagger_light_finished = function (unit, param)
	-- function 6
	if not ALIVE[unit] then
		return
	end

	local breed = Unit.get_data(unit, "breed")
	local blackboard = BLACKBOARDS[unit]

	if breed.handle_stagger_anim_cb then
		breed.handle_stagger_anim_cb(unit, blackboard, "anim_cb_stagger_light_finished")
	end
end

AnimationCallbackTemplates.server.anim_cb_stagger_medium_finished = function (unit, param)
	-- function 7
	if not ALIVE[unit] then
		return
	end

	local breed = Unit.get_data(unit, "breed")
	local blackboard = BLACKBOARDS[unit]

	if breed.handle_stagger_anim_cb then
		breed.handle_stagger_anim_cb(unit, blackboard, "anim_cb_stagger_medium_finished")
	end
end

AnimationCallbackTemplates.server.anim_cb_stagger_heavy_finished = function (unit, param)
	-- function 8
	if not ALIVE[unit] then
		return
	end

	local breed = Unit.get_data(unit, "breed")
	local blackboard = BLACKBOARDS[unit]

	if breed.handle_stagger_anim_cb then
		breed.handle_stagger_anim_cb(unit, blackboard, "anim_cb_stagger_heavy_finished")
	end
end

AnimationCallbackTemplates.server.anim_cb_tp_end_enter = function (unit, param)
	-- function 9
	local blackboard = BLACKBOARDS[unit]

	if blackboard.active_node and blackboard.active_node.anim_cb_tp_end_enter then
		blackboard.active_node:anim_cb_tp_end_enter(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_hesitate_finished = function (unit, param)
	-- function 10
	local blackboard = BLACKBOARDS[unit]

	if blackboard.active_node and blackboard.active_node.anim_cb_hesitate_finished then
		blackboard.active_node:anim_cb_hesitate_finished(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_emote_finished = function (unit, param)
	-- function 11
	local blackboard = BLACKBOARDS[unit]

	if blackboard.active_node and blackboard.active_node.anim_cb_emote_finished then
		blackboard.active_node:anim_cb_emote_finished(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_direct_damage = function (unit, param)
	-- function 12
	local blackboard = BLACKBOARDS[unit]

	if not Unit.alive(blackboard.target_unit) then
		return
	end

	local action = blackboard.action

	if not action then
		return
	end

	local active_behavior_node = blackboard.active_node

	if active_behavior_node and active_behavior_node.direct_damage then
		active_behavior_node.direct_damage(unit, blackboard)
	end

	blackboard.attacks_done = blackboard.attacks_done + 1
end

local DEFAULT_SPEED_MODIFIER_ON_TARGET_DODGE_DAMAGE_DONE = 0
local DEFAULT_ROTATION_STUN_TIME_ON_DODGE_DAMAGE_DONE = 0.6
local DEFAULT_SPEED_LERP_TIME_ON_TARGET_DODGE_DAMAGE_DONE = 0.3

AnimationCallbackTemplates.server.anim_cb_damage = function (unit, param)
	-- function 13
	local blackboard = BLACKBOARDS[unit]
	local target_unit_2

	if blackboard.smash_door then
		target_unit_2 = blackboard.smash_door.target_unit

		if not target_unit_2 then
			-- Nothing
		end
	end

	target_unit_2 = blackboard.attacking_target

	if not target_unit_2 then
		-- Nothing
	end

	target_unit_2 = blackboard.drag_target_unit

	local target_unit = target_unit_2

	::label_13_0::

	local action = blackboard.action

	if not action then
		return
	end

	local damage = action.damage

	if not damage then
		return
	end

	local combo = blackboard.combo_attack_data

	if combo and action.combo_attacks then
		local current_attack = action.combo_attacks[combo.current_attack_name]

		if current_attack.no_abort_attack then
			blackboard.attack_aborted = false
		end
	end

	if blackboard.active_node and blackboard.active_node.attack_cooldown then
		blackboard.active_node:attack_cooldown(unit, blackboard)
	end

	if blackboard.attack_aborted then
		return
	end

	if blackboard.buff_extension then
		blackboard.buff_extension:trigger_procs("minion_attack_used")
	end

	if blackboard.active_node and blackboard.active_node.anim_cb_damage then
		blackboard.active_node:anim_cb_damage(unit, blackboard)

		return
	end

	blackboard.anim_cb_damage = true

	if not Unit.alive(target_unit) or not Unit.alive(unit) then
		return
	end

	if blackboard.has_line_of_sight == false or not DamageUtils.check_distance(action, blackboard, unit, target_unit) or not DamageUtils.check_infront(unit, target_unit) then
		return
	end

	local attack_directions = action.attack_directions

	if attack_directions then
		-- Nothing
	end

	attack_directions = action.attack_directions[blackboard.attack_anim]

	local attack_direction = attack_directions

	::label_13_1::

	if not action.unblockable and DamageUtils.check_block(unit, target_unit, action.fatigue_type, attack_direction) then
		if blackboard.active_node and blackboard.active_node.attack_blocked then
			blackboard.active_node:attack_blocked(unit, blackboard, attack_direction)
		end

		local t = Managers.time:time("game")
		local target_blackboard = BLACKBOARDS[target_unit]

		if not target_blackboard.is_player then
			local attacker_blackboard = BLACKBOARDS[unit]
			local var_13_2 = POSITION_LOOKUP[unit]

			if not var_13_2 then
				-- Nothing
			end

			var_13_2 = Unit.world_position(unit, 0)

			local attacker_pos = var_13_2

			::label_13_2::

			local var_13_3 = POSITION_LOOKUP[target_unit]

			if not var_13_3 then
				-- Nothing
			end

			var_13_3 = Unit.local_position(target_unit, 0)

			local target_pos = var_13_3

			::label_13_3::

			local damage_direction = Vector3.normalize(target_pos - attacker_pos)
			local stagger_strength = AiUtils.calculate_ai_stagger_strength(attacker_blackboard, target_blackboard, t, true, stagger_types.medium, 0.25)

			if stagger_strength == stagger_types.none then
				stagger_strength = stagger_types.weak
			elseif stagger_strength == stagger_types.heavy then
				stagger_strength = stagger_types.medium
			end

			local impact, distance = AiUtils.calculate_ai_stagger_impact(stagger_strength)

			AiUtils.stagger_target(unit, target_unit, distance, impact, damage_direction, t, nil, nil, nil, true)
		end

		return
	end

	AiUtils.damage_target(target_unit, unit, action, action.damage)

	if blackboard.active_node and blackboard.active_node.attack_success then
		blackboard.active_node:attack_success(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_special_damage = function (unit, param)
	-- function 14
	local blackboard = BLACKBOARDS[unit]
	local action = blackboard.action

	if not action or not action.damage then
		return
	end

	if blackboard.attack_aborted then
		return
	end

	if blackboard.buff_extension then
		blackboard.buff_extension:trigger_procs("minion_attack_used")
	end

	if blackboard.active_node and blackboard.active_node.anim_cb_damage then
		blackboard.active_node:anim_cb_damage(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_reset_attack_animation_locked = function (unit, param)
	-- function 15
	local ai_extension = ScriptUnit.extension(unit, "ai_system")
	local blackboard = ai_extension:blackboard()

	blackboard.reset_attack_animation_locked = true
end

AnimationCallbackTemplates.server.anim_cb_unlink_unit = function (unit, param)
	-- function 16
	local ai_extension = ScriptUnit.extension(unit, "ai_system")
	local blackboard = ai_extension:blackboard()

	blackboard.unlink_unit = true
end

AnimationCallbackTemplates.server.anim_cb_mounted_knocked_off = function (unit, param)
	-- function 17
	local ai_extension = ScriptUnit.extension(unit, "ai_system")
	local blackboard = ai_extension:blackboard()

	blackboard.knocked_off_mount = true

	local locomotion_extension = blackboard.locomotion_extension

	LocomotionUtils.set_animation_driven_movement(unit, false, false, true)
	locomotion_extension:use_lerp_rotation(true)
	locomotion_extension:set_movement_type("snap_to_navmesh")
end

AnimationCallbackTemplates.server.anim_cb_mounting_finished = function (unit, param)
	-- function 18
	local ai_extension = ScriptUnit.extension(unit, "ai_system")
	local blackboard = ai_extension:blackboard()

	blackboard.mounting_finished = true
end

AnimationCallbackTemplates.server.anim_cb_frenzy_damage = function (unit, param)
	-- function 19
	local blackboard = BLACKBOARDS[unit]
	local action = blackboard.action

	if not action or not action.damage then
		return
	end

	if blackboard.attack_aborted then
		return
	end

	if blackboard.active_node and blackboard.active_node.attack_cooldown then
		blackboard.active_node:attack_cooldown(unit, blackboard)
	end

	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_frenzy_damage then
		active_node:anim_cb_frenzy_damage(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_vce = function (unit, param)
	-- function 20
	local blackboard = BLACKBOARDS[unit]
	local action = blackboard.action

	if blackboard.attack_aborted then
		return
	end

	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_attack_vce then
		active_node:anim_cb_attack_vce(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_vce_long = function (unit, param)
	-- function 21
	local blackboard = BLACKBOARDS[unit]
	local action = blackboard.action

	if blackboard.attack_aborted then
		return
	end

	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_attack_vce_long then
		active_node:anim_cb_attack_vce_long(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_shout_vo = function (unit, param)
	-- function 22
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_shout_vo then
		active_node:anim_cb_shout_vo(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_combo_damage = function (unit, param)
	-- function 23
	local blackboard = BLACKBOARDS[unit]
	local action = blackboard.action

	if not action or not action.damage then
		return
	end

	if blackboard.attack_aborted then
		return
	end

	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_combo_damage then
		active_node.anim_cb_combo_damage(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_rotation_start = function (unit, param)
	-- function 24
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_rotation_start = true
end

AnimationCallbackTemplates.server.anim_cb_rotation_stop = function (unit, param)
	-- function 25
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_rotation_stop = true
end

AnimationCallbackTemplates.server.anim_cb_picked_up_standard = function (unit, param)
	-- function 26
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_picked_up_standard = true
end

AnimationCallbackTemplates.server.anim_cb_running_attack_start = function (unit, param)
	-- function 27
	local blackboard = BLACKBOARDS[unit]

	if blackboard.active_node and blackboard.active_node.anim_cb_running_attack_start then
		blackboard.active_node:anim_cb_running_attack_start(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_running_attack_end = function (unit, param)
	-- function 28
	local blackboard = BLACKBOARDS[unit]

	if blackboard.active_node and blackboard.active_node.anim_cb_running_attack_end then
		blackboard.active_node:anim_cb_running_attack_end(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_death_finished = function (unit, param)
	-- function 29
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_death_finished = true
end

AnimationCallbackTemplates.server.anim_cb_move = function (unit, param)
	-- function 30
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	blackboard.anim_cb_move = true

	if not active_node or blackboard.attack_aborted then
		return
	end

	local anim_cb = active_node.anim_cb_move

	if anim_cb then
		anim_cb(anim_cb, unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_move_stop = function (unit, param)
	-- function 31
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_move_stop = true
end

AnimationCallbackTemplates.server.anim_cb_transform_finished = function (unit, param)
	-- function 32
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node
	local anim_cb = not not active_node and not not active_node.anim_cb_transform_finished

	if anim_cb then
		anim_cb(anim_cb, unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_throw_weapon = function (unit, param)
	-- function 33
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node
	local anim_cb = active_node.anim_cb_throw_weapon

	if anim_cb then
		anim_cb(anim_cb, unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_throw_finished = function (unit, param)
	-- function 34
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node
	local anim_cb = not not active_node and not not active_node.anim_cb_throw_finished

	if anim_cb then
		anim_cb(anim_cb, unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_charge_start_finished = function (unit, param)
	-- function 35
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_charge_start_finished then
		active_node:anim_cb_charge_start_finished(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_charge_charging_finished = function (unit, param)
	-- function 36
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_charge_charging_finished then
		active_node:anim_cb_charge_charging_finished(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_charge_impact_finished = function (unit, param)
	-- function 37
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_charge_impact_finished then
		active_node:anim_cb_charge_impact_finished(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_disable_charge_collision = function (unit, param)
	-- function 38
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_disable_charge_collision then
		active_node:anim_cb_disable_charge_collision(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_throw = function (unit, param)
	-- function 39
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_throw = true
end

AnimationCallbackTemplates.server.anim_cb_spawn_projectile = function (unit, param)
	-- function 40
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_spawn_projectile = true
end

AnimationCallbackTemplates.server.anim_cb_jump_start_finished = function (unit, param)
	-- function 41
	local blackboard = BLACKBOARDS[unit]

	blackboard.jump_start_finished = true
end

AnimationCallbackTemplates.server.anim_cb_jump_climb_finished = function (unit, param)
	-- function 42
	local blackboard = BLACKBOARDS[unit]

	blackboard.jump_climb_finished = true
end

AnimationCallbackTemplates.server.anim_cb_start_finished = function (unit, param)
	-- function 43
	local blackboard = BLACKBOARDS[unit]

	blackboard.start_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_start = function (unit, param)
	-- function 44
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if not active_node or blackboard.attack_aborted then
		return
	end

	local anim_cb = active_node.anim_cb_attack_start

	if anim_cb then
		anim_cb(anim_cb, unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_finished = function (unit, param)
	-- function 45
	local blackboard = BLACKBOARDS[unit]

	if blackboard.active_node and blackboard.active_node.anim_cb_attack_finished then
		local anim_cb = blackboard.active_node.anim_cb_attack_finished

		anim_cb(anim_cb, unit, blackboard)
	else
		blackboard.attacks_done = blackboard.attacks_done + 1
		blackboard.attack_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_escape_finished = function (unit, param)
	-- function 46
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_escape_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_cooldown = function (unit, param)
	-- function 47
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_attack_cooldown = true
end

AnimationCallbackTemplates.server.anim_cb_blocked_cooldown = function (unit, param)
	-- function 48
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_blocked_cooldown = true
end

AnimationCallbackTemplates.server.anim_cb_summoning_finished = function (unit, param)
	-- function 49
	local blackboard = BLACKBOARDS[unit]

	blackboard.summoning_finished = true
end

AnimationCallbackTemplates.server.anim_cb_shout_finished = function (unit, param)
	-- function 50
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_shout_finished = true
end

AnimationCallbackTemplates.server.anim_cb_order_finished = function (unit, param)
	-- function 51
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_order_finished = true
end

AnimationCallbackTemplates.server.anim_cb_scurry_under_finished = function (unit, param)
	-- function 52
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_scurry_under_finished = true
end

AnimationCallbackTemplates.server.anim_cb_dig_finished = function (unit, param)
	-- function 53
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_dig_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_throw_score_finished = function (unit, param)
	-- function 54
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.anim_cb_attack_throw_score_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_jump_start_finished = function (unit, param)
	-- function 55
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.anim_cb_attack_jump_start_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_shoot_start_finished = function (unit, param)
	-- function 56
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.anim_cb_attack_shoot_start_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_reload_start_finished = function (unit, param)
	-- function 57
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.anim_cb_reload_start_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_windup_start_finished = function (unit, param)
	-- function 58
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.anim_cb_attack_windup_start_finished = true
	end
end

AnimationCallbackTemplates.server.anim_cb_attack_shoot_random_shot = function (unit, param)
	-- function 59
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.anim_cb_attack_shoot_random_shot = true
	end
end

AnimationCallbackTemplates.server.anim_cb_stormvermin_voice = function (unit, param)
	-- function 60
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.anim_cb_stormvermin_voice = true
	end
end

AnimationCallbackTemplates.server.anim_cb_patrol_sound = function (unit, param)
	-- function 61
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.anim_cb_patrol_sound = true
	end
end

AnimationCallbackTemplates.server.anim_cb_exit_shooting_hit_react = function (unit, param)
	-- function 62
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.in_hit_reaction = nil
	end
end

AnimationCallbackTemplates.server.anim_cb_enter_shooting_hit_react = function (unit, param)
	-- function 63
	local ai_base_extension = ScriptUnit.has_extension(unit, "ai_system")

	if ai_base_extension then
		local blackboard = ai_base_extension:blackboard()

		blackboard.in_hit_reaction = true
	end
end

AnimationCallbackTemplates.server.anim_cb_place_standard = function (unit, param)
	-- function 64
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node then
		local anim_cb = active_node.anim_cb_place_standard

		if anim_cb then
			anim_cb(active_node, unit, blackboard)
		end
	end
end

AnimationCallbackTemplates.server.anim_cb_pick_up_standard = function (unit, param)
	-- function 65
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node then
		local anim_cb = active_node.anim_cb_pick_up_standard

		if anim_cb then
			anim_cb(active_node, unit, blackboard)
		end
	end
end

AnimationCallbackTemplates.server.anim_cb_placed_standard = function (unit, param)
	-- function 66
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node
	local anim_cb = not not active_node and not not active_node.anim_cb_placed_standard

	if anim_cb then
		anim_cb(active_node, unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_stormvermin_push = function (unit, param)
	-- function 67
	local blackboard = BLACKBOARDS[unit]
	local target_unit = blackboard.attacking_target
	local active_node = blackboard.active_node

	if not active_node or blackboard.attack_aborted or not HEALTH_ALIVE[target_unit] then
		return
	end

	local anim_cb = active_node.anim_cb_stormvermin_push

	if anim_cb then
		anim_cb(active_node, unit, blackboard, target_unit)
	end
end

AnimationCallbackTemplates.server.anim_cb_stormvermin_push_finished = function (unit, param)
	-- function 68
	local blackboard = BLACKBOARDS[unit]

	blackboard.attack_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_overlap_done = function (unit, param)
	-- function 69
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if not active_node or blackboard.attack_aborted then
		return
	end

	local anim_cb = active_node.anim_cb_attack_overlap_done

	if anim_cb then
		anim_cb(active_node, unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_vomit = function (unit, param)
	-- function 70
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if not active_node or blackboard.attack_aborted then
		return
	end

	local anim_cb = active_node.anim_cb_vomit

	if anim_cb then
		anim_cb(anim_cb, unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_vomit_end = function (unit, param)
	-- function 71
	local blackboard = BLACKBOARDS[unit]

	blackboard.is_puking = nil
end

AnimationCallbackTemplates.server.anim_cb_dodge_finished = function (unit, param)
	-- function 72
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_dodge_finished = true
end

AnimationCallbackTemplates.server.anim_cb_downed_end_finished = function (unit, param)
	-- function 73
	local blackboard = BLACKBOARDS[unit]

	blackboard.downed_end_finished = true
end

AnimationCallbackTemplates.server.anim_cb_rage_finished = function (unit, param)
	-- function 74
	local blackboard = BLACKBOARDS[unit]

	blackboard.rage_end_finished = true
end

AnimationCallbackTemplates.server.anim_cb_roar_begin = function (unit, param)
	-- function 75
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_roar_begin = true
end

AnimationCallbackTemplates.server.anim_cb_roar_end = function (unit, param)
	-- function 76
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_roar_end = true
end

AnimationCallbackTemplates.server.anim_cb_landing_finished = function (unit, param)
	-- function 77
	local blackboard = BLACKBOARDS[unit]

	blackboard.landing_finished = true
end

AnimationCallbackTemplates.server.anim_cb_teleport_finished = function (unit, param)
	-- function 78
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_teleport_finished = true
end

AnimationCallbackTemplates.server.anim_cb_teleport_start_finished = function (unit, param)
	-- function 79
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_teleport_start_finished then
		active_node:anim_cb_teleport_start_finished(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_teleport_end_finished = function (unit, param)
	-- function 80
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_teleport_end_finished then
		active_node:anim_cb_teleport_end_finished(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_move_jump_finished = function (unit, param)
	-- function 81
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_move_jump_finished then
		active_node:anim_cb_move_jump_finished(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_stagger_immune = function (unit, param)
	-- function 82
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_stagger_immune = true
end

AnimationCallbackTemplates.server.anim_cb_push_cancel = function (unit, param)
	-- function 83
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node

	if active_node and active_node.anim_cb_push_cancel then
		active_node:anim_cb_push_cancel(unit, blackboard)
	end
end

AnimationCallbackTemplates.server.anim_cb_disable_invincibility = function (unit, param)
	-- function 84
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if health_extension then
		health_extension.is_invincible = false
	end
end

AnimationCallbackTemplates.server.anim_cb_combat_step_stop = function (unit, param)
	-- function 85
	local blackboard = BLACKBOARDS[unit]

	if blackboard.active_node and blackboard.active_node.anim_cb_combat_step_stop then
		blackboard.active_node:anim_cb_combat_step_stop(unit, blackboard)
	end
end

AnimationCallbackTemplates.client.anim_cb_hide_unit = function (unit, param)
	-- function 86
	Unit.set_unit_visibility(unit, false)

	local inventory_extension = ScriptUnit.has_extension(unit, "inventory_system")

	if inventory_extension then
		inventory_extension:show_third_person_inventory(false)
	end

	local attachment_extension = ScriptUnit.has_extension(unit, "attachment_system")

	if attachment_extension then
		attachment_extension:show_attachments(false)
	end
end

AnimationCallbackTemplates.client.anim_cb_hide_weapons = function (unit, param)
	-- function 87
	local player_manager = Managers.player
	local player = player_manager:unit_owner(unit)

	if not player then
		return
	end

	local is_local_player = player.local_player
	local allowed_to_set = true

	if is_local_player then
		local first_person_extension = ScriptUnit.extension(unit, "first_person_system")

		allowed_to_set = not first_person_extension.first_person_mode
	end

	local inventory_extension = ScriptUnit.has_extension(unit, "inventory_system")

	if allowed_to_set and inventory_extension and inventory_extension:is_showing_third_person_inventory() then
		inventory_extension:show_third_person_inventory(false)
	end
end

AnimationCallbackTemplates.client.anim_cb_unhide_weapons = function (unit, param)
	-- function 88
	local player_manager = Managers.player
	local player = player_manager:unit_owner(unit)

	if not player then
		return
	end

	local is_local_player = player.local_player
	local allowed_to_set = true

	if is_local_player then
		local first_person_extension = ScriptUnit.extension(unit, "first_person_system")

		allowed_to_set = not first_person_extension.first_person_mode
	end

	local inventory_extension = ScriptUnit.has_extension(unit, "inventory_system")

	if allowed_to_set and inventory_extension and not inventory_extension:is_showing_third_person_inventory() then
		inventory_extension:show_third_person_inventory(true)
	end
end

AnimationCallbackTemplates.client.anim_cb_climb_rotation_start = function (unit, param)
	-- function 89
	local status_extension = ScriptUnit.extension(unit, "status_system")

	status_extension.start_climb_rotation = true
end

AnimationCallbackTemplates.server.anim_cb_chew_attack = function (unit, param)
	-- function 90
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node
	local victim_unit = blackboard.victim_grabbed

	if not victim_unit or not Unit.alive(victim_unit) then
		return
	end

	if active_node then
		local anim_cb = active_node.anim_cb_chew_attack

		if anim_cb then
			anim_cb(active_node, unit, blackboard)
		end
	end
end

AnimationCallbackTemplates.server.anim_cb_chew_attack_finished = function (unit, param)
	-- function 91
	local blackboard = BLACKBOARDS[unit]

	blackboard.anim_cb_chew_attack_finished = true
end

AnimationCallbackTemplates.server.anim_cb_attack_grabbed_smash = function (unit, param)
	-- function 92
	local blackboard = BLACKBOARDS[unit]
	local active_node = blackboard.active_node
	local victim_unit = blackboard.victim_grabbed

	if not victim_unit or not Unit.alive(victim_unit) then
		return
	end

	if active_node then
		local anim_cb = active_node.anim_cb_attack_grabbed_smash

		if anim_cb then
			anim_cb(active_node, unit, blackboard)
		end
	end
end

AnimationCallbackTemplates.client.anim_cb_enable_skeleton_collison = function (unit, param)
	-- function 93
	local breed = Unit.get_data(unit, "breed")
	local ai_extension = ScriptUnit.extension(unit, "ai_system")
	local player_locomotion_constrain_radius = breed.player_locomotion_constrain_radius

	player_locomotion_constrain_radius = not not player_locomotion_constrain_radius or not not nil
	ai_extension.player_locomotion_constrain_radius = player_locomotion_constrain_radius
end

AnimationCallbackTemplates.server.anim_cb_shielded = function (unit, param)
	-- function 94
	if ScriptUnit.has_extension(unit, "ai_shield_system") then
		local shield_extension = ScriptUnit.extension(unit, "ai_shield_system")

		shield_extension:set_is_blocking(true)
	end

	local blackboard = BLACKBOARDS[unit]

	blackboard.shield_is_up = true
end

AnimationCallbackTemplates.server.anim_cb_unshielded = function (unit, param)
	-- function 95
	if ScriptUnit.has_extension(unit, "ai_shield_system") then
		local shield_extension = ScriptUnit.extension(unit, "ai_shield_system")

		shield_extension:set_is_blocking(false)
	end

	local blackboard = BLACKBOARDS[unit]

	blackboard.shield_is_up = false
end

DLCUtils.require_list("animation_callback_template_files")
