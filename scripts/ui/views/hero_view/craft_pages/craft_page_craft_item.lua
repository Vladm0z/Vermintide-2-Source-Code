-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_craft_item.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_craft_item_definitions")
local widgets = var_0_3.widgets
local category_settings = var_0_3.category_settings
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local flag = false
local num = 1

CraftPageCraftItem = class(CraftPageCraftItem)
CraftPageCraftItem.NAME = "CraftPageCraftItem"

CraftPageCraftItem.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroWindowCraft] Enter Substate CraftPageCraftItem")

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
	self._animations = {}

	self:create_ui_elements(arg_1_1)

	self._craft_items = {}
	self._material_items = {}
	self._item_grid = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index)

	self._item_grid:disable_locked_items(true)
	self._item_grid:mark_locked_items(true)
	self._item_grid:hide_slots(true)
	self._item_grid:disable_item_drag()
	self.super_parent:clear_disabled_backend_ids()
	self:setup_recipe_requirements()
end

CraftPageCraftItem.setup_recipe_requirements = function (self)
	-- function 2
	local name = self.settings.name
	local var_2_1 = self._craft_items[1]
	local get_interface = Managers.backend:get_interface("items")
	local flag = not var_2_1 and get_interface:get_item_masterlist_data(var_2_1)
	local flag_2 = not flag and flag.slot_type
	local flag_3 = not var_2_1 and get_interface:get_item_rarity(var_2_1)
	local flag_4 = not var_2_1 and flag_3 == "default"

	if not var_2_1 then
		if not (flag_2 == "ranged" or flag_2 ~= "melee") then
			name = "craft_weapon"
		elseif not (flag_2 == "trinket" or flag_2 == "ring" or flag_2 ~= "necklace") then
			name = "craft_jewellery"
		end
	end

	self._recipe_name = name

	local ingredients = var_0_1[name].ingredients
	local num = 0

	for i, v in ipairs(ingredients) do
		if not v.catergory then
			num = num + 1
		end
	end

	self:create_recipe_grid_by_amount(num)

	local _material_items = self._material_items

	table.clear(_material_items)

	local get_interface_2 = Managers.backend:get_interface("items")
	local get_filtered_items = get_interface_2:get_filtered_items("item_type == crafting_material")
	local flag_5 = true
	local num_2 = 1
	local _recipe_grid = self._recipe_grid

	for i_2, v_2 in ipairs(ingredients) do
		if not v_2.catergory then
			local name_2 = v_2.name
			local amount = v_2.amount
			local num_3 = 0
			local var_2_18

			for i_3, v_3 in ipairs(get_filtered_items) do
				local backend_id = v_3.backend_id

				if v_3.data.key == name_2 then
					var_2_18 = backend_id
					num_3 = get_interface_2:get_item_amount(backend_id)

					break
				end
			end

			local flag_6 = amount <= num_3
			local var_2_21

			if num_3 < UISettings.max_craft_material_presentation_amount then
				var_2_21 = tostring(num_3)

				if not var_2_21 then
					-- Nothing
				end
			end

			var_2_21 = "*"

			::label_2_0::

			local str = var_2_21 .. "/" .. tostring(amount)
			local tbl = {
				data = table.clone(ItemMasterList[name_2]),
				amount = str,
				insufficient_amount = not flag_6
			}

			_recipe_grid:add_item_to_slot_index(num_2, tbl)

			num_2 = num_2 + 1

			if not flag_6 then
				_material_items[#_material_items + 1] = var_2_18
			else
				flag_5 = false
			end
		end
	end

	self._has_all_requirements = not flag_5 and flag_4

	self:_set_craft_button_disabled(not self._has_all_requirements)
end

CraftPageCraftItem.create_recipe_grid_by_amount = function (self, arg_3_1)
	-- function 3
	if not self._recipe_grid then
		self._recipe_grid:destroy()

		self._recipe_grid = nil
	end

	local create_recipe_grid = UIWidgets.create_recipe_grid("recipe_grid", scenegraph_definition.recipe_grid.size, 1, arg_3_1, 30, 30)
	local var_3_1 = UIWidget.init(create_recipe_grid)

	for i, v in ipairs(self._widgets) do
		if v == self._widgets_by_name.recipe_grid then
			self._widgets[i] = var_3_1
			self._widgets_by_name.recipe_grid = var_3_1

			break
		end
	end

	self._recipe_grid = ItemGridUI:new(category_settings, self._widgets_by_name.recipe_grid, self.hero_name, self.career_index)

	self._recipe_grid:disable_item_drag()
end

CraftPageCraftItem.create_ui_elements = function (self, arg_4_1)
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

	self:_handle_craft_input_progress(0)
end

CraftPageCraftItem.on_exit = function (self, arg_5_1)
	-- function 5
	print("[HeroWindowCraft] Exit Substate CraftPageCraftItem")

	self.ui_animator = nil

	if not self._craft_input_time then
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageCraftItem.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_handle_input(arg_6_1, arg_6_2)
	self:_update_animations(arg_6_1)
	self:_update_craft_items()
	self:draw(arg_6_1)
end

CraftPageCraftItem.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

CraftPageCraftItem._update_animations = function (self, arg_8_1)
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

	UIWidgetUtils.animate_default_button(_widgets_by_name.craft_button, arg_8_1)
end

CraftPageCraftItem._is_button_pressed = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

CraftPageCraftItem._is_button_hovered = function (arg_10_0, arg_10_1)
	-- function 10
	if not arg_10_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageCraftItem._is_button_held = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

CraftPageCraftItem._handle_input = function (self, arg_12_1, arg_12_2)
	-- function 12
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

	if _is_button_held == 0 or not flag_2 or not self._has_all_requirements then
		if not self._craft_input_time then
			self._craft_input_time = 0

			self:_play_sound("play_gui_craft_forge_button_begin")
		else
			self._craft_input_time = self._craft_input_time + arg_12_1
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
		local _material_items = self._material_items
		local tbl = {}

		for i, v in ipairs(_craft_items) do
			tbl[#tbl + 1] = v
		end

		for i_2, v_2 in ipairs(_material_items) do
			tbl[#tbl + 1] = v_2
		end

		if not parent:craft(tbl, self._recipe_name) then
			self:_set_craft_button_disabled(true)

			local _item_grid = self._item_grid

			for k, v_3 in pairs(tbl) do
				_item_grid:lock_item_by_id(v_3, true)
			end

			_item_grid:update_items_status()
			self:_play_sound("play_gui_craft_forge_button_completed")
			self:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageCraftItem._handle_craft_input_progress = function (arg_13_0, arg_13_1)
	-- function 13
	local flag

	flag = arg_13_1 ~= 0

	local var_13_1 = scenegraph_definition.craft_bar.size[1]

	arg_13_0.ui_scenegraph.craft_bar.size[1] = var_13_1 * arg_13_1

	if arg_13_1 == 1 then
		return true
	end
end

CraftPageCraftItem.craft_result = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not arg_14_2 then
		self._craft_result = arg_14_1
	end
end

CraftPageCraftItem.reset = function (self)
	-- function 15
	local _item_grid = self._item_grid

	_item_grid:clear_locked_items()
	_item_grid:update_items_status()
	self:_set_craft_button_disabled(not self._has_all_requirements)
end

CraftPageCraftItem.on_craft_completed = function (self)
	-- function 16
	local _craft_result = self._craft_result
	local _item_grid = self._item_grid

	table.clear(self._craft_items)

	for i = 1, num do
		self._craft_items[i] = nil
	end

	_item_grid:clear_item_grid()
	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()

	local num_2 = 0

	for k, v in pairs(_craft_result) do
		num_2 = num_2 + 1
	end

	local flag = true

	for k_2, v_2 in pairs(_craft_result) do
		local var_16_4 = v_2[1]
		local var_16_5 = v_2[3]

		self:_add_craft_item(var_16_4, k_2, flag)
	end

	_item_grid:clear_locked_items()

	for k_3, v_3 in pairs(self._craft_items) do
		_item_grid:lock_item_by_id(v_3, true)
	end

	_item_grid:update_items_status()

	self._num_craft_items = 0

	self:_set_craft_button_disabled(true)

	self._craft_result = nil

	self:setup_recipe_requirements()
end

CraftPageCraftItem._update_craft_items = function (self)
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
					self:setup_recipe_requirements()
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

CraftPageCraftItem._remove_craft_item = function (self, arg_18_1, arg_18_2)
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

		self:_play_sound("play_gui_craft_item_drag")
		self:setup_recipe_requirements()

		self._widgets_by_name.item_grid_random_icon.content.visible = true
	end
end

CraftPageCraftItem._add_craft_item = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if self._num_craft_items == 0 then
		self._item_grid:clear_item_grid()
		table.clear(self._craft_items)
	end

	local _craft_items = self._craft_items

	if not arg_19_2 then
		for i = 1, num do
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

		self._item_grid:add_item_to_slot_index(arg_19_2, flag)
		self.super_parent:set_disabled_backend_id(arg_19_1, true)

		local min = math.min
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = min(_num_craft_items + 1, num)

		if not (not arg_19_1 and arg_19_3) then
			self:_play_sound("play_gui_craft_item_drop")
		end

		self._widgets_by_name.item_grid_random_icon.content.visible = false
	end

	self:setup_recipe_requirements()
end

CraftPageCraftItem._set_craft_button_disabled = function (arg_20_0, arg_20_1)
	-- function 20
	arg_20_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_20_1
end

CraftPageCraftItem._exit = function (self, arg_21_1)
	-- function 21
	self.exit = true
	self.exit_level_id = arg_21_1
end

CraftPageCraftItem.draw = function (self, arg_22_1)
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

CraftPageCraftItem._play_sound = function (self, arg_23_1)
	-- function 23
	self.super_parent:play_sound(arg_23_1)
end

CraftPageCraftItem._set_craft_button_text = function (self, arg_24_1, arg_24_2)
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
