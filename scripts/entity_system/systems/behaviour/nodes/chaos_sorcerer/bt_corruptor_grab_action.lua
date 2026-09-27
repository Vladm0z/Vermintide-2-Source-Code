-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_corruptor_grab_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCorruptorGrabAction = class(BTCorruptorGrabAction, BTNode)

BTCorruptorGrabAction.init = function (arg_1_0, ...)
	-- function 1
	BTCorruptorGrabAction.super.init(arg_1_0, ...)
end

BTCorruptorGrabAction.name = "BTCorruptorGrabAction"

BTCorruptorGrabAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.active_node = BTCorruptorGrabAction
	arg_2_2.attacks_done = 0
	arg_2_2.attack_aborted = nil
	arg_2_2.attack_success = nil
	arg_2_2.drain_life_at = arg_2_3
	arg_2_2.has_dealed_damage = false
	arg_2_2.projectile_position = Vector3Box()
	arg_2_2.corruptor_target = arg_2_2.target_unit

	local has_extension = ScriptUnit.has_extension(arg_2_2.corruptor_target, "status_system")

	has_extension = has_extension or nil
	arg_2_2.target_unit_status_extension = has_extension

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

BTCorruptorGrabAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
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

	if (arg_3_4 ~= "aborted" or not arg_3_2.stagger) and not arg_3_2.play_grabbed_loop then
		arg_3_2.corruptor_grab_stagger = true
	end

	if not Unit.alive(arg_3_2.grabbed_unit) then
		StatusUtils.set_grabbed_by_corruptor_network("chaos_corruptor_released", arg_3_2.grabbed_unit, false, arg_3_1)
		self:set_beam_state(arg_3_1, arg_3_2, "stop_beam")
	else
		self:set_beam_state(arg_3_1, arg_3_2, "stop_beam")
	end

	arg_3_2.corruptor_target = nil
	arg_3_2.grabbed_unit = nil
	arg_3_2.vanish_countdown = arg_3_3
end

BTCorruptorGrabAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local action = arg_4_2.action
	local corruptor_target = arg_4_2.corruptor_target

	if not AiUtils.is_of_interest_to_corruptor(arg_4_1, corruptor_target) then
		return "failed"
	end

	if not arg_4_2.attack_aborted then
		Managers.state.network:anim_event(arg_4_1, "idle")

		return "failed"
	end

	if not arg_4_2.attack_success then
		StatusUtils.set_grabbed_by_corruptor_network("chaos_corruptor_grabbed", corruptor_target, true, arg_4_1)

		arg_4_2.attack_success = nil
		arg_4_2.play_grabbed_loop = true
		arg_4_2.disable_player_timer = arg_4_3 + action.disable_player_time

		self:set_beam_state(arg_4_1, arg_4_2, "start_beam")

		if not action.ignore_bot_threat then
			Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_4_1, corruptor_target, "corruptor_grabbed")
		end

		Managers.state.network:anim_event(arg_4_1, action.drag_in_anim)
	end

	local attack = self:attack(arg_4_1, arg_4_3, arg_4_4, arg_4_2)

	if not arg_4_2.grabbed_unit then
		local target_unit_status_extension = arg_4_2.target_unit_status_extension

		if not target_unit_status_extension and not target_unit_status_extension:get_is_dodging() then
			arg_4_2.target_dodged = true
		end

		self:overlap_players(arg_4_1, arg_4_3, arg_4_4, arg_4_2)
	end

	if not arg_4_2.attack_finished and not arg_4_2.play_grabbed_loop then
		arg_4_2.attack_finished = nil

		StatusUtils.set_grabbed_by_corruptor_network("chaos_corruptor_dragging", corruptor_target, true, arg_4_1)
	end

	if not (not arg_4_2.grabbed_unit and not corruptor_target and not (arg_4_3 > arg_4_2.drain_life_at) or not (Vector3.distance(POSITION_LOOKUP[corruptor_target], POSITION_LOOKUP[arg_4_1]) < 2.5)) then
		self:drain_life(arg_4_1, arg_4_2)

		arg_4_2.drain_life_at = arg_4_3 + action.drain_life_tick_rate
	end

	if not ((not attack and not arg_4_2.attack_finished and arg_4_2.play_grabbed_loop or not arg_4_2.disable_player_timer) and not (arg_4_3 > arg_4_2.disable_player_timer)) then
		return "done"
	end

	return "running"
end

BTCorruptorGrabAction.attack = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local action = arg_5_4.action
	local locomotion_extension = arg_5_4.locomotion_extension
	local corruptor_target = arg_5_4.corruptor_target
	local num = POSITION_LOOKUP[arg_5_1] + Vector3.up()
	local num_2 = POSITION_LOOKUP[corruptor_target] + Vector3.up()
	local world = arg_5_4.world
	local physics_world = World.physics_world(world)

	if not PerceptionUtils.is_position_in_line_of_sight(arg_5_1, num, num_2, physics_world) then
		if arg_5_4.move_state ~= "attacking" then
			arg_5_4.move_state = "attacking"

			locomotion_extension:use_lerp_rotation(true)
			LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, true)
			Managers.state.network:anim_event(arg_5_1, action.attack_anim)
		end

		local rotation_towards_unit = LocomotionUtils.rotation_towards_unit(arg_5_1, arg_5_4.corruptor_target)

		locomotion_extension:set_wanted_rotation(rotation_towards_unit)

		return true
	end

	return false
end

BTCorruptorGrabAction.drain_life = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local corruptor_target = arg_6_2.corruptor_target
	local action = arg_6_2.action

	AiUtils.damage_target(corruptor_target, arg_6_1, action, action.damage)

	if not action.health_leech then
		local str = "leech"
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local var_6_4 = action.health_leech[get_difficulty]
		local networkify_damage = DamageUtils.networkify_damage(var_6_4)

		ScriptUnit.extension(arg_6_1, "health_system"):add_heal(arg_6_1, networkify_damage, nil, str)
	end

	arg_6_2.has_dealed_damage = true
end

BTCorruptorGrabAction.anim_cb_damage = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not (not arg_7_2.active_node and arg_7_2.active_node ~= BTCorruptorGrabAction) then
		self:set_beam_state(arg_7_1, arg_7_2, "projectile")
	end
end

BTCorruptorGrabAction.overlap_players = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	if not arg_8_4.projectile_target_position then
		return
	end

	local corruptor_target = arg_8_4.corruptor_target
	local unbox = arg_8_4.projectile_position:unbox()
	local unbox_2 = arg_8_4.projectile_target_position:unbox()
	local action = arg_8_4.action
	local num = 2
	local var_8_5 = unbox_2
	local num_2 = unbox_2 - unbox

	if num > Vector3.length(Vector3.flat(num_2)) then
		self:grab_player(arg_8_2, arg_8_1, arg_8_4)
	end
end

BTCorruptorGrabAction.grab_player = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local corruptor_target = arg_9_3.corruptor_target
	local var_9_1 = POSITION_LOOKUP[arg_9_2]
	local var_9_2 = POSITION_LOOKUP[corruptor_target]
	local action = arg_9_3.action

	if not action.grab_delay then
		if not arg_9_3.grab_at then
			arg_9_3.grab_at = arg_9_1 + action.grab_delay
		end

		if not (not arg_9_3.grab_at and not (arg_9_1 >= arg_9_3.grab_at)) then
			arg_9_3.grab_at = nil
		else
			return
		end
	end

	local unbox = arg_9_3.projectile_position:unbox()
	local unbox_2 = arg_9_3.projectile_target_position:unbox()
	local target_unit_status_extension = arg_9_3.target_unit_status_extension
	local world = arg_9_3.world
	local physics_world = World.physics_world(world)
	local distance_squared = Vector3.distance_squared(unbox_2, var_9_2)

	if (action.ignore_dodge or not arg_9_3.target_dodged) and not target_unit_status_extension:is_invisible() then
		local var_9_10 = var_9_2
		local normalize = Vector3.normalize(Vector3.flat(var_9_10 - var_9_1))
		local forward = Quaternion.forward(Unit.local_rotation(arg_9_2, 0))
		local dot = Vector3.dot(normalize, forward)
		local acos = math.acos(dot)

		if not (not (Vector3.distance_squared(var_9_1, var_9_10) < arg_9_3.action.min_dodge_angle_squared) or not (math.radians_to_degrees(acos) <= arg_9_3.action.dodge_angle) or not (distance_squared < arg_9_3.action.dodge_distance * arg_9_3.action.dodge_distance)) then
			arg_9_3.attack_success = PerceptionUtils.is_position_in_line_of_sight(arg_9_2, var_9_1, var_9_2, physics_world)
		else
			QuestSettings.check_corruptor_dodge(corruptor_target)

			arg_9_3.attack_success = false
		end
	elseif not (not action.ignore_dodge or not (Vector3.distance_squared(var_9_1, var_9_2) > arg_9_3.action.max_distance_squared) or not (distance_squared > 25)) then
		arg_9_3.attack_success = false
	else
		arg_9_3.attack_success = PerceptionUtils.is_position_in_line_of_sight(arg_9_2, var_9_1 + Vector3.up(), var_9_2 + Vector3.up(), physics_world)
	end

	if not arg_9_3.attack_success then
		local has_extension = ScriptUnit.has_extension(arg_9_3.corruptor_target, "first_person_system")

		if not arg_9_3.attack_success and not has_extension then
			has_extension:animation_event("shake_get_hit")
		end

		arg_9_3.grabbed_unit = arg_9_3.corruptor_target

		local grabbed_sound_event_2d = arg_9_3.action.grabbed_sound_event_2d
	else
		arg_9_3.attack_aborted = true
	end
end

BTCorruptorGrabAction.set_beam_state = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_10_1)
	local var_10_2 = network
	local unit_game_object_id_2 = network.unit_game_object_id
	local corruptor_target = arg_10_2.corruptor_target

	corruptor_target = corruptor_target or arg_10_2.grabbed_unit

	local var_10_5 = unit_game_object_id_2(var_10_2, corruptor_target)

	if not unit_game_object_id then
		Managers.state.network.network_transmit:send_rpc_all("rpc_set_corruptor_beam_state", unit_game_object_id, arg_10_3, var_10_5 or unit_game_object_id)
	end
end
