-- chunkname: @scripts/settings/mutators/mutator_lightning_strike.lua

return {
	max_spawns = 3,
	display_name = "lightning_strike_mutator_name",
	description = "lightning_strike_mutator_desc",
	spawn_rate = 11,
	icon = "mutator_icon_heavens_lightning",
	spawn_lightning_strike_unit = function (arg_1_0)
		local var_1_0 = arg_1_0.side_manager
		local var_1_1 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
		local var_1_2 = var_1_0:get_side_from_name("neutral").side_id

		table.clear(arg_1_0.units)

		for iter_1_0, iter_1_1 in pairs(var_1_1) do
			arg_1_0.extension_init_data.area_damage_system.follow_unit = iter_1_1

			local var_1_3 = Managers.state.unit_spawner:spawn_network_unit(arg_1_0.decal_unit_name, "timed_explosion_unit", arg_1_0.extension_init_data, Unit.local_position(iter_1_1, 0))

			var_1_0:add_unit_to_side(var_1_3, var_1_2)
			arg_1_0.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_spawn", var_1_3)

			arg_1_0.units[#arg_1_0.units + 1] = var_1_3
		end

		arg_1_0.lock_played = false
		arg_1_0.charge_played = false
		arg_1_0.hit_played = false
		arg_1_0.bots_alerted = false
	end,
	server_start_function = function (arg_2_0, arg_2_1)
		arg_2_1.last_spawn_time = nil
		arg_2_1.spawn_rate = arg_2_1.template.spawn_rate
		arg_2_1.max_spawns = arg_2_1.template.max_spawns
		arg_2_1.num_spawns = 0
		arg_2_1.build_up_effect_time = 1.5
		arg_2_1.side_manager = Managers.state.side
		arg_2_1.units = {}
		arg_2_1.decal_unit_name = "units/decals/decal_heavens_01"
		arg_2_1.audio_system = Managers.state.entity:system("audio_system")
		arg_2_1.explosion_template = ExplosionUtils.get_template("lightning_strike_twitch")
		arg_2_1.follow_time = arg_2_1.explosion_template.follow_time
		arg_2_1.time_to_explode = arg_2_1.explosion_template.time_to_explode
		arg_2_1.extension_init_data = {
			area_damage_system = {
				explosion_template_name = "lightning_strike_twitch"
			}
		}

		local var_2_0 = Managers.state.entity:system("ai_system")

		arg_2_1.ai_system = var_2_0
		arg_2_1._nav_cost_map_id = arg_2_1._nav_cost_map_id or var_2_0:create_nav_cost_map("mutator_heavens_zone", 4)
		arg_2_1._nav_cost_volume_ids = {}
		arg_2_1._nav_cost_radius = 4
	end,
	server_stop_function = function (arg_3_0, arg_3_1)
		arg_3_1._nav_cost_map_id = nil

		if #arg_3_1.units > 0 then
			for iter_3_0, iter_3_1 in ipairs(arg_3_1.units) do
				if ALIVE[iter_3_1] then
					Managers.state.unit_spawner:mark_for_deletion(iter_3_1)
				end

				arg_3_1.units[iter_3_0] = nil
			end
		end
	end,
	server_update_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		if not Managers.state.network or not Managers.state.network:game() then
			return
		end

		local var_4_0 = arg_4_1.template
		local var_4_1 = arg_4_1.last_spawn_time
		local var_4_2 = arg_4_1.spawn_rate

		if #arg_4_1.units > 0 then
			if not arg_4_1.lock_played then
				if arg_4_3 > var_4_1 + arg_4_1.follow_time then
					arg_4_1.lock_played = true

					for iter_4_0 = 1, #arg_4_1.units do
						local var_4_3 = arg_4_1.units[iter_4_0]

						if ALIVE[var_4_3] then
							arg_4_1.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_lock", var_4_3)

							if arg_4_1._nav_cost_map_id then
								local var_4_4 = POSITION_LOOKUP[var_4_3]
								local var_4_5 = arg_4_1.ai_system:add_nav_cost_map_sphere_volume(var_4_4, arg_4_1._nav_cost_radius, arg_4_1._nav_cost_map_id)

								table.insert(arg_4_1._nav_cost_volume_ids, var_4_5)
							end
						end
					end
				end
			elseif arg_4_3 < var_4_1 + arg_4_1.follow_time + arg_4_1.time_to_explode then
				if arg_4_3 > var_4_1 + arg_4_1.follow_time + arg_4_1.time_to_explode - 3 and not arg_4_1.bots_alerted then
					local var_4_6 = Vector3(0, arg_4_1._nav_cost_radius, arg_4_1._nav_cost_radius * 0.5)
					local var_4_7 = Managers.state.entity:system("ai_bot_group_system")

					for iter_4_1 = 1, #arg_4_1.units do
						local var_4_8 = arg_4_1.units[iter_4_1]

						if Unit.alive(var_4_8) then
							local var_4_9 = POSITION_LOOKUP[var_4_8]

							var_4_7:aoe_threat_created(var_4_9, "cylinder", var_4_6, nil, 3, "Lightning Strike")
						end
					end

					arg_4_1.bots_alerted = true
				end

				if arg_4_3 > var_4_1 + arg_4_1.follow_time + arg_4_1.time_to_explode - arg_4_1.build_up_effect_time then
					if not arg_4_1.charge_played then
						arg_4_1.charge_played = true

						for iter_4_2 = 1, #arg_4_1.units do
							local var_4_10 = arg_4_1.units[iter_4_2]

							if ALIVE[var_4_10] then
								arg_4_1.audio_system:play_audio_unit_event("Play_winds_heavens_gamepay_charge", var_4_10)
							end
						end
					end

					local var_4_11 = 100 - math.abs(var_4_1 + arg_4_1.follow_time + arg_4_1.time_to_explode - arg_4_3) / arg_4_1.build_up_effect_time * 100
					local var_4_12 = Managers.player:players()

					for iter_4_3, iter_4_4 in pairs(var_4_12) do
						Managers.state.network.network_transmit:send_rpc("rpc_client_audio_set_global_parameter", iter_4_4.peer_id, 6, var_4_11)
					end
				end
			elseif not arg_4_1.hit_played and arg_4_3 > var_4_1 + arg_4_1.follow_time + arg_4_1.time_to_explode then
				arg_4_1.hit_played = true

				for iter_4_5 = 1, #arg_4_1.units do
					local var_4_13 = arg_4_1.units[iter_4_5]

					if ALIVE[var_4_13] then
						arg_4_1.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_hit", var_4_13)
					end
				end

				for iter_4_6 = 1, #arg_4_1._nav_cost_volume_ids do
					local var_4_14 = arg_4_1._nav_cost_volume_ids[iter_4_6]

					arg_4_1.ai_system:remove_nav_cost_map_volume(var_4_14, arg_4_1._nav_cost_map_id)
				end

				table.clear(arg_4_1._nav_cost_volume_ids)
			end
		end

		if var_4_1 and arg_4_3 > var_4_1 + var_4_2 and arg_4_1.num_spawns < arg_4_1.max_spawns then
			var_4_0.spawn_lightning_strike_unit(arg_4_1)

			arg_4_1.num_spawns = arg_4_1.num_spawns + 1
			arg_4_1.last_spawn_time = arg_4_1.last_spawn_time + var_4_2
		elseif var_4_1 == nil then
			arg_4_1.last_spawn_time = arg_4_3 - var_4_2
		end
	end
}
