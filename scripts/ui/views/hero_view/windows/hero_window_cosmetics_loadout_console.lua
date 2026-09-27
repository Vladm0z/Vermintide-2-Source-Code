-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_console_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local flag = false
local str = "cosmetics_selection"

HeroWindowCosmeticsLoadoutConsole = class(HeroWindowCosmeticsLoadoutConsole)
HeroWindowCosmeticsLoadoutConsole.NAME = "HeroWindowCosmeticsLoadoutConsole"

HeroWindowCosmeticsLoadoutConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsLoadoutConsole")

	self.params = arg_1_1
	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}
	self._equipment_items = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index

	self:_start_transition_animation("on_enter")
end

HeroWindowCosmeticsLoadoutConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowCosmeticsLoadoutConsole.create_ui_elements = function (self, arg_3_1, arg_3_2)
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

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	local get_service = Managers.input:get_service("hero_view")
	local num = UILayer.default + 300

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, get_service, 6, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)

	local content = tbl_2.loadout_grid.content

	content.profile_index = self.params.profile_index
	content.career_index = self.params.career_index

	local slots_by_cosmetic_index = InventorySettings.slots_by_cosmetic_index

	for k_2, v_2 in pairs(slots_by_cosmetic_index) do
		local cosmetic_index = v_2.cosmetic_index
		local str_2 = "layout_" .. tostring(cosmetic_index) .. "_1"
		local layout_name = v_2.layout_name

		layout_name = layout_name or str
		content[str_2] = layout_name
	end
end

HeroWindowCosmeticsLoadoutConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsLoadoutConsole")

	self.ui_animator = nil

	self._menu_input_description:destroy()

	self._menu_input_description = nil
end

HeroWindowCosmeticsLoadoutConsole._input_service = function (self)
	-- function 5
	local parent = self.parent

	if not parent:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return parent:window_input_service()
end

HeroWindowCosmeticsLoadoutConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_animations(arg_6_1)
	self:_update_loadout_sync()
	self:_update_selected_cosmetic_slot_index()
	self:_update_input_description()
	self:_handle_input(arg_6_1, arg_6_2)
	self:_handle_gamepad_input(arg_6_1, arg_6_2)
	self:draw(arg_6_1)
end

HeroWindowCosmeticsLoadoutConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

HeroWindowCosmeticsLoadoutConsole._update_input_description = function (self)
	-- function 8
	local params = self.params
	local hero_statistics_active = self.params.hero_statistics_active

	if hero_statistics_active ~= self._hero_statistics_active then
		self._hero_statistics_active = hero_statistics_active

		if not hero_statistics_active then
			self._menu_input_description:change_generic_actions(generic_input_actions.details)
		else
			self._menu_input_description:change_generic_actions(generic_input_actions.default)
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._update_animations = function (self, arg_9_1)
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

HeroWindowCosmeticsLoadoutConsole._is_button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCosmeticsLoadoutConsole._handle_gamepad_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local parent = self.parent
	local _input_service = self:_input_service()
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns
	local var_11_5
	local var_11_6

	for i = 1, rows do
		for j = 1, columns do
			local str_2 = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str_2].is_selected then
				var_11_5 = i
				var_11_6 = j

				break
			end
		end
	end

	if not var_11_5 and not var_11_6 then
		if not (var_11_5 > 1) or not _input_service:get("move_up_hold_continuous") then
			parent:set_selected_cosmetic_slot_index(var_11_5 - 1)
			self:_play_sound("play_gui_cosmetics_selection_click")
		elseif not (var_11_5 < rows) or not _input_service:get("move_down_hold_continuous") then
			parent:set_selected_cosmetic_slot_index(var_11_5 + 1)
			self:_play_sound("play_gui_cosmetics_selection_click")
		end
	end

	if not _input_service:get("confirm", true) then
		local var_11_8 = self._widgets_by_name.loadout_grid.content["layout_" .. tostring(var_11_5) .. "_1"]

		parent:set_layout_by_name(var_11_8 or str)
	end
end

HeroWindowCosmeticsLoadoutConsole._handle_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local parent = self.parent
	local _is_equipment_slot_hovered = self:_is_equipment_slot_hovered()

	if not _is_equipment_slot_hovered then
		parent:set_selected_cosmetic_slot_index(_is_equipment_slot_hovered)
		self:_play_sound("play_gui_cosmetics_selection_hover")
	end

	local _is_equipment_slot_pressed = self:_is_equipment_slot_pressed()

	if not _is_equipment_slot_pressed then
		local var_12_3 = self._widgets_by_name.loadout_grid.content["layout_" .. tostring(_is_equipment_slot_pressed) .. "_1"]

		self:_play_sound("play_gui_cosmetics_selection_click")
		parent:set_layout_by_name(var_12_3 or str)
	end
end

HeroWindowCosmeticsLoadoutConsole._update_selected_cosmetic_slot_index = function (self)
	-- function 13
	local get_selected_cosmetic_slot_index = self.parent:get_selected_cosmetic_slot_index()

	if get_selected_cosmetic_slot_index ~= self._selected_cosmetic_slot_index then
		self:_set_equipment_slot_selected(get_selected_cosmetic_slot_index)

		self._selected_cosmetic_slot_index = get_selected_cosmetic_slot_index
	end
end

HeroWindowCosmeticsLoadoutConsole._update_loadout_sync = function (self)
	-- function 14
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self:_populate_loadout()

		self._loadout_sync_id = loadout_sync_id
	end
end

HeroWindowCosmeticsLoadoutConsole._exit = function (self, arg_15_1)
	-- function 15
	self.exit = true
	self.exit_level_id = arg_15_1
end

HeroWindowCosmeticsLoadoutConsole.draw = function (self, arg_16_1)
	-- function 16
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local _input_service = self:_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, _input_service, arg_16_1, nil, self.render_settings)

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

	if not (not is_device_active and not self._menu_input_description and self.parent:input_blocked()) then
		self._menu_input_description:draw(ui_top_renderer, arg_16_1)
	end
end

HeroWindowCosmeticsLoadoutConsole._play_sound = function (self, arg_17_1)
	-- function 17
	self.parent:play_sound(arg_17_1)
end

HeroWindowCosmeticsLoadoutConsole._setup_slot_icons = function (self)
	-- function 18
	local slots_by_cosmetic_index = InventorySettings.slots_by_cosmetic_index

	for k, v in pairs(slots_by_cosmetic_index) do
		local ui_slot_index = v.ui_slot_index

		if not ui_slot_index then
			local content = self._widgets_by_name.loadout_grid.content
			local str = "_1_" .. tostring(ui_slot_index)
			local str_2 = "item_icon" .. str
			local str_3 = "hotspot" .. str
			local str_4 = "item_tooltip" .. str
			local str_5 = "slot_icon" .. str
			local type = v.type
			local var_18_9 = slot_icon_by_type[type]

			var_18_9 = var_18_9 or "tabs_icon_all_selected"
			content[str_5] = var_18_9
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._populate_loadout = function (self)
	-- function 19
	local hero_name = self.hero_name
	local slots_by_cosmetic_index = InventorySettings.slots_by_cosmetic_index
	local career_index = self.career_index
	local var_19_3 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_19_3].careers[career_index].name

	for k, v in pairs(slots_by_cosmetic_index) do
		local name_2 = v.name

		self:_clear_item_slot(v)

		local get_loadout_item = BackendUtils.get_loadout_item(name, name_2)

		if not get_loadout_item then
			self:_equip_item_presentation(get_loadout_item, v)
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._equip_item_presentation = function (self, arg_20_1, arg_20_2)
	-- function 20
	local slot_type = arg_20_1.data.slot_type
	local slot_index = arg_20_2.slot_index
	local cosmetic_index = arg_20_2.cosmetic_index
	local _widgets_by_name = self._widgets_by_name

	if not cosmetic_index then
		self._equipment_items[cosmetic_index] = arg_20_1

		local loadout_grid = _widgets_by_name.loadout_grid
		local content = loadout_grid.content
		local style = loadout_grid.style
		local str = "_" .. tostring(cosmetic_index) .. "_1"
		local str_2 = "item_icon" .. str
		local str_3 = "hotspot" .. str
		local str_4 = "item_tooltip" .. str
		local get_ui_information_from_item, var_20_12, var_20_13 = UIUtils.get_ui_information_from_item(arg_20_1)

		content[str_4] = var_20_12
		content["item" .. str] = arg_20_1

		local backend_id = arg_20_1.backend_id
		local rarity = arg_20_1.rarity
		local get_interface = Managers.backend:get_interface("items")

		if not backend_id then
			rarity = get_interface:get_item_rarity(backend_id)
		end

		if not rarity then
			content["rarity_texture" .. str] = UISettings.item_rarity_textures[rarity]
		end

		content[str_3][str_2] = get_ui_information_from_item
	end
end

HeroWindowCosmeticsLoadoutConsole._clear_item_slot = function (self, arg_21_1)
	-- function 21
	local type = arg_21_1.type
	local slot_index = arg_21_1.slot_index
	local ui_slot_index = arg_21_1.ui_slot_index
	local _widgets_by_name = self._widgets_by_name

	if not ui_slot_index then
		self._equipment_items[slot_index] = nil

		local loadout_grid = _widgets_by_name.loadout_grid
		local content = loadout_grid.content
		local style = loadout_grid.style
		local str = "_" .. tostring(slot_index) .. "_1"
		local str_2 = "item_icon" .. str
		local str_3 = "hotspot" .. str

		content["item_tooltip" .. str] = nil
		content["item" .. str] = nil
		content[str_3][str_2] = nil
	end
end

HeroWindowCosmeticsLoadoutConsole._is_equipment_slot_right_clicked = function (self)
	-- function 22
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str].on_right_click then
				return i
			end
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._is_equipment_slot_pressed = function (self)
	-- function 23
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str].on_pressed then
				return i
			end
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._is_equipment_slot_hovered = function (self)
	-- function 24
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str].on_hover_enter then
				return i
			end
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._set_equipment_slot_selected = function (self, arg_25_1)
	-- function 25
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local var_25_4 = content["hotspot" .. str]

			var_25_4.is_selected = not arg_25_1 and arg_25_1 == i
			var_25_4.highlight = var_25_4.is_selected
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._enable_selection_highlight = function (self)
	-- function 26
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local var_26_4 = content["hotspot" .. str]

			var_26_4.highlight = var_26_4.is_selected
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._disable_selection_highlight = function (self)
	-- function 27
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			content["hotspot" .. str].highlight = false
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._is_equipment_slot_hovered_by_type = function (self, arg_28_1)
	-- function 28
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns
	local slots_by_ui_slot_index = InventorySettings.slots_by_ui_slot_index

	for i = 1, rows do
		for j = 1, columns do
			if slots_by_ui_slot_index[j].type == arg_28_1 then
				local str = "_" .. tostring(i) .. "_" .. tostring(j)

				if not content["hotspot" .. str].internal_is_hover then
					return j
				end
			end
		end
	end
end

HeroWindowCosmeticsLoadoutConsole._highlight_equipment_slot_by_type = function (self, arg_29_1)
	-- function 29
	local loadout_grid = self._widgets_by_name.loadout_grid
	local content = loadout_grid.content
	local style = loadout_grid.style
	local rows = content.rows
	local columns = content.columns
	local slots_by_ui_slot_index = InventorySettings.slots_by_ui_slot_index

	for i = 1, rows do
		for j = 1, columns do
			local var_29_6 = slots_by_ui_slot_index[j]
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "hotspot" .. str
			local str_3 = "slot_hover" .. str
			local var_29_10 = content[str_2]
			local flag = var_29_6.type == arg_29_1

			var_29_10.highlight = flag

			local flag_2

			flag_2 = not var_29_10.internal_is_hover and 255 and 100
			style[str_3].color[1] = not flag and flag_2 and 255
		end
	end
end
