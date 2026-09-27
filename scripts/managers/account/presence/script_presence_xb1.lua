-- chunkname: @scripts/managers/account/presence/script_presence_xb1.lua

ScriptPresence = class(ScriptPresence)
PRESENCE_LUT = {
	playing = "update_playing",
	menu = "update_menu",
	none = "update_none"
}
ScriptPresence.PRESENCE_UPDATE_TIME = 5
ScriptPresence.USE_ASYNC = true

ScriptPresence.init = function (self)
	-- function 1
	self._presence_func = "update_menu"
	self._current_presence_data = {}
	self._current_presence_set = false
	self._presence_update_timer = 0
end

ScriptPresence.set_presence = function (self, arg_2_1)
	-- function 2
	if not PRESENCE_LUT[arg_2_1] then
		self._presence_func = PRESENCE_LUT[arg_2_1]
		self._current_presence_set = nil
		self._current_presence_data = {}
	else
		Application.warning(string.format("[ScriptPresence] Trying to set presence '%s' which doesn't exist", arg_2_1))
	end
end

ScriptPresence.update = function (self, arg_3_1)
	-- function 3
	local account = Managers.account

	if not (account:user_detached() or account:is_online()) then
		return
	end

	local _presence_update_timer = self._presence_update_timer

	_presence_update_timer = _presence_update_timer or 0
	self._presence_update_timer = _presence_update_timer - arg_3_1

	if self._presence_update_timer < 0 then
		local user_id = account:user_id()

		self[self._presence_func](self, user_id)

		self._presence_update_timer = ScriptPresence.PRESENCE_UPDATE_TIME
	end
end

ScriptPresence.update_none = function (self, arg_4_1)
	-- function 4
	local str = ""

	if self._current_presence_set ~= str then
		self:_set_presence(arg_4_1, str)

		self._current_presence_set = str
	end
end

ScriptPresence.update_menu = function (self, arg_5_1)
	-- function 5
	local str = "in_menus"

	if self._current_presence_set ~= str then
		self:_set_presence(arg_5_1, str)

		self._current_presence_set = str
	end
end

local tbl = {}

ScriptPresence.update_playing = function (self, arg_6_1)
	-- function 6
	local mechanism = Managers.mechanism

	mechanism = not mechanism and Managers.mechanism:current_mechanism_name()

	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode_key()

	local game_mode_2 = Managers.state.game_mode

	game_mode_2 = not game_mode_2 and Managers.state.game_mode:level_key()

	local difficulty = Managers.state.difficulty

	difficulty = not difficulty and Managers.state.difficulty:get_difficulty()

	local player = Managers.player

	player = not player and Managers.player:num_human_players()

	local matchmaking = Managers.matchmaking

	matchmaking = not matchmaking and Managers.matchmaking:is_game_private()

	if not (not game_mode_2 and not difficulty and player) then
		self:set_presence("menu")
	else
		local str = ""

		if not self:_has_new_data(game_mode_2, difficulty, player, matchmaking) then
			local flag

			flag = player == 4 or not matchmaking or "playing" or "needs_assistance"

			self:_setup_stat_data(game_mode_2, difficulty, player)

			local var_6_8

			if game_mode == "weave" then
				local network = Managers.state.network

				network = not network and Managers.state.network:lobby()

				if not (not network and network:lobby_data("weave_quick_game") == "true") then
					var_6_8 = flag .. "_" .. "weave_quick_game_" .. difficulty
				else
					var_6_8 = "playing_weave"
				end
			elseif mechanism == "deus" then
				local get_state = Managers.mechanism:get_state()

				if get_state == "map_deus" then
					var_6_8 = "chaos_wastes_map"
				elseif get_state == "inn_deus" then
					var_6_8 = "chaos_wastes_keep"
				else
					var_6_8 = flag .. "_chaos_wastes_" .. difficulty
				end
			else
				var_6_8 = flag .. "_" .. game_mode_2 .. "_" .. difficulty
			end

			self:_set_presence(arg_6_1, var_6_8)

			self._current_presence_set = var_6_8
		end
	end
end

CURRENT_DIFFICULTY = "easy"
CURRENT_LEVEL = "magnus"

ScriptPresence._extract_stat_data = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local tbl = {}

	if not arg_7_1 then
		local var_7_1 = LevelSettings[arg_7_1]

		if not var_7_1 then
			arg_7_1 = var_7_1.display_name
		else
			arg_7_1 = nil
		end
	end

	if not arg_7_2 then
		local var_7_2 = DifficultySettings[arg_7_2]

		if not var_7_2 then
			arg_7_2 = var_7_2.display_name
		else
			arg_7_2 = nil
		end
	end

	if not arg_7_3 then
		arg_7_3 = string.format("(%s/4)", arg_7_3)
	else
		arg_7_2 = nil
	end

	tbl.CurrentNumPlayers = arg_7_3 or ""
	tbl.CurrentMap = arg_7_1 or ""
	tbl.CurrentDifficulty = arg_7_2 or ""

	return tbl
end

ScriptPresence._has_new_data = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	if tbl.current_level ~= arg_8_1 then
		return true
	elseif tbl.current_difficulty ~= arg_8_2 then
		return true
	elseif tbl.current_num_players ~= arg_8_3 then
		return true
	elseif tbl.is_private ~= arg_8_4 then
		return true
	end

	return false
end

ScriptPresence._setup_stat_data = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	tbl.current_level = arg_9_1
	tbl.current_difficulty = arg_9_2
	tbl.current_num_players = arg_9_3
	tbl.is_private = arg_9_4
end

ScriptPresence.destroy = function (self)
	-- function 10
	local account = Managers.account

	if not account then
		local user_id = account:user_id()
		local is_online = account:is_online()

		if not user_id and not is_online then
			self:_set_presence(user_id, "")
		end
	end
end

ScriptPresence._set_presence = function (self, arg_11_1, arg_11_2)
	-- function 11
	if self._current_presence_set == arg_11_2 then
		return
	end

	if not ScriptPresence.USE_ASYNC then
		print("##### Presence:", arg_11_2)
		Presence.set_async(arg_11_1, arg_11_2)
	else
		Presence.set(arg_11_1, arg_11_2)
	end
end

ScriptPresence.cb_async_presence_set = function (arg_12_0, arg_12_1)
	-- function 12
	local str = "Presence set: "

	if not arg_12_1.error_code then
		str = str .. "ERROR (" .. tostring(arg_12_1.error_code) .. ")"
	else
		local str_2 = str .. "SUCCESS"
	end
end
