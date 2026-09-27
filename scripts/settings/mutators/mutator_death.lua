-- chunkname: @scripts/settings/mutators/mutator_death.lua

return {
	description = "weaves_death_mutator_desc",
	icon = "mutator_icon_death_spirits",
	display_name = "weaves_death_mutator_name",
	spawn_spirit = function (self, arg_1_1, arg_1_2)
		-- function 1
		local add = Vector3.add(Unit.local_position(arg_1_1, 0), Vector3(0, 0, self.offset))
		local spawn_network_unit = self.unit_spawner:spawn_network_unit(self.spirit_unit_name, "position_synched_dummy_unit", self.extension_init_data, add)
		local tbl = {
			follow_unit = arg_1_2,
			unit = spawn_network_unit,
			chase_time = self.chase_time,
			delay_time = self.delay_time
		}
		local unit_game_object_id = self.network_manager:unit_game_object_id(spawn_network_unit)

		self.audio_system:play_audio_position_event("Play_winds_death_gameplay_spirit_release", add)
		self.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_loop", spawn_network_unit)

		self.spirits[unit_game_object_id] = tbl
	end,
	update_spirits = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local spirits = arg_2_1.spirits
		local num = 1
		local num_2 = 1

		for k, v in pairs(spirits) do
			local unit = v.unit

			if not Unit.alive(unit) then
				if v.delay_time == 0 then
					local local_position = Unit.local_position(unit, 0)
					local follow_unit = v.follow_unit
					local var_2_6 = POSITION_LOOKUP[follow_unit]

					if not var_2_6 then
						local num_3 = var_2_6 + Vector3.up() - local_position
						local length_squared = Vector3.length_squared(num_3)
						local normalize = Vector3.normalize(num_3)

						if length_squared <= num * num then
							local extension = ScriptUnit.extension(follow_unit, "health_system")

							if not extension then
								local current_permanent_health = extension:current_permanent_health()

								if current_permanent_health > 0 then
									local current_temporary_health = extension:current_temporary_health()
									local spirit_damage = arg_2_1.spirit_damage
									local var_2_14

									if spirit_damage < current_temporary_health + current_permanent_health then
										var_2_14 = spirit_damage
									else
										var_2_14 = current_permanent_health - 1
									end

									DamageUtils.add_damage_network(follow_unit, unit, var_2_14, "torso", "death_explosion", nil, normalize, "undefined", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, num_2)

									num_2 = num_2 + 1
								end
							end

							local world_rotation = Unit.world_rotation(unit, 0)

							Managers.state.entity:system("area_damage_system"):create_explosion(unit, local_position, world_rotation, "death_spirit_bomb", 1, "undefined", 0, false)
							arg_2_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", unit)
							Managers.state.unit_spawner:mark_for_deletion(unit)

							arg_2_1.spirits[k] = nil

							if ScorpionSeasonalSettings.current_season_id == 1 then
								local str = "season_1"
								local str_2 = "weave_death_hit_by_spirit"
								local owner = Managers.player:owner(follow_unit)

								if not owner.local_player then
									local statistics_db = Managers.player:statistics_db()
									local stats_id = Managers.player:local_player():stats_id()

									statistics_db:increment_stat(stats_id, str, str_2)
								else
									local var_2_21 = NetworkLookup.statistics_group_name[str]
									local var_2_22 = NetworkLookup.statistics[str_2]
									local network_id = owner:network_id()

									Managers.state.network.network_transmit:send_rpc("rpc_increment_stat_group", network_id, var_2_21, var_2_22)
								end
							end
						else
							v.chase_time = math.max(v.chase_time - arg_2_2, 0)

							local num_4 = local_position + normalize * (arg_2_2 * arg_2_1.chase_speed)

							Unit.set_local_position(unit, 0, num_4)

							if v.chase_time == 0 then
								local world_rotation_2 = Unit.world_rotation(unit, 0)

								Managers.state.entity:system("area_damage_system"):create_explosion(unit, local_position, world_rotation_2, "death_spirit_bomb", 1, "undefined", 0, false)
								arg_2_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", unit)
								Managers.state.unit_spawner:mark_for_deletion(unit)

								arg_2_1.spirits[k] = nil
							end
						end
					end
				else
					v.delay_time = math.max(v.delay_time - arg_2_2, 0)
				end
			else
				arg_2_1.spirits[k] = nil
			end
		end
	end,
	update_player_buff = function (arg_3_0, arg_3_1)
		-- function 3
		local players = Managers.player:players()

		for k, v in pairs(players) do
			if v.player_unit == nil then
				return
			end

			local current_permanent_health_percent = ScriptUnit.extension(v.player_unit, "health_system"):current_permanent_health_percent()
			local has_extension = ScriptUnit.has_extension(v.player_unit, "buff_system")
			local unit_game_object_id = arg_3_1.network_manager:unit_game_object_id(v.player_unit)

			if not has_extension:has_buff_type("death_attack_speed_buff") then
				if current_permanent_health_percent < 0.2 then
					local add_buff = arg_3_1.buff_system:add_buff(v.player_unit, "mutator_death_attack_speed_player_buff", v.player_unit, true)

					arg_3_1.player_buffs[unit_game_object_id] = add_buff
				end
			elseif current_permanent_health_percent >= 0.2 then
				arg_3_1.buff_system:remove_server_controlled_buff(v.player_unit, arg_3_1.player_buffs[unit_game_object_id])

				arg_3_1.player_buffs[unit_game_object_id] = nil
			end
		end
	end,
	server_ai_hit_by_player_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		if not DamageUtils.is_player_unit(arg_4_3) then
			return
		end

		if not Unit.get_data(arg_4_2, "breed").boss then
			local unit_game_object_id = arg_4_1.network_manager:unit_game_object_id(arg_4_2)

			if not arg_4_1.boss_drop_timers[unit_game_object_id] then
				arg_4_1.boss_drop_timers[unit_game_object_id] = {
					timer = arg_4_1.boss_drop_cooldown
				}
			end

			if arg_4_1.boss_drop_timers[unit_game_object_id].timer >= arg_4_1.boss_drop_cooldown then
				arg_4_1.template.spawn_spirit(arg_4_1, arg_4_2, arg_4_3)

				arg_4_1.boss_drop_timers[unit_game_object_id].timer = 0
			end
		end
	end,
	server_player_hit_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		local var_5_0 = arg_5_4[2]
		local is_player_unit = DamageUtils.is_player_unit(arg_5_2)

		if var_5_0 ~= "death_explosion" or not is_player_unit then
			local network_manager = arg_5_1.network_manager
			local mutator = NetworkLookup.heal_types.mutator
			local var_5_4 = arg_5_4[1]
			local unit_game_object_id = network_manager:unit_game_object_id(arg_5_2)

			network_manager.network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, var_5_4, mutator)
		end
	end,
	server_ai_killed_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		if not (not DamageUtils.is_player_unit(arg_6_3) and ScriptUnit.has_extension(arg_6_3, "status_system")) then
			return
		end

		arg_6_1.template.spawn_spirit(arg_6_1, arg_6_2, arg_6_3)
	end,
	server_players_left_safe_zone = function (arg_7_0, arg_7_1)
		-- function 7
		arg_7_1.has_left_safe_zone = true
	end,
	server_start_function = function (arg_8_0, arg_8_1)
		-- function 8
		printf("[Mutator]: mutator_start")

		local weave = Managers.weave
		local get_active_wind_settings = weave:get_active_wind_settings()
		local get_wind_strength = weave:get_wind_strength()
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_8_1.spirit_damage = get_active_wind_settings.spirit_settings.damage[get_difficulty][get_wind_strength]
		arg_8_1.delay_time = get_active_wind_settings.spirit_settings.wait_time[get_difficulty][get_wind_strength]
		arg_8_1.chase_speed = get_active_wind_settings.spirit_settings.chase_speed[get_difficulty][get_wind_strength]
		arg_8_1.chase_time = get_active_wind_settings.spirit_settings.chase_time[get_difficulty][get_wind_strength]
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
		-- function 9
		if not (not Managers.state.network and Managers.state.network:game()) then
			return
		end

		for k, v in pairs(arg_9_1.boss_drop_timers) do
			v.timer = v.timer + arg_9_2
		end

		arg_9_1.template.update_spirits(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		arg_9_1.template.update_player_buff(arg_9_0, arg_9_1)
	end
}
