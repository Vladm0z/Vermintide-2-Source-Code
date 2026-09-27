-- chunkname: @scripts/managers/account/presence/presence_helper.lua

local PresenceHelper = PresenceHelper

PresenceHelper = PresenceHelper or {}
PresenceHelper = PresenceHelper

PresenceHelper.lobby_level = function ()
	-- function 1
	return (Managers.level_transition_handler:get_current_level_key())
end

PresenceHelper.lobby_difficulty = function ()
	-- function 2
	return (Managers.level_transition_handler:get_current_difficulty())
end

local tbl = {
	versus = "versus_hub",
	deus = "deus_hub"
}

PresenceHelper.get_hub_presence = function ()
	-- function 3
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local var_3_1 = tbl[current_mechanism_name]

	var_3_1 = var_3_1 or "adventure_hub"

	return var_3_1
end

PresenceHelper.lobby_gamemode = function (self)
	-- function 4
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local flag = Managers.level_transition_handler:get_current_level_key() == "prologue"
	local flag_2 = Managers.level_transition_handler:get_current_level_key() == "plaza"
	local matchmaking_type = self.matchmaking_type
	local var_4_4 = to_boolean(self.weave_quick_game)

	if not var_4_4 then
		var_4_4 = Managers.venture.quickplay
		var_4_4 = not var_4_4 and Managers.venture.quickplay:is_quick_game()
	end

	local flag_3 = tonumber(matchmaking_type) == NetworkLookup.matchmaking_types.event
	local flag_4 = tonumber(matchmaking_type) == NetworkLookup.matchmaking_types.custom
	local has_deed = Managers.deed:has_deed()
	local var_4_8 = to_boolean(self.twitch_enabled)
	local var_4_9 = to_boolean(self.match_started)
	local in_hub_level = Managers.level_transition_handler:in_hub_level()
	local flag_5 = not var_4_4 and not in_hub_level
	local get_state = Managers.mechanism:get_state()

	if not flag then
		return "gamemode_prologue"
	elseif current_mechanism_name == "weave" then
		if not flag_5 then
			return "gamemode_weave_quick_play"
		else
			return "gamemode_weave"
		end
	elseif current_mechanism_name == "deus" then
		if not var_4_8 then
			return "gamemode_deus_twitch"
		elseif not flag_5 then
			return "gamemode_deus_quick_play"
		elseif not (flag_5 or var_4_8 or in_hub_level) then
			return "gamemode_deus_custom"
		else
			return "gamemode_deus_none"
		end
	elseif current_mechanism_name == "versus" then
		if not in_hub_level then
			return "versus_hub"
		end

		if not (get_state == "round_1" or get_state ~= "round_2") then
			return "gamemode_versus_quick_play"
		end

		return "gamemode_versus_none"
	elseif not var_4_8 then
		return "gamemode_twitch"
	elseif not flag_5 then
		return "gamemode_quick_play"
	elseif not has_deed then
		return "gamemode_deed"
	elseif flag_4 or not flag_2 then
		return "gamemode_custom"
	elseif not flag_3 then
		return "gamemode_event"
	end

	return "gamemode_none"
end

PresenceHelper.has_eac = function ()
	-- function 5
	return not IS_WINDOWS and lobby_data.eac_authorized
end

local function fn()
	-- function 6
	return Managers.state.network:lobby():members():get_member_count()
end

PresenceHelper.lobby_num_players = function ()
	-- function 7
	local var_7_0, var_7_1 = pcall(fn)

	return not var_7_0 and var_7_1 and 1
end

PresenceHelper.get_side = function ()
	-- function 8
	local peer_id = Network.peer_id()
	local party = Managers.party
	local flag = not party and party:get_party_from_player_id(peer_id, 1)
	local side = Managers.state.side
	local flag_2 = not side and side.side_by_party[flag]
	local name

	if not flag_2 then
		name = flag_2:name()

		if not name then
			-- Nothing
		end
	end

	name = "heroes"

	::label_8_0::

	return name
end

PresenceHelper.get_game_score = function ()
	-- function 9
	local peer_id = Network.peer_id()
	local game_mechanism = Managers.mechanism:game_mechanism()
	local flag = not game_mechanism and game_mechanism:win_conditions()
	local party = Managers.party
	local flag_2

	flag_2 = not party and party:get_party_from_player_id(peer_id, 1)

	local var_9_5
	local flag_3

	flag_3 = var_9_5 ~= 1 or not 2 or 1

	local flag_4 = not flag and flag:get_total_score(var_9_5)
	local flag_5 = not flag and flag:get_total_score(flag_3)
	local str = "[%d]-[%d]"

	if not flag_5 and not flag_4 then
		return string.format(str, flag_4, flag_5)
	else
		return "[?]-[?]"
	end
end

PresenceHelper.get_current_set = function ()
	-- function 10
	local game_mechanism = Managers.mechanism:game_mechanism()
	local flag = not game_mechanism and game_mechanism:win_conditions()
	local flag_2 = not flag and flag:get_current_round()
	local round

	if not flag_2 then
		round = math.round(flag_2 / 2)

		if not round then
			-- Nothing
		end
	end

	round = 0

	::label_10_0::

	return round
end
