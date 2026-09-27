-- chunkname: @scripts/settings/mutators/mutator_chasing_spirits.lua

local num = 5

return {
	description = "chasing_spirits_mutator_desc",
	chase_time = 5,
	delay_time = 2,
	chase_speed = 1,
	spirit_power_level = 200,
	icon = "mutator_icon_death_spirits",
	display_name = "chasing_spirits_mutator_name",
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
		local num_2 = num * num

		for k, v in pairs(spirits) do
			local flag = not v and v.unit

			if not (not flag and v.delay_time ~= 0) then
				local local_position = Unit.local_position(flag, 0)
				local follow_unit = v.follow_unit
				local var_2_6 = POSITION_LOOKUP[follow_unit]

				if not var_2_6 then
					local num_3 = var_2_6 + Vector3.up()
					local num_4 = num_3 - local_position
					local length_squared = Vector3.length_squared(num_4)
					local normalize = Vector3.normalize(num_4)

					if length_squared <= num_2 then
						local death_explosion = DamageProfileTemplates.death_explosion
						local spirit_power_level = arg_2_1.spirit_power_level

						DamageUtils.add_damage_network_player(death_explosion, nil, spirit_power_level, follow_unit, flag, "full", num_3, normalize, "undefined", nil, 0, false, nil, false, 0, 1)

						local world_rotation = Unit.world_rotation(flag, 0)

						Managers.state.entity:system("area_damage_system"):create_explosion(flag, local_position, world_rotation, "death_spirit_bomb", 1, "undefined", 0, false)
						arg_2_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", flag)
						Managers.state.unit_spawner:mark_for_deletion(flag)

						arg_2_1.spirits[k] = nil
					end
				end
			end
		end

		for k_2, v_2 in pairs(spirits) do
			local unit = v_2.unit

			if not ALIVE[unit] then
				if v_2.delay_time == 0 then
					local local_position_2 = Unit.local_position(unit, 0)
					local follow_unit_2 = v_2.follow_unit
					local var_2_17 = POSITION_LOOKUP[follow_unit_2]

					if not var_2_17 then
						v_2.chase_time = math.max(v_2.chase_time - arg_2_2, 0)

						local local_position_3 = Unit.local_position(unit, 0)
						local num_5 = var_2_17 + Vector3.up() - local_position_3
						local num_6 = local_position_3 + Vector3.normalize(num_5) * (arg_2_2 * arg_2_1.chase_speed)

						Unit.set_local_position(unit, 0, num_6)

						if v_2.chase_time == 0 then
							local world_rotation_2 = Unit.world_rotation(unit, 0)

							Managers.state.entity:system("area_damage_system"):create_explosion(unit, local_position_2, world_rotation_2, "death_spirit_bomb", 1, "undefined", 0, false)
							arg_2_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", unit)
							Managers.state.unit_spawner:mark_for_deletion(unit)

							arg_2_1.spirits[k_2] = nil
						end
					end
				else
					v_2.delay_time = math.max(v_2.delay_time - arg_2_2, 0)
				end
			else
				arg_2_1.spirits[k_2] = nil
			end
		end
	end,
	server_ai_hit_by_player_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		if not arg_3_1.can_spawn then
			return
		end

		if not DamageUtils.is_player_unit(arg_3_3) then
			return
		end

		if not Unit.get_data(arg_3_2, "breed").boss then
			local unit_game_object_id = arg_3_1.network_manager:unit_game_object_id(arg_3_2)

			if not arg_3_1.boss_drop_timers[unit_game_object_id] then
				arg_3_1.boss_drop_timers[unit_game_object_id] = {
					timer = arg_3_1.boss_drop_cooldown
				}
			end

			if arg_3_1.boss_drop_timers[unit_game_object_id].timer >= arg_3_1.boss_drop_cooldown then
				arg_3_1.template.spawn_spirit(arg_3_1, arg_3_2, arg_3_3)

				arg_3_1.boss_drop_timers[unit_game_object_id].timer = 0
			end
		end
	end,
	server_player_hit_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		local var_4_0 = arg_4_4[2]
		local is_player_unit = DamageUtils.is_player_unit(arg_4_2)

		if var_4_0 ~= "death_explosion" or not is_player_unit then
			local network_manager = arg_4_1.network_manager
			local mutator = NetworkLookup.heal_types.mutator
			local var_4_4 = arg_4_4[1]
			local unit_game_object_id = network_manager:unit_game_object_id(arg_4_2)

			network_manager.network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, var_4_4, mutator)
		end
	end,
	server_ai_killed_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		if not arg_5_1.can_spawn then
			return
		end

		if not DamageUtils.is_player_unit(arg_5_3) then
			return
		end

		arg_5_1.template.spawn_spirit(arg_5_1, arg_5_2, arg_5_3)
	end,
	server_players_left_safe_zone = function (arg_6_0, arg_6_1)
		-- function 6
		arg_6_1.has_left_safe_zone = true
	end,
	server_start_function = function (arg_7_0, arg_7_1)
		-- function 7
		printf("[Mutator]: mutator_start")

		arg_7_1.spirit_power_level = arg_7_1.template.spirit_power_level
		arg_7_1.delay_time = arg_7_1.template.delay_time
		arg_7_1.chase_speed = arg_7_1.template.chase_speed
		arg_7_1.chase_time = arg_7_1.template.chase_time
		arg_7_1.audio_system = Managers.state.entity:system("audio_system")
		arg_7_1.network_manager = Managers.state.network
		arg_7_1.unit_spawner = Managers.state.unit_spawner
		arg_7_1.boss_drop_timers = {}
		arg_7_1.boss_drop_cooldown = 2
		arg_7_1.spirits = {}
		arg_7_1.spirit_unit_name = "units/fx/vfx_animation_death_spirit_02"
		arg_7_1.extension_init_data = {}
		arg_7_1.offset = 1
		arg_7_1.can_spawn = true
	end,
	server_stop_function = function (arg_8_0, arg_8_1)
		-- function 8
		local spirits = arg_8_1.spirits

		for k, v in pairs(spirits) do
			local unit = v.unit

			if not ALIVE[unit] then
				local local_position = Unit.local_position(unit, 0)
				local world_rotation = Unit.world_rotation(unit, 0)

				Managers.state.entity:system("area_damage_system"):create_explosion(unit, local_position, world_rotation, "death_spirit_bomb", 1, "undefined", 0, false)
				arg_8_1.audio_system:play_audio_unit_event("Play_winds_death_gameplay_spirit_explode", unit)
				Managers.state.unit_spawner:mark_for_deletion(unit)

				arg_8_1.spirits[k] = nil
			end
		end
	end,
	server_update_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		if not (not Managers.state.network and Managers.state.network:game()) then
			return
		end

		for k, v in pairs(arg_9_1.boss_drop_timers) do
			v.timer = v.timer + arg_9_2
		end

		if not (not arg_9_1.can_spawn and not (arg_9_3 >= arg_9_1.deactivate_at_t - 5)) then
			arg_9_1.can_spawn = false
		end

		arg_9_1.template.update_spirits(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	end
}
