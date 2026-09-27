-- chunkname: @scripts/ui/diorama/hero_diorama_ui.lua

local var_0_0 = local_require("scripts/ui/diorama/hero_diorama_ui_definitions")
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local flag = false
local num = 0.8

HeroDioramaUI = class(HeroDioramaUI)

local HeroDioramaUI = HeroDioramaUI
local unique_id = HeroDioramaUI.unique_id

unique_id = unique_id or 0
HeroDioramaUI.unique_id = unique_id

HeroDioramaUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._settings = arg_1_2
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._input_manager = arg_1_1.input_manager
	self._ingame_ui_context = arg_1_1
	self._player_manager = arg_1_1.player_manager

	local world = arg_1_1.world_manager:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)
	self._instance_id = self:_get_unique_id()
	self._animations = {}
	self._active = false
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}

	self:_create_ui_elements()

	self._viewport_active = true
end

HeroDioramaUI._get_unique_id = function (arg_2_0)
	-- function 2
	local unique_id = HeroDioramaUI.unique_id

	HeroDioramaUI.unique_id = unique_id + 1

	return unique_id
end

HeroDioramaUI._create_ui_elements = function (self)
	-- function 3
	flag = false

	if not self._viewport_widget then
		self:_unload_level_package()
		self:_unload_diorama_package()
		UIWidget.destroy(self._ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local widget_definitions = var_0_0.widget_definitions

	for k, v in pairs(widget_definitions) do
		local var_3_3 = UIWidget.init(v)

		tbl_2[k] = var_3_3
		tbl[#tbl + 1] = var_3_3
	end

	self._widgets_by_name = tbl_2
	self._widgets = tbl
	self._viewport_widget_definition = self:_create_viewport_definition()

	local str = "diorama_test"
	local flag_2 = true
	local var_3_6 = callback(self, "_cb_diorama_package_loaded")

	Managers.package:load("resource_packages/dlcs/carousel_diorama", str, var_3_6, flag_2)
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	self:update_position()
	self:_reset_overlay()
end

HeroDioramaUI._cb_level_package_loaded = function (self)
	-- function 4
	self._level_package_loaded = true
end

HeroDioramaUI._cb_diorama_package_loaded = function (self)
	-- function 5
	self._diorama_package_loaded = true

	local level_package_name = self._viewport_widget_definition.style.viewport.level_package_name
	local _resource_id = self:_resource_id()
	local flag = true
	local var_5_3 = callback(self, "_cb_level_package_loaded")

	Managers.package:load(level_package_name, _resource_id, var_5_3, flag)
end

HeroDioramaUI.fade_in = function (self, arg_6_1)
	-- function 6
	self._fade_in_duration = arg_6_1
	self._fade_timer = 0
end

HeroDioramaUI.fade_out = function (self, arg_7_1)
	-- function 7
	self._fade_out_duration = arg_7_1
	self._fade_timer = 0
end

HeroDioramaUI._fade_out_overlay = function (self)
	-- function 8
	self._overlay_fade_out_time = 0
end

HeroDioramaUI._reset_overlay = function (self)
	-- function 9
	self._widgets_by_name.overlay.alpha_multiplier = 1
	self._overlay_fade_out_time = nil
	self._destroy_previewer_on_fade_out = true
end

HeroDioramaUI._update_overlay_fade_out_animation = function (self, arg_10_1)
	-- function 10
	local _overlay_fade_out_time = self._overlay_fade_out_time

	if not _overlay_fade_out_time then
		return
	end

	local num_2 = _overlay_fade_out_time + arg_10_1
	local min = math.min(num_2 / num, 1)

	self._widgets_by_name.overlay.alpha_multiplier = 1 - min

	if min == 1 then
		self._overlay_fade_out_time = nil
	else
		self._overlay_fade_out_time = num_2
	end
end

HeroDioramaUI._update_fade_animations = function (self, arg_11_1)
	-- function 11
	self:_update_fade_in_animation(arg_11_1)
	self:_update_fade_out_animation(arg_11_1)
	self:_update_overlay_fade_out_animation(arg_11_1)
end

HeroDioramaUI._update_fade_in_animation = function (self, arg_12_1)
	-- function 12
	local _fade_timer = self._fade_timer
	local _fade_in_duration = self._fade_in_duration

	if not (not _fade_timer and _fade_in_duration) then
		return
	end

	local num = _fade_timer + arg_12_1
	local min = math.min(num / _fade_in_duration, 1)

	self._render_settings.alpha_multiplier = min

	if min == 1 then
		self._fade_in_duration = nil
		self._fade_timer = nil
	else
		self._fade_timer = num
	end
end

HeroDioramaUI._update_fade_out_animation = function (self, arg_13_1)
	-- function 13
	local _fade_timer = self._fade_timer
	local _fade_out_duration = self._fade_out_duration

	if not (not _fade_timer and _fade_out_duration) then
		return
	end

	local num = _fade_timer + arg_13_1
	local min = math.min(num / _fade_out_duration, 1)

	self._render_settings.alpha_multiplier = 1 - min

	if min == 1 then
		self._fade_out_duration = nil
		self._fade_timer = nil
	else
		self._fade_timer = num
	end
end

HeroDioramaUI.set_viewport_active = function (self, arg_14_1)
	-- function 14
	self._viewport_active = arg_14_1
end

HeroDioramaUI._update_viewport_active_state = function (self)
	-- function 15
	local _viewport_active = self._viewport_active

	if self._synced_viewport_active_state ~= _viewport_active then
		local _viewport_widget = self._viewport_widget
		local viewport = _viewport_widget.style.viewport
		local viewport_name = viewport.viewport_name
		local world_name = viewport.world_name
		local var_15_5 = _viewport_widget.element.pass_data[1]
		local world = var_15_5.world
		local viewport_2 = var_15_5.viewport

		if not _viewport_active then
			if self._synced_viewport_active_state == false then
				ScriptWorld.activate_viewport(world, viewport_2)
			end

			self:_fade_out_overlay()
		else
			ScriptWorld.deactivate_viewport(world, viewport_2)
			self:_reset_overlay()
		end

		self._synced_viewport_active_state = _viewport_active
	end
end

HeroDioramaUI._create_viewport_definition = function (self)
	-- function 16
	local str = "environment/ui_store_preview"
	local _instance_id = self._instance_id
	local tbl = {
		"fire_01/tier_01",
		"fire_01/tier_02",
		"fire_01/tier_03",
		"forest_01/tier_01",
		"forest_01/tier_02",
		"forest_01/tier_03",
		"snow_01/tier_01",
		"snow_01/tier_02",
		"snow_01/tier_03"
	}
	local random = table.random(tbl)

	return {
		scenegraph_id = "viewport",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 800,
				viewport_type = "default_offscreen",
				enable_sub_gui = false,
				fov = 30,
				shading_environment = str,
				world_name = "diorama_preview_" .. tostring(_instance_id),
				viewport_name = "diorama_preview_viewport_" .. tostring(_instance_id),
				level_name = string.format("levels/diorama/%s/world", random),
				level_package_name = string.format("resource_packages/levels/dlcs/carousel/diorama/%s", random),
				world_flags = {
					Application.DISABLE_SOUND,
					Application.DISABLE_ESRAM
				},
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
				offset = {
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
		}
	}
end

HeroDioramaUI._set_size = function (self, arg_17_1)
	-- function 17
	local _ui_scenegraph = self._ui_scenegraph
	local background = _ui_scenegraph.background
	local viewport = _ui_scenegraph.viewport
	local hero_text_box = _ui_scenegraph.hero_text_box
	local player_text_box = _ui_scenegraph.player_text_box
	local bottom_panel = _ui_scenegraph.bottom_panel
	local size = _ui_scenegraph.bottom_panel_edge.size
	local size_2 = bottom_panel.size
	local size_3 = hero_text_box.size
	local size_4 = player_text_box.size
	local size_5 = background.size
	local size_6 = viewport.size
	local max = math.max
	local var_17_13

	if not arg_17_1 then
		var_17_13 = arg_17_1[1]

		if not var_17_13 then
			-- Nothing
		end
	end

	var_17_13 = 500

	::label_17_0::

	size_5[1] = max(var_17_13, 1)

	local max_2 = math.max
	local var_17_15

	if not arg_17_1 then
		var_17_15 = arg_17_1[2]

		if not var_17_15 then
			-- Nothing
		end
	end

	var_17_15 = 500

	::label_17_1::

	size_5[2] = max_2(var_17_15, 1)

	local max_3 = math.max
	local var_17_17

	if not arg_17_1 then
		var_17_17 = arg_17_1[1]

		if not var_17_17 then
			-- Nothing
		end
	end

	var_17_17 = 500

	::label_17_2::

	size_6[1] = max_3(var_17_17, 1)

	local max_4 = math.max
	local var_17_19

	if not arg_17_1 then
		var_17_19 = arg_17_1[2]

		if not var_17_19 then
			-- Nothing
		end
	end

	var_17_19 = 500

	::label_17_3::

	size_6[2] = max_4(var_17_19 - size_2[2], 1)

	local max_5 = math.max
	local var_17_21

	if not arg_17_1 then
		var_17_21 = arg_17_1[1]

		if not var_17_21 then
			-- Nothing
		end
	end

	var_17_21 = 500

	::label_17_4::

	size_2[1] = max_5(var_17_21, 1)

	local max_6 = math.max
	local var_17_23

	if not arg_17_1 then
		var_17_23 = arg_17_1[1]

		if not var_17_23 then
			-- Nothing
		end
	end

	var_17_23 = 500

	::label_17_5::

	size[1] = max_6(var_17_23, 1)

	local max_7 = math.max
	local var_17_25

	if not arg_17_1 then
		var_17_25 = arg_17_1[1]

		if not var_17_25 then
			-- Nothing
		end
	end

	var_17_25 = 500

	::label_17_6::

	size_3[1] = max_7(var_17_25 - size_2[2] * 2, 1)

	local max_8 = math.max
	local var_17_27

	if not arg_17_1 then
		var_17_27 = arg_17_1[1]

		if not var_17_27 then
			-- Nothing
		end
	end

	var_17_27 = 500

	::label_17_7::

	size_4[1] = max_8(var_17_27 - size_2[2], 1)

	self:_update_panel_background()
end

HeroDioramaUI._update_panel_background = function (self, arg_18_1)
	-- function 18
	local create_panel_background = var_0_0.create_panel_background
	local str = "bottom_panel"
	local size = self._ui_scenegraph[str].size
	local str_2 = "talent_tree_bg_01"
	local flag = arg_18_1 or {
		255,
		255,
		255,
		255
	}
	local var_18_5 = create_panel_background(str, size, str_2, flag)

	self._bottom_panel_widget = UIWidget.init(var_18_5)
end

HeroDioramaUI.update_position = function (self)
	-- function 19
	local _settings = self._settings

	if not _settings then
		local size = _settings.size

		self:_set_size(size)

		local position = _settings.position
		local vertical_alignment = _settings.vertical_alignment
		local horizontal_alignment = _settings.horizontal_alignment

		self:_set_position(position, horizontal_alignment, vertical_alignment)
	end
end

HeroDioramaUI._set_position = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local background = self._ui_scenegraph.background
	local position = background.position
	local var_20_2

	if not arg_20_1 then
		var_20_2 = arg_20_1[1]

		if not var_20_2 then
			-- Nothing
		end
	end

	var_20_2 = 0

	::label_20_0::

	position[1] = var_20_2

	local var_20_3

	if not arg_20_1 then
		var_20_3 = arg_20_1[2]

		if not var_20_3 then
			-- Nothing
		end
	end

	var_20_3 = 0

	::label_20_1::

	position[2] = var_20_3

	local var_20_4

	if not arg_20_1 then
		var_20_4 = arg_20_1[3]

		if not var_20_4 then
			-- Nothing
		end
	end

	var_20_4 = 0

	::label_20_2::

	position[3] = var_20_4
	background.vertical_alignment = arg_20_3 or "center"
	background.horizontal_alignment = arg_20_2 or "center"
end

HeroDioramaUI.destroy = function (self)
	-- function 21
	self:_destroy_previewers()

	if not self._viewport_widget then
		UIWidget.destroy(self._ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	self:_unload_level_package()
	self:_unload_diorama_package()

	self._ui_animator = nil
end

HeroDioramaUI._resource_id = function (self)
	-- function 22
	return "HeroDioramaUI_" .. self._instance_id
end

HeroDioramaUI._can_create_viewport = function (self)
	-- function 23
	if not self._viewport_widget then
		return false
	end

	local _level_package_loaded = self._level_package_loaded

	_level_package_loaded = not _level_package_loaded and self._cb_diorama_package_loaded

	return _level_package_loaded
end

HeroDioramaUI.set_hero_profile = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not self._viewport_widget then
		self._cashed_profile_data = nil

		self:_set_hero_profile(arg_24_1, arg_24_2)
	else
		self._cashed_profile_data = {
			profile_index = arg_24_1,
			career_index = arg_24_2
		}
	end
end

HeroDioramaUI._set_hero_profile = function (self, arg_25_1, arg_25_2)
	-- function 25
	self:_setup_character_previewer(arg_25_1, arg_25_2)

	local display_name = SPProfiles[arg_25_1].display_name
	local get_versus_experience = ExperienceSettings.get_versus_experience()
	local get_versus_level_from_experience = ExperienceSettings.get_versus_level_from_experience(get_versus_experience)

	get_versus_level_from_experience = get_versus_level_from_experience or ""

	local _get_portrait_frame = self:_get_portrait_frame(arg_25_1, arg_25_2)
	local get_portrait_image_by_profile_index

	if not arg_25_2 then
		get_portrait_image_by_profile_index = UIUtils.get_portrait_image_by_profile_index(arg_25_1, arg_25_2)

		if not get_portrait_image_by_profile_index then
			-- Nothing
		end
	end

	get_portrait_image_by_profile_index = "unit_frame_portrait_default"

	::label_25_0::

	self:_set_portrait_frame(_get_portrait_frame, get_versus_level_from_experience, get_portrait_image_by_profile_index)
	self:_set_career_name(arg_25_1, arg_25_2)

	local name = SPProfiles[arg_25_1].careers[arg_25_2].name
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(name, 255)

	get_color_table_with_alpha = get_color_table_with_alpha or Colors.color_definitions.white

	self:_update_panel_background(get_color_table_with_alpha)
end

HeroDioramaUI.post_update = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not flag then
		self:_destroy_previewers()
		self:_create_ui_elements()
	end

	if not self:_can_create_viewport() then
		self._viewport_widget = UIWidget.init(self._viewport_widget_definition)

		local _cashed_profile_data = self._cashed_profile_data

		if not _cashed_profile_data then
			local profile_index = _cashed_profile_data.profile_index
			local career_index = _cashed_profile_data.career_index

			self._cashed_profile_data = nil

			self:_set_hero_profile(profile_index, career_index)
		end
	end

	if not self._viewport_widget then
		self:_update_viewport_active_state()
	end

	if not self._world_previewer then
		self._world_previewer:post_update(arg_26_1, arg_26_2)
	end

	if not RESOLUTION_LOOKUP.modified then
		self:update_position()
	end
end

HeroDioramaUI.update = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not (not self._world_previewer and flag) then
		local flag_2 = true

		self._world_previewer:update(arg_27_1, arg_27_2, flag_2)
	end

	self:_update_animations(arg_27_1, arg_27_2)
	self:_draw(arg_27_1)
end

HeroDioramaUI._update_animations = function (self, arg_28_1, arg_28_2)
	-- function 28
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_28_1)

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	self:_update_fade_animations(arg_28_1)
end

HeroDioramaUI._draw = function (self, arg_29_1)
	-- function 29
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("ingame_menu")
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_29_1, nil, _render_settings)

	local _viewport_widget = self._viewport_widget

	if not _viewport_widget then
		local min = math.min
		local alpha_multiplier_2 = _viewport_widget.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = min(alpha_multiplier_2, alpha_multiplier)

		UIRenderer.draw_widget(_ui_renderer, _viewport_widget)
	end

	UIRenderer.end_pass(_ui_renderer)
	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_29_1, nil, _render_settings)

	local _widgets = self._widgets

	if not _widgets then
		for i = 1, #_widgets do
			local var_29_10 = _widgets[i]
			local min_2 = math.min
			local alpha_multiplier_3 = var_29_10.alpha_multiplier

			alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
			_render_settings.alpha_multiplier = min_2(alpha_multiplier_3, alpha_multiplier)

			UIRenderer.draw_widget(_ui_top_renderer, var_29_10)
		end
	end

	local _portrait_widget = self._portrait_widget

	if not _portrait_widget then
		local min_3 = math.min
		local alpha_multiplier_4 = _portrait_widget.alpha_multiplier

		alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier
		_render_settings.alpha_multiplier = min_3(alpha_multiplier_4, alpha_multiplier)

		UIRenderer.draw_widget(_ui_top_renderer, _portrait_widget)
	end

	local _bottom_panel_widget = self._bottom_panel_widget

	if not _bottom_panel_widget then
		local min_4 = math.min
		local alpha_multiplier_5 = _bottom_panel_widget.alpha_multiplier

		alpha_multiplier_5 = alpha_multiplier_5 or alpha_multiplier
		_render_settings.alpha_multiplier = min_4(alpha_multiplier_5, alpha_multiplier)

		UIRenderer.draw_widget(_ui_top_renderer, _bottom_panel_widget)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier
end

HeroDioramaUI._unload_level_package = function (self)
	-- function 30
	local _resource_id = self:_resource_id()
	local level_package_name = self._viewport_widget_definition.style.viewport.level_package_name

	Managers.package:unload(level_package_name, _resource_id)

	self._level_package_loaded = false
end

HeroDioramaUI._unload_diorama_package = function (self)
	-- function 31
	Managers.package:unload("resource_packages/dlcs/carousel_diorama", "diorama_test")

	self._diorama_package_loaded = false
end

HeroDioramaUI._destroy_previewers = function (self)
	-- function 32
	local _world_previewer = self._world_previewer

	if not _world_previewer then
		_world_previewer:prepare_exit()
		_world_previewer:on_exit()
		_world_previewer:destroy()

		self._world_previewer = nil
	end
end

local tbl = {
	default = {
		z = 0.4,
		x = 0,
		y = 0
	}
}

HeroDioramaUI._setup_character_previewer = function (self, arg_33_1, arg_33_2)
	-- function 33
	self:_destroy_previewers()

	local _viewport_widget = self._viewport_widget
	local var_33_1 = MenuWorldPreviewer:new(self._ingame_ui_context, tbl)

	var_33_1:on_enter(_viewport_widget)
	var_33_1:set_camera_axis_offset("y", 3.5, 0.01, math.easeOutCubic)

	self._world_previewer = var_33_1

	local var_33_2 = SPProfiles[arg_33_1]
	local display_name = var_33_2.display_name
	local name = var_33_2.careers[arg_33_2].name
	local base_skin = CareerSettings[name].base_skin
	local var_33_6
	local var_33_7 = callback(self, "cb_hero_unit_spawned_preview", var_33_1, display_name, arg_33_2)

	var_33_1:request_spawn_hero_unit(display_name, arg_33_2, false, var_33_7, 1, nil, var_33_6)

	local tbl_2 = {
		"units/diorama/podium/diorama_banner_flag_01",
		"units/diorama/podium/diorama_banner_flag_02"
	}
	local var_33_9 = callback(self, "cb_flag_spawned", var_33_1)

	var_33_1:request_spawn_unit(table.random(tbl_2), "flag", var_33_9)

	local tbl_3 = {
		"units/diorama/podium/diorama_banner_pole_01",
		"units/diorama/podium/diorama_banner_pole_02"
	}
	local var_33_11 = callback(self, "cb_pole_spawned", var_33_1)

	var_33_1:request_spawn_unit(table.random(tbl_3), "pole", var_33_11)

	local tbl_4 = {
		"units/diorama/podium/diorama_podium_rock_01",
		"units/diorama/podium/diorama_podium_stone_01",
		"units/diorama/podium/diorama_podium_dwarf_01",
		"units/diorama/podium/diorama_podium_pile_of_skulls_01"
	}
	local var_33_13 = callback(self, "cb_podium_spawned", var_33_1)

	var_33_1:request_spawn_unit(table.random(tbl_4), "podium", var_33_13)
	self:_reset_overlay()
end

HeroDioramaUI.cb_hero_unit_spawned_preview = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	arg_34_1:set_hero_location({
		0,
		0,
		0.43
	})

	local var_34_0 = FindProfileIndex(arg_34_2)
	local var_34_1 = SPProfiles[var_34_0].careers[arg_34_3]
	local str = "store_idle"
	local preview_items = var_34_1.preview_items

	if not preview_items then
		for i, v in ipairs(preview_items) do
			local item_name = v.item_name
			local slot_type = ItemMasterList[item_name].slot_type
			local var_34_6 = InventorySettings.slot_names_by_type[slot_type][1]
			local var_34_7 = InventorySettings.slots_by_name[var_34_6]

			if not (slot_type == "melee" or slot_type == "ranged") then
				arg_34_1:wield_weapon_slot(slot_type)
			end

			arg_34_1:equip_item(item_name, var_34_7)
		end
	end

	if not str then
		-- Nothing
	end

	if not self._viewport_active then
		self:_fade_out_overlay()
	end
end

HeroDioramaUI.cb_flag_spawned = function (arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	arg_35_1:set_unit_location(arg_35_2, {
		0,
		-1.5,
		0
	})
end

HeroDioramaUI.cb_pole_spawned = function (arg_36_0, arg_36_1, arg_36_2)
	-- function 36
	arg_36_1:set_unit_location(arg_36_2, {
		0,
		-1.5,
		0
	})
end

HeroDioramaUI.cb_podium_spawned = function (arg_37_0, arg_37_1, arg_37_2)
	-- function 37
	arg_37_1:set_unit_location(arg_37_2, {
		0,
		0,
		0
	})
end

HeroDioramaUI._set_career_name = function (arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	local display_name = SPProfiles[arg_38_1].careers[arg_38_2].display_name

	arg_38_0._widgets_by_name.career_name.content.text = Localize(display_name)
end

HeroDioramaUI._set_hero_name = function (arg_39_0, arg_39_1)
	-- function 39
	local ingame_short_display_name = SPProfiles[arg_39_1].ingame_short_display_name

	arg_39_0._widgets_by_name.hero_name.content.text = Localize(ingame_short_display_name)
end

HeroDioramaUI.set_player_name = function (arg_40_0, arg_40_1)
	-- function 40
	arg_40_0._widgets_by_name.player_name.content.text = arg_40_1
end

HeroDioramaUI._set_portrait_frame = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	local flag = arg_41_4 or 1
	local flag_2 = false
	local create_portrait_frame = UIWidgets.create_portrait_frame("portrait_pivot", arg_41_1, arg_41_2, flag, flag_2, arg_41_3)
	local var_41_3 = UIWidget.init(create_portrait_frame, self._ui_renderer)
	local content = var_41_3.content

	content.frame_settings_name = arg_41_1
	content.level_text = arg_41_2
	self._portrait_widget = var_41_3
end

HeroDioramaUI._get_portrait_frame = function (arg_42_0, arg_42_1, arg_42_2)
	-- function 42
	local name = SPProfiles[arg_42_1].careers[arg_42_2].name
	local str = "default"
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_frame")

	str = not get_loadout_item and get_loadout_item.data.temporary_template and str

	return str
end
