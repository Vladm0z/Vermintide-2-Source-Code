-- chunkname: @scripts/network/lobby_xbox_live.lua

require("scripts/network/lobby_aux")
require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/network/lobby_members")
require("scripts/network/smartmatch_xb1")
require("scripts/network/lobby_unclaimed")
require("scripts/network_lookup/network_lookup")
require("scripts/network/voice_chat_xb1")

local LobbyInternal = LobbyInternal

LobbyInternal = LobbyInternal or {}
LobbyInternal = LobbyInternal
LobbyInternal.lobby_data_version = 2
LobbyInternal.TYPE = "xboxlive"
LobbyInternal.WEAVE_HOPPER_NAME = "weave_find_group_hopper"
LobbyInternal.HOPPER_NAME = "safe_profiles_hopper"
LobbyInternal.SESSION_TEMPLATE_NAME = "new_default_game"
LobbyInternal.SMARTMATCH_SESSION_TEMPLATE_NAME = "ticket_default"
LobbyInternal.state_map = {
	[MultiplayerSession.READY] = LobbyState.JOINED,
	[MultiplayerSession.WORKING] = LobbyState.WORKING,
	[MultiplayerSession.SHUTDOWN] = LobbyState.SHUTDOWN,
	[MultiplayerSession.BROKEN] = LobbyState.FAILED
}

LobbyInternal.init_client = function (self)
	-- function 1
	if not LobbyInternal.client then
		if not Network.xboxlive_client_exists() then
			Network.init_xboxlive_client(self.config_file_name)
		end

		LobbyInternal.client = true
	end

	GameSettingsDevelopment.set_ignored_rpc_logs()
end

LobbyInternal.create_lobby = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local flag = arg_2_1 or Application.guid()
	local flag_2 = arg_2_2 or LobbyInternal.SESSION_TEMPLATE_NAME
	local create_multiplayer_session_host = Network.create_multiplayer_session_host(Managers.account:user_id(), flag, flag_2, {
		"server_name:" .. flag
	})
	local flag_3 = true

	return XboxLiveLobby:new(create_multiplayer_session_host, flag, flag_2, flag_3)
end

LobbyInternal.network_initialized = function ()
	-- function 3
	return not not LobbyInternal.client
end

LobbyInternal.ping = function (arg_4_0)
	-- function 4
	return Network.ping(arg_4_0)
end

LobbyInternal.leave_lobby = function (self)
	-- function 5
	self:leave()
end

LobbyInternal.join_lobby = function (self)
	-- function 6
	print("JOINING LOBBY")

	for k, v in pairs(self) do
		print(k, v)
	end

	print("end")

	local flag = false
	local name = self.name

	name = name or Application.guid()

	local session_template_name = self.session_template_name

	session_template_name = session_template_name or LobbyInternal.SESSION_TEMPLATE_NAME

	local create_multiplayer_session_client = Network.create_multiplayer_session_client(Managers.account:user_id(), name, session_template_name)
	local flag_2 = false

	return XboxLiveLobby:new(create_multiplayer_session_client, name, session_template_name, flag_2)
end

LobbyInternal.shutdown_client = function ()
	-- function 7
	if not LobbyInternal.xbox_live_lobby_browser then
		LobbyInternal.xbox_live_lobby_browser:destroy()

		LobbyInternal.xbox_live_lobby_browser = nil
	end
end

LobbyInternal.open_channel = function (self, arg_8_1)
	-- function 8
	local session_id = self:session_id()
	local open_channel = MultiplayerSession.open_channel(session_id, arg_8_1)

	printf("LobbyInternal.open_channel session: %s, to peer: %s channel: %s", session_id, arg_8_1, open_channel)

	return open_channel
end

LobbyInternal.close_channel = function (self, arg_9_1)
	-- function 9
	local session_id = self:session_id()

	printf("LobbyInternal.close_channel session: %s, channel: %s", session_id, arg_9_1)
	MultiplayerSession.close_channel(session_id, arg_9_1)
end

LobbyInternal.is_orphaned = function (arg_10_0)
	-- function 10
	return false
end

LobbyInternal.shutdown_xboxlive_client = function ()
	-- function 11
	if not Network.xboxlive_client_exists() then
		Network.shutdown_xboxlive_client()
	end

	LobbyInternal.client = nil
end

LobbyInternal.get_lobby = function (self, arg_12_1)
	-- function 12
	local tbl = {}
	local clone = table.clone(self:lobby(arg_12_1))

	tbl.name = clone.name
	tbl.template_name = clone.template_name

	for i = 1, #clone.keywords do
		local split_deprecated = string.split_deprecated(clone.keywords[i], ":")
		local var_12_3 = split_deprecated[1]
		local var_12_4 = tonumber(split_deprecated[2])

		var_12_4 = var_12_4 or split_deprecated[2]
		tbl[var_12_3] = var_12_4
	end

	return tbl
end

LobbyInternal.lobby_browser = function ()
	-- function 13
	return LobbyInternal.xbox_live_lobby_browser
end

LobbyInternal.get_lobby_data_from_id = function (arg_14_0)
	-- function 14
	return nil
end

LobbyInternal.get_lobby_data_from_id_by_key = function (arg_15_0, arg_15_1)
	-- function 15
	return nil
end

LobbyInternal.clear_filter_requirements = function ()
	-- function 16
	return
end

LobbyInternal.add_filter_requirements = function (arg_17_0)
	-- function 17
	return
end

LobbyInternal.lobby_id = function (self)
	-- function 18
	return self:id()
end

LobbyInternal.session_id = function (self)
	-- function 19
	return self:id()
end

LobbyInternal.is_friend = function (arg_20_0)
	-- function 20
	print("LobbyInternal.is_friend() is not implemented on the xb1")

	return false
end

LobbyInternal.set_max_members = function (arg_21_0, arg_21_1)
	-- function 21
	ferror("set_max_members not supported on platform.")
end

script_data.debug_xbox_lobby = true

local function fn()
	-- function 22
	return
end

if not script_data.debug_xbox_lobby then
	function fn(...)
		-- function 23
		print("[XboxLiveLobby]", string.format(...))
	end
end

local tbl = {
	[SmartMatchStatus.UNKNOWN] = "UNKNOWN",
	[SmartMatchStatus.SEARCHING] = "SEARCHING",
	[SmartMatchStatus.EXPIRED] = "EXPIRED",
	[SmartMatchStatus.FOUND] = "FOUND"
}
local tbl_2 = {
	[MultiplayerSession.READY] = "READY",
	[MultiplayerSession.WORKING] = "WORKING",
	[MultiplayerSession.SHUTDOWN] = "SHUTDOWN",
	[MultiplayerSession.BROKEN] = "BROKEN"
}
local tbl_3 = {
	default_stage_hopper = {
		"difficulty",
		"stage"
	},
	new_stage_hopper = {
		"difficulty",
		"level",
		"powerlevel",
		"strict_matchmaking"
	},
	safe_profiles_hopper = {
		"difficulty",
		"level",
		"powerlevel",
		"strict_matchmaking",
		"profiles",
		"network_hash",
		"matchmaking_types"
	},
	weave_find_group_hopper = {
		"difficulty",
		"powerlevel",
		"profiles",
		"network_hash",
		"matchmaking_types",
		"weave_index"
	}
}
local tbl_4 = {
	network_hash = "string",
	strict_matchmaking = "number",
	weave_index = "number",
	powerlevel = "number",
	matchmaking_types = "collection",
	profiles = "collection",
	stage = "number",
	difficulty = "number",
	level = "collection"
}

XboxLiveLobby = class(XboxLiveLobby)

XboxLiveLobby.init = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	self._user_id = Managers.account:user_id()
	self._session_id = arg_24_1
	self._data = {}
	self._gamertags = {}
	self._data.unique_server_name = arg_24_2 or LobbyInternal.SESSION_NAME
	self._data.session_name = arg_24_2
	self._data.session_template_name = arg_24_3
	self._hopper_name = LobbyInternal.HOPPER_NAME
	self._session_name = arg_24_2 or "missing session name"
	self._session_template_name = arg_24_3
	self._smartmatch_ticket_params = {}
	self._activity_set = false
	self._data_needs_update = false
	self._waiting_for_result = false
	self._client_update_lobby_data = false
	self._data_update_status_id = nil
	self._data_update_time_left = 0
	self._is_hosting = arg_24_4

	fn("Lobby created Session ID: %s - Name: %s - Template: %s", tostring(arg_24_1), tostring(arg_24_2), tostring(arg_24_3))

	if not (not Managers.account:has_privilege(UserPrivilege.COMMUNICATION_VOICE_INGAME) and script_data.honduras_demo) then
		if not Managers.voice_chat then
			Managers.voice_chat = VoiceChatXboxOneManager:new()
		end

		Managers.voice_chat:add_local_user()
	end
end

XboxLiveLobby.set_hosting = function (self, arg_25_1)
	-- function 25
	self._is_hosting = arg_25_1
end

XboxLiveLobby.enable_smartmatch = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	fassert(not arg_26_1 and arg_26_2 ~= nil or not arg_26_1, "You need to supply ticket_params if you want to enable matchmaking")

	self._hopper_name = arg_26_4 or LobbyInternal.HOPPER_NAME
	self._smartmatch_enabled = arg_26_1
	self._smartmatch_ticket_params = arg_26_2
	self._timeout = arg_26_3
	self._force_broadcast = true

	self:_cancel_matchmaking()
end

XboxLiveLobby.reissue_smartmatch_ticket = function (self, arg_27_1, arg_27_2)
	-- function 27
	fassert(self._smartmatch_enabled, "[XboxLiveLobby] You need to be matchmaking to be able to reissue a ticket")

	self._smartmatch_ticket_params = arg_27_1
	self._timeout = arg_27_2
	self._reissue_host_smartmatch_ticket = true
end

XboxLiveLobby._cancel_matchmaking = function (self)
	-- function 28
	if not self._smartmatch_in_progress then
		local tbl = {
			destroy_session = false,
			state = "_cleanup_ticket",
			user_id = self._smartmatch_user_id,
			session_id = self._session_id,
			hopper_name = self._hopper_name,
			session_name = self._data.session_name,
			ticket_id = self._ticket_id
		}

		Managers.account:add_session_to_cleanup(tbl)
		fn("Smartmatch in progress - DESTROYING")
	else
		fn("No smartmatch ticket found - RESETTING")
	end

	self._smartmatch_state = nil
	self._prev_smartmatch_state = nil
	self._reissue_host_smartmatch_ticket = nil
	self._timeout = nil
	self._ticket_id = nil
	self._smartmatch_in_progress = false
end

XboxLiveLobby.state = function (self)
	-- function 29
	local status = MultiplayerSession.status(self._session_id)

	if not (not self._friends_to_invite and status ~= MultiplayerSession.READY or Managers.account:user_detached()) then
		MultiplayerSession.invite_friends_list(Managers.account:user_id(), self._session_id, self._friends_to_invite)

		self._friends_to_invite = nil

		return (MultiplayerSession.status(self._session_id))
	end

	if not (self._session_group_id or status ~= MultiplayerSession.READY) then
		self._session_group_id = MultiplayerSession.group_id(self._session_id)
	end

	return status
end

XboxLiveLobby.ready = function (self)
	-- function 30
	if not self._smartmatch_enabled then
		return true
	end

	return self._smartmatch_state == MultiplayerSession.READY
end

XboxLiveLobby.invite_friends_list = function (self, arg_31_1)
	-- function 31
	self._friends_to_invite = arg_31_1
end

XboxLiveLobby.force_update_data = function (self)
	-- function 32
	self._client_update_lobby_data = true
end

XboxLiveLobby.update_data = function (self, arg_33_1)
	-- function 33
	if not Managers.account:user_detached() then
		return
	end

	if not self._is_hosting then
		local flag = MultiplayerSession.status(self._session_id) == MultiplayerSession.READY

		if not self._data_needs_update and not flag then
			MultiplayerSession.set_custom_property_json(self._session_id, "data", cjson.encode(self._data))

			self._data_needs_update = false
			self._waiting_for_result = true
		elseif not self._waiting_for_result and not flag then
			local _session_id = self._session_id
			local members = MultiplayerSession.members(_session_id)
			local peer_id = Network.peer_id()

			for i, v in ipairs(members) do
				local peer = v.peer

				if peer ~= peer_id then
					local var_33_5 = PEER_ID_TO_CHANNEL[peer]

					if not var_33_5 then
						RPC.rpc_client_update_lobby_data(var_33_5)
					end
				end
			end

			self._waiting_for_result = false
		end
	else
		if self._data_update_status_id ~= nil then
			local custom_property_json_status = MultiplayerSession.custom_property_json_status(self._data_update_status_id)

			if custom_property_json_status == SessionJobStatus.COMPLETE then
				local custom_property_json_result = MultiplayerSession.custom_property_json_result(self._data_update_status_id)

				if custom_property_json_result ~= nil then
					local decode = cjson.decode(custom_property_json_result)

					for k, v_2 in pairs(decode) do
						self._data[k] = v_2
					end
				end

				MultiplayerSession.free_custom_property_json(self._data_update_status_id)

				self._data_update_status_id = nil
			elseif custom_property_json_status == SessionJobStatus.FAILED then
				fn("Failed to get data from session")
				MultiplayerSession.free_custom_property_json(self._data_update_status_id)

				self._data_update_status_id = nil
			end
		end

		if not self._client_update_lobby_data then
			self._data_update_status_id = MultiplayerSession.custom_property_json(self._session_id, "data")
			self._client_update_lobby_data = false
		end
	end
end

XboxLiveLobby.is_updating_lobby_data = function (self)
	-- function 34
	local _client_update_lobby_data = self._client_update_lobby_data

	if not _client_update_lobby_data then
		_client_update_lobby_data = self._data_update_status_id

		if not _client_update_lobby_data then
			_client_update_lobby_data = self._waiting_for_result
			_client_update_lobby_data = _client_update_lobby_data or self._data_needs_update
		end
	end

	return _client_update_lobby_data
end

XboxLiveLobby.update_activity = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not Managers.account:user_detached() then
		return
	end

	local _session_id = self._session_id
	local _user_id = self._user_id
	local members = MultiplayerSession.members(_session_id)
	local size = table.size(members)

	if MultiplayerSession.status(_session_id) == MultiplayerSession.READY then
		local game_mode = Managers.state.game_mode

		game_mode = not game_mode and Managers.state.game_mode:is_game_mode_ended()

		if size == MatchmakingSettings.MAX_NUMBER_OF_PLAYERS or arg_35_2 == "prologue" or not game_mode then
			if not self._activity_set then
				if not Network.fatal_error() then
					Network.clear_activity(_user_id)
				end

				self._activity_set = false
			end

			return
		end

		if not self._activity_set then
			Network.set_activity(_user_id, _session_id)

			self._activity_set = true
		end
	end
end

XboxLiveLobby.update_host_matchmaking = function (self, arg_36_1)
	-- function 36
	if (MultiplayerSession.status(self._session_id) ~= MultiplayerSession.READY or not self._smartmatch_enabled) and not Managers.account:user_detached() then
		return
	end

	self:_update_smartmatching(arg_36_1)
	self:_handle_smartmatching_tickets(arg_36_1)
end

XboxLiveLobby._update_smartmatching = function (self, arg_37_1)
	-- function 37
	if not self._smartmatch_in_progress then
		return
	end

	local _session_id = self._session_id
	local smartmatch_status = MultiplayerSession.smartmatch_status(self._session_id)
	local start_smartmatch_result = MultiplayerSession.start_smartmatch_result(self._session_id)

	if not (not self._ticket_id and self._ticket_id == start_smartmatch_result and start_smartmatch_result == "") then
		fn("Started smartmatch with ticket_id: %s", start_smartmatch_result)

		self._ticket_id = start_smartmatch_result
	end

	if not (smartmatch_status == SmartMatchStatus.SEARCHING or smartmatch_status ~= SmartMatchStatus.UNKNOWN) then
		if not self._reissue_host_smartmatch_ticket then
			fn("Reissuing ticket - ticket name: %s", start_smartmatch_result)

			if not self._smartmatch_in_progress then
				local tbl = {
					destroy_session = false,
					state = "_cleanup_ticket",
					user_id = self._smartmatch_user_id,
					session_id = self._session_id,
					hopper_name = self._hopper_name,
					session_name = self._data.session_name,
					ticket_id = self._ticket_id
				}

				Managers.account:add_session_to_cleanup(tbl)

				self._smartmatch_in_progress = false
				self._ticket_id = nil
			end
		end

		return
	elseif not (smartmatch_status == SmartMatchStatus.EXPIRED or smartmatch_status ~= SmartMatchStatus.FOUND) then
		if smartmatch_status == SmartMatchStatus.EXPIRED then
			fn("Smartmatching EXPIRED - ticket name: %s", start_smartmatch_result)
		else
			fn("Smartmatching FOUND - ticket name: %s", start_smartmatch_result)
		end

		local tbl_2 = {
			destroy_session = false,
			state = "_cleanup_ticket",
			user_id = self._smartmatch_user_id,
			session_id = self._session_id,
			hopper_name = self._hopper_name,
			session_name = self._data.session_name,
			ticket_id = self._ticket_id
		}

		Managers.account:add_session_to_cleanup(tbl_2)

		self._smartmatch_in_progress = false
		self._ticket_id = nil

		fn("Smartmatch in progress - DESTROYING")
	end

	self._smartmatch_state = smartmatch_status
end

XboxLiveLobby._handle_smartmatching_tickets = function (self, arg_38_1)
	-- function 38
	if not self._smartmatch_in_progress then
		return
	end

	local _session_id = self._session_id
	local members = MultiplayerSession.members(_session_id)

	if table.size(members) >= 4 then
		return
	end

	local smartmatch_status = MultiplayerSession.smartmatch_status(self._session_id)

	if not ((smartmatch_status == SmartMatchStatus.FOUND or smartmatch_status == SmartMatchStatus.EXPIRED) and self._force_broadcast) then
		return
	end

	if self._smartmatch_state ~= self._prev_smartmatch_state then
		local var_38_3 = fn
		local str = "changed smartmatch status from %s -> %s"
		local var_38_5 = tbl[self._prev_smartmatch_state]

		var_38_5 = var_38_5 or "None"

		var_38_3(str, var_38_5, tbl[self._smartmatch_state])

		self._prev_smartmatch_state = self._smartmatch_state
	end

	self:_create_smartmatch_broadcast(600)

	self._smartmatch_in_progress = true
	self._reissue_host_smartmatch_ticket = false
	self._force_broadcast = false

	fn("######### Created smartmatch session broadcast for lobby host #########")
end

XboxLiveLobby._convert_to_json = function (arg_39_0, arg_39_1, arg_39_2)
	-- function 39
	local var_39_0 = tbl_3[arg_39_1]

	fassert(var_39_0, "[SmartMatch::_convert_to_json] No such hopper_name:  %s", arg_39_1)

	local str = ""

	for i, v in ipairs(var_39_0) do
		local var_39_2 = tbl_4[v]
		local var_39_3 = arg_39_2[v]

		fassert(var_39_3, "[SmartMatch::_convert_to_json] Missing variable [%s] in params", v)

		if var_39_2 == "number" then
			str = str .. string.format("%q:%i,", v, var_39_3)
		elseif var_39_2 == "string" then
			str = str .. string.format("%q:%q,", v, var_39_3)
		elseif var_39_2 == "collection" then
			str = str .. string.format("%q:[", v)

			for i_2, v_2 in ipairs(var_39_3) do
				if i_2 == 1 then
					str = str .. string.format("%q", tostring(v_2))
				else
					str = str .. string.format(",%q", tostring(v_2))
				end
			end

			str = str .. "],"
		end
	end

	if str == "" then
		return
	else
		local sub = string.sub(str, 1, -2)

		print("Hopper name:", arg_39_1, "JSON_DATA:", string.format("{%s}", sub))

		return string.format("{%s}", sub)
	end
end

XboxLiveLobby._create_smartmatch_broadcast = function (self, arg_40_1)
	-- function 40
	local flag = arg_40_1 or 600
	local ALWAYS = PreserveSessionMode.ALWAYS

	fn("PreserveSessionMode %s. is host %s", "ALWAYS", "TRUE")

	local members = self:members()
	local tbl = {}

	for i, v in ipairs(members) do
		local player_from_peer_id = Managers.player:player_from_peer_id(v)

		if not player_from_peer_id then
			tbl[#tbl + 1] = player_from_peer_id:profile_index()
		end
	end

	if #tbl > 0 then
		self._smartmatch_ticket_params.profiles = tbl
	end

	local var_40_5

	if not Managers.matchmaking then
		local get_average_power_level = Managers.matchmaking:get_average_power_level()

		if not get_average_power_level then
			self._smartmatch_ticket_params.powerlevel = get_average_power_level
		end
	end

	local var_40_7

	if not self._smartmatch_ticket_params then
		var_40_7 = self:_convert_to_json(self._hopper_name, self._smartmatch_ticket_params)

		fn("Ticket Params: %s Hopper Name: %s", var_40_7, self._hopper_name)
	end

	fn("Starting SmartMatch with session_id: %s Hopper name: %s PreserveSessionMode: %s Ticket params: %s Timeout: %s", tostring(self._session_id), self._hopper_name, "ALWAYS", var_40_7, tostring(flag))
	MultiplayerSession.start_smartmatch(self._session_id, self._hopper_name, flag, ALWAYS, var_40_7)

	self._smartmatch_user_id = Managers.account:user_id()
end

XboxLiveLobby.session_id = function (self)
	-- function 41
	return self._session_id
end

XboxLiveLobby.session_template_name = function (self)
	-- function 42
	return self._session_template_name
end

XboxLiveLobby.leave = function (self)
	-- function 43
	fn("Destroying Lobby --> session_id: %s - session_name: %s", self._session_id, self._data.session_name)

	self._activity_set = false

	local tbl = {
		destroy_session = true,
		state = "_cleanup_ticket",
		user_id = self._smartmatch_user_id,
		session_id = self._session_id,
		hopper_name = self._hopper_name,
		session_name = self._data.session_name
	}

	Managers.account:add_session_to_cleanup(tbl)

	if self._data_update_status_id ~= nil then
		local custom_property_json_status = MultiplayerSession.custom_property_json_status(self._data_update_status_id)

		if not (custom_property_json_status == SessionJobStatus.COMPLETE or custom_property_json_status ~= SessionJobStatus.FAILED) then
			MultiplayerSession.free_custom_property_json(self._data_update_status_id)

			self._data_update_status_id = nil
		end
	end
end

XboxLiveLobby.free = function (self)
	-- function 44
	Network.free_multiplayer_session(self._session_id)
end

XboxLiveLobby.set_data = function (self, arg_45_1, arg_45_2)
	-- function 45
	self._data[arg_45_1] = arg_45_2
	self._data_needs_update = true
end

XboxLiveLobby.set_data_table = function (self, arg_46_1)
	-- function 46
	for k, v in pairs(arg_46_1) do
		self._data[k] = v
	end

	self._data_needs_update = true
end

XboxLiveLobby.data = function (self, arg_47_1)
	-- function 47
	return self._data[arg_47_1]
end

XboxLiveLobby.members = function (self)
	-- function 48
	local tbl = {}
	local members = MultiplayerSession.members(self._session_id)

	for k, v in pairs(members) do
		tbl[#tbl + 1] = v.peer
	end

	return tbl
end

XboxLiveLobby.update_user_names = function (self)
	-- function 49
	local members = MultiplayerSession.members(self._session_id)

	for k, v in pairs(members) do
		self._gamertags[v.peer] = v.gamertag
	end
end

XboxLiveLobby.user_name = function (self, arg_50_1)
	-- function 50
	local members = MultiplayerSession.members(self._session_id)

	for k, v in pairs(members) do
		if v.peer == arg_50_1 then
			self._gamertags[arg_50_1] = v.gamertag

			return v.gamertag
		end
	end

	return self._gamertags[arg_50_1]
end

XboxLiveLobby.xuid = function (self, arg_51_1)
	-- function 51
	local members = MultiplayerSession.members(self._session_id)

	for k, v in pairs(members) do
		if v.peer == arg_51_1 then
			return v.xbox_user_id
		end
	end
end

XboxLiveLobby.lobby_host = function (self)
	-- function 52
	return MultiplayerSession.host_peer(self._session_id)
end

XboxLiveLobby.try_claim_host = function (self)
	-- function 53
	MultiplayerSession.try_claim_session(self._session_id)
end

XboxLiveLobby.id = function (arg_54_0)
	-- function 54
	return 1000
end

XboxLiveLobbyBrowser = class(XboxLiveLobbyBrowser)

XboxLiveLobbyBrowser.init = function (self, arg_55_1, arg_55_2)
	-- function 55
	self._network_hash = "network_hash:" .. LobbyAux.create_network_hash(arg_55_2.config_file_name, arg_55_2.project_hash)
	self._user_id = arg_55_1
	self._session_browsing_id = Network.start_session_browsing(arg_55_1, self._network_hash, LobbyInternal.SESSION_TEMPLATE_NAME)
	self._lobbies = {}
end

local LOBBIES = LOBBIES

LOBBIES = LOBBIES or {}
LOBBIES = LOBBIES

XboxLiveLobbyBrowser.is_refreshing = function (self)
	-- function 56
	if not self._session_browsing_id then
		return false
	end

	if MultiplayerSessionBrowser.status(self._session_browsing_id) ~= SessionJobStatus.COMPLETE then
		return true
	end

	local result = MultiplayerSessionBrowser.result(self._session_browsing_id)

	result = result or {}
	self._lobbies = result
	LOBBIES = self._lobbies

	Network.free_session_browsing(self._session_browsing_id)

	self._session_browsing_id = nil

	return false
end

XboxLiveLobbyBrowser.num_lobbies = function (self)
	-- function 57
	return #self._lobbies
end

XboxLiveLobbyBrowser.refresh = function (self)
	-- function 58
	self._session_browsing_id = Network.start_session_browsing(self._user_id, self._network_hash, LobbyInternal.SESSION_TEMPLATE_NAME)
end

XboxLiveLobbyBrowser.lobby = function (self, arg_59_1)
	-- function 59
	return self._lobbies[arg_59_1 + 1]
end

XboxLiveLobbyBrowser.destroy = function (self)
	-- function 60
	if not self._session_browsing_id then
		Network.free_session_browsing(self._session_browsing_id)
	end
end
