-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_salvage_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_salvage_console_definitions")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local NUM_CRAFT_SLOTS = var_0_0.NUM_CRAFT_SLOTS
local flag = false

CraftPageSalvageConsole = class(CraftPageSalvageConsole)
CraftPageSalvageConsole.NAME = "CraftPageSalvageConsole"

CraftPageSalvageConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroWindowCraft] Enter Substate CraftPageSalvageConsole")

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

	self:_reset_reward_materials(false)
	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:set_disabled_item_icon("salvage_item_icon")

	local tostring = tostring
	local _num_craft_items = self._num_craft_items

	_num_craft_items = _num_craft_items or 0

	local var_1_4 = tostring(_num_craft_items)

	self:_set_craft_counter_text(var_1_4, true)
	self:_start_transition_animation("on_enter")
end

CraftPageSalvageConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

CraftPageSalvageConsole.create_ui_elements = function (self, arg_3_1)
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

	tbl_2.max_counter_text.content.text = "/" .. tostring(CraftingSettings.NUM_SALVAGE_SLOTS)
end

CraftPageSalvageConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroWindowCraft] Exit Substate CraftPageSalvageConsole")

	self.ui_animator = nil

	if not self._craft_input_time then
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end

	self.super_parent:set_disabled_item_icon(nil)
end

CraftPageSalvageConsole.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_handle_input(arg_5_1, arg_5_2)
	self:_update_animations(arg_5_1)
	self:_update_craft_items()
	self:_update_reward_material_fade_out(arg_5_1)
	self:draw(arg_5_1)
end

CraftPageSalvageConsole.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

CraftPageSalvageConsole._update_animations = function (self, arg_7_1)
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

	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_plentiful, arg_7_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_common, arg_7_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_rare, arg_7_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_exotic, arg_7_1)
	UIWidgetUtils.animate_icon_button(_widgets_by_name.auto_fill_clear, arg_7_1)
end

CraftPageSalvageConsole._handle_input = function (self, arg_8_1, arg_8_2)
	-- function 8
	local parent = self.parent

	if parent:waiting_for_craft() or not self._craft_result then
		return
	end

	local _widgets_by_name = self._widgets_by_name
	local super_parent = self.super_parent
	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag = true
	local filter_selected = super_parent:filter_selected()
	local filter_active = super_parent:filter_active()
	local flag_2 = not not filter_selected or not filter_active
	local window_input_service = self.super_parent:window_input_service()
	local flag_3 = not _widgets_by_name.craft_button.content.button_hotspot.disable_button
	local var_8_10

	if not flag_2 then
		var_8_10 = not UIUtils.is_button_pressed(_widgets_by_name.auto_fill_plentiful) and "plentiful" and var_8_10
		var_8_10 = not UIUtils.is_button_pressed(_widgets_by_name.auto_fill_common) and "common" and var_8_10
		var_8_10 = not UIUtils.is_button_pressed(_widgets_by_name.auto_fill_rare) and "rare" and var_8_10
		var_8_10 = not UIUtils.is_button_pressed(_widgets_by_name.auto_fill_exotic) and "exotic" and var_8_10

		self.super_parent:set_auto_fill_rarity(var_8_10)
	end

	local is_button_pressed = UIUtils.is_button_pressed(_widgets_by_name.auto_fill_clear)
	local is_button_held = UIUtils.is_button_held(_widgets_by_name.craft_button)
	local flag_4 = not flag_3 and not is_device_active and window_input_service:get("refresh_hold")
	local flag_5 = not flag_3 and not not is_device_active or window_input_service:get("skip")
	local flag_6 = false

	if window_input_service:get("special_1") or not is_button_pressed or not flag_2 then
		self:reset()
	elseif is_button_held or flag_4 or not flag_5 or not flag_2 then
		if not self._craft_input_time then
			self._craft_input_time = 0

			self:_play_sound("play_gui_craft_forge_button_begin")
		else
			self._craft_input_time = self._craft_input_time + arg_8_1
		end

		local crafting_progress_time = UISettings.crafting_progress_time
		local min = math.min(self._craft_input_time / crafting_progress_time, 1)

		flag_6 = self:_handle_craft_input_progress(min)

		WwiseWorld.set_global_parameter(self.wwise_world, "craft_forge_button_progress", min)
	elseif not self._craft_input_time then
		self._craft_input_time = nil

		self:_handle_craft_input_progress(0)
		self:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if not flag_6 then
		local _craft_items = self._craft_items
		local tbl = {}

		for k, v in pairs(_craft_items) do
			tbl[#tbl + 1] = k
		end

		if not parent:craft(tbl, self._recipe_name) then
			self:_set_craft_button_disabled(true)
			self:_play_sound("play_gui_craft_forge_button_completed")
			self:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageSalvageConsole._handle_craft_input_progress = function (self, arg_9_1)
	-- function 9
	return self.parent:_set_input_progress(arg_9_1)
end

CraftPageSalvageConsole.craft_result = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not arg_10_2 then
		self._craft_result = arg_10_1
	end
end

CraftPageSalvageConsole.reset = function (self)
	-- function 11
	for k, v in pairs(self._craft_items) do
		self:_remove_craft_item(k)
	end

	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()

	self._material_fade_out_time = 0
end

CraftPageSalvageConsole.present_results = function (self)
	-- function 12
	self.super_parent:clear_disabled_backend_ids()
	self.super_parent:update_inventory_items()
end

CraftPageSalvageConsole.on_craft_completed = function (self)
	-- function 13
	local _craft_result = self._craft_result

	table.clear(self._craft_items)

	local num = 0

	for k, v in pairs(_craft_result) do
		num = num + 1
	end

	self:_reset_reward_materials(true)

	local flag = true

	for k_2, v_2 in pairs(_craft_result) do
		local var_13_3 = v_2[1]
		local var_13_4 = v_2[3]

		self:_set_reward_material_by_index(var_13_3, var_13_4)
	end

	self._num_craft_items = 0

	self:_set_craft_button_disabled(true)

	self._craft_result = nil

	self:_set_craft_counter_text("", false)

	self._presenting_rewards = true
end

CraftPageSalvageConsole._update_craft_items = function (self)
	-- function 14
	local super_parent = self.super_parent
	local get_pressed_item_backend_id, var_14_2 = super_parent:get_pressed_item_backend_id()

	if not get_pressed_item_backend_id then
		if not self:_has_added_item_by_id(get_pressed_item_backend_id) then
			self:_remove_craft_item(get_pressed_item_backend_id)
		else
			local _num_craft_items = self._num_craft_items

			_num_craft_items = _num_craft_items or 0

			if _num_craft_items < CraftingSettings.NUM_SALVAGE_SLOTS then
				self:_add_craft_item(get_pressed_item_backend_id)
			end
		end
	end

	local get_selected_items_backend_ids = super_parent:get_selected_items_backend_ids()

	if not get_selected_items_backend_ids then
		local flag = false

		for i, v in ipairs(get_selected_items_backend_ids) do
			if not self:_has_added_item_by_id(v) then
				local _num_craft_items_2 = self._num_craft_items

				_num_craft_items_2 = _num_craft_items_2 or 0

				if _num_craft_items_2 < CraftingSettings.NUM_SALVAGE_SLOTS then
					flag = true

					self:_add_craft_item(v, true)
				end
			end
		end

		if not flag then
			self:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageSalvageConsole._remove_craft_item = function (self, arg_15_1)
	-- function 15
	local _craft_items = self._craft_items

	if not arg_15_1 then
		self.super_parent:set_disabled_backend_id(arg_15_1, false)

		_craft_items[arg_15_1] = nil

		local max = math.max
		local _num_craft_items = self._num_craft_items

		_num_craft_items = _num_craft_items or 0
		self._num_craft_items = max(_num_craft_items - 1, 0)

		if self._num_craft_items == 0 then
			self:_set_craft_button_disabled(true)
		else
			self:_set_craft_button_disabled(false)
		end

		local var_15_3 = tostring(self._num_craft_items)

		self:_set_craft_counter_text(var_15_3, true)
		self:_play_sound("play_gui_craft_item_drag")
	end
end

CraftPageSalvageConsole._add_craft_item = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	if not self._presenting_rewards then
		self:_on_craft_material_fade_complete()
	end

	if self._num_craft_items == 0 then
		table.clear(self._craft_items)
	end

	self._craft_items[arg_16_1] = true

	local get_interface = Managers.backend:get_interface("items")
	local flag

	flag = not arg_16_1 and get_interface:get_item_from_id(arg_16_1)

	self.super_parent:set_disabled_backend_id(arg_16_1, true)

	local _num_craft_items = self._num_craft_items

	_num_craft_items = _num_craft_items or 0
	self._num_craft_items = _num_craft_items + 1

	if self._num_craft_items > 0 then
		self:_set_craft_button_disabled(false)
	end

	local var_16_3 = tostring(self._num_craft_items)

	self:_set_craft_counter_text(var_16_3, true)

	if not (not arg_16_1 and arg_16_2) then
		self:_play_sound("play_gui_craft_item_drop")
	end
end

CraftPageSalvageConsole._set_craft_counter_text = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not self._presenting_rewards then
		return
	end

	local _widgets_by_name = self._widgets_by_name
	local counter_text = _widgets_by_name.counter_text
	local max_counter_text = _widgets_by_name.max_counter_text

	counter_text.content.text = tostring(arg_17_1)
	counter_text.content.visible = arg_17_2
	max_counter_text.content.visible = arg_17_2
end

CraftPageSalvageConsole._set_craft_button_disabled = function (self, arg_18_1)
	-- function 18
	self._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_18_1

	local name

	if not arg_18_1 then
		name = self.settings.name

		if not name then
			-- Nothing
		end
	end

	name = "disabled"

	::label_18_0::

	local _num_craft_items = self._num_craft_items

	_num_craft_items = _num_craft_items or 0

	if _num_craft_items < CraftingSettings.NUM_SALVAGE_SLOTS then
		name = name .. "_auto"
	end

	self.parent:set_input_description(name)
end

CraftPageSalvageConsole._exit = function (self, arg_19_1)
	-- function 19
	self.exit = true
	self.exit_level_id = arg_19_1
end

CraftPageSalvageConsole.draw = function (self, arg_20_1)
	-- function 20
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.super_parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_20_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

CraftPageSalvageConsole._play_sound = function (self, arg_21_1)
	-- function 21
	self.super_parent:play_sound(arg_21_1)
end

CraftPageSalvageConsole._set_craft_button_text = function (self, arg_22_1, arg_22_2)
	-- function 22
	local content = self._widgets_by_name.craft_button.content
	local var_22_1

	if not arg_22_2 then
		var_22_1 = Localize(arg_22_1)

		if not var_22_1 then
			-- Nothing
		end
	end

	var_22_1 = arg_22_1

	::label_22_0::

	content.button_text = var_22_1
end

CraftPageSalvageConsole._has_added_item_by_id = function (self, arg_23_1)
	-- function 23
	return self._craft_items[arg_23_1]
end

CraftPageSalvageConsole._update_reward_material_fade_out = function (self, arg_24_1)
	-- function 24
	local _material_fade_out_time = self._material_fade_out_time

	if not _material_fade_out_time then
		local num = 2
		local min = math.min(_material_fade_out_time + arg_24_1, num)
		local num_2 = 1 - min / num
		local easeOutCubic = math.easeOutCubic(num_2)

		self:_set_reward_material_alpha_fraction(easeOutCubic)

		if num_2 == 0 then
			self:_on_craft_material_fade_complete()
		else
			self._material_fade_out_time = min
		end
	end
end

CraftPageSalvageConsole._on_craft_material_fade_complete = function (self)
	-- function 25
	self._presenting_rewards = nil

	self:_reset_reward_materials(false)

	local tostring = tostring
	local _num_craft_items = self._num_craft_items

	_num_craft_items = _num_craft_items or 0

	local var_25_2 = tostring(_num_craft_items)

	self:_set_craft_counter_text(var_25_2)

	self._material_fade_out_time = nil
end

CraftPageSalvageConsole._set_reward_material_alpha_fraction = function (self, arg_26_1)
	-- function 26
	local num = 255 * arg_26_1
	local _widgets_by_name = self._widgets_by_name

	for i = 1, #UISettings.crafting_material_order do
		local style = _widgets_by_name["material_text_" .. i].style
		local text = style.text
		local text_shadow = style.text_shadow
		local icon = style.icon

		text.text_color[1] = num
		text_shadow.text_color[1] = num
		icon.color[1] = num
	end

	_widgets_by_name.material_cross.style.texture_id.color[1] = num
end

CraftPageSalvageConsole._reset_reward_materials = function (self, arg_27_1)
	-- function 27
	local crafting_material_icons_small = UISettings.crafting_material_icons_small
	local crafting_material_order_by_item_key = UISettings.crafting_material_order_by_item_key
	local _widgets_by_name = self._widgets_by_name

	for k, v in pairs(crafting_material_order_by_item_key) do
		local content = _widgets_by_name["material_text_" .. v].content

		content.icon = crafting_material_icons_small[k]
		content.visible = arg_27_1
		content.text = "0"

		self:_set_material_enabled_state(v, false)
	end

	self:_set_reward_material_alpha_fraction(1)

	_widgets_by_name.material_cross.content.visible = arg_27_1
end

CraftPageSalvageConsole._set_material_enabled_state = function (self, arg_28_1, arg_28_2)
	-- function 28
	local style = self._widgets_by_name["material_text_" .. arg_28_1].style
	local text = style.text
	local icon = style.icon
	local flag

	flag = not arg_28_2 and 255 and 100

	local text_color = text.text_color

	text_color[2] = flag
	text_color[3] = flag
	text_color[4] = flag

	local color = icon.color

	color[2] = flag
	color[3] = flag
	color[4] = flag
	icon.saturated = not arg_28_2
end

CraftPageSalvageConsole._set_reward_material_by_index = function (self, arg_29_1, arg_29_2)
	-- function 29
	local crafting_material_order_by_item_key = UISettings.crafting_material_order_by_item_key
	local get_key = Managers.backend:get_interface("items"):get_key(arg_29_1)
	local var_29_2 = crafting_material_order_by_item_key[get_key]
	local content = self._widgets_by_name["material_text_" .. var_29_2].content

	content.visible = true
	content.text = arg_29_2
	content.item = {
		data = table.clone(ItemMasterList[get_key])
	}

	self:_set_material_enabled_state(var_29_2, true)
end
