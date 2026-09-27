-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_grid.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_grid_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
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

StartGameWindowMutatorGrid = class(StartGameWindowMutatorGrid)
StartGameWindowMutatorGrid.NAME = "StartGameWindowMutatorGrid"

StartGameWindowMutatorGrid.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorGrid")

	self.parent = arg_2_1.parent

	local ingame_ui_context = arg_2_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id

	self:create_ui_elements(arg_2_1, arg_2_2)

	local str = "empire_soldier"
	local num = 1
	local var_2_4 = ItemGridUI:new(tbl, self._widgets_by_name.item_grid, str, num)

	var_2_4:change_category("heroic_deeds")
	var_2_4:disable_item_drag()
	var_2_4:apply_item_sorting_function(fn)

	self._item_grid = var_2_4
end

StartGameWindowMutatorGrid.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_3
		tbl_2[k] = var_3_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	if not arg_3_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end
end

StartGameWindowMutatorGrid.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorGrid")
	self._item_grid:destroy()

	self._item_grid = nil
end

StartGameWindowMutatorGrid.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._item_grid:update(arg_5_1, arg_5_2)
	self:_update_page_info()
	self:_update_selected_item_backend_id()
	self:_handle_input(arg_5_1, arg_5_2)
	self:draw(arg_5_1)
end

StartGameWindowMutatorGrid.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

StartGameWindowMutatorGrid._is_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowMutatorGrid._is_button_hovered = function (arg_8_0, arg_8_1)
	-- function 8
	if not arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

StartGameWindowMutatorGrid._handle_input = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _widgets_by_name = self._widgets_by_name
	local _item_grid = self._item_grid
	local flag = true
	local is_item_pressed = _item_grid:is_item_pressed(flag)

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not is_item_pressed then
		self:_play_sound("play_gui_lobby_button_04_heroic_deed_inventory_click")

		local backend_id = is_item_pressed.backend_id

		self.parent:set_selected_heroic_deed_backend_id(backend_id)
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

StartGameWindowMutatorGrid._play_sound = function (self, arg_10_1)
	-- function 10
	self.parent:play_sound(arg_10_1)
end

StartGameWindowMutatorGrid._update_selected_item_backend_id = function (self)
	-- function 11
	local get_selected_heroic_deed_backend_id = self.parent:get_selected_heroic_deed_backend_id()

	if get_selected_heroic_deed_backend_id ~= self._selected_backend_id then
		self._selected_backend_id = get_selected_heroic_deed_backend_id

		self._item_grid:set_backend_id_selected(get_selected_heroic_deed_backend_id)
	elseif not get_selected_heroic_deed_backend_id then
		local get_item_in_slot = self._item_grid:get_item_in_slot(1, 1)

		if not get_item_in_slot then
			self.parent:set_selected_heroic_deed_backend_id(get_item_in_slot.backend_id)
		end
	end
end

StartGameWindowMutatorGrid.draw = function (self, arg_12_1)
	-- function 12
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_12_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_12_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_12_4)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowMutatorGrid._update_page_info = function (self)
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
		_widgets_by_name.page_button_next.content.button_hotspot.disable_button = get_page_info == var_13_1
		_widgets_by_name.page_button_previous.content.button_hotspot.disable_button = get_page_info == 1
	end
end
