-- chunkname: @scripts/ui/views/title_main_ui.win32.lua

require("scripts/ui/ui_animations")
local_require("scripts/ui/views/menu_information_slate_ui")

local var_0_0 = local_require("scripts/ui/views/title_main_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local background_widget_definitions = var_0_0.background_widget_definitions
local single_widget_definitions = var_0_0.single_widget_definitions
local widget_definitions = var_0_0.widget_definitions
local menu_videos = var_0_0.menu_videos
local create_menu_button_func = var_0_0.create_menu_button_func
local legal_texts = var_0_0.legal_texts
local animation_definitions = var_0_0.animation_definitions
local create_sub_logo_func = var_0_0.create_sub_logo_func
local flag = true
local str = "TitleMainUI_ATTRACTMODE"

TitleMainUI = class(TitleMainUI)

TitleMainUI.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._disable_input = false
	self._menu_hierarchy = {}
	self._menu_option_widgets = {}
	self._breadcrumbs = {}

	self:_create_ui_renderer()
	self:_setup_input()
	self:_create_ui_elements()
	self:_init_animations()
end

TitleMainUI._start_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings,
		ui_scenegraph = self._ui_scenegraph
	}
	local _background_widgets = self._background_widgets
	local var_2_2 = self._animations[arg_2_1]

	if not var_2_2 then
		self._ui_animator:stop_animation(var_2_2)
	end

	local start_animation = self._ui_animator:start_animation(arg_2_1, _background_widgets, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

TitleMainUI._create_ui_renderer = function (self)
	-- function 3
	local tbl = {
		"material",
		"materials/ui/ui_1080p_title_screen",
		"material",
		"materials/ui/ui_1080p_start_screen",
		"material",
		"materials/ui/ui_1080p_menu_atlas_textures",
		"material",
		"materials/ui/ui_1080p_menu_single_textures",
		"material",
		"materials/ui/ui_1080p_hud_single_textures",
		"material",
		"materials/fonts/gw_fonts",
		"material",
		"materials/ui/ui_1080p_common",
		"material",
		"materials/ui/ui_1080p_versus_available_common"
	}

	for k, v in pairs(menu_videos) do
		tbl[#tbl + 1] = "material"
		tbl[#tbl + 1] = v.video_name
	end

	for k_2, v_2 in pairs(DLCSettings) do
		local ui_materials = v_2.ui_materials

		if not ui_materials then
			for i, v_3 in ipairs(ui_materials) do
				tbl[#tbl + 1] = "material"
				tbl[#tbl + 1] = v_3
			end
		end
	end

	self._ui_renderer = UIRenderer.create(self._world, unpack(tbl))

	UISetupFontHeights(self._ui_renderer.gui)
end

TitleMainUI._setup_input = function (self)
	-- function 4
	self._input_manager = Managers.input

	self._input_manager:create_input_service("main_menu", "TitleScreenKeyMaps", "TitleScreenFilters")
	self._input_manager:map_device_to_service("main_menu", "gamepad")
	self._input_manager:map_device_to_service("main_menu", "keyboard")
	self._input_manager:map_device_to_service("main_menu", "mouse")
end

TitleMainUI._play_sound = function (arg_5_0, arg_5_1)
	-- function 5
	return Managers.music:trigger_event(arg_5_1)
end

TitleMainUI.get_ui_renderer = function (self)
	-- function 6
	return self._ui_renderer
end

TitleMainUI._init_animations = function (self)
	-- function 7
	self._menu_item_animations = {}
	self._ui_animations = {}
	self._ui_animation_callbacks = {}
	self._animations = {}
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

TitleMainUI._create_ui_elements = function (self)
	-- function 8
	self._alpha_multiplier = 1
	self._disabled_buttons = {}
	self._current_menu_widgets = {}
	self._menu_item_animations = {}
	self._current_menu_index = nil
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self:_create_videos()

	self._background_widgets = {}

	for k, v in pairs(background_widget_definitions) do
		self._background_widgets[k] = UIWidget.init(v)
	end

	self._engage_prompt = UIWidget.init(single_widget_definitions.create_engage_prompt(self._ui_renderer))
	self._information_text = UIWidget.init(single_widget_definitions.information_text)
	self._information_text.style.text.localize = false
	self._info_slate_widget = UIWidget.init(single_widget_definitions.info_slate)
	self._game_type_tag_widget = UIWidget.init(single_widget_definitions.game_type)
	self._game_type_description_widget = UIWidget.init(single_widget_definitions.game_type_description)
	self._menu_selection_left = UIWidget.init(single_widget_definitions.start_screen_selection_left)
	self._menu_selection_right = UIWidget.init(single_widget_definitions.start_screen_selection_right)
	self._logo_widget = UIWidget.init(single_widget_definitions.logo)

	self:_setup_legal_texts()
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	flag = false
end

TitleMainUI._setup_legal_texts = function (self)
	-- function 9
	local var_9_0 = UIWidget.init(single_widget_definitions.legal_text)
	local text = var_9_0.style.text

	text.localize = false
	text.vertical_alignment = "bottom"

	local str = ""

	for i, v in ipairs(legal_texts) do
		str = str .. "\n" .. Localize(v)
	end

	var_9_0.content.text = str
	self._legal_text = var_9_0
end

TitleMainUI._create_menu_option_widget = function (self, arg_10_1, arg_10_2)
	-- function 10
	for i, v in ipairs(arg_10_1) do
		local text = v.text
		local callback = v.callback
		local conditional_func = v.conditional_func
		local layout = v.layout
		local num = #arg_10_2 + 1

		if not conditional_func and not conditional_func() then
			local str = "menu_option_" .. num
			local var_10_6 = create_menu_button_func(str, text, callback, v)

			arg_10_2[num] = UIWidget.init(var_10_6)

			if not layout then
				local sub_menu = arg_10_2.sub_menu

				sub_menu = sub_menu or {}
				arg_10_2.sub_menu = sub_menu
				arg_10_2.sub_menu[num] = {}

				local var_10_8 = arg_10_2.sub_menu[num]

				self:_create_menu_option_widget(layout, var_10_8)

				local num_2 = #var_10_8 + 1
				local var_10_10 = callback(self, "_go_back")
				local str_2 = "menu_option_" .. num_2
				local var_10_12 = create_menu_button_func(str_2, "back_menu_button_name", var_10_10)

				var_10_8[num_2] = UIWidget.init(var_10_12)
			end
		end
	end
end

TitleMainUI.create_menu_options = function (self, arg_11_1)
	-- function 11
	table.clear(self._menu_hierarchy)
	self:_create_menu_option_widget(arg_11_1, self._menu_hierarchy)

	self._current_menu_widgets = self._menu_hierarchy
end

TitleMainUI._update_animations = function (self, arg_12_1)
	-- function 12
	local _animations = self._animations
	local _ui_animations = self._ui_animations
	local _ui_animation_callbacks = self._ui_animation_callbacks
	local _ui_animator = self._ui_animator
	local _menu_item_animations = self._menu_item_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_12_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil

			local var_12_5 = _ui_animation_callbacks[k]

			if not var_12_5 then
				var_12_5()

				_ui_animation_callbacks[k] = nil
			end
		end
	end

	for k_2, v_2 in pairs(_menu_item_animations) do
		self[v_2.func](self, v_2, k_2, arg_12_1)
	end

	_ui_animator:update(arg_12_1)

	for k_3, v_3 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_3) then
			_ui_animator:stop_animation(v_3)

			_animations[k_3] = nil
		end
	end
end

TitleMainUI.update = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not flag then
		self:_create_ui_elements()
		self:_init_animations()
	end

	self:_update_information_text(arg_13_1, arg_13_2)
	self:_update_input(arg_13_1, arg_13_2, arg_13_3)
	self:_update_animations(arg_13_1)
	self:_draw(arg_13_1, arg_13_2, arg_13_3)
end

TitleMainUI._update_information_text = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not self._show_menu then
		local backend = Managers.backend

		backend = not backend and Managers.backend:get_current_api_call()

		if not backend and not Managers.localizer:exists(backend) then
			local content = self._information_text.content

			if content.text ~= backend then
				content.text = Localize(backend)
			end
		end
	end
end

TitleMainUI._destroy_video_players = function (self)
	-- function 15
	if not self._video_widgets then
		for k, v in pairs(self._video_widgets) do
			local video_player = v.content.video_content.video_player

			if not video_player then
				World.destroy_video_player(self._world, video_player)
			end
		end

		self._video_widgets = nil
		self._active_video = nil
	end
end

TitleMainUI._change_video = function (self, arg_16_1)
	-- function 16
	if arg_16_1 == self._active_video_widget_name then
		return
	end

	World.remove_video_player(self._world, self._active_video_widget.content.video_content.video_player)

	self._active_video_widget = self._video_widgets[arg_16_1]
	self._active_video_widget_name = arg_16_1

	World.add_video_player(self._world, self._active_video_widget.content.video_content.video_player)
	self:_start_animation("video_fade_in")
end

TitleMainUI._create_videos = function (self)
	-- function 17
	self:_destroy_video_players()

	self._video_widgets = {}

	for k, v in pairs(menu_videos) do
		local create_video_player = World.create_video_player(self._world, v.video_name, true, false)
		local var_17_1 = UIWidget.init(UIWidgets.create_splash_video(v))

		var_17_1.content.video_content.video_player = create_video_player
		self._video_widgets[k] = var_17_1
	end

	self._active_video_widget = self._video_widgets.main

	World.add_video_player(self._world, self._active_video_widget.content.video_content.video_player)
end

TitleMainUI._draw_video = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("main_menu")
	local _render_settings = self._render_settings

	_render_settings.alpha_multiplier = self._alpha_multiplier

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_18_1, nil, _render_settings)
	UIRenderer.draw_widget(_ui_renderer, self._active_video_widget)
	UIRenderer.end_pass(_ui_renderer)

	_render_settings.alpha_multiplier = nil
end

TitleMainUI._go_back = function (self)
	-- function 19
	self:_play_sound("Play_console_menu_back")

	local _current_menu_index = self._current_menu_index
	local _breadcrumbs = self._breadcrumbs

	_breadcrumbs[#_breadcrumbs] = nil

	local _menu_hierarchy = self._menu_hierarchy

	for i = 1, #_breadcrumbs do
		local var_19_3 = _breadcrumbs[i]

		_menu_hierarchy = _menu_hierarchy.sub_menu[var_19_3]
	end

	if not _menu_hierarchy then
		table.clear(self._menu_item_animations)
		self:anim_deselect_button(nil, _current_menu_index, nil, 0)

		self._current_menu_widgets = _menu_hierarchy
		self._current_menu_index = nil
		_current_menu_index = 1
	end

	self:_update_selection(_current_menu_index)

	return true
end

local function fn()
	-- function 20
	return
end

TitleMainUI._activate_menu_widget = function (self, arg_21_1)
	-- function 21
	local _current_menu_index = self._current_menu_index
	local callback = self._current_menu_widgets[arg_21_1].content.callback

	callback = callback or fn

	if not callback() then
		return
	else
		local _breadcrumbs = self._breadcrumbs
		local _menu_hierarchy = self._menu_hierarchy

		for i = 1, #_breadcrumbs do
			local var_21_4 = _breadcrumbs[i]

			_menu_hierarchy = _menu_hierarchy.sub_menu[var_21_4]
		end

		local sub_menu = _menu_hierarchy.sub_menu

		sub_menu = not sub_menu and _menu_hierarchy.sub_menu[arg_21_1]

		if not sub_menu then
			table.clear(self._menu_item_animations)
			self:anim_deselect_button(nil, _current_menu_index, nil, 0)

			_breadcrumbs[#_breadcrumbs + 1] = arg_21_1
			self._current_menu_widgets = sub_menu
			self._current_menu_index = nil
			_current_menu_index = 1

			self:_play_sound("Play_console_menu_select")
		end
	end

	return _current_menu_index
end

TitleMainUI._update_mouse_input = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local _current_menu_index = self._current_menu_index

	_current_menu_index = _current_menu_index or 1

	local content = self._current_menu_widgets[_current_menu_index].content
	local _breadcrumbs = self._breadcrumbs
	local var_22_3

	for i, v in ipairs(self._current_menu_widgets) do
		if not UIUtils.is_button_pressed(v, "button_text") then
			_current_menu_index = self:_activate_menu_widget(i)
		elseif not UIUtils.is_button_hover_enter(v, "button_text") then
			_current_menu_index = i

			self:_play_sound("play_gui_inventory_item_hover")
		end
	end

	if table.is_empty(_breadcrumbs) or not arg_22_3:get("back", true) then
		return self:_go_back()
	end

	self:_update_selection(_current_menu_index)
end

TitleMainUI._update_gamepad_input = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local _current_menu_index = self._current_menu_index

	_current_menu_index = _current_menu_index or 1

	local content = self._current_menu_widgets[_current_menu_index].content
	local _breadcrumbs = self._breadcrumbs

	if not arg_23_3:get("up") then
		_current_menu_index = math.clamp(_current_menu_index - 1, 1, #self._current_menu_widgets)

		self:_play_sound("play_gui_inventory_item_hover")
	elseif not arg_23_3:get("down") then
		_current_menu_index = math.clamp(_current_menu_index + 1, 1, #self._current_menu_widgets)

		self:_play_sound("play_gui_inventory_item_hover")
	elseif not arg_23_3:get("start", true) then
		_current_menu_index = self:_activate_menu_widget(_current_menu_index)
	elseif table.is_empty(_breadcrumbs) or not arg_23_3:get("back", true) then
		return self:_go_back()
	end

	self:_update_selection(_current_menu_index)
end

TitleMainUI._update_selection = function (self, arg_24_1)
	-- function 24
	if not (not arg_24_1 and arg_24_1 == self._current_menu_index) then
		if not self._current_menu_index then
			self:_add_menu_item_animation(self._current_menu_index, "anim_deselect_button")
		end

		self:_add_menu_item_animation(arg_24_1, "anim_select_button")

		self._current_menu_index = arg_24_1

		local var_24_0 = self._current_menu_widgets[self._current_menu_index]

		if not var_24_0 then
			self:_populate_additional_data(var_24_0)
		end
	end
end

local tbl = {}

TitleMainUI._populate_additional_data = function (self, arg_25_1)
	-- function 25
	local menu_option_data = arg_25_1.content.menu_option_data

	menu_option_data = menu_option_data or tbl

	local tag = menu_option_data.tag
	local logo_texture = menu_option_data.logo_texture
	local description = menu_option_data.description
	local info_slate = menu_option_data.info_slate
	local video = menu_option_data.video

	video = video or "main_menu"
	self._info_slate_widget.content.text = info_slate
	self._game_type_tag_widget.content.text = tag
	self._game_type_description_widget.content.text = description

	local var_25_6

	if not logo_texture then
		var_25_6 = UIWidget.init(create_sub_logo_func(logo_texture))

		if not var_25_6 then
			-- Nothing
		end
	end

	var_25_6 = nil

	::label_25_0::

	self._sub_logo_widget = var_25_6

	self:_change_video(video)
end

TitleMainUI._update_input = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	if not self._disable_input then
		return
	end

	if not self._show_menu then
		return
	end

	if arg_26_3 or not self._frame_anim_id then
		return
	end

	if not table.is_empty(self._current_menu_widgets) then
		return
	end

	local get_service = self._input_manager:get_service("main_menu")

	if not Managers.input:is_device_active("mouse") then
		self:_update_mouse_input(arg_26_1, arg_26_2, get_service)
	else
		self:_update_gamepad_input(arg_26_1, arg_26_2, get_service)
	end
end

TitleMainUI._draw_menu_background = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	-- function 27
	UIRenderer.begin_pass(arg_27_3, arg_27_4, arg_27_5, arg_27_1, nil, arg_27_6)

	for k, v in pairs(self._background_widgets) do
		UIRenderer.draw_widget(arg_27_3, v)
	end

	local alpha_multiplier = arg_27_6.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1
	arg_27_6.alpha_multiplier = self._alpha_multiplier

	UIRenderer.draw_widget(arg_27_3, self._logo_widget)

	arg_27_6.alpha_multiplier = alpha_multiplier

	UIRenderer.end_pass(arg_27_3)
end

TitleMainUI._draw_menu = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	if not self._show_menu then
		return
	end

	local tbl = {
		alpha_multiplier = self._alpha_multiplier
	}

	UIRenderer.begin_pass(arg_28_3, arg_28_4, arg_28_5, arg_28_1, nil, tbl)

	for i, v in ipairs(self._current_menu_widgets) do
		UIRenderer.draw_widget(arg_28_3, v)
	end

	if not self._current_menu_index then
		UIRenderer.draw_widget(arg_28_3, self._menu_selection_left)
		UIRenderer.draw_widget(arg_28_3, self._menu_selection_right)
	end

	UIRenderer.draw_widget(arg_28_3, self._info_slate_widget)
	UIRenderer.draw_widget(arg_28_3, self._game_type_tag_widget)
	UIRenderer.draw_widget(arg_28_3, self._game_type_description_widget)

	if not self._sub_logo_widget then
		UIRenderer.draw_widget(arg_28_3, self._sub_logo_widget)
	end

	UIRenderer.end_pass(arg_28_3)
end

TitleMainUI._draw_engage_screen = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	-- function 29
	UIRenderer.begin_pass(arg_29_3, arg_29_4, arg_29_5, arg_29_1, nil, self._render_settings)

	if not self._show_menu then
		UIRenderer.draw_widget(arg_29_3, self._legal_text)
	end

	if not self._has_engaged then
		if not self._draw_information_text then
			UIRenderer.draw_widget(arg_29_3, self._information_text)
		end
	else
		UIRenderer.draw_widget(arg_29_3, self._engage_prompt)
	end

	UIRenderer.end_pass(arg_29_3)
end

TitleMainUI._draw = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("main_menu")
	local _render_settings = self._render_settings

	self:_draw_menu_background(arg_30_1, arg_30_2, _ui_renderer, _ui_scenegraph, get_service, _render_settings)
	self:_draw_video(arg_30_1, arg_30_2)

	if not self._show_menu and not self._information_slate_ui then
		self._information_slate_ui:update(arg_30_1, arg_30_2)
	end

	if not arg_30_3 then
		return
	end

	self:_draw_engage_screen(arg_30_1, arg_30_2, _ui_renderer, _ui_scenegraph, get_service, _render_settings)
	self:_draw_menu(arg_30_1, arg_30_2, _ui_renderer, _ui_scenegraph, get_service)
end

TitleMainUI.destroy = function (self)
	-- function 31
	if not self._information_slate_ui then
		self._information_slate_ui:destroy()
	end

	GarbageLeakDetector.register_object(self, "TitleMainUI")
	UIRenderer.destroy(self._ui_renderer, self._world)
	self:_destroy_video_players()
end

TitleMainUI.should_start = function (self)
	-- function 32
	return self._has_engaged
end

TitleMainUI.show_menu = function (self, arg_33_1)
	-- function 33
	if not arg_33_1 then
		self:_play_sound("Play_console_menu_start")
		self:_change_video("main_menu")

		self._ui_animations.sidebar = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.sidebar.position, 1, -544, 0, 0.5, math.easeCubic)
		self._ui_animations.alpha_multiplier = UIAnimation.init(UIAnimation.function_by_time, self, "_alpha_multiplier", 0, 1, 0.5, math.easeCubic)
		self._draw_information_text = false

		self._ui_animation_callbacks.alpha_multiplier = function ()
			-- function 34
			local get_service = Managers.input:get_service("main_menu")

			self._information_slate_ui = MenuInformationSlateUI:new(self._ui_renderer, get_service)
		end
	else
		local _current_menu_index = self._current_menu_index

		if not _current_menu_index then
			self:anim_deselect_button(nil, _current_menu_index, nil, 0)

			self._current_menu_index = nil
			self._menu_item_animations[_current_menu_index] = nil
		end

		self:_play_sound("Play_console_menu_back")
		self:_change_video("main")

		self._ui_scenegraph.sidebar.size[1] = 544
		self._ui_scenegraph.sidebar.position[1] = -800
		self._information_slate_ui = nil

		table.clear(self._ui_animations)
		table.clear(self._ui_animation_callbacks)
		table.clear(self._breadcrumbs)
	end

	self._show_menu = arg_33_1
	self._is_in_sub_menu = false
	self._current_menu_widgets = self._menu_hierarchy
end

TitleMainUI.set_start_pressed = function (self, arg_35_1)
	-- function 35
	if self._has_engaged ~= arg_35_1 then
		if not arg_35_1 then
			self._ui_animations.legal_text_fade = UIAnimation.init(UIAnimation.function_by_time, self._legal_text.style.text.text_color, 1, 255, 0, 0.2, math.easeCubic)
			self._ui_animations.information_text_fade = UIAnimation.init(UIAnimation.function_by_time, self._information_text.style.text.text_color, 1, 0, 255, 0.5, math.easeCubic)
		else
			self._ui_animations.legal_text_fade = UIAnimation.init(UIAnimation.function_by_time, self._legal_text.style.text.text_color, 1, 0, 255, 0.5, math.easeCubic)
			self._ui_animations.information_text_fade = UIAnimation.init(UIAnimation.function_by_time, self._information_text.style.text.text_color, 1, 255, 0, 0.2, math.easeCubic)
			self._draw_information_text = nil
		end
	end

	self._has_engaged = arg_35_1
end

local num = 0.2
local num_2 = 0.2

TitleMainUI.anim_select_button = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	if arg_36_1.progress == 1 then
		return
	end

	local timer = arg_36_1.timer

	timer = timer or arg_36_1.progress * num
	arg_36_1.timer = timer
	arg_36_1.timer = arg_36_1.timer + arg_36_3
	arg_36_1.progress = math.clamp(arg_36_1.timer / num, 0, 1)

	local var_36_1 = self._current_menu_widgets[arg_36_2]
	local disabled = var_36_1.content.disabled
	local gray

	if not disabled then
		gray = Colors.color_definitions.gray

		if not gray then
			-- Nothing
		end
	end

	gray = Colors.color_definitions.font_title

	do
		local gray_2
	end

	::label_36_0::

	if not disabled then
		gray_2 = Colors.color_definitions.gray

		if not gray_2 then
			-- Nothing
		end
	end

	gray_2 = Colors.color_definitions.white

	::label_36_1::

	if not var_36_1.style.text then
		var_36_1.style.text.text_color[2] = math.lerp(gray[2], gray_2[2], math.smoothstep(arg_36_1.progress, 0, 1))
		var_36_1.style.text.text_color[3] = math.lerp(gray[3], gray_2[3], math.smoothstep(arg_36_1.progress, 0, 1))
		var_36_1.style.text.text_color[4] = math.lerp(gray[4], gray_2[4], math.smoothstep(arg_36_1.progress, 0, 1))
		var_36_1.style.text.font_size = math.lerp(var_36_1.style.text.font_size, var_36_1.content.default_font_size + 10, math.easeInCubic(arg_36_1.progress))
	end

	local scenegraph_id = var_36_1.scenegraph_id
	local _ui_scenegraph = self._ui_scenegraph

	_ui_scenegraph.selection_anchor.local_position[2] = _ui_scenegraph[scenegraph_id].local_position[2] + 5

	local style = var_36_1.style
	local text_field = var_36_1.content.text_field

	if not text_field then
		local num_2 = 20

		num_2 = var_36_1.content.spacing or num_2

		local _get_word_wrap_size, var_36_11 = self:_get_word_wrap_size(Localize(text_field), style.text, 1000)

		_ui_scenegraph.selection_anchor.size[1] = (_get_word_wrap_size or 0) + num_2
		self._menu_selection_left.offset[1] = math.lerp(-50, 0, math.smoothstep(arg_36_1.progress, 0, 1))
		self._menu_selection_right.offset[1] = math.lerp(50, 0, math.smoothstep(arg_36_1.progress, 0, 1))
	end
end

TitleMainUI.anim_deselect_button = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	if not (not arg_37_1 and arg_37_1.progress ~= 0) then
		return
	end

	local num = 0

	if not arg_37_4 then
		local timer = arg_37_1.timer

		timer = timer or arg_37_1.progress * num_2
		arg_37_1.timer = timer
		arg_37_1.timer = arg_37_1.timer - arg_37_3
		arg_37_1.progress = math.clamp(arg_37_1.timer / num_2, 0, 1)
		num = arg_37_1.progress
	else
		num = arg_37_4
	end

	local var_37_2 = self._current_menu_widgets[arg_37_2]
	local flag = not var_37_2 and var_37_2.content.disabled
	local gray

	if not flag then
		gray = Colors.color_definitions.gray

		if not gray then
			-- Nothing
		end
	end

	gray = Colors.color_definitions.font_title

	do
		local gray_2
	end

	::label_37_0::

	if not flag then
		gray_2 = Colors.color_definitions.gray

		if not gray_2 then
			-- Nothing
		end
	end

	gray_2 = Colors.color_definitions.white

	::label_37_1::

	if not var_37_2 and not var_37_2.style.text then
		var_37_2.style.text.text_color[2] = math.lerp(gray[2], gray_2[2], math.smoothstep(num, 0, 1))
		var_37_2.style.text.text_color[3] = math.lerp(gray[3], gray_2[3], math.smoothstep(num, 0, 1))
		var_37_2.style.text.text_color[4] = math.lerp(gray[4], gray_2[4], math.smoothstep(num, 0, 1))
	end

	if not var_37_2 and not var_37_2.style.text then
		if not arg_37_4 then
			var_37_2.style.text.font_size = var_37_2.content.default_font_size * (1 - num)
		else
			var_37_2.style.text.font_size = math.lerp(var_37_2.style.text.font_size, var_37_2.content.default_font_size, math.easeInCubic(num))
		end
	end
end

TitleMainUI._get_text_size = function (self, arg_38_1, arg_38_2)
	-- function 38
	local var_38_0, var_38_1 = UIFontByResolution(arg_38_2)
	local text_size, var_38_3, var_38_4 = UIRenderer.text_size(self._ui_renderer, arg_38_1, var_38_0[1], var_38_1)

	return text_size, var_38_3
end

TitleMainUI._get_word_wrap_size = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local var_39_0, var_39_1 = UIFontByResolution(arg_39_2)
	local word_wrap = UIRenderer.word_wrap(self._ui_renderer, arg_39_1, var_39_0[1], var_39_1, arg_39_3)
	local _get_text_size, var_39_4 = self:_get_text_size(arg_39_1, arg_39_2)

	return _get_text_size, var_39_4 * #word_wrap
end

TitleMainUI._add_menu_item_animation = function (self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local _menu_item_animations = self._menu_item_animations
	local tbl = {}
	local progress

	if not self._menu_item_animations[arg_40_1] then
		progress = self._menu_item_animations[arg_40_1].progress

		if not progress then
			-- Nothing
		end
	end

	progress = 0

	::label_40_0::

	tbl.progress = progress
	tbl.func = arg_40_2
	_menu_item_animations[arg_40_1] = tbl
end

TitleMainUI.set_information_text = function (self, arg_41_1)
	-- function 41
	self._draw_information_text = true

	local _information_text = self._information_text
	local content = _information_text.content
	local style = _information_text.style

	if not arg_41_1 then
		content.text = Localize("state_info")
	else
		content.text = arg_41_1
	end
end

TitleMainUI.disable_input = function (self, arg_42_1)
	-- function 42
	self._disable_input = arg_42_1
end

TitleMainUI.view_activated = function (self, arg_43_1)
	-- function 43
	if not arg_43_1 then
		self._ui_animations.sidebar = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.sidebar.size, 1, 544, 1920, 0.5, math.easeCubic)
		self._ui_animations.alpha_multiplier = UIAnimation.init(UIAnimation.function_by_time, self, "_alpha_multiplier", 1, 0, 0.5, math.easeCubic)

		if not self._information_slate_ui then
			self._information_slate_ui:hide()
		end
	else
		self._ui_animations.sidebar = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.sidebar.size, 1, 1920, 544, 0.5, math.easeCubic)
		self._ui_animations.alpha_multiplier = UIAnimation.init(UIAnimation.function_by_time, self, "_alpha_multiplier", 0, 1, 0.5, math.easeCubic)

		if not self._information_slate_ui then
			self._information_slate_ui:show()
		end
	end
end
