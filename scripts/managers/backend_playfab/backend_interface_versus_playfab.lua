-- chunkname: @scripts/managers/backend_playfab/backend_interface_versus_playfab.lua

local var_0_0 = require("scripts/managers/backend_playfab/settings/flexmatch_queue_status")
local var_0_1 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

BackendInterfaceVersusPlayFab = class(BackendInterfaceVersusPlayFab)

local var_0_2 = {
	slot_necklace = "versus",
	slot_hat = "versus",
	slot_ring = "versus",
	slot_frame = "versus",
	slot_pose = "items",
	slot_ranged = "versus",
	slot_trinket_1 = "versus",
	slot_skin = "versus",
	slot_melee = "versus"
}

local function var_0_3(arg_1_0, ...)
	arg_1_0 = "[BackendInterfaceVersusPlayFab] " .. arg_1_0

	printf(arg_1_0, ...)
end

local function var_0_4(arg_2_0, arg_2_1, arg_2_2, ...)
	local var_2_0

	if arg_2_0.response then
		arg_2_1 = arg_2_1 or -1

		local var_2_1 = arg_2_0.status or "UNKNOWN_ERROR"
		local var_2_2 = arg_2_0.response

		var_2_0 = string.format("[%s] %s (%d)", var_2_1, var_2_2, arg_2_1)
	elseif arg_2_0.message then
		var_2_0 = arg_2_0.message
	else
		var_2_0 = "Unknown Error"
	end

	var_0_3(var_2_0)
	var_0_3(arg_2_2, ...)
	table.dump(arg_2_0, "BackendInterfaceVersusPlayFab", 5)
end

local function var_0_5(arg_3_0)
	local var_3_0, var_3_1 = pcall(cjson.decode, arg_3_0)

	if var_3_0 then
		return var_3_1
	end

	return {
		response = tostring(arg_3_0)
	}
end

function BackendInterfaceVersusPlayFab.init(arg_4_0, arg_4_1)
	arg_4_0._backend_mirror = arg_4_1
	arg_4_0._profile_data = {}
	arg_4_0._items_interface = Managers.backend:get_interface("items")

	Managers.backend:add_loadout_interface_override("versus", var_0_2)
	Managers.backend:add_loadout_interface_override("inn_vs", var_0_2)

	arg_4_0._dirty = true
	arg_4_0._is_matchmaking = false
	arg_4_0._backfilling_player_ids = {}
	arg_4_0._matchmaking_status = nil
end

function BackendInterfaceVersusPlayFab._refresh(arg_5_0)
	local var_5_0 = arg_5_0._backend_mirror:get_read_only_data("vs_profile_data") or "{}"

	arg_5_0._profile_data = cjson.decode(var_5_0)
	arg_5_0._dirty = false
end

function BackendInterfaceVersusPlayFab.make_dirty(arg_6_0)
	arg_6_0._dirty = true
end

function BackendInterfaceVersusPlayFab.ready(arg_7_0)
	return true
end

function BackendInterfaceVersusPlayFab.get_profile_data(arg_8_0, arg_8_1)
	if arg_8_0._dirty then
		arg_8_0:_refresh()
	end

	return arg_8_0._profile_data[arg_8_1]
end

function BackendInterfaceVersusPlayFab.get_loadout_item_id(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_0._dirty then
		arg_9_0:_refresh()
	end

	return arg_9_0._items_interface:get_loadout_item_id(arg_9_1, arg_9_2, arg_9_3)
end

function BackendInterfaceVersusPlayFab.set_loadout_item(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_0._dirty then
		arg_10_0:_refresh()
	end

	arg_10_0._dirty = true

	return arg_10_0._items_interface:set_loadout_item(arg_10_1, arg_10_2, arg_10_3)
end

local var_0_6 = {
	"Content-Type: application/json"
}
local var_0_7 = {
	"User-Agent: Warhammer: Vermintide 2",
	"Accept: application/json"
}

function BackendInterfaceVersusPlayFab.request_regions(arg_11_0, arg_11_1)
	fassert(arg_11_1 ~= nil, "request_regions is missing external_cb")

	local var_11_0 = {
		FunctionName = "getMatchMakingRegions",
		FunctionParameter = {}
	}
	local var_11_1 = callback(arg_11_0, "request_matchmaking_regions_cb", arg_11_1)

	arg_11_0._backend_mirror:request_queue():enqueue(var_11_0, var_11_1, true)
end

function BackendInterfaceVersusPlayFab.request_matchmaking_regions_cb(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.FunctionResult

	arg_12_1(var_12_0)

	if not var_12_0.success or not var_12_0.regions then
		if type(arg_12_2) == "table" then
			table.dump(arg_12_2, "BackendInterfaceVersusPlayFab", 5)
		else
			print("getMatchmakingQueueTicket result: %s", tostring(arg_12_2))
		end

		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Failed to get matchmaking regions")
	end
end

function BackendInterfaceVersusPlayFab.get_matchmaking_url(arg_13_0)
	if arg_13_0._base_url then
		return arg_13_0._base_url
	end

	return arg_13_0._backend_mirror:get_matchmaking_url()
end

function BackendInterfaceVersusPlayFab.start_matchmaking(arg_14_0, arg_14_1, arg_14_2)
	var_0_3("Starting matchmaking")

	local var_14_0 = arg_14_0:get_matchmaking_url()
	local var_14_1 = string.format("%s/matchmaking/start", var_14_0)
	local var_14_2 = callback(arg_14_0, "_start_matchmaking_cb", arg_14_2)
	local var_14_3 = cjson.encode({
		queueTickets = table.values(arg_14_1)
	})

	Managers.curl:post(var_14_1, var_14_3, var_0_6, var_14_2)
end

function BackendInterfaceVersusPlayFab._start_matchmaking_cb(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = var_0_5(arg_15_5)

	if var_15_0.debug_msg then
		Managers.chat:add_local_system_message(1, var_15_0.debug_msg, true)
	end

	if not arg_15_2 or arg_15_3 ~= 200 then
		var_0_4(var_15_0, arg_15_3, "Failed to start matchmaking. result: %s", tostring(arg_15_2))
		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Failed to start matchmaking")

		if arg_15_1 then
			arg_15_1(arg_15_2, arg_15_3, arg_15_4, nil)
		end

		return
	end

	arg_15_0._matchmaking_session_id = var_15_0.matchmakingSessionId
	arg_15_0._is_matchmaking = true
	arg_15_0._matchmaking_status = var_15_0.status

	var_0_3("Matchmaking started. matchmakingSessionId: %s", var_15_0.matchmakingSessionId)

	if arg_15_1 then
		arg_15_1(arg_15_2, arg_15_3, arg_15_4, var_15_0)
	end
end

function BackendInterfaceVersusPlayFab.cancel_matchmaking(arg_16_0, arg_16_1)
	var_0_3("Cancelling matchmaking")

	if not arg_16_0:is_matchmaking() then
		if arg_16_1 then
			arg_16_1(true, 200)
		end

		return
	end

	if not arg_16_0._matchmaking_session_id then
		var_0_3("Failed to cancel matchmaking. Reason: missing matchmaking_session_id")

		if arg_16_1 then
			arg_16_1(false, 404)
		end

		return
	end

	local var_16_0 = arg_16_0:get_matchmaking_url()
	local var_16_1 = string.format("%s/matchmaking/sessions/%s/cancel", var_16_0, arg_16_0._matchmaking_session_id)
	local var_16_2 = callback(arg_16_0, "_cancel_matchmaking_cb", arg_16_1)
	local var_16_3 = cjson.encode({
		matchmakingSessionId = arg_16_0._matchmaking_session_id
	})

	Managers.curl:post(var_16_1, var_16_3, var_0_6, var_16_2)
end

function BackendInterfaceVersusPlayFab._cancel_matchmaking_cb(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	arg_17_0._matchmaking_session_id = nil
	arg_17_0._is_matchmaking = nil

	local var_17_0 = var_0_5(arg_17_5)

	if var_17_0.debug_msg then
		Managers.chat:add_local_system_message(1, var_17_0.debug_msg, true)
	end

	if not arg_17_2 or arg_17_3 ~= 200 then
		var_0_4(var_17_0, arg_17_3, "Failed to cancel matchmaking. result: %s", tostring(arg_17_2))

		if arg_17_1 then
			arg_17_1(arg_17_2, arg_17_3, arg_17_4, nil)
		end

		return
	end

	var_0_3("Matchmaking cancelled")

	if arg_17_1 then
		arg_17_1(arg_17_2, arg_17_3, arg_17_4, var_17_0)
	end
end

function BackendInterfaceVersusPlayFab.fetch_matchmaking_session_data(arg_18_0, arg_18_1)
	if not arg_18_0._matchmaking_session_id then
		var_0_3("Failed to fetch matchmaking session data. Reason: missing matchmaking_session_id")

		if arg_18_1 then
			arg_18_1(false, 404)
		end

		return false
	end

	local var_18_0 = arg_18_0:get_matchmaking_url()
	local var_18_1 = string.format("%s/matchmaking/sessions/%s", var_18_0, arg_18_0._matchmaking_session_id)
	local var_18_2 = callback(arg_18_0, "_fetch_matchmaking_session_data_cb", arg_18_1)

	Managers.curl:get(var_18_1, var_0_7, var_18_2)
end

function BackendInterfaceVersusPlayFab._fetch_matchmaking_session_data_cb(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local var_19_0 = var_0_5(arg_19_5)

	if var_19_0.debug_msg then
		Managers.chat:add_local_system_message(1, var_19_0.debug_msg, true)
	end

	if not arg_19_2 or arg_19_3 ~= 200 then
		var_0_4(var_19_0, arg_19_3, "Failed to fetch matchmaking session data. result: %s", tostring(arg_19_2))
		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Failed to fetch matchmaking session data")

		if arg_19_1 then
			arg_19_1(arg_19_2, arg_19_3, arg_19_4, nil)
		end

		return
	end

	if var_19_0.status ~= arg_19_0._matchmaking_status then
		var_0_3("Matchmaking session data fetched. matchmakingSessionId: %s, status: %s", var_19_0.matchmakingSessionId, var_19_0.status)

		arg_19_0._matchmaking_status = var_19_0.status
	end

	if var_19_0.status == var_0_0.Succeeded then
		arg_19_0._is_matchmaking = false
	elseif var_19_0.status == var_0_0.Failed then
		var_0_4(var_19_0, arg_19_3, "Matchmaking changed to unwanted status '%s'. result: %s", var_19_0.status, tostring(arg_19_2))
		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Matchmaking changed to unwanted status '%s'", var_19_0.status)
	end

	if arg_19_1 then
		arg_19_1(arg_19_2, arg_19_3, arg_19_4, var_19_0)
	end
end

function BackendInterfaceVersusPlayFab.is_matchmaking(arg_20_0)
	return arg_20_0._is_matchmaking
end

function BackendInterfaceVersusPlayFab.request_matchmaking_ticket(arg_21_0, arg_21_1, arg_21_2)
	var_0_3("Requesting matchmaking ticket")
	fassert(arg_21_2 ~= nil, "request_matchmaking_ticket is missing external_cb")

	local var_21_0 = {
		FunctionName = "getMatchmakingQueueTicket",
		FunctionParameter = {
			alias_type = "mission",
			matchmaking_type = "quickplay",
			peer_id = Steam.user_id(),
			latency_list = arg_21_1,
			network_hash = LobbySetup.network_hash()
		}
	}
	local var_21_1 = callback(arg_21_0, "request_matchmaking_ticket_cb", arg_21_2)

	arg_21_0._backend_mirror:request_queue():enqueue(var_21_0, var_21_1, true)
end

function BackendInterfaceVersusPlayFab.request_matchmaking_ticket_cb(arg_22_0, arg_22_1, arg_22_2)
	var_0_3("Matchmaking ticket response")

	local var_22_0 = arg_22_2.FunctionResult

	if var_22_0.ticket then
		arg_22_0._base_url = var_22_0.url
	else
		if type(var_22_0) == "table" then
			table.dump(var_22_0, "BackendInterfaceVersusPlayFab", 5)
		else
			print("getMatchmakingQueueTicket result: %s", tostring(var_22_0))
		end

		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Failed to get matchmaking queue ticket")
	end

	arg_22_1(var_22_0)
end

function BackendInterfaceVersusPlayFab.reset_fetched_data(arg_23_0)
	assert(DEDICATED_SERVER, "Dedicated server function only")

	arg_23_0._matchmaking_session_id = false
	arg_23_0._game_session_data = nil
	arg_23_0._game_session_id = nil
end

function BackendInterfaceVersusPlayFab.get_game_session_data(arg_24_0)
	return arg_24_0._game_session_data
end

function BackendInterfaceVersusPlayFab.set_matchmaking_session_id(arg_25_0, arg_25_1)
	assert(not DEDICATED_SERVER, "player function only")

	arg_25_0._matchmaking_session_id = arg_25_1
	arg_25_0._is_matchmaking = arg_25_1 ~= nil
end

function BackendInterfaceVersusPlayFab.get_matchmaking_session_id(arg_26_0)
	return arg_26_0._matchmaking_session_id
end

function BackendInterfaceVersusPlayFab.is_player_in_backfilling_data(arg_27_0, arg_27_1)
	return table.contains(arg_27_0._backfilling_player_ids, arg_27_1)
end

function BackendInterfaceVersusPlayFab.matchmaking_enabled(arg_28_0, arg_28_1)
	local var_28_0 = Managers.backend:get_title_settings()
	local var_28_1 = var_28_0.versus and var_28_0.versus.matchmaking_settings

	if not var_28_1 then
		return true
	end

	local var_28_2 = var_28_1[arg_28_1]

	if not var_28_2 then
		return true
	end

	local var_28_3 = var_28_2.enabled

	if var_28_3 == nil then
		return true
	end

	local var_28_4 = var_28_2.disabled_reason

	return var_28_3, var_28_4
end
