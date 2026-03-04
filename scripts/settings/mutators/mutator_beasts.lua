-- chunkname: @scripts/settings/mutators/mutator_beasts.lua

return {
	description = "weaves_beasts_mutator_desc",
	display_name = "weaves_beasts_mutator_name",
	icon = "mutator_icon_beast_totems",
	server_level_object_killed_function = function(arg_1_0, arg_1_1, arg_1_2)
		if Unit.is_a(arg_1_2, arg_1_1.beacon_unit) then
			for iter_1_0, iter_1_1 in pairs(arg_1_1.totems) do
				if arg_1_2 == iter_1_1.unit then
					arg_1_1.audio_system:play_audio_unit_event("Play_winds_beast_totem_destroy", arg_1_2)

					iter_1_1.active = false

					arg_1_1.template.increment_challenge_stat()
				end
			end
		end
	end,
	increment_challenge_stat = function()
		if ScorpionSeasonalSettings.current_season_id == 1 then
			local var_2_0 = "season_1"
			local var_2_1 = "weave_beasts_destroyed_totems"
			local var_2_2 = NetworkLookup.statistics_group_name[var_2_0]
			local var_2_3 = NetworkLookup.statistics[var_2_1]
			local var_2_4 = Managers.player:statistics_db()
			local var_2_5 = Managers.player:local_player():stats_id()

			var_2_4:increment_stat(var_2_5, var_2_0, var_2_1)
			Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat_group", var_2_2, var_2_3)
		end
	end,
	update_totems = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		arg_3_1.update_timer = arg_3_1.update_timer + arg_3_2

		if arg_3_1.update_timer > 1 then
			arg_3_1.update_timer = 0

			local var_3_0 = Managers.player:local_player()
			local var_3_1 = var_3_0 and var_3_0.player_unit

			if not var_3_1 then
				return
			end

			local var_3_2 = Managers.state.side.side_by_unit[var_3_1].enemy_broadphase_categories

			for iter_3_0, iter_3_1 in ipairs(arg_3_1.totems) do
				if iter_3_1.active then
					table.clear(arg_3_1.ai_units_broadphase_result)

					local var_3_3 = POSITION_LOOKUP[iter_3_1.unit]
					local var_3_4 = AiUtils.broadphase_query(var_3_3, arg_3_1.radius, arg_3_1.ai_units_broadphase_result, var_3_2)

					for iter_3_2 = 1, var_3_4 do
						local var_3_5 = arg_3_1.ai_units_broadphase_result[iter_3_2]

						if ScriptUnit.has_extension(var_3_5, "buff_system") and not arg_3_1.ai_units_inside[var_3_5] then
							arg_3_1.ai_units_inside[var_3_5] = true
						end
					end
				else
					local var_3_6 = Managers.weave:get_active_objective_template()

					if var_3_6 and var_3_6.allow_mutator_item_respawning then
						iter_3_1.respawn_time = iter_3_1.respawn_time - 1

						if iter_3_1.respawn_time <= 0 then
							iter_3_1.active = true
							iter_3_1.respawn_time = arg_3_1.totem_respawn_time

							local var_3_7 = Unit.local_position(iter_3_1.unit, 0)
							local var_3_8 = Unit.local_rotation(iter_3_1.unit, 0)

							iter_3_1.unit = Managers.state.unit_spawner:spawn_network_unit(arg_3_1.unit_name, arg_3_1.unit_extension_template, arg_3_1.extension_init_data, var_3_7, var_3_8)
						end
					end
				end
			end

			local var_3_9 = {}

			for iter_3_3, iter_3_4 in pairs(arg_3_1.old_ai_units_inside) do
				if (not arg_3_1.ai_units_inside[iter_3_3] or not HEALTH_ALIVE[iter_3_3]) and Unit.alive(iter_3_3) and arg_3_1.buff_system:has_server_controlled_buff(iter_3_3, iter_3_4) then
					arg_3_1.buff_system:remove_server_controlled_buff(iter_3_3, iter_3_4)

					var_3_9[#var_3_9 + 1] = iter_3_3
				end
			end

			for iter_3_5 = 1, #var_3_9 do
				local var_3_10 = var_3_9[iter_3_5]

				arg_3_1.old_ai_units_inside[var_3_10] = nil
			end

			for iter_3_6, iter_3_7 in pairs(arg_3_1.ai_units_inside) do
				local var_3_11 = ScriptUnit.has_extension(iter_3_6, "buff_system")

				if var_3_11 and not var_3_11:get_non_stacking_buff(arg_3_1.buff_template_name) and not var_3_11:get_non_stacking_buff("healing_standard") then
					local var_3_12 = arg_3_1.buff_system:add_buff(iter_3_6, arg_3_1.buff_template_name, iter_3_6, true)

					arg_3_1.old_ai_units_inside[iter_3_6] = var_3_12
				end
			end

			table.clear(arg_3_1.ai_units_inside)
		end
	end,
	server_start_function = function(arg_4_0, arg_4_1)
		local var_4_0 = Managers.weave
		local var_4_1 = var_4_0:get_active_objective_template()
		local var_4_2 = Managers.state.difficulty:get_difficulty()
		local var_4_3 = var_4_0:get_wind_strength()
		local var_4_4 = var_4_0:get_active_wind_settings()

		arg_4_1.beacon_unit = var_4_4.beacon_unit
		arg_4_1.physics_world = World.physics_world(arg_4_0.world)
		arg_4_1.audio_system = Managers.state.entity:system("audio_system")
		arg_4_1.buff_system = Managers.state.entity:system("buff_system")
		arg_4_1.totems = {}
		arg_4_1.totem_respawn_time = var_4_4.respawn_rate[var_4_2][var_4_3]
		arg_4_1.radius = var_4_4.radius[var_4_2][var_4_3]
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

		local var_4_5 = var_4_1.mutator_item_config
		local var_4_6 = Managers.state.entity:system("mutator_item_system"):spawn_mutator_items(var_4_5)

		for iter_4_0, iter_4_1 in pairs(var_4_6) do
			arg_4_1.audio_system:play_audio_unit_event("Play_winds_beast_totem_loop", iter_4_1)

			local var_4_7 = {
				active = true,
				unit = iter_4_1,
				respawn_time = arg_4_1.totem_respawn_time,
				ai_units_inside = {}
			}

			arg_4_1.totems[#arg_4_1.totems + 1] = var_4_7
		end
	end,
	server_players_left_safe_zone = function(arg_5_0, arg_5_1)
		arg_5_1.has_left_safe_zone = true
	end,
	server_update_function = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if not Managers.state.network or not Managers.state.network:game() then
			return
		end

		if not arg_6_1.has_left_safe_zone then
			return
		end

		arg_6_1.template.update_totems(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	end
}
