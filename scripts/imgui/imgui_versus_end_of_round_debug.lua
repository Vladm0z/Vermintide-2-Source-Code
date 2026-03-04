-- chunkname: @scripts/imgui/imgui_versus_end_of_round_debug.lua

ImguiVersusEndOfRoundDebug = class(ImguiVersusEndOfRoundDebug)

local var_0_0 = Gui
local var_0_1 = Imgui
local var_0_2 = true

function ImguiVersusEndOfRoundDebug.init(arg_1_0)
	arg_1_0._max_score = 0
	arg_1_0._local_player_team_available_score = 0
	arg_1_0._opponent_team_available_score = 0
	arg_1_0._num_rounds = 0
	arg_1_0._current_set = 0
	arg_1_0._current_round = 0
	arg_1_0._local_player_unclaimed_points = {}
	arg_1_0._opponent_player_unclaimed_points = {}
	arg_1_0._score_threshold = 0
	arg_1_0._local_player_score = 0
	arg_1_0._local_player_score_to_win = 0
	arg_1_0._opponent_team_score = 0
	arg_1_0._opponent_team_score_to_win = 0
	arg_1_0._winning_party_id = 0
	arg_1_0._winning_party_score_to_win = 0
	arg_1_0._limit_score_to_round = true
	arg_1_0._score_to_add = 0
end

function ImguiVersusEndOfRoundDebug.update(arg_2_0)
	if var_0_2 then
		arg_2_0:init()

		var_0_2 = false
	end
end

function ImguiVersusEndOfRoundDebug.on_show(arg_3_0)
	arg_3_0._active = true
end

function ImguiVersusEndOfRoundDebug.on_hide(arg_4_0)
	arg_4_0._active = false
end

function ImguiVersusEndOfRoundDebug.draw(arg_5_0, arg_5_1)
	return (arg_5_0:_do_main_window())
end

function ImguiVersusEndOfRoundDebug.is_persistent(arg_6_0)
	return true
end

function ImguiVersusEndOfRoundDebug._do_main_window(arg_7_0)
	if arg_7_0._first_launch then
		local var_7_0, var_7_1 = Application.resolution()

		var_0_1.set_next_window_size(var_7_0 * 0.4, var_7_1 * 0.7)
	end

	local var_7_2 = var_0_1.begin_window("Versus End of Round Debug", "menu_bar")

	repeat
		if Managers.level_transition_handler:get_current_game_mode() ~= "versus" then
			var_0_1.text_colored("You have to be in a versus match to use this tool", 255, 0, 0, 255)

			break
		end

		if not arg_7_0:_get_win_conditions() then
			var_0_1.text_colored("No Win Conditions", 255, 0, 0, 255)

			break
		end

		arg_7_0:_collect_data_for_preview()
		arg_7_0:_do_preview()
	until true

	var_0_1:end_window()

	return var_7_2
end

function ImguiVersusEndOfRoundDebug._get_win_conditions(arg_8_0)
	return (Managers.mechanism:game_mechanism():win_conditions())
end

function ImguiVersusEndOfRoundDebug._get_round_count(arg_9_0)
	return (arg_9_0:_get_win_conditions():get_current_round())
end

function ImguiVersusEndOfRoundDebug._get_current_set(arg_10_0)
	local var_10_0 = arg_10_0:_get_win_conditions():get_current_round()

	return math.round(var_10_0 / 2)
end

function ImguiVersusEndOfRoundDebug._get_num_rounds(arg_11_0)
	return (Managers.mechanism:game_mechanism():num_sets())
end

function ImguiVersusEndOfRoundDebug._collect_data_for_preview(arg_12_0)
	local var_12_0 = arg_12_0:_get_win_conditions()
	local var_12_1 = arg_12_0:_get_current_set()
	local var_12_2 = arg_12_0:_get_round_count()
	local var_12_3 = arg_12_0:_get_num_rounds()
	local var_12_4 = Managers.level_transition_handler:get_current_level_key()
	local var_12_5 = VersusObjectiveSettings[var_12_4].max_score
	local var_12_6 = Network.peer_id()
	local var_12_7 = 1
	local var_12_8, var_12_9 = Managers.party:get_party_from_player_id(var_12_6, var_12_7)
	local var_12_10 = arg_12_0._local_player_party_id and arg_12_0._local_player_party_id or var_12_9 == 0 and 1 or var_12_9
	local var_12_11 = arg_12_0._opponent_party_id and arg_12_0._opponent_party_id or var_12_9 == 1 and 2 or 1
	local var_12_12 = var_12_0:get_total_score(var_12_10)
	local var_12_13 = var_12_0:get_sets_data_for_party(var_12_10)
	local var_12_14 = var_12_0:get_total_score(var_12_11)
	local var_12_15 = var_12_0:get_sets_data_for_party(var_12_11)
	local var_12_16 = var_12_5
	local var_12_17 = var_12_5
	local var_12_18 = Managers.player:local_player()
	local var_12_19 = Managers.state.side and Managers.state.side:get_side_from_player_unique_id(var_12_18:unique_id())
	local var_12_20 = var_12_19 and var_12_19:name() == "heroes"
	local var_12_21 = Managers.mechanism:get_state()
	local var_12_22 = Managers.state.game_mode and Managers.state.game_mode:game_mode()
	local var_12_23

	var_12_23 = var_12_22 and var_12_22:match_in_round_over_state()

	local var_12_24 = false
	local var_12_25 = false

	if var_12_2 % var_12_1 ~= 0 then
		var_12_24 = var_12_20
		var_12_25 = not var_12_20
	elseif var_12_2 % var_12_1 == 0 then
		var_12_24 = true
		var_12_25 = true
	end

	for iter_12_0 = 1, var_12_3 do
		local var_12_26 = var_12_13[iter_12_0]
		local var_12_27 = var_12_15[iter_12_0]

		if iter_12_0 < var_12_1 then
			var_12_16 = var_12_16 - (var_12_26.max_points - var_12_26.claimed_points or 0)
			var_12_17 = var_12_17 - (var_12_27.max_points - var_12_27.claimed_points or 0)
		end
	end

	local var_12_28 = var_12_16 < var_12_17 and var_12_16 or var_12_17
	local var_12_29 = var_12_28 - var_12_12
	local var_12_30 = var_12_28 - var_12_14
	local var_12_31 = var_12_3 >= var_12_1 + 1 and var_12_1 + 1 or var_12_3
	local var_12_32

	var_12_32 = var_12_31 == var_12_3

	local var_12_33 = 0
	local var_12_34 = 0

	if var_12_24 and var_12_25 then
		var_12_33 = var_12_14 + var_12_15[var_12_31].max_points
		var_12_34 = var_12_12 + var_12_13[var_12_31].max_points
	else
		local var_12_35 = var_12_15[var_12_1]

		var_12_33 = var_12_14 + (var_12_35.max_points - var_12_35.claimed_points)

		local var_12_36 = var_12_13[var_12_1]

		var_12_34 = var_12_12 + (var_12_36.max_points - var_12_36.claimed_points)
	end

	if var_12_29 < var_12_30 then
		if var_12_29 < var_12_13[var_12_31].max_points then
			arg_12_0._winning_party_id = var_12_10
			arg_12_0._winning_party_score_to_win = var_12_29 + 1
		end
	elseif var_12_30 < var_12_29 then
		if var_12_30 < var_12_15[var_12_31].max_points then
			arg_12_0._winning_party_id = var_12_11
			arg_12_0._winning_party_score_to_win = var_12_30 + 1
		end
	elseif var_12_29 < var_12_13[var_12_31].max_points then
		arg_12_0._winning_party_id = var_12_10
		arg_12_0._winning_party_score_to_win = var_12_29 + 1
	end

	arg_12_0._local_player_party_id = var_12_10
	arg_12_0._opponent_party_id = var_12_11
	arg_12_0._level_name = var_12_4
	arg_12_0._match_state = var_12_21
	arg_12_0._game_mode_state = var_12_22 and var_12_22:game_mode_state()
	arg_12_0._max_score = var_12_5
	arg_12_0._local_player_team_available_score = var_12_16
	arg_12_0._opponent_team_available_score = var_12_17
	arg_12_0._num_rounds = var_12_3
	arg_12_0._current_set = var_12_1
	arg_12_0._current_round = var_12_2
	arg_12_0._local_player_has_played_round = var_12_24
	arg_12_0._opponent_has_played_round = var_12_25
	arg_12_0._local_player_sets_data = var_12_13
	arg_12_0._opponent_player_sets_data = var_12_15
	arg_12_0._score_threshold = var_12_28
	arg_12_0._local_player_score = var_12_12
	arg_12_0._opponent_team_score = var_12_14
	arg_12_0._local_player_predicted_score = var_12_34
	arg_12_0._opponent_predicted_score = var_12_33
	arg_12_0._local_player_score_to_win = var_12_29
	arg_12_0._opponent_team_score_to_win = var_12_30
end

function ImguiVersusEndOfRoundDebug._do_preview(arg_13_0)
	arg_13_0:_do_add_score()
	var_0_1.dummy(2, 5)
	arg_13_0:_do_end_round()
	var_0_1.dummy(2, 5)
	var_0_1.text_colored("Level Key: " .. tostring(arg_13_0._level_name), 125, 125, 255, 255)
	var_0_1.text_colored("Match State: " .. tostring(arg_13_0._match_state), 125, 125, 255, 255)
	var_0_1.text_colored("Game Mode State: " .. tostring(arg_13_0._game_mode_state), 125, 125, 255, 255)
	var_0_1.text_colored("Max Level Score: " .. tostring(arg_13_0._max_score), 255, 125, 125, 255)
	var_0_1.text_colored("Local Player Team Max Available Score: " .. tostring(arg_13_0._local_player_team_available_score), 255, 125, 125, 255)
	var_0_1.text_colored("Opponent Team Max Available Score: " .. tostring(arg_13_0._opponent_team_available_score), 255, 125, 125, 255)
	var_0_1.text_colored("Number of Rounds (Sets): " .. tostring(arg_13_0._num_rounds), 255, 125, 125, 255)
	var_0_1.text_colored("Current Set: " .. tostring(arg_13_0._current_set), 255, 125, 125, 255)
	var_0_1.text_colored("Current Round: " .. tostring(arg_13_0._current_round), 255, 125, 125, 255)
	var_0_1.text_colored("Has Local Player Played Current Round: " .. tostring(arg_13_0._local_player_has_played_round), 255, 125, 125, 255)
	var_0_1.text_colored("Has Opponent Played Current Round: " .. tostring(arg_13_0._opponent_has_played_round), 255, 125, 125, 255)
	var_0_1.text_colored("Score Threshold: " .. tostring(arg_13_0._score_threshold), 255, 125, 125, 255)
	var_0_1.text_colored("Local Player Team Score: " .. tostring(arg_13_0._local_player_score), 255, 125, 125, 255)
	var_0_1.text_colored("Local Player Team Score to Win: " .. tostring(arg_13_0._local_player_score_to_win), 255, 125, 125, 255)
	var_0_1.text_colored("Local Player Team Predicted Score: " .. tostring(arg_13_0._local_player_predicted_score), 125, 255, 125, 255)
	var_0_1.text_colored("Opponent Team Score: " .. tostring(arg_13_0._opponent_team_score), 255, 125, 125, 255)
	var_0_1.text_colored("Opponent Team Score to Win: " .. tostring(arg_13_0._opponent_team_score_to_win), 255, 125, 125, 255)
	var_0_1.text_colored("Opponent Team Predicted Score: " .. tostring(arg_13_0._opponent_predicted_score), 125, 255, 125, 255)
	var_0_1.text_colored("Winning Party ID: " .. tostring(arg_13_0._winning_party_id), 125, 255, 125, 255)
	var_0_1.text_colored("Winning Party Score To Win: " .. tostring(arg_13_0._winning_party_score_to_win), 125, 255, 125, 255)
	var_0_1.dummy(2, 5)
	arg_13_0:_do_sets_data_preview()
end

function ImguiVersusEndOfRoundDebug._do_add_score(arg_14_0)
	script_data.disable_gamemode_end = var_0_1.checkbox("Disable Gamemode End", not not script_data.disable_gamemode_end)
	arg_14_0._limit_score_to_round = var_0_1.checkbox("Limit the score that can be added to the max score for this round", arg_14_0._limit_score_to_round)
	arg_14_0._score_to_add = var_0_1.input_int("Score", arg_14_0._score_to_add)

	if var_0_1.button("Add Score", 200, 20) then
		if Managers.level_transition_handler:in_hub_level() then
			return
		end

		if arg_14_0._limit_score_to_round then
			-- block empty
		end

		Managers.mechanism:game_mechanism():win_conditions():add_score(arg_14_0._score_to_add)
	end
end

function ImguiVersusEndOfRoundDebug._do_end_round(arg_15_0)
	if var_0_1.button("End Round", 200, 20) then
		if Managers.level_transition_handler:in_hub_level() then
			printf("Failed to end round - Match not started")

			return false
		end

		if not Managers.mechanism:game_mechanism().win_conditions then
			printf("Wrong game-mode, cannot end round here")

			return false
		end

		Managers.state.game_mode:round_started()
		Managers.mechanism:game_mechanism():win_conditions():set_time(0)
	end
end

function ImguiVersusEndOfRoundDebug._do_sets_data_preview(arg_16_0)
	if var_0_1.tree_node("Local Player Sets Data", true) then
		for iter_16_0, iter_16_1 in ipairs(arg_16_0._local_player_sets_data) do
			if var_0_1.tree_node("Local Player Set " .. iter_16_0 .. " Data", false) then
				var_0_1.text_colored("Claimed Points: " .. tostring(iter_16_1.claimed_points), 125, 255, 125, 255)
				var_0_1.text_colored("Distance Travelled: " .. tostring(iter_16_1.distance_traveled), 125, 255, 125, 255)
				var_0_1.text_colored("Max Points: " .. tostring(iter_16_1.max_points), 125, 255, 125, 255)
				var_0_1.text_colored("Unclaimed Points: " .. tostring(iter_16_1.unclaimed_points), 125, 255, 125, 255)
				var_0_1.tree_pop()
			end
		end
	end

	var_0_1.tree_pop()
	var_0_1.dummy(2, 5)

	if var_0_1.tree_node("Opponent Sets Data", true) then
		for iter_16_2, iter_16_3 in ipairs(arg_16_0._opponent_player_sets_data) do
			if var_0_1.tree_node("Opponent Set " .. iter_16_2 .. " Data", false) then
				var_0_1.text_colored("Claimed Points: " .. tostring(iter_16_3.claimed_points), 125, 255, 125, 255)
				var_0_1.text_colored("Distance Travelled: " .. tostring(iter_16_3.distance_traveled), 125, 255, 125, 255)
				var_0_1.text_colored("Max Points: " .. tostring(iter_16_3.max_points), 125, 255, 125, 255)
				var_0_1.text_colored("Unclaimed Points: " .. tostring(iter_16_3.unclaimed_points), 125, 255, 125, 255)
				var_0_1.tree_pop()
			end
		end
	end

	var_0_1.tree_pop()
end
