-- chunkname: @scripts/settings/mutators/mutator_chasing_spirits.lua

local var_0_0 = 5

return {
	description = "chasing_spirits_mutator_desc",
	chase_time = 5,
	delay_time = 2,
	chase_speed = 1,
	spirit_power_level = 200,
	icon = "mutator_icon_death_spirits",
	display_name = "chasing_spirits_mutator_name",
	spawn_spirit = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = Vector3.add(Unit.local_position(arg_1_1, 0), Vector3(0, 0, arg_1_0.offset))
		local var_1_1 = arg_1_0.unit_spawner:spawn_network_unit(arg_1_0.spirit_unit_name, "position_synched_dummy_unit", arg_1_0.extension_init_data, var_1_0)
		local var_1_2 = {
			follow_unit = arg_1_2,
			unit = var_1_1,
			chase_time = arg_1_0.chase_time,
			delay_time = arg_1_0.delay_time
		}
		local var_1_3 = arg_1_0.network_manager:unit_game_object_id(var_1_1)

		arg_1_0.audio_system:play_audio_position_event("Play_winds_death_gameplay_spirit_release", var_1_0)
		arg_1_0.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_loop", var_1_1)

		arg_1_0.spirits[var_1_3] = var_1_2
	end,
	update_spirits = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = arg_2_1.spirits
		local var_2_1 = 1
		local var_2_2 = var_2_1 * var_2_1

		for iter_2_0, iter_2_1 in pairs(var_2_0) do
			local var_2_3 = iter_2_1 and iter_2_1.unit

			if var_2_3 and iter_2_1.delay_time == 0 then
				local var_2_4 = Unit.local_position(var_2_3, 0)
				local var_2_5 = iter_2_1.follow_unit
				local var_2_6 = POSITION_LOOKUP[var_2_5]

				if var_2_6 then
					local var_2_7 = var_2_6 + Vector3.up()
					local var_2_8 = var_2_7 - var_2_4
					local var_2_9 = Vector3.length_squared(var_2_8)
					local var_2_10 = Vector3.normalize(var_2_8)

					if var_2_9 <= var_2_2 then
						local var_2_11 = DamageProfileTemplates.death_explosion
						local var_2_12 = arg_2_1.spirit_power_level

						DamageUtils.add_damage_network_player(var_2_11, nil, var_2_12, var_2_5, var_2_3, "full", var_2_7, var_2_10, "undefined", nil, 0, false, nil, false, 0, 1)

						local var_2_13 = Unit.world_rotation(var_2_3, 0)

						Managers.state.entity:system("area_damage_system"):create_explosion(var_2_3, var_2_4, var_2_13, "death_spirit_bomb", 1, "undefined", 0, false)
						arg_2_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", var_2_3)
						Managers.state.unit_spawner:mark_for_deletion(var_2_3)

						arg_2_1.spirits[iter_2_0] = nil
					end
				end
			end
		end

		for iter_2_2, iter_2_3 in pairs(var_2_0) do
			local var_2_14 = iter_2_3.unit

			if ALIVE[var_2_14] then
				if iter_2_3.delay_time == 0 then
					local var_2_15 = Unit.local_position(var_2_14, 0)
					local var_2_16 = iter_2_3.follow_unit
					local var_2_17 = POSITION_LOOKUP[var_2_16]

					if var_2_17 then
						iter_2_3.chase_time = math.max(iter_2_3.chase_time - arg_2_2, 0)

						local var_2_18 = Unit.local_position(var_2_14, 0)
						local var_2_19 = var_2_17 + Vector3.up() - var_2_18
						local var_2_20 = var_2_18 + Vector3.normalize(var_2_19) * (arg_2_2 * arg_2_1.chase_speed)

						Unit.set_local_position(var_2_14, 0, var_2_20)

						if iter_2_3.chase_time == 0 then
							local var_2_21 = Unit.world_rotation(var_2_14, 0)

							Managers.state.entity:system("area_damage_system"):create_explosion(var_2_14, var_2_15, var_2_21, "death_spirit_bomb", 1, "undefined", 0, false)
							arg_2_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", var_2_14)
							Managers.state.unit_spawner:mark_for_deletion(var_2_14)

							arg_2_1.spirits[iter_2_2] = nil
						end
					end
				else
					iter_2_3.delay_time = math.max(iter_2_3.delay_time - arg_2_2, 0)
				end
			else
				arg_2_1.spirits[iter_2_2] = nil
			end
		end
	end,
	server_ai_hit_by_player_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		if not arg_3_1.can_spawn then
			return
		end

		if not DamageUtils.is_player_unit(arg_3_3) then
			return
		end

		if Unit.get_data(arg_3_2, "breed").boss then
			local var_3_0 = arg_3_1.network_manager:unit_game_object_id(arg_3_2)

			if not arg_3_1.boss_drop_timers[var_3_0] then
				arg_3_1.boss_drop_timers[var_3_0] = {
					timer = arg_3_1.boss_drop_cooldown
				}
			end

			if arg_3_1.boss_drop_timers[var_3_0].timer >= arg_3_1.boss_drop_cooldown then
				arg_3_1.template.spawn_spirit(arg_3_1, arg_3_2, arg_3_3)

				arg_3_1.boss_drop_timers[var_3_0].timer = 0
			end
		end
	end,
	server_player_hit_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = arg_4_4[2]
		local var_4_1 = DamageUtils.is_player_unit(arg_4_2)

		if var_4_0 == "death_explosion" and var_4_1 then
			local var_4_2 = arg_4_1.network_manager
			local var_4_3 = NetworkLookup.heal_types.mutator
			local var_4_4 = arg_4_4[1]
			local var_4_5 = var_4_2:unit_game_object_id(arg_4_2)

			var_4_2.network_transmit:send_rpc_server("rpc_request_heal", var_4_5, var_4_4, var_4_3)
		end
	end,
	server_ai_killed_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		if not arg_5_1.can_spawn then
			return
		end

		if not DamageUtils.is_player_unit(arg_5_3) then
			return
		end

		arg_5_1.template.spawn_spirit(arg_5_1, arg_5_2, arg_5_3)
	end,
	server_players_left_safe_zone = function (arg_6_0, arg_6_1)
		arg_6_1.has_left_safe_zone = true
	end,
	server_start_function = function (arg_7_0, arg_7_1)
		printf("[Mutator]: mutator_start")

		arg_7_1.spirit_power_level = arg_7_1.template.spirit_power_level
		arg_7_1.delay_time = arg_7_1.template.delay_time
		arg_7_1.chase_speed = arg_7_1.template.chase_speed
		arg_7_1.chase_time = arg_7_1.template.chase_time
		arg_7_1.audio_system = Managers.state.entity:system("audio_system")
		arg_7_1.network_manager = Managers.state.network
		arg_7_1.unit_spawner = Managers.state.unit_spawner
		arg_7_1.boss_drop_timers = {}
		arg_7_1.boss_drop_cooldown = 2
		arg_7_1.spirits = {}
		arg_7_1.spirit_unit_name = "units/fx/vfx_animation_death_spirit_02"
		arg_7_1.extension_init_data = {}
		arg_7_1.offset = 1
		arg_7_1.can_spawn = true
	end,
	server_stop_function = function (arg_8_0, arg_8_1)
		local var_8_0 = arg_8_1.spirits

		for iter_8_0, iter_8_1 in pairs(var_8_0) do
			local var_8_1 = iter_8_1.unit

			if ALIVE[var_8_1] then
				local var_8_2 = Unit.local_position(var_8_1, 0)
				local var_8_3 = Unit.world_rotation(var_8_1, 0)

				Managers.state.entity:system("area_damage_system"):create_explosion(var_8_1, var_8_2, var_8_3, "death_spirit_bomb", 1, "undefined", 0, false)
				arg_8_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", var_8_1)
				Managers.state.unit_spawner:mark_for_deletion(var_8_1)

				arg_8_1.spirits[iter_8_0] = nil
			end
		end
	end,
	server_update_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		if not Managers.state.network or not Managers.state.network:game() then
			return
		end

		for iter_9_0, iter_9_1 in pairs(arg_9_1.boss_drop_timers) do
			iter_9_1.timer = iter_9_1.timer + arg_9_2
		end

		if arg_9_1.can_spawn and arg_9_3 >= arg_9_1.deactivate_at_t - 5 then
			arg_9_1.can_spawn = false
		end

		arg_9_1.template.update_spirits(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	end
}
