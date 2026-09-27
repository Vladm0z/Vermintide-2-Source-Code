-- chunkname: @scripts/ui/views/popup_profile_picker.lua

local var_0_0 = local_require("scripts/ui/views/popup_profile_picker_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widget_definitions = var_0_0.widget_definitions
local hero_widget_definition = var_0_0.hero_widget_definition
local hero_icon_widget_definition = var_0_0.hero_icon_widget_definition

PopupProfilePicker = class(PopupProfilePicker)

PopupProfilePicker.init = function (self, arg_1_1, ...)
	-- function 1
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._ingame_ui = arg_1_1.ingame_ui
	self._wwise_world = arg_1_1.wwise_world
	self._render_settings = {
		snap_pixel_positions = true
	}

	local input_manager = arg_1_1.input_manager

	self._input_manager = input_manager

	input_manager:create_input_service("popup_profile_picker", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("popup_profile_picker", "keyboard")
	input_manager:map_device_to_service("popup_profile_picker", "mouse")
	input_manager:map_device_to_service("popup_profile_picker", "gamepad")

	local get_service = input_manager:get_service("popup_profile_picker")

	self._menu_input_desc = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, get_service, 5, 900, var_0_0.generic_input_actions.default)

	self._menu_input_desc:set_input_description(nil)
	self:_create_ui_elements()
	self:show(...)
end

PopupProfilePicker._create_ui_elements = function (self)
	-- function 2
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widget_definitions)
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	local get_interface = Managers.backend:get_interface("hero_attributes")
	local tbl = {}

	self._hero_widgets = tbl

	local tbl_2 = {}

	self._hero_icon_widgets = tbl_2
	self._num_max_hero_columns = #ProfilePriority
	self._num_max_career_columns = 4

	for i, v in ipairs(ProfilePriority) do
		local var_2_3 = SPProfiles[v]
		local display_name = var_2_3.display_name
		local get = get_interface:get(display_name, "experience")

		get = get or 0

		local get_level = ExperienceSettings.get_level(get)
		local var_2_7 = UIWidget.init(hero_icon_widget_definition)

		tbl_2[#tbl_2 + 1] = var_2_7
		var_2_7.offset[1] = (i - 1) * 124

		local hero_selection_image = var_2_3.hero_selection_image

		var_2_7.content.icon = hero_selection_image
	end

	for k = 1, 4 do
		local var_2_9 = UIWidget.init(hero_widget_definition)

		tbl[k] = var_2_9
		var_2_9.offset[1] = (k - 1) * 124 + 62
	end
end

PopupProfilePicker.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_update_occupied_profiles(arg_3_2)

	local _ui_top_renderer = self._ui_top_renderer
	local input_service = self:input_service()

	if not self._cancel_timer then
		self._cancel_timer = math.max(self._cancel_timer - arg_3_1, 0)

		local var_3_2 = tostring(math.ceil(self._cancel_timer))

		self:_set_timer_text(var_3_2)

		if self._cancel_timer <= 0 then
			local flag = false

			self:set_result(flag)
		end
	end

	self:_handle_input(arg_3_1, arg_3_2)
	self:draw(_ui_top_renderer, input_service, arg_3_1)
end

PopupProfilePicker._INPUT_DEVICES = {
	"keyboard",
	"gamepad",
	"mouse"
}

PopupProfilePicker.show = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	-- function 4
	self._join_lobby_result = nil
	self._makeshift_lobby_data = {}
	self._lobby_client = arg_4_6
	self._reserved_party_id = arg_4_7

	local _ingame_ui = self._ingame_ui
	local var_4_1 = _ingame_ui
	local handle_transition = _ingame_ui.handle_transition
	local flag

	flag = not arg_4_4 and "exit_menu" and "close_active"

	handle_transition(var_4_1, flag)
	ShowCursorStack.show("PopupProfilePicker")

	local flag_2 = arg_4_1 or 1
	local flag_3 = arg_4_2 or 1
	local flag_4 = true

	self:_select_hero(flag_2, flag_3, flag_4)

	self._cancel_timer = arg_4_3
	self._optional_locked_profile_index = arg_4_8

	self._input_manager:capture_input(self._INPUT_DEVICES, 1, "popup_profile_picker", "PopupProfilePicker")
	self:_play_sound("hud_hot_join_hero_popup")
end

PopupProfilePicker.hide = function (self)
	-- function 5
	self._input_manager:release_input(self._INPUT_DEVICES, 1, "popup_profile_picker", "PopupProfilePicker")
	ShowCursorStack.hide("PopupProfilePicker")

	self._selected_hero_name = nil
	self._selected_career_name = nil
	self._makeshift_lobby_data = nil

	self:_play_sound("hud_hot_join_hero_popup_stop")
end

PopupProfilePicker.input_service = function (self)
	-- function 6
	return self._input_manager:get_service("popup_profile_picker")
end

PopupProfilePicker.draw = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	UIRenderer.begin_pass(arg_7_1, self._ui_scenegraph, arg_7_2, arg_7_3, nil, self._render_settings)

	local _widgets = self._widgets

	for i, v in ipairs(_widgets) do
		UIRenderer.draw_widget(arg_7_1, v)
	end

	for k, v_2 in pairs(self._hero_widgets) do
		UIRenderer.draw_widget(arg_7_1, v_2)
	end

	for i_2, v_3 in ipairs(self._hero_icon_widgets) do
		UIRenderer.draw_widget(arg_7_1, v_3)
	end

	UIRenderer.end_pass(arg_7_1)

	if not Managers.input:is_device_active("gamepad") then
		self._menu_input_desc:draw(arg_7_1, arg_7_3)
	end
end

PopupProfilePicker.set_result = function (self, arg_8_1, arg_8_2)
	-- function 8
	local flag = not arg_8_1 and self._selected_hero_name
	local flag_2 = not arg_8_1 and self._selected_career_name

	if not arg_8_1 then
		self:_play_sound("hud_hot_join_hero_popup_accept")
	else
		self:_play_sound("hud_hot_join_hero_popup_decline")
	end

	self._join_lobby_result = {
		accepted = arg_8_1,
		selected_hero_name = flag,
		selected_career_name = flag_2,
		reason = arg_8_2
	}
end

PopupProfilePicker.query_result = function (self)
	-- function 9
	return self._join_lobby_result
end

PopupProfilePicker.destroy = function (arg_10_0)
	-- function 10
	return
end

PopupProfilePicker._handle_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _widgets_by_name = self._widgets_by_name
	local get_service = Managers.input:get_service("popup_profile_picker")

	self:_handle_mouse_selection()
	self:_handle_gamepad_selection(get_service)

	local select_button = _widgets_by_name.select_button
	local cancel_button = _widgets_by_name.cancel_button

	UIWidgetUtils.animate_default_button(select_button, arg_11_1)
	UIWidgetUtils.animate_default_button(cancel_button, arg_11_1)

	if UIUtils.is_button_hover_enter(select_button) or not UIUtils.is_button_hover_enter(cancel_button) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	if not self._selection_approved and UIUtils.is_button_pressed(_widgets_by_name.select_button) and not get_service:get("confirm", true) then
		self:_play_sound("play_gui_start_menu_button_click")
		self:set_result(true)
	elseif UIUtils.is_button_pressed(_widgets_by_name.cancel_button) or not get_service:get("back_menu", true) then
		self:_play_sound("play_gui_start_menu_button_click")
		self:set_result(false, "cancelled")
	end
end

PopupProfilePicker._handle_mouse_selection = function (self)
	-- function 12
	local _hero_icon_widgets = self._hero_icon_widgets

	for i = 1, #_hero_icon_widgets do
		local content = _hero_icon_widgets[i].content

		if not content.taken then
			local button_hotspot = content.button_hotspot

			if not button_hotspot.on_hover_enter then
				self:_play_sound("play_gui_hero_select_hero_hover")
			end

			if not (not button_hotspot.on_pressed and i == self._selected_hero_column) then
				local var_12_3 = ProfilePriority[i]
				local min = math.min(self._selected_career_index, #SPProfiles[var_12_3].careers)

				self:_select_hero(var_12_3, min)

				return
			end
		end
	end

	local _hero_widgets = self._hero_widgets

	for j = 1, #_hero_widgets do
		local content_2 = _hero_widgets[j].content

		if not (not content_2.exists and content_2.taken or content_2.locked) then
			local button_hotspot_2 = content_2.button_hotspot

			if not button_hotspot_2.on_hover_enter then
				self:_play_sound("play_gui_hero_select_career_hover")
			end

			if not (not button_hotspot_2.on_pressed and j == self._selected_career_column) then
				local _selected_profile_index = self._selected_profile_index
				local var_12_9 = j

				self:_select_hero(_selected_profile_index, var_12_9)

				return
			end
		end
	end
end

PopupProfilePicker._handle_gamepad_selection = function (self, arg_13_1)
	-- function 13
	local _num_max_hero_columns = self._num_max_hero_columns
	local _num_max_career_columns = self._num_max_career_columns
	local _selected_hero_column = self._selected_hero_column
	local _selected_career_column = self._selected_career_column

	if not _selected_hero_column and not _selected_career_column then
		local flag = false

		if not (_selected_hero_column > 1) or not arg_13_1:get("cycle_previous") then
			_selected_hero_column = _selected_hero_column - 1
			flag = true
		elseif not (_selected_hero_column < _num_max_hero_columns) or not arg_13_1:get("cycle_next") then
			_selected_hero_column = _selected_hero_column + 1
			flag = true
		end

		if not (_selected_career_column > 1) or not arg_13_1:get("move_left") then
			_selected_career_column = _selected_career_column - 1
			flag = true
		elseif not (_selected_career_column < _num_max_career_columns) or not arg_13_1:get("move_right") then
			_selected_career_column = _selected_career_column + 1
			flag = true
		end

		if not flag then
			local var_13_5 = ProfilePriority[_selected_hero_column]
			local var_13_6 = _selected_career_column

			self:_select_hero(var_13_5, var_13_6)
		end
	end
end

PopupProfilePicker._select_hero = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local var_14_0 = SPProfiles[arg_14_1]
	local var_14_1 = var_14_0.careers[arg_14_2]
	local get_interface = Managers.backend:get_interface("dlcs")

	if not var_14_1 and not get_interface:is_unreleased_career(var_14_1.name) then
		return
	end

	local display_name = var_14_0.display_name
	local character_name = var_14_0.character_name
	local name = var_14_1.name
	local display_name_2 = var_14_1.display_name
	local var_14_7 = Localize(character_name)
	local var_14_8 = Localize(display_name_2)
	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "experience")

	get = get or 0

	local get_level = ExperienceSettings.get_level(get)

	self:_set_hero_info(var_14_7, var_14_8, get_level)

	local _hero_widgets = self._hero_widgets
	local _num_max_hero_rows = self._num_max_hero_rows
	local _num_max_hero_columns = self._num_max_hero_columns

	self._selected_career_index = arg_14_2
	self._selected_profile_index = arg_14_1
	self._selected_hero_name = display_name
	self._selected_career_name = name
	self._selected_hero_column = ProfileIndexToPriorityIndex[arg_14_1]
	self._selected_career_column = arg_14_2

	self:_set_hero_icon_selected(self._selected_hero_column)

	local get_interface_2 = Managers.backend:get_interface("dlcs")

	for i, v in ipairs(self._hero_widgets) do
		local var_14_15 = var_14_0.careers[i]
		local content = v.content
		local flag = not var_14_15 and not get_interface_2:is_unreleased_career(var_14_15.name)

		content.exists = flag

		if not flag then
			content.career_settings = var_14_15

			local picking_image = var_14_15.picking_image

			picking_image = picking_image or "medium_" .. var_14_15.portrait_image
			content.portrait = picking_image

			local is_unlocked_function, var_14_20, var_14_21 = var_14_15:is_unlocked_function(display_name, get_level)

			content.locked = not is_unlocked_function

			if not var_14_21 then
				content.lock_texture = "hero_icon_locked_gold"
				content.frame = "menu_frame_12_gold"
			else
				content.lock_texture = "hero_icon_locked"
				content.frame = "menu_frame_12"
			end

			content.button_hotspot.is_selected = i == self._selected_career_column
		end
	end

	if not arg_14_3 then
		self:_play_sound("play_gui_hero_select_hero_click")
	end
end

PopupProfilePicker._set_hero_icon_selected = function (self, arg_15_1)
	-- function 15
	for i, v in ipairs(self._hero_icon_widgets) do
		v.content.button_hotspot.is_selected = i == arg_15_1
	end
end

PopupProfilePicker._set_hero_info = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.info_hero_name.content.text = arg_16_1
	_widgets_by_name.info_career_name.content.text = arg_16_2
	_widgets_by_name.info_hero_level.content.text = arg_16_3
end

PopupProfilePicker._set_timer_text = function (arg_17_0, arg_17_1)
	-- function 17
	arg_17_0._widgets_by_name.timer_text.content.text = arg_17_1
end

PopupProfilePicker.set_difficulty = function (self, arg_18_1)
	-- function 18
	self._difficulty = arg_18_1
end

local num = 2

PopupProfilePicker._update_occupied_profiles = function (self, arg_19_1)
	-- function 19
	if not self._lobby_client.request_data then
		local _request_timer = self._request_timer

		_request_timer = _request_timer or 0

		if _request_timer < arg_19_1 then
			self._lobby_client:request_data()

			self._request_timer = arg_19_1 + num
		end
	end

	local _makeshift_lobby_data = self._makeshift_lobby_data

	_makeshift_lobby_data.reserved_profiles = self._lobby_client:lobby_data("reserved_profiles")

	local _hero_widgets = self._hero_widgets
	local _hero_icon_widgets = self._hero_icon_widgets
	local flag = false

	for i = 1, #_hero_icon_widgets do
		local var_19_5
		local var_19_6 = ProfilePriority[i]
		local flag_2 = not ProfileSynchronizer.is_free_in_lobby(var_19_6, _makeshift_lobby_data, self._reserved_party_id)

		flag_2 = self._optional_locked_profile_index == var_19_6 or flag_2

		local content = _hero_icon_widgets[i].content
		local button_hotspot = content.button_hotspot

		content.taken = flag_2
	end

	local flag_3 = not ProfileSynchronizer.is_free_in_lobby(self._selected_profile_index, _makeshift_lobby_data, self._reserved_party_id)

	flag_3 = self._optional_locked_profile_index == self._selected_profile_index or flag_3

	for j = 1, #_hero_widgets do
		_hero_widgets[j].content.taken = flag_3
	end

	local content_2 = _hero_widgets[self._selected_career_column].content

	if not (not content_2.button_hotspot.is_selected and content_2.taken or content_2.locked) then
		flag = true
	end

	self:set_select_button_enable_state(flag)
end

PopupProfilePicker._animate_element_by_time = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	return (UIAnimation.init(UIAnimation.function_by_time, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, math.ease_out_quad))
end

PopupProfilePicker.set_select_button_enable_state = function (self, arg_21_1)
	-- function 21
	local content = self._widgets_by_name.select_button.content
	local var_21_1

	if not arg_21_1 then
		var_21_1 = Localize("input_description_confirm")

		if not var_21_1 then
			-- Nothing
		end
	end

	var_21_1 = Localize("dlc1_2_difficulty_unavailable")

	::label_21_0::

	content.title_text = var_21_1
	content.button_hotspot.disable_button = not arg_21_1
	self._selection_approved = arg_21_1

	if not arg_21_1 then
		self._menu_input_desc:set_input_description(var_0_0.generic_input_actions.confirm_available)
	else
		self._menu_input_desc:set_input_description(nil)
	end
end

PopupProfilePicker._play_sound = function (self, arg_22_1)
	-- function 22
	WwiseWorld.trigger_event(self._wwise_world, arg_22_1)
end
