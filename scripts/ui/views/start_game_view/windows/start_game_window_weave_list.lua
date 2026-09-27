-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_list.lua

local var_0_0
local var_0_1
local var_0_2
local var_0_3
local var_0_4
local var_0_5
local var_0_6
local var_0_7
local flag = true

StartGameWindowWeaveList = class(StartGameWindowWeaveList)
StartGameWindowWeaveList.NAME = "StartGameWindowWeaveList"

StartGameWindowWeaveList.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveList")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._is_server = ingame_ui_context.is_server
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._current_index = 0
	self._hold_down_timer = 0
	self._hold_up_timer = 0
	self._current_scroll_value = 0
	self._wanted_scrollbar_value = 0
	self._start_index = 0
	self._play_button_pressed = false
	self._animations = {}

	self:_setup_definitions(arg_1_1)
	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_populate_list()

	local flag = true

	self:_on_weave_widget_pressed(self._next_weave_widget, flag)
	Managers.state.event:trigger("weave_list_entered")
	self:_start_transition_animation("on_enter")
	self._parent:change_generic_actions("default_weave")
end

StartGameWindowWeaveList._setup_definitions = function (arg_2_0, arg_2_1)
	-- function 2
	local use_gamepad_layout = arg_2_1.use_gamepad_layout

	use_gamepad_layout = use_gamepad_layout or not IS_WINDOWS

	if not use_gamepad_layout then
		var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_list_console_definitions")
	else
		var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_list_definitions")
	end

	var_0_1 = var_0_0.widgets
	var_0_2 = var_0_0.scenegraph_definition
	var_0_3 = var_0_0.animation_definitions
	var_0_4 = var_0_0.create_weave_entry_func
	var_0_5 = var_0_0.entry_size
	var_0_6 = var_0_0.entry_spacing
	var_0_7 = var_0_0.num_visible_weave_entries
end

StartGameWindowWeaveList._start_transition_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		render_settings = self._render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_3_1, _widgets_by_name, var_0_2, tbl)

	self._animations[arg_3_1] = start_animation
end

StartGameWindowWeaveList._create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	flag = false
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_2
		tbl_2[k] = var_4_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._weave_entry_widgets = {}
	self._weave_entry_widgets_by_name = {}

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_animator = UIAnimator:new(self.ui_scenegraph, var_0_3)
end

StartGameWindowWeaveList.on_exit = function (self, arg_5_1)
	-- function 5
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveList")

	self._ui_animator = nil
	self._params.selected_weave_template = nil
end

StartGameWindowWeaveList.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		self:_setup_definitions(self._params)
		self:_create_ui_elements()
	end

	self:_update_can_play(arg_6_1, arg_6_2)
	self:_update_animations(arg_6_1)

	if not self._play_button_pressed then
		self:_handle_input(arg_6_1, arg_6_2)
		self:_handle_gamepad_input(arg_6_1, arg_6_2)
	end

	self:_draw(arg_6_1)
end

StartGameWindowWeaveList._can_play = function (self)
	-- function 7
	if not (self._selected_weave_name ~= nil) then
		return false
	end

	local var_7_0 = self._weave_entry_widgets[self._current_index]

	return not var_7_0 and not var_7_0.content.locked
end

StartGameWindowWeaveList._can_set_next_weave = function (self)
	-- function 8
	local weave_template_name = self._next_weave_widget.content.weave_template_name

	return self._selected_weave_name ~= weave_template_name
end

StartGameWindowWeaveList._update_can_play = function (self)
	-- function 9
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local _can_play = self:_can_play()
	local _can_set_next_weave = self:_can_set_next_weave()

	if not (self._previous_can_play ~= _can_play or self._previous_set_next_weave ~= _can_set_next_weave or is_game_matchmaking == self._was_matchmaking) then
		self._previous_can_play = _can_play
		self._previous_set_next_weave = _can_set_next_weave
		self._was_matchmaking = is_game_matchmaking

		if not is_game_matchmaking then
			if not self._is_server then
				if not _can_set_next_weave then
					self._parent:set_input_description("cancel_available_set_next_weave_available_lock")
				else
					self._parent:set_input_description("cancel_matchmaking_lock")
				end
			elseif not _can_set_next_weave then
				self._parent:set_input_description("set_next_weave_available_lock")
			else
				self._parent:set_input_description(nil)
			end
		elseif not _can_play then
			if not _can_set_next_weave then
				self._parent:set_input_description("play_available_set_next_weave_available_lock")
			else
				self._parent:set_input_description("play_available_lock")
			end
		elseif not _can_set_next_weave then
			self._parent:set_input_description("set_next_weave_available_lock")
		else
			self._parent:set_input_description(nil)
		end
	end
end

StartGameWindowWeaveList.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

StartGameWindowWeaveList._update_animations = function (self, arg_11_1)
	-- function 11
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_11_1)

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartGameWindowWeaveList._on_list_index_selected = function (self, arg_12_1)
	-- function 12
	local _weave_entry_widgets = self._weave_entry_widgets
	local var_12_1 = _weave_entry_widgets[arg_12_1]

	if not var_12_1 then
		return
	end

	local template_id = var_12_1.content.template_id

	for i, v in ipairs(_weave_entry_widgets) do
		local button_hotspot = v.content.button_hotspot
		local flag = i == arg_12_1

		if not button_hotspot then
			button_hotspot.is_selected = flag
			button_hotspot.has_focus = flag
		end
	end

	if not _weave_entry_widgets[arg_12_1] then
		local content = self._next_weave_widget.content

		content.button_hotspot.is_selected = false
		content.button_hotspot.has_focus = false
	end

	local var_12_6 = WeaveSettings.templates_ordered[template_id]

	self._params.selected_weave_template = var_12_6
	self._current_index = arg_12_1

	local name = var_12_6.name

	self._selected_weave_name = name

	self._parent:set_selected_weave_id(name)
	self._parent:set_selected_weave_objective_index(1)
	self:_play_sound("menu_wind_level_select")
end

StartGameWindowWeaveList._handle_gamepad_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local count = #self._weave_entry_widgets
	local window_input_service = self._parent:window_input_service()
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()

	if not window_input_service:get("move_up_hold") then
		self._hold_up_timer = self._hold_up_timer + arg_13_1
		self._hold_down_timer = 0
	elseif not window_input_service:get("move_down_hold") then
		self._hold_down_timer = self._hold_down_timer + arg_13_1
		self._hold_up_timer = 0
	else
		self._hold_up_timer = 0
		self._hold_down_timer = 0
	end

	if not (window_input_service:get("move_up") or not (self._hold_up_timer > 0.5)) then
		if self._hold_up_timer > 0.5 then
			self._hold_up_timer = 0.45
		end

		local _current_index = self._current_index
		local num = _current_index - 1

		if num < 1 then
			num = count
		end

		if num ~= _current_index then
			self:_on_list_index_selected(num)
		end
	elseif not (window_input_service:get("move_down") or not (self._hold_down_timer > 0.5)) then
		if self._hold_down_timer > 0.5 then
			self._hold_down_timer = 0.45
		end

		local templates_ordered = WeaveSettings.templates_ordered
		local _current_index_2 = self._current_index
		local num_2 = 1 + _current_index_2 % count

		if num_2 ~= _current_index_2 then
			self:_on_list_index_selected(num_2)
		end
	else
		if not is_game_matchmaking then
			if not self._is_server and window_input_service:get("refresh_press") and not window_input_service:get("skip_pressed") then
				self._parent:play_sound("Play_hud_hover")
				Managers.matchmaking:cancel_matchmaking()
			end
		elseif not self:_can_play() and window_input_service:get("refresh_press") and not window_input_service:get("skip_pressed") then
			self._play_button_pressed = true

			local flag = true

			self._parent:play(arg_13_2, "weave", flag)
		end

		if not window_input_service:get("special_1") then
			self._current_index = 0
			self._hold_down_timer = 0
			self._hold_up_timer = 0
			self._current_scroll_value = 0
			self._wanted_scrollbar_value = 0
			self._start_index = 0

			self:_on_weave_widget_pressed(self._next_weave_widget)
		elseif not window_input_service:get("trigger_cycle_next") then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.ranked_weave_desc)
		end
	end

	self:_handle_gamepad_scrollbar(arg_13_1, arg_13_2)
	self:_animate_list_entries(false, arg_13_1)
end

StartGameWindowWeaveList._handle_gamepad_scrollbar = function (self, arg_14_1, arg_14_2)
	-- function 14
	local count = #self._weave_entry_widgets

	if count <= var_0_7 then
		return
	end

	local _start_index = self._start_index
	local num = 1 / (count - var_0_7 + 1)
	local _current_index = self._current_index
	local num_2 = self._current_index - (_start_index - 1)

	if num_2 > var_0_7 - 3 then
		local num_3 = num_2 - (var_0_7 - 3)

		self._start_index = math.min(_start_index + num_3, count - var_0_7 + 3)
		self._current_scroll_value = self._wanted_scrollbar_value
		self._wanted_scrollbar_value = math.min(self._wanted_scrollbar_value + num * num_3, 1)
	elseif self._current_index < _start_index + 2 then
		local num_4 = _start_index + 2 - self._current_index

		self._start_index = math.max(_start_index - num_4, 1)
		self._current_scroll_value = self._wanted_scrollbar_value
		self._wanted_scrollbar_value = math.max(self._wanted_scrollbar_value - num * num_4, 0)
	end

	self._current_scroll_value = math.lerp(self._current_scroll_value, self._wanted_scrollbar_value, arg_14_1 * 7)

	self:_set_scrollbar_value(self._current_scroll_value)
end

StartGameWindowWeaveList._handle_input = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not Managers.input:is_device_active("gamepad") then
		return
	end

	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = self._parent:window_input_service()
	local _is_list_hovered = self:_is_list_hovered()

	if not self:_next_weave_widget_hover_enter() then
		self:_play_sound("play_gui_lobby_button_02_mission_act_hover")
	end

	local _next_weave_widget_pressed = self:_next_weave_widget_pressed()

	if not _next_weave_widget_pressed then
		self:_on_weave_widget_pressed(_next_weave_widget_pressed)
		self:_play_sound("play_gui_lobby_button_02_mission_select")
	elseif not _is_list_hovered then
		if not self:_weave_widget_hover_enter() then
			self:_play_sound("play_gui_lobby_button_02_mission_act_hover")
		end

		local _weave_widget_pressed = self:_weave_widget_pressed()

		if not _weave_widget_pressed then
			self:_on_weave_widget_pressed(_weave_widget_pressed)
			self:_play_sound("play_gui_lobby_button_02_mission_select")
		end
	end

	self:_update_mouse_scroll_input()
	self:_animate_list_entries(_is_list_hovered, arg_15_1)
end

StartGameWindowWeaveList._is_list_hovered = function (self)
	-- function 16
	return self._widgets_by_name.list_hotspot.content.hotspot.is_hover == true
end

StartGameWindowWeaveList._on_weave_widget_pressed = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _weave_entry_widgets = self._weave_entry_widgets
	local var_17_1 = arg_17_1

	if not var_17_1.content.locked then
		return
	end

	local template_id = var_17_1.content.template_id

	for k, v in pairs(_weave_entry_widgets) do
		local content = v.content
		local button_hotspot = content.button_hotspot
		local flag = content.template_id ~= template_id or v == var_17_1

		if not button_hotspot then
			button_hotspot.is_selected = flag
			button_hotspot.has_focus = flag
		end
	end

	local content_2 = self._next_weave_widget.content

	content_2.button_hotspot.is_selected = arg_17_1 == self._next_weave_widget
	content_2.button_hotspot.has_focus = arg_17_1 == self._next_weave_widget

	local var_17_7 = WeaveSettings.templates_ordered[template_id]

	self._params.selected_weave_template = var_17_7

	local name = var_17_7.name

	self._selected_weave_name = name

	self._parent:set_selected_weave_id(name)
	self._parent:set_selected_weave_objective_index(1)

	if not arg_17_2 then
		self:_play_sound("menu_wind_level_select")
	end
end

StartGameWindowWeaveList._draw = function (self, arg_18_1)
	-- function 18
	local _ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 0

	UIRenderer.begin_pass(_ui_top_renderer, ui_scenegraph, window_input_service, arg_18_1, nil, _render_settings)

	for k, v in pairs(self._widgets_by_name) do
		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	local _calculate_first_widget_to_draw = self:_calculate_first_widget_to_draw()

	for k_2 = _calculate_first_widget_to_draw, _calculate_first_widget_to_draw + var_0_7 - 1 do
		local var_18_7 = self._weave_entry_widgets[k_2]

		if not var_18_7 then
			local alpha_multiplier_3 = var_18_7.alpha_multiplier

			alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_3

			UIRenderer.draw_widget(_ui_top_renderer, var_18_7)
		end
	end

	_render_settings.alpha_multiplier = alpha_multiplier

	UIRenderer.draw_widget(_ui_top_renderer, self._next_weave_widget)
	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowWeaveList._calculate_first_widget_to_draw = function (self)
	-- function 19
	local _total_scroll_height = self._total_scroll_height
	local count = #self._weave_entry_widgets
	local _scroll_value = self._scroll_value
	local num = count - var_0_7 + 2

	return (math.floor(math.lerp(1, num, _scroll_value)))
end

StartGameWindowWeaveList._play_sound = function (self, arg_20_1)
	-- function 20
	self._parent:play_sound(arg_20_1)
end

StartGameWindowWeaveList._populate_list = function (self)
	-- function 21
	local flag = false
	local list = self._widgets_by_name.list
	local templates_ordered = WeaveSettings.templates_ordered
	local count = #templates_ordered
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()
	local tbl = {}
	local num = 1
	local flag_2 = false

	for i = 1, count do
		local var_21_9 = templates_ordered[i]
		local weave_unlocked = LevelUnlockUtils.weave_unlocked(statistics_db, stats_id, var_21_9.name, flag)

		if not (weave_unlocked or num ~= i) then
			tbl[i] = true

			if not weave_unlocked and flag_2 and not LevelUnlockUtils.weave_disabled(var_21_9.name) then
				if not templates_ordered[i + 1] then
					num = i + 1
				end
			else
				flag_2 = true
			end
		end
	end

	for j = count, 1, -1 do
		if not (not tbl[j] and j == num) then
			local var_21_11 = templates_ordered[j]
			local var_21_12 = var_0_4(#self._weave_entry_widgets + 1, j, var_21_11, true)
			local var_21_13 = UIWidget.init(var_21_12)

			if not LevelUnlockUtils.weave_disabled(var_21_11.name) then
				var_21_13.content.locked = true
			end

			self._weave_entry_widgets[#self._weave_entry_widgets + 1] = var_21_13
			self._weave_entry_widgets_by_name[var_21_11.name] = var_21_13
		end
	end

	local var_21_14 = templates_ordered[num]
	local var_21_15 = var_0_4(1, num, var_21_14, false, "next_weave")
	local var_21_16 = UIWidget.init(var_21_15)

	if not LevelUnlockUtils.weave_disabled(var_21_14.name) then
		var_21_16.content.locked = true
	end

	self._next_weave_widget = var_21_16

	self:_setup_scrollbar()
end

StartGameWindowWeaveList._setup_scrollbar = function (self)
	-- function 22
	local count = #self._weave_entry_widgets

	self._total_scroll_height = count * var_0_5[2] + (count + 1) * var_0_6

	local list_scrollbar = self._widgets_by_name.list_scrollbar
	local scenegraph_id = list_scrollbar.scenegraph_id
	local var_22_3 = self.ui_scenegraph[scenegraph_id].size[2]
	local scroll_bar_info

	scroll_bar_info.bar_height_percentage, scroll_bar_info = math.min(var_22_3 / self._total_scroll_height, 1), list_scrollbar.content.scroll_bar_info

	self:_set_scrollbar_value(0)

	local size = var_0_2.list_window.size

	if self._total_scroll_height > size[2] then
		local num = count * var_0_5[2]
		local var_22_7 = var_0_5[2]

		scroll_bar_info.scroll_amount = math.max(var_22_7 / num, 0)
	else
		scroll_bar_info.scroll_amount = 0
	end
end

StartGameWindowWeaveList._next_weave_widget_pressed = function (self)
	-- function 23
	local button_hotspot = self._next_weave_widget.content.button_hotspot

	if not button_hotspot and not button_hotspot.on_release then
		button_hotspot.on_release = false

		return self._next_weave_widget
	end
end

StartGameWindowWeaveList._next_weave_widget_hover_enter = function (self)
	-- function 24
	local button_hotspot = self._next_weave_widget.content.button_hotspot

	if not button_hotspot and not button_hotspot.on_hover_enter then
		button_hotspot.on_hover_enter = false

		return self._next_weave_widget
	end
end

StartGameWindowWeaveList._weave_widget_pressed = function (self)
	-- function 25
	local _weave_entry_widgets = self._weave_entry_widgets

	for k, v in pairs(_weave_entry_widgets) do
		local content = v.content

		if not content then
			local button_hotspot = content.button_hotspot

			if not button_hotspot and not button_hotspot.on_release then
				button_hotspot.on_release = false

				return v
			end
		end
	end
end

StartGameWindowWeaveList._weave_widget_hover_enter = function (self)
	-- function 26
	local _weave_entry_widgets = self._weave_entry_widgets

	for k, v in pairs(_weave_entry_widgets) do
		local content = v.content

		if not content then
			local button_hotspot = content.button_hotspot

			if not button_hotspot and not button_hotspot.on_hover_enter then
				button_hotspot.on_hover_enter = false

				return v
			end
		end
	end
end

StartGameWindowWeaveList._update_mouse_scroll_input = function (self)
	-- function 27
	local scroll_bar_info = self._widgets_by_name.list_scrollbar.content.scroll_bar_info

	if not scroll_bar_info.on_pressed then
		scroll_bar_info.scroll_add = nil
	end

	local scroll_value = scroll_bar_info.scroll_value

	if not scroll_value then
		return
	end

	local value = scroll_bar_info.value
	local _scroll_value = self._scroll_value

	if _scroll_value ~= scroll_value then
		self:_set_scrollbar_value(scroll_value)
	elseif _scroll_value ~= value then
		self:_set_scrollbar_value(value)
	end
end

StartGameWindowWeaveList._set_scrollbar_value = function (self, arg_28_1)
	-- function 28
	local _scroll_value = self._scroll_value

	if not arg_28_1 then
		local scroll_bar_info = self._widgets_by_name.list_scrollbar.content.scroll_bar_info

		scroll_bar_info.value = arg_28_1
		scroll_bar_info.scroll_value = arg_28_1

		local local_position = self.ui_scenegraph.list_anchor.local_position
		local size = var_0_2.list_window.size

		local_position[2] = math.floor((self._total_scroll_height - size[2]) * arg_28_1)
		self._scroll_value = arg_28_1
	end
end

StartGameWindowWeaveList._animate_list_entries = function (self, arg_29_1, arg_29_2)
	-- function 29
	local _weave_entry_widgets = self._weave_entry_widgets

	for k, v in pairs(_weave_entry_widgets) do
		local content = v.content
		local style = v.style

		if not content then
			self:_animate_list_entry(content, style, arg_29_2, arg_29_1)
		end
	end

	local content_2 = self._next_weave_widget.content
	local style_2 = self._next_weave_widget.style

	self:_animate_list_entry(content_2, style_2, arg_29_2, true)
end

StartGameWindowWeaveList._animate_list_entry = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	local is_device_active = Managers.input:is_device_active("mouse")
	local button_hotspot = arg_30_1.button_hotspot

	button_hotspot = button_hotspot or arg_30_1.hotspot

	local flag = (button_hotspot.is_hover or not is_device_active) and button_hotspot.has_focus
	local is_selected = button_hotspot.is_selected
	local on_hover_enter = button_hotspot.on_hover_enter

	if not (not is_device_active and arg_30_4 == nil or arg_30_4) then
		flag = false

		local flag_2 = false
	end

	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_30_1

	::label_30_0::

	is_clicked = true

	::label_30_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 14
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_30_3 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_30_3 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not flag then
		hover_progress = math.min(hover_progress + arg_30_3 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_30_3 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_30_3 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_30_3 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * hover_progress
	local num_4 = 255 * max

	arg_30_2.hover_frame.color[1] = num_3
	arg_30_2.symbol_bg_glow.color[1] = 64 + 64 * max
	arg_30_2.wind_symbol.color[1] = 70 + 185 * max
	arg_30_2.background_effect.color[1] = 255 * selection_progress

	local num_5 = 20
	local symbol_frame_selected = arg_30_2.symbol_frame_selected
	local texture_size = symbol_frame_selected.texture_size
	local default_size = symbol_frame_selected.default_size
	local offset = symbol_frame_selected.offset
	local default_offset = symbol_frame_selected.default_offset

	texture_size[1] = default_size[1] - num_5 + num_5 * selection_progress
	texture_size[2] = default_size[2] - num_5 + num_5 * selection_progress
	offset[1] = default_offset[1] + num_5 / 2 - num_5 / 2 * selection_progress

	local symbol_frame_selected_glow = arg_30_2.symbol_frame_selected_glow
	local texture_size_2 = symbol_frame_selected_glow.texture_size
	local default_size_2 = symbol_frame_selected_glow.default_size
	local offset_2 = symbol_frame_selected_glow.offset
	local default_offset_2 = symbol_frame_selected_glow.default_offset
	local num_6 = 20

	texture_size_2[1] = default_size_2[1] - num_6 + num_6 * selection_progress
	texture_size_2[2] = default_size_2[2] - num_6 + num_6 * selection_progress
	offset_2[1] = default_offset_2[1] + num_6 / 2 - num_6 / 2 * selection_progress

	local level_name = arg_30_2.level_name
	local text_color = level_name.text_color
	local default_text_color = level_name.default_text_color
	local select_text_color = level_name.select_text_color

	Colors.lerp_color_tables(default_text_color, select_text_color, max, text_color)

	local title = arg_30_2.title
	local text_color_2 = title.text_color
	local default_text_color_2 = title.default_text_color
	local select_text_color_2 = title.select_text_color

	Colors.lerp_color_tables(default_text_color_2, select_text_color_2, max, text_color_2)

	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end
