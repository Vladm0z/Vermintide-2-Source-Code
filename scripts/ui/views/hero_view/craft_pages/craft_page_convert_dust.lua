-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_convert_dust.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_convert_dust_definitions")
local widgets = var_0_3.widgets
local category_settings = var_0_3.category_settings
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local flag = false
local num = 1

CraftPageConvertDust = class(CraftPageConvertDust)
CraftPageConvertDust.NAME = "CraftPageConvertDust"

CraftPageConvertDust.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroWindowCraft] Enter Substate CraftPageConvertDust")

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
	self._item_grid = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index)

	self._item_grid:disable_locked_items(true)
	self._item_grid:mark_locked_items(true)
	self._item_grid:hide_slots(true)
	self._item_grid:disable_item_drag()
	self.super_parent:clear_disabled_backend_ids()
	self:setup_recipe_requirements()
end

CraftPageConvertDust._has_required_item_amount = function (self, arg_2_1)
	-- function 2
	local _get_recipe_by_backend_id = self:_get_recipe_by_backend_id(arg_2_1)
	local var_2_1 = var_0_1[_get_recipe_by_backend_id]
	local item_filter = var_2_1.item_filter
	local ingredients = var_2_1.ingredients
	local get_interface = Managers.backend:get_interface("items")
	local get_filtered_items = get_interface:get_filtered_items(item_filter)
	local get_item_amount = get_interface:get_item_amount(arg_2_1)
	local get_item_from_id = get_interface:get_item_from_id(arg_2_1)

	for i, v in ipairs(ingredients) do
		if not v.catergory then
			local name = v.name
			local amount = v.amount

			if get_item_from_id.key == name then
				return amount <= get_item_amount
			end
		end
	end

	return false
end

CraftPageConvertDust._get_recipe_by_backend_id = function (arg_3_0, arg_3_1)
	-- function 3
	local get_key = Managers.backend:get_interface("items"):get_key(arg_3_1)
	local var_3_1

	if get_key == "crafting_material_dust_2" then
		var_3_1 = "convert_blue_dust"
	elseif get_key == "crafting_material_dust_3" then
		var_3_1 = "convert_orange_dust"
	end

	return var_3_1
end

CraftPageConvertDust.setup_recipe_requirements = function (self)
	-- function 4
	local settings = self.settings
	local var_4_1
	local item_filter = settings.item_filter
	local var_4_3 = self._craft_items[1]

	if not var_4_3 then
		var_4_1 = self:_get_recipe_by_backend_id(var_4_3)
	end

	self._recipe_name = var_4_1 or settings.name

	local flag = true

	if not var_4_1 then
		flag = false

		self:reset_requirements(0)
	else
		local var_4_5 = var_0_1[var_4_1]
		local item_filter_2 = var_4_5.item_filter
		local ingredients = var_4_5.ingredients
		local presentation_ingredients = var_4_5.presentation_ingredients
		local num = 0

		for i, v in ipairs(presentation_ingredients) do
			if not v.catergory then
				num = num + 1
			end
		end

		self:reset_requirements(num)

		for i_2, v_2 in ipairs(presentation_ingredients) do
			local name = v_2.name
			local amount = v_2.amount
			local var_4_12 = tostring(amount)

			self:_add_crafting_material_requirement(i_2, name, var_4_12, true)
		end

		local get_interface = Managers.backend:get_interface("items")
		local get_filtered_items = get_interface:get_filtered_items(item_filter_2)

		for i_3, v_3 in ipairs(ingredients) do
			if not v_3.catergory then
				local name_2 = v_3.name
				local amount_2 = v_3.amount
				local num_2 = 0
				local var_4_18

				for i_4, v_4 in ipairs(get_filtered_items) do
					local backend_id = v_4.backend_id

					if v_4.data.key == name_2 then
						local var_4_20 = backend_id

						num_2 = get_interface:get_item_amount(backend_id)

						break
					end
				end

				if not (amount_2 <= num_2) then
					flag = false
				end
			end
		end
	end

	self._has_all_requirements = not var_4_3 and flag

	if not self._has_all_requirements then
		self:_set_craft_button_disabled(false)
	else
		self:_set_craft_button_disabled(true)
	end
end

CraftPageConvertDust.reset_requirements = function (self, arg_5_1)
	-- function 5
	local _widgets_by_name = self._widgets_by_name
	local num = 60
	local num_2 = 94
	local num_3 = -((num + num_2) * (arg_5_1 - 1)) / 2

	for i = 1, 2 do
		local var_5_4 = _widgets_by_name["material_text_" .. i]
		local flag = i <= arg_5_1

		var_5_4.content.visible = flag
		var_5_4.content.draw_background = false

		if not flag then
			var_5_4.offset[1] = num_3
			num_3 = num_3 + num + num_2
		end
	end
end

CraftPageConvertDust._add_crafting_material_requirement = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local crafting_material_icons_small = UISettings.crafting_material_icons_small
	local content = self._widgets_by_name["material_text_" .. arg_6_1].content

	content.icon, content.text = crafting_material_icons_small[arg_6_2], arg_6_3
	content.warning = not arg_6_4
	content.item = {
		data = table.clone(ItemMasterList[arg_6_2])
	}
end

CraftPageConvertDust.create_ui_elements = function (self, arg_7_1)
	-- function 7
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_7_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_7_2
		tbl_2[k] = var_7_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	self:_set_craft_button_disabled(true)
	self:_handle_craft_input_progress(0)
end

CraftPageConvertDust.on_exit = function (self, arg_8_1)
	-- function 8
	print("[HeroWindowCraft] Exit Substate CraftPageConvertDust")

	self.ui_animator = nil

	if not self._craft_input_time then
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageConvertDust.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_handle_input(arg_9_1, arg_9_2)
	self:_update_animations(arg_9_1)
	self:_update_craft_items()
	self:draw(arg_9_1)
end

CraftPageConvertDust.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

CraftPageConvertDust._update_animations = function (self, arg_11_1)
	-- function 11
	self.ui_animator:update(arg_11_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.craft_button, arg_11_1)
end

CraftPageConvertDust._is_button_pressed = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

CraftPageConvertDust._is_button_hovered = function (arg_13_0, arg_13_1)
	-- function 13
	if not arg_13_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageConvertDust._is_button_held = function (arg_14_0, arg_14_1)
	-- function 14
	local button_hotspot = arg_14_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

CraftPageConvertDust._handle_input = function (self, arg_15_1, arg_15_2)
	-- function 15
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
			self._craft_input_time = self._craft_input_time + arg_15_1
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
		local tbl = {}

		for i, v in ipairs(_craft_items) do
			tbl[#tbl + 1] = v
		end

		if not parent:craft(tbl, self._recipe_name) then
			self:_set_craft_button_disabled(true)

			local _item_grid = self._item_grid

			for k, v_2 in pairs(tbl) do
				_item_grid:lock_item_by_id(v_2, true)
			end

			_item_grid:update_items_status()
			self:_play_sound("play_gui_craft_forge_button_completed")
			self:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageConvertDust._handle_craft_input_progress = function (arg_16_0, arg_16_1)
	-- function 16
	local flag

	flag = arg_16_1 ~= 0

	local var_16_1 = scenegraph_definition.craft_bar.size[1]

	arg_16_0.ui_scenegraph.craft_bar.size[1] = var_16_1 * arg_16_1

	if arg_16_1 == 1 then
		return true
	end
end

CraftPageConvertDust.craft_result = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if not arg_17_2 then
		self._craft_result = arg_17_1
	end
end

CraftPageConvertDust.reset = function (self)
	-- function 18
	local _item_grid = self._item_grid

	_item_grid:clear_locked_items()
	_item_grid:update_items_status()
end

CraftPageConvertDust.on_craft_completed = function (self)
	-- function 19
	local _craft_result = self._craft_result
	local _item_grid = self._item_grid

	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()

	local flag = false

	self._num_craft_items = 0

	local var_19_3 = self._craft_items[1]

	if not Managers.backend:get_interface("items"):get_item_from_id(var_19_3) then
		flag = true
	end

	if not flag then
		local flag_2 = true

		self:_add_craft_item(var_19_3, 1, flag_2)
	else
		_item_grid:clear_item_grid()
		table.clear(self._craft_items)
	end

	_item_grid:clear_locked_items()

	for k, v in pairs(self._craft_items) do
		_item_grid:lock_item_by_id(v, true)
	end

	_item_grid:update_items_status()
	self:_set_craft_button_disabled(true)

	self._craft_result = nil

	self:setup_recipe_requirements()
end

CraftPageConvertDust._update_craft_items = function (self)
	-- function 20
	local super_parent = self.super_parent
	local _item_grid = self._item_grid
	local is_dragging_item = _item_grid:is_dragging_item()

	is_dragging_item = is_dragging_item or _item_grid:is_item_dragged() ~= nil

	local get_pressed_item_backend_id, var_20_4 = super_parent:get_pressed_item_backend_id()

	if not get_pressed_item_backend_id then
		if not var_20_4 then
			if not is_dragging_item then
				local is_slot_hovered = _item_grid:is_slot_hovered()

				if not is_slot_hovered then
					self:_add_craft_item(get_pressed_item_backend_id, is_slot_hovered)
					self:setup_recipe_requirements()
				end
			end
		else
			self:_add_craft_item(get_pressed_item_backend_id)
			self:setup_recipe_requirements()
		end
	end

	local is_item_pressed = _item_grid:is_item_pressed()

	if not is_item_pressed then
		local backend_id = is_item_pressed.backend_id

		self:_remove_craft_item(backend_id)
	end
end

CraftPageConvertDust._remove_craft_item = function (self, arg_21_1, arg_21_2)
	-- function 21
	local _craft_items = self._craft_items

	if not arg_21_2 then
		if not _craft_items[arg_21_2] then
			arg_21_1 = _craft_items[arg_21_2]
		end
	else
		for k, v in pairs(_craft_items) do
			if v == arg_21_1 then
				arg_21_2 = k

				break
			end
		end
	end

	if not arg_21_1 and not arg_21_2 then
		self.super_parent:set_disabled_backend_id(arg_21_1, false)
		self._item_grid:add_item_to_slot_index(arg_21_2, nil)

		_craft_items[arg_21_2] = nil

		local max = math.max
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = max(_num_craft_items - 1, 0)

		if self._num_craft_items == 0 then
			self:_set_craft_button_disabled(true)
		end

		self:_play_sound("play_gui_craft_item_drag")
		self:setup_recipe_requirements()
	end
end

CraftPageConvertDust._add_craft_item = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	if self._num_craft_items == 0 then
		self._item_grid:clear_item_grid()
		table.clear(self._craft_items)
	end

	local _craft_items = self._craft_items

	if not arg_22_2 then
		for i = 1, 1 do
			if not _craft_items[i] then
				arg_22_2 = i

				break
			end
		end
	end

	if not arg_22_2 then
		_craft_items[arg_22_2] = arg_22_1

		local get_interface = Managers.backend:get_interface("items")
		local flag = not arg_22_1 and get_interface:get_item_from_id(arg_22_1)

		if not flag then
			flag = table.clone(flag)
			flag.insufficient_amount = not self:_has_required_item_amount(arg_22_1)
		end

		self._item_grid:add_item_to_slot_index(arg_22_2, flag)
		self.super_parent:set_disabled_backend_id(arg_22_1, true)

		local min = math.min
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = min(_num_craft_items + 1, num)

		if not (not arg_22_1 and arg_22_3) then
			self:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageConvertDust._set_craft_button_disabled = function (arg_23_0, arg_23_1)
	-- function 23
	arg_23_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_23_1
end

CraftPageConvertDust._exit = function (self, arg_24_1)
	-- function 24
	self.exit = true
	self.exit_level_id = arg_24_1
end

CraftPageConvertDust.draw = function (self, arg_25_1)
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

CraftPageConvertDust._play_sound = function (self, arg_26_1)
	-- function 26
	self.super_parent:play_sound(arg_26_1)
end

CraftPageConvertDust._set_craft_button_text = function (self, arg_27_1, arg_27_2)
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
