-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_inventory.lua

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_inventory_definitions")
local widgets = var_0_3.widgets
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local flag = false

HeroWindowInventory = class(HeroWindowInventory)
HeroWindowInventory.NAME = "HeroWindowInventory"

HeroWindowInventory.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowInventory")

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

	local var_1_2 = ItemGridUI:new(var_0_0, self._widgets_by_name.item_grid, self.hero_name, self.career_index)

	self._item_grid = var_1_2

	var_1_2:mark_equipped_items(true)
	var_1_2:mark_locked_items(true)
	var_1_2:disable_locked_items(true)
	var_1_2:disable_item_drag()

	self._inventory_sync_id = self.parent.inventory_sync_id

	self.parent:set_inventory_grid(var_1_2)
end

HeroWindowInventory.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_2
		tbl_2[k] = var_2_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

HeroWindowInventory.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate HeroWindowInventory")

	self.ui_animator = nil

	self._item_grid:destroy()

	self._item_grid = nil
end

HeroWindowInventory.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self._item_grid:update(arg_4_1, arg_4_2)
	self:_update_animations(arg_4_1)
	self:_handle_input(arg_4_1, arg_4_2)
	self:_update_inventory_items()
	self:_update_disabled_backend_ids()
	self:_update_page_info()
	self:draw(arg_4_1)
end

HeroWindowInventory.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

HeroWindowInventory._update_animations = function (self, arg_6_1)
	-- function 6
	self.ui_animator:update(arg_6_1)

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

HeroWindowInventory._is_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowInventory._is_button_hovered = function (arg_8_0, arg_8_1)
	-- function 8
	if not arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowInventory._handle_input = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _widgets_by_name = self._widgets_by_name
	local parent = self.parent
	local _item_grid = self._item_grid
	local flag = false
	local is_item_pressed = _item_grid:is_item_pressed(flag)
	local is_item_dragged = _item_grid:is_item_dragged()
	local flag_2 = is_item_pressed or is_item_dragged

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	for i = 1, 6 do
		local var_9_7 = _widgets_by_name["material_text_" .. i]

		if not self:_is_button_hovered(var_9_7) then
			self:_play_sound("play_gui_equipment_button_hover")
		end
	end

	if not flag_2 then
		local backend_id = flag_2.backend_id

		self._pressed_backend_id = backend_id

		local flag_3 = is_item_dragged ~= nil

		parent:set_pressed_item_backend_id(backend_id, flag_3)
	elseif not self._pressed_backend_id then
		if parent:get_pressed_item_backend_id() == self._pressed_backend_id then
			parent:set_pressed_item_backend_id(nil)
		end

		self._pressed_backend_id = nil
	end

	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_default_button(page_button_next, arg_9_1)
	UIWidgetUtils.animate_default_button(page_button_previous, arg_9_1)

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

HeroWindowInventory._update_page_info = function (self)
	-- function 10
	local get_page_info, var_10_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_10_1 == self._total_pages) then
		self._total_pages = var_10_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_10_1 = var_10_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_10_1)
		_widgets_by_name.page_button_next.content.button_hotspot.disable_button = get_page_info == var_10_1
		_widgets_by_name.page_button_previous.content.button_hotspot.disable_button = get_page_info == 1
	end
end

HeroWindowInventory._update_crafting_material_panel = function (self)
	-- function 11
	local get_interface = Managers.backend:get_interface("items")
	local crafting_material_icons_small = UISettings.crafting_material_icons_small
	local crafting_material_order = UISettings.crafting_material_order
	local _widgets_by_name = self._widgets_by_name
	local num = 1

	for i, v in ipairs(crafting_material_order) do
		local var_11_5 = crafting_material_icons_small[v]
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

		::label_11_0::

		local content = _widgets_by_name["material_text_" .. i].content
		local var_11_12

		if get_item_amount < 10000 then
			var_11_12 = tostring(get_item_amount)
		elseif get_item_amount < 100000 then
			var_11_12 = string.format("%.1fk", get_item_amount * 0.001)
		else
			var_11_12 = "+99k"
		end

		content.text = var_11_12
		content.icon = var_11_5

		if not content.item then
			content.item = flag or {
				data = table.clone(ItemMasterList[v])
			}
		end
	end
end

HeroWindowInventory._update_inventory_items = function (self)
	-- function 12
	local _item_grid = self._item_grid
	local parent = self.parent
	local inventory_sync_id = parent.inventory_sync_id
	local get_selected_craft_page = parent:get_selected_craft_page()
	local get_craft_optional_item_filter = parent:get_craft_optional_item_filter()

	if not (inventory_sync_id ~= self._inventory_sync_id or get_selected_craft_page ~= self._selected_craft_page_name or self._optional_craft_item_filter == get_craft_optional_item_filter) then
		if get_selected_craft_page ~= self._selected_craft_page_name then
			self:_change_category_by_name(get_selected_craft_page)
		elseif not get_craft_optional_item_filter then
			self:change_item_filter(get_craft_optional_item_filter, true)
		else
			self:_change_category_by_index(nil, true)
		end

		self._inventory_sync_id = inventory_sync_id
		self._selected_craft_page_name = get_selected_craft_page
		self._optional_craft_item_filter = get_craft_optional_item_filter

		self:_update_crafting_material_panel()
	end
end

HeroWindowInventory._update_disabled_backend_ids = function (self)
	-- function 13
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

HeroWindowInventory._exit = function (self, arg_14_1)
	-- function 14
	self.exit = true
	self.exit_level_id = arg_14_1
end

HeroWindowInventory.draw = function (self, arg_15_1)
	-- function 15
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_15_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

HeroWindowInventory._play_sound = function (self, arg_16_1)
	-- function 16
	self.parent:play_sound(arg_16_1)
end

HeroWindowInventory._change_category_by_name = function (self, arg_17_1)
	-- function 17
	for i, v in ipairs(var_0_0) do
		if v.name == arg_17_1 then
			self:_change_category_by_index(i)

			break
		end
	end
end

HeroWindowInventory._change_category_by_index = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not arg_18_2 then
		arg_18_1 = self._current_category_index or 1
	end

	if not (self._current_category_index ~= arg_18_1 or arg_18_2) then
		return
	end

	self._current_category_index = arg_18_1

	local var_18_0 = var_0_0[arg_18_1]
	local name = var_18_0.name
	local item_sort_func = var_18_0.item_sort_func

	if not item_sort_func then
		self._item_grid:apply_item_sorting_function(item_sort_func)
	end

	self._item_grid:change_category(name, arg_18_2)

	return true
end

HeroWindowInventory.change_item_filter = function (self, arg_19_1, arg_19_2)
	-- function 19
	arg_19_2 = arg_19_2 or arg_19_2 == nil

	self._item_grid:change_item_filter(arg_19_1, arg_19_2)
end
