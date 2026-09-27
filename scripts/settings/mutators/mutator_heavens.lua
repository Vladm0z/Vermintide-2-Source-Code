-- chunkname: @scripts/settings/mutators/mutator_heavens.lua

return {
	description = "weaves_heavens_mutator_desc",
	display_name = "weaves_heavens_mutator_name",
	icon = "mutator_icon_heavens_lightning",
	spawn_lightning_strike_unit = function (self)
		-- function 1
		table.clear(self.units)

		for k, v in pairs(Managers.player:players()) do
			local player_unit = v.player_unit

			if not Unit.alive(player_unit) then
				self.extension_init_data.area_damage_system.follow_unit = player_unit

				local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(self.decal_unit_name, "timed_explosion_unit", self.extension_init_data, Unit.local_position(player_unit, 0))
				local side = Managers.state.side
				local side_id = side:get_side_from_name("neutral").side_id

				side:add_unit_to_side(spawn_network_unit, side_id)
				self.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_spawn", spawn_network_unit)

				self.units[#self.units + 1] = spawn_network_unit
			end

			self.lock_played = false
			self.charge_played = false
			self.hit_played = false
			self.bots_alerted = false
		end
	end,
	server_start_function = function (arg_2_0, arg_2_1)
		-- function 2
		local get_wind_strength = Managers.weave:get_wind_strength()

		get_wind_strength = get_wind_strength or 1

		local get_active_wind_settings = Managers.weave:get_active_wind_settings()
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_2_1.follow_time = get_active_wind_settings.timed_explosion_extension_settings.follow_time[get_difficulty][get_wind_strength]
		arg_2_1.time_to_explode = get_active_wind_settings.timed_explosion_extension_settings.time_to_explode[get_difficulty][get_wind_strength]
		arg_2_1.spawn_rate = get_active_wind_settings.spawn_rate[get_difficulty][get_wind_strength]
		arg_2_1.last_spawn_time = nil
		arg_2_1.initial_spawn_delay = 5
		arg_2_1.units = {}
		arg_2_1.decal_unit_name = "units/decals/decal_heavens_01"
		arg_2_1.audio_system = Managers.state.entity:system("audio_system")
		arg_2_1.extension_init_data = {
			area_damage_system = {
				explosion_template_name = "lightning_strike"
			}
		}
		arg_2_1.boss_lightning_challenge = {}
		arg_2_1.boss_lightning_challenge_counter = 0

		local system = Managers.state.entity:system("ai_system")

		arg_2_1.ai_system = system

		local _nav_cost_map_id = arg_2_1._nav_cost_map_id

		_nav_cost_map_id = _nav_cost_map_id or system:create_nav_cost_map("mutator_heavens_zone", 4)
		arg_2_1._nav_cost_map_id = _nav_cost_map_id
		arg_2_1._nav_cost_volume_ids = {}
		arg_2_1._nav_cost_radius = get_active_wind_settings.radius[get_difficulty][get_wind_strength]
	end,
	server_stop_function = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		arg_3_1._nav_cost_map_id = nil
	end,
	server_ai_killed_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
		-- function 4
		if ScorpionSeasonalSettings.current_season_id == 1 then
			if not (arg_4_1.boss_lightning_challenge_counter > 0) or not arg_4_1.boss_lightning_challenge[arg_4_2] then
				local str = "season_1"
				local str_2 = "scorpion_weaves_heavens_season_1"
				local var_4_2 = NetworkLookup.statistics_group_name[str]
				local var_4_3 = NetworkLookup.statistics[str_2]
				local statistics_db = Managers.player:statistics_db()
				local stats_id = Managers.player:local_player():stats_id()

				statistics_db:increment_stat(stats_id, str, str_2)

				arg_4_1.boss_lightning_challenge_counter = 0

				Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat_group", var_4_2, var_4_3)
			end
		else
			arg_4_1.boss_lightning_challenge_counter = 0
		end
	end,
	server_ai_hit_by_player_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		if not (arg_5_1.boss_lightning_challenge_counter > 0) or not arg_5_1.boss_lightning_challenge[arg_5_2] then
			local is_player_unit = Managers.player:is_player_unit(arg_5_3)
			local var_5_1 = arg_5_4[DamageDataIndex.DAMAGE_AMOUNT]

			if not (not is_player_unit and not (var_5_1 > 0)) then
				arg_5_1.boss_lightning_challenge[arg_5_2] = nil
				arg_5_1.boss_lightning_challenge_counter = arg_5_1.boss_lightning_challenge_counter - 1
			end
		end
	end,
	server_ai_spawned_function = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		local alive_bosses = Managers.state.conflict:alive_bosses()

		if not alive_bosses and not (#alive_bosses > arg_6_1.boss_lightning_challenge_counter) or not BLACKBOARDS[arg_6_2].breed.boss then
			arg_6_1.boss_lightning_challenge[arg_6_2] = true
			arg_6_1.boss_lightning_challenge_counter = arg_6_1.boss_lightning_challenge_counter + 1
		end
	end,
	server_players_left_safe_zone = function (arg_7_0, arg_7_1)
		-- function 7
		arg_7_1.has_left_safe_zone = true
	end,
	server_update_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		-- function 8
		if not (not Managers.state.network and Managers.state.network:game()) then
			return
		end

		if not arg_8_1.has_left_safe_zone then
			return
		end

		local template = arg_8_1.template
		local last_spawn_time = arg_8_1.last_spawn_time
		local spawn_rate = arg_8_1.spawn_rate

		if #arg_8_1.units > 0 then
			if not arg_8_1.lock_played then
				if arg_8_3 > last_spawn_time + arg_8_1.follow_time then
					arg_8_1.lock_played = true

					for i = 1, #arg_8_1.units do
						local var_8_3 = arg_8_1.units[i]

						if not Unit.alive(var_8_3) then
							arg_8_1.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_lock", var_8_3)

							if not arg_8_1._nav_cost_map_id then
								local var_8_4 = POSITION_LOOKUP[var_8_3]
								local add_nav_cost_map_sphere_volume = arg_8_1.ai_system:add_nav_cost_map_sphere_volume(var_8_4, arg_8_1._nav_cost_radius, arg_8_1._nav_cost_map_id)

								table.insert(arg_8_1._nav_cost_volume_ids, add_nav_cost_map_sphere_volume)
							end
						end
					end
				end
			elseif arg_8_3 < last_spawn_time + arg_8_1.follow_time + arg_8_1.time_to_explode then
				if not (not (arg_8_3 > last_spawn_time + arg_8_1.follow_time + arg_8_1.time_to_explode - 3) or arg_8_1.bots_alerted) then
					local var_8_6 = Vector3(0, arg_8_1._nav_cost_radius, arg_8_1._nav_cost_radius * 0.5)
					local system = Managers.state.entity:system("ai_bot_group_system")

					for j = 1, #arg_8_1.units do
						local var_8_8 = arg_8_1.units[j]

						if not Unit.alive(var_8_8) then
							local var_8_9 = POSITION_LOOKUP[var_8_8]

							system:aoe_threat_created(var_8_9, "cylinder", var_8_6, nil, 3, "Heavens")
						end
					end

					arg_8_1.bots_alerted = true
				end

				if arg_8_3 > last_spawn_time + arg_8_1.follow_time + arg_8_1.time_to_explode - 1.5 then
					if not arg_8_1.charge_played then
						arg_8_1.charge_played = true

						for k = 1, #arg_8_1.units do
							local var_8_10 = arg_8_1.units[k]

							if not Unit.alive(var_8_10) then
								arg_8_1.audio_system:play_audio_unit_event("Play_winds_heavens_gamepay_charge", var_8_10)
							end
						end
					end

					local num = 100 - math.abs(last_spawn_time + arg_8_1.follow_time + arg_8_1.time_to_explode - arg_8_3) / 1.5 * 100
					local players = Managers.player:players()

					for k_2, v in pairs(players) do
						Managers.state.network.network_transmit:send_rpc("rpc_client_audio_set_global_parameter", v.peer_id, 6, num)
					end
				end
			elseif not (arg_8_1.hit_played or not (arg_8_3 > last_spawn_time + arg_8_1.follow_time + arg_8_1.time_to_explode)) then
				arg_8_1.hit_played = true

				for i5 = 1, #arg_8_1.units do
					local var_8_13 = arg_8_1.units[i5]

					if not Unit.alive(var_8_13) then
						arg_8_1.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_hit", var_8_13)
					end
				end

				for i6 = 1, #arg_8_1._nav_cost_volume_ids do
					local var_8_14 = arg_8_1._nav_cost_volume_ids[i6]

					arg_8_1.ai_system:remove_nav_cost_map_volume(var_8_14, arg_8_1._nav_cost_map_id)
				end

				table.clear(arg_8_1._nav_cost_volume_ids)
			end
		end

		if not (not last_spawn_time and not (arg_8_3 > last_spawn_time + spawn_rate)) then
			template.spawn_lightning_strike_unit(arg_8_1)

			arg_8_1.last_spawn_time = arg_8_3
		elseif last_spawn_time == nil then
			arg_8_1.last_spawn_time = arg_8_3 + arg_8_1.initial_spawn_delay - spawn_rate
		end
	end
}
