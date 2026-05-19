-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_overcharge_exploding.lua

PlayerCharacterStateOverchargeExploding = class(PlayerCharacterStateOverchargeExploding, PlayerCharacterState)

function PlayerCharacterStateOverchargeExploding.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "overcharge_exploding")

	arg_1_0.movement_speed = 0
	arg_1_0.movement_speed_limit = 1
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
	arg_1_0.inside_inn = global_is_inside_inn
end

function PlayerCharacterStateOverchargeExploding.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "exploding")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "exploding")

	local var_2_0 = arg_2_0.input_extension
	local var_2_1 = arg_2_0.first_person_extension
	local var_2_2 = arg_2_0.status_extension

	arg_2_0.damage_timer = arg_2_5 + 0.5
	arg_2_0.movement_speed = 0.2

	local var_2_3, var_2_4 = CharacterStateHelper.get_move_animation(arg_2_0.locomotion_extension, var_2_0, var_2_2)

	arg_2_0.move_anim_3p = var_2_3

	CharacterStateHelper.play_animation_event(arg_2_1, "explode_start")
	CharacterStateHelper.play_animation_event_first_person(var_2_1, "explode_start")
	arg_2_0.last_input_direction:store(Vector3.zero())

	arg_2_0.has_exploded = false

	local var_2_5 = ScriptUnit.extension(arg_2_1, "overcharge_system")

	arg_2_0.explosion_template = var_2_5.explosion_template
	arg_2_0.no_forced_movement = var_2_5.no_forced_movement
	arg_2_0.no_explosion = var_2_5.no_explosion
	arg_2_0.explosion_time = arg_2_5 + (var_2_5.overcharge_explosion_time or 3)
	arg_2_0.percent_health_lost = var_2_5.percent_health_lost
	arg_2_0._explode_vfx_name = var_2_5.explode_vfx_name
	arg_2_0.walking = false
	arg_2_0.falling = false
end

function PlayerCharacterStateOverchargeExploding.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	if not Managers.state.network:game() or not arg_3_6 then
		return
	end

	CharacterStateHelper.play_animation_event(arg_3_1, "cooldown_end")
	CharacterStateHelper.play_animation_event_first_person(arg_3_0.first_person_extension, "cooldown_end")

	local var_3_0 = ScriptUnit.extension(arg_3_1, "career_system")
	local var_3_1 = var_3_0:career_name()

	if not arg_3_0.has_exploded and (var_3_1 ~= "bw_unchained" or var_3_0:get_state() ~= "sienna_activate_unchained") then
		arg_3_0:explode()
	end

	if arg_3_0.falling and arg_3_6 ~= "falling" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end
end

function PlayerCharacterStateOverchargeExploding.explode(arg_4_0)
	arg_4_0.has_exploded = true

	local var_4_0 = arg_4_0.unit

	StatusUtils.set_overcharge_exploding(var_4_0, false)

	local var_4_1 = ScriptUnit.extension(var_4_0, "overcharge_system")

	if var_4_1.lockout_overcharge_decay_rate then
		var_4_1:set_lockout(true)
	else
		var_4_1:reset()
	end

	if not arg_4_0.inside_inn and not arg_4_0.status_extension:is_knocked_down() then
		local var_4_2 = ScriptUnit.extension(var_4_0, "health_system"):get_max_health() * (arg_4_0.percent_health_lost or 1)
		local var_4_3, var_4_4 = ScriptUnit.extension(var_4_0, "buff_system"):apply_buffs_to_value(0, "overcharge_damage_immunity")

		if not var_4_4 then
			DamageUtils.add_damage_network(var_4_0, var_4_0, var_4_2, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, var_4_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end

	local var_4_5 = POSITION_LOOKUP[var_4_0] + Vector3(0, 1.5, 0)
	local var_4_6 = Unit.local_rotation(var_4_0, 0)
	local var_4_7 = arg_4_0.explosion_template
	local var_4_8 = 1

	if not arg_4_0.no_explosion then
		Managers.state.entity:system("area_damage_system"):create_explosion(var_4_0, var_4_5, var_4_6, var_4_7, var_4_8, "overcharge", nil, false)
	end

	if arg_4_0._explode_vfx_name then
		local var_4_9 = arg_4_0._explode_vfx_name
		local var_4_10 = NetworkLookup.effects[var_4_9]
		local var_4_11 = NetworkConstants.invalid_game_object_id
		local var_4_12 = 0

		Managers.state.event:trigger("event_play_particle_effect", var_4_9, nil, var_4_12, POSITION_LOOKUP[var_4_0], var_4_6, false)

		local var_4_13 = Managers.state.network.network_transmit

		if Managers.player.is_server then
			var_4_13:send_rpc_clients("rpc_play_particle_effect", var_4_10, var_4_11, var_4_12, POSITION_LOOKUP[var_4_0], var_4_6, false)
		else
			var_4_13:send_rpc_server("rpc_play_particle_effect", var_4_10, var_4_11, var_4_12, POSITION_LOOKUP[var_4_0], var_4_6, false)
		end
	end
end

function PlayerCharacterStateOverchargeExploding.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.world
	local var_5_2 = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_1)
	local var_5_3 = arg_5_0.input_extension
	local var_5_4 = arg_5_0.status_extension
	local var_5_5 = arg_5_0.locomotion_extension
	local var_5_6 = ScriptUnit.extension(arg_5_1, "whereabouts_system")
	local var_5_7 = arg_5_0.first_person_extension

	if var_5_5:is_on_ground() then
		if arg_5_0.falling then
			arg_5_0.falling = false

			var_5_6:set_landed()
		end

		var_5_6:set_is_onground()
	elseif not arg_5_0.falling then
		arg_5_0.falling = true

		var_5_6:set_fell()
	end

	if CharacterStateHelper.do_common_state_transitions(var_5_4, var_5_0) then
		return
	end

	local var_5_8 = arg_5_0.temp_params

	if arg_5_5 >= arg_5_0.explosion_time and not arg_5_0.has_exploded or not var_5_4:is_overcharge_exploding() then
		if var_5_4:is_overcharge_exploding() then
			arg_5_0:explode()
		end

		if var_5_5:is_on_ground() then
			if CharacterStateHelper.has_move_input(var_5_3) then
				var_5_0:change_state("walking", var_5_8)
				var_5_7:change_state("walking")
			else
				var_5_0:change_state("standing", var_5_8)
				var_5_7:change_state("standing")
			end
		else
			var_5_0:change_state("falling", var_5_8)
			var_5_7:change_state("falling")
		end

		return
	end

	if arg_5_5 > arg_5_0.damage_timer then
		arg_5_0.damage_timer = arg_5_5 + 0.5

		if not arg_5_0.inside_inn then
			DamageUtils.add_damage_network(arg_5_1, arg_5_1, 10, "torso", "overcharge", nil, Vector3(0, 0, 1), "overcharge", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "overcharge_rumble_crit"
		})

		local var_5_9 = ScriptUnit.extension(arg_5_1, "locomotion_system")
		local var_5_10 = Vector3.normalize(Vector3(2 * (math.random() - 0.5), 2 * (math.random() - 0.5), 0))

		var_5_9:add_external_velocity(var_5_10, 10)

		arg_5_0.movement_speed = math.random() * 0.5 + 0.15
		arg_5_0.movement_speed_limit = arg_5_0.movement_speed

		var_5_7:animation_event("overheat_indicator")
	end

	if arg_5_0.no_forced_movement then
		return
	end

	local var_5_11 = Managers.player:owner(arg_5_1)

	if CharacterStateHelper.has_move_input(var_5_3) then
		arg_5_0.movement_speed = math.min(1, arg_5_0.movement_speed + var_5_2.move_acceleration_up * arg_5_3)
	elseif var_5_11 and var_5_11.bot_player then
		arg_5_0.movement_speed = 0
	else
		arg_5_0.movement_speed = math.max(arg_5_0.movement_speed_limit, arg_5_0.movement_speed - var_5_2.move_acceleration_down * arg_5_3)
	end

	local var_5_12 = var_5_3:get("walk")
	local var_5_13 = var_5_4:is_crouching() and var_5_2.crouch_move_speed or var_5_12 and var_5_2.walk_move_speed or var_5_2.move_speed
	local var_5_14 = var_5_4:current_move_speed_multiplier()

	if var_5_12 ~= arg_5_0.walking then
		var_5_4:set_slowed(var_5_12)
	end

	local var_5_15 = var_5_13 * var_5_14 * var_5_2.player_speed_scale * arg_5_0.movement_speed
	local var_5_16 = Vector3(0, 0.9, 0)
	local var_5_17 = var_5_3:get("move")

	if var_5_17 then
		var_5_16 = var_5_16 + var_5_17
	end

	local var_5_18 = var_5_3:get("move_controller")

	if var_5_18 then
		local var_5_19 = Vector3.length(var_5_18)

		if var_5_19 > 0 then
			var_5_15 = var_5_15 * var_5_19
		end

		var_5_16 = var_5_16 + var_5_18
	end

	local var_5_20
	local var_5_21 = Vector3.normalize(var_5_16)

	if Vector3.length(var_5_21) == 0 then
		var_5_21 = arg_5_0.last_input_direction:unbox()
	else
		arg_5_0.last_input_direction:store(var_5_21)
	end

	CharacterStateHelper.move_on_ground(var_5_7, var_5_3, var_5_5, var_5_21, var_5_15, arg_5_1)
	CharacterStateHelper.look(var_5_3, arg_5_0.player.viewport_name, var_5_7, var_5_4, arg_5_0.inventory_extension)

	local var_5_22, var_5_23 = CharacterStateHelper.get_move_animation(var_5_5, var_5_3, var_5_4, arg_5_0.move_anim_3p)

	if var_5_22 ~= arg_5_0.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_5_1, var_5_22)

		arg_5_0.move_anim_3p = var_5_22
	end

	arg_5_0.walking = var_5_12
end
