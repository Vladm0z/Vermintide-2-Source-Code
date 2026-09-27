-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false

HeroWindowCosmeticsLoadout = class(HeroWindowCosmeticsLoadout)
HeroWindowCosmeticsLoadout.NAME = "HeroWindowCosmeticsLoadout"

HeroWindowCosmeticsLoadout.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsLoadout")

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
end

HeroWindowCosmeticsLoadout.create_ui_elements = function (self, arg_2_1, arg_2_2)
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

	if not arg_2_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

HeroWindowCosmeticsLoadout.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsLoadout")

	self.ui_animator = nil
end

HeroWindowCosmeticsLoadout.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_animations(arg_4_1)
	self:_update_loadout_sync()
	self:_update_selected_cosmetic_slot_index()
	self:_handle_input(arg_4_1, arg_4_2)
	self:draw(arg_4_1)
end

HeroWindowCosmeticsLoadout.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

HeroWindowCosmeticsLoadout._update_animations = function (self, arg_6_1)
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
end

HeroWindowCosmeticsLoadout._is_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCosmeticsLoadout._handle_input = function (self, arg_8_1, arg_8_2)
	-- function 8
	local parent = self.parent

	if not self:_is_equipment_slot_hovered() then
		self:_play_sound("play_gui_cosmetics_selection_hover")
	end

	local _is_equipment_slot_pressed = self:_is_equipment_slot_pressed()

	if not _is_equipment_slot_pressed then
		parent:set_selected_cosmetic_slot_index(_is_equipment_slot_pressed)
		self:_play_sound("play_gui_cosmetics_selection_click")
	end
end

HeroWindowCosmeticsLoadout._update_selected_cosmetic_slot_index = function (self)
	-- function 9
	local get_selected_cosmetic_slot_index = self.parent:get_selected_cosmetic_slot_index()

	if get_selected_cosmetic_slot_index ~= self._selected_cosmetic_slot_index then
		self:_set_equipment_slot_selected(get_selected_cosmetic_slot_index)

		self._selected_cosmetic_slot_index = get_selected_cosmetic_slot_index
	end
end

HeroWindowCosmeticsLoadout._update_loadout_sync = function (self)
	-- function 10
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self:_populate_loadout()

		self._loadout_sync_id = loadout_sync_id
	end
end

HeroWindowCosmeticsLoadout._exit = function (self, arg_11_1)
	-- function 11
	self.exit = true
	self.exit_level_id = arg_11_1
end

HeroWindowCosmeticsLoadout.draw = function (self, arg_12_1)
	-- function 12
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_12_1, nil, self.render_settings)

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
end

HeroWindowCosmeticsLoadout._play_sound = function (self, arg_13_1)
	-- function 13
	self.parent:play_sound(arg_13_1)
end

HeroWindowCosmeticsLoadout._setup_slot_icons = function (self)
	-- function 14
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
			local var_14_9 = slot_icon_by_type[type]

			var_14_9 = var_14_9 or "tabs_icon_all_selected"
			content[str_5] = var_14_9
		end
	end
end

HeroWindowCosmeticsLoadout._populate_loadout = function (self)
	-- function 15
	local hero_name = self.hero_name
	local slots_by_cosmetic_index = InventorySettings.slots_by_cosmetic_index
	local career_index = self.career_index
	local var_15_3 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_15_3].careers[career_index].name

	for k, v in pairs(slots_by_cosmetic_index) do
		local name_2 = v.name
		local get_loadout_item = BackendUtils.get_loadout_item(name, name_2)

		if not get_loadout_item then
			self:_equip_item_presentation(get_loadout_item, v)
		end
	end
end

HeroWindowCosmeticsLoadout._equip_item_presentation = function (self, arg_16_1, arg_16_2)
	-- function 16
	local slot_type = arg_16_1.data.slot_type
	local slot_index = arg_16_2.slot_index
	local cosmetic_index = arg_16_2.cosmetic_index
	local _widgets_by_name = self._widgets_by_name

	if not cosmetic_index then
		self._equipment_items[cosmetic_index] = arg_16_1

		local loadout_grid = _widgets_by_name.loadout_grid
		local content = loadout_grid.content
		local style = loadout_grid.style
		local str = "_1_" .. tostring(cosmetic_index)
		local str_2 = "item_icon" .. str
		local str_3 = "hotspot" .. str
		local str_4 = "item_tooltip" .. str
		local get_ui_information_from_item, var_16_12, var_16_13 = UIUtils.get_ui_information_from_item(arg_16_1)

		content[str_4] = var_16_12
		content["item" .. str] = arg_16_1

		local backend_id = arg_16_1.backend_id
		local rarity = arg_16_1.rarity
		local get_interface = Managers.backend:get_interface("items")

		if not backend_id then
			rarity = get_interface:get_item_rarity(backend_id)
		end

		if not rarity then
			content["rarity_texture" .. str] = UISettings.item_rarity_textures[rarity]
		end

		local var_16_17 = content[str_3]

		if not var_16_17 then
			var_16_17[str_2] = get_ui_information_from_item
		end
	end
end

HeroWindowCosmeticsLoadout._is_equipment_slot_pressed = function (self)
	-- function 17
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str].on_pressed then
				return j
			end
		end
	end
end

HeroWindowCosmeticsLoadout._is_equipment_slot_hovered = function (self)
	-- function 18
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str].on_hover_enter then
				return j
			end
		end
	end
end

HeroWindowCosmeticsLoadout._set_equipment_slot_selected = function (self, arg_19_1)
	-- function 19
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			content["hotspot" .. str].is_selected = not arg_19_1 and arg_19_1 == j
		end
	end
end

HeroWindowCosmeticsLoadout._is_equipment_slot_hovered_by_type = function (self, arg_20_1)
	-- function 20
	local content = self._widgets_by_name.loadout_grid.content
	local rows = content.rows
	local columns = content.columns
	local slots_by_cosmetic_index = InventorySettings.slots_by_cosmetic_index

	for i = 1, rows do
		for j = 1, columns do
			if slots_by_cosmetic_index[j].type == arg_20_1 then
				local str = "_" .. tostring(i) .. "_" .. tostring(j)

				if not content["hotspot" .. str].internal_is_hover then
					return j
				end
			end
		end
	end
end

HeroWindowCosmeticsLoadout._highlight_equipment_slot_by_type = function (self, arg_21_1)
	-- function 21
	local loadout_grid = self._widgets_by_name.loadout_grid
	local content = loadout_grid.content
	local style = loadout_grid.style
	local rows = content.rows
	local columns = content.columns
	local slots_by_cosmetic_index = InventorySettings.slots_by_cosmetic_index

	for i = 1, rows do
		for j = 1, columns do
			local var_21_6 = slots_by_cosmetic_index[j]
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "hotspot" .. str
			local str_3 = "slot_hover" .. str
			local var_21_10 = content[str_2]
			local flag = var_21_6.type == arg_21_1

			var_21_10.highlight = flag

			local flag_2

			flag_2 = not var_21_10.internal_is_hover and 255 and 100
			style[str_3].color[1] = not flag and flag_2 and 255
		end
	end
end
