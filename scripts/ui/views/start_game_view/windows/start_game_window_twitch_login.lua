-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_twitch_login.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_login_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition

StartGameWindowTwitchLogin = class(StartGameWindowTwitchLogin)
StartGameWindowTwitchLogin.NAME = "StartGameWindowTwitchLogin"

StartGameWindowTwitchLogin.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowTwitchLogin")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id

	self:create_ui_elements(arg_1_1, arg_1_2)
	self:set_active(true)
	self:_set_disconnect_button_text()
end

StartGameWindowTwitchLogin.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_2
		tbl_2[k] = var_2_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	if not arg_2_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

StartGameWindowTwitchLogin.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowTwitchLogin")
	self:set_active(false)
end

StartGameWindowTwitchLogin.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_popup()
	self:_update_animations(arg_4_1)
	self:_handle_input(arg_4_1, arg_4_2)
	self:_update_game_options(arg_4_1, arg_4_2)
	self:draw(arg_4_1)
end

StartGameWindowTwitchLogin.set_active = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._active = arg_5_1

	if not IS_WINDOWS then
		if not arg_5_1 then
			Managers.irc:register_message_callback("twitch", Irc.CHANNEL_MSG, callback(self, "cb_on_message_received"))
		else
			Managers.irc:unregister_message_callback("twitch")
		end
	end
end

StartGameWindowTwitchLogin._update_popup = function (self)
	-- function 6
	if not self._error_popup_id then
		local query_result = Managers.popup:query_result(self._error_popup_id)

		if query_result == "ok" then
			self._error_popup_id = nil
		elseif not query_result then
			fassert(false, "[StateTitleScreenMainMenu] The popup result doesn't exist (%s)", query_result)
		end
	end
end

StartGameWindowTwitchLogin._handle_input = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not Managers.twitch:is_connecting() then
		local is_connected = Managers.twitch:is_connected()
		local frame_widget = self._widgets_by_name.frame_widget

		if not IS_WINDOWS then
			local content = frame_widget.content
			local text_input_hotspot = content.text_input_hotspot
			local screen_hotspot = content.screen_hotspot
			local frame_hotspot = content.frame_hotspot

			if not (not text_input_hotspot.on_pressed and is_connected) then
				self.parent.parent:set_input_blocked(true)

				content.text_field_active = true
			elseif screen_hotspot.on_pressed or not is_connected then
				if not (not screen_hotspot.on_pressed and content.text_field_active or frame_hotspot.on_pressed) then
					self:set_active(false)

					content.text_field_active = false

					self.parent.parent:set_input_blocked(false)

					return
				end

				content.text_field_active = false

				self.parent.parent:set_input_blocked(false)
			end

			if not content.text_field_active then
				Managers.chat:block_chat_input_for_one_frame()

				local keystrokes = Keyboard.keystrokes()

				content.twitch_name, content.caret_index = KeystrokeHelper.parse_strokes(content.twitch_name, content.caret_index, "insert", keystrokes, 32)

				if not self.parent:window_input_service():get("execute_chat_input", true) then
					content.text_field_active = false

					local gsub = string.gsub(content.twitch_name, " ", "")

					Managers.twitch:connect(gsub, callback(Managers.twitch, "cb_connection_error_callback"), callback(self, "cb_connection_success_callback"))
				end
			end
		end

		if not is_connected then
			local button_1 = self._widgets_by_name.button_1

			if not self:_is_button_hover_enter(button_1) then
				self:_play_sound("Play_hud_hover")
			end

			if not self:_is_button_pressed(button_1) then
				local str = ""

				if not frame_widget then
					local content_2 = frame_widget.content

					str = string.gsub(content_2.twitch_name, " ", "")
				end

				Managers.twitch:connect(str, callback(Managers.twitch, "cb_connection_error_callback"), callback(self, "cb_connection_success_callback"))
				self:_play_sound("Play_hud_select")
			end
		else
			local button_2 = self._widgets_by_name.button_2

			if not self:_is_button_hover_enter(button_2) then
				self:_play_sound("Play_hud_hover")
			end

			if not self:_is_button_pressed(button_2) then
				self:_play_sound("Play_hud_select")
				Managers.twitch:disconnect()

				local content_3 = self._widgets_by_name.chat_output_widget.content

				content_3.message_tables = {}
				content_3.text_start_offset = 0
			end
		end
	end
end

StartGameWindowTwitchLogin._update_game_options = function (self, arg_8_1, arg_8_2)
	-- function 8
	local is_connected = Managers.twitch:is_connected()
	local is_connecting = Managers.twitch:is_connecting()

	if is_connecting or not is_connected then
		self.parent:enable_widget(1, "game_option_1", false)
		self.parent:enable_widget(1, "game_option_2", false)
		self.parent:enable_widget(1, "game_option_3", false)
		self.parent:enable_widget(1, "game_option_5", false)
	elseif not (is_connecting or is_connected) then
		self.parent:enable_widget(1, "game_option_1", true)
		self.parent:enable_widget(1, "game_option_2", true)
		self.parent:enable_widget(1, "game_option_3", true)
		self.parent:enable_widget(1, "game_option_5", true)
	end
end

StartGameWindowTwitchLogin.cb_connection_success_callback = function (self, arg_9_1)
	-- function 9
	self:_set_disconnect_button_text()
end

StartGameWindowTwitchLogin._set_disconnect_button_text = function (arg_10_0)
	-- function 10
	local user_name

	if not Managers.twitch then
		user_name = Managers.twitch:user_name()

		if not user_name then
			-- Nothing
		end
	end

	user_name = "N/A"

	::label_10_0::

	arg_10_0._widgets_by_name.button_2.content.button_hotspot.text = string.format(Localize("start_game_window_twitch_disconnect"), user_name)
end

StartGameWindowTwitchLogin.cb_on_message_received = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local content = self._widgets_by_name.chat_output_widget.content
	local message_tables = content.message_tables
	local tbl = {}

	tbl.is_dev = false
	tbl.is_system = false
	tbl.sender = string.format("%s: ", arg_11_3)
	tbl.message = arg_11_4
	message_tables[#message_tables + 1] = tbl

	if #message_tables > 20 then
		table.remove(message_tables, 1)
	else
		content.text_start_offset = content.text_start_offset + 1
	end
end

StartGameWindowTwitchLogin._is_button_pressed = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowTwitchLogin._is_button_hover_enter = function (arg_13_0, arg_13_1)
	-- function 13
	return arg_13_1.content.button_hotspot.on_hover_enter
end

StartGameWindowTwitchLogin.post_update = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	return
end

StartGameWindowTwitchLogin._update_animations = function (self, arg_15_1)
	-- function 15
	self:_update_button_animations(arg_15_1)
end

StartGameWindowTwitchLogin._update_button_animations = function (self, arg_16_1)
	-- function 16
	local _widgets_by_name = self._widgets_by_name
	local str = "button_"

	for i = 1, 2 do
		local var_16_2 = _widgets_by_name[str .. i]

		self:_animate_button(var_16_2, arg_16_1)
	end
end

StartGameWindowTwitchLogin._animate_button = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local button_hotspot = arg_17_1.content.button_hotspot
	local num = 20
	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local is_clicked = button_hotspot.is_clicked

	is_clicked = not is_clicked and button_hotspot.is_clicked == 0

	if not is_clicked then
		input_progress = math.min(input_progress + arg_17_2 * num, 1)
	else
		input_progress = math.max(input_progress - arg_17_2 * num, 0)
	end

	local num_2 = 8
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	if not (not not button_hotspot.disable_button or button_hotspot.is_hover) then
		hover_progress = math.min(hover_progress + arg_17_2 * num_2, 1)
	else
		hover_progress = math.max(hover_progress - arg_17_2 * num_2, 0)
	end

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	if not (not not button_hotspot.disable_button or button_hotspot.is_selected) then
		selection_progress = math.min(selection_progress + arg_17_2 * num_2, 1)
	else
		selection_progress = math.max(selection_progress - arg_17_2 * num_2, 0)
	end

	local max = math.max(hover_progress, selection_progress)
	local style = arg_17_1.style

	style.clicked_rect.color[1] = 100 * input_progress

	local str = "hover_glow"
	local num_3 = 255 * max

	style[str].color[1] = num_3

	local text = style.text
	local text_color = text.text_color
	local default_text_color = text.default_text_color
	local select_text_color = text.select_text_color

	Colors.lerp_color_tables(default_text_color, select_text_color, max, text_color)

	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

StartGameWindowTwitchLogin.draw = function (self, arg_18_1)
	-- function 18
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_18_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_18_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_18_4)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowTwitchLogin._play_sound = function (self, arg_19_1)
	-- function 19
	self.parent:play_sound(arg_19_1)
end
