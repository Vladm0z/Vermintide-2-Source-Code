-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_inventory_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_inventory_console_definitions")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local flag = false
local str = "trigger_cycle_next"
local str_2 = "trigger_cycle_previous"

local function fn(self, arg_1_1)
	-- function 1
	local data = self.data
	local data_2 = arg_1_1.data
	local key = data.key
	local key_2 = data_2.key
	local power_level = self.power_level

	power_level = power_level or 0

	local power_level_2 = arg_1_1.power_level

	power_level_2 = power_level_2 or 0

	local backend_id = self.backend_id
	local backend_id_2 = arg_1_1.backend_id
	local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

	if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_1_1) then
		if power_level == power_level_2 then
			local rarity = self.rarity

			rarity = rarity or data.rarity

			local rarity_2 = arg_1_1.rarity

			rarity_2 = rarity_2 or data_2.rarity

			local item_rarity_order = UISettings.item_rarity_order
			local var_1_12 = item_rarity_order[rarity]
			local var_1_13 = item_rarity_order[rarity_2]

			if var_1_12 == var_1_13 then
				local var_1_14 = Localize(data.item_type)
				local var_1_15 = Localize(data_2.item_type)

				if var_1_14 == var_1_15 then
					local get_ui_information_from_item, var_1_17 = UIUtils.get_ui_information_from_item(self)
					local get_ui_information_from_item_2, var_1_19 = UIUtils.get_ui_information_from_item(arg_1_1)

					return Localize(var_1_17) < Localize(var_1_19)
				else
					return var_1_14 < var_1_15
				end
			else
				return var_1_12 < var_1_13
			end
		else
			return power_level_2 < power_level
		end
	elseif not is_favorite_backend_id then
		return true
	else
		return false
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole = class(HeroWindowCosmeticsLoadoutInventoryConsole)
HeroWindowCosmeticsLoadoutInventoryConsole.NAME = "HeroWindowCosmeticsLoadoutInventoryConsole"

HeroWindowCosmeticsLoadoutInventoryConsole.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsLoadoutInventoryConsole")

	self.params = arg_2_1
	self.parent = arg_2_1.parent

	local ingame_ui_context = arg_2_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.hero_name = arg_2_1.hero_name
	self.career_index = arg_2_1.career_index
	self.profile_index = arg_2_1.profile_index
	self.career_name = SPProfiles[self.profile_index].careers[self.career_index].name
	self._animations = {}

	self:create_ui_elements(arg_2_1, arg_2_2)
	self:_setup_input_buttons()

	local tbl = {
		profile_index = arg_2_1.profile_index,
		career_index = arg_2_1.career_index
	}
	local var_2_4 = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index, tbl)

	self._item_grid = var_2_4

	var_2_4:mark_equipped_items(true)
	var_2_4:mark_locked_items(true)
	var_2_4:disable_locked_items(true)
	var_2_4:disable_item_drag()
	var_2_4:apply_item_sorting_function(fn)
	self:_set_item_compare_enable_state(false)

	local flag = not local_player and local_player.player_unit

	if not flag then
		local has_extension = ScriptUnit.has_extension(flag, "inventory_system")

		if not has_extension then
			has_extension:check_and_drop_pickups("enter_inventory")
		end
	end

	self:_start_transition_animation("on_enter")
end

HeroWindowCosmeticsLoadoutInventoryConsole._start_transition_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_3_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_3_1] = start_animation
end

HeroWindowCosmeticsLoadoutInventoryConsole.create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_4_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_2
		tbl_2[k] = var_4_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local get_service = Managers.input:get_service("hero_view")
	local num = UILayer.default + 300

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, get_service, 6, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end

	tbl_2.item_tooltip.content.profile_index = self.params.profile_index
	tbl_2.item_tooltip.content.career_index = self.params.career_index
	tbl_2.item_tooltip_compare.content.profile_index = self.params.profile_index
	tbl_2.item_tooltip_compare.content.career_index = self.params.career_index
end

HeroWindowCosmeticsLoadoutInventoryConsole._input_service = function (self)
	-- function 5
	local parent = self.parent

	if not parent:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return parent:window_input_service()
end

HeroWindowCosmeticsLoadoutInventoryConsole.set_focus = function (self, arg_6_1)
	-- function 6
	self._focused = arg_6_1

	local render_settings = self.render_settings
	local flag

	flag = not arg_6_1 and 1 and 0.5
	render_settings.alpha_multiplier = flag
	self._widgets_by_name.item_tooltip.content.visible = arg_6_1
end

HeroWindowCosmeticsLoadoutInventoryConsole.on_exit = function (self, arg_7_1)
	-- function 7
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsLoadoutInventoryConsole")

	self.ui_animator = nil

	self._item_grid:destroy()

	self._item_grid = nil

	self._menu_input_description:destroy()

	self._menu_input_description = nil
end

HeroWindowCosmeticsLoadoutInventoryConsole.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self._item_grid:update(arg_8_1, arg_8_2)
	self:_update_animations(arg_8_1)
	self:_update_selected_cosmetic_slot_index()
	self:_update_loadout_sync()
	self:_update_page_info()
	self:_update_input_description()

	if not self._focused then
		self:_handle_gamepad_activity()
		self:_update_selected_item_tooltip()
		self:_handle_input(arg_8_1, arg_8_2)
		self:_handle_gamepad_input(arg_8_1, arg_8_2)
	end

	self:draw(arg_8_1)
end

HeroWindowCosmeticsLoadoutInventoryConsole.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_input_description = function (self)
	-- function 10
	local params = self.params
	local hero_statistics_active = self.params.hero_statistics_active

	if hero_statistics_active ~= self._hero_statistics_active then
		self._hero_statistics_active = hero_statistics_active

		if not hero_statistics_active then
			self._menu_input_description:change_generic_actions(generic_input_actions.details)
		else
			self._menu_input_description:change_generic_actions(generic_input_actions.default)
		end
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._set_item_compare_enable_state = function (self, arg_11_1)
	-- function 11
	self._widgets_by_name.item_tooltip_compare.content.visible = arg_11_1
	self._draw_item_compare = arg_11_1
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_equipped_item_tooltip = function (self)
	-- function 12
	local _selected_cosmetic_slot_index = self._selected_cosmetic_slot_index
	local name = InventorySettings.slots_by_cosmetic_index[_selected_cosmetic_slot_index].name
	local get_interface = Managers.backend:get_interface("items")
	local get_loadout_item_id = BackendUtils.get_loadout_item_id(self.career_name, name)
	local flag = not get_loadout_item_id and get_interface:get_item_from_id(get_loadout_item_id)

	self._widgets_by_name.item_tooltip_compare.content.item = flag
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_selected_item_tooltip = function (self)
	-- function 13
	local selected_item = self._item_grid:selected_item()
	local flag = not selected_item and selected_item.backend_id

	if flag ~= self._selected_backend_id then
		self._widgets_by_name.item_tooltip.content.item = selected_item
	end

	self._selected_backend_id = flag
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_animations = function (self, arg_14_1)
	-- function 14
	self.ui_animator:update(arg_14_1)

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

	UIWidgetUtils.animate_arrow_button(page_button_next, arg_14_1)
	UIWidgetUtils.animate_arrow_button(page_button_previous, arg_14_1)
end

HeroWindowCosmeticsLoadoutInventoryConsole._is_button_pressed = function (arg_15_0, arg_15_1)
	-- function 15
	local content = arg_15_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._is_button_hovered = function (arg_16_0, arg_16_1)
	-- function 16
	local content = arg_16_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._handle_gamepad_input = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local parent = self.parent
	local _input_service = self:_input_service()
	local _item_grid = self._item_grid

	if not _item_grid:handle_gamepad_selection(_input_service) then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not _input_service:get("confirm", true) then
		local selected_item, var_17_4 = _item_grid:selected_item()

		if not selected_item and not _item_grid:is_item_wieldable(selected_item) then
			parent:_set_loadout_item(selected_item)
			self:_play_sound("play_gui_equipment_equip_hero")

			if selected_item.data.slot_type == "skin" then
				parent:update_skin_sync()
			end
		end
	elseif not _input_service:get("special_1", true) then
		self:_set_item_compare_enable_state(not self._draw_item_compare)
	end

	local _current_page = self._current_page
	local _total_pages = self._total_pages

	if not _current_page and not _total_pages then
		if not (_current_page < _total_pages) or not _input_service:get(str) then
			_item_grid:set_item_page(_current_page + 1)
			self:_play_sound("play_gui_equipment_inventory_next_click")

			local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

			_item_grid:set_item_selected(get_item_in_slot)
		elseif not (_current_page > 1) or not _input_service:get(str_2) then
			_item_grid:set_item_page(_current_page - 1)
			self:_play_sound("play_gui_equipment_inventory_next_click")

			local get_item_in_slot_2 = _item_grid:get_item_in_slot(1, 1)

			_item_grid:set_item_selected(get_item_in_slot_2)
		end
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._handle_input = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _widgets_by_name = self._widgets_by_name
	local parent = self.parent
	local _item_grid = self._item_grid
	local flag = false
	local is_item_pressed, var_18_5 = _item_grid:is_item_pressed(flag)
	local _input_service = self:_input_service()

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not _item_grid:handle_favorite_marking(_input_service) then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not (not is_item_pressed and var_18_5) then
		parent:_set_loadout_item(is_item_pressed)
		self:_play_sound("play_gui_equipment_equip_hero")

		local data = is_item_pressed.data

		if data.slot_type == "skin" then
			parent:update_skin_sync()

			if not data.linked_weapon then
				local get_item_from_key = Managers.backend:get_interface("items"):get_item_from_key(data.linked_weapon)

				if not get_item_from_key then
					parent:_set_loadout_item(get_item_from_key)
				end
			end
		end
	end

	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	if self:_is_button_hovered(page_button_next) or not self:_is_button_hovered(page_button_previous) then
		self:_play_sound("play_gui_inventory_next_hover")
	end

	if not self:_is_button_pressed(page_button_next) then
		local num = self._current_page + 1

		_item_grid:set_item_page(num)
		self:_play_sound("play_gui_equipment_inventory_next_click")
	elseif not self:_is_button_pressed(page_button_previous) then
		local num_2 = self._current_page - 1

		_item_grid:set_item_page(num_2)
		self:_play_sound("play_gui_equipment_inventory_next_click")
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_page_info = function (self)
	-- function 19
	local get_page_info, var_19_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_19_1 == self._total_pages) then
		self._total_pages = var_19_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_19_1 = var_19_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_19_1)
		_widgets_by_name.page_button_next.content.hotspot.disable_button = get_page_info == var_19_1
		_widgets_by_name.page_button_previous.content.hotspot.disable_button = get_page_info == 1
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_selected_cosmetic_slot_index = function (self)
	-- function 20
	local get_selected_cosmetic_slot_index = self.parent:get_selected_cosmetic_slot_index()

	if get_selected_cosmetic_slot_index ~= self._selected_cosmetic_slot_index then
		self._selected_cosmetic_slot_index = get_selected_cosmetic_slot_index

		self:_change_category_by_index(get_selected_cosmetic_slot_index)
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_loadout_sync = function (self)
	-- function 21
	local _item_grid = self._item_grid
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self._loadout_sync_id = loadout_sync_id

		_item_grid:update_items_status()
		self:_update_equipped_item_tooltip()
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._exit = function (self, arg_22_1)
	-- function 22
	self.exit = true
	self.exit_level_id = arg_22_1
end

HeroWindowCosmeticsLoadoutInventoryConsole.draw = function (self, arg_23_1)
	-- function 23
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local _input_service = self:_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, _input_service, arg_23_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i_2, v_2 in ipairs(_active_node_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_2)
		end
	end

	UIRenderer.end_pass(ui_top_renderer)

	if not is_device_active and not self._menu_input_description then
		self._menu_input_description:draw(ui_top_renderer, arg_23_1)
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._play_sound = function (self, arg_24_1)
	-- function 24
	self.parent:play_sound(arg_24_1)
end

HeroWindowCosmeticsLoadoutInventoryConsole._change_category_by_index = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not arg_25_2 then
		arg_25_1 = self._current_category_index or 1
	end

	if self._current_category_index == arg_25_1 then
		return
	end

	self._current_category_index = arg_25_1

	local var_25_0 = category_settings[arg_25_1]
	local name = var_25_0.name
	local display_name = var_25_0.display_name

	self._item_grid:change_category(name)

	return true
end

HeroWindowCosmeticsLoadoutInventoryConsole._setup_input_buttons = function (self)
	-- function 26
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

HeroWindowCosmeticsLoadoutInventoryConsole._set_gamepad_input_buttons_visibility = function (self, arg_27_1)
	-- function 27
	local _widgets_by_name = self._widgets_by_name
	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local input_arrow_next = _widgets_by_name.input_arrow_next
	local input_arrow_previous = _widgets_by_name.input_arrow_previous

	input_icon_next.content.visible = arg_27_1
	input_icon_previous.content.visible = arg_27_1
	input_arrow_next.content.visible = arg_27_1
	input_arrow_previous.content.visible = arg_27_1
end

HeroWindowCosmeticsLoadoutInventoryConsole._handle_gamepad_activity = function (self)
	-- function 28
	local is_device_active = Managers.input:is_device_active("mouse")
	local flag = self.gamepad_active_last_frame == nil

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			local _item_grid = self._item_grid
			local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

			_item_grid:set_item_selected(get_item_in_slot)
			self:_set_gamepad_input_buttons_visibility(true)
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		self._item_grid:set_item_selected(nil)

		if not self._draw_item_compare then
			self:_set_item_compare_enable_state(false)
		end

		self:_set_gamepad_input_buttons_visibility(false)
	end
end
