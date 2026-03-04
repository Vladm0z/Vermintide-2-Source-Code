-- chunkname: @scripts/settings/mutators/mutator_death.lua

return {
	description = "weaves_death_mutator_desc",
	icon = "mutator_icon_death_spirits",
	display_name = "weaves_death_mutator_name",
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
		local var_2_2 = 1

		for iter_2_0, iter_2_1 in pairs(var_2_0) do
			local var_2_3 = iter_2_1.unit

			if Unit.alive(var_2_3) then
				if iter_2_1.delay_time == 0 then
					local var_2_4 = Unit.local_position(var_2_3, 0)
					local var_2_5 = iter_2_1.follow_unit
					local var_2_6 = POSITION_LOOKUP[var_2_5]

					if var_2_6 then
						local var_2_7 = var_2_6 + Vector3.up() - var_2_4
						local var_2_8 = Vector3.length_squared(var_2_7)
						local var_2_9 = Vector3.normalize(var_2_7)

						if var_2_8 <= var_2_1 * var_2_1 then
							local var_2_10 = ScriptUnit.extension(var_2_5, "health_system")

							if var_2_10 then
								local var_2_11 = var_2_10:current_permanent_health()

								if var_2_11 > 0 then
									local var_2_12 = var_2_10:current_temporary_health()
									local var_2_13 = arg_2_1.spirit_damage
									local var_2_14

									if var_2_13 < var_2_12 + var_2_11 then
										var_2_14 = var_2_13
									else
										var_2_14 = var_2_11 - 1
									end

									DamageUtils.add_damage_network(var_2_5, var_2_3, var_2_14, "torso", "death_explosion", nil, var_2_9, "undefined", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, var_2_2)

									var_2_2 = var_2_2 + 1
								end
							end

							local var_2_15 = Unit.world_rotation(var_2_3, 0)

							Managers.state.entity:system("area_damage_system"):create_explosion(var_2_3, var_2_4, var_2_15, "death_spirit_bomb", 1, "undefined", 0, false)
							arg_2_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", var_2_3)
							Managers.state.unit_spawner:mark_for_deletion(var_2_3)

							arg_2_1.spirits[iter_2_0] = nil

							if ScorpionSeasonalSettings.current_season_id == 1 then
								local var_2_16 = "season_1"
								local var_2_17 = "weave_death_hit_by_spirit"
								local var_2_18 = Managers.player:owner(var_2_5)

								if var_2_18.local_player then
									local var_2_19 = Managers.player:statistics_db()
									local var_2_20 = Managers.player:local_player():stats_id()

									var_2_19:increment_stat(var_2_20, var_2_16, var_2_17)
								else
									local var_2_21 = NetworkLookup.statistics_group_name[var_2_16]
									local var_2_22 = NetworkLookup.statistics[var_2_17]
									local var_2_23 = var_2_18:network_id()

									Managers.state.network.network_transmit:send_rpc("rpc_increment_stat_group", var_2_23, var_2_21, var_2_22)
								end
							end
						else
							iter_2_1.chase_time = math.max(iter_2_1.chase_time - arg_2_2, 0)

							local var_2_24 = var_2_4 + var_2_9 * (arg_2_2 * arg_2_1.chase_speed)

							Unit.set_local_position(var_2_3, 0, var_2_24)

							if iter_2_1.chase_time == 0 then
								local var_2_25 = Unit.world_rotation(var_2_3, 0)

								Managers.state.entity:system("area_damage_system"):create_explosion(var_2_3, var_2_4, var_2_25, "death_spirit_bomb", 1, "undefined", 0, false)
								arg_2_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", var_2_3)
								Managers.state.unit_spawner:mark_for_deletion(var_2_3)

								arg_2_1.spirits[iter_2_0] = nil
							end
						end
					end
				else
					iter_2_1.delay_time = math.max(iter_2_1.delay_time - arg_2_2, 0)
				end
			else
				arg_2_1.spirits[iter_2_0] = nil
			end
		end
	end,
	update_player_buff = function (arg_3_0, arg_3_1)
		local var_3_0 = Managers.player:players()

		for iter_3_0, iter_3_1 in pairs(var_3_0) do
			if iter_3_1.player_unit == nil then
				return
			end

			local var_3_1 = ScriptUnit.extension(iter_3_1.player_unit, "health_system"):current_permanent_health_percent()
			local var_3_2 = ScriptUnit.has_extension(iter_3_1.player_unit, "buff_system")
			local var_3_3 = arg_3_1.network_manager:unit_game_object_id(iter_3_1.player_unit)

			if not var_3_2:has_buff_type("death_attack_speed_buff") then
				if var_3_1 < 0.2 then
					local var_3_4 = arg_3_1.buff_system:add_buff(iter_3_1.player_unit, "mutator_death_attack_speed_player_buff", iter_3_1.player_unit, true)

					arg_3_1.player_buffs[var_3_3] = var_3_4
				end
			elseif var_3_1 >= 0.2 then
				arg_3_1.buff_system:remove_server_controlled_buff(iter_3_1.player_unit, arg_3_1.player_buffs[var_3_3])

				arg_3_1.player_buffs[var_3_3] = nil
			end
		end
	end,
	server_ai_hit_by_player_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		if not DamageUtils.is_player_unit(arg_4_3) then
			return
		end

		if Unit.get_data(arg_4_2, "breed").boss then
			local var_4_0 = arg_4_1.network_manager:unit_game_object_id(arg_4_2)

			if not arg_4_1.boss_drop_timers[var_4_0] then
				arg_4_1.boss_drop_timers[var_4_0] = {
					timer = arg_4_1.boss_drop_cooldown
				}
			end

			if arg_4_1.boss_drop_timers[var_4_0].timer >= arg_4_1.boss_drop_cooldown then
				arg_4_1.template.spawn_spirit(arg_4_1, arg_4_2, arg_4_3)

				arg_4_1.boss_drop_timers[var_4_0].timer = 0
			end
		end
	end,
	server_player_hit_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		local var_5_0 = arg_5_4[2]
		local var_5_1 = DamageUtils.is_player_unit(arg_5_2)

		if var_5_0 == "death_explosion" and var_5_1 then
			local var_5_2 = arg_5_1.network_manager
			local var_5_3 = NetworkLookup.heal_types.mutator
			local var_5_4 = arg_5_4[1]
			local var_5_5 = var_5_2:unit_game_object_id(arg_5_2)

			var_5_2.network_transmit:send_rpc_server("rpc_request_heal", var_5_5, var_5_4, var_5_3)
		end
	end,
	server_ai_killed_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		if not DamageUtils.is_player_unit(arg_6_3) or not ScriptUnit.has_extension(arg_6_3, "status_system") then
			return
		end

		arg_6_1.template.spawn_spirit(arg_6_1, arg_6_2, arg_6_3)
	end,
	server_players_left_safe_zone = function (arg_7_0, arg_7_1)
		arg_7_1.has_left_safe_zone = true
	end,
	server_start_function = function (arg_8_0, arg_8_1)
		printf("[Mutator]: mutator_start")

		local var_8_0 = Managers.weave
		local var_8_1 = var_8_0:get_active_wind_settings()
		local var_8_2 = var_8_0:get_wind_strength()
		local var_8_3 = Managers.state.difficulty:get_difficulty()

		arg_8_1.spirit_damage = var_8_1.spirit_settings.damage[var_8_3][var_8_2]
		arg_8_1.delay_time = var_8_1.spirit_settings.wait_time[var_8_3][var_8_2]
		arg_8_1.chase_speed = var_8_1.spirit_settings.chase_speed[var_8_3][var_8_2]
		arg_8_1.chase_time = var_8_1.spirit_settings.chase_time[var_8_3][var_8_2]
		arg_8_1.audio_system = Managers.state.entity:system("audio_system")
		arg_8_1.network_manager = Managers.state.network
		arg_8_1.buff_system = Managers.state.entity:system("buff_system")
		arg_8_1.unit_spawner = Managers.state.unit_spawner
		arg_8_1.boss_drop_timers = {}
		arg_8_1.boss_drop_cooldown = 2
		arg_8_1.player_buffs = {}
		arg_8_1.spirits = {}
		arg_8_1.spirit_unit_name = "units/fx/vfx_animation_death_spirit_02"
		arg_8_1.extension_init_data = {}
		arg_8_1.offset = 1
	end,
	server_update_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		if not Managers.state.network or not Managers.state.network:game() then
			return
		end

		for iter_9_0, iter_9_1 in pairs(arg_9_1.boss_drop_timers) do
			iter_9_1.timer = iter_9_1.timer + arg_9_2
		end

		arg_9_1.template.update_spirits(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		arg_9_1.template.update_player_buff(arg_9_0, arg_9_1)
	end
}
