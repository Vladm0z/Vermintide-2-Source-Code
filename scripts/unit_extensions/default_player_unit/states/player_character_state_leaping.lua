-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_leaping.lua

PlayerCharacterStateLeaping = class(PlayerCharacterStateLeaping, PlayerCharacterState)

function PlayerCharacterStateLeaping.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "leaping")

	arg_1_0._direction = Vector3Box()
end

local var_0_0 = POSITION_LOOKUP

function PlayerCharacterStateLeaping.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0.temp_params)

	local var_2_0 = arg_2_0.player
	local var_2_1 = arg_2_0.input_extension
	local var_2_2 = arg_2_0.status_extension
	local var_2_3 = arg_2_0.inventory_extension
	local var_2_4 = arg_2_0.first_person_extension

	arg_2_0._wwise_world = Managers.world:wwise_world(arg_2_0.world)
	arg_2_0._physics_world = World.get_data(arg_2_0.world, "physics_world")

	local var_2_5 = arg_2_0.status_extension.do_leap

	var_2_5.starting_pos = Vector3Box(var_0_0[arg_2_1])
	var_2_5.total_distance = Vector3.length(var_2_5.projected_hit_pos:unbox() - var_0_0[arg_2_1])
	arg_2_0._leap_data = var_2_5
	var_2_2.do_leap = false

	local var_2_6 = var_2_4:current_rotation()
	local var_2_7 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_2_6)))

	arg_2_0._move_function = arg_2_0[var_2_5.move_function]
	arg_2_0.jump_direction = Vector3Box(var_2_7)

	arg_2_0:_start_leap(arg_2_1, arg_2_5)
	CharacterStateHelper.look(var_2_1, var_2_0.viewport_name, var_2_4, var_2_2, arg_2_0.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_1, var_2_3, arg_2_0.health_extension)
	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	if var_2_0 and not var_2_0.remote and Managers.state.network:game() then
		local var_2_8 = Managers.state.unit_storage:go_id(arg_2_0.unit)

		Managers.state.network.network_transmit:send_rpc_server("rpc_leap_start", var_2_8)
	end

	arg_2_0._time_slided = 0
	arg_2_0._play_landing_event = true
	arg_2_0._played_landing_event = false
	arg_2_0._last_slam_vertical_distance = 0
end

function PlayerCharacterStateLeaping.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0:_reset_speed_and_gravity(arg_3_1)

	if arg_3_6 == "walking" or arg_3_6 == "standing" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	elseif arg_3_6 and arg_3_6 ~= "falling" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end

	local var_3_0 = arg_3_0.player

	if var_3_0 and not var_3_0.remote and Managers.state.network:game() then
		local var_3_1 = Managers.state.unit_storage:go_id(arg_3_1)

		Managers.state.network.network_transmit:send_rpc_server("rpc_leap_finished", var_3_1)
	end

	if arg_3_6 and arg_3_6 ~= "falling" and Managers.state.network:game() then
		CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
		CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")
	end

	if arg_3_6 == "catapulted" then
		arg_3_0:_finish(arg_3_1, arg_3_5, true)
	end
end

function PlayerCharacterStateLeaping.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.input_extension
	local var_4_2 = arg_4_0.status_extension
	local var_4_3 = arg_4_0.first_person_extension
	local var_4_4 = arg_4_0.locomotion_extension
	local var_4_5 = arg_4_0.inventory_extension
	local var_4_6 = arg_4_0.health_extension

	arg_4_0:_update_distance_travelled()

	local var_4_7 = arg_4_0._leap_data.leap_events

	if var_4_7 then
		local var_4_8 = var_4_7[1]
		local var_4_9 = arg_4_0._total_distance
		local var_4_10 = arg_4_0._distance_travelled

		while var_4_8 do
			if var_4_10 >= var_4_9 * var_4_8.distance_percentage then
				var_4_8.event_function(arg_4_0)
				table.remove(var_4_7, 1)

				var_4_8 = var_4_7[1]
			else
				break
			end
		end
	end

	local var_4_11 = false

	if CharacterStateHelper.do_common_state_transitions(var_4_2, var_4_0) then
		var_4_11 = true
	end

	if CharacterStateHelper.is_using_transport(var_4_2) then
		var_4_0:change_state("using_transport")

		var_4_11 = true
	end

	if CharacterStateHelper.is_overcharge_exploding(var_4_2) then
		var_4_0:change_state("overcharge_exploding")

		var_4_11 = true
	end

	if CharacterStateHelper.is_pushed(var_4_2) then
		var_4_2:set_pushed(false)
	end

	if CharacterStateHelper.is_block_broken(var_4_2) then
		var_4_2:set_block_broken(false)
	end

	local var_4_12, var_4_13 = arg_4_0:_update_movement(arg_4_1, arg_4_3, arg_4_5)

	if var_4_11 then
		if var_4_7 then
			local var_4_14 = var_4_7.finished

			if var_4_14 then
				var_4_14(arg_4_0, true, var_4_13 or var_0_0[arg_4_1])
			end
		end

		return
	end

	if var_4_12 then
		arg_4_0:_finish(arg_4_1, arg_4_5, false, var_4_13)

		if var_4_4:is_on_ground() then
			var_4_0:change_state("walking", arg_4_0.temp_params)
			var_4_3:change_state("walking")

			return
		end

		if not arg_4_0.csm.state_next and var_4_4:current_velocity().z <= 0 then
			var_4_0:change_state("falling", arg_4_0.temp_params)
			var_4_3:change_state("falling")

			return
		end
	end

	local var_4_15
	local var_4_16

	CharacterStateHelper.look(var_4_1, arg_4_0.player.viewport_name, var_4_3, var_4_2, var_4_5, var_4_15, var_4_16)
	CharacterStateHelper.update_weapon_actions(arg_4_5, arg_4_1, var_4_1, var_4_5, var_4_6)
end

function PlayerCharacterStateLeaping._update_distance_travelled(arg_5_0)
	local var_5_0 = arg_5_0.unit
	local var_5_1 = arg_5_0._leap_data
	local var_5_2 = var_0_0[var_5_0]
	local var_5_3 = var_5_1.starting_pos:unbox()
	local var_5_4 = var_5_1.projected_hit_pos:unbox()
	local var_5_5 = Vector3.flat(var_5_2 - var_5_3)
	local var_5_6 = Vector3.flat(var_5_4 - var_5_3)
	local var_5_7 = Vector3.dot(var_5_5, var_5_6)
	local var_5_8 = Vector3.length(var_5_6)

	arg_5_0._total_distance = var_5_8
	arg_5_0._distance_travelled = var_5_7 / var_5_8
end

local function var_0_1(arg_6_0, arg_6_1, arg_6_2)
	return (math.clamp(arg_6_2, arg_6_0, arg_6_1) - arg_6_0) / (arg_6_1 - arg_6_0)
end

function PlayerCharacterStateLeaping.leap(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.locomotion_extension
	local var_7_1 = var_0_0[arg_7_1]
	local var_7_2 = arg_7_0._leap_data.starting_pos:unbox()
	local var_7_3 = arg_7_0._leap_data.projected_hit_pos:unbox()
	local var_7_4 = arg_7_0._total_distance
	local var_7_5 = arg_7_0._distance_travelled
	local var_7_6 = var_7_2.z - var_7_1.z
	local var_7_7 = Vector3.normalize(arg_7_0._leap_data.direction:unbox())
	local var_7_8 = PlayerUnitMovementSettings.get_movement_settings_table(arg_7_1)
	local var_7_9 = arg_7_0._leap_data.speed
	local var_7_10 = arg_7_0.status_extension:current_move_speed_multiplier()
	local var_7_11 = var_7_9 * var_7_10 * var_7_10 * var_7_8.player_speed_scale
	local var_7_12 = var_7_4 * 0
	local var_7_13 = var_7_4 * 0.1
	local var_7_14 = var_7_4 * 0.2
	local var_7_15 = var_7_4 * 0.5
	local var_7_16 = var_7_4 * 0.7
	local var_7_17 = var_7_4 * 1

	if var_7_5 <= var_7_13 then
		local var_7_18 = var_0_1(var_7_12, var_7_13, var_7_5)
		local var_7_19 = math.ease_out_exp(var_7_18)

		var_7_11 = var_7_11 * math.lerp(0, 1, var_7_19)

		local var_7_20 = 0.25

		var_7_8.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_20

		local var_7_21 = math.clamp(var_7_8.leap.move_speed, 0, PlayerUnitMovementSettings.leap.move_speed)
		local var_7_22 = var_7_0:current_velocity()
		local var_7_23 = (Vector3.normalize(var_7_22) + var_7_7) * var_7_11
		local var_7_24 = Vector3.length(var_7_23)
		local var_7_25 = math.clamp(var_7_24, 0, var_7_21 * var_7_8.player_speed_scale)
		local var_7_26 = Vector3.normalize(var_7_23)

		var_7_0:set_wanted_velocity(var_7_26 * var_7_25)
	elseif var_7_5 <= var_7_14 then
		local var_7_27 = var_0_1(var_7_13, var_7_14, var_7_5)
		local var_7_28 = math.easeOutCubic(var_7_27)

		var_7_11 = var_7_11 * math.lerp(1, 0.8, var_7_28)

		local var_7_29 = 0.5

		var_7_8.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_29

		local var_7_30 = math.clamp(var_7_8.leap.move_speed, 0, PlayerUnitMovementSettings.leap.move_speed)
		local var_7_31 = var_7_0:current_velocity()
		local var_7_32 = (Vector3.normalize(var_7_31) + var_7_7) * var_7_11
		local var_7_33 = Vector3.length(var_7_32)
		local var_7_34 = math.clamp(var_7_33, 0, var_7_30 * var_7_8.player_speed_scale)
		local var_7_35 = Vector3.normalize(var_7_32)

		var_7_0:set_wanted_velocity(var_7_35 * var_7_34)
	elseif var_7_5 <= var_7_15 then
		local var_7_36 = var_0_1(var_7_14, var_7_15, var_7_5)
		local var_7_37 = math.ease_in_exp(var_7_36)

		var_7_11 = var_7_11 * math.lerp(0.8, 0.7, var_7_37)

		local var_7_38 = 1

		var_7_8.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_38

		local var_7_39 = math.clamp(var_7_8.leap.move_speed, 0, PlayerUnitMovementSettings.leap.move_speed)
		local var_7_40 = var_7_0:current_velocity()
		local var_7_41 = (Vector3.normalize(var_7_40) + var_7_7) * var_7_11
		local var_7_42 = Vector3.length(var_7_41)
		local var_7_43 = math.clamp(var_7_42, 0, var_7_39 * var_7_8.player_speed_scale)
		local var_7_44 = Vector3.normalize(var_7_41)

		var_7_0:set_wanted_velocity(var_7_44 * var_7_43)
	elseif var_7_5 <= var_7_16 then
		local var_7_45 = var_0_1(var_7_15, var_7_16, var_7_5)
		local var_7_46 = math.ease_out_quad(var_7_45)

		var_7_11 = var_7_11 * math.lerp(0.7, 0.5, var_7_46)
		var_7_8.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_46

		local var_7_47 = math.clamp(var_7_8.leap.move_speed, 0, PlayerUnitMovementSettings.leap.move_speed)
		local var_7_48 = var_7_0:current_velocity()
		local var_7_49 = (Vector3.normalize(var_7_48) + var_7_7) * var_7_11
		local var_7_50 = Vector3.length(var_7_49)
		local var_7_51 = math.clamp(var_7_50, 0, var_7_47 * var_7_8.player_speed_scale)
		local var_7_52 = Vector3.normalize(var_7_49)

		var_7_0:set_wanted_velocity(var_7_52 * var_7_51)
	else
		local var_7_53 = var_0_1(var_7_16, var_7_17, var_7_5)
		local var_7_54 = math.ease_out_quad(var_7_53)
		local var_7_55 = var_7_11 * math.lerp(0.5, 1.5, var_7_54)
		local var_7_56 = math.lerp(0.25, 0, var_7_54)
		local var_7_57 = math.lerp(0, 0.75, var_7_54)
		local var_7_58 = 1.5

		var_7_8.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_58

		local var_7_59 = math.clamp(var_7_8.leap.slam_speed, 0, PlayerUnitMovementSettings.leap.slam_speed)
		local var_7_60 = var_7_0:current_velocity()
		local var_7_61 = Vector3.normalize(Vector3.flat(var_7_7)) * var_7_56 + Vector3.normalize(var_7_3 - var_7_1) * var_7_57
		local var_7_62 = (Vector3.normalize(var_7_60) + var_7_61) * var_7_55
		local var_7_63 = Vector3.length(var_7_62)
		local var_7_64 = math.clamp(var_7_63, 0, var_7_59 * var_7_8.player_speed_scale)
		local var_7_65 = Vector3.normalize(var_7_62)

		var_7_0:set_forced_velocity(var_7_65 * var_7_64)
		var_7_0:set_wanted_velocity(var_7_65 * var_7_64)

		local var_7_66 = math.clamp(var_7_6, 0, math.huge)

		if var_7_66 < arg_7_0._last_slam_vertical_distance then
			arg_7_0._play_landing_event = false

			return true, var_7_1
		end

		arg_7_0._last_slam_vertical_distance = var_7_66
	end

	if var_7_17 < var_7_5 then
		return true, var_7_1
	end

	return false
end

function PlayerCharacterStateLeaping.teleleap(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0.locomotion_extension
	local var_8_1 = var_0_0[arg_8_1]
	local var_8_2 = arg_8_0._leap_data.starting_pos:unbox()
	local var_8_3 = arg_8_0._leap_data.projected_hit_pos:unbox()
	local var_8_4 = arg_8_0._total_distance
	local var_8_5 = arg_8_0._distance_travelled
	local var_8_6 = Vector3.normalize(arg_8_0._leap_data.direction:unbox())
	local var_8_7 = PlayerUnitMovementSettings.get_movement_settings_table(arg_8_1)
	local var_8_8 = arg_8_0._leap_data.speed
	local var_8_9 = arg_8_0.status_extension:current_move_speed_multiplier()
	local var_8_10 = var_8_8 * var_8_9 * var_8_9 * var_8_7.player_speed_scale
	local var_8_11 = var_8_4 * 0
	local var_8_12 = var_8_4 * 0.05
	local var_8_13 = var_8_4 * 0.2
	local var_8_14 = var_8_4 * 0.5
	local var_8_15 = var_8_4 * 1
	local var_8_16 = var_0_1(var_8_11, var_8_15, var_8_5)

	if var_8_5 <= var_8_12 then
		local var_8_17 = var_0_1(var_8_11, var_8_12, var_8_5)
		local var_8_18 = math.ease_out_exp(var_8_17)

		var_8_10 = var_8_10 * math.lerp(0, 0.25, var_8_18)

		local var_8_19 = math.lerp(5.5, 3, var_8_18)

		var_8_7.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_8_19

		local var_8_20 = math.clamp(var_8_7.teleleap.move_speed, 0, PlayerUnitMovementSettings.teleleap.move_speed)
		local var_8_21 = var_8_0:current_velocity()
		local var_8_22 = (Vector3.normalize(var_8_21) + var_8_6) * var_8_10
		local var_8_23 = Vector3.length(var_8_22)
		local var_8_24 = math.clamp(var_8_23, 0, var_8_20 * var_8_7.player_speed_scale)
		local var_8_25 = Vector3.normalize(var_8_22)

		var_8_0:set_wanted_velocity(var_8_25 * var_8_24)
	elseif var_8_5 <= var_8_13 then
		local var_8_26 = var_0_1(var_8_12, var_8_13, var_8_5)
		local var_8_27 = math.easeOutCubic(var_8_26)

		var_8_10 = var_8_10 * math.lerp(0.25, 3.5, var_8_27)

		local var_8_28 = math.lerp(0.75, 0.25, var_8_16)
		local var_8_29 = math.lerp(0, 0.75, var_8_16)
		local var_8_30 = 0.5

		var_8_7.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_8_30

		local var_8_31 = math.clamp(var_8_7.teleleap.move_speed, 0, PlayerUnitMovementSettings.teleleap.move_speed)
		local var_8_32 = var_8_0:current_velocity()
		local var_8_33 = Vector3.normalize(Vector3.flat(var_8_6)) * var_8_28 + Vector3.normalize(var_8_3 - var_8_1) * var_8_29
		local var_8_34 = (Vector3.normalize(var_8_32) + var_8_33) * var_8_10
		local var_8_35 = Vector3.length(var_8_34)
		local var_8_36 = math.clamp(var_8_35, 0, var_8_31 * var_8_7.player_speed_scale)
		local var_8_37 = Vector3.normalize(var_8_34)

		var_8_0:set_forced_velocity(var_8_37 * var_8_36)
		var_8_0:set_wanted_velocity(var_8_37 * var_8_36)
	elseif var_8_5 <= var_8_14 then
		local var_8_38 = var_0_1(var_8_13, var_8_14, var_8_5)
		local var_8_39 = math.ease_in_exp(var_8_38)
		local var_8_40 = var_8_10 * math.lerp(3.5, 5.5, var_8_39)
		local var_8_41 = math.lerp(0.25, 0.25, var_8_16)
		local var_8_42 = math.lerp(0.75, 1, var_8_16)
		local var_8_43 = 1

		var_8_7.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_8_43

		local var_8_44 = math.clamp(var_8_7.teleleap.move_speed, 0, PlayerUnitMovementSettings.teleleap.move_speed)
		local var_8_45 = var_8_0:current_velocity()
		local var_8_46 = Vector3.normalize(Vector3.flat(var_8_6)) * var_8_41 + Vector3.normalize(var_8_3 - var_8_1) * var_8_42
		local var_8_47 = (Vector3.normalize(var_8_45) + var_8_46) * var_8_40
		local var_8_48 = Vector3.length(var_8_47)
		local var_8_49 = math.clamp(var_8_48, 0, var_8_44 * var_8_7.player_speed_scale)
		local var_8_50 = Vector3.normalize(var_8_47)

		var_8_0:set_forced_velocity(var_8_50 * var_8_49)
		var_8_0:set_wanted_velocity(var_8_50 * var_8_49)
	else
		local var_8_51 = arg_8_0:_teleport_to_with_collision(var_8_1, var_8_3, nil, "filter_mover_blocker")

		return true, var_8_51
	end

	return false
end

function PlayerCharacterStateLeaping._teleport_to_with_collision(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_0.locomotion_extension
	local var_9_1 = arg_9_0._physics_world
	local var_9_2 = 1
	local var_9_3 = 20
	local var_9_4 = PhysicsWorld.linear_sphere_sweep(var_9_1, arg_9_1, arg_9_2, var_9_2, var_9_3, "collision_filter", arg_9_4, "report_initial_overlap")
	local var_9_5

	if not var_9_4 then
		var_9_5 = arg_9_2
	else
		var_9_5 = arg_9_1
	end

	var_9_0:teleport_to(var_9_5, arg_9_3)

	return var_9_5
end

function PlayerCharacterStateLeaping._update_movement(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_0._leap_done then
		return arg_10_0._leap_done, arg_10_0._final_position:unbox()
	end

	local var_10_0 = 0.016666666666666666
	local var_10_1 = 0
	local var_10_2
	local var_10_3

	while not var_10_2 and var_10_1 < arg_10_2 do
		local var_10_4 = math.min(var_10_0, arg_10_2 - var_10_1)

		var_10_1 = math.min(var_10_1 + var_10_0, arg_10_2)
		var_10_2, var_10_3 = arg_10_0:_move_function(arg_10_1, var_10_4, arg_10_3)
	end

	local var_10_5 = CharacterStateHelper.is_colliding_down(arg_10_1)

	arg_10_0._leap_done = var_10_2 or var_10_5
	arg_10_0._final_position = Vector3Box(var_10_2 and var_10_3 or var_0_0[arg_10_1])

	return arg_10_0._leap_done, var_10_3
end

function PlayerCharacterStateLeaping._reset_speed_and_gravity(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.locomotion_extension

	PlayerUnitMovementSettings.get_movement_settings_table(arg_11_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration

	var_11_0:set_forced_velocity(Vector3.zero())
	var_11_0:set_wanted_velocity(Vector3.zero())
	var_11_0:reset_maximum_upwards_velocity()
	var_11_0:set_external_velocity_enabled(true)
end

function PlayerCharacterStateLeaping._finish(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_0.locomotion_extension
	local var_12_1 = arg_12_0.first_person_extension
	local var_12_2 = arg_12_0._leap_data
	local var_12_3 = arg_12_0._play_landing_event

	arg_12_0:_reset_speed_and_gravity(arg_12_1)

	if var_12_3 then
		var_12_0:force_on_ground(true)

		if var_12_2.camera_effect_sequence_land then
			var_12_1:play_camera_effect_sequence(var_12_2.camera_effect_sequence_land, arg_12_2)
		end

		local var_12_4 = var_12_2.sfx_event_land

		if var_12_4 and not arg_12_0._played_landing_event then
			var_12_1:play_unit_sound_event(var_12_4, arg_12_1, 0, true)

			arg_12_0._played_landing_event = true
		end
	end

	local var_12_5 = var_12_2.leap_events

	if var_12_5 then
		local var_12_6 = var_12_5.finished

		if var_12_6 then
			var_12_6(arg_12_0, arg_12_3 or not var_12_3, arg_12_4 or var_0_0[arg_12_1])
		end
	end

	arg_12_0._leap_done = true
end

function PlayerCharacterStateLeaping._start_leap(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.locomotion_extension
	local var_13_1 = arg_13_0.first_person_extension
	local var_13_2 = arg_13_0._leap_data

	if var_13_2.camera_effect_sequence_start then
		var_13_1:play_camera_effect_sequence(var_13_2.camera_effect_sequence_start, arg_13_2)
	end

	if var_13_2.anim_start_event_1p then
		CharacterStateHelper.play_animation_event_first_person(var_13_1, var_13_2.anim_start_event_1p)
	end

	if var_13_2.anim_start_event_3p then
		CharacterStateHelper.play_animation_event(arg_13_1, var_13_2.anim_start_event_3p)
	end

	local var_13_3 = arg_13_0._leap_data.sfx_event_jump

	if var_13_3 then
		var_13_1:play_unit_sound_event(var_13_3, arg_13_1, 0, true)
	end

	local var_13_4 = var_13_2.direction:unbox() * var_13_2.initial_vertical_speed + Vector3.up()

	var_13_0:set_maximum_upwards_velocity(var_13_4.z)
	var_13_0:force_on_ground(false)
	var_13_0:set_forced_velocity(var_13_4)
	var_13_0:set_wanted_velocity(var_13_4)

	PlayerUnitMovementSettings.get_movement_settings_table(arg_13_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * 0

	local var_13_5 = var_13_2.leap_events

	if var_13_5 then
		local var_13_6 = var_13_5.start

		if var_13_6 then
			var_13_6(arg_13_0)
		end
	end

	arg_13_0._leap_done = false
end
