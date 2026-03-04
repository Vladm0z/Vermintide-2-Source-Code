-- chunkname: @foundation/scripts/managers/chat/chat_manager.lua

require("scripts/managers/irc/irc_manager")
require("scripts/ui/views/chat_gui")
require("scripts/misc/script_retrieve_app_ticket_token")

local var_0_0 = require("scripts/settings/profanity_list")

if script_data.honduras_demo or Development.parameter("attract_mode") then
	ChatGuiNull = class(ChatGuiNull)

	for iter_0_0, iter_0_1 in pairs(ChatGui) do
		ChatGuiNull[iter_0_0] = function ()
			return
		end
	end
end

ChatManager = class(ChatManager)

if not MESSAGE_TYPES then
	local var_0_1 = {
		[Irc.PRIVATE_MSG] = "Private Message",
		[Irc.CHANNEL_MSG] = "Channel Message",
		[Irc.SYSTEM_MSG] = "System Message",
		[Irc.PARTY_MSG] = "Party Message",
		[Irc.TEAM_MSG] = "Team Message",
		[Irc.ALL_MSG] = "All Message"
	}
end

local var_0_2 = {
	"All",
	"Channels",
	"Party",
	"Private"
}
local var_0_3 = {
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

ChatManager.init = function (arg_2_0)
	arg_2_0.channels = {}
	arg_2_0.chat_messages = {}
	arg_2_0.global_messages = {}
	arg_2_0.user_to_simplified_user_lut = {}
	arg_2_0.alias_lut = {}
	arg_2_0.recently_sent_messages = {}
	arg_2_0.peer_ignore_list = SaveData.chat_ignore_list or {}

	if not DEDICATED_SERVER then
		arg_2_0:create_chat_gui()
	end

	arg_2_0:set_chat_enabled(Application.user_setting("chat_enabled"))

	arg_2_0.message_targets = {}
	arg_2_0.message_targets_lut = {}
	arg_2_0.current_message_target_index = 1
	arg_2_0.current_view_index = 1

	arg_2_0:add_message_target("Party", Irc.PARTY_MSG, "vs_chat_msg_target_team")

	if (IS_WINDOWS or IS_LINUX) and GameSettingsDevelopment.use_global_chat and rawget(_G, "Steam") then
		Steam.retrieve_encrypted_app_ticket()

		local var_2_0 = ScriptReceiveAppTicketToken:new()

		Managers.token:register_token(var_2_0, callback(arg_2_0, "cb_encrypted_app_ticket_recieved"), 20)
	elseif not rawget(_G, "Steam") then
		GameSettingsDevelopment.use_global_chat = false

		Application.warning("[ChatManager] DISABLING GLOBAL CHAT - STEAM NOT ENABLED")
	end
end

ChatManager.update_ignore_list = function (arg_3_0)
	arg_3_0.peer_ignore_list = SaveData.chat_ignore_list or arg_3_0.peer_ignore_list
end

ChatManager.cb_encrypted_app_ticket_recieved = function (arg_4_0, arg_4_1)
	local var_4_0

	print("ENCRYPTED APP TICKET RECIEVED")
	print("begin")

	if arg_4_1.error then
		GameSettingsDevelopment.use_global_chat = false

		print("FAILED", arg_4_1.error, arg_4_1.encrypted_app_ticket)
	else
		print("SUCCESS:")
		print(arg_4_1.encrypted_app_ticket)

		var_4_0 = "steam:" .. arg_4_1.encrypted_app_ticket
	end

	print("end")

	local var_4_1 = {
		port = 6667,
		allow_send = true,
		channel_name = "#vermintide_se",
		address = "172.16.2.24"
	}
	local var_4_2 = Steam.user_name()
	local var_4_3, var_4_4 = string.find(var_4_2, "[0-9]+")

	if var_4_4 then
		var_4_2 = string.sub(var_4_2, var_4_4 + 1)
	end

	local var_4_5 = "_" .. IrcUtils.convert_steam_user_id_to_base_64(Steam.user_id())
	local var_4_6 = string.len(var_4_5)
	local var_4_7 = string.gsub(var_4_2, "%W+", "_")
	local var_4_8 = string.sub(var_4_7, 1, 30 - var_4_6)

	if var_4_8 == "" or var_4_8 == "_" then
		var_4_8 = "INVALID"
	end

	local var_4_9 = var_4_8 .. var_4_5

	Managers.irc:connect(var_4_9, var_4_0, var_4_1, callback(arg_4_0, "cb_notify_connected"))
end

ChatManager.cb_notify_connected = function (arg_5_0, arg_5_1)
	if arg_5_1 then
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

ChatManager.cb_channel_msg_received = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0, var_6_1 = arg_6_0:check_meta(arg_6_4, arg_6_3, arg_6_5)

	if var_6_0 then
		Managers.chat:add_irc_message(arg_6_2, arg_6_3, var_6_0, arg_6_5, var_6_1)
	end
end

ChatManager.cb_private_msg_received = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0, var_7_1 = arg_7_0:check_meta(arg_7_4, arg_7_3, arg_7_5)

	if var_7_0 then
		Managers.chat:add_irc_message(arg_7_2, arg_7_3, var_7_0, arg_7_5, var_7_1)
	end
end

ChatManager.cb_system_msg_received = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	Managers.chat:add_irc_message(arg_8_2, arg_8_3, arg_8_4, arg_8_5)
end

ChatManager.cb_join_msg_received = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	arg_9_4 = arg_9_3 .. " " .. arg_9_4 .. arg_9_5

	Managers.chat:add_irc_message(arg_9_2, arg_9_3, arg_9_4, arg_9_5)
end

ChatManager.cb_leave_msg_received = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	arg_10_4 = arg_10_3 .. " " .. arg_10_4 .. arg_10_5

	Managers.chat:add_irc_message(arg_10_2, arg_10_3, arg_10_4, arg_10_5)
end

ChatManager.cb_names_msg_received = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	Managers.chat:add_irc_message(arg_11_2, arg_11_3, arg_11_4, arg_11_5)
end

ChatManager.check_meta = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if string.find(arg_12_1, "$LINK;") then
		local var_12_0, var_12_1 = string.find(arg_12_1, "$LINK;")

		if var_12_1 then
			local var_12_2 = string.sub(arg_12_1, 1, var_12_0 - 1)
			local var_12_3 = string.sub(arg_12_1, var_12_1 + 1)

			if SteamMisc.get_lobby_data(var_12_3) then
				return var_12_2, {
					lobby_id = var_12_3
				}
			else
				return var_12_2
			end
		end

		return arg_12_1
	end

	return arg_12_1
end

ChatManager.add_message_target = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0:_verify_new_target(arg_13_1, arg_13_2) then
		arg_13_0.message_targets[#arg_13_0.message_targets + 1] = {
			message_target = arg_13_1,
			message_target_type = arg_13_2,
			message_target_key = arg_13_3
		}
		arg_13_0.message_targets_lut[arg_13_1] = #arg_13_0.message_targets
	end
end

ChatManager.set_message_target_type = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.message_targets_lut[arg_14_1]

	fassert(var_14_0, "[ChatManager] There is not message target for Irc target %q", arg_14_1)

	arg_14_0.current_message_target_index = var_14_0
end

ChatManager._verify_new_target = function (arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_1 or arg_15_1 == "" then
		return false
	end

	for iter_15_0, iter_15_1 in ipairs(arg_15_0.message_targets) do
		if iter_15_1.message_target == arg_15_1 then
			return false
		end
	end

	return true
end

ChatManager.remove_message_target = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.message_targets_lut[arg_16_1]

	if var_16_0 then
		arg_16_0.message_targets_lut[arg_16_1] = nil
		arg_16_0.message_targets[var_16_0] = nil

		if not arg_16_0.message_targets[arg_16_0.current_message_target_index] then
			arg_16_0.current_message_target_index = 1
		end

		return true
	end
end

ChatManager.current_view_and_color = function (arg_17_0)
	local var_17_0 = var_0_2[arg_17_0.current_view_index]

	return var_17_0, CHAT_VIEW_COLOR[var_17_0]
end

ChatManager.add_recent_chat_message = function (arg_18_0, arg_18_1)
	arg_18_0.recently_sent_messages[#arg_18_0.recently_sent_messages + 1] = arg_18_1
end

ChatManager.get_recently_sent_messages = function (arg_19_0)
	return arg_19_0.recently_sent_messages
end

ChatManager.next_message_target = function (arg_20_0)
	arg_20_0.current_message_target_index = 1 + arg_20_0.current_message_target_index % #arg_20_0.message_targets

	local var_20_0 = arg_20_0.message_targets[arg_20_0.current_message_target_index].message_target_type
	local var_20_1 = var_0_2[arg_20_0.current_view_index]
	local var_20_2 = var_0_3[var_20_1].filter

	if var_20_1 == "All" or var_20_0 == var_20_2 then
		return
	end

	local var_20_3 = CHAT_VIEW_TYPE_LUT[var_20_0]

	if not var_20_3 then
		return
	end

	local var_20_4 = table.find(var_0_2, var_20_3)

	if not var_20_4 then
		return
	end

	arg_20_0:_switch_view_internally(var_20_4)

	return true
end

ChatManager.current_message_target = function (arg_21_0)
	return arg_21_0.message_targets[arg_21_0.current_message_target_index]
end

ChatManager.gui_should_clear = function (arg_22_0)
	local var_22_0 = arg_22_0.clear_messages

	arg_22_0.clear_messages = nil

	return var_22_0
end

ChatManager.create_chat_gui = function (arg_23_0)
	local var_23_0 = Managers.world:world("top_ingame_view")

	arg_23_0._ui_top_renderer = UIRenderer.create(var_23_0, "material", "materials/ui/ui_1080p_chat", "material", "materials/fonts/gw_fonts")

	local var_23_1 = {
		input_manager = Managers.input,
		ui_top_renderer = arg_23_0._ui_top_renderer,
		chat_manager = arg_23_0
	}

	if script_data.honduras_demo then
		arg_23_0.chat_gui = ChatGuiNull
	else
		arg_23_0.chat_gui = ChatGui:new(var_23_1)
	end

	arg_23_0.gui_enabled = true

	local var_23_2

	if LEVEL_EDITOR_TEST then
		var_23_2 = DefaultUserSettings.get("user_settings", "chat_font_size")
	else
		var_23_2 = Application.user_setting("chat_font_size")
	end

	arg_23_0:set_font_size(var_23_2)
end

ChatManager.set_profile_synchronizer = function (arg_24_0, arg_24_1)
	if DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	arg_24_0.chat_gui:set_profile_synchronizer(arg_24_1)
end

ChatManager.set_wwise_world = function (arg_25_0, arg_25_1)
	if DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	arg_25_0.chat_gui:set_wwise_world(arg_25_1)
end

ChatManager.set_input_manager = function (arg_26_0, arg_26_1)
	if DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	arg_26_0.chat_gui:set_input_manager(arg_26_1)
end

ChatManager.block_chat_input_for_one_frame = function (arg_27_0)
	if DEDICATED_SERVER then
		Application.warning("Tried to use chat_gui on dedicated server")

		return
	end

	arg_27_0.chat_gui:block_chat_input_for_one_frame()
end

ChatManager.register_network_event_delegate = function (arg_28_0, arg_28_1)
	arg_28_1:register(arg_28_0, "rpc_chat_message")

	arg_28_0.network_event_delegate = arg_28_1
end

ChatManager.unregister_network_event_delegate = function (arg_29_0)
	arg_29_0.network_event_delegate:unregister(arg_29_0)

	arg_29_0.network_event_delegate = nil
end

ChatManager.setup_network_context = function (arg_30_0, arg_30_1)
	print(string.format("[ChatManager] Setting up network context, host_peer_id:%s my_peer_id:%s", arg_30_1.host_peer_id, arg_30_1.my_peer_id))

	arg_30_0.is_server = arg_30_1.is_server
	arg_30_0.host_peer_id = arg_30_1.host_peer_id
	arg_30_0.my_peer_id = arg_30_1.my_peer_id
end

ChatManager.ignoring_peer_id = function (arg_31_0, arg_31_1)
	return arg_31_0.peer_ignore_list[arg_31_1]
end

ChatManager.ignore_peer_id = function (arg_32_0, arg_32_1)
	arg_32_0.peer_ignore_list[arg_32_1] = true

	if rawget(_G, "Steam") or not IS_WINDOWS then
		SaveData.chat_ignore_list = arg_32_0.peer_ignore_list

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ChatManager.remove_ignore_peer_id = function (arg_33_0, arg_33_1)
	arg_33_0.peer_ignore_list[arg_33_1] = nil

	if rawget(_G, "Steam") or not IS_WINDOWS then
		SaveData.chat_ignore_list = arg_33_0.peer_ignore_list

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ChatManager.destroy = function (arg_34_0)
	if not DEDICATED_SERVER then
		arg_34_0.chat_gui:destroy()

		arg_34_0.chat_gui = nil

		local var_34_0 = Managers.world:world("top_ingame_view")

		UIRenderer.destroy(arg_34_0._ui_top_renderer, var_34_0)
	end

	arg_34_0.channels = nil
	arg_34_0.message_targets = {}
end

ChatManager.set_font_size = function (arg_35_0, arg_35_1)
	if arg_35_0.chat_gui then
		arg_35_0.chat_gui:set_font_size(arg_35_1)
	end
end

ChatManager.set_chat_enabled = function (arg_36_0, arg_36_1)
	arg_36_0._chat_enabled = arg_36_1
end

ChatManager.is_chat_enabled = function (arg_37_0)
	local var_37_0 = Managers.mechanism:network_handler()

	if not var_37_0 or not var_37_0:get_match_handler() then
		return false
	end

	return arg_37_0._chat_enabled
end

ChatManager.register_channel = function (arg_38_0, arg_38_1, arg_38_2)
	print(string.format("[ChatManager] Registering channel %s", arg_38_1))

	local var_38_0 = arg_38_0.channels

	if IS_XB1 then
		if var_38_0[arg_38_1] then
			Application.warning(string.format("[ChatManager] Tried to add already registered channel %q", arg_38_1))
		end
	else
		assert(var_38_0[arg_38_1] == nil, "[ChatManager] Tried to add already registered channel %q", arg_38_1)
	end

	var_38_0[arg_38_1] = {
		members_func = arg_38_2
	}
end

ChatManager.unregister_channel = function (arg_39_0, arg_39_1)
	print(string.format("[ChatManager] Unregistering channel %s", arg_39_1))

	arg_39_0.channels[arg_39_1] = nil
end

ChatManager.chat_is_focused = function (arg_40_0)
	return arg_40_0.chat_gui.chat_focused
end

ChatManager.enable_gui = function (arg_41_0, arg_41_1)
	arg_41_0.gui_enabled = arg_41_1
end

ChatManager.update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	if arg_42_0.gui_enabled and not DEDICATED_SERVER then
		arg_42_0.chat_gui:update(arg_42_1, arg_42_3, arg_42_4, arg_42_5, arg_42_0:is_chat_enabled())
	end
end

ChatManager._get_localized_message = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	local var_43_0

	if arg_43_4 then
		var_43_0 = LocalizeArray(arg_43_3, FrameTable.alloc_table())
	else
		var_43_0 = arg_43_3
	end

	if arg_43_2 then
		arg_43_1 = string.format(Localize(arg_43_1), unpack(var_43_0))
	elseif #var_43_0 > 0 then
		arg_43_1 = string.format(arg_43_1, unpack(var_43_0))
	end

	return arg_43_1
end

ChatManager._get_message_target = function (arg_44_0, arg_44_1)
	for iter_44_0, iter_44_1 in ipairs(arg_44_0.message_targets) do
		if arg_44_1 == iter_44_1.message_target then
			return iter_44_1
		end
	end
end

ChatManager.send_chat_message = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11)
	local var_45_0, var_45_1, var_45_2 = arg_45_0:_handle_command(arg_45_3, arg_45_7, arg_45_8)

	if var_45_0 then
		return var_45_0, var_45_1, var_45_2
	end

	fassert(arg_45_0:has_channel(arg_45_1), "Haven't registered channel: %s", tostring(arg_45_1))

	local var_45_3 = false
	local var_45_4 = true
	local var_45_5 = arg_45_0.my_peer_id
	local var_45_6 = SteamHelper.is_dev() and arg_45_2 == 1

	if type(arg_45_5) ~= "table" then
		arg_45_5[1], arg_45_5 = arg_45_5, FrameTable.alloc_table()
	end

	local var_45_7

	if arg_45_8 then
		var_45_7 = arg_45_0:_get_message_target(arg_45_8)
	else
		var_45_7 = arg_45_0.message_targets[arg_45_0.current_message_target_index]
	end

	local var_45_8 = var_45_7.message_target
	local var_45_9 = arg_45_9 or var_45_7.message_target_type
	local var_45_10 = arg_45_10 or var_45_7.message_target_key

	if var_45_9 == Irc.PARTY_MSG or var_45_9 == Irc.TEAM_MSG or var_45_9 == Irc.ALL_MSG then
		if arg_45_0.is_server then
			var_45_5 = arg_45_11 or var_45_5

			local var_45_11 = Managers.mechanism:network_handler()

			if var_45_11 then
				var_45_11:get_match_handler():send_rpc_others("rpc_chat_message", arg_45_1, var_45_5, arg_45_2, arg_45_3, arg_45_5, arg_45_4, arg_45_6, var_45_3, var_45_4, var_45_6, var_45_9)
			else
				return
			end
		else
			local var_45_12 = Managers.mechanism:network_handler()

			if var_45_12 then
				var_45_12:get_match_handler():send_rpc_up("rpc_chat_message", arg_45_1, var_45_5, arg_45_2, arg_45_3, arg_45_5, arg_45_4, arg_45_6, var_45_3, var_45_4, var_45_6, var_45_9)
			else
				return
			end
		end

		if not arg_45_4 then
			Managers.telemetry_events:chat_message(arg_45_3)
		end
	elseif var_45_9 == Irc.CHANNEL_MSG or var_45_9 == Irc.PRIVATE_MSG then
		Managers.irc:send_message(arg_45_3, var_45_8)

		if rawget(_G, "Steam") then
			var_45_5 = Steam.user_name()
		end

		if var_45_9 == Irc.CHANNEL_MSG then
			if var_45_10 then
				var_45_5 = string.format("[%s] ", Localize(var_45_10))
			else
				var_45_5 = string.format("[%s]", var_45_8)
			end
		elseif var_45_9 == Irc.PRIVATE_MSG then
			var_45_5 = "To [" .. var_45_8 .. "]"
		end
	end

	if not arg_45_7 then
		arg_45_0:add_recent_chat_message(arg_45_3)
	elseif arg_45_0.recently_sent_messages[arg_45_7] ~= arg_45_3 then
		arg_45_0:add_recent_chat_message(arg_45_3)
	end

	if arg_45_0:is_channel_member(arg_45_1) and (var_45_3 or not arg_45_0.peer_ignore_list[var_45_5]) then
		local var_45_13 = arg_45_0:_get_localized_message(arg_45_3, arg_45_4, arg_45_5, arg_45_6)

		arg_45_0:_add_message_to_list(arg_45_1, var_45_5, arg_45_2, var_45_13, var_45_3, var_45_4, var_45_6, var_45_9)
	end
end

ChatManager.send_system_chat_message = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5)
	fassert(arg_46_0:has_channel(arg_46_1), "Haven't registered channel: %s", tostring(arg_46_1))

	local var_46_0 = true

	if type(arg_46_3) ~= "table" then
		arg_46_3[1], arg_46_3 = arg_46_3, FrameTable.alloc_table()
	end

	local var_46_1 = true

	arg_46_5 = arg_46_5 or false

	local var_46_2 = false
	local var_46_3 = arg_46_0.my_peer_id

	if arg_46_0.is_server then
		local var_46_4 = arg_46_0:channel_members(arg_46_1)

		for iter_46_0, iter_46_1 in pairs(var_46_4) do
			if iter_46_1 ~= var_46_3 then
				local var_46_5 = PEER_ID_TO_CHANNEL[iter_46_1]

				if var_46_5 then
					RPC.rpc_chat_message(var_46_5, arg_46_1, var_46_3, 0, arg_46_2, arg_46_3, var_46_0, arg_46_4, var_46_1, arg_46_5, var_46_2, Irc.SYSTEM_MSG)
				end
			end
		end
	else
		local var_46_6 = arg_46_0.host_peer_id

		if var_46_6 then
			local var_46_7 = PEER_ID_TO_CHANNEL[var_46_6]

			if var_46_7 then
				RPC.rpc_chat_message(var_46_7, arg_46_1, var_46_3, 0, arg_46_2, arg_46_3, var_46_0, arg_46_4, var_46_1, arg_46_5, var_46_2, Irc.SYSTEM_MSG)
			end
		end
	end

	if arg_46_0:is_channel_member(arg_46_1) then
		local var_46_8 = "System"
		local var_46_9 = arg_46_0:_get_localized_message(arg_46_2, var_46_0, arg_46_3, arg_46_4)

		arg_46_0:_add_message_to_list(arg_46_1, var_46_8, 0, var_46_9, var_46_1, arg_46_5, var_46_2)
	end
end

ChatManager.add_local_system_message = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	if arg_47_0:is_channel_member(arg_47_1) then
		local var_47_0 = "System"
		local var_47_1 = true
		local var_47_2 = false

		arg_47_0:_add_message_to_list(arg_47_1, var_47_0, 0, arg_47_2, var_47_1, arg_47_3, var_47_2)
	end
end

ChatManager.add_irc_message = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	local var_48_0 = 1
	local var_48_1 = {
		username = arg_48_2,
		message = arg_48_3,
		parameter = arg_48_4
	}

	if arg_48_1 == Irc.PRIVATE_MSG then
		local var_48_2 = arg_48_5

		if not var_48_2 then
			arg_48_0._last_private_message_username = arg_48_2

			arg_48_0:add_message_target(arg_48_2, arg_48_1)
		end

		arg_48_0:_add_message_to_list(var_48_0, arg_48_2, 0, arg_48_3, nil, true, false, arg_48_1, var_48_2, var_48_1)
	elseif arg_48_1 == Irc.CHANNEL_MSG then
		local var_48_3 = arg_48_5

		arg_48_0:_add_message_to_list(var_48_0, arg_48_2, 0, arg_48_3, nil, true, false, arg_48_1, var_48_3, var_48_1)
	elseif arg_48_1 == Irc.SYSTEM_MSG then
		arg_48_0:_add_message_to_list(var_48_0, "System", 0, arg_48_3, nil, true, false, arg_48_1, nil, var_48_1)
	elseif arg_48_1 == Irc.JOIN_MSG then
		if arg_48_2 == Managers.irc:user_name() then
			arg_48_0:_add_message_to_list(var_48_0, "System", 0, arg_48_3, nil, true, false, Irc.SYSTEM_MSG, nil, var_48_1)
			arg_48_0:add_message_target(arg_48_4, Irc.CHANNEL_MSG)
		else
			arg_48_0:_add_message_to_list(var_48_0, "System", 0, arg_48_3, nil, true, false, Irc.SYSTEM_MSG, nil, var_48_1)
		end
	elseif arg_48_1 == Irc.LEAVE_MSG then
		if arg_48_2 == Managers.irc:user_name() then
			arg_48_0:_add_message_to_list(var_48_0, "System", 0, arg_48_3, nil, true, false, Irc.SYSTEM_MSG, nil, var_48_1)
			arg_48_0:remove_message_target(arg_48_4)
		else
			arg_48_0:_add_message_to_list(var_48_0, "System", 0, arg_48_3, nil, true, false, Irc.SYSTEM_MSG, nil, var_48_1)
		end
	end
end

ChatManager.channel_members = function (arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0.channels[arg_49_1]

	fassert(var_49_0, "[ChatManager] Trying to get members from unregistered channel %q", arg_49_1)

	return (var_49_0.members_func())
end

ChatManager.is_channel_member = function (arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0.channels[arg_50_1]

	if not var_50_0 then
		return arg_50_1 == 1
	end

	local var_50_1 = var_50_0.members_func()
	local var_50_2 = arg_50_0.my_peer_id

	for iter_50_0, iter_50_1 in pairs(var_50_1) do
		if iter_50_1 == var_50_2 then
			return true
		end
	end
end

ChatManager.has_channel = function (arg_51_0, arg_51_1)
	return arg_51_0.channels[arg_51_1] and true
end

ChatManager.rpc_chat_message = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5, arg_52_6, arg_52_7, arg_52_8, arg_52_9, arg_52_10, arg_52_11, arg_52_12)
	if not arg_52_0:has_channel(arg_52_2) then
		return
	end

	local var_52_0 = CHANNEL_TO_PEER_ID[arg_52_1]

	if arg_52_0.is_server then
		local var_52_1 = arg_52_0:channel_members(arg_52_2)

		Managers.mechanism:network_handler():get_match_handler():propagate_rpc_if("rpc_chat_message", var_52_0, function (arg_53_0)
			return table.find(var_52_1, arg_53_0)
		end, arg_52_2, arg_52_3, arg_52_4, arg_52_5, arg_52_6, arg_52_7, arg_52_8, arg_52_9, arg_52_10, arg_52_11, arg_52_12)
	end

	if arg_52_0:is_channel_member(arg_52_2) and (arg_52_9 or not arg_52_0.peer_ignore_list[arg_52_3]) then
		if arg_52_9 then
			arg_52_3 = "System"
		end

		local var_52_2 = arg_52_0:_get_localized_message(arg_52_5, arg_52_7, arg_52_6, arg_52_8)

		arg_52_0:_add_message_to_list(arg_52_2, arg_52_3, arg_52_4, var_52_2, arg_52_9, arg_52_10, arg_52_11, arg_52_12)
	end
end

ChatManager._profanity_check = function (arg_54_0, arg_54_1)
	for iter_54_0, iter_54_1 in pairs(var_0_0) do
		local var_54_0, var_54_1 = string.find(arg_54_1, iter_54_1)

		while var_54_0 do
			local var_54_2 = ""
			local var_54_3 = UTF8Utils.string_length(iter_54_1)

			for iter_54_2 = 1, var_54_3 do
				var_54_2 = var_54_2 .. "*"
			end

			arg_54_1 = string.gsub(arg_54_1, iter_54_1, var_54_2)

			local var_54_4

			var_54_0, var_54_4 = string.find(arg_54_1, iter_54_1)
		end
	end

	return arg_54_1
end

ChatManager._add_message_to_list = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8, arg_55_9, arg_55_10)
	if not IS_WINDOWS and not arg_55_0:is_chat_enabled() then
		return
	end

	local var_55_0 = Managers.player:player_from_peer_id(arg_55_2, arg_55_3)
	local var_55_1 = false

	if var_55_0 and var_55_0:sync_data_active() then
		var_55_1 = not var_55_0:is_player_controlled()
		arg_55_7 = arg_55_7 or var_55_0:get_data("is_dev")
	end

	if Application.user_setting("profanity_check") and not arg_55_5 then
		arg_55_4 = arg_55_0:_profanity_check(arg_55_4)
	end

	local var_55_2 = false

	if var_55_0 and not DEDICATED_SERVER then
		local var_55_3 = Managers.player:local_player():get_party()
		local var_55_4 = var_55_3 and Managers.state.side.side_by_party[var_55_3]
		local var_55_5 = var_55_4 and var_55_0:get_party()
		local var_55_6 = var_55_5 and Managers.state.side.side_by_party[var_55_5]

		var_55_2 = var_55_6 and Managers.state.side:is_enemy_by_side(var_55_4, var_55_6)
	end

	local var_55_7 = ""
	local var_55_8 = false

	if not arg_55_5 then
		var_55_7 = string.gsub(arg_55_4, "{#.*}", "")
		var_55_8 = true
	end

	local var_55_9 = arg_55_0.global_messages

	var_55_9[#var_55_9 + 1] = {
		channel_id = arg_55_1,
		message_sender = arg_55_2,
		local_player_id = arg_55_3,
		message = var_55_8 and var_55_7 or arg_55_4,
		type = arg_55_8 or arg_55_5 and Irc.SYSTEM_MSG or Irc.PARTY_MSG,
		pop_chat = arg_55_6,
		is_dev = arg_55_7,
		is_bot = var_55_1,
		is_enemy = var_55_2,
		link = arg_55_9,
		data = arg_55_10,
		is_system_message = arg_55_5
	}

	if not IS_WINDOWS then
		if not arg_55_0:is_chat_enabled() then
			return
		end
	elseif not arg_55_0:is_chat_enabled() and not arg_55_5 then
		return
	end

	local var_55_10 = arg_55_0.chat_messages

	var_55_10[#var_55_10 + 1] = var_55_9[#var_55_9]

	if arg_55_5 then
		local var_55_11 = "System"

		printf("[ChatManager][%s]%s: %s", arg_55_1, var_55_11, var_55_8 and var_55_7 or arg_55_4)
	end
end

ChatManager.get_chat_messages = function (arg_56_0, arg_56_1, arg_56_2)
	local var_56_0 = arg_56_2 or var_0_2[arg_56_0.current_view_index] or 1
	local var_56_1 = var_0_3[var_56_0].filter
	local var_56_2 = arg_56_0.chat_messages

	for iter_56_0, iter_56_1 in pairs(var_56_2) do
		if var_56_0 == "All" or iter_56_1.type == var_56_1 then
			arg_56_1[iter_56_0] = iter_56_1
		end

		var_56_2[iter_56_0] = nil
	end
end

ChatManager._switch_view_internally = function (arg_57_0, arg_57_1)
	arg_57_0.current_view_index = arg_57_1

	local var_57_0 = arg_57_0.chat_messages

	table.clear(var_57_0)

	local var_57_1
	local var_57_2 = var_0_2[arg_57_0.current_view_index] or 1

	print("Switching Chat View to: " .. string.upper(var_57_2))

	local var_57_3 = var_0_3[var_57_2].filter

	for iter_57_0 = 1, #arg_57_0.global_messages do
		local var_57_4 = arg_57_0.global_messages[iter_57_0]

		if var_57_2 == "All" or var_57_4.type == var_57_3 then
			var_57_0[#var_57_0 + 1] = var_57_4
		end
	end
end

ChatManager.switch_view = function (arg_58_0, arg_58_1)
	arg_58_0.current_view_index = 1 + arg_58_0.current_view_index % #var_0_2

	local var_58_0 = arg_58_0.chat_messages

	table.clear(var_58_0)

	local var_58_1
	local var_58_2 = var_0_2[arg_58_0.current_view_index] or 1

	print("Switching Chat View to: " .. string.upper(var_58_2))

	local var_58_3 = var_0_3[var_58_2].filter

	for iter_58_0 = 1, #arg_58_0.global_messages do
		local var_58_4 = arg_58_0.global_messages[iter_58_0]

		if var_58_2 == "All" or var_58_4.type == var_58_3 then
			var_58_0[#var_58_0 + 1] = var_58_4
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

ChatManager._handle_command = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	if string.find(arg_59_1, "/") == 1 then
		local var_59_0 = string.split_deprecated(arg_59_1, " ")
		local var_59_1 = COMMAND_LUT[var_59_0[1]]
		local var_59_2

		if var_59_1 then
			var_59_2 = arg_59_0[var_59_1](arg_59_0, var_59_0, arg_59_1, arg_59_2, arg_59_3)
		end

		return var_59_1, var_59_0, var_59_2
	end

	return false
end

ChatManager.join_channel = function (arg_60_0, arg_60_1)
	if arg_60_1[2] then
		Managers.irc:join_channel(arg_60_1[2])

		if string.find(arg_60_1[2], "#") == 1 then
			local var_60_0 = string.lower(arg_60_1[2])

			arg_60_0:add_message_target(var_60_0, Irc.CHANNEL_MSG)

			arg_60_0.current_message_target_index = arg_60_0.message_targets_lut[var_60_0] or arg_60_0.current_message_target_index
		end
	end
end

ChatManager.game_invite = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
	if #arg_61_1 > 0 then
		local var_61_0

		if arg_61_4 then
			local var_61_1 = arg_61_0.message_targets_lut[arg_61_4]

			if not var_61_1 then
				print("No such message target:", arg_61_4)

				return
			else
				var_61_0 = arg_61_0.message_targets[var_61_1]
			end
		else
			var_61_0 = arg_61_0:current_message_target()
		end

		if var_61_0.message_target_type == Irc.PARTY_MSG then
			arg_61_0:_add_message_to_list(1, "System", 0, "You cannot invite people already in your party", false, true, false, Irc.SYSTEM_MSG)

			return
		end

		local var_61_2, var_61_3 = string.find(arg_61_2, arg_61_1[1])
		local var_61_4 = string.sub(arg_61_2, var_61_3 + 2)
		local var_61_5 = string.gsub(var_61_4, " ", "")

		if string.len(var_61_5) == 0 then
			return
		end

		local var_61_6 = Managers.state.network:lobby():id()
		local var_61_7 = {
			lobby_id = var_61_6
		}
		local var_61_8 = var_61_4 .. "$LINK;" .. var_61_6
		local var_61_9 = var_61_0.message_target

		print(var_61_8, var_61_9)
		Managers.irc:send_message(var_61_8, var_61_9)
		arg_61_0:_add_message_to_list(1, "LINK", var_61_4, 0, false, true, false, var_61_0.message_target_type, var_61_7)

		return var_61_7
	end
end

ChatManager.send_message = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	if arg_62_1[2] then
		local var_62_0, var_62_1 = string.find(arg_62_2, arg_62_1[2], 1, true)
		local var_62_2 = string.sub(arg_62_2, var_62_1 + 2)
		local var_62_3 = string.gsub(var_62_2, " ", "")

		if string.len(var_62_3) == 0 then
			return
		end

		local var_62_4 = arg_62_1[2]

		if Managers.irc:send_message(var_62_2, var_62_4) then
			arg_62_0:add_message_target(var_62_4, Irc.PRIVATE_MSG)

			arg_62_0.current_message_target_index = arg_62_0.message_targets_lut[var_62_4] or arg_62_0.current_message_target_index

			local var_62_5 = "To [" .. var_62_4 .. "]"

			if not arg_62_3 then
				arg_62_0:add_recent_chat_message(var_62_2)
			elseif arg_62_0.recently_sent_messages[arg_62_3] ~= var_62_2 then
				arg_62_0:add_recent_chat_message(var_62_2)
			end

			arg_62_0:_add_message_to_list(1, var_62_5, 0, var_62_2, false, true, false, Irc.PRIVATE_MSG)
		end
	end
end

ChatManager.leave = function (arg_63_0, arg_63_1)
	if arg_63_1[2] and string.find(arg_63_1[2], "#") == 1 then
		local var_63_0 = string.lower(arg_63_1[2])

		Managers.irc:leave_channel(var_63_0)

		if arg_63_0:remove_message_target(var_63_0) then
			arg_63_0.current_message_target_index = 1
		end
	end
end

ChatManager.who = function (arg_64_0, arg_64_1)
	if arg_64_1[2] and string.find(arg_64_1[2], "#") == 1 then
		local var_64_0 = string.lower(arg_64_1[2])

		Managers.irc:who(var_64_0)
	end
end

ChatManager.reply = function (arg_65_0, arg_65_1, arg_65_2)
	local var_65_0 = arg_65_0._last_private_message_username

	if arg_65_1[2] and var_65_0 then
		local var_65_1, var_65_2 = string.find(arg_65_2, arg_65_1[1])
		local var_65_3 = string.sub(arg_65_2, var_65_2 + 2)

		Managers.irc:send_message(var_65_3, var_65_0)

		arg_65_0.current_message_target_index = arg_65_0.message_targets_lut[var_65_0] or arg_65_0.current_message_target_index

		local var_65_4 = "To [" .. var_65_0 .. "]"

		arg_65_0:add_recent_chat_message(var_65_3)
		arg_65_0:_add_message_to_list(1, var_65_4, 0, var_65_3, false, true, false, Irc.PRIVATE_MSG)
	end
end

ChatManager.clear_chat = function (arg_66_0)
	arg_66_0.global_messages = {}
	arg_66_0.chat_messages = {}
	arg_66_0.clear_messages = true
end
