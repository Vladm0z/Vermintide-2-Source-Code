-- chunkname: @scripts/utils/ping_reporter.lua

PingReporter = class(PingReporter)
PingReporter.NAME = "PingReporter"

local var_0_0 = 10

local function var_0_1()
	local var_1_0 = Managers.player:players()

	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		if iter_1_1.local_player then
			return iter_1_1
		end
	end
end

local function var_0_2(arg_2_0)
	local var_2_0 = 0

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		var_2_0 = var_2_0 + iter_2_1
	end

	return var_2_0
end

local function var_0_3(arg_3_0)
	return var_0_2(arg_3_0) / #arg_3_0
end

local function var_0_4(arg_4_0, arg_4_1)
	return arg_4_0[math.round(arg_4_1 / 100 * #arg_4_0)]
end

local function var_0_5(arg_5_0)
	local var_5_0 = var_0_3(arg_5_0)
	local var_5_1 = {}

	for iter_5_0, iter_5_1 in pairs(arg_5_0) do
		var_5_1[iter_5_0] = (iter_5_1 - var_5_0)^2
	end

	return var_0_3(var_5_1)
end

function PingReporter.init(arg_6_0)
	arg_6_0._measures = {}
	arg_6_0._measure_taken = 0

	if Application.user_setting("write_network_debug_output_to_log") then
		arg_6_0._dump_detailed_connection_status = true
	end
end

function PingReporter.update(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2 - arg_7_0._measure_taken > var_0_0 then
		arg_7_0:_take_measure()

		arg_7_0._measure_taken = math.floor(arg_7_2)
	end
end

function PingReporter._take_measure(arg_8_0)
	local var_8_0 = var_0_1()

	if not var_8_0 then
		return
	end

	local var_8_1 = var_8_0.game_object_id
	local var_8_2 = Managers.state.network:game()

	if not var_8_0.is_server and not var_8_0.bot_player and var_8_2 and var_8_1 then
		local var_8_3 = GameSession.game_object_field(var_8_2, var_8_1, "ping")

		arg_8_0._measures[#arg_8_0._measures + 1] = var_8_3
	end

	if arg_8_0._dump_detailed_connection_status and LobbyInternal.client then
		print("\n\nSTEAM NETWORK DEBUG:\n")
		SteamClient.write_detailed_connection_status_to_log(LobbyInternal.client)
		print("Network.get_local_ping_location()\n", Network.get_local_ping_location())
		table.dump(SteamClient.get_connection_info(LobbyInternal.client), "SteamClient.get_connection_info", 2)
		table.dump(Network.get_relay_network_status(), "Network.get_relay_network_status()", 2)
	end
end

function PingReporter.report(arg_9_0)
	if #arg_9_0._measures == 0 then
		return
	end

	table.sort(arg_9_0._measures)

	local var_9_0 = var_0_3(arg_9_0._measures)
	local var_9_1 = math.sqrt(var_0_5(arg_9_0._measures))
	local var_9_2 = var_0_4(arg_9_0._measures, 99)
	local var_9_3 = var_0_4(arg_9_0._measures, 95)
	local var_9_4 = var_0_4(arg_9_0._measures, 90)
	local var_9_5 = var_0_4(arg_9_0._measures, 75)
	local var_9_6 = var_0_4(arg_9_0._measures, 50)
	local var_9_7 = var_0_4(arg_9_0._measures, 25)
	local var_9_8 = #arg_9_0._measures

	Managers.telemetry_events:network_ping(var_9_0, var_9_1, var_9_2, var_9_3, var_9_4, var_9_5, var_9_6, var_9_7, var_9_8)
end
