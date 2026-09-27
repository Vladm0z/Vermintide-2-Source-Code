-- chunkname: @scripts/settings/mutators/mutator_geheimnisnacht_2021_hard_mode.lua

local tbl = {
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
	server_ai_spawned_function = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		arg_1_1.enemies_to_be_buffed[#arg_1_1.enemies_to_be_buffed + 1] = arg_1_2
	end,
	server_stop_function = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		if not arg_2_2 then
			Managers.telemetry_events:geheimnisnacht_hard_mode_toggled(false)
		end

		local enemy_units = Managers.state.side:get_side_from_name("heroes"):enemy_units()
		local count = #enemy_units

		for i = 1, count do
			local var_2_2 = enemy_units[i]

			if not ALIVE[var_2_2] then
				local has_extension = ScriptUnit.has_extension(var_2_2, "buff_system")

				if not has_extension then
					local get_buff_type = has_extension:get_buff_type("geheimnisnacht_2021_event_health")

					if not get_buff_type then
						has_extension:remove_buff(get_buff_type.id)
					end
				end
			end
		end
	end,
	client_start_function = function (arg_3_0, arg_3_1)
		-- function 3
		local flag = true
		local var_3_1 = Localize("system_chat_geheimnisnacht_2021_hard_mode_on")

		Managers.chat:add_local_system_message(1, var_3_1, flag)
	end,
	client_stop_function = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		if not arg_4_2 then
			local flag = true
			local var_4_1 = Localize("system_chat_geheimnisnacht_2021_hard_mode_off")

			Managers.chat:add_local_system_message(1, var_4_1, flag)
		end

		local enemy_units = Managers.state.side:get_side_from_name("heroes"):enemy_units()
		local count = #enemy_units

		for i = 1, count do
			local var_4_4 = enemy_units[i]

			if not ALIVE[var_4_4] then
				local has_extension = ScriptUnit.has_extension(var_4_4, "buff_system")

				if not has_extension then
					local get_buff_type = has_extension:get_buff_type("geheimnisnacht_2021_event_health")

					if not get_buff_type then
						has_extension:remove_buff(get_buff_type.id)
					end
				end
			end
		end
	end,
	server_start_function = function (arg_5_0, arg_5_1)
		-- function 5
		Managers.telemetry_events:geheimnisnacht_hard_mode_toggled(true)

		local enemy_units = Managers.state.side:get_side_from_name("heroes"):enemy_units()
		local count = #enemy_units
		local system = Managers.state.entity:system("buff_system")

		arg_5_1.enemies_to_be_buffed = {}

		for i = 1, count do
			local var_5_3 = enemy_units[i]

			if not ALIVE[var_5_3] then
				local has_extension = ScriptUnit.has_extension(var_5_3, "buff_system")

				if not has_extension then
					local get_buff_type = has_extension:get_buff_type("geheimnisnacht_2021_event_health")

					if not (not system and get_buff_type) then
						system:add_buff(var_5_3, "geheimnisnacht_2021_event_horde_buff", var_5_3)
					end
				end
			end
		end
	end,
	server_update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		local enemies_to_be_buffed = arg_6_1.enemies_to_be_buffed

		if table.size(enemies_to_be_buffed) == 0 then
			return
		end

		local network = Managers.state.network
		local system = Managers.state.entity:system("buff_system")

		for i = #enemies_to_be_buffed, 1, -1 do
			local var_6_3 = enemies_to_be_buffed[i]

			if not network:unit_game_object_id(var_6_3) and not system then
				system:add_buff(var_6_3, "geheimnisnacht_2021_event_horde_buff", var_6_3)
				table.swap_delete(enemies_to_be_buffed, i)
			end
		end
	end,
	post_ai_spawned_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		local name = arg_7_2.name
		local var_7_1 = tbl[name]

		if not var_7_1 then
			local grudge_mark_state_by_breed = arg_7_1.grudge_mark_state_by_breed

			grudge_mark_state_by_breed = grudge_mark_state_by_breed or {}
			arg_7_1.grudge_mark_state_by_breed = grudge_mark_state_by_breed

			local var_7_3
			local spawn_chance = arg_7_3.spawn_chance

			spawn_chance = spawn_chance or var_7_1.chance

			local var_7_5 = grudge_mark_state_by_breed[name]
			local flip_coin, var_7_7 = PseudoRandomDistribution.flip_coin(var_7_5, spawn_chance)
			local var_7_8

			grudge_mark_state_by_breed[name], var_7_8 = var_7_7, flip_coin

			if not var_7_8 then
				local names = var_7_1.names
				local var_7_10 = names[math.random(1, #names)]
				local enhancements = arg_7_3.enhancements

				enhancements = enhancements or {}

				local base_grudgemark_name = var_7_1.base_grudgemark_name

				if not base_grudgemark_name then
					enhancements[#enhancements + 1] = BreedEnhancements[base_grudgemark_name]
				end

				enhancements[#enhancements + 1] = BreedEnhancements[var_7_10]
				arg_7_3.enhancements = enhancements
			end
		end
	end
}
