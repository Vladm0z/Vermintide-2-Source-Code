-- chunkname: @scripts/managers/invite/invite_manager.lua

InviteManager = class(InviteManager)

local num = 1

InviteManager.init = function (self)
	-- function 1
	self.lobby_data = nil
	self._pending_lobby_data = {}

	local flag

	flag = not rawget(_G, "Steam") and not rawget(_G, "Friends") and true and false
	self.is_steam = flag
	self._refresh_timer = num
end

InviteManager.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	self:_update_pending_lobby_data(arg_2_1, arg_2_2)
	self:_poll_invite(arg_2_1, arg_2_2)
end

InviteManager._poll_invite = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self.is_steam then
		local next_invite, var_3_1, var_3_2, var_3_3 = Friends.next_invite()

		if next_invite == Friends.INVITE_SERVER then
			self:_handle_invitation(next_invite, var_3_1, var_3_2, var_3_3)
		elseif next_invite == Friends.INVITE_LOBBY then
			print("Got invite to lobby from " .. var_3_3 .. " - fetching lobby data")

			self._pending_lobby_data.invite_type = next_invite
			self._pending_lobby_data.lobby_id = var_3_1
			self._pending_lobby_data.params = var_3_2
			self._pending_lobby_data.invitee = var_3_3
			self._refresh_timer = arg_3_2 + num

			SteamLobby.request_lobby_data(var_3_1)
		end
	end
end

InviteManager._handle_invitation = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local parameter = Development.parameter("use_lan_backend")

	parameter = not parameter and arg_4_1 ~= Friends.NO_INVITE

	assert(not parameter, "You cannot use Steam invites in combination with LAN backend.")

	if arg_4_1 == Friends.INVITE_LOBBY then
		print("Got invite to lobby from " .. arg_4_4)

		arg_4_5.is_server_invite = false
		arg_4_5.id = arg_4_2
		self.lobby_data = arg_4_5
	elseif arg_4_1 == Friends.INVITE_SERVER then
		print("Got invite to server from " .. arg_4_4)

		local tbl = {}

		tbl.is_server_invite = true
		tbl.id = arg_4_2
		tbl.server_info = {
			ip_port = arg_4_2,
			invitee = arg_4_4
		}
		self.lobby_data = tbl
	end
end

InviteManager._update_pending_lobby_data = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._pending_lobby_data.lobby_id then
		return
	end

	local invite_type = self._pending_lobby_data.invite_type
	local lobby_id = self._pending_lobby_data.lobby_id
	local params = self._pending_lobby_data.params
	local invitee = self._pending_lobby_data.invitee
	local get_lobby_data = SteamMisc.get_lobby_data(lobby_id)

	if not (table.is_empty(get_lobby_data) or not (arg_5_2 > self._refresh_timer)) then
		table.clear(self._pending_lobby_data)
		self:_handle_invitation(invite_type, lobby_id, params, invitee, get_lobby_data)
	end
end

InviteManager.has_invitation = function (self)
	-- function 6
	if self.lobby_data == nil then
		local time_and_delta, var_6_1 = Managers.time:time_and_delta("main")

		self:_poll_invite(var_6_1, time_and_delta)
	end

	return self.lobby_data ~= nil
end

InviteManager.get_invited_lobby_data = function (self)
	-- function 7
	local lobby_data = self.lobby_data

	self.lobby_data = nil

	return lobby_data
end

InviteManager.set_invited_lobby_data = function (self, arg_8_1)
	-- function 8
	local get_lobby_data_from_id = LobbyInternal.get_lobby_data_from_id(arg_8_1)

	get_lobby_data_from_id.id = arg_8_1
	self.lobby_data = get_lobby_data_from_id
end

InviteManager.clear_invites = function (arg_9_0)
	-- function 9
	return
end

InviteManager.invites_handled = function (arg_10_0)
	-- function 10
	return true
end

InviteManager.get_invite_error = function (arg_11_0)
	-- function 11
	return
end
