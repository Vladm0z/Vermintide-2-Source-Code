-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_lunging.lua

local var_0_0 = POSITION_LOOKUP

PlayerCharacterStateLunging = class(PlayerCharacterStateLunging, PlayerCharacterState)

function PlayerCharacterStateLunging.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "lunging")

	arg_1_0._direction = Vector3Box()
	arg_1_0._last_position = Vector3Box()
end

function PlayerCharacterStateLunging._on_enter_animation(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_3 then
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	else
		CharacterStateHelper.play_animation_event(arg_2_1, arg_2_2)
	end

	local var_2_0 = arg_2_0.first_person_extension

	CharacterStateHelper.play_animation_event_first_person(var_2_0, arg_2_5 or arg_2_2)
end

function PlayerCharacterStateLunging.on_enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	table.clear(arg_3_0.temp_params)

	local var_3_0 = arg_3_0.input_extension
	local var_3_1 = arg_3_0.first_person_extension
	local var_3_2 = arg_3_0.status_extension
	local var_3_3 = arg_3_0.status_extension.do_lunge

	arg_3_0._lunge_data = var_3_3
	arg_3_0.status_extension.do_lunge = false
	arg_3_0.career_extension = ScriptUnit.extension(arg_3_1, "career_system")
	arg_3_0._first_person_unit = var_3_1:get_first_person_unit()
	arg_3_0.damage_start_time = var_3_3.damage_start_time and arg_3_5 + var_3_3.damage_start_time or arg_3_5
	arg_3_0.ledge_falloff_immunity_time = var_3_3.ledge_falloff_immunity and arg_3_5 + var_3_3.ledge_falloff_immunity

	local var_3_4 = Quaternion.forward(arg_3_0.first_person_extension:current_rotation())

	Vector3.set_z(var_3_4, 0)

	local var_3_5 = Vector3.normalize(var_3_4)
	local var_3_6 = Quaternion.look(var_3_5, Vector3.up())

	Unit.set_local_rotation(arg_3_1, 0, var_3_6)
	CharacterStateHelper.look(var_3_0, arg_3_0.player.viewport_name, var_3_1, var_3_2, arg_3_0.inventory_extension)

	if var_3_3.animation_event then
		arg_3_0:_on_enter_animation(arg_3_1, var_3_3.animation_event, var_3_3.animation_variable_name, var_3_3.animation_variable_value, var_3_3.first_person_animation_event)
	end

	arg_3_0._num_impacts = 0
	arg_3_0._amount_of_mass_hit = 0
	arg_3_0._hit_units = {}
	arg_3_0._start_time = arg_3_5

	arg_3_0._last_position:store(var_0_0[arg_3_1])
	arg_3_0._direction:store(var_3_5)

	arg_3_0._falling = false
	arg_3_0._stop = false

	local var_3_7 = var_3_3.lunge_events

	if var_3_7 then
		local var_3_8 = var_3_7.start

		if var_3_8 then
			var_3_8(arg_3_0)
		end
	end

	var_3_1:disable_rig_movement()

	local var_3_9 = var_3_3.damage

	if var_3_9 then
		local var_3_10 = var_3_9.damage_profile or "default"
		local var_3_11, var_3_12, var_3_13, var_3_14 = arg_3_0:_parse_attack_data(var_3_9)

		arg_3_0.damage_profile_id = NetworkLookup.damage_profiles[var_3_10]

		local var_3_15 = DamageProfileTemplates[var_3_10]

		arg_3_0.damage_profile = var_3_15

		local var_3_16 = Managers.state.difficulty:get_difficulty()
		local var_3_17 = ActionUtils.scale_power_levels(var_3_12, "cleave", arg_3_1, var_3_16)
		local var_3_18, var_3_19 = ActionUtils.get_max_targets(var_3_15, var_3_17)

		arg_3_0.max_targets_attack = var_3_18
		arg_3_0.max_targets_impact = var_3_19
		arg_3_0.max_targets = var_3_19 < var_3_18 and var_3_18 or var_3_19
	end

	if var_3_3.dodge and Managers.state.network:game() then
		var_3_2:set_is_dodging(true)

		local var_3_20 = Managers.state.network
		local var_3_21 = var_3_20:unit_game_object_id(arg_3_1)

		var_3_20.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, var_3_21, 0)
	end

	if var_3_3.noclip then
		var_3_2:set_noclip(true, "lunging")
	end
end

function PlayerCharacterStateLunging.on_exit(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = arg_4_0._lunge_data
	local var_4_1 = var_4_0.first_person_animation_end_event

	if var_4_1 then
		CharacterStateHelper.play_animation_event_first_person(arg_4_0.first_person_extension, var_4_1)
	end

	local var_4_2 = var_4_0.animation_end_event

	if var_4_2 then
		if var_4_0.animation_variable_name and var_4_0.animation_variable_value then
			CharacterStateHelper.play_animation_event_with_variable_float(arg_4_1, var_4_2, var_4_0.animation_variable_name, var_4_0.animation_variable_value)
		else
			CharacterStateHelper.play_animation_event(arg_4_1, var_4_2)
		end
	end

	local var_4_3 = arg_4_0._lunge_data.lunge_events

	if var_4_3 then
		local var_4_4 = var_4_3.finished

		if var_4_4 then
			var_4_4(arg_4_0)
		end
	end

	if var_4_0.lunge_finish then
		var_4_0.lunge_finish(arg_4_1)
	end

	if var_4_0.dodge and Managers.state.network:game() then
		arg_4_0.status_extension:set_is_dodging(false)

		local var_4_5 = Managers.state.network
		local var_4_6 = var_4_5:unit_game_object_id(arg_4_1)

		var_4_5.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, var_4_6, 0)
	end

	if var_4_0.noclip then
		arg_4_0.status_extension:set_noclip(false, "lunging")
	end

	if arg_4_0._falling and arg_4_6 ~= "falling" then
		ScriptUnit.extension(arg_4_1, "whereabouts_system"):set_no_landing()
	end

	arg_4_0._lunge_data = nil
	arg_4_0._hit = nil
	arg_4_0._stop = true

	arg_4_0.first_person_extension:enable_rig_movement()
end

function PlayerCharacterStateLunging.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_1)
	local var_5_2 = arg_5_0.input_extension
	local var_5_3 = arg_5_0.status_extension
	local var_5_4 = ScriptUnit.extension(arg_5_1, "whereabouts_system")
	local var_5_5 = arg_5_0.first_person_extension
	local var_5_6 = arg_5_0.damage_start_time

	if CharacterStateHelper.is_colliding_down(arg_5_1) then
		if arg_5_0._falling then
			arg_5_0._falling = false

			var_5_4:set_landed()
		end

		var_5_4:set_is_onground()
	elseif not arg_5_0._falling then
		arg_5_0._falling = true

		var_5_4:set_fell(arg_5_0.name)
	end

	local var_5_7 = arg_5_0._lunge_data
	local var_5_8 = var_5_7.lunge_events

	if var_5_8 then
		local var_5_9 = var_5_8[1]
		local var_5_10 = arg_5_0._start_time

		while var_5_9 do
			if var_5_9.t < arg_5_5 - var_5_10 then
				var_5_9.event_function(arg_5_0)
				table.remove(var_5_8, 1)

				var_5_9 = var_5_8[1]
			else
				break
			end
		end
	end

	if CharacterStateHelper.do_common_state_transitions(var_5_3, var_5_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_5_3) then
		var_5_0:change_state("using_transport")

		return
	end

	local var_5_11 = arg_5_0.world

	if (not arg_5_0.ledge_falloff_immunity_time or arg_5_5 > arg_5_0.ledge_falloff_immunity_time) and CharacterStateHelper.is_ledge_hanging(var_5_11, arg_5_1, arg_5_0.temp_params) then
		arg_5_0._stop = true

		var_5_0:change_state("ledge_hanging", arg_5_0.temp_params)

		return
	end

	if CharacterStateHelper.is_overcharge_exploding(var_5_3) then
		var_5_0:change_state("overcharge_exploding")

		return
	end

	if CharacterStateHelper.is_pushed(var_5_3) then
		var_5_3:set_pushed(false)
	end

	if CharacterStateHelper.is_block_broken(var_5_3) then
		var_5_3:set_block_broken(false)
	end

	if not arg_5_0._stop then
		local var_5_12 = var_5_7.damage

		if var_5_12 and var_5_6 <= arg_5_5 then
			arg_5_0._stop = arg_5_0:_update_damage(arg_5_1, arg_5_3, arg_5_5, var_5_12)
		end

		local var_5_13 = Managers.input:get_service("Player")

		if var_5_13 and var_5_13:get("action_two", true) then
			local var_5_14 = var_0_0[arg_5_1]
			local var_5_15 = Quaternion.forward(var_5_5:current_rotation())

			arg_5_0:_do_blast(var_5_14, var_5_15)

			arg_5_0._stop = true
		end

		local var_5_16 = arg_5_0:_update_movement(arg_5_1, arg_5_3, arg_5_5, var_5_7)

		if var_5_16 == "ledge_hang" then
			arg_5_0._stop = true

			var_5_0:change_state("ledge_hanging", arg_5_0.temp_params)

			return
		end

		if var_5_16 == "stop" and not arg_5_0._stop then
			local var_5_17 = var_0_0[arg_5_1]
			local var_5_18 = Quaternion.forward(var_5_5:current_rotation())

			arg_5_0:_do_blast(var_5_17, var_5_18)

			arg_5_0._stop = true
		end
	end

	if arg_5_0._stop then
		if not arg_5_0.csm.state_next and arg_5_0._falling then
			var_5_0:change_state("falling", arg_5_0.temp_params)

			arg_5_0.temp_params.hit = false

			var_5_5:change_state("falling")

			return
		else
			var_5_0:change_state("walking", arg_5_0.temp_params)

			arg_5_0.temp_params.hit = false

			var_5_5:change_state("walking")

			return
		end
	end

	CharacterStateHelper.look(var_5_2, arg_5_0.player.viewport_name, var_5_5, var_5_3, arg_5_0.inventory_extension, 0.5)
	CharacterStateHelper.update_weapon_actions(arg_5_5, arg_5_1, var_5_2, arg_5_0.inventory_extension, arg_5_0.health_extension)
	arg_5_0._last_position:store(var_0_0[arg_5_1])
end

function PlayerCharacterStateLunging._update_movement(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0

	if arg_6_0._falling then
		var_6_0 = arg_6_0:_move_in_air(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	else
		var_6_0 = arg_6_0:_move_on_ground(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	end

	return var_6_0
end

function PlayerCharacterStateLunging._check_ledge_hang(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = var_0_0[arg_7_1]
	local var_7_1 = var_7_0 + arg_7_4 * arg_7_5 * arg_7_2
	local var_7_2 = Vector3.length(var_7_1 - var_7_0)
	local var_7_3 = 0.1
	local var_7_4 = var_7_2 / var_7_3
	local var_7_5 = arg_7_0.world

	arg_7_0.temp_params.z_offset = arg_7_6
	arg_7_0.temp_params.collision_filter = "filter_lunge_ledge_collision"
	arg_7_0.temp_params.radius = var_7_3 * 1.5

	for iter_7_0 = 1, var_7_4 do
		local var_7_6 = var_7_0 + arg_7_4 * (var_7_3 * iter_7_0)

		arg_7_0.temp_params.ray_position = var_7_6

		if CharacterStateHelper.will_be_ledge_hanging(var_7_5, arg_7_1, arg_7_0.temp_params) then
			return true
		end
	end

	return false
end

function PlayerCharacterStateLunging._move_on_ground(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0.locomotion_extension
	local var_8_1 = arg_8_0.first_person_extension
	local var_8_2 = arg_8_4.duration
	local var_8_3 = arg_8_3 - arg_8_0._start_time
	local var_8_4

	if arg_8_4.allow_rotation then
		local var_8_5 = Quaternion.forward(var_8_1:current_rotation())

		var_8_4 = Vector3.normalize(Vector3.flat(var_8_5))
	else
		var_8_4 = arg_8_0._direction:unbox()
	end

	local var_8_6 = arg_8_4.speed_function
	local var_8_7

	if var_8_6 then
		var_8_7 = var_8_6(var_8_3, var_8_2)
	else
		var_8_7 = math.lerp(arg_8_4.initial_speed, arg_8_4.falloff_to_speed, math.min(var_8_3 / var_8_2, 1))
	end

	local var_8_8 = 1
	local var_8_9 = var_8_8 < var_8_7
	local var_8_10 = var_8_9 and var_8_8 or var_8_7

	if arg_8_0:_check_ledge_hang(arg_8_1, arg_8_2, arg_8_3, var_8_4, var_8_7, -1.6) then
		return "ledge_hang"
	end

	var_8_0:set_wanted_velocity(var_8_4 * var_8_10)

	if var_8_9 then
		var_8_0:set_script_movement_time_scale(var_8_7 / var_8_8)
	end

	return var_8_3 < var_8_2 and "continue" or "stop"
end

function PlayerCharacterStateLunging._move_in_air(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_0.locomotion_extension
	local var_9_1 = arg_9_0.first_person_extension
	local var_9_2 = arg_9_4.duration
	local var_9_3 = arg_9_3 - arg_9_0._start_time
	local var_9_4

	if arg_9_4.allow_rotation then
		local var_9_5 = Quaternion.forward(var_9_1:current_rotation())

		var_9_4 = Vector3.normalize(Vector3.flat(var_9_5))
	else
		var_9_4 = arg_9_0._direction:unbox()
	end

	local var_9_6 = arg_9_4.speed_function
	local var_9_7

	if var_9_6 then
		var_9_7 = var_9_6(var_9_3, var_9_2)
	else
		var_9_7 = math.lerp(arg_9_4.initial_speed, arg_9_4.falloff_to_speed, math.min(var_9_3 / var_9_2, 1))
	end

	if arg_9_0:_check_ledge_hang(arg_9_1, arg_9_2, arg_9_3, var_9_4, var_9_7, -1.6) then
		return "ledge_hang"
	end

	local var_9_8 = Vector3.flat(var_9_0:current_velocity()) + var_9_4 * var_9_7
	local var_9_9 = Vector3.normalize(var_9_8)

	var_9_0:set_wanted_velocity(var_9_9 * var_9_7)

	return var_9_3 < var_9_2 and "continue" or "stop"
end

function PlayerCharacterStateLunging._parse_attack_data(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.career_extension:get_career_power_level() * arg_10_1.power_level_multiplier
	local var_10_1 = math.clamp(var_10_0, MIN_POWER_LEVEL, MAX_POWER_LEVEL)
	local var_10_2 = arg_10_1.damage_profile or "default"
	local var_10_3 = NetworkLookup.damage_profiles[var_10_2]
	local var_10_4 = arg_10_1.hit_zone_hit_name
	local var_10_5 = NetworkLookup.hit_zones[var_10_4]

	return var_10_3, var_10_1, var_10_5, arg_10_1.ignore_shield
end

function PlayerCharacterStateLunging._calculate_hit_mass(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = Managers.state.side:is_enemy(arg_11_5, arg_11_3)

	if arg_11_4 and var_11_0 and HEALTH_ALIVE[arg_11_3] then
		local var_11_1 = Managers.state.difficulty:get_difficulty_rank()
		local var_11_2 = arg_11_1 and (arg_11_4.hit_mass_counts_block and (arg_11_4.hit_mass_counts_block[var_11_1] or arg_11_4.hit_mass_counts_block[2]) or arg_11_4.hit_mass_count_block) or arg_11_4.hit_mass_counts and (arg_11_4.hit_mass_counts[var_11_1] or arg_11_4.hit_mass_counts[2]) or arg_11_4.hit_mass_count or 1
		local var_11_3 = arg_11_2.hit_mass_count

		if var_11_3 and var_11_3[arg_11_4.name] then
			var_11_2 = var_11_2 * (arg_11_2.hit_mass_count[arg_11_4.name] or 1)
		end

		arg_11_0._amount_of_mass_hit = arg_11_0._amount_of_mass_hit + var_11_2
	else
		arg_11_1 = false
	end

	return arg_11_1
end

function PlayerCharacterStateLunging._update_damage(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_4.depth_padding
	local var_12_1 = 0.5 * arg_12_4.width
	local var_12_2 = 0.5 * arg_12_4.height
	local var_12_3 = var_0_0[arg_12_1]
	local var_12_4 = arg_12_0._last_position:unbox()
	local var_12_5 = var_12_3 - var_12_4
	local var_12_6 = Vector3.length(var_12_5) * 0.5 + var_12_0
	local var_12_7 = Quaternion.look(var_12_5, Vector3.up())
	local var_12_8 = arg_12_0.first_person_extension
	local var_12_9 = Quaternion.forward(var_12_8:current_rotation())
	local var_12_10 = Vector3.flat(var_12_9)
	local var_12_11 = (var_12_3 + var_12_4) * 0.5 + Vector3(0, 0, var_12_2) + (arg_12_4.offset_forward or 0) * var_12_10
	local var_12_12 = Vector3(var_12_1, var_12_6, var_12_2)
	local var_12_13 = arg_12_4.collision_filter
	local var_12_14, var_12_15 = PhysicsWorld.immediate_overlap(arg_12_0.physics_world, "shape", "oobb", "position", var_12_11, "rotation", var_12_7, "size", var_12_12, "collision_filter", var_12_13)
	local var_12_16 = arg_12_0._hit_units
	local var_12_17 = arg_12_0.buff_extension
	local var_12_18 = Managers.state.network
	local var_12_19 = var_12_18:unit_game_object_id(arg_12_1)
	local var_12_20 = Vector3.normalize(var_12_5)
	local var_12_21 = Managers.state.entity:system("weapon_system")
	local var_12_22 = 0
	local var_12_23 = Managers.state.side

	for iter_12_0 = 1, var_12_15 do
		repeat
			local var_12_24 = var_12_14[iter_12_0]
			local var_12_25 = Actor.unit(var_12_24)

			if not var_12_16[var_12_25] then
				var_12_16[var_12_25] = true

				if not HEALTH_ALIVE[var_12_25] then
					break
				end

				if not var_12_23:is_enemy(arg_12_1, var_12_25) then
					break
				end

				local var_12_26 = Unit.get_data(var_12_25, "breed")

				if not var_12_26 then
					break
				end

				var_12_22 = var_12_22 + 1

				local var_12_27 = var_12_18:unit_game_object_id(var_12_25)
				local var_12_28 = var_0_0[var_12_25]
				local var_12_29, var_12_30, var_12_31, var_12_32 = arg_12_0:_parse_attack_data(arg_12_4)
				local var_12_33 = not var_12_32 and AiUtils.attack_is_shield_blocked(var_12_25, arg_12_1)
				local var_12_34 = arg_12_0:_calculate_hit_mass(var_12_33, arg_12_4, var_12_25, var_12_26, arg_12_1)
				local var_12_35

				if arg_12_4.stagger_angles then
					local var_12_36 = Vector3.normalize(var_12_28 - var_12_3)
					local var_12_37 = Vector3.cross(Vector3.flat(var_12_36), Vector3.flat(var_12_9))
					local var_12_38 = Math.random(arg_12_4.stagger_angles.min, arg_12_4.stagger_angles.max) * (var_12_37.z < 0 and -1 or 1)
					local var_12_39 = var_12_20

					var_12_39.x = math.cos(var_12_38) * var_12_20.x - math.sin(var_12_38) * var_12_20.y
					var_12_39.y = math.sin(var_12_38) * var_12_20.x + math.cos(var_12_38) * var_12_20.y
					var_12_35 = Vector3.normalize(var_12_39)
				else
					var_12_35 = var_12_20
				end

				local var_12_40 = "charge_ability_hit"
				local var_12_41 = NetworkLookup.damage_sources[var_12_40]
				local var_12_42
				local var_12_43 = false
				local var_12_44 = 0
				local var_12_45 = false
				local var_12_46 = true
				local var_12_47 = true

				var_12_21:send_rpc_attack_hit(var_12_41, var_12_19, var_12_27, var_12_31, var_12_28, var_12_35, var_12_29, "power_level", var_12_30, "hit_target_index", var_12_42, "blocking", var_12_34, "shield_break_procced", var_12_43, "boost_curve_multiplier", var_12_44, "is_critical_strike", var_12_45, "can_damage", var_12_46, "can_stagger", var_12_47)

				arg_12_0._num_impacts = arg_12_0._num_impacts + 1

				local var_12_48 = arg_12_0._lunge_data.lunge_events

				if var_12_48 then
					local var_12_49 = var_12_48.impact

					if var_12_49 then
						var_12_49(arg_12_0)
					end
				end

				if arg_12_0._lunge_data.first_person_hit_animation_event then
					CharacterStateHelper.play_animation_event_first_person(var_12_8, arg_12_0._lunge_data.first_person_hit_animation_event)
				end

				local var_12_50 = arg_12_0._amount_of_mass_hit >= arg_12_0.max_targets or var_12_26.armor_category == 2 or var_12_26.armor_category == 3

				if arg_12_4.interrupt_on_first_hit or var_12_50 and arg_12_4.interrupt_on_max_hit_mass then
					arg_12_0:_do_blast(var_12_3, var_12_9)

					return true
				end
			end
		until true
	end

	return false
end

local var_0_1 = {}

function PlayerCharacterStateLunging._do_blast(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._hit = true

	local var_13_0 = arg_13_0._lunge_data.damage
	local var_13_1 = var_13_0 and var_13_0.on_interrupt_blast

	if var_13_1 then
		local var_13_2 = arg_13_0.physics_world
		local var_13_3 = var_13_1.collision_filter
		local var_13_4 = Managers.state.network
		local var_13_5 = Managers.state.entity:system("weapon_system")
		local var_13_6 = arg_13_0.unit
		local var_13_7 = var_13_4:unit_game_object_id(var_13_6)
		local var_13_8 = var_13_1.radius
		local var_13_9 = arg_13_1 + arg_13_2 * var_13_8
		local var_13_10, var_13_11 = PhysicsWorld.immediate_overlap(var_13_2, "shape", "sphere", "position", var_13_9, "size", var_13_8, "collision_filter", var_13_3)
		local var_13_12 = 0
		local var_13_13 = Managers.state.side

		table.clear(var_0_1)

		for iter_13_0 = 1, var_13_11 do
			repeat
				local var_13_14 = var_13_10[iter_13_0]
				local var_13_15 = Actor.unit(var_13_14)

				if var_0_1[var_13_15] then
					break
				end

				var_0_1[var_13_15] = true

				if not Unit.get_data(var_13_15, "breed") then
					break
				end

				if not var_13_13:is_enemy(var_13_6, var_13_15) then
					break
				end

				local var_13_16, var_13_17, var_13_18, var_13_19 = arg_13_0:_parse_attack_data(var_13_1)
				local var_13_20 = var_13_4:unit_game_object_id(var_13_15)

				var_13_12 = var_13_12 + 1

				local var_13_21 = "charge_ability_hit_blast"
				local var_13_22 = NetworkLookup.damage_sources[var_13_21]
				local var_13_23 = var_0_0[var_13_15]
				local var_13_24 = Vector3.normalize(var_13_9 - var_13_23)
				local var_13_25 = 0
				local var_13_26
				local var_13_27 = not var_13_19 and AiUtils.attack_is_shield_blocked(var_13_15, var_13_6)
				local var_13_28 = false
				local var_13_29 = false
				local var_13_30 = true
				local var_13_31 = true

				var_13_5:send_rpc_attack_hit(var_13_22, var_13_7, var_13_20, var_13_18, var_13_23, var_13_24, var_13_16, "power_level", var_13_17, "hit_target_index", var_13_26, "blocking", var_13_27, "shield_break_procced", var_13_28, "boost_curve_multiplier", var_13_25, "is_critical_strike", var_13_29, "can_damage", var_13_30, "can_stagger", var_13_31)
			until true
		end
	end
end
