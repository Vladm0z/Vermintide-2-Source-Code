-- chunkname: @scripts/settings/mutators/mutator_heavens.lua

return {
	description = "weaves_heavens_mutator_desc",
	display_name = "weaves_heavens_mutator_name",
	icon = "mutator_icon_heavens_lightning",
	spawn_lightning_strike_unit = function (arg_1_0)
		table.clear(arg_1_0.units)

		for iter_1_0, iter_1_1 in pairs(Managers.player:players()) do
			local var_1_0 = iter_1_1.player_unit

			if Unit.alive(var_1_0) then
				arg_1_0.extension_init_data.area_damage_system.follow_unit = var_1_0

				local var_1_1 = Managers.state.unit_spawner:spawn_network_unit(arg_1_0.decal_unit_name, "timed_explosion_unit", arg_1_0.extension_init_data, Unit.local_position(var_1_0, 0))
				local var_1_2 = Managers.state.side
				local var_1_3 = var_1_2:get_side_from_name("neutral").side_id

				var_1_2:add_unit_to_side(var_1_1, var_1_3)
				arg_1_0.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_spawn", var_1_1)

				arg_1_0.units[#arg_1_0.units + 1] = var_1_1
			end

			arg_1_0.lock_played = false
			arg_1_0.charge_played = false
			arg_1_0.hit_played = false
			arg_1_0.bots_alerted = false
		end
	end,
	server_start_function = function (arg_2_0, arg_2_1)
		local var_2_0 = Managers.weave:get_wind_strength() or 1
		local var_2_1 = Managers.weave:get_active_wind_settings()
		local var_2_2 = Managers.state.difficulty:get_difficulty()

		arg_2_1.follow_time = var_2_1.timed_explosion_extension_settings.follow_time[var_2_2][var_2_0]
		arg_2_1.time_to_explode = var_2_1.timed_explosion_extension_settings.time_to_explode[var_2_2][var_2_0]
		arg_2_1.spawn_rate = var_2_1.spawn_rate[var_2_2][var_2_0]
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

		local var_2_3 = Managers.state.entity:system("ai_system")

		arg_2_1.ai_system = var_2_3
		arg_2_1._nav_cost_map_id = arg_2_1._nav_cost_map_id or var_2_3:create_nav_cost_map("mutator_heavens_zone", 4)
		arg_2_1._nav_cost_volume_ids = {}
		arg_2_1._nav_cost_radius = var_2_1.radius[var_2_2][var_2_0]
	end,
	server_stop_function = function (arg_3_0, arg_3_1, arg_3_2)
		arg_3_1._nav_cost_map_id = nil
	end,
	server_ai_killed_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
		if ScorpionSeasonalSettings.current_season_id == 1 then
			if arg_4_1.boss_lightning_challenge_counter > 0 and arg_4_1.boss_lightning_challenge[arg_4_2] then
				local var_4_0 = "season_1"
				local var_4_1 = "scorpion_weaves_heavens_season_1"
				local var_4_2 = NetworkLookup.statistics_group_name[var_4_0]
				local var_4_3 = NetworkLookup.statistics[var_4_1]
				local var_4_4 = Managers.player:statistics_db()
				local var_4_5 = Managers.player:local_player():stats_id()

				var_4_4:increment_stat(var_4_5, var_4_0, var_4_1)

				arg_4_1.boss_lightning_challenge_counter = 0

				Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat_group", var_4_2, var_4_3)
			end
		else
			arg_4_1.boss_lightning_challenge_counter = 0
		end
	end,
	server_ai_hit_by_player_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		if arg_5_1.boss_lightning_challenge_counter > 0 and arg_5_1.boss_lightning_challenge[arg_5_2] then
			local var_5_0 = Managers.player:is_player_unit(arg_5_3)
			local var_5_1 = arg_5_4[DamageDataIndex.DAMAGE_AMOUNT]

			if var_5_0 and var_5_1 > 0 then
				arg_5_1.boss_lightning_challenge[arg_5_2] = nil
				arg_5_1.boss_lightning_challenge_counter = arg_5_1.boss_lightning_challenge_counter - 1
			end
		end
	end,
	server_ai_spawned_function = function (arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = Managers.state.conflict:alive_bosses()

		if var_6_0 and #var_6_0 > arg_6_1.boss_lightning_challenge_counter and BLACKBOARDS[arg_6_2].breed.boss then
			arg_6_1.boss_lightning_challenge[arg_6_2] = true
			arg_6_1.boss_lightning_challenge_counter = arg_6_1.boss_lightning_challenge_counter + 1
		end
	end,
	server_players_left_safe_zone = function (arg_7_0, arg_7_1)
		arg_7_1.has_left_safe_zone = true
	end,
	server_update_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		if not Managers.state.network or not Managers.state.network:game() then
			return
		end

		if not arg_8_1.has_left_safe_zone then
			return
		end

		local var_8_0 = arg_8_1.template
		local var_8_1 = arg_8_1.last_spawn_time
		local var_8_2 = arg_8_1.spawn_rate

		if #arg_8_1.units > 0 then
			if not arg_8_1.lock_played then
				if arg_8_3 > var_8_1 + arg_8_1.follow_time then
					arg_8_1.lock_played = true

					for iter_8_0 = 1, #arg_8_1.units do
						local var_8_3 = arg_8_1.units[iter_8_0]

						if Unit.alive(var_8_3) then
							arg_8_1.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_lock", var_8_3)

							if arg_8_1._nav_cost_map_id then
								local var_8_4 = POSITION_LOOKUP[var_8_3]
								local var_8_5 = arg_8_1.ai_system:add_nav_cost_map_sphere_volume(var_8_4, arg_8_1._nav_cost_radius, arg_8_1._nav_cost_map_id)

								table.insert(arg_8_1._nav_cost_volume_ids, var_8_5)
							end
						end
					end
				end
			elseif arg_8_3 < var_8_1 + arg_8_1.follow_time + arg_8_1.time_to_explode then
				if arg_8_3 > var_8_1 + arg_8_1.follow_time + arg_8_1.time_to_explode - 3 and not arg_8_1.bots_alerted then
					local var_8_6 = Vector3(0, arg_8_1._nav_cost_radius, arg_8_1._nav_cost_radius * 0.5)
					local var_8_7 = Managers.state.entity:system("ai_bot_group_system")

					for iter_8_1 = 1, #arg_8_1.units do
						local var_8_8 = arg_8_1.units[iter_8_1]

						if Unit.alive(var_8_8) then
							local var_8_9 = POSITION_LOOKUP[var_8_8]

							var_8_7:aoe_threat_created(var_8_9, "cylinder", var_8_6, nil, 3, "Heavens")
						end
					end

					arg_8_1.bots_alerted = true
				end

				if arg_8_3 > var_8_1 + arg_8_1.follow_time + arg_8_1.time_to_explode - 1.5 then
					if not arg_8_1.charge_played then
						arg_8_1.charge_played = true

						for iter_8_2 = 1, #arg_8_1.units do
							local var_8_10 = arg_8_1.units[iter_8_2]

							if Unit.alive(var_8_10) then
								arg_8_1.audio_system:play_audio_unit_event("Play_winds_heavens_gamepay_charge", var_8_10)
							end
						end
					end

					local var_8_11 = 100 - math.abs(var_8_1 + arg_8_1.follow_time + arg_8_1.time_to_explode - arg_8_3) / 1.5 * 100
					local var_8_12 = Managers.player:players()

					for iter_8_3, iter_8_4 in pairs(var_8_12) do
						Managers.state.network.network_transmit:send_rpc("rpc_client_audio_set_global_parameter", iter_8_4.peer_id, 6, var_8_11)
					end
				end
			elseif not arg_8_1.hit_played and arg_8_3 > var_8_1 + arg_8_1.follow_time + arg_8_1.time_to_explode then
				arg_8_1.hit_played = true

				for iter_8_5 = 1, #arg_8_1.units do
					local var_8_13 = arg_8_1.units[iter_8_5]

					if Unit.alive(var_8_13) then
						arg_8_1.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_hit", var_8_13)
					end
				end

				for iter_8_6 = 1, #arg_8_1._nav_cost_volume_ids do
					local var_8_14 = arg_8_1._nav_cost_volume_ids[iter_8_6]

					arg_8_1.ai_system:remove_nav_cost_map_volume(var_8_14, arg_8_1._nav_cost_map_id)
				end

				table.clear(arg_8_1._nav_cost_volume_ids)
			end
		end

		if var_8_1 and arg_8_3 > var_8_1 + var_8_2 then
			var_8_0.spawn_lightning_strike_unit(arg_8_1)

			arg_8_1.last_spawn_time = arg_8_3
		elseif var_8_1 == nil then
			arg_8_1.last_spawn_time = arg_8_3 + arg_8_1.initial_spawn_delay - var_8_2
		end
	end
}
