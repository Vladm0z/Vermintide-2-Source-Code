-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_journey_selection.lua

require("scripts/settings/dlcs/morris/deus_theme_settings")

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_journey_selection_definitions")
local widgets = var_0_0.widgets
local node_widgets = var_0_0.node_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local journey_widget_settings = var_0_0.journey_widget_settings
local str = "confirm_press"

local function fn(self, arg_1_1)
	-- function 1
	return self.remaining_time - (arg_1_1 - self.time_of_update) < 0
end

StartGameWindowDeusJourneySelection = class(StartGameWindowDeusJourneySelection)
StartGameWindowDeusJourneySelection.NAME = "StartGameWindowDeusJourneySelection"

StartGameWindowDeusJourneySelection.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[StartGameWindow] Enter Substate StartGameWindowDeusJourneySelection")

	local ingame_ui_context = arg_2_1.ingame_ui_context
	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.parent = arg_2_1.parent
	self.ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._unlocked_journeys = self:_get_unlocked_journeys()
	self._animations = {}

	self:create_ui_elements(arg_2_1, arg_2_2)
	self:_set_presentation_info()
	self:_setup_journey_widgets()
	self:_refresh_journey_cycle()
	self:_update_selected_journey()
	self:_setup_grid_navigation()
	self:_start_transition_animation("on_enter")
end

StartGameWindowDeusJourneySelection._start_transition_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_3_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_3_1] = start_animation
end

StartGameWindowDeusJourneySelection.create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_4_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_3
		tbl_2[k] = var_4_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(node_widgets) do
		local var_4_6 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_4_6
		tbl_4[k_2] = var_4_6
	end

	self._node_widgets = tbl_3
	self._node_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end
end

StartGameWindowDeusJourneySelection._get_unlocked_journeys = function (self)
	-- function 5
	local tbl = {}

	for i, v in ipairs(LevelUnlockUtils.unlocked_journeys(self.statistics_db, self._stats_id)) do
		tbl[v] = true
	end

	return tbl
end

StartGameWindowDeusJourneySelection._setup_journey_widgets = function (self)
	-- function 6
	local _node_widgets = self._node_widgets
	local statistics_db = self.statistics_db
	local _stats_id = self._stats_id
	local _unlocked_journeys = self._unlocked_journeys
	local tbl = {}
	local num = -365
	local var_6_6 = journey_widget_settings
	local AvailableJourneyOrder = AvailableJourneyOrder

	for i, v in ipairs(AvailableJourneyOrder) do
		local var_6_8 = DeusJourneySettings[v]
		local num_2 = #tbl + 1
		local var_6_10 = AvailableJourneyOrder[num_2 + 1]
		local var_6_11 = _node_widgets[num_2]
		local content = var_6_11.content

		content.text = Localize(var_6_8.display_name)

		local num_3 = var_6_6.width + var_6_6.spacing_x

		num = num + num_3

		local offset = var_6_11.offset

		offset[1] = num
		offset[2] = 0

		local completed_journey_difficulty_index = LevelUnlockUtils.completed_journey_difficulty_index(statistics_db, _stats_id, v)
		local get_level_frame_by_difficulty_index = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_journey_difficulty_index)
		local var_6_17 = _unlocked_journeys[v]

		content.icon = var_6_8.level_image
		content.locked = not var_6_17
		content.frame = get_level_frame_by_difficulty_index
		content.journey_name = v
		content.draw_path = var_6_10 ~= nil
		content.draw_path_fill = _unlocked_journeys[var_6_10]
		var_6_11.style.path.texture_size[1] = num_3
		var_6_11.style.path_glow.texture_size[1] = num_3
		tbl[num_2] = var_6_11
		num = num + var_6_6.spacing_x
	end

	self._active_node_widgets = tbl
end

StartGameWindowDeusJourneySelection._get_first_journey_name = function (self)
	-- function 7
	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		return _active_node_widgets[1].content.journey_name
	end
end

StartGameWindowDeusJourneySelection._is_journey_presented = function (self, arg_8_1)
	-- function 8
	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			if _active_node_widgets[i].content.journey_name == arg_8_1 then
				return true
			end
		end
	end

	return false
end

StartGameWindowDeusJourneySelection._select_journey = function (self, arg_9_1)
	-- function 9
	local required_journeys = DeusJourneySettings[arg_9_1].required_journeys

	required_journeys = required_journeys or {}

	local _active_node_widgets = self._active_node_widgets
	local var_9_2 = self._unlocked_journeys[arg_9_1]

	if not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			local var_9_3 = _active_node_widgets[i]
			local content = var_9_3.content
			local flag = content.journey_name == arg_9_1

			var_9_3.content.button_hotspot.is_selected = flag

			if not table.contains(required_journeys, content.journey_name) then
				-- Nothing
			end

			::label_9_0::

			local locked = content.locked

			locked = locked or not var_9_2

			::label_9_1::

			content.unlock_guidance = locked
		end
	end

	self._selected_journey_name = arg_9_1

	self:_set_presentation_info(arg_9_1)
	self:_update_modifier_god_info(arg_9_1)
end

StartGameWindowDeusJourneySelection._set_presentation_info = function (self, arg_10_1)
	-- function 10
	local str = ""
	local str_2 = ""
	local var_10_2
	local flag = false
	local _widgets_by_name = self._widgets_by_name
	local content = _widgets_by_name.selected_level.content

	if not arg_10_1 then
		local statistics_db = self.statistics_db
		local _stats_id = self._stats_id
		local var_10_8 = DeusJourneySettings[arg_10_1]
		local level_image = var_10_8.level_image
		local display_name = var_10_8.display_name

		str_2 = var_10_8.description

		local completed_journey_difficulty_index = LevelUnlockUtils.completed_journey_difficulty_index(statistics_db, _stats_id, arg_10_1)

		var_10_2 = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_journey_difficulty_index)

		if not self._unlocked_journeys[arg_10_1] then
			self.parent:set_input_description("select_mission_confirm")
		else
			self.parent:set_input_description("select_mission")
		end

		content.icon = level_image
		str = Localize(display_name)
		str_2 = Localize(str_2)
		flag = true
	end

	content.frame = var_10_2
	content.locked = not flag
	content.visible = flag
	content.draw_chaos_symbol = false
	content.button_hotspot.disable_button = true
	_widgets_by_name.helper_text.content.visible = not flag
	_widgets_by_name.level_title_divider.content.visible = flag
	_widgets_by_name.level_title.content.text = str
	_widgets_by_name.description_text.content.text = str_2
	_widgets_by_name.locked_text.content.text = ""
end

StartGameWindowDeusJourneySelection._setup_grid_navigation = function (self)
	-- function 11
	local tbl = {}

	for k, v in pairs(self._active_node_widgets) do
		local content = v.content

		table.insert(tbl, content.journey_name)
	end

	self._navigation_grid = tbl
	self._current_column = self:_find_journey_location_in_grid(self._selected_journey_name)
end

StartGameWindowDeusJourneySelection._find_journey_location_in_grid = function (self, arg_12_1)
	-- function 12
	if not arg_12_1 then
		return 1
	end

	local _navigation_grid = self._navigation_grid
	local num = 1

	if not _navigation_grid then
		for i, v in ipairs(_navigation_grid) do
			if v == arg_12_1 then
				num = i

				break
			end
		end
	end

	fassert(num, "journey %s does not exist in navigation grid", arg_12_1)

	return num
end

StartGameWindowDeusJourneySelection.on_exit = function (self, arg_13_1)
	-- function 13
	print("[StartGameWindow] Exit Substate StartGameWindowDeusJourneySelection")

	self.ui_animator = nil

	self.parent:set_input_description(nil)
end

StartGameWindowDeusJourneySelection.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	local time = Managers.time:time("main")

	self:_update_modifiers(time)
	self:_update_animations(arg_14_1)
	self:_handle_input(arg_14_1, arg_14_2)
	self:draw(arg_14_1)
end

StartGameWindowDeusJourneySelection.post_update = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	return
end

StartGameWindowDeusJourneySelection._update_modifiers = function (self, arg_16_1)
	-- function 16
	local _journey_cycle = self._journey_cycle

	if not _journey_cycle and not fn(_journey_cycle, arg_16_1) then
		self:_refresh_journey_cycle()
	end

	self:_update_modifier_timer(arg_16_1)
end

StartGameWindowDeusJourneySelection._refresh_journey_cycle = function (self)
	-- function 17
	self._journey_cycle = Managers.backend:get_interface("deus"):get_journey_cycle()

	self:_on_new_journey_cycle()
end

StartGameWindowDeusJourneySelection._update_modifier_timer = function (self, arg_18_1)
	-- function 18
	local _journey_cycle = self._journey_cycle
	local num = _journey_cycle.remaining_time - (arg_18_1 - _journey_cycle.time_of_update)

	if num < 0 then
		num = 0
	end

	local floor = math.floor
	local var_18_3 = floor(num / 86400)
	local var_18_4 = floor(num / 3600)
	local num_2 = floor(num / 60) % 60
	local content = self._widgets_by_name.modifier_timer.content

	if num_2 > 0 then
		local var_18_7 = Localize("deus_start_game_mod_timer")

		content.time_text = string.format(var_18_7, var_18_3, var_18_4, num_2)
	else
		local var_18_8 = floor(num)
		local var_18_9 = Localize("deus_start_game_mod_timer_seconds")

		content.time_text = string.format(var_18_9, var_18_8)
	end
end

StartGameWindowDeusJourneySelection._update_modifier_god_info = function (self, arg_19_1)
	-- function 19
	local _journey_cycle = self._journey_cycle
	local modifier_info_god = self._widgets_by_name.modifier_info_god
	local content = modifier_info_god.content
	local dominant_god = _journey_cycle.journey_data[arg_19_1].dominant_god
	local var_19_4 = DeusThemeSettings[dominant_god]

	content.icon = var_19_4.text_icon
	content.title = var_19_4.journey_title
	content.description = Localize(var_19_4.journey_description)

	local color = var_19_4.color
	local style = modifier_info_god.style

	style.icon.color = color
	style.title.text_color = color
end

StartGameWindowDeusJourneySelection._update_journey_god_icons = function (self)
	-- function 20
	local _journey_cycle = self._journey_cycle

	for i, v in ipairs(self._active_node_widgets) do
		local content = v.content
		local dominant_god = _journey_cycle.journey_data[content.journey_name].dominant_god

		content.theme_icon = DeusThemeSettings[dominant_god].icon
	end
end

StartGameWindowDeusJourneySelection._on_new_journey_cycle = function (self)
	-- function 21
	local _selected_journey_name = self._selected_journey_name

	if not _selected_journey_name then
		self:_update_modifier_god_info(_selected_journey_name)
	end

	self:_update_journey_god_icons()
end

StartGameWindowDeusJourneySelection._update_animations = function (self, arg_22_1)
	-- function 22
	local ui_animator = self.ui_animator

	ui_animator:update(arg_22_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _node_widgets = self._node_widgets

	for k_2 = 1, #_node_widgets do
		local var_22_3 = _node_widgets[k_2]

		self:_animate_node_widget(var_22_3, arg_22_1)
	end
end

StartGameWindowDeusJourneySelection._is_button_pressed = function (arg_23_0, arg_23_1)
	-- function 23
	local button_hotspot = arg_23_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowDeusJourneySelection._is_button_hovered = function (arg_24_0, arg_24_1)
	-- function 24
	if not arg_24_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

StartGameWindowDeusJourneySelection._update_selected_journey = function (self)
	-- function 25
	local get_selected_level_id = self.parent:get_selected_level_id()

	if not (get_selected_level_id ~= self._selected_journey_name or get_selected_level_id) then
		if not self:_is_journey_presented(get_selected_level_id) then
			self:_select_journey(get_selected_level_id)
		elseif not self._selected_journey_name then
			local _get_first_journey_name = self:_get_first_journey_name()

			self:_select_journey(_get_first_journey_name)
		end
	end
end

StartGameWindowDeusJourneySelection._update_selection_from_grid = function (self)
	-- function 26
	local _current_column = self._current_column
	local var_26_1 = self._navigation_grid[_current_column]

	fassert(var_26_1, "No journey_name at column %s", tostring(_current_column))
	self:_select_journey(var_26_1)
	self:_play_sound("play_gui_lobby_button_02_mission_act_click")
end

StartGameWindowDeusJourneySelection._update_grid_column = function (self, arg_27_1)
	-- function 27
	local count = #self._navigation_grid

	self._current_column = math.clamp(arg_27_1, 1, count)

	self:_update_selection_from_grid()
end

StartGameWindowDeusJourneySelection._update_grid_navigation = function (self, arg_28_1)
	-- function 28
	local _find_column = self:_find_column(arg_28_1)

	if _find_column ~= self._current_column then
		self:_update_grid_column(_find_column)
	end
end

StartGameWindowDeusJourneySelection._find_column = function (self, arg_29_1)
	-- function 29
	if arg_29_1 == 0 then
		return self._current_column
	end

	local _current_column = self._current_column
	local _current_column_2 = self._current_column
	local _navigation_grid = self._navigation_grid

	if arg_29_1 < 0 then
		for k, v in pairs(_navigation_grid) do
			if k < _current_column_2 then
				_current_column = k
			else
				break
			end
		end
	else
		for k_2, v_2 in pairs(_navigation_grid) do
			if _current_column_2 < k_2 then
				_current_column = k_2

				break
			end
		end
	end

	return _current_column
end

StartGameWindowDeusJourneySelection._handle_input = function (self, arg_30_1, arg_30_2)
	-- function 30
	local parent = self.parent
	local window_input_service = parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not is_device_active then
		if not window_input_service:get("move_right_hold_continuous") then
			self:_update_grid_navigation(1)
		elseif not window_input_service:get("move_left_hold_continuous") then
			self:_update_grid_navigation(-1)
		end
	end

	local _active_node_widgets = self._active_node_widgets

	if not (not is_device_active and window_input_service:get(str, true)) and not self._unlocked_journeys[self._selected_journey_name] then
		self:_play_sound("play_gui_lobby_button_02_mission_select")

		local get_selected_game_mode_layout_name = parent:get_selected_game_mode_layout_name()

		parent:set_selected_level_id(self._selected_journey_name)
		parent:set_layout_by_name(get_selected_game_mode_layout_name)
	elseif not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			local var_30_5 = _active_node_widgets[i]
			local journey_name = var_30_5.content.journey_name

			if not (not self:_is_button_hovered(var_30_5) and self._selected_journey_name == journey_name) then
				self:_play_sound("play_gui_lobby_button_02_mission_act_click")
				self:_select_journey(journey_name)
			end

			if not self:_is_button_pressed(var_30_5) then
				self:_play_sound("play_gui_lobby_button_02_mission_select")

				local get_selected_game_mode_layout_name_2 = parent:get_selected_game_mode_layout_name()

				parent:set_selected_level_id(journey_name)
				parent:set_layout_by_name(get_selected_game_mode_layout_name_2)
			end
		end
	end
end

StartGameWindowDeusJourneySelection.draw = function (self, arg_31_1)
	-- function 31
	local _ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, ui_scenegraph, window_input_service, arg_31_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_31_4 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_31_4)
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for j = 1, #_active_node_widgets do
			local var_31_6 = _active_node_widgets[j]

			UIRenderer.draw_widget(_ui_top_renderer, var_31_6)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowDeusJourneySelection._play_sound = function (self, arg_32_1)
	-- function 32
	self.parent:play_sound(arg_32_1)
end

StartGameWindowDeusJourneySelection._animate_node_widget = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local content = arg_33_1.content
	local button_hotspot = content.button_hotspot
	local is_selected = button_hotspot.is_selected
	local selected_progress = button_hotspot.selected_progress

	selected_progress = selected_progress or 0

	local num = 9

	if not is_selected then
		selected_progress = math.min(selected_progress + num * arg_33_2, 1)
	else
		selected_progress = math.max(selected_progress - num * arg_33_2, 0)
	end

	local unlock_guidance = content.unlock_guidance
	local unlock_guidance_progress = content.unlock_guidance_progress

	unlock_guidance_progress = unlock_guidance_progress or 0

	local num_2 = 2

	if not unlock_guidance then
		unlock_guidance_progress = math.min(unlock_guidance_progress + arg_33_2 * num_2, 1)
	else
		unlock_guidance_progress = math.max(unlock_guidance_progress - arg_33_2 * num_2, 0)
	end

	local style = arg_33_1.style

	style.icon_glow.color[1] = 255 * selected_progress

	local max = math.max(math.lerp(-2.5, 1, unlock_guidance_progress), 0)

	style.icon_unlock_guidance_glow.color[1] = 255 * max
	button_hotspot.selected_progress = selected_progress
	content.unlock_guidance_progress = unlock_guidance_progress
end
