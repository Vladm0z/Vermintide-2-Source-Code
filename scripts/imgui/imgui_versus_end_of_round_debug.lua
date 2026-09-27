-- chunkname: @scripts/imgui/imgui_versus_end_of_round_debug.lua

ImguiVersusEndOfRoundDebug = class(ImguiVersusEndOfRoundDebug)

local Gui = Gui
local Imgui = Imgui
local flag = true

ImguiVersusEndOfRoundDebug.init = function (self)
	-- function 1
	self._max_score = 0
	self._local_player_team_available_score = 0
	self._opponent_team_available_score = 0
	self._num_rounds = 0
	self._current_set = 0
	self._current_round = 0
	self._local_player_unclaimed_points = {}
	self._opponent_player_unclaimed_points = {}
	self._score_threshold = 0
	self._local_player_score = 0
	self._local_player_score_to_win = 0
	self._opponent_team_score = 0
	self._opponent_team_score_to_win = 0
	self._winning_party_id = 0
	self._winning_party_score_to_win = 0
	self._limit_score_to_round = true
	self._score_to_add = 0
end

ImguiVersusEndOfRoundDebug.update = function (self)
	-- function 2
	if not flag then
		self:init()

		flag = false
	end
end

ImguiVersusEndOfRoundDebug.on_show = function (self)
	-- function 3
	self._active = true
end

ImguiVersusEndOfRoundDebug.on_hide = function (self)
	-- function 4
	self._active = false
end

ImguiVersusEndOfRoundDebug.draw = function (self, arg_5_1)
	-- function 5
	return (self:_do_main_window())
end

ImguiVersusEndOfRoundDebug.is_persistent = function (arg_6_0)
	-- function 6
	return true
end

ImguiVersusEndOfRoundDebug._do_main_window = function (self)
	-- function 7
	if not self._first_launch then
		local resolution, var_7_1 = Application.resolution()

		Imgui.set_next_window_size(resolution * 0.4, var_7_1 * 0.7)
	end

	local begin_window = Imgui.begin_window("Versus End of Round Debug", "menu_bar")

	repeat
		if Managers.level_transition_handler:get_current_game_mode() ~= "versus" then
			Imgui.text_colored("You have to be in a versus match to use this tool", 255, 0, 0, 255)

			break
		end

		if not self:_get_win_conditions() then
			Imgui.text_colored("No Win Conditions", 255, 0, 0, 255)

			break
		end

		self:_collect_data_for_preview()
		self:_do_preview()
	until true

	Imgui:end_window()

	return begin_window
end

ImguiVersusEndOfRoundDebug._get_win_conditions = function (arg_8_0)
	-- function 8
	return (Managers.mechanism:game_mechanism():win_conditions())
end

ImguiVersusEndOfRoundDebug._get_round_count = function (self)
	-- function 9
	return (self:_get_win_conditions():get_current_round())
end

ImguiVersusEndOfRoundDebug._get_current_set = function (self)
	-- function 10
	local get_current_round = self:_get_win_conditions():get_current_round()

	return math.round(get_current_round / 2)
end

ImguiVersusEndOfRoundDebug._get_num_rounds = function (arg_11_0)
	-- function 11
	return (Managers.mechanism:game_mechanism():num_sets())
end

ImguiVersusEndOfRoundDebug._collect_data_for_preview = function (self)
	-- function 12
	local _get_win_conditions = self:_get_win_conditions()
	local _get_current_set = self:_get_current_set()
	local _get_round_count = self:_get_round_count()
	local _get_num_rounds = self:_get_num_rounds()
	local get_current_level_key = Managers.level_transition_handler:get_current_level_key()
	local max_score = VersusObjectiveSettings[get_current_level_key].max_score
	local peer_id = Network.peer_id()
	local num = 1
	local get_party_from_player_id, var_12_9 = Managers.party:get_party_from_player_id(peer_id, num)
	local _local_player_party_id

	if not self._local_player_party_id then
		_local_player_party_id = self._local_player_party_id

		if not _local_player_party_id then
			-- Nothing
		end
	end

	_local_player_party_id = var_12_9 ~= 0 or not 1 or var_12_9

	do
		local _opponent_party_id
	end

	::label_12_0::

	if not self._opponent_party_id then
		_opponent_party_id = self._opponent_party_id

		if not _opponent_party_id then
			-- Nothing
		end
	end

	_opponent_party_id = var_12_9 ~= 1 or not 2 or 1

	::label_12_1::

	local get_total_score = _get_win_conditions:get_total_score(_local_player_party_id)
	local get_sets_data_for_party = _get_win_conditions:get_sets_data_for_party(_local_player_party_id)
	local get_total_score_2 = _get_win_conditions:get_total_score(_opponent_party_id)
	local get_sets_data_for_party_2 = _get_win_conditions:get_sets_data_for_party(_opponent_party_id)
	local var_12_16 = max_score
	local var_12_17 = max_score
	local local_player = Managers.player:local_player()
	local side = Managers.state.side

	side = not side and Managers.state.side:get_side_from_player_unique_id(local_player:unique_id())

	local flag = not side and side:name() == "heroes"
	local get_state = Managers.mechanism:get_state()
	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode()

	local flag_2

	flag_2 = not game_mode and game_mode:match_in_round_over_state()

	local flag_3 = false
	local flag_4 = false

	if _get_round_count % _get_current_set ~= 0 then
		flag_3 = flag
		flag_4 = not flag
	elseif _get_round_count % _get_current_set == 0 then
		flag_3 = true
		flag_4 = true
	end

	for i = 1, _get_num_rounds do
		local var_12_26 = get_sets_data_for_party[i]
		local var_12_27 = get_sets_data_for_party_2[i]

		if i < _get_current_set then
			local num_2 = var_12_26.max_points - var_12_26.claimed_points

			num_2 = num_2 or 0
			var_12_16 = var_12_16 - num_2
			var_12_17 = var_12_17 - (var_12_27.max_points - var_12_27.claimed_points or 0)
		end
	end

	local flag_5 = not (var_12_16 < var_12_17) or not var_12_16 or var_12_17
	local num_3 = flag_5 - get_total_score
	local num_4 = flag_5 - get_total_score_2
	local num_5

	if _get_num_rounds >= _get_current_set + 1 then
		num_5 = _get_current_set + 1

		if not num_5 then
			-- Nothing
		end
	end

	num_5 = _get_num_rounds

	do
		local flag_6
	end

	::label_12_2::

	flag_6 = num_5 == _get_num_rounds

	local num_6 = 0
	local num_7 = 0

	if not flag_3 and not flag_4 then
		num_6 = get_total_score_2 + get_sets_data_for_party_2[num_5].max_points
		num_7 = get_total_score + get_sets_data_for_party[num_5].max_points
	else
		local var_12_36 = get_sets_data_for_party_2[_get_current_set]

		num_6 = get_total_score_2 + (var_12_36.max_points - var_12_36.claimed_points)

		local var_12_37 = get_sets_data_for_party[_get_current_set]

		num_7 = get_total_score + (var_12_37.max_points - var_12_37.claimed_points)
	end

	if num_3 < num_4 then
		if num_3 < get_sets_data_for_party[num_5].max_points then
			self._winning_party_id = _local_player_party_id
			self._winning_party_score_to_win = num_3 + 1
		end
	elseif num_4 < num_3 then
		if num_4 < get_sets_data_for_party_2[num_5].max_points then
			self._winning_party_id = _opponent_party_id
			self._winning_party_score_to_win = num_4 + 1
		end
	elseif num_3 < get_sets_data_for_party[num_5].max_points then
		self._winning_party_id = _local_player_party_id
		self._winning_party_score_to_win = num_3 + 1
	end

	self._local_player_party_id = _local_player_party_id
	self._opponent_party_id = _opponent_party_id
	self._level_name = get_current_level_key
	self._match_state = get_state
	self._game_mode_state = not game_mode and game_mode:game_mode_state()
	self._max_score = max_score
	self._local_player_team_available_score = var_12_16
	self._opponent_team_available_score = var_12_17
	self._num_rounds = _get_num_rounds
	self._current_set = _get_current_set
	self._current_round = _get_round_count
	self._local_player_has_played_round = flag_3
	self._opponent_has_played_round = flag_4
	self._local_player_sets_data = get_sets_data_for_party
	self._opponent_player_sets_data = get_sets_data_for_party_2
	self._score_threshold = flag_5
	self._local_player_score = get_total_score
	self._opponent_team_score = get_total_score_2
	self._local_player_predicted_score = num_7
	self._opponent_predicted_score = num_6
	self._local_player_score_to_win = num_3
	self._opponent_team_score_to_win = num_4
end

ImguiVersusEndOfRoundDebug._do_preview = function (self)
	-- function 13
	self:_do_add_score()
	Imgui.dummy(2, 5)
	self:_do_end_round()
	Imgui.dummy(2, 5)
	Imgui.text_colored("Level Key: " .. tostring(self._level_name), 125, 125, 255, 255)
	Imgui.text_colored("Match State: " .. tostring(self._match_state), 125, 125, 255, 255)
	Imgui.text_colored("Game Mode State: " .. tostring(self._game_mode_state), 125, 125, 255, 255)
	Imgui.text_colored("Max Level Score: " .. tostring(self._max_score), 255, 125, 125, 255)
	Imgui.text_colored("Local Player Team Max Available Score: " .. tostring(self._local_player_team_available_score), 255, 125, 125, 255)
	Imgui.text_colored("Opponent Team Max Available Score: " .. tostring(self._opponent_team_available_score), 255, 125, 125, 255)
	Imgui.text_colored("Number of Rounds (Sets): " .. tostring(self._num_rounds), 255, 125, 125, 255)
	Imgui.text_colored("Current Set: " .. tostring(self._current_set), 255, 125, 125, 255)
	Imgui.text_colored("Current Round: " .. tostring(self._current_round), 255, 125, 125, 255)
	Imgui.text_colored("Has Local Player Played Current Round: " .. tostring(self._local_player_has_played_round), 255, 125, 125, 255)
	Imgui.text_colored("Has Opponent Played Current Round: " .. tostring(self._opponent_has_played_round), 255, 125, 125, 255)
	Imgui.text_colored("Score Threshold: " .. tostring(self._score_threshold), 255, 125, 125, 255)
	Imgui.text_colored("Local Player Team Score: " .. tostring(self._local_player_score), 255, 125, 125, 255)
	Imgui.text_colored("Local Player Team Score to Win: " .. tostring(self._local_player_score_to_win), 255, 125, 125, 255)
	Imgui.text_colored("Local Player Team Predicted Score: " .. tostring(self._local_player_predicted_score), 125, 255, 125, 255)
	Imgui.text_colored("Opponent Team Score: " .. tostring(self._opponent_team_score), 255, 125, 125, 255)
	Imgui.text_colored("Opponent Team Score to Win: " .. tostring(self._opponent_team_score_to_win), 255, 125, 125, 255)
	Imgui.text_colored("Opponent Team Predicted Score: " .. tostring(self._opponent_predicted_score), 125, 255, 125, 255)
	Imgui.text_colored("Winning Party ID: " .. tostring(self._winning_party_id), 125, 255, 125, 255)
	Imgui.text_colored("Winning Party Score To Win: " .. tostring(self._winning_party_score_to_win), 125, 255, 125, 255)
	Imgui.dummy(2, 5)
	self:_do_sets_data_preview()
end

ImguiVersusEndOfRoundDebug._do_add_score = function (self)
	-- function 14
	script_data.disable_gamemode_end = Imgui.checkbox("Disable Gamemode End", not not script_data.disable_gamemode_end)
	self._limit_score_to_round = Imgui.checkbox("Limit the score that can be added to the max score for this round", self._limit_score_to_round)
	self._score_to_add = Imgui.input_int("Score", self._score_to_add)

	if not Imgui.button("Add Score", 200, 20) then
		if not Managers.level_transition_handler:in_hub_level() then
			return
		end

		if not self._limit_score_to_round then
			-- Nothing
		end

		Managers.mechanism:game_mechanism():win_conditions():add_score(self._score_to_add)
	end
end

ImguiVersusEndOfRoundDebug._do_end_round = function (arg_15_0)
	-- function 15
	if not Imgui.button("End Round", 200, 20) then
		if not Managers.level_transition_handler:in_hub_level() then
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

ImguiVersusEndOfRoundDebug._do_sets_data_preview = function (self)
	-- function 16
	if not Imgui.tree_node("Local Player Sets Data", true) then
		for i, v in ipairs(self._local_player_sets_data) do
			if not Imgui.tree_node("Local Player Set " .. i .. " Data", false) then
				Imgui.text_colored("Claimed Points: " .. tostring(v.claimed_points), 125, 255, 125, 255)
				Imgui.text_colored("Distance Travelled: " .. tostring(v.distance_traveled), 125, 255, 125, 255)
				Imgui.text_colored("Max Points: " .. tostring(v.max_points), 125, 255, 125, 255)
				Imgui.text_colored("Unclaimed Points: " .. tostring(v.unclaimed_points), 125, 255, 125, 255)
				Imgui.tree_pop()
			end
		end
	end

	Imgui.tree_pop()
	Imgui.dummy(2, 5)

	if not Imgui.tree_node("Opponent Sets Data", true) then
		for i_2, v_2 in ipairs(self._opponent_player_sets_data) do
			if not Imgui.tree_node("Opponent Set " .. i_2 .. " Data", false) then
				Imgui.text_colored("Claimed Points: " .. tostring(v_2.claimed_points), 125, 255, 125, 255)
				Imgui.text_colored("Distance Travelled: " .. tostring(v_2.distance_traveled), 125, 255, 125, 255)
				Imgui.text_colored("Max Points: " .. tostring(v_2.max_points), 125, 255, 125, 255)
				Imgui.text_colored("Unclaimed Points: " .. tostring(v_2.unclaimed_points), 125, 255, 125, 255)
				Imgui.tree_pop()
			end
		end
	end

	Imgui.tree_pop()
end
