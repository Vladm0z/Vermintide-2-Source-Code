-- chunkname: @scripts/network/lobby_psn.lua

require("scripts/network/lobby_aux")
require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/network/lobby_members")
require("scripts/network_lookup/network_lookup")

LobbyInternal = LobbyInternal or {}
LobbyInternal.lobby_data_version = 2
LobbyInternal.TYPE = "psn"

local var_0_0 = false

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

for iter_0_0, iter_0_1 in ipairs(LobbyInternal.key_order) do
	LobbyInternal.key_index[iter_0_1] = iter_0_0
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

function LobbyInternal.init_client(arg_1_0)
	if not LobbyInternal.client then
		LobbyInternal.client = Network.init_psn_client(arg_1_0.config_file_name)
		LobbyInternal.psn_room_browser = PSNRoomBrowser:new(LobbyInternal.client)
		LobbyInternal.psn_room_data_external = PsnClient.room_data_external(LobbyInternal.client)
	end

	GameSettingsDevelopment.set_ignored_rpc_logs()
end

function LobbyInternal.network_initialized()
	return not not LobbyInternal.client
end

function LobbyInternal.client_ready()
	return PsnClient.ready(LobbyInternal.client)
end

function LobbyInternal.ping(arg_4_0)
	return Network.ping(arg_4_0)
end

function LobbyInternal.shutdown_client()
	Network.shutdown_psn_client(LobbyInternal.client)

	LobbyInternal.client = nil
	LobbyInternal.psn_room_browser = nil
	LobbyInternal.psn_room_data_external = nil

	if script_data.debug_psn then
		print("[LobbyInternal] shutdown_client")
		print(Script.callstack())
	end
end

function LobbyInternal.open_channel(arg_6_0, arg_6_1)
	local var_6_0 = PsnRoom.open_channel(arg_6_0.room_id, arg_6_1)

	printf("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", arg_6_0, arg_6_1, var_6_0)

	return var_6_0
end

function LobbyInternal.close_channel(arg_7_0, arg_7_1)
	printf("LobbyInternal.close_channel lobby: %s, channel: %s", arg_7_0, arg_7_1)
	PsnRoom.close_channel(arg_7_0.room_id, arg_7_1)
end

function LobbyInternal.is_orphaned(arg_8_0)
	return false
end

function LobbyInternal.game_session_host(arg_9_0)
	return PsnRoom.game_session_host(arg_9_0.room_id)
end

function LobbyInternal.create_lobby(arg_10_0)
	local var_10_0 = Managers.account:online_id() or "UNKNOWN"
	local var_10_1 = Network.create_psn_room(var_10_0, arg_10_0.max_members)

	if script_data.debug_psn then
		print("[LobbyInternal] creating room:", var_10_1)
		print(Script.callstack())
	end

	return PSNRoom:new(var_10_1)
end

function LobbyInternal.join_lobby(arg_11_0)
	local var_11_0 = arg_11_0.id
	local var_11_1 = Network.join_psn_room(var_11_0)

	if script_data.debug_psn then
		print("[LobbyInternal] joining room [room_id, id]", var_11_1, var_11_0)
		print(Script.callstack())
	end

	return PSNRoom:new(var_11_1)
end

function LobbyInternal.leave_lobby(arg_12_0)
	if script_data.debug_psn then
		print("[LobbyInternal] Leaving room:", arg_12_0.room_id)
		print(Script.callstack())
	end

	Network.leave_psn_room(arg_12_0.room_id)
end

function LobbyInternal.get_lobby(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0:lobby(arg_13_1)
	local var_13_1 = var_13_0.data
	local var_13_2, var_13_3 = LobbyInternal.unserialize_psn_data(var_13_1, arg_13_2)

	var_13_2.id = var_13_0.id
	var_13_2.name = var_13_0.name

	return var_13_2, var_13_3
end

function LobbyInternal.lobby_browser()
	return LobbyInternal.psn_room_browser
end

function LobbyInternal.client_lost_context()
	return PsnClient.lost_context(LobbyInternal.client)
end

function LobbyInternal.client_failed()
	return PsnClient.failed(LobbyInternal.client)
end

function LobbyInternal.get_lobby_data_from_id(arg_17_0)
	local var_17_0 = LobbyInternal.room_data_entry(arg_17_0)

	if var_17_0 then
		return var_17_0.data
	end
end

function LobbyInternal.get_lobby_data_from_id_by_key(arg_18_0, arg_18_1)
	local var_18_0 = LobbyInternal.room_data_entry(arg_18_0)

	if var_18_0 then
		return var_18_0.data[arg_18_1]
	end
end

function LobbyInternal.room_data_refresh(arg_19_0)
	if script_data.debug_psn then
		printf("[LobbyInternal] Refreshing PsnRoomDataExternal for %s number of rooms:", #arg_19_0)

		for iter_19_0, iter_19_1 in ipairs(arg_19_0) do
			printf("\tRoomId #%d: %s", iter_19_0, iter_19_1)
		end
	end

	PsnRoomDataExternal.refresh(LobbyInternal.psn_room_data_external, arg_19_0)
end

function LobbyInternal.room_data_is_refreshing()
	return PsnRoomDataExternal.is_refreshing(LobbyInternal.psn_room_data_external)
end

function LobbyInternal.room_data_all_entries()
	local var_21_0 = PsnRoomDataExternal.all_entries(LobbyInternal.psn_room_data_external)

	for iter_21_0, iter_21_1 in ipairs(var_21_0) do
		iter_21_1.data = LobbyInternal.unserialize_psn_data(iter_21_1.data)
	end

	return var_21_0
end

function LobbyInternal.room_data_entry(arg_22_0)
	local var_22_0 = PsnRoomDataExternal.entry(LobbyInternal.psn_room_data_external, arg_22_0)

	if var_22_0 then
		var_22_0.data = LobbyInternal.unserialize_psn_data(var_22_0.data)
	end

	return var_22_0
end

function LobbyInternal.room_data_num_entries()
	return PsnRoomDataExternal.num_entries(LobbyInternal.psn_room_data_external)
end

local var_0_1 = {}

function LobbyInternal.serialize_psn_data(arg_24_0)
	table.clear(var_0_1)

	local var_24_0 = LobbyInternal.lobby_data_network_lookups

	for iter_24_0, iter_24_1 in pairs(LobbyInternal.default_lobby_data) do
		if not arg_24_0[iter_24_0] then
			arg_24_0[iter_24_0] = iter_24_1
		end
	end

	for iter_24_2, iter_24_3 in pairs(arg_24_0) do
		if var_24_0[iter_24_2] then
			var_0_1[iter_24_2] = NetworkLookup[var_24_0[iter_24_2]][iter_24_3]
		else
			var_0_1[iter_24_2] = iter_24_3
		end
	end

	local var_24_1
	local var_24_2

	if var_0_0 then
		var_24_1 = PsnRoom.pack_room_data(var_0_1)
		var_24_2 = string.len(var_24_1)
	else
		var_24_1 = ""

		for iter_24_4, iter_24_5 in ipairs(LobbyInternal.key_order) do
			if iter_24_4 > 1 then
				var_24_1 = var_24_1 .. "/"
			end

			var_24_1 = var_24_1 .. (var_0_1[iter_24_5] or "1")
		end

		var_24_2 = string.len(var_24_1)
	end

	fassert(var_24_2 <= PSNRoom.room_data_max_size, "[PSNRoom] Tried to store %d characters in the PSN Room Data, maximum is 255 bytes", var_24_2)

	return var_24_1
end

function LobbyInternal.verify_lobby_data(arg_25_0)
	local var_25_0 = LobbySetup.network_hash()

	return arg_25_0.network_hash == var_25_0
end

function LobbyInternal.unserialize_psn_data(arg_26_0, arg_26_1)
	local var_26_0

	if var_0_0 then
		var_26_0 = PsnRoom.unpack_room_data(arg_26_0)
	else
		var_26_0 = {}

		local var_26_1 = string.split_deprecated(arg_26_0, "/")

		if #var_26_1 > #LobbyInternal.key_order then
			var_26_0.broken_lobby_data = arg_26_0

			return var_26_0, false
		end

		local var_26_2 = LobbySetup.network_hash()

		if var_26_1[LobbyInternal.key_index.network_hash] ~= var_26_2 then
			var_26_0.old_lobby_data = arg_26_0

			return var_26_0, false
		end

		for iter_26_0 = 1, #var_26_1 do
			var_26_0[LobbyInternal.key_order[iter_26_0]] = var_26_1[iter_26_0]
		end
	end

	local var_26_3 = LobbyInternal.lobby_data_network_lookups

	if arg_26_1 and not LobbyInternal.verify_lobby_data(var_26_0) then
		return var_26_0, false
	end

	for iter_26_1, iter_26_2 in pairs(var_26_0) do
		if var_26_3[iter_26_1] then
			var_26_0[iter_26_1] = NetworkLookup[var_26_3[iter_26_1]][tonumber(iter_26_2)]
		end
	end

	return var_26_0, true
end

function LobbyInternal.clear_filter_requirements()
	LobbyInternal.psn_room_browser:clear_filters()
end

function LobbyInternal.add_filter_requirements(arg_28_0)
	local var_28_0 = LobbyInternal.psn_room_browser

	var_28_0:clear_filters(var_28_0)

	local var_28_1 = LobbyInternal.lobby_data_network_lookups

	for iter_28_0, iter_28_1 in pairs(arg_28_0.filters) do
		local var_28_2 = LobbyInternal.matchmaking_lobby_data[iter_28_0]

		if var_28_2 then
			local var_28_3 = var_28_2.id
			local var_28_4 = iter_28_1.value
			local var_28_5 = iter_28_1.comparison

			if var_28_1[iter_28_0] then
				var_28_4 = NetworkLookup[var_28_1[iter_28_0]][var_28_4]
			end

			local var_28_6 = LobbyInternal.comparison_lookup[var_28_5]

			var_28_0:add_filter(var_28_3, var_28_4, var_28_6)
			mm_printf("Filter: %s, comparison(%s), id=%s, value(untouched)=%s, value=%s", tostring(iter_28_0), tostring(var_28_6), tostring(var_28_3), tostring(iter_28_1.value), tostring(var_28_4))
		else
			mm_printf("Skipping filter %q matchmaking_lobby_data not setup. Probably redundant on ps4", iter_28_0)
		end
	end
end

function LobbyInternal._set_matchmaking_data(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = LobbyInternal.matchmaking_lobby_data[arg_29_1]

	fassert(var_29_0, "Lobby data key %q is not set up for matchmaking", arg_29_1)

	local var_29_1 = LobbyInternal.lobby_data_network_lookups
	local var_29_2 = var_29_0.data_type

	if var_29_2 == "integer" then
		if var_29_1[arg_29_1] then
			arg_29_2 = NetworkLookup[var_29_1[arg_29_1]][arg_29_2]
		end

		fassert(type(arg_29_2) == "number", "Value needs to be an integer.")
		PsnRoom.set_searchable_attribute(arg_29_0, var_29_0.id, arg_29_2)
	else
		ferror("unsupported data type %q", var_29_2)
	end
end

function LobbyInternal.user_name(arg_30_0)
	return nil
end

function LobbyInternal.lobby_id(arg_31_0)
	return PsnRoom.sce_np_room_id(arg_31_0.room_id)
end

function LobbyInternal.is_friend(arg_32_0)
	print("LobbyInternal.is_friend() is not implemented on the ps4")

	return false
end

function LobbyInternal.set_max_members(arg_33_0, arg_33_1)
	ferror("set_max_members not supported on platform.")
end

PSNRoom = class(PSNRoom)
PSNRoom.room_data_max_size = 256

function PSNRoom.init(arg_34_0, arg_34_1)
	arg_34_0.room_id = arg_34_1
	arg_34_0._room_data = {}
	arg_34_0._serialized_room_data = ""
	arg_34_0._user_names = {}
	arg_34_0._refresh_room_data = false
	arg_34_0._refresh_cooldown = 0
end

function PSNRoom.state(arg_35_0)
	return PsnRoom.state(arg_35_0.room_id)
end

function PSNRoom.update(arg_36_0, arg_36_1)
	arg_36_0._refresh_cooldown = math.max(arg_36_0._refresh_cooldown - arg_36_1, 0)

	if arg_36_0._refresh_room_data and arg_36_0._refresh_cooldown == 0 then
		local var_36_0 = string.len(arg_36_0._serialized_room_data)

		fassert(var_36_0 <= PSNRoom.room_data_max_size, "[PSNRoom] Tried to store %d characters in the PSN Room Data, maximum is 255 bytes", var_36_0)
		print("ROOM DATA", arg_36_0._serialized_room_data)
		PsnRoom.set_data(arg_36_0.room_id, arg_36_0._serialized_room_data)
		PsnRoom.set_data_internal(arg_36_0.room_id, arg_36_0._serialized_room_data)

		if script_data.debug_psn then
			printf("[PSNRoom] Setting Packed Room Data: %q, Packed Size: %d/%d", arg_36_0._serialized_room_data, var_36_0, PSNRoom.room_data_max_size)
		end

		arg_36_0._refresh_room_data = false
		arg_36_0._refresh_cooldown = 1
	end
end

function PSNRoom.set_data(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0._room_data

	var_37_0[arg_37_1] = tostring(arg_37_2)

	if LobbyInternal.matchmaking_lobby_data[arg_37_1] then
		LobbyInternal._set_matchmaking_data(arg_37_0.room_id, arg_37_1, arg_37_2)
	end

	local var_37_1 = LobbyInternal.serialize_psn_data(var_37_0)

	if var_37_1 ~= arg_37_0._serialized_room_data then
		arg_37_0._serialized_room_data = var_37_1
		arg_37_0._refresh_room_data = true
	end
end

function PSNRoom.set_data_table(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._room_data

	for iter_38_0, iter_38_1 in pairs(arg_38_1) do
		var_38_0[iter_38_0] = tostring(iter_38_1)

		if LobbyInternal.matchmaking_lobby_data[iter_38_0] then
			LobbyInternal._set_matchmaking_data(arg_38_0.room_id, iter_38_0, iter_38_1)
		end
	end

	local var_38_1 = LobbyInternal.serialize_psn_data(var_38_0)

	if var_38_1 ~= arg_38_0._serialized_room_data then
		arg_38_0._serialized_room_data = var_38_1
		arg_38_0._refresh_room_data = true
	end
end

function PSNRoom.data(arg_39_0, arg_39_1)
	local var_39_0 = PsnRoom.data_internal(arg_39_0.room_id)

	return LobbyInternal.unserialize_psn_data(var_39_0)[arg_39_1]
end

function PSNRoom.members(arg_40_0)
	local var_40_0 = arg_40_0.room_id
	local var_40_1 = PsnRoom.num_members(var_40_0)
	local var_40_2 = {}

	for iter_40_0 = 0, var_40_1 - 1 do
		local var_40_3 = PsnRoom.member(var_40_0, iter_40_0)

		var_40_2[iter_40_0 + 1] = var_40_3.peer_id
	end

	return var_40_2
end

function PSNRoom.members_np_id(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0.room_id
	local var_41_1 = PsnRoom.num_members(var_41_0)

	for iter_41_0 = 0, var_41_1 - 1 do
		local var_41_2 = PsnRoom.member(var_41_0, iter_41_0)

		arg_41_1[iter_41_0 + 1] = var_41_2.np_id
	end
end

function PSNRoom.online_id_from_peer_id(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.room_id
	local var_42_1 = PsnRoom.num_members(var_42_0)

	for iter_42_0 = 0, var_42_1 - 1 do
		local var_42_2 = PsnRoom.member(var_42_0, iter_42_0)

		if var_42_2.peer_id == arg_42_1 then
			return var_42_2.online_id
		end
	end

	local var_42_3 = arg_42_0._user_names[arg_42_1]

	if var_42_3 then
		return var_42_3
	end

	fassert(false, "[PSNRoom]:np_id_froom_peer_id() No member with peer id(%s) in room(%d)", arg_42_1, var_42_0)
end

function PSNRoom.lobby_host(arg_43_0)
	return PsnRoom.owner(arg_43_0.room_id)
end

function PSNRoom.sce_np_room_id(arg_44_0)
	return PsnRoom.sce_np_room_id(arg_44_0.room_id)
end

function PSNRoom.update_user_names(arg_45_0)
	local var_45_0 = arg_45_0.room_id
	local var_45_1 = PsnRoom.num_members(var_45_0)

	for iter_45_0 = 0, var_45_1 - 1 do
		local var_45_2 = PsnRoom.member(var_45_0, iter_45_0)

		arg_45_0._user_names[var_45_2.peer_id] = var_45_2.online_id
	end
end

function PSNRoom.user_name(arg_46_0, arg_46_1)
	local var_46_0
	local var_46_1 = arg_46_0.room_id
	local var_46_2 = PsnRoom.num_members(var_46_1)

	for iter_46_0 = 0, var_46_2 - 1 do
		local var_46_3 = PsnRoom.member(var_46_1, iter_46_0)

		if var_46_3.peer_id == arg_46_1 then
			var_46_0 = var_46_3.online_id

			break
		end
	end

	var_46_0 = var_46_0 or arg_46_0._user_names[arg_46_1]

	return var_46_0
end

function PSNRoom.user_id(arg_47_0, arg_47_1)
	local var_47_0
	local var_47_1 = arg_47_0.room_id
	local var_47_2 = PsnRoom.num_members(var_47_1)

	for iter_47_0 = 0, var_47_2 - 1 do
		if PsnRoom.member(var_47_1, iter_47_0).peer_id == arg_47_1 then
			var_47_0 = PsnRoom.user_id(var_47_1, iter_47_0)
		end
	end

	fassert(var_47_0 ~= nil, "[PSNRoom]:user_id() No member with peer id(%s) in room(%d)", arg_47_1, var_47_1)

	return var_47_0
end

function PSNRoom.set_game_session_host(arg_48_0, arg_48_1)
	PsnRoom.set_game_session_host(arg_48_0.room_id, arg_48_1)
end

PSNRoomBrowser = class(PSNRoomBrowser)

function PSNRoomBrowser.init(arg_49_0, arg_49_1)
	arg_49_0.browser = PsnClient.room_browser(arg_49_1)
end

function PSNRoomBrowser.is_refreshing(arg_50_0)
	return PsnRoomBrowser.is_refreshing(arg_50_0.browser)
end

function PSNRoomBrowser.num_lobbies(arg_51_0)
	return PsnRoomBrowser.num_rooms(arg_51_0.browser)
end

function PSNRoomBrowser.refresh(arg_52_0)
	PsnRoomBrowser.refresh(arg_52_0.browser)
end

function PSNRoomBrowser.lobby(arg_53_0, arg_53_1)
	return PsnRoomBrowser.room(arg_53_0.browser, arg_53_1)
end

function PSNRoomBrowser.add_filter(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	PsnRoomBrowser.add_filter(arg_54_0.browser, arg_54_1, arg_54_2, arg_54_3)
end

function PSNRoomBrowser.clear_filters(arg_55_0)
	PsnRoomBrowser.clear_filters(arg_55_0.browser)
end
