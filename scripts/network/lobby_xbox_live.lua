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

LobbyInternal = LobbyInternal or {}
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

function LobbyInternal.init_client(arg_1_0)
	if not LobbyInternal.client then
		if not Network.xboxlive_client_exists() then
			Network.init_xboxlive_client(arg_1_0.config_file_name)
		end

		LobbyInternal.client = true
	end

	GameSettingsDevelopment.set_ignored_rpc_logs()
end

function LobbyInternal.create_lobby(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_1 or Application.guid()
	local var_2_1 = arg_2_2 or LobbyInternal.SESSION_TEMPLATE_NAME
	local var_2_2 = Network.create_multiplayer_session_host(Managers.account:user_id(), var_2_0, var_2_1, {
		"server_name:" .. var_2_0
	})
	local var_2_3 = true

	return XboxLiveLobby:new(var_2_2, var_2_0, var_2_1, var_2_3)
end

function LobbyInternal.network_initialized()
	return not not LobbyInternal.client
end

function LobbyInternal.ping(arg_4_0)
	return Network.ping(arg_4_0)
end

function LobbyInternal.leave_lobby(arg_5_0)
	arg_5_0:leave()
end

function LobbyInternal.join_lobby(arg_6_0)
	print("JOINING LOBBY")

	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		print(iter_6_0, iter_6_1)
	end

	print("end")

	local var_6_0 = false
	local var_6_1 = arg_6_0.name or Application.guid()
	local var_6_2 = arg_6_0.session_template_name or LobbyInternal.SESSION_TEMPLATE_NAME
	local var_6_3 = Network.create_multiplayer_session_client(Managers.account:user_id(), var_6_1, var_6_2)
	local var_6_4 = false

	return XboxLiveLobby:new(var_6_3, var_6_1, var_6_2, var_6_4)
end

function LobbyInternal.shutdown_client()
	if LobbyInternal.xbox_live_lobby_browser then
		LobbyInternal.xbox_live_lobby_browser:destroy()

		LobbyInternal.xbox_live_lobby_browser = nil
	end
end

function LobbyInternal.open_channel(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:session_id()
	local var_8_1 = MultiplayerSession.open_channel(var_8_0, arg_8_1)

	printf("LobbyInternal.open_channel session: %s, to peer: %s channel: %s", var_8_0, arg_8_1, var_8_1)

	return var_8_1
end

function LobbyInternal.close_channel(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:session_id()

	printf("LobbyInternal.close_channel session: %s, channel: %s", var_9_0, arg_9_1)
	MultiplayerSession.close_channel(var_9_0, arg_9_1)
end

function LobbyInternal.is_orphaned(arg_10_0)
	return false
end

function LobbyInternal.shutdown_xboxlive_client()
	if Network.xboxlive_client_exists() then
		Network.shutdown_xboxlive_client()
	end

	LobbyInternal.client = nil
end

function LobbyInternal.get_lobby(arg_12_0, arg_12_1)
	local var_12_0 = {}
	local var_12_1 = table.clone(arg_12_0:lobby(arg_12_1))

	var_12_0.name = var_12_1.name
	var_12_0.template_name = var_12_1.template_name

	for iter_12_0 = 1, #var_12_1.keywords do
		local var_12_2 = string.split_deprecated(var_12_1.keywords[iter_12_0], ":")

		var_12_0[var_12_2[1]] = tonumber(var_12_2[2]) or var_12_2[2]
	end

	return var_12_0
end

function LobbyInternal.lobby_browser()
	return LobbyInternal.xbox_live_lobby_browser
end

function LobbyInternal.get_lobby_data_from_id(arg_14_0)
	return nil
end

function LobbyInternal.get_lobby_data_from_id_by_key(arg_15_0, arg_15_1)
	return nil
end

function LobbyInternal.clear_filter_requirements()
	return
end

function LobbyInternal.add_filter_requirements(arg_17_0)
	return
end

function LobbyInternal.lobby_id(arg_18_0)
	return arg_18_0:id()
end

function LobbyInternal.session_id(arg_19_0)
	return arg_19_0:id()
end

function LobbyInternal.is_friend(arg_20_0)
	print("LobbyInternal.is_friend() is not implemented on the xb1")

	return false
end

function LobbyInternal.set_max_members(arg_21_0, arg_21_1)
	ferror("set_max_members not supported on platform.")
end

script_data.debug_xbox_lobby = true

local function var_0_0()
	return
end

if script_data.debug_xbox_lobby then
	function var_0_0(...)
		print("[XboxLiveLobby]", string.format(...))
	end
end

local var_0_1 = {
	[SmartMatchStatus.UNKNOWN] = "UNKNOWN",
	[SmartMatchStatus.SEARCHING] = "SEARCHING",
	[SmartMatchStatus.EXPIRED] = "EXPIRED",
	[SmartMatchStatus.FOUND] = "FOUND"
}
local var_0_2 = {
	[MultiplayerSession.READY] = "READY",
	[MultiplayerSession.WORKING] = "WORKING",
	[MultiplayerSession.SHUTDOWN] = "SHUTDOWN",
	[MultiplayerSession.BROKEN] = "BROKEN"
}
local var_0_3 = {
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
local var_0_4 = {
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

function XboxLiveLobby.init(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	arg_24_0._user_id = Managers.account:user_id()
	arg_24_0._session_id = arg_24_1
	arg_24_0._data = {}
	arg_24_0._gamertags = {}
	arg_24_0._data.unique_server_name = arg_24_2 or LobbyInternal.SESSION_NAME
	arg_24_0._data.session_name = arg_24_2
	arg_24_0._data.session_template_name = arg_24_3
	arg_24_0._hopper_name = LobbyInternal.HOPPER_NAME
	arg_24_0._session_name = arg_24_2 or "missing session name"
	arg_24_0._session_template_name = arg_24_3
	arg_24_0._smartmatch_ticket_params = {}
	arg_24_0._activity_set = false
	arg_24_0._data_needs_update = false
	arg_24_0._waiting_for_result = false
	arg_24_0._client_update_lobby_data = false
	arg_24_0._data_update_status_id = nil
	arg_24_0._data_update_time_left = 0
	arg_24_0._is_hosting = arg_24_4

	var_0_0("Lobby created Session ID: %s - Name: %s - Template: %s", tostring(arg_24_1), tostring(arg_24_2), tostring(arg_24_3))

	if Managers.account:has_privilege(UserPrivilege.COMMUNICATION_VOICE_INGAME) and not script_data.honduras_demo then
		if not Managers.voice_chat then
			Managers.voice_chat = VoiceChatXboxOneManager:new()
		end

		Managers.voice_chat:add_local_user()
	end
end

function XboxLiveLobby.set_hosting(arg_25_0, arg_25_1)
	arg_25_0._is_hosting = arg_25_1
end

function XboxLiveLobby.enable_smartmatch(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	fassert(arg_26_1 and arg_26_2 ~= nil or not arg_26_1, "You need to supply ticket_params if you want to enable matchmaking")

	arg_26_0._hopper_name = arg_26_4 or LobbyInternal.HOPPER_NAME
	arg_26_0._smartmatch_enabled = arg_26_1
	arg_26_0._smartmatch_ticket_params = arg_26_2
	arg_26_0._timeout = arg_26_3
	arg_26_0._force_broadcast = true

	arg_26_0:_cancel_matchmaking()
end

function XboxLiveLobby.reissue_smartmatch_ticket(arg_27_0, arg_27_1, arg_27_2)
	fassert(arg_27_0._smartmatch_enabled, "[XboxLiveLobby] You need to be matchmaking to be able to reissue a ticket")

	arg_27_0._smartmatch_ticket_params = arg_27_1
	arg_27_0._timeout = arg_27_2
	arg_27_0._reissue_host_smartmatch_ticket = true
end

function XboxLiveLobby._cancel_matchmaking(arg_28_0)
	if arg_28_0._smartmatch_in_progress then
		local var_28_0 = {
			destroy_session = false,
			state = "_cleanup_ticket",
			user_id = arg_28_0._smartmatch_user_id,
			session_id = arg_28_0._session_id,
			hopper_name = arg_28_0._hopper_name,
			session_name = arg_28_0._data.session_name,
			ticket_id = arg_28_0._ticket_id
		}

		Managers.account:add_session_to_cleanup(var_28_0)
		var_0_0("Smartmatch in progress - DESTROYING")
	else
		var_0_0("No smartmatch ticket found - RESETTING")
	end

	arg_28_0._smartmatch_state = nil
	arg_28_0._prev_smartmatch_state = nil
	arg_28_0._reissue_host_smartmatch_ticket = nil
	arg_28_0._timeout = nil
	arg_28_0._ticket_id = nil
	arg_28_0._smartmatch_in_progress = false
end

function XboxLiveLobby.state(arg_29_0)
	local var_29_0 = MultiplayerSession.status(arg_29_0._session_id)

	if arg_29_0._friends_to_invite and var_29_0 == MultiplayerSession.READY and not Managers.account:user_detached() then
		MultiplayerSession.invite_friends_list(Managers.account:user_id(), arg_29_0._session_id, arg_29_0._friends_to_invite)

		arg_29_0._friends_to_invite = nil

		return (MultiplayerSession.status(arg_29_0._session_id))
	end

	if not arg_29_0._session_group_id and var_29_0 == MultiplayerSession.READY then
		arg_29_0._session_group_id = MultiplayerSession.group_id(arg_29_0._session_id)
	end

	return var_29_0
end

function XboxLiveLobby.ready(arg_30_0)
	if not arg_30_0._smartmatch_enabled then
		return true
	end

	return arg_30_0._smartmatch_state == MultiplayerSession.READY
end

function XboxLiveLobby.invite_friends_list(arg_31_0, arg_31_1)
	arg_31_0._friends_to_invite = arg_31_1
end

function XboxLiveLobby.force_update_data(arg_32_0)
	arg_32_0._client_update_lobby_data = true
end

function XboxLiveLobby.update_data(arg_33_0, arg_33_1)
	if Managers.account:user_detached() then
		return
	end

	if arg_33_0._is_hosting then
		local var_33_0 = MultiplayerSession.status(arg_33_0._session_id) == MultiplayerSession.READY

		if arg_33_0._data_needs_update and var_33_0 then
			MultiplayerSession.set_custom_property_json(arg_33_0._session_id, "data", cjson.encode(arg_33_0._data))

			arg_33_0._data_needs_update = false
			arg_33_0._waiting_for_result = true
		elseif arg_33_0._waiting_for_result and var_33_0 then
			local var_33_1 = arg_33_0._session_id
			local var_33_2 = MultiplayerSession.members(var_33_1)
			local var_33_3 = Network.peer_id()

			for iter_33_0, iter_33_1 in ipairs(var_33_2) do
				local var_33_4 = iter_33_1.peer

				if var_33_4 ~= var_33_3 then
					local var_33_5 = PEER_ID_TO_CHANNEL[var_33_4]

					if var_33_5 then
						RPC.rpc_client_update_lobby_data(var_33_5)
					end
				end
			end

			arg_33_0._waiting_for_result = false
		end
	else
		if arg_33_0._data_update_status_id ~= nil then
			local var_33_6 = MultiplayerSession.custom_property_json_status(arg_33_0._data_update_status_id)

			if var_33_6 == SessionJobStatus.COMPLETE then
				local var_33_7 = MultiplayerSession.custom_property_json_result(arg_33_0._data_update_status_id)

				if var_33_7 ~= nil then
					local var_33_8 = cjson.decode(var_33_7)

					for iter_33_2, iter_33_3 in pairs(var_33_8) do
						arg_33_0._data[iter_33_2] = iter_33_3
					end
				end

				MultiplayerSession.free_custom_property_json(arg_33_0._data_update_status_id)

				arg_33_0._data_update_status_id = nil
			elseif var_33_6 == SessionJobStatus.FAILED then
				var_0_0("Failed to get data from session")
				MultiplayerSession.free_custom_property_json(arg_33_0._data_update_status_id)

				arg_33_0._data_update_status_id = nil
			end
		end

		if arg_33_0._client_update_lobby_data then
			arg_33_0._data_update_status_id = MultiplayerSession.custom_property_json(arg_33_0._session_id, "data")
			arg_33_0._client_update_lobby_data = false
		end
	end
end

function XboxLiveLobby.is_updating_lobby_data(arg_34_0)
	return arg_34_0._client_update_lobby_data or arg_34_0._data_update_status_id or arg_34_0._waiting_for_result or arg_34_0._data_needs_update
end

function XboxLiveLobby.update_activity(arg_35_0, arg_35_1, arg_35_2)
	if Managers.account:user_detached() then
		return
	end

	local var_35_0 = arg_35_0._session_id
	local var_35_1 = arg_35_0._user_id
	local var_35_2 = MultiplayerSession.members(var_35_0)
	local var_35_3 = table.size(var_35_2)

	if MultiplayerSession.status(var_35_0) == MultiplayerSession.READY then
		local var_35_4 = Managers.state.game_mode and Managers.state.game_mode:is_game_mode_ended()

		if var_35_3 == MatchmakingSettings.MAX_NUMBER_OF_PLAYERS or arg_35_2 == "prologue" or var_35_4 then
			if arg_35_0._activity_set then
				if not Network.fatal_error() then
					Network.clear_activity(var_35_1)
				end

				arg_35_0._activity_set = false
			end

			return
		end

		if not arg_35_0._activity_set then
			Network.set_activity(var_35_1, var_35_0)

			arg_35_0._activity_set = true
		end
	end
end

function XboxLiveLobby.update_host_matchmaking(arg_36_0, arg_36_1)
	if MultiplayerSession.status(arg_36_0._session_id) ~= MultiplayerSession.READY or not arg_36_0._smartmatch_enabled or Managers.account:user_detached() then
		return
	end

	arg_36_0:_update_smartmatching(arg_36_1)
	arg_36_0:_handle_smartmatching_tickets(arg_36_1)
end

function XboxLiveLobby._update_smartmatching(arg_37_0, arg_37_1)
	if not arg_37_0._smartmatch_in_progress then
		return
	end

	local var_37_0 = arg_37_0._session_id
	local var_37_1 = MultiplayerSession.smartmatch_status(arg_37_0._session_id)
	local var_37_2 = MultiplayerSession.start_smartmatch_result(arg_37_0._session_id)

	if (not arg_37_0._ticket_id or arg_37_0._ticket_id ~= var_37_2) and var_37_2 ~= "" then
		var_0_0("Started smartmatch with ticket_id: %s", var_37_2)

		arg_37_0._ticket_id = var_37_2
	end

	if var_37_1 == SmartMatchStatus.SEARCHING or var_37_1 == SmartMatchStatus.UNKNOWN then
		if arg_37_0._reissue_host_smartmatch_ticket then
			var_0_0("Reissuing ticket - ticket name: %s", var_37_2)

			if arg_37_0._smartmatch_in_progress then
				local var_37_3 = {
					destroy_session = false,
					state = "_cleanup_ticket",
					user_id = arg_37_0._smartmatch_user_id,
					session_id = arg_37_0._session_id,
					hopper_name = arg_37_0._hopper_name,
					session_name = arg_37_0._data.session_name,
					ticket_id = arg_37_0._ticket_id
				}

				Managers.account:add_session_to_cleanup(var_37_3)

				arg_37_0._smartmatch_in_progress = false
				arg_37_0._ticket_id = nil
			end
		end

		return
	elseif var_37_1 == SmartMatchStatus.EXPIRED or var_37_1 == SmartMatchStatus.FOUND then
		if var_37_1 == SmartMatchStatus.EXPIRED then
			var_0_0("Smartmatching EXPIRED - ticket name: %s", var_37_2)
		else
			var_0_0("Smartmatching FOUND - ticket name: %s", var_37_2)
		end

		local var_37_4 = {
			destroy_session = false,
			state = "_cleanup_ticket",
			user_id = arg_37_0._smartmatch_user_id,
			session_id = arg_37_0._session_id,
			hopper_name = arg_37_0._hopper_name,
			session_name = arg_37_0._data.session_name,
			ticket_id = arg_37_0._ticket_id
		}

		Managers.account:add_session_to_cleanup(var_37_4)

		arg_37_0._smartmatch_in_progress = false
		arg_37_0._ticket_id = nil

		var_0_0("Smartmatch in progress - DESTROYING")
	end

	arg_37_0._smartmatch_state = var_37_1
end

function XboxLiveLobby._handle_smartmatching_tickets(arg_38_0, arg_38_1)
	if arg_38_0._smartmatch_in_progress then
		return
	end

	local var_38_0 = arg_38_0._session_id
	local var_38_1 = MultiplayerSession.members(var_38_0)

	if table.size(var_38_1) >= 4 then
		return
	end

	local var_38_2 = MultiplayerSession.smartmatch_status(arg_38_0._session_id)

	if (var_38_2 == SmartMatchStatus.FOUND or var_38_2 == SmartMatchStatus.EXPIRED) and not arg_38_0._force_broadcast then
		return
	end

	if arg_38_0._smartmatch_state ~= arg_38_0._prev_smartmatch_state then
		var_0_0("changed smartmatch status from %s -> %s", var_0_1[arg_38_0._prev_smartmatch_state] or "None", var_0_1[arg_38_0._smartmatch_state])

		arg_38_0._prev_smartmatch_state = arg_38_0._smartmatch_state
	end

	arg_38_0:_create_smartmatch_broadcast(600)

	arg_38_0._smartmatch_in_progress = true
	arg_38_0._reissue_host_smartmatch_ticket = false
	arg_38_0._force_broadcast = false

	var_0_0("######### Created smartmatch session broadcast for lobby host #########")
end

function XboxLiveLobby._convert_to_json(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = var_0_3[arg_39_1]

	fassert(var_39_0, "[SmartMatch::_convert_to_json] No such hopper_name:  %s", arg_39_1)

	local var_39_1 = ""

	for iter_39_0, iter_39_1 in ipairs(var_39_0) do
		local var_39_2 = var_0_4[iter_39_1]
		local var_39_3 = arg_39_2[iter_39_1]

		fassert(var_39_3, "[SmartMatch::_convert_to_json] Missing variable [%s] in params", iter_39_1)

		if var_39_2 == "number" then
			var_39_1 = var_39_1 .. string.format("%q:%i,", iter_39_1, var_39_3)
		elseif var_39_2 == "string" then
			var_39_1 = var_39_1 .. string.format("%q:%q,", iter_39_1, var_39_3)
		elseif var_39_2 == "collection" then
			var_39_1 = var_39_1 .. string.format("%q:[", iter_39_1)

			for iter_39_2, iter_39_3 in ipairs(var_39_3) do
				if iter_39_2 == 1 then
					var_39_1 = var_39_1 .. string.format("%q", tostring(iter_39_3))
				else
					var_39_1 = var_39_1 .. string.format(",%q", tostring(iter_39_3))
				end
			end

			var_39_1 = var_39_1 .. "],"
		end
	end

	if var_39_1 == "" then
		return
	else
		local var_39_4 = string.sub(var_39_1, 1, -2)

		print("Hopper name:", arg_39_1, "JSON_DATA:", string.format("{%s}", var_39_4))

		return string.format("{%s}", var_39_4)
	end
end

function XboxLiveLobby._create_smartmatch_broadcast(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_1 or 600
	local var_40_1 = PreserveSessionMode.ALWAYS

	var_0_0("PreserveSessionMode %s. is host %s", "ALWAYS", "TRUE")

	local var_40_2 = arg_40_0:members()
	local var_40_3 = {}

	for iter_40_0, iter_40_1 in ipairs(var_40_2) do
		local var_40_4 = Managers.player:player_from_peer_id(iter_40_1)

		if var_40_4 then
			var_40_3[#var_40_3 + 1] = var_40_4:profile_index()
		end
	end

	if #var_40_3 > 0 then
		arg_40_0._smartmatch_ticket_params.profiles = var_40_3
	end

	local var_40_5

	if Managers.matchmaking then
		local var_40_6 = Managers.matchmaking:get_average_power_level()

		if var_40_6 then
			arg_40_0._smartmatch_ticket_params.powerlevel = var_40_6
		end
	end

	local var_40_7

	if arg_40_0._smartmatch_ticket_params then
		var_40_7 = arg_40_0:_convert_to_json(arg_40_0._hopper_name, arg_40_0._smartmatch_ticket_params)

		var_0_0("Ticket Params: %s Hopper Name: %s", var_40_7, arg_40_0._hopper_name)
	end

	var_0_0("Starting SmartMatch with session_id: %s Hopper name: %s PreserveSessionMode: %s Ticket params: %s Timeout: %s", tostring(arg_40_0._session_id), arg_40_0._hopper_name, "ALWAYS", var_40_7, tostring(var_40_0))
	MultiplayerSession.start_smartmatch(arg_40_0._session_id, arg_40_0._hopper_name, var_40_0, var_40_1, var_40_7)

	arg_40_0._smartmatch_user_id = Managers.account:user_id()
end

function XboxLiveLobby.session_id(arg_41_0)
	return arg_41_0._session_id
end

function XboxLiveLobby.session_template_name(arg_42_0)
	return arg_42_0._session_template_name
end

function XboxLiveLobby.leave(arg_43_0)
	var_0_0("Destroying Lobby --> session_id: %s - session_name: %s", arg_43_0._session_id, arg_43_0._data.session_name)

	arg_43_0._activity_set = false

	local var_43_0 = {
		destroy_session = true,
		state = "_cleanup_ticket",
		user_id = arg_43_0._smartmatch_user_id,
		session_id = arg_43_0._session_id,
		hopper_name = arg_43_0._hopper_name,
		session_name = arg_43_0._data.session_name
	}

	Managers.account:add_session_to_cleanup(var_43_0)

	if arg_43_0._data_update_status_id ~= nil then
		local var_43_1 = MultiplayerSession.custom_property_json_status(arg_43_0._data_update_status_id)

		if var_43_1 == SessionJobStatus.COMPLETE or var_43_1 == SessionJobStatus.FAILED then
			MultiplayerSession.free_custom_property_json(arg_43_0._data_update_status_id)

			arg_43_0._data_update_status_id = nil
		end
	end
end

function XboxLiveLobby.free(arg_44_0)
	Network.free_multiplayer_session(arg_44_0._session_id)
end

function XboxLiveLobby.set_data(arg_45_0, arg_45_1, arg_45_2)
	arg_45_0._data[arg_45_1] = arg_45_2
	arg_45_0._data_needs_update = true
end

function XboxLiveLobby.set_data_table(arg_46_0, arg_46_1)
	for iter_46_0, iter_46_1 in pairs(arg_46_1) do
		arg_46_0._data[iter_46_0] = iter_46_1
	end

	arg_46_0._data_needs_update = true
end

function XboxLiveLobby.data(arg_47_0, arg_47_1)
	return arg_47_0._data[arg_47_1]
end

function XboxLiveLobby.members(arg_48_0)
	local var_48_0 = {}
	local var_48_1 = MultiplayerSession.members(arg_48_0._session_id)

	for iter_48_0, iter_48_1 in pairs(var_48_1) do
		var_48_0[#var_48_0 + 1] = iter_48_1.peer
	end

	return var_48_0
end

function XboxLiveLobby.update_user_names(arg_49_0)
	local var_49_0 = MultiplayerSession.members(arg_49_0._session_id)

	for iter_49_0, iter_49_1 in pairs(var_49_0) do
		arg_49_0._gamertags[iter_49_1.peer] = iter_49_1.gamertag
	end
end

function XboxLiveLobby.user_name(arg_50_0, arg_50_1)
	local var_50_0 = MultiplayerSession.members(arg_50_0._session_id)

	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		if iter_50_1.peer == arg_50_1 then
			arg_50_0._gamertags[arg_50_1] = iter_50_1.gamertag

			return iter_50_1.gamertag
		end
	end

	return arg_50_0._gamertags[arg_50_1]
end

function XboxLiveLobby.xuid(arg_51_0, arg_51_1)
	local var_51_0 = MultiplayerSession.members(arg_51_0._session_id)

	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		if iter_51_1.peer == arg_51_1 then
			return iter_51_1.xbox_user_id
		end
	end
end

function XboxLiveLobby.lobby_host(arg_52_0)
	return MultiplayerSession.host_peer(arg_52_0._session_id)
end

function XboxLiveLobby.try_claim_host(arg_53_0)
	MultiplayerSession.try_claim_session(arg_53_0._session_id)
end

function XboxLiveLobby.id(arg_54_0)
	return 1000
end

XboxLiveLobbyBrowser = class(XboxLiveLobbyBrowser)

function XboxLiveLobbyBrowser.init(arg_55_0, arg_55_1, arg_55_2)
	arg_55_0._network_hash = "network_hash:" .. LobbyAux.create_network_hash(arg_55_2.config_file_name, arg_55_2.project_hash)
	arg_55_0._user_id = arg_55_1
	arg_55_0._session_browsing_id = Network.start_session_browsing(arg_55_1, arg_55_0._network_hash, LobbyInternal.SESSION_TEMPLATE_NAME)
	arg_55_0._lobbies = {}
end

LOBBIES = LOBBIES or {}

function XboxLiveLobbyBrowser.is_refreshing(arg_56_0)
	if not arg_56_0._session_browsing_id then
		return false
	end

	if MultiplayerSessionBrowser.status(arg_56_0._session_browsing_id) ~= SessionJobStatus.COMPLETE then
		return true
	end

	arg_56_0._lobbies = MultiplayerSessionBrowser.result(arg_56_0._session_browsing_id) or {}
	LOBBIES = arg_56_0._lobbies

	Network.free_session_browsing(arg_56_0._session_browsing_id)

	arg_56_0._session_browsing_id = nil

	return false
end

function XboxLiveLobbyBrowser.num_lobbies(arg_57_0)
	return #arg_57_0._lobbies
end

function XboxLiveLobbyBrowser.refresh(arg_58_0)
	arg_58_0._session_browsing_id = Network.start_session_browsing(arg_58_0._user_id, arg_58_0._network_hash, LobbyInternal.SESSION_TEMPLATE_NAME)
end

function XboxLiveLobbyBrowser.lobby(arg_59_0, arg_59_1)
	return arg_59_0._lobbies[arg_59_1 + 1]
end

function XboxLiveLobbyBrowser.destroy(arg_60_0)
	if arg_60_0._session_browsing_id then
		Network.free_session_browsing(arg_60_0._session_browsing_id)
	end
end
