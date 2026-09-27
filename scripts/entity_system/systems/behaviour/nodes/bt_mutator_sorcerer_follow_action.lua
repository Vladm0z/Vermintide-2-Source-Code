-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_mutator_sorcerer_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMutatorSorcererFollowAction = class(BTMutatorSorcererFollowAction, BTNode)

BTMutatorSorcererFollowAction.init = function (arg_1_0, ...)
	-- function 1
	BTMutatorSorcererFollowAction.super.init(arg_1_0, ...)
end

BTMutatorSorcererFollowAction.name = "BTMutatorSorcererFollowAction"

BTMutatorSorcererFollowAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	local start_anims_name = action_data.start_anims_name
	local var_2_2 = POSITION_LOOKUP[arg_2_2.target_unit]
	local get_start_move_animation = AiAnimUtils.get_start_move_animation(arg_2_1, var_2_2, start_anims_name)
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_2_1, arg_2_2)
	local navigation_extension = arg_2_2.navigation_extension

	navigation_extension:set_max_speed(get_default_breed_move_speed)
	navigation_extension:set_enabled(true)

	local network = Managers.state.network

	arg_2_2.move_state = "moving"

	network:anim_event(arg_2_1, "float_into")
	network:anim_event(arg_2_1, get_start_move_animation)

	local physics_world = arg_2_2.physics_world

	physics_world = physics_world or World.get_data(arg_2_2.world, "physics_world")
	arg_2_2.physics_world = physics_world

	local system = Managers.state.entity:system("audio_system")
	local skulking_sound_event = action_data.skulking_sound_event

	system:play_audio_unit_event(skulking_sound_event, arg_2_1)
end

BTMutatorSorcererFollowAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local system = Managers.state.entity:system("audio_system")
	local stop_skulking_sound_event = arg_3_2.action.stop_skulking_sound_event

	system:play_audio_unit_event(stop_skulking_sound_event, arg_3_1)

	if not arg_3_2.played_fast_movespeed_sound then
		local stop_fast_move_speed_sound_event = arg_3_2.action.stop_fast_move_speed_sound_event

		system:play_audio_unit_event(stop_fast_move_speed_sound_event, arg_3_1)

		arg_3_2.played_fast_movespeed_sound = nil
	end

	local current_hunting_target = arg_3_2.current_hunting_target

	if not Unit.alive(current_hunting_target) then
		local stop_hunting_sound_event = arg_3_2.action.stop_hunting_sound_event
		local network_id = Managers.player:unit_owner(current_hunting_target):network_id()
		local network = Managers.state.network
		local go_id = network.unit_storage:go_id(arg_3_1)

		network.network_transmit:send_rpc("rpc_server_audio_unit_event", network_id, NetworkLookup.sound_events[stop_hunting_sound_event], go_id, false, 0)
	end

	arg_3_2.action = nil
	arg_3_2.start_anim_locked = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.start_finished = nil
end

BTMutatorSorcererFollowAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local target_unit = arg_4_2.target_unit
	local action = arg_4_2.action
	local navigation_extension = arg_4_2.navigation_extension

	if not AiUtils.is_of_interest_to_corruptor(arg_4_1, target_unit) then
		return "failed"
	end

	local var_4_3 = POSITION_LOOKUP[arg_4_1]
	local var_4_4 = POSITION_LOOKUP[target_unit]

	self:handle_movement_speed_bonus(arg_4_1, arg_4_2, action, var_4_3, var_4_4, target_unit)

	local distance_squared = Vector3.distance_squared(var_4_3, var_4_4)
	local distance_to_attack = action.distance_to_attack

	if not (distance_squared < distance_to_attack * distance_to_attack) or not PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_4_2.physics_world, arg_4_1, target_unit) then
		return "done"
	end

	local closest_positions_when_outside_navmesh, var_4_8 = ScriptUnit.extension(target_unit, "whereabouts_system"):closest_positions_when_outside_navmesh()

	if not var_4_8 then
		navigation_extension:move_to(var_4_4)
	elseif #closest_positions_when_outside_navmesh > 0 then
		local var_4_9 = closest_positions_when_outside_navmesh[1]

		navigation_extension:move_to(var_4_9:unbox())
	else
		return "failed"
	end

	local num = action.hunting_sound_distance * action.hunting_sound_distance
	local current_hunting_target = arg_4_2.current_hunting_target
	local hunting_sound_event = action.hunting_sound_event
	local stop_hunting_sound_event = action.stop_hunting_sound_event

	if not (not (distance_squared <= num) or current_hunting_target == target_unit) then
		local unit_owner = Managers.player:unit_owner(target_unit)

		if not (not unit_owner and unit_owner:is_player_controlled()) then
			local network_id = unit_owner:network_id()
			local network = Managers.state.network
			local go_id = network.unit_storage:go_id(arg_4_1)

			network.network_transmit:send_rpc("rpc_server_audio_unit_event", network_id, NetworkLookup.sound_events[hunting_sound_event], go_id, false, 0)

			if not Unit.alive(current_hunting_target) then
				local network_id_2 = Managers.player:unit_owner(current_hunting_target):network_id()

				network.network_transmit:send_rpc("rpc_server_audio_unit_event", network_id_2, NetworkLookup.sound_events[stop_hunting_sound_event], go_id, false, 0)
			end

			arg_4_2.current_hunting_target = target_unit
		end
	elseif not (num < distance_squared) or not Unit.alive(current_hunting_target) then
		local unit_owner_2 = Managers.player:unit_owner(current_hunting_target)

		if not (not unit_owner_2 and unit_owner_2:is_player_controlled()) then
			local network_id_3 = unit_owner_2:network_id()
			local network_2 = Managers.state.network
			local go_id_2 = network_2.unit_storage:go_id(arg_4_1)

			network_2.network_transmit:send_rpc("rpc_server_audio_unit_event", network_id_3, NetworkLookup.sound_events[stop_hunting_sound_event], go_id_2, false, 0)
		end

		arg_4_2.current_hunting_target = nil
	end

	return "running"
end

BTMutatorSorcererFollowAction.check_infront = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local world_position = Unit.world_position(arg_5_2, 0)
	local world_position_2 = Unit.world_position(arg_5_1, 0)
	local normalize = Vector3.normalize(world_position_2 - world_position)
	local has_extension = ScriptUnit.has_extension(arg_5_2, "first_person_system")
	local var_5_4

	if not has_extension then
		var_5_4 = Quaternion.forward(has_extension:current_rotation())
	else
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_5_2)

		var_5_4 = GameSession.game_object_field(network:game(), unit_game_object_id, "aim_direction")
	end

	local dot = Vector3.dot(var_5_4, normalize)
	local flag = not (dot >= 0.6) or dot <= 1
	local num = math.abs((1 - dot) / 0.4 - 1) * arg_5_3.infront_movement_multiplier

	return flag, num
end

BTMutatorSorcererFollowAction.handle_movement_speed_bonus = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local var_6_0
	local var_6_1
	local var_6_2
	local fast_move_speed_sound_event = arg_6_3.fast_move_speed_sound_event
	local stop_fast_move_speed_sound_event = arg_6_3.stop_fast_move_speed_sound_event
	local navigation_extension = arg_6_2.navigation_extension
	local var_6_6
	local target_unit = arg_6_2.target_unit
	local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[target_unit].PLAYER_AND_BOT_UNITS

	for i, v in ipairs(PLAYER_AND_BOT_UNITS) do
		var_6_6 = POSITION_LOOKUP[v]
		var_6_0, var_6_1 = self:check_infront(arg_6_1, v, arg_6_3)
		var_6_2 = PerceptionUtils.is_position_in_line_of_sight(arg_6_1, arg_6_4 + Vector3.up(), var_6_6 + Vector3.up(), arg_6_2.physics_world)

		if not var_6_0 and not var_6_2 then
			break
		end
	end

	local distance = Vector3.distance(arg_6_4, POSITION_LOOKUP[arg_6_2.target_unit])

	if not var_6_0 and not (Vector3.length(arg_6_4 - var_6_6) > 0) or not var_6_2 then
		local slow_move_speed

		if not arg_6_3.slow_down_on_look_at then
			slow_move_speed = arg_6_3.slow_move_speed

			if not slow_move_speed then
				-- Nothing
			end
		end

		slow_move_speed = arg_6_3.fast_move_speed * var_6_1

		::label_6_0::

		navigation_extension:set_max_speed(slow_move_speed)

		if slow_move_speed ~= arg_6_3.slow_move_speed or not arg_6_2.played_fast_movespeed_sound then
			self:play_movement_sound(arg_6_1, stop_fast_move_speed_sound_event)

			arg_6_2.played_fast_movespeed_sound = nil
		elseif not (arg_6_3.slow_down_on_look_at or arg_6_2.played_fast_movespeed_sound) then
			self:play_movement_sound(arg_6_1, fast_move_speed_sound_event)

			arg_6_2.played_fast_movespeed_sound = true
		end
	elseif not (distance > arg_6_3.catchup_distance or var_6_2) then
		local catchup_speed = arg_6_3.catchup_speed

		navigation_extension:set_max_speed(catchup_speed)

		if not arg_6_2.played_fast_movespeed_sound then
			self:play_movement_sound(arg_6_1, fast_move_speed_sound_event)

			arg_6_2.played_fast_movespeed_sound = true
		end
	else
		local num

		if not arg_6_3.slow_down_on_look_at then
			num = arg_6_3.fast_move_speed * 4

			if not num then
				-- Nothing
			end
		end

		num = arg_6_3.slow_move_speed

		::label_6_1::

		navigation_extension:set_max_speed(num)

		if not (not arg_6_3.slow_down_on_look_at and arg_6_2.played_fast_movespeed_sound) then
			self:play_movement_sound(arg_6_1, fast_move_speed_sound_event)

			arg_6_2.played_fast_movespeed_sound = true
		elseif num == arg_6_3.slow_move_speed then
			self:play_movement_sound(arg_6_1, stop_fast_move_speed_sound_event)

			arg_6_2.played_fast_movespeed_sound = nil
		end
	end
end

BTMutatorSorcererFollowAction.play_movement_sound = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_7_2, arg_7_1)
end
