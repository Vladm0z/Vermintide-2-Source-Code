-- chunkname: @scripts/game_state/server_join_state_machine.lua

local var_0_0 = class(FindServerState)

var_0_0.NAME = "FindServerState"

var_0_0.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	print("Attempting " .. arg_1_2 .. " search for game server " .. arg_1_4)
	assert(arg_1_2 == "internet" or arg_1_2 == "lan")

	self._search_type = arg_1_2
	self._network_options = arg_1_3
	self._ip_port = arg_1_4
end

var_0_0.enter = function (self)
	-- function 2
	self._finder = GameServerFinder:new(self._network_options)

	self._finder:set_search_type(self._search_type)

	local tbl = {
		server_browser_filters = {
			dedicated = "valuenotused",
			gamedir = Managers.mechanism:server_universe()
		},
		matchmaking_filters = {}
	}
	local flag = true

	self._finder:add_filter_requirements(tbl, flag)
	self._finder:refresh()
end

var_0_0.destroy = function (self)
	-- function 3
	self._finder:destroy()

	self._finder = nil
end

var_0_0.update = function (self, arg_4_1)
	-- function 4
	self._finder:update(arg_4_1)

	if not self._finder:is_refreshing() then
		return
	end

	local servers = self._finder:servers()

	for i, v in ipairs(servers) do
		if v.server_info.ip_port == self._ip_port then
			print("Found server " .. self._ip_port)

			if not v.server_info.password then
				return "password_required"
			else
				local str = ""

				return "password_not_required", str
			end
		end
	end

	print("Server not found")

	return "server_not_found"
end

local var_0_1 = class(FindServerLANState, var_0_0)

var_0_1.NAME = "FindServerLANState"

var_0_1.init = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	self.super.init(self, arg_5_1, "lan", arg_5_2, arg_5_3)
end

local var_0_2 = class(FindServerInternetState, var_0_0)

var_0_2.NAME = "FindServerInternetState"

var_0_2.init = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	self.super.init(self, arg_6_1, "internet", arg_6_2, arg_6_3)
end

local var_0_3 = class(PasswordDialogState)

var_0_3.NAME = "PasswordDialogState"

var_0_3.init = function (self, arg_7_1)
	-- function 7
	self._popup_id = Managers.popup:queue_password_popup(Localize("lb_password"), Localize("lb_password_protected"), "ok", Localize("lb_ok"), "cancel", Localize("lb_cancel"))
end

var_0_3.destroy = function (self)
	-- function 8
	Managers.popup:cancel_popup(self._popup_id)

	self._popup_id = nil
end

var_0_3.update = function (self)
	-- function 9
	local query_result, var_9_1 = Managers.popup:query_result(self._popup_id)

	if not query_result then
		if query_result == "ok" then
			local input = var_9_1.input

			return "password_entered", input
		else
			return "password_cancelled"
		end
	end
end

local var_0_4 = class(ServerJoinState)

var_0_4.NAME = "ServerJoinState"

var_0_4.init = function (self, arg_10_1)
	-- function 10
	self._sm = arg_10_1
end

var_0_4.enter = function (arg_11_0, arg_11_1)
	-- function 11
	arg_11_0._sm._action = "join"
	arg_11_0._sm._password = arg_11_1
end

local var_0_5 = class(AbortState)

var_0_5.NAME = "AbortState"

var_0_5.init = function (arg_12_0, arg_12_1)
	-- function 12
	arg_12_1._action = "cancel"
	arg_12_1._password = ""
end

ServerJoinStateMachine = class(ServerJoinStateMachine, VisualStateMachine)

ServerJoinStateMachine.init = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0

	self.super.init(self, "ServerJoinStateMachine", var_13_0, arg_13_1, arg_13_2)

	self._has_result = false
	self._server_data = nil
	self._ip_port = arg_13_2
	self._user_data = arg_13_3
	self._action = nil
	self._password = nil

	self:add_transition("FindServerInternetState", "password_required", var_0_3)
	self:add_transition("FindServerInternetState", "password_not_required", var_0_4)
	self:add_transition("FindServerInternetState", "server_not_found", var_0_1)
	self:add_transition("FindServerLANState", "password_required", var_0_3)
	self:add_transition("FindServerLANState", "password_not_required", var_0_4)
	self:add_transition("FindServerLANState", "server_not_found", var_0_3)
	self:add_transition("PasswordDialogState", "password_entered", var_0_4)
	self:add_transition("PasswordDialogState", "password_cancelled", var_0_5)
	self:set_initial_state(var_0_2)
end

ServerJoinStateMachine.result = function (self)
	-- function 14
	if self._action == nil then
		return
	end

	return self._action, self._user_data, self._password
end
