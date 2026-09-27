-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_roll_properties.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_roll_properties_definitions")
local widgets = var_0_3.widgets
local category_settings = var_0_3.category_settings
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local flag = false
local num = 1

CraftPageRollProperties = class(CraftPageRollProperties)
CraftPageRollProperties.NAME = "CraftPageRollProperties"

CraftPageRollProperties.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroWindowCraft] Enter Substate CraftPageRollProperties")

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
	self._animations = {}

	self:create_ui_elements(arg_1_1)

	self._craft_items = {}
	self._material_items = {}
	self._item_grid = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index)
	self._recipe_grid = ItemGridUI:new(category_settings, self._widgets_by_name.recipe_grid, self.hero_name, self.career_index)

	self._item_grid:disable_locked_items(true)
	self._item_grid:mark_locked_items(true)
	self._item_grid:hide_slots(true)
	self._item_grid:disable_item_drag()
	self._recipe_grid:disable_item_drag()
	self.super_parent:clear_disabled_backend_ids()
	self:setup_recipe_requirements()
end

CraftPageRollProperties.setup_recipe_requirements = function (self)
	-- function 2
	local _recipe_grid = self._recipe_grid
	local name = self.settings.name
	local ingredients = var_0_1[name].ingredients
	local _material_items = self._material_items

	table.clear(_material_items)

	local get_interface = Managers.backend:get_interface("items")
	local get_filtered_items = get_interface:get_filtered_items("item_type == crafting_material")
	local flag = true
	local num = 1

	for i, v in ipairs(ingredients) do
		if not v.catergory then
			local name_2 = v.name
			local amount = v.amount
			local num_2 = 0
			local var_2_11

			for i_2, v_2 in ipairs(get_filtered_items) do
				local backend_id = v_2.backend_id

				if v_2.data.key == name_2 then
					var_2_11 = backend_id
					num_2 = get_interface:get_item_amount(backend_id)

					break
				end
			end

			local flag_2 = amount <= num_2
			local var_2_14

			if num_2 < UISettings.max_craft_material_presentation_amount then
				var_2_14 = tostring(num_2)

				if not var_2_14 then
					-- Nothing
				end
			end

			var_2_14 = "*"

			::label_2_0::

			local str = var_2_14 .. "/" .. tostring(amount)
			local tbl = {
				data = table.clone(ItemMasterList[name_2]),
				amount = str,
				insufficient_amount = not flag_2
			}

			_recipe_grid:add_item_to_slot_index(num, tbl)

			num = num + 1

			if not flag_2 then
				_material_items[#_material_items + 1] = var_2_11
			else
				flag = false
			end
		end
	end

	self._has_all_requirements = flag
end

CraftPageRollProperties.create_ui_elements = function (self, arg_3_1)
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

	self:_set_craft_button_disabled(true)
	self:_handle_craft_input_progress(0)
end

CraftPageRollProperties.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroWindowCraft] Exit Substate CraftPageRollProperties")

	self.ui_animator = nil

	if not self._craft_input_time then
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageRollProperties.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_handle_input(arg_5_1, arg_5_2)
	self:_update_animations(arg_5_1)
	self:_update_craft_items()
	self:draw(arg_5_1)
end

CraftPageRollProperties.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

CraftPageRollProperties._update_animations = function (self, arg_7_1)
	-- function 7
	self.ui_animator:update(arg_7_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.craft_button, arg_7_1)
end

CraftPageRollProperties._is_button_pressed = function (arg_8_0, arg_8_1)
	-- function 8
	local button_hotspot = arg_8_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

CraftPageRollProperties._is_button_hovered = function (arg_9_0, arg_9_1)
	-- function 9
	if not arg_9_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageRollProperties._is_button_held = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

CraftPageRollProperties._handle_input = function (self, arg_11_1, arg_11_2)
	-- function 11
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
			self._craft_input_time = self._craft_input_time + arg_11_1
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

CraftPageRollProperties._handle_craft_input_progress = function (arg_12_0, arg_12_1)
	-- function 12
	local flag

	flag = arg_12_1 ~= 0

	local var_12_1 = scenegraph_definition.craft_bar.size[1]

	arg_12_0.ui_scenegraph.craft_bar.size[1] = var_12_1 * arg_12_1

	if arg_12_1 == 1 then
		return true
	end
end

CraftPageRollProperties.craft_result = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not arg_13_2 then
		self._craft_result = arg_13_1
	end
end

CraftPageRollProperties.reset = function (self)
	-- function 14
	local _item_grid = self._item_grid

	_item_grid:clear_locked_items()
	_item_grid:update_items_status()
end

CraftPageRollProperties.on_craft_completed = function (self)
	-- function 15
	local _craft_result = self._craft_result
	local _item_grid = self._item_grid

	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()
	self:setup_recipe_requirements()

	local flag = true

	for i = 1, num do
		local var_15_3 = self._craft_items[i]

		self:_remove_craft_item(var_15_3, i, flag)
		self:_add_craft_item(var_15_3, i, flag)
	end

	self._craft_result = nil
end

CraftPageRollProperties._update_craft_items = function (self)
	-- function 16
	local super_parent = self.super_parent
	local _item_grid = self._item_grid
	local is_dragging_item = _item_grid:is_dragging_item()

	is_dragging_item = is_dragging_item or _item_grid:is_item_dragged() ~= nil

	local get_pressed_item_backend_id, var_16_4 = super_parent:get_pressed_item_backend_id()

	if not get_pressed_item_backend_id then
		if not var_16_4 then
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

CraftPageRollProperties._remove_craft_item = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local _craft_items = self._craft_items

	if not arg_17_2 then
		if not _craft_items[arg_17_2] then
			arg_17_1 = _craft_items[arg_17_2]
		end
	else
		for k, v in pairs(_craft_items) do
			if v == arg_17_1 then
				arg_17_2 = k

				break
			end
		end
	end

	if not arg_17_1 and not arg_17_2 then
		self.super_parent:set_disabled_backend_id(arg_17_1, false)
		self._item_grid:add_item_to_slot_index(arg_17_2, nil)

		_craft_items[arg_17_2] = nil

		local max = math.max
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = max(_num_craft_items - 1, 0)

		if self._num_craft_items == 0 then
			self:_set_craft_button_disabled(true)
		end

		if not arg_17_3 then
			self:_play_sound("play_gui_craft_item_drag")
		end

		self._recipe_name = self.settings.name
	end
end

CraftPageRollProperties._add_craft_item = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if self._num_craft_items == 0 then
		self._item_grid:clear_item_grid()
		table.clear(self._craft_items)
	end

	local _craft_items = self._craft_items

	if not arg_18_2 then
		for i = 1, 1 do
			if not _craft_items[i] then
				arg_18_2 = i

				break
			end
		end
	end

	if not arg_18_2 then
		_craft_items[arg_18_2] = arg_18_1

		local get_interface = Managers.backend:get_interface("items")
		local flag = not arg_18_1 and get_interface:get_item_from_id(arg_18_1)
		local flag_2 = not arg_18_1 and get_interface:get_item_masterlist_data(arg_18_1)
		local flag_3 = not flag_2 and flag_2.slot_type

		if not (flag_3 == "ranged" or flag_3 ~= "melee") then
			self._recipe_name = "reroll_weapon_properties"
		elseif not (flag_3 == "trinket" or flag_3 == "ring" or flag_3 ~= "necklace") then
			self._recipe_name = "reroll_jewellery_properties"
		end

		self._item_grid:add_item_to_slot_index(arg_18_2, flag)
		self.super_parent:set_disabled_backend_id(arg_18_1, true)

		local min = math.min
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = min(_num_craft_items + 1, num)

		if not (self._num_craft_items > 0) or not self._has_all_requirements then
			self:_set_craft_button_disabled(false)
		end

		if not (not arg_18_1 and arg_18_3) then
			self:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageRollProperties._set_craft_button_disabled = function (arg_19_0, arg_19_1)
	-- function 19
	arg_19_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_19_1
end

CraftPageRollProperties._exit = function (self, arg_20_1)
	-- function 20
	self.exit = true
	self.exit_level_id = arg_20_1
end

CraftPageRollProperties.draw = function (self, arg_21_1)
	-- function 21
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.super_parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_21_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

CraftPageRollProperties._play_sound = function (self, arg_22_1)
	-- function 22
	self.super_parent:play_sound(arg_22_1)
end

CraftPageRollProperties._set_craft_button_text = function (self, arg_23_1, arg_23_2)
	-- function 23
	local content = self._widgets_by_name.craft_button.content
	local var_23_1

	if not arg_23_2 then
		var_23_1 = Localize(arg_23_1)

		if not var_23_1 then
			-- Nothing
		end
	end

	var_23_1 = arg_23_1

	::label_23_0::

	content.button_text = var_23_1
end
