-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_lunging.lua

local var_0_0 = POSITION_LOOKUP

EnemyCharacterStateLunging = class(EnemyCharacterStateLunging, EnemyCharacterState)

function EnemyCharacterStateLunging.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "lunging")

	arg_1_0._direction = Vector3Box()
	arg_1_0._last_position = Vector3Box()
end

function EnemyCharacterStateLunging._on_enter_animation(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_3 then
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	else
		CharacterStateHelper.play_animation_event(arg_2_1, arg_2_2)
	end

	local var_2_0 = arg_2_0._first_person_extension

	CharacterStateHelper.play_animation_event_first_person(var_2_0, arg_2_5 or arg_2_2)
end

function EnemyCharacterStateLunging.on_enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_0._unit
	local var_3_1 = arg_3_0._input_extension
	local var_3_2 = arg_3_0._first_person_extension
	local var_3_3 = arg_3_0._status_extension
	local var_3_4 = var_3_3.do_lunge

	arg_3_0._lunge_data = var_3_4
	var_3_3.do_lunge = false
	arg_3_0._career_extension = ScriptUnit.extension(var_3_0, "career_system")
	arg_3_0._first_person_unit = var_3_2:get_first_person_unit()
	arg_3_0.damage_start_time = var_3_4.damage_start_time and arg_3_5 + var_3_4.damage_start_time or arg_3_5

	local var_3_5 = Quaternion.forward(arg_3_0._first_person_extension:current_rotation())

	Vector3.set_z(var_3_5, 0)

	local var_3_6 = Vector3.normalize(var_3_5)
	local var_3_7 = Quaternion.look(var_3_6, Vector3.up())

	Unit.set_local_rotation(var_3_0, 0, var_3_7)
	CharacterStateHelper.look(var_3_1, arg_3_0._player.viewport_name, var_3_2, var_3_3, arg_3_0._inventory_extension)
	arg_3_0:_on_enter_animation(var_3_0, var_3_4.animation_event, var_3_4.animation_variable_name, var_3_4.animation_variable_value, var_3_4.first_person_animation_event)

	arg_3_0._num_impacts = 0
	arg_3_0._amount_of_mass_hit = 0
	arg_3_0._hit_units = {}
	arg_3_0._start_time = arg_3_5

	arg_3_0._last_position:store(var_0_0[var_3_0])
	arg_3_0._direction:store(var_3_6)

	arg_3_0._falling = false

	local var_3_8 = var_3_4.lunge_events

	if var_3_8 then
		local var_3_9 = var_3_8.start

		if var_3_9 then
			var_3_9(arg_3_0)
		end
	end

	var_3_2:disable_rig_movement()

	local var_3_10 = var_3_4.damage

	if var_3_10 then
		local var_3_11 = arg_3_0._career_extension:get_career_power_level()
		local var_3_12 = var_3_10.power_level_multiplier
		local var_3_13 = var_3_10.damage_profile or "default"
		local var_3_14, var_3_15, var_3_16, var_3_17, var_3_18 = arg_3_0:_parse_attack_data(var_3_10)

		arg_3_0.damage_profile_id = NetworkLookup.damage_profiles[var_3_13]

		local var_3_19 = DamageProfileTemplates[var_3_13]

		arg_3_0.damage_profile = var_3_19

		local var_3_20 = Managers.state.difficulty:get_difficulty()
		local var_3_21 = ActionUtils.scale_power_levels(var_3_15, "cleave", var_3_0, var_3_20)
		local var_3_22, var_3_23 = ActionUtils.get_max_targets(var_3_19, var_3_21)

		arg_3_0.max_targets_attack = var_3_22
		arg_3_0.max_targets_impact = var_3_23
		arg_3_0.max_targets = var_3_23 < var_3_22 and var_3_22 or var_3_23
	end

	if var_3_4.dodge and Managers.state.network:game() then
		var_3_3:set_is_dodging(true)

		local var_3_24 = Managers.state.network
		local var_3_25 = var_3_24:unit_game_object_id(var_3_0)

		var_3_24.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, var_3_25, 0)
	end
end

function EnemyCharacterStateLunging.on_exit(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = arg_4_0._lunge_data
	local var_4_1 = arg_4_0._hit
	local var_4_2 = var_4_0.first_person_animation_end_event

	if var_4_2 then
		CharacterStateHelper.play_animation_event_first_person(arg_4_0._first_person_extension, var_4_2)
	end

	local var_4_3 = var_4_0.animation_end_event

	if var_4_3 then
		if var_4_0.animation_variable_name and var_4_0.animation_variable_value then
			CharacterStateHelper.play_animation_event_with_variable_float(arg_4_1, var_4_3, var_4_0.animation_variable_name, var_4_0.animation_variable_value)
		else
			CharacterStateHelper.play_animation_event(arg_4_1, var_4_3)
		end
	end

	local var_4_4 = arg_4_0._lunge_data.lunge_events

	if var_4_4 then
		local var_4_5 = var_4_4.finished

		if var_4_5 then
			var_4_5(arg_4_0)
		end
	end

	if var_4_0.lunge_finish then
		var_4_0.lunge_finish(arg_4_1)
	end

	if var_4_0.dodge and Managers.state.network:game() then
		arg_4_0._status_extension:set_is_dodging(false)

		local var_4_6 = Managers.state.network
		local var_4_7 = var_4_6:unit_game_object_id(arg_4_1)

		var_4_6.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, var_4_7, 0)
	end

	if arg_4_0._falling and arg_4_6 ~= "falling" then
		ScriptUnit.extension(arg_4_1, "whereabouts_system"):set_no_landing()
	end

	arg_4_0._lunge_data = nil
	arg_4_0._hit = nil

	arg_4_0._first_person_extension:enable_rig_movement()
end

function EnemyCharacterStateLunging.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0._csm
	local var_5_1 = arg_5_0._unit
	local var_5_2 = arg_5_0._first_person_unit
	local var_5_3 = PlayerUnitMovementSettings.get_movement_settings_table(var_5_1)
	local var_5_4 = arg_5_0._input_extension
	local var_5_5 = arg_5_0._status_extension
	local var_5_6 = ScriptUnit.extension(var_5_1, "whereabouts_system")
	local var_5_7 = arg_5_0._first_person_extension
	local var_5_8 = arg_5_0.damage_start_time
	local var_5_9 = false

	if CharacterStateHelper.is_colliding_down(var_5_1) then
		if arg_5_0._falling then
			arg_5_0._falling = false

			var_5_6:set_landed()
		end

		var_5_6:set_is_onground()
	elseif not arg_5_0._falling then
		arg_5_0._falling = true

		var_5_6:set_fell(arg_5_0.name)
	end

	local var_5_10 = arg_5_0._lunge_data
	local var_5_11 = var_5_10.lunge_events

	if var_5_11 then
		local var_5_12 = var_5_11[1]
		local var_5_13 = arg_5_0._start_time

		while var_5_12 do
			if var_5_12.t < arg_5_5 - var_5_13 then
				var_5_12.event_function(arg_5_0)
				table.remove(var_5_11, 1)

				var_5_12 = var_5_11[1]
			else
				break
			end
		end
	end

	if CharacterStateHelper.do_common_state_transitions(var_5_5, var_5_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_5_5) then
		var_5_0:change_state("using_transport")

		return
	end

	if CharacterStateHelper.is_overcharge_exploding(var_5_5) then
		var_5_0:change_state("overcharge_exploding")

		return
	end

	if CharacterStateHelper.is_pushed(var_5_5) then
		var_5_5:set_pushed(false)

		local var_5_14 = var_5_3.stun_settings.pushed

		var_5_14.hit_react_type = var_5_5:hit_react_type() .. "_push"

		var_5_0:change_state("stunned", var_5_14)

		return
	end

	if CharacterStateHelper.is_block_broken(var_5_5) then
		var_5_5:set_block_broken(false)

		local var_5_15 = var_5_3.stun_settings.parry_broken

		var_5_15.hit_react_type = "medium_push"

		var_5_0:change_state("stunned", var_5_15)

		return
	end

	if not var_5_9 then
		local var_5_16 = var_5_10.damage

		if var_5_16 and var_5_8 <= arg_5_5 then
			var_5_9 = arg_5_0:_update_damage(var_5_1, arg_5_3, arg_5_5, var_5_16)
		end

		if Managers.input:get_service("Player"):get("action_two", true) then
			local var_5_17 = var_0_0[var_5_1]
			local var_5_18 = Quaternion.forward(var_5_7:current_rotation())

			arg_5_0:_do_blast(var_5_17, var_5_18)

			var_5_9 = true
		end

		if not arg_5_0:_update_movement(var_5_1, arg_5_3, arg_5_5, var_5_10) and not var_5_9 then
			local var_5_19 = var_0_0[var_5_1]
			local var_5_20 = Quaternion.forward(var_5_7:current_rotation())

			arg_5_0:_do_blast(var_5_19, var_5_20)

			var_5_9 = true
		end
	end

	if var_5_9 then
		if not arg_5_0._csm.state_next and arg_5_0._falling then
			var_5_0:change_state("falling", arg_5_0._temp_params)

			arg_5_0._temp_params.hit = false

			var_5_7:change_state("falling")

			return
		else
			var_5_0:change_state("walking", arg_5_0._temp_params)

			arg_5_0._temp_params.hit = false

			var_5_7:change_state("walking")

			return
		end
	end

	CharacterStateHelper.look(var_5_4, arg_5_0._player.viewport_name, var_5_7, var_5_5, arg_5_0._inventory_extension, 0.5)
end

function EnemyCharacterStateLunging._update_movement(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_0._falling then
		return arg_6_0:_move_in_air(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	end

	return arg_6_0:_move_on_ground(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
end

function EnemyCharacterStateLunging._move_on_ground(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_0._locomotion_extension
	local var_7_1 = arg_7_0._first_person_extension
	local var_7_2 = arg_7_4.duration
	local var_7_3 = arg_7_3 - arg_7_0._start_time
	local var_7_4

	if arg_7_4.allow_rotation then
		local var_7_5 = Quaternion.forward(var_7_1:current_rotation())

		var_7_4 = Vector3.normalize(Vector3.flat(var_7_5))
	else
		var_7_4 = arg_7_0._direction:unbox()
	end

	local var_7_6 = arg_7_4.speed_function
	local var_7_7

	if var_7_6 then
		var_7_7 = var_7_6(var_7_3, var_7_2)
	else
		local var_7_8 = arg_7_4.initial_speed

		var_7_7 = math.lerp(arg_7_4.initial_speed, arg_7_4.falloff_to_speed, math.min(var_7_3 / var_7_2, 1))
	end

	local var_7_9 = 1

	if var_7_9 < var_7_7 then
		var_7_0:set_wanted_velocity(var_7_4 * var_7_9)
		var_7_0:set_script_movement_time_scale(var_7_7 / var_7_9)
	else
		var_7_0:set_wanted_velocity(var_7_4 * var_7_7)
	end

	return var_7_3 < var_7_2
end

function EnemyCharacterStateLunging._move_in_air(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0._locomotion_extension
	local var_8_1 = arg_8_0._first_person_extension
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
		local var_8_8 = arg_8_4.initial_speed

		var_8_7 = math.lerp(arg_8_4.initial_speed, arg_8_4.falloff_to_speed, math.min(var_8_3 / var_8_2, 1))
	end

	local var_8_9 = PlayerUnitMovementSettings.get_movement_settings_table(arg_8_1)
	local var_8_10 = Vector3.flat(var_8_0:current_velocity()) + var_8_4 * var_8_7
	local var_8_11 = Vector3.length(var_8_10)
	local var_8_12 = Vector3.normalize(var_8_10)

	var_8_0:set_wanted_velocity(var_8_12 * var_8_7)

	return var_8_3 < var_8_2
end

function EnemyCharacterStateLunging._parse_attack_data(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._career_extension:get_career_power_level() * arg_9_1.power_level_multiplier
	local var_9_1 = arg_9_1.damage_profile or "default"
	local var_9_2 = NetworkLookup.damage_profiles[var_9_1]
	local var_9_3 = arg_9_1.hit_zone_hit_name
	local var_9_4 = NetworkLookup.hit_zones[var_9_3]

	return var_9_2, var_9_0, var_9_4, arg_9_1.ignore_shield, arg_9_1.allow_backstab
end

function EnemyCharacterStateLunging._calculate_hit_mass(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if arg_10_4 and HEALTH_ALIVE[arg_10_3] then
		local var_10_0 = Managers.state.difficulty:get_difficulty_rank()
		local var_10_1 = arg_10_1 and (arg_10_4.hit_mass_counts_block and (arg_10_4.hit_mass_counts_block[var_10_0] or arg_10_4.hit_mass_counts_block[2]) or arg_10_4.hit_mass_count_block) or arg_10_4.hit_mass_counts and (arg_10_4.hit_mass_counts[var_10_0] or arg_10_4.hit_mass_counts[2]) or arg_10_4.hit_mass_count or 1
		local var_10_2 = arg_10_2.hit_mass_count

		if var_10_2 and var_10_2[arg_10_4.name] then
			var_10_1 = var_10_1 * (arg_10_2.hit_mass_count[arg_10_4.name] or 1)
		end

		arg_10_0._amount_of_mass_hit = arg_10_0._amount_of_mass_hit + var_10_1
	else
		arg_10_1 = false
	end

	return arg_10_1
end

function EnemyCharacterStateLunging._update_damage(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_4.depth_padding
	local var_11_1 = 0.5 * arg_11_4.width
	local var_11_2 = 0.5 * arg_11_4.height
	local var_11_3 = var_0_0[arg_11_1]
	local var_11_4 = arg_11_0._last_position:unbox()
	local var_11_5 = var_11_3 - var_11_4
	local var_11_6 = Vector3.length(var_11_5) * 0.5 + var_11_0
	local var_11_7 = Quaternion.look(var_11_5, Vector3.up())
	local var_11_8 = arg_11_0._first_person_extension
	local var_11_9 = Quaternion.forward(var_11_8:current_rotation())
	local var_11_10 = (var_11_3 + var_11_4) * 0.5 + Vector3(0, 0, var_11_2) + (arg_11_4.offset_forward or 0) * var_11_9
	local var_11_11 = Vector3(var_11_1, var_11_6, var_11_2)
	local var_11_12 = arg_11_4.collision_filter
	local var_11_13, var_11_14 = PhysicsWorld.immediate_overlap(arg_11_0._physics_world, "shape", "oobb", "position", var_11_10, "rotation", var_11_7, "size", var_11_11, "collision_filter", var_11_12)
	local var_11_15 = arg_11_0._hit_units
	local var_11_16 = arg_11_0._buff_extension
	local var_11_17 = Managers.state.network
	local var_11_18 = var_11_17:unit_game_object_id(arg_11_1)
	local var_11_19 = Vector3.normalize(var_11_5)
	local var_11_20 = Managers.state.entity:system("weapon_system")

	for iter_11_0 = 1, var_11_14 do
		local var_11_21 = var_11_13[iter_11_0]
		local var_11_22 = Actor.unit(var_11_21)

		if not var_11_15[var_11_22] then
			var_11_15[var_11_22] = true

			local var_11_23 = var_11_17:unit_game_object_id(var_11_22)
			local var_11_24 = var_0_0[var_11_22]
			local var_11_25 = false
			local var_11_26 = 1
			local var_11_27 = Unit.get_data(var_11_22, "breed")
			local var_11_28, var_11_29, var_11_30, var_11_31, var_11_32 = arg_11_0:_parse_attack_data(arg_11_4)

			if var_11_27 and HEALTH_ALIVE[var_11_22] then
				var_11_25 = not var_11_31 and AiUtils.attack_is_shield_blocked(var_11_22, arg_11_1)

				if var_11_32 then
					local var_11_33 = Vector3.normalize(var_11_24 - var_11_3)
					local var_11_34 = Quaternion.forward(Unit.local_rotation(var_11_22, 0))

					if Vector3.dot(var_11_34, var_11_33) >= 0.55 then
						local var_11_35 = false
						local var_11_36, var_11_37 = var_11_16:apply_buffs_to_value(var_11_26, "backstab_multiplier")
					end
				end

				var_11_25 = arg_11_0:_calculate_hit_mass(var_11_25, arg_11_4, var_11_22, var_11_27)
			else
				var_11_25 = false
			end

			if var_11_27 and HEALTH_ALIVE[var_11_22] then
				local var_11_38

				if arg_11_4.stagger_angles then
					local var_11_39 = Vector3.normalize(var_11_24 - var_11_3)
					local var_11_40 = Vector3.cross(Vector3.flat(var_11_39), Vector3.flat(var_11_9))
					local var_11_41 = Math.random(arg_11_4.stagger_angles.min, arg_11_4.stagger_angles.max) * (var_11_40.z < 0 and -1 or 1)
					local var_11_42 = var_11_19

					var_11_42.x = math.cos(var_11_41) * var_11_19.x - math.sin(var_11_41) * var_11_19.y
					var_11_42.y = math.sin(var_11_41) * var_11_19.x + math.cos(var_11_41) * var_11_19.y
					var_11_38 = Vector3.normalize(var_11_42)
				else
					var_11_38 = var_11_19
				end

				local var_11_43 = "career_ability"
				local var_11_44 = NetworkLookup.damage_sources[var_11_43]
				local var_11_45
				local var_11_46 = false
				local var_11_47 = 0
				local var_11_48 = false
				local var_11_49 = true
				local var_11_50 = true

				var_11_20:send_rpc_attack_hit(var_11_44, var_11_18, var_11_23, var_11_30, var_11_38, var_11_28, "power_level", var_11_29, "hit_target_index", var_11_45, "blocking", var_11_25, "shield_break_procced", var_11_46, "boost_curve_multiplier", var_11_47, "is_critical_strike", var_11_48, "can_damage", var_11_49, "can_stagger", var_11_50)

				arg_11_0._num_impacts = arg_11_0._num_impacts + 1

				local var_11_51 = arg_11_0._lunge_data.lunge_events

				if var_11_51 then
					local var_11_52 = var_11_51.impact

					if var_11_52 then
						var_11_52(arg_11_0)
					end
				end

				if arg_11_0._lunge_data.first_person_hit_animation_event then
					CharacterStateHelper.play_animation_event_first_person(var_11_8, arg_11_0._lunge_data.first_person_hit_animation_event)
				end

				local var_11_53 = arg_11_0._amount_of_mass_hit >= arg_11_0.max_targets or var_11_27.armor_category == 2 or var_11_27.armor_category == 3

				if HEALTH_ALIVE[var_11_22] and (arg_11_4.interrupt_on_first_hit or var_11_53 and arg_11_4.interrupt_on_max_hit_mass) then
					arg_11_0:_do_blast(var_11_3, var_11_9)

					return true
				end
			end
		end
	end

	arg_11_0._last_position:store(var_11_3)

	return false
end

local var_0_1 = {}

function EnemyCharacterStateLunging._do_blast(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0._hit = true

	local var_12_0 = arg_12_0._lunge_data.damage
	local var_12_1 = var_12_0 and var_12_0.on_interrupt_blast

	if var_12_1 then
		local var_12_2 = arg_12_0._physics_world
		local var_12_3 = var_12_1.collision_filter
		local var_12_4 = Managers.state.network
		local var_12_5 = Managers.state.entity:system("weapon_system")
		local var_12_6 = arg_12_0._unit
		local var_12_7 = var_12_4:unit_game_object_id(var_12_6)
		local var_12_8 = var_12_1.radius
		local var_12_9 = arg_12_1 + arg_12_2 * var_12_8
		local var_12_10, var_12_11 = PhysicsWorld.immediate_overlap(var_12_2, "shape", "sphere", "position", var_12_9, "size", var_12_8, "collision_filter", var_12_3)

		table.clear(var_0_1)

		for iter_12_0 = 1, var_12_11 do
			local var_12_12 = var_12_10[iter_12_0]
			local var_12_13 = Actor.unit(var_12_12)

			if not var_0_1[var_12_13] then
				var_0_1[var_12_13] = true

				if Unit.get_data(var_12_13, "breed") then
					local var_12_14, var_12_15, var_12_16, var_12_17, var_12_18 = arg_12_0:_parse_attack_data(var_12_1)
					local var_12_19 = var_12_4:unit_game_object_id(var_12_13)
					local var_12_20 = "career_ability"
					local var_12_21 = NetworkLookup.damage_sources[var_12_20]
					local var_12_22 = Vector3.normalize(var_12_9 - var_0_0[var_12_13])
					local var_12_23 = 0
					local var_12_24
					local var_12_25 = not var_12_17 and AiUtils.attack_is_shield_blocked(var_12_13, var_12_6)
					local var_12_26 = false
					local var_12_27 = false
					local var_12_28 = true
					local var_12_29 = true

					var_12_5:send_rpc_attack_hit(var_12_21, var_12_7, var_12_19, var_12_16, var_12_22, var_12_14, "power_level", var_12_15, "hit_target_index", var_12_24, "blocking", var_12_25, "shield_break_procced", var_12_26, "boost_curve_multiplier", var_12_23, "is_critical_strike", var_12_27, "can_damage", var_12_28, "can_stagger", var_12_29)
				end
			end
		end
	end
end
