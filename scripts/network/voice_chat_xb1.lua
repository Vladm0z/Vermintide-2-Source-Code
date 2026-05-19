-- chunkname: @scripts/network/voice_chat_xb1.lua

local var_0_0 = true

local function var_0_1(...)
	print("[VoiceChatXboxOneManager]", string.format(...))
end

local var_0_2

if var_0_0 then
	local var_0_3 = var_0_1
else
	local function var_0_4()
		return
	end
end

VoiceChatXboxOneManager = class(VoiceChatXboxOneManager)

function VoiceChatXboxOneManager.init(arg_3_0)
	arg_3_0._muted_users = {}
	arg_3_0._remote_users = {}
	arg_3_0._bandwidth_disabled = false
	arg_3_0._has_local_user = false

	VoiceChat.init()
end

function VoiceChatXboxOneManager.reset(arg_4_0)
	VoiceChat.clear_remote_users()
	VoiceChat.clear_local_users()
	table.clear(arg_4_0._muted_users)
	table.clear(arg_4_0._remote_users)

	arg_4_0._bandwidth_disabled = false
	arg_4_0._has_local_user = false
end

function VoiceChatXboxOneManager.clear_dangling_remote_users(arg_5_0)
	VoiceChat.clear_dangling_remote_users()
end

function VoiceChatXboxOneManager.initiated(arg_6_0)
	return arg_6_0._has_local_user
end

function VoiceChatXboxOneManager.add_local_user(arg_7_0)
	if not arg_7_0._bandwidth_disabled and not arg_7_0._has_local_user and Managers.account:has_privilege(UserPrivilege.COMMUNICATION_VOICE_INGAME) then
		local var_7_0 = Managers.account:user_id()

		arg_7_0._has_local_user = true

		VoiceChat.add_local_user(var_7_0)
	end
end

function VoiceChatXboxOneManager.remove_local_user(arg_8_0)
	if Managers.account:user_detached() then
		return
	end

	if arg_8_0._has_local_user then
		local var_8_0 = Managers.account:user_id()

		VoiceChat.remove_user(var_8_0)

		arg_8_0._has_local_user = false
	end
end

function VoiceChatXboxOneManager._remove_all_users(arg_9_0)
	arg_9_0:remove_local_user()

	for iter_9_0, iter_9_1 in pairs(arg_9_0._remote_users) do
		arg_9_0:remove_remote_user(iter_9_0)
	end

	table.clear(arg_9_0._remote_users)
end

function VoiceChatXboxOneManager.add_remote_user(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._bandwidth_disabled then
		arg_10_0._remote_users[arg_10_1] = arg_10_2

		VoiceChat.add_remote_user(arg_10_1, arg_10_2)
		Application.warning(string.format("[VoiceChatXboxOneManager] Adding remote user - Xuid: %q Peer_id: %q", arg_10_1, arg_10_2))
	end
end

function VoiceChatXboxOneManager.remove_remote_user(arg_11_0, arg_11_1)
	VoiceChat.remove_user_from_channel_with_xuid(arg_11_1)

	local var_11_0 = arg_11_0._remote_users[arg_11_1]

	Application.warning(string.format("[VoiceChatXboxOneManager] Removing remote user - Xuid: %q Peer_id: %q", arg_11_1, var_11_0))

	arg_11_0._remote_users[arg_11_1] = nil
end

function VoiceChatXboxOneManager.set_enabled(arg_12_0, arg_12_1)
	print("[VoiceChatXboxOneManager] Temporarily turned off ability to turn voice chat ON/OFF")

	do return end

	if arg_12_1 then
		arg_12_0:add_local_user()
	else
		arg_12_0:_remove_all_users()
	end
end

function VoiceChatXboxOneManager.bandwitdth_disable_voip(arg_13_0)
	arg_13_0._popup_id = Managers.popup:queue_popup(Localize("popup_voice_chat_disabled_low_bandwidth"), Localize("popup_voice_chat_disabled_low_bandwidth_header"), "ok", Localize("menu_ok"))

	arg_13_0:_remove_all_users()

	arg_13_0._bandwidth_disabled = true
end

function VoiceChatXboxOneManager.bandwidth_disabled(arg_14_0)
	return arg_14_0._bandwidth_disabled
end

function VoiceChatXboxOneManager.is_peer_muted(arg_15_0, arg_15_1)
	if not arg_15_0._has_local_user then
		return true
	end

	return arg_15_0._muted_users[arg_15_1] ~= nil
end

function VoiceChatXboxOneManager.mute_peer(arg_16_0, arg_16_1)
	local var_16_0 = Managers.state.network:lobby():xuid(arg_16_1)

	if var_16_0 and arg_16_0._remote_users[var_16_0] then
		VoiceChat.mute_user(var_16_0)

		arg_16_0._muted_users[arg_16_1] = var_16_0

		return true
	end
end

function VoiceChatXboxOneManager.unmute_peer(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._muted_users[arg_17_1]

	if var_17_0 and arg_17_0._remote_users[var_17_0] then
		VoiceChat.unmute_user(var_17_0)

		return true
	end

	arg_17_0._muted_users[arg_17_1] = nil
end

function VoiceChatXboxOneManager.set_chat_volume(arg_18_0, arg_18_1)
	VoiceChat.set_chat_volume(arg_18_1)
end

function VoiceChatXboxOneManager.set_user_chat_volume(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = Managers.state.network:lobby():xuid(peer_id)

	if var_19_0 and arg_19_0._remote_users[var_19_0] then
		VoiceChat.set_user_chat_volume(var_19_0, arg_19_2)
	end
end

function VoiceChatXboxOneManager.mute_all_users(arg_20_0)
	VoiceChat.mute_all_users()
	table.clear(arg_20_0._muted_users)

	for iter_20_0, iter_20_1 in pairs(arg_20_0._remote_users) do
		arg_20_0._muted_users[iter_20_0] = true
	end
end

function VoiceChatXboxOneManager.unmute_all_users(arg_21_0)
	VoiceChat.unmute_all_users()
	table.clear(arg_21_0._muted_users)
end

function VoiceChatXboxOneManager.update(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0:_handle_popups()
	arg_22_0:_update_members()
end

function VoiceChatXboxOneManager._handle_popups(arg_23_0)
	if arg_23_0._popup_id and Managers.popup:query_result(arg_23_0._popup_id) then
		arg_23_0._popup_id = nil
	end
end

function VoiceChatXboxOneManager._update_members(arg_24_0)
	if not arg_24_0._has_local_user then
		return
	end

	if Managers.state.network then
		local var_24_0 = Managers.state.network:lobby()

		if var_24_0 then
			arg_24_0:_update_members_changed(var_24_0)
		end
	end
end

XUIDS_TO_REMOVE = {}
REMOTE_XUIDS = {}

function VoiceChatXboxOneManager._update_members_changed(arg_25_0, arg_25_1)
	if Managers.account:user_detached() then
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

	local var_25_0 = Managers.account:xbox_user_id()

	for iter_25_0, iter_25_1 in pairs(PEER_ID_TO_CHANNEL) do
		local var_25_1 = arg_25_1:xuid(iter_25_0)

		if var_25_1 then
			if var_25_1 ~= var_25_0 and not arg_25_0._remote_users[var_25_1] then
				arg_25_0:add_remote_user(var_25_1, iter_25_0)
			end

			REMOTE_XUIDS[var_25_1] = true
		end
	end

	local var_25_2 = arg_25_1:lobby_host()
	local var_25_3 = arg_25_1:members():get_members()

	if var_25_2 ~= Network.peer_id() then
		for iter_25_2, iter_25_3 in pairs(var_25_3) do
			if iter_25_3 ~= var_25_2 then
				local var_25_4 = arg_25_1:xuid(iter_25_3)

				if var_25_4 ~= var_25_0 and not arg_25_0._remote_users[var_25_4] then
					arg_25_0:add_remote_user(var_25_4, iter_25_3)
				end

				REMOTE_XUIDS[var_25_4] = true
			end
		end
	end

	for iter_25_4, iter_25_5 in pairs(arg_25_0._remote_users) do
		if not REMOTE_XUIDS[iter_25_4] then
			XUIDS_TO_REMOVE[iter_25_4] = true
		end
	end

	for iter_25_6, iter_25_7 in pairs(XUIDS_TO_REMOVE) do
		arg_25_0:remove_remote_user(iter_25_6)
	end
end

function VoiceChatXboxOneManager.destroy(arg_26_0)
	VoiceChat.clear_remote_users()
	VoiceChat.clear_local_users()

	if arg_26_0._popup_id then
		Managers.popup:cancel_popup(arg_26_0._popup_id)

		arg_26_0._popup_id = nil
	end

	VoiceChat.shutdown()
end
