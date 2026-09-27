-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_character_summary.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_character_summary_definitions")
local widgets = var_0_0.widgets
local career_info_widgets = var_0_0.career_info_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local create_talent_widget = var_0_0.create_talent_widget
local create_stat_widget = var_0_0.create_stat_widget
local create_hero_widget = var_0_0.create_hero_widget
local create_hero_icon_widget = var_0_0.create_hero_icon_widget
local list_spacing = var_0_0.list_spacing
local flag = false
local num = 0.3

HeroWindowCharacterSummary = class(HeroWindowCharacterSummary)
HeroWindowCharacterSummary.NAME = "HeroWindowCharacterSummary"

HeroWindowCharacterSummary.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCharacterSummary")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._profile_synchronizer = ingame_ui_context.profile_synchronizer
	self._animations = {}

	self:_create_ui_elements(arg_1_1)
	self:_start_transition_animation("on_enter")
	self:_setup_title_texts()
	self:_toggle_statistics(false)
	self:_setup_hero_selection_widgets()
	self:_set_career_selection_state(false)
end

HeroWindowCharacterSummary._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowCharacterSummary._create_ui_elements = function (self, arg_3_1)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(career_info_widgets) do
		local var_3_5 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_3_5
		tbl_4[k_2] = var_3_5
	end

	self._carrer_info_widgets = tbl_3
	self._carrer_info_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local list_scrollbar = self._widgets_by_name.list_scrollbar

	self._scrollbar_logic = ScrollBarLogic:new(list_scrollbar)

	self._scrollbar_logic:set_gamepad_scroll_enabled(true)

	tbl_2.hero_selection_warning.content.visible = false
end

HeroWindowCharacterSummary.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate HeroWindowCharacterSummary")

	self.ui_animator = nil

	self:_commit_talent_changes()
end

HeroWindowCharacterSummary._input_service = function (self)
	-- function 5
	local _parent = self._parent

	if not _parent:is_friends_list_active() then
		return _parent.fake_input_service
	end

	return _parent:window_input_service()
end

HeroWindowCharacterSummary.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	local player_unit = Managers.player:local_player().player_unit

	if not Unit.alive(player_unit) then
		self:_update_hero_sync()
	end

	self:_update_scroll_position()
	self:_update_animations(arg_6_1)
	self:_draw(arg_6_1)

	local _input_service = self:_input_service()

	self:_handle_input(_input_service, arg_6_1, arg_6_2)
end

HeroWindowCharacterSummary.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

HeroWindowCharacterSummary._handle_input = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _widgets_by_name = self._widgets_by_name
	local _parent = self._parent
	local flag = true
	local is_device_active = Managers.input:is_device_active("gamepad")

	self._scrollbar_logic:update(arg_8_2, arg_8_3)

	local any_input_pressed = Managers.input:any_input_pressed()
	local flag_2 = false
	local _talent_slot_widgets = self._talent_slot_widgets

	if not _talent_slot_widgets then
		for i, v in ipairs(_talent_slot_widgets) do
			if not self:_is_button_pressed(v) then
				self:_on_talent_slot_pressed(i)

				flag_2 = true
			end
		end
	end

	local _selected_talent_index = self._selected_talent_index

	if not _selected_talent_index then
		local var_8_8 = self._talent_widgets[_selected_talent_index]

		for i_2, v_2 in ipairs(var_8_8) do
			if not self:_is_button_pressed(v_2) then
				self:_on_talent_pressed(_selected_talent_index, i_2)

				flag_2 = true
			end
		end
	else
		local window_button = _widgets_by_name.window_button
		local hero_selection_button = _widgets_by_name.hero_selection_button

		if self:_is_button_pressed(hero_selection_button) or arg_8_1:get("special_1_press", flag) or not self._draw_hero_selection or not arg_8_1:get("back_menu", flag) then
			flag_2 = true

			self:_set_career_selection_state(not self._draw_hero_selection)
		end

		if not self._draw_hero_selection then
			if not self:_handle_gamepad_selection(arg_8_1) then
				flag_2 = true
			end

			if not arg_8_1:get("confirm_press", flag) then
				flag_2 = true

				self:_set_career_selection_state(false, true)
			end

			if not (is_device_active or flag_2) then
				local _hero_widgets = self._hero_widgets

				for i_3, v_3 in ipairs(_hero_widgets) do
					if not self:_is_button_hovered(v_3) then
						local career_settings = v_3.content.career_settings

						self:_change_carrer(career_settings)
					end

					if not self:_is_button_pressed(v_3) then
						flag_2 = true

						self:_set_career_selection_state(false, true)
						table.clear(v_3.content.button_hotspot)
					end
				end

				if not self:_is_button_hover(window_button) then
					local _previous_career_settings = self._previous_career_settings

					self:_change_carrer(_previous_career_settings)
				end
			end
		elseif not flag_2 then
			local is_hover = _widgets_by_name.list_scrollbar.content.scroll_bar_info.is_hover

			if not self:_is_button_pressed(window_button) and is_hover and not arg_8_1:get("right_stick_press") then
				self:_toggle_statistics(not self._draw_statistics)
			end
		end
	end

	if is_device_active or flag_2 or not Managers.input:any_input_pressed() then
		if not self._selected_talent_index then
			self:_on_talent_slot_pressed(nil)
		elseif not self._draw_hero_selection then
			self:_set_career_selection_state(false)
		end
	end
end

HeroWindowCharacterSummary._handle_gamepad_selection = function (self, arg_9_1)
	-- function 9
	local _num_max_hero_rows = self._num_max_hero_rows
	local _num_max_hero_columns = self._num_max_hero_columns
	local _selected_hero_row = self._selected_hero_row
	local _selected_hero_column = self._selected_hero_column
	local flag = false

	if not _selected_hero_row and not _selected_hero_column then
		local flag_2 = false

		if not arg_9_1:get("move_left_hold_continuous") then
			if _selected_hero_column > 1 then
				_selected_hero_column = _selected_hero_column - 1
				flag_2 = true
			end

			flag = true
		elseif not arg_9_1:get("move_right_hold_continuous") then
			if _selected_hero_column < _num_max_hero_columns then
				_selected_hero_column = _selected_hero_column + 1
				flag_2 = true
			end

			flag = true
		end

		if not arg_9_1:get("move_up_hold_continuous") then
			if _selected_hero_row > 1 then
				_selected_hero_row = _selected_hero_row - 1
				flag_2 = true
			end

			flag = true
		elseif not arg_9_1:get("move_down_hold_continuous") then
			if _selected_hero_row < _num_max_hero_rows then
				_selected_hero_row = _selected_hero_row + 1
				flag_2 = true
			end

			flag = true
		end

		if not flag_2 then
			self:_set_selected_hero_by_coordinates(_selected_hero_row, _selected_hero_column)

			local _selected_hero_career = self:_selected_hero_career()

			self:_change_carrer(_selected_hero_career)
		end
	end

	return flag
end

HeroWindowCharacterSummary._set_career_selection_state = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._draw_hero_selection = arg_10_1

	local current_career = self._parent:current_career()

	if not arg_10_1 then
		self._previous_career_settings = CareerSettings[current_career]

		local _hero_widgets = self._hero_widgets

		for i, v in ipairs(_hero_widgets) do
			if v.content.career_settings.name == current_career then
				self:_set_selected_hero_index(i)
			end
		end
	else
		if not arg_10_2 then
			local _previous_career_settings = self._previous_career_settings

			if not (not _previous_career_settings and _previous_career_settings.name == current_career) then
				self:_change_carrer(_previous_career_settings)
			end
		end

		self._previous_career_settings = nil
	end

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.summary_title.content.visible = not arg_10_1
	_widgets_by_name.hero_selection_title.content.visible = arg_10_1

	local content = _widgets_by_name.list_scrollbar.content
	local _draw_statistics

	if not arg_10_1 then
		_draw_statistics = self._draw_statistics

		if not _draw_statistics then
			-- Nothing
		end
	end

	_draw_statistics = false

	::label_10_0::

	content.visible = _draw_statistics
	self._params.changing_hero = arg_10_1
end

HeroWindowCharacterSummary._change_carrer = function (self, arg_11_1)
	-- function 11
	local _parent = self._parent
	local current_career = _parent:current_career()
	local name = arg_11_1.name

	if name == current_career then
		return
	end

	local profile_name = arg_11_1.profile_name
	local var_11_4 = FindProfileIndex(profile_name)
	local var_11_5 = career_index_from_name(var_11_4, name)

	_parent:set_current_career(var_11_4, var_11_5)

	local playing_career_index = _parent.playing_career_index
	local playing_profile_index = _parent.playing_profile_index
	local flag = playing_career_index ~= var_11_5 or playing_profile_index == var_11_4

	self._widgets_by_name.hero_selection_warning.content.visible = not flag
end

HeroWindowCharacterSummary._set_selected_hero_by_coordinates = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _hero_widgets = self._hero_widgets

	for i, v in ipairs(_hero_widgets) do
		local content = v.content
		local flag = content.row == arg_12_1
		local flag_2 = content.column == arg_12_2

		if not flag and not flag_2 then
			self:_set_selected_hero_index(i)

			return
		end
	end
end

HeroWindowCharacterSummary._set_selected_hero_index = function (self, arg_13_1)
	-- function 13
	local _hero_widgets = self._hero_widgets

	for i, v in ipairs(_hero_widgets) do
		local content = v.content
		local button_hotspot = content.button_hotspot
		local flag = i == arg_13_1

		button_hotspot.is_selected = flag

		if not flag then
			self._selected_hero_row = content.row
			self._selected_hero_column = content.column
		end
	end

	self._selected_hero_index = arg_13_1
end

HeroWindowCharacterSummary._selected_hero_career = function (self)
	-- function 14
	local _selected_hero_index = self._selected_hero_index
	local _hero_widgets = self._hero_widgets

	for i, v in ipairs(_hero_widgets) do
		local content = v.content
		local button_hotspot = content.button_hotspot

		if not (i == _selected_hero_index) then
			return content.career_settings
		end
	end
end

HeroWindowCharacterSummary._on_talent_pressed = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _selected_talents = self._selected_talents

	if _selected_talents[arg_15_1] == 0 then
		self:_play_sound("play_gui_talent_unlock")
	else
		self:_play_sound("play_gui_talents_selection_click")
	end

	self._talent_changes_done = true
	_selected_talents[arg_15_1] = arg_15_2

	local var_15_1 = self._talent_widgets[arg_15_1][arg_15_2]

	table.clear(var_15_1.content.button_hotspot)
	self:_set_talent_selected(arg_15_1, arg_15_2)
	self:_on_talent_slot_pressed(arg_15_1)
end

HeroWindowCharacterSummary._set_talent_selected = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _talent_slot_widgets = self._talent_slot_widgets
	local var_16_1 = self._talent_widgets[arg_16_1]

	for i, v in ipairs(var_16_1) do
		local content = v.content
		local style = v.style
		local flag = i == arg_16_2

		content.selected = flag
		style.icon.saturated = not flag

		if not flag then
			local var_16_5 = _talent_slot_widgets[arg_16_1]
			local content_2 = var_16_5.content
			local style_2 = var_16_5.style

			content_2.icon = content.icon
			content_2.talent = content.talent
			content_2.talent_id = content.talent_id
		end
	end
end

HeroWindowCharacterSummary._on_talent_slot_pressed = function (self, arg_17_1)
	-- function 17
	local var_17_0
	local _talent_slot_widgets = self._talent_slot_widgets

	for i, v in ipairs(_talent_slot_widgets) do
		local content = v.content
		local button_hotspot = content.button_hotspot
		local flag = not not button_hotspot.is_selected or arg_17_1 == i

		content.active = flag
		button_hotspot.is_selected = flag

		if not flag then
			var_17_0 = arg_17_1
		end
	end

	self._selected_talent_index = var_17_0
	self._talents_position_timer = 0
	self._widgets_by_name.list_scrollbar.content.scroll_bar_info.disable_button = var_17_0 ~= nil

	self:_enable_talent_row(nil)
end

HeroWindowCharacterSummary._enable_talent_row = function (self, arg_18_1)
	-- function 18
	local _talent_widgets = self._talent_widgets

	for i, v in ipairs(_talent_widgets) do
		for i_2, v_2 in ipairs(v) do
			v_2.content.button_hotspot.disable_button = i ~= arg_18_1
		end
	end
end

HeroWindowCharacterSummary._toggle_statistics = function (self, arg_19_1)
	-- function 19
	self._draw_statistics = arg_19_1

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.list_scrollbar.content.visible = arg_19_1

	local content = _widgets_by_name.summary_title.content
	local flag

	flag = not arg_19_1 and 2 and 1
	content.selected_option = flag
end

HeroWindowCharacterSummary._update_hero_sync = function (self)
	-- function 20
	local _parent = self._parent
	local loadout_sync_id = _parent.loadout_sync_id
	local hero_sync_id = _parent.hero_sync_id
	local talent_sync_id = _parent.talent_sync_id
	local flag = self._hero_sync_id ~= hero_sync_id
	local flag_2 = flag or self._talent_sync_id ~= talent_sync_id
	local flag_3 = flag or self._loadout_sync_id ~= loadout_sync_id
	local flag_4 = flag or flag_2 or flag_3
	local flag_5 = not flag_4 and _parent:current_hero()
	local flag_6 = not flag_4 and _parent:current_career()

	if not flag then
		self:_commit_talent_changes()
		self:_populate_career_info(flag_6)

		self._hero_sync_id = hero_sync_id
	end

	if not flag_2 then
		self:_populate_talents(flag_5, flag_6)

		self._talent_sync_id = talent_sync_id
	end

	if not flag_3 then
		self:_sync_statistics()

		self._loadout_sync_id = loadout_sync_id
	end
end

HeroWindowCharacterSummary._commit_talent_changes = function (self)
	-- function 21
	local _talent_changes_done = self._talent_changes_done
	local _selected_talents = self._selected_talents

	if not _talent_changes_done and not _selected_talents then
		local _selected_talents_career_name = self._selected_talents_career_name

		Managers.backend:get_interface("talents"):set_talents(_selected_talents_career_name, self._selected_talents)

		self._talent_changes_done = nil

		local _parent = self._parent

		_parent:update_talent_sync()

		self._talent_sync_id = _parent.talent_sync_id
	end
end

HeroWindowCharacterSummary._update_animations = function (self, arg_22_1)
	-- function 22
	self.ui_animator:update(arg_22_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	self:_animate_title_button(arg_22_1)
	self:_update_talent_position_animation(arg_22_1)

	local _talent_slot_widgets = self._talent_slot_widgets

	for i, v_2 in ipairs(_talent_slot_widgets) do
		self:_animate_talent_widget(v_2, arg_22_1)
	end

	local _talent_widgets = self._talent_widgets

	for i_2, v_3 in ipairs(_talent_widgets) do
		for i_3, v_4 in ipairs(v_3) do
			self:_animate_talent_widget(v_4, arg_22_1)
		end
	end

	local var_22_4
	local _hero_widgets = self._hero_widgets

	for i_4, v_5 in ipairs(_hero_widgets) do
		self:_animate_hero_widget(v_5, arg_22_1)

		if i_4 == self._selected_hero_index then
			var_22_4 = math.ceil(i_4 / 3)
		end
	end

	local _hero_icon_widgets = self._hero_icon_widgets

	for i_5, v_6 in ipairs(_hero_icon_widgets) do
		local flag = var_22_4 == i_5

		self:_animate_hero_icon_widget(v_6, flag, arg_22_1)
	end
end

HeroWindowCharacterSummary._is_button_pressed = function (arg_23_0, arg_23_1)
	-- function 23
	local content = arg_23_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_pressed then
		button_hotspot.on_pressed = false

		return true
	end
end

HeroWindowCharacterSummary._is_button_hovered = function (arg_24_0, arg_24_1)
	-- function 24
	local content = arg_24_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowCharacterSummary._is_button_hover = function (arg_25_0, arg_25_1)
	-- function 25
	local content = arg_25_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	return button_hotspot.is_hover
end

HeroWindowCharacterSummary._exit = function (self)
	-- function 26
	self.exit = true
end

HeroWindowCharacterSummary._draw = function (self, arg_27_1)
	-- function 27
	self:_update_visible_list_entries()

	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_service = self:_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, _input_service, arg_27_1, nil, self._render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	local _talent_slot_widgets = self._talent_slot_widgets

	if not _talent_slot_widgets then
		local var_27_6

		for i_2, v_2 in ipairs(_talent_slot_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v_2)

			if not v_2.content.active then
				local var_27_7 = i_2
			end
		end

		local _selected_talent_index = self._selected_talent_index

		if not _selected_talent_index then
			local _talent_widgets = self._talent_widgets

			if not _talent_widgets then
				local var_27_10 = _talent_widgets[_selected_talent_index]

				for i_3, v_3 in ipairs(var_27_10) do
					UIRenderer.draw_widget(_ui_top_renderer, v_3)
				end
			end
		end
	end

	if not self._draw_hero_selection then
		local _hero_widgets = self._hero_widgets

		if not _hero_widgets then
			for i_4, v_4 in ipairs(_hero_widgets) do
				UIRenderer.draw_widget(_ui_top_renderer, v_4)
			end
		end

		local _hero_icon_widgets = self._hero_icon_widgets

		if not _hero_icon_widgets then
			for i_5, v_5 in ipairs(_hero_icon_widgets) do
				UIRenderer.draw_widget(_ui_top_renderer, v_5)
			end
		end
	elseif not self._draw_statistics then
		local _list_widgets = self._list_widgets

		if not _list_widgets then
			for i_6, v_6 in ipairs(_list_widgets) do
				UIRenderer.draw_widget(_ui_top_renderer, v_6)
			end
		end
	else
		local _carrer_info_widgets = self._carrer_info_widgets

		if not _carrer_info_widgets then
			for i_7, v_7 in ipairs(_carrer_info_widgets) do
				UIRenderer.draw_widget(_ui_top_renderer, v_7)
			end
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

HeroWindowCharacterSummary._play_sound = function (self, arg_28_1)
	-- function 28
	self._parent:play_sound(arg_28_1)
end

HeroWindowCharacterSummary._sync_statistics = function (self)
	-- function 29
	local HeroStatisticsTemplate = HeroStatisticsTemplate
	local get_hero_statistics_by_template = UIUtils.get_hero_statistics_by_template(HeroStatisticsTemplate)

	self:_populate_statistics(get_hero_statistics_by_template)
end

HeroWindowCharacterSummary._populate_talents = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _ui_renderer = self._ui_renderer
	local str = "talent_root"
	local var_30_2 = create_talent_widget(str)
	local get_interface = Managers.backend:get_interface("talents")
	local get_talents = get_interface:get_talents(arg_30_2)

	self._selected_talents = table.clone(get_talents)
	self._talent_interface = get_interface
	self._selected_talents_career_name = arg_30_2

	local get_experience = ExperienceSettings.get_experience(arg_30_1)
	local get_level = ExperienceSettings.get_level(get_experience)
	local tbl = {}
	local tbl_2 = {}
	local var_30_9 = CareerSettings[arg_30_2]
	local var_30_10 = TalentTrees[arg_30_1][var_30_9.talent_tree_index]
	local _selected_talents = self._selected_talents
	local num = 12
	local num_2 = 5

	for i = 1, NumTalentRows do
		local str_2 = "talent_point_" .. i
		local is_unlocked = ProgressionUnlocks.is_unlocked(str_2, get_level)
		local get_unlock = ProgressionUnlocks.get_unlock(str_2)
		local var_30_17 = tostring(get_unlock.level_requirement)
		local var_30_18 = UIWidget.init(var_30_2)

		tbl[i] = var_30_18

		local size = var_30_18.content.size
		local offset = var_30_18.offset

		offset[1] = (i - 1) * (size[1] + num)
		offset[3] = NumTalentColumns * num_2
		var_30_18.content.level_text = var_30_17
		var_30_18.content.locked = not is_unlocked

		local tbl_3 = {}

		for j = 1, NumTalentColumns do
			local var_30_22 = UIWidget.init(var_30_2)

			tbl_3[#tbl_3 + 1] = var_30_22

			local var_30_23 = var_30_10[i][j]
			local var_30_24 = TalentIDLookup[var_30_23]
			local get_talent_by_id = TalentUtils.get_talent_by_id(arg_30_1, var_30_24)
			local content = var_30_22.content
			local icon

			if not get_talent_by_id then
				icon = get_talent_by_id.icon

				if not icon then
					-- Nothing
				end
			end

			icon = "icons_placeholder"

			::label_30_0::

			content.icon = icon
			content.talent = get_talent_by_id
			content.talent_id = var_30_24

			local offset_2 = var_30_22.offset

			offset_2[1] = (i - 1) * (size[1] + num)
			offset_2[2] = j * size[2]
			offset_2[3] = (NumTalentColumns - j) * num_2
		end

		tbl_2[i] = tbl_3
	end

	self._talent_slot_widgets = tbl
	self._talent_widgets = tbl_2

	for k = 1, NumTalentRows do
		local var_30_29 = _selected_talents[k]
		local flag

		flag = not var_30_29 and var_30_29 == 0

		for l = 1, NumTalentColumns do
			if not (var_30_29 == l) then
				self:_set_talent_selected(k, l)
			end
		end
	end
end

HeroWindowCharacterSummary._populate_statistics = function (self, arg_31_1)
	-- function 31
	local _ui_renderer = self._ui_renderer
	local tbl = {}
	local str = "list_item"
	local flag = true
	local var_31_4 = create_stat_widget(str, flag)
	local count = #arg_31_1

	for i = 1, count do
		local var_31_6 = arg_31_1[i]
		local var_31_7 = UIWidget.init(var_31_4)

		tbl[i] = var_31_7

		local str_2 = ""
		local str_3 = ""
		local str_4 = ""
		local type = var_31_6.type
		local num = 0

		if type == "title" then
			str_2 = var_31_6.display_name

			local num_2 = 10
		elseif type == "entry" then
			str_3 = var_31_6.display_name
			str_4 = var_31_6.value
		end

		local content = var_31_7.content
		local style = var_31_7.style

		content.name = UIRenderer.crop_text_width(_ui_renderer, str_3, 300, style.name)
		content.title = UIRenderer.crop_text_width(_ui_renderer, str_2, 300, style.title)
		content.value = str_4
	end

	self._list_widgets = tbl
	self._total_list_height = self:_align_list_widgets(tbl, list_spacing)

	self:_initialize_scrollbar()
end

HeroWindowCharacterSummary._align_list_widgets = function (arg_32_0, arg_32_1, arg_32_2)
	-- function 32
	local num = 0
	local count = #arg_32_1

	for i, v in ipairs(arg_32_1) do
		local offset = v.offset
		local size = v.content.size

		v.default_offset = table.clone(offset)

		local var_32_4 = size[2]

		offset[2] = -num
		num = num + var_32_4

		if i ~= count then
			num = num + arg_32_2
		end
	end

	return num
end

HeroWindowCharacterSummary._initialize_scrollbar = function (self)
	-- function 33
	local size = scenegraph_definition.item_list.size
	local size_2 = scenegraph_definition.list_scrollbar.size
	local var_33_2 = size[2]
	local _total_list_height = self._total_list_height
	local var_33_4 = size_2[2]
	local num = 200 + list_spacing * 1.5
	local num_2 = 1
	local _scrollbar_logic = self._scrollbar_logic

	_scrollbar_logic:set_scrollbar_values(var_33_2, _total_list_height, var_33_4, num, num_2)
	_scrollbar_logic:set_scroll_percentage(0)

	self._list_thumb_scale = _scrollbar_logic:thumb_scale()
end

HeroWindowCharacterSummary._update_scroll_position = function (self)
	-- function 34
	local get_scrolled_length = self._scrollbar_logic:get_scrolled_length()

	if get_scrolled_length ~= self._scrolled_length then
		self._ui_scenegraph.list_scroll_root.local_position[2] = math.round(get_scrolled_length)
		self._scrolled_length = get_scrolled_length
	end
end

HeroWindowCharacterSummary._update_visible_list_entries = function (self)
	-- function 35
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		return
	end

	local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
	local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
	local get_scroll_length = _scrollbar_logic:get_scroll_length()
	local size = scenegraph_definition.item_list.size
	local num = list_spacing * 2
	local num_2 = size[2] + num
	local _list_widgets = self._list_widgets
	local count = #_list_widgets

	for i, v in ipairs(_list_widgets) do
		local offset = v.offset
		local content = v.content
		local size_2 = content.size
		local num_3 = math.abs(offset[2]) + size_2[2]
		local flag = false

		if num_3 < get_scrolled_length - num then
			flag = true
		elseif num_2 < math.abs(offset[2]) - get_scrolled_length then
			flag = true
		end

		content.visible = not flag
	end
end

HeroWindowCharacterSummary._get_scrollbar_percentage_by_index = function (self, arg_36_1)
	-- function 36
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
		local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
		local get_scroll_length = _scrollbar_logic:get_scroll_length()
		local var_36_4 = scenegraph_definition.item_list.size[2]
		local var_36_5 = get_scrolled_length
		local num = var_36_5 + var_36_4
		local _list_widgets = self._list_widgets

		if not _list_widgets then
			local var_36_8 = _list_widgets[arg_36_1]
			local content = var_36_8.content
			local offset = var_36_8.offset
			local var_36_11 = content.size[2]
			local abs = math.abs(offset[2])
			local num_2 = abs + var_36_11
			local num_3 = 0

			if num < num_2 then
				local num_4 = num_2 - num

				num_3 = math.clamp(num_4 / get_scroll_length, 0, 1)
			elseif abs < var_36_5 then
				local num_5 = var_36_5 - abs

				num_3 = -math.clamp(num_5 / get_scroll_length, 0, 1)
			end

			if not num_3 then
				return (math.clamp(get_scroll_percentage + num_3, 0, 1))
			end
		end
	end

	return 0
end

HeroWindowCharacterSummary._setup_title_texts = function (self)
	-- function 37
	local summary_title = self._widgets_by_name.summary_title
	local content = summary_title.content
	local style = summary_title.style
	local size = content.size
	local text_spacing = content.text_spacing
	local _ui_renderer = self._ui_renderer
	local get_text_width = UIUtils.get_text_width(_ui_renderer, style.title_text1, content.title_text1)
	local get_text_width_2 = UIUtils.get_text_width(_ui_renderer, style.title_text2, content.title_text2)
	local get_text_width_3 = UIUtils.get_text_width(_ui_renderer, style.divider, content.divider)
	local var_37_9 = size[1]
	local num = -var_37_9 / 2 + text_spacing

	style.title_text1.offset[1] = -var_37_9 + get_text_width + text_spacing
	style.title_text1_shadow.offset[1] = style.title_text1.offset[1] + 2
	style.divider.offset[1] = get_text_width
	style.divider_shadow.offset[1] = style.divider.offset[1] + 2
	style.title_text2.offset[1] = get_text_width + get_text_width_3
	style.title_text2_shadow.offset[1] = style.title_text2.offset[1] + 2
end

HeroWindowCharacterSummary._animate_title_button = function (self, arg_38_1)
	-- function 38
	local summary_title = self._widgets_by_name.summary_title
	local content = summary_title.content
	local style = summary_title.style
	local selected_option = content.selected_option

	for i = 1, 2 do
		local str = "title_text" .. i
		local str_2 = "title_text" .. i .. "_shadow"
		local var_38_6 = style[str]
		local var_38_7 = style[str_2]
		local flag = i == selected_option
		local selected_progress = var_38_6.selected_progress

		selected_progress = selected_progress or 0

		local num = 15

		if not flag then
			selected_progress = math.min(selected_progress + num * arg_38_1, 1)
		else
			selected_progress = math.max(selected_progress - num * arg_38_1, 0)
		end

		var_38_6.selected_progress = selected_progress

		local num_2 = 255 * selected_progress
		local num_3 = var_38_6.default_font_size + 6 * selected_progress

		var_38_6.font_size = num_3
		var_38_7.font_size = num_3

		local num_4 = (1 - selected_progress) * 3

		var_38_6.offset[2] = var_38_6.default_offset[2] + num_4
		var_38_7.offset[2] = var_38_7.default_offset[2] + num_4

		local text_color = var_38_6.text_color
		local default_color = var_38_6.default_color
		local selected_color = var_38_6.selected_color

		Colors.lerp_color_tables(default_color, selected_color, selected_progress, text_color)
	end
end

HeroWindowCharacterSummary._populate_career_info = function (self, arg_39_1)
	-- function 39
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local var_39_2 = CareerSettings[arg_39_1]
	local character_selection_image = var_39_2.character_selection_image
	local display_name = var_39_2.display_name
	local _carrer_info_widgets_by_name = self._carrer_info_widgets_by_name

	if not (not Colors.color_definitions[arg_39_1] and Colors.get_color_table_with_alpha(arg_39_1, 255)) then
		local tbl = {
			255,
			255,
			255,
			255
		}
	end

	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(var_39_2)
	local index = PROFILES_BY_CAREER_NAMES[arg_39_1].index
	local var_39_9 = career_index_from_name(index, arg_39_1)
	local get_ability_data_by_career = CareerUtils.get_ability_data_by_career(var_39_2, 1)
	local display_name_2 = get_passive_ability_by_career.display_name
	local icon = get_passive_ability_by_career.icon
	local display_name_3 = get_ability_data_by_career.display_name
	local icon_2 = get_ability_data_by_career.icon

	_carrer_info_widgets_by_name.passive_title_text.content.text = Localize(display_name_2)
	_carrer_info_widgets_by_name.passive_description_text.content.text = UIUtils.get_ability_description(get_passive_ability_by_career)
	_carrer_info_widgets_by_name.passive_icon.content.texture_id = icon
	_carrer_info_widgets_by_name.active_title_text.content.text = Localize(display_name_3)
	_carrer_info_widgets_by_name.active_description_text.content.text = UIUtils.get_ability_description(get_ability_data_by_career)
	_carrer_info_widgets_by_name.active_icon.content.texture_id = icon_2

	local perks = get_passive_ability_by_career.perks
	local num = 0
	local num_2 = 0

	for i = 1, 3 do
		local var_39_18 = _carrer_info_widgets_by_name["career_perk_" .. i]
		local content = var_39_18.content
		local style = var_39_18.style
		local size = _ui_scenegraph[var_39_18.scenegraph_id].size

		var_39_18.offset[2] = -num

		local var_39_22 = perks[i]

		if not var_39_22 then
			local var_39_23 = Localize(var_39_22.display_name)
			local get_perk_description = UIUtils.get_perk_description(var_39_22)
			local title_text = style.title_text
			local description_text = style.description_text
			local description_text_shadow = style.description_text_shadow

			content.title_text = var_39_23
			content.description_text = get_perk_description

			local get_text_height = UIUtils.get_text_height(_ui_renderer, size, title_text, var_39_23)
			local get_text_height_2 = UIUtils.get_text_height(_ui_renderer, size, description_text, get_perk_description)

			description_text.offset[2] = -get_text_height_2
			description_text_shadow.offset[2] = -(get_text_height_2 + 2)
			num = num + get_text_height + get_text_height_2 + num_2
		end

		content.visible = var_39_22 ~= nil
	end
end

HeroWindowCharacterSummary._animate_talent_widget = function (arg_40_0, arg_40_1, arg_40_2)
	-- function 40
	local content = arg_40_1.content
	local style = arg_40_1.style
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	local is_hover = button_hotspot.is_hover
	local is_selected = button_hotspot.is_selected
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_40_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_40_2 * num, 0)
	end

	local easeOutCubic = math.easeOutCubic(hover_progress)
	local easeInCubic = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_40_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_40_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(selection_progress)
	local easeInCubic_2 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_2, easeOutCubic)
	local max_3 = math.max(easeInCubic, easeInCubic_2)
	local num_2 = 255 * hover_progress

	style.hover_frame.color[1] = num_2

	local color = style.icon.color
	local num_3 = 200 + 55 * max

	color[2] = num_3
	color[3] = num_3
	color[4] = num_3
	button_hotspot.hover_progress = hover_progress
	button_hotspot.selection_progress = selection_progress
end

HeroWindowCharacterSummary._update_talent_position_animation = function (self, arg_41_1)
	-- function 41
	local _selected_talent_index = self._selected_talent_index

	if not _selected_talent_index then
		return
	end

	local _talents_position_timer = self._talents_position_timer

	if not _talents_position_timer then
		return
	end

	local _get_timer_progress, var_41_3 = self:_get_timer_progress(_talents_position_timer, num, arg_41_1)
	local flag = _get_timer_progress == 1
	local easeOutCubic = math.easeOutCubic

	if not flag then
		self._talents_position_timer = nil

		self:_enable_talent_row(_selected_talent_index)
	else
		self._talents_position_timer = var_41_3
	end

	local var_41_6 = self._talent_widgets[_selected_talent_index]

	self:_set_talent_list_animation_progress(var_41_6, easeOutCubic(_get_timer_progress))
end

HeroWindowCharacterSummary._get_timer_progress = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local num = arg_42_1 + arg_42_3

	return math.min(num / arg_42_2, 1), num
end

HeroWindowCharacterSummary._set_talent_list_animation_progress = function (arg_43_0, arg_43_1, arg_43_2)
	-- function 43
	local num = 255 * arg_43_2

	for i, v in ipairs(arg_43_1) do
		local size = v.content.size

		v.offset[2] = size[2] * i * arg_43_2
	end
end

HeroWindowCharacterSummary._setup_hero_selection_widgets = function (self)
	-- function 44
	local tbl = {}

	self._hero_widgets = tbl

	local tbl_2 = {}

	self._hero_icon_widgets = tbl_2

	local get_interface = Managers.backend:get_interface("hero_attributes")
	local count = #SPProfilesAbbreviation
	local num = 0
	local var_44_5 = create_hero_widget("hero_root")
	local var_44_6 = create_hero_icon_widget("hero_icon_root")
	local num_2 = 144
	local num_3 = 116
	local num_4 = 136

	for i, v in ipairs(ProfilePriority) do
		local var_44_10 = SPProfiles[v]
		local display_name = var_44_10.display_name
		local get = get_interface:get(display_name, "experience")

		get = get or 0

		local get_level = ExperienceSettings.get_level(get)
		local careers = var_44_10.careers

		num = math.max(num, #careers)

		local var_44_15 = UIWidget.init(var_44_6)

		tbl_2[#tbl_2 + 1] = var_44_15
		var_44_15.offset[2] = -((i - 1) * num_4)

		local str = "hero_icon_large_" .. display_name

		var_44_15.content.icon = str
		var_44_15.content.icon_highlight = str .. "_glow"

		for i_2, v_2 in ipairs(careers) do
			local var_44_17 = UIWidget.init(var_44_5)

			tbl[#tbl + 1] = var_44_17

			local offset = var_44_17.offset
			local content = var_44_17.content

			content.career_settings = v_2
			content.row = i
			content.column = i_2

			local portrait_image = v_2.portrait_image

			content.portrait = "medium_" .. portrait_image
			content.locked = not v_2.is_unlocked_function(display_name, get_level)
			content.button_hotspot.disable_button = content.locked
			offset[1] = (i_2 - 1) * num_3
			offset[2] = -((i - 1) * num_4)

			print("lol", #tbl, i, i_2)
		end
	end

	self._num_max_hero_rows = count
	self._num_max_hero_columns = num
end

HeroWindowCharacterSummary._animate_hero_widget = function (arg_45_0, arg_45_1, arg_45_2)
	-- function 45
	local content = arg_45_1.content
	local style = arg_45_1.style
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	local is_hover = button_hotspot.is_hover
	local is_selected = button_hotspot.is_selected
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_45_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_45_2 * num, 0)
	end

	local easeOutCubic = math.easeOutCubic(hover_progress)
	local easeInCubic = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_45_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_45_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(selection_progress)
	local easeInCubic_2 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_2, easeOutCubic)
	local max_3 = math.max(easeInCubic, easeInCubic_2)
	local num_2 = 255 * hover_progress

	style.hover_frame.color[1] = 255 * max

	local color = style.portrait.color
	local num_3 = 170 + 85 * max

	color[2] = num_3
	color[3] = num_3
	color[4] = num_3
	button_hotspot.hover_progress = hover_progress
	button_hotspot.selection_progress = selection_progress
end

HeroWindowCharacterSummary._animate_hero_icon_widget = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local content = arg_46_1.content
	local style = arg_46_1.style
	local animation_progress = content.animation_progress

	animation_progress = animation_progress or 0

	local num = 8

	if not arg_46_2 then
		animation_progress = math.min(animation_progress + arg_46_3 * num, 1)
	else
		animation_progress = math.max(animation_progress - arg_46_3 * num, 0)
	end

	local easeOutCubic = math.easeOutCubic(animation_progress)
	local easeInCubic = math.easeInCubic(animation_progress)
	local num_2 = 255 * animation_progress

	style.icon_highlight.color[1] = num_2
	content.animation_progress = animation_progress
end
