-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_twitch.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_twitch_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widgets = var_0_0.widgets
local selection_widgets = var_0_0.selection_widgets
local client_widgets = var_0_0.client_widgets
local server_widgets = var_0_0.server_widgets
local additional_settings_widgets = var_0_0.additional_settings_widgets
local animation_definitions = var_0_0.animation_definitions
local selector_input_definition = var_0_0.selector_input_definition
local str = "refresh_press"
local str_2 = "confirm_press"
local str_3 = "special_1_press"

StartGameWindowDeusTwitch = class(StartGameWindowDeusTwitch)
StartGameWindowDeusTwitch.NAME = "StartGameWindowDeusTwitch"

StartGameWindowDeusTwitch.on_enter = function (self, arg_1_1, arg_1_2)
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
	self._is_focused = false
	self._play_button_pressed = false
	self._show_additional_settings = false
	self._previous_can_play = nil

	local get_difficulty_option = self._parent:get_difficulty_option(true)

	get_difficulty_option = get_difficulty_option or Managers.state.difficulty:get_difficulty()
	self._current_difficulty = get_difficulty_option
	self._dlc_name = nil
	self._backend_deus = Managers.backend:get_interface("deus")
	self._animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)

	if not self._is_server then
		local var_1_2 = self
		local _gamepad_selector_input_func = self._gamepad_selector_input_func
		local input_index = arg_1_1.input_index

		input_index = input_index or 1

		_gamepad_selector_input_func(var_1_2, input_index)
		self:_update_expedition_option()
		self:_update_difficulty_option(self._current_difficulty)
	end

	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	self:_set_input_description(twitch)
	self:_set_disconnect_button_text()
	self:_setup_connected_status()

	if not Managers.twitch:is_connected() then
		self:_set_active(true)
	end

	self:_start_transition_animation("on_enter")
	Managers.state.event:register(self, "_update_additional_curse_frame", "_update_additional_curse_frame")
end

StartGameWindowDeusTwitch._create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._expedition_widgets = {}

	local tbl = {}
	local tbl_2 = {}

	if not self._is_server then
		tbl, tbl_2 = UIUtils.create_widgets(selection_widgets)

		UIUtils.create_widgets(server_widgets, self._widgets, self._widgets_by_name)
		self:_gather_unlocked_journeys()
		self:_setup_journey_widgets()
		self:_refresh_journey_cycle()
	else
		UIUtils.create_widgets(client_widgets, self._widgets, self._widgets_by_name)
	end

	self._selection_widgets = tbl
	self._selection_widgets_by_name = tbl_2
	self._additional_settings_widgets, self._additional_settings_widgets_by_name = UIUtils.create_widgets(additional_settings_widgets)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end

	if not IS_PS4 then
		local content = self._widgets_by_name.frame_widget.content
		local twitch_user_name = PlayerData.twitch_user_name

		twitch_user_name = twitch_user_name or ""
		content.twitch_name = twitch_user_name
	end

	self._widgets_by_name.difficulty_info.content.visible = false
	self._widgets_by_name.upsell_button.content.visible = false
end

StartGameWindowDeusTwitch.set_focus = function (self, arg_3_1)
	-- function 3
	self._is_focused = arg_3_1
end

StartGameWindowDeusTwitch._set_active = function (self, arg_4_1)
	-- function 4
	if not arg_4_1 then
		Managers.irc:register_message_callback("twitch_gamepad", Irc.CHANNEL_MSG, callback(self, "cb_on_message_received"))
	else
		Managers.irc:unregister_message_callback("twitch_gamepad")

		local content = self._widgets_by_name.chat_output_widget.content

		table.clear(content.message_tables)
	end
end

StartGameWindowDeusTwitch._set_disconnect_button_text = function (self)
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

StartGameWindowDeusTwitch.cb_on_message_received = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local content = self._widgets_by_name.chat_output_widget.content
	local message_tables = content.message_tables
	local tbl = {}

	tbl.is_dev = false
	tbl.is_system = false
	tbl.sender = string.format("%s: ", arg_6_3)
	tbl.message = arg_6_4
	message_tables[#message_tables + 1] = tbl

	if #message_tables > 45 then
		table.remove(message_tables, 1)
	else
		content.text_start_offset = content.text_start_offset + 1
	end
end

StartGameWindowDeusTwitch.set_input_blocked = function (self, arg_7_1)
	-- function 7
	local input = Managers.input

	if not arg_7_1 then
		input:block_device_except_service("start_game_view", "keyboard", 1, "twitch")
		input:block_device_except_service("start_game_view", "mouse", 1, "twitch")
		input:block_device_except_service("start_game_view", "gamepad", 1, "twitch")
		self._parent.parent:set_input_blocked(true)
	else
		input:device_unblock_all_services("keyboard")
		input:device_unblock_all_services("mouse")
		input:device_unblock_all_services("gamepad")
		input:block_device_except_service("start_game_view", "keyboard", 1)
		input:block_device_except_service("start_game_view", "mouse", 1)
		input:block_device_except_service("start_game_view", "gamepad", 1)
		self._parent.parent:set_input_blocked(false)
	end
end

StartGameWindowDeusTwitch._handle_twitch_login_input = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not Managers.twitch:is_connecting() then
		local is_connected = Managers.twitch:is_connected()
		local frame_widget = self._widgets_by_name.frame_widget

		if not IS_WINDOWS then
			local content = frame_widget.content
			local text_input_hotspot = content.text_input_hotspot
			local screen_hotspot = content.screen_hotspot
			local frame_hotspot = content.frame_hotspot

			if not (not text_input_hotspot.on_pressed and is_connected) then
				self:set_input_blocked(true)

				content.text_field_active = true
			elseif screen_hotspot.on_pressed or not is_connected then
				if not (not screen_hotspot.on_pressed and content.text_field_active or frame_hotspot.on_pressed) then
					content.text_field_active = false

					self:set_input_blocked(false)

					return
				end

				content.text_field_active = false

				self:set_input_blocked(false)
			end

			if not content.text_field_active then
				if not arg_8_3:get("toggle_menu", true) then
					content.text_field_active = false

					self:set_input_blocked(false)
				else
					Managers.chat:block_chat_input_for_one_frame()

					local keystrokes = Keyboard.keystrokes()

					content.twitch_name, content.caret_index = KeystrokeHelper.parse_strokes(content.twitch_name, content.caret_index, "insert", keystrokes)

					if not arg_8_3:get("execute_chat_input", true) then
						content.text_field_active = false

						self:set_input_blocked(false)

						local gsub = string.gsub(content.twitch_name, " ", "")

						Managers.twitch:connect(gsub, callback(Managers.twitch, "cb_connection_error_callback"), callback(self, "cb_connection_success_callback"))
					end
				end
			end
		end

		if not is_connected then
			local button_1 = self._widgets_by_name.button_1

			if not button_1 and not UIUtils.is_button_hover_enter(button_1) then
				self:_play_sound("Play_hud_hover")
			end

			if not button_1 and UIUtils.is_button_pressed(button_1) or not arg_8_3:get(str_3) then
				if not IS_PS4 then
					local user_id = Managers.account:user_id()
					local twitch_user_name = PlayerData.twitch_user_name
					local var_8_11 = Localize("start_game_window_twitch_login_hint")
					local twitch_keyboard_anchor_point = var_0_0.twitch_keyboard_anchor_point
					local inv_scale = RESOLUTION_LOOKUP.inv_scale

					self._virtual_keyboard_id = Managers.system_dialog:open_virtual_keyboard(user_id, var_8_11, twitch_user_name, twitch_keyboard_anchor_point)
				elseif not IS_XB1 then
					local twitch_user_name_2 = PlayerData.twitch_user_name
					local var_8_15 = Localize("start_game_window_twitch_login_hint")

					XboxInterface.show_virtual_keyboard(twitch_user_name_2, var_8_15)

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

			if not button_2 and not UIUtils.is_button_hover_enter(button_2) then
				self:_play_sound("Play_hud_hover")
			end

			if not button_2 and UIUtils.is_button_pressed(button_2) or not arg_8_3:get(str_3) then
				self:_play_sound("Play_hud_select")
				self:_set_active(false)
				Managers.twitch:disconnect()
			end
		end
	end
end

StartGameWindowDeusTwitch.cb_connection_success_callback = function (self, arg_9_1)
	-- function 9
	self:_set_disconnect_button_text()
	self:_setup_connected_status()
	self:_set_active(true)
end

StartGameWindowDeusTwitch._setup_connected_status = function (arg_10_0)
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

	arg_10_0._widgets_by_name.frame_widget.content.connected = Localize("start_game_window_twitch_connected_to") .. user_name
end

local function fn(self, arg_11_1)
	-- function 11
	return self.remaining_time - (arg_11_1 - self.time_of_update) < 0
end

StartGameWindowDeusTwitch._gather_unlocked_journeys = function (self)
	-- function 12
	local tbl = {}

	for i, v in ipairs(LevelUnlockUtils.unlocked_journeys(self._statistics_db, self._stats_id)) do
		tbl[v] = true
	end

	local journey_data = self._backend_deus:get_journey_cycle().journey_data

	for k, v_2 in pairs(tbl) do
		if not LevelUnlockUtils.is_chaos_waste_god_disabled(journey_data[k].dominant_god) then
			tbl[k] = nil
		end
	end

	self._unlocked_journeys = tbl
end

StartGameWindowDeusTwitch._setup_journey_widgets = function (self)
	-- function 13
	local _node_widgets = self._node_widgets
	local _statistics_db = self._statistics_db
	local _stats_id = self._stats_id
	local _unlocked_journeys = self._unlocked_journeys
	local tbl = {}
	local num = -365
	local journey_widget_settings = var_0_0.journey_widget_settings
	local AvailableJourneyOrder = AvailableJourneyOrder

	for i = 1, #AvailableJourneyOrder do
		local var_13_8 = AvailableJourneyOrder[i]
		local deus_journey_with_belakor = self._backend_deus:deus_journey_with_belakor(var_13_8)
		local var_13_10 = DeusJourneySettings[var_13_8]
		local num_2 = #tbl + 1
		local var_13_12 = AvailableJourneyOrder[num_2 + 1]
		local create_expedition_widget_func = UIWidgets.create_expedition_widget_func("level_root_node", num_2, var_13_10, var_13_8, journey_widget_settings)
		local var_13_14 = UIWidget.init(create_expedition_widget_func)
		local content = var_13_14.content

		content.text = Localize(var_13_10.display_name)
		num = num + (journey_widget_settings.width + journey_widget_settings.spacing_x)

		local offset = var_13_14.offset

		offset[1] = num
		offset[2] = 0

		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(_statistics_db, _stats_id, var_13_8)
		local get_level_frame_by_difficulty_index = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_level_difficulty_index)
		local var_13_19 = _unlocked_journeys[var_13_8]

		content.level_icon = var_13_10.level_image
		content.locked = not var_13_19
		content.frame = get_level_frame_by_difficulty_index
		content.journey_name = var_13_8

		local flag

		flag = not deus_journey_with_belakor and "morris_expedition_select_border_belakor" and "morris_expedition_select_border"
		content.level_icon_frame = flag
		content.draw_path = var_13_12 ~= nil
		content.draw_path_fill = _unlocked_journeys[var_13_12]
		var_13_14.style.path.texture_size[1] = journey_widget_settings.spacing_x
		var_13_14.style.path_glow.texture_size[1] = journey_widget_settings.spacing_x
		tbl[num_2] = var_13_14
		num = num + journey_widget_settings.spacing_x
	end

	self._expedition_widgets = tbl
end

StartGameWindowDeusTwitch._refresh_journey_cycle = function (self)
	-- function 14
	self._journey_cycle = self._backend_deus:get_journey_cycle()

	self:_on_new_journey_cycle()
end

StartGameWindowDeusTwitch._on_new_journey_cycle = function (self)
	-- function 15
	self:_update_journey_god_icons()
end

StartGameWindowDeusTwitch._update_journey_god_icons = function (self)
	-- function 16
	local _journey_cycle = self._journey_cycle

	for i, v in ipairs(self._expedition_widgets) do
		local content = v.content
		local dominant_god = _journey_cycle.journey_data[content.journey_name].dominant_god

		content.theme_icon = DeusThemeSettings[dominant_god].text_icon
	end
end

StartGameWindowDeusTwitch.update = function (self, arg_17_1, arg_17_2)
	-- function 17
	self:_update_modifiers(arg_17_1, arg_17_2)
	self:_update_input_description(arg_17_1, arg_17_2)
	self:_update_can_play(arg_17_1, arg_17_2)
	self:_update_animations(arg_17_1)
	self:_handle_virtual_keyboard(arg_17_1, arg_17_2)
	self:_handle_gamepad_activity(arg_17_1, arg_17_2)
	self:_handle_input(arg_17_1, arg_17_2)
	self:_draw(arg_17_1, arg_17_2)
end

StartGameWindowDeusTwitch.post_update = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	return
end

StartGameWindowDeusTwitch._handle_input = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not self._virtual_keyboard_id then
		return
	end

	local _parent = self._parent
	local window_input_service = _parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("mouse")

	if not self._widgets_by_name.frame_widget.content.text_field_active then
		window_input_service:get("move_up", true)
		window_input_service:get("move_down", true)
		window_input_service:get("move_left", true)
		window_input_service:get("move_right", true)
		window_input_service:get("cycle_next", true)
		window_input_service:get("cycle_previous", true)
	end

	if not self._is_server then
		if not is_device_active then
			local var_19_3
			local _input_index = self._input_index

			if not window_input_service:get("move_down") then
				_input_index = _input_index + 1
				var_19_3 = 1
			elseif not window_input_service:get("move_up") then
				_input_index = _input_index - 1
				var_19_3 = -1
			else
				selector_input_definition[_input_index].update(self, window_input_service, arg_19_1, arg_19_2)
			end

			if _input_index ~= self._input_index then
				self:_gamepad_selector_input_func(_input_index, var_19_3)
			end
		else
			local _selection_widgets_by_name = self._selection_widgets_by_name

			for k, v in pairs(_selection_widgets_by_name) do
				if k == "difficulty_stepper" then
					if not UIUtils.is_button_pressed(v, "left_arrow_hotspot") then
						self:_option_selected(k, "left_arrow", arg_19_2)
					elseif not UIUtils.is_button_pressed(v, "right_arrow_hotspot") then
						self:_option_selected(k, "right_arrow", arg_19_2)
					end

					if UIUtils.is_button_hover(v, "info_hotspot") or not UIUtils.is_button_hover(self._widgets_by_name.difficulty_info, "widget_hotspot") then
						local tbl = {
							difficulty_info = self._widgets_by_name.difficulty_info,
							upsell_button = self._widgets_by_name.upsell_button
						}

						if not self.diff_info_anim_played then
							self._diff_anim_id = self._ui_animator:start_animation("difficulty_info_enter", tbl, scenegraph_definition)
							self.diff_info_anim_played = true
						end

						self:_update_difficulty_lock()
					else
						if not self._diff_anim_id then
							self._ui_animator:stop_animation(self._diff_anim_id)
						end

						self.diff_info_anim_played = false
						self._widgets_by_name.upsell_button.content.visible = false
						self._widgets_by_name.difficulty_info.content.visible = false
					end
				elseif not UIUtils.is_button_pressed(v) then
					self:_option_selected(k, nil, arg_19_2)
				end

				if k == "difficulty_stepper" then
					local content = v.content
					local is_button_hover = UIUtils.is_button_hover(v, "left_arrow_hotspot")

					is_button_hover = is_button_hover or UIUtils.is_button_hover(v, "right_arrow_hotspot")
					content.is_selected = is_button_hover
				else
					v.content.is_selected = UIUtils.is_button_hover(v)
				end
			end
		end

		local _expeditions_selection_index = self._expeditions_selection_index
		local var_19_10 = self._expedition_widgets[self._expeditions_selection_index]

		for k_2 = 1, #self._expedition_widgets do
			local var_19_11 = self._expedition_widgets[k_2]

			if not UIUtils.is_button_pressed(var_19_11) then
				if not var_19_10 then
					var_19_10.content.button_hotspot.is_selected = nil
				end

				var_19_11.content.button_hotspot.is_selected = true

				local journey_name = var_19_11.content.journey_name

				_parent:set_selected_level_id(journey_name)

				self._expeditions_selection_index = k_2

				self:_play_sound("play_gui_lobby_button_01_difficulty_select_normal")
			end

			if not UIUtils.is_button_hover_enter(var_19_11) then
				self._parent:play_sound("Play_hud_hover")
			end
		end

		local upsell_button = self._widgets_by_name.upsell_button

		if not UIUtils.is_button_pressed(upsell_button) then
			Managers.unlock:open_dlc_page(self._dlc_name)
		end

		if not self:_can_play() then
			local _selection_widgets_by_name_2 = self._selection_widgets_by_name

			if not UIUtils.is_button_hover_enter(_selection_widgets_by_name_2.play_button) then
				self._parent:play_sound("Play_hud_hover")
			end

			if window_input_service:get(str) or not UIUtils.is_button_pressed(_selection_widgets_by_name_2.play_button) then
				local get_twitch_settings = _parent:get_twitch_settings(self._mechanism_name)

				get_twitch_settings = get_twitch_settings or _parent:get_twitch_settings("adventure")

				self._parent:set_difficulty_option(self._current_difficulty)
				_parent:play(arg_19_2, get_twitch_settings.game_mode_type)

				self._play_button_pressed = true
			end
		end
	end

	self:_update_gamemode_info_text(window_input_service)
	self:_handle_twitch_login_input(arg_19_1, arg_19_2, window_input_service)
end

StartGameWindowDeusTwitch._update_input_description = function (self, arg_20_1, arg_20_2)
	-- function 20
	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	self:_set_input_description(twitch)
end

StartGameWindowDeusTwitch._update_modifiers = function (self, arg_21_1, arg_21_2)
	-- function 21
	local time = Managers.time:time("main")
	local _journey_cycle = self._journey_cycle

	if not _journey_cycle and not fn(_journey_cycle, time) then
		self:_refresh_journey_cycle()
	end
end

StartGameWindowDeusTwitch._update_expedition_option = function (self)
	-- function 22
	local get_selected_level_id = self._parent:get_selected_level_id()

	if not get_selected_level_id then
		return
	end

	local var_22_1 = LevelSettings[get_selected_level_id]
	local display_name = var_22_1.display_name
	local level_image = var_22_1.level_image
	local get_completed_level_difficulty_index = self._parent:get_completed_level_difficulty_index(self._statistics_db, self._stats_id, get_selected_level_id)

	for i = 1, #self._expedition_widgets do
		local content = self._expedition_widgets[i].content

		if get_selected_level_id == content.journey_name then
			content.button_hotspot.is_selected = true
			self._expeditions_selection_index = i

			break
		end
	end
end

StartGameWindowDeusTwitch._update_button_animations = function (self, arg_23_1)
	-- function 23
	local _widgets_by_name = self._widgets_by_name

	self:_animate_button(_widgets_by_name.button_1, arg_23_1)
	self:_animate_button(_widgets_by_name.button_2, arg_23_1)
end

StartGameWindowDeusTwitch._update_animations = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not (IS_PS4 or Managers.input:is_device_active("gamepad")) then
		self:_update_button_animations(arg_24_1)
	end

	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_24_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_animations[k] = nil
		end
	end

	local _expedition_widgets = self._expedition_widgets

	for k_2 = 1, #_expedition_widgets do
		local var_24_3 = _expedition_widgets[k_2]

		self:_animate_expedition_widget(var_24_3, arg_24_1)
	end
end

StartGameWindowDeusTwitch._draw = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local var_25_4

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_25_1, var_25_4, _render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._expedition_widgets)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._selection_widgets)

	if not self._show_additional_settings then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._additional_settings_widgets)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowDeusTwitch._start_transition_animation = function (self, arg_26_1)
	-- function 26
	local tbl = {
		render_settings = self._render_settings
	}
	local start_animation = self._ui_animator:start_animation(arg_26_1, nil, scenegraph_definition, tbl)

	self._animations[arg_26_1] = start_animation
end

StartGameWindowDeusTwitch._animate_button = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local button_hotspot = arg_27_1.content.button_hotspot
	local num = 20
	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local is_clicked = button_hotspot.is_clicked

	is_clicked = not is_clicked and button_hotspot.is_clicked == 0

	local animate_value = UIUtils.animate_value(input_progress, arg_27_2 * num, is_clicked)
	local num_2 = 8
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local flag = not not button_hotspot.disable_button or button_hotspot.is_hover
	local animate_value_2 = UIUtils.animate_value(hover_progress, arg_27_2 * num_2, flag)
	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local flag_2 = not not button_hotspot.disable_button or button_hotspot.is_selected
	local animate_value_3 = UIUtils.animate_value(selection_progress, arg_27_2 * num_2, flag_2)
	local max = math.max(animate_value_2, animate_value_3)
	local style = arg_27_1.style

	style.clicked_rect.color[1] = 100 * animate_value

	local str = "hover_glow"
	local num_3 = 255 * max

	style[str].color[1] = num_3

	local text = style.text
	local text_color = text.text_color
	local default_text_color = text.default_text_color
	local select_text_color = text.select_text_color

	Colors.lerp_color_tables(default_text_color, select_text_color, max, text_color)

	button_hotspot.hover_progress = animate_value_2
	button_hotspot.input_progress = animate_value
	button_hotspot.selection_progress = animate_value_3
end

StartGameWindowDeusTwitch._animate_expedition_widget = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local button_hotspot = arg_28_1.content.button_hotspot
	local is_selected = button_hotspot.is_selected
	local selected_progress = button_hotspot.selected_progress

	selected_progress = selected_progress or 0

	local num = 1.5
	local animate_value = UIUtils.animate_value(selected_progress, num * arg_28_2, is_selected)

	arg_28_1.style.purple_glow.color[1] = 255 * animate_value
	button_hotspot.selected_progress = animate_value
end

StartGameWindowDeusTwitch._play_sound = function (self, arg_29_1)
	-- function 29
	self._parent:play_sound(arg_29_1)
end

StartGameWindowDeusTwitch._handle_virtual_keyboard = function (self, arg_30_1, arg_30_2)
	-- function 30
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
		local poll_virtual_keyboard, var_30_3, var_30_4 = Managers.system_dialog:poll_virtual_keyboard(self._virtual_keyboard_id)

		if not poll_virtual_keyboard then
			self._virtual_keyboard_id = nil

			if not var_30_3 then
				local gsub_2 = string.gsub(var_30_4, " ", "")

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

StartGameWindowDeusTwitch._handle_gamepad_activity = function (self, arg_31_1, arg_31_2)
	-- function 31
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true
			self._input_index = 1

			local var_31_1 = selector_input_definition[self._input_index]

			if not var_31_1 and not var_31_1.enter_requirements(self) then
				var_31_1.on_enter(self)
			end
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		local var_31_2 = selector_input_definition[self._input_index]

		if not var_31_2 then
			var_31_2.on_exit(self)
		end
	end
end

StartGameWindowDeusTwitch._verify_selection_index = function (self, arg_32_1, arg_32_2)
	-- function 32
	local _input_index = self._input_index
	local count = #selector_input_definition

	arg_32_1 = math.clamp(arg_32_1, 1, count)

	if not arg_32_2 then
		return arg_32_1
	end

	local var_32_2 = selector_input_definition[arg_32_1]

	while not (not var_32_2 and not (arg_32_1 < count) or var_32_2.enter_requirements(self)) do
		arg_32_1 = arg_32_1 + arg_32_2
		var_32_2 = selector_input_definition[arg_32_1]
	end

	if not var_32_2 and not var_32_2.enter_requirements(self) then
		_input_index = arg_32_1
	end

	return _input_index
end

StartGameWindowDeusTwitch._gamepad_selector_input_func = function (self, arg_33_1, arg_33_2)
	-- function 33
	local is_device_active = Managers.input:is_device_active("mouse")

	arg_33_1 = self:_verify_selection_index(arg_33_1, arg_33_2)

	if not (self._input_index == arg_33_1 or is_device_active) then
		self._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if not self._input_index then
			selector_input_definition[self._input_index].on_exit(self)
		end

		selector_input_definition[arg_33_1].on_enter(self)
	end

	self._input_index = arg_33_1
end

StartGameWindowDeusTwitch._update_difficulty_option = function (self, arg_34_1)
	-- function 34
	if not arg_34_1 then
		local var_34_0 = DifficultySettings[arg_34_1]
		local difficulty_stepper = self._selection_widgets_by_name.difficulty_stepper

		difficulty_stepper.content.selected_difficulty_text = Localize(var_34_0.display_name)

		local display_image = var_34_0.display_image

		difficulty_stepper.content.difficulty_icon = display_image

		self:_set_info_window(arg_34_1)

		self._current_difficulty = arg_34_1
	end
end

StartGameWindowDeusTwitch._option_selected = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	local _parent = self._parent
	local get_twitch_settings = _parent:get_twitch_settings(self._mechanism_name)

	get_twitch_settings = get_twitch_settings or _parent:get_twitch_settings("adventure")

	if arg_35_1 == "difficulty_stepper" then
		local _current_difficulty = self._current_difficulty
		local difficulties = GameModeSettings.deus.difficulties
		local find = table.find(difficulties, _current_difficulty)
		local num = 0

		if arg_35_2 == "left_arrow" then
			if find - 1 >= 1 then
				num = find - 1

				self._parent:play_sound("hud_morris_start_menu_set")
			end
		elseif not (arg_35_2 ~= "right_arrow" or not (find + 1 <= #difficulties)) then
			num = find + 1

			self._parent:play_sound("hud_morris_start_menu_set")
		end

		self:_update_difficulty_option(difficulties[num])
	elseif arg_35_1 == "play_button" then
		self._play_button_pressed = true

		self._parent:set_difficulty_option(self._current_difficulty)
		self._parent:play(arg_35_3, get_twitch_settings.game_mode_type)
	else
		ferror("Unknown selector_input_definition: %s", arg_35_1)
	end
end

StartGameWindowDeusTwitch._set_input_description = function (self, arg_36_1)
	-- function 36
	if not self._is_server then
		if not arg_36_1 then
			local flag

			flag = not self._dlc_locked and "deus_twitch_buy_connected" and "deus_default_twitch_connected"

			self._parent:change_generic_actions(flag)
		else
			local flag_2

			flag_2 = not self._dlc_locked and "deus_twitch_buy" and "deus_default_twitch"

			self._parent:change_generic_actions(flag_2)
		end
	elseif not arg_36_1 then
		self._parent:change_generic_actions("deus_default_twitch_client_connected")
	else
		self._parent:change_generic_actions("deus_default_twitch_client")
	end

	self._input_description_connected = arg_36_1
end

StartGameWindowDeusTwitch._update_can_play = function (self, arg_37_1, arg_37_2)
	-- function 37
	if not self._is_server then
		local _can_play = self:_can_play()

		if self._previous_can_play ~= _can_play then
			self._previous_can_play = _can_play
			self._selection_widgets_by_name.play_button.content.button_hotspot.disable_button = not _can_play

			if not _can_play then
				self._parent:set_input_description("play_available")
			else
				self._parent:set_input_description(nil)
			end
		end
	end
end

StartGameWindowDeusTwitch._can_play = function (self)
	-- function 38
	if not self._is_server then
		return false
	end

	local get_selected_level_id = self._parent:get_selected_level_id()
	local twitch = Managers.twitch

	twitch = not twitch and Managers.twitch:is_connected()

	return (get_selected_level_id == nil or not twitch) and not self._dlc_locked
end

StartGameWindowDeusTwitch.on_exit = function (self, arg_39_1)
	-- function 39
	print("[StartGameViewWindow] Exit Substate StartGameWindowTwitchOverviewConsole")

	self._ui_animator = nil

	if not self._play_button_pressed then
		arg_39_1.input_index = nil
	else
		arg_39_1.input_index = self._input_index
	end

	self._parent:set_difficulty_option(self._current_difficulty)
	self:_set_active(false)
	Managers.state.event:unregister("_update_additional_curse_frame", self)
end

StartGameWindowDeusTwitch._set_info_window = function (self, arg_40_1)
	-- function 40
	local var_40_0 = DifficultySettings[arg_40_1]
	local description = var_40_0.description
	local max_chest_power_level = var_40_0.max_chest_power_level
	local difficulty_info = self._widgets_by_name.difficulty_info

	difficulty_info.content.difficulty_description = Localize(description)
	difficulty_info.content.highest_obtainable_level = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(max_chest_power_level)
end

StartGameWindowDeusTwitch._update_difficulty_lock = function (self)
	-- function 41
	local _current_difficulty = self._current_difficulty
	local difficulty_info = self._widgets_by_name.difficulty_info
	local upsell_button = self._widgets_by_name.upsell_button

	if not _current_difficulty then
		local is_difficulty_approved, var_41_4, var_41_5, var_41_6 = self._parent:is_difficulty_approved(_current_difficulty)

		if not is_difficulty_approved then
			if not var_41_4 then
				difficulty_info.content.should_show_diff_lock_text = true

				local content = difficulty_info.content
				local var_41_8

				if not var_41_4 then
					var_41_8 = Localize(var_41_4)

					if not var_41_8 then
						-- Nothing
					end
				end

				var_41_8 = ""

				::label_41_0::

				content.difficulty_lock_text = var_41_8
			else
				difficulty_info.content.should_show_diff_lock_text = false
			end

			if not var_41_5 then
				difficulty_info.content.should_show_dlc_lock = true
				self._dlc_locked = var_41_5
				self._dlc_name = var_41_5
				upsell_button.content.visible = true
			else
				difficulty_info.content.should_show_dlc_lock = false
				upsell_button.content.visible = false
				self._dlc_locked = nil
				self._dlc_name = nil
			end
		else
			difficulty_info.content.should_show_dlc_lock = false
			difficulty_info.content.should_show_diff_lock_text = false
			difficulty_info.content.should_resize = false
			upsell_button.content.visible = false
			self._dlc_locked = nil
			self._dlc_name = nil
		end

		self._difficulty_approved = is_difficulty_approved
	else
		difficulty_info.content.should_show_dlc_lock = false
		upsell_button.content.visible = false
	end

	local _calculate_difficulty_info_widget_size = self:_calculate_difficulty_info_widget_size(difficulty_info)
	local num = (math.floor(_calculate_difficulty_info_widget_size) - scenegraph_definition.difficulty_info.size[2]) / 2

	self:_resize_difficulty_info({
		math.floor(scenegraph_definition.difficulty_info.size[1]),
		math.floor(_calculate_difficulty_info_widget_size)
	}, {
		0,
		-num,
		1
	})

	upsell_button.offset[2] = -math.floor(_calculate_difficulty_info_widget_size) / 2 + 24
end

StartGameWindowDeusTwitch._calculate_difficulty_info_widget_size = function (self, arg_42_1)
	-- function 42
	local num = 20
	local difficulty_description = arg_42_1.style.difficulty_description
	local difficulty_description_2 = arg_42_1.content.difficulty_description
	local get_text_height = UIUtils.get_text_height(self._ui_renderer, difficulty_description.size, difficulty_description, difficulty_description_2)

	arg_42_1.content.difficulty_description_text_size = get_text_height

	local highest_obtainable_level = arg_42_1.style.highest_obtainable_level
	local highest_obtainable_level_2 = arg_42_1.content.highest_obtainable_level
	local num_2 = UIUtils.get_text_height(self._ui_renderer, highest_obtainable_level.size, highest_obtainable_level, highest_obtainable_level_2) + num
	local difficulty_lock_text = arg_42_1.style.difficulty_lock_text
	local difficulty_lock_text_2 = arg_42_1.content.difficulty_lock_text
	local num_3 = 0

	if not arg_42_1.content.should_show_diff_lock_text then
		num_3 = UIUtils.get_text_height(self._ui_renderer, difficulty_lock_text.size, difficulty_lock_text, difficulty_lock_text_2) + num
		arg_42_1.content.difficulty_lock_text_height = num_3
	end

	local dlc_lock_text = arg_42_1.style.dlc_lock_text
	local dlc_lock_text_2 = arg_42_1.content.dlc_lock_text
	local num_4 = 0

	if not arg_42_1.content.should_show_dlc_lock then
		num_4 = UIUtils.get_text_height(self._ui_renderer, dlc_lock_text.size, dlc_lock_text, dlc_lock_text_2) + num
	end

	return num_2 + get_text_height + num_3 + num_4 + 50
end

StartGameWindowDeusTwitch._resize_difficulty_info = function (self, arg_43_1, arg_43_2)
	-- function 43
	local difficulty_info = self._widgets_by_name.difficulty_info

	difficulty_info.content.should_resize = true
	difficulty_info.content.resize_size = arg_43_1
	difficulty_info.content.resize_offset = arg_43_2
	difficulty_info.style.widget_hotspot.size = arg_43_1
	difficulty_info.style.widget_hotspot.offset = arg_43_2
end

StartGameWindowDeusTwitch._update_gamemode_info_text = function (self, arg_44_1)
	-- function 44
	local twitch_gamemode_info_box = self._widgets_by_name.twitch_gamemode_info_box

	if not (not arg_44_1:get("trigger_cycle_next") and twitch_gamemode_info_box.content.is_showing_info) then
		self._ui_animator:start_animation("gamemode_text_swap", twitch_gamemode_info_box, scenegraph_definition)

		twitch_gamemode_info_box.content.is_showing_info = true
	elseif not arg_44_1:get("trigger_cycle_next") and not twitch_gamemode_info_box.content.is_showing_info then
		self._ui_animator:start_animation("gamemode_text_swap", twitch_gamemode_info_box, scenegraph_definition)

		twitch_gamemode_info_box.content.is_showing_info = false
	end

	if not UIUtils.is_button_pressed(twitch_gamemode_info_box, "info_hotspot") then
		if not twitch_gamemode_info_box.content.is_showing_info then
			self._ui_animator:start_animation("gamemode_text_swap", twitch_gamemode_info_box, scenegraph_definition)

			twitch_gamemode_info_box.content.is_showing_info = true
		else
			self._ui_animator:start_animation("gamemode_text_swap", twitch_gamemode_info_box, scenegraph_definition)

			twitch_gamemode_info_box.content.is_showing_info = false
		end
	end
end

StartGameWindowDeusTwitch._update_additional_curse_frame = function (self, arg_45_1)
	-- function 45
	for i, v in ipairs(self._expedition_widgets) do
		local content = v.content
		local flag

		flag = not (content.journey_name == arg_45_1) and "morris_expedition_select_border_belakor" and "morris_expedition_select_border"
		content.level_icon_frame = flag
	end
end
