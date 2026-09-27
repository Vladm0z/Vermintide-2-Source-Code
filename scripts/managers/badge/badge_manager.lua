-- chunkname: @scripts/managers/badge/badge_manager.lua

require("scripts/settings/badge_templates")

BadgeManager = class(BadgeManager)

local tbl = {
	"rpc_show_badge",
	"rpc_complete_badge"
}

BadgeManager.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._statistics_db = arg_1_1
	self._is_server = arg_1_3
	self._registered_events = {}
	self.network_event_delegate = arg_1_2

	arg_1_2:register(self, unpack(tbl))

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	if current_mechanism_name == "versus" then
		require("scripts/settings/dlcs/carousel/carousel_badge_templates")
	elseif current_mechanism_name == "adventure" then
		-- Nothing
	end

	if not arg_1_3 then
		self:_initialize_server()
	else
		self:_initialize_client()
	end
end

BadgeManager._initialize_server = function (self)
	-- function 2
	local server = BadgeTemplates.server
	local tbl = {}
	local _statistics_db = self._statistics_db
	local event = Managers.state.event
	local network_transmit = Managers.state.network.network_transmit

	for k, v in pairs(server) do
		local events = v.events

		events = events or {}

		for k_2, v_2 in pairs(events) do
			local tbl_2 = {
				callback_function = function (arg_3_0, ...)
					-- function 3
					local time = Managers.time:time("main")
					local settings = v.settings
					local data = v.data

					if not v_2(settings, data, time, ...) then
						local complete, var_3_4 = v.complete(_statistics_db, settings, data, ...)

						if not complete and not var_3_4 then
							network_transmit:send_rpc("rpc_show_badge", complete, var_3_4)
						end
					end
				end
			}

			self._registered_events[#self._registered_events + 1] = tbl_2

			event:register(tbl_2, k_2, "callback_function")
		end

		if not v.update then
			tbl[#tbl + 1] = v
		end
	end

	self._templates = server
	self._update_cache = tbl
end

BadgeManager._initialize_client = function (self)
	-- function 4
	local client = BadgeTemplates.client
	local tbl = {}
	local _statistics_db = self._statistics_db
	local event = Managers.state.event
	local network_transmit = Managers.state.network.network_transmit

	for k, v in pairs(client) do
		local events = v.events

		events = events or {}

		for k_2, v_2 in pairs(events) do
			local tbl_2 = {
				callback_function = function (arg_5_0, ...)
					-- function 5
					local time = Managers.time:time("main")
					local settings = v.settings
					local data = v.data

					if not v_2(settings, data, time, ...) then
						local complete, var_5_4 = v.complete(_statistics_db, settings, data, ...)

						if not complete and not var_5_4 then
							network_transmit:send_rpc_server("rpc_complete_badge", var_5_4, complete)
						end
					end
				end
			}

			self._registered_events[#self._registered_events + 1] = tbl_2

			event:register(tbl_2, k_2, "callback_function")
		end

		if not v.update then
			tbl[#tbl + 1] = v
		end
	end

	self._templates = client
	self._update_cache = tbl
end

BadgeManager.destroy = function (self)
	-- function 6
	self.network_event_delegate:unregister(self)

	for k, v in pairs(self._templates) do
		table.clear(v.data)
	end

	for i, v_2 in ipairs(self._registered_events) do
		self.network_event_delegate:unregister(v_2)
	end
end

BadgeManager.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not self._is_server then
		self:_update_server(arg_7_1, arg_7_2)
	else
		self:_update_client(arg_7_1, arg_7_2)
	end
end

BadgeManager._update_server = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _update_cache = self._update_cache
	local network_transmit = Managers.state.network.network_transmit

	for i, v in ipairs(_update_cache) do
		local settings = v.settings
		local data = v.data
		local update = v.update(settings, data, arg_8_1, arg_8_2)

		if not (not update and not (#update > 0)) then
			for i_2, v_2 in ipairs(update) do
				local complete, var_8_6 = v.complete(self._statistics_db, v.settings, v.data, v_2)

				if not complete and not var_8_6 then
					network_transmit:send_rpc("rpc_show_badge", complete, var_8_6)
				end
			end
		end
	end
end

BadgeManager._update_client = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _update_cache = self._update_cache
	local network_transmit = Managers.state.network.network_transmit

	for i, v in ipairs(_update_cache) do
		local settings = v.settings
		local data = v.data
		local update = v.update(settings, data, arg_9_1, arg_9_2)

		if not (not update and not (#update > 0)) then
			for i_2, v_2 in ipairs(update) do
				local complete, var_9_6 = v.complete(self._statistics_db, v.settings, v.data, v_2)

				if not complete and not var_9_6 then
					network_transmit:send_rpc_server("rpc_complete_badge", var_9_6, complete)
				end
			end
		end
	end
end

BadgeManager.rpc_show_badge = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	Managers.telemetry_events:badge_gained(NetworkLookup.badges[arg_10_2])
	Managers.state.event:trigger("add_local_badge", arg_10_2)
end

BadgeManager.rpc_complete_badge = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	fassert(self._is_server, "Only server should get this")
	Managers.state.network.network_transmit:send_rpc("rpc_show_badge", arg_11_3, arg_11_2)
end
