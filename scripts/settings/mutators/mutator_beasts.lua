-- chunkname: @scripts/settings/mutators/mutator_beasts.lua

return {
	description = "weaves_beasts_mutator_desc",
	display_name = "weaves_beasts_mutator_name",
	icon = "mutator_icon_beast_totems",
	server_level_object_killed_function = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		if not Unit.is_a(arg_1_2, arg_1_1.beacon_unit) then
			for k, v in pairs(arg_1_1.totems) do
				if arg_1_2 == v.unit then
					arg_1_1.audio_system:play_audio_unit_event("Play_winds_beast_totem_destroy", arg_1_2)

					v.active = false

					arg_1_1.template.increment_challenge_stat()
				end
			end
		end
	end,
	increment_challenge_stat = function ()
		-- function 2
		if ScorpionSeasonalSettings.current_season_id == 1 then
			local str = "season_1"
			local str_2 = "weave_beasts_destroyed_totems"
			local var_2_2 = NetworkLookup.statistics_group_name[str]
			local var_2_3 = NetworkLookup.statistics[str_2]
			local statistics_db = Managers.player:statistics_db()
			local stats_id = Managers.player:local_player():stats_id()

			statistics_db:increment_stat(stats_id, str, str_2)
			Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat_group", var_2_2, var_2_3)
		end
	end,
	update_totems = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		arg_3_1.update_timer = arg_3_1.update_timer + arg_3_2

		if arg_3_1.update_timer > 1 then
			arg_3_1.update_timer = 0

			local local_player = Managers.player:local_player()
			local flag = not local_player and local_player.player_unit

			if not flag then
				return
			end

			local enemy_broadphase_categories = Managers.state.side.side_by_unit[flag].enemy_broadphase_categories

			for i, v in ipairs(arg_3_1.totems) do
				if not v.active then
					table.clear(arg_3_1.ai_units_broadphase_result)

					local var_3_3 = POSITION_LOOKUP[v.unit]
					local broadphase_query = AiUtils.broadphase_query(var_3_3, arg_3_1.radius, arg_3_1.ai_units_broadphase_result, enemy_broadphase_categories)

					for k = 1, broadphase_query do
						local var_3_5 = arg_3_1.ai_units_broadphase_result[k]

						if not (not ScriptUnit.has_extension(var_3_5, "buff_system") and arg_3_1.ai_units_inside[var_3_5]) then
							arg_3_1.ai_units_inside[var_3_5] = true
						end
					end
				else
					local get_active_objective_template = Managers.weave:get_active_objective_template()

					if not get_active_objective_template and not get_active_objective_template.allow_mutator_item_respawning then
						v.respawn_time = v.respawn_time - 1

						if v.respawn_time <= 0 then
							v.active = true
							v.respawn_time = arg_3_1.totem_respawn_time

							local local_position = Unit.local_position(v.unit, 0)
							local local_rotation = Unit.local_rotation(v.unit, 0)

							v.unit = Managers.state.unit_spawner:spawn_network_unit(arg_3_1.unit_name, arg_3_1.unit_extension_template, arg_3_1.extension_init_data, local_position, local_rotation)
						end
					end
				end
			end

			local tbl = {}

			for k_2, v_2 in pairs(arg_3_1.old_ai_units_inside) do
				if (not arg_3_1.ai_units_inside[k_2] and HEALTH_ALIVE[k_2] or not Unit.alive(k_2)) and not arg_3_1.buff_system:has_server_controlled_buff(k_2, v_2) then
					arg_3_1.buff_system:remove_server_controlled_buff(k_2, v_2)

					tbl[#tbl + 1] = k_2
				end
			end

			for i5 = 1, #tbl do
				local var_3_10 = tbl[i5]

				arg_3_1.old_ai_units_inside[var_3_10] = nil
			end

			for k_3, v_3 in pairs(arg_3_1.ai_units_inside) do
				local has_extension = ScriptUnit.has_extension(k_3, "buff_system")

				if not (not has_extension and has_extension:get_non_stacking_buff(arg_3_1.buff_template_name) or has_extension:get_non_stacking_buff("healing_standard")) then
					local add_buff = arg_3_1.buff_system:add_buff(k_3, arg_3_1.buff_template_name, k_3, true)

					arg_3_1.old_ai_units_inside[k_3] = add_buff
				end
			end

			table.clear(arg_3_1.ai_units_inside)
		end
	end,
	server_start_function = function (self, arg_4_1)
		-- function 4
		local weave = Managers.weave
		local get_active_objective_template = weave:get_active_objective_template()
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local get_wind_strength = weave:get_wind_strength()
		local get_active_wind_settings = weave:get_active_wind_settings()

		arg_4_1.beacon_unit = get_active_wind_settings.beacon_unit
		arg_4_1.physics_world = World.physics_world(self.world)
		arg_4_1.audio_system = Managers.state.entity:system("audio_system")
		arg_4_1.buff_system = Managers.state.entity:system("buff_system")
		arg_4_1.totems = {}
		arg_4_1.totem_respawn_time = get_active_wind_settings.respawn_rate[get_difficulty][get_wind_strength]
		arg_4_1.radius = get_active_wind_settings.radius[get_difficulty][get_wind_strength]
		arg_4_1.update_timer = 0
		arg_4_1.ai_units_broadphase_result = {}
		arg_4_1.ai_units_inside = {}
		arg_4_1.old_ai_units_inside = {}
		arg_4_1.unit_name = "units/weave/beasts/beast_totem_mutator"
		arg_4_1.unit_extension_template = "destructible_objective_unit"
		arg_4_1.buff_template_name = "mutator_beasts_totem_buff"
		arg_4_1.extension_init_data = {
			health_system = {
				damage_cap_per_hit = 1,
				health = 5
			},
			hit_reaction_system = {
				hit_reaction_template = "level_object"
			}
		}

		local mutator_item_config = get_active_objective_template.mutator_item_config
		local spawn_mutator_items = Managers.state.entity:system("mutator_item_system"):spawn_mutator_items(mutator_item_config)

		for k, v in pairs(spawn_mutator_items) do
			arg_4_1.audio_system:play_audio_unit_event("Play_winds_beast_totem_loop", v)

			local tbl = {
				active = true,
				unit = v,
				respawn_time = arg_4_1.totem_respawn_time,
				ai_units_inside = {}
			}

			arg_4_1.totems[#arg_4_1.totems + 1] = tbl
		end
	end,
	server_players_left_safe_zone = function (arg_5_0, arg_5_1)
		-- function 5
		arg_5_1.has_left_safe_zone = true
	end,
	server_update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not (not Managers.state.network and Managers.state.network:game()) then
			return
		end

		if not arg_6_1.has_left_safe_zone then
			return
		end

		arg_6_1.template.update_totems(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	end
}
