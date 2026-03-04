-- chunkname: @scripts/network/lobby_aux.lua

LobbyAux = LobbyAux or {}

local function var_0_0()
	local var_1_0

	for iter_1_0, iter_1_1 in pairs(DLCSettings) do
		var_1_0 = var_1_0 and var_1_0 .. "__" or ""
		var_1_0 = var_1_0 .. iter_1_0
	end

	return var_1_0
end

LobbyAux.create_network_hash = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = Network.config_hash(arg_2_0)
	local var_2_1 = Application.settings()
	local var_2_2 = var_2_1 and var_2_1.content_revision
	local var_2_3 = Development.parameter("ignore_engine_revision_in_network_hash") or Managers.mechanism:setting("ignore_engine_revision_in_network_hash")
	local var_2_4 = var_2_3 and 0 or Application.build_identifier()
	local var_2_5
	local var_2_6 = GameSettingsDevelopment.network_revision_check_enabled or var_2_2 ~= nil and var_2_2 ~= ""
	local var_2_7 = GameSettingsDevelopment.network_concatenated_dlc_check_enabled and var_0_0() or ""
	local var_2_8 = DEDICATED_SERVER and GameServerInternal.lobby_data_version or LobbyInternal.lobby_data_version
	local var_2_9 = #NetworkLookup.level_keys

	if var_2_6 then
		fassert(var_2_2, "No trunk_revision even though it needs to exist!")

		var_2_5 = Application.make_hash(var_2_0, var_2_2, var_2_4, arg_2_1, var_2_7, var_2_8, var_2_9)

		if not arg_2_2 then
			printf("[LobbyAux] Making combined_hash: %s from network_hash=%s, trunk_revision=%s, engine_revision=%s, project_hash=%s, lobby_data_version=%s, num_levels=%s", tostring(var_2_5), tostring(var_2_0), tostring(var_2_2), tostring(var_2_4), tostring(arg_2_1), tostring(var_2_8), tostring(var_2_9))
		end
	else
		var_2_5 = Application.make_hash(var_2_0, var_2_4, arg_2_1, var_2_7, var_2_8, var_2_9)

		if not arg_2_2 then
			printf("[LobbyAux] Making combined_hash: %s from network_hash=%s, engine_revision=%s, project_hash=%s, lobby_data_version=%s, num_levels=%s", tostring(var_2_5), tostring(var_2_0), tostring(var_2_4), tostring(arg_2_1), tostring(var_2_8), tostring(var_2_9))
		end
	end

	if not arg_2_2 and not IS_CONSOLE then
		printf("GameServerAux.create_network_hash network_hash: %s, trunk_revision/content_revision: %s, ignore_engine_revision: %s, engine_revision: %s, , concatenated_dlc_string %s, use_trunk_revision %s, combined_hash %s, lobby_data_version=%s", var_2_0, var_2_2, var_2_3, var_2_4, var_2_7, var_2_6, var_2_5, tostring(var_2_8))
	end

	return var_2_5
end

LobbyFinderState = LobbyFinderState or {}
LobbyFinderState.SEARCHING = "searching"
LobbyFinderState.IDLE = "idle"
LobbyState = LobbyState or {}

if IS_XB1 then
	LobbyState.WORKING = "working"
	LobbyState.JOINED = "joined"
	LobbyState.FAILED = "failed"
	LobbyState.SHUTDOWN = "shutdown"
elseif IS_PS4 then
	LobbyState.WAITING_TO_CREATE = "waiting_to_create"
	LobbyState.CREATING = "creating"
	LobbyState.JOINING = "joining"
	LobbyState.JOINED = "joined"
	LobbyState.FAILED = "failed"
else
	LobbyState.CREATING = "creating"
	LobbyState.JOINING = "joining"
	LobbyState.JOINED = "joined"
	LobbyState.FAILED = "failed"
end

LobbyGameModes = {
	"adventure",
	"custom",
	"n/a",
	"tutorial",
	"event",
	"deed",
	"weave",
	"twitch"
}

local var_0_1 = {}

for iter_0_0, iter_0_1 in pairs(LobbyGameModes) do
	var_0_1[iter_0_0] = iter_0_1
	var_0_1[iter_0_1] = iter_0_0
end

LobbyGameModes = var_0_1
LobbyAux.map_lobby_distance_filter = IS_PS4 and {
	"close",
	"medium",
	"world"
} or {
	"close",
	"far",
	"world"
}

local var_0_2 = {}

for iter_0_2 = 1, #LobbyAux.map_lobby_distance_filter do
	var_0_2[LobbyAux.map_lobby_distance_filter[iter_0_2]] = LobbyAux.map_lobby_distance_filter[iter_0_2 + 1]
end

LobbyAux.next_distance_filter = var_0_2

LobbyAux.get_next_lobby_distance_filter = function (arg_3_0, arg_3_1)
	if arg_3_0 == arg_3_1 then
		return
	end

	return LobbyAux.next_distance_filter[arg_3_0]
end

LobbyAux.get_unique_server_name = function ()
	local var_4_0 = Development.parameter("unique_server_name")

	if not var_4_0 or var_4_0 == "" then
		if rawget(_G, "Steam") then
			var_4_0 = Steam.user_name()
		elseif IS_XB1 then
			var_4_0 = LobbyInternal.SESSION_NAME
		else
			var_4_0 = Network.peer_id()
		end
	end

	return var_4_0
end

LobbyAux.MAX_CUSTOM_SERVER_NAME_LENGTH = 32

local function var_0_3(arg_5_0)
	local var_5_0 = arg_5_0.selected_mission_id or arg_5_0.mission_id
	local var_5_1 = var_5_0 and rawget(NetworkLookup.mission_ids, var_5_0)

	var_5_1 = var_5_1 or WeaveSettings.templates[var_5_0] and true

	return var_5_1
end

local function var_0_4(arg_6_0)
	local var_6_0 = arg_6_0.difficulty

	if not var_6_0 or not DifficultySettings[var_6_0] then
		return false
	end

	return true
end

local function var_0_5(arg_7_0)
	local var_7_0 = tonumber(arg_7_0.matchmaking_type)

	if not var_7_0 or not NetworkLookup.matchmaking_types[var_7_0] then
		return false
	end

	return true
end

local function var_0_6(arg_8_0)
	local var_8_0 = arg_8_0.mechanism

	if not var_8_0 or not MechanismSettings[var_8_0] then
		return false
	end

	return true
end

LobbyAux.verify_lobby_data = function (arg_9_0)
	if not var_0_3(arg_9_0) then
		return false
	end

	if not var_0_4(arg_9_0) then
		return false
	end

	if not var_0_5(arg_9_0) then
		return false
	end

	if not var_0_6(arg_9_0) then
		return false
	end

	return true
end

local var_0_7 = ";"
local var_0_8 = ","
local var_0_9 = "="
local var_0_10 = 1
local var_0_11 = 2

LobbyAux.serialize_lobby_reservation_data = function (arg_10_0)
	local var_10_0 = {}

	for iter_10_0 = 1, #arg_10_0 do
		local var_10_1 = arg_10_0[iter_10_0]

		for iter_10_1 = 1, #var_10_1 do
			local var_10_2 = var_10_1[iter_10_1]
			local var_10_3 = var_10_2.peer_id
			local var_10_4 = var_10_2.profile_index or -1

			var_10_1[iter_10_1] = string.format("%s%s%d", var_10_3, var_0_9, var_10_4)
		end

		var_10_0[iter_10_0] = table.concat(var_10_1, var_0_8)
	end

	local var_10_5 = table.concat(var_10_0, var_0_7)

	if var_10_5 == "" then
		var_10_5 = rawget(_G, "LobbyInternal") and LobbyInternal.default_lobby_data and LobbyInternal.default_lobby_data.reserved_profiles or ""
	end

	return var_10_5
end

LobbyAux.deserialize_lobby_reservation_data = function (arg_11_0, arg_11_1)
	local var_11_0 = {}
	local var_11_1 = arg_11_0.reserved_profiles

	var_11_1 = var_11_1 ~= "" and var_11_1 or rawget(_G, "LobbyInternal") and LobbyInternal.default_lobby_data and LobbyInternal.default_lobby_data.reserved_profiles or ""

	local var_11_2 = string.split(var_11_1, var_0_7)

	for iter_11_0 = 1, #var_11_2 do
		local var_11_3 = {}

		var_11_0[iter_11_0] = var_11_3

		local var_11_4 = string.split(var_11_2[iter_11_0], var_0_8)

		for iter_11_1 = 1, #var_11_4 do
			local var_11_5 = string.split(var_11_4[iter_11_1], var_0_9)
			local var_11_6 = var_11_5[var_0_10]
			local var_11_7 = tonumber(var_11_5[var_0_11])

			if var_11_7 == -1 then
				var_11_7 = nil
			end

			if var_11_7 or arg_11_1 then
				var_11_3[iter_11_1] = {
					peer_id = var_11_6,
					profile_index = var_11_7
				}
			end
		end
	end

	return var_11_0
end
