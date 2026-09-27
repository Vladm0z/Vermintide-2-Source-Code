-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_item_customization.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_item_customization_definitions")
local scenegraph_definition = var_0_3.scenegraph_definition
local animation_definitions = var_0_3.animation_definitions
local widgets = var_0_3.widgets
local crafting_widgets = var_0_3.crafting_widgets
local info_widgets = var_0_3.info_widgets
local weapon_illusion_base_widgets = var_0_3.weapon_illusion_base_widgets
local trait_reroll_widgets = var_0_3.trait_reroll_widgets
local upgrade_widgets = var_0_3.upgrade_widgets
local property_reroll_widgets = var_0_3.property_reroll_widgets
local viewport_widget = var_0_3.viewport_widget
local create_property_option = var_0_3.create_property_option
local create_trait_option = var_0_3.create_trait_option
local create_illusion_button = var_0_3.create_illusion_button
local background_rect = var_0_3.background_rect
local generic_input_actions = var_0_3.generic_input_actions
local tbl = {
	item_setting = {
		setup_function = "_state_setup_overview",
		craft_complete_func_name = "_apply_weapon_skin_craft_complete",
		gamepad_input_func = "_update_skin_gamepad_input",
		transition_time = 0.3,
		fov = 30,
		draw_function = "_state_draw_overview",
		camera_position = {
			0,
			0,
			0
		}
	},
	item_properties = {
		setup_function = "_state_setup_property_reroll",
		craft_complete_func_name = "_state_setup_property_reroll",
		transition_time = 0.3,
		fov = 30,
		draw_function = "_state_draw_property_reroll",
		camera_position = {
			0,
			-1,
			0
		},
		recipe_by_slot_type = {
			trinket = "reroll_jewellery_properties",
			ranged = "reroll_weapon_properties",
			necklace = "reroll_jewellery_properties",
			ring = "reroll_jewellery_properties",
			melee = "reroll_weapon_properties"
		}
	},
	item_trait = {
		setup_function = "_state_setup_trait_reroll",
		craft_complete_func_name = "_state_setup_trait_reroll",
		transition_time = 0.3,
		fov = 30,
		draw_function = "_state_draw_trait_reroll",
		camera_position = {
			0,
			-1,
			0
		},
		recipe_by_slot_type = {
			trinket = "reroll_jewellery_traits",
			ranged = "reroll_weapon_traits",
			necklace = "reroll_jewellery_traits",
			ring = "reroll_jewellery_traits",
			melee = "reroll_weapon_traits"
		}
	},
	item_upgrade = {
		setup_function = "_state_setup_upgrade",
		craft_complete_func_name = "_upgrade_item_craft_complete",
		transition_time = 0.3,
		fov = 30,
		draw_function = "_state_draw_upgrade",
		camera_position = {
			0,
			-1,
			0
		},
		recipe_by_rarity = {
			common = "upgrade_item_rarity_rare",
			plentiful = "upgrade_item_rarity_common",
			rare = "upgrade_item_rarity_exotic",
			exotic = "upgrade_item_rarity_unique"
		}
	}
}

HeroWindowItemCustomization = class(HeroWindowItemCustomization)
HeroWindowItemCustomization.NAME = "HeroWindowItemCustomization"

HeroWindowItemCustomization.on_enter = function (self, arg_1_1)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowItemCustomization")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._career_index = arg_1_1.career_index
	self._profile_index = arg_1_1.profile_index
	self._career_name = SPProfiles[self._profile_index].careers[self._career_index].name
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._state_render_settings = {
		alpha_multiplier = 0
	}
	self._animations = {}
	self._ui_animations = {}
	self._animation_callbacks = {}
	self._craft_progress = 0

	local item_to_customize = arg_1_1.item_to_customize

	self._item_backend_id = item_to_customize.backend_id

	self:_create_ui_elements()
	self:_setup_menu_input_description()
	self:_present_item(item_to_customize)
	self:_find_equipment_slot()
	self:_setup_availble_states(item_to_customize)
	self:_option_selected(1, true)
	self:_start_transition_animation("on_enter")
end

HeroWindowItemCustomization._setup_menu_input_description = function (self)
	-- function 2
	local num = UILayer.default + 300
	local window_input_service = self._parent:window_input_service()

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, window_input_service, 5, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
end

HeroWindowItemCustomization._find_equipment_slot = function (self)
	-- function 3
	local get_interface = Managers.backend:get_interface("items")
	local var_3_1

	for k, v in pairs(InventorySettings.equipment_slots) do
		var_3_1 = v.name

		if get_interface:get_loadout_item_id(self._career_name, var_3_1) == self._item_backend_id then
			break
		end
	end

	if not var_3_1 then
		local slot_type = self:_get_item(self._item_backend_id).data.slot_type

		var_3_1 = InventorySettings.slot_names_by_type[slot_type][1]
	end

	self._equipment_slot_name = var_3_1
end

HeroWindowItemCustomization._setup_availble_states = function (self, arg_4_1)
	-- function 4
	local data = arg_4_1.data
	local rarity = arg_4_1.rarity

	if not rarity then
		rarity = data.rarity
		rarity = rarity or "default"
	end

	local item_rarity_order = UISettings.item_rarity_order
	local var_4_3 = item_rarity_order[rarity]

	var_4_3 = var_4_3 or item_rarity_order.default

	if not (rarity == "default" or rarity ~= "promo") then
		self._available_states = {
			"item_setting"
		}
	elseif var_4_3 <= item_rarity_order.unique then
		self._available_states = {
			"item_setting",
			"item_properties",
			"item_trait"
		}
	elseif var_4_3 <= item_rarity_order.exotic then
		self._available_states = {
			"item_setting",
			"item_properties",
			"item_trait",
			"item_upgrade"
		}
	elseif var_4_3 <= item_rarity_order.common then
		self._available_states = {
			"item_setting",
			"item_properties",
			"item_upgrade"
		}
	elseif var_4_3 <= item_rarity_order.plentiful then
		self._available_states = {
			"item_setting",
			"item_upgrade"
		}
	end

	self._states = {}

	local _widgets_by_name = self._widgets_by_name

	for k, v in pairs(tbl) do
		local find = table.find(self._available_states, k)

		if not find then
			self._states[k] = tbl[k]
		end

		_widgets_by_name[k].content.visible = find
	end

	if not (not self._state and self._states[self._state]) then
		local var_4_6 = self._widgets_by_name[self._state]

		var_4_6.content.button_hotspot.is_selected = false
		var_4_6.style.hover_frame.saturated = false

		self:_option_selected(1, true)
	end
end

HeroWindowItemCustomization._set_camera_position = function (self, arg_5_1)
	-- function 5
	local viewport = self._preview_widget.element.pass_data[1].viewport
	local camera = ScriptViewport.camera(viewport)

	ScriptCamera.set_local_position(camera, arg_5_1)
end

HeroWindowItemCustomization._camera_position = function (self)
	-- function 6
	local viewport = self._preview_widget.element.pass_data[1].viewport
	local camera = ScriptViewport.camera(viewport)

	return ScriptCamera.position(camera)
end

HeroWindowItemCustomization._set_camera_fov = function (self, arg_7_1)
	-- function 7
	local viewport = self._preview_widget.element.pass_data[1].viewport
	local camera = ScriptViewport.camera(viewport)

	Camera.set_vertical_fov(camera, math.pi * arg_7_1 / 180)
end

HeroWindowItemCustomization._camera_fov = function (self)
	-- function 8
	local viewport = self._preview_widget.element.pass_data[1].viewport
	local camera = ScriptViewport.camera(viewport)
	local vertical_fov = Camera.vertical_fov(camera)

	return math.floor(vertical_fov * 180 / math.pi)
end

HeroWindowItemCustomization._change_state = function (self, arg_9_1)
	-- function 9
	if not (self._state == arg_9_1) then
		local var_9_0 = self._states[arg_9_1]

		fassert(var_9_0, "[HeroWindowItemCustomization:_change_state] There is no state called %s", tostring(arg_9_1))

		self._state = arg_9_1

		local setup_function = var_9_0.setup_function

		if not setup_function then
			self[setup_function](self)
		end

		self._state_render_settings.alpha_multiplier = 0
	end

	self._state_start_fov = self:_camera_fov()

	local _camera_position = self:_camera_position()

	self._state_start_camera_position = {
		_camera_position.x,
		_camera_position.y,
		_camera_position.z
	}
	self._state_transition_timer = 0

	if not self._skin_dirty then
		local _get_item = self:_get_item(self._item_backend_id)

		self:_present_item(_get_item, true)

		self._skin_dirty = nil
	end
end

HeroWindowItemCustomization._get_item = function (self, arg_10_1)
	-- function 10
	self._item_backend_id = arg_10_1

	return Managers.backend:get_interface("items"):get_item_from_id(arg_10_1)
end

HeroWindowItemCustomization._start_transition_animation = function (self, arg_11_1)
	-- function 11
	local tbl = {
		render_settings = self._render_settings,
		state_render_settings = self._state_render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_11_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_11_1] = start_animation
end

HeroWindowItemCustomization._create_ui_elements = function (self)
	-- function 12
	if not self._preview_widget then
		UIWidget.destroy(self._ui_top_renderer, self._preview_widget)

		self._preview_widget = nil
	end

	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self._ui_scenegraph = init_scenegraph
	self._background_widget = UIWidget.init(background_rect)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_12_3 = UIWidget.init(v, self._ui_top_renderer)

		tbl[#tbl + 1] = var_12_3
		tbl_2[k] = var_12_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}

	for k_2, v_2 in pairs(crafting_widgets) do
		local var_12_5 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_12_5
		self._widgets_by_name[k_2] = var_12_5
	end

	self._crafting_widgets = tbl_3

	self:_create_preview_widget()
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)
end

HeroWindowItemCustomization._create_preview_widget = function (self)
	-- function 13
	local _create_item_preview_widget_definition = self:_create_item_preview_widget_definition()

	self._preview_widget = UIWidget.init(_create_item_preview_widget_definition)

	self:_register_object_sets(self._preview_widget, _create_item_preview_widget_definition)
end

HeroWindowItemCustomization._create_item_preview_widget_definition = function (arg_14_0)
	-- function 14
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "viewport",
			style_id = "viewport"
		},
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		}
	}
	local tbl_3 = {
		activated = true,
		button_hotspot = {}
	}
	local tbl_4 = {
		viewport = {
			viewport_type = "default_forward",
			layer = 962,
			shading_environment = "environment/ui_store_preview",
			viewport_name = "item_preview",
			level_name = "levels/ui_store_preview/world",
			enable_sub_gui = true,
			fov = 65,
			world_name = "item_preview",
			object_sets = LevelResource.object_set_names("levels/ui_store_preview/world"),
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
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = "item_preview"

	return tbl
end

HeroWindowItemCustomization.on_exit = function (self, arg_15_1)
	-- function 15
	print("[HeroViewWindow] Exit Substate HeroWindowItemCustomization")

	self._ui_animator = nil

	if not self._previewer then
		self._previewer:destroy()
	end

	if not self._preview_widget then
		UIWidget.destroy(self._ui_top_renderer, self._preview_widget)
	end

	if not self._character_dirty then
		self._parent:update_skin_sync()
	end
end

HeroWindowItemCustomization.play_sound = function (self, arg_16_1)
	-- function 16
	self._parent:play_sound(arg_16_1)
end

HeroWindowItemCustomization.update = function (self, arg_17_1, arg_17_2)
	-- function 17
	self:_handle_gamepad_activity()
	self:_update_craft_response()

	if not self._item_dirty then
		self:_update_item_rarity()
		self:_update_property_option()
		self:_update_trait_option()
		self:_update_upgrade_option()

		self._item_dirty = false
	end

	self:_update_active_preview()
	self:_update_animations(arg_17_1)

	local window_input_service = self._parent:window_input_service()

	self:_handle_gamepad_input(window_input_service, arg_17_1, arg_17_2)
	self:_handle_input(window_input_service, arg_17_1, arg_17_2)

	if not self._previewer then
		self._previewer:update(arg_17_1, arg_17_2, window_input_service)
	end

	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic then
		_scrollbar_logic:update(arg_17_1, arg_17_2)
	end

	self:_update_scroll_position()
	self:_draw(window_input_service, arg_17_1)
end

HeroWindowItemCustomization.post_update = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not self._previewer then
		self._previewer:post_update(arg_18_1, arg_18_2)
	end
end

HeroWindowItemCustomization._register_object_sets = function (self, arg_19_1, arg_19_2)
	-- function 19
	local viewport = arg_19_2.style.viewport
	local content = arg_19_1.content
	local var_19_2 = arg_19_1.element.pass_data[1]
	local level_name = viewport.level_name
	local tbl = {}
	local object_set_names = LevelResource.object_set_names(level_name)

	for i, v in ipairs(object_set_names) do
		tbl[v] = {
			set_enabled = true,
			units = LevelResource.unit_indices_in_object_set(level_name, v)
		}
	end

	content.object_set_data = {
		world = var_19_2.world,
		level = var_19_2.level,
		object_sets = tbl,
		level_name = level_name
	}

	self:_show_object_set(nil, true)
end

HeroWindowItemCustomization._show_object_set = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._preview_widget then
		print("[StoreWindowItemPreview:show_object_set] Viewport not initiated")

		return
	end

	local object_set_data = self._preview_widget.content.object_set_data
	local world = object_set_data.world
	local level = object_set_data.level
	local level_name = object_set_data.level_name
	local object_sets = object_set_data.object_sets

	if not (object_sets[arg_20_1] or arg_20_2) then
		print(string.format("[StoreWindowItemPreview:show_object_set] No object set called %q in level %q", arg_20_1, level_name))

		return
	end

	for k, v in pairs(object_sets) do
		local set_enabled = v.set_enabled

		if not (not set_enabled and k == arg_20_1) then
			local units = v.units

			for i, v_2 in ipairs(units) do
				local unit_by_index = Level.unit_by_index(level, v_2)

				Unit.set_unit_visibility(unit_by_index, false)
			end

			v.set_enabled = false
		elseif not (set_enabled or k ~= arg_20_1) then
			local units_2 = v.units

			for i_2, v_3 in ipairs(units_2) do
				local unit_by_index_2 = Level.unit_by_index(level, v_3)

				Unit.set_unit_visibility(unit_by_index_2, true)

				if not Unit.has_data(unit_by_index_2, "LevelEditor", "is_gizmo_unit") then
					local get_data = Unit.get_data(unit_by_index_2, "LevelEditor", "is_gizmo_unit")
					local is_a = Unit.is_a(unit_by_index_2, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe")

					if not (not get_data and is_a) then
						Unit.flow_event(unit_by_index_2, "hide_helper_mesh")
					end
				end
			end

			v.set_enabled = true
		end
	end
end

HeroWindowItemCustomization._update_environment = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not self._preview_widget then
		return
	end

	local flag = arg_21_1 or "default"
	local world = self._preview_widget.content.object_set_data.world
	local get_data = World.get_data(world, "shading_settings")
	local flag_2

	flag_2 = not arg_21_2 and "default" and flag
	get_data[1] = flag_2
end

HeroWindowItemCustomization._is_button_hover = function (arg_22_0, arg_22_1)
	-- function 22
	return arg_22_1.content.button_hotspot.is_hover
end

HeroWindowItemCustomization._is_button_hover_enter = function (arg_23_0, arg_23_1)
	-- function 23
	return arg_23_1.content.button_hotspot.on_hover_enter
end

HeroWindowItemCustomization._is_button_pressed = function (arg_24_0, arg_24_1)
	-- function 24
	local button_hotspot = arg_24_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowItemCustomization._navigation_menu_disabled = function (self)
	-- function 25
	return self._mission_selection_grid ~= nil
end

HeroWindowItemCustomization._handle_gamepad_input = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local _parent = self._parent
	local flag = false
	local _navigation_menu_disabled = self:_navigation_menu_disabled()
	local _widgets_by_name = self._widgets_by_name

	if not _navigation_menu_disabled then
		local gamepad_input_func = self._states[self._state].gamepad_input_func

		if not gamepad_input_func then
			flag = self[gamepad_input_func](self, arg_26_1, arg_26_2, arg_26_3)
		end

		if not flag then
			local get = arg_26_1:get("move_up_hold_continuous")
			local get_2 = arg_26_1:get("move_down_hold_continuous")
			local _input_index = self._input_index

			_input_index = _input_index or 1

			if not get_2 then
				_input_index = math.min(_input_index + 1, #self._available_states)
			elseif not get then
				_input_index = math.max(_input_index - 1, 1)
			end

			if _input_index ~= self._input_index then
				self:_handle_new_selection(_input_index)
				self:_option_selected(self._input_index)

				flag = true
			end

			local weapon_diagram = self._info_widgets_by_name.weapon_diagram

			if not weapon_diagram then
				weapon_diagram.content.show_info = not not flag or arg_26_1:get("trigger_cycle_previous_hold")
			end

			if not self._material_items and not self._current_recipe_name and not self._has_all_crafting_requirements then
				local craft_button = _widgets_by_name.craft_button
				local experience_bar = _widgets_by_name.experience_bar
				local _craft_progress = self._craft_progress

				if not craft_button.content.visible then
					local num = 2

					if not UIUtils.is_button_held(craft_button) then
						if arg_26_1:get("refresh_hold") or not arg_26_1:get("skip") then
							_craft_progress = math.clamp(_craft_progress + arg_26_2 * num, 0, 1)
						else
							_craft_progress = math.max(_craft_progress - arg_26_2 * num, 0)
						end
					end

					local easeOutCubic = math.easeOutCubic(_craft_progress)

					self._ui_scenegraph.experience_bar.size[1] = 390 * easeOutCubic
					experience_bar.content.texture_id.uvs[2][1] = easeOutCubic
					experience_bar.content.visible = true

					if _craft_progress >= 1 then
						self:_craft(self._material_items, self._current_recipe_name)

						_craft_progress = 0
					end

					self._craft_progress = _craft_progress
				end
			end
		end
	end
end

HeroWindowItemCustomization._handle_input = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local _parent = self._parent
	local flag = false
	local _widgets_by_name = self._widgets_by_name
	local var_27_3

	for i = 1, #self._available_states do
		local var_27_4 = _widgets_by_name[self._available_states[i]]

		if var_27_4.content.button_hotspot.is_selected or not self:_is_button_hover_enter(var_27_4) then
			self:play_sound("Play_hud_hover")
		end

		if not self:_is_button_hover(var_27_4) then
			var_27_3 = i
		end

		if not self:_is_button_pressed(var_27_4) then
			self:_option_selected(i)

			local flag_2 = true
		end
	end

	local _get_item = self:_get_item(self._item_backend_id)
	local key = _get_item.key
	local var_27_8 = WeaponSkins.default_skins[key]
	local skin = _get_item.skin
	local _illusion_widgets = self._illusion_widgets
	local content = self._weapon_illusion_base_widgets_by_name.illusions_name.content
	local var_27_12
	local var_27_13

	for j = 1, #_illusion_widgets do
		local var_27_14 = _illusion_widgets[j]

		if not UIUtils.is_button_hover(var_27_14) then
			var_27_13 = var_27_14.content.skin_key
		elseif not UIUtils.is_button_selected(var_27_14) then
			var_27_12 = var_27_14.content.skin_key
		end
	end

	local flag_3 = var_27_13 or var_27_12 or skin or var_27_8
	local flag_4 = not flag_3 and WeaponSkins.skins[flag_3]
	local var_27_17

	if not flag_4 then
		var_27_17 = Localize(flag_4.display_name)

		if not var_27_17 then
			-- Nothing
		end
	end

	var_27_17 = ""

	::label_27_0::

	content.text = var_27_17

	if not self._material_items and not self._current_recipe_name then
		local craft_button = _widgets_by_name.craft_button
		local experience_bar = _widgets_by_name.experience_bar
		local _craft_progress = self._craft_progress
		local num = 2

		if not (arg_27_1:get("refresh_hold") or arg_27_1:get("skip")) then
			if not UIUtils.is_button_held(craft_button) then
				_craft_progress = math.clamp(_craft_progress + arg_27_2 * num, 0, 1)

				if not self._playing_craft_sound then
					self:_play_sound("play_gui_craft_forge_button_begin_qol")

					self._playing_craft_sound = true
				end
			else
				_craft_progress = math.max(_craft_progress - arg_27_2 * num, 0)

				if not (not self._playing_craft_sound and self._waiting_for_craft) then
					self:_play_sound("play_gui_craft_forge_button_aborted_qol")

					self._playing_craft_sound = false
				end
			end
		end

		local easeOutCubic = math.easeOutCubic(_craft_progress)

		self._ui_scenegraph.experience_bar.size[1] = 390 * easeOutCubic
		experience_bar.content.texture_id.uvs[2][1] = easeOutCubic
		experience_bar.content.visible = true

		if _craft_progress >= 1 then
			self:_craft(self._material_items, self._current_recipe_name)

			_craft_progress = 0
		end

		self._craft_progress = _craft_progress
	end

	self._hover_index = var_27_3
end

HeroWindowItemCustomization._update_active_preview = function (self)
	-- function 28
	local _active_selection_index = self._active_selection_index

	if not _active_selection_index then
		_active_selection_index = self._hover_index
		_active_selection_index = _active_selection_index or self._input_index
	end

	self._active_selector_preview = self._available_states[_active_selection_index]
end

HeroWindowItemCustomization._option_selected = function (self, arg_29_1, arg_29_2)
	-- function 29
	local _parent = self._parent
	local var_29_1 = self._available_states[arg_29_1]
	local flag = false
	local flag_2 = not arg_29_1 and self._active_selection_index == arg_29_1

	if not arg_29_2 then
		self:play_sound("Play_hud_select")
	end

	if not flag_2 then
		flag = true

		self:_change_state(var_29_1)
	end

	local is_device_active = Managers.input:is_device_active("mouse")
	local _active_selection_index = self._active_selection_index

	self._active_selection_index = not flag and arg_29_1

	local _widgets_by_name = self._widgets_by_name

	for i = 1, #self._available_states do
		_widgets_by_name[self._available_states[i]].style.hover_frame.saturated = not flag and arg_29_1 == i and not not is_device_active or i == _active_selection_index
	end

	if not flag then
		self:_handle_new_selection(self._active_selection_index)
	elseif not (not self._input_index and Managers.input:is_device_active("gamepad")) then
		self:_handle_new_selection(nil)
	end
end

HeroWindowItemCustomization._setting_option_pressed = function (arg_30_0, arg_30_1)
	-- function 30
	local content = arg_30_1.content
	local num_options = content.num_options

	for i = 1, num_options do
		local var_30_2 = content["button_hotspot_" .. i]

		if var_30_2.on_release or not var_30_2.is_selected then
			return content["option_key_" .. i], var_30_2.marked
		end
	end
end

HeroWindowItemCustomization._set_setting_option_selected = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local content = arg_31_1.content
	local num_options = content.num_options

	if not num_options then
		for i = 1, num_options do
			content["button_hotspot_" .. i].is_selected = arg_31_3 or i == arg_31_2
		end
	end
end

HeroWindowItemCustomization._handle_new_selection = function (self, arg_32_1)
	-- function 32
	local count = #self._available_states

	arg_32_1 = not arg_32_1 and math.clamp(arg_32_1, 1, count)

	local is_device_active = Managers.input:is_device_active("mouse")
	local _widgets_by_name = self._widgets_by_name

	for i = 1, #self._available_states do
		local var_32_3 = _widgets_by_name[self._available_states[i]]
		local flag = i == arg_32_1

		var_32_3.content.button_hotspot.is_selected = flag or i == self._active_selection_index

		if not is_device_active then
			var_32_3.style.hover_frame.saturated = not flag
		end

		self:_set_setting_option_selected(var_32_3, not flag and 1, flag)
	end

	if not (not arg_32_1 and self._input_index == arg_32_1) then
		self:play_sound("Play_hud_hover")
	end

	self._input_index = arg_32_1
end

HeroWindowItemCustomization._update_animations = function (self, arg_33_1)
	-- function 33
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_33_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _ui_animations = self._ui_animations
	local _animation_callbacks = self._animation_callbacks

	for k_2, v_2 in pairs(_ui_animations) do
		UIAnimation.update(v_2, arg_33_1)

		if not UIAnimation.completed(v_2) then
			_ui_animations[k_2] = nil

			if not _animation_callbacks[k_2] then
				_animation_callbacks[k_2]()

				_animation_callbacks[k_2] = nil
			end
		end
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.craft_button, arg_33_1)
	UIWidgetUtils.animate_game_option_button(_widgets_by_name.item_setting, arg_33_1)
	UIWidgetUtils.animate_game_option_button(_widgets_by_name.item_properties, arg_33_1)
	UIWidgetUtils.animate_game_option_button(_widgets_by_name.item_trait, arg_33_1)
	UIWidgetUtils.animate_game_option_button(_widgets_by_name.item_upgrade, arg_33_1)
	self:_animate_state_transition(arg_33_1)
end

HeroWindowItemCustomization._animate_state_transition = function (self, arg_34_1)
	-- function 34
	local _state_transition_timer = self._state_transition_timer

	if not _state_transition_timer then
		return
	end

	local _state = self._state
	local var_34_2 = self._states[_state]
	local transition_time = var_34_2.transition_time
	local num = _state_transition_timer + arg_34_1
	local clamp = math.clamp(num / transition_time, 0, 1)
	local smoothstep = math.smoothstep(clamp, 0, 1)
	local _state_start_fov = self._state_start_fov

	if not _state_start_fov then
		local num_2 = _state_start_fov + (var_34_2.fov - self._state_start_fov) * smoothstep

		self:_set_camera_fov(num_2)
	end

	local _state_start_camera_position = self._state_start_camera_position

	if not _state_start_camera_position then
		local camera_position = var_34_2.camera_position
		local var_34_11

		if not camera_position then
			var_34_11 = camera_position[1]

			if not var_34_11 then
				-- Nothing
			end
		end

		var_34_11 = 0

		do
			local var_34_12
		end

		::label_34_0::

		if not camera_position then
			var_34_12 = camera_position[2]

			if not var_34_12 then
				-- Nothing
			end
		end

		var_34_12 = 0

		do
			local var_34_13
		end

		::label_34_1::

		if not camera_position then
			var_34_13 = camera_position[3]

			if not var_34_13 then
				-- Nothing
			end
		end

		var_34_13 = 0

		::label_34_2::

		local var_34_14 = _state_start_camera_position[1]
		local var_34_15 = _state_start_camera_position[2]
		local var_34_16 = _state_start_camera_position[3]
		local num_3 = var_34_11 - var_34_14
		local num_4 = var_34_12 - var_34_15
		local num_5 = var_34_13 - var_34_16
		local num_6 = var_34_14 + num_3 * smoothstep
		local num_7 = var_34_15 + num_4 * smoothstep
		local num_8 = var_34_16 + num_5 * smoothstep

		if not (num_3 ~= 0 or num_4 ~= 0 or num_5 == 0) then
			local var_34_23 = Vector3(num_6, num_7, num_8)

			self:_set_camera_position(var_34_23)
		end
	end

	self._state_render_settings.alpha_multiplier = math.max(smoothstep, self._state_render_settings.alpha_multiplier)

	if clamp == 1 then
		self._state_transition_timer = nil
	else
		self._state_transition_timer = num
	end
end

HeroWindowItemCustomization._draw = function (self, arg_35_1, arg_35_2)
	-- function 35
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local var_35_4
	local is_device_active = Managers.input:is_device_active("gamepad")
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, arg_35_1, arg_35_2, var_35_4, _render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_35_8 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_35_8)
	end

	local _state = self._state

	if not _state then
		local var_35_10 = self._states[_state]

		if not var_35_10.draw_function then
			local alpha_multiplier_2 = self._state_render_settings.alpha_multiplier

			alpha_multiplier_2 = alpha_multiplier_2 or 0
			_render_settings.alpha_multiplier = alpha_multiplier_2

			self[var_35_10.draw_function](self, _ui_top_renderer, arg_35_2)

			_render_settings.alpha_multiplier = alpha_multiplier
		end
	end

	local alpha_multiplier_3 = self._state_render_settings.alpha_multiplier

	alpha_multiplier_3 = alpha_multiplier_3 or 0
	_render_settings.alpha_multiplier = alpha_multiplier_3

	for i_2, v in ipairs(self._crafting_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	_render_settings.alpha_multiplier = alpha_multiplier

	if not self._previewer then
		UIRenderer.draw_widget(_ui_top_renderer, self._preview_widget)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier

	if not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_35_2)
	end
end

HeroWindowItemCustomization._state_draw_overview = function (self, arg_36_1, arg_36_2)
	-- function 36
	local _info_widgets = self._info_widgets

	if not _info_widgets then
		for i, v in ipairs(_info_widgets) do
			UIRenderer.draw_widget(arg_36_1, v)
		end
	end

	local _illusion_widgets = self._illusion_widgets

	if not (not _illusion_widgets and not (#_illusion_widgets > 0)) then
		local _weapon_illusion_base_widgets = self._weapon_illusion_base_widgets

		for i_2, v_2 in ipairs(_weapon_illusion_base_widgets) do
			UIRenderer.draw_widget(arg_36_1, v_2)
		end

		for i_3, v_3 in ipairs(_illusion_widgets) do
			UIRenderer.draw_widget(arg_36_1, v_3)
		end

		local _illusion_widgets_2 = self._illusion_widgets

		for i_4, v_4 in ipairs(_illusion_widgets_2) do
			if not self:_is_button_pressed(v_4) then
				self:_on_illusion_index_pressed(i_4)

				break
			elseif not self:_is_button_hover_enter(v_4) then
				self:_play_sound("play_gui_equipment_inventory_hover")
			end
		end
	end
end

HeroWindowItemCustomization._state_draw_property_reroll = function (self, arg_37_1, arg_37_2)
	-- function 37
	local _property_reroll_widgets = self._property_reroll_widgets

	if not _property_reroll_widgets then
		for i, v in ipairs(_property_reroll_widgets) do
			UIRenderer.draw_widget(arg_37_1, v)
		end

		local _property_reroll_option_widgets = self._property_reroll_option_widgets

		if not _property_reroll_option_widgets then
			for i_2, v_2 in ipairs(_property_reroll_option_widgets) do
				UIRenderer.draw_widget(arg_37_1, v_2)
			end
		end

		local _material_widgets = self._material_widgets

		if not _material_widgets then
			for i_3, v_3 in ipairs(_material_widgets) do
				UIRenderer.draw_widget(arg_37_1, v_3)
			end
		end
	end
end

HeroWindowItemCustomization._handle_gamepad_activity = function (self)
	-- function 38
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			local _widgets_by_name = self._widgets_by_name

			if not self._input_index then
				local _input_index = self._input_index

				_input_index = _input_index or 1
				self._input_index = _input_index

				self:_handle_new_selection(self._input_index)
			end
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		local _widgets_by_name_2 = self._widgets_by_name

		if not self._active_selection_index then
			self:_handle_new_selection(nil)
		end
	end
end

HeroWindowItemCustomization._update_item_rarity = function (self)
	-- function 39
	local _get_item = self:_get_item(self._item_backend_id)
	local data = _get_item.data
	local rarity = _get_item.rarity

	rarity = rarity or data.rarity

	local _widgets_by_name = self._widgets_by_name
	local texture_id = _widgets_by_name.rarity_display.content.texture_id
	local num = 0
	local var_39_6 = UISettings.item_rarity_order[rarity]
	local item_rarities = UISettings.item_rarities
	local index_of = table.index_of(item_rarities, rarity)

	for i = 1, #item_rarities do
		local var_39_9 = item_rarities[i]
		local var_39_10
		local flag

		flag = not (index_of < i) or not "item_tier_empty" or "item_tier_" .. var_39_9

		if not UIAtlasHelper.has_texture_by_name(flag) then
			num = num + 1
			texture_id[num] = flag
		end
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(rarity, 255)
	local item_setting = _widgets_by_name.item_setting
	local content = item_setting.content
	local input_text = item_setting.style.input_text
	local num_2 = 0.8
	local tbl = {
		255,
		math.floor(get_color_table_with_alpha[2] * num_2),
		math.floor(get_color_table_with_alpha[3] * num_2),
		math.floor(get_color_table_with_alpha[4] * num_2)
	}

	input_text.text_color = tbl
	input_text.default_text_color = tbl
	input_text.select_text_color = get_color_table_with_alpha
end

HeroWindowItemCustomization._update_property_option = function (self)
	-- function 40
	local properties = self:_get_item(self._item_backend_id).properties

	if not properties then
		local content = self._widgets_by_name.item_properties.content
		local num = 0

		for k, v in pairs(properties) do
			num = num + 1

			local buff_name = WeaponProperties.properties[k].buff_name
			local flag

			flag = BuffUtils.get_buff_template(buff_name).buffs[1].variable_multiplier ~= nil

			local get_property_description, var_40_6 = UIUtils.get_property_description(k, v)
			local str = "button_hotspot_" .. num
			local str_2 = "option_text_" .. num

			content[str].disable_button = false
			content[str_2] = get_property_description
		end
	end
end

HeroWindowItemCustomization._update_upgrade_option = function (self)
	-- function 41
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _get_item = self:_get_item(self._item_backend_id)
	local data = _get_item.data
	local rarity = _get_item.rarity

	rarity = rarity or data.rarity

	local item_upgrade = self._widgets_by_name.item_upgrade
	local scenegraph_id = item_upgrade.scenegraph_id
	local size = scenegraph_definition[scenegraph_id].size
	local var_41_8 = size[2]
	local content = item_upgrade.content
	local style = item_upgrade.style
	local str = ""
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("plentiful", 255)
	local tbl = {}

	if rarity == "plentiful" then
		local var_41_14 = Localize("forge_screen_common_token_tooltip")

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("common", 255)
		tbl[1] = "icon_add_property"
	elseif rarity == "common" then
		local var_41_15 = Localize("forge_screen_rare_token_tooltip")

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("rare", 255)
		tbl[1] = "icon_add_property"
	elseif rarity == "rare" then
		local var_41_16 = Localize("forge_screen_exotic_token_tooltip")

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("exotic", 255)
		tbl[1] = "icon_add_trait"
	elseif rarity == "exotic" then
		tbl[1] = "icon_upgrade_property"
		tbl[2] = "icon_upgrade_property"

		local var_41_17 = Localize("difficulty_veteran")

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("unique", 255)
	end

	local var_41_18 = Localize("upgrade_description_text_" .. rarity)

	content.sub_title = var_41_18
	content.locked = rarity == "unique" or rarity == "default"

	local upper

	if rarity == "unique" then
		upper = string.upper(Localize("menu_weave_forge_upgrade_loadout_button_cap"))

		if not upper then
			-- Nothing
		end
	end

	upper = Localize("search_filter_locked")

	::label_41_0::

	content.input_text_locked = upper

	if not get_color_table_with_alpha then
		local num = 0.8
		local sub_title = style.sub_title
		local tbl_2 = {
			255,
			math.floor(get_color_table_with_alpha[1] * num),
			math.floor(get_color_table_with_alpha[2] * num),
			math.floor(get_color_table_with_alpha[3] * num)
		}

		sub_title.text_color = get_color_table_with_alpha
		sub_title.default_text_color = tbl_2
		sub_title.select_text_color = tbl_2
	end

	local sub_title_2 = style.sub_title
	local num_2 = var_41_8 + (math.floor(UIUtils.get_text_height(_ui_top_renderer, size, sub_title_2, var_41_18)) + 50)

	style.title_text.size[2] = num_2
	style.title_text_shadow.size[2] = num_2
	style.input_text.size[2] = num_2
	style.input_text_shadow.size[2] = num_2
	style.input_text_locked.size[2] = num_2
	style.input_text_locked_shadow.size[2] = num_2
	style.sub_title.size[2] = num_2
	style.sub_title_shadow.size[2] = num_2
	_ui_scenegraph[scenegraph_id].size[2] = num_2
end

HeroWindowItemCustomization._update_trait_option = function (self)
	-- function 42
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local traits = self:_get_item(self._item_backend_id).traits
	local item_trait = self._widgets_by_name.item_trait
	local scenegraph_id = item_trait.scenegraph_id
	local size = scenegraph_definition[scenegraph_id].size
	local var_42_6 = size[2]

	if not traits then
		local content = item_trait.content
		local style = item_trait.style

		for i, v in ipairs(traits) do
			local var_42_9 = WeaponTraits.traits[v]
			local display_name = var_42_9.display_name
			local advanced_description = var_42_9.advanced_description
			local icon = var_42_9.icon
			local var_42_13 = Localize(display_name)
			local get_trait_description = UIUtils.get_trait_description(v)

			content.icon_texture = icon
			content.input_text = var_42_13
			content.sub_title = get_trait_description
			content.locked = false

			local sub_title = style.sub_title

			var_42_6 = var_42_6 + math.floor(UIUtils.get_text_height(_ui_top_renderer, size, sub_title, get_trait_description))

			if var_42_6 ~= content.size[2] then
				-- Nothing
			end

			style.title_text.size[2] = var_42_6
			style.title_text_shadow.size[2] = var_42_6
			style.input_text.size[2] = var_42_6
			style.input_text_shadow.size[2] = var_42_6
			style.sub_title.size[2] = var_42_6
			style.sub_title_shadow.size[2] = var_42_6
		end
	end

	local size_2 = _ui_scenegraph[scenegraph_id].size
	local local_position = _ui_scenegraph[scenegraph_id].local_position

	size_2[2] = var_42_6
	local_position[2] = -var_42_6
end

HeroWindowItemCustomization._present_item = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	self._item_dirty = true

	self:_spawn_item_unit(arg_43_1, arg_43_2, arg_43_3)

	local get_ui_information_from_item, var_43_1, var_43_2, var_43_3 = UIUtils.get_ui_information_from_item(arg_43_1)
	local data = arg_43_1.data
	local item_type = data.item_type
	local slot_type = data.slot_type
	local backend_id = arg_43_1.backend_id
	local get_item_template = BackendUtils.get_item_template(data, backend_id)
	local rarity = arg_43_1.rarity

	rarity = rarity or data.rarity

	local power_level = arg_43_1.power_level
	local flag = false

	if not (rarity == "plentiful" or rarity == "common" or rarity == "rare" or rarity ~= "exotic") then
		local flag_2 = true
	end

	local var_43_13 = UISettings.item_rarity_textures[rarity]
	local content = self._widgets_by_name.item_setting.content

	content.input_text = Localize(var_43_1)
	content.sub_title = Localize(slot_type)
	content.icon_texture = get_ui_information_from_item or "icons_placeholder"
	content.icon_bg = var_43_13 or "icons_placeholder"
	content.item = arg_43_1

	local item_preview_object_set_name = data.item_preview_object_set_name

	item_preview_object_set_name = item_preview_object_set_name or "flow_weapon_lights"

	local item_preview_environment = data.item_preview_environment

	item_preview_environment = item_preview_environment or "weapons_default_01"

	self:_show_object_set(item_preview_object_set_name)
	self:_update_environment(item_preview_environment)
end

HeroWindowItemCustomization._spawn_item_unit = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	if not self._previewer then
		self._previewer:destroy()
	end

	local data = arg_44_1.data
	local key = arg_44_1.key

	key = key or data.key

	local var_44_2 = self._preview_widget.element.pass_data[1]
	local viewport = var_44_2.viewport
	local world = var_44_2.world
	local flag = arg_44_3 or {
		0,
		1,
		0
	}
	local var_44_6
	local var_44_7
	local var_44_8
	local var_44_9
	local var_44_10
	local _career_name = self._career_name
	local var_44_12 = LootItemUnitPreviewer:new(arg_44_1, flag, world, viewport, var_44_6, var_44_7, var_44_8, var_44_9, var_44_10, _career_name)
	local var_44_13 = callback(self, "cb_on_item_loaded", key, arg_44_2)

	var_44_12:register_spawn_callback(var_44_13)

	self._previewer = var_44_12
end

HeroWindowItemCustomization.cb_on_item_loaded = function (self, arg_45_1, arg_45_2)
	-- function 45
	print("cb_on_item_loaded", arg_45_1)
	self._previewer:present_item(arg_45_1, arg_45_2)
end

HeroWindowItemCustomization._select_illusion_by_key = function (self, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	if not arg_46_1 then
		return
	end

	local _illusion_widgets = self._illusion_widgets

	for i, v in ipairs(_illusion_widgets) do
		if v.content.skin_key == arg_46_1 then
			self:_on_illusion_index_pressed(i, arg_46_2, arg_46_3)

			break
		end
	end
end

HeroWindowItemCustomization._on_illusion_index_pressed = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	local content = self._illusion_widgets[arg_47_1].content
	local skin_key = content.skin_key

	self._skin_dirty = false

	if not arg_47_2 then
		local locked = content.locked
		local var_47_3 = ItemMasterList[skin_key]
		local tbl = {
			data = var_47_3,
			skin = skin_key
		}

		self:_spawn_item_unit(tbl, true)
		table.clear(self._material_items)

		if not locked then
			local _get_item = self:_get_item(self._item_backend_id)
			local key = _get_item.key
			local var_47_7 = WeaponSkins.default_skins[key]
			local skin = _get_item.skin

			skin = skin or var_47_7

			if skin_key ~= skin then
				local get_weapon_skin_from_skin_key, var_47_10 = Managers.backend:get_interface("items"):get_weapon_skin_from_skin_key(skin_key)

				self._material_items[#self._material_items + 1] = get_weapon_skin_from_skin_key

				self:_enable_craft_button(true, true)

				self._skin_dirty = true
			else
				self:_enable_craft_button(false)
			end
		else
			self:_enable_craft_button(false)
		end
	end

	local _weapon_illusion_base_widgets_by_name = self._weapon_illusion_base_widgets_by_name
	local var_47_12 = WeaponSkins.skins[skin_key]

	_weapon_illusion_base_widgets_by_name.illusions_name.content.text = Localize(var_47_12.display_name)

	local _illusion_widgets = self._illusion_widgets

	for i, v in ipairs(_illusion_widgets) do
		local flag = i == arg_47_1
		local content_2 = v.content

		content_2.button_hotspot.is_selected = flag

		if not arg_47_3 then
			content_2.equipped = flag
		end
	end

	self._selected_skin_index = arg_47_1

	self:_play_sound("play_gui_equipment_equip")
end

local function fn(self, arg_48_1)
	-- function 48
	local skins = WeaponSkins.skins
	local item_rarity_order = UISettings.item_rarity_order
	local content = self.content
	local content_2 = arg_48_1.content
	local rarity = content.rarity
	local rarity_2 = content_2.rarity
	local var_48_6 = item_rarity_order[rarity]

	var_48_6 = var_48_6 or 0

	local var_48_7 = item_rarity_order[rarity_2]

	var_48_7 = var_48_7 or 0

	return var_48_7 < var_48_6
end

local tbl_2 = {}

HeroWindowItemCustomization._setup_illusions = function (self, arg_49_1)
	-- function 49
	local key = arg_49_1.key
	local data = arg_49_1.data
	local num = 0
	local skin_combination_table = data.skin_combination_table
	local var_49_4 = WeaponSkins.skin_combinations[skin_combination_table]

	var_49_4 = var_49_4 or tbl_2

	local get_interface = Managers.backend:get_interface("quests")
	local get_unlocked_weapon_skins = Managers.backend:get_interface("crafting"):get_unlocked_weapon_skins()
	local gsub = string.gsub(arg_49_1.ItemId, "^vs_", "")
	local var_49_8 = WeaponSkins.default_skins[gsub]
	local var_49_9
	local num_2 = 51
	local num_3 = -5
	local num_4 = -num_3
	local tbl = {}
	local tbl_3 = {}
	local RaritySettings = RaritySettings
	local var_49_16 = create_illusion_button()

	for k, v in pairs(var_49_4) do
		for i, v_2 in ipairs(v) do
			if not tbl_3[v_2] then
				if not RaritySettings[k] then
					local var_49_17 = WeaponSkins.skins[v_2]

					k = not var_49_17 and var_49_17.rarity and k
				end

				local var_49_18 = get_unlocked_weapon_skins[v_2]

				var_49_18 = var_49_18 or v_2 == var_49_8

				local flag = true
				local var_49_20 = ItemMasterList[v_2]

				var_49_20 = var_49_20 or tbl_2

				local event_quest_requirement = var_49_20.event_quest_requirement

				if var_49_18 or not event_quest_requirement then
					flag = get_interface:get_quest_key(event_quest_requirement)
				end

				if not flag then
					local str = "button_illusion_" .. k

					if not UIAtlasHelper.has_texture_by_name(str) then
						str = "button_illusion_default"
					end

					if not var_49_18 then
						num = num + 1
					else
						str = "button_illusion_locked"
					end

					local var_49_23 = UIWidget.init(var_49_16)

					tbl[#tbl + 1] = var_49_23

					local content = var_49_23.content

					content.skin_key = v_2
					content.icon_texture = str
					content.locked = not var_49_18
					content.rarity = k
					num_4 = num_4 + num_3 + num_2
					tbl_3[v_2] = true
				end
			end
		end
	end

	if not (not var_49_8 and tbl_3[var_49_8]) then
		local flag_2 = true
		local str_2 = "plentiful"
		local str_3 = "button_illusion_" .. str_2

		if not UIAtlasHelper.has_texture_by_name(str_3) then
			str_3 = "button_illusion_default"
		end

		local var_49_28 = UIWidget.init(var_49_16)

		tbl[#tbl + 1] = var_49_28

		local content_2 = var_49_28.content

		content_2.skin_key = var_49_8
		content_2.icon_texture = str_3
		content_2.locked = not flag_2
		content_2.rarity = str_2
		num_4 = num_4 + num_3 + num_2
		num = num + 1
	end

	table.sort(tbl, fn)

	local num_5 = num_2 / 2

	for i_2, v_3 in ipairs(tbl) do
		v_3.offset[1] = -num_4 / 2 + num_5
		num_5 = num_5 + num_2 + num_3
	end

	self._illusion_widgets = tbl

	local skin = arg_49_1.skin

	skin = skin or var_49_8

	local flag_3 = true
	local flag_4 = true

	self:_select_illusion_by_key(skin, flag_3, flag_4)

	self._weapon_illusion_base_widgets_by_name.illusions_counter.content.text = "(" .. tostring(num) .. "/" .. tostring(#tbl) .. ")"
end

HeroWindowItemCustomization._state_setup_overview = function (self)
	-- function 50
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(info_widgets) do
		local var_50_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_50_2
		tbl_2[k] = var_50_2
	end

	self._info_widgets = tbl
	self._info_widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(weapon_illusion_base_widgets) do
		local var_50_5 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_50_5
		tbl_4[k_2] = var_50_5
	end

	self._weapon_illusion_base_widgets = tbl_3
	self._weapon_illusion_base_widgets_by_name = tbl_4

	local _get_item = self:_get_item(self._item_backend_id)
	local get_ui_information_from_item, var_50_8, var_50_9, var_50_10 = UIUtils.get_ui_information_from_item(_get_item)
	local data = _get_item.data
	local slot_type = data.slot_type
	local backend_id = _get_item.backend_id
	local get_item_template = BackendUtils.get_item_template(data, backend_id)

	if not _get_item.rarity then
		local rarity = data.rarity
	end

	local power_level = _get_item.power_level
	local tbl_5 = {}
	local _create_item_feature_widget = self:_create_item_feature_widget(Localize("tooltips_power"), power_level)

	tbl_5[#tbl_5 + 1] = _create_item_feature_widget

	local flag = slot_type == "melee" or slot_type == "ranged"

	if not flag then
		local tooltip_keywords = get_item_template.tooltip_keywords

		if not tooltip_keywords then
			local str = ""
			local count = #tooltip_keywords

			for i, v_3 in ipairs(tooltip_keywords) do
				str = str .. Localize(v_3)
				count = count - 1

				if count > 0 then
					str = str .. ", "
				end
			end

			local tbl_6 = {
				word_wrap = true,
				font_size = 28,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			}
			local _create_description_widget, var_50_25 = self:_create_description_widget("info_keyword_text", str, tbl_6)

			tbl[#tbl + 1] = _create_description_widget
		end
	else
		self._ui_scenegraph.info_keyword_text.size[2] = 0
	end

	self._info_widgets_by_name.keyword_divider_top.content.visible = flag

	if slot_type == "melee" then
		local block_angle = get_item_template.block_angle
		local _create_item_feature_widget_2 = self:_create_item_feature_widget(Localize("tutorial_tooltip_block"), block_angle)

		tbl_5[#tbl_5 + 1] = _create_item_feature_widget_2

		local max_fatigue_points = get_item_template.max_fatigue_points
		local _create_item_feature_widget_3 = self:_create_item_feature_widget(Localize("tooltips_stamina"), max_fatigue_points)

		tbl_5[#tbl_5 + 1] = _create_item_feature_widget_3
	elseif slot_type == "ranged" then
		local var_50_30
		local var_50_31
		local ammo_data = get_item_template.ammo_data

		if not (not ammo_data and ammo_data.hide_ammo_ui) then
			local single_clip = ammo_data.single_clip
			local reload_time = ammo_data.reload_time
			local max_ammo = ammo_data.max_ammo
			local ammo_per_clip = ammo_data.ammo_per_clip

			var_50_30 = tostring(max_ammo)
		else
			var_50_31 = "icon_fire"
		end

		local _create_item_feature_widget_4 = self:_create_item_feature_widget(Localize("tooltips_ammunition"), var_50_30, var_50_31)

		tbl_5[#tbl_5 + 1] = _create_item_feature_widget_4

		local var_50_38 = UISettings.crosshair_styles.ranged[get_item_template.crosshair_style]

		var_50_38 = var_50_38 or UISettings.crosshair_types.default

		local _create_item_feature_widget_5 = self:_create_item_feature_widget("Crosshair", nil, var_50_38.crosshair_icon)

		tbl_5[#tbl_5 + 1] = _create_item_feature_widget_5
	end

	local count_2 = #tbl_5

	for i6 = 1, count_2 do
		local var_50_41 = tbl_5[i6]

		var_50_41.offset[1] = var_50_41.content.size[1] * (i6 - 1)
		tbl[#tbl + 1] = var_50_41
	end

	if not flag then
		local _create_weapon_diagram_widget = self:_create_weapon_diagram_widget(get_item_template)

		tbl[#tbl + 1] = _create_weapon_diagram_widget
		tbl_2.weapon_diagram = _create_weapon_diagram_widget
	end

	local _create_description_widget_2, var_50_44 = self:_create_description_widget("info_description_text", Localize(var_50_9))

	tbl[#tbl + 1] = _create_description_widget_2
	self._ui_scenegraph.info_description_text.local_position[2] = -(var_50_44[2] + 10)

	local local_position = self._ui_scenegraph.keyword_divider_bottom.local_position
	local flag_2

	flag_2 = not flag and -10 and 350
	local_position[2] = flag_2

	self:_destroy_scrollbar()
	self:_setup_illusions(_get_item)

	self._current_recipe_name = "apply_weapon_skin"

	self:_update_state_craft_button(self._current_recipe_name, Localize("input_description_apply"), nil, nil, {
		0,
		-40,
		0
	})
	self:_enable_craft_button(false)
	self._menu_input_description:change_generic_actions(generic_input_actions.default)
end

HeroWindowItemCustomization._state_setup_property_reroll = function (self)
	-- function 51
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(property_reroll_widgets) do
		local var_51_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_51_2
		tbl_2[k] = var_51_2
	end

	self._property_reroll_widgets = tbl
	self._property_reroll_widgets_by_name = tbl_2

	local _get_item = self:_get_item(self._item_backend_id)
	local data = _get_item.data
	local slot_type = data.slot_type
	local rarity = _get_item.rarity

	rarity = rarity or data.rarity

	local property_table_name = data.property_table_name

	if not property_table_name then
		return
	end

	local tbl_3 = {}
	local num = 45
	local num_2 = 30
	local var_51_11 = num
	local var_51_12 = WeaponProperties.combinations[property_table_name]
	local var_51_13 = var_51_12[rarity]

	var_51_13 = var_51_13 or var_51_12.common

	for k_2, v_2 in pairs(WeaponProperties.properties) do
		local flag = false

		for i, v_3 in ipairs(var_51_13) do
			if not table.contains(v_3, k_2) then
				flag = true

				break
			end
		end

		if not flag then
			local buff_name = v_2.buff_name
			local flag_2

			flag_2 = BuffUtils.get_buff_template(buff_name).buffs[1].variable_multiplier ~= nil

			local display_name = v_2.display_name
			local num_3 = 1
			local get_property_description, var_51_20 = UIUtils.get_property_description(k_2, num_3)
			local gsub = string.gsub(get_property_description, "%d", "")
			local gsub_2 = string.gsub(gsub, "%p", "")
			local var_51_23 = gsub_2
			local _create_property_option_entry = self:_create_property_option_entry(gsub_2, var_51_20)

			tbl_3[#tbl_3 + 1] = _create_property_option_entry
			_create_property_option_entry.offset[2] = -var_51_11
			var_51_11 = var_51_11 + num_2
		end
	end

	local num_4 = var_51_11 - num

	self._property_reroll_option_widgets = tbl_3

	local _create_description_widget, var_51_27 = self:_create_description_widget("info_description_text_2", Localize("description_crafting_recipe_weapon_reroll_properties"))

	tbl[#tbl + 1] = _create_description_widget

	local num_5 = var_51_27[2] + 10

	self._ui_scenegraph.info_description_text_2.local_position[2] = -num_5

	local num_6 = num_2 * 2

	self:_initialize_scrollbar(num_4, num_6)

	local var_51_30 = self._states[self._state].recipe_by_slot_type[slot_type]

	self._current_recipe_name = var_51_30

	self:_update_state_craft_button(var_51_30, Localize("crafting_recipe_weapon_reroll_properties"), Colors.get_color_table_with_alpha("corn_flower_blue", 255))
	self._menu_input_description:change_generic_actions(generic_input_actions[self._state])
end

HeroWindowItemCustomization._enable_craft_button = function (self, arg_52_1, arg_52_2)
	-- function 52
	if not GameSettingsDevelopment.read_only_backend then
		arg_52_1 = false
	end

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.button_top_edge_left.content.visible = arg_52_2 or not arg_52_1 or false
	_widgets_by_name.button_top_edge_right.content.visible = arg_52_2 or not arg_52_1 or false
	_widgets_by_name.button_top_edge_glow.content.visible = arg_52_2 or not arg_52_1 or false

	local craft_button = _widgets_by_name.craft_button

	craft_button.content.visible = arg_52_1
	craft_button.content.button_hotspot.disable_button = not arg_52_1
	_widgets_by_name.experience_bar.content.visible = arg_52_1
	_widgets_by_name.experience_bar_edge.content.visible = arg_52_1

	if not arg_52_1 then
		self._menu_input_description:change_generic_actions(generic_input_actions.default)
	else
		self._menu_input_description:change_generic_actions(generic_input_actions[self._state])
	end
end

HeroWindowItemCustomization._update_state_craft_button = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	-- function 53
	local _create_material_requirement_widgets, var_53_1 = self:_create_material_requirement_widgets(arg_53_1)
	local max = math.max(var_53_1 + 30, 100)
	local _widgets_by_name = self._widgets_by_name
	local button_top_edge_left = _widgets_by_name.button_top_edge_left
	local button_top_edge_right = _widgets_by_name.button_top_edge_right
	local button_top_edge_glow = _widgets_by_name.button_top_edge_glow

	button_top_edge_left.offset[1] = -max / 2
	button_top_edge_right.offset[1] = max / 2
	self._ui_scenegraph.button_top_edge_glow.size[1] = max

	if not arg_53_3 then
		button_top_edge_glow.style.texture_id.color = arg_53_3
	end

	local craft_button = _widgets_by_name.craft_button

	craft_button.content.button_hotspot.disable_button = (arg_53_4 or not _create_material_requirement_widgets) and GameSettingsDevelopment.read_only_backend
	craft_button.content.title_text = arg_53_2
	self._has_all_crafting_requirements = _create_material_requirement_widgets

	local flag = true

	button_top_edge_left.content.visible = flag
	button_top_edge_right.content.visible = flag
	button_top_edge_glow.content.visible = flag
	craft_button.content.visible = flag
	self._ui_scenegraph.craft_button.local_position = arg_53_5 or {
		0,
		0,
		0
	}
end

local tbl_3 = {
	0,
	0,
	0,
	0,
	0
}

HeroWindowItemCustomization._create_weapon_diagram_widget = function (arg_54_0, arg_54_1)
	-- function 54
	local num = 0.25
	local num_2 = 8
	local num_3 = (1 - num) / num_2
	local num_4 = 0.0125
	local tbl = {}
	local weapon_diagram = arg_54_1.weapon_diagram
	local flag = not weapon_diagram and weapon_diagram.light_attack

	if not flag then
		Application.error(string.format("[HeroWindowItemCustomization] Missing light attack weapon diagram data for %q - Defaulting to zeros", arg_54_1.name))

		flag = tbl_3
	end

	local clamp = math.clamp(math.floor(flag[DamageTypes.ARMOR_PIERCING] + 0.5), 0, num_2 - 1)
	local clamp_2 = math.clamp(math.floor(flag[DamageTypes.CLEAVE] + 0.5), 0, num_2 - 1)
	local clamp_3 = math.clamp(math.floor(flag[DamageTypes.SPEED] + 0.5), 0, num_2 - 1)
	local clamp_4 = math.clamp(math.floor(flag[DamageTypes.STAGGER] + 0.5), 0, num_2 - 1)
	local clamp_5 = math.clamp(math.floor(flag[DamageTypes.DAMAGE] + 0.5), 0, num_2 - 1)

	tbl[#tbl + 1] = num + num_3 * clamp + clamp * num_4
	tbl[#tbl + 1] = num + num_3 * clamp_2 + clamp_2 * num_4
	tbl[#tbl + 1] = num + num_3 * clamp_3 + clamp_3 * num_4
	tbl[#tbl + 1] = num + num_3 * clamp_4 + clamp_4 * num_4
	tbl[#tbl + 1] = num + num_3 * clamp_5 + clamp_5 * num_4

	local flag_2 = not weapon_diagram and weapon_diagram.heavy_attack

	if not flag_2 then
		Application.error(string.format("[HeroWindowItemCustomization] Missing heavy attack weapon diagram data for %q - Defaulting to zeros", arg_54_1.name))

		flag_2 = tbl_3
	end

	local clamp_6 = math.clamp(math.floor(flag_2[DamageTypes.ARMOR_PIERCING] + 0.5), 0, num_2 - 1)
	local clamp_7 = math.clamp(math.floor(flag_2[DamageTypes.CLEAVE] + 0.5), 0, num_2 - 1)
	local clamp_8 = math.clamp(math.floor(flag_2[DamageTypes.SPEED] + 0.5), 0, num_2 - 1)
	local clamp_9 = math.clamp(math.floor(flag_2[DamageTypes.STAGGER] + 0.5), 0, num_2 - 1)
	local clamp_10 = math.clamp(math.floor(flag_2[DamageTypes.DAMAGE] + 0.5), 0, num_2 - 1)

	tbl[#tbl + 1] = num + num_3 * clamp_6 + clamp_6 * num_4
	tbl[#tbl + 1] = num + num_3 * clamp_7 + clamp_7 * num_4
	tbl[#tbl + 1] = num + num_3 * clamp_8 + clamp_8 * num_4
	tbl[#tbl + 1] = num + num_3 * clamp_9 + clamp_9 * num_4
	tbl[#tbl + 1] = num + num_3 * clamp_10 + clamp_10 * num_4

	local flag_3 = false
	local str = "weapon_stats_diagram"
	local size = scenegraph_definition[str].size
	local create_weapon_diagram_widget = UIWidgets.create_weapon_diagram_widget("weapon_stats_diagram", size, tbl, flag_3, num)

	return UIWidget.init(create_weapon_diagram_widget), size
end

HeroWindowItemCustomization._create_item_feature_widget = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	-- function 55
	local flag = false
	local str = "item_feature"
	local size = scenegraph_definition[str].size
	local create_item_feature = UIWidgets.create_item_feature(str, size, arg_55_1, arg_55_2, arg_55_3, flag)

	return UIWidget.init(create_item_feature), size
end

HeroWindowItemCustomization._create_description_widget = function (self, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	local flag = false

	if not arg_56_3 then
		local tbl = {
			word_wrap = true,
			font_size = 20,
			localize = false,
			use_shadow = true,
			horizontal_alignment = "left",
			vertical_alignment = "top"
		}
		local flag_2

		flag_2 = not flag and "hell_shark_masked" and "hell_shark"
		tbl.font_type = flag_2
		tbl.text_color = Colors.get_color_table_with_alpha("font_default", 255)
		tbl.offset = {
			0,
			0,
			2
		}
		arg_56_3 = tbl
	end

	local create_simple_text = UIWidgets.create_simple_text(arg_56_2, arg_56_1, nil, nil, arg_56_3)
	local var_56_4 = UIWidget.init(create_simple_text)
	local _ui_top_renderer = self._ui_top_renderer
	local size = scenegraph_definition[arg_56_1].size
	local size_2

	size_2[2], size_2 = math.floor(UIUtils.get_text_height(_ui_top_renderer, size, arg_56_3, arg_56_2)), self._ui_scenegraph[arg_56_1].size

	return var_56_4, size_2
end

HeroWindowItemCustomization._create_property_option_entry = function (arg_57_0, arg_57_1, arg_57_2)
	-- function 57
	local str = "property_options"
	local str_2 = arg_57_1 .. arg_57_2
	local var_57_2 = create_property_option(str, str_2)
	local var_57_3 = UIWidget.init(var_57_2)
	local text = var_57_3.style.text
	local color_override_table = text.color_override_table
	local length

	if not arg_57_2 then
		length = Utf8.length(arg_57_2)

		if not length then
			-- Nothing
		end
	end

	length = 0

	::label_57_0::

	local length_2 = Utf8.length(arg_57_1)

	length_2 = length_2 or 0
	color_override_table.start_index = length_2 + 1
	color_override_table.end_index = length_2 + length
	text.color_override[1] = color_override_table

	return var_57_3
end

HeroWindowItemCustomization._set_scroll_area_height = function (arg_58_0, arg_58_1, arg_58_2)
	-- function 58
	arg_58_0._ui_scenegraph.scroll_area.size[2] = arg_58_2
	arg_58_1.style.mask.size[2] = arg_58_2
end

HeroWindowItemCustomization._destroy_scrollbar = function (self)
	-- function 59
	if not self._scrollbar_logic then
		self._scrollbar_logic = nil
	end

	self._widgets_by_name.scrollbar.content.visible = false
end

HeroWindowItemCustomization._initialize_scrollbar = function (self, arg_60_1, arg_60_2)
	-- function 60
	local _widgets_by_name = self._widgets_by_name
	local _ui_scenegraph = self._ui_scenegraph

	UISceneGraph.update_scenegraph(_ui_scenegraph)

	local var_60_2 = _ui_scenegraph.info_window.world_position[2]
	local num = _ui_scenegraph.property_options_title.world_position[2] - var_60_2
	local flag = num < arg_60_1

	_ui_scenegraph.scrollbar.size[2] = num

	local scrollbar = _widgets_by_name.scrollbar

	scrollbar.content.visible = flag

	local var_60_6 = ScrollBarLogic:new(scrollbar)

	self._scrollbar_logic = var_60_6

	local num_2 = 1
	local var_60_8 = num

	var_60_6:set_scrollbar_values(num, arg_60_1, var_60_8, arg_60_2, num_2)
	var_60_6:set_scroll_percentage(0)

	local scroll_area = _widgets_by_name.scroll_area

	self:_set_scroll_area_height(scroll_area, num)

	self._scrolled_length = nil

	return flag
end

HeroWindowItemCustomization._update_scroll_position = function (self)
	-- function 61
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic then
		return
	end

	local get_scrolled_length = _scrollbar_logic:get_scrolled_length()

	if get_scrolled_length ~= self._scrolled_length then
		self._ui_scenegraph.scroll_root.local_position[2] = get_scrolled_length
		self._scrolled_length = get_scrolled_length
	end
end

HeroWindowItemCustomization._create_material_requirement_widgets = function (self, arg_62_1)
	-- function 62
	local ingredients = var_0_1[arg_62_1].ingredients
	local create_craft_material_widget = UIWidgets.create_craft_material_widget("material_root")
	local get_interface = Managers.backend:get_interface("items")
	local get_filtered_items = get_interface:get_filtered_items("item_type == crafting_material")
	local crafting_material_icons_small = UISettings.crafting_material_icons_small
	local tbl = {}
	local flag = true

	if not self._material_items then
		self._material_items = {}
	end

	local _material_items = self._material_items

	table.clear(_material_items)

	for i, v in ipairs(ingredients) do
		if not v.catergory then
			local var_62_8 = UIWidget.init(create_craft_material_widget)

			tbl[#tbl + 1] = var_62_8

			local name = v.name
			local amount = v.amount
			local var_62_11 = crafting_material_icons_small[name]
			local num = 0
			local var_62_13

			for i_2, v_2 in ipairs(get_filtered_items) do
				local backend_id = v_2.backend_id

				if v_2.data.key == name then
					var_62_13 = backend_id
					num = get_interface:get_item_amount(backend_id)

					break
				end
			end

			local flag_2 = amount <= num
			local var_62_16

			if num < UISettings.max_craft_material_presentation_amount then
				var_62_16 = tostring(num)

				if not var_62_16 then
					-- Nothing
				end
			end

			var_62_16 = "*"

			do
				local content
			end

			::label_62_0::

			content.text, content = var_62_16 .. "/" .. tostring(amount), var_62_8.content
			content.icon = var_62_11
			content.warning = not flag_2
			content.item = {
				data = table.clone(ItemMasterList[name])
			}
			_material_items[#_material_items + 1] = var_62_13

			if not (not (name == "crafting_material_dust_4") and not (ExperienceSettings.get_highest_character_level() < LootChestData.LEVEL_USED_FOR_POOL_LEVELS)) then
				flag = false
			elseif not flag_2 then
				flag = false
			end
		end
	end

	local count = #_material_items
	local num_2 = 80
	local num_3 = count * num_2
	local num_4 = -(num_3 / 2) + num_2 / 2

	for i4 = 1, count do
		tbl[i4].offset[1] = num_4
		num_4 = num_4 + num_2
	end

	self._material_widgets = tbl

	return flag, num_3
end

HeroWindowItemCustomization._play_sound = function (self, arg_63_1)
	-- function 63
	self._parent:play_sound(arg_63_1)
end

HeroWindowItemCustomization._state_setup_trait_reroll = function (self)
	-- function 64
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(trait_reroll_widgets) do
		local var_64_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_64_2
		tbl_2[k] = var_64_2
	end

	self._trait_reroll_widgets = tbl
	self._trait_reroll_widgets_by_name = tbl_2

	local _get_item = self:_get_item(self._item_backend_id)
	local data = _get_item.data
	local slot_type = data.slot_type
	local rarity = _get_item.rarity

	rarity = rarity or data.rarity

	local trait_table_name = data.trait_table_name

	if not trait_table_name then
		self:_enable_craft_button(false)

		return
	end

	self:_enable_craft_button(rarity)

	local tbl_3 = {}
	local num = 45
	local num_2 = 30
	local var_64_11 = num
	local var_64_12 = WeaponTraits.combinations[trait_table_name]

	for k_2, v_2 in pairs(WeaponTraits.traits) do
		local flag = false

		for i, v_3 in ipairs(var_64_12) do
			if not (not table.contains(v_3, k_2) and v_2.crafting_disabled) then
				flag = true

				break
			end
		end

		if not flag then
			local display_name = v_2.display_name
			local advanced_description = v_2.advanced_description
			local icon = v_2.icon
			local var_64_17 = Localize(display_name)
			local get_trait_description = UIUtils.get_trait_description(k_2)
			local _create_trait_option_entry, var_64_20 = self:_create_trait_option_entry(var_64_17, get_trait_description, icon)

			tbl_3[#tbl_3 + 1] = _create_trait_option_entry
			_create_trait_option_entry.offset[2] = -var_64_11
			var_64_11 = var_64_11 + num_2 + var_64_20
		end
	end

	local num_3 = var_64_11 - num

	self._trait_reroll_option_widgets = tbl_3

	local _create_description_widget, var_64_23 = self:_create_description_widget("info_description_text_2", Localize("description_crafting_recipe_weapon_reroll_traits"))

	tbl[#tbl + 1] = _create_description_widget

	local num_4 = var_64_23[2] + 10

	self._ui_scenegraph.info_description_text_2.local_position[2] = -num_4

	local num_5 = num_2 * 2

	self:_initialize_scrollbar(num_3, num_5)

	local var_64_26 = self._states[self._state].recipe_by_slot_type[slot_type]

	self._current_recipe_name = var_64_26

	self:_update_state_craft_button(var_64_26, Localize("crafting_recipe_weapon_reroll_traits"), Colors.get_color_table_with_alpha("font_title", 255))
	self._menu_input_description:change_generic_actions(generic_input_actions[self._state])
end

HeroWindowItemCustomization._create_trait_option_entry = function (self, arg_65_1, arg_65_2, arg_65_3)
	-- function 65
	local _ui_top_renderer = self._ui_top_renderer
	local str = "trait_options"
	local var_65_2 = create_trait_option(str, arg_65_1, arg_65_2, arg_65_3)
	local var_65_3 = UIWidget.init(var_65_2)
	local content = var_65_3.content
	local style = var_65_3.style
	local text = style.text
	local description_text = style.description_text
	local size = description_text.size
	local floor = math.floor(UIUtils.get_text_height(_ui_top_renderer, size, description_text, arg_65_2))
	local floor_2 = math.floor(floor)

	return var_65_3, floor_2
end

HeroWindowItemCustomization._state_draw_trait_reroll = function (self, arg_66_1, arg_66_2)
	-- function 66
	local _trait_reroll_widgets = self._trait_reroll_widgets

	if not _trait_reroll_widgets then
		for i, v in ipairs(_trait_reroll_widgets) do
			UIRenderer.draw_widget(arg_66_1, v)
		end

		local _trait_reroll_option_widgets = self._trait_reroll_option_widgets

		if not _trait_reroll_option_widgets then
			for i_2, v_2 in ipairs(_trait_reroll_option_widgets) do
				UIRenderer.draw_widget(arg_66_1, v_2)
			end
		end

		local _material_widgets = self._material_widgets

		if not _material_widgets then
			for i_3, v_3 in ipairs(_material_widgets) do
				UIRenderer.draw_widget(arg_66_1, v_3)
			end
		end
	end
end

HeroWindowItemCustomization._state_setup_upgrade = function (self)
	-- function 67
	self:_destroy_scrollbar()

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(upgrade_widgets) do
		local var_67_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_67_2
		tbl_2[k] = var_67_2
	end

	self._upgrade_widgets = tbl
	self._upgrade_widgets_by_name = tbl_2

	local _get_item = self:_get_item(self._item_backend_id)
	local data = _get_item.data
	local rarity = _get_item.rarity

	rarity = rarity or data.rarity

	local str = ""
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("plentiful", 255)
	local tbl_3 = {}

	if rarity == "plentiful" then
		str = Localize("forge_screen_common_token_tooltip")
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("common", 255)
		tbl_3[1] = "icon_add_property"
	elseif rarity == "common" then
		str = Localize("forge_screen_rare_token_tooltip")
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("rare", 255)
		tbl_3[1] = "icon_add_property"
	elseif rarity == "rare" then
		str = Localize("forge_screen_exotic_token_tooltip")
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("exotic", 255)
		tbl_3[1] = "icon_add_trait"
	elseif rarity == "exotic" then
		tbl_3[1] = "icon_upgrade_property"
		tbl_3[2] = "icon_upgrade_property"
		str = Localize("difficulty_veteran")
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("unique", 255)
	else
		return
	end

	local var_67_9 = Localize("upgrade_description_text_" .. rarity)
	local upgrade_rarity_name = tbl_2.upgrade_rarity_name

	upgrade_rarity_name.content.text = str
	upgrade_rarity_name.style.text.text_color = get_color_table_with_alpha

	local upgrade_icons = tbl_2.upgrade_icons

	upgrade_icons.content.texture_id = tbl_3
	tbl_2.upgrade_description_text.content.text = var_67_9

	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(tbl_3[1]).size

	upgrade_icons.style.texture_id.texture_size[1] = size[1]
	upgrade_icons.style.texture_id.texture_size[2] = size[2]
	upgrade_icons.style.texture_id.texture_amount = #tbl_3

	local _create_description_widget, var_67_14 = self:_create_description_widget("info_description_text_2", Localize("description_crafting_upgrade_item_rarity_common"))

	tbl[#tbl + 1] = _create_description_widget

	local num = var_67_14[2] + 10

	self._ui_scenegraph.info_description_text_2.local_position[2] = -num

	local var_67_16 = self._states[self._state].recipe_by_rarity[rarity]

	self._current_recipe_name = var_67_16

	self:_update_state_craft_button(var_67_16, Localize("hero_view_crafting_upgrade"), get_color_table_with_alpha)
	self._menu_input_description:change_generic_actions(generic_input_actions[self._state])
end

HeroWindowItemCustomization._state_draw_upgrade = function (self, arg_68_1, arg_68_2)
	-- function 68
	local _upgrade_widgets = self._upgrade_widgets

	if not _upgrade_widgets then
		for i, v in ipairs(_upgrade_widgets) do
			UIRenderer.draw_widget(arg_68_1, v)
		end

		local _material_widgets = self._material_widgets

		if not _material_widgets then
			for i_2, v_2 in ipairs(_material_widgets) do
				UIRenderer.draw_widget(arg_68_1, v_2)
			end
		end
	end
end

HeroWindowItemCustomization._craft = function (self, arg_69_1, arg_69_2)
	-- function 69
	local backend_id = self:_get_item(self._item_backend_id).backend_id
	local clone = table.clone(arg_69_1)

	clone[#clone + 1] = backend_id

	local craft = Managers.state.crafting:craft(clone, arg_69_2)

	if not craft then
		self._waiting_for_craft = true

		self._parent:block_input()

		self._current_crafting_data = {
			craft_id = craft,
			state_name = self._state
		}

		local loading_icon = self._widgets_by_name.loading_icon

		self:_start_transition_animation("on_crafting_enter")

		self._ui_animations.on_crafting_enter = UIAnimation.init(UIAnimation.function_by_time, loading_icon.style.texture_id.color, 1, 0, 255, 0.3, math.easeOutCubic)
		loading_icon.content.active = true

		return true
	end

	return false
end

HeroWindowItemCustomization._update_craft_response = function (self)
	-- function 70
	local _current_crafting_data = self._current_crafting_data

	_current_crafting_data = not _current_crafting_data and self._current_crafting_data.craft_id

	if not _current_crafting_data then
		return
	end

	local get_interface = Managers.backend:get_interface("crafting")

	if not get_interface:is_craft_complete(_current_crafting_data) then
		local get_craft_result = get_interface:get_craft_result(_current_crafting_data)

		self:_craft_completed(get_craft_result)

		self._current_crafting_data = nil
		self._character_dirty = true
	end
end

HeroWindowItemCustomization._craft_completed = function (self, arg_71_1)
	-- function 71
	self._waiting_for_craft = false

	self._parent:unblock_input()

	local _state = self._state
	local craft_complete_func_name = self._states[_state].craft_complete_func_name

	if not craft_complete_func_name then
		self[craft_complete_func_name](self, arg_71_1)
	end

	local loading_icon = self._widgets_by_name.loading_icon

	self:_start_transition_animation("on_crafting_exit")

	self._ui_animations.on_crafting_exit = UIAnimation.init(UIAnimation.function_by_time, loading_icon.style.texture_id.color, 1, 255, 0, 0.3, math.easeOutCubic)

	self._animation_callbacks.on_crafting_exit = function ()
		-- function 72
		loading_icon.content.active = false
	end

	self._item_dirty = true

	self:_play_sound("play_gui_craft_forge_end_console_qol")

	self._playing_craft_sound = false
end

HeroWindowItemCustomization._apply_weapon_skin_craft_complete = function (self, arg_73_1)
	-- function 73
	local _get_item = self:_get_item(self._item_backend_id)
	local key = _get_item.key
	local skin = _get_item.skin

	skin = skin or WeaponSkins.default_skins[key]

	local slot_type = _get_item.data.slot_type
	local _equipment_slot_name = self._equipment_slot_name

	_equipment_slot_name = _equipment_slot_name or InventorySettings.slot_names_by_type[slot_type][1]

	self._parent:_set_loadout_item(_get_item, _equipment_slot_name)
	self:_present_item(_get_item, true)

	local flag = true
	local flag_2 = true

	self:_select_illusion_by_key(skin, flag, flag_2)
	self._menu_input_description:change_generic_actions(generic_input_actions.default)
	self:_enable_craft_button(false)
end

HeroWindowItemCustomization._update_skin_gamepad_input = function (self, arg_74_1, arg_74_2, arg_74_3)
	-- function 74
	local _selected_skin_index = self._selected_skin_index

	_selected_skin_index = _selected_skin_index or 1

	local _selected_skin_index_2 = self._selected_skin_index
	local _illusion_widgets = self._illusion_widgets

	if #_illusion_widgets == 0 then
		return
	end

	local count = #_illusion_widgets
	local flag = false

	if not arg_74_1:get("move_left") then
		_selected_skin_index = math.clamp(_selected_skin_index - 1, 1, count)
	elseif not arg_74_1:get("move_right") then
		_selected_skin_index = math.clamp(_selected_skin_index + 1, 1, count)
	end

	if _selected_skin_index ~= _selected_skin_index_2 then
		local flag_2 = false
		local flag_3 = false

		self:_on_illusion_index_pressed(_selected_skin_index, flag_2, flag_3)

		flag = true
	end

	return flag
end

HeroWindowItemCustomization._upgrade_item_craft_complete = function (self, arg_75_1)
	-- function 75
	local _item_backend_id = self._item_backend_id
	local get_interface = Managers.backend:get_interface("dlcs")
	local get_interface_2 = Managers.backend:get_interface("items")
	local var_75_3 = arg_75_1[1][1]
	local _get_item = self:_get_item(var_75_3)

	self:_present_item(_get_item, nil, {
		0,
		2,
		0
	})

	for i, v in ipairs(ProfilePriority) do
		local careers = SPProfiles[v].careers

		for k, v_2 in pairs(careers) do
			local name = v_2.name

			if not (not v_2 and get_interface:is_unreleased_career(name)) then
				local get_career_loadouts = get_interface_2:get_career_loadouts(name)

				for k_2, v_3 in pairs(InventorySettings.equipment_slots) do
					local name_2 = v_3.name

					for i_2, v_4 in ipairs(get_career_loadouts) do
						if v_4[name_2] == _item_backend_id then
							get_interface_2:set_loadout_item(var_75_3, name, name_2, i_2)
						end
					end
				end
			end
		end
	end

	self._parent:_set_loadout_item(_get_item, self._equipment_slot_name)
	self:_state_setup_upgrade()
	self:_setup_availble_states(_get_item)
end
