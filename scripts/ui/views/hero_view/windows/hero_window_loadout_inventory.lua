-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_loadout_inventory.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_inventory_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local flag = false

HeroWindowLoadoutInventory = class(HeroWindowLoadoutInventory)
HeroWindowLoadoutInventory.NAME = "HeroWindowLoadoutInventory"

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

local tbl = {
	melee = Localize("inventory_screen_melee_weapon_title"),
	ranged = Localize("inventory_screen_ranged_weapon_title"),
	necklace = Localize("inventory_screen_necklace_title"),
	trinket = Localize("inventory_screen_trinket_title"),
	ring = Localize("inventory_screen_ring_title")
}

HeroWindowLoadoutInventory.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[HeroViewWindow] Enter Substate HeroWindowLoadoutInventory")

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
	self._categories = self:_create_item_categories(self.profile_index, self.career_index)
	self._animations = {}

	self:create_ui_elements(arg_2_1, arg_2_2)

	local var_2_3 = ItemGridUI:new(self._categories, self._widgets_by_name.item_grid, self.hero_name, self.career_index)

	self._item_grid = var_2_3

	var_2_3:mark_equipped_items(true)
	var_2_3:mark_locked_items(true)
	var_2_3:disable_locked_items(true)
	var_2_3:disable_unwieldable_items(true)
	var_2_3:disable_item_drag()
	var_2_3:apply_item_sorting_function(fn)

	local flag = not local_player and local_player.player_unit

	if not flag then
		local has_extension = ScriptUnit.has_extension(flag, "inventory_system")

		if not has_extension then
			has_extension:check_and_drop_pickups("enter_inventory")
		end
	end
end

HeroWindowLoadoutInventory._create_item_categories = function (self, arg_3_1, arg_3_2)
	-- function 3
	local career_index = self.career_index
	local profile_index = self.profile_index
	local item_slot_types_by_slot_name = SPProfiles[profile_index].careers[career_index].item_slot_types_by_slot_name
	local tbl_2 = {}

	for k, v in pairs(item_slot_types_by_slot_name) do
		local ui_slot_index = InventorySettings.slots_by_name[k].ui_slot_index

		if not ui_slot_index then
			local str = "( "
			local str_2 = ""
			local var_3_7
			local tbl_3 = {}

			for i, v_2 in ipairs(v) do
				local var_3_9 = tbl[v_2]

				str_2 = str_2 .. var_3_9
				str = str .. "slot_type == " .. v_2

				if i < #v then
					str_2 = str_2 .. " - "
					str = str .. " or "
				else
					str = str .. " ) and item_rarity ~= magic"
				end

				for k_2, v_3 in pairs(UISettings.slot_icons) do
					if not string.find(k_2, v_2) then
						tbl_3[k_2] = v_3
					end
				end
			end

			for k_3, v_4 in pairs(tbl_3) do
				local flag = true

				for i_2, v_5 in ipairs(v) do
					if not string.find(k_3, v_5) then
						flag = false

						break
					end
				end

				if not flag then
					var_3_7 = v_4

					break
				end
			end

			tbl_2[ui_slot_index] = {
				hero_specific_filter = true,
				name = k,
				display_name = str_2,
				icon = var_3_7,
				item_types = v,
				slot_index = ui_slot_index,
				slot_name = k,
				item_filter = str
			}
		end
	end

	return tbl_2
end

HeroWindowLoadoutInventory.create_ui_elements = function (self, arg_4_1, arg_4_2)
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

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end

	self:_setup_tab_widget()
end

HeroWindowLoadoutInventory._setup_tab_widget = function (self)
	-- function 5
	local _categories = self._categories
	local count = #_categories
	local _widgets = self._widgets
	local _widgets_by_name = self._widgets_by_name
	local var_5_4 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_vertical", {
		5,
		35
	}, "item_tabs_segments", count - 1))
	local var_5_5 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_top", {
		17,
		9
	}, "item_tabs_segments_top", count - 1))
	local var_5_6 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_bottom", {
		17,
		9
	}, "item_tabs_segments_bottom", count - 1))

	_widgets_by_name.item_tabs_segments = var_5_4
	_widgets_by_name.item_tabs_segments_top = var_5_5
	_widgets_by_name.item_tabs_segments_bottom = var_5_6
	_widgets[#_widgets + 1] = var_5_4
	_widgets[#_widgets + 1] = var_5_5
	_widgets[#_widgets + 1] = var_5_6

	local str = "item_tabs"
	local size = scenegraph_definition.item_tabs.size
	local create_default_icon_tabs = UIWidgets.create_default_icon_tabs(str, size, count)
	local var_5_10 = UIWidget.init(create_default_icon_tabs)

	_widgets_by_name[str] = var_5_10
	_widgets[#_widgets + 1] = var_5_10

	local content = var_5_10.content

	for i, v in ipairs(_categories) do
		local str_2 = "_" .. tostring(i)
		local str_3 = "hotspot" .. str_2
		local str_4 = "icon" .. str_2
		local var_5_15 = content[str_3]

		var_5_15.slot_index, var_5_15[str_4] = v.slot_index, v.icon
	end
end

HeroWindowLoadoutInventory.on_exit = function (self, arg_6_1)
	-- function 6
	print("[HeroViewWindow] Exit Substate HeroWindowLoadoutInventory")

	self.ui_animator = nil

	self._item_grid:destroy()

	self._item_grid = nil
end

HeroWindowLoadoutInventory.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self._item_grid:update(arg_7_1, arg_7_2)
	self:_update_animations(arg_7_1)
	self:_handle_input(arg_7_1, arg_7_2)
	self:_update_selected_loadout_slot_index()
	self:_update_loadout_sync()
	self:_update_page_info()
	self:draw(arg_7_1)
end

HeroWindowLoadoutInventory.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return
end

HeroWindowLoadoutInventory._update_animations = function (self, arg_9_1)
	-- function 9
	self.ui_animator:update(arg_9_1)

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

HeroWindowLoadoutInventory._is_button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowLoadoutInventory._is_button_hovered = function (arg_11_0, arg_11_1)
	-- function 11
	if not arg_11_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowLoadoutInventory._is_inventory_tab_hovered = function (self)
	-- function 12
	local content = self._widgets_by_name.item_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)

		if not content["hotspot" .. str].on_hover_enter then
			return i
		end
	end
end

HeroWindowLoadoutInventory._is_inventory_tab_pressed = function (self)
	-- function 13
	local content = self._widgets_by_name.item_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)
		local var_13_3 = content["hotspot" .. str]

		if not (not var_13_3.on_release and var_13_3.is_selected) then
			return i
		end
	end
end

HeroWindowLoadoutInventory._select_tab_by_slot_index = function (self, arg_14_1)
	-- function 14
	local content = self._widgets_by_name.item_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)
		local var_14_3 = content["hotspot" .. str]

		var_14_3.is_selected = arg_14_1 == var_14_3.slot_index
	end
end

HeroWindowLoadoutInventory._handle_input = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _widgets_by_name = self._widgets_by_name
	local parent = self.parent
	local _item_grid = self._item_grid
	local flag = false
	local is_item_pressed, var_15_5 = _item_grid:is_item_pressed(flag)
	local window_input_service = parent:window_input_service()

	if not _item_grid:handle_favorite_marking(window_input_service) then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not (not is_item_pressed and var_15_5) then
		parent:_set_loadout_item(is_item_pressed, self._strict_slot_name)
		self:_play_sound("play_gui_equipment_equip_hero")
	end

	local item_tabs = _widgets_by_name.item_tabs

	UIWidgetUtils.animate_default_icon_tabs(item_tabs, arg_15_1)

	if not self:_is_inventory_tab_hovered() then
		self:_play_sound("play_gui_inventory_tab_hover")
	end

	local _is_inventory_tab_pressed = self:_is_inventory_tab_pressed()

	if not (not _is_inventory_tab_pressed and _is_inventory_tab_pressed == self._category_index) then
		local _get_category_slot_index = self:_get_category_slot_index(_is_inventory_tab_pressed)

		parent:set_selected_loadout_slot_index(_get_category_slot_index)
		self:_play_sound("play_gui_inventory_tab_click")
	elseif not Managers.input:is_device_active("gamepad") then
		local get_service = Managers.input:get_service("hero_view")
		local _selected_loadout_slot_index = parent._selected_loadout_slot_index

		_selected_loadout_slot_index = _selected_loadout_slot_index or 1

		local count = #self._categories

		if not (not get_service:get("cycle_previous") and not (_selected_loadout_slot_index > 1)) then
			parent:set_selected_loadout_slot_index(_selected_loadout_slot_index - 1)
			self:_play_sound("play_gui_inventory_tab_click")
		elseif not (not get_service:get("cycle_next") and not (_selected_loadout_slot_index < count)) then
			parent:set_selected_loadout_slot_index(_selected_loadout_slot_index + 1)
			self:_play_sound("play_gui_inventory_tab_click")
		end
	end

	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_default_button(page_button_next, arg_15_1)
	UIWidgetUtils.animate_default_button(page_button_previous, arg_15_1)

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

HeroWindowLoadoutInventory._update_page_info = function (self)
	-- function 16
	local get_page_info, var_16_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_16_1 == self._total_pages) then
		self._total_pages = var_16_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_16_1 = var_16_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_16_1)
		_widgets_by_name.page_button_next.content.button_hotspot.disable_button = get_page_info == var_16_1
		_widgets_by_name.page_button_previous.content.button_hotspot.disable_button = get_page_info == 1
	end
end

HeroWindowLoadoutInventory._get_category_slot_index = function (self, arg_17_1)
	-- function 17
	return self._categories[arg_17_1].slot_index
end

HeroWindowLoadoutInventory._get_category_index_by_slot_index = function (self, arg_18_1)
	-- function 18
	local _categories = self._categories

	for i, v in ipairs(_categories) do
		if v.slot_index == arg_18_1 then
			return i
		end
	end
end

HeroWindowLoadoutInventory._update_selected_loadout_slot_index = function (self)
	-- function 19
	local get_selected_loadout_slot_index = self.parent:get_selected_loadout_slot_index()
	local _get_category_index_by_slot_index = self:_get_category_index_by_slot_index(get_selected_loadout_slot_index)

	if get_selected_loadout_slot_index ~= self._selected_loadout_slot_index then
		self:_change_category_by_index(_get_category_index_by_slot_index)

		self._selected_loadout_slot_index = get_selected_loadout_slot_index
		self._category_index = _get_category_index_by_slot_index
	end
end

HeroWindowLoadoutInventory._update_loadout_sync = function (self)
	-- function 20
	local _item_grid = self._item_grid
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self._loadout_sync_id = loadout_sync_id

		_item_grid:update_items_status()
	end
end

HeroWindowLoadoutInventory._exit = function (self, arg_21_1)
	-- function 21
	self.exit = true
	self.exit_level_id = arg_21_1
end

HeroWindowLoadoutInventory.draw = function (self, arg_22_1)
	-- function 22
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_22_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

HeroWindowLoadoutInventory._play_sound = function (self, arg_23_1)
	-- function 23
	self.parent:play_sound(arg_23_1)
end

HeroWindowLoadoutInventory._change_category_by_index = function (self, arg_24_1)
	-- function 24
	self:_select_tab_by_slot_index(arg_24_1)

	local var_24_0 = self._categories[arg_24_1]

	self._strict_slot_name = var_24_0.slot_name

	local name = var_24_0.name
	local display_name = var_24_0.display_name

	self._widgets_by_name.item_grid_header.content.text = display_name

	self._item_grid:change_category(name)

	return true
end
