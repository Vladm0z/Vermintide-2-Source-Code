-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_versus_testify.lua

return {
	versus_has_lost = function (self)
		-- function 1
		return self:is_about_to_end_game_early()
	end,
	versus_wait_for_local_player_hero_picking_turn = function (self)
		-- function 2
		local party_selection_logic = self:party_selection_logic()

		if not party_selection_logic then
			return Testify.RETRY
		end

		local peer_id = Network.peer_id()
		local num = 1
		local party = Managers.party
		local get_party_from_player_id, var_2_5 = party:get_party_from_player_id(peer_id, num)

		if not (not get_party_from_player_id and not (var_2_5 < 1)) then
			return Testify.RETRY
		end

		local get_party_data = party_selection_logic:get_party_data(var_2_5)

		if not get_party_data then
			return Testify.RETRY
		end

		local current_picker_index = get_party_data.current_picker_index

		if current_picker_index <= 0 then
			return Testify.RETRY
		end

		local get_player_status = party:get_player_status(peer_id, num)
		local status = get_party_data.picker_list[current_picker_index].status

		if not (var_2_5 ~= get_party_data.party_id or get_player_status.slot_id == status.slot_id) then
			return Testify.RETRY
		end
	end,
	versus_set_time = function (arg_3_0, arg_3_1)
		-- function 3
		Managers.mechanism:game_mechanism():win_conditions():set_time(arg_3_1)
	end,
	versus_wait_for_initial_peers_spawned = function (self)
		-- function 4
		if not self:initial_peers_spawned() then
			return Testify.RETRY
		end
	end
}
