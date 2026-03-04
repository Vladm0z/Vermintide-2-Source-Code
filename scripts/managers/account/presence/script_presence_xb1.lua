-- chunkname: @scripts/managers/account/presence/script_presence_xb1.lua

ScriptPresence = class(ScriptPresence)
PRESENCE_LUT = {
	playing = "update_playing",
	menu = "update_menu",
	none = "update_none"
}
ScriptPresence.PRESENCE_UPDATE_TIME = 5
ScriptPresence.USE_ASYNC = true

ScriptPresence.init = function (arg_1_0)
	arg_1_0._presence_func = "update_menu"
	arg_1_0._current_presence_data = {}
	arg_1_0._current_presence_set = false
	arg_1_0._presence_update_timer = 0
end

ScriptPresence.set_presence = function (arg_2_0, arg_2_1)
	if PRESENCE_LUT[arg_2_1] then
		arg_2_0._presence_func = PRESENCE_LUT[arg_2_1]
		arg_2_0._current_presence_set = nil
		arg_2_0._current_presence_data = {}
	else
		Application.warning(string.format("[ScriptPresence] Trying to set presence '%s' which doesn't exist", arg_2_1))
	end
end

ScriptPresence.update = function (arg_3_0, arg_3_1)
	local var_3_0 = Managers.account

	if var_3_0:user_detached() or not var_3_0:is_online() then
		return
	end

	arg_3_0._presence_update_timer = (arg_3_0._presence_update_timer or 0) - arg_3_1

	if arg_3_0._presence_update_timer < 0 then
		local var_3_1 = var_3_0:user_id()

		arg_3_0[arg_3_0._presence_func](arg_3_0, var_3_1)

		arg_3_0._presence_update_timer = ScriptPresence.PRESENCE_UPDATE_TIME
	end
end

ScriptPresence.update_none = function (arg_4_0, arg_4_1)
	local var_4_0 = ""

	if arg_4_0._current_presence_set ~= var_4_0 then
		arg_4_0:_set_presence(arg_4_1, var_4_0)

		arg_4_0._current_presence_set = var_4_0
	end
end

ScriptPresence.update_menu = function (arg_5_0, arg_5_1)
	local var_5_0 = "in_menus"

	if arg_5_0._current_presence_set ~= var_5_0 then
		arg_5_0:_set_presence(arg_5_1, var_5_0)

		arg_5_0._current_presence_set = var_5_0
	end
end

local var_0_0 = {}

ScriptPresence.update_playing = function (arg_6_0, arg_6_1)
	local var_6_0 = Managers.mechanism and Managers.mechanism:current_mechanism_name()
	local var_6_1 = Managers.state.game_mode and Managers.state.game_mode:game_mode_key()
	local var_6_2 = Managers.state.game_mode and Managers.state.game_mode:level_key()
	local var_6_3 = Managers.state.difficulty and Managers.state.difficulty:get_difficulty()
	local var_6_4 = Managers.player and Managers.player:num_human_players()
	local var_6_5 = Managers.matchmaking and Managers.matchmaking:is_game_private()

	if not var_6_2 or not var_6_3 or not var_6_4 then
		arg_6_0:set_presence("menu")
	else
		local var_6_6 = ""

		if arg_6_0:_has_new_data(var_6_2, var_6_3, var_6_4, var_6_5) then
			local var_6_7 = (var_6_4 == 4 or var_6_5) and "playing" or "needs_assistance"

			arg_6_0:_setup_stat_data(var_6_2, var_6_3, var_6_4)

			local var_6_8

			if var_6_1 == "weave" then
				local var_6_9 = Managers.state.network and Managers.state.network:lobby()

				if var_6_9 and var_6_9:lobby_data("weave_quick_game") == "true" then
					var_6_8 = var_6_7 .. "_" .. "weave_quick_game_" .. var_6_3
				else
					var_6_8 = "playing_weave"
				end
			elseif var_6_0 == "deus" then
				local var_6_10 = Managers.mechanism:get_state()

				if var_6_10 == "map_deus" then
					var_6_8 = "chaos_wastes_map"
				elseif var_6_10 == "inn_deus" then
					var_6_8 = "chaos_wastes_keep"
				else
					var_6_8 = var_6_7 .. "_chaos_wastes_" .. var_6_3
				end
			else
				var_6_8 = var_6_7 .. "_" .. var_6_2 .. "_" .. var_6_3
			end

			arg_6_0:_set_presence(arg_6_1, var_6_8)

			arg_6_0._current_presence_set = var_6_8
		end
	end
end

CURRENT_DIFFICULTY = "easy"
CURRENT_LEVEL = "magnus"

ScriptPresence._extract_stat_data = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = {}

	if arg_7_1 then
		local var_7_1 = LevelSettings[arg_7_1]

		if var_7_1 then
			arg_7_1 = var_7_1.display_name
		else
			arg_7_1 = nil
		end
	end

	if arg_7_2 then
		local var_7_2 = DifficultySettings[arg_7_2]

		if var_7_2 then
			arg_7_2 = var_7_2.display_name
		else
			arg_7_2 = nil
		end
	end

	if arg_7_3 then
		arg_7_3 = string.format("(%s/4)", arg_7_3)
	else
		arg_7_2 = nil
	end

	var_7_0.CurrentNumPlayers = arg_7_3 or ""
	var_7_0.CurrentMap = arg_7_1 or ""
	var_7_0.CurrentDifficulty = arg_7_2 or ""

	return var_7_0
end

ScriptPresence._has_new_data = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if var_0_0.current_level ~= arg_8_1 then
		return true
	elseif var_0_0.current_difficulty ~= arg_8_2 then
		return true
	elseif var_0_0.current_num_players ~= arg_8_3 then
		return true
	elseif var_0_0.is_private ~= arg_8_4 then
		return true
	end

	return false
end

ScriptPresence._setup_stat_data = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	var_0_0.current_level = arg_9_1
	var_0_0.current_difficulty = arg_9_2
	var_0_0.current_num_players = arg_9_3
	var_0_0.is_private = arg_9_4
end

ScriptPresence.destroy = function (arg_10_0)
	local var_10_0 = Managers.account

	if var_10_0 then
		local var_10_1 = var_10_0:user_id()
		local var_10_2 = var_10_0:is_online()

		if var_10_1 and var_10_2 then
			arg_10_0:_set_presence(var_10_1, "")
		end
	end
end

ScriptPresence._set_presence = function (arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0._current_presence_set == arg_11_2 then
		return
	end

	if ScriptPresence.USE_ASYNC then
		print("##### Presence:", arg_11_2)
		Presence.set_async(arg_11_1, arg_11_2)
	else
		Presence.set(arg_11_1, arg_11_2)
	end
end

ScriptPresence.cb_async_presence_set = function (arg_12_0, arg_12_1)
	local var_12_0 = "Presence set: "

	if arg_12_1.error_code then
		var_12_0 = var_12_0 .. "ERROR (" .. tostring(arg_12_1.error_code) .. ")"
	else
		local var_12_1 = var_12_0 .. "SUCCESS"
	end
end
