-- chunkname: @scripts/ui/views/cinematics_view/cinematics_view.lua

local var_0_0 = local_require("scripts/ui/views/cinematics_view/cinematics_view_definitions")

require("scripts/ui/views/cinematics_view/cinematics_view_settings")
require("scripts/ui/views/cutscene_overlay_ui")
require("scripts/ui/views/skip_input_ui")

local tbl = {}

CinematicsView = class(CinematicsView)

local tbl_2 = {
	"resource_packages/menu_cinematics_videos",
	"resource_packages/videos/vermintide_2_versus_trailer"
}

CinematicsView.init = function (self, arg_1_1)
	-- function 1
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._ingame_ui = arg_1_1.ingame_ui
	self._input_manager = arg_1_1.input_manager
	self._ingame_ui_context = arg_1_1
	self._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = false
	}
	self._in_title_screen = arg_1_1.in_title_screen

	local _input_manager = self._input_manager

	_input_manager:create_input_service("cinematics_view", "IngameMenuKeymaps", "IngameMenuFilters")
	_input_manager:map_device_to_service("cinematics_view", "keyboard")
	_input_manager:map_device_to_service("cinematics_view", "mouse")
	_input_manager:map_device_to_service("cinematics_view", "gamepad")
	self:_reset()
end

CinematicsView._packages_loaded = function (arg_2_0)
	-- function 2
	local package = Managers.package

	for i, v in ipairs(tbl_2) do
		if not package:has_loaded(v, "cinematics_view") then
			return false
		end
	end

	return true
end

CinematicsView._load_packages = function (arg_3_0)
	-- function 3
	local package = Managers.package

	for i, v in ipairs(tbl_2) do
		if not package:has_loaded(v, "cinematics_view") then
			package:load(v, "cinematics_view", nil, true, true)
		end
	end
end

CinematicsView._unload_packages = function (arg_4_0)
	-- function 4
	local package = Managers.package

	for i, v in ipairs(tbl_2) do
		if package:has_loaded(v, "cinematics_view") or not package:is_loading(v, "cinematics_view") then
			package:unload(v, "cinematics_view", nil, true)
		end
	end
end

CinematicsView._reset = function (self)
	-- function 5
	self._current_video_content = nil
	self._current_category_index = 1
	self._current_gamepad_selection_index = 1
	self._exiting = false
end

CinematicsView._create_ui_elements = function (self)
	-- function 6
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(var_0_0.widget_definitions) do
		local var_6_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_6_2
		tbl_2[k] = var_6_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	self:_destroy_video_players()

	local CinematicsViewSettings = CinematicsViewSettings
	local _ui_top_renderer = self._ui_top_renderer
	local create_cinematic_entry = var_0_0.create_cinematic_entry
	local tbl_3 = {}
	local tbl_4 = {}

	for k_2 = 1, #CinematicsViewSettings do
		local var_6_8 = CinematicsViewSettings[k_2]

		if #var_6_8 > 0 then
			local tbl_5 = {}

			for l = 1, #var_6_8 do
				local var_6_10 = var_6_8[l]
				local var_6_11 = create_cinematic_entry(_ui_top_renderer, var_6_10, l, false, self)
				local var_6_12 = UIWidget.init(var_6_11)

				tbl_5[#tbl_5 + 1] = var_6_12
			end

			tbl_3[#tbl_3 + 1] = tbl_5

			local count = #tbl_3
			local category_name = var_6_8.category_name

			tbl_4[category_name] = count
			tbl_4[count] = category_name
		end
	end

	self._cinematics_widgets = tbl_3
	self._cinematics_categories_lut = tbl_4

	local create_video_entry = var_0_0.create_video_entry(self)

	self._video_widget = UIWidget.init(create_video_entry)

	local tbl_6 = {}
	local tbl_7 = {}

	for k_3, v_2 in pairs(var_0_0.button_widget_definitions) do
		local var_6_18 = UIWidget.init(v_2)

		tbl_6[#tbl_6 + 1] = var_6_18
		tbl_7[k_3] = var_6_18
	end

	self._button_widgets = tbl_6
	self._button_widgets_by_name = tbl_7
	self._ui_animations = {}
	self._animations = {}
	self._animation_callbacks = {}
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.animation_definitions)

	local _ui_top_renderer_2 = self._ui_top_renderer
	local input_service = self:input_service()
	local generic_input_actions = var_0_0.generic_input_actions

	self._menu_input_description = MenuInputDescriptionUI:new(nil, _ui_top_renderer_2, input_service, 5, 900, generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)
end

CinematicsView._create_scrollbar = function (self)
	-- function 7
	local count = #self._cinematics_widgets[self._current_category_index]
	local create_scrollbar = var_0_0.create_scrollbar(count)

	self._scrollbar_widget = UIWidget.init(create_scrollbar)

	local _ui_scenegraph = self._ui_scenegraph
	local num = count * var_0_0.entry_size[2]
	local var_7_4 = _ui_scenegraph.video_area.size[2]

	self._scroll_area_size = math.max(num - var_7_4, 0)
end

CinematicsView._destroy_video_players = function (self)
	-- function 8
	if not self._cinematics_widgets then
		return
	end

	local _ui_video_renderer = self._ui_video_renderer

	for i = 1, #self._cinematics_widgets do
		local var_8_1 = self._cinematics_widgets[i]

		for j = 1, #var_8_1 do
			local reference_name = var_8_1[j].content.reference_name

			if not _ui_video_renderer.video_players[reference_name] then
				local world = _ui_video_renderer.world

				UIRenderer.destroy_video_player(_ui_video_renderer, reference_name, world)
			end
		end
	end
end

CinematicsView.input_service = function (self)
	-- function 9
	return self._input_manager:get_service("cinematics_view")
end

CinematicsView.on_enter = function (self)
	-- function 10
	self._input_manager:capture_input(ALL_INPUT_METHODS, 1, "cinematics_view", "CinematicsView")
	self:_load_packages()
	self:_show_loading_icon()
end

CinematicsView._reset_button_states = function (self)
	-- function 11
	for i, v in ipairs(self._button_widgets) do
		UIWidgetUtils.reset_layout_button(v)
	end
end

CinematicsView._show_loading_icon = function (arg_12_0)
	-- function 12
	Managers.transition:show_loading_icon(false)
end

CinematicsView._hide_loading_icon = function (arg_13_0)
	-- function 13
	Managers.transition:hide_loading_icon()
end

CinematicsView._create_video_renderer = function (self)
	-- function 14
	local tbl = {
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

	for i = 1, #CinematicsViewSettings do
		local var_14_1 = CinematicsViewSettings[i]

		for j = 1, #var_14_1 do
			local video_data = var_14_1[j].video_data

			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = video_data.resource
		end
	end

	local world = self._ui_top_renderer.world

	self._ui_video_renderer = UIRenderer.create(world, unpack(tbl))
end

CinematicsView._destroy_video_renderer = function (self)
	-- function 15
	local world = self._ui_top_renderer.world

	UIRenderer.destroy(self._ui_video_renderer, world)
end

CinematicsView.initialized = function (self)
	-- function 16
	return self._initialized
end

CinematicsView._init_view = function (self)
	-- function 17
	self:_create_video_renderer()
	self:_create_ui_elements()
	self:_create_scrollbar()
	self:_reset()
	self:_hide_loading_icon()
	self:_reset_button_states()
	self:_start_animation("on_enter")

	self._initialized = true
end

CinematicsView._start_animation = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _render_settings = self._render_settings

	_render_settings = _render_settings or {
		alpha_multiplier = 0,
		snap_pixel_positions = false
	}
	self._render_settings = _render_settings

	local tbl = {
		render_settings = self._render_settings
	}

	self._animations[arg_18_1] = self._ui_animator:start_animation(arg_18_1, nil, self._ui_scenegraph, tbl, 1, 0)
	self._animation_callbacks[arg_18_1] = arg_18_2
end

CinematicsView._enable_viewport = function (arg_19_0, arg_19_1)
	-- function 19
	if not IS_WINDOWS and GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		local str = "inventory_preview"
		local str_2 = "inventory_preview_viewport"
		local world = Managers.world:world(str)
		local viewport = ScriptWorld.viewport(world, str_2)

		if not arg_19_1 then
			ScriptWorld.activate_viewport(world, viewport)
			ShowCursorStack.show("CinematicsView")
		else
			ScriptWorld.deactivate_viewport(world, viewport)
			ShowCursorStack.hide("CinematicsView")
		end
	elseif not arg_19_1 then
		ShowCursorStack.show("CinematicsView")
	else
		ShowCursorStack.hide("CinematicsView")
	end
end

CinematicsView._create_skip_widget = function (self)
	-- function 20
	local tbl = {
		ui_renderer = self._ui_top_renderer
	}

	self._skip_input_ui = SkipInputUI:new(self, tbl)
end

CinematicsView.on_exit = function (self)
	-- function 21
	self._input_manager:release_input(ALL_INPUT_METHODS, 1, "cinematics_view", "CinematicsView")
	self:deactivate_video()
	self:_destroy_video_players()
	self:_destroy_video_renderer()
	self:_unload_packages()
	ShowCursorStack.hide("CinematicsView")

	self._initialized = false
end

CinematicsView.do_exit = function (self, arg_22_1)
	-- function 22
	self:_start_animation("on_exit", callback(self, "exit", arg_22_1))

	self._exiting = true

	local music = Managers.music
	local var_22_1 = music
	local trigger_event = music.trigger_event
	local flag

	flag = not IS_WINDOWS and "Play_console_menu_back" and "Play_console_menu_select"

	trigger_event(var_22_1, flag)
end

CinematicsView.update = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not self._packages_loaded() then
		if not self:initialized() then
			self:_update_input(arg_23_1, arg_23_2)
			self:_update_animations(arg_23_1, arg_23_2)
			self:_update_video(arg_23_1, arg_23_2)
			self:_draw(arg_23_1, arg_23_2)
		else
			self:_init_view()
		end
	end
end

CinematicsView.current_gamepad_selection = function (self)
	-- function 24
	return self._current_gamepad_selection_index
end

local tbl_3 = {}

CinematicsView._update_input = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not self._exiting then
		return
	end

	local on_enter = self._animations.on_enter
	local input_service = self:input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")
	local _current_video_content = self._current_video_content
	local get = input_service:get("toggle_menu", true)
	local get_2 = input_service:get("back_menu", true)
	local IS_WINDOWS = IS_WINDOWS

	if not IS_WINDOWS then
		IS_WINDOWS = self._ui_animator:is_animation_completed(on_enter)
		IS_WINDOWS = not IS_WINDOWS and input_service:get("left_press")
	end

	local any_pressed = Managers.input:get_most_recent_device().any_pressed()
	local hotspot = self._widgets_by_name.canvas_hotspot.content.hotspot

	if _current_video_content or get or get_2 or hotspot.is_hover or not IS_WINDOWS then
		self:do_exit()

		return
	elseif not _current_video_content and not self._skip_input_ui and not self._skip_input_ui:skipped() then
		self:deactivate_video()
	elseif not input_service:get("confirm_press") then
		local _current_gamepad_selection_index = self._current_gamepad_selection_index
		local video_content = self._cinematics_widgets[self._current_category_index][_current_gamepad_selection_index].content.video_content

		if video_content.video_player_reference ~= (not _current_video_content and _current_video_content.video_player_reference) then
			self:activate_video(video_content, _current_gamepad_selection_index)
		end
	end

	if not _current_video_content then
		self:_update_scrollbar(arg_25_1, arg_25_2, input_service, is_device_active)
	end
end

CinematicsView._update_animations = function (self, arg_26_1, arg_26_2)
	-- function 26
	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_26_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_26_1)

	local _animations = self._animations
	local _animation_callbacks = self._animation_callbacks

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_animations[k_2] = nil

			if not _animation_callbacks[k_2] then
				_animation_callbacks[k_2]()

				_animation_callbacks[k_2] = nil
			end
		end
	end

	if not Managers.input:is_device_active("mouse") then
		for i, v_3 in ipairs(self._button_widgets) do
			UIWidgetUtils.animate_layout_button(v_3, arg_26_1)
		end
	end
end

CinematicsView._update_scrollbar = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local hotspot = self._widgets_by_name.video_area.content.hotspot
	local _scrollbar_widget = self._scrollbar_widget
	local content = _scrollbar_widget.content
	local style = _scrollbar_widget.style
	local hotspot_2 = content.hotspot
	local scroller_hotspot = content.scroller_hotspot
	local scroller = style.scroller
	local get = arg_27_3:get("scroll_axis")
	local get_2 = arg_27_3:get("cursor")
	local var_27_9

	if not get_2 then
		var_27_9 = get_2[2]

		if not var_27_9 then
			-- Nothing
		end
	end

	var_27_9 = 0

	::label_27_0::

	if not (not IS_WINDOWS and arg_27_4) then
		var_27_9 = var_27_9 * RESOLUTION_LOOKUP.inv_scale
	end

	local _ui_scenegraph = self._ui_scenegraph
	local local_position = _ui_scenegraph.anchor_point.local_position

	if not scroller_hotspot.on_pressed then
		self._cursor_start_pos = var_27_9
		self._scrollbar_start_pos = local_position[2]
		self._ui_animations.scroll = nil
		scroller_hotspot.selected = true
	elseif not self._cursor_start_pos then
		if not arg_27_3:get("left_hold") then
			local var_27_12 = _ui_scenegraph.scrollbar.size[2]
			local var_27_13 = _ui_scenegraph.video_area.size[2]
			local var_27_14 = scroller.area_size[2]
			local var_27_15 = var_27_9
			local num = (self._cursor_start_pos - var_27_15) / (var_27_13 - var_27_14)

			local_position[2] = math.clamp(self._scrollbar_start_pos + num * self._scroll_area_size, 0, self._scroll_area_size)
		else
			self._cursor_start_pos = nil
			self._scrollbar_start_pos = nil
			scroller_hotspot.selected = false
		end
	elseif not hotspot_2.on_pressed then
		local var_27_17 = _ui_scenegraph.video_area.world_position[2]
		local var_27_18 = _ui_scenegraph.video_area.size[2]
		local var_27_19 = scroller.area_size[2]
		local num_2 = var_27_9 - var_27_19 * 0.5
		local num_3 = num_2 - var_27_17
		local num_4 = 1 - num_3 / (var_27_18 - var_27_19)

		print(num_2, var_27_17, var_27_18, num_3, num_4)

		local_position[2] = math.clamp(self._scroll_area_size * num_4, 0, self._scroll_area_size)
	elseif not (not hotspot.is_hover and not (math.abs(get[2]) > 0)) then
		local num_5 = 200
		local var_27_24 = local_position
		local num_6 = 2
		local var_27_26 = local_position[2]
		local clamp = math.clamp(local_position[2] - get[2] * num_5, 0, self._scroll_area_size)

		self._ui_animations.scroll = UIAnimation.init(UIAnimation.function_by_time, var_27_24, num_6, var_27_26, clamp, 0.5, math.easeOutCubic)
	else
		local count = #self._cinematics_widgets[self._current_category_index]
		local _current_gamepad_selection_index = self._current_gamepad_selection_index

		if not arg_27_3:get("move_up_hold_continuous") then
			_current_gamepad_selection_index = math.clamp(_current_gamepad_selection_index - 1, 1, count)
		elseif not arg_27_3:get("move_down_hold_continuous") then
			_current_gamepad_selection_index = math.clamp(_current_gamepad_selection_index + 1, 1, count)
		end

		if _current_gamepad_selection_index ~= self._current_gamepad_selection_index then
			local var_27_30 = var_0_0.entry_size[2]
			local var_27_31 = local_position
			local num_7 = 2
			local var_27_33 = local_position[2]
			local clamp_2 = math.clamp(var_27_30 * (_current_gamepad_selection_index - 1), 0, self._scroll_area_size)

			self._ui_animations.scroll = UIAnimation.init(UIAnimation.function_by_time, var_27_31, num_7, var_27_33, clamp_2, 0.5, math.easeOutCubic)
			self._current_gamepad_selection_index = _current_gamepad_selection_index

			self:_play_sound("play_gui_start_menu_button_hover")
		end
	end

	local var_27_35 = _ui_scenegraph.scrollbar.size[2]
	local num_8 = local_position[2] / self._scroll_area_size

	scroller.offset[2] = num_8 * (var_27_35 - scroller.area_size[2]) * -1
end

CinematicsView._update_video = function (self)
	-- function 28
	local _current_video_content = self._current_video_content

	if not _current_video_content then
		local video_player_reference = _current_video_content.video_player_reference
		local var_28_2 = self._ui_video_renderer.video_players[video_player_reference]

		if VideoPlayer.number_of_frames(var_28_2) <= VideoPlayer.current_frame(var_28_2) then
			self:deactivate_video()
		end
	end
end

CinematicsView.deactivate_video = function (self)
	-- function 29
	if not self._current_video_content then
		self:_reset_sound()
		self:_enable_viewport(true)

		local video_player_reference = self._current_video_content.video_player_reference
		local _ui_video_renderer = self._ui_video_renderer

		if not _ui_video_renderer.video_players[video_player_reference] then
			local world = _ui_video_renderer.world

			UIRenderer.destroy_video_player(_ui_video_renderer, video_player_reference, world)
		end
	end

	if not self._cutscene_overlay_ui then
		self._cutscene_overlay_ui:destroy()

		self._cutscene_overlay_ui = nil
	end

	if not self._skip_input_ui then
		self._skip_input_ui:destroy()

		self._skip_input_ui = nil
	end

	self._current_video_content = nil

	Managers.chat:set_chat_enabled(true)
end

CinematicsView._play_sound = function (arg_30_0, arg_30_1)
	-- function 30
	if not IS_WINDOWS and GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		local flag

		flag = not IS_CONSOLE and "title_screen_world" and "level_world"

		local world = Managers.world:world(flag)
		local wwise_world = Managers.world:wwise_world(world)

		WwiseWorld.trigger_event(wwise_world, arg_30_1)
	else
		Managers.music:trigger_event(arg_30_1)
	end
end

CinematicsView._start_video_sound = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not IS_WINDOWS and GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		self:_play_sound("play_gui_amb_hero_screen_loop_end")
		self:_play_sound("Play_hud_start_cinematic")

		if not arg_31_2 then
			self:_play_sound(arg_31_2)
		end
	else
		Managers.music:stop_all_sounds()
	end

	if not arg_31_1 then
		self:_play_sound(arg_31_1)
	end
end

CinematicsView._reset_sound = function (self)
	-- function 32
	local sound_stop = self._current_video_content.video_data.sound_stop

	if not sound_stop then
		self:_play_sound(sound_stop)
	end

	local var_32_1 = self
	local _play_sound = self._play_sound
	local flag

	flag = not IS_CONSOLE and "Play_console_menu_music" and "Play_menu_screen_music"

	_play_sound(var_32_1, flag)

	if not IS_WINDOWS and GameSettingsDevelopment.skip_start_screen and not Development.parameter("skip_start_screen") then
		self:_play_sound("play_gui_amb_hero_screen_loop_begin")
	end
end

CinematicsView.activate_video = function (self, arg_33_1, arg_33_2)
	-- function 33
	if not self._exiting then
		return
	end

	local _current_video_content = self._current_video_content

	_current_video_content = _current_video_content or tbl_3

	local _ui_video_renderer = self._ui_video_renderer
	local video_player_reference = arg_33_1.video_player_reference

	if video_player_reference == _current_video_content.video_player_reference then
		return
	end

	local video_data = arg_33_1.video_data

	if not _ui_video_renderer.video_players[video_player_reference] then
		local create_video_player = UIRenderer.create_video_player
		local var_33_5 = _ui_video_renderer
		local var_33_6 = video_player_reference
		local world = _ui_video_renderer.world
		local resource = video_data.resource
		local set_loop = video_data.set_loop

		set_loop = set_loop or false

		create_video_player(var_33_5, var_33_6, world, resource, set_loop)
	end

	local var_33_10 = _ui_video_renderer.video_players[video_player_reference]
	local video_data_2 = _current_video_content.video_data

	video_data_2 = video_data_2 or tbl_3

	local sound_start = video_data.sound_start
	local sound_stop = video_data_2.sound_stop

	self:_start_video_sound(sound_start, sound_stop)
	self:_setup_subtitles(video_data.subtitle_template_settings)
	self:_enable_viewport(false)
	self:_create_skip_widget()

	self._video_widget.content.video_content = arg_33_1
	self._current_video_content = arg_33_1
	self._current_gamepad_selection_index = arg_33_2

	Managers.chat:set_chat_enabled(false)
end

CinematicsView._setup_subtitles = function (self, arg_34_1)
	-- function 34
	self._cutscene_overlay_ui = nil

	if not arg_34_1 then
		local tbl = {
			ui_renderer = self._ui_top_renderer
		}

		self._cutscene_overlay_ui = CutsceneOverlayUI:new(self, tbl)

		self._cutscene_overlay_ui:start(arg_34_1)
	end
end

CinematicsView.is_video_active = function (self, arg_35_1)
	-- function 35
	local _current_video_content = self._current_video_content

	_current_video_content = _current_video_content or tbl_3

	return arg_35_1 == _current_video_content.video_player_reference
end

CinematicsView._draw = function (self, arg_36_1, arg_36_2)
	-- function 36
	local input_service = self:input_service()
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_renderer = self._ui_renderer
	local _ui_video_renderer = self._ui_video_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")
	local _current_video_content = self._current_video_content

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, input_service, arg_36_1, nil, _render_settings)

	for i = 1, #self._widgets do
		local var_36_8 = self._widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_36_8)
	end

	if not self._exiting then
		local video_area = _ui_scenegraph.video_area
		local var_36_10 = video_area.world_position[2]
		local var_36_11 = video_area.size[2]
		local var_36_12 = _ui_scenegraph.anchor_point.world_position[2]
		local var_36_13 = self._cinematics_widgets[self._current_category_index]

		for j = 1, #var_36_13 do
			local var_36_14 = var_36_13[j]
			local num = var_36_12 - var_0_0.entry_size[2] * (j - 1)

			if not (not (num < var_36_10 + var_36_11) or not (var_36_10 < num + var_0_0.entry_size[2])) then
				UIRenderer.draw_widget(_ui_top_renderer, var_36_14)
			end
		end
	end

	UIRenderer.draw_widget(_ui_top_renderer, self._scrollbar_widget)

	if not self._in_title_screen and _current_video_content or not Managers.input:is_device_active("mouse") then
		for i_2, v in ipairs(self._button_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not _current_video_content then
		if not self._cutscene_overlay_ui then
			self._cutscene_overlay_ui:update(arg_36_1)
		end

		if not self._skip_input_ui then
			self._skip_input_ui:update(arg_36_1, arg_36_2, input_service, _render_settings)
		end

		UIRenderer.begin_pass(_ui_video_renderer, _ui_scenegraph, input_service, arg_36_1, nil, _render_settings)
		UIRenderer.draw_widget(_ui_video_renderer, self._video_widget)
		UIRenderer.end_pass(_ui_video_renderer)
	elseif not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_36_1)
	end
end
