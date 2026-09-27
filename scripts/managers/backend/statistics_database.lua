-- chunkname: @scripts/managers/backend/statistics_database.lua

require("scripts/managers/backend/statistics_util")
require("scripts/managers/backend/statistics_definitions")

local function fn(self, arg_1_1)
	-- function 1
	if arg_1_1 == nil then
		return tonumber(self)
	elseif arg_1_1 == "string" then
		return self
	elseif arg_1_1 == "hexarray" then
		local tbl = {}
		local num = 0
		local floor = math.floor

		for iter_1_0 in self:gmatch(".") do
			local var_1_3 = tonumber(iter_1_0, 16)

			for j = 4, 1, -1 do
				local num_2 = var_1_3 / 2

				var_1_3 = floor(num_2)

				local num_3 = num + j
				local flag

				flag = var_1_3 == num_2 or not true or false
				tbl[num_3] = flag
			end

			num = num + 4
		end

		return tbl
	end

	assert(false, "Unknown database_type %s for value %s", tostring(arg_1_1), tostring(self))
end

local function fn_2(self, arg_2_1)
	-- function 2
	if arg_2_1 == nil then
		return tostring(self)
	elseif arg_2_1 == "string" then
		return self
	elseif arg_2_1 == "hexarray" then
		local str = ""
		local count = #self

		assert(count % 4 == 0, "Incorrectly stored statistic")

		for i = 1, count, 4 do
			local num = 0

			for j = 0, 3 do
				local num_2 = num * 2
				local flag

				flag = self[i + j] ~= true or not 1 or 0
				num = num_2 + flag
			end

			local format = string.format("%X", num)

			str = str .. format
		end

		return str
	end

	assert(false, "Unknown database_type %s for value %s", tostring(arg_2_1), tostring(self))
end

local function fn_3(...)
	-- function 3
	if not script_data.statistics_debug then
		printf(...)
	end
end

local str = "player"

StatisticsDatabase = class(StatisticsDatabase)

StatisticsDatabase.init = function (self)
	-- function 4
	self.statistics = {}
	self.local_statistics = {}
end

StatisticsDatabase.destroy = function (self)
	-- function 5
	local var_5_0 = next(self.statistics)

	fassert(var_5_0 == nil, "Destroying stats manager without properly cleaning up first. Stat id %s not unregistered.", tostring(var_5_0))
end

local tbl = {
	"rpc_sync_statistics_number",
	"rpc_increment_stat",
	"rpc_increment_stat_group",
	"rpc_set_local_player_stat",
	"rpc_modify_stat",
	"rpc_increment_stat_party"
}

StatisticsDatabase.register_network_event_delegate = function (self, arg_6_1)
	-- function 6
	self.network_event_delegate = arg_6_1

	arg_6_1:register(self, unpack(tbl))
end

StatisticsDatabase.unregister_network_event_delegate = function (self)
	-- function 7
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

StatisticsDatabase._init_backend_stat = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0

	if not arg_8_1.name then
		local database_name = arg_8_1.database_name

		if not database_name then
			local var_8_2 = arg_8_2[database_name]

			if not var_8_2 then
				var_8_0 = self:_init_stat(arg_8_1, fn(var_8_2, arg_8_1.database_type))
			end
		end
	else
		for k, v in pairs(arg_8_1) do
			local _init_backend_stat = self:_init_backend_stat(arg_8_1[k], arg_8_2)

			if not _init_backend_stat then
				var_8_0 = var_8_0 or {}
				var_8_0[k] = _init_backend_stat
			end
		end
	end

	return var_8_0
end

StatisticsDatabase._init_stat = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local clone = table.clone(arg_9_1)

	clone.default_value = clone.value

	if not arg_9_1.database_name then
		if not arg_9_2 then
			-- Nothing
		end

		::label_9_0::

		local value = clone.value

		value = value or 0

		::label_9_1::

		clone.persistent_value = value
		clone.persistent_value_mirror = clone.persistent_value
	end

	return clone
end

StatisticsDatabase.register = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	fn_3("StatisticsDatabase: Registering id=%s as %s", tostring(arg_10_1), arg_10_2)
	assert(self.statistics[arg_10_1] == nil, "There were statistics for %s already.", tostring(arg_10_1))

	local var_10_0 = StatisticsDefinitions[arg_10_2]
	local var_10_1

	if not arg_10_3 then
		var_10_1 = self:_init_backend_stat(var_10_0, arg_10_3)
	end

	self.statistics[arg_10_1] = var_10_1 or {}
end

StatisticsDatabase.unregister = function (arg_11_0, arg_11_1)
	-- function 11
	fn_3("StatisticsDatabase: Unregistering id=%s", tostring(arg_11_1))

	local event = Managers.state.event

	if not event then
		event:trigger("statistics_database_unregister_player", arg_11_1)
	end

	arg_11_0.statistics[arg_11_1] = nil
end

StatisticsDatabase.is_registered = function (self, arg_12_1)
	-- function 12
	return self.statistics[arg_12_1]
end

local tbl_2 = {}

local function fn_4(self)
	-- function 13
	local count = #self

	for i = 1, count do
		local var_13_1 = self[i]

		tbl_2[i] = NetworkLookup.statistics_path_names[var_13_1]
	end

	for j = count + 1, #tbl_2 do
		tbl_2[j] = nil
	end

	return tbl_2
end

local function fn_5(self)
	-- function 14
	local tbl = {}

	for i = 1, #self do
		local var_14_1 = self[i]

		tbl[i] = NetworkLookup.statistics_path_names[var_14_1]
	end

	return tbl
end

local function fn_6(arg_15_0)
	-- function 15
	local num = 65535

	if num < arg_15_0 then
		Application.warning(string.format("Trying to sync value exceeding maximum size %d > %d", arg_15_0, num))
		print(Script.callstack())

		arg_15_0 = num
	end

	return arg_15_0
end

local function fn_7(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	if not arg_16_5.value then
		if not arg_16_5.sync_on_hot_join then
			fassert(type(arg_16_5.value) == "number", "Not supporting hot join syncing of value %q", type(arg_16_5.value))
			fassert(arg_16_4 <= NetworkConstants.statistics_path_max_size, "statistics path is longer than max size, increase in global.networks_config")

			local default_value = arg_16_5.default_value

			if not ((arg_16_5.value ~= default_value or not arg_16_5.persistent_value) and arg_16_5.persistent_value == default_value) then
				local var_16_1 = fn_5(arg_16_3)
				local var_16_2, rpc_sync_statistics_number = PEER_ID_TO_CHANNEL[arg_16_0], RPC.rpc_sync_statistics_number
				local var_16_4 = arg_16_1
				local var_16_5 = arg_16_2
				local var_16_6 = var_16_1
				local var_16_7 = fn_6(arg_16_5.value)
				local var_16_8 = fn_6
				local persistent_value = arg_16_5.persistent_value

				persistent_value = persistent_value or 0

				rpc_sync_statistics_number(var_16_2, var_16_4, var_16_5, var_16_6, var_16_7, var_16_8(persistent_value))
			end
		end
	else
		for k, v in pairs(arg_16_5) do
			arg_16_3[arg_16_4] = k

			fn_7(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4 + 1, v)
		end
	end

	arg_16_3[arg_16_4] = nil
end

local function fn_8(self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	if not arg_17_5.value then
		if not arg_17_5.sync_to_host then
			fassert(type(arg_17_5.persistent_value) == "number", "Not supporting hot join syncing of value %q", type(arg_17_5.persistent_value))
			fassert(arg_17_4 <= NetworkConstants.statistics_path_max_size, "statistics path is longer than max size, increase in global.networks_config")

			local default_value = arg_17_5.default_value

			if not ((arg_17_5.value ~= default_value or not arg_17_5.persistent_value) and arg_17_5.persistent_value == default_value) then
				local var_17_1 = fn_5(arg_17_3)

				self:send_rpc_server("rpc_sync_statistics_number", arg_17_1, arg_17_2, var_17_1, fn_6(arg_17_5.value), fn_6(arg_17_5.persistent_value))
			end
		end
	else
		for k, v in pairs(arg_17_5) do
			arg_17_3[arg_17_4] = k

			fn_8(self, arg_17_1, arg_17_2, arg_17_3, arg_17_4 + 1, v)
		end
	end

	arg_17_3[arg_17_4] = nil
end

StatisticsDatabase.hot_join_sync = function (self, arg_18_1)
	-- function 18
	for k, v in pairs(self.statistics) do
		local player_from_stats_id = Managers.player:player_from_stats_id(k)

		fn_7(arg_18_1, player_from_stats_id:network_id(), player_from_stats_id:local_player_id(), {}, 1, v)
	end
end

StatisticsDatabase._create_stat = function (self, arg_19_1, arg_19_2, ...)
	-- function 19
	local var_19_0 = arg_19_1
	local var_19_1 = StatisticsDefinitions[str]

	for i = 1, arg_19_2 - 1 do
		local var_19_2 = select(i, ...)

		var_19_1 = var_19_1[var_19_2]

		local var_19_3 = var_19_0[var_19_2]

		var_19_3 = var_19_3 or {}
		var_19_0[var_19_2] = var_19_3
		var_19_0 = var_19_3
	end

	local var_19_4 = select(arg_19_2, ...)
	local var_19_5 = var_19_1[var_19_4]

	if not var_19_5 then
		ferror("[StatisticsDatabase] No statistics definition found with path 'StatisticsDefinitions.%s.%s'", str, table.concat({
			...
		}, ""))
	end

	local _init_stat = self:_init_stat(var_19_5)

	var_19_0[var_19_4] = _init_stat

	return _init_stat
end

StatisticsDatabase._get_or_create_stat = function (self, arg_20_1, arg_20_2, ...)
	-- function 20
	local var_20_0 = self.statistics[arg_20_1]
	local var_20_1 = var_20_0
	local num = select("#", ...) - (arg_20_2 or 0)

	for i = 1, num do
		var_20_1 = var_20_1[select(i, ...)]

		if not var_20_1 then
			return self:_create_stat(var_20_0, num, ...), num
		end
	end

	return var_20_1, num
end

local function fn_9(self)
	-- function 21
	if not self.value then
		if self.database_type == "hexarray" then
			for i = 1, #self.value do
				self.value[i] = false
			end
		else
			local persistent_value = self.persistent_value

			if not persistent_value then
				persistent_value = self.default_value
				persistent_value = persistent_value or 0
			end

			self.value = persistent_value
		end
	else
		for k, v in pairs(self) do
			fn_9(v)
		end
	end
end

StatisticsDatabase.reset_session_stats = function (self)
	-- function 22
	fn_3("StatisticsDatabase: Resetting all session stats")

	for k, v in pairs(self.statistics) do
		fn_9(v)
	end

	table.clear(self.local_statistics)
end

local function fn_10(self, arg_23_1)
	-- function 23
	if not self.value then
		local database_name = self.database_name

		if not database_name then
			arg_23_1[database_name] = fn_2(self.persistent_value, self.database_type)
		end
	else
		for k, v in pairs(self) do
			fn_10(v, arg_23_1)
		end
	end
end

StatisticsDatabase.generate_backend_stats = function (self, arg_24_1, arg_24_2)
	-- function 24
	local var_24_0 = self.statistics[arg_24_1]

	assert(table.is_empty(arg_24_2), "Got non-empty table")
	fn_10(var_24_0, arg_24_2)

	return arg_24_2
end

StatisticsDatabase.increment_stat = function (self, arg_25_1, ...)
	-- function 25
	local _get_or_create_stat = self:_get_or_create_stat(arg_25_1, 0, ...)

	_get_or_create_stat.value = _get_or_create_stat.value + 1

	if not _get_or_create_stat.persistent_value then
		_get_or_create_stat.dirty = true
		_get_or_create_stat.persistent_value = _get_or_create_stat.persistent_value + 1
	end

	local event = Managers.state.event

	if not event then
		event:trigger("event_stat_incremented", arg_25_1, ...)
	end

	fn_3("StatisticsDatabase: Incremented stat %s for id=%s to %f", _get_or_create_stat.name, tostring(arg_25_1), _get_or_create_stat.value)
end

StatisticsDatabase.decrement_stat = function (self, arg_26_1, ...)
	-- function 26
	local _get_or_create_stat = self:_get_or_create_stat(arg_26_1, 0, ...)

	_get_or_create_stat.value = _get_or_create_stat.value - 1

	if not _get_or_create_stat.persistent_value then
		_get_or_create_stat.dirty = true
		_get_or_create_stat.persistent_value = _get_or_create_stat.persistent_value - 1
	end

	fn_3("StatisticsDatabase: Decremented stat %s for id=%s to %f", _get_or_create_stat.name, tostring(arg_26_1), _get_or_create_stat.value)
end

StatisticsDatabase.increment_stat_and_sync_to_clients = function (self, arg_27_1)
	-- function 27
	local local_player = Managers.player:local_player()

	if not local_player then
		local get_persistent_stat = self:get_persistent_stat(local_player:stats_id(), arg_27_1)

		self:set_stat(local_player:stats_id(), arg_27_1, get_persistent_stat + 1)
	end

	local network = Managers.state.network
	local var_27_3 = NetworkLookup.statistics[arg_27_1]

	network.network_transmit:send_rpc_clients("rpc_increment_stat", var_27_3)
end

StatisticsDatabase.modify_stat_by_amount = function (self, arg_28_1, ...)
	-- function 28
	local _get_or_create_stat, var_28_1 = self:_get_or_create_stat(arg_28_1, 1, ...)
	local var_28_2 = select(var_28_1 + 1, ...)
	local value = _get_or_create_stat.value

	_get_or_create_stat.value = value + var_28_2

	if not _get_or_create_stat.persistent_value then
		_get_or_create_stat.dirty = var_28_2 ~= 0
		_get_or_create_stat.persistent_value = _get_or_create_stat.persistent_value + var_28_2
	end

	local event = Managers.state.event

	if not event then
		event:trigger("event_stat_modified_by", arg_28_1, ...)
	end

	fn_3("StatisticsDatabase: Modified stat %s for id=%s from %f to %f", _get_or_create_stat.name, tostring(arg_28_1), value, value + var_28_2)
end

StatisticsDatabase.get_persistent_array_stat = function (self, arg_29_1, ...)
	-- function 29
	local _get_or_create_stat, var_29_1 = self:_get_or_create_stat(arg_29_1, 1, ...)
	local var_29_2 = select(var_29_1 + 1, ...)

	if not _get_or_create_stat.persistent_value then
		return _get_or_create_stat.persistent_value[var_29_2]
	end

	return false
end

StatisticsDatabase.set_array_stat = function (self, arg_30_1, ...)
	-- function 30
	local _get_or_create_stat, var_30_1 = self:_get_or_create_stat(arg_30_1, 2, ...)
	local var_30_2 = select(var_30_1 + 1, ...)
	local var_30_3 = select(var_30_1 + 2, ...)

	_get_or_create_stat.value[var_30_2] = var_30_3

	if not _get_or_create_stat.persistent_value then
		_get_or_create_stat.persistent_value[var_30_2] = var_30_3
	end

	fn_3("StatisticsDatabase: Set array stat %s[%s] for id=%s to %s", _get_or_create_stat.name, tostring(var_30_2), tostring(arg_30_1), tostring(var_30_3))
end

StatisticsDatabase.set_stat = function (self, arg_31_1, ...)
	-- function 31
	local _get_or_create_stat, var_31_1 = self:_get_or_create_stat(arg_31_1, 1, ...)
	local var_31_2 = select(var_31_1 + 1, ...)

	_get_or_create_stat.dirty = _get_or_create_stat.value ~= var_31_2
	_get_or_create_stat.value = var_31_2
	_get_or_create_stat.persistent_value = var_31_2
end

StatisticsDatabase.set_non_persistent_stat = function (self, arg_32_1, ...)
	-- function 32
	local _get_or_create_stat, var_32_1 = self:_get_or_create_stat(arg_32_1, 1, ...)
	local var_32_2 = select(var_32_1 + 1, ...)

	_get_or_create_stat.dirty = _get_or_create_stat.value ~= var_32_2
	_get_or_create_stat.value = var_32_2
end

StatisticsDatabase._get_stat = function (arg_33_0, arg_33_1, ...)
	-- function 33
	local var_33_0 = select("#", ...)

	for i = 1, var_33_0 do
		arg_33_1 = arg_33_1[select(i, ...)]

		if not arg_33_1 then
			return nil
		end
	end

	return arg_33_1
end

StatisticsDatabase.get_stat = function (self, arg_34_1, ...)
	-- function 34
	local _get_or_create_stat = self:_get_or_create_stat(arg_34_1, 0, ...)
	local value

	if not _get_or_create_stat then
		value = _get_or_create_stat.value

		if not value then
			-- Nothing
		end
	end

	value = 0

	::label_34_0::

	return value
end

StatisticsDatabase.has_stat = function (self, ...)
	-- function 35
	local var_35_0 = StatisticsDefinitions[str]

	return not not self:_get_stat(var_35_0, ...)
end

StatisticsDatabase.get_persistent_stat = function (self, arg_36_1, ...)
	-- function 36
	local var_36_0 = self.statistics[arg_36_1]
	local _get_stat = self:_get_stat(var_36_0, ...)

	if not _get_stat then
		return _get_stat.persistent_value
	else
		local _get_stat_2 = self:_get_stat(StatisticsDefinitions[str], ...)

		if not _get_stat_2 then
			ferror("[StatisticsDatabase] Failed fetching statistic using parameters: %s", table.concat({
				...
			}, ", "))
		end

		if not _get_stat_2.database_name then
			return _get_stat_2.value
		end
	end

	return nil
end

StatisticsDatabase.sync_stats_to_server = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	local var_37_0 = self.statistics[arg_37_1]

	fn_8(arg_37_4, arg_37_2, arg_37_3, {}, 1, var_37_0)
end

local function fn_11(arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	local var_38_0 = type(arg_38_1)

	if var_38_0 == "number" then
		if math.ceil(arg_38_1) == arg_38_1 then
			Debug.text("%s%s = %d", string.rep(" ", arg_38_2 * 2), arg_38_0, arg_38_1)
		else
			Debug.text("%s%s = %.2f", string.rep(" ", arg_38_2 * 2), arg_38_0, arg_38_1)
		end
	elseif var_38_0 == "table" then
		Debug.text("%s%s", string.rep(" ", arg_38_2 * 2), arg_38_0, arg_38_1)

		for k, v in pairs(arg_38_1) do
			fn_11(k, v, arg_38_2 + 1)
		end
	end
end

StatisticsDatabase.debug_draw = function (self)
	-- function 39
	if not script_data.statistics_debug then
		return
	end

	for k, v in pairs(self.statistics) do
		Debug.text("Stats for %s", tostring(k))

		for k_2, v_2 in pairs(v) do
			fn_11(k_2, v_2, 1)
		end
	end
end

StatisticsDatabase.rpc_increment_stat = function (self, arg_40_1, arg_40_2)
	-- function 40
	local var_40_0 = NetworkLookup.statistics[arg_40_2]
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local stats_id = local_player:stats_id()

	self:increment_stat(stats_id, var_40_0)
end

StatisticsDatabase.rpc_increment_stat_group = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	local var_41_0 = NetworkLookup.statistics_group_name[arg_41_2]
	local var_41_1 = NetworkLookup.statistics[arg_41_3]
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local stats_id = local_player:stats_id()

	self:increment_stat(stats_id, var_41_0, var_41_1)
end

StatisticsDatabase.rpc_increment_stat_party = function (self, arg_42_1, arg_42_2)
	-- function 42
	if not Managers.state.network.is_server then
		local network_transmit = Managers.state.network.network_transmit
		local var_42_1 = CHANNEL_TO_PEER_ID[arg_42_1]

		network_transmit:send_rpc_clients_except("rpc_increment_stat_party", var_42_1, arg_42_2)
	end

	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local stats_id = local_player:stats_id()
	local var_42_4 = NetworkLookup.statistics[arg_42_2]

	self:increment_stat(stats_id, var_42_4)
end

StatisticsDatabase.rpc_set_local_player_stat = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local var_43_0 = NetworkLookup.statistics[arg_43_2]
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local stats_id = local_player:stats_id()

	if arg_43_3 > self:get_stat(stats_id, var_43_0) then
		self:set_stat(stats_id, var_43_0, arg_43_3)
	end
end

StatisticsDatabase.rpc_sync_statistics_number = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6)
	-- function 44
	local stats_id = Managers.player:player(arg_44_2, arg_44_3):stats_id()
	local var_44_1 = fn_4(arg_44_4)
	local _get_or_create_stat = self:_get_or_create_stat(stats_id, 0, unpack(var_44_1))

	_get_or_create_stat.value = arg_44_5

	if not _get_or_create_stat.database_name then
		_get_or_create_stat.persistent_value = arg_44_6

		fn_3("StatisticsDatabase: Synced peer %q stat %30q to %d, persistent_value to %d", arg_44_2, _get_or_create_stat.name, arg_44_5, arg_44_6)
	else
		fassert(arg_44_6 == 0, "Got non-zero persistent_value for stat %q that didn't have database_name", _get_or_create_stat.name)
		fn_3("StatisticsDatabase: Synced peer %q stat %30q to %d, persistent_value not present", arg_44_2, _get_or_create_stat.name, arg_44_5)
	end
end

StatisticsDatabase.rpc_modify_stat = function (self, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	local var_45_0 = NetworkLookup.statistics[arg_45_2]
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local stats_id = local_player:stats_id()

	self:modify_stat_by_amount(stats_id, var_45_0, arg_45_3)
end

StatisticsDatabase.get_all_stats = function (self, arg_46_1)
	-- function 46
	return self.statistics[arg_46_1]
end

StatisticsDatabase.get_local_stat = function (self, arg_47_1)
	-- function 47
	return self.local_statistics[arg_47_1]
end

StatisticsDatabase.set_local_stat = function (arg_48_0, arg_48_1, arg_48_2)
	-- function 48
	arg_48_0.local_statistics[arg_48_1] = arg_48_2
end

StatisticsDatabase.increment_local_stat = function (self, arg_49_1)
	-- function 49
	if not self.local_statistics[arg_49_1] then
		self.local_statistics[arg_49_1] = 0
	end

	self.local_statistics[arg_49_1] = self.local_statistics[arg_49_1] + 1
end

local function fn_12(self)
	-- function 50
	if not self.value then
		if not self.persistent_value and not self.dirty then
			if self.database_type == "hexarray" then
				for i = 1, #self.persistent_value do
					self.persistent_value_mirror[i] = self.persistent_value[i]
				end
			else
				self.persistent_value_mirror = self.persistent_value
			end
		end
	else
		for k, v in pairs(self) do
			fn_12(v)
		end
	end
end

StatisticsDatabase.apply_persistant_stats = function (self)
	-- function 51
	fn_3("StatisticsDatabase: Applying all session stats")

	for k, v in pairs(self.statistics) do
		fn_12(v)
	end
end

local function fn_13(self)
	-- function 52
	if not self.value then
		if not self.persistent_value and not self.dirty then
			if self.database_type == "hexarray" then
				for i = 1, #self.persistent_value do
					self.persistent_value[i] = self.persistent_value_mirror[i]

					local value = self.value
					local var_52_1 = self.persistent_value[i]

					var_52_1 = var_52_1 or false
					value[i] = var_52_1
				end
			else
				self.persistent_value = self.persistent_value_mirror

				local persistent_value = self.persistent_value

				if not persistent_value then
					persistent_value = self.default_value
					persistent_value = persistent_value or 0
				end

				self.value = persistent_value
			end

			self.dirty = false
		end
	else
		for k, v in pairs(self) do
			fn_13(v)
		end
	end
end

StatisticsDatabase.reset_persistant_stats = function (self)
	-- function 53
	fn_3("StatisticsDatabase: Reseting all session stats")

	for k, v in pairs(self.statistics) do
		local var_53_0 = self.statistics[k]

		fn_13(var_53_0)
	end
end

local flag = false

if not flag then
	local var_0_17 = str

	str = "unit_test"

	local statistics_debug = script_data.statistics_debug

	script_data.statistics_debug = true

	fn_3("Running statistics unit test")

	local tbl_3 = {
		kills_total = 10,
		lorebook_unlocks = "6F"
	}
	local var_0_20 = StatisticsDatabase:new()

	var_0_20:register("player1", "unit_test", tbl_3)
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

	local tbl_4 = {}

	var_0_20:generate_backend_stats("player1", tbl_4)
	assert(tbl_4.kills_total == tostring(15))
	assert(tbl_4.lorebook_unlocks == "EF")
	var_0_20:unregister("player1")
	var_0_20:destroy()

	script_data.statistics_debug = statistics_debug
	str = var_0_17
end
