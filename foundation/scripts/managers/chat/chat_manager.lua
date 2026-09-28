-- chunkname: @foundation/scripts/managers/chat/chat_manager.lua

require("scripts/managers/irc/irc_manager")
require("scripts/ui/views/chat_gui")
require("scripts/misc/script_retrieve_app_ticket_token")

local PROFANITY_LIST = require("scripts/settings/profanity_list")

if script_data.honduras_demo or Development.parameter("attract_mode") then
	ChatGuiNull = class(ChatGuiNull)

	for name, func in pairs(ChatGui) do
		ChatGuiNull[name] = function ()
			-- function 1
			return
		end
	end
end

ChatManager = class(ChatManager)

local MESSAGE_TYPES_2 = MESSAGE_TYPES

if not MESSAGE_TYPES_2 then
	-- Nothing
end

MESSAGE_TYPES_2 = {
	[Irc.PRIVATE_MSG] = "Private Message",
	[Irc.CHANNEL_MSG] = "Channel Message",
	[Irc.SYSTEM_MSG] = "System Message",
	[Irc.PARTY_MSG] = "Party Message",
	[Irc.TEAM_MSG] = "Team Message",
	[Irc.ALL_MSG] = "All Message"
}

local MESSAGE_TYPES = MESSAGE_TYPES_2

::label_0_0::

local CHAT_VIEWS = {
	"All",
	"Channels",
	"Party",
	"Private"
}
local CHAT_VIEW_LUT = {
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

	chat_ignore_list = not not chat_ignore_list or not not {}
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

	if (IS_WINDOWS or IS_LINUX) and GameSettingsDevelopment.use_global_chat and rawget(_G, "Steam") then
		Steam.retrieve_encrypted_app_ticket()

		local token = ScriptReceiveAppTicketToken:new()

		Managers.token:register_token(token, callback(self, "cb_encrypted_app_ticket_recieved"), 20)
	elseif not rawget(_G, "Steam") then
		GameSettingsDevelopment.use_global_chat = false

		Application.warning("[ChatManager] DISABLING GLOBAL CHAT - STEAM NOT ENABLED")
	end
end

ChatManager.update_ignore_list = function (self)
	-- function 3
	local chat_ignore_list = SaveData.chat_ignore_list

	chat_ignore_list = not not chat_ignore_list or not not self.peer_ignore_list
	self.peer_ignore_list = chat_ignore_list
end

ChatManager.cb_encrypted_app_ticket_recieved = function (self, info)
	-- function 4
	local password

	print("ENCRYPTED APP TICKET RECIEVED")
	print("begin")

	if info.error then
		GameSettingsDevelopment.use_global_chat = false

		print("FAILED", info.error, info.encrypted_app_ticket)
	else
		print("SUCCESS:")
		print(info.encrypted_app_ticket)

		password = "steam:" .. info.encrypted_app_ticket
	end

	print("end")

	local irc_settings = {
		port = 6667,
		allow_send = true,
		channel_name = "#vermintide_se",
		address = "172.16.2.24"
	}
	local steam_user_name = Steam.user_name()
	local start_idx, end_idx = string.find(steam_user_name, "[0-9]+")

	if end_idx then
		steam_user_name = string.sub(steam_user_name, end_idx + 1)
	end

	local suffix = "_" .. IrcUtils.convert_steam_user_id_to_base_64(Steam.user_id())
	local suffix_length = string.len(suffix)

	steam_user_name = string.gsub(steam_user_name, "%W+", "_")
	steam_user_name = string.sub(steam_user_name, 1, 30 - suffix_length)

	if steam_user_name == "" or steam_user_name == "_" then
		steam_user_name = "INVALID"
	end

	local user_name = steam_user_name .. suffix

	Managers.irc:connect(user_name, password, irc_settings, callback(self, "cb_notify_connected"))
end

ChatManager.cb_notify_connected = function (self, connected)
	-- function 5
	if connected then
		Application.warning("[ChatManager] Connected to IRC!")
		Managers.irc:register_message_callback("chat_channel_message", Irc.CHANNEL_MSG, callback(self, "cb_channel_msg_received"))
		Managers.irc:register_message_callback("chat_private_message", Irc.PRIVATE_MSG, callback(self, "cb_private_msg_received"))
		Managers.irc:register_message_callback("chat_system_message", Irc.SYSTEM_MSG, callback(self, "cb_system_msg_received"))
		Managers.irc:register_message_callback("chat_join_message", Irc.JOIN_MSG, callback(self, "cb_join_msg_received"))
		Managers.irc:register_message_callback("chat_leave_message", Irc.LEAVE_MSG, callback(self, "cb_leave_msg_received"))
		Managers.irc:register_message_callback("chat_names_message", Irc.NAMES_MSG, callback(self, "cb_names_msg_received"))
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

ChatManager.cb_channel_msg_received = function (self, key, message_type, username, message, parameter)
	-- function 6
	local message, link_data = self:check_meta(message, username, parameter)

	if message then
		Managers.chat:add_irc_message(message_type, username, message, parameter, link_data)
	end
end

ChatManager.cb_private_msg_received = function (self, key, message_type, username, message, parameter)
	-- function 7
	local message, link_data = self:check_meta(message, username, parameter)

	if message then
		Managers.chat:add_irc_message(message_type, username, message, parameter, link_data)
	end
end

ChatManager.cb_system_msg_received = function (self, key, message_type, username, message, parameter)
	-- function 8
	Managers.chat:add_irc_message(message_type, username, message, parameter)
end

ChatManager.cb_join_msg_received = function (self, key, message_type, username, message, parameter)
	-- function 9
	message = username .. " " .. message .. parameter

	Managers.chat:add_irc_message(message_type, username, message, parameter)
end

ChatManager.cb_leave_msg_received = function (self, key, message_type, username, message, parameter)
	-- function 10
	message = username .. " " .. message .. parameter

	Managers.chat:add_irc_message(message_type, username, message, parameter)
end

ChatManager.cb_names_msg_received = function (self, key, message_type, username, message, parameter)
	-- function 11
	Managers.chat:add_irc_message(message_type, username, message, parameter)
end

ChatManager.check_meta = function (self, message, username, parameter)
	-- function 12
	if string.find(message, "$LINK;") then
		local start_index, end_index = string.find(message, "$LINK;")

		if end_index then
			local new_message = string.sub(message, 1, start_index - 1)
			local lobby_id = string.sub(message, end_index + 1)
			local lobby_data = SteamMisc.get_lobby_data(lobby_id)

			if lobby_data then
				return new_message, {
					lobby_id = lobby_id
				}
			else
				return new_message
			end
		end

		return message
	end

	return message
end

ChatManager.add_message_target = function (self, message_target, message_target_type, message_target_key)
	-- function 13
	if self:_verify_new_target(message_target, message_target_type) then
		self.message_targets[#self.message_targets + 1] = {
			message_target = message_target,
			message_target_type = message_target_type,
			message_target_key = message_target_key
		}
		self.message_targets_lut[message_target] = #self.message_targets
	end
end

ChatManager.set_message_target_type = function (self, message_target_type)
	-- function 14
	local message_target_index = self.message_targets_lut[message_target_type]

	fassert(message_target_index, "[ChatManager] There is not message target for Irc target %q", message_target_type)

	self.current_message_target_index = message_target_index
end

ChatManager._verify_new_target = function (self, message_target, message_target_type)
	-- function 15
	if not message_target or message_target == "" then
		return false
	end

	for _, info in ipairs(self.message_targets) do
		if info.message_target == message_target then
			return false
		end
	end

	return true
end

ChatManager.remove_message_target = function (self, message_target)
	-- function 16
	local target_index = self.message_targets_lut[message_target]

	if target_index then
		self.message_targets_lut[message_target] = nil
		self.message_targets[target_index] = nil

		if not self.message_targets[self.current_message_target_index] then
			self.current_message_target_index = 1
		end

		return true
	end
end

ChatManager.current_view_and_color = function (self)
	-- function 17
	local chat_view_name = CHAT_VIEWS[self.current_view_index]

	return chat_view_name, CHAT_VIEW_COLOR[chat_view_name]
end

ChatManager.add_recent_chat_message = function (self, message)
	-- function 18
	self.recently_sent_messages[#self.recently_sent_messages + 1] = message
end

ChatManager.get_recently_sent_messages = function (self)
	-- function 19
	return self.recently_sent_messages
end

ChatManager.next_message_target = function (self)
	-- function 20
	self.current_message_target_index = 1 + self.current_message_target_index % #self.message_targets

	local message_target_type = self.message_targets[self.current_message_target_index].message_target_type
	local filter_name = CHAT_VIEWS[self.current_view_index]
	local view_filter = CHAT_VIEW_LUT[filter_name].filter

	if filter_name == "All" or message_target_type == view_filter then
		return
	end

	local view_name = CHAT_VIEW_TYPE_LUT[message_target_type]

	if not view_name then
		return
	end

	local view_index = table.find(CHAT_VIEWS, view_name)

	if not view_index then
		return
	end

	self:_switch_view_internally(view_index)

	return true
end

ChatManager.current_message_target = function (self)
	-- function 21
	return self.message_targets[self.current_message_target_index]
end

ChatManager.gui_should_clear = function (self)
	-- function 22
	local clear = self.clear_messages

	self.clear_messages = nil

	return clear
end

ChatManager.create_chat_gui = function (self)
	-- function 23
	local top_world = Managers.world:world("top_ingame_view")

	self._ui_top_renderer = UIRenderer.create(top_world, "material", "materials/ui/ui_1080p_chat", "material", "materials/fonts/gw_fonts")

	local context = {
		input_manager = Managers.input,
		ui_top_renderer = self._ui_top_renderer,
		chat_manager = self
	}

	if script_data.honduras_demo then
		self.chat_gui = ChatGuiNull
	else
		self.chat_gui = ChatGui:new(context)
	end

	self.gui_enabled = true

	local font_size

	if LEVEL_EDITOR_TEST then
		font_size = DefaultUserSettings.get("user_settings", "chat_font_size")
	else
		font_size = Application.user_setting("chat_font_size")
	end

	self:set_font_size(font_size)
end

ChatManager.set_profile_synchronizer = function (self, profile_synchronizer)
	-- function 24
	if DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	self.chat_gui:set_profile_synchronizer(profile_synchronizer)
end

ChatManager.set_wwise_world = function (self, wwise_world)
	-- function 25
	if DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	self.chat_gui:set_wwise_world(wwise_world)
end

ChatManager.set_input_manager = function (self, input_manager)
	-- function 26
	if DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	self.chat_gui:set_input_manager(input_manager)
end

ChatManager.block_chat_input_for_one_frame = function (self)
	-- function 27
	if DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	self.chat_gui:block_chat_input_for_one_frame()
end

ChatManager.register_network_event_delegate = function (self, network_event_delegate)
	-- function 28
	network_event_delegate:register(self, "rpc_chat_message")

	self.network_event_delegate = network_event_delegate
end

ChatManager.unregister_network_event_delegate = function (self)
	-- function 29
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

ChatManager.setup_network_context = function (self, network_context)
	-- function 30
	print(string.format("[ChatManager] Setting up network context, host_peer_id:%s my_peer_id:%s", network_context.host_peer_id, network_context.my_peer_id))

	self.is_server = network_context.is_server
	self.host_peer_id = network_context.host_peer_id
	self.my_peer_id = network_context.my_peer_id
end

ChatManager.ignoring_peer_id = function (self, peer_id)
	-- function 31
	return self.peer_ignore_list[peer_id]
end

ChatManager.ignore_peer_id = function (self, peer_id)
	-- function 32
	self.peer_ignore_list[peer_id] = true

	if rawget(_G, "Steam") or not IS_WINDOWS then
		SaveData.chat_ignore_list = self.peer_ignore_list

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ChatManager.remove_ignore_peer_id = function (self, peer_id)
	-- function 33
	self.peer_ignore_list[peer_id] = nil

	if rawget(_G, "Steam") or not IS_WINDOWS then
		SaveData.chat_ignore_list = self.peer_ignore_list

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ChatManager.destroy = function (self)
	-- function 34
	if not DEDICATED_SERVER then
		self.chat_gui:destroy()

		self.chat_gui = nil

		local top_world = Managers.world:world("top_ingame_view")

		UIRenderer.destroy(self._ui_top_renderer, top_world)
	end

	self.channels = nil
	self.message_targets = {}
end

ChatManager.set_font_size = function (self, font_size)
	-- function 35
	if self.chat_gui then
		self.chat_gui:set_font_size(font_size)
	end
end

ChatManager.set_chat_enabled = function (self, chat_enabled)
	-- function 36
	self._chat_enabled = chat_enabled
end

ChatManager.is_chat_enabled = function (self)
	-- function 37
	local network_handler = Managers.mechanism:network_handler()

	if not network_handler or not network_handler:get_match_handler() then
		return false
	end

	return self._chat_enabled
end

ChatManager.register_channel = function (self, channel_id, members_func)
	-- function 38
	print(string.format("[ChatManager] Registering channel %s", channel_id))

	local channels = self.channels

	if IS_XB1 then
		if channels[channel_id] then
			Application.warning(string.format("[ChatManager] Tried to add already registered channel %q", channel_id))
		end
	else
		assert(channels[channel_id] == nil, "[ChatManager] Tried to add already registered channel %q", channel_id)
	end

	channels[channel_id] = {
		members_func = members_func
	}
end

ChatManager.unregister_channel = function (self, channel_id)
	-- function 39
	print(string.format("[ChatManager] Unregistering channel %s", channel_id))

	self.channels[channel_id] = nil
end

ChatManager.chat_is_focused = function (self)
	-- function 40
	return self.chat_gui.chat_focused
end

ChatManager.enable_gui = function (self, enable)
	-- function 41
	self.gui_enabled = enable
end

ChatManager.update = function (self, dt, t, menu_active, menu_input_service, no_unblock)
	-- function 42
	if self.gui_enabled and not DEDICATED_SERVER then
		self.chat_gui:update(dt, menu_active, menu_input_service, no_unblock, self:is_chat_enabled())
	end
end

ChatManager._get_localized_message = function (self, message, localize, localization_parameters, localize_parameters)
	-- function 43
	local localized_parameters

	if localize_parameters then
		localized_parameters = LocalizeArray(localization_parameters, FrameTable.alloc_table())
	else
		localized_parameters = localization_parameters
	end

	if localize then
		message = string.format(Localize(message), unpack(localized_parameters))
	elseif #localized_parameters > 0 then
		message = string.format(message, unpack(localized_parameters))
	end

	return message
end

ChatManager._get_message_target = function (self, message_target)
	-- function 44
	for i, data in ipairs(self.message_targets) do
		if message_target == data.message_target then
			return data
		end
	end
end

ChatManager.send_chat_message = function (self, channel_id, local_player_id, original_message, localize, localization_parameters, localize_parameters, recent_message_index, optional_message_target, optional_message_type, optional_message_target_key, sender_peer_id)
	-- function 45
	local command, parameters, context_data = self:_handle_command(original_message, recent_message_index, optional_message_target)

	if command then
		return command, parameters, context_data
	end

	local message = original_message
	local max_chat_message_length = NetworkConstants.max_string_length - 5

	if max_chat_message_length < #original_message then
		message = UTF8Utils.clamp_byte_length(message, max_chat_message_length) .. "..."
	end

	fassert(self:has_channel(channel_id), "Haven't registered channel: %s", tostring(channel_id))

	local is_system_message = false
	local pop_chat = true
	local peer_id = self.my_peer_id
	local is_dev_2 = SteamHelper.is_dev()

	if is_dev_2 then
		-- Nothing
	end

	if local_player_id ~= 1 then
		is_dev_2 = false

		goto label_45_0
	end

	is_dev_2 = true

	local is_dev = is_dev_2

	::label_45_0::

	if type(localization_parameters) ~= "table" then
		local old_parameter = localization_parameters

		localization_parameters = FrameTable.alloc_table()
		localization_parameters[1] = old_parameter
	end

	local message_target_info

	if optional_message_target then
		message_target_info = self:_get_message_target(optional_message_target)
	else
		message_target_info = self.message_targets[self.current_message_target_index]
	end

	local message_target = message_target_info.message_target
	local message_type = not not optional_message_type or not not message_target_info.message_target_type
	local message_target_key = not not optional_message_target_key or not not message_target_info.message_target_key

	if message_type == Irc.PARTY_MSG or message_type == Irc.TEAM_MSG or message_type == Irc.ALL_MSG then
		if self.is_server then
			peer_id = not not sender_peer_id or not not peer_id

			local network_handler = Managers.mechanism:network_handler()

			if network_handler then
				local match_handler = network_handler:get_match_handler()

				match_handler:send_rpc_others("rpc_chat_message", channel_id, peer_id, local_player_id, message, localization_parameters, localize, localize_parameters, is_system_message, pop_chat, is_dev, message_type)
			else
				return
			end
		else
			local network_handler = Managers.mechanism:network_handler()

			if network_handler then
				local match_handler = network_handler:get_match_handler()

				match_handler:send_rpc_up("rpc_chat_message", channel_id, peer_id, local_player_id, message, localization_parameters, localize, localize_parameters, is_system_message, pop_chat, is_dev, message_type)
			else
				return
			end
		end

		if not localize then
			Managers.telemetry_events:chat_message(message)
		end
	elseif message_type == Irc.CHANNEL_MSG or message_type == Irc.PRIVATE_MSG then
		Managers.irc:send_message(message, message_target)

		if rawget(_G, "Steam") then
			peer_id = Steam.user_name()
		end

		if message_type == Irc.CHANNEL_MSG then
			if message_target_key then
				peer_id = string.format("[%s] ", Localize(message_target_key))
			else
				peer_id = string.format("[%s]", message_target)
			end
		elseif message_type == Irc.PRIVATE_MSG then
			peer_id = "To [" .. message_target .. "]"
		end
	end

	if not recent_message_index then
		self:add_recent_chat_message(message)
	else
		local recent_message = self.recently_sent_messages[recent_message_index]

		if recent_message ~= message then
			self:add_recent_chat_message(message)
		end
	end

	if self:is_channel_member(channel_id) and (is_system_message or not self.peer_ignore_list[peer_id]) then
		local localized_message = self:_get_localized_message(message, localize, localization_parameters, localize_parameters)

		self:_add_message_to_list(channel_id, peer_id, local_player_id, localized_message, is_system_message, pop_chat, is_dev, message_type)
	end
end

ChatManager.send_system_chat_message = function (self, channel_id, message_id, localization_parameters, localize_parameters, pop_chat)
	-- function 46
	fassert(self:has_channel(channel_id), "Haven't registered channel: %s", tostring(channel_id))

	local localize = true

	if type(localization_parameters) ~= "table" then
		local old_parameter = localization_parameters

		localization_parameters = FrameTable.alloc_table()
		localization_parameters[1] = old_parameter
	end

	local is_system_message = true

	pop_chat = not not pop_chat or not not false

	local is_dev = false
	local my_peer_id = self.my_peer_id

	if self.is_server then
		local members = self:channel_members(channel_id)

		for _, member in pairs(members) do
			if member ~= my_peer_id then
				local network_channel_id = PEER_ID_TO_CHANNEL[member]

				if network_channel_id then
					RPC.rpc_chat_message(network_channel_id, channel_id, my_peer_id, 0, message_id, localization_parameters, localize, localize_parameters, is_system_message, pop_chat, is_dev, Irc.SYSTEM_MSG)
				end
			end
		end
	else
		local host_peer_id = self.host_peer_id

		if host_peer_id then
			local network_channel_id = PEER_ID_TO_CHANNEL[host_peer_id]

			if network_channel_id then
				RPC.rpc_chat_message(network_channel_id, channel_id, my_peer_id, 0, message_id, localization_parameters, localize, localize_parameters, is_system_message, pop_chat, is_dev, Irc.SYSTEM_MSG)
			end
		end
	end

	if self:is_channel_member(channel_id) then
		local message_sender = "System"
		local localized_message = self:_get_localized_message(message_id, localize, localization_parameters, localize_parameters)

		self:_add_message_to_list(channel_id, message_sender, 0, localized_message, is_system_message, pop_chat, is_dev)
	end
end

ChatManager.add_local_system_message = function (self, channel_id, message, pop_chat)
	-- function 47
	if self:is_channel_member(channel_id) then
		local message_sender = "System"
		local is_system_message = true
		local is_dev = false

		self:_add_message_to_list(channel_id, message_sender, 0, message, is_system_message, pop_chat, is_dev)
	end
end

ChatManager.add_irc_message = function (self, message_type, username, message, parameter, context)
	-- function 48
	local channel_id = 1
	local data = {
		username = username,
		message = message,
		parameter = parameter
	}

	if message_type == Irc.PRIVATE_MSG then
		local link_data = context

		if not link_data then
			self._last_private_message_username = username

			self:add_message_target(username, message_type)
		end

		self:_add_message_to_list(channel_id, username, 0, message, nil, true, false, message_type, link_data, data)
	elseif message_type == Irc.CHANNEL_MSG then
		local link_data = context

		self:_add_message_to_list(channel_id, username, 0, message, nil, true, false, message_type, link_data, data)
	elseif message_type == Irc.SYSTEM_MSG then
		self:_add_message_to_list(channel_id, "System", 0, message, nil, true, false, message_type, nil, data)
	elseif message_type == Irc.JOIN_MSG then
		if username == Managers.irc:user_name() then
			self:_add_message_to_list(channel_id, "System", 0, message, nil, true, false, Irc.SYSTEM_MSG, nil, data)
			self:add_message_target(parameter, Irc.CHANNEL_MSG)
		else
			self:_add_message_to_list(channel_id, "System", 0, message, nil, true, false, Irc.SYSTEM_MSG, nil, data)
		end
	elseif message_type == Irc.LEAVE_MSG then
		if username == Managers.irc:user_name() then
			self:_add_message_to_list(channel_id, "System", 0, message, nil, true, false, Irc.SYSTEM_MSG, nil, data)
			self:remove_message_target(parameter)
		else
			self:_add_message_to_list(channel_id, "System", 0, message, nil, true, false, Irc.SYSTEM_MSG, nil, data)
		end
	end
end

ChatManager.channel_members = function (self, channel_id)
	-- function 49
	local channel = self.channels[channel_id]

	fassert(channel, "[ChatManager] Trying to get members from unregistered channel %q", channel_id)

	local members = channel.members_func()

	return members
end

ChatManager.is_channel_member = function (self, channel_id)
	-- function 50
	local channel = self.channels[channel_id]

	if not channel then
		return channel_id == 1
	end

	local members = channel.members_func()
	local my_peer_id = self.my_peer_id

	for _, member in pairs(members) do
		if member == my_peer_id then
			return true
		end
	end
end

ChatManager.has_channel = function (self, channel_id)
	-- function 51
	local var_51_0 = self.channels[channel_id]

	var_51_0 = not not var_51_0 and not not true

	return var_51_0
end

ChatManager.rpc_chat_message = function (self, sender_channel_id, channel_id, message_sender, local_player_id, message, localization_parameters, localize, localize_parameters, is_system_message, pop_chat, is_dev, message_type)
	-- function 52
	if not self:has_channel(channel_id) then
		return
	end

	local sender_peer_id = CHANNEL_TO_PEER_ID[sender_channel_id]

	if self.is_server then
		local members = self:channel_members(channel_id)
		local network_handler = Managers.mechanism:network_handler()
		local match_handler = network_handler:get_match_handler()

		match_handler:propagate_rpc_if("rpc_chat_message", sender_peer_id, function (peer_id)
			-- function 53
			return table.find(members, peer_id)
		end, channel_id, message_sender, local_player_id, message, localization_parameters, localize, localize_parameters, is_system_message, pop_chat, is_dev, message_type)
	end

	if self:is_channel_member(channel_id) and (is_system_message or not self.peer_ignore_list[message_sender]) then
		if is_system_message then
			message_sender = "System"
		end

		local localized_message = self:_get_localized_message(message, localize, localization_parameters, localize_parameters)

		self:_add_message_to_list(channel_id, message_sender, local_player_id, localized_message, is_system_message, pop_chat, is_dev, message_type)
	end
end

ChatManager._profanity_check = function (self, message)
	-- function 54
	for _, profanity in pairs(PROFANITY_LIST) do
		local start_index, end_index = string.find(message, profanity)

		while start_index do
			local replacement_text = ""
			local length = Utf8.length(profanity)

			for i = 1, length do
				replacement_text = replacement_text .. "*"
			end

			message = string.gsub(message, profanity, replacement_text)
			start_index, end_index = string.find(message, profanity)
		end
	end

	return message
end

ChatManager._add_message_to_list = function (self, channel_id, message_sender, local_player_id, message, is_system_message, pop_chat, is_dev, message_type, link, data)
	-- function 55
	if not IS_WINDOWS and not self:is_chat_enabled() then
		return
	end

	local player_manager = Managers.player
	local sender_player = player_manager:player_from_peer_id(message_sender, local_player_id)
	local is_bot = false

	if sender_player and sender_player:sync_data_active() then
		is_bot = not sender_player:is_player_controlled()
		is_dev = not not is_dev or not not sender_player:get_data("is_dev")
	end

	if Application.user_setting("profanity_check") and not is_system_message then
		message = self:_profanity_check(message)
	end

	local is_enemy = false

	if sender_player and not DEDICATED_SERVER then
		local local_player = Managers.player:local_player()
		local local_party = local_player:get_party()
		local local_side = not not local_party and not not Managers.state.side.side_by_party[local_party]
		local remote_party = not not local_side and not not sender_player:get_party()
		local remote_side = not not remote_party and not not Managers.state.side.side_by_party[remote_party]

		is_enemy = not not remote_side and not not Managers.state.side:is_enemy_by_side(local_side, remote_side)
	end

	local parsed_message = ""
	local message_edited = false

	if not is_system_message then
		parsed_message = string.gsub(message, "{#.*}", "")
		message_edited = true
	end

	local global_messages = self.global_messages
	local num = #global_messages + 1
	local tbl = {
		channel_id = channel_id,
		message_sender = message_sender,
		local_player_id = local_player_id,
		message = (not message_edited or not parsed_message) and not not message
	}

	if not message_type then
		-- Nothing
	end

	do
		local SYSTEM_MSG
	end

	::label_55_0::

	if is_system_message then
		SYSTEM_MSG = Irc.SYSTEM_MSG

		if not SYSTEM_MSG then
			-- Nothing
		end
	end

	SYSTEM_MSG = Irc.PARTY_MSG

	::label_55_1::

	tbl.type = SYSTEM_MSG
	tbl.pop_chat = pop_chat
	tbl.is_dev = is_dev
	tbl.is_bot = is_bot
	tbl.is_enemy = is_enemy
	tbl.link = link
	tbl.data = data
	tbl.is_system_message = is_system_message
	global_messages[num] = tbl

	if not IS_WINDOWS then
		if not self:is_chat_enabled() then
			return
		end
	elseif not self:is_chat_enabled() and not is_system_message then
		return
	end

	local chat_messages = self.chat_messages

	chat_messages[#chat_messages + 1] = global_messages[#global_messages]

	if is_system_message then
		local sender = "System"

		printf("[ChatManager][%s]%s: %s", channel_id, sender, (not message_edited or not parsed_message) and not not message)
	end
end

ChatManager.get_chat_messages = function (self, destination_table, filter_name)
	-- function 56
	if not filter_name then
		-- Nothing
	end

	::label_56_0::

	local var_56_0 = CHAT_VIEWS[self.current_view_index]

	if not var_56_0 then
		-- Nothing
	end

	var_56_0 = 1

	local filter_name = var_56_0

	::label_56_1::

	local filter = CHAT_VIEW_LUT[filter_name].filter
	local chat_messages = self.chat_messages

	for i, message_data in pairs(chat_messages) do
		if filter_name == "All" or message_data.type == filter then
			destination_table[i] = message_data
		end

		chat_messages[i] = nil
	end
end

ChatManager._switch_view_internally = function (self, view_index)
	-- function 57
	self.current_view_index = view_index

	local chat_messages = self.chat_messages

	table.clear(chat_messages)

	local message_data
	local var_57_0 = CHAT_VIEWS[self.current_view_index]

	if not var_57_0 then
		-- Nothing
	end

	var_57_0 = 1

	local filter_name = var_57_0

	::label_57_0::

	print("Switching Chat View to: " .. string.upper(filter_name))

	local filter = CHAT_VIEW_LUT[filter_name].filter

	for i = 1, #self.global_messages do
		message_data = self.global_messages[i]

		if filter_name == "All" or message_data.type == filter then
			chat_messages[#chat_messages + 1] = message_data
		end
	end
end

ChatManager.switch_view = function (self, view_index)
	-- function 58
	self.current_view_index = 1 + self.current_view_index % #CHAT_VIEWS

	local chat_messages = self.chat_messages

	table.clear(chat_messages)

	local message_data
	local var_58_0 = CHAT_VIEWS[self.current_view_index]

	if not var_58_0 then
		-- Nothing
	end

	var_58_0 = 1

	local filter_name = var_58_0

	::label_58_0::

	print("Switching Chat View to: " .. string.upper(filter_name))

	local filter = CHAT_VIEW_LUT[filter_name].filter

	for i = 1, #self.global_messages do
		message_data = self.global_messages[i]

		if filter_name == "All" or message_data.type == filter then
			chat_messages[#chat_messages + 1] = message_data
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

ChatManager._handle_command = function (self, message, recent_message_index, optional_message_target)
	-- function 59
	if string.find(message, "/") == 1 then
		local parameters = string.split_deprecated(message, " ")
		local command = COMMAND_LUT[parameters[1]]
		local context_data

		if command then
			context_data = self[command](self, parameters, message, recent_message_index, optional_message_target)
		end

		return command, parameters, context_data
	end

	return false
end

ChatManager.join_channel = function (self, parameters)
	-- function 60
	if parameters[2] then
		Managers.irc:join_channel(parameters[2])

		if string.find(parameters[2], "#") == 1 then
			local channel_name = string.lower(parameters[2])

			self:add_message_target(channel_name, Irc.CHANNEL_MSG)

			local var_60_0 = self.message_targets_lut[channel_name]

			var_60_0 = not not var_60_0 or not not self.current_message_target_index
			self.current_message_target_index = var_60_0
		end
	end
end

ChatManager.game_invite = function (self, parameters, message, recent_message_index, optional_message_target)
	-- function 61
	if #parameters > 0 then
		local message_target_data

		if optional_message_target then
			local message_target_index = self.message_targets_lut[optional_message_target]

			if not message_target_index then
				print("No such message target:", optional_message_target)

				return
			else
				message_target_data = self.message_targets[message_target_index]
			end
		else
			message_target_data = self:current_message_target()
		end

		if message_target_data.message_target_type == Irc.PARTY_MSG then
			self:_add_message_to_list(1, "System", 0, "You cannot invite people already in your party", false, true, false, Irc.SYSTEM_MSG)

			return
		end

		local _, end_index = string.find(message, parameters[1])
		local message = string.sub(message, end_index + 2)
		local cropped_msg = string.gsub(message, " ", "")

		if string.len(cropped_msg) == 0 then
			return
		end

		local lobby_id = Managers.state.network:lobby():id()
		local link_data = {
			lobby_id = lobby_id
		}
		local networked_message = message .. "$LINK;" .. lobby_id
		local channel_or_username = message_target_data.message_target

		print(networked_message, channel_or_username)
		Managers.irc:send_message(networked_message, channel_or_username)
		self:_add_message_to_list(1, "LINK", message, 0, false, true, false, message_target_data.message_target_type, link_data)

		return link_data
	end
end

ChatManager.send_message = function (self, parameters, message, recent_message_index)
	-- function 62
	if parameters[2] then
		local _, end_index = string.find(message, parameters[2], 1, true)
		local message = string.sub(message, end_index + 2)
		local cropped_msg = string.gsub(message, " ", "")

		if string.len(cropped_msg) == 0 then
			return
		end

		local user_name = parameters[2]

		if Managers.irc:send_message(message, user_name) then
			self:add_message_target(user_name, Irc.PRIVATE_MSG)

			local var_62_0 = self.message_targets_lut[user_name]

			var_62_0 = not not var_62_0 or not not self.current_message_target_index
			self.current_message_target_index = var_62_0

			local name = "To [" .. user_name .. "]"

			if not recent_message_index then
				self:add_recent_chat_message(message)
			else
				local recent_message = self.recently_sent_messages[recent_message_index]

				if recent_message ~= message then
					self:add_recent_chat_message(message)
				end
			end

			self:_add_message_to_list(1, name, 0, message, false, true, false, Irc.PRIVATE_MSG)
		end
	end
end

ChatManager.leave = function (self, parameters)
	-- function 63
	if parameters[2] and string.find(parameters[2], "#") == 1 then
		local channel_name = string.lower(parameters[2])

		Managers.irc:leave_channel(channel_name)

		if self:remove_message_target(channel_name) then
			self.current_message_target_index = 1
		end
	end
end

ChatManager.who = function (self, parameters)
	-- function 64
	if parameters[2] and string.find(parameters[2], "#") == 1 then
		local channel_name = string.lower(parameters[2])

		Managers.irc:who(channel_name)
	end
end

ChatManager.reply = function (self, parameters, message)
	-- function 65
	local user_name = self._last_private_message_username

	if parameters[2] and user_name then
		local start_index, end_index = string.find(message, parameters[1])
		local new_message = string.sub(message, end_index + 2)

		Managers.irc:send_message(new_message, user_name)

		local var_65_0 = self.message_targets_lut[user_name]

		var_65_0 = not not var_65_0 or not not self.current_message_target_index
		self.current_message_target_index = var_65_0

		local name = "To [" .. user_name .. "]"

		self:add_recent_chat_message(new_message)
		self:_add_message_to_list(1, name, 0, new_message, false, true, false, Irc.PRIVATE_MSG)
	end
end

ChatManager.clear_chat = function (self)
	-- function 66
	self.global_messages = {}
	self.chat_messages = {}
	self.clear_messages = true
end
