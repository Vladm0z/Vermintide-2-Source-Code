-- chunkname: @scripts/settings/mutators/mutator_geheimnisnacht_2021_hard_mode.lua

local var_0_0 = {
	chaos_warrior = {
		chance = 0.15,
		base_grudgemark_name = "elite_base",
		names = {
			"shockwave",
			"ignore_death_aura"
		}
	}
}

return {
	description = "description_mutator_geheimnisnacht_2021_hard_mode",
	display_name = "display_name_mutator_geheimnisnacht_2021_hard_mode",
	icon = "mutator_icon_geheimnisnacht_2021_difficulty",
	server_ai_spawned_function = function(arg_1_0, arg_1_1, arg_1_2)
		arg_1_1.enemies_to_be_buffed[#arg_1_1.enemies_to_be_buffed + 1] = arg_1_2
	end,
	server_stop_function = function(arg_2_0, arg_2_1, arg_2_2)
		if not arg_2_2 then
			Managers.telemetry_events:geheimnisnacht_hard_mode_toggled(false)
		end

		local var_2_0 = Managers.state.side:get_side_from_name("heroes"):enemy_units()
		local var_2_1 = #var_2_0

		for iter_2_0 = 1, var_2_1 do
			local var_2_2 = var_2_0[iter_2_0]

			if ALIVE[var_2_2] then
				local var_2_3 = ScriptUnit.has_extension(var_2_2, "buff_system")

				if var_2_3 then
					local var_2_4 = var_2_3:get_buff_type("geheimnisnacht_2021_event_health")

					if var_2_4 then
						var_2_3:remove_buff(var_2_4.id)
					end
				end
			end
		end
	end,
	client_start_function = function(arg_3_0, arg_3_1)
		local var_3_0 = true
		local var_3_1 = Localize("system_chat_geheimnisnacht_2021_hard_mode_on")

		Managers.chat:add_local_system_message(1, var_3_1, var_3_0)
	end,
	client_stop_function = function(arg_4_0, arg_4_1, arg_4_2)
		if not arg_4_2 then
			local var_4_0 = true
			local var_4_1 = Localize("system_chat_geheimnisnacht_2021_hard_mode_off")

			Managers.chat:add_local_system_message(1, var_4_1, var_4_0)
		end

		local var_4_2 = Managers.state.side:get_side_from_name("heroes"):enemy_units()
		local var_4_3 = #var_4_2

		for iter_4_0 = 1, var_4_3 do
			local var_4_4 = var_4_2[iter_4_0]

			if ALIVE[var_4_4] then
				local var_4_5 = ScriptUnit.has_extension(var_4_4, "buff_system")

				if var_4_5 then
					local var_4_6 = var_4_5:get_buff_type("geheimnisnacht_2021_event_health")

					if var_4_6 then
						var_4_5:remove_buff(var_4_6.id)
					end
				end
			end
		end
	end,
	server_start_function = function(arg_5_0, arg_5_1)
		Managers.telemetry_events:geheimnisnacht_hard_mode_toggled(true)

		local var_5_0 = Managers.state.side:get_side_from_name("heroes"):enemy_units()
		local var_5_1 = #var_5_0
		local var_5_2 = Managers.state.entity:system("buff_system")

		arg_5_1.enemies_to_be_buffed = {}

		for iter_5_0 = 1, var_5_1 do
			local var_5_3 = var_5_0[iter_5_0]

			if ALIVE[var_5_3] then
				local var_5_4 = ScriptUnit.has_extension(var_5_3, "buff_system")

				if var_5_4 then
					local var_5_5 = var_5_4:get_buff_type("geheimnisnacht_2021_event_health")

					if var_5_2 and not var_5_5 then
						var_5_2:add_buff(var_5_3, "geheimnisnacht_2021_event_horde_buff", var_5_3)
					end
				end
			end
		end
	end,
	server_update_function = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		local var_6_0 = arg_6_1.enemies_to_be_buffed

		if table.size(var_6_0) == 0 then
			return
		end

		local var_6_1 = Managers.state.network
		local var_6_2 = Managers.state.entity:system("buff_system")

		for iter_6_0 = #var_6_0, 1, -1 do
			local var_6_3 = var_6_0[iter_6_0]

			if var_6_1:unit_game_object_id(var_6_3) and var_6_2 then
				var_6_2:add_buff(var_6_3, "geheimnisnacht_2021_event_horde_buff", var_6_3)
				table.swap_delete(var_6_0, iter_6_0)
			end
		end
	end,
	post_ai_spawned_function = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		local var_7_0 = arg_7_2.name
		local var_7_1 = var_0_0[var_7_0]

		if var_7_1 then
			local var_7_2 = arg_7_1.grudge_mark_state_by_breed or {}

			arg_7_1.grudge_mark_state_by_breed = var_7_2

			local var_7_3
			local var_7_4 = arg_7_3.spawn_chance or var_7_1.chance
			local var_7_5 = var_7_2[var_7_0]
			local var_7_6, var_7_7 = PseudoRandomDistribution.flip_coin(var_7_5, var_7_4)
			local var_7_8

			var_7_2[var_7_0], var_7_8 = var_7_7, var_7_6

			if var_7_8 then
				local var_7_9 = var_7_1.names
				local var_7_10 = var_7_9[math.random(1, #var_7_9)]
				local var_7_11 = arg_7_3.enhancements or {}
				local var_7_12 = var_7_1.base_grudgemark_name

				if var_7_12 then
					var_7_11[#var_7_11 + 1] = BreedEnhancements[var_7_12]
				end

				var_7_11[#var_7_11 + 1] = BreedEnhancements[var_7_10]
				arg_7_3.enhancements = var_7_11
			end
		end
	end
}
