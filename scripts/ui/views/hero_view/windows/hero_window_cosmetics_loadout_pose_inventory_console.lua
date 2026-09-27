-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_pose_inventory_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_pose_inventory_console_definitions")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local create_illusion_button = var_0_0.create_illusion_button
local weapon_illusion_base_widgets = var_0_0.weapon_illusion_base_widgets
local flag = false
local str = "trigger_cycle_next"
local str_2 = "trigger_cycle_previous"

local function fn(self, arg_1_1)
	-- function 1
	local data = self.data
	local data_2 = arg_1_1.data
	local key = data.key
	local key_2 = data_2.key
	local power_level = self.power_level

	power_level = power_level or 0

	local power_level_2 = arg_1_1.power_level

	power_level_2 = power_level_2 or 0

	local backend_id = self.backend_id
	local backend_id_2 = arg_1_1.backend_id
	local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

	if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_1_1) then
		if power_level == power_level_2 then
			local rarity = self.rarity

			rarity = rarity or data.rarity

			local rarity_2 = arg_1_1.rarity

			rarity_2 = rarity_2 or data_2.rarity

			local item_rarity_order = UISettings.item_rarity_order
			local var_1_12 = item_rarity_order[rarity]
			local var_1_13 = item_rarity_order[rarity_2]

			if var_1_12 == var_1_13 then
				local var_1_14 = Localize(data.item_type)
				local var_1_15 = Localize(data_2.item_type)

				if var_1_14 == var_1_15 then
					local get_ui_information_from_item, var_1_17 = UIUtils.get_ui_information_from_item(self)
					local get_ui_information_from_item_2, var_1_19 = UIUtils.get_ui_information_from_item(arg_1_1)

					return Localize(var_1_17) < Localize(var_1_19)
				else
					return var_1_14 < var_1_15
				end
			else
				return var_1_12 < var_1_13
			end
		else
			return power_level_2 < power_level
		end
	elseif not is_favorite_backend_id then
		return true
	else
		return false
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole = class(HeroWindowCosmeticsLoadoutPoseInventoryConsole)
HeroWindowCosmeticsLoadoutPoseInventoryConsole.NAME = "HeroWindowCosmeticsLoadoutPoseInventoryConsole"

HeroWindowCosmeticsLoadoutPoseInventoryConsole.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsLoadoutPoseInventoryConsole")

	self._params = arg_2_1
	self._parent = arg_2_1.parent

	local ingame_ui_context = arg_2_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._world_previewer = arg_2_1.world_previewer

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self._player_manager = player
	self._peer_id = ingame_ui_context.peer_id
	self._hero_name = arg_2_1.hero_name
	self._career_index = arg_2_1.career_index
	self._profile_index = arg_2_1.profile_index
	self._career_name = SPProfiles[self._profile_index].careers[self._career_index].name
	self._current_input_description = "default"
	self._animations = {}

	self:create_ui_elements(arg_2_1, arg_2_2)
	self:_setup_input_buttons()

	local tbl = {
		profile_index = arg_2_1.profile_index,
		career_index = arg_2_1.career_index
	}
	local var_2_4 = ItemGridUI:new(category_settings, self._widgets_by_name.item_grid, self._hero_name, self._career_index, tbl)

	self._item_grid = var_2_4

	var_2_4:mark_locked_items(true)
	var_2_4:disable_locked_items(true)
	var_2_4:disable_unwieldable_items(true)
	var_2_4:mark_equipped_weapon_pose_parent(true)
	var_2_4:disable_item_drag()
	var_2_4:apply_item_sorting_function(fn)
	self:_set_item_compare_enable_state(false)
	self:_show_equipped_weapon_pose()

	local flag = not local_player and local_player.player_unit

	if not flag then
		local has_extension = ScriptUnit.has_extension(flag, "inventory_system")

		if not has_extension then
			has_extension:check_and_drop_pickups("enter_inventory")
		end
	end

	self:_start_transition_animation("on_enter")
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._show_equipped_weapon_pose = function (self)
	-- function 3
	local get_interface = Managers.backend:get_interface("items")
	local get_loadout_item_id = get_interface:get_loadout_item_id(self._career_name, "slot_pose")

	if not get_loadout_item_id then
		return
	end

	local data = get_interface:get_item_from_id(get_loadout_item_id).data
	local parent = data.parent
	local var_3_4 = rawget(ItemMasterList, parent)

	if not var_3_4 then
		local clone = table.clone(var_3_4)
		local get_equipped_weapon_pose_skin = get_interface:get_equipped_weapon_pose_skin(parent)
		local var_3_7

		if not get_equipped_weapon_pose_skin then
			var_3_7 = get_equipped_weapon_pose_skin
		end

		self._parent:set_temporary_loadout_item({
			data = clone,
			skin = var_3_7
		})
		self._parent:set_character_pose_animation(data.data.anim_event)
	end
end

local tbl = {}

HeroWindowCosmeticsLoadoutPoseInventoryConsole._start_transition_animation = function (self, arg_4_1, arg_4_2)
	-- function 4
	local tbl_2 = {
		wwise_world = self.wwise_world,
		render_settings = self._render_settings
	}
	local flag = arg_4_2 or tbl
	local start_animation = self.ui_animator:start_animation(arg_4_1, flag, scenegraph_definition, tbl_2)

	self._animations[arg_4_1] = start_animation
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole.create_ui_elements = function (self, arg_5_1, arg_5_2)
	-- function 5
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_5_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_5_2
		tbl_2[k] = var_5_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._illusion_widgets = {}
	self._illusion_base_widgets = {}

	local get_service = Managers.input:get_service("hero_view")
	local controller_description = UILayer.controller_description

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, get_service, 7, controller_description, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_5_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_5_2[1]
		local_position[2] = local_position[2] + arg_5_2[2]
		local_position[3] = local_position[3] + arg_5_2[3]
	end

	tbl_2.item_tooltip.content.profile_index = self._params.profile_index
	tbl_2.item_tooltip.content.career_index = self._params.career_index
	tbl_2.item_tooltip_compare.content.profile_index = self._params.profile_index
	tbl_2.item_tooltip_compare.content.career_index = self._params.career_index
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._input_service = function (self)
	-- function 6
	local _parent = self._parent

	if not _parent:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return _parent:window_input_service()
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole.set_focus = function (self, arg_7_1)
	-- function 7
	self._focused = arg_7_1

	local _render_settings = self._render_settings
	local flag

	flag = not arg_7_1 and 1 and 0.5
	_render_settings.alpha_multiplier = flag
	self._widgets_by_name.item_tooltip.content.visible = arg_7_1
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole.on_exit = function (self, arg_8_1)
	-- function 8
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsLoadoutPoseInventoryConsole")

	self.ui_animator = nil

	self._item_grid:destroy()

	self._item_grid = nil

	self._menu_input_description:destroy()

	self._menu_input_description = nil

	self._parent:set_character_pose_animation(nil)
	self._parent:clear_temporary_loadout()
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self._item_grid:update(arg_9_1, arg_9_2)
	self:_update_animations(arg_9_1)
	self:_update_selected_cosmetic_slot_index()
	self:_update_loadout_sync()
	self:_update_page_info()
	self:_update_input_description()
	self:_update_illusions(arg_9_1, arg_9_2)
	self:_update_remove_button_state(arg_9_1, arg_9_2)

	if not self._focused then
		self:_handle_gamepad_activity()
		self:_update_selected_item_tooltip()
		self:_handle_input(arg_9_1, arg_9_2)
		self:_handle_gamepad_input(arg_9_1, arg_9_2)
	end

	self:draw(arg_9_1)
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_illusions = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _illusion_widgets = self._illusion_widgets

	if not table.is_empty(_illusion_widgets) then
		return
	end

	local _widgets_by_name = self._widgets_by_name
	local flag = false

	for i, v in ipairs(_illusion_widgets) do
		if not UIUtils.is_button_pressed(v) then
			local flag_2 = false
			local flag_3 = true

			self:_on_illusion_index_pressed(i, flag_2, flag_3)

			return
		elseif not UIUtils.is_button_hover_enter(v) then
			self:_play_sound("play_gui_equipment_inventory_hover")

			local skin_key = v.content.skin_key
			local var_11_6 = WeaponSkins.skins[skin_key]

			self._widgets_by_name.illusions_name.content.text = Localize(var_11_6.display_name)

			return
		elseif not UIUtils.is_button_hover(v) then
			flag = true
		end
	end

	if not flag then
		local skin_key_2 = _illusion_widgets[self._selected_skin_index].content.skin_key
		local var_11_8 = WeaponSkins.skins[skin_key_2]

		_widgets_by_name.illusions_name.content.text = Localize(var_11_8.display_name)
	end

	if not UIUtils.is_button_pressed(_widgets_by_name.apply_illusion_button) then
		self:_apply_illusion()
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_remove_button_state = function (self, arg_12_1, arg_12_2)
	-- function 12
	local get_interface = Managers.backend:get_interface("items")
	local get_loadout_item_id = BackendUtils.get_loadout_item_id(self._career_name, "slot_pose")
	local flag = not get_loadout_item_id and get_interface:get_item_from_id(get_loadout_item_id)
	local flag_2 = not flag and flag.key
	local button_remove = self._widgets_by_name.button_remove

	UIUtils.enable_button(button_remove, not flag_2 and flag_2 ~= "default_weapon_pose_01")
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._apply_illusion = function (self)
	-- function 13
	local content = self._illusion_widgets[self._selected_skin_index].content

	if not content.locked then
		local skin_key = content.skin_key
		local var_13_2 = ItemMasterList[skin_key]
		local get_interface = Managers.backend:get_interface("items")
		local gsub = string.gsub(self._selected_blueprint_name, "^vs_", "")

		if var_13_2.matching_item_key == gsub then
			local get_weapon_skin_from_skin_key, var_13_6 = get_interface:get_weapon_skin_from_skin_key(skin_key)

			get_interface:set_weapon_pose_skin(gsub, get_weapon_skin_from_skin_key)

			local flag = true
			local flag_2 = true

			self:_select_illusion_by_key(skin_key, flag, flag_2)

			local get_loadout_item_id = get_interface:get_loadout_item_id(self._career_name, "slot_pose")
			local get_item_from_id = get_interface:get_item_from_id(get_loadout_item_id)
			local flag_3 = not get_item_from_id and get_item_from_id.data

			if gsub == (not flag_3 and flag_3.parent) then
				local local_player = Managers.player:local_player()

				CosmeticUtils.update_cosmetic_slot(local_player, "slot_pose", get_item_from_id.key)
			end
		end
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_input_description = function (self)
	-- function 14
	local str = "default"

	if not self._selected_blueprint_name then
		str = not self._gamepad_illusion_buttons_active and not self._widgets_by_name.apply_illusion_button.content.visible and "apply_weapon_skin" and "weapon_skin" or "pose_selection"
	end

	if str ~= self._current_input_description then
		self._menu_input_description:change_generic_actions(generic_input_actions[str])

		self._current_input_description = str
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._set_item_compare_enable_state = function (self, arg_15_1)
	-- function 15
	self._widgets_by_name.item_tooltip_compare.content.visible = arg_15_1
	self._draw_item_compare = arg_15_1
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_equipped_item_tooltip = function (self)
	-- function 16
	local _selected_cosmetic_slot_index = self._selected_cosmetic_slot_index
	local name = InventorySettings.slots_by_cosmetic_index[_selected_cosmetic_slot_index].name
	local get_interface = Managers.backend:get_interface("items")
	local get_loadout_item_id = BackendUtils.get_loadout_item_id(self._career_name, name)
	local flag = not get_loadout_item_id and get_interface:get_item_from_id(get_loadout_item_id)

	self._widgets_by_name.item_tooltip_compare.content.item = flag
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_selected_item_tooltip = function (self)
	-- function 17
	local selected_item = self._item_grid:selected_item()
	local flag = not selected_item and selected_item.backend_id

	if flag ~= self._selected_backend_id then
		self._widgets_by_name.item_tooltip.content.item = selected_item
	end

	self._selected_backend_id = flag
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_animations = function (self, arg_18_1)
	-- function 18
	self.ui_animator:update(arg_18_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name
	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_arrow_button(page_button_next, arg_18_1)
	UIWidgetUtils.animate_arrow_button(page_button_previous, arg_18_1)

	if not table.is_empty(self._illusion_base_widgets) then
		UIWidgetUtils.animate_default_button(_widgets_by_name.apply_illusion_button, arg_18_1)
	end

	UIWidgetUtils.animate_default_button(_widgets_by_name.button_remove, arg_18_1)
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._handle_gamepad_input = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local _parent = self._parent
	local _input_service = self:_input_service()
	local _item_grid = self._item_grid

	if not self._gamepad_illusion_buttons_active then
		local _selected_skin_index = self._selected_skin_index
		local _illusion_widgets = self._illusion_widgets

		if _input_service:get("special_1", true) or not _input_service:get("back_menu", true) then
			self:_toggle_gamepad_illusion_buttons()

			return
		elseif not _input_service:get("confirm", true) then
			self:_apply_illusion()

			return
		end

		local flag = false

		if not (_selected_skin_index > 1) or not _input_service:get("move_left_hold_continuous") then
			_selected_skin_index = _selected_skin_index - 1
			flag = true
		elseif not (_selected_skin_index < #_illusion_widgets) or not _input_service:get("move_right_hold_continuous") then
			_selected_skin_index = _selected_skin_index + 1
			flag = true
		end

		if not flag then
			local flag_2 = false
			local flag_3 = true

			self:_on_illusion_index_pressed(_selected_skin_index, flag_2, flag_3)
		end
	else
		if not _item_grid:handle_gamepad_selection(_input_service) then
			self:_play_sound("play_gui_inventory_item_hover")
		end

		if not _input_service:get("confirm", true) then
			local selected_item, var_19_9 = _item_grid:selected_item()

			if not selected_item then
				local data = selected_item.data

				if data.slot_type == "weapon_pose" then
					if not self._widgets_by_name.apply_illusion_button.content.visible then
						self:_apply_illusion()
					elseif not var_19_9 then
						_parent:_set_loadout_item(selected_item)
						self:_play_sound("play_gui_equipment_equip_hero")
					end
				else
					self._selected_blueprint_name, self._selected_blueprint_item = data.name, table.clone(selected_item)

					local str_3 = "weapon_pose_parent == " .. string.gsub(self._selected_blueprint_name, "^vs_", "")

					self:_change_item_filter(str_3)
					self._parent:set_temporary_loadout_item(selected_item)
					self:_setup_illusions(selected_item)
				end
			end
		elseif not _input_service:get("special_1", true) then
			self:_toggle_gamepad_illusion_buttons()
		else
			local selected_item_2, var_19_13 = _item_grid:selected_item()

			if not selected_item_2 then
				local data_2 = selected_item_2.data

				if data_2.slot_type == "weapon_pose" then
					local anim_event = data_2.data.anim_event

					if self._current_anim_event ~= anim_event then
						self._parent:set_character_pose_animation(anim_event)

						self._current_anim_event = anim_event
					end
				end
			elseif not self._current_anim_event then
				self._parent:clear_character_animation()

				self._current_anim_event = nil
				self._current_hovered_item = nil
			end
		end

		if not self._selected_blueprint_name and _input_service:get("back_menu", true) and not _input_service:get("toggle_menu", true) then
			self:_back()
		elseif not _input_service:get("refresh") then
			self:_equip_default()

			return
		end

		local _current_page = self._current_page
		local _total_pages = self._total_pages

		if not _current_page and not _total_pages then
			if not (_current_page < _total_pages) or not _input_service:get(str) then
				_item_grid:set_item_page(_current_page + 1)
				self:_play_sound("play_gui_equipment_inventory_next_click")

				local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

				_item_grid:set_item_selected(get_item_in_slot)
			elseif not (_current_page > 1) or not _input_service:get(str_2) then
				_item_grid:set_item_page(_current_page - 1)
				self:_play_sound("play_gui_equipment_inventory_next_click")

				local get_item_in_slot_2 = _item_grid:get_item_in_slot(1, 1)

				_item_grid:set_item_selected(get_item_in_slot_2)
			end
		end
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._toggle_gamepad_illusion_buttons = function (self)
	-- function 20
	self._gamepad_illusion_buttons_active = not self._gamepad_illusion_buttons_active
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._handle_input = function (self, arg_21_1, arg_21_2)
	-- function 21
	local _widgets_by_name = self._widgets_by_name
	local _parent = self._parent
	local _item_grid = self._item_grid
	local flag = self._selected_blueprint_name == nil
	local is_item_pressed, var_21_5 = _item_grid:is_item_pressed(flag)
	local get_item_hovered, var_21_7 = _item_grid:get_item_hovered()
	local _input_service = self:_input_service()

	if not Managers.input:is_device_active("mouse") then
		return
	end

	if not self._selected_blueprint_name and not _input_service:get("toggle_menu", true) then
		self:_back()

		return
	end

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not _item_grid:handle_favorite_marking(_input_service) then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not is_item_pressed then
		local data = is_item_pressed.data

		if data.slot_type == "weapon_pose" then
			if not var_21_5 then
				self:_set_loadout_item(is_item_pressed)
				self:_play_sound("play_gui_equipment_equip_hero")
			end
		else
			self._selected_blueprint_name, self._selected_blueprint_item = data.name, table.clone(is_item_pressed)

			local str = "weapon_pose_parent == " .. string.gsub(self._selected_blueprint_name, "^vs_", "")

			self:_change_item_filter(str)
			self:_setup_illusions(is_item_pressed)
		end
	elseif not get_item_hovered then
		local data_2 = get_item_hovered.data

		if data_2.slot_type == "weapon_pose" then
			local anim_event = data_2.data.anim_event

			if self._current_anim_event ~= anim_event then
				self._parent:set_character_pose_animation(anim_event)

				self._current_anim_event = anim_event
				self._current_hovered_item = get_item_hovered
			end
		end
	end

	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	if UIUtils.is_button_hover_enter(page_button_next) or not UIUtils.is_button_hover_enter(page_button_previous) then
		self:_play_sound("play_gui_inventory_next_hover")
	end

	if not UIUtils.is_button_pressed(page_button_next) then
		local num = self._current_page + 1

		_item_grid:set_item_page(num)
		self:_play_sound("play_gui_equipment_inventory_next_click")
	elseif not UIUtils.is_button_pressed(page_button_previous) then
		local num_2 = self._current_page - 1

		_item_grid:set_item_page(num_2)
		self:_play_sound("play_gui_equipment_inventory_next_click")
	end

	local button_remove = _widgets_by_name.button_remove

	if not UIUtils.is_button_hover_enter(button_remove) then
		self:_play_sound("play_gui_equipment_inventory_hover")
	end

	if not UIUtils.is_button_pressed(button_remove) then
		self:_equip_default()
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._equip_default = function (self)
	-- function 22
	self:_play_sound("play_gui_equipment_equip_hero")

	local get_item_from_key = Managers.backend:get_interface("items"):get_item_from_key("default_weapon_pose_01")

	if not get_item_from_key then
		self._parent:_set_loadout_item(get_item_from_key)
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._set_loadout_item = function (self, arg_23_1)
	-- function 23
	self._parent:_set_loadout_item(arg_23_1)

	local data = arg_23_1.data
	local local_player = Managers.player:local_player()

	CosmeticUtils.update_cosmetic_slot(local_player, "slot_pose", data.name)
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._select_illusion_by_key = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	if not arg_24_1 then
		return
	end

	local _illusion_widgets = self._illusion_widgets

	for i, v in ipairs(_illusion_widgets) do
		if v.content.skin_key == arg_24_1 then
			self:_on_illusion_index_pressed(i, arg_24_2, arg_24_3)

			break
		end
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._on_illusion_index_pressed = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local content = self._illusion_widgets[arg_25_1].content
	local skin_key = content.skin_key

	self._skin_dirty = false

	local locked = content.locked
	local _selected_blueprint_item = self._selected_blueprint_item

	_selected_blueprint_item.skin = skin_key

	self._parent:clear_temporary_loadout()
	self._parent:set_temporary_loadout_item(_selected_blueprint_item, arg_25_3)

	if not locked then
		local get_interface = Managers.backend:get_interface("items")
		local get_unlocked_weapon_poses = get_interface:get_unlocked_weapon_poses()
		local _selected_blueprint_name = self._selected_blueprint_name
		local var_25_7 = ItemMasterList[_selected_blueprint_name]
		local gsub = string.gsub(var_25_7.name, "^vs_", "")

		if not get_unlocked_weapon_poses[gsub] then
			local var_25_9 = tbl
		end

		local var_25_10 = WeaponSkins.default_skins[gsub]
		local get_weapon_skin_from_skin_key, var_25_12 = get_interface:get_weapon_skin_from_skin_key(var_25_10)
		local get_equipped_weapon_pose_skin = get_interface:get_equipped_weapon_pose_skin(gsub)

		if not ((get_equipped_weapon_pose_skin or skin_key == var_25_10 or not get_equipped_weapon_pose_skin) and get_equipped_weapon_pose_skin == skin_key) then
			self:_enable_apply_illusion_button(true, true)
		else
			self:_enable_apply_illusion_button(false)
		end
	else
		self:_enable_apply_illusion_button(false)
	end

	local _widgets_by_name = self._widgets_by_name
	local var_25_15 = WeaponSkins.skins[skin_key]

	_widgets_by_name.illusions_name.content.text = Localize(var_25_15.display_name)

	local _illusion_widgets = self._illusion_widgets

	for i, v in ipairs(_illusion_widgets) do
		local flag = i == arg_25_1
		local content_2 = v.content

		content_2.button_hotspot.is_selected = flag

		if not arg_25_2 then
			content_2.equipped = flag
		end
	end

	self._selected_skin_index = arg_25_1

	self:_play_sound("play_gui_equipment_equip")
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._enable_apply_illusion_button = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not GameSettingsDevelopment.read_only_backend then
		arg_26_1 = false
	end

	local apply_illusion_button = self._widgets_by_name.apply_illusion_button

	apply_illusion_button.content.visible = arg_26_1
	apply_illusion_button.content.button_hotspot.disable_button = not arg_26_1
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._get_item = function (self, arg_27_1)
	-- function 27
	self._item_backend_id = arg_27_1

	return Managers.backend:get_interface("items"):get_item_from_id(arg_27_1)
end

local function fn_2(self, arg_28_1)
	-- function 28
	local skins = WeaponSkins.skins
	local item_rarity_order = UISettings.item_rarity_order
	local content = self.content
	local content_2 = arg_28_1.content
	local rarity = content.rarity
	local rarity_2 = content_2.rarity
	local var_28_6 = item_rarity_order[rarity]

	var_28_6 = var_28_6 or 0

	local var_28_7 = item_rarity_order[rarity_2]

	var_28_7 = var_28_7 or 0

	return var_28_7 < var_28_6
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._clear_illusion_widgets = function (self)
	-- function 29
	table.clear(self._illusion_base_widgets)
	table.clear(self._illusion_widgets)
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._setup_illusions = function (self, arg_30_1)
	-- function 30
	local tbl_2 = {}
	local _widgets_by_name = self._widgets_by_name

	for k, v in pairs(weapon_illusion_base_widgets) do
		local var_30_2 = UIWidget.init(v)

		tbl_2[#tbl_2 + 1] = var_30_2
		_widgets_by_name[k] = var_30_2
	end

	self._illusion_base_widgets = tbl_2

	local gsub = string.gsub(arg_30_1.key, "^vs_", "")
	local data = arg_30_1.data
	local var_30_5 = ItemMasterList[gsub]
	local flag = var_30_5 or data
	local num = 0
	local skin_combination_table = flag.skin_combination_table
	local var_30_9 = WeaponSkins.skin_combinations[skin_combination_table]

	var_30_9 = var_30_9 or tbl

	local get_interface = Managers.backend:get_interface("quests")
	local get_unlocked_weapon_skins = Managers.backend:get_interface("crafting"):get_unlocked_weapon_skins()
	local var_30_12 = WeaponSkins.default_skins[gsub]
	local var_30_13
	local num_2 = 51
	local num_3 = -5
	local num_4 = -num_3
	local tbl_3 = {}
	local tbl_4 = {}
	local RaritySettings = RaritySettings
	local var_30_20 = create_illusion_button()

	for k_2, v_2 in pairs(var_30_9) do
		for i, v_3 in ipairs(v_2) do
			if not tbl_4[v_3] then
				if not RaritySettings[k_2] then
					local var_30_21 = WeaponSkins.skins[v_3]

					k_2 = not var_30_21 and var_30_21.rarity and k_2
				end

				local var_30_22 = get_unlocked_weapon_skins[v_3]

				var_30_22 = var_30_22 or v_3 == var_30_12

				local flag_2 = true
				local var_30_24 = ItemMasterList[v_3]

				var_30_24 = var_30_24 or tbl

				local event_quest_requirement = var_30_24.event_quest_requirement

				if var_30_22 or not event_quest_requirement then
					flag_2 = get_interface:get_quest_key(event_quest_requirement)
				end

				if not flag_2 then
					local str = "button_illusion_" .. k_2

					if not UIAtlasHelper.has_texture_by_name(str) then
						str = "button_illusion_default"
					end

					if not var_30_22 then
						num = num + 1
					else
						str = "button_illusion_locked"
					end

					local var_30_27 = UIWidget.init(var_30_20)

					tbl_3[#tbl_3 + 1] = var_30_27

					local content = var_30_27.content

					content.skin_key = v_3
					content.icon_texture = str
					content.locked = not var_30_22
					content.rarity = k_2
					num_4 = num_4 + num_3 + num_2
					tbl_4[v_3] = true
				end
			end
		end
	end

	if not (not var_30_12 and tbl_4[var_30_12]) then
		local flag_3 = true
		local str_2 = "plentiful"
		local str_3 = "button_illusion_" .. str_2

		if not UIAtlasHelper.has_texture_by_name(str_3) then
			str_3 = "button_illusion_default"
		end

		local var_30_32 = UIWidget.init(var_30_20)

		tbl_3[#tbl_3 + 1] = var_30_32

		local content_2 = var_30_32.content

		content_2.skin_key = var_30_12
		content_2.icon_texture = str_3
		content_2.locked = not flag_3
		content_2.rarity = str_2
		num_4 = num_4 + num_3 + num_2
		num = num + 1
	end

	table.sort(tbl_3, fn_2)

	local num_5 = num_2 / 2

	for i_2, v_4 in ipairs(tbl_3) do
		v_4.offset[1] = -num_4 / 2 + num_5
		num_5 = num_5 + num_2 + num_3
	end

	self._illusion_widgets = tbl_3

	local get_interface_2 = Managers.backend:get_interface("items")
	local var_30_36 = get_interface_2:get_equipped_weapon_pose_skins()[gsub]
	local flag_4 = not var_30_36 and get_interface_2:get_weapon_skin_from_skin_key(var_30_36)
	local flag_5 = not flag_4 and get_interface_2:get_item_from_id(flag_4)
	local skin

	if not flag_5 then
		skin = flag_5.skin

		if not skin then
			-- Nothing
		end
	end

	skin = var_30_5.skin
	skin = skin or var_30_12

	::label_30_0::

	local flag_6 = true

	self:_select_illusion_by_key(skin, flag_6)

	self._widgets_by_name.illusions_counter.content.text = "(" .. tostring(num) .. "/" .. tostring(#tbl_3) .. ")"

	self:_start_transition_animation("animate_illusion_widgets")
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._back = function (self)
	-- function 31
	local var_31_0 = category_settings[self._current_category_index]
	local name = var_31_0.name
	local display_name = var_31_0.display_name

	self._item_grid:change_category(name)

	self._selected_blueprint_name = nil

	self:_play_sound("play_gui_equipment_inventory_next_click")
	self:_start_transition_animation("on_enter")

	if not Managers.input:is_device_active("mouse") then
		local _item_grid = self._item_grid
		local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

		_item_grid:set_item_selected(get_item_in_slot)
	end

	self:_show_equipped_weapon_pose()
	self:_clear_illusion_widgets()
	self._item_grid:mark_equipped_items(false)
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._change_item_filter = function (self, arg_32_1)
	-- function 32
	self._item_grid:change_item_filter(arg_32_1, true)
	self:_play_sound("play_gui_equipment_inventory_next_click")
	self:_start_transition_animation("on_enter")

	if not Managers.input:is_device_active("mouse") then
		local _item_grid = self._item_grid
		local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

		_item_grid:set_item_selected(get_item_in_slot)
	end

	self._item_grid:mark_equipped_items(true)
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_page_info = function (self)
	-- function 33
	local get_page_info, var_33_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_33_1 == self._total_pages) then
		self._total_pages = var_33_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_33_1 = var_33_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_33_1)
		_widgets_by_name.page_button_next.content.hotspot.disable_button = get_page_info == var_33_1
		_widgets_by_name.page_button_previous.content.hotspot.disable_button = get_page_info == 1
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_selected_cosmetic_slot_index = function (self)
	-- function 34
	local get_selected_cosmetic_slot_index = self._parent:get_selected_cosmetic_slot_index()

	if get_selected_cosmetic_slot_index ~= self._selected_cosmetic_slot_index then
		self._selected_cosmetic_slot_index = get_selected_cosmetic_slot_index

		self:_change_category_by_index(get_selected_cosmetic_slot_index)
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_loadout_sync = function (self)
	-- function 35
	local _item_grid = self._item_grid
	local loadout_sync_id = self._parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self._loadout_sync_id = loadout_sync_id

		_item_grid:update_items_status()
		self:_update_equipped_item_tooltip()
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._exit = function (self, arg_36_1)
	-- function 36
	self.exit = true
	self.exit_level_id = arg_36_1
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole.draw = function (self, arg_37_1)
	-- function 37
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local _input_service = self:_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	UIRenderer.begin_pass(_ui_top_renderer, ui_scenegraph, _input_service, arg_37_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	if not is_device_active and not self._gamepad_illusion_buttons_active then
		for i_2, v_2 in ipairs(self._illusion_widgets) do
			local alpha_multiplier_3 = v_2.alpha_multiplier

			alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_3

			UIRenderer.draw_widget(_ui_top_renderer, v_2)
		end

		for i_3, v_3 in ipairs(self._illusion_base_widgets) do
			local alpha_multiplier_4 = v_3.alpha_multiplier

			alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_4

			UIRenderer.draw_widget(_ui_top_renderer, v_3)
		end
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i_4, v_4 in ipairs(_active_node_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v_4)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active and not self._menu_input_description then
		self._menu_input_description:draw(_ui_top_renderer, arg_37_1)
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._play_sound = function (self, arg_38_1)
	-- function 38
	self._parent:play_sound(arg_38_1)
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._change_category_by_index = function (self, arg_39_1, arg_39_2)
	-- function 39
	if not arg_39_2 then
		arg_39_1 = self._current_category_index or 1
	end

	if self._current_category_index == arg_39_1 then
		return
	end

	self._current_category_index = arg_39_1

	local var_39_0 = category_settings[arg_39_1]
	local name = var_39_0.name
	local display_name = var_39_0.display_name

	self._item_grid:change_category(name)

	return true
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._setup_input_buttons = function (self)
	-- function 40
	local window_input_service = self._parent:window_input_service()
	local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str, true)
	local get_gamepad_input_texture_data_2 = UISettings.get_gamepad_input_texture_data(window_input_service, str_2, true)
	local _widgets_by_name = self._widgets_by_name
	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local texture_id = input_icon_next.style.texture_id

	texture_id.horizontal_alignment = "center"
	texture_id.vertical_alignment = "center"
	texture_id.texture_size = {
		get_gamepad_input_texture_data.size[1],
		get_gamepad_input_texture_data.size[2]
	}
	input_icon_next.content.texture_id = get_gamepad_input_texture_data.texture

	local texture_id_2 = input_icon_previous.style.texture_id

	texture_id_2.horizontal_alignment = "center"
	texture_id_2.vertical_alignment = "center"
	texture_id_2.texture_size = {
		get_gamepad_input_texture_data_2.size[1],
		get_gamepad_input_texture_data_2.size[2]
	}
	input_icon_previous.content.texture_id = get_gamepad_input_texture_data_2.texture
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._set_gamepad_input_buttons_visibility = function (self, arg_41_1)
	-- function 41
	local _widgets_by_name = self._widgets_by_name
	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local input_arrow_next = _widgets_by_name.input_arrow_next
	local input_arrow_previous = _widgets_by_name.input_arrow_previous

	input_icon_next.content.visible = arg_41_1
	input_icon_previous.content.visible = arg_41_1
	input_arrow_next.content.visible = arg_41_1
	input_arrow_previous.content.visible = arg_41_1
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole._handle_gamepad_activity = function (self)
	-- function 42
	local is_device_active = Managers.input:is_device_active("mouse")
	local flag = self.gamepad_active_last_frame == nil

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			local _item_grid = self._item_grid
			local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)
			local var_42_4 = _item_grid
			local set_item_selected = _item_grid.set_item_selected
			local _current_hovered_item = self._current_hovered_item

			_current_hovered_item = _current_hovered_item or get_item_in_slot

			set_item_selected(var_42_4, _current_hovered_item)
			self:_set_gamepad_input_buttons_visibility(true)
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		self._item_grid:set_item_selected(nil)
		self:_set_gamepad_input_buttons_visibility(false)

		self._gamepad_illusion_buttons_active = false
	end
end
