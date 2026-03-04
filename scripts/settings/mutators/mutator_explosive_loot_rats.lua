-- chunkname: @scripts/settings/mutators/mutator_explosive_loot_rats.lua

return {
	description = "description_explosive_loot_rats",
	icon = "mutator_icon_explosive_loot_rats",
	display_name = "display_name_explosive_loot_rats",
	server_initialize_function = function (arg_1_0, arg_1_1)
		arg_1_1.amount_of_rats_per_difficulty = {
			normal = {
				3,
				5
			},
			hard = {
				4,
				7
			},
			harder = {
				6,
				9
			},
			hardest = {
				7,
				11
			},
			cataclysm = {
				9,
				13
			}
		}
		arg_1_1.spawn_frequency_per_difficulty = {
			normal = {
				68,
				80
			},
			hard = {
				60,
				72
			},
			harder = {
				56,
				70
			},
			hardest = {
				48,
				64
			},
			cataclysm = {
				40,
				56
			}
		}
		arg_1_1.spawn_frequency_per_difficulty_twitch_mode = {
			normal = {
				34,
				40
			},
			hard = {
				30,
				36
			},
			harder = {
				28,
				35
			},
			hardest = {
				24,
				32
			},
			cataclysm = {
				20,
				28
			}
		}
		arg_1_1.side_id = Managers.state.side:get_side_from_name("dark_pact").side_id
	end,
	server_players_left_safe_zone = function (arg_2_0, arg_2_1)
		arg_2_1.has_left_safe_zone = true

		local var_2_0 = 20

		arg_2_1.spawn_loot_rats_at = Managers.time:time("game") + var_2_0
	end,
	server_update_function = function (arg_3_0, arg_3_1)
		if not arg_3_1.has_left_safe_zone then
			return
		end

		local var_3_0 = Managers.time:time("game")

		if not global_is_inside_inn and var_3_0 > arg_3_1.spawn_loot_rats_at then
			local var_3_1 = Managers.state.difficulty:get_difficulty()
			local var_3_2 = arg_3_1.amount_of_rats_per_difficulty[var_3_1]
			local var_3_3 = arg_3_1.spawn_frequency_per_difficulty[var_3_1]

			if Managers.twitch:is_activated() then
				local var_3_4 = arg_3_1.spawn_frequency_per_difficulty_twitch_mode[var_3_1]
			end

			local var_3_5 = math.random(var_3_2[1], var_3_2[2])
			local var_3_6 = math.random(var_3_3[1], var_3_3[2])
			local var_3_7 = {}

			for iter_3_0 = 1, var_3_5 do
				var_3_7[#var_3_7 + 1] = "skaven_explosive_loot_rat"
			end

			local var_3_8 = Managers.state.conflict
			local var_3_9 = false
			local var_3_10 = arg_3_1.side_id
			local var_3_11 = var_3_8.main_path_info

			if var_3_11.ahead_unit or var_3_11.behind_unit then
				var_3_8.horde_spawner:execute_custom_horde(var_3_7, var_3_9, var_3_10)

				arg_3_1.spawn_loot_rats_at = var_3_0 + var_3_6
			end
		end
	end,
	server_stop_function = function (arg_4_0, arg_4_1)
		return
	end
}
