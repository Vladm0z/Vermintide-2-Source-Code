-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_info.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_info_definitions")
local create_objective_widget = var_0_0.create_objective_widget
local top_widgets = var_0_0.top_widgets
local bottom_widgets = var_0_0.bottom_widgets
local bottom_hdr_widgets = var_0_0.bottom_hdr_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false
local num = 1.5

StartGameWindowWeaveInfo = class(StartGameWindowWeaveInfo)
StartGameWindowWeaveInfo.NAME = "StartGameWindowWeaveInfo"

StartGameWindowWeaveInfo.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveInfo")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui = ingame_ui_context.ingame_ui
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._network_lobby = ingame_ui_context.network_lobby
	self._is_server = ingame_ui_context.is_server
	self._is_in_inn = ingame_ui_context.is_in_inn
	self._ui_hdr_renderer = self._parent:hdr_renderer()
	self._my_player = ingame_ui_context.player

	local local_player = Managers.player:local_player()

	if not local_player then
		self._stats_id = local_player:stats_id()
	end

	self._enable_play = false
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_start_transition_animation("on_enter")
end

StartGameWindowWeaveInfo._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_2_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowWeaveInfo._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(top_widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl_2[#tbl_2 + 1] = var_3_2
		tbl[k] = var_3_2
	end

	local tbl_3 = {}

	for k_2, v_2 in pairs(bottom_widgets) do
		local var_3_4 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_3_4
		tbl[k_2] = var_3_4
	end

	local tbl_4 = {}

	for k_3, v_3 in pairs(bottom_hdr_widgets) do
		local var_3_6 = UIWidget.init(v_3)

		tbl_4[#tbl_4 + 1] = var_3_6
		tbl[k_3] = var_3_6
	end

	self._top_widgets = tbl_2
	self._bottom_widgets = tbl_3
	self._bottom_hdr_widgets = tbl_4
	self._widgets_by_name = tbl

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local is_private_option_enabled = self._parent:is_private_option_enabled()

	tbl.private_checkbox.content.button_hotspot.is_selected = is_private_option_enabled
	tbl.play_button.content.button_hotspot.disable_button = true

	self:_align_private_checkbox()
	self:_setup_input_buttons()
end

StartGameWindowWeaveInfo._setup_input_buttons = function (self)
	-- function 4
	local window_input_service = self._parent:window_input_service()
	local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, "refresh_press", true)
	local play_button_console = self._widgets_by_name.play_button_console
	local input_texture = play_button_console.style.input_texture

	input_texture.horizontal_alignment = "center"
	input_texture.vertical_alignment = "center"
	input_texture.texture_size = {
		get_gamepad_input_texture_data.size[1],
		get_gamepad_input_texture_data.size[2]
	}
	play_button_console.content.input_texture = get_gamepad_input_texture_data.texture
end

StartGameWindowWeaveInfo.on_exit = function (self, arg_5_1)
	-- function 5
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveInfo")

	self._ui_animator = nil
end

StartGameWindowWeaveInfo.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	self:_update_can_play()
	self:_handle_gamepad_activity()
	self:_update_selected_weave()
	self:_update_animations(arg_6_1)
	self:_update_party_status(arg_6_1)
	self:_handle_input(arg_6_1, arg_6_2)
	self:draw(arg_6_1)
end

StartGameWindowWeaveInfo._handle_gamepad_activity = function (self)
	-- function 7
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("gamepad") then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			local _widgets_by_name = self._widgets_by_name

			_widgets_by_name.play_button.content.visible = false
			_widgets_by_name.play_button_console.content.visible = true
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		local _widgets_by_name_2 = self._widgets_by_name

		_widgets_by_name_2.play_button.content.visible = true
		_widgets_by_name_2.play_button_console.content.visible = false
	end
end

StartGameWindowWeaveInfo._update_can_play = function (self)
	-- function 8
	local _widgets_by_name = self._widgets_by_name
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local _is_matchmaking = self._is_matchmaking

	self._is_matchmaking = is_game_matchmaking

	if is_game_matchmaking ~= _is_matchmaking then
		if not is_game_matchmaking then
			_widgets_by_name.play_button.content.button_hotspot.disable_button = true

			self._parent:set_input_description("cancel_matchmaking_lock")
		else
			self._parent:set_input_description("play_available_lock")
		end
	end

	local play_button_console = self._widgets_by_name.play_button_console

	if not is_game_matchmaking then
		play_button_console.content.text = Localize("cancel_matchmaking")

		if not self._is_server then
			play_button_console.content.locked = false
		else
			play_button_console.content.locked = true
		end
	elseif not self._selected_weave_name and not LevelUnlockUtils.weave_disabled(self._selected_weave_name) then
		_widgets_by_name.play_button.content.button_hotspot.disable_button = true
		_widgets_by_name.play_button.content.locked = true
		play_button_console.content.locked = true
	else
		play_button_console.content.locked = false
		_widgets_by_name.play_button.content.button_hotspot.disable_button = false
		_widgets_by_name.play_button.content.locked = false
		play_button_console.content.text = Localize("start_game_window_play")
	end
end

StartGameWindowWeaveInfo.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

StartGameWindowWeaveInfo._update_animations = function (self, arg_10_1)
	-- function 10
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_10_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_10_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	self:_update_wind_icon_animation(arg_10_1)

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.play_button, arg_10_1)
	UIWidgetUtils.animate_default_button(_widgets_by_name.private_checkbox, arg_10_1)
end

StartGameWindowWeaveInfo._is_button_pressed = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowWeaveInfo._is_button_released = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowWeaveInfo._is_stepper_button_pressed = function (arg_13_0, arg_13_1)
	-- function 13
	local content = arg_13_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = false

		return true, -1
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = false

		return true, 1
	end
end

StartGameWindowWeaveInfo._is_button_hover_enter = function (arg_14_0, arg_14_1)
	-- function 14
	return arg_14_1.content.button_hotspot.on_hover_enter
end

StartGameWindowWeaveInfo._is_button_hover_exit = function (arg_15_0, arg_15_1)
	-- function 15
	return arg_15_1.content.button_hotspot.on_hover_exit
end

StartGameWindowWeaveInfo._is_button_selected = function (arg_16_0, arg_16_1)
	-- function 16
	return arg_16_1.content.button_hotspot.is_selected
end

StartGameWindowWeaveInfo._handle_input = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local is_device_active = Managers.input:is_device_active("gamepad")
	local window_input_service = self._parent:window_input_service()
	local play_button = _widgets_by_name.play_button
	local private_checkbox = _widgets_by_name.private_checkbox

	if not self:_is_button_hover_enter(play_button) then
		self:_play_sound("Play_hud_hover")
	end

	local flag = not is_device_active and window_input_service:get("right_stick_press")

	if self:_is_button_released(private_checkbox) or not flag then
		local content = private_checkbox.content

		content.button_hotspot.is_selected = not content.button_hotspot.is_selected

		_parent:set_private_option_enabled(content.button_hotspot.is_selected)
		self:_play_sound("play_gui_lobby_button_play")
	end

	if not is_device_active then
		-- Nothing
	end

	::label_17_0::

	local _enable_play = self._enable_play

	_enable_play = not _enable_play and window_input_service:get("refresh_press")

	::label_17_1::

	if self:_is_button_released(play_button) or not _enable_play then
		_parent:play(arg_17_2, "weave")
		self:_play_sound("menu_wind_level_choose_wind")
	end
end

local tbl = {
	Localize("menu_weave_play_find_party"),
	(Localize("menu_weave_play_find_party_cancel"))
}

StartGameWindowWeaveInfo._update_party_status = function (self, arg_18_1)
	-- function 18
	local matchmaking = Managers.matchmaking
	local is_game_matchmaking = matchmaking:is_game_matchmaking()
	local active_game_mode = matchmaking:active_game_mode()
	local flag = not active_game_mode and active_game_mode == "weave"
	local flag_2 = not is_game_matchmaking and flag

	self._is_matchmaking_for_weave = flag_2

	local content = self._widgets_by_name.play_button.content
	local button_hotspot = content.button_hotspot

	if not content.locked then
		button_hotspot.disable_button = flag_2
	end
end

StartGameWindowWeaveInfo._play_sound = function (self, arg_19_1)
	-- function 19
	self._parent:play_sound(arg_19_1)
end

StartGameWindowWeaveInfo._update_selected_weave = function (self)
	-- function 20
	local selected_weave_template = self._params.selected_weave_template

	if not selected_weave_template then
		local get_selected_weave_id = self._parent:get_selected_weave_id()

		selected_weave_template = WeaveSettings.templates_ordered[get_selected_weave_id]
	end

	local _widgets_by_name = self._widgets_by_name

	if not selected_weave_template then
		local name = selected_weave_template.name

		if not (not name and name == self._selected_weave_name) then
			self._selected_weave_name = name

			local objectives = selected_weave_template.objectives
			local display_name = selected_weave_template.display_name

			_widgets_by_name.title.content.text = display_name

			local level_id = objectives[1].level_id
			local display_name_2 = LevelSettings[level_id].display_name

			_widgets_by_name.level_title.content.text = display_name_2

			local wind = selected_weave_template.wind
			local var_20_9 = WindSettings[wind]
			local wind_title = _widgets_by_name.wind_title
			local wind_icon = _widgets_by_name.wind_icon

			wind_title.content.text = var_20_9.lore_display_name

			self:_set_wind_icon_by_name(wind)
			self:_set_colors_by_wind(wind)

			local mutator = var_20_9.mutator
			local var_20_13 = MutatorTemplates[mutator]
			local mutator_icon = _widgets_by_name.mutator_icon
			local mutator_title_text = _widgets_by_name.mutator_title_text
			local mutator_description_text = _widgets_by_name.mutator_description_text

			mutator_icon.content.texture_id = var_20_13.icon
			mutator_title_text.content.text = var_20_13.display_name
			mutator_description_text.content.text = var_20_13.description

			local num = 10
			local num_2 = 0
			local str = "objective"
			local size = scenegraph_definition[str].size
			local var_20_21 = create_objective_widget(str, size)
			local tbl = {}

			for i = 1, #objectives do
				local var_20_23 = UIWidget.init(var_20_21)

				tbl[#tbl + 1] = var_20_23

				local var_20_24 = objectives[i]
				local flag = var_20_24.conflict_settings == "weave_disabled"
				local flag_2

				flag_2 = not flag and "menu_weave_play_next_end_event_title" and "menu_weave_play_main_objective_title"

				local display_name_3 = var_20_24.display_name
				local flag_3

				flag_3 = not flag and "objective_icon_boss" and "objective_icon_general"

				local _assign_objective = self:_assign_objective(var_20_23, flag_2, display_name_3, flag_3, num)

				var_20_23.offset[2] = -num_2
				num_2 = num_2 + _assign_objective + num
			end

			self._objective_widgets = tbl
		end

		if not _widgets_by_name.play_button.content.locked then
			_widgets_by_name.play_button.content.button_hotspot.disable_button = false
		end
	end
end

StartGameWindowWeaveInfo._update_wind_icon_animation = function (self, arg_21_1)
	-- function 21
	local _wind_icon_animation_time = self._wind_icon_animation_time

	if not _wind_icon_animation_time then
		return
	end

	local max = math.max(_wind_icon_animation_time - arg_21_1, 0)
	local clamp = math.clamp(1 - max / num, 0, 1)
	local lerp = math.lerp(0, 1, clamp)
	local wind_icon = self._widgets_by_name.wind_icon
	local gui = self._ui_hdr_renderer.gui
	local texture_id = wind_icon.content.texture_id
	local material = Gui.material(gui, texture_id)

	Material.set_scalar(material, "progress", lerp)

	local easeInCubic = math.easeInCubic(clamp)

	wind_icon.style.texture_id.color[1] = 255 * easeInCubic

	if clamp == 1 then
		self._wind_icon_animation_time = nil
	else
		self._wind_icon_animation_time = max
	end
end

local tbl_2 = {
	shadow = 2,
	fire = 4,
	beasts = 5,
	life = 0,
	death = 3,
	light = 6,
	heavens = 1,
	metal = 7
}

StartGameWindowWeaveInfo._set_wind_icon_by_name = function (self, arg_22_1)
	-- function 22
	local wind_icon = self._widgets_by_name.wind_icon
	local var_22_1 = tbl_2[arg_22_1]
	local gui = self._ui_renderer.gui
	local gui_2 = self._ui_hdr_renderer.gui
	local texture_id = wind_icon.content.texture_id
	local material = Gui.material(gui_2, texture_id)

	Material.set_scalar(material, "texture_index", var_22_1)

	self._wind_icon_animation_time = num
end

StartGameWindowWeaveInfo._set_colors_by_wind = function (self, arg_23_1)
	-- function 23
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(arg_23_1, 255)
	local _widgets_by_name = self._widgets_by_name

	self:_apply_color_values(_widgets_by_name.wind_title.style.text.text_color, get_color_table_with_alpha)
	self:_apply_color_values(_widgets_by_name.wind_icon.style.texture_id.color, get_color_table_with_alpha)
end

StartGameWindowWeaveInfo._align_private_checkbox = function (self)
	-- function 24
	local is_device_active = Managers.input:is_device_active("gamepad")
	local private_checkbox = self._widgets_by_name.private_checkbox
	local content = private_checkbox.content
	local offset = private_checkbox.offset
	local style = private_checkbox.style
	local button_hotspot = content.button_hotspot
	local size = style.button_hotspot.size
	local text = style.text
	local var_24_8 = text.offset[1]
	local _ui_renderer = self._ui_renderer
	local num = var_24_8 + UIUtils.get_text_width(_ui_renderer, text, button_hotspot.text)

	offset[1] = -num / 2

	local flag

	flag = not is_device_active and 40 and 0
	offset[2] = flag

	local additional_option_info = style.additional_option_info
	local max_width = additional_option_info.max_width

	additional_option_info.offset[1] = -(max_width / 2 - num / 2)
	size[1] = num
end

StartGameWindowWeaveInfo._apply_color_values = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	arg_25_3 = arg_25_3 or 1

	if not arg_25_4 then
		arg_25_1[1] = arg_25_2[1]
	end

	arg_25_1[2] = math.floor(arg_25_2[2] * arg_25_3)
	arg_25_1[3] = math.floor(arg_25_2[3] * arg_25_3)
	arg_25_1[4] = math.floor(arg_25_2[4] * arg_25_3)
end

StartGameWindowWeaveInfo._assign_objective = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	local scenegraph_id = arg_26_1.scenegraph_id
	local content = arg_26_1.content
	local style = arg_26_1.style
	local size = scenegraph_definition[scenegraph_id].size

	content.icon = arg_26_4 or "trial_gem"
	content.title_text = arg_26_2 or "-"
	content.text = arg_26_3 or "-"

	local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(content.icon).size
	local icon = style.icon
	local texture_size = icon.texture_size
	local default_offset = icon.default_offset
	local offset = icon.offset

	texture_size[1] = size_2[1]
	texture_size[2] = size_2[2]
	offset[1] = default_offset[1] - texture_size[1] / 2
	offset[2] = default_offset[2]

	local text = style.text
	local _ui_renderer = self._ui_renderer
	local get_text_width = UIUtils.get_text_width(_ui_renderer, text, content.text)
	local get_text_height = UIUtils.get_text_height(_ui_renderer, size, text, content.text)

	arg_26_5 = arg_26_5 or 0

	return math.max(get_text_height, 50) + arg_26_5
end

StartGameWindowWeaveInfo._exit = function (self, arg_27_1)
	-- function 27
	self.exit = true
	self.exit_level_id = arg_27_1
end

StartGameWindowWeaveInfo.draw = function (self, arg_28_1)
	-- function 28
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_hdr_renderer = self._ui_hdr_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_28_1, nil, _render_settings)

	for i, v in ipairs(self._top_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	local _objective_widgets = self._objective_widgets

	if not _objective_widgets then
		for i_2, v_2 in ipairs(_objective_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v_2)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_28_1, nil, _render_settings)

	for i_3, v_3 in ipairs(self._bottom_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_3)
	end

	UIRenderer.end_pass(_ui_renderer)
	UIRenderer.begin_pass(_ui_hdr_renderer, _ui_scenegraph, window_input_service, arg_28_1, nil, _render_settings)

	for i_4, v_4 in ipairs(self._bottom_hdr_widgets) do
		UIRenderer.draw_widget(_ui_hdr_renderer, v_4)
	end

	UIRenderer.end_pass(_ui_hdr_renderer)
end

StartGameWindowWeaveInfo._play_sound = function (self, arg_29_1)
	-- function 29
	self._parent:play_sound(arg_29_1)
end

StartGameWindowWeaveInfo._animate_pulse = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	-- function 30
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5))
end

StartGameWindowWeaveInfo._animate_element_by_time = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	-- function 31
	return (UIAnimation.init(UIAnimation.function_by_time, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, math.ease_out_quad))
end

StartGameWindowWeaveInfo._animate_element_by_catmullrom = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8)
	-- function 32
	return (UIAnimation.init(UIAnimation.catmullrom, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8))
end

StartGameWindowWeaveInfo._format_time = function (arg_33_0, arg_33_1)
	-- function 33
	local floor = math.floor

	return (string.format("%.2d:%.2d:%.2d", floor(arg_33_1 / 3600), floor(arg_33_1 / 60) % 60, floor(arg_33_1) % 60))
end

StartGameWindowWeaveInfo._get_save_data_by_weave_name = function (arg_34_0, arg_34_1)
	-- function 34
	return nil
end
