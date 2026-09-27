-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_salvage.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_salvage_definitions")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false

CraftPageSalvage = class(CraftPageSalvage)
CraftPageSalvage.NAME = "CraftPageSalvage"

CraftPageSalvage.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroWindowCraft] Enter Substate CraftPageSalvage")

	self.parent = arg_1_1.parent
	self.super_parent = self.parent.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.crafting_manager = Managers.state.crafting

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.profile_index = arg_1_1.profile_index
	self.wwise_world = arg_1_1.wwise_world
	self.settings = arg_1_2
	self._recipe_name = arg_1_2.name
	self._num_craft_items = 0
	self._animations = {}

	self:create_ui_elements(arg_1_1)

	self._craft_items = {}
	self._item_grid = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index)

	self._item_grid:disable_locked_items(true)
	self._item_grid:mark_locked_items(true)
	self._item_grid:hide_slots(true)
	self._item_grid:disable_item_drag()
	self.super_parent:clear_disabled_backend_ids()
end

CraftPageSalvage.create_ui_elements = function (self, arg_2_1)
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

	self:_set_craft_button_disabled(true)
	self:_handle_craft_input_progress(0)
end

CraftPageSalvage.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroWindowCraft] Exit Substate CraftPageSalvage")

	self.ui_animator = nil

	if not self._craft_input_time then
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageSalvage.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_handle_input(arg_4_1, arg_4_2)
	self:_update_animations(arg_4_1)
	self:_update_craft_items()
	self:draw(arg_4_1)
end

CraftPageSalvage.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

CraftPageSalvage._update_animations = function (self, arg_6_1)
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

	UIWidgetUtils.animate_default_button(_widgets_by_name.craft_button, arg_6_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_plentiful, arg_6_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_common, arg_6_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_rare, arg_6_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_exotic, arg_6_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_clear, arg_6_1)
end

CraftPageSalvage._is_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

CraftPageSalvage._is_button_hovered = function (arg_8_0, arg_8_1)
	-- function 8
	if not arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageSalvage._is_button_held = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

CraftPageSalvage._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	local parent = self.parent

	if parent:waiting_for_craft() or not self._craft_result then
		return
	end

	local _widgets_by_name = self._widgets_by_name
	local super_parent = self.super_parent
	local is_device_active = Managers.input:is_device_active("gamepad")
	local window_input_service = self.super_parent:window_input_service()
	local flag = not _widgets_by_name.craft_button.content.button_hotspot.disable_button
	local _is_button_held = self:_is_button_held(_widgets_by_name.craft_button)
	local flag_2 = not flag and not is_device_active and window_input_service:get("refresh_hold")
	local flag_3 = false

	if _is_button_held == 0 or not flag_2 then
		if not self._craft_input_time then
			self._craft_input_time = 0

			self:_play_sound("play_gui_craft_forge_button_begin")
		else
			self._craft_input_time = self._craft_input_time + arg_10_1
		end

		local crafting_progress_time = UISettings.crafting_progress_time
		local min = math.min(self._craft_input_time / crafting_progress_time, 1)

		flag_3 = self:_handle_craft_input_progress(min)

		WwiseWorld.set_global_parameter(self.wwise_world, "craft_forge_button_progress", min)
	elseif not self._craft_input_time then
		self._craft_input_time = nil

		self:_handle_craft_input_progress(0)
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if not flag_3 then
		local _craft_items = self._craft_items

		if not parent:craft(_craft_items, self._recipe_name) then
			self:_set_craft_button_disabled(true)

			local _item_grid = self._item_grid

			for k, v in pairs(_craft_items) do
				_item_grid:lock_item_by_id(v, true)
			end

			_item_grid:update_items_status()
			self:_play_sound("play_gui_craft_forge_button_completed")
			self:_play_sound("play_gui_craft_forge_begin")
		end
	end

	if not flag_3 then
		if not self:_is_button_pressed(_widgets_by_name.auto_fill_plentiful) then
			self:_fill_by_rarity("plentiful")
		end

		if not self:_is_button_pressed(_widgets_by_name.auto_fill_common) then
			self:_fill_by_rarity("common")
		end

		if not self:_is_button_pressed(_widgets_by_name.auto_fill_rare) then
			self:_fill_by_rarity("rare")
		end

		if not self:_is_button_pressed(_widgets_by_name.auto_fill_exotic) then
			self:_fill_by_rarity("exotic")
		end

		if not self:_is_button_pressed(_widgets_by_name.auto_fill_clear) then
			self:clear_craft_items()
		end
	end
end

CraftPageSalvage._fill_by_rarity = function (self, arg_11_1)
	-- function 11
	if not self.parent:get_active_recipe() then
		return
	end

	if CraftingSettings.NUM_SALVAGE_SLOTS - self._num_craft_items <= 0 then
		return
	end

	local flag = false
	local get_inventory_grid = self.super_parent:get_inventory_grid()
	local _craft_items = self._craft_items
	local items = get_inventory_grid:items()

	for i, v in ipairs(items) do
		local backend_id = v.backend_id

		if not (not backend_id and v.rarity ~= arg_11_1 or table.find(_craft_items, backend_id)) then
			local _add_craft_item = self:_add_craft_item(backend_id, nil, flag)

			flag = flag or _add_craft_item

			if table.size(_craft_items) == CraftingSettings.NUM_SALVAGE_SLOTS then
				break
			end
		end
	end
end

CraftPageSalvage._handle_craft_input_progress = function (arg_12_0, arg_12_1)
	-- function 12
	local flag

	flag = arg_12_1 ~= 0

	local var_12_1 = scenegraph_definition.craft_bar.size[1]

	arg_12_0.ui_scenegraph.craft_bar.size[1] = var_12_1 * arg_12_1

	if arg_12_1 == 1 then
		return true
	end
end

CraftPageSalvage.craft_result = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not arg_13_2 then
		self._craft_result = arg_13_1
	end
end

CraftPageSalvage.clear_craft_items = function (self)
	-- function 14
	local flag = false

	for k, v in pairs(self._craft_items) do
		local _remove_craft_item = self:_remove_craft_item(v, nil, flag)

		flag = flag or _remove_craft_item
	end

	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()
	self:reset()
end

CraftPageSalvage.reset = function (self)
	-- function 15
	local _item_grid = self._item_grid

	_item_grid:clear_locked_items()
	_item_grid:update_items_status()
end

CraftPageSalvage.on_craft_completed = function (self)
	-- function 16
	local _craft_result = self._craft_result
	local _item_grid = self._item_grid

	table.clear(self._craft_items)

	for i = 1, CraftingSettings.NUM_SALVAGE_SLOTS do
		self._craft_items[i] = nil
	end

	_item_grid:clear_item_grid()
	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()

	local num = 0

	for k, v in pairs(_craft_result) do
		num = num + 1
	end

	local flag = true

	for k_2, v_2 in pairs(_craft_result) do
		local var_16_4 = v_2[1]
		local var_16_5 = v_2[3]

		if num == 1 then
			self:_add_craft_item(var_16_4, 5, flag, var_16_5)
		else
			self:_add_craft_item(var_16_4, k_2, flag, var_16_5)
		end
	end

	_item_grid:clear_locked_items()

	for k_3, v_3 in pairs(self._craft_items) do
		_item_grid:lock_item_by_id(v_3, true)
	end

	_item_grid:update_items_status()

	self._num_craft_items = 0

	self:_set_craft_button_disabled(true)

	self._craft_result = nil
end

CraftPageSalvage._update_craft_items = function (self)
	-- function 17
	local super_parent = self.super_parent
	local _item_grid = self._item_grid
	local is_dragging_item = _item_grid:is_dragging_item()

	is_dragging_item = is_dragging_item or _item_grid:is_item_dragged() ~= nil

	local get_pressed_item_backend_id, var_17_4 = super_parent:get_pressed_item_backend_id()

	if not get_pressed_item_backend_id then
		if not var_17_4 then
			if not is_dragging_item then
				local is_slot_hovered = _item_grid:is_slot_hovered()

				if not is_slot_hovered then
					self:_add_craft_item(get_pressed_item_backend_id, is_slot_hovered)
				end
			end
		else
			self:_add_craft_item(get_pressed_item_backend_id)
		end
	end

	local is_item_pressed = _item_grid:is_item_pressed()

	if not is_item_pressed then
		local backend_id = is_item_pressed.backend_id

		self:_remove_craft_item(backend_id)
	end
end

CraftPageSalvage._remove_craft_item = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local _craft_items = self._craft_items

	if not arg_18_2 then
		if not _craft_items[arg_18_2] then
			arg_18_1 = _craft_items[arg_18_2]
		end
	else
		for k, v in pairs(_craft_items) do
			if v == arg_18_1 then
				arg_18_2 = k

				break
			end
		end
	end

	if not arg_18_1 and not arg_18_2 then
		self.super_parent:set_disabled_backend_id(arg_18_1, false)
		self._item_grid:add_item_to_slot_index(arg_18_2, nil)

		_craft_items[arg_18_2] = nil

		local max = math.max
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = max(_num_craft_items - 1, 0)

		if self._num_craft_items == 0 then
			self:_set_craft_button_disabled(true)
		end

		if not arg_18_3 then
			self:_play_sound("play_gui_craft_item_drag")
		end

		return true
	end

	return false
end

CraftPageSalvage._add_craft_item = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	if self._num_craft_items == 0 then
		self._item_grid:clear_item_grid()
		table.clear(self._craft_items)
	end

	local _craft_items = self._craft_items

	if not arg_19_2 then
		for i = 1, CraftingSettings.NUM_SALVAGE_SLOTS do
			if not _craft_items[i] then
				arg_19_2 = i

				break
			end
		end
	end

	if not arg_19_2 then
		_craft_items[arg_19_2] = arg_19_1

		local get_interface = Managers.backend:get_interface("items")
		local flag = not arg_19_1 and get_interface:get_item_from_id(arg_19_1)

		self._item_grid:add_item_to_slot_index(arg_19_2, flag, arg_19_4)
		self.super_parent:set_disabled_backend_id(arg_19_1, true)

		local min = math.min
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = min(_num_craft_items + 1, CraftingSettings.NUM_SALVAGE_SLOTS)

		if self._num_craft_items > 0 then
			self:_set_craft_button_disabled(false)
		end

		if not (not arg_19_1 and arg_19_3) then
			self:_play_sound("play_gui_craft_item_drop")
		end

		return true
	end

	return false
end

CraftPageSalvage._set_craft_button_disabled = function (arg_20_0, arg_20_1)
	-- function 20
	arg_20_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_20_1
end

CraftPageSalvage._exit = function (self, arg_21_1)
	-- function 21
	self.exit = true
	self.exit_level_id = arg_21_1
end

CraftPageSalvage.draw = function (self, arg_22_1)
	-- function 22
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.super_parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_22_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

CraftPageSalvage._play_sound = function (self, arg_23_1)
	-- function 23
	self.super_parent:play_sound(arg_23_1)
end

CraftPageSalvage._set_craft_button_text = function (self, arg_24_1, arg_24_2)
	-- function 24
	local content = self._widgets_by_name.craft_button.content
	local var_24_1

	if not arg_24_2 then
		var_24_1 = Localize(arg_24_1)

		if not var_24_1 then
			-- Nothing
		end
	end

	var_24_1 = arg_24_1

	::label_24_0::

	content.button_text = var_24_1
end
