-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_custom_game_settings.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_custom_game_settings_definitions")
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition

StartGameWindowVersusCustomGameSettings = class(StartGameWindowVersusCustomGameSettings)
StartGameWindowVersusCustomGameSettings.NAME = "StartGameWindowVersusCustomGameSettings"

local tbl = {
	default = UIWidgets.create_settings_stepper_widget,
	stepper = UIWidgets.create_settings_stepper_widget,
	slider = UIWidgets.create_settings_slider_widget
}
local tbl_2 = {
	default = 36,
	slider = 36,
	stepper = 36
}

StartGameWindowVersusCustomGameSettings.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("Entered Substate StartGameWindowVersusCustomGameSettings")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._matchmaking_manager = ingame_ui_context.matchmaking_manager
	self._peer_id = ingame_ui_context.peer_id
	self._is_server = ingame_ui_context.is_server

	local game_mechanism = Managers.mechanism:game_mechanism()
	local flag = not game_mechanism and game_mechanism:get_custom_game_settings_handler()

	self._settings_templates = not flag and flag:get_settings_template()
	self._custom_game_settings_handler = flag
	self._game_mechanism = game_mechanism
	self._selected_setting_index = nil
	self._input_focused = false
	self._is_loading = true

	local custom_settings_enabled

	if not game_mechanism then
		custom_settings_enabled = game_mechanism:custom_settings_enabled()

		if not custom_settings_enabled then
			-- Nothing
		end
	end

	custom_settings_enabled = false

	::label_1_0::

	self._custom_settings_toggled = custom_settings_enabled

	self:_create_ui_elements()
	Managers.state.event:register(self, "event_focus_custom_game_settings_input", "focus_custom_game_settings_input")
	Managers.state.event:register(self, "event_reset_host_settings", "_reset_host_settings")
end

StartGameWindowVersusCustomGameSettings._create_ui_elements = function (self)
	-- function 2
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local widget_definitions = var_0_0.widget_definitions

	UIUtils.create_widgets(widget_definitions, tbl, tbl_2)

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	self._animations = {}
	self._ui_animations = {}
end

StartGameWindowVersusCustomGameSettings._populate_settings = function (self)
	-- function 3
	local _is_server = self._is_server

	_is_server = not _is_server and self._game_mechanism:is_hosting_versus_custom_game()

	local get_settings = self._custom_game_settings_handler:get_settings()
	local _settings_templates = self._settings_templates
	local custom_game_ui_settings = DLCSettings.carousel.custom_game_ui_settings
	local tbl_3 = {}
	local tbl_4 = {}
	local num = 0

	for i, v in ipairs(get_settings) do
		local var_3_7 = _settings_templates[i]
		local setting_name = var_3_7.setting_name
		local values = var_3_7.values
		local var_3_10 = custom_game_ui_settings[setting_name]
		local widget_type

		if not var_3_10 then
			widget_type = var_3_10.widget_type

			if not widget_type then
				-- Nothing
			end
		end

		widget_type = "default"

		::label_3_0::

		local var_3_12 = tbl_2[widget_type]
		local var_3_13 = var_3_7.values_reverse_lookup[v]
		local default = var_3_7.default
		local var_3_15 = var_3_7.values_reverse_lookup[default]
		local var_3_16 = callback(self, "on_setting_changed_cb")
		local var_3_17 = tbl[widget_type]("settings_anchor", var_3_7, var_3_10, v, var_3_13, i, var_3_16)
		local var_3_18 = UIWidget.init(var_3_17)

		num = num + var_3_12
		var_3_18.offset = {
			20,
			-num,
			1
		}
		var_3_18.content.is_server = _is_server
		var_3_18.content.default_value = default
		var_3_18.content.default_idx = var_3_15
		var_3_18.content.widget_type = widget_type
		tbl_3[#tbl_3 + 1] = var_3_18
		tbl_4[setting_name] = var_3_18
	end

	self._settings_widgets = tbl_3
	self._settings_widgets_by_name = tbl_4
	self._num_settings = #get_settings, self:_setup_scrollbar(num)
	self._settings = get_settings
end

StartGameWindowVersusCustomGameSettings.on_exit = function (self, arg_4_1)
	-- function 4
	print("Exited Substate StartGameWindowVersusCustomGameSettings")

	self._ui_animator = nil

	Managers.state.event:unregister("event_focus_custom_game_settings_input", self)
	Managers.state.event:unregister("event_reset_host_settings", self)
end

StartGameWindowVersusCustomGameSettings.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._ui_animator:update(arg_5_1)
	self:_update_animations(arg_5_1)
	self:_draw(arg_5_1, arg_5_2)

	local get_match_owner = Managers.mechanism:network_handler():get_match_handler():get_match_owner()

	self._is_loading = not Managers.mechanism:mechanism_try_call("get_all_reservation_handlers_by_owner", get_match_owner) and not Managers.matchmaking:is_in_versus_custom_game_lobby()
end

StartGameWindowVersusCustomGameSettings._update_animations = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _animations = self._animations
	local _ui_animator = self._ui_animator
	local _ui_animations = self._ui_animations

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	if self._ui_animations.move_up or not self._ui_animations.move_down then
		self._scrollbar_ui:force_update_progress(2)
	end
end

StartGameWindowVersusCustomGameSettings.post_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not self._settings_initialized then
		self._settings_initialized = true

		self:_populate_settings()
	end

	if not (not self._settings_initialized and self._game_mechanism:is_hosting_versus_custom_game()) then
		self:_client_sync_settings()
	end

	if not self._settings_is_dirty then
		self:_update_lobby_data(arg_7_1, arg_7_2)
	end

	local is_device_active = Managers.input:is_device_active("gamepad")

	if not is_device_active and not self._input_focused then
		self:_handle_gamepad_input(arg_7_1, arg_7_2)
	else
		self:_handle_input(arg_7_1, arg_7_2)
	end

	self:_update_focus_overlay(arg_7_1, arg_7_2, is_device_active)
end

StartGameWindowVersusCustomGameSettings._update_lobby_data = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._custom_settings_toggled then
		local get_packed_custom_settings = self._custom_game_settings_handler:get_packed_custom_settings()

		Managers.matchmaking:set_versus_custom_lobby_data(get_packed_custom_settings)
	else
		Managers.matchmaking:set_versus_custom_lobby_data("n/a")
	end

	self._settings_is_dirty = false
end

StartGameWindowVersusCustomGameSettings._draw = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_9_1, nil, _render_settings)

	if not self._is_loading then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)

		if not self._settings_widgets then
			UIRenderer.draw_all_widgets(_ui_top_renderer, self._settings_widgets)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if self._is_loading or not self._scrollbar_ui then
		self._scrollbar_ui:update(arg_9_1, arg_9_2, _ui_top_renderer, window_input_service, _render_settings)
	end
end

StartGameWindowVersusCustomGameSettings.on_setting_changed_cb = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._is_server and not self._game_mechanism:is_hosting_versus_custom_game() then
		local var_10_0 = self._settings_templates[arg_10_1]
		local var_10_1 = var_10_0.values[arg_10_2]
		local setting_name = var_10_0.setting_name

		self._custom_game_settings_handler:server_set_setting(setting_name, var_10_1)

		self._settings_is_dirty = true
	end
end

StartGameWindowVersusCustomGameSettings._client_sync_settings = function (self)
	-- function 11
	local get_settings = self._custom_game_settings_handler:get_settings()
	local _settings_templates = self._settings_templates

	for i = 1, #get_settings do
		local var_11_2 = _settings_templates[i]
		local var_11_3 = self._settings_widgets_by_name[var_11_2.setting_name]
		local setting_idx = var_11_3.content.setting_idx
		local var_11_5 = get_settings[i]
		local var_11_6 = var_11_2.values_reverse_lookup[var_11_5]
		local content = var_11_3.content

		if setting_idx ~= var_11_6 then
			content.setting_idx = var_11_6

			if content.widget_type == "slider" then
				content.current_slider_value = math.clamp(var_11_6 / content.num_settings, 0, 1)
			end
		end
	end
end

StartGameWindowVersusCustomGameSettings._setup_scrollbar = function (self, arg_12_1)
	-- function 12
	local num = arg_12_1 - var_0_0.scenegraph_definition.container.size[2]

	if num > 0 then
		local _ui_scenegraph = self._ui_scenegraph
		local str = "settings_anchor"
		local str_2 = "container"
		local flag = false
		local var_12_5
		local var_12_6

		self._scrollbar_ui = ScrollbarUI:new(_ui_scenegraph, str, str_2, num, flag, var_12_5, var_12_6)
	end
end

StartGameWindowVersusCustomGameSettings.focus_custom_game_settings_input = function (self, arg_13_1)
	-- function 13
	self._input_focused = arg_13_1

	self._parent:pause_input(arg_13_1)
	self._parent:set_input_description("versus_player_hosted_lobby_custom_settings")

	self._custom_settings_toggled = arg_13_1
	self._settings_is_dirty = true
end

StartGameWindowVersusCustomGameSettings._reset_host_settings = function (self, arg_14_1)
	-- function 14
	if not arg_14_1 then
		local get_settings = self._custom_game_settings_handler:get_settings()
		local _settings_templates = self._settings_templates

		for i = 1, #get_settings do
			local var_14_2 = _settings_templates[i]
			local var_14_3 = self._settings_widgets_by_name[var_14_2.setting_name]
			local default = var_14_2.default
			local var_14_5 = var_14_2.values_reverse_lookup[default]
			local content = var_14_3.content

			content.setting_idx = var_14_5

			if content.widget_type == "slider" then
				content.current_slider_value = math.clamp(var_14_5 / content.num_settings, 0, 1)
			end
		end
	end
end

local function fn(self, arg_15_1)
	-- function 15
	local num = 0
	local num_2 = 0

	for i = 1, arg_15_1 do
		local widget_type = self[i].content.widget_type

		num = num + tbl_2[widget_type]

		if num > 350 then
			num_2 = num_2 + tbl_2[widget_type]
		end
	end

	return num_2
end

StartGameWindowVersusCustomGameSettings._handle_gamepad_input = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not self._settings_widgets then
		return
	end

	local window_input_service = self._parent:window_input_service()
	local _selected_setting_index = self._selected_setting_index

	_selected_setting_index = _selected_setting_index or 1

	local _settings_widgets = self._settings_widgets

	if not window_input_service:get("move_up") then
		if _selected_setting_index - 1 >= 1 then
			_selected_setting_index = _selected_setting_index - 1
		else
			_selected_setting_index = #_settings_widgets
		end

		local var_16_3 = _settings_widgets[1]

		if self._ui_scenegraph.settings_anchor.local_position[2] > 0 then
			local var_16_4 = fn(_settings_widgets, _selected_setting_index)

			self._ui_animations.move_down = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.settings_anchor.local_position, 2, self._ui_scenegraph.settings_anchor.local_position[2], var_16_4, 0.5, math.easeOutCubic)
		end
	elseif not window_input_service:get("move_down") then
		if _selected_setting_index + 1 <= #_settings_widgets then
			_selected_setting_index = _selected_setting_index + 1
		else
			_selected_setting_index = 1
		end

		local var_16_5 = _settings_widgets[_selected_setting_index]

		if math.abs(var_16_5.offset[2]) > 380 then
			local var_16_6 = fn(_settings_widgets, _selected_setting_index)

			self._ui_animations.move_up = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.settings_anchor.local_position, 2, self._ui_scenegraph.settings_anchor.local_position[2], var_16_6, 0.5, math.easeOutCubic)
		end
	end

	if _selected_setting_index ~= self._selected_setting_index then
		self._selected_setting_index = _selected_setting_index

		for i = 1, #_settings_widgets do
			_settings_widgets[i].content.is_selected = _selected_setting_index == i
		end
	end

	if not self._is_server and not self._game_mechanism:is_hosting_versus_custom_game() then
		local var_16_7 = _settings_widgets[_selected_setting_index]
		local content = var_16_7.content
		local input_cooldown_multiplier = content.input_cooldown_multiplier
		local flag = false
		local flag_2 = false

		if not content.input_cooldown then
			flag = true

			local input_cooldown = content.input_cooldown
			local max = math.max(input_cooldown - arg_16_1, 0)

			content.input_cooldown = not (max > 0) or not max or nil
		end

		if not (not var_16_7 and content.input_cooldown) then
			if window_input_service:get("move_left") or content.widget_type ~= "slider" or not window_input_service:get("move_left_hold") then
				local num = content.setting_idx - 1

				if num < 1 then
					num = content.widget_type ~= "slider" or not 1 or content.num_settings
				end

				content.setting_idx = num

				if content.widget_type == "slider" then
					local num_2 = 1 / content.num_settings
					local num_3 = content.current_slider_value - num_2

					content.current_slider_value = math.clamp(num_3, 0, 1)
				end

				content.on_setting_changed_cb(content.id, num)

				flag_2 = true
			elseif window_input_service:get("move_right") or content.widget_type ~= "slider" or not window_input_service:get("move_right_hold") then
				local num_4 = content.setting_idx + 1

				if num_4 > content.num_settings then
					num_4 = content.widget_type ~= "slider" or not content.num_settings or 1
				end

				content.setting_idx = num_4

				if content.widget_type == "slider" then
					local num_5 = 1 / content.num_settings
					local num_6 = content.current_slider_value + num_5

					content.current_slider_value = math.clamp(num_6, 0, 1)
				end

				content.on_setting_changed_cb(content.id, num_4)

				flag_2 = true
			elseif not window_input_service:get("special_1") then
				local default_idx = content.default_idx

				content.setting_idx = default_idx
				content.current_slider_value = math.clamp(default_idx / content.num_settings, 0, 1)

				content.on_setting_changed_cb(content.id, default_idx)

				flag_2 = true
			end
		end

		if not var_16_7 and not flag_2 then
			if not flag then
				local max_2 = math.max(input_cooldown_multiplier - 0.1, 0.1)

				content.input_cooldown = 0.2 * math.ease_in_exp(max_2)
				content.input_cooldown_multiplier = max_2
			else
				local num_7 = 1

				content.input_cooldown = 0.2 * math.ease_in_exp(num_7)
				content.input_cooldown_multiplier = num_7
			end
		end
	end

	if not window_input_service:get("back") then
		Managers.state.event:trigger("event_focus_versus_hosted_lobby_input")
		self._parent:pause_input(false)

		self._input_focused = false
		self._custom_settings_toggled = false
	end
end

StartGameWindowVersusCustomGameSettings._handle_input = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not self._settings_widgets then
		return
	end

	local _settings_widgets = self._settings_widgets

	for i = 1, #_settings_widgets do
		local var_17_1 = _settings_widgets[i]
		local content = var_17_1.content
		local widget_type = content.widget_type
		local _is_list_hovered = self:_is_list_hovered()

		content.can_hover = _is_list_hovered

		if not (widget_type == "stepper" or widget_type ~= "default") then
			if not _is_list_hovered then
				if not UIUtils.is_button_pressed(var_17_1, "left_arrow_hotspot") then
					local num = content.setting_idx - 1

					if num < 1 then
						num = content.num_settings
					end

					content.setting_idx = num

					content.on_setting_changed_cb(content.id, num)
				elseif not UIUtils.is_button_pressed(var_17_1, "right_arrow_hotspot") then
					local num_2 = content.setting_idx + 1

					if num_2 > content.num_settings then
						num_2 = 1
					end

					content.setting_idx = num_2

					content.on_setting_changed_cb(content.id, num_2)
				elseif not UIUtils.is_button_pressed(var_17_1, "reset_setting_button_hotspot") then
					local default_idx = content.default_idx

					content.setting_idx = default_idx

					content.on_setting_changed_cb(content.id, default_idx)
				end
			end
		elseif (widget_type ~= "slider" or not _is_list_hovered) and not UIUtils.is_button_pressed(var_17_1, "reset_setting_button_hotspot") then
			local default_idx_2 = content.default_idx

			content.setting_idx = default_idx_2
			content.current_slider_value = default_idx_2 / content.num_settings

			content.on_setting_changed_cb(content.id, default_idx_2)
		end
	end

	local window_input_service = self._parent:window_input_service()

	if not self._custom_settings_toggled and not window_input_service:get("toggle_menu", true) then
		self._parent:close_menu()
	end
end

StartGameWindowVersusCustomGameSettings._is_list_hovered = function (self)
	-- function 18
	return self._widgets_by_name.mask.content.hotspot.is_hover
end

StartGameWindowVersusCustomGameSettings._update_focus_overlay = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not self._settings_widgets then
		return
	end

	local _settings_widgets = self._settings_widgets

	for i = 1, #_settings_widgets do
		local content = _settings_widgets[i].content
		local _custom_settings_toggled = self._custom_settings_toggled

		_custom_settings_toggled = _custom_settings_toggled or self._input_focused
		content.focused = _custom_settings_toggled

		local fade_progress = content.fade_progress

		fade_progress = fade_progress or 0

		local num = 25

		if not _custom_settings_toggled then
			fade_progress = math.min(fade_progress + arg_19_1 * num, 1)
		else
			fade_progress = math.max(fade_progress - arg_19_1 * num, 0)
		end

		content.fade_progress = fade_progress
	end
end
