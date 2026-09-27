-- chunkname: @scripts/managers/difficulty/difficulty_manager.lua

require("scripts/settings/difficulty_settings")

DifficultyManager = class(DifficultyManager)

DifficultyManager.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.world = arg_1_1
	self.is_server = arg_1_2
	self.network_event_delegate = arg_1_3
	self._lobby = arg_1_4

	arg_1_3:register(self, "rpc_set_difficulty")

	self.difficulty = nil
	self.fallback_difficulty = nil
	self.difficulty_setting = nil
	self.difficulty_tweak = 0
end

DifficultyManager.set_difficulty = function (self, arg_2_1, arg_2_2)
	-- function 2
	fassert(not arg_2_2 and not (arg_2_2 >= -10) or arg_2_2 <= 10, "tweak must be a number from -10 to 10")

	if arg_2_1 == "versus_base" then
		arg_2_2 = 0
	end

	self.difficulty = arg_2_1
	self.difficulty_setting = DifficultySettings[arg_2_1]
	self.difficulty_rank = self.difficulty_setting.rank
	self.fallback_difficulty = self.difficulty_setting.fallback_difficulty
	self.difficulty_tweak = arg_2_2

	SET_BREED_DIFFICULTY(arg_2_1)

	if not self.is_server then
		local get_stored_lobby_data = self._lobby:get_stored_lobby_data()

		get_stored_lobby_data.difficulty = arg_2_1
		get_stored_lobby_data.difficulty_tweak = arg_2_2

		self._lobby:set_lobby_data(get_stored_lobby_data)

		local network = Managers.state.network

		if not network then
			local network_transmit = network.network_transmit
			local var_2_3 = NetworkLookup.difficulties[self.difficulty]

			network_transmit:send_rpc_clients("rpc_set_difficulty", var_2_3, arg_2_2, false)
		end
	end
end

DifficultyManager.get_default_difficulties = function (arg_3_0)
	-- function 3
	return DefaultDifficulties, DefaultStartingDifficulty
end

DifficultyManager.get_difficulty = function (self)
	-- function 4
	return self.difficulty, self.difficulty_tweak
end

DifficultyManager.get_difficulty_rank = function (self)
	-- function 5
	return self.difficulty_rank, self.difficulty_tweak
end

DifficultyManager.get_difficulty_settings = function (self)
	-- function 6
	return self.difficulty_setting
end

DifficultyManager.get_difficulty_value_from_table = function (self, arg_7_1)
	-- function 7
	local difficulty = self.difficulty
	local var_7_1 = arg_7_1[difficulty]

	if not var_7_1 then
		return var_7_1
	end

	return arg_7_1[DifficultySettings[difficulty].fallback_difficulty]
end

DifficultyManager.get_difficulty_index = function (self)
	-- function 8
	return table.index_of(DefaultDifficulties, self.difficulty)
end

DifficultyManager.hot_join_sync = function (self, arg_9_1)
	-- function 9
	local network_transmit = Managers.state.network.network_transmit
	local var_9_1 = NetworkLookup.difficulties[self.difficulty]

	network_transmit:send_rpc("rpc_set_difficulty", arg_9_1, var_9_1, self.difficulty_tweak, true)
end

DifficultyManager.destroy = function (self)
	-- function 10
	self.network_event_delegate:unregister(self)
end

DifficultyManager.rpc_set_difficulty = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0 = NetworkLookup.difficulties[arg_11_2]

	self:set_difficulty(var_11_0, arg_11_3)

	if not arg_11_4 then
		Managers.state.event:trigger("difficulty_synced")
	end
end

local tbl = {}

DifficultyManager.players_below_required_power_level = function (arg_12_0, arg_12_1)
	-- function 12
	table.clear(tbl)

	local required_power_level = DifficultySettings[arg_12_0].required_power_level

	for k, v in pairs(arg_12_1) do
		if not (not v:sync_data_active() and not (required_power_level > v:get_data("best_aquired_power_level"))) then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

local tbl_2 = {}

DifficultyManager.players_locked_difficulty_rank = function (arg_13_0, arg_13_1)
	-- function 13
	table.clear(tbl_2)

	local var_13_0 = DifficultySettings[arg_13_0]

	for k, v in pairs(arg_13_1) do
		if not v:sync_data_active() then
			local get_data = v:get_data("highest_unlocked_difficulty")
			local var_13_2 = NetworkLookup.difficulties[get_data]

			if DifficultySettings[var_13_2].rank < var_13_0.rank then
				tbl_2[#tbl_2 + 1] = v
			end
		end
	end

	return tbl_2
end
