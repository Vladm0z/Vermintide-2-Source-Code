-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_crafting_inventory_console.lua

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_inventory_console_definitions")
local widgets = var_0_3.widgets
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local pc_filter_widgets = var_0_3.pc_filter_widgets
local create_search_input_widget = var_0_3.create_search_input_widget
local create_search_filters_widget = var_0_3.create_search_filters_widget
local flag = false
local str = "trigger_cycle_next"
local str_2 = "trigger_cycle_previous"

HeroWindowCraftingInventoryConsole = class(HeroWindowCraftingInventoryConsole)
HeroWindowCraftingInventoryConsole.NAME = "HeroWindowCraftingInventoryConsole"

HeroWindowCraftingInventoryConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCraftingInventoryConsole")

	self.params = arg_1_1
	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.profile_index = arg_1_1.profile_index
	arg_1_1 = {
		profile_index = self.profile_index,
		career_index = self.career_index
	}

	self:_setup_input_buttons()

	local var_1_2 = ItemGridUI:new(var_0_0, self._widgets_by_name.item_grid, self.hero_name, self.career_index, arg_1_1)

	self._item_grid = var_1_2

	var_1_2:mark_equipped_items(true)
	var_1_2:mark_locked_items(true)
	var_1_2:disable_locked_items(false)
	var_1_2:disable_item_drag()

	self._inventory_sync_id = self.parent.inventory_sync_id

	self:_start_transition_animation("on_enter")
	self.parent:set_inventory_grid(var_1_2)
end

HeroWindowCraftingInventoryConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowCraftingInventoryConsole.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	local var_3_3 = create_search_input_widget(self)
	local var_3_4 = UIWidget.init(var_3_3)

	tbl[#tbl + 1] = var_3_4
	tbl_2.input = var_3_4
	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local var_3_5 = create_search_filters_widget("search_filters", self.ui_top_renderer, self, UISettings.inventory_filter_definitions)

	self._filter_widget = UIWidget.init(var_3_5)

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(pc_filter_widgets) do
		local var_3_8 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_3_8
		tbl_4[k_2] = var_3_8
	end

	self._pc_filter_widgets = tbl_3
	self._pc_filter_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	tbl_2.item_tooltip.content.profile_index = self.params.profile_index
	tbl_2.item_tooltip.content.career_index = self.params.career_index

	self:_set_input_blocked(false)
end

HeroWindowCraftingInventoryConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate HeroWindowCraftingInventoryConsole")

	self.ui_animator = nil

	self._item_grid:destroy()

	self._item_grid = nil

	self.parent:set_filter_selected(false)
	self.parent:set_filter_active(false)
end

HeroWindowCraftingInventoryConsole._input_service = function (self)
	-- function 5
	local parent = self.parent

	if not parent:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return parent:window_input_service()
end

HeroWindowCraftingInventoryConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self._item_grid:update(arg_6_1, arg_6_2)
	self:_update_filter_status()
	self:_update_animations(arg_6_1)
	self:_handle_input(arg_6_1, arg_6_2)
	self:_handle_gamepad_input(arg_6_1, arg_6_2)
	self:_update_inventory_items()
	self:_update_disabled_item_icon()
	self:_update_disabled_backend_ids()
	self:_update_page_info()
	self:_handle_gamepad_activity()
	self:_update_selected_item_tooltip()
	self:_update_filter_reset()
	self:_handle_filer_widgets_sounds()
	self:draw(arg_6_1)

	if not self._do_delayed_search then
		local content = self._filter_widget.content
		local content_2 = self._widgets_by_name.input.content

		self:_do_search(content_2.search_query, content.query)

		self._do_delayed_search = false
	end
end

HeroWindowCraftingInventoryConsole._update_filter_status = function (self)
	-- function 7
	local filter_search_disabled, var_7_1 = self.parent:filter_search_disabled()
	local content = self._widgets_by_name.input.content

	content.hotspot.disable_button = var_7_1
	content.clear_hotspot.disable_button = var_7_1
	content.search_filters_hotspot.disable_button = filter_search_disabled
end

HeroWindowCraftingInventoryConsole._update_filter_reset = function (self, arg_8_1)
	-- function 8
	if self.parent:filter_reset() or not arg_8_1 then
		local content = self._filter_widget.content

		table.clear(content.query.sort)
		table.clear(content.query.filter)

		content.query.only_new = nil

		local content_2 = self._widgets_by_name.input.content

		content_2.search_query, content_2.caret_index, content_2.text_index = "", 1, 1

		self:_do_search(content_2.search_query, content.query)
		self:_set_filter_selected(false)
	end
end

HeroWindowCraftingInventoryConsole.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

HeroWindowCraftingInventoryConsole._update_animations = function (self, arg_10_1)
	-- function 10
	self.ui_animator:update(arg_10_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name
	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_arrow_button(page_button_next, arg_10_1)
	UIWidgetUtils.animate_arrow_button(page_button_previous, arg_10_1)
	UIWidgetUtils.animate_default_button(self._pc_filter_widgets_by_name.apply_button, arg_10_1)
end

HeroWindowCraftingInventoryConsole._is_button_pressed = function (arg_11_0, arg_11_1)
	-- function 11
	local content = arg_11_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCraftingInventoryConsole._is_button_hovered = function (arg_12_0, arg_12_1)
	-- function 12
	local content = arg_12_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowCraftingInventoryConsole._handle_filter_input = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not self.parent:filter_active() then
		return false
	end

	if not arg_13_1:get("toggle_menu", true) then
		self.parent:set_filter_active(false)

		return false
	end

	local content = self._filter_widget.content

	if not content.close_filter_hotspot.on_pressed then
		self.parent:set_filter_active(false)

		return false
	elseif content.area_hotspot.is_hover or not arg_13_1:get("left_press", true) then
		local content_2 = self._widgets_by_name.input.content

		self:_do_search(content_2.search_query, content.query)
		self.parent:set_filter_active(false)

		return false
	end

	if not UIUtils.is_button_pressed(self._pc_filter_widgets_by_name.apply_button) then
		local content_3 = self._widgets_by_name.input.content

		self:_do_search(content_3.search_query, content.query)
		self.parent:set_filter_active(false)

		return false
	end
end

HeroWindowCraftingInventoryConsole._handle_filer_widgets_sounds = function (self)
	-- function 14
	local _filter_widget = self._filter_widget
	local input = self._widgets_by_name.input

	if not input and not UIUtils.is_button_hover_enter(input, "search_filters_hotspot") then
		self:_play_sound("play_gui_filter_tab_hover")
	end

	if not _filter_widget then
		if not UIUtils.is_button_pressed(_filter_widget, "reset_filter_hotspot") then
			self:_play_sound("play_gui_filter_reset")
		end

		local tbl = {
			[1] = "rarity",
			[2] = "power_level"
		}

		for i = 1, #tbl do
			local var_14_3 = tbl[i]

			if not UIUtils.is_button_hover_enter(_filter_widget, "sort_items_" .. var_14_3 .. "_hotspot") then
				self:_play_sound("play_gui_filter_sort_type_hover")
			end

			if not UIUtils.is_button_pressed(_filter_widget, "sort_items_" .. var_14_3 .. "_hotspot") then
				self:_play_sound("play_gui_filter_sort_type")
			end
		end

		for k, v in pairs(RaritySettings) do
			if not UIUtils.is_button_hover_enter(_filter_widget, k .. "_hotspot") then
				self:_play_sound("play_gui_filter_rarity_hover")
			end

			if not UIUtils.is_button_pressed(_filter_widget, k .. "_hotspot") then
				self:_play_sound("play_gui_filter_rarity_click")
			end
		end

		if not UIUtils.is_button_hover_enter(_filter_widget, "checkbox_hotspot") then
			self:_play_sound("play_gui_filter_rarity_hover")
		end

		if not UIUtils.is_button_pressed(_filter_widget, "checkbox_hotspot") then
			self:_play_sound("play_gui_filter_rarity_click")
		end
	end
end

HeroWindowCraftingInventoryConsole._handle_gamepad_filter_input = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local filter_active = self.parent:filter_active()
	local filter_selected = self.parent:filter_selected()

	if not filter_active then
		arg_15_1:get("back_menu", true)

		local content = self._filter_widget.content
		local current_gamepad_index = content.current_gamepad_index

		current_gamepad_index = current_gamepad_index or {
			1,
			1
		}

		local gamepad_input_matrix = content.gamepad_input_matrix
		local count = #gamepad_input_matrix
		local count_2 = #gamepad_input_matrix[current_gamepad_index[1]]

		if not arg_15_1:get("move_down_hold_continuous") then
			current_gamepad_index[1] = math.clamp(current_gamepad_index[1] + 1, 1, count)

			local count_3 = #gamepad_input_matrix[current_gamepad_index[1]]

			current_gamepad_index[2] = math.clamp(current_gamepad_index[2], 1, count_3)
		elseif not arg_15_1:get("move_up_hold_continuous") then
			current_gamepad_index[1] = math.clamp(current_gamepad_index[1] - 1, 1, count)

			local count_4 = #gamepad_input_matrix[current_gamepad_index[1]]

			current_gamepad_index[2] = math.clamp(current_gamepad_index[2], 1, count_4)
		elseif not arg_15_1:get("move_right_hold_continuous") then
			current_gamepad_index[2] = math.clamp(current_gamepad_index[2] + 1, 1, count_2)
		elseif not arg_15_1:get("move_left_hold_continuous") then
			current_gamepad_index[2] = math.clamp(current_gamepad_index[2] - 1, 1, count_2)
		end

		if not arg_15_1:get("confirm", true) then
			local var_15_9 = current_gamepad_index[1]
			local var_15_10 = current_gamepad_index[2]

			content[gamepad_input_matrix[var_15_9][var_15_10]].gamepad_pressed = true
			self._do_delayed_search = true
		elseif not arg_15_1:get("special_1", true) then
			self:_update_filter_reset(true)
		elseif not arg_15_1:get("back", true) then
			content.current_gamepad_index[1] = 1
			content.current_gamepad_index[2] = 1

			local content_2 = self._widgets_by_name.input.content

			self:_do_search(content_2.search_query, content.query)
			self.parent:set_filter_active(false)
			self:_set_filter_selected(true)
		end
	elseif not filter_selected then
		if not self._item_grid:get_item_in_slot(1, 1) and not arg_15_1:get("move_down_hold_continuous") then
			self:_set_filter_selected(false)
		elseif not arg_15_1:get("special_1", true) then
			self:_update_filter_reset(true)
		elseif not arg_15_1:get("confirm") then
			self.parent:set_filter_active(true)
			self.parent:set_filter_selected(false)
		end
	elseif self.parent:filter_search_disabled() or self._item_grid:get_selected_item_grid_slot() ~= 1 or not arg_15_1:get("move_up_hold_continuous") then
		self:_set_filter_selected(true)

		return true
	end

	return filter_active or filter_selected
end

HeroWindowCraftingInventoryConsole.filter_selected = function (self)
	-- function 16
	return self.parent:filter_selected()
end

HeroWindowCraftingInventoryConsole.filter_active = function (self)
	-- function 17
	return self.parent:filter_active()
end

HeroWindowCraftingInventoryConsole._set_filter_selected = function (self, arg_18_1)
	-- function 18
	local _item_grid = self._item_grid
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not arg_18_1 then
		_item_grid:set_item_selected(nil)
	elseif not is_device_active then
		local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

		_item_grid:set_item_selected(get_item_in_slot)
	end

	self.parent:set_filter_selected(arg_18_1)
end

HeroWindowCraftingInventoryConsole._handle_input = function (self, arg_19_1, arg_19_2)
	-- function 19
	local _input_service = self:_input_service()

	if not Managers.input:is_device_active("gamepad") then
		if not self:_handle_search_input(arg_19_1, arg_19_2) then
			return
		end

		if not self:_handle_filter_input(_input_service, arg_19_1, arg_19_2) then
			return
		end

		local _widgets_by_name = self._widgets_by_name
		local parent = self.parent
		local _item_grid = self._item_grid
		local flag = false
		local is_item_pressed = _item_grid:is_item_pressed(flag)

		if not _item_grid:is_item_hovered() then
			self:_play_sound("play_gui_inventory_item_hover")
		end

		if not (not self._pressed_backend_id and parent:get_pressed_item_backend_id() ~= self._pressed_backend_id) then
			parent:set_pressed_item_backend_id(nil)

			self._pressed_backend_id = nil
		end

		if not is_item_pressed then
			local backend_id = is_item_pressed.backend_id

			self._pressed_backend_id = backend_id

			local flag_2 = false

			parent:set_pressed_item_backend_id(backend_id, flag_2)
		end

		local page_button_next = _widgets_by_name.page_button_next
		local page_button_previous = _widgets_by_name.page_button_previous

		if self:_is_button_hovered(page_button_next) or not self:_is_button_hovered(page_button_previous) then
			self:_play_sound("play_gui_inventory_next_hover")
		end

		if not self:_is_button_pressed(page_button_next) then
			local num = self._current_page + 1

			_item_grid:set_item_page(num)
			self:_play_sound("play_gui_craft_inventory_next")
		elseif not self:_is_button_pressed(page_button_previous) then
			local num_2 = self._current_page - 1

			_item_grid:set_item_page(num_2)
			self:_play_sound("play_gui_craft_inventory_next")
		end
	end

	self:_handle_recipe_inputs(arg_19_1, arg_19_2)
end

HeroWindowCraftingInventoryConsole._handle_gamepad_input = function (self, arg_20_1, arg_20_2)
	-- function 20
	local parent = self.parent
	local _input_service = self:_input_service()
	local _item_grid = self._item_grid

	if Managers.input:is_device_active("mouse") or not self.parent.parent:input_blocked() then
		return
	end

	if not IS_CONSOLE and not self:_handle_search_input(arg_20_1, arg_20_2) then
		return
	end

	if not self:_handle_gamepad_filter_input(_input_service, arg_20_1, arg_20_2) then
		return
	end

	if not _input_service:get("confirm", true) then
		local selected_item = _item_grid:selected_item()

		if not selected_item then
			local backend_id = selected_item.backend_id

			self._pressed_backend_id = backend_id

			local flag = false

			parent:set_pressed_item_backend_id(backend_id, flag)
		end
	elseif not (not self._pressed_backend_id and parent:get_pressed_item_backend_id() ~= self._pressed_backend_id) then
		parent:set_pressed_item_backend_id(nil)

		self._pressed_backend_id = nil
	elseif not _item_grid:handle_gamepad_selection(_input_service) then
		self:_play_sound("play_gui_craft_forge_hover")
	end

	local _current_page = self._current_page
	local _total_pages = self._total_pages

	if not _current_page and not _total_pages then
		if not (_current_page < _total_pages) or not _input_service:get(str) then
			_item_grid:set_item_page(_current_page + 1)
			self:_play_sound("play_gui_craft_inventory_next")

			local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

			_item_grid:set_item_selected(get_item_in_slot)
		elseif not (_current_page > 1) or not _input_service:get(str_2) then
			_item_grid:set_item_page(_current_page - 1)
			self:_play_sound("play_gui_craft_inventory_next")

			local get_item_in_slot_2 = _item_grid:get_item_in_slot(1, 1)

			_item_grid:set_item_selected(get_item_in_slot_2)
		end
	end
end

HeroWindowCraftingInventoryConsole._set_input_blocked = function (self, arg_21_1)
	-- function 21
	local input = Managers.input

	if not arg_21_1 then
		input:block_device_except_service("hero_view", "keyboard", 1, "search")
		input:block_device_except_service("hero_view", "mouse", 1, "search")
		input:block_device_except_service("hero_view", "gamepad", 1, "search")
	else
		input:device_unblock_all_services("keyboard")
		input:device_unblock_all_services("mouse")
		input:device_unblock_all_services("gamepad")
		input:block_device_except_service("hero_view", "keyboard", 1)
		input:block_device_except_service("hero_view", "mouse", 1)
		input:block_device_except_service("hero_view", "gamepad", 1)
	end

	self.parent.parent:set_input_blocked(arg_21_1)
end

HeroWindowCraftingInventoryConsole._handle_search_input = function (self, arg_22_1, arg_22_2)
	-- function 22
	local is_device_active = Managers.input:is_device_active("gamepad")
	local _input_service = self:_input_service()
	local content = self._widgets_by_name.input.content

	if not is_device_active then
		if not content.clear_hotspot.on_pressed then
			content.search_query, content.caret_index, content.text_index = "", 1, 1

			self:_do_search(content.search_query)

			return true
		elseif not content.search_filters_hotspot.on_pressed then
			self:_play_sound("play_gui_filter_tab_click")

			content.input_active = false
			self._keyboard_id = nil

			self:_set_input_blocked(false)
			self.parent:set_filter_active(true)

			return true
		end
	end

	if not self._keyboard_id then
		content.input_active = false

		local filter_selected = self.parent:filter_selected()

		if not is_device_active and not filter_selected then
			-- Nothing
		end

		::label_22_1::

		local get = _input_service:get("refresh")

		get = not get and not IS_WINDOWS

		::label_22_2::

		if content.hotspot.on_pressed or not get then
			content.input_active = true

			if not IS_WINDOWS then
				self:_set_input_blocked(true)

				self._keyboard_id = true
			elseif not IS_XB1 then
				local var_22_5 = Localize("lb_search")

				XboxInterface.show_virtual_keyboard(self._search_query, var_22_5)

				self._keyboard_id = true
			elseif not IS_PS4 then
				local user_id = Managers.account:user_id()
				local var_22_7 = Localize("lb_search")
				local virtual_keyboard_anchor_point = var_0_3.virtual_keyboard_anchor_point

				self._keyboard_id = Managers.system_dialog:open_virtual_keyboard(user_id, var_22_7, self._search_query, virtual_keyboard_anchor_point)
			end

			return true
		end

		return false
	end

	local is_device_active_2 = Managers.input:is_device_active("gamepad")

	Managers.chat:block_chat_input_for_one_frame()

	if not IS_WINDOWS then
		local keystrokes = Keyboard.keystrokes()

		content.search_query, content.caret_index = KeystrokeHelper.parse_strokes(content.search_query, content.caret_index, "insert", keystrokes)

		if not _input_service:get("execute_chat_input", true) then
			self:_do_search(content.search_query)

			content.input_active = false
			self._keyboard_id = nil

			self:_set_input_blocked(false)
		elseif not _input_service:get("toggle_menu", true) then
			content.input_active = false
			self._keyboard_id = nil

			self:_set_input_blocked(false)
		end
	elseif not IS_XB1 then
		if not XboxInterface.interface_active() then
			local get_keyboard_result = XboxInterface.get_keyboard_result()
			local flag

			flag = not is_device_active_2 and 1 and #get_keyboard_result
			content.caret_index = flag

			self:_do_search(get_keyboard_result)

			self._keyboard_id = nil

			local get_item_in_slot = self._item_grid:get_item_in_slot(1, 1)

			self:_set_filter_selected(get_item_in_slot == nil)
		end
	elseif not IS_PS4 then
		local poll_virtual_keyboard, var_22_15, var_22_16 = Managers.system_dialog:poll_virtual_keyboard(self._keyboard_id)

		if not poll_virtual_keyboard then
			if not var_22_15 then
				local flag_2

				flag_2 = not is_device_active_2 and 1 and #var_22_16
				content.caret_index = flag_2

				self:_do_search(var_22_16)
			end

			self._keyboard_id = nil

			local get_item_in_slot_2 = self._item_grid:get_item_in_slot(1, 1)

			self:_set_filter_selected(get_item_in_slot_2 == nil)
		end
	end

	if not content.hotspot.on_pressed then
		return true
	end

	return self._keyboard_id
end

local tbl = {}

HeroWindowCraftingInventoryConsole._do_search = function (self, arg_23_1, arg_23_2)
	-- function 23
	self._search_query = arg_23_1

	if not arg_23_2 then
		-- Nothing
	end

	::label_23_0::

	local _filter_query = self._filter_query

	_filter_query = _filter_query or tbl

	::label_23_1::

	self._filter_query = _filter_query
	self._widgets_by_name.input.content.search_query = arg_23_1

	local var_23_1 = var_0_1[self._selected_craft_page_name]
	local item_filter = var_23_1.item_filter
	local hero_specific_filter = var_23_1.hero_specific_filter
	local career_specific_filter = var_23_1.career_specific_filter

	if not hero_specific_filter then
		local str

		if not item_filter then
			str = "and " .. item_filter

			if not str then
				-- Nothing
			end
		end

		str = ""

		::label_23_2::

		item_filter = "can_wield_by_current_hero " .. str
	end

	if not self._filter_query.filter then
		for k, v in pairs(self._filter_query.filter) do
			if not v then
				item_filter = item_filter .. " and not is_" .. k
			end
		end
	end

	if not self._filter_query.only_new then
		item_filter = item_filter .. " and is_new"
	end

	self:change_item_filter(item_filter, true, arg_23_1)

	if not self._filter_query.sort then
		local var_23_6

		for k_2, v_2 in pairs(self._filter_query.sort) do
			local str_2 = k_2 .. "_" .. v_2

			var_23_6 = UIUtils[str_2]

			break
		end

		local items = self._item_grid:items()

		if not (not var_23_6 and not (#items > 1)) then
			table.sort(items, var_23_6)
		end

		self._item_grid:set_item_page(1)
	end

	self:_play_sound("Play_hud_select")
end

HeroWindowCraftingInventoryConsole._handle_recipe_inputs = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _input_service = self:_input_service()
	local var_24_1 = var_0_1[self._selected_craft_page_name]

	if not var_24_1 and not var_24_1.input_func then
		var_24_1.input_func(self, _input_service)
	end
end

HeroWindowCraftingInventoryConsole._update_page_info = function (self)
	-- function 25
	local get_page_info, var_25_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_25_1 == self._total_pages) then
		self._total_pages = var_25_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_25_1 = var_25_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_25_1)
		_widgets_by_name.page_button_next.content.hotspot.disable_button = get_page_info == var_25_1
		_widgets_by_name.page_button_previous.content.hotspot.disable_button = get_page_info == 1
	end
end

HeroWindowCraftingInventoryConsole._update_crafting_material_panel = function (self)
	-- function 26
	local get_interface = Managers.backend:get_interface("items")
	local crafting_material_icons_small = UISettings.crafting_material_icons_small
	local crafting_material_order = UISettings.crafting_material_order
	local _widgets_by_name = self._widgets_by_name
	local num = 1

	for i, v in ipairs(crafting_material_order) do
		local var_26_5 = crafting_material_icons_small[v]
		local str = "item_key == " .. v
		local get_filtered_items = get_interface:get_filtered_items(str)
		local flag = not get_filtered_items and get_filtered_items[1]
		local flag_2 = not flag and flag.backend_id
		local get_item_amount

		if not flag_2 then
			get_item_amount = get_interface:get_item_amount(flag_2)

			if not get_item_amount then
				-- Nothing
			end
		end

		get_item_amount = 0

		::label_26_0::

		local content = _widgets_by_name["material_text_" .. i].content
		local var_26_12

		if get_item_amount < 10000 then
			var_26_12 = tostring(get_item_amount)
		elseif get_item_amount < 100000 then
			var_26_12 = string.format("%.1fk", get_item_amount * 0.001)
		else
			var_26_12 = "+99k"
		end

		content.text = var_26_12
		content.icon = var_26_5

		if not content.item then
			content.item = flag or {
				data = table.clone(ItemMasterList[v])
			}
		end
	end
end

HeroWindowCraftingInventoryConsole._update_inventory_items = function (self)
	-- function 27
	local _item_grid = self._item_grid
	local parent = self.parent
	local inventory_sync_id = parent.inventory_sync_id
	local get_selected_craft_page = parent:get_selected_craft_page()
	local get_craft_optional_item_filter = parent:get_craft_optional_item_filter()

	if not (inventory_sync_id ~= self._inventory_sync_id or get_selected_craft_page ~= self._selected_craft_page_name or self._optional_craft_item_filter == get_craft_optional_item_filter) then
		if get_selected_craft_page ~= self._selected_craft_page_name then
			self._selected_craft_page_name = get_selected_craft_page

			self:_change_category_by_name(get_selected_craft_page)
		elseif not get_craft_optional_item_filter then
			self:change_item_filter(get_craft_optional_item_filter, true)
			self:_handle_gamepad_activity(true)
			self:_update_selected_item_tooltip(true)
		else
			self:_change_category_by_index(nil, true)
		end

		self._inventory_sync_id = inventory_sync_id
		self._optional_craft_item_filter = get_craft_optional_item_filter

		self:_update_crafting_material_panel()
	end
end

HeroWindowCraftingInventoryConsole._update_disabled_item_icon = function (self)
	-- function 28
	local _item_grid = self._item_grid
	local disabled_item_icon = self.parent:disabled_item_icon()

	if disabled_item_icon ~= self._disabled_item_icon then
		self._disabled_item_icon = disabled_item_icon

		_item_grid:set_locked_items_icon(disabled_item_icon)
	end
end

HeroWindowCraftingInventoryConsole._update_disabled_backend_ids = function (self)
	-- function 29
	local _item_grid = self._item_grid
	local disabled_backend_ids_sync_id = self.parent.disabled_backend_ids_sync_id

	if disabled_backend_ids_sync_id ~= self._disabled_backend_ids_sync_id then
		self._disabled_backend_ids_sync_id = disabled_backend_ids_sync_id

		_item_grid:clear_locked_items()

		local get_disabled_backend_ids = self.parent:get_disabled_backend_ids()

		for k, v in pairs(get_disabled_backend_ids) do
			_item_grid:lock_item_by_id(k, true)
		end

		_item_grid:update_items_status()
	end
end

HeroWindowCraftingInventoryConsole._exit = function (self, arg_30_1)
	-- function 30
	self.exit = true
	self.exit_level_id = arg_30_1
end

HeroWindowCraftingInventoryConsole.draw = function (self, arg_31_1)
	-- function 31
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local _input_service = self:_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")
	local filter_active = self.parent:filter_active()

	if not filter_active then
		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, _input_service, arg_31_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_top_renderer, self._filter_widget)

		if not is_device_active then
			for i, v in ipairs(self._pc_filter_widgets) do
				UIRenderer.draw_widget(ui_top_renderer, v)
			end
		end

		UIRenderer.end_pass(ui_top_renderer)
	end

	_input_service = not filter_active and FAKE_INPUT_SERVICE and _input_service

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, _input_service, arg_31_1, nil, self.render_settings)

	for i_2, v_2 in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_2)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

HeroWindowCraftingInventoryConsole._play_sound = function (self, arg_32_1)
	-- function 32
	self.parent:play_sound(arg_32_1)
end

HeroWindowCraftingInventoryConsole._change_category_by_name = function (self, arg_33_1)
	-- function 33
	for i, v in ipairs(var_0_0) do
		if v.name == arg_33_1 then
			self:_change_category_by_index(i)

			break
		end
	end
end

HeroWindowCraftingInventoryConsole._change_category_by_index = function (self, arg_34_1, arg_34_2)
	-- function 34
	if not arg_34_2 then
		arg_34_1 = self._current_category_index or 1
	end

	if not (self._current_category_index ~= arg_34_1 or arg_34_2) then
		return
	end

	self._current_category_index = arg_34_1

	local _item_grid = self._item_grid
	local var_34_1 = var_0_0[arg_34_1]
	local name = var_34_1.name
	local item_sort_func = var_34_1.item_sort_func

	if not item_sort_func then
		_item_grid:apply_item_sorting_function(item_sort_func)
	end

	_item_grid:change_category(name, arg_34_2)

	local _filter_widget = self._filter_widget
	local input = self._widgets_by_name.input
	local content = _filter_widget.content
	local search_query = input.content.search_query
	local query = content.query

	if (search_query ~= "" or not table.is_empty(query.sort) or not table.is_empty(query.filter)) and not query.only_new then
		self:_do_search(search_query, query)
	end

	self:_handle_gamepad_activity(true)
	self:_update_selected_item_tooltip(true)

	return true
end

HeroWindowCraftingInventoryConsole.change_item_filter = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	arg_35_2 = arg_35_2 or arg_35_2 == nil

	self._item_grid:change_item_filter(arg_35_1, arg_35_2, arg_35_3)
end

HeroWindowCraftingInventoryConsole._update_selected_item_tooltip = function (self, arg_36_1)
	-- function 36
	local selected_item = self._item_grid:selected_item()
	local flag = not selected_item and selected_item.backend_id

	if flag ~= self._selected_backend_id or not arg_36_1 then
		self._widgets_by_name.item_tooltip.content.item = selected_item
	end

	self._selected_backend_id = flag
end

HeroWindowCraftingInventoryConsole._setup_input_buttons = function (self)
	-- function 37
	local window_input_service = self.parent:window_input_service()
	local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str, true)
	local get_gamepad_input_texture_data_2 = UISettings.get_gamepad_input_texture_data(window_input_service, str_2, true)
	local _widgets_by_name = self._widgets_by_name
	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local texture_id = input_icon_next.style.texture_id

	texture_id.horizontal_alignment = "center"
	texture_id.vertical_alignment = "center"
	texture_id.texture_size = {
		get_gamepad_input_texture_data.size[1],
		get_gamepad_input_texture_data.size[2]
	}
	input_icon_next.content.texture_id = get_gamepad_input_texture_data.texture

	local texture_id_2 = input_icon_previous.style.texture_id

	texture_id_2.horizontal_alignment = "center"
	texture_id_2.vertical_alignment = "center"
	texture_id_2.texture_size = {
		get_gamepad_input_texture_data_2.size[1],
		get_gamepad_input_texture_data_2.size[2]
	}
	input_icon_previous.content.texture_id = get_gamepad_input_texture_data_2.texture
end

HeroWindowCraftingInventoryConsole._set_gamepad_input_buttons_visibility = function (self, arg_38_1)
	-- function 38
	local _widgets_by_name = self._widgets_by_name
	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local input_arrow_next = _widgets_by_name.input_arrow_next
	local input_arrow_previous = _widgets_by_name.input_arrow_previous

	input_icon_next.content.visible = arg_38_1
	input_icon_previous.content.visible = arg_38_1
	input_arrow_next.content.visible = arg_38_1
	input_arrow_previous.content.visible = arg_38_1
end

HeroWindowCraftingInventoryConsole._handle_gamepad_activity = function (self, arg_39_1)
	-- function 39
	if not self.parent.parent:input_blocked() then
		return
	end

	local is_device_active = Managers.input:is_device_active("mouse")

	arg_39_1 = arg_39_1 or self.gamepad_active_last_frame == nil

	if not is_device_active then
		if not self.gamepad_active_last_frame and not arg_39_1 then
			self.gamepad_active_last_frame = true

			local _item_grid = self._item_grid
			local var_39_2
			local selected_item = _item_grid:selected_item()

			if not selected_item and not _item_grid:has_item(selected_item) then
				var_39_2 = selected_item.backend_id
			else
				local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

				var_39_2 = not get_item_in_slot and get_item_in_slot.backend_id
			end

			if not var_39_2 then
				_item_grid:set_backend_id_selected(var_39_2)
			else
				_item_grid:set_item_selected(nil)
			end

			self:_set_gamepad_input_buttons_visibility(true)
		end
	elseif self.gamepad_active_last_frame or not arg_39_1 then
		self.gamepad_active_last_frame = false

		self._item_grid:set_item_selected(nil)
		self:_set_gamepad_input_buttons_visibility(false)
	end
end
