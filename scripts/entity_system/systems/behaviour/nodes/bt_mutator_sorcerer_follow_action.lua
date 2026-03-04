-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_mutator_sorcerer_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMutatorSorcererFollowAction = class(BTMutatorSorcererFollowAction, BTNode)

BTMutatorSorcererFollowAction.init = function (arg_1_0, ...)
	BTMutatorSorcererFollowAction.super.init(arg_1_0, ...)
end

BTMutatorSorcererFollowAction.name = "BTMutatorSorcererFollowAction"

BTMutatorSorcererFollowAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	local var_2_1 = var_2_0.start_anims_name
	local var_2_2 = POSITION_LOOKUP[arg_2_2.target_unit]
	local var_2_3 = AiAnimUtils.get_start_move_animation(arg_2_1, var_2_2, var_2_1)
	local var_2_4 = AiUtils.get_default_breed_move_speed(arg_2_1, arg_2_2)
	local var_2_5 = arg_2_2.navigation_extension

	var_2_5:set_max_speed(var_2_4)
	var_2_5:set_enabled(true)

	local var_2_6 = Managers.state.network

	arg_2_2.move_state = "moving"

	var_2_6:anim_event(arg_2_1, "float_into")
	var_2_6:anim_event(arg_2_1, var_2_3)

	arg_2_2.physics_world = arg_2_2.physics_world or World.get_data(arg_2_2.world, "physics_world")

	local var_2_7 = Managers.state.entity:system("audio_system")
	local var_2_8 = var_2_0.skulking_sound_event

	var_2_7:play_audio_unit_event(var_2_8, arg_2_1)
end

BTMutatorSorcererFollowAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = Managers.state.entity:system("audio_system")
	local var_3_1 = arg_3_2.action.stop_skulking_sound_event

	var_3_0:play_audio_unit_event(var_3_1, arg_3_1)

	if arg_3_2.played_fast_movespeed_sound then
		local var_3_2 = arg_3_2.action.stop_fast_move_speed_sound_event

		var_3_0:play_audio_unit_event(var_3_2, arg_3_1)

		arg_3_2.played_fast_movespeed_sound = nil
	end

	local var_3_3 = arg_3_2.current_hunting_target

	if Unit.alive(var_3_3) then
		local var_3_4 = arg_3_2.action.stop_hunting_sound_event
		local var_3_5 = Managers.player:unit_owner(var_3_3):network_id()
		local var_3_6 = Managers.state.network
		local var_3_7 = var_3_6.unit_storage:go_id(arg_3_1)

		var_3_6.network_transmit:send_rpc("rpc_server_audio_unit_event", var_3_5, NetworkLookup.sound_events[var_3_4], var_3_7, false, 0)
	end

	arg_3_2.action = nil
	arg_3_2.start_anim_locked = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.start_finished = nil
end

BTMutatorSorcererFollowAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.target_unit
	local var_4_1 = arg_4_2.action
	local var_4_2 = arg_4_2.navigation_extension

	if not AiUtils.is_of_interest_to_corruptor(arg_4_1, var_4_0) then
		return "failed"
	end

	local var_4_3 = POSITION_LOOKUP[arg_4_1]
	local var_4_4 = POSITION_LOOKUP[var_4_0]

	arg_4_0:handle_movement_speed_bonus(arg_4_1, arg_4_2, var_4_1, var_4_3, var_4_4, var_4_0)

	local var_4_5 = Vector3.distance_squared(var_4_3, var_4_4)
	local var_4_6 = var_4_1.distance_to_attack

	if var_4_5 < var_4_6 * var_4_6 and PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_4_2.physics_world, arg_4_1, var_4_0) then
		return "done"
	end

	local var_4_7, var_4_8 = ScriptUnit.extension(var_4_0, "whereabouts_system"):closest_positions_when_outside_navmesh()

	if var_4_8 then
		var_4_2:move_to(var_4_4)
	elseif #var_4_7 > 0 then
		local var_4_9 = var_4_7[1]

		var_4_2:move_to(var_4_9:unbox())
	else
		return "failed"
	end

	local var_4_10 = var_4_1.hunting_sound_distance * var_4_1.hunting_sound_distance
	local var_4_11 = arg_4_2.current_hunting_target
	local var_4_12 = var_4_1.hunting_sound_event
	local var_4_13 = var_4_1.stop_hunting_sound_event

	if var_4_5 <= var_4_10 and var_4_11 ~= var_4_0 then
		local var_4_14 = Managers.player:unit_owner(var_4_0)

		if var_4_14 and var_4_14:is_player_controlled() then
			local var_4_15 = var_4_14:network_id()
			local var_4_16 = Managers.state.network
			local var_4_17 = var_4_16.unit_storage:go_id(arg_4_1)

			var_4_16.network_transmit:send_rpc("rpc_server_audio_unit_event", var_4_15, NetworkLookup.sound_events[var_4_12], var_4_17, false, 0)

			if Unit.alive(var_4_11) then
				local var_4_18 = Managers.player:unit_owner(var_4_11):network_id()

				var_4_16.network_transmit:send_rpc("rpc_server_audio_unit_event", var_4_18, NetworkLookup.sound_events[var_4_13], var_4_17, false, 0)
			end

			arg_4_2.current_hunting_target = var_4_0
		end
	elseif var_4_10 < var_4_5 and Unit.alive(var_4_11) then
		local var_4_19 = Managers.player:unit_owner(var_4_11)

		if var_4_19 and var_4_19:is_player_controlled() then
			local var_4_20 = var_4_19:network_id()
			local var_4_21 = Managers.state.network
			local var_4_22 = var_4_21.unit_storage:go_id(arg_4_1)

			var_4_21.network_transmit:send_rpc("rpc_server_audio_unit_event", var_4_20, NetworkLookup.sound_events[var_4_13], var_4_22, false, 0)
		end

		arg_4_2.current_hunting_target = nil
	end

	return "running"
end

BTMutatorSorcererFollowAction.check_infront = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = Unit.world_position(arg_5_2, 0)
	local var_5_1 = Unit.world_position(arg_5_1, 0)
	local var_5_2 = Vector3.normalize(var_5_1 - var_5_0)
	local var_5_3 = ScriptUnit.has_extension(arg_5_2, "first_person_system")
	local var_5_4

	if var_5_3 then
		var_5_4 = Quaternion.forward(var_5_3:current_rotation())
	else
		local var_5_5 = Managers.state.network
		local var_5_6 = var_5_5:unit_game_object_id(arg_5_2)

		var_5_4 = GameSession.game_object_field(var_5_5:game(), var_5_6, "aim_direction")
	end

	local var_5_7 = Vector3.dot(var_5_4, var_5_2)
	local var_5_8 = var_5_7 >= 0.6 and var_5_7 <= 1
	local var_5_9 = math.abs((1 - var_5_7) / 0.4 - 1) * arg_5_3.infront_movement_multiplier

	return var_5_8, var_5_9
end

BTMutatorSorcererFollowAction.handle_movement_speed_bonus = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0
	local var_6_1
	local var_6_2
	local var_6_3 = arg_6_3.fast_move_speed_sound_event
	local var_6_4 = arg_6_3.stop_fast_move_speed_sound_event
	local var_6_5 = arg_6_2.navigation_extension
	local var_6_6
	local var_6_7 = arg_6_2.target_unit
	local var_6_8 = Managers.state.side.side_by_unit[var_6_7].PLAYER_AND_BOT_UNITS

	for iter_6_0, iter_6_1 in ipairs(var_6_8) do
		var_6_6 = POSITION_LOOKUP[iter_6_1]
		var_6_0, var_6_1 = arg_6_0:check_infront(arg_6_1, iter_6_1, arg_6_3)
		var_6_2 = PerceptionUtils.is_position_in_line_of_sight(arg_6_1, arg_6_4 + Vector3.up(), var_6_6 + Vector3.up(), arg_6_2.physics_world)

		if var_6_0 and var_6_2 then
			break
		end
	end

	local var_6_9 = Vector3.distance(arg_6_4, POSITION_LOOKUP[arg_6_2.target_unit])

	if var_6_0 and Vector3.length(arg_6_4 - var_6_6) > 0 and var_6_2 then
		local var_6_10 = arg_6_3.slow_down_on_look_at and arg_6_3.slow_move_speed or arg_6_3.fast_move_speed * var_6_1

		var_6_5:set_max_speed(var_6_10)

		if var_6_10 == arg_6_3.slow_move_speed and arg_6_2.played_fast_movespeed_sound then
			arg_6_0:play_movement_sound(arg_6_1, var_6_4)

			arg_6_2.played_fast_movespeed_sound = nil
		elseif not arg_6_3.slow_down_on_look_at and not arg_6_2.played_fast_movespeed_sound then
			arg_6_0:play_movement_sound(arg_6_1, var_6_3)

			arg_6_2.played_fast_movespeed_sound = true
		end
	elseif var_6_9 > arg_6_3.catchup_distance or not var_6_2 then
		local var_6_11 = arg_6_3.catchup_speed

		var_6_5:set_max_speed(var_6_11)

		if not arg_6_2.played_fast_movespeed_sound then
			arg_6_0:play_movement_sound(arg_6_1, var_6_3)

			arg_6_2.played_fast_movespeed_sound = true
		end
	else
		local var_6_12 = arg_6_3.slow_down_on_look_at and arg_6_3.fast_move_speed * 4 or arg_6_3.slow_move_speed

		var_6_5:set_max_speed(var_6_12)

		if arg_6_3.slow_down_on_look_at and not arg_6_2.played_fast_movespeed_sound then
			arg_6_0:play_movement_sound(arg_6_1, var_6_3)

			arg_6_2.played_fast_movespeed_sound = true
		elseif var_6_12 == arg_6_3.slow_move_speed then
			arg_6_0:play_movement_sound(arg_6_1, var_6_4)

			arg_6_2.played_fast_movespeed_sound = nil
		end
	end
end

BTMutatorSorcererFollowAction.play_movement_sound = function (arg_7_0, arg_7_1, arg_7_2)
	Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_7_2, arg_7_1)
end
