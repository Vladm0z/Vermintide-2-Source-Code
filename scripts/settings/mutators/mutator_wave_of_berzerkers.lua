-- chunkname: @scripts/settings/mutators/mutator_wave_of_berzerkers.lua

return {
	description = "description_mutator_wave_of_berzerkers",
	icon = "mutator_icon_powerful_elites",
	display_name = "display_name_mutator_wave_of_berzerkers",
	server_initialize_function = function (arg_1_0, arg_1_1)
		-- function 1
		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local num = 5 + get_difficulty_rank * 2
		local tbl = {}

		for i = 1, num do
			tbl[i] = "chaos_berzerker"
		end

		local time = Managers.time:time("game")

		arg_1_1.spawn_list = tbl
		arg_1_1.spawn_at = time + math.random(30, 50)
		arg_1_1.current_difficulty_rank = get_difficulty_rank
		BreedActions.chaos_berzerker.frenzy_attack.attack_intensity = 0
		arg_1_1.old_threat_value = Breeds.chaos_berzerker.threat_value

		Managers.state.conflict:set_threat_value("chaos_berzerker", 1)

		arg_1_1.side_id = Managers.state.side:get_side_from_name("dark_pact").side_id
	end,
	server_update_function = function (arg_2_0, arg_2_1)
		-- function 2
		local time = Managers.time:time("game")

		if time > arg_2_1.spawn_at then
			local spawn_list = arg_2_1.spawn_list
			local horde_spawner = Managers.state.conflict.horde_spawner
			local flag = false
			local side_id = arg_2_1.side_id

			horde_spawner:execute_custom_horde(spawn_list, flag, side_id)

			local num = 80 - arg_2_1.current_difficulty_rank * 5

			arg_2_1.spawn_at = time + math.random(40, num)
		end
	end,
	server_stop_function = function (arg_3_0, arg_3_1)
		-- function 3
		BreedActions.chaos_berzerker.frenzy_attack.attack_intensity = nil

		Managers.state.conflict:set_threat_value("chaos_berzerker", arg_3_1.old_threat_value)
	end
}
