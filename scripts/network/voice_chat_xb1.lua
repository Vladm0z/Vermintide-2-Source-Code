-- chunkname: @scripts/network/voice_chat_xb1.lua

local flag = true

local function fn(...)
	-- function 1
	print("[VoiceChatXboxOneManager]", string.format(...))
end

local var_0_2

if not flag then
	local var_0_3 = fn
else
	local function fn_2()
		-- function 2
		return
	end
end

VoiceChatXboxOneManager = class(VoiceChatXboxOneManager)

VoiceChatXboxOneManager.init = function (self)
	-- function 3
	self._muted_users = {}
	self._remote_users = {}
	self._bandwidth_disabled = false
	self._has_local_user = false

	VoiceChat.init()
end

VoiceChatXboxOneManager.reset = function (self)
	-- function 4
	VoiceChat.clear_remote_users()
	VoiceChat.clear_local_users()
	table.clear(self._muted_users)
	table.clear(self._remote_users)

	self._bandwidth_disabled = false
	self._has_local_user = false
end

VoiceChatXboxOneManager.clear_dangling_remote_users = function (arg_5_0)
	-- function 5
	VoiceChat.clear_dangling_remote_users()
end

VoiceChatXboxOneManager.initiated = function (self)
	-- function 6
	return self._has_local_user
end

VoiceChatXboxOneManager.add_local_user = function (self)
	-- function 7
	if self._bandwidth_disabled or self._has_local_user or not Managers.account:has_privilege(UserPrivilege.COMMUNICATION_VOICE_INGAME) then
		local user_id = Managers.account:user_id()

		self._has_local_user = true

		VoiceChat.add_local_user(user_id)
	end
end

VoiceChatXboxOneManager.remove_local_user = function (self)
	-- function 8
	if not Managers.account:user_detached() then
		return
	end

	if not self._has_local_user then
		local user_id = Managers.account:user_id()

		VoiceChat.remove_user(user_id)

		self._has_local_user = false
	end
end

VoiceChatXboxOneManager._remove_all_users = function (self)
	-- function 9
	self:remove_local_user()

	for k, v in pairs(self._remote_users) do
		self:remove_remote_user(k)
	end

	table.clear(self._remote_users)
end

VoiceChatXboxOneManager.add_remote_user = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._bandwidth_disabled then
		self._remote_users[arg_10_1] = arg_10_2

		VoiceChat.add_remote_user(arg_10_1, arg_10_2)
		Application.warning(string.format("[VoiceChatXboxOneManager] Adding remote user - Xuid: %q Peer_id: %q", arg_10_1, arg_10_2))
	end
end

VoiceChatXboxOneManager.remove_remote_user = function (self, arg_11_1)
	-- function 11
	VoiceChat.remove_user_from_channel_with_xuid(arg_11_1)

	local var_11_0 = self._remote_users[arg_11_1]

	Application.warning(string.format("[VoiceChatXboxOneManager] Removing remote user - Xuid: %q Peer_id: %q", arg_11_1, var_11_0))

	self._remote_users[arg_11_1] = nil
end

VoiceChatXboxOneManager.set_enabled = function (self, arg_12_1)
	-- function 12
	print("[VoiceChatXboxOneManager] Temporarily turned off ability to turn voice chat ON/OFF")

	do return end

	if not arg_12_1 then
		self:add_local_user()
	else
		self:_remove_all_users()
	end
end

VoiceChatXboxOneManager.bandwitdth_disable_voip = function (self)
	-- function 13
	self._popup_id = Managers.popup:queue_popup(Localize("popup_voice_chat_disabled_low_bandwidth"), Localize("popup_voice_chat_disabled_low_bandwidth_header"), "ok", Localize("menu_ok"))

	self:_remove_all_users()

	self._bandwidth_disabled = true
end

VoiceChatXboxOneManager.bandwidth_disabled = function (self)
	-- function 14
	return self._bandwidth_disabled
end

VoiceChatXboxOneManager.is_peer_muted = function (self, arg_15_1)
	-- function 15
	if not self._has_local_user then
		return true
	end

	return self._muted_users[arg_15_1] ~= nil
end

VoiceChatXboxOneManager.mute_peer = function (self, arg_16_1)
	-- function 16
	local xuid = Managers.state.network:lobby():xuid(arg_16_1)

	if not xuid and not self._remote_users[xuid] then
		VoiceChat.mute_user(xuid)

		self._muted_users[arg_16_1] = xuid

		return true
	end
end

VoiceChatXboxOneManager.unmute_peer = function (self, arg_17_1)
	-- function 17
	local var_17_0 = self._muted_users[arg_17_1]

	if not var_17_0 and not self._remote_users[var_17_0] then
		VoiceChat.unmute_user(var_17_0)

		return true
	end

	self._muted_users[arg_17_1] = nil
end

VoiceChatXboxOneManager.set_chat_volume = function (arg_18_0, arg_18_1)
	-- function 18
	VoiceChat.set_chat_volume(arg_18_1)
end

VoiceChatXboxOneManager.set_user_chat_volume = function (self, arg_19_1, arg_19_2)
	-- function 19
	local xuid = Managers.state.network:lobby():xuid(peer_id)

	if not xuid and not self._remote_users[xuid] then
		VoiceChat.set_user_chat_volume(xuid, arg_19_2)
	end
end

VoiceChatXboxOneManager.mute_all_users = function (self)
	-- function 20
	VoiceChat.mute_all_users()
	table.clear(self._muted_users)

	for k, v in pairs(self._remote_users) do
		self._muted_users[k] = true
	end
end

VoiceChatXboxOneManager.unmute_all_users = function (self)
	-- function 21
	VoiceChat.unmute_all_users()
	table.clear(self._muted_users)
end

VoiceChatXboxOneManager.update = function (self, arg_22_1, arg_22_2)
	-- function 22
	self:_handle_popups()
	self:_update_members()
end

VoiceChatXboxOneManager._handle_popups = function (self)
	-- function 23
	if not self._popup_id and not Managers.popup:query_result(self._popup_id) then
		self._popup_id = nil
	end
end

VoiceChatXboxOneManager._update_members = function (self)
	-- function 24
	if not self._has_local_user then
		return
	end

	if not Managers.state.network then
		local lobby = Managers.state.network:lobby()

		if not lobby then
			self:_update_members_changed(lobby)
		end
	end
end

XUIDS_TO_REMOVE = {}
REMOTE_XUIDS = {}

VoiceChatXboxOneManager._update_members_changed = function (self, arg_25_1)
	-- function 25
	if not Managers.account:user_detached() then
		return
	end

	if arg_25_1:get_state() ~= LobbyState.JOINED then
		return
	end

	if not arg_25_1:is_joined() then
		return
	end

	table.clear(REMOTE_XUIDS)
	table.clear(XUIDS_TO_REMOVE)

	local xbox_user_id = Managers.account:xbox_user_id()

	for k, v in pairs(PEER_ID_TO_CHANNEL) do
		local xuid = arg_25_1:xuid(k)

		if not xuid then
			if not (xuid == xbox_user_id or self._remote_users[xuid]) then
				self:add_remote_user(xuid, k)
			end

			REMOTE_XUIDS[xuid] = true
		end
	end

	local lobby_host = arg_25_1:lobby_host()
	local get_members = arg_25_1:members():get_members()

	if lobby_host ~= Network.peer_id() then
		for k_2, v_2 in pairs(get_members) do
			if v_2 ~= lobby_host then
				local xuid_2 = arg_25_1:xuid(v_2)

				if not (xuid_2 == xbox_user_id or self._remote_users[xuid_2]) then
					self:add_remote_user(xuid_2, v_2)
				end

				REMOTE_XUIDS[xuid_2] = true
			end
		end
	end

	for k_3, v_3 in pairs(self._remote_users) do
		if not REMOTE_XUIDS[k_3] then
			XUIDS_TO_REMOVE[k_3] = true
		end
	end

	for k_4, v_4 in pairs(XUIDS_TO_REMOVE) do
		self:remove_remote_user(k_4)
	end
end

VoiceChatXboxOneManager.destroy = function (self)
	-- function 26
	VoiceChat.clear_remote_users()
	VoiceChat.clear_local_users()

	if not self._popup_id then
		Managers.popup:cancel_popup(self._popup_id)

		self._popup_id = nil
	end

	VoiceChat.shutdown()
end
