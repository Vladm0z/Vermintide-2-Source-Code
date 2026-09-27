-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_apply_skin.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_apply_skin_definitions")
local widgets = var_0_3.widgets
local category_settings = var_0_3.category_settings
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local flag = false
local num = 1

CraftPageApplySkin = class(CraftPageApplySkin)
CraftPageApplySkin.NAME = "CraftPageApplySkin"

CraftPageApplySkin.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroWindowCraft] Enter Substate CraftPageApplySkin")

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
	self.career_name = SPProfiles[self.profile_index].careers[self.career_index].name
	self.wwise_world = arg_1_1.wwise_world
	self.settings = arg_1_2
	self._recipe_name = arg_1_2.name
	self._animations = {}

	self:create_ui_elements(arg_1_1)

	self._material_items = {}
	self._item_grid = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self.hero_name, self.career_index)

	self._item_grid:disable_locked_items(true)
	self._item_grid:mark_locked_items(true)
	self._item_grid:hide_slots(true)
	self._item_grid:disable_item_drag()

	self._item_grid_2 = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid_2, self.hero_name, self.career_index)

	self._item_grid_2:disable_item_drag()
	self._item_grid_2:mark_locked_items(true)
	self._item_grid_2:hide_slots(true)
	self._item_grid_2:disable_item_drag()

	self._recipe_grid = ItemGridUI:new(category_settings, self._widgets_by_name.recipe_grid, self.hero_name, self.career_index)

	self._recipe_grid:disable_item_drag()
	self._recipe_grid:hide_slots(true)
	self.super_parent:clear_disabled_backend_ids()
	self:_weapon_slot_updated()
	self:setup_recipe_requirements()
end

CraftPageApplySkin.setup_recipe_requirements = function (self)
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

CraftPageApplySkin.create_ui_elements = function (self, arg_3_1)
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

CraftPageApplySkin._weapon_slot_updated = function (self)
	-- function 4
	local get_interface = Managers.backend:get_interface("items")
	local _craft_item = self._craft_item
	local flag = not _craft_item and get_interface:get_item_masterlist_data(_craft_item)
	local flag_2

	flag_2 = not flag and flag.slot_type

	if not flag then
		local str = flag.key .. "_skin"
		local str_2 = "is_fake_item and item_key == " .. str

		self.parent.parent:set_craft_optional_item_filter(str_2)
	else
		self.parent.parent:set_craft_optional_item_filter(nil)
	end
end

CraftPageApplySkin.on_exit = function (self, arg_5_1)
	-- function 5
	self.parent.parent:set_craft_optional_item_filter(nil)
	print("[HeroWindowCraft] Exit Substate CraftPageApplySkin")

	self.ui_animator = nil

	if not self._craft_input_time then
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageApplySkin.update = function (self, arg_6_1, arg_6_2)
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

CraftPageApplySkin.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

CraftPageApplySkin._update_animations = function (self, arg_8_1)
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

CraftPageApplySkin._is_button_pressed = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

CraftPageApplySkin._is_button_hovered = function (arg_10_0, arg_10_1)
	-- function 10
	if not arg_10_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageApplySkin._is_button_held = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

CraftPageApplySkin._handle_input = function (self, arg_12_1, arg_12_2)
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

	if (_is_button_held == 0 or not flag_2 or not self._craft_item) and (not self._skin_item or not self._has_all_requirements) then
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
		local _craft_item = self._craft_item
		local _skin_item = self._skin_item
		local tbl = {
			_craft_item,
			_skin_item
		}
		local _material_items = self._material_items

		for i, v in ipairs(_material_items) do
			tbl[#tbl + 1] = v
		end

		if not parent:craft(tbl, self._recipe_name) then
			self:_set_craft_button_disabled(true)
			self._item_grid:lock_item_by_id(_craft_item, true)
			self._item_grid:update_items_status()
			self._item_grid_2:lock_item_by_id(_skin_item, true)
			self._item_grid_2:update_items_status()
			self:_play_sound("play_gui_craft_forge_button_completed")
			self:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageApplySkin._handle_craft_input_progress = function (arg_13_0, arg_13_1)
	-- function 13
	local flag

	flag = arg_13_1 ~= 0

	local var_13_1 = scenegraph_definition.craft_bar.size[1]

	arg_13_0.ui_scenegraph.craft_bar.size[1] = var_13_1 * arg_13_1

	if arg_13_1 == 1 then
		return true
	end
end

CraftPageApplySkin.craft_result = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not arg_14_2 then
		self._craft_result = arg_14_1
	end
end

CraftPageApplySkin.reset = function (self)
	-- function 15
	local _item_grid = self._item_grid
	local _item_grid_2 = self._item_grid_2

	_item_grid:clear_locked_items()
	_item_grid:update_items_status()
	_item_grid_2:clear_locked_items()
	_item_grid_2:update_items_status()
end

CraftPageApplySkin.on_craft_completed = function (self)
	-- function 16
	local _craft_result = self._craft_result
	local _item_grid = self._item_grid
	local _item_grid_2 = self._item_grid_2
	local flag = true
	local _craft_item = self._craft_item
	local _skin_item = self._skin_item

	self:_remove_item(_item_grid_2, _skin_item, flag)
	self:_remove_item(_item_grid, _craft_item, flag)
	_item_grid:clear_item_grid()
	_item_grid_2:clear_item_grid()
	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()
	self:_set_craft_button_disabled(true)

	self._craft_result = nil
	self._craft_item = nil
	self._skin_item = nil
	self._presenting_reward = true

	self:_weapon_slot_updated()
	self:setup_recipe_requirements()

	if not _craft_item and not ItemHelper.is_equiped_backend_id(_craft_item, self.career_name) then
		local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(_craft_item)
		local get_equipped_slots, var_16_8 = ItemHelper.get_equipped_slots(_craft_item, self.career_name)

		for i = 1, var_16_8 do
			self.super_parent:_set_loadout_item(get_item_from_id, get_equipped_slots[i])
		end

		if get_item_from_id.data.slot_type == "skin" then
			self.super_parent:update_skin_sync()
		end
	end
end

CraftPageApplySkin._update_craft_items = function (self)
	-- function 17
	local super_parent = self.super_parent
	local _item_grid = self._item_grid
	local _item_grid_2 = self._item_grid_2
	local get_pressed_item_backend_id, var_17_4 = super_parent:get_pressed_item_backend_id()

	if not get_pressed_item_backend_id then
		if not self._craft_item then
			self:_add_item(_item_grid, get_pressed_item_backend_id)

			self._craft_item = get_pressed_item_backend_id

			self:_weapon_slot_updated()
		else
			if not self._skin_item then
				self.super_parent:set_disabled_backend_id(self._skin_item, false)
			end

			local flag = true

			if self._skin_item == get_pressed_item_backend_id then
				self:_remove_item(_item_grid_2, get_pressed_item_backend_id)

				self._skin_item = nil
				flag = false
			end

			if not flag then
				self:_add_item(_item_grid_2, get_pressed_item_backend_id)

				self._skin_item = get_pressed_item_backend_id
			end

			self:_weapon_slot_updated()

			if not self._has_all_requirements then
				self:_set_craft_button_disabled(false)
			end
		end
	end

	local is_item_pressed = _item_grid:is_item_pressed()

	if not is_item_pressed then
		local backend_id = is_item_pressed.backend_id

		self:_remove_item(_item_grid, backend_id)

		self._craft_item = nil

		if not self._presenting_reward then
			self._presenting_reward = nil
		end

		if not self._skin_item then
			self:_remove_item(_item_grid_2, self._skin_item)

			self._skin_item = nil
		end

		self:_weapon_slot_updated()
		self:_set_craft_button_disabled(true)
	end

	local is_item_pressed_2 = _item_grid_2:is_item_pressed()

	if not is_item_pressed_2 then
		local backend_id_2 = is_item_pressed_2.backend_id

		self:_remove_item(_item_grid_2, backend_id_2)

		self._skin_item = nil

		self:_weapon_slot_updated()
		self:_set_craft_button_disabled(true)
	end
end

CraftPageApplySkin._remove_item = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	self.super_parent:set_disabled_backend_id(arg_18_2, false)
	arg_18_1:add_item_to_slot_index(1, nil)
	self:_set_craft_button_disabled(true)

	if not arg_18_3 then
		self:_play_sound("play_gui_craft_item_drag")
	end
end

CraftPageApplySkin._add_item = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	arg_19_1:clear_item_grid()

	local num = 1

	if not num then
		local get_interface = Managers.backend:get_interface("items")
		local flag = not arg_19_2 and get_interface:get_item_from_id(arg_19_2)

		arg_19_1:add_item_to_slot_index(num, flag)
		self.super_parent:set_disabled_backend_id(arg_19_2, true)

		if not (not arg_19_2 and arg_19_3) then
			self:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageApplySkin._set_craft_button_disabled = function (arg_20_0, arg_20_1)
	-- function 20
	arg_20_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_20_1
end

CraftPageApplySkin._exit = function (self, arg_21_1)
	-- function 21
	self.exit = true
	self.exit_level_id = arg_21_1
end

CraftPageApplySkin.draw = function (self, arg_22_1)
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

CraftPageApplySkin._play_sound = function (self, arg_23_1)
	-- function 23
	self.super_parent:play_sound(arg_23_1)
end

CraftPageApplySkin._set_craft_button_text = function (self, arg_24_1, arg_24_2)
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
