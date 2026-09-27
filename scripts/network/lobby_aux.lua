-- chunkname: @scripts/network/lobby_aux.lua

local LobbyAux = LobbyAux

LobbyAux = LobbyAux or {}
LobbyAux = LobbyAux

local function fn()
	-- function 1
	local var_1_0

	for k, v in pairs(DLCSettings) do
		var_1_0 = not var_1_0 and var_1_0 .. "__" and ""
		var_1_0 = var_1_0 .. k
	end

	return var_1_0
end

LobbyAux.create_network_hash = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local config_hash = Network.config_hash(arg_2_0)
	local settings = Application.settings()
	local flag = not settings and settings.content_revision
	local parameter = Development.parameter("ignore_engine_revision_in_network_hash")

	parameter = parameter or Managers.mechanism:setting("ignore_engine_revision_in_network_hash")

	local flag_2

	flag_2 = not parameter and 0 and Application.build_identifier()

	local var_2_5
	local network_revision_check_enabled = GameSettingsDevelopment.network_revision_check_enabled

	network_revision_check_enabled = network_revision_check_enabled or flag == nil or flag ~= ""

	local var_2_7

	if not GameSettingsDevelopment.network_concatenated_dlc_check_enabled then
		var_2_7 = fn()

		if not var_2_7 then
			-- Nothing
		end
	end

	var_2_7 = ""

	do
		local lobby_data_version
	end

	::label_2_0::

	if not DEDICATED_SERVER then
		lobby_data_version = GameServerInternal.lobby_data_version

		if not lobby_data_version then
			-- Nothing
		end
	end

	lobby_data_version = LobbyInternal.lobby_data_version

	::label_2_1::

	local count = #NetworkLookup.level_keys

	if not network_revision_check_enabled then
		fassert(flag, "No trunk_revision even though it needs to exist!")

		var_2_5 = Application.make_hash(config_hash, flag, flag_2, arg_2_1, var_2_7, lobby_data_version, count)

		if not arg_2_2 then
			printf("[LobbyAux] Making combined_hash: %s from network_hash=%s, trunk_revision=%s, engine_revision=%s, project_hash=%s, lobby_data_version=%s, num_levels=%s", tostring(var_2_5), tostring(config_hash), tostring(flag), tostring(flag_2), tostring(arg_2_1), tostring(lobby_data_version), tostring(count))
		end
	else
		var_2_5 = Application.make_hash(config_hash, flag_2, arg_2_1, var_2_7, lobby_data_version, count)

		if not arg_2_2 then
			printf("[LobbyAux] Making combined_hash: %s from network_hash=%s, engine_revision=%s, project_hash=%s, lobby_data_version=%s, num_levels=%s", tostring(var_2_5), tostring(config_hash), tostring(flag_2), tostring(arg_2_1), tostring(lobby_data_version), tostring(count))
		end
	end

	if not (arg_2_2 or IS_CONSOLE) then
		printf("GameServerAux.create_network_hash network_hash: %s, trunk_revision/content_revision: %s, ignore_engine_revision: %s, engine_revision: %s, , concatenated_dlc_string %s, use_trunk_revision %s, combined_hash %s, lobby_data_version=%s", config_hash, flag, parameter, flag_2, var_2_7, network_revision_check_enabled, var_2_5, tostring(lobby_data_version))
	end

	return var_2_5
end

local LobbyFinderState = LobbyFinderState

LobbyFinderState = LobbyFinderState or {}
LobbyFinderState = LobbyFinderState
LobbyFinderState.SEARCHING = "searching"
LobbyFinderState.IDLE = "idle"

local LobbyState = LobbyState

LobbyState = LobbyState or {}
LobbyState = LobbyState

if not IS_XB1 then
	LobbyState.WORKING = "working"
	LobbyState.JOINED = "joined"
	LobbyState.FAILED = "failed"
	LobbyState.SHUTDOWN = "shutdown"
elseif not IS_PS4 then
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

local tbl = {}

for k, v in pairs(LobbyGameModes) do
	tbl[k] = v
	tbl[v] = k
end

LobbyGameModes = tbl

local LobbyAux_2 = LobbyAux
local tbl_2

if not IS_PS4 then
	tbl_2 = {
		"close",
		"medium",
		"world"
	}

	if not tbl_2 then
		-- Nothing
	end
end

tbl_2 = {
	"close",
	"far",
	"world"
}

::label_0_0::

LobbyAux_2.map_lobby_distance_filter = tbl_2

local tbl_3 = {}

for k_2 = 1, #LobbyAux.map_lobby_distance_filter do
	tbl_3[LobbyAux.map_lobby_distance_filter[k_2]] = LobbyAux.map_lobby_distance_filter[k_2 + 1]
end

LobbyAux.next_distance_filter = tbl_3

LobbyAux.get_next_lobby_distance_filter = function (arg_3_0, arg_3_1)
	-- function 3
	if arg_3_0 == arg_3_1 then
		return
	end

	return LobbyAux.next_distance_filter[arg_3_0]
end

LobbyAux.get_unique_server_name = function ()
	-- function 4
	local parameter = Development.parameter("unique_server_name")

	if not (not parameter and parameter ~= "") then
		if not rawget(_G, "Steam") then
			parameter = Steam.user_name()
		elseif not IS_XB1 then
			parameter = LobbyInternal.SESSION_NAME
		else
			parameter = Network.peer_id()
		end
	end

	return parameter
end

LobbyAux.MAX_CUSTOM_SERVER_NAME_LENGTH = 32

local function fn_2(self)
	-- function 5
	local selected_mission_id = self.selected_mission_id

	selected_mission_id = selected_mission_id or self.mission_id

	local flag = not selected_mission_id and rawget(NetworkLookup.mission_ids, selected_mission_id)

	flag = flag or not WeaveSettings.templates[selected_mission_id] or true

	return flag
end

local function fn_3(self)
	-- function 6
	local difficulty = self.difficulty

	if not (not difficulty and DifficultySettings[difficulty]) then
		return false
	end

	return true
end

local function fn_4(self)
	-- function 7
	local var_7_0 = tonumber(self.matchmaking_type)

	if not (not var_7_0 and NetworkLookup.matchmaking_types[var_7_0]) then
		return false
	end

	return true
end

local function fn_5(self)
	-- function 8
	local mechanism = self.mechanism

	if not (not mechanism and MechanismSettings[mechanism]) then
		return false
	end

	return true
end

LobbyAux.verify_lobby_data = function (arg_9_0)
	-- function 9
	if not fn_2(arg_9_0) then
		return false
	end

	if not fn_3(arg_9_0) then
		return false
	end

	if not fn_4(arg_9_0) then
		return false
	end

	if not fn_5(arg_9_0) then
		return false
	end

	return true
end

local str = ";"
local str_2 = ","
local str_3 = "="
local num = 1
local num_2 = 2

LobbyAux.serialize_lobby_reservation_data = function (self)
	-- function 10
	local tbl = {}

	for i = 1, #self do
		local var_10_1 = self[i]

		for j = 1, #var_10_1 do
			local var_10_2 = var_10_1[j]
			local peer_id = var_10_2.peer_id
			local profile_index = var_10_2.profile_index

			profile_index = profile_index or -1
			var_10_1[j] = string.format("%s%s%d", peer_id, str_3, profile_index)
		end

		tbl[i] = table.concat(var_10_1, str_2)
	end

	local concat = table.concat(tbl, str)

	if concat == "" then
		concat = not rawget(_G, "LobbyInternal") and not LobbyInternal.default_lobby_data and LobbyInternal.default_lobby_data.reserved_profiles and ""
	end

	return concat
end

LobbyAux.deserialize_lobby_reservation_data = function (self, arg_11_1)
	-- function 11
	local tbl = {}
	local reserved_profiles = self.reserved_profiles

	reserved_profiles = (reserved_profiles == "" or not reserved_profiles or not rawget(_G, "LobbyInternal")) and (not LobbyInternal.default_lobby_data or LobbyInternal.default_lobby_data.reserved_profiles or "")

	local split = string.split(reserved_profiles, str)

	for i = 1, #split do
		local tbl_2 = {}

		tbl[i] = tbl_2

		local split_2 = string.split(split[i], str_2)

		for j = 1, #split_2 do
			local split_3 = string.split(split_2[j], str_3)
			local var_11_6 = split_3[num]
			local var_11_7 = tonumber(split_3[num_2])

			if var_11_7 == -1 then
				var_11_7 = nil
			end

			if var_11_7 or not arg_11_1 then
				tbl_2[j] = {
					peer_id = var_11_6,
					profile_index = var_11_7
				}
			end
		end
	end

	return tbl
end
