-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_tentacle_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTentacleAttackAction = class(BTTentacleAttackAction, BTNode)
BTTentacleAttackAction.name = "BTTentacleAttackAction"

local flag = false

BTTentacleAttackAction.init = function (arg_1_0, ...)
	-- function 1
	BTTentacleAttackAction.super.init(arg_1_0, ...)
end

BTTentacleAttackAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	local target_unit = arg_2_2.target_unit
	local has_extension = ScriptUnit.has_extension(arg_2_1, "ai_supplementary_system")

	has_extension:set_target("attack", target_unit, 0)

	arg_2_2.tentacle_spline_extension = has_extension
	arg_2_2.current_target = target_unit

	self:sync_state_to_clients(arg_2_1, arg_2_2, "attack", 0, arg_2_3)

	arg_2_2.tentacle_satisfied = false
end

BTTentacleAttackAction.sync_state_to_clients = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_3_1)
	local unit_game_object_id_2 = network:unit_game_object_id(arg_3_2.current_target)
	local var_3_3 = NetworkLookup.tentacle_template[arg_3_3]

	arg_3_4 = math.clamp(arg_3_4, 0, 31)

	network.network_transmit:send_rpc_clients("rpc_change_tentacle_state", unit_game_object_id, unit_game_object_id_2, var_3_3, arg_3_4, arg_3_5)
end

BTTentacleAttackAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.tentacle_satisfied = true
end

local alive = Unit.alive

BTTentacleAttackAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not self:update_tentacle(arg_5_1, arg_5_2, arg_5_3, arg_5_4) then
		return "running"
	end

	return "done"
end

local num = 10

BTTentacleAttackAction.update_tentacle = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local tentacle_data = arg_6_2.tentacle_data
	local current_target = arg_6_2.current_target

	if not Unit.alive(current_target) then
		return true
	end

	local node = Unit.node(current_target, "j_hips")
	local world_position = Unit.world_position(current_target, node)
	local tentacle_spline_extension = arg_6_2.tentacle_spline_extension
	local action = arg_6_2.action

	if tentacle_data.state == "spline_update" then
		local breed = arg_6_2.breed
		local spline = tentacle_data.spline
		local num_2 = world_position - tentacle_data.root_pos:unbox()
		local current_length = tentacle_data.current_length
		local lock_point_dist = tentacle_spline_extension.lock_point_dist

		if not tentacle_data.unit then
			if tentacle_data.sub_state == "grabbed" then
				current_length = current_length - breed.drag_speed * arg_6_4
				tentacle_data.current_length = current_length

				local length_squared = Vector3.length_squared(num_2)
				local var_6_12 = POSITION_LOOKUP[current_target]

				tentacle_data.last_target_pos:store(var_6_12)
				tentacle_spline_extension:set_target("attack", current_target, current_length)

				if not (self:target_tentacle_status_check(current_target, "portal_consume") or not (length_squared < 2)) then
					StatusUtils.set_grabbed_by_tentacle_status_network(current_target, "portal_consume")

					tentacle_data.wait_for_player_death = arg_6_3 + breed.time_before_consume_kill_player
					tentacle_data.wait_for_consume_end = arg_6_3 + breed.time_before_consume_end
					tentacle_data.sub_state = "portal_consume"
				end
			elseif tentacle_data.sub_state == "portal_hanging" then
				if arg_6_3 > tentacle_data.wait_for_consume then
					StatusUtils.set_grabbed_by_tentacle_status_network(current_target, "portal_consume")

					tentacle_data.wait_for_player_death = arg_6_3 + breed.time_before_consume_kill_player
					tentacle_data.wait_for_consume_end = arg_6_3 + breed.time_before_consume_end
					tentacle_data.sub_state = "portal_consume"
					tentacle_data.wait_for_consume = nil
				end
			elseif tentacle_data.sub_state == "portal_consume" then
				ScriptUnit.has_extension(current_target, "health_system"):die()

				if not (not tentacle_data.wait_for_player_death and not (arg_6_3 > tentacle_data.wait_for_player_death)) then
					StatusUtils.set_grabbed_by_tentacle_network(current_target, false, arg_6_1)

					local portal_unit = tentacle_data.portal_unit

					Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_enemy_sorcerer_portal_puke", portal_unit, "a_surface_center")

					tentacle_data.wait_for_player_death = nil
				end

				if arg_6_3 > tentacle_data.wait_for_consume_end then
					tentacle_data.sub_state = "attacking"

					self:sync_state_to_clients(arg_6_1, arg_6_2, "attack", current_length, arg_6_3)
					ScriptUnit.has_extension(arg_6_1, "health_system"):die()

					tentacle_data.state = "done"
					tentacle_data.wait_for_consume_end = nil

					return false
				end
			elseif tentacle_data.sub_state == "swipe_attack" then
				Debug.text("Swipe Attack")

				if arg_6_3 > arg_6_2.swipe_attack_timer then
					tentacle_data.sub_state = nil
					arg_6_2.next_attack_time = arg_6_3 + 2 + math.random()

					return false
				end
			elseif tentacle_data.sub_state == "target_evaded" then
				local num_3 = Vector3.length(num_2) + num
				local max_length = tentacle_data.max_length

				current_length = current_length + arg_6_4 * 25

				if max_length <= current_length then
					current_length = max_length
				elseif num_3 < current_length then
					current_length = num_3
				end

				tentacle_spline_extension:set_target("evaded", current_target, current_length)

				if arg_6_3 > arg_6_2.evaded_timer then
					tentacle_data.sub_state = nil
					arg_6_2.next_attack_time = arg_6_3 + 2 + math.random()

					return false
				end
			elseif tentacle_data.sub_state == "target_too_far_away" then
				current_length = current_length - breed.fail_retract_speed * arg_6_4

				if current_length <= 0 then
					current_length = 0
					tentacle_data.sub_state = nil
					arg_6_2.next_attack_time = arg_6_3 + 2 + math.random()
					tentacle_data.current_length = current_length

					return false
				end

				tentacle_data.current_length = current_length
				arg_6_2.tentacle_satisfied = true

				local var_6_16 = POSITION_LOOKUP[current_target]

				tentacle_data.last_target_pos:store(var_6_16)
				tentacle_spline_extension:set_target("attack", current_target, current_length)
			else
				local length = Vector3.length(num_2)
				local num_4 = (lock_point_dist or length) + tentacle_data.spiral_length
				local var_6_19
				local max_length_2 = tentacle_data.max_length
				local num_5 = current_length + arg_6_4 * 35

				if max_length_2 <= num_5 then
					num_5 = max_length_2
					var_6_19 = true
				elseif num_4 < num_5 then
					num_5 = num_4
				end

				tentacle_data.current_length = num_5

				tentacle_spline_extension:set_target("attack", current_target, num_5)

				local dist_sqr_to_tentacle_tip = self:dist_sqr_to_tentacle_tip(arg_6_1, tentacle_data, current_target)

				if dist_sqr_to_tentacle_tip < 4 then
					if not flag then
						local str = "attack_swipe"

						Managers.state.network:anim_event(arg_6_1, str)

						tentacle_data.sub_state = "swipe_attack"
						arg_6_2.swipe_attack_timer = arg_6_3 + 3

						print("FANCY ANIM")

						return true
					end

					local system = Managers.state.entity:system("audio_system")

					if not self:target_evade_through_dodge_check(action, tentacle_data, current_target, dist_sqr_to_tentacle_tip) then
						tentacle_data.sub_state = "target_evaded"

						self:sync_state_to_clients(arg_6_1, arg_6_2, "evaded", num_5, arg_6_3)
						system:play_audio_unit_event("Play_enemy_sorcerer_tentacle_foley_attack_swing", arg_6_1, breed.sound_head_node)

						arg_6_2.evaded_timer = arg_6_3 + 1 + math.random()
					elseif num_5 > num_4 - 1 then
						StatusUtils.set_grabbed_by_tentacle_network(current_target, true, arg_6_1)

						tentacle_data.sub_state = "grabbed"

						self:sync_state_to_clients(arg_6_1, arg_6_2, "attack", num_5, arg_6_3)

						tentacle_data.grabbed_timer = arg_6_3 + 2

						system:play_audio_unit_event("Play_enemy_sorcerer_tentacle_foley_player_grabbed", arg_6_1, breed.sound_head_node)
					elseif not var_6_19 then
						tentacle_data.sub_state = "target_too_far_away"

						self:sync_state_to_clients(arg_6_1, arg_6_2, "attack", num_5, arg_6_3)
					end
				end
			end
		end
	end

	return true
end

BTTentacleAttackAction.dist_sqr_to_tentacle_tip = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local var_7_0 = arg_7_2.bone_nodes[arg_7_2.num_bone_nodes]
	local world_position = Unit.world_position(arg_7_1, var_7_0)
	local flat = Vector3.flat(POSITION_LOOKUP[arg_7_3] - world_position)

	return (Vector3.length_squared(flat))
end

BTTentacleAttackAction.target_evade_through_dodge_check = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local has_extension = ScriptUnit.has_extension(arg_8_3, "status_system")

	if not (not has_extension and not has_extension.is_dodging and not (arg_8_4 > arg_8_1.dodge_mitigation_radius_squared)) then
		return true
	end
end

BTTentacleAttackAction.target_tentacle_status_check = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local has_extension = ScriptUnit.has_extension(arg_9_1, "status_system")

	if not (not has_extension and has_extension.grabbed_by_tentacle_status ~= arg_9_2) then
		return true
	end
end
