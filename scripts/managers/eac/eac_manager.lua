-- chunkname: @scripts/managers/eac/eac_manager.lua

local var_0_0 = table.enum("untrusted", "trusted", "banned", "undetermined")
local var_0_1 = 15

local function var_0_2(...)
	print("[EACManager] " .. string.format(...))
end

EacManager = class(EacManager)
USE_EOS = true

local function var_0_3()
	if not IS_WINDOWS and not DEDICATED_SERVER then
		return false, "unsupported platform: " .. tostring(PLATFORM)
	end

	if script_data["eac-untrusted"] then
		return false, "in modded realm"
	end

	if USE_EOS then
		if not rawget(_G, "EOS_EAC") then
			return false, "EOS_EAC not available"
		end

		if DEDICATED_SERVER then
			local var_2_0 = EOS_EAC.has_eac_server()

			assert(var_2_0, "Dedicated server is running without EAC running in server mode")

			return true
		end

		return EOS_EAC.has_eac_client(), "EAC client not available"
	else
		if not rawget(_G, "EAC") then
			return false, "EAC not available"
		end

		return true
	end
end

function EacManager.init(arg_3_0)
	local var_3_0, var_3_1 = var_0_3()

	if var_3_0 then
		var_0_2("EAC enabled")
	else
		var_0_2("Disabling EAC due to reason: %s", var_3_1)
	end

	arg_3_0._peer_data = {}
	arg_3_0._eac_supported = var_3_0
	arg_3_0._host_peer_id = nil
	arg_3_0._local_role = nil
	arg_3_0._network_model = nil
	arg_3_0._user_id = "untrusted"
	arg_3_0._suppress_popup = not var_3_0
	arg_3_0._suppress_panel = not var_3_0
	arg_3_0._popup_id = nil
	arg_3_0._indicator_offset = 0
end

function EacManager.challenge_response(arg_4_0, arg_4_1)
	if arg_4_0._eac_supported then
		if USE_EOS then
			return EOS_EAC.challenge_response(arg_4_1)
		else
			return EAC.challenge_response(arg_4_1)
		end
	end

	return nil
end

function EacManager.is_trusted(arg_5_0)
	if arg_5_0._eac_supported then
		if USE_EOS then
			if EOS_EAC.has_eac_server() then
				return true
			end

			return not EOS_EAC.get_integrity_violation()
		else
			return EAC.state() == var_0_0.trusted
		end
	end

	return false
end

function EacManager.before_join(arg_6_0, arg_6_1)
	assert(arg_6_0._local_role == nil, "Method called in incompatible state")
	assert(arg_6_1 == "client_server" or arg_6_1 == "peer_to_peer", "Invalid network_model argument")

	arg_6_0._local_role = "client"
	arg_6_0._network_model = arg_6_1

	if arg_6_0._eac_supported then
		if USE_EOS then
			EOS_EAC.begin_session(arg_6_1)
		else
			EAC.before_join()
		end
	end
end

function EacManager.after_leave(arg_7_0)
	assert(arg_7_0._local_role == "client", "Method called in incompatible state")

	if arg_7_0._eac_supported then
		if USE_EOS then
			EOS_EAC.end_session()
			arg_7_0:_pump_eos_actions()
		else
			EAC.after_leave()
		end
	end

	local var_7_0 = arg_7_0._host_peer_id

	if var_7_0 then
		arg_7_0._peer_data[var_7_0] = nil
	else
		var_0_2("Left EAC session without setting the host.")
	end

	arg_7_0._local_role = nil
	arg_7_0._session_mode = nil
	arg_7_0._host_peer_id = nil
end

function EacManager.set_host(arg_8_0, arg_8_1)
	assert(arg_8_0._local_role == "client", "Method called in incompatible state")
	assert(arg_8_0._host_peer_id == nil, "Host was already set and cannot be changed")

	local var_8_0 = PEER_ID_TO_CHANNEL[arg_8_1]

	assert(var_8_0, "Must already be connected")

	arg_8_0._host_peer_id = arg_8_1

	local var_8_1 = {
		user_id = false,
		peer_id = arg_8_1,
		channel_id = var_8_0
	}

	arg_8_0._peer_data[arg_8_1] = var_8_1

	if arg_8_0._eac_supported then
		if USE_EOS then
			if arg_8_0._network_model == "peer_to_peer" then
				arg_8_0:_initiate_handshake(arg_8_1)
			elseif arg_8_0._network_model == "client_server" then
				EOS_EAC.set_server_peer_id(arg_8_1)

				var_8_1.timeout_t = math.huge
				var_8_1.is_server = true
			end
		else
			EAC.set_host(var_8_0)
			EAC.validate_host()
		end
	else
		arg_8_0:_initiate_handshake(arg_8_1)
	end
end

function EacManager.check_host(arg_9_0)
	assert(arg_9_0._local_role == "client", "Method called in incompatible state")
	assert(arg_9_0._host_peer_id, "Cannot check the host before it has been set.")

	local var_9_0
	local var_9_1

	if arg_9_0._eac_supported then
		if USE_EOS then
			var_9_0, var_9_1 = arg_9_0:_check_peer(arg_9_0._host_peer_id)
		else
			local var_9_2 = EAC.state(arg_9_0._host_peer_id)
			local var_9_3 = EAC.state()

			var_9_0, var_9_1 = arg_9_0:_check_states_compatible(var_9_2, var_9_3)
		end
	else
		var_9_0, var_9_1 = arg_9_0:_check_peer(arg_9_0._host_peer_id)
	end

	return var_9_0, var_9_1
end

function EacManager._check_peer(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._peer_data[arg_10_1]

	if var_10_0.untrusted then
		return true, not arg_10_0._eac_supported
	end

	if var_10_0.is_server then
		return true, true
	end

	if not var_10_0.user_id then
		return false, true
	end

	if USE_EOS and arg_10_0._eac_supported and EOS_EAC.peer_status(arg_10_1) == EOS_EAC_ACCCAS.RemoteAuthComplete then
		return true, true
	end

	return false, true
end

function EacManager._check_states_compatible(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 == var_0_0.banned or arg_11_2 == var_0_0.banned then
		return true, false
	end

	if arg_11_1 == var_0_0.undetermined or arg_11_2 == var_0_0.undetermined then
		return false, true
	end

	local var_11_0 = arg_11_1 == arg_11_2

	return true, var_11_0
end

function EacManager.is_initialized(arg_12_0)
	if arg_12_0._eac_supported then
		if USE_EOS then
			return arg_12_0._eos_auth_complete, arg_12_0._eos_auth_error
		else
			if not EAC.is_initialized() then
				return false, nil
			end

			local var_12_0, var_12_1 = EAC.initialization_error()

			if var_12_1 then
				return true, var_12_1
			end
		end
	end

	return true, nil
end

function EacManager.server_create(arg_13_0, arg_13_1)
	assert(arg_13_0._local_role == nil, "Method called in incompatible state")
	assert(arg_13_1 ~= nil, "Must provide a server_name")

	arg_13_0._local_role = "server"

	if arg_13_0._eac_supported then
		if USE_EOS then
			local var_13_0 = EOS_EAC.has_eac_server() and "client_server" or "peer_to_peer"

			EOS_EAC.begin_session(var_13_0)
		else
			assert(arg_13_0._eac_server == nil, "An EAC server already exists")

			arg_13_0._eac_server = EACServer.create(arg_13_1)
		end
	end

	var_0_2("Created EACServer with name %q", arg_13_1)
end

function EacManager.server_destroy(arg_14_0)
	assert(arg_14_0._local_role == "server", "Method called in incompatible state")

	arg_14_0._local_role = nil

	if arg_14_0._eac_supported then
		if USE_EOS then
			EOS_EAC.end_session()
			arg_14_0:_pump_eos_actions()
		else
			EACServer.destroy(arg_14_0._eac_server)

			arg_14_0._eac_server = nil
		end
	end

	var_0_2("Destroyed EACServer (%d registered peers)", table.size(arg_14_0._peer_data))
	table.clear(arg_14_0._peer_data)
end

function EacManager.server_add_peer(arg_15_0, arg_15_1)
	assert(arg_15_0._local_role == "server", "Method called in incompatible state")
	fassert(not arg_15_0._peer_data[arg_15_1], "Peer %q was already added", arg_15_1)
	var_0_2("Adding peer %s", arg_15_1)

	local var_15_0 = PEER_ID_TO_CHANNEL[arg_15_1]

	assert(var_15_0, "Must already be connected")

	local var_15_1 = {
		peer_id = arg_15_1,
		channel_id = var_15_0
	}

	arg_15_0._peer_data[arg_15_1] = var_15_1

	if arg_15_0._eac_supported then
		if USE_EOS then
			arg_15_0:_initiate_handshake(arg_15_1)
		else
			EACServer.add_peer(arg_15_0._eac_server, var_15_0)
		end
	else
		arg_15_0:_initiate_handshake(arg_15_1)
	end
end

function EacManager.server_remove_peer(arg_16_0, arg_16_1)
	assert(arg_16_0._local_role == "server", "Method called in incompatible state")
	fassert(arg_16_0._peer_data[arg_16_1], "Peer %q was already removed", arg_16_1)
	var_0_2("Removing peer %s", arg_16_1)

	if arg_16_0._eac_supported then
		if USE_EOS then
			if arg_16_0._peer_data[arg_16_1].added then
				EOS_EAC.remove_peer(arg_16_1)
			end
		else
			local var_16_0 = PEER_ID_TO_CHANNEL[arg_16_1]

			EACServer.remove_peer(arg_16_0._eac_server, var_16_0)
		end
	end

	arg_16_0._peer_data[arg_16_1] = nil
end

function EacManager.server_check_peer(arg_17_0, arg_17_1)
	if arg_17_1 == Network.peer_id() then
		return true, true
	end

	local var_17_0
	local var_17_1

	if arg_17_0._eac_supported then
		if USE_EOS then
			var_17_0, var_17_1 = arg_17_0:_check_peer(arg_17_1)
		else
			local var_17_2 = arg_17_0._eac_server
			local var_17_3 = EACServer.state(var_17_2, Network.peer_id())
			local var_17_4 = EACServer.state(var_17_2, arg_17_1)

			var_17_0, var_17_1 = arg_17_0:_check_states_compatible(var_17_3, var_17_4)
		end
	else
		var_17_0, var_17_1 = arg_17_0:_check_peer(arg_17_1)
	end

	return var_17_0, var_17_1
end

function EacManager.update(arg_18_0, arg_18_1, arg_18_2)
	if arg_18_0._eac_server then
		EACServer.update(arg_18_0._eac_server)
	end

	arg_18_0:_handle_eos(arg_18_2)

	if IS_WINDOWS then
		arg_18_0:_handle_violations()
		arg_18_0:_handle_popups()
	end
end

function EacManager.register_network_event_delegate(arg_19_0, arg_19_1)
	arg_19_1:register(arg_19_0, "rpc_eac_handshake_request", "rpc_eac_handshake_reply")

	arg_19_0._network_event_delegate = arg_19_1
end

function EacManager.unregister_network_event_delegate(arg_20_0)
	arg_20_0._network_event_delegate:unregister(arg_20_0)

	arg_20_0._network_event_delegate = nil
end

function EacManager._initiate_handshake(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._peer_data[arg_21_1]

	RPC.rpc_eac_handshake_request(var_21_0.channel_id)

	var_21_0.timeout_t = Managers.time:time("main") + var_0_1
	var_21_0.untrusted = false
end

function EacManager.rpc_eac_handshake_request(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._user_id

	RPC.rpc_eac_handshake_reply(arg_22_1, var_22_0)
end

function EacManager.rpc_eac_handshake_reply(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = CHANNEL_TO_PEER_ID[arg_23_1]
	local var_23_1 = arg_23_0._peer_data[var_23_0]

	if not var_23_1 then
		var_0_2("Ignoring handshake reply from unknown peer %s", var_23_0)

		return
	end

	if var_23_1.untrusted then
		var_0_2("Ignoring handshake reply from already untrusted peer %s", var_23_0)

		return
	end

	if var_23_1.added then
		var_0_2("Ignoring handshake reply from already added peer %s", var_23_0)

		return
	end

	if arg_23_2 == "untrusted" then
		var_23_1.untrusted = true
	else
		var_23_1.user_id = arg_23_2
		var_23_1.timeout_t = math.huge

		if arg_23_0._eac_supported and USE_EOS then
			EOS_EAC.add_peer(var_23_0, arg_23_2)

			var_23_1.added = true
		end
	end
end

function EacManager._pump_eos_actions(arg_24_0)
	while EOS_EAC.has_eac_action() do
		local var_24_0 = EOS_EAC.next_eac_action()
		local var_24_1 = table.find(EOS_EAC_ACCCA, var_24_0.action) or "?"
		local var_24_2 = table.find(EOS_EAC_ACCCAR, var_24_0.reason) or "?"

		var_0_2("Got action { action=%d %q, reason=%d %q, details=%q, peer=%q }", var_24_0.action, var_24_1, var_24_0.reason, var_24_2, var_24_0.details, var_24_0.peer)

		local var_24_3 = arg_24_0._peer_data[var_24_0.peer]

		if var_24_3 then
			if var_24_0.action == EOS_EAC_ACCCA.RemovePlayer then
				var_24_3.untrusted = true
			else
				var_0_2("Ignored action because it was unknown")
			end
		else
			var_0_2("Ignored action because peer %q is not registed", var_24_0.peer)
		end
	end
end

local var_0_4 = {
	init = function(arg_25_0)
		return "retrieve_ticket"
	end,
	retrieve_ticket = function(arg_26_0, arg_26_1)
		var_0_2("Retrieving Steam auth session ticket...")

		arg_26_0._steam_ticket_job = Steam.retrieve_auth_session_ticket("epiconlineservices")

		return "poll_ticket"
	end,
	poll_ticket = function(arg_27_0)
		local var_27_0 = Steam.poll_auth_session_ticket(arg_27_0._steam_ticket_job)

		if var_27_0 then
			arg_27_0._steam_ticket_job = nil
			arg_27_0._auth_session_ticket = var_27_0

			return "start_authenticate"
		end
	end,
	start_authenticate = function(arg_28_0)
		var_0_2("Authenticating with Steam as an identity provider...")
		EOS_EAC.authenticate_with_steam(arg_28_0._auth_session_ticket)

		arg_28_0._auth_session_ticket = nil

		return "poll_authenticate"
	end,
	poll_authenticate = function(arg_29_0)
		local var_29_0, var_29_1 = EOS_EAC.poll_authenticate_status()

		if var_29_0 == "in_flight" then
			return
		end

		if var_29_0 == "success" then
			arg_29_0._user_id = EOS_EAC.user_id()
			arg_29_0._eos_auth_error = nil
		else
			arg_29_0._eos_auth_error = string.format("EOS auth status=%s, result=%s", var_29_0, table.find(EOS_Result, var_29_1) or "?")
		end

		arg_29_0._eos_auth_complete = true

		var_0_2("Login complete. Error: %s", arg_29_0._eos_auth_error or "none")

		return "poll_valid"
	end,
	poll_valid = function(arg_30_0)
		if EOS_EAC.poll_authenticate_status() == "expired" then
			var_0_2("Refreshing user id ...")

			return "init"
		end
	end
}

function EacManager._handle_eos(arg_31_0, arg_31_1)
	if not USE_EOS or not arg_31_0._eac_supported then
		return
	end

	if not DEDICATED_SERVER then
		local var_31_0 = arg_31_0._auth_state or "init"
		local var_31_1 = var_0_4[var_31_0](arg_31_0, arg_31_1)

		if var_31_1 then
			arg_31_0._auth_state = var_31_1
		end

		if not arg_31_0._user_id then
			return
		end
	end

	arg_31_0:_pump_eos_actions()

	for iter_31_0, iter_31_1 in pairs(arg_31_0._peer_data) do
		if arg_31_1 > iter_31_1.timeout_t then
			iter_31_1.untrusted = true
		end
	end
end

local var_0_5 = {}

if USE_EOS then
	var_0_5.IntegrityCatalogNotFound = true
	var_0_5.IntegrityCatalogError = true
	var_0_5.IntegrityCatalogMissingMainExecutable = true
	var_0_5.GameFileMismatch = true
	var_0_5.RequiredGameFileNotFound = true
	var_0_5.UnknownGameFileForbidden = true
else
	var_0_5.hash_catalogue_file_not_found = true
	var_0_5.hash_catalogue_error = true
	var_0_5.unknown_game_file_version = true
	var_0_5.required_game_file_not_found = true
end

function EacManager._handle_violations(arg_32_0)
	if arg_32_0._eac_violation_type then
		return
	end

	if USE_EOS and rawget(_G, "EOS_EAC") then
		local var_32_0
		local var_32_1

		if not EOS_EAC.has_eac_client() then
			var_32_0, var_32_1 = "NO_BOOTSTRAPPER", "NO_BOOTSTRAPPER"
		elseif arg_32_0._eos_auth_error then
			var_32_0, var_32_1 = "AUTH_ERROR", arg_32_0._eos_auth_error
		else
			var_32_0, var_32_1 = EOS_EAC.get_integrity_violation()
			var_32_0 = var_32_0 and (table.find(EOS_EAC_ACCVT, var_32_0) or "UNKNOWN")
		end

		if var_32_0 then
			local var_32_2 = "{#color(193,91,36)}"
			local var_32_3 = "{#color(255,255,255)}: "
			local var_32_4 = "{#reset()}"

			arg_32_0._eac_violation_message = var_32_2 .. Localize("eac_state") .. var_32_3 .. Localize("eac_state_untrusted") .. "\n" .. var_32_2 .. Localize("eac_violation_type") .. var_32_3 .. var_32_0 .. "\n" .. var_32_2 .. Localize("eac_cause") .. var_32_3 .. var_32_1 .. "\n" .. var_32_4 .. Localize("eac_untrusted_explanation")
			arg_32_0._eac_violation_type = var_32_0
		end
	elseif rawget(_G, "EAC") then
		local var_32_5, var_32_6, var_32_7, var_32_8 = EAC.state()

		if var_32_5 == var_0_0.untrusted or var_32_5 == var_0_0.banned then
			local var_32_9 = "{#color(193,91,36)}"
			local var_32_10 = "{#color(255,255,255)}: "
			local var_32_11 = "{#reset()}"

			arg_32_0._eac_violation_message = var_32_9 .. Localize("eac_state") .. var_32_10 .. Localize("eac_state_untrusted") .. "\n" .. var_32_9 .. Localize("eac_violation_type") .. var_32_10 .. var_32_8 .. "\n" .. var_32_9 .. Localize("eac_cause") .. var_32_10 .. var_32_7 .. "\n" .. var_32_11 .. Localize(var_32_5 == var_0_0.banned and "eac_banned_explanation" or "eac_untrusted_explanation")
			arg_32_0._eac_violation_type = var_32_8
		end
	end

	if arg_32_0._eac_violation_type then
		Crashify.print_exception("EAC", "Integrity violation: %s", arg_32_0._eac_violation_type)
	end
end

function EacManager._handle_popups(arg_33_0)
	local var_33_0 = Managers.popup

	if arg_33_0._popup_id ~= nil and var_33_0:query_result(arg_33_0._popup_id) == "quit" then
		arg_33_0._popup_id = nil

		Application.quit()
	end

	if arg_33_0._suppress_popup then
		return
	end

	if not var_0_5[arg_33_0._eac_violation_type] then
		return
	end

	local var_33_1 = Localize("eac_file_corruption_detected")
	local var_33_2 = Localize("eac_file_corruption_topic")
	local var_33_3 = Localize("menu_quit")

	arg_33_0._popup_id = var_33_0:queue_popup(var_33_1, var_33_2, "quit", var_33_3)
	arg_33_0._suppress_popup = true
end

function EacManager.draw_panel(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._eac_violation_message

	if not var_34_0 or arg_34_0._suppress_panel then
		return
	end

	local var_34_1 = Vector2
	local var_34_2 = Vector3
	local var_34_3 = Color
	local var_34_4 = math.max(RESOLUTION_LOOKUP.scale, 0.5)
	local var_34_5 = var_34_1(RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h)
	local var_34_6 = "materials/fonts/arial"
	local var_34_7 = 14 * var_34_4
	local var_34_8 = 1.1 * var_34_7
	local var_34_9 = var_34_3(192, 91, 36)
	local var_34_10 = var_34_3(200, 0, 0, 0)
	local var_34_11 = var_34_3(180, 180, 180)
	local var_34_12 = 500 * var_34_4
	local var_34_13 = 1 * var_34_4
	local var_34_14 = var_34_1(15, 10) * var_34_4
	local var_34_15 = var_34_1(40, 20) * var_34_4
	local var_34_16 = 995
	local var_34_17 = Gui.word_wrap(arg_34_1, var_34_0, var_34_6, var_34_7, var_34_12, " ", "_-+&/", "\n", true, Gui.FormatDirectives)
	local var_34_18 = 2 * var_34_14 + var_34_1(var_34_12, #var_34_17 * var_34_8)
	local var_34_19 = var_34_5 - var_34_18 - var_34_15 + var_34_2(0, 0, var_34_16)

	Gui.rect(arg_34_1, var_34_19, var_34_18, var_34_10)
	Gui.rect(arg_34_1, var_34_19 + var_34_2(0, 0, 1), var_34_1(var_34_13, var_34_18.y), var_34_9)
	Gui.rect(arg_34_1, var_34_19 + var_34_2(0, 0, 1), var_34_1(var_34_18.x, var_34_13), var_34_9)
	Gui.rect(arg_34_1, var_34_19 + var_34_2(0, var_34_18.y, 1), var_34_1(var_34_18.x, -var_34_13), var_34_9)
	Gui.rect(arg_34_1, var_34_19 + var_34_2(var_34_18.x, 0, 1), var_34_1(-var_34_13, var_34_18.y), var_34_9)

	local var_34_20 = var_34_19 + var_34_14 + var_34_2(0, 0.18 * var_34_7, 2)

	for iter_34_0 = #var_34_17, 1, -1 do
		Gui.text(arg_34_1, var_34_17[iter_34_0], var_34_6, var_34_7, nil, var_34_20, var_34_11, Gui.FormatDirectives)

		var_34_20.y = var_34_20.y + var_34_8
	end
end

function EacManager.eac_ready_locally(arg_35_0)
	return not not arg_35_0._local_role
end
