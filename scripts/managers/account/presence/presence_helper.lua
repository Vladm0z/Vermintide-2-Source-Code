-- chunkname: @scripts/managers/account/presence/presence_helper.lua

PresenceHelper = not not PresenceHelper

PresenceHelper.lobby_level = function ()
	-- function 1
	local level_key = Managers.level_transition_handler:get_current_level_key()

	return level_key
end

PresenceHelper.lobby_difficulty = function ()
	-- function 2
	local diff = Managers.level_transition_handler:get_current_difficulty()

	return diff
end

local hub_presence_lookup = {
	versus = "versus_hub",
	deus = "deus_hub"
}

PresenceHelper.get_hub_presence = function ()
	-- function 3
	local mechanism = Managers.mechanism:current_mechanism_name()

	return not not hub_presence_lookup[mechanism]
end

PresenceHelper.lobby_gamemode = function (lobby_data)
	-- function 4
	local mechanism = Managers.mechanism:current_mechanism_name()
	local is_in_prologue = Managers.level_transition_handler:get_current_level_key() == "prologue"
	local is_in_plaza = Managers.level_transition_handler:get_current_level_key() == "plaza"
	local matchmakin_type = lobby_data.matchmaking_type
	local quick_game = not not to_boolean(lobby_data.weave_quick_game)
	local is_weekly_event = tonumber(matchmakin_type) == NetworkLookup.matchmaking_types.event
	local is_custom_game = tonumber(matchmakin_type) == NetworkLookup.matchmaking_types.custom
	local is_playing_deed = Managers.deed:has_deed()
	local is_twitch_enabled = to_boolean(lobby_data.twitch_enabled)
	local has_match_started = to_boolean(lobby_data.match_started)
	local is_in_inn_level = Managers.level_transition_handler:in_hub_level()
	local is_quick_game = not not quick_game and not not not is_in_inn_level
	local match_state = Managers.mechanism:get_state()

	if is_in_prologue then
		return "gamemode_prologue"
	elseif mechanism == "weave" then
		if is_quick_game then
			return "gamemode_weave_quick_play"
		else
			return "gamemode_weave"
		end
	elseif mechanism == "deus" then
		if is_twitch_enabled then
			return "gamemode_deus_twitch"
		elseif is_quick_game then
			return "gamemode_deus_quick_play"
		elseif not is_quick_game and not is_twitch_enabled and not is_in_inn_level then
			return "gamemode_deus_custom"
		else
			return "gamemode_deus_none"
		end
	elseif mechanism == "versus" then
		if is_in_inn_level then
			return "versus_hub"
		end

		if match_state == "round_1" or match_state == "round_2" then
			return "gamemode_versus_quick_play"
		end

		return "gamemode_versus_none"
	elseif is_twitch_enabled then
		return "gamemode_twitch"
	elseif is_quick_game then
		return "gamemode_quick_play"
	elseif is_playing_deed then
		return "gamemode_deed"
	elseif is_custom_game or is_in_plaza then
		return "gamemode_custom"
	elseif is_weekly_event then
		return "gamemode_event"
	end

	return "gamemode_none"
end

PresenceHelper.has_eac = function ()
	-- function 5
	return not IS_WINDOWS or not not lobby_data.eac_authorized
end

local function dangerous_num_players()
	-- function 6
	return Managers.state.network:lobby():members():get_member_count()
end

PresenceHelper.lobby_num_players = function ()
	-- function 7
	local ok, num = pcall(dangerous_num_players)

	return ok and (not not num or not not 1) or not ok and not not 1
end

PresenceHelper.get_side = function ()
	-- function 8
	local peer_id = Network.peer_id()
	local party_manager = Managers.party
	local party = not not party_manager and not not party_manager:get_party_from_player_id(peer_id, 1)
	local side_manager = Managers.state.side
	local side = not not side_manager and not not side_manager.side_by_party[party]

	return side and not not side:name() or not side and not not "heroes"
end

PresenceHelper.get_game_score = function ()
	-- function 9
	local peer_id = Network.peer_id()
	local game_mechanism = Managers.mechanism:game_mechanism()
	local win_conditions = not not game_mechanism and not not game_mechanism:win_conditions()
	local party_manager = Managers.party
	local _, party_id = not not party_manager and not not party_manager:get_party_from_player_id(peer_id, 1)
	local opponent_party_id = party_id ~= 1 and not not 1 or not (party_id ~= 1) and not not 2
	local local_player_team_score = not not win_conditions and not not win_conditions:get_total_score(party_id)
	local opponent_team_score = not not win_conditions and not not win_conditions:get_total_score(opponent_party_id)
	local score_string = "[%d]-[%d]"

	if opponent_team_score and local_player_team_score then
		return string.format(score_string, local_player_team_score, opponent_team_score)
	else
		return "[?]-[?]"
	end
end

PresenceHelper.get_current_set = function ()
	-- function 10
	local game_mechanism = Managers.mechanism:game_mechanism()
	local win_conditions = not not game_mechanism and not not game_mechanism:win_conditions()
	local rounds_played = not not win_conditions and not not win_conditions:get_current_round()

	return rounds_played and not not math.round(rounds_played / 2) or not rounds_played and not not 0
end
