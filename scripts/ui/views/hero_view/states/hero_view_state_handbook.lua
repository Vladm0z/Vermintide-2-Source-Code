-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_handbook.lua

require("scripts/ui/helpers/handbook_logic")
require("scripts/settings/handbook_settings")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_handbook_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local achievement_window_size = var_0_0.achievement_window_size
local category_tab_info = var_0_0.category_tab_info
local generic_input_actions = var_0_0.generic_input_actions
local console_cursor_definition = var_0_0.console_cursor_definition
local var_0_8 = achievement_window_size[2]

HeroViewStateHandbook = class(HeroViewStateHandbook)
HeroViewStateHandbook.NAME = "HeroViewStateHandbook"

HeroViewStateHandbook.on_enter = function (self, arg_1_1)
	-- function 1
	print("[HeroViewState] Enter Substate HeroViewStateHandbook")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._render_settings = {
		snap_pixel_positions = false
	}
	self._voting_manager = ingame_ui_context.voting_manager

	local SaveData = SaveData
	local seen_handbook_pages = SaveData.seen_handbook_pages

	seen_handbook_pages = seen_handbook_pages or {}
	SaveData.seen_handbook_pages = seen_handbook_pages

	local input_service = self:input_service()

	self._menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self._ui_top_renderer, input_service, 5, 100, generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)

	self._current_page = 1
	self._total_pages = 1

	self:play_sound("Play_gui_handbook_open")
	Managers.input:enable_gamepad_cursor()
	self:_create_ui_elements(arg_1_1)

	if not arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		self:_start_transition_animation("on_enter", "on_enter")
	end
end

HeroViewStateHandbook.on_exit = function (self, arg_2_1)
	-- function 2
	print("[HeroViewState] Exit Substate HeroViewStateHandbook")
	self._handbook_logic:delete()
	Managers.input:disable_gamepad_cursor()
end

HeroViewStateHandbook._create_ui_elements = function (self)
	-- function 3
	local count = #HandbookSettings.outline
	local create_category_tab_widgets_func = var_0_0.create_category_tab_widgets_func(count)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._console_cursor_widget = UIWidget.init(console_cursor_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._category_tab_widgets = UIUtils.create_widgets(create_category_tab_widgets_func)

	for k, v in pairs(self._category_tab_widgets) do
		self:_reset_tab(v)
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	self._category_scrollbar = ScrollBarLogic:new(self._widgets_by_name.category_scrollbar)

	local tbl = {
		scenegraph_id = "achievement_root",
		ui_renderer = self._ui_renderer,
		world = self._ingame_ui_context.world
	}

	self._handbook_logic = HandbookLogic:new(tbl, var_0_0.content_blueprints)

	self:_setup_layout()

	self._widgets_by_name.achievement_scrollbar.content.visible = true
	self._widgets_by_name.category_scrollbar.content.visible = true

	self:_update_categories_scroll_height(0)

	local var_3_3 = self._category_tab_widgets[1]

	self:_activate_tab(var_3_3, 1, 1, true)
end

HeroViewStateHandbook._reset_tabs = function (self)
	-- function 4
	for i, v in ipairs(self._category_tab_widgets) do
		self:_reset_tab(v)
	end
end

HeroViewStateHandbook._setup_layout = function (self)
	-- function 5
	local _category_tab_widgets = self._category_tab_widgets
	local count = #_category_tab_widgets
	local outline = HandbookSettings.outline

	for i = 1, count do
		local var_5_3 = _category_tab_widgets[i]

		self:_reset_tab(var_5_3)

		local var_5_4 = outline[i]

		if not var_5_4 then
			self:_setup_tab_widget(var_5_3, var_5_4)
		end
	end
end

HeroViewStateHandbook._setup_tab_widget = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local children = arg_6_2.children
	local content = arg_6_1.content

	content.title_text = Localize(arg_6_2.display_name)
	content.children = arg_6_2.children
	content.new = false

	if not children then
		local list_content = content.list_content
		local tab_list_entry_size = category_tab_info.tab_list_entry_size
		local count = #children

		content.tabs_height = tab_list_entry_size[2] * count

		for i = 1, count do
			local var_6_5 = children[i]
			local var_6_6 = var_6_5[1]
			local var_6_7 = HandbookSettings.pages[var_6_6]
			local flag = not SaveData.seen_handbook_pages[var_6_6]

			if not flag then
				content.new = true
			end

			local var_6_9 = list_content[i]

			var_6_9.text = Localize(var_6_7.display_name)
			var_6_9.new = flag
			var_6_9.pages = var_6_5
		end

		arg_6_1.style.list_style.num_draws = count
	end

	arg_6_1.content.visible = true
end

HeroViewStateHandbook._reset_tab = function (arg_7_0, arg_7_1)
	-- function 7
	local content = arg_7_1.content
	local list_style = arg_7_1.style.list_style

	content.active = false
	content.list_content.active = false
	content.button_hotspot.is_selected = false
	content.visible = false
	content.new = false
	list_style.num_draws = 0

	local scenegraph_id = list_style.scenegraph_id

	arg_7_0._ui_scenegraph[scenegraph_id].size[2] = 0
	arg_7_1.alpha_multiplier = 0
	arg_7_1.alpha_fade_in_delay = nil
	arg_7_1.alpha_fade_multipler = 5
end

HeroViewStateHandbook._update_categories_scroll_height = function (self, arg_8_1)
	-- function 8
	local size = scenegraph_definition.category_window_mask.size
	local size_2 = scenegraph_definition.category_scrollbar.size
	local _category_scrollbar = self._category_scrollbar
	local var_8_3 = size[2]
	local _get_category_entries_height = self:_get_category_entries_height()
	local var_8_5 = size_2[2]
	local num = 220
	local num_2 = 1

	_category_scrollbar:set_scrollbar_values(var_8_3, _get_category_entries_height, var_8_5, num, num_2)

	if not arg_8_1 then
		_category_scrollbar:set_scroll_percentage(arg_8_1)
	end
end

HeroViewStateHandbook._get_category_entries_height = function (self)
	-- function 9
	local count = #self._category_tab_widgets
	local tab_size = category_tab_info.tab_size
	local tab_list_entry_spacing = category_tab_info.tab_list_entry_spacing

	return math.max(tab_size[2] * count + tab_list_entry_spacing * (count - 1), 0) + self:_get_active_tabs_height()
end

HeroViewStateHandbook._get_active_tabs_height = function (self)
	-- function 10
	local _active_tab = self._active_tab
	local num_draws

	if not _active_tab then
		num_draws = _active_tab.style.list_style.num_draws

		if not num_draws then
			-- Nothing
		end
	end

	num_draws = 0

	::label_10_0::

	local tab_list_entry_size = category_tab_info.tab_list_entry_size
	local tab_list_entry_spacing = category_tab_info.tab_list_entry_spacing

	return (math.max(tab_list_entry_size[2] * num_draws + tab_list_entry_spacing * (num_draws - 1), 0))
end

HeroViewStateHandbook._get_active_category_height = function (self)
	-- function 11
	local _active_tab_index = self._active_tab_index

	_active_tab_index = _active_tab_index or 1

	local num = _active_tab_index - 1
	local tab_size = category_tab_info.tab_size
	local tab_list_entry_spacing = category_tab_info.tab_list_entry_spacing
	local max = math.max(tab_size[2] * num + tab_list_entry_spacing * (num - 1), 0)
	local _get_active_tabs_height = self:_get_active_tabs_height()

	return max, tab_size[2] + tab_list_entry_spacing + _get_active_tabs_height
end

HeroViewStateHandbook._setup_scrollbar = function (self, arg_12_1, arg_12_2)
	-- function 12
	local achievement_scrollbar = self._widgets_by_name.achievement_scrollbar
	local scenegraph_id = achievement_scrollbar.scenegraph_id
	local var_12_2 = self._ui_scenegraph[scenegraph_id].size[2]
	local min = math.min(var_12_2 / arg_12_1, 1)

	achievement_scrollbar.content.scroll_bar_info.bar_height_percentage = min

	self:_set_scrollbar_value(arg_12_2 or 0)

	local num = 2
	local num_2 = math.max(110 / self._total_scroll_height, 0) * num

	self._widgets_by_name.achievement_window.content.scroll_amount = num_2
end

HeroViewStateHandbook._update_mouse_scroll_input = function (self)
	-- function 13
	local flag = true

	if not flag then
		local _widgets_by_name = self._widgets_by_name
		local achievement_scrollbar = _widgets_by_name.achievement_scrollbar
		local achievement_window = _widgets_by_name.achievement_window

		if not achievement_scrollbar.content.scroll_bar_info.on_pressed then
			achievement_window.content.scroll_add = nil
		end

		local scroll_value = achievement_window.content.scroll_value

		if not scroll_value then
			return
		end

		local value = achievement_scrollbar.content.scroll_bar_info.value
		local _scroll_value = self._scroll_value

		if _scroll_value ~= scroll_value then
			self:_set_scrollbar_value(scroll_value)
		elseif _scroll_value ~= value then
			self:_set_scrollbar_value(value)
		end
	end
end

HeroViewStateHandbook._set_scrollbar_value = function (self, arg_14_1)
	-- function 14
	if not arg_14_1 then
		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.achievement_scrollbar.content.scroll_bar_info.value = arg_14_1
		_widgets_by_name.achievement_window.content.scroll_value = arg_14_1

		local num = self._total_scroll_height * arg_14_1

		self._ui_scenegraph.achievement_root.position[2] = math.floor(num)
		self._scroll_value = arg_14_1
	end
end

HeroViewStateHandbook._update_achievement_read_index = function (arg_15_0, arg_15_1)
	-- function 15
	return
end

HeroViewStateHandbook._update_category_scroll_position = function (self)
	-- function 16
	local get_scrolled_length = self._category_scrollbar:get_scrolled_length()

	if get_scrolled_length ~= self._category_scrolled_length then
		self._ui_scenegraph.category_root.local_position[2] = math.round(get_scrolled_length)
		self._category_scrolled_length = get_scrolled_length
	end
end

HeroViewStateHandbook._setup_achievement_entries_animations = function (self)
	-- function 17
	local num = 0.05
	local num_2 = 0
	local num_3 = 4
	local _achievement_widgets = self._achievement_widgets

	for i, v in ipairs(_achievement_widgets) do
		v.alpha_multiplier = 0
		v.alpha_fade_in_delay = num_2
		v.alpha_fade_multipler = num_3
		num_2 = num_2 + num
	end
end

HeroViewStateHandbook.transitioning = function (self)
	-- function 18
	return not not self._exiting
end

HeroViewStateHandbook._update_transition_timer = function (self, arg_19_1)
	-- function 19
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_19_1, 0)
	end
end

HeroViewStateHandbook.input_service = function (self)
	-- function 20
	return self.parent:input_service()
end

HeroViewStateHandbook.update = function (self, arg_21_1, arg_21_2)
	-- function 21
	local FAKE_INPUT_SERVICE

	if not self._input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_21_0::

	local is_device_active = Managers.input:is_device_active("gamepad")

	self._ui_animator:update(arg_21_1)

	local exit_button = self._widgets_by_name.exit_button

	UIWidgetUtils.animate_default_button(exit_button, arg_21_1)

	local parent = self.parent
	local transitioning = parent:transitioning()
	local wanted_state = parent:wanted_state()

	if not self._transition_timer then
		if not transitioning then
			if not self:_has_active_level_vote() then
				local flag = true

				self:close_menu(flag)
			else
				self:_handle_input(FAKE_INPUT_SERVICE, is_device_active, arg_21_1, arg_21_2)
			end
		end

		local flag_2 = wanted_state or self._new_state

		if not flag_2 then
			parent:clear_wanted_state()

			return flag_2
		end
	end

	if not self._exiting then
		return
	end

	self:draw(FAKE_INPUT_SERVICE, is_device_active, arg_21_1)
end

HeroViewStateHandbook._has_active_level_vote = function (self)
	-- function 22
	local _voting_manager = self._voting_manager
	local vote_in_progress = _voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and _voting_manager:is_mission_vote()

	return not vote_in_progress and not _voting_manager:has_voted(Network.peer_id())
end

HeroViewStateHandbook._handle_input = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local _widgets_by_name = self._widgets_by_name
	local exit_button = _widgets_by_name.exit_button
	local get = arg_23_1:get("toggle_menu")
	local flag = not arg_23_2 and arg_23_1:get("back")

	if get or UIUtils.is_button_pressed(exit_button) or not flag then
		self:play_sound("Play_hud_hover")
		self:close_menu()

		self._exiting = true

		return
	end

	if not UIUtils.is_button_hover_enter(exit_button) then
		self:play_sound("play_gui_equipment_button_hover")
	end

	self._category_scrollbar:update(arg_23_3, arg_23_4, false)
	self:_update_category_scroll_position()

	for i, v in ipairs(self._category_tab_widgets) do
		if not v.content.visible then
			UIWidgetUtils.animate_default_button(v, arg_23_3)

			if not UIUtils.is_button_hover_enter(v) then
				self:play_sound("Play_gui_achivements_menu_hover_category")
			end

			if not UIUtils.is_button_pressed(v) then
				self:_tab_pressed(v, i)
			end
		end
	end

	local _active_tab = self._active_tab

	if not _active_tab then
		local list_content = _active_tab.content.list_content
		local num_draws = _active_tab.style.list_style.num_draws
		local _active_list_index = self._active_list_index

		for k = 1, num_draws do
			local var_23_8 = list_content[k]
			local button_hotspot = var_23_8.button_hotspot

			button_hotspot = button_hotspot or var_23_8.hotspot

			if not button_hotspot.on_hover_enter then
				self:play_sound("Play_gui_achivements_menu_hover_category")
			end

			if not button_hotspot.on_release then
				button_hotspot.on_release = false

				self:_on_tab_list_pressed(k, var_23_8, var_23_8.pages)
			end

			button_hotspot.is_selected = _active_list_index == k
		end
	end

	if not self._achievement_widgets then
		self:_update_mouse_scroll_input()
	end

	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	self:_set_gamepad_input_buttons_visibility(arg_23_2)
	UIWidgetUtils.animate_arrow_button(page_button_next, arg_23_3)
	UIWidgetUtils.animate_arrow_button(page_button_previous, arg_23_3)

	if UIUtils.is_button_hover_enter(page_button_next) or not UIUtils.is_button_hover_enter(page_button_previous) then
		self:play_sound("play_gui_inventory_next_hover")
	end

	if UIUtils.is_button_pressed(page_button_next) or not arg_23_1:get("cycle_next") then
		local num = self._current_page + 1

		if num <= self._total_pages then
			self:_go_to_page(num)
			self:play_sound("play_gui_cosmetics_inventory_next_click")
		end
	elseif UIUtils.is_button_pressed(page_button_previous) or not arg_23_1:get("cycle_previous") then
		local num_2 = self._current_page - 1

		if num_2 >= 1 then
			self:_go_to_page(num_2)
			self:play_sound("play_gui_cosmetics_inventory_next_click")
		end
	end
end

HeroViewStateHandbook._go_to_page = function (self, arg_24_1)
	-- function 24
	local var_24_0 = self._active_pages[arg_24_1]
	local var_24_1 = HandbookSettings.pages[var_24_0]

	if not var_24_1 then
		return
	end

	local create_entry_widgets, var_24_3 = self._handbook_logic:create_entry_widgets(var_24_1)
	local num = var_24_3 + 150

	self._achievement_widgets = create_entry_widgets
	self._total_scroll_height = math.max(num - var_0_8, 0)
	self._scroll_value = nil

	self:_setup_scrollbar(num)
	self:_setup_achievement_entries_animations()

	self._current_page = arg_24_1

	self:_update_page_info()
end

HeroViewStateHandbook._on_tab_list_pressed = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	if arg_25_1 == self._active_list_index then
		return
	end

	self._active_pages = arg_25_3
	self._active_list_index = arg_25_1
	self._total_pages = #arg_25_3

	self:_go_to_page(1)

	if not arg_25_2.new then
		arg_25_2.new = false

		local var_25_0 = arg_25_3[1]

		SaveData.seen_handbook_pages[var_25_0] = true

		local flag = false

		for i, v in ipairs(arg_25_2.parent.list_content) do
			if not v.new then
				flag = true

				break
			end
		end

		arg_25_2.parent.new = flag
	end

	if not arg_25_4 then
		self:play_sound("Play_gui_handbook_click")
	end
end

HeroViewStateHandbook._tab_pressed = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local flag = self._active_tab == arg_26_1

	self:_deactivate_active_tab()

	if not flag then
		self:_activate_tab(arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	end
end

HeroViewStateHandbook._activate_tab = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	self._active_tab = arg_27_1
	self._active_tab_index = arg_27_2

	local content = arg_27_1.content
	local list_style = arg_27_1.style.list_style
	local num_draws = list_style.num_draws
	local scenegraph_id = list_style.scenegraph_id
	local var_27_4 = self._ui_scenegraph[scenegraph_id]
	local tab_active_size = category_tab_info.tab_active_size
	local tab_list_entry_size = category_tab_info.tab_list_entry_size
	local tab_list_entry_spacing = category_tab_info.tab_list_entry_spacing
	local max = math.max(tab_list_entry_size[2] * num_draws + tab_list_entry_spacing * (num_draws - 1), 0)

	var_27_4.size[1] = tab_active_size[1]
	var_27_4.size[2] = max
	content.button_hotspot.is_selected = true
	content.active = true
	content.list_content.active = true
	self._active_list_index = nil
	arg_27_3 = arg_27_3 or 1

	if not arg_27_3 then
		local var_27_9 = content.children[arg_27_3]
		local var_27_10 = content.list_content[arg_27_3]

		var_27_10.parent = content

		self:_on_tab_list_pressed(arg_27_3, var_27_10, var_27_9, true)

		if not arg_27_4 then
			self:play_sound("Play_gui_achivements_menu_select_category")
		end
	else
		self._active_list_index = nil

		if not arg_27_4 then
			self:play_sound("Play_gui_achivements_menu_expand_category")
		end
	end

	self:_update_categories_scroll_height()
end

HeroViewStateHandbook._deactivate_active_tab = function (self)
	-- function 28
	local _active_tab = self._active_tab

	if not _active_tab then
		return
	end

	self._active_tab = nil
	self._active_tab_index = nil

	local content = _active_tab.content
	local scenegraph_id = _active_tab.style.list_style.scenegraph_id
	local var_28_3 = self._ui_scenegraph[scenegraph_id]
	local tab_size = category_tab_info.tab_size

	var_28_3.size[1] = tab_size[1]
	var_28_3.size[2] = 0
	content.active = false
	content.list_content.active = false
	content.button_hotspot.is_selected = false
end

HeroViewStateHandbook.close_menu = function (self, arg_29_1)
	-- function 29
	if not arg_29_1 then
		self:play_sound("Play_gui_achivements_menu_close")
	end

	arg_29_1 = true

	local flag = true

	self.parent:close_menu(nil, arg_29_1, flag)
end

HeroViewStateHandbook._update_page_info = function (self)
	-- function 30
	local _widgets_by_name = self._widgets_by_name
	local _current_page = self._current_page
	local _total_pages = self._total_pages

	_widgets_by_name.page_text_left.content.text = tostring(_current_page)
	_widgets_by_name.page_text_right.content.text = tostring(_total_pages)
	_widgets_by_name.page_button_next.content.hotspot.disable_button = _current_page == _total_pages
	_widgets_by_name.page_button_previous.content.hotspot.disable_button = _current_page == 1

	local flag = _total_pages > 1

	_widgets_by_name.page_button_next.content.visible = flag
	_widgets_by_name.page_button_previous.content.visible = flag
	_widgets_by_name.input_icon_next.content.visible = flag
	_widgets_by_name.input_icon_previous.content.visible = flag
	_widgets_by_name.input_arrow_next.content.visible = flag
	_widgets_by_name.input_arrow_previous.content.visible = flag
	_widgets_by_name.page_text_center.content.visible = flag
	_widgets_by_name.page_text_left.content.visible = flag
	_widgets_by_name.page_text_right.content.visible = flag
	_widgets_by_name.page_text_area.content.visible = flag

	local _menu_input_description = self._menu_input_description
	local var_30_5 = _menu_input_description
	local set_input_description = _menu_input_description.set_input_description
	local has_pages

	if not flag then
		has_pages = generic_input_actions.has_pages

		if not has_pages then
			-- Nothing
		end
	end

	has_pages = nil

	::label_30_0::

	set_input_description(var_30_5, has_pages)
end

HeroViewStateHandbook._set_gamepad_input_buttons_visibility = function (self, arg_31_1)
	-- function 31
	local _widgets_by_name = self._widgets_by_name
	local flag = self._total_pages > 1

	arg_31_1 = not arg_31_1 and flag

	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local input_arrow_next = _widgets_by_name.input_arrow_next
	local input_arrow_previous = _widgets_by_name.input_arrow_previous

	input_icon_next.content.visible = arg_31_1
	input_icon_previous.content.visible = arg_31_1
	input_arrow_next.content.visible = arg_31_1
	input_arrow_previous.content.visible = arg_31_1
end

HeroViewStateHandbook.draw = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, arg_32_1, arg_32_3, nil, _render_settings)

	local snap_pixel_positions = _render_settings.snap_pixel_positions
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	for i, v in ipairs(self._widgets) do
		if v.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = v.snap_pixel_positions
		end

		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(_ui_renderer, v)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	local _achievement_widgets = self._achievement_widgets

	if not _achievement_widgets then
		for k = 1, #_achievement_widgets do
			local var_32_8 = _achievement_widgets[k]

			if var_32_8.snap_pixel_positions ~= nil then
				_render_settings.snap_pixel_positions = var_32_8.snap_pixel_positions
			end

			local alpha_multiplier_3 = var_32_8.alpha_multiplier
			local alpha_fade_in_delay = var_32_8.alpha_fade_in_delay

			if not alpha_fade_in_delay then
				local max = math.max(alpha_fade_in_delay - arg_32_3, 0)

				if max > 0 then
					var_32_8.alpha_fade_in_delay = max
				else
					var_32_8.alpha_fade_in_delay = nil
				end

				_render_settings.alpha_multiplier = 0
			elseif not alpha_multiplier_3 then
				local alpha_fade_multipler = var_32_8.alpha_fade_multipler

				alpha_fade_multipler = alpha_fade_multipler or 1

				local min = math.min(alpha_multiplier_3 + arg_32_3 * alpha_fade_multipler, 1)

				_render_settings.alpha_multiplier = math.easeInCubic(min)
				var_32_8.alpha_multiplier = min
				var_32_8.offset[1] = -40 * (1 - min)
			end

			UIRenderer.draw_widget(_ui_renderer, var_32_8)

			_render_settings.snap_pixel_positions = snap_pixel_positions
		end
	end

	for i_2, v_2 in ipairs(self._category_tab_widgets) do
		if v_2.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = v_2.snap_pixel_positions
		end

		local alpha_multiplier_4 = v_2.alpha_multiplier
		local alpha_fade_in_delay_2 = v_2.alpha_fade_in_delay

		if not alpha_fade_in_delay_2 then
			local max_2 = math.max(alpha_fade_in_delay_2 - arg_32_3, 0)

			if max_2 > 0 then
				v_2.alpha_fade_in_delay = max_2
			else
				v_2.alpha_fade_in_delay = nil
			end

			_render_settings.alpha_multiplier = 0
		elseif not alpha_multiplier_4 then
			local alpha_fade_multipler_2 = v_2.alpha_fade_multipler

			alpha_fade_multipler_2 = alpha_fade_multipler_2 or 1

			local min_2 = math.min(alpha_multiplier_4 + arg_32_3 * alpha_fade_multipler_2, 1)

			_render_settings.alpha_multiplier = math.easeInCubic(min_2)
			v_2.alpha_multiplier = min_2
		end

		UIRenderer.draw_widget(_ui_renderer, v_2)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(_ui_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier

	if not arg_32_2 then
		self._menu_input_description:draw(_ui_top_renderer, arg_32_3)
		UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, arg_32_1, arg_32_3)
		UIRenderer.draw_widget(_ui_top_renderer, self._console_cursor_widget)
		UIRenderer.end_pass(_ui_top_renderer)
	end
end

HeroViewStateHandbook.play_sound = function (self, arg_33_1)
	-- function 33
	self.parent:play_sound(arg_33_1)
end

HeroViewStateHandbook._start_transition_animation = function (self, arg_34_1, arg_34_2)
	-- function 34
	local tbl = {
		wwise_world = self._ingame_ui_context.wwise_world,
		render_settings = self._render_settings
	}
	local var_34_1

	self._ui_animator:start_animation(arg_34_2, var_34_1, scenegraph_definition, tbl)
end

HeroViewStateHandbook.block_input = function (self)
	-- function 35
	self._input_blocked = true
end

HeroViewStateHandbook.unblock_input = function (self)
	-- function 36
	self._input_blocked = false
end

HeroViewStateHandbook.input_blocked = function (self)
	-- function 37
	return self._input_blocked
end
