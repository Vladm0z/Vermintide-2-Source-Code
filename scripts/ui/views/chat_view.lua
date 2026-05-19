-- chunkname: @scripts/ui/views/chat_view.lua

require("scripts/utils/keystroke_helper")
require("scripts/helpers/emoji_helper")

local var_0_0 = local_require("scripts/ui/views/chat_view_definitions")
local var_0_1 = var_0_0.create_entry_func
local var_0_2 = var_0_0.num_users_in_list
local var_0_3 = {
	"--------------------------------------------------------------------------",
	"    WELCOME TO VERMINTIDE 2 GLOBAL CHAT                    ",
	"                                                           ",
	"    type '/'  or click the '?' to get a list of commands   ",
	"                                                           ",
	"    Current channel: %s                                    ",
	"--------------------------------------------------------------------------",
	" ",
	" "
}
local var_0_4 = {}

ChatView = class(ChatView)
ChatView.MAX_CHARS = 512
ChatView.MAX_CHANNEL_NAME = 30
ChatView.MAX_POPULAR_CHANNELS = 5

local var_0_5 = {
	{
		command = "/join",
		description_text = "<channel_name> - Join a Channel",
		parameter = "#",
		color = Colors.get_table("red")
	},
	{
		command = "/leave",
		description_text = "<channel_name> - Leave a Channel",
		color = Colors.get_table("red")
	},
	{
		command = "/msg",
		description_text = "<user_name> <message> - Send Message to Another User",
		color = Colors.get_table("red")
	},
	{
		command = "/reply",
		description_text = "<message> - Replies to the Person You Last Spoke To",
		color = Colors.get_table("red")
	},
	{
		command = "/invite",
		description_text = "<description> - Send an Invite to Your Game",
		color = Colors.get_table("red")
	},
	{
		command = "/clear",
		description_text = "- Clears the chat",
		color = Colors.get_table("red")
	}
}

function ChatView.init(arg_1_0, arg_1_1)
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._network_lobby = arg_1_1.network_lobby
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._render_settings = {
		snap_pixel_positions = false
	}
	arg_1_0._network_server = arg_1_1.network_server
	arg_1_0._current_channel_name = Managers.irc:home_channel()
	arg_1_0._local_player_id = arg_1_1.local_player_id
	arg_1_0._chat_message = ""
	arg_1_0._chat_index = 1
	arg_1_0._emoji_scroll = 0
	arg_1_0._channels = {}
	arg_1_0._popular_channel_list = {}
	arg_1_0._popular_channel_list_lookup = {}
	arg_1_0._list_channels_cbs = {}

	local var_1_0 = false
	local var_1_1 = Managers.irc:get_channels()

	for iter_1_0, iter_1_1 in pairs(var_1_1) do
		if iter_1_0 == arg_1_0._current_channel_name then
			var_1_0 = true

			break
		end
	end

	if not var_1_0 then
		Managers.irc:join_channel(arg_1_0._current_channel_name)
	end

	local var_1_2 = arg_1_1.input_manager
	local var_1_3 = {
		keybind = true,
		channels_list = true,
		debug_screen = true,
		free_flight = true
	}

	var_1_2:create_input_service("chat_view", "ChatControllerSettings", "ChatControllerFilters", var_1_3)
	var_1_2:map_device_to_service("chat_view", "keyboard")
	var_1_2:map_device_to_service("chat_view", "mouse")

	local var_1_4 = {
		keybind = true,
		debug_screen = true,
		free_flight = true
	}

	var_1_2:create_input_service("channels_list", "ChatControllerSettings", "ChatControllerFilters", var_1_4)
	var_1_2:map_device_to_service("channels_list", "keyboard")
	var_1_2:map_device_to_service("channels_list", "mouse")

	arg_1_0._input_manager = var_1_2

	local var_1_5 = arg_1_1.world_manager:world("level_world")

	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_5)

	Managers.irc:register_message_callback("chat_view_private_msg", Irc.PRIVATE_MSG, callback(arg_1_0, "cb_private_message"))
	Managers.irc:register_message_callback("chat_view_channel_msg", Irc.CHANNEL_MSG, callback(arg_1_0, "cb_channel_message"))
	Managers.irc:register_message_callback("chat_view_join", Irc.JOIN_MSG, callback(arg_1_0, "cb_join_updated"))
	Managers.irc:register_message_callback("chat_view_leave", Irc.LEAVE_MSG, callback(arg_1_0, "cb_leave_updated"))
	Managers.irc:register_message_callback("chat_view_names", Irc.NAMES_MSG, callback(arg_1_0, "cb_members_updated"))
	Managers.irc:register_message_callback("chat_view_meta", Irc.META_MSG, callback(arg_1_0, "cb_meta_updated"))
	Managers.irc:register_message_callback("chat_view_list", Irc.LIST_MSG, callback(arg_1_0, "cb_list_updated"))
	Managers.irc:register_message_callback("chat_view_list_end", Irc.LIST_END_MSG, callback(arg_1_0, "cb_list_end"))
	arg_1_0:_create_ui_elements()
end

function ChatView._strip_identifier_from_user_name(arg_2_0, arg_2_1)
	return string.sub(arg_2_1, 1, -11)
end

function ChatView.cb_private_message(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0._widgets.chat_output_widget
	local var_3_1 = arg_3_0._widgets.private_messages_widget
	local var_3_2 = var_3_0.content
	local var_3_3 = var_3_1.content
	local var_3_4 = var_3_2.private_messages_table

	var_3_4[arg_3_3] = var_3_4[arg_3_3] or {}

	local var_3_5 = var_3_4[arg_3_3]
	local var_3_6, var_3_7 = Managers.chat:check_meta(arg_3_4, arg_3_3, arg_3_5)
	local var_3_8 = EmojiHelper.parse_emojis(var_3_6)
	local var_3_9 = {
		sender = arg_3_3 .. ": ",
		trimmed_sender = arg_3_0:_strip_identifier_from_user_name(arg_3_3) .. ": ",
		message = var_3_6,
		type = arg_3_2
	}

	if var_3_7 then
		var_3_9.link = var_3_7
	end

	if #var_3_8 > 0 then
		var_3_9.emojis = table.clone(var_3_8)
	end

	var_3_5[#var_3_5 + 1] = var_3_9

	if var_3_2.private_user_name ~= arg_3_3 then
		var_3_3.num_private_messages = var_3_3.num_private_messages + 1
		var_3_3.new_per_user[arg_3_3] = true
	end

	var_3_3.has_private_conversations = not table.is_empty(var_3_4)
end

function ChatView._find_end_index(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = (string.find(arg_4_1, " ", arg_4_2) or math.huge) - 1
	local var_4_1 = string.find(arg_4_1, ":", arg_4_2) or math.huge
	local var_4_2 = var_4_0 <= var_4_1 and var_4_0 or var_4_1

	return var_4_2 < math.huge - 1 and var_4_2 or nil
end

function ChatView.cb_channel_message(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0._widgets.chat_output_widget.content
	local var_5_1 = var_5_0.channel_messages_table

	var_5_1[arg_5_5] = var_5_1[arg_5_5] or {}

	local var_5_2 = var_5_1[arg_5_5]
	local var_5_3, var_5_4 = Managers.chat:check_meta(arg_5_4, arg_5_3, arg_5_5)
	local var_5_5 = EmojiHelper.parse_emojis(var_5_3)
	local var_5_6 = {
		sender = arg_5_3 .. ": ",
		trimmed_sender = arg_5_0:_strip_identifier_from_user_name(arg_5_3) .. ": ",
		message = var_5_3,
		type = arg_5_2
	}

	if var_5_4 then
		var_5_6.link = var_5_4
	end

	if #var_5_5 > 0 then
		var_5_6.emojis = table.clone(var_5_5)
	end

	var_5_2[#var_5_2 + 1] = var_5_6
	var_5_0.text_start_offset = #var_5_2
end

function ChatView.cb_join_updated(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = Managers.irc:user_name()

	if arg_6_3 == var_6_0 then
		arg_6_0:_change_channel(arg_6_5)
	end

	arg_6_0:_update_members()

	PlayerData.recent_irc_channels = PlayerData.recent_irc_channels or {}

	local var_6_1 = PlayerData.recent_irc_channels
	local var_6_2 = arg_6_5

	if not table.find(var_6_1, var_6_2) then
		table.insert(var_6_1, 1, var_6_2)

		while #var_6_1 > 5 do
			var_6_1[#var_6_1] = nil
		end
	end

	if arg_6_3 == var_6_0 then
		arg_6_0:_show_welcome_message()
	end
end

function ChatView.cb_meta_updated(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_0:_update_members()
end

function ChatView.cb_list_updated(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	print(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)

	arg_8_0._popular_channel_list[#arg_8_0._popular_channel_list + 1] = arg_8_4 .. "," .. arg_8_5
	arg_8_0._popular_channel_list_lookup = arg_8_0._popular_channel_list_lookup or {}
	arg_8_0._popular_channel_list_lookup[arg_8_4] = arg_8_5
end

function ChatView.cb_list_end(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	arg_9_0._list_updated = true

	local function var_9_0(arg_10_0, arg_10_1)
		local var_10_0 = string.split_deprecated(arg_10_0, ",")
		local var_10_1 = string.split_deprecated(arg_10_1, ",")

		return tonumber(var_10_0[2]) > tonumber(var_10_1[2])
	end

	table.sort(arg_9_0._popular_channel_list, var_9_0)

	if arg_9_0._list_channels_cbs then
		for iter_9_0, iter_9_1 in ipairs(arg_9_0._list_channels_cbs) do
			iter_9_1(arg_9_0._popular_channel_list, arg_9_0._popular_channel_list_lookup)
		end
	end

	table.clear(arg_9_0._list_channels_cbs)
end

function ChatView._change_channel(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._widgets.chat_output_widget.content
	local var_11_1 = arg_11_0._widgets.name_list_widget.content

	arg_11_0._current_channel_name = arg_11_1
	arg_11_0._channels = arg_11_0._channels or {}
	arg_11_0._channels[arg_11_1] = arg_11_1
	var_11_0.channel_name = arg_11_1
	var_11_1.channel_name = arg_11_1
	var_11_0.private_user_name = nil
	var_11_0.trimmed_private_user_name = nil

	local var_11_2 = arg_11_0._widgets.frame_widget.content

	var_11_2.private_user_name = nil
	var_11_2.trimmed_private_user_name = nil
	var_11_0.text_start_offset = #(var_11_0.channel_messages_table[arg_11_1] or {})

	arg_11_0:_update_members()
	arg_11_0:_verify_channel_tabs()
end

local var_0_6 = {}

function ChatView._verify_channel_tabs(arg_12_0)
	local var_12_0 = Managers.irc:get_channels()
	local var_12_1 = var_0_0.widget_definitions
	local var_12_2 = Managers.irc:get_channels()

	for iter_12_0, iter_12_1 in pairs(var_12_2) do
		if not arg_12_0._channel_tab_lookup[iter_12_0] then
			arg_12_0._channel_tabs[#arg_12_0._channel_tabs + 1] = UIWidget.init(var_12_1.create_channel_tab(iter_12_0, #arg_12_0._channel_tabs + 1, arg_12_0._current_channel_name))
			arg_12_0._channel_tab_lookup[iter_12_0] = true
		end
	end

	table.clear(var_0_6)

	local var_12_3 = 1

	for iter_12_2, iter_12_3 in ipairs(arg_12_0._channel_tabs) do
		local var_12_4 = iter_12_3.content
		local var_12_5 = var_12_4.channel_name

		if not var_12_2[var_12_5] then
			arg_12_0._channel_tab_lookup[var_12_5] = nil
			var_0_6[#var_0_6 + 1] = iter_12_2
		else
			var_12_4.selected = var_12_5 == arg_12_0._current_channel_name
			iter_12_3.offset[1] = arg_12_0._ui_scenegraph.channel_tab_anchor.size[1] * (var_12_3 - 1)
			var_12_3 = var_12_3 + 1
		end
	end

	for iter_12_4 = #var_0_6, 1, -1 do
		local var_12_6 = var_0_6[iter_12_4]

		table.remove(arg_12_0._channel_tabs, var_12_6)
	end
end

function ChatView._change_to_private(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._widgets.chat_output_widget.content

	var_13_0.private_user_name = arg_13_1
	var_13_0.trimmed_private_user_name = arg_13_0:_strip_identifier_from_user_name(arg_13_1)
	var_13_0.text_start_offset = #(var_13_0.private_messages_table[arg_13_1] or {})

	local var_13_1 = arg_13_0._widgets.frame_widget.content

	var_13_1.private_user_name = arg_13_1
	var_13_1.trimmed_private_user_name = arg_13_0:_strip_identifier_from_user_name(arg_13_1)
	arg_13_0._widgets.private_messages_widget.content.new_per_user[arg_13_1] = nil

	Managers.chat:add_message_target(arg_13_1, Irc.PRIVATE_MSG)
end

function ChatView._list_private_messages(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._widgets.chat_output_widget.content
	local var_14_1 = arg_14_0._widgets.name_list_widget.content

	arg_14_0._current_channel_name = arg_14_1
	arg_14_0._channels = arg_14_0._channels or {}
	arg_14_0._channels[channel_name] = channel_name
	var_14_0.channel_name = channel_name
	var_14_1.channel_name = channel_name
	var_14_0.text_start_offset = #(var_14_0.channel_messages_table[channel_name] or {})
end

function ChatView.cb_leave_updated(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if arg_15_3 == Managers.irc:user_name() then
		arg_15_0._channels[arg_15_5] = nil

		local var_15_0 = next(arg_15_0._channels) or " "

		arg_15_0:_change_channel(var_15_0)

		local var_15_1 = arg_15_0._widgets.chat_output_widget.content
		local var_15_2 = arg_15_0._widgets.name_list_widget.content

		var_15_1.channel_messages_table[arg_15_5] = nil
		var_15_2.channel_messages_table[arg_15_5] = nil
	end

	arg_15_0:_update_members()
end

function ChatView.cb_members_updated(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	arg_16_0:_update_members()
end

function ChatView._create_ui_elements(arg_17_0)
	arg_17_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_17_0 = {}
	local var_17_1 = {}

	arg_17_0._widgets = arg_17_0._widgets or {}

	local var_17_2 = arg_17_0._widgets.chat_output_widget

	if var_17_2 then
		var_17_0 = var_17_2.content.channel_messages_table
	end

	arg_17_0._widgets = arg_17_0._widgets or {}

	local var_17_3 = arg_17_0._widgets.name_list_widget

	if var_17_3 then
		var_17_1 = var_17_3.content.channel_messages_table
	end

	arg_17_0._widgets = {}
	arg_17_0._current_tab_offset_index = 1
	arg_17_0._channels_list_widgets = {}
	arg_17_0._popular_channel_list_widgets = {}
	arg_17_0._channel_list_widgets = {}
	arg_17_0._private_list_widgets = {}
	arg_17_0._recent_channels_list_widgets = {}
	arg_17_0._commands_list_widgets = {}
	arg_17_0._filtered_user_names_list_widgets = {}
	arg_17_0._create_channel_widgets = {}
	arg_17_0._recent_channels_widgets = {}
	arg_17_0._invite_widgets = {}
	arg_17_0._emoji_widgets = {}
	arg_17_0._channel_tabs = {}
	arg_17_0._channel_tab_lookup = {}
	arg_17_0._ui_animations = {}

	local var_17_4 = var_0_0.widget_definitions

	for iter_17_0, iter_17_1 in pairs(var_17_4.widgets) do
		arg_17_0._widgets[iter_17_0] = UIWidget.init(iter_17_1)
	end

	local var_17_5 = arg_17_0._widgets.chat_output_widget.content

	var_17_5.channel_messages_table = var_17_0
	var_17_5.channel_name = arg_17_0._current_channel_name
	var_17_5.text_start_offset = #var_17_0

	local var_17_6 = arg_17_0._widgets.name_list_widget.content

	var_17_6.channel_messages_table = var_17_1
	var_17_6.channel_name = arg_17_0._current_channel_name

	local var_17_7 = 60
	local var_17_8 = {}

	for iter_17_2 = 1, var_17_7 do
		var_17_8[iter_17_2] = {
			name = "test_" .. iter_17_2
		}
	end

	local var_17_9 = {}

	for iter_17_3 = 1, var_0_2 do
		local var_17_10 = var_0_1(iter_17_3)

		var_17_9[iter_17_3] = UIWidget.init(var_17_10)
	end

	arg_17_0._user_entry_widgets = var_17_9

	arg_17_0:_update_members()

	local var_17_11 = Managers.irc:get_channels()

	for iter_17_4, iter_17_5 in pairs(var_17_11) do
		arg_17_0._channel_tabs[#arg_17_0._channel_tabs + 1] = UIWidget.init(var_17_4.create_channel_tab(iter_17_4, #arg_17_0._channel_tabs + 1, arg_17_0._current_channel_name))
		arg_17_0._channel_tab_lookup[iter_17_4] = #arg_17_0._channel_tabs
	end

	UIRenderer.clear_scenegraph_queue(arg_17_0._ui_renderer)
	Managers.input:device_unblock_service("keyboard", 1, "chat_view")
	Managers.input:device_unblock_service("mouse", 1, "chat_view")
end

function ChatView.on_enter(arg_18_0)
	arg_18_0:set_active(true)
end

local var_0_7 = false

function ChatView.update(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if var_0_7 then
		var_0_7 = false

		arg_19_0:_create_ui_elements()
	end

	if Keyboard.pressed(Keyboard.button_index("b")) then
		print("UPDATE MEMBERS")
		arg_19_0:_update_members()
	end

	if arg_19_0._suspended or not arg_19_0._active then
		return
	end

	arg_19_0:_update_animations(arg_19_1, arg_19_2)
	arg_19_0:_draw(arg_19_1, arg_19_2)
	arg_19_0:_update_channel_tabs(arg_19_1, arg_19_2)
	arg_19_0:_update_input(arg_19_1, arg_19_2)
	arg_19_0:_update_channels_list_input(arg_19_1, arg_19_2)
	arg_19_0:_update_create_channel_input(arg_19_1, arg_19_2)
	arg_19_0:_update_recent_channels_input(arg_19_1, arg_19_2)
	arg_19_0:_update_send_invite_input(arg_19_1, arg_19_2)
	arg_19_0:_handle_command_list(arg_19_1, arg_19_2)
end

function ChatView._update_filter(arg_20_0, arg_20_1)
	local var_20_0 = os.clock()

	arg_20_1 = string.gsub(arg_20_1, "%W", "")

	if #KeystrokeHelper._build_utf8_table(arg_20_1) <= 0 then
		return
	end

	local var_20_1 = {}
	local var_20_2 = false
	local var_20_3 = 1
	local var_20_4 = false
	local var_20_5 = arg_20_0._user_names

	if not var_20_5 or #var_20_5 <= 0 then
		return
	end

	local var_20_6, var_20_7, var_20_8 = Script.temp_count()

	for iter_20_0 = 1, #var_20_5 do
		if string.find(string.lower(var_20_5[iter_20_0]), arg_20_1) then
			var_20_1[#var_20_1 + 1] = var_20_5[iter_20_0]
		end
	end

	if #var_20_1 > 0 then
		table.dump(var_20_1, "NAMES", 2)

		return var_20_1
	end

	Script.set_temp_count(var_20_6, var_20_7, var_20_8)
	print(string.format("Search time: %f", tostring(os.clock() - var_20_0)))
end

function ChatView._play_sound(arg_21_0, arg_21_1)
	WwiseWorld.trigger_event(arg_21_0._wwise_world, arg_21_1)
end

function ChatView._update_recent_channels_input(arg_22_0, arg_22_1, arg_22_2)
	if table.is_empty(arg_22_0._recent_channels_widgets) then
		return
	end

	local var_22_0 = Managers.input:get_service("channels_list")
	local var_22_1 = arg_22_0._recent_channels_widgets.join_button
	local var_22_2 = arg_22_0._recent_channels_widgets.recent_channels_window

	UIWidgetUtils.animate_default_button(var_22_1, arg_22_1)

	local var_22_3 = var_22_1.content
	local var_22_4 = var_22_2.content
	local var_22_5 = var_22_3.button_hotspot
	local var_22_6 = var_22_4.screen_hotspot
	local var_22_7 = var_22_4.widget_hotspot
	local var_22_8 = var_22_4.close_hotspot
	local var_22_9 = var_22_4.list_hotspot

	if var_22_7.is_hover then
		if var_22_8.on_pressed then
			arg_22_0:_destroy_recent_channels_window()
		elseif var_22_5.on_pressed then
			if var_22_4.selected_channel ~= nil then
				local var_22_10 = false
				local var_22_11 = false

				arg_22_0:_destroy_recent_channels_window(true)
				Managers.chat:send_chat_message(1, nil, "/join " .. var_22_4.selected_channel, var_22_10, nil, var_22_11, arg_22_0._recent_message_index, var_22_4.selected_channel, Irc.CHANNEL_MSG)
			end
		else
			local var_22_12 = "channel_entry_"

			for iter_22_0 = 1, 5 do
				local var_22_13 = arg_22_0._recent_channels_widgets[var_22_12 .. iter_22_0]

				if var_22_13 then
					local var_22_14 = var_22_13.content

					if var_22_14.hotspot.on_pressed then
						if var_22_14.selected_channel then
							var_22_14.selected_channel = nil
							var_22_4.selected_channel = nil
						else
							var_22_14.selected_channel = var_22_14.channel_name
							var_22_4.selected_channel = var_22_14.channel_name
						end
					elseif var_22_14.selected_channel ~= var_22_4.selected_channel then
						var_22_14.selected_channel = nil
					end
				end
			end
		end

		if var_22_7.on_pressed and not var_22_9.is_hover then
			var_22_4.selected_channel = nil
		end
	elseif var_22_6.on_pressed then
		arg_22_0:_destroy_recent_channels_window()
	end

	var_22_5.disable_button = var_22_4.selected_channel == nil
end

function ChatView._create_recent_channels_window(arg_23_0)
	local var_23_0 = var_0_0.widget_definitions

	arg_23_0._recent_channels_widgets.recent_channels_window = UIWidget.init(var_23_0.recent_channels_window)

	local var_23_1 = UIWidget.init(var_23_0.recent_join_channel_button)

	var_23_1.content.button_hotspot.disable_button = true
	arg_23_0._recent_channels_widgets.join_button = var_23_1

	Managers.input:block_device_except_service("channels_list", "keyboard", 1, "channels_list")
	Managers.input:block_device_except_service("channels_list", "mouse", 1, "channels_list")
	Irc.list_channels()

	arg_23_0._list_channels_cbs[#arg_23_0._list_channels_cbs + 1] = callback(arg_23_0, "cb_populate_recent_channels")
	arg_23_0._recent_channels_widgets.recent_channels_window.content.fetching_channels = true
end

function ChatView.cb_populate_recent_channels(arg_24_0, arg_24_1, arg_24_2)
	if table.is_empty(arg_24_0._recent_channels_widgets) then
		return
	end

	local var_24_0 = arg_24_0._ui_scenegraph.recent_channels_window_list_box_entry.size
	local var_24_1 = var_0_0.channels_list_settings
	local var_24_2 = var_24_1.channels_width_spacing
	local var_24_3 = var_24_1.channels_height_spacing
	local var_24_4 = 0
	local var_24_5 = var_0_0.widget_definitions
	local var_24_6 = PlayerData.recent_irc_channels or {}

	for iter_24_0, iter_24_1 in ipairs(var_24_6) do
		local var_24_7 = arg_24_2[iter_24_1] or 0
		local var_24_8 = UIWidget.init(var_24_5.create_channel_list_entry_func("recent_channels_window_list_box_entry"))
		local var_24_9 = var_24_8.content
		local var_24_10 = var_24_8.style

		var_24_8.offset[2] = var_24_4
		var_24_9.channel_name = iter_24_1
		var_24_9.channel_name_id = UIRenderer.crop_text_width(arg_24_0._ui_renderer, iter_24_1, 160, var_24_10.channel_name)
		var_24_9.num_members_id = var_24_7 .. " Member(s)"
		var_24_10.icon.texture_size = {
			var_24_0[2] - var_24_2 * 2,
			var_24_0[2] - var_24_3 * 2
		}
		var_24_10.channel_name.offset[1] = var_24_0[2] - var_24_2 * 2 + var_24_2
		var_24_10.num_members.offset[1] = var_24_0[2] - var_24_2 * 2 + var_24_2
		var_24_10.background.size[1] = var_24_0[1]
		var_24_10.background.size[2] = var_24_0[2] - var_24_3
		arg_24_0._recent_channels_widgets["channel_entry_" .. iter_24_0] = var_24_8
		var_24_4 = var_24_4 - (var_24_0[2] + var_24_3)
	end

	arg_24_0._recent_channels_widgets.recent_channels_window.content.fetching_channels = false
end

function ChatView._destroy_recent_channels_window(arg_25_0, arg_25_1)
	table.clear(arg_25_0._recent_channels_widgets)

	if not arg_25_1 then
		arg_25_0:_create_channels_list()
	else
		Managers.input:device_unblock_service("keyboard", 1, "chat_view")
		Managers.input:device_unblock_service("mouse", 1, "chat_view")
	end
end

function ChatView._create_invite_window(arg_26_0)
	local var_26_0 = var_0_0.widget_definitions
	local var_26_1 = var_0_0.scenegraph_definition

	arg_26_0._invite_widgets.send_invite_window = UIWidget.init(var_26_0.send_invite_window)
	arg_26_0._invite_widgets.send_invite_button = UIWidget.init(var_26_0.send_invite_button)

	Managers.input:block_device_except_service("channels_list", "keyboard", 1, "channels_list")
	Managers.input:block_device_except_service("channels_list", "mouse", 1, "channels_list")

	arg_26_0._invite_widgets.send_invite_window.content.text_field_active = true
end

function ChatView._destroy_send_invite_window(arg_27_0)
	table.clear(arg_27_0._invite_widgets)
	Managers.input:device_unblock_service("keyboard", 1, "chat_view")
	Managers.input:device_unblock_service("mouse", 1, "chat_view")
end

function ChatView._update_send_invite_input(arg_28_0, arg_28_1, arg_28_2)
	if table.is_empty(arg_28_0._invite_widgets) then
		return
	end

	local var_28_0 = Managers.input:get_service("channels_list")
	local var_28_1 = arg_28_0._invite_widgets.send_invite_button
	local var_28_2 = arg_28_0._invite_widgets.send_invite_window
	local var_28_3 = var_28_1.content
	local var_28_4 = var_28_2.content
	local var_28_5 = var_28_3.button_hotspot
	local var_28_6 = var_28_4.input_hotspot
	local var_28_7 = var_28_4.screen_hotspot
	local var_28_8 = var_28_4.widget_hotspot
	local var_28_9 = var_28_4.close_hotspot

	var_28_5.disable_button = var_28_4.chat_text_id == ""

	UIWidgetUtils.animate_default_button(var_28_1, arg_28_1)

	if var_28_8.is_hover then
		if var_28_9.on_pressed then
			arg_28_0:_destroy_send_invite_window()
		elseif var_28_6.on_pressed then
			var_28_4.text_field_active = true
		elseif var_28_5.on_pressed then
			arg_28_0:_destroy_send_invite_window()

			local var_28_10 = arg_28_0._widgets.frame_widget.content

			var_28_10.chat_text.text = "/invite " .. var_28_4.chat_text_id

			arg_28_0:_send_message(var_28_10)
		elseif var_28_8.on_pressed then
			var_28_4.text_field_active = false
		end
	elseif var_28_7.on_pressed then
		arg_28_0:_destroy_send_invite_window()
	end

	if var_28_0:get("deactivate_chat_input") then
		arg_28_0:_destroy_send_invite_window()
	elseif var_28_4.text_field_active then
		if var_28_0:get("execute_chat_input") then
			if var_28_4.chat_text_id ~= "" then
				arg_28_0:_destroy_send_invite_window()
				arg_28_0:_destroy_send_invite_window()

				local var_28_11 = arg_28_0._widgets.frame_widget.content

				var_28_11.chat_text.text = "/invite " .. var_28_4.chat_text_id

				arg_28_0:_send_message(var_28_11)
			end

			var_28_4.text_field_active = false
			var_28_4.caret_index = 1
			var_28_4.text_index = 1
			var_28_4.chat_text_id = ""
		elseif var_28_4.caret_index < ChatView.MAX_CHARS then
			local var_28_12 = Keyboard.keystrokes()

			var_28_4.chat_text_id, var_28_4.caret_index = KeystrokeHelper.parse_strokes(var_28_4.chat_text_id, var_28_4.caret_index, "insert", var_28_12)
		elseif var_28_0:get("chat_backspace_pressed") then
			local var_28_13 = {
				Keyboard.BACKSPACE
			}

			var_28_4.chat_text_id, var_28_4.caret_index = KeystrokeHelper.parse_strokes(var_28_4.chat_text_id, var_28_4.caret_index, "insert", var_28_13)
		end
	end
end

function ChatView._create_create_channels_window(arg_29_0)
	local var_29_0 = var_0_0.widget_definitions
	local var_29_1 = var_0_0.scenegraph_definition

	arg_29_0._create_channel_widgets.create_channel_window = UIWidget.init(var_29_0.create_channel_window)
	arg_29_0._create_channel_widgets.create_button = UIWidget.init(var_29_0.inner_create_channel_button)

	Managers.input:block_device_except_service("channels_list", "keyboard", 1, "channels_list")
	Managers.input:block_device_except_service("channels_list", "mouse", 1, "channels_list")

	arg_29_0._create_channel_widgets.create_channel_window.content.text_field_active = true
end

function ChatView._destroy_create_channel_window(arg_30_0, arg_30_1)
	table.clear(arg_30_0._create_channel_widgets)
	Managers.input:device_unblock_service("keyboard", 1, "chat_view")
	Managers.input:device_unblock_service("mouse", 1, "chat_view")

	if not arg_30_1 then
		arg_30_0:_create_channels_list()
	end
end

function ChatView._update_create_channel_input(arg_31_0, arg_31_1, arg_31_2)
	if table.is_empty(arg_31_0._create_channel_widgets) then
		return
	end

	local var_31_0 = false
	local var_31_1 = false
	local var_31_2 = Managers.input:get_service("channels_list")
	local var_31_3 = arg_31_0._create_channel_widgets.create_button
	local var_31_4 = arg_31_0._create_channel_widgets.create_channel_window
	local var_31_5 = var_31_3.content
	local var_31_6 = var_31_4.content
	local var_31_7 = var_31_5.button_hotspot
	local var_31_8 = var_31_6.input_hotspot
	local var_31_9 = var_31_6.screen_hotspot
	local var_31_10 = var_31_6.widget_hotspot
	local var_31_11 = var_31_6.close_hotspot

	var_31_7.disable_button = var_31_6.chat_text_id == ""

	UIWidgetUtils.animate_default_button(var_31_3, arg_31_1)

	if var_31_10.is_hover then
		if var_31_11.on_pressed then
			arg_31_0:_destroy_create_channel_window()
		elseif var_31_8.on_pressed then
			var_31_6.text_field_active = true
		elseif var_31_7.on_pressed then
			arg_31_0:_destroy_create_channel_window(true)
			Managers.chat:send_chat_message(1, nil, "/join #" .. var_31_6.chat_text_id, var_31_0, nil, var_31_1, arg_31_0._recent_message_index, var_31_6.chat_text_id, Irc.CHANNEL_MSG)
		elseif var_31_10.on_pressed then
			var_31_6.text_field_active = false
		end
	elseif var_31_9.on_pressed then
		arg_31_0:_destroy_create_channel_window()
	end

	if var_31_2:get("deactivate_chat_input") then
		arg_31_0:_destroy_create_channel_window()
	elseif var_31_6.text_field_active then
		if var_31_2:get("execute_chat_input") then
			if var_31_6.chat_text_id ~= "" then
				arg_31_0:_destroy_create_channel_window(true)
				Managers.chat:send_chat_message(1, nil, "/join #" .. var_31_6.chat_text_id, var_31_0, nil, var_31_1, arg_31_0._recent_message_index, var_31_6.chat_text_id, Irc.CHANNEL_MSG)
			end

			var_31_6.text_field_active = false
			var_31_6.caret_index = 1
			var_31_6.text_index = 1
			var_31_6.chat_text_id = ""
		elseif var_31_6.caret_index < ChatView.MAX_CHANNEL_NAME then
			local var_31_12 = Keyboard.keystrokes()

			var_31_6.chat_text_id, var_31_6.caret_index = KeystrokeHelper.parse_strokes(var_31_6.chat_text_id, var_31_6.caret_index, "insert", var_31_12)

			for iter_31_0, iter_31_1 in ipairs(ESCAPE_CHARACTERS) do
				var_31_6.chat_text_id = string.gsub(var_31_6.chat_text_id, "%" .. iter_31_1, "")
			end

			var_31_6.chat_text_id = string.format(var_31_6.chat_text_id, "%w")
			var_31_6.chat_text_id = string.gsub(var_31_6.chat_text_id, "%s", "")
			var_31_6.caret_index = UTF8Utils.string_length(var_31_6.chat_text_id) + 1
		elseif var_31_2:get("chat_backspace_pressed") then
			local var_31_13 = {
				Keyboard.BACKSPACE
			}

			var_31_6.chat_text_id, var_31_6.caret_index = KeystrokeHelper.parse_strokes(var_31_6.chat_text_id, var_31_6.caret_index, "insert", var_31_13)
		end
	end
end

local var_0_8 = {}

function ChatView._create_channels_list(arg_32_0)
	local var_32_0 = var_0_0.widget_definitions
	local var_32_1 = var_0_0.scenegraph_definition

	arg_32_0._channels_list_widgets.channel_window_widget = UIWidget.init(var_32_0.channels_window)

	local var_32_2 = Managers.input
	local var_32_3 = var_32_2:get_service("channels_list")

	var_32_2:block_device_except_service("channels_list", "keyboard", 1, "channels_list")
	var_32_2:block_device_except_service("channels_list", "mouse", 1, "channels_list")

	local var_32_4 = UIWidget.init(var_32_0.channel_entry)

	arg_32_0._channels_list_widgets.channel_entry = var_32_4

	local var_32_5 = var_32_4.style
	local var_32_6 = var_32_5.icon
	local var_32_7 = var_32_5.channel_name
	local var_32_8 = var_32_5.num_members
	local var_32_9 = var_32_5.background
	local var_32_10 = arg_32_0._ui_scenegraph
	local var_32_11 = var_32_10[var_32_10[var_32_4.scenegraph_id].parent].size
	local var_32_12 = var_0_0.channels_list_settings
	local var_32_13 = var_32_12.channels_width_spacing
	local var_32_14 = var_32_12.channels_height_spacing
	local var_32_15 = var_32_12.channels_offset
	local var_32_16 = var_32_12.channels_per_row
	local var_32_17 = var_32_12.max_rows
	local var_32_18 = var_32_11[1] - var_32_15[1] * 2 - (var_32_16 - 1) * var_32_13
	local var_32_19 = var_32_11[2] - -var_32_15[2] * 2 - (var_32_17 - 3) * var_32_14
	local var_32_20 = var_32_18 / var_32_16
	local var_32_21 = var_32_19 / (var_32_17 - 2)

	var_32_12.channels_entry_size = {
		var_32_20,
		var_32_21
	}
	var_32_6.texture_size = {
		var_32_21 - var_32_13 * 2,
		var_32_21 - var_32_14 * 2
	}
	var_32_7.offset[1] = var_32_21 - var_32_13 * 2 + var_32_13
	var_32_8.offset[1] = var_32_21 - var_32_13 * 2 + var_32_13
	var_32_9.size[1] = var_32_12.channels_entry_size[1]
	var_32_9.size[2] = var_32_12.channels_entry_size[2] - var_32_14

	local var_32_22 = var_32_4.style
	local var_32_23 = var_32_10[var_32_4.scenegraph_id]

	var_32_23.size[1] = var_32_12.channels_entry_size[1]
	var_32_23.size[2] = var_32_12.channels_entry_size[2]

	local var_32_24 = UIWidget.init(var_32_0.join_channel_button)

	arg_32_0._channels_list_widgets.join_button = var_32_24
	var_32_24.content.button_hotspot.disable_button = true

	local var_32_25 = UIWidget.init(var_32_0.create_channel_button)

	arg_32_0._channels_list_widgets.create_channel_button = var_32_25

	local var_32_26 = UIWidget.init(var_32_0.recent_channels_button)

	arg_32_0._channels_list_widgets.recent_channels_button = var_32_26

	table.clear(arg_32_0._popular_channel_list)
	table.clear(arg_32_0._popular_channel_list_lookup)
	Irc.list_channels()

	arg_32_0._list_channels_cbs[#arg_32_0._list_channels_cbs + 1] = callback(arg_32_0, "cb_populate_channels_list", nil)
	arg_32_0._channels_list_widgets.channel_window_widget.content.fetching_channels = true
end

function ChatView._destroy_channels_list(arg_33_0)
	table.clear(var_0_8)
	table.clear(arg_33_0._channels_list_widgets)
	Managers.input:device_unblock_service("keyboard", 1, "chat_view")
	Managers.input:device_unblock_service("mouse", 1, "chat_view")
end

function ChatView.cb_populate_channels_list(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if table.is_empty(arg_34_0._channels_list_widgets) then
		return
	end

	table.clear(var_0_8)

	local var_34_0 = var_0_0.channels_list_settings
	local var_34_1 = arg_34_0._channels_list_widgets.channel_window_widget.content

	var_34_1.updating_channels = false
	var_34_1.info_id = string.format("Search results for %q", arg_34_1)

	for iter_34_0, iter_34_1 in ipairs(arg_34_2) do
		if not arg_34_1 or string.find(iter_34_1, arg_34_1) then
			var_0_8[#var_0_8 + 1] = iter_34_1
		end
	end

	var_34_0.current_rows = math.ceil(#var_0_8 / var_34_0.channels_per_row)
	arg_34_0._channels_list_widgets.channel_window_widget.content.fetching_channels = false
end

function ChatView._handle_and_draw_channels_list(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	local var_35_0 = var_0_0.channels_list_settings
	local var_35_1 = arg_35_0._channels_list_widgets.channel_window_widget

	UIRenderer.draw_widget(arg_35_1, var_35_1)

	local var_35_2 = arg_35_0._channels_list_widgets.join_button
	local var_35_3 = arg_35_0._channels_list_widgets.create_channel_button
	local var_35_4 = arg_35_0._channels_list_widgets.recent_channels_button

	UIRenderer.draw_widget(arg_35_1, var_35_2)
	UIRenderer.draw_widget(arg_35_1, var_35_3)
	UIRenderer.draw_widget(arg_35_1, var_35_4)

	local var_35_5 = math.min(var_35_0.current_rows or 0, var_35_0.max_rows)
	local var_35_6 = var_35_0.channels_width_spacing
	local var_35_7 = var_35_0.channels_height_spacing
	local var_35_8 = var_35_0.channels_per_row
	local var_35_9 = var_35_0.channels_entry_size
	local var_35_10 = arg_35_0._channels_list_widgets.channel_entry
	local var_35_11 = var_35_10.content
	local var_35_12 = var_35_10.style
	local var_35_13 = var_35_10.offset
	local var_35_14 = var_35_0.channels_offset

	var_35_13[2] = var_35_14[2]

	local var_35_15

	for iter_35_0 = 1, math.min(var_35_5, 4) do
		var_35_13[2] = var_35_14[2] - (iter_35_0 - 1) * var_35_9[2] - (iter_35_0 - 1) * var_35_7

		for iter_35_1 = 1, var_35_8 do
			local var_35_16 = (iter_35_0 - 1) * var_35_8 + iter_35_1

			if not var_0_8[var_35_16] then
				break
			else
				local var_35_17 = string.split_deprecated(var_0_8[var_35_16], ",")

				var_35_11.channel_name = var_35_17[1]
				var_35_11.channel_name_id = UIRenderer.crop_text_width(arg_35_0._ui_renderer, var_35_11.channel_name, 160, var_35_12.channel_name)
				var_35_11.num_members_id = var_35_17[2] .. " Member(s)"
			end

			var_35_13[1] = var_35_14[1] + (iter_35_1 - 1) * var_35_9[1] + (iter_35_1 - 1) * var_35_6

			UIRenderer.draw_widget(arg_35_1, var_35_10)

			if var_35_11.hotspot.on_pressed then
				if var_35_11.selected_channel == var_35_11.channel_name then
					var_35_11.selected_channel = nil
				else
					var_35_11.selected_channel = var_35_11.channel_name
				end
			end
		end
	end

	var_35_2.content.button_hotspot.disable_button = var_35_11.selected_channel == nil
end

function ChatView._update_channels_list_input(arg_36_0, arg_36_1, arg_36_2)
	if table.is_empty(arg_36_0._channels_list_widgets) then
		return
	end

	local var_36_0 = Managers.input:get_service("channels_list")
	local var_36_1 = arg_36_0._channels_list_widgets.channel_entry
	local var_36_2 = arg_36_0._channels_list_widgets.join_button
	local var_36_3 = arg_36_0._channels_list_widgets.create_channel_button
	local var_36_4 = arg_36_0._channels_list_widgets.recent_channels_button
	local var_36_5 = arg_36_0._channels_list_widgets.channel_window_widget.content
	local var_36_6 = var_36_2.content
	local var_36_7 = var_36_3.content
	local var_36_8 = var_36_4.content
	local var_36_9 = var_36_1.content
	local var_36_10 = var_36_5.input_hotspot
	local var_36_11 = var_36_5.screen_hotspot
	local var_36_12 = var_36_5.widget_hotspot
	local var_36_13 = var_36_5.close_hotspot
	local var_36_14 = var_36_6.button_hotspot
	local var_36_15 = var_36_7.button_hotspot
	local var_36_16 = var_36_8.button_hotspot
	local var_36_17 = var_36_5.channels_list_hotspot

	if var_36_5.updating_channels then
		return
	end

	UIWidgetUtils.animate_default_button(var_36_2, arg_36_1)
	UIWidgetUtils.animate_default_button(var_36_3, arg_36_1)
	UIWidgetUtils.animate_default_button(var_36_4, arg_36_1)

	if var_36_0:get("deactivate_chat_input") then
		arg_36_0:_destroy_channels_list()
	elseif var_36_10.on_pressed then
		var_36_5.text_field_active = true
	elseif var_36_12.is_hover then
		if var_36_13.on_pressed then
			var_36_5.text_field_active = false

			arg_36_0:_destroy_channels_list()
		elseif var_36_14.on_pressed then
			local var_36_18 = var_36_9.selected_channel

			arg_36_0:_destroy_channels_list()

			if arg_36_0._channels[var_36_18] then
				arg_36_0:_change_channel(var_36_18)
			else
				local var_36_19 = false
				local var_36_20 = false

				Managers.chat:send_chat_message(1, nil, "/join " .. var_36_18, var_36_19, nil, var_36_20, arg_36_0._recent_message_index, var_36_18, Irc.CHANNEL_MSG)
			end
		elseif var_36_15.on_pressed then
			arg_36_0:_destroy_channels_list()
			arg_36_0:_create_create_channels_window()
		elseif var_36_16.on_pressed then
			arg_36_0:_destroy_channels_list()
			arg_36_0:_create_recent_channels_window()
		elseif var_36_12.on_pressed then
			var_36_5.text_field_active = false
		end
	elseif var_36_11.on_pressed then
		arg_36_0:_destroy_channels_list()
	end

	if var_36_5.text_field_active then
		if var_36_0:get("execute_chat_input") then
			if var_36_5.chat_text_id ~= "" then
				table.clear(arg_36_0._popular_channel_list)
				table.clear(arg_36_0._popular_channel_list_lookup)
				Irc.list_channels()

				arg_36_0._list_channels_cbs[#arg_36_0._list_channels_cbs + 1] = callback(arg_36_0, "cb_populate_channels_list", var_36_5.chat_text_id)
			end

			var_36_5.text_field_active = false
			var_36_5.caret_index = 1
			var_36_5.text_index = 1
			var_36_5.chat_text_id = ""
		elseif var_36_5.caret_index < ChatView.MAX_CHANNEL_NAME then
			local var_36_21 = Keyboard.keystrokes()

			if not table.is_empty(var_36_21) then
				var_36_5.chat_text_id, var_36_5.caret_index = KeystrokeHelper.parse_strokes(var_36_5.chat_text_id, var_36_5.caret_index, "insert", var_36_21)

				for iter_36_0, iter_36_1 in ipairs(ESCAPE_CHARACTERS) do
					var_36_5.chat_text_id = string.gsub(var_36_5.chat_text_id, "%" .. iter_36_1, "")
				end

				var_36_5.chat_text_id = string.format(var_36_5.chat_text_id, "%w")
				var_36_5.chat_text_id = string.gsub(var_36_5.chat_text_id, "%s", "")
				var_36_5.caret_index = UTF8Utils.string_length(var_36_5.chat_text_id) + 1
			end
		elseif var_36_0:get("chat_backspace_pressed") then
			local var_36_22 = {
				Keyboard.BACKSPACE
			}

			var_36_5.chat_text_id, var_36_5.caret_index = KeystrokeHelper.parse_strokes(var_36_5.chat_text_id, var_36_5.caret_index, "insert", var_36_22)
		end
	end
end

function ChatView._update_input(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0._input_manager:get_service("chat_view")

	arg_37_0:_handle_user_pressed()
	arg_37_0:_handle_user_list_scroll_input(var_37_0)
	arg_37_0:_handle_link_presses()

	local var_37_1 = arg_37_0._widgets.frame_widget.content
	local var_37_2 = arg_37_0._channel_list_widgets.channel_list_frame
	local var_37_3 = arg_37_0._private_list_widgets.private_user_list_frame
	local var_37_4 = arg_37_0._recent_channels_list_widgets.recent_channels_list_frame
	local var_37_5 = arg_37_0._commands_list_widgets.command_list_frame
	local var_37_6 = arg_37_0._filtered_user_names_list_widgets.filtered_user_names_list_frame
	local var_37_7 = arg_37_0._emoji_widgets.emoji_list_frame

	var_37_1.channel_name = arg_37_0._current_channel_name or " "

	if var_37_0:get("deactivate_chat_input", true) then
		if var_37_1.text_field_active then
			var_37_1.text_field_active = false
			var_37_1.chat_text.text = ""
		else
			arg_37_0:_exit(true)

			return
		end
	end

	local var_37_8 = false
	local var_37_9 = false
	local var_37_10 = var_37_1.text_input_hotspot
	local var_37_11 = var_37_1.screen_hotspot
	local var_37_12 = var_37_1.channel_hotspot
	local var_37_13 = var_37_1.left_hotspot
	local var_37_14 = var_37_1.right_hotspot
	local var_37_15 = arg_37_0._widgets.private_messages_widget.content.button_hotspot
	local var_37_16 = arg_37_0._widgets.send_invite_widget.content.button_hotspot
	local var_37_17 = arg_37_0._widgets.channels_widget.content.button_hotspot
	local var_37_18 = arg_37_0._widgets.emoji_widget.content.button_hotspot

	if var_37_5 then
		local var_37_19 = var_37_5.content
		local var_37_20 = var_37_19.hotspot
		local var_37_21 = var_37_19.screen_hotspot

		if var_37_20.on_pressed then
			arg_37_0:_handle_command_list_input()
		elseif var_37_21.on_pressed then
			arg_37_0:_destroy_command_list()
		end
	elseif var_37_7 then
		local var_37_22 = var_37_7.content
		local var_37_23 = var_37_22.hotspot

		if var_37_22.screen_hotspot.on_pressed and not var_37_23.on_pressed then
			arg_37_0:_destroy_emoji_list()
		else
			arg_37_0:_handle_and_draw_emoji_list_input(arg_37_1)
		end
	elseif var_37_6 then
		local var_37_24 = var_37_6.content
		local var_37_25 = var_37_24.hotspot
		local var_37_26 = var_37_24.screen_hotspot

		if var_37_25.on_pressed then
			arg_37_0:_handle_filtered_user_names_list_input()
		elseif var_37_26.on_pressed then
			arg_37_0:_destroy_filtered_user_names_list()
		end
	elseif var_37_2 then
		local var_37_27 = var_37_2.content
		local var_37_28 = var_37_27.hotspot
		local var_37_29 = var_37_27.screen_hotspot

		if var_37_28.on_pressed then
			arg_37_0:_handle_channel_list_input()
		elseif var_37_29.on_pressed then
			arg_37_0:_destroy_channel_list()
		end
	elseif var_37_3 then
		local var_37_30 = var_37_3.content
		local var_37_31 = var_37_30.hotspot
		local var_37_32 = var_37_30.screen_hotspot

		if var_37_31.on_pressed then
			arg_37_0:_handle_private_list_input()
		elseif var_37_32.on_pressed then
			arg_37_0:_destroy_private_list()
		end
	elseif var_37_18.on_pressed then
		arg_37_0:_create_emoji_list()
	elseif var_37_12.on_pressed then
		arg_37_0:_create_channel_list()

		var_37_8 = true
		var_37_9 = true
	elseif var_37_17.on_pressed then
		arg_37_0:_create_channels_list()

		var_37_8 = true
		var_37_9 = true
	elseif var_37_15.on_pressed then
		arg_37_0:_create_private_list()

		var_37_8 = true
		var_37_9 = true
	elseif var_37_16.on_pressed then
		arg_37_0:_create_invite_window()

		var_37_8 = true
		var_37_9 = true
	elseif var_37_10.on_pressed then
		var_37_1.text_field_active = true
	elseif var_37_11.on_pressed then
		var_37_8 = true
		var_37_9 = true
	elseif var_37_13.on_release then
		arg_37_0._current_tab_offset_index = math.max(arg_37_0._current_tab_offset_index - 1, 1)
		arg_37_0._ui_animations.tab_animation = UIAnimation.init(UIAnimation.function_by_time, arg_37_0._ui_scenegraph.channel_tab_anchor.position, 1, arg_37_0._ui_scenegraph.channel_tab_anchor.position[1], -arg_37_0._ui_scenegraph.channel_tab_anchor.size[1] * (arg_37_0._current_tab_offset_index - 1) + 10, 0.25, math.easeOutCubic)
	elseif var_37_14.on_release then
		arg_37_0._current_tab_offset_index = math.min(arg_37_0._current_tab_offset_index + 1, math.max(#arg_37_0._channel_tabs - 3, 1))

		print(arg_37_0._current_tab_offset_index)

		arg_37_0._ui_animations.tab_animation = UIAnimation.init(UIAnimation.function_by_time, arg_37_0._ui_scenegraph.channel_tab_anchor.position, 1, arg_37_0._ui_scenegraph.channel_tab_anchor.position[1], -arg_37_0._ui_scenegraph.channel_tab_anchor.size[1] * (arg_37_0._current_tab_offset_index - 1) + 10, 0.25, math.easeOutCubic)
	end

	local var_37_33 = arg_37_0._widgets.send_invite_widget
	local var_37_34 = arg_37_0._widgets.channels_widget
	local var_37_35 = arg_37_0._widgets.commands_widget
	local var_37_36 = arg_37_0._widgets.emoji_widget

	UIWidgetUtils.animate_default_button(var_37_33, arg_37_1)
	UIWidgetUtils.animate_default_button(var_37_34, arg_37_1)
	UIWidgetUtils.animate_default_button(var_37_35, arg_37_1)
	UIWidgetUtils.animate_default_button(var_37_36, arg_37_1)

	if var_37_1.text_field_active then
		if var_37_0:get("execute_chat_input") then
			arg_37_0:_send_message(var_37_1)
		elseif var_37_0:get("chat_next_old_message") then
			local var_37_37 = Managers.chat:get_recently_sent_messages()
			local var_37_38 = #var_37_37

			if var_37_38 > 0 then
				if not arg_37_0._recent_message_index then
					if string.len(var_37_1.chat_text.text) > 0 then
						arg_37_0._old_chat_message = var_37_1.chat_text.text
					end

					arg_37_0._recent_message_index = var_37_38
				else
					arg_37_0._recent_message_index = math.max(arg_37_0._recent_message_index - 1, 1)
				end

				var_37_1.chat_text.text = var_37_37[arg_37_0._recent_message_index]
				var_37_1.caret_index = #KeystrokeHelper._build_utf8_table(var_37_1.chat_text.text) + 1
			end
		elseif var_37_0:get("chat_previous_old_message") then
			local var_37_39 = Managers.chat:get_recently_sent_messages()
			local var_37_40 = #var_37_39

			if arg_37_0._recent_message_index then
				if var_37_40 > 0 and var_37_40 > arg_37_0._recent_message_index then
					arg_37_0._recent_message_index = math.clamp(arg_37_0._recent_message_index + 1, 1, var_37_40)
					var_37_1.chat_text.text = var_37_39[arg_37_0._recent_message_index]
					var_37_1.caret_index = #KeystrokeHelper._build_utf8_table(var_37_1.chat_text.text) + 1
				elseif arg_37_0.recent_message_index == var_37_40 and arg_37_0._old_chat_message then
					var_37_1.chat_text.text = arg_37_0._old_chat_message
					var_37_1.caret_index = #KeystrokeHelper._build_utf8_table(var_37_1.chat_text.text) + 1
					arg_37_0._recent_message_index = nil
					arg_37_0._old_chat_message = nil
				end
			end
		elseif var_37_0:get("chat_backspace_word") then
			local var_37_41 = KeystrokeHelper._build_utf8_table(var_37_1.chat_text.text)
			local var_37_42 = var_37_1.caret_index - 1
			local var_37_43 = false
			local var_37_44 = 0

			for iter_37_0 = var_37_42, 1, -1 do
				local var_37_45 = var_37_41[iter_37_0]

				if var_37_41[iter_37_0] == " " and var_37_43 then
					var_37_42 = iter_37_0 + 1

					break
				else
					table.remove(var_37_41, iter_37_0)

					var_37_42 = iter_37_0

					if var_37_41[iter_37_0] ~= " " then
						var_37_43 = true
					end
				end
			end

			var_37_1.caret_index = math.clamp(var_37_42, 1, #var_37_41 + 1)
			var_37_1.chat_text.text = ""

			local var_37_46 = 0

			for iter_37_1, iter_37_2 in ipairs(var_37_41) do
				var_37_1.chat_text.text = var_37_1.chat_text.text .. iter_37_2
				var_37_46 = var_37_46 + 1
			end
		elseif var_37_1.caret_index <= ChatView.MAX_CHARS then
			local var_37_47 = Keyboard.keystrokes()
			local var_37_48 = Keyboard.button_index("left ctrl")

			if not Keyboard.pressed(var_37_48) then
				local var_37_49

				var_37_49 = Keyboard.button(var_37_48) > 0
			end

			var_37_1.chat_text.text, var_37_1.caret_index = KeystrokeHelper.parse_strokes(var_37_1.chat_text.text, var_37_1.caret_index, "insert", var_37_47)

			if #var_37_47 > 0 then
				local var_37_50 = var_37_1.chat_text.text
				local var_37_51, var_37_52 = string.find(var_37_50, "/msg ")
				local var_37_53, var_37_54 = string.find(var_37_50, " ", (var_37_52 or 0) + 1)

				if var_37_52 and not var_37_53 then
					local var_37_55 = string.lower(string.gsub(var_37_50, "/msg ", ""))

					arg_37_0:_create_filtered_user_list(var_37_55)
				end
			end
		end
	elseif var_37_0:get("execute_chat_input") then
		var_37_1.text_field_active = true
	end

	if var_37_8 then
		var_37_1.text_field_active = false

		if var_37_9 then
			var_37_1.chat_text.text = ""
			var_37_1.caret_index = 1
		end
	end
end

function ChatView._handle_command_list(arg_38_0)
	local var_38_0 = arg_38_0._widgets.frame_widget.content
	local var_38_1 = arg_38_0._widgets.commands_widget.content.button_hotspot

	if not var_38_1.on_pressed and not var_38_1.disable_button then
		if #Keyboard.keystrokes() == 0 then
			return
		end

		local var_38_2 = var_38_0.chat_text.text
		local var_38_3, var_38_4 = string.find(var_38_2, "/")
		local var_38_5 = string.find(var_38_2, " ")
		local var_38_6 = string.len(var_38_2)

		if not var_38_2 or string.find(var_38_2, "/") ~= 1 or var_38_5 then
			table.clear(arg_38_0._commands_list_widgets)

			return
		end

		arg_38_0._ui_scenegraph.commands_list.position[1] = 25
	else
		var_38_1.disable_button = true
		arg_38_0._ui_scenegraph.commands_list.position[1] = -60
	end

	if table.size(arg_38_0._commands_list_widgets) == 0 then
		local var_38_7 = var_0_0.widget_definitions
		local var_38_8 = var_38_7.create_command_entry_func
		local var_38_9 = 0
		local var_38_10 = 0
		local var_38_11 = 100

		for iter_38_0, iter_38_1 in ipairs(var_0_5) do
			local var_38_12 = iter_38_1.command
			local var_38_13 = UIWidget.init(var_38_8(var_38_12, iter_38_1.description_text, iter_38_1.parameter, var_38_11, iter_38_1.color, -20 - 20 * var_38_9, var_38_0.chat_text))

			arg_38_0._commands_list_widgets["command_" .. var_38_9 + 1] = var_38_13
			var_38_9 = var_38_9 + 1

			local var_38_14 = var_38_13.style.command
			local var_38_15, var_38_16 = UIFontByResolution(var_38_14, nil)
			local var_38_17 = var_38_15[1]
			local var_38_18 = var_38_14.font_size
			local var_38_19 = UIRenderer.text_size(arg_38_0._ui_renderer, var_38_12 .. iter_38_1.description_text, var_38_17, var_38_18) + 100

			var_38_10 = math.max(var_38_10, var_38_19)
		end

		arg_38_0._commands_list_widgets.command_list_frame = UIWidget.init(var_38_7.commands_list_frame)
		arg_38_0._ui_scenegraph.commands_list.size[2] = 40 + var_38_9 * 20
		arg_38_0._ui_scenegraph.commands_list.size[1] = var_38_10 + 10
		arg_38_0._ui_scenegraph.commands_list_entry.size[1] = var_38_10 + 20
	end
end

function ChatView._create_channel_list(arg_39_0)
	local var_39_0 = Managers.irc:get_channels()
	local var_39_1 = var_0_0.widget_definitions
	local var_39_2 = var_39_1.create_channel_entry_func
	local var_39_3 = 0
	local var_39_4 = 200
	local var_39_5 = 0

	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		local var_39_6 = UIWidget.init(var_39_2(iter_39_0, -10 - 30 * var_39_3))

		arg_39_0._channel_list_widgets["channel_" .. var_39_3 + 1] = var_39_6
		var_39_3 = var_39_3 + 1

		local var_39_7 = var_39_6.style.channel_name
		local var_39_8, var_39_9 = UIFontByResolution(var_39_7, nil)
		local var_39_10 = var_39_8[1]
		local var_39_11 = var_39_7.font_size
		local var_39_12 = UIRenderer.text_size(arg_39_0._ui_renderer, iter_39_0, var_39_10, var_39_11)

		var_39_5 = math.max(var_39_5, var_39_12)
	end

	arg_39_0._channel_list_widgets.channel_list_frame = UIWidget.init(var_39_1.channel_list_frame)
	arg_39_0._ui_scenegraph.channel_list.size[2] = 30 + var_39_3 * 30
	arg_39_0._ui_scenegraph.channel_list.size[1] = var_39_5 + 125
	arg_39_0._ui_scenegraph.channel_list_entry.size[1] = var_39_5 + 30
end

function ChatView._destroy_emoji_list(arg_40_0)
	table.clear(arg_40_0._emoji_widgets)

	arg_40_0._base_offset = 0
end

function ChatView._create_emoji_list(arg_41_0)
	local var_41_0 = var_0_0.widget_definitions

	table.clear(arg_41_0._emoji_widgets)

	arg_41_0._emoji_widgets.emoji_list_frame = UIWidget.init(var_41_0.create_emoji_frame_func())
	arg_41_0._emoji_widgets.emoji = UIWidget.init(var_41_0.create_emoji_func())

	local var_41_1 = var_0_0.emoji_list_settings
	local var_41_2 = #EMOJI_SETTINGS

	var_41_1.current_rows = math.ceil(var_41_2 / var_41_1.emojis_per_row)

	local var_41_3 = arg_41_0._ui_renderer
	local var_41_4 = arg_41_0._ui_scenegraph
	local var_41_5 = arg_41_0._input_manager:get_service("chat_view")
	local var_41_6 = arg_41_0._render_settings
	local var_41_7 = arg_41_0._emoji_widgets.emoji
	local var_41_8 = var_41_4[var_41_7.scenegraph_id]
	local var_41_9 = var_41_1.max_rows - 1
	local var_41_10 = (var_41_9 + 2) * var_41_8.size[2] + (var_41_9 - 1) * var_41_1.emoji_height_spacing

	var_41_7.offset[2] = var_41_10
	var_41_1.height = var_41_10

	local var_41_11 = arg_41_0._emoji_widgets.emoji_list_frame
	local var_41_12 = var_41_11.content
	local var_41_13 = var_41_11.style
	local var_41_14 = var_41_4[var_41_11.scenegraph_id]

	var_41_14.size = {
		var_41_1.emoji_size[1] * var_41_1.emojis_per_row + (var_41_1.emojis_per_row - 1) * var_41_1.emoji_width_spacing + var_41_1.emoji_offset[1] * 2 + 20,
		var_41_10 + var_41_1.emoji_offset[2] * 2
	}
	var_41_13.mask_rect.offset[2] = var_41_1.emoji_size[2] + var_41_1.emoji_height_spacing * 3
	var_41_13.mask_rect.size = {
		var_41_14.size[1],
		var_41_14.size[2] - (var_41_1.emoji_size[2] + var_41_1.emoji_height_spacing * 3)
	}

	local var_41_15 = UIWidget.init(var_41_0.create_emoji_scroller_func())

	var_41_4[var_41_15.scenegraph_id].size[2] = var_41_10 / var_41_1.max_rows

	if var_41_1.current_rows > var_41_1.max_rows then
		arg_41_0._emoji_widgets.emoji_scrollbar = var_41_15
	end
end

function ChatView._handle_and_draw_emoji_list_input(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._ui_renderer
	local var_42_1 = arg_42_0._ui_scenegraph
	local var_42_2 = arg_42_0._input_manager:get_service("chat_view")
	local var_42_3 = arg_42_0._render_settings
	local var_42_4 = var_0_0.emoji_list_settings
	local var_42_5 = arg_42_0._emoji_widgets.emoji
	local var_42_6 = var_42_5.content
	local var_42_7 = var_42_5.offset
	local var_42_8 = arg_42_0._emoji_widgets.emoji_list_frame
	local var_42_9 = var_42_8.content
	local var_42_10 = var_42_8.style
	local var_42_11 = false
	local var_42_12 = var_42_4.current_rows
	local var_42_13 = var_42_4.emojis_per_row
	local var_42_14 = var_42_4.emoji_size
	local var_42_15 = var_42_4.emoji_offset
	local var_42_16 = var_42_4.emoji_width_spacing
	local var_42_17 = var_42_4.emoji_height_spacing
	local var_42_18 = var_42_4.height
	local var_42_19 = var_42_4.max_rows
	local var_42_20 = math.max(var_42_19, var_42_12)
	local var_42_21 = arg_42_0._emoji_widgets.emoji_scrollbar

	arg_42_0._emoji_scroll = 0

	if var_42_21 then
		local var_42_22 = var_42_2:get("chat_scroll")[2]

		arg_42_0._emoji_scroll = math.abs(var_42_22) > math.abs(arg_42_0._emoji_scroll) and var_42_22 or arg_42_0._emoji_scroll
	end

	local var_42_23 = var_42_12 * var_42_14[2] + (var_42_12 - 1) * var_42_15[2]

	arg_42_0._base_offset = math.clamp((arg_42_0._base_offset or 0) - arg_42_0._emoji_scroll, 0, var_42_23)

	local var_42_24 = math.floor(arg_42_0._base_offset / (var_42_14[2] + var_42_15[2]))

	arg_42_0._emoji_scroll = math.lerp(math.abs(arg_42_0._emoji_scroll), 0, arg_42_1 * 2.5) * math.sign(arg_42_0._emoji_scroll)
	var_42_7[2] = var_42_18 + arg_42_0._base_offset % (var_42_14[2] + var_42_15[2])

	if var_42_21 then
		var_42_21.offset[2] = -(arg_42_0._base_offset / var_42_23) * ((var_42_20 - 2) * (var_42_14[2] + var_42_15[2]) + 15)
	end

	UIRenderer.begin_pass(var_42_0, var_42_1, var_42_2, arg_42_1, nil, nil)

	if var_42_21 then
		UIRenderer.draw_widget(var_42_0, var_42_21)
	end

	UIRenderer.draw_widget(var_42_0, var_42_8)

	local var_42_25 = false

	for iter_42_0 = 1 + var_42_24, var_42_20 + var_42_24 do
		var_42_7[2] = var_42_7[2] - var_42_14[2] - var_42_15[2]

		for iter_42_1 = 1, var_42_13 do
			var_42_7[1] = (iter_42_1 - 1) * (var_42_14[1] + var_42_16)

			local var_42_26 = (iter_42_0 - 1) * var_42_13 + iter_42_1
			local var_42_27 = EMOJI_SETTINGS[var_42_26]

			var_42_6.texture_id = var_42_27 and var_42_27.texture or nil

			UIRenderer.draw_widget(var_42_0, var_42_5)

			if var_42_27 then
				local var_42_28 = var_42_6.hotspot

				if var_42_28.on_pressed then
					local var_42_29 = EMOJI_SETTINGS[var_42_26].keys
					local var_42_30 = arg_42_0._widgets.frame_widget.content

					var_42_30.chat_text.text = var_42_30.chat_text.text .. var_42_29
					var_42_30.caret_index = #KeystrokeHelper._build_utf8_table(var_42_30.chat_text.text) + 1
					arg_42_0._widgets.frame_widget.content.text_field_active = true
					var_42_11 = true
				elseif var_42_28.is_hover then
					var_42_25 = true
					var_42_9.emoji_text_id = EMOJI_SETTINGS[var_42_26].keys
					var_42_9.emoji_texture_id = EMOJI_SETTINGS[var_42_26].texture
					var_42_10.emoji_texture.texture_size = var_42_14
					var_42_10.emoji_texture.offset[1] = 10
					var_42_10.emoji_text.offset[1] = var_42_10.emoji_texture.offset[1] + var_42_14[1] + var_42_16
				end
			end
		end

		var_42_7[2] = var_42_7[2] - var_42_17
	end

	var_42_6.texture_id = nil

	if not var_42_25 then
		var_42_9.emoji_text_id = nil
		var_42_9.emoji_texture_id = nil
	end

	UIRenderer.end_pass(var_42_0)

	if var_42_11 then
		arg_42_0:_destroy_emoji_list()
	end
end

function ChatView._create_private_list(arg_43_0)
	local var_43_0 = arg_43_0._widgets.chat_output_widget.content.private_messages_table
	local var_43_1 = var_0_0.widget_definitions
	local var_43_2 = var_43_1.create_private_user_entry_func
	local var_43_3 = arg_43_0._widgets.private_messages_widget.content
	local var_43_4 = var_43_3.new_per_user
	local var_43_5 = 0
	local var_43_6 = 200
	local var_43_7 = 0

	for iter_43_0, iter_43_1 in pairs(var_43_0) do
		local var_43_8 = UIWidget.init(var_43_2(iter_43_0, -20 - 30 * var_43_5, var_43_4[iter_43_0]))

		arg_43_0._private_list_widgets[iter_43_0] = var_43_8
		var_43_5 = var_43_5 + 1

		local var_43_9 = var_43_8.style.user_name
		local var_43_10, var_43_11 = UIFontByResolution(var_43_9, nil)
		local var_43_12 = var_43_10[1]
		local var_43_13 = var_43_9.font_size
		local var_43_14 = UIRenderer.text_size(arg_43_0._ui_renderer, iter_43_0, var_43_12, var_43_13)

		var_43_7 = math.max(var_43_7, var_43_14)
	end

	arg_43_0._private_list_widgets.private_user_list_frame = UIWidget.init(var_43_1.private_user_list_frame)
	arg_43_0._ui_scenegraph.private_user_list.size[2] = 40 + var_43_5 * 30
	arg_43_0._ui_scenegraph.private_user_list.size[1] = var_43_7 + 125
	arg_43_0._ui_scenegraph.private_user_list.position[2] = arg_43_0._ui_scenegraph.private_user_list.size[2] + 5
	arg_43_0._ui_scenegraph.private_user_list_entry.size[1] = var_43_7 + 40
	var_43_3.num_private_messages = 0
end

function ChatView._create_filtered_user_list(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0:_update_filter(arg_44_1)

	arg_44_0:_destroy_filtered_user_names_list()

	if not var_44_0 then
		return
	end

	local var_44_1 = var_0_0.widget_definitions
	local var_44_2 = var_44_1.create_filtered_user_name_entry_func
	local var_44_3 = 0
	local var_44_4 = 0

	for iter_44_0, iter_44_1 in ipairs(var_44_0) do
		local var_44_5 = UIWidget.init(var_44_2(string.gsub(iter_44_1, "@", ""), -20 - 30 * var_44_3))

		arg_44_0._filtered_user_names_list_widgets[iter_44_1] = var_44_5
		var_44_3 = var_44_3 + 1

		local var_44_6 = var_44_5.style.user_name
		local var_44_7, var_44_8 = UIFontByResolution(var_44_6, nil)
		local var_44_9 = var_44_7[1]
		local var_44_10 = var_44_6.font_size
		local var_44_11 = UIRenderer.text_size(arg_44_0._ui_renderer, iter_44_1, var_44_9, var_44_10)

		var_44_4 = math.max(var_44_4, var_44_11)
	end

	arg_44_0._filtered_user_names_list_widgets.filtered_user_names_list_frame = UIWidget.init(var_44_1.filtered_user_names_list_frame)
	arg_44_0._ui_scenegraph.filtered_user_names_list.size[2] = 40 + var_44_3 * 25
	arg_44_0._ui_scenegraph.filtered_user_names_list.size[1] = var_44_4 + 60
	arg_44_0._ui_scenegraph.filtered_user_names_list_entry.size[1] = var_44_4 + 10
end

function ChatView._destroy_channel_list(arg_45_0)
	table.clear(arg_45_0._channel_list_widgets)
end

function ChatView._destroy_private_list(arg_46_0)
	table.clear(arg_46_0._private_list_widgets)
end

function ChatView._destroy_command_list(arg_47_0)
	table.clear(arg_47_0._commands_list_widgets)

	arg_47_0._widgets.commands_widget.content.button_hotspot.disable_button = false
end

function ChatView._destroy_filtered_user_names_list(arg_48_0)
	table.clear(arg_48_0._filtered_user_names_list_widgets)
end

function ChatView._handle_channel_list_input(arg_49_0)
	for iter_49_0, iter_49_1 in pairs(arg_49_0._channel_list_widgets) do
		local var_49_0 = iter_49_1.content

		if var_49_0.channel_hotspot and var_49_0.channel_hotspot.on_pressed then
			local var_49_1 = var_49_0.channel_name

			arg_49_0:_change_channel(var_49_1)
			arg_49_0:_destroy_channel_list()

			return
		elseif var_49_0.exit_button_hotspot and var_49_0.exit_button_hotspot.on_pressed then
			local var_49_2 = false
			local var_49_3 = false

			Managers.chat:send_chat_message(1, nil, "/leave " .. var_49_0.channel_name, var_49_2, nil, var_49_3, arg_49_0._recent_message_index, var_49_0.channel_name, Irc.CHANNEL_MSG)
			arg_49_0:_destroy_channel_list()

			return
		end
	end
end

function ChatView._handle_private_list_input(arg_50_0)
	for iter_50_0, iter_50_1 in pairs(arg_50_0._private_list_widgets) do
		local var_50_0 = iter_50_1.content

		if var_50_0.user_hotspot and var_50_0.user_hotspot.on_pressed then
			local var_50_1 = var_50_0.user_name

			arg_50_0:_change_to_private(var_50_1)
			arg_50_0:_destroy_private_list()

			return
		elseif var_50_0.exit_button_hotspot and var_50_0.exit_button_hotspot.on_pressed then
			local var_50_2 = arg_50_0._widgets.chat_output_widget.content.private_messages_table

			var_50_2[iter_50_0] = nil
			arg_50_0._widgets.private_messages_widget.content.has_private_conversations = not table.is_empty(var_50_2)

			arg_50_0:_destroy_private_list()
			arg_50_0:_change_channel(arg_50_0._current_channel_name)

			return
		end
	end
end

function ChatView._handle_command_list_input(arg_51_0)
	for iter_51_0, iter_51_1 in pairs(arg_51_0._commands_list_widgets) do
		local var_51_0 = iter_51_1.content

		if var_51_0.command_hotspot and var_51_0.command_hotspot.on_pressed then
			local var_51_1 = var_51_0.command
			local var_51_2 = var_51_0.parameter or ""
			local var_51_3 = arg_51_0._widgets.frame_widget.content

			var_51_3.chat_text.text = var_51_1 .. " " .. var_51_2
			var_51_3.caret_index = #KeystrokeHelper._build_utf8_table(var_51_3.chat_text.text) + 1

			arg_51_0:_destroy_command_list()

			arg_51_0._widgets.frame_widget.content.text_field_active = true

			return
		end
	end
end

function ChatView._handle_filtered_user_names_list_input(arg_52_0)
	for iter_52_0, iter_52_1 in pairs(arg_52_0._filtered_user_names_list_widgets) do
		local var_52_0 = iter_52_1.content

		if var_52_0.user_name_hotspot and var_52_0.user_name_hotspot.on_pressed then
			local var_52_1 = var_52_0.user_name
			local var_52_2 = arg_52_0._widgets.frame_widget.content

			var_52_2.chat_text.text = "/msg " .. var_52_1 .. " "
			var_52_2.caret_index = #KeystrokeHelper._build_utf8_table(var_52_2.chat_text.text) + 1

			arg_52_0:_destroy_filtered_user_names_list()

			return
		end
	end
end

function ChatView._handle_user_list_scroll_input(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0._user_list
	local var_53_1 = arg_53_0._user_list_read_index

	if not var_53_0 and not var_53_1 then
		return
	end

	if not arg_53_0._widgets.list_area_hotspot_widget.content.hotspot.is_hover then
		return
	end

	local var_53_2 = arg_53_1:get("chat_scroll")
	local var_53_3

	if arg_53_1:get("chat_scroll_up") or var_53_2[2] > 0.5 then
		var_53_3 = math.max(var_53_1 - 1, 1)
	elseif arg_53_1:get("chat_scroll_down") or var_53_2[2] < 0 then
		var_53_3 = math.min(var_53_1 + 1, #var_53_0)
	end

	if var_53_3 and var_53_3 ~= var_53_1 then
		arg_53_0:_update_members(var_53_3)
	end
end

function ChatView._handle_link_presses(arg_54_0)
	local var_54_0 = arg_54_0._widgets.chat_output_widget

	if var_54_0.content.link_pressed then
		local var_54_1 = var_54_0.content.link_pressed

		Managers.invite:set_invited_lobby_data(var_54_1.lobby_id)

		var_54_0.content.link_pressed = nil

		print("Link Pressed! -> joining game!")
	end
end

function ChatView._send_message(arg_55_0, arg_55_1)
	arg_55_1.chat_text.text = EmojiHelper.replace_emojis(arg_55_1.chat_text.text)

	local var_55_0 = EmojiHelper.parse_emojis(arg_55_1.chat_text.text)

	if arg_55_1.private_user_name then
		arg_55_0:_send_private_message(arg_55_1, var_55_0)
	else
		arg_55_0:_send_channel_message(arg_55_1, var_55_0)
	end
end

function ChatView._show_welcome_message(arg_56_0)
	local var_56_0 = arg_56_0._widgets.chat_output_widget.content
	local var_56_1 = var_56_0.channel_messages_table

	var_56_1[arg_56_0._current_channel_name] = var_56_1[arg_56_0._current_channel_name] or {}

	local var_56_2 = var_56_1[arg_56_0._current_channel_name]

	for iter_56_0 = 1, #var_0_3 do
		local var_56_3 = var_0_3[iter_56_0]
		local var_56_4 = {
			sender = string.format(var_56_3, arg_56_0._current_channel_name)
		}

		var_56_4.trimmed_sender = var_56_4.sender
		var_56_4.message = ""
		var_56_4.type = nil
		var_56_2[#var_56_2 + 1] = var_56_4
		var_56_0.text_start_offset = #var_56_2
	end
end

function ChatView._send_channel_message(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = false
	local var_57_1 = false
	local var_57_2, var_57_3, var_57_4 = Managers.chat:send_chat_message(1, arg_57_0._local_player_id, arg_57_1.chat_text.text, var_57_0, nil, var_57_1, arg_57_0._recent_message_index, arg_57_0._current_channel_name, Irc.CHANNEL_MSG)

	if not var_57_2 then
		if arg_57_1.chat_text.text ~= "" then
			local var_57_5 = Managers.irc:user_name()
			local var_57_6 = arg_57_0._widgets.chat_output_widget.content
			local var_57_7 = var_57_6.channel_messages_table

			var_57_7[arg_57_0._current_channel_name] = var_57_7[arg_57_0._current_channel_name] or {}

			local var_57_8 = var_57_7[arg_57_0._current_channel_name]
			local var_57_9 = {
				sender = var_57_5 .. ": ",
				trimmed_sender = arg_57_0:_strip_identifier_from_user_name(var_57_5) .. ": ",
				message = arg_57_1.chat_text.text,
				type = Irc.CHANNEL_MSG
			}

			if #arg_57_2 > 0 then
				var_57_9.emojis = table.clone(arg_57_2)
			end

			var_57_8[#var_57_8 + 1] = var_57_9
			var_57_6.text_start_offset = #var_57_8
		else
			arg_57_1.text_field_active = false
		end
	elseif var_57_2 == "send_message" then
		local var_57_10 = var_57_3[2]
		local var_57_11 = ""

		for iter_57_0 = 3, #var_57_3 do
			var_57_11 = var_57_11 .. " " .. var_57_3[iter_57_0]
		end

		local var_57_12 = arg_57_0._widgets.chat_output_widget.content
		local var_57_13 = var_57_12.private_messages_table

		var_57_13[var_57_10] = var_57_13[var_57_10] or {}

		local var_57_14 = var_57_13[var_57_10]
		local var_57_15 = {
			sender = "To [" .. var_57_10 .. "]: ",
			trimmed_sender = "To [" .. arg_57_0:_strip_identifier_from_user_name(var_57_10) .. "]: ",
			message = var_57_11,
			type = Irc.PRIVATE_MSG
		}

		if #arg_57_2 > 0 then
			var_57_15.emojis = table.clone(arg_57_2)
		end

		var_57_14[#var_57_14 + 1] = var_57_15
		var_57_12.text_start_offset = #var_57_14

		arg_57_0:_change_to_private(var_57_10)
	elseif var_57_2 == "game_invite" then
		local var_57_16 = Managers.irc:user_name()
		local var_57_17 = ""

		for iter_57_1 = 2, #var_57_3 do
			var_57_17 = var_57_17 .. " " .. var_57_3[iter_57_1]
		end

		local var_57_18 = arg_57_0._widgets.chat_output_widget.content
		local var_57_19 = var_57_18.channel_messages_table

		var_57_19[arg_57_0._current_channel_name] = var_57_19[arg_57_0._current_channel_name] or {}

		local var_57_20 = var_57_19[arg_57_0._current_channel_name]
		local var_57_21 = {
			sender = var_57_16 .. ": ",
			trimmed_sender = arg_57_0:_strip_identifier_from_user_name(var_57_16) .. ": ",
			message = var_57_17,
			type = Irc.CHANNEL_MSG
		}

		if var_57_4 then
			var_57_21.link = var_57_4
		end

		if #arg_57_2 > 0 then
			var_57_21.emojis = table.clone(arg_57_2)
		end

		var_57_20[#var_57_20 + 1] = var_57_21
		var_57_18.text_start_offset = #var_57_20
	elseif var_57_2 == "clear_chat" then
		local var_57_22 = arg_57_0._widgets.chat_output_widget.content
		local var_57_23 = var_57_22.channel_messages_table

		var_57_23[arg_57_0._current_channel_name] = var_57_23[arg_57_0._current_channel_name] or {}

		local var_57_24 = var_57_23[arg_57_0._current_channel_name]

		table.clear(var_57_24)

		var_57_22.text_start_offset = #var_57_24
	end

	arg_57_1.chat_text.text = ""
	arg_57_1.caret_index = 1
	arg_57_0._recent_message_index = nil
end

function ChatView._send_private_message(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = arg_58_1.private_user_name
	local var_58_1 = false
	local var_58_2 = false
	local var_58_3, var_58_4, var_58_5 = Managers.chat:send_chat_message(1, arg_58_0._local_player_id, arg_58_1.chat_text.text, var_58_1, nil, var_58_2, arg_58_0._recent_message_index, var_58_0, Irc.PRIVATE_MSG)

	if not var_58_3 then
		if arg_58_1.chat_text.text ~= "" then
			local var_58_6 = arg_58_0._widgets.chat_output_widget.content
			local var_58_7 = var_58_6.private_messages_table

			var_58_7[var_58_0] = var_58_7[var_58_0] or {}

			local var_58_8 = var_58_7[var_58_0]
			local var_58_9 = {
				sender = "To [" .. var_58_0 .. "]: ",
				trimmed_sender = "To [" .. arg_58_0:_strip_identifier_from_user_name(var_58_0) .. "]: ",
				message = arg_58_1.chat_text.text,
				type = Irc.PRIVATE_MSG
			}

			if #arg_58_2 > 0 then
				var_58_9.emojis = table.clone(arg_58_2)
			end

			var_58_8[#var_58_8 + 1] = var_58_9
			var_58_6.text_start_offset = #var_58_8
		else
			arg_58_1.text_field_active = false
		end
	elseif var_58_3 == "game_invite" then
		local var_58_10 = ""

		for iter_58_0 = 2, #var_58_4 do
			var_58_10 = var_58_10 .. " " .. var_58_4[iter_58_0]
		end

		local var_58_11 = arg_58_0._widgets.chat_output_widget.content
		local var_58_12 = var_58_11.private_messages_table

		var_58_12[var_58_0] = var_58_12[var_58_0] or {}

		local var_58_13 = var_58_12[var_58_0]
		local var_58_14 = {
			sender = "To [" .. var_58_0 .. "]: ",
			trimmed_sender = "To [" .. arg_58_0:_strip_identifier_from_user_name(var_58_0) .. "]: ",
			message = var_58_10,
			type = Irc.PRIVATE_MSG
		}

		if var_58_5 then
			var_58_14.link = var_58_5
		end

		if #arg_58_2 > 0 then
			var_58_14.emojis = table.clone(arg_58_2)
		end

		var_58_13[#var_58_13 + 1] = var_58_14
		var_58_11.text_start_offset = #var_58_13
	elseif var_58_3 == "clear_chat" then
		local var_58_15 = arg_58_0._widgets.chat_output_widget.content
		local var_58_16 = var_58_15.private_messages_table

		var_58_16[var_58_0] = var_58_16[var_58_0] or {}

		local var_58_17 = var_58_16[var_58_0]

		table.clear(var_58_17)

		var_58_15.text_start_offset = #var_58_17
	end

	arg_58_1.chat_text.text = ""
	arg_58_1.caret_index = 1
	arg_58_0._recent_message_index = nil
end

function ChatView.set_active(arg_59_0, arg_59_1)
	arg_59_0._active = arg_59_1

	if arg_59_0._active then
		arg_59_0._input_manager:block_device_except_service("chat_view", "keyboard", 1, "irc_chat")
		arg_59_0._input_manager:block_device_except_service("chat_view", "mouse", 1, "irc_chat")
		arg_59_0._input_manager:block_device_except_service("chat_view", "gamepad", 1, "irc_chat")
		ShowCursorStack.show("ChatView")
	else
		ShowCursorStack.hide("ChatView")
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

function ChatView.suspend(arg_60_0)
	arg_60_0._suspended = true

	arg_60_0._input_manager:device_unblock_all_services("keyboard", 1)
	arg_60_0._input_manager:device_unblock_all_services("mouse", 1)
	arg_60_0._input_manager:device_unblock_all_services("gamepad", 1)
end

function ChatView.unsuspend(arg_61_0)
	arg_61_0._input_manager:block_device_except_service("chat_view", "keyboard", 1, "irc_chat")
	arg_61_0._input_manager:block_device_except_service("chat_view", "mouse", 1, "irc_chat")
	arg_61_0._input_manager:block_device_except_service("chat_view", "gamepad", 1, "irc_chat")

	arg_61_0._suspended = nil
end

function ChatView._update_animations(arg_62_0, arg_62_1, arg_62_2)
	for iter_62_0, iter_62_1 in pairs(arg_62_0._ui_animations) do
		UIAnimation.update(iter_62_1, arg_62_1)

		if UIAnimation.completed(iter_62_1) then
			arg_62_0._ui_animations[iter_62_0] = nil
		end
	end
end

function ChatView._draw(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = arg_63_0._ui_renderer
	local var_63_1 = arg_63_0._ui_scenegraph
	local var_63_2 = arg_63_0._input_manager:get_service("chat_view")
	local var_63_3 = arg_63_0._input_manager:get_service("channels_list")
	local var_63_4 = arg_63_0._render_settings
	local var_63_5 = Managers.twitch:is_connected()
	local var_63_6 = Managers.twitch:is_connecting()

	UIRenderer.begin_pass(var_63_0, var_63_1, var_63_2, arg_63_1, nil, var_63_4)

	for iter_63_0, iter_63_1 in pairs(arg_63_0._widgets) do
		UIRenderer.draw_widget(var_63_0, iter_63_1)
	end

	for iter_63_2, iter_63_3 in pairs(arg_63_0._channel_list_widgets) do
		UIRenderer.draw_widget(var_63_0, iter_63_3)
	end

	for iter_63_4, iter_63_5 in pairs(arg_63_0._private_list_widgets) do
		UIRenderer.draw_widget(var_63_0, iter_63_5)
	end

	for iter_63_6, iter_63_7 in pairs(arg_63_0._recent_channels_list_widgets) do
		UIRenderer.draw_widget(var_63_0, iter_63_7)
	end

	for iter_63_8, iter_63_9 in pairs(arg_63_0._popular_channel_list_widgets) do
		UIRenderer.draw_widget(var_63_0, iter_63_9)
	end

	for iter_63_10, iter_63_11 in pairs(arg_63_0._commands_list_widgets) do
		UIRenderer.draw_widget(var_63_0, iter_63_11)
	end

	for iter_63_12, iter_63_13 in pairs(arg_63_0._filtered_user_names_list_widgets) do
		UIRenderer.draw_widget(var_63_0, iter_63_13)
	end

	for iter_63_14, iter_63_15 in pairs(arg_63_0._channel_tabs) do
		UIRenderer.draw_widget(var_63_0, iter_63_15)
	end

	local var_63_7 = arg_63_0._user_entry_widgets

	if var_63_7 then
		for iter_63_16, iter_63_17 in ipairs(var_63_7) do
			UIRenderer.draw_widget(var_63_0, iter_63_17)
		end
	end

	UIRenderer.end_pass(var_63_0)

	if not table.is_empty(arg_63_0._channels_list_widgets) then
		UIRenderer.begin_pass(var_63_0, var_63_1, var_63_3, arg_63_1, nil, var_63_4)
		arg_63_0:_handle_and_draw_channels_list(var_63_0, var_63_1, arg_63_1, arg_63_2)
		UIRenderer.end_pass(var_63_0)
	elseif not table.is_empty(arg_63_0._create_channel_widgets) then
		UIRenderer.begin_pass(var_63_0, var_63_1, var_63_3, arg_63_1, nil, var_63_4)

		for iter_63_18, iter_63_19 in pairs(arg_63_0._create_channel_widgets) do
			UIRenderer.draw_widget(var_63_0, iter_63_19)
		end

		UIRenderer.end_pass(var_63_0)
	elseif not table.is_empty(arg_63_0._recent_channels_widgets) then
		UIRenderer.begin_pass(var_63_0, var_63_1, var_63_3, arg_63_1, nil, var_63_4)

		for iter_63_20, iter_63_21 in pairs(arg_63_0._recent_channels_widgets) do
			UIRenderer.draw_widget(var_63_0, iter_63_21)
		end

		UIRenderer.end_pass(var_63_0)
	elseif not table.is_empty(arg_63_0._invite_widgets) then
		UIRenderer.begin_pass(var_63_0, var_63_1, var_63_3, arg_63_1, nil, var_63_4)

		for iter_63_22, iter_63_23 in pairs(arg_63_0._invite_widgets) do
			UIRenderer.draw_widget(var_63_0, iter_63_23)
		end

		UIRenderer.end_pass(var_63_0)
	end
end

function ChatView._update_channel_tabs(arg_64_0, arg_64_1, arg_64_2)
	for iter_64_0, iter_64_1 in ipairs(arg_64_0._channel_tabs) do
		local var_64_0 = iter_64_1.content

		if var_64_0.tab_hotspot.on_release then
			local var_64_1 = var_64_0.channel_name

			arg_64_0:_change_channel(var_64_1)
		end
	end
end

function ChatView.on_exit(arg_65_0)
	arg_65_0:set_active(false)
end

function ChatView.destroy(arg_66_0)
	return
end

function ChatView._exit(arg_67_0, arg_67_1)
	local var_67_0 = arg_67_1 and "exit_menu" or "ingame_menu"

	arg_67_0._ingame_ui:handle_transition(var_67_0)
end

function ChatView.input_service(arg_68_0)
	return arg_68_0._input_manager:get_service("chat_view")
end

function ChatView._is_widget_pressed(arg_69_0, arg_69_1)
	return arg_69_1.content.button_hotspot.on_pressed
end

function ChatView._set_text_field_active(arg_70_0, arg_70_1)
	arg_70_0._widgets.frame_widget.content.text_field_active = arg_70_1
end

function ChatView._handle_user_pressed(arg_71_0)
	local var_71_0 = arg_71_0._user_entry_widgets

	for iter_71_0, iter_71_1 in ipairs(var_71_0) do
		local var_71_1 = iter_71_1.content
		local var_71_2 = var_71_1.button_hotspot

		if var_71_2.on_double_click then
			local var_71_3 = string.gsub(var_71_1.user_name, "@", "")

			arg_71_0:_change_to_private(var_71_3)
			arg_71_0:_set_text_field_active(true)
		elseif var_71_2.on_right_click then
			print("on right click", var_71_1.user_name)
		end
	end
end

function ChatView._populate_user_widgets(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = arg_72_0._user_entry_widgets
	local var_72_1 = arg_72_2

	for iter_72_0, iter_72_1 in ipairs(var_72_0) do
		local var_72_2 = iter_72_1.content
		local var_72_3 = iter_72_1.style
		local var_72_4 = arg_72_1[var_72_1]

		if var_72_4 then
			var_72_2.user_name = var_72_4.name
			var_72_2.title_text = string.sub(var_72_4.name, 1, -11)
			var_72_2.level_text = var_72_4.level or tostring(math.random(1, 100) + math.random(0, 100))
			var_72_2.description_text = var_72_4.info or "abc..."
			var_72_2.icon = var_0_4[var_72_4.icon_id] or "icons_placeholder"
		end

		var_72_2.visible = var_72_4 ~= nil
		var_72_1 = var_72_1 + 1
	end
end

for iter_0_0, iter_0_1 in pairs(ItemMasterList) do
	if iter_0_1.item_type == "hat" then
		var_0_4[#var_0_4 + 1] = iter_0_1.inventory_icon
	end
end

function ChatView._update_members(arg_73_0, arg_73_1)
	arg_73_1 = arg_73_1 or arg_73_0._user_list_read_index or 1
	arg_73_0._current_channel_name = arg_73_0._current_channel_name or Managers.irc:home_channel()

	local var_73_0 = Managers.irc:user_name()
	local var_73_1 = {}
	local var_73_2 = {}
	local var_73_3 = Managers.irc:get_channel_members(arg_73_0._current_channel_name)
	local var_73_4 = 1

	for iter_73_0, iter_73_1 in pairs(var_73_3) do
		var_73_1[var_73_4] = iter_73_1
		var_73_2[var_73_4] = iter_73_1.name
		var_73_4 = var_73_4 + 1
	end

	arg_73_0:_populate_user_widgets(var_73_1, arg_73_1)

	arg_73_0._user_list = var_73_1
	arg_73_0._user_names = var_73_2
	arg_73_0._user_list_read_index = arg_73_1
end
