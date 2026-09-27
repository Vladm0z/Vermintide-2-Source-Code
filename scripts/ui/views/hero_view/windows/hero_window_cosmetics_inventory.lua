-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_inventory.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_inventory_definitions")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local flag = false

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

local testify = script_data.testify

testify = not testify and require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_inventory_testify")
HeroWindowCosmeticsInventory = class(HeroWindowCosmeticsInventory)
HeroWindowCosmeticsInventory.NAME = "HeroWindowCosmeticsInventory"

HeroWindowCosmeticsInventory.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsInventory")

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

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_2_1, arg_2_2)

	self.hero_name = arg_2_1.hero_name
	self.career_index = arg_2_1.career_index
	self.profile_index = arg_2_1.profile_index

	local var_2_2 = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index)

	self._item_grid = var_2_2

	var_2_2:mark_equipped_items(true)
	var_2_2:mark_locked_items(true)
	var_2_2:disable_locked_items(true)
	var_2_2:disable_item_drag()
	var_2_2:apply_item_sorting_function(fn)
end

HeroWindowCosmeticsInventory.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	self:_assign_tab_icons()
end

HeroWindowCosmeticsInventory._assign_tab_icons = function (self)
	-- function 4
	local content = self._widgets_by_name.item_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)
		local str_2 = "hotspot" .. str
		local str_3 = "icon" .. str

		content[str_2][str_3] = category_settings[i].icon
	end
end

HeroWindowCosmeticsInventory.on_exit = function (self, arg_5_1)
	-- function 5
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsInventory")

	self.ui_animator = nil

	self._item_grid:destroy()

	self._item_grid = nil
end

HeroWindowCosmeticsInventory.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self._item_grid:update(arg_6_1, arg_6_2)
	self:_update_animations(arg_6_1)
	self:_handle_input(arg_6_1, arg_6_2)
	self:_update_selected_cosmetic_slot_index()
	self:_update_loadout_sync()
	self:_update_page_info()
	self:draw(arg_6_1)

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

HeroWindowCosmeticsInventory.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

HeroWindowCosmeticsInventory._update_animations = function (self, arg_8_1)
	-- function 8
	self.ui_animator:update(arg_8_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name
end

HeroWindowCosmeticsInventory._is_button_pressed = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCosmeticsInventory._is_button_hovered = function (arg_10_0, arg_10_1)
	-- function 10
	if not arg_10_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowCosmeticsInventory._is_inventory_tab_hovered = function (self)
	-- function 11
	local content = self._widgets_by_name.item_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)

		if not content["hotspot" .. str].on_hover_enter then
			return i
		end
	end
end

HeroWindowCosmeticsInventory._is_inventory_tab_pressed = function (self)
	-- function 12
	local content = self._widgets_by_name.item_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)
		local var_12_3 = content["hotspot" .. str]

		if not (not var_12_3.on_release and var_12_3.is_selected) then
			return i
		end
	end
end

HeroWindowCosmeticsInventory._select_tab_by_category_index = function (self, arg_13_1)
	-- function 13
	local content = self._widgets_by_name.item_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)

		content["hotspot" .. str].is_selected = i == arg_13_1
	end
end

HeroWindowCosmeticsInventory._handle_input = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _widgets_by_name = self._widgets_by_name
	local parent = self.parent
	local _item_grid = self._item_grid
	local flag = false
	local is_item_pressed, var_14_5 = _item_grid:is_item_pressed(flag)
	local window_input_service = parent:window_input_service()

	if not _item_grid:handle_favorite_marking(window_input_service) then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not (not is_item_pressed and var_14_5) then
		parent:_set_loadout_item(is_item_pressed)
		self:_play_sound("play_gui_equipment_equip_hero")

		if is_item_pressed.data.slot_type == "skin" then
			parent:update_skin_sync()
		end
	end

	local item_tabs = _widgets_by_name.item_tabs

	UIWidgetUtils.animate_default_icon_tabs(item_tabs, arg_14_1)

	if not self:_is_inventory_tab_hovered() then
		self:_play_sound("play_gui_inventory_tab_hover")
	end

	local _is_inventory_tab_pressed = self:_is_inventory_tab_pressed()

	if not (not _is_inventory_tab_pressed and _is_inventory_tab_pressed == self._selected_cosmetic_slot_index) then
		parent:set_selected_cosmetic_slot_index(_is_inventory_tab_pressed)
		self:_play_sound("play_gui_inventory_tab_click")
	elseif not Managers.input:is_device_active("gamepad") then
		local get_service = Managers.input:get_service("hero_view")
		local amount = self._widgets_by_name.item_tabs.content.amount
		local _selected_cosmetic_slot_index = parent._selected_cosmetic_slot_index

		_selected_cosmetic_slot_index = _selected_cosmetic_slot_index or 1

		if not (not get_service:get("cycle_previous") and not (_selected_cosmetic_slot_index > 1)) then
			parent:set_selected_cosmetic_slot_index(_selected_cosmetic_slot_index - 1)
			self:_play_sound("play_gui_cosmetics_selection_click")
		elseif not (not get_service:get("cycle_next") and not (_selected_cosmetic_slot_index < amount)) then
			parent:set_selected_cosmetic_slot_index(_selected_cosmetic_slot_index + 1)
			self:_play_sound("play_gui_cosmetics_selection_click")
		end
	end

	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_default_button(page_button_next, arg_14_1)
	UIWidgetUtils.animate_default_button(page_button_previous, arg_14_1)

	if self:_is_button_hovered(page_button_next) or not self:_is_button_hovered(page_button_previous) then
		self:_play_sound("play_gui_inventory_next_hover")
	end

	if not self:_is_button_pressed(page_button_next) then
		local num = self._current_page + 1

		_item_grid:set_item_page(num)
		self:_play_sound("play_gui_cosmetics_inventory_next_click")
	elseif not self:_is_button_pressed(page_button_previous) then
		local num_2 = self._current_page - 1

		_item_grid:set_item_page(num_2)
		self:_play_sound("play_gui_cosmetics_inventory_next_click")
	end
end

HeroWindowCosmeticsInventory._update_page_info = function (self)
	-- function 15
	local get_page_info, var_15_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_15_1 == self._total_pages) then
		self._total_pages = var_15_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_15_1 = var_15_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_15_1)
		_widgets_by_name.page_button_next.content.button_hotspot.disable_button = get_page_info == var_15_1
		_widgets_by_name.page_button_previous.content.button_hotspot.disable_button = get_page_info == 1
	end
end

HeroWindowCosmeticsInventory._update_selected_cosmetic_slot_index = function (self)
	-- function 16
	local get_selected_cosmetic_slot_index = self.parent:get_selected_cosmetic_slot_index()

	if get_selected_cosmetic_slot_index ~= self._selected_cosmetic_slot_index then
		self._selected_cosmetic_slot_index = get_selected_cosmetic_slot_index

		self:_change_category_by_index(get_selected_cosmetic_slot_index)
	end
end

HeroWindowCosmeticsInventory._update_loadout_sync = function (self)
	-- function 17
	local _item_grid = self._item_grid
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self._loadout_sync_id = loadout_sync_id

		_item_grid:update_items_status()
	end
end

HeroWindowCosmeticsInventory._exit = function (self, arg_18_1)
	-- function 18
	self.exit = true
	self.exit_level_id = arg_18_1
end

HeroWindowCosmeticsInventory.draw = function (self, arg_19_1)
	-- function 19
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_19_1, nil, self.render_settings)

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
end

HeroWindowCosmeticsInventory._play_sound = function (self, arg_20_1)
	-- function 20
	self.parent:play_sound(arg_20_1)
end

HeroWindowCosmeticsInventory._change_category_by_index = function (self, arg_21_1, arg_21_2)
	-- function 21
	self:_select_tab_by_category_index(arg_21_1)

	if not arg_21_2 then
		arg_21_1 = self._current_category_index or 1
	end

	if self._current_category_index == arg_21_1 then
		return
	end

	self._current_category_index = arg_21_1

	local var_21_0 = category_settings[arg_21_1]
	local name = var_21_0.name
	local display_name = var_21_0.display_name

	self._item_grid:change_category(name)

	self._widgets_by_name.item_grid_header.content.text = display_name

	return true
end
