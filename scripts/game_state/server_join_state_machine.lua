-- chunkname: @scripts/game_state/server_join_state_machine.lua

local var_0_0 = class(FindServerState)

var_0_0.NAME = "FindServerState"

var_0_0.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	print("Attempting " .. arg_1_2 .. " search for game server " .. arg_1_4)
	assert(arg_1_2 == "internet" or arg_1_2 == "lan")

	arg_1_0._search_type = arg_1_2
	arg_1_0._network_options = arg_1_3
	arg_1_0._ip_port = arg_1_4
end

var_0_0.enter = function (arg_2_0)
	arg_2_0._finder = GameServerFinder:new(arg_2_0._network_options)

	arg_2_0._finder:set_search_type(arg_2_0._search_type)

	local var_2_0 = {
		server_browser_filters = {
			dedicated = "valuenotused",
			gamedir = Managers.mechanism:server_universe()
		},
		matchmaking_filters = {}
	}
	local var_2_1 = true

	arg_2_0._finder:add_filter_requirements(var_2_0, var_2_1)
	arg_2_0._finder:refresh()
end

var_0_0.destroy = function (arg_3_0)
	arg_3_0._finder:destroy()

	arg_3_0._finder = nil
end

var_0_0.update = function (arg_4_0, arg_4_1)
	arg_4_0._finder:update(arg_4_1)

	if arg_4_0._finder:is_refreshing() then
		return
	end

	local var_4_0 = arg_4_0._finder:servers()

	for iter_4_0, iter_4_1 in ipairs(var_4_0) do
		if iter_4_1.server_info.ip_port == arg_4_0._ip_port then
			print("Found server " .. arg_4_0._ip_port)

			if iter_4_1.server_info.password then
				return "password_required"
			else
				local var_4_1 = ""

				return "password_not_required", var_4_1
			end
		end
	end

	print("Server not found")

	return "server_not_found"
end

local var_0_1 = class(FindServerLANState, var_0_0)

var_0_1.NAME = "FindServerLANState"

var_0_1.init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0.super.init(arg_5_0, arg_5_1, "lan", arg_5_2, arg_5_3)
end

local var_0_2 = class(FindServerInternetState, var_0_0)

var_0_2.NAME = "FindServerInternetState"

var_0_2.init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.super.init(arg_6_0, arg_6_1, "internet", arg_6_2, arg_6_3)
end

local var_0_3 = class(PasswordDialogState)

var_0_3.NAME = "PasswordDialogState"

var_0_3.init = function (arg_7_0, arg_7_1)
	arg_7_0._popup_id = Managers.popup:queue_password_popup(Localize("lb_password"), Localize("lb_password_protected"), "ok", Localize("lb_ok"), "cancel", Localize("lb_cancel"))
end

var_0_3.destroy = function (arg_8_0)
	Managers.popup:cancel_popup(arg_8_0._popup_id)

	arg_8_0._popup_id = nil
end

var_0_3.update = function (arg_9_0)
	local var_9_0, var_9_1 = Managers.popup:query_result(arg_9_0._popup_id)

	if var_9_0 then
		if var_9_0 == "ok" then
			local var_9_2 = var_9_1.input

			return "password_entered", var_9_2
		else
			return "password_cancelled"
		end
	end
end

local var_0_4 = class(ServerJoinState)

var_0_4.NAME = "ServerJoinState"

var_0_4.init = function (arg_10_0, arg_10_1)
	arg_10_0._sm = arg_10_1
end

var_0_4.enter = function (arg_11_0, arg_11_1)
	arg_11_0._sm._action = "join"
	arg_11_0._sm._password = arg_11_1
end

local var_0_5 = class(AbortState)

var_0_5.NAME = "AbortState"

var_0_5.init = function (arg_12_0, arg_12_1)
	arg_12_1._action = "cancel"
	arg_12_1._password = ""
end

ServerJoinStateMachine = class(ServerJoinStateMachine, VisualStateMachine)

ServerJoinStateMachine.init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0

	arg_13_0.super.init(arg_13_0, "ServerJoinStateMachine", var_13_0, arg_13_1, arg_13_2)

	arg_13_0._has_result = false
	arg_13_0._server_data = nil
	arg_13_0._ip_port = arg_13_2
	arg_13_0._user_data = arg_13_3
	arg_13_0._action = nil
	arg_13_0._password = nil

	arg_13_0:add_transition("FindServerInternetState", "password_required", var_0_3)
	arg_13_0:add_transition("FindServerInternetState", "password_not_required", var_0_4)
	arg_13_0:add_transition("FindServerInternetState", "server_not_found", var_0_1)
	arg_13_0:add_transition("FindServerLANState", "password_required", var_0_3)
	arg_13_0:add_transition("FindServerLANState", "password_not_required", var_0_4)
	arg_13_0:add_transition("FindServerLANState", "server_not_found", var_0_3)
	arg_13_0:add_transition("PasswordDialogState", "password_entered", var_0_4)
	arg_13_0:add_transition("PasswordDialogState", "password_cancelled", var_0_5)
	arg_13_0:set_initial_state(var_0_2)
end

ServerJoinStateMachine.result = function (arg_14_0)
	if arg_14_0._action == nil then
		return
	end

	return arg_14_0._action, arg_14_0._user_data, arg_14_0._password
end
