-- chunkname: @scripts/utils/ping_reporter.lua

PingReporter = class(PingReporter)
PingReporter.NAME = "PingReporter"

local num = 10

local function fn()
	-- function 1
	local players = Managers.player:players()

	for k, v in pairs(players) do
		if not v.local_player then
			return v
		end
	end
end

local function fn_2(arg_2_0)
	-- function 2
	local num = 0

	for k, v in pairs(arg_2_0) do
		num = num + v
	end

	return num
end

local function fn_3(arg_3_0)
	-- function 3
	return fn_2(arg_3_0) / #arg_3_0
end

local function fn_4(self, arg_4_1)
	-- function 4
	return self[math.round(arg_4_1 / 100 * #self)]
end

local function fn_5(arg_5_0)
	-- function 5
	local var_5_0 = fn_3(arg_5_0)
	local tbl = {}

	for k, v in pairs(arg_5_0) do
		tbl[k] = (v - var_5_0)^2
	end

	return fn_3(tbl)
end

PingReporter.init = function (self)
	-- function 6
	self._measures = {}
	self._measure_taken = 0

	if not Application.user_setting("write_network_debug_output_to_log") then
		self._dump_detailed_connection_status = true
	end
end

PingReporter.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if arg_7_2 - self._measure_taken > num then
		self:_take_measure()

		self._measure_taken = math.floor(arg_7_2)
	end
end

PingReporter._take_measure = function (self)
	-- function 8
	local var_8_0 = fn()

	if not var_8_0 then
		return
	end

	local game_object_id = var_8_0.game_object_id
	local game = Managers.state.network:game()

	if (var_8_0.is_server or var_8_0.bot_player or not game) and not game_object_id then
		local game_object_field = GameSession.game_object_field(game, game_object_id, "ping")

		self._measures[#self._measures + 1] = game_object_field
	end

	if not self._dump_detailed_connection_status and not LobbyInternal.client then
		print("\n\nSTEAM NETWORK DEBUG:\n")
		SteamClient.write_detailed_connection_status_to_log(LobbyInternal.client)
		print("Network.get_local_ping_location()\n", Network.get_local_ping_location())
		table.dump(SteamClient.get_connection_info(LobbyInternal.client), "SteamClient.get_connection_info", 2)
		table.dump(Network.get_relay_network_status(), "Network.get_relay_network_status()", 2)
	end
end

PingReporter.report = function (self)
	-- function 9
	if #self._measures == 0 then
		return
	end

	table.sort(self._measures)

	local var_9_0 = fn_3(self._measures)
	local sqrt = math.sqrt(fn_5(self._measures))
	local var_9_2 = fn_4(self._measures, 99)
	local var_9_3 = fn_4(self._measures, 95)
	local var_9_4 = fn_4(self._measures, 90)
	local var_9_5 = fn_4(self._measures, 75)
	local var_9_6 = fn_4(self._measures, 50)
	local var_9_7 = fn_4(self._measures, 25)
	local count = #self._measures

	Managers.telemetry_events:network_ping(var_9_0, sqrt, var_9_2, var_9_3, var_9_4, var_9_5, var_9_6, var_9_7, count)
end
