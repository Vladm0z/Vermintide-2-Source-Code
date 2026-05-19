-- chunkname: @scripts/settings/mutators/mutator_light.lua

return {
	description = "weaves_light_mutator_desc",
	display_name = "weaves_light_mutator_name",
	icon = "mutator_icon_light_beacons",
	add_buff = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = #arg_1_1

		if var_1_0 < arg_1_0.max_stacks then
			local var_1_1 = true
			local var_1_2 = arg_1_2:add_buff(arg_1_3, arg_1_0.curse_buff_name, arg_1_3, var_1_1)

			arg_1_1[var_1_0 + 1] = var_1_2
		end
	end,
	clear_buffs = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = ScriptUnit.has_extension(arg_2_3.player_unit, "buff_system")
		local var_2_1 = var_2_0 and var_2_0:has_buff_type(arg_2_0.curse_buff_name)

		if arg_2_1 and var_2_1 then
			local var_2_2 = #arg_2_1
			local var_2_3 = arg_2_1[var_2_2]
			local var_2_4 = (var_2_2 - 1) * (arg_2_0.curse_value * -100)

			Managers.state.network.network_transmit:send_rpc("rpc_client_audio_set_global_parameter", arg_2_3.peer_id, 6, var_2_4)
			arg_2_2:remove_server_controlled_buff(arg_2_3.player_unit, var_2_3)

			arg_2_1[var_2_2] = nil
		end
	end,
	update_challenge_statistics = function(arg_3_0)
		if ScorpionSeasonalSettings.current_season_id == 1 then
			local var_3_0 = "season_1"
			local var_3_1 = "weave_light_low_curse"

			if arg_3_0.local_player then
				local var_3_2 = Managers.player:statistics_db()
				local var_3_3 = Managers.player:local_player():stats_id()

				var_3_2:increment_stat(var_3_3, var_3_0, var_3_1)
			else
				local var_3_4 = NetworkLookup.statistics_group_name[var_3_0]
				local var_3_5 = NetworkLookup.statistics[var_3_1]
				local var_3_6 = arg_3_0:network_id()

				Managers.state.network.network_transmit:send_rpc("rpc_increment_stat_group", var_3_6, var_3_4, var_3_5)
			end
		end
	end,
	update_curse = function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_0.template
		local var_4_1 = arg_4_0.last_curse_time
		local var_4_2 = arg_4_0.curse_rate

		if var_4_1 and arg_4_1 > var_4_1 + var_4_2 then
			arg_4_0.last_curse_time = arg_4_1

			local var_4_3 = Managers.player:players()

			for iter_4_0, iter_4_1 in pairs(var_4_3) do
				if not arg_4_0.buffs[iter_4_0] then
					arg_4_0.buffs[iter_4_0] = {}
				end

				local var_4_4 = ScriptUnit.has_extension(iter_4_1.player_unit, "buff_system")
				local var_4_5 = var_4_4 and var_4_4:has_buff_type("mutator_light_cleansing_curse_buff")
				local var_4_6 = ScriptUnit.has_extension(iter_4_1.player_unit, "status_system")
				local var_4_7 = var_4_6 and var_4_6.ready_for_assisted_respawn

				if not var_4_5 and not var_4_7 then
					local var_4_8 = arg_4_0.buffs[iter_4_0]

					var_4_0.add_buff(arg_4_0, var_4_8, arg_4_0.buff_system, iter_4_1.player_unit)

					local var_4_9 = #arg_4_0.buffs[iter_4_0] * (arg_4_0.curse_value * -100)

					if var_4_9 > 10 then
						arg_4_0.template.update_challenge_statistics(iter_4_1)
					end

					Managers.state.network.network_transmit:send_rpc("rpc_client_audio_set_global_parameter", iter_4_1.peer_id, 6, var_4_9)
				end
			end
		elseif var_4_1 == nil then
			arg_4_0.last_curse_time = arg_4_1 + 0
		end
	end,
	update_proximity_sound = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = Managers.state.network
		local var_5_1 = Network.peer_id()

		if not arg_5_1.players_in_proximity[arg_5_2.peer_id] and arg_5_3 then
			arg_5_1.players_in_proximity[arg_5_2.peer_id] = true

			if arg_5_2.peer_id ~= var_5_1 then
				local var_5_2 = NetworkLookup.sound_events.Play_wind_light_beacon_cleanse_loop

				var_5_0.network_transmit:send_rpc("rpc_server_audio_event", arg_5_2.peer_id, var_5_2)
			else
				local var_5_3 = Managers.world:wwise_world(arg_5_0.world)

				WwiseWorld.trigger_event(var_5_3, "Play_wind_light_beacon_cleanse_loop")
			end
		elseif arg_5_1.players_in_proximity[arg_5_2.peer_id] and not arg_5_3 then
			arg_5_1.players_in_proximity[arg_5_2.peer_id] = nil

			if arg_5_2.peer_id ~= var_5_1 then
				local var_5_4 = NetworkLookup.sound_events.Stop_wind_light_beacon_cleanse_loop

				var_5_0.network_transmit:send_rpc("rpc_server_audio_event", arg_5_2.peer_id, var_5_4)
			else
				local var_5_5 = Managers.world:wwise_world(arg_5_0.world)

				WwiseWorld.trigger_event(var_5_5, "Stop_wind_light_beacon_cleanse_loop")
			end
		end
	end,
	update_beacons = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		local var_6_0 = arg_6_1.last_cleanse_time
		local var_6_1 = arg_6_1.cleanse_rate

		if var_6_0 and arg_6_3 > var_6_0 + var_6_1 then
			arg_6_1.last_cleanse_time = arg_6_3

			local var_6_2 = {}

			for iter_6_0, iter_6_1 in pairs(Managers.player:players()) do
				var_6_2[iter_6_0] = {
					player_unit = iter_6_1.player_unit,
					peer_id = iter_6_1.peer_id
				}
			end

			for iter_6_2, iter_6_3 in pairs(arg_6_1.beacons) do
				arg_6_1.audio_system:play_audio_unit_event("Play_wind_light_beacon_pulse", iter_6_3)

				local var_6_3 = Unit.local_position(iter_6_3, 0)
				local var_6_4 = Unit.local_rotation(iter_6_3, 0)

				Managers.state.entity:system("area_damage_system"):create_explosion(iter_6_3, var_6_3, var_6_4, "light_pulse", 1, "undefined", 0, false)

				for iter_6_4, iter_6_5 in pairs(var_6_2) do
					local var_6_5 = POSITION_LOOKUP[iter_6_5.player_unit]

					if var_6_5 and Vector3.distance_squared(var_6_3, var_6_5) - 6 < arg_6_1.radius * arg_6_1.radius then
						iter_6_5.inside = true
					end
				end
			end

			for iter_6_6, iter_6_7 in pairs(var_6_2) do
				if iter_6_7.inside then
					arg_6_1.template.clear_buffs(arg_6_1, arg_6_1.buffs[iter_6_6], arg_6_1.buff_system, iter_6_7)
					arg_6_1.template.update_proximity_sound(arg_6_0, arg_6_1, iter_6_7, true)

					var_6_2[iter_6_6] = nil
				else
					arg_6_1.template.update_proximity_sound(arg_6_0, arg_6_1, iter_6_7, false)
				end
			end
		elseif var_6_0 == nil then
			arg_6_1.last_cleanse_time = arg_6_3 + 0
		end
	end,
	server_start_function = function(arg_7_0, arg_7_1)
		local var_7_0 = Managers.weave
		local var_7_1 = var_7_0:get_active_wind_settings()
		local var_7_2 = var_7_0:get_wind_strength()
		local var_7_3 = var_7_0:get_active_objective_template()
		local var_7_4 = Managers.state.difficulty:get_difficulty()

		arg_7_1.audio_system = Managers.state.entity:system("audio_system")
		arg_7_1.radius = var_7_1.radius[var_7_4][var_7_2]
		arg_7_1.buff_system = Managers.state.entity:system("buff_system")
		arg_7_1.curse_rate = var_7_1.curse_settings.curse_rate[var_7_4][var_7_2]
		arg_7_1.curse_value = var_7_1.curse_settings.value[var_7_4]
		arg_7_1.cleanse_rate = var_7_1.cleanse_rate
		arg_7_1.beacons = {}
		arg_7_1.buffs = {}
		arg_7_1.curse_buff_name = "mutator_light_debuff"
		arg_7_1.max_stacks = math.ceil(math.abs(1.5 / arg_7_1.curse_value))
		arg_7_1.players_in_proximity = {}

		local var_7_5 = var_7_3.mutator_item_config

		arg_7_1.beacons = Managers.state.entity:system("mutator_item_system"):spawn_mutator_items(var_7_5)

		local var_7_6 = Managers.player:players()

		for iter_7_0, iter_7_1 in pairs(var_7_6) do
			arg_7_1.buffs[iter_7_0] = {}
		end
	end,
	server_players_left_safe_zone = function(arg_8_0, arg_8_1)
		arg_8_1.has_left_safe_zone = true
	end,
	server_update_function = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		if not Managers.state.network or not Managers.state.network:game() then
			return
		end

		if not arg_9_1.has_left_safe_zone then
			return
		end

		arg_9_1.template.update_curse(arg_9_1, arg_9_3)
		arg_9_1.template.update_beacons(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	end
}
