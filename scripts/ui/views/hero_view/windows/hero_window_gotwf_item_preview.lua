-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_gotwf_item_preview.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_item_preview_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local top_widgets = var_0_0.top_widgets
local loading_widgets = var_0_0.loading_widgets
local create_claimed_widget = var_0_0.create_claimed_widget
local create_painting_widget = var_0_0.create_painting_widget
local create_texture_widget = var_0_0.create_texture_widget
local animation_definitions = var_0_0.animation_definitions
local num = 10
local num_2 = 800
local num_3 = 140
local str = "gui/1080p/single_textures/generic/transparent_placeholder_texture"

HeroWindowGotwfItemPreview = class(HeroWindowGotwfItemPreview)
HeroWindowGotwfItemPreview.NAME = "HeroWindowGotwfItemPreview"

HeroWindowGotwfItemPreview.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowGotwfItemPreview")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context

	local get_renderers, var_1_2 = self._parent:get_renderers()

	self._ui_renderer = get_renderers
	self._ui_top_renderer = var_1_2
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._is_in_inn = ingame_ui_context.is_in_inn
	self._animations = {}
	self._ui_animations = {}
	self._loaded_package_names = {}
	self._cloned_materials_by_reference = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_start_transition_animation("on_enter")
end

HeroWindowGotwfItemPreview._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local _top_widgets_by_name = self._top_widgets_by_name
	local var_2_2 = self._animations[arg_2_1]

	if not var_2_2 then
		self._ui_animator:stop_animation(var_2_2)

		self._animations[arg_2_1] = nil
	end

	local start_animation = self._ui_animator:start_animation(arg_2_1, _top_widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowGotwfItemPreview._create_viewport_definition = function (arg_3_0)
	-- function 3
	local str = "environment/ui_store_preview"

	return {
		scenegraph_id = "viewport",
		element = UIElements.Viewport,
		style = {
			viewport = {
				viewport_type = "default_forward",
				layer = 990,
				viewport_name = "item_preview_viewport",
				world_name = "item_preview",
				horizontal_alignment = "center",
				vertical_alignment = "center",
				level_name = "levels/ui_store_preview/world",
				enable_sub_gui = false,
				fov = 65,
				shading_environment = str,
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
				},
				viewport_size = {
					600,
					500
				}
			}
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		}
	}
end

HeroWindowGotwfItemPreview._create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._viewport_widget then
		UIWidget.destroy(self._ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(top_widgets) do
		local var_4_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_2
		tbl_2[k] = var_4_2
	end

	self._top_widgets = tbl
	self._top_widgets_by_name = tbl_2

	local var_4_3 = create_claimed_widget(self._ui_renderer)
	local var_4_4 = UIWidget.init(var_4_3)

	self._top_widgets[#self._top_widgets + 1] = var_4_4
	self._top_widgets_by_name.claimed = var_4_4

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(loading_widgets) do
		local var_4_7 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_4_7
		tbl_4[k_2] = var_4_7
	end

	self._loading_widgets = tbl_3
	self._loading_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end

	self._viewport_widget_definition = self:_create_viewport_definition()
end

HeroWindowGotwfItemPreview.on_exit = function (self, arg_5_1, arg_5_2)
	-- function 5
	print("[HeroViewWindow] Exit Substate HeroWindowGotwfItemPreview")

	self._ui_animator = nil
	self._has_exited = true

	self:_destroy_previewers()
	self:_destroy_viewport_gui()

	if not self._viewport_widget then
		UIWidget.destroy(self._ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	local _loaded_package_names = self._loaded_package_names

	for k, v in pairs(_loaded_package_names) do
		self:_unload_texture_by_reference(k)
	end
end

HeroWindowGotwfItemPreview.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_animations(arg_6_1)
	self:_sync_layout_path()
	self:_update_previewers(arg_6_1, arg_6_2)
end

HeroWindowGotwfItemPreview._update_previewers = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not self._selected_product then
		local window_input_service = self._parent:window_input_service()
		local flag = false
		local flag_2 = false

		if not self._world_previewer then
			local input_blocked = self._parent:input_blocked()

			self._world_previewer:update(arg_7_1, arg_7_2, input_blocked)
		end

		if not self._item_previewer then
			local viewport_button = self._top_widgets_by_name.viewport_button
			local is_button_hover = UIUtils.is_button_hover(viewport_button)
			local is_device_active = Managers.input:is_device_active("gamepad")
			local flag_3 = not not flag or not not flag_2 or is_device_active or is_button_hover

			self._item_previewer:update(arg_7_1, arg_7_2, not flag_3 and window_input_service)
		end
	end
end

HeroWindowGotwfItemPreview._register_object_sets = function (self, arg_8_1, arg_8_2)
	-- function 8
	local viewport = arg_8_2.style.viewport
	local style = arg_8_1.style
	local content = arg_8_1.content
	local var_8_3 = arg_8_1.element.pass_data[1]
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
		world = var_8_3.world,
		level = var_8_3.level,
		object_sets = tbl,
		level_name = level_name
	}

	self:_show_object_set(nil, true)
end

HeroWindowGotwfItemPreview._show_object_set = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._viewport_widget then
		print("[HeroWindowGotwfItemPreview:show_object_set] Viewport not initiated")

		return
	end

	local object_set_data = self._viewport_widget.content.object_set_data
	local world = object_set_data.world
	local level = object_set_data.level
	local level_name = object_set_data.level_name
	local object_sets = object_set_data.object_sets

	if not (object_sets[arg_9_1] or arg_9_2) then
		print(string.format("[HeroWindowGotwfItemPreview:show_object_set] No object set called %q in level %q", arg_9_1, level_name))

		return
	end

	for k, v in pairs(object_sets) do
		local set_enabled = v.set_enabled

		if not (not set_enabled and k == arg_9_1) then
			local units = v.units

			for i, v_2 in ipairs(units) do
				local unit_by_index = Level.unit_by_index(level, v_2)

				Unit.set_unit_visibility(unit_by_index, false)
			end

			v.set_enabled = false
		elseif not (set_enabled or k ~= arg_9_1) then
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

	print("Showing object set:", arg_9_1)
end

HeroWindowGotwfItemPreview._update_environment = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._viewport_widget then
		return
	end

	local flag = arg_10_1 or "default"
	local world = self._viewport_widget.content.object_set_data.world
	local get_data = World.get_data(world, "shading_settings")
	local flag_2

	flag_2 = not arg_10_2 and "default" and flag
	get_data[1] = flag_2
end

HeroWindowGotwfItemPreview._destroy_viewport_gui = function (self)
	-- function 11
	if not self._viewport_gui then
		local world = Managers.world:world("item_preview")

		World.destroy_gui(world, self._viewport_gui)

		self._viewport_gui = nil
	end
end

HeroWindowGotwfItemPreview._create_viewport_gui = function (self)
	-- function 12
	local world = Managers.world:world("item_preview")
	local flag = false
	local _is_in_inn = self._is_in_inn
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	self._viewport_gui = World.create_screen_gui(world, "immediate", "material", "materials/ui/ui_1080p_lock_test")

	local resolution, var_12_5 = Gui.resolution()

	self._gui_resolution = {
		resolution,
		var_12_5
	}
end

HeroWindowGotwfItemPreview.post_update = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not (not self._viewport_widget_definition and self._viewport_widget) then
		self._viewport_widget = UIWidget.init(self._viewport_widget_definition)

		self:_register_object_sets(self._viewport_widget, self._viewport_widget_definition)
	end

	self:_update_loading_overlay_fadeout_animation(arg_13_1)
	self:_update_delayed_item_unit_presentation(arg_13_1)

	if not self._viewport_widget then
		self:_sync_presentation_item()
	end

	if not self._world_previewer then
		self._world_previewer:post_update(arg_13_1, arg_13_2)
	end

	if not self._item_previewer then
		self._item_previewer:post_update(arg_13_1, arg_13_2)
	end

	if not self._selected_product then
		self:draw(arg_13_1)
	end
end

HeroWindowGotwfItemPreview._update_animations = function (self, arg_14_1)
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

	self:_update_title_edge_animation(arg_14_1)
end

HeroWindowGotwfItemPreview._exit = function (self)
	-- function 15
	self.exit = true
end

HeroWindowGotwfItemPreview._get_alpha_multiplier = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _render_settings = self._render_settings
	local alpha_multiplier = arg_16_1.alpha_multiplier

	if not alpha_multiplier then
		return math.min(alpha_multiplier, arg_16_2)
	end

	return arg_16_2
end

HeroWindowGotwfItemPreview.draw = function (self, arg_17_1)
	-- function 17
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_17_1, nil, _render_settings)

	for i, v in ipairs(self._top_widgets) do
		_render_settings.alpha_multiplier = self:_get_alpha_multiplier(v, alpha_multiplier)

		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	if not self._item_texture_widget then
		_render_settings.alpha_multiplier = self:_get_alpha_multiplier(self._item_texture_widget, alpha_multiplier)

		UIRenderer.draw_widget(_ui_top_renderer, self._item_texture_widget)
	end

	if not self._show_loading_overlay then
		for i_2, v_2 in ipairs(self._loading_widgets) do
			_render_settings.alpha_multiplier = self:_get_alpha_multiplier(v_2, alpha_multiplier)

			UIRenderer.draw_widget(_ui_top_renderer, v_2)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not self._viewport_widget then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_17_1, nil, _render_settings)
		UIRenderer.draw_widget(_ui_renderer, self._viewport_widget)
		UIRenderer.end_pass(_ui_renderer)
		self:_render_viewport_mask()
	end

	_render_settings.alpha_multiplier = alpha_multiplier
end

local tbl = {}

HeroWindowGotwfItemPreview._render_viewport_mask = function (self)
	-- function 18
	local resolution, var_18_1 = Application.resolution()
	local _gui_resolution = self._gui_resolution

	_gui_resolution = _gui_resolution or tbl

	if not (not self._viewport_gui and _gui_resolution[1] ~= resolution or _gui_resolution[2] == var_18_1) then
		self:_destroy_viewport_gui()
		self:_create_viewport_gui()
	end

	local _viewport_gui = self._viewport_gui
	local content = self._viewport_widget.content
	local viewport_size_y = content.viewport_size_y
	local viewport_size_y_2 = content.viewport_size_y
	local num = viewport_size_y * resolution * 0.285
	local num_2 = viewport_size_y_2 * var_18_1 * 0.26

	Gui.bitmap(_viewport_gui, "gui_lock_test_viewport_mask", Vector3(0, 0, 2), Vector2(num, num_2))
	Gui.bitmap(_viewport_gui, "gui_lock_test_viewport_mask", Vector3(resolution * viewport_size_y - num, 0, 2), Vector2(num, num_2))

	local var_18_9 = num
	local num_3 = viewport_size_y_2 * var_18_1 * 0.2

	Gui.bitmap(_viewport_gui, "gui_lock_test_viewport_mask", Vector3(0, var_18_1 * viewport_size_y_2 - num_3, 2), Vector2(var_18_9, num_3))
	Gui.bitmap(_viewport_gui, "gui_lock_test_viewport_mask", Vector3(resolution * viewport_size_y - var_18_9, var_18_1 * viewport_size_y_2 - num_3, 2), Vector2(var_18_9, num_3))

	local num_4 = viewport_size_y * resolution * 0.09
	local num_5 = viewport_size_y_2 * var_18_1

	Gui.bitmap(_viewport_gui, "gui_lock_test_viewport_mask", Vector3(0, 0, 2), Vector2(num_4, num_5))
	Gui.bitmap(_viewport_gui, "gui_lock_test_viewport_mask", Vector3(resolution * viewport_size_y - num_4, 0, 2), Vector2(num_4, num_5))
end

HeroWindowGotwfItemPreview._play_sound = function (self, arg_19_1)
	-- function 19
	self._parent:play_sound(arg_19_1)
end

HeroWindowGotwfItemPreview._start_loading_overlay = function (self)
	-- function 20
	self._show_loading_overlay = true
	self._fadeout_loading_overlay = nil
	self._fadeout_progress = nil
	self._loading_widgets_by_name.loading_icon.style.texture_id.color[1] = 255
end

HeroWindowGotwfItemPreview._update_loading_overlay_fadeout_animation = function (self, arg_21_1)
	-- function 21
	if self._fadeout_loading_overlay or not self._show_loading_overlay then
		return
	end

	local _loading_widgets_by_name = self._loading_widgets_by_name
	local num = 255
	local num_2 = 0
	local num_3 = 9
	local min = math.min
	local num_4 = 1
	local _fadeout_progress = self._fadeout_progress

	_fadeout_progress = _fadeout_progress or 0

	local var_21_7 = min(num_4, _fadeout_progress + num_3 * arg_21_1)
	local lerp = math.lerp(num, num_2, math.easeInCubic(var_21_7))

	_loading_widgets_by_name.loading_icon.style.texture_id.color[1] = lerp
	self._fadeout_progress = var_21_7

	if var_21_7 == 1 then
		self._fadeout_loading_overlay = nil
		self._fadeout_progress = nil
		self._show_loading_overlay = false
	end
end

HeroWindowGotwfItemPreview._destroy_previewers = function (self)
	-- function 22
	local _item_previewer = self._item_previewer

	if not _item_previewer then
		_item_previewer:destroy()

		self._item_previewer = nil
	end

	local _world_previewer = self._world_previewer

	if not _world_previewer then
		_world_previewer:prepare_exit()
		_world_previewer:on_exit()
		_world_previewer:destroy()

		self._world_previewer = nil
	end

	self._item_texture_widget = nil
end

HeroWindowGotwfItemPreview._sync_presentation_item = function (self, arg_23_1)
	-- function 23
	local selected_item = self._params.selected_item

	if selected_item ~= self._selected_product or not arg_23_1 then
		local flag = not selected_item and not self._selected_product and self._selected_product.item_id ~= selected_item.item_id or selected_item.reward_type == "currency"

		self._selected_product = selected_item

		local var_23_2 = selected_item

		if not flag then
			self._delayed_item_unit_presentation_delay = nil

			self:_destroy_previewers()

			if not self._selected_product then
				self:_start_loading_overlay()
				self:_present_item(var_23_2)
			end
		end
	end
end

local tbl_2 = {}

HeroWindowGotwfItemPreview._present_item = function (self, arg_24_1)
	-- function 24
	local var_24_0
	local var_24_1
	local item_id = arg_24_1.item_id
	local reward_type = arg_24_1.reward_type
	local var_24_4 = tbl_2
	local var_24_5

	if reward_type == "keep_decoration_painting" then
		var_24_5 = Paintings[arg_24_1.item_id]
	elseif reward_type == "chips" then
		var_24_4 = Currencies[arg_24_1.item_id]
	elseif reward_type == "currency" then
		var_24_4 = BackendUtils.get_fake_currency_item(arg_24_1.currency_code, arg_24_1.amount)
	else
		var_24_4 = ItemMasterList[arg_24_1.item_id]
	end

	if not var_24_4 then
		return
	end

	local item_type = var_24_4.item_type
	local slot_type = var_24_4.slot_type
	local can_wield = var_24_4.can_wield
	local display_name = var_24_4.display_name
	local item_preview_environment = var_24_4.item_preview_environment
	local item_preview_object_set_name = var_24_4.item_preview_object_set_name
	local str = ""
	local str_2 = ""
	local str_3 = ""
	local str_4 = ""
	local _get_can_wield_display_text, var_24_17 = self:_get_can_wield_display_text(can_wield)

	if not (slot_type == "melee" or slot_type == "ranged" or slot_type ~= "weapon_skin") then
		local item_type_2 = ItemMasterList[var_24_4.matching_item_key].item_type

		str = Localize(item_type_2)
		str_2 = Localize(item_type)
		item_preview_environment = item_preview_environment or "weapons_default_01"
		item_preview_object_set_name = item_preview_object_set_name or "flow_weapon_lights"
	elseif slot_type == "hat" then
		str = Localize(item_type)
		item_preview_environment = item_preview_environment or "hats_default_01"
		item_preview_object_set_name = item_preview_object_set_name or "flow_hat_lights"
	elseif slot_type == "skin" then
		str = Localize(item_type)

		local name = var_24_4.name
		local var_24_20 = Cosmetics[name]

		if not var_24_20 and not var_24_20.always_hide_attachment_slots then
			str_2 = Localize("menu_store_product_hero_skin_disclaimer_02_desc")
		else
			str_2 = Localize("menu_store_product_hero_skin_disclaimer_desc")
		end

		item_preview_object_set_name = item_preview_object_set_name or "flow_character_lights"
	elseif not var_24_5 then
		display_name = var_24_5.display_name
		str = Localize("interaction_painting")
		str_3 = Localize(var_24_5.description)
		_get_can_wield_display_text = ""
		var_24_17 = ""
	elseif slot_type == "chips" then
		local amount = arg_24_1.amount

		str = Localize(item_type)
		str_3 = Localize(var_24_4.description)
		str_4 = not amount and amount .. " " .. Localize("menu_store_panel_currency_tooltip_title") and ""
		_get_can_wield_display_text = ""
		var_24_17 = ""
	elseif slot_type == "versus_currency_name" then
		local amount_2 = arg_24_1.amount

		str_3 = Localize(var_24_4.description)
		str_4 = not amount_2 and string.format(Localize("achv_menu_vs_currency_reward_claimed"), amount_2) and ""
		str = Localize("hero_view_prestige_reward")
		display_name = "versus_currency_name"
		_get_can_wield_display_text = ""
		var_24_17 = ""
	elseif slot_type == "crafting_material" then
		local amount_3 = arg_24_1.amount

		str = Localize(item_type)
		str_3 = Localize(var_24_4.description)
		str_4 = not amount_3 and amount_3 .. " " .. Localize(var_24_4.display_name) and ""
		_get_can_wield_display_text = ""
		var_24_17 = ""
	else
		str = Localize(item_type)
		str_3 = Localize(var_24_4.description)
		_get_can_wield_display_text = ""
		var_24_17 = ""
	end

	if reward_type == "bundle_item" then
		local bundle_item_id = arg_24_1.bundle_item_id
		local var_24_25 = ItemMasterList[bundle_item_id]

		str = not var_24_25.information_text and Localize(var_24_25.information_text) and str
		str_3 = not var_24_25.description and Localize(var_24_25.description) and str_3
		_get_can_wield_display_text = ""
		var_24_17 = ""
	end

	self:_show_object_set(item_preview_object_set_name)
	self:_update_environment(item_preview_environment)
	self:_set_title_name(Localize(display_name))
	self:_set_sub_title_name(_get_can_wield_display_text)
	self:_set_description_text(str_3)
	self:_set_sub_title_alpha_multiplier(1)
	self:_set_type_title_name(str)
	self:_set_career_title_name(var_24_17)
	self:_set_disclaimer_text(str_2)
	self:_set_amount_text(str_4)
	self:_update_claimed_status()
	self:_start_transition_animation("info_animation")

	self._delayed_item_unit_presentation_delay = 0.3
end

HeroWindowGotwfItemPreview._update_claimed_status = function (self)
	-- function 25
	local selected_item_claimed = self._params.selected_item_claimed
	local selected_item_already_owned = self._params.selected_item_already_owned
	local claimed = self._top_widgets_by_name.claimed

	claimed.content.visible = selected_item_claimed
	claimed.content.already_owned = selected_item_already_owned
end

HeroWindowGotwfItemPreview._create_material_instance = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	arg_26_0._cloned_materials_by_reference[arg_26_4] = arg_26_2

	return Gui.clone_material_from_template(arg_26_1, arg_26_2, arg_26_3)
end

HeroWindowGotwfItemPreview._set_material_diffuse = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local material = Gui.material(arg_27_1, arg_27_2)

	if not material then
		Material.set_texture(material, "diffuse_map", arg_27_3)
	end
end

HeroWindowGotwfItemPreview._load_texture_package = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local flag = true
	local flag_2 = false

	Managers.package:load(arg_28_1, arg_28_2, arg_28_3, flag, flag_2)

	arg_28_0._loaded_package_names[arg_28_2] = arg_28_1
end

HeroWindowGotwfItemPreview._is_unique_reference_to_material = function (self, arg_29_1)
	-- function 29
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local var_29_1 = _cloned_materials_by_reference[arg_29_1]

	fassert(var_29_1, "[HeroWindowGotwfItemPreview] - Could not find a used material for reference name: (%s)", arg_29_1)

	for k, v in pairs(_cloned_materials_by_reference) do
		if not (var_29_1 ~= v or arg_29_1 == k) then
			return false
		end
	end

	return true
end

HeroWindowGotwfItemPreview._unload_texture_by_reference = function (self, arg_30_1)
	-- function 30
	local _loaded_package_names = self._loaded_package_names
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local var_30_2 = _loaded_package_names[arg_30_1]

	fassert(var_30_2, "[HeroWindowGotwfOverview] - Could not find a package to unload for reference name: (%s)", arg_30_1)
	Managers.package:unload(var_30_2, arg_30_1)

	_loaded_package_names[arg_30_1] = nil

	if not self:_is_unique_reference_to_material(arg_30_1) then
		local var_30_3 = _cloned_materials_by_reference[arg_30_1]
		local gui = self._ui_top_renderer.gui

		self:_set_material_diffuse(gui, var_30_3, str)
	end

	_cloned_materials_by_reference[arg_30_1] = nil
end

HeroWindowGotwfItemPreview._delayed_item_unit_presentation = function (self, arg_31_1)
	-- function 31
	if arg_31_1.reward_type == "keep_decoration_painting" then
		self:_setup_painting_presentation(arg_31_1)
	else
		self:_setup_item_presentation(arg_31_1)
	end
end

HeroWindowGotwfItemPreview._setup_painting_presentation = function (self, arg_32_1)
	-- function 32
	local item_id = arg_32_1.item_id
	local var_32_1 = Paintings[item_id]

	if not (not var_32_1 and item_id ~= "hidden") then
		return
	end

	local gui = self._ui_top_renderer.gui
	local var_32_3
	local str = "keep_painting_" .. item_id
	local flag = string.find(item_id, "_none") ~= nil

	if not flag then
		var_32_3 = "resource_packages/keep_paintings/" .. str
	end

	local _reference_id = self._reference_id

	_reference_id = _reference_id or 0
	self._reference_id = _reference_id + 1

	local str_2 = item_id .. "_" .. self._reference_id
	local str_3 = "keep_painting_" .. item_id
	local str_4 = "template_store_diffuse_masked"

	self:_create_material_instance(gui, str_3, str_4, str_2)

	local function fn()
		-- function 33
		local var_33_0 = create_painting_widget()
		local var_33_1 = UIWidget.init(var_33_0)
		local content = var_33_1.content
		local style = var_33_1.style

		self._item_texture_widget = var_33_1

		local str_2 = "units/gameplay/keep_paintings/materials/" .. str .. "/" .. str .. "_df"

		self:_set_material_diffuse(gui, str_3, str_2)

		local num = 2
		local num_2 = 150 * num
		local num_3 = 0.125

		if var_32_1.orientation == "horizontal" then
			content.painting = {
				texture_id = str_3,
				uvs = {
					{
						0,
						num_3
					},
					{
						1,
						1 - num_3
					}
				}
			}
			style.painting.texture_size = {
				num_2,
				num_2 * (1 - 2 * num_3)
			}
			style.painting_frame.area_size = {
				num_2,
				num_2 * (1 - 2 * num_3)
			}
		else
			content.painting = {
				texture_id = str_3,
				uvs = {
					{
						num_3,
						0
					},
					{
						1 - num_3,
						1
					}
				}
			}
			style.painting.texture_size = {
				num_2 * (1 - 2 * num_3),
				num_2
			}
			style.painting_frame.area_size = {
				num_2 * (1 - 2 * num_3),
				num_2
			}
		end

		self._fadeout_loading_overlay = true

		Renderer.request_textures_to_highest_mip_level()
	end

	if not flag then
		fn()
	else
		self:_load_texture_package(var_32_3, str_2, fn)
	end
end

HeroWindowGotwfItemPreview._setup_item_presentation = function (self, arg_34_1)
	-- function 34
	local item_id = arg_34_1.item_id
	local reward_type = arg_34_1.reward_type
	local var_34_2

	if reward_type == "chips" then
		var_34_2 = Currencies[item_id]
	elseif reward_type == "currency" then
		var_34_2, item_id = BackendUtils.get_fake_currency_item(arg_34_1.currency_code, arg_34_1.amount)
	else
		var_34_2 = ItemMasterList[item_id]
	end

	local slot_type = var_34_2.slot_type
	local _viewport_widget = self._viewport_widget
	local var_34_5 = _viewport_widget.element.pass_data[1]
	local viewport = var_34_5.viewport
	local world = var_34_5.world

	if not (slot_type == "melee" or slot_type == "ranged" or slot_type ~= "weapon_skin") then
		local tbl = {
			0,
			0,
			0
		}
		local var_34_9
		local flag = true
		local var_34_11
		local flag_2 = true
		local camera = ScriptViewport.camera(viewport)

		ScriptCamera.set_local_rotation(camera, QuaternionBox(0, 0, 1, 0):unbox())

		local tbl_2 = {
			data = var_34_2
		}
		local var_34_15 = LootItemUnitPreviewer:new(tbl_2, tbl, world, viewport, var_34_9, flag, var_34_11, flag_2)
		local var_34_16 = callback(self, "cb_unit_spawned_item_preview", var_34_15, item_id)

		var_34_15:activate_auto_spin()
		var_34_15:register_spawn_callback(var_34_16)

		self._item_previewer = var_34_15
	elseif slot_type == "hat" then
		local var_34_17 = MenuWorldPreviewer:new(self._ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroWindowGotwfItemPreview")

		var_34_17:on_enter(_viewport_widget)

		self._world_previewer = var_34_17

		local _get_hero_wield_info_by_item, var_34_19, var_34_20, var_34_21 = self:_get_hero_wield_info_by_item(var_34_2)
		local base_skin = CareerSettings[var_34_20].base_skin

		self:_spawn_hero_with_hat(var_34_17, _get_hero_wield_info_by_item, var_34_21, base_skin, item_id)
	elseif slot_type == "skin" then
		local var_34_23 = MenuWorldPreviewer:new(self._ingame_ui_context, UISettings.hero_skin_camera_position_by_character, "HeroWindowGotwfItemPreview")

		var_34_23:on_enter(_viewport_widget)

		self._world_previewer = var_34_23

		local var_34_24 = item_id
		local _get_hero_wield_info_by_item_2, var_34_26, var_34_27, var_34_28 = self:_get_hero_wield_info_by_item(var_34_2)

		self:_spawn_hero_skin(var_34_23, _get_hero_wield_info_by_item_2, var_34_28, var_34_24)
	elseif slot_type == "frame" then
		local str = "item_texture"
		local temporary_template = var_34_2.temporary_template

		temporary_template = temporary_template or "default"

		local num = 1.5
		local var_34_32
		local flag_3 = false
		local flag_4 = true
		local create_base_portrait_frame = UIWidgets.create_base_portrait_frame(str, temporary_template, num, var_34_32, flag_3, flag_4)

		self._item_texture_widget = UIWidget.init(create_base_portrait_frame)
		self._fadeout_loading_overlay = true
	elseif not (slot_type == "loot_chest" or slot_type == "chips" or slot_type == "crafting_material" or slot_type ~= "versus_currency_name") then
		local _reference_id = self._reference_id

		_reference_id = _reference_id or 0
		self._reference_id = _reference_id + 1

		local str_2 = item_id .. "_" .. self._reference_id

		if slot_type == "chips" then
			item_id = "shillings_medium"
		elseif slot_type == "versus_currency_name" then
			item_id = "versus_currency_small"
		elseif slot_type == "loot_chest" then
			item_id = "loot_chest_generic"
		end

		local store_icon_override_key = var_34_2.store_icon_override_key
		local str_3 = "store_item_icon_" .. (store_icon_override_key or item_id)
		local str_4 = "resource_packages/store/item_icons/" .. str_3

		if not Application.can_get("package", str_4) then
			local var_34_41
			local str_5 = "item_texture"
			local var_34_43
			local var_34_44
			local var_34_45
			local var_34_46
			local tbl_3 = {
				390,
				330
			}
			local var_34_48 = create_texture_widget(var_34_41, str_5, var_34_43, var_34_44, var_34_45, var_34_46, tbl_3)
			local var_34_49 = UIWidget.init(var_34_48)
			local content = var_34_49.content

			content.reference_name = str_2

			local gui = self._ui_top_renderer.gui
			local str_6

			if not var_34_43 then
				str_6 = str_3 .. "_masked"

				if not str_6 then
					-- Nothing
				end
			end

			str_6 = str_3

			do
				local flag_5
			end

			::label_34_0::

			flag_5 = not var_34_43 and "template_store_diffuse_masked" and "template_store_diffuse"

			self:_create_material_instance(gui, str_6, flag_5, str_2)

			local function fn()
				-- function 35
				local str = "gui/1080p/single_textures/store_item_icons/" .. str_3 .. "/" .. str_3

				self:_set_material_diffuse(gui, str_6, str)

				content.texture_id = str_6
				self._fadeout_loading_overlay = true
			end

			self:_load_texture_package(str_4, str_2, fn)

			self._item_texture_widget = var_34_49
		else
			Application.warning("Icon package not accessable for product_id: (%s) and texture_name: (%s)", item_id, str_3)
		end
	end
end

HeroWindowGotwfItemPreview._update_delayed_item_unit_presentation = function (self, arg_36_1)
	-- function 36
	local _delayed_item_unit_presentation_delay = self._delayed_item_unit_presentation_delay

	if not _delayed_item_unit_presentation_delay then
		return
	end

	local max = math.max(_delayed_item_unit_presentation_delay - arg_36_1, 0)

	if max == 0 then
		self._delayed_item_unit_presentation_delay = nil

		local _selected_product = self._selected_product

		self:_delayed_item_unit_presentation(_selected_product)
	else
		self._delayed_item_unit_presentation_delay = max
	end
end

HeroWindowGotwfItemPreview._set_title_name = function (arg_37_0, arg_37_1)
	-- function 37
	arg_37_0._top_widgets_by_name.title_text.content.text = arg_37_1
end

HeroWindowGotwfItemPreview._set_sub_title_name = function (arg_38_0, arg_38_1)
	-- function 38
	arg_38_0._top_widgets_by_name.sub_title_text.content.text = arg_38_1
end

HeroWindowGotwfItemPreview._set_description_text = function (arg_39_0, arg_39_1)
	-- function 39
	arg_39_0._top_widgets_by_name.description_text.content.text = arg_39_1
end

HeroWindowGotwfItemPreview._set_sub_title_alpha_multiplier = function (arg_40_0, arg_40_1)
	-- function 40
	arg_40_0._top_widgets_by_name.sub_title_text.alpha_multiplier = arg_40_1
end

HeroWindowGotwfItemPreview._set_type_title_name = function (arg_41_0, arg_41_1)
	-- function 41
	arg_41_0._top_widgets_by_name.type_title_text.content.text = arg_41_1
end

HeroWindowGotwfItemPreview._set_career_title_name = function (arg_42_0, arg_42_1)
	-- function 42
	arg_42_0._top_widgets_by_name.career_title_text.content.text = arg_42_1
end

HeroWindowGotwfItemPreview._set_disclaimer_text = function (self, arg_43_1)
	-- function 43
	self._disclaimer_text = arg_43_1
	self._top_widgets_by_name.disclaimer_text.content.text = arg_43_1

	self:_update_info_text_alignment()
end

HeroWindowGotwfItemPreview._set_amount_text = function (arg_44_0, arg_44_1)
	-- function 44
	arg_44_0._top_widgets_by_name.amount_text.content.text = arg_44_1
end

HeroWindowGotwfItemPreview._update_info_text_alignment = function (self)
	-- function 45
	local expire_timer_text = self._top_widgets_by_name.expire_timer_text
	local disclaimer_text = self._top_widgets_by_name.disclaimer_text
	local disclaimer_divider = self._top_widgets_by_name.disclaimer_divider
	local _expire_text = self._expire_text

	_expire_text = not _expire_text and self._expire_text ~= ""

	local _disclaimer_text = self._disclaimer_text

	_disclaimer_text = not _disclaimer_text and self._disclaimer_text ~= ""

	local var_45_5
	local var_45_6

	if not _expire_text then
		if not _disclaimer_text then
			var_45_5 = expire_timer_text
			var_45_6 = disclaimer_text
		else
			var_45_6 = expire_timer_text
		end
	elseif not _disclaimer_text then
		var_45_6 = disclaimer_text
	end

	local flag = _expire_text or _disclaimer_text
	local _ui_renderer = self._ui_renderer
	local get_text_width

	if not var_45_5 then
		get_text_width = UIUtils.get_text_width(_ui_renderer, var_45_5.style.text, var_45_5.content.text)

		if not get_text_width then
			-- Nothing
		end
	end

	get_text_width = 0

	do
		local get_text_width_2
	end

	::label_45_0::

	if not var_45_6 then
		get_text_width_2 = UIUtils.get_text_width(_ui_renderer, var_45_6.style.text, var_45_6.content.text)

		if not get_text_width_2 then
			-- Nothing
		end
	end

	get_text_width_2 = 0

	::label_45_1::

	local num = 14
	local var_45_12 = scenegraph_definition[disclaimer_divider.scenegraph_id].size[1]
	local num_2 = get_text_width + get_text_width_2 + var_45_12
	local num_3 = get_text_width / 2 - num_2 / 2 - num / 2
	local num_4 = num_3 + get_text_width / 2 + var_45_12 / 2 + num / 2
	local num_5 = num_4 + get_text_width_2 / 2 + var_45_12 / 2 + num / 2

	if not var_45_5 then
		var_45_5.offset[1] = num_3
	end

	if not var_45_6 then
		var_45_6.offset[1] = num_5
	end

	disclaimer_divider.offset[1] = num_4
	disclaimer_divider.content.visible = flag
end

HeroWindowGotwfItemPreview.cb_unit_spawned_item_preview = function (self, arg_46_1, arg_46_2)
	-- function 46
	local flag = true

	arg_46_1:present_item(arg_46_2, flag)

	self._fadeout_loading_overlay = true
end

HeroWindowGotwfItemPreview._spawn_hero_skin = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	-- function 47
	local var_47_0 = callback(arg_47_0, "cb_hero_unit_spawned_skin_preview", arg_47_1, arg_47_2, arg_47_3)

	arg_47_1:request_spawn_hero_unit(arg_47_2, arg_47_3, false, var_47_0, 1, nil, arg_47_4)
end

HeroWindowGotwfItemPreview._spawn_hero_with_hat = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	-- function 48
	local var_48_0 = callback(arg_48_0, "cb_hero_unit_spawned_hat_preview", arg_48_1, arg_48_2, arg_48_3, arg_48_5)

	arg_48_1:request_spawn_hero_unit(arg_48_2, arg_48_3, false, var_48_0, 1, nil, arg_48_4)
end

HeroWindowGotwfItemPreview.cb_hero_unit_spawned_skin_preview = function (self, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local var_49_0 = FindProfileIndex(arg_49_2)
	local var_49_1 = SPProfiles[var_49_0].careers[arg_49_3]
	local str = "store_idle"
	local preview_items = var_49_1.preview_items

	if not preview_items then
		for i, v in ipairs(preview_items) do
			local item_name = v.item_name
			local slot_type = ItemMasterList[item_name].slot_type

			if not (slot_type == "melee" or slot_type == "ranged") then
				local var_49_6 = InventorySettings.slot_names_by_type[slot_type][1]
				local var_49_7 = InventorySettings.slots_by_name[var_49_6]

				arg_49_1:equip_item(item_name, var_49_7)
			end
		end
	end

	if not str then
		arg_49_1:play_character_animation(str)
	end

	self._fadeout_loading_overlay = true
end

HeroWindowGotwfItemPreview.cb_hero_unit_spawned_hat_preview = function (self, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	-- function 50
	local var_50_0 = FindProfileIndex(arg_50_2)
	local var_50_1 = SPProfiles[var_50_0].careers[arg_50_3]
	local str = "store_idle"
	local preview_items = var_50_1.preview_items
	local slot_hat = InventorySettings.slots_by_name.slot_hat

	arg_50_1:equip_item(arg_50_4, slot_hat)

	if not preview_items then
		for i, v in ipairs(preview_items) do
			local item_name = v.item_name
			local slot_type = ItemMasterList[item_name].slot_type

			if not (slot_type == "melee" or slot_type == "ranged" or slot_type == "hat") then
				local var_50_7 = InventorySettings.slot_names_by_type[slot_type][1]
				local var_50_8 = InventorySettings.slots_by_name[var_50_7]

				arg_50_1:equip_item(item_name, var_50_8)
			end
		end
	end

	if not str then
		arg_50_1:play_character_animation(str)
	end

	self._fadeout_loading_overlay = true
end

HeroWindowGotwfItemPreview._get_can_wield_display_text = function (arg_51_0, arg_51_1)
	-- function 51
	local str = ""
	local str_2 = ""

	if not arg_51_1 then
		local num = 0
		local num_2 = 0

		for i, v in ipairs(arg_51_1) do
			local var_51_4 = CareerSettings[v]
			local profile_name = var_51_4.profile_name
			local var_51_6 = FindProfileIndex(profile_name)
			local character_name = SPProfiles[var_51_6].character_name

			if num_2 > 0 then
				str_2 = str_2 .. ", "
			end

			num_2 = num_2 + 1

			local display_name = var_51_4.display_name

			str_2 = str_2 .. Localize(display_name)

			local var_51_9 = Localize(character_name)

			if not string.find(str, var_51_9) then
				if num > 0 then
					str = str .. ", "
				end

				num = num + 1
				str = str .. var_51_9
			end
		end
	end

	return str, str_2
end

HeroWindowGotwfItemPreview._get_hero_wield_info_by_item = function (arg_52_0, arg_52_1)
	-- function 52
	local var_52_0 = arg_52_1.can_wield[1]

	for i, v in ipairs(SPProfiles) do
		local careers = v.careers

		for i_2, v_2 in ipairs(careers) do
			if v_2.name == var_52_0 then
				local display_name = v.display_name
				local var_52_3 = FindProfileIndex(display_name)
				local sort_order = v_2.sort_order

				return display_name, var_52_3, var_52_0, sort_order
			end
		end
	end
end

HeroWindowGotwfItemPreview._sync_layout_path = function (self)
	-- function 53
	local _parent = self._parent
	local _old_layout_name = self._old_layout_name
	local get_layout_name = _parent:get_layout_name()

	if get_layout_name ~= _old_layout_name then
		self._old_layout_name = get_layout_name
	end
end

HeroWindowGotwfItemPreview._update_title_edge_animation = function (self, arg_54_1)
	-- function 54
	local _title_edge_animation_data = self._title_edge_animation_data

	if not _title_edge_animation_data then
		return
	end

	local duration = _title_edge_animation_data.duration

	if not duration then
		return
	end

	local max = math.max(duration - arg_54_1, 0)
	local start_length = _title_edge_animation_data.start_length
	local target_length = _title_edge_animation_data.target_length
	local total_duration = _title_edge_animation_data.total_duration
	local easeOutCubic = math.easeOutCubic
	local num = 1 - max / total_duration
	local var_54_8 = easeOutCubic(num)
	local num_2 = start_length + (target_length - start_length) * var_54_8
	local title_edge = self._item_widgets_by_name.title_edge

	self._ui_scenegraph[title_edge.scenegraph_id].size[1] = num_2

	if max == 0 then
		_title_edge_animation_data.duration = nil
	else
		_title_edge_animation_data.duration = max
	end
end
