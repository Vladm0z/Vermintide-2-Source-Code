-- chunkname: @scripts/managers/backend_playfab/backend_interface_live_events_playfab.lua

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceLiveEventsPlayfab = class(BackendInterfaceLiveEventsPlayfab)

BackendInterfaceLiveEventsPlayfab.init = function (arg_1_0, arg_1_1)
	arg_1_0.is_local = false
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._last_id = 0
	arg_1_0._completed_live_event_requests = {}
	arg_1_0._live_events = nil

	arg_1_0:_refresh()
end

BackendInterfaceLiveEventsPlayfab._refresh = function (arg_2_0)
	local var_2_0 = Managers.backend
	local var_2_1 = var_2_0:get_title_data("live_events_v2") or var_2_0:get_title_data("live_events")
	local var_2_2 = var_2_1 and cjson.decode(var_2_1) or {}

	if is_array(var_2_2) then
		arg_2_0._live_events = {
			weekly_events = var_2_2
		}
	else
		arg_2_0._live_events = var_2_2
	end

	arg_2_0._weekly_event_rewards = cjson.decode(arg_2_0._backend_mirror:get_read_only_data("weekly_event_rewards") or "{}")
	arg_2_0._dirty = false
end

BackendInterfaceLiveEventsPlayfab.ready = function (arg_3_0)
	return arg_3_0._live_events ~= nil
end

BackendInterfaceLiveEventsPlayfab.update = function (arg_4_0, arg_4_1)
	return
end

BackendInterfaceLiveEventsPlayfab.make_dirty = function (arg_5_0)
	arg_5_0._dirty = true
end

BackendInterfaceLiveEventsPlayfab._new_id = function (arg_6_0)
	arg_6_0._last_id = arg_6_0._last_id + 1

	return arg_6_0._last_id
end

BackendInterfaceLiveEventsPlayfab.request_live_events = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0:_new_id()
	local var_7_1 = {
		FunctionName = "getLiveEvents",
		FunctionParameter = {
			id = var_7_0
		}
	}
	local var_7_2 = callback(arg_7_0, "request_live_events_cb", var_7_0, arg_7_1)

	arg_7_0._backend_mirror:request_queue():enqueue(var_7_1, var_7_2, false)

	return var_7_0
end

BackendInterfaceLiveEventsPlayfab.request_live_events_cb = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_3.FunctionResult
	local var_8_1 = var_8_0.live_events

	arg_8_0._backend_mirror:set_title_data("live_events_v2", var_8_1)
	arg_8_0:_refresh()

	arg_8_0._completed_live_event_requests[arg_8_1] = true

	if arg_8_2 then
		arg_8_2(var_8_0)
	end
end

BackendInterfaceLiveEventsPlayfab.request_weekly_event_rewards = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:_new_id()
	local var_9_1 = {
		FunctionName = "getWeeklyEventRewards",
		FunctionParameter = {
			id = var_9_0
		}
	}
	local var_9_2 = callback(arg_9_0, "request_weekly_event_rewards_cb", var_9_0, arg_9_1)

	arg_9_0._backend_mirror:request_queue():enqueue(var_9_1, var_9_2, false)

	return var_9_0
end

BackendInterfaceLiveEventsPlayfab.request_weekly_event_rewards_cb = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_3.FunctionResult
	local var_10_1 = var_10_0.data

	arg_10_0._backend_mirror:set_read_only_data("weekly_event_rewards", cjson.encode(var_10_1), true)
	arg_10_0:_refresh()

	arg_10_0._completed_live_event_requests[arg_10_1] = true

	if arg_10_2 then
		arg_10_2(var_10_0)
	end
end

BackendInterfaceLiveEventsPlayfab.live_events_request_complete = function (arg_11_0, arg_11_1)
	return arg_11_0._completed_live_event_requests[arg_11_1]
end

BackendInterfaceLiveEventsPlayfab.get_weekly_events = function (arg_12_0)
	if arg_12_0._dirty then
		arg_12_0:_refresh()
	end

	return arg_12_0._live_events.weekly_events
end

BackendInterfaceLiveEventsPlayfab.get_special_events = function (arg_13_0)
	if arg_13_0._dirty then
		arg_13_0:_refresh()
	end

	return arg_13_0._live_events.special_events
end

BackendInterfaceLiveEventsPlayfab.get_active_events = function (arg_14_0)
	if arg_14_0._dirty then
		arg_14_0:_refresh()
	end

	return arg_14_0._live_events.active_events
end

BackendInterfaceLiveEventsPlayfab.get_weekly_events_game_mode_data = function (arg_15_0)
	if arg_15_0._dirty then
		arg_15_0:_refresh()
	end

	local var_15_0 = arg_15_0._live_events.weekly_events

	for iter_15_0 = 1, #var_15_0 do
		local var_15_1 = var_15_0[iter_15_0]

		if var_15_1.game_mode_data then
			return var_15_1.game_mode_data
		end
	end
end

local var_0_1 = {}

BackendInterfaceLiveEventsPlayfab.get_weekly_chaos_wastes_game_mode_data = function (arg_16_0)
	if arg_16_0._dirty then
		arg_16_0:_refresh()
	end

	local var_16_0 = arg_16_0._live_events.weekly_chaos_wastes or var_0_1

	for iter_16_0 = 1, #var_16_0 do
		local var_16_1 = var_16_0[iter_16_0]

		if var_16_1.game_mode_data then
			return var_16_1.game_mode_data, var_16_1.information
		end
	end

	return var_0_1, var_0_1
end

BackendInterfaceLiveEventsPlayfab.get_weekly_chaos_wastes_rewards_data = function (arg_17_0)
	if arg_17_0._dirty then
		arg_17_0:_refresh()
	end

	local var_17_0 = arg_17_0._weekly_event_rewards.deus

	if not var_17_0 then
		return var_0_1
	end

	return var_17_0.data
end

BackendInterfaceLiveEventsPlayfab.request_twitch_app_access_token = function (arg_18_0, arg_18_1)
	local var_18_0 = {
		FunctionName = "getTwitchAccessToken",
		FunctionParameter = {
			force = true
		}
	}
	local var_18_1 = callback(arg_18_0, "_request_twitch_app_access_token_cb", arg_18_1)

	arg_18_0._backend_mirror:request_queue():enqueue(var_18_0, var_18_1, false)
end

BackendInterfaceLiveEventsPlayfab._request_twitch_app_access_token_cb = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2.FunctionResult.access_token

	if var_19_0 then
		arg_19_0._backend_mirror:set_twitch_app_access_token(var_19_0)
	end

	if arg_19_1 then
		arg_19_1(var_19_0)
	end
end
