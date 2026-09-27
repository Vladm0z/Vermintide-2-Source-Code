-- chunkname: @scripts/settings/mutators/mutator_light.lua

return {
	description = "weaves_light_mutator_desc",
	display_name = "weaves_light_mutator_name",
	icon = "mutator_icon_light_beacons",
	add_buff = function (self, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		local count = #arg_1_1

		if count < self.max_stacks then
			local flag = true
			local add_buff = arg_1_2:add_buff(arg_1_3, self.curse_buff_name, arg_1_3, flag)

			arg_1_1[count + 1] = add_buff
		end
	end,
	clear_buffs = function (self, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local has_extension = ScriptUnit.has_extension(arg_2_3.player_unit, "buff_system")
		local flag = not has_extension and has_extension:has_buff_type(self.curse_buff_name)

		if not arg_2_1 and not flag then
			local count = #arg_2_1
			local var_2_3 = arg_2_1[count]
			local num = (count - 1) * (self.curse_value * -100)

			Managers.state.network.network_transmit:send_rpc("rpc_client_audio_set_global_parameter", arg_2_3.peer_id, 6, num)
			arg_2_2:remove_server_controlled_buff(arg_2_3.player_unit, var_2_3)

			arg_2_1[count] = nil
		end
	end,
	update_challenge_statistics = function (self)
		-- function 3
		if ScorpionSeasonalSettings.current_season_id == 1 then
			local str = "season_1"
			local str_2 = "weave_light_low_curse"

			if not self.local_player then
				local statistics_db = Managers.player:statistics_db()
				local stats_id = Managers.player:local_player():stats_id()

				statistics_db:increment_stat(stats_id, str, str_2)
			else
				local var_3_4 = NetworkLookup.statistics_group_name[str]
				local var_3_5 = NetworkLookup.statistics[str_2]
				local network_id = self:network_id()

				Managers.state.network.network_transmit:send_rpc("rpc_increment_stat_group", network_id, var_3_4, var_3_5)
			end
		end
	end,
	update_curse = function (self, arg_4_1)
		-- function 4
		local template = self.template
		local last_curse_time = self.last_curse_time
		local curse_rate = self.curse_rate

		if not (not last_curse_time and not (arg_4_1 > last_curse_time + curse_rate)) then
			self.last_curse_time = arg_4_1

			local players = Managers.player:players()

			for k, v in pairs(players) do
				if not self.buffs[k] then
					self.buffs[k] = {}
				end

				local has_extension = ScriptUnit.has_extension(v.player_unit, "buff_system")
				local flag = not has_extension and has_extension:has_buff_type("mutator_light_cleansing_curse_buff")
				local has_extension_2 = ScriptUnit.has_extension(v.player_unit, "status_system")
				local flag_2 = not has_extension_2 and has_extension_2.ready_for_assisted_respawn

				if not (flag or flag_2) then
					local var_4_8 = self.buffs[k]

					template.add_buff(self, var_4_8, self.buff_system, v.player_unit)

					local num = #self.buffs[k] * (self.curse_value * -100)

					if num > 10 then
						self.template.update_challenge_statistics(v)
					end

					Managers.state.network.network_transmit:send_rpc("rpc_client_audio_set_global_parameter", v.peer_id, 6, num)
				end
			end
		elseif last_curse_time == nil then
			self.last_curse_time = arg_4_1 + 0
		end
	end,
	update_proximity_sound = function (self, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		local network = Managers.state.network
		local peer_id = Network.peer_id()

		if arg_5_1.players_in_proximity[arg_5_2.peer_id] or not arg_5_3 then
			arg_5_1.players_in_proximity[arg_5_2.peer_id] = true

			if arg_5_2.peer_id ~= peer_id then
				local Play_wind_light_beacon_cleanse_loop = NetworkLookup.sound_events.Play_wind_light_beacon_cleanse_loop

				network.network_transmit:send_rpc("rpc_server_audio_event", arg_5_2.peer_id, Play_wind_light_beacon_cleanse_loop)
			else
				local wwise_world = Managers.world:wwise_world(self.world)

				WwiseWorld.trigger_event(wwise_world, "Play_wind_light_beacon_cleanse_loop")
			end
		elseif not (not arg_5_1.players_in_proximity[arg_5_2.peer_id] and arg_5_3) then
			arg_5_1.players_in_proximity[arg_5_2.peer_id] = nil

			if arg_5_2.peer_id ~= peer_id then
				local Stop_wind_light_beacon_cleanse_loop = NetworkLookup.sound_events.Stop_wind_light_beacon_cleanse_loop

				network.network_transmit:send_rpc("rpc_server_audio_event", arg_5_2.peer_id, Stop_wind_light_beacon_cleanse_loop)
			else
				local wwise_world_2 = Managers.world:wwise_world(self.world)

				WwiseWorld.trigger_event(wwise_world_2, "Stop_wind_light_beacon_cleanse_loop")
			end
		end
	end,
	update_beacons = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		local last_cleanse_time = arg_6_1.last_cleanse_time
		local cleanse_rate = arg_6_1.cleanse_rate

		if not (not last_cleanse_time and not (arg_6_3 > last_cleanse_time + cleanse_rate)) then
			arg_6_1.last_cleanse_time = arg_6_3

			local tbl = {}

			for k, v in pairs(Managers.player:players()) do
				tbl[k] = {
					player_unit = v.player_unit,
					peer_id = v.peer_id
				}
			end

			for k_2, v_2 in pairs(arg_6_1.beacons) do
				arg_6_1.audio_system:play_audio_unit_event("Play_wind_light_beacon_pulse", v_2)

				local local_position = Unit.local_position(v_2, 0)
				local local_rotation = Unit.local_rotation(v_2, 0)

				Managers.state.entity:system("area_damage_system"):create_explosion(v_2, local_position, local_rotation, "light_pulse", 1, "undefined", 0, false)

				for k_3, v_3 in pairs(tbl) do
					local var_6_5 = POSITION_LOOKUP[v_3.player_unit]

					if not (not var_6_5 and not (Vector3.distance_squared(local_position, var_6_5) - 6 < arg_6_1.radius * arg_6_1.radius)) then
						v_3.inside = true
					end
				end
			end

			for k_4, v_4 in pairs(tbl) do
				if not v_4.inside then
					arg_6_1.template.clear_buffs(arg_6_1, arg_6_1.buffs[k_4], arg_6_1.buff_system, v_4)
					arg_6_1.template.update_proximity_sound(arg_6_0, arg_6_1, v_4, true)

					tbl[k_4] = nil
				else
					arg_6_1.template.update_proximity_sound(arg_6_0, arg_6_1, v_4, false)
				end
			end
		elseif last_cleanse_time == nil then
			arg_6_1.last_cleanse_time = arg_6_3 + 0
		end
	end,
	server_start_function = function (arg_7_0, arg_7_1)
		-- function 7
		local weave = Managers.weave
		local get_active_wind_settings = weave:get_active_wind_settings()
		local get_wind_strength = weave:get_wind_strength()
		local get_active_objective_template = weave:get_active_objective_template()
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_7_1.audio_system = Managers.state.entity:system("audio_system")
		arg_7_1.radius = get_active_wind_settings.radius[get_difficulty][get_wind_strength]
		arg_7_1.buff_system = Managers.state.entity:system("buff_system")
		arg_7_1.curse_rate = get_active_wind_settings.curse_settings.curse_rate[get_difficulty][get_wind_strength]
		arg_7_1.curse_value = get_active_wind_settings.curse_settings.value[get_difficulty]
		arg_7_1.cleanse_rate = get_active_wind_settings.cleanse_rate
		arg_7_1.beacons = {}
		arg_7_1.buffs = {}
		arg_7_1.curse_buff_name = "mutator_light_debuff"
		arg_7_1.max_stacks = math.ceil(math.abs(1.5 / arg_7_1.curse_value))
		arg_7_1.players_in_proximity = {}

		local mutator_item_config = get_active_objective_template.mutator_item_config

		arg_7_1.beacons = Managers.state.entity:system("mutator_item_system"):spawn_mutator_items(mutator_item_config)

		local players = Managers.player:players()

		for k, v in pairs(players) do
			arg_7_1.buffs[k] = {}
		end
	end,
	server_players_left_safe_zone = function (arg_8_0, arg_8_1)
		-- function 8
		arg_8_1.has_left_safe_zone = true
	end,
	server_update_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		if not (not Managers.state.network and Managers.state.network:game()) then
			return
		end

		if not arg_9_1.has_left_safe_zone then
			return
		end

		arg_9_1.template.update_curse(arg_9_1, arg_9_3)
		arg_9_1.template.update_beacons(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	end
}
