-- chunkname: @scripts/settings/mutators/mutator_escort.lua

return {
	screenspace_effect_name = "fx/screenspace_statue_veins/screenspace_statue_veins",
	display_name = "display_name_mutator_escort",
	time_until_explosion = 10,
	pickup_name = "mutator_statue_01",
	end_effect_required_duration = 4.5,
	icon = "mutator_icon_escort",
	description = "description_mutator_escort",
	screenspace_end_effect_name = "fx/screenspace_statue_veins/screenspace_statue_veins_fade_out",
	buildup_sound_global_parameter = "mutator_escort_buildup",
	packages = {
		"resource_packages/mutators/mutator_escort"
	},
	is_player_carrying_pickup = function (arg_1_0, arg_1_1)
		-- function 1
		local slot_name = AllPickups[arg_1_0].slot_name
		local PLAYER_AND_BOT_UNITS = arg_1_1.PLAYER_AND_BOT_UNITS

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_1_2 = PLAYER_AND_BOT_UNITS[i]

			if not ALIVE[var_1_2] then
				local get_slot_data = ScriptUnit.extension(var_1_2, "inventory_system"):get_slot_data(slot_name)
				local flag = not get_slot_data and get_slot_data.item_data

				if (not flag and flag.name) == arg_1_0 then
					return true
				end
			end
		end

		return false
	end,
	create_screen_space_effect = function (self, arg_2_1)
		-- function 2
		local player_unit = arg_2_1.local_player.player_unit

		if not ALIVE[player_unit] then
			local screenspace_effect_name = self.screenspace_effect_name

			arg_2_1.screen_effect_id = ScriptUnit.extension(player_unit, "first_person_system"):create_screen_particles(screenspace_effect_name)
			arg_2_1.screen_effect_t = Managers.time:time("game")
		end
	end,
	remove_screen_space_effect = function (self, arg_3_1)
		-- function 3
		local player_unit = arg_3_1.local_player.player_unit

		if not ALIVE[player_unit] and not arg_3_1.screen_effect_id then
			local extension = ScriptUnit.extension(player_unit, "first_person_system")
			local screen_effect_id = arg_3_1.screen_effect_id

			extension:destroy_screen_particles(screen_effect_id)

			if Managers.time:time("game") - arg_3_1.screen_effect_t > self.end_effect_required_duration then
				local screenspace_end_effect_name = self.screenspace_end_effect_name

				extension:create_screen_particles(screenspace_end_effect_name)
			end
		end

		arg_3_1.screen_effect_id = nil
		arg_3_1.screen_effect_t = nil
	end,
	server_start_function = function (arg_4_0, arg_4_1)
		-- function 4
		arg_4_1.server = {
			escort_unit_spawned = false
		}
		arg_4_1.hero_side = Managers.state.side:get_side_from_name("heroes")
	end,
	server_update_function = function (arg_5_0, arg_5_1)
		-- function 5
		local template = arg_5_1.template
		local pickup_name = template.pickup_name
		local server = arg_5_1.server
		local hero_side = arg_5_1.hero_side
		local PLAYER_UNITS = hero_side.PLAYER_UNITS

		if server.escort_unit_spawned or not PLAYER_UNITS[1] then
			local var_5_5 = PLAYER_UNITS[1]
			local var_5_6 = AllPickups[pickup_name]
			local slot_name = var_5_6.slot_name
			local item_name = var_5_6.item_name
			local extension = ScriptUnit.extension(var_5_5, "inventory_system")

			extension:destroy_slot(slot_name)
			extension:add_equipment(slot_name, item_name)

			local network_transmit = Managers.state.network.network_transmit
			local go_id = Managers.state.unit_storage:go_id(var_5_5)
			local var_5_12 = NetworkLookup.equipment_slots[slot_name]
			local var_5_13 = NetworkLookup.item_names[item_name]
			local var_5_14 = NetworkLookup.weapon_skins["n/a"]

			network_transmit:send_rpc_clients("rpc_add_equipment", go_id, var_5_12, var_5_13, var_5_14)
			extension:wield(slot_name)

			server.escort_unit_spawned = true
		elseif not server.escort_unit_spawned then
			local is_player_carrying_pickup = template.is_player_carrying_pickup(pickup_name, hero_side)

			if not is_player_carrying_pickup and not server.pickup_dropped_at_t then
				server.pickup_dropped_at_t = nil
				server.explosion_t = nil
			elseif not is_player_carrying_pickup then
				local time = Managers.time:time("game")

				if not server.pickup_dropped_at_t then
					server.pickup_dropped_at_t = time
					server.explosion_t = time + template.time_until_explosion
				end

				if not (not (time > server.explosion_t) or server.players_killed) then
					local PLAYER_AND_BOT_UNITS = arg_5_1.hero_side.PLAYER_AND_BOT_UNITS

					for i = 1, #PLAYER_AND_BOT_UNITS do
						local var_5_18 = PLAYER_AND_BOT_UNITS[i]

						if not ALIVE[var_5_18] then
							ScriptUnit.extension(var_5_18, "health_system"):die()
						end
					end

					server.players_killed = true
				end
			end
		end
	end,
	lose_condition_function = function (arg_6_0, arg_6_1)
		-- function 6
		local server = arg_6_1.server
		local time = Managers.time:time("game")
		local num = 2
		local explosion_t = server.explosion_t

		explosion_t = not explosion_t and time > server.explosion_t

		return explosion_t, num
	end,
	end_zone_activation_condition_function = function (arg_7_0, arg_7_1)
		-- function 7
		return arg_7_1.server.pickup_dropped_at_t == nil
	end,
	client_start_function = function (arg_8_0, arg_8_1)
		-- function 8
		local local_player = Managers.player:local_player()

		arg_8_1.client = {
			escort_unit_spawned = false,
			local_player = local_player
		}
		arg_8_1.hero_side = Managers.state.side:get_side_from_name("heroes")
	end,
	client_update_function = function (arg_9_0, arg_9_1)
		-- function 9
		local template = arg_9_1.template
		local pickup_name = template.pickup_name
		local is_player_carrying_pickup = template.is_player_carrying_pickup(pickup_name, arg_9_1.hero_side)
		local client = arg_9_1.client

		if not client.escort_unit_spawned then
			if not is_player_carrying_pickup and not client.pickup_dropped_at_t then
				client.pickup_dropped_at_t = nil
				client.explosion_t = nil

				template.remove_screen_space_effect(template, client)
			elseif not is_player_carrying_pickup then
				local time = Managers.time:time("game")

				if not client.pickup_dropped_at_t then
					client.pickup_dropped_at_t = time
					client.explosion_t = time + template.time_until_explosion

					template.create_screen_space_effect(template, client)
				end

				local auto_lerp = math.auto_lerp(client.pickup_dropped_at_t, client.explosion_t, 0, 1, time)

				Managers.state.entity:system("audio_system"):set_global_parameter(template.buildup_sound_global_parameter, auto_lerp)
			end
		elseif not is_player_carrying_pickup then
			client.escort_unit_spawned = true
		end
	end,
	client_stop_function = function (arg_10_0, arg_10_1)
		-- function 10
		local template = arg_10_1.template
		local client = arg_10_1.client

		if not client.screen_effect_id then
			template.remove_screen_space_effect(template, client)
		end
	end
}
