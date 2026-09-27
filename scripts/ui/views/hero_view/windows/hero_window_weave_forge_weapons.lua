-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_weave_forge_weapons.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_weapons_definitions")
local top_widgets = var_0_0.top_widgets
local bottom_widgets = var_0_0.bottom_widgets
local bottom_hdr_widgets = var_0_0.bottom_hdr_widgets
local top_hdr_widgets = var_0_0.top_hdr_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local create_weapon_entry_widget = var_0_0.create_weapon_entry_widget
local create_property_option = var_0_0.create_property_option
local create_trait_option = var_0_0.create_trait_option
local create_divider_option = var_0_0.create_divider_option
local create_item_block_option = var_0_0.create_item_block_option
local create_item_stamina_option = var_0_0.create_item_stamina_option
local create_item_ammunition_option = var_0_0.create_item_ammunition_option
local create_item_keywords_option = var_0_0.create_item_keywords_option
local create_item_overheat_option = var_0_0.create_item_overheat_option
local flag = false
local num = 10
local num_2 = 0.3
local num_3 = 1.6

HeroWindowWeaveForgeWeapons = class(HeroWindowWeaveForgeWeapons)
HeroWindowWeaveForgeWeapons.NAME = "HeroWindowWeaveForgeWeapons"

HeroWindowWeaveForgeWeapons.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowWeaveForgeWeapons")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._ingame_ui_context = ingame_ui_context
	self._animations = {}
	self._ui_animations = {}
	self._scrollbars = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	local hero_name = arg_1_1.hero_name
	local career_index = arg_1_1.career_index
	local profile_index = arg_1_1.profile_index

	self._career_name = SPProfiles[profile_index].careers[career_index].name
	self._hero_name = hero_name
	self._selected_slot_name = arg_1_1.selected_slot_name

	local local_player = Managers.player:local_player()
	local get_ui_onboarding_state = WeaveOnboardingUtils.get_ui_onboarding_state(ingame_ui_context.statistics_db, local_player:stats_id())

	self._crafting_tutorial = not WeaveOnboardingUtils.tutorial_completed(get_ui_onboarding_state, WeaveUITutorials.equip_weapon)

	self:_update_button_visibility()

	if not self._crafting_tutorial then
		local unlock_button = self._widgets_by_name.unlock_button

		unlock_button.content.highlighted = true
		self._ui_animations.unlock_button_pulse = UIAnimation.init(UIAnimation.pulse_animation, unlock_button.style.texture_highlight.color, 1, 100, 255, 2)
	end

	self:_setup_weapon_list()
	self:_sync_backend_loadout()
	Managers.state.event:trigger("weave_forge_weapons_entered")
end

HeroWindowWeaveForgeWeapons._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		parent = self._parent,
		render_settings = self._render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_2_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowWeaveForgeWeapons._setup_weapon_list = function (self)
	-- function 3
	local backend = Managers.backend
	local get_interface = backend:get_interface("items")
	local _selected_slot_name = self._selected_slot_name
	local _career_name = self._career_name
	local var_3_4 = CareerSettings[_career_name].item_slot_types_by_slot_name[_selected_slot_name]
	local tbl = {}

	for k, v in pairs(ItemMasterList) do
		if v.rarity == "magic" then
			local slot_type = v.slot_type

			if not table.contains(var_3_4, slot_type) then
				local can_wield = v.can_wield

				if not table.contains(can_wield, _career_name) then
					local required_unlock_item = v.required_unlock_item
					local get_item_from_key = get_interface:get_item_from_key(required_unlock_item)
					local get_item_from_key_2 = get_interface:get_item_from_key(k)

					if get_item_from_key or not get_item_from_key_2 then
						local flag = not get_item_from_key_2 and get_item_from_key_2.backend_id

						tbl[#tbl + 1] = {
							key = k,
							item_data = v,
							backend_id = flag
						}
					end
				end
			end
		end
	end

	if not self._crafting_tutorial then
		local get_interface_2 = backend:get_interface("weaves")

		for k_2 = #tbl, 1, -1 do
			local var_3_13 = tbl[k_2]
			local magic_item_cost = get_interface_2:magic_item_cost(var_3_13.key)

			if not (not magic_item_cost and not (magic_item_cost > 0)) then
				table.remove(tbl, k_2)
			end
		end
	end

	self:_populate_list(tbl)
end

HeroWindowWeaveForgeWeapons._setup_definitions = function (self)
	-- function 4
	if not self._parent:gamepad_style_active() then
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_weapons_console_definitions")
	else
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_weapons_definitions")
	end

	top_widgets = var_0_0.top_widgets
	bottom_widgets = var_0_0.bottom_widgets
	bottom_hdr_widgets = var_0_0.bottom_hdr_widgets
	top_hdr_widgets = var_0_0.top_hdr_widgets
	scenegraph_definition = var_0_0.scenegraph_definition
	animation_definitions = var_0_0.animation_definitions
	create_weapon_entry_widget = var_0_0.create_weapon_entry_widget
	create_property_option = var_0_0.create_property_option
	create_trait_option = var_0_0.create_trait_option
	create_divider_option = var_0_0.create_divider_option
	create_item_block_option = var_0_0.create_item_block_option
	create_item_stamina_option = var_0_0.create_item_stamina_option
	create_item_ammunition_option = var_0_0.create_item_ammunition_option
	create_item_keywords_option = var_0_0.create_item_keywords_option
	create_item_overheat_option = var_0_0.create_item_overheat_option
end

HeroWindowWeaveForgeWeapons.create_ui_elements = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_setup_definitions()

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}

	for k, v in pairs(top_widgets) do
		local var_5_5 = UIWidget.init(v)

		tbl[#tbl + 1] = var_5_5
		tbl_5[k] = var_5_5
	end

	for k_2, v_2 in pairs(bottom_widgets) do
		local var_5_6 = UIWidget.init(v_2)

		tbl_2[#tbl_2 + 1] = var_5_6
		tbl_5[k_2] = var_5_6
	end

	for k_3, v_3 in pairs(bottom_hdr_widgets) do
		local var_5_7 = UIWidget.init(v_3)

		tbl_4[#tbl_4 + 1] = var_5_7
		tbl_5[k_3] = var_5_7
	end

	for k_4, v_4 in pairs(top_hdr_widgets) do
		local var_5_8 = UIWidget.init(v_4)

		tbl_3[#tbl_3 + 1] = var_5_8
		tbl_5[k_4] = var_5_8
	end

	self._top_widgets = tbl
	self._bottom_widgets = tbl_2
	self._top_hdr_widgets = tbl_3
	self._bottom_hdr_widgets = tbl_4
	self._widgets_by_name = tbl_5
	tbl_5.upgrade_bg.alpha_multiplier = 0
	tbl_5.upgrade_text.alpha_multiplier = 0
	tbl_5.upgrade_effect.alpha_multiplier = 0
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_5_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_5_2[1]
		local_position[2] = local_position[2] + arg_5_2[2]
		local_position[3] = local_position[3] + arg_5_2[3]
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

HeroWindowWeaveForgeWeapons._initialize_viewports = function (self)
	-- function 6
	local selected_item = self._params.selected_item
	local _career_name = self._career_name
	local backend = Managers.backend
	local get_interface = backend:get_interface("weaves")
	local get_interface_2 = backend:get_interface("items")
	local _widgets_by_name = self._widgets_by_name
	local flag

	flag = selected_item ~= nil

	local str = "viewport"
	local _create_viewport_definition = self:_create_viewport_definition(str)
	local var_6_9 = UIWidget.init(_create_viewport_definition)
	local flag_2

	flag_2 = not selected_item and selected_item.backend_id

	local num = 0
	local num_2 = 0

	self._viewport_data = {
		widget = var_6_9,
		item = selected_item,
		equip_button = _widgets_by_name.equip_button,
		customize_button = _widgets_by_name.customize_button,
		unlock_button = _widgets_by_name.unlock_button,
		magic_level = num,
		power_level = num_2
	}

	local key = self._params.selected_item.data.key
	local _list_index_by_item_key = self:_list_index_by_item_key(key)

	self:_on_list_index_selected(_list_index_by_item_key)
end

HeroWindowWeaveForgeWeapons._create_item_previewer = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local data = arg_7_2.data
	local key = data.key

	key = key or arg_7_2.key

	local slot_type = data.slot_type
	local var_7_3 = arg_7_1.element.pass_data[1]
	local viewport = var_7_3.viewport
	local world = var_7_3.world
	local tbl = {
		0,
		2.5,
		0
	}
	local var_7_7
	local var_7_8
	local var_7_9
	local var_7_10
	local var_7_11
	local _career_name = self._career_name
	local var_7_13 = LootItemUnitPreviewer:new(arg_7_2, tbl, world, viewport, var_7_7, var_7_8, var_7_9, var_7_10, var_7_11, _career_name)
	local var_7_14 = callback(self, "cb_unit_spawned_item_preview", var_7_13, key, arg_7_3)

	var_7_13:register_spawn_callback(var_7_14)
	var_7_13:activate_auto_spin()

	return var_7_13
end

HeroWindowWeaveForgeWeapons.cb_unit_spawned_item_preview = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local flag = not arg_8_3

	arg_8_1:present_item(arg_8_2, flag)
end

HeroWindowWeaveForgeWeapons._create_viewport_definition = function (arg_9_0, arg_9_1)
	-- function 9
	local str = "environment/ui_weave_forge_preview"

	return {
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 840,
				viewport_type = "default_forward",
				enable_sub_gui = false,
				fov = 20,
				shading_environment = str,
				world_name = "weave_forge_item_preview_" .. arg_9_1,
				viewport_name = "weave_forge_item_preview_" .. arg_9_1,
				camera_position = {
					0,
					0,
					0
				},
				camera_lookat = {
					0,
					0,
					0
				}
			}
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		},
		scenegraph_id = arg_9_1
	}
end

HeroWindowWeaveForgeWeapons.on_exit = function (self, arg_10_1)
	-- function 10
	print("[HeroViewWindow] Exit Substate HeroWindowWeaveForgeWeapons")

	self._ui_animator = nil

	local _viewport_data = self._viewport_data

	if not _viewport_data then
		local _ui_renderer = self._ui_renderer
		local item_previewer = _viewport_data.item_previewer

		if not item_previewer then
			item_previewer:destroy()
		end

		local widget = _viewport_data.widget

		UIWidget.destroy(_ui_renderer, widget)

		self._viewport_data = nil
	end
end

HeroWindowWeaveForgeWeapons.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	local window_input_service = self._parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")
	local _viewport_data = self._viewport_data

	if not _viewport_data then
		local item_previewer = _viewport_data.item_previewer
		local widget = _viewport_data.widget

		if not item_previewer then
			local _is_button_hover = self:_is_button_hover(widget)
			local flag_2 = is_device_active or _is_button_hover

			item_previewer:update(arg_11_1, arg_11_2, not flag_2 and window_input_service)
		end
	end

	self:_update_animations(arg_11_1)
	self:_update_scrollbar_positions()

	if not self._viewport_data then
		self:_draw(arg_11_1)
	end

	local _unlock_item_done_time = self._unlock_item_done_time

	if not (not _unlock_item_done_time and not (_unlock_item_done_time < arg_11_2)) then
		local _unlock_item_response = self._unlock_item_response

		if _unlock_item_response ~= nil then
			self:_on_unlock_item_done(_unlock_item_response)

			self._unlock_item_done_time = nil
			self._unlock_item_response = nil
		end
	end
end

HeroWindowWeaveForgeWeapons._update_button_visibility = function (self)
	-- function 12
	local content = self._widgets_by_name.equip_button.content
	local content_2 = self._widgets_by_name.customize_button.content

	content.visible = not self._crafting_tutorial
	content_2.visible = not self._crafting_tutorial
end

HeroWindowWeaveForgeWeapons.post_update = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._viewport_data then
		self:_initialize_viewports()
	end

	local _viewport_data = self._viewport_data

	if not _viewport_data then
		local item_previewer = _viewport_data.item_previewer

		if not item_previewer then
			item_previewer:post_update(arg_13_1, arg_13_2)
		end

		self:_handle_input(arg_13_1, arg_13_2)
	end
end

HeroWindowWeaveForgeWeapons._update_animations = function (self, arg_14_1)
	-- function 14
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_14_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_14_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name
	local _viewport_data = self._viewport_data

	if not _viewport_data then
		local customize_button = _viewport_data.customize_button

		if not customize_button then
			UIWidgetUtils.animate_default_button(customize_button, arg_14_1)
		end

		local equip_button = _viewport_data.equip_button

		if not equip_button then
			UIWidgetUtils.animate_default_button(equip_button, arg_14_1)
		end

		local unlock_button = _viewport_data.unlock_button

		if not unlock_button then
			UIWidgetUtils.animate_default_button(unlock_button, arg_14_1)
		end
	end

	self:_update_item_pulse_animation(arg_14_1)
end

HeroWindowWeaveForgeWeapons._is_button_pressed = function (arg_15_0, arg_15_1)
	-- function 15
	local button_hotspot = arg_15_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		if not button_hotspot.is_selected then
			return true
		end
	end
end

HeroWindowWeaveForgeWeapons._is_button_hover = function (arg_16_0, arg_16_1)
	-- function 16
	return arg_16_1.content.button_hotspot.is_hover
end

HeroWindowWeaveForgeWeapons._is_button_hover_enter = function (arg_17_0, arg_17_1)
	-- function 17
	local button_hotspot = arg_17_1.content.button_hotspot
	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

HeroWindowWeaveForgeWeapons._is_button_hover_exit = function (arg_18_0, arg_18_1)
	-- function 18
	local button_hotspot = arg_18_1.content.button_hotspot
	local on_hover_exit = button_hotspot.on_hover_exit

	on_hover_exit = not on_hover_exit and not button_hotspot.is_selected

	return on_hover_exit
end

HeroWindowWeaveForgeWeapons._is_button_selected = function (arg_19_0, arg_19_1)
	-- function 19
	return arg_19_1.content.button_hotspot.is_selected
end

HeroWindowWeaveForgeWeapons._list_index_pressed = function (arg_20_0, arg_20_1)
	-- function 20
	for i, v in ipairs(arg_20_1) do
		local content = v.content
		local hotspot = content.hotspot

		hotspot = hotspot or content.button_hotspot

		if not hotspot and not hotspot.on_release then
			hotspot.on_release = false

			return i
		end
	end
end

HeroWindowWeaveForgeWeapons._is_list_hovered = function (arg_21_0, arg_21_1)
	-- function 21
	local is_hover = arg_21_1.content.hotspot.is_hover

	is_hover = is_hover or false

	return is_hover
end

HeroWindowWeaveForgeWeapons._sync_backend_loadout = function (self)
	-- function 22
	local backend = Managers.backend
	local get_interface = backend:get_interface("items")
	local get_interface_2 = backend:get_interface("weaves")
	local _career_name = self._career_name
	local get_interface_3 = Managers.backend:get_interface("weaves")
	local get_loadout_item_id = get_interface_3:get_loadout_item_id(_career_name, self._selected_slot_name)
	local max_magic_level = get_interface_3:max_magic_level()
	local list_widgets = self._scrollbars.weapons.list_widgets

	for i, v in ipairs(list_widgets) do
		local content = v.content
		local key = content.key
		local var_22_10

		if not self._crafting_tutorial then
			var_22_10 = get_interface:get_item_from_key(key)
		end

		local flag = not var_22_10 and var_22_10.backend_id
		local get_item_power_level

		if not flag then
			get_item_power_level = get_interface_3:get_item_power_level(flag)

			if not get_item_power_level then
				-- Nothing
			end
		end

		get_item_power_level = 0

		::label_22_0::

		local presentable_hero_power_level_weaves = UIUtils.presentable_hero_power_level_weaves(get_item_power_level)
		local get_item_magic_level

		if not flag then
			get_item_magic_level = get_interface_3:get_item_magic_level(flag)

			if not get_item_magic_level then
				-- Nothing
			end
		end

		get_item_magic_level = 0

		::label_22_1::

		content.locked = not flag
		content.backend_id = flag
		content.equipped = not flag and get_interface_3:has_loadout_item_id(_career_name, flag)

		local equipped = content.equipped

		equipped = not equipped and flag ~= get_loadout_item_id
		content.equipped_in_another_slot = equipped
		content.power_text = presentable_hero_power_level_weaves
		content.item_power = presentable_hero_power_level_weaves
		content.magic_level = get_item_magic_level
		content.level_progress = get_item_magic_level / max_magic_level
	end

	local flag_2 = self._selected_backend_id ~= nil
	local _selected_backend_id = self._selected_backend_id

	_selected_backend_id = not _selected_backend_id and get_interface_3:has_loadout_item_id(_career_name, self._selected_backend_id)

	self:_update_equip_button_status(flag_2, _selected_backend_id)
end

HeroWindowWeaveForgeWeapons._play_sound = function (self, arg_23_1)
	-- function 23
	self._parent:play_sound(arg_23_1)
end

HeroWindowWeaveForgeWeapons._handle_input = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local is_device_active = Managers.input:is_device_active("gamepad")
	local window_input_service = self._parent:window_input_service()
	local _scrollbars = self._scrollbars

	if not _scrollbars then
		for k, v in pairs(_scrollbars) do
			v.scrollbar_logic:update(arg_24_1, arg_24_2)
		end

		local weapons = _scrollbars.weapons

		if not weapons then
			local list_mask_widget = weapons.list_mask_widget
			local _is_list_hovered = self:_is_list_hovered(list_mask_widget)
			local list_widgets = weapons.list_widgets

			if not list_widgets and not _is_list_hovered then
				for i, v_2 in ipairs(list_widgets) do
					if not self:_is_button_hover_enter(v_2) then
						self:_play_sound("play_gui_equipment_button_hover")
					end
				end

				local _list_index_pressed = self:_list_index_pressed(list_widgets)

				if not (not _list_index_pressed and _list_index_pressed == self._selected_list_index) then
					self:_on_list_index_selected(_list_index_pressed)
					self:_play_sound("menu_magic_forge_select_weapon")
				end
			end

			self:_animate_weapon_lists_widgets(list_widgets, arg_24_1, _is_list_hovered)
		end
	end

	local _params = self._params
	local _viewport_data = self._viewport_data

	if not _viewport_data then
		local equip_button = _viewport_data.equip_button
		local customize_button = _viewport_data.customize_button
		local unlock_button = _viewport_data.unlock_button

		customize_button.content.button_hotspot.disable_button = self._selected_backend_id == nil

		if self:_is_button_hover_enter(equip_button) or self:_is_button_hover_enter(customize_button) or not self:_is_button_hover_enter(unlock_button) then
			self:_play_sound("Play_hud_hover")
		end

		if not self:_is_button_pressed(equip_button) and not self._selected_backend_id then
			self:_equip_item(self._selected_backend_id)
			self:_play_sound("menu_magic_forge_equip_weapon")
		elseif not self:_is_button_pressed(unlock_button) and not self._selected_item_id then
			self:_unlock_item(self._selected_item_id)
		elseif not self:_is_button_pressed(customize_button) then
			local item = _viewport_data.item

			if not item then
				_params.selected_item = item

				_parent:set_layout_by_name("weave_properties")
			end
		end
	end
end

HeroWindowWeaveForgeWeapons._on_list_index_selected = function (self, arg_25_1)
	-- function 25
	local list_widgets = self._scrollbars.weapons.list_widgets
	local flag = false

	for i, v in ipairs(list_widgets) do
		local content = v.content
		local key = content.key
		local backend_id = content.backend_id
		local button_hotspot = content.button_hotspot
		local flag_2 = i == arg_25_1

		button_hotspot.is_selected = flag_2

		if not flag_2 then
			flag = content.equipped
			self._selected_backend_id = self:_present_item(key)
			self._selected_item_id = key
		end
	end

	self._selected_list_index = arg_25_1

	local flag_3 = self._selected_backend_id ~= nil

	self:_update_equip_button_status(flag_3, flag)
end

HeroWindowWeaveForgeWeapons._update_equip_button_status = function (self, arg_26_1, arg_26_2)
	-- function 26
	local _viewport_data = self._viewport_data

	if not _viewport_data then
		local equip_button = _viewport_data.equip_button
		local flag = not arg_26_1 and not arg_26_2
		local var_26_3

		if not flag then
			var_26_3 = Localize("menu_weave_forge_equip_weapon_button")

			if not var_26_3 then
				-- Nothing
			end
		end

		var_26_3 = Localize("menu_weave_forge_equipped_weapon_button")

		::label_26_0::

		equip_button.content.button_hotspot.disable_button = not flag
		equip_button.content.title_text = var_26_3
	end
end

HeroWindowWeaveForgeWeapons._list_index_by_item_key = function (self, arg_27_1)
	-- function 27
	local list_widgets = self._scrollbars.weapons.list_widgets

	for i, v in ipairs(list_widgets) do
		if v.content.key == arg_27_1 then
			return i
		end
	end

	return 1
end

HeroWindowWeaveForgeWeapons._present_item = function (self, arg_28_1, arg_28_2)
	-- function 28
	local _viewport_data = self._viewport_data

	if not _viewport_data.item_previewer then
		_viewport_data.item_previewer:destroy()

		_viewport_data.item_previewer = nil
	end

	local backend = Managers.backend
	local get_interface = backend:get_interface("weaves")
	local get_interface_2 = backend:get_interface("items")
	local var_28_4

	if not self._crafting_tutorial then
		var_28_4 = get_interface_2:get_item_from_key(arg_28_1)
	end

	local var_28_5
	local flag = false

	if not var_28_4 then
		local clone = table.clone(ItemMasterList[arg_28_1])

		clone.key = arg_28_1
		var_28_5 = {
			data = clone,
			key = arg_28_1
		}
		flag = true
	end

	local widget = _viewport_data.widget

	_viewport_data.item_previewer = self:_create_item_previewer(widget, var_28_4 or var_28_5, arg_28_2)
	_viewport_data.item = var_28_4

	local num = 0
	local num_2 = 0
	local flag_2 = not var_28_4 and var_28_4.backend_id
	local str = ""
	local str_2 = ""

	if not var_28_4 then
		num = get_interface:get_item_magic_level(flag_2) or 0
		num_2 = var_28_4.power_level or 0
		num_2 = UIUtils.presentable_hero_power_level_weaves(num_2)

		local data = var_28_4.data

		str = Localize(data.display_name)
		str_2 = Localize(data.item_type)
	else
		local data_2 = var_28_5.data

		str = Localize(data_2.display_name)
		str_2 = Localize(data_2.item_type)
	end

	_viewport_data.magic_level = num
	_viewport_data.power_level = num_2

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.viewport_level_value.content.text = num
	_widgets_by_name.viewport_power_value.content.text = num_2
	_widgets_by_name.viewport_title.content.text = str
	_widgets_by_name.viewport_sub_title.content.text = str_2

	self:_set_presentation_locked_state(flag)

	self._selected_item_locked = flag

	self:_setup_weapon_stats(var_28_4 or var_28_5)

	if not var_28_4 then
		local get_essence = get_interface:get_essence()
		local magic_item_cost = get_interface:magic_item_cost(arg_28_1)
		local flag_3 = magic_item_cost <= get_essence

		self:_set_essence_upgrade_cost(magic_item_cost, flag_3)
	end

	return flag_2
end

HeroWindowWeaveForgeWeapons._set_presentation_locked_state = function (self, arg_29_1)
	-- function 29
	local _widgets_by_name = self._widgets_by_name
	local viewport_level_value = _widgets_by_name.viewport_level_value
	local viewport_level_title = _widgets_by_name.viewport_level_title

	viewport_level_value.content.visible = not arg_29_1
	viewport_level_title.content.visible = not arg_29_1

	local viewport_power_value = _widgets_by_name.viewport_power_value
	local viewport_power_title = _widgets_by_name.viewport_power_title

	viewport_power_value.content.visible = not arg_29_1
	viewport_power_title.content.visible = not arg_29_1

	local viewport_panel_divider = _widgets_by_name.viewport_panel_divider
	local viewport_panel_divider_left = _widgets_by_name.viewport_panel_divider_left
	local viewport_panel_divider_right = _widgets_by_name.viewport_panel_divider_right
	local unlock_button = _widgets_by_name.unlock_button

	viewport_panel_divider.content.visible = not arg_29_1
	viewport_panel_divider_left.content.visible = not arg_29_1
	viewport_panel_divider_right.content.visible = not arg_29_1
	unlock_button.content.visible = arg_29_1
end

HeroWindowWeaveForgeWeapons._set_essence_upgrade_cost = function (self, arg_30_1, arg_30_2)
	-- function 30
	local unlock_button = self._widgets_by_name.unlock_button
	local content = unlock_button.content
	local style = unlock_button.style
	local str = ""

	if not arg_30_1 then
		local comma_value = UIUtils.comma_value(arg_30_1)

		str = Localize("menu_weave_forge_unlock_weapon_button") .. " " .. comma_value
	else
		str = Localize("backend_err_playfab")
	end

	local _ui_top_renderer = self._ui_top_renderer
	local get_text_width = UIUtils.get_text_width(_ui_top_renderer, style.title_text, str)
	local var_30_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(content.price_icon).size[1]
	local num = 0
	local num_2 = -((var_30_7 + get_text_width + num) / 2 - (get_text_width / 2 + 5))

	style.title_text.offset[1] = style.title_text.default_offset[1] + num_2
	style.title_text_shadow.offset[1] = style.title_text_shadow.default_offset[1] + num_2
	style.title_text_disabled.offset[1] = style.title_text_disabled.default_offset[1] + num_2
	style.price_icon.offset[1] = num_2 + var_30_7 / 2 + get_text_width / 2 + num
	style.price_icon_disabled.offset[1] = style.price_icon.offset[1]
	style.price_icon.color[1] = 255
	style.price_icon_disabled.color[1] = 255
	content.button_hotspot.disable_button = not arg_30_1 and not arg_30_2
	content.title_text = str
end

HeroWindowWeaveForgeWeapons._unlock_item = function (self, arg_31_1)
	-- function 31
	self._params.upgrading = true

	self._parent:block_input()

	self._unlock_item_done_time = Managers.time:time("ui") + num_3
	self._unlock_item_response = nil

	local unlock_button = self._widgets_by_name.unlock_button

	unlock_button.content.upgrading = true
	unlock_button.content.button_hotspot.disable_button = true

	local var_31_1 = callback(self, "_unlock_item_cb")

	if not self._crafting_tutorial then
		var_31_1(true)

		local world = Managers.world:world("level_world")
		local current_level = LevelHelper:current_level(world)

		Level.trigger_event(current_level, "lua_keep_vom_magic_forge_tutorial_weapon_craft")
	else
		Managers.backend:get_interface("weaves"):buy_magic_item(arg_31_1, var_31_1)
	end
end

HeroWindowWeaveForgeWeapons._unlock_item_cb = function (self, arg_32_1)
	-- function 32
	self._unlock_item_response = arg_32_1

	if not self._crafting_tutorial then
		self._crafting_tutorial = false
		self._widgets_by_name.unlock_button.content.highlighted = false
		self._ui_animations.unlock_button_pulse = nil

		self:_update_button_visibility()
	end

	self:_setup_weapon_list()
end

HeroWindowWeaveForgeWeapons._on_unlock_item_done = function (self, arg_33_1)
	-- function 33
	local unlock_button = self._widgets_by_name.unlock_button

	unlock_button.content.upgrading = false
	unlock_button.content.button_hotspot.disable_button = false
	self._params.upgrading = nil

	self._parent:unblock_input()

	if not arg_33_1 then
		self:_play_sound("menu_magic_forge_unlock_weapon_for_crafting")

		if not self._selected_item_id then
			self._selected_backend_id = self:_present_item(self._selected_item_id)
		end

		Managers.state.event:trigger("weave_forge_item_unlocked")

		local str = "upgrade"
		local var_33_2 = self._animations[str]

		if not var_33_2 then
			self._ui_animator:stop_animation(var_33_2)

			self._animations[str] = nil
		end

		self:_start_transition_animation(str)
	end

	self:_sync_backend_loadout(arg_33_1)
end

HeroWindowWeaveForgeWeapons._equip_item = function (self, arg_34_1)
	-- function 34
	local _career_name = self._career_name

	Managers.backend:get_interface("weaves"):set_loadout_item(arg_34_1, _career_name, self._selected_slot_name)
	self:_sync_backend_loadout()

	self._equip_pulse_duration = num_2

	Managers.state.event:trigger("weave_forge_item_equpped")
end

HeroWindowWeaveForgeWeapons._update_item_pulse_animation = function (self, arg_35_1)
	-- function 35
	local _equip_pulse_duration = self._equip_pulse_duration

	if not _equip_pulse_duration then
		return
	end

	local max = math.max(_equip_pulse_duration - arg_35_1, 0)
	local num = 1 - max / num_2
	local _viewport_data = self._viewport_data

	if not _viewport_data then
		local item_previewer = _viewport_data.item_previewer

		if not item_previewer then
			local num_3 = 0.08 * math.ease_pulse(num)

			item_previewer:set_zoom_fraction(num_3)
		end
	end

	if num == 1 then
		self._equip_pulse_duration = nil
	else
		self._equip_pulse_duration = max
	end
end

HeroWindowWeaveForgeWeapons._draw = function (self, arg_36_1)
	-- function 36
	self:_update_visible_list_entries()

	local _parent = self._parent
	local get_ui_renderer = _parent:get_ui_renderer()
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = _parent:window_input_service()
	local _render_settings = self._render_settings
	local hdr_renderer = _parent:hdr_renderer()
	local hdr_top_renderer = _parent:hdr_top_renderer()
	local alpha_multiplier = _render_settings.alpha_multiplier
	local snap_pixel_positions = _render_settings.snap_pixel_positions

	UIRenderer.begin_pass(hdr_renderer, _ui_scenegraph, window_input_service, arg_36_1, nil, _render_settings)

	local snap_pixel_positions_2 = _render_settings.snap_pixel_positions

	for i, v in ipairs(self._bottom_hdr_widgets) do
		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(hdr_renderer, v)
	end

	UIRenderer.end_pass(hdr_renderer)
	UIRenderer.begin_pass(hdr_top_renderer, _ui_scenegraph, window_input_service, arg_36_1, nil, _render_settings)

	local snap_pixel_positions_3 = _render_settings.snap_pixel_positions

	for i_2, v_2 in ipairs(self._top_hdr_widgets) do
		local alpha_multiplier_3 = v_2.alpha_multiplier

		alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_3

		UIRenderer.draw_widget(hdr_top_renderer, v_2)
	end

	UIRenderer.end_pass(hdr_top_renderer)
	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_36_1, nil, _render_settings)

	for i_3, v_3 in ipairs(self._top_widgets) do
		local alpha_multiplier_4 = v_3.alpha_multiplier

		alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_4

		UIRenderer.draw_widget(_ui_top_renderer, v_3)
	end

	local _scrollbars = self._scrollbars

	if not _scrollbars then
		for k, v_4 in pairs(_scrollbars) do
			local list_widgets = v_4.list_widgets

			for i_4, v_5 in ipairs(list_widgets) do
				local alpha_multiplier_5 = v_5.alpha_multiplier

				alpha_multiplier_5 = alpha_multiplier_5 or alpha_multiplier
				_render_settings.alpha_multiplier = alpha_multiplier_5

				UIRenderer.draw_widget(_ui_top_renderer, v_5)
			end
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
	UIRenderer.begin_pass(get_ui_renderer, _ui_scenegraph, window_input_service, arg_36_1, nil, _render_settings)

	local _viewport_data = self._viewport_data

	if not _viewport_data then
		local widget = _viewport_data.widget
		local alpha_multiplier_6 = widget.alpha_multiplier

		alpha_multiplier_6 = alpha_multiplier_6 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_6

		UIRenderer.draw_widget(get_ui_renderer, widget)
	end

	for i_5, v_6 in ipairs(self._bottom_widgets) do
		local alpha_multiplier_7 = v_6.alpha_multiplier

		alpha_multiplier_7 = alpha_multiplier_7 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_7

		UIRenderer.draw_widget(get_ui_renderer, v_6)
	end

	UIRenderer.end_pass(get_ui_renderer)
end

local function fn(self, arg_37_1)
	-- function 37
	local content = self.content
	local content_2 = arg_37_1.content

	return content.magic_level > content_2.magic_level
end

HeroWindowWeaveForgeWeapons._populate_list = function (self, arg_38_1)
	-- function 38
	local str = "weapon_list_entry"
	local size = scenegraph_definition[str].size
	local tbl = {}
	local var_38_3 = create_weapon_entry_widget(str, size)
	local _ui_renderer = self._ui_renderer
	local get_interface = Managers.backend:get_interface("weaves")
	local count = #arg_38_1

	for i = 1, count do
		local var_38_7 = arg_38_1[i]
		local key = var_38_7.key
		local item_data = var_38_7.item_data
		local inventory_icon = item_data.inventory_icon
		local var_38_11 = Localize(item_data.item_type)
		local backend_id = var_38_7.backend_id
		local get_item_magic_level

		if not backend_id then
			get_item_magic_level = get_interface:get_item_magic_level(backend_id)

			if not get_item_magic_level then
				-- Nothing
			end
		end

		get_item_magic_level = 0

		::label_38_0::

		local var_38_14 = UIWidget.init(var_38_3)

		tbl[i] = var_38_14

		local content = var_38_14.content
		local title = var_38_14.style.title
		local num_2 = title.size[1] - 60

		content.title = UIRenderer.crop_text_width(_ui_renderer, var_38_11, num_2, title)
		content.level_title = Localize("menu_weave_forge_magic_level_title") .. ": " .. get_item_magic_level
		content.icon = inventory_icon
		content.key = key
		content.magic_level = get_item_magic_level
	end

	if count > 1 then
		table.sort(tbl, fn)
	end

	local var_38_18 = num
	local _align_list_widgets = self:_align_list_widgets(tbl, var_38_18)
	local weapon_list_scrollbar = self._widgets_by_name.weapon_list_scrollbar
	local str_2 = "weapon_list_window"
	local str_3 = "weapon_scroll_root"
	local _initialize_scrollbar = self:_initialize_scrollbar(weapon_list_scrollbar, _align_list_widgets, str_2, var_38_18)

	self._scrollbars.weapons = {
		total_height = _align_list_widgets,
		list_widgets = tbl,
		widget = weapon_list_scrollbar,
		scrollbar_logic = _initialize_scrollbar,
		spacing = var_38_18,
		root_scenegraph_id = str_3,
		list_scenegraph_id = str_2,
		list_mask_widget = self._widgets_by_name.weapon_list_mask
	}
end

HeroWindowWeaveForgeWeapons._align_list_widgets = function (arg_39_0, arg_39_1, arg_39_2)
	-- function 39
	local num = 0
	local count = #arg_39_1

	for i = 1, count do
		local var_39_2 = arg_39_1[i]
		local offset = var_39_2.offset
		local size = var_39_2.content.size

		var_39_2.default_offset = table.clone(offset)

		local var_39_5 = size[2]

		offset[2] = -num
		num = num + var_39_5

		if i ~= count then
			num = num + arg_39_2
		end
	end

	return num
end

HeroWindowWeaveForgeWeapons._initialize_scrollbar = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	local scenegraph_id = arg_40_1.scenegraph_id
	local var_40_1 = ScrollBarLogic:new(arg_40_1)
	local size = scenegraph_definition[arg_40_3].size
	local size_2 = scenegraph_definition[scenegraph_id].size
	local var_40_4 = size[2]
	local var_40_5 = size_2[2]
	local num = 220 + arg_40_4 * 1.5
	local num_2 = 1

	var_40_1:set_scrollbar_values(var_40_4, arg_40_2, var_40_5, num, num_2)
	var_40_1:set_scroll_percentage(0)

	return var_40_1
end

HeroWindowWeaveForgeWeapons._update_scrollbar_positions = function (self)
	-- function 41
	local _scrollbars = self._scrollbars

	if not _scrollbars then
		local _ui_scenegraph = self._ui_scenegraph

		for k, v in pairs(_scrollbars) do
			local scrollbar_logic = v.scrollbar_logic
			local root_scenegraph_id = v.root_scenegraph_id
			local scrolled_length = v.scrolled_length
			local get_scrolled_length = scrollbar_logic:get_scrolled_length()

			if get_scrolled_length ~= scrolled_length then
				_ui_scenegraph[root_scenegraph_id].local_position[2] = math.round(get_scrolled_length)
				v.scrolled_length = get_scrolled_length
			end
		end
	end
end

HeroWindowWeaveForgeWeapons._update_visible_list_entries = function (self)
	-- function 42
	local _scrollbars = self._scrollbars

	if not _scrollbars then
		local _ui_scenegraph = self._ui_scenegraph

		for k, v in pairs(_scrollbars) do
			local scrollbar_logic = v.scrollbar_logic

			if not scrollbar_logic:enabled() then
				local list_scenegraph_id = v.list_scenegraph_id
				local list_widgets = v.list_widgets
				local spacing = v.spacing
				local get_scrolled_length = scrollbar_logic:get_scrolled_length()
				local size = scenegraph_definition[list_scenegraph_id].size
				local num = spacing * 2
				local num_2 = size[2] + num

				for i, v_2 in ipairs(list_widgets) do
					local offset = v_2.offset
					local content = v_2.content
					local size_2 = content.size
					local num_3 = math.abs(offset[2]) + size_2[2]
					local flag = false

					if num_3 < get_scrolled_length - num then
						flag = true
					elseif num_2 < math.abs(offset[2]) - get_scrolled_length then
						flag = true
					end

					content.visible = not flag
				end
			end
		end
	end
end

HeroWindowWeaveForgeWeapons._get_scrollbar_percentage_by_index = function (self, arg_43_1, arg_43_2)
	-- function 43
	local var_43_0 = self._scrollbars[arg_43_1]
	local scrollbar_logic = var_43_0.scrollbar_logic

	if not scrollbar_logic:enabled() then
		local get_scroll_percentage = scrollbar_logic:get_scroll_percentage()
		local get_scrolled_length = scrollbar_logic:get_scrolled_length()
		local get_scroll_length = scrollbar_logic:get_scroll_length()
		local list_scenegraph_id = var_43_0.list_scenegraph_id
		local var_43_6 = scenegraph_definition[list_scenegraph_id].size[2]
		local var_43_7 = get_scrolled_length
		local num = var_43_7 + var_43_6
		local list_widgets = var_43_0.list_widgets

		if not list_widgets then
			local var_43_10 = list_widgets[arg_43_2]
			local content = var_43_10.content
			local offset = var_43_10.offset
			local var_43_13 = content.size[2]
			local abs = math.abs(offset[2])
			local num_2 = abs + var_43_13
			local num_3 = 0

			if num < num_2 then
				local num_4 = num_2 - num

				num_3 = math.clamp(num_4 / get_scroll_length, 0, 1)
			elseif abs < var_43_7 then
				local num_5 = var_43_7 - abs

				num_3 = -math.clamp(num_5 / get_scroll_length, 0, 1)
			end

			if not num_3 then
				return (math.clamp(get_scroll_percentage + num_3, 0, 1))
			end
		end
	end

	return 0
end

HeroWindowWeaveForgeWeapons._find_closest_neighbour = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local list_widgets = self._scrollbars[arg_44_1].list_widgets
	local var_44_1 = list_widgets[arg_44_3]
	local size = var_44_1.content.size
	local offset = var_44_1.offset
	local num = size[1] * 0.5 + offset[1]
	local huge = math.huge
	local var_44_6

	for k, v in pairs(arg_44_2) do
		local var_44_7 = list_widgets[v]
		local offset_2 = var_44_7.offset
		local num_2 = var_44_7.content.size[1] * 0.5 + offset_2[1]
		local abs = math.abs(num_2 - num)

		if abs < huge then
			huge = abs
			var_44_6 = v
		end
	end

	if not var_44_6 then
		return var_44_6
	end
end

HeroWindowWeaveForgeWeapons._animate_weapon_lists_widgets = function (self, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	for i, v in ipairs(arg_45_1) do
		self:_animate_list_widget(v, arg_45_2, arg_45_3)
	end
end

HeroWindowWeaveForgeWeapons._animate_list_widget = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local offset = arg_46_1.offset
	local content = arg_46_1.content
	local style = arg_46_1.style
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	local equipped_in_another_slot = content.equipped_in_another_slot
	local locked = content.locked
	local on_hover_enter = button_hotspot.on_hover_enter
	local is_hover = button_hotspot.is_hover

	if not (arg_46_3 == nil or arg_46_3) then
		is_hover = false
		on_hover_enter = false
	end

	local is_selected = button_hotspot.is_selected
	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_46_1

	::label_46_0::

	is_clicked = true

	::label_46_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local pulse_progress = button_hotspot.pulse_progress

	pulse_progress = pulse_progress or 1

	local offset_progress = button_hotspot.offset_progress

	offset_progress = offset_progress or 1

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local flag

	flag = is_hover or not is_selected or 14 or 8

	local num = 3
	local num_2 = 20
	local num_3 = 5

	if not is_clicked then
		input_progress = math.min(input_progress + arg_46_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_46_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not on_hover_enter then
		pulse_progress = 0
	end

	local min = math.min(pulse_progress + arg_46_2 * num, 1)
	local easeOutCubic_2 = math.easeOutCubic(min)
	local easeInCubic_2 = math.easeInCubic(min)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_46_2 * flag, 1)
	else
		hover_progress = math.max(hover_progress - arg_46_2 * flag, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(hover_progress)
	local easeInCubic_3 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_46_2 * flag, 1)
		offset_progress = math.min(offset_progress + arg_46_2 * num_3, 1)
	else
		selection_progress = math.max(selection_progress - arg_46_2 * flag, 0)
		offset_progress = math.max(offset_progress - arg_46_2 * num_3, 0)
	end

	local easeOutCubic_4 = math.easeOutCubic(selection_progress)
	local easeInCubic_4 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_4, easeOutCubic_3)
	local max_3 = math.max(easeInCubic_3, easeInCubic_4)
	local num_4 = 255 * max

	style.hover_frame.color[1] = num_4

	local title = style.title
	local text_color = title.text_color
	local default_text_color = title.default_text_color
	local hover_text_color = title.hover_text_color

	Colors.lerp_color_tables(default_text_color, hover_text_color, max, text_color)

	local level_title = style.level_title
	local text_color_2 = level_title.text_color
	local default_text_color_2 = level_title.default_text_color
	local hover_text_color_2 = level_title.hover_text_color

	Colors.lerp_color_tables(default_text_color_2, hover_text_color_2, max, text_color_2)

	local power_text = style.power_text
	local text_color_3 = power_text.text_color
	local default_text_color_3 = power_text.default_text_color
	local hover_text_color_3 = power_text.hover_text_color

	Colors.lerp_color_tables(default_text_color_3, hover_text_color_3, max, text_color_3)

	local num_5 = 255 - 255 * min

	style.pulse_frame.color[1] = num_5
	style.icon.saturated = equipped_in_another_slot or locked
	style.icon_background.saturated = equipped_in_another_slot or locked
	button_hotspot.offset_progress = offset_progress
	button_hotspot.pulse_progress = min
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

HeroWindowWeaveForgeWeapons._setup_weapon_stats = function (self, arg_47_1)
	-- function 47
	local _career_name = self._career_name
	local data = arg_47_1.data
	local flag = not arg_47_1 and arg_47_1.backend_id
	local get_item_template = BackendUtils.get_item_template(data, flag)
	local slot_type = data.slot_type
	local get_interface = Managers.backend:get_interface("weaves")
	local get_loadout_properties = get_interface:get_loadout_properties(_career_name, flag)
	local get_loadout_traits = get_interface:get_loadout_traits(_career_name, flag)
	local flag_2

	flag_2 = not not flag or get_interface:get_loadout_talents(_career_name)

	local num = 70
	local num_2 = 10
	local tbl = {}
	local tbl_2 = {
		0,
		num
	}
	local tbl_3 = {
		0,
		num
	}
	local num_3 = 10
	local _create_divider_option_entry = self:_create_divider_option_entry(tbl_2, Localize("menu_weave_forge_weapon_stats_title"))

	tbl[#tbl + 1] = _create_divider_option_entry
	_create_divider_option_entry.offset[2] = -num_2

	local num_4 = num_2 + num
	local tooltip_keywords = get_item_template.tooltip_keywords

	if not tooltip_keywords then
		local tbl_4 = {
			0,
			50
		}
		local str = ""
		local count = #tooltip_keywords

		for i, v in ipairs(tooltip_keywords) do
			str = str .. Localize(v)
			count = count - 1

			if count > 0 then
				str = str .. ", "
			end
		end

		local _create_item_keywords_option_entry = self:_create_item_keywords_option_entry(tbl_4, str)

		tbl[#tbl + 1] = _create_item_keywords_option_entry
		_create_item_keywords_option_entry.offset[2] = -num_4
		num_4 = num_4 + tbl_4[2] + num_3
	end

	if slot_type == ItemType.MELEE then
		local block_angle = get_item_template.block_angle

		if not block_angle then
			local degrees_to_radians = math.degrees_to_radians(block_angle)
			local _create_item_block_option_entry = self:_create_item_block_option_entry(tbl_3, degrees_to_radians)

			tbl[#tbl + 1] = _create_item_block_option_entry
			_create_item_block_option_entry.offset[2] = -num_4
			num_4 = num_4 + num + num_3
		end

		local max_fatigue_points = get_item_template.max_fatigue_points

		if not max_fatigue_points then
			local num_5 = max_fatigue_points / 2
			local _create_item_stamina_option_entry = self:_create_item_stamina_option_entry(tbl_3, num_5)

			tbl[#tbl + 1] = _create_item_stamina_option_entry
			_create_item_stamina_option_entry.offset[2] = -num_4
			num_4 = num_4 + num + num_3
		end
	end

	if slot_type == ItemType.RANGED then
		local ammo_data = get_item_template.ammo_data

		if not ammo_data then
			local single_clip = ammo_data.single_clip
			local reload_time = ammo_data.reload_time
			local max_ammo = ammo_data.max_ammo
			local ammo_per_clip = ammo_data.ammo_per_clip
			local hide_ammo_ui = ammo_data.hide_ammo_ui
			local var_47_34
			local var_47_35

			if not single_clip then
				var_47_34 = tostring(max_ammo) .. "/0"
			elseif not hide_ammo_ui then
				var_47_35 = Localize("menu_weave_forge_weapon_ammo_burn_description")
			else
				var_47_34 = tostring(ammo_per_clip) .. "/" .. tostring(max_ammo - ammo_per_clip)
			end

			local _create_item_ammunition_option_entry = self:_create_item_ammunition_option_entry(tbl_3, var_47_34)

			tbl[#tbl + 1] = _create_item_ammunition_option_entry
			_create_item_ammunition_option_entry.offset[2] = -num_4
			num_4 = num_4 + num + num_3

			if not hide_ammo_ui then
				_create_item_ammunition_option_entry.content.hide_ammo_ui = hide_ammo_ui
				_create_item_ammunition_option_entry.content.description_text = var_47_35
			end
		else
			local _create_item_overheat_option_entry = self:_create_item_overheat_option_entry(tbl_3)

			tbl[#tbl + 1] = _create_item_overheat_option_entry
			_create_item_overheat_option_entry.offset[2] = -num_4
			num_4 = num_4 + num + num_3
		end
	end

	if not get_loadout_traits then
		local num_6 = 0

		for k, v_2 in pairs(get_loadout_traits) do
			num_6 = num_6 + 1
		end

		if num_6 > 0 then
			local _create_divider_option_entry_2 = self:_create_divider_option_entry(tbl_2, Localize("menu_weave_forge_options_title_traits"))

			tbl[#tbl + 1] = _create_divider_option_entry_2
			_create_divider_option_entry_2.offset[2] = -num_4
			num_4 = num_4 + num
		end

		local tbl_5 = {
			0,
			num
		}

		for k_2, v_3 in pairs(get_loadout_traits) do
			local var_47_41 = WeaveTraits.traits[k_2]
			local icon = var_47_41.icon

			icon = icon or "icons_placeholder"

			local display_name = var_47_41.display_name
			local icon_2 = var_47_41.icon
			local var_47_45 = Localize(display_name)
			local str_2 = ""

			if not var_47_41.advanced_description then
				str_2 = UIUtils.get_trait_description(k_2, var_47_41)
			end

			local _create_trait_option_entry, var_47_48 = self:_create_trait_option_entry(tbl_5, var_47_45, str_2, icon)

			tbl[#tbl + 1] = _create_trait_option_entry
			_create_trait_option_entry.offset[2] = -num_4
			num_4 = num_4 + num + var_47_48
		end
	end

	if not get_loadout_properties then
		local num_7 = 0

		for k_3, v_4 in pairs(get_loadout_properties) do
			num_7 = num_7 + 1
		end

		if num_7 > 0 then
			local _create_divider_option_entry_3 = self:_create_divider_option_entry(tbl_2, Localize("menu_weave_forge_options_title_properties"))

			tbl[#tbl + 1] = _create_divider_option_entry_3
			_create_divider_option_entry_3.offset[2] = -num_4
			num_4 = num_4 + num
		end

		local tbl_6 = {}
		local tbl_7 = {
			0,
			num
		}

		for k_4, v_5 in pairs(get_loadout_properties) do
			local count_2 = #v_5
			local var_47_54 = WeaveProperties.properties[k_4]
			local get_property_mastery_costs = get_interface:get_property_mastery_costs(k_4)
			local get_weave_property_description = UIUtils.get_weave_property_description(k_4, var_47_54, get_property_mastery_costs, count_2)
			local find = string.find(get_weave_property_description, " ", 1)
			local sub = string.sub(get_weave_property_description, 1, find)
			local icon_3 = var_47_54.icon

			icon_3 = icon_3 or "icons_placeholder"

			local _create_property_option_entry = self:_create_property_option_entry(tbl_7, get_weave_property_description, sub, icon_3)

			tbl[#tbl + 1] = _create_property_option_entry
			_create_property_option_entry.offset[2] = -num_4
			num_4 = num_4 + num
		end
	end

	local stats_list_scrollbar = self._widgets_by_name.stats_list_scrollbar
	local str_3 = "stats_list_window"
	local str_4 = "stats_scroll_root"
	local num_8 = 0
	local _initialize_scrollbar = self:_initialize_scrollbar(stats_list_scrollbar, num_4, str_3, num_8)

	self._scrollbars.stats = {
		total_height = num_4,
		list_widgets = tbl,
		widget = stats_list_scrollbar,
		scrollbar_logic = _initialize_scrollbar,
		spacing = num_8,
		root_scenegraph_id = str_4,
		list_scenegraph_id = str_3,
		list_mask_widget = self._widgets_by_name.stats_list_mask
	}
end

HeroWindowWeaveForgeWeapons._create_item_keywords_option_entry = function (self, arg_48_1, arg_48_2)
	-- function 48
	local flag = true
	local _ui_renderer = self._ui_renderer
	local str = "stat_option"
	local var_48_3 = create_item_keywords_option(arg_48_1, str, flag, arg_48_2)
	local var_48_4 = UIWidget.init(var_48_3)
	local content = var_48_4.content
	local text = var_48_4.style.text

	return var_48_4
end

HeroWindowWeaveForgeWeapons._create_item_overheat_option_entry = function (self, arg_49_1)
	-- function 49
	local flag = true
	local _ui_renderer = self._ui_renderer
	local str = "stat_option"
	local var_49_3 = create_item_overheat_option(arg_49_1, str, flag)

	return (UIWidget.init(var_49_3))
end

HeroWindowWeaveForgeWeapons._create_item_ammunition_option_entry = function (self, arg_50_1, arg_50_2)
	-- function 50
	local flag = true
	local _ui_renderer = self._ui_renderer
	local str = "stat_option"
	local var_50_3 = create_item_ammunition_option(arg_50_1, str, flag, arg_50_2)

	return (UIWidget.init(var_50_3))
end

HeroWindowWeaveForgeWeapons._create_item_stamina_option_entry = function (self, arg_51_1, arg_51_2)
	-- function 51
	local flag = true
	local _ui_renderer = self._ui_renderer
	local str = "stat_option"
	local var_51_3 = create_item_stamina_option(arg_51_1, str, flag, arg_51_2)

	return (UIWidget.init(var_51_3))
end

HeroWindowWeaveForgeWeapons._create_item_block_option_entry = function (self, arg_52_1, arg_52_2)
	-- function 52
	print("_create_item_block_option_entry", arg_52_2)

	local flag = true
	local _ui_renderer = self._ui_renderer
	local str = "stat_option"
	local var_52_3 = create_item_block_option(arg_52_1, str, flag, arg_52_2)

	return (UIWidget.init(var_52_3))
end

HeroWindowWeaveForgeWeapons._create_divider_option_entry = function (self, arg_53_1, arg_53_2)
	-- function 53
	local flag = true
	local _ui_renderer = self._ui_renderer
	local str = "stat_option"
	local var_53_3 = create_divider_option(arg_53_1, str, flag, arg_53_2)
	local var_53_4 = UIWidget.init(var_53_3)
	local content = var_53_4.content
	local text = var_53_4.style.text

	return var_53_4
end

HeroWindowWeaveForgeWeapons._create_trait_option_entry = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	-- function 54
	local flag = true
	local _ui_renderer = self._ui_renderer
	local str = "stat_option"
	local var_54_3 = create_trait_option(arg_54_1, str, flag, arg_54_2, arg_54_3, arg_54_4)
	local var_54_4 = UIWidget.init(var_54_3)
	local content = var_54_4.content
	local style = var_54_4.style
	local text = style.text
	local description_text = style.description_text
	local size = description_text.size
	local floor = math.floor(UIUtils.get_text_height(_ui_renderer, size, description_text, arg_54_3))
	local floor_2 = math.floor(floor)

	return var_54_4, floor_2
end

HeroWindowWeaveForgeWeapons._create_property_option_entry = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	local flag = true
	local str = "stat_option"
	local var_55_2 = arg_55_2
	local var_55_3 = create_property_option(arg_55_1, str, flag, var_55_2, arg_55_4)
	local var_55_4 = UIWidget.init(var_55_3)
	local style = var_55_4.style
	local color_override_table = style.text.color_override_table
	local length = Utf8.length(arg_55_2)

	length = length or 0

	local length_2 = Utf8.length(arg_55_3)
	local text = style.text

	if not text then
		local color_override_table_2 = text.color_override_table

		color_override_table_2.start_index = length_2
		color_override_table_2.end_index = length
		text.color_override[1] = color_override_table_2
	end

	return var_55_4
end
