-- chunkname: @scripts/managers/account/presence/presence_helper.lua

PresenceHelper = PresenceHelper or {}

function PresenceHelper.lobby_level()
	return (Managers.level_transition_handler:get_current_level_key())
end

function PresenceHelper.lobby_difficulty()
	return (Managers.level_transition_handler:get_current_difficulty())
end

local var_0_0 = {
	versus = "versus_hub",
	deus = "deus_hub"
}

function PresenceHelper.get_hub_presence()
	local var_3_0 = Managers.mechanism:current_mechanism_name()

	return var_0_0[var_3_0] or "adventure_hub"
end

function PresenceHelper.lobby_gamemode(arg_4_0)
	local var_4_0 = Managers.mechanism:current_mechanism_name()
	local var_4_1 = Managers.level_transition_handler:get_current_level_key() == "prologue"
	local var_4_2 = Managers.level_transition_handler:get_current_level_key() == "plaza"
	local var_4_3 = arg_4_0.matchmaking_type
	local var_4_4 = to_boolean(arg_4_0.weave_quick_game) or Managers.venture.quickplay and Managers.venture.quickplay:is_quick_game()
	local var_4_5 = tonumber(var_4_3) == NetworkLookup.matchmaking_types.event
	local var_4_6 = tonumber(var_4_3) == NetworkLookup.matchmaking_types.custom
	local var_4_7 = Managers.deed:has_deed()
	local var_4_8 = to_boolean(arg_4_0.twitch_enabled)
	local var_4_9 = to_boolean(arg_4_0.match_started)
	local var_4_10 = Managers.level_transition_handler:in_hub_level()
	local var_4_11 = var_4_4 and not var_4_10
	local var_4_12 = Managers.mechanism:get_state()

	if var_4_1 then
		return "gamemode_prologue"
	elseif var_4_0 == "weave" then
		if var_4_11 then
			return "gamemode_weave_quick_play"
		else
			return "gamemode_weave"
		end
	elseif var_4_0 == "deus" then
		if var_4_8 then
			return "gamemode_deus_twitch"
		elseif var_4_11 then
			return "gamemode_deus_quick_play"
		elseif not var_4_11 and not var_4_8 and not var_4_10 then
			return "gamemode_deus_custom"
		else
			return "gamemode_deus_none"
		end
	elseif var_4_0 == "versus" then
		if var_4_10 then
			return "versus_hub"
		end

		if var_4_12 == "round_1" or var_4_12 == "round_2" then
			return "gamemode_versus_quick_play"
		end

		return "gamemode_versus_none"
	elseif var_4_8 then
		return "gamemode_twitch"
	elseif var_4_11 then
		return "gamemode_quick_play"
	elseif var_4_7 then
		return "gamemode_deed"
	elseif var_4_6 or var_4_2 then
		return "gamemode_custom"
	elseif var_4_5 then
		return "gamemode_event"
	end

	return "gamemode_none"
end

function PresenceHelper.has_eac()
	return not IS_WINDOWS or lobby_data.eac_authorized
end

local function var_0_1()
	return Managers.state.network:lobby():members():get_member_count()
end

function PresenceHelper.lobby_num_players()
	local var_7_0, var_7_1 = pcall(var_0_1)

	return var_7_0 and var_7_1 or 1
end

function PresenceHelper.get_side()
	local var_8_0 = Network.peer_id()
	local var_8_1 = Managers.party
	local var_8_2 = var_8_1 and var_8_1:get_party_from_player_id(var_8_0, 1)
	local var_8_3 = Managers.state.side
	local var_8_4 = var_8_3 and var_8_3.side_by_party[var_8_2]

	return var_8_4 and var_8_4:name() or "heroes"
end

function PresenceHelper.get_game_score()
	local var_9_0 = Network.peer_id()
	local var_9_1 = Managers.mechanism:game_mechanism()
	local var_9_2 = var_9_1 and var_9_1:win_conditions()
	local var_9_3 = Managers.party
	local var_9_4

	var_9_4 = var_9_3 and var_9_3:get_party_from_player_id(var_9_0, 1)

	local var_9_5
	local var_9_6 = var_9_5 == 1 and 2 or 1
	local var_9_7 = var_9_2 and var_9_2:get_total_score(var_9_5)
	local var_9_8 = var_9_2 and var_9_2:get_total_score(var_9_6)
	local var_9_9 = "[%d]-[%d]"

	if var_9_8 and var_9_7 then
		return string.format(var_9_9, var_9_7, var_9_8)
	else
		return "[?]-[?]"
	end
end

function PresenceHelper.get_current_set()
	local var_10_0 = Managers.mechanism:game_mechanism()
	local var_10_1 = var_10_0 and var_10_0:win_conditions()
	local var_10_2 = var_10_1 and var_10_1:get_current_round()

	return var_10_2 and math.round(var_10_2 / 2) or 0
end
