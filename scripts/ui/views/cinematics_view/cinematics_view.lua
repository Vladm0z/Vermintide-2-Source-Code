-- chunkname: @scripts/ui/views/cinematics_view/cinematics_view.lua

local var_0_0 = local_require("scripts/ui/views/cinematics_view/cinematics_view_definitions")

require("scripts/ui/views/cinematics_view/cinematics_view_settings")
require("scripts/ui/views/cutscene_overlay_ui")
require("scripts/ui/views/skip_input_ui")

local var_0_1 = {}

CinematicsView = class(CinematicsView)

local var_0_2 = {
	"resource_packages/menu_cinematics_videos",
	"resource_packages/videos/vermintide_2_versus_trailer"
}

CinematicsView.init = function (arg_1_0, arg_1_1)
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = false
	}
	arg_1_0._in_title_screen = arg_1_1.in_title_screen

	local var_1_0 = arg_1_0._input_manager

	var_1_0:create_input_service("cinematics_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_0:map_device_to_service("cinematics_view", "keyboard")
	var_1_0:map_device_to_service("cinematics_view", "mouse")
	var_1_0:map_device_to_service("cinematics_view", "gamepad")
	arg_1_0:_reset()
end

CinematicsView._packages_loaded = function (arg_2_0)
	local var_2_0 = Managers.package

	for iter_2_0, iter_2_1 in ipairs(var_0_2) do
		if not var_2_0:has_loaded(iter_2_1, "cinematics_view") then
			return false
		end
	end

	return true
end

CinematicsView._load_packages = function (arg_3_0)
	local var_3_0 = Managers.package

	for iter_3_0, iter_3_1 in ipairs(var_0_2) do
		if not var_3_0:has_loaded(iter_3_1, "cinematics_view") then
			var_3_0:load(iter_3_1, "cinematics_view", nil, true, true)
		end
	end
end

CinematicsView._unload_packages = function (arg_4_0)
	local var_4_0 = Managers.package

	for iter_4_0, iter_4_1 in ipairs(var_0_2) do
		if var_4_0:has_loaded(iter_4_1, "cinematics_view") or var_4_0:is_loading(iter_4_1, "cinematics_view") then
			var_4_0:unload(iter_4_1, "cinematics_view", nil, true)
		end
	end
end

CinematicsView._reset = function (arg_5_0)
	arg_5_0._current_video_content = nil
	arg_5_0._current_category_index = 1
	arg_5_0._current_gamepad_selection_index = 1
	arg_5_0._exiting = false
end

CinematicsView._create_ui_elements = function (arg_6_0)
	arg_6_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_6_0 = {}
	local var_6_1 = {}

	for iter_6_0, iter_6_1 in pairs(var_0_0.widget_definitions) do
		local var_6_2 = UIWidget.init(iter_6_1)

		var_6_0[#var_6_0 + 1] = var_6_2
		var_6_1[iter_6_0] = var_6_2
	end

	arg_6_0._widgets = var_6_0
	arg_6_0._widgets_by_name = var_6_1

	arg_6_0:_destroy_video_players()

	local var_6_3 = CinematicsViewSettings
	local var_6_4 = arg_6_0._ui_top_renderer
	local var_6_5 = var_0_0.create_cinematic_entry
	local var_6_6 = {}
	local var_6_7 = {}

	for iter_6_2 = 1, #var_6_3 do
		local var_6_8 = var_6_3[iter_6_2]

		if #var_6_8 > 0 then
			local var_6_9 = {}

			for iter_6_3 = 1, #var_6_8 do
				local var_6_10 = var_6_8[iter_6_3]
				local var_6_11 = var_6_5(var_6_4, var_6_10, iter_6_3, false, arg_6_0)
				local var_6_12 = UIWidget.init(var_6_11)

				var_6_9[#var_6_9 + 1] = var_6_12
			end

			var_6_6[#var_6_6 + 1] = var_6_9

			local var_6_13 = #var_6_6
			local var_6_14 = var_6_8.category_name

			var_6_7[var_6_14] = var_6_13
			var_6_7[var_6_13] = var_6_14
		end
	end

	arg_6_0._cinematics_widgets = var_6_6
	arg_6_0._cinematics_categories_lut = var_6_7

	local var_6_15 = var_0_0.create_video_entry(arg_6_0)

	arg_6_0._video_widget = UIWidget.init(var_6_15)

	local var_6_16 = {}
	local var_6_17 = {}

	for iter_6_4, iter_6_5 in pairs(var_0_0.button_widget_definitions) do
		local var_6_18 = UIWidget.init(iter_6_5)

		var_6_16[#var_6_16 + 1] = var_6_18
		var_6_17[iter_6_4] = var_6_18
	end

	arg_6_0._button_widgets = var_6_16
	arg_6_0._button_widgets_by_name = var_6_17
	arg_6_0._ui_animations = {}
	arg_6_0._animations = {}
	arg_6_0._animation_callbacks = {}
	arg_6_0._ui_animator = UIAnimator:new(arg_6_0._ui_scenegraph, var_0_0.animation_definitions)

	local var_6_19 = arg_6_0._ui_top_renderer
	local var_6_20 = arg_6_0:input_service()
	local var_6_21 = var_0_0.generic_input_actions

	arg_6_0._menu_input_description = MenuInputDescriptionUI:new(nil, var_6_19, var_6_20, 5, 900, var_6_21.default)

	arg_6_0._menu_input_description:set_input_description(nil)
end

CinematicsView._create_scrollbar = function (arg_7_0)
	local var_7_0 = #arg_7_0._cinematics_widgets[arg_7_0._current_category_index]
	local var_7_1 = var_0_0.create_scrollbar(var_7_0)

	arg_7_0._scrollbar_widget = UIWidget.init(var_7_1)

	local var_7_2 = arg_7_0._ui_scenegraph
	local var_7_3 = var_7_0 * var_0_0.entry_size[2]
	local var_7_4 = var_7_2.video_area.size[2]

	arg_7_0._scroll_area_size = math.max(var_7_3 - var_7_4, 0)
end

CinematicsView._destroy_video_players = function (arg_8_0)
	if not arg_8_0._cinematics_widgets then
		return
	end

	local var_8_0 = arg_8_0._ui_video_renderer

	for iter_8_0 = 1, #arg_8_0._cinematics_widgets do
		local var_8_1 = arg_8_0._cinematics_widgets[iter_8_0]

		for iter_8_1 = 1, #var_8_1 do
			local var_8_2 = var_8_1[iter_8_1].content.reference_name

			if var_8_0.video_players[var_8_2] then
				local var_8_3 = var_8_0.world

				UIRenderer.destroy_video_player(var_8_0, var_8_2, var_8_3)
			end
		end
	end
end

CinematicsView.input_service = function (arg_9_0)
	return arg_9_0._input_manager:get_service("cinematics_view")
end

CinematicsView.on_enter = function (arg_10_0)
	arg_10_0._input_manager:capture_input(ALL_INPUT_METHODS, 1, "cinematics_view", "CinematicsView")
	arg_10_0:_load_packages()
	arg_10_0:_show_loading_icon()
end

CinematicsView._reset_button_states = function (arg_11_0)
	for iter_11_0, iter_11_1 in ipairs(arg_11_0._button_widgets) do
		UIWidgetUtils.reset_layout_button(iter_11_1)
	end
end

CinematicsView._show_loading_icon = function (arg_12_0)
	Managers.transition:show_loading_icon(false)
end

CinematicsView._hide_loading_icon = function (arg_13_0)
	Managers.transition:hide_loading_icon()
end

CinematicsView._create_video_renderer = function (arg_14_0)
	local var_14_0 = {
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

	for iter_14_0 = 1, #CinematicsViewSettings do
		local var_14_1 = CinematicsViewSettings[iter_14_0]

		for iter_14_1 = 1, #var_14_1 do
			local var_14_2 = var_14_1[iter_14_1].video_data

			var_14_0[#var_14_0 + 1] = "material"
			var_14_0[#var_14_0 + 1] = var_14_2.resource
		end
	end

	local var_14_3 = arg_14_0._ui_top_renderer.world

	arg_14_0._ui_video_renderer = UIRenderer.create(var_14_3, unpack(var_14_0))
end

CinematicsView._destroy_video_renderer = function (arg_15_0)
	local var_15_0 = arg_15_0._ui_top_renderer.world

	UIRenderer.destroy(arg_15_0._ui_video_renderer, var_15_0)
end

CinematicsView.initialized = function (arg_16_0)
	return arg_16_0._initialized
end

CinematicsView._init_view = function (arg_17_0)
	arg_17_0:_create_video_renderer()
	arg_17_0:_create_ui_elements()
	arg_17_0:_create_scrollbar()
	arg_17_0:_reset()
	arg_17_0:_hide_loading_icon()
	arg_17_0:_reset_button_states()
	arg_17_0:_start_animation("on_enter")

	arg_17_0._initialized = true
end

CinematicsView._start_animation = function (arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._render_settings = arg_18_0._render_settings or {
		alpha_multiplier = 0,
		snap_pixel_positions = false
	}

	local var_18_0 = {
		render_settings = arg_18_0._render_settings
	}

	arg_18_0._animations[arg_18_1] = arg_18_0._ui_animator:start_animation(arg_18_1, nil, arg_18_0._ui_scenegraph, var_18_0, 1, 0)
	arg_18_0._animation_callbacks[arg_18_1] = arg_18_2
end

CinematicsView._enable_viewport = function (arg_19_0, arg_19_1)
	if IS_WINDOWS and (GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		local var_19_0 = "inventory_preview"
		local var_19_1 = "inventory_preview_viewport"
		local var_19_2 = Managers.world:world(var_19_0)
		local var_19_3 = ScriptWorld.viewport(var_19_2, var_19_1)

		if arg_19_1 then
			ScriptWorld.activate_viewport(var_19_2, var_19_3)
			ShowCursorStack.show("CinematicsView")
		else
			ScriptWorld.deactivate_viewport(var_19_2, var_19_3)
			ShowCursorStack.hide("CinematicsView")
		end
	elseif arg_19_1 then
		ShowCursorStack.show("CinematicsView")
	else
		ShowCursorStack.hide("CinematicsView")
	end
end

CinematicsView._create_skip_widget = function (arg_20_0)
	local var_20_0 = {
		ui_renderer = arg_20_0._ui_top_renderer
	}

	arg_20_0._skip_input_ui = SkipInputUI:new(arg_20_0, var_20_0)
end

CinematicsView.on_exit = function (arg_21_0)
	arg_21_0._input_manager:release_input(ALL_INPUT_METHODS, 1, "cinematics_view", "CinematicsView")
	arg_21_0:deactivate_video()
	arg_21_0:_destroy_video_players()
	arg_21_0:_destroy_video_renderer()
	arg_21_0:_unload_packages()
	ShowCursorStack.hide("CinematicsView")

	arg_21_0._initialized = false
end

CinematicsView.do_exit = function (arg_22_0, arg_22_1)
	arg_22_0:_start_animation("on_exit", callback(arg_22_0, "exit", arg_22_1))

	arg_22_0._exiting = true

	Managers.music:trigger_event(IS_WINDOWS and "Play_console_menu_back" or "Play_console_menu_select")
end

CinematicsView.update = function (arg_23_0, arg_23_1, arg_23_2)
	if arg_23_0._packages_loaded() then
		if arg_23_0:initialized() then
			arg_23_0:_update_input(arg_23_1, arg_23_2)
			arg_23_0:_update_animations(arg_23_1, arg_23_2)
			arg_23_0:_update_video(arg_23_1, arg_23_2)
			arg_23_0:_draw(arg_23_1, arg_23_2)
		else
			arg_23_0:_init_view()
		end
	end
end

CinematicsView.current_gamepad_selection = function (arg_24_0)
	return arg_24_0._current_gamepad_selection_index
end

local var_0_3 = {}

CinematicsView._update_input = function (arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0._exiting then
		return
	end

	local var_25_0 = arg_25_0._animations.on_enter
	local var_25_1 = arg_25_0:input_service()
	local var_25_2 = Managers.input:is_device_active("gamepad")
	local var_25_3 = arg_25_0._current_video_content
	local var_25_4 = var_25_1:get("toggle_menu", true)
	local var_25_5 = var_25_1:get("back_menu", true)
	local var_25_6 = IS_WINDOWS and arg_25_0._ui_animator:is_animation_completed(var_25_0) and var_25_1:get("left_press")
	local var_25_7 = Managers.input:get_most_recent_device().any_pressed()
	local var_25_8 = arg_25_0._widgets_by_name.canvas_hotspot.content.hotspot

	if not var_25_3 and (var_25_4 or var_25_5 or not var_25_8.is_hover and var_25_6) then
		arg_25_0:do_exit()

		return
	elseif var_25_3 and arg_25_0._skip_input_ui and arg_25_0._skip_input_ui:skipped() then
		arg_25_0:deactivate_video()
	elseif var_25_1:get("confirm_press") then
		local var_25_9 = arg_25_0._current_gamepad_selection_index
		local var_25_10 = arg_25_0._cinematics_widgets[arg_25_0._current_category_index][var_25_9].content.video_content

		if var_25_10.video_player_reference ~= (var_25_3 and var_25_3.video_player_reference) then
			arg_25_0:activate_video(var_25_10, var_25_9)
		end
	end

	if not var_25_3 then
		arg_25_0:_update_scrollbar(arg_25_1, arg_25_2, var_25_1, var_25_2)
	end
end

CinematicsView._update_animations = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._ui_animations

	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		UIAnimation.update(iter_26_1, arg_26_1)

		if UIAnimation.completed(iter_26_1) then
			var_26_0[iter_26_0] = nil
		end
	end

	local var_26_1 = arg_26_0._ui_animator

	var_26_1:update(arg_26_1)

	local var_26_2 = arg_26_0._animations
	local var_26_3 = arg_26_0._animation_callbacks

	for iter_26_2, iter_26_3 in pairs(var_26_2) do
		if var_26_1:is_animation_completed(iter_26_3) then
			var_26_2[iter_26_2] = nil

			if var_26_3[iter_26_2] then
				var_26_3[iter_26_2]()

				var_26_3[iter_26_2] = nil
			end
		end
	end

	if Managers.input:is_device_active("mouse") then
		for iter_26_4, iter_26_5 in ipairs(arg_26_0._button_widgets) do
			UIWidgetUtils.animate_layout_button(iter_26_5, arg_26_1)
		end
	end
end

CinematicsView._update_scrollbar = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = arg_27_0._widgets_by_name.video_area.content.hotspot
	local var_27_1 = arg_27_0._scrollbar_widget
	local var_27_2 = var_27_1.content
	local var_27_3 = var_27_1.style
	local var_27_4 = var_27_2.hotspot
	local var_27_5 = var_27_2.scroller_hotspot
	local var_27_6 = var_27_3.scroller
	local var_27_7 = arg_27_3:get("scroll_axis")
	local var_27_8 = arg_27_3:get("cursor")
	local var_27_9 = var_27_8 and var_27_8[2] or 0

	if IS_WINDOWS and not arg_27_4 then
		var_27_9 = var_27_9 * RESOLUTION_LOOKUP.inv_scale
	end

	local var_27_10 = arg_27_0._ui_scenegraph
	local var_27_11 = var_27_10.anchor_point.local_position

	if var_27_5.on_pressed then
		arg_27_0._cursor_start_pos = var_27_9
		arg_27_0._scrollbar_start_pos = var_27_11[2]
		arg_27_0._ui_animations.scroll = nil
		var_27_5.selected = true
	elseif arg_27_0._cursor_start_pos then
		if arg_27_3:get("left_hold") then
			local var_27_12 = var_27_10.scrollbar.size[2]
			local var_27_13 = var_27_10.video_area.size[2]
			local var_27_14 = var_27_6.area_size[2]
			local var_27_15 = var_27_9
			local var_27_16 = (arg_27_0._cursor_start_pos - var_27_15) / (var_27_13 - var_27_14)

			var_27_11[2] = math.clamp(arg_27_0._scrollbar_start_pos + var_27_16 * arg_27_0._scroll_area_size, 0, arg_27_0._scroll_area_size)
		else
			arg_27_0._cursor_start_pos = nil
			arg_27_0._scrollbar_start_pos = nil
			var_27_5.selected = false
		end
	elseif var_27_4.on_pressed then
		local var_27_17 = var_27_10.video_area.world_position[2]
		local var_27_18 = var_27_10.video_area.size[2]
		local var_27_19 = var_27_6.area_size[2]
		local var_27_20 = var_27_9 - var_27_19 * 0.5
		local var_27_21 = var_27_20 - var_27_17
		local var_27_22 = 1 - var_27_21 / (var_27_18 - var_27_19)

		print(var_27_20, var_27_17, var_27_18, var_27_21, var_27_22)

		var_27_11[2] = math.clamp(arg_27_0._scroll_area_size * var_27_22, 0, arg_27_0._scroll_area_size)
	elseif var_27_0.is_hover and math.abs(var_27_7[2]) > 0 then
		local var_27_23 = 200
		local var_27_24 = var_27_11
		local var_27_25 = 2
		local var_27_26 = var_27_11[2]
		local var_27_27 = math.clamp(var_27_11[2] - var_27_7[2] * var_27_23, 0, arg_27_0._scroll_area_size)

		arg_27_0._ui_animations.scroll = UIAnimation.init(UIAnimation.function_by_time, var_27_24, var_27_25, var_27_26, var_27_27, 0.5, math.easeOutCubic)
	else
		local var_27_28 = #arg_27_0._cinematics_widgets[arg_27_0._current_category_index]
		local var_27_29 = arg_27_0._current_gamepad_selection_index

		if arg_27_3:get("move_up_hold_continuous") then
			var_27_29 = math.clamp(var_27_29 - 1, 1, var_27_28)
		elseif arg_27_3:get("move_down_hold_continuous") then
			var_27_29 = math.clamp(var_27_29 + 1, 1, var_27_28)
		end

		if var_27_29 ~= arg_27_0._current_gamepad_selection_index then
			local var_27_30 = var_0_0.entry_size[2]
			local var_27_31 = var_27_11
			local var_27_32 = 2
			local var_27_33 = var_27_11[2]
			local var_27_34 = math.clamp(var_27_30 * (var_27_29 - 1), 0, arg_27_0._scroll_area_size)

			arg_27_0._ui_animations.scroll = UIAnimation.init(UIAnimation.function_by_time, var_27_31, var_27_32, var_27_33, var_27_34, 0.5, math.easeOutCubic)
			arg_27_0._current_gamepad_selection_index = var_27_29

			arg_27_0:_play_sound("play_gui_start_menu_button_hover")
		end
	end

	local var_27_35 = var_27_10.scrollbar.size[2]
	local var_27_36 = var_27_11[2] / arg_27_0._scroll_area_size

	var_27_6.offset[2] = var_27_36 * (var_27_35 - var_27_6.area_size[2]) * -1
end

CinematicsView._update_video = function (arg_28_0)
	local var_28_0 = arg_28_0._current_video_content

	if var_28_0 then
		local var_28_1 = var_28_0.video_player_reference
		local var_28_2 = arg_28_0._ui_video_renderer.video_players[var_28_1]

		if VideoPlayer.number_of_frames(var_28_2) <= VideoPlayer.current_frame(var_28_2) then
			arg_28_0:deactivate_video()
		end
	end
end

CinematicsView.deactivate_video = function (arg_29_0)
	if arg_29_0._current_video_content then
		arg_29_0:_reset_sound()
		arg_29_0:_enable_viewport(true)

		local var_29_0 = arg_29_0._current_video_content.video_player_reference
		local var_29_1 = arg_29_0._ui_video_renderer

		if var_29_1.video_players[var_29_0] then
			local var_29_2 = var_29_1.world

			UIRenderer.destroy_video_player(var_29_1, var_29_0, var_29_2)
		end
	end

	if arg_29_0._cutscene_overlay_ui then
		arg_29_0._cutscene_overlay_ui:destroy()

		arg_29_0._cutscene_overlay_ui = nil
	end

	if arg_29_0._skip_input_ui then
		arg_29_0._skip_input_ui:destroy()

		arg_29_0._skip_input_ui = nil
	end

	arg_29_0._current_video_content = nil

	Managers.chat:set_chat_enabled(true)
end

CinematicsView._play_sound = function (arg_30_0, arg_30_1)
	if IS_WINDOWS and (GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		local var_30_0 = IS_CONSOLE and "title_screen_world" or "level_world"
		local var_30_1 = Managers.world:world(var_30_0)
		local var_30_2 = Managers.world:wwise_world(var_30_1)

		WwiseWorld.trigger_event(var_30_2, arg_30_1)
	else
		Managers.music:trigger_event(arg_30_1)
	end
end

CinematicsView._start_video_sound = function (arg_31_0, arg_31_1, arg_31_2)
	if IS_WINDOWS and (GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		arg_31_0:_play_sound("play_gui_amb_hero_screen_loop_end")
		arg_31_0:_play_sound("Play_hud_start_cinematic")

		if arg_31_2 then
			arg_31_0:_play_sound(arg_31_2)
		end
	else
		Managers.music:stop_all_sounds()
	end

	if arg_31_1 then
		arg_31_0:_play_sound(arg_31_1)
	end
end

CinematicsView._reset_sound = function (arg_32_0)
	local var_32_0 = arg_32_0._current_video_content.video_data.sound_stop

	if var_32_0 then
		arg_32_0:_play_sound(var_32_0)
	end

	arg_32_0:_play_sound(IS_CONSOLE and "Play_console_menu_music" or "Play_menu_screen_music")

	if IS_WINDOWS and (GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen")) then
		arg_32_0:_play_sound("play_gui_amb_hero_screen_loop_begin")
	end
end

CinematicsView.activate_video = function (arg_33_0, arg_33_1, arg_33_2)
	if arg_33_0._exiting then
		return
	end

	local var_33_0 = arg_33_0._current_video_content or var_0_3
	local var_33_1 = arg_33_0._ui_video_renderer
	local var_33_2 = arg_33_1.video_player_reference

	if var_33_2 == var_33_0.video_player_reference then
		return
	end

	local var_33_3 = arg_33_1.video_data

	if not var_33_1.video_players[var_33_2] then
		UIRenderer.create_video_player(var_33_1, var_33_2, var_33_1.world, var_33_3.resource, var_33_3.set_loop or false)
	end

	local var_33_4 = var_33_1.video_players[var_33_2]
	local var_33_5 = var_33_0.video_data or var_0_3
	local var_33_6 = var_33_3.sound_start
	local var_33_7 = var_33_5.sound_stop

	arg_33_0:_start_video_sound(var_33_6, var_33_7)
	arg_33_0:_setup_subtitles(var_33_3.subtitle_template_settings)
	arg_33_0:_enable_viewport(false)
	arg_33_0:_create_skip_widget()

	arg_33_0._video_widget.content.video_content = arg_33_1
	arg_33_0._current_video_content = arg_33_1
	arg_33_0._current_gamepad_selection_index = arg_33_2

	Managers.chat:set_chat_enabled(false)
end

CinematicsView._setup_subtitles = function (arg_34_0, arg_34_1)
	arg_34_0._cutscene_overlay_ui = nil

	if arg_34_1 then
		local var_34_0 = {
			ui_renderer = arg_34_0._ui_top_renderer
		}

		arg_34_0._cutscene_overlay_ui = CutsceneOverlayUI:new(arg_34_0, var_34_0)

		arg_34_0._cutscene_overlay_ui:start(arg_34_1)
	end
end

CinematicsView.is_video_active = function (arg_35_0, arg_35_1)
	return arg_35_1 == (arg_35_0._current_video_content or var_0_3).video_player_reference
end

CinematicsView._draw = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0:input_service()
	local var_36_1 = arg_36_0._ui_top_renderer
	local var_36_2 = arg_36_0._ui_renderer
	local var_36_3 = arg_36_0._ui_video_renderer
	local var_36_4 = arg_36_0._ui_scenegraph
	local var_36_5 = arg_36_0._render_settings
	local var_36_6 = Managers.input:is_device_active("gamepad")
	local var_36_7 = arg_36_0._current_video_content

	UIRenderer.begin_pass(var_36_1, var_36_4, var_36_0, arg_36_1, nil, var_36_5)

	for iter_36_0 = 1, #arg_36_0._widgets do
		local var_36_8 = arg_36_0._widgets[iter_36_0]

		UIRenderer.draw_widget(var_36_1, var_36_8)
	end

	if not arg_36_0._exiting then
		local var_36_9 = var_36_4.video_area
		local var_36_10 = var_36_9.world_position[2]
		local var_36_11 = var_36_9.size[2]
		local var_36_12 = var_36_4.anchor_point.world_position[2]
		local var_36_13 = arg_36_0._cinematics_widgets[arg_36_0._current_category_index]

		for iter_36_1 = 1, #var_36_13 do
			local var_36_14 = var_36_13[iter_36_1]
			local var_36_15 = var_36_12 - var_0_0.entry_size[2] * (iter_36_1 - 1)

			if var_36_15 < var_36_10 + var_36_11 and var_36_10 < var_36_15 + var_0_0.entry_size[2] then
				UIRenderer.draw_widget(var_36_1, var_36_14)
			end
		end
	end

	UIRenderer.draw_widget(var_36_1, arg_36_0._scrollbar_widget)

	if arg_36_0._in_title_screen and not var_36_7 and Managers.input:is_device_active("mouse") then
		for iter_36_2, iter_36_3 in ipairs(arg_36_0._button_widgets) do
			UIRenderer.draw_widget(var_36_1, iter_36_3)
		end
	end

	UIRenderer.end_pass(var_36_1)

	if var_36_7 then
		if arg_36_0._cutscene_overlay_ui then
			arg_36_0._cutscene_overlay_ui:update(arg_36_1)
		end

		if arg_36_0._skip_input_ui then
			arg_36_0._skip_input_ui:update(arg_36_1, arg_36_2, var_36_0, var_36_5)
		end

		UIRenderer.begin_pass(var_36_3, var_36_4, var_36_0, arg_36_1, nil, var_36_5)
		UIRenderer.draw_widget(var_36_3, arg_36_0._video_widget)
		UIRenderer.end_pass(var_36_3)
	elseif var_36_6 then
		arg_36_0._menu_input_description:draw(var_36_1, arg_36_1)
	end
end
