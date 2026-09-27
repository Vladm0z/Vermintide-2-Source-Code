-- chunkname: @scripts/ui/views/chat_view.lua

require("scripts/utils/keystroke_helper")
require("scripts/helpers/emoji_helper")

local var_0_0 = local_require("scripts/ui/views/chat_view_definitions")
local create_entry_func = var_0_0.create_entry_func
local num_users_in_list = var_0_0.num_users_in_list
local tbl = {
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
local tbl_2 = {}

ChatView = class(ChatView)
ChatView.MAX_CHARS = 512
ChatView.MAX_CHANNEL_NAME = 30
ChatView.MAX_POPULAR_CHANNELS = 5

local tbl_3 = {
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

ChatView.init = function (self, arg_1_1)
	-- function 1
	self._ui_renderer = arg_1_1.ui_renderer
	self._ingame_ui = arg_1_1.ingame_ui
	self._network_lobby = arg_1_1.network_lobby
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._render_settings = {
		snap_pixel_positions = false
	}
	self._network_server = arg_1_1.network_server
	self._current_channel_name = Managers.irc:home_channel()
	self._local_player_id = arg_1_1.local_player_id
	self._chat_message = ""
	self._chat_index = 1
	self._emoji_scroll = 0
	self._channels = {}
	self._popular_channel_list = {}
	self._popular_channel_list_lookup = {}
	self._list_channels_cbs = {}

	local flag = false
	local get_channels = Managers.irc:get_channels()

	for k, v in pairs(get_channels) do
		if k == self._current_channel_name then
			flag = true

			break
		end
	end

	if not flag then
		Managers.irc:join_channel(self._current_channel_name)
	end

	local input_manager = arg_1_1.input_manager
	local tbl = {
		keybind = true,
		channels_list = true,
		debug_screen = true,
		free_flight = true
	}

	input_manager:create_input_service("chat_view", "ChatControllerSettings", "ChatControllerFilters", tbl)
	input_manager:map_device_to_service("chat_view", "keyboard")
	input_manager:map_device_to_service("chat_view", "mouse")

	local tbl_2 = {
		keybind = true,
		debug_screen = true,
		free_flight = true
	}

	input_manager:create_input_service("channels_list", "ChatControllerSettings", "ChatControllerFilters", tbl_2)
	input_manager:map_device_to_service("channels_list", "keyboard")
	input_manager:map_device_to_service("channels_list", "mouse")

	self._input_manager = input_manager

	local world = arg_1_1.world_manager:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)

	Managers.irc:register_message_callback("chat_view_private_msg", Irc.PRIVATE_MSG, callback(self, "cb_private_message"))
	Managers.irc:register_message_callback("chat_view_channel_msg", Irc.CHANNEL_MSG, callback(self, "cb_channel_message"))
	Managers.irc:register_message_callback("chat_view_join", Irc.JOIN_MSG, callback(self, "cb_join_updated"))
	Managers.irc:register_message_callback("chat_view_leave", Irc.LEAVE_MSG, callback(self, "cb_leave_updated"))
	Managers.irc:register_message_callback("chat_view_names", Irc.NAMES_MSG, callback(self, "cb_members_updated"))
	Managers.irc:register_message_callback("chat_view_meta", Irc.META_MSG, callback(self, "cb_meta_updated"))
	Managers.irc:register_message_callback("chat_view_list", Irc.LIST_MSG, callback(self, "cb_list_updated"))
	Managers.irc:register_message_callback("chat_view_list_end", Irc.LIST_END_MSG, callback(self, "cb_list_end"))
	self:_create_ui_elements()
end

ChatView._strip_identifier_from_user_name = function (arg_2_0, arg_2_1)
	-- function 2
	return string.sub(arg_2_1, 1, -11)
end

ChatView.cb_private_message = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local chat_output_widget = self._widgets.chat_output_widget
	local private_messages_widget = self._widgets.private_messages_widget
	local content = chat_output_widget.content
	local content_2 = private_messages_widget.content
	local private_messages_table = content.private_messages_table
	local var_3_5 = private_messages_table[arg_3_3]

	var_3_5 = var_3_5 or {}
	private_messages_table[arg_3_3] = var_3_5

	local var_3_6 = private_messages_table[arg_3_3]
	local check_meta, var_3_8 = Managers.chat:check_meta(arg_3_4, arg_3_3, arg_3_5)
	local parse_emojis = EmojiHelper.parse_emojis(check_meta)
	local tbl = {
		sender = arg_3_3 .. ": ",
		trimmed_sender = self:_strip_identifier_from_user_name(arg_3_3) .. ": ",
		message = check_meta,
		type = arg_3_2
	}

	if not var_3_8 then
		tbl.link = var_3_8
	end

	if #parse_emojis > 0 then
		tbl.emojis = table.clone(parse_emojis)
	end

	var_3_6[#var_3_6 + 1] = tbl

	if content.private_user_name ~= arg_3_3 then
		content_2.num_private_messages = content_2.num_private_messages + 1
		content_2.new_per_user[arg_3_3] = true
	end

	content_2.has_private_conversations = not table.is_empty(private_messages_table)
end

ChatView._find_end_index = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local find = string.find(arg_4_1, " ", arg_4_2)

	find = find or math.huge

	local num = find - 1
	local find_2 = string.find(arg_4_1, ":", arg_4_2)

	find_2 = find_2 or math.huge

	local flag = not (num <= find_2) or not num or find_2

	return not (flag < math.huge - 1) or not flag or nil
end

ChatView.cb_channel_message = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local content = self._widgets.chat_output_widget.content
	local channel_messages_table = content.channel_messages_table
	local var_5_2 = channel_messages_table[arg_5_5]

	var_5_2 = var_5_2 or {}
	channel_messages_table[arg_5_5] = var_5_2

	local var_5_3 = channel_messages_table[arg_5_5]
	local check_meta, var_5_5 = Managers.chat:check_meta(arg_5_4, arg_5_3, arg_5_5)
	local parse_emojis = EmojiHelper.parse_emojis(check_meta)
	local tbl = {
		sender = arg_5_3 .. ": ",
		trimmed_sender = self:_strip_identifier_from_user_name(arg_5_3) .. ": ",
		message = check_meta,
		type = arg_5_2
	}

	if not var_5_5 then
		tbl.link = var_5_5
	end

	if #parse_emojis > 0 then
		tbl.emojis = table.clone(parse_emojis)
	end

	var_5_3[#var_5_3 + 1] = tbl
	content.text_start_offset = #var_5_3
end

ChatView.cb_join_updated = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local user_name = Managers.irc:user_name()

	if arg_6_3 == user_name then
		self:_change_channel(arg_6_5)
	end

	self:_update_members()

	local PlayerData = PlayerData
	local recent_irc_channels = PlayerData.recent_irc_channels

	recent_irc_channels = recent_irc_channels or {}
	PlayerData.recent_irc_channels = recent_irc_channels

	local recent_irc_channels_2 = PlayerData.recent_irc_channels
	local var_6_4 = arg_6_5

	if not table.find(recent_irc_channels_2, var_6_4) then
		table.insert(recent_irc_channels_2, 1, var_6_4)

		while #recent_irc_channels_2 > 5 do
			recent_irc_channels_2[#recent_irc_channels_2] = nil
		end
	end

	if arg_6_3 == user_name then
		self:_show_welcome_message()
	end
end

ChatView.cb_meta_updated = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	self:_update_members()
end

ChatView.cb_list_updated = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	print(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)

	self._popular_channel_list[#self._popular_channel_list + 1] = arg_8_4 .. "," .. arg_8_5

	local _popular_channel_list_lookup = self._popular_channel_list_lookup

	_popular_channel_list_lookup = _popular_channel_list_lookup or {}
	self._popular_channel_list_lookup = _popular_channel_list_lookup
	self._popular_channel_list_lookup[arg_8_4] = arg_8_5
end

ChatView.cb_list_end = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	self._list_updated = true

	local function fn(arg_10_0, arg_10_1)
		-- function 10
		local split_deprecated = string.split_deprecated(arg_10_0, ",")
		local split_deprecated_2 = string.split_deprecated(arg_10_1, ",")

		return tonumber(split_deprecated[2]) > tonumber(split_deprecated_2[2])
	end

	table.sort(self._popular_channel_list, fn)

	if not self._list_channels_cbs then
		for i, v in ipairs(self._list_channels_cbs) do
			v(self._popular_channel_list, self._popular_channel_list_lookup)
		end
	end

	table.clear(self._list_channels_cbs)
end

ChatView._change_channel = function (self, arg_11_1)
	-- function 11
	local content = self._widgets.chat_output_widget.content
	local content_2 = self._widgets.name_list_widget.content

	self._current_channel_name = arg_11_1

	local _channels = self._channels

	_channels = _channels or {}
	self._channels = _channels
	self._channels[arg_11_1] = arg_11_1
	content.channel_name = arg_11_1
	content_2.channel_name = arg_11_1
	content.private_user_name = nil
	content.trimmed_private_user_name = nil

	local content_3 = self._widgets.frame_widget.content

	content_3.private_user_name = nil
	content_3.trimmed_private_user_name = nil

	local var_11_4 = content.channel_messages_table[arg_11_1]

	var_11_4 = var_11_4 or {}
	content.text_start_offset = #var_11_4

	self:_update_members()
	self:_verify_channel_tabs()
end

local tbl_4 = {}

ChatView._verify_channel_tabs = function (self)
	-- function 12
	local get_channels = Managers.irc:get_channels()
	local widget_definitions = var_0_0.widget_definitions
	local get_channels_2 = Managers.irc:get_channels()

	for k, v in pairs(get_channels_2) do
		if not self._channel_tab_lookup[k] then
			self._channel_tabs[#self._channel_tabs + 1] = UIWidget.init(widget_definitions.create_channel_tab(k, #self._channel_tabs + 1, self._current_channel_name))
			self._channel_tab_lookup[k] = true
		end
	end

	table.clear(tbl_4)

	local num = 1

	for i, v_2 in ipairs(self._channel_tabs) do
		local content = v_2.content
		local channel_name = content.channel_name

		if not get_channels_2[channel_name] then
			self._channel_tab_lookup[channel_name] = nil
			tbl_4[#tbl_4 + 1] = i
		else
			content.selected = channel_name == self._current_channel_name
			v_2.offset[1] = self._ui_scenegraph.channel_tab_anchor.size[1] * (num - 1)
			num = num + 1
		end
	end

	for i4 = #tbl_4, 1, -1 do
		local var_12_6 = tbl_4[i4]

		table.remove(self._channel_tabs, var_12_6)
	end
end

ChatView._change_to_private = function (self, arg_13_1)
	-- function 13
	local content = self._widgets.chat_output_widget.content

	content.private_user_name = arg_13_1
	content.trimmed_private_user_name = self:_strip_identifier_from_user_name(arg_13_1)

	local var_13_1 = content.private_messages_table[arg_13_1]

	var_13_1 = var_13_1 or {}
	content.text_start_offset = #var_13_1

	local content_2 = self._widgets.frame_widget.content

	content_2.private_user_name = arg_13_1
	content_2.trimmed_private_user_name = self:_strip_identifier_from_user_name(arg_13_1)
	self._widgets.private_messages_widget.content.new_per_user[arg_13_1] = nil

	Managers.chat:add_message_target(arg_13_1, Irc.PRIVATE_MSG)
end

ChatView._list_private_messages = function (self, arg_14_1)
	-- function 14
	local content = self._widgets.chat_output_widget.content
	local content_2 = self._widgets.name_list_widget.content

	self._current_channel_name = arg_14_1

	local _channels = self._channels

	_channels = _channels or {}
	self._channels = _channels
	self._channels[channel_name] = channel_name
	content.channel_name = channel_name
	content_2.channel_name = channel_name

	local var_14_3 = content.channel_messages_table[channel_name]

	var_14_3 = var_14_3 or {}
	content.text_start_offset = #var_14_3
end

ChatView.cb_leave_updated = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if arg_15_3 == Managers.irc:user_name() then
		self._channels[arg_15_5] = nil

		local var_15_0 = next(self._channels)

		var_15_0 = var_15_0 or " "

		self:_change_channel(var_15_0)

		local content = self._widgets.chat_output_widget.content
		local content_2 = self._widgets.name_list_widget.content

		content.channel_messages_table[arg_15_5] = nil
		content_2.channel_messages_table[arg_15_5] = nil
	end

	self:_update_members()
end

ChatView.cb_members_updated = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	self:_update_members()
end

ChatView._create_ui_elements = function (self)
	-- function 17
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local _widgets = self._widgets

	_widgets = _widgets or {}
	self._widgets = _widgets

	local chat_output_widget = self._widgets.chat_output_widget

	if not chat_output_widget then
		tbl = chat_output_widget.content.channel_messages_table
	end

	local _widgets_2 = self._widgets

	_widgets_2 = _widgets_2 or {}
	self._widgets = _widgets_2

	local name_list_widget = self._widgets.name_list_widget

	if not name_list_widget then
		tbl_2 = name_list_widget.content.channel_messages_table
	end

	self._widgets = {}
	self._current_tab_offset_index = 1
	self._channels_list_widgets = {}
	self._popular_channel_list_widgets = {}
	self._channel_list_widgets = {}
	self._private_list_widgets = {}
	self._recent_channels_list_widgets = {}
	self._commands_list_widgets = {}
	self._filtered_user_names_list_widgets = {}
	self._create_channel_widgets = {}
	self._recent_channels_widgets = {}
	self._invite_widgets = {}
	self._emoji_widgets = {}
	self._channel_tabs = {}
	self._channel_tab_lookup = {}
	self._ui_animations = {}

	local widget_definitions = var_0_0.widget_definitions

	for k, v in pairs(widget_definitions.widgets) do
		self._widgets[k] = UIWidget.init(v)
	end

	local content = self._widgets.chat_output_widget.content

	content.channel_messages_table = tbl
	content.channel_name = self._current_channel_name
	content.text_start_offset = #tbl

	local content_2 = self._widgets.name_list_widget.content

	content_2.channel_messages_table = tbl_2
	content_2.channel_name = self._current_channel_name

	local num = 60
	local tbl_3 = {}

	for k_2 = 1, num do
		tbl_3[k_2] = {
			name = "test_" .. k_2
		}
	end

	local tbl_4 = {}

	for l = 1, num_users_in_list do
		local var_17_12 = create_entry_func(l)

		tbl_4[l] = UIWidget.init(var_17_12)
	end

	self._user_entry_widgets = tbl_4

	self:_update_members()

	local get_channels = Managers.irc:get_channels()

	for k_3, v_2 in pairs(get_channels) do
		self._channel_tabs[#self._channel_tabs + 1] = UIWidget.init(widget_definitions.create_channel_tab(k_3, #self._channel_tabs + 1, self._current_channel_name))
		self._channel_tab_lookup[k_3] = #self._channel_tabs
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
	Managers.input:device_unblock_service("keyboard", 1, "chat_view")
	Managers.input:device_unblock_service("mouse", 1, "chat_view")
end

ChatView.on_enter = function (self)
	-- function 18
	self:set_active(true)
end

local flag = false

ChatView.update = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	if not Keyboard.pressed(Keyboard.button_index("b")) then
		print("UPDATE MEMBERS")
		self:_update_members()
	end

	if not (self._suspended or self._active) then
		return
	end

	self:_update_animations(arg_19_1, arg_19_2)
	self:_draw(arg_19_1, arg_19_2)
	self:_update_channel_tabs(arg_19_1, arg_19_2)
	self:_update_input(arg_19_1, arg_19_2)
	self:_update_channels_list_input(arg_19_1, arg_19_2)
	self:_update_create_channel_input(arg_19_1, arg_19_2)
	self:_update_recent_channels_input(arg_19_1, arg_19_2)
	self:_update_send_invite_input(arg_19_1, arg_19_2)
	self:_handle_command_list(arg_19_1, arg_19_2)
end

ChatView._update_filter = function (self, arg_20_1)
	-- function 20
	local clock = os.clock()

	arg_20_1 = string.gsub(arg_20_1, "%W", "")

	if #KeystrokeHelper._build_utf8_table(arg_20_1) <= 0 then
		return
	end

	local tbl = {}
	local flag = false
	local num = 1
	local flag_2 = false
	local _user_names = self._user_names

	if not (not _user_names and not (#_user_names <= 0)) then
		return
	end

	local temp_count, var_20_7, var_20_8 = Script.temp_count()

	for i = 1, #_user_names do
		if not string.find(string.lower(_user_names[i]), arg_20_1) then
			tbl[#tbl + 1] = _user_names[i]
		end
	end

	if #tbl > 0 then
		table.dump(tbl, "NAMES", 2)

		return tbl
	end

	Script.set_temp_count(temp_count, var_20_7, var_20_8)
	print(string.format("Search time: %f", tostring(os.clock() - clock)))
end

ChatView._play_sound = function (self, arg_21_1)
	-- function 21
	WwiseWorld.trigger_event(self._wwise_world, arg_21_1)
end

ChatView._update_recent_channels_input = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not table.is_empty(self._recent_channels_widgets) then
		return
	end

	local get_service = Managers.input:get_service("channels_list")
	local join_button = self._recent_channels_widgets.join_button
	local recent_channels_window = self._recent_channels_widgets.recent_channels_window

	UIWidgetUtils.animate_default_button(join_button, arg_22_1)

	local content = join_button.content
	local content_2 = recent_channels_window.content
	local button_hotspot = content.button_hotspot
	local screen_hotspot = content_2.screen_hotspot
	local widget_hotspot = content_2.widget_hotspot
	local close_hotspot = content_2.close_hotspot
	local list_hotspot = content_2.list_hotspot

	if not widget_hotspot.is_hover then
		if not close_hotspot.on_pressed then
			self:_destroy_recent_channels_window()
		elseif not button_hotspot.on_pressed then
			if content_2.selected_channel ~= nil then
				local flag = false
				local flag_2 = false

				self:_destroy_recent_channels_window(true)
				Managers.chat:send_chat_message(1, nil, "/join " .. content_2.selected_channel, flag, nil, flag_2, self._recent_message_index, content_2.selected_channel, Irc.CHANNEL_MSG)
			end
		else
			local str = "channel_entry_"

			for i = 1, 5 do
				local var_22_13 = self._recent_channels_widgets[str .. i]

				if not var_22_13 then
					local content_3 = var_22_13.content

					if not content_3.hotspot.on_pressed then
						if not content_3.selected_channel then
							content_3.selected_channel = nil
							content_2.selected_channel = nil
						else
							content_3.selected_channel = content_3.channel_name
							content_2.selected_channel = content_3.channel_name
						end
					elseif content_3.selected_channel ~= content_2.selected_channel then
						content_3.selected_channel = nil
					end
				end
			end
		end

		if not (not widget_hotspot.on_pressed and list_hotspot.is_hover) then
			content_2.selected_channel = nil
		end
	elseif not screen_hotspot.on_pressed then
		self:_destroy_recent_channels_window()
	end

	button_hotspot.disable_button = content_2.selected_channel == nil
end

ChatView._create_recent_channels_window = function (arg_23_0)
	-- function 23
	local widget_definitions = var_0_0.widget_definitions

	arg_23_0._recent_channels_widgets.recent_channels_window = UIWidget.init(widget_definitions.recent_channels_window)

	local var_23_1 = UIWidget.init(widget_definitions.recent_join_channel_button)

	var_23_1.content.button_hotspot.disable_button = true
	arg_23_0._recent_channels_widgets.join_button = var_23_1

	Managers.input:block_device_except_service("channels_list", "keyboard", 1, "channels_list")
	Managers.input:block_device_except_service("channels_list", "mouse", 1, "channels_list")
	Irc.list_channels()

	arg_23_0._list_channels_cbs[#arg_23_0._list_channels_cbs + 1] = callback(arg_23_0, "cb_populate_recent_channels")
	arg_23_0._recent_channels_widgets.recent_channels_window.content.fetching_channels = true
end

ChatView.cb_populate_recent_channels = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not table.is_empty(self._recent_channels_widgets) then
		return
	end

	local size = self._ui_scenegraph.recent_channels_window_list_box_entry.size
	local channels_list_settings = var_0_0.channels_list_settings
	local channels_width_spacing = channels_list_settings.channels_width_spacing
	local channels_height_spacing = channels_list_settings.channels_height_spacing
	local num = 0
	local widget_definitions = var_0_0.widget_definitions
	local recent_irc_channels = PlayerData.recent_irc_channels

	recent_irc_channels = recent_irc_channels or {}

	for i, v in ipairs(recent_irc_channels) do
		local var_24_7 = arg_24_2[v]

		var_24_7 = var_24_7 or 0

		local var_24_8 = UIWidget.init(widget_definitions.create_channel_list_entry_func("recent_channels_window_list_box_entry"))
		local content = var_24_8.content
		local style = var_24_8.style

		var_24_8.offset[2] = num
		content.channel_name = v
		content.channel_name_id = UIRenderer.crop_text_width(self._ui_renderer, v, 160, style.channel_name)
		content.num_members_id = var_24_7 .. " Member(s)"
		style.icon.texture_size = {
			size[2] - channels_width_spacing * 2,
			size[2] - channels_height_spacing * 2
		}
		style.channel_name.offset[1] = size[2] - channels_width_spacing * 2 + channels_width_spacing
		style.num_members.offset[1] = size[2] - channels_width_spacing * 2 + channels_width_spacing
		style.background.size[1] = size[1]
		style.background.size[2] = size[2] - channels_height_spacing
		self._recent_channels_widgets["channel_entry_" .. i] = var_24_8
		num = num - (size[2] + channels_height_spacing)
	end

	self._recent_channels_widgets.recent_channels_window.content.fetching_channels = false
end

ChatView._destroy_recent_channels_window = function (self, arg_25_1)
	-- function 25
	table.clear(self._recent_channels_widgets)

	if not arg_25_1 then
		self:_create_channels_list()
	else
		Managers.input:device_unblock_service("keyboard", 1, "chat_view")
		Managers.input:device_unblock_service("mouse", 1, "chat_view")
	end
end

ChatView._create_invite_window = function (arg_26_0)
	-- function 26
	local widget_definitions = var_0_0.widget_definitions
	local scenegraph_definition = var_0_0.scenegraph_definition

	arg_26_0._invite_widgets.send_invite_window = UIWidget.init(widget_definitions.send_invite_window)
	arg_26_0._invite_widgets.send_invite_button = UIWidget.init(widget_definitions.send_invite_button)

	Managers.input:block_device_except_service("channels_list", "keyboard", 1, "channels_list")
	Managers.input:block_device_except_service("channels_list", "mouse", 1, "channels_list")

	arg_26_0._invite_widgets.send_invite_window.content.text_field_active = true
end

ChatView._destroy_send_invite_window = function (self)
	-- function 27
	table.clear(self._invite_widgets)
	Managers.input:device_unblock_service("keyboard", 1, "chat_view")
	Managers.input:device_unblock_service("mouse", 1, "chat_view")
end

ChatView._update_send_invite_input = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not table.is_empty(self._invite_widgets) then
		return
	end

	local get_service = Managers.input:get_service("channels_list")
	local send_invite_button = self._invite_widgets.send_invite_button
	local send_invite_window = self._invite_widgets.send_invite_window
	local content = send_invite_button.content
	local content_2 = send_invite_window.content
	local button_hotspot = content.button_hotspot
	local input_hotspot = content_2.input_hotspot
	local screen_hotspot = content_2.screen_hotspot
	local widget_hotspot = content_2.widget_hotspot
	local close_hotspot = content_2.close_hotspot

	button_hotspot.disable_button = content_2.chat_text_id == ""

	UIWidgetUtils.animate_default_button(send_invite_button, arg_28_1)

	if not widget_hotspot.is_hover then
		if not close_hotspot.on_pressed then
			self:_destroy_send_invite_window()
		elseif not input_hotspot.on_pressed then
			content_2.text_field_active = true
		elseif not button_hotspot.on_pressed then
			self:_destroy_send_invite_window()

			local content_3 = self._widgets.frame_widget.content

			content_3.chat_text.text = "/invite " .. content_2.chat_text_id

			self:_send_message(content_3)
		elseif not widget_hotspot.on_pressed then
			content_2.text_field_active = false
		end
	elseif not screen_hotspot.on_pressed then
		self:_destroy_send_invite_window()
	end

	if not get_service:get("deactivate_chat_input") then
		self:_destroy_send_invite_window()
	elseif not content_2.text_field_active then
		if not get_service:get("execute_chat_input") then
			if content_2.chat_text_id ~= "" then
				self:_destroy_send_invite_window()
				self:_destroy_send_invite_window()

				local content_4 = self._widgets.frame_widget.content

				content_4.chat_text.text = "/invite " .. content_2.chat_text_id

				self:_send_message(content_4)
			end

			content_2.text_field_active = false
			content_2.caret_index = 1
			content_2.text_index = 1
			content_2.chat_text_id = ""
		elseif content_2.caret_index < ChatView.MAX_CHARS then
			local keystrokes = Keyboard.keystrokes()

			content_2.chat_text_id, content_2.caret_index = KeystrokeHelper.parse_strokes(content_2.chat_text_id, content_2.caret_index, "insert", keystrokes)
		elseif not get_service:get("chat_backspace_pressed") then
			local tbl = {
				Keyboard.BACKSPACE
			}

			content_2.chat_text_id, content_2.caret_index = KeystrokeHelper.parse_strokes(content_2.chat_text_id, content_2.caret_index, "insert", tbl)
		end
	end
end

ChatView._create_create_channels_window = function (arg_29_0)
	-- function 29
	local widget_definitions = var_0_0.widget_definitions
	local scenegraph_definition = var_0_0.scenegraph_definition

	arg_29_0._create_channel_widgets.create_channel_window = UIWidget.init(widget_definitions.create_channel_window)
	arg_29_0._create_channel_widgets.create_button = UIWidget.init(widget_definitions.inner_create_channel_button)

	Managers.input:block_device_except_service("channels_list", "keyboard", 1, "channels_list")
	Managers.input:block_device_except_service("channels_list", "mouse", 1, "channels_list")

	arg_29_0._create_channel_widgets.create_channel_window.content.text_field_active = true
end

ChatView._destroy_create_channel_window = function (self, arg_30_1)
	-- function 30
	table.clear(self._create_channel_widgets)
	Managers.input:device_unblock_service("keyboard", 1, "chat_view")
	Managers.input:device_unblock_service("mouse", 1, "chat_view")

	if not arg_30_1 then
		self:_create_channels_list()
	end
end

ChatView._update_create_channel_input = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not table.is_empty(self._create_channel_widgets) then
		return
	end

	local flag = false
	local flag_2 = false
	local get_service = Managers.input:get_service("channels_list")
	local create_button = self._create_channel_widgets.create_button
	local create_channel_window = self._create_channel_widgets.create_channel_window
	local content = create_button.content
	local content_2 = create_channel_window.content
	local button_hotspot = content.button_hotspot
	local input_hotspot = content_2.input_hotspot
	local screen_hotspot = content_2.screen_hotspot
	local widget_hotspot = content_2.widget_hotspot
	local close_hotspot = content_2.close_hotspot

	button_hotspot.disable_button = content_2.chat_text_id == ""

	UIWidgetUtils.animate_default_button(create_button, arg_31_1)

	if not widget_hotspot.is_hover then
		if not close_hotspot.on_pressed then
			self:_destroy_create_channel_window()
		elseif not input_hotspot.on_pressed then
			content_2.text_field_active = true
		elseif not button_hotspot.on_pressed then
			self:_destroy_create_channel_window(true)
			Managers.chat:send_chat_message(1, nil, "/join #" .. content_2.chat_text_id, flag, nil, flag_2, self._recent_message_index, content_2.chat_text_id, Irc.CHANNEL_MSG)
		elseif not widget_hotspot.on_pressed then
			content_2.text_field_active = false
		end
	elseif not screen_hotspot.on_pressed then
		self:_destroy_create_channel_window()
	end

	if not get_service:get("deactivate_chat_input") then
		self:_destroy_create_channel_window()
	elseif not content_2.text_field_active then
		if not get_service:get("execute_chat_input") then
			if content_2.chat_text_id ~= "" then
				self:_destroy_create_channel_window(true)
				Managers.chat:send_chat_message(1, nil, "/join #" .. content_2.chat_text_id, flag, nil, flag_2, self._recent_message_index, content_2.chat_text_id, Irc.CHANNEL_MSG)
			end

			content_2.text_field_active = false
			content_2.caret_index = 1
			content_2.text_index = 1
			content_2.chat_text_id = ""
		elseif content_2.caret_index < ChatView.MAX_CHANNEL_NAME then
			local keystrokes = Keyboard.keystrokes()

			content_2.chat_text_id, content_2.caret_index = KeystrokeHelper.parse_strokes(content_2.chat_text_id, content_2.caret_index, "insert", keystrokes)

			for i, v in ipairs(ESCAPE_CHARACTERS) do
				content_2.chat_text_id = string.gsub(content_2.chat_text_id, "%" .. v, "")
			end

			content_2.chat_text_id = string.format(content_2.chat_text_id, "%w")
			content_2.chat_text_id = string.gsub(content_2.chat_text_id, "%s", "")
			content_2.caret_index = Utf8.length(content_2.chat_text_id) + 1
		elseif not get_service:get("chat_backspace_pressed") then
			local tbl = {
				Keyboard.BACKSPACE
			}

			content_2.chat_text_id, content_2.caret_index = KeystrokeHelper.parse_strokes(content_2.chat_text_id, content_2.caret_index, "insert", tbl)
		end
	end
end

local tbl_5 = {}

ChatView._create_channels_list = function (self)
	-- function 32
	local widget_definitions = var_0_0.widget_definitions
	local scenegraph_definition = var_0_0.scenegraph_definition

	self._channels_list_widgets.channel_window_widget = UIWidget.init(widget_definitions.channels_window)

	local input = Managers.input
	local get_service = input:get_service("channels_list")

	input:block_device_except_service("channels_list", "keyboard", 1, "channels_list")
	input:block_device_except_service("channels_list", "mouse", 1, "channels_list")

	local var_32_4 = UIWidget.init(widget_definitions.channel_entry)

	self._channels_list_widgets.channel_entry = var_32_4

	local style = var_32_4.style
	local icon = style.icon
	local channel_name = style.channel_name
	local num_members = style.num_members
	local background = style.background
	local _ui_scenegraph = self._ui_scenegraph
	local size = _ui_scenegraph[_ui_scenegraph[var_32_4.scenegraph_id].parent].size
	local channels_list_settings = var_0_0.channels_list_settings
	local channels_width_spacing = channels_list_settings.channels_width_spacing
	local channels_height_spacing = channels_list_settings.channels_height_spacing
	local channels_offset = channels_list_settings.channels_offset
	local channels_per_row = channels_list_settings.channels_per_row
	local max_rows = channels_list_settings.max_rows
	local num = size[1] - channels_offset[1] * 2 - (channels_per_row - 1) * channels_width_spacing
	local num_2 = size[2] - -channels_offset[2] * 2 - (max_rows - 3) * channels_height_spacing
	local num_3 = num / channels_per_row
	local num_4 = num_2 / (max_rows - 2)

	channels_list_settings.channels_entry_size = {
		num_3,
		num_4
	}
	icon.texture_size = {
		num_4 - channels_width_spacing * 2,
		num_4 - channels_height_spacing * 2
	}
	channel_name.offset[1] = num_4 - channels_width_spacing * 2 + channels_width_spacing
	num_members.offset[1] = num_4 - channels_width_spacing * 2 + channels_width_spacing
	background.size[1] = channels_list_settings.channels_entry_size[1]
	background.size[2] = channels_list_settings.channels_entry_size[2] - channels_height_spacing

	local style_2 = var_32_4.style
	local var_32_23 = _ui_scenegraph[var_32_4.scenegraph_id]

	var_32_23.size[1] = channels_list_settings.channels_entry_size[1]
	var_32_23.size[2] = channels_list_settings.channels_entry_size[2]

	local var_32_24 = UIWidget.init(widget_definitions.join_channel_button)

	self._channels_list_widgets.join_button = var_32_24
	var_32_24.content.button_hotspot.disable_button = true

	local var_32_25 = UIWidget.init(widget_definitions.create_channel_button)

	self._channels_list_widgets.create_channel_button = var_32_25

	local var_32_26 = UIWidget.init(widget_definitions.recent_channels_button)

	self._channels_list_widgets.recent_channels_button = var_32_26

	table.clear(self._popular_channel_list)
	table.clear(self._popular_channel_list_lookup)
	Irc.list_channels()

	self._list_channels_cbs[#self._list_channels_cbs + 1] = callback(self, "cb_populate_channels_list", nil)
	self._channels_list_widgets.channel_window_widget.content.fetching_channels = true
end

ChatView._destroy_channels_list = function (self)
	-- function 33
	table.clear(tbl_5)
	table.clear(self._channels_list_widgets)
	Managers.input:device_unblock_service("keyboard", 1, "chat_view")
	Managers.input:device_unblock_service("mouse", 1, "chat_view")
end

ChatView.cb_populate_channels_list = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	if not table.is_empty(self._channels_list_widgets) then
		return
	end

	table.clear(tbl_5)

	local channels_list_settings = var_0_0.channels_list_settings
	local content = self._channels_list_widgets.channel_window_widget.content

	content.updating_channels = false
	content.info_id = string.format("Search results for %q", arg_34_1)

	for i, v in ipairs(arg_34_2) do
		if not arg_34_1 and not string.find(v, arg_34_1) then
			tbl_5[#tbl_5 + 1] = v
		end
	end

	channels_list_settings.current_rows = math.ceil(#tbl_5 / channels_list_settings.channels_per_row)
	self._channels_list_widgets.channel_window_widget.content.fetching_channels = false
end

ChatView._handle_and_draw_channels_list = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	-- function 35
	local channels_list_settings = var_0_0.channels_list_settings
	local channel_window_widget = self._channels_list_widgets.channel_window_widget

	UIRenderer.draw_widget(arg_35_1, channel_window_widget)

	local join_button = self._channels_list_widgets.join_button
	local create_channel_button = self._channels_list_widgets.create_channel_button
	local recent_channels_button = self._channels_list_widgets.recent_channels_button

	UIRenderer.draw_widget(arg_35_1, join_button)
	UIRenderer.draw_widget(arg_35_1, create_channel_button)
	UIRenderer.draw_widget(arg_35_1, recent_channels_button)

	local min = math.min
	local current_rows = channels_list_settings.current_rows

	current_rows = current_rows or 0

	local var_35_7 = min(current_rows, channels_list_settings.max_rows)
	local channels_width_spacing = channels_list_settings.channels_width_spacing
	local channels_height_spacing = channels_list_settings.channels_height_spacing
	local channels_per_row = channels_list_settings.channels_per_row
	local channels_entry_size = channels_list_settings.channels_entry_size
	local channel_entry = self._channels_list_widgets.channel_entry
	local content = channel_entry.content
	local style = channel_entry.style
	local offset = channel_entry.offset
	local channels_offset = channels_list_settings.channels_offset

	offset[2] = channels_offset[2]

	local var_35_17

	for i = 1, math.min(var_35_7, 4) do
		offset[2] = channels_offset[2] - (i - 1) * channels_entry_size[2] - (i - 1) * channels_height_spacing

		for j = 1, channels_per_row do
			local num = (i - 1) * channels_per_row + j

			if not tbl_5[num] then
				break
			else
				local split_deprecated = string.split_deprecated(tbl_5[num], ",")

				content.channel_name = split_deprecated[1]
				content.channel_name_id = UIRenderer.crop_text_width(self._ui_renderer, content.channel_name, 160, style.channel_name)
				content.num_members_id = split_deprecated[2] .. " Member(s)"
			end

			offset[1] = channels_offset[1] + (j - 1) * channels_entry_size[1] + (j - 1) * channels_width_spacing

			UIRenderer.draw_widget(arg_35_1, channel_entry)

			if not content.hotspot.on_pressed then
				if content.selected_channel == content.channel_name then
					content.selected_channel = nil
				else
					content.selected_channel = content.channel_name
				end
			end
		end
	end

	join_button.content.button_hotspot.disable_button = content.selected_channel == nil
end

ChatView._update_channels_list_input = function (self, arg_36_1, arg_36_2)
	-- function 36
	if not table.is_empty(self._channels_list_widgets) then
		return
	end

	local get_service = Managers.input:get_service("channels_list")
	local channel_entry = self._channels_list_widgets.channel_entry
	local join_button = self._channels_list_widgets.join_button
	local create_channel_button = self._channels_list_widgets.create_channel_button
	local recent_channels_button = self._channels_list_widgets.recent_channels_button
	local content = self._channels_list_widgets.channel_window_widget.content
	local content_2 = join_button.content
	local content_3 = create_channel_button.content
	local content_4 = recent_channels_button.content
	local content_5 = channel_entry.content
	local input_hotspot = content.input_hotspot
	local screen_hotspot = content.screen_hotspot
	local widget_hotspot = content.widget_hotspot
	local close_hotspot = content.close_hotspot
	local button_hotspot = content_2.button_hotspot
	local button_hotspot_2 = content_3.button_hotspot
	local button_hotspot_3 = content_4.button_hotspot
	local channels_list_hotspot = content.channels_list_hotspot

	if not content.updating_channels then
		return
	end

	UIWidgetUtils.animate_default_button(join_button, arg_36_1)
	UIWidgetUtils.animate_default_button(create_channel_button, arg_36_1)
	UIWidgetUtils.animate_default_button(recent_channels_button, arg_36_1)

	if not get_service:get("deactivate_chat_input") then
		self:_destroy_channels_list()
	elseif not input_hotspot.on_pressed then
		content.text_field_active = true
	elseif not widget_hotspot.is_hover then
		if not close_hotspot.on_pressed then
			content.text_field_active = false

			self:_destroy_channels_list()
		elseif not button_hotspot.on_pressed then
			local selected_channel = content_5.selected_channel

			self:_destroy_channels_list()

			if not self._channels[selected_channel] then
				self:_change_channel(selected_channel)
			else
				local flag = false
				local flag_2 = false

				Managers.chat:send_chat_message(1, nil, "/join " .. selected_channel, flag, nil, flag_2, self._recent_message_index, selected_channel, Irc.CHANNEL_MSG)
			end
		elseif not button_hotspot_2.on_pressed then
			self:_destroy_channels_list()
			self:_create_create_channels_window()
		elseif not button_hotspot_3.on_pressed then
			self:_destroy_channels_list()
			self:_create_recent_channels_window()
		elseif not widget_hotspot.on_pressed then
			content.text_field_active = false
		end
	elseif not screen_hotspot.on_pressed then
		self:_destroy_channels_list()
	end

	if not content.text_field_active then
		if not get_service:get("execute_chat_input") then
			if content.chat_text_id ~= "" then
				table.clear(self._popular_channel_list)
				table.clear(self._popular_channel_list_lookup)
				Irc.list_channels()

				self._list_channels_cbs[#self._list_channels_cbs + 1] = callback(self, "cb_populate_channels_list", content.chat_text_id)
			end

			content.text_field_active = false
			content.caret_index = 1
			content.text_index = 1
			content.chat_text_id = ""
		elseif content.caret_index < ChatView.MAX_CHANNEL_NAME then
			local keystrokes = Keyboard.keystrokes()

			if not table.is_empty(keystrokes) then
				content.chat_text_id, content.caret_index = KeystrokeHelper.parse_strokes(content.chat_text_id, content.caret_index, "insert", keystrokes)

				for i, v in ipairs(ESCAPE_CHARACTERS) do
					content.chat_text_id = string.gsub(content.chat_text_id, "%" .. v, "")
				end

				content.chat_text_id = string.format(content.chat_text_id, "%w")
				content.chat_text_id = string.gsub(content.chat_text_id, "%s", "")
				content.caret_index = Utf8.length(content.chat_text_id) + 1
			end
		elseif not get_service:get("chat_backspace_pressed") then
			local tbl = {
				Keyboard.BACKSPACE
			}

			content.chat_text_id, content.caret_index = KeystrokeHelper.parse_strokes(content.chat_text_id, content.caret_index, "insert", tbl)
		end
	end
end

ChatView._update_input = function (self, arg_37_1, arg_37_2)
	-- function 37
	local get_service = self._input_manager:get_service("chat_view")

	self:_handle_user_pressed()
	self:_handle_user_list_scroll_input(get_service)
	self:_handle_link_presses()

	local content = self._widgets.frame_widget.content
	local channel_list_frame = self._channel_list_widgets.channel_list_frame
	local private_user_list_frame = self._private_list_widgets.private_user_list_frame
	local recent_channels_list_frame = self._recent_channels_list_widgets.recent_channels_list_frame
	local command_list_frame = self._commands_list_widgets.command_list_frame
	local filtered_user_names_list_frame = self._filtered_user_names_list_widgets.filtered_user_names_list_frame
	local emoji_list_frame = self._emoji_widgets.emoji_list_frame
	local _current_channel_name = self._current_channel_name

	_current_channel_name = _current_channel_name or " "
	content.channel_name = _current_channel_name

	if not get_service:get("deactivate_chat_input", true) then
		if not content.text_field_active then
			content.text_field_active = false
			content.chat_text.text = ""
		else
			self:_exit(true)

			return
		end
	end

	local flag = false
	local flag_2 = false
	local text_input_hotspot = content.text_input_hotspot
	local screen_hotspot = content.screen_hotspot
	local channel_hotspot = content.channel_hotspot
	local left_hotspot = content.left_hotspot
	local right_hotspot = content.right_hotspot
	local button_hotspot = self._widgets.private_messages_widget.content.button_hotspot
	local button_hotspot_2 = self._widgets.send_invite_widget.content.button_hotspot
	local button_hotspot_3 = self._widgets.channels_widget.content.button_hotspot
	local button_hotspot_4 = self._widgets.emoji_widget.content.button_hotspot

	if not command_list_frame then
		local content_2 = command_list_frame.content
		local hotspot = content_2.hotspot
		local screen_hotspot_2 = content_2.screen_hotspot

		if not hotspot.on_pressed then
			self:_handle_command_list_input()
		elseif not screen_hotspot_2.on_pressed then
			self:_destroy_command_list()
		end
	elseif not emoji_list_frame then
		local content_3 = emoji_list_frame.content
		local hotspot_2 = content_3.hotspot

		if not (not content_3.screen_hotspot.on_pressed and hotspot_2.on_pressed) then
			self:_destroy_emoji_list()
		else
			self:_handle_and_draw_emoji_list_input(arg_37_1)
		end
	elseif not filtered_user_names_list_frame then
		local content_4 = filtered_user_names_list_frame.content
		local hotspot_3 = content_4.hotspot
		local screen_hotspot_3 = content_4.screen_hotspot

		if not hotspot_3.on_pressed then
			self:_handle_filtered_user_names_list_input()
		elseif not screen_hotspot_3.on_pressed then
			self:_destroy_filtered_user_names_list()
		end
	elseif not channel_list_frame then
		local content_5 = channel_list_frame.content
		local hotspot_4 = content_5.hotspot
		local screen_hotspot_4 = content_5.screen_hotspot

		if not hotspot_4.on_pressed then
			self:_handle_channel_list_input()
		elseif not screen_hotspot_4.on_pressed then
			self:_destroy_channel_list()
		end
	elseif not private_user_list_frame then
		local content_6 = private_user_list_frame.content
		local hotspot_5 = content_6.hotspot
		local screen_hotspot_5 = content_6.screen_hotspot

		if not hotspot_5.on_pressed then
			self:_handle_private_list_input()
		elseif not screen_hotspot_5.on_pressed then
			self:_destroy_private_list()
		end
	elseif not button_hotspot_4.on_pressed then
		self:_create_emoji_list()
	elseif not channel_hotspot.on_pressed then
		self:_create_channel_list()

		flag = true
		flag_2 = true
	elseif not button_hotspot_3.on_pressed then
		self:_create_channels_list()

		flag = true
		flag_2 = true
	elseif not button_hotspot.on_pressed then
		self:_create_private_list()

		flag = true
		flag_2 = true
	elseif not button_hotspot_2.on_pressed then
		self:_create_invite_window()

		flag = true
		flag_2 = true
	elseif not text_input_hotspot.on_pressed then
		content.text_field_active = true
	elseif not screen_hotspot.on_pressed then
		flag = true
		flag_2 = true
	elseif not left_hotspot.on_release then
		self._current_tab_offset_index = math.max(self._current_tab_offset_index - 1, 1)
		self._ui_animations.tab_animation = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.channel_tab_anchor.position, 1, self._ui_scenegraph.channel_tab_anchor.position[1], -self._ui_scenegraph.channel_tab_anchor.size[1] * (self._current_tab_offset_index - 1) + 10, 0.25, math.easeOutCubic)
	elseif not right_hotspot.on_release then
		self._current_tab_offset_index = math.min(self._current_tab_offset_index + 1, math.max(#self._channel_tabs - 3, 1))

		print(self._current_tab_offset_index)

		self._ui_animations.tab_animation = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.channel_tab_anchor.position, 1, self._ui_scenegraph.channel_tab_anchor.position[1], -self._ui_scenegraph.channel_tab_anchor.size[1] * (self._current_tab_offset_index - 1) + 10, 0.25, math.easeOutCubic)
	end

	local send_invite_widget = self._widgets.send_invite_widget
	local channels_widget = self._widgets.channels_widget
	local commands_widget = self._widgets.commands_widget
	local emoji_widget = self._widgets.emoji_widget

	UIWidgetUtils.animate_default_button(send_invite_widget, arg_37_1)
	UIWidgetUtils.animate_default_button(channels_widget, arg_37_1)
	UIWidgetUtils.animate_default_button(commands_widget, arg_37_1)
	UIWidgetUtils.animate_default_button(emoji_widget, arg_37_1)

	if not content.text_field_active then
		if not get_service:get("execute_chat_input") then
			self:_send_message(content)
		elseif not get_service:get("chat_next_old_message") then
			local get_recently_sent_messages = Managers.chat:get_recently_sent_messages()
			local count = #get_recently_sent_messages

			if count > 0 then
				if not self._recent_message_index then
					if string.len(content.chat_text.text) > 0 then
						self._old_chat_message = content.chat_text.text
					end

					self._recent_message_index = count
				else
					self._recent_message_index = math.max(self._recent_message_index - 1, 1)
				end

				content.chat_text.text = get_recently_sent_messages[self._recent_message_index]
				content.caret_index = #KeystrokeHelper._build_utf8_table(content.chat_text.text) + 1
			end
		elseif not get_service:get("chat_previous_old_message") then
			local get_recently_sent_messages_2 = Managers.chat:get_recently_sent_messages()
			local count_2 = #get_recently_sent_messages_2

			if not self._recent_message_index then
				if not (not (count_2 > 0) or not (count_2 > self._recent_message_index)) then
					self._recent_message_index = math.clamp(self._recent_message_index + 1, 1, count_2)
					content.chat_text.text = get_recently_sent_messages_2[self._recent_message_index]
					content.caret_index = #KeystrokeHelper._build_utf8_table(content.chat_text.text) + 1
				elseif self.recent_message_index ~= count_2 or not self._old_chat_message then
					content.chat_text.text = self._old_chat_message
					content.caret_index = #KeystrokeHelper._build_utf8_table(content.chat_text.text) + 1
					self._recent_message_index = nil
					self._old_chat_message = nil
				end
			end
		elseif not get_service:get("chat_backspace_word") then
			local _build_utf8_table = KeystrokeHelper._build_utf8_table(content.chat_text.text)
			local num = content.caret_index - 1
			local flag_3 = false
			local num_2 = 0

			for i = num, 1, -1 do
				local var_37_46 = _build_utf8_table[i]

				if _build_utf8_table[i] ~= " " or not flag_3 then
					num = i + 1

					break
				else
					table.remove(_build_utf8_table, i)

					num = i

					if _build_utf8_table[i] ~= " " then
						flag_3 = true
					end
				end
			end

			content.caret_index = math.clamp(num, 1, #_build_utf8_table + 1)
			content.chat_text.text = ""

			local num_3 = 0

			for i_2, v in ipairs(_build_utf8_table) do
				content.chat_text.text = content.chat_text.text .. v
				num_3 = num_3 + 1
			end
		elseif content.caret_index <= ChatView.MAX_CHARS then
			local keystrokes = Keyboard.keystrokes()
			local button_index = Keyboard.button_index("left ctrl")

			if not Keyboard.pressed(button_index) then
				local flag_4

				flag_4 = Keyboard.button(button_index) > 0
			end

			content.chat_text.text, content.caret_index = KeystrokeHelper.parse_strokes(content.chat_text.text, content.caret_index, "insert", keystrokes)

			if #keystrokes > 0 then
				local text = content.chat_text.text
				local find, var_37_53 = string.find(text, "/msg ")
				local find_2, var_37_55 = string.find(text, " ", (var_37_53 or 0) + 1)

				if not (not var_37_53 and find_2) then
					local lower = string.lower(string.gsub(text, "/msg ", ""))

					self:_create_filtered_user_list(lower)
				end
			end
		end
	elseif not get_service:get("execute_chat_input") then
		content.text_field_active = true
	end

	if not flag then
		content.text_field_active = false

		if not flag_2 then
			content.chat_text.text = ""
			content.caret_index = 1
		end
	end
end

ChatView._handle_command_list = function (self)
	-- function 38
	local content = self._widgets.frame_widget.content
	local button_hotspot = self._widgets.commands_widget.content.button_hotspot

	if not (button_hotspot.on_pressed or button_hotspot.disable_button) then
		if #Keyboard.keystrokes() == 0 then
			return
		end

		local text = content.chat_text.text
		local find, var_38_4 = string.find(text, "/")
		local find_2 = string.find(text, " ")
		local len = string.len(text)

		if not text and string.find(text, "/") ~= 1 or not find_2 then
			table.clear(self._commands_list_widgets)

			return
		end

		self._ui_scenegraph.commands_list.position[1] = 25
	else
		button_hotspot.disable_button = true
		self._ui_scenegraph.commands_list.position[1] = -60
	end

	if table.size(self._commands_list_widgets) == 0 then
		local widget_definitions = var_0_0.widget_definitions
		local create_command_entry_func = widget_definitions.create_command_entry_func
		local num = 0
		local num_2 = 0
		local num_3 = 100

		for i, v in ipairs(tbl_3) do
			local command = v.command
			local var_38_13 = UIWidget.init(create_command_entry_func(command, v.description_text, v.parameter, num_3, v.color, -20 - 20 * num, content.chat_text))

			self._commands_list_widgets["command_" .. num + 1] = var_38_13
			num = num + 1

			local command_2 = var_38_13.style.command
			local var_38_15, var_38_16 = UIFontByResolution(command_2, nil)
			local var_38_17 = var_38_15[1]
			local font_size = command_2.font_size
			local num_4 = UIRenderer.text_size(self._ui_renderer, command .. v.description_text, var_38_17, font_size) + 100

			num_2 = math.max(num_2, num_4)
		end

		self._commands_list_widgets.command_list_frame = UIWidget.init(widget_definitions.commands_list_frame)
		self._ui_scenegraph.commands_list.size[2] = 40 + num * 20
		self._ui_scenegraph.commands_list.size[1] = num_2 + 10
		self._ui_scenegraph.commands_list_entry.size[1] = num_2 + 20
	end
end

ChatView._create_channel_list = function (self)
	-- function 39
	local get_channels = Managers.irc:get_channels()
	local widget_definitions = var_0_0.widget_definitions
	local create_channel_entry_func = widget_definitions.create_channel_entry_func
	local num = 0
	local num_2 = 200
	local num_3 = 0

	for k, v in pairs(get_channels) do
		local var_39_6 = UIWidget.init(create_channel_entry_func(k, -10 - 30 * num))

		self._channel_list_widgets["channel_" .. num + 1] = var_39_6
		num = num + 1

		local channel_name = var_39_6.style.channel_name
		local var_39_8, var_39_9 = UIFontByResolution(channel_name, nil)
		local var_39_10 = var_39_8[1]
		local font_size = channel_name.font_size
		local text_size = UIRenderer.text_size(self._ui_renderer, k, var_39_10, font_size)

		num_3 = math.max(num_3, text_size)
	end

	self._channel_list_widgets.channel_list_frame = UIWidget.init(widget_definitions.channel_list_frame)
	self._ui_scenegraph.channel_list.size[2] = 30 + num * 30
	self._ui_scenegraph.channel_list.size[1] = num_3 + 125
	self._ui_scenegraph.channel_list_entry.size[1] = num_3 + 30
end

ChatView._destroy_emoji_list = function (self)
	-- function 40
	table.clear(self._emoji_widgets)

	self._base_offset = 0
end

ChatView._create_emoji_list = function (self)
	-- function 41
	local widget_definitions = var_0_0.widget_definitions

	table.clear(self._emoji_widgets)

	self._emoji_widgets.emoji_list_frame = UIWidget.init(widget_definitions.create_emoji_frame_func())
	self._emoji_widgets.emoji = UIWidget.init(widget_definitions.create_emoji_func())

	local emoji_list_settings = var_0_0.emoji_list_settings
	local count = #EMOJI_SETTINGS

	emoji_list_settings.current_rows = math.ceil(count / emoji_list_settings.emojis_per_row)

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("chat_view")
	local _render_settings = self._render_settings
	local emoji = self._emoji_widgets.emoji
	local var_41_8 = _ui_scenegraph[emoji.scenegraph_id]
	local num = emoji_list_settings.max_rows - 1
	local num_2 = (num + 2) * var_41_8.size[2] + (num - 1) * emoji_list_settings.emoji_height_spacing

	emoji.offset[2] = num_2
	emoji_list_settings.height = num_2

	local emoji_list_frame = self._emoji_widgets.emoji_list_frame
	local content = emoji_list_frame.content
	local style = emoji_list_frame.style
	local var_41_14 = _ui_scenegraph[emoji_list_frame.scenegraph_id]

	var_41_14.size = {
		emoji_list_settings.emoji_size[1] * emoji_list_settings.emojis_per_row + (emoji_list_settings.emojis_per_row - 1) * emoji_list_settings.emoji_width_spacing + emoji_list_settings.emoji_offset[1] * 2 + 20,
		num_2 + emoji_list_settings.emoji_offset[2] * 2
	}
	style.mask_rect.offset[2] = emoji_list_settings.emoji_size[2] + emoji_list_settings.emoji_height_spacing * 3
	style.mask_rect.size = {
		var_41_14.size[1],
		var_41_14.size[2] - (emoji_list_settings.emoji_size[2] + emoji_list_settings.emoji_height_spacing * 3)
	}

	local var_41_15 = UIWidget.init(widget_definitions.create_emoji_scroller_func())

	_ui_scenegraph[var_41_15.scenegraph_id].size[2] = num_2 / emoji_list_settings.max_rows

	if emoji_list_settings.current_rows > emoji_list_settings.max_rows then
		self._emoji_widgets.emoji_scrollbar = var_41_15
	end
end

ChatView._handle_and_draw_emoji_list_input = function (self, arg_42_1)
	-- function 42
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("chat_view")
	local _render_settings = self._render_settings
	local emoji_list_settings = var_0_0.emoji_list_settings
	local emoji = self._emoji_widgets.emoji
	local content = emoji.content
	local offset = emoji.offset
	local emoji_list_frame = self._emoji_widgets.emoji_list_frame
	local content_2 = emoji_list_frame.content
	local style = emoji_list_frame.style
	local flag = false
	local current_rows = emoji_list_settings.current_rows
	local emojis_per_row = emoji_list_settings.emojis_per_row
	local emoji_size = emoji_list_settings.emoji_size
	local emoji_offset = emoji_list_settings.emoji_offset
	local emoji_width_spacing = emoji_list_settings.emoji_width_spacing
	local emoji_height_spacing = emoji_list_settings.emoji_height_spacing
	local height = emoji_list_settings.height
	local max_rows = emoji_list_settings.max_rows
	local max = math.max(max_rows, current_rows)
	local emoji_scrollbar = self._emoji_widgets.emoji_scrollbar

	self._emoji_scroll = 0

	if not emoji_scrollbar then
		local var_42_22 = get_service:get("chat_scroll")[2]

		self._emoji_scroll = not (math.abs(var_42_22) > math.abs(self._emoji_scroll)) or not var_42_22 or self._emoji_scroll
	end

	local num = current_rows * emoji_size[2] + (current_rows - 1) * emoji_offset[2]
	local clamp = math.clamp
	local _base_offset = self._base_offset

	_base_offset = _base_offset or 0
	self._base_offset = clamp(_base_offset - self._emoji_scroll, 0, num)

	local floor = math.floor(self._base_offset / (emoji_size[2] + emoji_offset[2]))

	self._emoji_scroll = math.lerp(math.abs(self._emoji_scroll), 0, arg_42_1 * 2.5) * math.sign(self._emoji_scroll)
	offset[2] = height + self._base_offset % (emoji_size[2] + emoji_offset[2])

	if not emoji_scrollbar then
		emoji_scrollbar.offset[2] = -(self._base_offset / num) * ((max - 2) * (emoji_size[2] + emoji_offset[2]) + 15)
	end

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_42_1, nil, nil)

	if not emoji_scrollbar then
		UIRenderer.draw_widget(_ui_renderer, emoji_scrollbar)
	end

	UIRenderer.draw_widget(_ui_renderer, emoji_list_frame)

	local flag_2 = false

	for i = 1 + floor, max + floor do
		offset[2] = offset[2] - emoji_size[2] - emoji_offset[2]

		for j = 1, emojis_per_row do
			offset[1] = (j - 1) * (emoji_size[1] + emoji_width_spacing)

			local num_2 = (i - 1) * emojis_per_row + j
			local var_42_29 = EMOJI_SETTINGS[num_2]
			local texture

			if not var_42_29 then
				texture = var_42_29.texture

				if not texture then
					-- Nothing
				end
			end

			texture = nil

			::label_42_0::

			content.texture_id = texture

			UIRenderer.draw_widget(_ui_renderer, emoji)

			if not var_42_29 then
				local hotspot = content.hotspot

				if not hotspot.on_pressed then
					local keys = EMOJI_SETTINGS[num_2].keys
					local content_3 = self._widgets.frame_widget.content

					content_3.chat_text.text = content_3.chat_text.text .. keys
					content_3.caret_index = #KeystrokeHelper._build_utf8_table(content_3.chat_text.text) + 1
					self._widgets.frame_widget.content.text_field_active = true
					flag = true
				elseif not hotspot.is_hover then
					flag_2 = true
					content_2.emoji_text_id = EMOJI_SETTINGS[num_2].keys
					content_2.emoji_texture_id = EMOJI_SETTINGS[num_2].texture
					style.emoji_texture.texture_size = emoji_size
					style.emoji_texture.offset[1] = 10
					style.emoji_text.offset[1] = style.emoji_texture.offset[1] + emoji_size[1] + emoji_width_spacing
				end
			end
		end

		offset[2] = offset[2] - emoji_height_spacing
	end

	content.texture_id = nil

	if not flag_2 then
		content_2.emoji_text_id = nil
		content_2.emoji_texture_id = nil
	end

	UIRenderer.end_pass(_ui_renderer)

	if not flag then
		self:_destroy_emoji_list()
	end
end

ChatView._create_private_list = function (self)
	-- function 43
	local private_messages_table = self._widgets.chat_output_widget.content.private_messages_table
	local widget_definitions = var_0_0.widget_definitions
	local create_private_user_entry_func = widget_definitions.create_private_user_entry_func
	local content = self._widgets.private_messages_widget.content
	local new_per_user = content.new_per_user
	local num = 0
	local num_2 = 200
	local num_3 = 0

	for k, v in pairs(private_messages_table) do
		local var_43_8 = UIWidget.init(create_private_user_entry_func(k, -20 - 30 * num, new_per_user[k]))

		self._private_list_widgets[k] = var_43_8
		num = num + 1

		local user_name = var_43_8.style.user_name
		local var_43_10, var_43_11 = UIFontByResolution(user_name, nil)
		local var_43_12 = var_43_10[1]
		local font_size = user_name.font_size
		local text_size = UIRenderer.text_size(self._ui_renderer, k, var_43_12, font_size)

		num_3 = math.max(num_3, text_size)
	end

	self._private_list_widgets.private_user_list_frame = UIWidget.init(widget_definitions.private_user_list_frame)
	self._ui_scenegraph.private_user_list.size[2] = 40 + num * 30
	self._ui_scenegraph.private_user_list.size[1] = num_3 + 125
	self._ui_scenegraph.private_user_list.position[2] = self._ui_scenegraph.private_user_list.size[2] + 5
	self._ui_scenegraph.private_user_list_entry.size[1] = num_3 + 40
	content.num_private_messages = 0
end

ChatView._create_filtered_user_list = function (self, arg_44_1)
	-- function 44
	local _update_filter = self:_update_filter(arg_44_1)

	self:_destroy_filtered_user_names_list()

	if not _update_filter then
		return
	end

	local widget_definitions = var_0_0.widget_definitions
	local create_filtered_user_name_entry_func = widget_definitions.create_filtered_user_name_entry_func
	local num = 0
	local num_2 = 0

	for i, v in ipairs(_update_filter) do
		local var_44_5 = UIWidget.init(create_filtered_user_name_entry_func(string.gsub(v, "@", ""), -20 - 30 * num))

		self._filtered_user_names_list_widgets[v] = var_44_5
		num = num + 1

		local user_name = var_44_5.style.user_name
		local var_44_7, var_44_8 = UIFontByResolution(user_name, nil)
		local var_44_9 = var_44_7[1]
		local font_size = user_name.font_size
		local text_size = UIRenderer.text_size(self._ui_renderer, v, var_44_9, font_size)

		num_2 = math.max(num_2, text_size)
	end

	self._filtered_user_names_list_widgets.filtered_user_names_list_frame = UIWidget.init(widget_definitions.filtered_user_names_list_frame)
	self._ui_scenegraph.filtered_user_names_list.size[2] = 40 + num * 25
	self._ui_scenegraph.filtered_user_names_list.size[1] = num_2 + 60
	self._ui_scenegraph.filtered_user_names_list_entry.size[1] = num_2 + 10
end

ChatView._destroy_channel_list = function (self)
	-- function 45
	table.clear(self._channel_list_widgets)
end

ChatView._destroy_private_list = function (self)
	-- function 46
	table.clear(self._private_list_widgets)
end

ChatView._destroy_command_list = function (self)
	-- function 47
	table.clear(self._commands_list_widgets)

	self._widgets.commands_widget.content.button_hotspot.disable_button = false
end

ChatView._destroy_filtered_user_names_list = function (self)
	-- function 48
	table.clear(self._filtered_user_names_list_widgets)
end

ChatView._handle_channel_list_input = function (self)
	-- function 49
	for k, v in pairs(self._channel_list_widgets) do
		local content = v.content

		if not content.channel_hotspot and not content.channel_hotspot.on_pressed then
			local channel_name = content.channel_name

			self:_change_channel(channel_name)
			self:_destroy_channel_list()

			return
		elseif not content.exit_button_hotspot and not content.exit_button_hotspot.on_pressed then
			local flag = false
			local flag_2 = false

			Managers.chat:send_chat_message(1, nil, "/leave " .. content.channel_name, flag, nil, flag_2, self._recent_message_index, content.channel_name, Irc.CHANNEL_MSG)
			self:_destroy_channel_list()

			return
		end
	end
end

ChatView._handle_private_list_input = function (self)
	-- function 50
	for k, v in pairs(self._private_list_widgets) do
		local content = v.content

		if not content.user_hotspot and not content.user_hotspot.on_pressed then
			local user_name = content.user_name

			self:_change_to_private(user_name)
			self:_destroy_private_list()

			return
		elseif not content.exit_button_hotspot and not content.exit_button_hotspot.on_pressed then
			local private_messages_table = self._widgets.chat_output_widget.content.private_messages_table

			private_messages_table[k] = nil
			self._widgets.private_messages_widget.content.has_private_conversations = not table.is_empty(private_messages_table)

			self:_destroy_private_list()
			self:_change_channel(self._current_channel_name)

			return
		end
	end
end

ChatView._handle_command_list_input = function (self)
	-- function 51
	for k, v in pairs(self._commands_list_widgets) do
		local content = v.content

		if not content.command_hotspot and not content.command_hotspot.on_pressed then
			local command = content.command
			local parameter = content.parameter

			parameter = parameter or ""

			local content_2 = self._widgets.frame_widget.content

			content_2.chat_text.text = command .. " " .. parameter
			content_2.caret_index = #KeystrokeHelper._build_utf8_table(content_2.chat_text.text) + 1

			self:_destroy_command_list()

			self._widgets.frame_widget.content.text_field_active = true

			return
		end
	end
end

ChatView._handle_filtered_user_names_list_input = function (self)
	-- function 52
	for k, v in pairs(self._filtered_user_names_list_widgets) do
		local content = v.content

		if not content.user_name_hotspot and not content.user_name_hotspot.on_pressed then
			local user_name = content.user_name
			local content_2 = self._widgets.frame_widget.content

			content_2.chat_text.text = "/msg " .. user_name .. " "
			content_2.caret_index = #KeystrokeHelper._build_utf8_table(content_2.chat_text.text) + 1

			self:_destroy_filtered_user_names_list()

			return
		end
	end
end

ChatView._handle_user_list_scroll_input = function (self, arg_53_1)
	-- function 53
	local _user_list = self._user_list
	local _user_list_read_index = self._user_list_read_index

	if not (_user_list or _user_list_read_index) then
		return
	end

	if not self._widgets.list_area_hotspot_widget.content.hotspot.is_hover then
		return
	end

	local get = arg_53_1:get("chat_scroll")
	local var_53_3

	if not (arg_53_1:get("chat_scroll_up") or not (get[2] > 0.5)) then
		var_53_3 = math.max(_user_list_read_index - 1, 1)
	elseif not (arg_53_1:get("chat_scroll_down") or not (get[2] < 0)) then
		var_53_3 = math.min(_user_list_read_index + 1, #_user_list)
	end

	if not (not var_53_3 and var_53_3 == _user_list_read_index) then
		self:_update_members(var_53_3)
	end
end

ChatView._handle_link_presses = function (self)
	-- function 54
	local chat_output_widget = self._widgets.chat_output_widget

	if not chat_output_widget.content.link_pressed then
		local link_pressed = chat_output_widget.content.link_pressed

		Managers.invite:set_invited_lobby_data(link_pressed.lobby_id)

		chat_output_widget.content.link_pressed = nil

		print("Link Pressed! -> joining game!")
	end
end

ChatView._send_message = function (self, arg_55_1)
	-- function 55
	arg_55_1.chat_text.text = EmojiHelper.replace_emojis(arg_55_1.chat_text.text)

	local parse_emojis = EmojiHelper.parse_emojis(arg_55_1.chat_text.text)

	if not arg_55_1.private_user_name then
		self:_send_private_message(arg_55_1, parse_emojis)
	else
		self:_send_channel_message(arg_55_1, parse_emojis)
	end
end

ChatView._show_welcome_message = function (self)
	-- function 56
	local content = self._widgets.chat_output_widget.content
	local channel_messages_table = content.channel_messages_table
	local _current_channel_name = self._current_channel_name
	local var_56_3 = channel_messages_table[self._current_channel_name]

	var_56_3 = var_56_3 or {}
	channel_messages_table[_current_channel_name] = var_56_3

	local var_56_4 = channel_messages_table[self._current_channel_name]

	for i = 1, #tbl do
		local var_56_5 = tbl[i]
		local tbl_2 = {
			sender = string.format(var_56_5, self._current_channel_name)
		}

		tbl_2.trimmed_sender = tbl_2.sender
		tbl_2.message = ""
		tbl_2.type = nil
		var_56_4[#var_56_4 + 1] = tbl_2
		content.text_start_offset = #var_56_4
	end
end

ChatView._send_channel_message = function (self, arg_57_1, arg_57_2)
	-- function 57
	local flag = false
	local flag_2 = false
	local send_chat_message, var_57_3, var_57_4 = Managers.chat:send_chat_message(1, self._local_player_id, arg_57_1.chat_text.text, flag, nil, flag_2, self._recent_message_index, self._current_channel_name, Irc.CHANNEL_MSG)

	if not send_chat_message then
		if arg_57_1.chat_text.text ~= "" then
			local user_name = Managers.irc:user_name()
			local content = self._widgets.chat_output_widget.content
			local channel_messages_table = content.channel_messages_table
			local _current_channel_name = self._current_channel_name
			local var_57_9 = channel_messages_table[self._current_channel_name]

			var_57_9 = var_57_9 or {}
			channel_messages_table[_current_channel_name] = var_57_9

			local var_57_10 = channel_messages_table[self._current_channel_name]
			local tbl = {
				sender = user_name .. ": ",
				trimmed_sender = self:_strip_identifier_from_user_name(user_name) .. ": ",
				message = arg_57_1.chat_text.text,
				type = Irc.CHANNEL_MSG
			}

			if #arg_57_2 > 0 then
				tbl.emojis = table.clone(arg_57_2)
			end

			var_57_10[#var_57_10 + 1] = tbl
			content.text_start_offset = #var_57_10
		else
			arg_57_1.text_field_active = false
		end
	elseif send_chat_message == "send_message" then
		local var_57_12 = var_57_3[2]
		local str = ""

		for i = 3, #var_57_3 do
			str = str .. " " .. var_57_3[i]
		end

		local content_2 = self._widgets.chat_output_widget.content
		local private_messages_table = content_2.private_messages_table
		local var_57_16 = private_messages_table[var_57_12]

		var_57_16 = var_57_16 or {}
		private_messages_table[var_57_12] = var_57_16

		local var_57_17 = private_messages_table[var_57_12]
		local tbl_2 = {
			sender = "To [" .. var_57_12 .. "]: ",
			trimmed_sender = "To [" .. self:_strip_identifier_from_user_name(var_57_12) .. "]: ",
			message = str,
			type = Irc.PRIVATE_MSG
		}

		if #arg_57_2 > 0 then
			tbl_2.emojis = table.clone(arg_57_2)
		end

		var_57_17[#var_57_17 + 1] = tbl_2
		content_2.text_start_offset = #var_57_17

		self:_change_to_private(var_57_12)
	elseif send_chat_message == "game_invite" then
		local user_name_2 = Managers.irc:user_name()
		local str_2 = ""

		for j = 2, #var_57_3 do
			str_2 = str_2 .. " " .. var_57_3[j]
		end

		local content_3 = self._widgets.chat_output_widget.content
		local channel_messages_table_2 = content_3.channel_messages_table
		local _current_channel_name_2 = self._current_channel_name
		local var_57_24 = channel_messages_table_2[self._current_channel_name]

		var_57_24 = var_57_24 or {}
		channel_messages_table_2[_current_channel_name_2] = var_57_24

		local var_57_25 = channel_messages_table_2[self._current_channel_name]
		local tbl_3 = {
			sender = user_name_2 .. ": ",
			trimmed_sender = self:_strip_identifier_from_user_name(user_name_2) .. ": ",
			message = str_2,
			type = Irc.CHANNEL_MSG
		}

		if not var_57_4 then
			tbl_3.link = var_57_4
		end

		if #arg_57_2 > 0 then
			tbl_3.emojis = table.clone(arg_57_2)
		end

		var_57_25[#var_57_25 + 1] = tbl_3
		content_3.text_start_offset = #var_57_25
	elseif send_chat_message == "clear_chat" then
		local content_4 = self._widgets.chat_output_widget.content
		local channel_messages_table_3 = content_4.channel_messages_table
		local _current_channel_name_3 = self._current_channel_name
		local var_57_30 = channel_messages_table_3[self._current_channel_name]

		var_57_30 = var_57_30 or {}
		channel_messages_table_3[_current_channel_name_3] = var_57_30

		local var_57_31 = channel_messages_table_3[self._current_channel_name]

		table.clear(var_57_31)

		content_4.text_start_offset = #var_57_31
	end

	arg_57_1.chat_text.text = ""
	arg_57_1.caret_index = 1
	self._recent_message_index = nil
end

ChatView._send_private_message = function (self, arg_58_1, arg_58_2)
	-- function 58
	local private_user_name = arg_58_1.private_user_name
	local flag = false
	local flag_2 = false
	local send_chat_message, var_58_4, var_58_5 = Managers.chat:send_chat_message(1, self._local_player_id, arg_58_1.chat_text.text, flag, nil, flag_2, self._recent_message_index, private_user_name, Irc.PRIVATE_MSG)

	if not send_chat_message then
		if arg_58_1.chat_text.text ~= "" then
			local content = self._widgets.chat_output_widget.content
			local private_messages_table = content.private_messages_table
			local var_58_8 = private_messages_table[private_user_name]

			var_58_8 = var_58_8 or {}
			private_messages_table[private_user_name] = var_58_8

			local var_58_9 = private_messages_table[private_user_name]
			local tbl = {
				sender = "To [" .. private_user_name .. "]: ",
				trimmed_sender = "To [" .. self:_strip_identifier_from_user_name(private_user_name) .. "]: ",
				message = arg_58_1.chat_text.text,
				type = Irc.PRIVATE_MSG
			}

			if #arg_58_2 > 0 then
				tbl.emojis = table.clone(arg_58_2)
			end

			var_58_9[#var_58_9 + 1] = tbl
			content.text_start_offset = #var_58_9
		else
			arg_58_1.text_field_active = false
		end
	elseif send_chat_message == "game_invite" then
		local str = ""

		for i = 2, #var_58_4 do
			str = str .. " " .. var_58_4[i]
		end

		local content_2 = self._widgets.chat_output_widget.content
		local private_messages_table_2 = content_2.private_messages_table
		local var_58_14 = private_messages_table_2[private_user_name]

		var_58_14 = var_58_14 or {}
		private_messages_table_2[private_user_name] = var_58_14

		local var_58_15 = private_messages_table_2[private_user_name]
		local tbl_2 = {
			sender = "To [" .. private_user_name .. "]: ",
			trimmed_sender = "To [" .. self:_strip_identifier_from_user_name(private_user_name) .. "]: ",
			message = str,
			type = Irc.PRIVATE_MSG
		}

		if not var_58_5 then
			tbl_2.link = var_58_5
		end

		if #arg_58_2 > 0 then
			tbl_2.emojis = table.clone(arg_58_2)
		end

		var_58_15[#var_58_15 + 1] = tbl_2
		content_2.text_start_offset = #var_58_15
	elseif send_chat_message == "clear_chat" then
		local content_3 = self._widgets.chat_output_widget.content
		local private_messages_table_3 = content_3.private_messages_table
		local var_58_19 = private_messages_table_3[private_user_name]

		var_58_19 = var_58_19 or {}
		private_messages_table_3[private_user_name] = var_58_19

		local var_58_20 = private_messages_table_3[private_user_name]

		table.clear(var_58_20)

		content_3.text_start_offset = #var_58_20
	end

	arg_58_1.chat_text.text = ""
	arg_58_1.caret_index = 1
	self._recent_message_index = nil
end

ChatView.set_active = function (self, arg_59_1)
	-- function 59
	self._active = arg_59_1

	if not self._active then
		self._input_manager:block_device_except_service("chat_view", "keyboard", 1, "irc_chat")
		self._input_manager:block_device_except_service("chat_view", "mouse", 1, "irc_chat")
		self._input_manager:block_device_except_service("chat_view", "gamepad", 1, "irc_chat")
		ShowCursorStack.show("ChatView")
	else
		ShowCursorStack.hide("ChatView")
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

ChatView.suspend = function (self)
	-- function 60
	self._suspended = true

	self._input_manager:device_unblock_all_services("keyboard", 1)
	self._input_manager:device_unblock_all_services("mouse", 1)
	self._input_manager:device_unblock_all_services("gamepad", 1)
end

ChatView.unsuspend = function (self)
	-- function 61
	self._input_manager:block_device_except_service("chat_view", "keyboard", 1, "irc_chat")
	self._input_manager:block_device_except_service("chat_view", "mouse", 1, "irc_chat")
	self._input_manager:block_device_except_service("chat_view", "gamepad", 1, "irc_chat")

	self._suspended = nil
end

ChatView._update_animations = function (self, arg_62_1, arg_62_2)
	-- function 62
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_62_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end
end

ChatView._draw = function (self, arg_63_1, arg_63_2)
	-- function 63
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("chat_view")
	local get_service_2 = self._input_manager:get_service("channels_list")
	local _render_settings = self._render_settings
	local is_connected = Managers.twitch:is_connected()
	local is_connecting = Managers.twitch:is_connecting()

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_63_1, nil, _render_settings)

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	for k_2, v_2 in pairs(self._channel_list_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_2)
	end

	for k_3, v_3 in pairs(self._private_list_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_3)
	end

	for k_4, v_4 in pairs(self._recent_channels_list_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_4)
	end

	for k_5, v_5 in pairs(self._popular_channel_list_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_5)
	end

	for k_6, v_6 in pairs(self._commands_list_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_6)
	end

	for k_7, v_7 in pairs(self._filtered_user_names_list_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_7)
	end

	for k_8, v_8 in pairs(self._channel_tabs) do
		UIRenderer.draw_widget(_ui_renderer, v_8)
	end

	local _user_entry_widgets = self._user_entry_widgets

	if not _user_entry_widgets then
		for i, v_9 in ipairs(_user_entry_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v_9)
		end
	end

	UIRenderer.end_pass(_ui_renderer)

	if not table.is_empty(self._channels_list_widgets) then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service_2, arg_63_1, nil, _render_settings)
		self:_handle_and_draw_channels_list(_ui_renderer, _ui_scenegraph, arg_63_1, arg_63_2)
		UIRenderer.end_pass(_ui_renderer)
	elseif not table.is_empty(self._create_channel_widgets) then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service_2, arg_63_1, nil, _render_settings)

		for k_9, v_10 in pairs(self._create_channel_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v_10)
		end

		UIRenderer.end_pass(_ui_renderer)
	elseif not table.is_empty(self._recent_channels_widgets) then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service_2, arg_63_1, nil, _render_settings)

		for k_10, v_11 in pairs(self._recent_channels_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v_11)
		end

		UIRenderer.end_pass(_ui_renderer)
	elseif not table.is_empty(self._invite_widgets) then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service_2, arg_63_1, nil, _render_settings)

		for k_11, v_12 in pairs(self._invite_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v_12)
		end

		UIRenderer.end_pass(_ui_renderer)
	end
end

ChatView._update_channel_tabs = function (self, arg_64_1, arg_64_2)
	-- function 64
	for i, v in ipairs(self._channel_tabs) do
		local content = v.content

		if not content.tab_hotspot.on_release then
			local channel_name = content.channel_name

			self:_change_channel(channel_name)
		end
	end
end

ChatView.on_exit = function (self)
	-- function 65
	self:set_active(false)
end

ChatView.destroy = function (arg_66_0)
	-- function 66
	return
end

ChatView._exit = function (self, arg_67_1)
	-- function 67
	local flag

	flag = not arg_67_1 and "exit_menu" and "ingame_menu"

	self._ingame_ui:handle_transition(flag)
end

ChatView.input_service = function (self)
	-- function 68
	return self._input_manager:get_service("chat_view")
end

ChatView._is_widget_pressed = function (arg_69_0, arg_69_1)
	-- function 69
	return arg_69_1.content.button_hotspot.on_pressed
end

ChatView._set_text_field_active = function (arg_70_0, arg_70_1)
	-- function 70
	arg_70_0._widgets.frame_widget.content.text_field_active = arg_70_1
end

ChatView._handle_user_pressed = function (self)
	-- function 71
	local _user_entry_widgets = self._user_entry_widgets

	for i, v in ipairs(_user_entry_widgets) do
		local content = v.content
		local button_hotspot = content.button_hotspot

		if not button_hotspot.on_double_click then
			local gsub = string.gsub(content.user_name, "@", "")

			self:_change_to_private(gsub)
			self:_set_text_field_active(true)
		elseif not button_hotspot.on_right_click then
			print("on right click", content.user_name)
		end
	end
end

ChatView._populate_user_widgets = function (self, arg_72_1, arg_72_2)
	-- function 72
	local _user_entry_widgets = self._user_entry_widgets
	local var_72_1 = arg_72_2

	for i, v in ipairs(_user_entry_widgets) do
		local content = v.content
		local style = v.style
		local var_72_4 = arg_72_1[var_72_1]

		if not var_72_4 then
			content.user_name = var_72_4.name
			content.title_text = string.sub(var_72_4.name, 1, -11)

			local level = var_72_4.level

			level = level or tostring(math.random(1, 100) + math.random(0, 100))
			content.level_text = level

			local info = var_72_4.info

			info = info or "abc..."
			content.description_text = info

			local var_72_7 = tbl_2[var_72_4.icon_id]

			var_72_7 = var_72_7 or "icons_placeholder"
			content.icon = var_72_7
		end

		content.visible = var_72_4 ~= nil
		var_72_1 = var_72_1 + 1
	end
end

for k, v in pairs(ItemMasterList) do
	if v.item_type == "hat" then
		tbl_2[#tbl_2 + 1] = v.inventory_icon
	end
end

ChatView._update_members = function (self, arg_73_1)
	-- function 73
	arg_73_1 = arg_73_1 or self._user_list_read_index or 1

	local _current_channel_name = self._current_channel_name

	_current_channel_name = _current_channel_name or Managers.irc:home_channel()
	self._current_channel_name = _current_channel_name

	local user_name = Managers.irc:user_name()
	local tbl = {}
	local tbl_2 = {}
	local get_channel_members = Managers.irc:get_channel_members(self._current_channel_name)
	local num = 1

	for k, v in pairs(get_channel_members) do
		tbl[num] = v
		tbl_2[num] = v.name
		num = num + 1
	end

	self:_populate_user_widgets(tbl, arg_73_1)

	self._user_list = tbl
	self._user_names = tbl_2
	self._user_list_read_index = arg_73_1
end
