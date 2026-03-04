-- chunkname: @scripts/entity_system/systems/leaderboard/leaderboard_system.lua

LeaderboardSystem = class(LeaderboardSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_client_leaderboard_register_score"
}
local var_0_1 = Leaderboard and {
	Leaderboard.UINT(32),
	Leaderboard.UINT(32),
	Leaderboard.UINT(32),
	Leaderboard.UINT(4),
	Leaderboard.UINT(4),
	Leaderboard.UINT(4),
	Leaderboard.UINT(4)
}
local var_0_2 = 0
local var_0_3 = 4
local var_0_4 = rawget(_G, "Steam") and GameSettingsDevelopment.network_mode == "steam"
local var_0_5 = Leaderboard and Leaderboard.KEEP_BEST

local function var_0_6(arg_1_0, arg_1_1)
	return string.format("%s_%s", arg_1_0, arg_1_1)
end

local function var_0_7(arg_2_0, arg_2_1, arg_2_2)
	Leaderboard.close(arg_2_0)
	table.clear(arg_2_1)

	arg_2_2[arg_2_0] = nil
end

local var_0_8 = 10000000

local function var_0_9(arg_3_0, arg_3_1)
	assert(arg_3_0 <= 200 and arg_3_1 <= 10800, "Leaderboard error: Too many waves or too long playtime!")

	return var_0_8 * arg_3_0 + (math.floor(var_0_8 / arg_3_1) - 1)
end

function get_wave_and_time_from_score(arg_4_0)
	local var_4_0 = math.floor(arg_4_0 / var_0_8)
	local var_4_1 = arg_4_0 % var_0_8
	local var_4_2 = math.floor(var_0_8 / (var_4_1 + 1))

	return var_4_0, var_4_2
end

local function var_0_10(arg_5_0, arg_5_1, arg_5_2)
	for iter_5_0 = 1, arg_5_1 do
		local var_5_0 = arg_5_2[iter_5_0]
		local var_5_1 = var_5_0.global_rank
		local var_5_2 = var_5_0.name
		local var_5_3 = var_5_0.score
		local var_5_4, var_5_5 = get_wave_and_time_from_score(var_5_3)
		local var_5_6 = var_5_0.data
		local var_5_7 = var_5_6[var_0_3]
		local var_5_8 = SPProfiles[var_5_7]
		local var_5_9 = Localize(var_5_8.display_name)
		local var_5_10 = ""

		for iter_5_1 = 1, 3 do
			local var_5_11 = var_5_6[iter_5_1]

			if var_5_11 ~= var_0_2 then
				local var_5_12 = var_5_6[var_0_3 + iter_5_1]
				local var_5_13 = SPProfiles[var_5_12]
				local var_5_14 = Steam.id_32bit_to_id(var_5_11)
				local var_5_15 = Steam.user_name(var_5_14)
				local var_5_16 = Localize(var_5_13.display_name)

				var_5_10 = var_5_10 .. var_5_15 .. " " .. var_5_16 .. " : "
			else
				break
			end
		end

		local var_5_17 = string.format("%d. %s, %s: %d, %d || %s", var_5_1, var_5_2, var_5_9, var_5_4, var_5_5, var_5_10)

		print(var_5_17)
	end
end

local function var_0_11(arg_6_0, arg_6_1, arg_6_2)
	for iter_6_0 = 1, arg_6_1 do
		local var_6_0 = arg_6_2[iter_6_0]
		local var_6_1 = var_6_0.global_rank
		local var_6_2 = var_6_0.name
		local var_6_3 = var_6_0.score
		local var_6_4, var_6_5 = get_wave_and_time_from_score(var_6_3)
		local var_6_6 = var_6_0.data
		local var_6_7 = var_6_6[0]
		local var_6_8 = var_6_6[1]
		local var_6_9 = var_6_6[2]
		local var_6_10 = (var_6_7 or "Nothing here, Good") .. " " .. var_6_8 .. " " .. (var_6_9 or "")
		local var_6_11 = string.format("%d. %s, %d, %d || %s", var_6_1, var_6_2, var_6_4, var_6_5, var_6_10)

		print(var_6_11)
	end
end

function LeaderboardSystem.init(arg_7_0, arg_7_1, arg_7_2)
	LeaderboardSystem.super.init(arg_7_0, arg_7_1, arg_7_2, {})

	local var_7_0 = arg_7_1.network_event_delegate

	arg_7_0.network_event_delegate = var_7_0

	var_7_0:register(arg_7_0, unpack(var_0_0))

	arg_7_0.world = arg_7_1.world
	arg_7_0.is_server = arg_7_1.is_server
	arg_7_0.network_transmit = arg_7_1.network_transmit
	arg_7_0.transaction_tokens = {}
	arg_7_0.round_start_time = nil

	if script_data.debug_leaderboard then
		local var_7_1 = string.format("[LeaderboardSystem] %s", var_0_4 and "Steam detected, using leaderboards" or "Leaderboards are disabled")

		print(var_7_1)
	end
end

function LeaderboardSystem.destroy(arg_8_0)
	arg_8_0.network_event_delegate:unregister(arg_8_0)

	local var_8_0 = arg_8_0.transaction_tokens

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		var_0_7(iter_8_0, iter_8_1, var_8_0)
	end

	if script_data.debug_leaderboard then
		local var_8_1 = "[LeaderboardSystem] DESTROYED"

		print(var_8_1)
	end
end

function LeaderboardSystem.update(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.transaction_tokens

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		local var_9_1 = Leaderboard.progress(iter_9_0)

		if script_data.debug_leaderboard then
			local var_9_2 = string.format("[LeaderboardSystem] %s - transaction_status = %s : work_status = %s", iter_9_1.name, var_9_1.transaction_status, var_9_1.work_status)

			print(var_9_2)
		end

		if var_9_1.work_status == "succeeded" or var_9_1.work_status == "failed" then
			local var_9_3 = iter_9_1.callback

			if var_9_3 ~= nil then
				var_9_3(var_9_1.work_status, var_9_1.total_scores, var_9_1.scores)
			end

			var_0_7(iter_9_0, iter_9_1, var_9_0)
		end
	end
end

function LeaderboardSystem.round_started(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.is_server or not var_0_4 then
		return
	end

	arg_10_0.round_start_time = arg_10_2.start_time

	if script_data.debug_leaderboard then
		local var_10_0 = string.format("[LeaderboardSystem] round_started at %.2f, level score_type = %s", arg_10_2.start_time, arg_10_1 or "?")

		print(var_10_0)
	end
end

function LeaderboardSystem.debug_simulate_wave_score_enty(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = var_0_9(arg_11_1, arg_11_2)
	local var_11_1 = {}
	local var_11_2 = {
		"1",
		"2",
		"3",
		"4"
	}
	local var_11_3 = {
		1,
		2,
		3,
		4
	}

	for iter_11_0 = 1, arg_11_3 do
		local var_11_4 = var_11_2[iter_11_0]
		local var_11_5 = Steam.id_to_id_32bit(var_11_4)

		var_11_1[#var_11_1 + 1] = var_11_5
		var_11_1[#var_11_1 + 1] = var_11_3[iter_11_0]
	end

	arg_11_0:register_score("whitebox_ai", "normal", var_11_0, var_11_1)
end

function LeaderboardSystem.round_completed(arg_12_0)
	if not arg_12_0.is_server or not var_0_4 then
		return
	end

	local var_12_0 = Managers.state.game_mode:level_key()
	local var_12_1 = LevelSettings[var_12_0].score_type

	if not var_12_1 then
		return
	end

	local var_12_2 = Managers.time:time("game")
	local var_12_3 = 1
	local var_12_4 = {
		completed_time = var_12_2,
		nr_waves_completed = var_12_3
	}
	local var_12_5 = math.floor(var_12_4.completed_time - arg_12_0.round_start_time)

	if var_12_5 <= 0 then
		print("[LeaderboardSystem] Invalid completion time, score will not be recorded!")

		return
	end

	local var_12_6
	local var_12_7 = NetworkLookup.level_keys[var_12_0]
	local var_12_8 = Managers.state.difficulty:get_difficulty()
	local var_12_9 = NetworkLookup.difficulties[var_12_8]
	local var_12_10 = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
	local var_12_11 = 1
	local var_12_12 = Managers.player:human_players()
	local var_12_13 = Managers.state.network.profile_synchronizer

	for iter_12_0, iter_12_1 in pairs(var_12_12) do
		local var_12_14 = iter_12_1:network_id()
		local var_12_15 = var_12_13:profile_by_peer(var_12_14, iter_12_1:local_player_id())

		var_12_10[var_12_11] = Steam.id_to_id_32bit(var_12_14)
		var_12_10[var_12_11 + 1] = var_12_15
		var_12_11 = var_12_11 + 2
	end

	if var_12_1 == "time" then
		var_12_6 = var_12_5
	elseif var_12_1 == "wave_and_time" then
		local var_12_16 = var_12_4.nr_waves_completed

		var_12_6 = var_0_9(var_12_16, var_12_5)
	end

	if var_12_6 then
		arg_12_0.network_transmit:send_rpc_clients("rpc_client_leaderboard_register_score", var_12_7, var_12_9, var_12_6, unpack(var_12_10))
		arg_12_0:register_score(var_12_0, var_12_8, var_12_6, var_12_10)
	end

	if script_data.debug_leaderboard then
		local var_12_17 = string.format("[LeaderboardSystem] start_time = %.2f, end_time = %.2f, completion_time = %d, level score_type = %s", arg_12_0.round_start_time, var_12_4.completed_time, var_12_5, var_12_1 or "?")

		print(var_12_17)
	end
end

function LeaderboardSystem.register_score(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = var_0_6(arg_13_1, arg_13_2)
	local var_13_1 = Managers.player:local_player():network_id()
	local var_13_2 = Steam.id_to_id_32bit(var_13_1)
	local var_13_3 = {
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
	local var_13_4 = 1
	local var_13_5 = #arg_13_4

	for iter_13_0 = 1, var_13_5, 2 do
		local var_13_6 = arg_13_4[iter_13_0]
		local var_13_7 = arg_13_4[iter_13_0 + 1]

		if var_13_6 == var_13_2 then
			var_13_3[var_0_3] = var_13_7
		else
			var_13_3[var_13_4] = var_13_6
			var_13_3[var_13_4 + var_0_3] = var_13_7
			var_13_4 = var_13_4 + 1
		end
	end

	local var_13_8 = Leaderboard.register_score(var_13_0, arg_13_3, var_0_5, var_0_1, var_13_3)

	arg_13_0.transaction_tokens[var_13_8] = {
		name = "register_token"
	}

	if script_data.debug_leaderboard then
		local var_13_9 = string.format("[LeaderboardSystem] register_score -> score = %s, board = %s", tostring(arg_13_3), var_13_0)

		print(var_13_9)
	end
end

function LeaderboardSystem.get_ranking_range(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	if not var_0_4 then
		return
	end

	local var_14_0 = var_0_6(arg_14_1, arg_14_2)
	local var_14_1 = Leaderboard.ranking_range(var_14_0, arg_14_4, arg_14_5, var_0_1)

	arg_14_0.transaction_tokens[var_14_1] = {
		name = "ranking_range_token",
		callback = arg_14_3
	}
end

function LeaderboardSystem.get_ranking_around_self(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if not var_0_4 then
		return
	end

	local var_15_0 = var_0_6(arg_15_1, arg_15_2)
	local var_15_1 = Leaderboard.ranking_around_self(var_15_0, arg_15_4, arg_15_5, var_0_1)

	arg_15_0.transaction_tokens[var_15_1] = {
		name = "ranking_around_self_token",
		callback = arg_15_3
	}
end

function LeaderboardSystem.get_ranking_for_friends(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if not var_0_4 then
		return
	end

	local var_16_0 = var_0_6(arg_16_1, arg_16_2)
	local var_16_1 = Leaderboard.ranking_for_friends(var_16_0, var_0_1)

	arg_16_0.transaction_tokens[var_16_1] = {
		name = "ranking_for_friends",
		callback = arg_16_3
	}
end

function LeaderboardSystem.rpc_client_leaderboard_register_score(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, ...)
	local var_17_0 = NetworkLookup.level_keys[arg_17_2]
	local var_17_1 = NetworkLookup.difficulties[arg_17_3]
	local var_17_2 = {
		...
	}

	arg_17_0:register_score(var_17_0, var_17_1, arg_17_4, var_17_2)
end
