-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_weave_forge_panel.lua

require("scripts/ui/views/menu_world_previewer")
require("scripts/helpers/weave_utils")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_panel_definitions")
local top_widgets = var_0_0.top_widgets
local bottom_widgets = var_0_0.bottom_widgets
local bottom_hdr_widgets = var_0_0.bottom_hdr_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false

HeroWindowWeaveForgePanel = class(HeroWindowWeaveForgePanel)
HeroWindowWeaveForgePanel.NAME = "HeroWindowWeaveForgePanel"

HeroWindowWeaveForgePanel.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowWeaveForgePanel")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._wwise_world = ingame_ui_context.wwise_world
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._ingame_ui_context = ingame_ui_context

	local input = Managers.input
	local tbl = {
		wwise_world = self._wwise_world,
		ui_renderer = self._ui_renderer,
		ui_top_renderer = self._ui_top_renderer,
		input_manager = input
	}

	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	local hero_name = arg_1_1.hero_name
	local career_index = arg_1_1.career_index
	local profile_index = arg_1_1.profile_index

	self._career_name = SPProfiles[profile_index].careers[career_index].name
	self._hero_name = hero_name
end

HeroWindowWeaveForgePanel._start_transition_animation = function (self, arg_2_1, arg_2_2)
	-- function 2
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_2_2, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowWeaveForgePanel._setup_definitions = function (self)
	-- function 3
	if not self._parent:gamepad_style_active() then
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_panel_console_definitions")
	else
		var_0_0 = dofile("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_panel_definitions")
	end

	top_widgets = var_0_0.top_widgets
	bottom_widgets = var_0_0.bottom_widgets
	bottom_hdr_widgets = var_0_0.bottom_hdr_widgets
	scenegraph_definition = var_0_0.scenegraph_definition
	animation_definitions = var_0_0.animation_definitions
end

HeroWindowWeaveForgePanel.create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_setup_definitions()

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(top_widgets) do
		local var_4_2 = UIWidget.init(v)

		tbl_2[#tbl_2 + 1] = var_4_2
		tbl[k] = var_4_2
	end

	local tbl_3 = {}

	for k_2, v_2 in pairs(bottom_widgets) do
		local var_4_4 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_4_4
		tbl[k_2] = var_4_4
	end

	local tbl_4 = {}

	for k_3, v_3 in pairs(bottom_hdr_widgets) do
		local var_4_6 = UIWidget.init(v_3)

		tbl_4[#tbl_4 + 1] = var_4_6
		tbl[k_3] = var_4_6
	end

	self._top_widgets = tbl_2
	self._bottom_widgets = tbl_3
	self._bottom_hdr_widgets = tbl_4
	self._widgets_by_name = tbl
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end

	self:_setup_essence_tooltip()
	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)
end

HeroWindowWeaveForgePanel._setup_essence_tooltip = function (self)
	-- function 5
	local _top_widgets = self._top_widgets
	local _widgets_by_name = self._widgets_by_name
	local comma_value = UIUtils.comma_value(0)
	local comma_value_2 = UIUtils.comma_value(0)
	local format = string.format(Localize("menu_weave_forge_tooltip_essence_description_total"), comma_value, comma_value_2)
	local str = "essence_panel"
	local size = scenegraph_definition[str].size
	local tbl = {
		"weave_progression_slot_titles"
	}
	local tbl_2 = {
		title = Localize("menu_weave_forge_tooltip_essence_title"),
		description = Localize("menu_weave_forge_tooltip_essence_description"),
		divider_description = Localize("menu_weave_forge_tooltip_essence_description_base_game"),
		essence_title = Localize("menu_weave_forge_tooltip_essence_description_total_title"),
		input_highlight = format
	}
	local num = 400
	local flag = true
	local var_5_11
	local var_5_12
	local tbl_3 = {
		96,
		0,
		0
	}
	local create_additional_option_tooltip = UIWidgets.create_additional_option_tooltip(str, size, tbl, tbl_2, num, var_5_11, var_5_12, flag, tbl_3)
	local var_5_15 = UIWidget.init(create_additional_option_tooltip)

	_top_widgets[#_top_widgets + 1] = var_5_15
	_widgets_by_name.essence_tooltip = var_5_15
end

HeroWindowWeaveForgePanel._set_essence_tooltip_amounts = function (self, arg_6_1, arg_6_2)
	-- function 6
	local tooltip = self._widgets_by_name.essence_tooltip.content.tooltip
	local comma_value = UIUtils.comma_value(arg_6_1)
	local comma_value_2 = UIUtils.comma_value(arg_6_2)
	local format = string.format(Localize("menu_weave_forge_tooltip_essence_description_total"), comma_value, comma_value_2)

	tooltip.title = Localize("menu_weave_forge_tooltip_essence_title")
	tooltip.description = Localize("menu_weave_forge_tooltip_essence_description")
	tooltip.divider_description = Localize("menu_weave_forge_tooltip_essence_description_base_game")
	tooltip.essence_title = Localize("menu_weave_forge_tooltip_essence_description_total_title")
	tooltip.input_highlight = format
end

HeroWindowWeaveForgePanel.on_exit = function (self, arg_7_1)
	-- function 7
	print("[HeroViewWindow] Exit Substate HeroWindowWeaveForgePanel")

	self._ui_animator = nil

	local world = Managers.world:world("level_world")
	local current_level = LevelHelper:current_level(world)

	Level.trigger_event(current_level, "lua_keep_vom_magic_forge_on_exit")
end

HeroWindowWeaveForgePanel._set_loadout_power = function (arg_8_0, arg_8_1)
	-- function 8
	arg_8_0._widgets_by_name.loadout_power_text.content.text = arg_8_1
end

HeroWindowWeaveForgePanel._set_essence_amount = function (self, arg_9_1)
	-- function 9
	local _widgets_by_name = self._widgets_by_name
	local essence_text = _widgets_by_name.essence_text
	local essence_icon = _widgets_by_name.essence_icon
	local comma_value = UIUtils.comma_value(arg_9_1)

	essence_text.content.text = comma_value

	local _ui_top_renderer = self._ui_top_renderer
	local get_text_width = UIUtils.get_text_width(_ui_top_renderer, essence_text.style.text, comma_value)
	local var_9_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(essence_icon.content.texture_id).size[1]
	local num = 0
	local num_2 = var_9_6 + get_text_width + num

	essence_icon.offset[1] = -(num_2 / 2 - var_9_6 / 2 + 5)
	essence_text.offset[1] = essence_icon.offset[1] + var_9_6 / 2 + get_text_width / 2 + num

	return comma_value
end

HeroWindowWeaveForgePanel._sync_backend_loadout = function (self)
	-- function 10
	local _career_name = self._career_name
	local get_interface = Managers.backend:get_interface("weaves")
	local get_essence = get_interface:get_essence()
	local get_maximum_essence = get_interface:get_maximum_essence()
	local get_total_essence = get_interface:get_total_essence()

	self._current_essence_amount = get_essence
	self._essence_value_string = self:_set_essence_amount(math.min(get_essence, get_maximum_essence))

	self:_set_essence_tooltip_amounts(math.min(get_total_essence, get_maximum_essence), get_maximum_essence)

	local get_average_power_level = get_interface:get_average_power_level(_career_name)
	local presentable_hero_power_level_weaves = UIUtils.presentable_hero_power_level_weaves(get_average_power_level)

	self:_set_loadout_power(presentable_hero_power_level_weaves)
end

HeroWindowWeaveForgePanel._is_button_pressed = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		if not button_hotspot.is_selected then
			return true
		end
	end
end

HeroWindowWeaveForgePanel._handle_input = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	return
end

HeroWindowWeaveForgePanel._play_sound = function (self, arg_13_1)
	-- function 13
	self._parent:play_sound(arg_13_1)
end

HeroWindowWeaveForgePanel.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	local get_essence = Managers.backend:get_interface("weaves"):get_essence()
	local get_selected_layout_name = self._parent:get_selected_layout_name()

	if not (get_selected_layout_name ~= self._selected_layout_name or get_essence == self._current_essence_amount) then
		self:_sync_component_visibilty_by_layout(get_selected_layout_name)

		self._selected_layout_name = get_selected_layout_name

		self:_sync_backend_loadout()
	end

	self:_handle_input(arg_14_1, arg_14_2)
	self:_update_animations(arg_14_1)
	self:_draw(arg_14_1)
end

HeroWindowWeaveForgePanel._sync_component_visibilty_by_layout = function (self, arg_15_1)
	-- function 15
	local _ui_scenegraph = self._ui_scenegraph
	local _widgets_by_name = self._widgets_by_name

	if arg_15_1 == "weave_overview" then
		local flag = true

		_widgets_by_name.loadout_power_title.content.visible = flag
		_widgets_by_name.loadout_power_text.content.visible = flag
		_widgets_by_name.top_corner_right.content.visible = flag
		_widgets_by_name.loadout_power_tooltip.content.visible = flag
		_widgets_by_name.bottom_panel_left.content.visible = flag
		_widgets_by_name.bottom_panel_right.content.visible = flag
	else
		local flag_2 = false

		_widgets_by_name.loadout_power_title.content.visible = flag_2
		_widgets_by_name.loadout_power_text.content.visible = flag_2
		_widgets_by_name.loadout_power_tooltip.content.visible = flag_2
		_widgets_by_name.bottom_panel_left.content.visible = flag_2
		_widgets_by_name.bottom_panel_right.content.visible = flag_2
		_widgets_by_name.top_corner_right.content.visible = arg_15_1 ~= "weave_properties"
	end

	local flag_3 = arg_15_1 ~= "weave_properties"

	self:_set_background_wheel_visibility(flag_3)
end

HeroWindowWeaveForgePanel.post_update = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	return
end

HeroWindowWeaveForgePanel._update_animations = function (self, arg_17_1)
	-- function 17
	local upgrading = self._params.upgrading
	local _upgrading_anim_progress = self._upgrading_anim_progress

	_upgrading_anim_progress = _upgrading_anim_progress or 0

	local num = 3

	if not upgrading then
		_upgrading_anim_progress = math.min(_upgrading_anim_progress + arg_17_1 * num, 1)
	else
		_upgrading_anim_progress = math.max(_upgrading_anim_progress - arg_17_1 * num, 0)
	end

	self._upgrading_anim_progress = _upgrading_anim_progress

	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_17_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_17_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	if not self._draw_background_wheel then
		self:_update_background_animations(arg_17_1)
	end
end

HeroWindowWeaveForgePanel._draw = function (self, arg_18_1)
	-- function 18
	local _parent = self._parent
	local get_ui_renderer = _parent:get_ui_renderer()
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local window_input_service = _parent:window_input_service()
	local hdr_renderer = _parent:hdr_renderer()

	UIRenderer.begin_pass(hdr_renderer, _ui_scenegraph, window_input_service, arg_18_1, nil, _render_settings)

	local snap_pixel_positions = _render_settings.snap_pixel_positions
	local alpha_multiplier = _render_settings.alpha_multiplier

	for i, v in ipairs(self._bottom_hdr_widgets) do
		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(hdr_renderer, v)
	end

	UIRenderer.end_pass(hdr_renderer)
	UIRenderer.begin_pass(get_ui_renderer, _ui_scenegraph, window_input_service, arg_18_1, nil, _render_settings)

	local alpha_multiplier_3 = _render_settings.alpha_multiplier

	for i_2, v_2 in ipairs(self._bottom_widgets) do
		local alpha_multiplier_4 = v_2.alpha_multiplier

		alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier_3
		_render_settings.alpha_multiplier = alpha_multiplier_4

		UIRenderer.draw_widget(get_ui_renderer, v_2)
	end

	UIRenderer.end_pass(get_ui_renderer)
	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_18_1, nil, _render_settings)

	for i_3, v_3 in ipairs(self._top_widgets) do
		local alpha_multiplier_5 = v_3.alpha_multiplier

		alpha_multiplier_5 = alpha_multiplier_5 or alpha_multiplier_3
		_render_settings.alpha_multiplier = alpha_multiplier_5

		UIRenderer.draw_widget(_ui_top_renderer, v_3)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

HeroWindowWeaveForgePanel._set_background_bloom_intensity = function (self, arg_19_1)
	-- function 19
	local num = 1.39
	local num_2 = 2 + 30 * self._upgrading_anim_progress
	local num_3 = num + math.clamp(arg_19_1, 0, 1) * num_2
	local gui = self._parent:hdr_renderer().gui
	local _widgets_by_name = self._widgets_by_name
	local texture_id = _widgets_by_name.hdr_background_wheel_1.content.texture_id
	local material = Gui.material(gui, texture_id)

	Material.set_scalar(material, "noise_intensity", num_3)

	for i = 1, 2 do
		local var_19_7 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_1"]
		local var_19_8 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_2"]
		local var_19_9 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_3"]
		local texture_id_2 = var_19_7.content.texture_id
		local texture_id_3 = var_19_8.content.texture_id
		local texture_id_4 = var_19_9.content.texture_id
		local material_2 = Gui.material(gui, texture_id_2)
		local material_3 = Gui.material(gui, texture_id_3)
		local material_4 = Gui.material(gui, texture_id_4)

		Material.set_scalar(material_2, "noise_intensity", num_3)
		Material.set_scalar(material_3, "noise_intensity", num_3)
		Material.set_scalar(material_4, "noise_intensity", num_3)
	end
end

HeroWindowWeaveForgePanel._set_background_wheel_visibility = function (self, arg_20_1)
	-- function 20
	local _widgets_by_name = self._widgets_by_name
	local background_wheel_1 = _widgets_by_name.background_wheel_1
	local hdr_background_wheel_1 = _widgets_by_name.hdr_background_wheel_1

	background_wheel_1.content.visible = arg_20_1
	hdr_background_wheel_1.content.visible = arg_20_1

	for i = 1, 2 do
		local var_20_3 = _widgets_by_name["wheel_ring_" .. i .. "_1"]
		local var_20_4 = _widgets_by_name["wheel_ring_" .. i .. "_2"]
		local var_20_5 = _widgets_by_name["wheel_ring_" .. i .. "_3"]
		local var_20_6 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_1"]
		local var_20_7 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_2"]
		local var_20_8 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_3"]

		var_20_3.content.visible = arg_20_1
		var_20_4.content.visible = arg_20_1
		var_20_5.content.visible = arg_20_1
		var_20_6.content.visible = arg_20_1
		var_20_7.content.visible = arg_20_1
		var_20_8.content.visible = arg_20_1
	end

	self._draw_background_wheel = arg_20_1
end

HeroWindowWeaveForgePanel._update_background_animations = function (self, arg_21_1)
	-- function 21
	local _widgets_by_name = self._widgets_by_name

	for i = 1, 2 do
		local var_21_1 = _widgets_by_name["wheel_ring_" .. i .. "_1"]
		local var_21_2 = _widgets_by_name["wheel_ring_" .. i .. "_2"]
		local var_21_3 = _widgets_by_name["wheel_ring_" .. i .. "_3"]
		local var_21_4 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_1"]
		local var_21_5 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_2"]
		local var_21_6 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_3"]
		local num = 360
		local degrees_to_radians = math.degrees_to_radians(num)
		local num_2 = 1 + 4 * self._upgrading_anim_progress
		local num_3 = arg_21_1 * 0.01 * num_2
		local num_4 = arg_21_1 * 0.008 * num_2
		local num_5 = arg_21_1 * 0.006 * num_2

		var_21_1.style.texture_id.angle = (var_21_1.style.texture_id.angle + degrees_to_radians * num_3) % degrees_to_radians
		var_21_2.style.texture_id.angle = (var_21_2.style.texture_id.angle - degrees_to_radians * num_4) % -degrees_to_radians
		var_21_3.style.texture_id.angle = (var_21_3.style.texture_id.angle + degrees_to_radians * num_5) % degrees_to_radians
		var_21_4.style.texture_id.angle = var_21_1.style.texture_id.angle
		var_21_5.style.texture_id.angle = var_21_2.style.texture_id.angle
		var_21_6.style.texture_id.angle = var_21_3.style.texture_id.angle
	end

	local num_6 = 2.5
	local num_7 = 0.5 + math.sin(Managers.time:time("ui") * num_6) * 0.5

	self:_set_background_bloom_intensity(num_7)
end
