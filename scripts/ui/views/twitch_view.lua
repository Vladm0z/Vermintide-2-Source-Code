-- chunkname: @scripts/ui/views/twitch_view.lua

require("scripts/utils/keystroke_helper")

local var_0_0 = local_require("scripts/ui/views/twitch_view_definitions")

TwitchView = class(TwitchView)

TwitchView.init = function (self, arg_1_1)
	-- function 1
	self._ui_renderer = arg_1_1.ui_renderer
	self._ingame_ui = arg_1_1.ingame_ui
	self._network_lobby = arg_1_1.network_lobby
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._network_server = arg_1_1.network_server

	local input_manager = arg_1_1.input_manager

	input_manager:create_input_service("twitch_view", "TwitchControllerSettings", "TwitchControllerFilters")
	input_manager:map_device_to_service("twitch_view", "keyboard")
	input_manager:map_device_to_service("twitch_view", "mouse")
	input_manager:map_device_to_service("twitch_view", "gamepad")

	self._input_manager = input_manager

	local world = arg_1_1.world_manager:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)

	self:_create_ui_elements()
end

TwitchView._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._widgets = {}

	local widget_definitions = var_0_0.widget_definitions

	for k, v in pairs(widget_definitions.widgets) do
		self._widgets[k] = UIWidget.init(v)
	end

	self._connect_button_widget = UIWidget.init(var_0_0.widget_definitions.connect_button)

	local title_text = self._connect_button_widget.style.title_text

	title_text.text_color = Colors.get_color_table_with_alpha("twitch", 255)
	title_text.text_color_enabled = Colors.get_color_table_with_alpha("twitch", 255)
	self._disconnect_button_widget = UIWidget.init(var_0_0.widget_definitions.disconnect_button)

	local title_text_2 = self._disconnect_button_widget.style.title_text

	title_text_2.text_color = Colors.get_color_table_with_alpha("red", 255)
	title_text_2.text_color_enabled = Colors.get_color_table_with_alpha("red", 255)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._error_timer = nil
end

TwitchView.on_enter = function (self)
	-- function 3
	ShowCursorStack.show("TwitchView")
	self:set_active(true)
end

local flag = true

TwitchView.update = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	if not (self._suspended or self._active) then
		return
	end

	self:_draw(arg_4_1, arg_4_2)
	self:_update_input(arg_4_1, arg_4_2)
	self:_update_error(arg_4_1, arg_4_2)
end

TwitchView.cb_on_message_received = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local content = self._widgets.chat_output_widget.content
	local message_tables = content.message_tables
	local tbl = {}

	tbl.is_dev = false
	tbl.is_system = false
	tbl.sender = string.format("%s: ", arg_5_3)
	tbl.message = arg_5_4
	message_tables[#message_tables + 1] = tbl

	if #message_tables > 20 then
		table.remove(message_tables, 1)
	else
		content.text_start_offset = content.text_start_offset + 1
	end
end

TwitchView._play_sound = function (self, arg_6_1)
	-- function 6
	WwiseWorld.trigger_event(self._wwise_world, arg_6_1)
end

TwitchView._update_input = function (self, arg_7_1, arg_7_2)
	-- function 7
	local content = self._widgets.frame_widget.content
	local get_service = self._input_manager:get_service("twitch_view")

	if not get_service:get("back", true) then
		if not content.text_field_active then
			content.text_field_active = false
		else
			self:set_active(false)

			return
		end
	end

	local is_connecting = Managers.twitch:is_connecting()
	local is_connected = Managers.twitch:is_connected()

	if not is_connecting then
		self._connect_button_widget.content.button_hotspot.on_pressed = false
		self._disconnect_button_widget.content.button_hotspot.on_pressed = false
	else
		local text_input_hotspot = content.text_input_hotspot
		local screen_hotspot = content.screen_hotspot
		local frame_hotspot = content.frame_hotspot

		if not (not text_input_hotspot.on_pressed and is_connected) then
			content.text_field_active = true
		elseif screen_hotspot.on_pressed or not is_connected then
			if not (not screen_hotspot.on_pressed and content.text_field_active or frame_hotspot.on_pressed) then
				self:set_active(false)

				return
			end

			content.text_field_active = false
		end

		if not content.text_field_active then
			local keystrokes = Keyboard.keystrokes()

			content.twitch_name, content.caret_index = KeystrokeHelper.parse_strokes(content.twitch_name, content.caret_index, "insert", keystrokes)

			if not get_service:get("execute_login") then
				content.text_field_active = false

				local gsub = string.gsub(content.twitch_name, " ", "")

				Managers.twitch:connect(gsub, callback(self, "cb_connection_callback"))
			end
		end

		if not self._widgets.exit_button.content.button_hotspot.on_pressed then
			self:set_active(false)

			return
		end

		if not (not self._connect_button_widget.content.button_hotspot.on_pressed and is_connected) then
			local gsub_2 = string.gsub(content.twitch_name, " ", "")

			Managers.twitch:connect(gsub_2, callback(self, "cb_connection_callback"))
		end

		if not self._disconnect_button_widget.content.button_hotspot.on_pressed and not is_connected then
			Managers.twitch:disconnect()

			local content_2 = self._widgets.chat_output_widget.content

			content_2.message_tables = {}
			content_2.text_start_offset = 0
		end
	end
end

TwitchView._update_error = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._error_timer then
		return
	end

	local style = self._widgets.frame_widget.style

	self._error_timer = self._error_timer - arg_8_1

	local lerp = math.lerp(0, 255, math.min(self._error_timer, 1))

	style.error_field.text_color[1] = lerp

	if self._error_timer <= 0 then
		style.error_field.text_color[1] = 0
		self._error_timer = nil
	end
end

TwitchView.cb_connection_callback = function (self, arg_9_1)
	-- function 9
	local content = self._widgets.frame_widget.content
	local style = self._widgets.frame_widget.style

	content.error_id = arg_9_1
	style.error_field.text_color[1] = 255
	self._error_timer = 5
end

TwitchView.set_active = function (self, arg_10_1)
	-- function 10
	self._active = arg_10_1

	if not self._active then
		self._input_manager:block_device_except_service("twitch_view", "keyboard", 1, "twitch")
		self._input_manager:block_device_except_service("twitch_view", "mouse", 1, "twitch")
		self._input_manager:block_device_except_service("twitch_view", "gamepad", 1, "twitch")
		Managers.irc:register_message_callback("twitch", Irc.CHANNEL_MSG, callback(self, "cb_on_message_received"))
	else
		self._input_manager:device_unblock_all_services("keyboard", 1)
		self._input_manager:device_unblock_all_services("mouse", 1)
		self._input_manager:device_unblock_all_services("gamepad", 1)
		self._input_manager:block_device_except_service("start_game_view", "keyboard", 1, "start_game_view")
		self._input_manager:block_device_except_service("start_game_view", "mouse", 1, "start_game_view")
		self._input_manager:block_device_except_service("start_game_view", "gamepad", 1, "start_game_view")
		Managers.irc:unregister_message_callback("twitch")
	end
end

TwitchView.is_active = function (self)
	-- function 11
	return self._active
end

TwitchView.suspend = function (self)
	-- function 12
	self._suspended = true

	self._input_manager:device_unblock_all_services("keyboard", 1)
	self._input_manager:device_unblock_all_services("mouse", 1)
	self._input_manager:device_unblock_all_services("gamepad", 1)
end

TwitchView.unsuspend = function (self)
	-- function 13
	self._input_manager:block_device_except_service("twitch_view", "keyboard", 1, "twitch")
	self._input_manager:block_device_except_service("twitch_view", "mouse", 1, "twitch")
	self._input_manager:block_device_except_service("twitch_view", "gamepad", 1, "twitch")

	self._suspended = nil
end

TwitchView._draw = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("twitch_view")
	local _render_settings = self._render_settings
	local is_connected = Managers.twitch:is_connected()
	local is_connecting = Managers.twitch:is_connecting()

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_14_1, nil, _render_settings)

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	if not is_connecting then
		if not is_connected then
			UIRenderer.draw_widget(_ui_renderer, self._disconnect_button_widget)
		else
			UIRenderer.draw_widget(_ui_renderer, self._connect_button_widget)
		end
	end

	UIRenderer.end_pass(_ui_renderer)
end

TwitchView.on_exit = function (self)
	-- function 15
	ShowCursorStack.hide("TwitchView")
	self:set_active(false)
end

TwitchView.destroy = function (arg_16_0)
	-- function 16
	return
end

TwitchView._exit = function (self, arg_17_1)
	-- function 17
	local flag

	flag = not arg_17_1 and "exit_menu" and "ingame_menu"

	self._ingame_ui:handle_transition(flag)
end

TwitchView.input_service = function (self)
	-- function 18
	return self._input_manager:get_service("twitch_view")
end
