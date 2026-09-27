-- chunkname: @scripts/managers/backend_playfab/backend_interface_versus_playfab.lua

local scripts_managers_backend_playfab_settings_flexmatch_queue_status = require("scripts/managers/backend_playfab/settings/flexmatch_queue_status")
local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

BackendInterfaceVersusPlayFab = class(BackendInterfaceVersusPlayFab)

local tbl = {
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

local function fn(arg_1_0, ...)
	-- function 1
	arg_1_0 = "[BackendInterfaceVersusPlayFab] " .. arg_1_0

	printf(arg_1_0, ...)
end

local function fn_2(self, arg_2_1, arg_2_2, ...)
	-- function 2
	local var_2_0

	if not self.response then
		arg_2_1 = arg_2_1 or -1

		local status = self.status

		status = status or "UNKNOWN_ERROR"

		local response = self.response

		var_2_0 = string.format("[%s] %s (%d)", status, response, arg_2_1)
	elseif not self.message then
		var_2_0 = self.message
	else
		var_2_0 = "Unknown Error"
	end

	fn(var_2_0)
	fn(arg_2_2, ...)
	table.dump(self, "BackendInterfaceVersusPlayFab", 5)
end

local function fn_3(arg_3_0)
	-- function 3
	local var_3_0, var_3_1 = pcall(cjson.decode, arg_3_0)

	if not var_3_0 then
		return var_3_1
	end

	return {
		response = tostring(arg_3_0)
	}
end

BackendInterfaceVersusPlayFab.init = function (self, arg_4_1)
	-- function 4
	self._backend_mirror = arg_4_1
	self._profile_data = {}
	self._items_interface = Managers.backend:get_interface("items")

	Managers.backend:add_loadout_interface_override("versus", tbl)
	Managers.backend:add_loadout_interface_override("inn_vs", tbl)

	self._dirty = true
	self._is_matchmaking = false
	self._backfilling_player_ids = {}
	self._matchmaking_status = nil
end

BackendInterfaceVersusPlayFab._refresh = function (self)
	-- function 5
	local get_read_only_data = self._backend_mirror:get_read_only_data("vs_profile_data")

	get_read_only_data = get_read_only_data or "{}"
	self._profile_data = cjson.decode(get_read_only_data)
	self._dirty = false
end

BackendInterfaceVersusPlayFab.make_dirty = function (self)
	-- function 6
	self._dirty = true
end

BackendInterfaceVersusPlayFab.ready = function (arg_7_0)
	-- function 7
	return true
end

BackendInterfaceVersusPlayFab.get_profile_data = function (self, arg_8_1)
	-- function 8
	if not self._dirty then
		self:_refresh()
	end

	return self._profile_data[arg_8_1]
end

BackendInterfaceVersusPlayFab.get_loadout_item_id = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if not self._dirty then
		self:_refresh()
	end

	return self._items_interface:get_loadout_item_id(arg_9_1, arg_9_2, arg_9_3)
end

BackendInterfaceVersusPlayFab.set_loadout_item = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not self._dirty then
		self:_refresh()
	end

	self._dirty = true

	return self._items_interface:set_loadout_item(arg_10_1, arg_10_2, arg_10_3)
end

local tbl_2 = {
	"Content-Type: application/json"
}
local tbl_3 = {
	"User-Agent: Warhammer: Vermintide 2",
	"Accept: application/json"
}

BackendInterfaceVersusPlayFab.request_regions = function (self, arg_11_1)
	-- function 11
	fassert(arg_11_1 ~= nil, "request_regions is missing external_cb")

	local tbl = {
		FunctionName = "getMatchMakingRegions",
		FunctionParameter = {}
	}
	local var_11_1 = callback(self, "request_matchmaking_regions_cb", arg_11_1)

	self._backend_mirror:request_queue():enqueue(tbl, var_11_1, true)
end

BackendInterfaceVersusPlayFab.request_matchmaking_regions_cb = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local FunctionResult = arg_12_2.FunctionResult

	arg_12_1(FunctionResult)

	if not (not FunctionResult.success and FunctionResult.regions) then
		if type(arg_12_2) == "table" then
			table.dump(arg_12_2, "BackendInterfaceVersusPlayFab", 5)
		else
			print("getMatchmakingQueueTicket result: %s", tostring(arg_12_2))
		end

		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Failed to get matchmaking regions")
	end
end

BackendInterfaceVersusPlayFab.get_matchmaking_url = function (self)
	-- function 13
	if not self._base_url then
		return self._base_url
	end

	return self._backend_mirror:get_matchmaking_url()
end

BackendInterfaceVersusPlayFab.start_matchmaking = function (self, arg_14_1, arg_14_2)
	-- function 14
	fn("Starting matchmaking")

	local get_matchmaking_url = self:get_matchmaking_url()
	local format = string.format("%s/matchmaking/start", get_matchmaking_url)
	local var_14_2 = callback(self, "_start_matchmaking_cb", arg_14_2)
	local encode = cjson.encode({
		queueTickets = table.values(arg_14_1)
	})

	Managers.curl:post(format, encode, tbl_2, var_14_2)
end

BackendInterfaceVersusPlayFab._start_matchmaking_cb = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local var_15_0 = fn_3(arg_15_5)

	if not var_15_0.debug_msg then
		Managers.chat:add_local_system_message(1, var_15_0.debug_msg, true)
	end

	if not (not arg_15_2 and arg_15_3 == 200) then
		fn_2(var_15_0, arg_15_3, "Failed to start matchmaking. result: %s", tostring(arg_15_2))
		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Failed to start matchmaking")

		if not arg_15_1 then
			arg_15_1(arg_15_2, arg_15_3, arg_15_4, nil)
		end

		return
	end

	self._matchmaking_session_id = var_15_0.matchmakingSessionId
	self._is_matchmaking = true
	self._matchmaking_status = var_15_0.status

	fn("Matchmaking started. matchmakingSessionId: %s", var_15_0.matchmakingSessionId)

	if not arg_15_1 then
		arg_15_1(arg_15_2, arg_15_3, arg_15_4, var_15_0)
	end
end

BackendInterfaceVersusPlayFab.cancel_matchmaking = function (self, arg_16_1)
	-- function 16
	fn("Cancelling matchmaking")

	if not self:is_matchmaking() then
		if not arg_16_1 then
			arg_16_1(true, 200)
		end

		return
	end

	if not self._matchmaking_session_id then
		fn("Failed to cancel matchmaking. Reason: missing matchmaking_session_id")

		if not arg_16_1 then
			arg_16_1(false, 404)
		end

		return
	end

	local get_matchmaking_url = self:get_matchmaking_url()
	local format = string.format("%s/matchmaking/sessions/%s/cancel", get_matchmaking_url, self._matchmaking_session_id)
	local var_16_2 = callback(self, "_cancel_matchmaking_cb", arg_16_1)
	local encode = cjson.encode({
		matchmakingSessionId = self._matchmaking_session_id
	})

	Managers.curl:post(format, encode, tbl_2, var_16_2)
end

BackendInterfaceVersusPlayFab._cancel_matchmaking_cb = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	self._matchmaking_session_id = nil
	self._is_matchmaking = nil

	local var_17_0 = fn_3(arg_17_5)

	if not var_17_0.debug_msg then
		Managers.chat:add_local_system_message(1, var_17_0.debug_msg, true)
	end

	if not (not arg_17_2 and arg_17_3 == 200) then
		fn_2(var_17_0, arg_17_3, "Failed to cancel matchmaking. result: %s", tostring(arg_17_2))

		if not arg_17_1 then
			arg_17_1(arg_17_2, arg_17_3, arg_17_4, nil)
		end

		return
	end

	fn("Matchmaking cancelled")

	if not arg_17_1 then
		arg_17_1(arg_17_2, arg_17_3, arg_17_4, var_17_0)
	end
end

BackendInterfaceVersusPlayFab.fetch_matchmaking_session_data = function (self, arg_18_1)
	-- function 18
	if not self._matchmaking_session_id then
		fn("Failed to fetch matchmaking session data. Reason: missing matchmaking_session_id")

		if not arg_18_1 then
			arg_18_1(false, 404)
		end

		return false
	end

	local get_matchmaking_url = self:get_matchmaking_url()
	local format = string.format("%s/matchmaking/sessions/%s", get_matchmaking_url, self._matchmaking_session_id)
	local var_18_2 = callback(self, "_fetch_matchmaking_session_data_cb", arg_18_1)

	Managers.curl:get(format, tbl_3, var_18_2)
end

BackendInterfaceVersusPlayFab._fetch_matchmaking_session_data_cb = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	local var_19_0 = fn_3(arg_19_5)

	if not var_19_0.debug_msg then
		Managers.chat:add_local_system_message(1, var_19_0.debug_msg, true)
	end

	if not (not arg_19_2 and arg_19_3 == 200) then
		fn_2(var_19_0, arg_19_3, "Failed to fetch matchmaking session data. result: %s", tostring(arg_19_2))
		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Failed to fetch matchmaking session data")

		if not arg_19_1 then
			arg_19_1(arg_19_2, arg_19_3, arg_19_4, nil)
		end

		return
	end

	if var_19_0.status ~= self._matchmaking_status then
		fn("Matchmaking session data fetched. matchmakingSessionId: %s, status: %s", var_19_0.matchmakingSessionId, var_19_0.status)

		self._matchmaking_status = var_19_0.status
	end

	if var_19_0.status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.Succeeded then
		self._is_matchmaking = false
	elseif var_19_0.status == scripts_managers_backend_playfab_settings_flexmatch_queue_status.Failed then
		fn_2(var_19_0, arg_19_3, "Matchmaking changed to unwanted status '%s'. result: %s", var_19_0.status, tostring(arg_19_2))
		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Matchmaking changed to unwanted status '%s'", var_19_0.status)
	end

	if not arg_19_1 then
		arg_19_1(arg_19_2, arg_19_3, arg_19_4, var_19_0)
	end
end

BackendInterfaceVersusPlayFab.is_matchmaking = function (self)
	-- function 20
	return self._is_matchmaking
end

BackendInterfaceVersusPlayFab.request_matchmaking_ticket = function (self, arg_21_1, arg_21_2)
	-- function 21
	fn("Requesting matchmaking ticket")
	fassert(arg_21_2 ~= nil, "request_matchmaking_ticket is missing external_cb")

	local tbl = {
		FunctionName = "getMatchmakingQueueTicket",
		FunctionParameter = {
			alias_type = "mission",
			matchmaking_type = "quickplay",
			peer_id = Steam.user_id(),
			latency_list = arg_21_1,
			network_hash = LobbySetup.network_hash()
		}
	}
	local var_21_1 = callback(self, "request_matchmaking_ticket_cb", arg_21_2)

	self._backend_mirror:request_queue():enqueue(tbl, var_21_1, true)
end

BackendInterfaceVersusPlayFab.request_matchmaking_ticket_cb = function (self, arg_22_1, arg_22_2)
	-- function 22
	fn("Matchmaking ticket response")

	local FunctionResult = arg_22_2.FunctionResult

	if not FunctionResult.ticket then
		self._base_url = FunctionResult.url
	else
		if type(FunctionResult) == "table" then
			table.dump(FunctionResult, "BackendInterfaceVersusPlayFab", 5)
		else
			print("getMatchmakingQueueTicket result: %s", tostring(FunctionResult))
		end

		Crashify.print_exception("BackendInterfaceVersusPlayFab", "Failed to get matchmaking queue ticket")
	end

	arg_22_1(FunctionResult)
end

BackendInterfaceVersusPlayFab.reset_fetched_data = function (self)
	-- function 23
	assert(DEDICATED_SERVER, "Dedicated server function only")

	self._matchmaking_session_id = false
	self._game_session_data = nil
	self._game_session_id = nil
end

BackendInterfaceVersusPlayFab.get_game_session_data = function (self)
	-- function 24
	return self._game_session_data
end

BackendInterfaceVersusPlayFab.set_matchmaking_session_id = function (self, arg_25_1)
	-- function 25
	assert(not DEDICATED_SERVER, "player function only")

	self._matchmaking_session_id = arg_25_1
	self._is_matchmaking = arg_25_1 ~= nil
end

BackendInterfaceVersusPlayFab.get_matchmaking_session_id = function (self)
	-- function 26
	return self._matchmaking_session_id
end

BackendInterfaceVersusPlayFab.is_player_in_backfilling_data = function (self, arg_27_1)
	-- function 27
	return table.contains(self._backfilling_player_ids, arg_27_1)
end

BackendInterfaceVersusPlayFab.matchmaking_enabled = function (arg_28_0, arg_28_1)
	-- function 28
	local get_title_settings = Managers.backend:get_title_settings()
	local versus = get_title_settings.versus

	versus = not versus and get_title_settings.versus.matchmaking_settings

	if not versus then
		return true
	end

	local var_28_2 = versus[arg_28_1]

	if not var_28_2 then
		return true
	end

	local enabled = var_28_2.enabled

	if enabled == nil then
		return true
	end

	local disabled_reason = var_28_2.disabled_reason

	return enabled, disabled_reason
end
