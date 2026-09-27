-- chunkname: @scripts/ui/views/chat_gui.lua

require("scripts/utils/keystroke_helper")

local var_0_0 = local_require("scripts/ui/views/chat_gui_definitions")

ChatGui = class(ChatGui)

ChatGui.init = function (self, arg_1_1)
	-- function 1
	self.input_manager = arg_1_1.input_manager
	self.ui_renderer = arg_1_1.ui_top_renderer
	self.chat_manager = arg_1_1.chat_manager
	self._render_settings = {
		alpha_multiplier = 1
	}
	self._keystrokes = {}
	self.chat_message = ""
	self.chat_index = 1
	self.chat_mode = "insert"
	self.chat_messages = {}

	rawset(_G, "global_chat_gui", self)

	self.ui_animations = {}

	self:create_ui_elements()

	self.block_chat_activation_hack = 0
	self.menu_active = false
	self.chat_closed = true
	self.chat_focused = false
	self.chat_close_time = 0

	local var_1_0

	if not LEVEL_EDITOR_TEST then
		var_1_0 = DefaultUserSettings.get("user_settings", "chat_font_size")
	else
		var_1_0 = Application.user_setting("chat_font_size")
	end

	self:set_font_size(var_1_0)
	self:_set_chat_window_alpha(0)
end

ChatGui.set_profile_synchronizer = function (self, arg_2_1)
	-- function 2
	self.profile_synchronizer = arg_2_1
end

ChatGui.set_wwise_world = function (self, arg_3_1)
	-- function 3
	self.wwise_world = arg_3_1
end

ChatGui.set_input_manager = function (self, arg_4_1)
	-- function 4
	if not arg_4_1 then
		local tbl = {
			keybind = true,
			irc_chat = true,
			debug_screen = true,
			popup = true,
			twitch = true,
			free_flight = true
		}

		arg_4_1:create_input_service("chat_input", "ChatControllerSettings", "ChatControllerFilters", tbl)
		arg_4_1:map_device_to_service("chat_input", "keyboard")
		arg_4_1:map_device_to_service("chat_input", "mouse")
	end

	self.input_manager = arg_4_1
end

local flag = true

ChatGui.create_ui_elements = function (self)
	-- function 5
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.chat_window_widget = UIWidget.init(var_0_0.chat_window_widget)
	self.chat_output_widget = UIWidget.init(var_0_0.chat_output_widget)
	self.chat_input_widget = UIWidget.init(var_0_0.chat_input_widget)
	self.scrollbar_widget = UIWidget.init(var_0_0.chat_scrollbar_widget)
	self.tab_widget = UIWidget.init(var_0_0.chat_tab_widget)
	self._widgets = {}

	for k, v in pairs(var_0_0.widgets) do
		self._widgets[k] = UIWidget.init(v)
	end

	self.ui_animations.caret_pulse = self:animate_element_pulse(self.chat_input_widget.style.text.caret_color, 1, 60, 255, 2)

	if not flag then
		local var_5_0

		if not LEVEL_EDITOR_TEST then
			var_5_0 = DefaultUserSettings.get("user_settings", "chat_font_size")
		else
			var_5_0 = Application.user_setting("chat_font_size")
		end

		self:set_font_size(var_5_0)
		self:set_menu_transition_fraction(0)
	end

	flag = false
end

ChatGui.clear_messages = function (self)
	-- function 6
	self.chat_output_widget = UIWidget.init(var_0_0.chat_output_widget)
end

ChatGui.animate_element_pulse = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5))
end

ChatGui.animate_element_by_time = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	return (UIAnimation.init(UIAnimation.function_by_time, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, math.ease_out_quad))
end

ChatGui.destroy = function (self)
	-- function 9
	rawset(_G, "global_chat_gui", nil)

	if not self.chat_focused then
		self:unblock_input()

		self.chat_focused = false
	end
end

ChatGui.ignoring_peer_id = function (self, arg_10_1)
	-- function 10
	return self.chat_manager:ignoring_peer_id(arg_10_1)
end

ChatGui.ignore_peer_id = function (self, arg_11_1)
	-- function 11
	self.chat_manager:ignore_peer_id(arg_11_1)
end

ChatGui.remove_ignore_peer_id = function (self, arg_12_1)
	-- function 12
	self.chat_manager:remove_ignore_peer_id(arg_12_1)
end

ChatGui.set_font_size = function (self, arg_13_1)
	-- function 13
	local ui_scenegraph = self.ui_scenegraph
	local scenegraph_definition = var_0_0.scenegraph_definition
	local num = 0
	local num_2 = arg_13_1 + 20

	ui_scenegraph.chat_input_text.size[2] = num_2
	ui_scenegraph.chat_input_box.size[2] = num_2
	self.chat_output_widget.style.text.font_size = arg_13_1
	self.chat_input_widget.style.text.font_size = arg_13_1
	self.chat_input_widget.style.channel_text.font_size = arg_13_1

	local var_13_4, var_13_5 = UIFontByResolution(self.chat_input_widget.style.text)
	local font_type = self.chat_input_widget.style.text.font_type
	local var_13_7, var_13_8, var_13_9 = UIGetFontHeight(self.ui_renderer.gui, font_type, var_13_5)
	local num_3 = num_2 / 2 + math.abs(var_13_8 / 2) - var_13_7 / 2

	self.chat_input_widget.style.text.offset[2] = num_3
	self.chat_input_widget.style.text.caret_size[2] = var_13_7
	ui_scenegraph[self.chat_output_widget.style.text.scenegraph_id].size[2] = var_0_0.CHAT_HEIGHT - arg_13_1 - num
	ui_scenegraph[self.chat_output_widget.style.text.scenegraph_id].position[2] = num * 0.5
end

local tbl = {
	registry_key = "chat_gui",
	drag_scenegraph_id = "root_dragger",
	root_scenegraph_id = "root",
	label = "Chat",
	use_plain_rects = true
}

ChatGui.update = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	if not flag then
		self:create_ui_elements()
	end

	HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl)
	self:update_transition(arg_14_1)

	local _update_chat_messages = self:_update_chat_messages()
	local ui_scenegraph = self.ui_scenegraph
	local ui_animations = self.ui_animations

	if self.menu_active or not arg_14_2 then
		if not self.chat_focused then
			self.chat_focused = true
			self.chat_closed = false

			self:clear_current_transition()
			self:set_menu_transition_fraction(1)
			self:_set_chat_window_alpha(1)

			self.tab_widget.style.button_notification.color[1] = UISettings.chat.tab_notification_alpha_2
		else
			self.chat_closed = true
			self.chat_focused = false
			self.chat_close_time = 0

			self:clear_current_transition()
			self:set_menu_transition_fraction(0)
			self:_set_chat_window_alpha(1)

			self.tab_widget.style.button_notification.color[1] = UISettings.chat.tab_notification_alpha_1
		end
	elseif not (not self.menu_active and arg_14_2) then
		if not self.chat_focused then
			self.chat_focused = true
			self.chat_closed = false

			self:clear_current_transition()
			self:_set_chat_window_alpha(1)
			self:set_menu_transition_fraction(1)

			ui_animations.notification_pulse = nil
		else
			self.chat_closed = true
			self.chat_focused = false
			self.chat_close_time = 0

			self:clear_current_transition()
			self:_set_chat_window_alpha(0)

			ui_animations.notification_pulse = nil
		end
	end

	self.menu_active = arg_14_2

	local get_service = self.input_manager:get_service("chat_input")
	local _update_input, var_14_5, var_14_6 = self:_update_input(get_service, arg_14_3, arg_14_1, arg_14_4, arg_14_5)

	if not (not _update_chat_messages and arg_14_2) then
		var_14_5 = false

		if not (_update_input or self.keep_chat_visible) then
			var_14_6 = UISettings.chat.chat_close_delay
		end
	end

	if not (not var_14_6 and not (var_14_6 > 0)) then
		var_14_6 = var_14_6 - arg_14_1

		if var_14_6 < 0 then
			var_14_6 = 0
		end
	end

	if not arg_14_2 then
		if not (not self.chat_closed and var_14_5) then
			self:menu_open()
		elseif self.chat_closed or not var_14_5 then
			self:menu_close()
		end

		if not var_14_5 and not _update_chat_messages then
			if not self.wwise_world then
				WwiseWorld.trigger_event(self.wwise_world, "hud_chat_message")
			end

			if not ui_animations.notification_pulse then
				local chat = UISettings.chat
				local tab_notification_alpha_1 = chat.tab_notification_alpha_1
				local tab_notification_alpha_2 = chat.tab_notification_alpha_2

				ui_animations.notification_pulse = self:animate_element_pulse(self.tab_widget.style.button_notification.color, 1, tab_notification_alpha_1, tab_notification_alpha_2, 5)
			end
		end
	elseif not ((_update_chat_messages or self.chat_focused or not _update_input or not self.chat_closed) and var_14_5) then
		self:clear_current_transition()
		self:set_menu_transition_fraction(1)
		self:_set_chat_window_alpha(1)
	end

	if self.chat_focused ~= _update_input then
		if not _update_input then
			self:block_input()
		else
			self:unblock_input()
		end
	end

	self.chat_focused = _update_input
	self.chat_closed = var_14_5
	self.chat_close_time = var_14_6

	local flag_2 = arg_14_3 or get_service

	if not self.chat_focused then
		flag_2 = get_service
	end

	self:_update_hud_scale()
	self:_draw_widgets(arg_14_1, flag_2, arg_14_5)
end

ChatGui._update_chat_messages = function (self)
	-- function 15
	if not Managers.chat:gui_should_clear() then
		self:clear_messages()
	end

	local alloc_table = FrameTable.alloc_table()

	self.chat_manager:get_chat_messages(alloc_table)

	local num = 30
	local count = #alloc_table
	local flag = false

	if count > 0 then
		local message_tables = self.chat_output_widget.content.message_tables
		local count_2 = #message_tables

		if num < count + count_2 then
			local num_2 = count + count_2 - num

			for i = 1, num_2 do
				table.remove(message_tables, 1)
			end
		end

		local count_3 = #message_tables

		for j = 1, count do
			local var_15_8 = alloc_table[j]
			local tbl = {}

			if not (var_15_8.type == Irc.PARTY_MSG or var_15_8.type == Irc.ALL_MSG or var_15_8.type == Irc.TEAM_MSG) then
				local message = var_15_8.message

				if not var_15_8.is_system_message then
					tbl.is_system = true
					tbl.sender = var_15_8.message_sender .. ": "
				else
					if var_15_8.type ~= Irc.CHANNEL_MSG or not var_15_8.data then
						tbl.sender = "[" .. var_15_8.data.parameter .. "] " .. var_15_8.message_sender .. ": "
						tbl.trimmed_sender = "[" .. var_15_8.data.parameter .. "] " .. string.sub(var_15_8.message_sender, 1, -11) .. ": "
					elseif var_15_8.type == Irc.PRIVATE_MSG then
						tbl.sender = var_15_8.message_sender .. ": "
						tbl.trimmed_sender = string.sub(var_15_8.message_sender, 1, -11) .. ": "
					else
						tbl.sender = var_15_8.message_sender .. ": "
					end

					tbl.is_system = false
				end

				tbl.is_dev = var_15_8.is_dev
				tbl.is_enemy = var_15_8.is_enemy
				tbl.is_bot = var_15_8.is_bot
				tbl.message = message
				tbl.type = var_15_8.type

				if not var_15_8.link then
					tbl.link = var_15_8.link
				end

				flag = var_15_8.pop_chat
			else
				local message_sender = var_15_8.message_sender
				local player = Managers.player:player(message_sender, var_15_8.local_player_id)
				local var_15_13
				local var_15_14

				if not player then
					local profile_by_peer = self.profile_synchronizer:profile_by_peer(player.peer_id, player:local_player_id())

					var_15_13 = not SPProfiles[profile_by_peer] and SPProfiles[profile_by_peer].ingame_short_display_name and nil
					var_15_14 = player:name()
				else
					var_15_14 = not rawget(_G, "Steam") and Steam.user_name(message_sender) and tostring(message_sender)
				end

				local message_2 = var_15_8.message

				tbl.is_dev = var_15_8.is_dev
				tbl.is_enemy = var_15_8.is_enemy
				tbl.is_bot = var_15_8.is_bot
				tbl.is_system = false

				local format

				if not var_15_13 then
					format = string.format("%s (%s): ", var_15_14, Localize(var_15_13))

					if not format then
						-- Nothing
					end
				end

				format = string.format("%s: ", var_15_14)

				::label_15_0::

				tbl.sender = format
				tbl.message = message_2
				tbl.type = var_15_8.type

				local message_targets = self.chat_manager.message_targets

				for i_2, v in ipairs(message_targets) do
					if v.message_target_type == var_15_8.type then
						if not v.message_target_key then
							tbl.channel_string = string.format("[%s] ", Localize(v.message_target_key))
						end

						break
					end
				end

				flag = true
			end

			message_tables[count_3 + j] = tbl
		end
	end

	return flag
end

ChatGui.show_chat = function (self)
	-- function 16
	self:clear_current_transition()
	self:set_menu_transition_fraction(1)
	self:_set_chat_window_alpha(1)

	self.chat_closed = false
	self.chat_focused = false
	self.chat_close_time = nil
	self.keep_chat_visible = true
	self.scrollbar_widget.content.internal_scroll_value = 0
end

ChatGui.hide_chat = function (self)
	-- function 17
	self:clear_current_transition()
	self:set_menu_transition_fraction(0)
	self:_set_chat_window_alpha(0)

	self.chat_closed = true
	self.chat_focused = false
	self.chat_close_time = nil
	self.keep_chat_visible = false
end

ChatGui.menu_open = function (self)
	-- function 18
	self:clear_current_transition()

	local chat = UISettings.chat

	self.ui_animations.notification_pulse = nil
	self.tab_widget.style.button_notification.color[1] = chat.tab_notification_alpha_1
	self.opening = true
	self.transition_timer = 0
end

ChatGui.menu_close = function (self)
	-- function 19
	self:clear_current_transition()

	self.closing = true
	self.transition_timer = 0
end

ChatGui.set_menu_transition_fraction = function (self, arg_20_1)
	-- function 20
	local ui_scenegraph = self.ui_scenegraph
	local scenegraph_definition = var_0_0.scenegraph_definition
	local scenegraph_id = self.chat_window_widget.scenegraph_id
	local var_20_3 = scenegraph_definition[scenegraph_id]

	ui_scenegraph[scenegraph_id].size[1] = var_20_3.size[1] * arg_20_1
end

ChatGui.update_transition = function (self, arg_21_1)
	-- function 21
	local transition_timer = self.transition_timer

	if not transition_timer then
		return
	end

	local num = 0.2
	local min = math.min(transition_timer + arg_21_1, num)
	local num_2 = min / num

	if not self.opening then
		self:set_menu_transition_fraction(num_2)
	elseif not self.closing then
		self:set_menu_transition_fraction(1 - num_2)
	end

	if num_2 == 1 then
		self.transition_timer = nil

		if not self.opening then
			self.opening = nil
		elseif not self.closing then
			self.closing = nil
		end
	else
		self.transition_timer = min
	end
end

ChatGui.clear_current_transition = function (self)
	-- function 22
	self.opening = nil
	self.closing = nil
	self.transition_timer = nil
end

ChatGui.block_input = function (self)
	-- function 23
	self.input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "chat_input", "ChatGui")
	self:_show_cursor()
	Window.set_ime_enabled(true)
end

ChatGui.unblock_input = function (self)
	-- function 24
	Window.set_ime_enabled(false)

	if not self.input_manager then
		self.input_manager:release_input({
			"keyboard",
			"gamepad",
			"mouse"
		}, 1, "chat_input", "ChatGui")
	end

	self:_hide_cursor()
end

ChatGui._show_cursor = function (self)
	-- function 25
	if not self._cursor_visible then
		self._cursor_visible = true

		ShowCursorStack.show("ChatGui")
	end
end

ChatGui._hide_cursor = function (self)
	-- function 26
	if not self._cursor_visible then
		self._cursor_visible = false

		ShowCursorStack.hide("ChatGui")
	end
end

ChatGui.block_chat_input_for_one_frame = function (self)
	-- function 27
	self._block_keystrokes = true
end

ChatGui._update_input = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	local chat_focused = self.chat_focused
	local chat_closed = self.chat_closed
	local chat_close_time = self.chat_close_time
	local button_hotspot = self.tab_widget.content.button_hotspot
	local scrollbar_widget = self.scrollbar_widget

	if not arg_28_1:get("unallowed_activate_chat_input") then
		self.block_chat_activation_hack = 0
	else
		self.block_chat_activation_hack = self.block_chat_activation_hack + arg_28_3
	end

	local flag = (self.block_chat_activation_hack < 0.2 or not arg_28_5) and self._block_keystrokes

	self._block_keystrokes = false

	local var_28_6 = chat_closed

	if not chat_closed then
		local get = arg_28_1:get("execute_alt_chat_input")

		if (button_hotspot.on_release or arg_28_1:get("activate_chat_input") or arg_28_1:get("execute_chat_input") or not get or flag) and not GameSettingsDevelopment.allow_chat_input then
			if not arg_28_5 then
				var_28_6 = false
				chat_close_time = nil
				chat_focused = true
			else
				var_28_6 = false
				chat_close_time = UISettings.chat.chat_close_delay
				chat_focused = false
				self._refocus_chat_window = true
			end

			self.chat_message = ""
			self.chat_index = 1
			self.chat_mode = "insert"

			local num = 1
			local var_28_9
			local game_mechanism = Managers.mechanism:game_mechanism()

			if not game_mechanism.get_chat_channel then
				local peer_id = Network.peer_id()

				num, var_28_9 = game_mechanism:get_chat_channel(peer_id, get)
			end

			self.channel_id = num or 1
			self.alt_chat_input = get

			if not var_28_9 then
				Managers.chat:set_message_target_type(var_28_9)
			end

			local current_message_target = Managers.chat:current_message_target()
			local var_28_13

			if not current_message_target.message_target_key then
				var_28_13 = string.format("[%s] ", Localize(current_message_target.message_target_key))
			else
				var_28_13 = string.format("[%s] ", current_message_target.message_target)
			end

			local var_28_14, var_28_15 = UIFontByResolution(self.chat_input_widget.style.channel_text)
			local text_size, var_28_17, var_28_18 = UIRenderer.text_size(self.ui_renderer, var_28_13, var_28_14[1], var_28_15)

			self.chat_input_widget.content.channel_field = var_28_13

			local var_28_19 = IRC_CHANNEL_COLORS[current_message_target.message_target_type]
			local text_color = self.chat_input_widget.style.channel_text.text_color

			self:_apply_color_values(text_color, var_28_19)

			self.ui_scenegraph.chat_input_text.size[1] = var_0_0.CHAT_INPUT_TEXT_WIDTH - text_size
			self.chat_input_widget.style.text.offset[1] = self.chat_input_widget.style.channel_text.offset[1] + text_size
			self.chat_input_widget.content.caret_index = 1
			self.chat_input_widget.content.text_index = 1
		end

		scrollbar_widget.content.internal_scroll_value = 0
	else
		local flag_2 = false

		if not self.menu_active and not arg_28_1:get("left_release") then
			local var_28_22 = UIInverseScaleVectorToResolution(arg_28_1:get("cursor"))
			local get_world_position = UISceneGraph.get_world_position(self.ui_scenegraph, "chat_window_background")
			local get_size = UISceneGraph.get_size(self.ui_scenegraph, "chat_window_background")

			if not math.point_is_inside_2d_box(var_28_22, get_world_position, get_size) then
				flag_2 = true
			end
		end

		local flag_3 = not chat_close_time and chat_close_time == 0 or not arg_28_5

		if button_hotspot.on_release or not arg_28_1:get("deactivate_chat_input") and flag and flag_2 or not flag_3 then
			if not chat_focused and button_hotspot.on_release and not arg_28_1:get("deactivate_chat_input") and flag and not flag_2 then
				table.clear(button_hotspot)
			end

			var_28_6 = true
			chat_close_time = 0
			chat_focused = false
			self.recent_message_index = nil
			self.old_chat_message = nil
		end

		button_hotspot.on_release = false

		if not chat_focused and not arg_28_5 then
			if not GameSettingsDevelopment.allow_chat_input and not arg_28_1:get("execute_chat_input") then
				var_28_6 = false
				chat_focused = false

				if not self.keep_chat_visible then
					chat_close_time = UISettings.chat.chat_close_delay
				end

				if self.chat_message ~= "" then
					local channel_id = self.channel_id

					if not self.chat_manager:has_channel(channel_id) then
						local flag_4 = false
						local flag_5 = false

						self.chat_manager:send_chat_message(channel_id, 1, self.chat_message, flag_4, nil, flag_5, self.recent_message_index)
					end

					self.chat_message = ""
					self.chat_mode = "insert"
					self.chat_index = 1
					self.chat_input_widget.content.caret_index = 1
					self.chat_input_widget.content.text_index = 1
					self.scrollbar_widget.content.internal_scroll_value = 0
				else
					var_28_6 = true
					chat_close_time = 0
					chat_focused = false
				end

				self.old_chat_message = nil
				self.recent_message_index = nil
			elseif not arg_28_1:get("chat_next_old_message") and not GameSettingsDevelopment.allow_chat_input then
				local get_recently_sent_messages = Managers.chat:get_recently_sent_messages()
				local count = #get_recently_sent_messages

				if count > 0 then
					if not self.recent_message_index then
						if not (not (string.len(self.chat_message) > 0) or self.recent_message_index) then
							self.old_chat_message = self.chat_message
						end

						self.recent_message_index = count
					else
						self.recent_message_index = math.max(self.recent_message_index - 1, 1)
					end

					self.chat_message = get_recently_sent_messages[self.recent_message_index]
					self.chat_index = #KeystrokeHelper._build_utf8_table(self.chat_message) + 1
					self.chat_input_widget.content.jump_to_end = true
				end
			elseif not arg_28_1:get("chat_previous_old_message") and not GameSettingsDevelopment.allow_chat_input then
				local get_recently_sent_messages_2 = Managers.chat:get_recently_sent_messages()
				local count_2 = #get_recently_sent_messages_2

				if not self.recent_message_index then
					if not (not (count_2 > 0) or not (count_2 > self.recent_message_index)) then
						self.recent_message_index = math.clamp(self.recent_message_index + 1, 1, count_2)
						self.chat_message = get_recently_sent_messages_2[self.recent_message_index]
						self.chat_index = #KeystrokeHelper._build_utf8_table(self.chat_message) + 1
					elseif self.recent_message_index ~= count_2 or not self.old_chat_message then
						self.chat_message = self.old_chat_message
						self.chat_index = #KeystrokeHelper._build_utf8_table(self.chat_message) + 1
						self.recent_message_index = nil
						self.old_chat_message = nil
					end

					self.chat_input_widget.content.jump_to_end = true
				end
			elseif not GameSettingsDevelopment.use_global_chat and not arg_28_1:get("chat_switch_view") and not GameSettingsDevelopment.allow_chat_input then
				self:clear_messages()
				Managers.chat:switch_view()

				local current_view_and_color, var_28_34 = Managers.chat:current_view_and_color()

				self.chat_input_widget.content.header_field = current_view_and_color

				self:_apply_color_values(self.chat_input_widget.style.header_text.text_color, var_28_34)
			elseif not GameSettingsDevelopment.use_global_chat and not arg_28_1:get("chat_switch_channel") and not GameSettingsDevelopment.allow_chat_input then
				if not Managers.chat:next_message_target() then
					self:clear_messages()
				end

				local current_message_target_2 = Managers.chat:current_message_target()
				local str = "[" .. tostring(current_message_target_2.message_target) .. "]  "
				local var_28_37, var_28_38 = UIFontByResolution(self.chat_input_widget.style.channel_text)
				local text_size_2, var_28_40, var_28_41 = UIRenderer.text_size(self.ui_renderer, str, var_28_37[1], var_28_38)

				self.chat_input_widget.content.channel_field = str

				local var_28_42 = IRC_CHANNEL_COLORS[current_message_target_2.message_target_type]

				self:_apply_color_values(self.chat_input_widget.style.channel_text.text_color, var_28_42)

				self.ui_scenegraph.chat_input_text.size[1] = var_0_0.CHAT_INPUT_TEXT_WIDTH - text_size_2
				self.chat_input_widget.style.text.offset[1] = self.chat_input_widget.style.channel_text.offset[1] + text_size_2
				self.chat_input_widget.content.caret_index = Utf8.length(self.chat_message) + 1
				self.chat_index = self.chat_input_widget.content.caret_index

				local current_view_and_color_2, var_28_44 = Managers.chat:current_view_and_color()

				self.chat_input_widget.content.header_field = current_view_and_color_2

				self:_apply_color_values(self.chat_input_widget.style.header_text.text_color, var_28_44)
			elseif not arg_28_1:get("chat_backspace_word") and not GameSettingsDevelopment.allow_chat_input then
				local _build_utf8_table = KeystrokeHelper._build_utf8_table(self.chat_message)
				local num_2 = self.chat_index - 1
				local flag_6 = false
				local num_3 = 0

				for i = num_2, 1, -1 do
					local var_28_49 = _build_utf8_table[i]

					if _build_utf8_table[i] ~= " " or not flag_6 then
						num_2 = i + 1

						break
					else
						table.remove(_build_utf8_table, i)

						num_2 = i

						if _build_utf8_table[i] ~= " " then
							flag_6 = true
						end
					end
				end

				self.chat_index = math.clamp(num_2, 1, #_build_utf8_table + 1)
				self.chat_message = ""

				local num_4 = 0

				for i_2, v in ipairs(_build_utf8_table) do
					self.chat_message = self.chat_message .. v
					num_4 = num_4 + 1
				end
			elseif not GameSettingsDevelopment.allow_chat_input then
				local _keystrokes = self._keystrokes

				table.clear(_keystrokes)

				local keystrokes = Keyboard.keystrokes(_keystrokes)
				local button_index = Keyboard.button_index("left ctrl")

				if not Keyboard.pressed(button_index) then
					local flag_7

					flag_7 = Keyboard.button(button_index) > 0
				end

				local max_string_length = NetworkConstants.max_string_length
				local parse_strokes, var_28_57, var_28_58 = KeystrokeHelper.parse_strokes(self.chat_message, self.chat_index, self.chat_mode, keystrokes, max_string_length)

				if var_28_57 ~= self.chat_index then
					if var_28_57 == 1 then
						self.chat_input_widget.content.text_index = var_28_57
					elseif var_28_57 > Utf8.length(parse_strokes) then
						self.chat_input_widget.content.jump_to_end = true
					end
				end

				self.chat_message = parse_strokes
				self.chat_index = var_28_57
				self.chat_mode = var_28_58
			end
		else
			local get_2 = arg_28_1:get("execute_alt_chat_input")

			if arg_28_1:get("activate_chat_input") or arg_28_1:get("execute_chat_input") or not get_2 or not GameSettingsDevelopment.allow_chat_input then
				if not arg_28_5 then
					var_28_6 = false
					chat_close_time = nil
					chat_focused = true
				else
					var_28_6 = false
					chat_close_time = UISettings.chat.chat_close_delay
					chat_focused = false
					self._refocus_chat_window = true
				end

				self.chat_message = ""
				self.chat_index = 1
				self.chat_mode = "insert"
				self.recent_message_index = nil
				self.old_chat_message = nil

				local num_5 = 1
				local var_28_61
				local game_mechanism_2 = Managers.mechanism:game_mechanism()

				if not game_mechanism_2.get_chat_channel then
					local peer_id_2 = Network.peer_id()

					num_5, var_28_61 = game_mechanism_2:get_chat_channel(peer_id_2, get_2)
				end

				self.channel_id = num_5 or 1
				self.alt_chat_input = get_2

				if not var_28_61 then
					Managers.chat:set_message_target_type(var_28_61)
				end

				local current_message_target_3 = Managers.chat:current_message_target()

				if not current_message_target_3 then
					local str_2 = "[" .. tostring(current_message_target_3.message_target) .. "]  "
					local var_28_66, var_28_67 = UIFontByResolution(self.chat_input_widget.style.channel_text)
					local text_size_3, var_28_69, var_28_70 = UIRenderer.text_size(self.ui_renderer, str_2, var_28_66[1], var_28_67)

					self.chat_input_widget.content.channel_field = str_2

					local var_28_71 = IRC_CHANNEL_COLORS[current_message_target_3.message_target_type]

					self:_apply_color_values(self.chat_input_widget.style.channel_text.text_color, var_28_71)

					self.ui_scenegraph.chat_input_text.size[1] = var_0_0.CHAT_INPUT_TEXT_WIDTH - text_size_3
					self.chat_input_widget.style.text.offset[1] = self.chat_input_widget.style.channel_text.offset[1] + text_size_3
				end

				self.chat_input_widget.content.caret_index = 1
				self.chat_input_widget.content.text_index = 1
			end
		end

		local content = self.chat_input_widget.content
		local enlarge_hotspot = content.enlarge_hotspot
		local info_hotspot = content.info_hotspot
		local filter_hotspot = content.filter_hotspot
		local target_hotspot = content.target_hotspot

		if not GameSettingsDevelopment.use_global_chat then
			if not enlarge_hotspot.on_release then
				Managers.ui:handle_transition("chat_view_force", {
					use_fade = true
				})

				var_28_6 = true
				chat_close_time = 0
				chat_focused = false
			elseif not (not info_hotspot.on_release and true) then
				var_28_6 = true
				chat_close_time = 0
				chat_focused = false
			elseif not filter_hotspot.on_release then
				self:clear_messages()
				Managers.chat:switch_view()

				local current_view_and_color_3, var_28_78 = Managers.chat:current_view_and_color()

				self.chat_input_widget.content.header_field = current_view_and_color_3

				self:_apply_color_values(self.chat_input_widget.style.header_text.text_color, var_28_78)
			elseif not target_hotspot.on_release then
				if not Managers.chat:next_message_target() then
					self:clear_messages()
				end

				local current_message_target_4 = Managers.chat:current_message_target()
				local str_3 = "[" .. tostring(current_message_target_4.message_target) .. "]  "
				local var_28_81, var_28_82 = UIFontByResolution(self.chat_input_widget.style.channel_text)
				local text_size_4, var_28_84, var_28_85 = UIRenderer.text_size(self.ui_renderer, str_3, var_28_81[1], var_28_82)

				self.chat_input_widget.content.channel_field = str_3

				local var_28_86 = IRC_CHANNEL_COLORS[current_message_target_4.message_target_type]

				self:_apply_color_values(self.chat_input_widget.style.channel_text.text_color, var_28_86)

				self.ui_scenegraph.chat_input_text.size[1] = var_0_0.CHAT_INPUT_TEXT_WIDTH - text_size_4
				self.chat_input_widget.style.text.offset[1] = self.chat_input_widget.style.channel_text.offset[1] + text_size_4
				self.chat_input_widget.content.caret_index = Utf8.length(self.chat_message) + 1
				self.chat_index = self.chat_input_widget.content.caret_index

				local current_view_and_color_4, var_28_88 = Managers.chat:current_view_and_color()

				self.chat_input_widget.content.header_field = current_view_and_color_4

				self:_apply_color_values(self.chat_input_widget.style.header_text.text_color, var_28_88)
			end
		end

		local num_6 = 0.025
		local content_2 = scrollbar_widget.content
		local var_28_91

		if not chat_focused then
			if not arg_28_1:get("chat_scroll_up") then
				var_28_91 = num_6
			elseif not arg_28_1:get("chat_scroll_down") then
				var_28_91 = -num_6
			end

			local str_4 = "chat_scroll"

			if not arg_28_1:has(str_4) then
				local y = arg_28_1:get(str_4).y

				if y ~= 0 then
					var_28_91 = num_6 * y
				end
			end
		end

		if not var_28_91 then
			local ui_scenegraph = self.ui_scenegraph
			local num_7 = ui_scenegraph[scrollbar_widget.scenegraph_id].position[2] + ui_scenegraph.chat_window_root.position[2]
			local scenegraph_id = scrollbar_widget.style.scrollbar.scenegraph_id
			local num_8 = num_7 - content_2.scroll_bar_height / 2
			local get_size_2 = UISceneGraph.get_size(ui_scenegraph, scenegraph_id)
			local clamp = math.clamp(num_8, 0, get_size_2[2])
			local min = math.min(clamp / get_size_2[2], 1)

			content_2.internal_scroll_value = math.clamp(content_2.internal_scroll_value + var_28_91, 0, min)
		end
	end

	return chat_focused, var_28_6, chat_close_time
end

ChatGui._draw_widgets = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local is_device_active = self.input_manager:is_device_active("gamepad")
	local chat_close_time = self.chat_close_time
	local menu_active = self.menu_active

	if not ((menu_active or not chat_close_time) and chat_close_time ~= 0) then
		return
	end

	local _render_settings = self._render_settings
	local ui_scenegraph = self.ui_scenegraph
	local ui_renderer = self.ui_renderer
	local ui_animations = self.ui_animations
	local chat_window_widget = self.chat_window_widget
	local chat_input_widget = self.chat_input_widget
	local chat_output_widget = self.chat_output_widget
	local scrollbar_widget = self.scrollbar_widget
	local tab_widget = self.tab_widget

	chat_input_widget.content.text_field = self.chat_message
	chat_input_widget.content.caret_index = self.chat_index
	chat_output_widget.content.text_start_offset = 1 - scrollbar_widget.content.scroll_value

	local alpha_multiplier = _render_settings.alpha_multiplier

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_29_2, arg_29_1, nil, _render_settings)

	if (is_device_active or not menu_active) and not arg_29_3 then
		UIRenderer.draw_widget(ui_renderer, tab_widget)
	end

	self:_apply_hud_scale()

	if not self.chat_focused then
		UIAnimation.update(ui_animations.caret_pulse, arg_29_1)
	end

	if not menu_active then
		if not ui_animations.window_position then
			UIAnimation.update(ui_animations.window_position, arg_29_1)
		end

		if not ui_animations.notification_pulse then
			UIAnimation.update(ui_animations.notification_pulse, arg_29_1)
		end
	else
		local chat_close_fade_length = UISettings.chat.chat_close_fade_length

		if not (not chat_close_time and not (chat_close_time < chat_close_fade_length)) then
			local num = chat_close_time / chat_close_fade_length

			self:_set_chat_window_alpha(num)
		elseif not self._refocus_chat_window then
			self:_set_chat_window_alpha(1)

			self._refocus_chat_window = nil
		end
	end

	UIRenderer.draw_widget(ui_renderer, chat_window_widget)

	if not (self.chat_closed or self.opening or self.closing) then
		if not self.chat_focused and not arg_29_3 then
			UIRenderer.draw_widget(ui_renderer, chat_input_widget)
		end

		local _output_text_alpha_multiplier = self._output_text_alpha_multiplier

		_output_text_alpha_multiplier = _output_text_alpha_multiplier or alpha_multiplier
		_render_settings.alpha_multiplier = _output_text_alpha_multiplier

		UIRenderer.draw_widget(ui_renderer, chat_output_widget)

		_render_settings.alpha_multiplier = alpha_multiplier

		UIRenderer.draw_widget(ui_renderer, scrollbar_widget)

		if not chat_output_widget.content.link_pressed then
			local link_pressed = chat_output_widget.content.link_pressed

			Managers.invite:set_invited_lobby_data(link_pressed.lobby_id)

			chat_output_widget.content.link_pressed = nil

			print("Link Pressed! -> joining game!")
		end

		if not arg_29_3 then
			for k, v in pairs(self._widgets) do
				UIRenderer.draw_widget(ui_renderer, v)
			end
		end
	end

	self:_abort_hud_scale()
	UIRenderer.end_pass(ui_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier
end

ChatGui._update_hud_scale = function (self)
	-- function 30
	if not self._resolution_modified then
		self._resolution_modified = RESOLUTION_LOOKUP.modified
	end

	if not self._scale_modified then
		local num = UISettings.hud_scale * 0.01

		self._scale_modified = self._hud_scale_multiplier ~= num
		self._hud_scale_multiplier = num
	end
end

ChatGui._apply_hud_scale = function (self)
	-- function 31
	self:_update_hud_scale()

	local _scale_modified = self._scale_modified
	local _resolution_modified = self._resolution_modified
	local flag = _scale_modified or _resolution_modified
	local _hud_scale_multiplier = self._hud_scale_multiplier

	UPDATE_RESOLUTION_LOOKUP(flag, _hud_scale_multiplier)
end

ChatGui._abort_hud_scale = function (self)
	-- function 32
	local _scale_modified = self._scale_modified
	local _resolution_modified = self._resolution_modified
	local flag = _scale_modified or _resolution_modified

	UPDATE_RESOLUTION_LOOKUP(flag)
end

ChatGui._set_chat_window_alpha = function (self, arg_33_1)
	-- function 33
	local chat = UISettings.chat
	local chat_window_widget = self.chat_window_widget
	local chat_input_widget = self.chat_input_widget
	local chat_output_widget = self.chat_output_widget
	local scrollbar_widget = self.scrollbar_widget

	chat_window_widget.style.background.color[1] = chat.window_background_alpha * arg_33_1

	local style = chat_input_widget.style

	style.background.color[1] = chat.input_background_alpha * arg_33_1
	style.text.text_color[1] = chat.input_text_alpha * arg_33_1
	style.text.caret_color[1] = chat.input_caret_alpha * arg_33_1
	chat_output_widget.style.background.color[1] = chat.output_background_alpha * arg_33_1

	local style_2 = scrollbar_widget.style

	style_2.background.color[1] = chat.scrollbar_background_alpha * arg_33_1

	local num = chat.scrollbar_background_stroke_alpha * arg_33_1

	style_2.background_stroke_top.color[1] = num
	style_2.background_stroke_bottom.color[1] = num
	style_2.background_stroke_left.color[1] = num
	style_2.background_stroke_right.color[1] = num
	style_2.scrollbar.color[1] = chat.scrollbar_alpha * arg_33_1

	local num_2 = chat.scrollbar_stroke_alpha * arg_33_1

	style_2.scrollbar_stroke_top.color[1] = num_2
	style_2.scrollbar_stroke_bottom.color[1] = num_2
	self._output_text_alpha_multiplier = arg_33_1
end

ChatGui._apply_color_values = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	arg_34_1[2] = arg_34_2[2]
	arg_34_1[3] = arg_34_2[3]
	arg_34_1[4] = arg_34_2[4]
end
