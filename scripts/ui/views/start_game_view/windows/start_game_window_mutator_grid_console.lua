-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_grid_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_grid_console_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local overlay_widgets = var_0_0.overlay_widgets
local delete_deeds_button_widgets = var_0_0.delete_deeds_button_widgets
local str = "confirm_press"
local tbl = {
	{
		wield = true,
		name = "heroic_deeds",
		display_name = "heroic_deeds",
		item_filter = "slot_type == deed",
		hero_specific_filter = false,
		item_types = {
			"deed"
		},
		icon = UISettings.slot_icons.melee
	}
}
local enum = table.enum("clear", "delete_selected")

local function fn(self, arg_1_1)
	-- function 1
	local data = self.data
	local data_2 = arg_1_1.data
	local rarity = self.rarity

	rarity = rarity or data.rarity

	local rarity_2 = arg_1_1.rarity

	rarity_2 = rarity_2 or data_2.rarity

	local item_rarity_order = UISettings.item_rarity_order
	local var_1_5 = item_rarity_order[rarity]
	local var_1_6 = item_rarity_order[rarity_2]
	local backend_id = self.backend_id
	local backend_id_2 = arg_1_1.backend_id
	local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

	if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_1_1) then
		if var_1_5 == var_1_6 then
			local var_1_10 = Localize(data.item_type)
			local var_1_11 = Localize(data_2.item_type)

			if var_1_10 == var_1_11 then
				local get_ui_information_from_item, var_1_13 = UIUtils.get_ui_information_from_item(self)
				local get_ui_information_from_item_2, var_1_15 = UIUtils.get_ui_information_from_item(arg_1_1)

				return Localize(var_1_13) < Localize(var_1_15)
			else
				return var_1_10 < var_1_11
			end
		else
			return var_1_5 < var_1_6
		end
	elseif not is_favorite_backend_id then
		return true
	else
		return false
	end
end

local str_2 = "trigger_cycle_next"
local str_3 = "trigger_cycle_previous"

StartGameWindowMutatorGridConsole = class(StartGameWindowMutatorGridConsole)
StartGameWindowMutatorGridConsole.NAME = "StartGameWindowMutatorGridConsole"

StartGameWindowMutatorGridConsole.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorGridConsole")

	self.parent = arg_2_1.parent

	local ingame_ui_context = arg_2_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._deeds_marked_for_deletion = {}
	self._animations = {}

	self:create_ui_elements(arg_2_1, arg_2_2)

	self._previously_selected_backend_id = self.parent:get_selected_heroic_deed_backend_id()

	if not Managers.backend:get_interface("items"):get_item_from_id(self._previously_selected_backend_id) then
		self._previously_selected_backend_id = nil

		self.parent:set_selected_heroic_deed_backend_id(nil)
	end

	local str = "empire_soldier"
	local num = 1
	local var_2_4 = ItemGridUI:new(tbl, self._widgets_by_name.item_grid, str, num)

	var_2_4:change_category("heroic_deeds")
	var_2_4:disable_item_drag()
	var_2_4:apply_item_sorting_function(fn)

	local mechanism = Managers.mechanism

	mechanism = not mechanism and Managers.mechanism:mechanism_setting_for_title("override_levels")

	if not mechanism then
		local items = var_2_4:items()

		for i = 1, #items do
			local var_2_7 = items[i]

			if mechanism[var_2_7.level_key] == false then
				var_2_4:lock_item_by_id(var_2_7.backend_id, true)
			end
		end

		var_2_4:mark_locked_items(true)
		var_2_4:disable_locked_items(true)
	end

	self:_setup_input_buttons()

	self._item_grid = var_2_4

	self.parent:set_input_description("select_heroic_deed")
	self:_start_transition_animation("on_enter")

	if not Managers.input:is_device_active("gamepad") then
		self.parent:set_selected_heroic_deed_backend_id(nil)
	end

	self._deed_manager = Managers.deed
	self._can_delete_deeds = false
end

StartGameWindowMutatorGridConsole._start_transition_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_3_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_3_1] = start_animation
end

StartGameWindowMutatorGridConsole.create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._overlay_widgets, self._overlay_widgets_by_name = UIUtils.create_widgets(overlay_widgets)
	self._delete_deeds_buttons_widgets, self._delete_deeds_buttons_widgets_by_name = UIUtils.create_widgets(delete_deeds_button_widgets)

	if not GameSettingsDevelopment.read_only_backend then
		local _delete_deeds_buttons_widgets_by_name = self._delete_deeds_buttons_widgets_by_name

		_delete_deeds_buttons_widgets_by_name.button_delete.content.button_hotspot.disable_button = true
		_delete_deeds_buttons_widgets_by_name.button_clear.content.button_hotspot.disable_button = true
	end

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end
end

StartGameWindowMutatorGridConsole.on_exit = function (self, arg_5_1)
	-- function 5
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorGridConsole")

	self.ui_animator = nil

	self._item_grid:destroy()

	self._item_grid = nil

	self.parent:set_input_description(nil)

	if not (not self._previously_selected_backend_id and self._selected_backend_id or self._confirm_selection) then
		self.parent:set_selected_heroic_deed_backend_id(self._previously_selected_backend_id)
	end

	self._confirm_selection = nil
end

StartGameWindowMutatorGridConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._item_grid:update(arg_6_1, arg_6_2)
	self:_update_animations(arg_6_1)
	self:_update_page_info()
	self:_update_selected_item_backend_id()
	self:_handle_input(arg_6_1, arg_6_2)
	self:_handle_gamepad_activity()
	self:draw(arg_6_1)
	self:_update_on_removal_state(arg_6_2)

	local _popup_id = self._popup_id

	if not _popup_id then
		local query_result = Managers.popup:query_result(_popup_id)

		if not query_result then
			if query_result == "yes" then
				self:_handle_deeds_deletion()
			end

			self._popup_id = nil
		end
	end
end

StartGameWindowMutatorGridConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowMutatorGridConsole._update_animations = function (self, arg_8_1)
	-- function 8
	local ui_animator = self.ui_animator

	ui_animator:update(arg_8_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name
	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_arrow_button(page_button_next, arg_8_1)
	UIWidgetUtils.animate_arrow_button(page_button_previous, arg_8_1)
end

StartGameWindowMutatorGridConsole._handle_input = function (self, arg_9_1, arg_9_2)
	-- function 9
	local window_input_service = self.parent:window_input_service()
	local _item_grid = self._item_grid

	if not _item_grid:handle_gamepad_selection(window_input_service) then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_equipment_selection_hover")
	end

	local is_device_active = Managers.input:is_device_active("gamepad")
	local var_9_3
	local var_9_4

	if not is_device_active then
		local get_selected_item_grid_slot, var_9_6 = _item_grid:get_selected_item_grid_slot()

		var_9_3 = _item_grid:get_item_in_slot(get_selected_item_grid_slot, var_9_6)
		var_9_4 = _item_grid:get_item_content(get_selected_item_grid_slot, var_9_6)
	else
		local get_item_hovered_slot, var_9_8 = _item_grid:get_item_hovered_slot()

		var_9_3 = _item_grid:get_item_hovered()
		var_9_4 = _item_grid:get_item_content(get_item_hovered_slot, var_9_8)
	end

	if (not var_9_3 and var_9_3.marked_for_deletion or not window_input_service) and window_input_service:get("right_stick_press") and not window_input_service:get("mouse_middle_press") then
		var_9_3.marked_for_deletion = true
		var_9_4.reserved = true

		table.insert(self._deeds_marked_for_deletion, var_9_3)
		self:_play_sound("hud_deed_delete_select")
	elseif not var_9_3 and not var_9_3.marked_for_deletion and not window_input_service and window_input_service:get("right_stick_press") and not window_input_service:get("mouse_middle_press") then
		var_9_3.marked_for_deletion = false
		var_9_4.reserved = false

		local index_of = table.index_of(self._deeds_marked_for_deletion, var_9_3)

		table.swap_delete(self._deeds_marked_for_deletion, index_of)
		self:_play_sound("hud_deed_delete_select")
	end

	local selected_item = _item_grid:selected_item()

	if not (not selected_item and selected_item.backend_id == self._selected_backend_id) then
		self.parent:set_selected_heroic_deed_backend_id(selected_item.backend_id)
	end

	local flag = true
	local is_item_pressed = _item_grid:is_item_pressed(flag)

	if not is_item_pressed then
		self:_play_sound("play_gui_lobby_button_04_heroic_deed_inventory_click")

		local backend_id = is_item_pressed.backend_id

		self.parent:set_selected_heroic_deed_backend_id(backend_id)

		self._selected_backend_id = backend_id
		self._confirm_selection = true

		self.parent:set_layout_by_name("heroic_deeds")
	end

	local _widgets_by_name = self._widgets_by_name
	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	if UIUtils.is_button_hover_enter(page_button_next) or not UIUtils.is_button_hover_enter(page_button_previous) then
		self:_play_sound("play_gui_inventory_next_hover")
	end

	local _current_page = self._current_page

	if UIUtils.is_button_pressed(page_button_next) or not window_input_service:get(str_2) then
		_current_page = math.min(_current_page + 1, self._total_pages)
	elseif UIUtils.is_button_pressed(page_button_previous) or not window_input_service:get(str_3) then
		_current_page = math.max(_current_page - 1, 1)
	end

	if _current_page ~= self._current_page then
		_item_grid:set_item_page(_current_page)
		self:_play_sound("play_gui_equipment_inventory_next_click")

		local get_item_in_slot = self._item_grid:get_item_in_slot(1, 1)

		if not get_item_in_slot then
			self.parent:set_selected_heroic_deed_backend_id(get_item_in_slot.backend_id)
		end
	end

	local button_clear = self._delete_deeds_buttons_widgets_by_name.button_clear

	if not UIUtils.is_button_hover_enter(button_clear) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	if UIUtils.is_button_pressed(button_clear) or not window_input_service:get("refresh") then
		self._popup_id = Managers.popup:queue_popup(Localize("delete_deeds_popup_warning_message"), Localize("popup_discard_changes_topic"), "yes", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		self._delete_type = enum.clear

		self.parent:set_selected_heroic_deed_backend_id(nil)
	end

	local button_delete = self._delete_deeds_buttons_widgets_by_name.button_delete

	if not UIUtils.is_button_hover_enter(button_delete) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	if not ((UIUtils.is_button_pressed(button_delete) or not window_input_service:get("special_1")) and table.is_empty(self._deeds_marked_for_deletion)) then
		self._popup_id = Managers.popup:queue_popup(Localize("delete_deeds_popup_warning_message"), Localize("popup_discard_changes_topic"), "yes", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		self._delete_type = enum.delete_selected

		self.parent:set_selected_heroic_deed_backend_id(nil)
	end

	UIWidgetUtils.animate_default_button(button_clear, arg_9_1)
	UIWidgetUtils.animate_default_button(button_delete, arg_9_1)

	if not window_input_service:get(str) then
		self._confirm_selection = true

		self.parent:set_layout_by_name("heroic_deeds")
	end
end

StartGameWindowMutatorGridConsole._play_sound = function (self, arg_10_1)
	-- function 10
	self.parent:play_sound(arg_10_1)
end

StartGameWindowMutatorGridConsole._update_selected_item_backend_id = function (self)
	-- function 11
	local is_device_active = Managers.input:is_device_active("mouse")
	local parent = self.parent
	local _item_grid = self._item_grid

	if not is_device_active then
		local get_selected_heroic_deed_backend_id = parent:get_selected_heroic_deed_backend_id()

		if get_selected_heroic_deed_backend_id ~= self._selected_backend_id then
			self._selected_backend_id = get_selected_heroic_deed_backend_id

			_item_grid:set_backend_id_selected(get_selected_heroic_deed_backend_id)
		elseif not get_selected_heroic_deed_backend_id then
			local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

			if not get_item_in_slot then
				parent:set_selected_heroic_deed_backend_id(get_item_in_slot.backend_id)
			end
		end
	else
		local get_item_hovered = _item_grid:get_item_hovered()
		local flag = not get_item_hovered and get_item_hovered.backend_id

		if flag ~= self._selected_backend_id then
			self._selected_backend_id = flag

			parent:set_selected_heroic_deed_backend_id(flag)
		elseif not flag then
			parent:set_selected_heroic_deed_backend_id(nil)
			_item_grid:set_backend_id_selected(nil)

			self._selected_backend_id = nil
		end
	end
end

StartGameWindowMutatorGridConsole.draw = function (self, arg_12_1)
	-- function 12
	local _ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()
	local render_settings = self.render_settings
	local snap_pixel_positions = render_settings.snap_pixel_positions
	local alpha_multiplier = render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	UIRenderer.begin_pass(_ui_top_renderer, ui_scenegraph, window_input_service, arg_12_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_12_7 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_12_7)
	end

	if not self:_is_deleting() then
		for i_2, v in ipairs(self._overlay_widgets) do
			if v.snap_pixel_positions ~= nil then
				render_settings.snap_pixel_positions = v.snap_pixel_positions
			end

			local alpha_multiplier_2 = v.alpha_multiplier

			alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
			render_settings.alpha_multiplier = alpha_multiplier_2

			UIRenderer.draw_widget(_ui_top_renderer, v)

			render_settings.snap_pixel_positions = snap_pixel_positions
		end
	end

	for i_3, v_2 in ipairs(self._delete_deeds_buttons_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_2)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowMutatorGridConsole._update_page_info = function (self)
	-- function 13
	local get_page_info, var_13_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_13_1 == self._total_pages) then
		self._total_pages = var_13_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_13_1 = var_13_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_13_1)
		_widgets_by_name.page_button_next.content.hotspot.disable_button = get_page_info == var_13_1
		_widgets_by_name.page_button_previous.content.hotspot.disable_button = get_page_info == 1
	end
end

StartGameWindowMutatorGridConsole._setup_input_buttons = function (self)
	-- function 14
	local window_input_service = self.parent:window_input_service()
	local _widgets_by_name = self._widgets_by_name
	local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str_2, true)
	local input_icon_next = _widgets_by_name.input_icon_next
	local texture_id = input_icon_next.style.texture_id

	texture_id.horizontal_alignment = "center"
	texture_id.vertical_alignment = "center"
	texture_id.texture_size = {
		get_gamepad_input_texture_data.size[1],
		get_gamepad_input_texture_data.size[2]
	}
	input_icon_next.content.texture_id = get_gamepad_input_texture_data.texture

	local get_gamepad_input_texture_data_2 = UISettings.get_gamepad_input_texture_data(window_input_service, str_3, true)
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local texture_id_2 = input_icon_previous.style.texture_id

	texture_id_2.horizontal_alignment = "center"
	texture_id_2.vertical_alignment = "center"
	texture_id_2.texture_size = {
		get_gamepad_input_texture_data_2.size[1],
		get_gamepad_input_texture_data_2.size[2]
	}
	input_icon_previous.content.texture_id = get_gamepad_input_texture_data_2.texture
end

StartGameWindowMutatorGridConsole._set_gamepad_input_buttons_visibility = function (self, arg_15_1)
	-- function 15
	local _widgets_by_name = self._widgets_by_name
	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local input_arrow_next = _widgets_by_name.input_arrow_next
	local input_arrow_previous = _widgets_by_name.input_arrow_previous

	input_icon_next.content.visible = arg_15_1
	input_icon_previous.content.visible = arg_15_1
	input_arrow_next.content.visible = arg_15_1
	input_arrow_previous.content.visible = arg_15_1
end

StartGameWindowMutatorGridConsole._handle_gamepad_activity = function (self)
	-- function 16
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("gamepad") then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			self:_set_gamepad_input_buttons_visibility(true)
			self:_set_delete_buttons_visible(false)
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		self:_set_gamepad_input_buttons_visibility(false)
		self:_set_delete_buttons_visible(true)
	end
end

StartGameWindowMutatorGridConsole._delete_deeds = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _deed_manager = self._deed_manager
	local var_17_1
	local can_delete_deeds, var_17_3, var_17_4 = _deed_manager:can_delete_deeds(arg_17_1, arg_17_2)

	if not var_17_3 then
		printf("[StartGameWindowMutatorGridConsole]:Failed to remove deeds from the inventory: %s)", var_17_4)

		return nil
	else
		return _deed_manager:delete_marked_deeds(var_17_3), can_delete_deeds
	end

	self.parent:window_input_service():set_blocked(true)
end

StartGameWindowMutatorGridConsole._handle_deeds_deletion = function (self)
	-- function 18
	local items = self._item_grid:items()

	if self._delete_type == "clear" then
		self:_mark_all_for_deletion()
	end

	local _deeds_marked_for_deletion = self._deeds_marked_for_deletion

	if table.is_empty(items) or not table.is_empty(_deeds_marked_for_deletion) then
		return
	end

	local _delete_deeds, var_18_3 = self:_delete_deeds(items, _deeds_marked_for_deletion)

	self._deed_removal_id = _delete_deeds
end

StartGameWindowMutatorGridConsole._update_on_removal_state = function (self, arg_19_1)
	-- function 19
	if not self._deed_removal_id then
		return
	end

	if not self._deed_manager:is_deleting_deeds() then
		self:_on_removal_complete()

		self._deed_removal_id = nil
	end
end

StartGameWindowMutatorGridConsole._is_deleting = function (self)
	-- function 20
	return self._deed_removal_id
end

StartGameWindowMutatorGridConsole._on_removal_complete = function (self)
	-- function 21
	local _item_grid = self._item_grid

	_item_grid:clear_item_grid()
	_item_grid:change_item_filter(tbl[1].item_filter, true)
	self.parent:window_input_service():set_blocked(false)

	local get_selected_heroic_deed_backend_id = self.parent:get_selected_heroic_deed_backend_id()

	self:_play_sound("hud_deed_delete_confirmed")
end

StartGameWindowMutatorGridConsole._set_delete_buttons_visible = function (self, arg_22_1)
	-- function 22
	local var_22_0
	local var_22_1
	local button_clear = self._delete_deeds_buttons_widgets_by_name.button_clear
	local button_delete = self._delete_deeds_buttons_widgets_by_name.button_delete

	button_clear.content.visible = arg_22_1
	button_delete.content.visible = arg_22_1
end

StartGameWindowMutatorGridConsole._mark_all_for_deletion = function (self)
	-- function 23
	self._deeds_marked_for_deletion = {}

	local items = self._item_grid:items()

	for i, v in ipairs(items) do
		v.marked_for_deletion = true
		self._deeds_marked_for_deletion[#self._deeds_marked_for_deletion + 1] = v
	end
end
