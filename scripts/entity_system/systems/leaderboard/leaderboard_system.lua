-- chunkname: @scripts/entity_system/systems/leaderboard/leaderboard_system.lua

LeaderboardSystem = class(LeaderboardSystem, ExtensionSystemBase)

local tbl = {
	"rpc_client_leaderboard_register_score"
}
local Leaderboard = Leaderboard

Leaderboard = not Leaderboard and {
	Leaderboard.UINT(32),
	Leaderboard.UINT(32),
	Leaderboard.UINT(32),
	Leaderboard.UINT(4),
	Leaderboard.UINT(4),
	Leaderboard.UINT(4),
	Leaderboard.UINT(4)
}

local num = 0
local num_2 = 4
local var_0_4 = rawget(_G, "Steam")

var_0_4 = not var_0_4 and GameSettingsDevelopment.network_mode == "steam"

local Leaderboard_2 = Leaderboard

Leaderboard_2 = not Leaderboard_2 and Leaderboard.KEEP_BEST

local function fn(arg_1_0, arg_1_1)
	-- function 1
	return string.format("%s_%s", arg_1_0, arg_1_1)
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	Leaderboard.close(arg_2_0)
	table.clear(arg_2_1)

	arg_2_2[arg_2_0] = nil
end

local num_3 = 10000000

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	assert(not (arg_3_0 <= 200) or arg_3_1 <= 10800, "Leaderboard error: Too many waves or too long playtime!")

	return num_3 * arg_3_0 + (math.floor(num_3 / arg_3_1) - 1)
end

function get_wave_and_time_from_score(arg_4_0)
	-- function 4
	local floor = math.floor(arg_4_0 / num_3)
	local num = arg_4_0 % num_3
	local floor_2 = math.floor(num_3 / (num + 1))

	return floor, floor_2
end

local function fn_4(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	for i = 1, arg_5_1 do
		local var_5_0 = arg_5_2[i]
		local global_rank = var_5_0.global_rank
		local name = var_5_0.name
		local score = var_5_0.score
		local var_5_4, var_5_5 = get_wave_and_time_from_score(score)
		local data = var_5_0.data
		local var_5_7 = data[num_2]
		local var_5_8 = SPProfiles[var_5_7]
		local var_5_9 = Localize(var_5_8.display_name)
		local str = ""

		for j = 1, 3 do
			local var_5_11 = data[j]

			if var_5_11 ~= num then
				local var_5_12 = data[num_2 + j]
				local var_5_13 = SPProfiles[var_5_12]
				local id_32bit_to_id = Steam.id_32bit_to_id(var_5_11)
				local user_name = Steam.user_name(id_32bit_to_id)
				local var_5_16 = Localize(var_5_13.display_name)

				str = str .. user_name .. " " .. var_5_16 .. " : "
			else
				break
			end
		end

		local format = string.format("%d. %s, %s: %d, %d || %s", global_rank, name, var_5_9, var_5_4, var_5_5, str)

		print(format)
	end
end

local function fn_5(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	for i = 1, arg_6_1 do
		local var_6_0 = arg_6_2[i]
		local global_rank = var_6_0.global_rank
		local name = var_6_0.name
		local score = var_6_0.score
		local var_6_4, var_6_5 = get_wave_and_time_from_score(score)
		local data = var_6_0.data
		local var_6_7 = data[0]
		local var_6_8 = data[1]
		local var_6_9 = data[2]
		local str = (var_6_7 or "Nothing here, Good") .. " " .. var_6_8 .. " " .. (var_6_9 or "")
		local format = string.format("%d. %s, %d, %d || %s", global_rank, name, var_6_4, var_6_5, str)

		print(format)
	end
end

LeaderboardSystem.init = function (self, arg_7_1, arg_7_2)
	-- function 7
	LeaderboardSystem.super.init(self, arg_7_1, arg_7_2, {})

	local network_event_delegate = arg_7_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.world = arg_7_1.world
	self.is_server = arg_7_1.is_server
	self.network_transmit = arg_7_1.network_transmit
	self.transaction_tokens = {}
	self.round_start_time = nil

	if not script_data.debug_leaderboard then
		local format = string.format
		local str = "[LeaderboardSystem] %s"
		local flag

		flag = not var_0_4 and "Steam detected, using leaderboards" and "Leaderboards are disabled"

		local var_7_4 = format(str, flag)

		print(var_7_4)
	end
end

LeaderboardSystem.destroy = function (self)
	-- function 8
	self.network_event_delegate:unregister(self)

	local transaction_tokens = self.transaction_tokens

	for k, v in pairs(transaction_tokens) do
		fn_2(k, v, transaction_tokens)
	end

	if not script_data.debug_leaderboard then
		local str = "[LeaderboardSystem] DESTROYED"

		print(str)
	end
end

LeaderboardSystem.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local transaction_tokens = self.transaction_tokens

	for k, v in pairs(transaction_tokens) do
		local progress = Leaderboard.progress(k)

		if not script_data.debug_leaderboard then
			local format = string.format("[LeaderboardSystem] %s - transaction_status = %s : work_status = %s", v.name, progress.transaction_status, progress.work_status)

			print(format)
		end

		if not (progress.work_status == "succeeded" or progress.work_status ~= "failed") then
			local callback = v.callback

			if callback ~= nil then
				callback(progress.work_status, progress.total_scores, progress.scores)
			end

			fn_2(k, v, transaction_tokens)
		end
	end
end

LeaderboardSystem.round_started = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not (not self.is_server and var_0_4) then
		return
	end

	self.round_start_time = arg_10_2.start_time

	if not script_data.debug_leaderboard then
		local format = string.format("[LeaderboardSystem] round_started at %.2f, level score_type = %s", arg_10_2.start_time, arg_10_1 or "?")

		print(format)
	end
end

LeaderboardSystem.debug_simulate_wave_score_enty = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local var_11_0 = fn_3(arg_11_1, arg_11_2)
	local tbl = {}
	local tbl_2 = {
		"1",
		"2",
		"3",
		"4"
	}
	local tbl_3 = {
		1,
		2,
		3,
		4
	}

	for i = 1, arg_11_3 do
		local var_11_4 = tbl_2[i]
		local id_to_id_32bit = Steam.id_to_id_32bit(var_11_4)

		tbl[#tbl + 1] = id_to_id_32bit
		tbl[#tbl + 1] = tbl_3[i]
	end

	self:register_score("whitebox_ai", "normal", var_11_0, tbl)
end

LeaderboardSystem.round_completed = function (self)
	-- function 12
	if not (not self.is_server and var_0_4) then
		return
	end

	local level_key = Managers.state.game_mode:level_key()
	local score_type = LevelSettings[level_key].score_type

	if not score_type then
		return
	end

	local time = Managers.time:time("game")
	local num = 1
	local tbl = {
		completed_time = time,
		nr_waves_completed = num
	}
	local floor = math.floor(tbl.completed_time - self.round_start_time)

	if floor <= 0 then
		print("[LeaderboardSystem] Invalid completion time, score will not be recorded!")

		return
	end

	local var_12_6
	local var_12_7 = NetworkLookup.level_keys[level_key]
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local var_12_9 = NetworkLookup.difficulties[get_difficulty]
	local tbl_2 = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
	local num_2 = 1
	local human_players = Managers.player:human_players()
	local profile_synchronizer = Managers.state.network.profile_synchronizer

	for k, v in pairs(human_players) do
		local network_id = v:network_id()
		local profile_by_peer = profile_synchronizer:profile_by_peer(network_id, v:local_player_id())

		tbl_2[num_2] = Steam.id_to_id_32bit(network_id)
		tbl_2[num_2 + 1] = profile_by_peer
		num_2 = num_2 + 2
	end

	if score_type == "time" then
		var_12_6 = floor
	elseif score_type == "wave_and_time" then
		local nr_waves_completed = tbl.nr_waves_completed

		var_12_6 = fn_3(nr_waves_completed, floor)
	end

	if not var_12_6 then
		self.network_transmit:send_rpc_clients("rpc_client_leaderboard_register_score", var_12_7, var_12_9, var_12_6, unpack(tbl_2))
		self:register_score(level_key, get_difficulty, var_12_6, tbl_2)
	end

	if not script_data.debug_leaderboard then
		local format = string.format("[LeaderboardSystem] start_time = %.2f, end_time = %.2f, completion_time = %d, level score_type = %s", self.round_start_time, tbl.completed_time, floor, score_type or "?")

		print(format)
	end
end

LeaderboardSystem.register_score = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local var_13_0 = fn(arg_13_1, arg_13_2)
	local network_id = Managers.player:local_player():network_id()
	local id_to_id_32bit = Steam.id_to_id_32bit(network_id)
	local tbl = {
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
	local num = 1
	local count = #arg_13_4

	for i = 1, count, 2 do
		local var_13_6 = arg_13_4[i]
		local var_13_7 = arg_13_4[i + 1]

		if var_13_6 == id_to_id_32bit then
			tbl[num_2] = var_13_7
		else
			tbl[num] = var_13_6
			tbl[num + num_2] = var_13_7
			num = num + 1
		end
	end

	local register_score = Leaderboard.register_score(var_13_0, arg_13_3, Leaderboard_2, Leaderboard, tbl)

	arg_13_0.transaction_tokens[register_score] = {
		name = "register_token"
	}

	if not script_data.debug_leaderboard then
		local format = string.format("[LeaderboardSystem] register_score -> score = %s, board = %s", tostring(arg_13_3), var_13_0)

		print(format)
	end
end

LeaderboardSystem.get_ranking_range = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	if not var_0_4 then
		return
	end

	local var_14_0 = fn(arg_14_1, arg_14_2)
	local ranking_range = Leaderboard.ranking_range(var_14_0, arg_14_4, arg_14_5, Leaderboard)

	arg_14_0.transaction_tokens[ranking_range] = {
		name = "ranking_range_token",
		callback = arg_14_3
	}
end

LeaderboardSystem.get_ranking_around_self = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if not var_0_4 then
		return
	end

	local var_15_0 = fn(arg_15_1, arg_15_2)
	local ranking_around_self = Leaderboard.ranking_around_self(var_15_0, arg_15_4, arg_15_5, Leaderboard)

	arg_15_0.transaction_tokens[ranking_around_self] = {
		name = "ranking_around_self_token",
		callback = arg_15_3
	}
end

LeaderboardSystem.get_ranking_for_friends = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	if not var_0_4 then
		return
	end

	local var_16_0 = fn(arg_16_1, arg_16_2)
	local ranking_for_friends = Leaderboard.ranking_for_friends(var_16_0, Leaderboard)

	arg_16_0.transaction_tokens[ranking_for_friends] = {
		name = "ranking_for_friends",
		callback = arg_16_3
	}
end

LeaderboardSystem.rpc_client_leaderboard_register_score = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, ...)
	-- function 17
	local var_17_0 = NetworkLookup.level_keys[arg_17_2]
	local var_17_1 = NetworkLookup.difficulties[arg_17_3]
	local tbl = {
		...
	}

	self:register_score(var_17_0, var_17_1, arg_17_4, tbl)
end
