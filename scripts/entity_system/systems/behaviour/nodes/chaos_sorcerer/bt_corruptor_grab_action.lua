-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_corruptor_grab_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCorruptorGrabAction = class(BTCorruptorGrabAction, BTNode)

BTCorruptorGrabAction.init = function (arg_1_0, ...)
	BTCorruptorGrabAction.super.init(arg_1_0, ...)
end

BTCorruptorGrabAction.name = "BTCorruptorGrabAction"

BTCorruptorGrabAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.active_node = BTCorruptorGrabAction
	arg_2_2.attacks_done = 0
	arg_2_2.attack_aborted = nil
	arg_2_2.attack_success = nil
	arg_2_2.drain_life_at = arg_2_3
	arg_2_2.has_dealed_damage = false
	arg_2_2.projectile_position = Vector3Box()
	arg_2_2.corruptor_target = arg_2_2.target_unit
	arg_2_2.target_unit_status_extension = ScriptUnit.has_extension(arg_2_2.corruptor_target, "status_system") or nil

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

BTCorruptorGrabAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_2.action.ignore_bot_threat then
		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_3_1, arg_3_2.corruptor_target, "corruptor_grabbed", 2)
	end

	arg_3_2.move_state = nil

	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.target_unit_status_extension = nil
	arg_3_2.active_node = nil
	arg_3_2.attack_aborted = nil
	arg_3_2.attack_finished = nil
	arg_3_2.attack_success = nil
	arg_3_2.attack_cooldown = arg_3_3 + arg_3_2.action.cooldown
	arg_3_2.action = nil
	arg_3_2.ready_to_summon = nil
	arg_3_2.disable_player_timer = nil
	arg_3_2.play_grabbed_loop = nil
	arg_3_2.drain_life_at = nil
	arg_3_2.has_grabbed_unit = nil
	arg_3_2.projectile_position = nil
	arg_3_2.target_dodged = nil
	arg_3_2.projectile_target_position = nil

	if not arg_3_5 then
		arg_3_2.locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
	end

	if arg_3_4 == "aborted" and arg_3_2.stagger and arg_3_2.play_grabbed_loop then
		arg_3_2.corruptor_grab_stagger = true
	end

	if Unit.alive(arg_3_2.grabbed_unit) then
		StatusUtils.set_grabbed_by_corruptor_network("chaos_corruptor_released", arg_3_2.grabbed_unit, false, arg_3_1)
		arg_3_0:set_beam_state(arg_3_1, arg_3_2, "stop_beam")
	else
		arg_3_0:set_beam_state(arg_3_1, arg_3_2, "stop_beam")
	end

	arg_3_2.corruptor_target = nil
	arg_3_2.grabbed_unit = nil
	arg_3_2.vanish_countdown = arg_3_3
end

BTCorruptorGrabAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.action
	local var_4_1 = arg_4_2.corruptor_target

	if not AiUtils.is_of_interest_to_corruptor(arg_4_1, var_4_1) then
		return "failed"
	end

	if arg_4_2.attack_aborted then
		Managers.state.network:anim_event(arg_4_1, "idle")

		return "failed"
	end

	if arg_4_2.attack_success then
		StatusUtils.set_grabbed_by_corruptor_network("chaos_corruptor_grabbed", var_4_1, true, arg_4_1)

		arg_4_2.attack_success = nil
		arg_4_2.play_grabbed_loop = true
		arg_4_2.disable_player_timer = arg_4_3 + var_4_0.disable_player_time

		arg_4_0:set_beam_state(arg_4_1, arg_4_2, "start_beam")

		if not var_4_0.ignore_bot_threat then
			Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_4_1, var_4_1, "corruptor_grabbed")
		end

		Managers.state.network:anim_event(arg_4_1, var_4_0.drag_in_anim)
	end

	local var_4_2 = arg_4_0:attack(arg_4_1, arg_4_3, arg_4_4, arg_4_2)

	if not arg_4_2.grabbed_unit then
		local var_4_3 = arg_4_2.target_unit_status_extension

		if var_4_3 and var_4_3:get_is_dodging() then
			arg_4_2.target_dodged = true
		end

		arg_4_0:overlap_players(arg_4_1, arg_4_3, arg_4_4, arg_4_2)
	end

	if arg_4_2.attack_finished and arg_4_2.play_grabbed_loop then
		arg_4_2.attack_finished = nil

		StatusUtils.set_grabbed_by_corruptor_network("chaos_corruptor_dragging", var_4_1, true, arg_4_1)
	end

	if arg_4_2.grabbed_unit and var_4_1 and arg_4_3 > arg_4_2.drain_life_at and Vector3.distance(POSITION_LOOKUP[var_4_1], POSITION_LOOKUP[arg_4_1]) < 2.5 then
		arg_4_0:drain_life(arg_4_1, arg_4_2)

		arg_4_2.drain_life_at = arg_4_3 + var_4_0.drain_life_tick_rate
	end

	if not var_4_2 or arg_4_2.attack_finished and not arg_4_2.play_grabbed_loop or arg_4_2.disable_player_timer and arg_4_3 > arg_4_2.disable_player_timer then
		return "done"
	end

	return "running"
end

BTCorruptorGrabAction.attack = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_4.action
	local var_5_1 = arg_5_4.locomotion_extension
	local var_5_2 = arg_5_4.corruptor_target
	local var_5_3 = POSITION_LOOKUP[arg_5_1] + Vector3.up()
	local var_5_4 = POSITION_LOOKUP[var_5_2] + Vector3.up()
	local var_5_5 = arg_5_4.world
	local var_5_6 = World.physics_world(var_5_5)

	if PerceptionUtils.is_position_in_line_of_sight(arg_5_1, var_5_3, var_5_4, var_5_6) then
		if arg_5_4.move_state ~= "attacking" then
			arg_5_4.move_state = "attacking"

			var_5_1:use_lerp_rotation(true)
			LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, true)
			Managers.state.network:anim_event(arg_5_1, var_5_0.attack_anim)
		end

		local var_5_7 = LocomotionUtils.rotation_towards_unit(arg_5_1, arg_5_4.corruptor_target)

		var_5_1:set_wanted_rotation(var_5_7)

		return true
	end

	return false
end

BTCorruptorGrabAction.drain_life = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.corruptor_target
	local var_6_1 = arg_6_2.action

	AiUtils.damage_target(var_6_0, arg_6_1, var_6_1, var_6_1.damage)

	if var_6_1.health_leech then
		local var_6_2 = "leech"
		local var_6_3 = Managers.state.difficulty:get_difficulty()
		local var_6_4 = var_6_1.health_leech[var_6_3]
		local var_6_5 = DamageUtils.networkify_damage(var_6_4)

		ScriptUnit.extension(arg_6_1, "health_system"):add_heal(arg_6_1, var_6_5, nil, var_6_2)
	end

	arg_6_2.has_dealed_damage = true
end

BTCorruptorGrabAction.anim_cb_damage = function (arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2.active_node and arg_7_2.active_node == BTCorruptorGrabAction then
		arg_7_0:set_beam_state(arg_7_1, arg_7_2, "projectile")
	end
end

BTCorruptorGrabAction.overlap_players = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if not arg_8_4.projectile_target_position then
		return
	end

	local var_8_0 = arg_8_4.corruptor_target
	local var_8_1 = arg_8_4.projectile_position:unbox()
	local var_8_2 = arg_8_4.projectile_target_position:unbox()
	local var_8_3 = arg_8_4.action
	local var_8_4 = 2
	local var_8_5 = var_8_2
	local var_8_6 = var_8_2 - var_8_1

	if var_8_4 > Vector3.length(Vector3.flat(var_8_6)) then
		arg_8_0:grab_player(arg_8_2, arg_8_1, arg_8_4)
	end
end

BTCorruptorGrabAction.grab_player = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_3.corruptor_target
	local var_9_1 = POSITION_LOOKUP[arg_9_2]
	local var_9_2 = POSITION_LOOKUP[var_9_0]
	local var_9_3 = arg_9_3.action

	if var_9_3.grab_delay then
		if not arg_9_3.grab_at then
			arg_9_3.grab_at = arg_9_1 + var_9_3.grab_delay
		end

		if arg_9_3.grab_at and arg_9_1 >= arg_9_3.grab_at then
			arg_9_3.grab_at = nil
		else
			return
		end
	end

	local var_9_4 = arg_9_3.projectile_position:unbox()
	local var_9_5 = arg_9_3.projectile_target_position:unbox()
	local var_9_6 = arg_9_3.target_unit_status_extension
	local var_9_7 = arg_9_3.world
	local var_9_8 = World.physics_world(var_9_7)
	local var_9_9 = Vector3.distance_squared(var_9_5, var_9_2)

	if not var_9_3.ignore_dodge and arg_9_3.target_dodged or var_9_6:is_invisible() then
		local var_9_10 = var_9_2
		local var_9_11 = Vector3.normalize(Vector3.flat(var_9_10 - var_9_1))
		local var_9_12 = Quaternion.forward(Unit.local_rotation(arg_9_2, 0))
		local var_9_13 = Vector3.dot(var_9_11, var_9_12)
		local var_9_14 = math.acos(var_9_13)

		if Vector3.distance_squared(var_9_1, var_9_10) < arg_9_3.action.min_dodge_angle_squared and math.radians_to_degrees(var_9_14) <= arg_9_3.action.dodge_angle or var_9_9 < arg_9_3.action.dodge_distance * arg_9_3.action.dodge_distance then
			arg_9_3.attack_success = PerceptionUtils.is_position_in_line_of_sight(arg_9_2, var_9_1, var_9_2, var_9_8)
		else
			QuestSettings.check_corruptor_dodge(var_9_0)

			arg_9_3.attack_success = false
		end
	elseif not not var_9_3.ignore_dodge and Vector3.distance_squared(var_9_1, var_9_2) > arg_9_3.action.max_distance_squared or var_9_9 > 25 then
		arg_9_3.attack_success = false
	else
		arg_9_3.attack_success = PerceptionUtils.is_position_in_line_of_sight(arg_9_2, var_9_1 + Vector3.up(), var_9_2 + Vector3.up(), var_9_8)
	end

	if arg_9_3.attack_success then
		local var_9_15 = ScriptUnit.has_extension(arg_9_3.corruptor_target, "first_person_system")

		if arg_9_3.attack_success and var_9_15 then
			var_9_15:animation_event("shake_get_hit")
		end

		arg_9_3.grabbed_unit = arg_9_3.corruptor_target

		local var_9_16 = arg_9_3.action.grabbed_sound_event_2d
	else
		arg_9_3.attack_aborted = true
	end
end

BTCorruptorGrabAction.set_beam_state = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = Managers.state.network
	local var_10_1 = var_10_0:unit_game_object_id(arg_10_1)
	local var_10_2 = var_10_0:unit_game_object_id(arg_10_2.corruptor_target or arg_10_2.grabbed_unit)

	if var_10_1 then
		Managers.state.network.network_transmit:send_rpc_all("rpc_set_corruptor_beam_state", var_10_1, arg_10_3, var_10_2 or var_10_1)
	end
end
