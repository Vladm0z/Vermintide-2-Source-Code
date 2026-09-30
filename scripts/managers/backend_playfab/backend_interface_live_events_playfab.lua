-- chunkname: @scripts/managers/backend_playfab/backend_interface_live_events_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceLiveEventsPlayfab = class(BackendInterfaceLiveEventsPlayfab)

BackendInterfaceLiveEventsPlayfab.init = function (self, backend_mirror)
	-- function 1
	self.is_local = false
	self._backend_mirror = backend_mirror
	self._last_id = 0
	self._completed_live_event_requests = {}
	self._live_events = nil

	self:_refresh()
end

BackendInterfaceLiveEventsPlayfab._refresh = function (self)
	-- function 2
	local backend_manager = Managers.backend
	local live_events_string = backend_manager:get_title_data("live_events_v2")
	local live_events = live_events_string and cjson.decode(live_events_string) or not live_events_string and {}

	if is_array(live_events) then
		self._live_events = {
			weekly_events = live_events
		}
	else
		self._live_events = live_events
	end

	self._weekly_event_rewards = cjson.decode((self._backend_mirror:get_read_only_data("weekly_event_rewards")))
	self._dirty = false
end

BackendInterfaceLiveEventsPlayfab.ready = function (self)
	-- function 3
	return self._live_events ~= nil
end

BackendInterfaceLiveEventsPlayfab.update = function (self, dt)
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

BackendInterfaceLiveEventsPlayfab.request_live_events = function (self, cb)
	-- function 7
	local id = self:_new_id()
	local request = {
		FunctionName = "getLiveEvents",
		FunctionParameter = {
			id = id
		}
	}
	local success_callback = callback(self, "request_live_events_cb", id, cb)
	local request_queue = self._backend_mirror:request_queue()

	request_queue:enqueue(request, success_callback, false)

	return id
end

BackendInterfaceLiveEventsPlayfab.request_live_events_cb = function (self, id, cb, result)
	-- function 8
	local function_result = result.FunctionResult
	local live_events_json = function_result.live_events

	self._backend_mirror:set_title_data("live_events_v2", live_events_json)
	self:_refresh()

	self._completed_live_event_requests[id] = true

	if cb then
		cb(function_result)
	end
end

BackendInterfaceLiveEventsPlayfab.request_weekly_event_rewards = function (self, cb)
	-- function 9
	local id = self:_new_id()
	local request = {
		FunctionName = "getWeeklyEventRewards",
		FunctionParameter = {
			id = id
		}
	}
	local success_callback = callback(self, "request_weekly_event_rewards_cb", id, cb)
	local request_queue = self._backend_mirror:request_queue()

	request_queue:enqueue(request, success_callback, false)

	return id
end

BackendInterfaceLiveEventsPlayfab.request_weekly_event_rewards_cb = function (self, id, cb, result)
	-- function 10
	local function_result = result.FunctionResult
	local weekly_event_rewards = function_result.data

	self._backend_mirror:set_read_only_data("weekly_event_rewards", cjson.encode(weekly_event_rewards), true)
	self:_refresh()

	self._completed_live_event_requests[id] = true

	if cb then
		cb(function_result)
	end
end

BackendInterfaceLiveEventsPlayfab.live_events_request_complete = function (self, id)
	-- function 11
	local complete = self._completed_live_event_requests[id]

	return complete
end

BackendInterfaceLiveEventsPlayfab.get_weekly_events = function (self)
	-- function 12
	if self._dirty then
		self:_refresh()
	end

	return self._live_events.weekly_events
end

BackendInterfaceLiveEventsPlayfab.get_special_events = function (self)
	-- function 13
	if self._dirty then
		self:_refresh()
	end

	return self._live_events.special_events
end

BackendInterfaceLiveEventsPlayfab.get_active_events = function (self)
	-- function 14
	if self._dirty then
		self:_refresh()
	end

	return self._live_events.active_events
end

BackendInterfaceLiveEventsPlayfab.get_weekly_events_game_mode_data = function (self)
	-- function 15
	if self._dirty then
		self:_refresh()
	end

	local weekly_event_data = self._live_events.weekly_events

	for i = 1, #weekly_event_data do
		local event = weekly_event_data[i]

		if event.game_mode_data then
			return event.game_mode_data
		end
	end
end

local EMPTY_TABLE = {}

BackendInterfaceLiveEventsPlayfab.get_weekly_chaos_wastes_game_mode_data = function (self)
	-- function 16
	if self._dirty then
		self:_refresh()
	end

	local weekly_event_data = self._live_events.weekly_chaos_wastes

	for i = 1, #weekly_event_data do
		local event = weekly_event_data[i]

		if event.game_mode_data then
			return event.game_mode_data, event.information
		end
	end

	return EMPTY_TABLE, EMPTY_TABLE
end

BackendInterfaceLiveEventsPlayfab.get_weekly_chaos_wastes_rewards_data = function (self)
	-- function 17
	if self._dirty then
		self:_refresh()
	end

	local deus = self._weekly_event_rewards.deus

	if not deus then
		return EMPTY_TABLE
	end

	return deus.data
end

BackendInterfaceLiveEventsPlayfab.request_twitch_app_access_token = function (self, cb)
	-- function 18
	local request = {
		FunctionName = "getTwitchAccessToken",
		FunctionParameter = {
			force = true
		}
	}
	local success_callback = callback(self, "_request_twitch_app_access_token_cb", cb)
	local request_queue = self._backend_mirror:request_queue()

	request_queue:enqueue(request, success_callback, false)
end

BackendInterfaceLiveEventsPlayfab._request_twitch_app_access_token_cb = function (self, cb, result)
	-- function 19
	local function_result = result.FunctionResult
	local access_token = function_result.access_token

	if access_token then
		self._backend_mirror:set_twitch_app_access_token(access_token)
	end

	if cb then
		cb(access_token)
	end
end
