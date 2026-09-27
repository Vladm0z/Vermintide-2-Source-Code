-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_apply_skin_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_apply_skin_console_definitions")
local widgets = var_0_3.widgets
local category_settings = var_0_3.category_settings
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local flag = false
local num = 1

CraftPageApplySkinConsole = class(CraftPageApplySkinConsole)
CraftPageApplySkinConsole.NAME = "CraftPageApplySkinConsole"

CraftPageApplySkinConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroWindowCraft] Enter Substate CraftPageApplySkinConsole")

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
	self.career_name = SPProfiles[self.profile_index].careers[self.career_index].name
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
	self.super_parent:clear_disabled_backend_ids()
	self:_weapon_slot_updated()
	self:setup_recipe_requirements()
end

CraftPageApplySkinConsole.setup_recipe_requirements = function (self)
	-- function 2
	local name = self.settings.name
	local var_2_1 = var_0_1[name]
	local ingredients = var_2_1.ingredients
	local ingredients_2 = var_2_1.ingredients
	local num = 0

	for i, v in ipairs(ingredients_2) do
		if not v.catergory then
			num = num + 1
		end
	end

	self:reset_requirements(num)

	local _material_items = self._material_items

	table.clear(_material_items)

	local get_interface = Managers.backend:get_interface("items")
	local get_filtered_items = get_interface:get_filtered_items("item_type == crafting_material")
	local flag = true
	local num_2 = 1

	for i_2, v_2 in ipairs(ingredients_2) do
		if not v_2.catergory then
			local name_2 = v_2.name
			local amount = v_2.amount
			local num_3 = 0
			local var_2_13

			for i_3, v_3 in ipairs(get_filtered_items) do
				local backend_id = v_3.backend_id

				if v_3.data.key == name_2 then
					var_2_13 = backend_id
					num_3 = get_interface:get_item_amount(backend_id)

					break
				end
			end

			local flag_2 = amount <= num_3
			local var_2_16

			if num_3 < UISettings.max_craft_material_presentation_amount then
				var_2_16 = tostring(num_3)

				if not var_2_16 then
					-- Nothing
				end
			end

			var_2_16 = "*"

			::label_2_0::

			local str = var_2_16 .. "/" .. tostring(amount)

			self:_add_crafting_material_requirement(num_2, name_2, str, flag_2)

			num_2 = num_2 + 1

			if not flag_2 then
				_material_items[#_material_items + 1] = var_2_13
			else
				flag = false
			end
		end
	end

	self._has_all_requirements = flag
end

CraftPageApplySkinConsole.reset_requirements = function (self, arg_3_1)
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

CraftPageApplySkinConsole.create_ui_elements = function (self, arg_4_1)
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

	self:_set_craft_button_disabled(true)
	self:_handle_craft_input_progress(0)
end

CraftPageApplySkinConsole._weapon_slot_updated = function (self)
	-- function 5
	local get_interface = Managers.backend:get_interface("items")
	local _craft_item = self._craft_item
	local flag = not _craft_item and get_interface:get_item_masterlist_data(_craft_item)
	local flag_2

	flag_2 = not flag and flag.slot_type

	if not flag then
		local str = flag.key .. "_skin"
		local str_2 = "item_key == " .. str

		self.parent.parent:set_craft_optional_item_filter(str_2)
		self.parent.parent:disable_filter(true)
		self.parent.parent:disable_search(true)
	else
		self.parent.parent:set_craft_optional_item_filter(nil)
		self.parent.parent:disable_filter(false)
		self.parent.parent:disable_search(false)
	end
end

CraftPageApplySkinConsole.on_exit = function (self, arg_6_1)
	-- function 6
	self.parent.parent:set_craft_optional_item_filter(nil)
	self.parent.parent:disable_filter(false)
	self.parent.parent:disable_search(false)
	print("[HeroWindowCraft] Exit Substate CraftPageApplySkinConsole")

	self.ui_animator = nil

	if not self._craft_input_time then
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageApplySkinConsole.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_handle_input(arg_7_1, arg_7_2)
	self:_update_animations(arg_7_1)
	self:_update_craft_items()
	self:draw(arg_7_1)
end

CraftPageApplySkinConsole.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return
end

CraftPageApplySkinConsole._update_animations = function (self, arg_9_1)
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

CraftPageApplySkinConsole._is_button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

CraftPageApplySkinConsole._is_button_hovered = function (arg_11_0, arg_11_1)
	-- function 11
	if not arg_11_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageApplySkinConsole._is_button_held = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

CraftPageApplySkinConsole._handle_input = function (self, arg_13_1, arg_13_2)
	-- function 13
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

	if window_input_service:get("special_1") or not self._craft_item or not window_input_service:get("toggle_menu", true) then
		self:reset()
	elseif (_is_button_held == 0 or flag_2 or not flag_3 or not self._craft_item) and (not self._skin_item or not self._has_all_requirements) then
		if not self._craft_input_time then
			self._craft_input_time = 0

			self:_play_sound("play_gui_craft_forge_button_begin")
		else
			self._craft_input_time = self._craft_input_time + arg_13_1
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

CraftPageApplySkinConsole._handle_craft_input_progress = function (self, arg_14_1)
	-- function 14
	return self.parent:_set_input_progress(arg_14_1)
end

CraftPageApplySkinConsole.craft_result = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	if not arg_15_2 then
		self._craft_result = arg_15_1
	end
end

CraftPageApplySkinConsole.reset = function (self)
	-- function 16
	local _item_grid = self._item_grid
	local _item_grid_2 = self._item_grid_2

	if not self._craft_item then
		self:_remove_item(_item_grid, self._craft_item)

		self._craft_item = nil
	end

	if not self._skin_item then
		self:_remove_item(_item_grid_2, self._skin_item)

		self._skin_item = nil
	end

	_item_grid:clear_locked_items()
	_item_grid:update_items_status()
	_item_grid_2:clear_locked_items()
	_item_grid_2:update_items_status()
	self:_weapon_slot_updated()
end

CraftPageApplySkinConsole.present_results = function (self)
	-- function 17
	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()
	self:_weapon_slot_updated()
	self:setup_recipe_requirements()
end

CraftPageApplySkinConsole.on_craft_completed = function (self)
	-- function 18
	local _item_grid = self._item_grid
	local _item_grid_2 = self._item_grid_2
	local _craft_item = self._craft_item
	local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(_craft_item)

	self.parent:set_reward_tooltip_item(get_item_from_id)

	if not self._craft_item then
		self:_remove_item(_item_grid, self._craft_item)

		self._craft_item = nil
	end

	if not self._skin_item then
		self:_remove_item(_item_grid_2, self._skin_item)

		self._skin_item = nil
	end

	self._craft_result = nil

	if not _craft_item and not ItemHelper.is_equiped_backend_id(_craft_item, self.career_name) then
		local get_item_from_id_2 = Managers.backend:get_interface("items"):get_item_from_id(_craft_item)
		local get_equipped_slots, var_18_6 = ItemHelper.get_equipped_slots(_craft_item, self.career_name)

		for i = 1, var_18_6 do
			self.super_parent:_set_loadout_item(get_item_from_id_2, get_equipped_slots[i])
		end

		if get_item_from_id_2.data.slot_type == "skin" then
			self.super_parent:update_skin_sync()
		end
	end
end

CraftPageApplySkinConsole._update_craft_items = function (self)
	-- function 19
	local super_parent = self.super_parent
	local _item_grid = self._item_grid
	local _item_grid_2 = self._item_grid_2
	local get_pressed_item_backend_id, var_19_4 = super_parent:get_pressed_item_backend_id()

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

CraftPageApplySkinConsole._remove_item = function (self, arg_20_1, arg_20_2)
	-- function 20
	self.super_parent:set_disabled_backend_id(arg_20_2, false)
	arg_20_1:add_item_to_slot_index(1, nil)
	self:_set_craft_button_disabled(true)
	self:_play_sound("play_gui_craft_item_drag")
end

CraftPageApplySkinConsole._add_item = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	arg_21_1:clear_item_grid()

	local num = 1

	if not num then
		local get_interface = Managers.backend:get_interface("items")
		local flag = not arg_21_2 and get_interface:get_item_from_id(arg_21_2)

		arg_21_1:add_item_to_slot_index(num, flag)
		self.super_parent:set_disabled_backend_id(arg_21_2, true)

		if not (not arg_21_2 and arg_21_3) then
			self:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageApplySkinConsole._set_craft_button_disabled = function (self, arg_22_1)
	-- function 22
	self._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_22_1

	local parent = self.parent
	local var_22_1 = parent
	local set_input_description = parent.set_input_description
	local name

	if not arg_22_1 then
		name = self.settings.name

		if not name then
			-- Nothing
		end
	end

	name = "disabled"

	::label_22_0::

	set_input_description(var_22_1, name)
end

CraftPageApplySkinConsole._exit = function (self, arg_23_1)
	-- function 23
	self.exit = true
	self.exit_level_id = arg_23_1
end

CraftPageApplySkinConsole.draw = function (self, arg_24_1)
	-- function 24
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.super_parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_24_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

CraftPageApplySkinConsole._play_sound = function (self, arg_25_1)
	-- function 25
	self.super_parent:play_sound(arg_25_1)
end

CraftPageApplySkinConsole._set_craft_button_text = function (self, arg_26_1, arg_26_2)
	-- function 26
	local content = self._widgets_by_name.craft_button.content
	local var_26_1

	if not arg_26_2 then
		var_26_1 = Localize(arg_26_1)

		if not var_26_1 then
			-- Nothing
		end
	end

	var_26_1 = arg_26_1

	::label_26_0::

	content.button_text = var_26_1
end

CraftPageApplySkinConsole._add_crafting_material_requirement = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local crafting_material_icons_small = UISettings.crafting_material_icons_small
	local content = self._widgets_by_name["material_text_" .. arg_27_1].content

	content.icon, content.text = crafting_material_icons_small[arg_27_2], arg_27_3
	content.warning = not arg_27_4
	content.item = {
		data = table.clone(ItemMasterList[arg_27_2])
	}
end
