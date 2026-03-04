-- chunkname: @scripts/ui/views/title_main_ui.win32.lua

require("scripts/ui/ui_animations")
local_require("scripts/ui/views/menu_information_slate_ui")

local var_0_0 = local_require("scripts/ui/views/title_main_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.background_widget_definitions
local var_0_3 = var_0_0.single_widget_definitions
local var_0_4 = var_0_0.widget_definitions
local var_0_5 = var_0_0.menu_videos
local var_0_6 = var_0_0.create_menu_button_func
local var_0_7 = var_0_0.legal_texts
local var_0_8 = var_0_0.animation_definitions
local var_0_9 = var_0_0.create_sub_logo_func
local var_0_10 = true
local var_0_11 = "TitleMainUI_ATTRACTMODE"

TitleMainUI = class(TitleMainUI)

TitleMainUI.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._disable_input = false
	arg_1_0._menu_hierarchy = {}
	arg_1_0._menu_option_widgets = {}
	arg_1_0._breadcrumbs = {}

	arg_1_0:_create_ui_renderer()
	arg_1_0:_setup_input()
	arg_1_0:_create_ui_elements()
	arg_1_0:_init_animations()
end

TitleMainUI._start_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings,
		ui_scenegraph = arg_2_0._ui_scenegraph
	}
	local var_2_1 = arg_2_0._background_widgets
	local var_2_2 = arg_2_0._animations[arg_2_1]

	if var_2_2 then
		arg_2_0._ui_animator:stop_animation(var_2_2)
	end

	local var_2_3 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_3
end

TitleMainUI._create_ui_renderer = function (arg_3_0)
	local var_3_0 = {
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

	for iter_3_0, iter_3_1 in pairs(var_0_5) do
		var_3_0[#var_3_0 + 1] = "material"
		var_3_0[#var_3_0 + 1] = iter_3_1.video_name
	end

	for iter_3_2, iter_3_3 in pairs(DLCSettings) do
		local var_3_1 = iter_3_3.ui_materials

		if var_3_1 then
			for iter_3_4, iter_3_5 in ipairs(var_3_1) do
				var_3_0[#var_3_0 + 1] = "material"
				var_3_0[#var_3_0 + 1] = iter_3_5
			end
		end
	end

	arg_3_0._ui_renderer = UIRenderer.create(arg_3_0._world, unpack(var_3_0))

	UISetupFontHeights(arg_3_0._ui_renderer.gui)
end

TitleMainUI._setup_input = function (arg_4_0)
	arg_4_0._input_manager = Managers.input

	arg_4_0._input_manager:create_input_service("main_menu", "TitleScreenKeyMaps", "TitleScreenFilters")
	arg_4_0._input_manager:map_device_to_service("main_menu", "gamepad")
	arg_4_0._input_manager:map_device_to_service("main_menu", "keyboard")
	arg_4_0._input_manager:map_device_to_service("main_menu", "mouse")
end

TitleMainUI._play_sound = function (arg_5_0, arg_5_1)
	return Managers.music:trigger_event(arg_5_1)
end

TitleMainUI.get_ui_renderer = function (arg_6_0)
	return arg_6_0._ui_renderer
end

TitleMainUI._init_animations = function (arg_7_0)
	arg_7_0._menu_item_animations = {}
	arg_7_0._ui_animations = {}
	arg_7_0._ui_animation_callbacks = {}
	arg_7_0._animations = {}
	arg_7_0._ui_animator = UIAnimator:new(arg_7_0._ui_scenegraph, var_0_8)
end

TitleMainUI._create_ui_elements = function (arg_8_0)
	arg_8_0._alpha_multiplier = 1
	arg_8_0._disabled_buttons = {}
	arg_8_0._current_menu_widgets = {}
	arg_8_0._menu_item_animations = {}
	arg_8_0._current_menu_index = nil
	arg_8_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	arg_8_0:_create_videos()

	arg_8_0._background_widgets = {}

	for iter_8_0, iter_8_1 in pairs(var_0_2) do
		arg_8_0._background_widgets[iter_8_0] = UIWidget.init(iter_8_1)
	end

	arg_8_0._engage_prompt = UIWidget.init(var_0_3.create_engage_prompt(arg_8_0._ui_renderer))
	arg_8_0._information_text = UIWidget.init(var_0_3.information_text)
	arg_8_0._information_text.style.text.localize = false
	arg_8_0._info_slate_widget = UIWidget.init(var_0_3.info_slate)
	arg_8_0._game_type_tag_widget = UIWidget.init(var_0_3.game_type)
	arg_8_0._game_type_description_widget = UIWidget.init(var_0_3.game_type_description)
	arg_8_0._menu_selection_left = UIWidget.init(var_0_3.start_screen_selection_left)
	arg_8_0._menu_selection_right = UIWidget.init(var_0_3.start_screen_selection_right)
	arg_8_0._logo_widget = UIWidget.init(var_0_3.logo)

	arg_8_0:_setup_legal_texts()
	UIRenderer.clear_scenegraph_queue(arg_8_0._ui_renderer)

	var_0_10 = false
end

TitleMainUI._setup_legal_texts = function (arg_9_0)
	local var_9_0 = UIWidget.init(var_0_3.legal_text)
	local var_9_1 = var_9_0.style.text

	var_9_1.localize = false
	var_9_1.vertical_alignment = "bottom"

	local var_9_2 = ""

	for iter_9_0, iter_9_1 in ipairs(var_0_7) do
		var_9_2 = var_9_2 .. "\n" .. Localize(iter_9_1)
	end

	var_9_0.content.text = var_9_2
	arg_9_0._legal_text = var_9_0
end

TitleMainUI._create_menu_option_widget = function (arg_10_0, arg_10_1, arg_10_2)
	for iter_10_0, iter_10_1 in ipairs(arg_10_1) do
		local var_10_0 = iter_10_1.text
		local var_10_1 = iter_10_1.callback
		local var_10_2 = iter_10_1.conditional_func
		local var_10_3 = iter_10_1.layout
		local var_10_4 = #arg_10_2 + 1

		if not var_10_2 or var_10_2() then
			local var_10_5 = "menu_option_" .. var_10_4
			local var_10_6 = var_0_6(var_10_5, var_10_0, var_10_1, iter_10_1)

			arg_10_2[var_10_4] = UIWidget.init(var_10_6)

			if var_10_3 then
				arg_10_2.sub_menu = arg_10_2.sub_menu or {}
				arg_10_2.sub_menu[var_10_4] = {}

				local var_10_7 = arg_10_2.sub_menu[var_10_4]

				arg_10_0:_create_menu_option_widget(var_10_3, var_10_7)

				local var_10_8 = #var_10_7 + 1
				local var_10_9 = callback(arg_10_0, "_go_back")
				local var_10_10 = "menu_option_" .. var_10_8
				local var_10_11 = var_0_6(var_10_10, "back_menu_button_name", var_10_9)

				var_10_7[var_10_8] = UIWidget.init(var_10_11)
			end
		end
	end
end

TitleMainUI.create_menu_options = function (arg_11_0, arg_11_1)
	table.clear(arg_11_0._menu_hierarchy)
	arg_11_0:_create_menu_option_widget(arg_11_1, arg_11_0._menu_hierarchy)

	arg_11_0._current_menu_widgets = arg_11_0._menu_hierarchy
end

TitleMainUI._update_animations = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._animations
	local var_12_1 = arg_12_0._ui_animations
	local var_12_2 = arg_12_0._ui_animation_callbacks
	local var_12_3 = arg_12_0._ui_animator
	local var_12_4 = arg_12_0._menu_item_animations

	for iter_12_0, iter_12_1 in pairs(var_12_1) do
		UIAnimation.update(iter_12_1, arg_12_1)

		if UIAnimation.completed(iter_12_1) then
			var_12_1[iter_12_0] = nil

			local var_12_5 = var_12_2[iter_12_0]

			if var_12_5 then
				var_12_5()

				var_12_2[iter_12_0] = nil
			end
		end
	end

	for iter_12_2, iter_12_3 in pairs(var_12_4) do
		arg_12_0[iter_12_3.func](arg_12_0, iter_12_3, iter_12_2, arg_12_1)
	end

	var_12_3:update(arg_12_1)

	for iter_12_4, iter_12_5 in pairs(var_12_0) do
		if var_12_3:is_animation_completed(iter_12_5) then
			var_12_3:stop_animation(iter_12_5)

			var_12_0[iter_12_4] = nil
		end
	end
end

TitleMainUI.update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if var_0_10 then
		arg_13_0:_create_ui_elements()
		arg_13_0:_init_animations()
	end

	arg_13_0:_update_information_text(arg_13_1, arg_13_2)
	arg_13_0:_update_input(arg_13_1, arg_13_2, arg_13_3)
	arg_13_0:_update_animations(arg_13_1)
	arg_13_0:_draw(arg_13_1, arg_13_2, arg_13_3)
end

TitleMainUI._update_information_text = function (arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0._show_menu then
		local var_14_0 = Managers.backend and Managers.backend:get_current_api_call()

		if var_14_0 and Managers.localizer:exists(var_14_0) then
			local var_14_1 = arg_14_0._information_text.content

			if var_14_1.text ~= var_14_0 then
				var_14_1.text = Localize(var_14_0)
			end
		end
	end
end

TitleMainUI._destroy_video_players = function (arg_15_0)
	if arg_15_0._video_widgets then
		for iter_15_0, iter_15_1 in pairs(arg_15_0._video_widgets) do
			local var_15_0 = iter_15_1.content.video_content.video_player

			if var_15_0 then
				World.destroy_video_player(arg_15_0._world, var_15_0)
			end
		end

		arg_15_0._video_widgets = nil
		arg_15_0._active_video = nil
	end
end

TitleMainUI._change_video = function (arg_16_0, arg_16_1)
	if arg_16_1 == arg_16_0._active_video_widget_name then
		return
	end

	World.remove_video_player(arg_16_0._world, arg_16_0._active_video_widget.content.video_content.video_player)

	arg_16_0._active_video_widget = arg_16_0._video_widgets[arg_16_1]
	arg_16_0._active_video_widget_name = arg_16_1

	World.add_video_player(arg_16_0._world, arg_16_0._active_video_widget.content.video_content.video_player)
	arg_16_0:_start_animation("video_fade_in")
end

TitleMainUI._create_videos = function (arg_17_0)
	arg_17_0:_destroy_video_players()

	arg_17_0._video_widgets = {}

	for iter_17_0, iter_17_1 in pairs(var_0_5) do
		local var_17_0 = World.create_video_player(arg_17_0._world, iter_17_1.video_name, true, false)
		local var_17_1 = UIWidget.init(UIWidgets.create_splash_video(iter_17_1))

		var_17_1.content.video_content.video_player = var_17_0
		arg_17_0._video_widgets[iter_17_0] = var_17_1
	end

	arg_17_0._active_video_widget = arg_17_0._video_widgets.main

	World.add_video_player(arg_17_0._world, arg_17_0._active_video_widget.content.video_content.video_player)
end

TitleMainUI._draw_video = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._ui_renderer
	local var_18_1 = arg_18_0._ui_scenegraph
	local var_18_2 = arg_18_0._input_manager:get_service("main_menu")
	local var_18_3 = arg_18_0._render_settings

	var_18_3.alpha_multiplier = arg_18_0._alpha_multiplier

	UIRenderer.begin_pass(var_18_0, var_18_1, var_18_2, arg_18_1, nil, var_18_3)
	UIRenderer.draw_widget(var_18_0, arg_18_0._active_video_widget)
	UIRenderer.end_pass(var_18_0)

	var_18_3.alpha_multiplier = nil
end

TitleMainUI._go_back = function (arg_19_0)
	arg_19_0:_play_sound("Play_console_menu_back")

	local var_19_0 = arg_19_0._current_menu_index
	local var_19_1 = arg_19_0._breadcrumbs

	var_19_1[#var_19_1] = nil

	local var_19_2 = arg_19_0._menu_hierarchy

	for iter_19_0 = 1, #var_19_1 do
		local var_19_3 = var_19_1[iter_19_0]

		var_19_2 = var_19_2.sub_menu[var_19_3]
	end

	if var_19_2 then
		table.clear(arg_19_0._menu_item_animations)
		arg_19_0:anim_deselect_button(nil, var_19_0, nil, 0)

		arg_19_0._current_menu_widgets = var_19_2
		arg_19_0._current_menu_index = nil
		var_19_0 = 1
	end

	arg_19_0:_update_selection(var_19_0)

	return true
end

local function var_0_12()
	return
end

TitleMainUI._activate_menu_widget = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._current_menu_index

	if (arg_21_0._current_menu_widgets[arg_21_1].content.callback or var_0_12)() then
		return
	else
		local var_21_1 = arg_21_0._breadcrumbs
		local var_21_2 = arg_21_0._menu_hierarchy

		for iter_21_0 = 1, #var_21_1 do
			local var_21_3 = var_21_1[iter_21_0]

			var_21_2 = var_21_2.sub_menu[var_21_3]
		end

		local var_21_4 = var_21_2.sub_menu and var_21_2.sub_menu[arg_21_1]

		if var_21_4 then
			table.clear(arg_21_0._menu_item_animations)
			arg_21_0:anim_deselect_button(nil, var_21_0, nil, 0)

			var_21_1[#var_21_1 + 1] = arg_21_1
			arg_21_0._current_menu_widgets = var_21_4
			arg_21_0._current_menu_index = nil
			var_21_0 = 1

			arg_21_0:_play_sound("Play_console_menu_select")
		end
	end

	return var_21_0
end

TitleMainUI._update_mouse_input = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0._current_menu_index or 1
	local var_22_1 = arg_22_0._current_menu_widgets[var_22_0].content
	local var_22_2 = arg_22_0._breadcrumbs
	local var_22_3

	for iter_22_0, iter_22_1 in ipairs(arg_22_0._current_menu_widgets) do
		if UIUtils.is_button_pressed(iter_22_1, "button_text") then
			var_22_0 = arg_22_0:_activate_menu_widget(iter_22_0)
		elseif UIUtils.is_button_hover_enter(iter_22_1, "button_text") then
			var_22_0 = iter_22_0

			arg_22_0:_play_sound("play_gui_inventory_item_hover")
		end
	end

	if not table.is_empty(var_22_2) and arg_22_3:get("back", true) then
		return arg_22_0:_go_back()
	end

	arg_22_0:_update_selection(var_22_0)
end

TitleMainUI._update_gamepad_input = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0._current_menu_index or 1
	local var_23_1 = arg_23_0._current_menu_widgets[var_23_0].content
	local var_23_2 = arg_23_0._breadcrumbs

	if arg_23_3:get("up") then
		var_23_0 = math.clamp(var_23_0 - 1, 1, #arg_23_0._current_menu_widgets)

		arg_23_0:_play_sound("play_gui_inventory_item_hover")
	elseif arg_23_3:get("down") then
		var_23_0 = math.clamp(var_23_0 + 1, 1, #arg_23_0._current_menu_widgets)

		arg_23_0:_play_sound("play_gui_inventory_item_hover")
	elseif arg_23_3:get("start", true) then
		var_23_0 = arg_23_0:_activate_menu_widget(var_23_0)
	elseif not table.is_empty(var_23_2) and arg_23_3:get("back", true) then
		return arg_23_0:_go_back()
	end

	arg_23_0:_update_selection(var_23_0)
end

TitleMainUI._update_selection = function (arg_24_0, arg_24_1)
	if arg_24_1 and arg_24_1 ~= arg_24_0._current_menu_index then
		if arg_24_0._current_menu_index then
			arg_24_0:_add_menu_item_animation(arg_24_0._current_menu_index, "anim_deselect_button")
		end

		arg_24_0:_add_menu_item_animation(arg_24_1, "anim_select_button")

		arg_24_0._current_menu_index = arg_24_1

		local var_24_0 = arg_24_0._current_menu_widgets[arg_24_0._current_menu_index]

		if var_24_0 then
			arg_24_0:_populate_additional_data(var_24_0)
		end
	end
end

local var_0_13 = {}

TitleMainUI._populate_additional_data = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1.content.menu_option_data or var_0_13
	local var_25_1 = var_25_0.tag
	local var_25_2 = var_25_0.logo_texture
	local var_25_3 = var_25_0.description
	local var_25_4 = var_25_0.info_slate
	local var_25_5 = var_25_0.video or "main_menu"

	arg_25_0._info_slate_widget.content.text = var_25_4
	arg_25_0._game_type_tag_widget.content.text = var_25_1
	arg_25_0._game_type_description_widget.content.text = var_25_3
	arg_25_0._sub_logo_widget = var_25_2 and UIWidget.init(var_0_9(var_25_2)) or nil

	arg_25_0:_change_video(var_25_5)
end

TitleMainUI._update_input = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if arg_26_0._disable_input then
		return
	end

	if not arg_26_0._show_menu then
		return
	end

	if arg_26_3 or arg_26_0._frame_anim_id then
		return
	end

	if table.is_empty(arg_26_0._current_menu_widgets) then
		return
	end

	local var_26_0 = arg_26_0._input_manager:get_service("main_menu")

	if Managers.input:is_device_active("mouse") then
		arg_26_0:_update_mouse_input(arg_26_1, arg_26_2, var_26_0)
	else
		arg_26_0:_update_gamepad_input(arg_26_1, arg_26_2, var_26_0)
	end
end

TitleMainUI._draw_menu_background = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	UIRenderer.begin_pass(arg_27_3, arg_27_4, arg_27_5, arg_27_1, nil, arg_27_6)

	for iter_27_0, iter_27_1 in pairs(arg_27_0._background_widgets) do
		UIRenderer.draw_widget(arg_27_3, iter_27_1)
	end

	local var_27_0 = arg_27_6.alpha_multiplier or 1

	arg_27_6.alpha_multiplier = arg_27_0._alpha_multiplier

	UIRenderer.draw_widget(arg_27_3, arg_27_0._logo_widget)

	arg_27_6.alpha_multiplier = var_27_0

	UIRenderer.end_pass(arg_27_3)
end

TitleMainUI._draw_menu = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	if not arg_28_0._show_menu then
		return
	end

	local var_28_0 = {
		alpha_multiplier = arg_28_0._alpha_multiplier
	}

	UIRenderer.begin_pass(arg_28_3, arg_28_4, arg_28_5, arg_28_1, nil, var_28_0)

	for iter_28_0, iter_28_1 in ipairs(arg_28_0._current_menu_widgets) do
		UIRenderer.draw_widget(arg_28_3, iter_28_1)
	end

	if arg_28_0._current_menu_index then
		UIRenderer.draw_widget(arg_28_3, arg_28_0._menu_selection_left)
		UIRenderer.draw_widget(arg_28_3, arg_28_0._menu_selection_right)
	end

	UIRenderer.draw_widget(arg_28_3, arg_28_0._info_slate_widget)
	UIRenderer.draw_widget(arg_28_3, arg_28_0._game_type_tag_widget)
	UIRenderer.draw_widget(arg_28_3, arg_28_0._game_type_description_widget)

	if arg_28_0._sub_logo_widget then
		UIRenderer.draw_widget(arg_28_3, arg_28_0._sub_logo_widget)
	end

	UIRenderer.end_pass(arg_28_3)
end

TitleMainUI._draw_engage_screen = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	UIRenderer.begin_pass(arg_29_3, arg_29_4, arg_29_5, arg_29_1, nil, arg_29_0._render_settings)

	if not arg_29_0._show_menu then
		UIRenderer.draw_widget(arg_29_3, arg_29_0._legal_text)
	end

	if arg_29_0._has_engaged then
		if arg_29_0._draw_information_text then
			UIRenderer.draw_widget(arg_29_3, arg_29_0._information_text)
		end
	else
		UIRenderer.draw_widget(arg_29_3, arg_29_0._engage_prompt)
	end

	UIRenderer.end_pass(arg_29_3)
end

TitleMainUI._draw = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = arg_30_0._ui_renderer
	local var_30_1 = arg_30_0._ui_scenegraph
	local var_30_2 = arg_30_0._input_manager:get_service("main_menu")
	local var_30_3 = arg_30_0._render_settings

	arg_30_0:_draw_menu_background(arg_30_1, arg_30_2, var_30_0, var_30_1, var_30_2, var_30_3)
	arg_30_0:_draw_video(arg_30_1, arg_30_2)

	if arg_30_0._show_menu and arg_30_0._information_slate_ui then
		arg_30_0._information_slate_ui:update(arg_30_1, arg_30_2)
	end

	if arg_30_3 then
		return
	end

	arg_30_0:_draw_engage_screen(arg_30_1, arg_30_2, var_30_0, var_30_1, var_30_2, var_30_3)
	arg_30_0:_draw_menu(arg_30_1, arg_30_2, var_30_0, var_30_1, var_30_2)
end

TitleMainUI.destroy = function (arg_31_0)
	if arg_31_0._information_slate_ui then
		arg_31_0._information_slate_ui:destroy()
	end

	GarbageLeakDetector.register_object(arg_31_0, "TitleMainUI")
	UIRenderer.destroy(arg_31_0._ui_renderer, arg_31_0._world)
	arg_31_0:_destroy_video_players()
end

TitleMainUI.should_start = function (arg_32_0)
	return arg_32_0._has_engaged
end

TitleMainUI.show_menu = function (arg_33_0, arg_33_1)
	if arg_33_1 then
		arg_33_0:_play_sound("Play_console_menu_start")
		arg_33_0:_change_video("main_menu")

		arg_33_0._ui_animations.sidebar = UIAnimation.init(UIAnimation.function_by_time, arg_33_0._ui_scenegraph.sidebar.position, 1, -544, 0, 0.5, math.easeCubic)
		arg_33_0._ui_animations.alpha_multiplier = UIAnimation.init(UIAnimation.function_by_time, arg_33_0, "_alpha_multiplier", 0, 1, 0.5, math.easeCubic)
		arg_33_0._draw_information_text = false

		arg_33_0._ui_animation_callbacks.alpha_multiplier = function ()
			local var_34_0 = Managers.input:get_service("main_menu")

			arg_33_0._information_slate_ui = MenuInformationSlateUI:new(arg_33_0._ui_renderer, var_34_0)
		end
	else
		local var_33_0 = arg_33_0._current_menu_index

		if var_33_0 then
			arg_33_0:anim_deselect_button(nil, var_33_0, nil, 0)

			arg_33_0._current_menu_index = nil
			arg_33_0._menu_item_animations[var_33_0] = nil
		end

		arg_33_0:_play_sound("Play_console_menu_back")
		arg_33_0:_change_video("main")

		arg_33_0._ui_scenegraph.sidebar.size[1] = 544
		arg_33_0._ui_scenegraph.sidebar.position[1] = -800
		arg_33_0._information_slate_ui = nil

		table.clear(arg_33_0._ui_animations)
		table.clear(arg_33_0._ui_animation_callbacks)
		table.clear(arg_33_0._breadcrumbs)
	end

	arg_33_0._show_menu = arg_33_1
	arg_33_0._is_in_sub_menu = false
	arg_33_0._current_menu_widgets = arg_33_0._menu_hierarchy
end

TitleMainUI.set_start_pressed = function (arg_35_0, arg_35_1)
	if arg_35_0._has_engaged ~= arg_35_1 then
		if arg_35_1 then
			arg_35_0._ui_animations.legal_text_fade = UIAnimation.init(UIAnimation.function_by_time, arg_35_0._legal_text.style.text.text_color, 1, 255, 0, 0.2, math.easeCubic)
			arg_35_0._ui_animations.information_text_fade = UIAnimation.init(UIAnimation.function_by_time, arg_35_0._information_text.style.text.text_color, 1, 0, 255, 0.5, math.easeCubic)
		else
			arg_35_0._ui_animations.legal_text_fade = UIAnimation.init(UIAnimation.function_by_time, arg_35_0._legal_text.style.text.text_color, 1, 0, 255, 0.5, math.easeCubic)
			arg_35_0._ui_animations.information_text_fade = UIAnimation.init(UIAnimation.function_by_time, arg_35_0._information_text.style.text.text_color, 1, 255, 0, 0.2, math.easeCubic)
			arg_35_0._draw_information_text = nil
		end
	end

	arg_35_0._has_engaged = arg_35_1
end

local var_0_14 = 0.2
local var_0_15 = 0.2

TitleMainUI.anim_select_button = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	if arg_36_1.progress == 1 then
		return
	end

	arg_36_1.timer = arg_36_1.timer or arg_36_1.progress * var_0_14
	arg_36_1.timer = arg_36_1.timer + arg_36_3
	arg_36_1.progress = math.clamp(arg_36_1.timer / var_0_14, 0, 1)

	local var_36_0 = arg_36_0._current_menu_widgets[arg_36_2]
	local var_36_1 = var_36_0.content.disabled
	local var_36_2 = var_36_1 and Colors.color_definitions.gray or Colors.color_definitions.font_title
	local var_36_3 = var_36_1 and Colors.color_definitions.gray or Colors.color_definitions.white

	if var_36_0.style.text then
		var_36_0.style.text.text_color[2] = math.lerp(var_36_2[2], var_36_3[2], math.smoothstep(arg_36_1.progress, 0, 1))
		var_36_0.style.text.text_color[3] = math.lerp(var_36_2[3], var_36_3[3], math.smoothstep(arg_36_1.progress, 0, 1))
		var_36_0.style.text.text_color[4] = math.lerp(var_36_2[4], var_36_3[4], math.smoothstep(arg_36_1.progress, 0, 1))
		var_36_0.style.text.font_size = math.lerp(var_36_0.style.text.font_size, var_36_0.content.default_font_size + 10, math.easeInCubic(arg_36_1.progress))
	end

	local var_36_4 = var_36_0.scenegraph_id
	local var_36_5 = arg_36_0._ui_scenegraph

	var_36_5.selection_anchor.local_position[2] = var_36_5[var_36_4].local_position[2] + 5

	local var_36_6 = var_36_0.style
	local var_36_7 = var_36_0.content.text_field

	if var_36_7 then
		local var_36_8 = 20

		var_36_8 = var_36_0.content.spacing or var_36_8

		local var_36_9, var_36_10 = arg_36_0:_get_word_wrap_size(Localize(var_36_7), var_36_6.text, 1000)

		var_36_5.selection_anchor.size[1] = (var_36_9 or 0) + var_36_8
		arg_36_0._menu_selection_left.offset[1] = math.lerp(-50, 0, math.smoothstep(arg_36_1.progress, 0, 1))
		arg_36_0._menu_selection_right.offset[1] = math.lerp(50, 0, math.smoothstep(arg_36_1.progress, 0, 1))
	end
end

TitleMainUI.anim_deselect_button = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	if arg_37_1 and arg_37_1.progress == 0 then
		return
	end

	local var_37_0 = 0

	if not arg_37_4 then
		arg_37_1.timer = arg_37_1.timer or arg_37_1.progress * var_0_15
		arg_37_1.timer = arg_37_1.timer - arg_37_3
		arg_37_1.progress = math.clamp(arg_37_1.timer / var_0_15, 0, 1)
		var_37_0 = arg_37_1.progress
	else
		var_37_0 = arg_37_4
	end

	local var_37_1 = arg_37_0._current_menu_widgets[arg_37_2]
	local var_37_2 = var_37_1 and var_37_1.content.disabled
	local var_37_3 = var_37_2 and Colors.color_definitions.gray or Colors.color_definitions.font_title
	local var_37_4 = var_37_2 and Colors.color_definitions.gray or Colors.color_definitions.white

	if var_37_1 and var_37_1.style.text then
		var_37_1.style.text.text_color[2] = math.lerp(var_37_3[2], var_37_4[2], math.smoothstep(var_37_0, 0, 1))
		var_37_1.style.text.text_color[3] = math.lerp(var_37_3[3], var_37_4[3], math.smoothstep(var_37_0, 0, 1))
		var_37_1.style.text.text_color[4] = math.lerp(var_37_3[4], var_37_4[4], math.smoothstep(var_37_0, 0, 1))
	end

	if var_37_1 and var_37_1.style.text then
		if arg_37_4 then
			var_37_1.style.text.font_size = var_37_1.content.default_font_size * (1 - var_37_0)
		else
			var_37_1.style.text.font_size = math.lerp(var_37_1.style.text.font_size, var_37_1.content.default_font_size, math.easeInCubic(var_37_0))
		end
	end
end

TitleMainUI._get_text_size = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0, var_38_1 = UIFontByResolution(arg_38_2)
	local var_38_2, var_38_3, var_38_4 = UIRenderer.text_size(arg_38_0._ui_renderer, arg_38_1, var_38_0[1], var_38_1)

	return var_38_2, var_38_3
end

TitleMainUI._get_word_wrap_size = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0, var_39_1 = UIFontByResolution(arg_39_2)
	local var_39_2 = UIRenderer.word_wrap(arg_39_0._ui_renderer, arg_39_1, var_39_0[1], var_39_1, arg_39_3)
	local var_39_3, var_39_4 = arg_39_0:_get_text_size(arg_39_1, arg_39_2)

	return var_39_3, var_39_4 * #var_39_2
end

TitleMainUI._add_menu_item_animation = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	arg_40_0._menu_item_animations[arg_40_1] = {
		progress = arg_40_0._menu_item_animations[arg_40_1] and arg_40_0._menu_item_animations[arg_40_1].progress or 0,
		func = arg_40_2
	}
end

TitleMainUI.set_information_text = function (arg_41_0, arg_41_1)
	arg_41_0._draw_information_text = true

	local var_41_0 = arg_41_0._information_text
	local var_41_1 = var_41_0.content
	local var_41_2 = var_41_0.style

	if not arg_41_1 then
		var_41_1.text = Localize("state_info")
	else
		var_41_1.text = arg_41_1
	end
end

TitleMainUI.disable_input = function (arg_42_0, arg_42_1)
	arg_42_0._disable_input = arg_42_1
end

TitleMainUI.view_activated = function (arg_43_0, arg_43_1)
	if arg_43_1 then
		arg_43_0._ui_animations.sidebar = UIAnimation.init(UIAnimation.function_by_time, arg_43_0._ui_scenegraph.sidebar.size, 1, 544, 1920, 0.5, math.easeCubic)
		arg_43_0._ui_animations.alpha_multiplier = UIAnimation.init(UIAnimation.function_by_time, arg_43_0, "_alpha_multiplier", 1, 0, 0.5, math.easeCubic)

		if arg_43_0._information_slate_ui then
			arg_43_0._information_slate_ui:hide()
		end
	else
		arg_43_0._ui_animations.sidebar = UIAnimation.init(UIAnimation.function_by_time, arg_43_0._ui_scenegraph.sidebar.size, 1, 1920, 544, 0.5, math.easeCubic)
		arg_43_0._ui_animations.alpha_multiplier = UIAnimation.init(UIAnimation.function_by_time, arg_43_0, "_alpha_multiplier", 0, 1, 0.5, math.easeCubic)

		if arg_43_0._information_slate_ui then
			arg_43_0._information_slate_ui:show()
		end
	end
end
