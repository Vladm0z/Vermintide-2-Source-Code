-- chunkname: @scripts/ui/views/versus_menu/versus_inventory_grid.lua

local var_0_0 = local_require("scripts/ui/views/versus_menu/versus_inventory_grid_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local flag = false

VersusInventoryGrid = class(VersusInventoryGrid)
VersusInventoryGrid.NAME = "VersusInventoryGrid"

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

VersusInventoryGrid._create_item_categories = function (self)
	-- function 2
	local career_index = self.career_index
	local profile_index = self.profile_index
	local item_slot_types_by_slot_name = SPProfiles[profile_index].careers[career_index].item_slot_types_by_slot_name
	local tbl_2 = {}

	for k, v in pairs(item_slot_types_by_slot_name) do
		local ui_slot_index = InventorySettings.slots_by_name[k].ui_slot_index

		if not ui_slot_index then
			local str = "( "
			local str_2 = ""
			local var_2_7
			local tbl_3 = {}

			for i, v_2 in ipairs(v) do
				local var_2_9 = tbl[v_2]

				str_2 = str_2 .. var_2_9
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
					var_2_7 = v_4

					break
				end
			end

			tbl_2[ui_slot_index] = {
				hero_specific_filter = true,
				name = k,
				display_name = str_2,
				icon = var_2_7,
				item_types = v,
				slot_index = ui_slot_index,
				slot_name = k,
				item_filter = str
			}
		end
	end

	return tbl_2
end

VersusInventoryGrid.on_enter = function (self, arg_3_1, arg_3_2)
	-- function 3
	print("[HeroViewWindow] Enter Substate VersusInventoryGrid")

	self.parent = arg_3_1.parent

	local ingame_ui_context = arg_3_1.ingame_ui_context

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
	self.hero_name = arg_3_1.hero_name
	self.career_index = arg_3_1.career_index
	self.profile_index = arg_3_1.profile_index
	self._category_settings = self:_create_item_categories()
	self._animations = {}

	self:create_ui_elements(arg_3_1, arg_3_2)

	local var_3_3 = ItemGridUI:new(self._category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index)

	self._item_grid = var_3_3

	var_3_3:mark_equipped_items(true)
	var_3_3:mark_locked_items(true)
	var_3_3:disable_locked_items(true)
	var_3_3:disable_unwieldable_items(true)
	var_3_3:disable_item_drag()
	var_3_3:apply_item_sorting_function(fn)

	local flag = not local_player and local_player.player_unit

	if not flag then
		local has_extension = ScriptUnit.has_extension(flag, "inventory_system")

		if not has_extension then
			has_extension:check_and_drop_pickups("enter_inventory")
		end
	end

	local loadout_slot_index = arg_3_1.loadout_slot_index

	loadout_slot_index = loadout_slot_index or 1
	self._selected_loadout_slot_index = loadout_slot_index

	self:_change_category_by_index(self._selected_loadout_slot_index)

	self._job_done = false
end

VersusInventoryGrid.create_ui_elements = function (self, arg_4_1, arg_4_2)
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

VersusInventoryGrid._setup_tab_widget = function (self)
	-- function 5
	local item_slot_types_by_slot_name = SPProfiles[self.profile_index].careers[self.career_index].item_slot_types_by_slot_name
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(item_slot_types_by_slot_name) do
		for i, v_2 in ipairs(v) do
			for i_2, v_3 in ipairs(self._category_settings) do
				if "slot_" .. v_2 == v_3.name then
					tbl_2[i_2] = true
					tbl[i_2] = i_2

					break
				end
			end
		end
	end

	local num = 0
	local tbl_3 = {}

	for k_2, v_4 in pairs(tbl_2) do
		num = num + 1
		tbl_3[#tbl_3 + 1] = k_2
	end

	local function fn(arg_6_0, arg_6_1)
		-- function 6
		return arg_6_0 < arg_6_1
	end

	table.sort(tbl_3, fn)

	self._tabs_category_index_lookups = tbl_3
	self._career_category_settings_index_lookup = tbl

	local _widgets = self._widgets
	local _widgets_by_name = self._widgets_by_name
	local var_5_8 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_vertical", {
		5,
		35
	}, "item_tabs_segments", num - 1))
	local var_5_9 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_top", {
		17,
		9
	}, "item_tabs_segments_top", num - 1))
	local var_5_10 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_bottom", {
		17,
		9
	}, "item_tabs_segments_bottom", num - 1))

	_widgets_by_name.item_tabs_segments = var_5_8
	_widgets_by_name.item_tabs_segments_top = var_5_9
	_widgets_by_name.item_tabs_segments_bottom = var_5_10
	_widgets[#_widgets + 1] = var_5_8
	_widgets[#_widgets + 1] = var_5_9
	_widgets[#_widgets + 1] = var_5_10
end

VersusInventoryGrid.on_exit = function (self, arg_7_1)
	-- function 7
	print("[HeroViewWindow] Exit Substate VersusInventoryGrid")

	self.ui_animator = nil

	self._item_grid:destroy()

	self._item_grid = nil
end

VersusInventoryGrid.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self._item_grid:update(arg_8_1, arg_8_2)
	self:_update_animations(arg_8_1)
	self:_handle_input(arg_8_1, arg_8_2)
	self:_update_page_info()
	self:draw(arg_8_1)

	return self._job_done
end

VersusInventoryGrid.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

VersusInventoryGrid._update_animations = function (self, arg_10_1)
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
end

VersusInventoryGrid._is_button_pressed = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

VersusInventoryGrid._is_button_hovered = function (arg_12_0, arg_12_1)
	-- function 12
	if not arg_12_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

VersusInventoryGrid._handle_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _widgets_by_name = self._widgets_by_name
	local parent = self.parent
	local _item_grid = self._item_grid
	local flag = false
	local is_item_pressed, var_13_5 = _item_grid:is_item_pressed(flag)
	local window_input_service = parent:window_input_service()

	if not _item_grid:handle_favorite_marking(window_input_service) then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not is_item_pressed then
		self:_set_loadout_item(is_item_pressed, self._strict_slot_type)
		self:_play_sound("play_gui_equipment_equip_hero")
	end

	if not is_item_pressed and var_13_5 and not window_input_service:get("toggle_menu") then
		self._job_done = true
	end

	if not Managers.input:is_device_active("gamepad") then
		local get_service = Managers.input:get_service("hero_view")
		local _selected_loadout_slot_index = parent._selected_loadout_slot_index

		_selected_loadout_slot_index = _selected_loadout_slot_index or 1

		local count = #self._career_category_settings_index_lookup

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

	UIWidgetUtils.animate_default_button(page_button_next, arg_13_1)
	UIWidgetUtils.animate_default_button(page_button_previous, arg_13_1)

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

VersusInventoryGrid._update_page_info = function (self)
	-- function 14
	local get_page_info, var_14_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_14_1 == self._total_pages) then
		self._total_pages = var_14_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_14_1 = var_14_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_14_1)
		_widgets_by_name.page_button_next.content.button_hotspot.disable_button = get_page_info == var_14_1
		_widgets_by_name.page_button_previous.content.button_hotspot.disable_button = get_page_info == 1
	end
end

VersusInventoryGrid._get_actual_loadout_category_index = function (self, arg_15_1)
	-- function 15
	return self._career_category_settings_index_lookup[arg_15_1]
end

VersusInventoryGrid._update_selected_loadout_slot_index = function (self)
	-- function 16
	local get_selected_loadout_slot_index = self.parent:get_selected_loadout_slot_index()
	local var_16_1 = self._career_category_settings_index_lookup[get_selected_loadout_slot_index]

	if get_selected_loadout_slot_index ~= self._selected_loadout_slot_index then
		self:_change_category_by_index(get_selected_loadout_slot_index)

		self._selected_loadout_slot_index = get_selected_loadout_slot_index
		self._internal_slot_index = var_16_1
	end
end

VersusInventoryGrid._update_loadout_sync = function (self)
	-- function 17
	local _item_grid = self._item_grid
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self._loadout_sync_id = loadout_sync_id

		_item_grid:update_items_status()
	end
end

VersusInventoryGrid._exit = function (self, arg_18_1)
	-- function 18
	self.exit = true
	self.exit_level_id = arg_18_1
end

VersusInventoryGrid.draw = function (self, arg_19_1)
	-- function 19
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

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

VersusInventoryGrid._play_sound = function (self, arg_20_1)
	-- function 20
	self.parent:play_sound(arg_20_1)
end

VersusInventoryGrid._change_category_by_index = function (self, arg_21_1, arg_21_2)
	-- function 21
	local var_21_0 = self._career_category_settings_index_lookup[arg_21_1]

	if not arg_21_2 then
		arg_21_1 = self._internal_slot_index or 1
	end

	self._strict_slot_type = self._category_settings[arg_21_1].name

	if self._internal_slot_index == var_21_0 then
		return
	end

	local var_21_1 = self._category_settings[var_21_0]
	local name = var_21_1.name
	local display_name = var_21_1.display_name

	self._widgets_by_name.item_grid_header.content.text = display_name

	self._item_grid:change_category(name)

	return true
end

VersusInventoryGrid._get_slot_by_type = function (arg_22_0, arg_22_1)
	-- function 22
	local slots_by_slot_index = InventorySettings.slots_by_slot_index

	for k, v in pairs(slots_by_slot_index) do
		if arg_22_1 == "slot_" .. v.type then
			return v
		end
	end
end

VersusInventoryGrid._set_loadout_item = function (self, arg_23_1, arg_23_2)
	-- function 23
	local profile_index = self.profile_index
	local career_index = self.career_index
	local var_23_2 = SPProfiles[profile_index].careers[career_index]
	local data = arg_23_1.data
	local flag = arg_23_2 or data.slot_type
	local _get_slot_by_type = self:_get_slot_by_type(flag)
	local backend_id = arg_23_1.backend_id
	local name = var_23_2.name
	local name_2 = _get_slot_by_type.name

	Managers.backend:get_interface("items"):set_loadout_item(backend_id, name, name_2)
	self.parent:new_item_equipped()

	self._job_done = true
end
