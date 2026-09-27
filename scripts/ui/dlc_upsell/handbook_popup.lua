-- chunkname: @scripts/ui/dlc_upsell/handbook_popup.lua

require("scripts/ui/helpers/handbook_logic")

local content_blueprints = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_handbook_definitions").content_blueprints
local var_0_1 = local_require("scripts/ui/dlc_upsell/handbook_popup_definitions")
local generic_input_actions = var_0_1.generic_input_actions
local var_0_3 = var_0_1.achievement_window_size[2]

HandbookPopup = class(HandbookPopup, CommonPopup)

HandbookPopup.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	HandbookPopup.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._input_manager = arg_1_1.input_manager
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	self._active_pages = arg_1_3.pages
	self._current_page = 1
	self._total_pages = #self._active_pages

	local var_1_0 = arg_1_3.pages[1]
	local SaveData = SaveData
	local seen_handbook_pages = SaveData.seen_handbook_pages

	seen_handbook_pages = seen_handbook_pages or {}
	SaveData.seen_handbook_pages = seen_handbook_pages
	SaveData.seen_handbook_pages[var_1_0] = true
	self._has_widget_been_closed = false
end

HandbookPopup.destroy = function (self)
	-- function 2
	HandbookPopup.super.destroy(self)
	self._handbook_logic:delete()
end

HandbookPopup.create_ui_elements = function (self)
	-- function 3
	HandbookPopup.super.create_ui_elements(self)

	local tbl = {
		scenegraph_id = "achievement_root",
		ui_renderer = self._ui_top_renderer,
		world = self._ui_context.world
	}

	self._handbook_logic = HandbookLogic:new(tbl, content_blueprints)
end

HandbookPopup.show = function (self)
	-- function 4
	HandbookPopup.super.show(self)
	self:_start_transition_animation("on_enter")
	self:play_sound("Play_gui_handbook_popup")
	self:set_fullscreen_effect_enable_state(true)
end

HandbookPopup.hide = function (self)
	-- function 5
	self:set_fullscreen_effect_enable_state(false)

	self._exit_anim_id = self:_start_transition_animation("on_exit")
end

HandbookPopup._start_transition_animation = function (self, arg_6_1)
	-- function 6
	return self._ui_animator:start_animation(arg_6_1, nil, var_0_1.scenegraph_definition, {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	})
end

HandbookPopup._update_animations = function (self, arg_7_1)
	-- function 7
	HandbookPopup.super._update_animations(self, arg_7_1)

	if not self._exit_anim_id and not self._ui_animator:is_animation_completed(self._exit_anim_id) then
		self._is_visible = false
	end

	local exit_button = self._widgets_by_name.exit_button

	UIWidgetUtils.animate_default_button(exit_button, arg_7_1)
end

HandbookPopup._handle_input = function (self, arg_8_1)
	-- function 8
	if not self._has_widget_been_closed then
		return
	end

	HandbookPopup.super._handle_input(self, arg_8_1)

	local _widgets_by_name = self._widgets_by_name
	local _get_input_service = self:_get_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	self:_set_gamepad_input_buttons_visibility(is_device_active)

	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_arrow_button(page_button_next, arg_8_1)
	UIWidgetUtils.animate_arrow_button(page_button_previous, arg_8_1)

	if UIUtils.is_button_hover_enter(page_button_next) or not UIUtils.is_button_hover_enter(page_button_previous) then
		self:play_sound("play_gui_inventory_next_hover")
	end

	if UIUtils.is_button_pressed(page_button_next) or not _get_input_service:get("cycle_next") then
		local num = self._current_page + 1

		if num <= self._total_pages then
			self:_go_to_page(num)
			self:play_sound("play_gui_cosmetics_inventory_next_click")
		end
	elseif UIUtils.is_button_pressed(page_button_previous) or not _get_input_service:get("cycle_previous") then
		local num_2 = self._current_page - 1

		if num_2 >= 1 then
			self:_go_to_page(num_2)
			self:play_sound("play_gui_cosmetics_inventory_next_click")
		end
	end

	if not self._content_widgets then
		self:_update_mouse_scroll_input()
	end

	if UIUtils.is_button_pressed(_widgets_by_name.exit_button) or _get_input_service:get("back", true) or not _get_input_service:get("toggle_menu", true) then
		self:hide()
		self:release_input()

		self._has_widget_been_closed = true

		self:play_sound("Play_hud_button_close")

		return
	end
end

HandbookPopup._go_to_page = function (self, arg_9_1)
	-- function 9
	local var_9_0 = self._active_pages[arg_9_1]
	local var_9_1 = HandbookSettings.pages[var_9_0]

	if not var_9_1 then
		return
	end

	local create_entry_widgets, var_9_3 = self._handbook_logic:create_entry_widgets(var_9_1)
	local num = var_9_3 + 150

	self._content_widgets = create_entry_widgets
	self._total_scroll_height = math.max(num - var_0_3, 0)
	self._scroll_value = nil

	self:_setup_scrollbar(num)

	self._current_page = arg_9_1

	self:_update_page_info()
end

HandbookPopup._update_page_info = function (self)
	-- function 10
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
	local var_10_5 = _menu_input_description
	local set_input_description = _menu_input_description.set_input_description
	local has_pages

	if not flag then
		has_pages = generic_input_actions.has_pages

		if not has_pages then
			-- Nothing
		end
	end

	has_pages = nil

	::label_10_0::

	set_input_description(var_10_5, has_pages)
end

HandbookPopup.should_show = function (self)
	-- function 11
	local is_in_inn = self._ui_context.is_in_inn

	is_in_inn = not is_in_inn and not not Managers.popup:has_popup() and not not self._is_visible or not Managers.unlock:is_waiting_for_gift_popup_ui()

	return is_in_inn
end

HandbookPopup.update = function (self, arg_12_1)
	-- function 12
	HandbookPopup.super.update(self, arg_12_1)

	if not (not self:should_show() and self._has_widget_been_closed) then
		self:show()
		self:_go_to_page(1)
	end
end

HandbookPopup._setup_scrollbar = function (self, arg_13_1, arg_13_2)
	-- function 13
	local achievement_scrollbar = self._widgets_by_name.achievement_scrollbar
	local scenegraph_id = achievement_scrollbar.scenegraph_id
	local var_13_2 = self._ui_scenegraph[scenegraph_id].size[2]
	local min = math.min(var_13_2 / arg_13_1, 1)

	achievement_scrollbar.content.scroll_bar_info.bar_height_percentage = min

	self:_set_scrollbar_value(arg_13_2 or 0)

	local num = 2
	local num_2 = math.max(110 / self._total_scroll_height, 0) * num

	self._widgets_by_name.achievement_window.content.scroll_amount = num_2
end

HandbookPopup._set_scrollbar_value = function (self, arg_14_1)
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

HandbookPopup._update_mouse_scroll_input = function (self)
	-- function 15
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

HandbookPopup._set_gamepad_input_buttons_visibility = function (self, arg_16_1)
	-- function 16
	local _widgets_by_name = self._widgets_by_name
	local flag = self._total_pages > 1

	arg_16_1 = not arg_16_1 and flag

	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local input_arrow_next = _widgets_by_name.input_arrow_next
	local input_arrow_previous = _widgets_by_name.input_arrow_previous

	input_icon_next.content.visible = arg_16_1
	input_icon_previous.content.visible = arg_16_1
	input_arrow_next.content.visible = arg_16_1
	input_arrow_previous.content.visible = arg_16_1
end
