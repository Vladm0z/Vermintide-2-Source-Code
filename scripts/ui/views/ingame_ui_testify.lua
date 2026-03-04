-- chunkname: @scripts/ui/views/ingame_ui_testify.lua

return {
	transition_with_fade = function (arg_1_0, arg_1_1)
		arg_1_0:transition_with_fade(arg_1_1.transition, arg_1_1.transition_params)
	end,
	wait_for_active_view = function (arg_2_0, arg_2_1)
		if arg_2_0.current_view ~= arg_2_1 then
			return Testify.RETRY
		end
	end,
	versus_select_random_available_hero = function (arg_3_0)
		fassert(arg_3_0.current_view == "versus_party_char_selection_view", "TODO")

		local var_3_0 = arg_3_0.views[arg_3_0.current_view]
		local var_3_1 = Network.peer_id()
		local var_3_2 = 1
		local var_3_3, var_3_4 = Managers.party:get_party_from_player_id(var_3_1, var_3_2)

		if not var_3_3 or var_3_4 < 1 then
			return Testify.RETRY
		end

		local var_3_5 = Managers.state.game_mode and Managers.state.game_mode:game_mode()

		if not var_3_5 then
			return Testify.RETRY
		end

		local var_3_6 = var_3_5:party_selection_logic()

		if not var_3_6 then
			return Testify.RETRY
		end

		local var_3_7 = var_3_6:get_party_data(var_3_4)

		if not var_3_7 then
			return Testify.RETRY
		end

		local var_3_8, var_3_9 = var_3_6:get_random_available_character(var_3_7)

		var_3_6:select_character(var_3_8, var_3_9)
	end
}
