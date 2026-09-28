-- chunkname: @scripts/imgui/imgui_versus_end_of_round_debug.lua

ImguiVersusEndOfRoundDebug = class(ImguiVersusEndOfRoundDebug)

local Gui, Imgui = Gui, Imgui
local DO_RELOAD = true

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
	if DO_RELOAD then
		self:init()

		DO_RELOAD = false
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

ImguiVersusEndOfRoundDebug.draw = function (self, is_open)
	-- function 5
	local do_close = self:_do_main_window()

	return do_close
end

ImguiVersusEndOfRoundDebug.is_persistent = function (self)
	-- function 6
	return true
end

ImguiVersusEndOfRoundDebug._do_main_window = function (self)
	-- function 7
	if self._first_launch then
		local w, h = Application.resolution()

		Imgui.set_next_window_size(w * 0.4, h * 0.7)
	end

	local do_close = Imgui.begin_window("Versus End of Round Debug", "menu_bar")

	repeat
		local game_mode_key = Managers.level_transition_handler:get_current_game_mode()

		if game_mode_key ~= "versus" then
			Imgui.text_colored("You have to be in a versus match to use this tool", 255, 0, 0, 255)

			break
		end

		local win_conditions = self:_get_win_conditions()

		if not win_conditions then
			Imgui.text_colored("No Win Conditions", 255, 0, 0, 255)

			break
		end

		self:_collect_data_for_preview()
		self:_do_preview()
	until true

	Imgui:end_window()

	return do_close
end

ImguiVersusEndOfRoundDebug._get_win_conditions = function (self)
	-- function 8
	local win_conditions = Managers.mechanism:game_mechanism():win_conditions()

	return win_conditions
end

ImguiVersusEndOfRoundDebug._get_round_count = function (self)
	-- function 9
	local win_conditions = self:_get_win_conditions()
	local round_count = win_conditions:get_current_round()

	return round_count
end

ImguiVersusEndOfRoundDebug._get_current_set = function (self)
	-- function 10
	local win_conditions = self:_get_win_conditions()
	local rounds_played = win_conditions:get_current_round()

	return math.round(rounds_played / 2)
end

ImguiVersusEndOfRoundDebug._get_num_rounds = function (self)
	-- function 11
	local mechanism_manager = Managers.mechanism:game_mechanism()
	local number_of_rounds = mechanism_manager:num_sets()

	return number_of_rounds
end

ImguiVersusEndOfRoundDebug._collect_data_for_preview = function (self)
	-- function 12
	local win_conditions = self:_get_win_conditions()
	local current_set = self:_get_current_set()
	local current_round = self:_get_round_count()
	local num_rounds = self:_get_num_rounds()
	local level_key = Managers.level_transition_handler:get_current_level_key()
	local max_level_score = VersusObjectiveSettings[level_key].max_score
	local peer_id = Network.peer_id()
	local local_player_id = 1
	local party_manager = Managers.party
	local _, party_id = party_manager:get_party_from_player_id(peer_id, local_player_id)
	local _local_player_party_id

	if self._local_player_party_id then
		_local_player_party_id = self._local_player_party_id

		if not _local_player_party_id then
			-- Nothing
		end
	end

	if party_id == 0 then
		_local_player_party_id = 1

		goto label_12_0
	end

	_local_player_party_id = party_id

	local local_player_party_id = _local_player_party_id

	do
		local _opponent_party_id
	end

	::label_12_0::

	if self._opponent_party_id then
		_opponent_party_id = self._opponent_party_id

		if not _opponent_party_id then
			-- Nothing
		end
	end

	if party_id == 1 then
		_opponent_party_id = 2

		goto label_12_1
	end

	_opponent_party_id = 1

	local opponent_party_id = _opponent_party_id

	::label_12_1::

	local local_player_team_score = win_conditions:get_total_score(local_player_party_id)
	local local_player_team_sets_data = win_conditions:get_sets_data_for_party(local_player_party_id)
	local opponent_team_score = win_conditions:get_total_score(opponent_party_id)
	local opponent_team_sets_data = win_conditions:get_sets_data_for_party(opponent_party_id)
	local local_player_available_score, opponent_team_available_score = max_level_score, max_level_score
	local player = Managers.player:local_player()
	local side_2 = Managers.state.side

	if side_2 then
		-- Nothing
	end

	side_2 = Managers.state.side:get_side_from_player_unique_id(player:unique_id())

	local side = side_2

	::label_12_2::

	local is_hero = not not side and side:name() == "heroes"
	local match_state = Managers.mechanism:get_state()
	local game_mode_2 = Managers.state.game_mode

	if game_mode_2 then
		-- Nothing
	end

	game_mode_2 = Managers.state.game_mode:game_mode()

	local game_mode = game_mode_2

	::label_12_3::

	local is_round_over = not not game_mode and not not game_mode:match_in_round_over_state()
	local local_player_has_played_round, opponent_has_played_round = false, false

	if current_round % current_set ~= 0 then
		local_player_has_played_round = is_hero
		opponent_has_played_round = not is_hero
	elseif current_round % current_set == 0 then
		local_player_has_played_round = true
		opponent_has_played_round = true
	end

	for i = 1, num_rounds do
		local local_player_set_data = local_player_team_sets_data[i]
		local opponent_team_set_data = opponent_team_sets_data[i]

		if i < current_set then
			local num = local_player_set_data.max_points - local_player_set_data.claimed_points

			if not num then
				-- Nothing
			end

			num = 0

			local unclaimed_points = num

			::label_12_4::

			local_player_available_score = local_player_available_score - unclaimed_points
			unclaimed_points = not not (opponent_team_set_data.max_points - opponent_team_set_data.claimed_points) or not not 0
			opponent_team_available_score = opponent_team_available_score - unclaimed_points
		end
	end

	local score_threshold = (not (local_player_available_score < opponent_team_available_score) or not local_player_available_score) and not not opponent_team_available_score
	local local_player_score_to_win = score_threshold - local_player_team_score
	local opponent_team_score_to_win = score_threshold - opponent_team_score
	local num_2

	if num_rounds >= current_set + 1 then
		num_2 = current_set + 1

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = num_rounds

	local next_round_id = num_2

	::label_12_5::

	local is_next_round_last = next_round_id == num_rounds
	local opp_predicted_score = 0
	local loc_predicted_score = 0

	if local_player_has_played_round and opponent_has_played_round then
		local opponent_team_set_data = opponent_team_sets_data[next_round_id]

		opp_predicted_score = opponent_team_score + opponent_team_set_data.max_points

		local local_player_set_data = local_player_team_sets_data[next_round_id]

		loc_predicted_score = local_player_team_score + local_player_set_data.max_points
	else
		local opponent_team_set_data = opponent_team_sets_data[current_set]

		opp_predicted_score = opponent_team_score + (opponent_team_set_data.max_points - opponent_team_set_data.claimed_points)

		local local_player_set_data = local_player_team_sets_data[current_set]

		loc_predicted_score = local_player_team_score + (local_player_set_data.max_points - local_player_set_data.claimed_points)
	end

	if local_player_score_to_win < opponent_team_score_to_win then
		local local_player_set_data = local_player_team_sets_data[next_round_id]

		if local_player_score_to_win < local_player_set_data.max_points then
			self._winning_party_id = local_player_party_id
			self._winning_party_score_to_win = local_player_score_to_win + 1
		end
	elseif opponent_team_score_to_win < local_player_score_to_win then
		local opponent_team_set_data = opponent_team_sets_data[next_round_id]

		if opponent_team_score_to_win < opponent_team_set_data.max_points then
			self._winning_party_id = opponent_party_id
			self._winning_party_score_to_win = opponent_team_score_to_win + 1
		end
	else
		local local_player_set_data = local_player_team_sets_data[next_round_id]

		if local_player_score_to_win < local_player_set_data.max_points then
			self._winning_party_id = local_player_party_id
			self._winning_party_score_to_win = local_player_score_to_win + 1
		end
	end

	self._local_player_party_id = local_player_party_id
	self._opponent_party_id = opponent_party_id
	self._level_name = level_key
	self._match_state = match_state
	self._game_mode_state = not not game_mode and not not game_mode:game_mode_state()
	self._max_score = max_level_score
	self._local_player_team_available_score = local_player_available_score
	self._opponent_team_available_score = opponent_team_available_score
	self._num_rounds = num_rounds
	self._current_set = current_set
	self._current_round = current_round
	self._local_player_has_played_round = local_player_has_played_round
	self._opponent_has_played_round = opponent_has_played_round
	self._local_player_sets_data = local_player_team_sets_data
	self._opponent_player_sets_data = opponent_team_sets_data
	self._score_threshold = score_threshold
	self._local_player_score = local_player_team_score
	self._opponent_team_score = opponent_team_score
	self._local_player_predicted_score = loc_predicted_score
	self._opponent_predicted_score = opp_predicted_score
	self._local_player_score_to_win = local_player_score_to_win
	self._opponent_team_score_to_win = opponent_team_score_to_win
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

	if Imgui.button("Add Score", 200, 20) then
		if Managers.level_transition_handler:in_hub_level() then
			return
		end

		if self._limit_score_to_round then
			-- Nothing
		end

		local win_conditions = Managers.mechanism:game_mechanism():win_conditions()

		win_conditions:add_score(self._score_to_add)
	end
end

ImguiVersusEndOfRoundDebug._do_end_round = function (self)
	-- function 15
	if Imgui.button("End Round", 200, 20) then
		if Managers.level_transition_handler:in_hub_level() then
			printf("Failed to end round - Match not started")

			return false
		end

		if not Managers.mechanism:game_mechanism().win_conditions then
			printf("Wrong game-mode, cannot end round here")

			return false
		end

		local game_mode_manager = Managers.state.game_mode

		game_mode_manager:round_started()

		local win_conditions = Managers.mechanism:game_mechanism():win_conditions()

		win_conditions:set_time(0)
	end
end

ImguiVersusEndOfRoundDebug._do_sets_data_preview = function (self)
	-- function 16
	local is_local_player_tree_open = Imgui.tree_node("Local Player Sets Data", true)

	if is_local_player_tree_open then
		for set, set_data in ipairs(self._local_player_sets_data) do
			local is_node_open = Imgui.tree_node("Local Player Set " .. set .. " Data", false)

			if is_node_open then
				Imgui.text_colored("Claimed Points: " .. tostring(set_data.claimed_points), 125, 255, 125, 255)
				Imgui.text_colored("Distance Travelled: " .. tostring(set_data.distance_traveled), 125, 255, 125, 255)
				Imgui.text_colored("Max Points: " .. tostring(set_data.max_points), 125, 255, 125, 255)
				Imgui.text_colored("Unclaimed Points: " .. tostring(set_data.unclaimed_points), 125, 255, 125, 255)
				Imgui.tree_pop()
			end
		end
	end

	Imgui.tree_pop()
	Imgui.dummy(2, 5)

	local is_opponent_tree_open = Imgui.tree_node("Opponent Sets Data", true)

	if is_opponent_tree_open then
		for set, set_data in ipairs(self._opponent_player_sets_data) do
			local is_node_open = Imgui.tree_node("Opponent Set " .. set .. " Data", false)

			if is_node_open then
				Imgui.text_colored("Claimed Points: " .. tostring(set_data.claimed_points), 125, 255, 125, 255)
				Imgui.text_colored("Distance Travelled: " .. tostring(set_data.distance_traveled), 125, 255, 125, 255)
				Imgui.text_colored("Max Points: " .. tostring(set_data.max_points), 125, 255, 125, 255)
				Imgui.text_colored("Unclaimed Points: " .. tostring(set_data.unclaimed_points), 125, 255, 125, 255)
				Imgui.tree_pop()
			end
		end
	end

	Imgui.tree_pop()
end
