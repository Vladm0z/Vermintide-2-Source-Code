-- chunkname: @scripts/managers/backend_playfab/backend_interface_live_events_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceLiveEventsPlayfab = class(BackendInterfaceLiveEventsPlayfab)

BackendInterfaceLiveEventsPlayfab.init = function (self, arg_1_1)
	-- function 1
	self.is_local = false
	self._backend_mirror = arg_1_1
	self._last_id = 0
	self._completed_live_event_requests = {}
	self._live_events = nil

	self:_refresh()
end

BackendInterfaceLiveEventsPlayfab._refresh = function (self)
	-- function 2
	local backend = Managers.backend
	local get_title_data = backend:get_title_data("live_events_v2")

	get_title_data = get_title_data or backend:get_title_data("live_events")

	local decode

	if not get_title_data then
		decode = cjson.decode(get_title_data)

		if not decode then
			-- Nothing
		end
	end

	decode = {}

	::label_2_0::

	if not is_array(decode) then
		self._live_events = {
			weekly_events = decode
		}
	else
		self._live_events = decode
	end

	local decode_2 = cjson.decode
	local get_read_only_data = self._backend_mirror:get_read_only_data("weekly_event_rewards")

	get_read_only_data = get_read_only_data or "{}"
	self._weekly_event_rewards = decode_2(get_read_only_data)
	self._dirty = false
end

BackendInterfaceLiveEventsPlayfab.ready = function (self)
	-- function 3
	return self._live_events ~= nil
end

BackendInterfaceLiveEventsPlayfab.update = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

BackendInterfaceLiveEventsPlayfab.make_dirty = function (self)
	-- function 5
	self._dirty = true
end

BackendInterfaceLiveEventsPlayfab._new_id = function (self)
	-- function 6
	self._last_id = self._last_id + 1

	return self._last_id
end

BackendInterfaceLiveEventsPlayfab.request_live_events = function (self, arg_7_1)
	-- function 7
	local _new_id = self:_new_id()
	local tbl = {
		FunctionName = "getLiveEvents",
		FunctionParameter = {
			id = _new_id
		}
	}
	local var_7_2 = callback(self, "request_live_events_cb", _new_id, arg_7_1)

	self._backend_mirror:request_queue():enqueue(tbl, var_7_2, false)

	return _new_id
end

BackendInterfaceLiveEventsPlayfab.request_live_events_cb = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local FunctionResult = arg_8_3.FunctionResult
	local live_events = FunctionResult.live_events

	self._backend_mirror:set_title_data("live_events_v2", live_events)
	self:_refresh()

	self._completed_live_event_requests[arg_8_1] = true

	if not arg_8_2 then
		arg_8_2(FunctionResult)
	end
end

BackendInterfaceLiveEventsPlayfab.request_weekly_event_rewards = function (self, arg_9_1)
	-- function 9
	local _new_id = self:_new_id()
	local tbl = {
		FunctionName = "getWeeklyEventRewards",
		FunctionParameter = {
			id = _new_id
		}
	}
	local var_9_2 = callback(self, "request_weekly_event_rewards_cb", _new_id, arg_9_1)

	self._backend_mirror:request_queue():enqueue(tbl, var_9_2, false)

	return _new_id
end

BackendInterfaceLiveEventsPlayfab.request_weekly_event_rewards_cb = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local FunctionResult = arg_10_3.FunctionResult
	local data = FunctionResult.data

	self._backend_mirror:set_read_only_data("weekly_event_rewards", cjson.encode(data), true)
	self:_refresh()

	self._completed_live_event_requests[arg_10_1] = true

	if not arg_10_2 then
		arg_10_2(FunctionResult)
	end
end

BackendInterfaceLiveEventsPlayfab.live_events_request_complete = function (self, arg_11_1)
	-- function 11
	return self._completed_live_event_requests[arg_11_1]
end

BackendInterfaceLiveEventsPlayfab.get_weekly_events = function (self)
	-- function 12
	if not self._dirty then
		self:_refresh()
	end

	return self._live_events.weekly_events
end

BackendInterfaceLiveEventsPlayfab.get_special_events = function (self)
	-- function 13
	if not self._dirty then
		self:_refresh()
	end

	return self._live_events.special_events
end

BackendInterfaceLiveEventsPlayfab.get_active_events = function (self)
	-- function 14
	if not self._dirty then
		self:_refresh()
	end

	return self._live_events.active_events
end

BackendInterfaceLiveEventsPlayfab.get_weekly_events_game_mode_data = function (self)
	-- function 15
	if not self._dirty then
		self:_refresh()
	end

	local weekly_events = self._live_events.weekly_events

	for i = 1, #weekly_events do
		local var_15_1 = weekly_events[i]

		if not var_15_1.game_mode_data then
			return var_15_1.game_mode_data
		end
	end
end

local tbl = {}

BackendInterfaceLiveEventsPlayfab.get_weekly_chaos_wastes_game_mode_data = function (self)
	-- function 16
	if not self._dirty then
		self:_refresh()
	end

	local weekly_chaos_wastes = self._live_events.weekly_chaos_wastes

	weekly_chaos_wastes = weekly_chaos_wastes or tbl

	for i = 1, #weekly_chaos_wastes do
		local var_16_1 = weekly_chaos_wastes[i]

		if not var_16_1.game_mode_data then
			return var_16_1.game_mode_data, var_16_1.information
		end
	end

	return tbl, tbl
end

BackendInterfaceLiveEventsPlayfab.get_weekly_chaos_wastes_rewards_data = function (self)
	-- function 17
	if not self._dirty then
		self:_refresh()
	end

	local deus = self._weekly_event_rewards.deus

	if not deus then
		return tbl
	end

	return deus.data
end

BackendInterfaceLiveEventsPlayfab.request_twitch_app_access_token = function (self, arg_18_1)
	-- function 18
	local tbl = {
		FunctionName = "getTwitchAccessToken",
		FunctionParameter = {
			force = true
		}
	}
	local var_18_1 = callback(self, "_request_twitch_app_access_token_cb", arg_18_1)

	self._backend_mirror:request_queue():enqueue(tbl, var_18_1, false)
end

BackendInterfaceLiveEventsPlayfab._request_twitch_app_access_token_cb = function (self, arg_19_1, arg_19_2)
	-- function 19
	local access_token = arg_19_2.FunctionResult.access_token

	if not access_token then
		self._backend_mirror:set_twitch_app_access_token(access_token)
	end

	if not arg_19_1 then
		arg_19_1(access_token)
	end
end
