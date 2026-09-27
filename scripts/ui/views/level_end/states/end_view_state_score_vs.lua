-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_score_vs_definitions")

require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_details")
require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report")

local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local tab_size = var_0_0.tab_size
local flag = false
local num = 30

EndViewStateScoreVS = class(EndViewStateScoreVS)
EndViewStateScoreVS.NAME = "EndViewStateScoreVS"

EndViewStateScoreVS.on_enter = function (self, arg_1_1)
	-- function 1
	print("[PlayState] Enter Substate EndViewStateScoreVS")

	self._params = arg_1_1

	local context = arg_1_1.context

	self._parent = arg_1_1.parent
	self._context = context
	self._ui_renderer = context.ui_top_renderer
	self._input_manager = context.input_manager
	self._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}

	local shallow_copy = table.shallow_copy(var_0_0.tab_layouts)

	for i = #shallow_copy, 1, -1 do
		local condition_func = shallow_copy[i].condition_func

		if not (not condition_func and condition_func()) then
			table.remove(shallow_copy, i)
		end
	end

	self._layout_settings = shallow_copy

	self:create_ui_elements(arg_1_1)
	self:_align_tabs()
	self:_setup_level_widget()

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	self._animations = {}
	self._animation_callbacks = {}
	self._selected_layout_name = self._layout_settings[1].name

	self:_update_tab_selection(1)
	self._parent:hide_team()
	self:_play_animation("transition_enter")

	self._animation_callbacks.transition_enter = function ()
		-- function 2
		self:_set_initial_tab()
	end

	self._parent:set_input_description(nil)
end

EndViewStateScoreVS.exit = function (self, arg_3_1)
	-- function 3
	self._exit_started = true

	self:_play_animation("transition_exit")
end

EndViewStateScoreVS._play_animation = function (self, arg_4_1)
	-- function 4
	local tbl = {
		render_settings = self._render_settings
	}
	local start_animation = self._ui_animator:start_animation(arg_4_1, self._widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_4_1] = start_animation
end

EndViewStateScoreVS.play_sound = function (self, arg_5_1)
	-- function 5
	self._parent:play_sound(arg_5_1)
end

EndViewStateScoreVS.exit_done = function (self)
	-- function 6
	local _exit_started = self._exit_started

	_exit_started = not _exit_started and table.is_empty(self._animations)

	return _exit_started
end

EndViewStateScoreVS.create_ui_elements = function (self, arg_7_1)
	-- function 7
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets, {}, {})

	local tbl = {}
	local _layout_settings = self._layout_settings
	local num_2 = 0

	for i = 1, #_layout_settings do
		local var_7_3 = _layout_settings[i]
		local str = "tab"
		local display_name = var_7_3.display_name

		display_name = display_name or "n/a"

		local create_tab = var_0_0.create_tab(str, display_name)
		local var_7_7 = UIWidget.init(create_tab)
		local get_text_width = UIUtils.get_text_width(self._ui_renderer, var_7_7.style.text, display_name)
		local offset = var_7_7.offset
		local num_3

		if i > 1 then
			num_3 = get_text_width * 0.5

			if not num_3 then
				-- Nothing
			end
		end

		num_3 = 0

		::label_7_0::

		offset[1] = num_2 + num_3
		num_2 = num_2 + get_text_width * 0.5 + num
		var_7_7.style.hotspot.area_size[1] = get_text_width * 0.5

		local name = var_7_3.name

		var_7_7.content.layout_name = name
		tbl[#tbl + 1] = var_7_7
	end

	self._title_button_widgets = tbl
	self._ui_animations = {}

	local create_team_score_func = var_0_0.create_team_score_func
	local peer_id = Network.peer_id()
	local num_4 = 1
	local var_7_15 = self._context.party_composition[PlayerUtils.unique_player_id(peer_id, num_4)]
	local flag

	flag = var_7_15 ~= 1 or not 2 or 1

	local var_7_17 = GameModeSettings.versus.party_names_lookup_by_id[var_7_15]
	local var_7_18 = GameModeSettings.versus.party_names_lookup_by_id[flag]
	local team_scores = self._context.rewards.team_scores
	local var_7_20 = team_scores[var_7_15]
	local var_7_21 = team_scores[flag]
	local var_7_22 = create_team_score_func("local_team", var_7_17, var_7_20)
	local var_7_23 = create_team_score_func("opponent_team", var_7_18, var_7_21)
	local var_7_24 = UIWidget.init(var_7_22)
	local var_7_25 = UIWidget.init(var_7_23)

	self._widgets[#self._widgets + 1] = var_7_24
	self._widgets[#self._widgets + 1] = var_7_25
	self._widgets_by_name.local_score = var_7_24
	self._widgets_by_name.opponent_score = var_7_25

	local count = #_layout_settings

	self._widgets_by_name.tab_selection.content.visible = count > 1
	self._widgets_by_name.prev_tab.content.visible = count > 1
	self._widgets_by_name.next_tab.content.visible = count > 1

	local back_to_keep_button = self._widgets_by_name.back_to_keep_button

	UIUtils.enable_button(back_to_keep_button, false)
end

EndViewStateScoreVS._align_tabs = function (self)
	-- function 8
	local num_2 = 0

	for k, v in pairs(self._title_button_widgets) do
		num_2 = num_2 + v.style.hotspot.area_size[1] + num
	end

	for k_2, v_2 in pairs(self._title_button_widgets) do
		v_2.offset[1] = v_2.offset[1] - num_2
	end

	local var_8_1 = self._title_button_widgets[1]
	local text = var_8_1.content.text
	local text_2 = var_8_1.style.text
	local get_text_width = UIUtils.get_text_width(self._ui_renderer, text_2, text)

	self._widgets_by_name.prev_tab.offset[1] = -num_2 - get_text_width * 0.5 - num * 2

	local var_8_5 = self._title_button_widgets[#self._title_button_widgets]
	local text_3 = var_8_5.content.text
	local text_4 = var_8_5.style.text
	local get_text_width_2 = UIUtils.get_text_width(self._ui_renderer, text_4, text_3)
	local offset = var_8_5.offset

	self._widgets_by_name.next_tab.offset[1] = offset[1] + get_text_width_2 * 0.5 + num * 2
end

EndViewStateScoreVS._setup_level_widget = function (self)
	-- function 9
	local content = self._widgets_by_name.level.content
	local level_key = self._context.level_key
	local var_9_2 = LevelSettings[level_key]
	local level_image

	if not var_9_2 then
		level_image = var_9_2.level_image

		if not level_image then
			-- Nothing
		end
	end

	level_image = "level_image_any"

	::label_9_0::

	content.icon = level_image

	local difficulty = self._context.difficulty
	local var_9_5 = DifficultySettings[difficulty]
	local completed_frame_texture

	if not var_9_5 then
		completed_frame_texture = var_9_5.completed_frame_texture

		if not completed_frame_texture then
			-- Nothing
		end
	end

	completed_frame_texture = "map_frame_00"

	::label_9_1::

	content.frame = completed_frame_texture
	self._widgets_by_name.level_text.content.text = Localize(var_9_2.display_name)
end

EndViewStateScoreVS._set_text_button_size = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local style = arg_10_1.style

	style.selected_texture.texture_size[1] = arg_10_2

	local num = 5
	local num_2 = arg_10_2 - num * 2

	style.text.size[1] = num_2
	style.text_shadow.size[1] = num_2
	style.text_hover.size[1] = num_2
	style.text_disabled.size[1] = num_2
	style.text.offset[1] = style.text.default_offset[1] + num
	style.text_shadow.offset[1] = style.text_shadow.default_offset[1] + num
	style.text_hover.offset[1] = style.text_hover.default_offset[1] + num
	style.text_disabled.offset[1] = style.text_disabled.default_offset[1] + num
end

EndViewStateScoreVS._wanted_state = function (self)
	-- function 11
	return (self.parent:wanted_menu_state())
end

EndViewStateScoreVS.set_input_manager = function (self, arg_12_1)
	-- function 12
	self.input_manager = arg_12_1
end

EndViewStateScoreVS.on_exit = function (self, arg_13_1)
	-- function 13
	print("[PlayState] Exit Substate EndViewStateScoreVS")

	self.ui_animator = nil
end

EndViewStateScoreVS._update_transition_timer = function (self, arg_14_1)
	-- function 14
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_14_1, 0)
	end
end

EndViewStateScoreVS.update = function (self, arg_15_1, arg_15_2)
	-- function 15
	self:_update_animations(arg_15_1, arg_15_2)
	self:_handle_input(arg_15_1, arg_15_2)
	self:_draw(arg_15_1, arg_15_2)

	if not self._active_tab then
		self._active_tab:update(arg_15_1, arg_15_2)
	end
end

EndViewStateScoreVS._update_animations = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_16_1)

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil

			local var_16_2 = self._animation_callbacks[k]

			if not var_16_2 then
				var_16_2()

				self._animation_callbacks[k] = nil
			end
		end
	end

	for k_2, v_2 in pairs(self._ui_animations) do
		UIAnimation.update(v_2, arg_16_1)

		if not UIAnimation.completed(v_2) then
			self._ui_animations[k_2] = nil

			local var_16_3 = self._animation_callbacks[k_2]

			if not var_16_3 then
				var_16_3()

				self._animation_callbacks[k_2] = nil
			end
		end
	end

	local back_to_keep_button = self._widgets_by_name.back_to_keep_button

	UIWidgetUtils.animate_default_button(back_to_keep_button, arg_16_1)
end

EndViewStateScoreVS._set_initial_tab = function (self)
	-- function 17
	self:_change_tab(self._selected_layout_name, 1, "")
end

EndViewStateScoreVS._handle_input = function (self, arg_18_1, arg_18_2)
	-- function 18
	local get_service = self._input_manager:get_service("end_of_level")
	local _title_button_widgets = self._title_button_widgets

	if #_title_button_widgets > 1 then
		for i = 1, #_title_button_widgets do
			local var_18_2 = _title_button_widgets[i]

			if not UIUtils.is_button_pressed(var_18_2) then
				local layout_name = var_18_2.content.layout_name

				if layout_name ~= self._selected_layout_name then
					self:_change_tab(layout_name, i, self._selected_layout_name)
					self:_set_selected_option(layout_name)
				end

				self:play_sound("Play_hud_select")

				break
			elseif not UIUtils.is_button_hover_enter(var_18_2) then
				self:play_sound("Play_hud_hover")
			end
		end
	end

	local var_18_4

	if UIUtils.is_button_pressed(self._widgets_by_name.prev_tab) or not get_service:get("cycle_previous") then
		var_18_4 = self._selected_tab_index
		var_18_4 = math.clamp((var_18_4 or 1) - 1, 1, #self._title_button_widgets)
	elseif UIUtils.is_button_pressed(self._widgets_by_name.next_tab) or not get_service:get("cycle_next") then
		var_18_4 = self._selected_tab_index
		var_18_4 = math.clamp((var_18_4 or 1) + 1, 1, #self._title_button_widgets)
	end

	if not var_18_4 then
		local layout_name_2 = self._title_button_widgets[var_18_4].content.layout_name

		if layout_name_2 ~= self._selected_layout_name then
			self:_change_tab(layout_name_2, var_18_4, self._selected_layout_name)
		end
	end

	local back_to_keep_button = self._widgets_by_name.back_to_keep_button
	local is_button_enabled = UIUtils.is_button_enabled(back_to_keep_button)

	is_button_enabled = not is_button_enabled and get_service:get("refresh")

	if UIUtils.is_button_pressed(back_to_keep_button) or not is_button_enabled then
		self._done = true

		UIUtils.enable_button(back_to_keep_button, false)
		self:play_sound("play_gui_mission_summary_button_return_to_keep_click")
		Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
	elseif not UIUtils.is_button_hover_enter(back_to_keep_button) then
		self:play_sound("Play_hud_hover")
	end
end

EndViewStateScoreVS._change_tab = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not (arg_19_2 < 0 or not (arg_19_2 > #self._title_button_widgets)) then
		return
	end

	local _get_tab_settings_by_layout_name = self:_get_tab_settings_by_layout_name(arg_19_3)

	if not (not self._active_tab and self._active_tab.NAME ~= _get_tab_settings_by_layout_name.class_name) then
		self._active_tab:on_exit()

		self._active_tab = nil
	end

	local class_name = self._layout_settings[arg_19_2].class_name
	local var_19_2 = rawget(_G, class_name):new()

	if not var_19_2.on_enter then
		var_19_2:on_enter(self._params)
	end

	self._active_tab = var_19_2
	self._selected_layout_name = arg_19_1

	self:_update_tab_selection(arg_19_2)
	self:play_sound("Play_vs_hud_progression_scoreboard_appear")
end

EndViewStateScoreVS._update_tab_selection = function (self, arg_20_1)
	-- function 20
	self._selected_tab_index = arg_20_1

	for i, v in ipairs(self._title_button_widgets) do
		v.content.hotspot.is_selected = i == arg_20_1
	end

	local var_20_0 = self._title_button_widgets[arg_20_1]
	local text = var_20_0.content.text
	local text_2 = var_20_0.style.text
	local var_20_3 = var_20_0.offset[1]
	local num = 20
	local get_text_width = UIUtils.get_text_width(self._ui_renderer, text_2, text)
	local tab_selection = self._widgets_by_name.tab_selection
	local rect = tab_selection.style.rect

	self._ui_animations.tab_selection_position = UIAnimation.init(UIAnimation.function_by_time, tab_selection.offset, 1, tab_selection.offset[1], var_20_3, 0.25, math.easeOutCubic)
	self._ui_animations.tab_selection_size = UIAnimation.init(UIAnimation.function_by_time, rect.texture_size, 1, rect.texture_size[1], get_text_width + num, 0.25, math.easeOutCubic)
end

EndViewStateScoreVS._set_selected_option = function (self, arg_21_1)
	-- function 21
	local _title_button_widgets = self._title_button_widgets

	for i = 1, #_title_button_widgets do
		local content = _title_button_widgets[i].content
		local layout_name = content.layout_name

		content.hotspot.is_selected = layout_name == arg_21_1
	end
end

EndViewStateScoreVS.post_update = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	return
end

EndViewStateScoreVS._draw = function (self, arg_23_1, arg_23_2)
	-- function 23
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_service = self._input_manager:get_service("end_of_level")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_23_1, nil, _render_settings)
	UIRenderer.draw_all_widgets(_ui_renderer, self._widgets)

	if #self._title_button_widgets > 1 then
		UIRenderer.draw_all_widgets(_ui_renderer, self._title_button_widgets)
	end

	UIRenderer.end_pass(_ui_renderer)
end

EndViewStateScoreVS.done = function (self)
	-- function 24
	return self._done
end

EndViewStateScoreVS._get_tab_settings_by_layout_name = function (self, arg_25_1)
	-- function 25
	for i, v in ipairs(self._layout_settings) do
		if v.name == arg_25_1 then
			return v
		end
	end
end

EndViewStateScoreVS.activate_back_to_keep_button = function (self)
	-- function 26
	local back_to_keep_button = self._widgets_by_name.back_to_keep_button

	UIUtils.enable_button(back_to_keep_button, true)
end
