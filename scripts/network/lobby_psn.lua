-- chunkname: @scripts/network/lobby_psn.lua

require("scripts/network/lobby_aux")
require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/network/lobby_members")
require("scripts/network_lookup/network_lookup")

local LobbyInternal = LobbyInternal

LobbyInternal = LobbyInternal or {}
LobbyInternal = LobbyInternal
LobbyInternal.lobby_data_version = 2
LobbyInternal.TYPE = "psn"

local flag = false

LobbyInternal.comparison_lookup = {
	less_than = 3,
	greater_or_equal = 6,
	less_or_equal = 4,
	greater_than = 5,
	equal = 1,
	not_equal = 2
}
LobbyInternal.matchmaking_lobby_data = {
	matchmaking = {
		data_type = "integer",
		id = PsnRoom.SEARCHABLE_INTEGER_ID_1
	},
	difficulty = {
		data_type = "integer",
		id = PsnRoom.SEARCHABLE_INTEGER_ID_2
	},
	selected_mission_id = {
		data_type = "integer",
		id = PsnRoom.SEARCHABLE_INTEGER_ID_3
	},
	matchmaking_type = {
		data_type = "integer",
		id = PsnRoom.SEARCHABLE_INTEGER_ID_4
	},
	primary_region = {
		data_type = "integer",
		id = PsnRoom.SEARCHABLE_INTEGER_ID_5
	},
	secondary_region = {
		data_type = "integer",
		id = PsnRoom.SEARCHABLE_INTEGER_ID_6
	},
	network_hash_as_int = {
		data_type = "integer",
		id = PsnRoom.SEARCHABLE_INTEGER_ID_7
	},
	mechanism = {
		data_type = "integer",
		id = PsnRoom.SEARCHABLE_INTEGER_ID_8
	}
}
LobbyInternal.lobby_data_network_lookups = {
	matchmaking = "lobby_data_values",
	secondary_region = "matchmaking_regions",
	twitch_enabled = "lobby_data_values",
	mechanism = "mechanism_keys",
	is_private = "lobby_data_values",
	matchmaking_type = "matchmaking_types",
	mission_id = "mission_ids",
	primary_region = "matchmaking_regions",
	selected_mission_id = "mission_ids",
	difficulty = "difficulties",
	weave_quick_game = "lobby_data_values"
}
LobbyInternal.key_order = {
	"network_hash",
	"difficulty",
	"matchmaking_type",
	"is_private",
	"mission_id",
	"selected_mission_id",
	"matchmaking",
	"num_players",
	"weave_quick_game",
	"session_id",
	"reserved_profiles",
	"unique_server_name",
	"host",
	"country_code",
	"twitch_enabled",
	"power_level",
	"mechanism"
}
LobbyInternal.key_index = {}

for i, v in ipairs(LobbyInternal.key_order) do
	LobbyInternal.key_index[v] = i
end

LobbyInternal.default_lobby_data = {
	twitch_enabled = "false",
	reserved_profiles = "0=0",
	is_private = "false",
	matchmaking_type = "n/a",
	mission_id = "n/a",
	matchmaking = "false",
	num_players = 1,
	selected_mission_id = "n/a",
	difficulty = "normal",
	weave_quick_game = "false"
}

LobbyInternal.init_client = function (self)
	-- function 1
	if not LobbyInternal.client then
		LobbyInternal.client = Network.init_psn_client(self.config_file_name)
		LobbyInternal.psn_room_browser = PSNRoomBrowser:new(LobbyInternal.client)
		LobbyInternal.psn_room_data_external = PsnClient.room_data_external(LobbyInternal.client)
	end

	GameSettingsDevelopment.set_ignored_rpc_logs()
end

LobbyInternal.network_initialized = function ()
	-- function 2
	return not not LobbyInternal.client
end

LobbyInternal.client_ready = function ()
	-- function 3
	return PsnClient.ready(LobbyInternal.client)
end

LobbyInternal.ping = function (arg_4_0)
	-- function 4
	return Network.ping(arg_4_0)
end

LobbyInternal.shutdown_client = function ()
	-- function 5
	Network.shutdown_psn_client(LobbyInternal.client)

	LobbyInternal.client = nil
	LobbyInternal.psn_room_browser = nil
	LobbyInternal.psn_room_data_external = nil

	if not script_data.debug_psn then
		print("[LobbyInternal] shutdown_client")
		print(Script.callstack())
	end
end

LobbyInternal.open_channel = function (self, arg_6_1)
	-- function 6
	local open_channel = PsnRoom.open_channel(self.room_id, arg_6_1)

	printf("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", self, arg_6_1, open_channel)

	return open_channel
end

LobbyInternal.close_channel = function (self, arg_7_1)
	-- function 7
	printf("LobbyInternal.close_channel lobby: %s, channel: %s", self, arg_7_1)
	PsnRoom.close_channel(self.room_id, arg_7_1)
end

LobbyInternal.is_orphaned = function (arg_8_0)
	-- function 8
	return false
end

LobbyInternal.game_session_host = function (self)
	-- function 9
	return PsnRoom.game_session_host(self.room_id)
end

LobbyInternal.create_lobby = function (self)
	-- function 10
	local online_id = Managers.account:online_id()

	online_id = online_id or "UNKNOWN"

	local create_psn_room = Network.create_psn_room(online_id, self.max_members)

	if not script_data.debug_psn then
		print("[LobbyInternal] creating room:", create_psn_room)
		print(Script.callstack())
	end

	return PSNRoom:new(create_psn_room)
end

LobbyInternal.join_lobby = function (self)
	-- function 11
	local id = self.id
	local join_psn_room = Network.join_psn_room(id)

	if not script_data.debug_psn then
		print("[LobbyInternal] joining room [room_id, id]", join_psn_room, id)
		print(Script.callstack())
	end

	return PSNRoom:new(join_psn_room)
end

LobbyInternal.leave_lobby = function (self)
	-- function 12
	if not script_data.debug_psn then
		print("[LobbyInternal] Leaving room:", self.room_id)
		print(Script.callstack())
	end

	Network.leave_psn_room(self.room_id)
end

LobbyInternal.get_lobby = function (self, arg_13_1, arg_13_2)
	-- function 13
	local lobby = self:lobby(arg_13_1)
	local data = lobby.data
	local unserialize_psn_data, var_13_3 = LobbyInternal.unserialize_psn_data(data, arg_13_2)

	unserialize_psn_data.id = lobby.id
	unserialize_psn_data.name = lobby.name

	return unserialize_psn_data, var_13_3
end

LobbyInternal.lobby_browser = function ()
	-- function 14
	return LobbyInternal.psn_room_browser
end

LobbyInternal.client_lost_context = function ()
	-- function 15
	return PsnClient.lost_context(LobbyInternal.client)
end

LobbyInternal.client_failed = function ()
	-- function 16
	return PsnClient.failed(LobbyInternal.client)
end

LobbyInternal.get_lobby_data_from_id = function (arg_17_0)
	-- function 17
	local room_data_entry = LobbyInternal.room_data_entry(arg_17_0)

	if not room_data_entry then
		return room_data_entry.data
	end
end

LobbyInternal.get_lobby_data_from_id_by_key = function (arg_18_0, arg_18_1)
	-- function 18
	local room_data_entry = LobbyInternal.room_data_entry(arg_18_0)

	if not room_data_entry then
		return room_data_entry.data[arg_18_1]
	end
end

LobbyInternal.room_data_refresh = function (arg_19_0)
	-- function 19
	if not script_data.debug_psn then
		printf("[LobbyInternal] Refreshing PsnRoomDataExternal for %s number of rooms:", #arg_19_0)

		for i, v in ipairs(arg_19_0) do
			printf("\tRoomId #%d: %s", i, v)
		end
	end

	PsnRoomDataExternal.refresh(LobbyInternal.psn_room_data_external, arg_19_0)
end

LobbyInternal.room_data_is_refreshing = function ()
	-- function 20
	return PsnRoomDataExternal.is_refreshing(LobbyInternal.psn_room_data_external)
end

LobbyInternal.room_data_all_entries = function ()
	-- function 21
	local all_entries = PsnRoomDataExternal.all_entries(LobbyInternal.psn_room_data_external)

	for i, v in ipairs(all_entries) do
		v.data = LobbyInternal.unserialize_psn_data(v.data)
	end

	return all_entries
end

LobbyInternal.room_data_entry = function (arg_22_0)
	-- function 22
	local entry = PsnRoomDataExternal.entry(LobbyInternal.psn_room_data_external, arg_22_0)

	if not entry then
		entry.data = LobbyInternal.unserialize_psn_data(entry.data)
	end

	return entry
end

LobbyInternal.room_data_num_entries = function ()
	-- function 23
	return PsnRoomDataExternal.num_entries(LobbyInternal.psn_room_data_external)
end

local tbl = {}

LobbyInternal.serialize_psn_data = function (self)
	-- function 24
	table.clear(tbl)

	local lobby_data_network_lookups = LobbyInternal.lobby_data_network_lookups

	for k, v in pairs(LobbyInternal.default_lobby_data) do
		if not self[k] then
			self[k] = v
		end
	end

	for k_2, v_2 in pairs(self) do
		if not lobby_data_network_lookups[k_2] then
			tbl[k_2] = NetworkLookup[lobby_data_network_lookups[k_2]][v_2]
		else
			tbl[k_2] = v_2
		end
	end

	local var_24_1
	local var_24_2

	if not flag then
		var_24_1 = PsnRoom.pack_room_data(tbl)
		var_24_2 = string.len(var_24_1)
	else
		var_24_1 = ""

		for i, v_3 in ipairs(LobbyInternal.key_order) do
			if i > 1 then
				var_24_1 = var_24_1 .. "/"
			end

			local var_24_3 = var_24_1
			local var_24_4 = tbl[v_3]

			var_24_4 = var_24_4 or "1"
			var_24_1 = var_24_3 .. var_24_4
		end

		var_24_2 = string.len(var_24_1)
	end

	fassert(var_24_2 <= PSNRoom.room_data_max_size, "[PSNRoom] Tried to store %d characters in the PSN Room Data, maximum is 255 bytes", var_24_2)

	return var_24_1
end

LobbyInternal.verify_lobby_data = function (self)
	-- function 25
	local network_hash = LobbySetup.network_hash()

	return self.network_hash == network_hash
end

LobbyInternal.unserialize_psn_data = function (arg_26_0, arg_26_1)
	-- function 26
	local var_26_0

	if not flag then
		var_26_0 = PsnRoom.unpack_room_data(arg_26_0)
	else
		var_26_0 = {}

		local split_deprecated = string.split_deprecated(arg_26_0, "/")

		if #split_deprecated > #LobbyInternal.key_order then
			var_26_0.broken_lobby_data = arg_26_0

			return var_26_0, false
		end

		local network_hash = LobbySetup.network_hash()

		if split_deprecated[LobbyInternal.key_index.network_hash] ~= network_hash then
			var_26_0.old_lobby_data = arg_26_0

			return var_26_0, false
		end

		for i = 1, #split_deprecated do
			var_26_0[LobbyInternal.key_order[i]] = split_deprecated[i]
		end
	end

	local lobby_data_network_lookups = LobbyInternal.lobby_data_network_lookups

	if not (not arg_26_1 and LobbyInternal.verify_lobby_data(var_26_0)) then
		return var_26_0, false
	end

	for k, v in pairs(var_26_0) do
		if not lobby_data_network_lookups[k] then
			var_26_0[k] = NetworkLookup[lobby_data_network_lookups[k]][tonumber(v)]
		end
	end

	return var_26_0, true
end

LobbyInternal.clear_filter_requirements = function ()
	-- function 27
	LobbyInternal.psn_room_browser:clear_filters()
end

LobbyInternal.add_filter_requirements = function (self)
	-- function 28
	local psn_room_browser = LobbyInternal.psn_room_browser

	psn_room_browser:clear_filters(psn_room_browser)

	local lobby_data_network_lookups = LobbyInternal.lobby_data_network_lookups

	for k, v in pairs(self.filters) do
		local var_28_2 = LobbyInternal.matchmaking_lobby_data[k]

		if not var_28_2 then
			local id = var_28_2.id
			local value = v.value
			local comparison = v.comparison

			if not lobby_data_network_lookups[k] then
				value = NetworkLookup[lobby_data_network_lookups[k]][value]
			end

			local var_28_6 = LobbyInternal.comparison_lookup[comparison]

			psn_room_browser:add_filter(id, value, var_28_6)
			mm_printf("Filter: %s, comparison(%s), id=%s, value(untouched)=%s, value=%s", tostring(k), tostring(var_28_6), tostring(id), tostring(v.value), tostring(value))
		else
			mm_printf("Skipping filter %q matchmaking_lobby_data not setup. Probably redundant on ps4", k)
		end
	end
end

LobbyInternal._set_matchmaking_data = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0 = LobbyInternal.matchmaking_lobby_data[arg_29_1]

	fassert(var_29_0, "Lobby data key %q is not set up for matchmaking", arg_29_1)

	local lobby_data_network_lookups = LobbyInternal.lobby_data_network_lookups
	local data_type = var_29_0.data_type

	if data_type == "integer" then
		if not lobby_data_network_lookups[arg_29_1] then
			arg_29_2 = NetworkLookup[lobby_data_network_lookups[arg_29_1]][arg_29_2]
		end

		fassert(type(arg_29_2) == "number", "Value needs to be an integer.")
		PsnRoom.set_searchable_attribute(arg_29_0, var_29_0.id, arg_29_2)
	else
		ferror("unsupported data type %q", data_type)
	end
end

LobbyInternal.user_name = function (arg_30_0)
	-- function 30
	return nil
end

LobbyInternal.lobby_id = function (self)
	-- function 31
	return PsnRoom.sce_np_room_id(self.room_id)
end

LobbyInternal.is_friend = function (arg_32_0)
	-- function 32
	print("LobbyInternal.is_friend() is not implemented on the ps4")

	return false
end

LobbyInternal.set_max_members = function (arg_33_0, arg_33_1)
	-- function 33
	ferror("set_max_members not supported on platform.")
end

PSNRoom = class(PSNRoom)
PSNRoom.room_data_max_size = 256

PSNRoom.init = function (self, arg_34_1)
	-- function 34
	self.room_id = arg_34_1
	self._room_data = {}
	self._serialized_room_data = ""
	self._user_names = {}
	self._refresh_room_data = false
	self._refresh_cooldown = 0
end

PSNRoom.state = function (self)
	-- function 35
	return PsnRoom.state(self.room_id)
end

PSNRoom.update = function (self, arg_36_1)
	-- function 36
	self._refresh_cooldown = math.max(self._refresh_cooldown - arg_36_1, 0)

	if not (not self._refresh_room_data and self._refresh_cooldown ~= 0) then
		local len = string.len(self._serialized_room_data)

		fassert(len <= PSNRoom.room_data_max_size, "[PSNRoom] Tried to store %d characters in the PSN Room Data, maximum is 255 bytes", len)
		print("ROOM DATA", self._serialized_room_data)
		PsnRoom.set_data(self.room_id, self._serialized_room_data)
		PsnRoom.set_data_internal(self.room_id, self._serialized_room_data)

		if not script_data.debug_psn then
			printf("[PSNRoom] Setting Packed Room Data: %q, Packed Size: %d/%d", self._serialized_room_data, len, PSNRoom.room_data_max_size)
		end

		self._refresh_room_data = false
		self._refresh_cooldown = 1
	end
end

PSNRoom.set_data = function (self, arg_37_1, arg_37_2)
	-- function 37
	local _room_data = self._room_data

	_room_data[arg_37_1] = tostring(arg_37_2)

	if not LobbyInternal.matchmaking_lobby_data[arg_37_1] then
		LobbyInternal._set_matchmaking_data(self.room_id, arg_37_1, arg_37_2)
	end

	local serialize_psn_data = LobbyInternal.serialize_psn_data(_room_data)

	if serialize_psn_data ~= self._serialized_room_data then
		self._serialized_room_data = serialize_psn_data
		self._refresh_room_data = true
	end
end

PSNRoom.set_data_table = function (self, arg_38_1)
	-- function 38
	local _room_data = self._room_data

	for k, v in pairs(arg_38_1) do
		_room_data[k] = tostring(v)

		if not LobbyInternal.matchmaking_lobby_data[k] then
			LobbyInternal._set_matchmaking_data(self.room_id, k, v)
		end
	end

	local serialize_psn_data = LobbyInternal.serialize_psn_data(_room_data)

	if serialize_psn_data ~= self._serialized_room_data then
		self._serialized_room_data = serialize_psn_data
		self._refresh_room_data = true
	end
end

PSNRoom.data = function (self, arg_39_1)
	-- function 39
	local data_internal = PsnRoom.data_internal(self.room_id)

	return LobbyInternal.unserialize_psn_data(data_internal)[arg_39_1]
end

PSNRoom.members = function (self)
	-- function 40
	local room_id = self.room_id
	local num_members = PsnRoom.num_members(room_id)
	local tbl = {}

	for i = 0, num_members - 1 do
		local member = PsnRoom.member(room_id, i)

		tbl[i + 1] = member.peer_id
	end

	return tbl
end

PSNRoom.members_np_id = function (self, arg_41_1)
	-- function 41
	local room_id = self.room_id
	local num_members = PsnRoom.num_members(room_id)

	for i = 0, num_members - 1 do
		local member = PsnRoom.member(room_id, i)

		arg_41_1[i + 1] = member.np_id
	end
end

PSNRoom.online_id_from_peer_id = function (self, arg_42_1)
	-- function 42
	local room_id = self.room_id
	local num_members = PsnRoom.num_members(room_id)

	for i = 0, num_members - 1 do
		local member = PsnRoom.member(room_id, i)

		if member.peer_id == arg_42_1 then
			return member.online_id
		end
	end

	local var_42_3 = self._user_names[arg_42_1]

	if not var_42_3 then
		return var_42_3
	end

	fassert(false, "[PSNRoom]:np_id_froom_peer_id() No member with peer id(%s) in room(%d)", arg_42_1, room_id)
end

PSNRoom.lobby_host = function (self)
	-- function 43
	return PsnRoom.owner(self.room_id)
end

PSNRoom.sce_np_room_id = function (self)
	-- function 44
	return PsnRoom.sce_np_room_id(self.room_id)
end

PSNRoom.update_user_names = function (self)
	-- function 45
	local room_id = self.room_id
	local num_members = PsnRoom.num_members(room_id)

	for i = 0, num_members - 1 do
		local member = PsnRoom.member(room_id, i)

		self._user_names[member.peer_id] = member.online_id
	end
end

PSNRoom.user_name = function (self, arg_46_1)
	-- function 46
	local var_46_0
	local room_id = self.room_id
	local num_members = PsnRoom.num_members(room_id)

	for i = 0, num_members - 1 do
		local member = PsnRoom.member(room_id, i)

		if member.peer_id == arg_46_1 then
			var_46_0 = member.online_id

			break
		end
	end

	var_46_0 = var_46_0 or self._user_names[arg_46_1]

	return var_46_0
end

PSNRoom.user_id = function (self, arg_47_1)
	-- function 47
	local var_47_0
	local room_id = self.room_id
	local num_members = PsnRoom.num_members(room_id)

	for i = 0, num_members - 1 do
		if PsnRoom.member(room_id, i).peer_id == arg_47_1 then
			var_47_0 = PsnRoom.user_id(room_id, i)
		end
	end

	fassert(var_47_0 ~= nil, "[PSNRoom]:user_id() No member with peer id(%s) in room(%d)", arg_47_1, room_id)

	return var_47_0
end

PSNRoom.set_game_session_host = function (self, arg_48_1)
	-- function 48
	PsnRoom.set_game_session_host(self.room_id, arg_48_1)
end

PSNRoomBrowser = class(PSNRoomBrowser)

PSNRoomBrowser.init = function (self, arg_49_1)
	-- function 49
	self.browser = PsnClient.room_browser(arg_49_1)
end

PSNRoomBrowser.is_refreshing = function (self)
	-- function 50
	return PsnRoomBrowser.is_refreshing(self.browser)
end

PSNRoomBrowser.num_lobbies = function (self)
	-- function 51
	return PsnRoomBrowser.num_rooms(self.browser)
end

PSNRoomBrowser.refresh = function (self)
	-- function 52
	PsnRoomBrowser.refresh(self.browser)
end

PSNRoomBrowser.lobby = function (self, arg_53_1)
	-- function 53
	return PsnRoomBrowser.room(self.browser, arg_53_1)
end

PSNRoomBrowser.add_filter = function (self, arg_54_1, arg_54_2, arg_54_3)
	-- function 54
	PsnRoomBrowser.add_filter(self.browser, arg_54_1, arg_54_2, arg_54_3)
end

PSNRoomBrowser.clear_filters = function (self)
	-- function 55
	PsnRoomBrowser.clear_filters(self.browser)
end
