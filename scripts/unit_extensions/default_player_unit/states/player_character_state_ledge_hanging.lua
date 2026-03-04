-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_ledge_hanging.lua

PlayerCharacterStateLedgeHanging = class(PlayerCharacterStateLedgeHanging, PlayerCharacterState)

function PlayerCharacterStateLedgeHanging.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "ledge_hanging")

	local var_1_0 = arg_1_1

	arg_1_0.lerp_target_position = Vector3Box()
	arg_1_0.lerp_start_position = Vector3Box()
end

function PlayerCharacterStateLedgeHanging.on_enter_animation(arg_2_0)
	local var_2_0 = arg_2_0.unit

	CharacterStateHelper.play_animation_event_first_person(arg_2_0.first_person_extension, "idle")
	CharacterStateHelper.play_animation_event(var_2_0, "hanging")
end

function PlayerCharacterStateLedgeHanging.change_to_third_person_camera(arg_3_0)
	CharacterStateHelper.change_camera_state(arg_3_0.player, "follow_third_person_ledge")
	arg_3_0.first_person_extension:set_first_person_mode(false)

	local var_3_0 = true

	CharacterStateHelper.show_inventory_3p(arg_3_0.unit, false, var_3_0, arg_3_0.is_server, arg_3_0.inventory_extension)
end

function PlayerCharacterStateLedgeHanging.on_enter(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	local var_4_0 = arg_4_0.unit

	arg_4_0.ledge_unit = arg_4_7.ledge_unit

	CharacterStateHelper.stop_weapon_actions(arg_4_0.inventory_extension, "ledge_hanging")
	CharacterStateHelper.stop_career_abilities(arg_4_0.career_extension, "ledge_hanging")
	arg_4_0.locomotion_extension:enable_script_driven_ladder_movement()
	arg_4_0.locomotion_extension:set_forced_velocity(Vector3:zero())

	arg_4_0.fall_down_time = arg_4_5 + PlayerUnitMovementSettings.get_movement_settings_table(var_4_0).ledge_hanging.time_until_fall_down

	arg_4_0:calculate_and_start_rotation_to_ledge()
	arg_4_0:calculate_start_position()
	arg_4_0:calculate_offset_rotation()
	arg_4_0:on_enter_animation()
	arg_4_0:change_to_third_person_camera()
	CharacterStateHelper.set_is_on_ledge(arg_4_0.ledge_unit, var_4_0, true, arg_4_0.is_server, arg_4_0.status_extension)
end

function PlayerCharacterStateLedgeHanging.on_exit(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	arg_5_0.rotate_timer_yaw = nil
	arg_5_0.position_lerp_timer = nil
	arg_5_0.start_rotation = nil

	if arg_5_6 ~= "leave_ledge_hanging_pull_up" then
		if arg_5_6 ~= "leave_ledge_hanging_falling" then
			CharacterStateHelper.change_camera_state(arg_5_0.player, "follow")
			arg_5_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
		end

		local var_5_0 = arg_5_0.status_extension

		arg_5_0.locomotion_extension:enable_script_driven_movement()

		local var_5_1 = false

		CharacterStateHelper.show_inventory_3p(arg_5_1, true, var_5_1, arg_5_0.is_server, arg_5_0.inventory_extension)

		if Managers.state.network:game() then
			CharacterStateHelper.set_is_on_ledge(arg_5_0.ledge_unit, arg_5_1, false, arg_5_0.is_server, arg_5_0.status_extension)
		end
	elseif arg_5_6 == "leave_ledge_hanging_pull_up" or arg_5_6 == "leave_ledge_hanging_falling" then
		CharacterStateHelper.change_camera_state(arg_5_0.player, "follow_third_person")
	end
end

function PlayerCharacterStateLedgeHanging.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0.csm
	local var_6_1 = arg_6_0.unit
	local var_6_2 = arg_6_0.locomotion_extension
	local var_6_3 = arg_6_0.input_extension
	local var_6_4 = arg_6_0.status_extension
	local var_6_5 = arg_6_0.first_person_extension

	if var_6_4:is_pulled_up() or DebugKeyHandler.key_pressed("c", "pull up from ledge hanging", "player") then
		local var_6_6 = arg_6_0.temp_params

		var_6_6.ledge_unit = arg_6_0.ledge_unit
		var_6_6.start_rotation_box = arg_6_0.start_rotation_box

		var_6_0:change_state("leave_ledge_hanging_pull_up", var_6_6)

		return
	end

	if arg_6_5 > arg_6_0.fall_down_time or CharacterStateHelper.is_knocked_down(var_6_4) then
		local var_6_7 = arg_6_0.temp_params

		var_6_7.ledge_unit = arg_6_0.ledge_unit

		var_6_0:change_state("leave_ledge_hanging_falling", var_6_7)
		Unit.set_local_rotation(var_6_1, 0, arg_6_0.start_rotation_box:unbox())

		return
	end

	if arg_6_0.position_lerp_timer then
		arg_6_0.position_lerp_timer = arg_6_0.position_lerp_timer + arg_6_3

		local var_6_8 = math.clamp(arg_6_0.position_lerp_timer / arg_6_0.time_for_position_lerp, 0, 1)
		local var_6_9 = arg_6_0.lerp_start_position:unbox()
		local var_6_10 = var_6_9 + (arg_6_0.lerp_target_position:unbox() - var_6_9) * var_6_8

		var_6_2:teleport_to(var_6_10)

		if var_6_8 == 1 then
			arg_6_0.time_for_position_lerp = nil
			arg_6_0.position_lerp_timer = nil
		end
	end

	if CharacterStateHelper.do_common_state_transitions(var_6_4, var_6_0, "ledge_hanging") then
		return
	end

	arg_6_0.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_6_3, arg_6_0.player.viewport_name, arg_6_0.first_person_extension, var_6_4, arg_6_0.inventory_extension)
	arg_6_0.locomotion_extension:set_forced_velocity(Vector3:zero())
end

function PlayerCharacterStateLedgeHanging.calculate_start_position(arg_7_0)
	local var_7_0 = arg_7_0.unit
	local var_7_1 = arg_7_0.ledge_unit
	local var_7_2 = PlayerUnitMovementSettings.get_movement_settings_table(var_7_0)
	local var_7_3 = Unit.local_scale(var_7_1, 0)
	local var_7_4 = Unit.node(var_7_1, "g_gameplay_ledge_trigger_box")
	local var_7_5 = Unit.world_position(var_7_1, var_7_4)
	local var_7_6 = Unit.world_rotation(var_7_1, var_7_4)
	local var_7_7 = Unit.local_position(var_7_0, 0)
	local var_7_8 = Quaternion.right(var_7_6)
	local var_7_9 = var_7_7 - var_7_5
	local var_7_10 = Vector3.dot(var_7_8, var_7_9)
	local var_7_11 = Unit.node(var_7_1, "g_gameplay_ledge_finger_box")
	local var_7_12 = Unit.world_position(var_7_1, var_7_11)
	local var_7_13 = Unit.world_rotation(var_7_1, var_7_11)
	local var_7_14 = Unit.local_scale(var_7_1, var_7_11)
	local var_7_15 = Quaternion.right(var_7_13)
	local var_7_16 = (1 - 0.3 * (1 / var_7_3.x) * (1 / var_7_14.x)) * var_7_3.x * var_7_14.x
	local var_7_17 = var_7_12 - var_7_15 * var_7_16
	local var_7_18 = var_7_12 + var_7_15 * var_7_16
	local var_7_19 = Geometry.closest_point_on_line(var_7_7, var_7_17, var_7_18)
	local var_7_20 = Vector3.distance(var_7_7, var_7_19)

	arg_7_0.lerp_start_position:store(var_7_7)
	arg_7_0.lerp_target_position:store(var_7_19)

	arg_7_0.time_for_position_lerp = var_7_20 * var_7_2.ledge_hanging.attach_position_lerp_time_per_meter
	arg_7_0.position_lerp_timer = 0

	local var_7_21 = 0.5
	local var_7_22 = var_7_19 - Quaternion.forward(var_7_6) * var_7_21

	ScriptUnit.extension(var_7_0, "whereabouts_system"):set_new_hang_ledge_position(var_7_22)
end

function PlayerCharacterStateLedgeHanging.calculate_and_start_rotation_to_ledge(arg_8_0)
	local var_8_0 = arg_8_0.unit
	local var_8_1 = arg_8_0.ledge_unit
	local var_8_2 = PlayerUnitMovementSettings.get_movement_settings_table(var_8_0)
	local var_8_3 = Unit.node(var_8_1, "g_gameplay_ledge_finger_box")
	local var_8_4 = Unit.world_rotation(var_8_1, var_8_3)
	local var_8_5 = Quaternion.yaw(var_8_4)
	local var_8_6 = Quaternion(Vector3.up(), var_8_5 + math.pi)
	local var_8_7 = Quaternion.forward(var_8_6)

	arg_8_0.start_rotation_box = QuaternionBox(Quaternion.look(-var_8_7))

	Unit.set_local_rotation(var_8_0, 0, var_8_6)
end

function PlayerCharacterStateLedgeHanging.calculate_offset_rotation(arg_9_0)
	local var_9_0 = arg_9_0.unit
	local var_9_1 = arg_9_0.ledge_unit
	local var_9_2 = Unit.local_rotation(var_9_0, 0)
	local var_9_3 = Quaternion.forward(var_9_2)
	local var_9_4 = arg_9_0.lerp_target_position:unbox()
	local var_9_5 = Vector3.up() * 0.25
	local var_9_6 = var_9_4 + var_9_3 * 0.25 + var_9_5
	local var_9_7 = World.physics_world(arg_9_0.world)
	local var_9_8 = PerceptionUtils.is_position_in_line_of_sight
	local var_9_9 = var_9_6 - Vector3.up() * 2.25
	local var_9_10, var_9_11 = var_9_8(var_9_0, var_9_6, var_9_9, var_9_7)

	if not var_9_10 then
		local var_9_12
		local var_9_13
		local var_9_14
		local var_9_15 = 5

		for iter_9_0 = 1, var_9_15 do
			var_9_14 = var_9_9 + var_9_3 * 0.5 * iter_9_0

			local var_9_16

			var_9_12, var_9_16 = var_9_8(var_9_0, var_9_6, var_9_14, var_9_7)

			if var_9_12 then
				break
			end
		end

		if var_9_12 then
			local var_9_17 = Quaternion.right(var_9_2)
			local var_9_18 = Vector3.normalize(var_9_14 - var_9_4)
			local var_9_19 = Vector3.cross(var_9_17, var_9_18)

			var_9_2 = Quaternion.look(var_9_19)
		elseif script_data.debug_hang_ledges then
			-- block empty
		end
	end

	Unit.set_local_rotation(var_9_0, 0, var_9_2)
end
