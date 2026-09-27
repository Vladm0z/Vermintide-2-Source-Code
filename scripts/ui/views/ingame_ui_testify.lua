-- chunkname: @scripts/ui/views/ingame_ui_testify.lua

return {
	transition_with_fade = function (self, arg_1_1)
		-- function 1
		self:transition_with_fade(arg_1_1.transition, arg_1_1.transition_params)
	end,
	wait_for_active_view = function (self, arg_2_1)
		-- function 2
		if self.current_view ~= arg_2_1 then
			return Testify.RETRY
		end
	end,
	versus_select_random_available_hero = function (self)
		-- function 3
		fassert(self.current_view == "versus_party_char_selection_view", "TODO")

		local var_3_0 = self.views[self.current_view]
		local peer_id = Network.peer_id()
		local num = 1
		local get_party_from_player_id, var_3_4 = Managers.party:get_party_from_player_id(peer_id, num)

		if not (not get_party_from_player_id and not (var_3_4 < 1)) then
			return Testify.RETRY
		end

		local game_mode = Managers.state.game_mode

		game_mode = not game_mode and Managers.state.game_mode:game_mode()

		if not game_mode then
			return Testify.RETRY
		end

		local party_selection_logic = game_mode:party_selection_logic()

		if not party_selection_logic then
			return Testify.RETRY
		end

		local get_party_data = party_selection_logic:get_party_data(var_3_4)

		if not get_party_data then
			return Testify.RETRY
		end

		local get_random_available_character, var_3_9 = party_selection_logic:get_random_available_character(get_party_data)

		party_selection_logic:select_character(get_random_available_character, var_3_9)
	end
}
