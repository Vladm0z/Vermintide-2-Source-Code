-- chunkname: @scripts/settings/mutators/mutator_explosive_loot_rats.lua

return {
	description = "description_explosive_loot_rats",
	icon = "mutator_icon_explosive_loot_rats",
	display_name = "display_name_explosive_loot_rats",
	server_initialize_function = function (arg_1_0, arg_1_1)
		-- function 1
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
		-- function 2
		arg_2_1.has_left_safe_zone = true

		local num = 20

		arg_2_1.spawn_loot_rats_at = Managers.time:time("game") + num
	end,
	server_update_function = function (arg_3_0, arg_3_1)
		-- function 3
		if not arg_3_1.has_left_safe_zone then
			return
		end

		local time = Managers.time:time("game")

		if not (global_is_inside_inn or not (time > arg_3_1.spawn_loot_rats_at)) then
			local get_difficulty = Managers.state.difficulty:get_difficulty()
			local var_3_2 = arg_3_1.amount_of_rats_per_difficulty[get_difficulty]
			local var_3_3 = arg_3_1.spawn_frequency_per_difficulty[get_difficulty]

			if not Managers.twitch:is_activated() then
				local var_3_4 = arg_3_1.spawn_frequency_per_difficulty_twitch_mode[get_difficulty]
			end

			local random = math.random(var_3_2[1], var_3_2[2])
			local random_2 = math.random(var_3_3[1], var_3_3[2])
			local tbl = {}

			for i = 1, random do
				tbl[#tbl + 1] = "skaven_explosive_loot_rat"
			end

			local conflict = Managers.state.conflict
			local flag = false
			local side_id = arg_3_1.side_id
			local main_path_info = conflict.main_path_info

			if main_path_info.ahead_unit or not main_path_info.behind_unit then
				conflict.horde_spawner:execute_custom_horde(tbl, flag, side_id)

				arg_3_1.spawn_loot_rats_at = time + random_2
			end
		end
	end,
	server_stop_function = function (arg_4_0, arg_4_1)
		-- function 4
		return
	end
}
