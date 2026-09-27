-- chunkname: @scripts/settings/mutators/mutator_lightning_strike.lua

return {
	max_spawns = 3,
	display_name = "lightning_strike_mutator_name",
	description = "lightning_strike_mutator_desc",
	spawn_rate = 11,
	icon = "mutator_icon_heavens_lightning",
	spawn_lightning_strike_unit = function (self)
		-- function 1
		local side_manager = self.side_manager
		local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
		local side_id = side_manager:get_side_from_name("neutral").side_id

		table.clear(self.units)

		for k, v in pairs(PLAYER_AND_BOT_UNITS) do
			self.extension_init_data.area_damage_system.follow_unit = v

			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(self.decal_unit_name, "timed_explosion_unit", self.extension_init_data, Unit.local_position(v, 0))

			side_manager:add_unit_to_side(spawn_network_unit, side_id)
			self.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_spawn", spawn_network_unit)

			self.units[#self.units + 1] = spawn_network_unit
		end

		self.lock_played = false
		self.charge_played = false
		self.hit_played = false
		self.bots_alerted = false
	end,
	server_start_function = function (arg_2_0, arg_2_1)
		-- function 2
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

		local system = Managers.state.entity:system("ai_system")

		arg_2_1.ai_system = system

		local _nav_cost_map_id = arg_2_1._nav_cost_map_id

		_nav_cost_map_id = _nav_cost_map_id or system:create_nav_cost_map("mutator_heavens_zone", 4)
		arg_2_1._nav_cost_map_id = _nav_cost_map_id
		arg_2_1._nav_cost_volume_ids = {}
		arg_2_1._nav_cost_radius = 4
	end,
	server_stop_function = function (arg_3_0, arg_3_1)
		-- function 3
		arg_3_1._nav_cost_map_id = nil

		if #arg_3_1.units > 0 then
			for i, v in ipairs(arg_3_1.units) do
				if not ALIVE[v] then
					Managers.state.unit_spawner:mark_for_deletion(v)
				end

				arg_3_1.units[i] = nil
			end
		end
	end,
	server_update_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		if not (not Managers.state.network and Managers.state.network:game()) then
			return
		end

		local template = arg_4_1.template
		local last_spawn_time = arg_4_1.last_spawn_time
		local spawn_rate = arg_4_1.spawn_rate

		if #arg_4_1.units > 0 then
			if not arg_4_1.lock_played then
				if arg_4_3 > last_spawn_time + arg_4_1.follow_time then
					arg_4_1.lock_played = true

					for i = 1, #arg_4_1.units do
						local var_4_3 = arg_4_1.units[i]

						if not ALIVE[var_4_3] then
							arg_4_1.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_lock", var_4_3)

							if not arg_4_1._nav_cost_map_id then
								local var_4_4 = POSITION_LOOKUP[var_4_3]
								local add_nav_cost_map_sphere_volume = arg_4_1.ai_system:add_nav_cost_map_sphere_volume(var_4_4, arg_4_1._nav_cost_radius, arg_4_1._nav_cost_map_id)

								table.insert(arg_4_1._nav_cost_volume_ids, add_nav_cost_map_sphere_volume)
							end
						end
					end
				end
			elseif arg_4_3 < last_spawn_time + arg_4_1.follow_time + arg_4_1.time_to_explode then
				if not (not (arg_4_3 > last_spawn_time + arg_4_1.follow_time + arg_4_1.time_to_explode - 3) or arg_4_1.bots_alerted) then
					local var_4_6 = Vector3(0, arg_4_1._nav_cost_radius, arg_4_1._nav_cost_radius * 0.5)
					local system = Managers.state.entity:system("ai_bot_group_system")

					for j = 1, #arg_4_1.units do
						local var_4_8 = arg_4_1.units[j]

						if not Unit.alive(var_4_8) then
							local var_4_9 = POSITION_LOOKUP[var_4_8]

							system:aoe_threat_created(var_4_9, "cylinder", var_4_6, nil, 3, "Lightning Strike")
						end
					end

					arg_4_1.bots_alerted = true
				end

				if arg_4_3 > last_spawn_time + arg_4_1.follow_time + arg_4_1.time_to_explode - arg_4_1.build_up_effect_time then
					if not arg_4_1.charge_played then
						arg_4_1.charge_played = true

						for k = 1, #arg_4_1.units do
							local var_4_10 = arg_4_1.units[k]

							if not ALIVE[var_4_10] then
								arg_4_1.audio_system:play_audio_unit_event("Play_winds_heavens_gamepay_charge", var_4_10)
							end
						end
					end

					local num = 100 - math.abs(last_spawn_time + arg_4_1.follow_time + arg_4_1.time_to_explode - arg_4_3) / arg_4_1.build_up_effect_time * 100
					local players = Managers.player:players()

					for k_2, v in pairs(players) do
						Managers.state.network.network_transmit:send_rpc("rpc_client_audio_set_global_parameter", v.peer_id, 6, num)
					end
				end
			elseif not (arg_4_1.hit_played or not (arg_4_3 > last_spawn_time + arg_4_1.follow_time + arg_4_1.time_to_explode)) then
				arg_4_1.hit_played = true

				for i5 = 1, #arg_4_1.units do
					local var_4_13 = arg_4_1.units[i5]

					if not ALIVE[var_4_13] then
						arg_4_1.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_hit", var_4_13)
					end
				end

				for i6 = 1, #arg_4_1._nav_cost_volume_ids do
					local var_4_14 = arg_4_1._nav_cost_volume_ids[i6]

					arg_4_1.ai_system:remove_nav_cost_map_volume(var_4_14, arg_4_1._nav_cost_map_id)
				end

				table.clear(arg_4_1._nav_cost_volume_ids)
			end
		end

		if not (not last_spawn_time and not (arg_4_3 > last_spawn_time + spawn_rate) or not (arg_4_1.num_spawns < arg_4_1.max_spawns)) then
			template.spawn_lightning_strike_unit(arg_4_1)

			arg_4_1.num_spawns = arg_4_1.num_spawns + 1
			arg_4_1.last_spawn_time = arg_4_1.last_spawn_time + spawn_rate
		elseif last_spawn_time == nil then
			arg_4_1.last_spawn_time = arg_4_3 - spawn_rate
		end
	end
}
