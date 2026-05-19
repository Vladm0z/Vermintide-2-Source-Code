-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_panel_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_panel_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.title_button_definitions
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = "cycle_next"
local var_0_6 = "cycle_previous"

StartGameWindowWeavePanelConsole = class(StartGameWindowWeavePanelConsole)
StartGameWindowWeavePanelConsole.NAME = "StartGameWindowWeavePanelConsole"

function StartGameWindowWeavePanelConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowWeavePanelConsole")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui = var_1_0.ingame_ui
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._layout_settings = arg_1_1.layout_settings
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_setup_input_buttons()
end

function StartGameWindowWeavePanelConsole._create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)
	arg_2_0._widgets, arg_2_0._widgets_by_name = UIUtils.create_widgets(var_0_1)

	local var_2_0 = {}
	local var_2_1 = arg_2_0._layout_settings.window_layouts
	local var_2_2 = "game_option"
	local var_2_3 = var_0_3[var_2_2].size
	local var_2_4 = 28
	local var_2_5 = "center"
	local var_2_6 = {
		upper_case = true,
		localize = true,
		dynamic_font_size = true,
		word_wrap = false,
		font_type = "hell_shark_header",
		font_size = var_2_4
	}
	local var_2_7 = arg_2_0._parent
	local var_2_8 = 0

	for iter_2_0, iter_2_1 in ipairs(var_2_1) do
		if iter_2_1.panel_sorting and var_2_7:can_add_layout(iter_2_1) then
			local var_2_9 = iter_2_1.name
			local var_2_10 = iter_2_1.display_name or "n/a"
			local var_2_11 = arg_2_0:_get_text_width(var_2_6, var_2_10)
			local var_2_12 = {
				math.min(var_2_11 + 40, 400),
				var_2_3[2]
			}
			local var_2_13 = {
				var_2_8,
				0,
				0
			}
			local var_2_14 = UIWidgets.create_weave_panel_button(var_2_2, var_2_12, var_2_10, var_2_4, var_2_13, var_2_5)

			var_2_8 = var_2_8 + var_2_12[1]

			local var_2_15 = UIWidget.init(var_2_14)

			arg_2_0:_set_text_button_size(var_2_15, var_2_12[1])

			var_2_15.content.layout_name = var_2_9
			var_2_0[#var_2_0 + 1] = var_2_15
		end
	end

	arg_2_0._ui_scenegraph.panel_entry_area.size[1] = var_2_8
	arg_2_0._title_button_widgets = var_2_0

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_4)
end

function StartGameWindowWeavePanelConsole.on_exit(arg_3_0, arg_3_1)
	print("[StartGameWindow] Exit Substate StartGameWindowWeavePanelConsole")

	arg_3_0._ui_animator = nil
end

function StartGameWindowWeavePanelConsole.update(arg_4_0, arg_4_1, arg_4_2)
	if DO_RELOAD then
		arg_4_0:_create_ui_elements()
	end

	arg_4_0:_handle_gamepad_activity()
	arg_4_0:_update_selected_option()
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_draw(arg_4_1)
end

function StartGameWindowWeavePanelConsole.post_update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
end

function StartGameWindowWeavePanelConsole._update_animations(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ui_animations
	local var_6_1 = arg_6_0._animations
	local var_6_2 = arg_6_0._ui_animator

	for iter_6_0, iter_6_1 in pairs(arg_6_0._ui_animations) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			arg_6_0._ui_animations[iter_6_0] = nil
		end
	end

	var_6_2:update(arg_6_1)

	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		if var_6_2:is_animation_completed(iter_6_3) then
			var_6_2:stop_animation(iter_6_3)

			var_6_1[iter_6_2] = nil
		end
	end

	local var_6_3 = arg_6_0._title_button_widgets

	for iter_6_4, iter_6_5 in ipairs(var_6_3) do
		arg_6_0:_animate_title_entry(iter_6_5, arg_6_1)
	end

	arg_6_0:_update_panel_selection_animation(arg_6_1)
end

function StartGameWindowWeavePanelConsole._is_button_pressed(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content
	local var_7_1 = var_7_0.button_hotspot or var_7_0.button_text

	if var_7_1.on_release then
		var_7_1.on_release = false

		return true
	end
end

function StartGameWindowWeavePanelConsole._is_stepper_button_pressed(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.content
	local var_8_1 = var_8_0.button_hotspot_left
	local var_8_2 = var_8_0.button_hotspot_right

	if var_8_1.on_release then
		var_8_1.on_release = false

		return true, -1
	elseif var_8_2.on_release then
		var_8_2.on_release = false

		return true, 1
	end
end

function StartGameWindowWeavePanelConsole._is_button_hover_enter(arg_9_0, arg_9_1)
	return arg_9_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowWeavePanelConsole._is_button_hover_exit(arg_10_0, arg_10_1)
	return arg_10_1.content.button_hotspot.on_hover_exit
end

function StartGameWindowWeavePanelConsole._is_button_selected(arg_11_0, arg_11_1)
	return arg_11_1.content.button_hotspot.is_selected
end

function StartGameWindowWeavePanelConsole._handle_input(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._parent
	local var_12_1 = arg_12_0._widgets_by_name
	local var_12_2 = arg_12_0._parent:window_input_service()
	local var_12_3 = false
	local var_12_4 = arg_12_0._title_button_widgets
	local var_12_5 = #var_12_4

	for iter_12_0, iter_12_1 in ipairs(var_12_4) do
		if not iter_12_1.content.button_hotspot.is_selected then
			if arg_12_0:_is_button_hover_enter(iter_12_1) then
				arg_12_0:_play_sound("Play_hud_store_button_hover_category")
			end

			if arg_12_0:_is_button_pressed(iter_12_1) then
				arg_12_0:_on_panel_button_selected(iter_12_0)

				var_12_3 = true
			end
		end
	end

	if not var_12_3 then
		local var_12_6 = arg_12_0._selected_index or 1
		local var_12_7 = #var_12_4

		if var_12_2:get(var_0_6) then
			local var_12_8 = var_12_6 > 1 and var_12_6 - 1 or var_12_7

			arg_12_0:_on_panel_button_selected(var_12_8)
		elseif var_12_2:get(var_0_5) then
			local var_12_9 = var_12_6 % var_12_7 + 1

			arg_12_0:_on_panel_button_selected(var_12_9)
		end
	end
end

function StartGameWindowWeavePanelConsole._on_panel_button_selected(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._parent
	local var_13_1 = arg_13_0._title_button_widgets[arg_13_1].content.layout_name

	print("_on_panel_button_selected", arg_13_1, var_13_1)
	var_13_0:set_layout_by_name(var_13_1)
end

function StartGameWindowWeavePanelConsole._set_selected_option(arg_14_0, arg_14_1)
	arg_14_0:_start_panel_selection_animation(arg_14_0._selected_index, arg_14_1)

	local var_14_0 = arg_14_0._title_button_widgets

	for iter_14_0, iter_14_1 in ipairs(var_14_0) do
		iter_14_1.content.button_hotspot.is_selected = iter_14_0 == arg_14_1
	end
end

function StartGameWindowWeavePanelConsole._update_selected_option(arg_15_0)
	local var_15_0 = arg_15_0._parent:get_selected_layout_name()

	if var_15_0 then
		local var_15_1 = arg_15_0._title_button_widgets

		for iter_15_0, iter_15_1 in ipairs(var_15_1) do
			if iter_15_1.content.layout_name == var_15_0 and iter_15_0 ~= arg_15_0._selected_index then
				arg_15_0:_set_selected_option(iter_15_0)

				arg_15_0._selected_index = iter_15_0
			end
		end
	end
end

function StartGameWindowWeavePanelConsole._draw(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._ui_renderer
	local var_16_1 = arg_16_0._ui_top_renderer
	local var_16_2 = arg_16_0._ui_scenegraph
	local var_16_3 = arg_16_0._parent:window_input_service()
	local var_16_4 = arg_16_0._render_settings

	UIRenderer.begin_pass(var_16_1, var_16_2, var_16_3, arg_16_1, nil, var_16_4)

	for iter_16_0, iter_16_1 in ipairs(arg_16_0._widgets) do
		UIRenderer.draw_widget(var_16_1, iter_16_1)
	end

	for iter_16_2, iter_16_3 in ipairs(arg_16_0._title_button_widgets) do
		UIRenderer.draw_widget(var_16_1, iter_16_3)
	end

	UIRenderer.end_pass(var_16_1)
end

function StartGameWindowWeavePanelConsole._play_sound(arg_17_0, arg_17_1)
	arg_17_0._parent:play_sound(arg_17_1)
end

function StartGameWindowWeavePanelConsole._setup_input_buttons(arg_18_0)
	local var_18_0 = arg_18_0._parent:window_input_service()
	local var_18_1 = UISettings.get_gamepad_input_texture_data(var_18_0, var_0_6, true)
	local var_18_2 = UISettings.get_gamepad_input_texture_data(var_18_0, var_0_5, true)
	local var_18_3 = arg_18_0._widgets_by_name
	local var_18_4 = var_18_3.panel_input_area_1
	local var_18_5 = var_18_3.panel_input_area_2
	local var_18_6 = var_18_4.style.texture_id

	var_18_6.horizontal_alignment = "center"
	var_18_6.vertical_alignment = "center"
	var_18_6.texture_size = {
		var_18_1.size[1],
		var_18_1.size[2]
	}
	var_18_4.content.texture_id = var_18_1.texture

	local var_18_7 = var_18_5.style.texture_id

	var_18_7.horizontal_alignment = "center"
	var_18_7.vertical_alignment = "center"
	var_18_7.texture_size = {
		var_18_2.size[1],
		var_18_2.size[2]
	}
	var_18_5.content.texture_id = var_18_2.texture
end

function StartGameWindowWeavePanelConsole._handle_gamepad_activity(arg_19_0)
	local var_19_0 = Managers.input:is_device_active("gamepad")
	local var_19_1 = Managers.input:get_most_recent_device()
	local var_19_2 = arg_19_0.gamepad_active_last_frame == nil or var_19_0 and var_19_1 ~= arg_19_0._most_recent_device

	if var_19_0 then
		if not arg_19_0.gamepad_active_last_frame or var_19_2 then
			arg_19_0.gamepad_active_last_frame = true

			local var_19_3 = arg_19_0._widgets_by_name

			var_19_3.panel_input_area_1.content.visible = true
			var_19_3.panel_input_area_2.content.visible = true

			arg_19_0:_setup_input_buttons()
		end
	elseif arg_19_0.gamepad_active_last_frame or var_19_2 then
		arg_19_0.gamepad_active_last_frame = false

		local var_19_4 = arg_19_0._widgets_by_name

		var_19_4.panel_input_area_1.content.visible = false
		var_19_4.panel_input_area_2.content.visible = false
	end

	arg_19_0._most_recent_device = var_19_1
end

function StartGameWindowWeavePanelConsole._set_text_button_size(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0._ui_scenegraph[arg_20_1.scenegraph_id].size[1] = arg_20_2

	local var_20_0 = arg_20_1.style
	local var_20_1 = 5
	local var_20_2 = arg_20_2 - var_20_1 * 2

	var_20_0.text.size[1] = var_20_2
	var_20_0.text_shadow.size[1] = var_20_2
	var_20_0.text_hover.size[1] = var_20_2
	var_20_0.text_disabled.size[1] = var_20_2
	var_20_0.text.offset[1] = var_20_0.text.default_offset[1] + var_20_1
	var_20_0.text_shadow.offset[1] = var_20_0.text_shadow.default_offset[1] + var_20_1
	var_20_0.text_hover.offset[1] = var_20_0.text_hover.default_offset[1] + var_20_1
	var_20_0.text_disabled.offset[1] = var_20_0.text_disabled.default_offset[1] + var_20_1
end

function StartGameWindowWeavePanelConsole._get_text_width(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_1.localize then
		arg_21_2 = Localize(arg_21_2)
	end

	if arg_21_1.upper_case then
		arg_21_2 = TextToUpper(arg_21_2)
	end

	local var_21_0 = arg_21_0._ui_renderer
	local var_21_1, var_21_2 = UIFontByResolution(arg_21_1)
	local var_21_3, var_21_4, var_21_5 = UIRenderer.text_size(var_21_0, arg_21_2, var_21_1[1], var_21_2)

	return var_21_3
end

function StartGameWindowWeavePanelConsole._set_text_button_horizontal_position(arg_22_0, arg_22_1, arg_22_2)
	arg_22_1.offset[1] = arg_22_2
end

function StartGameWindowWeavePanelConsole._animate_title_entry(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_1.content
	local var_23_1 = arg_23_1.style
	local var_23_2 = var_23_0.button_hotspot
	local var_23_3 = var_23_2.is_hover
	local var_23_4 = var_23_2.is_selected
	local var_23_5 = not var_23_4 and var_23_2.is_clicked and var_23_2.is_clicked == 0
	local var_23_6 = var_23_2.input_progress or 0
	local var_23_7 = var_23_2.hover_progress or 0
	local var_23_8 = var_23_2.selection_progress or 0
	local var_23_9 = 8
	local var_23_10 = 20

	if var_23_5 then
		var_23_6 = math.min(var_23_6 + arg_23_2 * var_23_10, 1)
	else
		var_23_6 = math.max(var_23_6 - arg_23_2 * var_23_10, 0)
	end

	local var_23_11 = math.easeOutCubic(var_23_6)
	local var_23_12 = math.easeInCubic(var_23_6)

	if var_23_3 then
		var_23_7 = math.min(var_23_7 + arg_23_2 * var_23_9, 1)
	else
		var_23_7 = math.max(var_23_7 - arg_23_2 * var_23_9, 0)
	end

	local var_23_13 = math.easeOutCubic(var_23_7)
	local var_23_14 = math.easeInCubic(var_23_7)

	if var_23_4 then
		var_23_8 = math.min(var_23_8 + arg_23_2 * var_23_9, 1)
	else
		var_23_8 = math.max(var_23_8 - arg_23_2 * var_23_9, 0)
	end

	local var_23_15 = math.easeOutCubic(var_23_8)
	local var_23_16 = math.easeInCubic(var_23_8)
	local var_23_17 = math.max(var_23_7, var_23_8)
	local var_23_18 = math.max(var_23_15, var_23_13)
	local var_23_19 = math.max(var_23_14, var_23_16)
	local var_23_20 = 255 * var_23_17

	if var_23_1.text then
		local var_23_21 = 1 * var_23_17

		var_23_1.text.offset[2] = -(2 + var_23_21)
		var_23_1.text_shadow.offset[2] = -(4 + var_23_21)
		var_23_1.text_hover.offset[2] = -(2 + var_23_21)
		var_23_1.text_disabled.offset[2] = -(2 + var_23_21)
	end

	if var_23_1.new_marker then
		local var_23_22 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

		var_23_1.new_marker.color[1] = 100 + 155 * var_23_22
	end

	var_23_2.hover_progress = var_23_7
	var_23_2.input_progress = var_23_6
	var_23_2.selection_progress = var_23_8
end

function StartGameWindowWeavePanelConsole._start_panel_selection_animation(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._widgets_by_name.entry_panel_selection
	local var_24_1 = var_24_0.offset
	local var_24_2 = var_24_0.content.size
	local var_24_3 = arg_24_0._panel_selection_animation or {}

	arg_24_0._panel_selection_animation = var_24_3

	local var_24_4 = var_24_1[1]
	local var_24_5 = var_24_2[1]
	local var_24_6 = arg_24_0._title_button_widgets[arg_24_2].offset[1]
	local var_24_7 = arg_24_0._title_button_widgets[arg_24_2].content.size[1]
	local var_24_8 = 0.3

	var_24_3.duration = var_24_8
	var_24_3.total_duration = var_24_8
	var_24_3.target_offset = var_24_6
	var_24_3.start_offset = var_24_4
	var_24_3.target_width = var_24_7
	var_24_3.start_width = var_24_5
end

function StartGameWindowWeavePanelConsole._update_panel_selection_animation(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._panel_selection_animation

	if not var_25_0 then
		return
	end

	local var_25_1 = var_25_0.duration

	if not var_25_1 then
		return
	end

	local var_25_2 = math.max(var_25_1 - arg_25_1, 0)
	local var_25_3 = var_25_0.start_offset
	local var_25_4 = var_25_0.target_offset
	local var_25_5 = var_25_0.start_width
	local var_25_6 = var_25_0.target_width
	local var_25_7 = 1 - var_25_2 / var_25_0.total_duration
	local var_25_8 = math.easeOutCubic(var_25_7)
	local var_25_9 = var_25_5 + (var_25_6 - var_25_5) * var_25_8
	local var_25_10 = var_25_3 + (var_25_4 - var_25_3) * var_25_8
	local var_25_11 = arg_25_0._widgets_by_name.entry_panel_selection
	local var_25_12 = var_25_11.style.write_mask.texture_size
	local var_25_13 = var_25_11.content.size
	local var_25_14 = var_25_11.scenegraph_id

	var_25_13[1] = var_25_9
	var_25_12[1] = var_25_9 * 2
	arg_25_0._ui_scenegraph[var_25_14].size[1] = var_25_9
	var_25_11.offset[1] = var_25_10

	if var_25_2 == 0 then
		var_25_0.duration = nil
	else
		var_25_0.duration = var_25_2
	end
end
