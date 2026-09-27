-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_weave_forge_overview.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_overview_definitions")
local top_widgets = var_0_0.top_widgets
local bottom_widgets = var_0_0.bottom_widgets
local bottom_hdr_widgets = var_0_0.bottom_hdr_widgets
local top_hdr_widgets = var_0_0.top_hdr_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local weapon_crafting_tutorial_definitions = var_0_0.weapon_crafting_tutorial_definitions
local flag = false
local num = 1.6

HeroWindowWeaveForgeOverview = class(HeroWindowWeaveForgeOverview)
HeroWindowWeaveForgeOverview.NAME = "HeroWindowWeaveForgeOverview"

HeroWindowWeaveForgeOverview.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowWeaveForgeOverview")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._ingame_ui_context = ingame_ui_context
	self._stats_id = Managers.player:local_player():stats_id()
	self._statistics_db = ingame_ui_context.statistics_db

	local _statistics_db = self._statistics_db
	local _stats_id = self._stats_id
	local get_onboarding_step = WeaveOnboardingUtils.get_onboarding_step(_statistics_db, _stats_id)
	local get_ui_onboarding_state = WeaveOnboardingUtils.get_ui_onboarding_state(_statistics_db, _stats_id)

	self.weapon_crafting_tutorial = not not WeaveOnboardingUtils.tutorial_completed(get_ui_onboarding_state, WeaveUITutorials.equip_weapon) or WeaveOnboardingUtils.reached_requirements(get_onboarding_step, WeaveUITutorials.equip_weapon)
	self.forge_upgrade_tutorial = not not WeaveOnboardingUtils.tutorial_completed(get_ui_onboarding_state, WeaveUITutorials.forge_upgrade) or WeaveOnboardingUtils.reached_requirements(get_onboarding_step, WeaveUITutorials.forge_upgrade)
	self.amulet_introduced = WeaveOnboardingUtils.reached_requirements(get_onboarding_step, WeaveUITutorials.amulet)
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	local hero_name = arg_1_1.hero_name
	local career_index = arg_1_1.career_index
	local profile_index = arg_1_1.profile_index

	self._career_name = SPProfiles[profile_index].careers[career_index].name
	self._hero_name = hero_name

	self:_sync_backend_loadout()
end

HeroWindowWeaveForgeOverview._setup_definitions = function (self)
	-- function 2
	if not self._parent:gamepad_style_active() then
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_overview_console_definitions")
	else
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_overview_definitions")
	end

	top_widgets = var_0_0.top_widgets
	bottom_widgets = var_0_0.bottom_widgets
	bottom_hdr_widgets = var_0_0.bottom_hdr_widgets
	top_hdr_widgets = var_0_0.top_hdr_widgets
	scenegraph_definition = var_0_0.scenegraph_definition
	animation_definitions = var_0_0.animation_definitions
	weapon_crafting_tutorial_definitions = var_0_0.weapon_crafting_tutorial_definitions
end

HeroWindowWeaveForgeOverview._start_transition_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		parent = self._parent,
		render_settings = self._render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_3_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_3_1] = start_animation
end

HeroWindowWeaveForgeOverview.create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_setup_definitions()

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}

	for k, v in pairs(top_widgets) do
		local var_4_5 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_5
		tbl_5[k] = var_4_5
	end

	for k_2, v_2 in pairs(bottom_widgets) do
		local var_4_6 = UIWidget.init(v_2)

		tbl_2[#tbl_2 + 1] = var_4_6
		tbl_5[k_2] = var_4_6
	end

	for k_3, v_3 in pairs(bottom_hdr_widgets) do
		local var_4_7 = UIWidget.init(v_3)

		tbl_4[#tbl_4 + 1] = var_4_7
		tbl_5[k_3] = var_4_7
	end

	for k_4, v_4 in pairs(top_hdr_widgets) do
		local var_4_8 = UIWidget.init(v_4)

		tbl_3[#tbl_3 + 1] = var_4_8
		tbl_5[k_4] = var_4_8
	end

	self._top_widgets = tbl
	self._bottom_widgets = tbl_2
	self._top_hdr_widgets = tbl_3
	self._bottom_hdr_widgets = tbl_4
	self._widgets_by_name = tbl_5

	local viewport_button_1 = self._widgets_by_name.viewport_button_1
	local viewport_button_2 = self._widgets_by_name.viewport_button_2
	local viewport_button_3 = self._widgets_by_name.viewport_button_3

	viewport_button_1.content.hotspot.allow_multi_hover = true
	viewport_button_2.content.hotspot.allow_multi_hover = true
	viewport_button_3.content.hotspot.allow_multi_hover = true
	tbl_5.upgrade_text.alpha_multiplier = 0
	tbl_5.upgrade_bg.alpha_multiplier = 0
	tbl_5.skull_circle.alpha_multiplier = 0
	tbl_5.skull_circle_shade.alpha_multiplier = 0
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end

	if not self.forge_upgrade_tutorial then
		local upgrade_button = tbl_5.upgrade_button

		upgrade_button.content.highlighted = true
		self._ui_animations.upgrade_button_pulse = UIAnimation.init(UIAnimation.pulse_animation, upgrade_button.style.texture_highlight.color, 1, 100, 255, 2)
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

HeroWindowWeaveForgeOverview._play_sound = function (self, arg_5_1)
	-- function 5
	self._parent:play_sound(arg_5_1)
end

HeroWindowWeaveForgeOverview._initialize_viewports = function (self)
	-- function 6
	local weapon_crafting_tutorial = self.weapon_crafting_tutorial
	local amulet_introduced = self.amulet_introduced
	local tbl = {
		{
			slot_name = "slot_melee",
			no_item_sub_title_text = "inventory_screen_melee_weapon_title",
			no_item_for_tutorial = weapon_crafting_tutorial
		},
		{
			unit_name = "units/ui/pup_weave_amulet/pup_weave_amulet",
			package_name = "units/ui/pup_weave_amulet/pup_weave_amulet",
			optional_title = Localize("weave_amulet_name"),
			hidden_for_tutorial = not amulet_introduced
		},
		{
			slot_name = "slot_ranged",
			no_item_sub_title_text = "inventory_screen_ranged_weapon_title",
			no_item_for_tutorial = weapon_crafting_tutorial
		}
	}
	local _career_name = self._career_name
	local backend = Managers.backend
	local get_interface = backend:get_interface("weaves")
	local get_interface_2 = backend:get_interface("items")
	local _widgets_by_name = self._widgets_by_name
	local tbl_2 = {}

	for i, v in ipairs(tbl) do
		local slot_name = v.slot_name
		local package_name = v.package_name
		local unit_name = v.unit_name
		local optional_title = v.optional_title
		local optional_sub_title = v.optional_sub_title
		local hidden_for_tutorial = v.hidden_for_tutorial
		local no_item_for_tutorial = v.no_item_for_tutorial
		local str = "viewport_" .. i
		local flag = i == #tbl
		local _create_viewport_definition = self:_create_viewport_definition(str, flag)
		local var_6_19 = UIWidget.init(_create_viewport_definition)

		var_6_19.content.visible = not hidden_for_tutorial

		local flag_2 = not slot_name and get_interface:get_loadout_item_id(_career_name, slot_name)
		local flag_3 = not flag_2 and get_interface_2:get_item_from_id(flag_2)
		local num = -0.8
		local flag_4 = false
		local flag_5 = (not not no_item_for_tutorial or not flag_3) and self:_create_item_previewer(var_6_19, flag_3, num, flag_4)
		local flag_6 = not package_name and self:_create_unit_previewer(var_6_19, unit_name, package_name)
		local num_2 = 0
		local num_3 = 0
		local flag_7 = optional_title or ""
		local flag_8 = optional_sub_title or ""

		if not no_item_for_tutorial then
			flag_7 = Localize("menu_weave_tutorial_athanor_01_empty_state_no_weapon")
			flag_8 = Localize(v.no_item_sub_title_text)
			num_3 = nil
		elseif not flag_3 then
			num_2 = get_interface:get_item_magic_level(flag_2) or 0
			num_3 = flag_3.power_level or 0
			num_3 = UIUtils.presentable_hero_power_level_weaves(num_3)

			local data = flag_3.data

			flag_7 = Localize(data.display_name)
			flag_8 = Localize(data.item_type)
		else
			num_2 = get_interface:get_career_magic_level(_career_name) or 0
			num_3 = get_interface:get_career_power_level(_career_name)
			num_3 = not num_3 and UIUtils.presentable_hero_power_level_weaves(num_3)

			local var_6_31 = CareerSettings[_career_name]

			flag_8 = Localize(var_6_31.display_name)
		end

		local var_6_32 = _widgets_by_name["viewport_panel_divider_" .. i]
		local var_6_33 = _widgets_by_name["viewport_panel_divider_left_" .. i]
		local var_6_34 = _widgets_by_name["viewport_panel_divider_right_" .. i]
		local var_6_35 = _widgets_by_name["viewport_level_value_" .. i]
		local var_6_36 = _widgets_by_name["viewport_level_title_" .. i]

		var_6_35.content.text = num_2
		var_6_35.content.visible = not not hidden_for_tutorial or not no_item_for_tutorial
		var_6_36.content.visible = not not hidden_for_tutorial or not no_item_for_tutorial

		local var_6_37 = _widgets_by_name["viewport_power_value_" .. i]
		local var_6_38 = _widgets_by_name["viewport_power_title_" .. i]

		var_6_37.content.visible = num_3 == nil or not hidden_for_tutorial
		var_6_38.content.visible = num_3 == nil or not hidden_for_tutorial
		var_6_32.content.visible = num_3 == nil or not hidden_for_tutorial
		var_6_33.content.visible = not hidden_for_tutorial
		var_6_34.content.visible = not hidden_for_tutorial

		if not num_3 then
			var_6_37.content.text = num_3
		else
			self._ui_scenegraph[var_6_35.scenegraph_id].local_position[1] = 0
			self._ui_scenegraph[var_6_36.scenegraph_id].local_position[1] = 0
		end

		local var_6_39 = _widgets_by_name["viewport_title_" .. i]

		var_6_39.content.text = flag_7
		var_6_39.content.visible = not hidden_for_tutorial

		local var_6_40 = _widgets_by_name["viewport_sub_title_" .. i]

		var_6_40.content.text = flag_8
		var_6_40.content.visible = not hidden_for_tutorial

		local var_6_41 = _widgets_by_name["viewport_button_" .. i]
		local var_6_42 = _widgets_by_name["viewport_button_highlight_" .. i]
		local var_6_43 = _widgets_by_name["viewport_button_text_highlight_" .. i]

		var_6_41.content.hotspot.disable_button = (hidden_for_tutorial or no_item_for_tutorial) == true

		local var_6_44 = _widgets_by_name["change_button_" .. i]

		if not var_6_44 and not weapon_crafting_tutorial then
			var_6_44.content.highlighted = true
			self._ui_animations["change_button_pulse" .. i] = UIAnimation.init(UIAnimation.pulse_animation, var_6_44.style.texture_highlight.color, 1, 100, 255, 2)
		end

		tbl_2[i] = {
			widget = var_6_19,
			viewport_button = var_6_41,
			viewport_button_highlight = var_6_42,
			viewport_button_text_highlight = var_6_43,
			item_previewer = flag_5,
			unit_previewer = flag_6,
			package_name = package_name,
			unit_name = unit_name,
			item = flag_3,
			slot_name = slot_name,
			change_button = var_6_44,
			magic_level = num_2,
			power_level = num_3
		}
	end

	if not (not weapon_crafting_tutorial and amulet_introduced) then
		local _top_widgets = self._top_widgets

		for k, v_2 in pairs(weapon_crafting_tutorial_definitions) do
			local var_6_46 = UIWidget.init(v_2)

			_top_widgets[#_top_widgets + 1] = var_6_46
		end
	end

	self._viewports_data = tbl_2
end

HeroWindowWeaveForgeOverview._create_item_previewer = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local data = arg_7_2.data
	local key = data.key
	local slot_type = data.slot_type
	local var_7_3 = arg_7_1.element.pass_data[1]
	local viewport = var_7_3.viewport
	local world = var_7_3.world
	local tbl = {
		arg_7_3,
		3,
		0
	}
	local var_7_7
	local var_7_8 = arg_7_4
	local var_7_9
	local var_7_10
	local var_7_11
	local _career_name = self._career_name
	local var_7_13 = LootItemUnitPreviewer:new(arg_7_2, tbl, world, viewport, var_7_7, var_7_8, var_7_9, var_7_10, var_7_11, _career_name)
	local var_7_14 = callback(self, "cb_unit_spawned_item_preview", var_7_13, key)

	var_7_13:register_spawn_callback(var_7_14)
	var_7_13:activate_auto_spin()

	return var_7_13
end

HeroWindowWeaveForgeOverview._create_unit_previewer = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local var_8_0 = arg_8_1.element.pass_data[1]
	local viewport = var_8_0.viewport
	local world = var_8_0.world
	local tbl = {
		0,
		2.8,
		0
	}
	local var_8_4 = UIUnitPreviewer:new(arg_8_2, arg_8_3, tbl, world, viewport)
	local var_8_5 = callback(arg_8_0, "cb_unit_spawned_unit_preview", var_8_4, arg_8_2)

	var_8_4:register_spawn_callback(var_8_5)
	var_8_4:activate_auto_spin()

	return var_8_4
end

HeroWindowWeaveForgeOverview.cb_unit_spawned_unit_preview = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	print("cb_unit_spawned_unit_preview", arg_9_1, arg_9_2)
end

HeroWindowWeaveForgeOverview.cb_unit_spawned_item_preview = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local flag = true

	arg_10_1:present_item(arg_10_2, flag)
end

HeroWindowWeaveForgeOverview._create_viewport_definition = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local flag

	flag = not arg_11_2 and "environment/ui_weave_forge_preview_inverted" and "environment/ui_weave_forge_preview"

	return {
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 801,
				viewport_type = "default_forward",
				enable_sub_gui = false,
				fov = 20,
				shading_environment = flag,
				world_name = "weave_forge_item_preview_" .. arg_11_1,
				viewport_name = "weave_forge_item_preview_" .. arg_11_1,
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
		scenegraph_id = arg_11_1
	}
end

HeroWindowWeaveForgeOverview.on_exit = function (self, arg_12_1)
	-- function 12
	print("[HeroViewWindow] Exit Substate HeroWindowWeaveForgeOverview")

	self._ui_animator = nil

	if not self._viewports_data then
		local _ui_top_renderer = self._ui_top_renderer

		for i, v in ipairs(self._viewports_data) do
			local item_previewer = v.item_previewer

			if not item_previewer then
				item_previewer:destroy()
			end

			local unit_previewer = v.unit_previewer

			if not unit_previewer then
				unit_previewer:destroy()
			end

			local widget = v.widget

			UIWidget.destroy(_ui_top_renderer, widget)
		end

		self._viewports_data = nil
	end
end

HeroWindowWeaveForgeOverview.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	local window_input_service = self._parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not self._viewports_data then
		for i, v in ipairs(self._viewports_data) do
			local viewport_button = v.viewport_button
			local viewport_button_highlight = v.viewport_button_highlight
			local viewport_button_text_highlight = v.viewport_button_text_highlight
			local item_previewer = v.item_previewer
			local unit_previewer = v.unit_previewer
			local _is_button_hover = self:_is_button_hover(viewport_button)
			local flag_2 = false
			local hover_progress = v.hover_progress

			hover_progress = hover_progress or 0

			local num = 5
			local var_13_11

			if not _is_button_hover then
				hover_progress = math.min(hover_progress + arg_13_1 * num, 1)
			else
				hover_progress = math.max(hover_progress - arg_13_1 * num, 0)
			end

			v.hover_progress = hover_progress

			local ease_out_quad = math.ease_out_quad(hover_progress)

			viewport_button_highlight.alpha_multiplier = ease_out_quad
			viewport_button_text_highlight.alpha_multiplier = ease_out_quad

			local num_2 = 0.12 * ease_out_quad

			if not item_previewer then
				item_previewer:set_zoom_fraction(num_2)
				item_previewer:update(arg_13_1, arg_13_2, not flag_2 and window_input_service)
			end

			if not unit_previewer then
				unit_previewer:set_zoom_fraction(num_2)
				unit_previewer:update(arg_13_1, arg_13_2, not flag_2 and window_input_service)
			end
		end
	end

	local _upgrade_forge_done_time = self._upgrade_forge_done_time

	if not (not _upgrade_forge_done_time and not (_upgrade_forge_done_time < arg_13_2)) then
		local _upgrade_forge_response = self._upgrade_forge_response

		if _upgrade_forge_response ~= nil then
			self:_upgrade_forge_done(_upgrade_forge_response)

			self._upgrade_forge_done_time = nil
			self._upgrade_forge_response = nil
		end
	end

	self:_update_animations(arg_13_1)
	self:_draw(arg_13_1)
end

HeroWindowWeaveForgeOverview.post_update = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not self._viewports_data then
		self:_initialize_viewports()
	end

	if not self._viewports_data then
		for i, v in ipairs(self._viewports_data) do
			local item_previewer = v.item_previewer
			local unit_previewer = v.unit_previewer

			if not item_previewer then
				item_previewer:post_update(arg_14_1, arg_14_2)
			end

			if not unit_previewer then
				unit_previewer:post_update(arg_14_1, arg_14_2)
			end
		end
	end

	self:_handle_input(arg_14_1, arg_14_2)
end

HeroWindowWeaveForgeOverview._update_animations = function (self, arg_15_1)
	-- function 15
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_15_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_15_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	if not self._viewports_data then
		for i, v_3 in ipairs(self._viewports_data) do
			if not v_3.customize_button then
				-- Nothing
			end

			local change_button = v_3.change_button

			if not change_button then
				UIWidgetUtils.animate_icon_button(change_button, arg_15_1)
			end
		end
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.upgrade_button, arg_15_1)
end

HeroWindowWeaveForgeOverview._is_button_pressed = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local content = arg_16_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if button_hotspot.on_pressed or not arg_16_2 or not button_hotspot.on_double_click then
		button_hotspot.on_pressed = false

		if not button_hotspot.is_selected then
			return true
		end
	end
end

HeroWindowWeaveForgeOverview._is_button_hover_enter = function (arg_17_0, arg_17_1)
	-- function 17
	local content = arg_17_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

HeroWindowWeaveForgeOverview._is_button_hover = function (arg_18_0, arg_18_1)
	-- function 18
	local content = arg_18_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	return button_hotspot.is_hover
end

HeroWindowWeaveForgeOverview._is_button_hover_exit = function (arg_19_0, arg_19_1)
	-- function 19
	local content = arg_19_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	local on_hover_exit = button_hotspot.on_hover_exit

	on_hover_exit = not on_hover_exit and not button_hotspot.is_selected

	return on_hover_exit
end

HeroWindowWeaveForgeOverview._is_button_selected = function (arg_20_0, arg_20_1)
	-- function 20
	local content = arg_20_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	return button_hotspot.is_selected
end

HeroWindowWeaveForgeOverview._sync_backend_loadout = function (self)
	-- function 21
	local get_interface = Managers.backend:get_interface("weaves")
	local get_forge_level = get_interface:get_forge_level()
	local forge_max_level = get_interface:forge_max_level()

	self:_set_forge_level(get_forge_level)

	self._forge_level = get_forge_level

	local flag = get_forge_level < forge_max_level
	local var_21_4 = self
	local _set_forge_upgrade_price_by_level = self._set_forge_upgrade_price_by_level
	local flag_2

	flag_2 = not flag and 1 and 0

	_set_forge_upgrade_price_by_level(var_21_4, get_forge_level + flag_2)
	self:_setup_upgrade_tooltip(1)
end

HeroWindowWeaveForgeOverview._handle_input = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local is_device_active = Managers.input:is_device_active("gamepad")
	local window_input_service = self._parent:window_input_service()
	local _params = self._params

	if not self._viewports_data then
		for i, v in ipairs(self._viewports_data) do
			local change_button = v.change_button

			if not change_button and not self:_is_button_hover_enter(change_button) then
				self:_play_sound("Play_hud_hover")
			end

			if not change_button and not self:_is_button_pressed(change_button) then
				local item = v.item
				local slot_name = v.slot_name

				if not item then
					_params.selected_item = item
					_params.selected_slot_name = slot_name

					_parent:set_layout_by_name("weave_weapon_select")

					break
				end
			end

			local viewport_button = v.viewport_button

			if not viewport_button and not self:_is_button_hover_enter(viewport_button) then
				self:_play_sound("menu_magic_forge_hover")
			end

			if not viewport_button and not self:_is_button_pressed(viewport_button) then
				local item_2 = v.item
				local slot_name_2 = v.slot_name
				local unit_name = v.unit_name

				_params.selected_item = item_2
				_params.selected_slot_name = slot_name_2
				_params.selected_unit_name = unit_name

				_parent:set_layout_by_name("weave_properties")

				break
			end
		end
	end

	local upgrade_button = _widgets_by_name.upgrade_button

	if not (not self:_is_button_hover_enter(upgrade_button) and upgrade_button.content.button_hotspot.disable_button) then
		self:_play_sound("Play_hud_hover")
	end

	if not self:_is_button_pressed(upgrade_button) then
		self:_upgrade_forge()
	end
end

HeroWindowWeaveForgeOverview._draw = function (self, arg_23_1)
	-- function 23
	local get_ui_renderer = self._parent:get_ui_renderer()
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _parent = self._parent
	local window_input_service = _parent:window_input_service()
	local _render_settings = self._render_settings
	local hdr_renderer = _parent:hdr_renderer()
	local hdr_top_renderer = _parent:hdr_top_renderer()
	local alpha_multiplier = _render_settings.alpha_multiplier

	UIRenderer.begin_pass(hdr_renderer, _ui_scenegraph, window_input_service, arg_23_1, nil, _render_settings)

	local snap_pixel_positions = _render_settings.snap_pixel_positions

	for i, v in ipairs(self._bottom_hdr_widgets) do
		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(hdr_renderer, v)
	end

	UIRenderer.end_pass(hdr_renderer)
	UIRenderer.begin_pass(hdr_top_renderer, _ui_scenegraph, window_input_service, arg_23_1, nil, _render_settings)

	local snap_pixel_positions_2 = _render_settings.snap_pixel_positions

	for i_2, v_2 in ipairs(self._top_hdr_widgets) do
		local alpha_multiplier_3 = v_2.alpha_multiplier

		alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_3

		UIRenderer.draw_widget(hdr_top_renderer, v_2)
	end

	UIRenderer.end_pass(hdr_top_renderer)
	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_23_1, nil, _render_settings)

	local snap_pixel_positions_3 = _render_settings.snap_pixel_positions

	for i_3, v_3 in ipairs(self._top_widgets) do
		local alpha_multiplier_4 = v_3.alpha_multiplier

		alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_4

		UIRenderer.draw_widget(_ui_top_renderer, v_3)
	end

	UIRenderer.end_pass(_ui_top_renderer)
	UIRenderer.begin_pass(get_ui_renderer, _ui_scenegraph, window_input_service, arg_23_1, nil, _render_settings)

	if not self._viewports_data then
		for i_4, v_4 in ipairs(self._viewports_data) do
			local widget = v_4.widget
			local alpha_multiplier_5 = widget.alpha_multiplier

			alpha_multiplier_5 = alpha_multiplier_5 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_5

			UIRenderer.draw_widget(get_ui_renderer, widget)
		end
	end

	for i_5, v_5 in ipairs(self._bottom_widgets) do
		local alpha_multiplier_6 = v_5.alpha_multiplier

		alpha_multiplier_6 = alpha_multiplier_6 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_6

		UIRenderer.draw_widget(get_ui_renderer, v_5)
	end

	UIRenderer.end_pass(get_ui_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier
end

HeroWindowWeaveForgeOverview._set_forge_upgrade_price_by_level = function (self, arg_24_1)
	-- function 24
	local get_interface = Managers.backend:get_interface("weaves")
	local get_essence = get_interface:get_essence()
	local forge_upgrade_cost = get_interface:forge_upgrade_cost(arg_24_1 - self._forge_level)
	local flag = not forge_upgrade_cost and forge_upgrade_cost <= get_essence or false

	self:_set_essence_upgrade_cost(forge_upgrade_cost, flag)
end

HeroWindowWeaveForgeOverview._upgrade_forge_cb = function (self, arg_25_1)
	-- function 25
	self._upgrade_forge_response = arg_25_1
end

HeroWindowWeaveForgeOverview._upgrade_forge_done = function (self, arg_26_1)
	-- function 26
	self._params.upgrading = nil

	self._parent:unblock_input()

	local upgrade_button = self._widgets_by_name.upgrade_button

	upgrade_button.content.upgrading = false

	if not arg_26_1 then
		self:_play_sound("menu_magic_forge_forge_upgrade")
		self:_sync_backend_loadout()
		Managers.state.event:trigger("weave_forge_upgraded")

		if not self.forge_upgrade_tutorial then
			self.forge_upgrade_tutorial = false
			upgrade_button.content.highlighted = false
			self._ui_animations.upgrade_button_pulse = nil
		end

		local str = "upgrade"
		local var_26_2 = self._animations[str]

		if not var_26_2 then
			self._ui_animator:stop_animation(var_26_2)

			self._animations[str] = nil
		end

		self:_start_transition_animation(str)
	end
end

HeroWindowWeaveForgeOverview._upgrade_forge = function (self)
	-- function 27
	self._params.upgrading = true

	self._parent:block_input()

	self._upgrade_forge_done_time = Managers.time:time("ui") + num
	self._upgrade_forge_response = nil
	self._widgets_by_name.upgrade_button.content.upgrading = true

	local num_2 = 1
	local get_interface = Managers.backend:get_interface("weaves")
	local var_27_2 = callback(self, "_upgrade_forge_cb")

	get_interface:upgrade_forge(num_2, var_27_2)
end

HeroWindowWeaveForgeOverview._setup_upgrade_tooltip = function (self, arg_28_1)
	-- function 28
	local upgrade_button = self._widgets_by_name.upgrade_button
	local var_28_1
	local get_interface = Managers.backend:get_interface("weaves")
	local get_forge_level = get_interface:get_forge_level()
	local forge_max_level = get_interface:forge_max_level()
	local num = get_forge_level + arg_28_1

	if num <= forge_max_level then
		var_28_1 = {
			title = string.format(Localize("menu_weave_forge_tooltip_upgrade_athanor_title"), num),
			sub_title = string.format(Localize("menu_weave_forge_tooltip_upgrade_item_description"), forge_max_level),
			divider_description = Localize("menu_weave_forge_tooltip_upgrade_athanor_description"),
			upgrade_effect_title = Localize("menu_weave_forge_tooltip_upgrade_item_effect_title")
		}

		local get_interface_2 = Managers.backend:get_interface("weaves")
		local var_28_7
		local properties = WeaveProperties.properties

		for k, v in pairs(properties) do
			local get_property_required_forge_level = get_interface_2:get_property_required_forge_level(k)

			get_property_required_forge_level = get_property_required_forge_level or 0

			if not (not (get_forge_level < get_property_required_forge_level) or not (get_property_required_forge_level <= num)) then
				local icon = v.icon

				icon = icon or "icons_placeholder"

				local get_property_mastery_costs = get_interface_2:get_property_mastery_costs(k)
				local get_weave_property_description = UIUtils.get_weave_property_description(k, v, get_property_mastery_costs)

				var_28_7 = var_28_7 or {}
				var_28_7[#var_28_7 + 1] = {
					text = get_weave_property_description,
					icon = icon,
					required_forge_level = get_property_required_forge_level
				}
			end
		end

		if not var_28_7 then
			table.sort(var_28_7, function (self, arg_29_1)
				-- function 29
				local required_forge_level = self.required_forge_level
				local required_forge_level_2 = arg_29_1.required_forge_level

				if required_forge_level == required_forge_level_2 then
					return self.text <= arg_29_1.text
				end

				return required_forge_level < required_forge_level_2
			end)
		end

		var_28_1.property_unlock_table = var_28_7

		local var_28_13
		local traits = WeaveTraits.traits

		for k_2, v_2 in pairs(traits) do
			local get_trait_required_forge_level = get_interface_2:get_trait_required_forge_level(k_2)

			get_trait_required_forge_level = get_trait_required_forge_level or 0

			if not (not (get_forge_level < get_trait_required_forge_level) or not (get_trait_required_forge_level <= num)) then
				local display_name = v_2.display_name
				local icon_2 = v_2.icon
				local var_28_18 = Localize(display_name)

				var_28_13 = var_28_13 or {}
				var_28_13[#var_28_13 + 1] = {
					text = var_28_18,
					icon = icon_2,
					required_forge_level = get_trait_required_forge_level
				}
			end
		end

		if not var_28_13 then
			table.sort(var_28_13, function (self, arg_30_1)
				-- function 30
				local required_forge_level = self.required_forge_level
				local required_forge_level_2 = arg_30_1.required_forge_level

				if required_forge_level == required_forge_level_2 then
					return self.text <= arg_30_1.text
				end

				return required_forge_level < required_forge_level_2
			end)
		end

		var_28_1.trait_unlock_table = var_28_13
	end

	upgrade_button.content.tooltip = var_28_1
end

HeroWindowWeaveForgeOverview._set_essence_upgrade_cost = function (self, arg_31_1, arg_31_2)
	-- function 31
	local upgrade_button = self._widgets_by_name.upgrade_button
	local content = upgrade_button.content
	local style = upgrade_button.style
	local _ui_top_renderer = self._ui_top_renderer
	local str = ""
	local num = 0
	local num_2 = 0

	if not arg_31_1 then
		num_2 = 15

		local num_3 = 170
		local comma_value = UIUtils.comma_value(arg_31_1)

		str = Localize("menu_weave_forge_upgrade_button") .. " " .. comma_value
		num = math.min(UIUtils.get_text_width(_ui_top_renderer, style.title_text, str), num_3)

		local var_31_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(content.price_icon).size[1]
		local num_4 = 0
		local num_5 = -((var_31_9 + num + num_4) / 2 - (num / 2 + 5))

		style.title_text.offset[1] = style.title_text.default_offset[1] + num_5
		style.title_text_shadow.offset[1] = style.title_text_shadow.default_offset[1] + num_5
		style.title_text_disabled.offset[1] = style.title_text_disabled.default_offset[1] + num_5
		style.price_icon.offset[1] = style.title_text.offset[1] + num / 2 + num_4
		style.price_icon_disabled.offset[1] = style.price_icon.offset[1]
		style.price_icon.color[1] = 255
		style.price_icon_disabled.color[1] = 255
		self._can_upgrade = true
	else
		num_2 = 23

		local num_6 = 200

		str = Localize("menu_weave_forge_upgrade_loadout_button_cap")
		num = math.min(UIUtils.get_text_width(_ui_top_renderer, style.title_text, str), num_6)
		style.title_text.offset[1] = style.title_text.default_offset[1]
		style.title_text_shadow.offset[1] = style.title_text_shadow.default_offset[1]
		style.title_text_disabled.offset[1] = style.title_text_disabled.default_offset[1]
		style.price_icon.color[1] = 0
		style.price_icon_disabled.color[1] = 0
		self._can_upgrade = false
	end

	local num_7 = num_2 + (content.size[1] / 2 - num / 2)
	local button_hotspot = content.button_hotspot
	local read_only_backend = GameSettingsDevelopment.read_only_backend

	read_only_backend = (read_only_backend or not arg_31_1) and not arg_31_2
	button_hotspot.disable_button = read_only_backend
	content.title_text = str
	style.title_text.size[1] = num
	style.title_text_shadow.size[1] = num
	style.title_text_disabled.size[1] = num
	style.title_text.offset[1] = num_7
	style.title_text_shadow.offset[1] = num_7
	style.title_text_disabled.offset[1] = num_7
end

HeroWindowWeaveForgeOverview._set_forge_level = function (self, arg_32_1)
	-- function 32
	local _widgets_by_name = self._widgets_by_name
	local forge_level_title = _widgets_by_name.forge_level_title
	local forge_level_text = _widgets_by_name.forge_level_text

	forge_level_text.content.text = arg_32_1

	local _ui_top_renderer = self._ui_top_renderer
	local min = math.min(170, UIUtils.get_text_width(_ui_top_renderer, forge_level_title.style.text, forge_level_title.content.text))
	local min_2 = math.min(30, UIUtils.get_text_width(_ui_top_renderer, forge_level_text.style.text, forge_level_text.content.text))
	local _ui_scenegraph = self._ui_scenegraph

	_ui_scenegraph[forge_level_title.scenegraph_id].size[1] = min + 5
	_ui_scenegraph[forge_level_text.scenegraph_id].size[1] = min_2 + 5

	local num = 10
	local num_2 = -((min + min_2 + num) / 2 - min / 2)

	forge_level_title.style.text.offset[1] = num_2
	forge_level_title.style.text_shadow.offset[1] = num_2
	forge_level_text.style.text.offset[1] = num_2 + min / 2 + min_2 / 2 + num
	forge_level_text.style.text_shadow.offset[1] = forge_level_text.style.text.offset[1]
end
