-- chunkname: @scripts/managers/badge/badge_manager.lua

require("scripts/settings/badge_templates")

BadgeManager = class(BadgeManager)

local var_0_0 = {
	"rpc_show_badge",
	"rpc_complete_badge"
}

function BadgeManager.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._statistics_db = arg_1_1
	arg_1_0._is_server = arg_1_3
	arg_1_0._registered_events = {}
	arg_1_0.network_event_delegate = arg_1_2

	arg_1_2:register(arg_1_0, unpack(var_0_0))

	local var_1_0 = Managers.mechanism:current_mechanism_name()

	if var_1_0 == "versus" then
		require("scripts/settings/dlcs/carousel/carousel_badge_templates")
	elseif var_1_0 == "adventure" then
		-- block empty
	end

	if arg_1_3 then
		arg_1_0:_initialize_server()
	else
		arg_1_0:_initialize_client()
	end
end

function BadgeManager._initialize_server(arg_2_0)
	local var_2_0 = BadgeTemplates.server
	local var_2_1 = {}
	local var_2_2 = arg_2_0._statistics_db
	local var_2_3 = Managers.state.event
	local var_2_4 = Managers.state.network.network_transmit

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		local var_2_5 = iter_2_1.events or {}

		for iter_2_2, iter_2_3 in pairs(var_2_5) do
			local var_2_6 = {
				callback_function = function(arg_3_0, ...)
					local var_3_0 = Managers.time:time("main")
					local var_3_1 = iter_2_1.settings
					local var_3_2 = iter_2_1.data

					if iter_2_3(var_3_1, var_3_2, var_3_0, ...) then
						local var_3_3, var_3_4 = iter_2_1.complete(var_2_2, var_3_1, var_3_2, ...)

						if var_3_3 and var_3_4 then
							var_2_4:send_rpc("rpc_show_badge", var_3_3, var_3_4)
						end
					end
				end
			}

			arg_2_0._registered_events[#arg_2_0._registered_events + 1] = var_2_6

			var_2_3:register(var_2_6, iter_2_2, "callback_function")
		end

		if iter_2_1.update then
			var_2_1[#var_2_1 + 1] = iter_2_1
		end
	end

	arg_2_0._templates = var_2_0
	arg_2_0._update_cache = var_2_1
end

function BadgeManager._initialize_client(arg_4_0)
	local var_4_0 = BadgeTemplates.client
	local var_4_1 = {}
	local var_4_2 = arg_4_0._statistics_db
	local var_4_3 = Managers.state.event
	local var_4_4 = Managers.state.network.network_transmit

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		local var_4_5 = iter_4_1.events or {}

		for iter_4_2, iter_4_3 in pairs(var_4_5) do
			local var_4_6 = {
				callback_function = function(arg_5_0, ...)
					local var_5_0 = Managers.time:time("main")
					local var_5_1 = iter_4_1.settings
					local var_5_2 = iter_4_1.data

					if iter_4_3(var_5_1, var_5_2, var_5_0, ...) then
						local var_5_3, var_5_4 = iter_4_1.complete(var_4_2, var_5_1, var_5_2, ...)

						if var_5_3 and var_5_4 then
							var_4_4:send_rpc_server("rpc_complete_badge", var_5_4, var_5_3)
						end
					end
				end
			}

			arg_4_0._registered_events[#arg_4_0._registered_events + 1] = var_4_6

			var_4_3:register(var_4_6, iter_4_2, "callback_function")
		end

		if iter_4_1.update then
			var_4_1[#var_4_1 + 1] = iter_4_1
		end
	end

	arg_4_0._templates = var_4_0
	arg_4_0._update_cache = var_4_1
end

function BadgeManager.destroy(arg_6_0)
	arg_6_0.network_event_delegate:unregister(arg_6_0)

	for iter_6_0, iter_6_1 in pairs(arg_6_0._templates) do
		table.clear(iter_6_1.data)
	end

	for iter_6_2, iter_6_3 in ipairs(arg_6_0._registered_events) do
		arg_6_0.network_event_delegate:unregister(iter_6_3)
	end
end

function BadgeManager.update(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0._is_server then
		arg_7_0:_update_server(arg_7_1, arg_7_2)
	else
		arg_7_0:_update_client(arg_7_1, arg_7_2)
	end
end

function BadgeManager._update_server(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._update_cache
	local var_8_1 = Managers.state.network.network_transmit

	for iter_8_0, iter_8_1 in ipairs(var_8_0) do
		local var_8_2 = iter_8_1.settings
		local var_8_3 = iter_8_1.data
		local var_8_4 = iter_8_1.update(var_8_2, var_8_3, arg_8_1, arg_8_2)

		if var_8_4 and #var_8_4 > 0 then
			for iter_8_2, iter_8_3 in ipairs(var_8_4) do
				local var_8_5, var_8_6 = iter_8_1.complete(arg_8_0._statistics_db, iter_8_1.settings, iter_8_1.data, iter_8_3)

				if var_8_5 and var_8_6 then
					var_8_1:send_rpc("rpc_show_badge", var_8_5, var_8_6)
				end
			end
		end
	end
end

function BadgeManager._update_client(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._update_cache
	local var_9_1 = Managers.state.network.network_transmit

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		local var_9_2 = iter_9_1.settings
		local var_9_3 = iter_9_1.data
		local var_9_4 = iter_9_1.update(var_9_2, var_9_3, arg_9_1, arg_9_2)

		if var_9_4 and #var_9_4 > 0 then
			for iter_9_2, iter_9_3 in ipairs(var_9_4) do
				local var_9_5, var_9_6 = iter_9_1.complete(arg_9_0._statistics_db, iter_9_1.settings, iter_9_1.data, iter_9_3)

				if var_9_5 and var_9_6 then
					var_9_1:send_rpc_server("rpc_complete_badge", var_9_6, var_9_5)
				end
			end
		end
	end
end

function BadgeManager.rpc_show_badge(arg_10_0, arg_10_1, arg_10_2)
	Managers.telemetry_events:badge_gained(NetworkLookup.badges[arg_10_2])
	Managers.state.event:trigger("add_local_badge", arg_10_2)
end

function BadgeManager.rpc_complete_badge(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	fassert(arg_11_0._is_server, "Only server should get this")
	Managers.state.network.network_transmit:send_rpc("rpc_show_badge", arg_11_3, arg_11_2)
end
