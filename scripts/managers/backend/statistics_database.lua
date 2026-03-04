-- chunkname: @scripts/managers/backend/statistics_database.lua

require("scripts/managers/backend/statistics_util")
require("scripts/managers/backend/statistics_definitions")

local function var_0_0(arg_1_0, arg_1_1)
	if arg_1_1 == nil then
		return tonumber(arg_1_0)
	elseif arg_1_1 == "string" then
		return arg_1_0
	elseif arg_1_1 == "hexarray" then
		local var_1_0 = {}
		local var_1_1 = 0
		local var_1_2 = math.floor

		for iter_1_0 in arg_1_0:gmatch(".") do
			local var_1_3 = tonumber(iter_1_0, 16)

			for iter_1_1 = 4, 1, -1 do
				local var_1_4 = var_1_3 / 2

				var_1_3 = var_1_2(var_1_4)
				var_1_0[var_1_1 + iter_1_1] = var_1_3 ~= var_1_4 and true or false
			end

			var_1_1 = var_1_1 + 4
		end

		return var_1_0
	end

	assert(false, "Unknown database_type %s for value %s", tostring(arg_1_1), tostring(arg_1_0))
end

local function var_0_1(arg_2_0, arg_2_1)
	if arg_2_1 == nil then
		return tostring(arg_2_0)
	elseif arg_2_1 == "string" then
		return arg_2_0
	elseif arg_2_1 == "hexarray" then
		local var_2_0 = ""
		local var_2_1 = #arg_2_0

		assert(var_2_1 % 4 == 0, "Incorrectly stored statistic")

		for iter_2_0 = 1, var_2_1, 4 do
			local var_2_2 = 0

			for iter_2_1 = 0, 3 do
				var_2_2 = var_2_2 * 2 + (arg_2_0[iter_2_0 + iter_2_1] == true and 1 or 0)
			end

			local var_2_3 = string.format("%X", var_2_2)

			var_2_0 = var_2_0 .. var_2_3
		end

		return var_2_0
	end

	assert(false, "Unknown database_type %s for value %s", tostring(arg_2_1), tostring(arg_2_0))
end

local function var_0_2(...)
	if script_data.statistics_debug then
		printf(...)
	end
end

local var_0_3 = "player"

StatisticsDatabase = class(StatisticsDatabase)

function StatisticsDatabase.init(arg_4_0)
	arg_4_0.statistics = {}
	arg_4_0.local_statistics = {}
end

function StatisticsDatabase.destroy(arg_5_0)
	local var_5_0 = next(arg_5_0.statistics)

	fassert(var_5_0 == nil, "Destroying stats manager without properly cleaning up first. Stat id %s not unregistered.", tostring(var_5_0))
end

local var_0_4 = {
	"rpc_sync_statistics_number",
	"rpc_increment_stat",
	"rpc_increment_stat_group",
	"rpc_set_local_player_stat",
	"rpc_modify_stat",
	"rpc_increment_stat_party"
}

function StatisticsDatabase.register_network_event_delegate(arg_6_0, arg_6_1)
	arg_6_0.network_event_delegate = arg_6_1

	arg_6_1:register(arg_6_0, unpack(var_0_4))
end

function StatisticsDatabase.unregister_network_event_delegate(arg_7_0)
	arg_7_0.network_event_delegate:unregister(arg_7_0)

	arg_7_0.network_event_delegate = nil
end

function StatisticsDatabase._init_backend_stat(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0

	if arg_8_1.name then
		local var_8_1 = arg_8_1.database_name

		if var_8_1 then
			local var_8_2 = arg_8_2[var_8_1]

			if var_8_2 then
				var_8_0 = arg_8_0:_init_stat(arg_8_1, var_0_0(var_8_2, arg_8_1.database_type))
			end
		end
	else
		for iter_8_0, iter_8_1 in pairs(arg_8_1) do
			local var_8_3 = arg_8_0:_init_backend_stat(arg_8_1[iter_8_0], arg_8_2)

			if var_8_3 then
				var_8_0 = var_8_0 or {}
				var_8_0[iter_8_0] = var_8_3
			end
		end
	end

	return var_8_0
end

function StatisticsDatabase._init_stat(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = table.clone(arg_9_1)

	var_9_0.default_value = var_9_0.value

	if arg_9_1.database_name then
		var_9_0.persistent_value = arg_9_2 or var_9_0.value or 0
		var_9_0.persistent_value_mirror = var_9_0.persistent_value
	end

	return var_9_0
end

function StatisticsDatabase.register(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	var_0_2("StatisticsDatabase: Registering id=%s as %s", tostring(arg_10_1), arg_10_2)
	assert(arg_10_0.statistics[arg_10_1] == nil, "There were statistics for %s already.", tostring(arg_10_1))

	local var_10_0 = StatisticsDefinitions[arg_10_2]
	local var_10_1

	if arg_10_3 then
		var_10_1 = arg_10_0:_init_backend_stat(var_10_0, arg_10_3)
	end

	arg_10_0.statistics[arg_10_1] = var_10_1 or {}
end

function StatisticsDatabase.unregister(arg_11_0, arg_11_1)
	var_0_2("StatisticsDatabase: Unregistering id=%s", tostring(arg_11_1))

	local var_11_0 = Managers.state.event

	if var_11_0 then
		var_11_0:trigger("statistics_database_unregister_player", arg_11_1)
	end

	arg_11_0.statistics[arg_11_1] = nil
end

function StatisticsDatabase.is_registered(arg_12_0, arg_12_1)
	return arg_12_0.statistics[arg_12_1]
end

local var_0_5 = {}

local function var_0_6(arg_13_0)
	local var_13_0 = #arg_13_0

	for iter_13_0 = 1, var_13_0 do
		local var_13_1 = arg_13_0[iter_13_0]

		var_0_5[iter_13_0] = NetworkLookup.statistics_path_names[var_13_1]
	end

	for iter_13_1 = var_13_0 + 1, #var_0_5 do
		var_0_5[iter_13_1] = nil
	end

	return var_0_5
end

local function var_0_7(arg_14_0)
	local var_14_0 = {}

	for iter_14_0 = 1, #arg_14_0 do
		local var_14_1 = arg_14_0[iter_14_0]

		var_14_0[iter_14_0] = NetworkLookup.statistics_path_names[var_14_1]
	end

	return var_14_0
end

local function var_0_8(arg_15_0)
	local var_15_0 = 65535

	if var_15_0 < arg_15_0 then
		Application.warning(string.format("Trying to sync value exceeding maximum size %d > %d", arg_15_0, var_15_0))
		print(Script.callstack())

		arg_15_0 = var_15_0
	end

	return arg_15_0
end

local function var_0_9(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	if arg_16_5.value then
		if arg_16_5.sync_on_hot_join then
			fassert(type(arg_16_5.value) == "number", "Not supporting hot join syncing of value %q", type(arg_16_5.value))
			fassert(arg_16_4 <= NetworkConstants.statistics_path_max_size, "statistics path is longer than max size, increase in global.networks_config")

			local var_16_0 = arg_16_5.default_value

			if arg_16_5.value ~= var_16_0 or arg_16_5.persistent_value and arg_16_5.persistent_value ~= var_16_0 then
				local var_16_1 = var_0_7(arg_16_3)
				local var_16_2 = PEER_ID_TO_CHANNEL[arg_16_0]

				RPC.rpc_sync_statistics_number(var_16_2, arg_16_1, arg_16_2, var_16_1, var_0_8(arg_16_5.value), var_0_8(arg_16_5.persistent_value or 0))
			end
		end
	else
		for iter_16_0, iter_16_1 in pairs(arg_16_5) do
			arg_16_3[arg_16_4] = iter_16_0

			var_0_9(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4 + 1, iter_16_1)
		end
	end

	arg_16_3[arg_16_4] = nil
end

local function var_0_10(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	if arg_17_5.value then
		if arg_17_5.sync_to_host then
			fassert(type(arg_17_5.persistent_value) == "number", "Not supporting hot join syncing of value %q", type(arg_17_5.persistent_value))
			fassert(arg_17_4 <= NetworkConstants.statistics_path_max_size, "statistics path is longer than max size, increase in global.networks_config")

			local var_17_0 = arg_17_5.default_value

			if arg_17_5.value ~= var_17_0 or arg_17_5.persistent_value and arg_17_5.persistent_value ~= var_17_0 then
				local var_17_1 = var_0_7(arg_17_3)

				arg_17_0:send_rpc_server("rpc_sync_statistics_number", arg_17_1, arg_17_2, var_17_1, var_0_8(arg_17_5.value), var_0_8(arg_17_5.persistent_value))
			end
		end
	else
		for iter_17_0, iter_17_1 in pairs(arg_17_5) do
			arg_17_3[arg_17_4] = iter_17_0

			var_0_10(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4 + 1, iter_17_1)
		end
	end

	arg_17_3[arg_17_4] = nil
end

function StatisticsDatabase.hot_join_sync(arg_18_0, arg_18_1)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.statistics) do
		local var_18_0 = Managers.player:player_from_stats_id(iter_18_0)

		var_0_9(arg_18_1, var_18_0:network_id(), var_18_0:local_player_id(), {}, 1, iter_18_1)
	end
end

function StatisticsDatabase._create_stat(arg_19_0, arg_19_1, arg_19_2, ...)
	local var_19_0 = arg_19_1
	local var_19_1 = StatisticsDefinitions[var_0_3]

	for iter_19_0 = 1, arg_19_2 - 1 do
		local var_19_2 = select(iter_19_0, ...)

		var_19_1 = var_19_1[var_19_2]

		local var_19_3 = var_19_0[var_19_2] or {}

		var_19_0[var_19_2] = var_19_3
		var_19_0 = var_19_3
	end

	local var_19_4 = select(arg_19_2, ...)
	local var_19_5 = var_19_1[var_19_4]

	if not var_19_5 then
		ferror("[StatisticsDatabase] No statistics definition found with path 'StatisticsDefinitions.%s.%s'", var_0_3, table.concat({
			...
		}, ""))
	end

	local var_19_6 = arg_19_0:_init_stat(var_19_5)

	var_19_0[var_19_4] = var_19_6

	return var_19_6
end

function StatisticsDatabase._get_or_create_stat(arg_20_0, arg_20_1, arg_20_2, ...)
	local var_20_0 = arg_20_0.statistics[arg_20_1]
	local var_20_1 = var_20_0
	local var_20_2 = select("#", ...) - (arg_20_2 or 0)

	for iter_20_0 = 1, var_20_2 do
		var_20_1 = var_20_1[select(iter_20_0, ...)]

		if not var_20_1 then
			return arg_20_0:_create_stat(var_20_0, var_20_2, ...), var_20_2
		end
	end

	return var_20_1, var_20_2
end

local function var_0_11(arg_21_0)
	if arg_21_0.value then
		if arg_21_0.database_type == "hexarray" then
			for iter_21_0 = 1, #arg_21_0.value do
				arg_21_0.value[iter_21_0] = false
			end
		else
			arg_21_0.value = arg_21_0.persistent_value or arg_21_0.default_value or 0
		end
	else
		for iter_21_1, iter_21_2 in pairs(arg_21_0) do
			var_0_11(iter_21_2)
		end
	end
end

function StatisticsDatabase.reset_session_stats(arg_22_0)
	var_0_2("StatisticsDatabase: Resetting all session stats")

	for iter_22_0, iter_22_1 in pairs(arg_22_0.statistics) do
		var_0_11(iter_22_1)
	end

	table.clear(arg_22_0.local_statistics)
end

local function var_0_12(arg_23_0, arg_23_1)
	if arg_23_0.value then
		local var_23_0 = arg_23_0.database_name

		if var_23_0 then
			arg_23_1[var_23_0] = var_0_1(arg_23_0.persistent_value, arg_23_0.database_type)
		end
	else
		for iter_23_0, iter_23_1 in pairs(arg_23_0) do
			var_0_12(iter_23_1, arg_23_1)
		end
	end
end

function StatisticsDatabase.generate_backend_stats(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.statistics[arg_24_1]

	assert(table.is_empty(arg_24_2), "Got non-empty table")
	var_0_12(var_24_0, arg_24_2)

	return arg_24_2
end

function StatisticsDatabase.increment_stat(arg_25_0, arg_25_1, ...)
	local var_25_0 = arg_25_0:_get_or_create_stat(arg_25_1, 0, ...)

	var_25_0.value = var_25_0.value + 1

	if var_25_0.persistent_value then
		var_25_0.dirty = true
		var_25_0.persistent_value = var_25_0.persistent_value + 1
	end

	local var_25_1 = Managers.state.event

	if var_25_1 then
		var_25_1:trigger("event_stat_incremented", arg_25_1, ...)
	end

	var_0_2("StatisticsDatabase: Incremented stat %s for id=%s to %f", var_25_0.name, tostring(arg_25_1), var_25_0.value)
end

function StatisticsDatabase.decrement_stat(arg_26_0, arg_26_1, ...)
	local var_26_0 = arg_26_0:_get_or_create_stat(arg_26_1, 0, ...)

	var_26_0.value = var_26_0.value - 1

	if var_26_0.persistent_value then
		var_26_0.dirty = true
		var_26_0.persistent_value = var_26_0.persistent_value - 1
	end

	var_0_2("StatisticsDatabase: Decremented stat %s for id=%s to %f", var_26_0.name, tostring(arg_26_1), var_26_0.value)
end

function StatisticsDatabase.increment_stat_and_sync_to_clients(arg_27_0, arg_27_1)
	local var_27_0 = Managers.player:local_player()

	if var_27_0 then
		local var_27_1 = arg_27_0:get_persistent_stat(var_27_0:stats_id(), arg_27_1)

		arg_27_0:set_stat(var_27_0:stats_id(), arg_27_1, var_27_1 + 1)
	end

	local var_27_2 = Managers.state.network
	local var_27_3 = NetworkLookup.statistics[arg_27_1]

	var_27_2.network_transmit:send_rpc_clients("rpc_increment_stat", var_27_3)
end

function StatisticsDatabase.modify_stat_by_amount(arg_28_0, arg_28_1, ...)
	local var_28_0, var_28_1 = arg_28_0:_get_or_create_stat(arg_28_1, 1, ...)
	local var_28_2 = select(var_28_1 + 1, ...)
	local var_28_3 = var_28_0.value

	var_28_0.value = var_28_3 + var_28_2

	if var_28_0.persistent_value then
		var_28_0.dirty = var_28_2 ~= 0
		var_28_0.persistent_value = var_28_0.persistent_value + var_28_2
	end

	local var_28_4 = Managers.state.event

	if var_28_4 then
		var_28_4:trigger("event_stat_modified_by", arg_28_1, ...)
	end

	var_0_2("StatisticsDatabase: Modified stat %s for id=%s from %f to %f", var_28_0.name, tostring(arg_28_1), var_28_3, var_28_3 + var_28_2)
end

function StatisticsDatabase.get_persistent_array_stat(arg_29_0, arg_29_1, ...)
	local var_29_0, var_29_1 = arg_29_0:_get_or_create_stat(arg_29_1, 1, ...)
	local var_29_2 = select(var_29_1 + 1, ...)

	if var_29_0.persistent_value then
		return var_29_0.persistent_value[var_29_2]
	end

	return false
end

function StatisticsDatabase.set_array_stat(arg_30_0, arg_30_1, ...)
	local var_30_0, var_30_1 = arg_30_0:_get_or_create_stat(arg_30_1, 2, ...)
	local var_30_2 = select(var_30_1 + 1, ...)
	local var_30_3 = select(var_30_1 + 2, ...)

	var_30_0.value[var_30_2] = var_30_3

	if var_30_0.persistent_value then
		var_30_0.persistent_value[var_30_2] = var_30_3
	end

	var_0_2("StatisticsDatabase: Set array stat %s[%s] for id=%s to %s", var_30_0.name, tostring(var_30_2), tostring(arg_30_1), tostring(var_30_3))
end

function StatisticsDatabase.set_stat(arg_31_0, arg_31_1, ...)
	local var_31_0, var_31_1 = arg_31_0:_get_or_create_stat(arg_31_1, 1, ...)
	local var_31_2 = select(var_31_1 + 1, ...)

	var_31_0.dirty = var_31_0.value ~= var_31_2
	var_31_0.value = var_31_2
	var_31_0.persistent_value = var_31_2
end

function StatisticsDatabase.set_non_persistent_stat(arg_32_0, arg_32_1, ...)
	local var_32_0, var_32_1 = arg_32_0:_get_or_create_stat(arg_32_1, 1, ...)
	local var_32_2 = select(var_32_1 + 1, ...)

	var_32_0.dirty = var_32_0.value ~= var_32_2
	var_32_0.value = var_32_2
end

function StatisticsDatabase._get_stat(arg_33_0, arg_33_1, ...)
	local var_33_0 = select("#", ...)

	for iter_33_0 = 1, var_33_0 do
		arg_33_1 = arg_33_1[select(iter_33_0, ...)]

		if not arg_33_1 then
			return nil
		end
	end

	return arg_33_1
end

function StatisticsDatabase.get_stat(arg_34_0, arg_34_1, ...)
	local var_34_0 = arg_34_0:_get_or_create_stat(arg_34_1, 0, ...)

	return var_34_0 and var_34_0.value or 0
end

function StatisticsDatabase.has_stat(arg_35_0, ...)
	local var_35_0 = StatisticsDefinitions[var_0_3]

	return not not arg_35_0:_get_stat(var_35_0, ...)
end

function StatisticsDatabase.get_persistent_stat(arg_36_0, arg_36_1, ...)
	local var_36_0 = arg_36_0.statistics[arg_36_1]
	local var_36_1 = arg_36_0:_get_stat(var_36_0, ...)

	if var_36_1 then
		return var_36_1.persistent_value
	else
		local var_36_2 = arg_36_0:_get_stat(StatisticsDefinitions[var_0_3], ...)

		if not var_36_2 then
			ferror("[StatisticsDatabase] Failed fetching statistic using parameters: %s", table.concat({
				...
			}, ", "))
		end

		if var_36_2.database_name then
			return var_36_2.value
		end
	end

	return nil
end

function StatisticsDatabase.sync_stats_to_server(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	local var_37_0 = arg_37_0.statistics[arg_37_1]

	var_0_10(arg_37_4, arg_37_2, arg_37_3, {}, 1, var_37_0)
end

local function var_0_13(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = type(arg_38_1)

	if var_38_0 == "number" then
		if math.ceil(arg_38_1) == arg_38_1 then
			Debug.text("%s%s = %d", string.rep(" ", arg_38_2 * 2), arg_38_0, arg_38_1)
		else
			Debug.text("%s%s = %.2f", string.rep(" ", arg_38_2 * 2), arg_38_0, arg_38_1)
		end
	elseif var_38_0 == "table" then
		Debug.text("%s%s", string.rep(" ", arg_38_2 * 2), arg_38_0, arg_38_1)

		for iter_38_0, iter_38_1 in pairs(arg_38_1) do
			var_0_13(iter_38_0, iter_38_1, arg_38_2 + 1)
		end
	end
end

function StatisticsDatabase.debug_draw(arg_39_0)
	if not script_data.statistics_debug then
		return
	end

	for iter_39_0, iter_39_1 in pairs(arg_39_0.statistics) do
		Debug.text("Stats for %s", tostring(iter_39_0))

		for iter_39_2, iter_39_3 in pairs(iter_39_1) do
			var_0_13(iter_39_2, iter_39_3, 1)
		end
	end
end

function StatisticsDatabase.rpc_increment_stat(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = NetworkLookup.statistics[arg_40_2]
	local var_40_1 = Managers.player:local_player()

	if not var_40_1 then
		return
	end

	local var_40_2 = var_40_1:stats_id()

	arg_40_0:increment_stat(var_40_2, var_40_0)
end

function StatisticsDatabase.rpc_increment_stat_group(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = NetworkLookup.statistics_group_name[arg_41_2]
	local var_41_1 = NetworkLookup.statistics[arg_41_3]
	local var_41_2 = Managers.player:local_player()

	if not var_41_2 then
		return
	end

	local var_41_3 = var_41_2:stats_id()

	arg_41_0:increment_stat(var_41_3, var_41_0, var_41_1)
end

function StatisticsDatabase.rpc_increment_stat_party(arg_42_0, arg_42_1, arg_42_2)
	if Managers.state.network.is_server then
		local var_42_0 = Managers.state.network.network_transmit
		local var_42_1 = CHANNEL_TO_PEER_ID[arg_42_1]

		var_42_0:send_rpc_clients_except("rpc_increment_stat_party", var_42_1, arg_42_2)
	end

	local var_42_2 = Managers.player:local_player()

	if not var_42_2 then
		return
	end

	local var_42_3 = var_42_2:stats_id()
	local var_42_4 = NetworkLookup.statistics[arg_42_2]

	arg_42_0:increment_stat(var_42_3, var_42_4)
end

function StatisticsDatabase.rpc_set_local_player_stat(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = NetworkLookup.statistics[arg_43_2]
	local var_43_1 = Managers.player:local_player()

	if not var_43_1 then
		return
	end

	local var_43_2 = var_43_1:stats_id()

	if arg_43_3 > arg_43_0:get_stat(var_43_2, var_43_0) then
		arg_43_0:set_stat(var_43_2, var_43_0, arg_43_3)
	end
end

function StatisticsDatabase.rpc_sync_statistics_number(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6)
	local var_44_0 = Managers.player:player(arg_44_2, arg_44_3):stats_id()
	local var_44_1 = var_0_6(arg_44_4)
	local var_44_2 = arg_44_0:_get_or_create_stat(var_44_0, 0, unpack(var_44_1))

	var_44_2.value = arg_44_5

	if var_44_2.database_name then
		var_44_2.persistent_value = arg_44_6

		var_0_2("StatisticsDatabase: Synced peer %q stat %30q to %d, persistent_value to %d", arg_44_2, var_44_2.name, arg_44_5, arg_44_6)
	else
		fassert(arg_44_6 == 0, "Got non-zero persistent_value for stat %q that didn't have database_name", var_44_2.name)
		var_0_2("StatisticsDatabase: Synced peer %q stat %30q to %d, persistent_value not present", arg_44_2, var_44_2.name, arg_44_5)
	end
end

function StatisticsDatabase.rpc_modify_stat(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = NetworkLookup.statistics[arg_45_2]
	local var_45_1 = Managers.player:local_player()

	if not var_45_1 then
		return
	end

	local var_45_2 = var_45_1:stats_id()

	arg_45_0:modify_stat_by_amount(var_45_2, var_45_0, arg_45_3)
end

function StatisticsDatabase.get_all_stats(arg_46_0, arg_46_1)
	return arg_46_0.statistics[arg_46_1]
end

function StatisticsDatabase.get_local_stat(arg_47_0, arg_47_1)
	return arg_47_0.local_statistics[arg_47_1]
end

function StatisticsDatabase.set_local_stat(arg_48_0, arg_48_1, arg_48_2)
	arg_48_0.local_statistics[arg_48_1] = arg_48_2
end

function StatisticsDatabase.increment_local_stat(arg_49_0, arg_49_1)
	if not arg_49_0.local_statistics[arg_49_1] then
		arg_49_0.local_statistics[arg_49_1] = 0
	end

	arg_49_0.local_statistics[arg_49_1] = arg_49_0.local_statistics[arg_49_1] + 1
end

local function var_0_14(arg_50_0)
	if arg_50_0.value then
		if arg_50_0.persistent_value and arg_50_0.dirty then
			if arg_50_0.database_type == "hexarray" then
				for iter_50_0 = 1, #arg_50_0.persistent_value do
					arg_50_0.persistent_value_mirror[iter_50_0] = arg_50_0.persistent_value[iter_50_0]
				end
			else
				arg_50_0.persistent_value_mirror = arg_50_0.persistent_value
			end
		end
	else
		for iter_50_1, iter_50_2 in pairs(arg_50_0) do
			var_0_14(iter_50_2)
		end
	end
end

function StatisticsDatabase.apply_persistant_stats(arg_51_0)
	var_0_2("StatisticsDatabase: Applying all session stats")

	for iter_51_0, iter_51_1 in pairs(arg_51_0.statistics) do
		var_0_14(iter_51_1)
	end
end

local function var_0_15(arg_52_0)
	if arg_52_0.value then
		if arg_52_0.persistent_value and arg_52_0.dirty then
			if arg_52_0.database_type == "hexarray" then
				for iter_52_0 = 1, #arg_52_0.persistent_value do
					arg_52_0.persistent_value[iter_52_0] = arg_52_0.persistent_value_mirror[iter_52_0]
					arg_52_0.value[iter_52_0] = arg_52_0.persistent_value[iter_52_0] or false
				end
			else
				arg_52_0.persistent_value = arg_52_0.persistent_value_mirror
				arg_52_0.value = arg_52_0.persistent_value or arg_52_0.default_value or 0
			end

			arg_52_0.dirty = false
		end
	else
		for iter_52_1, iter_52_2 in pairs(arg_52_0) do
			var_0_15(iter_52_2)
		end
	end
end

function StatisticsDatabase.reset_persistant_stats(arg_53_0)
	var_0_2("StatisticsDatabase: Reseting all session stats")

	for iter_53_0, iter_53_1 in pairs(arg_53_0.statistics) do
		local var_53_0 = arg_53_0.statistics[iter_53_0]

		var_0_15(var_53_0)
	end
end

local var_0_16 = false

if var_0_16 then
	local var_0_17 = var_0_3

	var_0_3 = "unit_test"

	local var_0_18 = script_data.statistics_debug

	script_data.statistics_debug = true

	var_0_2("Running statistics unit test")

	local var_0_19 = {
		kills_total = 10,
		lorebook_unlocks = "6F"
	}
	local var_0_20 = StatisticsDatabase:new()

	var_0_20:register("player1", "unit_test", var_0_19)
	assert(var_0_20:get_stat("player1", "kills_total") == 0)
	assert(var_0_20:get_stat("player1", "profiles", "witch_hunter", "kills_total") == 0)
	var_0_20:increment_stat("player1", "kills_total")
	var_0_20:increment_stat("player1", "profiles", "witch_hunter", "kills_total")
	assert(var_0_20:get_stat("player1", "kills_total") == 1)
	assert(var_0_20:get_stat("player1", "profiles", "witch_hunter", "kills_total") == 1)
	var_0_20:decrement_stat("player1", "kills_total")
	var_0_20:decrement_stat("player1", "profiles", "witch_hunter", "kills_total")
	assert(var_0_20:get_stat("player1", "kills_total") == 0)
	assert(var_0_20:get_stat("player1", "profiles", "witch_hunter", "kills_total") == 0)
	var_0_20:modify_stat_by_amount("player1", "kills_total", 5)
	var_0_20:modify_stat_by_amount("player1", "profiles", "witch_hunter", "kills_total", 5)
	assert(var_0_20:get_stat("player1", "kills_total") == 5)
	assert(var_0_20:get_stat("player1", "profiles", "witch_hunter", "kills_total") == 5)
	var_0_20:reset_session_stats()
	assert(var_0_20:get_stat("player1", "kills_total") == 0)
	assert(var_0_20:get_stat("player1", "profiles", "witch_hunter", "kills_total") == 0)

	local var_0_21 = {}

	var_0_20:generate_backend_stats("player1", var_0_21)
	assert(var_0_21.kills_total == tostring(15))
	assert(var_0_21.lorebook_unlocks == "EF")
	var_0_20:unregister("player1")
	var_0_20:destroy()

	script_data.statistics_debug = var_0_18
	var_0_3 = var_0_17
end
