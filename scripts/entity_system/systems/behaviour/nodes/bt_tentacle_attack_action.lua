-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_tentacle_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTentacleAttackAction = class(BTTentacleAttackAction, BTNode)
BTTentacleAttackAction.name = "BTTentacleAttackAction"

local var_0_0 = false

BTTentacleAttackAction.init = function (arg_1_0, ...)
	BTTentacleAttackAction.super.init(arg_1_0, ...)
end

BTTentacleAttackAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	local var_2_0 = arg_2_2.target_unit
	local var_2_1 = ScriptUnit.has_extension(arg_2_1, "ai_supplementary_system")

	var_2_1:set_target("attack", var_2_0, 0)

	arg_2_2.tentacle_spline_extension = var_2_1
	arg_2_2.current_target = var_2_0

	arg_2_0:sync_state_to_clients(arg_2_1, arg_2_2, "attack", 0, arg_2_3)

	arg_2_2.tentacle_satisfied = false
end

BTTentacleAttackAction.sync_state_to_clients = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = Managers.state.network
	local var_3_1 = var_3_0:unit_game_object_id(arg_3_1)
	local var_3_2 = var_3_0:unit_game_object_id(arg_3_2.current_target)
	local var_3_3 = NetworkLookup.tentacle_template[arg_3_3]

	arg_3_4 = math.clamp(arg_3_4, 0, 31)

	var_3_0.network_transmit:send_rpc_clients("rpc_change_tentacle_state", var_3_1, var_3_2, var_3_3, arg_3_4, arg_3_5)
end

BTTentacleAttackAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.tentacle_satisfied = true
end

local var_0_1 = Unit.alive

BTTentacleAttackAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_0:update_tentacle(arg_5_1, arg_5_2, arg_5_3, arg_5_4) then
		return "running"
	end

	return "done"
end

local var_0_2 = 10

BTTentacleAttackAction.update_tentacle = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_2.tentacle_data
	local var_6_1 = arg_6_2.current_target

	if not Unit.alive(var_6_1) then
		return true
	end

	local var_6_2 = Unit.node(var_6_1, "j_hips")
	local var_6_3 = Unit.world_position(var_6_1, var_6_2)
	local var_6_4 = arg_6_2.tentacle_spline_extension
	local var_6_5 = arg_6_2.action

	if var_6_0.state == "spline_update" then
		local var_6_6 = arg_6_2.breed
		local var_6_7 = var_6_0.spline
		local var_6_8 = var_6_3 - var_6_0.root_pos:unbox()
		local var_6_9 = var_6_0.current_length
		local var_6_10 = var_6_4.lock_point_dist

		if var_6_0.unit then
			if var_6_0.sub_state == "grabbed" then
				var_6_9 = var_6_9 - var_6_6.drag_speed * arg_6_4
				var_6_0.current_length = var_6_9

				local var_6_11 = Vector3.length_squared(var_6_8)
				local var_6_12 = POSITION_LOOKUP[var_6_1]

				var_6_0.last_target_pos:store(var_6_12)
				var_6_4:set_target("attack", var_6_1, var_6_9)

				if not arg_6_0:target_tentacle_status_check(var_6_1, "portal_consume") and var_6_11 < 2 then
					StatusUtils.set_grabbed_by_tentacle_status_network(var_6_1, "portal_consume")

					var_6_0.wait_for_player_death = arg_6_3 + var_6_6.time_before_consume_kill_player
					var_6_0.wait_for_consume_end = arg_6_3 + var_6_6.time_before_consume_end
					var_6_0.sub_state = "portal_consume"
				end
			elseif var_6_0.sub_state == "portal_hanging" then
				if arg_6_3 > var_6_0.wait_for_consume then
					StatusUtils.set_grabbed_by_tentacle_status_network(var_6_1, "portal_consume")

					var_6_0.wait_for_player_death = arg_6_3 + var_6_6.time_before_consume_kill_player
					var_6_0.wait_for_consume_end = arg_6_3 + var_6_6.time_before_consume_end
					var_6_0.sub_state = "portal_consume"
					var_6_0.wait_for_consume = nil
				end
			elseif var_6_0.sub_state == "portal_consume" then
				ScriptUnit.has_extension(var_6_1, "health_system"):die()

				if var_6_0.wait_for_player_death and arg_6_3 > var_6_0.wait_for_player_death then
					StatusUtils.set_grabbed_by_tentacle_network(var_6_1, false, arg_6_1)

					local var_6_13 = var_6_0.portal_unit

					Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_enemy_sorcerer_portal_puke", var_6_13, "a_surface_center")

					var_6_0.wait_for_player_death = nil
				end

				if arg_6_3 > var_6_0.wait_for_consume_end then
					var_6_0.sub_state = "attacking"

					arg_6_0:sync_state_to_clients(arg_6_1, arg_6_2, "attack", var_6_9, arg_6_3)
					ScriptUnit.has_extension(arg_6_1, "health_system"):die()

					var_6_0.state = "done"
					var_6_0.wait_for_consume_end = nil

					return false
				end
			elseif var_6_0.sub_state == "swipe_attack" then
				Debug.text("Swipe Attack")

				if arg_6_3 > arg_6_2.swipe_attack_timer then
					var_6_0.sub_state = nil
					arg_6_2.next_attack_time = arg_6_3 + 2 + math.random()

					return false
				end
			elseif var_6_0.sub_state == "target_evaded" then
				local var_6_14 = Vector3.length(var_6_8) + var_0_2
				local var_6_15 = var_6_0.max_length

				var_6_9 = var_6_9 + arg_6_4 * 25

				if var_6_15 <= var_6_9 then
					var_6_9 = var_6_15
				elseif var_6_14 < var_6_9 then
					var_6_9 = var_6_14
				end

				var_6_4:set_target("evaded", var_6_1, var_6_9)

				if arg_6_3 > arg_6_2.evaded_timer then
					var_6_0.sub_state = nil
					arg_6_2.next_attack_time = arg_6_3 + 2 + math.random()

					return false
				end
			elseif var_6_0.sub_state == "target_too_far_away" then
				var_6_9 = var_6_9 - var_6_6.fail_retract_speed * arg_6_4

				if var_6_9 <= 0 then
					var_6_9 = 0
					var_6_0.sub_state = nil
					arg_6_2.next_attack_time = arg_6_3 + 2 + math.random()
					var_6_0.current_length = var_6_9

					return false
				end

				var_6_0.current_length = var_6_9
				arg_6_2.tentacle_satisfied = true

				local var_6_16 = POSITION_LOOKUP[var_6_1]

				var_6_0.last_target_pos:store(var_6_16)
				var_6_4:set_target("attack", var_6_1, var_6_9)
			else
				local var_6_17 = Vector3.length(var_6_8)
				local var_6_18 = (var_6_10 or var_6_17) + var_6_0.spiral_length
				local var_6_19
				local var_6_20 = var_6_0.max_length
				local var_6_21 = var_6_9 + arg_6_4 * 35

				if var_6_20 <= var_6_21 then
					var_6_21 = var_6_20
					var_6_19 = true
				elseif var_6_18 < var_6_21 then
					var_6_21 = var_6_18
				end

				var_6_0.current_length = var_6_21

				var_6_4:set_target("attack", var_6_1, var_6_21)

				local var_6_22 = arg_6_0:dist_sqr_to_tentacle_tip(arg_6_1, var_6_0, var_6_1)

				if var_6_22 < 4 then
					if var_0_0 then
						local var_6_23 = "attack_swipe"

						Managers.state.network:anim_event(arg_6_1, var_6_23)

						var_6_0.sub_state = "swipe_attack"
						arg_6_2.swipe_attack_timer = arg_6_3 + 3

						print("FANCY ANIM")

						return true
					end

					local var_6_24 = Managers.state.entity:system("audio_system")

					if arg_6_0:target_evade_through_dodge_check(var_6_5, var_6_0, var_6_1, var_6_22) then
						var_6_0.sub_state = "target_evaded"

						arg_6_0:sync_state_to_clients(arg_6_1, arg_6_2, "evaded", var_6_21, arg_6_3)
						var_6_24:play_audio_unit_event("Play_enemy_sorcerer_tentacle_foley_attack_swing", arg_6_1, var_6_6.sound_head_node)

						arg_6_2.evaded_timer = arg_6_3 + 1 + math.random()
					elseif var_6_21 > var_6_18 - 1 then
						StatusUtils.set_grabbed_by_tentacle_network(var_6_1, true, arg_6_1)

						var_6_0.sub_state = "grabbed"

						arg_6_0:sync_state_to_clients(arg_6_1, arg_6_2, "attack", var_6_21, arg_6_3)

						var_6_0.grabbed_timer = arg_6_3 + 2

						var_6_24:play_audio_unit_event("Play_enemy_sorcerer_tentacle_foley_player_grabbed", arg_6_1, var_6_6.sound_head_node)
					elseif var_6_19 then
						var_6_0.sub_state = "target_too_far_away"

						arg_6_0:sync_state_to_clients(arg_6_1, arg_6_2, "attack", var_6_21, arg_6_3)
					end
				end
			end
		end
	end

	return true
end

BTTentacleAttackAction.dist_sqr_to_tentacle_tip = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.bone_nodes[arg_7_2.num_bone_nodes]
	local var_7_1 = Unit.world_position(arg_7_1, var_7_0)
	local var_7_2 = Vector3.flat(POSITION_LOOKUP[arg_7_3] - var_7_1)

	return (Vector3.length_squared(var_7_2))
end

BTTentacleAttackAction.target_evade_through_dodge_check = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = ScriptUnit.has_extension(arg_8_3, "status_system")

	if var_8_0 and var_8_0.is_dodging and arg_8_4 > arg_8_1.dodge_mitigation_radius_squared then
		return true
	end
end

BTTentacleAttackAction.target_tentacle_status_check = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = ScriptUnit.has_extension(arg_9_1, "status_system")

	if var_9_0 and var_9_0.grabbed_by_tentacle_status == arg_9_2 then
		return true
	end
end
