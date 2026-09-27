-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_craft_item_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_craft_item_console_definitions")
local widgets = var_0_3.widgets
local category_settings = var_0_3.category_settings
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local flag = false
local num = 1

CraftPageCraftItemConsole = class(CraftPageCraftItemConsole)
CraftPageCraftItemConsole.NAME = "CraftPageCraftItemConsole"

CraftPageCraftItemConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroWindowCraft] Enter Substate CraftPageCraftItemConsole")

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

	self._params = {
		profile_index = self.profile_index,
		career_index = self.career_index
	}
	self._craft_items = {}
	self._material_items = {}
	self._item_grid = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index, self._params)

	self._item_grid:disable_locked_items(true)
	self._item_grid:mark_locked_items(true)
	self._item_grid:hide_slots(true)
	self._item_grid:disable_item_drag()
	self.super_parent:clear_disabled_backend_ids()
	self:setup_recipe_requirements()
	self.super_parent:disable_filter(true)
	self.super_parent:disable_search(true)
end

CraftPageCraftItemConsole.setup_recipe_requirements = function (self)
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

	self:reset_requirements(num)

	local _material_items = self._material_items

	table.clear(_material_items)

	local get_interface_2 = Managers.backend:get_interface("items")
	local get_filtered_items = get_interface_2:get_filtered_items("item_type == crafting_material")
	local flag_5 = true
	local num_2 = 1

	for i_2, v_2 in ipairs(ingredients) do
		if not v_2.catergory then
			local name_2 = v_2.name
			local amount = v_2.amount
			local num_3 = 0
			local var_2_17

			for i_3, v_3 in ipairs(get_filtered_items) do
				local backend_id = v_3.backend_id

				if v_3.data.key == name_2 then
					var_2_17 = backend_id
					num_3 = get_interface_2:get_item_amount(backend_id)

					break
				end
			end

			local flag_6 = amount <= num_3
			local var_2_20

			if num_3 < UISettings.max_craft_material_presentation_amount then
				var_2_20 = tostring(num_3)

				if not var_2_20 then
					-- Nothing
				end
			end

			var_2_20 = "*"

			::label_2_0::

			local str = var_2_20 .. "/" .. tostring(amount)

			self:_add_crafting_material_requirement(num_2, name_2, str, flag_6)

			num_2 = num_2 + 1

			if not flag_6 then
				_material_items[#_material_items + 1] = var_2_17
			else
				flag_5 = false
			end
		end
	end

	self._has_all_requirements = not flag_5 and flag_4

	self:_set_craft_button_disabled(not self._has_all_requirements)
end

CraftPageCraftItemConsole.reset_requirements = function (self, arg_3_1)
	-- function 3
	local _widgets_by_name = self._widgets_by_name
	local num = 60
	local num_2 = 10
	local num_3 = -((num + num_2) * (arg_3_1 - 1)) / 2
	local count = #UISettings.crafting_material_order

	for i = 1, count do
		local var_3_5 = _widgets_by_name["material_text_" .. i]
		local flag = i <= arg_3_1

		var_3_5.content.visible = flag

		if not flag then
			var_3_5.offset[1] = num_3
			num_3 = num_3 + num + num_2
		end
	end
end

CraftPageCraftItemConsole.create_ui_elements = function (self, arg_4_1)
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

CraftPageCraftItemConsole.on_exit = function (self, arg_5_1)
	-- function 5
	print("[HeroWindowCraft] Exit Substate CraftPageCraftItemConsole")

	self.ui_animator = nil

	if not self._craft_input_time then
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end

	self.super_parent:disable_filter(false)
	self.super_parent:disable_search(false)
end

CraftPageCraftItemConsole.update = function (self, arg_6_1, arg_6_2)
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

CraftPageCraftItemConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

CraftPageCraftItemConsole._update_animations = function (self, arg_8_1)
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

CraftPageCraftItemConsole._is_button_pressed = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

CraftPageCraftItemConsole._is_button_hovered = function (arg_10_0, arg_10_1)
	-- function 10
	if not arg_10_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageCraftItemConsole._is_button_held = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

CraftPageCraftItemConsole._handle_input = function (self, arg_12_1, arg_12_2)
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
	local flag_3 = not flag and not not is_device_active or window_input_service:get("skip")
	local flag_4 = false

	if not window_input_service:get("special_1") then
		self:reset()
	elseif _is_button_held == 0 or flag_2 or not flag_3 or not self._has_all_requirements then
		if not self._craft_input_time then
			self._craft_input_time = 0

			self:_play_sound("play_gui_craft_forge_button_begin")
		else
			self._craft_input_time = self._craft_input_time + arg_12_1
		end

		local crafting_progress_time = UISettings.crafting_progress_time
		local min = math.min(self._craft_input_time / crafting_progress_time, 1)

		flag_4 = self:_handle_craft_input_progress(min)

		WwiseWorld.set_global_parameter(self.wwise_world, "craft_forge_button_progress", min)
	elseif not self._craft_input_time then
		self._craft_input_time = nil

		self:_handle_craft_input_progress(0)
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if not flag_4 then
		local _craft_items = self._craft_items
		local _material_items = self._material_items
		local tbl = {}

		for i, v in ipairs(_craft_items) do
			tbl[#tbl + 1] = v
		end

		for i_2, v_2 in ipairs(_material_items) do
			tbl[#tbl + 1] = v_2
		end

		if not parent:craft(tbl) then
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

CraftPageCraftItemConsole._handle_craft_input_progress = function (self, arg_13_1)
	-- function 13
	return self.parent:_set_input_progress(arg_13_1)
end

CraftPageCraftItemConsole.craft_result = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not arg_14_2 then
		self._craft_result = arg_14_1
	end
end

CraftPageCraftItemConsole.reset = function (self)
	-- function 15
	for i = 1, num do
		local var_15_0 = self._craft_items[i]

		if not var_15_0 then
			self:_remove_craft_item(var_15_0)
		end
	end

	local _item_grid = self._item_grid

	_item_grid:clear_locked_items()
	_item_grid:update_items_status()
	self:setup_recipe_requirements()
end

CraftPageCraftItemConsole.present_results = function (self)
	-- function 16
	local _item_grid = self._item_grid

	_item_grid:clear_locked_items()
	_item_grid:update_items_status()
	self.super_parent:update_inventory_items()
	self:setup_recipe_requirements()
end

CraftPageCraftItemConsole.on_craft_completed = function (self)
	-- function 17
	local _craft_result = self._craft_result
	local _item_grid = self._item_grid
	local flag = true
	local var_17_3 = self._craft_items[1]

	if not var_17_3 then
		self:_add_craft_item(var_17_3, nil, flag)
	end

	local get_interface = Managers.backend:get_interface("items")
	local parent = self.parent
	local _craft_result_2 = self._craft_result
	local flag_2 = true

	for k, v in pairs(_craft_result_2) do
		local var_17_8 = v[1]
		local var_17_9 = v[3]
		local flag_3 = not var_17_8 and get_interface:get_item_from_id(var_17_8)

		parent:set_reward_tooltip_item(flag_3)
	end

	self._craft_result = nil

	self:setup_recipe_requirements()
end

CraftPageCraftItemConsole._update_craft_items = function (self)
	-- function 18
	local super_parent = self.super_parent
	local _item_grid = self._item_grid

	if not _item_grid:is_dragging_item() then
		local flag

		flag = _item_grid:is_item_dragged() ~= nil
	end

	local get_pressed_item_backend_id, var_18_4 = super_parent:get_pressed_item_backend_id()

	if not get_pressed_item_backend_id then
		if not self:_has_added_item_by_id(get_pressed_item_backend_id) then
			self:_remove_craft_item(get_pressed_item_backend_id)
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

CraftPageCraftItemConsole._remove_craft_item = function (self, arg_19_1, arg_19_2)
	-- function 19
	local _craft_items = self._craft_items

	if not arg_19_2 then
		if not _craft_items[arg_19_2] then
			arg_19_1 = _craft_items[arg_19_2]
		end
	else
		for k, v in pairs(_craft_items) do
			if v == arg_19_1 then
				arg_19_2 = k

				break
			end
		end
	end

	if not arg_19_1 and not arg_19_2 then
		self.super_parent:set_disabled_backend_id(arg_19_1, false)
		self._item_grid:add_item_to_slot_index(arg_19_2, nil)

		_craft_items[arg_19_2] = nil

		local max = math.max
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = max(_num_craft_items - 1, 0)

		self:_play_sound("play_gui_craft_item_drag")
		self:setup_recipe_requirements()

		self._widgets_by_name.item_grid_random_icon.content.visible = true
	end
end

CraftPageCraftItemConsole._add_craft_item = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	self:_clear_item_grid()

	local _craft_items = self._craft_items

	if not arg_20_2 then
		for i = 1, num do
			if not _craft_items[i] then
				arg_20_2 = i

				break
			end
		end
	end

	if not arg_20_2 then
		_craft_items[arg_20_2] = arg_20_1

		local get_interface = Managers.backend:get_interface("items")
		local flag = not arg_20_1 and get_interface:get_item_from_id(arg_20_1)

		self._item_grid:add_item_to_slot_index(arg_20_2, flag)
		self.super_parent:set_disabled_backend_id(arg_20_1, true)

		local min = math.min
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = min(_num_craft_items + 1, num)

		if not (not arg_20_1 and arg_20_3) then
			self:_play_sound("play_gui_craft_item_drop")
		end

		self._widgets_by_name.item_grid_random_icon.content.visible = false
	end

	self:setup_recipe_requirements()
end

CraftPageCraftItemConsole._clear_item_grid = function (self)
	-- function 21
	local _craft_items = self._craft_items
	local super_parent = self.super_parent

	for i = 1, num do
		if not _craft_items[i] then
			super_parent:set_disabled_backend_id(_craft_items[i], false)
		end
	end

	self._item_grid:clear_item_grid()
	table.clear(_craft_items)
end

CraftPageCraftItemConsole._has_added_item_by_id = function (self, arg_22_1)
	-- function 22
	local _craft_items = self._craft_items

	for i = 1, num do
		if _craft_items[i] == arg_22_1 then
			return true
		end
	end

	return false
end

CraftPageCraftItemConsole._set_craft_button_disabled = function (self, arg_23_1)
	-- function 23
	self._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_23_1

	local parent = self.parent
	local var_23_1 = parent
	local set_input_description = parent.set_input_description
	local name

	if not arg_23_1 then
		name = self.settings.name

		if not name then
			-- Nothing
		end
	end

	name = "disabled"

	::label_23_0::

	set_input_description(var_23_1, name)
end

CraftPageCraftItemConsole._exit = function (self, arg_24_1)
	-- function 24
	self.exit = true
	self.exit_level_id = arg_24_1
end

CraftPageCraftItemConsole.draw = function (self, arg_25_1)
	-- function 25
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.super_parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_25_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

CraftPageCraftItemConsole._play_sound = function (self, arg_26_1)
	-- function 26
	self.super_parent:play_sound(arg_26_1)
end

CraftPageCraftItemConsole._set_craft_button_text = function (self, arg_27_1, arg_27_2)
	-- function 27
	local content = self._widgets_by_name.craft_button.content
	local var_27_1

	if not arg_27_2 then
		var_27_1 = Localize(arg_27_1)

		if not var_27_1 then
			-- Nothing
		end
	end

	var_27_1 = arg_27_1

	::label_27_0::

	content.button_text = var_27_1
end

CraftPageCraftItemConsole._add_crafting_material_requirement = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local crafting_material_icons_small = UISettings.crafting_material_icons_small
	local content = self._widgets_by_name["material_text_" .. arg_28_1].content

	content.icon, content.text = crafting_material_icons_small[arg_28_2], arg_28_3
	content.warning = not arg_28_4
	content.item = {
		data = table.clone(ItemMasterList[arg_28_2])
	}
end
