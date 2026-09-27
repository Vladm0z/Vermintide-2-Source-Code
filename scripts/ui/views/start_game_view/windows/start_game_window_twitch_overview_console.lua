-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_twitch_overview_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_overview_console_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widgets = var_0_0.widgets
local play_widgets = var_0_0.play_widgets
local client_widgets = var_0_0.client_widgets
local additional_settings_widgets = var_0_0.additional_settings_widgets
local animation_definitions = var_0_0.animation_definitions
local selector_input_definition = var_0_0.selector_input_definition
local str = "refresh_press"
local str_2 = "confirm_press"
local str_3 = "special_1_press"

StartGameWindowTwitchOverviewConsole = class(StartGameWindowTwitchOverviewConsole)
StartGameWindowTwitchOverviewConsole.NAME = "StartGameWindowTwitchOverviewConsole"

StartGameWindowTwitchOverviewConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameViewWindow] Enter Substate StartGameWindowTwitchOverviewConsole")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._is_server = ingame_ui_context.is_server
	self._mechanism_name = Managers.mechanism:current_mechanism_name()
	self._stats_id = Managers.player:local_player():stats_id()
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)

	if not self._is_server then
		local input_index = arg_1_1.input_index

		input_index = input_index or 1
		self._input_index = input_index

		self:_handle_new_selection(self._input_index)
	end

	if not self._is_server then
		self:_update_mission_option()
		self:_update_difficulty_option()
	end

	self._is_focused = false
	self._play_button_pressed = false
	self._show_additional_settings = false
	self._previous_can_play = nil

	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	self:_set_input_description(twitch)
	self:_set_disconnect_button_text()
	self:_setup_connected_status()

	if not Managers.twitch:is_connected() then
		self:_set_active(true)
	end

	self:_start_transition_animation("on_enter")
end

StartGameWindowTwitchOverviewConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowTwitchOverviewConsole._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	if not self._is_server then
		for k_2, v_2 in pairs(play_widgets) do
			local var_3_3 = UIWidget.init(v_2)

			tbl[#tbl + 1] = var_3_3
			tbl_2[k_2] = var_3_3
		end
	else
		for k_3, v_3 in pairs(client_widgets) do
			local var_3_4 = UIWidget.init(v_3)

			tbl[#tbl + 1] = var_3_4
			tbl_2[k_3] = var_3_4
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}

	for k_4, v_4 in pairs(additional_settings_widgets) do
		local var_3_7 = UIWidget.init(v_4)

		tbl_3[#tbl_3 + 1] = var_3_7
		tbl_4[k_4] = var_3_7
	end

	self._additional_settings_widgets = tbl_3
	self._additional_settings_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	if not IS_PS4 then
		local content = self._widgets_by_name.frame_widget.content
		local twitch_user_name = PlayerData.twitch_user_name

		twitch_user_name = twitch_user_name or ""
		content.twitch_name = twitch_user_name
	end
end

StartGameWindowTwitchOverviewConsole._set_input_description = function (self, arg_4_1)
	-- function 4
	if not self._is_server then
		if not arg_4_1 then
			self._parent:change_generic_actions("default_twitch_connected")
		else
			self._parent:change_generic_actions("default_twitch")
		end
	elseif not arg_4_1 then
		self._parent:change_generic_actions("default_twitch_client_connected")
	else
		self._parent:change_generic_actions("default_twitch_client")
	end

	self._input_description_connected = arg_4_1
end

StartGameWindowTwitchOverviewConsole._set_disconnect_button_text = function (self)
	-- function 5
	local button_2 = self._widgets_by_name.button_2

	if not button_2 then
		local user_name

		if not Managers.twitch then
			user_name = Managers.twitch:user_name()

			if not user_name then
				-- Nothing
			end
		end

		user_name = "N/A"

		::label_5_0::

		button_2.content.button_hotspot.text = string.format(Localize("start_game_window_twitch_disconnect"), user_name)
	end
end

StartGameWindowTwitchOverviewConsole.on_exit = function (self, arg_6_1)
	-- function 6
	print("[StartGameViewWindow] Exit Substate StartGameWindowTwitchOverviewConsole")

	self._ui_animator = nil

	if not self._play_button_pressed then
		arg_6_1.input_index = nil
	else
		arg_6_1.input_index = self._input_index
	end

	self:_set_active(false)
end

StartGameWindowTwitchOverviewConsole.set_focus = function (self, arg_7_1)
	-- function 7
	self._is_focused = arg_7_1
end

StartGameWindowTwitchOverviewConsole.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:_update_input_description()
	self:_update_can_play()
	self:_update_animations(arg_8_1)
	self:_handle_virtual_keyboard(arg_8_1, arg_8_2)
	self:_handle_input(arg_8_1, arg_8_2)
	self:_draw(arg_8_1)
end

StartGameWindowTwitchOverviewConsole.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

StartGameWindowTwitchOverviewConsole._update_input_description = function (self)
	-- function 10
	local _input_description_connected = self._input_description_connected
	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	if twitch ~= _input_description_connected then
		self:_set_input_description(twitch)
	end
end

StartGameWindowTwitchOverviewConsole._update_can_play = function (self)
	-- function 11
	if not self._is_server then
		local _can_play = self:_can_play()

		if self._previous_can_play ~= _can_play then
			self._previous_can_play = _can_play

			local play_button = self._widgets_by_name.play_button

			play_button.content.button_hotspot.disable_button = not _can_play
			play_button.content.disabled = not _can_play

			if not _can_play then
				self._parent:set_input_description("play_available")
			else
				self._parent:set_input_description(nil)
			end
		end
	end
end

StartGameWindowTwitchOverviewConsole._set_active = function (self, arg_12_1)
	-- function 12
	if not arg_12_1 then
		Managers.irc:register_message_callback("twitch_gamepad", Irc.CHANNEL_MSG, callback(self, "cb_on_message_received"))
	else
		Managers.irc:unregister_message_callback("twitch_gamepad")

		local content = self._widgets_by_name.chat_output_widget.content

		table.clear(content.message_tables)
	end
end

StartGameWindowTwitchOverviewConsole.cb_on_message_received = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	local content = self._widgets_by_name.chat_output_widget.content
	local message_tables = content.message_tables
	local tbl = {}

	tbl.is_dev = false
	tbl.is_system = false
	tbl.sender = string.format("%s: ", arg_13_3)
	tbl.message = arg_13_4
	message_tables[#message_tables + 1] = tbl

	if #message_tables > 45 then
		table.remove(message_tables, 1)
	else
		content.text_start_offset = content.text_start_offset + 1
	end
end

StartGameWindowTwitchOverviewConsole._handle_virtual_keyboard = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not self._virtual_keyboard_id then
		return
	end

	if not IS_XB1 then
		if not XboxInterface.interface_active() then
			local get_keyboard_result = XboxInterface.get_keyboard_result()

			self._virtual_keyboard_id = nil

			local gsub = string.gsub(get_keyboard_result, " ", "")

			if not gsub then
				PlayerData.twitch_user_name = gsub
			end

			self._widgets_by_name.frame_widget.content.twitch_name = gsub

			Managers.twitch:connect(gsub, callback(Managers.twitch, "cb_connection_error_callback"), callback(self, "cb_connection_success_callback"))
			self:_play_sound("Play_hud_select")
		end
	else
		local poll_virtual_keyboard, var_14_3, var_14_4 = Managers.system_dialog:poll_virtual_keyboard(self._virtual_keyboard_id)

		if not poll_virtual_keyboard then
			self._virtual_keyboard_id = nil

			if not var_14_3 then
				local gsub_2 = string.gsub(var_14_4, " ", "")

				if not gsub_2 then
					PlayerData.twitch_user_name = gsub_2
				end

				self._widgets_by_name.frame_widget.content.twitch_name = gsub_2

				Managers.twitch:connect(gsub_2, callback(Managers.twitch, "cb_connection_error_callback"), callback(self, "cb_connection_success_callback"))
				self:_play_sound("Play_hud_select")
			end
		end
	end
end

StartGameWindowTwitchOverviewConsole._handle_input = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._virtual_keyboard_id then
		return
	end

	local _parent = self._parent
	local window_input_service = _parent:window_input_service()

	self:_handle_twitch_login_input(arg_15_1, arg_15_2, window_input_service)

	if not self._is_server then
		if not window_input_service:get(str_2) then
			self:_option_selected(self._input_index, arg_15_2)
		end

		local _input_index = self._input_index

		if not window_input_service:get("move_down") then
			_input_index = _input_index + 1
		elseif not window_input_service:get("move_up") then
			_input_index = _input_index - 1
		end

		if _input_index ~= self._input_index then
			self:_handle_new_selection(_input_index)
		end

		local _widgets_by_name = self._widgets_by_name

		for i = 1, #selector_input_definition do
			local var_15_4 = _widgets_by_name[selector_input_definition[i]]

			if var_15_4.content.is_selected or not self:_is_button_hover_enter(var_15_4) then
				self:_handle_new_selection(i)
			end

			if not self:_is_button_pressed(var_15_4) then
				self:_option_selected(self._input_index, arg_15_2)
			end
		end

		if not self:_can_play() then
			if not self:_is_button_hover_enter(_widgets_by_name.play_button) then
				self._parent:play_sound("Play_hud_hover")
			end

			if window_input_service:get(str) or not self:_is_button_pressed(_widgets_by_name.play_button) then
				local get_twitch_settings = _parent:get_twitch_settings(self._mechanism_name)

				get_twitch_settings = get_twitch_settings or _parent:get_twitch_settings("adventure")

				_parent:play(arg_15_2, get_twitch_settings.game_mode_type)

				self._play_button_pressed = true
			end
		end
	end
end

StartGameWindowTwitchOverviewConsole._handle_twitch_login_input = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	if not Managers.twitch:is_connecting() then
		local is_connected = Managers.twitch:is_connected()
		local frame_widget = self._widgets_by_name.frame_widget

		if not IS_WINDOWS then
			local content = frame_widget.content
			local text_input_hotspot = content.text_input_hotspot
			local screen_hotspot = content.screen_hotspot
			local frame_hotspot = content.frame_hotspot

			if not (not text_input_hotspot.on_pressed and is_connected) then
				self._parent.parent:set_input_blocked(true)

				content.text_field_active = true
			elseif not content.text_field_active and not screen_hotspot.on_pressed then
				content.text_field_active = false

				self._parent.parent:set_input_blocked(false)
			end

			if not content.text_field_active then
				arg_16_3:get("move_up", true)
				arg_16_3:get("move_down", true)
				arg_16_3:get("cycle_next", true)
				arg_16_3:get("cycle_previous", true)
				Managers.chat:block_chat_input_for_one_frame()

				local keystrokes = Keyboard.keystrokes()

				content.twitch_name, content.caret_index = KeystrokeHelper.parse_strokes(content.twitch_name, content.caret_index, "insert", keystrokes)

				if not arg_16_3:get("execute_chat_input", true) then
					content.text_field_active = false

					local gsub = string.gsub(content.twitch_name, " ", "")

					Managers.twitch:connect(gsub, callback(Managers.twitch, "cb_connection_error_callback"), callback(self, "cb_connection_success_callback"))
				elseif not arg_16_3:get("toggle_menu", true) then
					content.text_field_active = false

					self._parent.parent:set_input_blocked(false)
				end
			end
		end

		if not is_connected then
			local button_1 = self._widgets_by_name.button_1

			if not button_1 and not self:_is_button_hover_enter(button_1) then
				self:_play_sound("Play_hud_hover")
			end

			if not button_1 and self:_is_button_pressed(button_1) or not arg_16_3:get(str_3) then
				if not IS_PS4 then
					local user_id = Managers.account:user_id()
					local twitch_user_name = PlayerData.twitch_user_name
					local var_16_11 = Localize("start_game_window_twitch_login_hint")
					local twitch_keyboard_anchor_point = var_0_0.twitch_keyboard_anchor_point
					local inv_scale = RESOLUTION_LOOKUP.inv_scale

					self._virtual_keyboard_id = Managers.system_dialog:open_virtual_keyboard(user_id, var_16_11, twitch_user_name, twitch_keyboard_anchor_point)
				elseif not IS_XB1 then
					local twitch_user_name_2 = PlayerData.twitch_user_name
					local var_16_15 = Localize("start_game_window_twitch_login_hint")

					XboxInterface.show_virtual_keyboard(twitch_user_name_2, var_16_15)

					self._virtual_keyboard_id = true
				else
					local str = ""

					if not frame_widget then
						local content_2 = frame_widget.content

						str = string.gsub(content_2.twitch_name, " ", "")
					end

					Managers.twitch:connect(str, callback(Managers.twitch, "cb_connection_error_callback"), callback(self, "cb_connection_success_callback"))
					self:_play_sound("Play_hud_select")
				end
			end
		else
			local button_2 = self._widgets_by_name.button_2

			if not button_2 and not self:_is_button_hover_enter(button_2) then
				self:_play_sound("Play_hud_hover")
			end

			if not button_2 and self:_is_button_pressed(button_2) or not arg_16_3:get(str_3) then
				self:_play_sound("Play_hud_select")
				self:_set_active(false)
				Managers.twitch:disconnect()
			end
		end
	end
end

StartGameWindowTwitchOverviewConsole._is_button_pressed = function (arg_17_0, arg_17_1)
	-- function 17
	local button_hotspot = arg_17_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowTwitchOverviewConsole._is_button_hover_enter = function (arg_18_0, arg_18_1)
	-- function 18
	return arg_18_1.content.button_hotspot.on_hover_enter
end

StartGameWindowTwitchOverviewConsole.cb_connection_success_callback = function (self, arg_19_1)
	-- function 19
	self:_set_disconnect_button_text()
	self:_setup_connected_status()
	self:_set_active(true)
end

StartGameWindowTwitchOverviewConsole._setup_connected_status = function (arg_20_0)
	-- function 20
	local user_name

	if not Managers.twitch then
		user_name = Managers.twitch:user_name()

		if not user_name then
			-- Nothing
		end
	end

	user_name = "N/A"

	::label_20_0::

	arg_20_0._widgets_by_name.frame_widget.content.connected = Localize("start_game_window_twitch_connected_to") .. user_name
end

StartGameWindowTwitchOverviewConsole._can_play = function (self)
	-- function 21
	if not self._is_server then
		return false
	end

	local _parent = self._parent
	local get_selected_level_id = _parent:get_selected_level_id()
	local get_difficulty_option = _parent:get_difficulty_option()
	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	return get_selected_level_id == nil or get_difficulty_option == nil or twitch
end

StartGameWindowTwitchOverviewConsole._update_mission_option = function (self)
	-- function 22
	local get_selected_level_id = self._parent:get_selected_level_id()

	if not get_selected_level_id then
		self:_set_selected_level(get_selected_level_id)
	end
end

StartGameWindowTwitchOverviewConsole._set_selected_level = function (self, arg_23_1)
	-- function 23
	local var_23_0 = LevelSettings[arg_23_1]
	local mission_setting = self._widgets_by_name.mission_setting

	mission_setting.content.input_text = Localize(var_23_0.display_name)

	local level_image = var_23_0.level_image

	mission_setting.content.icon_texture = level_image

	local get_completed_level_difficulty_index = self._parent:get_completed_level_difficulty_index(self._statistics_db, self._stats_id, arg_23_1)
	local get_level_frame_by_difficulty_index = UIWidgetUtils.get_level_frame_by_difficulty_index(get_completed_level_difficulty_index)

	mission_setting.content.icon_frame_texture = get_level_frame_by_difficulty_index
end

StartGameWindowTwitchOverviewConsole._update_difficulty_option = function (self)
	-- function 24
	local get_difficulty_option = self._parent:get_difficulty_option()

	if not get_difficulty_option then
		local var_24_1 = DifficultySettings[get_difficulty_option]
		local difficulty_setting = self._widgets_by_name.difficulty_setting

		difficulty_setting.content.input_text = Localize(var_24_1.display_name)

		local display_image = var_24_1.display_image

		difficulty_setting.content.icon_texture = display_image

		local completed_frame_texture = var_24_1.completed_frame_texture

		difficulty_setting.content.icon_frame_texture = completed_frame_texture
	end
end

StartGameWindowTwitchOverviewConsole._option_selected = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _parent = self._parent
	local get_twitch_settings = _parent:get_twitch_settings(self._mechanism_name)

	get_twitch_settings = get_twitch_settings or _parent:get_twitch_settings("adventure")

	local var_25_2 = selector_input_definition[arg_25_1]

	if var_25_2 == "mission_setting" then
		self._parent:set_layout_by_name(get_twitch_settings.layout_name)
	elseif var_25_2 == "difficulty_setting" then
		self._parent:set_layout_by_name("difficulty_selection_custom")
	elseif var_25_2 == "play_button" then
		if not self:_can_play() then
			self._play_button_pressed = true

			self._parent:play(arg_25_2, get_twitch_settings.game_mode_type)
		end
	else
		ferror("Unknown selector_input_definition: %s", var_25_2)
	end
end

StartGameWindowTwitchOverviewConsole._handle_new_selection = function (self, arg_26_1)
	-- function 26
	local _widgets_by_name = self._widgets_by_name
	local count = #selector_input_definition

	arg_26_1 = math.clamp(arg_26_1, 1, count)

	if not _widgets_by_name[selector_input_definition[arg_26_1]].content.disabled then
		return
	end

	for i = 1, #selector_input_definition do
		local var_26_2 = _widgets_by_name[selector_input_definition[i]]

		if not var_26_2 then
			local flag = i == arg_26_1

			var_26_2.content.is_selected = flag
		end
	end

	if self._input_index ~= arg_26_1 then
		self._parent:play_sound("play_gui_lobby_button_02_mission_act_click")
	end

	self._input_index = arg_26_1
end

StartGameWindowTwitchOverviewConsole._update_animations = function (self, arg_27_1)
	-- function 27
	if not (IS_PS4 or Managers.input:is_device_active("gamepad")) then
		self:_update_button_animations(arg_27_1)
	end

	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_27_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	if not self._is_server then
		local _widgets_by_name = self._widgets_by_name

		UIWidgetUtils.animate_start_game_console_setting_button(_widgets_by_name.mission_setting, arg_27_1)
		UIWidgetUtils.animate_start_game_console_setting_button(_widgets_by_name.difficulty_setting, arg_27_1)
		UIWidgetUtils.animate_play_button(_widgets_by_name.play_button, arg_27_1)
	end
end

StartGameWindowTwitchOverviewConsole._update_button_animations = function (self, arg_28_1)
	-- function 28
	local _widgets_by_name = self._widgets_by_name
	local str = "button_"

	for i = 1, 2 do
		local var_28_2 = _widgets_by_name[str .. i]

		self:_animate_button(var_28_2, arg_28_1)
	end
end

StartGameWindowTwitchOverviewConsole._animate_button = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	local button_hotspot = arg_29_1.content.button_hotspot
	local num = 20
	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local is_clicked = button_hotspot.is_clicked

	is_clicked = not is_clicked and button_hotspot.is_clicked == 0

	if not is_clicked then
		input_progress = math.min(input_progress + arg_29_2 * num, 1)
	else
		input_progress = math.max(input_progress - arg_29_2 * num, 0)
	end

	local num_2 = 8
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	if not (not not button_hotspot.disable_button or button_hotspot.is_hover) then
		hover_progress = math.min(hover_progress + arg_29_2 * num_2, 1)
	else
		hover_progress = math.max(hover_progress - arg_29_2 * num_2, 0)
	end

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	if not (not not button_hotspot.disable_button or button_hotspot.is_selected) then
		selection_progress = math.min(selection_progress + arg_29_2 * num_2, 1)
	else
		selection_progress = math.max(selection_progress - arg_29_2 * num_2, 0)
	end

	local max = math.max(hover_progress, selection_progress)
	local style = arg_29_1.style

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

StartGameWindowTwitchOverviewConsole._draw = function (self, arg_30_1)
	-- function 30
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local var_30_4

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_30_1, var_30_4, _render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_30_6 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_30_6)
	end

	if not self._show_additional_settings then
		local _additional_settings_widgets = self._additional_settings_widgets

		for j = 1, #_additional_settings_widgets do
			local var_30_8 = _additional_settings_widgets[j]

			UIRenderer.draw_widget(_ui_top_renderer, var_30_8)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowTwitchOverviewConsole._play_sound = function (self, arg_31_1)
	-- function 31
	self._parent:play_sound(arg_31_1)
end
