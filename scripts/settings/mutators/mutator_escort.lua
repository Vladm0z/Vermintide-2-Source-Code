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
	is_player_carrying_pickup = function(arg_1_0, arg_1_1)
		local var_1_0 = AllPickups[arg_1_0].slot_name
		local var_1_1 = arg_1_1.PLAYER_AND_BOT_UNITS

		for iter_1_0 = 1, #var_1_1 do
			local var_1_2 = var_1_1[iter_1_0]

			if ALIVE[var_1_2] then
				local var_1_3 = ScriptUnit.extension(var_1_2, "inventory_system"):get_slot_data(var_1_0)
				local var_1_4 = var_1_3 and var_1_3.item_data

				if (var_1_4 and var_1_4.name) == arg_1_0 then
					return true
				end
			end
		end

		return false
	end,
	create_screen_space_effect = function(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_1.local_player.player_unit

		if ALIVE[var_2_0] then
			local var_2_1 = arg_2_0.screenspace_effect_name

			arg_2_1.screen_effect_id = ScriptUnit.extension(var_2_0, "first_person_system"):create_screen_particles(var_2_1)
			arg_2_1.screen_effect_t = Managers.time:time("game")
		end
	end,
	remove_screen_space_effect = function(arg_3_0, arg_3_1)
		local var_3_0 = arg_3_1.local_player.player_unit

		if ALIVE[var_3_0] and arg_3_1.screen_effect_id then
			local var_3_1 = ScriptUnit.extension(var_3_0, "first_person_system")
			local var_3_2 = arg_3_1.screen_effect_id

			var_3_1:destroy_screen_particles(var_3_2)

			if Managers.time:time("game") - arg_3_1.screen_effect_t > arg_3_0.end_effect_required_duration then
				local var_3_3 = arg_3_0.screenspace_end_effect_name

				var_3_1:create_screen_particles(var_3_3)
			end
		end

		arg_3_1.screen_effect_id = nil
		arg_3_1.screen_effect_t = nil
	end,
	server_start_function = function(arg_4_0, arg_4_1)
		arg_4_1.server = {
			escort_unit_spawned = false
		}
		arg_4_1.hero_side = Managers.state.side:get_side_from_name("heroes")
	end,
	server_update_function = function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1.template
		local var_5_1 = var_5_0.pickup_name
		local var_5_2 = arg_5_1.server
		local var_5_3 = arg_5_1.hero_side
		local var_5_4 = var_5_3.PLAYER_UNITS

		if not var_5_2.escort_unit_spawned and var_5_4[1] then
			local var_5_5 = var_5_4[1]
			local var_5_6 = AllPickups[var_5_1]
			local var_5_7 = var_5_6.slot_name
			local var_5_8 = var_5_6.item_name
			local var_5_9 = ScriptUnit.extension(var_5_5, "inventory_system")

			var_5_9:destroy_slot(var_5_7)
			var_5_9:add_equipment(var_5_7, var_5_8)

			local var_5_10 = Managers.state.network.network_transmit
			local var_5_11 = Managers.state.unit_storage:go_id(var_5_5)
			local var_5_12 = NetworkLookup.equipment_slots[var_5_7]
			local var_5_13 = NetworkLookup.item_names[var_5_8]
			local var_5_14 = NetworkLookup.weapon_skins["n/a"]

			var_5_10:send_rpc_clients("rpc_add_equipment", var_5_11, var_5_12, var_5_13, var_5_14)
			var_5_9:wield(var_5_7)

			var_5_2.escort_unit_spawned = true
		elseif var_5_2.escort_unit_spawned then
			local var_5_15 = var_5_0.is_player_carrying_pickup(var_5_1, var_5_3)

			if var_5_15 and var_5_2.pickup_dropped_at_t then
				var_5_2.pickup_dropped_at_t = nil
				var_5_2.explosion_t = nil
			elseif not var_5_15 then
				local var_5_16 = Managers.time:time("game")

				if not var_5_2.pickup_dropped_at_t then
					var_5_2.pickup_dropped_at_t = var_5_16
					var_5_2.explosion_t = var_5_16 + var_5_0.time_until_explosion
				end

				if var_5_16 > var_5_2.explosion_t and not var_5_2.players_killed then
					local var_5_17 = arg_5_1.hero_side.PLAYER_AND_BOT_UNITS

					for iter_5_0 = 1, #var_5_17 do
						local var_5_18 = var_5_17[iter_5_0]

						if ALIVE[var_5_18] then
							ScriptUnit.extension(var_5_18, "health_system"):die()
						end
					end

					var_5_2.players_killed = true
				end
			end
		end
	end,
	lose_condition_function = function(arg_6_0, arg_6_1)
		local var_6_0 = arg_6_1.server
		local var_6_1 = Managers.time:time("game")
		local var_6_2 = 2

		return var_6_0.explosion_t and var_6_1 > var_6_0.explosion_t, var_6_2
	end,
	end_zone_activation_condition_function = function(arg_7_0, arg_7_1)
		return arg_7_1.server.pickup_dropped_at_t == nil
	end,
	client_start_function = function(arg_8_0, arg_8_1)
		local var_8_0 = Managers.player:local_player()

		arg_8_1.client = {
			escort_unit_spawned = false,
			local_player = var_8_0
		}
		arg_8_1.hero_side = Managers.state.side:get_side_from_name("heroes")
	end,
	client_update_function = function(arg_9_0, arg_9_1)
		local var_9_0 = arg_9_1.template
		local var_9_1 = var_9_0.pickup_name
		local var_9_2 = var_9_0.is_player_carrying_pickup(var_9_1, arg_9_1.hero_side)
		local var_9_3 = arg_9_1.client

		if var_9_3.escort_unit_spawned then
			if var_9_2 and var_9_3.pickup_dropped_at_t then
				var_9_3.pickup_dropped_at_t = nil
				var_9_3.explosion_t = nil

				var_9_0.remove_screen_space_effect(var_9_0, var_9_3)
			elseif not var_9_2 then
				local var_9_4 = Managers.time:time("game")

				if not var_9_3.pickup_dropped_at_t then
					var_9_3.pickup_dropped_at_t = var_9_4
					var_9_3.explosion_t = var_9_4 + var_9_0.time_until_explosion

					var_9_0.create_screen_space_effect(var_9_0, var_9_3)
				end

				local var_9_5 = math.auto_lerp(var_9_3.pickup_dropped_at_t, var_9_3.explosion_t, 0, 1, var_9_4)

				Managers.state.entity:system("audio_system"):set_global_parameter(var_9_0.buildup_sound_global_parameter, var_9_5)
			end
		elseif var_9_2 then
			var_9_3.escort_unit_spawned = true
		end
	end,
	client_stop_function = function(arg_10_0, arg_10_1)
		local var_10_0 = arg_10_1.template
		local var_10_1 = arg_10_1.client

		if var_10_1.screen_effect_id then
			var_10_0.remove_screen_space_effect(var_10_0, var_10_1)
		end
	end
}
