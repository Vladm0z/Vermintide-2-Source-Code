-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_versus_testify.lua

return {
	versus_has_lost = function(arg_1_0)
		return arg_1_0:is_about_to_end_game_early()
	end,
	versus_wait_for_local_player_hero_picking_turn = function(arg_2_0)
		local var_2_0 = arg_2_0:party_selection_logic()

		if not var_2_0 then
			return Testify.RETRY
		end

		local var_2_1 = Network.peer_id()
		local var_2_2 = 1
		local var_2_3 = Managers.party
		local var_2_4, var_2_5 = var_2_3:get_party_from_player_id(var_2_1, var_2_2)

		if not var_2_4 or var_2_5 < 1 then
			return Testify.RETRY
		end

		local var_2_6 = var_2_0:get_party_data(var_2_5)

		if not var_2_6 then
			return Testify.RETRY
		end

		local var_2_7 = var_2_6.current_picker_index

		if var_2_7 <= 0 then
			return Testify.RETRY
		end

		local var_2_8 = var_2_3:get_player_status(var_2_1, var_2_2)
		local var_2_9 = var_2_6.picker_list[var_2_7].status

		if not (var_2_5 == var_2_6.party_id and var_2_8.slot_id == var_2_9.slot_id) then
			return Testify.RETRY
		end
	end,
	versus_set_time = function(arg_3_0, arg_3_1)
		Managers.mechanism:game_mechanism():win_conditions():set_time(arg_3_1)
	end,
	versus_wait_for_initial_peers_spawned = function(arg_4_0)
		if not arg_4_0:initial_peers_spawned() then
			return Testify.RETRY
		end
	end
}
