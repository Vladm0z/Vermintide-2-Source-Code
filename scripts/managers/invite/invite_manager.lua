-- chunkname: @scripts/managers/invite/invite_manager.lua

InviteManager = class(InviteManager)

local var_0_0 = 1

InviteManager.init = function (arg_1_0)
	arg_1_0.lobby_data = nil
	arg_1_0._pending_lobby_data = {}
	arg_1_0.is_steam = rawget(_G, "Steam") and rawget(_G, "Friends") and true or false
	arg_1_0._refresh_timer = var_0_0
end

InviteManager.update = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:_update_pending_lobby_data(arg_2_1, arg_2_2)
	arg_2_0:_poll_invite(arg_2_1, arg_2_2)
end

InviteManager._poll_invite = function (arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0.is_steam then
		local var_3_0, var_3_1, var_3_2, var_3_3 = Friends.next_invite()

		if var_3_0 == Friends.INVITE_SERVER then
			arg_3_0:_handle_invitation(var_3_0, var_3_1, var_3_2, var_3_3)
		elseif var_3_0 == Friends.INVITE_LOBBY then
			print("Got invite to lobby from " .. var_3_3 .. " - fetching lobby data")

			arg_3_0._pending_lobby_data.invite_type = var_3_0
			arg_3_0._pending_lobby_data.lobby_id = var_3_1
			arg_3_0._pending_lobby_data.params = var_3_2
			arg_3_0._pending_lobby_data.invitee = var_3_3
			arg_3_0._refresh_timer = arg_3_2 + var_0_0

			SteamLobby.request_lobby_data(var_3_1)
		end
	end
end

InviteManager._handle_invitation = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = Development.parameter("use_lan_backend") and arg_4_1 ~= Friends.NO_INVITE

	assert(not var_4_0, "You cannot use Steam invites in combination with LAN backend.")

	if arg_4_1 == Friends.INVITE_LOBBY then
		print("Got invite to lobby from " .. arg_4_4)

		arg_4_5.is_server_invite = false
		arg_4_5.id = arg_4_2
		arg_4_0.lobby_data = arg_4_5
	elseif arg_4_1 == Friends.INVITE_SERVER then
		print("Got invite to server from " .. arg_4_4)

		local var_4_1 = {}

		var_4_1.is_server_invite = true
		var_4_1.id = arg_4_2
		var_4_1.server_info = {
			ip_port = arg_4_2,
			invitee = arg_4_4
		}
		arg_4_0.lobby_data = var_4_1
	end
end

InviteManager._update_pending_lobby_data = function (arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0._pending_lobby_data.lobby_id then
		return
	end

	local var_5_0 = arg_5_0._pending_lobby_data.invite_type
	local var_5_1 = arg_5_0._pending_lobby_data.lobby_id
	local var_5_2 = arg_5_0._pending_lobby_data.params
	local var_5_3 = arg_5_0._pending_lobby_data.invitee
	local var_5_4 = SteamMisc.get_lobby_data(var_5_1)

	if not table.is_empty(var_5_4) and arg_5_2 > arg_5_0._refresh_timer then
		table.clear(arg_5_0._pending_lobby_data)
		arg_5_0:_handle_invitation(var_5_0, var_5_1, var_5_2, var_5_3, var_5_4)
	end
end

InviteManager.has_invitation = function (arg_6_0)
	if arg_6_0.lobby_data == nil then
		local var_6_0, var_6_1 = Managers.time:time_and_delta("main")

		arg_6_0:_poll_invite(var_6_1, var_6_0)
	end

	return arg_6_0.lobby_data ~= nil
end

InviteManager.get_invited_lobby_data = function (arg_7_0)
	local var_7_0 = arg_7_0.lobby_data

	arg_7_0.lobby_data = nil

	return var_7_0
end

InviteManager.set_invited_lobby_data = function (arg_8_0, arg_8_1)
	local var_8_0 = LobbyInternal.get_lobby_data_from_id(arg_8_1)

	var_8_0.id = arg_8_1
	arg_8_0.lobby_data = var_8_0
end

InviteManager.clear_invites = function (arg_9_0)
	return
end

InviteManager.invites_handled = function (arg_10_0)
	return true
end

InviteManager.get_invite_error = function (arg_11_0)
	return
end
