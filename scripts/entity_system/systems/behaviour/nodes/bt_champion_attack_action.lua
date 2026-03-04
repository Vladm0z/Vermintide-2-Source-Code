-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_champion_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChampionAttackAction = class(BTChampionAttackAction, BTNode)

BTChampionAttackAction.init = function (arg_1_0, ...)
	BTChampionAttackAction.super.init(arg_1_0, ...)
end

BTChampionAttackAction.name = "BTChampionAttackAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTChampionAttackAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTChampionAttackAction
	arg_3_2.attack_range = var_3_0.range
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.hit_players = arg_3_2.hit_players or {}
	arg_3_2.target_dodged = false

	local var_3_1 = arg_3_2.target_unit

	arg_3_2.target_unit_status_extension = ScriptUnit.has_extension(var_3_1, "status_system") and ScriptUnit.extension(var_3_1, "status_system") or nil

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_3_2.attacking_target = arg_3_2.target_unit

	arg_3_0:_init_attack(arg_3_1, arg_3_2, var_3_0, arg_3_3)

	arg_3_2.spawn_to_running = nil

	AiUtils.stormvermin_champion_hack_check_ward(arg_3_1, arg_3_2)
end

local function var_0_1()
	return false
end

local var_0_2 = {}
local var_0_3 = {}
local var_0_4 = {}
local var_0_5 = {
	mode = "retained",
	name = "BTChampionAttackAction"
}

BTChampionAttackAction._init_attack = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_2.move_state = "attacking"

	local var_5_0 = arg_5_2.world
	local var_5_1
	local var_5_2
	local var_5_3 = arg_5_3.attack_sequence

	if var_5_3 then
		var_5_1, var_5_2 = arg_5_0:_next_in_sequence(arg_5_2, arg_5_4, var_5_3, 1)
	else
		arg_5_2.attack_next_sequence_ready = var_0_1
		var_5_1 = arg_5_3.attack_anim
		var_5_2 = arg_5_3.animation_drive_scale
	end

	if arg_5_3.animation_driven and var_5_2 then
		LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(var_5_2, var_5_2, var_5_2))
	end

	if var_5_1 then
		Managers.state.network:anim_event(arg_5_1, var_0_0(var_5_1))
	else
		arg_5_0:anim_cb_damage(arg_5_1, arg_5_2)

		arg_5_2.attack_finished = true
	end

	local var_5_4 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.attacking_target)

	arg_5_2.attack_rotation = QuaternionBox(var_5_4)
	arg_5_2.attack_rotation_update_timer = arg_5_4 + arg_5_3.rotation_time

	if arg_5_3.mode == "continuous_overlap" then
		arg_5_2.last_attack_overlap_position = Vector3Box(POSITION_LOOKUP[arg_5_1])
		arg_5_2.last_attack_overlap_position_time = arg_5_4
		arg_5_2.overlap_start_time = arg_5_4 + arg_5_3.overlap_start_time
		arg_5_2.overlap_end_time = arg_5_4 + arg_5_3.overlap_end_time
		arg_5_2.overlap_walls_check_time = arg_5_4 + (arg_5_3.overlap_check_walls_time or math.huge)
	elseif arg_5_3.mode == "radial_cylinder" then
		arg_5_2.overlap_start_time = arg_5_4 + arg_5_3.overlap_start_time
		arg_5_2.overlap_end_time = arg_5_4 + arg_5_3.overlap_end_time
		arg_5_2.overlap_angle_speed = (arg_5_3.overlap_end_angle_offset - arg_5_3.overlap_start_angle_offset) / (arg_5_3.overlap_end_time - arg_5_3.overlap_start_time)

		local var_5_5 = Quaternion.forward(arg_5_2.attack_rotation:unbox())
		local var_5_6 = math.atan2(var_5_5.y, var_5_5.x)

		arg_5_2.overlap_start_angle = var_5_6 + arg_5_3.overlap_start_angle_offset
		arg_5_2.overlap_end_angle = var_5_6 + arg_5_3.overlap_end_angle_offset
		arg_5_2.overlap_last_angle = arg_5_2.overlap_start_angle
	elseif arg_5_3.mode == "nav_mesh_wave" then
		local var_5_7 = 1
		local var_5_8 = Quaternion.forward(var_5_4)
		local var_5_9 = POSITION_LOOKUP[arg_5_1]
		local var_5_10 = var_5_9 + var_5_8 * arg_5_3.offset_forward
		local var_5_11 = Managers.state.entity:system("ai_system"):nav_world()
		local var_5_12 = 2
		local var_5_13 = 2
		local var_5_14 = 0.4
		local var_5_15, var_5_16 = GwNavQueries.triangle_from_position(var_5_11, var_5_9, var_5_12, var_5_13)

		table.clear(var_0_2)
		table.clear(var_0_3)
		table.clear(var_0_4)

		if var_5_15 then
			local var_5_17 = Development.parameter("debug_ai_attack")
			local var_5_18 = World.get_data(var_5_0, "physics_world")
			local var_5_19 = arg_5_3.wave_point_distance
			local var_5_20 = Vector3(var_5_10.x, var_5_10.y, var_5_16)
			local var_5_21 = {
				Vector3Box(var_5_20)
			}

			var_0_3[var_5_7] = var_5_20

			while var_5_15 and var_5_7 < arg_5_3.num_wave_points do
				local var_5_22 = var_5_20 + var_5_8 * var_5_19
				local var_5_23

				var_5_15, var_5_23 = GwNavQueries.triangle_from_position(var_5_11, var_5_22, var_5_12, var_5_13)

				if var_5_15 then
					var_5_22.z = var_5_23
					var_5_15 = GwNavQueries.raycango(var_5_11, var_5_20, var_5_22)

					if not var_5_15 then
						local var_5_24 = var_5_20 + Vector3(0, 0, var_5_14)
						local var_5_25 = var_5_22 - var_5_20
						local var_5_26 = Vector3.length(var_5_25)
						local var_5_27 = var_5_25 / var_5_26

						var_5_15 = not PhysicsWorld.raycast(var_5_18, var_5_24, var_5_27, var_5_26, "closest", "collision_filter", "filter_ai_line_of_sight_check")
					end

					if var_5_15 then
						var_5_7 = var_5_7 + 1
						var_5_21[var_5_7] = Vector3Box(var_5_22)
						var_0_3[var_5_7] = var_5_22
						var_5_20 = var_5_22

						if var_5_17 then
							local var_5_28 = Managers.state.debug:drawer(var_0_5)

							var_5_28:reset()
							var_5_28:sphere(var_5_22, 0.25, Color(255, 0, 0))
						end
					end
				end
			end

			arg_5_2.overlap_wave_points = var_5_21
		else
			arg_5_2.overlap_wave_points = {
				Vector3Box(var_5_10)
			}
			var_0_3[var_5_7] = var_5_10
		end

		local var_5_29 = arg_5_3.anticipation_fx
		local var_5_30 = NetworkLookup.effects[var_5_29]

		for iter_5_0 = 1, var_5_7 do
			local var_5_31 = var_0_3[iter_5_0]

			var_0_2[iter_5_0] = var_5_30

			World.create_particles(var_5_0, var_5_29, var_5_31)
		end

		Managers.state.network.network_transmit:send_rpc_clients("rpc_play_fx", var_0_2, var_0_4, var_0_3)

		local var_5_32 = arg_5_3.wave_speed

		arg_5_2.overlap_start_time = arg_5_4 + arg_5_3.overlap_start_time
		arg_5_2.overlap_end_time = arg_5_2.overlap_start_time + var_5_7 * var_5_32
		arg_5_2.last_overlap_index = 0
	end

	if arg_5_3.animation_driven then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, true, true, true)
	end

	local var_5_33 = arg_5_3.bot_threat_duration

	if var_5_33 then
		if arg_5_3.collision_type == "cylinder" then
			local var_5_34 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.attacking_target)
			local var_5_35 = arg_5_0:_calculate_cylinder_collision(arg_5_3, POSITION_LOOKUP[arg_5_1], var_5_34)
			local var_5_36 = Vector3(0, arg_5_3.radius, arg_5_3.height * 0.5)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_5_35, "cylinder", var_5_36, nil, var_5_33, "Champion Attack")
		elseif arg_5_3.collision_type == "oobb" or not arg_5_3.collision_type then
			local var_5_37 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.attacking_target)
			local var_5_38, var_5_39, var_5_40 = arg_5_0:_calculate_oobb_collision(arg_5_3, POSITION_LOOKUP[arg_5_1], var_5_37)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_5_38, "oobb", var_5_40, var_5_39, var_5_33, "Champion Attack")
		end
	end
end

BTChampionAttackAction._attack_threat_over = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_2.attacking_target
	local var_6_1 = Unit.alive(var_6_0)
	local var_6_2 = arg_6_2.hit_players[var_6_0]

	if var_6_1 and not var_6_2 and (arg_6_3.throw_dialogue_system_event_on_dodged_attack and arg_6_2.target_dodged or arg_6_3.throw_dialogue_system_event_on_missed_attack) then
		local var_6_3 = ScriptUnit.extension(var_6_0, "dialogue_system").context.player_profile

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "enemy_attack", DialogueSettings.enemy_attack_distance, "attack_tag", arg_6_3.name, "target_name", var_6_3, "attack_hit", false)
	end
end

BTChampionAttackAction.leave = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_2.action
	local var_7_1 = arg_7_2.catapulted_players

	if var_7_1 then
		arg_7_2.catapulted_players = nil

		if not arg_7_5 and var_7_1[1] then
			arg_7_0:_catapult_players(arg_7_1, arg_7_2, var_7_0, var_7_1)
		end
	end

	if not arg_7_5 and var_7_0.animation_driven then
		LocomotionUtils.set_animation_driven_movement(arg_7_1, false)
		LocomotionUtils.set_animation_translation_scale(arg_7_1, Vector3(1, 1, 1))
	end

	if arg_7_2.attacking_target and not arg_7_5 then
		arg_7_0:_attack_threat_over(arg_7_1, arg_7_2, var_7_0)
	end

	local var_7_2 = arg_7_2.attacking_target
	local var_7_3 = Unit.alive(var_7_2)
	local var_7_4 = arg_7_2.hit_players[var_7_2]
	local var_7_5 = var_7_0.increment_stat_on_attack_dodged

	if var_7_5 and not arg_7_5 and var_7_3 and not var_7_4 and arg_7_2.target_dodged then
		local var_7_6 = Managers.player:owner(var_7_2)

		if var_7_6 and var_7_6.local_player then
			local var_7_7 = var_7_6:stats_id()

			Managers.player:statistics_db():increment_stat(var_7_7, var_7_5)
		elseif var_7_6 and var_7_6:is_player_controlled() then
			local var_7_8 = PEER_ID_TO_CHANNEL[var_7_6:network_id()]

			RPC.rpc_increment_stat(var_7_8, NetworkLookup.statistics[var_7_5])
		end
	end

	arg_7_2.navigation_extension:set_enabled(true)
	table.clear(arg_7_2.hit_players)

	arg_7_2.target_unit_status_extension = nil
	arg_7_2.active_node = nil
	arg_7_2.attack_aborted = nil
	arg_7_2.attack_rotation = nil
	arg_7_2.attack_rotation_update_timer = nil
	arg_7_2.attacking_target = nil
	arg_7_2.action = nil
	arg_7_2.target_dodged = nil
	arg_7_2.attack_next_sequence_step_at = nil
	arg_7_2.attack_next_sequence_index = nil

	if var_7_0.mode == "continuous_overlap" then
		arg_7_2.last_attack_overlap_position = nil
		arg_7_2.overlap_start_time = nil
		arg_7_2.overlap_end_time = nil
		arg_7_2.overlap_wall_collision_time = nil
		arg_7_2.overlap_walls_check_time = nil
	elseif var_7_0.mode == "radial_cylinder" then
		-- Nothing
	end

	local var_7_9 = var_7_0.exit_flow_event

	if var_7_9 then
		Unit.flow_event(arg_7_1, var_7_9)
	end
end

BTChampionAttackAction.run = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_2.attacking_target

	if not Unit.alive(var_8_0) or arg_8_2.attack_aborted then
		return "done"
	end

	arg_8_0:_update_rotation(arg_8_1, arg_8_3, arg_8_4, arg_8_2)

	local var_8_1 = arg_8_2.action
	local var_8_2 = arg_8_2.catapulted_players

	if var_8_2 and var_8_2[1] then
		arg_8_0:_catapult_players(arg_8_1, arg_8_2, var_8_1, var_8_2)
	end

	local var_8_3 = arg_8_2.overlap_wall_collision_time

	if var_8_3 then
		if var_8_3 < arg_8_3 then
			return "done"
		else
			return "running"
		end
	end

	if arg_8_2.attack_next_sequence_ready(arg_8_1, arg_8_2, arg_8_3) then
		local var_8_4, var_8_5 = arg_8_0:_next_in_sequence(arg_8_2, arg_8_3, var_8_1.attack_sequence, arg_8_2.attack_next_sequence_index)

		Managers.state.network:anim_event(arg_8_1, var_0_0(var_8_4))

		if var_8_1.animation_driven then
			LocomotionUtils.set_animation_translation_scale(arg_8_1, Vector3(var_8_5, var_8_5, var_8_5))
		end
	end

	if var_8_1.mode == "continuous_overlap" then
		arg_8_0:_update_overlap(arg_8_1, arg_8_2, var_8_1, arg_8_4, arg_8_3)
	elseif var_8_1.mode == "radial_cylinder" then
		arg_8_0:_update_radial_cylinder(arg_8_1, arg_8_2, var_8_1, arg_8_4, arg_8_3)
	elseif var_8_1.mode == "nav_mesh_wave" then
		arg_8_0:_update_nav_mesh_wave(arg_8_1, arg_8_2, var_8_1, arg_8_4, arg_8_3)
	end

	if arg_8_2.attack_finished then
		return "done"
	end

	return "running"
end

BTChampionAttackAction._next_in_sequence = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_3[arg_9_4]
	local var_9_1 = var_9_0.attack_anim
	local var_9_2 = var_9_0.animation_drive_scale
	local var_9_3 = arg_9_4 + 1
	local var_9_4 = arg_9_3[var_9_3]
	local var_9_5 = arg_9_2

	arg_9_1.attack_sequence_start_time = var_9_5

	if var_9_4 then
		local var_9_6 = var_9_4.at

		arg_9_1.attack_next_sequence_ready = var_9_6 and function (arg_10_0, arg_10_1, arg_10_2)
			return arg_10_2 - var_9_5 >= var_9_6
		end or var_9_4.ready_function
		arg_9_1.attack_next_sequence_index = var_9_3
	else
		arg_9_1.attack_next_sequence_ready = var_0_1
		arg_9_1.attack_next_sequence_index = nil
	end

	return var_9_1, var_9_2 or 1
end

BTChampionAttackAction._update_rotation = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_4.target_unit_status_extension
	local var_11_1 = arg_11_4.target_dodged or var_11_0 and (var_11_0:get_is_dodging() or var_11_0:is_invisible())

	arg_11_4.target_dodged = var_11_1

	local var_11_2
	local var_11_3 = POSITION_LOOKUP[arg_11_1]
	local var_11_4 = arg_11_4.attacking_target
	local var_11_5 = POSITION_LOOKUP[var_11_4]

	if Unit.alive(var_11_4) and arg_11_2 < arg_11_4.attack_rotation_update_timer and not var_11_1 and Vector3.distance_squared(var_11_3, var_11_5) > 0.09 and not arg_11_4.hit_players[var_11_4] then
		var_11_2 = LocomotionUtils.rotation_towards_unit_flat(arg_11_1, arg_11_4.attacking_target)

		local var_11_6 = var_11_5 - var_11_3

		var_11_6.z = 0

		local var_11_7 = Quaternion.look(Vector3.normalize(var_11_6))

		arg_11_4.attack_rotation:store(var_11_7)
	else
		var_11_2 = arg_11_4.attack_rotation:unbox()
	end

	arg_11_4.locomotion_extension:set_wanted_rotation(var_11_2)
end

BTChampionAttackAction._update_overlap = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = arg_12_2.overlap_start_time
	local var_12_1 = arg_12_2.overlap_end_time
	local var_12_2 = arg_12_2.last_attack_overlap_position_time
	local var_12_3 = POSITION_LOOKUP[arg_12_1]

	if var_12_0 < arg_12_5 and var_12_2 < var_12_1 then
		local var_12_4 = arg_12_2.last_attack_overlap_position:unbox()
		local var_12_5
		local var_12_6

		if var_12_2 < var_12_0 then
			local var_12_7 = (var_12_0 - var_12_2) / (arg_12_5 - var_12_2)

			var_12_5 = Vector3.lerp(var_12_4, var_12_3, var_12_7)
		else
			var_12_5 = var_12_4
		end

		if var_12_1 < arg_12_5 then
			local var_12_8 = (var_12_1 - var_12_2) / (arg_12_5 - var_12_2)

			var_12_6 = Vector3.lerp(var_12_4, var_12_3, var_12_8)
		else
			var_12_6 = var_12_3
		end

		local var_12_9 = arg_12_3.movement_controlled_rotation
		local var_12_10 = var_12_6 - var_12_5
		local var_12_11 = Vector3.length(var_12_10)
		local var_12_12 = Vector3.normalize(var_12_10)
		local var_12_13
		local var_12_14

		if var_12_9 then
			var_12_13 = Quaternion.look(var_12_12, Vector3.up())
			var_12_14 = var_12_12
		else
			var_12_13 = Unit.local_rotation(arg_12_1, 0)
			var_12_14 = Quaternion.forward(var_12_13)
		end

		local var_12_15 = Quaternion.up(var_12_13)
		local var_12_16
		local var_12_17 = arg_12_3.range

		if type(var_12_17) == "function" then
			var_12_16 = var_12_17((arg_12_5 - var_12_0) / (var_12_1 - var_12_0))
		else
			var_12_16 = var_12_17
		end

		local var_12_18 = var_12_16 + (var_12_9 and var_12_11 or Vector3.dot(var_12_10, var_12_14))
		local var_12_19 = arg_12_3.height
		local var_12_20 = arg_12_3.width
		local var_12_21 = var_12_18 * 0.5
		local var_12_22 = var_12_19 * 0.5
		local var_12_23 = var_12_5 + var_12_14 * (arg_12_3.offset_forward + var_12_21) + var_12_15 * (arg_12_3.offset_up + var_12_22)
		local var_12_24 = Vector3(var_12_20 * 0.5, var_12_21, var_12_22)
		local var_12_25 = World.get_data(arg_12_2.world, "physics_world")
		local var_12_26, var_12_27 = PhysicsWorld.immediate_overlap(var_12_25, "position", var_12_23, "rotation", var_12_13, "size", var_12_24, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_player_hit_box_check")

		if Development.parameter("debug_ai_attack") then
			local var_12_28 = Matrix4x4.from_quaternion_position(var_12_13, var_12_23)

			QuickDrawer:box(var_12_28, var_12_24)
		end

		arg_12_0:_deal_damage(arg_12_1, arg_12_2, arg_12_3, var_12_5, var_12_26, var_12_27, true)

		if arg_12_5 > arg_12_2.overlap_walls_check_time then
			local var_12_29 = 0.3
			local var_12_30 = 0.3
			local var_12_31 = arg_12_2.nav_world
			local var_12_32, var_12_33 = GwNavQueries.triangle_from_position(var_12_31, var_12_5, var_12_29, var_12_30)
			local var_12_34 = false

			if var_12_32 then
				local var_12_35 = arg_12_3.overlap_check_walls_range + arg_12_4 * Vector3.length(arg_12_2.locomotion_extension:current_velocity())
				local var_12_36 = var_12_5 + var_12_14 * var_12_35
				local var_12_37, var_12_38 = GwNavQueries.triangle_from_position(var_12_31, var_12_36, math.max(var_12_29, var_12_35), math.max(var_12_30, var_12_35))

				if not var_12_37 or not GwNavQueries.raycango(var_12_31, Vector3(var_12_5.x, var_12_5.y, var_12_33), Vector3(var_12_36.x, var_12_36.y, var_12_38)) then
					var_12_34 = true
				end
			else
				var_12_34 = true
			end

			if var_12_34 then
				arg_12_2.overlap_wall_collision_time = arg_12_5 + arg_12_3.wall_collision_stun_time

				Managers.state.network:anim_event(arg_12_1, var_0_0(arg_12_3.wall_collision_anim))
			end
		end
	elseif arg_12_2.attacking_target and var_12_1 < var_12_2 then
		arg_12_0:_attack_threat_over(arg_12_1, arg_12_2, arg_12_3)
	end

	arg_12_2.last_attack_overlap_position:store(var_12_3)

	arg_12_2.last_attack_overlap_position_time = arg_12_5
end

local var_0_6 = {}

BTChampionAttackAction._update_nav_mesh_wave = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	local var_13_0 = arg_13_2.world
	local var_13_1 = arg_13_2.overlap_start_time
	local var_13_2 = arg_13_2.overlap_end_time

	if var_13_2 < arg_13_5 and arg_13_2.attacking_target then
		arg_13_0:_attack_threat_over(arg_13_1, arg_13_2, arg_13_3)

		return
	elseif arg_13_5 < var_13_1 or var_13_2 < arg_13_5 then
		return
	end

	local var_13_3 = arg_13_3.wave_speed
	local var_13_4 = arg_13_2.overlap_wave_points
	local var_13_5 = arg_13_5 - var_13_1
	local var_13_6 = math.min(math.floor(var_13_5 * var_13_3 + 1), #var_13_4)
	local var_13_7 = arg_13_2.last_overlap_index
	local var_13_8 = math.min(var_13_7 + 1, var_13_6)
	local var_13_9 = World.get_data(var_13_0, "physics_world")

	table.clear(var_0_6)

	local var_13_10 = 0
	local var_13_11
	local var_13_12 = Development.parameter("debug_ai_attack")

	table.clear(var_0_2)
	table.clear(var_0_3)
	table.clear(var_0_4)

	local var_13_13 = 0
	local var_13_14 = arg_13_3.wave_sfx
	local var_13_15 = arg_13_3.wave_fx
	local var_13_16 = NetworkLookup.effects[var_13_15]
	local var_13_17 = NetworkLookup.sound_events[var_13_14]

	for iter_13_0 = var_13_8, var_13_6 do
		local var_13_18 = var_13_4[iter_13_0]:unbox()

		if iter_13_0 ~= var_13_7 then
			WwiseUtils.trigger_position_event(var_13_0, var_13_14, var_13_18)
			World.create_particles(var_13_0, var_13_15, var_13_18)

			var_13_13 = var_13_13 + 1
			var_0_2[var_13_13] = var_13_16
			var_0_4[var_13_13] = var_13_17
			var_0_3[var_13_13] = var_13_18
		end

		local var_13_19 = var_13_4[iter_13_0 + 1]
		local var_13_20

		var_13_20 = var_13_19 and var_13_19:unbox() or var_13_18
		var_13_11 = var_13_4[iter_13_0 - 1]
		var_13_11 = var_13_11 and var_13_11:unbox() or POSITION_LOOKUP[arg_13_1]

		local var_13_21 = Quaternion.look(var_13_20 - var_13_11, Vector3.up())
		local var_13_22 = math.max(Vector3.length(var_13_20 - var_13_18), Vector3.length(var_13_11 - var_13_18))
		local var_13_23 = arg_13_3.height * 0.5
		local var_13_24 = Vector3(arg_13_3.width * 0.5, var_13_22, var_13_23)
		local var_13_25 = Quaternion.up(var_13_21)
		local var_13_26 = (var_13_20 + var_13_11) * 0.5 + var_13_25 * var_13_23
		local var_13_27, var_13_28 = PhysicsWorld.immediate_overlap(var_13_9, "position", var_13_26, "rotation", var_13_21, "size", var_13_24, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_player_hit_box_check")

		table.append(var_0_6, var_13_27)

		var_13_10 = var_13_10 + var_13_28

		if var_13_12 then
			local var_13_29 = Matrix4x4.from_quaternion_position(var_13_21, var_13_26)

			QuickDrawer:box(var_13_29, var_13_24)
		end
	end

	if var_13_13 > 0 then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_play_fx", var_0_2, var_0_4, var_0_3)
	end

	arg_13_0:_deal_damage(arg_13_1, arg_13_2, arg_13_3, var_13_11, var_0_6, var_13_10, true)

	arg_13_2.last_overlap_index = var_13_6
end

BTChampionAttackAction.anim_cb_damage = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_2.action
	local var_14_1 = var_14_0.mode

	if var_14_1 then
		printf("BTChampionAttackAction anim_cb_damage in mode %q", var_14_1)

		return
	end

	local var_14_2 = Unit.local_position(arg_14_1, 0)
	local var_14_3 = Unit.local_rotation(arg_14_1, 0)
	local var_14_4 = World.get_data(arg_14_2.world, "physics_world")

	if var_14_0.effect_name then
		Managers.state.network:rpc_play_particle_effect(nil, NetworkLookup.effects[var_14_0.effect_name], NetworkConstants.invalid_game_object_id, 0, POSITION_LOOKUP[arg_14_1], Quaternion.identity(), false)
	end

	if var_14_0.collision_type == "oobb" or not var_14_0.collision_type then
		local var_14_5, var_14_6, var_14_7 = arg_14_0:_calculate_oobb_collision(var_14_0, var_14_2, var_14_3)
		local var_14_8, var_14_9 = PhysicsWorld.immediate_overlap(var_14_4, "position", var_14_5, "rotation", var_14_6, "size", var_14_7, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_player_hit_box_check")

		if Development.parameter("debug_ai_attack") then
			local var_14_10 = Managers.state.debug:drawer(var_0_5)

			var_14_10:reset()

			local var_14_11 = Matrix4x4.from_quaternion_position(var_14_6, var_14_5)

			var_14_10:box(var_14_11, var_14_7)
		end

		arg_14_0:_deal_damage(arg_14_1, arg_14_2, var_14_0, var_14_2, var_14_8, var_14_9, true)
	elseif var_14_0.collision_type == "cylinder" then
		local var_14_12, var_14_13, var_14_14 = arg_14_0:_calculate_cylinder_collision(var_14_0, var_14_2, var_14_3)
		local var_14_15 = var_14_13.y - var_14_13.x > 0 and "capsule" or "sphere"

		PhysicsWorld.prepare_actors_for_overlap(var_14_4, var_14_12, var_14_0.radius)

		local var_14_16, var_14_17 = PhysicsWorld.immediate_overlap(var_14_4, "position", var_14_12, "rotation", var_14_14, "size", var_14_13, "shape", var_14_15, "types", "dynamics", "collision_filter", var_14_0.collision_filter or "filter_player_hit_box_check")

		if Development.parameter("debug_ai_attack") then
			local var_14_18 = Managers.state.debug:drawer(var_0_5)

			var_14_18:reset()

			local var_14_19 = Quaternion.forward(var_14_14)

			var_14_18:cylinder(var_14_12 - var_14_19 * var_14_13.y, var_14_12 + var_14_19 * var_14_13.y, math.max(var_14_13.x, var_14_13.z), nil, 4)
		end

		arg_14_0:_deal_damage(arg_14_1, arg_14_2, var_14_0, var_14_2, var_14_16, var_14_17, true)
	end

	arg_14_0:_attack_threat_over(arg_14_1, arg_14_2, var_14_0)
end

BTChampionAttackAction._update_radial_cylinder = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if arg_15_5 > arg_15_2.overlap_end_time and arg_15_2.attacking_target then
		arg_15_0:_attack_threat_over(arg_15_1, arg_15_2, arg_15_3)

		return
	elseif arg_15_5 < arg_15_2.overlap_start_time or arg_15_5 > arg_15_2.overlap_end_time then
		return
	end

	local var_15_0 = arg_15_5 - arg_15_2.overlap_start_time
	local var_15_1 = Unit.local_position(arg_15_1, 0)
	local var_15_2 = Unit.local_rotation(arg_15_1, 0)
	local var_15_3 = World.get_data(arg_15_2.world, "physics_world")
	local var_15_4, var_15_5, var_15_6 = arg_15_0:_calculate_cylinder_collision(arg_15_3, var_15_1, var_15_2)
	local var_15_7 = var_15_5.y - var_15_5.x > 0 and "capsule" or "sphere"
	local var_15_8, var_15_9 = PhysicsWorld.immediate_overlap(var_15_3, "position", var_15_4, "rotation", var_15_6, "size", var_15_5, "shape", var_15_7, "types", "dynamics", "collision_filter", arg_15_3.collision_filter)

	if Development.parameter("debug_ai_attack") then
		local var_15_10 = Managers.state.debug:drawer(var_0_5)

		var_15_10:reset()

		local var_15_11 = Quaternion.forward(var_15_6)

		var_15_10:cylinder(var_15_4 - var_15_11 * var_15_5.y, var_15_4 + var_15_11 * var_15_5.y, math.max(var_15_5.x, var_15_5.z), nil, 4)
	end

	local var_15_12 = arg_15_2.overlap_start_angle
	local var_15_13 = arg_15_2.overlap_last_angle
	local var_15_14 = var_15_12 + var_15_0 * arg_15_2.overlap_angle_speed
	local var_15_15 = var_15_14 - var_15_13
	local var_15_16 = 0.5
	local var_15_17 = 2 * math.pi
	local var_15_18 = {}
	local var_15_19 = 0

	for iter_15_0 = 1, var_15_9 do
		local var_15_20 = var_15_8[iter_15_0]
		local var_15_21 = Actor.unit(var_15_20)

		if var_15_21 ~= arg_15_1 and not arg_15_2.hit_players[var_15_21] then
			local var_15_22 = Actor.center_of_mass(var_15_20) - var_15_1
			local var_15_23 = var_15_22.y
			local var_15_24
			local var_15_25 = arg_15_3.direction

			if var_15_25 == "clockwise" then
				var_15_24 = -var_15_22.x
			elseif var_15_25 == "counter_clockwise" then
				var_15_24 = var_15_22.x
			else
				fassert(false, "Radial cylinder overlap with invalid direction %s", tostring(var_15_25))
			end

			local var_15_26 = math.sqrt(var_15_24 * var_15_24 + var_15_23 * var_15_23)
			local var_15_27 = math.atan2(var_15_23, var_15_24)
			local var_15_28 = 2 * math.tan(var_15_16, var_15_26)
			local var_15_29 = (var_15_27 - var_15_28 - var_15_13) % var_15_17
			local var_15_30 = (var_15_27 + var_15_28 - var_15_13) % var_15_17

			if var_15_30 < var_15_29 then
				var_15_29 = var_15_29 - var_15_17
			end

			if var_15_29 < 0 and var_15_15 < var_15_30 or var_15_29 > 0 and var_15_29 < var_15_15 or var_15_30 > 0 and var_15_30 < var_15_15 then
				var_15_18[#var_15_18 + 1] = var_15_20
				var_15_19 = var_15_19 + 1
			end
		end
	end

	arg_15_0:_deal_damage(arg_15_1, arg_15_2, arg_15_3, var_15_1, var_15_18, var_15_19, false)

	arg_15_2.overlap_last_angle = var_15_14
end

BTChampionAttackAction._calculate_cylinder_collision = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_1.radius
	local var_16_1 = arg_16_1.height
	local var_16_2 = arg_16_1.offset_up
	local var_16_3 = arg_16_1.offset_forward
	local var_16_4 = arg_16_1.offset_right
	local var_16_5 = var_16_1 * 0.5
	local var_16_6 = Vector3(var_16_0, var_16_5, var_16_0)
	local var_16_7 = Quaternion.forward(arg_16_3)
	local var_16_8 = Quaternion.up(arg_16_3)
	local var_16_9 = Quaternion.right(arg_16_3)
	local var_16_10 = arg_16_2 + var_16_7 * (var_16_0 + var_16_3) + var_16_8 * (var_16_5 + var_16_2) + var_16_9 * var_16_4
	local var_16_11 = Quaternion.look(var_16_8, Vector3.up())

	return var_16_10, var_16_6, var_16_11
end

BTChampionAttackAction._calculate_oobb_collision = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_1.range
	local var_17_1 = arg_17_1.height
	local var_17_2 = arg_17_1.width
	local var_17_3 = arg_17_1.offset_up
	local var_17_4 = arg_17_1.offset_forward
	local var_17_5 = var_17_0 * 0.5
	local var_17_6 = var_17_1 * 0.5
	local var_17_7 = Vector3(var_17_2 * 0.5, var_17_5, var_17_6)
	local var_17_8 = Quaternion.rotate(arg_17_3, Vector3.forward()) * (var_17_4 + var_17_5)
	local var_17_9 = Vector3.up() * (var_17_6 + var_17_3)

	return arg_17_2 + var_17_8 + var_17_9, arg_17_3, var_17_7
end

BTChampionAttackAction._deal_damage = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	local var_18_0 = arg_18_2.hit_players
	local var_18_1 = Unit.alive
	local var_18_2 = Actor.unit
	local var_18_3 = AiUtils.damage_target
	local var_18_4 = arg_18_3.catapult
	local var_18_5 = arg_18_3.shove_speed
	local var_18_6 = arg_18_3.shove_z_speed
	local var_18_7 = arg_18_3.impact_shove_multiplier

	if var_18_7 then
		var_18_5 = Vector3.length(arg_18_2.locomotion_extension:current_velocity()) * var_18_7
	end

	assert(not var_18_5 == not var_18_6, "Shove speed and shove_z_speed both or neither need to be set")

	for iter_18_0 = 1, arg_18_6 do
		local var_18_8 = arg_18_5[iter_18_0]
		local var_18_9 = var_18_2(var_18_8)

		if DamageUtils.is_character(var_18_9) and var_18_1(var_18_9) and not var_18_0[var_18_9] and arg_18_1 ~= var_18_9 then
			var_18_0[var_18_9] = true

			local var_18_10 = arg_18_3.attack_directions and arg_18_3.attack_directions[arg_18_2.attack_anim]
			local var_18_11 = DamageUtils.check_block(arg_18_1, var_18_9, arg_18_3.fatigue_type, var_18_10)
			local var_18_12 = POSITION_LOOKUP[var_18_9]
			local var_18_13 = DamageUtils.is_player_unit(var_18_9)

			if var_18_5 and var_18_13 then
				local var_18_14 = Vector3.normalize(var_18_12 - arg_18_4)

				if arg_18_7 then
					local var_18_15 = arg_18_2.catapulted_players

					if not var_18_15 then
						var_18_15 = {}
						arg_18_2.catapulted_players = var_18_15
					end

					var_18_15[#var_18_15 + 1] = {
						target_unit = var_18_9,
						blocked = var_18_11,
						direction = Vector3Box(var_18_14)
					}
				else
					arg_18_0:_catapult_enemy(arg_18_1, arg_18_2, var_18_5, var_18_6, var_18_9, var_18_11, var_18_14)
				end
			end

			if var_18_13 and var_18_11 then
				local var_18_16 = arg_18_3.player_push_speed_blocked

				if var_18_16 then
					local var_18_17 = var_18_16 * Vector3.normalize(var_18_12 - arg_18_4)

					ScriptUnit.extension(var_18_9, "locomotion_system"):add_external_velocity(var_18_17)
				end

				local var_18_18 = arg_18_3.blocked_damage

				if var_18_18 then
					var_18_3(var_18_9, arg_18_1, arg_18_3, var_18_18)
				end

				if not arg_18_3.ignore_abort_on_blocked_attack then
					return
				end
			else
				if DamageUtils.is_enemy(arg_18_2.attacking_target, var_18_9) and arg_18_3.hit_ai_func then
					arg_18_3.hit_ai_func(arg_18_1, arg_18_2, var_18_9)
				end

				var_18_3(var_18_9, arg_18_1, arg_18_3, arg_18_3.damage)
			end
		end
	end
end

BTChampionAttackAction._catapult_players = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_3.shove_speed
	local var_19_1 = arg_19_3.shove_z_speed
	local var_19_2 = arg_19_3.impact_shove_multiplier

	if var_19_2 then
		var_19_0 = Vector3.length(arg_19_2.locomotion_extension:current_velocity()) * var_19_2
	end

	for iter_19_0, iter_19_1 in ipairs(arg_19_4) do
		local var_19_3 = iter_19_1.target_unit

		if Unit.alive(var_19_3) then
			arg_19_0:_catapult_player(arg_19_1, var_19_0, var_19_1, var_19_3, iter_19_1.blocked, iter_19_1.direction:unbox())
		end
	end

	table.clear(arg_19_4)
end

BTChampionAttackAction._catapult_player = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	local var_20_0 = ScriptUnit.extension(arg_20_4, "status_system")

	if not var_20_0:is_knocked_down() and not var_20_0:is_dead() then
		local var_20_1 = arg_20_6 * arg_20_2

		Vector3.set_z(var_20_1, arg_20_3)
		StatusUtils.set_catapulted_network(arg_20_4, true, var_20_1)
	end
end
