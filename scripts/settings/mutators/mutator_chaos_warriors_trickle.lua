-- chunkname: @scripts/settings/mutators/mutator_chaos_warriors_trickle.lua

return {
	description = "description_mutator_chaos_warrior_trickle",
	icon = "mutator_icon_powerful_elites",
	display_name = "display_name_mutator_chaos_warrior_trickle",
	server_initialize_function = function (arg_1_0, arg_1_1)
		local var_1_0 = Managers.state.difficulty:get_difficulty_rank()
		local var_1_1 = 2 + var_1_0 * 1
		local var_1_2 = {}

		for iter_1_0 = 1, var_1_1 do
			var_1_2[iter_1_0] = "chaos_warrior"
		end

		local var_1_3 = Managers.time:time("game")

		arg_1_1.spawn_list = var_1_2
		arg_1_1.spawn_at = var_1_3 + math.random(30, 50)
		arg_1_1.current_difficulty_rank = var_1_0
		arg_1_1.old_threat_value = Breeds.chaos_warrior.threat_value

		Managers.state.conflict:set_threat_value("chaos_warrior", 1)

		arg_1_1.side_id = Managers.state.side:get_side_from_name("dark_pact").side_id
	end,
	server_update_function = function (arg_2_0, arg_2_1)
		local var_2_0 = Managers.time:time("game")

		if var_2_0 > arg_2_1.spawn_at then
			local var_2_1 = arg_2_1.spawn_list
			local var_2_2 = Managers.state.conflict.horde_spawner
			local var_2_3 = false
			local var_2_4 = arg_2_1.side_id

			var_2_2:execute_custom_horde(var_2_1, var_2_3, var_2_4)

			local var_2_5 = 80 - arg_2_1.current_difficulty_rank * 5

			arg_2_1.spawn_at = var_2_0 + math.random(40, var_2_5)
		end
	end,
	server_stop_function = function (arg_3_0, arg_3_1)
		Managers.state.conflict:set_threat_value("chaos_warrior", arg_3_1.old_threat_value)
	end
}
