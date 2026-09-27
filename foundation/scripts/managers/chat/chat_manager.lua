-- chunkname: @foundation/scripts/managers/chat/chat_manager.lua

require("scripts/managers/irc/irc_manager")
require("scripts/ui/views/chat_gui")
require("scripts/misc/script_retrieve_app_ticket_token")

local scripts_settings_profanity_list = require("scripts/settings/profanity_list")

if script_data.honduras_demo or not Development.parameter("attract_mode") then
	ChatGuiNull = class(ChatGuiNull)

	for k, v in pairs(ChatGui) do
		ChatGuiNull[k] = function ()
			-- function 1
			return
		end
	end
end

ChatManager = class(ChatManager)

if not MESSAGE_TYPES then
	local tbl = {
		[Irc.PRIVATE_MSG] = "Private Message",
		[Irc.CHANNEL_MSG] = "Channel Message",
		[Irc.SYSTEM_MSG] = "System Message",
		[Irc.PARTY_MSG] = "Party Message",
		[Irc.TEAM_MSG] = "Team Message",
		[Irc.ALL_MSG] = "All Message"
	}
end

local tbl_2 = {
	"All",
	"Channels",
	"Party",
	"Private"
}
local tbl_3 = {
	All = {},
	Channels = {
		filter = Irc.CHANNEL_MSG
	},
	Party = {
		filter = Irc.PARTY_MSG
	},
	Private = {
		filter = Irc.PRIVATE_MSG
	}
}

CHAT_VIEW_TYPE_LUT = {
	[Irc.PRIVATE_MSG] = "Private",
	[Irc.CHANNEL_MSG] = "Channels",
	[Irc.PARTY_MSG] = "Party",
	[Irc.TEAM_MSG] = "Team Message",
	[Irc.ALL_MSG] = "All Message"
}
CHAT_VIEW_COLOR = {
	All = Colors.get_table("white"),
	Channels = IRC_CHANNEL_COLORS[Irc.CHANNEL_MSG],
	Party = IRC_CHANNEL_COLORS[Irc.PARTY_MSG],
	Private = IRC_CHANNEL_COLORS[Irc.PRIVATE_MSG]
}

ChatManager.init = function (self)
	-- function 2
	self.channels = {}
	self.chat_messages = {}
	self.global_messages = {}
	self.user_to_simplified_user_lut = {}
	self.alias_lut = {}
	self.recently_sent_messages = {}

	local chat_ignore_list = SaveData.chat_ignore_list

	chat_ignore_list = chat_ignore_list or {}
	self.peer_ignore_list = chat_ignore_list

	if not DEDICATED_SERVER then
		self:create_chat_gui()
	end

	self:set_chat_enabled(Application.user_setting("chat_enabled"))

	self.message_targets = {}
	self.message_targets_lut = {}
	self.current_message_target_index = 1
	self.current_view_index = 1

	self:add_message_target("Party", Irc.PARTY_MSG, "vs_chat_msg_target_team")

	if (IS_WINDOWS or not IS_LINUX or not GameSettingsDevelopment.use_global_chat) and not rawget(_G, "Steam") then
		Steam.retrieve_encrypted_app_ticket()

		local var_2_1 = ScriptReceiveAppTicketToken:new()

		Managers.token:register_token(var_2_1, callback(self, "cb_encrypted_app_ticket_recieved"), 20)
	elseif not rawget(_G, "Steam") then
		GameSettingsDevelopment.use_global_chat = false

		Application.warning("[ChatManager] DISABLING GLOBAL CHAT - STEAM NOT ENABLED")
	end
end

ChatManager.update_ignore_list = function (self)
	-- function 3
	local chat_ignore_list = SaveData.chat_ignore_list

	chat_ignore_list = chat_ignore_list or self.peer_ignore_list
	self.peer_ignore_list = chat_ignore_list
end

ChatManager.cb_encrypted_app_ticket_recieved = function (arg_4_0, arg_4_1)
	-- function 4
	local var_4_0

	print("ENCRYPTED APP TICKET RECIEVED")
	print("begin")

	if not arg_4_1.error then
		GameSettingsDevelopment.use_global_chat = false

		print("FAILED", arg_4_1.error, arg_4_1.encrypted_app_ticket)
	else
		print("SUCCESS:")
		print(arg_4_1.encrypted_app_ticket)

		var_4_0 = "steam:" .. arg_4_1.encrypted_app_ticket
	end

	print("end")

	local tbl = {
		port = 6667,
		allow_send = true,
		channel_name = "#vermintide_se",
		address = "172.16.2.24"
	}
	local user_name = Steam.user_name()
	local find, var_4_4 = string.find(user_name, "[0-9]+")

	if not var_4_4 then
		user_name = string.sub(user_name, var_4_4 + 1)
	end

	local str = "_" .. IrcUtils.convert_steam_user_id_to_base_64(Steam.user_id())
	local len = string.len(str)
	local gsub = string.gsub(user_name, "%W+", "_")
	local sub = string.sub(gsub, 1, 30 - len)

	if not (sub == "" or sub ~= "_") then
		sub = "INVALID"
	end

	local str_2 = sub .. str

	Managers.irc:connect(str_2, var_4_0, tbl, callback(arg_4_0, "cb_notify_connected"))
end

ChatManager.cb_notify_connected = function (arg_5_0, arg_5_1)
	-- function 5
	if not arg_5_1 then
		Application.warning("[ChatManager] Connected to IRC!")
		Managers.irc:register_message_callback("chat_channel_message", Irc.CHANNEL_MSG, callback(arg_5_0, "cb_channel_msg_received"))
		Managers.irc:register_message_callback("chat_private_message", Irc.PRIVATE_MSG, callback(arg_5_0, "cb_private_msg_received"))
		Managers.irc:register_message_callback("chat_system_message", Irc.SYSTEM_MSG, callback(arg_5_0, "cb_system_msg_received"))
		Managers.irc:register_message_callback("chat_join_message", Irc.JOIN_MSG, callback(arg_5_0, "cb_join_msg_received"))
		Managers.irc:register_message_callback("chat_leave_message", Irc.LEAVE_MSG, callback(arg_5_0, "cb_leave_msg_received"))
		Managers.irc:register_message_callback("chat_names_message", Irc.NAMES_MSG, callback(arg_5_0, "cb_names_msg_received"))
	else
		Application.error("[ChatManager] Disconnected from IRC!")
		Managers.irc:unregister_message_callback("chat_channel_message")
		Managers.irc:unregister_message_callback("chat_private_message")
		Managers.irc:unregister_message_callback("chat_system_message")
		Managers.irc:unregister_message_callback("chat_join_message")
		Managers.irc:unregister_message_callback("chat_leave_message")
		Managers.irc:unregister_message_callback("chat_names_message")
	end
end

ChatManager.cb_channel_msg_received = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local check_meta, var_6_1 = self:check_meta(arg_6_4, arg_6_3, arg_6_5)

	if not check_meta then
		Managers.chat:add_irc_message(arg_6_2, arg_6_3, check_meta, arg_6_5, var_6_1)
	end
end

ChatManager.cb_private_msg_received = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local check_meta, var_7_1 = self:check_meta(arg_7_4, arg_7_3, arg_7_5)

	if not check_meta then
		Managers.chat:add_irc_message(arg_7_2, arg_7_3, check_meta, arg_7_5, var_7_1)
	end
end

ChatManager.cb_system_msg_received = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	Managers.chat:add_irc_message(arg_8_2, arg_8_3, arg_8_4, arg_8_5)
end

ChatManager.cb_join_msg_received = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	arg_9_4 = arg_9_3 .. " " .. arg_9_4 .. arg_9_5

	Managers.chat:add_irc_message(arg_9_2, arg_9_3, arg_9_4, arg_9_5)
end

ChatManager.cb_leave_msg_received = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	arg_10_4 = arg_10_3 .. " " .. arg_10_4 .. arg_10_5

	Managers.chat:add_irc_message(arg_10_2, arg_10_3, arg_10_4, arg_10_5)
end

ChatManager.cb_names_msg_received = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	Managers.chat:add_irc_message(arg_11_2, arg_11_3, arg_11_4, arg_11_5)
end

ChatManager.check_meta = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not string.find(arg_12_1, "$LINK;") then
		local find, var_12_1 = string.find(arg_12_1, "$LINK;")

		if not var_12_1 then
			local sub = string.sub(arg_12_1, 1, find - 1)
			local sub_2 = string.sub(arg_12_1, var_12_1 + 1)

			if not SteamMisc.get_lobby_data(sub_2) then
				return sub, {
					lobby_id = sub_2
				}
			else
				return sub
			end
		end

		return arg_12_1
	end

	return arg_12_1
end

ChatManager.add_message_target = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not self:_verify_new_target(arg_13_1, arg_13_2) then
		self.message_targets[#self.message_targets + 1] = {
			message_target = arg_13_1,
			message_target_type = arg_13_2,
			message_target_key = arg_13_3
		}
		self.message_targets_lut[arg_13_1] = #self.message_targets
	end
end

ChatManager.set_message_target_type = function (self, arg_14_1)
	-- function 14
	local var_14_0 = self.message_targets_lut[arg_14_1]

	fassert(var_14_0, "[ChatManager] There is not message target for Irc target %q", arg_14_1)

	self.current_message_target_index = var_14_0
end

ChatManager._verify_new_target = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not (not arg_15_1 and arg_15_1 ~= "") then
		return false
	end

	for i, v in ipairs(self.message_targets) do
		if v.message_target == arg_15_1 then
			return false
		end
	end

	return true
end

ChatManager.remove_message_target = function (self, arg_16_1)
	-- function 16
	local var_16_0 = self.message_targets_lut[arg_16_1]

	if not var_16_0 then
		self.message_targets_lut[arg_16_1] = nil
		self.message_targets[var_16_0] = nil

		if not self.message_targets[self.current_message_target_index] then
			self.current_message_target_index = 1
		end

		return true
	end
end

ChatManager.current_view_and_color = function (self)
	-- function 17
	local var_17_0 = tbl_2[self.current_view_index]

	return var_17_0, CHAT_VIEW_COLOR[var_17_0]
end

ChatManager.add_recent_chat_message = function (arg_18_0, arg_18_1)
	-- function 18
	arg_18_0.recently_sent_messages[#arg_18_0.recently_sent_messages + 1] = arg_18_1
end

ChatManager.get_recently_sent_messages = function (self)
	-- function 19
	return self.recently_sent_messages
end

ChatManager.next_message_target = function (self)
	-- function 20
	self.current_message_target_index = 1 + self.current_message_target_index % #self.message_targets

	local message_target_type = self.message_targets[self.current_message_target_index].message_target_type
	local var_20_1 = tbl_2[self.current_view_index]
	local filter = tbl_3[var_20_1].filter

	if not (var_20_1 == "All" or message_target_type ~= filter) then
		return
	end

	local var_20_3 = CHAT_VIEW_TYPE_LUT[message_target_type]

	if not var_20_3 then
		return
	end

	local find = table.find(tbl_2, var_20_3)

	if not find then
		return
	end

	self:_switch_view_internally(find)

	return true
end

ChatManager.current_message_target = function (self)
	-- function 21
	return self.message_targets[self.current_message_target_index]
end

ChatManager.gui_should_clear = function (self)
	-- function 22
	local clear_messages = self.clear_messages

	self.clear_messages = nil

	return clear_messages
end

ChatManager.create_chat_gui = function (self)
	-- function 23
	local world = Managers.world:world("top_ingame_view")

	self._ui_top_renderer = UIRenderer.create(world, "material", "materials/ui/ui_1080p_chat", "material", "materials/fonts/gw_fonts")

	local tbl = {
		input_manager = Managers.input,
		ui_top_renderer = self._ui_top_renderer,
		chat_manager = self
	}

	if not script_data.honduras_demo then
		self.chat_gui = ChatGuiNull
	else
		self.chat_gui = ChatGui:new(tbl)
	end

	self.gui_enabled = true

	local var_23_2

	if not LEVEL_EDITOR_TEST then
		var_23_2 = DefaultUserSettings.get("user_settings", "chat_font_size")
	else
		var_23_2 = Application.user_setting("chat_font_size")
	end

	self:set_font_size(var_23_2)
end

ChatManager.set_profile_synchronizer = function (self, arg_24_1)
	-- function 24
	if not DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	self.chat_gui:set_profile_synchronizer(arg_24_1)
end

ChatManager.set_wwise_world = function (self, arg_25_1)
	-- function 25
	if not DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	self.chat_gui:set_wwise_world(arg_25_1)
end

ChatManager.set_input_manager = function (self, arg_26_1)
	-- function 26
	if not DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	self.chat_gui:set_input_manager(arg_26_1)
end

ChatManager.block_chat_input_for_one_frame = function (self)
	-- function 27
	if not DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	self.chat_gui:block_chat_input_for_one_frame()
end

ChatManager.register_network_event_delegate = function (self, arg_28_1)
	-- function 28
	arg_28_1:register(self, "rpc_chat_message")

	self.network_event_delegate = arg_28_1
end

ChatManager.unregister_network_event_delegate = function (self)
	-- function 29
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

ChatManager.setup_network_context = function (self, arg_30_1)
	-- function 30
	print(string.format("[ChatManager] Setting up network context, host_peer_id:%s my_peer_id:%s", arg_30_1.host_peer_id, arg_30_1.my_peer_id))

	self.is_server = arg_30_1.is_server
	self.host_peer_id = arg_30_1.host_peer_id
	self.my_peer_id = arg_30_1.my_peer_id
end

ChatManager.ignoring_peer_id = function (self, arg_31_1)
	-- function 31
	return self.peer_ignore_list[arg_31_1]
end

ChatManager.ignore_peer_id = function (self, arg_32_1)
	-- function 32
	self.peer_ignore_list[arg_32_1] = true

	if not (rawget(_G, "Steam") or IS_WINDOWS) then
		SaveData.chat_ignore_list = self.peer_ignore_list

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ChatManager.remove_ignore_peer_id = function (self, arg_33_1)
	-- function 33
	self.peer_ignore_list[arg_33_1] = nil

	if not (rawget(_G, "Steam") or IS_WINDOWS) then
		SaveData.chat_ignore_list = self.peer_ignore_list

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ChatManager.destroy = function (self)
	-- function 34
	if not DEDICATED_SERVER then
		self.chat_gui:destroy()

		self.chat_gui = nil

		local world = Managers.world:world("top_ingame_view")

		UIRenderer.destroy(self._ui_top_renderer, world)
	end

	self.channels = nil
	self.message_targets = {}
end

ChatManager.set_font_size = function (self, arg_35_1)
	-- function 35
	if not self.chat_gui then
		self.chat_gui:set_font_size(arg_35_1)
	end
end

ChatManager.set_chat_enabled = function (self, arg_36_1)
	-- function 36
	self._chat_enabled = arg_36_1
end

ChatManager.is_chat_enabled = function (self)
	-- function 37
	local network_handler = Managers.mechanism:network_handler()

	if not (not network_handler and network_handler:get_match_handler()) then
		return false
	end

	return self._chat_enabled
end

ChatManager.register_channel = function (self, arg_38_1, arg_38_2)
	-- function 38
	print(string.format("[ChatManager] Registering channel %s", arg_38_1))

	local channels = self.channels

	if not IS_XB1 then
		if not channels[arg_38_1] then
			Application.warning(string.format("[ChatManager] Tried to add already registered channel %q", arg_38_1))
		end
	else
		assert(channels[arg_38_1] == nil, "[ChatManager] Tried to add already registered channel %q", arg_38_1)
	end

	channels[arg_38_1] = {
		members_func = arg_38_2
	}
end

ChatManager.unregister_channel = function (arg_39_0, arg_39_1)
	-- function 39
	print(string.format("[ChatManager] Unregistering channel %s", arg_39_1))

	arg_39_0.channels[arg_39_1] = nil
end

ChatManager.chat_is_focused = function (self)
	-- function 40
	return self.chat_gui.chat_focused
end

ChatManager.enable_gui = function (self, arg_41_1)
	-- function 41
	self.gui_enabled = arg_41_1
end

ChatManager.update = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	-- function 42
	if not (not self.gui_enabled and DEDICATED_SERVER) then
		self.chat_gui:update(arg_42_1, arg_42_3, arg_42_4, arg_42_5, self:is_chat_enabled())
	end
end

ChatManager._get_localized_message = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	-- function 43
	local var_43_0

	if not arg_43_4 then
		var_43_0 = LocalizeArray(arg_43_3, FrameTable.alloc_table())
	else
		var_43_0 = arg_43_3
	end

	if not arg_43_2 then
		arg_43_1 = string.format(Localize(arg_43_1), unpack(var_43_0))
	elseif #var_43_0 > 0 then
		arg_43_1 = string.format(arg_43_1, unpack(var_43_0))
	end

	return arg_43_1
end

ChatManager._get_message_target = function (self, arg_44_1)
	-- function 44
	for i, v in ipairs(self.message_targets) do
		if arg_44_1 == v.message_target then
			return v
		end
	end
end

ChatManager.send_chat_message = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11)
	-- function 45
	local _handle_command, var_45_1, var_45_2 = self:_handle_command(arg_45_3, arg_45_7, arg_45_8)

	if not _handle_command then
		return _handle_command, var_45_1, var_45_2
	end

	local var_45_3 = arg_45_3
	local num = NetworkConstants.max_string_length - 5

	if num < #arg_45_3 then
		var_45_3 = UTF8Utils.clamp_byte_length(var_45_3, num) .. "..."
	end

	fassert(self:has_channel(arg_45_1), "Haven't registered channel: %s", tostring(arg_45_1))

	local flag = false
	local flag_2 = true
	local my_peer_id = self.my_peer_id
	local is_dev = SteamHelper.is_dev()

	is_dev = not is_dev and arg_45_2 == 1

	if type(arg_45_5) ~= "table" then
		arg_45_5[1], arg_45_5 = arg_45_5, FrameTable.alloc_table()
	end

	local var_45_9

	if not arg_45_8 then
		var_45_9 = self:_get_message_target(arg_45_8)
	else
		var_45_9 = self.message_targets[self.current_message_target_index]
	end

	local message_target = var_45_9.message_target
	local flag_3 = arg_45_9 or var_45_9.message_target_type
	local flag_4 = arg_45_10 or var_45_9.message_target_key

	if not (flag_3 == Irc.PARTY_MSG or flag_3 == Irc.TEAM_MSG or flag_3 ~= Irc.ALL_MSG) then
		if not self.is_server then
			my_peer_id = arg_45_11 or my_peer_id

			local network_handler = Managers.mechanism:network_handler()

			if not network_handler then
				network_handler:get_match_handler():send_rpc_others("rpc_chat_message", arg_45_1, my_peer_id, arg_45_2, var_45_3, arg_45_5, arg_45_4, arg_45_6, flag, flag_2, is_dev, flag_3)
			else
				return
			end
		else
			local network_handler_2 = Managers.mechanism:network_handler()

			if not network_handler_2 then
				network_handler_2:get_match_handler():send_rpc_up("rpc_chat_message", arg_45_1, my_peer_id, arg_45_2, var_45_3, arg_45_5, arg_45_4, arg_45_6, flag, flag_2, is_dev, flag_3)
			else
				return
			end
		end

		if not arg_45_4 then
			Managers.telemetry_events:chat_message(var_45_3)
		end
	elseif not (flag_3 == Irc.CHANNEL_MSG or flag_3 ~= Irc.PRIVATE_MSG) then
		Managers.irc:send_message(var_45_3, message_target)

		if not rawget(_G, "Steam") then
			my_peer_id = Steam.user_name()
		end

		if flag_3 == Irc.CHANNEL_MSG then
			if not flag_4 then
				my_peer_id = string.format("[%s] ", Localize(flag_4))
			else
				my_peer_id = string.format("[%s]", message_target)
			end
		elseif flag_3 == Irc.PRIVATE_MSG then
			my_peer_id = "To [" .. message_target .. "]"
		end
	end

	if not arg_45_7 then
		self:add_recent_chat_message(var_45_3)
	elseif self.recently_sent_messages[arg_45_7] ~= var_45_3 then
		self:add_recent_chat_message(var_45_3)
	end

	if not (not self:is_channel_member(arg_45_1) and flag or self.peer_ignore_list[my_peer_id]) then
		local _get_localized_message = self:_get_localized_message(var_45_3, arg_45_4, arg_45_5, arg_45_6)

		self:_add_message_to_list(arg_45_1, my_peer_id, arg_45_2, _get_localized_message, flag, flag_2, is_dev, flag_3)
	end
end

ChatManager.send_system_chat_message = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5)
	-- function 46
	fassert(self:has_channel(arg_46_1), "Haven't registered channel: %s", tostring(arg_46_1))

	local flag = true

	if type(arg_46_3) ~= "table" then
		arg_46_3[1], arg_46_3 = arg_46_3, FrameTable.alloc_table()
	end

	local flag_2 = true

	arg_46_5 = arg_46_5 or false

	local flag_3 = false
	local my_peer_id = self.my_peer_id

	if not self.is_server then
		local channel_members = self:channel_members(arg_46_1)

		for k, v in pairs(channel_members) do
			if v ~= my_peer_id then
				local var_46_5 = PEER_ID_TO_CHANNEL[v]

				if not var_46_5 then
					RPC.rpc_chat_message(var_46_5, arg_46_1, my_peer_id, 0, arg_46_2, arg_46_3, flag, arg_46_4, flag_2, arg_46_5, flag_3, Irc.SYSTEM_MSG)
				end
			end
		end
	else
		local host_peer_id = self.host_peer_id

		if not host_peer_id then
			local var_46_7 = PEER_ID_TO_CHANNEL[host_peer_id]

			if not var_46_7 then
				RPC.rpc_chat_message(var_46_7, arg_46_1, my_peer_id, 0, arg_46_2, arg_46_3, flag, arg_46_4, flag_2, arg_46_5, flag_3, Irc.SYSTEM_MSG)
			end
		end
	end

	if not self:is_channel_member(arg_46_1) then
		local str = "System"
		local _get_localized_message = self:_get_localized_message(arg_46_2, flag, arg_46_3, arg_46_4)

		self:_add_message_to_list(arg_46_1, str, 0, _get_localized_message, flag_2, arg_46_5, flag_3)
	end
end

ChatManager.add_local_system_message = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	if not self:is_channel_member(arg_47_1) then
		local str = "System"
		local flag = true
		local flag_2 = false

		self:_add_message_to_list(arg_47_1, str, 0, arg_47_2, flag, arg_47_3, flag_2)
	end
end

ChatManager.add_irc_message = function (self, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	-- function 48
	local num = 1
	local tbl = {
		username = arg_48_2,
		message = arg_48_3,
		parameter = arg_48_4
	}

	if arg_48_1 == Irc.PRIVATE_MSG then
		local var_48_2 = arg_48_5

		if not var_48_2 then
			self._last_private_message_username = arg_48_2

			self:add_message_target(arg_48_2, arg_48_1)
		end

		self:_add_message_to_list(num, arg_48_2, 0, arg_48_3, nil, true, false, arg_48_1, var_48_2, tbl)
	elseif arg_48_1 == Irc.CHANNEL_MSG then
		local var_48_3 = arg_48_5

		self:_add_message_to_list(num, arg_48_2, 0, arg_48_3, nil, true, false, arg_48_1, var_48_3, tbl)
	elseif arg_48_1 == Irc.SYSTEM_MSG then
		self:_add_message_to_list(num, "System", 0, arg_48_3, nil, true, false, arg_48_1, nil, tbl)
	elseif arg_48_1 == Irc.JOIN_MSG then
		if arg_48_2 == Managers.irc:user_name() then
			self:_add_message_to_list(num, "System", 0, arg_48_3, nil, true, false, Irc.SYSTEM_MSG, nil, tbl)
			self:add_message_target(arg_48_4, Irc.CHANNEL_MSG)
		else
			self:_add_message_to_list(num, "System", 0, arg_48_3, nil, true, false, Irc.SYSTEM_MSG, nil, tbl)
		end
	elseif arg_48_1 == Irc.LEAVE_MSG then
		if arg_48_2 == Managers.irc:user_name() then
			self:_add_message_to_list(num, "System", 0, arg_48_3, nil, true, false, Irc.SYSTEM_MSG, nil, tbl)
			self:remove_message_target(arg_48_4)
		else
			self:_add_message_to_list(num, "System", 0, arg_48_3, nil, true, false, Irc.SYSTEM_MSG, nil, tbl)
		end
	end
end

ChatManager.channel_members = function (self, arg_49_1)
	-- function 49
	local var_49_0 = self.channels[arg_49_1]

	fassert(var_49_0, "[ChatManager] Trying to get members from unregistered channel %q", arg_49_1)

	return (var_49_0.members_func())
end

ChatManager.is_channel_member = function (self, arg_50_1)
	-- function 50
	local var_50_0 = self.channels[arg_50_1]

	if not var_50_0 then
		return arg_50_1 == 1
	end

	local members_func = var_50_0.members_func()
	local my_peer_id = self.my_peer_id

	for k, v in pairs(members_func) do
		if v == my_peer_id then
			return true
		end
	end
end

ChatManager.has_channel = function (self, arg_51_1)
	-- function 51
	local var_51_0 = self.channels[arg_51_1]

	var_51_0 = not var_51_0 and true

	return var_51_0
end

ChatManager.rpc_chat_message = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5, arg_52_6, arg_52_7, arg_52_8, arg_52_9, arg_52_10, arg_52_11, arg_52_12)
	-- function 52
	if not self:has_channel(arg_52_2) then
		return
	end

	local var_52_0 = CHANNEL_TO_PEER_ID[arg_52_1]

	if not self.is_server then
		local channel_members = self:channel_members(arg_52_2)

		Managers.mechanism:network_handler():get_match_handler():propagate_rpc_if("rpc_chat_message", var_52_0, function (arg_53_0)
			-- function 53
			return table.find(channel_members, arg_53_0)
		end, arg_52_2, arg_52_3, arg_52_4, arg_52_5, arg_52_6, arg_52_7, arg_52_8, arg_52_9, arg_52_10, arg_52_11, arg_52_12)
	end

	if not (not self:is_channel_member(arg_52_2) and arg_52_9 or self.peer_ignore_list[arg_52_3]) then
		if not arg_52_9 then
			arg_52_3 = "System"
		end

		local _get_localized_message = self:_get_localized_message(arg_52_5, arg_52_7, arg_52_6, arg_52_8)

		self:_add_message_to_list(arg_52_2, arg_52_3, arg_52_4, _get_localized_message, arg_52_9, arg_52_10, arg_52_11, arg_52_12)
	end
end

ChatManager._profanity_check = function (arg_54_0, arg_54_1)
	-- function 54
	for k, v in pairs(scripts_settings_profanity_list) do
		local find, var_54_1 = string.find(arg_54_1, v)

		while not find do
			local str = ""
			local length = Utf8.length(v)

			for k_2 = 1, length do
				str = str .. "*"
			end

			arg_54_1 = string.gsub(arg_54_1, v, str)

			local var_54_4

			find, var_54_4 = string.find(arg_54_1, v)
		end
	end

	return arg_54_1
end

ChatManager._add_message_to_list = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8, arg_55_9, arg_55_10)
	-- function 55
	if not (IS_WINDOWS or self:is_chat_enabled()) then
		return
	end

	local player_from_peer_id = Managers.player:player_from_peer_id(arg_55_2, arg_55_3)
	local flag = false

	if not player_from_peer_id and not player_from_peer_id:sync_data_active() then
		flag = not player_from_peer_id:is_player_controlled()
		arg_55_7 = arg_55_7 or player_from_peer_id:get_data("is_dev")
	end

	if not (not Application.user_setting("profanity_check") and arg_55_5) then
		arg_55_4 = self:_profanity_check(arg_55_4)
	end

	local flag_2 = false

	if not (not player_from_peer_id and DEDICATED_SERVER) then
		local get_party = Managers.player:local_player():get_party()
		local flag_3 = not get_party and Managers.state.side.side_by_party[get_party]
		local flag_4 = not flag_3 and player_from_peer_id:get_party()
		local flag_5 = not flag_4 and Managers.state.side.side_by_party[flag_4]

		flag_2 = not flag_5 and Managers.state.side:is_enemy_by_side(flag_3, flag_5)
	end

	local str = ""
	local flag_6 = false

	if not arg_55_5 then
		str = string.gsub(arg_55_4, "{#.*}", "")
		flag_6 = true
	end

	local global_messages = self.global_messages
	local num = #global_messages + 1
	local tbl = {
		channel_id = arg_55_1,
		message_sender = arg_55_2,
		local_player_id = arg_55_3,
		message = not flag_6 and str and arg_55_4
	}

	if not arg_55_8 then
		-- Nothing
	end

	do
		local SYSTEM_MSG
	end

	::label_55_0::

	if not arg_55_5 then
		SYSTEM_MSG = Irc.SYSTEM_MSG

		if not SYSTEM_MSG then
			-- Nothing
		end
	end

	SYSTEM_MSG = Irc.PARTY_MSG

	::label_55_1::

	tbl.type = SYSTEM_MSG
	tbl.pop_chat = arg_55_6
	tbl.is_dev = arg_55_7
	tbl.is_bot = flag
	tbl.is_enemy = flag_2
	tbl.link = arg_55_9
	tbl.data = arg_55_10
	tbl.is_system_message = arg_55_5
	global_messages[num] = tbl

	if not IS_WINDOWS then
		if not self:is_chat_enabled() then
			return
		end
	elseif not (self:is_chat_enabled() or arg_55_5) then
		return
	end

	local chat_messages = self.chat_messages

	chat_messages[#chat_messages + 1] = global_messages[#global_messages]

	if not arg_55_5 then
		local str_2 = "System"

		printf("[ChatManager][%s]%s: %s", arg_55_1, str_2, not flag_6 and str and arg_55_4)
	end
end

ChatManager.get_chat_messages = function (self, arg_56_1, arg_56_2)
	-- function 56
	if not arg_56_2 then
		-- Nothing
	end

	::label_56_0::

	local var_56_0 = tbl_2[self.current_view_index]

	var_56_0 = var_56_0 or 1

	::label_56_1::

	local filter = tbl_3[var_56_0].filter
	local chat_messages = self.chat_messages

	for k, v in pairs(chat_messages) do
		if not (var_56_0 == "All" or v.type ~= filter) then
			arg_56_1[k] = v
		end

		chat_messages[k] = nil
	end
end

ChatManager._switch_view_internally = function (self, arg_57_1)
	-- function 57
	self.current_view_index = arg_57_1

	local chat_messages = self.chat_messages

	table.clear(chat_messages)

	local var_57_1
	local var_57_2 = tbl_2[self.current_view_index]

	var_57_2 = var_57_2 or 1

	print("Switching Chat View to: " .. string.upper(var_57_2))

	local filter = tbl_3[var_57_2].filter

	for i = 1, #self.global_messages do
		local var_57_4 = self.global_messages[i]

		if not (var_57_2 == "All" or var_57_4.type ~= filter) then
			chat_messages[#chat_messages + 1] = var_57_4
		end
	end
end

ChatManager.switch_view = function (self, arg_58_1)
	-- function 58
	self.current_view_index = 1 + self.current_view_index % #tbl_2

	local chat_messages = self.chat_messages

	table.clear(chat_messages)

	local var_58_1
	local var_58_2 = tbl_2[self.current_view_index]

	var_58_2 = var_58_2 or 1

	print("Switching Chat View to: " .. string.upper(var_58_2))

	local filter = tbl_3[var_58_2].filter

	for i = 1, #self.global_messages do
		local var_58_4 = self.global_messages[i]

		if not (var_58_2 == "All" or var_58_4.type ~= filter) then
			chat_messages[#chat_messages + 1] = var_58_4
		end
	end
end

COMMAND_LUT = {
	["/w"] = "send_message",
	["/t"] = "send_message",
	["/away"] = "away",
	["/cls"] = "clear_chat",
	["/reply"] = "reply",
	["/clear"] = "clear_chat",
	["/j"] = "join_channel",
	["/leave"] = "leave",
	["/invite"] = "game_invite",
	["/msg"] = "send_message",
	["/join"] = "join_channel",
	["/send"] = "send_message",
	["/r"] = "reply",
	["/who"] = "who",
	["/part"] = "leave"
}

ChatManager._handle_command = function (self, arg_59_1, arg_59_2, arg_59_3)
	-- function 59
	if string.find(arg_59_1, "/") == 1 then
		local split_deprecated = string.split_deprecated(arg_59_1, " ")
		local var_59_1 = COMMAND_LUT[split_deprecated[1]]
		local var_59_2

		if not var_59_1 then
			var_59_2 = self[var_59_1](self, split_deprecated, arg_59_1, arg_59_2, arg_59_3)
		end

		return var_59_1, split_deprecated, var_59_2
	end

	return false
end

ChatManager.join_channel = function (self, arg_60_1)
	-- function 60
	if not arg_60_1[2] then
		Managers.irc:join_channel(arg_60_1[2])

		if string.find(arg_60_1[2], "#") == 1 then
			local lower = string.lower(arg_60_1[2])

			self:add_message_target(lower, Irc.CHANNEL_MSG)

			local var_60_1 = self.message_targets_lut[lower]

			var_60_1 = var_60_1 or self.current_message_target_index
			self.current_message_target_index = var_60_1
		end
	end
end

ChatManager.game_invite = function (self, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
	-- function 61
	if #arg_61_1 > 0 then
		local var_61_0

		if not arg_61_4 then
			local var_61_1 = self.message_targets_lut[arg_61_4]

			if not var_61_1 then
				print("No such message target:", arg_61_4)

				return
			else
				var_61_0 = self.message_targets[var_61_1]
			end
		else
			var_61_0 = self:current_message_target()
		end

		if var_61_0.message_target_type == Irc.PARTY_MSG then
			self:_add_message_to_list(1, "System", 0, "You cannot invite people already in your party", false, true, false, Irc.SYSTEM_MSG)

			return
		end

		local find, var_61_3 = string.find(arg_61_2, arg_61_1[1])
		local sub = string.sub(arg_61_2, var_61_3 + 2)
		local gsub = string.gsub(sub, " ", "")

		if string.len(gsub) == 0 then
			return
		end

		local id = Managers.state.network:lobby():id()
		local tbl = {
			lobby_id = id
		}
		local str = sub .. "$LINK;" .. id
		local message_target = var_61_0.message_target

		print(str, message_target)
		Managers.irc:send_message(str, message_target)
		self:_add_message_to_list(1, "LINK", sub, 0, false, true, false, var_61_0.message_target_type, tbl)

		return tbl
	end
end

ChatManager.send_message = function (self, arg_62_1, arg_62_2, arg_62_3)
	-- function 62
	if not arg_62_1[2] then
		local find, var_62_1 = string.find(arg_62_2, arg_62_1[2], 1, true)
		local sub = string.sub(arg_62_2, var_62_1 + 2)
		local gsub = string.gsub(sub, " ", "")

		if string.len(gsub) == 0 then
			return
		end

		local var_62_4 = arg_62_1[2]

		if not Managers.irc:send_message(sub, var_62_4) then
			self:add_message_target(var_62_4, Irc.PRIVATE_MSG)

			local var_62_5 = self.message_targets_lut[var_62_4]

			var_62_5 = var_62_5 or self.current_message_target_index
			self.current_message_target_index = var_62_5

			local str = "To [" .. var_62_4 .. "]"

			if not arg_62_3 then
				self:add_recent_chat_message(sub)
			elseif self.recently_sent_messages[arg_62_3] ~= sub then
				self:add_recent_chat_message(sub)
			end

			self:_add_message_to_list(1, str, 0, sub, false, true, false, Irc.PRIVATE_MSG)
		end
	end
end

ChatManager.leave = function (self, arg_63_1)
	-- function 63
	if not (not arg_63_1[2] and string.find(arg_63_1[2], "#") ~= 1) then
		local lower = string.lower(arg_63_1[2])

		Managers.irc:leave_channel(lower)

		if not self:remove_message_target(lower) then
			self.current_message_target_index = 1
		end
	end
end

ChatManager.who = function (arg_64_0, arg_64_1)
	-- function 64
	if not (not arg_64_1[2] and string.find(arg_64_1[2], "#") ~= 1) then
		local lower = string.lower(arg_64_1[2])

		Managers.irc:who(lower)
	end
end

ChatManager.reply = function (self, arg_65_1, arg_65_2)
	-- function 65
	local _last_private_message_username = self._last_private_message_username

	if not arg_65_1[2] and not _last_private_message_username then
		local find, var_65_2 = string.find(arg_65_2, arg_65_1[1])
		local sub = string.sub(arg_65_2, var_65_2 + 2)

		Managers.irc:send_message(sub, _last_private_message_username)

		local var_65_4 = self.message_targets_lut[_last_private_message_username]

		var_65_4 = var_65_4 or self.current_message_target_index
		self.current_message_target_index = var_65_4

		local str = "To [" .. _last_private_message_username .. "]"

		self:add_recent_chat_message(sub)
		self:_add_message_to_list(1, str, 0, sub, false, true, false, Irc.PRIVATE_MSG)
	end
end

ChatManager.clear_chat = function (self)
	-- function 66
	self.global_messages = {}
	self.chat_messages = {}
	self.clear_messages = true
end
